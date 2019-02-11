-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity declaration
entity alu is port(
    A: in std_logic_vector(4 downto 0);
    B: in std_logic_vector(4 downto 0);
    S: out std_logic_vector(4 downto 0);
    ALTB: out std_logic;
    AEQB: out std_logic;
    AGTB: out std_logic
);
end alu;

architecture Behavioral of alu is

    -- Component declaration
    component adder is port ( 
            A: in std_logic_vector(4 downto 0);
            B: in std_logic_vector(4 downto 0);
            S: out std_logic_vector(4 downto 0)
    );
    end component;
    component comparer is port ( 
        S: in std_logic_vector(4 downto 0);
        ALTB: out std_logic;
        AEQB: out std_logic;
        AGTB: out std_logic
    );
    end component;

    -- Signal declaration
    signal sum: std_logic_vector(4 downto 0);
    signal carry: std_logic;
    signal sign: std_logic;
    signal zero: std_logic;
    
    begin
    
    -- New instances of components
    adder_instance: adder port map(
        A => A,
        B => B,
        S => sum
    );
    comparer_instance: comparer port map(
        S => sum,
        ALTB => ALTB,
        AEQB => AEQB,
        AGTB => AGTB
    );
    S <= sum;

end Behavioral;
