--------------------------------------------------------------------------------
--! @file   ScalerTimer_test.vhd
--! @brief  Test bench of ScalerTimer.vhd
--! @author Takehiro Shiozaki
--! @date   2014-08-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ScalerTimer_test is
end ScalerTimer_test;

architecture behavior of ScalerTimer_test is
    component ScalerTimer is
        port(
            SCALER_CLK : in std_logic; -- 125MHz
            RESET : in std_logic;
            TIMER_1MHZ : out std_logic;
            TIMER_1KHZ : out std_logic
        );
    end component;

    signal SCALER_CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal TIMER_1MHZ : std_logic;
    signal TIMER_1KHZ : std_logic;
    constant SCALER_CLK_period : time := 8 ns;
begin
    uut: ScalerTimer
    port map(
        SCALER_CLK => SCALER_CLK,
        RESET => RESET,
        TIMER_1MHZ => TIMER_1MHZ,
        TIMER_1KHz => TIMER_1KHZ
    );

    process
    begin
        SCALER_CLK <= '0';
        wait for SCALER_CLK_period / 2;
        SCALER_CLK <= '1';
        wait for SCALER_CLK_period / 2;
    end process;

    process
    begin
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';
        wait;
    end process;
end behavior;

