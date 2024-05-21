--includes
Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Fetch_piplined is
port (
  clk,Reset,Enable,Interupt,flushing_for_jump : in std_logic;
  PC_plus_one: in std_logic_vector(31 downto 0);
  DFF_out: out std_logic_vector(80 downto 0);
  PC_old: in std_logic_vector(31 downto 0);
  Instruction: in std_logic_vector(15 downto 0);
  flush_imediate: in std_logic
);
end entity;
Architecture fetch of Fetch_piplined is
Component my_nDFF IS
	GENERIC ( n : integer := 12);
	PORT(	Clk,Rst : IN std_logic;
		d : IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0);
                we: IN std_logic);
END Component;

signal rst: std_logic;
signal DFF_in:  std_logic_vector(80 downto 0);
begin
  rst<='1' when flushing_for_jump='1'or flush_imediate='1'
else Reset ;

  DFF_in<=PC_plus_one&Instruction&Interupt&PC_old;--8049483332310
allout:  my_nDFF  GENERIC MAP (81) port MAP(Clk=>Clk,Rst=>rst,d=>DFF_in,q=>DFF_out,we=>Enable);
end architecture;