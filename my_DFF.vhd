LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_DFF IS
	PORT( 	d,clk,rst : IN std_logic;
			q : OUT std_logic;
we:IN std_logic);
END my_DFF;

ARCHITECTURE a_my_DFF OF my_DFF IS
BEGIN
	PROCESS(clk,rst,we)
	BEGIN
		IF(rst = '1') THEN
			q <= '0';
		ELSIF rising_edge(clk) THEN
                       IF we = '1' THEN		
			q <= d;
                END IF;
		END IF;
	END PROCESS;
END a_my_DFF;