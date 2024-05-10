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