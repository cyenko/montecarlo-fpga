library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.monte_carlo.all;


entity constant_generator is
GENERIC (
 	STOCK_WIDTH : natural := STOCK_W
 );
	port(
		clk: in std_logic;
		stock : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
		vol : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		t : in std_logic_vector(3 downto 0);
		u : in std_logic_vector(STOCK_WIDTH-1 downto 0);

		--output
		A : out std_logic_vector (STOCK_WIDTH-1 downto 0);
		B : out std_logic_vector (STOCK_WIDTH-1 downto 0);
		C : out std_logic_vector (STOCK_WIDTH-1 downto 0);
		constantReady : out std_logic
	);
END ENTITY constant_generator;

ARCHITECTURE behavioral OF constant_generator IS

	SIGNAL vol_squared : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL u_minus_half_vol_sq_t : std_logic_vector(STOCK_WIDTH-1 downto 0);

BEGIN


	--A = Stock * exp (u-0.5*vol*vol)t
	vol_squared_map : multiplier PORT MAP ()
	

end architecture behavioral;

