VERSION := 0.1.0

INCLUDE_DIR := include
SRC_DIR := src

CFLAGS := -Wall -Wextra -Werror -fPIC -g -I$(INCLUDE_DIR)
LDFLAGS :=

SRC = $(shell find $(SRC_DIR) -name "*.c")
OBJ = $(patsubst $(SRC_DIR)/%.c, $(SRC_DIR)/%.o, $(SRC))

LIB_NAME = tcs34725
STATIC_LIB = lib$(LIB_NAME).a
SHARED_LIB = lib$(LIB_NAME).so

PREFIX ?= /usr/local

PKGCONFIG_DIR = $(PREFIX)/lib/pkgconfig
LIB_DIR = $(PREFIX)/lib
INCLUDE_INSTALL_DIR = $(PREFIX)/include/tcs34725
BIN_DIR = $(PREFIX)/bin

.PHONY: all
all: static shared

static: $(OBJ)
	ar rcs $(STATIC_LIB) $(OBJ)

shared: $(OBJ)
	$(CC) -shared -o $(SHARED_LIB) $(OBJ) $(LDFLAGS)

$(SRC_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@ $(LDFL)

.PHONY: install
install: static shared pkgconfig
	mkdir -p $(INCLUDE_INSTALL_DIR) $(LIB_DIR) $(PKGCONFIG_DIR)

	cp $(INCLUDE_DIR)/tcs34725/* $(INCLUDE_INSTALL_DIR)
	cp $(STATIC_LIB) $(SHARED_LIB) $(LIB_DIR)

	cp tcs34725.pc tcs34725-static.pc $(PKGCONFIG_DIR)

.PHONY: clean
clean:
	rm -rf $(OBJ) $(STATIC_LIB) $(SHARED_LIB) *.pc

define PKG_CONFIG
prefix=$(PREFIX)
includedir=$${prefix}/include
libdir=$${prefix}/lib

Name: $(LIB_NAME)
Description: TCS34725 color sensor C library
Version: $(VERSION)
Cflags: -I$${includedir}
Libs: -L$${libdir} -ltcs34725
endef

define PKG_CONFIG_STATIC
prefix=$(PREFIX)
includedir=$${prefix}/include
libdir=$${prefix}/lib

Name: $(LIB_NAME)-static
Description: TCS34725 color sensor C library
Version: $(VERSION)
Cflags: -I$${includedir}
Libs: -L$${libdir} -ltcs34725 -static
endef

pkgconfig: $(LIB_NAME).pc $(LIB_NAME)-static.pc

$(LIB_NAME).pc:
    $(file > $(LIB_NAME).pc,$(PKG_CONFIG))

$(LIB_NAME)-static.pc:
    $(file > $(LIB_NAME)-static.pc,$(PKG_CONFIG_STATIC))

.PHONY: compile_commands.json
compile_commands.json:
	@bear -- make clean all
