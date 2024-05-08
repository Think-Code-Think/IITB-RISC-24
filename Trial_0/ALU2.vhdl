library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU2 is
port   (
	     clk: in std_logic;
		  PC: IN STD_LOGIC_VECTOR(15 downto 0);
		  PCout : OUT STD_LOGIC_VECTOR(15 downto 0)
		   );
end ALU2;
--
--
--architecture behave of ALU2 is
--begin
-- 
--process(PC,CLK)
--variable T1: STD_LOGIC_VECTOR(15 downto 0);
--begin
--
--T1:="0000000000000001";
--if (clk'event and clk = '1') then
--	PCout <= STD_LOGIC_VECTOR(unsigned(PC) +unsigned(T1));
--end if;
--end process;
--end behave;
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
