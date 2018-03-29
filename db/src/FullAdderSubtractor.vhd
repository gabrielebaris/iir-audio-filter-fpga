library IEEE;
use IEEE.std_logic_1164.all;
	
entity FullAdderSubtractor is
	port (
	a		:	in	std_ulogic;
	b		:	in	std_ulogic;
	d		:	in	std_ulogic;
	cin		:	in	std_ulogic;
	s		:	out std_ulogic;
	cout 	:	out std_ulogic
	);
end FullAdderSubtractor;	

architecture FullAdderSubtractor_Arch of FullAdderSubtractor is

component FullAdder
	port (
		a		:	in	std_ulogic;
		b		:	in	std_ulogic;
		cin		:	in	std_ulogic;
		s		:	out std_ulogic;
		cout 	:	out std_ulogic
	);
end component;

signal muxA	:	std_ulogic;


begin
	internalFullAdder: FullAdder
	port map(
		a		=>	muxA,
		b		=>	b,
		cin		=>	cin,
		s		=>	s,
		cout	=>	cout
	);					
	
	muxA <=	a when d = '0' else not(a);
	
end FullAdderSubtractor_Arch;