--------------------------------------------------------------------------------
--! @file   ScalerGatherer_test.vhd
--! @brief  Test bench of ScalerGatherer.vhd
--! @author Takehiro Shiozaki
--! @date   2014-08-27
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ScalerGatherer_test is
end ScalerGatherer_test;

architecture behavior of ScalerGatherer_test is
    component ScalerGatherer is
        port (
            SITCP_CLK : in  std_logic;
            RESET : in  std_logic;

            -- Scaler
            DIN : in  std_logic_vector (20 downto 0);
            RADDR : out  std_logic_vector (6 downto 0);
            RCOMP : out  std_logic;
            EMPTY : in  std_logic;

            -- FIFO
            DOUT : out std_logic_vector(20 downto 0);
            WE : out std_logic;
            FULL : in std_logic;

            -- Control
            START : in std_logic;
            BUSY : out std_logic
        );
    end component;

    signal SITCP_CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DIN : std_logic_vector(20 downto 0) := (others => '0');
    signal RADDR : std_logic_vector(6 downto 0) := (others => '0');
    signal RCOMP : std_logic;
    signal EMPTY : std_logic := '0';
    signal DOUT : std_logic_vector(20 downto 0);
    signal WE : std_logic;
    signal FULL : std_logic := '0';
    signal START : std_logic := '0';
    signal BUSY : std_logic;

    constant SITCP_CLK_period : time := 40 ns;
    constant DELAY : time := 10 ns;
begin
    uut: ScalerGatherer
    port map(
        SITCP_CLK => SITCP_CLK,
        RESET => RESET,
        DIN => DIN,
        RADDR => RADDR,
        RCOMP => RCOMP,
        EMPTY => EMPTY,
        DOUT => DOUT,
        WE => WE,
        FULL => FULL,
        START => START,
        BUSY => BUSY
    );

    process
    begin
        SITCP_CLK <= '0';
        wait for SITCP_CLK_period / 2;
        SITCP_CLK <= '1';
        wait for SITCP_CLK_period / 2;
    end process;

    process(RADDR)
    begin
        DIN <= "00000000000000" & RADDR;
    end process;

    process
    begin
        RESET <= '1';
        wait for SITCP_CLK_period * 2;
        wait until SITCP_CLK'event and SITCP_CLK = '1';
        RESET <= '0' after DELAY;
        wait for SITCP_CLK_period * 2;

        EMPTY <= '1' after DELAY;
        wait for SITCP_CLK_period;
        START <= '1' after DELAY,
                 '0' after SITCP_CLK_period + DELAY;
        wait for SITCP_CLK_period;

        wait for SITCP_CLK_period * 3;
        EMPTY <= '0' after DELAY;

        wait for SITCP_CLK_period * 30;
        FULL <= '1' after DELAY,
                '0' after SITCP_CLK_period * 10 + DELAY;
        wait;
    end process;
end behavior;
