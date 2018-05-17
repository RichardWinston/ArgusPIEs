        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:09 2011
        MODULE DGMRES__genmod
          INTERFACE 
            SUBROUTINE DGMRES(N,B,X,NELT,IA,JA,A,ISYM,MATVEC,MSOLVE,ITOL&
     &,TOL,ITMAX,ITER,ERR,IERR,IUNIT,SB,SX,RGWK,LRGW,IGWK,LIGW,RWORK,   &
     &IWORK)
              INTEGER(KIND=4) :: LIGW
              INTEGER(KIND=4) :: LRGW
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
              REAL(KIND=8) :: SB(N)
              REAL(KIND=8) :: SX(N)
              REAL(KIND=8) :: RGWK(LRGW)
              INTEGER(KIND=4) :: IGWK(LIGW)
              REAL(KIND=8) :: RWORK(*)
              INTEGER(KIND=4) :: IWORK(*)
            END SUBROUTINE DGMRES
          END INTERFACE 
        END MODULE DGMRES__genmod
