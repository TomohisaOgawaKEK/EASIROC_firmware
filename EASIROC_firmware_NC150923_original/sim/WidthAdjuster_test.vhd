--------------------------------------------------------------------------------
--! @file   WidthAdjuster_test.vhd
--! @brief  Test bench of WidthAdjuster.vhd
--! @author Naruhiro Chikuma
--! @date   2015-09-19
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity WidthAdjuster_test is
end WidthAdjuster_test;

architecture behavior of WidthAdjuster_test is

	component Width_Adjuster is
	port(
		CLK         : in  std_logic;
		RESET       : in  std_logic;
		TRIGGER_IN  : in  std_logic;
		TRIGGER_OUT : out std_logic;
		WIDTH_cnt   : in  std_logic_vector(7 downto 0)
	);
	end component;
	
	signal CLK         : std_logic := '0';
	signal RESET       : std_logic := '0';
	signal TRIGGER_IN  : std_logic := '0';
	signal TRIGGER_OUT : std_logic;
	signal WIDTH_cnt   : std_logic_vector(7 downto 0) := "00000001";

   -- Clock period definitions
   	constant CLK_500M_period : time := 2 ns;  --500MHz
	constant DELAY_500M : time := CLK_500M_period*0.2;

begin
    
	utt: Width_Adjuster
	port map(
	  CLK         =>  CLK,         
          RESET       =>  RESET,       
          TRIGGER_IN  =>  TRIGGER_IN, 
          TRIGGER_OUT =>  TRIGGER_OUT,
	  WIDTH_cnt   => WIDTH_cnt
        );

   -- Clock process definitions
   process
   begin
		CLK <= '0';
		wait for CLK_500M_period/2;
		CLK <= '1';
		wait for CLK_500M_period/2;
   end process;
  

   -- Stimulus process
   stim_proc: process

		procedure reset_uut is
		begin
			RESET <= '1';
			wait until CLK'event and CLK = '1';
			wait for CLK_500M_period;
			RESET <= '0' after DELAY_500M;
		end procedure;

   begin
		reset_uut;

		wait for 10 ns;
		WIDTH_cnt <= X"10";
		wait for 10.5 ns;
		TRIGGER_IN <= '1';
		wait for 20 ns;
		TRIGGER_IN <= '0';
				
		wait;
   end process;

end;
