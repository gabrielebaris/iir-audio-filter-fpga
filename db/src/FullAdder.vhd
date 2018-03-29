library IEEE;
use IEEE.std_logic_1164.all;
	
entity FullAdder is
	port (
	a		:	in	std_ulogic;
	b		:	in	std_ulogic;
	cin		:	in	std_ulogic;
	s		:	out std_ulogic;
	cout 	:	out std_ulogic
	);
end FullAdder;	

architecture FullAdder_Arch of FullAdder is
begin
	s <= a xor b xor cin;
	cout <= (a and b) or (a and cin) or (b and cin);
end FullAdder_Arch;