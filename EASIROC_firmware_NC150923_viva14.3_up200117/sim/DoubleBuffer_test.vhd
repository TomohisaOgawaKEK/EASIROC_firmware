--------------------------------------------------------------------------------
--! @file   DoubleBuffer_test.vhd
--! @brief  Test bench of DoubleBuffer.vhd
--! @author Takehiro Shiozaki
--! @date   2013-11-06
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity DoubleBuffer_test is
end DoubleBuffer_test;

architecture behavior of DoubleBuffer_test is

    component DoubleBuffer
    generic(
        G_WIDTH : integer;
        G_DEPTH : integer
    );
    port(
        RESET : in  std_logic;
        WCLK : in  std_logic;
        DIN : in  std_logic_vector(19 downto 0);
        WADDR : in  std_logic_vector(5 downto 0);
        WE : in  std_logic;
        WCOMP : in  std_logic;
        DEC_WPTR : in std_logic;
        FULL : out  std_logic;
        RCLK : in  std_logic;
        DOUT : out  std_logic_vector(19 downto 0);
        RADDR : in  std_logic_vector(5 downto 0);
        RCOMP : in  std_logic;
        EMPTY : out  std_logic
    );
    end component;


    --Inputs
    signal RESET : std_logic := '0';
    signal WCLK : std_logic := '0';
    signal DIN : std_logic_vector(19 downto 0) := (others => '0');
    signal WADDR : std_logic_vector(5 downto 0) := (others => '0');
    signal WE : std_logic := '0';
    signal WCOMP : std_logic := '0';
    signal DEC_WPTR : std_logic := '0';
    signal RCLK : std_logic := '0';
    signal RADDR : std_logic_vector(5 downto 0) := (others => '0');
    signal RCOMP : std_logic := '0';

    --Outputs
    signal FULL : std_logic;
    signal DOUT : std_logic_vector(19 downto 0);
    signal EMPTY : std_logic;

    -- Clock period definitions
    constant WCLK_period : time := 29 ns;
    constant RCLK_period : time := 13 ns;
    constant DELAY : time := 2 ns;

begin

    uut: DoubleBuffer
    generic map(
        G_WIDTH => 20,
        G_DEPTH => 6
    )
    port map (
        RESET => RESET,
        WCLK => WCLK,
        DIN => DIN,
        WADDR => WADDR,
        WE => WE,
        WCOMP => WCOMP,
        DEC_WPTR => DEC_WPTR,
        FULL => FULL,
        RCLK => RCLK,
        DOUT => DOUT,
        RADDR => RADDR,
        RCOMP => RCOMP,
        EMPTY => EMPTY
    );

    process
    begin
        WCLK <= '0';
        wait for WCLK_period/2;
        WCLK <= '1';
        wait for WCLK_period/2;
    end process;

    process
    begin
        RCLK <= '0';
        wait for RCLK_period/2;
        RCLK <= '1';
        wait for RCLK_period/2;
    end process;


    process

    procedure reset_uut is
    begin
        RESET <= '1';
        wait until WCLK'event and WCLK = '1';
        wait for WCLK_period;
        RESET <= '0' after DELAY;
        wait for WCLK_period;
    end procedure;

    procedure write_data
        (addr : std_logic_vector(5 downto 0);
        data : std_logic_vector(19 downto 0)
        ) is
    begin
        wait until WCLK'event and WCLK = '1';

        DIN <= data after DELAY;
        WADDR <= addr after DELAY;
        WE <= '1' after DELAY;

        wait for WCLK_period;

        DIN <= (others => '0') after DELAY;
        WADDR <= (others => '0') after DELAY;
        WE <= '0' after DELAY;

        wait for WCLK_period;
    end procedure;

    procedure write_complete is
    begin
        wait until WCLK'event and WCLK = '1';
        WCOMP <= '1' after DELAY;
        wait for WCLK_period;
        WCOMP <= '0' after DELAY;
        wait for WCLK_period;
    end procedure;

    procedure read_data
        (addr : std_logic_vector(5 downto 0)
        ) is
    begin
        wait until RCLK'event and RCLK = '1';
        RADDR <= addr after DELAY;
        wait for RCLK_period;
    end procedure;

    procedure read_complete is
    begin
        wait until RCLK'event and RCLK = '1';
        RCOMP <= '1' after DELAY;
        wait for RCLK_period;
        RCOMP <= '0' after DELAY;
        wait for RCLK_period;
    end procedure;

    procedure decriment_wptr is
    begin
        wait until WCLK'event and WCLK = '1';
        DEC_WPTR <= '1' after DELAY;
        wait for WCLK_period;
        DEC_WPTR <= '0' after DELAY;
        wait for WCLK_period;
    end procedure;

    begin
        reset_uut;

        write_data(conv_std_logic_vector(0, 6), X"01234");
        write_data(conv_std_logic_vector(1, 6), X"6789A");
        write_data(conv_std_logic_vector(2, 6), X"CDEF0");
        write_data(conv_std_logic_vector(3, 6), X"23456");
        write_data(conv_std_logic_vector(4, 6), X"89ABC");
        write_data(conv_std_logic_vector(5, 6), X"EF012");
        write_complete;

        read_data(conv_std_logic_vector(0, 6));
        read_data(conv_std_logic_vector(1, 6));
        read_data(conv_std_logic_vector(2, 6));
        read_data(conv_std_logic_vector(3, 6));
        read_data(conv_std_logic_vector(4, 6));
        read_data(conv_std_logic_vector(5, 6));
        read_complete;

        write_data(conv_std_logic_vector(0, 6), X"FEDCB");
        write_data(conv_std_logic_vector(1, 6), X"98765");
        write_data(conv_std_logic_vector(2, 6), X"3210F");
        write_data(conv_std_logic_vector(3, 6), X"DCBA9");
        write_data(conv_std_logic_vector(4, 6), X"76543");
        write_data(conv_std_logic_vector(5, 6), X"10FED");
        write_complete;
        decriment_wptr;

        write_data(conv_std_logic_vector(0, 6), X"FEDCB");
        write_data(conv_std_logic_vector(1, 6), X"98765");
        write_data(conv_std_logic_vector(2, 6), X"3210F");
        write_data(conv_std_logic_vector(3, 6), X"DCBA9");
        write_data(conv_std_logic_vector(4, 6), X"76543");
        write_data(conv_std_logic_vector(5, 6), X"10FED");
        write_complete;

        read_data(conv_std_logic_vector(0, 6));
        read_data(conv_std_logic_vector(1, 6));
        read_data(conv_std_logic_vector(2, 6));
        read_data(conv_std_logic_vector(3, 6));
        read_data(conv_std_logic_vector(4, 6));
        read_data(conv_std_logic_vector(5, 6));
        read_complete;

        write_complete;
        write_complete;

        read_complete;
        read_complete;
        wait;
    end process;

end;
