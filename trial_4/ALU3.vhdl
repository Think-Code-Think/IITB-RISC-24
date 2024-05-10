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
