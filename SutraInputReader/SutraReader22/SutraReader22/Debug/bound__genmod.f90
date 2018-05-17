        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:09 2011
        MODULE BOUND__genmod
          INTERFACE 
            SUBROUTINE BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT,IBCPBC,IBCUBC&
     &,GNUP1,GNUU1)
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
              INTEGER(KIND=4) :: IPBCT
              INTEGER(KIND=4) :: IUBCT
              INTEGER(KIND=1) :: IBCPBC(NBCN)
              INTEGER(KIND=1) :: IBCUBC(NBCN)
              REAL(KIND=8) :: GNUP1(NBCN)
              REAL(KIND=8) :: GNUU1(NBCN)
            END SUBROUTINE BOUND
          END INTERFACE 
        END MODULE BOUND__genmod
