library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_Pipeline is	port (
	     clk: in std_logic;
		 reset:in std_logic
		   );
end RISC_Pipeline;


architecture behave of RISC_Pipeline is
-------------------------------------------------------------------
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
		 mem_a   : in std_logic_vector(15 downto 0);
		 mem_out : out std_logic_vector(15 DOWNTO 0)); -- output
end component;
---------------------------------------------------------------------------------------------
component ALU is
	port ( 
       	opcode : IN STD_LOGIC_VECTOR(3 downto 0);     ---------input 
		   c_in, z_in: IN STD_LOGIC;
			sel: IN STD_LOGIC_VECTOR(1 downto 0); 
		   ALUa, ALUb : IN STD_LOGIC_VECTOR(15 downto 0);
			clk: in std_logic;
		   ComBit : IN STD_LOGIC_VECTOR(0 downto 0);
		   ALUc: OUT STD_LOGIC_VECTOR(15 downto 0);       ------------ output
		   c_out, z_out,equal, less,tell: OUT STD_LOGIC);
end component;
------------------------------------------------------------------------------------------------
component ALU2 is
	port (
	     clk: in std_logic;
		  PC: IN STD_LOGIC_VECTOR(15 downto 0);
		  PCout : OUT STD_LOGIC_VECTOR(15 downto 0)
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
	port (clk : in std_logic;
       	Iin : IN STD_LOGIC_VECTOR(15 downto 0);
		   opcode: OUT STD_LOGIC_VECTOR(3 downto 0); 
			RA : OUT STD_LOGIC_VECTOR(2 downto 0);
			RB : OUT STD_LOGIC_VECTOR(2 downto 0); 
			RC : OUT STD_LOGIC_VECTOR(2 downto 0);
			Compbit :out std_logic;
			SelAlu : out STD_LOGIC_VECTOR(1 downto 0);
		   Imm6 : OUT STD_LOGIC_VECTOR(5 downto 0); 	
			Imm9 : OUT STD_LOGIC_VECTOR(8 downto 0) 	
		   );
end component;
---------------------------------------------------------------------------------------------------------
component IFIDReg is
	port (
	     clk: in std_logic;
        PCin : IN STD_LOGIC_VECTOR(15 downto 0);   
		  WR_E: in std_logic;                     
        reset: in std_logic;
		  Iin : IN STD_LOGIC_VECTOR(15 downto 0);
		  
		  PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		  Iout : out STD_LOGIC_VECTOR(15 downto 0)
		  );  
end component;
--------------------------------------------------------------------------------------------------------
component IDORReg is
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
		   Imm6in : in STD_LOGIC_VECTOR(5 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(8 downto 0);
		   aRAin : in STD_LOGIC_VECTOR(2 downto 0);	
			aRBin : in STD_LOGIC_VECTOR(2 downto 0);
			aRCin : in STD_LOGIC_VECTOR(2 downto 0);
			
		   PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		   Iout : out STD_LOGIC_VECTOR(15 downto 0) ;
		   opcode: out STD_LOGIC_VECTOR(3 downto 0); 
			RA : out STD_LOGIC_VECTOR(15 downto 0);
			RB : out STD_LOGIC_VECTOR(15 downto 0); 
			RC : out STD_LOGIC_VECTOR(15 downto 0);
			Compbit :out std_logic;
			aRAout : out STD_LOGIC_VECTOR(2 downto 0);
			aRBout : out STD_LOGIC_VECTOR(2 downto 0);
			aRCout : out STD_LOGIC_VECTOR(2 downto 0);
			SelAlu : out STD_LOGIC_VECTOR(1 downto 0);
		   Imm6out : out STD_LOGIC_VECTOR(5 downto 0); 	
			Imm9out : out STD_LOGIC_VECTOR(8 downto 0)
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
		   Imm6in : in STD_LOGIC_VECTOR(5 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(8 downto 0);
			aRAin : in STD_LOGIC_VECTOR(2 downto 0);
			aRBin : in STD_LOGIC_VECTOR(2 downto 0);
			aRCin : in STD_LOGIC_VECTOR(2 downto 0);

		   PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		   Iout : out STD_LOGIC_VECTOR(15 downto 0) ; 
		   opcode: OUT STD_LOGIC_VECTOR(3 downto 0); 
			aluCout : out STD_LOGIC_VECTOR(15 downto 0);
			aRAout : out STD_LOGIC_VECTOR(2 downto 0);
		   aRBout : out STD_LOGIC_VECTOR(2 downto 0);
			aRCout : out STD_LOGIC_VECTOR(2 downto 0);
		   Imm6out : out STD_LOGIC_VECTOR(5 downto 0); 	
			Imm9out : out STD_LOGIC_VECTOR(8 downto 0)
			);
end component;

--------------------------------------------------------------------------------------------------------------
component MMWBReg is
	port (
	     clk: in std_logic;
        PCin : IN STD_LOGIC_VECTOR(15 downto 0);   
		  WR_E: in std_logic;                         
         reset: in std_logic;
		   Iin : IN STD_LOGIC_VECTOR(15 downto 0);
         opcodein: in STD_LOGIC_VECTOR(3 downto 0); 
			MMoutin : IN STD_LOGIC_VECTOR(15 downto 0);
		   aluCin : in STD_LOGIC_VECTOR(15 downto 0);
			Imm6in : in STD_LOGIC_VECTOR(5 downto 0); 	
			Imm9in : in STD_LOGIC_VECTOR(8 downto 0);
			aRAin : in STD_LOGIC_VECTOR(2 downto 0);
			aRBin : in STD_LOGIC_VECTOR(2 downto 0);
			aRCin : in STD_LOGIC_VECTOR(2 downto 0);

		   PCout : out STD_LOGIC_VECTOR(15 downto 0); 
		   Iout : out STD_LOGIC_VECTOR(15 downto 0) ;
		   opcode: OUT STD_LOGIC_VECTOR(3 downto 0); 
			aluCout : out STD_LOGIC_VECTOR(15 downto 0);
		   MMoutout : out STD_LOGIC_VECTOR(15 downto 0);
		   aRAout : out STD_LOGIC_VECTOR(2 downto 0);
		   aRBout : out STD_LOGIC_VECTOR(2 downto 0);
			aRCout : out STD_LOGIC_VECTOR(2 downto 0);
		   Imm6out : out STD_LOGIC_VECTOR(5 downto 0); 	
			Imm9out : out STD_LOGIC_VECTOR(8 downto 0)
			);
end component;
---------------------------------------------------------------------------------------------------------------

 ----------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------
component data_memory is                                                                       --data memory
	port(
		 mem_d   : in std_logic_vector(15 DOWNTO 0);
		 mem_a   : in std_logic_vector(15 downto 0);
		 rd_bar  : in std_logic; -- read enable.
		 wr_bar  : in std_logic; -- write enable
		 reset : in std_logic; -- clear.
		 clk : in std_logic; -- clock.
		 mem_out : out std_logic_vector(15 DOWNTO 0)); -- output
		 
end component;

------------------------------------------------------------------------------------------------------------
component mux_4_1 is
port(three,two,one,zero:in std_logic_vector(15 downto 0);
     output:out std_logic_vector(15 downto 0); 
     sel:in std_logic_vector(1 downto 0));
end component;

------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
---------------------------------      END COMPONENTS      -------------------------------------------------
------------------------------------------------------------------------------------------------------------
----------------------------------------SIGNALS-------------------------------------------------------------

signal PCin: std_logic_vector(15 downto 0);
signal PCreset: std_logic; 
signal PCReadout: std_logic_vector(15 downto 0);
signal PCWR_E: std_logic;

signal WR_E1: std_logic;
signal reset1: std_logic;
signal Iin1: std_logic_vector(15 downto 0);
signal PCout1: std_logic_vector(15 downto 0);
signal Iout1: std_logic_vector(15 downto 0);

signal PC_plus_one: std_logic_vector(15 downto 0);
signal PCincrout: std_logic_vector(15 downto 0);
signal PC_selected: std_logic_vector(15 downto 0);

signal PCincrIMM: std_logic_vector(15 downto 0);

signal SelAlu1: std_logic_vector(1 downto 0);
signal opcode1: std_logic_vector(3 downto 0);
signal RA1: std_logic_vector(2 downto 0);
signal RB1: std_logic_vector(2 downto 0);
signal RC1: std_logic_vector(2 downto 0);
signal Compbit1: std_logic;
signal IMM6_1: std_logic_vector(5 downto 0);
signal IMM9_1: std_logic_vector(8 downto 0);
signal IMM6_16bit_1: std_logic_vector(15 downto 0);
signal IMM9_16bit_1: std_logic_vector(15 downto 0);


signal WR_E2,tel: std_logic;
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

signal WBlocation : std_logic_vector(2 downto 0);
signal PCout5 : std_logic_vector(15 downto 0);
signal WR_ER05 : std_logic;
signal Din_R_file : std_logic_vector(15 downto 0);
signal WR_E_R_file: std_logic;
signal reset_R_file: std_logic;
signal Dout1: std_logic_vector(15 downto 0);
signal Dout2: std_logic_vector(15 downto 0);
signal R0PC : std_logic_vector(15 downto 0);


signal WR_E3: std_logic;
signal opcode3: std_logic_vector(3 downto 0);
signal SelAlu3: std_logic_vector(1 downto 0);
signal PCout3: std_logic_vector(15 downto 0);
signal Iout3: std_logic_vector(15 downto 0);
signal aRB3: std_logic_vector(2 downto 0);
signal aRC3: std_logic_vector(2 downto 0);
signal reset3,Compbit3: std_logic;
signal IMM6_16bit_3: std_logic_vector(15 downto 0);
signal IMM9_16bit_3: std_logic_vector(15 downto 0);
signal RA3: std_logic_vector(15 downto 0);
signal RB3: std_logic_vector(15 downto 0);


signal WR_E4,equal4,less4: std_logic;
signal opcode4: std_logic_vector(3 downto 0);
signal PCout4: std_logic_vector(15 downto 0);
signal Iout4: std_logic_vector(15 downto 0);

signal aRC4: std_logic_vector(2 downto 0);
signal reset4: std_logic;
signal IMM6_16bit_4: std_logic_vector(15 downto 0);
signal IMM9_16bit_4: std_logic_vector(15 downto 0);
signal RA4: std_logic_vector(15 downto 0);--not need
signal RB4: std_logic_vector(15 downto 0);--not need
signal aluC: std_logic_vector(15 downto 0);
signal aluCout4: std_logic_vector(15 downto 0);

signal alu_mux_E,C,Z: std_logic;
signal aluB: std_logic_vector(15 downto 0);
signal alu_mux_reset : std_logic;

signal PC_MM: std_logic_vector(15 downto 0);

signal WR_E5,tell: std_logic;
signal opcode5: std_logic_vector(3 downto 0);
signal Iout5: std_logic_vector(15 downto 0);
signal aRC5: std_logic_vector(2 downto 0);
signal reset5: std_logic;
signal IMM6_16bit_5: std_logic_vector(15 downto 0);
signal IMM9_16bit_5: std_logic_vector(15 downto 0);
signal MMout5: std_logic_vector(15 downto 0);

signal MMoutin: std_logic_vector(15 downto 0);
signal aluCout5 : std_logic_vector(15 downto 0);

signal Mdatain : std_logic_vector(15 downto 0);
signal Madrin: std_logic_vector(15 downto 0);
signal RE_MD,flushit: std_logic;
signal WE_MD: std_logic;
signal reset_MD : std_logic;

signal muxaluAout : std_logic_vector(15 downto 0);
signal muxA4in : std_logic_vector(15 downto 0);

signal  muxaluAsel : std_logic_vector(1 downto 0);
signal DH_PC_WE : std_logic;
 signal DH_IFID_WE : std_logic;
 signal  DH_IDRR_WE,tell4,tell5 : std_logic;
signal RBsel : std_logic_vector(1 downto 0);          

begin

 
 
IM: instruction_memory
	port map (
		 mem_a =>PC_R0_out
		, mem_out=>Iin1); -- output


ALU2_inst: ALU2 is
	port map(
	     clk => clk,
		  PC => PC_R0_out,
		  PCout => PC_plus_one
		   );
end ALU2;



-----------------------------
-----------Instruction Decode 
-----------------------------	
 
IFID :IFIDReg
	     port map (
	     clk => clk,
        PCin=>PC_R0_out,--pc to IFID 
		  WR_E=> WR_E1,
        reset =>reset1,
		  Iin =>Iin1,
		  PCout=> PCout1,
		  Iout=>Iout1 ) ;
		  

		  
-- reset1<=('1' and flushit);		  
-- WR_E1<=('1' and DH_IFID_WE);

 

Decoder1 :Decoder 
	      port map(clk=> clk,
       	Iin =>Iin1,
		   opcode=>opcode1,
			RA=>RA1, 
			RB=>RB1,
			RC=>RC1,
			Compbit=>Compbit1,
			SelAlu=>SelAlu1,
		   Imm6=>IMM6_1;
			Imm9=>IMM9_1;
		   );
			
SE6_inst : SE6
    port map(
        Imm6in => IMM6_1;
        Imm6out =>IMM6_16bit_1;
    );

SE9_inst : SE9
    port map(
        Imm9in => IMM9_1;
        Imm9out =>IMM9_16bit_1;
    );
-----------------------------
----------------register Read 
-----------------------------

IDOR:   IDOR_Reg
		port map(
	     clk => clk,
        PCin => PCout1, 
		  WR_E =>WR_E2,
		  reset=> reset2,
		  Iin  =>Iout1,
        opcodein =>opcode1,
		  aRAin  =>RA1,
		  aRBin  =>RB1,
		  aRCin  =>RC1,
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

--
--reset<=('1' and flushit);	
--		  
-- WR_E2<=('1' and DH_IDRR_WE);
		  

R_file: Register_File 
        port map(
		  A1 =>aRA2,
        A2 =>aRB2,
        A3=>WBlocation,
        D3 =>Din_R_file,
		  R0in => PC_selected,
		  WR_E_R0=>PC_write,
        WR_E =>WR_E_R_file,
        reset=>reset_R_file,
        clk =>clk,
        D1=>Dout1,
        D2 =>Dout2,
        R0_PC => PC_R0_out
		  );
--WR_E_R_file<=(not(tell) and '1');
--reset_R_file <=('1' and flushit);		  
--		  
-----------------------------
--------------------Exicution
-----------------------------

OREX: OREX_Reg 
	      port map (
		   clk =>clk,
         PCin =>PCout2,    
		   WR_E =>WR_E3,                
         reset =>reset3,
		   Iin =>Iout2,
         opcodein =>opcode2,
			RAin =>Dout1, 
			RBin =>Dout2,
			Compbitin =>Compbit2,
			SelAluin =>SelAlu2,
		   Imm6in => IMM6_16bit_2, 	
			Imm9in => IMM9_16bit_2,
		   aRAin =>aRA2,	
			aRBin =>aRB2,
			aRCin =>aRC2,
			
		   PCout =>PCout3,
		   Iout =>Iout3,
		   opcode=>opcode3,
			RA  =>RA3,
			RB  =>RB3,
			RC  =>RC3, 
			Compbit =>Compbit3,
			aRAout =>aRA3,
			aRBout =>aRB3,
			aRCout =>aRC3,
			SelAlu =>SelAlu3,
		   Imm6out => IMM6_16bit_3,	
			Imm9out => IMM9_16bit_3
	);

shifter_mux:mux_2_1	
	port map(I0 => IMM9_16bit_3,
				I1 => IMM6_16bit_3,
			  S0 => shifter_select,
			  mux_out: => shifter_in);
			  
shifter_select <= (opcode3(3) and (not opcode3(2)));

Shifter_Inst: SHIFTER 
	port map (INPUT => shifter_in,
			OUTPUT => shifter_out);	
  
muxaluA : mux_4_1 
port map (three=>PCout3 ,
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
       	opcode=>opcode3, 
		   c_in=>C,
			z_in=>Z,
			sel=>SelAlu3,
		   ALUa=>aluAin,
			ALUb =>aluBin,
			clk=>clk,
		   ComBit(0) =>Compbit3,
		   ALUc=>aluC,   
		   c_out=>C,
			z_out=>Z
			,equal=>equal4, less=>less4,tell=>tel
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
			aluCin=>aluC,
			Imm6in => IMM6_16bit_3, 	
			Imm9in => IMM9_16bit_3,
			RAin => RA3,
			aRAin => aRA3,
			aRBin => aRB3,
			aRCin => aRC3,

		   PCout=>PCout4,
		   Iout=>Iout4,
		   opcode=>opcode4,
			aluCout=>aluCout4,
			RA => RA4,
			aRAout=>aRA4,
		   aRBout=>aRB4,
			aRCout=>aRC4,
		   Imm6out => IMM6_16bit_4,	
			Imm9out => IMM9_16bit_4
			);
			
Dmemory : data_memory
	port map(
		 mem_d =>Mdatain,
		 mem_a =>Madrin,
		 rd_en =>RE_MD,
		 wr_en =>WR_MD,
		 reset =>reset_MD,
		 clk =>clk,
		 mem_out =>MMoutin
		 );

Madrin <= aluCout4;
RE_MD <= '1'	when (opcode4 ="0100" )	;		
Mdatain <= RA4;
WR_MD <= '1' when (opcode4 = "0101");

---------------------------------------------------
------------------WRITE BACK-----------------------
---------------------------------------------------	

	
MMWB: MMWB_Reg
	port map(
	      clk=>clk,
         PCin=>PCout4, 
		   WR_E=>WR_E5,
         reset=>reset5,
		   Iin =>Iout4,
         opcodein=>opcode4,
			MMoutin=>MMoutin,
		   aluCin=>aluCout4,
		   Immin=>IMM3,
			aRCin=>aRC4,
			tellin=>tell4,
			tellout=>tell5,
		   PCout=>PCout5,
		   Iout=>Iout5,
		   opcode=>opcode5, 
			aluCout=>aluCout5,
			aRCout=>aRC5,
		   MMoutout=>MMout5,
		   Imm=>Imm5
			);
			
			port map(
	     clk=>clk,
         PCin=>PCout4,   
		  WR_E: in std_logic;   
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
			
		   PCout=>PCout5,
		   Iout=>Iout5,
		   opcode=>opcode5, 
			aluCout=>aluCout5,
		   MMoutout => MMout4,
		   aRAout=>aRA5,
		   aRBout=>aRB5,
			aRCout=>aRC5,
		   Imm6out => IMM6_16bit_5,	
			Imm9out => IMM9_16bit_5
			);

WR_E_R_file <=  
datahaz:hazard_detector 
	port map (
	     Z=>z
		  ,flush=>flushit
		  ,C=>c
		  ,equal =>equal4
		  ,less=>less4
	     ,clk=>clk,
		  I_RR_EX=>Iout3,
		  I_EX_MM=>Iout4,
		  I_MM_WB=>Iout5,
		  PC_WE=>DH_PC_WE,
		  IFID_WE=>DH_IFID_WE,
		  IDRR_WE=> DH_IDRR_WE,
		  RAselect=>muxaluAsel,
		  RBselect=>RBsel
			---------------------------------------------------
		 );
		   
		 



	

end behave;