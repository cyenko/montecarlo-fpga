library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_textio.all; 
use STD.textio.all; 
use WORK.monte_carlo.all; 
use IEEE.numeric_std.all;

entity project_tb is 

end entity project_tb;

architecture test of project_tb is 

	SIGNAL done : std_logic := '0';
	signal start_tb : std_logic;
    signal stock_price_tb,vol_tb,premium_z : std_logic_vector(16-1 DOWNTO 0);
    signal strike_price_tb : std_logic_vector(16-1 DOWNTO 0);
    signal t_tb : std_logic_vector(3 downto 0);
    signal clk_tb : std_logic :='0';
    signal reset_tb : std_logic :='0';
    signal u_tb : std_logic_vector(16-1 downto 0);
    signal ready_z : std_logic :='0';
    signal leds : std_logic_vector(7*(16/4)-1 downto 0);

    BEGIN

    project392_map : project392 
    	port map (
    	    clk=>clk_tb,
    	    start=>start_tb,
    	    stock_price=>stock_price_tb,
    	    strike_price=>strike_price_tb,
    		vol => vol_tb,
    		u => u_tb,
        	t=>t_tb,
        	premium_led => leds,
        	--premium_out => premium_z,
        	ready => ready_z,
        	reset => reset_tb
        );

   
    clk_tb <= NOT clk_tb AFTER 10 ns;
    
    read_file : process 
    	file my_input : TEXT open READ_MODE is "project_in_binary.txt";
   		file my_output: TEXT open WRITE_MODE is "project_out.txt";

    	variable my_line : LINE;
    	variable my_int : integer;
    	variable my_char : character;
    	variable temp_in1 : integer;
    	variable temp_in2 : integer;

    	variable out_line : LINE;


    	variable stock_in, strike_in, u_in, vol_in : std_logic_vector(16-1 downto 0);
    	variable t_in : std_logic_vector(3 downto 0);
    	BEGIN

    		wait for 150 ns;
    		start_tb <= '0';
    		while not endfile(my_input) loop 
    			readline(my_input,my_line);
    			--now get the variables
				read(my_line,stock_in);
				read(my_line,strike_in);
				read(my_line,u_in);
				read(my_line,vol_in);
				read(my_line,t_in);
				--not put it into the actual signals
				stock_price_tb <= stock_in;
				strike_price_tb <= strike_in;
				vol_tb <= vol_in;
				u_tb <= u_in;
				t_tb <= t_in;
				start_tb <= '1';
				wait for 20 ns;
				start_tb <= '0';
				wait for 20 ns;
				start_tb <= '1';
				wait for 1 ns;
				--and wait until i'm done
				wait until ready_z='1';
				write(out_line,premium_z);
				writeline(my_output,out_line);
			end loop;
			file_close(my_output);
			wait;
	end process read_file;


end architecture test;



















