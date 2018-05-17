        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE BCSTEP__genmod
          INTERFACE 
            SUBROUTINE BCSTEP(SETBCS,IPBC,PBC,IUBC,UBC,QIN,UIN,QUIN,    &
     &IQSOP,IQSOU,IPBCT1,IUBCT1,IQSOPT1,IQSOUT1,GNUP1,GNUU1,IBCPBC,     &
     &IBCUBC,IBCSOP,IBCSOU,IIDPBC,IIDUBC,IIDSOP,IIDSOU,NCID,BCSFL,BCSTR)
              COMMON/TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR&
     &,TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART
                REAL(KIND=8) :: DELT
                REAL(KIND=8) :: TSEC
                REAL(KIND=8) :: TMIN
                REAL(KIND=8) :: THOUR
                REAL(KIND=8) :: TDAY
                REAL(KIND=8) :: TWEEK
                REAL(KIND=8) :: TMONTH
                REAL(KIND=8) :: TYEAR
                REAL(KIND=8) :: TMAX
                REAL(KIND=8) :: DELTP
                REAL(KIND=8) :: DELTU
                REAL(KIND=8) :: DLTPM1
                REAL(KIND=8) :: DLTUM1
                INTEGER(KIND=4) :: IT
                INTEGER(KIND=4) :: ITBCS
                INTEGER(KIND=4) :: ITRST
                INTEGER(KIND=4) :: ITMAX
                REAL(KIND=8) :: TSTART
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
              LOGICAL(KIND=4) :: SETBCS
              INTEGER(KIND=4) :: IPBC(NBCN)
              REAL(KIND=8) :: PBC(NBCN)
              INTEGER(KIND=4) :: IUBC(NBCN)
              REAL(KIND=8) :: UBC(NBCN)
              REAL(KIND=8) :: QIN(NN)
              REAL(KIND=8) :: UIN(NN)
              REAL(KIND=8) :: QUIN(NN)
              INTEGER(KIND=4) :: IQSOP(NSOP)
              INTEGER(KIND=4) :: IQSOU(NSOU)
              INTEGER(KIND=4) :: IPBCT1
              INTEGER(KIND=4) :: IUBCT1
              INTEGER(KIND=4) :: IQSOPT1
              INTEGER(KIND=4) :: IQSOUT1
              REAL(KIND=8) :: GNUP1(NBCN)
              REAL(KIND=8) :: GNUU1(NBCN)
              INTEGER(KIND=1) :: IBCPBC(NBCN)
              INTEGER(KIND=1) :: IBCUBC(NBCN)
              INTEGER(KIND=1) :: IBCSOP(NSOP)
              INTEGER(KIND=1) :: IBCSOU(NSOU)
              INTEGER(KIND=4) :: IIDPBC(NBCN)
              INTEGER(KIND=4) :: IIDUBC(NBCN)
              INTEGER(KIND=4) :: IIDSOP(NSOP)
              INTEGER(KIND=4) :: IIDSOU(NSOU)
              INTEGER(KIND=4) :: NCID
              LOGICAL(KIND=4) :: BCSFL(0:ITMAX)
              LOGICAL(KIND=4) :: BCSTR(0:ITMAX)
            END SUBROUTINE BCSTEP
          END INTERFACE 
        END MODULE BCSTEP__genmod
