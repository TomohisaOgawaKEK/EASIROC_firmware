--------------------------------------------------------------------------------
--! @file   MADC_test.vhd
--! @brief  Test bench of MADC.vhd
--! @author Naruhiro Chikuma
--! @date   2015-08-16
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity MADC_test is
end MADC_test;

architecture behavior of MADC_test is

component MADC
    generic(
   	G_MONITOR_ADC_ADDR : std_logic_vector(31 downto 0) := X"00000000";
   	G_READ_MADC_ADDR   : std_logic_vector(31 downto 0) := X"00000000"
    );	    	
    port(
	CLK        : in  std_logic;
	RST        : in  std_logic;
	
	-- RBCP interface
	RBCP_ACT   : in  std_logic;
	RBCP_ADDR  : in  std_logic_vector(31 downto 0);
	RBCP_WD    : in  std_logic_vector(7 downto 0);
	RBCP_WE    : in  std_logic;
	RBCP_ACK   : out std_logic;
	RBCP_RD    : out std_logic_vector(7 downto 0);
	RBCP_RE    : in  std_logic;

    	-- Monitor ADC
	DOUT_MADC  : in  std_logic;
	DIN_MADC   : out std_logic;
	CS_MADC    : out std_logic;
	SCK_MADC   : out std_logic;
	MUX_EN     : out std_logic_vector(3 downto 0);
	MUX        : out std_logic_vector(3 downto 0)
    );
end component;

	-- Inputs
	signal CLK        : std_logic := '0';
	signal RST        : std_logic := '0';
		-- RBCP interface
	signal RBCP_ACT   : std_logic := '0';
	signal RBCP_ADDR  : std_logic_vector(31 downto 0) := (others => '0');
	signal RBCP_WD    : std_logic_vector(7 downto 0)  := (others => '0');
	signal RBCP_WE    : std_logic := '0';
	signal RBCP_RE    : std_logic := '0';
	    	-- Monitor ADC
	signal DOUT_MADC  : std_logic := '0';

	-- Outputs
		-- RBCP interface
	signal RBCP_ACK   : std_logic;
	signal RBCP_RD    : std_logic_vector(7 downto 0);
    	 	-- Monitor ADC
	signal DIN_MADC   : std_logic;
	signal CS_MADC    : std_logic;
	signal SCK_MADC   : std_logic;
	signal MUX_EN     : std_logic_vector(3 downto 0);
	signal MUX        : std_logic_vector(3 downto 0);


   -- Clock period definitions
   	constant CLK_period : time := 40 ns;  --25MHz
	constant DELAY : time := CLK_period*0.2;
   	constant Madc_renew : time :=  8 ms;  --125Hz
	constant readout_data : std_logic_vector(15 downto 0) := X"ABCD";

begin

	utt: MADC 
	    generic map (
	   	G_MONITOR_ADC_ADDR => X"00000001",
	   	G_READ_MADC_ADDR   => X"00000005"
	    )   	
	    port map(
		CLK      => CLK, 
		RST      => RST, 
		
		-- RBCP interface
		RBCP_ACT   => RBCP_ACT,  
		RBCP_ADDR  => RBCP_ADDR, 
		RBCP_WD    => RBCP_WD,   
		RBCP_WE    => RBCP_WE,   
		RBCP_ACK   => RBCP_ACK,  
		RBCP_RD    => RBCP_RD,   
		RBCP_RE    => RBCP_RE,   
	
	    	-- Monitor ADC
		DOUT_MADC =>  DOUT_MADC,
		DIN_MADC  =>  DIN_MADC, 
		CS_MADC   =>  CS_MADC,  
		SCK_MADC  =>  SCK_MADC, 
		MUX_EN    =>  MUX_EN,   
		MUX       =>  MUX      
	    );


   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
  


   -- Stimulus process
   stim_proc: process

		procedure reset_uut is
		begin
			RST <= '1';
			wait until CLK'event and CLK = '1';
			wait for CLK_period;
			RST <= '0' after DELAY;
		end procedure;

		procedure madc_out is
		begin
			wait for CLK_period*18;


			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(15);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(14);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(13);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(12);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(11);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(10);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(9);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(8);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(7);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(6);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(5);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(4);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(3);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(2);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(1);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= readout_data(0);
			wait until CLK'event and CLK = '1';
			DOUT_MADC <= '1';  --- read out is done

		end procedure;

		procedure write_data
		(
			addr : std_logic_vector(31 downto 0);
			data : std_logic_vector(7 downto 0)
		) is
		begin
			wait for CLK_period;
			RBCP_ACT <= '1' after DELAY;
			wait for CLK_period*2;

			RBCP_ADDR <= addr after DELAY;
			RBCP_WE <= '1' after DELAY;
			RBCP_WD <= data after DELAY;
			wait for CLK_period;

			RBCP_ADDR <= (others => '0') after DELAY;
			RBCP_WE <= '0' after DElAY;
			RBCP_WD <= (others => '0') after DELAY;

			wait until RBCP_ACK'event and RBCP_ACK = '1';
			wait for CLK_period;
			RBCP_ACT <= '0' after DELAY;
		end procedure;

		procedure read_data
		(
			addr : std_logic_vector(31 downto 0)
		) is
		begin
			wait for CLK_period;
			RBCP_ACT <= '1' after DELAY;
			wait for CLK_period*2;

			RBCP_ADDR <= addr after DELAY;
			RBCP_RE <= '1' after DELAY;
			wait for CLK_period;

			RBCP_ADDR <= (others => '0') after DELAY;
			RBCP_RE <= '0' after DElAY;

			wait until RBCP_ACK'event and RBCP_ACK = '1';
			wait for CLK_period;
			RBCP_ACT <= '0' after DELAY;
		end procedure;


   begin
	

		reset_uut;
		write_data(X"00000001", X"F8");

		wait for CLK_period;
		write_data(X"00000002", X"00");
	
		wait for CLK_period*30;
		write_data(X"00000001", X"03");
	
		wait for CLK_period;
		write_data(X"00000002", X"00");

		DOUT_MADC <= '0';
		wait for CLK_period*40;
		write_data(X"00000001", X"F0");

		wait for CLK_period;
		write_data(X"00000002", X"01");
		madc_out;

		wait for CLK_period*30;
		read_data(X"00000005");

		wait for CLK_period;
		read_data(X"00000006");


      wait;
   end process;

end;
