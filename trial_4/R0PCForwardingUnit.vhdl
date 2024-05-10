library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity R0PCForwardingUnit is
	port(
		EX_dest_reg_add: in std_logic_vector(2 downto 0);
		MM_dest_reg_add: in std_logic_vector(2 downto 0);
		
		PC_selected_without_fwd: in std_logic_vector(15 downto 0);
		EX_aluc : in std_logic_vector(15 downto 0);
		EX_Imm9_16bit : in std_logic_vector(15 downto 0);
		MM_mem_out : in std_logic_vector(15 downto 0);
		
		EX_opcode : in std_logic_vector(3 downto 0);
		MM_opcode : in std_logic_vector(3 downto 0);
		
		EX_instr_wr_reg, MM_instr_wr_reg: in std_logic;
		
		pc_out : out std_logic_vector(15 downto 0);
		flush_id_or_ex: out std_logic;
		flush_mem: out std_logic
	);
end entity;

architecture forward of R0PCForwardingUnit is
	
begin
	
	process(EX_instr_wr_reg,MM_instr_wr_reg ,
				EX_dest_reg_add,MM_dest_reg_add,
				PC_selected_without_fwd,EX_aluc,EX_Imm9_16bit,MM_mem_out,
				EX_opcode,MM_opcode)
		begin
		
			if ((EX_instr_wr_reg = '1') and (EX_dest_reg_add = "000")) then
				
				case EX_opcode is 
				
					when "0001"|"0010"|"0000"|"1100"|"1101" =>
						pc_out <= EX_aluc;
						flush_id_or_ex <= '1';
						flush_mem <= '0';
						
					when "0011" =>
						pc_out <= EX_Imm9_16bit;
						flush_id_or_ex <= '1';
						flush_mem <= '0';
						
					when others =>
						pc_out <= PC_selected_without_fwd;
						flush_id_or_ex <= '0';
						flush_mem <= '0';
					
				end case;
			
			elsif ((MM_instr_wr_reg = '1') and (MM_dest_reg_add = "000")) then
				
				case MM_opcode is 
					
					when "0100"|"0110" =>
						pc_out <= MM_mem_out;
						flush_id_or_ex <= '1';
						flush_mem <= '1';
					
					when others =>
						pc_out <= PC_selected_without_fwd;
						flush_id_or_ex <= '0';
						flush_mem <= '0';
					
				end case;
			
			
			else
						pc_out <= PC_selected_without_fwd;
						flush_id_or_ex <= '0';
						flush_mem <= '0';
					
			end if;
					
	end process;
end architecture;