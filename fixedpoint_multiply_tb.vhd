library ieee;
use ieee.std_logic_1164.all;
use work.monte_carlo.all;

entity fixedpoint_multiply_tb is 
 port( 
     --Outputs 
     outVector_tb : out std_logic_vector (15 downto 0)
 ); 
end entity fixedpoint_multiply_tb;

ARCHITECTURE structural OF fixedpoint_multiply_tb IS
    
	signal in2_tb : std_logic_vector(15 downto 0);
    signal in1_tb : std_logic_vector(15 downto 0);
	signal clk_tb : std_logic;


BEGIN
    fixedpoint_multiply_map : fixedpoint_multiply
    port map (
        clk => clk_tb,
		data_in1=>in1_tb,
		data_in2=>in2_tb,
        data_out=>outVector_tb
	);

    
    test_proc : PROCESS
    BEGIN
    	wait for 5 ns;
    	clk_tb <= not '0';
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
        -- 4*4 = 16 (0 0010000 0000 0000)
        in1_tb <= "0000010000000000"; 
        in2_tb <= "0000010000000000";
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        -- 4.5*4 = 18 (0 0010010 0000 0000)
        in1_tb <= "0000010010000000"; 
        in2_tb <= "0000010000000000";
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
    	wait for 5 ns;
    	clk_tb <= not clk_tb;
        -- -4.5*4 = -18 (1 0010010 0000 0000)
        in1_tb <= "1000010010000000"; 
        in2_tb <= "0000010000000000";
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
    