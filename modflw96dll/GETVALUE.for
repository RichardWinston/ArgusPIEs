C     Last change:  RBW  23 Jan 2006   11:12 am
      MODULE XMODULE
        REAL X(:)
        ALLOCATABLE x
      END MODULE
      SUBROUTINE GETVALUE(IXINDEX, VALUE)
      USE XMODULE
      DLL_EXPORT GETVALUE
C      PARAMETER (LENX=16000000)
C      COMMON X(LENX)
      REAL VALUE
      INTEGER IXINDEX
      VALUE = X(IXINDEX)
      RETURN
      END
      SUBROUTINE TERMINATE
      USE XMODULE
      DLL_EXPORT TERMINATE
      if (ALLOCATED(x)) then
        DEALLOCATE (X)
      end if
      END SUBROUTINE
