--------------------------------------------------------------------------------
--! @file   ReadRegister_test.vhd
--! @brief  Test bench of ReadRegister.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ResetManager_test is
end ResetManager_test;

architecture behavior of ResetManager_test is

    -- component Declaration for the Unit Under Test (UUT)

    component ResetManager
    port(
         CLK : in  std_logic;
         EXT_RESET : in  std_logic;
         PLL_LOCKED : in  std_logic;
         TCP_OPEN_ACK : in  std_logic;
         L1_RESET : out  std_logic;
         L2_RESET : out  std_logic;
         L3_RESET : out  std_logic;
         L4_RESET : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal EXT_RESET : std_logic := '1';
   signal PLL_LOCKED : std_logic := '0';
   signal TCP_OPEN_ACK : std_logic := '0';

 	--Outputs
   signal L1_RESET : std_logic;
   signal L2_RESET : std_logic;
   signal L3_RESET : std_logic;
   signal L4_RESET : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: ResetManager port map (
          CLK => CLK,
          EXT_RESET => EXT_RESET,
          PLL_LOCKED => PLL_LOCKED,
          TCP_OPEN_ACK => TCP_OPEN_ACK,
          L1_RESET => L1_RESET,
          L2_RESET => L2_RESET,
          L3_RESET => L3_RESET,
          L4_RESET => L4_RESET
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
		EXT_RESET <= '1';
		PLL_LOCKED <= '0';
		wait for 100 ns;
		EXT_RESET <= '0';
		wait for 200 ns;
		PLL_LOCKED <= '1';

		wait for 300 ns;
		TCP_OPEN_ACK <= '1';
		wait for 300 ns;
		TCP_OPEN_ACK <= '0';

      wait;
   end process;

end;
