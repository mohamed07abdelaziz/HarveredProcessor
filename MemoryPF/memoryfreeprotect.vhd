library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity memoryfreeprotect is
  generic (bits : integer := 1);
  port (
    clk, Rst, writeEN, readEN     : in  std_logic;
    readaddress                   : in  std_logic_vector(31 downto 0);
    writeport                     : in  std_logic_vector(bits - 1 downto 0);
    readport                      : out std_logic_vector(bits - 1 downto 0);
    zero_flag, branch, conduncond : in  std_logic_vector(0 downto 0);
    output_branch                 : out std_logic
  );

end entity;

architecture rtl of memoryfreeprotect is
  type ram_type is array (0 to 2048) of std_logic_vector(bits - 1 downto 0);
  signal ram : ram_type;
  component myand is
    port (
      A : in  std_logic;
      B : in  std_logic;
      C : out std_logic
    );
  end component;
  --Mux2x1--
  component Mux2x1 is
    generic (n : integer := 32);
    port (A, B : in  std_logic_vector(n - 1 downto 0) := (others => '0');
          S    : in  std_logic;
          F    : out std_logic_vector(n - 1 downto 0) := (others => '0'));
  end component;
  --Mux2x1--
  signal onebit, out_mux2 : std_logic_vector(0 downto 0);
  signal readadd: integer;
  signal rm :integer:=2048;
  signal allones          : std_logic_vector(12 - 1 downto 0) := (others => '1');
  signal allzeros         : std_logic_vector(22 - 1 downto 0) := (others => '0');
begin
  onebit(0) <= '1';
  
  mux2: Mux2x1 generic map (1) port map (A => zero_flag(0 downto 0), B => onebit(0 downto 0), S => conduncond(0), F => out_mux2(0 downto 0));
  And_branch: myand port map (A => branch(0), B => out_mux2(0), C => output_branch);

  process (clk, Rst, readEN, writeEN, readaddress) is
  begin
    if (Rst = '1') then
      ram <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if writeEN = '1' then
        if (readaddress < allzeros & allones) then
          ram(to_integer(unsigned(readaddress))) <= writeport;
        end if;
       
      end if;
    end if;
    if readEN = '1' then
      if (readaddress < allzeros & allones) then
        readport <= ram(to_integer(unsigned(readaddress)));
      else
        readport(0) <= '0';
      end if;
    else
      readport(0) <= '0';
    end if;
  end process;
end architecture;
