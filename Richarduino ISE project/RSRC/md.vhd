--- 2016 RSRC "md" VHDL Code 
--- Current file name:  md.vhd
--- Last Revised:  11/23/2016; 11:10 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;

ENTITY md IS
   PORT (bus_in   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk      : IN  STD_LOGIC ;
         md_rd    : IN  STD_LOGIC ;
         md_wr    : IN  STD_LOGIC ;
         md_out   : IN  STD_LOGIC ;
         md_bus   : IN  STD_LOGIC ;
         d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         bus_out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
END md ;

ARCHITECTURE behavioral OF md IS

   SIGNAL mdi : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL mdo : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN

   mdregs:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'EVENT) THEN
         IF (md_bus = '1') THEN
            mdo(31 DOWNTO 0) <= bus_in(31 DOWNTO 0) ;
         END IF ;
         IF (md_rd = '1') THEN
            mdi(31 DOWNTO 0) <= d ;
         END IF ;
      END IF ;
   END PROCESS mdregs ; 

   mddrive:PROCESS(md_out,mdi)
   BEGIN
      IF (md_out = '1') THEN
         bus_out <= mdi ;
      ELSE
	 bus_out <= (OTHERS => 'Z') ;
      END IF ;
   END PROCESS mddrive ;

   pindrive:PROCESS(mdo,md_wr,d)
   BEGIN
      IF (md_wr = '1') THEN
         d <= mdo ;
      ELSE
	 d <= (OTHERS => 'Z') ;
      END IF ;
   END PROCESS pindrive ;

END behavioral ;
