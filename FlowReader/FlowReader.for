C     Last change:  RBW  19 Jun 2014    2:04 pm
      MODULE FlowRead
      REAL :: FlowValues(:,:,:)
      ALLOCATABLE FlowValues
      integer :: INBUD, NRC, NODES
      INTEGER :: NCOL,NROW,NLAY
      END MODULE
c
      module Local
      ALLOCATABLE BUFF(:), IZONE(:), ICH(:), IBUFF(:)
      INTEGER NLIST, NVAL
      end module

      module StressPeriods
      Allocatable PERLEN(:),NSTP(:),TSMULT(:)
      end module StressPeriods
c
C     ******************************************************************
C
C     This program is based on ZONEBUDGET which is
c     documented in USGS Open-File Report 90-392,
C     written by Arlen W. Harbaugh
C     ******************************************************************
C        SPECIFICATIONS:
      SUBROUTINE ReadArray(TOTIM,KSTP,KPER,IRESULT,TEXT)
      USE FlowRead
      USE Local
      CHARACTER*16 TEXT,CTMP
      INTEGER IRESULT
      INTEGER KSTP,KPER,NC,NR,NL
      INCLUDE 'openspec.inc'
      DLL_EXPORT ReadArray
C     ------------------------------------------------------------------
C
C-----INITIALIZE VARIABLES
      ZERO=0.0
      NLIST=0
      NVAL=1
      TOTIM=-1
C
C-----READ BUDGET DATA
100   READ(INBUD,END=1000) KSTP,KPER,TEXT,NC,NR,NL
      ITYPE=0
      IF(NL.LT.0) THEN
         READ(INBUD) ITYPE,DELT,PERTIM,TOTIM
         NVAL=1
         IF(ITYPE.EQ.5) THEN
            READ(INBUD) NVAL
            IF(NVAL.GT.1) THEN
               DO 101 N=2,NVAL
               READ(INBUD) CTMP
101            CONTINUE
            END IF
         END IF
         IF(ITYPE.EQ. 2 .OR. ITYPE.EQ.5) READ(INBUD) NLIST
      END IF
C
C-----READ THE BUDGET TERM DATA UNDER THE FOLLOWING CONDITIONS:
      IF(ITYPE.EQ.0 .OR. ITYPE.EQ.1) THEN
C  FULL 3-D ARRAY
         READ(INBUD) (BUFF(I),I=1,NODES)
      ELSE IF(ITYPE.EQ.3) THEN
C  1-LAYER ARRAY WITH LAYER INDICATOR ARRAY
         DO 260 I=1,NODES
         BUFF(I)=ZERO
260      CONTINUE
         READ(INBUD) (IBUFF(I),I=1,NRC)
         READ(INBUD) (BUFF(I),I=1,NRC)
         DO 270 I=1,NRC
         IF(IBUFF(I).GT.1) THEN
            LAYMOV=(IBUFF(I)-1)*NRC
            BUFF(LAYMOV+I)=BUFF(I)
            BUFF(I)=ZERO
         END IF
270      CONTINUE
      ELSE IF(ITYPE.EQ.4) THEN
C  1-LAYER ARRAY THAT DEFINES LAYER 1
         READ(INBUD) (BUFF(I),I=1,NRC)
         IF(NODES.GT.NRC) THEN
            DO 280 I=NRC+1,NODES
            BUFF(I)=ZERO
280         CONTINUE
         END IF
      END IF
C
C-----PROCESS A BUDGET TERM AND THEN START THE READ PROCESS OVER
      CALL ACCM(BUFF,IZONE,ICH,TEXT,ITYPE,NLIST,NVAL)
      IRESULT = 0
      RETURN
C
C  THE END OF FILE WAS REACHED
1000  continue
      IRESULT = 1
      RETURN
C
C-----EMPTY BUDGET FILE
2000  continue
      IRESULT = 2
      RETURN
C
      END
c
      SUBROUTINE ACCM(BUFF,IZONE,ICH,TEXT,ITYPE,NLIST,NVAL)
C     ******************************************************************
C     ACCUMULATE VOLUMETRIC BUDGET FOR ZONES
C     ******************************************************************
      USE FlowRead
      DIMENSION BUFF(NCOL,NROW,NLAY),
     1  IZONE(NCOL,NROW,NLAY),
     2  ICH(NCOL,NROW,NLAY)
      CHARACTER*16 TEXT
      DIMENSION VAL(10)
C     ------------------------------------------------------------------
      ZERO=0.0
      NRC=NROW*NCOL
      call InitializeArray
C
C-----CHECK FOR INTERNAL FLOW TERMS, WHICH ARE USED TO CALCULATE FLOW
C-----BETWEEN ZONES, AND CONSTANT-HEAD TERMS
      IF(TEXT.EQ.'   CONSTANT HEAD') GO TO 200
      IF(TEXT.EQ.'FLOW RIGHT FACE ') GO TO 300
      IF(TEXT.EQ.'FLOW FRONT FACE ') GO TO 400
      IF(TEXT.EQ.'FLOW LOWER FACE ') GO TO 500
C
C-----NOT AN INTERNAL FLOW TERM, SO MUST BE A SOURCE TERM OR STORAGE
C-----ACCUMULATE THE FLOW BY ZONE
      IF(ITYPE.EQ.2 .OR. ITYPE.EQ.5) THEN
C  LIST
         IF(NLIST.GT.0) THEN
            DO 80 N=1,NLIST
            READ(INBUD) ICELL,(VAL(I),I=1,NVAL)
            K= (ICELL-1)/NRC + 1
            I= ( (ICELL - (K-1)*NRC)-1 )/NCOL +1
            J= ICELL - (K-1)*NRC - (I-1)*NCOL
            if ((j.ge.1).AND.(i.ge.1).AND.(k.ge.1).AND.(j.le.ncol).AND.
     1       (i.le.NROW).AND.(k.le.NLAY)) then
              FlowValues(J,I,K) = FlowValues(J,I,K) + VAL(1)
            endif
80          CONTINUE
         END IF
      ELSE
         DO 100 K=1,NLAY
         DO 100 I=1,NROW
         DO 100 J=1,NCOL
         FlowValues(J,I,K) = BUFF(J,I,K)
  100    CONTINUE
      END IF
C
      RETURN
C
C-----CONSTANT-HEAD FLOW -- DON'T ACCUMULATE THE CELL-BY-CELL VALUES FOR
C-----CONSTANT-HEAD FLOW BECAUSE THEY MAY INCLUDE PARTIALLY CANCELING
C-----INS AND OUTS.  USE CONSTANT-HEAD TERM TO IDENTIFY WHERE CONSTANT-
C-----HEAD CELLS ARE AND THEN USE FACE FLOWS TO DETERMINE THE AMOUNT OF
C-----FLOW.  STORE CONSTANT-HEAD LOCATIONS IN ICH ARRAY.
200   IF(ITYPE.EQ.2 .OR. ITYPE.EQ.5) THEN
         DO 240 K=1,NLAY
         DO 240 I=1,NROW
         DO 240 J=1,NCOL
         ICH(J,I,K)=0
240      CONTINUE
         IF(NLIST.GT.0) THEN
            DO 250 N=1,NLIST
            READ(INBUD) ICELL,(VAL(I),I=1,NVAL)
            K= (ICELL-1)/NRC + 1
            I= ( (ICELL - (K-1)*NRC)-1 )/NCOL +1
            J= ICELL - (K-1)*NRC - (I-1)*NCOL
            if ((j.ge.1).AND.(i.ge.1).AND.(k.ge.1).AND.(j.le.ncol).AND.
     1       (i.le.NROW).AND.(k.le.NLAY)) then
               ICH(J,I,K)=1
            end if
250         CONTINUE
         END IF
      ELSE
         DO 260 K=1,NLAY
         DO 260 I=1,NROW
         DO 260 J=1,NCOL
         ICH(J,I,K)=0
         IF(BUFF(J,I,K).NE.ZERO) ICH(J,I,K)=1
260      CONTINUE
      END IF
      RETURN
C
C-----"FLOW RIGHT FACE"  COMPUTE FLOW BETWEEN ZONES ACROSS COLUMNS.
C-----COMPUTE FLOW ONLY BETWEEN A ZONE AND A HIGHER ZONE -- FLOW FROM
C-----ZONE 4 TO 3 IS THE NEGATIVE OF FLOW FROM 3 TO 4.
C-----1ST, CALCULATE FLOW BETWEEN NODE J,I,K AND J-1,I,K
300   IF(NCOL.LT.2) RETURN
      DO 340 K=1,NLAY
      DO 340 I=1,NROW
      DO 340 J=1,NCOL
C  Don't include CH to CH flow (can occur if CHTOCH option is used)
      if (J.ne.1) then
        IF(ICH(J,I,K).EQ.1 .AND. ICH(J-1,I,K).EQ.1) GO TO 340
      end if
      FlowValues(J,I,K)=BUFF(J,I,K)
  340 CONTINUE
C
C
      RETURN
C
C-----"FLOW FRONT FACE"
C-----CALCULATE FLOW BETWEEN NODE J,I,K AND J,I-1,K
400   IF(NROW.LT.2) RETURN
      DO 440 K=1,NLAY
      DO 440 I=1,NROW
      DO 440 J=1,NCOL
C  Don't include CH to CH flow (can occur if CHTOCH option is used)
      if (I.ne.1) then
        IF(ICH(J,I,K).EQ.1 .AND. ICH(J,I-1,K).EQ.1) GO TO 440
      end if
      FlowValues(J,I,K)=BUFF(J,I,K)
  440 CONTINUE
C
      RETURN
C
C-----"FLOW LOWER FACE"
C-----CALCULATE FLOW BETWEEN NODE J,I,K AND J,I,K-1
500   IF(NLAY.LT.2) RETURN
      DO 540 K=1,NLAY
      DO 540 I=1,NROW
      DO 540 J=1,NCOL
C  Don't include CH to CH flow (can occur if CHTOCH option is used)
      if (K.ne.1) then
        IF(ICH(J,I,K).EQ.1 .AND. ICH(J,I,K-1).EQ.1) GO TO 540
      end if
      FlowValues(J,I,K)=BUFF(J,I,K)
  540 CONTINUE
C
      RETURN
C
      END
c
      SUBROUTINE OpenBudgetFile (IRESULT,NC,NR,NL,NAME)
      USE FlowRead
      USE Local
      implicit none
      INTEGER I
      INCLUDE 'openspec.inc'
      character (len=*) NAME
      CHARACTER*16 TEXT
      INTEGER KSTP,KPER,NC,NR,NL
      INTEGER IRESULT
      DLL_EXPORT OpenBudgetFile
      INBUD=12
      IRESULT = 0
      OPEN(UNIT=INBUD,FILE=NAME,STATUS='OLD',FORM=FORM,ACCESS=ACCESS,
     1               ERR=10)
C-----READ GRID SIZE FROM BUDGET FILE AND REWIND
      READ(INBUD,END=2000) KSTP,KPER,TEXT,NCOL,NROW,NLAY
      IF(NLAY.LT.0) NLAY=-NLAY
      REWIND(UNIT=INBUD)
      allocate (FlowValues(NCOL,NROW,NLAY))
      NC = NCOL
      NR = NROW
      NL = NLAY
      NRC=NROW*NCOL
      NODES=NRC*NLAY
C-----Allocate temporary arrays
      ALLOCATE(BUFF(NODES), IZONE(NODES), ICH(NODES), IBUFF(NODES))
      return
10    continue
      IRESULT = 1
c need to return if there is an error.
      Return
2000  continue
c reached end of file
      IRESULT = 2
      return
      END
C
      SUBROUTINE CloseBudgetFile
      USE FlowRead
      USE Local
      LOGICAL ISOPEN
      DLL_EXPORT CloseBudgetFile
      INQUIRE(UNIT=INBUD,opened=ISOPEN)
      IF (ISOPEN) CLOSE(UNIT=INBUD)
      IF (ALLOCATED(FlowValues)) deallocate (FlowValues)
      IF (ALLOCATED(BUFF)) deallocate (BUFF)
      IF (ALLOCATED(IZONE)) deallocate (IZONE)
      IF (ALLOCATED(ICH)) deallocate (ICH)
      IF (ALLOCATED(IBUFF)) deallocate (IBUFF)
      Return
      END
c
      subroutine InitializeArray
      USE FlowRead
         DO 260 K=1,NLAY
         DO 260 I=1,NROW
         DO 260 J=1,NCOL
         FlowValues(J,I,K)=0
260      CONTINUE
      end subroutine
c
      subroutine GetValue (Layer,Row,Column,Value)
      USE FlowRead
      INTEGER Layer,Row,Column
      REAL Value
      DLL_EXPORT GetValue
         Value = FlowValues(Column,Row,Layer)
      end subroutine

      SUBROUTINE DeAllocateStressPeriods
      USE StressPeriods
      DLL_EXPORT DeAllocateStressPeriods
      if (ALLOCATED(PERLEN)) DEALLOCATE(PERLEN)
      if (ALLOCATED(NSTP)) DEALLOCATE(NSTP)
      if (ALLOCATED(TSMULT)) DEALLOCATE(TSMULT)
      END SUBROUTINE DeAllocateStressPeriods

      subroutine ReadStressPeriods(Success, NPER, FNAME)
      USE StressPeriods
      character (len=*) FNAME
      LOGICAL Success, opnd
      CHARACTER*200 LINE
      REAl Dummy1D(:), Dummy2D(:,:)
      INTEGER Laycbd(:)
      ALLOCATABLE Dummy1D, Dummy2D, Laycbd
      INCLUDE 'openspec.inc'
      DLL_EXPORT ReadStressPeriods

C Read the stress period data from the Discretization file.
C1 Open the Discretization file
      OPEN(UNIT=10,FILE=FNAME,FORM= 'FORMATTED',
     1      ACCESS='SEQUENTIAL',STATUS='OLD    ',ACTION='READ',ERR=2000)
C
C5------READ NUMBER OF LAYERS, ROWS, COLUMNS, STRESS PERIODS, AND
C5------ITMUNI USING FREE OR FIXED FORMAT.
C
C2------READ FIRST RECORD
      INDIS = 10
      CALL URDCOM(INDIS,LINE)
      LLOC=1
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,NLAY,R, INDIS, Success)
      if (.not.Success) GOTO 2000
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,NROW,R, INDIS, Success)
      if (.not.Success) GOTO 2000
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,NCOL,R, INDIS, Success)
      if (.not.Success) GOTO 2000
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,NPER,R, INDIS, Success)
      if (.not.Success) GOTO 2000
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,ITMUNI,R, INDIS, Success)
      if (.not.Success) GOTO 2000
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,LENUNI,R, INDIS, Success)
      if (.not.Success) GOTO 2000
      Success  = .false.
      IF(NLAY.GT.200) GOTO 2000

c.3------Read confining bed information
      ALLOCATE(Laycbd(NLAY))
      READ(INDIS,*) (Laycbd(k),K=1,NLAY)

C------Read the DELR and DELC arrays.
      ALLOCATE(DUMMY1D(NCOL))
      CALL U1DREL(DUMMY1D,'dummy',NCOL,INDIS, Success)
      DEALLOCATE(DUMMY1D)
      if (.not.Success) GOTO 2000
      ALLOCATE(DUMMY1D(NROW))
      CALL U1DREL(DUMMY1D,'dummy',NROW,INDIS, Success)
      DEALLOCATE(DUMMY1D)
      if (.not.Success) GOTO 2000

      ALLOCATE(DUMMY2D(NCOL,NROW))
C------Read the top elevation of layer 1.
      CALL U2DREL(DUMMY2D,'dummy',NROW,NCOL,0,INDIS, Success)
      if (.not.Success) GOTO 2000

C------Read the bottom elevations.
      DO 20 K=1,NLAY
      KK=K
      CALL U2DREL(DUMMY2D,'dummy',NROW,NCOL,KK,INDIS, Success)
      IF(LAYCBD(K).NE.0) CALL U2DREL(DUMMY2D,'dummy',
     1          NROW,NCOL,KK,INDIS, Success)
      if (.not.Success) GOTO 2000
   20 CONTINUE
      DEALLOCATE(DUMMY2D)

      ALLOCATE(PERLEN(NPER),NSTP(NPER),TSMULT(NPER))
      DO 200 N=1,NPER
      READ(INDIS,'(A)') LINE
      LLOC=1
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,3,I,PERLEN(N),INDIS, Success)
      if (.not.Success) GOTO 2000
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,NSTP(N),R,INDIS, Success)
      if (.not.Success) GOTO 2000
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,3,I,TSMULT(N),INDIS, Success)
      if (.not.Success) GOTO 2000
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,INDIS, Success)
      if (.not.Success) GOTO 2000
      IF (LINE(ISTART:ISTOP).EQ.'TR') THEN
         ISSFLG=0
         ITR=1
      ELSE IF (LINE(ISTART:ISTOP).EQ.'SS') THEN
         ISSFLG=1
         ISS=1
      ELSE
        Success = .false.
        GOTO 2000
      END IF
      ZERO=0.
      IF(PERLEN(N).EQ.ZERO .AND. ISSFLG.EQ.0) THEN
        Success = .false.
        GOTO 2000
      END IF
      IF(TSMULT(N).LE.ZERO) THEN
        Success = .false.
        GOTO 2000
      END IF
      IF(PERLEN(N).LT.ZERO) THEN
        Success = .false.
        GOTO 2000
      END IF
  200 CONTINUE

      Success  = .true.
C Close discretization file
2000  inquire (10, opened=opnd)
      IF(opnd) CLOSE(UNIT=10)
      if (ALLOCATED(DUMMY2D)) DEALLOCATE(DUMMY2D)
      if (ALLOCATED(LAYCBD)) DEALLOCATE(LAYCBD)
c      if (.not.Success) call DeAllocateStressPeriods
      return
      END subroutine

      subroutine GetStressPeriod(I, PLen, N, Mult)
      USE StressPeriods
      REAL Mult
      DLL_EXPORT GetStressPeriod
        PLen = PERLEN(i)
        N = NSTP(i)
        Mult = TSMULT(i)
      end subroutine

      SUBROUTINE URDCOM(IN,LINE)
C
C-----VERSION 02FEB1999 URDCOM
C     ******************************************************************
C     READ COMMENTS FROM A FILE.  RETURN THE FIRST LINE
C     THAT IS NOT A COMMENT
C     ******************************************************************
C
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
      CHARACTER*(*) LINE
C     ------------------------------------------------------------------
   10 READ(IN,'(A)') LINE
      IF(LINE(1:1).NE.'#') RETURN
c      L=LEN(LINE)
c      IF(L.GT.79) L=79
c      DO 20 I=L,1,-1
c      IF(LINE(I:I).NE.' ') GO TO 30
c   20 CONTINUE
c   30 IF (IOUT.GT.0) WRITE(IOUT,'(1X,A)') LINE(1:I)
      GO TO 10
C
      END
      SUBROUTINE URWORD(LINE,ICOL,ISTART,ISTOP,NCODE,N,R,IN,Success)
C
C
C-----VERSION 1003 05AUG1992 URWORD
C     ******************************************************************
C     ROUTINE TO EXTRACT A WORD FROM A LINE OF TEXT, AND OPTIONALLY
C     CONVERT THE WORD TO A NUMBER.
C        ISTART AND ISTOP WILL BE RETURNED WITH THE STARTING AND
C          ENDING CHARACTER POSITIONS OF THE WORD.
C        THE LAST CHARACTER IN THE LINE IS SET TO BLANK SO THAT IF ANY
C          PROBLEMS OCCUR WITH FINDING A WORD, ISTART AND ISTOP WILL
C          POINT TO THIS BLANK CHARACTER.  THUS, A WORD WILL ALWAYS BE
C          RETURNED UNLESS THERE IS A NUMERIC CONVERSION ERROR.  BE SURE
C          THAT THE LAST CHARACTER IN LINE IS NOT AN IMPORTANT CHARACTER
C          BECAUSE IT WILL ALWAYS BE SET TO BLANK.
C        A WORD STARTS WITH THE FIRST CHARACTER THAT IS NOT A SPACE OR
C          COMMA, AND ENDS WHEN A SUBSEQUENT CHARACTER THAT IS A SPACE
C          OR COMMA.  NOTE THAT THESE PARSING RULES DO NOT TREAT TWO
C          COMMAS SEPARATED BY ONE OR MORE SPACES AS A NULL WORD.
C        FOR A WORD THAT BEGINS WITH "'", THE WORD STARTS WITH THE
C          CHARACTER AFTER THE QUOTE AND ENDS WITH THE CHARACTER
C          PRECEDING A SUBSEQUENT QUOTE.  THUS, A QUOTED WORD CAN
C          INCLUDE SPACES AND COMMAS.  THE QUOTED WORD CANNOT CONTAIN
C          A QUOTE CHARACTER.
C        IF NCODE IS 1, THE WORD IS CONVERTED TO UPPER CASE.
C        IF NCODE IS 2, THE WORD IS CONVERTED TO AN INTEGER.
C        IF NCODE IS 3, THE WORD IS CONVERTED TO A REAL NUMBER.
C     ******************************************************************
C
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
      CHARACTER*(*) LINE
      CHARACTER*20 STRING
      CHARACTER*30 RW
      CHARACTER*1 TAB
      LOGICAL Success
C     ------------------------------------------------------------------
      TAB=CHAR(9)
C
C1------Set last char in LINE to blank and set ISTART and ISTOP to point
C1------to this blank as a default situation when no word is found.  If
C1------starting location in LINE is out of bounds, do not look for a
C1------word.
      Success = .true.
      LINLEN=LEN(LINE)
      LINE(LINLEN:LINLEN)=' '
      ISTART=LINLEN
      ISTOP=LINLEN
      LINLEN=LINLEN-1
      IF(ICOL.LT.1 .OR. ICOL.GT.LINLEN) GO TO 100
C
C2------Find start of word, which is indicated by first character that
C2------is not a blank, a comma, or a tab.
      DO 10 I=ICOL,LINLEN
      IF(LINE(I:I).NE.' ' .AND. LINE(I:I).NE.','
     &    .AND. LINE(I:I).NE.TAB) GO TO 20
10    CONTINUE
      ICOL=LINLEN+1
      GO TO 100
C
C3------Found start of word.  Look for end.
C3A-----When word is quoted, only a quote can terminate it.
20    IF(LINE(I:I).EQ.'''') THEN
         I=I+1
         IF(I.LE.LINLEN) THEN
            DO 25 J=I,LINLEN
            IF(LINE(J:J).EQ.'''') GO TO 40
25          CONTINUE
         END IF
C
C3B-----When word is not quoted, space, comma, or tab will terminate.
      ELSE
         DO 30 J=I,LINLEN
         IF(LINE(J:J).EQ.' ' .OR. LINE(J:J).EQ.','
     &    .OR. LINE(J:J).EQ.TAB) GO TO 40
30       CONTINUE
      END IF
C
C3C-----End of line without finding end of word; set end of word to
C3C-----end of line.
      J=LINLEN+1
C
C4------Found end of word; set J to point to last character in WORD and
C-------set ICOL to point to location for scanning for another word.
40    ICOL=J+1
      J=J-1
      IF(J.LT.I) GO TO 100
      ISTART=I
      ISTOP=J
C
C5------Convert word to upper case and RETURN if NCODE is 1.
      IF(NCODE.EQ.1) THEN
         IDIFF=ICHAR('a')-ICHAR('A')
         DO 50 K=ISTART,ISTOP
            IF(LINE(K:K).GE.'a' .AND. LINE(K:K).LE.'z')
     1             LINE(K:K)=CHAR(ICHAR(LINE(K:K))-IDIFF)
50       CONTINUE
         RETURN
      END IF
C
C6------Convert word to a number if requested.
100   IF(NCODE.EQ.2 .OR. NCODE.EQ.3) THEN
         RW=' '
         L=30-ISTOP+ISTART
         IF(L.LT.1) GO TO 200
         RW(L:30)=LINE(ISTART:ISTOP)
         IF(NCODE.EQ.2) READ(RW,'(I30)',ERR=200) N
         IF(NCODE.EQ.3) READ(RW,'(F30.0)',ERR=200) R
      END IF
      RETURN
C
C7------Number conversion error.
200   IF(NCODE.EQ.3) THEN
         STRING= 'A REAL NUMBER'
         L=13
      ELSE
         STRING= 'AN INTEGER'
         L=10
      END IF
C
C7A-----If output unit is negative, set last character of string to 'E'.
C7D-----STOP after writing message.
      Success = .false.
      END

      SUBROUTINE U1DREL(A,ANAME,JJ,IN,Success)
C
C
C-----VERSION 1740 18APRIL1993 U1DREL
C     ******************************************************************
C     ROUTINE TO INPUT 1-D REAL DATA MATRICES
C       A IS ARRAY TO INPUT
C       ANAME IS 24 CHARACTER DESCRIPTION OF A
C       JJ IS NO. OF ELEMENTS
C       IN IS INPUT UNIT
C       IOUT IS OUTPUT UNIT
C     ******************************************************************
C
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
      CHARACTER*24 ANAME
      DIMENSION A(JJ)
      CHARACTER*20 FMTIN
      CHARACTER*200 CNTRL
      CHARACTER*200 FNAME
      LOGICAL Success
      DATA NUNOPN/99/
      INCLUDE 'openspec.inc'
C     ------------------------------------------------------------------
C
C1------READ ARRAY CONTROL RECORD AS CHARACTER DATA.
      READ(IN,'(A)') CNTRL
C
C2------LOOK FOR ALPHABETIC WORD THAT INDICATES THAT THE RECORD IS FREE
C2------FORMAT.  SET A FLAG SPECIFYING IF FREE FORMAT OR FIXED FORMAT.
      ICLOSE=0
      IFREE=1
      ICOL=1
      CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,1,N,R,IN,Success)
      if (.not.Success) return
      IF (CNTRL(ISTART:ISTOP).EQ.'CONSTANT') THEN
         LOCAT=0
      ELSE IF(CNTRL(ISTART:ISTOP).EQ.'INTERNAL') THEN
         LOCAT=IN
      ELSE IF(CNTRL(ISTART:ISTOP).EQ.'EXTERNAL') THEN
         CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,2,LOCAT,R,IN,Success)
         return
      ELSE IF(CNTRL(ISTART:ISTOP).EQ.'OPEN/CLOSE') THEN
         CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,0,N,R,IN,Success)
         RETURN
      ELSE
C
C2A-----DID NOT FIND A RECOGNIZED WORD, SO NOT USING FREE FORMAT.
C2A-----READ THE CONTROL RECORD THE ORIGINAL WAY.
         IFREE=0
         READ(CNTRL,1,ERR=500) LOCAT,CNSTNT,FMTIN,IPRN
    1    FORMAT(I10,F10.0,A20,I10)
!        Assume that the data is always from the same file
         LOCAT = 10
      END IF
C
C3------FOR FREE FORMAT CONTROL RECORD, READ REMAINING FIELDS.
      IF(IFREE.NE.0) THEN
         CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,3,N,CNSTNT,IN,Success)
         if (.not.Success) return
         IF(LOCAT.GT.0) THEN
            CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,1,N,R,IN,Success)
            if (.not.Success) return
            FMTIN=CNTRL(ISTART:ISTOP)
            CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,2,IPRN,R,IN,Success)
            if (.not.Success) return
         END IF
      END IF
C
C4------TEST LOCAT TO SEE HOW TO DEFINE ARRAY VALUES.
      IF(LOCAT.GT.0) GO TO 90
C
C4A-----LOCAT <0 OR =0; SET ALL ARRAY VALUES EQUAL TO CNSTNT. RETURN.
      DO 80 J=1,JJ
   80 A(J)=CNSTNT
      RETURN
C
C4B-----LOCAT>0; READ FORMATTED RECORDS USING FORMAT FMTIN.
   90 CONTINUE
      IF(FMTIN.EQ.'(FREE)') THEN
      READ(LOCAT,*) (A(J),J=1,JJ)
      ELSE
         READ(LOCAT,FMTIN) (A(J),J=1,JJ)
      END IF
      IF(ICLOSE.NE.0) CLOSE(UNIT=LOCAT)
C
C5------IF CNSTNT NOT ZERO THEN MULTIPLY ARRAY VALUES BY CNSTNT.
      ZERO=0.
      IF(CNSTNT.EQ.ZERO) GO TO 120
      DO 100 J=1,JJ
  100 A(J)=A(J)*CNSTNT
C
C6------IF PRINT CODE (IPRN) =0 OR >0 THEN PRINT ARRAY VALUES.
120   CONTINUE
C
C7------RETURN
      Success = .true.
      RETURN
C
C8------CONTROL RECORD ERROR.
 500  Success = .False.
      return
      END

      SUBROUTINE U2DREL(A,ANAME,II,JJ,K,IN,Success)
C
C
C-----VERSION 1539 22JUNE1993 U2DREL
C     ******************************************************************
C     ROUTINE TO INPUT 2-D REAL DATA MATRICES
C       A IS ARRAY TO INPUT
C       ANAME IS 24 CHARACTER DESCRIPTION OF A
C       II IS NO. OF ROWS
C       JJ IS NO. OF COLS
C       K IS LAYER NO. (USED WITH NAME TO TITLE PRINTOUT --)
C              IF K=0, NO LAYER IS PRINTED
C              IF K<0, CROSS SECTION IS PRINTED)
C       IN IS INPUT UNIT
C       IOUT IS OUTPUT UNIT
C     ******************************************************************
C
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
      CHARACTER*24 ANAME
      DIMENSION A(JJ,II)
      CHARACTER*20 FMTIN
      CHARACTER*200 CNTRL
      CHARACTER*16 TEXT
      CHARACTER*200 FNAME
      LOGICAL Success
      DATA NUNOPN/99/
      INCLUDE 'openspec.inc'
C     ------------------------------------------------------------------
C
C1------READ ARRAY CONTROL RECORD AS CHARACTER DATA.
      READ(IN,'(A)') CNTRL
C
C2------LOOK FOR ALPHABETIC WORD THAT INDICATES THAT THE RECORD IS FREE
C2------FORMAT.  SET A FLAG SPECIFYING IF FREE FORMAT OR FIXED FORMAT.
      ICLOSE=0
      IFREE=1
      ICOL=1
      CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,1,N,R,IN,Success)
      if (.not.Success) return
      IF (CNTRL(ISTART:ISTOP).EQ.'CONSTANT') THEN
         LOCAT=0
      ELSE IF(CNTRL(ISTART:ISTOP).EQ.'INTERNAL') THEN
         LOCAT=IN
      ELSE IF(CNTRL(ISTART:ISTOP).EQ.'EXTERNAL') THEN
         CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,2,LOCAT,R,IN,Success)
         return
      ELSE IF(CNTRL(ISTART:ISTOP).EQ.'OPEN/CLOSE') THEN
         CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,0,N,R,IN,Success)
         return
      ELSE
C
C2A-----DID NOT FIND A RECOGNIZED WORD, SO NOT USING FREE FORMAT.
C2A-----READ THE CONTROL RECORD THE ORIGINAL WAY.
         IFREE=0
         READ(CNTRL,1,ERR=500) LOCAT,CNSTNT,FMTIN,IPRN
    1    FORMAT(I10,F10.0,A20,I10)
!        Assume that the data is always from the same file
         LOCAT = 10
      END IF
C
C3------FOR FREE FORMAT CONTROL RECORD, READ REMAINING FIELDS.
      IF(IFREE.NE.0) THEN
         CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,3,N,CNSTNT,IN,Success)
         if (.not.Success) return
         IF(LOCAT.NE.0) THEN
            CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,1,N,R,IN,Success)
            if (.not.Success) return
            FMTIN=CNTRL(ISTART:ISTOP)
            IF(ICLOSE.NE.0) THEN
               return
            END IF
            IF(LOCAT.GT.0 .AND. FMTIN.EQ.'(BINARY)') LOCAT=-LOCAT
            CALL URWORD(CNTRL,ICOL,ISTART,ISTOP,2,IPRN,R,IN,Success)
            if (.not.Success) return
      END IF
      END IF
C
C4------TEST LOCAT TO SEE HOW TO DEFINE ARRAY VALUES.
      IF(LOCAT) 200,50,90
C
C4A-----LOCAT=0; SET ALL ARRAY VALUES EQUAL TO CNSTNT. RETURN.
   50 DO 80 I=1,II
      DO 80 J=1,JJ
   80 A(J,I)=CNSTNT
      RETURN
C
C4B-----LOCAT>0; READ FORMATTED RECORDS USING FORMAT FMTIN.
   90 CONTINUE
      DO 100 I=1,II
      IF(FMTIN.EQ.'(FREE)') THEN
         READ(LOCAT,*) (A(J,I),J=1,JJ)
      ELSE
         READ(LOCAT,FMTIN) (A(J,I),J=1,JJ)
      END IF
  100 CONTINUE
      GO TO 300
C
C4C-----LOCAT<0; READ UNFORMATTED ARRAY VALUES.
  200 LOCAT=-LOCAT
      READ(LOCAT) KSTP,KPER,PERTIM,TOTIM,TEXT,NCOL,NROW,ILAY
      READ(LOCAT) A
C
C5------IF CNSTNT NOT ZERO THEN MULTIPLY ARRAY VALUES BY CNSTNT.
  300 IF(ICLOSE.NE.0) CLOSE(UNIT=LOCAT)
      ZERO=0.
      IF(CNSTNT.EQ.ZERO) GO TO 320
      DO 310 I=1,II
      DO 310 J=1,JJ
      A(J,I)=A(J,I)*CNSTNT
  310 CONTINUE
  320 continue
C
C
      Success = .true.
C7------RETURN
      RETURN
C
C8------CONTROL RECORD ERROR.
  500 Success = .false.
      return
      END

