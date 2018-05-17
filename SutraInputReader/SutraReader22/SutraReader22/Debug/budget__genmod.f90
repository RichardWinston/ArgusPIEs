        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE BUDGET__genmod
          INTERFACE 
            SUBROUTINE BUDGET(ML,IBCT,VOL,SW,DSWDP,RHO,SOP,QIN,PVEC,PM1,&
     &DPDTITR,PBC,QPLITR,IPBC,IQSOP,POR,UVEC,UM1,UM2,UIN,QUIN,QINITR,   &
     &IQSOU,UBC,IUBC,CS1,CS2,CS3,SL,SR,NREG,GNUP1,GNUU1,IBCSOP,IBCSOU)
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
              INTEGER(KIND=4) :: IBCT
              REAL(KIND=8) :: VOL(NN)
              REAL(KIND=8) :: SW(NN)
              REAL(KIND=8) :: DSWDP(NN)
              REAL(KIND=8) :: RHO(NN)
              REAL(KIND=8) :: SOP(NN)
              REAL(KIND=8) :: QIN(NN)
              REAL(KIND=8) :: PVEC(NNVEC)
              REAL(KIND=8) :: PM1(NN)
              REAL(KIND=8) :: DPDTITR(NN)
              REAL(KIND=8) :: PBC(NBCN)
              REAL(KIND=8) :: QPLITR(NBCN)
              INTEGER(KIND=4) :: IPBC(NBCN)
              INTEGER(KIND=4) :: IQSOP(NSOP)
              REAL(KIND=8) :: POR(NN)
              REAL(KIND=8) :: UVEC(NNVEC)
              REAL(KIND=8) :: UM1(NN)
              REAL(KIND=8) :: UM2(NN)
              REAL(KIND=8) :: UIN(NN)
              REAL(KIND=8) :: QUIN(NN)
              REAL(KIND=8) :: QINITR(NN)
              INTEGER(KIND=4) :: IQSOU(NSOU)
              REAL(KIND=8) :: UBC(NBCN)
              INTEGER(KIND=4) :: IUBC(NBCN)
              REAL(KIND=8) :: CS1(NN)
              REAL(KIND=8) :: CS2(NN)
              REAL(KIND=8) :: CS3(NN)
              REAL(KIND=8) :: SL(NN)
              REAL(KIND=8) :: SR(NN)
              INTEGER(KIND=4) :: NREG(NN)
              REAL(KIND=8) :: GNUP1(NBCN)
              REAL(KIND=8) :: GNUU1(NBCN)
              INTEGER(KIND=1) :: IBCSOP(NSOP)
              INTEGER(KIND=1) :: IBCSOU(NSOU)
            END SUBROUTINE BUDGET
          END INTERFACE 
        END MODULE BUDGET__genmod
