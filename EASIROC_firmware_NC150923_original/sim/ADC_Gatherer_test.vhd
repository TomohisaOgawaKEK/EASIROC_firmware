--------------------------------------------------------------------------------
--! @file   ADC_Gatherer_test.vhd
--! @brief  Test bench of ADC_Gatherer.vhd
--! @author Takehiro Shiozaki
--! @date   2014-05-05
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ADC_Gatherer_test is
end ADC_Gatherer_test;

architecture behavior of ADC_Gatherer_test is

    -- component Declaration for the Unit Under Test (UUT)

    component ADC_Gatherer
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         DIN0 : in  std_logic_vector(19 downto 0);
         RADDR0 : out  std_logic_vector(5 downto 0);
         RCOMP0 : out  std_logic;
         EMPTY0 : in  std_logic;
         DIN1 : in  std_logic_vector(19 downto 0);
         RADDR1 : out  std_logic_vector(5 downto 0);
         RCOMP1 : out  std_logic;
         EMPTY1 : in  std_logic;
         DIN2 : in  std_logic_vector(19 downto 0);
         RADDR2 : out  std_logic_vector(5 downto 0);
         RCOMP2 : out  std_logic;
         EMPTY2 : in  std_logic;
         DIN3 : in  std_logic_vector(19 downto 0);
         RADDR3 : out  std_logic_vector(5 downto 0);
         RCOMP3 : out  std_logic;
         EMPTY3 : in  std_logic;
         DOUT : out  std_logic_vector(19 downto 0);
         WE : out  std_logic;
         FULL : in  std_logic;
         START : in  std_logic;
         BUSY : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal DIN0 : std_logic_vector(19 downto 0) := (others => 'X');
   signal EMPTY0 : std_logic := '0';
   signal DIN1 : std_logic_vector(19 downto 0) := (others => 'X');
   signal EMPTY1 : std_logic := '0';
   signal DIN2 : std_logic_vector(19 downto 0) := (others => 'X');
   signal EMPTY2 : std_logic := '0';
   signal DIN3 : std_logic_vector(19 downto 0) := (others => 'X');
   signal EMPTY3 : std_logic := '0';
   signal FULL : std_logic := '0';
   signal START : std_logic := '0';

 	--Outputs
   signal RADDR0 : std_logic_vector(5 downto 0);
   signal RCOMP0 : std_logic;
   signal RADDR1 : std_logic_vector(5 downto 0);
   signal RCOMP1 : std_logic;
   signal RADDR2 : std_logic_vector(5 downto 0);
   signal RCOMP2 : std_logic;
   signal RADDR3 : std_logic_vector(5 downto 0);
   signal RCOMP3 : std_logic;
   signal DOUT : std_logic_vector(19 downto 0);
   signal WE : std_logic;
   signal BUSY : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period * 0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: ADC_Gatherer port map (
          CLK => CLK,
          RESET => RESET,
          DIN0 => DIN0,
          RADDR0 => RADDR0,
          RCOMP0 => RCOMP0,
          EMPTY0 => EMPTY0,
          DIN1 => DIN1,
          RADDR1 => RADDR1,
          RCOMP1 => RCOMP1,
          EMPTY1 => EMPTY1,
          DIN2 => DIN2,
          RADDR2 => RADDR2,
          RCOMP2 => RCOMP2,
          EMPTY2 => EMPTY2,
          DIN3 => DIN3,
          RADDR3 => RADDR3,
          RCOMP3 => RCOMP3,
          EMPTY3 => EMPTY3,
          DOUT => DOUT,
          WE => WE,
          FULL => FULL,
          START => START,
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

	process(RADDR0)
	begin
		case RADDR0 is
			when "000000" =>
				DIN0 <= X"00001" after CLK_period + DELAY;
			when "000001" =>
				DIN0 <= X"00002" after CLK_period + DELAY;
			when "000010" =>
				DIN0 <= X"00003" after CLK_period + DELAY;
			when "000011" =>
				DIN0 <= X"00004" after CLK_period + DELAY;
			when "000100" =>
				DIN0 <= X"FFFFF" after CLK_period + DELAY;
			when others =>
				DIN0 <= (others => 'X') after CLK_period + DELAY;
		end case;
	end process;

	process(RADDR1)
	begin
		case RADDR1 is
			when "000000" =>
				DIN1 <= X"FFFFF" after CLK_period + DELAY;
			when others =>
				DIN1 <= (others => 'X') after CLK_period + DELAY;
		end case;
	end process;

	process(RADDR2)
	begin
		case RADDR2 is
			when "000000" =>
				DIN2 <= X"00005" after CLK_period + DELAY;
			when "000001" =>
				DIN2 <= X"00006" after CLK_period + DELAY;
			when "000010" =>
				DIN2 <= X"FFFFF" after CLK_period + DELAY;
			when others =>
				DIN2 <= (others => 'X') after CLK_period + DELAY;
		end case;
	end process;

	process(RADDR3)
	begin
		case RADDR3 is
			when "000000" =>
				DIN3 <= X"FFFFF" after CLK_period + DELAY;
			when others =>
				DIN3 <= (others => 'X') after CLK_period + DELAY;
		end case;
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
		START <= '1' after DELAY,
		         '0' after CLK_period + DELAY;

		wait until DOUT = X"00005";
		wait for CLK_period;
		FULL <= '1' after DELAY,
		        '0' after CLK_period*5 + DELAY;

		wait until BUSY = '0';
		wait for CLK_period;
		EMPTY0 <= '1' after DELAY,
		          '0' after DELAY + CLK_period*5;
		START <= '1' after DELAY,
		         '0' after CLK_period + DELAY;
      wait;
   end process;

end;
