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
    exp_map : exp 
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
        bitVector_tb <= "0001000000000101"; --2.5, PASS
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        bitVector_tb <= "0000100000100010"; -- 1.34, PASS
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        bitVector_tb <= "1000100000000101"; -- -1.5, PASS
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
    