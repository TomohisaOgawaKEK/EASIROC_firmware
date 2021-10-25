--------------------------------------------------------------------------------
--! @file   Triggermanager_test.vhd
--! @brief  test bench of TriggerManager.vhd
--! @author Takehiro Shiozaki
--! @date   2014-05-07
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity TriggerManager_test is
end TriggerManager_test;

architecture behavior of TriggerManager_test is

    component TriggerManager is
        port(
            SITCP_CLK : in  std_logic;
            AD9220_CLK : in std_logic;
            TDC_CLK : in std_logic;
            FAST_CLK : in std_logic;
            RESET : in  std_logic;

            -- Trigger
            HOLD : in std_logic;
            L1_TRIGGER : in std_logic;
            L2_TRIGGER : in std_logic;
            -- FAST_CLEAR : in std_logic;
            BUSY : out std_logic;
            SPILL_NUMBER : in std_logic;
            EVENT_NUMBER : in std_logic_vector(2 downto 0);

            -- Sender interface
            TRANSMIT_START : out std_logic;
            SPILL_NUMBER_OUT : out std_logic;
            EVENT_NUMBER_OUT : out std_logic_vector(2 downto 0);

            -- Control
            IS_DAQ_MODE : in std_logic;
            TCP_OPEN_ACK : in std_logic;

            -- ADC interface
            ADC_TRIGGER : out std_logic;
            -- ADC_FAST_CLEAR : out std_logic;
            ADC_BUSY : in std_logic;

            -- TDC intreface
            COMMON_STOP : out std_logic;
            -- TDC_FAST_CLEAR : out std_logic;
            TDC_BUSY : in std_logic;

            -- Hold
            HOLD_OUT1_N : out std_logic;
            HOLD_OUT2_N : out std_logic
        );
    end component;

    signal SITCP_CLK : std_logic := '0';
    signal AD9220_CLK : std_logic := '0';
    signal TDC_CLK : std_logic := '0';
    signal FAST_CLK : std_logic := '0';
    signal RESET : std_logic := '0';

    signal HOLD : std_logic := '0';
    signal L1_TRIGGER : std_logic := '0';
    signal L2_TRIGGER : std_logic := '0';
    signal BUSY : std_logic;
    signal SPILL_NUMBER : std_logic := '0';
    signal EVENT_NUMBER : std_logic_vector(2 downto 0) := (others => '0');

    signal TRANSMIT_START : std_logic;
    signal SPILL_NUMBER_OUT : std_logic;
    signal EVENT_NUMBER_OUT : std_logic_vector(2 downto 0);

    signal IS_DAQ_MODE : std_logic := '0';
    signal TCP_OPEN_ACK : std_logic := '0';

    signal ADC_TRIGGER : std_logic;
    signal ADC_BUSY : std_logic := '0';

    signal COMMON_STOP : std_logic;
    signal TDC_BUSY : std_logic := '0';

    signal HOLD_OUT1_N : std_logic;
    signal HOLD_OUT2_N : std_logic;

    constant SITCP_CLK_period : time := 40 ns;
    constant AD9220_CLK_period : time := 166.66 ns;
    constant TDC_CLK_period : time := 8 ns;
    constant FAST_CLK_period : time := 2 ns;
begin

    uut: TriggerManager
    port map(
        SITCP_CLK => SITCP_CLK,
        AD9220_CLK => AD9220_CLK,
        TDC_CLK => TDC_CLK,
        FAST_CLK => FAST_CLK,
        RESET => RESET,
        HOLD => HOLD,
        L1_TRIGGER => L1_TRIGGER,
        L2_TRIGGER => L2_TRIGGER,
        BUSY => BUSY,
        SPILL_NUMBER => SPILL_NUMBER,
        EVENT_NUMBER => EVENT_NUMBER,
        TRANSMIT_START => TRANSMIT_START,
        SPILL_NUMBER_OUT => SPILL_NUMBER_OUT,
        EVENT_NUMBER_OUT => EVENT_NUMBER_OUT,
        IS_DAQ_MODE => IS_DAQ_MODE,
        TCP_OPEN_ACK => TCP_OPEN_ACK,
        ADC_TRIGGER => ADC_TRIGGER,
        ADC_BUSY => ADC_BUSY,
        COMMON_STOP => COMMON_STOP,
        TDC_BUSY => TDC_BUSY,
        HOLD_OUT1_N => HOLD_OUT1_N,
        HOLD_OUT2_N => HOLD_OUT2_N
    );

    process
    begin
        SITCP_CLK <= '1';
        wait for SITCP_CLK_period / 2;
        SITCP_CLK <= '0';
        wait for SITCP_CLK_period / 2;
    end process;

    process
    begin
        AD9220_CLK <= '1';
        wait for AD9220_CLK_period / 2;
        AD9220_CLK <= '0';
        wait for AD9220_CLK_period / 2;
    end process;

    process
    begin
        TDC_CLK <= '1';
        wait for TDC_CLK_period / 2;
        TDC_CLK <= '0';
        wait for TDC_CLK_period / 2;
    end process;

    process
    begin
        FAST_CLK <= '1';
        wait for FAST_CLK_period / 2;
        FAST_CLK <= '0';
        wait for FAST_CLK_period / 2;
    end process;

    process
    begin
        wait until ADC_TRIGGER = '1';
        wait until AD9220_CLK'event and AD9220_CLK = '1';
        ADC_BUSY <= '1';
        wait for 20 us;
        ADC_BUSY <= '0';
    end process;

    process
    begin
        wait until COMMON_STOP = '1';
        wait until TDC_CLK'event and TDC_CLK = '1';
        TDC_BUSY <= '1';
        wait for TDC_CLK_period * 64 * 8;
        TDC_BUSY <= '0';
    end process;

    process
    begin
        RESET <= '1';
        wait for AD9220_CLK_period;
        RESET <= '0';
        wait for 10 ns;

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';
        wait for 10 ns;

        L1_TRIGGER <= '1';
        wait for 10 ns;
        L1_TRIGGER <= '0';
        wait for 10 ns;

        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';
        wait for 10 ns;

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';
        wait for 10 ns;

        wait for 100 ns;

        L1_TRIGGER <= '1';
        wait for 10 ns;
        L1_TRIGGER <= '0';
        wait for 10 ns;

        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';
        wait for 10 ns;

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';
        wait for 10 ns;

        wait until HOLD_OUT1_N = '1';

        wait for 1 us;

        TCP_OPEN_ACK <= '1';
        wait for 100 ns;
        IS_DAQ_MODE <= '1';

        L1_TRIGGER <= '1';
        wait for 10 ns;
        L1_TRIGGER <= '0';

        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';

        wait for 100 ns;

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';

        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';

        wait for 1 us;
        L1_TRIGGER <= '1';
        SPILL_NUMBER <= '1';
        EVENT_NUMBER <= "101";
        wait for 10 ns;
        L1_TRIGGER <= '0';

        wait for 10 ns;
        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';

        L1_TRIGGER <= '1';
        wait for 10 ns;
        L1_TRIGGER <= '0';

        wait for 10 us;
        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';

        wait for 25 us;
        IS_DAQ_MODE <= '0';
        TCP_OPEN_ACK <= '0';


        wait;
    end process;

end;
