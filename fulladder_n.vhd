library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fulladder_n is
  generic (
    n : integer
  );
  port (
    cin   : in std_logic;
    x     : in std_logic_vector(n-1 downto 0);
    y     : in std_logic_vector(n-1 downto 0);
    cout  : out std_logic;
    z     : out std_logic_vector(n-1 downto 0)
  );
end fulladder_n;

architecture behavioral of fulladder_n is
signal zbuf : unsigned(n downto 0);
begin
  zbuf <= unsigned('0' & x) + unsigned('0' & y) when cin = '0' else
          unsigned('0' & x) + unsigned('0' & y) + 1;
  z <= std_logic_vector(zbuf(n-1 downto 0));
  cout <= zbuf(n);
end behavioral;
