library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is 
port(
	  mem_add :  in std_logic_vector(15 downto 0);
	  mem_out : out std_logic_vector(15 downto 0)
	  );
end instruction_memory;

architecture structure of instruction_memory is 


type memarr is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM : memarr := ("1000001010000001","1000001010000001",others => "1000001010000001");
signal addr : std_logic_vector(4 downto 0);

begin

addr <= mem_add(4 downto 0);
mem_out <= RAM(to_integer(unsigned(addr)));

end structure;