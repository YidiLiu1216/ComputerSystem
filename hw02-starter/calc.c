#include<stdio.h>
#include<stdlib.h>
/*
c code
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
void
fault_msg(){
 printf("Usage: ./calc N op N \n");
}
int
main(int argc,char* argv[]){
  int result =0;
  if (argc!=4){
    fault_msg();
    return -1;
  }
  int num1=atoi(argv[1]);
  int num2=atoi(argv[3]);
  switch(argv[2][0]){
	  case '+':
            result=num1+num2;
          break;
	  case '-':
            result=num1-num2;
	  break;
	  case '*':
	    result=num1*num2;
	  break;
	  case '/':
	    result=num1/num2;
	  break;
	  default:
	  fault_msg();
	  return -1;
  }
  printf("%ld %c %ld = %ld\n",num1,argv[2][0],num2,result);
  return result;
}
