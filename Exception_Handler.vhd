LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Except_Handler IS
	PORT( 	clk,rst,Overflowflag,Protectedflag,expsp : IN std_logic;
                  PCE,PCM:IN std_logic_vector(31 downto 0);
			PCout : OUT std_logic_vector(31 downto 0);
                        Excepflag:out std_logic;        
                         outexception:out std_logic_vector(1 downto 0)  
 );
END Except_Handler;

ARCHITECTURE Except_HandlerP OF Except_Handler IS
Component my_nDFF IS
	GENERIC ( n : integer := 12);
	PORT(	Clk,Rst : IN std_logic;
		d : IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0);
                we: IN std_logic);
END Component;
Signal flagsexcep:std_logic_vector(1 downto 0);
BEGIN
 Reg:my_nDFF generic map(2)port map(clk,rst,flagsexcep, outexception,'1');
 flagsexcep<="01" when Overflowflag='1' and Protectedflag='0'
else  "10" when Overflowflag='0' and (Protectedflag or expsp)='1'
else   "00"when Overflowflag='0' and (Protectedflag or expsp)='0'
else "10";
Excepflag<='1' when Overflowflag='1' or (Protectedflag or expsp)='1'
else '0';
PCout<=PCE when Overflowflag='1' and (Protectedflag or expsp)='0'
else PCM  when Overflowflag='0' and (Protectedflag or expsp)='1'
else PCM;
END Except_HandlerP;
