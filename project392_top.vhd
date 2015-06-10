entity project392_top is 
	GENERIC ( STOCK_WIDTH : natural := STOCK_W;
			T_WIDTH : natural := TIME_W
	);
 	PORT( 
		--Inputs 
			 clk : in std_logic; 
			 start : in std_logic; 
		--	 stock_price : in std_logic_vector (STOCK_WIDTH -1 downto 0);  -- from 0 to 63
		--	 strike_price :  in std_logic_vector (STOCK_WIDTH -1 downto 0);  --from 0 to 63
		--	 t : in std_logic_vector(T_WIDTH-1 downto 0); --from 0 to 15 days'
		--	 vol : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
		--	 u : in std_logic_vector(STOCK_WIDTH-1 downto 0);
			 
			 --Outputs 
			 --premium_led is the width that will map entirely to the LEDs 
			 premium_led : out std_logic_vector (7*(STOCK_WIDTH/4) -1 downto 0);
			 --stock_out_led : out std_logic_vector (STOCK_WIDTH*2 - 1 downto 0)
			 premium_out : out std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
			 ready : out std_logic;
			 progress_led : out std_logic_vector(9 downto 0);
			 reset : in std_logic
	); 
end entity project392_top;

architecture behavioral of project392_top is 

	type rom is array (0 to (10)) of std_logic_vector(STOCK_WIDTH-1 downto 0);
	type rom_small is array (0 to 10) of std_logic_vector(T_WIDTH-1 downto 0);

0011011100000000 0011001000000000 0000000000100000 0000000001000000 0101
	CONSTANT stock_price : rom := (
		0 => x"3700",	1 =>x"3780" ,	2 =>x"378- ,
		3 => ,	4 => ,	5 => ,
		6 => ,	7 => ,	8 => ,
		9 => ,	10 => 
		);
	CONSTANT strike_price : rom := (
		0 => x"3200",	1 => ,	2 => ,
		3 => ,	4 => ,	5 => ,
		6 => ,	7 => ,	8 => ,
		9 => ,	10 => 
		);

	CONSTANT u : rom := (
		0 => x"0020",	1 => ,	2 => ,
		3 => ,	4 => ,	5 => ,
		6 => ,	7 => ,	8 => ,
		9 => ,	10 => 
		);
	

	CONSTANT vol : rom := (
		0 => x"0040",	1 => ,	2 => ,
		3 => ,	4 => ,	5 => ,
		6 => ,	7 => ,	8 => ,
		9 => ,	10 => 
		);


	CONSTANT t : rom_small := (
		0 => x"5",	1 => ,	2 => ,
		3 => ,	4 => ,	5 => ,
		6 => ,	7 => ,	8 => ,
		9 => ,	10 => 
		);

	begin




end architecture; 

