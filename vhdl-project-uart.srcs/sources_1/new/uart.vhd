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
        port(clk, reset, rx_full, tx_full: in std_logic;
             write_enable: out std_logic;
             data_in: in std_logic_vector(D_WIDTH - 1 downto 0);
             data_out: out std_logic_vector(D_WIDTH - 1 downto 0);
             max_addr: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
             read_addr, write_addr: out std_logic_vector(ADDR_WIDTH - 1 downto 0));
    end component;
    
    component rx_ram_controller is
        Port ( clk, reset, rx_empty: in std_logic;
               rx_read, write_enable : out std_logic;
               write_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0));
    end component;
    
    component tx_ram_controller is
        port(clk, reset, class_write_enable: in std_logic;
             ram_write_enable, fifo_write_enable: out std_logic);
    end component;
    
    -- Uart Signals
    signal tx_start, rx_done, tx_done: std_logic := '0';
    
    -- Connection to Fifo Buffer
    signal rx_data, tx_data: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');
    
    -- RX Buffer signals
    signal rx_read_req, rx_full, rx_empty: std_logic := '0';
    
    -- TX Buffer signals
    signal tx_write_req, tx_full, tx_empty: std_logic := '0';
    
    -- rx ram data in and out.
    signal rx_ram_data_in, rx_ram_data_out: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');
    
    -- rx ram signals
    signal rx_write_enable: std_logic := '0';
    signal rx_write_address, rx_read_address: std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
    
    -- tx ram signals
    signal class_write_enable, ram_tx_write_enable: std_logic := '0';
    signal tx_address: std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
    
    -- tx ram data in and out.
    signal tx_ram_data_in, tx_ram_data_out: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');


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
                                    data_out => rx_ram_data_in,
                                    data_in => rx_data,
                                    full => rx_full,
                                    empty => rx_empty);
                                     
    rx_ram : single_port_ram port map ( clk => clk, 
                                        write_enable => rx_write_enable,
                                        write_address => rx_write_address,
                                        read_address => rx_read_address,
                                        data_in => rx_ram_data_in,
                                        data_out => rx_ram_data_out);
                                     
    rx_ram_control: rx_ram_controller port map (clk => clk, 
                                                reset => reset,
                                                rx_empty => rx_empty,
                                                rx_read => rx_read_req,
                                                write_enable => rx_write_enable,
                                                write_addr => rx_write_address);
                                                
    class : classification_engine port map (clk => clk, 
                                            reset => reset, 
                                            rx_full => rx_full, 
                                            tx_full => tx_full,
                                            data_in => rx_ram_data_out,
                                            read_addr => rx_read_address,
                                            write_addr => tx_address,
                                            data_out => tx_ram_data_in,
                                            max_addr => rx_write_address,
                                            write_enable => class_write_enable);
                                            
    tx_ram : single_port_ram port map ( clk => clk, 
                                        write_enable => ram_tx_write_enable,
                                        write_address => tx_address,
                                        read_address => tx_address,
                                        data_in => tx_ram_data_in,
                                        data_out => tx_ram_data_out);
                                            
    tx_ram_control: tx_ram_controller port map (clk => clk, 
                                                reset => reset,
                                                class_write_enable => class_write_enable,
                                                ram_write_enable => ram_tx_write_enable,
                                                fifo_write_enable => tx_write_req);
                              
    tx_fifo : fifo_buffer port map (clk => clk, 
                                    reset => reset,
                                    write_req => tx_write_req,
                                    read_req => tx_done,
                                    data_out => tx_data,
                                    data_in => tx_ram_data_out,
                                    full => tx_full,
                                    empty => tx_empty);

    tx_start <= not tx_empty;

end Behavioral;
