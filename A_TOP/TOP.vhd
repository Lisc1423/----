LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.STRUCT.ALL;
ENTITY TOP IS
PORT(
clk :in std_logic;
clear:in std_logic;
systemadmin: in std_logic;
keyrow_in:in std_logic_vector(3 downto 0);
keycol_out:out std_logic_vector(3 downto 0);
beep_out:out STD_LOGIC;
beep_led:out STD_LOGIC;
menuled_out:out STD_LOGIC_vector(6 downto 0);
smgdata_out:out STD_LOGIC_vector(6 downto 0);
smgcat_out:out STD_LOGIC_vector(7 downto 0);
dzrow_out:out std_logic_vector(7 downto 0);
dzcolred_out:out std_logic_vector(7 downto 0);
dzcolgre_out:out std_logic_vector(7 downto 0);
RW_out,E_out,RS_out:out std_logic;      
lcd_out:out std_logic_vector(7 downto 0)
);
end TOP;

ARCHITECTURE a_top OF TOP IS
component SMG
PORT(
clk_smg_1khz : in std_logic;                   
a: in smg_eight;
b: out STD_LOGIC_VECTOR (6 downto 0);
c: out STD_LOGIC_VECTOR (7 downto 0)
);
end component;

component DZ
port(
clk_dz_1khz:in std_logic;
clk_1hz:in std_logic;
row:out std_logic_vector(7 downto 0);
col_r:out std_logic_vector(7 downto 0);
col_g:out std_logic_vector(7 downto 0);
onoff :in std_logic_vector(1 downto 0) 
);
end component;

component BEEP
port(
clk_beep_1khz: in std_logic;                       
onoff: in std_logic ;            
spks: out std_logic;
led:  out std_logic
);
end component;

component LCD
PORT(
clk_lcd_1khz,clear:in std_logic;
onoff:in std_logic;
t1,t2:in moment;
RW,E,RS:out std_logic;      
data:out std_logic_vector(7 downto 0)
); 
end component;

component KEY
PORT(
inclk:in std_logic;                               --1M
inrow:in std_logic_vector(3 downto 0);
incol:out std_logic_vector(3 downto 0);
outshumaguan:out std_logic_vector(4 downto 0)
);
end component;

component CLKD
port(
clk1:in std_logic;
clear:in std_logic;
clk_1hz:out std_logic;
clk_1khz:out std_logic
);
end component;

component STATE
port(
clk: in std_logic;
clear: in std_logic;
clk_1hz: in std_logic;
sysadmin: in std_logic;
data_key:in std_logic_vector(4 downto 0);
data_menuled: out std_logic_vector(6 downto 0);
data_beep: out std_logic;
data_dz: out std_logic_vector(1 downto 0);
data_smg:out smg_eight;
data_lcd:out moment;
data_lcd0:out moment;
data_lcd0ready:out std_logic
);
end component;

SIGNAL top_1mhz:std_logic;
SIGNAL top_1khz:std_logic;
SIGNAL top_1hz:std_logic;

SIGNAL top_smg:smg_eight;
SIGNAL top_smgcat:std_logic_vector(7 downto 0);
SIGNAL top_smgdata:std_logic_vector(6 downto 0);

SIGNAL top_dzonoff:std_logic_vector(1 downto 0);
SIGNAL top_dzrow:std_logic_vector(7 downto 0);
SIGNAL top_dzcolr:std_logic_vector(7 downto 0);
SIGNAL top_dzcolg:std_logic_vector(7 downto 0);

SIGNAL top_beeponoff:std_logic;
SIGNAL top_beepspks:std_logic;
SIGNAL top_beepled:std_logic;

SIGNAL top_lcdonoff:std_logic;
SIGNAL top_lcdtime:moment;
SIGNAL top_lcdtime0:moment;
SIGNAL top_lcdrw:std_logic;
SIGNAL top_lcde:std_logic;
SIGNAL top_lcdrs:std_logic;
SIGNAL top_lcddata:std_logic_vector(7 downto 0);

SIGNAL top_keyrow:std_logic_vector(3 downto 0);
SIGNAL top_keycol:std_logic_vector(3 downto 0);
SIGNAL top_keydata:std_logic_vector(4 downto 0);

SIGNAL top_menuled:std_logic_vector(6 downto 0);
SIGNAL top_clear:std_logic;

BEGIN
top_1mhz<=clk;
top_clear<=clear;
top_keyrow<=keyrow_in;
keycol_out<=top_keycol;
beep_out<=top_beepspks;
beep_led<=top_beepled;
menuled_out<=top_menuled;
smgdata_out<=top_smgdata;
smgcat_out<=top_smgcat;
dzrow_out<=top_dzrow;
dzcolred_out<=top_dzcolr;
dzcolgre_out<=top_dzcolg;
RW_out<=top_lcdrw;
E_out<=top_lcde;
RS_out<=top_lcdrs;
lcd_out<=top_lcddata;

	u1:SMG   port map(clk_smg_1khz=>top_1khz, a=>top_smg, b=>top_smgdata, c=>top_smgcat);
	u2:DZ    port map(clk_dz_1khz=>top_1khz,clk_1hz=>top_1hz, row=>top_dzrow,col_r=>top_dzcolr,col_g=>top_dzcolg,onoff=>top_dzonoff);
	u3:BEEP  port map(clk_beep_1khz=>top_1khz,onoff=>top_beeponoff,spks=>top_beepspks,led=>top_beepled);
	u4:LCD   port map(clk_lcd_1khz=>top_1khz,clear=>top_clear,onoff=>top_lcdonoff,t1=>top_lcdtime,t2=>top_lcdtime0,RW=>top_lcdrw,E=>top_lcde,RS=>top_lcdrs,data=>top_lcddata);
	u5:KEY   port map(inclk=>top_1khz, inrow=>top_keyrow,incol=>top_keycol,outshumaguan=>top_keydata);
	u6:CLKD  port map(clk1=>top_1mhz,clear=>top_clear,clk_1hz=>top_1hz, clk_1khz=>top_1khz);
	u7:STATE port map(clk=>top_1khz,clear=>top_clear,clk_1hz=>top_1hz,sysadmin=>systemadmin,data_key=>top_keydata,data_menuled=>top_menuled,data_beep=>top_beeponoff,data_dz=>top_dzonoff,data_smg=>top_smg,data_lcd=>top_lcdtime,data_lcd0=>top_lcdtime0,data_lcd0ready=>top_lcdonoff);
END a_top;