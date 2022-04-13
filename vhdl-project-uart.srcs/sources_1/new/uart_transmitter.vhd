library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

entity uart_transmitter is
    generic(D_BIT: natural := 8;
            SAMPLE_TICKS: natural := 16);
    port(clk, reset: in std_logic;
         tx_start: in std_logic;
         s_tick: in std_logic;
         data_in: in std_logic_vector(D_BIT - 1 downto 0);
         tx_done_tick: out std_logic;
         tx: out std_logic);
end uart_transmitter;

architecture Behavioral of uart_transmitter is

    type states is (idle, stop, start, data);
    signal statereg, statenext: states;
    
    constant sample_count_reg_width : natural := natural(ceil(log2(real(SAMPLE_TICKS))));
    constant data_count_width : natural := natural(ceil(log2(real(D_BIT))));
    
    signal sample_count_reg, sample_count_next: unsigned(sample_count_reg_width - 1 downto 0) := (others => '0');
    signal data_count_reg, data_count_next: unsigned(data_count_width - 1 downto 0) := (others => '0');
    signal data_reg, data_next: std_logic_vector(D_BIT - 1 downto 0) := (others => '0');
    signal tx_reg, tx_next: std_logic := '1';

begin

    -- State Register and Internal Registers
    process (clk, reset)
    begin
         if (reset = '1') then
            statereg <= idle;
            sample_count_reg <= (others => '0');
            data_count_reg <= (others => '0');
            data_reg <= (others => '0');
            tx_reg <= '1';
         elsif (clk'event and clk = '1') then
            statereg <= statenext;
            sample_count_reg <= sample_count_next;
            data_count_reg <= data_count_next;
            data_reg <= data_next;
            tx_reg <= tx_next;
         end if;
    end process;
    
    -- Next State Logic
    process(statereg, tx_start, sample_count_reg, data_count_reg, data_reg, tx_reg, s_tick, data_in)
    begin
        
        case statereg is
            when idle =>
                tx_done_tick <= '0';
                tx_next <= '1';
                if (tx_start = '1') then
                    statenext <= start;
                    sample_count_next <= (others => '0');
                    data_next <= data_in;
                end if;
                
            when start =>
                tx_next <= '0';
                if (s_tick = '1') then
                    if (sample_count_reg = (SAMPLE_TICKS - 1)) then
                        sample_count_next <= (others => '0');
                        data_count_next <= (others => '0');
                        statenext <= data; 
                    else
                        sample_count_next <= sample_count_reg + 1;
                    end if;
                else
                    statenext <= start; 
                end if;
                
            when data =>
                
                tx_next <= data_reg(0);
                if (s_tick = '1') then
                    if (sample_count_reg = (SAMPLE_TICKS - 1)) then
                        sample_count_next <= (others => '0');
                        data_next <= '0' & data_reg(D_BIT - 1 downto 1); 
                        if (data_count_reg = (D_BIT - 1)) then
                            statenext <= stop;
                        else
                            data_count_next <= data_count_reg + 1;
                        end if;
                    else
                        sample_count_next <= sample_count_reg + 1;
                    end if;
                else
                    statenext <= data; 
                end if;
            
            when stop =>
                tx_next <= '1';
                if (s_tick = '1') then
                    if (sample_count_reg = (SAMPLE_TICKS - 1)) then
                        statenext <= idle;
                        tx_done_tick <= '1';
                    else
                        sample_count_next <= sample_count_reg + 1;
                    end if;
                else
                    statenext <= stop; 
                end if;
        end case;
    
    end process;
    
    -- Output Logic
    tx <= tx_reg;


end Behavioral;
