library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Given an ASCII input, outputs...
-- 0 - unknown char         (< 32 , > 126)
-- 1 - uppercase letter     (65 - 90)
-- 2 - lowercase letter     (97 - 122)
-- 3 - numbers              (48 - 57)
-- 4 - symbols              (32 - 47, 58 - 64, 91 - 96, and 123 - 126)

entity classification_engine is
    generic ( D_WIDTH: natural := 8;
              ADDR_WIDTH: natural := 8);
    port(clk, reset, rx_full, tx_full: in std_logic;
         write_enable: out std_logic;
         data_in: in std_logic_vector(D_WIDTH - 1 downto 0);
         data_out: out std_logic_vector(D_WIDTH - 1 downto 0);
         max_addr: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
         read_addr, write_addr: out std_logic_vector(ADDR_WIDTH - 1 downto 0));
end classification_engine;

architecture Behavioral of classification_engine is

    signal data_reg, data_next: std_logic_vector(D_WIDTH - 1 downto 0) := (others=>'0');
    signal read_addr_reg, read_addr_next: std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others=>'0');
    signal write_addr_reg, write_addr_next: std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others=>'0');
    signal write_enable_reg, write_enable_next, enable: std_logic := '0';

begin

    process(clk, reset)
    begin
        if (reset='1') then
            data_reg <= (others=>'0');
            read_addr_reg <= (others=>'0');
            write_addr_reg <= (others=>'0');
            write_enable_reg <= '0';
        elsif (clk'event and clk='1') then
            data_reg <= data_next;
            read_addr_reg <= read_addr_next;
            write_addr_reg <= write_addr_next;
            write_enable_reg <= write_enable_next;
        end if;
    
    end process;
    
    classifying: process(data_in)
    begin
        -- Unknown ASCII Range (< 32, > 126) - 0.
        if((to_integer(unsigned(data_in)) < 32) or (to_integer(unsigned(data_in)) > 126)) then
                data_next <= std_logic_vector(to_unsigned(0, D_WIDTH));
                
        -- Uppercase letter ASCII Range (65 - 90) - 1
        elsif((to_integer(unsigned(data_in)) >= 65) and (to_integer(unsigned(data_in)) <= 90)) then
                data_next <= std_logic_vector(to_unsigned(1, D_WIDTH));  
                
        -- Lowercase ASCII Range (97 - 122) - 2
        elsif(((to_integer(unsigned(data_in)) >= 97) and (to_integer(unsigned(data_in)) <= 122))) then
                data_next <= std_logic_vector(to_unsigned(2, D_WIDTH));  
                
        -- Number ASCII Range (48 - 57) - 3
        elsif((to_integer(unsigned(data_in)) >= 48) and (to_integer(unsigned(data_in)) <= 57)) then
                data_next <= std_logic_vector(to_unsigned(3, D_WIDTH));  
                
        -- Symbol ASCII Range (32 - 47, 58 - 64, 91 - 96, and 123 - 126) - 4
        elsif(((to_integer(unsigned(data_in)) >= 32) and (to_integer(unsigned(data_in)) <= 47))
        or ((to_integer(unsigned(data_in)) >= 58) and (to_integer(unsigned(data_in)) <= 64))
        or ((to_integer(unsigned(data_in)) >= 91) and (to_integer(unsigned(data_in)) <= 96))
        or ((to_integer(unsigned(data_in)) >= 123) and (to_integer(unsigned(data_in)) <= 126))) then
                data_next <= std_logic_vector(to_unsigned(4, D_WIDTH));  
        end if;
        
    end process;
    
    read_addr_next <= std_logic_vector(unsigned(read_addr_reg) + 1) when (unsigned(read_addr_reg) < unsigned(max_addr))
                      else max_addr when unsigned(read_addr_reg) > unsigned(max_addr) 
                      else read_addr_reg;
                      
    write_addr_next <= std_logic_vector(unsigned(write_addr_reg) + 1) when (unsigned(write_addr_reg) < unsigned(read_addr_next))
                       else read_addr_next when unsigned(write_addr_reg) > unsigned(read_addr_next) 
                       else write_addr_reg;
                      
    write_enable_next <= '1' when unsigned(write_addr_next) > unsigned(write_addr_reg) 
                          else '0';
    
    -- output logic
    data_out <= data_reg;
    read_addr <= read_addr_reg;
    write_addr <= write_addr_reg;
    write_enable <= write_enable_reg;

end Behavioral;
