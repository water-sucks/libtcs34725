#ifndef _TCS34725_H_
#define _TCS34725_H_

#define TCS34725_I2C_ADDR 0x29

struct tcs34725;

struct tcs34725* tcs34725_init(char* i2c_bus_path);
void tcs34725_deinit(struct tcs34725* tcs);

#endif
