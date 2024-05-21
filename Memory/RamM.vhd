LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Ram IS

    PORT (
        clk : IN STD_LOGIC;
        writeEnable : IN STD_LOGIC;
        readEnable : IN STD_LOGIC;
        rest : IN STD_LOGIC;
        Address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        spControl : IN STD_LOGIC

    );

END ENTITY Ram;
ARCHITECTURE impOfRam OF Ram IS

    TYPE ramType IS ARRAY(2047 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ramType;

BEGIN
    PROCESS (clk, rest, writeEnable, readEnable, spControl)
        VARIABLE var1, var2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF rest = '1' THEN
            var1 := ram((0));
            var2 := ram((1));
            dataOut <= var2 & var1;
        ELSIF (to_integer(unsigned (Address)) < 2048) THEN
            IF (falling_edge(clk)) THEN
                IF writeEnable = '1' AND spControl = '0'   THEN
                    ram(to_integer(unsigned (Address))) <= dataIn(15 DOWNTO 0);
                    ram(to_integer(unsigned (Address)) + 1) <= dataIn(31 DOWNTO 16);
                ELSIF writeEnable = '1' AND spControl = '1'  THEN
                    ram(to_integer(unsigned (Address))) <= dataIn(15 DOWNTO 0);
                    ram(to_integer(unsigned (Address)) - 1) <= dataIn(31 DOWNTO 16);
                ELSIF readEnable = '1' AND spControl = '1'  THEN
                    var1 := ram(to_integer(unsigned (Address))+1);
                    var2 := ram(to_integer(unsigned (Address)) + 2);
                    dataOut <= var1 & var2;
                ELSIF readEnable = '1' AND spControl = '0' THEN
                    var1 := ram(to_integer(unsigned (Address)));
                    var2 := ram(to_integer(unsigned (Address)) - 1);
                    dataOut <= x"0000" & var1;
             
                END IF;
            END IF;
        END IF;
    END PROCESS;
END impOfRam;