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
         CLK : in  std_logic;
         RESET : in  std_logic;
         RBCP_ACT : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         RBCP_RE : in  std_logic;
         RBCP_RD : out  std_logic_vector(7 downto 0);
         RBCP_WE : in  std_logic;
         RBCP_WD : in  std_logic_vector(7 downto 0);
         RBCP_ACK : out  std_logic;
         ADC_READY : in  std_logic;
         TRANSMIT_COMPLETE : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal RBCP_ACT : std_logic := '0';
   signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal RBCP_RE : std_logic := '0';
   signal RBCP_WE : std_logic := '0';
   signal RBCP_WD : std_logic_vector(7 downto 0) := (others => '0');
   signal ADC_READY : std_logic := '0';

 	--Outputs
   signal RBCP_RD : std_logic_vector(7 downto 0);
   signal RBCP_ACK : std_logic;
   signal TRANSMIT_COMPLETE : std_logic;

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
          RBCP_RE => RBCP_RE,
          RBCP_RD => RBCP_RD,
          RBCP_WE => RBCP_WE,
          RBCP_WD => RBCP_WD,
          RBCP_ACK => RBCP_ACK,
          ADC_READY => ADC_READY,
          TRANSMIT_COMPLETE => TRANSMIT_COMPLETE
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

		write_data(X"10000000", X"FF");

		ADC_READY <= '1' after DELAY;

		wait for CLK_period * 10;
		read_data(X"10000000");

      wait;
   end process;

end;
