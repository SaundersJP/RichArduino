--- 2016 RSRC "ma" VHDL Code 
--- Current file name:  ma.vhd
--- Last Revised:  11/28/2016; 8:46 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;

ENTITY ma IS
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk     : IN  STD_LOGIC ;
         ma_in   : IN  STD_LOGIC) ;
END ma ;

ARCHITECTURE behavioral OF ma IS

BEGIN

   mareg:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'EVENT) THEN
	 IF (ma_in = '1') THEN
	    address(31 DOWNTO 0 ) <= bus_in(31 DOWNTO 0) ;
         END IF ;
      END IF ;
   END PROCESS mareg ; 

END behavioral ;
