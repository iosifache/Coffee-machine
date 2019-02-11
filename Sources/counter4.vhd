-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity
entity counter4 is port( 
    clk: in std_logic;
    reset: in std_logic;
    count: inout std_logic_vector(1 downto 0) := "00"
);  
end counter4;

architecture Behavioral of counter4 is

    signal divider: std_logic_vector(20 downto 0) := "000000000000000000000";

    begin

    -- Process for slowing the clock
    process(clk)
    
        begin

        if(clk'event and clk='1') then
            divider <= divider + 1;
        end if;
    
    end process;

    -- Process for counting
    process (reset, clk)

        begin
    
        if reset='1' then
            count <= "00";
        end if;
        count <= divider(20 downto 19);
       
    end process;

end Behavioral;