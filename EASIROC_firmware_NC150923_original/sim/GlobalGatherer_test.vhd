--------------------------------------------------------------------------------
--! @file   Gatherer_test.vhd
--! @brief  test bench of Gatherer.vhd
--! @author Takehiro Shiozaki
--! @date   2014-05-05
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity GlobalGatherer_test is
end GlobalGatherer_test;

architecture behavior of GlobalGatherer_test is

    component GlobalGatherer
    port(
        CLK : in  std_logic;
        RESET : in  std_logic;
        ADC0_DIN : in  std_logic_vector(20 downto 0);
        ADC0_RADDR : out  std_logic_vector(5 downto 0);
        ADC0_RCOMP : out  std_logic;
        ADC0_EMPTY : in  std_logic;
        ADC1_DIN : in  std_logic_vector(20 downto 0);
        ADC1_RADDR : out  std_logic_vector(5 downto 0);
        ADC1_RCOMP : out  std_logic;
        ADC1_EMPTY : in  std_logic;
        ADC2_DIN : in  std_logic_vector(20 downto 0);
        ADC2_RADDR : out  std_logic_vector(5 downto 0);
        ADC2_RCOMP : out  std_logic;
        ADC2_EMPTY : in  std_logic;
        ADC3_DIN : in  std_logic_vector(20 downto 0);
        ADC3_RADDR : out  std_logic_vector(5 downto 0);
        ADC3_RCOMP : out  std_logic;
        ADC3_EMPTY : in  std_logic;
        TDC_DIN_L : in  std_logic_vector(19 downto 0);
        TDC_RADDR_L : out  std_logic_vector(10 downto 0);
        TDC_RCOMP_L : out  std_logic;
        TDC_EMPTY_L : in  std_logic;
        TDC_DIN_T : in  std_logic_vector(19 downto 0);
        TDC_RADDR_T : out  std_logic_vector(10 downto 0);
        TDC_RCOMP_T : out  std_logic;
        TDC_EMPTY_T : in  std_logic;
        SCALER_DIN : in std_logic_vector(20 downto 0);
        SCALER_RADDR : out std_logic_vector(6 downto 0);
        SCALER_RCOMP : out std_logic;
        SCALER_EMPTY : in std_logic;
        DOUT : out  std_logic_vector(31 downto 0);
        WE : out  std_logic;
        FULL : in  std_logic;
        SEND_ADC : in  std_logic;
        SEND_TDC : in  std_logic;
        SEND_SCALER : in std_logic;
        TRIGGER : in  std_logic;
        SPILL_NUMBER : in  std_logic;
        EVENT_NUMBER : in  std_logic_vector(2 downto 0);
        BUSY : out  std_logic
    );
    end component;

    signal CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal ADC0_DIN : std_logic_vector(20 downto 0) := (others => '0');
    signal ADC0_EMPTY : std_logic := '0';
    signal ADC1_DIN : std_logic_vector(20 downto 0) := (others => '0');
    signal ADC1_EMPTY : std_logic := '0';
    signal ADC2_DIN : std_logic_vector(20 downto 0) := (others => '0');
    signal ADC2_EMPTY : std_logic := '0';
    signal ADC3_DIN : std_logic_vector(20 downto 0) := (others => '0');
    signal ADC3_EMPTY : std_logic := '0';
    signal TDC_DIN_L : std_logic_vector(19 downto 0) := (others => '0');
    signal TDC_EMPTY_L : std_logic := '0';
    signal TDC_DIN_T : std_logic_vector(19 downto 0) := (others => '0');
    signal TDC_EMPTY_T : std_logic := '0';
    signal SCALER_DIN : std_logic_vector(20 downto 0) := (others => '0');
    signal SCALER_RADDR : std_logic_vector(6 downto 0);
    signal SCALER_RCOMP : std_logic;
    signal SCALER_EMPTY : std_logic := '0';
    signal FULL : std_logic := '0';
    signal SEND_ADC : std_logic := '0';
    signal SEND_TDC : std_logic := '0';
    signal SEND_SCALER : std_logic := '0';
    signal TRIGGER : std_logic := '0';
    signal SPILL_NUMBER : std_logic := 'X';
    signal EVENT_NUMBER : std_logic_vector(2 downto 0) := (others => 'X');

    signal ADC0_RADDR : std_logic_vector(5 downto 0);
    signal ADC1_RADDR : std_logic_vector(5 downto 0);
    signal ADC2_RADDR : std_logic_vector(5 downto 0);
    signal ADC3_RADDR : std_logic_vector(5 downto 0);
    signal TDC_RADDR_L : std_logic_vector(10 downto 0);
    signal TDC_RADDR_T : std_logic_vector(10 downto 0);
    signal ADC0_RCOMP : std_logic;
    signal ADC1_RCOMP : std_logic;
    signal ADC2_RCOMP : std_logic;
    signal ADC3_RCOMP : std_logic;
    signal TDC_RCOMP_L : std_logic;
    signal TDC_RCOMP_T : std_logic;
    signal DOUT : std_logic_vector(31 downto 0);
    signal WE : std_logic;
    signal BUSY : std_logic;

    constant CLK_period : time := 40 ns;
    constant DELAY : time := CLK_period * 0.2;

begin

    uut: GlobalGatherer
    port map (
        CLK => CLK,
        RESET => RESET,
        ADC0_DIN => ADC0_DIN,
        ADC0_RADDR => ADC0_RADDR,
        ADC0_RCOMP => ADC0_RCOMP,
        ADC0_EMPTY => ADC0_EMPTY,
        ADC1_DIN => ADC1_DIN,
        ADC1_RADDR => ADC1_RADDR,
        ADC1_RCOMP => ADC1_RCOMP,
        ADC1_EMPTY => ADC1_EMPTY,
        ADC2_DIN => ADC2_DIN,
        ADC2_RADDR => ADC2_RADDR,
        ADC2_RCOMP => ADC2_RCOMP,
        ADC2_EMPTY => ADC2_EMPTY,
        ADC3_DIN => ADC3_DIN,
        ADC3_RADDR => ADC3_RADDR,
        ADC3_RCOMP => ADC3_RCOMP,
        ADC3_EMPTY => ADC3_EMPTY,
        TDC_DIN_L => TDC_DIN_L,
        TDC_RADDR_L => TDC_RADDR_L,
        TDC_RCOMP_L => TDC_RCOMP_L,
        TDC_EMPTY_L => TDC_EMPTY_L,
        TDC_DIN_T => TDC_DIN_T,
        TDC_RADDR_T => TDC_RADDR_T,
        TDC_RCOMP_T => TDC_RCOMP_T,
        TDC_EMPTY_T => TDC_EMPTY_T,
        SCALER_DIN => SCALER_DIN,
        SCALER_RADDR => SCALER_RADDR,
        SCALER_RCOMP => SCALER_RCOMP,
        SCALER_EMPTY => SCALER_EMPTY,
        DOUT => DOUT,
        WE => WE,
        FULL => FULL,
        SEND_ADC => SEND_ADC,
        SEND_TDC => SEND_TDC,
        SEND_SCALER => SEND_SCALER,
        TRIGGER => TRIGGER,
        SPILL_NUMBER => SPILL_NUMBER,
        EVENT_NUMBER => EVENT_NUMBER,
        BUSY => BUSY
    );

    process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    process(ADC0_RADDR)
    begin
        case ADC0_RADDR is
            when "000000" =>
                ADC0_DIN <= transport '0' & X"00001" after CLK_period + DELAY;
            when "000001" =>
                ADC0_DIN <= transport '0' & X"00002" after CLK_period + DELAY;
            when "000010" =>
                ADC0_DIN <= transport '0' & X"00003" after CLK_period + DELAY;
            when "000011" =>
                ADC0_DIN <= transport '0' & X"00004" after CLK_period + DELAY;
            when "000100" =>
                ADC0_DIN <= transport '1' & X"FFFFF" after CLK_period + DELAY;
            when "111111" =>
                ADC0_DIN <= transport '0' & X"00004" after CLK_period + DELAY;
            when others =>
                ADC0_DIN <= transport (others => 'X') after CLK_period + DELAY;
        end case;
    end process;

    process(ADC1_RADDR)
    begin
        case ADC1_RADDR is
            when "000000" =>
                ADC1_DIN <= transport '1' & X"FFFFF" after CLK_period + DELAY;
            when "111111" =>
                ADC1_DIN <= transport '0' & X"00000" after CLK_period + DELAY;
            when others =>
                ADC1_DIN <= transport (others => 'X') after CLK_period + DELAY;
        end case;
    end process;

    process(ADC2_RADDR)
    begin
        case ADC2_RADDR is
            when "000000" =>
                ADC2_DIN <= transport '0' & X"00005" after CLK_period + DELAY;
            when "000001" =>
                ADC2_DIN <= transport '0' & X"00006" after CLK_period + DELAY;
            when "000010" =>
                ADC2_DIN <= transport '1' & X"FFFFF" after CLK_period + DELAY;
            when "111111" =>
                ADC2_DIN <= transport '0' & X"00002" after CLK_period + DELAY;
            when others =>
                ADC2_DIN <= transport (others => 'X') after CLK_period + DELAY;
        end case;
    end process;

    process(ADC3_RADDR)
    begin
        case ADC3_RADDR is
            when "000000" =>
                ADC3_DIN <= transport '1' & X"FFFFF" after CLK_period + DELAY;
            when "111111" =>
                ADC3_DIN <= transport '0' & X"00000" after CLK_period + DELAY;
            when others =>
                ADC3_DIN <= transport (others => 'X') after CLK_period + DELAY;
        end case;
    end process;

    process(TDC_RADDR_L)
    begin
        case TDC_RADDR_L is
            when "00000000000" =>
                TDC_DIN_L <= transport X"00001" after CLK_period + DELAY;
            when "00000000001" =>
                TDC_DIN_L <= transport X"00002" after CLK_period + DELAY;
            when "00000000010" =>
                TDC_DIN_L <= transport X"00003" after CLK_period + DELAY;
            when "00000000011" =>
                TDC_DIN_L <= transport X"00004" after CLK_period + DELAY;
            when "00000000100" =>
                TDC_DIN_L <= transport X"FFFFF" after CLK_period + DELAY;
            when "11111111111" =>
                TDC_DIN_L <= transport X"00004" after CLK_period + DELAY;
            when others =>
                TDC_DIN_L <= transport (others => 'X') after CLK_period + DELAY;
        end case;
    end process;

    process(TDC_RADDR_T)
    begin
        case TDC_RADDR_T is
            when "00000000000" =>
                TDC_DIN_T <= transport X"00001" after CLK_period + DELAY;
            when "00000000001" =>
                TDC_DIN_T <= transport X"00002" after CLK_period + DELAY;
            when "00000000010" =>
                TDC_DIN_T <= transport X"00003" after CLK_period + DELAY;
            when "00000000011" =>
                TDC_DIN_T <= transport X"00004" after CLK_period + DELAY;
            when "00000000100" =>
                TDC_DIN_T <= transport X"00005" after CLK_period + DELAY;
            when "00000000101" =>
                TDC_DIN_T <= transport X"00006" after CLK_period + DELAY;
            when "00000000110" =>
                TDC_DIN_T <= transport X"FFFFF" after CLK_period + DELAY;
            when "11111111111" =>
                TDC_DIN_T <= transport X"00006" after CLK_period + DELAY;
            when others =>
                TDC_DIN_T <= transport (others => 'X') after CLK_period + DELAY;
        end case;
    end process;

    process(SCALER_RADDR)
    begin
        case SCALER_RADDR is
            when "0000000" =>
                SCALER_DIN <= transport "0" & X"00001" after CLK_period + DELAY;
            when "0000001" =>
                SCALER_DIN <= transport "0" & X"00010" after CLK_period + DELAY;
            when "0000010" =>
                SCALER_DIN <= transport "0" & X"00011" after CLK_period + DELAY;
            when "0000011" =>
                SCALER_DIN <= transport "0" & X"00100" after CLK_period + DELAY;
            when "0000100" =>
                SCALER_DIN <= transport "0" & X"00101" after CLK_period + DELAY;
            when others =>
                SCALER_DIN <= transport "0" & X"00000" after CLK_period + DELAY;
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

        TRIGGER <= '1' after DELAY,
                   '0' after CLK_period + DELAY;
        SPILL_NUMBER <= '1' after DELAY,
                        'X' after CLK_period + DELAY;
        EVENT_NUMBER <= "000" after DELAY,
                        (others => 'X') after CLK_period + DELAY;
        SEND_ADC <= '1' after DELAY,
                    '0' after CLK_period + DELAY;
        SEND_TDC <= '1' after DELAY,
                    '0' after CLK_period + DELAY;
        SEND_SCALER <= '1' after DELAY,
                       '0' after CLK_period + DELAY;
        wait until BUSY'event and BUSY = '0';
        wait for CLK_period * 2;

        TRIGGER <= '1' after DELAY,
                   '0' after CLK_period + DELAY;
        SPILL_NUMBER <= '0' after DELAY,
                        'X' after CLK_period + DELAY;
        EVENT_NUMBER <= "100" after DELAY,
                        (others => 'X') after CLK_period + DELAY;
        SEND_ADC <= '1' after DELAY,
                    '0' after CLK_period + DELAY;
        wait until BUSY'event and BUSY = '0';
        wait for CLK_period * 2;

        TRIGGER <= '1' after DELAY,
                   '0' after CLK_period + DELAY;
        SPILL_NUMBER <= '0' after DELAY,
                        'X' after CLK_period + DELAY;
        EVENT_NUMBER <= "010" after DELAY,
                        (others => 'X') after CLK_period + DELAY;
        SEND_TDC <= '1' after DELAY,
                    '0' after CLK_period + DELAY;
        wait until BUSY'event and BUSY = '0';
        wait for CLK_period * 2;

        TRIGGER <= '1' after DELAY,
                   '0' after CLK_period + DELAY;
        SPILL_NUMBER <= '0' after DELAY,
                        'X' after CLK_period + DELAY;
        EVENT_NUMBER <= "010" after DELAY,
                        (others => 'X') after CLK_period + DELAY;
        SEND_SCALER <= '1' after DELAY,
                    '0' after CLK_period + DELAY;
        wait until BUSY'event and BUSY = '0';
        wait for CLK_period * 2;

        TRIGGER <= '1' after DELAY,
                   '0' after CLK_period + DELAY;
        SPILL_NUMBER <= '0' after DELAY,
                        'X' after CLK_period + DELAY;
        EVENT_NUMBER <= "010" after DELAY,
                        (others => 'X') after CLK_period + DELAY;
        wait until BUSY'event and BUSY = '0';
        wait for CLK_period * 2;

        wait;
   end process;

end;
