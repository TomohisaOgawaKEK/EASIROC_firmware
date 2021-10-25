--------------------------------------------------------------------------------
--! @file   SynchronizerNbit_test.vhd
--! @brief  Test bench of SynchronizerNbit.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-06
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SynchronizerNbit_test is
end SynchronizerNbit_test;

architecture behavior of SynchronizerNbit_test is

    -- component Declaration for the Unit Under Test (UUT)

    component SynchronizerNbit
	 generic (
			G_BITS : integer
			);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         DIN : in  std_logic_vector(G_BITS - 1 downto 0);
         DOUT : out  std_logic_vector(G_BITS - 1 downto 0)
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal DOUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period*0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: SynchronizerNbit
	generic map(
			G_BITS => 8
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
		wait for CLK_period * 2;

		DIN <= X"5E" after DELAY;
		wait for CLK_period * 1.5;
		DIN <= X"7A" after DELAY;


      wait;
   end process;

end;
