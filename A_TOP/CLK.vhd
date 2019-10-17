library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity CLKD is
port(
	clk1:in std_logic;
	clear:in std_logic;
	clk_1hz:out std_logic;
	clk_1khz:out std_logic
	 );
end;
architecture a of CLKD is 
signal cnt1,cnt2:integer range 0 to 500;
signal clk_1k,clk_1:std_logic;
begin 
clk_1khz<=clk_1k;
clk_1hz<=clk_1;
	p1:process(clk1,clear)
	begin
		if clear = '1' then 
			cnt1<=0;
		elsif clk1'event and clk1='1'then
			if cnt1=499 then 
				cnt1 <= 0;clk_1k <= not clk_1k;
			else
				cnt1 <= cnt1+1;
			end if;
		end if;
	end process p1;
		p2:process(clk_1k,clear)
	begin
		if clear = '1' then 
			cnt2<=0;
		elsif clk_1k'event and clk_1k='1'then
			if cnt2=499 then 
				cnt2 <= 0;clk_1 <= not clk_1;
			else
				cnt2 <= cnt2+1;
			end if;
		end if;
	end process p2;

end a;