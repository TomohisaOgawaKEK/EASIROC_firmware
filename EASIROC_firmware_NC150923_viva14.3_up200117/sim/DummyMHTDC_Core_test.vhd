--------------------------------------------------------------------------------
--! @file   DummyMHTDC_Core_test.vhd
--! @brief  test bench of DummyMHTDC_Core.vhd
--! @author Takehiro Shiozaki
--! @date   2014-04-30
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity DummyMHTDC_Core_test is
end DummyMHTDC_Core_test;

architecture behavior of DummyMHTDC_Core_test is

    -- component Declaration for the Unit Under Test (UUT)

    component DummyMHTDC_Core
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         DOUT : out  std_logic_vector(19 downto 0);
         WADDR : out  std_logic_vector(9 downto 0);
         WE : out  std_logic;
         WCOMP : out  std_logic;
         FULL : in  std_logic;
         COMMON_STOP : in  std_logic;
         BUSY : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal FULL : std_logic := '0';
   signal COMMON_STOP : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic_vector(19 downto 0);
   signal WADDR : std_logic_vector(9 downto 0);
   signal WE : std_logic;
   signal WCOMP : std_logic;
   signal BUSY : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period * 0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: DummyMHTDC_Core port map (
          CLK => CLK,
          RESET => RESET,
          DOUT => DOUT,
          WADDR => WADDR,
          WE => WE,
          WCOMP => WCOMP,
          FULL => FULL,
          COMMON_STOP => COMMON_STOP,
          BUSY => BUSY
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

		wait for CLK_period * 3;
		COMMON_STOP <= '1' after DELAY,
		               '0' after DELAY + CLK_period;
		wait for CLK_period;
		FULL <= '1' after DELAY,
		        '0' after DELAY + CLK_period * 8;
      wait;
   end process;

end;
