library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.numeric_std.all;

entity Interruptjmp is
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

end entity;

architecture Interruptjmpp of Interruptjmp  is
Component my_nDFF IS
	GENERIC ( n : integer := 12);
	PORT(	Clk,Rst : IN std_logic;
		d : IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0);
                we: IN std_logic);
END Component;
signal PC:std_logic_vector(31 downto 0);
Signal outbranch:std_logic_vector(0 downto 0);
begin
 D:  my_nDFF generic map(32) port map (Clk,Rst,PC,PCout,enable);
  -- z:  my_nDFF generic map(1) port map (Clk,Rst,outbranch,outputbranchxx,'1');
PC<=PC_jmp when (outputBranch='1' and  Andgateprediction='1') or (outputBranch='1' and  Andgateprediction='0')
else   PC_frommem when returnenable='1'
else PC_plus;
--outputbranchxx<='0' when outputBranch='1' and  interrupt_signal_Exec='1'
--else '1' when outputBranch='1'
--else '0';
outAndgateprediction<='0' when interrupt_signal_Decode='1'
else Andgateprediction ;
outxordecision<='0' when interrupt_signal_Mem='1'
else xordecision;
outandnotforuntakendecision<='0' when interrupt_signal_Mem='1'
else andnotforuntakendecision;
outreturnenable<='0' when  returnenable='1' and  interrupt_signal_Exec='1'
else '1' when returnenable='1'
else '0';
end architecture;
