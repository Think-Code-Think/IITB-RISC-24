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
signal RAM : memarr := (0=>"0011100000000000",
								1=>"0100001100000000",
								2=>"0100010100000001",
								3=>"0011110000000001",
								4=>"1000010100000011",
								5=>"0001011001011000",
								6=>"0001101100101011",
								7=>"0001010110010111",
								8=>"1100111111111110",
								9=>"1011011000000101",
								10=>"0101101100000010",
								11=>"0101011100000011",
								12=>"1110000000000011",
								others => "1011000101001100");
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