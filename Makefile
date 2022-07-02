x86_64_asm_source_files := $(shell find src/impl/x86_64 -name *.asm) #find all the files with asm extension
#and is asigned to the variable x86_64_asm_source_files

#after compiling the source files will turn into object files, so we need a variable that point to all the
#object files
x86_64_asm_object_files := $(patsubst src/impl/x86_64/%.asm, build/x86_64/%.o, $(x86_64_asm_source_files))
#renames all out input source files to the outputs object files which are saved in build directory

x86_64_c_source_files := $(shell find src/impl/x86_64 -name *.c)
x86_64_c_object_files := $(patsubst src/impl/x86_64/%.c, build/x86_64/%.o, $(x86_64_c_source_files))

kernel_source_files := $(shell find src/impl/kernel -name *.c)
kernel_object_files := $(patsubst src/impl/kernel/%.c, build/kernel/%.o, $(kernel_source_files))

x86_64_object_files := $(x86_64_asm_object_files) $(x86_64_c_object_files)
#we only want to compile the source files that have changed
#we need to make sure that the directory that will hold our object files exists
#mkdir -p $(dir $@) get the directory of the file we are compiling
#&& and the backslash is to add a command after another one
#nasm -f elf64 -o $@, change the format to elf64 and name with the name of the source file
#do a reverse path substitute 
$(x86_64_asm_object_files): build/x86_64/%.o : src/impl/x86_64/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/x86_64/%.o, src/impl/x86_64/%.asm, $@) -o $@

$(x86_64_c_object_files): build/x86_64/%.o : src/impl/x86_64/%.c
	mkdir -p $(dir $@) && \
	x86_64-elf-gcc -c -I src/impl/intf -ffreestanding $(patsubst build/x86_64/%.o, src/impl/x86_64/%.c, $@) -o $@

$(kernel_object_files): build/kernel/%.o : src/impl/kernel/%.c
	mkdir -p $(dir $@) && \
	x86_64-elf-gcc -c -I src/impl/intf -ffreestanding $(patsubst build/kernel/%.o, src/impl/kernel/%.c, $@) -o $@
#we build a custom phoney command
#this should only run if and only if an object file has changed
#we set the output to kernel.bin and use our linkerscript
#and then we can pass out object files as input
#in the config file we generate a iso file, which use a kernel.bin, now we have to move this file from here to the boot foldel
#and finally generate the iso file
#we need to reference our iso folder
.PHONY: build-x86_64
build-x86_64: $(kernel_object_files) $(x86_64_object_files)
	mkdir -p dist/x86_64 && \
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld $(kernel_object_files) $(x86_64_object_files) && \
	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso




