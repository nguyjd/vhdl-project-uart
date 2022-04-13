library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_transmitter_TB is
    generic(D_BIT: natural := 8);
end uart_transmitter_TB;

architecture Behavioral of uart_transmitter_TB is

    component uart_receiver is
        port(clk, rx, s_tick, reset: in std_logic;  
         rx_done_tick: out std_logic;
         data_out: out std_logic_vector(D_BIT - 1 downto 0)
        ); 
    end component;
    
    component uart_transmitter is
        port(clk, reset: in std_logic;
         tx_start: in std_logic;
         s_tick: in std_logic;
         data_in: in std_logic_vector(D_BIT - 1 downto 0);
         tx_done_tick: out std_logic;
         tx: out std_logic);
    end component;
    
    signal clk, rx, s_tick, reset, rx_done_tick, tx_done_tick, tx_start: std_logic := '0';
    signal data_out, data_in: std_logic_vector(D_BIT - 1 downto 0) := (others => '0');

    -- Clock Period 
    constant Tclk: time := 2 ns;

begin

    UUT1 : uart_receiver port map (clk => clk, 
                                  rx => rx,
                                  s_tick => s_tick,
                                  reset => reset,
                                  rx_done_tick => rx_done_tick,
                                  data_out => data_out);
                                  
    UUT2 : uart_transmitter port map (clk => clk, 
                                      tx => rx,
                                      tx_start => tx_start,
                                      s_tick => s_tick,
                                      reset => reset,
                                      tx_done_tick => tx_done_tick,
                                      data_in => data_in);
                                      
    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        wait for Tclk/2;
    
    end process;
    
    process
    begin
    
        wait for 19 ns;
    
        data_in <= "01011100";
        tx_start <= '1';
        s_tick <= '1';
        
        wait for 2 ns;
        
        tx_start <= '0';
        
        wait;
    
    end process;

end Behavioral;
