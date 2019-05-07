--- 2016 RSRC VHDL Code 
--- Current file name:  src.vhd
--- Last Revised:  11/23/2016; 8:30 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY rsrc IS
   PORT(clk      : IN    STD_LOGIC ;
        reset_l  : IN    STD_LOGIC ;
        d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        address  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        read     : OUT   STD_LOGIC ;
        write    : OUT   STD_LOGIC ;
        done     : IN    STD_LOGIC) ;
END rsrc ;

architecture structure of rsrc is

   COMPONENT pc 
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk     : IN  STD_LOGIC ;
         pc_in   : IN  STD_LOGIC ;
         pc_out  : IN  STD_LOGIC ;
         reset_l : IN  STD_LOGIC ;
         bus_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
   END COMPONENT ;

   COMPONENT a
   PORT (bus_in : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         a      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk    : IN  STD_LOGIC ;
         a_in   : IN  STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT c
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk     : IN  STD_LOGIC ;
         c_in    : IN  STD_LOGIC ;
         c_out   : IN  STD_LOGIC ;
         bus_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
   END COMPONENT ;

   COMPONENT alu
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
   END COMPONENT ;

   COMPONENT shiftcounter
   PORT (rrc       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         ir        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         n         : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)) ;
   END COMPONENT ;

   COMPONENT regfile
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
   END COMPONENT ;

   COMPONENT ma
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk     : IN  STD_LOGIC ;
         ma_in   : IN  STD_LOGIC) ;
   END COMPONENT ;


   COMPONENT md
   PORT (bus_in   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk      : IN  STD_LOGIC ;
         md_rd    : IN  STD_LOGIC ;
         md_wr    : IN  STD_LOGIC ;
         md_out   : IN  STD_LOGIC ;
         md_bus   : IN  STD_LOGIC ;
         d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         bus_out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
   END COMPONENT ;

   COMPONENT ir
   PORT (bus_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         clk     : IN  STD_LOGIC ;
         c1_out  : IN  STD_LOGIC ;
         c2_out  : IN  STD_LOGIC ;
         ir_in   : IN  STD_LOGIC ;
         bus_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ; 
         ir      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)) ;
   END COMPONENT ;

   COMPONENT conbit
   PORT (bus_in   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         ir       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         con      : OUT STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT control
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
   END COMPONENT ;

   SIGNAL con       : STD_LOGIC ;
   SIGNAL a_in      : STD_LOGIC ;
   SIGNAL c_in      : STD_LOGIC ;
   SIGNAL c_out     : STD_LOGIC ;
   SIGNAL pc_in     : STD_LOGIC ;
   SIGNAL pc_out    : STD_LOGIC ;
   SIGNAL c1_out    : STD_LOGIC ;
   SIGNAL c2_out    : STD_LOGIC ;
   SIGNAL ir_in     : STD_LOGIC ;
   SIGNAL gra       : STD_LOGIC ;
   SIGNAL grb       : STD_LOGIC ;
   SIGNAL grc       : STD_LOGIC ;
   SIGNAL r_in      : STD_LOGIC ;
   SIGNAL r_out     : STD_LOGIC ;
   SIGNAL ba_out    : STD_LOGIC ;
   SIGNAL md_bus    : STD_LOGIC ;
   SIGNAL md_rd     : STD_LOGIC ;
   SIGNAL md_wr     : STD_LOGIC ;
   SIGNAL md_out    : STD_LOGIC ;
   SIGNAL ma_in     : STD_LOGIC ;
   SIGNAL add       : STD_LOGIC ;
   SIGNAL sub       : STD_LOGIC ;
   SIGNAL andx      : STD_LOGIC ;
   SIGNAL orx       : STD_LOGIC ;
   SIGNAL notx      : STD_LOGIC ;
   SIGNAL neg       : STD_LOGIC ;
   SIGNAL c_eq_b    : STD_LOGIC ;
   SIGNAL inc4      : STD_LOGIC ;
   SIGNAL shr       : STD_LOGIC ;
   SIGNAL shra      : STD_LOGIC ;
   SIGNAL shl       : STD_LOGIC ;
   SIGNAL shc       : STD_LOGIC ;
   SIGNAL n         : STD_LOGIC_VECTOR(4 DOWNTO 0) ;
   SIGNAL cpu_bus   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL a_bus     : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL c_bus     : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL ir_bus    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL rrc_bus   : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN

   rsrcpc:pc 
   PORT MAP(bus_in   => cpu_bus ,
            clk      => clk ,
            pc_in    => pc_in ,
            pc_out   => pc_out ,
            reset_l  => reset_l ,
            bus_out  => cpu_bus) ;

   rsrcareg:a
   PORT MAP(bus_in   => cpu_bus ,
            a        => a_bus ,
            clk      => clk ,
            a_in     => a_in) ;

   rsrccreg:c
   PORT MAP(bus_in   => c_bus ,
            clk      => clk ,
            c_in     => c_in ,
            c_out    => c_out ,
            bus_out  => cpu_bus) ;

   rsrcalu:alu
   PORT MAP(a        => a_bus ,
            b        => cpu_bus ,
            add      => add ,  
            sub      => sub ,
            andx     => andx ,
            c_eq_b   => c_eq_b ,
            inc4     => inc4 ,
            neg      => neg ,
            shr      => shr ,
            shl      => shl ,
            shc      => shc ,
            shra     => shra ,
            orx      => orx ,
            notx     => notx ,
            n        => n ,
            c        => c_bus) ;

   rsrcshiftcounter:shiftcounter
   PORT MAP(rrc      => rrc_bus , 
            ir       => ir_bus , 
            n        => n) ;

   rsrcregfile:regfile
   PORT MAP(bus_in   => cpu_bus ,
            ir       => ir_bus ,
            r_in     => r_in ,
            r_out    => r_out ,
            ba_out   => ba_out ,
            gra      => gra ,
            grb      => grb ,
            grc      => grc ,
            clk      => clk ,
            rrc      => rrc_bus ,
            bus_out  => cpu_bus) ;

   rsrcmareg:ma
   PORT MAP(bus_in   => cpu_bus ,
            address  => address ,
            clk      => clk ,
            ma_in    => ma_in) ;

   rsrcmdreg:md
   PORT MAP(bus_in   => cpu_bus ,
            clk      => clk ,
            md_rd    => md_rd ,
            md_wr    => md_wr ,
            md_out   => md_out ,
            md_bus   => md_bus ,
            d        => d ,
            bus_out  => cpu_bus) ;

   rsrcirreg:ir
   PORT MAP(bus_in   => cpu_bus ,
            clk      => clk ,
            c1_out   => c1_out ,
            c2_out   => c2_out ,
            ir_in    => ir_in ,
            bus_out  => cpu_bus ,
            ir       => ir_bus) ;

   rsrcconbit:conbit
   PORT MAP(bus_in   => rrc_bus ,
            ir       => ir_bus ,
            con      => con) ;

   rsrccontrol:control
   PORT MAP(clk      => clk , 
            opcode   => ir_bus(31 DOWNTO 27) , 
            con       => con ,
            done      => done , 
            reset_l   => reset_l ,
            a_in      => a_in ,
            c_in      => c_in ,
            c_out     => c_out ,
            pc_in     => pc_in ,
            pc_out    => pc_out ,
            c1_out    => c1_out ,
            c2_out    => c2_out ,
            ir_in     => ir_in ,
            gra       => gra ,
            grb       => grb ,
            grc       => grc ,
            r_in      => r_in ,
            r_out     => r_out ,
            ba_out    => ba_out ,
            md_bus    => md_bus ,
            md_rd     => md_rd ,
            md_wr     => md_wr ,
            md_out    => md_out ,
            ma_in     => ma_in ,
            read      => read ,
            write     => write ,
            add       => add ,
            sub       => sub ,
            andx      => andx ,
            orx       => orx ,
            notx      => notx ,
            neg       => neg ,
            c_eq_b    => c_eq_b ,
            inc4      => inc4 ,
            shr       => shr ,
            shra      => shra ,
            shl       => shl ,
            shc       => shc) ;

END structure;
