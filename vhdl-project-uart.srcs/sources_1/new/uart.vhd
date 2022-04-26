library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart is
    generic(D_WIDTH: natural := 8;
            ADDR_WIDTH: natural := 8);
    port (clk, reset, rx: in std_logic;
          tx: out std_logic);
end uart;

architecture Behavioral of uart is

    component uart_system is 
        port (clk, reset, rx, tx_start: in std_logic;
          rx_done, tx_done, tx: out std_logic;
          rx_data: out std_logic_vector(D_WIDTH - 1 downto 0);
          tx_data: in std_logic_vector(D_WIDTH - 1 downto 0));
    end component;
    
    component fifo_buffer is
        Port (  clk, reset, write_req, read_req : in std_logic;
                data_out : out std_logic_vector (D_WIDTH - 1 downto 0);
                data_in : in std_logic_vector (D_WIDTH - 1 downto 0);
                full, empty : out std_logic);
    end component;
    
    component single_port_ram is
        port (clk : in std_logic;
              write_enable : in std_logic;
              write_address : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
              read_address : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
              data_in : in std_logic_vector(D_WIDTH - 1 downto 0);
              data_out : out std_logic_vector(D_WIDTH - 1 downto 0));
    end component;
    
    component classification_engine is
    port(clk, reset : in std_logic;
        data_in : in std_logic_vector(D_WIDTH - 1 downto 0);
        data_out : out std_logic_vector(D_WIDTH - 1 downto 0));
    end component;
    
    -- Uart Signals
    signal tx_start, rx_done, tx_done: std_logic := '0';
    
    -- Connection to Fifo Buffer
    signal rx_data, tx_data: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');
    
    -- RX Buffer signals
    signal rx_read_req, rx_full, rx_empty: std_logic := '0';
    
    -- TX Buffer signals
    signal tx_write_req, tx_read_req, tx_full, tx_empty: std_logic := '0';
    
    -- Ram data in and out.
    signal ram_data_in, ram_data_out: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');


begin

    uart_module: uart_system port map (clk => clk, 
                                       reset => reset,
                                       rx => rx,
                                       tx_start => tx_start,
                                       rx_done => rx_done,
                                       tx_done => tx_done,
                                       tx => tx,
                                       rx_data => rx_data,
                                       tx_data => tx_data);
                                       
     rx_fifo : fifo_buffer port map (clk => clk, 
                                     reset => reset,
                                     write_req => rx_done,
                                     read_req => rx_read_req,
                                     data_out => ram_data_in,
                                     data_in => rx_data,
                                     full => rx_full,
                                     empty => rx_empty);
                                     
    ram : single_port_ram port map ( clk => clk, 
                                     write_enable => write_enable,
                                     write_address => write_address,
                                     read_address => read_address,
                                     data_in => ram_data_in,
                                     data_out => ram_data_out);  


end Behavioral;
