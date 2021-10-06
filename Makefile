ROOT=.

CC=gcc
C_STD=gnu99
C_TARGET=-x c -std=$(C_STD)
CCARM=arm-none-eabi-$(CC)
COMPILE_C=$(CCARM) $(C_TARGET)

CPPC=g++
CPP_STD=c++17
CPP_TARGET=-x c++ -std=$(CPP_STD)
CPPCARM=arm-none-eabi-$(CPPC)
COMPILE_CPP=$(CPPCARM) $(CPP_TARGET)

ASARM=arm-none-eabi-as

UF2CONV=$(ROOT)/submodule/uf2/utils/uf2conv.py

MCU_FAMILY=SAMD51
MCU_NAME=$(MCU_FAMILY)J19A
MCU_NAME_L=$(shell echo $(MCU_NAME) | tr A-Z a-z)

UF2_OPTS=-c -f $(MCU_FAMILY)

ARM_CC_OPTS=\
 -mthumb\
 -DDEBUG\
 -Os\
 -ffunction-sections\
 -mlong-calls\
 -g3\
 -Wall\
 -c\
 -D__$(MCU_NAME)__\
 -mcpu=cortex-m4\
 -mfloat-abi=softfp\
 -mfpu=fpv4-sp-d16\
 -MD\
 -MP\
 -MF "$(@:%.o=%.d)"\
 -MT "$(@:%.o=%.d)"\
 -MT "$(@:%.o=%.o)"

BIN_DIR=$(ROOT)/bin
OBJ_DIR=$(ROOT)/obj
SRC_DIR=$(ROOT)/src/embedded

LIB=lib
LIB_ASF4_SAMD51=$(LIB)/asf4-samd51
LIB_ASF4_SAMD51_L=$(SRC_DIR)/$(LIB_ASF4_SAMD51)/samd51a/gcc/gcc
LIB_ASF4_SAMD51_LD_FLASH=$(LIB_ASF4_SAMD51_L)/$(MCU_NAME_L)_flash.ld
LIB_ASF4_SAMD51_LD_SRAM=$(LIB_ASF4_SAMD51_L)/$(MCU_NAME_L)_sram.ld

FM4_HUB_OUT=$(BIN_DIR)/fm4hub

INCLUDES+=\
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/CMSIS/Core/Include" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/CMSIS/Include" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/config" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hal/include" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hal/utils/include" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/adc" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/cmcc" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/core" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/dac" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/dmac" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/evsys" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/gclk" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/mclk" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/nvmctrl" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/osc32kctrl" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/oscctrl" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/pm" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/port" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/ramecc" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/rtc" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/sercom" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/systick" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/tc" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/trng" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hpl/usb" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/hri" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/include" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/samd51a/include" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/cdc" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/cdc/device" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/composite/device" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/hid" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/hid/device" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/hub" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/msc" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/msc/device" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/class/vendor" \
-I"$(SRC_DIR)/$(LIB_ASF4_SAMD51)/usb/device"

C_SRCS:=$(shell find $(SRC_DIR) -type f -name *.c -not -path */samd51a/armcc/*)
CPP_SRCS:=$(shell find $(SRC_DIR) -type f -name *.cpp)
C_OBJS:=$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(C_SRCS))
CPP_OBJS:=$(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(CPP_SRCS))
OBJS:=$(C_OBJS) $(CPP_OBJS)
DEPS:=$(OBJS:%.o=%.d)

all: bin_dirs feather_m4

feather_m4: feather_m4_hub_uf2

feather_m4_hub_uf2: feather_m4_hub
	@echo feather_m4_hub_uf2
	$(UF2CONV) $(UF2_OPTS) -o $(FM4_HUB_OUT).uf2 $(FM4_HUB_OUT).bin

feather_m4_hub: $(OBJS)
	@echo feather_m4_hub
	$(CPPCARM) $^ -o $(FM4_HUB_OUT).elf -Wl,--start-group -lm -Wl,--end-group -mthumb -Wl,-Map="$(FM4_HUB_OUT).map" --specs=nosys.specs -Wl,--gc-sections -mcpu=cortex-m4 -Wl,--section-start=.text=0x4000 -T"$(LIB_ASF4_SAMD51_LD_FLASH)" -L"$(LIB_ASF4_SAMD51_L)"
	"arm-none-eabi-objcopy" -O binary $(FM4_HUB_OUT).elf $(FM4_HUB_OUT).bin
	"arm-none-eabi-objcopy" -O ihex -R .eeprom -R .fuse -R .lock -R .signature $(FM4_HUB_OUT).elf $(FM4_HUB_OUT).hex
	"arm-none-eabi-objcopy" -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings -O binary $(FM4_HUB_OUT).elf $(FM4_HUB_OUT).eep || exit 0
	"arm-none-eabi-objdump" -h -S $(FM4_HUB_OUT).elf > $(FM4_HUB_OUT).lss
	"arm-none-eabi-size" $(FM4_HUB_OUT).elf

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo Compiling $< to $@
	$(COMPILE_CPP) $(ARM_CC_OPTS) $(INCLUDES) -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo Compiling $< to $@
	$(COMPILE_CPP) $(ARM_CC_OPTS) $(INCLUDES) -o $@ $<

$(OBJ_DIR)/.o: $(SRC_DIR)/%.s
	@echo Assembling $< to $@
	$(ASARM) $(ARM_CC_OPTS) $(INCLUDES) -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	@echo Compiling $< to $@
	$(CCARM) $(ARM_CC_OPTS) $(INCLUDES) -o $@ $<

bin_dirs:
	@mkdir -p $(BIN_DIR)
	@find $(SRC_DIR) -type d | sed 's/src\/embedded/obj/' | while read path; do mkdir -p "$$path"; done

.PHONY: clean

clean:
	rm -r $(BIN_DIR) $(OBJ_DIR)
