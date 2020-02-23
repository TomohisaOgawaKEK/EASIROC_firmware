--------------------------------------------------------------------------------
--! @file   Scaler_test.vhd
--! @brief  Test bench of Scaler.vhd
--! @author Takehiro Shiozaki
--! @date   2014-08-26
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Scaler_test is
end Scaler_test;

architecture behavior of Scaler_test is
    component Scaler is
        port (
            SCALER_CLK : in std_logic;
            SITCP_CLK : in std_logic;
            RESET : in std_logic;

            -- Data input
            DIN : in std_logic_vector(68 downto 0); -- EASIROC TRIGGER 64CH
                                                    -- OR32U, OR32L, OR64, 1kHz, 1MHz

            -- Control Interface
            L1_TRIGGER : in std_logic; -- Synchronized with SCALER_CLK
            BUSY : out std_logic;

            -- Gatherer interface
            DOUT : out std_logic_vector(20 downto 0);
            RADDR : in std_logic_vector(6 downto 0);
            RCOMP : in std_logic;
            EMPTY : out std_logic
        );
    end component;

    signal SCALER_CLK : std_logic := '0';
    signal SITCP_CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DIN : std_logic_vector(68 downto 0) := (others => '0');
    signal L1_TRIGGER : std_logic := '0';
    signal BUSY : std_logic;
    signal DOUT : std_logic_vector(20 downto 0);
    signal RADDR : std_logic_vector(6 downto 0) := (others => '0');
    signal RCOMP : std_logic := '0';
    signal EMPTY : std_logic;

    constant SCALER_CLK_period : time := 4 ns;
    constant SITCP_CLK_period : time := 25 ns;
    constant DELAY : time := 1 ns;
begin
    uut: Scaler
    port map(
        SCALER_CLK => SCALER_CLK,
        SITCP_CLK => SITCP_CLK,
        RESET => RESET,
        DIN => DIN,
        L1_TRIGGER => L1_TRIGGER,
        BUSY => BUSY,
        DOUT => DOUT,
        RADDR => RADDR,
        RCOMP => RCOMP,
        EMPTY => EMPTY
    );

    process
    begin
        wait for SCALER_CLK_period / 2;
        SCALER_CLK <= '1';
        wait for SCALER_CLK_period / 2;
        SCALER_CLK <= '0';
    end process;

    process
    begin
        wait for SITCP_CLK_period / 2;
        SITCP_CLK <= '1';
        wait for SITCP_CLK_period / 2;
        SITCP_CLK <= '0';
    end process;

    process
        procedure pulse(ch : integer) is
        begin
            DIN(ch) <= '1' after DELAY,
                       '0' after SCALER_CLK_period * 2 + DELAY;
        end procedure;
    begin
        RESET <= '1';
        wait for 100 ns;
        RESET <= '0';
        wait until SCALER_CLK'event and SCALER_CLK = '1';
        pulse(0);
        pulse(1);
        pulse(2);
        pulse(3);
        pulse(68);
        wait for SCALER_CLK_period * 3;
        pulse(1);
        pulse(2);
        pulse(3);
        pulse(68);
        wait for SCALER_CLK_period * 3;
        pulse(2);
        pulse(3);
        pulse(68);
        wait for SCALER_CLK_period * 3;
        pulse(3);
        pulse(68);
        wait for SCALER_CLK_period * 3;
        pulse(68);
        wait for SCALER_CLK_period * 3;

        L1_TRIGGER <= '1' after DELAY;
        wait for SCALER_CLK_period;
        L1_TRIGGER <= '0' after DELAY;

        wait until BUSY'event and BUSY = '0';

        wait for SCALER_CLK_period * 2;
        L1_TRIGGER <= '1' after DELAY;
        wait for SCALER_CLK_period;
        L1_TRIGGER <= '0' after DELAY;

        wait until BUSY'event and BUSY = '0';

        wait for SCALER_CLK_period * 2;
        L1_TRIGGER <= '1' after DELAY;
        wait for SCALER_CLK_period;
        L1_TRIGGER <= '0' after DELAY;
        wait;
    end process;


end behavior;
