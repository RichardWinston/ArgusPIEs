C     Last change:  RBW  23 Apr 2002   11:00 am
      MODULE xarray
        INTEGER LCCNEW
        INTEGER NCOL,NROW,NLAY
        DIMENSION X(:)
        ALLOCATABLE :: X
        REAL x
      END MODULE
C     ------------------------------------------------------------------
      SUBROUTINE pm_deallocate
      USE xarray
      implicit none
      dll_export pm_deallocate
        if (ALLOCATED(X)) then
          DEALLOCATE(x)
        end if
      return
      END SUBROUTINE
C     ------------------------------------------------------------------
      subroutine lropen(ierror,iunit,filename, isnew )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      character*80 frmtarg, statusarg, ACCARG
      LOGICAL isnew
        ACCARG='TRANSPARENT'
        frmtarg = 'UNFORMATTED'
        if (isnew) then
          statusarg = 'REPLACE'
        else
          statusarg = 'OLD'
        end if
	open(UNIT=iunit,IOSTAT=ierror,FILE=filename,STATUS=statusarg,
     1    ACCESS=ACCARG,FORM=frmtarg)
c
      return
      end
C     ------------------------------------------------------------------
      subroutine lropenFormatted(ierror,iunit,filename, isnew )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      character*80 frmtarg, statusarg
      LOGICAL isnew
        frmtarg = 'FORMATTED'
        if (isnew) then
          statusarg = 'REPLACE'
        else
          statusarg = 'OLD'
        end if
	open(UNIT=iunit,IOSTAT=ierror,FILE=filename,STATUS=statusarg,
     1    FORM=frmtarg)
      return
      end
C     ------------------------------------------------------------------
      subroutine pmopen(ierror,iunit,filename, isnew)
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      LOGICAL isnew
      dll_export pmopen
        ierror = 0
        call lropen(ierror,iunit,filename, isnew )
      return
      end
C     ------------------------------------------------------------------
      subroutine pmfopen(ierror,iunit, filename, isnew )
      implicit none
      integer iunit,ierror
      character(LEN=*) filename
      LOGICAL isnew
      dll_export pmfopen
        ierror = 0
        call lropenFormatted(ierror,iunit,filename, isnew )
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
      subroutine pmclose(iunit)
      implicit none
      integer iunit
      dll_export pmclose
	call lrclose(iunit)
	return
      end
C     ------------------------------------------------------------------
      subroutine GetValue(icol, irow, ilay, Value, CNEW)
      USE xarray
      implicit none
      INTEGER icol, irow, ilay
      REAL Value
      REAL      CNEW
      DIMENSION CNEW(NCOL,NROW,NLAY)
        Value = CNEW(ICOL,IROW,ILAY)
	return
      end subroutine
C     ------------------------------------------------------------------
      subroutine pmget_value(icol, irow, ilay, ierr, Value)
      USE xarray
      implicit none
      INTEGER icol, irow, ilay, ierr
      REAL Value
      dll_export pmget_value
      ierr = 0
      if ((icol.gt.ncol).OR.(irow.gt.nrow).OR.(ilay.gt.nlay)) then
        ierr = 1
        return
      end if
      if ((icol.lt.1).OR.(irow.lt.1).OR.(ilay.lt.1)) then
        ierr = 1
        return
      end if
      call GetValue(icol, irow, ilay, Value, X(LCCNEW))
      return
      end subroutine
C     ------------------------------------------------------------------

      subroutine pm_initialize(IERR)
      USE xarray
      IMPLICIT  NONE
      INTEGER   ICNF
      INTEGER   IERR
      PARAMETER (ICNF=11)
      INTEGER   LCDISR,LCDISC,LCDISL,LCHTOP,
     &          LCBUFF,
     &          IOERR,ISUM,ISUMX
      REAL      CINACT,YTRANS,ZTRANS,CDRY,XOFF,YOFF,ZOFF
      dll_export pm_initialize
C      DIMENSION X(:)
C      ALLOCATABLE :: X
      COMMON /DRYCEL/CDRY
      COMMON /OFFSET/XOFF,YOFF,ZOFF

C--CDRY IS VALUE INDICATING DRY CELL WHICH IS SET IN MODFLOW
C--AS 1.E30
      IERR = 0
      CDRY=1.E30
C
C--ALLOCATE SPACE IN THE X ARRAY FOR INDIVIDUAL WORKING ARRAYS
      CALL DEFINE(ICNF,ISUM,NCOL,NROW,NLAY,
     & LCDISR,LCDISC,LCDISL,LCHTOP,LCCNEW,LCBUFF)
C
C--DYNAMICALLY ALLOCATE MEMORY
      ISUMX=ISUM-1
      ALLOCATE (X(ISUMX),STAT=IOERR)
      IF(IOERR.NE.0) THEN
        IERR = 1
c        WRITE(*,*) 'STOP.  NOT ENOUGH MEMORY'
        RETURN
      ENDIF
C
C--READ SPATIAL DISCRETIZATION INFORMATION
      CALL GETCNF(ICNF,NCOL,NROW,NLAY,X(LCDISR),X(LCDISC),X(LCDISL),
     & X(LCHTOP),X(LCBUFF),CINACT,YTRANS,ZTRANS)
C
C--OFFSET COORDINATE ORIGIN IF REQUESTED
      return
      end subroutine
C     ------------------------------------------------------------------
      subroutine pmread_nextarray(IERR, NTRANS,KSTP,KPER,TIME)
      USE xarray
c        IERR = 1: NOT ENOUGH MEMORY'
c        IERR = 2: data not found
C        IERR = 3: NCOL or NROW in unformatted file and model grid configuration file NOT same.
C        IERR = 4; Layer NOT found in unformatted file.'
c        IERR = 5: end of file
c        TIME0 = total elapsed time at which contour map is needed',
c           enter 0 to specify step numbers ',
c           or -1 for the final step.
c        NT0 = number of Transport Step
c        KS0 = Time Step
c        KP0 = Stress Period
C
C     PROGRAM PostMT3DMS|PostMODFLOW
C *****************************************************************
C THIS PROGRAM READS THE UNFORMATTED CONCENTRATION OR HEAD FILE
C SAVED BY MT3DMS/MODFLOW, AND THE MODEL GRID CONFIGURATION FILE,
C TO CREATE DATA FILES APPROPRIATE FOR USE BY GOLDEN SOFTWARE'S
C CONTOURING GRAPHIC PACKAGE [SURFER] OR AMTEC'S 3D VISUALIZATION
C PACKAGE TECPLOT.
C *****************************************************************
C Version 4.00, last modified: 08-12-2001
C Written by C. Zheng
C
C--REDIMENSION THE STORAGE X ARRAY IF NECESSARY
      IMPLICIT  NONE
      INTEGER   IUCN
      INTEGER   IERR
      PARAMETER (IUCN=10)
c      INTEGER   IOERR,ISUM,ISUMX
      INTEGER   NTRANS,KSTP,KPER
      REAL      TIME,CDRY,XOFF,YOFF,ZOFF
      LOGICAL   FOUND,ENDED
      dll_export pmread_nextarray
C      DIMENSION X(:)
C      ALLOCATABLE :: X
      COMMON /DRYCEL/CDRY
      COMMON /OFFSET/XOFF,YOFF,ZOFF
C
C--WRITE AN IDENTIFIER TO SCREEN
c      WRITE(*,101)
c  101 FORMAT('+',
c     & 'PM - Unformatted File Reader for MODFLOW/MT3DMS.',
c     & ' C. Zheng. Ver. 4.00.'/)
C
C--CDRY IS VALUE INDICATING DRY CELL WHICH IS SET IN MODFLOW
C--AS 1.E30
      IERR = 0
      CDRY=1.E30
C
C--OPEN INPUT FILES
c    5 WRITE(*,10)
c   10 FORMAT(1X,'Enter name of unformatted concentration or head file',
c     &      /1X,'saved after running MT3D or MODFLOW: ')
c      READ(*,'(A80)') FLNAME
c      IF(FLNAME.EQ.' ') GOTO 5
c    6 WRITE(*,7)
c    7 FORMAT(1X,'Specify style of the unformatted file;',
c     &      /1X,'enter 1 for [Unformatted]; 2 for [True Binary]: ')
c      READ(*,*) ISTYLE
c      IF(ISTYLE.NE.1.AND.ISTYLE.NE.2) THEN
c        WRITE(*,8)
c        GOTO 6
c    8   FORMAT(1X,'Invalid file style specified. Enter 1 or 2 Only.')
c      ENDIF
C
C--DEFINE STRUCTURE OF UNFORMATTED FILE
c      IF(ISTYLE.EQ.1) THEN
c        FORMARG='UNFORMATTED'
c        ACCARG='SEQUENTIAL'
c      ELSEIF(ISTYLE.EQ.2) THEN
c        FORMARG='UNFORMATTED'
c        ACCARG='TRANSPARENT'
c      ENDIF
C
c      L=INDEX(FLNAME,' ')-1
c      OPEN(IUCN,FILE=FLNAME(1:L),FORM=FORMARG,ACCESS=ACCARG,
c     & STATUS='OLD')
C
c   11 WRITE(*,12)
c   12 FORMAT(1X,'Enter name of the model grid configuration file: ')
c      READ(*,'(A80)') FLNAME
c      IF(FLNAME.EQ.' ') GOTO 11
c      L=INDEX(FLNAME,' ')-1
c      OPEN(ICNF,FILE=FLNAME(1:L),FORM='FORMATTED',STATUS='OLD')
C
C--ALLOCATE SPACE IN THE X ARRAY FOR INDIVIDUAL WORKING ARRAYS
c      CALL DEFINE(ICNF,ISUM,NCOL,NROW,NLAY,
c     & LCDISR,LCDISC,LCDISL,LCHTOP,LCCNEW,LCBUFF)
c      WRITE(*,1) NCOL,NROW,NLAY
c    1 FORMAT(1X,'The model consists of',I5,' Columns',I5,' Rows, and',
c     & I3,' Layers'/)
C
C--DYNAMICALLY ALLOCATE MEMORY
c      ISUMX=ISUM-1
c      ALLOCATE (X(ISUMX),STAT=IOERR)
c      IF(IOERR.NE.0) THEN
c        IERR = 1
c        WRITE(*,*) 'STOP.  NOT ENOUGH MEMORY'
c        RETURN
c      ENDIF
C
C--READ SPATIAL DISCRETIZATION INFORMATION
c      CALL GETCNF(ICNF,NCOL,NROW,NLAY,X(LCDISR),X(LCDISC),X(LCDISL),
c     & X(LCHTOP),X(LCBUFF),CINACT,YTRANS,ZTRANS)
C
C--OFFSET COORDINATE ORIGIN IF REQUESTED
c      WRITE(*,310)
c  310 FORMAT(1X,'Do you wish to offset the coordinate origin (y/n)? ')
c      READ(*,'(A)') ANS
c      IF(ANS.EQ.'y'.OR.ANS.EQ.'Y') THEN
c  315   WRITE(*,320)
c  320   FORMAT(1X,'Enter offsets for x, y and z axes: ')
c        READ(*,FMT=*,ERR=330,IOSTAT=IOERR) XOFF,YOFF,ZOFF
c  330   IF(IOERR.GT.0) THEN
c          WRITE(*,113)
c          GOTO 315
c        ENDIF
c      ELSE
        XOFF=0
        YOFF=0
        ZOFF=0
c      ENDIF
C
C--DEFINE TOTAL ELAPSED TIME OR STEP NUMBER
C--AT WHICH CONTOUR MAP IS NEEDED
c  114 WRITE(*,14)
c      READ(*,FMT=*,ERR=116,IOSTAT=IOERR) TIME0
c  116 IF(IOERR.GT.0) THEN
c        WRITE(*,113)
c        GOTO 114
c  113   FORMAT(1X,'Invalid input.  Please try again.')
c      ELSEIF(TIME0.EQ.0) THEN
c  115   WRITE(*,16)
c        READ(*,FMT=*,ERR=118,IOSTAT=IOERR) NT0,KS0,KP0
c  118   IF(IOERR.GT.0.OR.KS0.LE.0.OR.KP0.LE.0) THEN
c          WRITE(*,113)
c          GOTO 115
c        ENDIF
c      ENDIF
c   14 FORMAT(1X,'Specify total elapsed time at which',
c     & ' contour map is needed',
c     & /1X,'(enetr 0 to specify step numbers ',
c     & 'or -1 for the final step): ')
c   16 FORMAT(1X,'Specify number of Transport Step,',
c     & ' Time Step, and Stress Period (Transport Step',
c     & /1X,'is not used and can be given any number',
c     & ' for MODFLOW file): ')
C
C--LOAD CONCENTRATIONS OR HEADS AT THE DESIRED STEP
      CALL GETNEXTUCN(IUCN,NCOL,NROW,NLAY,
     & ENDED,FOUND,X(LCCNEW), IERR,NTRANS,KSTP,KPER,TIME)
      IF(.NOT.FOUND.AND.ENDED) THEN
c        WRITE(*,17)
c        READ(*,'(A1)') ANS
c        IF(ANS.EQ.'Y'.OR.ANS.EQ.'y') THEN
c          REWIND(IUCN)
c          GOTO 114
c        ELSE
         IERR = 2
         GOTO 100
c        ENDIF
      ENDIF
      IF(ENDED) THEN
c        WRITE(*,17)
c        READ(*,'(A1)') ANS
c        IF(ANS.EQ.'Y'.OR.ANS.EQ.'y') THEN
c          REWIND(IUCN)
c          GOTO 114
c        ELSE
         IERR = 5
         GOTO 100
c        ENDIF
      ENDIF
c   17 FORMAT(/1X,'Cannot find the specified total elapsed time',
c     & ' or step number.'/1X,'Try again (Y/N)? ')
C
C--SPECIFY THE J,I,K INDICES AT CORNERS OF THE CONTOUR MAP
c  199 WRITE(*,18)
c      READ (*,FMT=*,ERR=200,IOSTAT=IOERR) JJJ1,III1,KKK1
c  200 IF(IOERR.GT.0) THEN
c        WRITE(*,113)
c        GOTO 199
c      ELSEIF(JJJ1.LT.1.OR.JJJ1.GT.NCOL
c     &   .OR.III1.LT.1.OR.III1.GT.NROW
c     &   .OR.KKK1.LT.0.OR.KKK1.GT.NLAY) THEN
c        WRITE(*,202)
c        GOTO 199
c      ENDIF
c  205 WRITE(*,20)
c      READ (*,FMT=*,ERR=210,IOSTAT=IOERR) JJJ2,III2,KKK2
c  210 IF(IOERR.GT.0) THEN
c        WRITE(*,113)
c        GOTO 205
c      ELSEIF(JJJ2.LT.1.OR.JJJ2.GT.NCOL
c     &   .OR.III2.LT.1.OR.III2.GT.NROW
c     &   .OR.KKK2.LT.0.OR.KKK2.GT.NLAY) THEN
c        WRITE(*,202)
c        GOTO 205
c      ELSEIF(JJJ1.GT.JJJ2.OR.III1.GT.III2.OR.KKK1.GT.KKK2) THEN
c        WRITE(*,201)
c        GOTO 199
c      ENDIF
c   18 FORMAT(/1X,'Specify starting column (J1), row (I1),',
c     & ' layer (K1) indices of the contour map'
c     & /1X,'(enter K1=0 to specify water table): ')
c   20 FORMAT(1X,'Specify ending column (J2), row (I2),',
c     & ' layer (K2) indices of the contour map'
c     & /1X,'(enter K2=0 to specify water table): ')
c  201 FORMAT(1X,'Starting indices must be < or = ending indices.',
c     & '  Please try again.')
c  202 FORMAT(1X,'Specified Column, Row or Layer number out of bound.',
c     & '  Please try again.')
C
C--OPEN OUTPUT DATA FILE
C  217 WRITE(*,22)
C      READ(*,'(A80)') FLNAME
C      IF(FLNAME.EQ.' ') GOTO 217
C      L=INDEX(FLNAME,' ')-1
C      OPEN(IOUT,FILE=FLNAME(1:L),FORM='FORMATTED')
C   22 FORMAT(1X,'Enter name of output data file',
C     & ' for generating contour map: ')
C
C--SPECIFY THE FORMAT OF OUTPUT DATA FILE
C  122 WRITE(*,24)
C      READ(*,*,ERR=123) IFMT
C      IF(IFMT.EQ.3) THEN
C        WRITE(*,5000) CINACT
C        READ(*,'(A1)') ANS
C        IF(ANS.EQ.'Y'.OR.ANS.EQ.'y') THEN
C          WRITE(*,5020)
C          READ(*,*) C0
C        ENDIF
C      ENDIF
C      IF(IFMT.EQ.1.OR.IFMT.EQ.2.OR.IFMT.EQ.3) GOTO 126
C  123 WRITE(*,25)
C      GOTO 122
C 5000 FORMAT(1X,'Current value indicating inactive/dry cells=',G15.7,
C     & /1X,' Replace it with a different value (y/n)? ')
C 5020 FORMAT(1X,'Enter a new value to indicate inactive/dry cells: ')
C   24 FORMAT(1X,'Select a format for the data file; Enter',
C     &  /1X,' 1 for Surfer GRD foramt (regular grid assumed);',
C     &  /1X,' 2 for DAT format without header',
C     &          ' (inactive cells skipped);',
C     &  /1X,' 3 for DAT format with Tecplot header: ')
C   25 FORMAT(1X,'Input value must be either 1, 2 or 3.',
C     & '  Please try again.')
C
C--WRITE CONCENTRATIONS TO OUTPUT DATA FILE
C  126 IF(IFMT.EQ.1) THEN
C        CALL TOPO(IOUT,NCOL,NROW,NLAY,JJJ1,JJJ2,III1,III2,KKK1,KKK2,
C     &   X(LCDISR),X(LCDISC),X(LCDISL),X(LCCNEW),X(LCBUFF),CINACT,
C     &   YTRANS,ZTRANS)
C      ELSE
C        CALL GRID(IOUT,NCOL,NROW,NLAY,JJJ1,JJJ2,III1,III2,KKK1,KKK2,
C     &   X(LCDISR),X(LCDISC),X(LCDISL),X(LCCNEW),X(LCBUFF),CINACT,
C     &   YTRANS,ZTRANS,IFMT,C0)
C      ENDIF
C
C--CREATE ANOTHER DATA FILE FOR CONTOUR MAP?
C      WRITE(*,30)
C   30 FORMAT(1X,'Create another data file for contour map (Y/N)? ')
C      READ(*,'(A1)') ANS
C      IF(ANS.NE.'Y'.AND.ANS.NE.'y') GOTO 100
C
C--REDEFINE TOTAL ELASPED TIME OR STEP NUMBER?
C      WRITE(*,32)
C   32 FORMAT(1X,'Change total elapsed time or step number (Y/N)? ')
C      READ(*,'(A1)') ANS
C      IF(ANS.EQ.'Y'.OR.ANS.EQ.'y') THEN
C   40   WRITE(*,14)
C        READ(*,FMT=*,ERR=42,IOSTAT=IOERR) TIME0
C   42   IF(IOERR.GT.0) THEN
C          WRITE(*,113)
C          GOTO 40
C        ELSEIF(TIME0.EQ.0) THEN
C   44     WRITE(*,16)
C          READ(*,FMT=*,ERR=46,IOSTAT=IOERR) NT0,KS0,KP0
C   46     IF(IOERR.GT.0.OR.KS0.LE.0.OR.KP0.LE.0) THEN
C            WRITE(*,113)
C            GOTO 44
C          ENDIF
C        ENDIF
C  124   CALL GETUCN(IUCN,NCOL,NROW,NLAY,
C     &   TIME0,NT0,KS0,KP0,ENDED,FOUND,X(LCCNEW))
C        IF(.NOT.FOUND.AND.ENDED) THEN
C          WRITE(*,26)
C          READ(*,'(A1)') ANS
C          IF(ANS.EQ.'Y'.OR.ANS.EQ.'y') THEN
C            REWIND(IUCN)
C            GOTO 124
C          ELSE
C            GOTO 100
C          ENDIF
C        ENDIF
C      ENDIF
C   26 FORMAT(1X,'End of the unformatted file reached.  ',
C     & ' Re-search from the beginning (Y/N)? ')
C
C--REDEFINE LOCATION OF CONTOUR MAP?
C      WRITE(*,34)
C   34 FORMAT(1X,'Change corner indices of the contour map (Y/N)? ')
C      READ(*,'(A1)') ANS
C      IF(ANS.EQ.'Y'.OR.ANS.EQ.'y') THEN
C        GOTO 199
C      ELSE
C        GOTO 217
C      ENDIF
C
  100 CONTINUE
      RETURN
      END
C     ------------------------------------------------------------------
      SUBROUTINE DEFINE(ICNF,ISUM,NCOL,NROW,NLAY,LCDISR,LCDISC,LCDISL,
     & LCHTOP,LCCNEW,LCBUFF)
C*********************************************************************
C THIS SUBROUTINE READS COLUMN, ROW AND LAYER NUMBERS FROM THE MODEL
C GRID CONFIGURATION AND ALLOCATES SPACE FOR ARRAYS USED IN PROGRAM.
C ********************************************************************
C
      IMPLICIT  NONE
      INTEGER   ICNF,ISUM,NCOL,NROW,NLAY,
     &          LCDISR,LCDISC,LCDISL,LCHTOP,LCCNEW,LCBUFF
C
C--READ NO. OF LAYERS, ROWS, COLUMNS, AND STRESS PERIODS
      READ(ICNF,*) NLAY,NROW,NCOL
C
C--INITIALIZE ARRAY POINTER FOR ALLOCATING MEMORY
      ISUM=1
C
C--ALLOCATE SPACE FOR ARRAYS
      LCDISR=ISUM
      ISUM=ISUM+NCOL
      LCDISC=ISUM
      ISUM=ISUM+NROW
      LCDISL=ISUM
      ISUM=ISUM+NCOL*NROW*NLAY
      LCCNEW=ISUM
      ISUM=ISUM+NCOL*NROW*NLAY
      LCHTOP=ISUM
      ISUM=ISUM+NCOL*NROW
      LCBUFF=ISUM
      ISUM=ISUM+NCOL*NROW*NLAY
C
C--NORMAL RETURN
      RETURN
      END
C
C
      SUBROUTINE GETCNF(ICNF,NCOL,NROW,NLAY,DISR,DISC,DISL,HTOP,BUFF,
     & CINACT,YTRANS,ZTRANS)
C *********************************************************************
C THIS SUBROUTINE READS SPATIAL DISCRETIZATION INFORMATION, AND THE
C VALVE INDICATING INACTIVE CELLS FROM THE MODEL GRID CONFIGURATION.
C**********************************************************************
C
      IMPLICIT  NONE
      INTEGER   ICNF,NCOL,NROW,NLAY,J,I,K,IERR
      REAL      DISR,DISC,DISL,HTOP,BUFF,CINACT,HORIGN,
     &          YTRANS,ZTRANS,CDRY
      DIMENSION DISR(NCOL),DISC(NROW),DISL(NCOL,NROW,NLAY),
     &          HTOP(NCOL,NROW),BUFF(NCOL,NROW,NLAY)
      COMMON /DRYCEL/CDRY
C
C--READ CELL WIDTH ALONG ROWS (OR THE X AXIS)
C--AND CALCULATE NODAL COORDINATES RELATIVE TO ORIGIN
      READ(ICNF,*) (BUFF(J,1,1),J=1,NCOL)
      DISR(1)=BUFF(1,1,1)/2.
      DO 70 J=2,NCOL
        DISR(J)=DISR(J-1)+(BUFF(J-1,1,1)+BUFF(J,1,1))/2.
   70 CONTINUE
C
C--READ CELL WIDTH ALONG COLUMNS
C--AND CALCULATE NODAL COORDINATES RELATIVE TO ORIGIN
      READ(ICNF,*) (BUFF(1,I,1),I=1,NROW)
      DISC(1)=BUFF(1,1,1)/2.
      DO 80 I=2,NROW
        DISC(I)=DISC(I-1)+(BUFF(1,I-1,1)+BUFF(1,I,1))/2.
   80 CONTINUE
      YTRANS=DISC(NROW)+BUFF(1,NROW,1)/2.
C
C--READ TOP ELEVATION OF 1st MODEL LAYER
      READ(ICNF,*) ((HTOP(J,I),J=1,NCOL),I=1,NROW)
      HORIGN=HTOP(1,1)
      ZTRANS=HORIGN
C
C--READ CELL THICKNESS
C--AND CALCULATE NODAL COORDINATES RELATIVE TO ORIGIN
      READ(ICNF,*) (((BUFF(J,I,K),J=1,NCOL),I=1,NROW),K=1,NLAY)
      DO 90 I=1,NROW
        DO 95 J=1,NCOL
          DISL(J,I,1)=BUFF(J,I,1)/2.+(HORIGN-HTOP(J,I))
          DO 100 K=2,NLAY
            DISL(J,I,K)=DISL(J,I,K-1)+(BUFF(J,I,K-1)+BUFF(J,I,K))/2.
  100     CONTINUE
   95   CONTINUE
   90 CONTINUE
C
C--READ THE VALVE INDICATING INACTIVE OR DRY CONCENTRATION CELLS
      READ(ICNF,*,ERR=200,END=200,IOSTAT=IERR) CINACT,CDRY
  200 IF(IERR.NE.0) CDRY=CINACT
C
C--RETURN
      RETURN
      END
C
C
      SUBROUTINE GETNEXTUCN(IUCN,NCOL,NROW,NLAY,ENDED,
     & FOUND,CNEW, IERR,NTRANS,KSTP,KPER,TIME)
C ********************************************************************
C THIS SUBROUTINE READS THE UNFORMATTED CONCENTRATION OR HEAD FILE
C SAVED BY MT3D OR MODFLOW, AND LOADS THE CONCENTRATIONS/HEADS
C AT THE DESIRED STEP INTO ARRAY [CNEW].
C ********************************************************************
C
      IMPLICIT  NONE
      INTEGER   IUCN,NCOL,NROW,NLAY,J,I,K,
     &          NTRANS,KSTP,KPER,NC,NR,ILAY,ITMP1,ITMP2,ITMP3
      INTEGER   IERR
      REAL      CNEW,TIME2,TIME
      LOGICAL   FOUND,ENDED
      CHARACTER TEXT*16
      DIMENSION CNEW(NCOL,NROW,NLAY)
C
C--INITIALIZE
      ENDED=.FALSE.
      FOUND=.FALSE.
C
C--READ UNFORMATTED CONCENTRATION FILE
C    1 WRITE(*,11)
C   11 FORMAT(1X,'Reading Unformatted File......')
   12 DO 10 K=1,NLAY
C
C--READ AND PRINT HEADER
        READ(IUCN,END=100) ITMP1,ITMP2,ITMP3,TIME2,TEXT,NC,NR,ILAY
        NTRANS=ITMP1
        KSTP=ITMP2
        KPER=ITMP3
        TIME=TIME2
        IF(TEXT(1:13).NE.'CONCENTRATION'.AND.
     &         TEXT(1:13).NE.'concentration') THEN
          KSTP=ITMP1
          KPER=ITMP2
C          NT0=-1
          NTRANS=-1
        ENDIF
C        IF(K.EQ.1.AND.NTRANS.GT.0) WRITE(*,2) NTRANS,KSTP,KPER,TIME2
C        IF(K.EQ.1.AND.NTRANS.LT.0) WRITE(*,3) TEXT,KSTP,KPER,TIME2
C    2   FORMAT(1X,'Transport Step',I5,' Time Step',I3,
C     &   ' Stress Period',I3,' Total Elapsed Time',G11.4)
C    3   FORMAT(1X,A16,': Time Step',I3,
C     &   ' Stress Period',I3,' Total Elapsed Time',G11.4)
C
C--MAKE SURE PROPER FILE IS READ
        IF(NC.NE.NCOL.OR.NR.NE.NROW) THEN
          IERR = 3
          RETURN
CC          WRITE(*,5)
CC    5     FORMAT(/1X,'NCOL or NROW in unformatted file ',
CC     &     'and model grid configuration file NOT same.')
CC          STOP
        ELSEIF(ILAY.NE.K) THEN
          IERR = 4
          RETURN
C          WRITE(*,6) K
C    6     FORMAT(/1X,'Layer',I3,' NOT found in unformatted file.')
C          STOP
        ENDIF
C
C--READ CONCENTRATION RECORD ONE LAYER AT A TIME
        READ(IUCN) ((CNEW(J,I,K),J=1,NCOL),I=1,NROW)
C
   10 CONTINUE
C
C--FIND DESIRED STEP AT WHICH CONTOUR MAP IS NEEDED?
C--IF NOT GO TO NEXT STEP
C      IF(TIME0.GT.0.AND.ABS(TIME0-TIME2).LT.1.E-5*TIME0) THEN
        FOUND=.TRUE.
        GOTO 200
C      ELSEIF(TIME0.EQ.0.AND.
C     & NT0.EQ.NTRANS.AND.KS0.EQ.KSTP.AND.KP0.EQ.KPER) THEN
C        FOUND=.TRUE.
C        GOTO 200
C      ENDIF
C      GOTO 12
C
  100 ENDED=.TRUE.
      FOUND=.TRUE.
C
C--RETURN
  200 RETURN
      END
C

