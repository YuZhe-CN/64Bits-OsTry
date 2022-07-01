x86_64_asm_source_files := $(shell find src/impl/x86_64 -name *.asm) #find all the files with asm extension
#and is asigned to the variable x86_64_asm_source_files

#after compiling the source files will turn into object files, so we need a variable that point to all the
#object files
x86_64_asm_object_files := $(patsubst src/impl/x86_64/%.asm, build/x86_64/%.o, $(x86_64_asm_object_files))
#renames all out input source files to the outputs object files which are saved in build directory


#we only want to compile the source files that have changed
#we need to make sure that the directory that will hold our object files exists
#mkdir -p $(dir $@) get the directory of the file we are compiling
#&& and the backslash is to add a command after another one
#nasm -f elf64 -o $@, change the format to elf64 and name with the name of the source file
#do a reverse path substitute 
$(x86_64_asm_object_files): build/x86_64/%.o : src/impl/x86_64/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/x86_64/%.o, src/impl/x86_64/%.asm, $@) -o $@

#we build a custom phoney command
#this should only run if and only if an object file has changed
#we set the output to kernel.bin and use our linkerscript
#and then we can pass out object files as input
#in the config file we generate a iso file, which use a kernel.bin, now we have to move this file from here to the boot foldel
#and finally generate the iso file
.PHONY: build-x86_64
build-x86_64: $(x86_64_asm_object_files)
	mkdir -p dist/x86_64 && \
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld $(x86_64_asm_object_files) && \ 
	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin && \
	grub-mkrecue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso
#we need to reference our iso folder





