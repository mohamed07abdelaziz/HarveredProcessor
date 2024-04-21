LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY SignExtend IS
	PORT(

		Immediate: IN  std_logic_vector(15 DOWNTO 0);
		Immediateextended : OUT std_logic_vector(31 DOWNTO 0)
);
END ENTITY SignExtend;

ARCHITECTURE SignExtendP OF SignExtend IS
Signal Sign:std_logic_vector(15 DOWNTO 0);
	BEGIN
Sign<=x"FFFF" when Immediate(15)='1'
else x"0000";
		Immediateextended<=Sign & Immediate;
        END SignExtendP;

