library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity baud_rate_gen_TB is
end baud_rate_gen_TB;

architecture Behavioral of baud_rate_gen_TB is

    component baud_rate_generator is 
        port(clk, reset: in std_logic;  
            tick: out std_logic  
        ); 
    end component;
    
    signal clk, reset, tick: std_logic := '0';
    
    -- Clock Period 
    constant Tclk: time := 20 ns;

begin

    UUT : baud_rate_generator port map (clk => clk, reset => reset, tick => tick);

    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        wait for Tclk/2;
    
    end process;


end Behavioral;
