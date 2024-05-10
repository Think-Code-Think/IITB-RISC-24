library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        opcode : in std_logic_vector(3 downto 0);     -- input 
        c_in, z_in, CompBit,Bit_Reg_Add_in : in std_logic;            -- carry in, zero in, and complement
        C_z : in std_logic_vector(1 downto 0);
        ALU_A, ALU_B : in std_logic_vector(15 downto 0);
        ALU_C : out std_logic_vector(15 downto 0);   -- ALU_C
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
        variable compliment: STD_LOGIC_VECTOR(15 downto 0); -- Define compliment
		  variable temp_c_in: STD_LOGIC;
    begin
            case opcode is
				
					 -------------- ADD Instructions
                when "0100"| "0101" | "1111" | "1101" | "1100" =>  -- for opcode 0000 adi cz, CompBit and cin are assumed to be 0
                    
                        temp := sixteen_bit_adder(ALU_A, ALU_B, '0');
								ALU_C <= temp(15 downto 0);
					 
					 when "0001" | "0000"=>  -- ADD instruction and ADI instruction
													-- In decode stage sel of ADI is given to be 00
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

					 -------------- NAND Instructions
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
							
					 -------------- Set Equal and Less flags
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
        -- end if;
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