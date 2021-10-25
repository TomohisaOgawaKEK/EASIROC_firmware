--------------------------------------------------------------------------------
--! @file   MHTDC_Builder_test.vhd
--! @brief  Test bench of MHTDC_Builder.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-09
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.MHTDC_DataType.all;

entity MHTDC_Builder_test is
end MHTDC_Builder_test;

architecture behavior of MHTDC_Builder_test is
    component MHTDC_Builder is
        generic(
            G_LT : std_logic := '0'
        );
        port(
            TDC_CLK : in std_logic;
            RESET : in std_logic;

            DIN : in MHTDC_CounterArray;
            RE : out std_logic_vector(63 downto 0);
            EMPTY : in std_logic_vector(63 downto 0);
            CLEAR : out std_logic_vector(63 downto 0);

            -- Commom Stop interface
            COMMON_STOP : in std_logic;
            COMMON_STOP_COUNT : in std_logic_vector(45 downto 0);
            FAST_CLEAR : in std_logic;

            -- Double buffer interface
            DOUT : out std_logic_vector(19 downto 0);
            WADDR : out std_logic_vector(10 downto 0);
            WE : out std_logic;
            FULL : in std_logic;
            WCOMP : out std_logic;

            -- Control interface
            TIME_WINDOW : in std_logic_vector(11 downto 0);
            BUSY : out std_logic
        );
    end component;

    signal TDC_CLK : std_logic := '0';
    signal RESET : std_logic := '0';

    signal DIN : MHTDC_CounterArray := (
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46),
        conv_std_logic_vector(0, 46), conv_std_logic_vector(0, 46)
    );
    signal RE : std_logic_vector(63 downto 0);
    signal EMPTY : std_logic_vector(63 downto 0) := X"FFFFFFFFFFFFFFFF";
    signal CLEAR : std_logic_vector(63 downto 0);

    signal COMMON_STOP : std_logic := '0';
    signal COMMON_STOP_COUNT : std_logic_vector(45 downto 0) := (others => '0');
    signal FAST_CLEAR : std_logic := '0';

    signal DOUT : std_logic_vector(19 downto 0);
    signal WADDR : std_logic_vector(10 downto 0);
    signal WE : std_logic;
    signal FULL : std_logic := '0';
    signal WCOMP : std_logic;

    signal TIME_WINDOW : std_logic_vector(11 downto 0) := (others => '0');
    signal BUSY : std_logic;

    constant TDC_CLK_period : time := 8 ns;
    constant DELAY : time := 2 ns;
begin

    uut: MHTDC_Builder
    generic map(
        G_LT => '0'
    )
    port map(
        TDC_CLK => TDC_CLK,
        RESET => RESET,

        DIN => DIN,
        RE => RE,
        EMPTY => EMPTY,
        CLEAR => CLEAR,

        COMMON_STOP => COMMON_STOP,
        COMMON_STOP_COUNT => COMMON_STOP_COUNT,
        FAST_CLEAR => FAST_CLEAR,

        DOUT => DOUT,
        WADDR => WADDR,
        WE => WE,
        FULL => FULL,
        WCOMP => WCOMP,

        TIME_WINDOW => TIME_WINDOW,
        BUSY => BUSY
    );

    process
    begin
        TDC_CLK <= '0';
        wait for TDC_CLK_period / 2;
        TDC_CLK <= '1';
        wait for TDC_CLK_period / 2;
    end process;

    -- CH0
    process
    begin
        EMPTY(0) <= '0' after DELAY;
        for i in 0 to 2 loop
            wait until RE(0) = '1';
            wait for TDC_CLK_period;
            case i is
                when 0 =>
                    DIN(0) <= conv_std_logic_vector(90, 46) after DELAY;
                when 1 =>
                    DIN(0) <= conv_std_logic_vector(80, 46) after DELAY;
                when 2 =>
                    DIN(0) <= conv_std_logic_vector(70, 46) after DELAY;
                when others =>
                    DIN(0) <= conv_std_logic_vector(0, 46) after DELAY;
            end case;
        end loop;
        EMPTY(0) <= '1' after DELAY;
        wait;
    end process;

    -- CH1
    process
    begin
        EMPTY(1) <= '0' after DELAY;
        for i in 0 to 3 loop
            wait until RE(1) = '1';
            wait for TDC_CLK_period;
            case i is
                when 0 =>
                    DIN(1) <= conv_std_logic_vector(60, 46) after DELAY;
                when 1 =>
                    DIN(1) <= conv_std_logic_vector(55, 46) after DELAY;
                when 2 =>
                    DIN(1) <= conv_std_logic_vector(45, 46) after DELAY;
                when 3 =>
                    DIN(1) <= conv_std_logic_vector(35, 46) after DELAY;
                when others =>
                    DIN(1) <= conv_std_logic_vector(0, 46) after DELAY;
            end case;
        end loop;
        EMPTY(1) <= '1' after DELAY;
        wait;
    end process;

    -- CH63
    process
    begin
        EMPTY(63) <= '0' after DELAY;
        for i in 0 to 2 loop
            wait until RE(63) = '1';
            wait for TDC_CLK_period;
            case i is
                when 0 =>
                    DIN(63) <= conv_std_logic_vector(90, 46) after DELAY;
                when 1 =>
                    DIN(63) <= conv_std_logic_vector(80, 46) after DELAY;
                when 2 =>
                    DIN(63) <= conv_std_logic_vector(70, 46) after DELAY;
                when others =>
                    DIN(63) <= conv_std_logic_vector(0, 46) after DELAY;
            end case;
        end loop;
        EMPTY(63) <= '1' after DELAY;
        wait;
    end process;

    process
    begin
        RESET <= '1';
        wait for 100 ns;
        wait until TDC_CLK'event and TDC_CLK = '1';
        RESET <= '0' after DELAY;

        wait until TDC_CLK'event and TDC_CLK = '1';
        COMMON_STOP <= '1' after DELAY;
        COMMON_STOP_COUNT <= conv_std_logic_vector(100, 46) after DELAY;
        TIME_WINDOW <= conv_std_logic_vector(50, 12) after DELAY;
        wait for TDC_CLK_period;
        COMMON_STOP <= '0' after DELAY;
        COMMON_STOP_COUNT <= conv_std_logic_vector(0, 46) after DELAY;

        wait;
    end process;
end behavior;
