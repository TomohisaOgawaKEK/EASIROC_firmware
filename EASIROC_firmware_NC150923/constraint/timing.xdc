## Timing Assertions Section

# Primary clocks
create_clock -name EXTCLK50M -period 20 [get_ports EXTCLK50M]
create_clock -name ETH_RX_CLK -period 40 [get_ports ETH_RX_CLK]
create_clock -name ETH_TX_CLK -period 40 [get_ports ETH_TX_CLK]

# Vertual clocks
create_clock -name vclk_6M -period 166.667
create_clock -name vclk_66M -period 15

# Generated clocks
create_generated_clock -name CLK_500M \
    [get_pins ClockManager_0/MMCM_0/MMCM_0/CLKOUT6]
create_generated_clock -name CLK_250M_0 \
    [get_pins ClockManager_0/MMCM_0/MMCM_0/CLKOUT1]
create_generated_clock -name CLK_250M_90 \
    [get_pins ClockManager_0/MMCM_0/MMCM_0/CLKOUT2]
create_generated_clock -name CLK_250M_180 \
    [get_pins ClockManager_0/MMCM_0/MMCM_0/CLKOUT3]
create_generated_clock -name CLK_250M_270 \
    [get_pins ClockManager_0/MMCM_0/MMCM_0/CLKOUT4]
create_generated_clock -name CLK_125M \
    [get_pins ClockManager_0/MMCM_0/MMCM_0/CLKOUT5]
create_generated_clock -name CLK_66M \
    [get_pins ClockManager_0/MMCM_0/MMCM_1/CLKOUT2]
create_generated_clock -name CLK_25M \
    [get_pins ClockManager_0/MMCM_0/MMCM_1/CLKOUT0]
create_generated_clock -name CLK_6M \
    [get_pins ClockManager_0/MMCM_0/MMCM_1/CLKOUT1]
create_generated_clock -name CLK_3M -source [get_pins ClockManager_0/Clk3M_reg/C] \
    -divide_by 2 [get_pins ClockManager_0/Clk3M_reg/Q]

# Clock Uncertainty and Jitter
set_input_jitter EXTCLK50M 0.002
set_input_jitter ETH_RX_CLK 0.002
set_input_jitter ETH_TX_CLK 0.002

# Input and output delay constraints
set_input_delay -clock [get_clocks ETH_RX_CLK] 28 \
    [get_ports -regexp ETH_(RXD|RX_DV|RX_ER)]
set_input_delay -clock [get_clocks vclk_6M] -min 8 \
    [get_ports -regexp EASIROC(1|2)_ADC_(DATA|OTR)_(H|L)G]
set_input_delay -clock [get_clocks vclk_6M] -max 19 \
    [get_ports -regexp EASIROC(1|2)_ADC_(DATA|OTR)_(H|L)G]
set_output_delay -clock [get_clocks ETH_TX_CLK] -max 12 \
    [get_ports -regexp ETH_(TXD|TX_EN|TX_ER)]
set_output_delay -clock [get_clocks ETH_TX_CLK] -min 0 \
    [get_ports -regexp ETH_(TXD|TX_EN|TX_ER)]

# Clock Groups
set_clock_groups -name asynch -asynchronous \
    -group {EXTCLK50M} \
    -group {CLK_500M CLK_250M_0 CLK_250M_90 CLK_250M_180 CLK_250M_270 CLK_125M} \
    -group {CLK_25M CLK_6M CLK_3M} \
    -group {CLK_66M} \
    -group {ETH_TX_CLK} \
    -group {ETH_RX_CLK} \
    -group {vclk_6M} \
    -group {vclk_66M}

## Timing Exceptions section
# False Paths
set_false_path -from [get_ports DIP_SW]
set_false_path -from [get_ports -regexp ETH_(COL|CRS)]
set_false_path -from [get_ports EEPROM_DO]
set_false_path -from [get_ports -regexp EASIROC(1|2)_TRIGGER]
set_false_path -from [get_ports SPI_MISO]
set_false_path -to [get_ports -regexp EASIROC(1|2)_HOLDB]
set_false_path -to [get_ports -regexp EASIROC(1|2)_RESET_PA]
set_false_path -to [get_ports -regexp EASIROC(1|2)_PWR_ON]
set_false_path -to [get_ports -regexp EASIROC(1|2)_VAL_EVT]
set_false_path -to [get_ports -regexp EASIROC(1|2)_RAZ_CHN]
set_false_path -to [get_ports -regexp EASIROC(1|2)_CLK_SR]
set_false_path -to [get_ports -regexp EASIROC(1|2)_RSTB_SR]
set_false_path -to [get_ports -regexp EASIROC(1|2)_SRIN_SR]
set_false_path -to [get_ports -regexp EASIROC(1|2)_LOAD_SC]
set_false_path -to [get_ports -regexp EASIROC(1|2)_SELECT_SC]
set_false_path -to [get_ports -regexp EASIROC(1|2)_CLK_READ]
set_false_path -to [get_ports -regexp EASIROC(1|2)_RSTB_READ]
set_false_path -to [get_ports -regexp EASIROC(1|2)_SRIN_READ]
set_false_path -to [get_ports ETH_RSTn]
set_false_path -to [get_ports -regexp EEPROM_(CS|DI)]
set_false_path -to [get_ports -regexp EASIROC(1|2)_ADC_CLK_(H|L)G]
set_false_path -to [get_ports EEPROM_SK]
set_false_path -to [get_ports SPI_SCLK]
set_false_path -to [get_ports SPI_MOSI]
set_false_path -to [get_ports SPI_SS_N]
set_false_path -to [get_cells -hierarchical *DoubleFFSynchronizerFF1]
set_false_path -from [get_pins ResetManager_0/DelayedTcpOpenAckBothEdge_reg/C]
set_false_path -from [get_clocks CLK_500M] -to [get_clocks CLK_25M]
set_false_path -from [get_clocks CLK_25M] -to [get_clocks CLK_500M]
set_false_path -from [get_clocks CLK_25M] -to [get_clocks CLK_6M]
set_false_path -from [get_clocks CLK_500M] -to [get_clocks CLK_250M_*]
set_false_path -to [get_ports PROG_B_ON]
set_false_path -to [get_ports LED]
set_false_path -to [get_ports MUX]
set_false_path -to [get_ports MUX_EN]
set_false_path -to [get_ports -regexp (CS|DIN|SCK)_MADC]
set_false_path -to [get_ports ETH_LED]
set_false_path -to [get_ports -regexp (SCK|SDI|CS)_DAC]
set_false_path -to [get_ports HV_EN]
set_false_path -from [get_ports IN_FPGA]
set_false_path -to [get_ports OUT_FPGA]
set_false_path -from [get_ports DOUT_MADC]
set_false_path -from [get_ports -regexp OR32_(C1|C2)]
set_false_path -from [get_ports -regexp DIGITAL_LINE_(C1|C2)]

# Max Delay / Min Delay

# Multicycle Paths
set_multicycle_path 2 -setup -from [get_clocks CLK_250M_270] -to [get_clocks CLK_250M_0]

# Case Analysis
# Disable Timing
