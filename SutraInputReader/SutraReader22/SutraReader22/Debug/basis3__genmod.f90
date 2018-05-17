        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE BASIS3__genmod
          INTERFACE 
            SUBROUTINE BASIS3(ICALL,L,XLOC,YLOC,ZLOC,IN,X,Y,Z,F,W,DET,  &
     &DFDXG,DFDYG,DFDZG,DWDXG,DWDYG,DWDZG,PITER,UITER,PVEL,POR,VXG,VYG, &
     &VZG,SWG,RHOG,VISCG,PORG,VGMAG,RELKG,PERMXX,PERMXY,PERMXZ,PERMYX,  &
     &PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ,CJ11,CJ12,CJ13,CJ21,CJ22,CJ23, &
     &CJ31,CJ32,CJ33,GXSI,GETA,GZET,RCIT,RCITM1,RGXG,RGYG,RGZG,LREG)
              COMMON/DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,NSOP, &
     &NSOU,NBCN,NCIDB
                INTEGER(KIND=4) :: NN
                INTEGER(KIND=4) :: NE
                INTEGER(KIND=4) :: NIN
                INTEGER(KIND=4) :: NBI
                INTEGER(KIND=4) :: NCBI
                INTEGER(KIND=4) :: NB
                INTEGER(KIND=4) :: NBHALF
                INTEGER(KIND=4) :: NPBC
                INTEGER(KIND=4) :: NUBC
                INTEGER(KIND=4) :: NSOP
                INTEGER(KIND=4) :: NSOU
                INTEGER(KIND=4) :: NBCN
                INTEGER(KIND=4) :: NCIDB
              INTEGER(KIND=4) :: ICALL
              INTEGER(KIND=4) :: L
              REAL(KIND=8) :: XLOC
              REAL(KIND=8) :: YLOC
              REAL(KIND=8) :: ZLOC
              INTEGER(KIND=4) :: IN(NIN)
              REAL(KIND=8) :: X(NN)
              REAL(KIND=8) :: Y(NN)
              REAL(KIND=8) :: Z(NN)
              REAL(KIND=8) :: F(8)
              REAL(KIND=8) :: W(8)
              REAL(KIND=8) :: DET
              REAL(KIND=8) :: DFDXG(8)
              REAL(KIND=8) :: DFDYG(8)
              REAL(KIND=8) :: DFDZG(8)
              REAL(KIND=8) :: DWDXG(8)
              REAL(KIND=8) :: DWDYG(8)
              REAL(KIND=8) :: DWDZG(8)
              REAL(KIND=8) :: PITER(NN)
              REAL(KIND=8) :: UITER(NN)
              REAL(KIND=8) :: PVEL(NN)
              REAL(KIND=8) :: POR(NN)
              REAL(KIND=8) :: VXG
              REAL(KIND=8) :: VYG
              REAL(KIND=8) :: VZG
              REAL(KIND=8) :: SWG
              REAL(KIND=8) :: RHOG
              REAL(KIND=8) :: VISCG
              REAL(KIND=8) :: PORG
              REAL(KIND=8) :: VGMAG
              REAL(KIND=8) :: RELKG
              REAL(KIND=8) :: PERMXX(NE)
              REAL(KIND=8) :: PERMXY(NE)
              REAL(KIND=8) :: PERMXZ(NE)
              REAL(KIND=8) :: PERMYX(NE)
              REAL(KIND=8) :: PERMYY(NE)
              REAL(KIND=8) :: PERMYZ(NE)
              REAL(KIND=8) :: PERMZX(NE)
              REAL(KIND=8) :: PERMZY(NE)
              REAL(KIND=8) :: PERMZZ(NE)
              REAL(KIND=8) :: CJ11
              REAL(KIND=8) :: CJ12
              REAL(KIND=8) :: CJ13
              REAL(KIND=8) :: CJ21
              REAL(KIND=8) :: CJ22
              REAL(KIND=8) :: CJ23
              REAL(KIND=8) :: CJ31
              REAL(KIND=8) :: CJ32
              REAL(KIND=8) :: CJ33
              REAL(KIND=8) :: GXSI(NE,8)
              REAL(KIND=8) :: GETA(NE,8)
              REAL(KIND=8) :: GZET(NE,8)
              REAL(KIND=8) :: RCIT(NN)
              REAL(KIND=8) :: RCITM1(NN)
              REAL(KIND=8) :: RGXG
              REAL(KIND=8) :: RGYG
              REAL(KIND=8) :: RGZG
              INTEGER(KIND=4) :: LREG(NE)
            END SUBROUTINE BASIS3
          END INTERFACE 
        END MODULE BASIS3__genmod
