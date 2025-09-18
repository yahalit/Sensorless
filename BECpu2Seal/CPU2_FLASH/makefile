################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-c2000_22.6.1.LTS

GEN_OPTS__FLAG := 
GEN_CMDS__FLAG := 

ORDERED_OBJS += \
"./SEAL_codestartbranch.obj" \
"./Drivers/LowLevel.obj" \
"./SEAL/Automatic/ExternalCode/CANServer.obj" \
"./SEAL/Automatic/Seal.obj" \
"./SEAL/Automatic/Seal_data.obj" \
"./SEAL/Automatic/div_nde_s16_floor.obj" \
"./SEAL/Automatic/mod_CTxUEiaB.obj" \
"./SEAL/Automatic/rt_roundd.obj" \
"./SEAL/DeviceSetup.obj" \
"./SEAL/SealMain.obj" \
"../SEAL_generic_flash_lnk_cpu2.cmd" \
$(GEN_CMDS__FLAG) \
-llibc.a \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include Drivers/subdir_vars.mk
-include SEAL/Automatic/ExternalCode/subdir_vars.mk
-include SEAL/Automatic/subdir_vars.mk
-include SEAL/subdir_vars.mk
-include subdir_rules.mk
-include Drivers/subdir_rules.mk
-include SEAL/Automatic/ExternalCode/subdir_rules.mk
-include SEAL/Automatic/subdir_rules.mk
-include SEAL/subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(SV7A_DEPS)),)
-include $(SV7A_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXE_OUTPUTS += \
BESeal.out 

EXE_OUTPUTS__QUOTED += \
"BESeal.out" 


# All Target
all: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@$(MAKE) --no-print-directory -Onone "BESeal.out"

# Tool invocations
BESeal.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: "$@"'
	@echo 'Invoking: C2000 Linker'
	"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-c2000_22.6.1.LTS/bin/cl2000" -v28 -ml -mt --cla_support=cla2 --float_support=fpu64 --tmu_support=tmu1 --vcu_support=vcrc -Ooff --fp_mode=relaxed --define=DEBUG --define=CPU2 --define=_FLASH --diag_suppress=10063 --diag_warning=225 --diag_wrap=off --display_error_number --gen_func_subsections=on --abi=eabi -z -m"BESeal.map" --stack_size=0x10 --warn_sections -i"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-c2000_22.6.1.LTS/lib" -i"C:/ti/ccs1260/ccs/tools/compiler/ti-cgt-c2000_22.6.1.LTS/include" --reread_libs --diag_wrap=off --display_error_number --xml_link_info="BESeal_linkInfo.xml" --entry_point=code_start --rom_model -o "BESeal.out" $(ORDERED_OBJS)
	@echo 'Finished building target: "$@"'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(EXE_OUTPUTS__QUOTED)
	-$(RM) "SEAL_codestartbranch.obj" "Drivers\LowLevel.obj" "SEAL\Automatic\ExternalCode\CANServer.obj" "SEAL\Automatic\Seal.obj" "SEAL\Automatic\Seal_data.obj" "SEAL\Automatic\div_nde_s16_floor.obj" "SEAL\Automatic\mod_CTxUEiaB.obj" "SEAL\Automatic\rt_roundd.obj" "SEAL\DeviceSetup.obj" "SEAL\SealMain.obj" 
	-$(RM) "Drivers\LowLevel.d" "SEAL\Automatic\ExternalCode\CANServer.d" "SEAL\Automatic\Seal.d" "SEAL\Automatic\Seal_data.d" "SEAL\Automatic\div_nde_s16_floor.d" "SEAL\Automatic\mod_CTxUEiaB.d" "SEAL\Automatic\rt_roundd.d" "SEAL\DeviceSetup.d" "SEAL\SealMain.d" 
	-$(RM) "SEAL_codestartbranch.d" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

