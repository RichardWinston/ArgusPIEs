C     Last change:  RBW  17 Nov 2008    5:48 pm
      module MyBuff
      implicit none
      REAL BUF
      INTEGER OLDNCOL, OLDNROW, ierror
      INTEGER, SAVE ::IPREC
      ALLOCATABLE BUF(:,:)
      DOUBLE PRECISION DBLBUFF
      ALLOCATABLE DBLBUFF(:,:)
      end module
C     ------------------------------------------------------------------
      SUBROUTINE HEADPRECISION(IU,NCOL,NROW)
      USE MyBuff
C  Determine single or double precision file type for a MODFLOW binary
C  head file:  0=unrecognized, 1=single, 2=double.
      DOUBLE PRECISION PERTIMD,TOTIMD
      CHARACTER*16 TEXT
C
      IF(IPREC.EQ.1 .OR. IPREC.EQ.2) RETURN
C
C  SINGLE check
      READ(IU,ERR=50,END=50) KSTP,KPER,PERTIM,TOTIM,TEXT
      IF((TEXT.EQ.'            HEAD')
     *   .or. (TEXT.EQ.'        DRAWDOWN')
     *   .or. (TEXT.EQ.'      SUBSIDENCE')
     *   .or. (TEXT.EQ.'      COMPACTION')
     *   .or. (TEXT.EQ.'   CRITICAL HEAD')
     *   .or. (TEXT.EQ.'     HEAD IN HGU')
     *   .or. (TEXT.EQ.'      SUBSIDENCE')
     *   .or. (TEXT.EQ.'NDSYS COMPACTION')
     *   .or. (TEXT.EQ.'  Z DISPLACEMENT')
     *   .or. (TEXT.EQ.' D CRITICAL HEAD')
     *   .or. (TEXT.EQ.'LAYER COMPACTION')
     *   .or. (TEXT.EQ.' DSYS COMPACTION')
     *   .or. (TEXT.EQ.'ND CRITICAL HEAD')
     *   .or. (TEXT.EQ.'LAYER COMPACTION')
     *   .or. (TEXT.EQ.'SYSTM COMPACTION')
     *   .or. (TEXT.EQ.'PRECONSOL STRESS')
     *   .or. (TEXT.EQ.'CHANGE IN PCSTRS')
     *   .or. (TEXT.EQ.'EFFECTIVE STRESS')
     *   .or. (TEXT.EQ.'CHANGE IN EFF-ST')
     *   .or. (TEXT.EQ.'      VOID RATIO')
     *   .or. (TEXT.EQ.'       THICKNESS')
     *   .or. (TEXT.EQ.'CENTER ELEVATION'))
     *  THEN
         IPREC=1
         GO TO 100
      END IF
C
C  DOUBLE check
50    REWIND(IU)
      READ(IU,ERR=100,END=100) KSTP,KPER,PERTIMD,TOTIMD,TEXT
      IF((TEXT.EQ.'            HEAD')
     *   .or. (TEXT.EQ.'        DRAWDOWN')
     *   .or. (TEXT.EQ.'      SUBSIDENCE')
     *   .or. (TEXT.EQ.'      COMPACTION')
     *   .or. (TEXT.EQ.'   CRITICAL HEAD')
     *   .or. (TEXT.EQ.'     HEAD IN HGU')
     *   .or. (TEXT.EQ.'      SUBSIDENCE')
     *   .or. (TEXT.EQ.'NDSYS COMPACTION')
     *   .or. (TEXT.EQ.'  Z DISPLACEMENT')
     *   .or. (TEXT.EQ.' D CRITICAL HEAD')
     *   .or. (TEXT.EQ.'LAYER COMPACTION')
     *   .or. (TEXT.EQ.' DSYS COMPACTION')
     *   .or. (TEXT.EQ.'ND CRITICAL HEAD')
     *   .or. (TEXT.EQ.'LAYER COMPACTION')
     *   .or. (TEXT.EQ.'SYSTM COMPACTION')
     *   .or. (TEXT.EQ.'PRECONSOL STRESS')
     *   .or. (TEXT.EQ.'CHANGE IN PCSTRS')
     *   .or. (TEXT.EQ.'EFFECTIVE STRESS')
     *   .or. (TEXT.EQ.'CHANGE IN EFF-ST')
     *   .or. (TEXT.EQ.'      VOID RATIO')
     *   .or. (TEXT.EQ.'       THICKNESS')
     *   .or. (TEXT.EQ.'CENTER ELEVATION')
     *   .or. (TEXT.EQ.'CHANGE IN EFF-ST')
     *   .or. (TEXT.EQ.'CHANGE IN EFF-ST'))
     *  THEN
         IPREC=2
      END IF
100   continue
C
      REWIND(IU)
      RETURN
      END
C     ------------------------------------------------------------------
      SUBROUTINE ReadMe2(INUNIT,iorror,KSTP,KPER,PERTIM,TOTIM,
     1   NCOL,NROW,ILAY,Text)
      use MyBuff
      implicit none
      DLL_EXPORT ReadMe2
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
      SUBROUTINE ReadMeFormatted2(INUNIT,iorror,KSTP,KPER,PERTIM,TOTIM,
     1   NCOL,NROW,ILAY,Text)
      use MyBuff
      implicit none
      DLL_EXPORT ReadMeFormatted2
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
      SUBROUTINE GETVALUE2(AVALUE,COL,ROW)
      use MyBuff
      implicit none
      DLL_EXPORT GETVALUE2
      REAL AVALUE
      INTEGER COL,ROW
      if (IPREC.eq.1) then
        AVALUE = BUF(COL,ROW)
      else
        AVALUE = DBLBUFF(COL,ROW)
      end if
      END SUBROUTINE
C     ------------------------------------------------------------------
      SUBROUTINE FreeMe2()
      use MyBuff
      implicit none
      DLL_EXPORT FreeMe2
      if (ALLOCATED(Buf)) then
        DEALLOCATE(BUF)
      end if
      if (ALLOCATED(DBLBUFF)) then
        DEALLOCATE(DBLBUFF)
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
      double precision PERTIMD,TOTIMD
      call HEADPRECISION(ICHN,NCOL,NROW)
C1------ READ AN UNFORMATTED RECORD CONTAINING IDENTIFYING
C1------INFORMATION.
      if (IPREC.eq.1) then

        READ (UNIT=ICHN,IOSTAT=IOERR) KSTP,KPER,PERTIM,TOTIM,Localtext,
     1   NCOL,NROW,ILAY
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
      else
        if (IPREC.ne.2) then
          IOERR = 1
          GOTO 10
        end if
        READ (UNIT=ICHN,IOSTAT=IOERR) KSTP,KPER,PERTIMD,TOTIMD,
     1    Localtext,NCOL,NROW,ILAY
        PERTIM = PERTIMD
        TOTIM = TOTIMD
        IF (IOERR.NE.0) GOTO 10
        if (.not. ALLOCATED(DBLBUFF)) then
          ALLOCATE(DBLBUFF(NCOL,NROW))
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
        READ (UNIT=ICHN,IOSTAT=IOERR) ((DBLBUFF(IC,IR),IC=1,NCOL),
     *     IR=1,NROW)
        IF (IOERR.NE.0) GOTO 10
      end if
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
      subroutine lropen(ierrorL,iunit,filename )
      USE MyBuff
c      implicit none
      integer iunit,ierrorL
      character(LEN=*) filename
      character*80 frmtarg, statusarg,actionarg,accessarg
        frmtarg = 'UNFORMATTED'
        statusarg = 'OLD'
        actionarg = 'READ'
        accessarg = 'TRANSPARENT'
	open(UNIT=iunit,IOSTAT=ierrorL,FILE=filename,STATUS=statusarg,
     1    FORM=frmtarg,ACTION=actionarg,ACCESS=accessarg)
        IPREC = 0
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
      subroutine lrxopen2(ierror,iunit,filename )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      dll_export lrxopen2
        call lropen(ierror,iunit,filename )
      return
      end
C     ------------------------------------------------------------------
      subroutine lrfopen2(ierror,iunit,filename )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      dll_export lrfopen2
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
      subroutine lrxclose2(iunit)
      implicit none
      integer iunit
      dll_export lrxclose2
	call lrclose(iunit)
	return
      end
