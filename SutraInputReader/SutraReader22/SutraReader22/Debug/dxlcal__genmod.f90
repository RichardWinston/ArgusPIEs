        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:08 2011
        MODULE DXLCAL__genmod
          INTERFACE 
            SUBROUTINE DXLCAL(N,LGMR,X,XL,ZL,HES,MAXLP1,Q,V,R0NRM,WK,SZ,&
     &JSCAL,JPRE,MSOLVE,NMSL,RPAR,IPAR,NELT,IA,JA,A,ISYM)
              INTEGER(KIND=4) :: NELT
              INTEGER(KIND=4) :: MAXLP1
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: LGMR
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: XL(N)
              REAL(KIND=8) :: ZL(N)
              REAL(KIND=8) :: HES(MAXLP1,*)
              REAL(KIND=8) :: Q(*)
              REAL(KIND=8) :: V(N,*)
              REAL(KIND=8) :: R0NRM
              REAL(KIND=8) :: WK(N)
              REAL(KIND=8) :: SZ(*)
              INTEGER(KIND=4) :: JSCAL
              INTEGER(KIND=4) :: JPRE
              EXTERNAL MSOLVE
              INTEGER(KIND=4) :: NMSL
              REAL(KIND=8) :: RPAR(*)
              INTEGER(KIND=4) :: IPAR(*)
              INTEGER(KIND=4) :: IA(NELT)
              INTEGER(KIND=4) :: JA(NELT)
              REAL(KIND=8) :: A(NELT)
              INTEGER(KIND=4) :: ISYM
            END SUBROUTINE DXLCAL
          END INTERFACE 
        END MODULE DXLCAL__genmod
