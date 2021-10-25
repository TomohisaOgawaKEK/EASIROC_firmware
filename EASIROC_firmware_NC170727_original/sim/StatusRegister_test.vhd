--------------------------------------------------------------------------------
--! @file   StatusRegister_test.vhd
--! @brief  Test bench of StatusRegister.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-15
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity StatusRegister_test is
end StatusRegister_test;

architecture behavior of StatusRegister_test is

    -- component Declaration for the Unit Under Test (UUT)
    component StatusRegister
    generic(
	   G_STATUS_REGISTER_ADDR : std_logic_vector(31 downto 0)
	);
    port(
         CLK       : in  std_logic;
         RESET     : in  std_logic;
         RBCP_ACT  : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         --RBCP_RE   : in  std_logic;                       -- this was not used in StatusRegister
         --RBCP_RD   : out  std_logic_vector(7 downto 0);   -- this was not used in StatusRegister
         RBCP_WE   : in  std_logic;
         RBCP_WD   : in  std_logic_vector(7 downto 0);
         -- output
         RBCP_ACK  : out  std_logic;
         --ADC_READY : in  std_logic;                       -- this was not used in StatusRegister
         --TRANSMIT_COMPLETE : out  std_logic               -- this was not used in StatusRegister
         DAQ_MODE : out std_logic;
         SEND_ADC : out std_logic;
         SEND_TDC : out std_logic;
         SEND_SCALER : out std_logic
    );
    end component;

    --Inputs
    signal CLK      : std_logic := '0';
    signal RESET    : std_logic := '0';
    signal RBCP_ACT : std_logic := '0';
    signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
    --signal RBCP_RE : std_logic := '0';
    --signal RBCP_RD : std_logic_vector(7 downto 0);
    signal RBCP_WE : std_logic := '0';
    signal RBCP_WD : std_logic_vector(7 downto 0) := (others => '0');
    signal RBCP_ACK : std_logic;
    --signal ADC_READY : std_logic := '0';
    --signal TRANSMIT_COMPLETE : std_logic;
    signal DAQ_MODE : std_logic := '0';
    signal SEND_ADC : std_logic := '0';
    signal SEND_TDC : std_logic := '0';
    signal SEND_SCALER : std_logic := '0';

    -- Clock period definitions
    constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period * 0.2;

begin
	-- Instantiate the Unit Under Test (UUT)
    uut: StatusRegister
	generic map(
	   G_STATUS_REGISTER_ADDR => X"10000000"
	)
	port map (
          CLK => CLK,
          RESET => RESET,
          RBCP_ACT => RBCP_ACT,
          RBCP_ADDR => RBCP_ADDR,
          --RBCP_RE => RBCP_RE,
          --RBCP_RD => RBCP_RD,
          RBCP_WE => RBCP_WE,
          RBCP_WD => RBCP_WD,
          RBCP_ACK => RBCP_ACK,
          --ADC_READY => ADC_READY,
          --TRANSMIT_COMPLETE => TRANSMIT_COMPLETE
          DAQ_MODE => DAQ_MODE,
          SEND_ADC => SEND_ADC,
          SEND_TDC => SEND_TDC,
          SEND_SCALER => SEND_SCALER
    );

    -- Clock process definitions
    CLK_process :process
    begin
		CLK <= '0';
		wait for CLK_period/2; -- 5 ns
		CLK <= '1';
		wait for CLK_period/2; -- 5 ns
    end process;

    -- Stimulus process
    stim_proc: process

	procedure reset_uut is
	begin
		RESET <= '1';
		wait until CLK'event and CLK = '1'; -- rising edge 
		wait for CLK_period;                -- wait 10 ns
		RESET <= '0' after DELAY;           -- delay 2 ns
	end procedure;

	procedure read_data (
	   addr : std_logic_vector(31 downto 0)
    ) is
	begin
        RBCP_ACT <= '1' after DELAY;
		wait for CLK_period * 2; -- 20 ns

		RBCP_ADDR <= addr after DELAY; -- put address X"10000000" -> 32bit binary 000100..00
		--RBCP_RE <= '1' after DELAY;
		wait for CLK_period;

		RBCP_ADDR <= (others => '0') after DELAY;
		--RBCP_RE <= '0' after DELAY;

        --RBCP_ACK <= '1' after DELAY; -- add this line to test below RBCP_ACK, but ?? 
        
		wait until RBCP_ACK'event and RBCP_ACK = '1';
		wait for CLK_period;

		RBCP_ACT <= '0' after DELAY; -- 0 にならないのなんで？ 上でRBCP_ACK の立ち上がりがないから？
		wait for CLK_period;
	end procedure;

    procedure write_data (
        addr : std_logic_vector(31 downto 0);
        data : std_logic_vector( 7 downto 0)
	) is
	begin
		wait for CLK_period;         -- 10 ns (27 ns)
		
		RBCP_ACT <= '1' after DELAY; --  2 ns 
		wait for CLK_period * 2;     -- 20 ns

        -- 以下同時に起こる after delay ってされてから？
		RBCP_ADDR <= addr after DELAY; -- put address X"10000000" -> 32bit binary 000100..00
		RBCP_WE   <= '1'  after DELAY; 
		RBCP_WD   <= data after DELAY; -- put hexadecimal X"FF" -> 255 -> 8bit binary 11111111
		wait for CLK_period;           -- 10 ns

		RBCP_ADDR <= (others => '0') after DELAY; -- initialize 
		RBCP_WE   <= '0'             after DELAY; -- initialize
		RBCP_WD   <= (others => '0') after DELAY; -- initialize

		wait until RBCP_ACK'event and RBCP_ACK = '1'; -- this is 1 because of above line
		wait for CLK_period;                          --  10 ns
		RBCP_ACT <= '0' after DELAY;
	end procedure;

    begin
		reset_uut; -- in total 17 ns interval 
		write_data(X"10000000", X"FF");

		--ADC_READY <= '1' after DELAY;
		wait for CLK_period * 10;
		read_data(X"10000000");
        wait;
    end process;
end;
