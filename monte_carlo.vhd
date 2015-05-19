----------------------------------------------------------------------------- 
library IEEE; 
 
use IEEE.std_logic_1164.all; 
--Additional standard or custom libraries go here 
 
package monte_carlo is 
 
	constant STOCK_W: natural := 16;
	constant N_NUMBER : natural := 1024*1024;
	constant N_PAR : natural := 8;
	constant log2_N_NUMBER : natural := 20; --equal to log2(N_NUMBER)

	COMPONENT project392 is 
		GENERIC ( STOCK_WIDTH : natural := STOCK_W);
	 	port( 
			--Inputs 
				 clk : in std_logic; 
				 start : in std_logic; 
				 stock_price : in std_logic_vector (STOCK_WIDTH -1 downto 0);  -- from 0 to 63
				 strike_price :  in std_logic_vector (STOCK_WIDTH -1 downto 0);  --from 0 to 63
				 t : in std_logic_vector(3 downto 0); --from 0 to 15 days
	 			 u : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0); -- rate-free interest rate'
	 			 vol : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
				 
				 --Outputs 
				 --premium_led is the width that will map entirely to the LEDs 
				 premium_led : out std_logic_vector (7*(STOCK_WIDTH/4) -1 downto 0);
				 --stock_out_led : out std_logic_vector (STOCK_WIDTH*2 - 1 downto 0)
				 ready : out std_logic;
				 progress_led : out std_logic_vector(9 downto 0)

		); 
	end COMPONENT project392; 

	COMPONENT top_fpga is
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
			 stock_price : in std_logic_vector (STOCK_WIDTH -1 downto 0);  -- from 0 to 63
			 strike_price :  in std_logic_vector (STOCK_WIDTH -1 downto 0);  --from 0 to 63
			 t : in std_logic_vector(3 downto 0); --from 0 to 15 days
			 u : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0); -- rate-free interest rate

			 
			 --Outputs 
			 premium : out std_logic_vector (STOCK_WIDTH -1 downto 0); 
			 stock_out : out std_logic_vector (STOCK_WIDTH - 1 downto 0);
			 ready : out std_logic;
			 progress_led : out std_logic_vector(9 downto 0)

		 ); 
	end component top_fpga;

	component constant_generator is
		GENERIC (
 			STOCK_WIDTH : natural := STOCK_W
 		);
		port(
			clk: in std_logic;
			stock : in std_logic_vector(STOCK_WIDTH-1 DOWNTO 0);
			vol : in std_logic_vector(STOCK_WIDTH-1 downto 0);
			t : in std_logic_vector(3 downto 0);
			u : in std_logic_vector(STOCK_WIDTH-1 downto 0);

			--output
			A : out std_logic_vector (STOCK_WIDTH-1 downto 0);
			B : out std_logic_vector (STOCK_WIDTH-1 downto 0);
			C : out std_logic_vector (STOCK_WIDTH-1 downto 0);
			constantReady : out std_logic
		);
	END component constant_generator;

	component random_fn is
	GENERIC (
 	STOCK_WIDTH : natural := STOCK_W
 );
		port(
			clk : in std_logic;
			data_in : in std_logic_vector(STOCK_WIDTH-1 downto 0);
			data_out : out std_logic_vector(STOCK_WIDTH-1 downto 0)
		);
	end component random_fn;

	COMPONENT leddcd is
    port(
            data_in         :in std_logic_vector (3 downto 0);
            segments_out    :out std_logic_vector (6 downto 0)
        );
	end COMPONENT leddcd;

	component exp_fn is 
	 port( 
		 --Inputs 
		 clk : in std_logic; 
		 bitVector : in std_logic_vector (15 downto 0); --16 bits
		 
		 --Outputs 
		 outVector : out std_logic_vector (15 downto 0)
	 ); 
	end component exp_fn;



 --Other constants, types, subroutines, components go here 
 
end package monte_carlo; 
 
package body monte_carlo is 
 
--Subroutine declarations go here 
-- you will not have any need for it now, this package is only for defining -
-- some useful constants 

function log2(i: natural) return integer is
	variable temp: integer := i;
	variable ret_val: integer:= 0;
	begin
		while temp > 1 loop
			ret_val := ret_val+1;
			temp := temp/2;
		end loop;
		return ret_val;
end function log2;

 
end package body monte_carlo; 
--------------------------------------------------