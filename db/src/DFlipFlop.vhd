library IEEE;
use IEEE.std_logic_1164.all;

entity DFlipFlop is
	port(
		clk		:	in	std_ulogic;	
		rst_l	:	in	std_ulogic;
		d		:	in	std_ulogic;
		q		:	out	std_ulogic
	);
end DFlipFlop;

architecture DFlipFlop_Arch of DFlipFlop is
begin
	DFF_Proc: process(clk, rst_l)
	begin
		if rst_l = '0' then
			q <= '0';
		elsif (clk = '1' and clk'event) then
			q <= d;
		end if;
	end process;
end DFlipFlop_Arch;