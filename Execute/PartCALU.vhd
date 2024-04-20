
Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Part_CALU is
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
ARCHITECTURE Part_CALUP OF Part_CALU IS
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
Signal FT,FTx,Bx:std_logic_vector( n-1 downto 0);
Signal CoutT,Cinx,We :std_logic;
Signal CCRx:std_logic_vector( 3 downto 0);
begin
   f0:adder_16bit generic map(n) port map(A,Bx,Cinx,FT,CoutT);
   D0:my_nDFF generic map(4) port map(Clk,Rst,CCRx ,CCR,We);
   --Selection=1000  A+B flags   Flags ,Sel=1001 AorB  flags,Sel=1010 AxorB with  Flags
   --Selection=1011 A-1 with  flags
   --for A
--For B
   Bx<=Not x"00000001" when Sel="1011"
else  B ;

Cinx<='1' when Sel="1011"
else '0';
We<='1';
FTx<=A or B when Sel="1001"
else A xor B when Sel="1010"
else FT;
F<=FTx;
CCRx(0)<=CoutT when Sel="1000"  or Sel="1011"
else '0';
CCRx(1)<=FTx(31) ;
CCRx(2)<='1' when FTx=x"00000000"
else '0';
CCRx(3)<='1'when (Sel="1000"and FTx(31)=not A(31) and A(31)=B(31))  or(Sel="1011"and FTx(31)=not A(31) and A(31)='1')
else '0';
--CCR<=CCRx;
END Part_CALUP;

 


