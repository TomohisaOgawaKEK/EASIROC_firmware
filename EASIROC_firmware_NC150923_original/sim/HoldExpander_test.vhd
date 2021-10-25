--------------------------------------------------------------------------------
--! @file   HoldExpander_test.vhd
--! @brief  Test bench of HoldExpandervhd
--! @author Takehiro Shiozaki
--! @date   2013-11-13
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity HoldExpander_test is
end HoldExpander_test;

architecture behavior of HoldExpander_test is

    -- component Declaration for the Unit Under Test (UUT)

    component HoldExpander
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         HOLD_IN : in  std_logic;
         HOLD_OUT_N : out  std_logic;
         ADC_BUSY : in  std_logic;
         IS_DAQ_MODE : in  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal HOLD_IN : std_logic := '0';
   signal ADC_BUSY : std_logic := '0';
   signal IS_DAQ_MODE : std_logic := '0';

 	--Outputs
   signal HOLD_OUT_N : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 40 ns;
	constant DELAY : time := CLK_period * 0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: HoldExpander port map (
          CLK => CLK,
          RESET => RESET,
          HOLD_IN => HOLD_IN,
          HOLD_OUT_N => HOLD_OUT_N,
          ADC_BUSY => ADC_BUSY,
          IS_DAQ_MODE => IS_DAQ_MODE
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
		wait until CLK'event and CLK = '1';
		wait for CLK_period;
		RESET <= '0' after DELAY;

		wait for CLK_period * 2;
		IS_DAQ_MODE <= '0' after DELAY;
		wait for CLK_period;
		HOLD_IN <= '1' after DELAY;
		wait for CLK_period;
		HOLD_IN <= '0' after DELAY;

		wait until HOLD_OUT_N = '1';
		wait until CLK'event and CLK = '1';
		wait for CLK_period;

		IS_DAQ_MODE <= '1' after DELAY;
		wait for CLK_period;

		HOLD_IN <= '1' after DELAY,
		           '0' after CLK_period + DELAY;
		wait for CLK_period * 10;
		ADC_BUSY <= '1' after DELAY,
		            '0' after CLK_period * 20 + DELAY;


      wait;
   end process;

end;
