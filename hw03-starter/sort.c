
#include <unistd.h>
#include <stdlib.h>// for atol
#include <stdio.h> // for perror

//for open(2)
#include <sys/types.h>
#include <fcntl.h>
#include <sys/stat.h>
int
length(char* text)
{
    char* z;
    for (z = text; *z; ++z);
    return z - text;
}


void
usageinfo(){
   char* usage = "Usage: ./sort input output\n";

    int rv = write(1, usage, length(usage));
    if (rv < 0) {
        // Checking your syscall return values is a
        // really good idea.
        perror("write in main");
    }
   _exit(1);
}

//this part sort the array and write it back into outputfile
//  using insertsort
void
sort(int* inputarray,long size,char *outputfile){
for(int i=0;i<size;i++){
   int key=inputarray[i];
   int j=i-1;
   while(j>-1 && inputarray[j]>key){
     inputarray[j+1]=inputarray[j];
     j=j-1;
   }
   inputarray[j+1]=key;
   }

//write the output

int file_out=open(outputfile,O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);

if(file_out!=-1){
  int write_result=write(file_out,inputarray,size*4);

  if (write_result==-1){usageinfo();}
}else{
  usageinfo();
}
close(file_out);
}

int
// usage: ./sort input output
// using insertsort
main(int argc, char* argv[])
{
    if (argc!=3){
      usageinfo();  //check the input form
    }
    int file_in=open(argv[1],O_RDONLY);
    
    if(file_in!=-1){

     struct stat f_stat;
     stat(argv[1], &f_stat);
     int size=f_stat.st_size;
     int array_size=size/4;
     int read_buf[array_size];// define read_buf
     size=read(file_in,read_buf,size);
     if (size==-1){usageinfo();
     }
     sort(read_buf,array_size,argv[2]);
    }else{usageinfo();}
    close(file_in);
    return 0;
}
