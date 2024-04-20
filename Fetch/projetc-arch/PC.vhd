library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity pc_unit is
  generic (bits : integer := 32);
  port (clk, enable, rst : in  STD_LOGIC;
     O_PC_OLD   : out STD_LOGIC_VECTOR(bits - 1 downto 0);
        Reset_PC_value          : in  STD_LOGIC_VECTOR(bits - 1 downto 0);
        current_pc : in std_logic_vector(bits - 1 downto 0);
    current_pc_out : out std_logic_vector(bits - 1 downto 0)
       );
end entity;

architecture Behavioral of pc_unit is

  signal allones    : std_logic_vector(bits - 1 downto 0) := (others => '1');
signal kj: std_logic_vector(bits - 1 downto 0) := (others => '1');
  
begin
  process (clk) is
    variable current:std_logic_vector(bits - 1 downto 0) := (others => '1');
  begin
    if (rst = '1') then
      O_PC_OLD <= Reset_PC_value;
      current:=Reset_PC_value;
      current := std_logic_vector(unsigned(current) + 1);
      current_pc_out<=current;

    elsif rising_edge(clk) and enable = '1' then
      if (current_pc = allones) then
        current_pc_out <= (others => '0');
      else
        current:=current_pc;
        O_PC_OLD <= current_pc;
        current := std_logic_vector(unsigned(current) + 1);
        current_pc_out<=current;
      end if;

    end if;
  end process;

end architecture;