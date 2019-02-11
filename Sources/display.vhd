-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity
entity display is port ( 
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
end display;

-- Architeture
architecture Behavioral of display is

    -- Components
    component decoder2to4 is port ( 
        input: in std_logic_vector(1 downto 0);
        output: out std_logic_vector(3 downto 0));
    end component;
    component counter4 is port( 
        clk: in std_logic;
        reset: in std_logic;
        count: inout std_logic_vector(1 downto 0) := "00"
    );  
    end component;
    component bcd is port(
        data: in std_logic_vector(3 downto 0);
        segments: out std_logic_vector(6 downto 0)
    );
    end component;

    -- Signals
    signal state: std_logic_vector(1 downto 0);
    signal digit_to_decode: std_logic_vector(3 downto 0);
    signal digit_select: std_logic_vector(3 downto 0);
    signal anode_select: std_logic_vector(7 downto 0);
    signal dot_enable: std_logic := '1';
    
    begin

    -- Instances
    counter_for_scan: counter4 port map(
        clk => clock,
        reset=> reset,
        count => state
    );
    decoder: decoder2to4 port map(
        input => state,
        output => digit_select
    );
    bcd_decoder: bcd port map(
        data => digit_to_decode,
        segments => segments
    );

    -- Process for scan
    scan_process: process(digit_select)
    
        begin  
    
        case digit_select is
            when "0001" => 
                digit_to_decode <= L1;   
                anode_select <= "11111110";  
                dot_enable <= '1';              
            when "0010" => 
                digit_to_decode <= L2;
                anode_select <= "11111101";
                dot_enable <= '0';
            when "0100" => 
                digit_to_decode <= L3;
                anode_select <= "11111011";
                dot_enable <= '1';  
            when "1000" => 
                digit_to_decode <= L4;
                anode_select <= "11110111";
                dot_enable <= '1';   
            when others => 
                anode_select <= "11111111";
                dot_enable <= '1';   
        end case;
        
    end process;
    
    anode <= anode_select;
    dot <= dot_enable;

end Behavioral;