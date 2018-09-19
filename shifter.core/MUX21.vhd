library IEEE;
use IEEE.std_logic_1164.all;
use WORK.all;


entity MUX21_GENERIC is
	Generic(N: integer := 32);
	Port (one:	In	std_logic_vector(N-1 downto 0);
	      zero:	In	std_logic_vector(N-1 downto 0);
	      sel:	In	std_logic;
	      Y:	Out	std_logic_vector(N-1 downto 0));
end MUX21_GENERIC;

architecture BEHAVIORAL of MUX21_GENERIC is
begin
        behavior : process (one,zero,sel)
        begin
        	if sel='1' then
        		Y <= one;
        	elsif sel='0' then
        		Y <= zero;
       		end if;	
        end process;
end BEHAVIORAL;
