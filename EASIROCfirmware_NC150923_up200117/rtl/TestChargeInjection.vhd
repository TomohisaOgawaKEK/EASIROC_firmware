--------------------------------------------------------------------------------
--! @file   TestChargeInjection.vhd
--! @brief  Test charge injection
--! @author Naruhiro Chikuma
--! @date   2015-8-2
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TestChargeInjection is
    generic(
        -- 19/11/11 add address variable and initialize it 
        G_TESTCHARGE_ADDRESS : std_logic_vector(31 downto 0) := X"00000000"
    );        
    port(
	       CLK     : in  std_logic;
	       RST     : in  std_logic; -- PWR_RST is inputted
	       SITCP_CLK  : in  std_logic; -- 19/11/11 another clock from SiTCP
	       SITCP_RST  : in  std_logic; -- 19/11/11 another clock from SiTCP
	       CAL1    : out std_logic;
	       CAL2    : out std_logic;
	       -- 19/11/11 RBCP interface
           RBCP_ACT   : in  std_logic;
           RBCP_ADDR  : in  std_logic_vector(31 downto 0);
           RBCP_WD    : in  std_logic_vector( 7 downto 0);
           RBCP_WE    : in  std_logic;
           RBCP_ACK   : out std_logic;
           SYNC_Trigg : out std_logic -- no usage 19/12/30
           --dummy1     : out std_logic; -- output
           --dummy2     : out std_logic_vector( 7 downto 0) -- output
       );
end TestChargeInjection;


architecture RTL of TestChargeInjection is

    -- 19/11/11 declare address
    -- RegisterAddress.vhd : constant C_TESTCHARGE_ADDRESS : 
    -- std_logic_vector(31 downto 0) := X"00020000";
    constant C_TESTCHARGE_ADDRESS : std_logic_vector(31 downto 0) := G_TESTCHARGE_ADDRESS;
    
	-- 19/11/11 reduce bit width
    -- signal syn_cnt    : std_logic_vector(31 downto 0);
    signal syn_cnt    : std_logic_vector(15 downto 0) := (others => '0') ;
    signal test_palse : std_logic := '0';
    
    -- 19/11/11 add RBCP_Receiver to listen register value??
    -- RBCP(Remote Bus Control Protocol)
    component RBCP_Receiver
    generic (
        G_ADDR : std_logic_vector(31 downto 0);
        G_LEN  : integer;
        G_ADDR_WIDTH : integer
    );
    port(
        CLK       : in std_logic;
        RESET     : in std_logic;
        RBCP_ACT  : in std_logic;
        RBCP_ADDR : in std_logic_vector(31 downto 0);
        RBCP_WE   : in std_logic;
        RBCP_WD   : in std_logic_vector( 7 downto 0);
        RBCP_ACK  : out std_logic;
        ADDR      : out std_logic_vector(G_ADDR_WIDTH -1 downto 0);
        WE        : out std_logic;
        WD        : out std_logic_vector(7 downto 0)
    );
    end component;
    
    -- 19/11/11 for interanl lines 
    signal addr_recv   : std_logic_vector(2 downto 0) := (others => '0') ;
    signal wd_recv     : std_logic_vector(7 downto 0) := (others => '0') ;
    signal we_recv     : std_logic := '0';
    signal PatternReg  : std_logic_vector(2 downto 0) := (others => '0');
    
begin

    -- 19/11/11 put RBCP_Receiver and listen register value?? 
    RBCP_Receiver_0: RBCP_Receiver
    generic map(
        G_ADDR       => C_TESTCHARGE_ADDRESS,
        G_LEN        => 1,        
        G_ADDR_WIDTH => 3 
    )
    port map(
        CLK       => SITCP_CLK, --CLK,
        RESET     => SITCP_RST, --RST,
        RBCP_ACT  => RBCP_ACT,
        RBCP_ADDR => RBCP_ADDR,
        RBCP_WE   => RBCP_WE,
        RBCP_WD   => RBCP_WD,  -- this value is returned to WD if it's fine 
        RBCP_ACK  => RBCP_ACK, -- output 
        ADDR      => addr_recv,-- output 
        WE        => we_recv,  -- output write enable
        WD        => wd_recv   -- output write data
    );
        
    -- iteration to decide pulse width 
    process (CLK) begin
    if (CLK'event and CLK = '1') then
        --if (RST = '0') then -- original : RST is PWR_RST 
        -- memo : RST==0, then, sync==0 => why does the counting allow only for the first a few clocks? it should be RST==1, right? 
--        if (RST = '1') then 
--            syn_cnt <= (others => '0'); -- This line is necessary for initialization, but you can initilaize it in the definition
--        else
            syn_cnt <= syn_cnt + 1;
--        end if;
    end if;
    end process;   
    
    -- hexadecimal X"8000" -> decimal num 32768 : 
    -- if 1MHz = 1 usec, 32 msec is needed to reach X"8000" -> binary:16bit 1000..00
    test_palse <= '1' when (syn_cnt(15 downto 0) = X"8000") else '0'; -- original
    --CAL1 <= 'Z'; 
    --CAL2 <= test_palse; 


    -- below lines are just for testing : X"C8" -> decimal num 200 -> 200 usec under 1MHz clock 
    -- below lines are just for testing : X"64" -> decimal num 100 -> 100 usec under 1MHz clock 
    --test_palse <= '1' when (syn_cnt(15 downto 0) = X"64") else '0'; -- just test
    --test_palse <= '1'; -- just test
  
  
    -- 19/11/11 listen register  ...
    --process(SITCP_CLK) begin
    --if (SITCP_CLK'event and SITCP_CLK = '1') then
    process(CLK) begin
    if (CLK'event and CLK = '1') then
        --PatternReg <= "00000010"; -- this works 
        --PatternReg <= wd_recv( 2 downto 0);
        --if (we_recv = '1' and addr_recv="0") then
        if (we_recv = '1') then
            PatternReg <= wd_recv( 2 downto 0);
            -- PatternReg <= "00000010"; -- this does not work
        end if;
    end if;
    end process;

    --dummy1 <= we_recv;
    --dummy2 <= PatternReg;
    --PatternReg <= "00000010"; -- this can select 00000010 in the case "PatternReg"

    -- 19/11/11 select calibration combination  ...
    -- warning : signal 'test_palse' is read in the process but is not in the sensitivity list 
    --process(PatternReg) begin    
    process(PatternReg, test_palse) begin   
    case PatternReg is
        --when X"02" =>
        when "001" =>
           CAL1 <= 'Z'; -- High Impedance
           --CAL1 <= '0'; -- 0 drive : GND
           CAL2 <= test_palse;
        when "010" =>
           CAL1 <= test_palse;
           CAL2 <= test_palse;
        when others => 
           CAL1 <= test_palse;
           CAL2 <= 'Z'; -- High Impedance
           --CAL2 <= '0'; -- 0 drive : GND
    end case;
    end process;
     
end RTL;
