C***********************************************************************
C SUBROUTINE ARGUMENTS:
C
C      NCOL -- NUMBER OF COLUMNS
C      NROW -- NUMBER OF ROWS
C      NLAY -- NUMBER OF LAYERS
C      MXITER -- MAX OUTER ITERATIONS
C      IITER -- MAX INNER ITERATIONS PER OUTER ITERATION
C      RCLOSE -- RESIDUAL CONVERGENCE CRITERION
C      HCLOSE -- HEAD-CHANGE CONVERGENCE CRITERION
C      DAMP -- DAMPING PARAMETER
C      IADAMP -- ADAPTIVE DAMPING FLAG
C      IOUTGMG -- OUTPUT CONTROLL
C      IN -- INPUT UNIT NUMBER
C      IOUT -- OUTPUT UNIT NUMBER
C      HNEW -- CURRENT APPROXIMATION
C      RHS -- RIGHT-HAND SIDE
C      CR,CC,CV -- CONDUCTANCE ARRAYS
C      HCOF -- SOURCE ARRAY
C      HNOFLO -- NOFLOW VALUE
C      IBOUND -- BOUNDARY FLAG
C      KITER -- CURRENT OUTER ITERATION
C      KSTP -- CURRENT TIME-STEP
C      KPER -- CURRENT STRESS PERIOD
C      ICNVG -- CONVERGENCE FLAG
C***********************************************************************
C
C***********************************************************************
C     SUBROUTINE GMG1ALG:
C     READS INPUT FROM FILE TYPE GMG SPECIFIED IN NAME FILE
C     ALLOCATES GMG SOLVER
C
C      ISIZ -- NUMBER OF MB ALLOCATED BY GMG
C      IPREC -- PRECISION FLAG (0=SINGLE, OTHERWISE DOUBLE)
C      ISM -- SMOOTHER FLAG (0=ILU, GAUSS-SEIDEL OTHERWISE)
C      ISC -- SEMI-COARSENING FLAG
C             0 : MAX COARSENING FOR COLUMNS, ROWS, AND LAYERS
C             1 : MAX COARSENING FOR COLUMNS AND ROWS.
C             2 : MAX COARSENING FOR ROWS AND LAYERS
C             3 : MAX COARSENING FOR COLUMNS AND LAYERS
C             4 : NO COARSENING
C      RELAX -- ILU RELAXATION PARAMETER (IF ISC .EQ. 4)
C      IERR -- NEGATIVE VALUE INDICATES ERROR
C      IIOUT -- EQUALS IOUT UNLESS IOUTGMG IS EVEN, THEN UNIT 6
C
C***********************************************************************
      SUBROUTINE GMG1ALG(NCOL,NROW,NLAY,MXITER,IITER,
     &                   RCLOSE,HCLOSE,DAMP,IADAMP,IOUTGMG,IN,IOUT,
     &                   ISM,ISC,RELAX)
C--------------------------------------------------------------------
C     EXPLICIT DECLERATIONS
C--------------------------------------------------------------------
      IMPLICIT NONE
C
      INTEGER NCOL,NROW,NLAY,MXITER,IITER
      REAL RCLOSE,HCLOSE,DAMP
      DOUBLEPRECISION RELAX
      INTEGER IADAMP,IOUTGMG,IN,IOUT
C
      INTEGER ISIZ,IPREC,ISM
      INTEGER ISC,IERR,IIOUT
C
      CHARACTER*200 LINE
C
C--------------------------------------------------------------------
C     READ AND PRINT COMMENTS
C--------------------------------------------------------------------
      CALL URDCOM(IN,IOUT,LINE)
C
C--------------------------------------------------------------------
C     READ INPUT FILE
C--------------------------------------------------------------------
      READ(LINE,*) RCLOSE,IITER,HCLOSE,MXITER
      CALL URDCOM(IN,IOUT,LINE)
      READ(LINE,*) DAMP,IADAMP,IOUTGMG
      CALL URDCOM(IN,IOUT,LINE)
      READ(LINE,*) ISM,ISC
C
      RELAX=0.0D0
      IF(ISC .EQ. 4) THEN
        CALL URDCOM(IN,IOUT,LINE)
        READ(LINE,*) RELAX
      END IF
C
      IF(DAMP .LE. 0.0 .OR. DAMP .GT. 1.0) DAMP=1.0
      IIOUT=IOUT
      IF(IOUTGMG .GT. 2) IIOUT=6
C
C--------------------------------------------------------------------
C     ALLOCATE
C--------------------------------------------------------------------
C
C---- CHECK FOR FORCED DOUBLE PRECISION
C
      IPREC=0
      IF(KIND(DAMP) .EQ. 8) IPREC=1
C
c      CALL MF2KGMG_ALLOCATE(NCOL,NROW,NLAY,IPREC,ISM,ISC,
c     &                      RELAX,ISIZ,IERR)
!      IF(IERR .NE. 0) THEN
!        CALL USTOP('ALLOCATION ERROR IN SUBROUTINE GMG1ALG')
!      END IF
C
      WRITE(IOUT,500) RCLOSE,IITER,HCLOSE,MXITER,
     &                 DAMP,IADAMP,IOUTGMG,
     &                 ISM,ISC,RELAX
C
      IF(IADAMP .NE. 0) WRITE(IOUT,510)
      IF(ISM .EQ. 0) WRITE(IOUT,520)
      IF(ISM .EQ. 1) WRITE(IOUT,525)
      IF(ISC .EQ. 0) WRITE(IOUT,530)
      IF(ISC .EQ. 1) WRITE(IOUT,531)
      IF(ISC .EQ. 2) WRITE(IOUT,532)
      IF(ISC .EQ. 3) WRITE(IOUT,533)
      IF(ISC .EQ. 4) WRITE(IOUT,534)
C
!      WRITE(IOUT,540) ISIZ
C
C--------------------------------------------------------------------
C     FORMAT STATEMENTS
C--------------------------------------------------------------------
  500 FORMAT(1X,'-------------------------------------------------',/,
     &       1X,'GMG -- PCG GEOMETRIC MULTI-GRID SOLUTION PACKAGE:',/,
     &       1X,'-------------------------------------------------',/,
     &       1X,'RCLOSE  = ',1P,E8.2,'; INNER CONVERGENCE CRITERION',/,
     &       1X,'IITER   = ',I8,'; MAX INNER ITERATIONS            ',/,
     &       1X,'HCLOSE  = ',1P,E8.2,'; OUTER CONVERGENCE CRITERION',/,
     &       1X,'MXIITER = ',I8,'; MAX OUTER ITERATIONS            ',/,
     &       1X,'DAMP    = ',1P,E8.2,'; DAMPING PARAMETER          ',/,
     &       1X,'IADAMP  = ',I8,'; ADAPTIVE DAMPING FLAG           ',/,
     &       1X,'IOUTGMG = ',I8,'; OUTPUT CONTROL FLAG             ',/,
     &       1X,'ISM     = ',I8,'; SMOOTHER FLAG                   ',/,
     &       1X,'ISC     = ',I8,'; COARSENING FLAG                 ',/,
     &       1X,'RELAX   = ',1P,E8.2,'; RELAXATION PARAMETER       ',/,
     &       1X,"-------------------------------------------------")
C
  510 FORMAT(1X,"COOLEY'S ADAPTIVE DAMPING METHOD IMPLEMENTED")
  520 FORMAT(1X,'ILU SMOOTHING IMPLEMENTED')
  525 FORMAT(1X,'SGS SMOOTHING IMPLEMENTED')
C
  530 FORMAT(1X,'FULL COARSENING')
  531 FORMAT(1X,'COARSENING ALONG COLUMNS AND ROWS ONLY')
  532 FORMAT(1X,'COARSENING ALONG ROWS AND LAYERS ONLY')
  533 FORMAT(1X,'COARSENING ALONG COLUMNS AND LAYERS ONLY')
  534 FORMAT(1X,'NO COARSENING')
C
  540 FORMAT(1X,'-------------------------------------------------',/,
     &       1X,I4,' MEGABYTES OF MEMORY ALLOCATED BY GMG',/,
     &       1X,'-------------------------------------------------',/)
C
      RETURN
      END
C

