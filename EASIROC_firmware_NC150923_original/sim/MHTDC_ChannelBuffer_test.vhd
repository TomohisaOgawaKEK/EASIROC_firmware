--------------------------------------------------------------------------------
--! @file   MHTDC_ChannelBuffer_test.vhd
--! @brief  Test bench of MHTDC_ChannelBuffer.vhd
--! @author Takehiro Shiozaki
--! @date   2014-06-08
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity MHTDC_ChannelBuffer_test is
end MHTDC_ChannelBuffer_test;

architecture behavior of MHTDC_ChannelBuffer_test is
    component MHTDC_ChannelBuffer is
        port(
            CLK : in std_logic;
            DIN : in std_logic_vector(45 downto 0);
            WE : in std_logic;
            DOUT : out std_logic_vector(45 downto 0);
            RE : in std_logic;
            EMPTY : out std_logic;
            CLEAR : in std_logic
        );
    end component;

    signal CLK : std_logic := '0';
    signal DIN : std_logic_vector(45 downto 0) := (others => 'X');
    signal WE : std_logic := '0';
    signal DOUT : std_logic_vector(45 downto 0);
    signal RE : std_logic := '0';
    signal EMPTY : std_logic;
    signal CLEAR : std_logic := '1';

    constant CLK_period : time := 8 ns;
    constant DELAY : time := 1 ns;
begin

    uut: MHTDC_ChannelBuffer
    port map(
        CLK => CLK,
        DIN => DIN,
        WE => WE,
        DOUT => DOUT,
        RE => RE,
        EMPTY => EMPTY,
        CLEAR => CLEAR
    );

    process
    begin
        CLK <= '0';
        wait for CLK_period / 2;
        CLK <= '1';
        wait for CLK_period / 2;
    end process;

    process
        procedure write_word(word: in integer) is
        begin
            DIN <= conv_std_logic_vector(word, 46) after DELAY;
            wait for CLK_period;
        end procedure;

        procedure read_words(number_of_words: in integer) is
        begin
            RE <= '1' after DELAY;
            wait for CLK_period * number_of_words;
            RE <= '0' after DELAY;
        end procedure;
    begin
        CLEAR <= '1';
        wait for 100 ns;
        CLEAR <= '0' after DELAY;
        wait for CLK_period;

        wait until CLK'event and CLK = '1';
        WE <= '1' after DELAY;
        write_word(1);
        write_word(2);
        DIN <= (others => 'X') after DELAY;
        WE <= '0' after DELAY;

        wait for CLK_period;
        read_words(2);

        wait until CLK'event and CLK = '1';
        WE <= '1' after DELAY;
        write_word(1);
        write_word(2);
        write_word(3);
        write_word(4);
        write_word(5);
        write_word(6);
        write_word(7);
        write_word(8);
        write_word(9);
        write_word(10);
        write_word(11);
        write_word(12);
        write_word(13);
        write_word(14);
        write_word(15);
        write_word(16);
        write_word(17);
        write_word(18);
        write_word(19);
        write_word(20);
        write_word(21);
        write_word(22);
        write_word(23);
        write_word(24);
        write_word(25);
        DIN <= (others => 'X') after DELAY;
        WE <= '0' after DELAY;
        wait for CLK_period;
        read_words(16);

        wait;
    end process;
end behavior;
