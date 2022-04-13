library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_controller is
    generic(ADDR_WIDTH: natural := 5);
    Port ( clk, reset, write_req, read_req : in std_logic;
           full, empty : out std_logic;
           write_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0);
           read_addr : out std_logic_vector (ADDR_WIDTH - 1 downto 0));
end fifo_controller;

architecture Behavioral of fifo_controller is

    signal w_pointer, w_next: unsigned(ADDR_WIDTH downto 0) := (others => '0');
    signal r_pointer, r_next: unsigned(ADDR_WIDTH downto 0) := (others => '0');
    signal full_signal, empty_signal: std_logic := '0';

begin

    -- D FF Memory
    process(clk, reset)
    begin
    
        if (reset = '1') then
            w_pointer <= (others => '0');
            r_pointer <= (others => '0');
        elsif (clk'event and clk = '1') then
            w_pointer <= w_next;
            r_pointer <= r_next;
        end if;
    
    end process;
    
    w_next <= w_pointer + 1 when (write_req = '1' and full_signal = '0') else
              w_pointer;
              
    r_next <= r_pointer + 1 when (read_req = '1' and empty_signal = '0') else
              r_pointer;
    
    -- Empty if both pointers are in the same place.
    empty_signal <= '1' when (w_pointer = r_pointer) else
                    '0';
             
    -- Full when the MSB is not equal.
    full_signal <=  '1' when ((w_pointer(ADDR_WIDTH) /= r_pointer(ADDR_WIDTH)) and 
                               w_pointer(ADDR_WIDTH - 1 downto 0) = r_pointer(ADDR_WIDTH - 1 downto 0))  
                    else '0';
                    
    -- Output Logic
    empty <= empty_signal;
    full <= full_signal;      
    write_addr <= std_logic_vector(w_pointer(ADDR_WIDTH - 1 downto 0));
    read_addr <= std_logic_vector(r_pointer(ADDR_WIDTH - 1 downto 0));  

end Behavioral;
