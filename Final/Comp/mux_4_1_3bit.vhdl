library ieee;
use ieee.std_logic_1164.all;

entity mux_4_1_3bit is
port(three,two,one,zero:in std_logic_vector(2 downto 0);
     output:out std_logic_vector(2 downto 0); 
     sel:in std_logic_vector(1 downto 0));
end entity;

architecture mux4to1 of mux_4_1_3bit is
begin
	
process(zero,one,sel,three,two)
variable temp: std_logic_vector(2 downto 0); 
begin

case sel is 
	when "00" =>
        temp:=zero;
    when "01" =>
        temp:=one;
    when "10" =>
        temp:=two;
    when "11" =>
        temp:=three;
    when others =>
        temp:="XXX";
end case;

output<= temp;

end process;

end mux4to1;

