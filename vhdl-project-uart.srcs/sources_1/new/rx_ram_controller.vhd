library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rx_ram_controller is
    generic(ADDR_WIDTH: natural := 8);
    Port ( clk, reset, rx_empty: in std_logic;
           rx_read, write_enable : out std_logic;
           write_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0));
end rx_ram_controller;

architecture Behavioral of rx_ram_controller is

    signal rx_empty_reg, rx_empty_next: std_logic := '1';
    signal addr_inc_reg, addr_inc_next: std_logic := '1';
    signal addr_pointer, addr_next: unsigned(ADDR_WIDTH - 1 downto 0) := (others => '0');

begin

    -- D FF Memory
    process(clk, reset)
    begin
    
        if (reset = '1') then
            rx_empty_reg <= '1';
            addr_inc_reg <= '1';
            addr_pointer <= (others => '0');
        elsif (clk'event and clk = '1') then
            addr_pointer <= addr_next;
            rx_empty_reg <= rx_empty_next;
            addr_inc_reg <= addr_inc_next;
        end if;
    
    end process;
    
    rx_empty_next <= rx_empty;
    addr_inc_next <= rx_empty_reg;
    addr_next <= addr_pointer when addr_inc_next = '1' else 
                 addr_pointer + 1 when addr_inc_reg = '0' 
                 else addr_pointer;
    
    rx_read <= '1' when rx_empty_reg = '0' else '0';
    write_enable <= '1' when rx_empty_reg = '0' else '0';
    write_addr <= std_logic_vector(addr_pointer);

end Behavioral;
