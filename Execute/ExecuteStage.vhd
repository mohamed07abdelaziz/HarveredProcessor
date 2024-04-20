Library IEEE;
use ieee.std_logic_1164.all;
entity ExecuteStage is
generic (n: integer := 32);
port(
 Clk,Rst : IN std_logic;
 A,B,Immediate,OutputALU,OUTPUTMem: in std_logic_vector(n-1 downto 0);
AluSrc,AlusrcStore,Restoreflag:IN std_logic;
FU1,FU2:IN std_logic_vector(1 downto 0);
  F,ReadData1,ReadData2: out std_logic_vector(n-1 downto 0); -- we dont need to write semicolon as the end has } :)
-- Cout:out std_logic;
--Cin:in std_logic;
--Carry Flag,Negative flag,Zero Flag ,Overflowflag
Opcode : IN std_logic_vector(5 downto 0);
CCRx:IN std_logic_vector(3 downto 0);
    --WB Signals
    -- InPortWe: Out std_logic; -- OutPortWe: Out std_logic; -- RegWrite1: Out std_logic;
    -- SwapSignal:OUT std_logic;
    WBSignals:OUT std_logic_vector(3 downto 0);
    --Memory Signals
  --  BitfreeorProtectSignal:OUT std_logic;-- CondorUnCond:OUT std_logic;
    MemSignals:OUT std_logic_vector(1 downto 0);
CCR:OUT std_logic_vector(3 downto 0)
);
end entity;
ARCHITECTURE ExecuteStageP OF ExecuteStage  IS
Component ALUxx is
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
end Component;
Component ALUController IS
	PORT( 	Rst: IN std_logic;
    -- OPCode Second 4 bits for group first 2bits for instruction
Opcode : IN std_logic_vector(5 downto 0);
---- Controls Signals for special instructions
   -- Execute Signals
	SelectALU : OUT std_logic_vector(3 downto 0);
    --WB Signals
    -- InPortWe: Out std_logic; -- OutPortWe: Out std_logic; -- RegWrite1: Out std_logic;
    -- SwapSignal:OUT std_logic;
    WBSignals:OUT std_logic_vector(3 downto 0);
    --Memory Signals
  --  BitfreeorProtectSignal:OUT std_logic;-- CondorUnCond:OUT std_logic;
    MemSignals:OUT std_logic_vector(1 downto 0)
);
END Component;
Component  mux21 is
GENERIC (n: integer:= 3);
port(	
	in1,in2: in std_logic_vector(n - 1 downto 0);
	out1 : out std_logic_vector(n - 1 downto 0);
	sel : in std_logic
);
end Component ;
Component mux41 is
GENERIC (n: integer:= 3);
port(	
	in1,in2,in3,in4: in std_logic_vector(n - 1 downto 0);
	out1 : out std_logic_vector(n - 1 downto 0);
	sel : in std_logic_vector(1 downto 0)
);
end Component;
Signal OutputSig1,OutputSig2,OutputforALU1,OutputforALU2:Std_logic_vector(31 downto 0);
Signal SelectALU:Std_logic_vector(3 downto 0);
Begin
M0:mux21 generic map(n) PORT MAP ( A,Immediate,OutputSig1,AlusrcStore);
M1:mux21 generic map(n) PORT MAP (B,Immediate, OutputSig2,AluSrc);
M2:mux41 generic map(n) PORT MAP (OutputSig1,OutputALU, OUTPUTMem,OUTPUTMem,OutputforALU1,"00");--Forwarding unit//
M3:mux41 generic map(n) PORT MAP (OutputSig2,OutputALU, OUTPUTMem,OUTPUTMem ,OutputforALU2,"00");--Forwarding unit//
a0: ALUController  PORT MAP (Rst,Opcode,SelectALU,WBSignals,MemSignals);
a1: ALUxx  generic map(n) PORT MAP(Clk,Rst, OutputforALU1,OutputforALU2,SelectALU,F,'0',CCR,Restoreflag,CCRx);
ReadData1<=OutputforALU1;
ReadData2<=OutputforALU2;
end ExecuteStageP;
