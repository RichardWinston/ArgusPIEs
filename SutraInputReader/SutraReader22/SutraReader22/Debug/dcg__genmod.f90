        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:08 2011
        MODULE DCG__genmod
          INTERFACE 
            SUBROUTINE DCG(N,B,X,NELT,IA,JA,A,ISYM,MATVEC,MSOLVE,ITOL,  &
     &TOL,ITMAX,ITER,ERR,IERR,IUNIT,R,Z,P,DZ,RWORK,IWORK)
              INTEGER(KIND=4) :: NELT
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: B(N)
              REAL(KIND=8) :: X(N)
              INTEGER(KIND=4) :: IA(NELT)
              INTEGER(KIND=4) :: JA(NELT)
              REAL(KIND=8) :: A(NELT)
              INTEGER(KIND=4) :: ISYM
              EXTERNAL MATVEC
              EXTERNAL MSOLVE
              INTEGER(KIND=4) :: ITOL
              REAL(KIND=8) :: TOL
              INTEGER(KIND=4) :: ITMAX
              INTEGER(KIND=4) :: ITER
              REAL(KIND=8) :: ERR
              INTEGER(KIND=4) :: IERR
              INTEGER(KIND=4) :: IUNIT
              REAL(KIND=8) :: R(N)
              REAL(KIND=8) :: Z(N)
              REAL(KIND=8) :: P(N)
              REAL(KIND=8) :: DZ(N)
              REAL(KIND=8) :: RWORK(*)
              INTEGER(KIND=4) :: IWORK(*)
            END SUBROUTINE DCG
          END INTERFACE 
        END MODULE DCG__genmod
