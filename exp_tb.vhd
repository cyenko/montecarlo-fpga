library ieee;
use ieee.std_logic_1164.all;
use work.monte_carlo.all;

entity exp_tb is 
 port( 
     --Outputs 
     outVector_tb : out std_logic_vector (15 downto 0)
 ); 
end entity exp_tb;

ARCHITECTURE structural OF exp_tb IS
    
	signal bitVector_tb : std_logic_vector(15 downto 0);
	signal clk_tb : std_logic;


BEGIN
    exp_map : exp_fn
    port map (
		clk=>clk_tb,
		bitVector=>bitVector_tb,
        outVector=>outVector_tb
	);

    
    test_proc : PROCESS
    BEGIN
    	wait for 5 ns;
    	clk_tb <= not '0';
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
        --x=4.01953125, e^x=55.675
        bitVector_tb <= "0000010000000101"; --PASS
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        --x=1.75,e^x=5.754602676
        bitVector_tb <= "0000000111000000"; --PASS
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        --x=2.78125,e^x=16.13918232
        bitVector_tb <= "0000001011001000"; --PASS
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        wait;
   END PROCESS;
  END ARCHITECTURE structural;
    