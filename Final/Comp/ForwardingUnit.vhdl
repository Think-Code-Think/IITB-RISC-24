library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ForwardingUnit is
	port(
		EX_dest_reg_add: in std_logic_vector(2 downto 0);
		MM_dest_reg_add: in std_logic_vector(2 downto 0);
		WB_dest_reg_add : in std_logic_vector(2 downto 0);
		OR_source_reg_add : in std_logic_vector(2 downto 0);
		OR_source_reg_data: in std_logic_vector(15 downto 0);
		EX_aluc : in std_logic_vector(15 downto 0);
		EX_Imm9_16bit : in std_logic_vector(15 downto 0);
		MM_mem_out : in std_logic_vector(15 downto 0);
		MEM_aluc : in std_logic_vector(15 downto 0);
		MEM_Imm9_16bit : in std_logic_vector(15 downto 0);
		WB_RFD3 : in std_logic_vector(15 downto 0);
		EX_opcode : in std_logic_vector(3 downto 0);
		MM_opcode : in std_logic_vector(3 downto 0);
		EX_instr_wr_reg, MM_instr_wr_reg, WB_instr_wr_reg: in std_logic;
		
		fwd_reg_val : out std_logic_vector(15 downto 0);
		hold_or_fwd: out std_logic
	);
end entity;

architecture forward of ForwardingUnit is

	
begin
	
	process(EX_instr_wr_reg,MM_instr_wr_reg ,WB_instr_wr_reg,
				EX_dest_reg_add,MM_dest_reg_add,WB_dest_reg_add,OR_source_reg_add,
				OR_source_reg_data,EX_aluc,EX_Imm9_16bit,MM_mem_out,MEM_aluc,MEM_Imm9_16bit,WB_RFD3,
				EX_opcode,MM_opcode)
		begin
		
			if ((EX_instr_wr_reg = '1') and (EX_dest_reg_add = OR_source_reg_add)) then
				
				case EX_opcode is 
				
					when "0001"|"0010"|"0000"|"1100"|"1101" =>
						fwd_reg_val <= EX_aluc;
						hold_or_fwd <= '0';
						
					when "0011" =>
						fwd_reg_val <= EX_Imm9_16bit;
						hold_or_fwd <= '0';
						
					when "0100"|"0110" =>
						fwd_reg_val <= "0000000000000000";
						hold_or_fwd <= '1';
					when others =>
						fwd_reg_val <= OR_source_reg_data;
						hold_or_fwd <= '0';
				end case;
			
			elsif ((MM_instr_wr_reg = '1') and (MM_dest_reg_add = OR_source_reg_add)) then
				hold_or_fwd <= '0';
				
				case MM_opcode is 
				
					when "0001"|"0010"|"0000"|"1100"|"1101" =>
						fwd_reg_val <= MEM_aluc;
						
						
					when "0011" =>
						fwd_reg_val <= MEM_Imm9_16bit;
						
						
					when "0100"|"0110" =>
						fwd_reg_val <= MM_mem_out;
						
					when others =>
						fwd_reg_val <= OR_source_reg_data;
				end case;
			
			elsif ((WB_instr_wr_reg = '1') and (WB_dest_reg_add = OR_source_reg_add)) then
				hold_or_fwd <= '0';
				fwd_reg_val <= WB_RFD3;
			
			else
				
				hold_or_fwd <= '0';
				fwd_reg_val <= OR_source_reg_data;
			end if;
					
	end process;
end architecture;