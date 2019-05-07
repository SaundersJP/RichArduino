--- 2018 RSRC new "VGA Testbench" VHDL Code 
--- Current file name:  testbench.vhd
--- Last Revised:  8/22/2018; 10:03 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;
use ieee.numeric_std.all;



ENTITY testbench IS
   PORT( rx_check_output : out	std_logic_vector (7 downto 0 );
			clk       	: IN  STD_LOGIC;
         reset_l   	: IN  STD_LOGIC;
         TMDSp 		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			TMDSn 		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			TMDSp_clock : OUT STD_LOGIC ;
			TMDSn_clock : OUT STD_LOGIC;
			USB_RX		: OUT STD_LOGIC;
			USB_TX		: IN STD_LOGIC;
			BT_RX		: OUT STD_LOGIC;
			BT_TX		: IN STD_LOGIC) ;
END testbench ;


ARCHITECTURE structure OF testbench IS


	component Aregister
	PORT (clk : IN STD_LOGIC ;
		 reset_l : IN STD_LOGIC ;
		 ena: IN STD_LOGIC;
		 d : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)) ;
	end component;

   COMPONENT rsrc
   PORT(clk      : IN    STD_LOGIC ;
        reset_l  : IN    STD_LOGIC ;
        d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        address  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        read     : OUT   STD_LOGIC ;
        write    : OUT   STD_LOGIC ;
        done     : IN    STD_LOGIC) ;
   END COMPONENT ;


   COMPONENT eprom
      PORT(d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
           address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
           ce_l     : IN  STD_LOGIC ;
           oe_l     : IN  STD_LOGIC) ;
   END COMPONENT ;


   COMPONENT sram
      PORT (d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
            address  : IN    STD_LOGIC_VECTOR(9 DOWNTO 0) ;
            ce_l     : IN    STD_LOGIC ;
            oe_l     : IN    STD_LOGIC ;
            we_l     : IN    STD_LOGIC ;
            clk      : IN    STD_LOGIC) ;
   END COMPONENT ;
   
   COMPONENT HDMI_test
   PORT( clk		   : IN STD_LOGIC ;
			ena       	: IN  STD_LOGIC ;
         wea       	: IN  STD_LOGIC_VECTOR(0 DOWNTO 0) ;
			addra       : IN  STD_LOGIC_VECTOR(11 DOWNTO 0) ;
         dina        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			TMDSp 	   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			TMDSn 	   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			TMDSp_clock : OUT STD_LOGIC ;
			TMDSn_clock : OUT STD_LOGIC) ;
   END COMPONENT ;


	COMPONENT Uart_core
		port( rx_check_output : out	std_logic_vector (7 downto 0 );
			reset_l  	: in		std_logic;
			clk   	: in 		std_logic;
			ena 		: in  	std_logic;
			wea 		: in  	std_logic_vector(0 downto 0);
			rd_ena		: in 		std_logic;	
			data		: inout 	std_logic_vector(31 downto 0);
			addr 		: in 		std_logic_vector(1 downto 0);
			RX  		: in  	std_logic;
			TX  		: out 		std_logic
		);
	END COMPONENT;	

   SIGNAL reset_l_temp : STD_LOGIC ;
   SIGNAL reset_l_sync : STD_LOGIC ;
	SIGNAL clk_out      : STD_LOGIC ;
   SIGNAL d            : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL address      : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL read         : STD_LOGIC;
   SIGNAL write        : STD_LOGIC;
   SIGNAL done         : STD_LOGIC;
   SIGNAL eprom_ce_l   :  STD_LOGIC ;
   SIGNAL eprom_oe_l   :  STD_LOGIC ;
   SIGNAL sram_ce_l    :  STD_LOGIC ;
   SIGNAL sram_oe_l    :  STD_LOGIC ;
   SIGNAL sram_we_l    :  STD_LOGIC ;
	SIGNAL USB_RX_1			: STD_LOGIC;
	
	SIGNAL hdmi_ena      : STD_LOGIC;
	SIGNAL vga_ena      : STD_LOGIC;
   SIGNAL hdmi_wea      : STD_LOGIC_VECTOR(0 DOWNTO 0) ;
	
	SIGNAL Uart_read	: STD_LOGIC;
	SIGNAL USB_ena   : STD_LOGIC;
	SIGNAL BT_ena   : STD_LOGIC;
	SIGNAL USB_wea      : STD_LOGIC_VECTOR(0 DOWNTO 0) ;
   SIGNAL BT_wea      : STD_LOGIC_VECTOR(0 DOWNTO 0) ;
	SIGNAL USB_rd   : STD_LOGIC;
	SIGNAL BT_rd   : STD_LOGIC;
	SIGNAL rx_check_ena : std_logic;
	signal rx_check_data : std_logic_vector (7 downto 0);


BEGIN




	clk_out <= clk;

   syncprocess:PROCESS(clk_out)
   begin
      IF (clk_out = '1' AND clk_out'event) THEN
         reset_l_temp <= reset_l ;
         reset_l_sync <= reset_l_temp ;
      END IF;
   END PROCESS syncprocess ;

	rx_check_ena <='1' WHEN (address(31 DOWNTO 12) = "00000000000000001001" and read = '1') ELSE '0';
	
   eprom_ce_l <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000000" AND read = '1') ELSE '1' ;
   sram_ce_l  <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000001" AND (read = '1' OR write = '1')) ELSE '1' ;

   eprom_oe_l <= '0' WHEN read = '1' ELSE '1' ;
   sram_oe_l  <= '0' WHEN read = '1' ELSE '1' ;

   sram_we_l  <= '0' WHEN write = '1' ELSE '1' ;
	
	USB_ena <= '1' WHEN (address(31 DOWNTO 14) = "000000000000000010" and (read = '1' OR write = '1')) ELSE '0' ;
	USB_wea <= CONV_STD_LOGIC_VECTOR(write,1) ;
	USB_rd  <= '1' WHEN read = '1' ELSE '0' ;

	
	BT_ena <= '1' WHEN (address(31 DOWNTO 14) =  "000000000000000011" and (read = '1' OR write = '1')) ELSE '0' ;
	BT_wea <= CONV_STD_LOGIC_VECTOR(write,1) ;
	BT_rd  <= '1' WHEN read = '1' ELSE '0' ;
	
	hdmi_ena <= '1' WHEN (address(31 DOWNTO 14) = "000000000000000001" ) ELSE '0' ;
   hdmi_wea <= CONV_STD_LOGIC_VECTOR(write,1) ;
	
	
	rx_check_output <= rx_check_data;
	
   done <= '1' WHEN (eprom_ce_l = '0' OR sram_ce_l = '0' OR hdmi_ena = '1' OR USB_ena = '1') ELSE '0' ;


	rx_ready_check: Aregister
	PORT map (   clk => clk_out ,
					 reset_l => reset_l_sync ,
					 ena => rx_check_ena,
					 d => d (7 downto 0) ,
					 q => rx_check_data );
					 
					 
   rsrc1:rsrc      
   PORT MAP(clk       => clk_out,
            reset_l   => reset_l_sync,
            d         => d,
            address   => address,
            read      => read,
            write     => write,
            done      => done);

   erpom1:eprom    
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => eprom_ce_l,
               oe_l      => eprom_oe_l);
 
   sram1: sram
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => sram_ce_l,
               oe_l      => sram_oe_l,
               we_l      => sram_we_l,
               clk       => clk_out);

 
 
 

   hdmi1:HDMI_test
   PORT MAP(clk         => clk_out,
            ena         => hdmi_ena,
            wea         => hdmi_wea,
            addra       => address(13 DOWNTO 2),
            dina        => d(7 DOWNTO 0),
            TMDSp 	      => TMDSp,
			   TMDSn 	   	=> TMDSn,
			   TMDSp_clock  => TMDSp_clock,
			   TMDSn_clock  => TMDSn_clock);
				
	
	
	USB1 : Uart_core
	port map( rx_check_output => open,
				reset_l => reset_l_sync,
				clk   	=> clk_out,
				ena 		=> USB_ena,
				wea 		=> USB_wea,
				rd_ena		=> USB_rd,
				data		=> d,
				addr 		=> address(13 downto 12),
				RX  		=> USB_TX,
				TX  		=> USB_RX
		);
		
	Bluetooth : Uart_core
	port map( rx_check_output => open, 
				reset_l => reset_l_sync,
				clk   	=> clk_out,
				ena 		=> BT_ena,
				wea 		=> BT_wea,
				rd_ena		=> BT_rd,
				data		=> d,
				addr 		=> address(13 downto 12),
				RX  		=> BT_TX,
				TX  		=> BT_RX
		);

END structure;
