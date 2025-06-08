#define BAD_COMMAND						0x7480//"Bad Command"
#define BAD_INDEX						0x7481//"Bad Index"
#define STRING_TOO_LARGE				0x7482//"String too large"
#define INTERNAL_INTERP_ERR				0x7483//"Internal interpreter error"
#define VAR_NOT_STRING					0x7484//"Variable is not string"
#define BAD_COM_FORMAT					0x7485//"Bad Command Format"
#define PAR_OUT_OF_RANGE				0x7486//"Operand Out of Range"
#define BAD_OPERATOR					0x7487//"Bad Operation"
#define PROGRAM_NOT_COMPILED			0x7488//"Program does not exist or not Compiled"
#define BAD_PROGRAM_DATABASE			0x7489//"Bad program Data Base"
#define BAD_CONTEXT						0x748a//"Bad Context"
#define RECORDER_IS_BUSY				0x748b//"Recorder Is Busy"
#define REC_SETTING_ERROR				0x748c//"Recorder Usage Error"
#define REC_INVALIDATE					0x748d//"Recorder data Invalid"
#define MISPLACED_DEFAULT				0x748e//"Misplaced default operand"
#define BUFFER_TOO_LARGE				0x748f//"Buffer Too Large"
#define OUT_OF_RANGE_PAR_1				0x7490//"Out of range parameter 1"
#define OUT_OF_RANGE_PAR_2				0x7491//"Out of range parameter 2"
#define OUT_OF_RANGE_PAR_3				0x7492//"Out of range parameter 3"
#define OUT_OF_RANGE_PAR_4				0x7493//"Out of range parameter 4"
#define OUT_OF_RANGE_PAR_5				0x7494//"Out of range parameter 5"
#define OUT_OF_RANGE_PAR_6				0x7495//"Out of range parameter 6"
#define OUT_OF_RANGE_PAR_7				0x7496//"Out of range parameter 7"
#define OUT_OF_RANGE_PAR_8				0x7497//"Out of range parameter 8"
#define OUT_OF_RANGE_PAR_9				0x7498//"Out of range parameter 9"
#define OUT_OF_RANGE_PAR_10				0x7499//"Out of range parameter 10"
#define OUT_OF_RANGE_PAR_11				0x749a//"Out of range parameter 11"
#define OUT_OF_RANGE_PAR_12				0x749b//"Out of range parameter 12"
#define OUT_OF_RANGE_PAR_13				0x749c//"Out of range parameter 13"
#define OUT_OF_RANGE_PAR_14				0x749d//"Out of range parameter 14"
#define OUT_OF_RANGE_PAR_15				0x749e//"Out of range parameter 15"
#define OUT_OF_RANGE_PAR_16				0x749f//"Out of range parameter 16"
#define OUT_OF_RANGE_PAR_17				0x74a0//"Out of range parameter 17"
#define OUT_OF_RANGE_PAR_18				0x74a1//"Out of range parameter 18"
#define OUT_OF_RANGE_PAR_19				0x74a2//"Out of range parameter 19"
#define OUT_OF_RANGE_PAR_20				0x74a3//"Out of range parameter 20"
#define OUT_OF_RANGE_PAR_21				0x74a4//"Out of range parameter 21"
#define OUT_OF_RANGE_PAR_22				0x74a5//"Out of range parameter 22"
#define NUMBER_TOO_LONG					0x74a6//"Too long number"
#define NUM_OVERFLOW					0x74a7//"Overflow in a numeric operator"
#define VAR_IS_ARRAY					0x74a8//"Variable is an array"
#define NOT_A_NUMBER					0x74a9//"Not a number"
#define NUM_STACK_UNDERFLOW				0x74aa//"Numeric Stack underflow"
#define NUM_STACK_OFLOW					0x74ab//"Numeric stack overflow" 
#define EXP_STACK_OFLOW					0x74ac//"Expression stack overflow" 
#define EXEC_COMMAND					0x74ad//"Executable command within math expression"
#define EMPTY_EXPRESSION				0x74ae//"Nothing in the expression"
#define UNEXPECTED_TERMINATOR			0x74af//"Unexpected sentence termination"
#define ENDLESS_SENTENCE				0x74b0//"Sentence terminator not found"
#define PARANTHESES_MISMATCH			0x74b1//"Parantheses mismatch"
#define BAD_OPERAND_TYPE				0x74b2//"Bad operand type"
#define OUT_OF_DATA_SEG					0x74b3//"Address is out of data memory segment"
#define BEYOND_STACK_RANGE				0x74b4//"Beyond stack range"
#define EC_COMMAND						0x74b5//"EC command (not an error)"
#define RESPONSE_ABSENT					0x74b6//"Response is absent"
#define NOT_FIELD_ACCESS_FOR_CUSTOM		0x74b7//"For custom report extended mnemonics only access per field is allowed" 
#define FIELD_ACCESS_FOR_ARRAY			0x74b8//"Access per field is forbidden for array mnemonics"
#define NOT_ENOUGH_INDEX_ARG			0x74b9//"Too few indices for array extended mnemonics"
#define BAD_REC_DATA_TYPE				0x74ba//"Bad recorder parameter"



#define PROGRAM_NOT_RUNNING				0x74c0//"Program is not running"
#define NO_SUCH_LABEL					0x74c1//"No Such Label"
#define OUT_OF_PROG_RANGE				0x74c2//"Out of Program Range"
#define PROGRAM_IS_RUNNING				0x74c3//"Program Is Running"
#define CMD_NOT_FOR_PROGRAM				0x74c4//"CMD not for program"
#define PROG_TIME_OUT					0x74c5//"User program time out"
#define PERSONALITY_NOT_LOADED			0x74c6//"Personality not loaded"
#define FAILED_USER_PROG				0x74c7//"Failure in the user program - ask factory support"
#define BAD_VAR_INDEX					0x74c8//"Bad variable index in database - internal compiler error"
#define VAR_NOT_ARRAY					0x74c9//"Variable is not an array"
#define BAD_VAR_NAME					0x74ca//"Variable name does not exist"
#define LOCAL_USER_VAR					0x74cb//"Cannot record local variable"
#define MISMATCH_FUNC_ARGS				0x74cc//"Number of function input arguments is not as expected"
#define LOCAL_USER_FUNC					0x74cd//"Cannot run local label/function with xq command"
#define PROG_ALREADY_COMPILED			0x74ce//"Program already compiled" 
#define TOO_MANY_BREAK_PTS				0x74cf//"The number of break points exceeds maximal number"
#define NOT_RELEVANT_BREAK_PNT			0x74d0//"An attempt to set/clear break point at the not relevant line"
#define BAD_OPCODE						0x74d1//"Bad opcode"
#define PROGRAM_NOT_HALTED				0x74d2//"Program is not halted"
#define OUT_OF_PROGDATA_MEM				0x74d3//"Not enough space in program data segment"
#define PROGRAM_TOO_LARGE				0x74d4//"Non-text area of program is too large"
#define NO_PROGRAM_LOADED				0x74d5//"Program has not been loaded" 
#define ATTEMPT_CUSTOM_SET				0x74d6//"An attempt to set custom report extended mnemonic" 

// DS402 errors, corresponds to ies61800-7-201,table 24. 
// 16-bit codes for Emergency messages and database errors.
// Error codes from xx00h to xx7Fh are compatible with defined in EN 50325-4 or in ies61800-7-201, Table 24.
// Error codes between xx80h and xxFFh are used manufacturer-specific.
// Error codes between ff00h and FFFFh are also used manufacturer-specific.
///////////////

#define Short_circuit_or_earth_leakage_at_input  0x2110 
#define Earth_leakage_at_input  0x2120 
#define Earth_leakage_phase_L1  0x2121 
#define Earth_leakage_phase_L2  0x2122 
#define Earth_leakage_phase_L3  0x2123 
#define Short_circuit_at_input  0x2130 
#define Short_circuit_phases_L1_L2  0x2131 
#define Short_circuit_phases_L2_L3  0x2132 
#define Short_circuit_phases_L3_L1  0x2133
 
#define Internal_current_no1  0x2211 
#define Internal_current_no2  0x2212 
#define Over_current_in_ramp_function  0x2213 
#define Over_current_in_the_sequence  0x2214 
#define Continuous_over_current_at_device_internal  0x2220 
#define Continuous_over_current_at_device_no1  0x2221 
#define Continuous_over_current_at_device_no2  0x2222 
#define Short_circuit_or_earth_leakage_at_device_internal  0x2230 
#define Earth_leakage_at_device_internal  0x2240 
#define Short_circuit_at_device_internal  0x2250 
#define Expt_CurrentSensorFail_no1		  0x2280
#define Expt_CurrentSensorFail_no2		  0x2281
#define Expt_CurrentSensorFail_no3		  0x2282
#define Expt_CurrentSensorFail_no4		  0x2283
#define Expt_CurrentSensorFail_no5		  0x2284
#define Expt_CurrentSensorFail_no6		  0x2285

#define Continuous_over_current  0x2310 
#define Continuous_over_current_no1  0x2311 
#define Continuous_over_current_no2  0x2312 
#define Short_circuit_or_earth_leakage_at_motor_side  0x2320 
#define Earth_leakage_at_motor_side  0x2330 
#define Earth_leakage_phase_U  0x2331 
#define Earth_leakage_phase_V  0x2332 
#define Earth_leakage_phase_W  0x2333 

#define Short_circuit_at_motor_side				0x2340 // bridge short circuit
#define Short_circuit_phases_U_V				0x2341 
#define Earth_leakage_phase_V_W					0x2342 
#define Earth_leakage_phase_W_U					0x2343 
#define Load_level_fault_at_I2t_thermal_state	0x2350 
#define Load_level_warning_at_I2t_thermal_state 0x2351
#define Expt_PeakOverCurrent					0x2380 // peak overcurrent in phases
#define Expt_PeakOverCurrentAz					0x2381 // peak overcurrent AZ
#define Expt_PeakOverCurrentElev				0x2382 // peak overcurrent ELEV


 
#define Mains_over_voltage  0x3110 
#define Mains_over_voltage_phase_L1  0x3111 
#define Mains_over_voltage_phase_L2  0x3112 
#define Mains_over_voltage_phase_L3  0x3113 
#define Mains_under_voltage  0x3120 
#define Mains_under_voltage_phase_L1  0x3121 
#define Mains_under_voltage_phase_L2  0x3122 
#define Mains_under_voltage_phase_L3  0x3123 
#define Phase_failure  0x3130 
#define Phase_failure_L1  0x3131 
#define Phase_failure_L2  0x3132 
#define Phase_failure_L3  0x3133 
#define Phase_sequence  0x3134 
#define Mains_frequency  0x3140 
#define Mains_frequency_too_great  0x3141 
#define Mains_frequency_too_small  0x3142
 
#define DC_link_over_voltage  0x3210 // bridge overvoltage
#define Over_voltage_no_1  0x3211 
#define Over_voltage_no_2  0x3212 
#define DC_link_under_voltage  0x3220 // bridge undervoltage
#define Under_voltage_no_1  0x3221 
#define Under_voltage_no_2  0x3222 
#define Load_error  0x3230
 
#define Output_over_voltage  0x3310 
#define Output_over_voltage_phase_U  0x3311 
#define Output_over_voltage_phase_V  0x3312 
#define Output_over_voltage_phase_W  0x3313 
#define Armature_circuit  0x3320 
#define Armature_circuit_interrupted  0x3321 
#define Field_circuit  0x3330 
#define Field_circuit_interrupted  0x3331
 
#define Excess_ambient_temperature  0x4110 
#define Too_low_ambient_temperature  0x4120 
#define Temperature_supply_air  0x4130 
#define Temperature_air_outlet  0x4140
 
#define Excess_temperature_device  0x4210 
#define Too_low_temperature_device  0x4220
 
#define Temperature_drive  0x4300 
#define Excess_temperature_drive  0x4310 
#define Too_low_temperature_drive  0x4320
 
#define Temperature_supply  0x4400 
#define Excess_temperature_supply  0x4410 
#define Too_low_temperature_supply  0x4420 

#define Supply_Fault					0x5100 
#define Supply_low_voltage				0x5110 
#define U1_supply_15V					0x5111 
#define U2_supply_P24_V					0x5112 
#define U3_supply_P5_V					0x5113 
#define U4_manufacturer_specific		0x5114 
#define U5_manufacturer_specific		0x5115 
#define U6_manufacturer_specific		0x5116 
#define U7_manufacturer_specific		0x5117 
#define U8_manufacturer_specific		0x5118 
#define U9_manufacturer_specific		0x5119 
#define Supply_intermediate_circuit		0x5120 
#define VFiltConst_OutOfRange			0x5180   // VFilt constant out of range
#define Expt_VoltageSensorFailure		0x5181
#define Hot_Pbit_Fail					0x5182   // HotCpu power bit fail



#define Control_Fault					0x5200 
#define Control_Measurement_circuit		0x5210
#define Computing_circuit				0x5220
#define Computation_stack_overflow		0x5280
#define Computation_NullInterrupt		0x5281
#define Computation_task_timing			0x5282
#define Expt_CurrentOffsets				0x5283 // cant get current offsets

 
#define Operating_unit  0x5300 
#define Power_section  0x5400 
#define Output_stages  0x5410 
#define Chopper_Fault  0x5420 
#define Input_stages  0x5430 
#define Contacts  0x5440 
#define Contact_1_manufacturer_specific  0x5441 
#define Contact_2_manufacturer_specific  0x5442 
#define Contact_3_manufacturer_specific  0x5443 
#define Contact_4_manufacturer_specific  0x5444 
#define Contact_5_manufacturer_specific  0x5445 
#define Fuses_Fault  0x5450 
#define S1_l1_Fault  0x5451 
#define S2_l2_Fault  0x5452 
#define S3_l3_Fault  0x5453 
#define S4_manufacturer_specific  0x5454 
#define S5_manufacturer_specific  0x5455 
#define S6_manufacturer_specific  0x5456 
#define S7_manufacturer_specific  0x5457 
#define S8_manufacturer_specific  0x5458 
#define S9_manufacturer_specific  0x5459 
#define Bridge_amplifier_disabled 0x5480 // infen
#define Bridge_ready_timeout  	  0x5481 // timeout
#define Bridge_off_timeout  	  0x5482 // timeout
#define Bridge_gate_not_ready	  0x5483 
#define Bridge_in_capacitor_not_ready 0x5484 // bypass status not ready


#define Hardware_memory						0x5500 
#define RAM_Error							0x5510 
#define ROM_or_EPROM						0x5520 
#define EEPROM_Error						0x5530 
#define	Flash_write_error					0x5580//"Flash write error"
#define	Flash_read_error 					0x5581//"Flash reading error"
#define	Flash_erase_error 					0x5582//"Flash erase error"
#define Flash_out_of_range					0x5583//"Out of flash memory range"
#define Flash_verify_error					0x5584//"invalid flash memory data"
#define Flash_mismatch_data_checksum		0x5585//"Checksum of data is not correct"
#define Flash_boot_is_absent				0x5586//"Boot is not burned or is erased"
#define SFlash_toc_error					0x5587//"Serial Flash toc reading error"
#define SFlash_par_error					0x5588//"Serial Flash parameter reading error"
#define SFlash_read_error					0x5589//"Serial Flash reading error"
#define SFlash_mismatch_data_checksum		0x558a//"Checksum of data in serial flash is not correct"
#define SFlash_write_error					0x558b//"Serial Flash write error"
#define SFlash_absent_data					0x558c//"Validation of data in serial flash is not found"
#define SFlash_cant_read_axis_id			0x558d//"Axis ID in serial flash is not found"
#define Flash_hotcpu_version_invalid		0x558e//"HotCpu version is invalid"

#define Software_reset_at_watchdog  0x6010 

#define to_630Fh_Data_record_no_1_to_no_15  0x6301 
#define Loss_of_parameters					0x6310 
#define Parameter_error						0x6320 
#define Database_not_initialized			0x6380// Invalid application in flash
#define Data_out_of_flash_range				0x6381 
#define Bad_conf_tab_in_flash				0x6382//"Bad configuration table in flash" 
#define Param_module_not_exist				0x6383//"Module parameters dont exist"
#define HotDatabase_not_initialized			0x6384
#define HotParameter_not_initialized		0x6385
#define DeviceData_not_initialized			0x6386 // Device data in flash (SN) not initialized
#define Res_Calib_data_not_initialized		0x6387 // Calibration data (resolver) not initialized
#define Hardware_software_mismatch			0x6388 // Invalid software version for the device
#define Gyro_Calib_data_not_initialized		0x6389 // Calibration data (gyro) not initialized
#define Memorator_data_bad_format			0x6390 //"Bad format or checksum of memorator setup data in the flash"
#define Firmware_out_of_flash_range			0x6391 


#define Power  0x7100 
#define Brake_chopper  0x7110 
#define Failure_brake_chopper  0x7111 
#define Over_current_brake_chopper  0x7112 
#define Protective_circuit_brake_chopper  0x7113
 
#define Motor_err							0x7120 
#define Motor_blocked						0x7121 //motor stuck
#define Motor_error_or_commutation_malfunc  0x7122 
#define Motor_tilted						0x7123
#define Expt_AlignFault						0x7124 // autophasing fault
 
#define Measurement_circuit			0x7200 



#define Sensor_Error  0x7300 
#define Tacho_fault  0x7301 
#define Tacho_wrong_polarity  0x7302 
#define Resolver_1_fault  0x7303 
#define Resolver_2_fault  0x7304 
#define Incremental_sensor_1_fault  0x7305 
#define Incremental_sensor_2_fault  0x7306 
#define Incremental_sensor_3_fault  0x7307 
#define Sensor_Speed_Error  0x7310 // Velocity sensor fail
#define Sensor_Position_Error  0x7320  // Position sensor fail
#define Sensor_Fb_Modulo_Conflict				0x7380  // The sensor has limited range but the position feedback is set to count modulo 
#define Feedback_modulo_must_be_even			0x7381 // The modulo difference between max pos feedback and the minimum must be even 
#define Motion_max_and_min_fb_conflict			0x7382 // The maximum value of the position feedback is no bigger than the minimum value 
#define Feedback_range_exceeds_sensor_limit		0x7383 // The desired feedback range is greater than the sensor can provide
#define Expt_DHallMismatch						0x7384 
#define Expt_DHallSensorProblem					0x7385
#define Pos_sensor_resolution_OutOfRange		0x7386
#define Vel_sensor_resolution_OutOfRange		0x7387
#define Invalid_reference_range_for_abs_sensor  0x7388 // invalid reference limits for an absolute sensor
#define Resolver_ref_shift_out_of_range			0x7389   // resolver reference phase shift out of range
#define Resolver_ref_amp_out_of_range			0x738A   
#define Sensor_not_supported_by_hardware		0x738B   
#define Encoder_filter_out_of_range				0x738C   
#define Resolver_filter_out_of_range			0x738D   
#define Resolver_SC_ratio_out_of_range			0x738E   
#define Resolver_invalid_signal_range			0x738F   
#define AbsEncoder_filter_out_of_range			0x7390   
#define AbsEncoder_resolution_out_of_range		0x7391   
#define Invalid_halls_order						0x7392   // invalid halls order
#define Invalid_vel_sensor_mapping				0x7393   // Invalid vel sensor mapping
#define Invalid_commutation_sensor_mapping		0x7394   // Invalid commutation sensor mapping
#define Invalid_pos_sensor_mapping				0x7395   // Invalid position sensor mapping
#define Sensor_must_be_uninstalled				0x7396 // sensor must be uninstalled to be configured
#define Invalid_sensor_slot						0x7397 // invalid sensor slot
#define Invalid_hw_sensor_range					0x7398 // The sensor setup is bad - its reading range is non-positive 
#define Motion_max_and_min_ref_conflict			0x7399 // The maximum value of the position reference is no bigger than the minimum value 
#define Sensor_invalid_direction				0x739A // The sensor direction must be 1 or -1 
#define Lvdt_ref_shift_out_of_range				0x739B   // lvdt reference phase shift out of range
#define Lvdt_ref_amp_out_of_range				0x739C   // 
#define Lvdt_filter_out_of_range				0x739D   
#define Lvdt_SC_ratio_out_of_range				0x739E   
#define Lvdt_invalid_signal_range				0x739F   


#define Computation_circuit  		0x7400 
// 0x7480-74bf are reserved for Interpreter
// 0x74c0-74ff are reserved for user program

#define Communication_err  0x7500 
#define Serial_interface_no_1  0x7510 
#define Serial_interface_no_2  0x7520 
#define Serial_interface_no_1_rx_overrun		0x7580 //"Communication reciever overrun" 
#define Expt_Abort_Connection					0x7581
#define Invalid_commutation_type				0x7582 // Invalid commutation type
#define HotCpu_Communication_string_too_long	0x7583 
#define HotCpu_Communication_invalid_length		0x7584 
#define HotCpu_Communication_timeout			0x7585 
#define HotCpu_Communication_err_1				0x7586 // bad data length
#define HotCpu_Communication_err_2				0x7587 // bad preambule etc.
#define HotCpu_Communication_err_3				0x7588 
#define HotCpu_boot_Communication_timeout		0x7589		
#define HotCpu_rt_Communication_timeout			0x758a 
#define PowerSupply_rt_Communication_timeout	0x758b


#define Data_storage_at_external  0x7600 

#define Torque_control						0x8300 
#define Excess_torque						0x8311 
#define Difficult_start_up					0x8312 
#define Standstill_torque					0x8313 
#define Insufficient_torque					0x8321 
#define Torque_fault						0x8331
#define LoopType_must_be_torque				0x8380 // command is valid only in torque mode
#define Motor_RatedTorque_OutOfRange		0x8381 // The motor rated torque is out of the [1 ... 1000000] range 

#define Velocity_speed_controller			0x8400
#define Expt_SpeedLimit						0x8480 // speed feedback limits over 
#define Fb_velocity_out_of_range			0x8481 // invalid setting for speed feedback limits
#define Expt_SpeedErrorLimit				0x8482 // speed error limit 

 
#define Position_controller					0x8500
 
#define Positioning_controller				0x8600 
#define Following_error						0x8611	
#define Reference_limit						0x8612
#define Expt_PositionLimit					0x8680  // position feedback limits over
#define SpeedFeedForward_OutOfRange			0x8681  // The ratio between the speed ancoder and the position encoder must be in [2e-5 ... 5e4] 
#define MaxPosErr_OutOfRange				0x8682  // MaxPosErr  out of range
#define MaxAcc_OutOfRange					0x8683   // MaxAcc  out of range
#define GsPosErrGain_OutOfRange				0x8684   // GsPosErrGain  out of range
#define GsMode_OutOfRange					0x8685   // GsMode  out of range
#define GsMinSpeed_OutOfRange				0x8686   // GsMinSpeed  out of range
#define GsFilterUp_OutOfRange				0x8687   // GsBWUpHz  out of range
#define GsFilterDn_OutOfRange				0x8688   // GsBWDnHz  out of range
#define GsScale_OutOfRange					0x8689   // GsScale  out of range
#define Invalid_SpeedCtrlFlt_configuration	0x868a   // invalid SpeedCtrlFlt configuration
#define Invalid_PosCtrlFlt_configuration	0x868b   // invalid PosCtrlFlt configuration
#define MaxVelIn_OutOfRange					0x868c  // MaxVelIn  out of range

 
#define Sync_controller						0x8700 
#define Winding_controller					0x8800 
#define Process_data_monitoring				0x8900
 
#define Motion_Control						0x8A00 
#define Motor_profiler_not_ready 			0x8A80 // Motor profiler in not ready
#define Motor_torque_not_ready 				0x8A81 // Motor torque in not ready
#define Motor_RatedCurrent_OutOfRange		0x8A82	// The motor rated current is out of the [1 ... 1000000]  range 
#define Motor_peak_limit_OutOfRange			0x8A83	 // Peak limit is over motor rate
#define Motor_cont_limit_OutOfRange			0x8A84	 // Continuous limit is over motor rate
#define PrefStepLim_OutOfRange				0x8A85   // PrefStepLim out of range
#define PrefPoleHz_OutOfRange				0x8A86   // PrefPoleHz out of range
#define PrefOvershoot_OutOfRange			0x8A87   // PrefOvershoot out of range
#define CurrPoleHz_OutOfRange				0x8A88   // CurrPoleHz out of range
#define CurrPi_OutOfRange					0x8A89   // CurrKp or CurrKi out of range
#define MotorType_invalid					0x8A8a   // invalid MotorType



#define Deceleration								0xF001 
#define Sub_synchronous_run							0xF002 
#define Stroke_operation							0xF003 
#define Profile_Control								0xF004 
#define Motion_Queue_Block_Cant_Put					0xF080 // Attempt to put another target into a full motion queue
#define Profile_Data_Invalid						0xF081 // Profile data is invalid - acceleration, deceleration, or speed are non-positive
#define Request_Bad_ModeOfOperation					0xF082 // Request had been made for an invalid mode of operation (object 0x6060)
#define CSP_Mode_Not_Supported						0xF083 // Cyclic synchronous mode (by object 0x5007) is not supported
#define CSP_Home_State_Ilegal						0xF084 // Homing process reached an undefined state
#define Home_while_feedback_not_configured			0xF085 // Requested homing while the position feedback is not configured
#define Homing_Method_requires_Absolute				0xF086  // Homing on absolute ambigous sensor requires an absolute sensor
#define Homing_Method_requires_Index				0xF087 // The homing method requires a sensor with index, e.g. incremental encoder
#define Home_Process_Timed_out						0xF088 // Homing process timed out by violating the time set in object 0x5009
#define ConstSpeedCantBeZero						0xF089 // Internal profiler error - constant speed segment cant have zero speed
#define Homing_Method_unknown						0xF08a // The homing method is unknown
#define Homing_return_value_out_of_range			0xF08b // The homing return position must be inside of the mechanical limits
#define Homing_Method_requires_limited_ref			0xF08c // The homing method requires limited reference
#define Object_GearRatio_Den_orNum_Zero				0xF08D // The gear ratio (0x6091) is ilegal ; either numerator or denominator is zero 
#define Object_GearRatio_OutOfRange					0xF08E // The gear ratio (0x6091) is out of permitted range 
#define Num_Of_GearRatio_Must_Divide_ModuloRange	0xF08F  // In modulo system the numerator of the gear ratio does not divide the encoder modulo
#define User_Modulo_Range_Overflow					0xF090  // In modulo system, (gear * sensor modulo) overflows the maximum of 2^31 
#define Interpolation_TimeIndex_OutOfRange			0xF091 // The interpolation time index (Object 0x60c2.2) is out of range 
#define Interpolation_TimePeriod_OutOfRange			0xF092 // The interpolation time period (Object 0x60c2.1) is out of the [1..127] range 
#define Reference_range_exceeds_Feedback_range		0xF093 // The desired refence range is greater than the feedback range
#define Invalid_reference_range						0xF094  // The reference limit range is non-positive 
#define Modulo_init_limits_conflict					0xF095  // Modulo structure initialization with conflicting limits 
#define Expt_Invalid_Homing_Speeds_Or_Acc			0xF096
#define Home_switch_position_OutOf_feedback_range	0xF097 // Position at home switch must be inside the feedback limits
#define Ref_velocity_out_of_range					0xF098   
#define Ref_accel_out_of_range						0xF099   
#define Ref_decel_out_of_range						0xF09a   
#define Ref_emcy_accel_out_of_range					0xF09b   
#define Home_offset_out_of_modulo_limits			0xF09c
#define Acceleration_limiting_must_be_turned_off	0xF09d 


// Manufacturer specific codes 
#define Invalid_axis								0xff00 // invalid axis
#define Cant_reset_motor_be_fault					0xff01 
#define Motor_must_be_off	 						0xff02 // Motor must be off
#define Both_motors_must_be_off						0xff03 
#define Expt_ExternalInhibit						0xff04 
#define Expt_BadDataBase							0xff06 
#define LoopType_invalid							0xff07 // invalid setting for looptype
#define Expt_Aborted_By_Group_Peer					0xff0d 
#define Expt_Unknown_Forced_Action_code				0xff0e
#define Motor_Aborted_ByUser						0xff0f


// DFTServo definitioins
#define excpt_rec_mask_UNMASKED	0L // always free wheel

#define excpt_rec_mask_DHallSensorProblem	0x01
#define excpt_rec_mask_BridgeOverVoltage	0x02
#define excpt_rec_mask_BridgeUnderVoltage	0x04
#define excpt_rec_mask_PositionErrorLimit	0x08
#define excpt_rec_mask_MotorStuck			0x10
#define excpt_rec_PositionLimit				0x20
#define excpt_rec_SpeedLimit				0x40
#define excpt_rec_PeakOverCurrent			0x80
#define excpt_rec_mask_BridgeTemperature    0x100
#define excpt_rec_mask_BridgeShortCircuit	0x200
#define excpt_rec_mask_SupplyMonitor		0x400
#define excpt_rec_mask_AbortByGroupPeer		0x800

#define fatal_excpt_mask 0x200

// End of file

