LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Control_H_Unit IS
	PORT(

		clk,rst,Outbranchforbitpredictor,Branch_Sig_Exec,predictionout_mem,Branch_sig_Mem: IN  std_logic;
		Andgateprediction,and_bet_xorout_outbranch ,and_bet_xorout_notoutbranch : OUT std_logic
);
END ENTITY Control_H_Unit;

ARCHITECTURE Control_H_UnitP OF Control_H_Unit IS
  TYPE ramType IS ARRAY(0 DOWNTO 0) OF STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL ram : ramType;
Component my_DFF IS
	PORT( 	d,clk,rst : IN std_logic;
			q : OUT std_logic;
we:IN std_logic);
END Component;

 Signal bitpredictor,outbranch:std_logic_vector(0 downto 0);
Signal We,inand_bet_xorout_outbranch,inand_bet_xorout_notoutbranch:std_logic;
	BEGIN
R1:my_DFF port map(inand_bet_xorout_outbranch,clk,rst,and_bet_xorout_outbranch,'1');
R2:my_DFF port map(inand_bet_xorout_notoutbranch,clk,rst,and_bet_xorout_notoutbranch,'1');

outbranch(0)<=Outbranchforbitpredictor; 
bitpredictor<=ram(0);
We<= (bitpredictor(0) xor Outbranchforbitpredictor) and Branch_sig_Mem;

Andgateprediction<=bitpredictor(0) and '0' when Branch_Sig_Exec='U'
else bitpredictor(0) and Branch_Sig_Exec;

inand_bet_xorout_outbranch<= predictionout_mem xor  Outbranchforbitpredictor;
inand_bet_xorout_notoutbranch<=Outbranchforbitpredictor and (not predictionout_mem);
 PROCESS (clk,rst)
    BEGIN
              If(rst='1') then
                     ram(0)<="1"; 
            elsIF (rising_edge(clk)) THEN
                IF We = '1'    THEN
                    ram(0)<=outbranch; 
            END IF;
        END IF;
    END PROCESS;
        END Control_H_UnitP;

