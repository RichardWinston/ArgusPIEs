        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE ADSORB__genmod
          INTERFACE 
            SUBROUTINE ADSORB(CS1,CS2,CS3,SL,SR,U)
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
              REAL(KIND=8) :: CS1(NN)
              REAL(KIND=8) :: CS2(NN)
              REAL(KIND=8) :: CS3(NN)
              REAL(KIND=8) :: SL(NN)
              REAL(KIND=8) :: SR(NN)
              REAL(KIND=8) :: U(NN)
            END SUBROUTINE ADSORB
          END INTERFACE 
        END MODULE ADSORB__genmod
