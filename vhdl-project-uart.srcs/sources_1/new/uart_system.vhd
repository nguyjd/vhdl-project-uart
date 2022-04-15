library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_system is
    port (sysclk: in std_logic;
          btn: in std_logic_vector(0 downto 0);
          jc: out std_logic_vector(0 downto 0));
end uart_system;

architecture Behavioral of uart_system is

    component baud_rate_generator is 
        port(clk, reset: in std_logic;  
            tick: out std_logic  
        ); 
    end component;

begin

    UUT : baud_rate_generator port map (clk => sysclk, reset => btn(0), tick => jc(0));

end Behavioral;
