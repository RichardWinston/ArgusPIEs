        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE SOURCE1__genmod
          INTERFACE 
            SUBROUTINE SOURCE1(QIN1,UIN1,IQSOP1,QUIN1,IQSOU1,IQSOPT1,   &
     &IQSOUT1,NSOP1,NSOU1,NFB,BCSID)
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
              INTEGER(KIND=4) :: NSOU1
              INTEGER(KIND=4) :: NSOP1
              REAL(KIND=8) :: QIN1(NN)
              REAL(KIND=8) :: UIN1(NN)
              INTEGER(KIND=4) :: IQSOP1(NSOP1)
              REAL(KIND=8) :: QUIN1(NN)
              INTEGER(KIND=4) :: IQSOU1(NSOU1)
              INTEGER(KIND=4) :: IQSOPT1
              INTEGER(KIND=4) :: IQSOUT1
              INTEGER(KIND=4) :: NFB
              CHARACTER(LEN=40) :: BCSID
            END SUBROUTINE SOURCE1
          END INTERFACE 
        END MODULE SOURCE1__genmod
