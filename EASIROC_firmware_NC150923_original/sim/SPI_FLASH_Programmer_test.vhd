--------------------------------------------------------------------------------
--! @file   SPI_FLASH_Programmer_test.vhd
--! @brief  Test bench of SPI_FLASH_Programmer.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-26
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SPI_FLASH_Programmer_test is
end entity;

architecture behavior of SPI_FLASH_Programmer_test is
    component SPI_FLASH_Programmer is
        generic(
            G_SPI_FLASH_PROGRAMMER_ADDRESS : std_logic_vector(31 downto 0)
        );
        port(
            SPI_CLK : in std_logic;
            SITCP_CLK : in std_logic;
            RESET : in std_logic;

            RBCP_ACT : in std_logic;
            RBCP_ADDR : in std_logic_vector(31 downto 0);
            RBCP_WE : in std_logic;
            RBCP_WD : in std_logic_vector(7 downto 0);
            RBCP_RE : in std_logic;
            RBCP_RD : out std_logic_vector(7 downto 0);
            RBCP_ACK : out std_logic;

            SPI_SCLK : out std_logic;
            SPI_SS_N : out std_logic;
            SPI_MOSI : out std_logic;
            SPI_MISO : in std_logic;
            RECONFIGURATION_N : out std_logic
        );
    end component;

    signal SPI_CLK : std_logic := '0';
    signal SITCP_CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal RBCP_ACT : std_logic := '0';
    signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
    signal RBCP_WE : std_logic := '0';
    signal RBCP_WD : std_logic_vector(7 downto 0) := (others => 'X');
    signal RBCP_RE : std_logic := '0';
    signal RBCP_RD : std_logic_vector(7 downto 0);
    signal RBCP_ACK : std_logic;
    signal SPI_SCLK : std_logic;
    signal SPI_SS_N : std_logic;
    signal SPI_MOSI : std_logic;
    signal SPI_MISO : std_logic := '0';
    signal RECONFIGURATION_N : std_logic := '0';

    constant SPI_CLK_period : time := 15 ns;
    constant SITCP_CLK_period : time := 40 ns;
    constant DELAY : time := 3 ns;
begin

    uut: SPI_FLASH_Programmer
    generic map(
        G_SPI_FLASH_PROGRAMMER_ADDRESS => X"10000000"
    )
    port map(
        SPI_CLK => SPI_CLK,
        SITCP_CLK => SITCP_CLK,
        RESET => RESET,
        RBCP_ACT => RBCP_ACT,
        RBCP_ADDR => RBCP_ADDR,
        RBCP_WE => RBCP_WE,
        RBCP_WD => RBCP_WD,
        RBCP_RE => RBCP_RE,
        RBCP_RD => RBCP_RD,
        RBCP_ACK => RBCP_ACK,
        SPI_SCLK => SPI_SCLK,
        SPI_SS_N => SPI_SS_N,
        SPI_MOSI => SPI_MOSI,
        SPI_MISO => SPI_MISO,
        RECONFIGURATION_N => RECONFIGURATION_N
    );

    process
    begin
        SPI_CLK <= '1';
        wait for SPI_CLK_period / 2;
        SPI_CLK <= '0';
        wait for SPI_CLK_period / 2;
    end process;

    process
    begin
        SITCP_CLK <= '1';
        wait for SITCP_CLK_period / 2;
        SITCP_CLK <= '0';
        wait for SITCP_CLK_period / 2;
    end process;

    -- process drive MISO
    process
        variable data : std_logic_vector(31 downto 0) := X"01234567";
    begin
        wait until RESET = '0';
        for i in 31 downto 0 loop
            SPI_MISO <= data(i);
            wait until SPI_SCLK'event and SPI_SCLK = '0';
        end loop;
        wait;
    end process;

    process
    procedure write_data(
        addr : std_logic_vector(31 downto 0);
        data : std_logic_vector(7 downto 0)
    )is
    begin
        wait for SITCP_CLK_period;
        RBCP_ACT <= '1' after DELAY;
        wait for SITCP_CLK_period*2;

        RBCP_ADDR <= addr after DELAY;
        RBCP_WE <= '1' after DELAY;
        RBCP_WD <= data after DELAY;
        wait for SITCP_CLK_period;

        RBCP_ADDR <= (others => '0') after DELAY;
        RBCP_WE <= '0' after DElAY;
        RBCP_WD <= (others => '0') after DELAY;

        wait until RBCP_ACK'event and RBCP_ACK = '1';
        wait for SITCP_CLK_period;
        RBCP_ACT <= '0' after DELAY;
    end procedure;

    procedure read_data(
        addr : std_logic_vector(31 downto 0)
    )is
    begin
        wait for SITCP_CLK_period;
        RBCP_ACT <= '1' after DELAY;
        wait for SITCP_CLK_period*2;

        RBCP_ADDR <= addr after DELAY;
        RBCP_RE <= '1' after DELAY;
        wait for SITCP_CLK_period;

        RBCP_ADDR <= (others => '0') after DELAY;
        RBCP_RE <= '0' after DELAY;

        wait until RBCP_ACK'event and RBCP_ACK = '1';
        wait for SITCP_CLK_period;
        RBCP_ACT <= '0' after DELAY;
    end procedure;

    begin
        RESET <= '1';
        wait for 100 ns;
        wait until SITCP_CLK'event and SITCP_CLK = '1';
        RESET <= '0' after DELAY;

        wait for SITCP_CLK_period;

        -- Length
        write_data(X"10000001", X"00");
        write_data(X"10000002", X"03");

        -- Data
        write_data(X"10000003", X"01");
        write_data(X"10000004", X"02");
        write_data(X"10000005", X"03");
        write_data(X"10000006", X"04");

        -- Start
        write_data(X"10000000", X"00");

        wait for 20 * SITCP_CLK_period;
        write_data(X"10000000", X"4d");
        write_data(X"10000000", X"49");
        write_data(X"10000000", X"57");
        write_data(X"10000000", X"41");

        wait;
    end process;

end behavior;
