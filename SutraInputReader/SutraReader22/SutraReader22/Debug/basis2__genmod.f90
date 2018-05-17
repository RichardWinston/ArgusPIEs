        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE BASIS2__genmod
          INTERFACE 
            SUBROUTINE BASIS2(ICALL,L,XLOC,YLOC,IN,X,Y,F,W,DET,DFDXG,   &
     &DFDYG,DWDXG,DWDYG,PITER,UITER,PVEL,POR,THICK,THICKG,VXG,VYG,SWG,  &
     &RHOG,VISCG,PORG,VGMAG,RELKG,PERMXX,PERMXY,PERMYX,PERMYY,CJ11,CJ12,&
     &CJ21,CJ22,GXSI,GETA,RCIT,RCITM1,RGXG,RGYG,LREG)
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
              INTEGER(KIND=4) :: IN(NIN)
              REAL(KIND=8) :: X(NN)
              REAL(KIND=8) :: Y(NN)
              REAL(KIND=8) :: F(4)
              REAL(KIND=8) :: W(4)
              REAL(KIND=8) :: DET
              REAL(KIND=8) :: DFDXG(4)
              REAL(KIND=8) :: DFDYG(4)
              REAL(KIND=8) :: DWDXG(4)
              REAL(KIND=8) :: DWDYG(4)
              REAL(KIND=8) :: PITER(NN)
              REAL(KIND=8) :: UITER(NN)
              REAL(KIND=8) :: PVEL(NN)
              REAL(KIND=8) :: POR(NN)
              REAL(KIND=8) :: THICK(NN)
              REAL(KIND=8) :: THICKG
              REAL(KIND=8) :: VXG
              REAL(KIND=8) :: VYG
              REAL(KIND=8) :: SWG
              REAL(KIND=8) :: RHOG
              REAL(KIND=8) :: VISCG
              REAL(KIND=8) :: PORG
              REAL(KIND=8) :: VGMAG
              REAL(KIND=8) :: RELKG
              REAL(KIND=8) :: PERMXX(NE)
              REAL(KIND=8) :: PERMXY(NE)
              REAL(KIND=8) :: PERMYX(NE)
              REAL(KIND=8) :: PERMYY(NE)
              REAL(KIND=8) :: CJ11
              REAL(KIND=8) :: CJ12
              REAL(KIND=8) :: CJ21
              REAL(KIND=8) :: CJ22
              REAL(KIND=8) :: GXSI(NE,4)
              REAL(KIND=8) :: GETA(NE,4)
              REAL(KIND=8) :: RCIT(NN)
              REAL(KIND=8) :: RCITM1(NN)
              REAL(KIND=8) :: RGXG
              REAL(KIND=8) :: RGYG
              INTEGER(KIND=4) :: LREG(NE)
            END SUBROUTINE BASIS2
          END INTERFACE 
        END MODULE BASIS2__genmod
