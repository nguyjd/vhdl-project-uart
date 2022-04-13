library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_TB is
    generic(D_WIDTH: natural := 8;
            ADDR_WIDTH: natural := 5;
            REGISTERS_AMOUNT: natural := 32);
end register_file_TB;

architecture Behavioral of register_file_TB is

    component register_file is
        Port ( read_data : out std_logic_vector (D_WIDTH - 1 downto 0);
               write_data : in std_logic_vector (D_WIDTH - 1 downto 0);
               clk, reset, write_enable : in std_logic;
               write_addr : in std_logic_vector (ADDR_WIDTH - 1 downto 0);
               read_addr : in std_logic_vector (ADDR_WIDTH - 1 downto 0));
    end component;

    signal clk, reset, write_enable: std_logic := '0';
    signal write_addr, read_addr: std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal read_data, write_data: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');

    -- Clock Period 
    constant Tclk: time := 20 ns;

begin

    UUT : register_file port map (clk => clk, 
                                  reset => reset,
                                  write_enable => write_enable,
                                  write_addr => write_addr,
                                  read_addr => read_addr,
                                  read_data => read_data,
                                  write_data => write_data);
                                  
    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        wait for Tclk/2;
    
    end process;
    
    process
    begin
        
        wait for 20 ns;
        
        write_addr <= "00101";
        read_addr <= "00101";
        write_enable <= '0';
        write_data <= "00110001";
        
        wait for 20 ns;
        
        write_enable <= '1';
        
        wait for 20 ns;
        
        write_addr <= "00000";
        write_data <= "00110111";
        
        wait for 20 ns;
        
        read_addr <= "00000";
        
        wait;
        
    
    end process;


end Behavioral;
