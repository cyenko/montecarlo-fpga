library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use work.monte_carlo.all;


entity pricer is
GENERIC (
 	STOCK_WIDTH : natural := STOCK_W
 );
	port(
		clk: in std_logic;
		Strike : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		A : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		B : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		C : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		constants_ready : in std_logic;

		data_out : out std_logic_vector(STOCK_WIDTH-1 downto 0);
		pricer_ready : out std_logic;
		
		reset : in std_logic
	);
END ENTITY pricer;

ARCHITECTURE behavioral OF pricer IS

	TYPE stateType is (s0,s1,s2);
	SIGNAL state, next_state : stateType := s0;

	--control signals (for state machine)
	SIGNAL gauss_ready : std_logic;
		--here would be the constants_ready signal that is an input

	--operation signals
	-- premium = (strike - (A*e^(B*gauss(0,1))))*C
	SIGNAL premium,gaussian_extended : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL gauss_out : std_logic_vector(12-1 downto 0);
	SIGNAL gauss_out_ext : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL B_x_gauss : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL exp_Bxgauss : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL A_x_expBxgauss : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL Strike_minus_Aexp_Bgauss : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL not_A_x_expBxgauss : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL premium_result : std_logic_vector(STOCK_WIDTH-1 downto 0);

	SIGNAL minus_2 : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL max_signal : std_logic_vector(STOCK_WIDTH-1 downto 0);

	SIGNAL zeros : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);


BEGIN

	zeros <= (others=>'0');
	
	minus_2 <= "1111111000000000";
	--2 = 			00000010.00000000
	--not 2 = 		11111101.11111111
	-- -2 = not2+1	11111110.00000000

	--have a state machine
	--3 states: waiting and output
	--state s0 => waiting for constants. simply output what was here before
	--state s1 => doing operation but waiting for gaussian. do everything along with the gaussian
	--state s2 => gaussian said ready, so output and wait until the constants_ready becomes 0 to stop output

	move_state : process (clk,reset) is 
	BEGIN 
	if rising_edge(clk) then 
		if reset='1' then
			state <= s0;
		else
			state <= next_state;
		end if;
	end if;
	end process move_state;


	state_machine : PROCESS (clk,reset,gauss_ready,constants_ready) IS 

	begin 
		if reset='1' then 
			next_state <= s0;
		end if;
		case state is 
			when s0 => 
				if constants_ready='1' then
					next_state <= s1;
				else
					next_state <= s0;
				end if;
				pricer_ready <= '0';
			when s1 =>
				if gauss_ready='1' then
					next_state <= s2;
				else
					next_state <= s1;
				end if;
				pricer_ready <='0';
			when s2 =>
				--in theory , you're grabbing and just putting it out
				next_state <= s0;
				pricer_ready <= '1';
		end case;
	end process;

		--operation is :
	-- premium = (strike - (A*e^(B*gauss(0,1))))*C

	--get gaussian and extend it however it should be
	--subtract 2 from it?
	gaussian_map : random_gaussian PORT MAP (
		clk => clk,
		reset_in => reset,
		random => gauss_out,
		ready => gauss_ready
		);

	--now change it so that it works with this!
	--currently it's a 12 bit vector where the first 2 bits are integer part
	--and the next 10 are the fixed point decimal side
	--	so we do a shift right by a few and extend it

	--make it into a correct thing (eliminate the least 2 significant bits)
	gaussian_extended <= "000000"&gauss_out(11 downto 2);

--	gaussian_correct_map : fulladder_n 
--		GENERIC MAP ( n => STOCK_WIDTH)
--		PORT MAP (
--				cin => '0',
--				x => gaussian_extended,
--				y => minus_2,
--				z => gauss_out_ext
--			);
	gauss_out_ext <= std_logic_vector(signed(gaussian_extended) + signed(minus_2));
	--get B*gauss(0,1)
--	b_x_gauss_map : fixedpoint_multiply PORT MAP (
--			clk => clk,
--			data_in1 => B,
--			data_in2 => gauss_out_ext,
--			data_out => B_x_gauss
--		);
	B_x_gauss <= std_logic_vector(signed(B) * signed(gauss_out_ext))(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);

	exp_Bxgauss_map : exp_fn PORT MAP (
			clk => clk,
			bitVector => B_x_gauss,
			outVector => exp_Bxgauss
		);


--	A_x_expBxgauss_map : fixedpoint_multiply PORT MAP (
--			clk => clk,
--			data_in1 => A,
--			data_in2 => exp_Bxgauss,
--			data_out => A_x_expBxgauss
--		);
	A_x_expBxgauss <= std_logic_vector(signed(A) * signed(exp_Bxgauss))(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);

	--do something for put/? operation!!!!
	--right now, assume just this: (Strike - A*exp(B*gauss(0,1)))*C
	--add strike + not(A_x_expBxgauss) + cin='1'

	--NEGATE IT!
--	not_map : for i in 0 to STOCK_WIDTH-1 GENERATE
--		not_bit_map : not_A_x_expBxgauss(i) <= not A_x_expBxgauss(i);
--	END GENERATE;
--
--	Strike_minus_Aexp_Bgauss_map : fulladder_n 
--		GENERIC MAP (n=>STOCK_WIDTH) 
--		PORT MAP (
--			cin => '1',
--			x => Strike,
--			y => not_A_x_expBxgauss,
--			z => Strike_minus_Aexp_Bgauss
--		);

	Strike_minus_Aexp_Bgauss <= std_logic_vector(signed(Strike) - signed(A_x_expBxgauss));

	process(Strike_minus_Aexp_Bgauss,zeros) is 
	begin 
		if signed (Strike_minus_Aexp_Bgauss) < 0 then 
			max_signal <= zeros;
		else 
			max_signal <= Strike_minus_Aexp_Bgauss;
		end if;
	end process;
--	max_0_or_signal_map : mux_n GENERIC MAP (n=>STOCK_WIDTH)
--		PORT MAP (
--			sel => Strike_minus_Aexp_Bgauss(STOCK_WIDTH-1),
--			src0 => Strike_minus_Aexp_Bgauss,
--			src1 => zeros,
--			z => max_signal
--		);
	
	--now times C for the output
	premium_result <= std_logic_vector(signed(max_signal) * signed(C))(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);
--	premium_map : fixedpoint_multiply PORT MAP (
--			clk => clk,
--			data_in1 => max_signal,
--			data_in2 => C,
--			data_out => premium_result
--		);

	--put it as the output!
	premium <= premium_result;
	clocked_out : process(clk,reset):
	begin
		if reset='1' then
			data_out <= zeros;
		else
			if rising_edge(clk) then 
				data_out <= premium;
			end if;
		end if;
	end process;

	--data_out <= premium;

end architecture behavioral;

