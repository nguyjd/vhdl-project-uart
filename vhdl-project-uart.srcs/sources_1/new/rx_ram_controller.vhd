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

    signal write_enable_reg, write_next: std_logic := '0';
    signal rx_read_reg, read_next: std_logic := '0';
    signal addr_pointer, addr_next: unsigned(ADDR_WIDTH - 1 downto 0) := (others => '0');

begin

    -- D FF Memory
    process(clk, reset)
    begin
    
        if (reset = '1') then
            write_enable_reg <= '0';
            rx_read_reg <= '0';
            addr_pointer <= (others => '0');
        elsif (clk'event and clk = '1') then
            write_enable_reg <= write_next;
            rx_read_reg <= read_next;
            addr_pointer <= addr_next;
        end if;
    
    end process;

    write_next <= '1' when rx_empty = '0' else '0';
    read_next <= '1' when rx_empty = '0' else '0';
    addr_next <= addr_pointer + 1 when write_enable_reg = '1' else addr_pointer;
    
    rx_read <= rx_read_reg;
    write_enable <= write_enable_reg;
    write_addr <= std_logic_vector(addr_pointer);

end Behavioral;
