        !COMPILER-GENERATED INTERFACE MODULE: Mon Feb 28 11:50:10 2011
        MODULE LLD2AR__genmod
          INTERFACE 
            SUBROUTINE LLD2AR(LSTLEN,DLIST,DARR1,DARR2)
              USE LLDEF
              INTEGER(KIND=4) :: LSTLEN
              TYPE (LLD) ,POINTER :: DLIST
              REAL(KIND=8) :: DARR1(*)
              REAL(KIND=8) :: DARR2(*)
            END SUBROUTINE LLD2AR
          END INTERFACE 
        END MODULE LLD2AR__genmod
