library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFIDReg is
	port (
	     clk: in std_logic;
        PCin : IN STD_LOGIC_VECTOR(15 downto 0);   
		  WR_E: in std_logic;                     
        reset: in std_logic;
		  Iin : IN STD_LOGIC_VECTOR(15 downto 0); 
		  PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		  Iout : out STD_LOGIC_VECTOR(15 downto 0)
		  ) ; 
end entity;

architecture behave of IFIDReg is
  begin 
  
    process(Iin,clk,PCin,reset,WR_E) is

      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
              Iout <="0000000000000000";
              PCout<="0000000000000000";
       end if; 
		 
		 if(WR_E='1') then 
               Iout <=Iin; 
               PCout<=PCin;
             
       end if;

			 end if;
		end process;
end behave;