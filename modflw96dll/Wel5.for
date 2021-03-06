      SUBROUTINE WEL5AL(ISUM,LENX,LCWELL,MXWELL,NWELLS,IN,IOUT,IWELCB,
     1        NWELVL,IWELAL,IFREFM)
C
C-----VERSION 0820 21FEB1996 WEL5AL
C     ******************************************************************
C     ALLOCATE ARRAY STORAGE FOR WELL PACKAGE
C     ******************************************************************
C
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
      COMMON /WELCOM/WELAUX(5)
      CHARACTER*16 WELAUX
      CHARACTER*80 LINE
C     ------------------------------------------------------------------
C
C1------IDENTIFY PACKAGE AND INITIALIZE NWELLS.
      WRITE(IOUT,1)IN
    1 FORMAT(1X,/1X,'WEL5 -- WELL PACKAGE, VERSION 5, 9/1/93',
     1' INPUT READ FROM UNIT',I3)
      NWELLS=0
C
C2------READ MAXIMUM NUMBER OF WELLS AND UNIT OR FLAG FOR
C2------CELL-BY-CELL FLOW TERMS.
      READ(IN,'(A)') LINE
      IF(IFREFM.EQ.0) THEN
         READ(LINE,'(2I10)') MXWELL,IWELCB
         LLOC=21
      ELSE
         LLOC=1
         CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,MXWELL,R,IOUT,IN)
         CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,IWELCB,R,IOUT,IN)
      END IF
      WRITE(IOUT,3) MXWELL
    3 FORMAT(1X,'MAXIMUM OF',I5,' WELLS')
      IF(IWELCB.LT.0) WRITE(IOUT,7)
    7 FORMAT(1X,'CELL-BY-CELL FLOWS WILL BE PRINTED WHEN ICBCFL NOT 0')
      IF(IWELCB.GT.0) WRITE(IOUT,8) IWELCB
    8 FORMAT(1X,'CELL-BY-CELL FLOWS WILL BE SAVED ON UNIT',I3)
C
C3------READ AUXILIARY PARAMETERS AND CBC ALLOCATION OPTION.
      IWELAL=0
      NAUX=0
   10 CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,N,R,IOUT,IN)
      IF(LINE(ISTART:ISTOP).EQ.'CBCALLOCATE' .OR.
     1   LINE(ISTART:ISTOP).EQ.'CBC') THEN
         IWELAL=1
         WRITE(IOUT,11)
   11    FORMAT(1X,'MEMORY IS ALLOCATED FOR CELL-BY-CELL BUDGET TERMS')
         GO TO 10
      ELSE IF(LINE(ISTART:ISTOP).EQ.'AUXILIARY' .OR.
     1        LINE(ISTART:ISTOP).EQ.'AUX') THEN
         CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,N,R,IOUT,IN)
         IF(NAUX.LT.5) THEN
            NAUX=NAUX+1
            WELAUX(NAUX)=LINE(ISTART:ISTOP)
            WRITE(IOUT,12) WELAUX(NAUX)
   12       FORMAT(1X,'AUXILIARY WELL PARAMETER: ',A)
         END IF
         GO TO 10
      END IF
      NWELVL=4+NAUX+IWELAL
C
C4------ALLOCATE SPACE IN THE X ARRAY FOR THE WELL ARRAY.
      LCWELL=ISUM
      ISP=NWELVL*MXWELL
      ISUM=ISUM+ISP
C
C5------PRINT NUMBER OF SPACES IN X ARRAY USED BY WELL PACKAGE.
      WRITE(IOUT,14) ISP
   14 FORMAT(1X,I10,' ELEMENTS IN X ARRAY ARE USED BY WEL')
      ISUM1=ISUM-1
      WRITE(IOUT,15) ISUM1,LENX
   15 FORMAT(1X,I10,' ELEMENTS OF X ARRAY USED OUT OF ',I10)
      IF(ISUM1.GT.LENX) WRITE(IOUT,16)
   16 FORMAT(1X,'   ***X ARRAY MUST BE DIMENSIONED LARGER***')
C
C6------RETURN
      RETURN
      END
      SUBROUTINE WEL5RP(WELL,NWELLS,MXWELL,IN,IOUT,NWELVL,IWELAL,IFREFM)
C
C-----VERSION 0823 21FEB1996 WEL5RP
C     ******************************************************************
C     READ NEW WELL LOCATIONS AND STRESS RATES
C     ******************************************************************
C
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
      DIMENSION WELL(NWELVL,MXWELL)
      COMMON /WELCOM/WELAUX(5)
      CHARACTER*16 WELAUX
      CHARACTER*151 LINE
C     ------------------------------------------------------------------
C
C1------READ ITMP(NUMBER OF WELLS OR FLAG SAYING REUSE WELL DATA).
      IF(IFREFM.EQ.0) THEN
         READ(IN,'(I10)') ITMP
      ELSE
         READ(IN,*) ITMP
      END IF
      IF(ITMP.GE.0) GO TO 50
C
C1A-----IF ITMP LESS THAN ZERO REUSE DATA. PRINT MESSAGE AND RETURN.
      WRITE(IOUT,6)
    6 FORMAT(1X,/1X,'REUSING WELLS FROM LAST STRESS PERIOD')
      RETURN
C
C1B-----ITMP=>0.  SET NWELLS EQUAL TO ITMP.
   50 NWELLS=ITMP
      IF(NWELLS.LE.MXWELL) GO TO 100
C
C2------NWELLS>MXWELL.  PRINT MESSAGE. STOP.
      WRITE(IOUT,99) NWELLS,MXWELL
   99 FORMAT(1X,/1X,'NWELLS(',I4,') IS GREATER THAN MXWELL(',I4,')')
      STOP
C
C3------PRINT NUMBER OF WELLS IN CURRENT STRESS PERIOD.
  100 WRITE (IOUT,101) NWELLS
  101 FORMAT(1X,//1X,I5,' WELLS')
C
C4------IF THERE ARE NO ACTIVE WELLS IN THIS STRESS PERIOD THEN RETURN.
      IF(NWELLS.EQ.0) GO TO 260
C
C5------READ AND PRINT DATA FOR EACH WELL.
      NAUX=NWELVL-4-IWELAL
      MAXAUX=NWELVL-IWELAL
      IF(NAUX.GT.0) THEN
         WRITE(IOUT,103) (WELAUX(JJ),JJ=1,NAUX)
         WRITE(IOUT,104) ('------------------',JJ=1,NAUX)
      ELSE
         WRITE(IOUT,103)
         WRITE(IOUT,104)
      END IF
  103 FORMAT(1X,/
     1       1X,'LAYER   ROW   COL   STRESS RATE   WELL NO.',:5(2X,A))
  104 FORMAT(1X,42('-'),5A)
      DO 250 II=1,NWELLS
C5A-----READ THE REQUIRED DATA WITH FIXED OR FREE FORMAT.
      READ(IN,'(A)') LINE
      IF(IFREFM.EQ.0) THEN
         READ(LINE,'(3I10,F10.0)') K,I,J,WELL(4,II)
         LLOC=41
      ELSE
         LLOC=1
         CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,K,R,IOUT,IN)
         CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,I,R,IOUT,IN)
         CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,J,R,IOUT,IN)
         CALL URWORD(LINE,LLOC,ISTART,ISTOP,3,N,WELL(4,II),IOUT,IN)
      END IF
C5B-----READ ANY AUXILIARY DATA WITH FREE FORMAT, AND PRINT ALL VALUES.
      IF(NAUX.GT.0) THEN
         DO 110 JJ=1,NAUX
         CALL URWORD(LINE,LLOC,ISTART,ISTOP,3,N,WELL(JJ+4,II),IOUT,IN)
  110    CONTINUE
         WRITE (IOUT,115) K,I,J,WELL(4,II),II,
     1         (WELL(JJ,II),JJ=5,MAXAUX)
      ELSE
         WRITE (IOUT,115) K,I,J,WELL(4,II),II
      END IF
  115 FORMAT(1X,I4,I7,I6,G15.5,I7,:5(2X,G16.5))
      WELL(1,II)=K
      WELL(2,II)=I
      WELL(3,II)=J
  250 CONTINUE
C
C6------RETURN
  260 RETURN
      END
      SUBROUTINE WEL5FM(NWELLS,MXWELL,RHS,WELL,IBOUND,
     1        NCOL,NROW,NLAY,NWELVL)
C
C-----VERSION 1101 28AUG1992 WEL5FM
C
C     ******************************************************************
C     SUBTRACT Q FROM RHS
C     ******************************************************************
C
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
      DIMENSION RHS(NCOL,NROW,NLAY),WELL(NWELVL,MXWELL),
     1            IBOUND(NCOL,NROW,NLAY)
C     ------------------------------------------------------------------
C1------IF NUMBER OF WELLS <= 0 THEN RETURN.
      IF(NWELLS.LE.0) RETURN
C
C2------PROCESS EACH WELL IN THE WELL LIST.
      DO 100 L=1,NWELLS
      IR=WELL(2,L)
      IC=WELL(3,L)
      IL=WELL(1,L)
      Q=WELL(4,L)
C
C2A-----IF THE CELL IS INACTIVE THEN BYPASS PROCESSING.
      IF(IBOUND(IC,IR,IL).LE.0) GO TO 100
C
C2B-----IF THE CELL IS VARIABLE HEAD THEN SUBTRACT Q FROM
C       THE RHS ACCUMULATOR.
      RHS(IC,IR,IL)=RHS(IC,IR,IL)-Q
  100 CONTINUE
C
C3------RETURN
      RETURN
      END
      SUBROUTINE WEL5BD(NWELLS,MXWELL,VBNM,VBVL,MSUM,WELL,IBOUND,DELT,
     1        NCOL,NROW,NLAY,KSTP,KPER,IWELCB,ICBCFL,BUFF,IOUT,
     2        PERTIM,TOTIM,NWELVL,IWELAL)
C-----VERSION 1120 16APRIL1993 WEL5BD
C     ******************************************************************
C     CALCULATE VOLUMETRIC BUDGET FOR WELLS
C     ******************************************************************
C
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
      CHARACTER*16 VBNM(MSUM),TEXT
      DIMENSION VBVL(4,MSUM),WELL(NWELVL,MXWELL),IBOUND(NCOL,NROW,NLAY),
     1          BUFF(NCOL,NROW,NLAY)
      DOUBLE PRECISION RATIN,RATOUT,QQ
      DATA TEXT /'           WELLS'/
C     ------------------------------------------------------------------
C
C1------CLEAR RATIN AND RATOUT ACCUMULATORS, AND SET CELL-BY-CELL
C1------BUDGET FLAG.
      ZERO=0.
      RATIN=ZERO
      RATOUT=ZERO
      IBD=0
      IF(IWELCB.LT.0 .AND. ICBCFL.NE.0) IBD=-1
      IF(IWELCB.GT.0) IBD=ICBCFL
      IBDLBL=0
C
C2-----IF CELL-BY-CELL FLOWS WILL BE SAVED AS A LIST, WRITE HEADER.
      IF(IBD.EQ.2) CALL UBDSV2(KSTP,KPER,TEXT,IWELCB,NCOL,NROW,NLAY,
     1          NWELLS,IOUT,DELT,PERTIM,TOTIM,IBOUND)
C
C3------CLEAR THE BUFFER.
      DO 50 IL=1,NLAY
      DO 50 IR=1,NROW
      DO 50 IC=1,NCOL
      BUFF(IC,IR,IL)=ZERO
50    CONTINUE
C
C4------IF THERE ARE NO WELLS, DO NOT ACCUMULATE FLOW.
      IF(NWELLS.EQ.0) GO TO 200
C
C5------LOOP THROUGH EACH WELL CALCULATING FLOW.
      DO 100 L=1,NWELLS
C
C5A-----GET LAYER, ROW & COLUMN OF CELL CONTAINING WELL.
      IR=WELL(2,L)
      IC=WELL(3,L)
      IL=WELL(1,L)
      Q=ZERO
C
C5B-----IF THE CELL IS NO-FLOW OR CONSTANT_HEAD, IGNORE IT.
      IF(IBOUND(IC,IR,IL).LE.0)GO TO 99
C
C5C-----GET FLOW RATE FROM WELL LIST.
      Q=WELL(4,L)
      QQ=Q
C
C5D-----PRINT FLOW RATE IF REQUESTED.
      IF(IBD.LT.0) THEN
         IF(IBDLBL.EQ.0) WRITE(IOUT,61) TEXT,KPER,KSTP
   61    FORMAT(1X,/1X,A,'   PERIOD',I3,'   STEP',I3)
         WRITE(IOUT,62) L,IL,IR,IC,Q
   62    FORMAT(1X,'WELL',I4,'   LAYER',I3,'   ROW',I4,'   COL',I4,
     1       '   RATE',1PG15.6)
         IBDLBL=1
      END IF
C
C5E-----ADD FLOW RATE TO BUFFER.
      BUFF(IC,IR,IL)=BUFF(IC,IR,IL)+Q
C
C5F-----SEE IF FLOW IS POSITIVE OR NEGATIVE.
      IF(Q) 90,99,80
C
C5G-----FLOW RATE IS POSITIVE (RECHARGE). ADD IT TO RATIN.
   80 RATIN=RATIN+QQ
      GO TO 99
C
C5H-----FLOW RATE IS NEGATIVE (DISCHARGE). ADD IT TO RATOUT.
   90 RATOUT=RATOUT-QQ
C
C5I-----IF CELL-BY-CELL FLOWS ARE BEING SAVED AS A LIST, WRITE FLOW.
C5I-----OR IF RETURNING THE FLOW IN THE WELL ARRAY, COPY FLOW TO WELL.
   99 IF(IBD.EQ.2) CALL UBDSVA(IWELCB,NCOL,NROW,IC,IR,IL,Q,IBOUND,NLAY)
      IF(IWELAL.NE.0) WELL(NWELVL,L)=Q
  100 CONTINUE
C
C6------IF CELL-BY-CELL FLOWS WILL BE SAVED AS A 3-D ARRAY,
C6------CALL UBUDSV TO SAVE THEM.
      IF(IBD.EQ.1) CALL UBUDSV(KSTP,KPER,TEXT,IWELCB,BUFF,NCOL,NROW,
     1                          NLAY,IOUT)
C
C7------MOVE RATES, VOLUMES & LABELS INTO ARRAYS FOR PRINTING.
  200 RIN=RATIN
      ROUT=RATOUT
      VBVL(3,MSUM)=RIN
      VBVL(4,MSUM)=ROUT
      VBVL(1,MSUM)=VBVL(1,MSUM)+RIN*DELT
      VBVL(2,MSUM)=VBVL(2,MSUM)+ROUT*DELT
      VBNM(MSUM)=TEXT
C
C8------INCREMENT BUDGET TERM COUNTER(MSUM).
      MSUM=MSUM+1
C
C9------RETURN
      RETURN
      END
