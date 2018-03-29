library IEEE;
use IEEE.std_logic_1164.all;

entity Reg is
	generic (Nbit : positive := 8);
	port (
		clk		:	in	std_ulogic;	
		rst_l	:	in	std_ulogic;
		d		:	in	std_ulogic_vector(Nbit-1 downto 0);
		q		:	out	std_ulogic_vector(Nbit-1 downto	0)
	);
end Reg;

-- We can write the register in a structural way or using a process

architecture Reg_Arch of Reg is	 

component DFlipFlop 
	port(
		clk		:	in	std_ulogic;	
		rst_l	:	in	std_ulogic;
		d		:	in	std_ulogic;
		q		:	out	std_ulogic
	);
end component;

begin		
	GEN: for i in 0 to Nbit-1 generate
		DFFx: DFlipFlop port map(clk, rst_l, d(i), q(i));
	end generate GEN;
end Reg_Arch;		 
