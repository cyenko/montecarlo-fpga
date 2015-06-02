library IEEE;
use IEEE.std_logic_1164.all;
--Additional standard or custom libraries go here

entity leddcd is
    port(
            data_in         :in std_logic_vector (3 downto 0);
            segments_out    :out std_logic_vector (6 downto 0)
        );
end entity leddcd;

architecture data_flow of leddcd is

--Signals and components go here
signal A,B,C,D : std_logic;
begin

segments_out <= "1000000" when data_in = "0000" else
	"1111001" when data_in = "0001" else --1
	"0100100" when data_in = "0010" else --2
	"0110000" when data_in = "0011" else --3
	"0011001" when data_in = "0100" else --4
	"0010010" when data_in = "0101" else --5
	"0000010" when data_in = "0110" else --6
	"1111000" when data_in = "0111" else --7 
	"0000000" when data_in = "1000" else --8 
	"0011000" when data_in = "1001" else --9
	"0001000" when data_in = "1010" else --A
	"0000011" when data_in = "1011" else --b 
	"1000110" when data_in = "1100" else --C
	"0100001" when data_in = "1101" else --d
	"0000110" when data_in = "1110" else --E
	"0001110" when data_in = "1111" else --F
	"0000000";

end architecture data_flow;




