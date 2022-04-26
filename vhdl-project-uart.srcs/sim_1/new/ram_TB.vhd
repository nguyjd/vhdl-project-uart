library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_TB is
    generic ( D_WIDTH: natural := 8;
              ADDR_WIDTH: natural := 8);
end ram_TB;

architecture Behavioral of ram_TB is

    component single_port_ram is
        port (clk : in std_logic;
              write_enable : in std_logic;
              data_address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
              data_in : in std_logic_vector(D_WIDTH - 1 downto 0);
              data_out : out std_logic_vector(D_WIDTH - 1 downto 0));
    end component;

begin


end Behavioral;
