library ieee;
use ieee.std_logic_1164.all;


package Components is

-------------------------------------------------------------------------------------------------------
component Register_File is 
port(  
        A1 : in std_logic_vector(2 downto 0); 
        A2 : in std_logic_vector(2 downto 0); 
        A3 : in std_logic_vector(2 downto 0); 
        D3 : in std_logic_vector(15 downto 0);
		  R0in : in std_logic_vector(15 downto 0);
		  WR_E_R0: in std_logic;
        WR_E : in std_logic; 
        reset : in std_logic;
        clk : in std_logic; 
        D1 : out std_logic_vector(15 downto 0); 
        D2 : out std_logic_vector(15 downto 0); 
        R0_PC : out std_logic_vector(15 downto 0)  
    );
end component;
---------------------------------------------------------------------------------------------
component instruction_memory is 
port(
		  mem_add :  in std_logic_vector(15 downto 0);
		  reset   : in std_logic;
		  mem_out : out std_logic_vector(15 downto 0)
	 ); 
end component;
---------------------------------------------------------------------------------------------
component ALU is
port (
        opcode : in std_logic_vector(3 downto 0);     
        c_in, z_in, CompBit,Bit_Reg_Add_in : in std_logic;         
        C_z : in std_logic_vector(1 downto 0);
        ALU_A, ALU_B : in std_logic_vector(15 downto 0);
        ALU_C : out std_logic_vector(15 downto 0);  
        carry, zero, equal, less, write_reg : out std_logic
    );
end component;
------------------------------------------------------------------------------------------------
component ALU2 is
	port (
		  PC: in std_logic_vector(15 downto 0);
		  PCout : out std_logic_vector(15 downto 0)
		   );
end component;
----------------------------------------------------------------------------------------------------
component ALU3 is
    Port (
	     PC, Imm: in std_logic_vector(15 downto 0);
		  PCImm2: out std_logic_vector(15 downto 0)
    );
end component;
------------------------------------------------------------------------------------------------------
component Decoder is
	port (Iin : in std_logic_VECTOR(15 downto 0);
		   opcode: out std_logic_VECTOR(3 downto 0); 
			RA : out std_logic_VECTOR(2 downto 0);
			RB : out std_logic_VECTOR(2 downto 0); 
			RC : out std_logic_VECTOR(2 downto 0);
			Compbit :out std_logic;
			SelAlu : out std_logic_VECTOR(1 downto 0);
		   Imm6 : out std_logic_VECTOR(5 downto 0); 	
			Imm9 : out std_logic_VECTOR(8 downto 0) 	
		   );
end component;
---------------------------------------------------------------------------------------------------------
component SE6 is
port (
        Imm6in: in std_logic_vector(5 downto 0);
        Imm6out: out std_logic_vector(15 downto 0)
     );
end component;
---------------------------------------------------------------------------------------------------------
component SE9 is
port (
        Imm9in: in std_logic_vector(8 downto 0);
        Imm9out: out std_logic_vector(15 downto 0)
    );
end component;
---------------------------------------------------------------------------------------------------------
component SHIFTER is 
port (input: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(15 downto 0)
		);
end component;
---------------------------------------------------------------------------------------------------------
component ForwardingUnit is
	port(
		EX_dest_reg_add: in std_logic_vector(2 downto 0);
		MM_dest_reg_add: in std_logic_vector(2 downto 0);
		WB_dest_reg_add : in std_logic_vector(2 downto 0);
		OR_source_reg_add : in std_logic_vector(2 downto 0);
		OR_source_reg_data: in std_logic_vector(15 downto 0);
		EX_aluc : in std_logic_vector(15 downto 0);
		EX_Imm9_16bit : in std_logic_vector(15 downto 0);
		MM_mem_out : in std_logic_vector(15 downto 0);
		MEM_aluc : in std_logic_vector(15 downto 0);
		MEM_Imm9_16bit : in std_logic_vector(15 downto 0);
		WB_RFD3 : in std_logic_vector(15 downto 0);
		EX_opcode : in std_logic_vector(3 downto 0);
		MM_opcode : in std_logic_vector(3 downto 0);
		EX_instr_wr_reg, MM_instr_wr_reg, WB_instr_wr_reg: in std_logic;
		
		fwd_reg_val : out std_logic_vector(15 downto 0);
		hold_or_fwd: out std_logic
	);
end component;
---------------------------------------------------------------------------------------------------------
component R0PCForwardingUnit is
	port(
		EX_dest_reg_add: in std_logic_vector(2 downto 0);
		MM_dest_reg_add: in std_logic_vector(2 downto 0);
		PC_selected_without_fwd: in std_logic_vector(15 downto 0);
		EX_aluc : in std_logic_vector(15 downto 0);
		EX_Imm9_16bit : in std_logic_vector(15 downto 0);
		MM_mem_out : in std_logic_vector(15 downto 0);
		EX_opcode : in std_logic_vector(3 downto 0);
		MM_opcode : in std_logic_vector(3 downto 0);
		EX_instr_wr_reg, MM_instr_wr_reg: in std_logic;
		
		pc_out : out std_logic_vector(15 downto 0);
		flush_id_or_ex: out std_logic;
		flush_mem: out std_logic
	);
end component;
---------------------------------------------------------------------------------------------------------
component IFIDReg is
port (
	     clk: in std_logic;
        PCin : in std_logic_vector(15 downto 0);   
		  WR_E: in std_logic;                     
        reset: in std_logic;
		  Iin : in std_logic_vector(15 downto 0);
		  
		  PCout : out std_logic_vector(15 downto 0); 
		  Iout : out std_logic_vector(15 downto 0)
		  );  
end component;
--------------------------------------------------------------------------------------------------------
component IDORReg is
port (
	      clk: in std_logic;
         PCin : IN std_logic_VECTOR(15 downto 0);    
		   WR_E: in std_logic;                        
         reset: in std_logic;
         opcodein: in std_logic_VECTOR(3 downto 0);
			aRAin : in std_logic_VECTOR(2 downto 0);
			aRBin : in std_logic_VECTOR(2 downto 0); 
			aRCin : in std_logic_VECTOR(2 downto 0);
			Compbitin :in std_logic;
			SelAluin : in std_logic_VECTOR(1 downto 0);
		   Imm6in : in std_logic_VECTOR(15 downto 0); 	
			Imm9in : in std_logic_VECTOR(15 downto 0); 

		   PCout : out std_logic_VECTOR(15 downto 0); 
		   opcode: OUT std_logic_VECTOR(3 downto 0); 
			aRAout : OUT std_logic_VECTOR(2 downto 0);
			aRBout : OUT std_logic_VECTOR(2 downto 0); 
			aRCout : OUT std_logic_VECTOR(2 downto 0);
			Compbitout :out std_logic;
			SelAluout : out std_logic_VECTOR(1 downto 0);
		   Imm6out : out std_logic_VECTOR(15 downto 0); 	
			Imm9out : out std_logic_VECTOR(15 downto 0)
			);
end component;
-------------------------------------------------------------------------------------------------------
component OREXReg is
port(
	      clk: in std_logic;
         PCin : in std_logic_VECTOR(15 downto 0);    
		   WR_E: in std_logic;                        
         reset: in std_logic;
         opcodein: in std_logic_VECTOR(3 downto 0); 
			RAin : in std_logic_VECTOR(15 downto 0);   
			RBin : in std_logic_VECTOR(15 downto 0); 
			Compbitin :in std_logic;
			SelAluin : in std_logic_VECTOR(1 downto 0);
		   Imm6in : in std_logic_VECTOR(15 downto 0); 	
			Imm9in : in std_logic_VECTOR(15 downto 0);
			Dest_reg_add_in : in std_logic_VECTOR(2 downto 0);
			Mem_Imm_M_in:  in std_logic_VECTOR(15 downto 0); 	
			Bit_Reg_Add_in: in std_logic;
			Cin : in std_logic;
			Zin : in std_logic;
			
		   PCout : out std_logic_VECTOR(15 downto 0); 
		   opcode: out std_logic_VECTOR(3 downto 0); 
			RA : out std_logic_VECTOR(15 downto 0);
			RB : out std_logic_VECTOR(15 downto 0); 
			Compbit :out std_logic;
			Dest_reg_add_out : out std_logic_VECTOR(2 downto 0);
			SelAlu : out std_logic_VECTOR(1 downto 0);
		   Imm6out : out std_logic_VECTOR(15 downto 0); 	
			Imm9out : out std_logic_VECTOR(15 downto 0);
			Mem_Imm_M_out:  out std_logic_VECTOR(15 downto 0); 	
			Bit_Reg_Add_out: out std_logic;
			Cout : out std_logic;
			Zout : out std_logic
			);
end component;
----------------------------------------------------------------------------------------------------------
component EXMMReg is
port (
	      clk: in std_logic;
         PCin : in std_logic_VECTOR(15 downto 0);    
		   WR_E: in std_logic;                          
         reset: in std_logic;
         opcodein: in std_logic_VECTOR(3 downto 0);
			aluCin : in std_logic_VECTOR(15 downto 0);
			RAin : in std_logic_VECTOR(15 downto 0);   
			RBin : in std_logic_VECTOR(15 downto 0);   	
			Imm9in : in std_logic_VECTOR(15 downto 0);
			Dest_reg_add_in : in std_logic_VECTOR(2 downto 0);	
			Bit_Reg_Add_in: in std_logic;
			write_reg_in : in std_logic;

		   PCout : out std_logic_VECTOR(15 downto 0); 
		   opcode: OUT std_logic_VECTOR(3 downto 0); 
			aluCout : out std_logic_VECTOR(15 downto 0);
			RAout : out std_logic_VECTOR(15 downto 0);
			RBout : out std_logic_VECTOR(15 downto 0);
			Dest_reg_add_out : out std_logic_VECTOR(2 downto 0);	
			Imm9out : out std_logic_VECTOR(15 downto 0);	
			Bit_Reg_Add_out: out std_logic;
			write_reg_out : out std_logic
			);
end component;

--------------------------------------------------------------------------------------------------------------
component MMWBReg is
port (
	      clk: in std_logic;
         PCin : in std_logic_vector(15 downto 0);   
		   WR_E: in std_logic;                         
         reset: in std_logic;
         opcodein: in std_logic_vector(3 downto 0); 
			MMoutin : in std_logic_vector(15 downto 0);
		   aluCin : in std_logic_vector(15 downto 0); 	
			Imm9in : in std_logic_vector(15 downto 0);
			Dest_reg_add_in : in std_logic_VECTOR(2 downto 0);
         write_reg_in : in std_logic;
			
		   PCout : out std_logic_vector(15 downto 0); 
		   opcode: out std_logic_vector(3 downto 0); 
			aluCout : out std_logic_vector(15 downto 0);
		   MMoutout : out std_logic_vector(15 downto 0);
			Dest_reg_add_out : out std_logic_VECTOR(2 downto 0);	
			Imm9out : out std_logic_vector(15 downto 0);
			write_reg_out : out std_logic
			);
end component;
---------------------------------------------------------------------------------------------------------------
component data_memory is                                                                    
port(
		 mem_d   : in std_logic_vector(15 downto 0);
		 mem_a   : in std_logic_vector(15 downto 0);
		 rd_en  : in std_logic; 
		 wr_en  : in std_logic; 
		 reset: in std_logic; 
		 clk : in std_logic;
		 mem_out : out std_logic_vector(15 downto 0); 
		 mem_0 : out std_logic_vector(15 downto 0); 
		 mem_1 : out std_logic_vector(15 downto 0); 
		 mem_2 : out std_logic_vector(15 downto 0); 
		 mem_3 : out std_logic_vector(15 downto 0)
		 );
end component;

------------------------------------------------------------------------------------------------------------
component mux_4_1 is
port(
		three,two,one,zero:in std_logic_vector(15 downto 0);
      output:out std_logic_vector(15 downto 0); 
      sel:in std_logic_vector(1 downto 0)
	 );
end component;

------------------------------------------------------------------------------------------------------------
component mux_2_1  is
port (
		  I0 ,I1: in std_logic_vector(15 downto 0);
        S0: in std_logic;
		  mux_out: out std_logic_vector(15 downto 0)
	  );
end component;
---------------------------------------------------------------------------------------------------------
component mux_2_1_3bit  is
  port (I0 ,I1: in std_logic_vector(2 downto 0);
        S0: in std_logic;
		  mux_out: out std_logic_vector(2 downto 0)
		 );
end component;
------------------------------------------------------------------------------------------------------------
component mux_4_1_3bit is
port(
     three,two,one,zero:in std_logic_vector(2 downto 0);
     output:out std_logic_vector(2 downto 0); 
     sel:in std_logic_vector(1 downto 0)
	 );
end component;
------------------------------------------------------------------------------------------------------------
component Multiple_Reg is
	port (
	     clk: in std_logic;
		  Imm9_16bit : IN std_logic_VECTOR(15 downto 0);
		  WR_E_M: in std_logic;                     
        reset: in std_logic;
		  Reg_Add_out : out std_logic_VECTOR(2 downto 0); 
		  Mem_Imm_out : out std_logic_VECTOR(15 downto 0);
		  Imm_at_RegAdd_out : out std_logic
		  ) ; 
end component;

end package Components;
----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU2 is
port   (
		  PC: IN STD_LOGIC_VECTOR(15 downto 0);
		  PCout : OUT STD_LOGIC_VECTOR(15 downto 0)
		   );
end ALU2;

architecture inside of ALU2 is

    function add_sub(
        PC: in STD_LOGIC_VECTOR(15 downto 0);
		  Imm :in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000001")
		  return std_logic_vector is
        variable temp_sum : STD_LOGIC_VECTOR(15 downto 0);
        variable sum : std_logic_vector(16 downto 0) := (others => '0');
		  variable carry : std_logic;
    begin
        carry := '0';
        for i in 0 to 15 loop
                temp_sum(i) := (PC(i) XOR Imm(i)) XOR carry;
                carry := (PC(i) AND Imm(i)) OR ((PC(i) OR Imm(i)) AND carry);
        end loop;
        sum(15 downto 0) := temp_sum;
		  sum(16) := carry;
        return sum;
    end function add_sub;

begin
    ALU2: process(PC)
	 variable temp: STD_LOGIC_VECTOR(16 downto 0);
    begin
            temp := add_sub(PC, "0000000000000001");
				PCout <= temp(15 downto 0);
    end process ALU2;

end architecture inside;
------------------------------------------------------------------------------------------------------------------------

library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is 
port(
	  mem_add :  in std_logic_vector(15 downto 0);
	  reset: in STD_LOGIC;
	  mem_out : out std_logic_vector(15 downto 0)
	  );
end instruction_memory;

architecture structure of instruction_memory is 


type memarr is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM : memarr := (0=>"0011100000000000",
								1=>"0100001100000000",
								2=>"0100010100000001",
								3=>"0011110000000001",
								4=>"1000010100000011",
								5=>"0001011001011000",
								6=>"0001101100101011",
								7=>"0001010110010111",
								8=>"1100111111111110",
								9=>"1011011000000101",
								10=>"0101101100000010",
								11=>"0101011100000011",
								12=>"1110000000000011",
								others => "1011000101001100");
signal addr : std_logic_vector(4 downto 0);

begin
	process(reset,RAM,mem_add,addr) 
	begin
		if (reset = '1') then
			mem_out <= "1011000000000000";
		else
			addr <= mem_add(4 downto 0);
			mem_out <= RAM(to_integer(unsigned(addr)));
		end if;
	end process;
end structure;

-------------------------------------------------------------------------------------------------

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
              Iout <="1011000000000000";
              PCout<="0000000000000000";
       end if; 
		 
		 if(WR_E='1') then 
               Iout <=Iin; 
               PCout<=PCin;
             
       end if;

			 end if;
		end process;
end behave;

------------------------------------------

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
						RA <=Iin(11 downto 9) ;    
						RB <=Iin(8 downto 6) ;     
						RC <=Iin(5 downto 3) ;     
						Imm6 <= "000000";
						Imm9 <= "000000000";
					
					when "0000" | "1000" | "1001" | "1010" | "0101"| "0100" |  "1101" =>
						RA <=Iin(11 downto 9) ;    
						RB <=Iin(8 downto 6) ;     
						RC <= "000";
						Imm6 <= Iin(5 downto 0);
						Imm9 <= "000000000";
						SelAlu <= "00";
						Compbit <= '0';
						
					when "1100" | "1111" | "0111" | "0011" | "0110"  =>
					
						RA <=Iin(11 downto 9) ;     
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

end process ;
end behave;

-------------------------------------------------------------------------------------------------------------------	

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDORReg is
	port (
	     clk: in std_logic;
        PCin : IN STD_LOGIC_VECTOR(15 downto 0);    
		  WR_E: in std_logic;                        
        reset: in std_logic;
        opcodein: in STD_LOGIC_VECTOR(3 downto 0);
			aRAin : in STD_LOGIC_VECTOR(2 downto 0);
			aRBin : in STD_LOGIC_VECTOR(2 downto 0); 
			aRCin : in STD_LOGIC_VECTOR(2 downto 0);
			Compbitin :in std_logic;
			SelAluin : in STD_LOGIC_VECTOR(1 downto 0);
		   Imm6in : in STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(15 downto 0); 

		  PCout : out STD_LOGIC_VECTOR(15 downto 0); 
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
  
    process(clk,PCin,reset,WR_E,opcodein,aRAin,aRBin,aRCin, Compbitin,SelAluin, Imm6in,Imm9in) is
      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
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
------

library ieee;
use ieee.std_logic_1164.all;
library work;
entity SE6 is
port(
        Imm6in: in std_logic_vector(5 downto 0);
        Imm6out: out std_logic_vector(15 downto 0)
    );
end entity SE6;

architecture extender of SE6 is
begin
    conv_process: process(Imm6in)
    begin
            if (Imm6in(5) = '0') then
                Imm6out <= "0000000000" & Imm6in;
            else 
                Imm6out <= "1111111111" & Imm6in;
            end if;
    end process;
end extender;
--------

library ieee;
use ieee.std_logic_1164.all;
library work;
entity SE9 is
port (
        Imm9in: in std_logic_vector(8 downto 0);
        Imm9out: out std_logic_vector(15 downto 0)
     );
end entity SE9;

architecture extender of SE9 is
begin
    conv_process: process(Imm9in)
    begin
            if (Imm9in(5) = '0') then
                Imm9out <= "0000000" & Imm9in;
            else 
                Imm9out <= "1111111" & Imm9in;
            end if;
    end process;
end extender;
-----------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Register_File is 
port(  
        A1 : in std_logic_vector(2 downto 0); 
        A2 : in std_logic_vector(2 downto 0); 
        A3 : in std_logic_vector(2 downto 0); 
        D3 : in std_logic_vector(15 downto 0);
		  R0in : in std_logic_vector(15 downto 0);
		  WR_E_R0: in std_logic;
        WR_E : in std_logic; 
        reset : in std_logic;
        clk : in std_logic; 
        D1 : out std_logic_vector(15 downto 0); 
        D2 : out std_logic_vector(15 downto 0); 
        R0_PC : out std_logic_vector(15 downto 0)  
    );
end entity;

architecture inside of Register_File is    
	     signal R0 : std_logic_vector(15 downto 0) ;
		 signal R1 : std_logic_vector(15 downto 0) ;
		 signal R2 : std_logic_vector(15 downto 0) ;
		 signal R3 : std_logic_vector(15 downto 0) ;
		 signal R4 : std_logic_vector(15 downto 0) ;
		 signal R5 : std_logic_vector(15 downto 0) ;
		 signal R6 : std_logic_vector(15 downto 0) ;
		 signal R7 : std_logic_vector(15 downto 0) ;
begin
    
write_process: process(A3,WR_E,clk,reset,WR_E_R0,R0in) 


    begin
	 
	    if(reset = '1') then           
            R0 <= "0000000000000000";
            R1 <= "0000000000000000";
            R2 <= "0000000000000000";
            R3 <= "0000000000000000";
            R4 <= "0000000000000000";
            R5 <= "0000000000000000";
            R6 <= "0000000000000000";
            R7 <= "0000000000000000";
				
elsif (clk'event and clk = '1') then   
   if(WR_E_R0 = '1') then
      R0 <= R0in;
   end if;						  
	if(WR_E = '1') then
				
                if(A3 = "000") then     
                    R0 <= D3;
                
                elsif(A3 = "001") then
                    R1 <= D3;
						  
                elsif(A3 = "010") then
                    R2 <= D3;
						  
                elsif(A3 = "011") then
                    R3 <= D3;

                elsif(A3 = "100") then
                    R4 <= D3;

                elsif(A3 = "101") then
                    R5 <= D3;
	
                elsif(A3 = "110") then
                    R6 <= D3;
 		 
                elsif(A3 = "111") then
                    R7 <= D3;
						else
							null;
                end if;
    end if;
end if;
end process write_process;
	 
read_process: process(A1,A2,R0,R1,R2,R3,R4,R5,R6,R7) 

begin
        
            if(A1 = "000")    then  
                D1 <= R0;
            elsif(A1 = "001") then
                D1 <= R1;
            elsif(A1 = "010") then
                D1 <= R2;
            elsif(A1 = "011") then
                D1 <= R3;
            elsif(A1 = "100") then
                D1 <= R4;
            elsif(A1 = "101") then
                D1 <= R5;
            elsif(A1 = "110") then
                D1 <= R6;
            elsif(A1 = "111") then
                D1 <= R7;
				else 
					D1 <= R0;	
            end if;
				
            if(A2 = "000")    then    
                D2 <= R0;
            elsif(A2 = "001") then
                D2 <= R1;
            elsif(A2 = "010") then
                D2 <= R2;
            elsif(A2 = "011") then
                D2 <= R3;
            elsif(A2 = "100") then
                D2 <= R4;
            elsif(A2 = "101") then
                D2 <= R5;
            elsif(A2 = "110") then
                D2 <= R6;
            elsif(A2 = "111") then
                D2 <= R7;
				else 
					D2 <= R0;
            end if;    
  
end process read_process;

R0_PC <= R0;
end inside;
---------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OREXReg is
port(
	      clk: in std_logic;
         PCin : in STD_LOGIC_VECTOR(15 downto 0);    
		   WR_E: in std_logic;                        
         reset: in std_logic;
         opcodein: in STD_LOGIC_VECTOR(3 downto 0); 
			RAin : in STD_LOGIC_VECTOR(15 downto 0);   
			RBin : in STD_LOGIC_VECTOR(15 downto 0); 
			Compbitin :in std_logic;
			SelAluin : in STD_LOGIC_VECTOR(1 downto 0);
		   Imm6in : in STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(15 downto 0);
			Dest_reg_add_in : in STD_LOGIC_VECTOR(2 downto 0);
			Mem_Imm_M_in:  in STD_LOGIC_VECTOR(15 downto 0); 	
			Bit_Reg_Add_in: in STD_LOGIC;
			Cin : in std_logic;
			Zin : in std_logic;
			
		   PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		   opcode: out STD_LOGIC_VECTOR(3 downto 0); 
			RA : out STD_LOGIC_VECTOR(15 downto 0);
			RB : out STD_LOGIC_VECTOR(15 downto 0); 
			Compbit :out std_logic;
			Dest_reg_add_out : out STD_LOGIC_VECTOR(2 downto 0);
			SelAlu : out STD_LOGIC_VECTOR(1 downto 0);
		   Imm6out : out STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9out : out STD_LOGIC_VECTOR(15 downto 0);
			Mem_Imm_M_out:  out STD_LOGIC_VECTOR(15 downto 0); 	
			Bit_Reg_Add_out: out STD_LOGIC;
			Cout : out std_logic;
			Zout : out std_logic
			);
end OREXReg;


architecture behave of OREXReg is
  begin 
  
    process(clk,PCin,reset,WR_E,opcodein,RAin,RBin, Compbitin,SelAluin, Imm6in,Imm9in,
										Bit_Reg_Add_in,Mem_Imm_M_in,Dest_reg_add_in ) is
	  variable T1, compvalue,One: STD_LOGIC_VECTOR(15 downto 0);
      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
               PCout <="0000000000000000";
					opcode<="1011";
			      RA    <="0000000000000000";
			      RB    <="0000000000000000";
			      Compbit<='0';
			      SelAlu <="00";
					Dest_reg_add_out <= "000";
			
					Imm6out    <="0000000000000000";
					Imm9out    <="0000000000000000";
					Mem_Imm_M_out <= "0000000000000000";
					Bit_Reg_Add_out <= '0';
					Cout <= '0';
					Zout <= '0';
       end if; 
		 
		 if(WR_E='1') then  
               PCout<=PCin;
               opcode<=opcodein;
			      RA    <=RAin;
			      RB    <=RBin;
			      Compbit<=Compbitin;
			      SelAlu <= SelAluin;
					Dest_reg_add_out <= Dest_reg_add_in;
					Imm6out    <=Imm6in;
					Imm9out    <=Imm9in;
					Mem_Imm_M_out <= Mem_Imm_M_in;
					Bit_Reg_Add_out <= Bit_Reg_Add_in;
					Cout <= Cin;
					Zout <= Zin;
       end if;
  
		  
			 end if;
		end process;
end behave;
---------------------------------------

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
--------------

library ieee;
use ieee.std_logic_1164.all;
library work;

entity SHIFTER is 
port (INPUT: in std_logic_vector(15 downto 0);
      OUTPUT: out std_logic_vector(15 downto 0)
		);
end entity SHIFTER;

architecture BHV_SHIFTER of SHIFTER is 

begin

	OUTPUT(15 downto 1) <= INPUT(14 downto 0);
	OUTPUT(0) <= '0';
	
end BHV_SHIFTER;

-----------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux_4_1 is
port(three,two,one,zero:in std_logic_vector(15 downto 0);
     output:out std_logic_vector(15 downto 0); 
     sel:in std_logic_vector(1 downto 0));
end entity;

architecture mux4to1 of mux_4_1 is
begin
	
process(zero,one,sel,three,two)
variable temp: std_logic_vector(15 downto 0); 
begin

case sel is 
	when "00" =>
        temp:=zero;
    when "01" =>
        temp:=one;
    when "10" =>
        temp:=two;
    when "11" =>
        temp:=three;
    when others =>
        temp:="XXXXXXXXXXXXXXXX";
end case;

output<= temp;

end process;

end mux4to1;

----------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        opcode : in std_logic_vector(3 downto 0);     
        c_in, z_in, CompBit,Bit_Reg_Add_in : in std_logic;          
        C_z : in std_logic_vector(1 downto 0);
        ALU_A, ALU_B : in std_logic_vector(15 downto 0);
        ALU_C : out std_logic_vector(15 downto 0);   
        carry, zero, equal, less, write_reg : out std_logic
    );

end entity ALU;

architecture behave of ALU is
	signal add_op,nand_op,write_reg_nand,write_reg_alu,write_reg_add,write_reg_op_always,write_LM : std_logic;
	signal carry_var,zero_var : std_logic;
	
    function sixteen_bit_adder(
        num_in_1, num_in_2 : in STD_LOGIC_VECTOR(15 downto 0);
        carry_in: in STD_LOGIC)
        return std_logic_vector is
        variable temp_sum : STD_LOGIC_VECTOR(17 downto 0);
        variable carry_adder : std_logic ;
    begin
        temp_sum(0) := num_in_1(0) XOR num_in_2(0) XOR carry_in;
            carry_adder := (num_in_1(0) AND num_in_2(0)) OR ((num_in_1(0) OR num_in_2(0)) AND carry_in);
		  for i in 1 to 15 loop
            temp_sum(i) := num_in_1(i) XOR num_in_2(i) XOR carry_adder;
            carry_adder := (num_in_1(i) AND num_in_2(i)) OR ((num_in_1(i) OR num_in_2(i)) AND carry_adder);
        end loop;
				temp_sum(16) := carry_adder;
		  if temp_sum = "000000000000000000" then
		      temp_sum(17) := '1';
		  else
		      temp_sum(17) := '0';
		  end if;
        return temp_sum;

    end function sixteen_bit_adder;

    function TwosComplement(num : in STD_LOGIC_VECTOR(15 downto 0))
        return STD_LOGIC_VECTOR is
        variable twos_comp: STD_LOGIC_VECTOR(15 downto 0);
        variable temp_num : unsigned(15 downto 0);
        variable twos_comp_temp : unsigned(15 downto 0);
    begin
        temp_num := unsigned(num);
        
        twos_comp_temp := not temp_num;
        
        twos_comp_temp := twos_comp_temp + 1;
        
        twos_comp := std_logic_vector(twos_comp_temp);
        
        return twos_comp;
    end function TwosComplement;
    
begin
    ALU:process(opcode,c_in, z_in, C_z, ALU_A, ALU_B,CompBit)
        variable temp: STD_LOGIC_VECTOR(17 downto 0);
        variable compliment: STD_LOGIC_VECTOR(15 downto 0); 
		  variable temp_c_in: STD_LOGIC;
    begin
            case opcode is
				
                when "0100"| "0101" | "1111" | "1101" | "1100" => 
                    
                        temp := sixteen_bit_adder(ALU_A, ALU_B, '0');
								ALU_C <= temp(15 downto 0);
					 
					 when "0001" | "0000"=>  
													
                    if (((C_z = "00") or (C_z = "11") or (C_z = "10" and c_in = '1') or (C_z = "01" and z_in = '1'))) then 
                        if CompBit = '1' then
                            compliment := TwosComplement(ALU_B);
                        else
                            compliment := ALU_B;
                        end if;

                        if not (C_z = "11") then
                            temp_c_in := '0';
								else
									 temp_c_in := c_in;
                        end if;

                        if (C_z = "00" and CompBit = '1') then
                            compliment := TwosComplement(ALU_A);
                        end if;

                        temp := sixteen_bit_adder(ALU_A, compliment, temp_c_in);
								ALU_C <= temp(15 downto 0);
								carry_var <= temp(16);
								zero_var <= temp(17);
								
								
							else 
								ALU_C <= "0000000000000000";
								
                    end if;

			
					 when "0010" =>
						  if ((c_z = "00" or (c_z = "10" and c_in = '1') or (C_z = "01" and z_in = '1'))) then
								if CompBit = '1' then
									compliment := TwosComplement(ALU_B);
								else
									compliment := ALU_B;
								end if;
									
								ALU_C <= ALU_A nand compliment;
								if (ALU_A nand compliment) = "0000000000000000" then
									zero_var <= '1';
								else
									zero_var <= '0';
								end if;
								
								
							else 
								ALU_C <= "0000000000000000";
						  end if;
							
				
					 when "1000" | "1001" | "1010" =>
						  zero_var <= '0';
						  carry_var <= '0';
						   
						  ALU_C <= "0000000000000000";
					
					 when others =>
						  ALU_C <= "0000000000000000";
						   
            end case;
				if ALU_A = ALU_B then
								equal <= '1';
						  else
						      equal <= '0';
						  end if;
						  
						  if ALU_A < ALU_B then
								less <= '1';
						  else
						      less <= '0';
					     end if;
						  
    end process;
	 add_op <= ( (not opcode(3)) and (not opcode(2)) and (not opcode(1)) and opcode(0));
	 write_reg_add <= (add_op and (((not C_z(1)) and (not C_z(0))) or ( C_z(1) and C_z(0)) or ( C_z(1) and c_in) or ((not C_z(1)) and z_in)));
	 nand_op <= ( (not opcode(3)) and (not opcode(2)) and opcode(1) and (not opcode(0)));
	 write_reg_nand <= (nand_op and (((not C_z(1)) and (not C_z(0))) or  ( (not C_z(0)) and c_in) or ((not C_z(1)) and z_in)));
    write_reg_alu <= (write_reg_add or write_reg_nand);
	 
	 write_reg_op_always <= (((not opcode(1)) and (((not opcode(3)) and (not opcode(0))) or  (opcode(3) and  opcode(2)))) or 
									((not opcode(3))  and (not opcode(2)) and opcode(1) and opcode(0)));

	  write_LM <= (Bit_Reg_Add_in and (not opcode(3)) and opcode(2) and opcode(1) and (not opcode(0)));
	 
	 write_reg <= (write_reg_alu or write_reg_op_always or write_LM);
	 
	 carry <= carry_var;
	 zero <= zero_var;

end behave;
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity ALU3 is
    Port (
	     PC, Imm: in std_logic_vector(15 downto 0);
		  PCImm2: out std_logic_vector(15 downto 0)
    );
end entity ALU3;

architecture inside of ALU3 is

    function add_sub(
        PC, Imm : in STD_LOGIC_VECTOR(15 downto 0))
		  return std_logic_vector is
        variable temp_sum : STD_LOGIC_VECTOR(15 downto 0);
        variable sum : std_logic_vector(16 downto 0) := (others => '0');
		  variable carry : std_logic;
    begin
        carry := '0';
        for i in 0 to 15 loop
                temp_sum(i) := PC(i) XOR Imm(i) XOR carry;
                carry := (PC(i) AND Imm(i)) OR ((PC(i) OR Imm(i)) AND carry);
        end loop;
        sum(15 downto 0) := temp_sum;
		  sum(16) := carry;
        return sum;
    end function add_sub;

begin
    ALU3: process(PC, Imm)
	 variable temp: STD_LOGIC_VECTOR(16 downto 0);
    begin
            temp := add_sub(PC, Imm);
				PCImm2 <= temp(15 downto 0);
    end process ALU3;

end architecture inside;
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXMMReg is
port    (
	      clk: in std_logic;
         PCin : in STD_LOGIC_VECTOR(15 downto 0);    
		   WR_E: in std_logic;                          
         reset: in std_logic;
         opcodein: in STD_LOGIC_VECTOR(3 downto 0);
			aluCin : in STD_LOGIC_VECTOR(15 downto 0);
			RAin : in STD_LOGIC_VECTOR(15 downto 0);   
			RBin : in STD_LOGIC_VECTOR(15 downto 0);   	
			Imm9in : in STD_LOGIC_VECTOR(15 downto 0);
			Dest_reg_add_in : in STD_LOGIC_VECTOR(2 downto 0);	
			Bit_Reg_Add_in: in STD_LOGIC;
			write_reg_in : in std_logic;

		   PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		   opcode: OUT STD_LOGIC_VECTOR(3 downto 0); 
			aluCout : out STD_LOGIC_VECTOR(15 downto 0);
			RAout : out STD_LOGIC_VECTOR(15 downto 0);
			RBout : out STD_LOGIC_VECTOR(15 downto 0);
			Dest_reg_add_out : out STD_LOGIC_VECTOR(2 downto 0);	
			Imm9out : out STD_LOGIC_VECTOR(15 downto 0);	
			Bit_Reg_Add_out: out STD_LOGIC;
			write_reg_out : out std_logic
			);
end EXMMReg;


architecture behave of EXMMReg is
  begin 
  
    process(clk,PCin,reset,WR_E,opcodein,aluCin ,Imm9in,RAin,RBin,Bit_Reg_Add_in,Dest_reg_add_in  ) is
      begin
		if (clk'event and clk = '1') then
		  
		 if(reset='1') then
               PCout  <="0000000000000000";
					opcode <="1011";
			      aluCout<="0000000000000000";
					Dest_reg_add_out <= "000";
					Imm9out<="0000000000000000";
					RAout <= "0000000000000000";
					RBout <= "0000000000000000";
					Bit_Reg_Add_out <= '0';
					write_reg_out <= '0';
       end if; 
		 
		 if(WR_E='1') then  
               PCout  <=PCin;
               opcode <=opcodein;
			      aluCout<=aluCin;
					Dest_reg_add_out <= Dest_reg_add_in;
					Imm9out<=Imm9in;
					RAout <= RAin;
					RBout <= RBin;
					Bit_Reg_Add_out <= Bit_Reg_Add_in;
					write_reg_out <= write_reg_in;
       end if;

			 end if;
		end process;
end behave;

---------------------------------------------------------------

library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is 
	port(
		 mem_d   : in std_logic_vector(15 DOWNTO 0);
		 mem_a   : in std_logic_vector(15 downto 0);
		 rd_en  : in std_logic; 
		 wr_en  : in std_logic;
		 reset: in std_logic;
		 clk : in std_logic;
		 mem_out : out std_logic_vector(15 DOWNTO 0); 
		 mem_0 : out std_logic_vector(15 DOWNTO 0); 
		 mem_1 : out std_logic_vector(15 DOWNTO 0); 
		 mem_2 : out std_logic_vector(15 DOWNTO 0); 
		 mem_3 : out std_logic_vector(15 DOWNTO 0)
		 );
end data_memory;

architecture structure of data_memory is 


type memarr is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM : memarr := (0=>"0000000011111111",
								1=>"0000000000000101",
								2=>"0000000000000000",
								3=>"0000000000000000",
								4=>"0111011001100110",
								5=>"0011001000001010",
								6=>"0110011000101000",
								7=>"0000000000000111",
								8=>"1100110000000100",
								16=>"1111011000000101",
								20=>"1101101011000000",
								10=>"0000000000001010",
								11=>"0000000000001011",
								others => "1011000101001100");
signal addr : std_logic_vector(4 downto 0);

begin

addr <= mem_a(4 downto 0);

	mem_proc : process(reset, wr_en, rd_en, clk, addr, RAM)

		begin
				
			if rd_en = '1' then
				mem_out <= RAM(to_integer(unsigned(addr)));
			
		
			elsif rising_edge (clk) then
				
				if wr_en ='1' then
					RAM(to_integer(unsigned(addr))) <= mem_d;
					
				end if;
				mem_out <= (others => '0');
			else 
				mem_out <= "0000000000000000";
			end if;	
					
	end process mem_proc;

	mem_0 <= RAM(0);
	mem_1 <= RAM(1);
	mem_2 <= RAM(2);
	mem_3 <= RAM(3);

end structure;

---------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux_4_1_3bit is
port(three,two,one,zero:in std_logic_vector(2 downto 0);
     output:out std_logic_vector(2 downto 0); 
     sel:in std_logic_vector(1 downto 0));
end entity;

architecture mux4to1 of mux_4_1_3bit is
begin
	
process(zero,one,sel,three,two)
variable temp: std_logic_vector(2 downto 0); 
begin

case sel is 
	when "00" =>
        temp:=zero;
    when "01" =>
        temp:=one;
    when "10" =>
        temp:=two;
    when "11" =>
        temp:=three;
    when others =>
        temp:="XXX";
end case;

output<= temp;

end process;

end mux4to1;

-----------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity mux_2_1_3bit  is
  port (I0 ,I1: in std_logic_vector(2 downto 0);
        S0: in std_logic;
		  mux_out: out std_logic_vector(2 downto 0)
		 );
end entity mux_2_1_3bit;

architecture mux2to1 of mux_2_1_3bit is
begin
	
process(I0,I1,S0)
variable temp: std_logic_vector(2 downto 0); 
begin

case S0 is 
	when '0' =>
        temp:=I0;
    when '1' =>
        temp:=I1;
    when others =>
        temp:="XXX";
end case;

mux_out<= temp;

end process;
end mux2to1;

---------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ForwardingUnit is
	port(
		EX_dest_reg_add: in std_logic_vector(2 downto 0);
		MM_dest_reg_add: in std_logic_vector(2 downto 0);
		WB_dest_reg_add : in std_logic_vector(2 downto 0);
		OR_source_reg_add : in std_logic_vector(2 downto 0);
		OR_source_reg_data: in std_logic_vector(15 downto 0);
		EX_aluc : in std_logic_vector(15 downto 0);
		EX_Imm9_16bit : in std_logic_vector(15 downto 0);
		MM_mem_out : in std_logic_vector(15 downto 0);
		MEM_aluc : in std_logic_vector(15 downto 0);
		MEM_Imm9_16bit : in std_logic_vector(15 downto 0);
		WB_RFD3 : in std_logic_vector(15 downto 0);
		EX_opcode : in std_logic_vector(3 downto 0);
		MM_opcode : in std_logic_vector(3 downto 0);
		EX_instr_wr_reg, MM_instr_wr_reg, WB_instr_wr_reg: in std_logic;
		
		fwd_reg_val : out std_logic_vector(15 downto 0);
		hold_or_fwd: out std_logic
	);
end entity;

architecture forward of ForwardingUnit is

	
begin
	
	process(EX_instr_wr_reg,MM_instr_wr_reg ,WB_instr_wr_reg,
				EX_dest_reg_add,MM_dest_reg_add,WB_dest_reg_add,OR_source_reg_add,
				OR_source_reg_data,EX_aluc,EX_Imm9_16bit,MM_mem_out,MEM_aluc,MEM_Imm9_16bit,WB_RFD3,
				EX_opcode,MM_opcode)
		begin
		
			if ((EX_instr_wr_reg = '1') and (EX_dest_reg_add = OR_source_reg_add)) then
				
				case EX_opcode is 
				
					when "0001"|"0010"|"0000"|"1100"|"1101" =>
						fwd_reg_val <= EX_aluc;
						hold_or_fwd <= '0';
						
					when "0011" =>
						fwd_reg_val <= EX_Imm9_16bit;
						hold_or_fwd <= '0';
						
					when "0100"|"0110" =>
						fwd_reg_val <= "0000000000000000";
						hold_or_fwd <= '1';
					when others =>
						fwd_reg_val <= OR_source_reg_data;
						hold_or_fwd <= '0';
				end case;
			
			elsif ((MM_instr_wr_reg = '1') and (MM_dest_reg_add = OR_source_reg_add)) then
				hold_or_fwd <= '0';
				
				case MM_opcode is 
				
					when "0001"|"0010"|"0000"|"1100"|"1101" =>
						fwd_reg_val <= MEM_aluc;
						
						
					when "0011" =>
						fwd_reg_val <= MEM_Imm9_16bit;
						
						
					when "0100"|"0110" =>
						fwd_reg_val <= MM_mem_out;
						
					when others =>
						fwd_reg_val <= OR_source_reg_data;
				end case;
			
			elsif ((WB_instr_wr_reg = '1') and (WB_dest_reg_add = OR_source_reg_add)) then
				hold_or_fwd <= '0';
				fwd_reg_val <= WB_RFD3;
			
			else
				
				hold_or_fwd <= '0';
				fwd_reg_val <= OR_source_reg_data;
			end if;
					
	end process;
end architecture;

----------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity R0PCForwardingUnit is
	port(
		EX_dest_reg_add: in std_logic_vector(2 downto 0);
		MM_dest_reg_add: in std_logic_vector(2 downto 0);
		PC_selected_without_fwd: in std_logic_vector(15 downto 0);
		EX_aluc : in std_logic_vector(15 downto 0);
		EX_Imm9_16bit : in std_logic_vector(15 downto 0);
		MM_mem_out : in std_logic_vector(15 downto 0);
		EX_opcode : in std_logic_vector(3 downto 0);
		MM_opcode : in std_logic_vector(3 downto 0);
		EX_instr_wr_reg, MM_instr_wr_reg: in std_logic;
		
		pc_out : out std_logic_vector(15 downto 0);
		flush_id_or_ex: out std_logic;
		flush_mem: out std_logic
	);
end entity;

architecture forward of R0PCForwardingUnit is
	
begin
	
	process(EX_instr_wr_reg,MM_instr_wr_reg ,
				EX_dest_reg_add,MM_dest_reg_add,
				PC_selected_without_fwd,EX_aluc,EX_Imm9_16bit,MM_mem_out,
				EX_opcode,MM_opcode)
		begin
		
			if ((EX_instr_wr_reg = '1') and (EX_dest_reg_add = "000")) then
				
				case EX_opcode is 
				
					when "0001"|"0010"|"0000"|"1100"|"1101" =>
						pc_out <= EX_aluc;
						flush_id_or_ex <= '1';
						flush_mem <= '0';
						
					when "0011" =>
						pc_out <= EX_Imm9_16bit;
						flush_id_or_ex <= '1';
						flush_mem <= '0';
						
					when others =>
						pc_out <= PC_selected_without_fwd;
						flush_id_or_ex <= '0';
						flush_mem <= '0';
					
				end case;
			
			elsif ((MM_instr_wr_reg = '1') and (MM_dest_reg_add = "000")) then
				
				case MM_opcode is 
					
					when "0100"|"0110" =>
						pc_out <= MM_mem_out;
						flush_id_or_ex <= '1';
						flush_mem <= '1';
					
					when others =>
						pc_out <= PC_selected_without_fwd;
						flush_id_or_ex <= '0';
						flush_mem <= '0';
					
				end case;
			
			
			else
						pc_out <= PC_selected_without_fwd;
						flush_id_or_ex <= '0';
						flush_mem <= '0';
					
			end if;
					
	end process;
end architecture;
--------------------------------------------------------------------------------------------------------------------------
