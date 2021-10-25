--------------------------------------------------------------------------------
--! @file   FineCounter_test.vhd
--! @brief  Test bench of FineCounter.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-06
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity FineCounter_test is
end FineCounter_test;

architecture behavior of FineCounter_test is
    component FineCounter is
        port (
            CLK_0 : in std_logic;
            CLK_90 : in std_logic;
            CLK_180 : in std_logic;
            CLK_270 : in std_logic;

            DIN : in std_logic;
            DOUT : out std_logic_vector(3 downto 0)
        );
    end component;

    signal CLK_0 : std_logic := '0';
    signal CLK_90 : std_logic := '0';
    signal CLK_180 : std_logic := '0';
    signal CLK_270 : std_logic := '0';

    signal DIN : std_logic := '0';
    signal DOUT : std_logic_vector(3 downto 0);

    constant CLK_period : time := 1 ns;
    constant DELAY : time := 0.5 ns;

begin

    uut: FineCounter
    port map(
        CLK_0 => CLK_0,
        CLK_90 => CLK_90,
        CLK_180 => CLK_180,
        CLK_270 => CLK_270,
        DIN => DIN,
        DOUT => DOUT
    );

    process
    begin
        CLK_0 <= '0';
        wait for CLK_period * 2;
        CLK_0 <= '1';
        wait for CLK_period * 2;
    end process;

    process
    begin
        CLK_90 <= '1';
        wait for CLK_period;
        CLK_90 <= '0';
        wait for CLK_period * 2;
        CLK_90 <= '1';
        wait for CLK_period;
    end process;

    process
    begin
        CLK_180 <= '1';
        wait for CLK_period * 2;
        CLK_180 <= '0';
        wait for CLK_period * 2;
    end process;

    process
    begin
        CLK_270 <= '0';
        wait for CLK_period;
        CLK_270 <= '1';
        wait for CLK_period * 2;
        CLK_270 <= '0';
        wait for CLK_period;
    end process;

    process
    begin
        wait for 10 ns;
        wait until CLK_0'event and CLK_0 = '1';
        DIN <= '1' after DELAY;
        wait for 8 ns;
        DIN <= '0' after DELAY;

        wait for 10 ns;
        wait until CLK_90'event and CLK_90 = '1';
        DIN <= '1' after DELAY;
        wait for 8 ns;
        DIN <= '0' after DELAY;

        wait for 10 ns;
        wait until CLK_180'event and CLK_180 = '1';
        DIN <= '1' after DELAY;
        wait for 8 ns;
        DIN <= '0' after DELAY;

        wait for 10 ns;
        wait until CLK_270'event and CLK_270 = '1';
        DIN <= '1' after DELAY;
        wait for 8 ns;
        DIN <= '0' after DELAY;

        wait;
    end process;
end behavior;
