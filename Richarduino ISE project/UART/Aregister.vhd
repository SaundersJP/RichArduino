----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:28:59 03/19/2019 
-- Design Name: 
-- Module Name:    Aregister - Behavioral 
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
LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;


ENTITY aregister IS
	 PORT (clk : IN STD_LOGIC ;
			 ena : IN STD_LOGIC;
			 reset_l : IN STD_LOGIC ;
			 d : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)) ;
END aregister ;

ARCHITECTURE behavioral OF aregister IS

BEGIN

 clkd: PROCESS (clk)
 BEGIN
	 IF (clk'EVENT AND clk='1') THEN
		 IF (reset_l = '0') THEN
			q <= "00000000" ;
		 ELSE 
			IF (ena = '1') THEN
				q <= d;
			END IF;
		 END IF;
	 END IF;
 END PROCESS clkd;
END behavioral ; 

