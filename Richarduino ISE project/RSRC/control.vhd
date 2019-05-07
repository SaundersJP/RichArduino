--- Current RSRC "control" VHDL Code 
--- Current file name:  control.vhd
--- Last Revised:  11/23/2016; 9:15 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY control IS
   PORT (clk         : IN    STD_LOGIC ;
         opcode      : IN    STD_LOGIC_VECTOR(4 DOWNTO 0) ;
         con         : IN    STD_LOGIC ;
         done        : IN    STD_LOGIC ;
         reset_l     : IN    STD_LOGIC ;
         a_in        : OUT   STD_LOGIC ;
         c_in        : OUT   STD_LOGIC ;
         c_out       : OUT   STD_LOGIC ;
         pc_in       : OUT   STD_LOGIC ;
         pc_out      : OUT   STD_LOGIC ;
         c1_out      : OUT   STD_LOGIC ;
         c2_out      : OUT   STD_LOGIC ;
         ir_in       : OUT   STD_LOGIC ;
         gra         : OUT   STD_LOGIC ;
         grb         : OUT   STD_LOGIC ;
         grc         : OUT   STD_LOGIC ;
         r_in        : OUT   STD_LOGIC ;
         r_out       : OUT   STD_LOGIC ;
         ba_out      : OUT   STD_LOGIC ;
         md_bus      : OUT   STD_LOGIC ;
         md_rd       : OUT   STD_LOGIC ;
         md_wr       : OUT   STD_LOGIC ;
         md_out      : OUT   STD_LOGIC ;
         ma_in       : OUT   STD_LOGIC ;
         read        : OUT   STD_LOGIC ;
         write       : OUT   STD_LOGIC ;
         add         : OUT   STD_LOGIC ;
         sub         : OUT   STD_LOGIC ;
         andx        : OUT   STD_LOGIC ;
         orx         : OUT   STD_LOGIC ;
         notx        : OUT   STD_LOGIC ;
         neg         : OUT   STD_LOGIC ;
         c_eq_b      : OUT   STD_LOGIC ;
         inc4        : OUT   STD_LOGIC ;
         shr         : OUT   STD_LOGIC ;
         shra        : OUT   STD_LOGIC ;
         shl         : OUT   STD_LOGIC ;
         shc         : OUT   STD_LOGIC) ;

END control ;

ARCHITECTURE behavioral of control IS

   TYPE states IS (s0, s1, s2, s3, s4, s5, s6, s7) ;

   SIGNAL state     : states ;
   SIGNAL nxt_state : states ;

   CONSTANT nop_op   : std_logic_vector (4 DOWNTO 0) := "00000" ;
   CONSTANT ld_op    : std_logic_vector (4 DOWNTO 0) := "00001" ;
   CONSTANT ldr_op   : std_logic_vector (4 DOWNTO 0) := "00010" ;
   CONSTANT st_op    : std_logic_vector (4 DOWNTO 0) := "00011" ;
   CONSTANT str_op   : std_logic_vector (4 DOWNTO 0) := "00100" ;
   CONSTANT la_op    : std_logic_vector (4 DOWNTO 0) := "00101" ;
   CONSTANT lar_op   : std_logic_vector (4 DOWNTO 0) := "00110" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "00111" ;
   CONSTANT br_op    : std_logic_vector (4 DOWNTO 0) := "01000" ;
   CONSTANT brl_op   : std_logic_vector (4 DOWNTO 0) := "01001" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "01010" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "01011" ;
   CONSTANT add_op   : std_logic_vector (4 DOWNTO 0) := "01100" ;
   CONSTANT addi_op  : std_logic_vector (4 DOWNTO 0) := "01101" ;
   CONSTANT sub_op   : std_logic_vector (4 DOWNTO 0) := "01110" ;
   CONSTANT neg_op   : std_logic_vector (4 DOWNTO 0) := "01111" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "10000" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "10001" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "10010" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "10011" ;
   CONSTANT and_op   : std_logic_vector (4 DOWNTO 0) := "10100" ;
   CONSTANT andi_op  : std_logic_vector (4 DOWNTO 0) := "10101" ;
   CONSTANT or_op    : std_logic_vector (4 DOWNTO 0) := "10110" ;
   CONSTANT ori_op   : std_logic_vector (4 DOWNTO 0) := "10111" ;
   CONSTANT not_op   : std_logic_vector (4 DOWNTO 0) := "11000" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "11001" ;
   CONSTANT shr_op   : std_logic_vector (4 DOWNTO 0) := "11010" ;
   CONSTANT shra_op  : std_logic_vector (4 DOWNTO 0) := "11011" ;
   CONSTANT shl_op   : std_logic_vector (4 DOWNTO 0) := "11100" ;
   CONSTANT shc_op   : std_logic_vector (4 DOWNTO 0) := "11101" ;
---CONSTANT unused_op: std_logic_vector (4 DOWNTO 0) := "11110" ;
   CONSTANT stop_op  : std_logic_vector (4 DOWNTO 0) := "11111" ;

BEGIN

   clkd:PROCESS(clk)
      BEGIN
         IF (clk'EVENT AND clk='1') THEN
            IF (reset_l = '0') THEN 
               state <= s0;
            ELSE
               state <= nxt_state;
            END IF;
         END IF;
      END PROCESS clkd;

   state_trans:PROCESS(opcode,state,done)
      BEGIN
      CASE state IS
         WHEN s0 => nxt_state <= s1 ;
         WHEN s1 => IF (done = '1') THEN
                       nxt_state <= s2 ;
                    ELSE
                       nxt_state <= s1 ;
                    END IF ;
         WHEN s2 => nxt_state <= s3 ;
         WHEN s3 => IF ((opcode=nop_op) OR (opcode=br_op)) THEN
                       nxt_state <= s0 ;
                    ELSIF (opcode=stop_op) THEN
                       nxt_state <= s3 ;
                    ELSE
                       nxt_state <= s4 ;
                    END IF;
         WHEN S4 => IF (opcode=brl_op OR opcode=neg_op OR opcode=not_op OR
                        opcode=shr_op OR opcode=shl_op OR opcode=shra_op OR
                        opcode=shc_op)THEN
                       nxt_state <= s0 ;
                    ELSE
                       nxt_state <= s5 ;
                    END IF;
         WHEN S5 => IF ((opcode=and_op) OR (opcode=andi_op) OR
                        (opcode=or_op) OR (opcode=ori_op) OR
                        (opcode=add_op) OR (opcode=addi_op) OR
                        (opcode=sub_op) OR (opcode=la_op) OR
                        (opcode=lar_op)) THEN
                       nxt_state <= s0 ;
                    ELSE
                       nxt_state <= s6 ;
                    END IF ;
         WHEN S6 => IF ((opcode=ld_op OR opcode=ldr_op) AND (done = '0')) THEN
                       nxt_state <= s6 ;
                    ELSE
                       nxt_state <= s7 ;
                    END IF ;
         WHEN S7 => IF ((opcode=st_op OR opcode=str_op) AND (done = '0')) THEN
                       nxt_state <= s7 ;
                    ELSE
                       nxt_state <= s0 ;
                    END IF ;
      END CASE ;
   END PROCESS state_trans ;

   output:PROCESS(state,opcode,con,done) 
   BEGIN

         a_in      <= '0' ;   
         c_in      <= '0' ;
         c_out     <= '0' ;
         pc_in     <= '0' ;
         pc_out    <= '0' ;
         c1_out    <= '0' ;
         c2_out    <= '0' ;
         ir_in     <= '0' ;
         gra       <= '0' ;
         grb       <= '0' ;
         grc       <= '0' ;
         r_in      <= '0' ;
         r_out     <= '0' ;
         ba_out    <= '0' ;
         md_bus    <= '0' ;
         md_rd     <= '0' ;
         md_wr     <= '0' ;
         md_out    <= '0' ;
         ma_in     <= '0' ;
         read      <= '0' ;
         write     <= '0' ;
         add       <= '0' ;
         sub       <= '0' ;
         andx      <= '0' ;
         orx       <= '0' ;
         notx      <= '0' ;
         neg       <= '0' ;
         c_eq_b    <= '0' ;
         inc4      <= '0' ;
         shr       <= '0' ;
         shra      <= '0' ;
         shl       <= '0' ;
         shc       <= '0' ;  

      CASE state IS

         WHEN s0 =>

            pc_out <= '1' ; 
            ma_in  <= '1' ;
            inc4   <= '1' ;
            c_in   <= '1' ;

         WHEN s1 =>

            c_out  <= '1' ; 
            pc_in  <= '1' ;
            md_rd  <= '1' ;
            read   <= '1' ;

         WHEN s2 =>

            md_out <= '1' ; 
            ir_in  <= '1' ;
 
         WHEN s3 =>

            IF (opcode=add_op OR opcode=addi_op OR opcode=and_op OR opcode=andi_op OR 
                opcode=or_op OR opcode=ori_op or opcode=sub_op) THEN
               grb   <= '1' ;
               r_out <= '1' ;
               a_in  <= '1' ;
            ELSIF (opcode=br_op) THEN
               grb    <= '1' ;
               r_out  <= '1' ;
               IF (con = '1') THEN
                  pc_in <= '1' ;
               END IF ;
            ELSIF (opcode=brl_op) THEN 
               gra    <= '1' ;
               r_in   <= '1' ;
               pc_out <= '1' ;
            ELSIF (opcode=st_op OR opcode=la_op OR opcode=ld_op) THEN
               grb    <= '1' ;
               ba_out <= '1' ;
               a_in   <= '1' ;
            ELSIF (opcode=ldr_op OR opcode=str_op OR opcode=lar_op) THEN
               pc_out <= '1' ;
               a_in   <= '1' ;
            ELSIF (opcode=shc_op OR opcode=shl_op OR opcode=shr_op OR opcode=shra_op) THEN
               grb    <= '1' ;
               r_out  <= '1' ;
               c_in   <= '1' ;
               IF (opcode=shc_op) THEN
                  shc <= '1' ;
               ELSIF (opcode=shl_op) THEN
                  shl <= '1' ;
               ELSIF (opcode=shr_op) THEN
                  shr <= '1' ;
               ELSE
                  shra <= '1' ;
               END IF ;
            ELSIF (opcode=neg_op OR opcode=not_op) THEN
               grc    <= '1' ;
               r_out  <= '1' ;
               c_in   <= '1' ;
               IF (opcode=not_op) THEN
                  notx <= '1' ;
               ELSIF (opcode=neg_op) THEN
                  neg <= '1' ;
               END IF ;
            END IF ; -- (nop and stop make no assignments)           

        WHEN s4 =>

            IF (opcode=add_op OR opcode=and_op OR opcode=or_op OR opcode=sub_op) THEN
               grc   <= '1' ;
               r_out <= '1' ;
               c_in  <= '1' ;
               IF (opcode=and_op) THEN
                  andx <= '1' ;
               ELSIF (opcode=or_op) THEN
                  orx <= '1' ;
               ELSIF (opcode=sub_op) THEN
                  sub <= '1' ;
               ELSE
                  add <= '1' ;
               END IF ;
            ELSIF (opcode=addi_op OR opcode=andi_op OR opcode=ori_op) THEN
               c2_out  <= '1' ;
               c_in  <= '1' ;
               IF (opcode=addi_op) THEN
                  add <= '1' ;
               ELSIF (opcode=andi_op) THEN
                  andx <= '1' ;
               ELSE
                  orx <= '1' ;
               END IF ;
            ELSIF (opcode=brl_op) THEN 
               grb    <= '1' ;
               r_out  <= '1' ;
               IF (con = '1') THEN
                  pc_in  <= '1' ;
               END IF ;
            ELSIF (opcode=st_op OR opcode=la_op OR opcode=ld_op) THEN
               c2_out <= '1' ;
               add    <= '1' ;
               c_in   <= '1' ;
            ELSIF (opcode=ldr_op OR opcode=str_op OR opcode=lar_op) THEN
               c1_out <= '1' ;
               add    <= '1' ;
               c_in   <= '1' ;
            ELSIF (opcode=neg_op OR opcode=not_op OR opcode=shc_op OR opcode=shl_op OR opcode=shr_op OR opcode=shra_op) THEN
               c_out  <= '1' ;
               gra    <= '1' ;
               r_in   <= '1' ;
            END IF ;

        WHEN s5 =>

            IF (opcode=add_op OR opcode=addi_op OR opcode=and_op OR opcode=andi_op OR 
                opcode=or_op OR opcode=ori_op or opcode=sub_op) THEN
               c_out  <= '1' ;
               gra    <= '1' ;
               r_in   <= '1' ;
            ELSIF (opcode=st_op OR opcode=ld_op) THEN
               c_out  <= '1' ;
               ma_in  <= '1' ;
            ELSIF (opcode=la_op OR opcode=lar_op) THEN
               c_out  <= '1' ;
               gra    <= '1' ;
               r_in   <= '1' ;
            ELSIF (opcode=ldr_op OR opcode=str_op) THEN
               c_out  <= '1' ;
               ma_in  <= '1' ;
            END IF ;       

        WHEN s6 =>

            IF (opcode=st_op) THEN
               gra    <= '1' ;
               r_out  <= '1' ;
               md_bus <= '1' ;
            ELSIF (opcode=ld_op) THEN
               md_rd  <= '1' ;
               read  <= '1' ;
            ELSIF (opcode=ldr_op) THEN
               md_rd  <= '1' ;
               read   <= '1' ;
            ELSIF (opcode=str_op) THEN
               gra    <= '1' ;
               r_out  <= '1' ;
               md_bus <= '1' ;
            END IF ;  
     
        WHEN s7 =>

            IF (opcode=st_op) THEN
               md_wr  <= '1' ;
               write  <= '1' ;
            ELSIF (opcode=ld_op) THEN
               md_out <= '1' ;
               gra    <= '1' ;
               r_in   <= '1' ;
            ELSIF (opcode=ldr_op) THEN
               md_out <= '1' ;
               gra    <= '1' ;
               r_in   <= '1' ;
            ELSIF (opcode=str_op) THEN
               md_wr  <= '1' ;
               write  <= '1' ;
            END IF ;       
            
      END CASE ;
   END PROCESS output ;

END behavioral ; 
