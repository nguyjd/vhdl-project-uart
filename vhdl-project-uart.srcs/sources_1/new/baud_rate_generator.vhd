library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity baud_rate_generator is
    generic(baud_rate: positive := 9600;
            clk_freq: positive := 50000000;
            sample_rate: positive := 16);
    port(clk: in std_logic;  
         tick: out std_logic  
    ); 
end baud_rate_generator;

architecture Behavioral of baud_rate_generator is

constant mod_m : positive := clk_freq/(sample_rate * baud_rate);
signal r_next, r_reg, r_inc: positive := 0;

begin

-- D FF Memory
process(clk)
begin

    if (clk'event and clk = '1') then
        r_reg <= r_next;
    end if;

end process;

-- Next-State Logic
r_inc <= r_reg + 1;
r_next <= 0 when (mod_m >= r_inc) else r_inc;

-- Output
tick <= '1' when r_reg = mod_m else
        '0';

end Behavioral;
