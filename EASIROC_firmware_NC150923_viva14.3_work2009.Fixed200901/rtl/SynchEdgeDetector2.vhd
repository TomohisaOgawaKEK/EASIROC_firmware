--------------------------------------------------------------------------------
--! @file   SynchEdgeDetector2.vhd
--! @brief  Synchronize async signal and detect positive edge
--! @author Takehiro Shiozaki
--! @date   2013-11-11
--! @modified 2020-03-07 H.Sato
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SynchEdgeDetector2 is
    port(
        CLK : in  std_logic;
        RESET : in  std_logic;
        DIN : in  std_logic;
        DOUT : out  std_logic
    );
end SynchEdgeDetector2;

architecture RTL of SynchEdgeDetector2 is

signal DelayedDin : std_logic;
signal DelayedDin2 : std_logic;
signal DelayedDin3 : std_logic;

begin

    process(CLK, RESET)
    begin
        if(RESET = '1') then
            DelayedDin <= '0';
            DelayedDin2 <= '0';
            DelayedDin3 <= '0';
        elsif(CLK'event and CLK = '1') then
            DelayedDin  <= DIN;
            DelayedDin2 <= DelayedDin;
            DelayedDin3 <= DelayedDin2;
        end if;
    end process;

    DOUT <= (not DelayedDin3) and DelayedDin;

end RTL;

