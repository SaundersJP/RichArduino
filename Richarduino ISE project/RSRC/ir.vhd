--- 2016 RSRC "ir" VHDL Code 
--- Current file name:  ir.vhd
--- Last Revised:  11/28/2016; 8:45 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;

ENTITY ir IS
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk     : IN  STD_LOGIC ;
         c1_out  : IN  STD_LOGIC ;
         c2_out  : IN  STD_LOGIC ;
         ir_in   : IN  STD_LOGIC ;
         bus_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ; 
         ir      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
END ir ;

ARCHITECTURE behavioral OF ir IS

BEGIN

   instrreg:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'EVENT) THEN
	 IF (ir_in = '1') THEN
	    ir(31 DOWNTO 0 ) <= bus_in(31 DOWNTO 0) ;
         END IF ;
      END IF ;
   END PROCESS instrreg ; 

   irdrive:PROCESS(c1_out,c2_out,ir)
   BEGIN
      IF (c1_out = '1') THEN
         bus_out <= ir(21) & ir(21) & ir(21) & ir(21) & ir(21) & ir(21) &
                    ir(21) & ir(21) & ir(21) & ir(21) & ir(21 DOWNTO 0) ;
      ELSIF (c2_out = '1') THEN
         bus_out <= ir(16) & ir(16) & ir(16) & ir(16) & ir(16) & ir(16) & ir(16) &
                    ir(16) & ir(16) & ir(16) & ir(16) & ir(16) & ir(16) & ir(16) &
                    ir(16) & ir(16 DOWNTO 0) ;
      ELSE
	 bus_out <= (OTHERS => 'Z') ;
      END IF ;
   END PROCESS irdrive ;

END behavioral ;
