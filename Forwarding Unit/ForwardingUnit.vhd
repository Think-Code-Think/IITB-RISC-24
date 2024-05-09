library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ForwardingUnit is
	port(
		ex_reg_addr, ma_reg_addr, wb_reg_addr, req_addr : in std_logic_vector(2 downto 0);
		ex_outval, ex_outalu, ma_outval, wb_outval : in std_logic_vector(15 downto 0);
		ex_op, ma_op : in std_logic_vector(3 downto 0);
		ex_outcond, ma_outcond : in std_logic_vector(1 downto 0);
		ex_write, ma_write, wb_write, ex_outc, ex_outz, ma_outc, ma_outz : in std_logic;
		
		fwd_reg_val : out std_logic_vector(15 downto 0);
		fwd_write : out std_logic
	);
end entity;

architecture forward of ForwardingUnit is
	
	signal reg_data : std_logic_vector(15 downto 0);
	signal reg_write : std_logic := '0';
	
begin
	
	fwd_reg_val <= reg_data;
	fwd_write <= reg_write;
	
	process(ex_reg_addr,ma_reg_addr,wb_reg_addr,req_addr,ex_outval,ex_outalu,ma_outval,wb_outval,ex_outcond,ex_write,ma_write,wb_write,ex_outc,ex_outz,ex_op,ma_op)
	begin
		if(req_addr = ex_reg_addr and ex_write = '1' and ex_outcond = "10" and ex_outc = '1' and (ex_op = "0001" or ex_op = "0010")) then
			reg_data <= ex_outalu;
			reg_write <= '1';
		elsif(req_addr = ex_reg_addr and ex_write = '1' and ex_outcond = "01" and ex_outz = '1' and (ex_op = "0001" or ex_op = "0010")) then
			reg_data <= ex_outalu;
			reg_write <= '1';
		elsif(req_addr = ex_reg_addr and ex_write = '1' and (ex_outcond = "00" or ex_outcond = "11") and (ex_op = "0001" or ex_op = "0010")) then	
			reg_data <= ex_outalu;
			reg_write <= '1';
		elsif(req_addr = ex_reg_addr and ex_write = '1' and ex_op = "0000") then
			reg_data <= ex_outalu;
			reg_write <= '1';
		elsif(req_addr = ex_reg_addr and ex_write = '1' and (ex_op = "0011" or ex_op = "0111" or ex_op = "0101")) then
			reg_data <= ex_outalu;
			reg_write <= '1';
		elsif(req_addr = ex_reg_addr and ex_write = '1' and not (ex_op = "0001" or ex_op = "0010" or ex_op = "0000" or ex_op = "1111")) then 
			reg_data <= ex_outval;
			reg_write <= '1';
		elsif(req_addr = ma_reg_addr and ma_write = '1' and ma_outcond = "10" and ma_outc = '1' and (ma_op = "0001" or ma_op = "0010")) then
			reg_data <= ma_outval;
			reg_write <= '1';
		elsif(req_addr = ma_reg_addr and ma_write = '1' and ma_outcond = "01" and ma_outz = '1' and (ma_op = "0001" or ma_op = "0010")) then
			reg_data <= ma_outval;
			reg_write <= '1';
		elsif(req_addr = ma_reg_addr and ma_write = '1' and (ma_outcond = "00" or ma_outcond = "11") and (ma_op = "0001" or ma_op = "0010")) then	
			reg_data <= ma_outval;
			reg_write <= '1';
		elsif(req_addr = ma_reg_addr and ma_write = '1' and not (ma_op = "0001" or ma_op = "0010" or ma_op = "1111")) then 
			reg_data <= ma_outval;
			reg_write <= '1';
		elsif(req_addr = wb_reg_addr and wb_write = '1') then
			reg_data <= wb_outval;
			reg_write <= '1';
		else
			reg_write <= '0';
		end if;
	end process;
end architecture;