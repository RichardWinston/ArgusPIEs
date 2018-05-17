        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:08 2011
        MODULE ISDOMN__genmod
          INTERFACE 
            FUNCTION ISDOMN(N,B,X,NELT,IA,JA,A,ISYM,MSOLVE,NSAVE,ITOL,  &
     &TOL,ITMAX,ITER,ERR,IERR,IUNIT,R,Z,P,AP,EMAP,DZ,CSAV,RWORK,IWORK,AK&
     &,BNRM,SOLNRM) RESULT(ISDOMN_0)
              INTEGER(KIND=4) :: NSAVE
              INTEGER(KIND=4) :: NELT
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: B(N)
              REAL(KIND=8) :: X(N)
              INTEGER(KIND=4) :: IA(NELT)
              INTEGER(KIND=4) :: JA(NELT)
              REAL(KIND=8) :: A(NELT)
              INTEGER(KIND=4) :: ISYM
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
              REAL(KIND=8) :: AK
              REAL(KIND=8) :: BNRM
              REAL(KIND=8) :: SOLNRM
              INTEGER(KIND=4) :: ISDOMN_0
            END FUNCTION ISDOMN
          END INTERFACE 
        END MODULE ISDOMN__genmod
