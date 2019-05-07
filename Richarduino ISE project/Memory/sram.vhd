--- 2018 new "sram" VHDL Code 
--- Current file name: sram.vhd
--- Last Revised:  8/21/2018; 4:21 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY sram IS
   PORT (d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address  : IN    STD_LOGIC_VECTOR(9 DOWNTO 0) ;
         ce_l     : IN    STD_LOGIC ;
         oe_l     : IN    STD_LOGIC ;
         we_l     : IN    STD_LOGIC ;
         clk      : IN    STD_LOGIC) ;
END sram ;

ARCHITECTURE behavioral OF sram IS

   TYPE memoryarray IS ARRAY(1023 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0) ;

   SIGNAL myarray : memoryarray ;

   SIGNAL myindex : INTEGER RANGE 0 TO 1023 ;

   SIGNAL temp : UNSIGNED(9 DOWNTO 0) ;

BEGIN

   temp <= UNSIGNED(address(9 DOWNTO 0)) ;

   myindex <= CONV_INTEGER(temp) ;

   writeprocess:PROCESS(clk)
   begin
      IF (clk = '1' AND clk'event) THEN
         IF (ce_l = '0' AND we_l = '0') THEN
            myarray(myindex) <= d(31 DOWNTO 0); 
         END IF;
      END IF;
   END PROCESS writeprocess ;

   readprocess:PROCESS(ce_l,oe_l,myarray,myindex)
   begin
      IF (ce_l = '0' AND oe_l = '0') THEN
         d(31 DOWNTO 0) <= myarray(myindex) ;
      else
	 d(31 DOWNTO 0) <= (OTHERS => 'Z') ;
      END IF;
   END PROCESS readprocess ; 

END behavioral ;
