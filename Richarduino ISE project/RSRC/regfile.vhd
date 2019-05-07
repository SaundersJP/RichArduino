--- 2016 RSRC "regfile" VHDL Code 
--- Current file name:  regfile.vhd
--- Last Revised:  11/23/2016; 8:45 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;

ENTITY regfile IS
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         ir      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         r_in    : IN  STD_LOGIC ;
         r_out   : IN  STD_LOGIC ;
         ba_out  : IN  STD_LOGIC ;
         gra     : IN  STD_LOGIC ;
         grb     : IN  STD_LOGIC ;
         grc     : IN  STD_LOGIC ;
         clk     : IN  STD_LOGIC ;
         rrc     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         bus_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
END regfile ;

ARCHITECTURE behavioral OF regfile IS

   SIGNAL ra      : STD_LOGIC_VECTOR(4 DOWNTO 0) ;
   SIGNAL rb      : STD_LOGIC_VECTOR(4 DOWNTO 0) ;
   SIGNAL rc      : STD_LOGIC_VECTOR(4 DOWNTO 0) ;
   SIGNAL mux_out : STD_LOGIC_VECTOR(4 DOWNTO 0) ;

   SIGNAL reg0    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg1    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg2    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg3    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg4    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg5    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg6    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg7    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg8    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg9    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg10   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg11   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg12   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg13   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg14   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg15   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg16   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg17   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg18   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg19   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg20   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg21   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg22   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg23   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg24   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg25   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg26   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg27   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg28   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg29   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg30   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL reg31   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN
   
   ra <= ir(26 DOWNTO 22) ;
   rb <= ir(21 DOWNTO 17) ;
   rc <= IR(16 DOWNTO 12) ;

   amux:PROCESS(ra,rb,rc,gra,grb,grc)
   BEGIN
      IF (gra = '1') THEN
	 mux_out <= ra ;
      ELSIF (grb = '1') THEN
         mux_out <= rb ;
      ELSIF (grc = '1') THEN
         mux_out <= rc ;
      ELSE
         mux_out <= "00000" ;
      END IF ;
   END PROCESS amux ; 

   regfile:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'EVENT) THEN
	 IF (r_in = '1') THEN
            CASE mux_out IS
               WHEN "00000" => reg0  <= bus_in ;
               WHEN "00001" => reg1  <= bus_in ;
               WHEN "00010" => reg2  <= bus_in ;
               WHEN "00011" => reg3  <= bus_in ;
               WHEN "00100" => reg4  <= bus_in ;
               WHEN "00101" => reg5  <= bus_in ;
               WHEN "00110" => reg6  <= bus_in ;
               WHEN "00111" => reg7  <= bus_in ;
               WHEN "01000" => reg8  <= bus_in ;
               WHEN "01001" => reg9  <= bus_in ;
               WHEN "01010" => reg10 <= bus_in ;
               WHEN "01011" => reg11 <= bus_in ;
               WHEN "01100" => reg12 <= bus_in ;
               WHEN "01101" => reg13 <= bus_in ;
               WHEN "01110" => reg14 <= bus_in ;
               WHEN "01111" => reg15 <= bus_in ;
               WHEN "10000" => reg16 <= bus_in ;
               WHEN "10001" => reg17 <= bus_in ;
               WHEN "10010" => reg18 <= bus_in ;
               WHEN "10011" => reg19 <= bus_in ;
               WHEN "10100" => reg20 <= bus_in ;
               WHEN "10101" => reg21 <= bus_in ;
               WHEN "10110" => reg22 <= bus_in ;
               WHEN "10111" => reg23 <= bus_in ;
               WHEN "11000" => reg24 <= bus_in ;
               WHEN "11001" => reg25 <= bus_in ;
               WHEN "11010" => reg26 <= bus_in ;
               WHEN "11011" => reg27 <= bus_in ;
               WHEN "11100" => reg28 <= bus_in ;
               WHEN "11101" => reg29 <= bus_in ;
               WHEN "11110" => reg30 <= bus_in ;
               WHEN OTHERS  => reg31 <= bus_in ;
            END CASE ;
         END IF ;
      END IF ;
   END PROCESS regfile ; 

   busdrive:PROCESS(mux_out,r_out,ba_out,reg0,reg1,reg2,reg3,reg4,reg5,reg6,
                    reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,
                    reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,
                    reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31)
   BEGIN
      IF ((ba_out = '1') OR (r_out = '1')) THEN
         CASE mux_out IS
               WHEN "00000" => IF r_out = '1' THEN
                                  bus_out <= reg0 ;
                               ELSE
                                  bus_out <= "00000000000000000000000000000000" ;
                               END IF ;
               WHEN "00001" => bus_out <= reg1 ;
               WHEN "00010" => bus_out <= reg2 ;
               WHEN "00011" => bus_out <= reg3 ;
               WHEN "00100" => bus_out <= reg4 ;
               WHEN "00101" => bus_out <= reg5 ;
               WHEN "00110" => bus_out <= reg6 ;
               WHEN "00111" => bus_out <= reg7 ;
               WHEN "01000" => bus_out <= reg8 ;
               WHEN "01001" => bus_out <= reg9 ;
               WHEN "01010" => bus_out <= reg10 ;
               WHEN "01011" => bus_out <= reg11 ;
               WHEN "01100" => bus_out <= reg12 ;
               WHEN "01101" => bus_out <= reg13 ;
               WHEN "01110" => bus_out <= reg14 ;
               WHEN "01111" => bus_out <= reg15 ;
               WHEN "10000" => bus_out <= reg16 ;
               WHEN "10001" => bus_out <= reg17 ;
               WHEN "10010" => bus_out <= reg18 ;
               WHEN "10011" => bus_out <= reg19 ;
               WHEN "10100" => bus_out <= reg20 ;
               WHEN "10101" => bus_out <= reg21 ;
               WHEN "10110" => bus_out <= reg22 ;
               WHEN "10111" => bus_out <= reg23 ;
               WHEN "11000" => bus_out <= reg24 ;
               WHEN "11001" => bus_out <= reg25 ;
               WHEN "11010" => bus_out <= reg26 ;
               WHEN "11011" => bus_out <= reg27 ;
               WHEN "11100" => bus_out <= reg28 ;
               WHEN "11101" => bus_out <= reg29 ;
               WHEN "11110" => bus_out <= reg30 ;
               WHEN OTHERS  => bus_out <= reg31 ;
            END CASE ;
      ELSE
	 bus_out  <= (OTHERS => 'Z') ;
      END IF ;
   END PROCESS busdrive ;

   rrcmux:PROCESS(rc,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,
                    reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,
                    reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,
                    reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31)
   BEGIN
      CASE rc IS
         WHEN "00000" => rrc <= reg0 ;
         WHEN "00001" => rrc <= reg1 ;
         WHEN "00010" => rrc <= reg2 ;
         WHEN "00011" => rrc <= reg3 ;
         WHEN "00100" => rrc <= reg4 ;
         WHEN "00101" => rrc <= reg5 ;
         WHEN "00110" => rrc <= reg6 ;
         WHEN "00111" => rrc <= reg7 ;
         WHEN "01000" => rrc <= reg8 ;
         WHEN "01001" => rrc <= reg9 ;
         WHEN "01010" => rrc <= reg10 ;
         WHEN "01011" => rrc <= reg11 ;
         WHEN "01100" => rrc <= reg12 ;
         WHEN "01101" => rrc <= reg13 ;
         WHEN "01110" => rrc <= reg14 ;
         WHEN "01111" => rrc <= reg15 ;
         WHEN "10000" => rrc <= reg16 ;
         WHEN "10001" => rrc <= reg17 ;
         WHEN "10010" => rrc <= reg18 ;
         WHEN "10011" => rrc <= reg19 ;
         WHEN "10100" => rrc <= reg20 ;
         WHEN "10101" => rrc <= reg21 ;
         WHEN "10110" => rrc <= reg22 ;
         WHEN "10111" => rrc <= reg23 ;
         WHEN "11000" => rrc <= reg24 ;
         WHEN "11001" => rrc <= reg25 ;
         WHEN "11010" => rrc <= reg26 ;
         WHEN "11011" => rrc <= reg27 ;
         WHEN "11100" => rrc <= reg28 ;
         WHEN "11101" => rrc <= reg29 ;
         WHEN "11110" => rrc <= reg30 ;
         WHEN OTHERS  => rrc <= reg31 ;
      END CASE ;
   END PROCESS rrcmux ;

END behavioral ;
