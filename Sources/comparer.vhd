-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity
entity comparer is port ( 
    S: in std_logic_vector(4 downto 0);
    ALTB: out std_logic;
    AEQB: out std_logic;
    AGTB: out std_logic
);
end comparer;

-- Architecture of comparer
architecture Behavioral of comparer is
    
    signal AEQB_copy: std_logic;
    signal ALTB_copy: std_logic;
    signal AGTB_copy: std_logic;
    
    begin
    
    -- Process for sum
    process(S)
        
        begin
        
        if (S = 0) then
            AEQB_copy <= '1';
            ALTB_copy <= '0';
            AGTB_copy <= '0';
        elsif (S(3) = '0') then
            AEQB_copy <= '0';
            ALTB_copy <= '0';
            AGTB_copy <= '1';
        elsif (S(3) = '1') then
            AEQB_copy <= '0';
            ALTB_copy <= '1';
            AGTB_copy <= '0';
        end if;
            
    end process;
        
    AEQB <= AEQB_copy;
    ALTB <= ALTB_copy;
    AGTB <= AGTB_copy;  
        
    end Behavioral;