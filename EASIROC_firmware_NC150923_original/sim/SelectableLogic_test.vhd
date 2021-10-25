--------------------------------------------------------------------------------
--! @file   SelectableLogic_test.vhd
--! @brief  Test bench of SelectableLogic.vhd
--! @author Naruhiro Chikuma
--! @date   2015-09-05
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SelectableLogic_test is
end SelectableLogic_test;

architecture behavior of SelectableLogic_test is

component SelectableLogic is
    generic(
        G_SELECTABLE_LOGIC_ADDRESS : std_logic_vector(31 downto 0) := X"00000000"
    );
    port(
        CLK         : in std_logic;
        RESET       : in std_logic;
        TRIGGER_IN1 : in std_logic_vector(31 downto 0);
        TRIGGER_IN2 : in std_logic_vector(31 downto 0);
        RBCP_ACT    : in std_logic;
        RBCP_ADDR   : in std_logic_vector(31 downto 0);
        RBCP_WE     : in std_logic;
        RBCP_WD     : in std_logic_vector(7 downto 0);
        RBCP_ACK    : out std_logic;
        SELECTABLE_LOGIC : out std_logic
    );
end component;
        
    -- Inputs
	signal CLK         : std_logic := '0';
        signal RESET       : std_logic := '0';
        signal TRIGGER_IN1 : std_logic_vector(31 downto 0) := (others => '0');
        signal TRIGGER_IN2 : std_logic_vector(31 downto 0) := (others => '0');
        signal RBCP_ACT    : std_logic := '0';
        signal RBCP_ADDR   : std_logic_vector(31 downto 0) := (others => '0');
        signal RBCP_WE     : std_logic := '0';
        signal RBCP_WD     : std_logic_vector(7 downto 0)  := (others => '0');
    -- Outputs
        signal RBCP_ACK    : std_logic;
        signal SELECTABLE_LOGIC : std_logic;

   -- Clock period definitions
   	constant CLK_period : time := 40 ns;  --25MHz
	constant DELAY : time := CLK_period*0.2;
	
	constant IN_Pattern         : std_logic_vector(7  downto 0) := X"09";
	constant IN_Channel         : std_logic_vector(7  downto 0) := X"00";
	constant IN_HitNumThreshold : std_logic_vector(7  downto 0) := X"00";
	constant IN_AndLogicChannel1: std_logic_vector(31 downto 0) := X"00060006";
	constant IN_AndLogicChannel2: std_logic_vector(31 downto 0) := X"C0200000";


begin

utt: SelectableLogic
    generic map(
        G_SELECTABLE_LOGIC_ADDRESS => X"00000000"
    )
    port map(
        CLK         => CLK,         
        RESET       => RESET,       
        TRIGGER_IN1 => TRIGGER_IN1, 
        TRIGGER_IN2 => TRIGGER_IN2, 
        RBCP_ACT    => RBCP_ACT,    
        RBCP_ADDR   => RBCP_ADDR,   
        RBCP_WE     => RBCP_WE,     
        RBCP_WD     => RBCP_WD,     
        RBCP_ACK    => RBCP_ACK,    
	SELECTABLE_LOGIC => SELECTABLE_LOGIC
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

		procedure trig_on
		(
			trig_in : std_logic_vector(63 downto 0)
		) is
		begin
			wait for CLK_period;
			for i in trig_in'range loop
				if(i<32) then
					if(trig_in(i)='1') then
						TRIGGER_IN1(i) <= '1';
					end if;
				else
					if(trig_in(i)='1') then
						TRIGGER_IN2(i-32) <= '1';
					end if;
				end if;
			end loop;
			wait for CLK_period;
			TRIGGER_IN1 <= (others => '0');
			TRIGGER_IN2 <= (others => '0');
			wait for CLK_period;
		end procedure;
   begin
	

		reset_uut;
		write_data(X"00000000", IN_Pattern(7 downto 0));
		write_data(X"00000001", IN_Channel(7 downto 0));
		write_data(X"00000002", IN_HitNumThreshold(7 downto 0)  );
		write_data(X"00000003", IN_AndLogicChannel1(31 downto 24));
		write_data(X"00000004", IN_AndLogicChannel1(23 downto 16));
		write_data(X"00000005", IN_AndLogicChannel1(15 downto 8));
		write_data(X"00000006", IN_AndLogicChannel1(7 downto 0));
		write_data(X"00000007", IN_AndLogicChannel2(31 downto 24));
		write_data(X"00000008", IN_AndLogicChannel2(23 downto 16));
		write_data(X"00000009", IN_AndLogicChannel2(15 downto 8) );
		write_data(X"0000000A", IN_AndLogicChannel2(7 downto 0)  );

		wait for CLK_period*10;

		trig_on("0000000000000000000000000000000000000000000000000000000000000000");
		wait for CLK_period*20;

		--------- "         "         "          |"         "         "         "  
		---------1398765432129876543211987654321013987654321298765432119876543210
		trig_on("1100000000100000000000000000000000000000000001100000000000000110");
		wait for CLK_period*20;
	
		--------- "         "         "          |"         "         "         "  
		---------1398765432129876543211987654321013987654321298765432119876543210
		trig_on("0000000000000000000000000000000000000000000000100000000000000110");
		wait for CLK_period*20;

		--------- "         "         "          |"         "         "         "  
		---------1398765432129876543211987654321013987654321298765432119876543210
		trig_on("0000000000000000000000000000000000000000000101100000000000000110");
		wait for CLK_period*20;

		--------- "         "         "          |"         "         "         "  
		---------1398765432129876543211987654321013987654321298765432119876543210
		trig_on("1100000000100000000000000000000000000000000000000000000000000000");
		wait for CLK_period*20;
	
		--------- "          "        "          |"         "         "         "  
		---------1398765432129876543211987654321013987654321298765432119876543210
		trig_on("1111111111111111111111111111111111111111111111111111111111111111");
		wait for CLK_period*20;

      wait;
   end process;

end;
