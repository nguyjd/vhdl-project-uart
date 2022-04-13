library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_buffer_TB is
    generic(ADDR_WIDTH: natural := 5;
            D_WIDTH: natural := 8);
end fifo_buffer_TB;

architecture Behavioral of fifo_buffer_TB is

    component fifo_buffer is
        Port (  clk, reset, write_req, read_req : in std_logic;
                data_out : out std_logic_vector (D_WIDTH - 1 downto 0);
                data_in : in std_logic_vector (D_WIDTH - 1 downto 0);
                full, empty : out std_logic);
    end component;

    signal clk, reset, write_req, read_req, full, empty : std_logic := '0';
    signal data_out, data_in: std_logic_vector (D_WIDTH - 1 downto 0) := (others => '0');
    
    signal counter : unsigned(D_WIDTH - 1 downto 0) := (others => '0');

    -- Clock Period 
    constant Tclk: time := 20 ns;

begin

    UUT : fifo_buffer port map (clk => clk, 
                                reset => reset,
                                write_req => write_req,
                                read_req => read_req,
                                data_out => data_out,
                                data_in => data_in,
                                full => full,
                                empty => empty);

    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        data_in <= std_logic_vector(counter);
        counter <= counter + 1;
        wait for Tclk/2;
    
    end process;

    process 
    begin
        
        write_req <= '1';
    
        wait until (full = '1');
        
        write_req <= '0';
        read_req <= '1';
        --counter <= (others => '0');
        
        wait;
    
    end process;


end Behavioral;
