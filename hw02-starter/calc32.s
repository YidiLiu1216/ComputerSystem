.global main
.text
/*
i386
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
  cmp  $4, 8(%ebp)
  jne  fault_info  //if argc !=4 - > return

  mov 12(%ebp), %ebx
  mov 4(%ebx), %eax
  push %eax
  call atol       // atol(argv[1]) - > a   
  mov %eax, %esi
  mov 12(%ebx), %eax
  push %eax
  call atol      // atol(argv[3]) - > b
  mov %eax, %edi
  

  mov 8(%ebx), %eax
  mov (%eax), %ebx  //argv[2] - > op

  cmpb $'+', %bl  // if op in {‘+’,’-’,’*’,’/’}
  je add_info
  cmpb $'-', %bl
  je sub_info
  cmpb $'*', %bl
  je mul_info
  cmpb $'/', %bl
  je div_info
  jmp fault_info //else print the usage information
 //c=a+b
 add_info:
  push %edi
  add %esi, %edi
  mov %edi, %eax
  pop %edi
  jmp result_info
//c=a-b
 sub_info:
  push %esi
  sub %edi, %esi
  mov %esi, %eax
  pop %esi
  jmp result_info
//c=a*b
 mul_info:
  push %edi
  imul %esi, %edi
  mov %edi, %eax
  pop %edi
  jmp result_info
//c=a/b
 div_info:
  mov $0, %edx
  mov %esi, %eax
  idiv %edi
  jmp result_info
 result_info:
   push %eax
   push %edi
   push %ebx
   push %esi
   push $output_fmt
   call printf
   leave
   ret
 fault_info:
  mov  $fault_fmt,%edi
  push %edi
  call printf
  leave
  ret
.data
output_fmt: .string "%ld %c %ld = %ld\n"
fault_fmt: .string "Usage ./calc32 N op N\n"
