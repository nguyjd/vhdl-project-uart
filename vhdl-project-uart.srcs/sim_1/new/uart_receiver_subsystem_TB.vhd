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
    
    component uart_transmitter is
        port(clk, reset: in std_logic;
         tx_start: in std_logic;
         s_tick: in std_logic;
         data_in: in std_logic_vector(D_WIDTH - 1 downto 0);
         tx_done_tick: out std_logic;
         tx: out std_logic);
    end component;
    
    component baud_rate_generator is 
        port(clk, reset: in std_logic;  
            tick: out std_logic  
        ); 
    end component;

    signal rx, s_tick, rx_done_tick, tx_start, tx_done_tick: std_logic := '0';
    
    signal clk, reset, read_req, full, empty : std_logic := '0';
    signal data_out, rx_data, data_in: std_logic_vector (D_WIDTH - 1 downto 0) := (others => '0');
    
    -- Clock Period 
    constant Tclk: time := 20 ns;
    
    signal counter : natural := 0;

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
                                
    UUT3 : uart_transmitter port map (clk => clk, 
                                      tx => rx,
                                      tx_start => tx_start,
                                      s_tick => s_tick,
                                      reset => reset,
                                      tx_done_tick => tx_done_tick,
                                      data_in => data_in);
                                      
    UUT : baud_rate_generator port map (clk => clk, reset => reset, tick => s_tick);
    
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
    
        wait for 8*Tclk;
        
        reset <= '0';
        data_in <= "00111000";
        
        wait until (s_tick'event and s_tick = '1');
        
        tx_start <= '1';
        
        wait until (s_tick'event and s_tick = '1');
        
        tx_start <= '0';
        
        
        while (full = '0') loop
        
            -- Wait until the transmitter is done sending data
            wait until (tx_done_tick'event and tx_done_tick = '1');
            -- Wait for 8 clock cycle.
            wait for 8*Tclk;
            
            data_in <= std_logic_vector(TO_UNSIGNED(counter, 8));
            counter <= counter + 1;
            
            wait until (s_tick'event and s_tick = '1');
            
            tx_start <= '1';
            
            wait until (s_tick'event and s_tick = '1');
            
            tx_start <= '0';
        
        end loop;
        
        
        wait;
    
    end process;

end Behavioral;
