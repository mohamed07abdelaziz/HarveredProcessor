LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ControllerP IS
	PORT ( 	
        --Input Signals
    -- Rst: IN std_logic;0  -- Int: IN std_logic;1-- Overflow:In std_logic;2-- ProtectedSig:In std_logic;3
    -- InterruptforPCandFx:IN std_logic;4 -RTISigx:IN std_logic;5 bitforimmediate :6
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
END ControllerP;

ARCHITECTURE P_Controller OF ControllerP IS
BEGIN

	    Process(InputSignals,Opcode)
        begin
         if(InputSignals(0)='1')  then--Reset
--          --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="00";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
   MemorySignals<="00000000000000";
   ExecuteSignals<="000000";
   WBSignals<="00";
   FlushSignals<="0000";
        elsif(InputSignals(1)='1') then--Interrupt
        --          --Memory Signals
    --     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='0'; --For Data Memory
    --     MemWrite<='1'; --FOr Data Memory--     Call_Signal<='1';--     SPsrc<='1';--     FlagSignal<='0';
    --     LDIMM<='0';--     ReturnEnable<='0'; --     Branch<='0'; --     SPSel<='1'; --   
      --Execute Signals --     --ALU_Src<='0'; --     RegDst<='0';--     InterruptforPCandF<='1';--    
      -- AluSrcForStore<='0'; --     RestoreFlags<='0'; -RTISig<='0';5 
    --     --WriteBack Signals
    --    MemtoReg<='0';--    RegWrite<="00";
    --    --Flushing Signals
    --    F_Flush<='0';--    D_Flush<='0';--    E_Flush<='0';--    MF_Flush<='0';
       MemorySignals<="10100001110100";
       ExecuteSignals<="000100";
       WBSignals<="00";
       FlushSignals<="0000";
       elsif(InputSignals(2)='1') then--Protect
            --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='0'; --For Data Memory
--     MemWrite<='1'; --FOr Data Memory--     Call_Signal<='1';--     SPsrc<='1';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='1';
--     --Execute Signals
--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';--     AluSrcForStore<='0';
--     RestoreFlags<='0'; -RTISig<='0';5 
--     --WriteBack Signals
--    MemtoReg<='0';--    RegWrite<="00";
--    --Flushing Signals
--    F_Flush<='1';--    D_Flush<='1';--    E_Flush<='1';--    MF_Flush<='1';
MemorySignals<="10100001110100";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="1111";
        elsif(InputSignals(3)='1') then--Overflow
          --Memory Signals--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='1';
--     MemRead<='0'; --For Data Memory--     MemWrite<='1'; --FOr Data Memory--     Call_Signal<='0';
--     SPsrc<='1';--     FlagSignal<='0';--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';
--     SPSel<='1';--    
 --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
 --WriteBack Signals--    MemtoReg<='0';--    RegWrite<="00";--    
--Flushing Signals--    F_Flush<='1';--    D_Flush<='1';--    E_Flush<='1';
--    MF_Flush<='0';
MemorySignals<="10100001110100";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="0111";
        elsif(InputSignals(4)='1') then  --InterruptforPCandFx
              --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='0'; --For Data Memory
--     MemWrite<='1'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='1';--     FlagSignal<='1';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='1';--     
--Execute Signals
--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';--     AluSrcForStore<='0';
--     RestoreFlags<='0';--    -RTISig<='0';5 
  --WriteBack Signals--    MemtoReg<='0';--    RegWrite<="00";
--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';--    E_Flush<='0';
--    MF_Flush<='0';
MemorySignals<="00100011010100";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="0000";
elsif(INputSignals(5)='1')  then --RTISigx
--Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='1'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='1';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='1';--     Branch<='0';--     SPSel<='0';--    --returnDisable<='1' 
--Execute Signals
--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';--     AluSrcForStore<='0';
--     RestoreFlags<='0';--    -RTISig<='0';5 
  --WriteBack Signals--    MemtoReg<='0';--    RegWrite<="00";
--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';--    E_Flush<='0';
--    MF_Flush<='0';
MemorySignals<="01001001001100";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="0000";
elsif( Opcode="0000") then
    --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="00";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000000000";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="0000";
elsif(Opcode="0001") then
--          --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="01";--  
--Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000000000";
ExecuteSignals<="000000";
WBSignals<="10";
FlushSignals<="0000";
elsif(Opcode="0010") then
--          --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="01";--  
--Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000000000";
ExecuteSignals<="000000";
WBSignals<="10";
FlushSignals<="0000";
elsif(Opcode="0011") then
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--     ALU_Src<='1';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="01";--  
--Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000000000";
ExecuteSignals<="000001";
WBSignals<="10";
if(INputSignals(6)='1') then
FlushSignals<="0001";
end if; 
elsif(Opcode="0100") then
  --     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="01";--  
--Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000000000";
ExecuteSignals<="000000";
WBSignals<="10";

FlushSignals<="0000";

elsif(Opcode="0101") then
           --Memory Signals
--     MemReadPF<='1';  --MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='1'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='1';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="00";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000010001";
ExecuteSignals<="001000";
WBSignals<="00";
if(INputSignals(6)='1') then
FlushSignals<="0001";
end if;
elsif(Opcode="0110") then
        --Memory Signals
--     MemReadPF<='1';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='0'; --For Data Memory
--     MemWrite<='1'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='1';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='1';
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="00";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00100001010101";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="0000";

elsif(Opcode="0111") then
      --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='1'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--     ALU_Src<='1';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='1';
--    RegWrite<="01";--  
--Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000001000";
ExecuteSignals<="000001";
WBSignals<="11";
if(INputSignals(6)='1') then
FlushSignals<="0001";
end if; 
elsif(Opcode="1000") then
           --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='1';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0';
--     --Execute Signals--    
-- ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='1';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="01";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000100000000";
ExecuteSignals<="001000";
WBSignals<="10";
if(INputSignals(6)='1') then
FlushSignals<="0001";
end if ;
elsif(Opcode="1001") then
       --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='1'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='1';--     SPsrc<='1';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='1';--     Branch<='0';--     SPSel<='0'; --returnDisable<='1'
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='1';
--    RegWrite<="00";--    --Flushing Signals--    F_Flush<='1';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="01001001101100";
ExecuteSignals<="000000";
WBSignals<="01";
FlushSignals<="0001";
elsif(Opcode="1010") then
            --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0'; --returnDisable<='0'
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="01";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000000000";
ExecuteSignals<="000000";
WBSignals<="10";
FlushSignals<="0000"; 
elsif(Opcode="1011") then
               --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='1';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0'; --returnDisable<='0'  
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="00";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000000000010";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="0000"; 
elsif(Opcode="1100") then
-- MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='0';--     MemRead<='0'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='0';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='1';--     SPSel<='0'; --returnDisable<='0'  
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="00";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00010000000000";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="0000"; 
elsif(Opcode="1101") then
-- MemReadPF<='1';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='0'; --For Data Memory
--     MemWrite<='1'; --FOr Data Memory--     Call_Signal<='1';--     SPsrc<='1';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='1';--     SPSel<='1'; --returnDisable<='0'  NeworOldPC<='0'
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="00";--    --Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00110001110101";
ExecuteSignals<="000000";
WBSignals<="00";
FlushSignals<="0000";
elsif(Opcode="1110") then
-- MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='1'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='0';--     SPsrc<='1';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0'; --returnDisable<='0'  
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='0';--    -RTISig<='0';5 
--WriteBack Signals--    MemtoReg<='1';
--    RegWrite<="1";--   
--Flushing Signals--    F_Flush<='0';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000001001100";
ExecuteSignals<="000000";
WBSignals<="11";
FlushSignals<="0000";
else
            --Memory Signals
--     MemReadPF<='0';--     MemWritePF<='0';--     SPControl<='1';--     MemRead<='1'; --For Data Memory
--     MemWrite<='0'; --FOr Data Memory--     Call_Signal<='1';--     SPsrc<='1';--     FlagSignal<='0';
--     LDIMM<='0';--     ReturnEnable<='0';--     Branch<='0';--     SPSel<='0'; --returnDisable<='0'
--     --Execute Signals--     ALU_Src<='0';--     RegDst<='0';--     InterruptforPCandF<='0';
--     AluSrcForStore<='0';--     RestoreFlags<='1';--    -RTISig<='1';5 
--WriteBack Signals--    MemtoReg<='0';
--    RegWrite<="0;--    --Flushing Signals--    F_Flush<='1';--    D_Flush<='0';
--    E_Flush<='0';--    MF_Flush<='0';
MemorySignals<="00000001101100";
ExecuteSignals<="110000";
WBSignals<="00";
FlushSignals<="0001";
end if;
end  process;   
END P_Controller;
