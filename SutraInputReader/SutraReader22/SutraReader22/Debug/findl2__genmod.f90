        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE FINDL2__genmod
          INTERFACE 
            SUBROUTINE FINDL2(X,Y,IN,LL,XK,YK,XSI,ETA,INOUT)
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
              REAL(KIND=8) :: X(NN)
              REAL(KIND=8) :: Y(NN)
              INTEGER(KIND=4) :: IN(NE*4)
              INTEGER(KIND=4) :: LL
              REAL(KIND=8) :: XK
              REAL(KIND=8) :: YK
              REAL(KIND=8) :: XSI
              REAL(KIND=8) :: ETA
              INTEGER(KIND=4) :: INOUT
            END SUBROUTINE FINDL2
          END INTERFACE 
        END MODULE FINDL2__genmod
