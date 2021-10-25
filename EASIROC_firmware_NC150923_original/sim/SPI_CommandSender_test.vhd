--------------------------------------------------------------------------------
--! @file   SPI_CommandSender_test.vhd
--! @brief  Test bench of SPI_CommandSender.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-26
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SPI_CommandSender_test is
end SPI_CommandSender_test;

architecture behavior of SPI_CommandSender_test is
    component SPI_CommandSender is
        port(
            CLK : in std_logic;
            RESET : in std_logic;

            START : in std_logic;
            BUSY : out std_logic;
            LENGTH : in std_logic_vector(12 downto 0);

            WE : out std_logic;
            DOUT : out std_logic_vector(7 downto 0);
            WADDR : out std_logic_vector(12 downto 0);

            DIN : in std_logic_vector(7 downto 0);
            RADDR : out std_logic_vector(8 downto 0);

            SPI_SCLK : out std_logic;
            SPI_SS_N : out std_logic;
            SPI_MOSI : out std_logic;
            SPI_MISO : in std_logic
        );
    end component;

    signal CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal START : std_logic := '0';
    signal BUSY : std_logic;
    signal LENGTH : std_logic_vector(12 downto 0) := (others => 'X');
    signal WE : std_logic;
    signal DOUT : std_logic_vector(7 downto 0);
    signal WADDR : std_logic_vector(12 downto 0);
    signal DIN : std_logic_vector(7 downto 0) := (others => 'X');
    signal RADDR : std_logic_vector(8 downto 0);
    signal SPI_SCLK : std_logic;
    signal SPI_SS_N : std_logic;
    signal SPI_MOSI : std_logic;
    signal SPI_MISO : std_logic := '0';

    signal CLK_period : time := 15 ns;
    signal DELAY : time := 2 ns;
begin
    uut: SPI_CommandSender
    port map(
        CLK => CLK,
        RESET => RESET,
        START => START,
        BUSY => BUSY,
        LENGTH => LENGTH,
        WE => WE,
        DOUT => DOUT,
        WADDR => WADDR,
        DIN => DIN,
        RADDR => RADDR,
        SPI_SCLK => SPI_SCLK,
        SPI_SS_N => SPI_SS_N,
        SPI_MOSI => SPI_MOSI,
        SPI_MISO => SPI_MISO
    );

    process
    begin
        CLK <= '1';
        wait for CLK_period / 2;
        CLK <= '0';
        wait for CLK_period / 2;
    end process;

    process(CLK)
    begin
        if(CLK'event and CLK = '1') then
            case RADDR is
                when conv_std_logic_vector(0, 9) =>
                    DIN <= conv_std_logic_vector(0, 8);
                when conv_std_logic_vector(1, 9) =>
                    DIN <= conv_std_logic_vector(1, 8);
                when conv_std_logic_vector(2, 9) =>
                    DIN <= conv_std_logic_vector(2, 8);
                when conv_std_logic_vector(3, 9) =>
                    DIN <= conv_std_logic_vector(3, 8);
                when others =>
                    DIN <= (others => 'X');
            end case;
        end if;
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
        wait for CLK_period;
        wait until CLK'event and CLK = '1';
        RESET <= '0' after DELAY;

        wait for CLK_period;
        START <= '1' after DELAY;
        LENGTH <= conv_std_logic_vector(0, 13) after DELAY;
        wait for CLK_period;
        START <= '0' after DELAY;
        LENGTH <= (others => 'X') after DELAY;

        wait;
    end process;
end behavior;
