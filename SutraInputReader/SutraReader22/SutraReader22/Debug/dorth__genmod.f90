        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:08 2011
        MODULE DORTH__genmod
          INTERFACE 
            SUBROUTINE DORTH(VNEW,V,HES,N,LL,LDHES,KMP,SNORMW)
              INTEGER(KIND=4) :: LDHES
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: VNEW(*)
              REAL(KIND=8) :: V(N,*)
              REAL(KIND=8) :: HES(LDHES,*)
              INTEGER(KIND=4) :: LL
              INTEGER(KIND=4) :: KMP
              REAL(KIND=8) :: SNORMW
            END SUBROUTINE DORTH
          END INTERFACE 
        END MODULE DORTH__genmod
