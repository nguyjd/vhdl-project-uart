library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity single_port_ram is
    generic ( D_WIDTH: natural := 8;
              ADDR_WIDTH: natural := 8);
    port (clk : in std_logic;
          write_enable : in std_logic;
          write_address : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
          read_address : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
          data_in : in std_logic_vector(D_WIDTH - 1 downto 0);
          data_out : out std_logic_vector(D_WIDTH - 1 downto 0));
end single_port_ram;

architecture Behavioral of single_port_ram is
    type ram_block is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector (D_WIDTH - 1 downto 0);
    signal ram : ram_block := (others => (others => '0'));
begin

    process (clk)
    begin
        if rising_edge(clk) then
        
            if (write_enable = '1') then
                ram(to_integer(unsigned(write_address))) <= data_in;
            end if;
            
        end if;
        
    end process;
    
    data_out <= ram(to_integer(unsigned(read_address)));

end Behavioral;
