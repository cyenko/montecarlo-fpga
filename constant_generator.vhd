library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use work.monte_carlo.all;


ENTITY constant_generator is
	GENERIC (
		STOCK_WIDTH : natural := STOCK_W;
		T_WIDTH : natural := TIME_W
	);
	PORT (
		clk: in std_logic;
		stock : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
		vol : in std_logic_vector(STOCK_WIDTH-1 downto 0);
		t : in std_logic_vector(T_WIDTH-1 downto 0);
		u : in std_logic_vector(STOCK_WIDTH-1 downto 0);

		--output
		A : out std_logic_vector (STOCK_WIDTH-1 downto 0);
		B : out std_logic_vector (STOCK_WIDTH-1 downto 0);
		C : out std_logic_vector (STOCK_WIDTH-1 downto 0);
		constantReady : out std_logic;

		reset : in std_logic
	);
END ENTITY constant_generator;

ARCHITECTURE behavioral OF constant_generator IS

	SIGNAL vol_squared : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL half_vol_squared : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL u_minus_half_vv : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL u_minus_half_vol_sq_t : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL exp_u_m_h_vv_t : std_logic_vector (STOCK_WIDTH-1 downto 0);
	SIGNAL t_extended : std_logic_vector (STOCK_WIDTH-1 downto 0);
	SIGNAL sqrt_t : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);

	SIGNAL before_t_ext : std_logic_vector(STOCK_WIDTH/2-T_WIDTH-1 downto 0);
	SIGNAL after_t_ext : std_logic_vector(STOCK_WIDTH/2-1 downto  0);
	SIGNAL t_size8 : std_logic_vector(STOCK_WIDTH/2-1 downto 0);

	SIGNAL u_t,not_ut : std_logic_vector(STOCK_WIDTH-1 downto 0);
	SIGNAL minus_ut : std_logic_vector(STOCK_WIDTH-1 downto 0);

	SIGNAL negative: std_logic;
	SIGNAL to_exp_A : std_logic_vector(STOCK_WIDTH-1 downto 0);

	SIGNAL zeros : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);

	SIGNAL 	A_in,B_in,C_in : std_logic_vector (STOCK_WIDTH-1 downto 0);
	SIGNAL constantReady_in : std_logic;

	SIGNAL vol_squared_long, u_minus_half_vol_sq_t_long, A_in_long,B_in_long, u_t_long : std_logic_vector(STOCK_WIDTH*2-1 DOWNTO 0);
BEGIN

	zeros <= (others=>'0');

	--negative <= '0';
	before_t_ext <= (others=>'0');
	after_t_ext <= (others=>'0');
	t_extended <= before_t_ext & t & after_t_ext;
	t_size8 <= "0000"&t;


	--A = Stock * exp (u-0.5*vol*vol)t
--	vol_squared_map : fixedpoint_multiply PORT MAP (clk,vol,vol,vol_squared);
	vol_squared_long <= std_logic_vector(signed(vol)*signed(vol));
	vol_squared <= vol_squared_long(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);
	--divide by 2
	half_vol_squared_map : half_vol_squared <= vol_squared(STOCK_WIDTH-1) & vol_squared(STOCK_WIDTH-1 downto 1);

	--subtract from u
	subtract_from_u :process (u,half_vol_squared) is 
		variable u_variable : integer := 0;
		variable half_v_sq: integer;
		variable u_minus_hvsq: integer;		

		BEGIN
		u_variable := to_integer(unsigned(u));
		half_v_sq := to_integer(unsigned(half_vol_squared));
		--u - hvsq
		if u_variable > half_v_sq then 
			u_minus_hvsq := u_variable - half_v_sq;
			negative <= '0';
		else 
			u_minus_hvsq := half_v_sq - u_variable;
			negative <= '1';
		end if;
--		u_minus_hvsq := u_variable - half_v_sq;
		u_minus_half_vv <= std_logic_vector(to_unsigned(u_minus_hvsq,STOCK_WIDTH));
	end process subtract_from_u;

	--now multiply by t
		--extend t first
	u_minus_half_vol_sq_t_long <= std_logic_vector(signed(u_minus_half_vv) * signed(t_extended));
	u_minus_half_vol_sq_t <= u_minus_half_vol_sq_t_long(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);
--	u_minus_half_vol_sq_t_map : fixedpoint_multiply PORT MAP (clk,u_minus_half_vv,t_extended,u_minus_half_vol_sq_t);

	--now exp(that)
	to_exp_A <= negative & u_minus_half_vol_sq_t(STOCK_WIDTH-2 downto 0);

	exp_a_map : exp_fn PORT MAP (
		clk=>clk, 
		bitVector => to_exp_A, 
		outVector=>exp_u_m_h_vv_t
	);

	A_in_long <= std_logic_vector(signed(exp_u_m_h_vv_t) * signed(stock));
	A_in <= A_in_long(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);
--	A_final_map : fixedpoint_multiply PORT MAP (
--		clk=>clk,
--		data_in1 => exp_u_m_h_vv_t,
--		data_in2 => stock,
--		data_out => A
--		);


	--B = vol * sqrt(t)
	sqrt_t_map : sqrt_fn PORT MAP (
		clk => clk,
		bitVector => t_size8,
		outVector => sqrt_t
		);

	B_in_long <= std_logic_vector(signed(vol) * signed(sqrt_t));
	B_in <= B_in_long(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);
--	B_map : fixedpoint_multiply PORT MAP (
--		clk=>clk,
--		data_in1 => vol,
--		data_in2 => sqrt_t,
--		data_out => B
--		);
	
	--C = exp(-u*t)
	u_t_long <= std_logic_vector(signed(t_extended)*signed(u));
	u_t <= u_t_long(STOCK_WIDTH+STOCK_WIDTH/2-1 downto STOCK_WIDTH/2);
	minus_ut <= std_logic_vector(0 - signed(u_t));
--	u_t_map : fixedpoint_multiply PORT MAP (
--		clk =>clk,
--		data_in1 => t_extended,
--		data_in2 => u,
--		data_out => u_t
--		);

--	NOT_UT_MAP : for i in 0 to STOCK_WIDTH-1 generate
--	  not_ut(i) <= not u_t(i);
--	END GENERATE;	
	
--	minus_ut_map : fulladder_n GENERIC MAP (n=>STOCK_WIDTH)
--		PORT MAP (
--			cin => '1',
--			x => not_ut,
--			y => zeros,
--			z => minus_ut
--		);

--	minus_ut <= '1'&u_t(STOCK_WIDTH-2 downto 0);
	C_map : exp_fn PORT MAP (clk,minus_ut,C_in);

	--for now, just set is as 1?? not really sure what to do here
	constantReady_in <= '1';

	clocked_out : process (clk,reset) is 
	--variable A_store, B_store, C_store : std_logic_vector(STOCK_WIDTH-1 downto 0);
	begin 
		if reset='1' then 
			A <= zeros;
			B <= zeros;
			C <= zeros;
			constantReady <= '0';
		else
			if rising_edge(clk) then 
				A <= A_in;
				B <= B_in;
				C <= C_in;
				constantReady <= constantReady_in;
			end if;
		end if;
	end process;

end architecture behavioral;

