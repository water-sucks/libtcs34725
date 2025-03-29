CFLAGS = -Wall -Wextra -Werror $(shell pkg-config --cflags tcs34725)

# Compile against the system tcs34725 library dynamically
# LDFLAGS = $(shell pkg-config --libs tcs34725)
# Compile against the system tcs34725 library statically
LDFLAGS = -Wl,-Bstatic $(shell pkg-config --libs tcs34725) -Wl,-Bdynamic

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


.PHONY: compile_commands.json
compile_commands.json:
	@bear -- make clean all

.PHONY: zig-compile-commands.json
zig-compile_commands.json:
	zig build -Dtarget=aarch64-linux-musl

	(echo \[ ; cat .zig-cache/cdb/* ; echo {}\]) \
		| perl -0777 -pe 's/,\n\{\}//igs' \
		| jq . | grep -v 'no-default-config' \
		> compile_commands.json
