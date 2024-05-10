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
signal RAM : memarr := (0=>"0011101000000100",
								1=>"0011110000000000",
								2=>"0100001110000000",
								3=>"0100010110000001",
								4=>"1001001010000010",
								5=>"0000011011000001",
								6=>"0001001010001111",
								7=>"1111101000000000",
								8=>"0101011110000010",
								9=>"0101001110000011",
								10=>"1110000101001100",
								others => "1110000101001100");
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