library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_controller_TB is
    generic(ADDR_WIDTH: natural := 5);
end fifo_controller_TB;

architecture Behavioral of fifo_controller_TB is

    component fifo_controller is
        Port ( clk, reset, write_req, read_req : in std_logic;
           full, empty : out std_logic;
           write_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0);
           read_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0));
    end component;

    signal clk, reset, write_req, read_req, full, empty: std_logic := '0';
    signal write_addr, read_addr: std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
    
    -- Clock Period 
    constant Tclk: time := 20 ns;

begin

    UUT : fifo_controller port map (clk => clk, 
                                    reset => reset,
                                    write_req => write_req,
                                    read_req => read_req,
                                    read_addr => read_addr,
                                    full => full,
                                    empty => empty,
                                    write_addr => write_addr);
                                    
    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        wait for Tclk/2;
    
    end process;
    
    process
    begin
    
        wait for 30 ns;
    
        write_req <= '1';
        wait for 800 ns;
        
        write_req <= '0';
        read_req <= '1';
        wait;
    
    end process;


end Behavioral;
