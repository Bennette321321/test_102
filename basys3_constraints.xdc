# Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Reset button (Center)
set_property PACKAGE_PIN W19 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# Buttons
set_property PACKAGE_PIN U18 [get_ports btnc]
set_property IOSTANDARD LVCMOS33 [get_ports btnc]

set_property PACKAGE_PIN T18 [get_ports btnu]
set_property IOSTANDARD LVCMOS33 [get_ports btnu]

set_property PACKAGE_PIN U17 [get_ports btnd]
set_property IOSTANDARD LVCMOS33 [get_ports btnd]

# SD Card SPI Interface (PMOD JA)
# CS (Chip Select)
set_property PACKAGE_PIN J1 [get_ports cs]
set_property IOSTANDARD LVCMOS33 [get_ports cs]

# SCK (Clock)
set_property PACKAGE_PIN L2 [get_ports sclk]
set_property IOSTANDARD LVCMOS33 [get_ports sclk]

# MOSI (Master Out Slave In)
set_property PACKAGE_PIN J2 [get_ports mosi]
set_property IOSTANDARD LVCMOS33 [get_ports mosi]

# MISO (Master In Slave Out)
set_property PACKAGE_PIN G2 [get_ports miso]
set_property IOSTANDARD LVCMOS33 [get_ports miso]

# VGA Interface
set_property PACKAGE_PIN C17 [get_ports v_sync]
set_property IOSTANDARD LVCMOS33 [get_ports v_sync]

set_property PACKAGE_PIN B17 [get_ports h_sync]
set_property IOSTANDARD LVCMOS33 [get_ports h_sync]

# VGA RGB (12-bit)
set_property PACKAGE_PIN A3 [get_ports {rgb[0]}]
set_property PACKAGE_PIN B4 [get_ports {rgb[1]}]
set_property PACKAGE_PIN C5 [get_ports {rgb[2]}]
set_property PACKAGE_PIN A4 [get_ports {rgb[3]}]
set_property PACKAGE_PIN B5 [get_ports {rgb[4]}]
set_property PACKAGE_PIN A5 [get_ports {rgb[5]}]
set_property PACKAGE_PIN E6 [get_ports {rgb[6]}]
set_property PACKAGE_PIN B7 [get_ports {rgb[7]}]
set_property PACKAGE_PIN C7 [get_ports {rgb[8]}]
set_property PACKAGE_PIN D7 [get_ports {rgb[9]}]
set_property PACKAGE_PIN E7 [get_ports {rgb[10]}]
set_property PACKAGE_PIN F7 [get_ports {rgb[11]}]

set_property IOSTANDARD LVCMOS33 [get_ports {rgb[*]}]

# PMOD JA Power Pins
set_property PACKAGE_PIN J4 [get_ports {pmod_ja[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_ja[0]}]
set_property PACKAGE_PIN L4 [get_ports {pmod_ja[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_ja[1]}]

# Clock constraints
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# Set false paths for buttons
set_false_path -from [get_ports {btn*}] -to [get_pins */state_reg*/D]
set_false_path -from [get_ports btn*] -to [get_pins */blend_factor_reg*/D]

# Set drive strength for all outputs
set_property DRIVE 12 [get_ports {rgb[*]}]
set_property DRIVE 12 [get_ports h_sync]
set_property DRIVE 12 [get_ports v_sync]
set_property DRIVE 12 [get_ports cs]
set_property DRIVE 12 [get_ports sclk]
set_property DRIVE 12 [get_ports mosi]

# Set slew rate for all outputs
set_property SLEW SLOW [get_ports {rgb[*]}]
set_property SLEW SLOW [get_ports h_sync]
set_property SLEW SLOW [get_ports v_sync]
set_property SLEW SLOW [get_ports cs]
set_property SLEW SLOW [get_ports sclk]
set_property SLEW SLOW [get_ports mosi]

set_property PACKAGE_PIN R2 [get_ports btnc]
set_property PACKAGE_PIN N19 [get_ports {rgb[11]}]
set_property PACKAGE_PIN J19 [get_ports {rgb[10]}]
set_property PACKAGE_PIN H19 [get_ports {rgb[9]}]
set_property PACKAGE_PIN G19 [get_ports {rgb[8]}]
set_property PACKAGE_PIN D17 [get_ports {rgb[7]}]
set_property PACKAGE_PIN G17 [get_ports {rgb[6]}]
set_property PACKAGE_PIN H17 [get_ports {rgb[5]}]
set_property PACKAGE_PIN J17 [get_ports {rgb[4]}]
set_property PACKAGE_PIN J18 [get_ports {rgb[3]}]
set_property PACKAGE_PIN K18 [get_ports {rgb[2]}]
set_property PACKAGE_PIN L18 [get_ports {rgb[1]}]
set_property PACKAGE_PIN N18 [get_ports {rgb[0]}]
