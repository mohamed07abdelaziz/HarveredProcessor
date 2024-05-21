--includes
library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity FETCH_STAGE is
  port (
    clk, reset, enable                                                                                                                      : in  std_logic;
    Protected_signal, overflow_signal, excution_predict, branch_predict, interuppt_signal, return_signal, selection, return_selection, I_PC : in  std_logic := '0';
    PC_RESET_VALUE, JMP_LABEL, WRITE_REG_1, ADDRESS_EXP_HANDLER, Jmp_label_Exec, PCplusfrommem                                              : in  std_logic_vector(31 downto 0);
    instruction                                                                                                                             : out std_logic_vector(15 downto 0);
    PC_plus, PCold                                                                                                                          : out std_logic_vector(31 downto 0)
  );
end entity;

architecture fetch_stage of FETCH_STAGE is
  --Mux4x2--
  component mux4 is
    generic (n : Integer := 16);
    port (in0, in1, in2, in3 : in  std_logic_vector(n - 1 downto 0);
          sel                : in  std_logic_vector(1 downto 0);
          out1               : out std_logic_vector(n - 1 downto 0));
  end component;
  --Mux4x2--
  --Mux2x1--
  component Mux2x1 is
    port (A, B : in  std_logic_vector(31 downto 0);
          S    : in  std_logic;
          F    : out std_logic_vector(31 downto 0));
  end component;
  --Mux2x1--
  --PC--
  component pc_unit is
    generic (bits : integer := 32);
    port (clk, enable, rst, interrupt        : in  STD_LOGIC;
          O_PC_OLD                           : out STD_LOGIC_VECTOR(bits - 1 downto 0);
          Reset_PC_value, Interrupt_PC_value : in  STD_LOGIC_VECTOR(bits - 1 downto 0);
          current_pc                         : in  std_logic_vector(bits - 1 downto 0);
          current_pc_out                     : out std_logic_vector(bits - 1 downto 0)
         );
  end component;
  --PC--
  --instructioncache--
  component instructioncache is
    generic (bits : integer := 16);
    port (
      clk, Rst, EN               : in  std_logic;
      readaddress                : in  std_logic_vector(31 downto 0);
      datain                     : in  std_logic_vector(bits - 1 downto 0);
      instructionport            : out std_logic_vector(bits - 1 downto 0);
      resetvalue, Interruptvalue : out std_logic_vector(31 downto 0)
    );

  end component;
  --instructioncache--
  --nor_gate--
  component mynor is
    port (
      A : in  std_logic;
      B : in  std_logic;
      C : out std_logic
    );
  end component;
  --nor_gate--
  --or_gate--
  component myor is
    port (
      A : in  std_logic;
      B : in  std_logic;
      C : out std_logic
    );
  end component;
  --or_gate--
  signal out_nor, out_or, exception_out, sig                                                : std_logic;
  signal select_mux41, select_mux42                                                         : std_logic_vector(1 downto 0);
  signal out_mux2, out_mux41, addres_2, out_mux42, out_current_address, PC_plus_one, PC_old : std_logic_vector(31 downto 0);
  signal datain                                                                             : std_logic_vector(15 downto 0);
  signal resetvalue, Interruptvalue, outjmp                                                 : std_logic_vector(31 downto 0);
begin
  addres_2 <= x"00000002";

  Enable_PC: mynor port map (A => interuppt_signal, B => return_signal, C => out_nor);
  Bit_predict: myor port map (A => excution_predict, B => branch_predict, C => out_or);
  Exception: myor port map (A => overflow_signal, B => Protected_signal, C => exception_out);
  select_mux41 <= return_selection & out_or;
  select_mux42 <= exception_out & I_PC;
  sig          <= enable and out_nor;
  instruction_cache: instructioncache port map (clk => clk, Rst => reset, EN => '0', readaddress => PC_old, datain => datain, instructionport => instruction, resetvalue => resetvalue, Interruptvalue => Interruptvalue);
  PC: pc_unit
    port map (clk => clk, enable => sig, rst => reset, interrupt => interuppt_signal,
              O_PC_OLD => PC_old,
              Reset_PC_value => resetvalue, Interrupt_PC_value => Interruptvalue, current_pc => out_mux42, current_pc_out => PC_plus_one);
  PCold   <= PC_old;
  PC_plus <= PC_plus_one;
  MUX1_PCOROLD: Mux2x1 port map (A => PC_plus_one, B => PCplusfrommem, S => selection, F => out_mux2);
  MUX2_PC_JMP: mux4 generic map (32) port map (in0 => out_mux2, in1 => outjmp, in2 => WRITE_REG_1, in3 => (others => '0'), sel => select_mux41, out1 => out_mux41);
  MUX3_exception: mux4 generic map (32) port map (in0 => out_mux41, in1 => addres_2, in2 => ADDRESS_EXP_HANDLER, in3 => WRITE_REG_1, sel => select_mux42, out1 => out_mux42);
  Mux_Branchfromexec_or_Branchfrommem: Mux2x1 port map (JMP_LABEL, Jmp_label_Exec, branch_predict, outjmp);

end architecture;
