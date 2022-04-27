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
              write_address : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
              read_address : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
              data_in : in std_logic_vector(D_WIDTH - 1 downto 0);
              data_out : out std_logic_vector(D_WIDTH - 1 downto 0));
    end component;
    
    signal clk, write_enable: std_logic := '0';
    signal write_address, read_address: std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal data_in, data_out: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');

    -- Clock Period 
    constant Tclk: time := 20 ns;
    
    signal counter : unsigned(D_WIDTH - 1 downto 0) := (others => '0');

begin

    ram : single_port_ram port map ( clk => clk, 
                                     write_enable => write_enable,
                                     write_address => write_address,
                                     read_address => read_address,
                                     data_in => data_in,
                                     data_out => data_out);
                                     
                                     
    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        counter <= counter + 1;
        wait for Tclk/2;
    
    end process;
    
    process 
    begin
        
        wait for Tclk/2;
        
        -- Enable writing.
        write_enable <= '1';
        
        -- Write 16 bytes to ram.
        for i in 0 to 15 loop
        
            write_address <= std_logic_vector(counter + 127);
            data_in <= std_logic_vector(counter);
            wait for Tclk;
            
        end loop;
        
        -- Disable writing to ram
        write_enable <= '0';
        -- Reset the counter
        wait for 8*Tclk;
        
        -- Read the 16 data from the ram.
        for i in 0 to 15 loop
        
            read_address <= std_logic_vector(counter + 127 - 24);
            wait for Tclk;
            
        end loop;
        
        wait;
    
    end process;


end Behavioral;
