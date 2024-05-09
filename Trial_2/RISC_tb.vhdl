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
	 	component RISC_Pipeline is	
	port (
	     clk: in std_logic;
		 reset:in std_logic
		   );
	end component;

begin
    dut_instance: RISC_Pipeline
        port map (
            clk => clk,
				reset => reset
        );
		  
    process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for 5 ns; 	
        end loop;
        wait;
    end process;
	 
	 reset <= '1', '0' after 20ns;
	 
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
