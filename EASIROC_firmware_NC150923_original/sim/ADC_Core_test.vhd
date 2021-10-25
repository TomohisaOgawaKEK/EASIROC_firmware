--------------------------------------------------------------------------------
--! @file   ADC_Core_test.vhd
--! @brief  Test bench of ADC_Core.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-11
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ADC_Core_test is
end ADC_Core_test;

architecture behavior of ADC_Core_test is

    component ADC_Core
    generic(
        G_IS_LAST_CHANNEL : std_logic;
        G_IS_LOW_GAIN : std_logic;
        G_PEDESTAL_SUPPRESSION_ADDR : std_logic_vector(31 downto 0)
    );
    port(
        ADC_CLK : in  std_logic;
        RESET : in  std_logic;
        START : in  std_logic;
        FAST_CLEAR : in std_logic;
        BUSY : out  std_logic;
        ADC_DATA : in  std_logic_vector(11 downto 0);
        ADC_OTR : in  std_logic;
        DOUT : out  std_logic_vector(20 downto 0);
        ADDR : out  std_logic_vector(5 downto 0);
        WE : out  std_logic;
        FULL : in  std_logic;
        WCOMP : out  std_logic;
        DEC_WPTR : out std_logic;
        RBCP_CLK : in std_logic;
        RBCP_ACT : in std_logic;
        RBCP_ADDR : in std_logic_vector(31 downto 0);
        RBCP_WE : in std_logic;
        RBCP_WD : in std_logic_vector(7 downto 0);
        RBCP_ACK : out std_logic
    );
    end component;


    --Inputs
    signal ADC_CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal START : std_logic := '0';
    signal FAST_CLEAR : std_logic := '0';
    signal ADC_DATA : std_logic_vector(11 downto 0) := (others => '0');
    signal ADC_OTR : std_logic := '0';
    signal FULL : std_logic := '0';
    signal RBCP_CLK : std_logic := '0';
    signal RBCP_ACT : std_logic := '0';
    signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
    signal RBCP_WD : std_logic_vector(7 downto 0) := (others => '0');
    signal RBCP_WE : std_logic := '0';

    --Outputs
    signal BUSY : std_logic;
    signal DOUT : std_logic_vector(20 downto 0);
    signal ADDR : std_logic_vector(5 downto 0);
    signal WE : std_logic;
    signal WCOMP : std_logic;
    signal DEC_WPTR : std_logic;
    signal RBCP_ACK : std_logic;

    -- Clock period definitions
    constant ADC_CLK_period : time := 10 ns;
    constant DELAY : time := ADC_CLK_period * 0.2;
    constant RBCP_CLK_period : time := 15 ns;

begin

    uut: ADC_Core
    generic map (
        G_IS_LAST_CHANNEL => '1',
        G_IS_LOW_GAIN => '0',
        G_PEDESTAL_SUPPRESSION_ADDR => X"10000000"
    )
    port map (
        ADC_CLK => ADC_CLK,
        RESET => RESET,
        START => START,
        FAST_CLEAR => FAST_CLEAR,
        BUSY => BUSY,
        ADC_DATA => ADC_DATA,
        ADC_OTR => ADC_OTR,
        DOUT => DOUT,
        ADDR => ADDR,
        WE => WE,
        FULL => FULL,
        WCOMP => WCOMP,
        DEC_WPTR => DEC_WPTR,
        RBCP_CLK => RBCP_CLK,
        RBCP_ACT => RBCP_ACT,
        RBCP_ADDR => RBCP_ADDR,
        RBCP_WE => RBCP_WE,
        RBCP_WD => RBCP_WD,
        RBCP_ACK => RBCP_ACK
    );

    process
    begin
        ADC_CLK <= '0';
        wait for ADC_CLK_period/2;
        ADC_CLK <= '1';
        wait for ADC_CLK_period/2;
    end process;

    process
    begin
        RBCP_CLK <= '0';
        wait for RBCP_CLK_period / 2;
        RBCP_CLK <= '1';
        wait for RBCP_CLK_period / 2;
    end process;

    process

    procedure reset_uut is
    begin
        RESET <= '1';
        wait until ADC_CLK'event and ADC_CLK = '1';
        wait for ADC_CLK_period;
        RESET <= '0' after DELAY;
    end procedure;

    procedure write_data(
        addr : std_logic_vector(31 downto 0);
        data : std_logic_vector(7 downto 0)
        ) is
    begin
        wait until RBCP_CLK'event and RBCP_CLK = '1';
        RBCP_ACT <= '1' after DELAY;
        wait for RBCP_CLK_period;

        RBCP_WE <= '1' after DELAY;
        RBCP_ADDR <= addr after DELAY;
        RBCP_WD <= data after DELAY;
        wait for RBCP_CLK_period;

        RBCP_WE <= '0' after DELAY;
        RBCP_ADDR <= (others => '0') after DELAY;
        RBCP_WD <= (others => '0') after DELAY;
        wait for RBCP_CLK_period;

        RBCP_ACT <= '0' after DELAY;
    end procedure;

    procedure write_threshold(
        ch : integer range 0 to 31;
        th : std_logic_vector(11 downto 0)
        ) is
    begin
        write_data(X"10000000" + 2 * ch, X"0" & th(11 downto 8));
        write_data(X"10000000" + 2 * ch + 1, th(7 downto 0));
    end procedure;

    begin
        reset_uut;

        write_threshold(0, X"000");
        write_threshold(1, X"000");
        write_threshold(2, X"000");
        write_threshold(3, X"000");
        write_threshold(4, X"000");
        write_threshold(5, X"000");
        write_threshold(6, X"000");
        write_threshold(7, X"000");
        write_threshold(8, X"000");
        write_threshold(9, X"000");
        write_threshold(10, X"000");
        write_threshold(11, X"000");
        write_threshold(12, X"000");
        write_threshold(13, X"000");
        write_threshold(14, X"000");
        write_threshold(15, X"000");
        write_threshold(16, X"000");
        write_threshold(17, X"000");
        write_threshold(18, X"000");
        write_threshold(19, X"000");
        write_threshold(20, X"000");
        write_threshold(21, X"000");
        write_threshold(22, X"000");
        write_threshold(23, X"000");
        write_threshold(24, X"000");
        write_threshold(25, X"000");
        write_threshold(26, X"000");
        write_threshold(27, X"000");
        write_threshold(28, X"000");
        write_threshold(29, X"000");
        write_threshold(30, X"000");
        write_threshold(31, X"0FF");

        wait until ADC_CLK'event and ADC_CLK = '1';
        START <= '1' after DELAY,
        '0' after ADC_CLK_period + DELAY;
        FULL <= '1' after DELAY,
        '0' after ADC_CLK_period * 80 + DELAY;

        for i in 0 to 31 loop
            wait until ADC_CLK'event and ADC_CLK = '1';
            wait until ADC_CLK'event and ADC_CLK = '1';
            ADC_DATA <= ADC_DATA + 1 after DELAY;
        end loop;
        wait until BUSY = '0';

        wait until ADC_CLK'event and ADC_CLK = '1';
        START <= '1' after DELAY,
                 '0' after ADC_CLK_period + DELAY;
        FULL <= '1' after DELAY,
                '0' after ADC_CLK_period * 80 + DELAY;
        FAST_CLEAR <= '1' after ADC_CLK_period * 20 + DELAY,
                      '0' after ADC_CLK_period * 21 + DELAY;

        for i in 0 to 31 loop
            wait until ADC_CLK'event and ADC_CLK = '1';
            wait until ADC_CLK'event and ADC_CLK = '1';
            ADC_DATA <= ADC_DATA + 1 after DELAY;
        end loop;

        wait until ADC_CLK'event and ADC_CLK = '1';
        START <= '1' after DELAY,
                 '0' after ADC_CLK_period + DELAY;
        FULL <= '1' after DELAY,
                '0' after ADC_CLK_period * 80 + DELAY;
        FAST_CLEAR <= '1' after ADC_CLK_period * 100 + DELAY,
                      '0' after ADC_CLK_period * 101 + DELAY;

        for i in 0 to 31 loop
            wait until ADC_CLK'event and ADC_CLK = '1';
            wait until ADC_CLK'event and ADC_CLK = '1';
            ADC_DATA <= ADC_DATA + 1 after DELAY;
        end loop;

        wait until DEC_WPTR = '1';
        wait for ADC_CLK_period * 3;

        wait until ADC_CLK'event and ADC_CLK = '1';
        START <= '1' after DELAY,
                 '0' after ADC_CLK_period + DELAY;
        FULL <= '1' after DELAY,
                '0' after ADC_CLK_period * 80 + DELAY;
        FAST_CLEAR <= '1' after ADC_CLK_period * 81 + DELAY,
                      '0' after ADC_CLK_period * 82 + DELAY;

        for i in 0 to 31 loop
            wait until ADC_CLK'event and ADC_CLK = '1';
            wait until ADC_CLK'event and ADC_CLK = '1';
            ADC_DATA <= ADC_DATA + 1 after DELAY;
        end loop;

        wait;
    end process;

end;
