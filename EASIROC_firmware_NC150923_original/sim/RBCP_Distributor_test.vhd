--------------------------------------------------------------------------------
--! @file   RBCP_Distributor_test.vhd
--! @brief  Test bench of RBCP_Distributor_test.vhd
--! @author Takehiro Shiozaki
--! @date   2013-10-28
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity RBCP_Distributor_test is
end RBCP_Distributor_test;

architecture behavior of RBCP_Distributor_test is

    -- component Declaration for the Unit Under Test (UUT)

    component RBCP_Distributor
    port(
         RD_IN1 : in  std_logic_vector(7 downto 0);
         ACK_IN1 : in  std_logic;
         RD_IN2 : in  std_logic_vector(7 downto 0);
         ACK_IN2 : in  std_logic;
         RD_OUT : out  std_logic_vector(7 downto 0);
         ACK_OUT : out  std_logic
        );
    end component;


   --Inputs
   signal RD_IN1 : std_logic_vector(7 downto 0) := (others => '0');
   signal ACK_IN1 : std_logic := '0';
   signal RD_IN2 : std_logic_vector(7 downto 0) := (others => '0');
   signal ACK_IN2 : std_logic := '0';

 	--Outputs
   signal RD_OUT : std_logic_vector(7 downto 0);
   signal ACK_OUT : std_logic;
   -- No clocks detected in port list. Replace <clock> below with
   -- appropriate port name


begin

	-- Instantiate the Unit Under Test (UUT)
   uut: RBCP_Distributor port map (
          RD_IN1 => RD_IN1,
          ACK_IN1 => ACK_IN1,
          RD_IN2 => RD_IN2,
          ACK_IN2 => ACK_IN2,
          RD_OUT => RD_OUT,
          ACK_OUT => ACK_OUT
        );

   -- Stimulus process
   stim_proc: process
   begin
		RD_IN1 <= X"12";
		RD_IN2 <= X"34";
		wait for 100ns;

		ACK_IN1 <= '1';
		ACK_IN2 <= '0';
		wait for 100ns;

		ACK_IN1 <= '0';
		ACK_IN2 <= '1';
		wait for 100ns;

		ACK_IN1 <= '1';
		ACK_IN2 <= '1';

      wait;
   end process;

end;
