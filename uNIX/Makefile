all: bootblock kernel
	make -C build

bootblock:
	make -C boot
	
kernel:
	make -C kernel
	
userland:
	make -C userland
	
clean:
	make -C kernel clean && \
	make -C boot clean && \
	make -C build clean && \
	make -C userland clean;
	
run:
	make -C build run
