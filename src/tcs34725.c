#include "tcs34725.h"

#include <stdio.h>

struct tcs34725* tcs34725_init(char* i2c_bus_path) {
  struct tcs34725* tcs = malloc(sizeof(struct tcs34725));
  if (tcs == NULL) {
    return NULL;
  }

  tcs->dev = i2c_open(i2c_bus_path, TCS34725_I2C_ADDR);
  if (tcs->dev == NULL) {
    free(tcs);
    return NULL;
  }

  return tcs;
}

void tcs34725_deinit(struct tcs34725* tcs) {
  i2c_close(tcs->dev);
  free(tcs);
}
