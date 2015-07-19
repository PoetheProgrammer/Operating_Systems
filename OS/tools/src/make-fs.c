/**
  MKFS for My OS,
  whatever it ends up being... **/
#include <stdio.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>

int makefs(char ** arg, int argc);

int main(int argc, char ** argv) {
  int userInput;
  if(argc < 3)
    printf("No Device Specified\n\n");
  else {
    printf("\n\nAre You Sure You Want to Write to [%s],\nthis will destroy whatever is on it... [1Y/2N]: ", argv[1]);
    scanf("%d", &userInput);
    if(userInput == 1) {
      makefs(argv, argc);
    }
  }

  return 0;
}

int makefs(char ** arg, int argc) {
  /**
    Copy the bootloader to the first 512 bytes,
    then the files one by one. **/
    char * prog, buf[1024];
    int dev, file, length, i = 3, count = 512, last = 0; /** Software to Install Begins at argv[3] **/

    /**
      Bootloader **/
    file = open(arg[2], O_RDONLY);
    assert(file > 0);

    read(file, buf, 512);
    close(file);
    printf("Loading [%s] as Bootsector\n", arg[2]);

    dev = open(arg[1], O_RDWR);
    assert(dev > 0);

    /**
      Write Loaded File to Disk **/
    if(write(dev, buf, 512))
      printf("[%s] Written as bootloader\n\n", arg[2]);

    for(; i < argc; i++) {
      file = open(arg[i], O_RDONLY);
      assert(file > 0);
      /**
        Get file size, copy it to disk **/
      length = lseek(file, 0, SEEK_END)+1;
      read(file, prog, length);
      last = count;
      count = count + length;
      if(write(dev, prog, length))
        printf("%s Written Next, Start: %d, End: %d\n", arg[i], last, count);

      close(file);
    }

    close(dev);
    printf("Finished...\n\n");

    return 0;
}
