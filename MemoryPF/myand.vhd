library IEEE;
use IEEE.std_logic_1164.all;

entity myand is 
port  (
	A : in std_logic; 
	B:  in std_logic;
	C : out std_logic
);
end entity;

Architecture mynorDesign of myand is


begin
  C <= A and B;


end mynorDesign;
