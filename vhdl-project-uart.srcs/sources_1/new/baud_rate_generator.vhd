library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

entity baud_rate_generator is
    generic(baud_rate: natural := 9600;
            clk_freq: natural := 50000000;
            sample_rate: natural := 16);
    port(clk, reset: in std_logic;  
         tick: out std_logic  
    ); 
end baud_rate_generator;

architecture Behavioral of baud_rate_generator is

constant mod_m : natural := clk_freq/(sample_rate * baud_rate);
constant reg_width : natural := natural(ceil(log2(real(mod_m))));

signal r_next, r_reg, r_inc: unsigned(reg_width - 1 downto 0) := (others => '0');

begin

-- D FF Memory
process(clk, reset)
begin
    
    if (reset = '1') then
        r_reg <= (others => '0');
    elsif (clk'event and clk = '1') then
        r_reg <= r_next;
    end if;

end process;

-- Next-State Logic
r_inc <= r_reg + 1;
r_next <= (others => '0') when (mod_m <= r_inc) else r_inc;

-- Output
tick <= '1' when (mod_m <= r_inc) else
        '0';

end Behavioral;
