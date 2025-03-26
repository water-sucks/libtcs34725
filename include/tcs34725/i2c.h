#ifndef _TCS34725_I2C_H_
#define _TCS34725_I2C_H_

#include <stdint.h>
#include <stdlib.h>

struct i2c_device {
  int fd;
  uint8_t target_addr;
};

struct i2c_device* i2c_open(char* dev_path, uint8_t addr);
void i2c_close(struct i2c_device* dev);

int i2c_set_target_addr(struct i2c_device* dev, uint8_t addr);

int i2c_write_byte(struct i2c_device* dev, uint8_t data);
int i2c_read_byte(struct i2c_device* dev, uint8_t* data);

int i2c_block_read(struct i2c_device* dev, uint8_t data, size_t len);
int i2c_block_write(struct i2c_device* dev, uint8_t* data, size_t len);

#endif
