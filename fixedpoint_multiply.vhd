library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.monte_carlo.all;

entity fixedpoint_multiply is
GENERIC (
 	STOCK_WIDTH : natural := STOCK_W
 );
	port(
		clk : in std_logic;
		data_in1 : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		data_in2 : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		data_out : out std_logic_vector(STOCK_WIDTH-1 downto 0)
	);
END ENTITY fixedpoint_multiply;
	
ARCHITECTURE behavioral OF fixedpoint_multiply IS

	SIGNAL temp_mult_out : std_logic_vector((STOCK_WIDTH*2)-1 downto 0);
	SIGNAL truncated_out : std_logic_vector(STOCK_WIDTH-1 downto 0);
	signal not_data_in1, not_data_in2 : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
	signal minus_data_in1, minus_data_in2 : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL zeros : STD_LOGIC_VECTOR(STOCK_WIDTH-1 DOWNTO 0);
BEGIN
	zeros <= (others=>'0');
	not_map: for i in 0 to STOCK_WIDTH-1 generate
		not1_map : not_data_in1(i) <= not data_in1(i);
		not2_map : not_data_in2(i) <= not data_in2(i);
	end generate;

	minus_data1_map : fulladder_n 
		generic map (n=>STOCK_WIDTH)
		port map ( cin => '1', x => not_data_in1, y=>zeros,z=>minus_data_in1);
	
	minus_data2_map : fulladder_n
		generic map (n=>STOCK_WIDTH)
		port map (cin => '1', x=> not_data_in2, y=>zeros, z=>minus_data_in2);
			
	
	multiplication: process(clk,data_in2,data_in1) is
		variable result : integer := 0;
		variable data_in1_int : integer;
		variable data_in2_int : integer;
		variable data_in1_pos : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
		variable data_in2_pos : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
		variable minus_amt : integer := 0;
		
		

		BEGIN
			minus_amt := 0;
			if data_in1(STOCK_WIDTH-1)='0' then
				data_in1_pos := data_in1;
			else 
				data_in1_pos := minus_data_in1;
				minus_amt := minus_amt + 1 ;
			end if;

			if data_in2(STOCK_WIDTH-1)='0' then
				data_in2_pos := data_in2;
			else
				data_in2_pos := minus_data_in2;
				minus_amt := minus_amt + 1 ;
			end if;
				

			data_in1_int := to_integer(unsigned(data_in1_pos));
			data_in2_int := to_integer(unsigned(data_in2_pos));
			result := data_in2_int * data_in1_int;
			
			if minus_amt=1 then
				result := 0 - result;
			end if;			

			temp_mult_out <= std_logic_vector(to_signed(result,STOCK_WIDTH*2));
			truncated_out <= temp_mult_out(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);
	end process multiplication;

	data_out <= truncated_out;

end architecture behavioral;

