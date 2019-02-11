-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity
entity edge_detector is port(
    clock: in std_logic;
    reset: in std_logic;
    input: in std_logic;
    output: out std_logic
);
end edge_detector;

-- Architecture
architecture Behavioral of edge_detector is

    -- Signal declaration
    signal top: std_logic := '0';
    signal down: std_logic := '0';

    begin

    detect_process: process(clock, reset)

        begin
      
        if(reset = '1') then
            top <= '0';
            down <= '0';
        elsif(rising_edge(clock)) then
            top <= input;
            down <= top;
      end if;
      
    end process;
    
    -- Wire
    output <= not down and top;
    
end Behavioral;