library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is 
port(
	  mem_add :  in std_logic_vector(15 downto 0);
	  reset: in STD_LOGIC;
	  mem_out : out std_logic_vector(15 downto 0)
	  );
end instruction_memory;

architecture structure of instruction_memory is 


type memarr is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM : memarr := ("0001001010011000","0001001010011000","0001001010011000","0111010010101010",others => "0001001010011000");
signal addr : std_logic_vector(4 downto 0);

begin
	process(reset,RAM,mem_add,addr) 
	begin
		if (reset = '1') then
			mem_out <= "1011000000000000";
		else
			addr <= mem_add(4 downto 0);
			mem_out <= RAM(to_integer(unsigned(addr)));
		end if;
	end process;
end structure;