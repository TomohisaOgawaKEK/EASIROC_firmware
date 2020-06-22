--------------------------------------------------------------------------------
--! @file   Triggermanager_test.vhd
--! @brief  test bench of TriggerManager.vhd
--! @author Takehiro Shiozaki
--! @date   2014-05-07
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity TriggerManager_test is
end TriggerManager_test;

architecture behavior of TriggerManager_test is

    component TriggerManager is
    generic(
        --G_TESTCHARGE_ADDRESS : std_logic_vector(31 downto 0) := X"00000000"
        G_TRIGGER_MANAGER_ADDRESS : std_logic_vector(31 downto 0) := X"00000000" -- this is new on NC
    );        
	port(
        SITCP_CLK  : in std_logic;
        ADC_CLK    : in std_logic; -- new
        AD9220_CLK : in std_logic;
        TDC_CLK    : in std_logic;
        SCALER_CLK : in std_logic; -- new
        FAST_CLK   : in std_logic;
        RESET      : in  std_logic;

        -- Trigger
        HOLD       : in std_logic;
        L1_TRIGGER : in std_logic;
        L2_TRIGGER : in std_logic;
        FAST_CLEAR : in std_logic;
        BUSY : out std_logic;
        --    SPILL_NUMBER : in std_logic;
        --    EVENT_NUMBER : in std_logic_vector(2 downto 0);
        SelectableTrigger : in std_logic; -- this is new on NC, which is from "SelectableLogic" and is input into OUT_FPGA(2)

	    OutPulse1 : out std_logic;
	    OutPulse2 : out std_logic;
	    OutPulse3 : out std_logic;

        -- Sender interface
        TRANSMIT_START : out std_logic;
        GATHERER_BUSY : in std_logic;
        --    SPILL_NUMBER_OUT : out std_logic;
        --    EVENT_NUMBER_OUT : out std_logic_vector(2 downto 0);

        -- Control
        IS_DAQ_MODE : in std_logic;
        TCP_OPEN_ACK : in std_logic;

        -- ADC interface
        ADC_TRIGGER : out std_logic;
        ADC_FAST_CLEAR : out std_logic;
        ADC_BUSY : in std_logic;

        -- TDC intreface
        COMMON_STOP : out std_logic;
        TDC_FAST_CLEAR : out std_logic;
        TDC_BUSY : in std_logic;

		-- Scaler interface "NEW"
        SCALER_TRIGGER : out std_logic;
        SCALER_FAST_CLEAR : out std_logic;
        SCALER_BUSY : in std_logic;

		-- Hold
        HOLD_OUT1_N : out std_logic;
        HOLD_OUT2_N : out std_logic;

		    -- RBCP
        RBCP_ACT    : in std_logic;
        RBCP_ADDR   : in std_logic_vector(31 downto 0);
        RBCP_WE     : in std_logic;
        RBCP_WD     : in std_logic_vector(7 downto 0);
        RBCP_ACK    : out std_logic
    );
    end component;

    signal SITCP_CLK : std_logic := '0';
    signal ADC_CLK   : std_logic := '0';
    signal AD9220_CLK: std_logic := '0';
    signal TDC_CLK   : std_logic := '0';
    signal SCALER_CLK: std_logic := '0';
    signal FAST_CLK  : std_logic := '0';
    signal RESET     : std_logic := '0';

    signal HOLD       : std_logic := '0';
    signal L1_TRIGGER : std_logic := '0';
    signal L2_TRIGGER : std_logic := '0';
    signal FAST_CLEAR : std_logic := '0';
    signal BUSY       : std_logic;
    signal SelectableTrigger: std_logic := '0';
    --signal SPILL_NUMBER : std_logic := '0';
    --signal EVENT_NUMBER : std_logic_vector(2 downto 0) := (others => '0');

	signal OutPulse1 : std_logic := '0';
	signal OutPulse2 : std_logic := '0';
	signal OutPulse3 : std_logic := '0';

    signal TRANSMIT_START : std_logic;
    signal GATHERER_BUSY  : std_logic;
	--signal SPILL_NUMBER_OUT : std_logic;
    --signal EVENT_NUMBER_OUT : std_logic_vector(2 downto 0);

    signal IS_DAQ_MODE : std_logic := '0';
    signal TCP_OPEN_ACK : std_logic := '0';

    signal ADC_TRIGGER : std_logic;
    signal ADC_FAST_CLEAR : std_logic;
	signal ADC_BUSY : std_logic := '0';

    signal COMMON_STOP : std_logic;
	signal TDC_FAST_CLEAR : std_logic;
    signal TDC_BUSY : std_logic := '0';

	signal SCALER_TRIGGER : std_logic;
    signal SCALER_FAST_CLEAR : std_logic;
    signal SCALER_BUSY : std_logic := '0';

    signal HOLD_OUT1_N : std_logic := '0';
    signal HOLD_OUT2_N : std_logic := '0';

	signal RBCP_ACT   : std_logic := '0';
    signal RBCP_ADDR  : std_logic_vector(31 downto 0) := (others => '0');
    signal RBCP_WD    : std_logic_vector( 7 downto 0) := (others => '0');
    signal RBCP_WE    : std_logic := '0';
    signal RBCP_ACK   : std_logic := '0';

    constant C_ADDR : std_logic_vector(31 downto 0) := X"00010100"; 

    constant SITCP_CLK_period : time := 40 ns;
    constant AD9220_CLK_period: time := 166.66 ns;
    constant TDC_CLK_period   : time := 8 ns;
    constant FAST_CLK_period  : time := 2 ns;
begin

    uut: TriggerManager
	generic map(
        G_TRIGGER_MANAGER_ADDRESS => C_ADDR
    )        
    port map(
        SITCP_CLK  => SITCP_CLK,
        ADC_CLK    => ADC_CLK, 
        AD9220_CLK => AD9220_CLK,
        TDC_CLK    => TDC_CLK,
        SCALER_CLK => SCALER_CLK,
        FAST_CLK   => FAST_CLK,
        RESET      => RESET,
        HOLD       => HOLD,
        L1_TRIGGER => L1_TRIGGER,
        L2_TRIGGER => L2_TRIGGER,
        FAST_CLEAR => FAST_CLEAR,
	    BUSY       => BUSY,
	    SelectableTrigger => SelectableTrigger,
        OutPulse1 => OutPulse1,
        OutPulse2 => OutPulse2,
        OutPulse3 => OutPulse3,
        --SPILL_NUMBER => SPILL_NUMBER,
        --EVENT_NUMBER => EVENT_NUMBER,
        TRANSMIT_START => TRANSMIT_START,
        GATHERER_BUSY  => GATHERER_BUSY,
		--SPILL_NUMBER_OUT => SPILL_NUMBER_OUT,
        --EVENT_NUMBER_OUT => EVENT_NUMBER_OUT,
        IS_DAQ_MODE  => IS_DAQ_MODE,
        TCP_OPEN_ACK => TCP_OPEN_ACK,
        --
        ADC_TRIGGER    => ADC_TRIGGER,
        ADC_FAST_CLEAR => ADC_FAST_CLEAR,
        ADC_BUSY       => ADC_BUSY,
        COMMON_STOP    => COMMON_STOP,
        TDC_FAST_CLEAR => TDC_FAST_CLEAR,
		TDC_BUSY       => TDC_BUSY,
		SCALER_TRIGGER => SCALER_TRIGGER,
		SCALER_FAST_CLEAR => SCALER_FAST_CLEAR,
		SCALER_BUSY    => SCALER_BUSY,
        --
        HOLD_OUT1_N => HOLD_OUT1_N,
        HOLD_OUT2_N => HOLD_OUT2_N,
		RBCP_ACT   => RBCP_ACT,
        RBCP_ADDR  => RBCP_ADDR,
        RBCP_WD    => RBCP_WD,
        RBCP_WE    => RBCP_WE,
        RBCP_ACK   => RBCP_ACK
    );

    SITCP_CLK_process: process
    begin
        SITCP_CLK <= '1';
        wait for SITCP_CLK_period / 2;
        SITCP_CLK <= '0';
        wait for SITCP_CLK_period / 2;
    end process;

    AD9920_CLK_process: process
    begin
        AD9220_CLK <= '1';
        wait for AD9220_CLK_period / 2;
        AD9220_CLK <= '0';
        wait for AD9220_CLK_period / 2;
    end process;

    TDC_CLK_process: process
    begin
        TDC_CLK <= '1';
        wait for TDC_CLK_period / 2;
        TDC_CLK <= '0';
        wait for TDC_CLK_period / 2;
    end process;

    Fast500M_CLK_process: process
    begin
        FAST_CLK <= '1';
        wait for FAST_CLK_period / 2;
        FAST_CLK <= '0';
        wait for FAST_CLK_period / 2;
    end process;

    -- clock conditions are defined up to here


    ADC_Busy_process: process
    begin
        wait until ADC_TRIGGER = '1';
        wait until AD9220_CLK'event and AD9220_CLK = '1';
        ADC_BUSY <= '1';
        wait for 20 us;
        ADC_BUSY <= '0';
    end process;

    TDC_Busy_process: process
    begin
        wait until COMMON_STOP = '1';
        wait until TDC_CLK'event and TDC_CLK = '1';
        TDC_BUSY <= '1';
        wait for TDC_CLK_period * 64 * 8;
        TDC_BUSY <= '0';
    end process;

    Scaler_Busy_process: process
    begin
        wait until SCALER_TRIGGER = '1';
        wait until FAST_CLK 'event and FAST_CLK = '1';
		SCALER_BUSY <= '1';
        wait for FAST_CLK_period * 64 * 8;
        SCALER_BUSY <= '0';
    end process;

    -- busy conditions are defined up to here


    exsample_stimulated_process: process
    procedure putpulses ( 
	       addr : std_logic_vector(31 downto 0);
	       data : std_logic_vector( 7 downto 0);
           trigger:std_logic;
		   pulse1 :std_logic;
           pulse2 :std_logic;
           pulse3 :std_logic
    ) is
    begin

		RBCP_ACT  <= '1'  ; -- give 1 to RBCP_action?
		RBCP_ADDR <= addr ; -- give address 
		RBCP_WE   <= '1'  ; -- give write enable to RBCP_WE
		RBCP_WD   <= data ;

		RESET <= '1';
        wait for AD9220_CLK_period;
        RESET <= '0';
        wait for 10 ns;

		SelectableTrigger<= trigger;
        HOLD       <= pulse1;
        L1_TRIGGER <= pulse2;
        L2_TRIGGER <= pulse3;
        wait for 80 ns;

		HOLD       <= '0';
        L1_TRIGGER <= '0';
        L2_TRIGGER <= '0';
    end procedure;

    begin -- process begin
        --putpulses('1','1','1'); 
        putpulses(X"00010100", X"01", '1', '1','0','0'); 

		-- wait 2400 usec for digitize
		wait for 2500 ns;
		putpulses(X"00010100", X"00", '1', '1','0','0');

		wait for 2500 ns;
		putpulses(X"00010100", X"01", '1', '1','0','0');
		wait;

		-- original below before Chikuma-NEW era
		RESET <= '1';
        wait for AD9220_CLK_period;
        RESET <= '0';
        wait for 10 ns;

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';
        wait for 10 ns;

        L1_TRIGGER <= '1';
        wait for 10 ns;
        L1_TRIGGER <= '0';
        wait for 10 ns;

        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';
        wait for 10 ns;

		--
        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';
        wait for 10 ns;

        wait for 100 ns;

        L1_TRIGGER <= '1';
        wait for 10 ns;
        L1_TRIGGER <= '0';
        wait for 10 ns;

        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';
        wait for 10 ns;

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';
        wait for 10 ns;

        wait until HOLD_OUT1_N = '1';

        wait for 1 us;

        TCP_OPEN_ACK <= '1';
        wait for 100 ns;
        IS_DAQ_MODE <= '1';

        L1_TRIGGER <= '1';
        wait for 10 ns;
        L1_TRIGGER <= '0';

        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';

        wait for 100 ns;

        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';

        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';

        wait for 1 us;
        L1_TRIGGER <= '1';
        --SPILL_NUMBER <= '1';
        --EVENT_NUMBER <= "101";
        wait for 10 ns;
        L1_TRIGGER <= '0';

        wait for 10 ns;
        HOLD <= '1';
        wait for 10 ns;
        HOLD <= '0';

        L1_TRIGGER <= '1';
        wait for 10 ns;
        L1_TRIGGER <= '0';

        wait for 10 us;
        L2_TRIGGER <= '1';
        wait for 10 ns;
        L2_TRIGGER <= '0';

        wait for 25 us;
        IS_DAQ_MODE <= '0';
        TCP_OPEN_ACK <= '0';
        wait;
    end process;

end;
