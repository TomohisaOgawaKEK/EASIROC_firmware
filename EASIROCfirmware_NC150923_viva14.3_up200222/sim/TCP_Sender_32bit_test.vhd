--------------------------------------------------------------------------------
--! @file   TCP_Sender_32bit_test.vhd
--! @brief  Test bench of TCP_Sender_32bit.vhd
--! @author Takehiro Shiozaki
--! @date   2014-04-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity TCP_Sender_32bit_test is
end TCP_Sender_32bit_test;

architecture behavior of TCP_Sender_32bit_test is

    -- component Declaration for the Unit Under Test (UUT)

    component TCP_Sender_32bit
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         DIN : in  std_logic_vector(31 downto 0);
         DOUT : out  std_logic_vector(7 downto 0);
         RE : out  std_logic;
         WE : out  std_logic;
         EMPTY : in  std_logic;
         AFULL : in  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal DIN : std_logic_vector(31 downto 0) := (others => 'X');
   signal EMPTY : std_logic := '0';
   signal AFULL : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic_vector(7 downto 0);
   signal RE : std_logic;
   signal WE : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period * 0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: TCP_Sender_32bit port map (
          CLK => CLK,
          RESET => RESET,
          DIN => DIN,
          DOUT => DOUT,
          RE => RE,
          WE => WE,
          EMPTY => EMPTY,
          AFULL => AFULL
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

		wait until RE = '1';
		wait until CLK'event and CLk = '1';
		DIN <= X"01234567" after DELAY,
		       (others => 'X') after DELAY + CLK_period;

		wait until RE = '1';
		wait until CLK'event and CLK = '1';
		DIN <= X"89ABCDEF" after DELAY,
		       (others => 'X') after DELAY + CLK_period;

		wait until RE = '1';
		wait until CLK'event and CLK = '1';
		DIN <= X"01234567" after DELAY,
		       (others => 'X') after DELAY + CLK_period;
		EMPTY <= '1' after DELAY;
		AFULL <= '1' after DELAY,
		         '0' after DELAY + CLK_period;

		wait until DOUT = X"45";
		EMPTY <= '0' after DELAY;
		AFULL <= '1' after DELAY;

		wait until RE = '1';
		wait until CLK'event and CLK = '1';
		DIN <= X"89ABCDEF" after DELAY,
		       (others => 'X') after DELAY + CLK_period;
		EMPTY <= '1' after DELAY;

		wait for CLK_period * 5;
		AFULL <= '0' after DELAY;

		wait until DOUT = X"EF" and WE = '0';
		wait for CLK_period * 2;
		EMPTY <= '0' after DELAY;

		wait until RE = '1';
		wait until CLK'event and CLK = '1';
		DIN <= X"01234567" after DELAY,
		       (others => 'X') after DELAY + CLK_period;
		EMPTY <= '1' after DELAY;

		wait for CLK_period * 2;
		wait until DOUT = X"67";
		EMPTY <= '0' after DELAY;

      wait;
   end process;

end;
