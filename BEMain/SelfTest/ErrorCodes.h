#ifndef SELFTEST_ERRORCODES_H_
#define SELFTEST_ERRORCODES_H_

#define exp_bad_hall_value 0x900 // [Commutation:Fatal] {Bad Hall reading }
#define exp_hall_ilegal_delta 0x901 // [Commutation:Fatal] {Hall reading jump}
#define exp_over_voltage 0x902 // [Drive:Fatal] {DC voltage too high}
#define exp_under_voltage 0x903 // [Drive:Fatal] {DC voltage too low}
#define exp_overload 0x904 // [Drive:Fatal] {I2t overload}
#define exp_nan_in_control 0x905 // [Drive:Fatal] {Numerical exception NAN in controller }
#define exp_adc_offset_too_large 0x906 // [Drive:Fatal] {ADC offset of current measurement is too large }
#define exp_periodc_service_cut_while_on 0x907 // [Drive:Fatal] {The periodic service is off while motor is on }
#define exp_sto_event  0x908 // [Drive:Fatal] {STO event possibly disables gate drivers }
#define exp_sysmode_fault 0x909 // [Drive:Fatal] {Motor on on fault mode}
#define exp_expecting_sto 0x90a // [Drive:Fatal] {After stopping, shut motor as STO is expected}
#define exp_missing_calib 0x90b // [Drive:Fatal] {Calibration data is missing or bad}
#define exp_auto_mode_requires_closedloop 0x90c // [Drive:Fatal] {Loop closure mode is not sufficient for automatic action}
#define exp_encoder_hall_deviation  0x90d // [Commutation:Fatal] {Hall reading deviates from value expected from encoder reading}
#define exp_adc_offset_never_calculated 0x90e // [Drive:Fatal] {ADC offset was never calculated (speed or too much noise) }
#define exp_rough_synchronization 0x90f // [Drive:Fatal] {Too big synchronization event for steering axis}
#define exp_phase_overcurrent 0x910 // [Drive:Fatal] {Motor phase over current}
#define configuration_not_complete  0x911 // [Drive:Fatal] {Configuration must be completed}
#define exp_dc_bus_sc_trip 0x912 //[Drive:Fatal] {Short circuit trip on DC bus}
#define exp_voltage_out_range_trip 0x912 //[Drive:Fatal] {Voltage trip, either under or over voltage}
#define exp_voltage_ost_trip 0x912 //[Drive:Fatal] {Trip zone one shot trip, general reason}
#define exp_speed_nan 0x91c // [Drive:Fatal] {Speed calculation resulted in NaN}
#define exp_current_nan 0x91d // [Drive:Fatal] {Current control calculation resulted in NaN}
#define err_undefined_proj_id  0x91e // [Drive:Fatal] {Did not identify project ID}
#define err_bad_proj_pars  0x91f // [Drive:Fatal] {Could not calculate project parameters}
#define exp_ilegal_position_range 0x920 // [Drive:Fatal] {Contradicting position range specification}
#define exp_auto_mode_transition_requires_motoroff 0x921 // [Drive:Fatal] {Transition to automatic requires motor off}
#define exp_homing_with_abs_sensor 0x922 // [Drive:Fatal] {homing request where position is by absolute sensor}
#define exp_homing_too_faraway 0x923 // [Drive:Fatal] {homing drove unexpected long distance}
#define exp_pot_ref_failed 0x924 // [Drive:Fatal] {The feedback potentiometer reference failed}
#define exp_pos_error_limit 0x925 // [Drive:Fatal] {Position error limit exceeded}
#define exp_overtemperature 0x926 // [Drive:Fatal] {Temperature exceeds temperature limit}
#define exp_deviation_from_feedback_limit 0x937 // [Drive:Fatal] {Deviation from feedback limit range }
#define exp_reboot_request_submit 0x938 // [Drive:Fatal] {A reboot request is submitted }
#define exp_homing_not_supported 0x939 // [Drive:Fatal] {homing request where drive use case does not support homing}
#define exp_canthome_pot_ref_failed 0x940 // [Drive:Fatal] {The feedback potentiometer reference failed, cant home}
#define exp_lost_host_comm 0x941 // [Drive:Fatal] {Lost host communication}
#define exp_wheel_encoder_mismatch 0x942 // [Drive:Fatal] {Mismatch between main and secondary encoders}
#define exp_pot_encoder_mismatch 0x943 // [Drive:Fatal] {Potentiometer deviated too much from expected encoder change}
#define exp_unknown_pos_ref_mode 0x944  // [Drive:Fatal] {Unknown reference mode for position}
#define exp_fsi_message_failure 0x945 // [Drive:Fatal] {FSI message from interface card is missing }
#define exp_unidentified_safe_fault 0x946 // [Drive:Fatal] {Safe fault mode timed out without safe fault reason }
#define exp_unidentified_fault 0x947 // [Drive:Fatal] {Fatal fault without fault reason }
#define exp_homing_requires_calib 0x948 // [Drive:Fatal] {Homing requires calibration before }


#define ERR_RECORDER_BUF_USED 0x70 // [Interpreter:Error] {Recorder buffer is used for FW programming}
#define ERR_RECORDER_BAD_TRIGGER 0x71 // [Interpreter:Error] {Recorder bad trigger type}
#define ERR_REC_GET_OUT_OF_RANGE 0x72 // [Interpreter:Error] {Recorder Attempt to get unrecorded signal}
#define ERR_REC_BAD_GETRANGE 0x73 // [Interpreter:Error] {Recorder Attempt to get out of range signal indices}
#define ERR_NO_SIGNALS_TO_RECORD 0x74 // [Interpreter:Error] {Recorder No programmed signals to record}
#define ERR_RECORDER_BAD_SIGNAL 0x75 // [Interpreter:Error] {Recorder Illegal signal programming}
#define INTER_RECORDER_SET_ERR 0x76 // [Interpreter:Error] {Recorder setting error}
#define INTER_RECORDER_NO_SIGLIST 0x77 // [Interpreter:Error] {Recorder list of signals is empty}
#define INTER_RECORDER_SIGNAL_NOTPROG 0x78 // [Interpreter:Error] {A signal in the recorder list is empty}
#define INTER_RECORDER_SET_UNKNOWN_TRIGTYPE 0x79 // [Interpreter:Error] {Unknown recorder trigger type}

#define ERR_ONLY_FOR_MOTORON  -124// [Interpreter:Error] {This command can only be executed with the motor on }
#define ERR_IDENTITY_MISSING     -125// [Interpreter:Error] {Cannot switch to automatic mode if identity is undefined }
#define ERR_ONLY_FOR_MANUALMODE  -126// [Interpreter:Error] {This command can only be executed in manual mode }
#define ERR_CALIBRATION_MISSING  -127// [Interpreter:Error] {Drive has no valid calibrations file }
#define ERR_NORMALLY_UNSUPPORTED_CLOSURE -128 // [Interpreter:Error] {Unsupported closure mode (voltage mode is not normal and has a special object) }
#define ERR_IN_VOLTAGE_OPEN_LOOP -129 // [Interpreter:Error] {Cannot return from voltage mode to normal. Reset CPU. }
#define ERR_TOO_BIG_ADC_OFFSET -130 // [Interpreter:Error] {Cannot start because current measurement offsets are too large }
#define ERR_ONLY_FOR_MOTOROFF  -131// [Interpreter:Error] {This command can only be executed with the motor off }
#define ERR_COULD_NOT_BURN_CALIB -132// [Interpreter:Error] {Could not burn calibration parameters}
#define ERR_RESET_FAILURE_FIRST  -133// [Interpreter:Error] {You must reset the failure before starting the motor }
#define ERR_COULD_NOT_READ_CALIB -134// [Interpreter:Error] {Could not read calibration parameters from flash}
#define ERR_COULD_NOT_ERASE_OLD_CALIB -135 // [Interpreter:Error] {Could not erase calibration parameters from flash}
#define ERR_BAD_FLASH_CHECKSUM -136 // [Interpreter:Error] {Data in flash has bad checksum}
#define ERR_BAD_FLASH_PASSWORD -137 // [Interpreter:Error] {Data in flash has invalid password}
#define ERR_FAILED_TO_OWN_FLASH -138 // [Interpreter:Error] {Failed to own the flash resource}
#define ERR_FAILED_SERFLASH_READ -139 // [Interpreter:Error] {Could not read from flash over the SPI}
#define ERR_UNALIGNED_FLASH_ENTITIES -140 // [Interpreter:Error] {Flash parameters are not aligned}
#define ERR_ODD_LENGTH_IN_FLASH_ACTION -141 // [Interpreter:Error] {Flash read/write must be even amount of words}
#define ERR_SFLASH_INIT_FAILED -142 // [Interpreter:Error] {Flash is not usable, initialization failed}
#define ERR_OUT_OF_RANGE -143 // [Interpreter:Error] {Entered parameter is out of range}
#define ERR_ADC_OFFSET_NOCALC -144 // [Interpreter:Error] {Cannot start because ADC offset is not calculated}
#define ERR_DRIVE_NOCONFIG -145 // [Interpreter:Error] {Drive must be configures}
#define ERR_CLOSURE_MODE_NOT_SUPPORTED -146 // [Interpreter:Error] {This loop closure mode is not supported for this config }
#define ERR_SERIOUS_ERROR -147 // [Interpreter:Error] {A serious un-resetable error occurred }
#define ERR_FIXED_PARAMETER -148 // [Interpreter:Error] {Entered parameter is fixed and cant be edited}
#define ERR_COULD_NOT_ERASE_OLD_IDENTITY -149 // [Interpreter:Error] {Could not erase identity parameters from flash}
#define ERR_COULD_NOT_BURN_IDENTITY -150// [Interpreter:Error] {Could not burn identity parameters}
#define ERR_RECORDER_BUFF_IN_USE -151// [Interpreter:Error] {The recorder buffer is in use}
#define ERR_COULD_NOT_ERASE_OLD_PARAMS -152 // [Interpreter:Error] {Could not erase user parameters from flash}
#define ERR_COULD_NOT_BURN_PARAMS -153// [Interpreter:Error] {Could not burn user parameters to flash}
#define ERR_COULD_NOT_CLEAR_STAT -154// [Interpreter:Error] {Could not clear statistics sector of flash}
#define ERR_IN_SAFE_FAULT_PROC  -155// [Interpreter:Error] {Within a safe fault procedure }
#define ERR_AVAIL_ONLY_IF_HOMED -156 // [Interpreter:Error] {Dual position applicable only if homed}


#define exp_reset_fail_before_motoron  0xFF7B // [MotorOn:Error] {You must reset the failure before starting the motor}
#define exp_mon_adc_offset_too_large 0xFF7E  // [MotorOn:Error] {Cannot start because current measurement offsets are too large}
#define exp_mon_missing_identity 0xFF83 // [MotorOn:Error] {Cannot switch to automatic mode if identity is undefined}
#define exp_mon_serious_error 0xFF6D // [MotorOn:Error] {A serious un-resetable error occurred }
#endif
