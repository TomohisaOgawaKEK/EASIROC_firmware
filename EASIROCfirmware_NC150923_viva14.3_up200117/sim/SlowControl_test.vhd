--------------------------------------------------------------------------------
--! @file   SlowControl_test.vhd
--! @brief  Test bench of SlowControl.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SlowControl_test is
end SlowControl_test;

architecture behavior of SlowControl_test is

    -- component Declaration for the Unit Under Test (UUT)

    component SlowControl
	 generic(
		G_SLOW_CONTROL_ADDR : std_logic_vector(31 downto 0)
		);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         SLOW_CONTROL_CLK : in  std_logic;
         RBCP_ACT : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         RBCP_WE : in  std_logic;
         RBCP_WD : in  std_logic_vector(7 downto 0);
         RBCP_ACK : out  std_logic;
         START_CYCLE : in  std_logic;
         SELECT_SC : in  std_logic;
         SRIN_SR : out  std_logic;
         CLK_SR : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal SLOW_CONTROL_CLK : std_logic := '0';
   signal RBCP_ACT : std_logic := '0';
   signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal RBCP_WE : std_logic := '0';
   signal RBCP_WD : std_logic_vector(7 downto 0) := (others => '0');
   signal START_CYCLE : std_logic := '0';
   signal SELECT_SC : std_logic := '0';

 	--Outputs
   signal RBCP_ACK : std_logic;
   signal SRIN_SR : std_logic;
   signal CLK_SR : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 40 ns;
   constant SLOW_CONTROL_CLK_period : time := 400 ns;
	constant DELAY : time := 3 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: SlowControl
	generic map(
		G_SLOW_CONTROL_ADDR => X"00000001"
		)
	port map (
          CLK => CLK,
          RESET => RESET,
          SLOW_CONTROL_CLK => SLOW_CONTROL_CLK,
          RBCP_ACT => RBCP_ACT,
          RBCP_ADDR => RBCP_ADDR,
          RBCP_WE => RBCP_WE,
          RBCP_WD => RBCP_WD,
          RBCP_ACK => RBCP_ACK,
          START_CYCLE => START_CYCLE,
          SELECT_SC => SELECT_SC,
          SRIN_SR => SRIN_SR,
          CLK_SR => CLK_SR
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

   SLOW_CONTROL_CLK_process :process
   begin
		SLOW_CONTROL_CLK <= '0';
		wait for SLOW_CONTROL_CLK_period/2;
		SLOW_CONTROL_CLK <= '1';
		wait for SLOW_CONTROL_CLK_period/2;
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

		procedure write_data
		(
			addr : std_logic_vector(31 downto 0);
			data : std_logic_vector(7 downto 0)
		) is
		begin
			wait for CLK_period;
			RBCP_ACT <= '1' after DELAY;
			wait for CLK_period*2;

			RBCP_ADDR <= addr after DELAY;
			RBCP_WE <= '1' after DELAY;
			RBCP_WD <= data after DELAY;
			wait for CLK_period;

			RBCP_ADDR <= (others => '0') after DELAY;
			RBCP_WE <= '0' after DElAY;
			RBCP_WD <= (others => '0') after DELAY;

			wait until RBCP_ACK'event and RBCP_ACK = '1';
			wait for CLK_period;
			RBCP_ACT <= '0' after DELAY;
		end procedure;

		procedure select_slow_control is
		begin
			SELECT_SC <= '1' after DELAY;
			wait for CLK_period;
		end procedure;

		procedure select_probe is
		begin
			SELECT_SC <= '0' after DELAY;
			wait for CLK_period;
		end procedure;

		procedure start_transmit is
		begin
			START_CYCLE <= '1' after DELAY;
			wait for CLK_period * 10;
			START_CYCLE <= '0' after DELAY;
		end procedure;

   begin
      reset_uut;
		select_slow_control;
		write_data(X"00000001", X"01");
		write_data(X"00000002", X"23");
		write_data(X"00000003", X"45");
		write_data(X"00000004", X"67");
		write_data(X"00000005", X"89");
		write_data(X"00000006", X"ab");
		write_data(X"00000007", X"cd");
		write_data(X"00000008", X"ef");
		write_data(X"00000009", X"01");
		write_data(X"0000000a", X"23");
		write_data(X"0000000b", X"45");
		write_data(X"0000000c", X"67");
		write_data(X"0000000d", X"89");
		write_data(X"0000000e", X"ab");
		write_data(X"0000000f", X"cd");
		write_data(X"00000010", X"ef");
		write_data(X"00000011", X"01");
		write_data(X"00000012", X"23");
		write_data(X"00000013", X"45");
		write_data(X"00000014", X"67");
		write_data(X"00000015", X"89");
		write_data(X"00000016", X"ab");
		write_data(X"00000017", X"cd");
		write_data(X"00000018", X"ef");
		write_data(X"00000019", X"01");
		write_data(X"0000001a", X"23");
		write_data(X"0000001b", X"45");
		write_data(X"0000001c", X"67");
		write_data(X"0000001d", X"89");
		write_data(X"0000001e", X"ab");
		write_data(X"0000001f", X"cd");
		write_data(X"00000020", X"ef");
		write_data(X"00000021", X"01");
		write_data(X"00000022", X"23");
		write_data(X"00000023", X"45");
		write_data(X"00000024", X"67");
		write_data(X"00000025", X"89");
		write_data(X"00000026", X"ab");
		write_data(X"00000027", X"cd");
		write_data(X"00000028", X"ef");
		write_data(X"00000029", X"01");
		write_data(X"0000002a", X"23");
		write_data(X"0000002b", X"45");
		write_data(X"0000002c", X"67");
		write_data(X"0000002d", X"89");
		write_data(X"0000002e", X"ab");
		write_data(X"0000002f", X"cd");
		write_data(X"00000030", X"ef");
		write_data(X"00000031", X"01");
		write_data(X"00000032", X"23");
		write_data(X"00000033", X"45");
		write_data(X"00000034", X"67");
		write_data(X"00000035", X"89");
		write_data(X"00000036", X"ab");
		write_data(X"00000037", X"cd");
		write_data(X"00000038", X"ef");
		write_data(X"00000039", X"01");

		wait for SLOW_CONTROL_CLK_period * 2;
		start_transmit;

      wait;
   end process;

end;
