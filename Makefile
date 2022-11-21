NAME=HELLO

all: HELLO

clean:
	rm -rf hello
	rm -rf *.o

HELLO: hello_world.asm
	nasm -f elf -F dwarf -g hello_world.asm
	nasm -f elf -F dwarf -g thread.asm
	gcc -no-pie -g -m32 -o hello *.o
