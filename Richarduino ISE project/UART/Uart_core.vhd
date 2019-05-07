----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:38:22 03/16/2019 
-- Design Name: 
-- Module Name:    Uart_core - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Uart_core is
	generic (
    g_CLKS_PER_BIT : integer := 217     -- Needs to be set correctly
    );
	port( rx_check_output : out	std_logic_vector (7 downto 0 );
			reset_l  	: in		std_logic;
			clk   	: in 		std_logic;
			ena 		: in  	std_logic;
			wea 		: in  	std_logic_vector(0 downto 0);
			rd_ena		: in		std_logic;
			data		: inout 	std_logic_vector(31 downto 0);
			addr 		: in 		std_logic_vector(1 downto 0);
			RX  		: in  	std_logic;
			TX  		: out 	std_logic
			
		);
end Uart_core;


architecture Behavioral of Uart_core is
component Decoder
	port( clk : in std_logic;
			addr: in std_logic_vector(1 downto 0);
			ena : in std_logic;
			read_RX		: out std_logic; 
			 read_RXD   : out std_logic;
			 write_TX	: out std_logic;
			 write_TXD	: out std_logic

	);
end component;



component Aregister
	PORT (clk : IN STD_LOGIC ;
			 reset_l : IN STD_LOGIC ;
			 ena: IN STD_LOGIC;
			 d : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)) ;
end component;




component uart_RX
  generic (
    g_CLKS_PER_BIT : integer := 217     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end component;


component uart_TX
  generic (
    g_CLKS_PER_BIT : integer := 217     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end component;

signal RX_ready	: std_logic_vector(7 downto 0);
signal TX_ready	: std_logic_vector(7 downto 0);



signal read_RX		: std_logic;
signal read_RXD   : std_logic;
signal write_TX	: std_logic;
signal write_TXD	: std_logic;
signal received_done : std_logic;
signal received_dataD : std_logic_vector(7 downto 0);
signal received_dataQ : std_logic_vector(7 downto 0);

signal start_transmit : std_logic;
signal active_transmit : std_logic;
signal transmit_done   : std_logic;
signal data_transmitD  : std_logic_vector(7 downto 0);
signal data_transmitQ  : std_logic_vector(7 downto 0);


signal ena_RX : std_logic;
signal ena_TX : std_logic;

type TXstates is (TXs0, TXs1, TXs2);
signal TXstate: TXstates := TXs0;
signal TXnxt_state : TXstates := TXs0;

type RXstates is (RXs0, RXs1);
signal RXstate: RXstates := RXs0;
signal RXnxt_state : RXstates := RXs0;


signal tx_data_ena : std_logic := '1';
signal tx_data_addr : std_logic_vector (0 downto 0) := "0";
--signal my_wea  : std_logic_vector (0 downto 0);
signal my_wea  : std_logic;

signal extra_data : std_logic_vector (23 downto 0);

--signal rx_check_output : std_logic;


begin 
	
	extra_data <= data (31 downto 8);
	
	my_decoder : Decoder
	port map (clk =>clk,
				addr => addr,
				ena => ena,
				read_RX =>read_RX,
				read_RXD   =>read_RXD,
				write_TX	=>write_TX,
				write_TXD	=>write_TXD
	
	
	);
	RX_register : Aregister
	PORT map (   clk => clk ,
					 reset_l => reset_l ,
					 ena => ena_RX,
					 d => received_dataD ,
					 q => received_dataQ );
					 
					 
	TX_register : Aregister
	PORT map (   clk => clk ,
					 reset_l => reset_l ,
					 ena => ena_TX,
					 d => data_transmitD ,
					 q => data_transmitQ );
	
	
	
	my_RX: uart_RX
	port map(
    i_Clk      	=> clk,  
    i_RX_Serial 	=> RX,
    o_RX_DV     	=> received_done,
    o_RX_Byte   	=> received_dataD);
	 
	 
	 
	my_TX: uart_TX
	port map(
	 i_Clk        => clk,
    i_TX_DV      => start_transmit,
    i_TX_Byte    => data_transmitQ,
    o_TX_Active  => open,
    o_TX_Serial  => TX,
    o_TX_Done    => transmit_done);
	 
--	 read_RX <= '1' when (ena = '1' and addr = "00") else '0';
--	 read_RXD <= '1' when (ena = '1' and addr = "01") else '0';
--	 write_TX <= '1' when (ena = '1' and addr = "10") else '0';
--	 write_TXD <= '1' when (ena = '1' and addr = "11") else '0';
	 
--	 data <= ("000000000000000000000000" & RX_ready) WHEN (read_RX = '1' and rd_ena = '1') ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
--	 data <= ("000000000000000000000000" & received_dataQ) WHEN (read_RXD = '1' and rd_ena = '1') ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	 TX_ready <= data (7 downto 0) WHEN (write_TX = '1') ELSE "00000000";
	 --data_transmitD <= data WHEN (write_TXD = '1' and wea = "1") ELSE data_transmitD;
	 --my_wea	<= "1" when (write_TXD = '1' and wea = "1") else "0";
	 my_wea	<= '1' when (write_TXD = '1' and wea = "1") else '0';


	rx_check_output <= received_dataQ;
	
	
	TX_data_register : Aregister
	PORT map (   clk => clk ,
					 reset_l => reset_l ,
					 ena => my_wea,
					 d => data (7 downto 0),
					 q => data_transmitD );
	 
			 

--   writeprocess:PROCESS(clk)
--   begin
--      IF (clk = '1' AND clk'event) THEN
--         IF (write_TX = '1') THEN
--            TX_ready <= data ;
--         END IF;
--			IF (write_TXD = '1') THEN
--            data_transmitD <= data ;
--         END IF;
--      END IF;
--   END PROCESS writeprocess ;
--
   readprocess:PROCESS(read_RX, read_RXD, rd_ena, RX_ready, received_dataQ)
   begin
      IF (read_RX = '1' and rd_ena = '1') THEN
         data <= "000000000000000000000000" & RX_ready;
      elsif (read_RXD = '1' and rd_ena = '1') then
			data <= "000000000000000000000000" & received_dataQ;
		else
			data <= (OTHERS => 'Z') ;
      END IF;
   END PROCESS readprocess ;
	
	
	 
	 clkd: PROCESS (clk)
	 BEGIN
		 IF (clk'EVENT AND clk='1') THEN
			 IF (reset_l = '0') THEN
				TXstate <= TXs0;
				RXstate <= RXs0;
			 ELSE
				TXstate <= TXnxt_state;
				RXstate <= RXnxt_state;
			 END IF;
		 END IF;
	 END PROCESS clkd;
	 
	 
	 -- process to determine next state
	 RXstate_trans: PROCESS (clk, RXstate, received_done, read_RXD)
	 BEGIN
		 RXnxt_state <= RXstate ;
		 CASE RXstate IS
			 WHEN RXs0 =>  RX_ready <= "00000000";
								ena_RX <= '0';
								if (received_done = '1') then
									RXnxt_state <= RXs1 ;
									ena_RX <= '1';
								end if;
			 WHEN RXs1 => 	RX_ready <= "00000001";
								--ena_RX is too long 
								ena_RX <= '1';
								if (read_RXD = '1') then
									RXnxt_state <= RXs0;
								end if;
		 END CASE;
	 END PROCESS RXstate_trans;
		
		
	 -- process to determine next state
	 TXstate_trans: PROCESS (clk, TXstate, TX_ready, transmit_done)
	 BEGIN
		 TXnxt_state <= TXstate ;
		 CASE TXstate IS
			 WHEN TXs0 =>  ena_TX <= '0';
								start_transmit <= '0';
								if (TX_ready(0) = '1') then
									TXnxt_state <= TXs1 ;
									ena_TX <= '1';
								end if;
			 WHEN TXs1 => 	start_transmit <= '1';
								ena_TX <= '1';
								TXnxt_state <= TXs2 ;
			 WHEN TXs2 =>	start_transmit <= '0';
								ena_TX <= '1';
								if (transmit_done = '1') then
									TXnxt_state <= TXs0 ;
								end if;
		 END CASE;
	 END PROCESS TXstate_trans;

	
 
end Behavioral;

