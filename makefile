all: build_boot_loader
build_boot_loader:
	@echo [r] start building boot loader
	make -C boot
	@echo [r] building boot loader ... [done]
clean:
	@echo [r] removing boot loader binary files ..
	make -C boot clean
	@echo [r] done  