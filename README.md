This is OCaml code for the book [Implementing SSL/TLS Using Cryptography and PKI](https://www.amazon.com/Implementing-SSL-TLS-Using-Cryptography/dp/0470920416/).

---

### WARNING
 
The book's introduction itself says:

> There isn’t any bounds-checking on buffers or verification that the input matches what’s expected, which are things that a proper library ought to be doing. I’ve omitted these things to keep this book’s (already long) page count under control, as well as to avoid obscuring the purpose of the example code with hundreds of lines of error checking.

Note that my OCaml code has even less error checking than the book -- I skip all the tedious error checking because it does not have educational value.


---

### Ch 01 | Understanding Internet Security

- skipped proxy authorization in http client implementation
- there is some bizzare bug (at the end of the response, duplicate packets seem to be written by the `display result` function.
- for some reason "www.google.com" doesn't work, there has to be path along with a hostname. This seems to be an issue with how the GET request is being constructed (even the C implementation of the book suffers from this issue).

Since my primary objective is to get a high-level understanding of TLS works, I'm not addressing the above shortcomings.

---

### Ch 02 | Protecting Against Eavesdroppers

- skipped 3DES implementation
- skipped padding (leaving this up to the caller)
- RC4 has some other minor improvements which I've skipped

OCaml doesn't seem to be really suited to writing imperative code, I resorted to using Arrays and for loops extensively in the AES implementation and the code feels rather unnatural.

---

### Ch 03 | Secure Key Exchange over an Insecure Medium with Public Key Cryptography
- skipped padding checks for RSA implementation (Somewhat shockingly, my code worked on the first try!)
- Elliptic Curves for Diffie-Hellman don't seem to be implmented with huge numbers, so I don't think it's going to be used for the library. Perhaps it will come later.

Elliptic Curves are amazing. There are several properties of the cyclic group formed a curve that I'm not fully clear on -- but the math is not particularly complex, elementary group theory is all that is required. Also I'm using the Zarith library from opam (which itself uses GMP) instead of implementing my own arbitrary precision integer arithmetic library like the book does. I am somewhat baffled by the book's choice to do this though.

---

### Ch 04 | Authenticating Communications Using Digital Signatures
- sha256 initial hash given in the book is in little endian. The book's C implementation converts all the initial hashes to little endian format, but we don't need to this for the OCaml implemntation.
- skipped the digest function which makes the code generic for md5, sha1, and sha256 algorithms
