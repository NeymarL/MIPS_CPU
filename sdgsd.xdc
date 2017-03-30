set_property PACKAGE_PIN E3 [get_ports clock]
set_property IOSTANDARD LVCMOS33 [get_ports clock]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF]

set_property PACKAGE_PIN P4 [get_ports clear]
set_property IOSTANDARD LVCMOS33 [get_ports clear]

set_property PACKAGE_PIN U9 [get_ports choose[0]]
set_property IOSTANDARD LVCMOS33 [get_ports choose[0]]

set_property PACKAGE_PIN U8 [get_ports choose[1]]
set_property IOSTANDARD LVCMOS33 [get_ports choose[1]]

set_property PACKAGE_PIN L6 [get_ports eight_decode[0]]
set_property IOSTANDARD LVCMOS33 [get_ports eight_decode[0]]

set_property PACKAGE_PIN M2 [get_ports eight_decode[1]]
set_property IOSTANDARD LVCMOS33 [get_ports eight_decode[1]]

set_property PACKAGE_PIN K3 [get_ports eight_decode[2]]
set_property IOSTANDARD LVCMOS33 [get_ports eight_decode[2]]

set_property PACKAGE_PIN L4 [get_ports eight_decode[3]]
set_property IOSTANDARD LVCMOS33 [get_ports eight_decode[3]]

set_property PACKAGE_PIN L5 [get_ports eight_decode[4]]
set_property IOSTANDARD LVCMOS33 [get_ports eight_decode[4]]

set_property PACKAGE_PIN N1 [get_ports eight_decode[5]]
set_property IOSTANDARD LVCMOS33 [get_ports eight_decode[5]]

set_property PACKAGE_PIN L3 [get_ports eight_decode[6]]
set_property IOSTANDARD LVCMOS33 [get_ports eight_decode[6]]

# enable

set_property PACKAGE_PIN N6 [get_ports mie[0]]
set_property IOSTANDARD LVCMOS33 [get_ports mie[0]]

set_property PACKAGE_PIN M6 [get_ports mie[1]]
set_property IOSTANDARD LVCMOS33 [get_ports mie[1]]

set_property PACKAGE_PIN M3 [get_ports mie[2]]
set_property IOSTANDARD LVCMOS33 [get_ports mie[2]]

set_property PACKAGE_PIN N5 [get_ports mie[3]]
set_property IOSTANDARD LVCMOS33 [get_ports mie[3]]

set_property PACKAGE_PIN N2 [get_ports mie[4]]
set_property IOSTANDARD LVCMOS33 [get_ports mie[4]]

set_property PACKAGE_PIN N4 [get_ports mie[5]]
set_property IOSTANDARD LVCMOS33 [get_ports mie[5]]

set_property PACKAGE_PIN L1 [get_ports mie[6]]
set_property IOSTANDARD LVCMOS33 [get_ports mie[6]]

set_property PACKAGE_PIN M1 [get_ports mie[7]]
set_property IOSTANDARD LVCMOS33 [get_ports mie[7]]


 set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
 set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
 set_property SEVERITY {Warning} [get_drc_checks LUTLP-1]
