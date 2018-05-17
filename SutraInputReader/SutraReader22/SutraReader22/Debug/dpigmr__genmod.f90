        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:08 2011
        MODULE DPIGMR__genmod
          INTERFACE 
            SUBROUTINE DPIGMR(N,R0,SR,SZ,JSCAL,MAXL,MAXLP1,KMP,NRSTS,   &
     &JPRE,MATVEC,MSOLVE,NMSL,Z,V,HES,Q,LGMR,RPAR,IPAR,WK,DL,RHOL,NRMAX,&
     &B,BNRM,X,XL,ITOL,TOL,NELT,IA,JA,A,ISYM,IUNIT,IFLAG,ERR,ITMAX)
              INTEGER(KIND=4) :: NELT
              INTEGER(KIND=4) :: MAXLP1
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: R0(*)
              REAL(KIND=8) :: SR(*)
              REAL(KIND=8) :: SZ(*)
              INTEGER(KIND=4) :: JSCAL
              INTEGER(KIND=4) :: MAXL
              INTEGER(KIND=4) :: KMP
              INTEGER(KIND=4) :: NRSTS
              INTEGER(KIND=4) :: JPRE
              EXTERNAL MATVEC
              EXTERNAL MSOLVE
              INTEGER(KIND=4) :: NMSL
              REAL(KIND=8) :: Z(*)
              REAL(KIND=8) :: V(N,*)
              REAL(KIND=8) :: HES(MAXLP1,*)
              REAL(KIND=8) :: Q(*)
              INTEGER(KIND=4) :: LGMR
              REAL(KIND=8) :: RPAR(*)
              INTEGER(KIND=4) :: IPAR(*)
              REAL(KIND=8) :: WK(*)
              REAL(KIND=8) :: DL(*)
              REAL(KIND=8) :: RHOL
              INTEGER(KIND=4) :: NRMAX
              REAL(KIND=8) :: B(*)
              REAL(KIND=8) :: BNRM
              REAL(KIND=8) :: X(*)
              REAL(KIND=8) :: XL(*)
              INTEGER(KIND=4) :: ITOL
              REAL(KIND=8) :: TOL
              INTEGER(KIND=4) :: IA(NELT)
              INTEGER(KIND=4) :: JA(NELT)
              REAL(KIND=8) :: A(NELT)
              INTEGER(KIND=4) :: ISYM
              INTEGER(KIND=4) :: IUNIT
              INTEGER(KIND=4) :: IFLAG
              REAL(KIND=8) :: ERR
              INTEGER(KIND=4) :: ITMAX
            END SUBROUTINE DPIGMR
          END INTERFACE 
        END MODULE DPIGMR__genmod
