library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiple_Reg is
	port (
	     clk: in std_logic;
		  Imm9_16bit : IN STD_LOGIC_VECTOR(15 downto 0);
		  WR_E_M: in std_logic;                     
        reset: in std_logic;
		  Reg_Add_out : out STD_LOGIC_VECTOR(2 downto 0); 
		  Mem_Imm_out : out STD_LOGIC_VECTOR(15 downto 0);
		  Imm_at_RegAdd_out : out std_logic
		  ) ; 
end entity;

architecture behave of Multiple_Reg is

	signal Reg_Add_temp : std_logic_vector(2 downto 0) := "111";
   signal Mem_Imm_temp : std_logic_vector(15 downto 0) := "0000000000000000";
	signal Imm_at_RegAdd_temp : std_logic;
	
	 
  begin 
			
    process(clk,Imm9_16bit,reset,WR_E_M) is
		variable T1: STD_LOGIC_VECTOR(15 downto 0);
		variable T2: STD_LOGIC_VECTOR(2 downto 0);
		
		
      begin
		T1:="0000000000000001";
		T2:= "001";
		if (clk'event and clk = '1') then
		  
			 if(reset='1') then
					  Reg_Add_temp <="111";
					  Mem_Imm_temp<="0000000000000000";
			 end if;
			if(WR_E_M='1') then
						if (Imm_at_RegAdd_temp = '1') then 
							Mem_Imm_temp  <= STD_LOGIC_VECTOR(unsigned(Mem_Imm_temp) +unsigned(T1));
						end if;
						Reg_Add_temp  <= STD_LOGIC_VECTOR(unsigned(Reg_Add_temp) - unsigned(T2));
						
--						
--							
			end if;
		end if;
		end process;
		
		reg_to_imm_map: process(Reg_Add_temp,Imm9_16bit) is
		begin
			case Reg_Add_temp is
						
							when "111" => 
								Imm_at_RegAdd_temp <= Imm9_16bit(0);
							when "110" => 
								Imm_at_RegAdd_temp <= Imm9_16bit(1);
							when "101" => 
								Imm_at_RegAdd_temp <= Imm9_16bit(2);
							when "100" => 
								Imm_at_RegAdd_temp <= Imm9_16bit(3);
							when "011" => 
								Imm_at_RegAdd_temp <= Imm9_16bit(4);
							when "010" => 
								Imm_at_RegAdd_temp <= Imm9_16bit(5);
							when "001" => 
								Imm_at_RegAdd_temp <= Imm9_16bit(6);
							when "000" => 
								Imm_at_RegAdd_temp <= Imm9_16bit(7);
							when others =>
								null;
						end case;
		end process reg_to_imm_map;

		
	  Reg_Add_out <=Reg_Add_temp;
	  Imm_at_RegAdd_out	<= Imm_at_RegAdd_temp;

	  Mem_Imm_out <=Mem_Imm_temp;
		
end behave;