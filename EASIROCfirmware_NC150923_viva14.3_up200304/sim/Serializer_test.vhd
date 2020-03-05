--------------------------------------------------------------------------------
--! @file   Serializer_test.vhd
--! @brief  Test bench of Serializer.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Serializer_test is
end Serializer_test;

architecture behavior of Serializer_test is

    -- component Declaration for the Unit Under Test (UUT)

    component Serializer
	 generic(
		G_BITS : integer
		);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         START : in  std_logic;
         BUSY : out  std_logic;
         DIN : in  std_logic_vector(G_BITS - 1 downto 0);
         DOUT : out  std_logic;
         CLK_OUT : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal START : std_logic := '0';
   signal DIN : std_logic_vector(23 downto 0) := (others => 'X');

 	--Outputs
   signal BUSY : std_logic;
   signal DOUT : std_logic;
   signal CLK_OUT : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   constant DELAY : time := CLK_period * 0.8;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: Serializer
		  generic map (
			 G_BITS => 24
		  )
		  port map (
          CLK => CLK,
          RESET => RESET,
          START => START,
          BUSY => BUSY,
          DIN => DIN,
          DOUT => DOUT,
          CLK_OUT => CLK_OUT
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
			wait for CLK_period;
		end procedure;

		procedure write_data
			( data : std_logic_vector(23 downto 0)
			)is
		begin
			START <= '1' after DELAY;
			DIN <= data  after DELAY;
			wait for CLK_period;

			START <= '0' after DELAY;
			DIN <= (others => 'X') after DELAY;
			wait until BUSY'event and BUSY = '0';
			wait for CLK_period;
		end procedure;

   begin
      reset_uut;
		write_data(X"012345");
		write_data(X"543210");

      wait;
   end process;

end;
