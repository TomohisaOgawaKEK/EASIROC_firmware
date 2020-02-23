--------------------------------------------------------------------------------
--! @file   AsynchRS_test.vhd
--! @brief  Test bench of AsynchRS.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-13
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity AsynchRS_test is
end AsynchRS_test;

architecture behavior of AsynchRS_test is

    -- component Declaration for the Unit Under Test (UUT)

    component AsynchRS
    port(
         S : in  std_logic;
         R : in  std_logic;
         Q : out std_logic
        );
    end component;


   --Inputs
   signal S : std_logic := '0';
   signal R : std_logic := '0';
   signal Q : std_logic;

	constant STEP : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: AsynchRS port map (
          S => S,
          R => R,
          Q => Q
        );

   -- Stimulus process
   stim_proc: process
   begin
		wait for STEP;

		R <= '1';
		wait for STEP;

		R <= '0';
		wait for STEP;

		S <= '1';
		wait for STEP;

		S <= '0';
		wait for STEP;

		R <= '1';
		wait for STEP;

		R <= '0';
		wait for STEP;

		S <= '1';
		R <= '1';
		wait for STEP;

		S <= '0';
		R <= '0';

      wait;
   end process;

end;
