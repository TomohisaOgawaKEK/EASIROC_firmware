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

entity Width_Adjuster is
	port(
		CLK         : in  std_logic;
		RESET       : in  std_logic;
		TRIGGER_IN  : in  std_logic;
		TRIGGER_OUT : out std_logic;
		WIDTH_cnt   : in  std_logic_vector(7 downto 0)
	);
end Width_Adjuster;

architecture RTL of Width_Adjuster is

    type state_type is (wait_trig, trig_on, stop);
    signal state, state_next: state_type;

    signal counter      : std_logic_vector(7 downto 0);
    signal counter_next : std_logic_vector(7 downto 0);
    signal trigger_s    : std_logic;

begin

	process(RESET,CLK)
	begin
		if(RESET = '1') then
			state     <= wait_trig;
			counter   <= (others => '0');
		elsif(CLK'event and CLK = '1') then
			state   <= state_next;
			counter <= counter_next;
		end if;
	end process;

	-- process(state,counter,TRIGGER_IN) -- original
	process(state,counter,TRIGGER_IN,WIDTH_cnt) -- 2019/12/08: add WIDTH_cnt in sensitivity list
	begin
		case state is
			when wait_trig =>
				if(TRIGGER_IN='1') then
					trigger_s  <= '1';
					state_next <= trig_on;
				else
					trigger_s  <= '0';
					state_next <= state;
				end if;
			when trig_on =>
				counter_next <= counter + 1;
				if(counter = WIDTH_cnt + 3) then
					state_next <= stop;
				else
					state_next <= state;
				end if;
			when stop =>
				trigger_s    <= '0';
				counter_next <= (others => '0');
				state_next   <= wait_trig;
		end case;
	end process;


	TRIGGER_OUT <= trigger_s;

end RTL;
