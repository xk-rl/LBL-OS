ASM=nasm

SRC_DIR=src
BUILD_DIR=build

$(BUILD_DIR)/boot.img: $(BUILD_DIR)/boot.bin
	cp $(BUILD_DIR)/boot.bin $(BUILD_DIR)/boot.img
	truncate -s 1440k $(BUILD_DIR)/boot.img

$(BUILD_DIR)/boot.bin: $(SRC_DIR)/bootloader/boot.asm
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/boot.bin
