--- 2016 RSRC "a" VHDL Code 
--- Current file name:  a.vhd
--- Last Revised:  11/28/2016; 8:45 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;

ENTITY a IS
   PORT (bus_in : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         a      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk    : IN  STD_LOGIC ;
         a_in   : IN  STD_LOGIC) ;
END a ;

ARCHITECTURE behavioral OF a IS

BEGIN

   areg:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'EVENT) THEN
	 IF (a_in = '1') THEN
	    a(31 DOWNTO 0 ) <= bus_in(31 DOWNTO 0) ;
         END IF ;
      END IF ;
   END PROCESS areg ; 

END behavioral ;
