--------------------------------------------------------------------------------
--! @file   FineCounterDecoder_test.vhd
--! @brief  Test bench of FineCounterDecoder.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-06
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity FineCounterDecoder_test is
end FineCounterDecoder_test;

architecture behavior of FineCounterDecoder_test is
    component FineCounterDecoder is
        port (
            CLK_0 : in std_logic; -- 250MHz
            CLK : in std_logic;   -- 125MHz

            DIN : in std_logic_vector(3 downto 0);

            SEMI_FINE_COUNT : out std_logic;
            FINE_COUNT : out std_logic_vector(1 downto 0);
            HIT_FIND : out std_logic
        );
    end component;

    signal CLK_0 : std_logic := '0';
    signal CLK : std_logic := '0';
    signal DIN : std_logic_vector(3 downto 0) := (others => '0');
    signal SEMI_FINE_COUNT : std_logic;
    signal FINE_COUNT : std_logic_vector(1 downto 0);
    signal HIT_FIND : std_logic;

    constant CLK_0_period : time := 4 ns;
    constant CLK_period : time := 8 ns;
    constant DELAY : time := 2 ns;
begin

    uut: FineCounterDecoder
    port map (
        CLK_0 => CLK_0,
        CLK => CLK,
        DIN => DIN,
        SEMI_FINE_COUNT => SEMI_FINE_COUNT,
        FINE_COUNT => FINE_COUNT,
        HIT_FIND => HIT_FIND
    );

    process
    begin
        CLK_0 <= '1';
        wait for CLK_0_period / 2;
        CLK_0 <= '0';
        wait for CLK_0_period / 2;
    end process;

    process
    begin
        CLK <= '1';
        wait for CLK_period / 2;
        CLK <= '0';
        wait for CLK_period / 2;
    end process;

    process
    begin
        wait for CLK_period * 10;

        wait until CLK'event and CLK = '1';
        DIN <= "1110" after DELAY;
        wait for CLK_0_period;
        DIN <= "1111" after DELAY;
        wait for CLK_period * 2;
        DIN <= "0000" after DELAY;
        wait for CLK_period;

        wait until CLK'event and CLK = '1';
        wait for CLK_0_period;
        DIN <= "1110" after DELAY;
        wait for CLK_0_period;
        DIN <= "1111" after DELAY;
        wait for CLK_period * 2;
        DIN <= "0000" after DELAY;
        wait for CLK_period;

        wait until CLK'event and CLK = '1';
        DIN <= "1100" after DELAY;
        wait for CLK_0_period;
        DIN <= "1111" after DELAY;
        wait for CLK_period * 2;
        DIN <= "0000" after DELAY;
        wait for CLK_period;

        wait until CLK'event and CLK = '1';
        wait for CLK_0_period;
        DIN <= "1100" after DELAY;
        wait for CLK_0_period;
        DIN <= "1111" after DELAY;
        wait for CLK_period * 2;
        DIN <= "0000" after DELAY;
        wait for CLK_period;

        wait until CLK'event and CLK = '1';
        DIN <= "1000" after DELAY;
        wait for CLK_0_period;
        DIN <= "1111" after DELAY;
        wait for CLK_period * 2;
        DIN <= "0000" after DELAY;
        wait for CLK_period;

        wait until CLK'event and CLK = '1';
        wait for CLK_0_period;
        DIN <= "1000" after DELAY;
        wait for CLK_0_period;
        DIN <= "1111" after DELAY;
        wait for CLK_period * 2;
        DIN <= "0000" after DELAY;
        wait for CLK_period;

        wait until CLK'event and CLK = '1';
        DIN <= "0000" after DELAY;
        wait for CLK_0_period;
        DIN <= "1111" after DELAY;
        wait for CLK_period * 2;
        DIN <= "0000" after DELAY;
        wait for CLK_period;

        wait until CLK'event and CLK = '1';
        wait for CLK_0_period;
        DIN <= "0000" after DELAY;
        wait for CLK_0_period;
        DIN <= "1111" after DELAY;
        wait for CLK_period * 2;
        DIN <= "0000" after DELAY;
        wait for CLK_period;

        wait;
    end process;
end behavior;
