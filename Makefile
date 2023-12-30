ASM=nasm

SRC_DIR=src
BUILD_DIR=build

$(BUILD_DIR)/OS_floppy.img: $(BUILD_DIR)/OS.bin
	cp $(BUILD_DIR)/OS.bin $(BUILD_DIR)/OS_floppy.img
	truncate -s 1440k $(BUILD_DIR)/OS_floppy.img

$(BUILD_DIR)/OS.bin: $(SRC_DIR)/OS.asm
	$(ASM) $(SRC_DIR)/OS.asm -f bin -o $(BUILD_DIR)/OS.bin
