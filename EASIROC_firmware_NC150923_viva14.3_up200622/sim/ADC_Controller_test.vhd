--------------------------------------------------------------------------------
--! @file   ADC_Controller_test.vhd
--! @brief  Test bench of ADC_Controller.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-11
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ADC_Controller_test is
end ADC_Controller_test;

architecture behavior of ADC_Controller_test is

    component ADC_Controller
        port(
            CLK : in  std_logic;
            ADC_CLK : in  std_logic;
            RESET : in  std_logic;
            TRIGGER : in  std_logic;
            FAST_CLEAR : in std_logic;
            BUSY : out  std_logic;
            CORE_START : out  std_logic;
            CORE_BUSY0 : in  std_logic;
            CORE_BUSY1 : in  std_logic;
            CORE_BUSY2 : in  std_logic;
            CORE_BUSY3 : in  std_logic;
            CLK_READ : out  std_logic;
            RSTB_READ : out std_logic;
            SRIN_READ : out  std_logic
    );
    end component;


    --Inputs
    signal CLK : std_logic := '0';
    signal ADC_CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal TRIGGER : std_logic := '0';
    signal FAST_CLEAR : std_logic := '0';
    signal CORE_BUSY0 : std_logic := '0';
    signal CORE_BUSY1 : std_logic := '0';
    signal CORE_BUSY2 : std_logic := '0';
    signal CORE_BUSY3 : std_logic := '0';

    --Outputs
    signal BUSY : std_logic;
    signal CORE_START : std_logic;
    signal CLK_READ : std_logic;
    signal RSTB_READ : std_logic;
    signal SRIN_READ : std_logic;

    -- Clock period definitions
    constant ADC_CLK_period : time := 333 ns;
    constant CLK_period : time := ADC_CLK_period / 2;
    constant DELAY : time := CLK_period * 0.2;

begin

    uut: ADC_Controller
    port map (
        CLK => CLK,
        ADC_CLK => ADC_CLK,
        RESET => RESET,
        TRIGGER => TRIGGER,
        FAST_CLEAR => FAST_CLEAR,
        BUSY => BUSY,
        CORE_START => CORE_START,
        CORE_BUSY0 => CORE_BUSY0,
        CORE_BUSY1 => CORE_BUSY1,
        CORE_BUSY2 => CORE_BUSY2,
        CORE_BUSY3 => CORE_BUSY3,
        CLK_READ => CLK_READ,
        RSTB_READ => RSTB_READ,
        SRIN_READ => SRIN_READ
    );

    process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    process
    begin
        ADC_CLK <= '1';
        wait for ADC_CLK_period/2;
        ADC_CLK <= '0';
        wait for ADC_CLK_period/2;
    end process;


    process

    procedure reset_uut is
    begin
        RESET <= '1';
        wait until CLK'event and CLK = '1';
        wait for CLK_period;
        RESET <= '0' after DELAY;
    end procedure;

    begin
        reset_uut;

        wait for CLK_period * 2;
        TRIGGER <= '1' after DELAY,
                   '0' after CLK_period * 2 + DELAY;

        wait for 20 us;

        TRIGGER <= '1' after DELAY,
                   '0' after CLK_period * 2 + DELAY;
        FAST_CLEAR <= '1' after CLK_period * 5 + DELAY,
                      '0' after CLK_period * 6 + DELAY;
        wait;
    end process;

end;
