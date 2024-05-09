library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU2 is
	port (
	     clk: in std_logic;
		  PC: IN STD_LOGIC_VECTOR(15 downto 0);
		  PCout : OUT STD_LOGIC_VECTOR(15 downto 0)
		   );
end ALU2;


architecture behave of ALU2 is
begin
 
process(PC)
variable T1: STD_LOGIC_VECTOR(15 downto 0);
begin

T1:="0000000000000001";
if (clk'event and clk = '1') then
	PCout <= STD_LOGIC_VECTOR(unsigned(PC) +unsigned(T1));
end if;
end process;
end behave;
