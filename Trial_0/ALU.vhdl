library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port    ( 
       	opcode : in std_logic_vector(3 downto 0);     ---------input 
		   c_in, z_in: in std_logic;
			sel: in std_logic_vector(1 downto 0); 
		   ALUa, ALUb : in std_logic_vector(15 downto 0);
			clk: in std_logic;
		   ComBit : in std_logic_vector(0 downto 0);
		   ALUc: out std_logic_vector(15 downto 0);       ------------ output
		   c_out, z_out,equal, less: out std_logic
		  );
end ALU;

architecture behave of ALU is

  begin
      process(opcode,c_in, z_in, ALUa, ALUb,ComBit,clk,sel)
	  variable T1, compvalue,One: std_logic_vector(15 downto 0);
	  variable T2 ,T3,T4: std_logic_vector(16 downto 0);
      begin
		if (clk'event and clk = '1') then
		
		  case opcode is
		   when "0010" =>
			
			     if (sel="00" and ComBit = "0" ) then---------ndu
				  
				  ALUc<= ALUa nand ALUb; 
				  T1 := ALUa nand ALUb;
				  if T1 = x"0000" then
					  z_out <= '1';
				  else
					  z_out <= '0';
				  end if;
			     end if;
              
              if (sel="10" and ComBit = "0" ) then-------------ndc
				  if(c_in = '1') then
				  ALUc<= ALUa nand ALUb; 
				  T1 := ALUa nand ALUb;
				  if T1 = x"0000" then
					  z_out <= '1';
				  else
					  z_out <= '0';
				  end if;
			     end if;				  
              end if;


             if (sel="01" and ComBit = "0" ) then-------------ndz
				  if(Z_in= '1') then
				  ALUc<= ALUa nand ALUb; ---
				  T1 := ALUa nand ALUb;
				  if T1 = x"0000" then
					  z_out <= '1';
				  else
					  z_out <= '0';
				  end if;
			     end if;				  
              end if;

              if (sel="00" and ComBit = "1" ) then---------ncu
				  
				  ALUc<= ALUa nand ALUb; ---
				  T1 := ALUa nand ALUb;
				  if T1 = x"0000" then
					  z_out <= '1';
				  else
					  z_out <= '0';
				  end if;
			     end if;
              
              if (sel="10" and ComBit = "1" ) then-------------nCc
				  if(c_in= '1') then
				  ALUc<= ALUa nand not(ALUb); ---
				  T1 := ALUa nand not(ALUb);
				  if T1 = x"0000" then
					  z_out <= '1';
				  else
					  z_out <= '0';
				  end if;
			     end if;				  
              end if;


             if (sel="01" and ComBit = "1" ) then-------------ncz
				  if(Z_in= '1') then
				  ALUc<= ALUa nand not(ALUb); ---
				  T1 := ALUa nand not(ALUb);
				  if T1 = x"0000" then
					  z_out <= '1';
				  else
					  z_out <= '0';
				  end if;
			     end if;				  
              end if;

              
			when "0001" =>
			
			 if (sel="00" and ComBit = "0" ) then---------Adu
				  
				   ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(ALUb)); ---
					T1 := std_logic_vector(unsigned(ALUa) + unsigned(ALUb));
					c_out <= (ALUa(15) and ALUb(15) and (not T1(15))) or ((not ALUa(15)) and (not ALUb(15)) and T1(15));
					   if T1 = "0000000000000000" then
						z_out <= '1';
					   else
						z_out <= '0';
				      end if;
              
              if (sel="10" and ComBit = "0" ) then-------------Adc
				  if(c_in = '1') then
				   ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(ALUb));
					T1 := std_logic_vector(unsigned(ALUa) + unsigned(ALUb)); ---
					c_out <= (ALUa(15) and ALUb(15) and (not T1(15))) or ((not ALUa(15)) and (not ALUb(15)) and T1(15));
					   if T1 = x"0000" then
						z_out <= '1';
					   else
						z_out <= '0';
				      end if;
			     end if;				  
              end if;


             if (sel="01" and ComBit = "0" ) then-------------Adz
				  if(Z_in= '1') then
				   ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(ALUb)); ---
					T1 := std_logic_vector(unsigned(ALUa) + unsigned(ALUb));
					c_out <= (ALUa(15) and ALUb(15) and (not T1(15))) or ((not ALUa(15)) and (not ALUb(15)) and T1(15));
					   if T1 = x"0000" then
						z_out <= '1';
					   else
						z_out <= '0';
				      end if;
			     end if;				  
              end if;

              if (sel="00" and ComBit = "1" ) then---------Acu
				  
			      compvalue :=not ALUb;
				   ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(compvalue)); ---
					T1 := std_logic_vector(unsigned(ALUa) + unsigned(compvalue));
					c_out <= (ALUa(15) and compvalue(15) and (not T1(15))) or ((not ALUa(15)) and (not compvalue(15)) and T1(15));
					   if T1 = x"0000" then
						z_out <= '1';
					   else
						z_out <= '0';
				      end if;
			     end if;
              
              if (sel="10" and ComBit = "1" ) then-------------ACc
				  if(c_in= '1') then
				   compvalue :=not ALUb;
				   ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(compvalue)); ---
					T1 := std_logic_vector(unsigned(ALUa) + unsigned(compvalue));
					c_out <= (ALUa(15) and compvalue(15) and (not T1(15))) or ((not ALUa(15)) and (not compvalue(15)) and T1(15));
					   if T1 = x"0000" then
						z_out <= '1';
					   else
						z_out <= '0';
				      end if;
			     end if;				  
              end if;


             if (sel="01" and ComBit = "1" ) then-------------Acz
				  if(Z_in= '1') then
			      compvalue :=not ALUb;
				   ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(compvalue)); ---
					T1 := std_logic_vector(unsigned(ALUa) + unsigned(compvalue));
					c_out <= (ALUa(15) and compvalue(15) and (not T1(15))) or ((not ALUa(15)) and (not compvalue(15)) and T1(15));
					   if T1 = x"0000" then
						z_out <= '1';
					   else
						z_out <= '0';
				      end if;
				  end if;
			     end if;				  
              end if;

			
			when "0000" =>-------------------------------------------------ADI

			   ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(ALUb));
			   T1 := std_logic_vector(unsigned(ALUa) + unsigned(ALUb)); ---
					c_out <= (ALUa(15) and ALUb(15) and (not T1(15))) or ((not ALUa(15)) and (not ALUb(15)) and T1(15));
					   if T1 = x"0000" then
						z_out <= '1';
					   else
						z_out <= '0';
				      end if;
						
						
			when ("0100"or"0101" ) =>
            if (Alub(6 downto 6 )="0") then 
            ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(ALUb)); ---
            else 
            ALUc<= std_logic_vector(unsigned(ALUa) - unsigned(ALUb)); ---
            end if;

		 	when("1101" or "1111" ) =>
			ALUc<= std_logic_vector(unsigned(ALUa) + 2);
			
			
	      when("1000" or "1001"or "1010" ) =>
			     ALUc<= std_logic_vector(unsigned(ALUa) - unsigned(ALUb)); ---
					T1 := std_logic_vector(unsigned(ALUa) - unsigned(ALUb));
					c_out <= (ALUa(15) and ALUb(15) and (not T1(15))) or ((not ALUa(15)) and (not ALUb(15)) and T1(15));
					   if T1 = x"0000" then
						equal <= '1';
					   else
						equal <= '0';
				      end if;
			     T2(15 downto 0):=ALUa;
			     T2(16 downto 16):="1";
			      T3(15 downto 0):=ALUb;
			     T3(16 downto 16):="0";
			--less = 1 => RegA < Reg B  
			T4:= std_logic_vector(unsigned(T2) - unsigned(T3));
			if (T4(16 downto 16)= "1") then
						less <= '0';
					   else
						less <= '1';
						end if;
			
			 when others  => 
			   ALUc<= std_logic_vector(unsigned(ALUa) + unsigned(ALUb));
				
          end case;
			 end if;
		end process;

end behave;