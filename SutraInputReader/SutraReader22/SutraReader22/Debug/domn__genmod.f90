        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:08 2011
        MODULE DOMN__genmod
          INTERFACE 
            SUBROUTINE DOMN(N,B,X,NELT,IA,JA,A,ISYM,MATVEC,MSOLVE,NSAVE,&
     &ITOL,TOL,ITMAX,ITER,ERR,IERR,IUNIT,R,Z,P,AP,EMAP,DZ,CSAV,RWORK,   &
     &IWORK)
              INTEGER(KIND=4) :: NSAVE
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
              REAL(KIND=8) :: P(N,0:NSAVE)
              REAL(KIND=8) :: AP(N,0:NSAVE)
              REAL(KIND=8) :: EMAP(N,0:NSAVE)
              REAL(KIND=8) :: DZ(N)
              REAL(KIND=8) :: CSAV(NSAVE)
              REAL(KIND=8) :: RWORK(*)
              INTEGER(KIND=4) :: IWORK(*)
            END SUBROUTINE DOMN
          END INTERFACE 
        END MODULE DOMN__genmod
