--------------------------------------------------------------------------------
--! @file   TDC_Gatherer_test.vhd
--! @brief  Test bench of TDC_Gatherer.vhd
--! @author Takehiro Shiozaki
--! @date   2014-05-05
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity TDC_Gatherer_test is
end TDC_Gatherer_test;

architecture behavior of TDC_Gatherer_test is

    component TDC_Gatherer is
        port(
            CLK : in std_logic;
            RESET : in  std_logic;

            -- TDC (Leading)
            DIN_L : in  std_logic_vector (19 downto 0);
            RADDR_L : out  std_logic_vector (10 downto 0);
            RCOMP_L : out  std_logic;
            EMPTY_L : in  std_logic;

            -- TDC (Trailing)
            DIN_T : in  std_logic_vector (19 downto 0);
            RADDR_T : out  std_logic_vector (10 downto 0);
            RCOMP_T : out  std_logic;
            EMPTY_T : in  std_logic;

            -- FIFO
            DOUT : out std_logic_vector(19 downto 0);
            WE : out std_logic;
            FULL : in std_logic;

            -- Control
            START : in std_logic;
            BUSY : out std_logic
            );
    end component;

    --Inputs
    signal CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DIN_L : std_logic_vector(19 downto 0) := (others => '0');
    signal DIN_T : std_logic_vector(19 downto 0) := (others => '0');
    signal EMPTY_L : std_logic := '0';
    signal EMPTY_T : std_logic := '0';
    signal FULL : std_logic := '0';
    signal START : std_logic := '0';

    --Outputs
    signal RADDR_L : std_logic_vector(10 downto 0);
    signal RADDR_T : std_logic_vector(10 downto 0);
    signal RCOMP_L : std_logic;
    signal RCOMP_T : std_logic;
    signal DOUT : std_logic_vector(19 downto 0);
    signal WE : std_logic;
    signal BUSY : std_logic;

    -- Clock period definitions
    constant CLK_period : time := 40 ns;
    constant DELAY : time := CLK_period * 0.2;

begin

    uut: TDC_Gatherer port map (
          CLK => CLK,
          RESET => RESET,
          DIN_L => DIN_L,
          RADDR_L => RADDR_L,
          RCOMP_L => RCOMP_L,
          EMPTY_L => EMPTY_L,
          DIN_T => DIN_T,
          RADDR_T => RADDR_T,
          RCOMP_T => RCOMP_T,
          EMPTY_T => EMPTY_T,
          DOUT => DOUT,
          WE => WE,
          FULL => FULL,
          START => START,
          BUSY => BUSY
        );

    process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    process(RADDR_L)
    begin
        case RADDR_L is
            when "00000000000" =>
                DIN_L <= X"00001" after CLK_period + DELAY;
            when "00000000001" =>
                DIN_L <= X"00002" after CLK_period + DELAY;
            when "00000000010" =>
                DIN_L <= X"00003" after CLK_period + DELAY;
            when "00000000011" =>
                DIN_L <= X"00004" after CLK_period + DELAY;
            when "00000000100" =>
                DIN_L <= X"FFFFF" after CLK_period + DELAY;
            when others =>
                DIN_L <= (others => 'X') after CLK_period + DELAY;
        end case;
    end process;

    process(RADDR_T)
    begin
        case RADDR_T is
            when "00000000000" =>
                DIN_T <= X"00005" after CLK_period + DELAY;
            when "00000000001" =>
                DIN_T <= X"00006" after CLK_period + DELAY;
            when "00000000010" =>
                DIN_T <= X"00007" after CLK_period + DELAY;
            when "00000000011" =>
                DIN_T <= X"00008" after CLK_period + DELAY;
            when "00000000100" =>
                DIN_T <= X"FFFFF" after CLK_period + DELAY;
            when others =>
                DIN_T <= (others => 'X') after CLK_period + DELAY;
        end case;
    end process;

    process

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
      wait;
    end process;

end;
