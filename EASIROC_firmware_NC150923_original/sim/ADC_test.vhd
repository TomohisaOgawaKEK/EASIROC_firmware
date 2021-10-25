--------------------------------------------------------------------------------
--! @file   ADC_test.vhd
--! @brief  Test bench of ADC.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-12
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ADC_test is
end ADC_test;

architecture behavior of ADC_test is

    -- component Declaration for the Unit Under Test (UUT)

    component ADC
	 generic(
			G_ADC_ADDR : std_logic_vector(31 downto 0)
			);
    port(
         CLK : in  std_logic;
         ADC_CLK : in  std_logic;
         AD9220_CLK : in  std_logic;
         RESET : in  std_logic;
         TRIGGER : in  std_logic;
         BUSY : out  std_logic;
         CLK_READ1 : out  std_logic;
			RSTB_READ1 : out std_logic;
         SRIN_READ1 : out  std_logic;
         CLK_READ2 : out  std_logic;
			RSTB_READ2 : out std_logic;
         SRIN_READ2 : out  std_logic;
         ADC_DATA_HG1 : in  std_logic_vector(11 downto 0);
         ADC_OTR_HG1 : in  std_logic;
         ADC_DATA_LG1 : in  std_logic_vector(11 downto 0);
         ADC_OTR_LG1 : in  std_logic;
         ADC_DATA_HG2 : in  std_logic_vector(11 downto 0);
         ADC_OTR_HG2 : in  std_logic;
         ADC_DATA_LG2 : in  std_logic_vector(11 downto 0);
         ADC_OTR_LG2 : in  std_logic;
         RBCP_ACT : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         RBCP_RE : in  std_logic;
         RBCP_RD : out  std_logic_vector(7 downto 0);
         RBCP_ACK : out  std_logic;
			DATA_READY : out std_logic;
			TRANSMIT_COMPLETE : in std_logic
        );
    end component;


   --Inputs
   signal CLK : std_logic := '0';
   signal ADC_CLK : std_logic := '0';
   signal AD9220_CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal TRIGGER : std_logic := '0';
   signal ADC_DATA_HG1 : std_logic_vector(11 downto 0) := X"000";
   signal ADC_OTR_HG1 : std_logic := '0';
   signal ADC_DATA_LG1 : std_logic_vector(11 downto 0) := X"100";
   signal ADC_OTR_LG1 : std_logic := '0';
   signal ADC_DATA_HG2 : std_logic_vector(11 downto 0) := X"200";
   signal ADC_OTR_HG2 : std_logic := '0';
   signal ADC_DATA_LG2 : std_logic_vector(11 downto 0) := X"300";
   signal ADC_OTR_LG2 : std_logic := '0';
   signal RBCP_ACT : std_logic := '0';
   signal RBCP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
   signal RBCP_RE : std_logic := '0';
	signal TRANSMIT_COMPLETE : std_logic := '0';

 	--Outputs
   signal BUSY : std_logic;
   signal CLK_READ1 : std_logic;
	signal RSTB_READ1 : std_logic;
   signal SRIN_READ1 : std_logic;
   signal CLK_READ2 : std_logic;
	signal RSTB_READ2 : std_logic;
   signal SRIN_READ2 : std_logic;
   signal RBCP_RD : std_logic_vector(7 downto 0);
   signal RBCP_ACK : std_logic;
	signal DATA_READY : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 40 ns;
   constant AD9220_CLK_period : time := 333 ns;
	constant ADC_CLK_period : time := AD9220_CLK_period / 2;
	constant DELAY : time := 8 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: ADC
	generic map (
			G_ADC_ADDR => X"10000000"
			)
	port map (
          CLK => CLK,
          ADC_CLK => ADC_CLK,
          AD9220_CLK => AD9220_CLK,
          RESET => RESET,
          TRIGGER => TRIGGER,
          BUSY => BUSY,
          CLK_READ1 => CLK_READ1,
			 RSTB_READ1 => RSTB_READ1,
          SRIN_READ1 => SRIN_READ1,
          CLK_READ2 => CLK_READ2,
			 RSTB_READ2 => RSTB_READ2,
          SRIN_READ2 => SRIN_READ2,
          ADC_DATA_HG1 => ADC_DATA_HG1,
          ADC_OTR_HG1 => ADC_OTR_HG1,
          ADC_DATA_LG1 => ADC_DATA_LG1,
          ADC_OTR_LG1 => ADC_OTR_LG1,
          ADC_DATA_HG2 => ADC_DATA_HG2,
          ADC_OTR_HG2 => ADC_OTR_HG2,
          ADC_DATA_LG2 => ADC_DATA_LG2,
          ADC_OTR_LG2 => ADC_OTR_LG2,
          RBCP_ACT => RBCP_ACT,
          RBCP_ADDR => RBCP_ADDR,
          RBCP_RE => RBCP_RE,
          RBCP_RD => RBCP_RD,
          RBCP_ACK => RBCP_ACK,
			 DATA_READY => DATA_READY,
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

   ADC_CLK_process :process
   begin
		ADC_CLK <= '1';
		wait for ADC_CLK_period/2;
		ADC_CLK <= '0';
		wait for ADC_CLK_period/2;
   end process;

   AD9220_CLK_process :process
   begin
		AD9220_CLK <= '0';
		wait for AD9220_CLK_period/2;
		AD9220_CLK <= '1';
		wait for AD9220_CLK_period/2;
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

		TRIGGER <= '1' after DELAY,
		           '0' after ADC_CLK_period*2 + DELAY;

		wait until BUSY = '0';

		wait until DATA_READY = '1';
		wait until CLK'event and CLK = '1';

		for i in 0 to 256 loop
			read_data(X"10000000" + i);
		end loop;

		for i in 512 to 512 + 256 loop
			read_data(X"10000000" + i);
		end loop;

      wait;
   end process;

	process(AD9220_CLK)
	begin
		if(AD9220_CLK'event and AD9220_CLK = '1') then
			ADC_DATA_HG1 <= ADC_DATA_HG1 + 1 after DELAY;
			ADC_OTR_HG1 <= not ADC_OTR_HG1 after DELAY;

			ADC_DATA_LG1 <= ADC_DATA_LG1 + 1 after DELAY;
			ADC_OTR_LG1 <= not ADC_OTR_LG1 after DELAY;

			ADC_DATA_HG2 <= ADC_DATA_HG2 + 1 after DELAY;
			ADC_OTR_HG2 <= not ADC_OTR_HG2 after DELAY;

			ADC_DATA_LG2 <= ADC_DATA_LG2 + 1 after DELAY;
			ADC_OTR_LG2 <= not ADC_OTR_LG2 after DELAY;
		end if;
	end process;

end;
