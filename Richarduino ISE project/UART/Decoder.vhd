----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:01:50 03/19/2019 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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
entity Decoder is
    	port( clk : in std_logic;
			addr: in std_logic_vector(1 downto 0);
			ena : in std_logic;
			read_RX		: out std_logic;
			 read_RXD   : out std_logic;
			 write_TX	: out std_logic;
			 write_TXD	: out std_logic

	);
end Decoder;

architecture Behavioral of Decoder is

begin

    -- single active low enabled tri-state buffer
    read_RX <= '1' when (ena = '1' and addr = "00") else '0';
	 read_RXD <= '1' when (ena = '1' and addr = "01") else '0';
	 write_TX <= '1' when (ena = '1' and addr = "10") else '0';
	 write_TXD <= '1' when (ena = '1' and addr = "11") else '0';
    


end Behavioral;

