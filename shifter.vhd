library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter is
	generic(N : integer := 32);
	port(A 			: in std_logic_vector(N-1 downto 0);
		 B 			: in std_logic_vector(N-1 downto 0);
		 logic_arith: in std_logic;
		 l_r		: in std_logic;
		 output   	: out std_logic_vector(N-1 downto 0));
end entity;

architecture structural of barrel_shifter is

	component MUX21_GENERIC is
		Generic(N: integer := 32);
		Port (one:	In	std_logic_vector(N-1 downto 0);
		      zero:	In	std_logic_vector(N-1 downto 0);
		      SEL:	In	std_logic;
		      Y:	Out	std_logic_vector(N-1 downto 0));
	end component;
	
	component MUX41_GENERIC is
	Generic(N: integer := 32);
	Port (three:In	std_logic_vector(N-1 downto 0);
		  two:  In  std_logic_vector(N-1 downto 0);
		  one:	In	std_logic_vector(N-1 downto 0);
	      zero:	In	std_logic_vector(N-1 downto 0);
	      SEL:	In	std_logic_vector(1 downto 0);
	      Y:	Out	std_logic_vector(N-1 downto 0));
	end component;
	
	component MUX81_GENERIC is
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
	end component;
	
	type cmasks_array is array(0 to N/8-1) of std_logic_vector(N+7 downto 0);
	type fmasks_array is array(0 to 7) of std_logic_vector(N-1 downto 0);
	signal cmasks_R : cmasks_array;
	signal cmasks_L : cmasks_array;
	signal cmasks: cmasks_array;
	signal fmasks : fmasks_array;
	signal l2_chosen_mask : std_logic_vector(N+7 downto 0);
	signal fine_sel : std_logic_vector(2 downto 0);
	
begin

	cmasks_gen: for i in 1 to N/8 generate 	
		cmasks_R(i-1)(N+7 downto N+8-8*i) <= (others => (A(N-1) and logic_arith));
		cmasks_R(i-1)(N+7-8*i downto 0) <= A(N-1 downto 8*(i-1));
		cmasks_L(i-1)(N+7 downto 8*i-1) <= '0' & A(N-8*(i-1)-1 downto 0);
		cmasks_L(i-1)(8*i-2 downto 0) <= (others => '0');
	end generate;
	
	level_1: for i in 0 to N/8-1 generate
		mux_1_i : MUX21_GENERIC generic map(N+8)
					  			port map(cmasks_L(i),cmasks_R(i),l_r,cmasks(i));
	end generate;
	
	level_2: MUX41_GENERIC generic map(N+8)
						   port map(cmasks(3),
						   			cmasks(2),
						   			cmasks(1),
						   			cmasks(0),
						   			B(4 downto 3),
						   			l2_chosen_mask);
						   			
	fmasks_gen: for i in 0 to 7 generate
		fmasks(i) <= l2_chosen_mask(N+i-1 downto i);
	end generate;				   			
	
	fine_sel(2) <= B(2) xor l_r;
	fine_sel(1) <= B(1) xor l_r;
	fine_sel(0) <= B(0) xor l_r;
	
	level_3: MUX81_GENERIC generic map(32)
						   port map(fmasks(7),
						   			fmasks(6),
						   			fmasks(5),
						   			fmasks(4),
						   			fmasks(3),
						   			fmasks(2),
						   			fmasks(1),
						   			fmasks(0),
						   			fine_sel,
						   			output);
	
end architecture;
