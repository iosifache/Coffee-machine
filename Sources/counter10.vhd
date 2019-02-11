-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter10 is port(
    enable: in std_logic;
    clock: in std_logic;
    reset: in std_logic;
    terminal_count: out std_logic;
    state: out std_logic_vector (3 downto 0)
);
end entity;

-- Architecture
architecture Behavioral of counter10 is

    -- Signal declaration
    signal count: std_logic_vector (3 downto 0);
    
    -- Constant state
    constant initial_state: std_logic_vector := "1010";
    
    begin

    -- Process sensitive to clock
    counter_process: process (enable, clock, reset) 
    
        begin
        
        if (reset = '1') then
            count <= initial_state;
        elsif (enable = '1' and rising_edge(clock)) then
            if (count = "0000") then
                count <= initial_state;
                terminal_count <= '1';
            else
                if (count = initial_state) then
                    terminal_count <= '0';
                end if;
                count <= count - 1;
            end if;
        end if;
        
    end process;
    
    -- Wire
    state <= count;
    
end architecture;