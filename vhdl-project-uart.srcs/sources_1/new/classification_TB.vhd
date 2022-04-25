library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity classification_TB is
end classification_TB;

architecture Behavioral of classification_TB is

component classification_engine is
    port(
        clk, reset : in std_logic;
        data_in : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(2 downto 0));
end component;

signal clk, reset : std_logic := '0';
signal data_in: std_logic_vector(7 downto 0) := (others => '0');
signal data_out : std_logic_vector(2 downto 0) := (others => '0');

begin

UUT : classification_engine port map (clk => clk, reset => reset, data_in => data_in, data_out => data_out);
--20ns Period CLK
    clockProcess : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 10ns;
        clk <= '1';
        WAIT FOR 10ns;
    END PROCESS;
    
    --Reset Process
    resetProcess : PROCESS
    BEGIN
        reset <= '1';
        wait for 160ns;
        reset <= '0';
        WAIT FOR 600ns;
        reset <= '1';
        WAIT FOR 20ns;
        reset <= '0';
    END PROCESS;
    
    --enable <= '1';
    dataProcess : PROCESS
    BEGIN
    --Uppper
        data_in <= std_logic_vector(to_unsigned(70, 8));
        wait for 66ns;
    --Lower
        data_in <= std_logic_vector(to_unsigned(100, 8));
        wait for 66ns;
    --Num
        data_in <= std_logic_vector(to_unsigned(50, 8));
        wait for 66ns;
    --Symb
        data_in <= std_logic_vector(to_unsigned(10, 8));
        wait for 66ns;
    end process;

end Behavioral;
