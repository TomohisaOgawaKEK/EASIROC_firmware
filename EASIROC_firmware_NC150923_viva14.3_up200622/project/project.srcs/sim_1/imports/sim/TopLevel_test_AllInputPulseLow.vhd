----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2020/01/26 15:12:50
-- Design Name:
-- Module Name: TopLevel_test_AllInputPulseLow - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:

-- 2020-01-25 by me
-- add 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel_test_AllInputPulseLow is
end TopLevel_test_AllInputPulseLow;

architecture Behavior of TopLevel_test_AllInputPulseLow is

    component TopLevel is
    port(
        EXTCLK50M : in  std_logic; -- External Clock(50MHz)
        -- AT93C46D
        EEPROM_CS : out std_logic; -- Chip select
        EEPROM_SK : out std_logic; -- Serial data clock
        EEPROM_DI : out std_logic; -- Serial write data
        EEPROM_DO : in  std_logic; -- Serial read data
        -- PHY(100Mbps only)
        ETH_RSTn   : out std_logic;
        ETH_TX_CLK : in  std_logic; -- Tx clock(2.5 or 25MHz)
        ETH_TX_EN  : out std_logic;
        ETH_TXD    : out std_logic_vector(3 downto 0);
        ETH_TX_ER  : out std_logic;
        ETH_RX_CLK : in  std_logic; -- Rx clock(2.5 or 25MHz)
        ETH_RX_DV  : in  std_logic;                    -- Rx data valid
        ETH_RXD    : in  std_logic_vector(3 downto 0); -- Rx data[7:0]
        ETH_RX_ER  : in  std_logic;                    -- Rx error
        ETH_CRS    : in  std_logic;                    -- Carrier sense
        ETH_COL    : in  std_logic;                    -- Collision detected
        ETH_MDC    : out std_logic;
        ETH_MDIO   : inout std_logic;
        ETH_LED    : out std_logic_vector(2 downto 1);
        DIP_SW     : in std_logic_vector(0 downto 0);  -- Load default parameters

        -- EASIROC1
        -- Direct Control
        EASIROC1_HOLDB    : out std_logic;
        EASIROC1_RESET_PA : out std_logic;
        EASIROC1_PWR_ON   : out std_logic;
        EASIROC1_VAL_EVT  : out std_logic;
        EASIROC1_RAZ_CHN  : out std_logic;
        -- Slow Control
        EASIROC1_CLK_SR    : out std_logic;
        EASIROC1_RSTB_SR   : out std_logic;
        EASIROC1_SRIN_SR   : out std_logic;
        EASIROC1_LOAD_SC   : out std_logic;
        EASIROC1_SELECT_SC : out std_logic;
        -- read register
        EASIROC1_CLK_READ   : out std_logic;
        EASIROC1_RSTB_READ  : out std_logic;
        EASIROC1_SRIN_READ  : out std_logic;
        -- ADC
        EASIROC1_ADC_CLK_HG  : out std_logic;
        EASIROC1_ADC_DATA_HG : in  std_logic_vector(11 downto 0);
        EASIROC1_ADC_OTR_HG  : in  std_logic;
        EASIROC1_ADC_CLK_LG  : out std_logic;
        EASIROC1_ADC_DATA_LG : in  std_logic_vector(11 downto 0);
        EASIROC1_ADC_OTR_LG  : in  std_logic;
        -- TDC
        EASIROC1_TRIGGER : in std_logic_vector(31 downto 0);

        -- EASIROC2
        -- Direct Control
        EASIROC2_HOLDB    : out std_logic;
        EASIROC2_RESET_PA : out std_logic;
        EASIROC2_PWR_ON   : out std_logic;
        EASIROC2_VAL_EVT  : out std_logic;
        EASIROC2_RAZ_CHN  : out std_logic;
        -- Slow Control
        EASIROC2_CLK_SR    : out std_logic;
        EASIROC2_RSTB_SR   : out std_logic;
        EASIROC2_SRIN_SR   : out std_logic;
        EASIROC2_LOAD_SC   : out std_logic;
        EASIROC2_SELECT_SC : out std_logic;
        -- read register
        EASIROC2_CLK_READ  : out std_logic;
        EASIROC2_RSTB_READ : out std_logic;
        EASIROC2_SRIN_READ : out std_logic;
        -- ADC
        EASIROC2_ADC_CLK_HG  : out std_logic;
        EASIROC2_ADC_DATA_HG : in  std_logic_vector(11 downto 0);
        EASIROC2_ADC_OTR_HG  : in  std_logic;
        EASIROC2_ADC_CLK_LG  : out std_logic;
        EASIROC2_ADC_DATA_LG : in  std_logic_vector(11 downto 0);
        EASIROC2_ADC_OTR_LG  : in  std_logic;
        -- TDC
        EASIROC2_TRIGGER : in std_logic_vector(31 downto 0);

        -- SPI FLASH
        SPI_SCLK  : out std_logic;
        SPI_SS_N  : out std_logic;
        SPI_MOSI  : out std_logic;
        SPI_MISO  : in  std_logic; -- SPI_FLASH_Programmer.vhd -> SPI_CommandSender.vhd ->
        PROG_B_ON : out std_logic;
        -- LED Control
        LED : out std_logic_vector(8 downto 1);
        -- Test charge injection
        CAL1    : out std_logic;
        CAL2    : out std_logic;
        PWR_RST : in  std_logic;
        -- Monitor ADC
        MUX       : out std_logic_vector(3 downto 0);
        MUX_EN    : out std_logic_vector(3 downto 0);
        CS_MADC   : out std_logic;
        DIN_MADC  : out std_logic;
        SCK_MADC  : out std_logic;
        DOUT_MADC : in  std_logic;
        -- HV Control
        SCK_DAC : out std_logic;
        SDI_DAC : out std_logic;
        CS_DAC  : out std_logic;
        HV_EN   : out std_logic;
        -- User I/O
        IN_FPGA         : in  std_logic_vector(6 downto 1);
        OUT_FPGA        : out std_logic_vector(5 downto 1);
        OR32_C1         : in  std_logic;
        OR32_C2         : in  std_logic;
        DIGITAL_LINE_C1 : in  std_logic;
        DIGITAL_LINE_C2 : in  std_logic
    );
    end component;

	signal EXTCLK50M : std_logic; -- External Clock(50MHz)
	-- AT93C46D
    signal EEPROM_CS : std_logic;
    signal EEPROM_SK : std_logic;
	signal EEPROM_DI : std_logic;
	signal EEPROM_DO : std_logic;
    -- PHY(100Mbps only)
	signal ETH_RSTn   : std_logic;
	signal ETH_TX_CLK : std_logic;
	signal ETH_TX_EN  : std_logic;
	signal ETH_TXD    : std_logic_vector(3 downto 0) := (others => '0');
	signal ETH_TX_ER  : std_logic;
	signal ETH_RX_CLK : std_logic;
 	signal ETH_RX_DV  : std_logic;
	signal ETH_RXD    : std_logic_vector(3 downto 0) := (others => '0');
	signal ETH_RX_ER  : std_logic;
	signal ETH_CRS    : std_logic;
	signal ETH_COL    : std_logic;
	signal ETH_MDC    : std_logic;
	signal ETH_MDIO   : std_logic;
	signal ETH_LED    : std_logic_vector(2 downto 1) := (others => '0');
	signal DIP_SW     : std_logic_vector(0 downto 0) := (others => '0');

    -- EASIROC1
    -- Direct Control
	signal EASIROC1_HOLDB    : std_logic;
	signal EASIROC1_RESET_PA : std_logic;
	signal EASIROC1_PWR_ON   : std_logic;
	signal EASIROC1_VAL_EVT  : std_logic;
	signal EASIROC1_RAZ_CHN  : std_logic;
    -- Slow Control
	signal EASIROC1_CLK_SR    : std_logic;
    signal EASIROC1_RSTB_SR   : std_logic;
    signal EASIROC1_SRIN_SR   : std_logic;
    signal EASIROC1_LOAD_SC   : std_logic;
    signal EASIROC1_SELECT_SC : std_logic;
    -- read register
    signal EASIROC1_CLK_READ   : std_logic;
    signal EASIROC1_RSTB_READ  : std_logic;
	signal EASIROC1_SRIN_READ  : std_logic;
    -- ADC
    signal EASIROC1_ADC_CLK_HG  : std_logic;
	signal EASIROC1_ADC_DATA_HG : std_logic_vector(11 downto 0) := (others => '0');
	signal EASIROC1_ADC_OTR_HG  : std_logic;
    signal EASIROC1_ADC_CLK_LG  : std_logic;
    signal EASIROC1_ADC_DATA_LG : std_logic_vector(11 downto 0) := (others => '0');
    signal EASIROC1_ADC_OTR_LG  : std_logic;
    -- TDC
    signal EASIROC1_TRIGGER     : std_logic_vector(31 downto 0) := (others => '0');

    -- EASIROC2
    -- Direct Control
    signal EASIROC2_HOLDB    : std_logic;
    signal EASIROC2_RESET_PA : std_logic;
    signal EASIROC2_PWR_ON   : std_logic;
    signal EASIROC2_VAL_EVT  : std_logic;
    signal EASIROC2_RAZ_CHN  : std_logic;
    -- Slow Control
    signal EASIROC2_CLK_SR    : std_logic;
    signal EASIROC2_RSTB_SR   : std_logic;
    signal EASIROC2_SRIN_SR   : std_logic;
    signal EASIROC2_LOAD_SC   : std_logic;
    signal EASIROC2_SELECT_SC : std_logic;
    -- read register
    signal EASIROC2_CLK_READ   : std_logic;
    signal EASIROC2_RSTB_READ  : std_logic;
    signal EASIROC2_SRIN_READ  : std_logic;
    -- ADC
    signal EASIROC2_ADC_CLK_HG  : std_logic;
    signal EASIROC2_ADC_DATA_HG : std_logic_vector(11 downto 0) := (others => '0');
    signal EASIROC2_ADC_OTR_HG  : std_logic;
    signal EASIROC2_ADC_CLK_LG  : std_logic;
    signal EASIROC2_ADC_DATA_LG : std_logic_vector(11 downto 0) := (others => '0');
    signal EASIROC2_ADC_OTR_LG  : std_logic;
    -- TDC
    signal EASIROC2_TRIGGER     : std_logic_vector(31 downto 0) := (others => '0');

    -- SPI FLASH
    signal SPI_SCLK  : std_logic;
    signal SPI_SS_N  : std_logic;
    signal SPI_MOSI  : std_logic;
    signal SPI_MISO  : std_logic;
    signal PROG_B_ON : std_logic;
  	-- LED Control
   	signal LED       : std_logic_vector(8 downto 1) := (others => '0');
    -- Test charge injection
  	signal CAL1      : std_logic;
    signal CAL2      : std_logic;
    signal PWR_RST   : std_logic;
    -- Monitor ADC
    signal MUX       : std_logic_vector(3 downto 0) := (others => '0');
    signal MUX_EN    : std_logic_vector(3 downto 0) := (others => '0');
    signal CS_MADC   : std_logic;
    signal DIN_MADC  : std_logic;
    signal SCK_MADC  : std_logic;
    signal DOUT_MADC : std_logic;
    -- HV Control
    signal SCK_DAC  : std_logic;
    signal SDI_DAC  : std_logic;
    signal CS_DAC   : std_logic;
    signal HV_EN    : std_logic;
    -- User I/O
   	signal IN_FPGA         : std_logic_vector(6 downto 1) := (others => '0');
    signal OUT_FPGA        : std_logic_vector(5 downto 1) := (others => '0');
    signal OR32_C1         : std_logic;
    signal OR32_C2         : std_logic;
    signal DIGITAL_LINE_C1 : std_logic;
    signal DIGITAL_LINE_C2 : std_logic;


    -- Clock period definitions
    constant CLK_period : time := 20 ns; -- 50Mhz
    constant EXT_CLK_period : time := 20 ns; 

begin

    uut: TopLevel
    --generic map(
    --    G_TESTCHARGE_ADDRESS => C_ADDR
    --)
    port map(
        EXTCLK50M  => EXTCLK50M, -- External Clock(50MHz)
        -- AT93C46D
        EEPROM_CS  => EEPROM_CS, -- out
        EEPROM_SK  => EEPROM_SK, -- out
        EEPROM_DI  => EEPROM_DI, -- out
        EEPROM_DO  => EEPROM_DO, -- in
        -- PHY(100Mbps only)
        ETH_RSTn   => ETH_RSTn,
        ETH_TX_CLK => ETH_TX_CLK,
        ETH_TX_EN  => ETH_TX_EN,
        ETH_TXD    => ETH_TXD,
        ETH_TX_ER  => ETH_TX_ER,
        ETH_RX_CLK => ETH_RX_CLK,
        ETH_RX_DV  => ETH_RX_DV,
        ETH_RXD    => ETH_RXD,
        ETH_RX_ER  => ETH_RX_ER,
        ETH_CRS    => ETH_CRS,
        ETH_COL    => ETH_COL,
        ETH_MDC    => ETH_MDC,
        ETH_MDIO   => ETH_MDIO,
        ETH_LED    => ETH_LED,
        DIP_SW     => DIP_SW,

        -- EASIROC1
        -- Direct Control
        EASIROC1_HOLDB     => EASIROC1_HOLDB,
        EASIROC1_RESET_PA  => EASIROC1_RESET_PA,
        EASIROC1_PWR_ON    => EASIROC1_PWR_ON,
        EASIROC1_VAL_EVT   => EASIROC1_VAL_EVT,
        EASIROC1_RAZ_CHN   => EASIROC1_RAZ_CHN,
        -- Slow Control
        EASIROC1_CLK_SR    => EASIROC1_CLK_SR,
        EASIROC1_RSTB_SR   => EASIROC1_RSTB_SR,
        EASIROC1_SRIN_SR   => EASIROC1_SRIN_SR,
        EASIROC1_LOAD_SC   => EASIROC1_LOAD_SC,
        EASIROC1_SELECT_SC => EASIROC1_SELECT_SC,
        -- read register
        EASIROC1_CLK_READ  => EASIROC1_CLK_READ,
        EASIROC1_RSTB_READ => EASIROC1_RSTB_READ,
        EASIROC1_SRIN_READ => EASIROC1_SRIN_READ,
        -- ADC
        EASIROC1_ADC_CLK_HG  => EASIROC1_ADC_CLK_HG,
        EASIROC1_ADC_DATA_HG => EASIROC1_ADC_DATA_HG,
        EASIROC1_ADC_OTR_HG  => EASIROC1_ADC_OTR_HG,
        EASIROC1_ADC_CLK_LG  => EASIROC1_ADC_CLK_LG,
        EASIROC1_ADC_DATA_LG => EASIROC1_ADC_DATA_LG, 
        EASIROC1_ADC_OTR_LG  => EASIROC1_ADC_OTR_LG,
        -- TDC
        EASIROC1_TRIGGER     => EASIROC1_TRIGGER,

        -- EASIROC2
        -- Direct Control
        EASIROC2_HOLDB     => EASIROC2_HOLDB,
        EASIROC2_RESET_PA  => EASIROC2_RESET_PA,
        EASIROC2_PWR_ON    => EASIROC2_PWR_ON,
        EASIROC2_VAL_EVT   => EASIROC2_VAL_EVT,
        EASIROC2_RAZ_CHN   => EASIROC2_RAZ_CHN,
        -- Slow Control
        EASIROC2_CLK_SR    => EASIROC2_CLK_SR,
        EASIROC2_RSTB_SR   => EASIROC2_RSTB_SR,
        EASIROC2_SRIN_SR   => EASIROC2_SRIN_SR,
        EASIROC2_LOAD_SC   => EASIROC2_LOAD_SC,
        EASIROC2_SELECT_SC => EASIROC2_SELECT_SC,
        -- read register
        EASIROC2_CLK_READ  => EASIROC2_CLK_READ,
        EASIROC2_RSTB_READ => EASIROC2_RSTB_READ,
        EASIROC2_SRIN_READ => EASIROC2_SRIN_READ,
        -- ADC
        EASIROC2_ADC_CLK_HG  => EASIROC2_ADC_CLK_HG,
        EASIROC2_ADC_DATA_HG => EASIROC2_ADC_DATA_HG,
        EASIROC2_ADC_OTR_HG  => EASIROC2_ADC_OTR_HG,
        EASIROC2_ADC_CLK_LG  => EASIROC2_ADC_CLK_LG,
        EASIROC2_ADC_DATA_LG => EASIROC2_ADC_DATA_LG,
        EASIROC2_ADC_OTR_LG  => EASIROC2_ADC_OTR_LG,
        -- TDC
        EASIROC2_TRIGGER     => EASIROC2_TRIGGER,

        -- SPI FLASH
        SPI_SCLK  => SPI_SCLK,
        SPI_SS_N  => SPI_SS_N,
        SPI_MOSI  => SPI_MOSI,
        SPI_MISO  => SPI_MISO,
        PROG_B_ON => PROG_B_ON,
        -- LED Control
        LED       => LED,
        -- Test charge injection
        CAL1      => CAL1,
        CAL2      => CAL2,
        PWR_RST   => PWR_RST,
        -- Monitor ADC
        MUX       => MUX,
        MUX_EN    => MUX_EN,
        CS_MADC   => CS_MADC,
        DIN_MADC  => DIN_MADC,
        SCK_MADC  => SCK_MADC,
        DOUT_MADC => DOUT_MADC,
        -- HV Control
        SCK_DAC => SCK_DAC,
        SDI_DAC => SDI_DAC,
        CS_DAC  => CS_DAC,
        HV_EN   => HV_EN,
        -- User I/O
        IN_FPGA         => IN_FPGA,
        OUT_FPGA        => OUT_FPGA,
        OR32_C1         => OR32_C1,
        OR32_C2         => OR32_C2,
        DIGITAL_LINE_C1 => DIGITAL_LINE_C1,
        DIGITAL_LINE_C2 => DIGITAL_LINE_C2 
	);

    -- Clock process definitions
   process
   begin -- 50Mhz
        EXTCLK50M <= '0';
        wait for CLK_period/2;
        EXTCLK50M <= '1';
        wait for CLK_period/2;
    end process;	

	-- Stimulus process definitions
    -- <82>�?<82>è<82>�?<82>¦<82>¸<83>v<83><8d><83>Z<83>X<82>�?<92>è<8b>`<82>·<82>é
    stim_proc: process

	--procedure reset_uut is        
	--end procedure;
	
    begin
        -- AT93C46D
        EEPROM_DO  <= '0'; -- low 
        -- PHY(100Mbps only)
		ETH_TX_CLK <= '0'; 
        ETH_RX_CLK <= '0';
        ETH_RX_DV  <= '0';
        ETH_RXD    <= (others => '0');
        ETH_RX_ER  <= '0'; -- Rx error
        ETH_CRS    <= '0'; -- Carrier sense
        ETH_COL    <= '0'; -- Collision detected
        DIP_SW     <= (others => '0'); -- Load default values

		-- CHIP1 ADC
		EASIROC1_ADC_DATA_HG <= (others => '0'); 
        EASIROC1_ADC_OTR_HG  <= '0';
        EASIROC1_ADC_DATA_LG <= (others => '0');
        EASIROC1_ADC_OTR_LG  <= '0';
        -- CHIP1 TDC
        EASIROC1_TRIGGER     <= (others => '0');
        -- CHIP2 ADC
        EASIROC2_ADC_DATA_HG <= (others => '0');
        EASIROC2_ADC_OTR_HG  <= '0';
        EASIROC2_ADC_DATA_LG <= (others => '0');
        EASIROC2_ADC_OTR_LG  <= '0';
        -- CHIP2 TDC
        EASIROC2_TRIGGER     <= (others => '0');

        -- SPI FLASH
        SPI_MISO <= '0'; -- low 
        -- Test charge injection 
		PWR_RST  <= '0'; -- low
        -- Monitor ADC
        DOUT_MADC<= '0'; -- low

		-- User I/O
        --HOLD       => IN_FPGA(1),
        --L1_TRIGGER => IN_FPGA(4),
        --L2_TRIGGER => IN_FPGA(3),
        --FAST_CLEAR => IN_FPGA(2),
        IN_FPGA         <= (others => '0'); -- low
        OR32_C1         <= '0'; -- low
        OR32_C2         <= '0'; -- low
        DIGITAL_LINE_C1 <= '0'; -- low
        DIGITAL_LINE_C2 <= '0'; -- low

		wait;
	end process;

end;
