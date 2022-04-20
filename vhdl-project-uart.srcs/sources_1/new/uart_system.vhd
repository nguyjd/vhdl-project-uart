library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_system is
    port (sysclk: in std_logic;
          btn: in std_logic_vector(0 downto 0);
          led: out std_logic_vector(0 downto 0));
end uart_system;

architecture Behavioral of uart_system is

    component baud_rate_generator is 
        port(clk, reset: in std_logic;  
            tick: out std_logic  
        ); 
    end component;
    
    signal temp : integer := 0;
    signal tick : std_logic := '0';

begin

    UUT : baud_rate_generator port map (clk => sysclk, reset => btn(0), tick => tick);
    
    process(tick)
    begin
    
        if (tick'event and tick = '1') then
            temp <= temp + 1;
        end if;
        
        if temp >= 1000000 then
        
            led(0) <= '1';
            
        else
            led(0) <= '0';
        end if;
    
    end process;

end Behavioral;
