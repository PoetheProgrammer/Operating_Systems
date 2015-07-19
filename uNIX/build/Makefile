all: unix.img
	dd if=/dev/zero of=unix.img count=10000
	dd if=bootblock of=unix.img conv=notrunc
	dd if=kernel of=unix.img seek=1 conv=notrunc
	sudo dd if=./unix.img of=/dev/sda5

unix.img:
	touch unix.img;
	
clean:
	rm {bootblock,unix.img,kernel}
	
run:
	sudo qemu-system-i386 -serial mon:stdio -hdb ./fs.img /dev/sda5 -smp 2 -m 512
	
