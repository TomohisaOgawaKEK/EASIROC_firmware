--------------------------------------------------------------------------------
--! @file   Version_test.vhd
--! @brief  Test bench of Version.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-05
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Version_test is
end Version_test;

architecture behavior of Version_test is

    -- component Declaration for the Unit Under Test (UUT)

    component Version
	 generic ( G_VERSION_ADDR : std_logic_vector(31 downto 0);
				  G_VERSION : std_logic_vector(15 downto 0);
				  G_SYNTHESIZED_DATE : std_logic_vector(31 downto 0)
	 );
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         RBCP_ACT : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         RBCP_RE : in  std_logic;
         RBCP_RD : out  std_logic_vector(7 downto 0);
         RBCP_ACK : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal RBCP_ACT : std_logic := '0';
   signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal RBCP_RE : std_logic := '0';

 	--Outputs
   signal RBCP_RD : std_logic_vector(7 downto 0);
   signal RBCP_ACK : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period*0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: Version
	generic map(
		G_VERSION_ADDR => X"F0000000",
		G_VERSION => X"1_2_3_4",
		G_SYNTHESIZED_DATE => X"2013_11_05"
	)
	port map (
          CLK => CLK,
          RESET => RESET,
          RBCP_ACT => RBCP_ACT,
          RBCP_ADDR => RBCP_ADDR,
          RBCP_RE => RBCP_RE,
          RBCP_RD => RBCP_RD,
          RBCP_ACK => RBCP_ACK
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

		read_data(X"F0000000");
		read_data(X"F0000001");
		read_data(X"F0000002");
		read_data(X"F0000003");
		read_data(X"F0000004");
		read_data(X"F0000005");
      wait;
   end process;

end;
