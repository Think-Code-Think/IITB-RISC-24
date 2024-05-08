library ieee;
use ieee.std_logic_1164.all;
library work;

entity SHIFTER is 
port (INPUT: in std_logic_vector(15 downto 0);
      OUTPUT: out std_logic_vector(15 downto 0)
		);
end entity SHIFTER;

architecture BHV_SHIFTER of SHIFTER is 

begin

	OUTPUT(15 downto 1) <= INPUT(14 downto 0);
	OUTPUT(0) <= '0';
	
end BHV_SHIFTER;