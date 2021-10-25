--------------------------------------------------------------------------------
--! @file   MADC_test.vhd
--! @brief  Test bench of MADC.vhd
--! @author Naruhiro Chikuma
--! @date   2015-08-16
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity TriggerDelayer_test is
end TriggerDelayer_test;

architecture behavior of TriggerDelayer_test is

    component TriggerDelayer
	port(
		CLK         : in  std_logic;
		CLK_25M     : in  std_logic;
		RESET       : in  std_logic;
		TRIGGER_IN  : in  std_logic;
		TRIGGER_OUT : out std_logic;
		DELAY       : in  std_logic_vector(7 downto 0)
	);
    end component;


	-- Inputs
        signal CLK         : std_logic := '0';
        signal CLK_25M     : std_logic := '0';
        signal RESET       : std_logic := '0';
        signal TRIGGER_IN  : std_logic := '0';
	signal DELAY       : std_logic_vector(7 downto 0) := (others=>'0');
	
	-- Outputs
	signal TRIGGER_OUT : std_logic;

   -- Clock period definitions
   	constant CLK_period : time := 2 ns;  --500MHz
   	constant CLK_25M_period : time := 40 ns;  --25MHz
	constant DELAY_clk : time := CLK_period*0.2;
	constant DELAY_clk_25M : time := CLK_25M_period*0.2;

begin

	utt: TriggerDelayer
	port map(
		CLK          => CLK        , 
		CLK_25M      => CLK_25M    , 
		RESET        => RESET      , 
		TRIGGER_IN   => TRIGGER_IN , 
		TRIGGER_OUT  => TRIGGER_OUT,
		DELAY        => DELAY      
	);

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
   
   -- Clock process definitions
   CLK_25M_process :process
   begin
		CLK_25M <= '0';
		wait for CLK_25M_period/2;
		CLK_25M <= '1';
		wait for CLK_25M_period/2;
   end process;

   -- Stimulus process
   stim_proc: process

		procedure reset_uut is
		begin
			RESET <= '1';
			wait until CLK_25M'event and CLK_25M = '1';
			wait for CLK_25M_period;
			RESET <= '0' after DELAY_clk_25M;
		end procedure;

   begin
	

		reset_uut;
		
		wait for CLK_period*2;
		DELAY <= "11111111";

		wait for CLK_25M_period;
		
		TRIGGER_IN <= '1';
		wait for CLK_period*10;
		TRIGGER_IN <= '0';

		wait for CLK_25M_period*10;
		DELAY <= "00000000";

		wait for CLK_25M_period;
		
		TRIGGER_IN <= '1';
		wait for CLK_period*10;
		TRIGGER_IN <= '0';


		wait for CLK_25M_period*10;
		DELAY <= "11111101";

		wait for CLK_25M_period;
		
		TRIGGER_IN <= '1';
		wait for CLK_period*10;
		TRIGGER_IN <= '0';
      wait;
   end process;

end;
