--------------------------------------------------------------------------------
--! @file   ScalerTimer.vhd
--! @brief  Timer for Scaler
--! @author Takehiro Shiozaki
--! @date   2014-08-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ScalerTimer is
    port(
        SCALER_CLK : in std_logic; -- 125MHz
        RESET : in std_logic;
        TIMER_1MHZ : out std_logic;
        TIMER_1KHZ : out std_logic
    );
end ScalerTimer;

architecture RTL of ScalerTimer is
    signal Counter1Mhz : std_logic_vector(7 downto 0);
    signal Counter1Khz : std_logic_vector(9 downto 0);

begin
    process(SCALER_CLK) -- 125MHz = 8nsec
    begin
        if(SCALER_CLK'event and SCALER_CLK = '1') then -- rise clock pulse
            if(RESET = '1') then
                Counter1Mhz <= (others => '0');
            else
                if(Counter1Mhz >= 124) then -- 125counts = 1000nsec
                    Counter1Mhz <= (others => '0');
                else
                    Counter1Mhz <= Counter1Mhz + 1;
                end if;
            end if;
        end if;
    end process;

    TIMER_1MHZ <= '0' when(Counter1Mhz <= 62) -- 63counts = 504nsec 
                      else '1';

    process(SCALER_CLK)
    begin
        if(SCALER_CLK'event and SCALER_CLK = '1') then
            if(RESET = '1') then
                Counter1Khz <= (others => '0');
            else
                if(Counter1Mhz >= 124) then -- 125counts = 1000nsec
                    if(Counter1Khz >= 999) then -- 1000counts = 8000nsec
                        Counter1Khz <= (others => '0');
                    else
                        Counter1Khz <= Counter1Khz + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    TIMER_1KHZ <= '0' when(Counter1Khz <= 499) -- 500counts = 
                      else '1';
end RTL;
