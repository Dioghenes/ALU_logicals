library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.myTypes.all;

entity comparator is
	generic(N		: integer := 32);
	port(ALU_OPCODE : in aluOp; -- You need to implement this type to make it work
		 COMP_signA	: in std_logic;
		 COMP_signB	: in std_logic;
		 ADD_out	: in std_logic_vector(N-1 downto 0);
		 ADD_cout	: in std_logic;
		 output		: out std_logic_vector(N-1 downto 0));
end entity;

architecture structural of comparator is
	signal zero 	: std_logic;
	signal zero_nor : std_logic_vector(N/2-1 downto 0);
	signal zero_and : std_logic_vector(N/2-2 downto 0);
begin
	-- Generate the Z signal, used to make the comparison
	zero_nor_gen : for i in 0 to N/2-1 generate
		zero_nor(i) <= ADD_out(2*i) nor ADD_out(2*i+1);
	end generate;
	zero_and_gen : for i in 0 to N/2-2 generate
		zero_and_0 : if i=0 generate
			zero_and(i) <= zero_nor(i) and zero_nor(i+1);
		end generate;
		zero_gen_i : if i>0 generate
			zero_and(i) <= zero_nor(i+1) and zero_and(i-1);
		end generate;
	end generate;
	zero <= zero_and(N/2-2);
		
	-- Set all the MSBs to 0
	output(N-1 downto 1) <= (others=>'0');
	
	-- Set the LSB according to the comparison required (MUX-like process)
	set_lsb: process(ALU_OPCODE,ADD_cout,zero,COMP_signA,COMP_signB)
	begin
		case ALU_OPCODE is
			when SEQ | SEQI =>
				output(0) <= zero; 
			when SNE | SNEI =>
				output(0) <= not zero; 
			when SLEU | SLEUI =>
				output(0) <= (not ADD_cout) or zero; 
			when SGEU | SGEUI =>
				output(0) <= ADD_cout;
			when SLTU | SLTUI =>
				output(0) <= not ADD_cout; 	
			when SGTU | SGTUI =>
				output(0) <= (not zero) and ADD_cout; 
			when SLE | SLEI =>
				output(0) <= ((not ADD_cout or zero) and (COMP_signA xnor COMP_signB)) or (COMP_signA and not COMP_signB); 
			when SGE | SGEI =>
				output(0) <= (ADD_cout and (COMP_signA xnor COMP_signB)) or (not COMP_signA and COMP_signB);
			when SLT | SLTI =>
				output(0) <= (not ADD_cout and (COMP_signA xnor COMP_signB)) or (COMP_signA and not COMP_signB); 		
			when SGT | SGTI =>
				output(0) <= ((not zero and ADD_cout) and (COMP_signA xnor COMP_signB)) or (not COMP_signA and COMP_signB); 				
			when others =>
				output(0) <= '0'; 
		end case;
	end process;
	
end architecture;
