library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DZ is
port(
     clk_dz_1khz:in std_logic;
     row:out std_logic_vector(7 downto 0);
     col_r:out std_logic_vector(7 downto 0);
     col_g:out std_logic_vector(7 downto 0);
     onoff :in std_logic_vector(1 downto 0) );
end DZ;

architecture one of DZ is
signal tmp:integer range 0 to 7;
begin
process(clk_dz_1khz,onoff)
begin
   
if clk_dz_1khz'event and clk_dz_1khz='1'then
if tmp=7 then
tmp<=0;
else
tmp<=tmp+1;
end if;
end if;

if onoff = "00" then
case tmp is
when 0 => col_r <= "00000001";row <= "11111111";col_g <= "00000000";
when 1 => col_r <= "00000010";row <= "11111111";col_g <= "00000000";
when 2 => col_r <= "00000100";row <= "11111111";col_g <= "00000000";
when 3 => col_r <= "00001000";row <= "11111111";col_g <= "00000000";
when 4 => col_r <= "00010000";row <= "11111111";col_g <= "00000000";
when 5 => col_r <= "00100000";row <= "11111111";col_g <= "00000000";
when 6 => col_r <= "01000000";row <= "11111111";col_g <= "00000000";
when 7 => col_r <= "10000000";row <= "11111111";col_g <= "00000000";
when others => null;
end case;
end if;

if onoff = "01" then
case tmp is
when 0 => col_r <= "00000001";row <= "11111111";col_g <= "00000000";
when 1 => col_r <= "00000010";row <= "11111111";col_g <= "00000000";
when 2 => col_r <= "00000100";row <= "11110000";col_g <= "00000000";
when 3 => col_r <= "00001000";row <= "10000000";col_g <= "00000000";
when 4 => col_r <= "00010000";row <= "10110000";col_g <= "00000000";
when 5 => col_r <= "00100000";row <= "10000000";col_g <= "00000000";
when 6 => col_r <= "01000000";row <= "11110000";col_g <= "00000000";
when 7 => col_r <= "10000000";row <= "11111111";col_g <= "00000000";
when others => null;
end case;
end if;
if onoff= "10" then
case tmp is
when 0 => col_g <= "00000001";row <= "11111111";col_r <= "00000000";
when 1 => col_g <= "00000010";row <= "10001111";col_r <= "00000000";
when 2 => col_g <= "00000100";row <= "10110000";col_r <= "00000000";
when 3 => col_g <= "00001000";row <= "10000000";col_r <= "00000000";
when 4 => col_g <= "00010000";row <= "11110000";col_r <= "00000000";
when 5 => col_g <= "00100000";row <= "11110000";col_r <= "00000000";
when 6 => col_g <= "01000000";row <= "11110000";col_r <= "00000000";
when 7 => col_g <= "10000000";row <= "11111111";col_r <= "00000000";
when others => null;
end case;
end if;
end process;
END one;