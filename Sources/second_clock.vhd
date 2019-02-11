-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity second_clock is port(
    faster_clk: in std_logic;
    slower: out std_logic
);
end entity;

-- Architecture
architecture Behavioral of second_clock is

    -- Signal declaration
    signal slower_clk: std_logic := '0';
    signal counter: integer := 0;
    
    begin

    -- Process sensitive to clock
    counter_process: process (faster_clk) 
    
        begin
            
        if (rising_edge(faster_clk)) then
            counter <= counter + 1;
        if (counter = 50000000) then
            slower_clk <= '0';
        elsif (counter = 100000000) then
            counter <= 0;
            slower_clk <= '1';
        end if;
            
        end if;
        
    end process;
    
    -- Wire
    slower <= slower_clk;
    
end architecture;