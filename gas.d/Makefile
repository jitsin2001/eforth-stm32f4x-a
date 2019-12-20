
ARMGNU?=arm-none-eabi

COPS = -Wall  -Os -nostdlib -nostartfiles -ffreestanding -save-temps
AOPS = --warn --fatal-warnings

all : experiment-aa.bin 

experiment-aa.o : experiment-aa.s
	$(ARMGNU)-as experiment-aa.s -o experiment-aa.o

experiment-aa.bin : memmap experiment-aa.o
	$(ARMGNU)-ld -o experiment-aa.elf -T memmap experiment-aa.o
	$(ARMGNU)-objdump -D experiment-aa.elf > experiment-aa.list
	$(ARMGNU)-objcopy experiment-aa.elf experiment-aa.bin -O binary

dump:
	arm-none-eabi-objdump --architecture=armv5 -D experiment-aa.elf

install:
	dfu-util -a 0 --dfuse-address 0x08000000 -D experiment-aa.bin

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list
