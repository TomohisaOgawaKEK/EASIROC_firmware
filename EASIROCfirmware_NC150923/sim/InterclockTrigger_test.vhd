--------------------------------------------------------------------------------
--! @file   InterclockTrigger_test.vhd
--! @brief  Test bench of InterclockTrigger.vhd
--! @author Takehiro Shiozaki
--! @date   2014-07-11
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity InterclockTrigger_test is
end InterclockTrigger_test;

architecture behavior of InterclockTrigger_test is
    component InterclockTrigger is
        port(
            CLK_IN : in std_logic;
            CLK_OUT : in std_logic;
            RESET : in std_logic;
            TRIGGER_IN : in std_logic;
            TRIGGER_OUT : out std_logic
        );
    end component;

    signal CLK_IN : std_logic := '0';
    signal CLK_OUT : std_logic := '0';
    signal RESET : std_logic := '0';
    signal TRIGGER_IN : std_logic := '0';
    signal TRIGGER_OUT : std_logic;

    constant CLK_IN_period : time := 10 ns;
    constant CLK_OUT_period : time := 100 ns;
    constant DELAY : time := 2 ns;
begin

    uut: InterclockTrigger
    port map(
        CLK_IN => CLK_IN,
        CLK_OUT => CLK_OUT,
        RESET => RESET,
        TRIGGER_IN => TRIGGER_IN,
        TRIGGER_OUT => TRIGGER_OUT
    );

    process
    begin
        CLK_IN <= '1';
        wait for CLK_IN_period / 2;
        CLK_IN <= '0';
        wait for CLK_IN_period / 2;
    end process;

    process
    begin
        CLK_OUT <= '1';
        wait for CLK_OUT_period / 2;
        CLK_OUT <= '0';
        wait for CLK_OUT_period / 2;
    end process;

    process
    begin
        RESET <= '1';
        wait for 10 ns;
        RESET <= '0';

        wait for CLK_IN_period * 2;
        wait for CLK_OUT_period * 2;
        wait until CLK_IN'event and CLK_IN = '1';

        TRIGGER_IN <= '1' after DELAY;
        wait for CLK_IN_period;
        TRIGGER_IN <= '0' after DELAY;

        wait;
    end process;
end behavior;
