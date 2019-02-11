-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity
entity coffee is port(
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
end coffee;

-- Architecture
architecture Behavioral of coffee is

    -- Components
    component second_clock is port(
        faster_clk: in std_logic;
        slower: out std_logic
    );
    end component;
    component edge_detector is port(
        clock: in std_logic;
        reset: in std_logic;
        input: in std_logic;
        output: out std_logic
    );
    end component;
    component debouncer is port(
        clock: in std_logic;
        input: in std_logic;
        output: out std_logic
    );
    end component;
    component alu is port(
        A: in std_logic_vector(4 downto 0);
        B: in std_logic_vector(4 downto 0);
        S: out std_logic_vector(4 downto 0);
        ALTB: out std_logic;
        AEQB: out std_logic;
        AGTB: out std_logic
    );
    end component;
    component counter10 is port(
        enable: in std_logic;
        clock: in std_logic;
        reset: in std_logic;
        terminal_count: out std_logic;
        state: out std_logic_vector (3 downto 0)
    );
    end component;
    component counter15 is port(
        enable: in std_logic;
        clock: in std_logic;
        reset: in std_logic;
        terminal_count: out std_logic;
        state: out std_logic_vector (3 downto 0)
    );
    end component;
    component money_counter is port(
        clock: in std_logic;
        banknote_clk: in std_logic;
        coin_clk: in std_logic;
        reset: in std_logic;
        load: in std_logic;
        data: in std_logic_vector (3 downto 0);
        terminal_count: out std_logic;
        state: out std_logic_vector (3 downto 0)
    );
    end component;
    component display is port ( 
        clock: in std_logic;
        reset: in std_logic;
        L1: in std_logic_vector(3 downto 0);
        L2: in std_logic_vector(3 downto 0);
        L3: in std_logic_vector(3 downto 0);
        L4: in std_logic_vector(3 downto 0);
        segments: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(7 downto 0);
        dot: out std_logic
    ); 
    end component;
    
    -- Signal for secondary clock
    signal slower_clk: std_logic := '0';
    
    -- Signals for edge detectors
    signal reset_debounced: std_logic := '0';
    signal banknote_debounced: std_logic := '0';
    signal coin_debounced: std_logic := '0';
    signal irish_debounced: std_logic := '0';
    signal latte_debounced: std_logic := '0';
    signal black_debounced: std_logic := '0';
    
    -- Signals for edge detectors
    signal reset_edge: std_logic := '0';
    signal banknote_edge: std_logic := '0';
    signal coin_edge: std_logic := '0';
    signal irish_edge: std_logic := '0';
    signal latte_edge: std_logic := '0';
    signal black_edge: std_logic := '0';
    
    -- Signal declaration for ALU
    signal A_alu: std_logic_vector(4 downto 0) := "00000";
    signal B_alu: std_logic_vector(4 downto 0) := "00000";
    signal S_alu: std_logic_vector(4 downto 0) := "00000";
    signal ALTB_alu: std_logic := '0';
    signal AEQB_alu: std_logic := '0';
    signal AGTB_alu: std_logic := '0';
    
    -- Signal declaration for wait counter for 10s 
    signal enable_wait_counter_10: std_logic := '0';
    signal reset_wait_counter_10: std_logic := '0';
    signal tc_wait_counter_10: std_logic := '0';
    signal state_wait_counter_10: std_logic_vector(3 downto 0) := "0000";
    
    -- Signal declaration for wait counter for 10s 
    signal enable_wait_counter_15: std_logic := '0';
    signal reset_wait_counter_15: std_logic := '0';
    signal tc_wait_counter_15: std_logic := '0';
    signal state_wait_counter_15: std_logic_vector(3 downto 0) := "0000";
    
    -- Signal for money counter
    signal actual_money: std_logic_vector(3 downto 0) := "0000";
    signal increment_money: std_logic := '0';
    signal reset_money: std_logic := '0';
    signal load_money: std_logic := '0';
    signal money_to_load: std_logic_vector(3 downto 0) := "0000";
    
    -- Signal declaration for LEDs
    signal red: std_logic := '0';
    signal green: std_logic := '0';
    signal blue: std_logic := '1';
    
    -- Status signals declaration
    signal max_count: integer;
    signal waiting: std_logic := '0';
    signal insufficient_money: std_logic := '0';
    signal processing_coffee: std_logic := '0';
    signal done_coffee: std_logic := '0';
    
    -- Signal for BCD
    signal segments_bcd: std_logic_vector(6 downto 0);
    signal anode_bcd: std_logic_vector(7 downto 0);
    signal digit_1: std_logic_vector(3 downto 0) := "0000";
    signal digit_2: std_logic_vector(3 downto 0) := "0000";
    signal digit_3: std_logic_vector(3 downto 0) := "1111";
    signal digit_4: std_logic_vector(3 downto 0) := "0000";
    signal dot_bcd: std_logic;
    
    -- Const for BCD digits
    constant ZeroDigit: std_logic_vector(3 downto 0) := "0000";
    constant FiveDigit: std_logic_vector(3 downto 0) := "0101";
    
    -- Const for state
    constant InitialState: std_logic_vector(3 downto 0) := "0000";
    constant ProcessingState: std_logic_vector(3 downto 0) := "0001";
    constant DoneState: std_logic_vector(3 downto 0) := "0010";
    constant WaitingState: std_logic_vector(3 downto 0) := "0011";
    constant InsufficientState: std_logic_vector(3 downto 0) := "0100";
    
    -- Const prices for coffe
    constant IrishPrice: std_logic_vector(3 downto 0) := "0100";
    constant BlackPrice: std_logic_vector(3 downto 0) := "0010";
    constant LattePrice: std_logic_vector(3 downto 0) := "0101";

    begin
    
    -- New instances of counters
    clock_divider: second_clock port map(
        faster_clk => clk,
        slower => slower_clk
    );
    reset_debouncer: debouncer port map(
        clock => clk,
        input => reset,
        output => reset_debounced
    );
    banknote_debouncer: debouncer port map(
        clock => clk,
        input => banknote,
        output => banknote_debounced
    );
    coin_debouncer: debouncer port map(
        clock => clk,
        input => coin,
        output => coin_debounced
    );
    irish_debouncer: debouncer port map(
        clock => clk,
        input => irish,
        output => irish_debounced
    );
    latte_debouncer: debouncer port map(
        clock => clk,
        input => latte,
        output => latte_debounced
    );
    black_debouncer: debouncer port map(
        clock => clk,
        input => black,
        output => black_debounced
    );
    reset_edge_detector: edge_detector port map(
        clock => clk,
        reset => '0',
        input => reset_debounced,
        output => reset_edge
    );
    banknote_edge_detector: edge_detector port map(
        clock => clk,
        reset => reset_edge,
        input => banknote_debounced,
        output => banknote_edge
    );
    coin_edge_detector: edge_detector port map(
        clock => clk,
        reset => reset_edge,
        input => coin_debounced,
        output => coin_edge
    );
    irish_edge_detector: edge_detector port map(
        clock => clk,
        reset => reset_edge,
        input => irish_debounced,
        output => irish_edge
    );
    latte_edge_detector: edge_detector port map(
        clock => clk,
        reset => reset_edge,
        input => latte_debounced,
        output => latte_edge
    );
    black_edge_detector: edge_detector port map(
        clock => clk,
        reset => reset_edge,
        input => black_debounced,
        output => black_edge
    );    
    alu_instance: alu port map(
        A => A_alu,
        B => B_alu,
        S => S_alu,
        ALTB => ALTB_alu,
        AEQB => AEQB_alu,
        AGTB => AGTB_alu
    );
    wait_counter_10: counter10 port map(
        enable => enable_wait_counter_10,
        clock => slower_clk, 
        reset => reset_wait_counter_10, 
        terminal_count => tc_wait_counter_10,
        state => state_wait_counter_10
    );
    wait_counter_15: counter15 port map(
        enable => enable_wait_counter_15,
        clock => slower_clk, 
        reset => reset_wait_counter_15, 
        terminal_count => tc_wait_counter_15,
        state => state_wait_counter_15
    );
    credit: money_counter port map(
        clock => clk,
        banknote_clk => banknote_edge,
        coin_clk => coin_edge,
        reset => reset_money,
        load => load_money,
        data => money_to_load,
        state => actual_money
    );
    four_segments: display port map(
        clock => clk,
        reset => reset,
        L1 => digit_1,
        L2 => digit_2,
        L3 => digit_3,
        L4 => digit_4,
        segments => segments_bcd,
        anode => anode_bcd,
        dot => dot_bcd
    );
    
    -- Digit process
    digit_process: process(actual_money)
    
        begin
        
        -- Display digits
        if (actual_money(0) = '1') then
            digit_1 <= FiveDigit;
        else
            digit_1 <= ZeroDigit;
        end if;
        digit_2 <= '0' & actual_money(3) & actual_money(2) & actual_money(1);
    
    end process;
    
    -- LED process
    led_process: process(reset_edge, processing_coffee, done_coffee, waiting, insufficient_money)
    
        begin
        
        -- Set colors
       if (reset_edge = '1') then
           red <= '0';
           green <= '0';
           blue <= '1';
           digit_4 <= InitialState;
       elsif (processing_coffee = '1') then
           red <= '1';
           green <= '0';
           blue <= '0';
           digit_4 <= ProcessingState;
       elsif (done_coffee = '1') then
           red <= '0';
           green <= '1';
           blue <= '0';
           digit_4 <= DoneState;
       elsif (waiting = '1') then
           red <= '1';
           green <= '1';
           blue <= '0';
           digit_4 <= WaitingState;
       elsif (insufficient_money = '1') then
           red <= '1';
           green <= '1';
           blue <= '1';
           digit_4 <= InsufficientState;
       end if;
    
    end process;

    -- Process sensitive to clk
    coffe_process: process(clk)
    
        begin
        
        if (rising_edge(clk)) then
            
            -- If it is first or second time when the customer try
            if ((waiting='0' and processing_coffee = '0') or (tc_wait_counter_10 = '1' and waiting = '1' and done_coffee = '0')) then
            
                -- Set cost for drinks
                A_alu <= '0' & actual_money;
                if (irish = '1') then
                    B_alu <= '0' & IrishPrice;
                    max_count <= 10;
                elsif (latte = '1') then
                    B_alu <= '0' & LattePrice;
                    max_count <= 15;
                elsif (black = '1') then 
                    B_alu <= '0' & BlackPrice;
                    max_count <= 10;
                end if;
            
            end if;
            
            -- If a product is selected
            if (latte = '1' or black = '1' or irish = '1') then
            
                if ((tc_wait_counter_10 = '1' or tc_wait_counter_15 = '1') and processing_coffee = '1') then
                            
                    -- Set status after processing command
                    waiting <= '0';
                    processing_coffee <= '0';
                    done_coffee <= '1';
                    insufficient_money <= '0';
                    
                elsif (ALTB_alu = '1' and waiting = '0') then
                
                    -- Set status if not enought money
                    waiting <= '1';
                    processing_coffee <= '0';
                    done_coffee <= '0';
                    insufficient_money <= '0';
                    
                    -- Enable counter
                    enable_wait_counter_10 <= '1';
                
                elsif (ALTB_alu = '1' and tc_wait_counter_10 = '1' and waiting = '1') then
                
                    -- Set status after waiting 10s to enter new money
                    waiting <= '0';
                    processing_coffee <= '0';
                    done_coffee <= '0';
                    insufficient_money <= '1';
                       
                end if;
               
            -- If enought money
            if (AGTB_alu = '1' or AEQB_alu = '1') then
                if (max_count = 10 or max_count = 15) then
                
                    -- Load rest
                    money_to_load <= S_alu(3 downto 0);
                    load_money <= '1';
                    
                    -- Set status
                    waiting <= '0';
                    processing_coffee <= '1';
                    done_coffee <= '0';
                    insufficient_money <= '0';
                    
                end if;
                if (max_count = 10) then
                    enable_wait_counter_10 <= '1';
                elsif (max_count = 15) then
                    enable_wait_counter_15 <= '1';
                end if;
            end if;
               
           end if;
           
        end if;
        
    end process;
    
    -- Wire
    segments_from_bcd <= segments_bcd;
    anode_from_bcd <= anode_bcd;
    reset_money <= reset_edge;
    reset_wait_counter_10 <= reset_edge;
    reset_wait_counter_15 <= reset_edge;
    LED_R <= red;
    LED_G <= green;
    LED_G <= green;
    slower_clock <= slower_clk;
    dot <= dot_bcd;

end Behavioral;