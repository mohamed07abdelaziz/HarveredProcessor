LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY adder_16bit IS
generic (n: integer := 32);
	PORT (a,b : IN  std_logic_vector(n-1 downto 0);
          cin : in std_logic;
		  s : out std_logic_vector(n-1 downto 0);
           cout : OUT std_logic );
END adder_16bit;

ARCHITECTURE my_Xadder OF adder_16bit IS
component  my_nadder IS
generic (n: integer := 4);
PORT (a,b : IN  std_logic_vector(n-1 downto 0);
      cin : in std_logic;
      s : out std_logic_vector(n-1 downto 0);
       cout : OUT std_logic );
end component;
component select_adder is
 generic (n: integer := 4);
	PORT 
(a,b : IN  std_logic_vector(n-1 downto 0);
          cin : in std_logic;
		  s : out std_logic_vector(n-1 downto 0);
           cout : OUT std_logic );
end component;
  signal temp : std_logic_vector( n/4-1 downto 0);
	BEGIN
     f0:my_nadder  generic map(4) port map(a(3 downto 0),b(3 downto 0),cin,s(3 downto 0),temp(0));
           loop1: for i in 0 to n/4-2 generate  
                   fx:select_adder  generic map(4) port map(a(4+4*(i+1)-1 downto 4+(4*i)),b(4+4*(i+1)-1 downto 4+(4*i)),temp(i),s(4+4*(i+1)-1 downto 4+(4*i)),temp(i+1));
                  end generate;
 
     cout<=temp(n/4-1);
        END my_Xadder;
