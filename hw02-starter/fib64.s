  .global main

  .text
// the amd64 fibnoacci number porgram


/*
the main function to calculate 
f(x)=f(x-1)+f(x-2)
require input:
./fib64 n
*/

main:
  enter $0, $0

  cmp $2, %rdi    //if (argc!=2)
  jne fault_info

  mov 8(%rsi), %rdi
  call atol       //long xx = atol(argv[1])
  cmp $0, %rax
  jl fault_info
  
  mov %rax, %rdi  //long yy=fib(xx)
  mov %rax, %r15
  call fib

  mov %r15, %rsi
  mov %rax, %rdx
  mov $output_fmt, %rdi //printf("fib(%ld) = %ld\n", xx,yy)
  mov $0, %al
  call printf

  leave
  ret

/*
calculate f(x)=f(x-1)+f(x-2)
input: x
return 0,1 while x=0,1
else call two recursive function to get fib(x)=fib(x-1)+fib(x-2)
*/

fib:
  enter $0,$0
  push %r12
  push %r13  
  
  mov %rdi,%r12
  cmp $1,%r12
  jle fib_done//if(x<=1){
               //  return x;
               //    }
   
  dec %r12
  mov %r12, %r13
  mov %r13, %rdi  // fib(x-1)
  
  call fib
  mov %rax, %r12
  
  dec %r13
  mov %r13, %rdi
  call fib
  mov %rax, %r13 // fib(x-2)

  add %r13,%r12  // return fib(x-1)+fib(x-2)
  jmp fib_done  
  
fib_done:
  mov %r12,%rax
  pop %r13 
  pop %r12
  leave
  ret
fault_info:

  mov $fault_fmt, %rdi
  mov $0, %al
  call printf  

  leave
  ret
  .data
output_fmt:  .string "fib(%ld) = %ld\n"
fault_fmt: .string "Usage ./fib64 N, Where N >= 0\n"
