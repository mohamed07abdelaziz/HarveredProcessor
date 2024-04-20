library IEEE;
use IEEE.std_logic_1164.all;

entity myor is 
port  (
	A : in std_logic; 
	B:  in std_logic;
	C : out std_logic
);
end entity;

Architecture myorDesign of myor is


begin
	C <= A or B;


end myorDesign;
