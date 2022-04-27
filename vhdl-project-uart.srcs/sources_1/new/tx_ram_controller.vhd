library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tx_ram_controller is
    port(clk, reset, class_write_enable: in std_logic;
         ram_write_enable, fifo_write_enable: out std_logic);
end tx_ram_controller;

architecture Behavioral of tx_ram_controller is

    signal fifo_req_reg, fifo_req_next: std_logic := '0';

begin

    -- D FF Memory
    process(clk, reset)
    begin
    
        if (reset = '1') then
            fifo_req_reg <= '0';
        elsif (clk'event and clk = '1') then
            fifo_req_reg <= fifo_req_next;
        end if;
    
    end process;
    
    
    --next state
    fifo_req_next <= '1' when class_write_enable = '1' else
                     '0';
    
    -- output logic 
    ram_write_enable <= class_write_enable;
    fifo_write_enable <= fifo_req_reg;

end Behavioral;
