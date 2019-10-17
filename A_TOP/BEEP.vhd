library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity BEEP is
port(
	clk_beep_1khz: in std_logic;                       
	onoff: in std_logic ;            
	spks: out std_logic;
	led:  out std_logic);
end BEEP;
architecture behavioral of BEEP is
signal  spks1:std_logic;
begin
spks <= spks1;
	process(clk_beep_1khz,onoff)
	begin
	if onoff = '1' then
	led <='1';
	if clk_beep_1khz'event and clk_beep_1khz ='1' then
		if spks1 = '1' then
			spks1<='0';
		else
			spks1<='1';
	   end if;
	end if;
	else
	spks1<='0';
	led<='0';
	end if;
	end process ;
end behavioral;
