        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:09 2011
        MODULE DSLUGM__genmod
          INTERFACE 
            SUBROUTINE DSLUGM(N,B,X,NELT,IA,JA,A,ISYM,NSAVE,ITOL,TOL,   &
     &ITMAX,ITER,ERR,IERR,IUNIT,RWORK,LENW,IWORK,LENIW)
              INTEGER(KIND=4) :: LENIW
              INTEGER(KIND=4) :: LENW
              INTEGER(KIND=4) :: NELT
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: B(N)
              REAL(KIND=8) :: X(N)
              INTEGER(KIND=4) :: IA(NELT)
              INTEGER(KIND=4) :: JA(NELT)
              REAL(KIND=8) :: A(NELT)
              INTEGER(KIND=4) :: ISYM
              INTEGER(KIND=4) :: NSAVE
              INTEGER(KIND=4) :: ITOL
              REAL(KIND=8) :: TOL
              INTEGER(KIND=4) :: ITMAX
              INTEGER(KIND=4) :: ITER
              REAL(KIND=8) :: ERR
              INTEGER(KIND=4) :: IERR
              INTEGER(KIND=4) :: IUNIT
              REAL(KIND=8) :: RWORK(LENW)
              INTEGER(KIND=4) :: IWORK(LENIW)
            END SUBROUTINE DSLUGM
          END INTERFACE 
        END MODULE DSLUGM__genmod
