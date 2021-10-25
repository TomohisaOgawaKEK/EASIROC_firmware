--------------------------------------------------------------------------------
--! @file   ClockManager_test.vhd
--! @brief  Test bench of ClockManager.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-12
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ClockManager_test is
end ClockManager_test;

architecture behavior of ClockManager_test is

    component ClockManager is
        port(
            EXT_CLK : in  std_logic;              -- 50MHz
            RESET : in  std_logic;
            LOCKED : out std_logic;               -- PLL Locked
            SITCP_CLK : out  std_logic;           -- 25MHz
            SLOWCONTROL_CLK : out  std_logic;     -- 6MHz
            ADC_CLK : out  std_logic;             -- 6MHz
            AD9220_CLK : out  std_logic;          -- 3MHz (Synchronized with ADC_CLK)
            AD9220_CLK_OUT : out std_logic;       -- 3MHz for AD9220
            AD9220_CLK_ENABLE : in std_logic;     -- AD9220 CLK Enable
            TDC_CLK : out std_logic;              -- 125MHz
            TDC_SAMPLING_CLK_0 : out std_logic;   -- 250MHz 0degree
            TDC_SAMPLING_CLK_90 : out std_logic;  -- 250MHz 90degree
            TDC_SAMPLING_CLK_180 : out std_logic; -- 250MHz 180degree
            TDC_SAMPLING_CLK_270 : out std_logic; -- 250MHz 270degree
            FAST_CLK : out std_logic              -- 500MHz
        );
    end component;

    signal EXT_CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal LOCKED : std_logic;
    signal SITCP_CLK : std_logic;
    signal SLOWCONTROL_CLK : std_logic;
    signal ADC_CLK : std_logic;
    signal AD9220_CLK : std_logic;
    signal AD9220_CLK_OUT : std_logic;
    signal AD9220_CLK_ENABLE : std_logic := '0';
    signal TDC_CLK : std_logic;
    signal TDC_SAMPLING_CLK_0 : std_logic;
    signal TDC_SAMPLING_CLK_90 : std_logic;
    signal TDC_SAMPLING_CLK_180 : std_logic;
    signal TDC_SAMPLING_CLK_270 : std_logic;
    signal FAST_CLK : std_logic;

    constant EXT_CLK_period : time := 20 ns; -- 50MHz

begin

    uut: ClockManager
    port map(
        EXT_CLK => EXT_CLK,
        RESET => RESET,
        LOCKED => LOCKED,
        SITCP_CLK => SITCP_CLK,
        SLOWCONTROL_CLK => SLOWCONTROL_CLK,
        ADC_CLK => ADC_CLK,
        AD9220_CLK => AD9220_CLK,
        AD9220_CLK_OUT => AD9220_CLK_OUT,
        AD9220_CLK_ENABLE => AD9220_CLK_ENABLE,
        TDC_CLK => TDC_CLK,
        TDC_SAMPLING_CLK_0 => TDC_SAMPLING_CLK_0,
        TDC_SAMPLING_CLK_90 => TDC_SAMPLING_CLK_90,
        TDC_SAMPLING_CLK_180 => TDC_SAMPLING_CLK_180,
        TDC_SAMPLING_CLK_270 => TDC_SAMPLING_CLK_270,
        FAST_CLK => FAST_CLK
    );

    process
    begin
        EXT_CLK <= '0';
        wait for EXT_CLK_period/2;
        EXT_CLK <= '1';
        wait for EXT_CLK_period/2;
    end process;

    process
    begin
        RESET <= '1';
        wait for EXT_CLK_period;
        RESET <= '0';
        wait;
    end process;

end;
