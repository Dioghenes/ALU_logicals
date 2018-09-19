library IEEE;
use IEEE.std_logic_1164.all;
use WORK.all;


entity MUX41_GENERIC is
	Generic(N: integer := 32);
	Port (three:in	std_logic_vector(N-1 downto 0);
		  two:  in  std_logic_vector(N-1 downto 0);
		  one:	in	std_logic_vector(N-1 downto 0);
	      zero:	in	std_logic_vector(N-1 downto 0);
	      sel:	in	std_logic_vector(1 downto 0);
	      Y:	out	std_logic_vector(N-1 downto 0));
end entity;

architecture BEHAVIORAL of MUX41_GENERIC is
begin
        behavior : process (three,two,one,zero,sel)
        begin
        	if sel="11" then
        		Y <= three;
        	elsif sel="10" then
        		Y<= two;
        	elsif sel="01" then
        		Y <= one;
        	elsif sel="00" then
        		Y <= zero;
       		end if;	
        end process;
end architecture;
