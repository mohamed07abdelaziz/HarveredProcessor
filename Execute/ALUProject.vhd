--Includes

Library IEEE;
use ieee.std_logic_1164.all;
entity ALUxx is
generic (n: integer := 32);
port(
 Clk,Rst : IN std_logic;
 A,B: in std_logic_vector(n-1 downto 0);
Sel:in std_logic_vector(3 downto 0);
  F: out std_logic_vector(n-1 downto 0); -- we dont need to write semicolon as the end has } :)
-- Cout:out std_logic;
Cin:in std_logic;
--Carry Flag,Negative flag,Zero Flag ,Overflowflag
CCR:OUT std_logic_vector(3 downto 0);
Restoreflag:in std_logic ;
CCRx:IN std_logic_vector(3 downto 0)
);
end entity;
ARCHITECTURE ALUP OF ALUxx IS
Component Part_AALU Is
generic (n: integer := 32);
port(
Clk,Rst : IN std_logic;
 A,B: in std_logic_vector(n-1 downto 0);
Sel:in std_logic_vector(3 downto 0);
  F: out std_logic_vector(n-1 downto 0); -- we dont need to write semicolon as the end has } :)
-- Cout:out std_logic;
Cin:in std_logic;
--Carry Flag,Negative flag,Zero Flag ,Overflowflag
CCR:OUT std_logic_vector(3 downto 0)
);
End Component;
SIGNAL CCRA:std_logic_vector(3 downto 0);
 SIGNAL FA:std_logic_vector(n-1 downto 0);

Component Part_BALU Is
generic (n: integer := 32);
port(
Clk,Rst : IN std_logic;
 A,B: in std_logic_vector(n-1 downto 0);
Sel:in std_logic_vector(3 downto 0);
  F: out std_logic_vector(n-1 downto 0); -- we dont need to write semicolon as the end has } :)
-- Cout:out std_logic;
Cin:in std_logic;
--Carry Flag,Negative flag,Zero Flag ,Overflowflag
CCR:OUT std_logic_vector(3 downto 0));
End Component;
SIGNAL CCRB:std_logic_vector(3 downto 0);
 SIGNAL FB:std_logic_vector(n-1 downto 0);

Component Part_CALU is
generic (n: integer := 32);
port(
Clk,Rst : IN std_logic;
 A,B: in std_logic_vector(n-1 downto 0);
Sel:in std_logic_vector(3 downto 0);
  F: out std_logic_vector(n-1 downto 0); -- we dont need to write semicolon as the end has } :)
-- Cout:out std_logic;
Cin:in std_logic;
--Carry Flag,Negative flag,Zero Flag ,Overflowflag
CCR:OUT std_logic_vector(3 downto 0)
);
end Component;
SIGNAL CCRC:std_logic_vector(3 downto 0);
SIGNAL   FC:std_logic_vector(n-1 downto 0);

BEGIN
u0: Part_AALU generic map(n) PORT MAP (Clk,Rst, A,B,Sel,FA,'0',CCRA);
u1: Part_BALU  generic map(n) PORT MAP(Clk,Rst, A,B,Sel,FB,'0',CCRB);
u2: Part_CALU generic map(n) PORT MAP (Clk,Rst, A,B,Sel,FC,'0',CCRC);

F<= FA WHEN Sel(3 downto 2) = "00" 
ELSE FB  WHEN  Sel(3 downto 2) = "01"
 ELSE FC  WHEN Sel(3 downto 2) = "10"
 ELSE (Others =>'0');
CCR<=  CCRA WHEN Sel(3 downto 2) = "00" and  Restoreflag='0'
ELSE CCRB  WHEN  Sel(3 downto 2) = "01" and Restoreflag='0'
 ELSE CCRC WHEN Sel(3 downto 2) = "10" and Restoreflag='0'
 ELSE CCRX;
END ALUP;