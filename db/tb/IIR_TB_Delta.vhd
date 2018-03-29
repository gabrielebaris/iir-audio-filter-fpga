library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- for the casting 

-- This testbench aims to check if the impulse response
-- of the filter is the same as the one designed in MATLAB

entity IIR_TB_Delta is
end IIR_TB_Delta;

architecture TB_Arch of IIR_TB_Delta is	

component IIR  
	generic (Nbit : positive := 8);
	port (
		clk		:	in	std_ulogic;
		rst_l	:	in	std_ulogic;
		x		:	in	std_ulogic_vector(Nbit-1 downto 0);	
		y		:	out	std_ulogic_vector(Nbit-1 downto 0)
	);
end component;

	constant BITS		:	positive	:=	16;
	constant SAMPLES 	:	positive	:= 	5;

	signal clk		: 	std_ulogic	:= '0';
	signal rst_l 	: 	std_ulogic;
	signal sample	:	std_ulogic_vector(BITS-1 downto 0);	
	signal output	:	std_ulogic_vector(BITS-1 downto 0);
	signal enable	:	std_ulogic	:=	'1';
	signal expected :	std_ulogic_vector(BITS-1 downto 0);
	
	-- Data type to store the sequence of samples
	type WAV_IN is array (0 to SAMPLES-1) of std_ulogic_vector(BITS-1 downto 0);

begin
	
	filter: IIR
	generic map(BITS)
	port map(clk, rst_l, sample, output);
	
	-- clock generator
	clk <= not clk and enable after 11338 ns; -- 44100Hz clock
	
	-- stimuli
	driver_p: process
	
	variable delta_in : WAV_IN := ("0000000000000001", "0000000000000000",
								   "0000000000000000", "0000000000000000",
						           "0000000000000000");
	
	variable expected_resp : WAV_IN := ("1111111111111111", "1111111111111111",
								   		"1111111111111111", "1111111111111111",
						           		"0000000000000000");
	
	begin
		
		-- inital reset of the filter
		rst_l <= '0';
		wait until clk'event and clk='1';
		rst_l <= '1';
		
		-- loop over all the samples 
		for i in 0 to SAMPLES-1 loop	
			
			sample <= delta_in(i);
			expected <= expected_resp(i);
			
			
			wait until clk'event and clk='1'; 
			
			-- If the actual output and the expected output
			-- mismatch, raise an asserion
			assert (output = expected)
			report "Mismatch for index i = " & integer'image(i)
			severity error;
			
		end loop;	 
		
		enable <= '0';
		end process;

end TB_Arch;