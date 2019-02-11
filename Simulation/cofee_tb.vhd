-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity
entity coffee_tb is
end;

-- Architecture
architecture bench of coffee_tb is

    -- Components
    component coffee port(
        clk: in std_logic;
        reset: in std_logic;
        banknote: in std_logic;
        coin: in std_logic;
        irish: in std_logic;
        latte: in std_logic;
        black: in std_logic;
        segments_from_bcd: out std_logic_vector(6 downto 0);
        anode_from_bcd: out std_logic_vector(7 downto 0);
        dot: out std_logic;
        LED_R: out std_logic := '0';
        LED_G: out std_logic := '0';
        LED_B: out std_logic := '1';
        slower_clock: out std_logic
    );
    end component;
    
    -- Constant clock period
    constant clk_period: time := 10 ns;

    -- Signals
    signal clock : std_logic := '0';
    signal reset: std_logic;
    signal banknote: std_logic;
    signal coin: std_logic;
    signal irish: std_logic;
    signal latte: std_logic;
    signal black: std_logic;
    signal LED_R: std_logic;
    signal LED_G: std_logic;
    signal LED_B: std_logic;
    signal segments_from_bcd: std_logic_vector(6 downto 0);
    signal anode_from_bcd: std_logic_vector(7 downto 0);

    begin

    -- Instance of coffee machine
    uut: coffee port map ( 
        clk         => clock,
        reset         => reset,
        banknote      => banknote,
        coin          => coin,
        irish         => irish,
        latte         => latte,
        black         => black,
        LED_R       => LED_R,
        LED_G    => LED_G,
        LED_B    => LED_B,
        segments_from_bcd => segments_from_bcd,
        anode_from_bcd => anode_from_bcd
    );
    
    -- Clock generating
    clock_process: process
    
        begin
        
        clock <= '0';
        wait for clk_period;
        clock <= '1';
        wait for clk_period;
        
    end process;
    
    -- Process
    stimulus: process
    
        begin
        
        -- Init all
        reset <= '0';
        banknote <= '0';
        coin <= '0';
        latte <= '0';
        black <= '0';
        irish <= '0';
        wait for 10 ms;
        
        -- Reset the machine
        reset <= '1';
        wait for 10 ms;
        reset <= '0';
        wait for 10 ms;
        
        -- Give one banknote
        banknote <= '1';
        wait for 10 ms;
        banknote <= '0';
        wait for 10 ms;
        
        -- Give one banknote
        banknote <= '1';
        wait for 10 ms;
        banknote <= '0';
        wait for 10 ms;
        
        -- Give one banknote
        banknote <= '1';
        wait for 10 ms;
        banknote <= '0';
        wait for 10 ms;
        
        -- Give a coin
        coin <= '1';
        wait for 10 ms;
        coin <= '0';
        wait for 10 ms;
        
        -- Give a coin
        coin <= '1';
        wait for 10 ms;
        coin <= '0';
        wait for 10 ms;
                
        -- Select product
        latte <= '1';
        wait for 100 ms;
        
        -- Wait
        wait;
        
    end process;

end;