        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE BC__genmod
          INTERFACE 
            SUBROUTINE BC(ML,PMAT,PVEC,UMAT,UVEC,IPBC,PBC,IUBC,UBC,     &
     &QPLITR,JA,GNUP1,GNUU1)
              COMMON/DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48
                INTEGER(KIND=4) :: NWI
                INTEGER(KIND=4) :: NWF
                INTEGER(KIND=4) :: NWL
                INTEGER(KIND=4) :: NELT
                INTEGER(KIND=4) :: NNNX
                INTEGER(KIND=4) :: NEX
                INTEGER(KIND=4) :: N48
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
              COMMON/DIMX2/ NELTA,NNVEC,NDIMIA,NDIMJA
                INTEGER(KIND=4) :: NELTA
                INTEGER(KIND=4) :: NNVEC
                INTEGER(KIND=4) :: NDIMIA
                INTEGER(KIND=4) :: NDIMJA
              INTEGER(KIND=4) :: ML
              REAL(KIND=8) :: PMAT(NELT,NCBI)
              REAL(KIND=8) :: PVEC(NNVEC)
              REAL(KIND=8) :: UMAT(NELT,NCBI)
              REAL(KIND=8) :: UVEC(NNVEC)
              INTEGER(KIND=4) :: IPBC(NBCN)
              REAL(KIND=8) :: PBC(NBCN)
              INTEGER(KIND=4) :: IUBC(NBCN)
              REAL(KIND=8) :: UBC(NBCN)
              REAL(KIND=8) :: QPLITR(NBCN)
              INTEGER(KIND=4) :: JA(NDIMJA)
              REAL(KIND=8) :: GNUP1(NBCN)
              REAL(KIND=8) :: GNUU1(NBCN)
            END SUBROUTINE BC
          END INTERFACE 
        END MODULE BC__genmod
