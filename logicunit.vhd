library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logic_unit is
	generic(N : integer := 32);
	port(A 		  : in std_logic_vector(N-1 downto 0);
		 B 		  : in std_logic_vector(N-1 downto 0);
		 s		  : in std_logic_vector(3 downto 0);
		 output   : out std_logic_vector(N-1 downto 0));
end entity;


architecture structural of logic_unit is

	signal nA  : std_logic_vector(N-1 downto 0);
	signal nB  : std_logic_vector(N-1 downto 0);
	signal block0_out : std_logic_vector(N-1 downto 0);
	signal block1_out : std_logic_vector(N-1 downto 0);
	signal block2_out : std_logic_vector(N-1 downto 0);
	signal block3_out : std_logic_vector(N-1 downto 0);
	signal output_int : std_logic_vector(N-1 downto 0);
	
begin

	nA <= not A;
	nB <= not B;
	
	block_gen : for i in N-1 downto 0 generate
		block0_out(i) <= (s(0) nand nA(i)) nand nB(i);
		block1_out(i) <= (s(1) nand nA(i)) nand B(i);
		block2_out(i) <= (s(2) nand A(i)) nand nB(i);
		block3_out(i) <= (s(3) nand A(i)) nand B(i);
	end generate;
	
	out_gen : for i in N-1 downto 0 generate
		output_int(i) <= (block0_out(i) nand block1_out(i)) nand (block2_out(i) nand block3_out(i));
	end generate;
	
	output <= output_int;
	
end architecture;
