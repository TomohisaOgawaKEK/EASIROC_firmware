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
        RBCP_ACK   : out std_logic
    );
end TestChargeInjection;

architecture RTL of TestChargeInjection is
    -- 19/11/11 declare address
    -- RegisterAddress.vhd : constant C_TESTCHARGE_ADDRESS : std_logic_vector(31 downto 0) := X"00020000";
    constant C_TESTCHARGE_ADDRESS : std_logic_vector(31 downto 0) := G_TESTCHARGE_ADDRESS;

	signal test_palse : std_logic;
	-- 19/11/11 reduce bit width
	-- signal syn_cnt    : std_logic_vector(31 downto 0);
	signal syn_cnt    : std_logic_vector(15 downto 0);
	
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
    signal addr_madc  : std_logic_vector(2 downto 0);   
    signal we_madc    : std_logic;   
    signal wd_madc    : std_logic_vector(7 downto 0);   	
    -- 19/11/11 charge controll register 
    --signal charge_contr_reg  : std_logic_vector(2 downto 0);
    signal charge_contr_reg  : std_logic_vector(7 downto 0);

begin
    -- 19/11/11 put RBCP_Receiver and listen register value?? 
    RBCP_Receiver_0: RBCP_Receiver
    generic map(
        G_ADDR       => C_TESTCHARGE_ADDRESS,
        G_LEN        => 1,
        -- [Synth 8-549] port width mismatch for port 'ADDR': port width = 1, actual width = 3 
        -- modify 1 -> 3
        G_ADDR_WIDTH => 3 
    )
    port map(
        CLK       => CLK,
        RESET     => RST,
        RBCP_ACT  => RBCP_ACT,
        RBCP_ADDR => RBCP_ADDR,
        RBCP_WE   => RBCP_WE,
        RBCP_WD   => RBCP_WD,  -- this is returned to WD if it's fine 
        RBCP_ACK  => RBCP_ACK, -- output 
        ADDR      => addr_madc,-- output ( internally, <= conv_std_logic_vector(conv_integer(RBCP_ADDR - G_ADDR), G_ADDR_WIDTH) )
        WE        => we_madc,  -- output write enable
        WD        => wd_madc   -- output write data
    );
 
    -- iteration to decide pulse width 
    -- CLK 
    process (CLK,RST) begin
    if (CLK'event and CLK = '1') then
        --if (RST = '0') then -- original : RST==0, then, sync==0 : RST==1 の最初の数クロック分の時にしかカウントしないの？
        if (RST = '1') then 
            syn_cnt <= (others => '0');
        else
            syn_cnt <= syn_cnt + 1;
        end if;
    end if;
    end process;   
    
    -- hexadecimal X"8000" -> decimal num 32768
    --test_palse <= '1' when (syn_cnt(15 downto 0) = X"8000") else '0';
    -- CAL1 <= 'Z';
    -- CAL2 <= test_palse;


    -- below lines are just for testing : X"C8" -> decimal num 200 -> 200 usec under 1MHz clock 
    -- below lines are just for testing : X"64" -> decimal num 100 -> 100 usec under 1MHz clock 
    test_palse <= '1' when (syn_cnt(15 downto 0) = X"64") else '0';
    --test_palse <= '1'; 
  
    
    -- 19/11/11 listen register  ...
    process(SITCP_CLK) begin
    if (SITCP_CLK'event and SITCP_CLK = '1') then
        if (we_madc = '1') then
            -- [Synth 8-690] width mismatch in assignment; target has 3 bits, source has 8 bits 
            -- modify 3 -> 8
            charge_contr_reg <= wd_madc; -- write data 8bit, depending on charge_contr_reg, pulse is selected
        end if;
    end if;
    end process;
    
    -- 19/11/11 select calibration combination  ...
    -- warning : signal 'test_palse' is read in the process but is not in the sensitivity list 
    -- process(charge_contr_reg) begin    
    process(charge_contr_reg, test_palse) begin    
    case charge_contr_reg is
        -- ERROR: [VRFC 10-494] choice "000" should have 8 elements
        -- 000 -> 00000000
        when "00000000" => 
            CAL1 <= test_palse;
            CAL2 <= test_palse;
        when "00000001" => 
            CAL1 <= test_palse;
            CAL2 <= '0';
        when "00000010" =>
            CAL1 <= '0';
            CAL2 <= test_palse;
        when "00000011" =>
            CAL1 <= test_palse;
            CAL2 <= 'Z';
        when "00000100" =>
            CAL1 <= 'Z';
            CAL2 <= test_palse;
        when others      =>
            CAL1 <= 'Z';
            CAL2 <= 'Z';
    end case;
    end process; 
     
end RTL;
