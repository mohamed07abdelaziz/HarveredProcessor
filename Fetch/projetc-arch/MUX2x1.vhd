--includes
library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Mux2x1 is
  GENERIC ( n : integer := 32);
  port (A,B: in  std_logic_vector(n-1 downto 0);
 S : in  std_logic;
 F       : out std_logic_vector(n-1 downto 0));
end entity;

architecture Dataflow of Mux2x1 is
begin
  F <= A when S='0'
else B;
end architecture;
