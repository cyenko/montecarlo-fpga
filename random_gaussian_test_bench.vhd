LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
USE ieee.numeric_std.ALL;

ENTITY random_gaussian_test_bench IS
END random_gaussian_test_bench;

ARCHITECTURE behavior OF random_gaussian_test_bench IS

     FILE test_out_data: TEXT open WRITE_MODE is "output/gaussian.txt"; 
    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT random_gaussian
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         random : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;


   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

    --Outputs
   signal random : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: random_gaussian PORT MAP (
          clk => clk,
          reset => reset,
          random => random
        );

   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
    variable L1 : LINE;
    variable I : integer;
   begin        
        reset <= '1';

      wait for clk_period*20;

        reset <= '0';
        wait for clk_period*30;

        for I in 0 to 1000000 loop
            wait for clk_period*3;

            write(L1, to_integer(signed(random)));
            writeline(test_out_data, L1);
        end loop;
      wait;
   end process;

END;