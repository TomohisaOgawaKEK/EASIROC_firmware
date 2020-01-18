--------------------------------------------------------------------------------
--! @file   HVControl_test.vhd
--! @brief  Test bench of HVControl.vhd
--! @author Naruhiro Chikuma
--! @date   2015-08-16
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity HVControl_test is
end HVControl_test;

architecture behavior of HvControl_test is

component HVControl
    generic(
	    	G_HV_CONTROL_ADDR : std_logic_vector(31 downto 0) := X"00000000"
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

	-- DAC output
	SDI_DAC    : out std_logic;
	SCK_DAC    : out std_logic;
	CS_DAC     : out std_logic;
	HV_EN      : out std_logic;
	
	-- LED control
	DOUT_LED   : out std_logic_vector(15 downto 0)
);
end component;

	signal CLK        : std_logic := '0';
	signal RST        : std_logic := '0';
	signal RBCP_ACT   : std_logic := '0';
    	signal RBCP_ADDR  : std_logic_vector(31 downto 0) := (others => '0');
    	signal RBCP_WD    : std_logic_vector(7 downto 0)  := (others => '0');
    	signal RBCP_WE    : std_logic := '0';
	signal RBCP_ACK   : std_logic;
	signal SDI_DAC    : std_logic;
	signal SCK_DAC    : std_logic;
	signal CS_DAC     : std_logic;
	signal HV_EN      : std_logic;
	signal DOUT_LED   : std_logic_vector(15 downto 0);

   -- Clock period definitions
   	constant CLK_period : time := 40 ns;  --25MHz
	constant DELAY : time := CLK_period*0.2;

	constant C_ADDR : std_logic_vector(31 downto 0) := X"00000005";

begin
	
utt :HVControl
    generic map(
	    	G_HV_CONTROL_ADDR => C_ADDR
    )    	
    port map(
	CLK        => CLK,
	RST        => RST,        
	RBCP_ACT   => RBCP_ACT,   
    	RBCP_ADDR  => RBCP_ADDR,  
    	RBCP_WD    => RBCP_WD,    
    	RBCP_WE    => RBCP_WE,    
	RBCP_ACK   => RBCP_ACK,   
	SDI_DAC    => SDI_DAC,    
	SCK_DAC    => SCK_DAC,    
	CS_DAC     => CS_DAC,    
	HV_EN      => HV_EN,      
	DOUT_LED   => DOUT_LED   
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

   begin
		reset_uut;

		write_data(X"00000005", X"F8");
		wait for CLK_period;
		write_data(X"00000006", X"C1");
		wait for CLK_period;
		write_data(X"00000007", X"01");

		wait for CLK_period*20;
		write_data(X"00000008", X"00");



      wait;
   end process;

end;
