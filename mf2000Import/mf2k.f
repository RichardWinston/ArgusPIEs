! The MODFLOW code has been altered to read data but not to process it by
! removing subroutine calls that formulate or approximate the solution
! for each time step.
! NLAY, integer, number of layers
! NROW, integer, number of rows
! NCOL, integer, number of columns
! NPER, integer, number of stress periods
! ITMUNI, integer, time unit
! LENUNI, integer, length unit
! ISENALL, integer, a flag in the sensitivy process.
! NPLIST, integer, SEN process
! IUHEAD, integer, SEN process
! MXSEN, integer, SEN process
! NZN, integer, number of zone arrays.
! NML, integer, number of multiplier arrays.
! MXITER, integer, maximum iterations in SIP, SOR, and PCG2
! NPARM, integer, number of parameters is SIP
! ITMX, integer, DE45 package
! MXUP, integer, DE45 package
! MXLOW, integer, DE45 package
! MXBW, integer, DE45 package
! ITER1, integer, PCG2 package
! NPCOND, integer, PCG2 package
! ICG, integer LMG package
! IPRINTS, integer, SEN process
! ISENSU, integer, SEN process
! ISENPU, integer, SEN process
! ISENFM, integer, SEN process
! ITMXP, integer, MAX-ITER, PES process
! IBEFLG, integer, PES process
! IYCFLG, integer, PES process
! IOSTAR, integer, PES process
! NOPT, integer, PES process
! NFIT, integer, PES process
! IAP, integer, PES process
! IPRC, integer, IPR-COV, PES process
! IPRINT, integer, PES process
! LPRINT, integer, PES process
! LASTX, integer, PES process
! NPNG, integer, PES process
! IPR, integer, PES process
! MPR, integer, PES process
! ISCALS, integer, OBS process
! NH, integer, head OBS process, number of head observations
! MOBS, integer, head OBS process,
! MAXM, integer, head OBS process,
! NQDR, integer, drain OBS process
! NQTDR, integer, drain OBS process
! NQRV, NQTRV, integer, river OBS process
! NQGB, NQTGB, integer, GHB OBS process
! NQST,NQTST, integer, stream OBS process
! NQCH,NQTCH, integer, constant-heads OBS process
! NQDT,NQTDT, integer, drain-return OBS process
! NPTH, NTT2, IOUTT2, KTFLG, KTREV, integer, ADV OBS process
! NZONAR, integer, number of zone arrays
! NMLTAR, integer, number of multiplier arrays
! NHUF, integer, number of HUF units
! IOUTG,IOUT, integer, output unit numbers.
! NBDTIM FHB package, number of times

! HDRY, real, head displayed in dry cells.
! STOR1, STOR2, STOR3, real LMG package
! DMAX, real, MAX-CHANGE, PES process
! TOL, real,  PES process
! SOSC, real,  PES process
! SOSC, real,  PES process
! SOSR, real,  PES process
! RMAR, real,  PES process
! RMARM, real,  PES process
! CSA, real,  PES process
! FCONV, real,  PES process
! ADVSTP, FSNK, real, ADV OBS process
!
! LCIZON, integer, location of zone array data in IG.
! LCRMLT, integer, location of multiplier array in GX.
! LCDELR, integer, location of DELR array in GX
! LCDELC, integer, location of DELC array in GX
! LCBOTM, integer, LOCATION of the BOTM array (with length NCOL*NROW*(NBOTM+1)) in GX array
! LCHNEW, integer, location of HNEW array with length NRCL
! LCHOLD, integer, location of HOLD array with length NRCL
! LCIBOU, integer, location of IBOUND array with length NRCL
! LCCR, integer, location of (conductanced along rows)? array with length NRCL
! LCCC, integer, location of (conductance along columns)? array with length NRCL
! LCCV, integer, location of (vertical conductance)? array with length NROW*NCOL*(NLAY-1)
! LCHCOF, integer, location of ? array with length NRCL
! LCRHS, integer, location of ? array with length NRCL
! LCBUFF, integer, location of ? array with length NRCL
! LCSTRT, integer, location of ? array with length NRCL
! LCOBDRN, integer, location of drain observation array
! LCSSDR, integer, location of ? in drain observation package
! LCOBRIV, integer, location of river observation array
! LCSSRV, integer, location of ? in river observation package
! LCOBGHB, integer, location of GHB observation array
! LCSSGB, integer, location of ? in GHB observation package
! LCOBSTR, integer, location of stream observation array
! LCSSST, integer, location of ? in stream observation array
! LCOBCHD, integer, location of constant head observation array
! LCSSCH, integer, location of ? in constant head observation array
! LCOBDRT, integer, location of drain-return observation array
! LCSSDT, integer, location of ? in drain-return observation array
! LCOBADV, integer, locatoin of ADV OBS array
! LCBL, integer, location of BL array in X array (SEN)
! LCBU, integer, location of BU array in X array (SEN)
! LCISEN, integer, location of ISENS array in IX array (SEN)
! LCLN, integer, location of LN array in IX array (SEN)
! LCBSCA, integer, location of BSCAL array in X array (SEN)

! LCWP, integer, location of WP array in X array (PES)
! LCLN, integer, location of LN array in IX array (PES)
! LCDD, integer, location of DD array in Z array (PES)
! LCPRM, integer, location of PRM array in X array (PES)
! LCISEN, integer, location of ISENS array in IX array (PES)
! LCWTP, integer, location of WTP array in X array (PES)
! LCWTPS, integer, location of WTPS array in X array (PES)
! LCW3, integer, location of W3 array in Z array (PES)
! LCW4, integer, location of W4 array in Z array (PES)
! LCNIPR, integer, location of NIPR array in IX array (PES)
! LCIPNG, integer, location of IPNG array in IX array (PES)
! LCIPLO, integer, location of IPLOT array in IX array (PES)
! LCBPRI, integer, location of BPRI array in X array (PES)
! LCNPAR, integer, location of NPAR array in IX array (PES)
! LCQCLS, integer, location of QCLS array in X array (OBS)
! LCWT, integer, location of WT array in X array (OBS)
! LCWTQ, integer, location of WTQ array in X array (OBS)
! LCWTQS, integer, location of WTQS array in X array (OBS)
!
! IUNIT, integer[1..100] identifies packages that are used.  see CUNIT.
! LAYCBDdll, integer[1..200] dll's copy of confining bed information
! LBOTMdll, integer[1..200] dll's copy of pointers to bottom arrays
! PERLEN(MXPER), real[1..1000] Period lengths
! NSTP(MXPER), integer[1..1000] number of steps per period
! TSMULT(MXPER), real[1..1000] time step multipliers per period
! ISSFLG(MXPER), integer[1..1000] steady state flag per period
! LAYTYPdll, integer[1..200] dll's copy of layer types
! LAYAVGdll, integer[1..200] dll's copy of layer averaging method
! CHANIdll, real[1..200] dll's copy of layer horizontal anisotropy
! LAYVKAdll, integer[1..200] dll's copy of indicator or whether VKA is vertical hydraulic conductivity or vertical anisotropy
! LAYWETdll, integer[1..200] dll's copy of indicator of whether wetting is active in a layer
! OUTNAM, character[1..200], OBS process
!
! ZONNAM(1..500), character(10), names of zone arrays, defined in param.inc
! MLTNAM(1..500), character(10), names of multiplier arrays, defined in param.inc
! PARNAM(1..500), character(10), names of parameters, defined in param.inc
! PARTYP(1..500), character(4), names of parameters, defined in param.inc
! INAME(1..1000), character(10), names of instances, defined in param.inc

! NH, integer, head OBS process, number of head observations
! MOBS, integer, head OBS process,
! MAXM, integer, head OBS process,
! NRCHOP recharge option code
! NEVTOP ET option code
! NETSOP is the evapotranspiration (ET) option code in the ETS package
! NPETS is the number of evapotranspiration-segments parameters in the ETS package
! NETSEG is the number of segments in the ETS package
! NCHDS is the number of boundaries in the CHD package

      SUBROUTINE INITMF2K(NLAY, NROW, NCOL, NPER, ITMUNI, LENUNI,
     1 ISENALL, NZN, NML, MXITER, NPARM, ITMX, MXUP, MXLOW, MXBW,
     2 ITER1, NPCOND, ICG, NPLIST, IUHEAD, MXSEN, IPRINTS, ISENSU,
     * ISENPU, ISENFM, ITMXP, IBEFLG, IYCFLG, IOSTAR, NOPT, NFIT, IAP,
     * IPRC, IPRINT, LPRINT, LASTX, NPNG, IPR, MPR, ISCALS, NH, MOBS,
     * MAXM, NQDR, NQTDR, NQRV, NQTRV, NQGB, NQTGB, NQST,NQTST,NQCH,
     * NQTCH,NQDT,NQTDT, NPTH, NTT2, IOUTT2, KTFLG, KTREV, NZONAR,
     * NMLTAR, NHUF, NRIVER, NBOUND, NRCHOP, NEVTOP, IPRSOR, IPCALC,
     * IPRSIP, IFREQ, IPRD4, NBPOL, IPRPCG, MUTPCG, MXCYC, DUP, DLOW,
     * IOUTAMG, ISS, IWDFLG, IWETIT, IHDWET, ISEN, NBDTIM, NETSOP,
     * NETSEG, NCHDS, IITER, IADAMP, IOUTGMG, ISM, ISC,
C     * LCHOLD, LCIBOU, LCCR, LCCC, LCCV, LCHCOF, LCRHS,LCBUFF,
C     * LCSTRT, LCOBDRN, LCSSDR, LCOBRIV, LCSSRV, LCOBGHB, LCSSGB,
C     * LCOBSTR, LCSSST, LCOBCHD, LCSSCH, LCOBDRT, LCSSDT, LCOBADV,
C     * LCBL, LCBU, LCISEN, LCLN, LCBSCA,
     4 HDRY, STOR1, STOR2, STOR3, DMAX, TOL, SOSC, SOSR, RMAR, RMARM,
     * CSA, FCONV, ADVSTP, FSNK, ACCL, HCLOSE, WSEED, RCLOSE, RELAX,
     * DAMP, BCLOSE, WETFCT,
     * GMGRELAX,
     5 IUNIT,
     * LAYCBDdll,LBOTMdll,PERLEN, NSTP, TSMULT, ISSFLG,
     * LAYTYPdll, LAYAVGdll, CHANIdll, LAYVKAdll, LAYWETdll, LAYCONdll)
      USE MF2K_ARRAYS
      use CurrentParameters

      DLL_EXPORT INITMF2K
c
C     ******************************************************************
C     MAIN CODE FOR U.S. GEOLOGICAL SURVEY MODULAR MODEL -- MODFLOW
C           BY MICHAEL G. MCDONALD AND ARLEN W. HARBAUGH
C     MODFLOW-88 documented in:
C        McDonald, M.G. and Harbaugh, A.W., 1988, A modular three-
C           dimensional finite-difference ground-water flow model:
C           U.S. Geological Survey Techniques of Water Resources
C           Investigations, Book 6, Chapter A1, 586 p.
C     MODFLOW-96 documented in:
C        Harbaugh, A.W. and McDonald, M.G., 1996, User's documentation
C           for the U.S. Geological Survey modular finite-difference
C           ground-water flow model: U.S. Geological Survey Open-File
C           Report 96-485
C     MODFLOW-2000 documented in:
C        Harbaugh, A.W., Banta, E.R., Hill, M.C., and McDonald, M.G.,
C           2000, MODFLOW-2000, the U.S. Geological Survey modular
C           ground-water model--User guide to modularization concepts
C           and the Ground-Water Flow Process: U.S. Geological Survey
C           Open-File Report 00-92
C        Hill, M.C., Banta, E.R., Harbaugh, A.W., and Anderman, E.R.,
C           2000, MODFLOW-2000, the U.S. Geological Survey modular
C           ground-water model--User guide to the Observation,
C           Sensitivity, and Parameter-Estimation Processes and three
C           post-processing programs: U.S. Geological Survey Open-
C           File Report 00-184
C     ******************************************************************
C        SPECIFICATIONS:
C     ------------------------------------------------------------------
C-------ASSIGN VERSION NUMBER AND DATE
      CHARACTER*40 VERSION
      PARAMETER (VERSION='1.11 04/10/2003')
C
C-----DECLARE ARRAY TYPES
c rbw begin change
c      REAL GX, X, RX, XHS
c      DOUBLE PRECISION GZ, VAR, Z
c      INTEGER IG, IX, IR
c rbw end change
C RBW BEGIN CHANGE
C      REAL GX, X, RX, XHS
C      DOUBLE PRECISION GZ, VAR, Z
C      INTEGER IG, IX, IR
C      CHARACTER*10 EQNAM, NIPRNAM
C      CHARACTER*12 NAMES, OBSNAM
C      CHARACTER*32 MNWSITE
C RBW END CHANGE
C RBW BEGIN CHANGE
      INTEGER IINDEX
      DIMENSION LAYCBDdll(200), LBOTMdll(200), LAYTYPdll(200)
      DIMENSION LAYAVGdll(200), CHANIdll(200), LAYVKAdll(200)
      DIMENSION LAYWETdll(200), LAYCONdll(200)
      INTEGER ISM, ISC
      DOUBLEPRECISION GMGRELAX
C RBW END CHANGE
c rbw begin change
c      CHARACTER*10 EQNAM, NIPRNAM
c      CHARACTER*12 NAMES, OBSNAM
c      CHARACTER*32 MNWSITE
c rbw end change
C
C *** FOR STATIC MEMORY ALLOCATION, THE FOLLOWING PARAMETER AND
C *** DIMENSION STATEMENTS MUST BE UNCOMMENTED.  TO CHANGE THE SIZE OF
C *** AN ARRAY, CHANGE THE VALUE OF THE CORRESPONDING (FORTRAN)
C *** PARAMETER AND RECOMPILE
C      PARAMETER (LENGX=1000000, LENIG=1000000, LENGZ=1000000,
C     &           LENX=2000000, LENIX=1500000, LENZ=1000000,
C     &           LENRX=1000000, LENIR=1000000, LENXHS=1000000,
C     &           NDD=10000, MPRD=100, IPRD=100)
C      DIMENSION GX(LENGX), IG(LENIG), X(LENX), IX(LENIX), RX(LENRX),
C     &          IR(LENIR), GZ(LENGZ), Z(LENZ), XHS(LENXHS),
C     &          EQNAM(MPRD), NIPRNAM(IPRD), NAMES(NDD+MPRD+IPRD),
C     &          OBSNAM(NDD)
C
C *** FOR STATIC MEMORY ALLOCATION, THE FOLLOWING ALLOCATABLE
C *** STATEMENT MUST BE COMMENTED OUT
c rbw begin change
c      ALLOCATABLE GX(:), IG(:), X(:), IX(:), RX(:), IR(:), GZ(:), Z(:),
c     &            XHS(:), NIPRNAM(:), EQNAM(:), NAMES(:), OBSNAM(:)
C
c      ALLOCATABLE MNWSITE(:)
c rbw end change
C RBW BEGIN CHANGE
C      ALLOCATABLE GX(:), IG(:), X(:), IX(:), RX(:), IR(:), GZ(:), Z(:),
C     &            XHS(:), NIPRNAM(:), EQNAM(:), NAMES(:), OBSNAM(:)
C
C
      DIMENSION PERLEN(MXPER),NSTP(MXPER),TSMULT(MXPER),ISSFLG(MXPER)
C      ALLOCATABLE MNWSITE(:)
C RBW END CHANGE
C
C      PARAMETER (NIUNIT=100)
C      PARAMETER (MXPER=1000)
C      CHARACTER*16 VBNM(NIUNIT)
      DIMENSION IUNIT(NIUNIT)
C      CHARACTER*80 HEADNG(2)
C      DOUBLE PRECISION AP
C RBW END CHANGE
C
C  UNCOMMENT "INCLUDE mpif.h" DURING TESTING TO DEVELOP MPI CODE IN THIS
C  ROUTINE OR TO ACTIVATE TIMERS AND DEBUG MODE.
C     INCLUDE 'mpif.h'
      INCLUDE 'parallel.inc'
      INCLUDE 'param.inc'
      INCLUDE 'openspec.inc'
C-------SPECIFY SIZE OF ARRAY TO HOLD SENSITIVITIES FROM ONE
C-------PARAMETER-ESTIMATION ITERATION TO THE NEXT WHEN PES, SEN, AND
C-------ANY OBS PACKAGE ARE ACTIVE.  IF IUHEAD IS GREATER THAN ZERO,
C-------LENXHS MAY EQUAL 1.  IF IUHEAD IS LESS THAN OR EQUAL TO ZERO,
C-------LENXHS MUST BE AT LEAST:
C-------NLAY*NCOL*NROW*(NUMBER OF PARAMETERS TO BE ESTIMATED).
C
      COMMON /BCFCOM/LAYCON(200)
      COMMON /DISCOM/LBOTM(200),LAYCBD(200)
      COMMON /LPFCOM/LAYTYP(200),LAYAVG(200),CHANI(200),LAYVKA(200),
     1               LAYWET(200)
      COMMON /HUFCOM/LTHUF(200),HGUHANI(200),HGUVANI(200),LAYWT(200)
C RBW BEGIN CHANGE
      include 'MyInc.inc'
C      INTEGER LAYHDT(200)
C
C      CHARACTER*4 PIDTMP
C      CHARACTER*20 CHEDFM,CDDNFM,CBOUFM
c      CHARACTER*200 FNAME, OUTNAM, COMLIN
C      CHARACTER*200 MNWNAME
C
C      LOGICAL EXISTS, BEFIRST, SHOWPROG, RESETDD, RESETDDNEXT
C      INTEGER NPEVT, NPGHB, NPDRN, NPHFB, NPRIV, NPSTR, NPWEL, NPRCH
C      INTEGER IUBE(2), IBDT(8)
C      INTEGER IOWELL2(3)  ! FOR MNW1 PACKAGE
C      CHARACTER*4 CUNIT(NIUNIT)
C      CHARACTER*10 PARNEG(MXPAR)
C      DATA CUNIT/'BCF6', 'WEL ', 'DRN ', 'RIV ', 'EVT ', '    ', 'GHB ',  !  7
C     &           'RCH ', 'SIP ', 'DE4 ', 'SOR ', 'OC  ', 'PCG ', 'LMG ',  ! 14
C     &           'gwt ', 'FHB ', 'RES ', 'STR ', 'IBS ', 'CHD ', 'HFB6',  ! 21
C     &           'LAK ', 'LPF ', 'DIS ', 'SEN ', 'PES ', 'OBS ', 'HOB ',  ! 28
C     &           'ADV2', 'COB ', 'ZONE', 'MULT', 'DROB', 'RVOB', 'GBOB',  ! 35
C     &           'STOB', 'HUF ', 'CHOB', 'ETS ', 'DRT ', 'DTOB', '    ',  ! 42
C     &           'HYD ', 'sfr ', 'SFOB', 'GAGE', '    ', '    ', 'LMT6',  ! 49
C     &           'MNW1', 'DAF ', 'DAFG', '    ', '    ', '    ', '    ',  ! 56
C     &           44*'    '/
      call InitializeVariables
C RBW END CHANGE
C     ------------------------------------------------------------------
      InstanceCount = 0
      CALL PLL1IN
C RBW BEGIN CHANGE
C      IF (MYID.EQ.MPROC) WRITE (*,1) VERSION
C RBW END CHANGE
    1 FORMAT (/,34X,'MODFLOW-2000',/,
     &4X,'U.S. GEOLOGICAL SURVEY MODULAR FINITE-DIFFERENCE',
     &' GROUND-WATER FLOW MODEL',/,29X,'Version ',A/)
      INUNIT = 99
      IBUNIT = 98
      IBOUTS = 97
      IERRU  = 96
      MAXUNIT= INUNIT
C     DEFINE RANGE OF RESERVED FILE UNITS
      MINRSV = 96
      MAXRSV = 99
      IBATCH = 0
CLAK
      NSOL = 1
      DUM=0.0D0
C
      INQUIRE (FILE='modflow.bf',EXIST=EXISTS)
      IF (EXISTS) THEN
        IBATCH = 1
        IF (MYID.EQ.MPROC) THEN
          OPEN (UNIT=IBUNIT,FILE='modflow.bf',STATUS='OLD')
          OPEN (UNIT=IBOUTS,FILE='modbatch.rpt')
          WRITE (IBOUTS,*) ' USGS MODFLOW MODEL BATCH-MODE REPORT'
        ENDIF
      ENDIF
C2------OPEN FILE OF FILE NAMES.
   10 CONTINUE
      IF (MYID.EQ.MPROC) THEN
        IF (IBATCH.GT.0) THEN
          READ (IBUNIT,'(A)',END=11) FNAME
          GOTO 12
   11     CLOSE(IBUNIT)
          CLOSE(IBOUTS)
          FNAME=' '
          GOTO 15
   12     IF (FNAME.EQ.' ') GOTO 10
          WRITE (IBOUTS,'(1X,/1X,A)') FNAME
        ELSE
          FNAME=' '
          COMLIN=' '
C *** Subroutines GETARG and GETCL are extensions to Fortran 90/95 that
C *** allow a program to retrieve command-line arguments.  To enable
C *** Modflow-2000 to read the name of a Name file from the command
C *** line, either GETARG or GETCL must be called, but not both.  As
C *** distributed, the call to GETARG is uncommented.  For compilers
C *** that support GETCL but not GETARG, comment out the call to GETARG
C *** and uncomment the call to GETCL.  The calls to both GETARG and
C *** GETCL may be commented out for compilers that do not support
C *** either extension.
          CALL GETARG(1,COMLIN)
C          CALL GETCL(COMLIN)
          ICOL = 1
          IF(COMLIN.NE.' ') THEN
            FNAME=COMLIN
          ELSE
c RBW begin change
            Return
c RBW end change
            WRITE (*,*) ' Enter the name of the NAME FILE: '
            READ (*,'(A)') FNAME
            CALL URWORD(FNAME,ICOL,ISTART,ISTOP,0,N,R,0,0)
            FNAME=FNAME(ISTART:ISTOP)
          ENDIF
          IF (FNAME.EQ.' ') GOTO 15
          INQUIRE (FILE=FNAME,EXIST=EXISTS)
          IF(.NOT.EXISTS) THEN
            NC=INDEX(FNAME,' ')
            FNAME(NC:NC+3)='.nam'
            INQUIRE (FILE=FNAME,EXIST=EXISTS)
            IF(.NOT.EXISTS) THEN
c RBW begin change
              Return
c RBW end change
              WRITE (*,480) FNAME(1:NC-1),FNAME(1:NC+3)
              FNAME=' '
            ENDIF
          ENDIF
        ENDIF
        IF (FNAME.EQ.' ') GOTO 15
        INQUIRE (FILE=FNAME,EXIST=EXISTS)
        IF (.NOT.EXISTS) THEN
          IF (IBATCH.GT.0) THEN
            WRITE (IBOUTS,*) ' Specified name file does not exist.'
            WRITE (IBOUTS,*) ' Processing will continue with the next ',
     &                       'name file in modflow.bf.'
          ENDIF
          GOTO 10
        ENDIF
      ENDIF
   15 CONTINUE
  480 FORMAT(1X,'Can''t find name file ',A,' or ',A)
C
C     BROADCAST FNAME AND OPEN FILE FOR WARNINGS AND ERROR MESSAGES
      CALL PLL1FN(FNAME)
      IF (FNAME.EQ.' ') GOTO 120
      CALL PLL1OP(IERRU,IERR)
      OPEN (UNIT=INUNIT,FILE=FNAME,STATUS='OLD',ACTION=ACTION(1))
C      IF (MYID.EQ.MPROC) WRITE(*,490)' Using NAME file: ',FNAME
  490 FORMAT(A,A)
C
C  DEFINE (DF) PROCEDURE
      CALL GLO1BAS6DF(INUNIT,IUNIT,CUNIT,IREWND,NIUNIT,IOUTG,IOUT,
     &                VERSION,NCOL,NROW,NLAY,NPER,ITMUNI,ISUMGX,
     &                MXPER,ISUMIG,ISUMGZ,INBAS,LENUNI,ISUMX,ISUMZ,
     &                ISUMIX,LAYHDT,24,IFREFM,INAMLOC,IPRTIM,IBDT,
     &                SHOWPROG)
      CALL OBS1BAS6DF(IOBS,IOSTAR,IOWTQ,IOWTQDR,IOWTQGB,
     &                IOWTQRV,IOWTQST,IQ1,IUNIT(27),JT,LCCOFF,LCHFB,
     &                LCIPLO,LCIPLP,LCIQOB,LCNDER,LCNQOB,LCOBADV,
     &                LCOBDRN,LCOBGHB,LCOBBAS,LCOBRIV,LCOBSE,LCOBSTR,
     &                LCQCLS,LCROFF,LCSSAD,LCSSCH,LCSSDR,LCSSGB,LCSSGF,
     &                LCSSPI,LCSSRV,LCSSST,LCSSTO,LCWT,LCWTQ,MOBS,NC,ND,
     &                NDMH,NDMHAR,NH,NOBADV,NQ,NQC,NQT,NQT1,NQTDR,
     &                NQTGB,NQTRV,NQTST,NQTCH,NT,NTT2,IOBSUM,LCX,
     &                LCBUF2,NDAR,LCOBDRT,LCSSDT,NQTDT,IOWTQDT,LCSSSF,
     &                NQTSF,LCOBSFR,IOWTQSF,NHT,LCRSQA,LCRSPA,LCBUF1,
     &                LCH,LCHOBS,LCWTQS,LCHANI,LCXND,LCOTIM,OBSALL)
      CALL SEN1BAS6DF(ISENALL,ISEN,IPRINTS,IUNIT(25),LCB1,LCLN,LCSV,NPE,
     &                NPLIST,RCLOSE,IUHEAD,MXSEN,LCSNEW,IOUTG,LCBSCA,
     &                LCISEN)
      CALL PES1BAS6DF(IBEFLG,IFO,IOUB,IPES,IPR,IPRAR,IPRINT,ITERPF,
     &                ITERPK,ITMXP,IUNIT(26),IYCFLG,JMAX,LASTX,LCDMXA,
     &                LCNIPR,LCNPAR,LCPRM,LCWP,LCWTP,LCWTPS,LCW3,LCW4,
     &                MPR,MPRAR,NPNGAR,SOSC,SOSR,BEFIRST,LCBPRI,LCPARE,
     &                LCAMPA,LCAMCA,LCAAP)
      CALL GWF1MNW1DF(LCHANI,LCHK,LCHKCC,LCHUFTHK,LCHY,LCSSHMN,LCTRPY,
     &                NHUFAR)
C
C  GLOBAL ALLOCATE (AL) PROCEDURE
      CALL GLO1BAS6AL(IUNIT(24),NCNFBD,NBOTM,NCOL,NROW,NLAY,LCBOTM,
     &                LCDELR,LCDELC,ISUMGX,IOUTG,LCHNEW,LCIBOU,LCCR,
     &                LCCC,LCCV,LCRHS,LCHCOF,LCHOLD,LCBUFF,LCSTRT,
     &                ISUMGZ,ISUMIG,ISEN,IOBS,IPES,ISENALL,ITMXP,IPAR,
     &                IUNIT(31),IUNIT(32),NMLTAR,NZONAR,NML,NZN,LCRMLT,
     &                LCIZON,IUNIT(15))
C RBW BEGIN CHANGE
      do 2020 IINDEX=1, NLAY
        LAYCBDdll(IINDEX) = LAYCBD(IINDEX)
        LBOTMdll(IINDEX) = LBOTM(IINDEX)
 2020 CONTINUE
C RBW END CHANGE
C
C  DYNAMICALLY ALLOCATE GLOBAL ARRAYS GX, GZ, AND IG.  FOR STATIC
C  MEMORY ALLOCATION, THE FOLLOWING THREE ASSIGNMENT AND ONE ALLOCATE
C  STATEMENTS MUST BE COMMENTED OUT
      LENGX = ISUMGX - 1
      LENGZ = ISUMGZ - 1
      LENIG = ISUMIG - 1
      ALLOCATE (GX(LENGX),GZ(LENGZ),IG(LENIG))
C
      CALL MEMCHKG(ISUMGX,ISUMIG,ISUMGZ,LENGX,LENIG,LENGZ,IOUTG,IERR,
     &             IERRU)
      IF (IERR.GT.0) CALL PLL1SD(IERR,IERRU,IOUT,IOUTG)
C
C  GLOBAL READ AND PREPARE (RP) PROCEDURE
      CALL GLO1BAS6RP(IUNIT(24),NCOL,NROW,NLAY,GX(LCBOTM),NBOTM,IOUTG,
     1                GX(LCDELR),GX(LCDELC),NPER,PERLEN,NSTP,TSMULT,
     2                ISSFLG,ITRSS,IUNIT(31),IUNIT(32),NMLTAR,NZONAR,
     3                GX(LCRMLT),IG(LCIZON),NML,NZN)
C
C-----NO rewind AL and RP for Ground-Water Flow Process
      IF(IUNIT(23).GT.0)
     1    CALL GWF1LPF1ALG(ISUMX,LCHK,LCVKA,LCSC1,LCSC2,LCHANI,LCVKCB,
     2                     IUNIT(23),NCOL,NROW,NLAY,IOUTG,ILPFCB,LCWETD,
     3                     HDRY,NPLPF,NCNFBD,LCLAYF,IREWND(23),ISUMIX,
     4                     LAYHDT,ITRSS,LCSV,ISEN)
      IF(IUNIT(37).GT.0) THEN
        CALL GWF1HUF2ALG(ISUMX,LCHK,LCVKA,LCSC1,IUNIT(37),ITRSS,NCOL,
     &                   NROW,NLAY,IOUTG,IHUFCB,LCWETD,HDRY,NPER,
     &                   ISSFLG,LCHGUF,IREWND(37),
     &                   NHUF,NPHUF,LCHUFTHK,LCHKCC,ISUMIX,IOHUFHDS,
     &                   IOHUFFLWS,LAYHDT,LCHUFTMP)
        CALL GWF1HUF2LVDA1ALG(ISUMX,ISUMIX,IUNIT(47),IOUTG,NCOL,
     &                        NROW,NLAY,LCVDHD,LCDVDH,LCVDHT,NPLVDA,
     &                        LCA9)
        CALL GWF1HUF2KDEP1ALG(ISUMX,IUNIT(53),IOUTG,NCOL,NROW,
     &                        LCGS,NPKDEP,IFKDEP)
      ENDIF
      IF(IUNIT(9).GT.0)
     1    CALL SIP5ALG(ISUMX,ISUMIX,LCEL,LCFL,LCGL,LCV,LCHDCG,LCLRCH,
     2                 LCW,MXITER,NPARM,NCOL,NROW,NLAY,IUNIT(9),IOUTG,
     3                 IFREFM,IREWND(9))
      IF(IUNIT(10).GT.0)
     1    CALL DE45ALG(ISUMX,ISUMIX,LCAU,LCAL,LCIUPP,LCIEQP,LCD4B,
     2                 LCLRCH,LCHDCG,MXUP,MXLOW,MXEQ,MXBW,IUNIT(10),
     3                 ITMX,ID4DIR,NCOL,NROW,NLAY,IOUTG,ID4DIM,
     4                 IREWND(10))
      IF(IUNIT(11).GT.0)
     1    CALL SOR5ALG(ISUMX,ISUMIX,LCA,LCRES,LCHDCG,LCLRCH,LCIEQP,
     2                 MXITER,NCOL,NLAY,NSLICE,MBW,IUNIT(11),IOUTG,
     3                 IFREFM,IREWND(11))
      IF(IUNIT(13).GT.0)
     1    CALL PCG2ALG(ISUMX,ISUMIX,LCV,LCSS,LCP,LCCD,LCHCHG,LCLHCH,
     2                 LCRCHG,LCLRCH,MXITER,ITER1,NCOL,NROW,NLAY,
     3                IUNIT(13),IOUTG,NPCOND,LCIT1,LCHCSV,IFREFM,
     4                IREWND(13),ISUMZ,LCHPCG)
      IF(IUNIT(14).GT.0)
     1    CALL LMG1ALG(ISUMZ,ISUMIX,LCA,LCIA,LCJA,LCU1,LCFRHS,
     2                 LCIG,ISIZ1,ISIZ2,ISIZ3,ISIZ4,ICG,NCOL,NROW,NLAY,
     3                 IUNIT(14),IOUTG,1, STOR1, STOR2, STOR3)
      IF(IUNIT(42).GT.0)
     1    CALL GMG1ALG(NCOL,NROW,NLAY,MXITER,IITER,RCLOSE,HCLOSE,DAMP,
     2                 IADAMP,IOUTGMG,IUNIT(42),IOUTG,
     3                 ISM, ISC, GMGRELAX)
C
C-----ALLOCATE SPACE FOR SENSITIVITY CALCULATIONS
      IF (ISEN.GT.0)
     &    CALL SEN1BAS6AL(ISUMX,ISUMIX,NCOL,NROW,NLAY,IOUTG,IUHEAD,
     &                    NPLIST,IUNIT(25),IPAR,LCHCLO,LCRCLO,LCLN,
     &                    IPRINTS,LCISEN,LCBU,LCBL,LCB1,ISENALL,
     &                    IREWND(25),LCSNEW,LCSOLD,ISUMZ,ISEN,ISENSU,
     &                    ISENPU,ISENFM,IPES,MXSEN,LCBSCA,ITMXP,MAXUNIT,
     &                    MINRSV,MAXRSV,NSTP,NPER,NTIMES,LCSEND,LCSNDT)
C-----ALLOCATE SPACE FOR PARAMETER-ESTIMATION PROCESS
      IF (IPES.GT.0)
     &    CALL PES1BAS6AL(ISUMX,ISUMZ,ISUMIX,IOUTG,NPLIST,LCC,LCSCLE,
     &                    LCG,LCDD,LCWP,MPR,LCPRM,LCR,LCU,LCGD,
     &                    LCS,NOPT,IPR,LCWTP,LCWTPS,LCW3,LCW4,LCNIPR,
     &                    LCEIGL,LCEIGV,LCEIGW,LCIPNG,IUNIT(26),
     &                    NPNG,MPRAR,IPRAR,NPNGAR,IREWND(26),
     &                    LCPRNT,LCPARE,ITMXP,LCSSPI,LCSSTO,DMAX,TOL,
     &                    SOSC,IOSTAR,NFIT,SOSR,IPRC,IPRINT,LPRINT,CSA,
     &                    FCONV,LASTX,ISEN,IPES,IPAR,IBEFLG,IYCFLG,
     &                    LCDMXA,LCNPAR,LCBPRI,RMARM,IAP,LCAAP,
     &                    LCAMCA,LCAMPA,RMAR)
C-----READ INPUT RELATED TO ALL OBSERVATIONS AND OPEN
C     PARAMETER-VALUE FILE ON IOUB
      IF (IOBS.GT.0)
     &    CALL OBS1BAS6AL(IOUB,IOUTG,ISCALS,ISEN,IUNIT(27),OUTNAM,
     &                    ISOLDX,ISOLDZ,ISOLDI,ISUMX,ISUMZ,ISUMIX,
     &                    OBSALL)
C-----ALLOCATE SPACE FOR HEAD OBSERVATIONS
      IF (IUNIT(28).GT.0)
     &    CALL OBS1BAS6HAL(IUNIT(28),NH,MOBS,MAXM,ISUMX,ISUMIX,LCNDER,
     &                     LCCOFF,LCROFF,LCIOFF,LCJOFF,LCRINT,LCMLAY,
     &                     LCPR,ND,IOUTG,IOBSUM,LCOBBAS,ITMXP,LCSSGF,
     &                     IOBS,NHT)
C-----ALLOCATE SPACE FOR FLOW OBSERVATIONS
      IF (IUNIT(33).GT.0)
     &    CALL OBS1DRN6AL(IUNIT(33),NQ,NQC,NQT,IOUTG,NQDR,NQTDR,IOBSUM,
     &                    LCOBDRN,ITMXP,LCSSDR,ISUMX,IOBS)
      IF (IUNIT(34).GT.0)
     &    CALL OBS1RIV6AL(IUNIT(34),NQ,NQC,NQT,IOUTG,NQRV,NQTRV,IOBSUM,
     &                    LCOBRIV,ITMXP,LCSSRV,ISUMX,IOBS)
      IF (IUNIT(35).GT.0)
     &    CALL OBS1GHB6AL(IUNIT(35),NQ,NQC,NQT,IOUTG,NQGB,NQTGB,IOBSUM,
     &                    LCOBGHB,ITMXP,LCSSGB,ISUMX,IOBS)
      IF (IUNIT(36).GT.0)
     &    CALL OBS1STR6AL(IUNIT(36),NQ,NQC,NQT,IOUTG,NQST,NQTST,IOBSUM,
     &                    LCOBSTR,ITMXP,LCSSST,ISUMX,IOBS)
      IF (IUNIT(38).GT.0)
     &    CALL OBS1BAS6FAL(IUNIT(38),NQ,NQC,NQT,IOUTG,NQCH,NQTCH,IOBSUM,
     &                     LCOBCHD,ITMXP,LCSSCH,ISUMX,IOBS)
      IF (IUNIT(41).GT.0)
     &    CALL OBS1DRT1AL(IUNIT(41),NQ,NQC,NQT,IOUTG,NQDT,NQTDT,IOBSUM,
     &                    LCOBDRT,ITMXP,LCSSDT,ISUMX,IOBS)
C-----ALLOCATE SPACE FOR ADVECTIVE TRAVEL OBSERVATIONS (ADV PACKAGE)
      IF (IUNIT(29).GT.0)
     &    CALL OBS1ADV2AL(IUNIT(29),NPTH,NTT2,IOUTT2,KTDIM,KTFLG,KTREV,
     &                    ADVSTP,IOUTG,LCICLS,LCPRST,NPRST,LCTT2,LCPOFF,
     &                    LCNPNT,ND,ISUMX,ISUMIX,NROW,NCOL,NLAY,
     &                    IOBSUM,LCOBADV,NOBADV,ITMXP,LCSSAD,IOBS,
     &                    FSNK,NBOTM,IUNIT,NIUNIT,LCDRAI,MXDRN,
     &                    NDRAIN,LCRIVR,MXRIVR,LCBNDS,MXBND,NBOUND,
     &                    LCIRCH,LCRECH,ICSTRM_,LCSTRM_,MXSTRM,NSTREM,
     &                    NDRNVL,NGHBVL,NRIVVL,NRIVER,LCHANI,LCHKCC,
     &                    LCHUFTHK,NHUF,LCGS,LCVDHT,LCDVDH,
     &                    LCWELL,NWELVL,MXWELL,NWELLS,ISEN,IADVHUF)
C-----ALLOCATE SPACE FOR ALL OBSERVATIONS AND FOR RESIDUALS RELATED TO
C     OBSERVATIONS AND PRIOR INFORMATION. ALSO INITIALIZE SOME ARRAYS
      IF (IOBS.GT.0)
     &    CALL OBS1BAS6AC(EV,ISUMX,ISUMZ,ISUMIX,LCTOFF,NH,LCH,ND,
     &                    LCHOBS,LCWT,NDMH,NDMHAR,LCWTQ,LCWTQS,LCW1,
     &                    LCW2,LCX,NPLIST,LCXD,IPAR,IOUTG,IDRY,
     &                    JDRY,NQ,NQAR,NQC,NQCAR,NQT,NQTAR,NHAR,MOBS,
     &                    MOBSAR,LCIBT,LCNQOB,LCNQCL,LCIQOB,LCQCLS,
     &                    LCIPLO,LCIPLP,IPR,MPR,IPRAR,LCBUF1,LCSSTO,
     &                    ITMXP,LBUFF,LCOBSE,ISOLDX,ISOLDZ,ISOLDI,MXSEN,
     &                    LCBUF2,NDAR,NHT,LCRSQA,LCRSPA,LCXND,LCOTIM)
C
C------DYNAMICALLY ALLOCATE X, Z, IX, XHS, NIPRNAM, EQNAM, NAMES, AND
C      OBSNAM ARRAYS FOR OBS, SEN, AND PES PROCESSES; SOLVERS; AND
C      PACKAGES THAT DO ALLOCATION ONCE ONLY.  FOR STATIC MEMORY
C      ALLOCATION, THE FOLLOWING LINES, THROUGH THE ALLOCATE STATEMENTS,
C      MUST BE COMMENTED OUT
      LENX = ISUMX - 1
      IF(LENX.LT.1) LENX=1
      LENZ = ISUMZ - 1
      IF(LENZ.LT.1) LENZ=1
      LENIX = ISUMIX - 1
      IF(LENIX.LT.1) LENIX=1
      IF (ISEN.NE.0 .AND. IUHEAD.LE.0 .AND. MXSEN.GT.0) THEN
        LENXHS = NCOL*NROW*NLAY*MXSEN
      ELSE
        LENXHS = 1
      ENDIF
      NDD = NDAR
      MPRD = MPRAR
      IPRD = IPRAR
      ALLOCATE (X(LENX),Z(LENZ),IX(LENIX),XHS(LENXHS))
      ALLOCATE (NIPRNAM(IPRAR),EQNAM(MPRAR),NAMES(ND+IPRAR+MPRAR),
     &          OBSNAM(NDAR))
C
C------IF THE ARRAYS ARE NOT BIG ENOUGH THEN STOP.
      CALL MEMCHK(ISUMX,ISUMIX,ISUMZ,LENX,LENIX,LENZ,IOUTG,ISEN,IUHEAD,
     &            LENXHS,NCOL,NROW,NLAY,MXSEN,IERR,IERRU,NDD,NDAR,MPRD,
     &            MPRAR,IPRD,IPRAR)
      IF (IERR.GT.0) CALL PLL1SD(IERR,IERRU,IOUT,IOUTG)
C
      IF (ISEN.GT.0 .OR. ISENALL.LT.0 .OR. IBEFLG.EQ.2)
     &    CALL SEN1BAS6RP(X(LCBL),X(LCBU),FAC,IX(LCISEN),IOUTG,
     &                    IUNIT(25),IX(LCLN),NPE,NPLIST,DETWTP,ISENALL,
     &                    X(LCBSCA),MXSEN)
      IF (IPES.GT.0 .OR. IBEFLG.EQ.2)
     &    CALL PES1BAS6RP(IUNIT(26),IOUTG,NPE,X(LCWP),IX(LCLN),DMAX,
     &                    Z(LCDD),FCONV,EV,MPR,X(LCPRM),IX(LCISEN),
     &                    NPLIST,X(LCWTP),X(LCWTPS),Z(LCW3),Z(LCW4),IPR,
     &                    IX(LCNIPR),DETWTP,ND,ADMX,AP,DMX,NIPRNAM,
     &                    EQNAM,MPRAR,IPRAR,IX(LCIPNG),NPNG,NPNGAR,
     &                    IX(LCIPLO),NAMES,PARNEG,MXPAR,LBUFF,FSTAT,
     &                    X(LCBPRI),IERR,IYCFLG,IX(LCNPAR),ITMXP,IBEFLG)
C
C-----INITIALIZE ARRAYS USED FOR OBSERVATION PROCESS
      IF (IOBS.GT.0) CALL OBS1BAS6RP(ND,NDAR,NDMH,NDMHAR,NQCAR,
     &                               X(LCQCLS),RSQO,RSQOO,RSQP,X(LCWT),
     &                               X(LCWTQ),X(LCWTQS),X(LCOTIM))
C
C-----READ AND PREPARE INFORMATION FOR OBSERVATIONS
C
C-----READ HEAD OBSERVATION DATA
      IF (IUNIT(28).GT.0)
     &    CALL OBS1BAS6HRP(NCOL,NROW,NLAY,NPER,IUNIT(28),IOUTG,OBSNAM,
     &                    NH,IX(LCNDER),JT,IX(LCJOFF),IX(LCIOFF),
     &                    X(LCHOBS),X(LCWT),GX(LCDELR),GX(LCDELC),
     &                    X(LCRINT),X(LCCOFF),X(LCROFF),IX(LCMLAY),
     &                    X(LCPR),MOBS,IERR,X(LCTOFF),EV,EVH,MAXM,NSTP,
     &                    PERLEN,TSMULT,ISSFLG,ITRSS,NHAR,MOBSAR,
     &                    IX(LCIPLO),NAMES,ND,IPR,MPR,X(LCOTIM))
C-----READ HEAD-DEPENDENT-BOUNDARY FLOW-OBSERVATION DATA
      IF (IUNIT(33).GT.0)
     &    CALL OBS1DRN6RP(NCOL,NROW,NPER,IUNIT(33),IOUTG,OBSNAM,NHT,JT,
     &                    IX(LCIBT),IX(LCNQOB),IX(LCNQCL),
     &                    IX(LCIQOB),X(LCQCLS),IERR,X(LCHOBS),X(LCTOFF),
     &                    X(LCWTQ),IOWTQ,IPRN,NDMH,NSTP,PERLEN,
     &                    TSMULT,ISSFLG,ITRSS,NQAR,NQCAR,
     &                    NQTAR,IQ1,NQT1,NDD,IUNIT(3),NQDR,NQTDR,NT,
     &                    NC,IX(LCIPLO),NAMES,ND,IPR,MPR,IOWTQDR,
     &                    X(LCOTIM))
      IF (IUNIT(34).GT.0)
     &    CALL OBS1RIV6RP(NCOL,NROW,NPER,IUNIT(34),IOUTG,OBSNAM,
     &                    NH,JT,IX(LCIBT),IX(LCNQOB),
     &                    IX(LCNQCL),IX(LCIQOB),X(LCQCLS),IERR,
     &                    X(LCHOBS),X(LCTOFF),X(LCWTQ),IOWTQ,IPRN,
     &                    NDMH,NSTP,PERLEN,TSMULT,
     &                    ISSFLG,ITRSS,NQAR,NQCAR,NQTAR,IQ1,NQT1,
     &                    NDD,IUNIT(4),NQRV,NQTRV,NT,NC,IX(LCIPLO),
     &                    NAMES,ND,IPR,MPR,IOWTQRV,X(LCOTIM))
      IF (IUNIT(35).GT.0)
     &    CALL OBS1GHB6RP(NCOL,NROW,NPER,IUNIT(35),IOUTG,OBSNAM,
     &                    NHT,JT,IX(LCIBT),IX(LCNQOB),
     &                    IX(LCNQCL),IX(LCIQOB),X(LCQCLS),IERR,
     &                    X(LCHOBS),X(LCTOFF),X(LCWTQ),IOWTQ,IPRN,
     &                    NDMH,NSTP,PERLEN,TSMULT,
     &                    ISSFLG,ITRSS,NQAR,NQCAR,NQTAR,IQ1,NQT1,
     &                    NDD,IUNIT(7),NQGB,NQTGB,NT,NC,IX(LCIPLO),
     &                    NAMES,ND,IPR,MPR,IOWTQGB,X(LCOTIM))
      IF (IUNIT(36).GT.0)
     &    CALL OBS1STR6RP(NPER,IUNIT(36),IOUTG,OBSNAM,NHT,JT,
     &                    IX(LCIBT),IX(LCNQOB),IX(LCNQCL),IX(LCIQOB),
     &                    X(LCQCLS),IERR,X(LCHOBS),X(LCTOFF),X(LCWTQ),
     &                    IOWTQ,IPRN,NDMH,NSTP,PERLEN,TSMULT,ISSFLG,
     &                    ITRSS,NQAR,NQCAR,NQTAR,IQ1,NQT1,IUNIT(18),
     &                    NQST,NQTST,NT,NC,IX(LCIPLO),NAMES,ND,IPR,
     &                    MPR,IOWTQST,X(LCOTIM))
      IF (IUNIT(38).GT.0)
     &    CALL OBS1BAS6FRP(NCOL,NROW,NPER,IUNIT(38),IOUTG,OBSNAM,
     &                     NHT,JT,IX(LCIBT),IX(LCNQOB),
     &                     IX(LCNQCL),IX(LCIQOB),X(LCQCLS),IERR,
     &                     X(LCHOBS),X(LCTOFF),X(LCWTQ),IOWTQ,IPRN,
     &                     NDMH,NSTP,PERLEN,TSMULT,ISSFLG,ITRSS,NQAR,
     &                     NQCAR,NQTAR,IQ1,NQT1,NDD,NQCH,NQTCH,NT,NC,
     &                     IX(LCIPLO),NAMES,ND,IPR,MPR,IOWTQCH,NLAY,
     &                     X(LCOTIM))
      IF (IUNIT(41).GT.0)
     &    CALL OBS1DRT1RP(NCOL,NROW,NPER,IUNIT(41),IOUTG,OBSNAM,NHT,JT,
     &                    IX(LCIBT),IX(LCNQOB),IX(LCNQCL),
     &                    IX(LCIQOB),X(LCQCLS),IERR,X(LCHOBS),X(LCTOFF),
     &                    X(LCWTQ),IOWTQ,IPRN,NDMH,NSTP,PERLEN,
     &                    TSMULT,ISSFLG,ITRSS,NQAR,NQCAR,
     &                    NQTAR,IQ1,NQT1,NDD,IUNIT(40),NQDT,NQTDT,NT,
     &                    NC,IX(LCIPLO),NAMES,ND,IPR,MPR,IOWTQDT,
     &                    X(LCOTIM))
C
C-----READ ADVECTIVE-TRANSPORT DATA
      IF (IUNIT(29).GT.0)
     &    CALL OBS1ADV2RP(IOUTG,NROW,NCOL,NLAY,
     &                    X(LCPRST),NPRST,NPTH,IX(LCNPNT),NTT2,NH,NQT,
     &                    OBSNAM,IX(LCICLS),X(LCPOFF),X(LCTT2),
     &                    X(LCHOBS),GX(LCDELR),GX(LCDELC),X(LCWTQ),ND,
     &                    KTDIM,IUNIT(29),NDMH,IOWTQ,GX(LCBOTM),
     &                    NBOTM,IX(LCIPLO),NAMES,IPR,MPR,JT,NPADV,
     &                    INAMLOC,IPFLG,IADVHUF,NHUF,X(LCOTIM),
     &                    PERLEN,NPER,NSTP,ISSFLG,IADVPER)
C-----CHECK OBSERVATION DATA AGAINST ALLOCATED STORAGE
      IF (IOBS.GT.0) CALL OBS1BAS6CK(NC,ND,NQC,NT,NQT,IOUTG,OBSNAM)
C-----CHECK FOR ERRORS, CALCULATE THE WEIGHT MATRIX AND ITS SQUARE-ROOT
      IF (IPAR.GE.-1)
     &    CALL OBS1BAS6QM(NDMH,X(LCWTQ),X(LCWTQS),DTLWTQ,Z(LCW1),
     &                    Z(LCW2),EV,IOWTQ,IPRN,IOUTG,NDMHAR,OBSALL,
     &                    OUTNAM,ND,NH,X(LCWT))
C
C---------SOLVER PACKAGE
      IF(IUNIT(9).GT.0)
     1    CALL SIP5RPG(NPARM,MXITER,ACCL,HCLOSE,X(LCW),IUNIT(9),IPCALC,
     2                 IPRSIP,IOUTG,IFREFM,WSEED)
      IF(IUNIT(10).GT.0)
     1    CALL DE45RPG(IUNIT(10),MXITER,NITER,ITMX,ACCL,HCLOSE,IFREQ,
     2                IPRD4,IOUTG,MUTD4)
      IF(IUNIT(11).GT.0)
     1    CALL SOR5RPG(MXITER,ACCL,HCLOSE,IUNIT(11),IPRSOR,IOUTG,IFREFM)
      IF(IUNIT(13).GT.0)
     1    CALL PCG2RPG(MXITER,ITER1,HCLOSE,RCLOSE,NPCOND,NBPOL,RELAX,
     2                IPRPCG,IUNIT(13),IOUTG,MUTPCG,NITER,DAMP,IFREFM)
      IF(IUNIT(14).GT.0)
     1    CALL LMG1RPG(IUNIT(14),MXITER,MXCYC,BCLOSE,DAMP,IOUTAMG,IOUTG,
     2                1,ICG,IADAMP,DUP,DLOW,HCLOSE)
C-----CHECK DATA AND CALCULATE CONVERGENCE CRITERIA FOR SENSITIVITIES
      IF (ISEN.GT.0)
     &    CALL SEN1BAS6CM(JT,IOUTG,IX(LCLN),X(LCB1),IERR,NPER,X(LCHCLO),
     &                    X(LCRCLO),HCLOSE,RCLOSE,IPAR,NPE,NPLIST,
     &                    IX(LCISEN),NSTP,PERLEN,TSMULT,IUNIT(10))
C
C RBW BEGIN CHANGE
c      goto 110
C RBW END CHANGE
C-----READ AND PREPARE FOR PACKAGES WITH NO REWIND
      IF(IUNIT(23).GT.0)
     1    CALL GWF1LPF1RPGD(X(LCHK),X(LCVKA),X(LCVKCB),X(LCHANI),
     2                      X(LCSC1),X(LCSC2),IUNIT(23),ITRSS,NCOL,NROW,
     3                      NLAY,IOUTG,X(LCWETD),NPLPF,WETFCT,IWETIT,
     4                      IHDWET,IX(LCLAYF),GX(LCBOTM),NBOTM,
     5                      GX(LCDELR),GX(LCDELC),1,INAMLOC,
     6                      IX(LCISEN),ISEN,NPLIST)
      IF(IUNIT(37).GT.0)
     &    CALL GWF1HUF2RPGD(IUNIT(37),NCOL,NROW,NLAY,IOUTG,X(LCWETD),
     &                    WETFCT,IWETIT,IHDWET,IX(LCHGUF),
     &                    1,NHUF,NPHUF,X(LCHUFTHK),
     &                    ITRSS)
      IF(IUNIT(47).GT.0)
     &    CALL GWF1HUF2LVDA1RPGD(IUNIT(47),IOUTG,1,NHUF,NPLVDA,NLAY,
     &                           ISEN)
      IF(IUNIT(53).GT.0)
     &    CALL GWF1HUF2KDEP1RPGD(IUNIT(53),IOUTG,1,NPKDEP,IFKDEP,NROW,
     &                           NCOL,X(LCGS),GX(LCBOTM),NHUF)
C
C-------BEGIN ITERATION LOOP FOR PARAMETER ESTIMATION
c      DO 105, KITP = 1,ITMXP
      DO 105, KITP = 1,1
        ITERP = KITP
C
C-------SET SENSITIVITY ARRAYS TO ZERO AND STORE ON DISK OR IN MEMORY
        IF (ISEN.GT.0) CALL SEN1BAS6ZS(IUHEAD,LENXHS,NCOL,NPE,NROW,NLAY,
     &                                 Z(LCSNEW),X(LCSOLD),XHS,
     &                                 X(LCSEND),NTIMES)
C-------LOOP TO HERE WHEN CONVERGENCE HAS BEEN ACHIEVED BY TOL CRITERION
 20     CONTINUE
        ITERPK = ITERPK + 1
        ICNVGP = 1
        IF (IPAR.GT.-3) THEN
C-------IF PARAMETER ESTIMATION HAS CONVERGED, SET ITERPF TO
C       CALCULATE HEAD WITH THE NEW PARAMETERS AND THEN STOP
          IF (IFO.GT.0) THEN
            ITERPF = ITERP
          ENDIF
C---------REWIND INPUT FILES
          IF (ITERPK.GT.1)
     1        CALL PES1BAS6RW(INUNIT,FNAME,CUNIT,IREWND,NIUNIT,IOUT,
     2                        IOUTG,VERSION,IX(LCISEN),ITERP,ITERPF,
     3                        LASTX,NPLIST,ITERPK)
        ENDIF
C
C-------INITIALIZE H AND X ARRAYS, AND UNFLAG OMITTED OBSERVATIONS
        IF (IOBS.GT.0) CALL OBS1BAS6FM(X(LCH),ND,NDAR,NDMH,NDMHAR,
     &                                 X(LCWT),X(LCWTQ))
        IF (ISEN.GT.0 .AND. (ITERPF.EQ.0 .OR. LASTX.GT.0))
     &      CALL OBS1BAS6DR(ND,NPE,X(LCX))
C4------ALLOCATE SPACE IN RX AND IR ARRAYS.
        CALL GWF1BAS6ALP(HEADNG,NPER,TOTIM,NCOL,NROW,NLAY,NODES,INBAS,
     1                   IOUT,IXSEC,ICHFLG,IFREFM,ISUMRX,ISUMIR,LCIOFL,
     2                   ISTRT,IAPART)
        IF(IUNIT(1).GT.0)
     1      CALL GWF1BCF6ALP(ISUMRX,LCSC1,LCHY,LCSC2,LCTRPY,ITRSS,ISS,
     2                       IUNIT(1),NCOL,NROW,NLAY,IOUT,IBCFCB,LCWETD,
     3                       IWDFLG,LCCVWD,WETFCT,IWETIT,IHDWET,HDRY,
     4                       IAPART,IFREFM,LAYHDT)
        IF(IUNIT(2).GT.0)
     1      CALL GWF1WEL6ALP(ISUMRX,LCWELL,MXWELL,NWELLS,IUNIT(2),IOUT,
     2                       IWELCB,NWELVL,IWELAL,IFREFM,NPWEL,IPWBEG,
     3                       NNPWEL,NOPRWL)
        IF(IUNIT(3).GT.0)
     1      CALL GWF1DRN6ALP(ISUMRX,LCDRAI,MXDRN,NDRAIN,IUNIT(3),IOUT,
     2                       IDRNCB,NDRNVL,IDRNAL,IFREFM,NPDRN,IDRNPB,
     3                       NNPDRN,NOPRDR)
        IF(IUNIT(4).GT.0)
     1      CALL GWF1RIV6ALP(ISUMRX,LCRIVR,MXRIVR,NRIVER,IUNIT(4),IOUT,
     2                       IRIVCB,NRIVVL,IRIVAL,IFREFM,NPRIV,IRIVPB,
     3                       NNPRIV,NOPRRV)
        IF(IUNIT(5).GT.0)
     1      CALL GWF1EVT6ALP(ISUMRX,ISUMIR,LCIEVT,LCEVTR,LCEXDP,LCSURF,
     2                       NCOL,NROW,NEVTOP,IUNIT(5),IOUT,IEVTCB,
     3                       IFREFM,NPEVT,IEVTPF)
        IF(IUNIT(7).GT.0)
     1      CALL GWF1GHB6ALP(ISUMRX,LCBNDS,MXBND,NBOUND,IUNIT(7),IOUT,
     2                       IGHBCB,NGHBVL,IGHBAL,IFREFM,NPGHB,IGHBPB,
     3                       NNPGHB,NOPRGB)
        IF(IUNIT(8).GT.0)
     1      CALL GWF1RCH6ALP(ISUMRX,ISUMIR,LCIRCH,LCRECH,NRCHOP,NCOL,
     2                       NROW,IUNIT(8),IOUT,IRCHCB,IFREFM,NPRCH,
     3                       IRCHPF)
        IF(IUNIT(16).GT.0)
     1      CALL GWF1FHB1ALP(ISUMRX,ISUMIR,LCFLLC,LCBDTM,LCFLRT,LCBDFV,
     2                  LCBDHV,LCHDLC,LCSBHD,NBDTIM,NFLW,NHED,IUNIT(16),
     3                  IOUT,IFHBCB,NFHBX1,NFHBX2,IFHBD3,IFHBD4,IFHBD5,
     4                  IFHBSS,ITRSS,NHEDDIM,NFLWDIM,NBDHVDIM)
        IF(IUNIT(18).GT.0)
     1      CALL GWF1STR6ALP(ISUMRX,ISUMIR,LCSTRM_,ICSTRM_,MXSTRM,
     2                  NSTREM,IUNIT(18),IOUT,ISTCB1STR6,ISTCB2STR6,
     3                  NSSSTR6,NTRIB,NDIV,ICALC,CONSTSTR6,LCTBAR,
     4                  LCTRIB,LCIVAR_,LCFGAR,NPSTR,ISTRPB)
        IF(IUNIT(19).GT.0)
     1      CALL GWF1IBS6ALP(ISUMRX,LCHC,LCSCE,LCSCV,LCSUB,NCOL,
     2                  NROW,NLAY,IIBSCB,IIBSOC,IUNIT(19),IOUT,IBSDIM,
     &                  IUNIT(54))
        IF(IUNIT(54).GT.0)
     1      CALL GWF1SUB1ALP(NROW,NCOL,NLAY,ITERP,ISUBCB,ISUBOC,AC1,AC2,
     2                  ITMIN,NNDB,NDB,NPZ,NN,NND1,ND1,ND2,IDSAVE,
     3                  IDREST,ISSFLG,NPER,NSTP,NSTPT,IUNIT(54),IOUT,
     4                  IUNIT(9),LCV,ISEN)
        IF(IUNIT(20).GT.0)
     1      CALL GWF1CHD6ALP(ISUMRX,LCCHDS,NCHDS,MXCHD,IUNIT(20),IOUT,
     2                       NCHDVL,IFREFM,NPCHD,IPCBEG,NNPCHD,NOPRCH)
        IF (IUNIT(17).GT.0)
     &      CALL GWF1RES1ALP(ISUMRX,LCIRES,LCIRSL,LCBRES,LCCRES,LCBBRE,
     &                  LCHRES,LCHRSE,IUNIT(17),IOUT,NRES,IRESCB,NRESOP,
     &                  IRESPT,NPTS,NCOL,NROW,ISUMIR)
        IF (IUNIT(21).GT.0)
     &      CALL GWF1HFB6ALP(IUNIT(21),IOUT,ISUMRX,LCHFB,MXACTFB,NHFBNP,
     &                       NPHFB,MXHFB,IHFB,NOPRHB)
CLAK
        IF(IUNIT(22).GT.0)
     1               CALL GWF1LAK3ALP(ISUMRX,ISUMIR,LCCOND,ICLAKE,
     2     MXLKND,LKNODE,LCSTAG,IUNIT(22),IOUT,ILKCB,NLAKES,INTRB,
     3     INDV,LCCNDF,LCLKPR,LCLKEV,ISTGLD,ISTGNW,IICS,IISUB,ISILL,
     4     LCWTDR,IFREFM,NROW,NCOL,NLAY,IBNLK,ILKBL,LKACC1,LKACC2,
     5     LKACC3,LKACC4,LKACC5,LKACC6,LKACC7,LKACC8,LKACC9,LKACC10,
     6     LKACC11,LKDRY,IBTMS,LKNCNT,LKKSUB,LKSADJ,LKFLXI,LKNCNS,LKSVT,
     7     LKJCLS,THETA,LCRNF,ITRSS,NSSITR,SSCNCR,LKSSMN,LKSSMX,LKNCN,
     8     LKDSR,LKCNN,LKCHN,IAREN,IUNIT(44),LSOVOL,NSS,IUNIT(15),
     9     LSLAKE,LSPPT,LSRNF,LSAUG,NSOL,IMSUB,IMSUB1,LSCGWL,LSSLAK,
     *     LSSWIN,LSSWOT,LSSPPT,LSCDRW,LSSRUN,
     *     LSGWIN,LSGWOT,LSLKSM,LSKLK,LSDONE,LSFLOB,LSRTCO,LSCLKO,
     *     LSALKI,LSALKO,ISTRIN,ISTROT,LKLMRR,IDSTRT,
     *     LKVI,ISTGLD2,LKCLKI,
     *     LKCUM1,LKCUM2,LKCUM3,LKCUM4,LKCUM5,
     *     LKCUM6,LKCUM7,LKCUM8,LKCUM9)
CLAK
        CALL GWF1GAG5ALP(IUNIT(46),ISUMIR,LSGAGE,NUMGAGE,IOUT,IUNIT(44),
     &                   IUNIT(22),LKACC7,LCSTAG,LSLAKE,ICSTRM,
     &                   NSTRM,NLAKES)
        IF(IUNIT(39).GT.0)
     &      CALL GWF1ETS1ALP(ISUMRX,ISUMIR,LCIETS,LCETSR,LCETSX,LCETSS,
     &                       NCOL,NROW,NETSOP,IUNIT(39),IOUT,IETSCB,
     &                       IFREFM,NPETS,IETSPF,NETSEG,LCPXDP,LCPETM,
     &                       NSEGAR)
        IF(IUNIT(40).GT.0)
     &      CALL GWF1DRT1ALP(ISUMRX,LCDRTF,MXDRT,NDRTCL,IUNIT(40),IOUT,
     &                       IDRTCB,NDRTVL,IDRTAL,IFREFM,NPDRT,IDRTPB,
     &                       NDRTNP,IDRTFL,NOPRDT)
        IF (IUNIT(43).GT.0)
     &      CALL GWF1HYD1ALP(ISUMRX,LCHYDM,NHYDM,IHYDMUN,HYDNOH,
     &                      IUNIT(43),IOUT)
        IF(IUNIT(51).GT.0)
     1      CALL GWF1DAF1ALP(IERR,IUNIT(52)+1,IUNIT(52),IUNIT(51),IOUT,
     2                      IDAFCB,IDAFBK)
        IF(IUNIT(50).GT.0) THEN
          CALL GWF1MNW1AL(ISUMRX,LCWEL2,MXWEL2,NWELL2,LCHREF,NODES,
     &                     KSPREF,IUNIT(50),IOUT,IWL2CB,IOWELL2,
     &                     NOMOITER,PLOSSMNW,MNWNAME,FNAME)
C
C         Allocate array for MNW1 site IDs
          IF (ITERPK.EQ.1) ALLOCATE (MNWSITE(MXWEL2))
        ENDIF
C RBW BEGIN CHANGE
c      goto 110
C RBW END CHANGE
C
C------DYNAMICALLY ALLOCATE RX AND IR ARRAYS FOR PACKAGES THAT DO
C      ALLOCATION EVERY PARAMETER-ESTIMATION ITERATION.  FOR STATIC
C      MEMORY ALLOCATION, THE FOLLOWING IF...THEN BLOCK MUST BE
C      COMMENTED OUT
       IF (ITERPK.EQ.1) THEN
         LENRX = ISUMRX - 1
         IF(LENRX.LE.0) LENRX=1
         LENIR = ISUMIR - 1
         IF(LENIR.LE.0) LENIR=1
         ALLOCATE (RX(LENRX),IR(LENIR))
       ENDIF
C
C5------IF THE ARRAYS ARE NOT BIG ENOUGH THEN STOP.
        CALL MEMCHKR(ISUMRX,ISUMIR,LENRX,LENIR,IOUT,IERR,IERRU)
        IF (IERR.GT.0) CALL PLL1SD(IERR,IERRU,IOUT,IOUTG)
C
C6------READ AND PREPARE INFORMATION FOR ENTIRE SIMULATION.
C---------BASIC PACKAGE
        CALL GWF1BAS6RPP(IG(LCIBOU),GZ(LCHNEW),GX(LCSTRT),INBAS,HEADNG,
     1                   NCOL,NROW,NLAY,VBVL,IR(LCIOFL),IUNIT(12),
     2                   IHEDFM,IDDNFM,IHEDUN,IDDNUN,IOUT,IPEROC,ITSOC,
     3                   CHEDFM,CDDNFM,IBDOPT,IXSEC,LBHDSV,LBDDSV,
     4                   IFREFM,IBOUUN,LBBOSV,CBOUFM,HNOFLO,NIUNIT,ITS,
     5                   IAUXSV,RESETDD,RESETDDNEXT)
        IF(IUNIT(1).GT.0)
     1      CALL GWF1BCF6RPP(IG(LCIBOU),GZ(LCHNEW),RX(LCSC1),RX(LCHY),
     2                       GX(LCCR),GX(LCCC),GX(LCCV),GX(LCDELR),
     3                       GX(LCDELC),RX(LCSC2),RX(LCTRPY),IUNIT(1),
     4                       ISS,NCOL,NROW,NLAY,IOUT,RX(LCWETD),IWDFLG,
     5                       RX(LCCVWD))
C-------SUBSTITUTE AND PREPARE FOR PACKAGES WITH NO REWIND
        IF(IUNIT(23).GT.0)
     1      CALL GWF1LPF1SP(IG(LCIBOU),GZ(LCHNEW),GX(LCCR),GX(LCCC),
     2                      GX(LCCV),GX(LCDELR),GX(LCDELC),GX(LCBOTM),
     3                      X(LCHK),X(LCVKA),X(LCVKCB),X(LCHANI),
     4                      X(LCSC1),X(LCSC2),ITRSS,NCOL,NROW,NLAY,IOUT,
     5                      X(LCWETD),NPLPF,NBOTM,GX(LCRMLT),IG(LCIZON),
     6                      NMLTAR,NZONAR,IX(LCLAYF),GX(LCBUFF),ITERPK)
        IF(IUNIT(37).GT.0)
     1     CALL GWF1HUF2SP(IG(LCIBOU),GZ(LCHNEW),GX(LCCR),GX(LCCC),
     2                      GX(LCCV),GX(LCDELR),GX(LCDELC),GX(LCBOTM),
     3                      X(LCHK),X(LCVKA),X(LCSC1),ITRSS,NCOL,NROW,
     4                      NLAY,IOUT,X(LCWETD),NHUF,NBOTM,GX(LCRMLT),
     5                      IG(LCIZON),NMLTAR,NZONAR,X(LCHUFTHK),
     6                      X(LCHKCC),HDRY,0,0,0,IX(LCHGUF),
     7                      X(LCHUFTMP),IUNIT(47),
     8                      X(LCVDHD),X(LCVDHT),IWETIT,
     9                      IHDWET,WETFCT,X(LCGS),X(LCA9))
C---------FLOW-SIMULATION OPTIONS
        IF(IUNIT(2).GT.0)
     1      CALL GWF1WEL6RPPD(IUNIT(2),IOUTG,NWELVL,IWELAL,NCOL,NROW,
     2                        NLAY,NPWEL,RX(LCWELL),IPWBEG,MXWELL,
     3                        IFREFM,ITERPK,INAMLOC,NOPRWL)
        IF(IUNIT(3).GT.0)
     1      CALL GWF1DRN6RPPD(IUNIT(3),IOUTG,NDRNVL,IDRNAL,NCOL,NROW,
     2                        NLAY,NPDRN,RX(LCDRAI),IDRNPB,MXDRN,IFREFM,
     &                        ITERPK,INAMLOC,NOPRDR)
        IF(IUNIT(4).GT.0)
     1      CALL GWF1RIV6RPPD(IUNIT(4),IOUTG,NRIVVL,IRIVAL,NCOL,NROW,
     2                        NLAY,NPRIV,RX(LCRIVR),IRIVPB,MXRIVR,
     3                        IFREFM,ITERPK,INAMLOC,NOPRRV)
        IF(IUNIT(5).GT.0)
     &      CALL GWF1EVT6RPPD(IUNIT(5),IOUTG,NPEVT,ITERPK,INAMLOC)
        IF(IUNIT(7).GT.0)
     1      CALL GWF1GHB6RPPD(IUNIT(7),IOUTG,NGHBVL,IGHBAL,NCOL,NROW,
     2                        NLAY,NPGHB,RX(LCBNDS),IGHBPB,MXBND,IFREFM,
     &                        ITERPK,INAMLOC,NOPRGB)
        IF(IUNIT(8).GT.0)
     &      CALL GWF1RCH6RPPD(IUNIT(8),IOUTG,NPRCH,ITERPK,INAMLOC)
        IF(IUNIT(16).GT.0)
     &      CALL GWF1FHB1RPP(IG(LCIBOU),NROW,NCOL,NLAY,IR(LCFLLC),
     &                   RX(LCBDTM),NBDTIM,RX(LCFLRT),NFLW,NHED,
     &                   IR(LCHDLC),RX(LCSBHD),IUNIT(16),IOUT, NFHBX1,
     &                   NFHBX2,IFHBD3,IFHBD5,NHEDDIM,NFLWDIM)
        IF(IUNIT(18).GT.0)
     1      CALL GWF1STR6RPPD(IUNIT(18),IOUTG,NCOL,NROW,NLAY,NPSTR,
     2                  RX(LCSTRM_),IR(ICSTRM_),ISTRPB,MXSTRM,ITERPK,
     &                  INAMLOC)
        IF(IUNIT(19).GT.0)
     1      CALL GWF1IBS6RPP(GX(LCDELR),GX(LCDELC),GZ(LCHNEW),RX(LCHC),
     2                  RX(LCSCE),RX(LCSCV),RX(LCSUB),NCOL,NROW,
     3                  NLAY,NODES,IIBSOC,ISUBFM,ICOMFM,IHCFM,
     4                  ISUBUN,ICOMUN,IHCUN,IUNIT(19),IOUT,IBSDIM)
        IF(IUNIT(54).GT.0)
     1      CALL GWF1SUB1RPP(GX(LCDELR),GX(LCDELC),GZ(LCHNEW),
     2                  GX(LCBUFF),NCOL,NROW,NLAY,NODES,NPER,NSTP,
     3                  ISUBOC,NND1,ND1,ND2,NDB,NNDB,NPZ,NN,IDSAVE,
     4                  IDREST,NSTPT,IUNIT(54),IOUT)
        IF(IUNIT(20).GT.0)
     1      CALL GWF1CHD6RPPD(IUNIT(20),IOUTG,NCHDVL,NCOL,NROW,NLAY,
     2                        NPCHD,RX(LCCHDS),IPCBEG,MXCHD,IFREFM,
     &                        ITERPK,INAMLOC,NOPRCH)
C
        IF (IUNIT(21).GT.0)
     &      CALL GWF1HFB6RPPA(GX(LCBOTM),GX(LCCR),GX(LCCC),GX(LCDELR),
     &                        GX(LCDELC),RX(LCHFB),IUNIT(21),MXACTFB,
     &                        NBOTM,NCOL,NROW,NLAY,NODES,NHFBNP,NHFB,
     &                        NPHFB,IOUT,IOUTG,ITERPK,MXHFB,IHFB,LAYHDT,
     &                        INAMLOC,NOPRHB)
        IF(IUNIT(39).GT.0)
     &      CALL GWF1ETS1RPPD(IUNIT(39),IOUTG,NPETS,ITERPK,INAMLOC)
        IF(IUNIT(40).GT.0)
     &      CALL GWF1DRT1RPPD(IUNIT(40),IOUTG,NDRTVL,IDRTAL,NCOL,NROW,
     &                        NLAY,NPDRT,RX(LCDRTF),IDRTPB,MXDRT,IFREFM,
     &                        ITERPK,IDRTFL,INAMLOC,NOPRDT)
CLAK
C  REVISED IF STATEMENT
C       IF(IUNIT(46).GT.0.AND.(IUNIT(44).GT.0.OR.IUNIT(22).GT.0))
        IF(IUNIT(46).GT.0)
     &      CALL GWF1GAG5RPP(IR(LSGAGE),NUMGAGE,IOUT,IUNIT(46))
C
C-------CHECK THAT PARAMETER DEFINITIONS ARE COMPLETE
        IF (ITERPK.EQ.1) CALL GLO1BAS6CK(IOUTG,ISEN,NPLIST)
        IF ((ISEN.GT.0 .OR. IBEFLG.EQ.2) .AND. ITERPK.EQ.1)
     &      CALL SEN1BAS6CP(IOUTG,NPLIST,ISENSU,CHEDFM)
        IF (IPES.GT.0)
     &      CALL PES1BAS6CK(X(LCBL),X(LCBU),IX(LCISEN),IOUB,IOUTG,
     &                      IX(LCIPNG),IX(LCLN),NPNG,NPLIST,NPNGAR,
     &                      ITERPK,FAC,FCONV,AP,ADMX,TOL,LAYHDT,NLAY,
     &                      X(LCBSCA),X(LCPARE),ITMXP)
        IF (IUNIT(43).GT.0)
     &      CALL GWF1HYD1RPP(RX(LCHYDM),GX(LCSTRT),NHYDM,NUMH,
     &                       GX(LCDELR),GX(LCDELC),NCOL,NROW,NLAY,
     &                       LCHNEW,LCIBOU,IUNIT(43),IOUT)
        IF(IUNIT(43).GT.0 .AND. IUNIT(19).GT.0)
     &      CALL GWF1HYD1IBS2RPP(RX(LCHYDM),NHYDM,NUMH,GX(LCDELR),
     &                       GX(LCDELC),NCOL,NROW,NLAY,LCIBOU,LCSUB,
     &                       LCHC,IUNIT(43),IOUT)
C
C
C-------SHOW PROGRESS IF REQUESTED
c RBW begin change
C        IF(SHOWPROG)THEN
C          WRITE(*,57) '+'
C   57     FORMAT(A,77(' '))
C        ENDIF
c RBW END change
C
C RBW BEGIN CHANGE
c      goto 110
C RBW END CHANGE
        CALL PLL1BR()
        IF (ISEN.GT.0) THEN
          CALL PLL1MX(X(LCX),X(LCXND),NPE,ND)
          IF (IFO.NE.1 .OR. LASTX.GT.0)
     &        CALL SEN1BAS6PD(IOUT,NPE,NPER,NSTP,NTIMES,X(LCSEND),
     &                        X(LCSNDT))
        ENDIF
C
C       Post-processing of MNW list output --- Parses to time series for
C       individual wells
        IF (IUNIT(50).GT.0) CALL GWF1MNW1OT(MNWSITE,RX(LCWEL2),NWELL2,
     &                                      MXWEL2,IOWELL2,MNWNAME)
C
C       PRINT DATA FOR OBSERVED HEADS AND FLOWS.
        IF (ND.GT.0 .AND. (IFO.NE.1 .OR. LASTX.NE.0))
     &      CALL OBS1BAS6OT(IOUT,IOUTG,NPE,NH,OBSNAM,X(LCBUF1),X(LCX),
     &                      X(LCH),X(LCWT),X(LCHOBS),IPRINT,IFO,ITERP,
     &                      IPAR,IX(LCLN),ISCALS,X(LCWP),MPR,X(LCPRM),
     &                      RSQ,RSQP,RSQO,RSQOO,SOSC,SOSR,IPR,
     &                      IX(LCNIPR),X(LCWTPS),ND,X(LCWTQ),
     &                      X(LCWTQS),IOWTQ,NDMH,NTT2,KTDIM,NPLIST,
     &                      MPRAR,IPRAR,OUTNAM,IX(LCIPLO),EQNAM,NAMES,
     &                      IX(LCIPLP),NDMHAR,NQTDR,NQTRV,NQTGB,NQTST,
     &                      NQTCH,IOWTQCH,IOWTQDR,IOWTQRV,IOWTQGB,
     &                      IOWTQST,LCOBBAS,LCOBDRN,LCOBRIV,LCOBGHB,
     &                      LCOBSTR,LCOBCHD,LCOBADV,X(LCSSGF),X(LCSSDR),
     &                      X(LCSSRV),X(LCSSGB),X(LCSSST),X(LCSSAD),
     &                      X(LCSSCH),X(LCSSPI),X(LCSSTO),ITMXP,
     &                      X(LCBUF2),IPES,X(LCBPRI),X(LCBSCA),LCOBDRT,
     &                      X(LCSSDT),NQTDT,IOWTQDT,NRSO,NPOST,
     &                      NNEGT,NRUNS,NQTSF,IOWTQSF,LCOBSFR,X(LCSSSF),
     &                      NHT,X(LCOTIM),OBSALL)
C       PARALLEL CONVERGENCE TEST
        CALL PLL1CV(IFO)
C-------IF CONVERGENCE ACHIEVED BY SUM OF SQUARES CRITERIA (SOSC)
        IF (IFO.EQ.2) THEN
          ITERPF = ITERP
        ENDIF
C
C-----NONLINEAR REGRESSION BY MODIFIED GAUSS-NEWTON
        IF (IPES.GT.0) THEN
          IF (IYCFLG.LT.1) THEN
C---------EXECUTE ONE GAUSS-NEWTON ITERATION
C RBW BEGIN CHANGE
            IF (MYID.EQ.MPROC) THEN
              continue
c              CALL PES1GAU1AP(X(LCX),ND,NPE,X(LCHOBS),X(LCWT),X(LCWP),
c     &                        Z(LCC),Z(LCSCLE),Z(LCG),X(LCH),Z(LCDD),
c     &                        DMAX,CSA,TOL,IND,IFO,AMP,AP,DMX,IOUTG,
c     &                        X(LCB1),ITERP,IPRINT,IX(LCLN),MPR,
c     &                        X(LCPRM),JMAX,NFIT,Z(LCR),Z(LCGD),
c     &                        Z(LCU),NOPT,X(LCXD),Z(LCS),SOSR,
c     &                        IX(LCNIPR),IPR,GX(LCBUFF),X(LCWTP),NHT,
c     &                        X(LCWTQ),IOWTQ,NDMH,IOSTAR,NPLIST,MPRAR,
c     &                        IPRAR,NDMHAR,X(LCBPRI),RMARM,IAP,
c     &                        Z(LCDMXA),IX(LCNPAR),X(LCAMPA),X(LCAMCA),
c     &                        X(LCAAP),ITMXP,RMAR,IX(LCIPNG),NPNG,
c     &                        NPNGAR)
C RBW END CHANGE
C---------FINAL OUTPUT:
C-----------PRINT SIMULATED EQUIVALENTS AND RESIDUALS IF LEAST-SQUARES
C           COEFFICIENT MATRIX IS SINGULAR OR IF PARAMETER ESTIMATION
C           DOES NOT CONVERGE
              IF (IND.GT.0 .OR. (IFO.EQ.0 .AND. KITP.EQ.ITMXP))
     &            CALL OBS1BAS6OH(X(LCWP),IOUT,NH,X(LCH),X(LCHOBS),
     &                            X(LCWT),OBSNAM,ND,MPR,X(LCPRM),RSQ,
     &                            RSQP,2,IX(LCLN),IPR,IX(LCNIPR),
     &                            X(LCWTPS),X(LCBUF1+IPRAR),
     &                            X(LCBUF1+IPRAR+ND+MPR+IPR),X(LCWTQ),
     &                            X(LCWTQS),NDMH,NTT2,KTDIM,NPLIST,
     &                            MPRAR,IPRAR,OUTNAM,IX(LCIPLO),EQNAM,
     &                            NAMES,IX(LCIPLP),NDMHAR,NQTDR,NQTRV,
     &                            NQTGB,NQTST,NQTCH,IOWTQCH,IOWTQDR,
     &                            IOWTQRV,IOWTQGB,IOWTQST,LCOBBAS,
     &                            LCOBDRN,LCOBRIV,LCOBGHB,LCOBSTR,
     &                            LCOBCHD,LCOBADV,0,X(LCSSGF),X(LCSSDR),
     &                            X(LCSSRV),X(LCSSGB),X(LCSSST),
     &                            X(LCSSAD),X(LCSSCH),X(LCSSPI),
     &                            X(LCSSTO),ITMXP,IPES,X(LCBPRI),
     &                            LCOBDRT,X(LCSSDT),NQTDT,IOWTQDT,
     &                            NRSO,NPOST,NNEGT,NRUNS,NQTSF,IOWTQSF,
     &                            LCOBSFR,X(LCSSSF),NHT)
C RBW BEGIN CHANGE
c      goto 110
C RBW END CHANGE
C-------------SHOW PROGRESS IF REQUESTED
c RBW begin change
C              IF(SHOWPROG)THEN
C                WRITE(*,'(A)') ' '
C              ENDIF
c RBW END change
            ENDIF
          ENDIF
          CALL PLL1BR()
          IF (NUMPROCS.GT.1) THEN
            CALL PLL1CV(IFO)
            CALL PLL1CV(ITERPF)
            CALL PLL1CV(IND)
            CALL PLL1BA(B,MXPAR)
          ENDIF
          IF (IYCFLG.LT.1) THEN
            IF (IFO.GT.0 .AND. IND.EQ.0 .AND. ITERPF.EQ.0) GOTO 20
C
C     IF PARAMETER ESTIMATION DOES NOT CONVERGE, PRINT
C     OBSERVATION-SENSITIVITY TABLE(S)
            IF (ND.GT.0 .AND. ITERP.EQ.ITMXP .AND. IFO.EQ.0)
     &          CALL OBS1BAS6NC(X(LCBUF1),X(LCBUF2),IOUTG,IOWTQ,
     &                          IX(LCIPLO),IPR,ISCALS,ITERP,IX(LCLN),
     &                          MPR,ND,NDMH,NDMHAR,NHT,NPE,NPLIST,
     &                          OBSNAM,OUTNAM,X(LCWT),X(LCWTQ),
     &                          X(LCWTQS),X(LCX),X(LCBSCA),OBSALL)
C
C-----------PRINT FINAL PARAMETER-ESTIMATION OUTPUT
C
C           WRITE CONTRIBUTIONS TO SSWR OF EACH OBSERVATION TYPE AND
C           PRIOR INFORMATION FOR EACH PARAMETER-ESTIMATION ITERATION
C           TO _ss FILE
            IF ((IFO.GT.0 .OR. ITERP.EQ.ITMXP) .AND. OUTNAM.NE.'NONE'
     &          .AND. MYID.EQ.MPROC) THEN
              CALL OBS1BAS6PR1(IFO,IOUTG,ITERPK,ITERSS,ITMXP,IUSS,
     &                         IX(LCNPAR),OUTNAM)
              IF (NH.GT.0) CALL OBS1BAS6HPR(ITERSS,ITMXP,IUSS,X(LCSSGF))
              IF (NQTCH.GT.0) CALL OBS1BAS6FPR(ITERSS,ITMXP,IUSS,
     &                                         X(LCSSCH))
              IF (NQTDR.GT.0) CALL OBS1DRN6PR(ITERSS,ITMXP,IUSS,
     &                                        X(LCSSDR))
              IF (NQTDT.GT.0) CALL OBS1DRT1PR(ITERSS,ITMXP,IUSS,
     &                                        X(LCSSDT))
              IF (NQTRV.GT.0) CALL OBS1RIV6PR(ITERSS,ITMXP,IUSS,
     &                                        X(LCSSRV))
              IF (NQTGB.GT.0) CALL OBS1GHB6PR(ITERSS,ITMXP,IUSS,
     &                                        X(LCSSGB))
              IF (NQTST.GT.0) CALL OBS1STR6PR(ITERSS,ITMXP,IUSS,
     &                                        X(LCSSST))
              IF (NOBADV.GT.0) CALL OBS1ADV2PR(ITERSS,ITMXP,IUSS,
     &                                         X(LCSSAD))
              IF (MPR.GT.0 .OR. IPR.GT.0)
     &            CALL PES1BAS6PR(ITERSS,ITMXP,IUSS,X(LCSSPI))
              CALL OBS1BAS6PR2(IPR,ITERSS,ITMXP,IUSS,MPR,X(LCSSTO))
            ENDIF
C
C           WRITE PARAMETER-ESTIMATION OUTPUT TO GLOBAL FILE
            CALL PES1BAS6OT(Z(LCC),X(LCWT),NPE,RSQ,IOUTG,GX(LCBUFF),ND,
     &                      IPRC,IFO,IND,Z(LCSCLE),X(LCHOBS),X(LCH),
     &                      X(LCB1),X(LCWP),ITERPF,IX(LCLN),MPR,
     &                      X(LCPRM),LPRINT,IDRY,EV,RSQP,VAR,IPR,
     &                      IX(LCNIPR),X(LCWTPS),DETWTP,X(LCBL),X(LCBU),
     &                      Z(LCEIGL),Z(LCEIGV),Z(LCEIGW),NHT,X(LCWTQ),
     &                      X(LCWTQS),DTLWTQ,IOWTQ,NDMH,NPLIST,MPRAR,
     &                      IPRAR,IOUB,IX(LCISEN),IBEALE,ITERP,ITMXP,
     &                      NDMHAR,X(LCPRNT),OUTNAM,X(LCPARE),X(LCSSPI),
     &                      X(LCSSTO),IX(LCNPAR),Z(LCDMXA),X(LCBPRI),
     &                      X(LCBSCA),IPRINT,X(LCAAP),X(LCAMCA),
     &                      X(LCRSQA),X(LCRSPA),X(LCAMPA),ITERPK,OBSALL,
     &                      IUSS)
            IF (IFO.EQ.0 .AND. ITERP.EQ.ITMXP) GOTO 110
C
          ENDIF
        ENDIF
C-------GENERATE INPUT FILE(S) FOR RESAN-2000, BEALE-2000 AND YCINT-2000
        IF (MYID.EQ.MPROC) THEN
          IF (IYCFLG.LT.1 .AND. IPES.GT.0)
     &        CALL PES1BAS6RS(NPE,ND,NDMH,VAR,Z(LCC),X(LCWT),NHT,
     &                        X(LCWTQS),X(LCX),MPR,X(LCPRM),X(LCWP),
     &                        NPLIST,MPRAR,NDMHAR,OUTNAM,X(LCWTPS),
     &                        IPR,IPRAR,IX(LCNIPR),RSQP,IDRY)
          IF (IBEFLG.GT.0 .AND. (IPES.LE.0 .OR. (IPES.GT.0 .AND.
     &        IFO.GT.0)))
     &        CALL PES1BAS6BE(NPE,ND,MPR,VAR,X(LCH),X(LCWT),X(LCX),
     &                        X(LCWP),IX(LCLN),X(LCPRM),X(LCHOBS),
     &                        Z(LCC),IBEALE,ITERPK,IOUT,OBSNAM,
     &                        GX(LCBUFF),NHT,NDMH,X(LCWTQ),NPLIST,MPRAR,
     &                        IBEFLG,OUTNAM,IUBE,BEFIRST,FSTAT,IERR,
     &                        IERRU,NDMHAR,X(LCWTP),IPR,IPRAR,X(LCBPRI),
     &                        IX(LCNIPR))
          IF (IERR.GT.0) GOTO 103
          IF (IYCFLG.GT.-1)
     &        CALL PES1BAS6YC(NPE,ND,MPR,X(LCH),X(LCWT),X(LCX),Z(LCC),
     &                        IOUT,OBSNAM,NHT,NDMH,X(LCWTQ),OUTNAM,
     &                        IYCFLG,IPR,IX(LCIPLO),IERR,IERRU,NDMHAR)
          IF (IERR.GT.0) GOTO 103
        ENDIF
  103   CONTINUE
        CALL PLL1BR()
        CALL PLL1EH(IERR,IERRU,IOUT,IOUTG,MINERR)
        IF (IBEFLG.EQ.2 .AND. IBEALE.NE.0) GOTO 20
        IF (ITERPF.GT.0) GOTO  107
C
C     END OF PARAMETER-ESTIMATION LOOP
  105 CONTINUE
C
  107 CONTINUE
C-------RESIDUAL ANALYSIS
C        OBS1BAS6RE CHANGES H AND MAY CHANGE HOBS
      IF (MYID.EQ.MPROC) THEN
        IF (ND.GT.0)
     &      CALL OBS1BAS6RE(X(LCWP),IOUTG,IOUT,NHT,X(LCH),X(LCHOBS),
     &                      X(LCWT),NDMH,ND,IPAR,MPR,X(LCPRM),IPR,
     &                      IX(LCNIPR),X(LCWTPS),X(LCBUF1),LBUFF,
     &                      X(LCWTQ),X(LCWTQS),NPLIST,MPRAR,IPRAR,
     &                      NDMHAR,NAMES,IX(LCOBSE),X(LCBPRI),RSQP,
     &                      NRSO,NPOST,NNEGT,NRUNS)
C
C       PRINT FINAL PARAMETER-ESTIMATION OUTPUT
        IF (IPES.GT.0 .AND. IYCFLG.LT.1)
     &      CALL PES1BAS6FO(ICNVGP,IFO,IOUTG)
      ENDIF
C
  110 CONTINUE
C     WRITE ANY RECORDS TO BE USED IN RESTARTING FUTURE SIMULATIONS
C       SAVE RESTART RECORDS FOR SUB PACKAGE
! RBW BEGIN change
C      IF(IUNIT(54).GT.0) CALL GWF1SUB1SV(ND2,IDSAVE)
! RBW END change
C8------END OF SIMULATION
! RBW BEGIN change
c      CALL GLO1BAS6ET(IBDT,IOUTG,IPRTIM)
c      CALL CLOSEFILES(INUNIT,FNAME)
!      IF (IBATCH.GT.0) THEN
C       TO USE STATIC MEMORY ALLOCATION, COMMENT OUT THE FOLLOWING
C       DEALLOCATE STATEMENTS
!        DEALLOCATE (GX,GZ,IG,X,Z,IX,XHS,RX,IR,NIPRNAM,EQNAM,NAMES,
!     &              OBSNAM)
!        GOTO 10
!      ENDIF
! RBW END change
C
C     HANDLE WARNINGS AND ERRORS
      CALL PLL1BR()
      CALL PLL1EH(IERR,IERRU,IOUT,IOUTG,MINERR)
      IF (MINERR.LT.0) CALL PLL1SD(IERR,IERRU,IOUT,IOUTG)
      CALL PLL1DE(IERRU,IOUT,IOUTG)
C
  120 CONTINUE
C
      CALL PLL1CL()
c RBW begin change
C      WRITE(*,121)
c RBW END change
121   FORMAT(1X,'Normal termination of MODFLOW-2000')
C RBW BEGIN CHANGE
C      CALL USTOP(' ')
C RBW END CHANGE
C
C RBW BEGIN CHANGE
      if (IUNIT(23).GT.0) then
        DO 122 K=1,NLAY
          IF(LAYTYP(K).NE.0) THEN
            LAYTYP(K)=1
          END IF
  122   continue
      END IF
      IF(IUNIT(1).GT.0) call TransferBCFLayavg
      do 3030 IINDEX=1,200
        LAYTYPdll(IINDEX) = LAYTYP(IINDEX)
        LAYAVGdll(IINDEX) = LAYAVG(IINDEX)
        CHANIdll(IINDEX) = CHANI(IINDEX)
        LAYVKAdll(IINDEX) = LAYVKA(IINDEX)
        if (IUNIT(30).GT.0) then
          LAYWETdll(IINDEX) = LAYWT(IINDEX)
        else
          LAYWETdll(IINDEX) = LAYWET(IINDEX)
        endif
        if (IUNIT(1).GT.0) then
          LAYCONdll(IINDEX) = LAYCON(IINDEX)
        else
          LAYCONdll(IINDEX) = LAYAVG(IINDEX)*10+LAYTYP(IINDEX)
        endif
 3030 CONTINUE
      RETURN
      END
C RBW END CHANGE
c
c
c
      subroutine ReadStressPeriod(KPER, NCOL, NROW, NLAY, NWELLS,
     1  NDRAIN, NRIVER, NBOUND, NRCHOP, NEVTOP, NCHDS,
     2  ISEN, NETSOP, NETSEG,
     3  IUNIT, ISSFLG, TSMULT, NSTEP,PERLEN)
      USE MF2K_ARRAYS
      use CurrentParameters
      DLL_EXPORT ReadStressPeriod
      INCLUDE 'parallel.inc'
      INCLUDE 'param.inc'
      INCLUDE 'openspec.inc'
      COMMON /BCFCOM/LAYCON(200)
      COMMON /DISCOM/LBOTM(200),LAYCBD(200)
      COMMON /LPFCOM/LAYTYP(200),LAYAVG(200),CHANI(200),LAYVKA(200),
     1               LAYWET(200)
      include 'MyInc.inc'
      DIMENSION IUNIT(NIUNIT)
      DIMENSION PERLEN(MXPER),NSTP(MXPER),TSMULT(MXPER),ISSFLG(MXPER)
      CurrentNameCount = 0
C7------SIMULATE EACH STRESS PERIOD.
C        DO 100 KPER = 1, NPER
          KKPER = KPER
          CALL GWF1BAS6ST(NSTP(KKPER),DELT,TSMULT(KKPER),PERTIM,KKPER,
     &                    IOUT,PERLEN(KKPER))
          IF(IUNIT(19).GT.0)
     1        CALL GWF1IBS6ST(ISSFLG,KKPER,GZ(LCHNEW),RX(LCHC),NCOL,
     2              NROW,NLAY,IBSDIM,IOUT)
          IF(IUNIT(54).GT.0)
     1        CALL GWF1SUB1ST(GZ(LCHNEW),NNDB,NDB,ISSFLG,NROW,NCOL,
     1                        NODES,NPER,KPER,NN)
C
C7B-----READ AND PREPARE INFORMATION FOR STRESS PERIOD.
C----------READ USING PACKAGE READ AND PREPARE MODULES.
          IF(IUNIT(2).GT.0)
     &        CALL GWF1WEL6RPSS(RX(LCWELL),NWELLS,MXWELL,IUNIT(2),IOUT,
     1                          NWELVL,IWELAL,IFREFM,NCOL,NROW,NLAY,
     2                          NNPWEL,NPWEL,IPWBEG,NOPRWL)
          IF(IUNIT(3).GT.0)
     &        CALL GWF1DRN6RPSS(RX(LCDRAI),NDRAIN,MXDRN,IUNIT(3),IOUT,
     1                          NDRNVL,IDRNAL,IFREFM,NCOL,NROW,NLAY,
     2                          NNPDRN,NPDRN,IDRNPB,NOPRDR)
          IF(IUNIT(4).GT.0)
     &        CALL GWF1RIV6RPSS(RX(LCRIVR),NRIVER,MXRIVR,IUNIT(4),IOUT,
     1                          NRIVVL,IRIVAL,IFREFM,NCOL,NROW,NLAY,
     2                          NNPRIV,NPRIV,IRIVPB,NOPRRV)
          IF(IUNIT(5).GT.0)
     &        CALL GWF1EVT6RPSS(NEVTOP,IR(LCIEVT),RX(LCEVTR),RX(LCEXDP),
     1                          RX(LCSURF),GX(LCDELR),GX(LCDELC),NCOL,
     2                          NROW,IUNIT(5),IOUT,IFREFM,NPEVT,
     3                          GX(LCRMLT),IG(LCIZON),NMLTAR,NZONAR,
     &                          IEVTPF)
          IF(IUNIT(7).GT.0)
     &        CALL GWF1GHB6RPSS(RX(LCBNDS),NBOUND,MXBND,IUNIT(7),IOUT,
     1                          NGHBVL,IGHBAL,IFREFM,NCOL,NROW,NLAY,
     2                          NNPGHB,NPGHB,IGHBPB,NOPRGB)
          IF(IUNIT(8).GT.0)
     &        CALL GWF1RCH6RPSS(NRCHOP,IR(LCIRCH),RX(LCRECH),GX(LCDELR),
     1                          GX(LCDELC),NROW,NCOL,IUNIT(8),IOUT,
     2                          IFREFM,NPRCH,GX(LCRMLT),IG(LCIZON),
     &                          NMLTAR,NZONAR,IRCHPF)
c rbw begin change
c diable until later
c          IF (IUNIT(17).GT.0)
c     &        CALL GWF1RES1RPS(IR(LCIRES),IR(LCIRSL),RX(LCBRES),
c     &                     RX(LCCRES),RX(LCBBRE),RX(LCHRSE),IG(LCIBOU),
c     &                     GX(LCDELR),GX(LCDELC),NRES,NRESOP,NPTS,NCOL,
c     &                     NROW,NLAY,PERLEN(KKPER),DELT,NSTP(KKPER),
c     &                     TSMULT(KKPER),IUNIT(17),IOUT)
c          IF (IUNIT(18).GT.0)
c     &        CALL GWF1STR6RPSS(RX(LCSTRM_),IR(ICSTRM_),NSTREM,MXSTRM,
c     &                    IUNIT(18),IOUT,IR(LCTBAR),NDIV,NSSSTR6,NTRIB,
c     &                    IR(LCIVAR_),ICALC,IPTFLG,NCOL,NROW,NLAY,
c     &                    NPSTR,ISTRPB)
c rbw end change
          IF(IUNIT(20).GT.0)
     &        CALL GWF1CHD6RPSS(RX(LCCHDS),NCHDS,MXCHD,IG(LCIBOU),NCOL,
     &                          NROW,NLAY,IUNIT(20),IOUT,NCHDVL,IFREFM,
     &                          NNPCHD,NPCHD,IPCBEG,NOPRCH)
c rbw begin change
c diable until later
cCLAK
c          IF(IUNIT(22).GT.0) THEN
c            CALL GWF1LAK3RPS(IR(ICLAKE),LKNODE,MXLKND,
c     1        IUNIT(22),IOUT,NLAKES,RX(LCSTAG),RX(LCLKPR),RX(LCLKEV),
c     2        RX(LCCOND),NTRB,NDV,IR(INTRB),IR(INDV),KKPER,
c     3        GX(LCDELR),GX(LCDELC),
c     4        NCOL,NROW,NLAY,IR(IICS),RX(LKACC7),GX(LCBOTM),NBOTM,
c     5        IR(IISUB),RX(ISILL),ICMX,NCLS,RX(LCWTDR),LWRT,IFREFM,
c     6        IR(IBNLK),RX(ILKBL),IR(IBNLK),RX(ILKBL),NODES,
c     7        RX(IBTMS),RX(LCRNF),RX(IAREN),IUNIT(44),NSS,
c     8        IUNIT(15),RX(LSLAKE),RX(LSAUG),RX(LSPPT),RX(LSRNF),
c     9        NSOL,IOUTS,RX(LKSSMN),RX(LKSSMX),ISSFLG(KKPER),RX(LKVI),
c     *        RX(LKCLKI),RX(LKCUM1),RX(LKCUM2),RX(LKCUM3),RX(LKCUM4),
c     &        RX(LKCUM5),RX(LKCUM6),RX(LKCUM7),RX(LKCUM8),
c     &        RX(LKCUM9))
c            IF (IUNIT(1).GT.0) THEN
c              CALL GWF1LAK3BCF6RPS(IOUT,RX(LCCOND),IR(IBNLK),
c     1             IR(ICLAKE),RX(LCCNDF),GX(LCDELR),GX(LCDELC),
c     2             RX(LCHY),RX(LCTRPY),LAYHDT,MXLKND,NCOL,NROW,NLAY,
c     3             LKNODE,IWDFLG,RX(LCCVWD))
c            ELSE IF (IUNIT(23).GT.0) THEN
c              CALL GWF1LAK3LPF1RPS(IOUT,RX(LCCOND),IR(IBNLK),
c     1             IR(ICLAKE),RX(LCCNDF),GX(LCDELR),GX(LCDELC),
c     2             X(LCHK),X(LCHANI),LAYHDT,MXLKND,NCOL,NROW,NLAY,
c     3             LKNODE,X(LCVKA),X(LCVKCB),GX(LCBOTM),NBOTM)
c            ELSE IF(IUNIT(37).GT.0) THEN
c              CALL GWF1LAK3HUF1RPS(IOUT,RX(LCCOND),IR(IBNLK),
c     1             IR(ICLAKE),RX(LCCNDF),GX(LCDELR),GX(LCDELC),
c     2             X(LCHK),X(LCHKCC),LAYHDT,MXLKND,NCOL,NROW,NLAY,
c     3             LKNODE,X(LCVKA),GX(LCBOTM),NBOTM)
c            ELSE
c              WRITE(IOUT,*) 'LAK Package requires BCF, LPF, or HUF'
c              CALL USTOP(' ')
c            END IF
ccc  Uncomment following call when SFR is added -- ERB 7/9/01
ccc            IF (IUNIT(44).GT.0)
ccc     &          CALL GWF1LAK3SFR1RPS(NTRB,NDV,NLAKES,IR(INTRB),IR(INDV),
ccc     &                  NSS,IR(LCIVAR),IR(LCOTSG),IOUT,NODES,GX(LCBUFF))
c          END IF
cCLAK
c          IF (IUNIT(46).GT.0.AND.
c     &           (IUNIT(44).GT.0.OR.IUNIT(22).GT.0).AND.KKPER.EQ.1)
c     &        CALL GWF1GAG5I(IR(LSGAGE),NUMGAGE,IOUT,IUNIT(15),
c     &                       RX(LCSTAG),RX(LSLAKE),NLAKES,IR(ICSTRM),
c     &                       NSTRM,DUM,NSOL,RX(LKACC7))
c rbw end change
          IF(IUNIT(39).GT.0)
     &        CALL GWF1ETS1RPSS(NETSOP,IR(LCIETS),RX(LCETSR),RX(LCETSX),
     &                          RX(LCETSS),GX(LCDELR),GX(LCDELC),NCOL,
     &                          NROW,IUNIT(39),IOUT,IFREFM,NPETS,
     &                          GX(LCRMLT),IG(LCIZON),NMLTAR,NZONAR,
     &                          IETSPF,NETSEG,RX(LCPXDP),RX(LCPETM),
     &                          NSEGAR)
c rbw end change
c          IF(IUNIT(40).GT.0)
c     &        CALL GWF1DRT1RPSS(RX(LCDRTF),NDRTCL,MXDRT,IUNIT(40),IOUT,
c     &                          NDRTVL,IDRTAL,IFREFM,NCOL,NROW,NLAY,
c     &                          NDRTNP,NPDRT,IDRTPB,IDRTFL,NRFLOW,
c     &                          NOPRDT)
c          IF(IUNIT(43).GT.0 .AND. IUNIT(18).GT.0 .AND. KPER.EQ.1)
c     &        CALL GWF1HYD1STR6RPS(IR(ICSTRM_),RX(LCHYDM),NHYDM,NUMH,
c     &                         GX(LCDELR),GX(LCDELC),NCOL,NROW,NLAY,
c     &                         LCIBOU,LCSTRM_,NSTREM,IUNIT(43),IOUT,
c     &                         MXSTRM)
c          IF(IUNIT(43).GT.0 .AND. KPER.EQ.1)
c     &        CALL GWF1HYD1OT(GZ,LENGZ,RX,LENRX,IG,LENIG,RX(LCHYDM),
c     &                        NUMH,IHYDMUN,0.0,HYDNOH,NROW,NCOL,
c     &                        ITMUNI,IOUT)
c          IF(IUNIT(50).GT.0)
c     &        CALL GWF1MNW1RP(MNWSITE,RX(LCWEL2),NWELL2,MXWEL2,
c     &                         GX(LCHOLD),RX(LCHREF),IG(LCIBOU),
c     &                         GX(LCDELR),GX(LCDELC),GX(LCCR),GX(LCCC),
c     &                         RX(LCHY),GZ(LCHNEW),HCLOSE,SMALL,HDRY,
c     &                         NODES,NROW,NCOL,KPER,KSPREF,IUNIT(50),
c     &                         IOUT,IOWELL2,TOTIM,LAYHDT,GX(LCBOTM),
c     &                         NBOTM,X(LCHK),IUNIT(1),IUNIT(23),
c     &                         IUNIT(37),NLAY,PLOSSMNW,RX(LCTRPY),
c     &                         X(LCHKCC),X(LCHANI))
c rbw end change
C
C-----INITIALIZE SV ARRAY
          IF (ISEN.GT.0 .AND. IUNIT(23).GT.0)
     &        CALL SEN1LPF1SV(IG(LCIZON),KKPER,NCOL,NLAY,NMLTAR,NPLIST,
     &                        NROW,NZONAR,GX(LCRMLT),X(LCSV))
C
C7C-----SIMULATE EACH TIME STEP.





crbw begin cut

C-----END OF TIME STEP (KSTP) AND STRESS PERIOD (KPER) LOOPS
   90     CONTINUE
  100   CONTINUE
      return
      end;

