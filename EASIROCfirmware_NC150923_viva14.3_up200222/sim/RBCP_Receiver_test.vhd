--------------------------------------------------------------------------------
--! @file   RBCP_Receiver_test.vhd
--! @brief  Test bench of RBCP_Receiver.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-01
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity RBCP_Receiver_test is
end RBCP_Receiver_test;

architecture behavior of RBCP_Receiver_test is

    -- component Declaration for the Unit Under Test (UUT)

    component RBCP_Receiver
	 generic ( G_ADDR : std_logic_vector(31 downto 0);
	           G_LEN : integer;
				  G_ADDR_WIDTH : integer
				);
    port(
         CLK : in  std_logic;
         RESET : in  std_logic;
         RBCP_ACT : in  std_logic;
         RBCP_ADDR : in  std_logic_vector(31 downto 0);
         RBCP_WE : in  std_logic;
         RBCP_WD : in  std_logic_vector(7 downto 0);
         RBCP_ACK : out  std_logic;
         ADDR : out  std_logic_vector(G_ADDR_WIDTH - 1 downto 0);
         WE : out  std_logic;
         WD : out  std_logic_vector(7 downto 0)
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
   --signal ADDR : std_logic_vector(3 downto 0);
   signal ADDR : std_logic_vector(1 downto 0);
   signal WE : std_logic;
   signal WD : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant DELAY : time := CLK_period*0.2;

begin

	-- Instantiate the Unit Under Test (UUT)
   uut: RBCP_Receiver
	generic map(
			G_ADDR => X"00000001",
			G_LEN => 3,
			G_ADDR_WIDTH => 2
			)
	port map (
          CLK => CLK,
          RESET => RESET,
          RBCP_ACT => RBCP_ACT,
          RBCP_ADDR => RBCP_ADDR,
          RBCP_WE => RBCP_WE,
          RBCP_WD => RBCP_WD,
          RBCP_ACK => RBCP_ACK,
          ADDR => ADDR,
          WE => WE,
          WD => WD
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

	procedure write_data(
		addr : std_logic_vector(31 downto 0);
		data : std_logic_vector(7 downto 0)
		) is
	begin
		RBCP_ACT <= '1' after DELAY;
		wait for CLK_period;

		RBCP_WE <= '1' after DELAY;
		RBCP_ADDR <= addr after DELAY;
		RBCP_WD <= data after DELAY;
		wait for CLK_period;

		RBCP_WE <= '0' after DELAY;
		RBCP_ADDR <= (others => '0') after DELAY;
		RBCP_WD <= (others => '0') after DELAY;
		wait for CLK_period;

		RBCP_ACT <= '0' after DELAY;
	end procedure;

   begin
		reset_uut;
		wait for CLK_period;

        write_data(X"00000003", X"05");
		write_data(X"00000001", X"01");
		write_data(X"00000002", X"23");
		--write_data(X"00000010", X"45");
		--write_data(X"00000011", X"67");
		--write_data(X"00000012", X"89");


      wait;
   end process;

end;
