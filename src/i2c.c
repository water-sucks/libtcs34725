#include "tcs34725/i2c.h"

#include <fcntl.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <unistd.h>

struct i2c_device {
  int fd;
  uint8_t target_addr;
};

struct i2c_device* i2c_open(char* dev_path, uint8_t addr) {
  struct i2c_device* dev = malloc(sizeof(struct i2c_device));
  if (dev == NULL) {
    return NULL;
  }

  dev->fd = open(dev_path, O_RDWR);
  if (dev->fd < 0) {
    free(dev);
    return NULL;
  }

  if (i2c_set_target_addr(dev, addr) < 0) {
    i2c_close(dev);
    return NULL;
  }

  return dev;
}

int i2c_set_target_addr(struct i2c_device* dev, uint8_t addr) {
  if (ioctl(dev->fd, I2C_SLAVE, addr) < 0) {
    return -1;
  }

  dev->target_addr = addr;
  return 0;
}

void i2c_close(struct i2c_device* dev) {
  close(dev->fd);
  free(dev);
}
