library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_receiver_subsystem_TB is
    generic(D_WIDTH: natural := 8);
end uart_receiver_subsystem_TB;

architecture Behavioral of uart_receiver_subsystem_TB is

    component uart_receiver is
        port(clk, rx, s_tick, reset: in std_logic;  
         rx_done_tick: out std_logic;
         data_out: out std_logic_vector(D_WIDTH - 1 downto 0)
        ); 
    end component;
    
    component fifo_buffer is
        Port (  clk, reset, write_req, read_req : in std_logic;
                data_out : out std_logic_vector (D_WIDTH - 1 downto 0);
                data_in : in std_logic_vector (D_WIDTH - 1 downto 0);
                full, empty : out std_logic);
    end component;

    signal rx, s_tick, rx_done_tick: std_logic := '0';
    
    signal clk, reset, read_req, full, empty : std_logic := '0';
    signal data_out, rx_data, data_in: std_logic_vector (D_WIDTH - 1 downto 0) := (others => '0');
    
    -- Clock Period 
    constant Tclk: time := 2 ns;

begin

    UUT1 : uart_receiver port map (clk => clk, 
                                  rx => rx,
                                  s_tick => s_tick,
                                  reset => reset,
                                  rx_done_tick => rx_done_tick,
                                  data_out => rx_data);
                                  
                                  
    UUT2 : fifo_buffer port map (clk => clk, 
                                reset => reset,
                                write_req => rx_done_tick,
                                read_req => read_req,
                                data_out => data_out,
                                data_in => rx_data,
                                full => full,
                                empty => empty);
    
    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        wait for Tclk/2;
    
    end process;
    
    process
    begin
    
        reset <= '1';
        
        wait for 2 ns;
        
        reset <= '0';
        
        wait for 2 ns;
        
        s_tick <= '1';
        rx <= '0';
        
        wait for 14 ns;
        
        -- 00111000 
       
        rx <= '0';
        wait for 32 ns;
        rx <= '0';
        wait for 32 ns;
        rx <= '0';
        wait for 32 ns;
        rx <= '1';
        wait for 32 ns;
        rx <= '1';
        wait for 32 ns;
        rx <= '1';
        wait for 32 ns;
        rx <= '0';
        wait for 32 ns;
        rx <= '0';
        wait for 32 ns;
        rx <= '1';
        wait for 100 ns;
        
        s_tick <= '1';
        rx <= '0';
        
        wait for 14 ns;
        
        -- 10010100
        
        rx <= '0';
        wait for 32 ns;
        rx <= '0';
        wait for 32 ns;
        rx <= '1';
        wait for 32 ns;
        rx <= '0';
        wait for 32 ns;
        rx <= '1';
        wait for 32 ns;
        rx <= '0';
        wait for 32 ns;
        rx <= '0';
        wait for 32 ns;
        rx <= '1';
        wait for 32 ns;
        rx <= '1';
        wait for 101 ns;
        
        read_req <= '1';
        wait for 2 ns;
        
        read_req <= '0';
        wait for 2 ns;
        
        read_req <= '1';
        wait for 2 ns;
        
        read_req <= '0';
        wait;
    
    end process;


end Behavioral;
