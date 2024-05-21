LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY spAlu IS
    PORT (
        aluSp :  IN STD_LOGIC;
        clk, reset : in std_logic;
        spSrc : in STD_LOGIC;
        SPOut : out STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END spAlu;
ARCHITECTURE impOfspAlu OF spAlu IS

    COMPONENT SPAdder
        PORT (
            sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            aluSp : IN STD_LOGIC;
            spOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            cOut : OUT STD_LOGIC
);
    END COMPONENT;

    COMPONENT my_nDFFM is

        PORT (
            clk : IN STD_LOGIC;
            rest : IN STD_LOGIC;
            writeEnable : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    signal spOutSig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal cOut : STD_LOGIC;
    signal spSig : STD_LOGIC_VECTOR(31 DOWNTO 0):=x"000007FF";
BEGIN
    
    spAdder1 : SPAdder PORT MAP (spSig, aluSp, spOutSig, cOut);

    dff1 : my_nDFFM PORT MAP (clk, reset, spSrc,spOutSig, spSig );
   
     SPOut<=spSig;
   

END impOfspAlu;