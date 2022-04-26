library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Given an ASCII input, outputs...
-- 0 - unknown char         (< 0, > 255)
-- 1 - uppercase letter     (65 - 90)
-- 2 - lowercase letter     (97 - 122)
-- 3 - numbers              (48 - 57)
-- 4 - symbols              (0 - 47, 58 - 64, 91 - 96, and 123 - 255)

entity classification_engine is
    port(
        clk, reset : in std_logic;
        data_in : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(2 downto 0));
end classification_engine;

architecture Behavioral of classification_engine is

signal data_reg, data_next : std_logic_vector(2 downto 0) :=(others=>'0');

begin

process(clk, reset)
    begin
        if (reset='1') then
            data_reg <= (others=>'0');
            
        elsif (clk'event and clk='1') then
            data_reg <= data_next;              
        end if;
    
    end process;
    
    process(data_in)
        begin
        -- Unknown ASCII Range (< 0, > 255) - 0.
            if((to_integer(unsigned(data_in)) < 0) or (to_integer(unsigned(data_in)) > 255)) then
                data_next <= std_logic_vector(to_unsigned(0, 3));
                
        -- Uppercase letter ASCII Range (65 - 90) - 1
            elsif((to_integer(unsigned(data_in)) >= 65) and (to_integer(unsigned(data_in)) <= 90)) then
                data_next <= std_logic_vector(to_unsigned(1, 3));  
                
        -- Lowercase ASCII Range (97 - 122) - 2
            elsif(((to_integer(unsigned(data_in)) >= 97) and (to_integer(unsigned(data_in)) <= 122))) then
                data_next <= std_logic_vector(to_unsigned(2, 3));  
                
        -- Number ASCII Range (48 - 57) - 3
            elsif((to_integer(unsigned(data_in)) >= 48) and (to_integer(unsigned(data_in)) <= 57)) then
                data_next <= std_logic_vector(to_unsigned(3, 3));  
                
        -- Symbol ASCII Range (0 - 47, 58 - 64, 91 - 96, and 123 - 255) - 4
            elsif(((to_integer(unsigned(data_in)) >= 0) and (to_integer(unsigned(data_in)) <= 47))
            or ((to_integer(unsigned(data_in)) >= 58) and (to_integer(unsigned(data_in)) <= 64))
            or ((to_integer(unsigned(data_in)) >= 91) and (to_integer(unsigned(data_in)) <= 96))
            or ((to_integer(unsigned(data_in)) >= 123) and (to_integer(unsigned(data_in)) <= 255))) then
                data_next <= std_logic_vector(to_unsigned(4, 3));          
            end if;
                     
          end process;        
                  
-- output logic
    data_out  <= data_reg;

end Behavioral;
