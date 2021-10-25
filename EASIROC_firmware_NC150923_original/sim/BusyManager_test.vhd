--------------------------------------------------------------------------------
--! @file   BusyManager_test.vhd
--! @brief  Test bench of BusyManager.vhd
--! @author Takehiro Shiozaki
--! @date   2014-05-07
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity BusyManager_test is
end BusyManager_test;

architecture behavior of BusyManager_test is

    -- component Declaration for the Unit Under Test (UUT)

    component BusyManager
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         HOLD : in  std_logic;
         IS_DAQ_MODE : in  std_logic;
         ADC_BUSY : in  std_logic;
         TDC_BUSY : in  std_logic;
         BUSY : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal HOLD : std_logic := '0';
   signal IS_DAQ_MODE : std_logic := '0';
   signal ADC_BUSY : std_logic := '0';
   signal TDC_BUSY : std_logic := '0';

 	--Outputs
   signal BUSY : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: BusyManager port map (
          CLK => CLK,
          RESET => RESET,
          HOLD => HOLD,
          IS_DAQ_MODE => IS_DAQ_MODE,
          ADC_BUSY => ADC_BUSY,
          TDC_BUSY => TDC_BUSY,
          BUSY => BUSY
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
		RESET <= '1';
		wait for CLK_period;
		RESET <= '0';
		wait for CLK_period * 2;

		IS_DAQ_MODE <= '1';
		wait for CLK_period;
		HOLD <= '1',
		        '0' after CLK_period;

		wait for CLK_period;
		ADC_BUSY <= '1',
		            '0' after CLK_period * 5;
		TDC_BUSY <= '1',
		            '0' after CLK_period * 10;

      wait;
   end process;

end;
