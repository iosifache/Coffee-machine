## Set combinational loops
set_property ALLOW_COMBINATORIAL_LOOPS TRUE

## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports clk]; 
create_clock -add -name sys_clk_pin -period 10 -waveform {0 5} [get_ports clk];

## Switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports black]; 
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports irish]; 
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports latte]; 

## LEDs
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports slower_clock]; 
set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports LED_B]; 
set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports LED_G]; 
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports LED_R]; 

## 7 segment display
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports segments_from_bcd[6]]; 
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports segments_from_bcd[5]]; 
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports segments_from_bcd[4]]; 
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports segments_from_bcd[3]]; 
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports segments_from_bcd[2]]; 
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports segments_from_bcd[1]]; 
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports segments_from_bcd[0]]; 
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports dot]; 
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports anode_from_bcd[0]]; 
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports anode_from_bcd[1]]; 
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports anode_from_bcd[2]];
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports anode_from_bcd[3]]; 
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports anode_from_bcd[4]]; 
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports anode_from_bcd[5]]; 
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports anode_from_bcd[6]]; 
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports anode_from_bcd[7]]; 

## Buttons
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports reset]; 
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports banknote]; 
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports coin]; 