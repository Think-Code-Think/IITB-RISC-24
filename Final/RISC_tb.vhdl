library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_tb is
end entity;

architecture tb_arch of RISC_tb is
    signal clk,reset: std_logic := '0';
	 signal mem_0_1,mem_2_3,mem_4_5,mem_6_7 : std_logic_vector(15 downto 0);
	 	component RISC_Pipeline is	
			port (
				 clk: in std_logic;
				 reset:in std_logic;
				 mem_0_1 : out std_logic_vector(15 downto 0); 
				 mem_2_3 : out std_logic_vector(15 downto 0); 
				 mem_4_5 : out std_logic_vector(15 downto 0); 
				 mem_6_7 : out std_logic_vector(15 downto 0)
				);
	end component;

begin
    dut_instance: RISC_Pipeline
        port map (
            clk => clk,
				reset => reset,
				mem_0_1 => mem_0_1,
				mem_2_3 => mem_2_3,
				mem_4_5 => mem_4_5,
				mem_6_7 => mem_6_7
        );
		  
    process
    begin
        while now < 100000 ns loop
            clk <= not clk;
            wait for 5 ns; 	
        end loop;
        wait;
    end process;
	 
	 reset <= '1', '0' after 20 ns;
	
end architecture tb_arch;
