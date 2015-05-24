library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.monte_carlo.all;


entity random_fn is
GENERIC (
 	STOCK_WIDTH : natural := STOCK_W
 );
	port(
		clk: in std_logic;
		data_in : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		data_out : out std_logic_vector(STOCK_WIDTH-1 downto 0)
	);
END ENTITY random_fn;

ARCHITECTURE behavioral OF random_fn IS

	SIGNAL exp_out : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL exp_in : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL mult_out : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL mult_out_long : std_logic_vector(2*STOCK_WIDTH -1 downto 0);
	SIGNAL multiplier: std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);

BEGIN
	
	
	multiplier <= x"0100";
	--do a multiplication 
	multiplication: process (clk,data_in) is 
		variable result : integer := 0;
		variable a: integer;
		variable b: integer;
		
		BEGIN  
			a := to_integer(unsigned(data_in));
			b := to_integer(unsigned(multiplier));
			result := a * b;
			mult_out_long <= std_logic_vector(to_unsigned(result,STOCK_WIDTH*2));
			mult_out <= mult_out_long(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);

	end process multiplication;
	
	exp_map: exp_fn PORT MAP (clk=>clk,bitVector => mult_out, outVector=>exp_out);
	
	data_out <= exp_out;
	

end architecture behavioral;

