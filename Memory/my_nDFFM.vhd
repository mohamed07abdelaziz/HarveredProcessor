

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
            ram(0) <= x"000007FF";
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