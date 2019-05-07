--- 20016 RSRC "conbit" VHDL Code 
--- Current file name:  conbit.vhd
--- Last Revised:  11/28/2016; 8:45 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;

ENTITY conbit IS
   PORT (bus_in   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         ir       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         con      : OUT STD_LOGIC) ;
END conbit ;

ARCHITECTURE behavioral OF conbit IS

BEGIN
   conbit:PROCESS(bus_in,ir)
   BEGIN
      IF (ir(2 DOWNTO 0) = "001") THEN
         con <= '1' ;
      ELSIF (ir(2 DOWNTO 0) = "010") AND (bus_in = "00000000000000000000000000000000") THEN
         con <= '1' ;
      ELSIF (ir(2 DOWNTO 0) = "011") AND (NOT(bus_in = "00000000000000000000000000000000")) THEN
         con <= '1' ;
      ELSIF (ir(2 DOWNTO 0) = "100") AND (bus_in(31) = '0') THEN
         con <= '1' ;
      ELSIF (ir(2 DOWNTO 0) = "101") AND (bus_in(31) = '1') THEN
         con <= '1' ;
      ELSE
         con <= '0' ;
      END IF ;
   END PROCESS conbit ; 
END behavioral ;
