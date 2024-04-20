-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;

-- ENTITY my_nDFF IS
-- 	GENERIC ( n : integer := 32);
-- 	PORT(	Clk,Rst : IN std_logic;
-- 		d : IN std_logic_vector(n-1 DOWNTO 0);
-- 		q : OUT std_logic_vector(n-1 DOWNTO 0);
-- 		enable : IN std_logic
-- );
-- END my_nDFF;

-- ARCHITECTURE b_my_nDFF OF my_nDFF IS
-- 	COMPONENT my_DFF IS
-- 	PORT( 	d,clk,rst : IN std_logic;
-- 			q : OUT std_logic;
-- 			enable : IN std_logic
-- );
-- 	END COMPONENT;
-- BEGIN
-- 	loop1: FOR i IN 0 TO n-1 GENERATE
-- 	fx: my_DFF PORT MAP(d(i),Clk,Rst,q(i),enable);
-- END GENERATE;

-- END b_my_nDFF;




LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY my_nDFFM IS

    PORT (
        clk : IN STD_LOGIC;
		rest : IN STD_LOGIC;
        writeEnable : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );

END ENTITY my_nDFFM;
ARCHITECTURE impOfmy_nDFF OF my_nDFFM IS

    TYPE ramType IS ARRAY(0 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ram : ramType;

BEGIN
    PROCESS (clk, rest)
    BEGIN
        IF rest = '1' THEN
            ram(0) <= x"00000800";
        ELse
            IF (rising_edge(clk)) then
                IF writeEnable = '1' THEN
					ram(0) <= d;
				
                END IF;
            END IF;
        END IF;

        END PROCESS;
		q <= ram(0);

    END impOfmy_nDFF;