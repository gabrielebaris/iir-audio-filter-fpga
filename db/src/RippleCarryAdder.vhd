library IEEE;
use IEEE.std_logic_1164.all;

entity RippleCarryAdder is
	generic (Nbit : positive := 8);
	port (
	a		:	in	std_ulogic_vector(Nbit-1 downto 0); 
	b		:	in	std_ulogic_vector(Nbit-1 downto 0);
	cin		:	in	std_ulogic;
	cout	:	out	std_ulogic;
	s		:	out	std_ulogic_vector(Nbit-1 downto 0)
	);
end RippleCarryAdder;


architecture RippleCarryAdder_Arch of RippleCarryAdder is

component FullAdder is
	port (
	a		:	in	std_ulogic;
	b		:	in	std_ulogic;
	cin		:	in	std_ulogic;
	s		:	out std_ulogic;
	cout 	:	out std_ulogic
	);
end component;

signal carries : std_ulogic_vector(Nbit downto 0);

begin
	carries(0) <= cin;
	GEN: for i in 0 to Nbit-1 generate
		FAx: FullAdder port map(a(i), b(i), carries(i), s(i), carries(i+1));
	end generate GEN;
	cout <= carries(Nbit);
end RippleCarryAdder_Arch;