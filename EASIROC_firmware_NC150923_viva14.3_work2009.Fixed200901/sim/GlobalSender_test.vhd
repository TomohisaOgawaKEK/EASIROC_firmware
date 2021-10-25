--------------------------------------------------------------------------------
--! @file   GlobalSender_test.vhd
--! @brief  test bench of GlobalSender.vhd
--! @author Takehiro Shiozaki
--! @date   2014-05-07
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity GlobalSender_test is
end GlobalSender_test;

architecture behavior of GlobalSender_test is

    -- component Declaration for the Unit Under Test (UUT)

    component GlobalSender
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         DIN : in  std_logic_vector(31 downto 0);
         WE : in  std_logic;
         FULL : out  std_logic;
         TCP_TX_DATA : out  std_logic_vector(7 downto 0);
         TCP_TX_WR : out  std_logic;
         TCP_TX_FULL : in  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal DIN : std_logic_vector(31 downto 0) := (others => '0');
   signal WE : std_logic := '0';
   signal TCP_TX_FULL : std_logic := '0';

 	--Outputs
   signal FULL : std_logic;
   signal TCP_TX_DATA : std_logic_vector(7 downto 0);
   signal TCP_TX_WR : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period * 0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: GlobalSender port map (
          CLK => CLK,
          RESET => RESET,
          DIN => DIN,
          WE => WE,
          FULL => FULL,
          TCP_TX_DATA => TCP_TX_DATA,
          TCP_TX_WR => TCP_TX_WR,
          TCP_TX_FULL => TCP_TX_FULL
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
		wait until CLK'event and CLK = '1';

		wait for CLK_period;
		WE <= '1' after DELAY;
		DIN <= X"01234567" after DELAY;

		wait for CLK_period;
		DIN <= X"89ABCDEF" after DELAY;

		wait for CLK_period;
		DIN <= X"76543210" after DELAY;

		wait for CLK_period;
		DIN <= X"FEDCBA98" after DELAY;

		wait for CLK_period;
		WE <= '0' after DELAY;

      wait;
   end process;

end;
