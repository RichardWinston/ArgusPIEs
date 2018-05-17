        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:08 2011
        MODULE DRLCAL__genmod
          INTERFACE 
            SUBROUTINE DRLCAL(N,KMP,LL,MAXL,V,Q,RL,SNORMW,PROD,R0NRM)
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: KMP
              INTEGER(KIND=4) :: LL
              INTEGER(KIND=4) :: MAXL
              REAL(KIND=8) :: V(N,*)
              REAL(KIND=8) :: Q(*)
              REAL(KIND=8) :: RL(N)
              REAL(KIND=8) :: SNORMW
              REAL(KIND=8) :: PROD
              REAL(KIND=8) :: R0NRM
            END SUBROUTINE DRLCAL
          END INTERFACE 
        END MODULE DRLCAL__genmod
