        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:06 2011
        MODULE BCTIME__genmod
          INTERFACE 
            SUBROUTINE BCTIME(IPBC,PBC,IUBC,UBC,QIN,UIN,QUIN,IQSOP,IQSOU&
     &,IPBCT,IUBCT,IQSOPT,IQSOUT,X,Y,Z,IBCPBC,IBCUBC,IBCSOP,IBCSOU)
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
              INTEGER(KIND=4) :: IPBC(NBCN)
              REAL(KIND=8) :: PBC(NBCN)
              INTEGER(KIND=4) :: IUBC(NBCN)
              REAL(KIND=8) :: UBC(NBCN)
              REAL(KIND=8) :: QIN(NN)
              REAL(KIND=8) :: UIN(NN)
              REAL(KIND=8) :: QUIN(NN)
              INTEGER(KIND=4) :: IQSOP(NSOP)
              INTEGER(KIND=4) :: IQSOU(NSOU)
              INTEGER(KIND=4) :: IPBCT
              INTEGER(KIND=4) :: IUBCT
              INTEGER(KIND=4) :: IQSOPT
              INTEGER(KIND=4) :: IQSOUT
              REAL(KIND=8) :: X(NN)
              REAL(KIND=8) :: Y(NN)
              REAL(KIND=8) :: Z(NN)
              INTEGER(KIND=1) :: IBCPBC(NBCN)
              INTEGER(KIND=1) :: IBCUBC(NBCN)
              INTEGER(KIND=1) :: IBCSOP(NSOP)
              INTEGER(KIND=1) :: IBCSOU(NSOU)
            END SUBROUTINE BCTIME
          END INTERFACE 
        END MODULE BCTIME__genmod
