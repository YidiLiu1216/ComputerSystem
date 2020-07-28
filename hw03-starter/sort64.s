    .global main
    .text
//print out the usage text by using syscall
usageinfo:
  enter $0, $0

  mov $1, %rdi
  mov $usage_msg, %rsi
  mov $27, %rdx // the length of text
  mov $1, %rax //write
  syscall
  
  mov $1, %rdi
  mov $60, %rax //exit(1)
  syscall

  leave
  ret

//print and exit whilt fail to open file
failopeninfo:
  enter $0, $0

  mov $1, %rdi
  mov $failopen_msg, %rsi
  mov $22, %rdx // the length of text
  mov $1, %rax //write
  syscall
  
  mov $1, %rdi
  mov $60, %rax //exit(1)
  syscall
  leave
  ret

failsyscall:
  mov $1, %rdi
  mov $60, %rax
  syscall //exit(1)
/*the sort and write function, based on insert sort
input:
%rdi: nums[size] - >r13
%rsi: size - > r14
%rdx: outputfile →r15
%r12: i
%rbx: j
%rcx: key
*/
sort:
  enter $0,$0
  push %rbx
  push %rcx
  push %r12
  push %r13
  push %r14
  push %r15   
  
  mov %rdi, %r13
  mov %rsi, %r14
  mov %rdx, %r15
  
  mov $0,%rdx
  mov %r14, %rax
  mov $4, %rcx
  idiv %rcx
  mov %rax, %r14
  mov $0,%r12   //i=0;i<size;i++
outloop:
  cmp %r14, %r12
  jge outloopdone
  mov (%r13,%r12,4),%ecx//key = array[i]
  mov %r12, %rbx
  dec %rbx            //j=i-1
  jmp innerloop
innerloop:
  cmp $0, %rbx       //while(j>-1 && inputarray[j]>key)
  jl innerdone
  cmp %ecx,(%r13,%rbx,4)
  jl innerdone
  mov (%r13,%rbx,4),%eax  //array[j+1]=array[j]
  mov %eax,4(%r13,%rbx,4)
  jmp innernext
innernext:
   dec %rbx         //j=j-1
   jmp innerloop
innerdone:
   
   mov %ecx,4(%r13,%rbx,4) //array[j+1]=key
  jmp outloopnext
outloopnext:
  // mov %r11,(%r13,%r12,4)
  //mov %r11,4(%r13,%rbx,4)//array[j+1]=key
  inc %r12
  jmp outloop
outloopdone:
  mov $4,%rax
  imul %r14
  mov %rax,%r14

  mov %r15,%rdi
  mov %r13,%rsi
  mov %r14,%rdx
  mov $1, %rax  //write
  syscall
  cmp $-1,%rax
  je failsyscall

  pop %rbx
  pop %rcx
  pop %r12
  pop %r15
  pop %r14
  pop %r13
  leave
  ret
main:
    /*
    %r12 :readin file
    %r13 :output file
    %r14 :array size
    */
    enter $145, $0 //144 for stat buffer
                    //4000 for maximum read or write buffer
    
    cmp $3,%rdi
    jne usageinfo  //check if argc==3

    mov 16(%rsi),%r13

    mov 8(%rsi),%rdi
    mov $0, %rsi //O_RONLY
    mov $0, %rdx
    mov $2, %rax //open
    syscall
    mov %rax, %r12
    cmp $0, %r12
    jle failopeninfo

    mov $4,%rax //stat
    lea 0(%rsp),%rsi// leave the space for stat struct
    syscall
    cmp $-1,%rax
    je failsyscall

    mov 48(%rsp), %r14 //find stat.st_size
    sub 48(%rsp), %rsp// allocate space
    mov %r12, %rdi
    lea 144(%rsp),%rsi
    mov %r14,%rdx
    mov $0, %rax
    syscall
    cmp $-1,%rax
    je failsyscall

    mov %rax, %r14

    mov %r12, %rdi //close the readin file
    mov $3, %rax //syscall 3 is close

    mov %r13,%rdi
    mov $65, %rsi //O_WRONLY|O_CREAT
    mov $0644, %rdx 
    mov $2, %rax //open
    syscall
    mov %rax, %r13
    cmp $0, %r13
    jle failopeninfo
    
    lea 144(%rsp), %rdi
    mov %r14, %rsi
    mov %r13, %rdx 
    call sort

    mov $0, %rax  
    leave
    ret
.data
usage_msg:  .string "Usage: ./sort input output\n"
failopen_msg:  .string "Fail to open the file\n"

