
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DecodeStage IS
	PORT(
		--Controller
 InputSignals : IN std_logic_vector(6 DOWNTO 0);
 OpCode : IN std_logic_vector(5 DOWNTO 0);
 MemSignals : OUT std_logic_vector(13 DOWNTO 0);
 ExecSignals : OUT std_logic_vector(5 DOWNTO 0);
 WBSignals : OUT std_logic_vector(1 DOWNTO 0);
FlushSignals:OUT std_Logic_vector(3 DOWNTO 0);
    --RegisterFile
	Clk,Rst : IN std_logic;
	RegWrite0,RegWrite1 :IN std_logic;
	Registeraddress1 : IN  std_logic_vector(2 DOWNTO 0);
			Registeraddress2 : IN  std_logic_vector(2 DOWNTO 0);
			Writeaddress1 : IN  std_logic_vector(2 DOWNTO 0);
			Writeaddress2 : IN  std_logic_vector(2 DOWNTO 0);
			Writedata1  : IN  std_logic_vector(31 DOWNTO 0);
			Writedata2 :  IN  std_logic_vector(31 DOWNTO 0);
			Readdata1 : OUT std_logic_vector(31 DOWNTO 0);
			Readdata2 : OUT std_logic_vector(31 DOWNTO 0);
			--Mux21 for Writeaddress1 && --Mux21 for Writeaddress2
			--Writeaddress1 : IN  std_logic_vector(2 DOWNTO 0);
			--Writeaddress2 : IN  std_logic_vector(2 DOWNTO 0);
			SwapSignal:IN  std_logic;
			--Outaddress1: OUT std_logic_vector(2 DOWNTO 0);
			--Outaddress2: OUT std_logic_vector(2 DOWNTO 0);
           
			--Mux21 for WriteReg1
			InputPortWE: IN  std_logic;
			--Writedata1  : IN  std_logic_vector(31 DOWNTO 0);
			InputPortdata:IN std_logic_vector(31 DOWNTO 0);
			--Outdata1:OUT std_logic_vector(31 DOWNTO 0);

		--SignExtend for Immediate
		Immediate: IN  std_logic_vector(15 DOWNTO 0);
		Immediateextended : OUT std_logic_vector(31 DOWNTO 0); 
                 SelecALU:OUT std_logic_vector(3 DOWNTO 0) ;
                  WBSignals2:OUT std_logic_vector(3 downto 0);

                    MemSignals2:OUT std_logic_vector(1 downto 0)
);
END DecodeStage ;

ARCHITECTURE DecodeStageP OF DecodeStage IS
Component ControllerP IS
	PORT ( 	
        --Input Signals
    -- Rst: IN std_logic;0  -- Int: IN std_logic;1-- Overflow:In std_logic;2-- ProtectedSig:In std_logic;3
    -- InterruptforPCandFx:IN std_logic;4 -RTISigx:IN std_logic;5
    InputSignals:IN std_logic_Vector(6 downto 0);--Memory Signals
    -- MemReadPF:OUT std_logic;0-- MemWritePF:OUT std_logic;1 -- SPControl:OUT std_Logic;2
    -- MemRead:OUT std_Logic; --For Data Memory3-- MemWrite:OUT std_Logic; --FOr Data Memory4-- Call_Signal:OUT std_Logic;5
    -- SPsrc:OUT std_Logic;6 -- FlagSignal:OUT std_Logic;7-- LDIMM:OUT std_Logic;8
    -- ReturnEnable:OUT std_Logic;9-- Branch:OUT std_Logic;10-- SPSel:OUT std_Logic;11 NeworOldPC<='0'13
    MemorySignals:OUT std_logic_Vector(13 downto 0);
    --Execute Signals
-- ALU_Src:OUT std_logic;0-- RegDst:OUT std_logic;1-- InterruptforPCandF:OUT std_logic;2
    -- AluSrcForStore:OUT std_logic;3-- RestoreFlags:OUT std_logic;4 -RTISig:OUT std_logic;5 
    ExecuteSignals:OUT std_logic_Vector(5 downto 0);
    --WriteBack Signals
--    MemtoReg:OUT std_logic;0 --RegWrite:OUT std_logic_vector(1 downto 0); 1,2
     WBSignals:OUT std_logic_Vector(1 downto 0);
   --Flushing Signal--    F_Flush:OUT std_logic;0--    D_Flush:OUT std_logic;1--    E_Flush:OUT std_logic;2--   
   -- MF_Flush:OUT std_logic;3
     FlushSignals:OUT std_logic_Vector(3 downto 0);
   --OPCode 
   Opcode : IN std_logic_vector(3 downto 0)
);
END Component;
Component Reg_Filexx IS
	PORT(
		Clk,Rst : IN std_logic;
RegWrite0,RegWrite1 :IN std_logic;
Registeraddress1 : IN  std_logic_vector(2 DOWNTO 0);
		Registeraddress2 : IN  std_logic_vector(2 DOWNTO 0);
                Writeaddress1 : IN  std_logic_vector(2 DOWNTO 0);
                Writeaddress2 : IN  std_logic_vector(2 DOWNTO 0);
		Writedata1  : IN  std_logic_vector(31 DOWNTO 0);
		Writedata2 :  IN  std_logic_vector(31 DOWNTO 0);
		Readdata1 : OUT std_logic_vector(31 DOWNTO 0);
		Readdata2 : OUT std_logic_vector(31 DOWNTO 0)
);
END Component;
Component mux21 is
	GENERIC (n: integer:= 3);
	port(	
		in1,in2: in std_logic_vector(n - 1 downto 0);
		out1 : out std_logic_vector(n - 1 downto 0);
		sel : in std_logic
	);
END  Component;
Component SignExtend IS
	PORT(

		Immediate: IN  std_logic_vector(15 DOWNTO 0);
		Immediateextended : OUT std_logic_vector(31 DOWNTO 0)
);
END  Component;
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
    MemSignals:OUT std_logic_vector(1 downto 0);
     InputSignals:IN std_logic_Vector(6 downto 0)
);
END Component;
--Mux21 for WriteReg1
Signal Outdata1 :std_logic_vector(31 DOWNTO 0);

--Mux21 for Writeaddress1 && --Mux21 for Writeaddress2
Signal  Outaddress1,Outaddress2: std_logic_vector(2 DOWNTO 0);


BEGIN

	fx: ControllerP  PORT MAP(InputSignals,MemSignals,ExecSignals,WBSignals,FlushSignals,OpCode(5 downto 2));
        fxALU:ALUController PORT MAP(Rst,OpCode, SelecALU,WBSignals2,MemSignals2,InputSignals);
        fy: Reg_Filexx PORT MAP(Clk,Rst,RegWrite0,RegWrite1,Registeraddress1,Registeraddress2,Outaddress1,Outaddress2,Outdata1
				,Writedata2,Readdata1,Readdata2);
        fz: SignExtend PORT MAP(Immediate,Immediateextended);
        fw: mux21 generic map(3) PORT MAP(Writeaddress1,Writeaddress2,Outaddress1,SwapSignal);--Writeaddress1
        fq: mux21 generic map(3) PORT MAP(Writeaddress2,Writeaddress1,Outaddress2,SwapSignal);--Writeaddress2
        fr: mux21 generic map(32) PORT MAP(Writedata1,InputPortdata,Outdata1,InputPortWE);--Writedata1
END DecodeStageP;
