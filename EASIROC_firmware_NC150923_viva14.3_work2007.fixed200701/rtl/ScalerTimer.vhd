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
        SCALER_CLK : in std_logic; -- 125MHz : 8nsec (4+4)
        RESET      : in std_logic;
        TIMER_1MHZ : out std_logic;
        TIMER_1KHZ : out std_logic
    );
end ScalerTimer;

architecture RTL of ScalerTimer is
    signal Counter1Mhz : std_logic_vector(7 downto 0); --  8 bit  256 counts
    signal Counter1Khz : std_logic_vector(9 downto 0); -- 10 bit 1024 counts

begin
    process(SCALER_CLK)
    begin
        if(SCALER_CLK'event and SCALER_CLK = '1') then -- look rising edge
            if (RESET = '1') then
                Counter1Mhz <= (others => '0');
            else
                if (Counter1Mhz >= 124) then -- >= 124 * 8 nsec = 992nsec ~ 1usec
                    Counter1Mhz <= (others => '0');
                else
                    Counter1Mhz <= Counter1Mhz + 1; 
                end if;
            end if;
        end if;
    end process;

    TIMER_1MHZ <= '0' when(Counter1Mhz <= 62) else '1';

    process(SCALER_CLK)
    begin
        if(SCALER_CLK'event and SCALER_CLK = '1') then
            if(RESET = '1') then
                Counter1Khz <= (others => '0');
            else
                if (Counter1Mhz >= 124) then -- >= 992nsec ~ 1usec
                    if (Counter1Khz >= 999) then -- >= 999 * 1usec ~ 1msec 
                        Counter1Khz <= (others => '0');
                    else
                        Counter1Khz <= Counter1Khz + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    TIMER_1KHZ <= '0' when(Counter1Khz <= 499) else '1';

end RTL;
