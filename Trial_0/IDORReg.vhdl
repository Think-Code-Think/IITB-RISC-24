library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDORReg is
	port (
	     clk: in std_logic;
        PCin : IN STD_LOGIC_VECTOR(15 downto 0);    
		  WR_E: in std_logic;                        
        reset: in std_logic;
		  Iin : IN STD_LOGIC_VECTOR(15 downto 0);
        opcodein: in STD_LOGIC_VECTOR(3 downto 0);
			aRAin : in STD_LOGIC_VECTOR(2 downto 0);
			aRBin : in STD_LOGIC_VECTOR(2 downto 0); 
			aRCin : in STD_LOGIC_VECTOR(2 downto 0);
			Compbitin :in std_logic;
			SelAluin : in STD_LOGIC_VECTOR(1 downto 0);
		   Imm6in : in STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(15 downto 0); 

		  PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		  Iout : out STD_LOGIC_VECTOR(15 downto 0) ;
		   opcode: OUT STD_LOGIC_VECTOR(3 downto 0); 
			aRAout : OUT STD_LOGIC_VECTOR(2 downto 0);
			aRBout : OUT STD_LOGIC_VECTOR(2 downto 0); 
			aRCout : OUT STD_LOGIC_VECTOR(2 downto 0);
			Compbitout :out std_logic;
			SelAluout : out STD_LOGIC_VECTOR(1 downto 0);
		    Imm6out : out STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9out : out STD_LOGIC_VECTOR(15 downto 0)
			);
end IDORReg;


architecture behave of IDORReg is
  begin 
  
    process(Iin,clk,PCin,reset,WR_E,opcodein,aRAin,aRBin,aRCin, Compbitin,SelAluin, Imm6in,Imm9in) is
      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
               Iout  <="1011000000000000";
               PCout <="0000000000000000";
					opcode<="1011";
			      aRAout    <="000";
			      aRBout    <="000";
			      aRCout    <="000";
			      Compbitout<='0';
			      SelAluout <="00"; 
					Imm6out    <="0000000000000000";
					Imm9out    <="0000000000000000";
       end if; 
		 
		 if(WR_E='1') then 
               Iout <=Iin; 
               PCout<=PCin;
               opcode<=opcodein;
			      aRAout    <=aRAin;
			      aRBout    <=aRBin;
			      aRCout    <=aRcin;
			      Compbitout<=Compbitin;
			      SelAluout <= SelAluin;
		         Imm6out    <=Imm6in;
					Imm9out    <=Imm9in;
       end if;
			 end if;
		end process;
end behave;