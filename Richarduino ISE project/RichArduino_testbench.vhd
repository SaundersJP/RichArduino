--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:11:02 03/26/2019
-- Design Name:   
-- Module Name:   H:/CSE462/RichArduino Test/RichArduino/RichArduino_testbench.vhd
-- Project Name:  RichArduino
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: testbench
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RichArduino_testbench IS
END RichArduino_testbench;
 
ARCHITECTURE behavior OF RichArduino_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT testbench

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
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset_l : std_logic := '1';
	signal RXTX	: std_logic;
	signal TMDSp	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal TMDSn	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal TMDSp_clock	: std_logic;
	signal TMDSn_clock	: std_logic;
	signal BT_RX	: std_logic;
	signal BT_TX	: std_logic;
	signal USB_RX	: std_logic;
	signal USB_TX	: std_logic;
	signal rx_check_output : std_logic_vector (7 downto 0 );

 

   -- Clock period definitions
   constant clk_period : time := 40 ns;
	   constant c_BIT_PERIOD : time := 8680 ns;

	
 procedure UART_WRITE_BYTE (
    i_data_in       : in  std_logic_vector(7 downto 0);
    signal o_serial : out std_logic) is
  begin
 
    -- Send Start Bit
    o_serial <= '0';
    wait for c_BIT_PERIOD;
 
    -- Send Data Byte
    for ii in 0 to 7 loop
      o_serial <= i_data_in(ii);
      wait for c_BIT_PERIOD;
    end loop;  -- ii
 
    -- Send Stop Bit
    o_serial <= '1';
    wait for c_BIT_PERIOD;
  end UART_WRITE_BYTE;
  
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: testbench PORT MAP (
          clk => clk,
          reset_l => reset_l,
          TMDSp => TMDSp,
          TMDSn => TMDSn,
          TMDSp_clock => TMDSp_clock,
          TMDSn_clock => TMDSn_clock,
          USB_RX => USB_RX,
          USB_TX => USB_TX,
          BT_RX => BT_RX,
          BT_TX => BT_TX
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;

   end process;
 

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		reset_l <= '0';
		wait for clk_period*10;
		reset_l <= '1';
		wait for clk_period*10;
		UART_WRITE_BYTE(X"3F", USB_TX);
		wait for clk_period*1000000000;


   end process;

END;
