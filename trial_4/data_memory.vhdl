library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is 
	port(
		 mem_d   : in std_logic_vector(15 DOWNTO 0);
		 mem_a   : in std_logic_vector(15 downto 0);
		 rd_en  : in std_logic; -- read enable.
		 wr_en  : in std_logic; -- write enable
		 reset: in std_logic; -- clear.
		 clk : in std_logic; -- clock.
		 mem_out : out std_logic_vector(15 DOWNTO 0)); -- output
end data_memory;

architecture structure of data_memory is 


type memarr is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM : memarr := (0=>"0000000010100100",
								1=>"0000000000001101",
								2=>"0000000000000000",
								3=>"0000000000000000",
								4=>"0111011001100110",
								5=>"0011001000001010",
								6=>"0110011000101000",
								7=>"0000000000000111",
								8=>"1100110000000100",
								16=>"1111011000000101",
								20=>"1101101011000000",
								10=>"0000000000001010",
								11=>"0000000000001011",
								others => "1011000101001100");
signal addr : std_logic_vector(4 downto 0);


begin

addr <= mem_a(4 downto 0);

	mem_proc : process(reset, wr_en, rd_en, clk, addr, RAM)

		begin
				
			if rd_en = '1' then
				mem_out <= RAM(to_integer(unsigned(addr)));
		
			elsif rising_edge (clk) then
				
				if wr_en ='1' then
					RAM(to_integer(unsigned(addr))) <= mem_d;
					mem_out <= (others => '0');
				end if;
				
			end if;	
					
	end process mem_proc;

end structure;

