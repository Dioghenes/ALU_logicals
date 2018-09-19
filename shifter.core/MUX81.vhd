library ieee;
use ieee.std_logic_1164.all;
use work.all;


entity MUX81_GENERIC is
	Generic(N: integer := 32);
	Port (seven:In	std_logic_vector(N-1 downto 0);
		  six:  In  std_logic_vector(N-1 downto 0);
		  five:	In	std_logic_vector(N-1 downto 0);
	      four:	In	std_logic_vector(N-1 downto 0);
		  three:In	std_logic_vector(N-1 downto 0);
		  two:  In  std_logic_vector(N-1 downto 0);
		  one:	In	std_logic_vector(N-1 downto 0);
	      zero:	In	std_logic_vector(N-1 downto 0);
	      SEL:	In	std_logic_vector(2 downto 0);
	      Y:	Out	std_logic_vector(N-1 downto 0));
end entity;


-- Behavioral description of the MUX41
architecture BEHAVIORAL of MUX81_GENERIC is
begin
        behavior : process (seven,six,five,four,three,two,one,zero,SEL)
        begin
        	if SEL="111" then
        		Y <= seven;
        	elsif SEL="110" then
        		Y<= six;
        	elsif SEL="101" then
        		Y <= five;
        	elsif SEL="100" then
        		Y <= four;
        	elsif SEL="011" then
        		Y <= three;
        	elsif SEL="010" then
        		Y<= two;
        	elsif SEL="001" then
        		Y <= one;
        	elsif SEL="000" then
        		Y <= zero;
       		end if;	
        end process;
end architecture;
