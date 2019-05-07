--- 2018 RSRC "alu" VHDL Code 
--- Current file name:  alu.vhd
--- Last Revised:  7/5/2018; 4:00 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
use IEEE.STD_LOGIC_UNSIGNED.ALL ;
use IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY alu IS
   PORT (a      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         b      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         add    : IN  STD_LOGIC ;
         sub    : IN  STD_LOGIC ;
         andx   : IN  STD_LOGIC ;
         c_eq_b : IN  STD_LOGIC ;
         inc4   : IN  STD_LOGIC ;
         neg    : IN  STD_LOGIC ;
         shr    : IN  STD_LOGIC ;
         shl    : IN  STD_LOGIC ;
         shc    : IN  STD_LOGIC ;
         shra   : IN  STD_LOGIC ;
         orx    : IN  STD_LOGIC ;
         notx   : IN  STD_LOGIC ;
         n      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0) ;
         c      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
END alu ;

ARCHITECTURE behavioral OF alu IS

   SIGNAL mysel : STD_LOGIC_VECTOR(11 DOWNTO 0) ;
   SIGNAL bshr  : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL bshl  : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL bshc  : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL bshra : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN

   mysel <= STD_LOGIC_VECTOR'(add,sub,andx,c_eq_b,inc4,neg,shr,shl,shc,shra,orx,notx) ;

   WITH mysel SELECT
      c <= a + b                        WHEN "100000000000" ,
           a - b                        WHEN "010000000000" ,
           a AND b                      WHEN "001000000000" ,
           b                            WHEN "000100000000" ,
           b + 4                        WHEN "000010000000" ,
           0 - b                        WHEN "000001000000" ,
           bshr                         WHEN "000000100000" ,
           bshl                         WHEN "000000010000" ,
           bshc                         WHEN "000000001000" ,
           bshra                        WHEN "000000000100" ,
           a OR b                       WHEN "000000000010" ,
           NOT(b)                       WHEN "000000000001" ,
           b                            WHEN OTHERS ;

   PROCESS(n,b)
   BEGIN
      CASE n IS
         WHEN "00000" => bshr  <= b(31 DOWNTO 0) ;
         WHEN "00001" => bshr  <= '0' & b(31 DOWNTO 1) ;
         WHEN "00010" => bshr  <= "00" & b(31 DOWNTO 2) ;
         WHEN "00011" => bshr  <= "000" & b(31 DOWNTO 3) ;
         WHEN "00100" => bshr  <= "0000" & b(31 DOWNTO 4) ;
         WHEN "00101" => bshr  <= "00000" & b(31 DOWNTO 5) ;
         WHEN "00110" => bshr  <= "000000" & b(31 DOWNTO 6) ;
         WHEN "00111" => bshr  <= "0000000" & b(31 DOWNTO 7) ;
         WHEN "01000" => bshr  <= "00000000" & b(31 DOWNTO 8) ;
         WHEN "01001" => bshr  <= "000000000" & b(31 DOWNTO 9) ;
         WHEN "01010" => bshr  <= "0000000000" & b(31 DOWNTO 10) ;
         WHEN "01011" => bshr  <= "00000000000" & b(31 DOWNTO 11) ;
         WHEN "01100" => bshr  <= "000000000000" & b(31 DOWNTO 12) ;
         WHEN "01101" => bshr  <= "0000000000000" & b(31 DOWNTO 13) ;
         WHEN "01110" => bshr  <= "00000000000000" & b(31 DOWNTO 14) ;
         WHEN "01111" => bshr  <= "000000000000000" & b(31 DOWNTO 15) ;
         WHEN "10000" => bshr  <= "0000000000000000" & b(31 DOWNTO 16) ;
         WHEN "10001" => bshr  <= "00000000000000000" & b(31 DOWNTO 17) ;
         WHEN "10010" => bshr  <= "000000000000000000" & b(31 DOWNTO 18) ;
         WHEN "10011" => bshr  <= "0000000000000000000" & b(31 DOWNTO 19) ;
         WHEN "10100" => bshr  <= "00000000000000000000" & b(31 DOWNTO 20) ;
         WHEN "10101" => bshr  <= "000000000000000000000" & b(31 DOWNTO 21) ;
         WHEN "10110" => bshr  <= "0000000000000000000000" & b(31 DOWNTO 22) ;
         WHEN "10111" => bshr  <= "00000000000000000000000" & b(31 DOWNTO 23) ;
         WHEN "11000" => bshr  <= "000000000000000000000000" & b(31 DOWNTO 24) ;
         WHEN "11001" => bshr  <= "0000000000000000000000000" & b(31 DOWNTO 25) ;
         WHEN "11010" => bshr  <= "00000000000000000000000000" & b(31 DOWNTO 26) ;
         WHEN "11011" => bshr  <= "000000000000000000000000000" & b(31 DOWNTO 27) ;
         WHEN "11100" => bshr  <= "0000000000000000000000000000" & b(31 DOWNTO 28) ;
         WHEN "11101" => bshr  <= "00000000000000000000000000000" & b(31 DOWNTO 29) ;
         WHEN "11110" => bshr  <= "000000000000000000000000000000" & b(31 DOWNTO 30) ;
         WHEN OTHERS  => bshr  <= "0000000000000000000000000000000" & b(31) ;
      END CASE ;
   END PROCESS ;

   PROCESS(n,b)
   BEGIN
      CASE n IS
         WHEN "00000" => bshl  <= b(31 DOWNTO 0) ;
         WHEN "00001" => bshl  <= b(30 DOWNTO 0) & '0' ;
         WHEN "00010" => bshl  <= b(29 DOWNTO 0) & "00" ;
         WHEN "00011" => bshl  <= b(28 DOWNTO 0) & "000" ;
         WHEN "00100" => bshl  <= b(27 DOWNTO 0) & "0000" ;
         WHEN "00101" => bshl  <= b(26 DOWNTO 0) & "00000" ;
         WHEN "00110" => bshl  <= b(25 DOWNTO 0) & "000000" ;
         WHEN "00111" => bshl  <= b(24 DOWNTO 0) & "0000000" ;
         WHEN "01000" => bshl  <= b(23 DOWNTO 0) & "00000000" ;
         WHEN "01001" => bshl  <= b(22 DOWNTO 0) & "000000000" ;
         WHEN "01010" => bshl  <= b(21 DOWNTO 0) & "0000000000" ;
         WHEN "01011" => bshl  <= b(20 DOWNTO 0) & "00000000000" ;
         WHEN "01100" => bshl  <= b(19 DOWNTO 0) & "000000000000" ;
         WHEN "01101" => bshl  <= b(18 DOWNTO 0) & "0000000000000" ;
         WHEN "01110" => bshl  <= b(17 DOWNTO 0) & "00000000000000" ;
         WHEN "01111" => bshl  <= b(16 DOWNTO 0) & "000000000000000" ;
         WHEN "10000" => bshl  <= b(15 DOWNTO 0) & "0000000000000000" ;
         WHEN "10001" => bshl  <= b(14 DOWNTO 0) & "00000000000000000" ;
         WHEN "10010" => bshl  <= b(13 DOWNTO 0) & "000000000000000000" ;
         WHEN "10011" => bshl  <= b(12 DOWNTO 0) & "0000000000000000000" ;
         WHEN "10100" => bshl  <= b(11 DOWNTO 0) & "00000000000000000000" ;
         WHEN "10101" => bshl  <= b(10 DOWNTO 0) & "000000000000000000000" ;
         WHEN "10110" => bshl  <= b(9 DOWNTO 0) & "0000000000000000000000" ;
         WHEN "10111" => bshl  <= b(8 DOWNTO 0) & "00000000000000000000000" ;
         WHEN "11000" => bshl  <= b(7 DOWNTO 0) & "000000000000000000000000" ;
         WHEN "11001" => bshl  <= b(6 DOWNTO 0) & "0000000000000000000000000" ;
         WHEN "11010" => bshl  <= b(5 DOWNTO 0) & "00000000000000000000000000" ;
         WHEN "11011" => bshl  <= b(4 DOWNTO 0) & "000000000000000000000000000" ;
         WHEN "11100" => bshl  <= b(3 DOWNTO 0) & "0000000000000000000000000000" ;
         WHEN "11101" => bshl  <= b(2 DOWNTO 0) & "00000000000000000000000000000" ;
         WHEN "11110" => bshl  <= b(1 DOWNTO 0) & "000000000000000000000000000000" ;
         WHEN OTHERS  => bshl  <= b(0) & "0000000000000000000000000000000" ;
      END CASE ;
   END PROCESS ;

   PROCESS(n,b)
   BEGIN
      CASE n IS
         WHEN "00000" => bshc  <= b(31 DOWNTO 0) ;
         WHEN "00001" => bshc  <= b(30 DOWNTO 0) & b(31) ;
         WHEN "00010" => bshc  <= b(29 DOWNTO 0) & b(31 DOWNTO 30) ;
         WHEN "00011" => bshc  <= b(28 DOWNTO 0) & b(31 DOWNTO 29) ;
         WHEN "00100" => bshc  <= b(27 DOWNTO 0) & b(31 DOWNTO 28) ;
         WHEN "00101" => bshc  <= b(26 DOWNTO 0) & b(31 DOWNTO 27) ;
         WHEN "00110" => bshc  <= b(25 DOWNTO 0) & b(31 DOWNTO 26) ;
         WHEN "00111" => bshc  <= b(24 DOWNTO 0) & b(31 DOWNTO 25) ;
         WHEN "01000" => bshc  <= b(23 DOWNTO 0) & b(31 DOWNTO 24) ;
         WHEN "01001" => bshc  <= b(22 DOWNTO 0) & b(31 DOWNTO 23) ;
         WHEN "01010" => bshc  <= b(21 DOWNTO 0) & b(31 DOWNTO 22) ;
         WHEN "01011" => bshc  <= b(20 DOWNTO 0) & b(31 DOWNTO 21) ;
         WHEN "01100" => bshc  <= b(19 DOWNTO 0) & b(31 DOWNTO 20) ;
         WHEN "01101" => bshc  <= b(18 DOWNTO 0) & b(31 DOWNTO 19) ;
         WHEN "01110" => bshc  <= b(17 DOWNTO 0) & b(31 DOWNTO 18) ;
         WHEN "01111" => bshc  <= b(16 DOWNTO 0) & b(31 DOWNTO 17) ;
         WHEN "10000" => bshc  <= b(15 DOWNTO 0) & b(31 DOWNTO 16) ;
         WHEN "10001" => bshc  <= b(14 DOWNTO 0) & b(31 DOWNTO 15) ;
         WHEN "10010" => bshc  <= b(13 DOWNTO 0) & b(31 DOWNTO 14) ;
         WHEN "10011" => bshc  <= b(12 DOWNTO 0) & b(31 DOWNTO 13) ;
         WHEN "10100" => bshc  <= b(11 DOWNTO 0) & b(31 DOWNTO 12) ;
         WHEN "10101" => bshc  <= b(10 DOWNTO 0) & b(31 DOWNTO 11) ;
         WHEN "10110" => bshc  <= b(9 DOWNTO 0) & b(31 DOWNTO 10) ;
         WHEN "10111" => bshc  <= b(8 DOWNTO 0) & b(31 DOWNTO 9) ;
         WHEN "11000" => bshc  <= b(7 DOWNTO 0) & b(31 DOWNTO 8) ;
         WHEN "11001" => bshc  <= b(6 DOWNTO 0) & b(31 DOWNTO 7) ;
         WHEN "11010" => bshc  <= b(5 DOWNTO 0) & b(31 DOWNTO 6) ;
         WHEN "11011" => bshc  <= b(4 DOWNTO 0) & b(31 DOWNTO 5) ;
         WHEN "11100" => bshc  <= b(3 DOWNTO 0) & b(31 DOWNTO 4) ;
         WHEN "11101" => bshc  <= b(2 DOWNTO 0) & b(31 DOWNTO 3) ;
         WHEN "11110" => bshc  <= b(1 DOWNTO 0) & b(31 DOWNTO 2) ;
         WHEN OTHERS  => bshc  <= b(0) & b(31 DOWNTO 1) ;
      END CASE ;
   END PROCESS ;

   PROCESS(n,b)
   BEGIN
      IF b(31) = '0' THEN
         CASE n IS
            WHEN "00000" => bshra  <= b(31 DOWNTO 0) ;
            WHEN "00001" => bshra  <= '0' & b(31 DOWNTO 1) ;
            WHEN "00010" => bshra  <= "00" & b(31 DOWNTO 2) ;
            WHEN "00011" => bshra  <= "000" & b(31 DOWNTO 3) ;
            WHEN "00100" => bshra  <= "0000" & b(31 DOWNTO 4) ;
            WHEN "00101" => bshra  <= "00000" & b(31 DOWNTO 5) ;
            WHEN "00110" => bshra  <= "000000" & b(31 DOWNTO 6) ;
            WHEN "00111" => bshra  <= "0000000" & b(31 DOWNTO 7) ;
            WHEN "01000" => bshra  <= "00000000" & b(31 DOWNTO 8) ;
            WHEN "01001" => bshra  <= "000000000" & b(31 DOWNTO 9) ;
            WHEN "01010" => bshra  <= "0000000000" & b(31 DOWNTO 10) ;
            WHEN "01011" => bshra  <= "00000000000" & b(31 DOWNTO 11) ;
            WHEN "01100" => bshra  <= "000000000000" & b(31 DOWNTO 12) ;
            WHEN "01101" => bshra  <= "0000000000000" & b(31 DOWNTO 13) ;
            WHEN "01110" => bshra  <= "00000000000000" & b(31 DOWNTO 14) ;
            WHEN "01111" => bshra  <= "000000000000000" & b(31 DOWNTO 15) ;
            WHEN "10000" => bshra  <= "0000000000000000" & b(31 DOWNTO 16) ;
            WHEN "10001" => bshra  <= "00000000000000000" & b(31 DOWNTO 17) ;
            WHEN "10010" => bshra  <= "000000000000000000" & b(31 DOWNTO 18) ;
            WHEN "10011" => bshra  <= "0000000000000000000" & b(31 DOWNTO 19) ;
            WHEN "10100" => bshra  <= "00000000000000000000" & b(31 DOWNTO 20) ;
            WHEN "10101" => bshra  <= "000000000000000000000" & b(31 DOWNTO 21) ;
            WHEN "10110" => bshra  <= "0000000000000000000000" & b(31 DOWNTO 22) ;
            WHEN "10111" => bshra  <= "00000000000000000000000" & b(31 DOWNTO 23) ;
            WHEN "11000" => bshra  <= "000000000000000000000000" & b(31 DOWNTO 24) ;
            WHEN "11001" => bshra  <= "0000000000000000000000000" & b(31 DOWNTO 25) ;
            WHEN "11010" => bshra  <= "00000000000000000000000000" & b(31 DOWNTO 26) ;
            WHEN "11011" => bshra  <= "000000000000000000000000000" & b(31 DOWNTO 27) ;
            WHEN "11100" => bshra  <= "0000000000000000000000000000" & b(31 DOWNTO 28) ;
            WHEN "11101" => bshra  <= "00000000000000000000000000000" & b(31 DOWNTO 29) ;
            WHEN "11110" => bshra  <= "000000000000000000000000000000" & b(31 DOWNTO 30) ;
            WHEN OTHERS  => bshra  <= "0000000000000000000000000000000" & b(31) ;
         END CASE ;
      ELSE
         CASE n IS
            WHEN "00000" => bshra  <= b(31 DOWNTO 0) ;
            WHEN "00001" => bshra  <= '1' & b(31 DOWNTO 1) ;
            WHEN "00010" => bshra  <= "11" & b(31 DOWNTO 2) ;
            WHEN "00011" => bshra  <= "111" & b(31 DOWNTO 3) ;
            WHEN "00100" => bshra  <= "1111" & b(31 DOWNTO 4) ;
            WHEN "00101" => bshra  <= "11111" & b(31 DOWNTO 5) ;
            WHEN "00110" => bshra  <= "111111" & b(31 DOWNTO 6) ;
            WHEN "00111" => bshra  <= "1111111" & b(31 DOWNTO 7) ;
            WHEN "01000" => bshra  <= "11111111" & b(31 DOWNTO 8) ;
            WHEN "01001" => bshra  <= "111111111" & b(31 DOWNTO 9) ;
            WHEN "01010" => bshra  <= "1111111111" & b(31 DOWNTO 10) ;
            WHEN "01011" => bshra  <= "11111111111" & b(31 DOWNTO 11) ;
            WHEN "01100" => bshra  <= "111111111111" & b(31 DOWNTO 12) ;
            WHEN "01101" => bshra  <= "1111111111111" & b(31 DOWNTO 13) ;
            WHEN "01110" => bshra  <= "11111111111111" & b(31 DOWNTO 14) ;
            WHEN "01111" => bshra  <= "111111111111111" & b(31 DOWNTO 15) ;
            WHEN "10000" => bshra  <= "1111111111111111" & b(31 DOWNTO 16) ;
            WHEN "10001" => bshra  <= "11111111111111111" & b(31 DOWNTO 17) ;
            WHEN "10010" => bshra  <= "111111111111111111" & b(31 DOWNTO 18) ;
            WHEN "10011" => bshra  <= "1111111111111111111" & b(31 DOWNTO 19) ;
            WHEN "10100" => bshra  <= "11111111111111111111" & b(31 DOWNTO 20) ;
            WHEN "10101" => bshra  <= "111111111111111111111" & b(31 DOWNTO 21) ;
            WHEN "10110" => bshra  <= "1111111111111111111111" & b(31 DOWNTO 22) ;
            WHEN "10111" => bshra  <= "11111111111111111111111" & b(31 DOWNTO 23) ;
            WHEN "11000" => bshra  <= "111111111111111111111111" & b(31 DOWNTO 24) ;
            WHEN "11001" => bshra  <= "1111111111111111111111111" & b(31 DOWNTO 25) ;
            WHEN "11010" => bshra  <= "11111111111111111111111111" & b(31 DOWNTO 26) ;
            WHEN "11011" => bshra  <= "111111111111111111111111111" & b(31 DOWNTO 27) ;
            WHEN "11100" => bshra  <= "1111111111111111111111111111" & b(31 DOWNTO 28) ;
            WHEN "11101" => bshra  <= "11111111111111111111111111111" & b(31 DOWNTO 29) ;
            WHEN "11110" => bshra  <= "111111111111111111111111111111" & b(31 DOWNTO 30) ;
            WHEN OTHERS  => bshra  <= "1111111111111111111111111111111" & b(31) ;
         END CASE ;
      END IF ;
   END PROCESS ;

END behavioral ;
