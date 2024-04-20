LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SPAdder IS
PORT (
        sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluSp : IN STD_LOGIC;
        spOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        cOut : OUT STD_LOGIC
    );
END ENTITY SPAdder;

ARCHITECTURE impOfSPAdder OF SPAdder IS
    COMPONENT my_nadder
    generic (n: integer := 4);
        PORT (
          a : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
          b : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            cIn : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            cOut : OUT STD_LOGIC
        );
    END COMPONENT;

    signal secondOperand : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
secondOperand<=x"00000002" when aluSp='0' else not x"00000002";
f0: my_nadder generic map(32) port map(sp, secondOperand ,aluSp,spOut,cOut);



END impOfSPAdder;