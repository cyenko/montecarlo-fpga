library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use work.monte_carlo.all;


--takes as inputs the stock price, strike price, start, and t
--goes down to top_fpga
--and from out there to the LED. nothing else
 
entity project392 is 
	GENERIC ( STOCK_WIDTH : natural := STOCK_W;
			T_WIDTH : natural := TIME_W
	);
 	PORT( 
		--Inputs 
			 clk : in std_logic; 
			 start : in std_logic; 
			 stock_price : in std_logic_vector (STOCK_WIDTH -1 downto 0);  -- from 0 to 63
			 strike_price :  in std_logic_vector (STOCK_WIDTH -1 downto 0);  --from 0 to 63
			 t : in std_logic_vector(T_WIDTH-1 downto 0); --from 0 to 15 days'
			 vol : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
			 u : in std_logic_vector(STOCK_WIDTH-1 downto 0);
			 
			 --Outputs 
			 --premium_led is the width that will map entirely to the LEDs 
			 premium_led : out std_logic_vector (7*(STOCK_WIDTH/4) -1 downto 0);
			 --stock_out_led : out std_logic_vector (STOCK_WIDTH*2 - 1 downto 0)
			 premium_out : out std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
			 ready : out std_logic;
			 progress_led : out std_logic_vector(9 downto 0);
			 reset : in std_logic
	); 
end entity project392; 
 
architecture structural of project392 is 
	--Signals and components go here 

	SIGNAL premium : std_logic_vector (STOCK_WIDTH -1 downto 0); 
	SIGNAL stock_out : std_logic_vector (STOCK_WIDTH - 1 downto 0);
	SIGNAL zeros : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0); 
	SIGNAL not_start : std_logic;
	SIGNAL premium_led_in : std_logic_vector (7*(STOCK_WIDTH/4) -1 downto 0);
	signal READY_IN : std_logic;

	
	BEGIN 

	zeros <= (others=>'0');
	--used in synthesis. comment this line out for simulation
	not_start <= not start;
--	premium_out <= premium;
 		--Structural design goes here for the pricer

	T1: top_fpga PORT MAP(
		clk=>clk,
		start=>not_start,
		stock_price=>stock_price,
		strike_price=>strike_price,
		t=>t,
		u=>u,
		vol => vol,
		premium=>premium,
		ready=>ready_in,
		reset => reset,
		progress_led=>progress_led
	);

	--mapping results to the LEDs
	loop_led_premium: for i in 0 to ((STOCK_WIDTH/4)-1) GENERATE 
		begin
			led_map : leddcd PORT MAP (data_in=>premium((i+1)*4-1 downto (i)*4),segments_out=>premium_led_in((i+1)*7-1 downto (i)*7));
	end GENERATE;

	clocked_out : process(clk) is 
	begin 
		if rising_edge(clk) then 
			premium_led <= premium_led_in;
			premium_out <= premium;
			ready <= ready_in;
		end if;
	end process;
	


end architecture structural; 
----------------------------------------------------------------------------- 
