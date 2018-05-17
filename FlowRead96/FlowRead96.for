C     Last change:  RBW  27 Apr 2006    3:03 pm
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
c
C     ******************************************************************
C
C     This program is based on ZONEBUDGET which is
c     documented in USGS Open-File Report 90-392,
C     written by Arlen W. Harbaugh
C     ******************************************************************
C        SPECIFICATIONS:
      SUBROUTINE ReadArray96(TOTIM,KSTP,KPER,IRESULT,TEXT)
      USE FlowRead
      USE Local
      CHARACTER*16 TEXT,CTMP
      INTEGER IRESULT
      INTEGER KSTP,KPER,NC,NR,NL
      INCLUDE 'openspec96.inc'
      DLL_EXPORT ReadArray96
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
              FlowValues(J,I,K) = VAL(1)
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
            endif

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
      SUBROUTINE OpenBudgetFile96 (IRESULT,NC,NR,NL,NAME)
      USE FlowRead
      USE Local
      implicit none
      INTEGER I
      INCLUDE 'openspec96.inc'
      character (len=*) NAME
      CHARACTER*16 TEXT
      INTEGER KSTP,KPER,NC,NR,NL
      INTEGER IRESULT
      DLL_EXPORT OpenBudgetFile96
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
      SUBROUTINE CloseBudgetFile96
      USE FlowRead
      USE Local
      LOGICAL ISOPEN
      DLL_EXPORT CloseBudgetFile96
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
      subroutine GetValue96 (Layer,Row,Column,Value)
      USE FlowRead
      INTEGER Layer,Row,Column
      REAL Value
      DLL_EXPORT GetValue96
         Value = FlowValues(Column,Row,Layer)
      end subroutine
