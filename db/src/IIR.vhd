library IEEE;
use IEEE.std_logic_1164.all; 

entity IIR is  
	generic (Nbit : positive := 8);
	port (
		clk		:	in	std_ulogic;	-- clock
		rst_l	:	in	std_ulogic;	-- reset (active low)
		x		:	in	std_ulogic_vector(Nbit-1 downto 0); -- input	
		y		:	out	std_ulogic_vector(Nbit-1 downto 0)  -- output
	);
end IIR;	

architecture IIR_Arch of IIR is	 

-- Buses used for the internal connections among the delay elemets
type BusArray is array (0 to 4) of std_ulogic_vector(Nbit-1 downto 0);

-- D Flip Flop Register on Nbit bits
component Reg
	generic (Nbit : positive := 8);
	port (
		clk		:	in	std_ulogic; -- clock	
		rst_l	:	in	std_ulogic;	-- reset (active low)
		d		:	in	std_ulogic_vector(Nbit-1 downto 0);	-- input
		q		:	out	std_ulogic_vector(Nbit-1 downto	0)	-- output
	);
end component;

-- Ripple Carry Adder on Nbit bits: a + b + cin = (cout, s)
component RippleCarryAdder
	generic (Nbit : positive := 8);
	port (
		a		:	in	std_ulogic_vector(Nbit-1 downto 0); -- first element of the sum 
		b		:	in	std_ulogic_vector(Nbit-1 downto 0); -- second element of the sum
		cin		:	in	std_ulogic;	-- carry in
		cout	:	out	std_ulogic;	-- carry out
		s		:	out	std_ulogic_vector(Nbit-1 downto 0)  -- result of the sum
	);
end component;

-- Ripple Carry Adder/Subtractor on Nbit bits:
-- if d == 0 -> a + b + cin = (cout, s)
-- if d == 1 -> not(a) + b + cin = (cout, s)
-- In this second case (d == 1) using cin = 1 you can compute s = b - a
-- This feature is useful for computing the 2 complement
-- of a given number using b = 0 and cin = 1, in fact:
-- cpl2(a) = not(a) + 1
component RippleCarryAdderSubtractor
	generic (Nbit : positive := 8);
	port (
	a		:	in	std_ulogic_vector(Nbit-1 downto 0); -- first element of the sum 
	b		:	in	std_ulogic_vector(Nbit-1 downto 0);	-- second element of the sum
	d		:	in	std_ulogic;	-- flag for the operation: 0 -> sum / 1 -> subtraction
	cout	:	out	std_ulogic; -- carry out
	s		:	out	std_ulogic_vector(Nbit-1 downto 0)	-- result of the sum
	);
end component;

signal samples	:	BusArray; -- Connections between the register pairs  
signal toOut	:	std_ulogic_vector(Nbit+1 downto 0); -- Connection from the outputAdder
														-- to the output of the filter
signal auxBus1	:	std_ulogic_vector(Nbit+1 downto 0); -- samples(0)*1/4
signal auxBus2	:	std_ulogic_vector(Nbit+1 downto 0);	-- samples(4)*1/4

begin
	
	-- Instanciate the delay elements (registers)
	GEN: for i in 0 to 3 generate
		REGx: Reg generic map(Nbit) port map(clk, rst_l, samples(i), samples(i+1));
	end generate GEN;
	
	-- Compute x + samples(1)
	inputAdder: RippleCarryAdder
	generic map(Nbit)
	port map (
		a		=>	x,
		b		=>	samples(1),
		cin		=>	'0',
		cout	=>	open,
		s		=>	samples(0) 
	);
	
	-- Compute auxBus2 - auxBus1
	outputAdder: RippleCarryAdderSubtractor
	generic map(Nbit+2)
	port map (
		a		=>	auxBus1,
		b		=>	auxBus2,
		d		=>	'1',
		cout	=>	open,
		s		=>	toOut
	);
	-- Both samples(0) and samples(4) must be divided by 4, which is an arithmetic
	-- right shift by 2 bits
	auxBus1 <= samples(0)(Nbit-1) & samples(0)(Nbit-1) & samples(0);	-- times 1/4
	auxBus2 <= samples(4)(Nbit-1) & samples(4)(Nbit-1) & samples(4);	-- times 1/4
	
	-- The output is taken by the Nbit LSBs of the toOut signal
	y <= toOut(Nbit-1 downto 0);
	
end IIR_Arch;