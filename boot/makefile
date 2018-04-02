all: boot_loader_build
boot_loader_build: boot.asm
	@echo [+] compiling boot loader
	nasm -o boot.bin boot.asm
	@echo [!] compile done
clean:
	@echo [+] removing boot.bin
	rm -f boot.bin
	@echo [!] removing done