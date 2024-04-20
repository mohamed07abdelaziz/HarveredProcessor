library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WriteBack is
  port (
    clk,rst,Enable: in std_logic;
mBlock:in std_logic_vector (11 downto 0);
wbBlock:in std_logic_vector (4 downto 0);
memoryDataIn: in std_logic_vector (63 downto 0);
aluDataIn: in std_logic_vector (63 downto 0);
writeAddress: in std_logic_vector (5 downto 0);
I_pc_in:in std_logic;

------------------------------------------------

writeAddress1: out std_logic_vector(2 downto 0);
writeAddress2: out std_logic_vector(2 downto 0);
SPScr: out std_logic;
Restore_Flag: out std_logic;
Return_signal: out std_logic;
Swap_signal: out std_logic;
Enable_outport: out std_logic;
reg_write: out std_logic_vector (1 downto 0);
I_pc_out:out std_logic;
output_to_reg1: out std_logic_vector (31 downto 0);
output_to_reg2: out std_logic_vector (31 downto 0)
  ) ;
end WriteBack;
architecture archOFWriteBackMux of WriteBack is

component mux2 is 
GENERIC (n: integer:= 64);
port(	
	in1,in2: in std_logic_vector(n - 1 downto 0);
	out1 : out std_logic_vector(n - 1 downto 0);
	sel : in std_logic
);

end component;
signal signalout_Mux: std_logic_vector(63 downto 0);
begin
 writeAddress1 <= writeAddress(5 downto 3);
  writeAddress2 <= writeAddress(2 downto 0);
SPScr<=mBlock(7);
Restore_Flag <= mBlock(9);
Return_signal <= mBlock(6);
Swap_signal <= mBlock(8);
Enable_outport <= wbBlock(3);
reg_write <= wbBlock (2) & wbBlock (1);

I_pc_out <=I_pc_in;

mem_to_reg_Mux: mux2 generic map(64) port map(aluDataIn,memoryDataIn,signalout_Mux,wbBlock(4));
output_to_reg1 <= signalout_Mux(63 downto 32);
output_to_reg2 <= signalout_Mux (31 downto 0);
end archOFWriteBackMux ; 