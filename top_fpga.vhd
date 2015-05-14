----------------------------------------------------------------------------- 
library IEEE; 
 
use IEEE.std_logic_1164.all; 
use WORK.monte_carlo.all; 
--Additional standard or custom libraries go here 
use IEEE.numeric_std.all;

--inputs: clock, start, stock price, strike, t
--output: premium, stock price out, ready
--	for now, do only premium and ready

entity top_fpga is 
 GENERIC (
 	STOCK_WIDTH : natural := STOCK_W;
	NUM_ITERATIONS : natural := N_NUMBER;
	NUM_PARALLEL : natural := N_PAR;
	log_iterations : integer := log2_N_NUMBER
 );
 port( 
	 --Inputs 
	 clk : in std_logic; 
	 start : in std_logic; 
	 stock_price : in std_logic_vector (STOCK_WIDTH -1 downto 0);  -- from 0 to 63 or 31
	 strike_price :  in std_logic_vector (STOCK_WIDTH -1 downto 0);  --from 0 to 63 or 31
	 t : in std_logic_vector(3 downto 0); --from 0 to 15 days
	 
	 --Outputs 
	 premium : out std_logic_vector (STOCK_WIDTH -1 downto 0);  --32 bits long
	 stock_out : out std_logic_vector (STOCK_WIDTH - 1 downto 0); --32 bits long
	 ready : out std_logic;
	 progress_led : out std_logic_vector(9 downto 0) --to display the progress of the operation
 ); 
end entity top_fpga;

architecture behavioral of top_fpga is 

SIGNAL stock : std_logic_vector(STOCK_WIDTH - 1 downto 0);
SIGNAL strike : std_logic_vector(STOCK_WIDTH -1 downto 0);
SIGNAL n : std_logic_vector(STOCK_WIDTH*NUM_PARALLEL-1 downto 0);
SIGNAL ready_out : std_logic;
SIGNAL final_price : std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
SIGNAL sum_total_vector : std_logic_vector(STOCK_WIDTH*3 - 1 DOWNTO 0);
SIGNAL shift_final_price: std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);

begin

	--get the stock price in a wire
	stock <= stock_price;

	--perform operation with the same stock but out to many variables
	loop_k : for i in 0 to (NUM_PARALLEL-1) GENERATE 
		fn_map : random_fn PORT MAP (clk=>clk,data_in=>stock,data_out=>n(STOCK_WIDTH*(i+1)-1 downto STOCK_WIDTH*(i)));
	end GENERATE;

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
		BEGIN  
			
			if rising_edge(clk) then
				if (start='1') then 
					Progress:= 0;
					started := '1';
					temp_sum := 0;
					readyn := 0;
					sum_total := 0;
					Price := 0;
				else
					started := started;
					Price := Price;
					temp_sum := temp_sum;
					readyn := ready_next;
					sum_total := sum_total;
					Progress := Progress /(1024);
					
				end if;
				if started='1' then 
					temp_sum := 0;
					for i in 0 to k-1 loop 
						--add it all up in a temporary variable
						temp_sum := temp_sum + to_integer(signed(n(STOCK_WIDTH*(i+1)-1 DOWNTO STOCK_WIDTH*(i))));
					end loop;
					--and put it out as the total integer
					sum_total := sum_total + (temp_sum); 
					readyn := readyn + k;
					if readyn=Num then
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
					temp_sum := temp_sum;
					sum_total := sum_total;
					ready_next := ready_next;
					readyn := readyn;
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

	--implement some kind of big adder that will take all of these inputs and add them up?
	--implement a 4:1, 8:1, 16:1, 32:1, 64:1 adders (in increasing order so we can use the previous ones)

	--process to increase the counter by however many adders we have

	--on the clock tick, save the data in a flip flop 
		--or in a register if necesary?
		--no idea here

	--and reset the counter (that's also a flip flop)

	--then implement division

	--and output the final stock price from there along with a 'ready' signal

end architecture;

