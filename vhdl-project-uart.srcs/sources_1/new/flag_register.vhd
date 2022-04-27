library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flag_register is
    generic(D_WIDTH: natural := 0);
    port(
        clk, clr_flag, wr : in std_logic;
        set_flag : in std_logic_vector(D_WIDTH downto 0);
        flag : out std_logic_vector(D_WIDTH downto 0));
end flag_register;

architecture Behavioral of flag_register is
signal flag_reg, flag_next : std_logic_vector(D_WIDTH downto 0):=(others=>'0');

begin

    process(clk, clr_flag)
    begin
        if (clr_flag='1') then
            flag_reg <= (others=>'0');
            elsif (clk'event and clk='1') then
            flag_reg <= flag_next;
        end if;
    end process; 

    flag_next <= set_flag when wr ='1' else flag_reg;

-- output logic
    flag <= flag_reg;


end Behavioral;
