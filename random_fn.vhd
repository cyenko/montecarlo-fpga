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
BEGIN
	data_map: exp PORT MAP (clk,data_in,data_out);

end architecture behavioral;

