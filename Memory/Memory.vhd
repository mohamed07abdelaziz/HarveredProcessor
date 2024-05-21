library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.numeric_std.all;

entity Memory is
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

end entity;

architecture impOfMemory of Memory is
  component my_nDFF is
    generic (N : INTEGER := 12);
    port (
      Clk, Rst : in  std_logic;
      d        : in  std_logic_vector(n - 1 downto 0);
      q        : out std_logic_vector(n - 1 downto 0);
      we       : in  std_logic
    );
  end component;

  component spAlu is
    port (
      aluSp      : in  STD_LOGIC;
      clk, reset : in  STD_LOGIC;
      spSrc      : in  STD_LOGIC;
      SPOut      : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  component Ram is
    port (
      clk         : in  STD_LOGIC;
      writeEnable : in  STD_LOGIC;
      readEnable  : in  STD_LOGIC;
      rest        : in  STD_LOGIC;
      Address     : in  STD_LOGIC_VECTOR(31 downto 0);
      dataIn      : in  STD_LOGIC_VECTOR(31 downto 0);
      dataOut     : out STD_LOGIC_VECTOR(31 downto 0);
      spControl   : in  STD_LOGIC

    );
  end component;

  signal SP        : STD_LOGIC_VECTOR(31 downto 0);
  signal oM1       : STD_LOGIC_VECTOR(31 downto 0);
  signal oM2       : STD_LOGIC_VECTOR(31 downto 0);
  signal oM3       : STD_LOGIC_VECTOR(31 downto 0);
  signal oM4       : STD_LOGIC_VECTOR(31 downto 0);
  signal oM5,PCe       : STD_LOGIC_VECTOR(31 downto 0);
  signal memWrite  : STD_LOGIC;
  signal outMemory : STD_LOGIC_VECTOR(31 downto 0);

  signal write_Back    : STD_LOGIC_VECTOR(63 downto 0);
  signal dataAluSignal : STD_LOGIC_VECTOR(63 downto 0);
  signal spOutSig      : STD_LOGIC_VECTOR(31 downto 0);
  signal dataOut       : STD_LOGIC_VECTOR(252 downto 0);
  signal enablesp,enableread :STD_LOGIC;
 
begin
  ----------------------------------------------------------use spAlu component-------------------------------------------
  spAlu1: spAlu port map ( mBlock(10), clk, reset, enablesp, spOutSig);
  --mux 1
enablesp<='0' when  spOutSig=x"000007FF" and mBlock(10)='0'
else mBlock(7);
enableread<='0' when spOutSig=x"000007FF" and mBlock(10)='0' and mBlock(3)='1' and mBlock(1)='1'
else  mBlock(3);
exceptionforsp<='1' when spOutSig=x"000007FF" and mBlock(10)='0' and mBlock(3)='1' and mBlock(1)='1'
else '0';
  oM1 <= dataAlu when mBlock(1) = '0' ---SPCOntrol
else
        spOutSig;
PCe<=PC when I_PC='0'
else PCWB;

  --mux 2
  oM2 <= pcPlus1 when mBlock(11) = '0' --PCornewPC
else
         PCe;

  --mux 3
  oM3 <= oM1 when mBlock(0) = '0' --LDIMM
else
         immediate;

  --mux 4
  oM4 <= readData1 when mBlock(2) = '0' --Call Signal
else
         oM2;

  --mux 5
  oM5 <= oM4 when mBlock(4) = '0' --FlagSignal
else
         flagReg;
  

  memWrite <= not bitProtect and mBlock(5); --MemWrite

  Ram1: Ram port map (clk, memWrite, enableread, rest, oM3, oM5, outMemory, mBlock(1)); --MemWrite,SPCOntrol,MemRead
  OutMem <= outMemory;

  write_Back    <= x"00000000" & outMemory; --64 bits
  dataAluSignal <= dataAlu & readData2;     --64 bits
  -------------------------------------------------------------------- pipeline signals out ----------------------------------------------------------------------------
  dataOut       <= flushbit&branchsig&andgateforpred&jmplabel&PCjmpCH&I_PC & writeAddresses & dataAluSignal & rest & write_Back & spOutSig & InputPortEnable & writeBackBlock & mBlock;--217186
  --        0->11          12->16        17              18->49       50->112     113       114       115->179       180->186
  PipeLine: my_nDFF generic map (253) port map (clk,reset2, dataOut, outMemoryOut, enable);
  -------------------------------------------------------------------- Forwarding signals out ----------------------------------------------------------------------------
  -- rdstExcuteAddress<=
  -- regwriteEX<=writeBackBlock(0);
end architecture;
