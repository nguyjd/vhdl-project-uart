library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

entity uart_receiver is
    generic(D_BIT: natural := 8;
            SAMPLE_TICKS: natural := 16);
    port(clk, rx, s_tick, reset: in std_logic;  
         rx_done_tick: out std_logic;
         data_out: out std_logic_vector(D_BIT - 1 downto 0)
    ); 
end uart_receiver;

--NOTE: This does reverse the order that the bits are in. Not sure what is the right way.
architecture Behavioral of uart_receiver is

type states is (idle, stop, start, data);
signal statereg, statenext: states;

constant sample_count_reg_width : natural := natural(ceil(log2(real(SAMPLE_TICKS))));
constant data_count_width : natural := natural(ceil(log2(real(D_BIT))));

signal sample_count_reg, sample_count_next: unsigned(sample_count_reg_width - 1 downto 0) := (others => '0');
signal data_count_reg, data_count_next: unsigned(data_count_width - 1 downto 0) := (others => '0');
signal data_reg, data_next: std_logic_vector(D_BIT - 1 downto 0) := (others => '0');

begin

    -- State Register and Internal Registers
    process (clk, reset)
    begin
         if (reset = '1') then
            statereg <= idle;
            sample_count_reg <= (others => '0');
            data_count_reg <= (others => '0');
            data_reg <= (others => '0');
         elsif (clk'event and clk = '1') then
            statereg <= statenext;
            sample_count_reg <= sample_count_next;
            data_count_reg <= data_count_next;
            data_reg <= data_next;
         end if;
    end process;
    
    -- Next State Logic
    process(statereg, rx, sample_count_reg, data_count_reg, data_reg, s_tick)
    begin
        case statereg is
            when idle =>
                rx_done_tick <= '0';
                if (rx = '0') then
                    statenext <= start;
                    sample_count_next <= (others => '0');
                else
                    statenext <= idle;
                end if;
                
            when start =>
                if (s_tick = '1') then
                    if (sample_count_reg = ((SAMPLE_TICKS / 2) - 1)) then
                        sample_count_next <= (others => '0');
                        data_count_next <= (others => '0');
                        data_next <= (others => '0');
                        statenext <= data; 
                    else
                        sample_count_next <= sample_count_next + 1;
                    end if;
                end if;
                
            when data =>
                if (s_tick = '1') then
                    if (sample_count_reg = (SAMPLE_TICKS - 1)) then
                        sample_count_next <= (others => '0');
                        data_next <= rx & data_reg(D_BIT - 1 downto 1);
                        if (data_count_reg = (D_BIT - 1)) then
                            statenext <= stop;
                        else
                            data_count_next <= data_count_reg + 1;
                        end if;
                    else
                        sample_count_next <= sample_count_reg + 1;
                    end if; 
                end if;
            
            when stop =>
                if (s_tick = '1') then
                    if (sample_count_reg = (SAMPLE_TICKS - 1)) then
                        statenext <= idle;
                        rx_done_tick <= '1';
                    else
                        sample_count_next <= sample_count_reg + 1;
                    end if;
                end if;
        end case;
    end process;
    
    -- Output Logic     
    data_out <= data_reg;

end Behavioral;
