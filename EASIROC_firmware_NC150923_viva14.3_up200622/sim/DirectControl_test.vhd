--------------------------------------------------------------------------------
--! @file   DirectControl_test.vhd
--! @brief  Test bench of DirectControl.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity DirectControl_test is
end DirectControl_test;

architecture behavior of DirectControl_test is

    -- component Declaration for the Unit Under Test (UUT)

    component DirectControl
	 generic(
		G_DIRECT_CONTROL_ADDR : std_logic_vector(31 downto 0)
		);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         RBCP_ACT : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         RBCP_WE : in  std_logic;
         RBCP_WD : in  std_logic_vector(7 downto 0);
         RBCP_ACK : out  std_logic;
         RAZ_CHN1 : out  std_logic;
         VAL_EVT1 : out  std_logic;
         RESET_PA1 : out  std_logic;
         PWR_ON1 : out  std_logic;
         SELECT_SC1 : out  std_logic;
         LOAD_SC1 : out  std_logic;
         RSTB_SR1 : out  std_logic;
         RSTB_READ1 : out  std_logic;
         RAZ_CHN2 : out  std_logic;
         VAL_EVT2 : out  std_logic;
         RESET_PA2 : out  std_logic;
         PWR_ON2 : out  std_logic;
         SELECT_SC2 : out  std_logic;
         LOAD_SC2 : out  std_logic;
         RSTB_SR2 : out  std_logic;
         RSTB_READ2 : out  std_logic;
         --SELECT_HG : out  std_logic;-- commented out by N.CHIKUMA 8/7/2015
         --SELECT_PROBE : out  std_logic;-- commented out by N.CHIKUMA 8/7/2015
         START_SC_CYCLE1 : out  std_logic;
         START_SC_CYCLE2 : out  std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal RBCP_ACT : std_logic := '0';
   signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal RBCP_WE : std_logic := '0';
   signal RBCP_WD : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal RBCP_ACK : std_logic;
   signal RAZ_CHN1 : std_logic;
   signal VAL_EVT1 : std_logic;
   signal RESET_PA1 : std_logic;
   signal PWR_ON1 : std_logic;
   signal SELECT_SC1 : std_logic;
   signal LOAD_SC1 : std_logic;
   signal RSTB_SR1 : std_logic;
   signal RSTB_READ1 : std_logic;
   signal RAZ_CHN2 : std_logic;
   signal VAL_EVT2 : std_logic;
   signal RESET_PA2 : std_logic;
   signal PWR_ON2 : std_logic;
   signal SELECT_SC2 : std_logic;
   signal LOAD_SC2 : std_logic;
   signal RSTB_SR2 : std_logic;
   signal RSTB_READ2 : std_logic;
   signal SELECT_HG : std_logic;
   signal SELECT_PROBE : std_logic;
   signal START_SC_CYCLE1 : std_logic;
   signal START_SC_CYCLE2 : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period*0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: DirectControl
	generic map (
		G_DIRECT_CONTROL_ADDR => X"00000000"
		)
	port map (
          CLK => CLK,
          RESET => RESET,
          RBCP_ACT => RBCP_ACT,
          RBCP_ADDR => RBCP_ADDR,
          RBCP_WE => RBCP_WE,
          RBCP_WD => RBCP_WD,
          RBCP_ACK => RBCP_ACK,
          RAZ_CHN1 => RAZ_CHN1,
          VAL_EVT1 => VAL_EVT1,
          RESET_PA1 => RESET_PA1,
          PWR_ON1 => PWR_ON1,
          SELECT_SC1 => SELECT_SC1,
          LOAD_SC1 => LOAD_SC1,
          RSTB_SR1 => RSTB_SR1,
          RSTB_READ1 => RSTB_READ1,
          RAZ_CHN2 => RAZ_CHN2,
          VAL_EVT2 => VAL_EVT2,
          RESET_PA2 => RESET_PA2,
          PWR_ON2 => PWR_ON2,
          SELECT_SC2 => SELECT_SC2,
          LOAD_SC2 => LOAD_SC2,
          RSTB_SR2 => RSTB_SR2,
          RSTB_READ2 => RSTB_READ2,
          --SELECT_HG => SELECT_HG, -- N.CHIKUMA 2015/08/07 (‹à) 23:22
          --SELECT_PROBE => SELECT_PROBE -- N.CHIKUMA 2015/08/07 (‹à) 23:22
          START_SC_CYCLE1 => START_SC_CYCLE1,
          START_SC_CYCLE2 => START_SC_CYCLE2
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

   begin
		reset_uut;
		write_data(X"00000000", X"FF");

		wait for CLK_period;
		write_data(X"00000001", X"FF");

		wait for CLK_period;
		write_data(X"00000002", X"FF");

      wait;
   end process;

end;
