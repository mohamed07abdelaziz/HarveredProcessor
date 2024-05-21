LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Reg_Filexx IS
	PORT (
		Clk, Rst : IN STD_LOGIC;
		RegWrite0, RegWrite1 : IN STD_LOGIC;
		Registeraddress1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Registeraddress2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Writeaddress1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Writeaddress2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Writedata1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Writedata2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Readdata1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Readdata2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ENTITY Reg_Filexx;

ARCHITECTURE RegfileP OF Reg_Filexx IS

	TYPE ram_type IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram : ram_type;

BEGIN
	PROCESS (clk, Rst) IS
	BEGIN
		IF Rst = '1' THEN
			ram <= (OTHERS => (OTHERS => '0'));
		ELSIF rising_edge(clk) THEN
			IF RegWrite0 = '1' THEN
				ram(to_integer(unsigned(Writeaddress1))) <= Writedata1;
			ELSE
				ram(to_integer(unsigned(Writeaddress1))) <= ram(to_integer(unsigned(Writeaddress1)));
			END IF;
			IF RegWrite1 = '1' THEN
				ram(to_integer(unsigned(Writeaddress2))) <= Writedata2;
			ELSE
				ram(to_integer(unsigned(Writeaddress2))) <= ram(to_integer(unsigned(Writeaddress2)));

			END IF;
		END IF;
	END PROCESS;
	Readdata1 <= ram(to_integer(unsigned(Registeraddress1)));
	Readdata2 <= ram(to_integer(unsigned(Registeraddress2)));
END RegfileP;