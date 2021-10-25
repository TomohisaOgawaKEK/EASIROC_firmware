--------------------------------------------------------------------------------
--! @file   Delayer_test.vhd
--! @brief  Test bench of Delayer.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-13
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Delayer_test is
end Delayer_test;

architecture behavior of Delayer_test is

    -- component Declaration for the Unit Under Test (UUT)

    component Delayer
	 generic(
			G_CLK : integer
			);
    port(
         CLK : in  std_logic;
         DIN : in  std_logic;
         DOUT : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal DIN : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period * 0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: Delayer
	generic map(
			G_CLK => 5
			)
	port map (
          CLK => CLK,
          DIN => DIN,
          DOUT => DOUT
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
		wait until CLK'event and CLK = '1';
		wait for CLK_period;

		wait for CLK_period * 2;
		DIN <= '1' after DELAY;

      wait;
   end process;

end;
