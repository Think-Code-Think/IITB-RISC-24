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