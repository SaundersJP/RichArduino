LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_UNSIGNED.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;
LIBRARY UNISIM ;
USE UNISIM.VCOMPONENTS.ALL ;


ENTITY HDMI_test IS
	PORT( clk		   : IN STD_LOGIC ;
			ena       	: IN  STD_LOGIC ;
         wea       	: IN  STD_LOGIC_VECTOR(0 DOWNTO 0) ;
			addra       : IN  STD_LOGIC_VECTOR(11 DOWNTO 0) ;
         dina        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			TMDSp 	   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			TMDSn 	   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			TMDSp_clock : OUT STD_LOGIC ;
			TMDSn_clock : OUT STD_LOGIC) ;
END HDMI_test ;

ARCHITECTURE structure OF HDMI_test IS

 COMPONENT TMDS_encoder
	PORT( clk 	: IN STD_LOGIC ;
			VD 	: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			CD 	: IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
			VDE 	: IN STD_LOGIC ;
			TMDS 	: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)) ;
 END COMPONENT ;
 
 COMPONENT 	my_char_rom
	PORT ( clka   :  	IN STD_LOGIC;
			 addra  :  	IN STD_LOGIC_VECTOR(13 DOWNTO 0);
          douta  :   OUT STD_LOGIC_VECTOR( 0 DOWNTO 0));			 
	END COMPONENT;
	
	COMPONENT 	my_text_ram
	PORT ( clka   :  	IN STD_LOGIC;
			 ena    :  	IN STD_LOGIC;
			 wea    :  	IN STD_LOGIC_VECTOR( 0 DOWNTO 0);
			 addra  :  	IN STD_LOGIC_VECTOR(11 DOWNTO 0);
          dina   :  	IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
			 clkb   :  	IN STD_LOGIC;
			 addrb  :  	IN STD_LOGIC_VECTOR(11 DOWNTO 0);
			 doutb  :  	OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
	END COMPONENT;
 
 SIGNAL addr_rom   : STD_LOGIC_VECTOR(13 DOWNTO 0) ;
 SIGNAL douta_rom  : STD_LOGIC_VECTOR(0 DOWNTO 0);
 SIGNAL addr_ram   : STD_LOGIC_VECTOR(11 DOWNTO 0);
 SIGNAL doutb_ram  : STD_LOGIC_VECTOR(7 DOWNTO 0);
 
 SIGNAL clk_TMDS : STD_LOGIC ;
 SIGNAL DCM_TMDS_CLKFX : STD_LOGIC ;
 SIGNAL CounterX : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
 SIGNAL CounterY : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
 SIGNAL hSync : STD_LOGIC ;
 SIGNAL vSync : STD_LOGIC ;
 SIGNAL DrawArea : STD_LOGIC ;
 SIGNAL red : STD_LOGIC_VECTOR(7 DOWNTO 0) ;
 SIGNAL green : STD_LOGIC_VECTOR(7 DOWNTO 0) ;
 SIGNAL blue : STD_LOGIC_VECTOR(7 DOWNTO 0) ;
 SIGNAL CD : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
 SIGNAL TMDS_red : STD_LOGIC_VECTOR(9 DOWNTO 0) ;
 SIGNAL TMDS_green : STD_LOGIC_VECTOR(9 DOWNTO 0) ;
 SIGNAL TMDS_blue : STD_LOGIC_VECTOR(9 DOWNTO 0) ;
 SIGNAL TMDS_mod10 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000" ; --- modulus 10 counter
 SIGNAL TMDS_shift_red : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
 SIGNAL TMDS_shift_green : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
 SIGNAL TMDS_shift_blue : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
 SIGNAL TMDS_shift_load : STD_LOGIC := '0' ;
  SIGNAL CounterXc : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
 SIGNAL CounterYc : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000" ;
 
 
BEGIN

 
 makesync:PROCESS(clk)
 begin
	 IF (clk = '1' AND clk'event) THEN
		 IF CounterX = 799 THEN
			 CounterX <= "0000000000" ;
			 IF CounterY = 524 THEN
				CounterY <= "0000000000" ;
	       ELSE
				CounterY <= CounterY + 1 ;
			 END IF ;
	    ELSE
	       CounterX <= CounterX + 1 ;
	    END IF ;
		 IF (CounterX < 640) AND (CounterY < 480) THEN
			DrawArea <= '1' ;
		 ELSE
			DrawArea <= '0' ;
		 END IF ;
		 IF (CounterX >= 656) AND (CounterX < 752) THEN
			hSync <= '1' ;
		 ELSE
			hSync <= '0' ;
		 END IF ;
		 IF (CounterY >= 490) AND (CounterY < 492) THEN
			vSync <= '1' ;
		 ELSE
			vSync <= '0' ;
		 END IF ;
	 END IF;
 END PROCESS makesync ;
 
 
 
 makepattern:PROCESS(clk) --- Not the same pattern!
 begin
	 IF (clk = '1' AND clk'event) THEN
		   red <= douta_rom(0 DOWNTO 0) & "0000000" ;
			green <= douta_rom(0 DOWNTO 0) &  "0000000" ;
			blue <= douta_rom(0 DOWNTO 0) &  "0000000" ;
	 END IF;
 END PROCESS makepattern ;
 
 myram1: my_text_ram
	PORT MAP(clka  => clk,
				ena   => ena,
				wea   => wea,
				addra => addra,
				dina  => dina,
				clkb  => clk,
				addrb => addr_ram,
				doutb => doutb_ram);
				
 myrom1: my_char_rom
	PORT MAP( clka => clk,
				 addra => addr_rom,
				 douta => douta_rom);
				 

 
 addr_ram <= CounterY(8 DOWNTO 4) & CounterX(9 DOWNTO 3);
 addr_rom <= doutb_ram(6 DOWNTO 0) & CounterY(3 downto 0) & (CounterX(2 downto 0)-1);
 
 encode_R:TMDS_encoder
 PORT MAP(clk => clk ,
			 VD => red ,
			 CD => "00" ,
			 VDE => DrawArea ,
			 TMDS => TMDS_red) ;
			 
 
 encode_G:TMDS_encoder
 PORT MAP(clk => clk ,
			 VD => green ,
			 CD => "00" ,
			 VDE => DrawArea ,
			 TMDS => TMDS_green) ;

 CD <= vSync & hSync ;
 
 
 encode_B:TMDS_encoder
 PORT MAP(clk => clk ,
			 VD => blue ,
			 CD => CD ,
			 VDE => DrawArea ,
			 TMDS => TMDS_blue) ;
 
 
 DCM_SP_inst:DCM_SP GENERIC MAP (CLKFX_MULTIPLY => 10)
 PORT MAP(CLKIN => clk,
			 CLKFX => DCM_TMDS_CLKFX,
			 RST => '0') ;
			 
 
 BUFG_TMDSp:BUFG
 PORT MAP(O => clk_TMDS,
			 I => DCM_TMDS_CLKFX);
 
 
 
 makeshiftload:PROCESS(clk_TMDS)
 begin
	 IF (clk_TMDS = '1' AND clk_TMDS'event) THEN
		 IF TMDS_mod10 = "1001" THEN
			TMDS_shift_load <= '1' ;
		 ELSE
			TMDS_shift_load <= '0' ;
		 END IF ;
	 END IF;
 END PROCESS makeshiftload ;
 
 
 
 shiftit:PROCESS(clk_TMDS)
 begin
	 IF (clk_TMDS = '1' AND clk_TMDS'event) THEN
		 IF TMDS_shift_load = '1' THEN
			 TMDS_shift_red <= TMDS_red ;
			 TMDS_shift_green <= TMDS_green ;
			 TMDS_shift_blue <= TMDS_blue ;
		 ELSE
			 TMDS_shift_red <= '0' & TMDS_shift_red(9 DOWNTO 1) ;
			 TMDS_shift_green <= '0' & TMDS_shift_green(9 DOWNTO 1) ;
			 TMDS_shift_blue <= '0' & TMDS_shift_blue(9 DOWNTO 1) ;
		 END IF ;
		 IF TMDS_mod10 = "1001" THEN
			TMDS_mod10 <= "0000" ;
		 ELSE
			TMDS_mod10 <= TMDS_mod10 + 1 ;
		 END IF ;
	 END IF;
 END PROCESS shiftit ;
 
 
 
 OBUFDS_red:OBUFDS GENERIC MAP (IOSTANDARD => "DEFAULT")
 PORT MAP(O => TMDSp(2),
			 OB => TMDSn(2),
			 I => TMDS_shift_red(0));
 
 
 OBUFDS_green:OBUFDS GENERIC MAP (IOSTANDARD => "DEFAULT")
 PORT MAP(O => TMDSp(1),
			 OB => TMDSn(1),
			 I => TMDS_shift_green(0));
			 
 
 OBUFDS_blue:OBUFDS GENERIC MAP (IOSTANDARD => "DEFAULT")
 PORT MAP(O => TMDSp(0),
			 OB => TMDSn(0),
			 I => TMDS_shift_blue(0));
			 
 
 OBUFDS_clock:OBUFDS GENERIC MAP (IOSTANDARD => "DEFAULT")
 PORT MAP(O => TMDSp_clock,
			 OB => TMDSn_clock,
			 I => clk);
			 
 
END structure;


