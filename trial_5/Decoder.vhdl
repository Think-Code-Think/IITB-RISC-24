library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
	port (Iin : in STD_LOGIC_VECTOR(15 downto 0);
		   opcode: out STD_LOGIC_VECTOR(3 downto 0); 
			RA : out STD_LOGIC_VECTOR(2 downto 0);
			RB : out STD_LOGIC_VECTOR(2 downto 0); 
			RC : out STD_LOGIC_VECTOR(2 downto 0);
			Compbit :out std_logic;
			SelAlu : out STD_LOGIC_VECTOR(1 downto 0);
		   Imm6 : out STD_LOGIC_VECTOR(5 downto 0); 	
			Imm9 : out STD_LOGIC_VECTOR(8 downto 0) 	
		   );
end Decoder;


architecture behave of Decoder is
  begin
  
      process(Iin) 
      begin
			
				opcode<=Iin(15 downto 12) ;
				case Iin(15 downto 12) is
					when "0001" | "0010"  =>
						SelAlu <=Iin(1 downto 0) ; 
						Compbit<= Iin(2);    
						RA <=Iin(11 downto 9) ;    ------A
						RB <=Iin(8 downto 6) ;     ------B
						RC <=Iin(5 downto 3) ;     ------C
						Imm6 <= "000000";
						Imm9 <= "000000000";
					
					when "0000" | "1000" | "1001" | "1010" | "0101"| "0100" |  "1101" =>
						RA <=Iin(11 downto 9) ;    ------A
						RB <=Iin(8 downto 6) ;     ------B
						RC <= "000";
						Imm6 <= Iin(5 downto 0);
						Imm9 <= "000000000";
						SelAlu <= "00";
						Compbit <= '0';
						
					when "1100" | "1111" | "0111" | "0011" | "0110"  =>
					
						RA <=Iin(11 downto 9) ;     ------A
						RB <= "000";
						RC <= "000";
						Imm6 <= "000000";
						Imm9 <= Iin(8 downto 0);
						SelAlu <= "00";
						Compbit <= '0';
						
					when others =>
						RA <= "000";
						RB <= "000";
						RC <= "000";
						Imm6 <= "000000";
						Imm9 <= "000000000";
						SelAlu <= "00";
						Compbit <= '0';
					end case;
			
--		if Iin(15 downto 12) = ("0001" | "0010" ) then----------------ADD AND NAND 
--		
--		SelAlu <=Iin(1 downto 0) ; 
--	   Compbit<= Iin(2);    
--		RA <=Iin(11 downto 9) ;    ------A
--		RB <=Iin(8 downto 6) ;     ------B
--		RC <=Iin(5 downto 3) ;     ------C
--      Imm6 <= "000000";
--		Imm9 <= "000000000";
--		END IF;
--		if Iin(15 downto 12) = ("0000" | "1000" | "1001" | "1010" | "0101"| "0100" |  "1101" ) then  ----- 6 bit immidiate case
--		
--		RA <=Iin(11 downto 9) ;    ------A
--		RB <=Iin(8 downto 6) ;     ------B
--		Imm6 <= Iin(5 downto 0);
--		Imm9 <= "000000000";
--		end if;
--		
------------------------------------------------------------------------------------------------------------------
--		if Iin(15 downto 12) = ("1100" | "1111" | "0111" | "0011" | "0110" ) then    ----- 9 bit immidiate case
--		
--		RA <=Iin(11 downto 9) ;     ------A
--      
--		Imm6 <= "000000";
--		Imm9 <= Iin(8 downto 0);
--		
--		end if;
-------------------------------------------------------------------------------------------------------------------		
		
end process ;
end behave;