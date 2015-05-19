library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.monte_carlo.all;

entity fixedpoint_multiply is
GENERIC (
 	STOCK_WIDTH : natural := STOCK_W
 );
	port(
		data_in1 : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		data_in2 : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		data_out : out std_logic_vector(STOCK_WIDTH-1 downto 0)
	);
END ENTITY fixedpoint_multiply;
	
ARCHITECTURE behavioral OF fixedpoint_multiply IS

	SIGNAL temp_mult_out : std_logic_vector((STOCK_WIDTH*2)-1 downto 0);
	SIGNAL truncated_out : std_logic_vector(STOCK_WIDTH-1 downto 0);
BEGIN
	
	multiplication: process(clk,data_in2,data_in1) is
		variable result : integer := 0;
		variable data_in1_int : integer;
		variable data_in2_int : integer;

		BEGIN
			data_in1_int := to_integer(unsigned(data_in1));
			data_in2_int := to_integer(unsigned(data_in2));
			result := data_in2_int * data_in1_int;
			temp_mult_out <= std_logic_vector(to_unsigned(result,STOCK_WIDTH*2));
			truncated_out <= temp_mult_out(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);
	end process multiplication;

	data_out <= truncated_out;

end architecture behavioral;

