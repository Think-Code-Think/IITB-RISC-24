library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OREXReg is
port(
	      clk: in std_logic;
         PCin : in STD_LOGIC_VECTOR(15 downto 0);    
		   WR_E: in std_logic;                        
         reset: in std_logic;
		   Iin : in STD_LOGIC_VECTOR(15 downto 0);
         opcodein: in STD_LOGIC_VECTOR(3 downto 0); 
			RAin : in STD_LOGIC_VECTOR(15 downto 0);   
			RBin : in STD_LOGIC_VECTOR(15 downto 0); 
			Compbitin :in std_logic;
			SelAluin : in STD_LOGIC_VECTOR(1 downto 0);
		   Imm6in : in STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(15 downto 0);
		   aRAin : in STD_LOGIC_VECTOR(2 downto 0);	
			aRBin : in STD_LOGIC_VECTOR(2 downto 0);
			aRCin : in STD_LOGIC_VECTOR(2 downto 0);
			Dest_reg_add_in : in STD_LOGIC_VECTOR(2 downto 0);
			Reg_Add_M_in: in STD_LOGIC_VECTOR(2 downto 0);
			Mem_Imm_M_in:  in STD_LOGIC_VECTOR(15 downto 0); 	
			Bit_Reg_Add_in: in STD_LOGIC;
			Cin : in std_logic;
			Zin : in std_logic;
			
		   PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		   Iout : out STD_LOGIC_VECTOR(15 downto 0) ;
		   opcode: out STD_LOGIC_VECTOR(3 downto 0); 
			RA : out STD_LOGIC_VECTOR(15 downto 0);
			RB : out STD_LOGIC_VECTOR(15 downto 0); 
--			RC : out STD_LOGIC_VECTOR(15 downto 0);
			Compbit :out std_logic;
			aRAout : out STD_LOGIC_VECTOR(2 downto 0);
			aRBout : out STD_LOGIC_VECTOR(2 downto 0);
			aRCout : out STD_LOGIC_VECTOR(2 downto 0);
			Dest_reg_add_out : out STD_LOGIC_VECTOR(2 downto 0);
			SelAlu : out STD_LOGIC_VECTOR(1 downto 0);
		   Imm6out : out STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9out : out STD_LOGIC_VECTOR(15 downto 0);
			Reg_Add_M_out: out STD_LOGIC_VECTOR(2 downto 0);
			Mem_Imm_M_out:  out STD_LOGIC_VECTOR(15 downto 0); 	
			Bit_Reg_Add_out: out STD_LOGIC;
			Cout : out std_logic;
			Zout : out std_logic
			);
end OREXReg;


architecture behave of OREXReg is
  begin 
  
    process(Iin,clk,PCin,reset,WR_E,opcodein,RAin,RBin, Compbitin,SelAluin, Imm6in,Imm9in,aRBin,aRCin,
										Bit_Reg_Add_in,Mem_Imm_M_in,Reg_Add_M_in,Dest_reg_add_in ) is
	  variable T1, compvalue,One: STD_LOGIC_VECTOR(15 downto 0);
      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
               Iout  <="1011000000000000";
               PCout <="0000000000000000";
					opcode<="1011";
			      RA    <="0000000000000000";
			      RB    <="0000000000000000";
			      Compbit<='0';
			      SelAlu <="00";
					aRAout <="000";
					aRCout <="000";
					aRBout <="000";
					Dest_reg_add_out <= "000";
			
					Imm6out    <="0000000000000000";
					Imm9out    <="0000000000000000";
					Reg_Add_M_out <= "000";
					Mem_Imm_M_out <= "0000000000000000";
					Bit_Reg_Add_out <= '0';
					Cout <= '0';
					Zout <= '0';
       end if; 
		 
		 if(WR_E='1') then 
               Iout <=Iin; 
               PCout<=PCin;
               opcode<=opcodein;
			      RA    <=RAin;
			      RB    <=RBin;
			      Compbit<=Compbitin;
			      SelAlu <= SelAluin;
					aRAout <=aRAin;
					aRBout <=aRBin;
					aRCout <=aRCin;
					Dest_reg_add_out <= Dest_reg_add_in;
					Imm6out    <=Imm6in;
					Imm9out    <=Imm9in;
					Reg_Add_M_out <= Reg_Add_M_in;
					Mem_Imm_M_out <= Mem_Imm_M_in;
					Bit_Reg_Add_out <= Bit_Reg_Add_in;
					Cout <= Cin;
					Zout <= Zin;
       end if;
  
		  
			 end if;
		end process;
end behave;