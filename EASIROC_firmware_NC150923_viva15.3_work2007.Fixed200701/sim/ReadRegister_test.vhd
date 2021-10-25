--------------------------------------------------------------------------------
--! @file   ReadRegister_test.vhd
--! @brief  Test bench of ReadRegister.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ReadRegister_test is
end ReadRegister_test;

architecture behavior of ReadRegister_test is

    -- component Declaration for the Unit Under Test (UUT)

    component ReadRegister
	 generic(
			G_READ_REGISTER_ADDR : std_logic_vector(31 downto 0)
			);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         READ_REGISTER_CLK : in  std_logic;
         RBCP_ACT : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         RBCP_WE : in  std_logic;
         RBCP_WD : in  std_logic_vector(7 downto 0);
         RBCP_ACK : out  std_logic;
         SRIN_READ : out  std_logic;
         CLK_READ : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal READ_REGISTER_CLK : std_logic := '0';
   signal RBCP_ACT : std_logic := '0';
   signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal RBCP_WE : std_logic := '0';
   signal RBCP_WD : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal RBCP_ACK : std_logic;
   signal SRIN_READ : std_logic;
   signal CLK_READ : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 40 ns;
   constant READ_REGISTER_CLK_period : time := 167 ns;
	constant DELAY : time := 2 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: ReadRegister
	generic map(
			 G_READ_REGISTER_ADDR => X"00150000"
			 )
	port map (
          CLK => CLK,
          RESET => RESET,
          READ_REGISTER_CLK => READ_REGISTER_CLK,
          RBCP_ACT => RBCP_ACT,
          RBCP_ADDR => RBCP_ADDR,
          RBCP_WE => RBCP_WE,
          RBCP_WD => RBCP_WD,
          RBCP_ACK => RBCP_ACK,
          SRIN_READ => SRIN_READ,
          CLK_READ => CLK_READ
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

   READ_REGISTER_CLK_process :process
   begin
		READ_REGISTER_CLK <= '0';
		wait for READ_REGISTER_CLK_period/2;
		READ_REGISTER_CLK <= '1';
		wait for READ_REGISTER_CLK_period/2;
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
		write_data(X"00150000", X"00");


      wait;
   end process;

end;
