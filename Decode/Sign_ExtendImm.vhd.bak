LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY SignExtend IS
	PORT(

		Immediate: IN  std_logic_vector(3 DOWNTO 0);
		Immediateextended : OUT std_logic_vector(31 DOWNTO 0)
);
END ENTITY SignExtend;

ARCHITECTURE SignExtendP OF SignExtend IS
Signal Sign:std_logic_vector(27 DOWNTO 0);
	BEGIN
Sign<="1111111111111111111111111111" when Immediate(3)='1'
else "0000000000000000000000000000";
		Immediateextended<=Sign & Immediate;
        END SignExtendP;

