hmac: hmac.ml digest.ml md5.ml sha.ml
	ocamlfind ocamlc -package hex -package integers -linkpkg -g -o hmac md5.ml sha.ml digest.ml hmac.ml

#digest: digest.ml md5.ml sha.ml
#	ocamlfind ocamlc -package hex -package integers -linkpkg -g -o digest md5.ml sha.ml digest.ml

clean:
	rm *.cm* hmac
