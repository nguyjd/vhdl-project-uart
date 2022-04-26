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

    -- Clock Period 
    constant Tclk: time := 20 ns;

begin

    UUT : classification_engine port map (clk => clk, reset => reset, data_in => data_in, data_out => data_out);
    --20ns Period CLK
    
    clockProcess : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR Tclk/2;
        clk <= '1';
        WAIT FOR Tclk/2;
    END PROCESS;
    
    --Reset Process
    resetProcess : PROCESS
    BEGIN
        reset <= '1';
        wait for 8*Tclk;
        
        reset <= '0';
        wait;
        
    END PROCESS;
    
    --enable <= '1';
    dataProcess : PROCESS
    BEGIN
        
        -- Wait for reset.
        wait for 8*Tclk;
        
        data_in <= std_logic_vector(to_unsigned(0, 8));
        wait for 3*Tclk;    
        
        --Uppper
        data_in <= std_logic_vector(to_unsigned(70, 8));
        wait for 3*Tclk;
        
        --Lower
        data_in <= std_logic_vector(to_unsigned(100, 8));
        wait for 3*Tclk;
        
        --Num
        data_in <= std_logic_vector(to_unsigned(50, 8));
        wait for 3*Tclk;
        
        --Symb
        data_in <= std_logic_vector(to_unsigned(10, 8));
        wait for 3*Tclk;
    
    end process;

end Behavioral;
