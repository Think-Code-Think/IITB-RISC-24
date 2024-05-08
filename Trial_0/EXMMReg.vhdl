library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXMMReg is
	port (
	      clk: in std_logic;
         PCin : in STD_LOGIC_VECTOR(15 downto 0);    
		   WR_E: in std_logic;                          
         reset: in std_logic;
		   Iin : in STD_LOGIC_VECTOR(15 downto 0);
         opcodein: in STD_LOGIC_VECTOR(3 downto 0);
			aluCin : in STD_LOGIC_VECTOR(15 downto 0);
			RAin : in STD_LOGIC_VECTOR(15 downto 0);   
		   Imm6in : in STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(15 downto 0);
			aRAin : in STD_LOGIC_VECTOR(2 downto 0);
			aRBin : in STD_LOGIC_VECTOR(2 downto 0);
			aRCin : in STD_LOGIC_VECTOR(2 downto 0);

		   PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		   Iout : out STD_LOGIC_VECTOR(15 downto 0) ; 
		   opcode: OUT STD_LOGIC_VECTOR(3 downto 0); 
			aluCout : out STD_LOGIC_VECTOR(15 downto 0);
			RA : out STD_LOGIC_VECTOR(15 downto 0);
			aRAout : out STD_LOGIC_VECTOR(2 downto 0);
		   aRBout : out STD_LOGIC_VECTOR(2 downto 0);
			aRCout : out STD_LOGIC_VECTOR(2 downto 0);
		   Imm6out : out STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9out : out STD_LOGIC_VECTOR(15 downto 0)
			);
end EXMMReg;


architecture behave of EXMMReg is
  begin 
  
    process(Iin,clk,PCin,reset,WR_E,opcodein,aluCin ,Imm6in,Imm9in,aRAin,aRBin,aRCin) is
      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
               Iout  <="0000000000000000";
               PCout <="0000000000000000"  ;
					opcode<="0000";
			      aluCout<="0000000000000000"; 
					aRAout<="000";
					aRCout <="000";
					aRBout <="000";
					Imm6out    <="0000000000000000";
					Imm9out    <="0000000000000000";
       end if; 
		 
		 if(WR_E='1') then 
               Iout <=Iin; 
               PCout<=PCin;
               opcode<=opcodein;
			      aluCout<=aluCin;
					aRAout <=aRAin;
					aRBout <=aRBin;
					aRCout <=aRCin;
					Imm6out<=Imm6in;
					Imm9out<=Imm9in;
       end if;
  
		  
			 end if;
		end process;
end behave;