    .global main
    .text
//print out the usage text by using syscall
usageinfo:
enter $0, $0

mov $4, %eax  //write
mov $1, %ebx
mov $usage_msg, %ecx
mov $27, %edx
int $0x80 //syscall

mov $1, %eax 
mov $1, %ebx
int $0x80  //exit(1)

leave
ret

//print and exit whilt fail to open file
failopeninfo:
  enter $0, $0

  mov $4, %eax
  mov $1, %ebx
  mov $failopen_msg, %ecx
  mov $22, %edx // the length of text
  int $0x80
  
  mov $1, %eax 
  mov $1, %ebx
  int $0x80  //exit(1)
  leave
  ret
// exit while syscall fail
failsyscall:
  mov $1, %eax 
  mov $1, %ebx
  int $0x80  //exit(1)

//this part sort the array and write it back into outputfile
//  using insertsort
sort:
  /*16(%ebp) *array[size]
    12(%ebp) size
    8(%ebp) outputfile
    esi: I
    ecx: size
    edi : j
    (%esp): key
  */
  enter $4,$0
    push %esi
   
    mov 12(%ebp), %eax
    mov $0, %edx
    mov $4, %ecx
    idiv %ecx
    mov %eax, %ecx
    mov $0,%esi // i=0,i<size;i++
    jmp outloop
outloop:
    cmp %ecx,%esi
    jge outdone

    mov 16(%ebp), %eax
    mov (%eax,%esi,4), %edx
    mov %edx, (%esp) //key = array[i]
    mov %esi, %edi //j=i-1
    dec %edi
inloop:
    cmp $0, %edi// while j>-1 and array[j]>key
    jl indone
    mov (%esp), %edx
    mov 16(%ebp), %eax
    cmp %edx, (%eax,%edi,4)
    jl indone
            
    mov (%eax,%edi,4),%edx
    mov %edx,4(%eax,%edi,4)             // array[j+1]=array[j]   
    jmp innext
innext:
    dec %edi
    jmp inloop
indone:
    jmp outnext
outnext:
    mov 16(%ebp), %eax
    mov (%esp), %edx
    mov %edx, 4(%eax,%edi,4) //array[j+1]=key

    inc %esi
    jmp outloop
outdone:

    mov $5, %eax  //open
    mov 8(%ebp), %ebx
    mov $65, %ecx  //O_WRONLY|O_CREATE
    mov $0644, %edx //setmode
    int $0x80
    cmp $0, %eax
    jl failopeninfo 
    mov %eax, %edi

    mov $4, %eax //write
    mov %edi, %ebx
    mov 16(%ebp), %ecx
    mov 12(%ebp), %edx
    int $0x80
    cmp $-1,%eax
    je failsyscall
  pop %esi
  leave
  ret
main:
/* 0(%esp) inputfile name and *array[size]
   0(%edp) filesize
   
*/
    enter $148, $0 
    
    cmp $3, 8(%ebp)
    jne usageinfo

    mov 12(%ebp), %ebx
    mov 4(%ebx), %eax
    mov 8(%ebx), %esi
    mov %eax, %ebx
    mov %ebx, 0(%esp)
    mov $5, %eax //open
    mov $0, %ecx
    mov $0, %edx
    int $0x80

    cmp $0, %eax
    jl failopeninfo
    mov %eax, %edi // inputfile fd

    mov $106, %eax
    mov 0(%esp), %ebx 
    lea 8(%esp), %ecx
    int $0x80   //call stat
    cmp $-1,%eax
    je failsyscall

    mov 28(%esp), %eax //size in 4(%esp)
    mov %eax,(%ebp)
    sub 28(%esp), %esp //allocate space
  
    mov $3,%eax  //read(inpurfile,read_buff,size)
    mov %edi,%ebx
    lea (%esp), %ecx
    mov 0(%ebp), %edx
    int $0x80
    cmp $-1,%eax
    je failsyscall

    mov $6, %eax
    mov %edi, %ebx// close inputfile release %edi
    int $0x80
    cmp $-1,%eax
    je failsyscall

    lea (%esp), %eax
    push %eax
    push (%ebp)
    push %esi

    call sort

    mov $0, %eax
    leave
    ret
.data
usage_msg:  .string "Usage: ./sort input output\n"
failopen_msg:  .string "Fail to open the file\n"


