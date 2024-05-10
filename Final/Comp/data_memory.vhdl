library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is 
	port(
		 mem_d   : in std_logic_vector(15 DOWNTO 0);
		 mem_a   : in std_logic_vector(15 downto 0);
		 rd_en  : in std_logic; 
		 wr_en  : in std_logic;
		 reset: in std_logic;
		 clk : in std_logic;
		 mem_out : out std_logic_vector(15 DOWNTO 0); 
		 mem_0 : out std_logic_vector(15 DOWNTO 0); 
		 mem_1 : out std_logic_vector(15 DOWNTO 0); 
		 mem_2 : out std_logic_vector(15 DOWNTO 0); 
		 mem_3 : out std_logic_vector(15 DOWNTO 0)
		 );
end data_memory;

architecture structure of data_memory is 


type memarr is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM : memarr := (0=>"0000000011111111",
								1=>"0000000000000101",
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
					
				end if;
				mem_out <= (others => '0');
			else 
				mem_out <= "0000000000000000";
			end if;	
					
	end process mem_proc;

	mem_0 <= RAM(0);
	mem_1 <= RAM(1);
	mem_2 <= RAM(2);
	mem_3 <= RAM(3);

end structure;

