C     Last change:  RBW  23 Oct 2003    3:59 pm
      module MyBuff
      implicit none
      REAL BUF
      INTEGER OLDNCOL, OLDNROW, ierror
      ALLOCATABLE BUF(:,:)
      end module
C     ------------------------------------------------------------------
      SUBROUTINE ReadMe(INUNIT,iorror,KSTP,KPER,PERTIM,TOTIM,
     1   NCOL,NROW,ILAY,Text)
      use MyBuff
      implicit none
      DLL_EXPORT ReadMe
      INTEGER iorror,INUNIT
      INTEGER KSTP,KPER
      REAL PERTIM,TOTIM
      INTEGER NCOL,NROW,ILAY
      character(len=*) :: TEXT
      ierror =iorror
      CALL LayRead(INUNIT, ierror,KSTP,KPER,PERTIM,TOTIM,NCOL,
     1   NROW,ILAY,TEXT)
      iorror = ierror
      return
      END SUBROUTINE
C     ------------------------------------------------------------------
      SUBROUTINE ReadMeFormatted(INUNIT,iorror,KSTP,KPER,PERTIM,TOTIM,
     1   NCOL,NROW,ILAY,Text)
      use MyBuff
      implicit none
      DLL_EXPORT ReadMeFormatted
      INTEGER iorror,INUNIT
      INTEGER KSTP,KPER
      REAL PERTIM,TOTIM
      INTEGER NCOL,NROW,ILAY
      character(len=*) :: TEXT
      ierror =iorror
      CALL  LayReadFormatted(INUNIT, ierror,KSTP,KPER,PERTIM,TOTIM,NCOL,
     1   NROW,ILAY,TEXT)
      iorror = ierror
      return
      END SUBROUTINE
C     ------------------------------------------------------------------
      SUBROUTINE GETVALUE(AVALUE,COL,ROW)
      use MyBuff
      implicit none
      DLL_EXPORT GETVALUE
      REAL AVALUE
      INTEGER COL,ROW
        AVALUE = BUF(COL,ROW)
      END SUBROUTINE
C     ------------------------------------------------------------------
      SUBROUTINE FreeMe()
      use MyBuff
      implicit none
      DLL_EXPORT FreeMe
      if (ALLOCATED(Buf)) then
        DEALLOCATE(BUF)
      end if
      return
      END SUBROUTINE
C     ------------------------------------------------------------------
      SUBROUTINE LayRead(ICHN, IOERR,KSTP,KPER,PERTIM,TOTIM,NCOL,
     1   NROW,ILAY,TEXT)
      USE MyBuff
      IMPLICIT NONE
      INTEGER ICHN, IOERR
      INTEGER KSTP,KPER
      INTEGER IC,IR
      REAL PERTIM,TOTIM
      INTEGER NCOL,NROW,ILAY
      CHARACTER(16) Localtext
      character(len=*) :: TEXT
C1------ READ AN UNFORMATTED RECORD CONTAINING IDENTIFYING
C1------INFORMATION.
      READ (UNIT=ICHN,IOSTAT=IOERR) KSTP,KPER,PERTIM,TOTIM,Localtext,
     1 NCOL,NROW,ILAY
      IF (IOERR.NE.0) GOTO 10
      if (.not. ALLOCATED(BUF)) then
        ALLOCATE(BUF(NCOL,NROW))
        OLDNCOL = NCOL
        OLDNROW = NROW
      ELSEIF ((OLDNCOL.ne.NCOL).OR.(OLDNROW.ne.NROW)) then
        IOERR = 1
        GOTO 10
      end if
      Text(2:17) = Localtext(1:16)
C
C2------ READ AN UNFORMATTED RECORD CONTAINING ARRAY VALUES
C2------THE ARRAY IS DIMENSIONED (NCOL,NROW)
      READ (UNIT=ICHN,IOSTAT=IOERR) ((BUF(IC,IR),IC=1,NCOL),IR=1,NROW)
      IF (IOERR.NE.0) GOTO 10
C
C3------RETURN
 10   CONTINUE
      RETURN
      END
C     ------------------------------------------------------------------
      SUBROUTINE LayReadFormatted(ICHN, IOERR,KSTP,KPER,PERTIM,TOTIM,
     1  NCOL,NROW,ILAY,TEXT)
      USE MyBuff
      IMPLICIT NONE
      INTEGER ICHN, IOERR
      INTEGER KSTP,KPER
      INTEGER IC,IR
      REAL PERTIM,TOTIM
      INTEGER NCOL,NROW,ILAY
      CHARACTER*20 FMTOUT
      character(len=*) :: TEXT
C1------ READ AN FORMATTED RECORD CONTAINING IDENTIFYING
C1------INFORMATION.
5     FORMAT(1X,2I5,1P,2E15.6,1X,A,3I6,1X,A)
      READ (UNIT=ICHN,FMT=5,IOSTAT=IOERR) KSTP,KPER,PERTIM,TOTIM,TEXT,
     1  NCOL,NROW,ILAY,FMTOUT
      IF (IOERR.NE.0) GOTO 10
      if (.not. ALLOCATED(BUF)) then
        ALLOCATE(BUF(NCOL,NROW))
        OLDNCOL = NCOL
        OLDNROW = NROW
      ELSEIF ((OLDNCOL.ne.NCOL).OR.(OLDNROW.ne.NROW)) then
        IOERR = 1
        GOTO 10
      end if
C
C2------ READ AN UNFORMATTED RECORD CONTAINING ARRAY VALUES
C2------THE ARRAY IS DIMENSIONED (NCOL,NROW)
      do IR = 1, NROW
        READ (UNIT=ICHN,FMT=FMTOUT,IOSTAT=IOERR) (BUF(IC,IR),IC=1,NCOL)
      end do
      IF (IOERR.NE.0) GOTO 10
C3------RETURN
 10   CONTINUE
      RETURN
      END
C     ------------------------------------------------------------------
      subroutine lropen(ierror,iunit,filename )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      character*80 frmtarg, statusarg
        frmtarg = 'UNFORMATTED'
        statusarg = 'OLD'
	open(UNIT=iunit,IOSTAT=ierror,FILE=filename,STATUS=statusarg,
     1    FORM=frmtarg)
c
      return
      end
C     ------------------------------------------------------------------
      subroutine lropenFormatted(ierror,iunit,filename )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      character*80 frmtarg, statusarg
        frmtarg = 'FORMATTED'
        statusarg = 'OLD'
	open(UNIT=iunit,IOSTAT=ierror,FILE=filename,STATUS=statusarg,
     1    FORM=frmtarg)
c
      return
      end
C     ------------------------------------------------------------------
      subroutine lrxopen(ierror,iunit,filename )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      dll_export lrxopen
        call lropen(ierror,iunit,filename )
      return
      end
C     ------------------------------------------------------------------
      subroutine lrfopen(ierror,iunit,filename )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      dll_export lrfopen
        call lropenFormatted(ierror,iunit,filename )
      return
      end
C     ------------------------------------------------------------------
      subroutine lrclose(iunit)
      implicit none
      integer iunit
	close(iunit)
	return
      end
C     ------------------------------------------------------------------
      subroutine lrxclose(iunit)
      implicit none
      integer iunit
      dll_export lrxclose
	call lrclose(iunit)
	return
      end
