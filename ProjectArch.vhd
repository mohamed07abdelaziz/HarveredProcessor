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
      clk, reset, enable, Protected_signal, overflow_signal, excution_predict, branch_predict, interuppt_signal, return_signal, selection, return_selection, I_PC : in  std_logic;
      PC_RESET_VALUE, JMP_LABEL, WRITE_REG_1, ADDRESS_EXP_HANDLER                                                                                                 : in  std_logic_vector(31 downto 0);
      instruction                                                                                                                                                 : out std_logic_vector(15 downto 0);
      PC_plus, PCold                                                                                                                                              : out std_logic_vector(31 downto 0)
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
 OpCode : IN std_logic_vector(3 DOWNTO 0);
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
		Immediateextended : OUT std_logic_vector(31 DOWNTO 0)
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
--Immediateout:OUT std_logic_vector(31 downto 0)
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
      DFF_out                      : out std_logic_vector(229 downto 0);
      PC_old                       : in  std_logic_vector(31 downto 0);
      immediate                    : in  std_logic_vector(31 downto 0);
      writeaddress1, writeaddress2 : in  std_logic_vector(2 downto 0);
      readdata1, readdata2         : in  std_logic_vector(31 downto 0);
      flag_register                : in  std_logic_vector(3 downto 0);
      memory_signal                : in  std_logic_vector(15 downto 0);
      Excute_signal                : in  std_logic_vector(5 downto 0);
      out_alu                      : in  std_logic_vector(31 downto 0);
      write_back_signal            : in  std_logic_vector(5 downto 0)
    );
  end component;
  component Memory is
    port (
          clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      -------------------------------------------------------------------- pipeline signals in ----------------------------------------------------------------------------
      mBlock : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- [0]LDIMM->1bit , [1]SPControll->1bit, [2]CallSignal->1bit ,[3]memRead ->1bit,[4]FlagSignal->1bit,[5]oldMemWrite->1bit,[6]returnSignal->1 bit,[7]SPSRC->1bit,[8] swapSignal->1bit,[9] restore flag ->1bit, [10] AluSP ->1bit ,[11] NeworOldPC ->1bit
      writeBackBlock : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- [0]Regwrite_EX->1bit ,[1][2]regWrite ->2bits 1 is req1 and 2 is reg2 ,[3] OutportEnable ->1bit,[4] megToReg ->1bit   note 8lbn reg1 hya same as in index  0 
      InputPortEnable : IN STD_LOGIC;
       I_PC: IN STD_LOGIC;
      pcPlus1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      flagReg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      bitProtect : IN STD_LOGIC;
      dataAlu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      readData1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      readData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      writeAddresses : IN STD_LOGIC_VECTOR(5 DOWNTO 0); -- 2 addresses
      immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      enable : IN STD_LOGIC;
      rest : IN STD_LOGIC;
      ---------------------------------------------------------------------------- pipeline signals out ----------------------------------------------------------------------------
      outMemoryOut : OUT STD_LOGIC_VECTOR(185 DOWNTO 0);
      SpsrcWB:IN STD_LOGIC;
       SPSElWB: IN STD_LOGIC;
      OutMem:OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      -------------------------------------------------------------------- Forwarding signals out ----------------------------------------------------------------------------
      regwriteEX : OUT STD_LOGIC;
      rdstExcuteAddress : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)


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
  signal out_mem_PF, OUT_BRANCH                                                 : std_logic:='0';
  signal FetchDecodeOutput                                                      : std_logic_vector(80 downto 0);
  signal PCF, PC_plusF, Readdata1, Readdata2, SignExtendImm, OutExec1, OutExec2 : std_logic_vector(31 downto 0);
  signal InstF, InstFD                                                          : std_logic_vector(15 downto 0);
  signal InputSignals                                                           : std_logic_vector(6 downto 0);
  signal MemSignals                                                             : std_logic_vector(13 downto 0):=(others => '0');
  signal ExecSignals                                                            : std_logic_vector(5 downto 0);
  signal WBSignals                                                              : std_logic_vector(1 downto 0);
  signal FlushSignals                                                           : std_Logic_vector(3 downto 0);
  signal OutputALU                                                              : std_Logic_vector(31 downto 0);
  signal FlagRegister                                                           : std_Logic_vector(3 downto 0);
  signal OUTDE                                                                  : std_Logic_vector(194 downto 0);
  signal MemSignals2                                                            : std_logic_vector(1 downto 0);
  signal WBSignals2                                                             : std_logic_vector(3 downto 0);
  signal OUTEMF                                                                 : std_Logic_vector(229 downto 0);
  signal OUT_MFMEM                                                              : std_Logic_vector(230 downto 0);
  signal OUT_MWB                                                              : std_Logic_vector(185 downto 0);
  signal onebit                                                                 : std_logic_vector(0 downto 0);
  Signal x1 : std_logic;
  Signal x2: std_logic_vector(2 downto 0);
Signal WA1,WA2:std_logic_vector(2 downto 0);
Signal Spenable, RFlagS,retS,SwapS,OUTS,I_PPCC:std_logic:='0';
Signal RegW01:std_logic_vector(1 downto 0);
Signal writedata1xx,writedata2xx,OUTOFMEM:std_logic_vector(31 downto 0);
Signal Inportvalue,FRmem:std_logic_vector(31 downto 0);
Signal DFF_out   : std_logic_vector(80 downto 0);
Signal INDE:std_logic_vector(194 downto 0);
Signal AllmemSig:std_logic_vector(15 downto 0);
Signal INMFM :std_logic_vector(230 downto 0);
Signal MBlockMem :std_logic_vector(11 downto 0);
Signal WBBlockMEM :std_logic_vector(4 downto 0);
Signal AllWBSig:std_logic_vector(5 downto 0);
Signal ImmediateOUT:std_logic_vector(31 downto 0);
begin

  F1: Fetch_STAGE
    port map (clk, reset, '1',OUT_MFMEM(92), FlagRegister(3), '0','0',
               interuppt_signal,MemSignals(9) , '0',retS, I_PPCC  ,
              OUTOFMEM, OutExec1, writedata1xx, x"00000000",InstF ,PC_plusF, PCF);
  FD: Fetch_piplined port map (clk, reset,'1', interuppt_signal,'0',PC_plusF, DFF_out, PCF, InstF,OUTDE(194));--if the DFFOUT(48 downto 33) 0000000000000000 =>0111000000000000
  
  InstFD       <= DFF_out(48 downto 33);
  InputSignals <=OUTDE(194)&OUTDE(135) & OUTDE(132) & out_mem_PF & FlagRegister(3) &  DFF_out(32) & reset;

  D1: DecodeStage
    port map (InputSignals, InstFD(5 downto 2), MemSignals, ExecSignals, WBSignals, FlushSignals, clk, reset,
              RegW01(0), RegW01(1), InstFD(11 downto 9), InstFD(14 downto 12),WA1,WA2,
              writedata1xx, writedata2xx, Readdata1, Readdata2, SwapS, OUT_MWB(17), Inportvalue,InstF,ImmediateOUT
             ); -- 33 38 OPCode 39 41 Dest 42 44 rsrc1 45 47 rsrc2
INDE<=DFF_out(48)&InstFD(14 downto 12) & InstFD(8 downto 6) & ImmediateOUT& InstFD(5 downto 0) 
& MemSignals & ExecSignals & WBSignals & PC_plusF & PCF & Readdata1 & Readdata2;
  DE: my_nDFF generic map (195) port map (clk, reset,INDE , OUTDE, '1'); -- WA2WA1 193188&Imm 187156&Opcode155150&M 149136& E  135130& WB 129128& PC+1 12796& PC 9564& ReadData1 6332 & ReadData2  310
  E1: ExecuteStage
    generic map (32)
    port map (clk, reset,OUTDE(63 downto 32), OUTDE(31 downto 0), OutputALU, OUTOFMEM,OUTDE(187 downto 156), OUTDE(130), OUTDE(133), RFlagS,"00","00" ,OutputALU, OutExec1, OutExec2, OUTDE(155 downto 150), OUTOFMEM(3 downto 0), WBSignals2, MemSignals2, FlagRegister);
   AllmemSig<=MemSignals2 & OUTDE(149 downto 136);
AllWBSig<=WBSignals2& OUTDE(129 downto 128);
  EMF: EXMF_piplined
    port map (clk, reset,'1', OUTDE(127 downto 96), OUTEMF, ImmediateOUT, OUTDE(187 downto 156)
               ,OUTDE(190 downto 188),OUTDE(193 downto 191), OUTDE(63 downto 32), OUTDE(31 downto 0),
 FlagRegister,AllmemSig, OUTDE(135 downto 130),OutputALU,AllWBSig);
  MF1: memoryfreeprotect
    generic map (1)
    port map (clk => clk, Rst => reset, writeEN => '0', readEN => OUTEMF(0),
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
  MFM: my_nDFF generic map (231) port map (clk, reset, 
  INMFM, OUT_MFMEM , '1');-- Imm230199,WA198196,WA2195193,readda1192161,readdata2160129,Flagreg128125,Outalu12493,Protectfreebit92,PC+19160,PCold5928,&Exec2722&WB2116&M150
  MBlockMem<=OUT_MFMEM(13)&OUT_MFMEM(11)&OUT_MFMEM(26) 
 &OUT_MFMEM(21)&OUT_MFMEM(6)&OUT_MFMEM(9)&OUT_MFMEM(4)&OUT_MFMEM(7)&OUT_MFMEM(3)&OUT_MFMEM(5)& OUT_MFMEM(2) &OUT_MFMEM(8);
  WBBlockMEM<=OUT_MFMEM(16)&OUT_MFMEM(19)&OUT_MFMEM(20)&OUT_MFMEM(17) &'0';
   FRmem<=x"0000000"&OUT_MFMEM(128 downto 125);
  M1:Memory port map( clk=>clk,            
    reset=>reset ,          
  -------------------------------------------------------------------- pipeline signals in ----------------------------------------------------------------------------
  mBlock=> MBlockMem,          -- [0]LDIMM->1bit , [1]SPControll->1bit, [2]CallSignal->1bit ,[3]memRead ->1bit,[4]FlagSignal->1bit,[5]oldMemWrite->1bit,[6]returnSignal->1 bit,[7]SPSRC->1bit,[8] swapSignal->1bit,[9] restore flag ->1bit, [10] AluSP ->1bit ,[11] NeworOldPC ->1bit
  writeBackBlock=> WBBlockMEM,  -- [0]Regwrite_EX->1bit ,[1][2]regWrite ->2bits 1 is req1 and 2 is reg2 ,[3] signalEnable ->1bit,[4] megToReg ->1bit   note 8lbn reg1 hya same as in index  0 
   InputPortEnable =>OUT_MFMEM(18),
   I_PC=>OUT_MFMEM(24),
      pcPlus1 =>OUT_MFMEM(91 downto 60),
      flagReg =>FRmem,
      bitProtect =>OUT_MFMEM(92),
      dataAlu =>OUT_MFMEM(124 downto 93),
      readData1 =>OUT_MFMEM(192 downto 161),
      PC =>OUT_MFMEM(59 downto 28),
      readData2=>OUT_MFMEM(160 downto 129),
      writeAddresses=> OUT_MFMEM(198  downto 193),  --WA1 & --WA2
      immediate =>OUT_MFMEM(230 downto 199),
      enable =>'1',
      rest =>reset,
      ---------------------------------------------------------------------------- pipeline signals out ----------------------------------------------------------------------------
      outMemoryOut=>OUT_MWB ,
      SpsrcWB=>Spenable,
       SPSElWB=>OUT_MWB(10),
      OutMem=>OUTOFMEM,
      -------------------------------------------------------------------- Forwarding signals out ----------------------------------------------------------------------------
      regwriteEX=>x1,
      rdstExcuteAddress =>x2
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
end architecture;