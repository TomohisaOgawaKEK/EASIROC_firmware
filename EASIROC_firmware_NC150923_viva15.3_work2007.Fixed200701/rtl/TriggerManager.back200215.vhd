--------------------------------------------------------------------------------
--! @file   TriggerManager.vhd
--! @brief  Manage and distribute trigger
--! @author Naruhiro Chikuma
--! @date   2015-09-06
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- this is for new NC

entity TriggerManager is
    generic(
        G_TRIGGER_MANAGER_ADDRESS : std_logic_vector(31 downto 0) := X"00000000" -- this is new on NC
    );
    port(
        SITCP_CLK  : in std_logic;
        ADC_CLK    : in std_logic;
        AD9220_CLK : in std_logic;
        TDC_CLK    : in std_logic;
        SCALER_CLK : in std_logic;
        FAST_CLK   : in std_logic;
        RESET      : in std_logic;
        -- Trigger
        HOLD : in std_logic;
        L1_TRIGGER : in std_logic; -- IN_FPGA(4): tstop
        L2_TRIGGER : in std_logic; -- IN_FPGA(3): accept
        FAST_CLEAR : in std_logic;
        BUSY : out std_logic;
		SelectableTrigger : in std_logic; -- this is new on NC, this is input into OUT_FPGA(2)

        -- Sender interface
        TRANSMIT_START : out std_logic;
        GATHERER_BUSY : in std_logic;
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
        -- Scaler interface
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
end TriggerManager;

architecture RTL of TriggerManager is

    component RBCP_Receiver --  this is new for NC
    generic (
        G_ADDR : std_logic_vector(31 downto 0);
        G_LEN : integer;
        G_ADDR_WIDTH : integer
    );
    port(
        CLK : in std_logic;
        RESET : in std_logic;
        RBCP_ACT : in std_logic;
        RBCP_ADDR : in std_logic_vector(31 downto 0);
        RBCP_WE : in std_logic;
        RBCP_WD : in std_logic_vector(7 downto 0);
        RBCP_ACK : out std_logic;
        ADDR : out std_logic_vector(G_ADDR_WIDTH -1 downto 0);
        WE : out std_logic;
        WD : out std_logic_vector(7 downto 0)
    );
    end component;

    component TriggerDelayer --  this is new for NC
    port(
        CLK         : in  std_logic;
        CLK_25M     : in  std_logic;
        RESET       : in  std_logic;
        TRIGGER_IN  : in  std_logic;
        TRIGGER_OUT : out std_logic;
        DELAY       : in  std_logic_vector(7 downto 0)
    );
    end component;

    component Synchronizer is
    port(
        CLK : in  std_logic;
        RESET : in  std_logic;
        DIN : in std_logic;
        DOUT : out std_logic
    );
    end component;

    component SynchEdgeDetector
    port(
        CLK : in std_logic;
        RESET : in std_logic;
        DIN : in std_logic;
        DOUT : out std_logic
    );
    end component;

    component InterclockTrigger is
    port(
		CLK_IN : in std_logic; --  this is new for NC
        CLK_OUT : in std_logic; --  this is new for NC
        RESET : in std_logic;
        TRIGGER_IN : in std_logic;
        TRIGGER_OUT : out std_logic
    );
    end component;

    component HoldExpander is
    port(
        FAST_CLK : in std_logic;
        RESET : in  std_logic;

        HOLD_IN : in std_logic;
        HOLD_OUT1_N : out std_logic;
        HOLD_OUT2_N : out std_logic;

        EXTERNAL_RESET_HOLD : in std_logic;
        IS_EXTERNAL_RESET_HOLD : in std_logic
    );
    end component;

    component BusyManager is
    port(
        FAST_CLK : in std_logic;
        RESET : in  std_logic;

        HOLD : in std_logic;
        RESET_BUSY : in std_logic;
        BUSY : out std_logic
    );
    end component;

    signal int_Busy : std_logic;

    signal DelayedAdcBusy : std_logic;
    signal DelayedTdcBusy : std_logic;
    signal DelayedScalerBusy : std_logic;
    signal DelayedIsDaqMode : std_logic;
    signal DelayedIsDaqMode_N : std_logic;
    signal IsDaqModeNEdge : std_logic;

    signal AdcTdcScalerBusy : std_logic;
    signal SynchAdcTdcScalerBusy : std_logic;
    signal SynchGathererBusy : std_logic;

    signal MaskedHold : std_logic;
    signal MaskedL1 : std_logic;
    signal MaskedL2 : std_logic;
    signal MaskedFastClear : std_logic;

    signal HoldEdge : std_logic;
    signal L1Edge : std_logic;
    signal L2Edge : std_logic;
    signal FastClearEdge : std_logic;

    signal CommonStopMask : std_logic;

    signal ResetHoldBusy : std_logic;

    signal SendAdcTrigger : std_logic;
    signal SendTransmitStart : std_logic;
    signal ResetBusy : std_logic;

    signal SendFastClear : std_logic;

    signal Hold_tmp : std_logic; -- new
    signal L1_tmp   : std_logic; -- new
    signal L2_tmp   : std_logic; -- new
    signal trig_delayed : std_logic; -- new
    signal hold_delayed : std_logic; -- new
    signal l1_delayed   : std_logic; -- new

    signal addr_recv   : std_logic_vector(1 downto 0); -- RBCP
    signal wd_recv     : std_logic_vector(7 downto 0); -- RBCP
    signal we_recv     : std_logic; -- RBCP
    signal TriggerMode : std_logic_vector(7 downto 0); -- new
    signal trig_delay  : std_logic_vector(7 downto 0); -- new
    signal hold_delay  : std_logic_vector(7 downto 0); -- new
    signal l1_delay    : std_logic_vector(7 downto 0); -- new
	
    type State is (IDLE, SEND_ADC_TRIGGER, HOLD_RECEIVED, L1_RECEIVED,
                   WAIT_GATHERER_BUSY, CLEAR_STATE, SEND_TRANSMIT_START,
                   WAIT_ADC_TDC_BUSY, RESET_BUSY);
    signal CurrentState, NextState : State;

begin

    RBCP_Receiver_0: RBCP_Receiver -- new
    generic map(
        G_ADDR       => G_TRIGGER_MANAGER_ADDRESS,
        G_LEN        => 4, -- data lenghth, which means array
        G_ADDR_WIDTH => 2  -- 00, 01, 10, 11
    )
    port map(
        CLK       => SITCP_CLK,
        RESET     => RESET,
        RBCP_ACT  => RBCP_ACT,
        RBCP_ADDR => RBCP_ADDR,
        RBCP_WE   => RBCP_WE,
        RBCP_WD   => RBCP_WD,
        RBCP_ACK  => RBCP_ACK,
        ADDR      => addr_recv,
        WE        => we_recv,
        WD        => wd_recv
    );

    Trig_Delayer: TriggerDelayer -- new
    port map(
    CLK         =>  FAST_CLK,
    CLK_25M     =>  SITCP_CLK,
    RESET       =>  RESET,
    TRIGGER_IN  =>  SelectableTrigger, -- in
    TRIGGER_OUT =>  trig_delayed, -- out
    DELAY       =>  trig_delay -- delay: array
    );

    Hold_Delayer: TriggerDelayer -- new
    port map(
    CLK         =>  SITCP_CLK,
    CLK_25M     =>  SITCP_CLK,
    RESET       =>  RESET,
    TRIGGER_IN  =>  Hold_tmp, -- in
    TRIGGER_OUT =>  hold_delayed, -- out
    DELAY       =>  hold_delay -- delay: array
    );

    L1_Delayer: TriggerDelayer -- new
    port map(
    CLK         =>  ADC_CLK,
    CLK_25M     =>  SITCP_CLK,
    RESET       =>  RESET,
    TRIGGER_IN  =>  L1_tmp, -- in
    TRIGGER_OUT =>  l1_delayed, -- out
    DELAY       =>  l1_delay -- delay: array
    );
	
    -- settings from outside
    -- select trigger mode 0-7
    -- select trig_delay
    -- select hold_delay
    -- select l1_delay 
    process(SITCP_CLK) 
    begin
        if(SITCP_CLK'event and SITCP_CLK = '1') then
            if(RESET = '1') then
                TriggerMode <= (others => '0'); 
                -- or initialization in the definition is better 
            else
                if(we_recv = '1') then -- write enable 
                    if  (addr_recv = "00") then
                        TriggerMode <= wd_recv; 
                    elsif(addr_recv = "01") then
                        trig_delay  <= wd_recv;
                    elsif(addr_recv = "10") then
                        hold_delay  <= wd_recv;
                    elsif(addr_recv = "11") then
                        l1_delay    <= wd_recv;
                    end if;
                end if;
            end if;
        end if;
    end process;


	-- select which pulse one wanna use for Hold_tmp(this gives hold pulse) 
	process(HOLD, L1_TRIGGER, L2_TRIGGER,
	       trig_delayed, hold_delayed,l1_delayed,
	       TriggerMode) -- 2019/12/08, TriggerMode is added in sensitivity list
    begin
        if   (TriggerMode = 0) then
            Hold_tmp <= trig_delayed;
            L1_tmp   <= hold_delayed;
            L2_tmp   <= l1_delayed;
        elsif(TriggerMode = 1) then
            Hold_tmp <= trig_delayed;
            L1_tmp   <= L1_TRIGGER;
            L2_tmp   <= l1_delayed;
        elsif(triggermode = 2) then
            Hold_tmp <= HOLD;
            L1_tmp   <= hold_delayed;
            L2_tmp   <= l1_delayed;
        elsif(TriggerMode = 3) then
            Hold_tmp <= HOLD;
            L1_tmp   <= L1_TRIGGER;
            L2_tmp   <= l1_delayed;
        elsif(TriggerMode = 4) then
            Hold_tmp <= trig_delayed;
            L1_tmp   <= hold_delayed;
            L2_tmp   <= L2_TRIGGER;
         elsif(TriggerMode = 5) then
            Hold_tmp <= HOLD;
            L1_tmp   <= hold_delayed;
            L2_tmp   <= L2_TRIGGER;
         elsif(TriggerMode = 6) then
            Hold_tmp <= trig_delayed;
            L1_tmp   <= L1_TRIGGER;
            L2_tmp   <= L2_TRIGGER;
         elsif(TriggerMode = 7) then
            Hold_tmp <= HOLD;
            L1_tmp   <= L1_TRIGGER;
            L2_tmp   <= L2_TRIGGER;
        end if;
    end process;

    --MaskedHold      <= HOLD and S_DAQ_MODE and TCP_OPEN_ACK and (not int_BUSY);
    --MaskedL1        <= L1_TRIGGER and IS_DAQ_MODE and TCP_OPEN_ACK;
    --MaskedL2        <= L2_TRIGGER and IS_DAQ_MODE and TCP_OPEN_ACK;
    --MaskedFastClear <= FAST_CLEAR and IS_DAQ_MODE and TCP_OPEN_ACK;

    -- if Hold_tmp is ON/high, MaskedHold will be issued
    MaskedHold      <= Hold_tmp   and IS_DAQ_MODE and TCP_OPEN_ACK and (not int_BUSY);
    MaskedL1        <= L1_tmp     and IS_DAQ_MODE and TCP_OPEN_ACK;
    MaskedL2        <= L2_tmp     and IS_DAQ_MODE and TCP_OPEN_ACK;
    MaskedFastClear <= FAST_CLEAR and IS_DAQ_MODE and TCP_OPEN_ACK;

	SynchEdgeDetector_HOLD: SynchEdgeDetector
    port map(
        CLK => FAST_CLK,
        RESET => RESET,
        DIN => MaskedHold,
        DOUT => HoldEdge
    );

    SynchEdgeDetector_L1: SynchEdgeDetector
    port map(
        CLK => FAST_CLK,
        RESET => RESET,
        DIN => MaskedL1,
        DOUT => L1Edge
    );

    SynchEdgeDetector_L2: SynchEdgeDetector
    port map(
        CLK => FAST_CLK,
        RESET => RESET,
        DIN => MaskedL2,
        DOUT => L2Edge
    );

    SynchEdgeDetector_FAST_CLEAR: SynchEdgeDetector
    port map(
        CLK => FAST_CLK,
        RESET => RESET,
        DIN => MaskedFastClear,
        Dout => FastClearEdge
    );

    process(FAST_CLK)
    begin
        if(FAST_CLK'event and FAST_CLK = '1') then
            if(RESET = '1') then
                CurrentState <= IDLE;
            else
                CurrentState <= NextState;
            end if;
        end if;
    end process;

    Synchronizer_GathererBusy: Synchronizer
    port map(
        CLK => FAST_CLK,
        RESET => RESET,
        DIN => GATHERER_BUSY,
        DOUT => SynchGathererBusy
    );

    process(CurrentState, HoldEdge, L1Edge, L2Edge, FastClearEdge, int_BUSY,
            SynchGathererBusy, SynchAdcTdcScalerBusy)
    begin
        case CurrentState is
            when IDLE =>
                if(HoldEdge = '1') then
                    NextState <= SEND_ADC_TRIGGER;
                else
                    NextState <= CurrentState;
                end if;
            when SEND_ADC_TRIGGER =>
                NextState <= HOLD_RECEIVED;
            when HOLD_RECEIVED =>
                if(L1Edge = '1') then
                    NextState <= L1_RECEIVED;
                else
                    NextState <= CurrentState;
                end if;
            when L1_RECEIVED =>
                if(FastClearEdge = '1') then
                    NextState <= CLEAR_STATE;
                elsif(L2Edge = '1') then
                    NextState <= WAIT_GATHERER_BUSY;
                else
                    NextState <= CurrentState;
                end if;
            when CLEAR_STATE =>
                NextState <= WAIT_ADC_TDC_BUSY;
            when WAIT_GATHERER_BUSY =>
                if(SynchGathererBusy = '1') then
                    NextState <= CurrentState;
                else
                    NextState <= SEND_TRANSMIT_START;
                end if;
            when SEND_TRANSMIT_START =>
                NextState <= WAIT_ADC_TDC_BUSY;
            when WAIT_ADC_TDC_BUSY =>
                if(SynchAdcTdcScalerBusy = '0') then
                    NextState <= RESET_BUSY;
                else
                    NextState <= CurrentState;
                end if;
            when RESET_BUSY =>
                NextState <= IDLE;
        end case;
    end process;

    SendAdcTrigger    <= '1' when(CurrentState = SEND_ADC_TRIGGER) else '0';
    SendTransmitStart <= '1' when(CurrentState = SEND_TRANSMIT_START) else '0';
    SendFastClear     <= '1' when(CurrentState = CLEAR_STATE) else '0';
    ResetBusy         <= '1' when(CurrentState = RESET_BUSY) else '0';

    process(FAST_CLK)
    begin
        if(FAST_CLK'event and FAST_CLK = '1') then
            if(CurrentState = HOLD_RECEIVED or 
			   CurrentState = L1_RECEIVED  ) then
                CommonStopMask <= '1';
            else
                CommonStopMask <= '0';
            end if;
        end if;
    end process;

    --COMMON_STOP <= L1_TRIGGER and CommonStopMask; -- original
	COMMON_STOP <= L1_tmp and CommonStopMask; -- new for NC

    InterclockTrigger_AdcTrigger: InterclockTrigger
    port map(
        CLK_IN      => FAST_CLK,
        CLK_OUT     => AD9220_CLK,
        RESET       => RESET,
        TRIGGER_IN  => SendAdcTrigger,
        TRIGGER_OUT => ADC_TRIGGER
    );

    InterclockTrigger_ScalerTrigger: InterclockTrigger
    port map(
        CLK_IN      => FAST_CLK,
        CLK_OUT     => SCALER_CLK,
        RESET       => RESET,
        TRIGGER_IN  => L1Edge,
        TRIGGER_OUT => SCALER_TRIGGER
    );

    InterclockTrigger_TransmitStart: InterclockTrigger
    port map(
        CLK_IN      => FAST_CLK,
        CLK_OUT     => SITCP_CLK,
        RESET       => RESET,
        TRIGGER_IN  => SendTransmitStart,
        TRIGGER_OUT => TRANSMIT_START
    );

    InterclockTrigger_AdcFastClear: InterclockTrigger
    port map(
        CLK_IN      => FAST_CLK,
        CLK_OUT     => ADC_CLK,
        RESET       => RESET,
        TRIGGER_IN  => SendFastClear,
        TRIGGER_OUT => ADC_FAST_CLEAR
    );

    InterclockTrigger_TdcFastClear: InterclockTrigger
    port map(
        CLK_IN      => FAST_CLK,
        CLK_OUT     => TDC_CLK,
        RESET       => RESET,
        TRIGGER_IN  => SendFastClear,
        TRIGGER_OUT => TDC_FAST_CLEAR
    );

    InterclockTrigger_ScalerFastClear: InterclockTrigger
    port map(
        CLK_IN      => FAST_CLK,
        CLK_OUT     => SCALER_CLK,
        RESET       => RESET,
        TRIGGER_IN  => SendFastClear,
        TRIGGER_OUT => SCALER_FAST_CLEAR
    );


    process(SITCP_CLK)
    begin
        if(SITCP_CLK'event and SITCP_CLK = '1') then
            DelayedIsDaqMode <= IS_DAQ_MODE;
        end if;
    end process;

    DelayedIsDaqMode_N <= not DelayedIsDaqMode;
    SynchEdgeDetector_IsDaqMode: SynchEdgeDetector
    port map(
        CLK => FAST_CLK,
        RESET => RESET,
        DIN   => DelayedIsDaqMode_N,
        DOUT  => IsDaqModeNEdge
    );

    ResetHoldBusy <= RESET or IsDaqModeNEdge;
    HoldExpander_0: HoldExpander
    port map(
        FAST_CLK => FAST_CLK,
        RESET    => ResetHoldBusy,
        -- HOLD_IN => HOLD, -- old in
        HOLD_IN    => Hold_tmp, -- new in
		HOLD_OUT1_N => HOLD_OUT1_N, -- out -> set EASIROC-1 HOLD pulse high
        HOLD_OUT2_N => HOLD_OUT2_N, -- out -> set EASIROC-2 HOLD pulse high
        EXTERNAL_RESET_HOLD => ResetBusy, -- in
        IS_EXTERNAL_RESET_HOLD => IS_DAQ_MODE -- in
    );

    BusyManager_0: BusyManager
    port map(
        FAST_CLK => FAST_CLK,
        RESET => ResetHoldBusy,
        HOLD => MaskedHold,
        RESET_BUSY => ResetBusy,
        BUSY => int_BUSY
    );

    BUSY <= int_BUSY;

    process(AD9220_CLK)
    begin
        if(AD9220_CLK'event and AD9220_CLK = '1') then
            DelayedAdcBusy <= ADC_BUSY;
        end if;
    end process;

    process(TDC_CLK)
    begin
        if(TDC_CLK'event and TDC_CLK = '1') then
            DelayedTdcBusy <= TDC_BUSY;
        end if;
    end process;

    process(SCALER_CLK)
    begin
        if(SCALER_CLK'event and SCALER_CLK = '1') then
            DelayedScalerBusy <= SCALER_BUSY;
        end if;
    end process;

    AdcTdcScalerBusy <= DelayedAdcBusy or 
						DelayedTdcBusy or 
						DelayedScalerBusy;

    Synchronizer_AdcTdcBusy: Synchronizer
    port map(
        CLK   => FAST_CLK,
        RESET => RESET,
        DIN   => AdcTdcScalerBusy,
        DOUT  => SynchAdcTdcScalerBusy
    );

end RTL;
