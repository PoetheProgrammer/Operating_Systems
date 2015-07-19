#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[]) {
  int i = 1;
  for(; i < argc; i++)
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  
  exit();
}
