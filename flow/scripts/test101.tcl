


################ Combination #####################
set match2 {CKINVDCx5p33_ASAP7_75t_SL CKINVDCx6p67_ASAP7_75t_SL CKINVDCx8_ASAP7_75t_SL CKINVDCx9p33_ASAP7_75t_SL CKINVDCx10_ASAP7_75t_SL CKINVDCx11_ASAP7_75t_SL CKINVDCx12_ASAP7_75t_SL CKINVDCx14_ASAP7_75t_SL CKINVDCx16_ASAP7_75t_SL CKINVDCx20_ASAP7_75t_SL}
#set match3 [lreplace $subsets 0 0 0]
set subsets [list [list]]
foreach e $match2 {
	foreach subset $subsets {
                lappend subsets [lappend subset $e]
        }
}

set xx {}
foreach aa $subsets {
	if {$aa != {}} { lappend xx $aa }
}

set ::cts_inverter_list_combination $xx
puts $::cts_inverter_list_combination
#################################################
