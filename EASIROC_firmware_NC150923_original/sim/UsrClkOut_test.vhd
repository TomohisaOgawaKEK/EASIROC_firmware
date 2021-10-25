--------------------------------------------------------------------------------
--! @file   UsrClkOut_test.vhd
--! @brief  Test bench of UsrClkOut.vhd
--! @author Naruhiro Chikuma
--! @date   2015-08-31
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity UsrClkOut_test is
end UsrClkOut_test;

architecture behavior of UsrClkOut_test is

	component UsrClkOut 
    generic(
   	G_USER_OUTPUT_ADDR : std_logic_vector(31 downto 0) := X"00000000"
    );	    	
    port(
	CLK_25M    : in  std_logic;
	RST        : in  std_logic;
	
	-- RBCP interface
	RBCP_ACT   : in  std_logic;
	RBCP_ADDR  : in  std_logic_vector(31 downto 0);
	RBCP_WD    : in  std_logic_vector(7 downto 0);
	RBCP_WE    : in  std_logic;
	RBCP_ACK   : out std_logic;

    	-- clock in
	CLK_500M   : in  std_logic;
	CLK_125M   : in  std_logic;
	CLK_3M     : in  std_logic;
	
    	-- out
    	DOUT       : out std_logic
    );
	end component;

	signal CLK_25M    :  std_logic := '0';
	signal RST        :  std_logic := '0';
	signal RBCP_ACT   :  std_logic := '0';
	signal RBCP_ADDR  :  std_logic_vector(31 downto 0) := X"00000000";
	signal RBCP_WD    :  std_logic_vector(7 downto 0) := X"00";
	signal RBCP_WE    :  std_logic := '0';
	signal RBCP_ACK   :  std_logic;
	signal CLK_500M   :  std_logic := '0';
	signal CLK_125M   :  std_logic := '0';
	signal CLK_3M     :  std_logic := '0';
    	signal DOUT       :  std_logic;

   -- Clock period definitions
   	constant CLK_500M_period : time := 2 ns;  --500MHz
   	constant CLK_25M_period : time := 40 ns;  --25MHz
   	constant CLK_125M_period : time := 8 ns;  --125MHz
   	constant CLK_3M_period : time := 333.3333333333 ns;  --3MHz
	constant CLK_period : time := 40 ns;  --for SiTCP
	constant DELAY : time := CLK_period*0.2;

begin
    
	utt: UsrClkOut 
    	generic map(
    	    G_USER_OUTPUT_ADDR => X"00000005"
    	)	    	
    	port map(
    	    CLK_25M   => CLK_25M,
    	    RST       => RST,
    	                 
    	    RBCP_ACT  => RBCP_ACT,
    	    RBCP_ADDR => RBCP_ADDR,
    	    RBCP_WD   => RBCP_WD,
    	    RBCP_WE   => RBCP_WE, 
    	    RBCP_ACK  => RBCP_ACK,
                                  
    	    CLK_500M  => CLK_500M,
    	    CLK_125M  => CLK_125M,
    	    CLK_3M    => CLK_3M,
    	                 
	    DOUT      => DOUT     
    	);


   -- Clock process definitions
   process
   begin
		CLK_500M <= '0';
		wait for CLK_500M_period/2;
		CLK_500M <= '1';
		wait for CLK_500M_period/2;
   end process;
   
   process
   begin
		CLK_125M <= '0';
		wait for CLK_125M_period/2;
		CLK_125M <= '1';
		wait for CLK_125M_period/2;
   end process; 

   process
   begin
		CLK_25M <= '0';
		wait for CLK_25M_period/2;
		CLK_25M <= '1';
		wait for CLK_25M_period/2;
   end process; 

   process
   begin
		CLK_3M <= '0';
		wait for CLK_3M_period/2;
		CLK_3M <= '1';
		wait for CLK_3M_period/2;
   end process; 


   -- Stimulus process
   stim_proc: process

		procedure reset_uut is
		begin
			RST <= '1';
			wait until CLK_25M'event and CLK_25M = '1';
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

		wait for CLK_period*10;
		write_data(X"00000005", X"01");
		wait for CLK_period*10;
		write_data(X"00000005", X"00");
		wait for CLK_period*10;
		write_data(X"00000005", X"06");

      wait;
   end process;

end;
