--- 2016 RSRC "c" VHDL Code 
--- Current file name:  c.vhd
--- Last Revised:  11/28/2016; 8:45 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;

ENTITY c IS
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk     : IN  STD_LOGIC ;
         c_in    : IN  STD_LOGIC ;
         c_out   : IN  STD_LOGIC ;
         bus_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
END c ;

ARCHITECTURE behavioral OF c IS

   SIGNAL c : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN

   creg:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'EVENT) THEN
	 IF (c_in = '1') THEN
	    c(31 DOWNTO 0 ) <= bus_in(31 DOWNTO 0) ;
         END IF ;
      END IF ;
   END PROCESS creg ; 

   cdrive:PROCESS(c_out,c)
   BEGIN
      IF (c_out = '1') THEN
         bus_out <= c ;
      ELSE
	 bus_out <= (OTHERS => 'Z') ;
      END IF ;
   END PROCESS cdrive ;

END behavioral ;
