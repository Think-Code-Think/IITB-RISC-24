library ieee;
use ieee.std_logic_1164.all;

entity Register_File is 
port(  
        A1 : in std_logic_vector(2 downto 0); 
        A2 : in std_logic_vector(2 downto 0); 
        A3 : in std_logic_vector(2 downto 0); 
        D3 : in std_logic_vector(15 downto 0);
		  R0in : in std_logic_vector(15 downto 0);
		  WR_E_R0: in std_logic;
        WR_E : in std_logic; 
        reset : in std_logic;
        clk : in std_logic; 
        D1 : out std_logic_vector(15 downto 0); 
        D2 : out std_logic_vector(15 downto 0); 
        R0_PC : out std_logic_vector(15 downto 0)  
    );
end entity;

architecture inside of Register_File is    
	     signal R0 : std_logic_vector(15 downto 0) ;
		 signal R1 : std_logic_vector(15 downto 0) ;
		 signal R2 : std_logic_vector(15 downto 0) ;
		 signal R3 : std_logic_vector(15 downto 0) ;
		 signal R4 : std_logic_vector(15 downto 0) ;
		 signal R5 : std_logic_vector(15 downto 0) ;
		 signal R6 : std_logic_vector(15 downto 0) ;
		 signal R7 : std_logic_vector(15 downto 0) ;
begin
    
write_process: process(A3,WR_E,clk,reset,WR_E_R0,R0in) 


    begin
	 
	    if(reset = '1') then           
            R0 <= "0000000000000000";
            R1 <= "0000000000000000";
            R2 <= "0000000000000000";
            R3 <= "0000000000000000";
            R4 <= "0000000000000000";
            R5 <= "0000000000000000";
            R6 <= "0000000000000000";
            R7 <= "0000000000000000";
				
elsif (clk'event and clk = '1') then   
   if(WR_E_R0 = '1') then
      R0 <= R0in;
   end if;						  
	if(WR_E = '1') then
				
                if(A3 = "000") then     
                    R0 <= D3;
                
                elsif(A3 = "001") then
                    R1 <= D3;
						  
                elsif(A3 = "010") then
                    R2 <= D3;
						  
                elsif(A3 = "011") then
                    R3 <= D3;

                elsif(A3 = "100") then
                    R4 <= D3;

                elsif(A3 = "101") then
                    R5 <= D3;
	
                elsif(A3 = "110") then
                    R6 <= D3;
 		 
                elsif(A3 = "111") then
                    R7 <= D3;
						else
							null;
                end if;
    end if;
end if;
end process write_process;
	 
read_process: process(A1,A2,R0,R1,R2,R3,R4,R5,R6,R7) 

begin
        
            if(A1 = "000")    then  
                D1 <= R0;
            elsif(A1 = "001") then
                D1 <= R1;
            elsif(A1 = "010") then
                D1 <= R2;
            elsif(A1 = "011") then
                D1 <= R3;
            elsif(A1 = "100") then
                D1 <= R4;
            elsif(A1 = "101") then
                D1 <= R5;
            elsif(A1 = "110") then
                D1 <= R6;
            elsif(A1 = "111") then
                D1 <= R7;
				else 
					D1 <= R0;	
            end if;
				
            if(A2 = "000")    then    
                D2 <= R0;
            elsif(A2 = "001") then
                D2 <= R1;
            elsif(A2 = "010") then
                D2 <= R2;
            elsif(A2 = "011") then
                D2 <= R3;
            elsif(A2 = "100") then
                D2 <= R4;
            elsif(A2 = "101") then
                D2 <= R5;
            elsif(A2 = "110") then
                D2 <= R6;
            elsif(A2 = "111") then
                D2 <= R7;
				else 
					D2 <= R0;
            end if;    
  
end process read_process;

R0_PC <= R0;
end inside;