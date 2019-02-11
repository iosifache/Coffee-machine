-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity
entity adder is port ( 
    A: in std_logic_vector(4 downto 0);
    B: in std_logic_vector(4 downto 0);
    S: out std_logic_vector(4 downto 0)
);
end adder;

-- Architecture of adder
architecture Behavioral of adder is	

    -- Signal declaration
    signal carry_flag: std_logic := '0';
    signal sign_flag: std_logic := '0';
    signal zero_flag: std_logic := '0';
    signal suma: std_logic_vector(4 downto 0) := "00000";
    
    begin
    
    -- Process
	input_watch: process(A, B)
	
           -- Variable declaration
            variable sum: std_logic_vector(4 downto 0) := "00000";
            variable comp: std_logic := '0';
            variable zero: std_logic := '0';
            variable aux: std_logic := '0';
			
			begin
			aux := '1';
			zero := '0';
			
			-- Compute sum
			for i in 0 to 4 loop
			    comp := not B(i);
			    sum(i) := A(i) xor comp xor aux;
				aux := (A(i) and comp) or (aux and (A(i) xor comp));
				zero := zero or sum(i);
			end loop;
            suma <= sum;
            
	end process;
	
	-- Wire
	S <= suma;
	
end Behavioral;