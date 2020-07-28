.global cube
.text
cube:
 enter $0,$0
 mov %rdi,%r9
 imul %r9,%r9
 imul %rdi,%r9
 mov %r9,%rax
 leave
 ret
