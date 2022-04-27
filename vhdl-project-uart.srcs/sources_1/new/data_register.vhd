library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_register is
    generic(D_WIDTH: natural := 0);
    port(
        clk, reset, wr : in std_logic;
        data_in : in std_logic_vector(D_WIDTH downto 0);
        data_out : out std_logic_vector(D_WIDTH downto 0));
end data_register;

architecture Behavioral of data_register is
signal data_reg, data_next : std_logic_vector(D_WIDTH downto 0):=(others=>'0');

begin

    process(clk, reset)
    begin
        if (reset='1') then
            data_reg <= (others=>'0');
            elsif (clk'event and clk='1') then
            data_reg <= data_next;
        end if;
    end process; 

    data_next <= data_in when wr ='1' else data_reg;

-- output logic
    data_out <= data_reg;


end Behavioral;
