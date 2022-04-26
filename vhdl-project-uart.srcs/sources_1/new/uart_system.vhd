library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_system is
    generic(D_WIDTH: natural := 8);
    port (clk, reset, rx, tx_start: in std_logic;
          rx_done, tx_done, tx: out std_logic;
          rx_data: out std_logic_vector(D_WIDTH - 1 downto 0);
          tx_data: in std_logic_vector(D_WIDTH - 1 downto 0));
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
    
    component uart_transmitter is
        port(clk, reset: in std_logic;
         tx_start: in std_logic;
         s_tick: in std_logic;
         data_in: in std_logic_vector(D_WIDTH - 1 downto 0);
         tx_done_tick: out std_logic;
         tx: out std_logic);
    end component;
    
    signal tick: std_logic := '0';

begin

    baud : baud_rate_generator port map (clk => clk, reset => reset, tick => tick);
    
    uart_rx : uart_receiver port map (clk => clk, 
                                      rx => rx,
                                      s_tick => tick,
                                      reset => reset,
                                      rx_done_tick => rx_done,
                                      data_out => rx_data);
    
    uart_tx : uart_transmitter port map (clk => clk,
                                         tx_start => tx_start,
                                         tx => tx,
                                         s_tick => tick,
                                         reset => reset,
                                         data_in => tx_data,
                                         tx_done_tick => tx_done);

end Behavioral;
