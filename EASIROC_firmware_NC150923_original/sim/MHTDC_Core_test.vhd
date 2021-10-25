--------------------------------------------------------------------------------
--! @file   MHTDC_Core_test.vhd
--! @brief  Test bench of MHTDC_Core.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-10
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity MHTDC_Core_test is
end MHTDC_Core_test;

architecture behavior of MHTDC_Core_test is
    component MHTDC_Core is
        port(
            CLK : in std_logic;     -- 125MHz
            CLK_0 : in std_logic;   -- 250MHz 0degree
            CLK_90 : in std_logic;  -- 250MHz 90degree
            CLK_180 : in std_logic; -- 250MHz 180degree
            CLK_270 : in std_logic; -- 250MHz 270degree
            RESET : in std_logic;

            DIN : in std_logic_vector(63 downto 0);
            COMMON_STOP : in std_logic;

            -- Eventbuffer interface(Leading)
            DOUT_L : out std_logic_vector(19 downto 0);
            ADDR_L : out std_logic_vector(10 downto 0);
            WE_L : out std_logic;
            FULL_L : in std_logic;
            WCOMP_L : out std_logic;

            -- Eventbuffer interface(Trailing)
            DOUT_T : out std_logic_vector(19 downto 0);
            ADDR_T : out std_logic_vector(10 downto 0);
            WE_T : out std_logic;
            FULL_T : in std_logic;
            WCOMP_T : out std_logic;

            BUSY : out std_logic
        );
    end component;

    signal CLK : std_logic := '0';
    signal CLK_0 : std_logic := '0';
    signal CLK_90 : std_logic := '0';
    signal CLK_180 : std_logic := '0';
    signal CLK_270 : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DIN : std_logic_vector(63 downto 0) := (others => '0');
    signal COMMON_STOP : std_logic := '0';
    signal DOUT_L : std_logic_vector(19 downto 0);
    signal ADDR_L : std_logic_vector(10 downto 0);
    signal WE_L : std_logic;
    signal FULL_L : std_logic := '0';
    signal WCOMP_L : std_logic := '0';
    signal DOUT_T : std_logic_vector(19 downto 0);
    signal ADDR_T : std_logic_vector(10 downto 0);
    signal WE_T : std_logic;
    signal FULL_T : std_logic := '0';
    signal WCOMP_T : std_logic := '0';
    signal BUSY : std_logic;

    constant CLK_0_period : time := 4 ns;
    constant CLK_period : time := 8 ns;
    constant DELAY : time := 0.5 ns;
begin

    uut: MHTDC_Core
    port map(
        CLK => CLK,
        CLK_0 => CLK_0,
        CLK_90 => CLK_90,
        CLK_180 => CLK_180,
        CLK_270 => CLK_270,
        RESET => RESET,
        DIN => DIN,
        COMMON_STOP => COMMON_STOP,
        DOUT_L => DOUT_L,
        ADDR_L => ADDR_L,
        WE_L => WE_L,
        FULL_L => FULL_L,
        WCOMP_L => WCOMP_L,
        DOUT_T => DOUT_T,
        ADDR_T => ADDR_T,
        WE_T => WE_T,
        FULL_T => FULL_T,
        WCOMP_T => WCOMP_T
    );

    process
    begin
        CLK_0 <= '0';
        wait for CLK_0_period / 2;
        CLK_0 <= '1';
        wait for CLK_0_period / 2;
    end process;

    process
    begin
        CLK_90 <= '1';
        wait for CLK_0_period / 4;
        CLK_90 <= '0';
        wait for CLK_0_period / 2;
        CLK_90 <= '1';
        wait for CLK_0_period / 4;
    end process;

    process
    begin
        CLK_180 <= '1';
        wait for CLK_0_period / 2;
        CLK_180 <= '0';
        wait for CLK_0_period / 2;
    end process;

    process
    begin
        CLK_270 <= '0';
        wait for CLK_0_period/ 4;
        CLK_270 <= '1';
        wait for CLK_0_period / 2;
        CLK_270 <= '0';
        wait for CLK_0_period / 4;
    end process;

    process
    begin
        CLK <= '0';
        wait for CLK_period / 4;
        CLK <= '1';
        wait for CLK_period / 2;
        CLK <= '0';
        wait for CLK_period / 4;
    end process;

    -- CH0
    process
    begin
        wait until RESET = '0';
        wait for CLK_period;
        wait until CLK'event and CLK = '1';

        DIN(0) <= '1';
        wait for 10 ns;
        DIN(0) <= '0';
        wait for 20 ns;

        DIN(0) <= '1';
        wait for 30 ns;
        DIN(0) <= '0';
        wait for 40 ns;

        DIN(0) <= '1';
        wait for 50 ns;
        DIN(0) <= '0';
        wait for 60 ns;

        DIN(0) <= '1';
        wait for 60 ns;
        DIN(0) <= '0';
        wait for 50 ns;

        DIN(0) <= '1';
        wait for 40 ns;
        DIN(0) <= '0';
        wait for 30 ns;

        DIN(0) <= '1';
        wait for 20 ns;
        DIN(0) <= '0';
        wait for 10 ns;
        wait;
    end process;

    -- CH1
    process
    begin
        wait until RESET = '0';
        wait for CLK_period;
        wait until CLK'event and CLK = '1';

        DIN(1) <= '1';
        wait for 15 ns;
        DIN(1) <= '0';
        wait for 25 ns;

        DIN(1) <= '1';
        wait for 28 ns;
        DIN(1) <= '0';
        wait for 45 ns;

        DIN(1) <= '1';
        wait for 47 ns;
        DIN(1) <= '0';
        wait for 62 ns;

        DIN(1) <= '1';
        wait for 53 ns;
        DIN(1) <= '0';
        wait for 35 ns;

        DIN(1) <= '1';
        wait for 42 ns;
        DIN(1) <= '0';
        wait for 26 ns;

        DIN(1) <= '1';
        wait for 23 ns;
        DIN(1) <= '0';
        wait for 8 ns;
        wait;

    end process;

    -- CH2
    process
    begin
        wait until RESET = '0';
        wait for CLK_period;
        wait until CLK'event and CLK = '1';

        DIN(2) <= '1';
        wait for 18 ns;
        DIN(2) <= '0';
        wait for 28 ns;

        DIN(2) <= '1';
        wait for 24 ns;
        DIN(2) <= '0';
        wait for 36 ns;

        DIN(2) <= '1';
        wait for 54 ns;
        DIN(2) <= '0';
        wait for 50 ns;

        DIN(2) <= '1';
        wait for 56 ns;
        DIN(2) <= '0';
        wait for 22 ns;

        DIN(2) <= '1';
        wait for 29 ns;
        DIN(2) <= '0';
        wait for 35 ns;

        DIN(2) <= '1';
        wait for 10 ns;
        DIN(2) <= '0';
        wait for 16 ns;
        wait;

    end process;

    -- CH63
    process
    begin
        wait until RESET = '0';
        wait for CLK_period;
        wait until CLK'event and CLK = '1';

        DIN(63) <= '1';
        wait for 27 ns;
        DIN(63) <= '0';
        wait for 20 ns;

        DIN(63) <= '1';
        wait for 28 ns;
        DIN(63) <= '0';
        wait for 40 ns;

        DIN(63) <= '1';
        wait for 35 ns;
        DIN(63) <= '0';
        wait for 40 ns;

        DIN(63) <= '1';
        wait for 12 ns;
        DIN(63) <= '0';
        wait for 32 ns;

        DIN(63) <= '1';
        wait for 19 ns;
        DIN(63) <= '0';
        wait for 24 ns;

        DIN(63) <= '1';
        wait for 24 ns;
        DIN(63) <= '0';
        wait for 16 ns;
        wait;

    end process;

    process
    begin
        RESET <= '1';
        wait for 100 ns;
        wait until CLK'event and CLK = '1';
        RESET <= '0' after DELAY;
        wait for CLK_period;

        wait for 1 us;
        COMMON_STOP <= '1';
        wait for 20 ns;
        COMMON_STOP <= '0';
        wait;
    end process;
end behavior;
