library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MMWBReg is
port    (
	      clk: in std_logic;
         PCin : in std_logic_vector(15 downto 0);   
		   WR_E: in std_logic;                         
         reset: in std_logic;
         opcodein: in std_logic_vector(3 downto 0); 
			MMoutin : in std_logic_vector(15 downto 0);
		   aluCin : in std_logic_vector(15 downto 0); 	
			Imm9in : in std_logic_vector(15 downto 0);
			Dest_reg_add_in : in STD_LOGIC_VECTOR(2 downto 0);
         write_reg_in : in std_logic;
			
		   PCout : out std_logic_vector(15 downto 0); 
		   opcode: out std_logic_vector(3 downto 0); 
			aluCout : out std_logic_vector(15 downto 0);
		   MMoutout : out std_logic_vector(15 downto 0);
			Dest_reg_add_out : out STD_LOGIC_VECTOR(2 downto 0);	
			Imm9out : out std_logic_vector(15 downto 0);
			write_reg_out : out std_logic
			);
end MMWBReg;


architecture behave of MMWBReg is
  begin 
  
    process(clk,PCin,reset,WR_E,opcodein,aluCin ,Imm9in ,MMoutin,Dest_reg_add_in ) is
	  variable T1, compvalue,One: std_logic_vector(15 downto 0);
      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
               PCout <="0000000000000000"  ;
					opcode<="1011";
			      aluCout<="0000000000000000";
					MMoutout<="0000000000000000";
					Dest_reg_add_out <= "000";
					Imm9out<="0000000000000000";
				   write_reg_out <= '0';	
       end if; 
		 
		 if(WR_E='1') then 
               PCout   <=PCin;
               opcode  <=opcodein;
			      aluCout <=aluCin;
			      MMoutout<= MMoutin;
					Dest_reg_add_out <= Dest_reg_add_in;
					Imm9out <=Imm9in;
					write_reg_out <= write_reg_in;
       end if;
			 end if;
		end process;
end behave;