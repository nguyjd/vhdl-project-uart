library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_system is
    generic(D_WIDTH: natural := 8);
    port (sysclk: in std_logic;
          btn: in std_logic_vector(0 downto 0);
          led: out std_logic_vector(0 downto 0));
end uart_system;

architecture Behavioral of uart_system is

    component baud_rate_generator is 
        port(clk, reset: in std_logic;  
            tick: out std_logic  
        ); 
    end component;
    
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
    
    component uart_transmitter is
        port(clk, reset: in std_logic;
         tx_start: in std_logic;
         s_tick: in std_logic;
         data_in: in std_logic_vector(D_WIDTH - 1 downto 0);
         tx_done_tick: out std_logic;
         tx: out std_logic);
    end component;
    
    signal rx, tick, rx_done_tick, tx_start, tx_done_tick: std_logic := '0';
    
    signal clk, reset, read_req, full, empty : std_logic := '0';
    signal data_out, rx_data, data_in: std_logic_vector (D_WIDTH - 1 downto 0) := (others => '0');

begin

    baud : baud_rate_generator port map (clk => sysclk, reset => reset, tick => tick);
    
    uart_rx : uart_receiver port map (clk => sysclk, 
                                      rx => rx,
                                      s_tick => tick,
                                      reset => reset,
                                      rx_done_tick => rx_done_tick,
                                      data_out => rx_data);
     
    rx_fifo : fifo_buffer port map (clk => sysclk, 
                                    reset => reset,
                                    write_req => rx_done_tick,
                                    read_req => read_req,
                                    data_out => data_out,
                                    data_in => rx_data,
                                    full => full,
                                    empty => empty);
                                    
    reset <= btn(0);

end Behavioral;
