--------------------------------------------------------------------------------
--! @file   SPI_IF_test.vhd
--! @brief  Test bench of SPI_IF.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-24
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SPI_IF_test is
end SPI_IF_test;

architecture behavior of SPI_IF_test is
    component SPI_IF is
        port(
            CLK : in std_logic;
            RESET : in std_logic;

            DIN : in std_logic_vector(7 downto 0);
            DOUT : out std_logic_vector(7 downto 0);
            START : in std_logic;
            BUSY : out std_logic;

            SPI_SCLK : out std_logic;
            SPI_MISO : in std_logic;
            SPI_MOSI : out std_logic
        );
    end component;

    signal CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DIN : std_logic_vector(7 downto 0) := (others => 'X');
    signal DOUT : std_logic_vector(7 downto 0);
    signal START : std_logic := '0';
    signal BUSY : std_logic;
    signal SPI_SCLK : std_logic;
    signal SPI_MISO : std_logic := '0';
    signal SPI_MOSI : std_logic;

    signal CLK_period : time := 15 ns;
    signal DELAY : time := 2 ns;
begin

    uut: SPI_IF
    port map(
        CLK => CLK,
        RESET => RESET,
        DIN => DIN,
        DOUT => DOUT,
        START => START,
        BUSY => BUSY,
        SPI_SCLK => SPI_SCLK,
        SPI_MISO => SPI_MISO,
        SPI_MOSI => SPI_MOSI
    );

    process
    begin
        CLK <= '1';
        wait for CLK_period / 2;
        CLK <= '0';
        wait for CLK_period / 2;
    end process;

    process
    begin
        wait until SPI_SCLK'event and SPI_SCLK = '0';
        SPI_MISO <= '0';
        wait until SPI_SCLK'event and SPI_SCLK = '0';
        SPI_MISO <= '1';
        wait until SPI_SCLK'event and SPI_SCLK = '0';
        SPI_MISO <= '1';
        wait until SPI_SCLK'event and SPI_SCLK = '0';
        SPI_MISO <= '0';
        wait until SPI_SCLK'event and SPI_SCLK = '0';
        SPI_MISO <= '1';
        wait until SPI_SCLK'event and SPI_SCLK = '0';
        SPI_MISO <= '0';
        wait until SPI_SCLK'event and SPI_SCLK = '0';
        SPI_MISO <= '1';
        wait until SPI_SCLK'event and SPI_SCLK = '0';
        SPI_MISO <= '0';

        wait;
    end process;

    process
    begin
        RESET <= '1';
        wait for 100 ns;
        RESET <= '0';

        wait until CLK'event and CLK = '1';
        DIN <= X"A5" after DELAY;
        START <= '1' after DELAY;
        wait for CLK_period;
        DIN <= (others => 'X') after DELAY;
        START <= '0' after DELAY;

        wait;
    end process;

end behavior;
