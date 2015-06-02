library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use work.monte_carlo.all;


entity adder_signed is
    Port ( clk : in  STD_LOGIC;
           a : in  STD_LOGIC_VECTOR (11 downto 0);
           b : in  STD_LOGIC_VECTOR (11 downto 0);
           r : out  STD_LOGIC_VECTOR (11 downto 0));      
end adder_signed;

architecture behavioral of adder_signed is

signal r_next : std_logic_vector(11 downto 0) := (others => '0');

begin

process(clk)

begin

if rising_edge(clk) then
    r <= r_next;
    r_next <= std_logic_vector(signed(a)+signed(b));
end if;

end process;

end behavioral;