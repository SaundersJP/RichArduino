--- 2016 RSRC "shiftcounter" VHDL Code 
--- Current file name:  shiftcounter.vhd
--- Last Revised:  11/23/2016; 8:51 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY shiftcounter IS
   PORT (rrc       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         ir        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         n         : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)) ;
END shiftcounter ;

ARCHITECTURE behavioral OF shiftcounter IS

   SIGNAL shift_cnt      : STD_LOGIC_VECTOR(4 DOWNTO 0) ;

BEGIN

   shift_cnt <= ir(4 DOWNTO 0) ;

   n <= shift_cnt WHEN NOT(shift_cnt = "00000") ELSE rrc(4 DOWNTO 0) ;

END behavioral ;
