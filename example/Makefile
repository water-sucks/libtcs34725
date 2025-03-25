CFLAGS = -Wall -Wextra -Werror $(shell pkg-config --cflags tcs34725-static)
LDFLAGS = $(shell pkg-config --libs tcs34725-static)

SRC := example.c
OBJ := example.o

BIN = tcs34725-example

PREFIX ?= /usr/local
BIN_DIR = $(PREFIX)/bin

all: $(BIN)

$(BIN): $(OBJ)
	$(CC) -o $@ $< $(LDFLAGS)

$(OBJ): $(SRC)
	$(CC) -c $@ $< $(CFLAGS)

install: $(BIN)
	mkdir -p $(BIN_DIR)
	cp -t $(BIN_DIR) $(BIN)

clean:
	rm -f $(OBJ) $(BIN)
