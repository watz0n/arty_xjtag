###################################################################
#      JTAG Hex String Reorder Function for Xilinx JTAG Toolchain
#      Author: Watson Huang
#      Description:
#           Reorder hex string for Xilinx XSCT JTAG Sequence (UG1208)
#      Change Log:
#      01/28,  Reorder data by ILA raw data observation
###################################################################

# Xilinx JTAG hex data reorder function
proc jtag_reorder { data } {
    set l [string length $data]
    if {$l > 2} {
        set i [expr $l - 1]
        set s ""
        while {$i > -1} {
            if {$i > 0} {
                set s [concat $s[string range $data [expr {$i - 1}] $i]]
                set i [expr {$i - 2}]
            } else {
                set s [concat $s[expr 0][string index $data $i]]
                set i [expr {$i - 1}]
            }
        }
        return $s
    } else {
        return $data
    }
}