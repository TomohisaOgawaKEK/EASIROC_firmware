--------------------------------------------------------------------------------
--! @file   Width_Adjuster.vhd
--! @brief  Control width of triggers
--! @author Naruhiro Chikuma
--! @date   2015-09-18
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity TriggerDelayer is
	port(
		CLK         : in  std_logic;
		CLK_25M     : in  std_logic;
		RESET       : in  std_logic;
		TRIGGER_IN  : in  std_logic;
		TRIGGER_OUT : out std_logic;
		DELAY       : in  std_logic_vector(7 downto 0)
	);
end TriggerDelayer;

architecture RTL of TriggerDelayer is

    type state_type is (wait_trig, delaying, trig_on);
    signal state, state_next: state_type;

    signal counter          : std_logic_vector(7 downto 0);
    signal counter_next     : std_logic_vector(7 downto 0);
    signal counter_25M      : std_logic_vector(7 downto 0);
    signal counter_25M_next : std_logic_vector(7 downto 0);
    signal trigger_s        : std_logic;

begin

	process(RESET,CLK)
	begin
		if(RESET = '1') then
			state        <= wait_trig;
			counter      <= (others => '0');
		elsif(CLK'event and CLK = '1') then
			state   <= state_next;
			counter <= counter_next;
		end if;
	end process;

	process(RESET,CLK_25M)
	begin
		if(RESET = '1') then
			counter_25M <= (others => '0');
		elsif(CLK_25M'event and CLK_25M = '1') then
			counter_25M <= counter_25M_next;
		end if;
	end process;

	process(state,counter,counter_25M,TRIGGER_IN,CLK_25M,trigger_s)
	begin
		case state is
			when wait_trig =>
				trigger_s        <= '0';
				counter_next     <= (others => '0');
				counter_25M_next <= (others => '0');
				if(TRIGGER_IN = '1') then
					state_next <= delaying;
				else
					state_next <= state;
				end if;
			when delaying =>
				counter_next <= counter + 1;
				if(counter = DELAY + 2) then
					trigger_s  <= '1';
					state_next <= trig_on;
				else
					state_next <= state;
				end if;
			when trig_on =>
				counter_25M_next <= counter_25M + 1;
				if(counter_25M = 2) then
					trigger_s  <= '0';
					state_next <= wait_trig;
				else
					state_next <= state;
				end if;
		end case;
	end process;

	TRIGGER_OUT <= trigger_s;

end RTL;
