library IEEE;
use IEEE.std_logic_1164.all;

-- 16-bit IIR filter
entity IIR16bit is
	port (
		clk		:	in	std_ulogic;	-- clock
		rst_l	:	in	std_ulogic;	-- reset (active low)
		x		:	in	std_ulogic_vector(15 downto 0); -- input	
		y		:	out	std_ulogic_vector(15 downto 0)  -- output
	);
end IIR16bit;	

architecture IIR_Arch of IIR16bit is

component IIR 
	generic (Nbit : positive := 8);
	port (
		clk		:	in	std_ulogic;
		rst_l	:	in	std_ulogic;
		x		:	in	std_ulogic_vector(Nbit-1 downto 0);	
		y		:	out	std_ulogic_vector(Nbit-1 downto 0)
	);
end component;

begin
	
	-- Instanciate a 16-bit filter
	filter: IIR
	generic map(16)
	port map(clk, rst_l, x, y);

end IIR_Arch;