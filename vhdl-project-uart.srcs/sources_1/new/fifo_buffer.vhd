library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_buffer is
    generic(ADDR_WIDTH: natural := 5;
            D_WIDTH: natural := 8);
    Port ( clk, reset, write_req, read_req : in std_logic;
           data_out : out std_logic_vector (D_WIDTH - 1 downto 0);
           data_in : in std_logic_vector (D_WIDTH - 1 downto 0);
           full, empty : out std_logic);
end fifo_buffer;

architecture Behavioral of fifo_buffer is

    component register_file is
        Port ( read_data : out std_logic_vector (D_WIDTH - 1 downto 0);
               write_data : in std_logic_vector (D_WIDTH - 1 downto 0);
               clk, reset, write_enable : in std_logic;
               write_addr : in std_logic_vector (ADDR_WIDTH - 1 downto 0);
               read_addr : in std_logic_vector (ADDR_WIDTH - 1 downto 0));
    end component;
    
    component fifo_controller is
        Port ( clk, reset, write_req, read_req : in std_logic;
           full, empty : out std_logic;
           write_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0);
           read_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0));
    end component;
    
    signal write_addr_signal, read_addr_signal: std_logic_vector (ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal full_signal, we: std_logic := '0';

begin
    
    fifo: fifo_controller port map (clk => clk,
                                    reset => reset,
                                    write_req => write_req,
                                    read_req => read_req,
                                    full => full_signal,
                                    empty => empty,
                                    write_addr => write_addr_signal,
                                    read_addr => read_addr_signal);
                                    
    regs : register_file port map (clk => clk, 
                                   reset => reset,
                                   write_enable => we,
                                   write_addr => write_addr_signal,
                                   read_addr => read_addr_signal,
                                   read_data => data_out,
                                   write_data => data_in);
    
    -- Output Logic                 
    we <= write_req and not full_signal;
    full <= full_signal;


end Behavioral;
