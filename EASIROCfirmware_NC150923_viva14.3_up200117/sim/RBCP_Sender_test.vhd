--------------------------------------------------------------------------------
--! @file   RBCP_Sender.vhd
--! @brief  test bench of RBCP_Sender.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-05
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity RBCP_Sender_test is
end RBCP_Sender_test;

architecture behavior of RBCP_Sender_test is

    -- component Declaration for the Unit Under Test (UUT)

    component RBCP_Sender
	 generic ( G_ADDR : std_logic_vector(31 downto 0);
	           G_LEN : integer;
				  G_ADDR_WIDTH : integer
				);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         RBCP_ACT : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         RBCP_RE : in  std_logic;
         RBCP_RD : out  std_logic_vector(7 downto 0);
         RBCP_ACK : out  std_logic;
         ADDR : out  std_logic_vector(G_ADDR_WIDTH - 1 downto 0);
         RD : in  std_logic_vector(7 downto 0)
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal RBCP_ACT : std_logic := '0';
   signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal RBCP_RE : std_logic := '0';
   signal RD : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal RBCP_RD : std_logic_vector(7 downto 0);
   signal RBCP_ACK : std_logic;
   --signal ADDR : std_logic_vector(2 downto 0);
   signal ADDR : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period*0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: RBCP_Sender
	generic map(
		G_ADDR => X"00000001",
		G_LEN => 2,
		G_ADDR_WIDTH => 2
		)
	port map (
          CLK => CLK,
          RESET => RESET,
          RBCP_ACT => RBCP_ACT,
          RBCP_ADDR => RBCP_ADDR,
          RBCP_RE => RBCP_RE,
          RBCP_RD => RBCP_RD,
          RBCP_ACK => RBCP_ACK,
          ADDR => ADDR,
          RD => RD
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

		procedure read_data
			(addr : std_logic_vector(31 downto 0)) is
		begin
			RBCP_ACT <= '1' after DELAY;
			wait for CLK_period * 2;

			RBCP_ADDR <= addr after DELAY;
			RBCP_RE <= '1' after DELAY;
			wait for CLK_period;

			RBCP_ADDR <= (others => '0') after DELAY;
			RBCP_RE <= '0' after DELAY;

			wait until RBCP_ACK'event and RBCP_ACK = '1';
			wait for CLK_period;

			RBCP_ACT <= '0' after DELAY;
			wait for CLK_period;
		end procedure;

   begin
      reset_uut;

		read_data(X"00000001");
		read_data(X"00000002");
		read_data(X"00000003");
		read_data(X"00000004");
		read_data(X"00000005");
		read_data(X"00000006");
		read_data(X"00000007");

      wait;
   end process;

	process(CLK)
	begin
		if(CLK'event and CLK = '1') then
			case ADDR is
			    when "00" =>
			        RD <= X"F0";
			    when "01" =>
			        RD <= X"0C";   
				--when "000" =>
				--	RD <= X"00";
				--when "001" =>
				--	RD <= X"01";
				--when "010" =>
				--	RD <= X"02";
				--when "011" =>
				--	RD <= X"03";
				--when "100" =>
				--	RD <= X"04";
				--when "101" =>
				--	RD <= X"05";
				--when "110" =>
				--	RD <= X"06";
				--when "111" =>
				--	RD <= X"07";
				when others =>
					RD <= (others => 'X');
			end case;
		end if;
	end process;

end;
