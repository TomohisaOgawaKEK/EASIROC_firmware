--------------------------------------------------------------------------------
--! @file   DFF_1Shot_test.vhd
--! @brief  Test bench of DFF_1Shot.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity DFF_1Shot_test is
end DFF_1Shot_test;

architecture behavior of DFF_1Shot_test is

    -- component Declaration for the Unit Under Test (UUT)

    component DFF_1Shot
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         D : in  std_logic;
         EN : in  std_logic;
         Q : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal D : std_logic := '0';
   signal EN : std_logic := '0';

 	--Outputs
   signal Q : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period*0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: DFF_1Shot port map (
          CLK => CLK,
          RESET => RESET,
          D => D,
          EN => EN,
          Q => Q
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

		D <= '1' after DELAY;
		EN <= '1' after DELAY;
		wait for CLK_period;
		D <= '0' after DELAY;
		EN <= '0' after DELAY;

      wait;
   end process;

end;
