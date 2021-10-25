--------------------------------------------------------------------------------
--! @file   SynchFIFO_test.vhd
--! @brief  test bench of SynchFIFO.vhd
--! @author Takehiro Shiozaki
--! @date   2014-04-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SynchFIFO_test is
end SynchFIFO_test;

architecture behavior of SynchFIFO_test is

    -- component Declaration for the Unit Under Test (UUT)

    component SynchFIFO
	 generic(
			G_WIDTH : integer;
			G_DEPTH : integer
			);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         DIN : in  std_logic_vector(G_WIDTH - 1 downto 0);
         WE : in  std_logic;
         FULL : out  std_logic;
         DOUT : out  std_logic_vector(G_WIDTH - 1 downto 0);
         RE : in  std_logic;
         EMPTY : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal DIN : std_logic_vector(31 downto 0) := (others => 'X');
   signal WE : std_logic := '0';
   signal RE : std_logic := '0';

 	--Outputs
   signal FULL : std_logic;
   signal DOUT : std_logic_vector(31 downto 0);
   signal EMPTY : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period * 0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: SynchFIFO
	generic map (
			G_WIDTH => 32,
			G_DEPTH => 2
	)
	port map (
          CLK => CLK,
          RESET => RESET,
          DIN => DIN,
          WE => WE,
          FULL => FULL,
          DOUT => DOUT,
          RE => RE,
          EMPTY => EMPTY
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

	procedure write_data(data : std_logic_vector(31 downto 0)) is
	begin
		wait until CLK'event and CLK = '1';
		DIN <= data after DELAY,
		       (others => 'X') after DELAY + CLK_period;
		WE <= '1' after DELAY,
				'0' after DELAY + CLK_period;
		wait for CLK_period * 2;
	end procedure;

	procedure read_data is
	begin
		wait until CLK'event and CLK = '1';
		RE <= '1' after DELAY,
		      '0' after DELAY + CLK_period;
		wait for CLK_period * 2;
	end procedure;

   begin
      reset_uut;

		write_data(X"01234567");
		write_data(X"89ABCDEF");
		write_data(X"76543210");
		write_data(X"FEDCBA98");

		read_data;
		read_data;
		read_data;
		read_data;

		RE <= '1' after DELAY;
		wait for CLK_period * 3;
		RE <= '0' after DELAY;

		write_data(X"01234567");
		write_data(X"89ABCDEF");
		write_data(X"76543210");
		write_data(X"FEDCBA98");

		WE <= '1' after DELAY;
		wait for CLK_period * 3;
		WE <= '0' after DELAY;

      wait;
   end process;

end;
