----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/11/18 15:12:50
-- Design Name: 
-- Module Name: TestChargeInjection_test - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

    -- 'U' --- Uninitialized
    -- 'X' --- Forcing Unknown
    -- '0' --- Forcing 0
    -- '1' --- Forcing 1
    -- 'Z' --- High Impedance ・・・別名スリーステート(3-state)。ドライブされていない信号状態の事
    -- '-' --- Don't care
    
entity TestChargeInjection_test is
--  Port ( );
end TestChargeInjection_test;


architecture Behavioral of TestChargeInjection_test is

    component TestChargeInjection
    generic(
        -- 19/11/11 add address variable and initialize it 
        G_TESTCHARGE_ADDRESS : std_logic_vector(31 downto 0) := X"00000000"
    );        
    port(
        CLK        : in  std_logic;
        SITCP_CLK  : in  std_logic; -- another clock from SiTCP
        RST        : in  std_logic;
        CAL1       : out std_logic; -- output
        CAL2       : out std_logic; -- output
        -- 19/11/11 RBCP interface
        RBCP_ACT   : in  std_logic;
        RBCP_ADDR  : in  std_logic_vector(31 downto 0);
        RBCP_WD    : in  std_logic_vector( 7 downto 0);
        RBCP_WE    : in  std_logic;
        RBCP_ACK   : out std_logic -- output
        --dummy1     : out std_logic; -- output
        --dummy2     : out std_logic_vector( 7 downto 0)       
    );
    end component;

    signal CLK        : std_logic := '0';
    signal SITCP_CLK  : std_logic := '0';
    signal RST        : std_logic := '0';
    signal CAL1       : std_logic := '0'; -- output
    signal CAL2       : std_logic := '0'; -- output

    signal RBCP_ACT   : std_logic := '0';
    signal RBCP_ADDR  : std_logic_vector(31 downto 0) := (others => '0');
    signal RBCP_WD    : std_logic_vector( 7 downto 0) := (others => '0');
    signal RBCP_WE    : std_logic := '0';
    signal RBCP_ACK   : std_logic := '0';
    --signal dummy1     : std_logic;
    --signal dummy2     : std_logic_vector( 7 downto 0) := (others => '0');

	constant C_ADDR : std_logic_vector(31 downto 0) := X"00020000"; -- 32bit binary: 0..010 00000000 00000000
    
    --SITCP_CLK            : out  std_logic;--  25MHz : 40 nsec
    --TDC_CLK              : out std_logic; -- 125MHz :  8 nsec   
    -- Clock period definitions
    --constant CLK_period  : time :=   40 ns;  --25MHz 
    constant CLK_period  : time :=    8 ns;  --125MHz 
    --constant CLK_period  : time := 1000 ns;  -- 1MHz = 1 usec
    constant DELAY       : time := CLK_period * 0.2;
    constant TimeInterval: time := 32000000 ns; --  (syn_cnt(15 downto 0) X"8000" : 32 ms

begin
    uut :TestChargeInjection
    generic map(
        G_TESTCHARGE_ADDRESS => C_ADDR
    )        
    port map(
        -- to controll pulse timing : X"8000" -> decimal num 32768 -> 1.3 msec
        -- to controll pulse timing : X"1000" -> decimal num  4096 -> 163 usec
        CLK        => CLK,    
        SITCP_CLK  => SITCP_CLK,
        CAL1       => CAL1,
        CAL2       => CAL2,
        RST        => RST,        
        RBCP_ACT   => RBCP_ACT,   
        RBCP_ADDR  => RBCP_ADDR,  
        RBCP_WD    => RBCP_WD,    
        RBCP_WE    => RBCP_WE,    
        RBCP_ACK   => RBCP_ACK
        --dummy1     => dummy1,
        --dummy2     => dummy2
    );


    -- Clock process definitions( clock with 50% duty cycle is generated here.    
    CLK_process: process
    begin
		CLK <= '0';
		SITCP_CLK <= '0';
		wait for CLK_period/2; -- 20 nsec ???
		CLK <= '1';
		SITCP_CLK <= '1';
		wait for CLK_period/2; -- 20 nsec ???
    end process;
 
    -- Stimulus process definitions
    -- とりあえずプロセスの定義する
    stim_proc: process 
  
    -- reset する必要性は不明
    procedure reset_uut is
    begin
        RST <= '1';
        wait until CLK'event and CLK = '1'; --  20 nsec ???
        wait for CLK_period;               --  40 nsec ???
        RST <= '0' after DELAY;            --   8 nsec ???
    end procedure;

    -- 多分 remote bus control protocol を通してアドレスのやり取り
    -- とりあえず、HVControl_test からコピー、内部でWE,WD の情報を
    -- 捕まえて、それをTestChargeInjection内部で利用しているはず
	procedure write_data 	( 
	   addr : std_logic_vector(31 downto 0);
	   data : std_logic_vector( 7 downto 0)
	) is
	begin
		wait for CLK_period;
		RBCP_ACT <= '1' after DELAY;   -- give 1 to RBCP_action? 

    	wait for CLK_period * 2;
		RBCP_ADDR <= addr after DELAY; -- give address ( internally, <= conv_std_logic_vector(conv_integer(RBCP_ADDR - G_ADDR), G_ADDR_WIDTH) )
		RBCP_WE   <= '1'  after DELAY; -- give write enable to RBCP_WE, 他の条件も揃えば、WE <= 1 をもらえる 
		RBCP_WD   <= data after DELAY; -- give hexadecimal X"00"... info to RBCP_WD. This is returned to WD if it's fine

       -- need below ??
		wait for CLK_period;
		RBCP_ADDR <= (others => '0') after DELAY;
		RBCP_WE   <= '0'             after DElAY;
		RBCP_WD   <= (others => '0') after DELAY;

		wait until RBCP_ACK'event and RBCP_ACK = '1';
		wait for CLK_period;
		RBCP_ACT <= '0' after DELAY;
    end procedure;

    begin
        -- clock で区切られていないと物事は同時に起こる
        reset_uut;
        -- the first address is thrown to RBCP_Receiver
        -- give hexadecimal X"00", X"01", X"02" -> 0,1,2 -> 8bit binary 000, 001, 010
        write_data(X"00020000", X"02");  
        --write_data(X"00020000", "00000001");  
 
-- 		wait for TimeInterval;
--        reset_uut;
--        write_data(X"00020000", X"02");  
 
-- 		wait for TimeInterval;
--       reset_uut;
--        write_data(X"00020000", X"04");  

        wait;
    end process;
end Behavioral;
