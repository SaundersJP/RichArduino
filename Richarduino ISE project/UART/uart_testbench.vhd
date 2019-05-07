--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:04:04 03/19/2019
-- Design Name:   
-- Module Name:   H:/CSE462/RichArduino board/Uart_Test/Uart_test/uart_testbench.vhd
-- Project Name:  Uart_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Uart_core
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
 
ENTITY uart_testbench IS
END uart_testbench;
 
ARCHITECTURE behavior OF uart_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Uart_core
    PORT(
         reset_l : IN  std_logic;
         clk : IN  std_logic;
         ena : IN  std_logic;
			wea : IN  std_logic_vector (0 downto 0);
         data : INOUT  std_logic_vector(7 downto 0);
         addr : IN  std_logic_vector(1 downto 0);
         RX : IN  std_logic;
         TX : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset_l : std_logic := '1';
   signal clk : std_logic := '0';
   signal ena : std_logic := '0';
   signal addr : std_logic_vector(1 downto 0) := (others => '0');
   signal RX : std_logic := '1';
	signal wea : std_logic_vector(0 downto 0) := "0";
	--BiDirs
   signal data : std_logic_vector(7 downto 0);

 	--Outputs
   signal TX : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
	constant c_BIT_PERIOD : time := 11500 ns;
	
	
	  -- Low-level byte-write
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
   uut: Uart_core PORT MAP (
          reset_l => reset_l,
          clk => clk,
          ena => ena,
			 wea => wea,
          data => data,
          addr => addr,
          RX => RX,
          TX => TX
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

      -- insert stimulus here
		
	-- Send a command to the UART
    wait until rising_edge(clk);
    UART_WRITE_BYTE(X"0F", RX);
    wait until rising_edge(clk);
--	 ena <= '1';
--	 addr <= "00";
--	 wait until rising_edge(clk);
--
--	 while (data = "00000000") loop
--	     wait until rising_edge(clk);
--
--	 end loop;
--	     wait until rising_edge(clk);
--	 ena <= '1';
--	 addr <= "01";
--	     wait until rising_edge(clk);
--	 ena <= '0';
--	 addr <= "00";  
--	 
--	 wait until rising_edge(clk);
--    UART_WRITE_BYTE(X"F0", RX);
--    wait until rising_edge(clk);
--	 ena <= '1';
--	 addr <= "00";
--	 wait until rising_edge(clk);
--
--	 while (data = "00000000") loop
--	     wait until rising_edge(clk);
--
--	 end loop;
--	     wait until rising_edge(clk);
--	 ena <= '1';
--	 addr <= "01";
--	     wait until rising_edge(clk);
--	 ena <= '0';
--	 addr <= "00";  
----	


-----------------------------------------------------TX	
--	 	     wait until rising_edge(clk);
--	 ena <= '1';
--	 addr <= "11";
--	 data <= "01010101";
--	     wait until rising_edge(clk);
--	 ena <= '0';
--	 addr <= "00";
--
--	 data <= "00000000";	
--
--	     wait until rising_edge(clk);
--	 ena <= '1';
--	 addr <= "10";
--
--	 data <= "00000001";	
--	 
--	 	      wait until rising_edge(clk);
--	 ena <= '0';
--	 addr <= "00";
--
--	 data <= "00000000";
--
--	     wait until rising_edge(clk);
--	 ena <= '1';
--	 addr <= "10";
--
--	 data <= "00000000";	
--	 
--
--
--	     wait until rising_edge(clk);
--	 ena <= '0';
--	 addr <= "00";
--
--	 data <= "00000000";	
--	 
--
      wait for clk_period*100000000;
--
--		
--		
--
--		
--	 
--	 
 
    -- Check that the correct command was received
    if data = X"3F" then
      report "Test Passed - Correct Byte Received" severity note;
    else
      report "Test Failed - Incorrect Byte Received" severity note;
    end if;
 
    assert false report "Tests Complete" severity failure;
      wait;
   end process;

END;
