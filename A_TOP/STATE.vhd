library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.STRUCT.all;
entity STATE is
port(
			clk: in std_logic;
			clear: in std_logic;
			clk_1hz: in std_logic;
			sysadmin: in std_logic;
			data_key:in std_logic_vector(4 downto 0);
			data_menuled: out std_logic_vector(6 downto 0);                                       --ismenu
			data_beep: out std_logic;										--isbeep
			data_dz: out std_logic_vector(1 downto 0);                   --islock
			data_smg:out smg_eight;                                       --issmg
			data_lcd:out moment;                                           --now_time
			data_lcd0:out moment;                                         --rec_time
			data_lcd0ready:out std_logic                                  --islcd
);
end STATE;
architecture behavioral of STATE is
signal  state:all_state :=MENU;                                                                          --��ǰ״̬��״̬

signal  four_cipher:four_cipher_six:=((1,1,1,1,1,1),(2,2,2,2,2,2),(3,3,3,3,3,3),(4,4,4,4,4,4));	--�洢4���û�������nine_cipher(1)(1)<=1��
signal  four_cipher_lenth:four_cipher_len:=(4,4,4,4);											 --�洢4���û������볤��
signal  three_recording:three_moment;															 --�洢3����¼   ten_recording(1)<=(0,0,1);

signal  num_recording:INTEGER RANGE 0 TO 5 :=0;                                                        --��ǰ��¼����
signal  num_user:INTEGER RANGE 0 TO 4 :=2;                                                              --��ǰ�û�����
signal  num_input:INTEGER RANGE 0 TO 6 :=0;                                                             --��ǰ������������
signal  now_user:INTEGER RANGE 0 TO 4 :=1;                                                              --��¼��ǰ�û�����
signal  now_recording:INTEGER RANGE 0 TO 5 :=0;                                                         --��¼��ǰ��ʾ��¼���
signal  now_input:cipher_six;	   --��ǰ�û������������
signal  now_time: moment:=(0,0,0);																	    --��¼��ǰʱ��   now_time<=(0,0,1);
signal  rec_time: moment:=(0,0,0);
signal  issmg:smg_eight:=(10,10,10,10,10,10,10,10);                                                          --��ǰ����ܵ���ʾ����
signal  ismenu:std_logic_vector(6 downto 0):= "0100000";                                                   --��ǰ�Ƿ���menu״̬
signal  islock:std_logic_vector(1 downto 0) := "01";                                                     --��ǰ����״̬       ��dz���ź�
signal  isbeep:std_logic := '0';                                                           --��ǰ��������״̬    �����������ź�
signal  islcd:std_logic := '0';																	     --��ǰlcd״̬

begin

	data_menuled<=ismenu;
	data_beep <= isbeep;
	data_dz<=islock;
	data_smg<=issmg;
	data_lcd<=now_time;
	data_lcd0 <= rec_time;
	data_lcd0ready<=islcd;

	ptime:process(clk_1hz)
	variable h:INTEGER RANGE 0 TO 1;
	variable m:INTEGER RANGE 0 TO 59;
	variable s:INTEGER RANGE 0 TO 59;
	begin
	if clear = '1' then 
			s:=0;
			m:=0;
			h:=0;
		elsif clk_1hz'event and clk_1hz='1'then
				if s=59 then 
					s := 0;
					if m=59 then 
						m:=0;
						if h=1 then
							h:=0;
						else
							h:=h+1;
						end if;
					else
						m:= m+1;
					end if;
				else
					s := s+1;
				end if;				
		end if;
		now_time<=(h,m,s);				
	end process ;
	pmenu:process(clk,state)
	begin
	if clear = '1' then 
		 ismenu<="1111111";
	else
		CASE state IS 
		WHEN ADMIN=> ismenu<="1000000";
		WHEN MENU=> ismenu<="0100000";
		WHEN CHOOSE_USER=> ismenu<="0010000";
		WHEN ADD_CIPHER=> ismenu<="0001000";
		WHEN CHANGE_CIPHER=> ismenu<="0000100";
		WHEN INPUT_CIPHER=> ismenu<="0000010";
		WHEN SHOW_RECORD=> ismenu<="0000001";		
		end case;
	end if;
	end process ;
	psmg:process(clk,num_input,num_user,now_input,now_user,state)
	begin
	if clear = '1' then 
			issmg(1)<=10;issmg(2)<=10;issmg(3)<=10;issmg(4)<=10;
			issmg(5)<=10;issmg(6)<=10;issmg(7)<=10;issmg(8)<=10;
	else 
		CASE state IS
		WHEN MENU => 
			issmg(1)<=10;issmg(2)<=10;issmg(3)<=10;issmg(4)<=10;
			issmg(5)<=10;issmg(6)<=10;issmg(7)<=10;issmg(8)<=10;
		WHEN SHOW_RECORD => 
			issmg(1)<=num_recording;issmg(2)<=now_recording;issmg(3)<=10;issmg(4)<=10;
			issmg(5)<=10;issmg(6)<=10;issmg(7)<=10;issmg(8)<=10;
		WHEN CHOOSE_USER => 
			issmg(1)<=num_user;issmg(2)<=10;issmg(3)<=10;issmg(4)<=10;
			issmg(5)<=10;issmg(6)<=10;issmg(7)<=10;issmg(8)<=10;
		WHEN INPUT_CIPHER =>
			issmg(1)<=num_user;issmg(2)<=now_user;
			case num_input is
				when 0 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=10;issmg(8)<=10;
			when 1 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=10;issmg(8)<=11;
			when 2 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=11;issmg(8)<=11;
			when 3 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=11;issmg(7)<=11;issmg(8)<=11;
			when 4 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=11;
				issmg(6)<=11;issmg(7)<=11;issmg(8)<=11;
			when 5 =>
				issmg(3)<=10;issmg(4)<=11;issmg(5)<=11;
				issmg(6)<=11;issmg(7)<=11;issmg(8)<=11;
			when 6 =>
				issmg(3)<=11;issmg(4)<=11;issmg(5)<=11;
				issmg(6)<=11;issmg(7)<=11;issmg(8)<=11;
			when others => NULL;
			END case;
		WHEN ADD_CIPHER =>
			issmg(1)<=num_user;issmg(2)<=10;
			case num_input is
			when 0 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=10;issmg(8)<=10;
			when 1 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=10;issmg(8)<=now_input(1);
			when 2 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=now_input(1);issmg(8)<=now_input(2);
			when 3 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=now_input(1);issmg(7)<=now_input(2);issmg(8)<=now_input(3);
			when 4 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=now_input(1);
				issmg(6)<=now_input(2);issmg(7)<=now_input(3);issmg(8)<=now_input(4);
			when 5 =>
				issmg(3)<=10;issmg(4)<=now_input(1);issmg(5)<=now_input(2);
				issmg(6)<=now_input(3);issmg(7)<=now_input(4);issmg(8)<=now_input(5);
			when 6 =>
				issmg(3)<=now_input(1);issmg(4)<=now_input(2);issmg(5)<=now_input(3);
				issmg(6)<=now_input(4);issmg(7)<=now_input(5);issmg(8)<=now_input(6);
			when others => NULL;
			END case;
		WHEN CHANGE_CIPHER =>
			issmg(1)<=num_user;issmg(2)<=now_user;
			case num_input is
			when 0 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=10;issmg(8)<=10;
			when 1 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=10;issmg(8)<=now_input(1);
			when 2 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=10;issmg(7)<=now_input(1);issmg(8)<=now_input(2);
			when 3 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
				issmg(6)<=now_input(1);issmg(7)<=now_input(2);issmg(8)<=now_input(3);
			when 4 =>
				issmg(3)<=10;issmg(4)<=10;issmg(5)<=now_input(1);
				issmg(6)<=now_input(2);issmg(7)<=now_input(3);issmg(8)<=now_input(4);
			when 5 =>
				issmg(3)<=10;issmg(4)<=now_input(1);issmg(5)<=now_input(2);
				issmg(6)<=now_input(3);issmg(7)<=now_input(4);issmg(8)<=now_input(5);
			when 6 =>
				issmg(3)<=now_input(1);issmg(4)<=now_input(2);issmg(5)<=now_input(3);
				issmg(6)<=now_input(4);issmg(7)<=now_input(5);issmg(8)<=now_input(6);
			when others => NULL;
			END case;
		WHEN ADMIN =>
				issmg(1)<=num_user;issmg(2)<=now_user;
				case four_cipher_lenth(now_user) is
				when 1 =>
					issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
					issmg(6)<=10;issmg(7)<=10;issmg(8)<=four_cipher(now_user)(1);
				when 2 =>
					issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
					issmg(6)<=10;issmg(7)<=four_cipher(now_user)(1);issmg(8)<=four_cipher(now_user)(2);
				when 3 =>
					issmg(3)<=10;issmg(4)<=10;issmg(5)<=10;
					issmg(6)<=four_cipher(now_user)(1);issmg(7)<=four_cipher(now_user)(2);issmg(8)<=four_cipher(now_user)(3);
				when 4 =>
					issmg(3)<=10;issmg(4)<=10;issmg(5)<=four_cipher(now_user)(1);
					issmg(6)<=four_cipher(now_user)(2);issmg(7)<=four_cipher(now_user)(3);issmg(8)<=four_cipher(now_user)(4);
				when 5 =>
					issmg(3)<=10;issmg(4)<=four_cipher(now_user)(1);issmg(5)<=four_cipher(now_user)(2);
					issmg(6)<=four_cipher(now_user)(3);issmg(7)<=four_cipher(now_user)(4);issmg(8)<=four_cipher(now_user)(5);
				when 6 =>
					issmg(3)<=four_cipher(now_user)(1);issmg(4)<=four_cipher(now_user)(2);issmg(5)<=four_cipher(now_user)(3);
					issmg(6)<=four_cipher(now_user)(4);issmg(7)<=four_cipher(now_user)(5);issmg(8)<=four_cipher(now_user)(6);
				when others => NULL;
		END case;	
		WHEN OTHERS =>NULL;
		END CASE;
	end if;
	end process;

	pstate:process(data_key)
	variable  number_recording:INTEGER RANGE 0 TO 10 :=0;                             --��ǰ��¼����
	variable  number_user:INTEGER RANGE 0 TO 9 :=2;                    --��ǰ�û�����
	variable  number_input:INTEGER RANGE 0 TO 6 :=0; 								 --��ǰ��������
	variable  current_user:INTEGER RANGE 0 TO 9 :=1;                                  --��¼��ǰ�û�����
	variable  current_recording:INTEGER RANGE 0 TO 9 :=0;                      --��¼��ǰ��ʾ��¼���
	variable  current_input:cipher_six;	                                   --��ǰ�û������������
	variable  cnt:INTEGER RANGE 0 TO 199 ;
	variable  correct:INTEGER RANGE 0 TO 6 :=0;
    variable  key_value:key:=nothing;																					 --��ǰ����������
	begin
	if clear = '1' then 
		number_input:=0;
		number_user:=2;
		number_recording:=0;
		state<=MENU;

	elsif clk'event and clk='1' then
	key_value := return_keyvalue(data_key);
		---------beepģ��------------------
		if isbeep='1' then
			if cnt=199 then 
				cnt := 0;isbeep <= '0';
			else
				cnt := cnt+1;
			end if;
		end if;
		---------beepģ��------------------
		num_input<=number_input;
		num_user<=number_user;
		num_recording<=number_recording;
		now_input<=current_input;
		now_user<=current_user;
		now_recording<=current_recording;
			if sysadmin='1' then 
			state<=ADMIN;
			number_input:=0;
			--current_user:=1;

			End if;


	CASE state IS
		WHEN MENU => 
			CASE key_value IS
				WHEN choose => 
					islock<="01";
					state<=CHOOSE_USER;
				WHEN add => 
					islock<="01";
					if number_user=4 then 
					isbeep<='1';
					else 
					number_user:=number_user+1;
					current_user:=number_user;
					state<=ADD_CIPHER;
					end if;
				WHEN recording => 
					islock<="01";
					if number_recording=0 then 
					isbeep<='1';
					else 
					current_recording:=1;
					rec_time<=three_recording(current_recording);
					islcd<='1';
					state<=SHOW_RECORD;
					end if;				
				WHEN modify => 
					if islock="10" then 
					state<=CHANGE_CIPHER;
					else 
					isbeep<='1';
					end if;
				WHEN enter => 
					if islock="10" then 
						islock<="01";	                                 --���ѿ�������� enter����	
					else isbeep <= '1';
					end if;	
				when nothing => null;
				WHEN OTHERS    => islock<="01";isbeep <= '1';
			END CASE;
		WHEN CHOOSE_USER => 
			CASE key_value IS
			WHEN del => state<=MENU;
			WHEN one => 
				current_user := 1;
				state<=INPUT_CIPHER; 
			WHEN two => 
				current_user := 2;
				state<=INPUT_CIPHER; 
			WHEN three => 
				if number_user>2 then			
				current_user := 3;
				state<=INPUT_CIPHER;
				else 
				isbeep <= '1';
				state<=CHOOSE_USER;
				end if;
			WHEN four =>
				if number_user>3 then			
				current_user := 4;
				state<=INPUT_CIPHER;
				else 
				isbeep <= '1';
				state<=CHOOSE_USER;
				end if;
			when nothing|choose=> null;
			WHEN OTHERS => 
				isbeep <= '1';
				state<=CHOOSE_USER;
			END CASE;
		
		WHEN INPUT_CIPHER|CHANGE_CIPHER|ADD_CIPHER =>
			CASE key_value IS 
			WHEN del => 
				if number_input=0 then
					if state = ADD_CIPHER then 
						number_user:=number_user-1;
						current_user:=number_user;
					end if;
					state<=MENU;
				else				
					number_input := number_input - 1;
					
				end if;	                  

			WHEN one => 
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
					current_input(number_input+1):=1;
					number_input:=number_input+1;
				end if;

			WHEN two => 
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1) :=2;
				number_input:=number_input+1;
				end if;
					
			WHEN three => 
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1):=3;
				number_input:=number_input+1;
				end if;
			WHEN four =>
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1):=4;
				number_input:=number_input+1;
				end if;
			WHEN five =>
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1):=5;
				number_input:=number_input+1;
				end if;
			WHEN six => 
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1):=6;
				number_input:=number_input+1;
				end if;
			WHEN seven => 
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1):=7;
				number_input:=number_input+1;
				end if;
			WHEN eight => 
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1):=8;
				number_input:=number_input+1;
				end if;
			WHEN nine => 
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1):=9;
				number_input:=number_input+1;
				end if;
			WHEN zero => 
				if number_input=6 then
					number_input:= 0;
					isbeep <= '1';
				else 
				current_input(number_input+1):=0;
				number_input:=number_input+1;
				end if;
			WHEN enter => 
					if state=INPUT_CIPHER then
						if current_input(1) = four_cipher(current_user)(1) then 
							correct:=1;
							if current_input(2) = four_cipher(current_user)(2) then
								correct:=2;
								if current_input(3) = four_cipher(current_user)(3) then
									correct:=3;
									if current_input(4) = four_cipher(current_user)(4) then 
										correct:=4;
										if current_input(5) = four_cipher(current_user)(5) then
											correct:=5;
											if current_input(6) = four_cipher(current_user)(6) then
												correct:=6;
											end if;
										end if;
									end if;
								end if;
							end if;
						end if;

						if correct>=number_input and number_input=four_cipher_lenth(current_user) then               ------?????bug
						islock<="10";
							correct:=0;
						if number_recording<5 then
							three_recording(number_recording+1)<=(current_user,now_time.minu,now_time.seco);      --i take a nop
							number_recording:=number_recording+1;						
						end if;
						number_input:=0;
						state<=MENU;
						else 
						isbeep<='1';
						number_input:=0;
						end if;
					else 
					    if number_input /= 0 then
						four_cipher_lenth(current_user)<=number_input;
						four_cipher(current_user)<=current_input;				
						end if;
						number_input:=0;
						state<=MENU;
					end if;
			WHEN nothing => null; 
			WHEN OTHERS => 
				isbeep<='1';
				number_input:=0;
			END CASE;
		WHEN SHOW_RECORD => 
			CASE key_value IS
			WHEN del => state<=MENU;islcd<='0';                               --??????????????
			WHEN recording =>
				if current_recording<number_recording then
					current_recording := current_recording+1;
				else
					current_recording:=1;
				end if;
				rec_time<=three_recording(current_recording);
			when nothing => null;
			WHEN OTHERS =>
				isbeep<='1';--beep
			END CASE;

		WHEN ADMIN => 
		IF sysadmin='0' then 
			state<=MENU;
		else
			CASE key_value IS
			when enter =>
					if current_user = number_user then
						current_user:=1;
					else 
					current_user:=current_user+1;
					end if;
			WHEN del => 
					case current_user is 
						when 1 => isbeep<='1';
						when 2 => isbeep<='1';
						when 3 => 
								if number_user=4 then
									four_cipher_lenth(3)<=four_cipher_lenth(4);
									four_cipher(3)<=four_cipher(4);	
									number_user:=number_user-1;
									current_user:=number_user;
								else number_user:=number_user-1;
								current_user:=number_user;
								end if;
						when 4 => number_user:=number_user-1;
						current_user:=number_user;
						when others=> null;
						end case;
			when nothing => null;
			WHEN OTHERS =>
				isbeep<='1';--beep
			END CASE;
		end if;
		WHEN OTHERS    => null;
		END CASE;
	end if;
	end process ;
end behavioral;