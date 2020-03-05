----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/11/18 15:12:50
-- Design Name: 
-- Module Name: TimingGeneratorModel_test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:

-- 2019-12-1 by me
-- add new function that can change pulse level with combination of calib1 and calib2
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TimingGeneratorModel_test is
--  Port ( );
end TimingGeneratorModel_test;

architecture Behavioral of TimingGeneratorModel_test is

    component TimingGeneratorModel
    --generic(
    --    -- 19/11/11 add address variable and initialize it 
    --    G_TESTCHARGE_ADDRESS : std_logic_vector(31 downto 0) := X"00000000"
    --);        
    port(
        clk_50M : in  std_logic;
        DIN     : out std_logic; -- output
        SYNCIN  : out std_logic; -- output
        TSTOP   : out std_logic; -- output
        ACCEPT  : out std_logic; -- output
        CLEAR   : out std_logic; -- output
        HOLD    : out std_logic -- output
    );
    end component;

    signal CLK        : std_logic := '0';
    signal DIN        : std_logic := '0';
    signal SYNCIN     : std_logic := '0';
    signal TSTOP      : std_logic := '0'; -- output
    signal ACCEPT     : std_logic := '0'; -- output
    signal CLEAR      : std_logic := '0'; -- output
    signal HOLD       : std_logic := '0'; -- output

	--constant C_ADDR : std_logic_vector(31 downto 0) := X"00020000"; -- 32bit binary: 0..010 00000000 00000000
    
    -- Clock period definitions
    constant CLK_period  : time :=   40 ns;  --25MHz ???
    --constant DELAY       : time := CLK_period * 0.2;
    --constant TimeInterval: time := 32000000 ns; --  (syn_cnt(15 downto 0) X"8000" : 32 ms

begin
    uut :TimingGeneratorModel
    --generic map(
    --    G_TESTCHARGE_ADDRESS => C_ADDR
    --)        
    port map(
        clk_50M => CLK,    
        DIN     => DIN,
        SYNCIN  => SYNCIN,
        TSTOP   => TSTOP,
        ACCEPT  => ACCEPT,
        CLEAR   => CLEAR,
        HOLD    => HOLD
    );


    -- Clock process definitions, clock with 50% duty cycle is generated here.    
    CLK_process: process
    begin
		CLK <= '0';
		wait for CLK_period/2; -- 20 nsec ???
		CLK <= '1';
		wait for CLK_period/2; -- 20 nsec ???
    end process;
 
    -- Stimulus process definitions
    stim_proc: process 
    begin

        wait;
    end process;
end Behavioral;
