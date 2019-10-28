library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DZ is
port(clk_dz_1khz:in std_logic;
clk_1hz:in std_logic;
row:out std_logic_vector(7 downto 0);
col_r:out std_logic_vector(7 downto 0);
col_g:out std_logic_vector(7 downto 0);
onoff :in std_logic_vector(1 downto 0)  );
end DZ;

architecture one of DZ is
signal tmp:integer range 0 to 7;
signal p_cnt:integer range 0 to 3;
signal c_cnt:integer range 0 to 3;
begin

p1:process(clk_1hz)
begin
	if(clk_1hz'event and clk_1hz = '1')then
		if(onoff = "01")then
			c_cnt <= 0;
			if(p_cnt < 3)then
				p_cnt <= p_cnt + 1;
			end if;
		elsif(onoff = "10")then
			p_cnt <= 0;
			if(c_cnt < 3)then
				c_cnt <= c_cnt + 1;
			end if;
		end if;
	end if;
end process;

p2:process(clk_dz_1khz,onoff)
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

if  p_cnt = 1 then
case tmp is
when 0 => col_r <= "01111100";row <= "11111110";col_g <= "00000000";
when 1 => col_r <= "01111100";row <= "11111101";col_g <= "00000000";
when 2 => col_r <= "01111100";row <= "11111011";col_g <= "00000000";
when 3 => col_r <= "01111100";row <= "11110111";col_g <= "00000000";
when 4 => col_r <= "00001000";row <= "11101111";col_g <= "00000000";
when 5 => col_r <= "00001000";row <= "11011111";col_g <= "00000000";
when 6 => col_r <= "00001000";row <= "10111111";col_g <= "00000000";
when 7 => col_r <= "00000000";row <= "01111111";col_g <= "00000000";
when others => null;
end case;
end if;
if  p_cnt = 2 then
case tmp is
when 0 => col_r <= "01111100";row <= "11111110";col_g <= "00000000";
when 1 => col_r <= "01111100";row <= "11111101";col_g <= "00000000";
when 2 => col_r <= "01111100";row <= "11111011";col_g <= "00000000";
when 3 => col_r <= "01111100";row <= "11110111";col_g <= "00000000";
when 4 => col_r <= "00001000";row <= "11101111";col_g <= "00000000";
when 5 => col_r <= "00001000";row <= "11011111";col_g <= "00000000";
when 6 => col_r <= "00111000";row <= "10111111";col_g <= "00000000";
when 7 => col_r <= "00000000";row <= "01111111";col_g <= "00000000";
when others => null;
end case;
end if;
if  p_cnt = 3 then
case tmp is
when 0 => col_r <= "01111100";row <= "11111110";col_g <= "00000000";
when 1 => col_r <= "01111100";row <= "11111101";col_g <= "00000000";
when 2 => col_r <= "01111100";row <= "11111011";col_g <= "00000000";
when 3 => col_r <= "01111100";row <= "11110111";col_g <= "00000000";
when 4 => col_r <= "00101000";row <= "11101111";col_g <= "00000000";
when 5 => col_r <= "00101000";row <= "11011111";col_g <= "00000000";
when 6 => col_r <= "00111000";row <= "10111111";col_g <= "00000000";
when 7 => col_r <= "00000000";row <= "01111111";col_g <= "00000000";
when others => null;
end case;
end if;
if  c_cnt = 1 then
case tmp is
when 0 => col_r <= "00000000";row <= "11111110";col_g <= "01111100";
when 1 => col_r <= "00000000";row <= "11111101";col_g <= "01111100";
when 2 => col_r <= "00000000";row <= "11111011";col_g <= "01111100";
when 3 => col_r <= "00000000";row <= "11110111";col_g <= "01111100";
when 4 => col_r <= "00000000";row <= "11101111";col_g <= "00001000";
when 5 => col_r <= "00000000";row <= "11011111";col_g <= "00001000";
when 6 => col_r <= "00000000";row <= "10111111";col_g <= "00111000";
when 7 => col_r <= "00000000";row <= "01111111";col_g <= "00000000";
when others => null;
end case;
end if;
if c_cnt = 2 then
case tmp is
when 0 => col_r <= "00000000";row <= "11111110";col_g <= "01111100";
when 1 => col_r <= "00000000";row <= "11111101";col_g <= "01111100";
when 2 => col_r <= "00000000";row <= "11111011";col_g <= "01111100";
when 3 => col_r <= "00000000";row <= "11110111";col_g <= "01111100";
when 4 => col_r <= "00000000";row <= "11101111";col_g <= "00001000";
when 5 => col_r <= "00000000";row <= "11011111";col_g <= "00001000";
when 6 => col_r <= "00000000";row <= "10111111";col_g <= "00001000";
when 7 => col_r <= "00000000";row <= "01111111";col_g <= "00000000";
when others => null;
end case;
end if;
if  c_cnt = 3 then
case tmp is
when 0 => col_r <= "00000000";row <= "11111110";col_g <= "01111100";
when 1 => col_r <= "00000000";row <= "11111101";col_g <= "01111100";
when 2 => col_r <= "00000000";row <= "11111011";col_g <= "01111100";
when 3 => col_r <= "00000000";row <= "11110111";col_g <= "01111100";
when 4 => col_r <= "00000000";row <= "11101111";col_g <= "00001000";
when 5 => col_r <= "00000000";row <= "11011111";col_g <= "00001010";
when 6 => col_r <= "00000000";row <= "10111111";col_g <= "00001110";
when 7 => col_r <= "00000000";row <= "01111111";col_g <= "00000000";
when others => null;
end case;
end if;
end process;
END one;