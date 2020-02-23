--------------------------------------------------------------------------------
--! @file   TriggerWidth_test.vhd
--! @brief  Test bench of TriggerWidth.vhd
--! @author Naruhiro Chikuma
--! @date   2015-09-18
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity TriggerWidth_test is
end TriggerWidth_test;

architecture behavior of TriggerWidth_test is

    component TriggerWidth is
	generic(
	  G_TRIGGER_WIDTH_ADDRESS : std_logic_vector(31 downto 0)
        );
	port(
          CLK          : in  std_logic;
          RESET        : in  std_logic;
          RBCP_ACT     : in  std_logic;
          RBCP_ADDR    : in  std_logic_vector(31 downto 0);
          RBCP_WE      : in  std_logic;
          RBCP_WD      : in  std_logic_vector(7 downto 0);
          RBCP_ACK     : out std_logic;
    	  INTERVAL_CLK : in  std_logic;
          TRIGGER_IN1  : in  std_logic_vector(31 downto 0);
          TRIGGER_IN2  : in  std_logic_vector(31 downto 0);
          TRIGGER_OUT1 : out std_logic_vector(31 downto 0);
          TRIGGER_OUT2 : out std_logic_vector(31 downto 0)
	);
    end component;

         signal CLK          :  std_logic := '0';
         signal RESET        :  std_logic := '0';
         signal RBCP_ACT     :  std_logic := '0';
         signal RBCP_ADDR    :  std_logic_vector(31 downto 0) := (others => '0');
         signal RBCP_WE      :  std_logic := '0';
         signal RBCP_WD      :  std_logic_vector(7 downto 0) := (others => '0');
         signal RBCP_ACK     :  std_logic;
    	 signal INTERVAL_CLK :  std_logic := '0';
         signal TRIGGER_IN1  :  std_logic_vector(31 downto 0) := (others => '0');
         signal TRIGGER_IN2  :  std_logic_vector(31 downto 0) := (others => '0');
         signal TRIGGER_OUT1 :  std_logic_vector(31 downto 0);
         signal TRIGGER_OUT2 :  std_logic_vector(31 downto 0);


   -- Clock period definitions
   	constant CLK_500M_period : time := 2 ns;  --500MHz
	constant DELAY_500M : time := CLK_500M_period*0.2;
	constant CLK_125M_period : time := 8 ns;  --125MHz
    constant DELAY_125M : time := CLK_125M_period*0.2;
	constant CLK_period : time := 40 ns;  --for SiTCP
	constant DELAY : time := CLK_period*0.2;

begin
    
	utt: TriggerWidth 
    generic map(
	  G_TRIGGER_WIDTH_ADDRESS => X"00000088"
    )
    port map(
          CLK          =>  CLK,         
          RESET        =>  RESET,       
          RBCP_ACT     =>  RBCP_ACT,    
          RBCP_ADDR    =>  RBCP_ADDR,   
          RBCP_WE      =>  RBCP_WE,     
          RBCP_WD      =>  RBCP_WD,     
          RBCP_ACK     =>  RBCP_ACK,    
    	  INTERVAL_CLK =>  INTERVAL_CLK,    
          TRIGGER_IN1  =>  TRIGGER_IN1, 
          TRIGGER_IN2  =>  TRIGGER_IN2, 
          TRIGGER_OUT1 =>  TRIGGER_OUT1,
          TRIGGER_OUT2 =>  TRIGGER_OUT2
    );

   -- Clock process definitions
   process
   begin
		INTERVAL_CLK <= '0';
		wait for CLK_125M_period/2;
		INTERVAL_CLK <= '1';
		wait for CLK_125M_period/2;
   end process;
  
   process
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
			RESET <= '1';
			wait until CLK'event and CLK = '1';
			wait for CLK_period;
			RESET <= '0' after DELAY;
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

        wait for CLK_period*10.1241;
		TRIGGER_IN1 <= X"00000010";
		wait for 12.4 ns;
		TRIGGER_IN1 <= (others=>'0');

		wait for CLK_period*10;
		write_data(X"00000088", X"60");
		wait for CLK_period*10.235;
		TRIGGER_IN1 <= X"A0000000";
		wait for 35.4567 ns;
		TRIGGER_IN1 <= (others=>'0');
		
		wait for CLK_period*10;
		write_data(X"00000088", X"08");
		wait for CLK_period*10.265;
		TRIGGER_IN1 <= X"00000100";
		wait for 35 ns;
		TRIGGER_IN1 <= X"00000002";
		wait for 10.213 ns;
		TRIGGER_IN1 <= (others=>'0');
	
		wait for CLK_period*10;
		write_data(X"00000088", X"00");
		wait for CLK_period*10.235;
		TRIGGER_IN2 <= X"00000001";
		wait for 35.4567 ns;
		TRIGGER_IN2 <= (others=>'0');

		wait for CLK_period*10;
		write_data(X"00000088", X"60");
		wait for CLK_period*10.212;
		TRIGGER_IN1 <= X"00001000";
		wait for 20.224 ns;
		TRIGGER_IN1 <= (others=>'0');

      wait;
   end process;

end;
