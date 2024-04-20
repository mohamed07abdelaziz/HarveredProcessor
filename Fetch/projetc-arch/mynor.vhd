library IEEE;
use IEEE.std_logic_1164.all;

entity mynor is 
port  (
	A : in std_logic; 
	B:  in std_logic;
	C : out std_logic
);
end entity;

Architecture mynorDesign of mynor is


begin
  C <= A nor B;


end mynorDesign;
