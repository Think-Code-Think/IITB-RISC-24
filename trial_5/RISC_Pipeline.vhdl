library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_Pipeline is
port (
	    clk: in std_logic;
		 reset:in std_logic;
		 mem_0 : out std_logic_vector(15 DOWNTO 0); 
		 mem_1 : out std_logic_vector(15 DOWNTO 0); 
		 mem_2 : out std_logic_vector(15 DOWNTO 0); 
		 mem_3 : out std_logic_vector(15 DOWNTO 0)
	   );
end RISC_Pipeline;

architecture behave of RISC_Pipeline is
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
		  reset: in STD_LOGIC;
		  mem_out : out std_logic_vector(15 downto 0)
	 ); 
end component;
---------------------------------------------------------------------------------------------
component ALU is
port (
        opcode : in std_logic_vector(3 downto 0);     -- input 
        c_in, z_in, CompBit,Bit_Reg_Add_in : in std_logic;            -- carry in, zero in, and complement
        C_z : in std_logic_vector(1 downto 0);
        ALU_A, ALU_B : in std_logic_vector(15 downto 0);
        ALU_C : out std_logic_vector(15 downto 0);   -- ALU_C
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
port (inPUT: in std_logic_vector(15 downto 0);
			outPUT: out std_logic_vector(15 downto 0));
	
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
         PCin : in std_logic_vector(15 downto 0);    
		   WR_E: in std_logic;                        
         reset: in std_logic;
		   Iin : in std_logic_vector(15 downto 0);
         opcodein: in std_logic_vector(3 downto 0);
			aRAin : in std_logic_vector(2 downto 0);
			aRBin : in std_logic_vector(2 downto 0); 
			aRCin : in std_logic_vector(2 downto 0);
			Compbitin :in std_logic;
			SelAluin : in std_logic_vector(1 downto 0);
		   Imm6in : in std_logic_vector(15 downto 0); 	
			Imm9in : in std_logic_vector(15 downto 0); 

		   PCout : out std_logic_vector(15 downto 0); 
		   Iout : out std_logic_vector(15 downto 0) ;
		   opcode: out std_logic_vector(3 downto 0); 
			aRAout : out std_logic_vector(2 downto 0);
			aRBout : out std_logic_vector(2 downto 0); 
			aRCout : out std_logic_vector(2 downto 0);
			Compbitout :out std_logic;
			SelAluout : out std_logic_vector(1 downto 0);
		   Imm6out : out std_logic_vector(15 downto 0); 	
			Imm9out : out std_logic_vector(15 downto 0)
			);
end component;
-------------------------------------------------------------------------------------------------------
component OREXReg is
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
end component;
----------------------------------------------------------------------------------------------------------
component EXMMReg is
port (
	      clk: in std_logic;
         PCin : in STD_LOGIC_VECTOR(15 downto 0);    
		   WR_E: in std_logic;                          
         reset: in std_logic;
		   Iin : in STD_LOGIC_VECTOR(15 downto 0);
         opcodein: in STD_LOGIC_VECTOR(3 downto 0);
			aluCin : in STD_LOGIC_VECTOR(15 downto 0);
			RAin : in STD_LOGIC_VECTOR(15 downto 0);   
			RBin : in STD_LOGIC_VECTOR(15 downto 0);   
		   Imm6in : in STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(15 downto 0);
			aRAin : in STD_LOGIC_VECTOR(2 downto 0);
			aRBin : in STD_LOGIC_VECTOR(2 downto 0);
			aRCin : in STD_LOGIC_VECTOR(2 downto 0);
			Dest_reg_add_in : in STD_LOGIC_VECTOR(2 downto 0);
			Reg_Add_M_in: in STD_LOGIC_VECTOR(2 downto 0);	
			Bit_Reg_Add_in: in STD_LOGIC;
			Cin : in std_logic;
			Zin : in std_logic;
			write_reg_in : in std_logic;

		   PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		   Iout : out STD_LOGIC_VECTOR(15 downto 0) ; 
		   opcode: OUT STD_LOGIC_VECTOR(3 downto 0); 
			aluCout : out STD_LOGIC_VECTOR(15 downto 0);
			RAout : out STD_LOGIC_VECTOR(15 downto 0);
			RBout : out STD_LOGIC_VECTOR(15 downto 0);
			aRAout : out STD_LOGIC_VECTOR(2 downto 0);
		   aRBout : out STD_LOGIC_VECTOR(2 downto 0);
			aRCout : out STD_LOGIC_VECTOR(2 downto 0);
			Dest_reg_add_out : out STD_LOGIC_VECTOR(2 downto 0);
		   Imm6out : out STD_LOGIC_VECTOR(15 downto 0); 	
			Imm9out : out STD_LOGIC_VECTOR(15 downto 0);
			Reg_Add_M_out: out STD_LOGIC_VECTOR(2 downto 0); 	
			Bit_Reg_Add_out: out STD_LOGIC;
			Cout : out std_logic;
			Zout : out std_logic;
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
end component;
---------------------------------------------------------------------------------------------------------------
component data_memory is                                                                    
port(
		  mem_d   : in std_logic_vector(15 DOWNTO 0);
		 mem_a   : in std_logic_vector(15 downto 0);
		 rd_en  : in std_logic; -- read enable.
		 wr_en  : in std_logic; -- write enable
		 reset: in std_logic; -- clear.
		 clk : in std_logic; -- clock.
		 mem_out : out std_logic_vector(15 DOWNTO 0); 
		 mem_0 : out std_logic_vector(15 DOWNTO 0); 
		 mem_1 : out std_logic_vector(15 DOWNTO 0); 
		 mem_2 : out std_logic_vector(15 DOWNTO 0); 
		 mem_3 : out std_logic_vector(15 DOWNTO 0)
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
		  Imm9_16bit : IN STD_LOGIC_VECTOR(15 downto 0);
		  WR_E_M: in std_logic;                     
        reset: in std_logic;
		  Reg_Add_out : out STD_LOGIC_VECTOR(2 downto 0); 
		  Mem_Imm_out : out STD_LOGIC_VECTOR(15 downto 0);
		  Imm_at_RegAdd_out : out std_logic
		  ) ; 
end component;
-------------------------------------------------------------------------------------------------------------
---------------------------------      END COMPONENTS      -------------------------------------------------
------------------------------------------------------------------------------------------------------------
----------------------------------------SIGNALS-------------------------------------------------------------

signal PCin: std_logic_vector(15 downto 0);
signal PCreset: std_logic; 
signal PCReadout: std_logic_vector(15 downto 0);


signal WR_E1: std_logic;
signal reset1: std_logic;
signal Iin1: std_logic_vector(15 downto 0);
signal PCout1: std_logic_vector(15 downto 0);
signal Iout1: std_logic_vector(15 downto 0);

signal PC_plus_one: std_logic_vector(15 downto 0);
signal PC_R0_out: std_logic_vector(15 downto 0);
signal PC_selected: std_logic_vector(15 downto 0);
signal PC_selected_with_fwd: std_logic_vector(15 downto 0);
signal pc_plus_2_imm: std_logic_vector(15 downto 0);
signal pc_in_sel:  std_logic_vector(1 downto 0);
signal jump_in_beq,jump_in_blt,jump_in_ble: std_logic;
signal jump: std_logic;

signal SelAlu1: std_logic_vector(1 downto 0);
signal opcode1: std_logic_vector(3 downto 0);
signal aRA1: std_logic_vector(2 downto 0);
signal aRB1: std_logic_vector(2 downto 0);
signal aRC1: std_logic_vector(2 downto 0);
signal Compbit1: std_logic;
signal IMM6_1: std_logic_vector(5 downto 0);
signal IMM9_1: std_logic_vector(8 downto 0);
signal IMM6_16bit_1: std_logic_vector(15 downto 0);
signal IMM9_16bit_1: std_logic_vector(15 downto 0);

signal reset_im: std_logic;

------------Read Operand

signal WR_E2: std_logic;
signal opcode2: std_logic_vector(3 downto 0);
signal SelAlu2: std_logic_vector(1 downto 0);
signal PCout2: std_logic_vector(15 downto 0);
signal Iout2: std_logic_vector(15 downto 0);
signal aRA2: std_logic_vector(2 downto 0);
signal aRB2: std_logic_vector(2 downto 0);
signal aRC2: std_logic_vector(2 downto 0);
signal reset2,Compbit2: std_logic;
signal IMM6_16bit_2: std_logic_vector(15 downto 0);
signal IMM9_16bit_2: std_logic_vector(15 downto 0);

signal PC_write,RO_write_RF : std_logic;
signal WBlocation : std_logic_vector(2 downto 0);
signal RF_A2_in : std_logic_vector(2 downto 0);
signal PCout5 : std_logic_vector(15 downto 0);
signal Din_R_file : std_logic_vector(15 downto 0);
signal WR_E_R_file: std_logic;
signal reset_R_file: std_logic;
signal RF_D1_PC_sel: std_logic;
signal RF_D2_PC_sel: std_logic;
signal Dout1: std_logic_vector(15 downto 0);
signal Dout2: std_logic_vector(15 downto 0);
signal Dout1_post_PC_fix: std_logic_vector(15 downto 0);
signal Dout2_post_PC_fix: std_logic_vector(15 downto 0);
signal R0PC : std_logic_vector(15 downto 0);
signal RF_A2_select: std_logic;

--Execution variables

signal WR_E3: std_logic;
signal opcode3: std_logic_vector(3 downto 0);
signal SelAlu3: std_logic_vector(1 downto 0);
signal PCout3: std_logic_vector(15 downto 0);
signal Iout3: std_logic_vector(15 downto 0);
signal aRA3: std_logic_vector(2 downto 0);
signal aRB3: std_logic_vector(2 downto 0);
signal aRC3: std_logic_vector(2 downto 0);
signal Dest_Reg_Add3: std_logic_vector(2 downto 0);
signal reset3,Compbit3,shifter_select: std_logic;
signal shifter_in: std_logic_vector(15 downto 0);
signal shifter_out: std_logic_vector(15 downto 0);
signal aluAin: std_logic_vector(15 downto 0);
signal aluAsel: std_logic_vector(1 downto 0);
signal aluBin: std_logic_vector(15 downto 0);
signal aluBsel: std_logic_vector(1 downto 0);
signal aluCsel: std_logic;
signal aluCout: std_logic_vector(15 downto 0);

signal IMM6_16bit_3,MEM_ADD_MUL: std_logic_vector(15 downto 0);
signal IMM9_16bit_3: std_logic_vector(15 downto 0);
signal RA3: std_logic_vector(15 downto 0);
signal RB3,RB2: std_logic_vector(15 downto 0);
signal RC3: std_logic_vector(15 downto 0);


signal WR_E_M,write_reg4,write_reg5,write_reg3: std_logic;
signal reset_M : std_logic;
signal Reg_Add_M,Reg_Add_M5,Reg_Add_M3,Reg_Add_M4,Dest_Reg_Add2: std_logic_vector(2 downto 0);
signal Mem_Imm_M,Mem_Imm_M3: std_logic_vector(15 downto 0);
signal Bit_Reg_Add,Bit_Reg_Add5,Bit_Reg_Add3,Bit_Reg_Add4: std_logic;

--Memory variables
signal WR_E4,equal4,less4: std_logic;
signal opcode4: std_logic_vector(3 downto 0);
signal PCout4: std_logic_vector(15 downto 0);
signal Iout4: std_logic_vector(15 downto 0);


signal reset4: std_logic;
signal IMM6_16bit_4: std_logic_vector(15 downto 0);
signal IMM9_16bit_4: std_logic_vector(15 downto 0);
signal RA4: std_logic_vector(15 downto 0);
signal RB4: std_logic_vector(15 downto 0);
signal RC4: std_logic_vector(15 downto 0);
signal aluC: std_logic_vector(15 downto 0);
signal aluCout4: std_logic_vector(15 downto 0);
signal aRA4: std_logic_vector(2 downto 0);
signal aRB4: std_logic_vector(2 downto 0);
signal aRC4: std_logic_vector(2 downto 0);
signal Dest_Reg_Add4: std_logic_vector(2 downto 0);

signal alu_mux_E,C2,C3,C4,C5,Z2,Z3,Z4,Z5: std_logic;
signal aluB: std_logic_vector(15 downto 0);
signal alu_mux_reset : std_logic;

signal PC_MM: std_logic_vector(15 downto 0);

signal RE_MD,flushit: std_logic;
signal WR_MD: std_logic;
signal reset_MD : std_logic;
signal Mdatain_sel : std_logic;
signal Mdatain : std_logic_vector(15 downto 0);
signal Madrin: std_logic_vector(15 downto 0);


--WriteBack
signal WR_E5: std_logic;
signal opcode5: std_logic_vector(3 downto 0);
signal Iout5: std_logic_vector(15 downto 0);
signal reset5,hold_or_flush_ex_D1fwd,hold_or_flush_ex_D2fwd,hold_or_flush_ex: std_logic;
signal flush_mem, flush_id_or_ex: std_logic;
signal IMM6_16bit_5,RA2: std_logic_vector(15 downto 0);
signal IMM9_16bit_5: std_logic_vector(15 downto 0);
signal MMout5: std_logic_vector(15 downto 0);
signal aRA5: std_logic_vector(2 downto 0);
signal aRB5: std_logic_vector(2 downto 0);
signal aRC5: std_logic_vector(2 downto 0);
signal Dest_Reg_Add5: std_logic_vector(2 downto 0);
signal MMoutin: std_logic_vector(15 downto 0);
signal aluCout5 : std_logic_vector(15 downto 0);

signal  RF_Datain_sel : std_logic_vector(1 downto 0);
signal  RF_Addressin_Sel: std_logic_vector(1 downto 0);



signal muxaluAout : std_logic_vector(15 downto 0);
signal muxA4in : std_logic_vector(15 downto 0);

signal  muxaluAsel : std_logic_vector(1 downto 0);
signal  stop: std_logic;
signal RBsel : std_logic_vector(1 downto 0);          

signal hold_instr_at_or : std_logic;

----------------------------------END OF SIGNALS-----------------------

begin

IM: instruction_memory
	port map(
		 mem_add =>PC_R0_out,
		 reset => reset_im,
		 mem_out=>Iin1
		 ); -- output
reset_im <= reset or jump;
ALU2_inst: ALU2 
	port map(
		  PC => PC_R0_out,
		  PCout => PC_plus_one
		   );

pc_in_mux : mux_4_1 
port map (
			  three=>pc_plus_2_imm,
           two=>RB3,
           one=>aluC,
           zero=>PC_plus_one,
           output=>PC_selected,
           sel=>pc_in_sel
	         );


pc_in_sel(1) <= 	((opcode3(3) and opcode3(2) and (not opcode3(1))) or jump_in_beq or jump_in_blt or jump_in_ble or reset);			
pc_in_sel(0) <=  	((opcode3(3) and opcode3(2) and (opcode3(1) or (not opcode3(0)))) or jump_in_beq or jump_in_blt or jump_in_ble or reset);

jump_in_beq <= (equal4 and opcode3(3) and (not opcode3(2)) and (not opcode3(1)) and (not opcode3(0)));
jump_in_blt <= (less4 and opcode3(3) and (not opcode3(2)) and (not opcode3(1)) and  opcode3(0));
jump_in_ble <= ((equal4 or less4) and opcode3(3) and (not opcode3(2)) and (not opcode3(1)) and  opcode3(0));

jump <= (pc_in_sel(1) or pc_in_sel(0));



R0_PC_Fwd_Unit :R0PCForwardingUnit
 port map(
		EX_dest_reg_add => Dest_Reg_Add3,
		MM_dest_reg_add => Dest_Reg_Add4,
		
		PC_selected_without_fwd => PC_selected,
		
		EX_aluc => aluCout,
		EX_Imm9_16bit => IMM9_16bit_3, 
		MM_mem_out => MMoutin,
		
		EX_opcode => opcode3,
		MM_opcode => opcode4,
		
		EX_instr_wr_reg => write_reg3, 
		MM_instr_wr_reg => write_reg4, 
		
		pc_out => PC_selected_with_fwd,
		flush_id_or_ex => flush_id_or_ex,
		flush_mem => flush_mem
		
	);

----------------------------------
-----------Instruction Decode------ 
----------------------------------	
 
IFID :IFIDReg
	     port map (
	     clk => clk,
        PCin=>PC_R0_out,--pc to IFID 
		  WR_E=> WR_E1,
        reset =>reset1,
		  Iin =>Iin1,
		  PCout=> PCout1,
		  Iout=>Iout1 
		  ) ;
	reset1 <= (reset or jump or flush_id_or_ex);
	WR_E1 <= not (reset or jump or hold_instr_at_or or hold_or_flush_ex or flush_id_or_ex or stop);
-- reset1<=('1' and flushit);		  
-- WR_E1<=('1' and DH_IFID_WE);

Decoder1 :Decoder 
	      port map(
       	Iin =>Iout1,
		   opcode=>opcode1,
			RA=>aRA1, 
			RB=>aRB1,
			RC=>aRC1,
			Compbit=>Compbit1,
			SelAlu=>SelAlu1,
		   Imm6=>IMM6_1,
			Imm9=>IMM9_1
		   );
SE6_inst : SE6
    port map(
        Imm6in => IMM6_1,
        Imm6out =>IMM6_16bit_1
    );

SE9_inst : SE9
    port map(
        Imm9in => IMM9_1,
        Imm9out =>IMM9_16bit_1
    );
----------------------------------
----------------Oprand Read-------- 
-----------------------------------

IDOR:   IDORReg
		port map(
	     clk => clk,
        PCin => PCout1, 
		  WR_E =>WR_E2,
		  reset=> reset2,
		  Iin  =>Iout1,
        opcodein =>opcode1,
		  aRAin  =>aRA1,
		  aRBin  =>aRB1,
		  aRCin  =>aRC1,
		  Compbitin =>Compbit1,
		  SelAluin  =>SelAlu1,
		  Imm6in => IMM6_16bit_1,
		  Imm9in => IMM9_16bit_1,
		  
		  PCout  => PCout2, 
		  Iout   =>Iout2,
		  opcode => opcode2,
		  aRAout  =>aRA2,
		  aRBout  =>aRB2,
		  aRCout  =>aRC2,
		  Compbitout =>Compbit2,
		  SelAluout =>SelAlu2,
		  Imm6out => IMM6_16bit_2,
		  Imm9out => IMM9_16bit_2
			);
			
	reset2 <= (reset or jump or flush_id_or_ex);
--reset<=('1' and flushit);	
--	
	WR_E2 <= not (reset or jump or hold_instr_at_or or hold_or_flush_ex or flush_id_or_ex or stop);
-- WR_E2<=('1' and DH_IDRR_WE);	  

R_file: Register_File 
        port map(
		  A1 =>aRA2,
        A2 =>RF_A2_in,
        A3=>WBlocation,
        D3 =>Din_R_file,
		  R0in => PC_selected_with_fwd,
		  WR_E_R0=>PC_write,
        WR_E =>WR_E_R_file,
        reset=>reset_R_file,
        clk =>clk,
        D1=>Dout1,
        D2 =>Dout2,
        R0_PC => PC_R0_out
		  );
		  
RF_D1_PC_mux :mux_2_1	
	port map(
	        I0 => PCout2,
			  I1 => Dout1,
			  S0 => RF_D1_PC_sel,
			  mux_out => Dout1_post_PC_fix
			  );

RF_D1_PC_sel <= (aRA2(2) or aRA2(1) or aRA2(0));
			  
RF_D2_PC_mux :mux_2_1	
	port map(
	        I0 => PCout2,
			  I1 => Dout2,
			  S0 => RF_D2_PC_sel,
			  mux_out => Dout2_post_PC_fix
			  );
RF_D2_PC_sel <= (RF_A2_in(2) or RF_A2_in(1) or RF_A2_in(0));
			  
RF_Addressin_mux : mux_4_1_3bit 
port map (
			  three=>Reg_Add_M ,
           two=> aRB2,
           one=>aRC2,
           zero=>aRA2,
           output=>Dest_Reg_Add2,
           sel=>RF_Addressin_Sel
	       );

RF_Addressin_Sel(1) <= ((not (opcode2(2) or opcode2(1) or opcode2(0))) or (opcode2(2) and opcode2(1)));			
RF_Addressin_Sel(0) <= (((not opcode2(3)) and (not opcode2(1)) and  opcode2(0)) or (opcode2(1) and (not opcode2(0)))) ;	

	
RF_D1_fwd_unit: ForwardingUnit 
	port map (
		EX_dest_reg_add => Dest_Reg_Add3,
		MM_dest_reg_add => Dest_Reg_Add4,
		WB_dest_reg_add => Dest_Reg_Add5,
		OR_source_reg_add => aRA2,
		
		OR_source_reg_data => Dout1_post_PC_fix,
		EX_aluc => aluCout,
		EX_Imm9_16bit => IMM9_16bit_3, 
		MM_mem_out => MMoutin,
		MEM_aluc =>aluCout4,
		MEM_Imm9_16bit => IMM9_16bit_4,
		WB_RFD3 => Din_R_file,
		
		EX_opcode => opcode3,
		MM_opcode => opcode4,
		
		EX_instr_wr_reg => write_reg3, 
		MM_instr_wr_reg => write_reg4, 
		WB_instr_wr_reg => write_reg5,
		
		fwd_reg_val => RA2,
		hold_or_fwd => hold_or_flush_ex_D1fwd
	);
	
RF_D2_fwd_unit: ForwardingUnit 
	port map (
		EX_dest_reg_add => Dest_Reg_Add3,
		MM_dest_reg_add => Dest_Reg_Add4,
		WB_dest_reg_add => Dest_Reg_Add5,
		OR_source_reg_add => RF_A2_in,
		
		OR_source_reg_data => Dout2_post_PC_fix,
		EX_aluc => aluCout,
		EX_Imm9_16bit => IMM9_16bit_3, 
		MM_mem_out => MMoutin,
		MEM_aluc =>aluCout4,
		MEM_Imm9_16bit => IMM9_16bit_4,
		WB_RFD3 => Din_R_file,
		
		EX_opcode => opcode3,
		MM_opcode => opcode4,
		
		EX_instr_wr_reg => write_reg3, 
		MM_instr_wr_reg => write_reg4, 
		WB_instr_wr_reg => write_reg5,
		
		fwd_reg_val => RB2,
		hold_or_fwd => hold_or_flush_ex_D2fwd
	);

		  
hold_or_flush_ex <= ( hold_or_flush_ex_D1fwd or hold_or_flush_ex_D2fwd );

reset_R_file <= reset;		  

RF_A2_mux:mux_2_1_3bit
	port map(
	        I0 => aRB2,
			  I1 => Reg_Add_M,
			  S0 => RF_A2_select,
			  mux_out => RF_A2_in
			  );

RF_A2_select <= ((not opcode2(3)) and opcode2(2) and opcode2(1) and opcode2(0));
			  
Multiple_Counter:Multiple_Reg
	port map(
	     clk=> clk,
		  Imm9_16bit => IMM9_16bit_2,
		  WR_E_M => WR_E_M,               
        reset => reset_M,
		  Reg_Add_out => Reg_Add_M,
		  Mem_Imm_out => Mem_Imm_M,
		  Imm_at_RegAdd_out => Bit_Reg_Add
		  ) ; 
	

reset_M <= ((not WR_E_M));
WR_E_M <= ((not (reset or stop)) and ((not opcode2(3)) and opcode2(2) and opcode2(1)
					and ( Reg_Add_M(2) or  Reg_Add_M(1) or Reg_Add_M(0))));

hold_instr_at_or <= WR_E_M;
	
--		  
-------------------------------------
--------------------Execution--------
-------------------------------------

OREX: OREXReg 
	      port map (
		   clk =>clk,
         PCin =>PCout2,    
		   WR_E =>WR_E3,                
         reset =>reset3,
		   Iin =>Iout2,
         opcodein =>opcode2,
			RAin =>RA2, 
			RBin =>RB2,
			Compbitin =>Compbit2,
			SelAluin =>SelAlu2,
		   Imm6in => IMM6_16bit_2, 	
			Imm9in => IMM9_16bit_2,
		   aRAin =>aRA2,	
			aRBin =>RF_A2_in,
			aRCin =>aRC2,
			Dest_reg_add_in => Dest_Reg_Add2,
			Reg_Add_M_in =>Reg_Add_M,
			Mem_Imm_M_in =>Mem_Imm_M, 
			Bit_Reg_Add_in =>Bit_Reg_Add,
			Cin => C2,
		   Zin => Z2,
			
		   PCout =>PCout3,
		   Iout =>Iout3,
		   opcode=>opcode3,
			RA  =>RA3,
			RB  =>RB3,
--			RC  =>RC3, 
			Compbit =>Compbit3,
			aRAout =>aRA3,
			aRBout =>aRB3,
			aRCout =>aRC3,
			Dest_reg_add_out => Dest_Reg_Add3,
			SelAlu =>SelAlu3,
		   Imm6out => IMM6_16bit_3,	
			Imm9out => IMM9_16bit_3,
			Reg_Add_M_out =>Reg_Add_M3,
			Mem_Imm_M_out =>Mem_Imm_M3,
			Bit_Reg_Add_out =>Bit_Reg_Add3, 
			Cout => C3,
		   Zout => Z3
	);
	
	reset3 <= (reset or jump or hold_or_flush_ex or flush_id_or_ex);
	
	WR_E3 <= not (reset or jump or hold_or_flush_ex or flush_id_or_ex or stop);
	
Multiple_ALU:  ALU3 
	port map (
	     PC => RA3,
		  Imm => Mem_Imm_M3,
		  PCImm2 => MEM_ADD_MUL
			);
			
muxaluC:mux_2_1	
	port map(
	        I0 => aluC,
			  I1 => MEM_ADD_MUL,
			  S0 => aluCsel,
			  mux_out => aluCout
			  );
			  
aluCsel	<= ((not opcode3(3)) and opcode3(2) and opcode3(1));
	
shifter_mux:mux_2_1	
	port map(
	        I0 => IMM9_16bit_3,
			  I1 => IMM6_16bit_3,
			  S0 => shifter_select,
			  mux_out => shifter_in
			  );
			  
shifter_select <= (opcode3(3) and (not opcode3(2)));

Shifter_inst: SHIFTER 
   port map (
	      inPUT => shifter_in,
			outPUT => shifter_out);	
  
muxaluA : mux_4_1 
port map ( 
           three=>PCout3 ,
           two=>"XXXXXXXXXXXXXXXX",
           one=>IMM6_16bit_3,
           zero=>RA3,
           output=>aluAin,
           sel=>aluAsel
	         );

aluAsel(0) <= (opcode3(2) and (not opcode3(1)));
aluAsel(1) <= (opcode3(3) and opcode3(2) and (not opcode3(1)));


muxaluB : mux_4_1 
port map (
			  three=>shifter_out ,
           two=>"0000000000000010",
           one=>IMM6_16bit_3,
           zero=>RB3,
           output=>aluBin,
           sel=>aluBsel
	       );

aluBsel(0) <= ((not (opcode3(3) or opcode3(2) or opcode3(1) or opcode3(0))) or (opcode3(1) and opcode3(0)));
aluBsel(1) <= ((opcode3(3) and opcode3(2)) or (opcode3(1) and opcode3(0)));

 
Main_ALU : ALU 
	port map (
		  opcode =>opcode3, 
		  c_in=> C3,
		  z_in=> Z3,
		  CompBit =>Compbit3,
		  Bit_Reg_Add_in => Bit_Reg_Add3,
        C_z =>SelAlu3,
        ALU_A=>aluAin,
		  ALU_B=>aluBin,                          -- clock
        ALU_C =>aluC,
        carry=>C2, 
		  zero=>Z2, 
		  equal=>equal4,
		  less=>less4,
		  write_reg => write_reg3
			
			);			 

ALU_3 : ALU3 
	port map (
	     PC => PCout3,
		  Imm => shifter_out,
		  PCImm2 => pc_plus_2_imm
			);			 

---------------------------------------------------
------------------MEMORY---------------------------
---------------------------------------------------	
EXMM: EXMMReg 
	     port map (
			clk=>clk,
         PCin =>PCout3,
		   WR_E=>WR_E4,
         reset=>reset4,
		   Iin=>Iout3,
         opcodein=>opcode3,
			aluCin=>aluCout,
			Imm6in => IMM6_16bit_3, 	
			Imm9in => IMM9_16bit_3,
			RAin => RA3,
			RBin => RB3,
			aRAin => aRA3,
			aRBin => aRB3,
			aRCin => aRC3,
			Dest_reg_add_in => Dest_Reg_Add3,
			Reg_Add_M_in => Reg_Add_M3,
			Bit_Reg_Add_in =>Bit_Reg_Add3,
			Cin => C3,
		   Zin => Z3,
			write_reg_in => write_reg3,

		   PCout=>PCout4,
		   Iout=>Iout4,
		   opcode=>opcode4,
			aluCout=>aluCout4,
			RAout => RA4,
			RBout => RB4,
			aRAout=>aRA4,
		   aRBout=>aRB4,
			aRCout=>aRC4,
			Dest_reg_add_out => Dest_Reg_Add4,
		   Imm6out => IMM6_16bit_4,	
			Imm9out => IMM9_16bit_4,
			Reg_Add_M_out => Reg_Add_M4,
			Bit_Reg_Add_out =>Bit_Reg_Add4,
			Cout => C4,
		   Zout => Z4,
			write_reg_out => write_reg4
			);
		
	reset4 <= (reset or flush_mem);
	
	WR_E4 <= not (reset or flush_mem or stop);
			
Dmemory : data_memory
	port map(
		 mem_d =>Mdatain,
		 mem_a =>Madrin,
		 rd_en =>RE_MD,
		 wr_en =>WR_MD,
		 reset =>reset_MD,
		 clk =>clk,
		 mem_out =>MMoutin,  
		 mem_0 => mem_0, 
		 mem_1 => mem_1,  
		 mem_2 => mem_2,
		 mem_3 => mem_3
		 );

Madrin <= aluCout4;
RE_MD <= ((not opcode4(3)) and opcode4(2) and (not opcode4(0)));	
reset_MD <= reset;	

Mdatain_mux:mux_2_1	
	port map(
	        I0 => RA4,
			  I1 => RB4,
			  S0 => Mdatain_sel,
			  mux_out => Mdatain
			  );
			  
Mdatain_sel <=  opcode4(1);
			  
WR_MD <= (((not opcode4(3)) and opcode4(2) and (((not opcode4(1)) and opcode4(0)) or ( opcode4(1) and opcode4(0) and Bit_Reg_Add4))) and (not (stop or reset)));

---------------------------------------------------
------------------WRITE BACK-----------------------
---------------------------------------------------	

MMWB: MMWBReg
			port map(
	     clk=>clk,
         PCin=>PCout4,
			WR_E=>WR_E5,
		   reset => reset5,
		   Iin   => Iout4,
         opcodein => opcode4,
			MMoutin => MMoutin,
		   aluCin => aluCout4,
			Imm6in => IMM6_16bit_4, 	
			Imm9in => IMM9_16bit_4,
			aRAin => aRA4,
			aRBin => aRB4,
			aRCin => aRC4,
			Dest_reg_add_in => Dest_Reg_Add4,
			Reg_Add_M_in => Reg_Add_M4,
			Bit_Reg_Add_in =>Bit_Reg_Add4,
			Cin => C4,
		   Zin => Z4,
			write_reg_in => write_reg4,
		  
		   PCout=>PCout5,
		   Iout=>Iout5,
		   opcode=>opcode5, 
			aluCout=>aluCout5,
		   MMoutout => MMout5,
		   aRAout=>aRA5,
		   aRBout=>aRB5,
			aRCout=>aRC5,
			Dest_reg_add_out => Dest_Reg_Add5,
		   Imm6out => IMM6_16bit_5,	
			Imm9out => IMM9_16bit_5,
			Reg_Add_M_out => Reg_Add_M5,
			Bit_Reg_Add_out =>Bit_Reg_Add5,
			Cout => C5,
		   Zout => Z5,
			write_reg_out => write_reg5
			);
	
	reset5 <= reset;	
	
	WBlocation <= Dest_Reg_Add5;
	
	WR_E5 <= not (reset or stop);
WR_E_R_file <= write_reg5 and (not (reset or stop));

RO_write_RF <= (WR_E_R_file and (not (Dest_Reg_Add5(2) or Dest_Reg_Add5(1) or Dest_Reg_Add5(0))));
PC_write <= not (reset or hold_instr_at_or or RO_write_RF or hold_or_flush_ex or stop);

RF_Datain_mux : mux_4_1 
port map (
			  three=>MMout5,
           two=>IMM9_16bit_5,
           one=>MMout5,
           zero=>aluCout5,
           output=>Din_R_file,
           sel=>RF_Datain_sel
	         );

RF_Datain_sel(1) <= 	(opcode5(1) and opcode5(0));			
RF_Datain_sel(0) <=  ((not opcode5(3)) and opcode5(2));

stop <= (opcode5(3) and opcode5(2) and opcode5(1) and (not opcode5(0)));


end behave;