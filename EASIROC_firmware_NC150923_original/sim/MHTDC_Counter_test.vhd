--------------------------------------------------------------------------------
--! @file   MHTDC_Counter_test.vhd
--! @brief  Test bench of MHTDC_Counter.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-07
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity MHTDC_Counter_test is
end MHTDC_Counter_test;

architecture behavior of MHTDC_Counter_test is
    component MHTDC_Counter is
        port(
            CLK_0 : in std_logic;   -- 250MHz 0degree
            CLK_90 : in std_logic;  -- 250MHz 90degree
            CLK_180 : in std_logic; -- 250MHz 180degree
            CLK_270 : in std_logic; -- 250MHz 270degree
            CLK : in std_logic;     -- 125MHz

            DIN : in std_logic;
            COARSE_COUNT : in std_logic_vector(42 downto 0);
            COUNT : out std_logic_vector(45 downto 0);
            HIT_FIND : out std_logic
        );
    end component;

    signal CLK_0 : std_logic := '0';
    signal CLK_90 : std_logic := '0';
    signal CLK_180 : std_logic := '0';
    signal CLK_270 : std_logic := '0';
    signal CLK : std_logic := '0';
    signal DIN : std_logic := '0';
    signal COARSE_COUNT : std_logic_vector(42 downto 0) := (others => 'X');
    signal COUNT : std_logic_vector(45 downto 0);
    signal HIT_FIND : std_logic;

    constant CLK_0_period : time := 4 ns;
    constant CLK_period : time := 8 ns;
    constant DELAY : time := 0.5 ns;
begin
    uut: MHTDC_Counter
    port map(
        CLK_0 => CLK_0,
        CLK_90 => CLK_90,
        CLK_180 => CLK_180,
        CLK_270 => CLK_270,
        CLK => CLK,
        DIN => DIN,
        COARSE_COUNT => COARSE_COUNT,
        COUNT => COUNT,
        HIT_FIND => HIT_FIND
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

    process
        procedure assert_din(din_delay : in time) is
        begin
            wait until CLK'event and CLK = '1';
            DIN <= '1' after DELAY + din_delay;
            COARSE_COUNT <= conv_std_logic_vector(1, 43),
                            conv_std_logic_vector(2, 43) after CLK_period * 1,
                            conv_std_logic_vector(3, 43) after CLK_period * 2,
                            conv_std_logic_vector(4, 43) after CLK_period * 3,
                            conv_std_logic_vector(5, 43) after CLK_period * 4,
                            conv_std_logic_vector(6, 43) after CLK_period * 5,
                            conv_std_logic_vector(7, 43) after CLK_period * 6,
                            (others => '0') after CLK_period * 7;
            wait for CLK_period * 2;
            DIN <= '0' after DELAY + din_delay;
            wait until COARSE_COUNT = conv_std_logic_vector(0, 43);
            COARSE_COUNT <= (others => 'X');
            wait for CLK_period * 2;
        end procedure;

        procedure check_minimum_pulse_width(din_delay : in time) is
        begin
            wait until CLK'event and CLK = '1';
            DIN <= '1' after DELAY + din_delay;
            wait for 7 ns + din_delay;
            DIN <= '0' after DELAY;
        end procedure;

        procedure check_double_hit_resolution(din_delay : in time) is
        begin
            wait until CLK'event and CLK = '1';
            COARSE_COUNT <= conv_std_logic_vector(1, 43),
                            conv_std_logic_vector(2, 43) after CLK_period * 1,
                            conv_std_logic_vector(3, 43) after CLK_period * 2,
                            conv_std_logic_vector(4, 43) after CLK_period * 3,
                            conv_std_logic_vector(5, 43) after CLK_period * 4,
                            conv_std_logic_vector(6, 43) after CLK_period * 5,
                            conv_std_logic_vector(7, 43) after CLK_period * 6,
                            (others => '0') after CLK_period * 7;
            wait for din_delay;
            DIN <= '1' after DELAY;
            wait for 7 ns;
            DIN <= '0' after DELAY;
            wait for 4 ns;
            DIN <= '1' after DELAY;
            wait for 7 ns;
            DIN <= '0' after DELAY;
            wait until COARSE_COUNT = conv_std_logic_vector(0, 43);
            COARSE_COUNT <= (others => 'X');
        end procedure;
    begin
        wait for 30 ns;

        assert_din(0 ns);
        assert_din(1 ns);
        assert_din(2 ns);
        assert_din(3 ns);
        assert_din(4 ns);
        assert_din(5 ns);
        assert_din(6 ns);
        assert_din(7 ns);
        assert_din(8 ns);
        assert_din(9 ns);
        assert_din(10 ns);
        assert_din(11 ns);
        assert_din(12 ns);
        assert_din(13 ns);
        assert_din(14 ns);
        assert_din(15 ns);

        -- Minimum pulse width
        check_minimum_pulse_width(0 ns);
        wait for CLK_period * 3;
        check_minimum_pulse_width(1 ns);
        wait for CLK_period * 3;
        check_minimum_pulse_width(2 ns);
        wait for CLK_period * 3;
        check_minimum_pulse_width(3 ns);
        wait for CLK_period * 3;
        check_minimum_pulse_width(4 ns);
        wait for CLK_period * 3;
        check_minimum_pulse_width(5 ns);
        wait for CLK_period * 3;
        check_minimum_pulse_width(6 ns);
        wait for CLK_period * 3;
        check_minimum_pulse_width(7 ns);
        wait for CLK_period * 3;

        -- Double Hit resolution
        check_double_hit_resolution(0 ns);
        check_double_hit_resolution(1 ns);
        check_double_hit_resolution(2 ns);
        check_double_hit_resolution(3 ns);
        check_double_hit_resolution(4 ns);
        check_double_hit_resolution(5 ns);
        check_double_hit_resolution(6 ns);
        check_double_hit_resolution(7 ns);

        wait;
    end process;
end behavior;
