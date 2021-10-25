--------------------------------------------------------------------------------
--! @file   PulseExtender_test.vhd
--! @brief  Test bench of PulseExtender.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity PulseExtender_test is
end PulseExtender_test;

architecture behavior of PulseExtender_test is

    -- component Declaration for the Unit Under Test (UUT)

    component PulseExtender
	 generic(
			G_WIDTH : integer
			);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         DIN : in  std_logic;
         DOUT : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal DIN : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period*0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: PulseExtender
	generic map (
		G_WIDTH => 5
	)
	port map (
          CLK => CLK,
          RESET => RESET,
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
      RESET <= '1';
		wait until CLK'event and CLK = '1';
		wait for CLK_period;
		RESET <= '0' after DELAY;
		wait for CLK_period;

		DIN <= '1' after DELAY;
		wait for CLK_period;
		DIN <= '0' after DELAY;

      wait;
   end process;

end;
