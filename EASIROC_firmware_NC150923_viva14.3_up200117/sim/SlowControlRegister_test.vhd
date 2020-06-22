--------------------------------------------------------------------------------
--! @file   SlowControlRegister_test.vhd
--! @brief  Test bench of SlowControlRegister.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SlowControlRegister_test is
end SlowControlRegister_test;

architecture behavior of SlowControlRegister_test is

    -- component Declaration for the Unit Under Test (UUT)

    component SlowControlRegister
    port(
         WCLK : in  std_logic;
         DIN : in  std_logic_vector(7 downto 0);
         WADDR : in  std_logic_vector(5 downto 0);
         WE : in  std_logic;
         RCLK : in  std_logic;
         DOUT : out  std_logic_vector(7 downto 0);
         RADDR : in  std_logic_vector(5 downto 0)
        );
    end component;


   --Inputs
   signal WCLK : std_logic := '0';
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal WADDR : std_logic_vector(5 downto 0) := (others => '0');
   signal WE : std_logic := '0';
   signal RCLK : std_logic := '0';
   signal RADDR : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal DOUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant WCLK_period : time := 13 ns;
   constant RCLK_period : time := 17 ns;
	constant DELAY : time := 3 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: SlowControlRegister port map (
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

	procedure write_data
		(data : std_logic_vector(7 downto 0);
		 addr : std_logic_vector(5 downto 0)
		 ) is
	begin
		wait until WCLK'event and WCLK = '1';
		DIN <= data after DELAY;
		WADDR <= addr after DELAY;
		WE <= '1' after DELAY;
		wait for WCLK_period;
		DIN <= (others => 'X') after DELAY;
		WADDR <= addr after DELAY;
		WE <= '0' after DELAY;
		wait for WCLK_period;
	end procedure;

	procedure read_data
		(addr : std_logic_vector(5 downto 0)
		) is
	begin
		wait until RCLK'event and RCLK = '1';
		RADDR <= addr after DELAY;
		wait for RCLK_period;
		RADDR <= (others => 'X') after DELAY;
	end procedure;

   begin
		write_data(X"12", "000000");
		write_data(X"34", "000010");
		read_data("000000");
		read_data("000001");
		read_data("000010");
		read_data("000011");
		wait;
   end process;

end;
