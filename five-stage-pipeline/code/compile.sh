riscv64-unknown-elf-as -march=rv64i -o prog.o $1
riscv64-unknown-elf-ld -o prog.elf prog.o
riscv64-unknown-elf-objcopy -O binary prog.elf prog.bin
hexdump -ve '1/4 "%08x\n"' prog.bin > prog.hex
cp prog.hex ../instructions.txt