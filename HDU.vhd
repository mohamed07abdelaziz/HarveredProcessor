--includes
library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity HDU is
  port (
    Rsource1, Rsource2, Rdst : in  STD_LOGIC_VECTOR(2 downto 0);
    stop_enable_signale      : out STD_LOGIC;
    return_enable,loaduse            : out STD_LOGIC;
    clk,rst, mem_read, reg_write : in  STD_LOGIC
  );
end entity;

architecture HDUunit of HDU is
Component my_DFF IS
	PORT( 	d,clk,rst : IN std_logic;
			q : OUT std_logic;
we:IN std_logic);
END Component;
signal ret  : std_logic;
signal stops  : std_logic;
BEGIN
 Reg:my_DFF generic map(1)port map(stops,clk,rst,ret,'1');
  stops <= '1' when mem_read = '1' and reg_write = '1' and (Rsource1 = Rdst or Rsource2 = Rdst)  else
           '0';  
  loaduse<='1' when stops='1' or ret='1'
 else '0';
  stop_enable_signale<=stops;
  return_enable<=ret;
end architecture;
