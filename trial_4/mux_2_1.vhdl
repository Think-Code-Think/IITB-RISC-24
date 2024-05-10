library ieee;
use ieee.std_logic_1164.all;
entity mux_2_1  is
  port (I0 ,I1: in std_logic_vector(15 downto 0);
        S0: in std_logic;
		  mux_out: out std_logic_vector(15 downto 0)
		 );
end entity mux_2_1;

architecture mux2to1 of mux_2_1 is
begin
	
process(I0,I1,S0)
variable temp: std_logic_vector(15 downto 0); 
begin

case S0 is 
	when '0' =>
        temp:=I0;
    when '1' =>
        temp:=I1;
    when others =>
        temp:="XXXXXXXXXXXXXXXX";
end case;

mux_out<= temp;

end process;
end mux2to1;