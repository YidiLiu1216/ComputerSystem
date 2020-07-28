
#include <stdio.h>
#include <stdlib.h>

/*
 calculate f(x)=f(x-1)+f(x-2)
 input: x
 return 0,1 while x=0,1
 else call two recursive function to get fib(x)=fib(x-1)+fib(x-2)
*/

int
fib(long x){
  if(x<=1){
   return x;
  }
  return fib(x-1)+fib(x-2);
}

/*
 the main function to calculate 
 f(x)=f(x-1)+f(x-2)
 require input:
 ./fib64 n
*/

int
main(int argc, char* argv[])
{
    if (argc!=2){
      printf("Usage: ./fib N, where N>=0");
      return -1;
    }	
    long xx = atol(argv[1]);
    if(xx<0){
     printf("Usage: ./fib N, where N>=0");
     return -1;
    }
    long yy=fib(xx);
    printf("fib(%ld) = %ld\n", xx,yy);
    return 0;
}

