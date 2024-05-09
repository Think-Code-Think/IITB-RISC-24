library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        opcode : in std_logic_vector(3 downto 0);     -- input 
        c_in, z_in, ComBit : in std_logic;            -- carry in, zero in, and complement
        C_z : in std_logic_vector(1 downto 0);
        Input_1, Input_2 : in std_logic_vector(15 downto 0);
        Output : out std_logic_vector(15 downto 0);   -- output
        carry, zero, equal, less : out std_logic
    );
end entity ALU;

architecture behave of ALU is

    function sixteen_bit_adder(
        num_in_1, num_in_2 : in STD_LOGIC_VECTOR(15 downto 0);
        carry_in: in STD_LOGIC)
        return std_logic_vector is
        variable temp_sum : STD_LOGIC_VECTOR(17 downto 0) :="000000000000000000";
        variable carry : std_logic := '0';
    begin
        for i in 0 to 15 loop
            temp_sum(i) := num_in_1(i) XOR num_in_2(i) XOR carry;
            carry := (num_in_1(i) AND num_in_2(i)) OR ((num_in_1(i) OR num_in_2(i)) AND carry);
        end loop;
				temp_sum(16) := carry;
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
    ALU:process(opcode,c_in, z_in, C_z, Input_1, Input_2,ComBit)
        variable temp: STD_LOGIC_VECTOR(17 downto 0);
        variable compliment: STD_LOGIC_VECTOR(15 downto 0); -- Define compliment
		  variable temp_c_in: STD_LOGIC;
    begin
            case opcode is
				
					 -------------- ADD Instructions
                when "0001" =>
                    if (((C_z = "00") or (C_z = "11") or (C_z = "10" and c_in = '1') or (C_z = "01" and z_in = '1'))) then 
                        if ComBit = '1' then
                            compliment := TwosComplement(Input_2);
                        else
                            compliment := Input_2;
                        end if;

                        if not (C_z = "11") then
                            temp_c_in := '0';
								else
									 temp_c_in := c_in;
                        end if;

                        if (C_z = "00" and ComBit = '1') then
                            compliment := TwosComplement(Input_1);
                        end if;
                                
                        temp := sixteen_bit_adder(Input_1, compliment, c_in);
								output <= temp(15 downto 0);
								carry <= temp(16);
								zero <= temp(17);

                    end if;

					 -------------- NAND Instructions
					 when "0010" =>
						  if ((c_z = "00" or (c_z = "10" and c_in = '1') or (C_z = "01" and z_in = '1')) and ComBit = '0') then
								if ComBit = '1' then
									compliment := TwosComplement(Input_2);
								else
									compliment := Input_2;
								end if;
									
								Output <= Input_1 nand compliment;
								if (Input_1 nand compliment) = "0000000000000000" then
									zero <= '1';
								else
									zero <= '0';
								end if;
						  end if;

					 -------------- Set Equal and Less flags
					 when "1000" | "1001" | "1010" =>
						  if Input_1 = Input_2 then
								equal <= '1';
						  else
						      equal <= '0';
						  end if;
						  
						  if Input_1 < Input_2 then
								less <= '1';
						  else
						      less <= '0';
					     end if;

					 when others =>
						  OUtput <= Input_1 nand Input_2;
            end case;
    end process;

end behave;