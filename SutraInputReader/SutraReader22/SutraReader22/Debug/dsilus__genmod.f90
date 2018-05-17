        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:07 2011
        MODULE DSILUS__genmod
          INTERFACE 
            SUBROUTINE DSILUS(N,NELT,IA,JA,A,ISYM,NL,IL,JL,L,DINV,NU,IU,&
     &JU,U,NROW,NCOL)
              INTEGER(KIND=4) :: NU
              INTEGER(KIND=4) :: NL
              INTEGER(KIND=4) :: NELT
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: IA(NELT)
              INTEGER(KIND=4) :: JA(NELT)
              REAL(KIND=8) :: A(NELT)
              INTEGER(KIND=4) :: ISYM
              INTEGER(KIND=4) :: IL(NL)
              INTEGER(KIND=4) :: JL(NL)
              REAL(KIND=8) :: L(NL)
              REAL(KIND=8) :: DINV(N)
              INTEGER(KIND=4) :: IU(NU)
              INTEGER(KIND=4) :: JU(NU)
              REAL(KIND=8) :: U(NU)
              INTEGER(KIND=4) :: NROW(N)
              INTEGER(KIND=4) :: NCOL(N)
            END SUBROUTINE DSILUS
          END INTERFACE 
        END MODULE DSILUS__genmod
