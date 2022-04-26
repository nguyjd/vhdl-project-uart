library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_control_TB is
    generic(ADDR_WIDTH: natural := 8;
            D_WIDTH: natural := 8);
end ram_control_TB;

architecture Behavioral of ram_control_TB is

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
    
    component rx_ram_controller is
        Port ( clk, reset, rx_empty: in std_logic;
               rx_read, write_enable : out std_logic;
               write_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0));
    end component;

    signal clk, reset, write_req, read_req, full, empty, write_enable: std_logic := '0';
    signal data_out, data_in, ram_data_out: std_logic_vector (D_WIDTH - 1 downto 0) := (others => '0');
    
    signal write_address, read_address: std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
    
    signal counter : unsigned(D_WIDTH - 1 downto 0) := (others => '0');

    -- Clock Period 
    constant Tclk: time := 20 ns;

begin

    fifo : fifo_buffer port map (clk => clk, 
                                reset => reset,
                                write_req => write_req,
                                read_req => read_req,
                                data_out => data_out,
                                data_in => data_in,
                                full => full,
                                empty => empty);
                                
    ram : single_port_ram port map ( clk => clk, 
                                     write_enable => write_enable,
                                     write_address => write_address,
                                     read_address => read_address,
                                     data_in => data_out,
                                     data_out => ram_data_out);
                                     
                                     
    UUT : rx_ram_controller port map ( clk => clk, 
                                       reset => reset,
                                       rx_empty => empty,
                                       rx_read => read_req,
                                       write_enable => write_enable,
                                       write_addr => write_address);

    clk_pulse: process
    begin
    
        clk <= '0';
        wait for Tclk/2;
        
        clk <= '1';
        
        if reset <= '0' then
        
            data_in <= std_logic_vector(counter);
            counter <= counter + 1;
        
        end if;
        
        wait for Tclk/2;
    
    end process;

    process 
    begin
        
        reset <= '1';
        
        wait for 8*Tclk;
        
        reset <= '0';
        write_req <= '1';
        wait;
    
    end process;


end Behavioral;
