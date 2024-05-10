--LIBRARY IEEE;
--USE IEEE.STD_LOGIC_1164.ALL;
--
--entity RISC_tb is
--end entity RISC_tb;
--
--architecture bhv of RISC_tb is
--	component RISC_Pipeline is	
--	port (
--	     clk: in std_logic;
--		 reset:in std_logic
--		   );
--	end component;
--
--signal clk: std_logic := '0';
--signal reset : std_logic := '0';
--constant clk_period : time := 20 ns;
--
--begin
--	dut_instance: RISC_Pipeline port map(clk, reset);
--	clk <= not clk after clk_period/2 ;
--	reset <= '0';
--end bhv;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_tb is
end entity;

architecture tb_arch of RISC_tb is
    signal clk,reset: std_logic := '0';
	 signal mem_0,mem_1,mem_2,mem_3 : std_logic_vector(15 downto 0);
	 	component RISC_Pipeline is	
			port (
				 clk: in std_logic;
				 reset:in std_logic;
				 mem_0 : out std_logic_vector(15 DOWNTO 0); 
				 mem_1 : out std_logic_vector(15 DOWNTO 0); 
				 mem_2 : out std_logic_vector(15 DOWNTO 0); 
				 mem_3 : out std_logic_vector(15 DOWNTO 0)
				);
	end component;

begin
    dut_instance: RISC_Pipeline
        port map (
            clk => clk,
				reset => reset,
				mem_0 => mem_0,
				mem_1 => mem_1,
				mem_2 => mem_2,
				mem_3 => mem_3
        );
		  
    process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for 5 ns; 	
        end loop;
        wait;
    end process;
	 
	 reset <= '1', '0' after 20 ns;
	 
--	     process
--    begin
--        while now < 1000 ns loop
--            wait for 400ns;
--				reset <= '1';
--				wait for 100ns;
--				reset <= '0';
--        end loop;
--        wait;
--    end process;
end architecture tb_arch;
