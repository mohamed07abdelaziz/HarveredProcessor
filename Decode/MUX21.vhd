library ieee;
use ieee.std_logic_1164.all;

entity mux21 is
GENERIC (n: integer:= 3);
port(	
	in1,in2: in std_logic_vector(n - 1 downto 0);
	out1 : out std_logic_vector(n - 1 downto 0);
	sel : in std_logic
);
end mux21;

architecture mux21P of mux21 is
begin
	out1<= in1 when sel='0' else in2;
end mux21P;
