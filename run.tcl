# ------------------------------------
# Clear previous settings
# ------------------------------------
clear -all



# ------------------------------------
# Enable Superlint only
# ------------------------------------
config_rtlds -rule -enable  -domain "LINT"
config_rtlds -rule -disable -domain "AUTO_FORMAL"
config_rtlds -rule -disable -category "NAMING FILEFORMAT"

# ------------------------------------
# Analyze RTL
# ------------------------------------
 analyze -verilog -f compile1.f

# ------------------------------------
# Elaborate design
# ------------------------------------
elaborate

# ------------------------------------
# Clock & Reset
# ------------------------------------
clock clk
reset rst
reset rst_im

# ------------------------------------
# Run Superlint
# ------------------------------------
check_superlint -extract

#---------------------------------------------
# Waivers
# ----------------------------------------------
#
check_superlint -waiver -add -tag ARY_MS_DRNG -comment "ordering of bit should be decending order but in memory the depth i used in ascending order so it can be ignored" 

check_superlint -waiver -add -tag CAS_NR_DEFX -comment "default value should be unknown but default condition for my design should be all zeros not unknoun values so this warning can be ignore" 

check_superlint -waiver -add -tag OTP_NR_ASYA -comment "output should be synchronous but which modules does not have clock, having this warning in output port and which module having clock, reading data is asynchronous. so this warning can be ignore . For BTB design The flagged output ports (rd_valid*, rd_tag*, rd_target*, rd_state*, hit*,predict_valid, predict_taken, predict_target) are intentionally driven by combinational logic as part of a zero-cycle BTB (Branch Target Buffer) fetch path. The BTB is accessed in the instruction fetch stage and must produce branch prediction results (hit, taken, target) in the same cycle as the PC.Registering these outputs would introduce an additional cycle of latency and violate the required branch prediction timing.This behavior is architecturally correct, synthesizable The asynchronous assignments are intentional, safe, and required by design." 

check_superlint -waiver -add -tag IDX_NR_DTTY -comment "index should be 2 state data type but in memory index is address which is of wire data type that is 4 state data type so this warning can be ignore" 

check_superlint -waiver -add -tag  INS_NR_INPR -comment "input should be register, but some inputs is taken from the combinational module so this warning can ignore" 

check_superlint -waiver -add -tag MOD_IS_SYAS -comment "having both synchronous and asynchronous logic, but writing to memory is synchronous and reading from memory is asynchronous.so this warning can be ignore. In modules such as BTB storage and dynamic branch predictor logic, combinational logic is used for same-cycle read paths and next-state computation, while sequential logic is used for state storage and updates. This separation is architecturally required to meet instruction fetch and branch prediction timing requirements. This mixed synchronous/asynchronous structure is intentional,synthesizable, and consistent with standard BTB and branch predictor implementations. No functional or timing risk exists." 



check_superlint -waiver -add -tag ASG_NR_POVF -comment "PC arithmetic overflow is intentional due to fixed 32-bit PC width; MSB truncation is architecturally valid.Arithmetic is modulo-XLEN by RISC-V spec. Overflow bits are intentionally discarded for PC, branch/jump targets, and ALU results"


check_superlint -waiver -add -tag MOD_NS_GLGC -comment "glue logic, but for synthesis we wand some output ports so glue logic is used"

check_superlint -waiver -add -tag FLP_NO_ASRT -comment "Register file flip-flops intentionally omit asynchronous reset. Register contents are architecturally undefined after reset and initialized by software. This reduces area and reset fanout."

check_superlint -waiver -add -tag NET_NO_LDDR -comment "Instruction and data memory arrays are initialized externally (HEX/mask ROM). Lint cannot infer these drivers; behavior is correct by design"

check_superlint -waive -add -tag MOD_NO_IPRG  -comment "Top-level inputs are registered in upstream logic"

#-------------------------------
#save report 
#------------------------------------

check_superlint -report -violation -property -order category -file  /home/sgeuser83/Desktop/sourabh/sd_lint/riscv_work/sd/database/riscv1.html -force -html -launch_html_browser -detailed -include_design_build


#redirect -file superlint_full_report1.txt {	    check_superlint -report	}

