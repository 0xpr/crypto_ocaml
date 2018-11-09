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

OCaml doesn't seem to be really suited to writing imperative code, I resorted to using Arrays and for loops extensively in the AES implementation and the code feels rather unnatural.

---
