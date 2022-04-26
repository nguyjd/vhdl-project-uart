library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_system_TB is
    generic(D_WIDTH: natural := 8);
end uart_system_TB;

architecture Behavioral of uart_system_TB is

    component uart_system is
        port (clk, reset, rx, tx_start: in std_logic;
              rx_done, tx_done, tx: out std_logic;
              rx_data: out std_logic_vector(D_WIDTH - 1 downto 0);
              tx_data: in std_logic_vector(D_WIDTH - 1 downto 0));
    end component;
    
    signal clk, reset, rx, tx_start, rx_done, tx_done, tx: std_logic := '0';
    signal rx_data, tx_data: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');

    -- Clock Period 
    constant Tclk: time := 20 ns;

begin

    uart : uart_system port map (clk => clk, 
                                 reset => reset,
                                 rx => rx,
                                 tx_start => tx_start,
                                 rx_done => rx_done,
                                 tx_done => tx_done,
                                 tx => tx,
                                 rx_data => rx_data,
                                 tx_data => tx_data);

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
        rx <= '1';
        wait for 8*Tclk;
        
        -- Start receving
        reset <= '0';
        rx <= '0';
        
        wait for 16*6500 ns;
        
        -- Sending 00111000
        rx <= '0';
        
        -- Allow the RX to oversample.
        wait for 16*6500 ns;
        
        rx <= '0';
        
        -- Allow the RX to oversample.
        wait for 16*6500 ns;
        
        rx <= '0';
        
        -- Allow the RX to oversample.
        wait for 16*6500 ns;
        
        rx <= '1';
        
        -- Allow the RX to oversample.
        wait for 16*6500 ns;
        
        rx <= '1';
        
        -- Allow the RX to oversample.
        wait for 16*6500 ns;
        
        rx <= '1';
        
        -- Allow the RX to oversample.
        wait for 16*6500 ns;
        
        rx <= '0';
        
        -- Allow the RX to oversample.
        wait for 16*6500 ns;
        
        rx <= '0';
        
        -- Allow the RX to oversample.
        wait for 16*6500 ns;
        
        rx <= '1';
        
        wait for 16*6500 ns;
    
        tx_data <= "01011010";
        
        wait for 16*6500 ns;
    
        tx_start <= '1';
        
        wait for 16*6500 ns;
    
        tx_start <= '0';
        wait;
    
    end process;


end Behavioral;
