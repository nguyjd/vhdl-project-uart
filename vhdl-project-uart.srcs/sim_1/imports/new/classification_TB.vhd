library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity classification_TB is
    generic ( D_WIDTH: natural := 8;
              ADDR_WIDTH: natural := 8);
end classification_TB;

architecture Behavioral of classification_TB is

    component classification_engine is
        port(clk, reset, rx_full, tx_full: in std_logic;
         write_enable: out std_logic;
         data_in: in std_logic_vector(D_WIDTH - 1 downto 0);
         data_out: out std_logic_vector(D_WIDTH - 1 downto 0);
         max_addr: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
         read_addr, write_addr: out std_logic_vector(ADDR_WIDTH - 1 downto 0));
    end component;

    signal clk, reset, rx_full, tx_full, write_enable: std_logic := '0';
    signal data_in: std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');
    signal data_out : std_logic_vector(D_WIDTH - 1 downto 0) := (others => '0');
    signal max_addr, read_addr, write_addr : std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');

    -- Clock Period 
    constant Tclk: time := 20 ns;

begin

    UUT : classification_engine port map (clk => clk, 
                                          reset => reset, 
                                          rx_full => rx_full, 
                                          tx_full => tx_full,
                                          write_enable => write_enable,
                                          data_in => data_in,
                                          data_out => data_out,
                                          max_addr => max_addr,
                                          read_addr => read_addr,
                                          write_addr => write_addr);
    --20ns Period CLK
    
    clockProcess : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR Tclk/2;
        clk <= '1';
        WAIT FOR Tclk/2;
    END PROCESS;
    
    --Reset Process
    resetProcess : PROCESS
    BEGIN
        reset <= '1';
        wait for 8*Tclk;
        
        reset <= '0';
        wait;
        
    END PROCESS;
    
    --enable <= '1';
    dataProcess : PROCESS
    BEGIN
        
        -- Wait for reset.
        wait for 8*Tclk;
        
        data_in <= std_logic_vector(to_unsigned(0, D_WIDTH));
        wait for 3*Tclk;    
        
        --Uppper F
        data_in <= std_logic_vector(to_unsigned(70, D_WIDTH));
        wait for 3*Tclk;
        
        --Lower d
        data_in <= std_logic_vector(to_unsigned(100, D_WIDTH));
        wait for 3*Tclk;
        
        --Num 2
        data_in <= std_logic_vector(to_unsigned(50, D_WIDTH));
        wait for 3*Tclk;
        
        --Symb new line
        data_in <= std_logic_vector(to_unsigned(10, D_WIDTH));
        wait for 3*Tclk;
    
    end process;

end Behavioral;
