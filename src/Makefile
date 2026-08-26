TARGET=hello

all:
		nasm -f elf64 -g -F dwarf $(TARGET).asm -o $(TARGET).o
		ld $(TARGET).o -o $(TARGET)
	
run: all
		./$(TARGET)

clean:
		rm -f *.o $(TARGET)