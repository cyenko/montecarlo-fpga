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

--Using Logic Operators to describe actions of decoder

--A <= data_in(3);
--B <= data_in(2);
--C <= data_in(1);
--D <= data_in(0);
--
--segments_out(0) <= NOT (A OR C OR (B AND D) OR ((NOT A) AND (NOT B) AND (NOT C) AND (NOT D)));
--segments_out(1) <= NOT ((NOT B) OR ((NOT A) AND (NOT C) AND (NOT D)) OR (A AND (NOT C) AND D) OR ((NOT A) AND C AND D));
--segments_out(2) <= NOT (((NOT A) AND B) OR (A AND (NOT B)) OR ((NOT C) AND D) OR ((NOT A) AND (NOT B) AND D) OR ((NOT A) AND (NOT C) AND (NOT D)));
--segments_out(3) <= NOT (((NOT A) AND (NOT B) AND (NOT D)) OR (B AND (NOT C) AND D) OR (B AND C AND (NOT D)) OR ((NOT B) AND C AND D) OR (A AND (NOT C) AND (NOT D)));
--segments_out(4) <= NOT (((NOT A) AND (NOT B) AND (NOT D)) OR (C AND (NOT D)) OR (A AND B AND C) OR (A AND (NOT B)) OR (A AND (NOT C) AND (NOT D)));
--segments_out(5) <= NOT (A OR (B AND C AND (NOT D)) OR ((NOT C) AND (NOT D)) OR ((NOT A) AND B AND (NOT C)));
--segments_out(6) <= NOT (((NOT A) AND (NOT B) AND C) OR ((NOT A) AND B AND (NOT C)) OR (A AND (NOT B)) OR (A AND C) OR (C AND (NOT D)));

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




