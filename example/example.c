#include "tcs34725.h"

#include <errno.h>
#include <stdio.h>
#include <string.h>

int main() {
  struct tcs34725* tcs = tcs34725_init("/dev/i2c-1");
  if (tcs == NULL) {
    fprintf(stderr, "failed to initialize tcs34725: %s\n", strerror(errno));
    return -1;
  }

  tcs34725_deinit(tcs);

  return 0;
}
