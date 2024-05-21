library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ProjectArch is
  generic (bits : integer := 32);
  port (
    ---Fetch Stage
    clk, reset : in  std_logic;
    interuppt_signal                   : in  std_logic;
   
    ---Decode Stage
  --Input
InputEx: IN std_logic_vector(31 downto 0);
OutPortOUT:OUT std_logic_vector(31 downto 0)
--Output 
  );
end entity;

architecture Project of ProjectArch is
  component FETCH_STAGE is
   port (
    clk, reset, enable : in  std_logic;
     Protected_signal, overflow_signal, excution_predict, branch_predict, interuppt_signal, return_signal, selection, return_selection, I_PC : in  std_logic:='0';
    PC_RESET_VALUE, JMP_LABEL, WRITE_REG_1, ADDRESS_EXP_HANDLER,Jmp_label_Exec,PCplusfrommem                    : in  std_logic_vector(31 downto 0);
    instruction                                                                     : out std_logic_vector(15 downto 0);
    PC_plus, PCold                                                           : out std_logic_vector(31 downto 0)
  );
  end component;

  component Fetch_piplined is
    port (
    clk,Reset,Enable,Interupt,flushing_for_jump : in std_logic;
  PC_plus_one: in std_logic_vector(31 downto 0);
  DFF_out: out std_logic_vector(80 downto 0);
  PC_old: in std_logic_vector(31 downto 0);
  Instruction: in std_logic_vector(15 downto 0);
  flush_imediate: in std_logic
    );
  end component;
  component DecodeStage is
    port (
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
  end component;
  component my_nDFF is
    generic (n : integer := 12);
    port (Clk, Rst : in  std_logic;
          d        : in  std_logic_vector(n - 1 downto 0);
          q        : out std_logic_vector(n - 1 downto 0);
          we       : in  std_logic);
  end component;
  component ExecuteStage is
    generic (n : integer := 32);
    port (
     Clk,Rst : IN std_logic;
 A,B,OutputALU,OUTPUTMem: in std_logic_vector(n-1 downto 0);
 Immediate:in std_logic_vector(31 downto 0);
AluSrc,AlusrcStore,Restoreflag:IN std_logic;
FU1,FU2:IN std_logic_vector(1 downto 0);
  F,ReadData1,ReadData2: out std_logic_vector(n-1 downto 0); -- we dont need to write semicolon as the end has } :)
-- Cout:out std_logic;
--Cin:in std_logic;
--Carry Flag,Negative flag,Zero Flag ,Overflowflag
SelectionALU : IN std_logic_vector(3 downto 0);
CCRx:IN std_logic_vector(3 downto 0);
    --WB Signals
    -- InPortWe: Out std_logic; -- OutPortWe: Out std_logic; -- RegWrite1: Out std_logic;
    -- SwapSignal:OUT std_logic;
    --WBSignals:OUT std_logic_vector(3 downto 0);
    --Memory Signals
  --  BitfreeorProtectSignal:OUT std_logic;-- CondorUnCond:OUT std_logic;
   -- MemSignals:OUT std_logic_vector(1 downto 0);
CCR:OUT std_logic_vector(3 downto 0);
--Immediateout:OUT std_logic_vector(31 downto 0)
inportvalue:in std_logic_vector(31 downto 0);
inportvalue2:in std_logic_vector(31 downto 0);
informem:in std_logic;
condoruncond:in std_logic;
inenable,outenable,branchsig:IN std_logic
    );
  end component;
  component memoryfreeprotect is
    generic (bits : integer := 1);
    port (
      clk, Rst, writeEN, readEN     : in  std_logic;
      readaddress                   : in  std_logic_vector(31 downto 0);
      writeport                     : in  std_logic_vector(bits - 1 downto 0);
      readport                      : out std_logic_vector(bits - 1 downto 0);
      zero_flag, branch, conduncond : in  std_logic_vector(0 downto 0);
      output_branch                 : out std_logic
    );
  end component;
  component EXMF_piplined is
   port (
     clk, Reset, Enable           : in  std_logic;
    PC_plus_one                  : in  std_logic_vector(31 downto 0);
    DFF_out                      : out std_logic_vector(231 downto 0);
    PC_old                       : in  std_logic_vector(31 downto 0);
    immediate                    : in  std_logic_vector(31 downto 0);
    writeaddress1, writeaddress2 : in  std_logic_vector(2 downto 0);
    readdata1, readdata2         : in  std_logic_vector(31 downto 0);
    flag_register                : in  std_logic_vector(3 downto 0);
    memory_signal                : in  std_logic_vector(15 downto 0);
    Excute_signal                : in  std_logic_vector(5 downto 0);
    out_alu                      : in std_logic_vector(31 downto 0);
    write_back_signal            : in  std_logic_vector(5 downto 0);
     Andgateprediction           :in std_logic;
     flushbit:in std_logic;
    loaduse:in std_logic
  );
  end component;
  component Memory is
    port (
          clk               : in  STD_LOGIC;
    reset             : in  STD_LOGIC;
    reset2           :in Std_logic;
    -------------------------------------------------------------------- pipeline signals in ----------------------------------------------------------------------------
    mBlock            : in  STD_LOGIC_VECTOR(11 downto 0); -- [0]LDIMM->1bit , [1]SPControll->1bit, [2]CallSignal->1bit ,[3]memRead ->1bit,[4]FlagSignal->1bit,[5]oldMemWrite->1bit,[6]returnSignal->1 bit,[7]SPSRC->1bit,[8] swapSignal->1bit,[9] restore flag ->1bit, [10] AluSP ->1bit ,[11] NeworOldPC ->1bit
    writeBackBlock    : in  STD_LOGIC_VECTOR(4 downto 0);  -- [0]Regwrite_EX->1bit ,[1][2]regWrite ->2bits 1 is req1 and 2 is reg2 ,[3] OutportEnable ->1bit,[4] megToReg ->1bit   note 8lbn reg1 hya same as in index  0 
    InputPortEnable   : in  STD_LOGIC;
    I_PC              : in  STD_LOGIC;
    pcPlus1           : in  STD_LOGIC_VECTOR(31 downto 0);
    flagReg           : in  STD_LOGIC_VECTOR(31 downto 0);
    bitProtect        : in  STD_LOGIC;
    dataAlu           : in  STD_LOGIC_VECTOR(31 downto 0);
    readData1         : in  STD_LOGIC_VECTOR(31 downto 0);
    PC                : in  STD_LOGIC_VECTOR(31 downto 0);
    readData2         : in  STD_LOGIC_VECTOR(31 downto 0);
    writeAddresses    : in  STD_LOGIC_VECTOR(5 downto 0);  -- 2 addresses
    immediate         : in  STD_LOGIC_VECTOR(31 downto 0);
    enable            : in  STD_LOGIC;
    rest              : in  STD_LOGIC;
    PCWB            : in  STD_LOGIC_VECTOR(31 downto 0);
   
    ---------------------------------------------------------------------------- pipeline signals out ----------------------------------------------------------------------------
    outMemoryOut      : out STD_LOGIC_VECTOR(252 downto 0);
    SpsrcWB           : in  STD_LOGIC;
    SPSElWB           : in  STD_LOGIC;
    OutMem            : out STD_LOGIC_VECTOR(31 downto 0);
    -------------------------------------------------------------------- Forwarding signals out ----------------------------------------------------------------------------
    regwriteEX        : out STD_LOGIC;
    rdstExcuteAddress : out STD_LOGIC_VECTOR(2 downto 0);
    PCjmpCH:in  STD_LOGIC_VECTOR(31 downto 0);
    jmplabel:in  STD_LOGIC_VECTOR(31 downto 0);
     branchsig,andgateforpred,flushbit: in  STD_LOGIC;
     exceptionforsp:out STD_LOGIC
    );

  end component;
  component WriteBack is
    port (
      clk, rst, Enable : in  std_logic;
      mBlock           : in  std_logic_vector(11 downto 0);
      wbBlock          : in  std_logic_vector(4 downto 0);
      memoryDataIn     : in  std_logic_vector(63 downto 0);
      aluDataIn        : in  std_logic_vector(63 downto 0);
      writeAddress     : in  std_logic_vector(5 downto 0);
      I_pc_in          : in  std_logic;

      ------------------------------------------------
      writeAddress1    : out std_logic_vector(2 downto 0);
      writeAddress2    : out std_logic_vector(2 downto 0);
      SPScr            : out std_logic;
      Restore_Flag     : out std_logic;
      Return_signal    : out std_logic;
      Swap_signal      : out std_logic;
      Enable_outport   : out std_logic;
      reg_write        : out std_logic_vector(1 downto 0);
      I_pc_out         : out std_logic;
      output_to_reg1   : out std_logic_vector(31 downto 0);
      output_to_reg2   : out std_logic_vector(31 downto 0)
    );
  end component;
Component Interruptjmp is
  port (
    Clk,Rst,enable : IN std_logic;
    Andgateprediction,xordecision,andnotforuntakendecision:IN std_logic;
    PC_plus:in std_logic_vector(31 downto 0);
     PC_jmp:in std_logic_vector(31 downto 0);
     PC_frommem:in std_logic_vector(31 downto 0);
   interrupt_signal_Exec,interrupt_signal_Decode,interrupt_signal_Mem : in STD_LOGIC;
   outputBranch:in std_logic;
   returnenable:in std_logic;
   PCout:out std_logic_vector(31 downto 0);
  outAndgateprediction,outxordecision,outandnotforuntakendecision:out std_logic;
  outreturnenable:out std_logic
  );
end Component;
Component Except_Handler IS
	PORT( 	clk,rst,Overflowflag,Protectedflag,expsp : IN std_logic;
                  PCE,PCM:IN std_logic_vector(31 downto 0);
			PCout : OUT std_logic_vector(31 downto 0);
                        Excepflag:out std_logic;        
                         outexception:out std_logic_vector(1 downto 0)  
 );
END Component;
Component Control_H_Unit IS
	PORT(
clk,rst,Outbranchforbitpredictor,Branch_Sig_Exec,predictionout_mem,Branch_sig_Mem: IN  std_logic;
		Andgateprediction,and_bet_xorout_outbranch ,and_bet_xorout_notoutbranch : OUT std_logic);
END Component;

Component Forward is
  port (
      Rsource1, Rsource2, RdstEX1, RdstEX2, RdstMem1, RdstMem2                                : in  STD_LOGIC_VECTOR(2 downto 0);

    clk, Input_enable,Input_enable_Mem, reg_write0EX, reg_write1EX, reg_write0Mem, reg_write1Mem, Alusrc, Aluforstore,AlusrcE, AluforstoreE,AlusrcM, AluforstoreM: in  STD_LOGIC;
    selection1, selection2                                                                           : out Std_logic_vector(1 downto 0);
    signalinformem:out std_logic ;
    R1swape,R2swape,R1swapm,R2swapm:out std_logic                                
  );
END Component;

Component HDU is
  port (
    Rsource1, Rsource2, Rdst : in  STD_LOGIC_VECTOR(2 downto 0);
    stop_enable_signale      : out STD_LOGIC;
    return_enable,loaduse            : out STD_LOGIC;
    clk,rst, mem_read, reg_write : in  STD_LOGIC
  );
END Component;
  signal out_mem_PF, OUT_BRANCH , OUT_BRANCHused,OUT_RETused                                               : std_logic:='0';
  signal FetchDecodeOutput                                                      : std_logic_vector(80 downto 0);
  signal PCF, PC_plusF, Readdata1, Readdata2, SignExtendImm, OutExec1, OutExec2,dataaaluxxx : std_logic_vector(31 downto 0);
  signal InstF, InstFD                                                          : std_logic_vector(15 downto 0);
  signal InputSignals                                                           : std_logic_vector(6 downto 0);
  signal MemSignals                                                             : std_logic_vector(13 downto 0):=(others => '0');
  signal ExecSignals                                                            : std_logic_vector(5 downto 0);
  signal WBSignals,ff1,ff1x                                                              : std_logic_vector(1 downto 0);
  signal FlushSignals,SelALU                                                           : std_Logic_vector(3 downto 0);
  signal OutputALU                                                              : std_Logic_vector(31 downto 0);
  signal FlagRegister                                                           : std_Logic_vector(3 downto 0);
  signal OUTDE                                                                  : std_Logic_vector(241 downto 0);
  signal MemSignals2                                                            : std_logic_vector(1 downto 0);
  signal WBSignals2                                                             : std_logic_vector(3 downto 0);
  signal OUTEMF                                                                 : std_Logic_vector(231 downto 0);
  signal OUT_MFMEM                                                              : std_Logic_vector(230 downto 0);
  signal OUT_MWB                                                              : std_Logic_vector(252 downto 0);
  signal onebit                                                                 : std_logic_vector(0 downto 0);
  Signal x1 : std_logic;
  Signal x2: std_logic_vector(2 downto 0);
Signal WA1,WA2,WAE1,WAE2:std_logic_vector(2 downto 0);
Signal Spenable, RFlagS,retS,SwapS,OUTS,I_PPCC:std_logic:='0';
Signal RegW01:std_logic_vector(1 downto 0);
Signal writedata1xx,writedata2xx,OUTOFMEM:std_logic_vector(31 downto 0);
Signal Inportvalue,FRmem:std_logic_vector(31 downto 0);
Signal DFF_out   : std_logic_vector(80 downto 0);
Signal INDE:std_logic_vector(241 downto 0);
Signal AllmemSig:std_logic_vector(15 downto 0);
Signal INMFM :std_logic_vector(230 downto 0);
Signal MBlockMem :std_logic_vector(11 downto 0);
Signal WBBlockMEM :std_logic_vector(4 downto 0);
Signal AllWBSig:std_logic_vector(5 downto 0);
Signal ImmediateOUT,immformem:std_logic_vector(31 downto 0);
signal flushbit,FlushBranching :std_logic;
Signal interrupt_2cycles,Wrx1,Wrx2:std_logic;
Signal PCforinterrupt,PCforexcep,PCforex,PCjmpCH,JmplabCH,outALUforcaseimminst,outaluspecialcase,outmemspecialcase,alufinalvalue,readdataedited:std_logic_vector(31 downto 0);
Signal flushdecode,flushexecute,flushWB,flushfetch:std_logic;
Signal Exceptionflag,signalforinmem,ff,ff2,ff3,ff4:std_logic;
Signal ff5:std_logic_vector(2 downto 0);
Signal outexcepflags,FU1,FU2:std_logic_vector(1 downto 0);
Signal Andgateprediction,and_bet_xorout_outbranch ,and_bet_xorout_notoutbranch,stop_enable, return_enablexx, enableofall ,notload, loaduse,protectorexpsp:std_logic;
Signal outAndgateprediction,outand_bet_xorout_outbranch ,outand_bet_xorout_notoutbranch,andgateforexp, R1swape,R2swape,R1swapm,R2swapm,exceptionforsp :std_logic;
--Signal PCe,PCPluse:std_logic_vector(31 downto 0);
begin
--notload<= not stop_enable;
protectorexpsp<=exceptionforsp or INMFM(92);
enableofall   <= not stop_enable;
andgateforexp<=(not Exceptionflag) and outAndgateprediction;
flushbit<=((InstFD(5)or InstFD(4)or InstFD(3)or InstFD(2)) and OUTDE(194));
--FlushBranching<= reset when INMFM(24)='1' or OUTDE(132)<='1'
--else reset  or OUT_RETused or OUT_BRANCHused;
--flushfetch<=reset  or Andgateprediction or OUT_RETused when OUT_BRANCHused=OUTEMF(230)
--else reset or and_bet_xorout_outbranch or Andgateprediction or OUT_RETused;
flushfetch<=reset when INMFM(24)='1' or OUTDE(132)='1' 
else reset or OUT_RETused or outand_bet_xorout_outbranch when DFF_out(32)='1' or interrupt_2cycles='1'
else reset or outand_bet_xorout_outbranch or andgateforexp or OUT_RETused ;
flushdecode<='1' when OUTDE(135)='1' and DFF_out(32)='1' else
reset or return_enablexx when INMFM(24)='1' or OUTDE(132)='1' 
else reset or outand_bet_xorout_notoutbranch or OUT_RETused  or return_enablexx when loaduse='1' 
else reset or outand_bet_xorout_notoutbranch or OUT_RETused;--when  OUTEMF(230)='0' and OUT_BRANCHused='1'
--else reset or OUT_RETused ;

flushexecute<=reset or outexcepflags(1) or outexcepflags(0) when Exceptionflag='1'
else reset or outand_bet_xorout_notoutbranch when OUT_MWB(250)='0' and OUT_MWB(251)='1'
else  reset;
flushWB<=reset or outexcepflags(1) when Exceptionflag='1'
else reset;

 interrupt_2cycles<=interuppt_signal or DFF_out(32);
  F1: Fetch_STAGE
    port map (clk, reset,enableofall ,protectorexpsp, FlagRegister(3), outand_bet_xorout_notoutbranch,andgateforexp,
                interrupt_2cycles,MemSignals(9),outand_bet_xorout_outbranch,OUT_RETused,'0' ,
              OUTOFMEM,OUT_MWB(249 downto 218) , OUTOFMEM, x"000001F4",OutExec1,OUT_MWB(217 downto 186),InstF ,PC_plusF, PCF);
--PCPluse<=PCF;
--PCe<=std_logic_vector(to_unsigned((to_integer(unsigned(PCF))-1),32));
  FD: Fetch_piplined port map (clk,flushfetch,enableofall, interuppt_signal,'0',PC_plusF, DFF_out, PCF, InstF,flushbit);--if the DFFOUT(48 downto 33) 0000000000000000 =>0111000000000000
  
  InstFD <= DFF_out(48 downto 33);

  InputSignals <= OUTDE(194)&OUTDE(135) & OUTDE(132) &  FlagRegister(3)&(out_mem_PF or exceptionforsp) &  DFF_out(32) & (outexcepflags(1) or outexcepflags(0)or reset);
  
  D1: DecodeStage
    port map (InputSignals, InstFD(5 downto 0), MemSignals, ExecSignals, WBSignals, FlushSignals, clk, reset,
              RegW01(0), RegW01(1), InstFD(11 downto 9), InstFD(14 downto 12),WA1,WA2,
              writedata1xx, writedata2xx, Readdata1, Readdata2, SwapS, OUT_MWB(17), Inportvalue,InstF ,ImmediateOUT,
             SelALU,WBSignals2, MemSignals2); -- 33 38 OPCode 39 41 Dest 42 44 rsrc1 45 47 rsrc2
         
PCforex<=PCforexcep when Exceptionflag='1'
else DFF_out(31 downto 0);
WAE1<= OUTDE(190 downto 188) when INMFM(22)='0' and INMFM(25)='0'
else OUTDE(190 downto 188) when  OUTEMF(231)='0'
else WA1;
WAE2<= OUTDE(193 downto 191) when INMFM(22)='0' and INMFM(25)='0'
else OUTDE(193 downto 191) when  OUTEMF(231)='0'
else WA2;
Wrx1<=OUTDE(129)when INMFM(22)='0' and INMFM(25)='0'
else OUTDE(129) when OUTEMF(231)='0'
else RegW01(0);
Wrx2<=OUTDE(199)when INMFM(22)='0' and INMFM(25)='0'
else OUTDE(199) when OUTEMF(231)='0'
else RegW01(1);

outALUforcaseimminst<=writedata1xx;

INDE<=R2swapm&R1swapm&R2swape&R1swape&outALUforcaseimminst&signalforinmem&FU2&FU1&WBSignals2&MemSignals2&InstFD(15)&InstFD(14 downto 12) & InstFD(8 downto 6) & ImmediateOUT&"00"&SelALU 
& MemSignals & ExecSignals & WBSignals & DFF_out(80 downto 49) & PCforex & Readdata1 & Readdata2;
  DE: my_nDFF generic map (242) port map (clk, flushdecode,INDE , OUTDE, enableofall); -- WBsig2 200197,Memsig2 196195&flushbit 194&WA2WA1 193188&Imm 187156&Opcode155150& M 149136& E  135130& WB 129128& PC+1 12796& PC 9564& ReadData1 6332 & ReadData2  310

outaluspecialcase<=INMFM(124 downto 93) when  INMFM(22)='0' and INMFM(25)='0' and INMFM(21)='0' and OUT_MWB(252)='0' 
else INMFM(160 downto 129) when OUTDE(202 downto 201)="01" and INMFM(21)='1' and OUTDE(238)='1'
else INMFM(160 downto 129) when  OUTDE(204 downto 203)="01" and INMFM(21)='1' and OUTDE(238)='1'
else INMFM(124 downto 93) when OUTDE(202 downto 201)="01"  and INMFM(21)='1' and OUTDE(239)='1'
else INMFM(124 downto 93) when  OUTDE(204 downto 203)="01" and INMFM(21)='1' and OUTDE(239)='1'
else INMFM(124 downto 93) when OUTEMF(231)='0' and OUT_MWB(252)='0'
else OUTDE(237 downto 206);
alufinalvalue<=OUTDE(237 downto 206) when OUT_MWB(252)='1' and (OUTDE(202 downto 201)="10" or OUTDE(204 downto 203)="10")
else writedata1xx when OUT_MWB(252)='1' and (OUTDE(202 downto 201)="01" or OUTDE(204 downto 203)="01")
else outaluspecialcase;
outmemspecialcase<= writedata2xx when (OUTDE(202 downto 201)="10" or OUTDE(204 downto 203)="10") and SwapS='1' and OUTDE(240)='1' and OUTDE(241)='0'
else writedata1xx  when (OUTDE(202 downto 201)="10" or OUTDE(204 downto 203)="10") and SwapS='1' and OUTDE(241)='1'
else writedata1xx;
  E1: ExecuteStage
    generic map (32)
    port map (clk, reset, OUTDE(63 downto 32), OUTDE(31 downto 0),alufinalvalue, outmemspecialcase,OUTDE(187 downto 156), OUTDE(130), OUTDE(133), INMFM(26),OUTDE(202 downto 201),OUTDE(204 downto 203),OutputALU, OutExec1, OutExec2, OUTDE(153 downto 150),OUTOFMEM(3 downto 0), FlagRegister,InputEx,Inportvalue,OUTDE(205),OUTDE(196),OUTDE(197),OUTDE(198),OUTDE(146));
   AllmemSig<=OUTDE(196 downto 195) & OUTDE(149 downto 136);
AllWBSig<=OUTDE(200 downto 197)& OUTDE(129 downto 128);

Forward_unit:Forward port map(InstFD(11 downto 9),InstFD(14 downto 12),WAE1,WAE2,
INMFM(198 downto 196),INMFM(195 downto 193),clk,OUTDE(197),INMFM(18),Wrx1,Wrx2,INMFM(17),INMFM(20),ExecSignals(0),ExecSignals(3),OUTDE(130),OUTDE(133),INMFM(22),INMFM(25),FU1,FU2,signalforinmem,R1swape,R2swape,R1swapm,R2swapm);

readdataedited<=OUTDE(63 downto 32) when OUTDE(133)='1' and OUTDE(140)='1'
else OutExec1;


  EMF: EXMF_piplined
    port map (clk, flushexecute,'1', OUTDE(127 downto 96), OUTEMF,OUTDE(95 downto 64),OUTDE(187 downto 156)
               ,OUTDE(190 downto 188),OUTDE(193 downto 191),readdataedited,OutExec2,
 FlagRegister,AllmemSig, OUTDE(135 downto 130),OutputALU,AllWBSig,Andgateprediction,OUTDE(194),notload);

  MF1: memoryfreeprotect
    generic map (1)
    port map (clk => clk, Rst => reset, writeEN =>  OUTEMF(1), readEN => OUTEMF(0),
              readaddress => OUTEMF(229 downto 198),
              writeport(0) => OUTEMF(14),
              readport(0) => out_mem_PF,
              zero_flag(0) => OUTEMF(30), branch(0)=> OUTEMF(10), conduncond(0) => OUTEMF(15), output_branch => OUT_BRANCH);
INMFM<=OUTEMF(133 downto 102) &
    OUTEMF(101 downto 99) & OUTEMF(98 downto 96) &
    OUTEMF(95 downto 64) & OUTEMF(63 downto 32) & OUTEMF(31 downto 28)
    & OUTEMF(229 downto 198) & out_mem_PF & OUTEMF(197 downto 166) &
    OUTEMF(165 downto 134)  & OUTEMF(27 downto 22)& OUTEMF(21 downto 16) 
& OUTEMF(15 downto 0);
 -- MFM: my_nDFF generic map (231) port map (clk, reset, 
 -- INMFM, OUT_MFMEM , '1');-- Imm230199,WA198196,WA2195193,readda1192161,readdata2160129,Flagreg128125,Outalu12493,Protectfreebit92,PC+19160,PCold5928,&Exec2722&WB2116&M150
  MBlockMem<=INMFM(13)&INMFM(11)&INMFM(26) 
 &INMFM(21)&INMFM(6)&INMFM(9)&INMFM(4)&INMFM(7)&INMFM(3)&INMFM(5)& INMFM(2) &INMFM(8);
  WBBlockMEM<=INMFM(16)&INMFM(19)&INMFM(20)&INMFM(17) &'0';
   FRmem<=x"0000000"&INMFM(128 downto 125);
immformem<=x"0000"&INMFM(214 downto 199);
dataaaluxxx<= x"0000"&INMFM(108 downto 93) when INMFM(8)='1' 
else INMFM(124 downto 93);

Interrupt_unit:Interruptjmp port map(clk, reset,interrupt_2cycles,Andgateprediction,and_bet_xorout_outbranch
,and_bet_xorout_notoutbranch,INMFM(91 downto 60),INMFM(124 downto 93),OUTOFMEM,OUTDE(132),DFF_out(32),INMFM(24),
OUT_BRANCH,INMFM(9),PCforinterrupt,outAndgateprediction,
outand_bet_xorout_outbranch ,outand_bet_xorout_notoutbranch,OUT_RETused);

  M1:Memory port map( clk=>clk,            
    reset=>reset ,reset2=>flushWB,          
  -------------------------------------------------------------------- pipeline signals in ----------------------------------------------------------------------------
  mBlock=> MBlockMem,          -- [0]LDIMM->1bit , [1]SPControll->1bit, [2]CallSignal->1bit ,[3]memRead ->1bit,[4]FlagSignal->1bit,[5]oldMemWrite->1bit,[6]returnSignal->1 bit,[7]SPSRC->1bit,[8] swapSignal->1bit,[9] restore flag ->1bit, [10] AluSP ->1bit ,[11] NeworOldPC ->1bit
  writeBackBlock=> WBBlockMEM,  -- [0]Regwrite_EX->1bit ,[1][2]regWrite ->2bits 1 is req1 and 2 is reg2 ,[3] signalEnable ->1bit,[4] megToReg ->1bit   note 8lbn reg1 hya same as in index  0 
   InputPortEnable =>INMFM(18),
   I_PC=>INMFM(24),
      pcPlus1 =>INMFM(91 downto 60),
      flagReg =>FRmem,
      bitProtect =>INMFM(92),
      dataAlu =>dataaaluxxx,
      readData1 =>INMFM(192 downto 161),
      PC =>INMFM(59 downto 28),
      readData2=>INMFM(160 downto 129),
      writeAddresses=> INMFM(198  downto 193),  --WA1 & --WA2
      immediate =>immformem,
      enable =>'1',
      rest =>reset,
         PCWB=>PCforinterrupt,
      ---------------------------------------------------------------------------- pipeline signals out ----------------------------------------------------------------------------
      outMemoryOut=>OUT_MWB ,
      SpsrcWB=>Spenable,
       SPSElWB=>OUT_MWB(10),
      OutMem=>OUTOFMEM,
      -------------------------------------------------------------------- Forwarding signals out ----------------------------------------------------------------------------
      regwriteEX=>x1,
      rdstExcuteAddress =>x2,
      PCjmpCH=>INMFM(91 downto 60),
     jmplabel=>INMFM(192 downto 161)
     ,branchsig=>OUT_BRANCH,andgateforpred=>OUTEMF(230),flushbit=>OUTEMF(231),
    exceptionforsp=>exceptionforsp
);
WB: WriteBack Port map( clk=>clk,            
 rst=>reset ,       
Enable=>'1',
mBlock=>OUT_MWB(11 downto 0),
wbBlock=>OUT_MWB(16 downto 12),
memoryDataIn=>OUT_MWB(113 downto 50),
aluDataIn=>OUT_MWB(178 downto 115),
writeAddress=>OUT_MWB(184 downto 179),
I_pc_in=>OUT_MWB(185),
writeAddress1=> WA1,
writeAddress2=> WA2,
SPScr=> Spenable,
Restore_Flag=> RFlagS,
Return_signal => retS,
Swap_signal=> SwapS,
Enable_outport=> OUTS,
reg_write=> RegW01,
I_pc_out=>I_PPCC,
output_to_reg1=> writedata1xx,
output_to_reg2=> writedata2xx
   );
  Outport: my_nDFF generic map (32) port map (clk,reset,writedata1xx,OutPortOUT,OUTS);
  InPort: my_nDFF generic map (32) port map (clk,reset,InputEx,Inportvalue,'1');
   Exception:Except_Handler port map(clk,reset,FlagRegister(3),out_mem_PF,exceptionforsp,OUTDE(95 downto 64)
,INMFM(59 downto 28),PCforexcep,Exceptionflag,outexcepflags);

--clk,rst,Outbranchforbitpredictor,Branch_Sig_Exec,predictionout_mem,Branch_sig_Mem

ControlHazard:Control_H_Unit port map(clk,reset,OUT_BRANCH,OUTDE(146),OUTEMF(230),INMFM(10),Andgateprediction,and_bet_xorout_outbranch,and_bet_xorout_notoutbranch);
HDU_UNIT: HDU
    port map (Rsource1 => DFF_out(44 downto 42), Rsource2 => DFF_out(47 downto 45), Rdst => OUTDE(190 downto 188),
              stop_enable_signale => stop_enable, return_enable => return_enablexx,loaduse=>loaduse,
              clk => clk,rst=>flushdecode, mem_read => OUTDE(139), reg_write => OUTDE(129));
end architecture;
