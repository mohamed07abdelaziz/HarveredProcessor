library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity instructioncache is
  generic (bits : integer := 16);
  port (
    clk, Rst, EN    : in  std_logic;
    readaddress     : in  std_logic_vector(31 downto 0);
    datain          : in  std_logic_vector(bits - 1 downto 0);
    instructionport : out std_logic_vector(bits - 1 downto 0)
  );

end entity;

architecture rtl of instructioncache is
  type ram_type is array (0 to 1999) of std_logic_vector(bits - 1 downto 0);
  signal ram : ram_type;

begin
  process (clk, Rst) is
  begin
   if Rst='1' then 
  elsif rising_edge(clk) then
      if EN = '1' then
        ram(to_integer(unsigned(readaddress))) <= datain;
      end if;
    end if;
  end process;
  instructionport <= ram(to_integer(unsigned(readaddress)));
end architecture;