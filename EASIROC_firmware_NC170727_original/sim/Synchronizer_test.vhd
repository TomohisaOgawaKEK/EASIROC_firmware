--------------------------------------------------------------------------------
--! @file   Synchronizer_test.vhd
--! @brief  Test bench of Synchronizer.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;

entity Synchronizer_test is
end Synchronizer_test;

architecture behavior of Synchronizer_test is

    -- component Declaration for the Unit Under Test (UUT)

    component Synchronizer
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
	constant DELAY : time := CLK_period * 0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: Synchronizer port map (
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

		procedure reset_uut is
		begin
			RESET <= '1';
			wait until CLK'event and CLK = '1';
			wait for CLK_period;
			RESET <= '0' after DELAY;
		end procedure;


   begin
		reset_uut;

		DIN <= '1' after CLK_period*0.5;
		wait for CLK_period*2;
		DIN <= '0' after CLK_period*0.5;

      wait;
   end process;

end;
