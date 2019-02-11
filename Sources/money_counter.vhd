-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity money_counter is port(
    clock: in std_logic;
    banknote_clk: in std_logic;
    coin_clk: in std_logic;
    reset: in std_logic;
    load: in std_logic;
    data: in std_logic_vector (3 downto 0);
    terminal_count: out std_logic;
    state: out std_logic_vector (3 downto 0)
);
end entity;

-- Architecture
architecture Behavioral of money_counter is

    -- Signal declaration
    signal count: std_logic_vector (3 downto 0) := "0000";
    
    begin

    -- Process sensitive to clock
    counter_process: process (clock) 
        begin
        
        if (rising_edge(clock)) then
            if (reset = '1') then
                count <= "0000";
            elsif (load = '1') then
                count <= data;
            elsif (coin_clk = '1') then
                count <= count + 1;
            elsif (banknote_clk = '1') then
                count <= count + 2;
            end if;
        end if;    
            
    end process;
    
    -- Wire
    state <= count;
    
end architecture;