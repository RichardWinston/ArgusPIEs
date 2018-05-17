        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:11 2011
        MODULE INDAT1__genmod
          INTERFACE 
            SUBROUTINE INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,  &
     &ATMIN,PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,    &
     &PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG,OBSPTS,INPUTFILE)
              USE ALLARR, ONLY :                                        &
     &          OBSDAT
              COMMON/OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX
                INTEGER(KIND=4) :: NOBSN
                INTEGER(KIND=4) :: NTOBS
                INTEGER(KIND=4) :: NOBCYC
                INTEGER(KIND=4) :: NOBLIN
                INTEGER(KIND=4) :: NFLOMX
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
              COMMON/DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48
                INTEGER(KIND=4) :: NWI
                INTEGER(KIND=4) :: NWF
                INTEGER(KIND=4) :: NWL
                INTEGER(KIND=4) :: NELT
                INTEGER(KIND=4) :: NNNX
                INTEGER(KIND=4) :: NEX
                INTEGER(KIND=4) :: N48
              REAL(KIND=8) :: X(NN)
              REAL(KIND=8) :: Y(NN)
              REAL(KIND=8) :: Z(NN)
              REAL(KIND=8) :: POR(NN)
              REAL(KIND=8) :: ALMAX(NE)
              REAL(KIND=8) :: ALMID(NEX)
              REAL(KIND=8) :: ALMIN(NE)
              REAL(KIND=8) :: ATMAX(NE)
              REAL(KIND=8) :: ATMID(NEX)
              REAL(KIND=8) :: ATMIN(NE)
              REAL(KIND=8) :: PERMXX(NE)
              REAL(KIND=8) :: PERMXY(NE)
              REAL(KIND=8) :: PERMXZ(NEX)
              REAL(KIND=8) :: PERMYX(NE)
              REAL(KIND=8) :: PERMYY(NE)
              REAL(KIND=8) :: PERMYZ(NEX)
              REAL(KIND=8) :: PERMZX(NEX)
              REAL(KIND=8) :: PERMZY(NEX)
              REAL(KIND=8) :: PERMZZ(NEX)
              REAL(KIND=8) :: PANGL1(NE)
              REAL(KIND=8) :: PANGL2(NEX)
              REAL(KIND=8) :: PANGL3(NEX)
              REAL(KIND=8) :: SOP(NN)
              INTEGER(KIND=4) :: NREG(NN)
              INTEGER(KIND=4) :: LREG(NE)
              TYPE (OBSDAT) :: OBSPTS(NOBSN)
              CHARACTER(*), INTENT(IN) :: INPUTFILE
            END SUBROUTINE INDAT1
          END INTERFACE 
        END MODULE INDAT1__genmod
