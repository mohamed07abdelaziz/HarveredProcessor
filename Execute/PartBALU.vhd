
Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Part_BALU is
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
end entity;
ARCHITECTURE Part_BALUP OF Part_BALU IS
component  adder_16bit IS
generic (n: integer := 16);
PORT (a,b : IN  std_logic_vector(n-1 downto 0);
          cin : in std_logic;
		  s : out std_logic_vector(n-1 downto 0);
           cout : OUT std_logic );
END component;
Component my_nDFF IS
	GENERIC ( n : integer := 12);
	PORT(	Clk,Rst : IN std_logic;
		d : IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0);
                we: IN std_logic);
end Component;
Signal FT,FTx,Ax,Bx:std_logic_vector( n-1 downto 0);
Signal CoutT,Cinx,We :std_logic;
Signal CCRx:std_logic_vector( 3 downto 0);
--Signal ZF:std_logic_vector( 0 downto 0):="0";
--Signal ZFo:std_logic_vector( 0 downto 0);
begin
   f0:adder_16bit generic map(n) port map(Ax,Bx,Cinx,FT,CoutT);
   --D0:my_nDFF generic map(1) port map(Clk,Rst,ZF ,ZFo,We);
   --Selection=0100  2s comp A   Flags ,Sel=0101 Not A  flags,Sel=0110 A and B with  Flags
   --Selection=0111 A+1 with  flags
   --for A
   Ax<= Not A when Sel="0100"  
else A;
--For B
   Bx<=x"00000001" when Sel="0100" or Sel="0111"
else  B ;
Cinx<='0';
We<='1';
FTx<=Not A when Sel="0101"
else A and B when Sel="0110"
else FT;
F<=FTx;
CCRx(0)<=CoutT when  Sel="0111"
else '0' when Sel="0110" or Sel="0101" or Sel="0100"  
else '0';
CCRx(1)<=FTx(31) ;
CCRx(2)<='1' when FTx=x"00000000"
else '0';
CCRx(3)<='1'when   Sel="0111" and ((FTx(31)=not A(31) and A(31)='0') or (A(31)='0' and FTx(31)=A(31) and CCRx(0)='1'))
else '0' when (Sel="0100" or Sel="0101" or Sel="0110")
else '0';
CCR<=CCRx;
END Part_BALUP;

 



