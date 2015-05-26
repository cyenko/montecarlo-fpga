library ieee;
use ieee.std_logic_1164.all;
use work.monte_carlo.all;

entity mux_n is
  generic (
	n	: integer
  );
  port (
	sel	  : in	std_logic;
	src0  :	in	std_logic_vector(n-1 downto 0);
	src1  :	in	std_logic_vector(n-1 downto 0);
	z	  : out std_logic_vector(n-1 downto 0)
  );
end entity mux_n;

architecture behavioral of mux_n is
begin
  z	<= src0 when sel = '0' else src1;
end architecture behavioral;
