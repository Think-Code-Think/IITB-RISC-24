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
			Dest_reg_add_in : in STD_LOGIC_VECTOR(2 downto 0);
			Reg_Add_M_in: in STD_LOGIC_VECTOR(2 downto 0);	
			Bit_Reg_Add_in: in STD_LOGIC;
			Cin : in std_logic;
			Zin : in std_logic;
         write_reg_in : in std_logic;
			
		   PCout : out std_logic_vector(15 downto 0); 
		   Iout : out std_logic_vector(15 downto 0) ;
		   opcode: out std_logic_vector(3 downto 0); 
			aluCout : out std_logic_vector(15 downto 0);
		   MMoutout : out std_logic_vector(15 downto 0);
		   aRAout : out std_logic_vector(2 downto 0);
		   aRBout : out std_logic_vector(2 downto 0);
			aRCout : out std_logic_vector(2 downto 0);
			Dest_reg_add_out : out STD_LOGIC_VECTOR(2 downto 0);
		   Imm6out : out std_logic_vector(15 downto 0); 	
			Imm9out : out std_logic_vector(15 downto 0);
			Reg_Add_M_out: out STD_LOGIC_VECTOR(2 downto 0); 	
			Bit_Reg_Add_out: out STD_LOGIC;
			Cout : out std_logic;
			Zout : out std_logic;
			write_reg_out : out std_logic
			);
end MMWBReg;


architecture behave of MMWBReg is
  begin 
  
    process(Iin,clk,PCin,reset,WR_E,opcodein,aluCin ,Imm6in,Imm9in,aRAin,aRBin,aRCin ,MMoutin,Bit_Reg_Add_in,Reg_Add_M_in,Dest_reg_add_in ) is
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
					Dest_reg_add_out <= "000";
					Imm6out<="0000000000000000";
					Imm9out<="0000000000000000";
					Reg_Add_M_out <= "000";
					Bit_Reg_Add_out <= '0';
				   Cout <= '0';
					Zout <= '0';
				   write_reg_out <= '0';	
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
					Dest_reg_add_out <= Dest_reg_add_in;
					Imm6out <=Imm6in;
					Imm9out <=Imm9in;
					Reg_Add_M_out <= Reg_Add_M_in;
					Bit_Reg_Add_out <= Bit_Reg_Add_in;
					Cout <= Cin;
					Zout <= Zin;
					write_reg_out <= write_reg_in;
       end if;
			 end if;
		end process;
end behave;