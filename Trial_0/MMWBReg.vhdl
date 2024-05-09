library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MMWBReg is
port    (
	      clk: in std_logic;
         PCin : in std_logic_vector(15 downto 0);   
		   WR_E: in std_logic;                         
         reset: in std_logic;
		   Iin : in std_logic_vector(15 downto 0);
         opcodein: in std_logic_vector(3 downto 0); 
			MMoutin : in std_logic_vector(15 downto 0);
		   aluCin : in std_logic_vector(15 downto 0);
			Imm6in : in std_logic_vector(15 downto 0); 	
			Imm9in : in std_logic_vector(15 downto 0);
			aRAin : in std_logic_vector(2 downto 0);
			aRBin : in std_logic_vector(2 downto 0);
			aRCin : in std_logic_vector(2 downto 0);

		   PCout : out std_logic_vector(15 downto 0); 
		   Iout : out std_logic_vector(15 downto 0) ;
		   opcode: out std_logic_vector(3 downto 0); 
			aluCout : out std_logic_vector(15 downto 0);
		   MMoutout : out std_logic_vector(15 downto 0);
		   aRAout : out std_logic_vector(2 downto 0);
		   aRBout : out std_logic_vector(2 downto 0);
			aRCout : out std_logic_vector(2 downto 0);
		   Imm6out : out std_logic_vector(15 downto 0); 	
			Imm9out : out std_logic_vector(15 downto 0)
			);
end MMWBReg;


architecture behave of MMWBReg is
  begin 
  
    process(Iin,clk,PCin,reset,WR_E,opcodein,aluCin ,Imm6in,Imm9in,aRAin,aRBin,aRCin ,MMoutin) is
	  variable T1, compvalue,One: std_logic_vector(15 downto 0);
      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
               Iout  <="1011000000000000";
               PCout <="0000000000000000"  ;
					opcode<="1011";
			      aluCout<="0000000000000000";
					MMoutout<="0000000000000000";
					aRAout <="000";
					aRCout <="000";
					aRBout <="000";
					Imm6out<="0000000000000000";
					Imm9out<="0000000000000000";	
       end if; 
		 
		 if(WR_E='1') then 
               Iout    <=Iin; 
               PCout   <=PCin;
               opcode  <=opcodein;
			      aluCout <=aluCin;
			      MMoutout<= MMoutin;
		         aRAout  <=aRAin;
					aRBout  <=aRBin;
					aRCout  <=aRCin;
					Imm6out <=Imm6in;
					Imm9out <=Imm9in;
       end if;
			 end if;
		end process;
end behave;