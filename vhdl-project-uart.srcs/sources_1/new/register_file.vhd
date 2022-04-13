library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    generic(D_WIDTH: natural := 8;
            ADDR_WIDTH: natural := 5;
            REGISTERS_AMOUNT: natural := 32);
    Port ( read_data : out std_logic_vector (D_WIDTH - 1 downto 0);
           write_data : in std_logic_vector (D_WIDTH - 1 downto 0);
           clk, reset, write_enable : in std_logic;
           write_addr : in std_logic_vector (ADDR_WIDTH - 1 downto 0);
           read_addr : in std_logic_vector (ADDR_WIDTH - 1 downto 0));
end register_file;

architecture Behavioral of register_file is
    
    type registers is array(0 to REGISTERS_AMOUNT - 1) of std_logic_vector (D_WIDTH - 1 downto 0);
    signal registerfile : registers := (others => (others => '0'));
    
    signal read_reg, read_next: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');
    
begin

    process (clk, reset, read_addr, write_enable, write_addr, write_data) 
    begin
        
        -- Normal reset
        if (reset = '1') then
            registerfile <= (others => (others => '0'));
            read_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            read_reg <= read_next;
            
            if (write_enable = '1') then
                registerfile(TO_INTEGER(unsigned(write_addr))) <= write_data;
            end if;
            
        end if;
        -- Read the reg at read_addr.
        read_next <= registerfile(TO_INTEGER(unsigned(read_addr)));
    end process;
    
-- Output Logic
read_data <= read_reg;

end Behavioral;
