--------------------------------------------------------------------------------
--! @file   DualPortRam_test.vhd
--! @brief  Test bench of DualPortRam.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-05
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity DualPortRam_test is
end DualPortRam_test;

architecture behavior of DualPortRam_test is

    -- component Declaration for the Unit Under Test (UUT)

    component DualPortRam
	 generic(
			G_WIDTH : integer;
			G_DEPTH : integer
			);
    port(
         WCLK : in  std_logic;
         DIN : in  std_logic_vector(G_WIDTH - 1 downto 0);
         WADDR : in  std_logic_vector(G_DEPTH - 1 downto 0);
         WE : in  std_logic;
         RCLK : in  std_logic;
         DOUT : out  std_logic_vector(G_WIDTH - 1 downto 0);
         RADDR : in  std_logic_vector(G_DEPTH - 1 downto 0)
        );
    end component;


   --Inputs
   signal WCLK : std_logic := '0';
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal WADDR : std_logic_vector(3 downto 0) := (others => '0');
   signal WE : std_logic := '0';
   signal RCLK : std_logic := '0';
   signal RADDR : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal DOUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant WCLK_period : time := 29 ns;
   constant RCLK_period : time := 13 ns;
	constant DELAY : time := 2 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: DualPortRam
	generic map (
			G_WIDTH => 8,
			G_DEPTH => 4
	)
	port map (
          WCLK => WCLK,
          DIN => DIN,
          WADDR => WADDR,
          WE => WE,
          RCLK => RCLK,
          DOUT => DOUT,
          RADDR => RADDR
        );

   -- Clock process definitions
   WCLK_process :process
   begin
		WCLK <= '0';
		wait for WCLK_period/2;
		WCLK <= '1';
		wait for WCLK_period/2;
   end process;

   RCLK_process :process
   begin
		RCLK <= '0';
		wait for RCLK_period/2;
		RCLK <= '1';
		wait for RCLK_period/2;
   end process;


   -- Stimulus process
   stim_proc: process

	procedure write_data(
		addr : std_logic_vector(3 downto 0);
		data : std_logic_vector(7 downto 0)
		) is
	begin
		wait until WCLK'event and WCLK = '1';
		WADDR <= addr after DELAY;
		DIN <= data after DELAY;
		WE <= '1' after DELAY;
		wait for WCLK_period;

		WADDR <= (others => '0') after DELAY;
		DIN <= (others => '0') after DELAY;
		WE <= '0' after DELAY;
		wait for WCLK_period;
	end procedure;

	procedure read_data(
		addr : std_logic_vector(3 downto 0)
		) is
	begin
		wait until RCLK'event and RCLK = '1';
		RADDR <= addr after DELAY;
		wait for RCLK_period * 2;
	end procedure;

   begin
		write_data(X"0", X"01");
		write_data(X"1", X"23");
		write_data(X"2", X"45");
		write_data(X"3", X"67");
		write_data(X"4", X"89");
		write_data(X"5", X"AB");
		write_data(X"6", X"CD");
		write_data(X"7", X"EF");
		write_data(X"8", X"01");
		write_data(X"9", X"23");
		write_data(X"A", X"45");
		write_data(X"B", X"67");
		write_data(X"C", X"89");
		write_data(X"D", X"AB");
		write_data(X"E", X"CD");
		write_data(X"F", X"EF");

		read_data(X"0");
		read_data(X"1");
		read_data(X"2");
		read_data(X"3");
		read_data(X"4");
		read_data(X"5");
		read_data(X"6");
      wait;
   end process;

end;
