let digest_block_size = 64
let input_block_size = 56

open Unsigned.UInt32

module Byte = struct
  include Bytes
  let g_ b i = of_int32 (Int32.of_int (Char.code (get b i)))
  let s_ b i v black_magic = set b i (Char.chr v)
  let print_byte b =
    let char_seq = Bytes.to_seq b in
    Printf.printf "0x";
    Seq.iter (fun c -> Printf.printf "%.2x" (Char.code c)) char_seq;
    Printf.printf "\n"
end

let digest_hash input len hash block_operate block_finalize =
  let padded_block = Byte.create digest_block_size in
  let length_in_bits = !len * 8 in
  let in_off = ref 0 in
  while (!len >= input_block_size) do
    if (!len < digest_block_size) then begin
      Byte.fill padded_block 0 digest_block_size (Char.chr 0x00);
      Byte.blit input !in_off padded_block 0 !len;
      Byte.set padded_block !len (Char.chr 0x80);
      block_operate padded_block hash;
      in_off := !in_off + !len;
      len := -1
    end
    else begin
      block_operate (Byte.sub input !in_off digest_block_size) hash;
      in_off := !in_off + digest_block_size;
      len := !len - digest_block_size
    end
  done;
  Byte.fill padded_block 0 digest_block_size (Char.chr 0x00);
  if (!len >= 0) then begin
    Byte.blit input !in_off padded_block 0 !len;
    Byte.set padded_block !len (Char.chr 0x80);
  end;
  block_finalize padded_block length_in_bits;
  block_operate padded_block hash

type endian = Little | Big

let int32_to_bytes n endian =
  let byte_1 = shift_right (logand n (of_int 0xff000000)) 24 in
  let byte_2 = shift_right (logand n (of_int 0x00ff0000)) 16 in
  let byte_3 = shift_right (logand n (of_int 0x0000ff00)) 8 in
  let byte_4 = logand n (of_int 0x000000ff) in
  let byte = Byte.create 4 in
  let () = match endian with
  | Big ->
    Byte.set byte 0 (Char.chr (to_int byte_1));
    Byte.set byte 1 (Char.chr (to_int byte_2));
    Byte.set byte 2 (Char.chr (to_int byte_3));
    Byte.set byte 3 (Char.chr (to_int byte_4))
  | Little ->
    Byte.set byte 0 (Char.chr (to_int byte_4));
    Byte.set byte 1 (Char.chr (to_int byte_3));
    Byte.set byte 2 (Char.chr (to_int byte_2));
    Byte.set byte 3 (Char.chr (to_int byte_1))
  in
  byte

let display_hash hash hash_len endian =
  let output = Byte.create (4 * hash_len) in
  for i = 0 to (hash_len - 1) do
    let byte = int32_to_bytes hash.(i) endian in
    Byte.blit byte 0 output (i * 4) 4
  done;
  Byte.print_byte output

let () =
  let algo = Sys.argv.(1) in
  let input = Sys.argv.(2) in
  let len = String.length input in
  let m_input =
    if input.[0] = '0' && input.[1] = 'x' then
      Hex.to_string (Hex.(`Hex (String.sub input 2 (len - 2))))
    else
      input
  in
  let input_len = ref (String.length m_input) in
  if algo = "-sha1" then begin
    let hash = Array.make Sha.sha1_result_size zero in
    List.iteri (fun i elem -> hash.(i) <- elem) Sha.sha1_initial_hash;
    digest_hash (Byte.of_string m_input) input_len hash Sha.sha1_block_operate Sha.sha_finalize;
    display_hash hash Sha.sha1_result_size Big
  end else if algo = "-sha256" then begin
    let hash = Array.make Sha.sha256_result_size zero in
    List.iteri (fun i elem -> hash.(i) <- elem) Sha.sha256_initial_hash;
    digest_hash (Byte.of_string m_input) input_len hash Sha.sha256_block_operate Sha.sha_finalize;
    display_hash hash Sha.sha256_result_size Big
  end else if algo = "-md5" then begin
    let hash = Array.make Md5.md5_result_size zero in
    List.iteri (fun i elem -> hash.(i) <- elem) Md5.md5_initial_hash;
    digest_hash (Byte.of_string m_input) input_len hash Md5.md5_block_operate Md5.md5_finalize;
    display_hash hash Md5.md5_result_size Little
  end else begin
    print_string "usage :: ./digest [-sha1 | -sha256 | -md5 ] input"
  end
