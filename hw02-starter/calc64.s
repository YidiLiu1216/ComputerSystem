.global main
.text
/*
amd64
this program do basic calculate on numbers:
ex. c= a + b
    c= a – b
    c= a * b
    c= a / b
*/
/* the main function 
   input: argv[1] - > a
          argv[2] - > op
          argv[3] - > b
   output: c =  a op b
*/
 
main:
 enter $0, $0
  cmp  $4, %rdi
  jne  fault_info //if argc !=4 - > return

  mov 8(%rsi), %rdi
  push %rsi
  call atol
  pop %rsi        // atol(argv[1]) - > a    
  mov %rax,%r12
  mov 24(%rsi), %rdi
  push %rsi
  call atol
  pop %rsi  
  mov %rax,%r13  // atol(argv[3]) - > b

  mov 16(%rsi),%rcx
  mov (%rcx),%rbx  //argv[2] - > op

  cmp $43,%bl  // if op in {‘+’,’-’,’*’,’/’}
  je add_info
  cmp $45,%bl
  je dec_info
  cmp $42,%bl
  je mul_info
  cmp $47,%bl
  je div_info
  jmp fault_info //else print the usage information
add_info:
  push %r13
  add %r12, %r13
  mov %r13, %rax //c=a+b
  pop %r13
  jmp output_info
dec_info:
  push %r12
  sub %r13, %r12
  mov %r12, %rax //c=a-b
  pop %r12
  jmp output_info
mul_info:
  push %r13
  imul %r12, %r13 //c=a*b
  mov %r13, %rax
  pop %r13
  jmp output_info
div_info:
  mov  %r12, %rax //c=a/b
  idiv %r13
  jmp output_info
output_info:
  mov %r12, %rsi  // a
  mov %rbx, %rdx  // op
  mov %r13, %rcx  // b
  mov %rax, %r8   // c 
  mov $output_fmt, %rdi
  mov $0, %al
  call printf
  leave
  ret
fault_info:
  mov  $fault_fmt, %rdi
  mov  $0, %al
  call printf
  leave
  ret
.data
output_fmt: .string "%ld %c %ld = %ld\n"
fault_fmt: .string "Usage ./calc64 N op N\n"
