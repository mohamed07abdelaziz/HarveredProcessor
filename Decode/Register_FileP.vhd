LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Reg_Filexx IS
	PORT(
		Clk,Rst : IN std_logic;
RegWrite0,RegWrite1 :IN std_logic;
Registeraddress1 : IN  std_logic_vector(2 DOWNTO 0);
		Registeraddress2 : IN  std_logic_vector(2 DOWNTO 0);
                Writeaddress1 : IN  std_logic_vector(2 DOWNTO 0);
                Writeaddress2 : IN  std_logic_vector(2 DOWNTO 0);
		Writedata1  : IN  std_logic_vector(31 DOWNTO 0);
		Writedata2 :  IN  std_logic_vector(31 DOWNTO 0);
		Readdata1 : OUT std_logic_vector(31 DOWNTO 0);
		Readdata2 : OUT std_logic_vector(31 DOWNTO 0)
);
END ENTITY Reg_Filexx;

ARCHITECTURE RegfileP OF Reg_Filexx IS

	TYPE ram_type IS ARRAY(0 TO 7) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(clk,Rst) IS
			BEGIN
                                IF Rst='1' THEN
                               	ram<=(others=>(others=>'0'));
				ELSIF rising_edge(clk) THEN  
					IF RegWrite0= '1' THEN
						ram(to_integer(unsigned(Writeaddress1))) <= Writedata1;
                                          else 
                                            ram(to_integer(unsigned(Writeaddress1))) <= ram(to_integer(unsigned(Writeaddress1)));
                                        end if;
                                    If RegWrite1='1' THEN
                                        ram(to_integer(unsigned(Writeaddress2))) <= Writedata2;
                                         else 
                                         ram(to_integer(unsigned(Writeaddress2)))<= ram(to_integer(unsigned(Writeaddress2)));
											
					END IF;
				END IF;
		END PROCESS;
		Readdata1<= ram(to_integer(unsigned(Registeraddress1)));
		Readdata2 <= ram(to_integer(unsigned(Registeraddress2)));
END RegfileP;

