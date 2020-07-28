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

    mov 8(%ebp), %ecx //x=argc
    cmp $2,%ecx       //if(argc !=2 )
    jne fault_info
    
    mov 12(%ebp),%ecx
    mov 4(%ecx), %ebx // x=atol(argv[1])
    push %ebx
    call atoi
    mov %eax, %ebx 
    cmp $0, %ebx
    jl fault_info
    
    push %ebx
    call fib  //long yy=fib(xx)
    pop %ebx

    push %eax
    push %ebx
    push $output_fmt //printf("fib(%ld) = %ld\n", xx,yy)
    call printf
    add $12, %esp

    leave
    ret
fault_info:
   push $fault_fmt
   call printf
   add $4, %esp
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
   
   mov 8(%ebp),%ebx
   cmp $1, %ebx  //if(x<=1){return x;}
   jle fib_done

   dec %ebx
   mov %ebx,%edi
   push %edi
   push %ebx
   call fib     // fib(x-1)
   pop %ebx
   pop %edi
   mov %eax, %ebx

   dec %edi
   push %ebx
   push %edi
   call fib    // fib(x-2)
   pop %edi
   pop %ebx
   mov %eax,%edi
   add %edi,%ebx // return fib(x-1)+fib(x-2)
   jmp fib_done
fib_done:
   mov %ebx, %eax
   pop %edi
   pop %ebx
   leave
   ret
    .data
fault_fmt: .string "Usage ./fib64 N,where N >=0\n"
output_fmt:  .string "fib(%ld) = %ld\n"
