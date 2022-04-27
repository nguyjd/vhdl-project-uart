library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_TB is
    generic(D_WIDTH: natural := 8);
end uart_TB;

architecture Behavioral of uart_TB is

    component uart is
        port (clk, reset, rx: in std_logic;
              tx: out std_logic);
    end component;
    
    component baud_rate_generator is 
        port(clk, reset: in std_logic;  
            tick: out std_logic  
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
    
    component uart_receiver is
        port(clk, rx, s_tick, reset: in std_logic;  
         rx_done_tick: out std_logic;
         data_out: out std_logic_vector(D_WIDTH - 1 downto 0)
        ); 
    end component;

    signal clk, reset, rx, tx, tx_start, s_tick, tx_done_tick, rx_done_tick: std_logic := '0';
    signal tx_data_in, rx_data_out: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');

    -- Clock Period 
    constant Tclk: time := 20 ns;
    
begin

    UUT : uart port map (clk => clk, 
                         reset => reset,
                         rx => rx,
                         tx => tx);
                         
    host_tx : uart_transmitter port map (clk => clk, 
                                         tx => rx,
                                         tx_start => tx_start,
                                         s_tick => s_tick,
                                         reset => reset,
                                         tx_done_tick => tx_done_tick,
                                         data_in => tx_data_in);
                                         
                                         
    host_rx : uart_receiver port map (clk => clk, 
                                      rx => tx,
                                      s_tick => s_tick,
                                      reset => reset,
                                      rx_done_tick => rx_done_tick,
                                      data_out => rx_data_out);
                                         
    
                                         
    baud : baud_rate_generator port map (clk => clk, reset => reset, tick => s_tick);

    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        wait for Tclk/2;
    
    end process;
    
    process
    begin
        
        -- Reset the uart system
        reset <= '1';
        wait for 8*Tclk;
        
        
        -- Sending F in ascii
        reset <= '0';
        tx_data_in <= std_logic_vector(to_unsigned(70, D_WIDTH));
        tx_start <= '1';
        wait for Tclk;
        tx_start <= '0';
        
        
        -- Sending d in ascii
        wait until (tx_done_tick = '1');
        wait until (s_tick = '1');
        tx_data_in <= std_logic_vector(to_unsigned(100, D_WIDTH));
        tx_start <= '1';
        wait for Tclk;
        tx_start <= '0';
        
        
        -- Sending 2 in ascii
        wait until (tx_done_tick = '1');
        wait until (s_tick = '1');
        tx_data_in <= std_logic_vector(to_unsigned(50, D_WIDTH));
        tx_start <= '1';
        wait for Tclk;
        tx_start <= '0';
        
        
        -- Sending + in ascii
        wait until (tx_done_tick = '1');
        wait until (s_tick = '1');
        tx_data_in <= std_logic_vector(to_unsigned(43, D_WIDTH));
        tx_start <= '1';
        wait for Tclk;
        tx_start <= '0';
        
        
        -- Sending a New Line in ascii
        wait until (tx_done_tick = '1');
        wait until (s_tick = '1');
        tx_data_in <= std_logic_vector(to_unsigned(10, D_WIDTH));
        tx_start <= '1';
        wait for Tclk;
        tx_start <= '0';
        
        wait;
    
    end process;
    

end Behavioral;
