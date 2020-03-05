--------------------------------------------------------------------------------
--! @file   SingleScaler.vhd
--! @brief  Test bench of SingleScaler.vhd
--! @author Takehiro Shiozaki
--! @date   2014-08-18
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SingleScaler_test is
end SingleScaler_test;

architecture behavior of SingleScaler_test is
    component SingleScaler is
        generic(
            G_BITS : integer
        );
        port(
            CLK : in std_logic;
            RESET : in std_logic;
            DIN : in std_logic;
            DOUT : out std_logic_vector(G_BITS - 1 downto 0);
            OVERFLOW : out std_logic
        );
    end component;

    signal CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DIN : std_logic := '0';
    signal DOUT : std_logic_vector(1 downto 0);
    signal OVERFLOW : std_logic;

    constant CLK_period : time := 4 ns;
    constant DELAY : time := 1 ns;
begin

    uut : SingleScaler
    generic map(
        G_BITS => 2
    )
    port map(
        CLK => CLK,
        RESET => RESET,
        DIN => DIN,
        DOUT => DOUT,
        OVERFLOW => OVERFLOW
    );

    process
    begin
        CLK <= '0';
        wait for CLK_period / 2;
        CLK <= '1';
        wait for CLK_period / 2;
    end process;

    process
    begin
        RESET <= '1';
        wait for CLK_period * 2;
        wait until CLK'event and CLK = '1';
        RESET <= '0' after DELAY;
        wait for CLK_period;

        DIN <= '1';
        wait for CLK_period * 3;
        DIN <= '0';
        wait for CLK_period * 2;
        DIN <= '1';
        wait for CLK_period * 4;
        DIN <= '0';
        wait for CLK_period * 6;
        DIN <= '1';
        wait for CLK_period * 1;
        DIN <= '0';
        wait for CLK_period * 9;
        DIN <= '1';
        wait for CLK_period * 7;
        DIN <= '0';
        wait for CLK_period * 2;

        wait;
    end process;
end behavior;
