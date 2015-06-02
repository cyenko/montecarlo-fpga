library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use work.monte_carlo.all;

--inputs: clock, start, stock price, strike, t
--output: premium, stock price out, ready
--	for now, do only premium and ready

entity top_fpga is 
 GENERIC (
 	STOCK_WIDTH : natural := STOCK_W;
	NUM_ITERATIONS : natural := N_NUMBER;
	NUM_PARALLEL : natural := N_PAR;
	log_iterations : integer := log2_N_NUMBER;
	T_WIDTH : natural := TIME_W

 );
 port( 
	 --Inputs 
	 clk : in std_logic; 
	 start : in std_logic; 
	 stock_price : in std_logic_vector (STOCK_WIDTH -1 downto 0);  -- from 0 to 63 or 31
	 strike_price :  in std_logic_vector (STOCK_WIDTH -1 downto 0);  --from 0 to 63 or 31
	 t : in std_logic_vector(T_WIDTH-1 downto 0); --from 0 to 15 days;
	 u : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0); -- rate-free interest rate
	 vol : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
	 
	 --Outputs 
	 premium : out std_logic_vector (STOCK_WIDTH -1 downto 0);  --32 bits long
	 stock_out : out std_logic_vector (STOCK_WIDTH - 1 downto 0); --32 bits long
	 ready : out std_logic;
	 progress_led : out std_logic_vector(9 downto 0); --to display the progress of the operation

	 reset : in std_logic

); 
end entity top_fpga;

architecture behavioral of top_fpga is 

SIGNAL stock : std_logic_vector(STOCK_WIDTH - 1 downto 0);
SIGNAL strike : std_logic_vector(STOCK_WIDTH -1 downto 0);
SIGNAL n : std_logic_vector(STOCK_WIDTH*NUM_PARALLEL-1 downto 0);

SIGNAL final_price : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
SIGNAL sum_total_vector : std_logic_vector(STOCK_WIDTH*3 - 1 DOWNTO 0);
SIGNAL shift_final_price: std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
SIGNAL A,B,C : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);

SIGNAL pricers_ready : std_logic_vector(NUM_PARALLEL-1 downto 0);
SIGNAL lots_of_ones : std_logic_vector(NUM_PARALLEL-1 downto 0);

SIGNAL constants_ready : std_logic;
SIGNAL ready_out : std_logic;
SIGNAL pricer_ready : std_logic;




begin

	lots_of_ones <= (others=>'1');
	--get the stock price in a wire
	stock <= stock_price;

	--wire in constants
	constants_map : constant_generator PORT MAP (
		clk=>clk, 
		stock=>stock,
		vol => vol,
		t => t,
		u => u,
		A => A,
		B => B,
		C => C,
		constantReady => constants_ready,
		reset => '0'
		);


	--perform operation with the same stock but out to many variables
	loop_k : for i in 0 to (NUM_PARALLEL-1) GENERATE 
		pricer_map : pricer PORT MAP (
			clk=>clk,
			Strike => strike_price ,
			A => A,
			B => B,
			C => C,
			constants_ready => constants_ready,
			data_out => n(STOCK_WIDTH*(i+1)-1 downto STOCK_WIDTH*(i)),
			pricer_ready => pricers_ready(i),
			reset => reset
		);
	end GENERATE;

	--make sure that it's all 1111111
	pricer_ready <= '1' WHEN pricers_ready=lots_of_ones else '0';



	--now the problem with adding:
		--only add if the pricers are ready!


	--did it in parallel. now we need to have an adder of all stuff
	--ADD IN PARALLEL
	adding_process: process (start,clk) is 
		variable sum_total : integer := 0;
		variable readyn,ready_next : integer := 0;
		variable temp_sum : integer := 0;
		variable k: integer := NUM_PARALLEL;
		variable started : std_logic:= '0';
		variable Num : integer := NUM_ITERATIONS;
		variable Price : integer :=0;
		variable Progress: integer := 0;
		variable debug: integer := 0;
		variable debug_2 : integer := 0;
		BEGIN  
			if reset='1' then
				Progress:= 0;
				started := '1';
				temp_sum := 0;
				readyn := 0;
				sum_total := 0;
				Price := 0;
			else
				if rising_edge(clk) then
					if (start='1') then 
						Progress:= 0;
						started := '1';
						temp_sum := 0;
						readyn := 0;
						sum_total := 0;
						Price := 0;
						debug := 1;
					else
						started := started;
						Price := Price;
						temp_sum := temp_sum;
						readyn := ready_next;
						sum_total := sum_total;
						Progress := Progress /(1024);
						debug := 0;
					end if;
					
					if started='1' then 
						--only do stuff if the pricers are ready
						if pricer_ready='1' then 
							debug_2 := 3;
							temp_sum := 0;
							for i in 0 to k-1 loop 
								--add it all up in a temporary variable
								temp_sum := temp_sum + to_integer(signed(n(STOCK_WIDTH*(i+1)-1 DOWNTO STOCK_WIDTH*(i))));
							end loop;
							--and put it out as the total integer
							sum_total := sum_total + (temp_sum); 
							readyn := readyn + k;
							if readyn=Num then
								--debug_2 := 4;
								ready_out <= '1';
								ready_next := 0;
								started := '0';
								Price := sum_total / Num;
								--and stop this process
								started := '0';
							else 
								Price := 00;

								ready_out <= '0';
								ready_next := readyn;
							end if;
						else 
							debug_2 := 5;
							temp_sum := temp_sum;
							sum_total := sum_total;
							ready_next := ready_next;
							readyn := readyn;
						end if;
					else 
						temp_sum := temp_sum;
						sum_total := sum_total;
						ready_next := ready_next;
						readyn := readyn;
					end if;
				end if;
			end if;
		sum_total_vector <= std_logic_vector(to_signed(sum_total,STOCK_WIDTH*3));
		final_price  <= std_logic_vector(to_signed(Price,STOCK_WIDTH));
		progress_led <= std_logic_vector(to_signed(Progress,10));
	end process adding_process;

	--ok. solution is done
	--now i need to say 'finish' and signal 'next'
	--next signal is 'ready' and finished is also 'ready'

	--shift the final price by the amount that we need (if it's now a 43 bit vector we shift it by log2(256) )
	shift_final_price <= sum_total_vector(STOCK_WIDTH+log_iterations-1 DOWNTO log_iterations);
	premium <= shift_final_price;
	--premium <= final_price;
	stock_out <= stock;
	ready <= ready_out;

	

end architecture;

