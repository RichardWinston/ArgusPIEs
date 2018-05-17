        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:08 2011
        MODULE DSICS__genmod
          INTERFACE 
            SUBROUTINE DSICS(N,NELT,IA,JA,A,ISYM,NEL,IEL,JEL,EL,D,R,    &
     &IWARN)
              INTEGER(KIND=4) :: NEL
              INTEGER(KIND=4) :: NELT
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: IA(NELT)
              INTEGER(KIND=4) :: JA(NELT)
              REAL(KIND=8) :: A(NELT)
              INTEGER(KIND=4) :: ISYM
              INTEGER(KIND=4) :: IEL(NEL)
              INTEGER(KIND=4) :: JEL(NEL)
              REAL(KIND=8) :: EL(NEL)
              REAL(KIND=8) :: D(N)
              REAL(KIND=8) :: R(N)
              INTEGER(KIND=4) :: IWARN
            END SUBROUTINE DSICS
          END INTERFACE 
        END MODULE DSICS__genmod
