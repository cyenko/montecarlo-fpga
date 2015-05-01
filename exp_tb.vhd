library ieee;
use ieee.std_logic_1164.all;
use work.monte_carlo.all;

entity exp is 
 port( 
     --Inputs 
     clk : in std_logic; 
     bitVector : in std_logic_vector (15 downto 0); --16 bits
     
     --Outputs 
     outVector : out std_logic_vector (15 downto 0)
 ); 
end entity exp;

ARCHITECTURE structural OF exp_tb IS
    
	signal bitVector_tb : std_logic_vector(15 downt0 0);
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
        bitVector <= "0000000000000000";
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        bitVector <= "0000000000000001";
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;

    	--stop the START button to let it stop 
    	start_tb <= '0';
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
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        wait;
   END PROCESS;
  END ARCHITECTURE struct;
    