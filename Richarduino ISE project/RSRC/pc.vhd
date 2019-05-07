--- 2016 RSRC "pc" VHDL Code 
--- Current file name:  pc.vhd
--- Last Revised:  11/28/2016; 8:53 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY pc IS
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk     : IN  STD_LOGIC ;
         pc_in   : IN  STD_LOGIC ;
         pc_out  : IN  STD_LOGIC ;
         reset_l : IN  STD_LOGIC ;
         bus_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
END pc ;

ARCHITECTURE behavioral OF pc IS
 
   SIGNAL pc : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN

   pcreg:PROCESS(clk)
   BEGIN
      IF (clk = '1' and clk'EVENT) THEN
         IF (reset_l = '0') THEN
	    pc <= (OTHERS => '0') ;
	 ELSIF (pc_in = '1') THEN
	    pc <= bus_in ;
         END IF ;
      END IF ;
   END PROCESS pcreg ; 

   pcdrive:PROCESS(pc_out,pc)
   BEGIN
      IF (pc_out = '1') THEN
         bus_out <= pc ;
      ELSE
	 bus_out <= (OTHERS => 'Z') ;
      END IF ;
   END PROCESS pcdrive ;


END behavioral ;
