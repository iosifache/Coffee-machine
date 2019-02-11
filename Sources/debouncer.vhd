-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity
entity debouncer is port(
    clock: in std_logic;
    input: in std_logic;
    output: out std_logic := '0'
);
end debouncer;

-- Architecture
architecture Behavioral of debouncer is

    -- Signal declaration
    signal data: std_logic := '0';

    begin

    -- Process sensitive to clock
    process(clock)
    
        begin
        if(rising_edge(clock)) then
            data <= input;
        end if;
        
    end process;
    
    -- Wire
    output <= data;
    
end Behavioral;