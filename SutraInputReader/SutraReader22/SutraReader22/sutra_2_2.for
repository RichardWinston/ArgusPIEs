c RBW begin
! In the project settings, it is important to set the calling 
! convention to STDCALL, REFERENCE (/iface:stdref)

      module ErrorFlag
        integer IErrorFlag
      end module ErrorFlag
c
      MODULE SutArrays
c       IMPLICIT DOUBLE PRECISION (A-H,O-Z)
c       ALLOCATABLE :: X(:),Y(:),Z(:),IPBC(:),PBC(:),IUBC(:),UBC(:),IN(:)
       DIMENSION KRV(100)
       integer KIMV4, KIMV5
      end module SutArrays
!
      subroutine GETCOORDINATES(AnX, AY, AZ, I)
       use SutArrays
       use ALLARR
       IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               A810....
!DEC$ attributes dllexport::GETCOORDINATES
!       DLL_EXPORT GETCOORDINATES
      COMMON/DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              @111798b
     1   NSOP,NSOU,NBCN                                                 B210....
c      DIMENSION X(NN),Y(NN),Z(NN)
      AnX = X(I)
      AY  = Y(I)
      AZ  = Z(I)
      return
      end
!
      subroutine GETNODENUMBER(NodeNum, IElem, INode)
       use SutArrays
       use ALLARR
!DEC$ attributes dllexport::GETNODENUMBER
!       DLL_EXPORT GETNODENUMBER
      COMMON/DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,
     1   NSOP,NSOU,NBCN
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48
c      DIMENSION IN(NIN)
      INode = INode+1
      III= INode+IElem*N48
    5 NodeNum = IN(III)
      NodeNum = NodeNum - 1
      return
      end
!
      subroutine GetSpecPresNodeNumber(NodeIndex, NodeNumber,
     1   SpecPress, Conc)
       use SutArrays
       use ALLARR
       IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               A810....
!DEC$ attributes dllexport::GetSpecPresNodeNumber
!       DLL_EXPORT GetSpecPresNodeNumber
      COMMON/DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              @111798b
     1   NSOP,NSOU,NBCN                                                 H100....
      DOUBLE PRECISION SpecPress, Conc
        NodeIndex = NodeIndex+1
c      DIMENSION IPBC(NBCN),PBC(NBCN),IUBC(NBCN),UBC(NBCN)               F130....
        NodeNumber = IPBC(NodeIndex)
        SpecPress = PBC(NodeIndex)
        Conc = UBC(NodeIndex)
        NodeNumber = NodeNumber -1
      return
      end
!
      subroutine GetSpecConcNodeNumber(NodeIndex, NodeNumber, Conc)
       use SutArrays
       use ALLARR
       IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               A810....
!DEC$ attributes dllexport::GetSpecConcNodeNumber
!       DLL_EXPORT GetSpecConcNodeNumber
      COMMON/DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              @111798b
     1   NSOP,NSOU,NBCN                                                 H100....
       DOUBLE PRECISION Conc
c      DIMENSION IUBC(NBCN),UBC(NBCN)
      NodeIndex = NodeIndex+1
        NodeNumber = IUBC(NodeIndex+NPBC)                                                 @111798b
        Conc = UBC(NodeIndex+NPBC)
      NodeNumber = NodeNumber -1
c        Conc = 0
      return
      end
!
      subroutine CLOSE_FILE
       use SutArrays
       use ALLARR
      common /IUNITS/ IUNIT
      LOGICAL ISOPEN
      DIMENSION IUNIT(0:7)                                               @111098
!DEC$ attributes dllexport::CLOSE_FILE
!       DLL_EXPORT CLOSE_FILE
      call TERSEQ()
      INQUIRE(UNIT=IUNIT(1),opened=ISOPEN)
      IF (ISOPEN) CLOSE(UNIT=IUNIT(1))
c      if (Allocated(RM)) deallocate(RM)
c      if (Allocated(RV)) deallocate(RV)
c      if (Allocated(IMV)) deallocate(IMV)
      if (Allocated(X)) deallocate(X)
      if (Allocated(Y)) deallocate(Y)
      if (Allocated(Z)) deallocate(Z)
      if (Allocated(IPBC)) deallocate(IPBC)
      if (Allocated(PBC)) deallocate(PBC)
      if (Allocated(IUBC)) deallocate(IUBC)
      if (Allocated(UBC)) deallocate(UBC)
      if (Allocated(IN)) deallocate(IN)

      return
      end
c RBW end

C     MAIN PROGRAM       S U T R A _ M A I N       SUTRA VERSION 2.2     SUTRA_MAIN.....100
C_______________________________________________________________________ SUTRA_MAIN.....200
C|                                                                     | SUTRA_MAIN.....300
C|                                                                     | SUTRA_MAIN.....400
C|                   UNITED STATES GEOLOGICAL SURVEY                   | SUTRA_MAIN.....500
C|          MODEL FOR SATURATED-UNSATURATED, VARIABLE-DENSITY          | SUTRA_MAIN.....600
C|          GROUND-WATER FLOW WITH SOLUTE OR ENERGY TRANSPORT          | SUTRA_MAIN.....700
C|                                                                     | SUTRA_MAIN.....800
C|                                                                     | SUTRA_MAIN.....900
C|                                                                     | SUTRA_MAIN....1000
C|                                                                     | SUTRA_MAIN....1100
C|                       _______________________                       | SUTRA_MAIN....1200
C|                      |                       |                      | SUTRA_MAIN....1300
C|                      |   S   U   T   R   A   |                      | SUTRA_MAIN....1400
C|                      |_______________________|                      | SUTRA_MAIN....1500
C|                                                                     | SUTRA_MAIN....1600
C|                                                                     | SUTRA_MAIN....1700
C|                Saturated    Unsaturated    TRAnsport                | SUTRA_MAIN....1800
C|                =            =              ===                      | SUTRA_MAIN....1900
C|                                                                     | SUTRA_MAIN....2000
C|                                                                     | SUTRA_MAIN....2100
C|                                                                     | SUTRA_MAIN....2200
C|    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    | SUTRA_MAIN....2300
C|    *                                                           *    | SUTRA_MAIN....2400
C|    *  PHYSICS OPTIONS:                                         *    | SUTRA_MAIN....2500
C|    *  -> Saturated and/or unsaturated ground-water flow        *    | SUTRA_MAIN....2600
C|    *  -> Either single species reactive solute transport       *    | SUTRA_MAIN....2700
C|    *     or thermal energy transport                           *    | SUTRA_MAIN....2800
C|    *  GEOMETRY OPTIONS:                                        *    | SUTRA_MAIN....2900
C|    *  -> Two-dimensional areal or cross-sectional simulation   *    | SUTRA_MAIN....3000
C|    *  -> Fully three-dimensional simulation                    *    | SUTRA_MAIN....3100
C|    *  -> Either two- or three-dimensional Cartesian or         *    | SUTRA_MAIN....3200
C|    *     two-dimensional radial coordinates                    *    | SUTRA_MAIN....3300
C|    *  NUMERICAL METHODS:                                       *    | SUTRA_MAIN....3400
C|    *  -> Hybrid Galerkin-finite-element method and             *    | SUTRA_MAIN....3500
C|    *     integrated-finite-difference method                   *    | SUTRA_MAIN....3600
C|    *     with two-dimensional quadrilateral or                 *    | SUTRA_MAIN....3700
C|    *     three-dimensional generalized hexahedral              *    | SUTRA_MAIN....3800
C|    *     finite elements                                       *    | SUTRA_MAIN....3900
C|    *  -> Finite-difference time discretization                 *    | SUTRA_MAIN....4000
C|    *  -> Nonlinear iterative, sequential or steady-state       *    | SUTRA_MAIN....4100
C|    *     solution modes                                        *    | SUTRA_MAIN....4200
C|    *  -> Direct and iterative solvers                          *    | SUTRA_MAIN....4300
C|    *  OUTPUT OPTIONS:                                          *    | SUTRA_MAIN....4400
C|    *  -> Optional fluid velocity calculation                   *    | SUTRA_MAIN....4500
C|    *  -> Optional observation well output                      *    | SUTRA_MAIN....4600
C|    *  -> Optional fluid mass and solute mass or energy budget  *    | SUTRA_MAIN....4700
C|    *  -> Flexible, columnwise output of solution               *    | SUTRA_MAIN....4800
C|    *                                                           *    | SUTRA_MAIN....4900
C|    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    | SUTRA_MAIN....5000
C|                                                                     | SUTRA_MAIN....5100
C|                                                                     | SUTRA_MAIN....5200
C|                                                                     | SUTRA_MAIN....5300
C|       Complete explanation of the function and use of this code     | SUTRA_MAIN....5400
C|       is given in :                                                 | SUTRA_MAIN....5500
C|                                                                     | SUTRA_MAIN....5600
C|       Voss, Clifford I., and Provost, Alden M., 2002,               | SUTRA_MAIN....5700
C|            SUTRA - A model for saturated-unsaturated                | SUTRA_MAIN....5800
C|            variable-density ground-water flow with                  | SUTRA_MAIN....5900
C|            solute or energy transport: U.S. Geological              | SUTRA_MAIN....6000
C|            Survey Water-Resources Investigations Report             | SUTRA_MAIN....6100
C|            02-4231, 291 p. (Version of Sept 22, 2010)               | SUTRA_MAIN....6200
C|                                                                     | SUTRA_MAIN....6300
C|                                                                     | SUTRA_MAIN....6400
C|                                                                     | SUTRA_MAIN....6500
C|       Users who wish to be notified of updates of the SUTRA         | SUTRA_MAIN....6600
C|       code and documentation may be added to the mailing list       | SUTRA_MAIN....6700
C|       by sending a request to :                                     | SUTRA_MAIN....6800
C|                                                                     | SUTRA_MAIN....6900
C|                           SUTRA Support                             | SUTRA_MAIN....7000
C|                       U.S. Geological Survey                        | SUTRA_MAIN....7100
C|                        411 National Center                          | SUTRA_MAIN....7200
C|                       Reston, Virginia 20192                        | SUTRA_MAIN....7300
C|                                USA                                  | SUTRA_MAIN....7400
C|                                                                     | SUTRA_MAIN....7500
C|    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    | SUTRA_MAIN....7600
C|    *                                                           *    | SUTRA_MAIN....7700
C|    *  The SUTRA code and documentation were originally         *    | SUTRA_MAIN....7800
C|    *  prepared under a joint research project of the U.S.      *    | SUTRA_MAIN....7900
C|    *  Geological Survey, Department of the Interior, Reston,   *    | SUTRA_MAIN....8000
C|    *  Virginia, and the Engineering and Services Laboratory,   *    | SUTRA_MAIN....8100
C|    *  U.S. Air Force Engineering and Services Center, Tyndall  *    | SUTRA_MAIN....8200
C|    *  A.F.B., Florida.  The SUTRA code and documentation are   *    | SUTRA_MAIN....8300
C|    *  available for unlimited distribution.                    *    | SUTRA_MAIN....8400
C|    *                                                           *    | SUTRA_MAIN....8500
C|    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    | SUTRA_MAIN....8600
C|                                                                     | SUTRA_MAIN....8700
C|    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    | SUTRA_MAIN....8800
C|    *                                                           *    | SUTRA_MAIN....8900
C|    *  Original Release: 1984, Version 1.0                      *    | SUTRA_MAIN....9000
C|    *  by: Clifford I. Voss, U.S. Geological Survey             *    | SUTRA_MAIN....9100
C|    *                                                           *    | SUTRA_MAIN....9200
C|    *  First Revision: June 1990, Version 1.1 (V06902D)         *    | SUTRA_MAIN....9300
C|    *  by: Clifford I. Voss, U.S. Geological Survey             *    | SUTRA_MAIN....9400
C|    *                                                           *    | SUTRA_MAIN....9500
C|    *  Second Revision: September 1997, Version 1.2 (V09972D)   *    | SUTRA_MAIN....9600
C|    *  by: C.I. Voss and David Boldt, U.S. Geological Survey    *    | SUTRA_MAIN....9700
C|    *                                                           *    | SUTRA_MAIN....9800
C|    *  Third Revision: September 2003, Version 2.0 (2D3D.1)     *    | SUTRA_MAIN....9900
C|    *  by: A.M. Provost & C.I. Voss, U.S. Geological Survey     *    | SUTRA_MAIN...10000
C|    *                                                           *    | SUTRA_MAIN...10100
C|    *  Fourth Revision: June 2008, Version 2.1                  *    | SUTRA_MAIN...10200
C|    *  by: A.M. Provost & C.I. Voss, U.S. Geological Survey     *    | SUTRA_MAIN...10300
C|    *                                                           *    | SUTRA_MAIN...10400
C|    *  Fifth Revision: September 2010, Version 2.2              *    | SUTRA_MAIN...10500
C|    *  by: A.M. Provost & C.I. Voss, U.S. Geological Survey     *    | SUTRA_MAIN...10600
C|    *                                                           *    | SUTRA_MAIN...10700
C|    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    | SUTRA_MAIN...10800
C|                                                                     | SUTRA_MAIN...10900
C|                                                                     | SUTRA_MAIN...11000
C|_____________________________________________________________________| SUTRA_MAIN...11100
C                                                                        SUTRA_MAIN...11200
C                                                                        SUTRA_MAIN...11300
C                                                                        SUTRA_MAIN...11400
c RBW begin
!      PROGRAM SUTRA_MAIN                                                 SUTRA_MAIN...11500
      SUBROUTINE INITIALIZE(NumNodes, NumElem, NPresB, NConcB,
     1   IERRORCODE, InputFile )
!     1   IERRORCODE)
      use SutArrays
      use ErrorFlag
c rbw end change
      USE ALLARR                                                         SUTRA_MAIN...11600
      USE PTRDEF                                                         SUTRA_MAIN...11700
      USE EXPINT                                                         SUTRA_MAIN...11800
      USE SCHDEF                                                         SUTRA_MAIN...11900
      USE BCSDEF                                                         SUTRA_MAIN...12000
      USE FINDEF                                                         SUTRA_MAIN...12100
      USE LLDEF                                                          SUTRA_MAIN...12200
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                SUTRA_MAIN...12300
      PARAMETER (NCOLMX=9)                                               SUTRA_MAIN...12400
C                                                                        SUTRA_MAIN...12500
C.....PROGRAMMERS SET SUTRA VERSION NUMBER HERE (8 CHARACTERS MAXIMUM)   SUTRA_MAIN...12600
      CHARACTER*8, PARAMETER :: VERN='2.2'                               SUTRA_MAIN...12700
C                                                                        SUTRA_MAIN...12800
c rbw begin
!      character*255, PARAMETER :: 
!     1 InputFile='C:\SutraSuite\debug\Island3D.inp'
      character (len=*) InputFile
      intent (in) InputFile
!      CHARACTER*80 FNAIN
c rbw end change
      CHARACTER*8 VERNUM, VERNIN                                         SUTRA_MAIN...12900
      CHARACTER*1 TITLE1(80),TITLE2(80)                                  SUTRA_MAIN...13000
      CHARACTER*80 SIMULA(5),MSHTYP(2),LAYNOR(2),SIMSTR,MSHSTR,LAYSTR    SUTRA_MAIN...13100
      CHARACTER*80 CUNSAT, CSSFLO ,CSSTRA, CREAD                         SUTRA_MAIN...13200
      CHARACTER*80 UNSSTR, SSFSTR ,SSTSTR, RDSTR                         SUTRA_MAIN...13300
      CHARACTER*80 UNAME,FNAME,FNINP,FNICS,FNBCS                         SUTRA_MAIN...13400
      CHARACTER*80 ERRCOD,CHERR(10)                                      SUTRA_MAIN...13500
      CHARACTER*40 SOLNAM(0:10)                                          SUTRA_MAIN...13600
      CHARACTER*10 SOLWRD(0:10)                                          SUTRA_MAIN...13700
      CHARACTER*10 ADSMOD                                                SUTRA_MAIN...13800
      CHARACTER INTFIL*1000                                              SUTRA_MAIN...13900
      CHARACTER*10 BCSSCH                                                SUTRA_MAIN...14000
      CHARACTER*80 CDUM80                                                SUTRA_MAIN...14100
      INTEGER RMVDIM,IMVDIM,CMVDIM,PMVDIM,LMVDIM                         SUTRA_MAIN...14200
      LOGICAL ONCEK5,ONCEK6,ONCEK7,ONCEK8                                SUTRA_MAIN...14300
      LOGICAL ONCEK10,ONCEK11,ONCEK12,ONCEK13                            SUTRA_MAIN...14400
      LOGICAL ONCEFO                                                     SUTRA_MAIN...14500
      LOGICAL ONCEBCS, SETBCS                                            SUTRA_MAIN...14600
      LOGICAL ALCBCS,ALCFIN,ALCOBS                                       SUTRA_MAIN...14700
      DIMENSION FNAME(0:13),IUNIT(0:13)                                  SUTRA_MAIN...14800
      DIMENSION INERR(10), RLERR(10)                                     SUTRA_MAIN...14900
      DIMENSION J5COL(NCOLMX), J6COL(NCOLMX)                             SUTRA_MAIN...15000
      ALLOCATABLE :: FNBCS(:), IUBCS(:)                                  SUTRA_MAIN...15100
      DIMENSION KTYPE(2)                                                 SUTRA_MAIN...15200
      TYPE (LLD), POINTER :: DENB                                        SUTRA_MAIN...15300
      COMMON /ALC/ ALCBCS,ALCFIN,ALCOBS                                  SUTRA_MAIN...15400
      COMMON /BCSL/ ONCEBCS                                              SUTRA_MAIN...15500
      COMMON /CLAY/ LAYSTR                                               SUTRA_MAIN...15600
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  SUTRA_MAIN...15700
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           SUTRA_MAIN...15800
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      SUTRA_MAIN...15900
      COMMON /DIMLAY/ NLAYS,NNLAY,NELAY                                  SUTRA_MAIN...16000
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              SUTRA_MAIN...16100
     1   NSOP,NSOU,NBCN,NCIDB                                            SUTRA_MAIN...16200
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        SUTRA_MAIN...16300
      COMMON /DIMX2/ NELTA, NNVEC, NDIMIA, NDIMJA                        SUTRA_MAIN...16400
      COMMON /FNAMES/ UNAME,FNAME                                        SUTRA_MAIN...16500
      COMMON /FO/ONCEFO                                                  SUTRA_MAIN...16600
      COMMON /FUNIB/ NFBCS                                               SUTRA_MAIN...16700
      COMMON /FUNITA/ IUNIT                                              SUTRA_MAIN...16800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 SUTRA_MAIN...16900
     1   K10,K11,K12,K13                                                 SUTRA_MAIN...17000
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      SUTRA_MAIN...17100
      COMMON /ITSOLI/ ITRMXP,ITOLP,NSAVEP,ITRMXU,ITOLU,NSAVEU            SUTRA_MAIN...17200
      COMMON /ITSOLR/ TOLP,TOLU                                          SUTRA_MAIN...17300
      COMMON /JCOLS/ NCOLPR, LCOLPR, NCOLS5, NCOLS6, J5COL, J6COL        SUTRA_MAIN...17400
      COMMON /KPRBCS/ KINACT                                             SUTRA_MAIN...17500
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,                SUTRA_MAIN...17600
     1   KPANDS,KVEL,KCORT,KBUDG,KSCRN,KPAUSE                            SUTRA_MAIN...17700
      COMMON /MODSOR/ ADSMOD                                             SUTRA_MAIN...17800
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      SUTRA_MAIN...17900
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      SUTRA_MAIN...18000
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        SUTRA_MAIN...18100
      COMMON /PLT1/ ONCEK5, ONCEK6, ONCEK7, ONCEK8                       SUTRA_MAIN...18200
      COMMON /PLT2/ ONCEK10, ONCEK11, ONCEK12, ONCEK13                   SUTRA_MAIN...18300
      COMMON /SCH/ NSCH,ISCHTS,NSCHAU                                    SUTRA_MAIN...18400
      COMMON /SOLVC/ SOLWRD, SOLNAM                                      SUTRA_MAIN...18500
      COMMON /SOLVN/ NSLVRS                                              SUTRA_MAIN...18600
      COMMON /SOLVI/ KSOLVP, KSOLVU, NN1, NN2, NN3                       SUTRA_MAIN...18700
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       SUTRA_MAIN...18800
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART      SUTRA_MAIN...18900
      COMMON /VER/ VERNUM, VERNIN                                        SUTRA_MAIN...19000
c rbw begin
!DEC$ attributes dllexport::INITIALIZE
!       DLL_EXPORT INITIALIZE
c rbw end
C....."NSLVRS" AND THE ARRAYS "SOLWRD" AND "SOLNAM" ARE INITIALIZED      SUTRA_MAIN...19100
C        IN THE BLOCK-DATA SUBPROGRAM "BDINIT"                           SUTRA_MAIN...19200
C                                                                        SUTRA_MAIN...19300
C                                                                        SUTRA_MAIN...19400
C.....COPY PARAMETER VERN (SUTRA VERSION NUMBER) TO VARIABLE VERNUM,     SUTRA_MAIN...19500
C        WHICH IS PASSED THROUGH COMMON BLOCK VER.                       SUTRA_MAIN...19600
      VERNUM = VERN                                                      SUTRA_MAIN...19700
C                                                                        SUTRA_MAIN...19800
C.....SET THE ALLOCATION FLAGS TO FALSE                                  SUTRA_MAIN...19900
      ALLO1 = .FALSE.                                                    SUTRA_MAIN...20000
      ALLO2 = .FALSE.                                                    SUTRA_MAIN...20100
      ALLO3 = .FALSE.                                                    SUTRA_MAIN...20200
C                                                                        SUTRA_MAIN...20300
C.....INITIALIZE FLAG TO INDICATE THAT BCSTEP HAS NOT YET BEEN CALLED    SUTRA_MAIN...20400
C        IN THE MAIN PROGRAM                                             SUTRA_MAIN...20500
      ONCEBCS = .FALSE.                                                  SUTRA_MAIN...20600
C                                                                        SUTRA_MAIN...20700
C_______________________________________________________________________ SUTRA_MAIN...20800
C|                                                                     | SUTRA_MAIN...20900
C|  *****************************************************************  | SUTRA_MAIN...21000
C|  *                                                               *  | SUTRA_MAIN...21100
C|  *   **********  M E M O R Y   A L L O C A T I O N  **********   *  | SUTRA_MAIN...21200
C|  *                                                               *  | SUTRA_MAIN...21300
C|  *   The main arrays used by SUTRA are dimensioned dynamically   *  | SUTRA_MAIN...21400
C|  *   in the main program, SUTRA_MAIN.  The amount of storage     *  | SUTRA_MAIN...21500
C|  *   required by these arrays depends on the dimensionality of   *  | SUTRA_MAIN...21600
C|  *   the problem (2D or 3D) and the particular solver(s) used.   *  | SUTRA_MAIN...21700
C|  *                                                               *  | SUTRA_MAIN...21800
C|  *               |---------------------|---------------------|   *  | SUTRA_MAIN...21900
C|  *               |     sum of real     |    sum of integer   |   *  | SUTRA_MAIN...22000
C|  *               |   array dimensions  |   array dimensions  |   *  | SUTRA_MAIN...22100
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...22200
C|  *   | 2D,       | (2*NBI+27)*NN+19*NE |   NN+5*NE+2*NSOP    |   *  | SUTRA_MAIN...22300
C|  *   | direct    |    +3*NBCN+6*NOBS   | +2*NSOU+4*NBCN+NOBS |   *  | SUTRA_MAIN...22400
C|  *   | solver    |   +2*NSCH+22+NRBCS  |  +3*NSCH+4+NI1BCS   |   *  | SUTRA_MAIN...22500
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...22600
C|  *   | 2D,       | 2*NELT+28*NN+19*NE  |   NELT+2*NN+5*NE    |   *  | SUTRA_MAIN...22700
C|  *   | iterative |   +3*NBCN+6*NOBS    |   +2*NSOP+2*NSOU    |   *  | SUTRA_MAIN...22800
C|  *   | solver(s) |   +2*NSCH+NWF+220   | +4*NBCN+NOBS+3*NSCH |   *  | SUTRA_MAIN...22900
C|  *   |           |       +NRBCS        |   +NWI+2+NI1BCS     |   *  | SUTRA_MAIN...23000
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...23100
C|  *   | 3D,       | (2*NBI+27)*NN+45*NE |   NN+9*NE+2*NSOP    |   *  | SUTRA_MAIN...23200
C|  *   | direct    |    +3*NBCN+6*NOBS   | +2*NSOU+4*NBCN+NOBS |   *  | SUTRA_MAIN...23300
C|  *   | solver    |   +2*NSCH+8+NRBCS   |  +3*NSCH+4+NI1BCS   |   *  | SUTRA_MAIN...23400
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...23500
C|  *   | 3D,       | 2*NELT+28*NN+45*NE  |   NELT+2*NN+9*NE    |   *  | SUTRA_MAIN...23600
C|  *   | iterative |   +3*NBCN+6*NOBS    |   +2*NSOP+2*NSOU    |   *  | SUTRA_MAIN...23700
C|  *   | solver(s) |   +2*NSCH+NWF+6     | +4*NBCN+NOBS+3*NSCH |   *  | SUTRA_MAIN...23800
C|  *   |           |       +NRBCS        |   +NWI+2+NI1BCS     |   *  | SUTRA_MAIN...23900
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...24000
C|  *                                                               *  | SUTRA_MAIN...24100
C|  *               |---------------------|---------------------|   *  | SUTRA_MAIN...24200
C|  *               |  sum of character   |  sum of dimensions  |   *  | SUTRA_MAIN...24300
C|  *               |   array effective   |     of arrays of    |   *  | SUTRA_MAIN...24400
C|  *               |     dimensions      |       pointers      |   *  | SUTRA_MAIN...24500
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...24600
C|  *   | all cases |   73*NOBS+89*NSCH   |        2*NSCH       |   *  | SUTRA_MAIN...24700
C|  *   |           |       +NCIDB        |                     |   *  | SUTRA_MAIN...24800
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...24900
C|  *                                                               *  | SUTRA_MAIN...25000
C|  *               |---------------------|                         *  | SUTRA_MAIN...25100
C|  *               |    sum of logical   |                         *  | SUTRA_MAIN...25200
C|  *               |   array dimensions  |                         *  | SUTRA_MAIN...25300
C|  *   |-----------|---------------------|                         *  | SUTRA_MAIN...25400
C|  *   | all cases |        ITMAX        |                         *  | SUTRA_MAIN...25500
C|  *   |-----------|---------------------|                         *  | SUTRA_MAIN...25600
C|  *                                                               *  | SUTRA_MAIN...25700
C|  *   Quantities in the tables above are defined in Section 7.3   *  | SUTRA_MAIN...25800
C|  *   of the published documentation (Voss & Provost, 2002,       *  | SUTRA_MAIN...25900
C|  *   USGS Water-Resources Investigations Report 02-4231,         *  | SUTRA_MAIN...26000
C|  *   Version of Oct 22, 2009).                                   *  | SUTRA_MAIN...26100
C|  *                                                               *  | SUTRA_MAIN...26200
C|  *   During each run, SUTRA writes memory usage information to   *  | SUTRA_MAIN...26300
C|  *   the LST output file.                                        *  | SUTRA_MAIN...26400
C|  *                                                               *  | SUTRA_MAIN...26500
C|  *****************************************************************  | SUTRA_MAIN...26600
C|_____________________________________________________________________| SUTRA_MAIN...26700
C                                                                        SUTRA_MAIN...26800
C                                                                        SUTRA_MAIN...26900
C_______________________________________________________________________ SUTRA_MAIN...27000
C|                                                                     | SUTRA_MAIN...27100
C|  *****************************************************************  | SUTRA_MAIN...27200
C|  *                                                               *  | SUTRA_MAIN...27300
C|  *   ***********  F I L E   A S S I G N M E N T S  ***********   *  | SUTRA_MAIN...27400
C|  *                                                               *  | SUTRA_MAIN...27500
C|  *   Unit K0 contains the FORTRAN unit number and filename       *  | SUTRA_MAIN...27600
C|  *   assignments for the various SUTRA input and output files.   *  | SUTRA_MAIN...27700
C|  *   Each line of Unit K0 begins with a file type, followed by   *  | SUTRA_MAIN...27800
C|  *   a unit number and a filename for that type, all in free     *  | SUTRA_MAIN...27900
C|  *   format. Permitted file types are INP, BCS, ICS, LST, RST,   *  | SUTRA_MAIN...28000
C|  *   NOD, ELE, BCOF, BCOP, BCOS, BCOU, OBS, OBC, and SMY.        *  | SUTRA_MAIN...28100
C|  *   Assignments may be listed in any order.                     *  | SUTRA_MAIN...28200
C|  *   Example ("#" indicates a comment):                          *  | SUTRA_MAIN...28300
C|  *   'INP'  50  'project.inp'   # required                       *  | SUTRA_MAIN...28400
C|  *   'BCS'  52  'project.bcs'   # optional                       *  | SUTRA_MAIN...28500
C|  *   'ICS'  55  'project.ics'   # required                       *  | SUTRA_MAIN...28600
C|  *   'LST'  60  'project.lst'   # required                       *  | SUTRA_MAIN...28700
C|  *   'RST'  66  'project.rst'   # optional                       *  | SUTRA_MAIN...28800
C|  *   'NOD'  70  'project.nod'   # optional                       *  | SUTRA_MAIN...28900
C|  *   'ELE'  80  'project.ele'   # optional                       *  | SUTRA_MAIN...29000
C|  *   'OBS'  90  'project.obs'   # optional                       *  | SUTRA_MAIN...29100
C|  *   'OBC'  90  'project.obc'   # optional                       *  | SUTRA_MAIN...29200
C|  *   'BCOF' 95  'project.bcof'  # optional                       *  | SUTRA_MAIN...29300
C|  *   'BCOP' 96  'project.bcop'  # optional                       *  | SUTRA_MAIN...29400
C|  *   'BCOS' 97  'project.bcos'  # optional                       *  | SUTRA_MAIN...29500
C|  *   'BCOU' 98  'project.bcou'  # optional                       *  | SUTRA_MAIN...29600
C|  *   'SMY'  40  'project.smy'   # optional; defaults to          *  | SUTRA_MAIN...29700
C|  *                              #           filename="SUTRA.SMY" *  | SUTRA_MAIN...29800
C|  *                                                               *  | SUTRA_MAIN...29900
C|  *   Note that the filenames for types OBS and OBC are actually  *  | SUTRA_MAIN...30000
C|  *   root names from which SUTRA will automatically generate     *  | SUTRA_MAIN...30100
C|  *   observation output filenames based on the combinations of   *  | SUTRA_MAIN...30200
C|  *   schedules and output formats that appear in the observation *  | SUTRA_MAIN...30300
C|  *   specifications.  If a unit number of zero is specified for  *  | SUTRA_MAIN...30400
C|  *   a file, SUTRA will automatically assign a valid unit number *  | SUTRA_MAIN...30500
C|  *   to that file.                                               *  | SUTRA_MAIN...30600
C|  *                                                               *  | SUTRA_MAIN...30700
C|  *****************************************************************  | SUTRA_MAIN...30800
C|_____________________________________________________________________| SUTRA_MAIN...30900
C                                                                        SUTRA_MAIN...31000
C.....SET FILENAME AND FORTRAN UNIT NUMBER FOR UNIT K0                   SUTRA_MAIN...31100
c rbw begin change
      IERRORCODE = 0
      IErrorFlag = 0
c rbw end change
      UNAME = 'SUTRA.FIL'                                                SUTRA_MAIN...31200
      K0 = 10                                                            SUTRA_MAIN...31300
C.....INITIALIZE NFLOMX TO ZERO NOW IN CASE TERMINATION SEQUENCE IS      SUTRA_MAIN...31400
C        CALLED BEFORE NFLOMX GETS SET.                                  SUTRA_MAIN...31500
      NFLOMX = 0                                                         SUTRA_MAIN...31600
C.....ASSIGN UNIT NUMBERS AND OPEN FILE UNITS FOR THIS SIMULATION,       SUTRA_MAIN...31700
C        EXCEPT OBSERVATION OUTPUT FILES.                                SUTRA_MAIN...31800
      ONCEFO = .FALSE.                                                   SUTRA_MAIN...31900
c rbw begin change
!      CALL FOPEN()                                                       SUTRA_MAIN...32000
      CALL FOPEN(InputFile)                                                       SUTRA_MAIN...28700
      if (IErrorFlag.ne.0) then
        IERRORCODE = IErrorFlag
        goto 1000
      endif
c rbw end change
C.....STORE INP, BCS, AND ICS FILENAMES FOR LATER REFERENCE, SINCE THE   SUTRA_MAIN...32100
C        CORRESPONDING ENTRIES IN FNAME MAY BE OVERWRITTEN BY FILE       SUTRA_MAIN...32200
C        INSERTION.                                                      SUTRA_MAIN...32300
      FNINP = FNAME(1)                                                   SUTRA_MAIN...32400
      FNICS = FNAME(2)                                                   SUTRA_MAIN...32500
      ALLOCATE (FNBCS(NFBCS), IUBCS(NFBCS))                              SUTRA_MAIN...32600
      DO 30 NFB=1,NFBCS                                                  SUTRA_MAIN...32700
         FNBCS(NFB) = FNAMB(NFB)                                         SUTRA_MAIN...32800
         IUBCS(NFB) = IUNIB(NFB)                                         SUTRA_MAIN...32900
   30 CONTINUE                                                           SUTRA_MAIN...33000
C                                                                        SUTRA_MAIN...33100
C                                                                        SUTRA_MAIN...33200
C.....OUTPUT BANNER                                                      SUTRA_MAIN...33300
c rbw begin change
!      WRITE(K3,110) TRIM(VERNUM)                                         SUTRA_MAIN...33400
!  110 FORMAT('1',131('*')////3(132('*')////)////                         SUTRA_MAIN...33500
!     1   47X,' SSSS   UU  UU  TTTTTT  RRRRR     AA  '/                   SUTRA_MAIN...33600
!     2   47X,'SS   S  UU  UU  T TT T  RR  RR   AAAA '/                   SUTRA_MAIN...33700
!     3   47X,'SSSS    UU  UU    TT    RRRRR   AA  AA'/                   SUTRA_MAIN...33800
!     4   47X,'    SS  UU  UU    TT    RR R    AAAAAA'/                   SUTRA_MAIN...33900
!     5   47X,'SS  SS  UU  UU    TT    RR RR   AA  AA'/                   SUTRA_MAIN...34000
!     6   47X,' SSSS    UUUU     TT    RR  RR  AA  AA'/                   SUTRA_MAIN...34100
!     7   7(/),37X,'U N I T E D    S T A T E S   ',                       SUTRA_MAIN...34200
!     8   'G E O L O G I C A L   S U R V E Y'////                         SUTRA_MAIN...34300
!     9   45X,'SUBSURFACE FLOW AND TRANSPORT SIMULATION MODEL'/           SUTRA_MAIN...34400
!     *   //58X,'-SUTRA VERSION ',A,'-'///                                SUTRA_MAIN...34500
!     A   36X,'*  SATURATED-UNSATURATED FLOW AND SOLUTE OR ENERGY',       SUTRA_MAIN...34600
!     B   ' TRANSPORT  *'////4(////132('*')))                             SUTRA_MAIN...34700
c rbw end change
C                                                                        SUTRA_MAIN...34800
C_______________________________________________________________________ SUTRA_MAIN...34900
C|                                                                     | SUTRA_MAIN...35000
C|  *****************************************************************  | SUTRA_MAIN...35100
C|  *                                                               *  | SUTRA_MAIN...35200
C|  *   *********  R E A D I N G   I N P U T   D A T A  *********   *  | SUTRA_MAIN...35300
C|  *   *********  A N D   E R R O R   H A N D L I N G  *********   *  | SUTRA_MAIN...35400
C|  *                                                               *  | SUTRA_MAIN...35500
C|  *   SUTRA typically reads input data line by line as follows.   *  | SUTRA_MAIN...35600
C|  *   Subroutine READIF is called to skip over any comment        *  | SUTRA_MAIN...35700
C|  *   lines and read a single line of input data (up to 1000      *  | SUTRA_MAIN...35800
C|  *   characters) into internal file INTFIL. The input data       *  | SUTRA_MAIN...35900
C|  *   are then read from INTFIL. In case of an error, subroutine  *  | SUTRA_MAIN...36000
C|  *   SUTERR is called to report it, and control passes to the    *  | SUTRA_MAIN...36100
C|  *   termination sequence in subroutine TERSEQ.  The variable    *  | SUTRA_MAIN...36200
C|  *   ERRCOD is used to identify the nature of the error and is   *  | SUTRA_MAIN...36300
C|  *   set prior to calling READIF. The variables CHERR, INERR,    *  | SUTRA_MAIN...36400
C|  *   and RLERR can be used to send character, integer, or real   *  | SUTRA_MAIN...36500
C|  *   error information to subroutine SUTERR.                     *  | SUTRA_MAIN...36600
C|  *   Example from the main program:                              *  | SUTRA_MAIN...36700
C|  *                                                               *  | SUTRA_MAIN...36800
C|  *   ERRCOD = 'REA-INP-3'                                        *  | SUTRA_MAIN...36900
C|  *   CALL READIF(K1, 0, INTFIL, ERRCOD)                          *  | SUTRA_MAIN...37000
C|  *   READ(INTFIL,*,IOSTAT=INERR(1)) NN,NE,NPBC,NUBC,             *  | SUTRA_MAIN...37100
C|  *  1   NSOP,NSOU,NOBS                                           *  | SUTRA_MAIN...37200
C|  *   IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR) *  | SUTRA_MAIN...37300
C|  *                                                               *  | SUTRA_MAIN...37400
C|  *****************************************************************  | SUTRA_MAIN...37500
C|_____________________________________________________________________| SUTRA_MAIN...37600
C                                                                        SUTRA_MAIN...37700
C.....INPUT DATASET 1:  OUTPUT HEADING                                   SUTRA_MAIN...37800
      ERRCOD = 'REA-INP-1'                                               SUTRA_MAIN...37900
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 SUTRA_MAIN...38000
c rbw begin change
      if (IErrorFlag.ne.0) then
        IERRORCODE = 146
        goto 1000
      endif
c rbw end change
      READ(INTFIL,117,IOSTAT=INERR(1)) TITLE1                            SUTRA_MAIN...38100
c rbw begin change
      !IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...38200
      IF (INERR(1).NE.0) then
        IERRORCODE = 1
        goto 1000
      endif
c rbw end change
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 SUTRA_MAIN...38300
c rbw begin change
      if (IErrorFlag.ne.0) then
        IERRORCODE = 147
        goto 1000
      endif
c rbw begin change
      READ(INTFIL,117,IOSTAT=INERR(1)) TITLE2                            SUTRA_MAIN...38400
c rbw end change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...38500
      IF (INERR(1).NE.0) then
        IERRORCODE = 2
        goto 1000
      endif
c rbw end change
  117 FORMAT(80A1)                                                       SUTRA_MAIN...38600
C                                                                        SUTRA_MAIN...38700
C.....INPUT DATASET 2A:  SIMULATION TYPE (TYPE OF TRANSPORT)             SUTRA_MAIN...38800
C        (SET ME=-1 FOR SOLUTE TRANSPORT, ME=+1 FOR ENERGY TRANSPORT)    SUTRA_MAIN...38900
      ERRCOD = 'REA-INP-2A'                                              SUTRA_MAIN...39000
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 SUTRA_MAIN...39100
c rbw begin change
      if (IErrorFlag.ne.0) then
        IERRORCODE = 148
        goto 1000
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) SIMSTR                              SUTRA_MAIN...39200
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...39300
      IF (INERR(1).NE.0) then
        IERRORCODE = 3
        goto 1000
      endif
c rbw end change
      CALL PRSWDS(SIMSTR, ' ', 5, SIMULA, NWORDS)                        SUTRA_MAIN...39400
c rbw begin change
!      IF(SIMULA(1).NE.'SUTRA     ') THEN                                 SUTRA_MAIN...39500
!!         ERRCOD = 'INP-2A-1'                                             SUTRA_MAIN...39600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...39700
!      END IF                                                             SUTRA_MAIN...39800
      IF(SIMULA(1).NE.'SUTRA     ') THEN
        IERRORCODE = 4
        goto 1000
      endif
c rbw end change
      IF (SIMULA(2).EQ.'VERSION   ') THEN                                SUTRA_MAIN...39900
         VERNIN = SIMULA(3)                                              SUTRA_MAIN...40000
         IF (VERNIN.EQ.'2D3D.1 ') THEN                                   SUTRA_MAIN...40100
            VERNIN = '2.0'                                               SUTRA_MAIN...40200
         ELSE IF ((VERNIN.NE.'2.0 ').AND.(VERNIN.NE.'2.1 ').AND.         SUTRA_MAIN...40300
     1            (VERNIN.NE.'2.2 ')) THEN                               SUTRA_MAIN...40400
c rbw begin change
            IERRORCODE = 5
            goto 1000
!            ERRCOD = 'INP-2A-4'                                          SUTRA_MAIN...40500
!            CHERR(1) = VERNIN                                            SUTRA_MAIN...40600
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...40700
c rbw end change
         END IF                                                          SUTRA_MAIN...40800
         IOFF = 2                                                        SUTRA_MAIN...40900
      ELSE                                                               SUTRA_MAIN...41000
         VERNIN = '2.0'                                                  SUTRA_MAIN...41100
         IOFF = 0                                                        SUTRA_MAIN...41200
      END IF                                                             SUTRA_MAIN...41300
      IF(SIMULA(2+IOFF).EQ.'SOLUTE    ') GOTO 120                        SUTRA_MAIN...41400
      IF(SIMULA(2+IOFF).EQ.'ENERGY    ') GOTO 140                        SUTRA_MAIN...41500
      IF (IOFF.EQ.0) THEN                                                SUTRA_MAIN...41600
         ERRCOD = 'INP-2A-2'                                             SUTRA_MAIN...41700
      ELSE                                                               SUTRA_MAIN...41800
         ERRCOD = 'INP-2A-3'                                             SUTRA_MAIN...41900
      END IF                                                             SUTRA_MAIN...42000
c rbw begin change
      IERRORCODE = 6
      goto 1000
!      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           SUTRA_MAIN...42100
c rbw end change
  120 ME=-1                                                              SUTRA_MAIN...42200
c rbw begin change
!      WRITE(K3,130)                                                      SUTRA_MAIN...42300
c rbw end change
  130 FORMAT('1'//132('*')///20X,'* * * * *   S U T R A   S O L U ',     SUTRA_MAIN...42400
     1   'T E   T R A N S P O R T   S I M U L A T I O N   * * * * *'//   SUTRA_MAIN...42500
     2   /132('*')/)                                                     SUTRA_MAIN...42600
      GOTO 160                                                           SUTRA_MAIN...42700
  140 ME=+1                                                              SUTRA_MAIN...42800
c rbw begin change
!      WRITE(K3,150)                                                      SUTRA_MAIN...42900
c rbw end change
  150 FORMAT('1'//132('*')///20X,'* * * * *   S U T R A   E N E R ',     SUTRA_MAIN...43000
     1   'G Y   T R A N S P O R T   S I M U L A T I O N   * * * * *'//   SUTRA_MAIN...43100
     2   /132('*')/)                                                     SUTRA_MAIN...43200
  160 CONTINUE                                                           SUTRA_MAIN...43300
C                                                                        SUTRA_MAIN...43400
C.....INPUT DATASET 2B:  MESH STRUCTURE                                  SUTRA_MAIN...43500
      ERRCOD = 'REA-INP-2B'                                              SUTRA_MAIN...43600
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 SUTRA_MAIN...43700
c rbw begin change
      if (IErrorFlag.ne.0) then
        IERRORCODE = 149
        goto 1000
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR                              SUTRA_MAIN...43800
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...43900
      IF (INERR(1).NE.0) then
        IERRORCODE = 7
        goto 1000
      endif
c rbw end change
      CALL PRSWDS(MSHSTR, ' ', 2, MSHTYP, NWORDS)                        SUTRA_MAIN...44000
C.....KTYPE SET ACCORDING TO THE TYPE OF FINITE-ELEMENT MESH:            SUTRA_MAIN...44100
C        2D MESH          ==>   KTYPE(1) = 2                             SUTRA_MAIN...44200
C        3D MESH          ==>   KTYPE(1) = 3                             SUTRA_MAIN...44300
C        IRREGULAR MESH   ==>   KTYPE(2) = 0                             SUTRA_MAIN...44400
C        LAYERED MESH     ==>   KTYPE(2) = 1                             SUTRA_MAIN...44500
C        REGULAR MESH     ==>   KTYPE(2) = 2                             SUTRA_MAIN...44600
C        BLOCKWISE MESH   ==>   KTYPE(2) = 3                             SUTRA_MAIN...44700
      IF (MSHTYP(1).EQ.'2D        ') THEN                                SUTRA_MAIN...44800
         KTYPE(1) = 2                                                    SUTRA_MAIN...44900
      ELSE IF (MSHTYP(1).EQ.'3D        ') THEN                           SUTRA_MAIN...45000
         KTYPE(1) = 3                                                    SUTRA_MAIN...45100
      ELSE                                                               SUTRA_MAIN...45200
c rbw begin change
        IERRORCODE = 8
        goto 1000
!         ERRCOD = 'INP-2B-1'                                             SUTRA_MAIN...45300
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...45400
c rbw end change
      END IF                                                             SUTRA_MAIN...45500
      IF ((MSHTYP(2).EQ.'REGULAR   ').OR.                                SUTRA_MAIN...45600
     1    (MSHTYP(2).EQ.'BLOCKWISE ')) THEN                              SUTRA_MAIN...45700
         ERRCOD = 'REA-INP-2B'                                           SUTRA_MAIN...45800
         IF (KTYPE(1).EQ.2) THEN                                         SUTRA_MAIN...45900
            READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR, NN1, NN2              SUTRA_MAIN...46000
            NN3 = 1                                                      SUTRA_MAIN...46100
         ELSE                                                            SUTRA_MAIN...46200
            READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR, NN1, NN2, NN3         SUTRA_MAIN...46300
         END IF                                                          SUTRA_MAIN...46400
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SUTRA_MAIN...46500
         IF (INERR(1).NE.0) then
           IERRORCODE = 8
           goto 1000
         endif
c rbw end change
         IF ((NN1.LT.2).OR.(NN2.LT.2).OR.                                SUTRA_MAIN...46600
     1      ((KTYPE(1).EQ.3).AND.(NN3.LT.2))) THEN                       SUTRA_MAIN...46700
c rbw begin change
            IERRORCODE = 9
            goto 1000
!            ERRCOD = 'INP-2B-3'                                          SUTRA_MAIN...46800
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...46900
c rbw end change
         END IF                                                          SUTRA_MAIN...47000
         IF (MSHTYP(2).EQ.'BLOCKWISE ') THEN                             SUTRA_MAIN...47100
            KTYPE(2) = 3                                                 SUTRA_MAIN...47200
            ERRCOD = 'REA-INP-2B'                                        SUTRA_MAIN...47300
            DO 177 I1=1,KTYPE(1)                                         SUTRA_MAIN...47400
               CALL READIF(K1, 0, INTFIL, ERRCOD)                        SUTRA_MAIN...47500
c rbw begin change
               if (IErrorFlag.ne.0) then
                 IERRORCODE = 150
                 goto 1000
               endif
c rbw end change
               READ(INTFIL,*,IOSTAT=INERR(1)) IDUM1, (IDUM2, I2=1,IDUM1) SUTRA_MAIN...47600
c rbw begin change
!               IF (INERR(1).NE.0) CALL SUTERR(ERRCOD,CHERR,INERR,RLERR)  SUTRA_MAIN...47700
               IF (INERR(1).NE.0) then
                 IERRORCODE = 9
                 goto 1000
               endif
c rbw end change
  177       CONTINUE                                                     SUTRA_MAIN...47800
         ELSE                                                            SUTRA_MAIN...47900
            KTYPE(2) = 2                                                 SUTRA_MAIN...48000
         END IF                                                          SUTRA_MAIN...48100
      ELSE IF (MSHTYP(2).EQ.'LAYERED   ') THEN                           SUTRA_MAIN...48200
         IF (KTYPE(1).EQ.2) THEN                                         SUTRA_MAIN...48300
c rbw begin change
            IERRORCODE = 10
            goto 1000
!            ERRCOD = 'INP-2B-5'                                          SUTRA_MAIN...48400
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...48500
c rbw end change
         END IF                                                          SUTRA_MAIN...48600
         KTYPE(2) = 1                                                    SUTRA_MAIN...48700
         ERRCOD = 'REA-INP-2B'                                           SUTRA_MAIN...48800
         READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR,NLAYS,NNLAY,NELAY,LAYSTR  SUTRA_MAIN...48900
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD,CHERR,INERR,RLERR)        SUTRA_MAIN...49000
         IF (INERR(1).NE.0) then
            IERRORCODE = 11
            goto 1000
         endif
c rbw end change
         CALL PRSWDS(LAYSTR, ' ', 1, LAYNOR, NWORDS)                     SUTRA_MAIN...49100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
         IF ((LAYNOR(1).NE.'ACROSS').AND.(LAYNOR(1).NE.'WITHIN')) THEN   SUTRA_MAIN...49200
c rbw begin change
            IERRORCODE = 12
            goto 1000
!            ERRCOD = 'INP-2B-6'                                          SUTRA_MAIN...49300
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...49400
c rbw end change
         END IF                                                          SUTRA_MAIN...49500
         IF ((NLAYS.LT.2).OR.(NNLAY.LT.4).OR.(NELAY.LT.1)) THEN          SUTRA_MAIN...49600
c rbw begin change
            IERRORCODE = 13
            goto 1000
!            ERRCOD = 'INP-2B-7'                                          SUTRA_MAIN...49700
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...49800
c rbw end change
         END IF                                                          SUTRA_MAIN...49900
      ELSE IF (MSHTYP(2).EQ.'IRREGULAR ') THEN                           SUTRA_MAIN...50000
         KTYPE(2) = 0                                                    SUTRA_MAIN...50100
      ELSE                                                               SUTRA_MAIN...50200
c rbw begin change
         IERRORCODE = 14
         goto 1000
!         ERRCOD = 'INP-2B-4'                                             SUTRA_MAIN...50300
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...50400
c rbw end change
      END IF                                                             SUTRA_MAIN...50500
C                                                                        SUTRA_MAIN...50600
C.....OUTPUT DATASET 1                                                   SUTRA_MAIN...50700
c rbw begin change
!      WRITE(K3,180) TITLE1,TITLE2                                        SUTRA_MAIN...50800
c rbw end change
  180 FORMAT(////1X,131('-')//26X,80A1//26X,80A1//1X,131('-'))           SUTRA_MAIN...50900
C                                                                        SUTRA_MAIN...51000
C.....OUTPUT FILE UNIT ASSIGNMENTS                                       SUTRA_MAIN...51100
c rbw begin change
!      WRITE(K3,200) IUNIT(1),FNINP,IUNIT(2),FNICS                        SUTRA_MAIN...51200
c rbw end change
  200 FORMAT(/////11X,'F I L E   U N I T   A S S I G N M E N T S'//      SUTRA_MAIN...51300
     1   13X,'INPUT UNITS:'/                                             SUTRA_MAIN...51400
     2   13X,' INP FILE (MAIN INPUT)          ',I7,4X,                   SUTRA_MAIN...51500
     3      'ASSIGNED TO ',A80/                                          SUTRA_MAIN...51600
     4   13X,' ICS FILE (INITIAL CONDITIONS)  ',I7,4X,                   SUTRA_MAIN...51700
     5      'ASSIGNED TO ',A80)                                          SUTRA_MAIN...51800
      IF(IUNIT(9).NE.-1) THEN                                            SUTRA_MAIN...51900
         DO 202 NFB=1,NFBCS                                              SUTRA_MAIN...52000
c rbw begin change
!            WRITE(K3,201) IUBCS(NFB),FNBCS(NFB)                          SUTRA_MAIN...52100
c rbw end change
  201       FORMAT(13X,' BCS FILE (TIME-VAR. BND. COND.)',I7,4X,         SUTRA_MAIN...52200
     1      'ASSIGNED TO ',A80)                                          SUTRA_MAIN...52300
  202    CONTINUE                                                        SUTRA_MAIN...52400
      END IF                                                             SUTRA_MAIN...52500
c rbw begin change
!      WRITE(K3,203) IUNIT(0),FNAME(0),IUNIT(3),FNAME(3)                  SUTRA_MAIN...52600
c rbw end change
  203 FORMAT(/                                                           SUTRA_MAIN...52700
     6   13X,'OUTPUT UNITS:'/                                            SUTRA_MAIN...52800
     7   13X,' SMY FILE (RUN SUMMARY)         ',I7,4X,                   SUTRA_MAIN...52900
     8      'ASSIGNED TO ',A80/                                          SUTRA_MAIN...53000
     9   13X,' LST FILE (GENERAL OUTPUT)      ',I7,4X,                   SUTRA_MAIN...53100
     T      'ASSIGNED TO ',A80)                                          SUTRA_MAIN...53200
c rbw begin change
!      IF(IUNIT(4).NE.-1) WRITE(K3,204) IUNIT(4),FNAME(4)                 SUTRA_MAIN...53300
c rbw end change
  204 FORMAT(13X,' RST FILE (RESTART DATA)        ',I7,4X,               SUTRA_MAIN...53400
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...53500
c rbw begin change
!      IF(IUNIT(5).NE.-1) WRITE(K3,205) IUNIT(5),FNAME(5)                 SUTRA_MAIN...53600
c rbw end change
  205 FORMAT(13X,' NOD FILE (NODEWISE OUTPUT)     ',I7,4X,               SUTRA_MAIN...53700
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...53800
c rbw begin change
!      IF(IUNIT(6).NE.-1) WRITE(K3,206) IUNIT(6),FNAME(6)                 SUTRA_MAIN...53900
c rbw end change
  206 FORMAT(13X,' ELE FILE (VELOCITY OUTPUT)     ',I7,4X,               SUTRA_MAIN...54000
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...54100
c rbw begin change
!      IF(IUNIT(7).NE.-1) WRITE(K3,207) IUNIT(7),                         SUTRA_MAIN...54200
!     1   TRIM(FNAME(7)) // " (BASE FILENAME)"                            SUTRA_MAIN...54300
c rbw end change
  207 FORMAT(13X,' OBS FILE (OBSERVATION OUTPUT) (',I7,')',3X,           SUTRA_MAIN...54400
     1   'ASSIGNED TO ',A)                                               SUTRA_MAIN...54500
c rbw begin change
!      IF(IUNIT(8).NE.-1) WRITE(K3,208) IUNIT(8),                         SUTRA_MAIN...54600
!     1   TRIM(FNAME(8)) // " (BASE FILENAME)"                            SUTRA_MAIN...54700
c rbw end change
  208 FORMAT(13X,' OBC FILE (OBSERVATION OUTPUT) (',I7,')',3X,           SUTRA_MAIN...54800
     1   'ASSIGNED TO ',A)                                               SUTRA_MAIN...54900
c rbw begin change
!      IF(IUNIT(10).NE.-1) WRITE(K3,209) IUNIT(10),FNAME(10)              SUTRA_MAIN...55000
c rbw end change
  209 FORMAT(13X,' BCOF FILE (BND. COND. OUTPUT)  ',I7,4X,               SUTRA_MAIN...55100
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...55200
c rbw begin change
!      IF(IUNIT(11).NE.-1) WRITE(K3,210) IUNIT(11),FNAME(11)              SUTRA_MAIN...55300
c rbw end change
  210 FORMAT(13X,' BCOS FILE (BND. COND. OUTPUT)  ',I7,4X,               SUTRA_MAIN...55400
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...55500
c rbw begin change
!      IF(IUNIT(12).NE.-1) WRITE(K3,211) IUNIT(12),FNAME(12)              SUTRA_MAIN...55600
c rbw end change
  211 FORMAT(13X,' BCOP FILE (BND. COND. OUTPUT)  ',I7,4X,               SUTRA_MAIN...55700
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...55800
c rbw begin change
!      IF(IUNIT(13).NE.-1) WRITE(K3,212) IUNIT(13),FNAME(13)              SUTRA_MAIN...55900
c rbw end change
  212 FORMAT(13X,' BCOU FILE (BND. COND. OUTPUT)  ',I7,4X,               SUTRA_MAIN...56000
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...56100
c rbw begin change
!      IF ((IUNIT(7).NE.-1).OR.(IUNIT(8).NE.-1)) WRITE(K3,213)            SUTRA_MAIN...56200
c rbw end change
  213 FORMAT(/14X,'NAMES FOR OBS AND OBC FILES WILL BE GENERATED',       SUTRA_MAIN...56300
     1   ' AUTOMATICALLY FROM THE BASE NAMES LISTED ABOVE AND SCHEDULE', SUTRA_MAIN...56400
     2   ' NAMES'/14X,'LISTED LATER IN THIS FILE.  UNIT NUMBERS',        SUTRA_MAIN...56500
     3   ' ASSIGNED TO THESE FILES WILL BE THE FIRST AVAILABLE',         SUTRA_MAIN...56600
     4   ' NUMBERS GREATER THAN'/14X,'OR EQUAL TO THE VALUES LISTED',    SUTRA_MAIN...56700
     5   ' ABOVE IN PARENTHESES.')                                       SUTRA_MAIN...56800
C                                                                        SUTRA_MAIN...56900
C.....INPUT DATASET 3:  SIMULATION CONTROL NUMBERS                       SUTRA_MAIN...57000
      ERRCOD = 'REA-INP-3'                                               SUTRA_MAIN...57100
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 SUTRA_MAIN...57200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = 151
           goto 1000
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS      SUTRA_MAIN...57300
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...57400
      IF (INERR(1).NE.0) then
         IERRORCODE = 14
         goto 1000
      endif
c rbw end change
c rbw begin
      NumNodes = NN
      NumElem = NE
      NPresB = NPBC
      NConcB = NUBC
c rbw end change
      IF (KTYPE(2).GT.1) THEN                                            SUTRA_MAIN...57500
         NN123 = NN1*NN2*NN3                                             SUTRA_MAIN...57600
         IF(NN123.NE.NN) THEN                                            SUTRA_MAIN...57700
c rbw begin change
           IERRORCODE = 15
           goto 1000
!           ERRCOD = 'INP-2B,3-1'                                         SUTRA_MAIN...57800
!           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...57900
c rbw end change
         END IF                                                          SUTRA_MAIN...58000
         IF (KTYPE(1).EQ.3) THEN                                         SUTRA_MAIN...58100
            NE123 = (NN1 - 1)*(NN2 - 1)*(NN3 - 1)                        SUTRA_MAIN...58200
         ELSE                                                            SUTRA_MAIN...58300
            NE123 = (NN1 - 1)*(NN2 - 1)                                  SUTRA_MAIN...58400
         END IF                                                          SUTRA_MAIN...58500
         IF(NE123.NE.NE) THEN                                            SUTRA_MAIN...58600
c rbw begin change
           IERRORCODE = 16
           goto 1000
!           ERRCOD = 'INP-2B,3-2'                                         SUTRA_MAIN...58700
!           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...58800
c rbw end change
         END IF                                                          SUTRA_MAIN...58900
      ELSE IF (MSHTYP(2).EQ.'LAYERED   ') THEN                           SUTRA_MAIN...59000
         NNTOT = NLAYS*NNLAY                                             SUTRA_MAIN...59100
         IF(NNTOT.NE.NN) THEN                                            SUTRA_MAIN...59200
c rbw begin change
           IERRORCODE = 17
           goto 1000
!           ERRCOD = 'INP-2B,3-3'                                         SUTRA_MAIN...59300
!           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...59400
c rbw end change
         END IF                                                          SUTRA_MAIN...59500
         NETOT = (NLAYS - 1)*NELAY                                       SUTRA_MAIN...59600
         IF(NETOT.NE.NE) THEN                                            SUTRA_MAIN...59700
c rbw begin change
           IERRORCODE = 17
           goto 1000
!           ERRCOD = 'INP-2B,3-4'                                         SUTRA_MAIN...59800
!           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...59900
c rbw end change
         END IF                                                          SUTRA_MAIN...60000
      ENDIF                                                              SUTRA_MAIN...60100
C                                                                        SUTRA_MAIN...60200
C.....INPUT AND OUTPUT DATASET 4:  SIMULATION MODE OPTIONS               SUTRA_MAIN...60300
      ERRCOD = 'REA-INP-4'                                               SUTRA_MAIN...60400
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 SUTRA_MAIN...60500
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = 152
           goto 1000
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) UNSSTR,SSFSTR,SSTSTR,RDSTR,ISTORE   SUTRA_MAIN...60600
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...60700
      IF (INERR(1).NE.0) then
           IERRORCODE = 18
           goto 1000
      endif
c rbw end change
      CALL PRSWDS(UNSSTR, ' ', 1, CUNSAT, NWORDS)                        SUTRA_MAIN...60800
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL PRSWDS(SSFSTR, ' ', 1, CSSFLO, NWORDS)                        SUTRA_MAIN...60900
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL PRSWDS(SSTSTR, ' ', 1, CSSTRA, NWORDS)                        SUTRA_MAIN...61000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL PRSWDS(RDSTR,  ' ', 1, CREAD,  NWORDS)                        SUTRA_MAIN...61100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      ISMERR = 0                                                         SUTRA_MAIN...61200
      IF (CUNSAT.EQ.'UNSATURATED') THEN                                  SUTRA_MAIN...61300
         IUNSAT = +1                                                     SUTRA_MAIN...61400
      ELSE IF (CUNSAT.EQ.'SATURATED') THEN                               SUTRA_MAIN...61500
         IUNSAT = 0                                                      SUTRA_MAIN...61600
      ELSE                                                               SUTRA_MAIN...61700
c rbw begin change
         IERRORCODE = 19
         goto 1000
!         ERRCOD = 'INP-4-1'                                              SUTRA_MAIN...61800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...61900
c rbw end change
      END IF                                                             SUTRA_MAIN...62000
      IF (CSSFLO.EQ.'TRANSIENT') THEN                                    SUTRA_MAIN...62100
         ISSFLO = 0                                                      SUTRA_MAIN...62200
      ELSE IF (CSSFLO.EQ.'STEADY') THEN                                  SUTRA_MAIN...62300
         ISSFLO = +1                                                     SUTRA_MAIN...62400
      ELSE                                                               SUTRA_MAIN...62500
c rbw begin change
         IERRORCODE = 20
         goto 1000
!         ERRCOD = 'INP-4-2'                                              SUTRA_MAIN...62600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...62700
c rbw end change
      END IF                                                             SUTRA_MAIN...62800
      IF (CSSTRA.EQ.'TRANSIENT') THEN                                    SUTRA_MAIN...62900
         ISSTRA = 0                                                      SUTRA_MAIN...63000
      ELSE IF (CSSTRA.EQ.'STEADY') THEN                                  SUTRA_MAIN...63100
         ISSTRA = +1                                                     SUTRA_MAIN...63200
      ELSE                                                               SUTRA_MAIN...63300
c rbw begin change
         IERRORCODE = 21
         goto 1000
!         ERRCOD = 'INP-4-3'                                              SUTRA_MAIN...63400
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...63500
c rbw end change
      END IF                                                             SUTRA_MAIN...63600
      IF (CREAD.EQ.'COLD') THEN                                          SUTRA_MAIN...63700
         IREAD = +1                                                      SUTRA_MAIN...63800
      ELSE IF (CREAD.EQ.'WARM') THEN                                     SUTRA_MAIN...63900
         IREAD = -1                                                      SUTRA_MAIN...64000
      ELSE                                                               SUTRA_MAIN...64100
c rbw begin change
         IERRORCODE = 22
         goto 1000
!         ERRCOD = 'INP-4-4'                                              SUTRA_MAIN...64200
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...64300
c rbw end change
      END IF                                                             SUTRA_MAIN...64400
c rbw begin change
!      WRITE(K3,214)                                                      SUTRA_MAIN...64500
c rbw end change
  214 FORMAT(////11X,'S I M U L A T I O N   M O D E   ',                 SUTRA_MAIN...64600
     1   'O P T I O N S'/)                                               SUTRA_MAIN...64700
      IF(ISSTRA.EQ.1.AND.ISSFLO.NE.1) THEN                               SUTRA_MAIN...64800
c rbw begin change
         IERRORCODE = 23
         goto 1000
!         ERRCOD = 'INP-4-5'                                              SUTRA_MAIN...64900
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...65000
c rbw end change
      ENDIF                                                              SUTRA_MAIN...65100
c rbw begin change
!      IF(IUNSAT.EQ.+1) WRITE(K3,215)                                     SUTRA_MAIN...65200
!      IF(IUNSAT.EQ.0) WRITE(K3,216)                                      SUTRA_MAIN...65300
c rbw end change
  215 FORMAT(11X,'- ALLOW UNSATURATED AND SATURATED FLOW:  UNSATURATED', SUTRA_MAIN...65400
     1   ' PROPERTIES ARE USER-PROGRAMMED IN SUBROUTINE   U N S A T')    SUTRA_MAIN...65500
  216 FORMAT(11X,'- ASSUME SATURATED FLOW ONLY')                         SUTRA_MAIN...65600
c rbw begin change
!      IF(ISSFLO.EQ.+1.AND.ME.EQ.-1) WRITE(K3,219)                        SUTRA_MAIN...65700
!      IF(ISSFLO.EQ.+1.AND.ME.EQ.+1) WRITE(K3,220)                        SUTRA_MAIN...65800
!      IF(ISSFLO.EQ.0) WRITE(K3,221)                                      SUTRA_MAIN...65900
c rbw end change
  219 FORMAT(11X,'- ASSUME STEADY-STATE FLOW FIELD CONSISTENT WITH ',    SUTRA_MAIN...66000
     1   'INITIAL CONCENTRATION CONDITIONS')                             SUTRA_MAIN...66100
  220 FORMAT(11X,'- ASSUME STEADY-STATE FLOW FIELD CONSISTENT WITH ',    SUTRA_MAIN...66200
     1   'INITIAL TEMPERATURE CONDITIONS')                               SUTRA_MAIN...66300
  221 FORMAT(11X,'- ALLOW TIME-DEPENDENT FLOW FIELD')                    SUTRA_MAIN...66400
c rbw begin change
!      IF(ISSTRA.EQ.+1) WRITE(K3,225)                                     SUTRA_MAIN...66500
!      IF(ISSTRA.EQ.0) WRITE(K3,226)                                      SUTRA_MAIN...66600
c rbw end change
  225 FORMAT(11X,'- ASSUME STEADY-STATE TRANSPORT')                      SUTRA_MAIN...66700
  226 FORMAT(11X,'- ALLOW TIME-DEPENDENT TRANSPORT')                     SUTRA_MAIN...66800
c rbw begin change
!      IF(IREAD.EQ.-1) WRITE(K3,230)                                      SUTRA_MAIN...66900
!      IF(IREAD.EQ.+1) WRITE(K3,231)                                      SUTRA_MAIN...67000
c rbw end change
  230 FORMAT(11X,'- WARM START - SIMULATION IS TO BE ',                  SUTRA_MAIN...67100
     1   'CONTINUED FROM PREVIOUSLY-STORED DATA')                        SUTRA_MAIN...67200
  231 FORMAT(11X,'- COLD START - BEGIN NEW SIMULATION')                  SUTRA_MAIN...67300
c rbw begin change
!      IF(ISTORE.GT.0) WRITE(K3,240) ISTORE                               SUTRA_MAIN...67400
!      IF(ISTORE.EQ.0) WRITE(K3,241)                                      SUTRA_MAIN...67500
c rbw end change
  240 FORMAT(11X,'- STORE RESULTS AFTER EVERY',I9,' TIME STEPS IN',      SUTRA_MAIN...67600
     1   ' RESTART FILE AS BACKUP AND FOR USE IN A SIMULATION RESTART')  SUTRA_MAIN...67700
  241 FORMAT(11X,'- DO NOT STORE RESULTS FOR USE IN A',                  SUTRA_MAIN...67800
     1   ' RESTART OF SIMULATION')                                       SUTRA_MAIN...67900
C.....OUTPUT DATASET 3                                                   SUTRA_MAIN...68000
c rbw begin change
!      IF(ME.EQ.-1)                                                       SUTRA_MAIN...68100
!     1   WRITE(K3,245) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS                    SUTRA_MAIN...68200
c rbw end change
  245 FORMAT(////11X,'S I M U L A T I O N   C O N T R O L   ',           SUTRA_MAIN...68300
     1   'N U M B E R S'// 8X,I9,5X,'NUMBER OF NODES IN FINITE-',        SUTRA_MAIN...68400
     2   'ELEMENT MESH'/ 8X,I9,5X,'NUMBER OF ELEMENTS IN MESH'//         SUTRA_MAIN...68500
     3    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...68600
     4   'PRESSURE IS A SPECIFIED CONSTANT OR FUNCTION OF TIME'/         SUTRA_MAIN...68700
     5    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...68800
     6   'SOLUTE CONCENTRATION IS A SPECIFIED CONSTANT OR ',             SUTRA_MAIN...68900
     7   'FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES AT',       SUTRA_MAIN...69000
     8   ' WHICH FLUID INFLOW OR OUTFLOW IS A SPECIFIED CONSTANT',       SUTRA_MAIN...69100
     9   ' OR FUNCTION OF TIME'/ 8X,I9,5X,'EXACT NUMBER OF NODES AT',    SUTRA_MAIN...69200
     A   ' WHICH A SOURCE OR SINK OF SOLUTE MASS IS A SPECIFIED ',       SUTRA_MAIN...69300
     B   'CONSTANT OR FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF ',   SUTRA_MAIN...69400
     C   'NODES AT WHICH PRESSURE AND CONCENTRATION WILL BE OBSERVED')   SUTRA_MAIN...69500
C                                                                        SUTRA_MAIN...69600
c rbw begin change
!      IF(ME.EQ.+1)                                                       SUTRA_MAIN...69700
!     1    WRITE(K3,247) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS                   SUTRA_MAIN...69800
c rbw end change
  247 FORMAT(////11X,'S I M U L A T I O N   C O N T R O L   ',           SUTRA_MAIN...69900
     1   'N U M B E R S'// 8X,I9,5X,'NUMBER OF NODES IN FINITE-',        SUTRA_MAIN...70000
     2   'ELEMENT MESH'/ 8X,I9,5X,'NUMBER OF ELEMENTS IN MESH'//         SUTRA_MAIN...70100
     3    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...70200
     4   'PRESSURE IS A SPECIFIED CONSTANT OR FUNCTION OF TIME'/         SUTRA_MAIN...70300
     5    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...70400
     6   'TEMPERATURE IS A SPECIFIED CONSTANT OR ',                      SUTRA_MAIN...70500
     7   'FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES AT',       SUTRA_MAIN...70600
     8   ' WHICH FLUID INFLOW OR OUTFLOW IS A SPECIFIED CONSTANT',       SUTRA_MAIN...70700
     9   ' OR FUNCTION OF TIME'/ 8X,I9,5X,'EXACT NUMBER OF NODES AT',    SUTRA_MAIN...70800
     A   ' WHICH A SOURCE OR SINK OF ENERGY IS A SPECIFIED CONSTANT',    SUTRA_MAIN...70900
     B   ' OR FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES ',     SUTRA_MAIN...71000
     C   'AT WHICH PRESSURE AND TEMPERATURE WILL BE OBSERVED')           SUTRA_MAIN...71100
C                                                                        SUTRA_MAIN...71200
C.....INPUT DATASETS 5 - 7 (NUMERICAL, TEMPORAL, AND ITERATION CONTROLS) SUTRA_MAIN...71300
      CALL INDAT0()                                                      SUTRA_MAIN...71400
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C.....KSOLVP AND KSOLVU HAVE BEEN SET ACCORDING TO THE SOLVERS SELECTED: SUTRA_MAIN...71500
C        BANDED GAUSSIAN ELIMINATION (DIRECT)   ==>   0                  SUTRA_MAIN...71600
C        IC-PRECONDITIONED CG                   ==>   1                  SUTRA_MAIN...71700
C        ILU-PRECONDITIONED GMRES               ==>   2                  SUTRA_MAIN...71800
C        ILU-PRECONDITIONED ORTHOMIN            ==>   3                  SUTRA_MAIN...71900
C                                                                        SUTRA_MAIN...72000
C.....OUTPUT DATASETS 7B & 7C                                            SUTRA_MAIN...72100
c rbw begin change
!      WRITE(K3,261)                                                      SUTRA_MAIN...72200
c rbw end change
  261 FORMAT(////11X,'S O L V E R - R E L A T E D   ',                   SUTRA_MAIN...72300
     1   'P A R A M E T E R S')                                          SUTRA_MAIN...72400
C.....OUTPUT DATASETS 3B & 3C                                            SUTRA_MAIN...72500
  266 IF (KSOLVP.NE.0) THEN                                              SUTRA_MAIN...72600
c rbw begin change
!         WRITE(K3,268)                                                   SUTRA_MAIN...72700
!     1      SOLNAM(KSOLVP), ITRMXP, TOLP,                                SUTRA_MAIN...72800
!     2      SOLNAM(KSOLVU), ITRMXU, TOLU                                 SUTRA_MAIN...72900
c rbw end change
  268    FORMAT(                                                         SUTRA_MAIN...73000
     1      /13X,'SOLVER FOR P: ',A40                                    SUTRA_MAIN...73100
     2      //20X,I6,5X,'MAXIMUM NUMBER OF MATRIX SOLVER ITERATIONS',    SUTRA_MAIN...73200
     3           ' DURING P SOLUTION'                                    SUTRA_MAIN...73300
     4      /11X,1PE15.4,5X,'CONVERGENCE TOLERANCE FOR MATRIX',          SUTRA_MAIN...73400
     5           ' SOLVER ITERATIONS DURING P SOLUTION'                  SUTRA_MAIN...73500
     6      //13X,'SOLVER FOR U: ',A40                                   SUTRA_MAIN...73600
     7      //20X,I6,5X,'MAXIMUM NUMBER OF MATRIX SOLVER ITERATIONS',    SUTRA_MAIN...73700
     8           ' DURING U SOLUTION'                                    SUTRA_MAIN...73800
     9      /11X,1PE15.4,5X,'CONVERGENCE TOLERANCE FOR MATRIX',          SUTRA_MAIN...73900
     A           ' SOLVER ITERATIONS DURING U SOLUTION' )                SUTRA_MAIN...74000
      ELSE                                                               SUTRA_MAIN...74100
c rbw begin change
!         WRITE(K3,269) SOLNAM(KSOLVP)                                    SUTRA_MAIN...74200
c rbw end change
  269    FORMAT(/13X,'SOLVER FOR P AND U: ',A40)                         SUTRA_MAIN...74300
      END IF                                                             SUTRA_MAIN...74400
C                                                                        SUTRA_MAIN...74500
C.....CALCULATE ARRAY DIMENSIONS, EXCEPT THOSE THAT DEPEND ON            SUTRA_MAIN...74600
C        BANDWIDTH OR NELT                                               SUTRA_MAIN...74700
C                                                                        SUTRA_MAIN...74800
      IF (KSOLVP.EQ.0) THEN                                              SUTRA_MAIN...74900
C........SET DIMENSIONS FOR DIRECT SOLVER                                SUTRA_MAIN...75000
         NNNX = 1                                                        SUTRA_MAIN...75100
         NDIMJA = 1                                                      SUTRA_MAIN...75200
         NNVEC = NN                                                      SUTRA_MAIN...75300
      ELSE                                                               SUTRA_MAIN...75400
C........SET DIMENSIONS FOR ITERATIVE SOLVER(S)                          SUTRA_MAIN...75500
         NNNX = NN                                                       SUTRA_MAIN...75600
         NDIMJA = NN + 1                                                 SUTRA_MAIN...75700
         NNVEC = NN                                                      SUTRA_MAIN...75800
      END IF                                                             SUTRA_MAIN...75900
      NBCN=NPBC+NUBC+1                                                   SUTRA_MAIN...76000
      NSOP=NSOP+1                                                        SUTRA_MAIN...76100
      NSOU=NSOU+1                                                        SUTRA_MAIN...76200
      NOBSN=NOBS+1                                                       SUTRA_MAIN...76300
      IF (KTYPE(1).EQ.3) THEN                                            SUTRA_MAIN...76400
         N48 = 8                                                         SUTRA_MAIN...76500
         NEX = NE                                                        SUTRA_MAIN...76600
      ELSE                                                               SUTRA_MAIN...76700
         N48 = 4                                                         SUTRA_MAIN...76800
         NEX = 1                                                         SUTRA_MAIN...76900
      END IF                                                             SUTRA_MAIN...77000
      NIN=NE*N48                                                         SUTRA_MAIN...77100
C                                                                        SUTRA_MAIN...77200
C.....ALLOCATE REAL ARRAYS, EXCEPT THOSE THAT DEPEND ON BANDWIDTH        SUTRA_MAIN...77300
      ALLOCATE(PITER(NN),UITER(NN),PM1(NN),DPDTITR(NN),UM1(NN),UM2(NN),  SUTRA_MAIN...77400
     1   PVEL(NN),SL(NN),SR(NN),X(NN),Y(NN),Z(NN),VOL(NN),POR(NN),       SUTRA_MAIN...77500
     2   CS1(NN),CS2(NN),CS3(NN),SW(NN),DSWDP(NN),RHO(NN),SOP(NN),       SUTRA_MAIN...77600
     3   QIN(NN),UIN(NN),QUIN(NN),QINITR(NN),RCIT(NN),RCITM1(NN))        SUTRA_MAIN...77700
      ALLOCATE(PVEC(NNVEC),UVEC(NNVEC))                                  SUTRA_MAIN...77800
      ALLOCATE(ALMAX(NE),ALMIN(NE),ATMAX(NE),ATMIN(NE),VMAG(NE),         SUTRA_MAIN...77900
     1   VANG1(NE),PERMXX(NE),PERMXY(NE),PERMYX(NE),PERMYY(NE),          SUTRA_MAIN...78000
     2   PANGL1(NE))                                                     SUTRA_MAIN...78100
      ALLOCATE(ALMID(NEX),ATMID(NEX),                                    SUTRA_MAIN...78200
     1   VANG2(NEX),PERMXZ(NEX),PERMYZ(NEX),PERMZX(NEX),                 SUTRA_MAIN...78300
     2   PERMZY(NEX),PERMZZ(NEX),PANGL2(NEX),PANGL3(NEX))                SUTRA_MAIN...78400
      ALLOCATE(PBC(NBCN),UBC(NBCN),QPLITR(NBCN),GNUP1(NBCN),GNUU1(NBCN)) SUTRA_MAIN...78500
      ALLOCATE(GXSI(NE,N48),GETA(NE,N48),GZET(NEX,N48))                  SUTRA_MAIN...78600
      ALLOCATE(B(NNNX))                                                  SUTRA_MAIN...78700
C.....ALLOCATE INTEGER ARRAYS, EXCEPT THOSE THAT DEPEND ON BANDWIDTH     SUTRA_MAIN...78800
C        OR NELT                                                         SUTRA_MAIN...78900
      ALLOCATE(IN(NIN),IQSOP(NSOP),IQSOU(NSOU),IPBC(NBCN),IUBC(NBCN),    SUTRA_MAIN...79000
     1   NREG(NN),LREG(NE),JA(NDIMJA))                                   SUTRA_MAIN...79100
      ALLOCATE(IIDPBC(NBCN),IIDUBC(NBCN),IIDSOP(NSOP),IIDSOU(NSOU))      SUTRA_MAIN...79200
C.....ALLOCATE INTEGER(1) ARRAYS, EXCEPT THOSE THAT DEPEND ON BANDWIDTH  SUTRA_MAIN...79300
C        OR NELT                                                         SUTRA_MAIN...79400
      ALLOCATE(IBCPBC(NBCN),IBCUBC(NBCN),IBCSOP(NSOP),IBCSOU(NSOU))      SUTRA_MAIN...79500
C.....ALLOCATE ARRAYS OF DERIVED TYPE, EXCEPT THOSE THAT DEPEND ON       SUTRA_MAIN...79600
C        BANDWIDTH OR NELT                                               SUTRA_MAIN...79700
      ALLOCATE(BCSFL(0:ITMAX),BCSTR(0:ITMAX))                            SUTRA_MAIN...79800
C.....ALLOCATE ARRAYS OF DERIVED TYPE, EXCEPT THOSE THAT DEPEND ON       SUTRA_MAIN...79900
C        BANDWIDTH OR NELT                                               SUTRA_MAIN...80000
      ALLOCATE(OBSPTS(NOBSN))                                            SUTRA_MAIN...80100
      ALLO1 = .TRUE.                                                     SUTRA_MAIN...80200
C                                                                        SUTRA_MAIN...80300
C.....INPUT DATASETS 8 - 15 (OUTPUT CONTROLS; FLUID AND SOLID MATRIX     SUTRA_MAIN...80400
C        PROPERTIES; ADSORPTION PARAMETERS; PRODUCTION OF ENERGY OR      SUTRA_MAIN...80500
C        SOLUTE MASS; GRAVITY; AND NODEWISE AND ELEMENTWISE DATA)        SUTRA_MAIN...80600
c rbw begin change
!      CALL INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,         SUTRA_MAIN...80700
!     1   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,                      SUTRA_MAIN...80800
!     2   PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG,        SUTRA_MAIN...80900
!     3   OBSPTS)                                                         SUTRA_MAIN...81000
      CALL INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,         SUTRA_MAIN...80700
     1   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,                      SUTRA_MAIN...80800
     2   PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG,        SUTRA_MAIN...80900
     3   OBSPTS, InputFile)                                                         SUTRA_MAIN...81000
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...81100
C.....KEEP TRACK IF OUTPUT ROUTINES HAVE BEEN EXECUTED, TO PRINT         SUTRA_MAIN...81200
C        HEADERS ONLY ONCE.                                              SUTRA_MAIN...81300
      ONCEK5 = .FALSE.                                                   SUTRA_MAIN...81400
      ONCEK6 = .FALSE.                                                   SUTRA_MAIN...81500
      ONCEK7 = .FALSE.                                                   SUTRA_MAIN...81600
      ONCEK8 = .FALSE.                                                   SUTRA_MAIN...81700
      ALLOCATE(ONCK78(NFLOMX))                                           SUTRA_MAIN...81800
      DO 400 J=1,NFLOMX                                                  SUTRA_MAIN...81900
         ONCK78(J) = .FALSE.                                             SUTRA_MAIN...82000
  400 CONTINUE                                                           SUTRA_MAIN...82100
      ONCEK10 = .FALSE.                                                  SUTRA_MAIN...82200
      ONCEK11 = .FALSE.                                                  SUTRA_MAIN...82300
      ONCEK12 = .FALSE.                                                  SUTRA_MAIN...82400
      ONCEK13 = .FALSE.                                                  SUTRA_MAIN...82500
C                                                                        SUTRA_MAIN...82600
C.....INITIALIZE BCTIME CONDITION FLAGS                                  SUTRA_MAIN...82610
      IQSOPT = 1                                                         SUTRA_MAIN...82620
      IQSOUT = 1                                                         SUTRA_MAIN...82630
      IPBCT = 1                                                          SUTRA_MAIN...82640
      IUBCT = 1                                                          SUTRA_MAIN...82650
C                                                                        SUTRA_MAIN...82600
C.....INPUT DATASETS 17 & 18 (SOURCES OF FLUID MASS AND ENERGY OR        SUTRA_MAIN...82700
C        SOLUTE MASS)                                                    SUTRA_MAIN...82800
      CALL ZERO(QIN,NN,0.0D0)                                            SUTRA_MAIN...82900
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL ZERO(UIN,NN,0.0D0)                                            SUTRA_MAIN...83000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL ZERO(QUIN,NN,0.0D0)                                           SUTRA_MAIN...83100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      IF(NSOP-1.GT.0.OR.NSOU-1.GT.0)                                     SUTRA_MAIN...83200
     1   CALL SOURCE(QIN,UIN,IQSOP,QUIN,IQSOU,IQSOPT,IQSOUT,             SUTRA_MAIN...83300
     2      IBCSOP,IBCSOU)                                               SUTRA_MAIN...83400
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...83500
C.....INPUT DATASETS 19 & 20 (SPECIFIED P AND U BOUNDARY CONDITIONS)     SUTRA_MAIN...83600
      IF(NBCN-1.GT.0) CALL BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT,          SUTRA_MAIN...83700
     1   IBCPBC,IBCUBC,GNUP1,GNUU1)                                      SUTRA_MAIN...83800
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...83900
C.....INPUT DATASET 22 (ELEMENT INCIDENCE [MESH CONNECTION] DATA)        SUTRA_MAIN...84000
      CALL CONNEC(IN)                                                    SUTRA_MAIN...84100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...84200
C.....IF USING OLD (VERSION 2D3D.1) OBSERVATION INPUT FORMAT, LOOK UP    SUTRA_MAIN...84300
C        COORDINATES FOR OBSERVATION POINTS (NODES).                     SUTRA_MAIN...84400
      IF (NOBCYC.NE.-1) THEN                                             SUTRA_MAIN...84500
         DO 710 K=1,NOBS                                                 SUTRA_MAIN...84600
            I = OBSPTS(K)%L                                              SUTRA_MAIN...84700
            OBSPTS(K)%X = X(I)                                           SUTRA_MAIN...84800
            OBSPTS(K)%Y = Y(I)                                           SUTRA_MAIN...84900
            IF (N48.EQ.8) OBSPTS(K)%Z = Z(I)                             SUTRA_MAIN...85000
  710    CONTINUE                                                        SUTRA_MAIN...85100
      END IF                                                             SUTRA_MAIN...85200
C                                                                        SUTRA_MAIN...85300
C.....FIND THE ELEMENT EACH OBSERVATION POINT IS IN.  IN COMPONENTS OF   SUTRA_MAIN...85400
C        OBSPTS, OVERWRITE NODE NUMBERS AND GLOBAL COORDINATES WITH      SUTRA_MAIN...85500
C        ELEMENT NUMBERS AND LOCAL COORDINATES.                          SUTRA_MAIN...85600
      DO 900 K=1,NOBS                                                    SUTRA_MAIN...85700
         XK = OBSPTS(K)%X                                                SUTRA_MAIN...85800
         YK = OBSPTS(K)%Y                                                SUTRA_MAIN...85900
         IF (N48.EQ.8) ZK = OBSPTS(K)%Z                                  SUTRA_MAIN...86000
         DO 800 LL=1,NE                                                  SUTRA_MAIN...86100
            IF (N48.EQ.8) THEN                                           SUTRA_MAIN...86200
               CALL FINDL3(X,Y,Z,IN,LL,XK,YK,ZK,XSI,ETA,ZET,INOUT)       SUTRA_MAIN...86300
c rbw begin change
               if (IErrorFlag.ne.0) then
                 IERRORCODE = IErrorFlag
                 goto 1000
               endif
c rbw end change
            ELSE                                                         SUTRA_MAIN...86400
               CALL FINDL2(X,Y,IN,LL,XK,YK,XSI,ETA,INOUT)                SUTRA_MAIN...86500
c rbw begin change
               if (IErrorFlag.ne.0) then
                 IERRORCODE = IErrorFlag
                 goto 1000
               endif
c rbw end change
            END IF                                                       SUTRA_MAIN...86600
            IF (INOUT.EQ.1) THEN                                         SUTRA_MAIN...86700
               L = LL                                                    SUTRA_MAIN...86800
               GOTO 820                                                  SUTRA_MAIN...86900
            END IF                                                       SUTRA_MAIN...87000
  800    CONTINUE                                                        SUTRA_MAIN...87100
         ERRCOD = 'INP-8D-3'                                             SUTRA_MAIN...87200
         CHERR(1) = OBSPTS(K)%NAME                                       SUTRA_MAIN...87300
c rbw begin change
!         WRITE(UNIT=CHERR(2), FMT=805)                                   SUTRA_MAIN...87400
!     1      OBSPTS(K)%X, OBSPTS(K)%Y, OBSPTS(K)%Z                        SUTRA_MAIN...87500
c rbw end change
  805    FORMAT('(',2(1PE14.7,','),1PE14.7,')')                          SUTRA_MAIN...87600
c rbw begin change
         IERRORCODE = 24
         goto 1000
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...87700
c rbw end change
  820    OBSPTS(K)%L = L                                                 SUTRA_MAIN...87800
         OBSPTS(K)%XSI = XSI                                             SUTRA_MAIN...87900
         OBSPTS(K)%ETA = ETA                                             SUTRA_MAIN...88000
         IF (N48.EQ.8) OBSPTS(K)%ZET = ZET                               SUTRA_MAIN...88100
  900 CONTINUE                                                           SUTRA_MAIN...88200
C                                                                        SUTRA_MAIN...88300
C.....IF ITERATIVE SOLVER IS USED, SET UP POINTER ARRAYS IA AND JA THAT  SUTRA_MAIN...88400
C        SPECIFY MATRIX STRUCTURE IN "SLAP COLUMN" FORMAT.  DIMENSION    SUTRA_MAIN...88500
C        NELT GETS SET HERE.                                             SUTRA_MAIN...88600
      IF (KSOLVP.NE.0) THEN                                              SUTRA_MAIN...88700
         CALL PTRSET()                                                   SUTRA_MAIN...88800
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      ELSE                                                               SUTRA_MAIN...88900
         NELT = NN                                                       SUTRA_MAIN...89000
         NDIMIA = 1                                                      SUTRA_MAIN...89100
         ALLOCATE(IA(NDIMIA))                                            SUTRA_MAIN...89200
      END IF                                                             SUTRA_MAIN...89300
      ALLO3 = .TRUE.                                                     SUTRA_MAIN...89400
C                                                                        SUTRA_MAIN...89500
C.....CALCULATE BANDWIDTH                                                SUTRA_MAIN...89600
      CALL BANWID(IN)                                                    SUTRA_MAIN...89700
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...89800
C.....CALCULATE ARRAY DIMENSIONS THAT DEPEND ON BANDWIDTH OR NELT        SUTRA_MAIN...89900
      IF (KSOLVP.EQ.0) THEN                                              SUTRA_MAIN...90000
C........SET DIMENSIONS FOR DIRECT SOLVER                                SUTRA_MAIN...90100
         NCBI = NBI                                                      SUTRA_MAIN...90200
         NELTA = NELT                                                    SUTRA_MAIN...90300
         NWI = 1                                                         SUTRA_MAIN...90400
         NWF = 1                                                         SUTRA_MAIN...90500
      ELSE                                                               SUTRA_MAIN...90600
C........SET DIMENSIONS FOR ITERATIVE SOLVER(S)                          SUTRA_MAIN...90700
         NCBI = 1                                                        SUTRA_MAIN...90800
         NELTA = NELT                                                    SUTRA_MAIN...90900
         KSOLVR = KSOLVP                                                 SUTRA_MAIN...91000
         NSAVE = NSAVEP                                                  SUTRA_MAIN...91100
         CALL DIMWRK(KSOLVR, NSAVE, NN, NELTA, NWIP, NWFP)               SUTRA_MAIN...91200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
         KSOLVR = KSOLVU                                                 SUTRA_MAIN...91300
         NSAVE = NSAVEU                                                  SUTRA_MAIN...91400
         CALL DIMWRK(KSOLVR, NSAVE, NN, NELTA, NWIU, NWFU)               SUTRA_MAIN...91500
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
         NWI = MAX(NWIP, NWIU)                                           SUTRA_MAIN...91600
         NWF = MAX(NWFP, NWFU)                                           SUTRA_MAIN...91700
      END IF                                                             SUTRA_MAIN...91800
      MATDIM=NELT*NCBI                                                   SUTRA_MAIN...91900
C                                                                        SUTRA_MAIN...92000
C.....ALLOCATE REAL AND INTEGER ARRAYS THAT DEPEND ON BANDWIDTH OR NELT  SUTRA_MAIN...92100
      ALLOCATE(PMAT(NELT,NCBI),UMAT(NELT,NCBI),FWK(NWF))                 SUTRA_MAIN...92200
      ALLOCATE(IWK(NWI))                                                 SUTRA_MAIN...92300
      ALLO2 = .TRUE.                                                     SUTRA_MAIN...92400
C                                                                        SUTRA_MAIN...92500
C.....READ BCS SCHEDULES AND CHECK BCS BOUNDARY CONDITIONS FOR           SUTRA_MAIN...92600
C        INPUT ERRORS.  DETERMINE SIZE OF BCS IDENTIFIER ARRAY.          SUTRA_MAIN...92700
      NCIDB = 1                                                          SUTRA_MAIN...92800
      ALLOCATE(CIDBCS(NCIDB))                                            SUTRA_MAIN...92900
      IF (K9.NE.-1) THEN                                                 SUTRA_MAIN...93000
C........SET UP ARRAY OF SCHEDULE NUMBERS, BCP                           SUTRA_MAIN...93100
         ALLOCATE (BFP(NFBCS))                                           SUTRA_MAIN...93200
         DO 2100 NFB=1,NFBCS                                             SUTRA_MAIN...93300
            K9 = IUNIB(NFB)                                              SUTRA_MAIN...93400
C...........SET FNAME(9) EQUAL TO FNAMB(NFB) FOR CONVENIENCE IN          SUTRA_MAIN...93500
C              ERROR HANDLING                                            SUTRA_MAIN...93600
            FNAME(9) = FNAMB(NFB)                                        SUTRA_MAIN...93700
C...........READ SCHEDULE NAME FOR CURRENT BCS FILE.                     SUTRA_MAIN...93800
            ERRCOD = 'REA-BCS-1'                                         SUTRA_MAIN...93900
            CHERR(1) = 'n/a'                                             SUTRA_MAIN...94000
            CHERR(2) = 'n/a'                                             SUTRA_MAIN...94100
            CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)                  SUTRA_MAIN...94200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = 151
           goto 1000
         endif
c rbw end change
            READ(INTFIL,*,IOSTAT=INERR(1)) CDUM80                        SUTRA_MAIN...94300
            IF (LEN_TRIM(CDUM80).GT.10) THEN                             SUTRA_MAIN...94400
c rbw begin change
!               ERRCOD = 'BCS-1-4'                                        SUTRA_MAIN...94500
!               CHERR(1) = CDUM80                                         SUTRA_MAIN...94600
!               CHERR(2) = FNAME(9)                                       SUTRA_MAIN...94700
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  SUTRA_MAIN...94800
         IERRORCODE = 14
         goto 1000
c rbw end change
            END IF                                                       SUTRA_MAIN...94900
            READ(INTFIL,*,IOSTAT=INERR(1)) BCSSCH                        SUTRA_MAIN...95000
c rbw begin change
!            IF (INERR(1).NE.0)                                           SUTRA_MAIN...95100
!     1            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               SUTRA_MAIN...95200
      IF (INERR(1).NE.0) then
         IERRORCODE = 14
         goto 1000
      endif
c rbw end change
C...........FIND SCHEDULE NUMBER IN LIST.  IF NOT FOUND, ERROR.          SUTRA_MAIN...95300
            DO 2050 NS=1,NSCH                                            SUTRA_MAIN...95400
               IF (BCSSCH.EQ.SCHDLS(NS)%NAME) THEN                       SUTRA_MAIN...95500
                  BFP(NFB)%ISCHED = NS                                   SUTRA_MAIN...95600
                  DENB => SCHDLS(BFP(NFB)%ISCHED)%SLIST                  SUTRA_MAIN...95700
                  LENSCH = SCHDLS(BFP(NFB)%ISCHED)%LLEN                  SUTRA_MAIN...95800
                  DO 2000 LC=1,LENSCH                                    SUTRA_MAIN...95900
                     DITBCS = DENB%DVALU2                                SUTRA_MAIN...96000
                     ITBCS = INT(DITBCS)                                 SUTRA_MAIN...96100
                     IF (DBLE(ITBCS).NE.DITBCS) THEN                     SUTRA_MAIN...96200
                        ERRCOD = 'BCS-1-2'                               SUTRA_MAIN...96300
                        CHERR(1) = BCSSCH                                SUTRA_MAIN...96400
                        CHERR(2) = FNAME(9)                              SUTRA_MAIN...96500
                        RLERR(1) = DITBCS                                SUTRA_MAIN...96600
c rbw begin change
         IERRORCODE = 14
         goto 1000
!                        CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)         SUTRA_MAIN...96700
c rbw end change
                     END IF                                              SUTRA_MAIN...96800
                     IF (LC.LT.LENSCH) DENB => DENB%NENT                 SUTRA_MAIN...96900
 2000             CONTINUE                                               SUTRA_MAIN...97000
                  GOTO 2100                                              SUTRA_MAIN...97100
               END IF                                                    SUTRA_MAIN...97200
 2050       CONTINUE                                                     SUTRA_MAIN...97300
            IF (ISSTRA.NE.1) THEN                                        SUTRA_MAIN...97400
               ERRCOD = 'BCS-1-1'                                        SUTRA_MAIN...97500
            ELSE                                                         SUTRA_MAIN...97600
               ERRCOD = 'BCS-1-3'                                        SUTRA_MAIN...97700
            END IF                                                       SUTRA_MAIN...97800
            CHERR(1) = BCSSCH                                            SUTRA_MAIN...97900
            CHERR(2) = FNAME(9)                                          SUTRA_MAIN...98000
c rbw begin change
         IERRORCODE = 14
         goto 1000
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...98100
c rbw end change
 2100    CONTINUE                                                        SUTRA_MAIN...98200
C........READ THROUGH FILES TO SEARCH FOR INPUT ERRORS, BUT DO NOT       SUTRA_MAIN...98300
C           ACTUALLY SET THE BOUNDARY CONDITIONS (SETBCS = .FALSE.)      SUTRA_MAIN...98400
         SETBCS = .FALSE.                                                SUTRA_MAIN...98500
         DENB => SCHDLS(ISCHTS)%SLIST                                    SUTRA_MAIN...98600
         LENSCH = SCHDLS(ISCHTS)%LLEN                                    SUTRA_MAIN...98700
         DO 2200 LC=1,LENSCH                                             SUTRA_MAIN...98800
            DITBCS = DENB%DVALU2                                         SUTRA_MAIN...98900
            ITBCS = INT(DITBCS)                                          SUTRA_MAIN...99000
            CALL BCSTEP(SETBCS,IPBC,PBC,IUBC,UBC,QIN,UIN,QUIN,IQSOP,     SUTRA_MAIN...99100
     1         IQSOU,IPBCT1,IUBCT1,IQSOPT1,IQSOUT1,GNUP1,GNUU1,          SUTRA_MAIN...99200
     2         IBCPBC,IBCUBC,IBCSOP,IBCSOU,IIDPBC,IIDUBC,IIDSOP,         SUTRA_MAIN...99300
     3         IIDSOU,NCID,BCSFL,BCSTR)                                  SUTRA_MAIN...99400
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
            NCIDB = MAX(NCIDB, NCID)                                     SUTRA_MAIN...99500
            IF (LC.LT.LENSCH) DENB => DENB%NENT                          SUTRA_MAIN...99600
 2200    CONTINUE                                                        SUTRA_MAIN...99700
C........TO CLOSE ALL INSERTED FILES, KEEP READING UNTIL END OF ZERO-    SUTRA_MAIN...99800
C           LEVEL FILE IS ENCOUNTERED.  THEN REWIND ZERO-LEVEL FILE      SUTRA_MAIN...99900
C           AND RE-READ THE SCHEDULE NAME.                               SUTRA_MAIN..100000
         DO 2300 NFB=1,NFBCS                                             SUTRA_MAIN..100100
            K9 = IUNIB(NFB)                                              SUTRA_MAIN..100200
            ERRCOD = 'NO_EOF_ERR'                                        SUTRA_MAIN..100300
            CHERR(1) = 'n/a'                                             SUTRA_MAIN..100400
            CHERR(2) = 'n/a'                                             SUTRA_MAIN..100500
            DO WHILE (ERRCOD.NE.'EOF')                                   SUTRA_MAIN..100600
               CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)               SUTRA_MAIN..100700
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = 151
           goto 1000
         endif
c rbw end change
            END DO                                                       SUTRA_MAIN..100800
            REWIND (K9)                                                  SUTRA_MAIN..100900
            CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)                  SUTRA_MAIN..101000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = 151
           goto 1000
         endif
c rbw end change
            READ(INTFIL,*,IOSTAT=INERR(1)) BCSSCH                        SUTRA_MAIN..101100
 2300    CONTINUE                                                        SUTRA_MAIN..101200
      ELSE                                                               SUTRA_MAIN..101300
C........IF NO BCS FILES, ZERO OUT BCS ID ARRAYS FOR NEATNESS.           SUTRA_MAIN..101400
         IIDSOP = 0                                                      SUTRA_MAIN..101500
         IIDSOU = 0                                                      SUTRA_MAIN..101600
         IIDPBC = 0                                                      SUTRA_MAIN..101700
         IIDUBC = 0                                                      SUTRA_MAIN..101800
      END IF                                                             SUTRA_MAIN..101900
C.....ALLOCATION OF BCS IDENTIFIER ARRAY IS DONE IN SUBROUTINE INDAT2.   SUTRA_MAIN..102000
C                                                                        SUTRA_MAIN..102100
C.....INPUT INITIAL OR RESTART CONDITIONS FROM THE ICS FILE AND          SUTRA_MAIN..102200
C        INITIALIZE PARAMETERS                                           SUTRA_MAIN..102300
c rbw begin change
!      CALL INDAT2(PVEC,UVEC,PM1,UM1,UM2,CS1,CS2,CS3,SL,SR,RCIT,SW,DSWDP, SUTRA_MAIN..102400
!     1   PBC,IPBC,IPBCT,NREG,QIN,DPDTITR,GNUP1,GNUU1,UIN,UBC,QUIN,       SUTRA_MAIN..102500
!     2   IBCPBC,IBCUBC,IBCSOP,IBCSOU,IIDPBC,IIDUBC,IIDSOP,IIDSOU)        SUTRA_MAIN..102600
      if (IErrorFlag.ne.0) then
        IERRORCODE = IErrorFlag
        goto 1000
      endif
      return
 1000 continue
C                                                                        SUTRA_MAIN..102700
C.....COMPUTE AND OUTPUT DIMENSIONS OF SIMULATION                        SUTRA_MAIN..102800
!      IF (K9.NE.-1) THEN                                                 SUTRA_MAIN..102900
!         NRBCS = 3*NN + 4*NBCN                                           SUTRA_MAIN..103000
!         NI1BCS = 2*NBCN + NSOP + NSOU                                   SUTRA_MAIN..103100
!      ELSE                                                               SUTRA_MAIN..103200
!         NRBCS = 7                                                       SUTRA_MAIN..103300
!         NI1BCS = 4                                                      SUTRA_MAIN..103400
!      END IF                                                             SUTRA_MAIN..103500
!      RMVDIM = 27*NN + 11*NE + 10*NEX + 3*NBCN + N48*(2*NE + NEX)        SUTRA_MAIN..103600
!     1   + NNNX + 2*NELT*NCBI + NWF + 6*NOBSN + 3*NSCH + NRBCS           SUTRA_MAIN..103700
!      IMVDIM = NIN + 2*NSOP + 2*NSOU + 4*NBCN + NN + NE                  SUTRA_MAIN..103800
!     1   + NDIMJA + NDIMIA + NWI + NOBSN + 3*NSCH                        SUTRA_MAIN..103900
!      I1VDIM = NI1BCS                                                    SUTRA_MAIN..104000
!      CMVDIM = 73*NOBS + 89*NSCH + NCIDB                                 SUTRA_MAIN..104100
!      PMVDIM = 2*NSCH                                                    SUTRA_MAIN..104200
!      LMVDIM = ITMAX                                                     SUTRA_MAIN..104300
!      TOTMB = (DBLE(RMVDIM)*8D0 + DBLE(IMVDIM)*4D0 + DBLE(I1VDIM)        SUTRA_MAIN..104400
!     1   + DBLE(CMVDIM) + DBLE(LMVDIM)*4D0)/1D6                          SUTRA_MAIN..104500
!      WRITE(K3,3000) RMVDIM,IMVDIM,I1VDIM,CMVDIM,LMVDIM,PMVDIM,TOTMB     SUTRA_MAIN..104600
! 3000 FORMAT(////11X,'S I M U L A T I O N   D I M E N S I O N S'//       SUTRA_MAIN..104700
!     1   13X,'REAL        ARRAYS WERE ALLOCATED ',I12/                   SUTRA_MAIN..104800
!     2   13X,'INTEGER     ARRAYS WERE ALLOCATED ',I12/                   SUTRA_MAIN..104900
!     3   13X,'INTEGER(1)  ARRAYS WERE ALLOCATED ',I12/                   SUTRA_MAIN..105000
!     4   13X,'CHARACTER   ARRAYS WERE ALLOCATED ',I12,                   SUTRA_MAIN..105100
!     5       ' (SUM OF ARRAY_DIMENSION*CHARACTER_LENGTH)'/               SUTRA_MAIN..105200
!     6   13X,'LOGICAL     ARRAYS WERE ALLOCATED ',I12/                   SUTRA_MAIN..105300
!     7   13X,'ARRAYS OF POINTERS WERE ALLOCATED ',I12//                  SUTRA_MAIN..105400
!     8   13X,F10.3,' Mbytes MEMORY USED FOR MAIN ARRAYS'/                SUTRA_MAIN..105500
!     9   13X,'- assuming 1 byte/character'/                              SUTRA_MAIN..105600
!     1   13X,'- assuming 4-byte logical variables'/                      SUTRA_MAIN..105700
!     2   13X,'- pointer storage not included')                           SUTRA_MAIN..105800
C                                                                        SUTRA_MAIN..105900
!      WRITE(K3,4000)                                                     SUTRA_MAIN..106000
! 4000 FORMAT(////////8(132("-")/))                                       SUTRA_MAIN..106100
!C                                                                        SUTRA_MAIN..106200
!C.....CALL MAIN CONTROL ROUTINE, SUTRA                                   SUTRA_MAIN..106300
!      CALL SUTRA(TITLE1,TITLE2,PMAT,UMAT,PITER,UITER,PM1,DPDTITR,        SUTRA_MAIN..106400
!     1   UM1,UM2,PVEL,SL,SR,X,Y,Z,VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,  SUTRA_MAIN..106500
!     2   QIN,UIN,QUIN,QINITR,RCIT,RCITM1,PVEC,UVEC,                      SUTRA_MAIN..106600
!     3   ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,VMAG,VANG1,VANG2,           SUTRA_MAIN..106700
!     4   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ, SUTRA_MAIN..106800
!     5   PANGL1,PANGL2,PANGL3,PBC,UBC,QPLITR,GXSI,GETA,GZET,FWK,B,       SUTRA_MAIN..106900
!     6   GNUP1,GNUU1,IN,IQSOP,IQSOU,IPBC,IUBC,OBSPTS,NREG,LREG,IWK,      SUTRA_MAIN..107000
!     7   IA,JA,IBCPBC,IBCUBC,IBCSOP,IBCSOU,IIDPBC,IIDUBC,IIDSOP,IIDSOU,  SUTRA_MAIN..107100
!     8   IQSOPT,IQSOUT,IPBCT,IUBCT,BCSFL,BCSTR)                          SUTRA_MAIN..107200
C                                                                        SUTRA_MAIN..107300
C.....TERMINATION SEQUENCE: DEALLOCATE ARRAYS, CLOSE FILES, AND END      SUTRA_MAIN..107400
9000  CONTINUE                                                           SUTRA_MAIN..107500
      CALL TERSEQ()                                                      SUTRA_MAIN..107600
      END                                                                SUTRA_MAIN..107700
C                                                                        SUTRA_MAIN..107800
C     SUBROUTINE        A  D  S  O  R  B           SUTRA VERSION 2.2     ADSORB.........100
C                                                                        ADSORB.........200
C *** PURPOSE :                                                          ADSORB.........300
C ***  TO CALCULATE VALUES OF EQUILIBRIUM SORPTION PARAMETERS FOR        ADSORB.........400
C ***  LINEAR, FREUNDLICH, AND LANGMUIR MODELS.                          ADSORB.........500
C                                                                        ADSORB.........600
      SUBROUTINE ADSORB(CS1,CS2,CS3,SL,SR,U)                             ADSORB.........700
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                ADSORB.........800
      CHARACTER*10 ADSMOD                                                ADSORB.........900
      DIMENSION CS1(NN),CS2(NN),CS3(NN),SL(NN),SR(NN),U(NN)              ADSORB........1000
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              ADSORB........1100
     1   NSOP,NSOU,NBCN,NCIDB                                            ADSORB........1200
      COMMON /MODSOR/ ADSMOD                                             ADSORB........1300
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      ADSORB........1400
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        ADSORB........1500
C                                                                        ADSORB........1600
C.....NOTE THAT THE CONCENTRATION OF ADSORBATE, CS(I), IS GIVEN BY       ADSORB........1700
C        CS(I) = SL(I)*U(I) + SR(I)                                      ADSORB........1800
C                                                                        ADSORB........1900
C.....NO SORPTION                                                        ADSORB........2000
      IF(ADSMOD.NE.'NONE      ') GOTO 450                                ADSORB........2100
      DO 250 I=1,NN                                                      ADSORB........2200
      CS1(I)=0.D0                                                        ADSORB........2300
      CS2(I)=0.D0                                                        ADSORB........2400
      CS3(I)=0.D0                                                        ADSORB........2500
      SL(I)=0.D0                                                         ADSORB........2600
      SR(I)=0.D0                                                         ADSORB........2700
  250 CONTINUE                                                           ADSORB........2800
      GOTO 2000                                                          ADSORB........2900
C                                                                        ADSORB........3000
C.....LINEAR SORPTION MODEL                                              ADSORB........3100
  450 IF(ADSMOD.NE.'LINEAR    ') GOTO 700                                ADSORB........3200
      DO 500 I=1,NN                                                      ADSORB........3300
      CS1(I)=CHI1*RHOW0                                                  ADSORB........3400
      CS2(I)=0.D0                                                        ADSORB........3500
      CS3(I)=0.D0                                                        ADSORB........3600
      SL(I)=CHI1*RHOW0                                                   ADSORB........3700
      SR(I)=0.D0                                                         ADSORB........3800
  500 CONTINUE                                                           ADSORB........3900
      GOTO 2000                                                          ADSORB........4000
C                                                                        ADSORB........4100
C.....FREUNDLICH SORPTION MODEL                                          ADSORB........4200
  700 IF(ADSMOD.NE.'FREUNDLICH') GOTO 950                                ADSORB........4300
      CHCH=CHI1/CHI2                                                     ADSORB........4400
      DCHI2=1.D0/CHI2                                                    ADSORB........4500
      RH2=RHOW0**DCHI2                                                   ADSORB........4600
      CHI2F=((1.D0-CHI2)/CHI2)                                           ADSORB........4700
      DO 750 I=1,NN                                                      ADSORB........4800
      IF(U(I)) 720,720,730                                               ADSORB........4900
  720 UCH=1.0D0                                                          ADSORB........5000
      GOTO 740                                                           ADSORB........5100
  730 UCH=U(I)**CHI2F                                                    ADSORB........5200
  740 RU=RH2*UCH                                                         ADSORB........5300
      CS1(I)=CHCH*RU                                                     ADSORB........5400
      CS2(I)=0.D0                                                        ADSORB........5500
      CS3(I)=0.D0                                                        ADSORB........5600
      SL(I)=CHI1*RU                                                      ADSORB........5700
      SR(I)=0.D0                                                         ADSORB........5800
  750 CONTINUE                                                           ADSORB........5900
      GOTO 2000                                                          ADSORB........6000
C                                                                        ADSORB........6100
C.....LANGMUIR SORPTION MODEL                                            ADSORB........6200
  950 IF(ADSMOD.NE.'LANGMUIR  ') GOTO 2000                               ADSORB........6300
      DO 1000 I=1,NN                                                     ADSORB........6400
      DD=1.D0+CHI2*RHOW0*U(I)                                            ADSORB........6500
      CS1(I)=(CHI1*RHOW0)/(DD*DD)                                        ADSORB........6600
      CS2(I)=0.D0                                                        ADSORB........6700
      CS3(I)=0.D0                                                        ADSORB........6800
      SL(I)=CS1(I)                                                       ADSORB........6900
      SR(I)=CS1(I)*CHI2*RHOW0*U(I)*U(I)                                  ADSORB........7000
 1000 CONTINUE                                                           ADSORB........7100
C                                                                        ADSORB........7200
 2000 RETURN                                                             ADSORB........7300
      END                                                                ADSORB........7400
C                                                                        ADSORB........7500
C     SUBROUTINE        B  A  N  W  I  D           SUTRA VERSION 2.2     BANWID.........100
C                                                                        BANWID.........200
C *** PURPOSE :                                                          BANWID.........300
C ***  TO CALCULATE THE BANDWIDTH OF THE FINITE ELEMENT MESH.            BANWID.........400
C                                                                        BANWID.........500
      SUBROUTINE BANWID(IN)                                              BANWID.........600
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BANWID.........700
      CHARACTER*80 UNAME,FNAME(0:13)                                     BANWID.........800
      DIMENSION IN(NIN)                                                  BANWID.........900
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BANWID........1000
     1   NSOP,NSOU,NBCN,NCIDB                                            BANWID........1100
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        BANWID........1200
      COMMON /FNAMES/ UNAME,FNAME                                        BANWID........1300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 BANWID........1400
     1   K10,K11,K12,K13                                                 BANWID........1500
      COMMON /SOLVI/ KSOLVP, KSOLVU, NN1, NN2, NN3                       BANWID........1600
C                                                                        BANWID........1700
      NDIF=0                                                             BANWID........1800
      II=0                                                               BANWID........1900
c rbw begin change
!      WRITE(K3,100)                                                      BANWID........2000
c rbw end change
  100 FORMAT(////11X,'**** MESH ANALYSIS ****'//)                        BANWID........2100
C                                                                        BANWID........2200
C.....FIND ELEMENT WITH MAXIMUM DIFFERENCE IN NODE NUMBERS               BANWID........2300
      DO 2000 L=1,NE                                                     BANWID........2400
      II=II+1                                                            BANWID........2500
      IELO=IN(II)                                                        BANWID........2600
      IEHI=IN(II)                                                        BANWID........2700
      DO 1000 I=2,N48                                                    BANWID........2800
      II=II+1                                                            BANWID........2900
      IF(IN(II).LT.IELO) IELO=IN(II)                                     BANWID........3000
 1000 IF(IN(II).GT.IEHI) IEHI=IN(II)                                     BANWID........3100
      NDIFF=IEHI-IELO                                                    BANWID........3200
      IF(NDIFF.GT.NDIF) THEN                                             BANWID........3300
       NDIF=NDIFF                                                        BANWID........3400
       LEM=L                                                             BANWID........3500
      ENDIF                                                              BANWID........3600
 2000 CONTINUE                                                           BANWID........3700
C                                                                        BANWID........3800
C.....CALCULATE FULL BANDWIDTH, NB.                                      BANWID........3900
      NB=2*NDIF+1                                                        BANWID........4000
      NBHALF=NDIF+1                                                      BANWID........4100
C.....NBI IS USED TO DIMENSION ARRAYS WHOSE SIZE DEPENDS ON THE          BANWID........4200
C        BANDWIDTH.  IT IS THE SAME AS THE ACTUAL BANDWIDTH, NB.         BANWID........4300
      NBI = NB                                                           BANWID........4400
c rbw begin change
!      WRITE(K3,2500) NB,LEM                                              BANWID........4500
c rbw end change
 2500 FORMAT(//13X,'MAXIMUM FULL BANDWIDTH, ',I9,                        BANWID........4600
     1   ', WAS CALCULATED IN ELEMENT ',I9)                              BANWID........4700
C                                                                        BANWID........4800
      RETURN                                                             BANWID........4900
      END                                                                BANWID........5000
C                                                                        BANWID........5100
C     SUBROUTINE        B  A  S  I  S  2           SUTRA VERSION 2.2     BASIS2.........100
C                                                                        BASIS2.........200
C *** PURPOSE :                                                          BASIS2.........300
C ***  TO CALCULATE VALUES OF BASIS AND WEIGHTING FUNCTIONS AND THEIR    BASIS2.........400
C ***  DERIVATIVES, TRANSFORMATION MATRICES BETWEEN LOCAL AND GLOBAL     BASIS2.........500
C ***  COORDINATES AND PARAMETER VALUES AT A SPECIFIED POINT IN A        BASIS2.........600
C ***  QUADRILATERAL FINITE ELEMENT.  THIS SUBROUTINE HANDLES 2D         BASIS2.........700
C ***  CALCULATIONS ONLY; 3D CALCULATIONS ARE PERFORMED IN SUBROUTINE    BASIS2.........800
C ***  BASIS3.                                                           BASIS2.........900
C                                                                        BASIS2........1000
      SUBROUTINE BASIS2(ICALL,L,XLOC,YLOC,IN,X,Y,F,W,DET,                BASIS2........1100
     1   DFDXG,DFDYG,DWDXG,DWDYG,PITER,UITER,PVEL,POR,THICK,THICKG,      BASIS2........1200
     2   VXG,VYG,SWG,RHOG,VISCG,PORG,VGMAG,RELKG,                        BASIS2........1300
     3   PERMXX,PERMXY,PERMYX,PERMYY,CJ11,CJ12,CJ21,CJ22,                BASIS2........1400
     4   GXSI,GETA,RCIT,RCITM1,RGXG,RGYG,LREG)                           BASIS2........1500
c rbw begin change
      use ErrorFlag
c rbw end chagne
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BASIS2........1600
      DOUBLE PRECISION XLOC,YLOC                                         BASIS2........1700
      DIMENSION IN(NIN),X(NN),Y(NN),UITER(NN),PITER(NN),PVEL(NN),        BASIS2........1800
     1   POR(NN),PERMXX(NE),PERMXY(NE),PERMYX(NE),PERMYY(NE),THICK(NN)   BASIS2........1900
      DIMENSION GXSI(NE,4),GETA(NE,4),RCIT(NN),RCITM1(NN),LREG(NE)       BASIS2........2000
      DIMENSION F(4),W(4),DFDXG(4),DFDYG(4),DWDXG(4),DWDYG(4)            BASIS2........2100
      DIMENSION FX(4),FY(4),AFX(4),AFY(4),                               BASIS2........2200
     1   DFDXL(4),DFDYL(4),DWDXL(4),DWDYL(4),                            BASIS2........2300
     2   XDW(4),YDW(4),XIIX(4),YIIY(4)                                   BASIS2........2400
      DIMENSION KTYPE(2)                                                 BASIS2........2500
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BASIS2........2600
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           BASIS2........2700
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      BASIS2........2800
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BASIS2........2900
     1   NSOP,NSOU,NBCN,NCIDB                                            BASIS2........3000
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      BASIS2........3100
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        BASIS2........3200
      DATA XIIX/-1.D0,+1.D0,+1.D0,-1.D0/,                                BASIS2........3300
     1     YIIY/-1.D0,-1.D0,+1.D0,+1.D0/                                 BASIS2........3400
      SAVE XIIX,YIIY                                                     BASIS2........3500
C                                                                        BASIS2........3600
C                                                                        BASIS2........3700
C.....AT THIS LOCATION IN LOCAL COORDINATES, (XLOC,YLOC),                BASIS2........3800
C        CALCULATE SYMMETRIC WEIGHTING FUNCTIONS, F(I),                  BASIS2........3900
C        SPACE DERIVATIVES, DFDXG(I) AND DFDYG(I), AND                   BASIS2........4000
C        DETERMINANT OF JACOBIAN, DET.                                   BASIS2........4100
C                                                                        BASIS2........4200
      XF1=1.D0-XLOC                                                      BASIS2........4300
      XF2=1.D0+XLOC                                                      BASIS2........4400
      YF1=1.D0-YLOC                                                      BASIS2........4500
      YF2=1.D0+YLOC                                                      BASIS2........4600
C                                                                        BASIS2........4700
C.....CALCULATE BASIS FUNCTION, F.                                       BASIS2........4800
      FX(1)=XF1                                                          BASIS2........4900
      FX(2)=XF2                                                          BASIS2........5000
      FX(3)=XF2                                                          BASIS2........5100
      FX(4)=XF1                                                          BASIS2........5200
      FY(1)=YF1                                                          BASIS2........5300
      FY(2)=YF1                                                          BASIS2........5400
      FY(3)=YF2                                                          BASIS2........5500
      FY(4)=YF2                                                          BASIS2........5600
      DO 10 I=1,4                                                        BASIS2........5700
   10 F(I)=0.250D0*FX(I)*FY(I)                                           BASIS2........5800
C                                                                        BASIS2........5900
C.....CALCULATE DERIVATIVES WITH RESPECT TO LOCAL COORDINATES.           BASIS2........6000
      DO 20 I=1,4                                                        BASIS2........6100
      DFDXL(I)=XIIX(I)*0.250D0*FY(I)                                     BASIS2........6200
   20 DFDYL(I)=YIIY(I)*0.250D0*FX(I)                                     BASIS2........6300
C                                                                        BASIS2........6400
C.....CALCULATE ELEMENTS OF JACOBIAN MATRIX, CJ.                         BASIS2........6500
      CJ11=0.D0                                                          BASIS2........6600
      CJ12=0.D0                                                          BASIS2........6700
      CJ21=0.D0                                                          BASIS2........6800
      CJ22=0.D0                                                          BASIS2........6900
      DO 100 IL=1,4                                                      BASIS2........7000
      II=(L-1)*4+IL                                                      BASIS2........7100
      I=IN(II)                                                           BASIS2........7200
      CJ11=CJ11+DFDXL(IL)*X(I)                                           BASIS2........7300
      CJ12=CJ12+DFDXL(IL)*Y(I)                                           BASIS2........7400
      CJ21=CJ21+DFDYL(IL)*X(I)                                           BASIS2........7500
  100 CJ22=CJ22+DFDYL(IL)*Y(I)                                           BASIS2........7600
C                                                                        BASIS2........7700
C.....CALCULATE DETERMINANT OF JACOBIAN MATRIX.                          BASIS2........7800
      DET=CJ11*CJ22-CJ21*CJ12                                            BASIS2........7900
C                                                                        BASIS2........8000
C.....RETURN TO ELEMEN2 WITH JACOBIAN MATRIX ON FIRST TIME STEP.         BASIS2........8100
      IF(ICALL.EQ.0) RETURN                                              BASIS2........8200
C                                                                        BASIS2........8300
C.....CALCULATE ELEMENTS OF INVERSE JACOBIAN MATRIX, CIJ.                BASIS2........8400
      ODET=1.D0/DET                                                      BASIS2........8500
      CIJ11=+ODET*CJ22                                                   BASIS2........8600
      CIJ12=-ODET*CJ12                                                   BASIS2........8700
      CIJ21=-ODET*CJ21                                                   BASIS2........8800
      CIJ22=+ODET*CJ11                                                   BASIS2........8900
C                                                                        BASIS2........9000
C.....CALCULATE DERIVATIVES WITH RESPECT TO GLOBAL COORDINATES           BASIS2........9100
      DO 200 I=1,4                                                       BASIS2........9200
      DFDXG(I)=CIJ11*DFDXL(I)+CIJ12*DFDYL(I)                             BASIS2........9300
  200 DFDYG(I)=CIJ21*DFDXL(I)+CIJ22*DFDYL(I)                             BASIS2........9400
C                                                                        BASIS2........9500
C.....CALCULATE CONSISTENT COMPONENTS OF (RHO*GRAV) TERM IN LOCAL        BASIS2........9600
C        COORDINATES AT THIS LOCATION, (XLOC,YLOC)                       BASIS2........9700
      RGXL=0.D0                                                          BASIS2........9800
      RGYL=0.D0                                                          BASIS2........9900
      RGXLM1=0.D0                                                        BASIS2.......10000
      RGYLM1=0.D0                                                        BASIS2.......10100
      DO 800 IL=1,4                                                      BASIS2.......10200
      II=(L-1)*4+IL                                                      BASIS2.......10300
      I=IN(II)                                                           BASIS2.......10400
      ADFDXL=DABS(DFDXL(IL))                                             BASIS2.......10500
      ADFDYL=DABS(DFDYL(IL))                                             BASIS2.......10600
      RGXL=RGXL+RCIT(I)*GXSI(L,IL)*ADFDXL                                BASIS2.......10700
      RGYL=RGYL+RCIT(I)*GETA(L,IL)*ADFDYL                                BASIS2.......10800
      RGXLM1=RGXLM1+RCITM1(I)*GXSI(L,IL)*ADFDXL                          BASIS2.......10900
      RGYLM1=RGYLM1+RCITM1(I)*GETA(L,IL)*ADFDYL                          BASIS2.......11000
  800 CONTINUE                                                           BASIS2.......11100
C                                                                        BASIS2.......11200
C.....TRANSFORM CONSISTENT COMPONENTS OF (RHO*GRAV) TERM TO              BASIS2.......11300
C        GLOBAL COORDINATES                                              BASIS2.......11400
      RGXG=CIJ11*RGXL+CIJ12*RGYL                                         BASIS2.......11500
      RGYG=CIJ21*RGXL+CIJ22*RGYL                                         BASIS2.......11600
      RGXGM1=CIJ11*RGXLM1+CIJ12*RGYLM1                                   BASIS2.......11700
      RGYGM1=CIJ21*RGXLM1+CIJ22*RGYLM1                                   BASIS2.......11800
C                                                                        BASIS2.......11900
C.....CALCULATE PARAMETER VALUES AT THIS LOCATION, (XLOC,YLOC)           BASIS2.......12000
      PITERG=0.D0                                                        BASIS2.......12100
      UITERG=0.D0                                                        BASIS2.......12200
      DPDXG=0.D0                                                         BASIS2.......12300
      DPDYG=0.D0                                                         BASIS2.......12400
      PORG=0.D0                                                          BASIS2.......12500
      THICKG=0.0D0                                                       BASIS2.......12600
      DO 1000 IL=1,4                                                     BASIS2.......12700
      II=(L-1)*4 +IL                                                     BASIS2.......12800
      I=IN(II)                                                           BASIS2.......12900
      DPDXG=DPDXG+PVEL(I)*DFDXG(IL)                                      BASIS2.......13000
      DPDYG=DPDYG+PVEL(I)*DFDYG(IL)                                      BASIS2.......13100
      PORG=PORG+POR(I)*F(IL)                                             BASIS2.......13200
      THICKG=THICKG+THICK(I)*F(IL)                                       BASIS2.......13300
      PITERG=PITERG+PITER(I)*F(IL)                                       BASIS2.......13400
      UITERG=UITERG+UITER(I)*F(IL)                                       BASIS2.......13500
 1000 CONTINUE                                                           BASIS2.......13600
C                                                                        BASIS2.......13700
C.....SET VALUES FOR DENSITY AND VISCOSITY.                              BASIS2.......13800
C.....RHOG = FUNCTION(UITER)                                             BASIS2.......13900
      RHOG=RHOW0+DRWDU*(UITERG-URHOW0)                                   BASIS2.......14000
C.....VISCG = FUNCTION(UITER); VISCOSITY IN UNITS OF VISC0*(KG/(M*SEC))  BASIS2.......14100
      IF(ME) 1300,1300,1200                                              BASIS2.......14200
 1200 VISCG=VISC0*239.4D-7*(10.D0**(248.37D0/(UITERG+133.15D0)))         BASIS2.......14300
      GOTO 1400                                                          BASIS2.......14400
C.....FOR SOLUTE TRANSPORT, VISCG IS TAKEN TO BE CONSTANT                BASIS2.......14500
 1300 VISCG=VISC0                                                        BASIS2.......14600
 1400 CONTINUE                                                           BASIS2.......14700
C                                                                        BASIS2.......14800
C.....SET UNSATURATED FLOW PARAMETERS SWG AND RELKG                      BASIS2.......14900
      IF(IUNSAT-2) 1600,1500,1600                                        BASIS2.......15000
 1500 IF(PITERG) 1550,1600,1600                                          BASIS2.......15100
 1550 CALL UNSAT(SWG,DSWDPG,RELKG,PITERG,LREG(L))                        BASIS2.......15200
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      GOTO 1700                                                          BASIS2.......15300
 1600 SWG=1.0D0                                                          BASIS2.......15400
      RELKG=1.0D0                                                        BASIS2.......15500
 1700 CONTINUE                                                           BASIS2.......15600
C                                                                        BASIS2.......15700
C.....CALCULATE CONSISTENT FLUID VELOCITIES WITH RESPECT TO GLOBAL       BASIS2.......15800
C        COORDINATES, VXG, VYG, AND VGMAG, AT THIS LOCATION, (XLOC,YLOC) BASIS2.......15900
      DENOM=1.D0/(PORG*SWG*VISCG)                                        BASIS2.......16000
      PGX=DPDXG-RGXGM1                                                   BASIS2.......16100
      PGY=DPDYG-RGYGM1                                                   BASIS2.......16200
C.....ZERO OUT RANDOM BOUYANT DRIVING FORCES DUE TO DIFFERENCING         BASIS2.......16300
C        NUMBERS PAST PRECISION LIMIT.  MINIMUM DRIVING FORCE IS         BASIS2.......16400
C        1.D-10 OF PRESSURE GRADIENT.  (THIS VALUE MAY BE CHANGED        BASIS2.......16500
C        DEPENDING ON MACHINE PRECISION.)                                BASIS2.......16600
      IF(DPDXG) 1720,1730,1720                                           BASIS2.......16700
 1720 IF(DABS(PGX/DPDXG)-1.0D-10) 1725,1725,1730                         BASIS2.......16800
 1725 PGX=0.0D0                                                          BASIS2.......16900
 1730 IF(DPDYG) 1750,1760,1750                                           BASIS2.......17000
 1750 IF(DABS(PGY/DPDYG)-1.0D-10) 1755,1755,1760                         BASIS2.......17100
 1755 PGY=0.0D0                                                          BASIS2.......17200
 1760 VXG=-DENOM*(PERMXX(L)*PGX+PERMXY(L)*PGY)*RELKG                     BASIS2.......17300
      VYG=-DENOM*(PERMYX(L)*PGX+PERMYY(L)*PGY)*RELKG                     BASIS2.......17400
      VXG2=VXG*VXG                                                       BASIS2.......17500
      VYG2=VYG*VYG                                                       BASIS2.......17600
      VGMAG=DSQRT(VXG2+VYG2)                                             BASIS2.......17700
C                                                                        BASIS2.......17800
C.....AT THIS POINT IN LOCAL COORDINATES, (XLOC,YLOC),                   BASIS2.......17900
C        CALCULATE ASYMMETRIC WEIGHTING FUNCTIONS, W(I),                 BASIS2.......18000
C        AND SPACE DERIVATIVES, DWDXG(I) AND DWDYG(I).                   BASIS2.......18100
C                                                                        BASIS2.......18200
C.....ASYMMETRIC FUNCTIONS SIMPLIFY WHEN  UP=0.0                         BASIS2.......18300
      IF(UP.GT.1.0D-6.AND.NOUMAT.EQ.0) GOTO 1790                         BASIS2.......18400
      DO 1780 I=1,4                                                      BASIS2.......18500
      W(I)=F(I)                                                          BASIS2.......18600
      DWDXG(I)=DFDXG(I)                                                  BASIS2.......18700
      DWDYG(I)=DFDYG(I)                                                  BASIS2.......18800
 1780 CONTINUE                                                           BASIS2.......18900
C.....RETURN WHEN ONLY SYMMETRIC WEIGHTING FUNCTIONS ARE USED            BASIS2.......19000
      RETURN                                                             BASIS2.......19100
C                                                                        BASIS2.......19200
C.....CALCULATE FLUID VELOCITIES WITH RESPECT TO LOCAL COORDINATES,      BASIS2.......19300
C        VXL, VYL, AND VLMAG, AT THIS LOCATION, (XLOC,YLOC).             BASIS2.......19400
 1790 VXL=CIJ11*VXG+CIJ21*VYG                                            BASIS2.......19500
      VYL=CIJ12*VXG+CIJ22*VYG                                            BASIS2.......19600
      VLMAG=DSQRT(VXL*VXL+VYL*VYL)                                       BASIS2.......19700
C                                                                        BASIS2.......19800
      AA=0.0D0                                                           BASIS2.......19900
      BB=0.0D0                                                           BASIS2.......20000
      IF(VLMAG) 1900,1900,1800                                           BASIS2.......20100
 1800 AA=UP*VXL/VLMAG                                                    BASIS2.......20200
      BB=UP*VYL/VLMAG                                                    BASIS2.......20300
C                                                                        BASIS2.......20400
 1900 XIXI=.750D0*AA*XF1*XF2                                             BASIS2.......20500
      YIYI=.750D0*BB*YF1*YF2                                             BASIS2.......20600
      DO 2000 I=1,4                                                      BASIS2.......20700
      AFX(I)=.50D0*FX(I)+XIIX(I)*XIXI                                    BASIS2.......20800
 2000 AFY(I)=.50D0*FY(I)+YIIY(I)*YIYI                                    BASIS2.......20900
C                                                                        BASIS2.......21000
C.....CALCULATE ASYMMETRIC WEIGHTING FUNCTION, W.                        BASIS2.......21100
      DO 3000 I=1,4                                                      BASIS2.......21200
 3000 W(I)=AFX(I)*AFY(I)                                                 BASIS2.......21300
C                                                                        BASIS2.......21400
      THAAX=0.50D0-1.50D0*AA*XLOC                                        BASIS2.......21500
      THBBY=0.50D0-1.50D0*BB*YLOC                                        BASIS2.......21600
      DO 4000 I=1,4                                                      BASIS2.......21700
      XDW(I)=XIIX(I)*THAAX                                               BASIS2.......21800
 4000 YDW(I)=YIIY(I)*THBBY                                               BASIS2.......21900
C                                                                        BASIS2.......22000
C.....CALCULATE DERIVATIVES WITH RESPECT TO LOCAL COORDINATES.           BASIS2.......22100
      DO 5000 I=1,4                                                      BASIS2.......22200
      DWDXL(I)=XDW(I)*AFY(I)                                             BASIS2.......22300
 5000 DWDYL(I)=YDW(I)*AFX(I)                                             BASIS2.......22400
C                                                                        BASIS2.......22500
C.....CALCULATE DERIVATIVES WITH RESPECT TO GLOBAL COORDINATES.          BASIS2.......22600
      DO 6000 I=1,4                                                      BASIS2.......22700
      DWDXG(I)=CIJ11*DWDXL(I)+CIJ12*DWDYL(I)                             BASIS2.......22800
 6000 DWDYG(I)=CIJ21*DWDXL(I)+CIJ22*DWDYL(I)                             BASIS2.......22900
C                                                                        BASIS2.......23000
C                                                                        BASIS2.......23100
      RETURN                                                             BASIS2.......23200
      END                                                                BASIS2.......23300
C                                                                        BASIS2.......23400
C     SUBROUTINE        B  A  S  I  S  3           SUTRA VERSION 2.2     BASIS3.........100
C                                                                        BASIS3.........200
C *** PURPOSE :                                                          BASIS3.........300
C ***  TO CALCULATE VALUES OF BASIS AND WEIGHTING FUNCTIONS AND THEIR    BASIS3.........400
C ***  DERIVATIVES, TRANSFORMATION MATRICES BETWEEN LOCAL AND GLOBAL     BASIS3.........500
C ***  COORDINATES AND PARAMETER VALUES AT A SPECIFIED POINT IN A        BASIS3.........600
C ***  QUADRILATERAL FINITE ELEMENT.  THIS SUBROUTINE HANDLES 3D         BASIS3.........700
C ***  CALCULATIONS ONLY; 2D CALCULATIONS ARE PERFORMED IN SUBROUTINE    BASIS3.........800
C ***  BASIS2.                                                           BASIS3.........900
C                                                                        BASIS3........1000
      SUBROUTINE BASIS3(ICALL,L,XLOC,YLOC,ZLOC,IN,X,Y,Z,F,W,DET,         BASIS3........1100
     1   DFDXG,DFDYG,DFDZG,DWDXG,DWDYG,DWDZG,PITER,UITER,PVEL,POR,       BASIS3........1200
     2   VXG,VYG,VZG,SWG,RHOG,VISCG,PORG,VGMAG,RELKG,                    BASIS3........1300
     3   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ, BASIS3........1400
     4   CJ11,CJ12,CJ13,CJ21,CJ22,CJ23,CJ31,CJ32,CJ33,                   BASIS3........1500
     4   GXSI,GETA,GZET,RCIT,RCITM1,RGXG,RGYG,RGZG,LREG)                 BASIS3........1600
c rbw begin change
      use ErrorFlag
c rbw end chagne
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BASIS3........1700
      DOUBLE PRECISION XLOC,YLOC,ZLOC                                    BASIS3........1800
      DIMENSION IN(NIN),X(NN),Y(NN),Z(NN),UITER(NN),PITER(NN),PVEL(NN),  BASIS3........1900
     1   POR(NN),PERMXX(NE),PERMXY(NE),PERMXZ(NE),PERMYX(NE),            BASIS3........2000
     2   PERMYY(NE),PERMYZ(NE),PERMZX(NE),PERMZY(NE),PERMZZ(NE)          BASIS3........2100
      DIMENSION GXSI(NE,8),GETA(NE,8),GZET(NE,8)                         BASIS3........2200
      DIMENSION RCIT(NN),RCITM1(NN),LREG(NE)                             BASIS3........2300
      DIMENSION F(8),DFDXG(8),DFDYG(8),DFDZG(8)                          BASIS3........2400
      DIMENSION W(8),DWDXG(8),DWDYG(8),DWDZG(8)                          BASIS3........2500
      DIMENSION FX(8),FY(8),FZ(8),AFX(8),AFY(8),AFZ(8),                  BASIS3........2600
     1   DFDXL(8),DFDYL(8),DFDZL(8),DWDXL(8),DWDYL(8),DWDZL(8),          BASIS3........2700
     2   XDW(8),YDW(8),ZDW(8),XIIX(8),YIIY(8),ZIIZ(8)                    BASIS3........2800
      DIMENSION KTYPE(2)                                                 BASIS3........2900
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BASIS3........3000
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           BASIS3........3100
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      BASIS3........3200
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BASIS3........3300
     1   NSOP,NSOU,NBCN,NCIDB                                            BASIS3........3400
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      BASIS3........3500
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        BASIS3........3600
      DATA XIIX/-1.D0,+1.D0,+1.D0,-1.D0,-1.D0,+1.D0,+1.D0,-1.D0/         BASIS3........3700
      DATA YIIY/-1.D0,-1.D0,+1.D0,+1.D0,-1.D0,-1.D0,+1.D0,+1.D0/         BASIS3........3800
      DATA ZIIZ/-1.D0,-1.D0,-1.D0,-1.D0,+1.D0,+1.D0,+1.D0,+1.D0/         BASIS3........3900
      SAVE XIIX,YIIY,ZIIZ                                                BASIS3........4000
C                                                                        BASIS3........4100
C                                                                        BASIS3........4200
C.....AT THIS LOCATION IN LOCAL COORDINATES, (XLOC,YLOC,ZLOC),           BASIS3........4300
C        CALCULATE SYMMETRIC WEIGHTING FUNCTIONS, F(I),                  BASIS3........4400
C        SPACE DERIVATIVES, DFDXG(I), DFDYX(I), AND DFDZG(I),            BASIS3........4500
C        AND DETERMINANT OF JACOBIAN, DET.                               BASIS3........4600
C                                                                        BASIS3........4700
      XF1=1.D0-XLOC                                                      BASIS3........4800
      XF2=1.D0+XLOC                                                      BASIS3........4900
      YF1=1.D0-YLOC                                                      BASIS3........5000
      YF2=1.D0+YLOC                                                      BASIS3........5100
      ZF1=1.D0-ZLOC                                                      BASIS3........5200
      ZF2=1.D0+ZLOC                                                      BASIS3........5300
C                                                                        BASIS3........5400
C.....CALCULATE BASIS FUNCTION, F.                                       BASIS3........5500
      FX(1)=XF1                                                          BASIS3........5600
      FX(2)=XF2                                                          BASIS3........5700
      FX(3)=XF2                                                          BASIS3........5800
      FX(4)=XF1                                                          BASIS3........5900
      FX(5)=XF1                                                          BASIS3........6000
      FX(6)=XF2                                                          BASIS3........6100
      FX(7)=XF2                                                          BASIS3........6200
      FX(8)=XF1                                                          BASIS3........6300
      FY(1)=YF1                                                          BASIS3........6400
      FY(2)=YF1                                                          BASIS3........6500
      FY(3)=YF2                                                          BASIS3........6600
      FY(4)=YF2                                                          BASIS3........6700
      FY(5)=YF1                                                          BASIS3........6800
      FY(6)=YF1                                                          BASIS3........6900
      FY(7)=YF2                                                          BASIS3........7000
      FY(8)=YF2                                                          BASIS3........7100
      FZ(1)=ZF1                                                          BASIS3........7200
      FZ(2)=ZF1                                                          BASIS3........7300
      FZ(3)=ZF1                                                          BASIS3........7400
      FZ(4)=ZF1                                                          BASIS3........7500
      FZ(5)=ZF2                                                          BASIS3........7600
      FZ(6)=ZF2                                                          BASIS3........7700
      FZ(7)=ZF2                                                          BASIS3........7800
      FZ(8)=ZF2                                                          BASIS3........7900
      DO 10 I=1,8                                                        BASIS3........8000
   10 F(I)=0.125D0*FX(I)*FY(I)*FZ(I)                                     BASIS3........8100
C                                                                        BASIS3........8200
C.....CALCULATE DERIVATIVES WITH RESPECT TO LOCAL COORDINATES.           BASIS3........8300
      DO 20 I=1,8                                                        BASIS3........8400
      DFDXL(I)=XIIX(I)*0.125D0*FY(I)*FZ(I)                               BASIS3........8500
      DFDYL(I)=YIIY(I)*0.125D0*FX(I)*FZ(I)                               BASIS3........8600
   20 DFDZL(I)=ZIIZ(I)*0.125D0*FX(I)*FY(I)                               BASIS3........8700
C                                                                        BASIS3........8800
C.....CALCULATE ELEMENTS OF JACOBIAN MATRIX, CJ.                         BASIS3........8900
      CJ11=0.D0                                                          BASIS3........9000
      CJ12=0.D0                                                          BASIS3........9100
      CJ13=0.D0                                                          BASIS3........9200
      CJ21=0.D0                                                          BASIS3........9300
      CJ22=0.D0                                                          BASIS3........9400
      CJ23=0.D0                                                          BASIS3........9500
      CJ31=0.D0                                                          BASIS3........9600
      CJ32=0.D0                                                          BASIS3........9700
      CJ33=0.D0                                                          BASIS3........9800
      DO 100 IL=1,8                                                      BASIS3........9900
      II=(L-1)*8+IL                                                      BASIS3.......10000
      I=IN(II)                                                           BASIS3.......10100
      CJ11=CJ11+DFDXL(IL)*X(I)                                           BASIS3.......10200
      CJ12=CJ12+DFDXL(IL)*Y(I)                                           BASIS3.......10300
      CJ13=CJ13+DFDXL(IL)*Z(I)                                           BASIS3.......10400
      CJ21=CJ21+DFDYL(IL)*X(I)                                           BASIS3.......10500
      CJ22=CJ22+DFDYL(IL)*Y(I)                                           BASIS3.......10600
      CJ23=CJ23+DFDYL(IL)*Z(I)                                           BASIS3.......10700
      CJ31=CJ31+DFDZL(IL)*X(I)                                           BASIS3.......10800
      CJ32=CJ32+DFDZL(IL)*Y(I)                                           BASIS3.......10900
  100 CJ33=CJ33+DFDZL(IL)*Z(I)                                           BASIS3.......11000
C                                                                        BASIS3.......11100
C.....CALCULATE DETERMINANT OF JACOBIAN MATRIX.                          BASIS3.......11200
      DET=CJ11*(CJ22*CJ33-CJ32*CJ23)                                     BASIS3.......11300
     1   -CJ21*(CJ12*CJ33-CJ32*CJ13)                                     BASIS3.......11400
     2   +CJ31*(CJ12*CJ23-CJ22*CJ13)                                     BASIS3.......11500
C                                                                        BASIS3.......11600
C.....RETURN TO ELEMEN3 WITH JACOBIAN MATRIX ON FIRST TIME STEP.         BASIS3.......11700
      IF(ICALL.EQ.0) RETURN                                              BASIS3.......11800
C                                                                        BASIS3.......11900
C                                                                        BASIS3.......12000
C.....CALCULATE ELEMENTS OF INVERSE JACOBIAN MATRIX, CIJ.                BASIS3.......12100
      ODET=1.D0/DET                                                      BASIS3.......12200
      CIJ11=+ODET*(CJ22*CJ33-CJ32*CJ23)                                  BASIS3.......12300
      CIJ12=-ODET*(CJ12*CJ33-CJ32*CJ13)                                  BASIS3.......12400
      CIJ13=+ODET*(CJ12*CJ23-CJ22*CJ13)                                  BASIS3.......12500
      CIJ21=-ODET*(CJ21*CJ33-CJ31*CJ23)                                  BASIS3.......12600
      CIJ22=+ODET*(CJ11*CJ33-CJ31*CJ13)                                  BASIS3.......12700
      CIJ23=-ODET*(CJ11*CJ23-CJ21*CJ13)                                  BASIS3.......12800
      CIJ31=+ODET*(CJ21*CJ32-CJ31*CJ22)                                  BASIS3.......12900
      CIJ32=-ODET*(CJ11*CJ32-CJ31*CJ12)                                  BASIS3.......13000
      CIJ33=+ODET*(CJ11*CJ22-CJ21*CJ12)                                  BASIS3.......13100
C                                                                        BASIS3.......13200
C.....CALCULATE DERIVATIVES WITH RESPECT TO GLOBAL COORDINATES           BASIS3.......13300
      DO 200 I=1,8                                                       BASIS3.......13400
      DFDXG(I)=CIJ11*DFDXL(I)+CIJ12*DFDYL(I)+CIJ13*DFDZL(I)              BASIS3.......13500
      DFDYG(I)=CIJ21*DFDXL(I)+CIJ22*DFDYL(I)+CIJ23*DFDZL(I)              BASIS3.......13600
  200 DFDZG(I)=CIJ31*DFDXL(I)+CIJ32*DFDYL(I)+CIJ33*DFDZL(I)              BASIS3.......13700
C                                                                        BASIS3.......13800
C.....CALCULATE CONSISTENT COMPONENTS OF (RHO*GRAV) TERM IN LOCAL        BASIS3.......13900
C        COORDINATES AT THIS LOCATION, (XLOC,YLOC,ZLOC)                  BASIS3.......14000
      RGXL=0.D0                                                          BASIS3.......14100
      RGYL=0.D0                                                          BASIS3.......14200
      RGZL=0.D0                                                          BASIS3.......14300
      RGXLM1=0.D0                                                        BASIS3.......14400
      RGYLM1=0.D0                                                        BASIS3.......14500
      RGZLM1=0.D0                                                        BASIS3.......14600
      DO 800 IL=1,8                                                      BASIS3.......14700
      II=(L-1)*8+IL                                                      BASIS3.......14800
      I=IN(II)                                                           BASIS3.......14900
      ADFDXL=DABS(DFDXL(IL))                                             BASIS3.......15000
      ADFDYL=DABS(DFDYL(IL))                                             BASIS3.......15100
      ADFDZL=DABS(DFDZL(IL))                                             BASIS3.......15200
      RGXL=RGXL+RCIT(I)*GXSI(L,IL)*ADFDXL                                BASIS3.......15300
      RGYL=RGYL+RCIT(I)*GETA(L,IL)*ADFDYL                                BASIS3.......15400
      RGZL=RGZL+RCIT(I)*GZET(L,IL)*ADFDZL                                BASIS3.......15500
      RGXLM1=RGXLM1+RCITM1(I)*GXSI(L,IL)*ADFDXL                          BASIS3.......15600
      RGYLM1=RGYLM1+RCITM1(I)*GETA(L,IL)*ADFDYL                          BASIS3.......15700
      RGZLM1=RGZLM1+RCITM1(I)*GZET(L,IL)*ADFDZL                          BASIS3.......15800
  800 CONTINUE                                                           BASIS3.......15900
C                                                                        BASIS3.......16000
C.....TRANSFORM CONSISTENT COMPONENTS OF (RHO*GRAV) TERM TO              BASIS3.......16100
C        GLOBAL COORDINATES                                              BASIS3.......16200
      RGXG=CIJ11*RGXL+CIJ12*RGYL+CIJ13*RGZL                              BASIS3.......16300
      RGYG=CIJ21*RGXL+CIJ22*RGYL+CIJ23*RGZL                              BASIS3.......16400
      RGZG=CIJ31*RGXL+CIJ32*RGYL+CIJ33*RGZL                              BASIS3.......16500
      RGXGM1=CIJ11*RGXLM1+CIJ12*RGYLM1+CIJ13*RGZLM1                      BASIS3.......16600
      RGYGM1=CIJ21*RGXLM1+CIJ22*RGYLM1+CIJ23*RGZLM1                      BASIS3.......16700
      RGZGM1=CIJ31*RGXLM1+CIJ32*RGYLM1+CIJ33*RGZLM1                      BASIS3.......16800
C                                                                        BASIS3.......16900
C.....CALCULATE PARAMETER VALUES AT THIS LOCATION, (XLOC,YLOC,ZLOC)      BASIS3.......17000
      PITERG=0.D0                                                        BASIS3.......17100
      UITERG=0.D0                                                        BASIS3.......17200
      DPDXG=0.D0                                                         BASIS3.......17300
      DPDYG=0.D0                                                         BASIS3.......17400
      DPDZG=0.D0                                                         BASIS3.......17500
      PORG=0.D0                                                          BASIS3.......17600
      DO 1000 IL=1,8                                                     BASIS3.......17700
      II=(L-1)*8 +IL                                                     BASIS3.......17800
      I=IN(II)                                                           BASIS3.......17900
      DPDXG=DPDXG+PVEL(I)*DFDXG(IL)                                      BASIS3.......18000
      DPDYG=DPDYG+PVEL(I)*DFDYG(IL)                                      BASIS3.......18100
      DPDZG=DPDZG+PVEL(I)*DFDZG(IL)                                      BASIS3.......18200
      PORG=PORG+POR(I)*F(IL)                                             BASIS3.......18300
      PITERG=PITERG+PITER(I)*F(IL)                                       BASIS3.......18400
      UITERG=UITERG+UITER(I)*F(IL)                                       BASIS3.......18500
 1000 CONTINUE                                                           BASIS3.......18600
C                                                                        BASIS3.......18700
C.....SET VALUES FOR DENSITY AND VISCOSITY.                              BASIS3.......18800
C.....RHOG = FUNCTION(UITER)                                             BASIS3.......18900
      RHOG=RHOW0+DRWDU*(UITERG-URHOW0)                                   BASIS3.......19000
C.....VISCG = FUNCTION(UITER); VISCOSITY IN UNITS OF VISC0*(KG/(M*SEC))  BASIS3.......19100
      IF(ME) 1300,1300,1200                                              BASIS3.......19200
 1200 VISCG=VISC0*239.4D-7*(10.D0**(248.37D0/(UITERG+133.15D0)))         BASIS3.......19300
      GOTO 1400                                                          BASIS3.......19400
C.....FOR SOLUTE TRANSPORT, VISCG IS TAKEN TO BE CONSTANT                BASIS3.......19500
 1300 VISCG=VISC0                                                        BASIS3.......19600
 1400 CONTINUE                                                           BASIS3.......19700
C                                                                        BASIS3.......19800
C.....SET UNSATURATED FLOW PARAMETERS SWG AND RELKG                      BASIS3.......19900
      IF(IUNSAT-2) 1600,1500,1600                                        BASIS3.......20000
 1500 IF(PITERG) 1550,1600,1600                                          BASIS3.......20100
 1550 CALL UNSAT(SWG,DSWDPG,RELKG,PITERG,LREG(L))                        BASIS3.......20200
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      GOTO 1700                                                          BASIS3.......20300
 1600 SWG=1.0D0                                                          BASIS3.......20400
      RELKG=1.0D0                                                        BASIS3.......20500
 1700 CONTINUE                                                           BASIS3.......20600
C                                                                        BASIS3.......20700
C.....CALCULATE CONSISTENT FLUID VELOCITIES WITH RESPECT TO GLOBAL       BASIS3.......20800
C        COORDINATES, VXG, VYG, VZG, AND VGMAG, AT THIS LOCATION,        BASIS3.......20900
C        (XLOC,YLOC,ZLOC)                                                BASIS3.......21000
      DENOM=1.D0/(PORG*SWG*VISCG)                                        BASIS3.......21100
      PGX=DPDXG-RGXGM1                                                   BASIS3.......21200
      PGY=DPDYG-RGYGM1                                                   BASIS3.......21300
      PGZ=DPDZG-RGZGM1                                                   BASIS3.......21400
C.....ZERO OUT RANDOM BOUYANT DRIVING FORCES DUE TO DIFFERENCING         BASIS3.......21500
C        NUMBERS PAST PRECISION LIMIT.  MINIMUM DRIVING FORCE IS         BASIS3.......21600
C        1.D-10 OF PRESSURE GRADIENT.  (THIS VALUE MAY BE CHANGED        BASIS3.......21700
C        DEPENDING ON MACHINE PRECISION.)                                BASIS3.......21800
      IF(DPDXG) 1720,1727,1720                                           BASIS3.......21900
 1720 IF(DABS(PGX/DPDXG)-1.0D-10) 1725,1725,1727                         BASIS3.......22000
 1725 PGX=0.0D0                                                          BASIS3.......22100
 1727 IF(DPDYG) 1730,1737,1730                                           BASIS3.......22200
 1730 IF(DABS(PGY/DPDYG)-1.0D-10) 1735,1735,1737                         BASIS3.......22300
 1735 PGY=0.0D0                                                          BASIS3.......22400
 1737 IF(DPDZG) 1740,1760,1740                                           BASIS3.......22500
 1740 IF(DABS(PGZ/DPDZG)-1.0D-10) 1745,1745,1760                         BASIS3.......22600
 1745 PGZ=0.0D0                                                          BASIS3.......22700
 1760 VXG=-DENOM*(PERMXX(L)*PGX+PERMXY(L)*PGY+PERMXZ(L)*PGZ)*RELKG       BASIS3.......22800
      VYG=-DENOM*(PERMYX(L)*PGX+PERMYY(L)*PGY+PERMYZ(L)*PGZ)*RELKG       BASIS3.......22900
      VZG=-DENOM*(PERMZX(L)*PGX+PERMZY(L)*PGY+PERMZZ(L)*PGZ)*RELKG       BASIS3.......23000
      VXG2=VXG*VXG                                                       BASIS3.......23100
      VYG2=VYG*VYG                                                       BASIS3.......23200
      VZG2=VZG*VZG                                                       BASIS3.......23300
      VGMAG=DSQRT(VXG2+VYG2+VZG2)                                        BASIS3.......23400
C                                                                        BASIS3.......23500
C.....AT THIS POINT IN LOCAL COORDINATES, (XLOC,YLOC,ZLOC),              BASIS3.......23600
C        CALCULATE ASYMMETRIC WEIGHTING FUNCTIONS, W(I),                 BASIS3.......23700
C        AND SPACE DERIVATIVES, DWDXG(I), DWDYG(I), AND DWDZG(I).        BASIS3.......23800
C                                                                        BASIS3.......23900
C.....ASYMMETRIC FUNCTIONS SIMPLIFY WHEN  UP=0.0                         BASIS3.......24000
      IF(UP.GT.1.0D-6.AND.NOUMAT.EQ.0) GOTO 1790                         BASIS3.......24100
      DO 1780 I=1,8                                                      BASIS3.......24200
      W(I)=F(I)                                                          BASIS3.......24300
      DWDXG(I)=DFDXG(I)                                                  BASIS3.......24400
      DWDYG(I)=DFDYG(I)                                                  BASIS3.......24500
      DWDZG(I)=DFDZG(I)                                                  BASIS3.......24600
 1780 CONTINUE                                                           BASIS3.......24700
C.....RETURN WHEN ONLY SYMMETRIC WEIGHTING FUNCTIONS ARE USED            BASIS3.......24800
      RETURN                                                             BASIS3.......24900
C                                                                        BASIS3.......25000
C.....CALCULATE FLUID VELOCITIES WITH RESPECT TO LOCAL COORDINATES,      BASIS3.......25100
C        VXL, VYL, VZL, AND VLMAG, AT THIS LOCATION, (XLOC,YLOC,ZLOC).   BASIS3.......25200
 1790 VXL=CIJ11*VXG+CIJ21*VYG+CIJ31*VZG                                  BASIS3.......25300
      VYL=CIJ12*VXG+CIJ22*VYG+CIJ32*VZG                                  BASIS3.......25400
      VZL=CIJ13*VXG+CIJ23*VYG+CIJ33*VZG                                  BASIS3.......25500
      VLMAG=DSQRT(VXL*VXL+VYL*VYL+VZL*VZL)                               BASIS3.......25600
C                                                                        BASIS3.......25700
      AA=0.0D0                                                           BASIS3.......25800
      BB=0.0D0                                                           BASIS3.......25900
      GG=0.0D0                                                           BASIS3.......26000
      IF(VLMAG) 1900,1900,1800                                           BASIS3.......26100
 1800 AA=UP*VXL/VLMAG                                                    BASIS3.......26200
      BB=UP*VYL/VLMAG                                                    BASIS3.......26300
      GG=UP*VZL/VLMAG                                                    BASIS3.......26400
C                                                                        BASIS3.......26500
 1900 XIXI=.750D0*AA*XF1*XF2                                             BASIS3.......26600
      YIYI=.750D0*BB*YF1*YF2                                             BASIS3.......26700
      ZIZI=.750D0*GG*ZF1*ZF2                                             BASIS3.......26800
      DO 2000 I=1,8                                                      BASIS3.......26900
      AFX(I)=.50D0*FX(I)+XIIX(I)*XIXI                                    BASIS3.......27000
      AFY(I)=.50D0*FY(I)+YIIY(I)*YIYI                                    BASIS3.......27100
 2000 AFZ(I)=.50D0*FZ(I)+ZIIZ(I)*ZIZI                                    BASIS3.......27200
C                                                                        BASIS3.......27300
C.....CALCULATE ASYMMETRIC WEIGHTING FUNCTION, W.                        BASIS3.......27400
      DO 3000 I=1,8                                                      BASIS3.......27500
 3000 W(I)=AFX(I)*AFY(I)*AFZ(I)                                          BASIS3.......27600
C                                                                        BASIS3.......27700
      THAAX=0.50D0-1.50D0*AA*XLOC                                        BASIS3.......27800
      THBBY=0.50D0-1.50D0*BB*YLOC                                        BASIS3.......27900
      THGGZ=0.50D0-1.50D0*GG*ZLOC                                        BASIS3.......28000
      DO 4000 I=1,8                                                      BASIS3.......28100
      XDW(I)=XIIX(I)*THAAX                                               BASIS3.......28200
      YDW(I)=YIIY(I)*THBBY                                               BASIS3.......28300
 4000 ZDW(I)=ZIIZ(I)*THGGZ                                               BASIS3.......28400
C                                                                        BASIS3.......28500
C.....CALCULATE DERIVATIVES WITH RESPECT TO LOCAL COORDINATES.           BASIS3.......28600
      DO 5000 I=1,8                                                      BASIS3.......28700
      DWDXL(I)=XDW(I)*AFY(I)*AFZ(I)                                      BASIS3.......28800
      DWDYL(I)=YDW(I)*AFX(I)*AFZ(I)                                      BASIS3.......28900
 5000 DWDZL(I)=ZDW(I)*AFX(I)*AFY(I)                                      BASIS3.......29000
C                                                                        BASIS3.......29100
C.....CALCULATE DERIVATIVES WITH RESPECT TO GLOBAL COORDINATES.          BASIS3.......29200
      DO 6000 I=1,8                                                      BASIS3.......29300
      DWDXG(I)=CIJ11*DWDXL(I)+CIJ12*DWDYL(I)+CIJ13*DWDZL(I)              BASIS3.......29400
      DWDYG(I)=CIJ21*DWDXL(I)+CIJ22*DWDYL(I)+CIJ23*DWDZL(I)              BASIS3.......29500
 6000 DWDZG(I)=CIJ31*DWDXL(I)+CIJ32*DWDYL(I)+CIJ33*DWDZL(I)              BASIS3.......29600
C                                                                        BASIS3.......29700
C                                                                        BASIS3.......29800
      RETURN                                                             BASIS3.......29900
      END                                                                BASIS3.......30000
C                                                                        BASIS3.......30100
C     SUBROUTINE        B  C                       SUTRA VERSION 2.2     BC.............100
C                                                                        BC.............200
C *** PURPOSE :                                                          BC.............300
C ***  TO IMPLEMENT SPECIFIED PRESSURE AND SPECIFIED TEMPERATURE OR      BC.............400
C ***  CONCENTRATION CONDITIONS BY MODIFYING THE GLOBAL FLOW AND         BC.............500
C ***  TRANSPORT MATRIX EQUATIONS.                                       BC.............600
C                                                                        BC.............700
      SUBROUTINE BC(ML,PMAT,PVEC,UMAT,UVEC,IPBC,PBC,IUBC,UBC,QPLITR,JA,  BC.............800
     1   GNUP1,GNUU1)                                                    BC.............900
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BC............1000
      DIMENSION PMAT(NELT,NCBI),PVEC(NNVEC),UMAT(NELT,NCBI),UVEC(NNVEC), BC............1100
     1   IPBC(NBCN),PBC(NBCN),IUBC(NBCN),UBC(NBCN),QPLITR(NBCN),         BC............1200
     2   GNUP1(NBCN),GNUU1(NBCN)                                         BC............1300
      DIMENSION JA(NDIMJA)                                               BC............1400
      DIMENSION KTYPE(2)                                                 BC............1500
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BC............1600
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           BC............1700
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      BC............1800
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BC............1900
     1   NSOP,NSOU,NBCN,NCIDB                                            BC............2000
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        BC............2100
      COMMON /DIMX2/ NELTA,NNVEC,NDIMIA,NDIMJA                           BC............2200
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      BC............2300
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        BC............2400
      COMMON /SOLVI/ KSOLVP,KSOLVU,NN1,NN2,NN3                           BC............2500
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       BC............2600
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART      BC............2700
C                                                                        BC............2800
C                                                                        BC............2900
C.....SET UP MATRIX STRUCTURE INFORMATION                                BC............3000
      IF (KSOLVP.EQ.0) THEN                                              BC............3100
         JMID = NBHALF                                                   BC............3200
      ELSE                                                               BC............3300
         JMID = 1                                                        BC............3400
      END IF                                                             BC............3500
C                                                                        BC............3600
      IF(NPBC.EQ.0) GOTO 1050                                            BC............3700
C.....SPECIFIED P BOUNDARY CONDITIONS                                    BC............3800
      DO 1000 IP=1,NPBC                                                  BC............3900
      I=IABS(IPBC(IP))                                                   BC............4000
      IF (KSOLVP.EQ.0) THEN                                              BC............4100
         IMID = I                                                        BC............4200
      ELSE                                                               BC............4300
         IMID = JA(I)                                                    BC............4400
      END IF                                                             BC............4500
C                                                                        BC............4600
      IF(ML-1) 100,100,200                                               BC............4700
C.....MODIFY EQUATION FOR P BY ADDING FLUID SOURCE AT SPECIFIED          BC............4800
C        PRESSURE NODE                                                   BC............4900
  100 GPINL=-GNUP1(IP)                                                   BC............5000
      GPINR=GNUP1(IP)*PBC(IP)                                            BC............5100
      PMAT(IMID,JMID)=PMAT(IMID,JMID)-GPINL                              BC............5200
      PVEC(I)=PVEC(I)+GPINR                                              BC............5300
C                                                                        BC............5400
      IF(ML-1) 200,1000,200                                              BC............5500
C.....MODIFY EQUATION FOR U BY ADDING U SOURCE WHEN FLUID FLOWS IN       BC............5600
C        AT SPECIFIED PRESSURE NODE                                      BC............5700
  200 GUR=0.0D0                                                          BC............5800
      GUL=0.0D0                                                          BC............5900
      IF(QPLITR(IP)) 360,360,340                                         BC............6000
  340 GUL=-CW*QPLITR(IP)                                                 BC............6100
      GUR=-GUL*UBC(IP)                                                   BC............6200
  360 IF(NOUMAT) 370,370,380                                             BC............6300
  370 UMAT(IMID,JMID)=UMAT(IMID,JMID)-GUL                                BC............6400
  380 UVEC(I)=UVEC(I)+GUR                                                BC............6500
 1000 CONTINUE                                                           BC............6600
C                                                                        BC............6700
C                                                                        BC............6800
 1050 IF(ML-1) 1100,3000,1100                                            BC............6900
 1100 IF(NUBC.EQ.0) GOTO 3000                                            BC............7000
C.....SPECIFIED U BOUNDARY CONDITIONS.                                   BC............7100
C        MODIFY EQUATION FOR U BY ADDING ENERGY/SOLUTE MASS SOURCE       BC............7200
C        AT SPECIFIED U NODE                                             BC............7300
      DO 2500 IU=1,NUBC                                                  BC............7400
      IUP=IU+NPBC                                                        BC............7500
      I=IABS(IUBC(IUP))                                                  BC............7600
      IF (KSOLVP.EQ.0) THEN                                              BC............7700
         IMID = I                                                        BC............7800
      ELSE                                                               BC............7900
         IMID = JA(I)                                                    BC............8000
      END IF                                                             BC............8100
      IF(NOUMAT) 1200,1200,2000                                          BC............8200
 1200 GUINL=-GNUU1(IUP)                                                  BC............8300
      UMAT(IMID,JMID)=UMAT(IMID,JMID)-GUINL                              BC............8400
 2000 GUINR=GNUU1(IUP)*UBC(IUP)                                          BC............8500
 2500 UVEC(I)=UVEC(I)+GUINR                                              BC............8600
C                                                                        BC............8700
 3000 CONTINUE                                                           BC............8800
C                                                                        BC............8900
C                                                                        BC............9000
      RETURN                                                             BC............9100
      END                                                                BC............9200
C                                                                        BC............9300
C     SUBROUTINE        B  C  S  T  E  P           SUTRA VERSION 2.2     BCSTEP.........100
C                                                                        BCSTEP.........200
C *** PURPOSE :                                                          BCSTEP.........300
C ***  TO READ TIME-DEPENDENT BOUNDARY CONDITIONS FROM THE BCS FILES     BCSTEP.........400
c ***  AND UPDATE THE ARRAYS IN WHICH THEY ARE STORED.                   BCSTEP.........500
C                                                                        BCSTEP.........600
      SUBROUTINE BCSTEP(SETBCS,IPBC,PBC,IUBC,UBC,QIN,UIN,QUIN,IQSOP,     BCSTEP.........700
     1   IQSOU,IPBCT1,IUBCT1,IQSOPT1,IQSOUT1,GNUP1,GNUU1,                BCSTEP.........800
     2   IBCPBC,IBCUBC,IBCSOP,IBCSOU,IIDPBC,IIDUBC,IIDSOP,IIDSOU,        BCSTEP.........900
     3   NCID,BCSFL,BCSTR)                                               BCSTEP........1000
      USE ALLARR, ONLY : CIDBCS                                          BCSTEP........1100
      USE BCSDEF                                                         BCSTEP........1200
      USE EXPINT                                                         BCSTEP........1300
      USE LLDEF                                                          BCSTEP........1400
      USE SCHDEF                                                         BCSTEP........1500
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BCSTEP........1600
      CHARACTER INTFIL*1000                                              BCSTEP........1700
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:13)                    BCSTEP........1800
      CHARACTER*40 BCSID                                                 BCSTEP........1900
      LOGICAL ONCEBCS,SETBCS,SETFL,SETTR,BCSFL(0:ITMAX),BCSTR(0:ITMAX)   BCSTEP........2000
      LOGICAL USEFL,ANYFL,ANYTR                                          BCSTEP........2100
      INTEGER(1) IBCPBC(NBCN),IBCUBC(NBCN),IBCSOP(NSOP),IBCSOU(NSOU)     BCSTEP........2200
      INTEGER IIDPBC(NBCN),IIDUBC(NBCN),IIDSOP(NSOP),IIDSOU(NSOU)        BCSTEP........2300
      DIMENSION INERR(10),RLERR(10)                                      BCSTEP........2400
      DIMENSION IPBC(NBCN),PBC(NBCN),IUBC(NBCN),UBC(NBCN),               BCSTEP........2500
     1   GNUP1(NBCN),GNUU1(NBCN),                                        BCSTEP........2600
     2   QIN(NN),UIN(NN),QUIN(NN),IQSOP(NSOP),IQSOU(NSOU)                BCSTEP........2700
      DIMENSION KTYPE(2)                                                 BCSTEP........2800
      ALLOCATABLE :: IPBC1(:),PBC1(:),IUBC1(:),UBC1(:),                  BCSTEP........2900
     1   QIN1(:),UIN1(:),QUIN1(:),IQSOP1(:),IQSOU1(:)                    BCSTEP........3000
      COMMON /BCSL/ ONCEBCS                                              BCSTEP........3100
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BCSTEP........3200
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           BCSTEP........3300
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      BCSTEP........3400
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BCSTEP........3500
     1   NSOP,NSOU,NBCN,NCIDB                                            BCSTEP........3600
      COMMON /FUNIB/ NFBCS                                               BCSTEP........3700
      COMMON /FNAMES/ UNAME,FNAME                                        BCSTEP........3800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 BCSTEP........3900
     1   K10,K11,K12,K13                                                 BCSTEP........4000
      COMMON /SCH/ NSCH,ISCHTS,NSCHAU                                    BCSTEP........4100
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       BCSTEP........4200
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART      BCSTEP........4300
C                                                                        BCSTEP........4400
C.....IF THIS IS THE FIRST IN A SERIES OF CALLS, INITIALIZE BCS          BCSTEP........4500
C        SCHEDULES                                                       BCSTEP........4600
      IF (.NOT.ONCEBCS) THEN                                             BCSTEP........4700
         IF (.NOT.ALLOCATED(LCNT)) ALLOCATE (LCNT(NFBCS),DENBCS(NFBCS))  BCSTEP........4800
         DO 20 NFB=1,NFBCS                                               BCSTEP........4900
            DENBCS(NFB)%NENT => SCHDLS(BFP(NFB)%ISCHED)%SLIST            BCSTEP........5000
            LCNT(NFB) = 1                                                BCSTEP........5100
   20    CONTINUE                                                        BCSTEP........5200
         ONCEBCS = .TRUE.                                                BCSTEP........5300
      END IF                                                             BCSTEP........5400
C                                                                        BCSTEP........5500
C.....INITIALIZE FLAGS THAT INDICATE WHETHER BOUNDARY CONDITIONS ARE     BCSTEP........5600
C        ACTUALLY SET ON THIS TIME STEP.  THESE FLAGS ARE USED IN        BCSTEP........5700
C        DETERMINING SOLUTION CYCLING.  INITIALIZE COUNTER FOR BCS       BCSTEP........5800
C        IDENTIFIERS.                                                    BCSTEP........5900
      IF (ITBCS.NE.0) THEN                                               BCSTEP........6000
         BCSFL(ITBCS) = .FALSE.                                          BCSTEP........6100
         BCSTR(ITBCS) = .FALSE.                                          BCSTEP........6200
      END IF                                                             BCSTEP........6300
      IF (.NOT.((ISSTRA.NE.0).AND.(ITBCS.EQ.1))) NCID = 0                BCSTEP........6400
C                                                                        BCSTEP........6500
C.....LOOP OVER ALL BCS FILES                                            BCSTEP........6600
      DO 1000 NFB=1,NFBCS                                                BCSTEP........6700
         K9 = IUNIB(NFB)                                                 BCSTEP........6800
C........SET FNAME(9) EQUAL TO FNAMB(NFB) FOR CONVENIENCE IN             BCSTEP........6900
C           ERROR HANDLING                                               BCSTEP........7000
         FNAME(9) = FNAMB(NFB)                                           BCSTEP........7100
         LENSCH = SCHDLS(BFP(NFB)%ISCHED)%LLEN                           BCSTEP........7200
C                                                                        BCSTEP........7300
C...,,FIND BOUNDARY CONDITIONS FOR THE CURRENT TIME STEP, IF ANY.        BCSTEP........7400
C        (IF THIS BCS SCHEDULE IS EXHAUSTED, SKIP TO NEXT FILE.)         BCSTEP........7500
  100 IF (LCNT(NFB).GT.LENSCH) GOTO 1000                                 BCSTEP........7600
      ITNBCS = INT(DENBCS(NFB)%NENT%DVALU2)                              BCSTEP........7700
      IF (ITBCS.LT.ITNBCS) THEN                                          BCSTEP........7800
C........THE CURRENT TIME STEP PRECEDES THIS BCS SCHEDULE ENTRY.         BCSTEP........7900
C          SKIP TO NEXT FILE.                                            BCSTEP........8000
         GOTO 1000                                                       BCSTEP........8100
      ELSE                                                               BCSTEP........8200
         WRITE(CHERR(1),*) ITNBCS                                        BCSTEP........8300
         ERRCOD = 'REA-BCS-2'                                            BCSTEP........8400
         CHERR(2) = 'unknown'                                            BCSTEP........8500
         CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)                     BCSTEP........8600
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
         READ(INTFIL,*,IOSTAT=INERR(1)) BCSID,NSOP1,NSOU1,NPBC1,NUBC1    BCSTEP........8700
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BCSTEP........8800
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
         IF ((ITNBCS.EQ.0).AND.(NSOU1+NUBC1.GT.0)) THEN                  BCSTEP........8900
           IErrorFlag = 153
           return
!            ERRCOD = 'BCS-2-1'                                           BCSTEP........9000
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     BCSTEP........9100
         END IF                                                          BCSTEP........9200
         IF (ITBCS.GT.ITNBCS) THEN                                       BCSTEP........9300
C...........THE CURRENT TIME STEP IS PAST THIS BCS SCHEDULE ENTRY,       BCSTEP........9400
C             READ PAST THIS SPECIFICATION AND ADVANCE TO THE NEXT       BCSTEP........9500
C             SCHEDULE ENTRY.                                            BCSTEP........9600
            CHERR(2) = BCSID                                             BCSTEP........9700
            ERRCOD = 'REA-BCS-3'                                         BCSTEP........9800
            IF (NSOP1.GT.0) THEN                                         BCSTEP........9900
               DO 120 N=1,NSOP1+1                                        BCSTEP.......10000
                  CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)            BCSTEP.......10100
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
  120          CONTINUE                                                  BCSTEP.......10200
            END IF                                                       BCSTEP.......10300
            ERRCOD = 'REA-BCS-4'                                         BCSTEP.......10400
            IF (NSOU1.GT.0) THEN                                         BCSTEP.......10500
               DO 122 N=1,NSOU1+1                                        BCSTEP.......10600
                  CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)            BCSTEP.......10700
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
  122          CONTINUE                                                  BCSTEP.......10800
            END IF                                                       BCSTEP.......10900
            ERRCOD = 'REA-BCS-5'                                         BCSTEP.......11000
            IF (NPBC1.GT.0) THEN                                         BCSTEP.......11100
               DO 124 N=1,NPBC1+1                                        BCSTEP.......11200
                  CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)            BCSTEP.......11300
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
  124          CONTINUE                                                  BCSTEP.......11400
            END IF                                                       BCSTEP.......11500
            ERRCOD = 'REA-BCS-6'                                         BCSTEP.......11600
            IF (NUBC1.GT.0) THEN                                         BCSTEP.......11700
               DO 126 N=1,NUBC1+1                                        BCSTEP.......11800
                  CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)            BCSTEP.......11900
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
  126          CONTINUE                                                  BCSTEP.......12000
            END IF                                                       BCSTEP.......12100
            LCNT(NFB) = LCNT(NFB) + 1                                    BCSTEP.......12200
            IF (LCNT(NFB).LE.LENSCH)                                     BCSTEP.......12300
     1         DENBCS(NFB)%NENT => DENBCS(NFB)%NENT%NENT                 BCSTEP.......12400
            GOTO 100                                                     BCSTEP.......12500
         END IF                                                          BCSTEP.......12600
      END IF                                                             BCSTEP.......12700
C                                                                        BCSTEP.......12800
C.....SET NBCN1, AND INCREMENT NSOP1 AND NSOU1 TO ACCOMMODATE FINAL      BCSTEP.......12900
C        ZERO WHEN READING.  COUNTS OF TIME-DEPENDENT NODES REFER TO     BCSTEP.......13000
C        THE BCS FILE CURRENTLY BEING READ.                              BCSTEP.......13100
      NBCN1 = NPBC1 + NUBC1 + 1                                          BCSTEP.......13200
      NSOP1 = NSOP1 + 1                                                  BCSTEP.......13300
      NSOU1 = NSOU1 + 1                                                  BCSTEP.......13400
C.....NSOPI IS ACTUAL NUMBER OF POSSIBLE FLUID SOURCE NODES              BCSTEP.......13500
      NSOPI = NSOP - 1                                                   BCSTEP.......13600
C.....NSOUI IS ACTUAL NUMBER OF POSSIBLE ENERGY OR SOLUTE MASS           BCSTEP.......13700
C        SOURCE NODES                                                    BCSTEP.......13800
      NSOUI = NSOU - 1                                                   BCSTEP.......13900
C.....NSOPI1 IS ACTUAL NUMBER OF TIME-STEP-DEPENDENT FLUID SOURCE NODES  BCSTEP.......14000
C        ON THIS TIME STEP                                               BCSTEP.......14100
      NSOPI1 = NSOP1 - 1                                                 BCSTEP.......14200
C.....NSOUI1 IS ACTUAL NUMBER OF TIME-STEP-DEPENDENT ENERGY OR SOLUTE    BCSTEP.......14300
C        MASS SOURCE NODES ON THIS TIME STEP                             BCSTEP.......14400
      NSOUI1 = NSOU1 - 1                                                 BCSTEP.......14500
C                                                                        BCSTEP.......14600
C.....SET FLAGS THAT DETERMINE WHETHER TO SET FLOW AND/OR TRANSPORT      BCSTEP.......14700
C        BOUNDARY CONDITIONS (IF ANY) AND THAT INDICATE WHETHER BOUNDARY BCSTEP.......14800
C        CONDITIONS ARE ACTUALLY SET ON THIS TIME STEP                   BCSTEP.......14900
      USEFL = ((ISSFLO.NE.0).AND.(ITBCS.EQ.0)).OR.                       BCSTEP.......15000
     1   ((ISSFLO.EQ.0).AND.(ITBCS.NE.0))                                BCSTEP.......15100
      ANYFL = NSOPI1+NPBC1.GT.0                                          BCSTEP.......15200
      ANYTR = NSOUI1+NUBC1.GT.0                                          BCSTEP.......15300
      BCSFL(ITBCS) = USEFL.AND.ANYFL                                     BCSTEP.......15400
      BCSTR(ITBCS) = ANYTR                                               BCSTEP.......15500
      SETFL = SETBCS.AND.BCSFL(ITBCS)                                    BCSTEP.......15600
      SETTR = SETBCS.AND.BCSTR(ITBCS)                                    BCSTEP.......15700
      IF (BCSFL(ITBCS).OR.BCSTR(ITBCS)) THEN                             BCSTEP.......15800
         NCID = NCID + 1                                                 BCSTEP.......15900
         IF (SETBCS) CIDBCS(NCID) = BCSID                                BCSTEP.......16000
      END IF                                                             BCSTEP.......16100
C                                                                        BCSTEP.......16200
C.....IF NO TIME-DEPENDENT SOURCE/SINK CONDITIONS, SKIP THIS SECTION     BCSTEP.......16300
      IF ((NSOPI1+NSOUI1).EQ.0) GOTO 500                                 BCSTEP.......16400
C                                                                        BCSTEP.......16500
C.....ALLOCATE ARRAYS FOR SOURCE/SINK CONDITIONS                         BCSTEP.......16600
      ALLOCATE(QIN1(NN),UIN1(NN),QUIN1(NN),IQSOP1(NSOP1),IQSOU1(NSOU1))  BCSTEP.......16700
C                                                                        BCSTEP.......16800
C.....INPUT BCS DATASETS 3 & 4 (SOURCES OF FLUID MASS AND ENERGY OR      BCSTEP.......16900
C        SOLUTE MASS) FOR CURRENT TIME STEP                              BCSTEP.......17000
      CALL SOURCE1(QIN1,UIN1,IQSOP1,QUIN1,IQSOU1,IQSOPT1,IQSOUT1,        BCSTEP.......17100
     1   NSOP1,NSOU1,NFB,BCSID)                                          BCSTEP.......17200
C                                                                        BCSTEP.......17300
C.....SET TIME-STEP-DEPENDENT FLUID SOURCES/SINKS,                       BCSTEP.......17400
C      OR CONCENTRATIONS (TEMPERATURES) OF SOURCE FLUID                  BCSTEP.......17500
C                                                                        BCSTEP.......17600
      IF (NSOPI1.GT.0) THEN                                              BCSTEP.......17700
      DO 200 IQP1=1,NSOPI1                                               BCSTEP.......17800
         I=IQSOP1(IQP1)                                                  BCSTEP.......17900
         DO 150 IQP0=1,NSOPI                                             BCSTEP.......18000
            I0 = IQSOP(IQP0)                                             BCSTEP.......18100
            IF (IABS(I0).EQ.IABS(I)) THEN                                BCSTEP.......18200
               IQP = IQP0                                                BCSTEP.......18300
               GOTO 180                                                  BCSTEP.......18400
            END IF                                                       BCSTEP.......18500
  150    CONTINUE                                                        BCSTEP.......18600
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-3-2'                                              BCSTEP.......18700
!         INERR(1) = IABS(I)                                              BCSTEP.......18800
!         INERR(2) = ITBCS                                                BCSTEP.......18900
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BCSTEP.......19000
  180    CONTINUE                                                        BCSTEP.......19100
         IF (SETFL) THEN                                                 BCSTEP.......19200
            IF (I.GT.0) THEN                                             BCSTEP.......19300
               QIN(I) = QIN1(I)                                          BCSTEP.......19400
               IF (QIN(I).GT.0D0) UIN(I) = UIN1(I)                       BCSTEP.......19500
               IBCSOP(IQP) = 1                                           BCSTEP.......19600
            ELSE                                                         BCSTEP.......19700
               QIN(-I) = 0D0                                             BCSTEP.......19800
               IBCSOP(IQP) = 2                                           BCSTEP.......19900
            END IF                                                       BCSTEP.......20000
            IIDSOP(IQP) = NCID                                           BCSTEP.......20100
         END IF                                                          BCSTEP.......20200
  200 CONTINUE                                                           BCSTEP.......20300
      END IF                                                             BCSTEP.......20400
C                                                                        BCSTEP.......20500
C.....SET TIME-STEP-DEPENDENT SOURCES/SINKS                              BCSTEP.......20600
C     OF SOLUTE MASS OR ENERGY                                           BCSTEP.......20700
C                                                                        BCSTEP.......20800
      IF (NSOUI1.GT.0) THEN                                              BCSTEP.......20900
      DO 400 IQU1=1,NSOUI1                                               BCSTEP.......21000
         I=IQSOU1(IQU1)                                                  BCSTEP.......21100
         DO 350 IQU0=1,NSOUI                                             BCSTEP.......21200
            I0 = IQSOU(IQU0)                                             BCSTEP.......21300
            IF (IABS(I0).EQ.IABS(I)) THEN                                BCSTEP.......21400
               IQU = IQU0                                                BCSTEP.......21500
               GOTO 380                                                  BCSTEP.......21600
            END IF                                                       BCSTEP.......21700
  350    CONTINUE                                                        BCSTEP.......21800
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-4-2'                                              BCSTEP.......21900
!         INERR(1) = IABS(I)                                              BCSTEP.......22000
!         INERR(2) = ITBCS                                                BCSTEP.......22100
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BCSTEP.......22200
  380    CONTINUE                                                        BCSTEP.......22300
         IF (SETTR) THEN                                                 BCSTEP.......22400
            IF (I.GT.0) THEN                                             BCSTEP.......22500
               QUIN(I) = QUIN1(I)                                        BCSTEP.......22600
               IBCSOU(IQU) = 1                                           BCSTEP.......22700
            ELSE                                                         BCSTEP.......22800
               QUIN(-I) = 0D0                                            BCSTEP.......22900
               IBCSOU(IQU) = 2                                           BCSTEP.......23000
            END IF                                                       BCSTEP.......23100
            IIDSOU(IQU) = NCID                                           BCSTEP.......23200
         END IF                                                          BCSTEP.......23300
  400 CONTINUE                                                           BCSTEP.......23400
      END IF                                                             BCSTEP.......23500
C                                                                        BCSTEP.......23600
C.....DEALLOCATE ARRAYS FOR SOURCE/SINK CONDITIONS                       BCSTEP.......23700
      DEALLOCATE(QIN1,UIN1,QUIN1,IQSOP1,IQSOU1)                          BCSTEP.......23800
C                                                                        BCSTEP.......23900
C.....IF NO TIME-DEPENDENT SPECIFIED P OR U BOUNDARY CONDITIONS, SKIP    BCSTEP.......24000
C        THIS SECTION                                                    BCSTEP.......24100
  500 IF (NBCN1-1.EQ.0) GOTO 900                                         BCSTEP.......24200
C                                                                        BCSTEP.......24300
C.....ALLOCATE ARRAYS FOR SPECIFIED P AND U BOUNDARY CONDITIONS          BCSTEP.......24400
      ALLOCATE(IPBC1(NBCN1),PBC1(NBCN1),IUBC1(NBCN1),UBC1(NBCN1))        BCSTEP.......24500
C                                                                        BCSTEP.......24600
C.....INPUT BCS DATASETS 5 & 6 (SPECIFIED P AND U BOUNDARY CONDITIONS)   BCSTEP.......24700
C        FOR CURRENT TIME STEP                                           BCSTEP.......24800
      CALL BOUND1(IPBC1,PBC1,IUBC1,UBC1,IPBCT1,IUBCT1,                   BCSTEP.......24900
     1   NPBC1,NUBC1,NBCN1,NFB,BCSID)                                    BCSTEP.......25000
C                                                                        BCSTEP.......25100
C.....SET TIME-STEP-DEPENDENT SPECIFIED PRESSURES OR                     BCSTEP.......25200
C     CONCENTRATIONS (TEMPERATURES) OF INFLOWS AT SPECIFIED              BCSTEP.......25300
C     PRESSURE NODES                                                     BCSTEP.......25400
C                                                                        BCSTEP.......25500
      IF (NPBC1.GT.0) THEN                                               BCSTEP.......25600
      DO 600 IP1=1,NPBC1                                                 BCSTEP.......25700
         I = IPBC1(IP1)                                                  BCSTEP.......25800
         DO 550 IP0=1,NPBC                                               BCSTEP.......25900
            I0 = IPBC(IP0)                                               BCSTEP.......26000
            IF (IABS(I0).EQ.IABS(I)) THEN                                BCSTEP.......26100
               IP = IP0                                                  BCSTEP.......26200
               GOTO 580                                                  BCSTEP.......26300
            END IF                                                       BCSTEP.......26400
  550    CONTINUE                                                        BCSTEP.......26500
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-5-2'                                              BCSTEP.......26600
!         INERR(1) = IABS(I)                                              BCSTEP.......26700
 !        INERR(2) = ITBCS                                                BCSTEP.......26800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BCSTEP.......26900
  580    CONTINUE                                                        BCSTEP.......27000
         IF (SETFL) THEN                                                 BCSTEP.......27100
            IF (I.GT.0) THEN                                             BCSTEP.......27200
               PBC(IP) = PBC1(IP1)                                       BCSTEP.......27300
               UBC(IP) = UBC1(IP1)                                       BCSTEP.......27400
               GNUP1(IP) = GNUP                                          BCSTEP.......27500
               IBCPBC(IP) = 1                                            BCSTEP.......27600
            ELSE                                                         BCSTEP.......27700
               GNUP1(IP) = 0D0                                           BCSTEP.......27800
               IBCPBC(IP) = 2                                            BCSTEP.......27900
            END IF                                                       BCSTEP.......28000
            IIDPBC(IP) = NCID                                            BCSTEP.......28100
         END IF                                                          BCSTEP.......28200
  600 CONTINUE                                                           BCSTEP.......28300
      END IF                                                             BCSTEP.......28400
C                                                                        BCSTEP.......28500
C.....SET TIME-STEP-DEPENDENT SPECIFIED                                  BCSTEP.......28600
C     CONCENTRATIONS (TEMPERATURES)                                      BCSTEP.......28700
C                                                                        BCSTEP.......28800
      IF (NUBC1.GT.0) THEN                                               BCSTEP.......28900
      DO 800 IU1=1,NUBC1                                                 BCSTEP.......29000
         IUP1 = IU1 + NPBC1                                              BCSTEP.......29100
         I=IUBC1(IUP1)                                                   BCSTEP.......29200
         DO 700 IU0=1,NUBC                                               BCSTEP.......29300
            IUP0 = IU0 + NPBC                                            BCSTEP.......29400
            I0 = IUBC(IUP0)                                              BCSTEP.......29500
            IF (IABS(I0).EQ.IABS(I)) THEN                                BCSTEP.......29600
               IUP = IUP0                                                BCSTEP.......29700
               GOTO 750                                                  BCSTEP.......29800
            END IF                                                       BCSTEP.......29900
  700    CONTINUE                                                        BCSTEP.......30000
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-6-2'                                              BCSTEP.......30100
!         INERR(1) = IABS(I)                                              BCSTEP.......30200!
!         INERR(2) = ITBCS                                                BCSTEP.......30300
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BCSTEP.......30400
  750    CONTINUE                                                        BCSTEP.......30500
         IF (SETTR) THEN                                                 BCSTEP.......30600
            IF (I.GT.0) THEN                                             BCSTEP.......30700
               UBC(IUP) = UBC1(IUP1)                                     BCSTEP.......30800
               GNUU1(IUP) = GNUU                                         BCSTEP.......30900
               IBCUBC(IUP) = 1                                           BCSTEP.......31000
            ELSE                                                         BCSTEP.......31100
               GNUU1(IUP) = 0D0                                          BCSTEP.......31200
               IBCUBC(IUP) = 2                                           BCSTEP.......31300
            END IF                                                       BCSTEP.......31400
            IIDUBC(IUP) = NCID                                           BCSTEP.......31500
         END IF                                                          BCSTEP.......31600
  800 CONTINUE                                                           BCSTEP.......31700
      END IF                                                             BCSTEP.......31800
C                                                                        BCSTEP.......31900
C.....DEALLOCATE ARRAYS FOR SPECIFIED P AND U BOUNDARY CONDITIONS        BCSTEP.......32000
      DEALLOCATE(IPBC1,PBC1,IUBC1,UBC1)                                  BCSTEP.......32100
C                                                                        BCSTEP.......32200
C.....ADVANCE TO NEXT SCHEDULE ENTRY FOR THIS FILE (IF THERE IS ONE).    BCSTEP.......32300
  900 LCNT(NFB) = LCNT(NFB) + 1                                          BCSTEP.......32400
      IF (LCNT(NFB).LE.LENSCH)                                           BCSTEP.......32500
     1   DENBCS(NFB)%NENT => DENBCS(NFB)%NENT%NENT                       BCSTEP.......32600
C                                                                        BCSTEP.......32700
 1000 CONTINUE                                                           BCSTEP.......32800
      RETURN                                                             BCSTEP.......32900
      END                                                                BCSTEP.......33000
C                                                                        BCSTEP.......33100
C     SUBPROGRAM        B  D  I  N  I  T           SUTRA VERSION 2.2     BDINIT.........100
C                                                                        BDINIT.........200
C *** PURPOSE :                                                          BDINIT.........300
C ***  BLOCK-DATA SUBPROGRAM FOR INITIALIZING VARIABLES NAMED IN         BDINIT.........400
C ***  COMMON BLOCKS.                                                    BDINIT.........500
C                                                                        BDINIT.........600
      BLOCK DATA BDINIT                                                  BDINIT.........700
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BDINIT.........800
      CHARACTER*40 SOLNAM(0:10)                                          BDINIT.........900
      CHARACTER*10 SOLWRD(0:10)                                          BDINIT........1000
      COMMON /SOLVC/ SOLWRD, SOLNAM                                      BDINIT........1100
      COMMON /SOLVN/ NSLVRS                                              BDINIT........1200
C.....SET THE NUMBER OF SOLVERS AVAILABLE                                BDINIT........1300
      DATA NSLVRS /4/                                                    BDINIT........1400
C.....DEFINE KEYWORDS AND NAMES FOR SOLVERS                              BDINIT........1500
      DATA (SOLWRD(M),SOLNAM(M),M=0,10) /                                BDINIT........1600
     1   'DIRECT', 'BANDED GAUSSIAN ELIMINATION (DIRECT)',               BDINIT........1700
     2   'CG', 'IC-PRECONDITIONED CONJUGATE GRADIENT',                   BDINIT........1800
     3   'GMRES', 'ILU-PRECONDITIONED GMRES',                            BDINIT........1900
     4   'ORTHOMIN', 'ILU-PRECONDITIONED ORTHOMIN',                      BDINIT........2000
     5   '', '',                                                         BDINIT........2100
     6   '', '',                                                         BDINIT........2200
     7   '', '',                                                         BDINIT........2300
     8   '', '',                                                         BDINIT........2400
     9   '', '',                                                         BDINIT........2500
     T   '', '',                                                         BDINIT........2600
     1   '', ''/                                                         BDINIT........2700
      END                                                                BDINIT........2800
C                                                                        BDINIT........2900
C     SUBROUTINE        B  O  U  N  D              SUTRA VERSION 2.2     BOUND..........100
C                                                                        BOUND..........200
C *** PURPOSE :                                                          BOUND..........300
C ***  TO READ AND ORGANIZE DEFAULT VALUES FOR SPECIFIED PRESSURE DATA   BOUND..........400
C ***  AND SPECIFIED TEMPERATURE OR CONCENTRATION DATA.                  BOUND..........500
C                                                                        BOUND..........600
      SUBROUTINE BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT,IBCPBC,IBCUBC,      BOUND..........700
     1   GNUP1,GNUU1)                                                    BOUND..........800
      USE EXPINT                                                         BOUND..........900
c rbw begin change
      use ErrorFlag
c rbw end chagne
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BOUND.........1000
      CHARACTER INTFIL*1000                                              BOUND.........1100
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:13)                    BOUND.........1200
      DIMENSION IPBC(NBCN),PBC(NBCN),IUBC(NBCN),UBC(NBCN)                BOUND.........1300
      DIMENSION GNUP1(NBCN),GNUU1(NBCN)                                  BOUND.........1400
      DIMENSION INERR(10),RLERR(10)                                      BOUND.........1500
      INTEGER(1) IBCPBC(NBCN),IBCUBC(NBCN)                               BOUND.........1600
      DIMENSION KTYPE(2)                                                 BOUND.........1700
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BOUND.........1800
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           BOUND.........1900
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      BOUND.........2000
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BOUND.........2100
     1   NSOP,NSOU,NBCN,NCIDB                                            BOUND.........2200
      COMMON /FNAMES/ UNAME,FNAME                                        BOUND.........2300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 BOUND.........2400
     1   K10,K11,K12,K13                                                 BOUND.........2500
C                                                                        BOUND.........2600
C                                                                        BOUND.........2700
      IP=0                                                               BOUND.........3000
      IPU=0                                                              BOUND.........3100
      IF(NPBC.EQ.0) GOTO 400                                             BOUND.........3200
c rbw begin change
!      WRITE(K3,100)                                                      BOUND.........3300
c rbw end chagne
  100 FORMAT('1'////11X,'S P E C I F I E D   P R E S S U R E   D A T A'  BOUND.........3400
     1   ////11X,'**** NODES AT WHICH PRESSURES ARE SPECIFIED ****'/)    BOUND.........3500
!      IF(ME) 107,107,114                                                 BOUND.........3600
c rbw begin change
!  107 WRITE(K3,108)                                                      BOUND.........3700
c rbw end chagne
  108 FORMAT(16X,'(AS WELL AS SOLUTE CONCENTRATION OF ANY'               BOUND.........3800
     1   /16X,' FLUID INFLOW WHICH MAY OCCUR AT THE POINT'               BOUND.........3900
     2   /16X,' OF SPECIFIED PRESSURE)'                                  BOUND.........4000
     3  //12X,'NODE',10X,'DEFAULT PRESSURE',                             BOUND.........4100
     4     5X,'DEFAULT CONCENTRATION'//)                                 BOUND.........4200
      GOTO 125                                                           BOUND.........4300
c rbw begin change
!  114 WRITE(K3,115)                                                      BOUND.........4400
c rbw end chagne
  115 FORMAT(16X,'(AS WELL AS TEMPERATURE {DEGREES CELSIUS} OF ANY'      BOUND.........4500
     1   /16X,' FLUID INFLOW WHICH MAY OCCUR AT THE POINT'               BOUND.........4600
     2   /16X,' OF SPECIFIED PRESSURE)'                                  BOUND.........4700
     3  //12X,'NODE',10X,'DEFAULT PRESSURE',                             BOUND.........4800
     4     5X,'  DEFAULT TEMPERATURE'//)                                 BOUND.........4900
C                                                                        BOUND.........5000
C.....INPUT DATASET 19:  DATA FOR SPECIFIED PRESSURE NODES               BOUND.........5100
  125 IPU=IPU+1                                                          BOUND.........5200
      ERRCOD = 'REA-INP-19'                                              BOUND.........5300
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 BOUND.........5400
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IDUM                                BOUND.........5500
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        BOUND.........5600
      IF (INERR(1).NE.0) then
        IErrorFlag = 25
        return
      endif
c rbw end change
      IDUMA = IABS(IDUM)                                                 BOUND.........5700
      IF (IDUM.EQ.0) THEN                                                BOUND.........5800
         GOTO 180                                                        BOUND.........5900
      ELSE IF (IDUMA.GT.NN) THEN                                         BOUND.........6000
c rbw begin change
        IErrorFlag = 26
        return
!         ERRCOD = 'INP-19-1'                                             BOUND.........6100
!         INERR(1) = IDUMA                                                BOUND.........6200
!         INERR(2) = NN                                                   BOUND.........6300
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND.........6400
c rbw end change
      ELSE IF (IPU.GT.NPBC) THEN                                         BOUND.........6500
         GOTO 125                                                        BOUND.........6600
      END IF                                                             BOUND.........6700
      IPBC(IPU) = IDUM                                                   BOUND.........6800
      IF (IPBC(IPU).GT.0) THEN                                           BOUND.........6900
         ERRCOD = 'REA-INP-19'                                           BOUND.........7000
         READ(INTFIL,*,IOSTAT=INERR(1)) IPBC(IPU),PBC(IPU),UBC(IPU)      BOUND.........7100
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BOUND.........7200
         IF (INERR(1).NE.0) then
           IErrorFlag = 27
           return
         endif
!         WRITE(K3,160) IPBC(IPU),PBC(IPU),UBC(IPU)                       BOUND.........7300
c rbw end change
      ELSE IF (IPBC(IPU).LT.0) THEN                                      BOUND.........7400
         IPBCT = -1                                                      BOUND.........7500
c rbw begin change
!         WRITE(K3,160) IPBC(IPU)                                         BOUND.........7600
c rbw end change
      ELSE                                                               BOUND.........7700
         PBC(NBCN) = 0D0                                                 BOUND.........7750
         GOTO 180                                                        BOUND.........7800
      END IF                                                             BOUND.........7900
  160 FORMAT(7X,I9,6X,1PE20.13,6X,1PE20.13)                              BOUND.........8000
      GOTO 125                                                           BOUND.........8100
  180 IPU=IPU-1                                                          BOUND.........8200
      IP=IPU                                                             BOUND.........8300
      IF(IP.EQ.NPBC) GOTO 200                                            BOUND.........8400
c rbw begin change
           IErrorFlag = 28
           return
!      ERRCOD = 'INP-3,19-1'                                              BOUND.........8500
!      INERR(1) = IP                                                      BOUND.........8600
!      INERR(2) = NPBC                                                    BOUND.........8700
!      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           BOUND.........8800
  200  CONTINUE
!  200 IF(IPBCT.NE.-1) GOTO 250                                           BOUND.........8900
!      IF(ME) 205,205,215                                                 BOUND.........9000
!  205 WRITE(K3,206)                                                      BOUND.........9100
c rbw end change
  206 FORMAT(//12X,'TIME-DEPENDENT SPECIFIED PRESSURE OR INFLOW ',       BOUND.........9200
     1   'CONCENTRATION'/12X,'SET IN SUBROUTINE BCTIME IS INDICATED ',   BOUND.........9300
     2   'BY NEGATIVE NODE NUMBER')                                      BOUND.........9400
!      GOTO 250                                                           BOUND.........9500
c rbw begin change
!  215 WRITE(K3,216)                                                      BOUND.........9600
c rbw end change
  216 FORMAT(//12X,'TIME-DEPENDENT SPECIFIED PRESSURE OR INFLOW ',       BOUND.........9700
     1   'TEMPERATURE'/12X,'SET IN SUBROUTINE BCTIME IS INDICATED ',     BOUND.........9800
     2   'BY NEGATIVE NODE NUMBER')                                      BOUND.........9900
c rbw begin change
!  250 WRITE(K3,252)                                                      BOUND........10000
c rbw end change
  252 FORMAT(/11X,'SPECIFICATIONS MADE IN (OPTIONAL) ',                  BOUND........10100
     1   'BCS INPUT FILES TAKE PRECEDENCE OVER THE'/11X,                 BOUND........10200
     2   'DEFAULT VALUES LISTED ABOVE AND ANY VALUES ',                  BOUND........10300
     3   'SET IN SUBROUTINE BCTIME.')                                    BOUND........10400
C.....INITIALIZE GNUP1 ARRAY                                             BOUND........10500
      GNUP1 = GNUP                                                       BOUND........10600
C.....INITIALIZE ARRAY THAT INDICATES WHERE SPECIFIED-PRESSURE           BOUND........10700
C        CONDITIONS WERE SET (0 = INP FILE)                              BOUND........10800
      IBCPBC = 0                                                         BOUND........10900
C                                                                        BOUND........11000
  400 IF(NUBC.EQ.0) GOTO 9000                                            BOUND........11100
!      IF(ME) 500,500,550                                                 BOUND........11200
c rbw begin change
!  500 WRITE(K3,1000)                                                     BOUND........11300
c rbw end change
 1000 FORMAT('1'////11X,'S P E C I F I E D   C O N C E N T R A T I O N', BOUND........11400
     1   '   D A T A'                                                    BOUND........11500
     2   ////11X,'**** NODES AT WHICH SOLUTE CONCENTRATIONS ARE ',       BOUND........11600
     3   'SPECIFIED TO BE INDEPENDENT OF LOCAL FLOWS AND FLUID SOURCES', BOUND........11700
     4   ' ****'//12X,'NODE',5X,'DEFAULT CONCENTRATION'//)               BOUND........11800
      GOTO 1125                                                          BOUND........11900
c rbw begin change
!  550 WRITE(K3,1001)                                                     BOUND........12000
c rbw end change
 1001 FORMAT('1'////11X,'S P E C I F I E D   T E M P E R A T U R E',     BOUND........12100
     1   '   D A T A'                                                    BOUND........12200
     2   ////11X,'**** NODES AT WHICH TEMPERATURES ARE ',                BOUND........12300
     3   'SPECIFIED TO BE INDEPENDENT OF LOCAL FLOWS AND FLUID SOURCES', BOUND........12400
     4   ' ****'//12X,'NODE',5X,'  DEFAULT TEMPERATURE'//)               BOUND........12500
C                                                                        BOUND........12600
C.....INPUT DATASET 20:  DATA FOR SPECIFIED CONCENTRATION OR             BOUND........12700
C        TEMPERATURE NODES                                               BOUND........12800
 1125 IPU=IPU+1                                                          BOUND........12900
      ERRCOD = 'REA-INP-20'                                              BOUND........13000
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 BOUND........13100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 154
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IDUM                                BOUND........13200
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        BOUND........13300
      IF (INERR(1).NE.0) then
           IErrorFlag = 29
           return
      endif
c rbw end change
      IDUMA = IABS(IDUM)                                                 BOUND........13400
      IF (IDUM.EQ.0) THEN                                                BOUND........13500
         GOTO 1180                                                       BOUND........13600
      ELSE IF (IDUMA.GT.NN) THEN                                         BOUND........13700
c rbw begin change
           IErrorFlag = 30
           return
!         ERRCOD = 'INP-20-1'                                             BOUND........13800
!         INERR(1) = IDUMA                                                BOUND........13900
!         INERR(2) = NN                                                   BOUND........14000
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND........14100
c rbw end change
      ELSE IF (IPU.GT.NPBC+NUBC) THEN                                    BOUND........14200
         GOTO 1125                                                       BOUND........14300
      END IF                                                             BOUND........14400
      IUBC(IPU) = IDUM                                                   BOUND........14500
      IF (IUBC(IPU).GT.0) THEN                                           BOUND........14600
         ERRCOD = 'REA-INP-20'                                           BOUND........14700
         READ(INTFIL,*,IOSTAT=INERR(1)) IUBC(IPU),UBC(IPU)               BOUND........14800
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BOUND........14900
         IF (INERR(1).NE.0) then
           IErrorFlag = 31
           return
         endif
!         WRITE(K3,1150) IUBC(IPU),UBC(IPU)                               BOUND........15000
c rbw end change
      ELSE IF (IUBC(IPU).LT.0) THEN                                      BOUND........15100
         IUBCT = -1                                                      BOUND........15200
c rbw begin change
!         WRITE(K3,1150) IUBC(IPU)                                        BOUND........15300
c rbw end change
      ELSE                                                               BOUND........15400
         GOTO 1180                                                       BOUND........15500
      END IF                                                             BOUND........15600
 1150 FORMAT(7X,I9,6X,1PE20.13)                                          BOUND........15700
      GOTO 1125                                                          BOUND........15800
 1180 IPU=IPU-1                                                          BOUND........15900
      IU=IPU-IP                                                          BOUND........16000
      IF(IU.EQ.NUBC) GOTO 1200                                           BOUND........16100
c rbw begin change
           IErrorFlag = 32
           return
!      IF (ME.EQ.1) THEN                                                  BOUND........16200
!         ERRCOD = 'INP-3,20-2'                                           BOUND........16300
!      ELSE                                                               BOUND........16400
!         ERRCOD = 'INP-3,20-1'                                           BOUND........16500
!      END IF                                                             BOUND........16600
!      INERR(1) = IU                                                      BOUND........16700
!      INERR(2) = NUBC                                                    BOUND........16800
!      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           BOUND........16900
c rbw end change
c rbw begin change
 1200  continue
! 1200 IF(IUBCT.NE.-1) GOTO 6000                                          BOUND........17000
!      IF(ME) 1205,1205,1215                                              BOUND........17100
! 1205 WRITE(K3,1206)                                                     BOUND........17200
! 1206 FORMAT(//11X,'TIME-DEPENDENT SPECIFIED CONCENTRATIONS USER-',      BOUND........17300
!     1   'PROGRAMMED IN'/12X,'SUBROUTINE BCTIME ARE INDICATED BY ',      BOUND........17400
!     2   'A NEGATIVE NODE NUMBER.')                                      BOUND........17500
!      GOTO 6000                                                          BOUND........17600
! 1215 WRITE(K3,1216)                                                     BOUND........17700
! 1216 FORMAT(//11X,'TIME-DEPENDENT SPECIFIED TEMPERATURES USER-',        BOUND........17800
!     1   'PROGRAMMED IN'/12X,'SUBROUTINE BCTIME ARE INDICATED BY ',      BOUND........17900
!     2   'A NEGATIVE NODE NUMBER.')                                      BOUND........18000
! 6000 WRITE(K3,252)                                                      BOUND........18100
c rbw end change
C.....INITIALIZE GNUU1 ARRAY                                             BOUND........18200
      GNUU1 = GNUU                                                       BOUND........18300
C.....INITIALIZE ARRAY THAT INDICATES WHERE SPECIFIED-CONC OR TEMP       BOUND........18400
C        CONDITIONS WERE SET (0 = INP FILE)                              BOUND........18500
      IBCUBC = 0                                                         BOUND........18600
C                                                                        BOUND........18700
C                                                                        BOUND........18800
 9000 RETURN                                                             BOUND........18900
      END                                                                BOUND........19000
C                                                                        BOUND........19100
C     SUBROUTINE        B  O  U  N  D  1           SUTRA VERSION 2.2     BOUND1.........100
C                                                                        BOUND1.........200
C *** PURPOSE :                                                          BOUND1.........300
C ***  TO READ AND ORGANIZE TIME-DEPENDENT SPECIFIED PRESSURE DATA AND   BOUND1.........400
C ***  SPECIFIED TEMPERATURE OR CONCENTRATION DATA SPECIFIED IN THE      BOUND1.........500
C ***  OPTIONAL BCS INPUT FILE.                                          BOUND1.........600
C                                                                        BOUND1.........700
      SUBROUTINE BOUND1(IPBC1,PBC1,IUBC1,UBC1,IPBCT1,IUBCT1,             BOUND1.........800
     1   NPBC1,NUBC1,NBCN1,NFB,BCSID)                                    BOUND1.........900
      USE EXPINT                                                         BOUND1........1000
c rbw begin change
      use ErrorFlag
c rbw end chagne
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BOUND1........1100
      CHARACTER INTFIL*1000                                              BOUND1........1200
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:13)                    BOUND1........1300
      CHARACTER*40 BCSID                                                 BOUND1........1400
      DIMENSION IPBC1(NBCN1),PBC1(NBCN1),IUBC1(NBCN1),UBC1(NBCN1)        BOUND1........1500
      DIMENSION INERR(10),RLERR(10)                                      BOUND1........1600
      DIMENSION KTYPE(2)                                                 BOUND1........1700
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BOUND1........1800
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           BOUND1........1900
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      BOUND1........2000
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BOUND1........2100
     1   NSOP,NSOU,NBCN,NCIDB                                            BOUND1........2200
      COMMON /FNAMES/ UNAME,FNAME                                        BOUND1........2300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 BOUND1........2400
     1   K10,K11,K12,K13                                                 BOUND1........2500
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       BOUND1........2600
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART      BOUND1........2700
C                                                                        BOUND1........2800
C                                                                        BOUND1........2900
      IP = 0                                                             BOUND1........3000
      IPU = 0                                                            BOUND1........3100
      IPBCT1 = +1                                                        BOUND1........3200
      IUBCT1 = +1                                                        BOUND1........3300
C                                                                        BOUND1........3400
      IF (NPBC1.EQ.0) GOTO 400                                           BOUND1........3500
C                                                                        BOUND1........3600
C.....INPUT BCS DATASET 5:  DATA FOR SPECIFIED PRESSURE NODES            BOUND1........3700
      IPBCT1 = -1                                                        BOUND1........3800
  125 IPU = IPU + 1                                                      BOUND1........3900
      ERRCOD = 'REA-BCS-5'                                               BOUND1........4000
c rbw begin change
!      WRITE(CHERR(1),*) ITBCS                                            BOUND1........4100
c rbw end change
      CHERR(2) = BCSID                                                   BOUND1........4200
      CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)                        BOUND1........4300
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IDUM                                BOUND1........4400
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        BOUND1........4500
      IF (INERR(1).NE.0) then
         IErrorFlag = 153
         return
      endif
c rbw end change
      IDUMA = IABS(IDUM)                                                 BOUND1........4600
      IF (IDUM.EQ.0) THEN                                                BOUND1........4700
         GOTO 180                                                        BOUND1........4800
      ELSE IF (IDUMA.GT.NN) THEN                                         BOUND1........4900
c rbw begin change
         IErrorFlag = 153
         return
!         ERRCOD = 'BCS-5-1'                                              BOUND1........5000
!         INERR(1) = IDUMA                                                BOUND1........5100
!         INERR(2) = NN                                                   BOUND1........5200
!         INERR(3) = ITBCS                                                BOUND1........5300
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND1........5400
c rbw end change
      ELSE IF (IPU.GT.NPBC1) THEN                                        BOUND1........5500
         GOTO 125                                                        BOUND1........5600
      END IF                                                             BOUND1........5700
      IPBC1(IPU) = IDUM                                                  BOUND1........5800
      IF (IPBC1(IPU).GT.0) THEN                                          BOUND1........5900
         ERRCOD = 'REA-BCS-5'                                            BOUND1........6000
c rbw begin change
!         WRITE(CHERR(1),*) ITBCS                                         BOUND1........6100
c rbw end change
         CHERR(2) = BCSID                                                BOUND1........6200
         READ(INTFIL,*,IOSTAT=INERR(1))                                  BOUND1........6300
     1      IPBC1(IPU),PBC1(IPU),UBC1(IPU)                               BOUND1........6400
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BOUND1........6500
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      ELSE IF (IPBC1(IPU).LT.0) THEN                                     BOUND1........6600
         CONTINUE                                                        BOUND1........6700
      ELSE                                                               BOUND1........6800
         GOTO 180                                                        BOUND1........6900
      END IF                                                             BOUND1........7000
      GOTO 125                                                           BOUND1........7100
  180 IPU = IPU - 1                                                      BOUND1........7200
      IP = IPU                                                           BOUND1........7300
      IF (IP.EQ.NPBC1) GOTO 400                                          BOUND1........7400
c rbw begin change
           IErrorFlag = 153
           return
!      ERRCOD = 'BCS-2,5-1'                                               BOUND1........7500
!      INERR(1) = IP                                                      BOUND1........7600
!      INERR(2) = NPBC1                                                   BOUND1........7700
!      INERR(3) = ITBCS                                                   BOUND1........7800
!      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           BOUND1........7900
c rbw end change
C                                                                        BOUND1........8000
  400 IF(NUBC1.EQ.0) GOTO 8000                                           BOUND1........8100
C                                                                        BOUND1........8200
C.....INPUT BCS DATASET 6:  DATA FOR SPECIFIED CONCENTRATION OR          BOUND1........8300
C        TEMPERATURE NODES                                               BOUND1........8400
      IUBCT1 = -1                                                        BOUND1........8500
 1125 IPU = IPU + 1                                                      BOUND1........8600
      ERRCOD = 'REA-BCS-6'                                               BOUND1........8700
c rbw begin change
!      WRITE(CHERR(1),*) ITBCS                                            BOUND1........8800
c rbw end change
      CHERR(2) = BCSID                                                   BOUND1........8900
      CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)                        BOUND1........9000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IDUM                                BOUND1........9100
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        BOUND1........9200
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      IDUMA = IABS(IDUM)                                                 BOUND1........9300
      IF (IDUM.EQ.0) THEN                                                BOUND1........9400
         GOTO 1180                                                       BOUND1........9500
      ELSE IF (IDUMA.GT.NN) THEN                                         BOUND1........9600
c rbw begin change
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-6-1'                                              BOUND1........9700
!         INERR(1) = IDUMA                                                BOUND1........9800
!         INERR(2) = NN                                                   BOUND1........9900
!         INERR(3) = ITBCS                                                BOUND1.......10000
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND1.......10100
c rbw end change
      ELSE IF (IPU.GT.NPBC1+NUBC1) THEN                                  BOUND1.......10200
         GOTO 1125                                                       BOUND1.......10300
      END IF                                                             BOUND1.......10400
      IUBC1(IPU) = IDUM                                                  BOUND1.......10500
      IF (IUBC1(IPU).GT.0) THEN                                          BOUND1.......10600
         ERRCOD = 'REA-BCS-6'                                            BOUND1.......10700
c rbw begin change
!         WRITE(CHERR(1),*) ITBCS                                         BOUND1.......10800
c rbw end change
         CHERR(2) = BCSID                                                BOUND1.......10900
         READ(INTFIL,*,IOSTAT=INERR(1)) IUBC1(IPU),UBC1(IPU)             BOUND1.......11000
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BOUND1.......11100
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      ELSE IF (IUBC1(IPU).LT.0) THEN                                     BOUND1.......11200
         CONTINUE                                                        BOUND1.......11300
      ELSE                                                               BOUND1.......11400
         GOTO 1180                                                       BOUND1.......11500
      END IF                                                             BOUND1.......11600
      GOTO 1125                                                          BOUND1.......11700
 1180 IPU = IPU - 1                                                      BOUND1.......11800
      IU = IPU - IP                                                      BOUND1.......11900
      IF (IU.EQ.NUBC1) GOTO 8000                                         BOUND1.......12000
c rbw begin change
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-2,6-1'                                            BOUND1.......12100
!         IF (ME.EQ.1) THEN                                               BOUND1.......12200
!            CHERR(1) = ' temperature '                                   BOUND1.......12300
!         ELSE                                                            BOUND1.......12400
!            CHERR(1) = 'concentration'                                   BOUND1.......12500
!         END IF                                                          BOUND1.......12600
!         INERR(1) = IU                                                   BOUND1.......12700
!         INERR(2) = NUBC1                                                BOUND1.......12800
!         INERR(3) = ITBCS                                                BOUND1.......12900
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND1.......13000
c rbw end change
C                                                                        BOUND1.......13100
 8000 CONTINUE                                                           BOUND1.......13200
C                                                                        BOUND1.......13300
      RETURN                                                             BOUND1.......13400
      END                                                                BOUND1.......13500
C                                                                        BOUND1.......13600
C     SUBROUTINE        B  U  D  G  E  T           SUTRA VERSION 2.2     BUDGET.........100
C                                                                        BUDGET.........200
C *** PURPOSE :                                                          BUDGET.........300
C ***  TO CALCULATE AND OUTPUT FLUID MASS AND SOLUTE MASS OR             BUDGET.........400
C ***  ENERGY BUDGETS.                                                   BUDGET.........500
C                                                                        BUDGET.........600
      SUBROUTINE BUDGET(ML,IBCT,VOL,SW,DSWDP,RHO,SOP,QIN,PVEC,PM1,       BUDGET.........700
     1   DPDTITR,PBC,QPLITR,IPBC,IQSOP,POR,UVEC,UM1,UM2,UIN,QUIN,QINITR, BUDGET.........800
     2   IQSOU,UBC,IUBC,CS1,CS2,CS3,SL,SR,NREG,GNUP1,GNUU1,              BUDGET.........900
     3   IBCSOP,IBCSOU)                                                  BUDGET........1000
c rbw begin change
      use ErrorFlag
c rbw end change
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BUDGET........1100
      CHARACTER*10 ADSMOD                                                BUDGET........1200
      CHARACTER*13 ULABL(2)                                              BUDGET........1300
      INTEGER(1) IBCSOP(NSOP),IBCSOU(NSOU)                               BUDGET........1400
      DIMENSION QIN(NN),UIN(NN),IQSOP(NSOP),QUIN(NN),QINITR(NN),         BUDGET........1500
     1   IQSOU(NSOU)                                                     BUDGET........1600
      DIMENSION IPBC(NBCN),IUBC(NBCN),UBC(NBCN),QPLITR(NBCN),PBC(NBCN),  BUDGET........1700
     1   GNUP1(NBCN),GNUU1(NBCN)                                         BUDGET........1800
      DIMENSION POR(NN),VOL(NN),PVEC(NNVEC),UVEC(NNVEC),SW(NN),          BUDGET........1900
     1   DSWDP(NN),RHO(NN),SOP(NN),PM1(NN),DPDTITR(NN),UM1(NN),UM2(NN),  BUDGET........2000
     2   CS1(NN),CS2(NN),CS3(NN),SL(NN),SR(NN),NREG(NN)                  BUDGET........2100
      DIMENSION KTYPE(2)                                                 BUDGET........2200
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BUDGET........2300
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           BUDGET........2400
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      BUDGET........2500
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BUDGET........2600
     1   NSOP,NSOU,NBCN,NCIDB                                            BUDGET........2700
      COMMON /DIMX2/ NELTA,NNVEC,NDIMIA,NDIMJA                           BUDGET........2800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 BUDGET........2900
     1   K10,K11,K12,K13                                                 BUDGET........3000
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      BUDGET........3100
      COMMON /MODSOR/ ADSMOD                                             BUDGET........3200
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      BUDGET........3300
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        BUDGET........3400
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       BUDGET........3500
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART      BUDGET........3600
      DATA ULABL(1)/'CONCENTRATION'/,ULABL(2)/' TEMPERATURE '/           BUDGET........3700
      SAVE ULABL                                                         BUDGET........3800
C                                                                        BUDGET........3900
C                                                                        BUDGET........4000
      MN=2                                                               BUDGET........4100
      IF(IUNSAT.NE.0) IUNSAT=1                                           BUDGET........4200
      IF(ME.EQ.-1) MN=1                                                  BUDGET........4300
c rbw begin change
!      WRITE(K3,10)                                                       BUDGET........4400
c rbw end change
   10 FORMAT('1')                                                        BUDGET........4500
C.....SET UNSATURATED FLOW PARAMETERS, SW(I) AND DSWDP(I)                BUDGET........4600
      IF(IUNSAT-1) 40,20,40                                              BUDGET........4700
   20 DO 30 I=1,NN                                                       BUDGET........4800
      IF(PVEC(I)) 25,27,27                                               BUDGET........4900
   25 CALL UNSAT(SW(I),DSWDP(I),RELK,PVEC(I),NREG(I))                    BUDGET........5000
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      GOTO 30                                                            BUDGET........5100
   27 SW(I)=1.0D0                                                        BUDGET........5200
      DSWDP(I)=0.0D0                                                     BUDGET........5300
   30 CONTINUE                                                           BUDGET........5400
C                                                                        BUDGET........5500
C.....CALCULATE COMPONENTS OF FLUID MASS BUDGET                          BUDGET........5600
   40 IF(ML-1) 50,50,1000                                                BUDGET........5700
   50 CONTINUE                                                           BUDGET........5800
      STPPOS = 0D0                                                       BUDGET........5900
      STPNEG = 0D0                                                       BUDGET........6000
      STUPOS = 0D0                                                       BUDGET........6100
      STUNEG = 0D0                                                       BUDGET........6200
      QINPOS = 0D0                                                       BUDGET........6300
      QINNEG = 0D0                                                       BUDGET........6400
      DO 100 I=1,NN                                                      BUDGET........6500
      TERM = (1-ISSFLO/2)*RHO(I)*VOL(I)*                                 BUDGET........6600
     1   (SW(I)*SOP(I)+POR(I)*DSWDP(I))*(PVEC(I)-PM1(I))/DELTP           BUDGET........6700
      STPPOS = STPPOS + MAX(0D0, TERM)                                   BUDGET........6800
      STPNEG = STPNEG + MIN(0D0, TERM)                                   BUDGET........6900
      TERM = (1-ISSFLO/2)*POR(I)*SW(I)*DRWDU*VOL(I)*                     BUDGET........7000
     1   (UM1(I)-UM2(I))/DLTUM1                                          BUDGET........7100
      STUPOS = STUPOS + MAX(0D0, TERM)                                   BUDGET........7200
      STUNEG = STUNEG + MIN(0D0, TERM)                                   BUDGET........7300
      TERM = QIN(I)                                                      BUDGET........7400
      QINPOS = QINPOS + MAX(0D0, TERM)                                   BUDGET........7500
      QINNEG = QINNEG + MIN(0D0, TERM)                                   BUDGET........7600
  100 CONTINUE                                                           BUDGET........7700
      STPTOT = STPPOS + STPNEG                                           BUDGET........7800
      STUTOT = STUPOS + STUNEG                                           BUDGET........7900
      STFPOS = STPPOS + STUPOS                                           BUDGET........8000
      STFNEG = STPNEG + STUNEG                                           BUDGET........8100
      STFTOT = STPTOT + STUTOT                                           BUDGET........8200
      QINTOT = QINPOS + QINNEG                                           BUDGET........8300
C                                                                        BUDGET........8400
      QPLPOS = 0D0                                                       BUDGET........8500
      QPLNEG = 0D0                                                       BUDGET........8600
      DO 200 IP=1,NPBC                                                   BUDGET........8700
      I=IABS(IPBC(IP))                                                   BUDGET........8800
      TERM = GNUP1(IP)*(PBC(IP)-PVEC(I))                                 BUDGET........8900
      QPLPOS = QPLPOS + MAX(0D0, TERM)                                   BUDGET........9000
      QPLNEG = QPLNEG + MIN(0D0, TERM)                                   BUDGET........9100
  200 CONTINUE                                                           BUDGET........9200
      QPLTOT = QPLPOS + QPLNEG                                           BUDGET........9300
      QFFPOS = QINPOS + QPLPOS                                           BUDGET........9400
      QFFNEG = QINNEG + QPLNEG                                           BUDGET........9500
      QFFTOT = QINTOT + QPLTOT                                           BUDGET........9600
C                                                                        BUDGET........9700
C.....OUTPUT FLUID MASS BUDGET                                           BUDGET........9800
      ACTFMB = 5D-1*(STFPOS - STFNEG + QFFPOS - QFFNEG)                  BUDGET........9900
      ERFMBA = STFTOT - QFFTOT                                           BUDGET.......10000
c rbw begin change
!      WRITE(K3,300) IT,STPPOS,STPNEG,STPTOT,                             BUDGET.......10100
!     1   ULABL(MN),STUPOS,STUNEG,STUTOT,STFPOS,STFNEG,STFTOT,            BUDGET.......10200
!     2   QINPOS,QINNEG,QINTOT,QPLPOS,QPLNEG,QPLTOT,                      BUDGET.......10300
!     3   QFFPOS,QFFNEG,QFFTOT,ACTFMB,ERFMBA                              BUDGET.......10400
c rbw end change
  300 FORMAT(//11X,'F L U I D   M A S S   B U D G E T      AFTER TIME',  BUDGET.......10500
     1   ' STEP ',I8,',     IN (MASS/SECOND)'                            BUDGET.......10600
     2   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'INCREASES(+)',4X,    BUDGET.......10700
     3   'DECREASES(-)',7X,'CHANGE'/84X,3(2X,14('='))                    BUDGET.......10800
     4   /13X,'RATE OF CHANGE IN TOTAL STORED FLUID DUE TO PRESSURE',    BUDGET.......10900
     5   ' CHANGE',12X,3(1X,1PE15.7)                                     BUDGET.......11000
     6   /13X,'RATE OF CHANGE IN TOTAL STORED FLUID DUE TO ',A13,        BUDGET.......11100
     7   ' CHANGE',7X,3(1X,1PE15.7)/84X,3(2X,14('-'))                    BUDGET.......11200
     8   /13X,'TOTAL RATE OF CHANGE IN STORED FLUID [ S+, S-, S ]',      BUDGET.......11300
     9   21X,3(1X,1PE15.7)                                               BUDGET.......11400
     T   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/89X,'GAINS(+)',7X,        BUDGET.......11500
     1   'LOSSES(-)',7X,'GAIN/LOSS'/84X,3(2X,14('='))                    BUDGET.......11600
     2   /13X,'GAIN/LOSS OF FLUID THROUGH FLUID SOURCES AND SINKS',      BUDGET.......11700
     3   21X,3(1X,1PE15.7)                                               BUDGET.......11800
     4   /13X,'GAIN/LOSS OF FLUID THROUGH INFLOWS/OUTFLOWS AT'           BUDGET.......11900
     5   ' SPECIFIED P NODES',7X,3(1X,1PE15.7)/84X,3(2X,14('-'))         BUDGET.......12000
     6   /13X,'TOTAL RATE OF GAIN/LOSS OF FLUID THROUGH FLOWS',          BUDGET.......12100
     7   ' [ F+, F-, F ]',11X,3(1X,1PE15.7)                              BUDGET.......12200
     8   ///13X,'FLUID MASS BALANCE ACTIVITY',                           BUDGET.......12300
     9   ' [ A = ((S+) - (S-) + (F+) - (F-))/2 ]',14X,1PE15.7            BUDGET.......12400
     T   /13X,'ABSOLUTE FLUID MASS BALANCE ERROR [ S - F ]',36X,1PE15.7) BUDGET.......12500
      IF (ACTFMB.NE.0D0) THEN                                            BUDGET.......12600
         ERFMBR = 1D2*ERFMBA/ACTFMB                                      BUDGET.......12700
c rbw begin change
!         WRITE(K3,301) ERFMBR                                            BUDGET.......12800
!      ELSE                                                               BUDGET.......12900
!         WRITE(K3,302)                                                   BUDGET.......13000
c rbw end change
      END IF                                                             BUDGET.......13100
  301 FORMAT(13X,'RELATIVE FLUID MASS BALANCE ERROR',                    BUDGET.......13200
     1   ' [ 100*(S - F)/A ]',28X,1PE15.7,' (PERCENT)')                  BUDGET.......13300
  302 FORMAT(13X,'RELATIVE FLUID MASS BALANCE ERROR',                    BUDGET.......13400
     1   ' [ 100*(S - F)/A ]',28X,'  UNDEFINED')                         BUDGET.......13500
C                                                                        BUDGET.......13600
      IF(IBCT.EQ.4) GOTO 600                                             BUDGET.......13700
      NSOPI=NSOP-1                                                       BUDGET.......13800
      INEGCT=0                                                           BUDGET.......13900
      DO 500 IQP=1,NSOPI                                                 BUDGET.......14000
      I=IQSOP(IQP)                                                       BUDGET.......14100
      IF (IBCSOP(IQP).EQ.-1) THEN                                        BUDGET.......14200
         INEGCT = INEGCT + 1                                             BUDGET.......14300
         IF (INEGCT.EQ.1) WRITE(K3,350)                                  BUDGET.......14400
  350    FORMAT(///22X,'TIME-DEPENDENT FLUID SOURCES OR SINKS SET IN ',  BUDGET.......14500
     1      'SUBROUTINE BCTIME'//22X,' NODE',5X,'INFLOW(+)/OUTFLOW(-)'   BUDGET.......14600
     2      /37X,'  (MASS/SECOND)'//)                                    BUDGET.......14700
c rbw begin change
!         WRITE(K3,450) -I,QIN(-I)                                        BUDGET.......14800
c rbw end change
  450    FORMAT(18X,I9,10X,1PE15.7)                                      BUDGET.......14900
      END IF                                                             BUDGET.......15000
  500 CONTINUE                                                           BUDGET.......15100
C                                                                        BUDGET.......15200
  600 IF(NPBC.EQ.0) GOTO 800                                             BUDGET.......15300
c rbw begin change
!      WRITE(K3,650)                                                      BUDGET.......15400
c rbw end change
  650 FORMAT(///22X,'FLUID SOURCES OR SINKS DUE TO SPECIFIED PRESSURES', BUDGET.......15500
     1   //22X,' NODE',5X,'INFLOW(+)/OUTFLOW(-)'/37X,'  (MASS/SECOND)'/) BUDGET.......15600
      DO 700 IP=1,NPBC                                                   BUDGET.......15700
      I=IABS(IPBC(IP))                                                   BUDGET.......15800
c rbw begin change
!      WRITE(K3,450) I, GNUP1(IP)*(PBC(IP)-PVEC(I))                       BUDGET.......15900
c rbw end change
  700 CONTINUE                                                           BUDGET.......16000
C                                                                        BUDGET.......16100
C.....CALCULATE COMPONENTS OF ENERGY OR SOLUTE MASS BUDGET               BUDGET.......16200
  800 IF(ML-1) 1000,5500,1000                                            BUDGET.......16300
 1000 CONTINUE                                                           BUDGET.......16400
      FLDPOS = 0D0                                                       BUDGET.......16500
      FLDNEG = 0D0                                                       BUDGET.......16600
      SLDPOS = 0D0                                                       BUDGET.......16700
      SLDNEG = 0D0                                                       BUDGET.......16800
      DNSPOS = 0D0                                                       BUDGET.......16900
      DNSNEG = 0D0                                                       BUDGET.......17000
      P1FPOS = 0D0                                                       BUDGET.......17100
      P1FNEG = 0D0                                                       BUDGET.......17200
      P1SPOS = 0D0                                                       BUDGET.......17300
      P1SNEG = 0D0                                                       BUDGET.......17400
      P0FPOS = 0D0                                                       BUDGET.......17500
      P0FNEG = 0D0                                                       BUDGET.......17600
      P0SPOS = 0D0                                                       BUDGET.......17700
      P0SNEG = 0D0                                                       BUDGET.......17800
      QQUPOS = 0D0                                                       BUDGET.......17900
      QQUNEG = 0D0                                                       BUDGET.......18000
      QIUPOS = 0D0                                                       BUDGET.......18100
      QIUNEG = 0D0                                                       BUDGET.......18200
C.....SET ADSORPTION PARAMETERS                                          BUDGET.......18300
      IF(ME.EQ.-1.AND.ADSMOD.NE.'NONE      ')                            BUDGET.......18400
     1   CALL ADSORB(CS1,CS2,CS3,SL,SR,UVEC)                             BUDGET.......18500
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      DO 1300 I=1,NN                                                     BUDGET.......18600
      ESRV=POR(I)*SW(I)*RHO(I)*VOL(I)                                    BUDGET.......18700
      EPRSV=(1.D0-POR(I))*RHOS*VOL(I)                                    BUDGET.......18800
      DUDT=(1-ISSTRA)*(UVEC(I)-UM1(I))/DELTU                             BUDGET.......18900
      TERM = ESRV*CW*DUDT                                                BUDGET.......19000
      FLDPOS = FLDPOS + MAX(0D0, TERM)                                   BUDGET.......19100
      FLDNEG = FLDNEG + MIN(0D0, TERM)                                   BUDGET.......19200
      TERM = EPRSV*CS1(I)*DUDT                                           BUDGET.......19300
      SLDPOS = SLDPOS + MAX(0D0, TERM)                                   BUDGET.......19400
      SLDNEG = SLDNEG + MIN(0D0, TERM)                                   BUDGET.......19500
      TERM = CW*UVEC(I)*(1-ISSFLO/2)*VOL(I)*                             BUDGET.......19600
     1   (RHO(I)*(SW(I)*SOP(I)+POR(I)*DSWDP(I))*DPDTITR(I)               BUDGET.......19700
     2   +POR(I)*SW(I)*DRWDU*(UM1(I)-UM2(I))/DLTUM1)                     BUDGET.......19800
      DNSPOS = DNSPOS + MAX(0D0, TERM)                                   BUDGET.......19900
      DNSNEG = DNSNEG + MIN(0D0, TERM)                                   BUDGET.......20000
      TERM = ESRV*PRODF1*UVEC(I)                                         BUDGET.......20100
      P1FPOS = P1FPOS + MAX(0D0, TERM)                                   BUDGET.......20200
      P1FNEG = P1FNEG + MIN(0D0, TERM)                                   BUDGET.......20300
      TERM = EPRSV*PRODS1*(SL(I)*UVEC(I)+SR(I))                          BUDGET.......20400
      P1SPOS = P1SPOS + MAX(0D0, TERM)                                   BUDGET.......20500
      P1SNEG = P1SNEG + MIN(0D0, TERM)                                   BUDGET.......20600
      TERM = ESRV*PRODF0                                                 BUDGET.......20700
      P0FPOS = P0FPOS + MAX(0D0, TERM)                                   BUDGET.......20800
      P0FNEG = P0FNEG + MIN(0D0, TERM)                                   BUDGET.......20900
      TERM = EPRSV*PRODS0                                                BUDGET.......21000
      P0SPOS = P0SPOS + MAX(0D0, TERM)                                   BUDGET.......21100
      P0SNEG = P0SNEG + MIN(0D0, TERM)                                   BUDGET.......21200
      TERM = QUIN(I)                                                     BUDGET.......21300
      QQUPOS = QQUPOS + MAX(0D0, TERM)                                   BUDGET.......21400
      QQUNEG = QQUNEG + MIN(0D0, TERM)                                   BUDGET.......21500
      IF (QINITR(I).LE.0D0) THEN                                         BUDGET.......21600
         TERM = QINITR(I)*CW*UVEC(I)                                     BUDGET.......21700
      ELSE                                                               BUDGET.......21800
         TERM = QINITR(I)*CW*UIN(I)                                      BUDGET.......21900
      END IF                                                             BUDGET.......22000
      QIUPOS = QIUPOS + MAX(0D0, TERM)                                   BUDGET.......22100
      QIUNEG = QIUNEG + MIN(0D0, TERM)                                   BUDGET.......22200
 1300 CONTINUE                                                           BUDGET.......22300
      FLDTOT = FLDPOS + FLDNEG                                           BUDGET.......22400
      SLDTOT = SLDPOS + SLDNEG                                           BUDGET.......22500
      DNSTOT = DNSPOS + DNSNEG                                           BUDGET.......22600
      STSPOS = FLDPOS + SLDPOS + DNSPOS                                  BUDGET.......22700
      STSNEG = FLDNEG + SLDNEG + DNSNEG                                  BUDGET.......22800
      STSTOT = FLDTOT + SLDTOT + DNSTOT                                  BUDGET.......22900
      P1FTOT = P1FPOS + P1FNEG                                           BUDGET.......23000
      P1STOT = P1SPOS + P1SNEG                                           BUDGET.......23100
      P0FTOT = P0FPOS + P0FNEG                                           BUDGET.......23200
      P0STOT = P0SPOS + P0SNEG                                           BUDGET.......23300
      PRSPOS = P1FPOS + P1SPOS + P0FPOS + P0SPOS                         BUDGET.......23400
      PRSNEG = P1FNEG + P1SNEG + P0FNEG + P0SNEG                         BUDGET.......23500
      PRSTOT = P1FTOT + P1STOT + P0FTOT + P0STOT                         BUDGET.......23600
      QQUTOT = QQUPOS + QQUNEG                                           BUDGET.......23700
      QIUTOT = QIUPOS + QIUNEG                                           BUDGET.......23800
C                                                                        BUDGET.......23900
      QPUPOS = 0D0                                                       BUDGET.......24000
      QPUNEG = 0D0                                                       BUDGET.......24100
      DO 1500 IP=1,NPBC                                                  BUDGET.......24200
      IF (QPLITR(IP).LE.0D0) THEN                                        BUDGET.......24300
         I=IABS(IPBC(IP))                                                BUDGET.......24400
         TERM = QPLITR(IP)*CW*UVEC(I)                                    BUDGET.......24500
      ELSE                                                               BUDGET.......24600
         TERM = QPLITR(IP)*CW*UBC(IP)                                    BUDGET.......24700
      END IF                                                             BUDGET.......24800
      QPUPOS = QPUPOS + MAX(0D0, TERM)                                   BUDGET.......24900
      QPUNEG = QPUNEG + MIN(0D0, TERM)                                   BUDGET.......25000
 1500 CONTINUE                                                           BUDGET.......25100
      QPUTOT = QPUPOS + QPUNEG                                           BUDGET.......25200
C                                                                        BUDGET.......25300
      QULPOS = 0D0                                                       BUDGET.......25400
      QULNEG = 0D0                                                       BUDGET.......25500
      QULTOT = 0D0                                                       BUDGET.......25600
      IF(NUBC.EQ.0) GOTO 1520                                            BUDGET.......25700
      DO 1510 IU=1,NUBC                                                  BUDGET.......25800
      IUP=IU+NPBC                                                        BUDGET.......25900
      I=IABS(IUBC(IUP))                                                  BUDGET.......26000
      QPLITR(IUP)=GNUU1(IUP)*(UBC(IUP)-UVEC(I))                          BUDGET.......26100
      TERM = QPLITR(IUP)                                                 BUDGET.......26200
      QULPOS = QULPOS + MAX(0D0, TERM)                                   BUDGET.......26300
      QULNEG = QULNEG + MIN(0D0, TERM)                                   BUDGET.......26400
 1510 CONTINUE                                                           BUDGET.......26500
 1520 QULTOT = QULPOS + QULNEG                                           BUDGET.......26600
      QFSPOS = QIUPOS + QPUPOS + QQUPOS + QULPOS                         BUDGET.......26700
      QFSNEG = QIUNEG + QPUNEG + QQUNEG + QULNEG                         BUDGET.......26800
      QFSTOT = QIUTOT + QPUTOT + QQUTOT + QULTOT                         BUDGET.......26900
C                                                                        BUDGET.......27000
 1540 IF(ME) 1550,1550,1615                                              BUDGET.......27100
C                                                                        BUDGET.......27200
C.....OUTPUT SOLUTE MASS BUDGET                                          BUDGET.......27300
 1550 ACTSMB = 5D-1*(STSPOS - STSNEG + PRSPOS - PRSNEG                   BUDGET.......27400
     1   + QFSPOS - QFSNEG)                                              BUDGET.......27500
      ERSMBA = STSTOT - PRSTOT - QFSTOT                                  BUDGET.......27600
c rbw begin change
!      WRITE(K3,1600) IT,FLDPOS,FLDNEG,FLDTOT,SLDPOS,SLDNEG,SLDTOT,       BUDGET.......27700
!     1   DNSPOS,DNSNEG,DNSTOT,STSPOS,STSNEG,STSTOT,                      BUDGET.......27800
!     2   P1FPOS,P1FNEG,P1FTOT,P1SPOS,P1SNEG,P1STOT,                      BUDGET.......27900
!     3   P0FPOS,P0FNEG,P0FTOT,P0SPOS,P0SNEG,P0STOT,PRSPOS,PRSNEG,PRSTOT, BUDGET.......28000
!     4   QIUPOS,QIUNEG,QIUTOT,QPUPOS,QPUNEG,QPUTOT,                      BUDGET.......28100
!     5   QQUPOS,QQUNEG,QQUTOT,QULPOS,QULNEG,QULTOT,QFSPOS,QFSNEG,QFSTOT, BUDGET.......28200
!     6   ACTSMB,ERSMBA                                                   BUDGET.......28300
c rbw end change
 1600 FORMAT(//11X,'S O L U T E   B U D G E T      AFTER TIME STEP ',I8, BUDGET.......28400
     1   ',   IN (SOLUTE MASS/SECOND)'                                   BUDGET.......28500
     2   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'INCREASES(+)',4X,    BUDGET.......28600
     3   'DECREASES(-)',7X,'CHANGE'/84X,3(2X,14('='))                    BUDGET.......28700
     4   /13X,'RATE OF CHANGE IN SOLUTE DUE TO CONCENTRATION CHANGE',    BUDGET.......28800
     5   19X,3(1X,1PE15.7)                                               BUDGET.......28900
     6   /13X,'RATE OF CHANGE OF ADSORBATE',44X,3(1X,1PE15.7)            BUDGET.......29000
     7   /13X,'RATE OF CHANGE IN SOLUTE DUE TO CHANGE IN MASS OF FLUID', BUDGET.......29100
     8   16X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......29200
     9   /13X,'TOTAL RATE OF CHANGE OF SOLUTE [ S+, S-, S ]',            BUDGET.......29300
     T   27X,3(1X,1PE15.7)                                               BUDGET.......29400
     1   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'PRODUCTION(+)',5X,   BUDGET.......29500
     2   'DECAY(-)',7X,'PROD./DECAY'/84X,3(2X,14('='))                   BUDGET.......29600
     3   /13X,'FIRST-ORDER PRODUCTION/DECAY OF SOLUTE',33X,3(1X,1PE15.7) BUDGET.......29700
     4   /13X,'FIRST-ORDER PRODUCTION/DECAY OF ADSORBATE',               BUDGET.......29800
     5   30X,3(1X,1PE15.7)                                               BUDGET.......29900
     6   /13X,'ZERO-ORDER PRODUCTION/DECAY OF SOLUTE',34X,3(1X,1PE15.7)  BUDGET.......30000
     7   /13X,'ZERO-ORDER PRODUCTION/DECAY OF ADSORBATE',                BUDGET.......30100
     8   31X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......30200
     9   /13X,'TOTAL RATE OF PRODUCTION/DECAY OF SOLUTE AND ADSORBATE',  BUDGET.......30300
     T   ' [ P+, P-, P ]',3X,3(1X,1PE15.7)                               BUDGET.......30400
     1   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/89X,'GAINS(+)',7X,        BUDGET.......30500
     2   'LOSSES(-)',7X,'GAIN/LOSS'/84X,3(2X,14('='))                    BUDGET.......30600
     3   /13X,'GAIN/LOSS OF SOLUTE THROUGH FLUID SOURCES AND SINKS',     BUDGET.......30700
     4   20X,3(1X,1PE15.7)                                               BUDGET.......30800
     5   /13X,'GAIN/LOSS OF SOLUTE THROUGH INFLOWS/OUTFLOWS AT'          BUDGET.......30900
     6   ' SPECIFIED P NODES',6X,3(1X,1PE15.7)                           BUDGET.......31000
     7   /13X,'GAIN/LOSS OF SOLUTE THROUGH SOLUTE SOURCES AND SINKS',    BUDGET.......31100
     8   19X,3(1X,1PE15.7)                                               BUDGET.......31200
     9   /13X,'GAIN/LOSS OF SOLUTE AT SPECIFIED CONCENTRATION NODES',    BUDGET.......31300
     T   19X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......31400
     1   /13X,'TOTAL RATE OF GAIN/LOSS OF SOLUTE',38X,3(1X,1PE15.7)      BUDGET.......31500
     2   /16X,' THROUGH FLOWS & SOURCES/SINKS [ F+, F-, F ]'             BUDGET.......31600
     3   ///13X,'SOLUTE MASS BAL. ACTIVITY [ A = ((S+) - (S-)',          BUDGET.......31700
     4   ' + (P+) - (P-) + (F+) - (F-))/2 ]',2X,1PE15.7                  BUDGET.......31800
     5   /13X,'ABSOLUTE SOLUTE MASS BALANCE ERROR [ S - P - F ]',        BUDGET.......31900
     6   31X,1PE15.7)                                                    BUDGET.......32000
      IF (ACTSMB.NE.0D0) THEN                                            BUDGET.......32100
         ERSMBR = 1D2*ERSMBA/ACTSMB                                      BUDGET.......32200
c rbw begin change
!         WRITE(K3,1601) ERSMBR                                           BUDGET.......32300
!      ELSE                                                               BUDGET.......32400
!         WRITE(K3,1602)                                                  BUDGET.......32500
c rbw end change
      END IF                                                             BUDGET.......32600
 1601 FORMAT(13X,'RELATIVE SOLUTE MASS BALANCE ERROR',                   BUDGET.......32700
     1   ' [ 100*(S - P - F)/A ]',23X,1PE15.7,' (PERCENT)')              BUDGET.......32800
 1602 FORMAT(13X,'RELATIVE SOLUTE MASS BALANCE ERROR',                   BUDGET.......32900
     1   ' [ 100*(S - P - F)/A ]',23X,'  UNDEFINED')                     BUDGET.......33000
      GOTO 1645                                                          BUDGET.......33100
C                                                                        BUDGET.......33200
C.....OUTPUT ENERGY BUDGET                                               BUDGET.......33300
 1615 ACTSMB = 5D-1*(STSPOS - STSNEG + PRSPOS - PRSNEG                   BUDGET.......33400
     1   + QFSPOS - QFSNEG)                                              BUDGET.......33500
      ERSMBA = STSTOT - PRSTOT - QFSTOT                                  BUDGET.......33600
c rbw begin change
!      WRITE(K3,1635) IT,FLDPOS,FLDNEG,FLDTOT,SLDPOS,SLDNEG,SLDTOT,       BUDGET.......33700
!     1   DNSPOS,DNSNEG,DNSTOT,STSPOS,STSNEG,STSTOT,                      BUDGET.......33800
!     2   P0FPOS,P0FNEG,P0FTOT,P0SPOS,P0SNEG,P0STOT,PRSPOS,PRSNEG,PRSTOT, BUDGET.......33900
!     3   QIUPOS,QIUNEG,QIUTOT,QPUPOS,QPUNEG,QPUTOT,                      BUDGET.......34000
!     4   QQUPOS,QQUNEG,QQUTOT,QULPOS,QULNEG,QULTOT,QFSPOS,QFSNEG,QFSTOT, BUDGET.......34100
!     5   ACTSMB,ERSMBA                                                   BUDGET.......34200
c rbw end change
 1635 FORMAT(//11X,'E N E R G Y   B U D G E T      AFTER TIME STEP ',I8, BUDGET.......34300
     1   ',   IN (ENERGY/SECOND)'                                        BUDGET.......34400
     2   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'INCREASES(+)',4X,    BUDGET.......34500
     3   'DECREASES(-)',7X,'CHANGE'/84X,3(2X,14('='))                    BUDGET.......34600
     4   /13X,'RATE OF CHANGE OF ENERGY IN FLUID DUE TO TEMPERATURE',    BUDGET.......34700
     5   ' CHANGE',12X,3(1X,1PE15.7)                                     BUDGET.......34800
     6   /13X,'RATE OF CHANGE OF ENERGY IN SOLID GRAINS',                BUDGET.......34900
     7   31X,3(1X,1PE15.7)                                               BUDGET.......35000
     8   /13X,'RATE OF CHANGE OF ENERGY DUE TO CHANGE IN MASS OF FLUID', BUDGET.......35100
     9   16X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......35200
     T   /13X,'TOTAL RATE OF CHANGE OF ENERGY [ S+, S-, S ]',            BUDGET.......35300
     1   27X,3(1X,1PE15.7)                                               BUDGET.......35400
     2   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'PRODUCTION(+)',5X,   BUDGET.......35500
     3   'DECAY(-)',7X,'PROD./DECAY'/84X,3(2X,14('='))                   BUDGET.......35600
     4   /13X,'ZERO-ORDER PRODUCTION/DECAY OF ENERGY IN FLUID',          BUDGET.......35700
     5   25X,3(1X,1PE15.7)                                               BUDGET.......35800
     6   /13X,'ZERO-ORDER PRODUCTION/DECAY OF ENERGY IN SOLID GRAINS',   BUDGET.......35900
     7   18X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......36000
     8   /13X,'TOTAL RATE OF PRODUCTION/DECAY OF ENERGY',                BUDGET.......36100
     9   ' [ P+, P-, P ]',17X,3(1X,1PE15.7)                              BUDGET.......36200
     T   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/89X,'GAINS(+)',7X,        BUDGET.......36300
     1   'LOSSES(-)',7X,'GAIN/LOSS'/84X,3(2X,14('='))                    BUDGET.......36400
     2   /13X,'GAIN/LOSS OF ENERGY THROUGH FLUID SOURCES AND SINKS',     BUDGET.......36500
     3   20X,3(1X,1PE15.7)                                               BUDGET.......36600
     4   /13X,'GAIN/LOSS OF ENERGY THROUGH INFLOWS/OUTFLOWS AT'          BUDGET.......36700
     5   ' SPECIFIED P NODES',6X,3(1X,1PE15.7)                           BUDGET.......36800
     6   /13X,'GAIN/LOSS OF ENERGY THROUGH ENERGY SOURCES AND SINKS',    BUDGET.......36900
     7   19X,3(1X,1PE15.7)                                               BUDGET.......37000
     8   /13X,'GAIN/LOSS OF ENERGY AT SPECIFIED TEMPERATURE NODES',      BUDGET.......37100
     9   21X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......37200
     T   /13X,'TOTAL RATE OF GAIN/LOSS OF ENERGY',38X,3(1X,1PE15.7)      BUDGET.......37300
     1   /16X,' THROUGH FLOWS & SOURCES/SINKS [ F+, F-, F ]'             BUDGET.......37400
     2   ///13X,'ENERGY BALANCE ACTIVITY [ A = ((S+) - (S-)',            BUDGET.......37500
     3   ' + (P+) - (P-) + (F+) - (F-))/2 ]',4X,1PE15.7                  BUDGET.......37600
     4   /13X,'ABSOLUTE ENERGY BALANCE ERROR [ S - P - F ]',             BUDGET.......37700
     5   36X,1PE15.7)                                                    BUDGET.......37800
      IF (ACTSMB.NE.0D0) THEN                                            BUDGET.......37900
         ERSMBR = 1D2*ERSMBA/ACTSMB                                      BUDGET.......38000
c rbw begin change
!         WRITE(K3,1641) ERSMBR                                           BUDGET.......38100
!      ELSE                                                               BUDGET.......38200
!         WRITE(K3,1642)                                                  BUDGET.......38300
c rbw end change
      END IF                                                             BUDGET.......38400
 1641 FORMAT(13X,'RELATIVE ENERGY BALANCE ERROR',                        BUDGET.......38500
     1   ' [ 100*(S - P - F)/A ]',28X,1PE15.7,' (PERCENT)')              BUDGET.......38600
 1642 FORMAT(13X,'RELATIVE ENERGY BALANCE ERROR',                        BUDGET.......38700
     1   ' [ 100*(S - P - F)/A ]',28X,'  UNDEFINED')                     BUDGET.......38800
C                                                                        BUDGET.......38900
c rbw begin change
 1645 CONTINUE
! 1645 IF ((IT.EQ.1).AND.(ITER.EQ.1).AND.(ISSTRA.NE.1)) WRITE(K3,1646)    BUDGET.......39000
c rbw end change
 1646 FORMAT(/13X,'******** NOTE: ON THE FIRST ITERATION OF THE ',       BUDGET.......39100
     1   'FIRST TIME STEP, A LARGE RELATIVE ERROR IN THE  ********'      BUDGET.......39200
     2   /13X,'******** SOLUTE MASS OR ENERGY BUDGET DOES NOT ',         BUDGET.......39300
     3   'NECESSARILY INDICATE AN INACCURATE TRANSPORT  ********'        BUDGET.......39400
     4   /13X,'******** SOLUTION. THE BUDGET CALCULATION WILL ',         BUDGET.......39500
     5   'NOT YIELD A MEANINGFUL RESULT UNLESS THE      ********'        BUDGET.......39600
     6   /13X,'******** INITIAL CONDITIONS REPRESENT MUTUALLY ',         BUDGET.......39700
     7   'CONSISTENT SOLUTIONS FOR FLOW AND TRANSPORT   ********'        BUDGET.......39800
     8   /13X,'******** FROM A PREVIOUS SUTRA SIMULATION THAT ',         BUDGET.......39900
     9   'ARE ALSO CONSISTENT WITH THE PRESENT SOURCES  ********'        BUDGET.......40000
     T   /13X,'******** AND BOUNDARY CONDITIONS.',60X,'********')        BUDGET.......40100
C                                                                        BUDGET.......40200
      NSOPI=NSOP-1                                                       BUDGET.......40300
      IF(NSOPI.EQ.0) GOTO 2000                                           BUDGET.......40400
c rbw begin change
!      IF(ME) 1649,1649,1659                                              BUDGET.......40500
! 1649 WRITE(K3,1650)                                                     BUDGET.......40600
 1650 FORMAT(///22X,'SOLUTE SOURCES OR SINKS AT FLUID SOURCES AND ',     BUDGET.......40700
     1   'SINKS'//22X,' NODE',8X,'SOURCE(+)/SINK(-)'/32X,                BUDGET.......40800
     2   '(SOLUTE MASS/SECOND)'/)                                        BUDGET.......40900
!      GOTO 1680                                                          BUDGET.......41000
! 1659 WRITE(K3,1660)                                                     BUDGET.......41100
 1660 FORMAT(///22X,'ENERGY SOURCES OR SINKS AT FLUID SOURCES AND ',     BUDGET.......41200
     1   'SINKS'//22X,' NODE',8X,'SOURCE(+)/SINK(-)'/37X,                BUDGET.......41300
     2   '(ENERGY/SECOND)'/)                                             BUDGET.......41400
c rbw end change
 1680 DO 1900 IQP=1,NSOPI                                                BUDGET.......41500
      I=IABS(IQSOP(IQP))                                                 BUDGET.......41600
      IF(QINITR(I)) 1700,1700,1750                                       BUDGET.......41700
 1700 QU=QINITR(I)*CW*UVEC(I)                                            BUDGET.......41800
      GOTO 1800                                                          BUDGET.......41900
 1750 QU=QINITR(I)*CW*UIN(I)                                             BUDGET.......42000
c rbw begin change
 1800 CONTINUE
! 1800 WRITE(K3,450) I,QU                                                 BUDGET.......42100
c rbw end change
 1900 CONTINUE                                                           BUDGET.......42200
C                                                                        BUDGET.......42300
 2000 IF(NPBC.EQ.0) GOTO 4500                                            BUDGET.......42400
c rbw begin change
!      IF(ME) 2090,2090,2150                                              BUDGET.......42500
! 2090 WRITE(K3,2100)                                                     BUDGET.......42600
 2100 FORMAT(///22X,'SOLUTE SOURCES OR SINKS DUE TO FLUID INFLOWS OR ',  BUDGET.......42700
     1   'OUTFLOWS AT POINTS OF SPECIFIED PRESSURE'//22X,' NODE',8X,     BUDGET.......42800
     2   'SOURCE(+)/SINK(-)'/32X,'(SOLUTE MASS/SECOND)'/)                BUDGET.......42900
!      GOTO 2190                                                          BUDGET.......43000
! 2150 WRITE(K3,2160)                                                     BUDGET.......43100
 2160 FORMAT(///22X,'ENERGY SOURCES OR SINKS DUE TO FLUID INFLOWS OR ',  BUDGET.......43200
     1   'OUTFLOWS AT POINTS OF SPECIFIED PRESSURE'//22X,' NODE',8X,     BUDGET.......43300
     2   'SOURCE(+)/SINK(-)'/37X,'(ENERGY/SECOND)'/)                     BUDGET.......43400
c rbw end change
 2190 DO 2400 IP=1,NPBC                                                  BUDGET.......43500
      I=IABS(IPBC(IP))                                                   BUDGET.......43600
      IF(QPLITR(IP)) 2200,2200,2250                                      BUDGET.......43700
 2200 QPU=QPLITR(IP)*CW*UVEC(I)                                          BUDGET.......43800
      GOTO 2300                                                          BUDGET.......43900
 2250 QPU=QPLITR(IP)*CW*UBC(IP)                                          BUDGET.......44000
c rbw begin change
 2300 CONTINUE
! 2300 WRITE(K3,450) I,QPU                                                BUDGET.......44100
c rbw end change
 2400 CONTINUE                                                           BUDGET.......44200
C                                                                        BUDGET.......44300
      IF(IBCT.EQ.4) GOTO 4500                                            BUDGET.......44400
      NSOUI=NSOU-1                                                       BUDGET.......44500
      INEGCT=0                                                           BUDGET.......44600
      DO 3500 IQU=1,NSOUI                                                BUDGET.......44700
      I=IQSOU(IQU)                                                       BUDGET.......44800
      IF (IBCSOU(IQU).EQ.-1) THEN                                        BUDGET.......44900
         INEGCT = INEGCT + 1                                             BUDGET.......45000
         IF (INEGCT.EQ.1) THEN                                           BUDGET.......45100
            IF (ME.EQ.-1) THEN                                           BUDGET.......45200
c rbw begin change
!               WRITE(K3,3455)                                            BUDGET.......45300
c rbw end change
 3455          FORMAT(///22X,'TIME-DEPENDENT SOLUTE SOURCES OR SINKS ',  BUDGET.......45400
     1            'SET IN SUBROUTINE BCTIME'//22X,' NODE',10X,           BUDGET.......45500
     2            'GAIN(+)/LOSS(-)'/30X,'  (SOLUTE MASS/SECOND)'//)      BUDGET.......45600
            ELSE                                                         BUDGET.......45700
c rbw begin change
!               WRITE(K3,3456)                                            BUDGET.......45800
c rbw end change
 3456          FORMAT(///22X,'TIME-DEPENDENT ENERGY SOURCES OR SINKS ',  BUDGET.......45900
     1            'SET IN SUBROUTINE BCTIME'//22X,' NODE',10X,           BUDGET.......46000
     2            'GAIN(+)/LOSS(-)'/30X,'  (ENERGY/SECOND)'//)           BUDGET.......46100
            END IF                                                       BUDGET.......46200
         END IF                                                          BUDGET.......46300
c rbw begin change
!         WRITE(K3,3490) -I,QUIN(-I)                                      BUDGET.......46400
c rbw end change
 3490    FORMAT(22X,I9,10X,1PE15.7)                                      BUDGET.......46500
      END IF                                                             BUDGET.......46600
 3500 CONTINUE                                                           BUDGET.......46700
C                                                                        BUDGET.......46800
 4500 IF(NUBC.EQ.0) GOTO 5500                                            BUDGET.......46900
c rbw begin change
!      IF(ME) 4600,4600,4655                                              BUDGET.......47000
! 4600 WRITE(K3,4650)                                                     BUDGET.......47100
 4650 FORMAT(///22X,'SOLUTE SOURCES OR SINKS DUE TO SPECIFIED ',         BUDGET.......47200
     1   'CONCENTRATIONS'//22X,' NODE',10X,'GAIN(+)/LOSS(-)'/30X,        BUDGET.......47300
     2   '  (SOLUTE MASS/SECOND)'/)                                      BUDGET.......47400
!      GOTO 4690                                                          BUDGET.......47500
! 4655 WRITE(K3,4660)                                                     BUDGET.......47600
c rbw end change
 4660 FORMAT(///22X,'ENERGY SOURCES OR SINKS DUE TO SPECIFIED ',         BUDGET.......47700
     1   'TEMPERATURES'//22X,' NODE',10X,'GAIN(+)/LOSS(-)'/35X,          BUDGET.......47800
     2   '  (ENERGY/SECOND)'/)                                           BUDGET.......47900
 4690 CONTINUE                                                           BUDGET.......48000
      DO 4700 IU=1,NUBC                                                  BUDGET.......48100
      IUP=IU+NPBC                                                        BUDGET.......48200
      I=IABS(IUBC(IUP))                                                  BUDGET.......48300
c rbw begin change
!      WRITE(K3,450) I,QPLITR(IUP)                                        BUDGET.......48400
c rbw end change
 4700 CONTINUE                                                           BUDGET.......48500
C                                                                        BUDGET.......48600
C                                                                        BUDGET.......48700
 5500 CONTINUE                                                           BUDGET.......48800
C                                                                        BUDGET.......48900
      RETURN                                                             BUDGET.......49000
      END                                                                BUDGET.......49100
C                                                                        BUDGET.......49200
C     SUBROUTINE        C  O  N  N  E  C           SUTRA VERSION 2.2     CONNEC.........100
C                                                                        CONNEC.........200
C *** PURPOSE :                                                          CONNEC.........300
C ***  TO READ, ORGANIZE, AND CHECK DATA ON NODE INCIDENCES.             CONNEC.........400
C                                                                        CONNEC.........500
      SUBROUTINE CONNEC(IN)                                              CONNEC.........600
c rbw begin change
      use ErrorFlag
c rbw end chaNge
      USE EXPINT                                                         CONNEC.........700
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                CONNEC.........800
      CHARACTER INTFIL*1000                                              CONNEC.........900
      CHARACTER CDUM10*10                                                CONNEC........1000
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:13)                    CONNEC........1100
      DIMENSION IN(NIN)                                                  CONNEC........1200
      DIMENSION IIN(8)                                                   CONNEC........1300
      DIMENSION INERR(10),RLERR(10)                                      CONNEC........1400
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              CONNEC........1500
     1   NSOP,NSOU,NBCN,NCIDB                                            CONNEC........1600
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        CONNEC........1700
      COMMON /FNAMES/ UNAME,FNAME                                        CONNEC........1800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 CONNEC........1900
     1   K10,K11,K12,K13                                                 CONNEC........2000
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,                CONNEC........2100
     1   KPANDS,KVEL,KCORT,KBUDG,KSCRN,KPAUSE                            CONNEC........2200
C                                                                        CONNEC........2300
      IPIN=0                                                             CONNEC........2400
c rbw begin change
!      IF(KINCID.EQ.0) WRITE(K3,1)                                        CONNEC........2500
    1 FORMAT('1'////11X,'M E S H   C O N N E C T I O N   D A T A'//      CONNEC........2600
     1   16X,'PRINTOUT OF NODAL INCIDENCES CANCELLED.')                  CONNEC........2700
!      IF(KINCID.EQ.+1) WRITE(K3,2)                                       CONNEC........2800
c rbw end change
    2 FORMAT('1'////11X,'M E S H   C O N N E C T I O N   D A T A',       CONNEC........2900
     1   ///11X,'**** NODAL INCIDENCES ****'///)                         CONNEC........3000
C                                                                        CONNEC........3100
C.....INPUT DATASET 22 AND CHECK FOR ERRORS                              CONNEC........3200
      ERRCOD = 'REA-INP-22'                                              CONNEC........3300
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 CONNEC........3400
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 155
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10                              CONNEC........3500
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        CONNEC........3600
      IF (INERR(1).NE.0) then
        IErrorFlag = 33
        return
      endif
c rbw end change
      IF (CDUM10.NE.'INCIDENCE ') THEN                                   CONNEC........3700
c rbw begin change
        IErrorFlag = 34
        return
!         ERRCOD = 'INP-22-1'                                             CONNEC........3800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        CONNEC........3900
c rbw end change
      END IF                                                             CONNEC........4000
      DO 1000 L=1,NE                                                     CONNEC........4100
      ERRCOD = 'REA-INP-22'                                              CONNEC........4200
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 CONNEC........4300
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 156
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) LL,(IIN(II),II=1,N48)               CONNEC........4400
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        CONNEC........4500
      IF (INERR(1).NE.0) then
        IErrorFlag = 35
        return
      endif
c rbw end change
C.....PREPARE NODE INCIDENCE LIST FOR MESH, IN.                          CONNEC........4600
      DO 5 II=1,N48                                                      CONNEC........4700
      III=II+(L-1)*N48                                                   CONNEC........4800
    5 IN(III)=IIN(II)                                                    CONNEC........4900
      IF(IABS(LL).EQ.L) GOTO 500                                         CONNEC........5000
c rbw begin change
        IErrorFlag = 36
        return
!      ERRCOD = 'INP-22-2'                                                CONNEC........5100
!      INERR(1) = LL                                                      CONNEC........5200
!      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           CONNEC........5300
c rbw end change
C                                                                        CONNEC........5400
C                                                                        CONNEC........5500
  500 M1=(L-1)*N48+1                                                     CONNEC........5600
      M8=M1+N48-1                                                        CONNEC........5700
      IF(KINCID.EQ.0) GOTO 1000                                          CONNEC........5800
c rbw begin change
!      WRITE(K3,650) L,(IN(M),M=M1,M8)                                    CONNEC........5900
c rbw end change
  650 FORMAT(11X,'ELEMENT',I9,5X,' NODES AT : ',6X,'CORNERS ',           CONNEC........6000
     1   5('*'),8I9,1X,5('*'))                                           CONNEC........6100
C                                                                        CONNEC........6200
 1000 CONTINUE                                                           CONNEC........6300
C                                                                        CONNEC........6400
C                                                                        CONNEC........6500
 5000 RETURN                                                             CONNEC........6600
      END                                                                CONNEC........6700
C                                                                        CONNEC........6800
C     FUNCTION          C  U  T  S  M  L           SUTRA VERSION 2.2     CUTSML.........100
C                                                                        CUTSML.........200
C *** PURPOSE :                                                          CUTSML.........300
C ***  TO RETURN ARGUMENT DPNUM IF ITS MAGNITUDE IS GREATER THAN OR      CUTSML.........400
C ***  EQUAL TO 1.D-99, AND ZERO OTHERWISE.                              CUTSML.........500
C                                                                        CUTSML.........600
      DOUBLE PRECISION FUNCTION CUTSML(DPNUM)                            CUTSML.........700
      IMPLICIT DOUBLE PRECISION (A-H, O-Z)                               CUTSML.........800
C                                                                        CUTSML.........900
C.....RETURN DPNUM IF ITS ABSOLUTE VALUE IS >= 1.D-99, OTHERWISE         CUTSML........1000
C        RETURN ZERO                                                     CUTSML........1100
      IF (DABS(DPNUM).LT.1.D-99) THEN                                    CUTSML........1200
         CUTSML = 0D0                                                    CUTSML........1300
      ELSE                                                               CUTSML........1400
         CUTSML = DPNUM                                                  CUTSML........1500
      END IF                                                             CUTSML........1600
C                                                                        CUTSML........1700
      RETURN                                                             CUTSML........1800
      END                                                                CUTSML........1900
C                                                                        CUTSML........2000
C     SUBROUTINE        D  I  M  W  R  K           SUTRA VERSION 2.2     DIMWRK.........100
C                                                                        DIMWRK.........200
C *** PURPOSE :                                                          DIMWRK.........300
C ***  TO RETURN DIMENSIONS FOR THE SOLVER WORK ARRAYS, WHICH DEPEND ON  DIMWRK.........400
C ***  THE PARTICULAR SOLVER CHOSEN.                                     DIMWRK.........500
C                                                                        DIMWRK.........600
      SUBROUTINE DIMWRK(KSOLVR, NSAVE, NN, NELT, NWI, NWF)               DIMWRK.........700
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                DIMWRK.........800
C                                                                        DIMWRK.........900
C.....COMPUTE SOLVER WORK ARRAY DIMENSIONS                               DIMWRK........1000
      IF (KSOLVR.EQ.1) THEN                                              DIMWRK........1100
         NL = (NELT + NN)/2                                              DIMWRK........1200
         NWI = 11 + 2*NL                                                 DIMWRK........1300
         NWF = NL + 5*NN + 1                                             DIMWRK........1400
      ELSE IF (KSOLVR.EQ.2) THEN                                         DIMWRK........1500
         NWI = 31 + 2*NELT                                               DIMWRK........1600
         NWF = 2 + NN*(NSAVE + 7) + NSAVE*(NSAVE + 3) + (NELT - NN)      DIMWRK........1700
      ELSE IF (KSOLVR.EQ.3) THEN                                         DIMWRK........1800
         NWI = 11 + 2*NELT                                               DIMWRK........1900
         NWF = 1 + 3*NN*(NSAVE + 1) + 7*NN + NSAVE + (NELT - NN)         DIMWRK........2000
      END IF                                                             DIMWRK........2100
C                                                                        DIMWRK........2200
      RETURN                                                             DIMWRK........2300
      END                                                                DIMWRK........2400
C                                                                        DIMWRK........2500
C     SUBROUTINE        D  I  S  P  R  3           SUTRA VERSION 2.2     DISPR3.........100
C                                                                        DISPR3.........200
C *** PURPOSE :                                                          DISPR3.........300
C ***  TO COMPUTE THE COMPONENTS OF THE 3D DISPERSION TENSOR IN          DISPR3.........400
C ***  X,Y,Z-COORDINATES USING AN AD HOC, 3D ANISOTROPIC DISPERSION      DISPR3.........500
C ***  MODEL.                                                            DISPR3.........600
C                                                                        DISPR3.........700
      SUBROUTINE DISPR3(VX,VY,VZ,VMAG,ANG1,ANG2,ANG3,ALMAX,ALMID,ALMIN,  DISPR3.........800
     1   ATMAX,ATMID,ATMIN,DXX,DXY,DXZ,DYX,DYY,DYZ,DZX,DZY,DZZ)          DISPR3.........900
c rbw begin change
      USE ErrorFlag
c rbw end change
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                DISPR3........1000
      LOGICAL LISO,TISO                                                  DISPR3........1100
      DIMENSION AL(3),AT(3),VN(3),UN(3),WN(3)                            DISPR3........1200
      DIMENSION J(3)                                                     DISPR3........1300
C                                                                        DISPR3........1400
C.....HANDLE CASE OF ZERO VELOCITY.  (THIS CASE IS ALREADY HANDLED       DISPR3........1500
C        BY SUBROUTINE ELEMN3.  THE BLOCK IF STATEMENT BELOW CAN BE      DISPR3........1600
C        UNCOMMENTED IF NEEDED IN THE FUTURE.)                           DISPR3........1700
C     IF (VMAG.EQ.0D0) THEN                                              DISPR3........1800
C        DXX = 0D0                                                       DISPR3........1900
C        DXY = 0D0                                                       DISPR3........2000
C        DXZ = 0D0                                                       DISPR3........2100
C        DYX = 0D0                                                       DISPR3........2200
C        DYY = 0D0                                                       DISPR3........2300
C        DYZ = 0D0                                                       DISPR3........2400
C        DZX = 0D0                                                       DISPR3........2500
C        DZY = 0D0                                                       DISPR3........2600
C        DZZ = 0D0                                                       DISPR3........2700
C        RETURN                                                          DISPR3........2800
C     END IF                                                             DISPR3........2900
C                                                                        DISPR3........3000
C.....SET TOLERANCES USED TO DETERMINE WHETHER CERTAIN DEGENERATE        DISPR3........3100
C        CONDITIONS ARE TRUE:                                            DISPR3........3200
C        TOLISO -- IS DISPERSION ESSENTIALLY ISOTROPIC?                  DISPR3........3300
C        TOLVRT -- IS FLOW ESSENTIALLY VERTICAL?                         DISPR3........3400
C        TOLCIR -- IS SLICING ELLIPSE ESSENTIALLY A CIRCLE?              DISPR3........3500
      TOLISO = 1D-7                                                      DISPR3........3600
      TOLVRT = 1D-7                                                      DISPR3........3700
      TOLCIR = 9.999999D-1                                               DISPR3........3800
C                                                                        DISPR3........3900
C.....NORMALIZE THE VELOCITY VECTOR.                                     DISPR3........4000
      VNX = VX/VMAG                                                      DISPR3........4100
      VNY = VY/VMAG                                                      DISPR3........4200
      VNZ = VZ/VMAG                                                      DISPR3........4300
C                                                                        DISPR3........4400
C.....DETERMINE WHETHER LONGITUDINAL DISPERSION IS ESSENTIALLY           DISPR3........4500
C        ISOTROPIC.                                                      DISPR3........4600
      AL(1) = ALMAX                                                      DISPR3........4700
      AL(2) = ALMID                                                      DISPR3........4800
      AL(3) = ALMIN                                                      DISPR3........4900
      ALMXVL = MAXVAL(AL)                                                DISPR3........5000
      ALMNVL = MINVAL(AL)                                                DISPR3........5100
      IF (ALMXVL.EQ.0D0) THEN                                            DISPR3........5200
         LISO = .TRUE.                                                   DISPR3........5300
      ELSE                                                               DISPR3........5400
         LISO = ((ALMXVL - ALMNVL)/ALMXVL.LT.TOLISO)                     DISPR3........5500
      END IF                                                             DISPR3........5600
C                                                                        DISPR3........5700
C.....COMPUTE THE LONGITUDINAL DISPERSION COEFFICIENT.                   DISPR3........5800
      IF (LISO) THEN                                                     DISPR3........5900
C........ISOTROPIC CASE.                                                 DISPR3........6000
         DL = ALMAX*VMAG                                                 DISPR3........6100
      ELSE                                                               DISPR3........6200
C........ANISOTROPIC CASE.                                               DISPR3........6300
C........ROTATE V TO "MAX-MID-MIN" COORDINATES.                          DISPR3........6400
         CALL ROTMAT(ANG1,ANG2,ANG3,G11,G12,G13,G21,G22,G23,             DISPR3........6500
     1      G31,G32,G33)                                                 DISPR3........6600
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         CALL ROTATE(G11,G21,G31,G12,G22,G32,G13,G23,G33,                DISPR3........6700
     1      VNX,VNY,VNZ,VNXX,VNYY,VNZZ)                                  DISPR3........6800
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
C........EVALUATE DL FROM THE LONGITUDINAL DISPERSIVITY ELLIPSOID.       DISPR3........6900
         DL = VMAG/(VNXX*VNXX/ALMAX+VNYY*VNYY/ALMID+VNZZ*VNZZ/ALMIN)     DISPR3........7000
      END IF                                                             DISPR3........7100
C                                                                        DISPR3........7200
C.....DETERMINE WHETHER TRANSVERSE DISPERSION IS ESSENTIALLY             DISPR3........7300
C        ISOTROPIC.                                                      DISPR3........7400
      AT(1) = ATMAX                                                      DISPR3........7500
      AT(2) = ATMID                                                      DISPR3........7600
      AT(3) = ATMIN                                                      DISPR3........7700
      ATMXVL = MAXVAL(AT)                                                DISPR3........7800
      ATMNVL = MINVAL(AT)                                                DISPR3........7900
      IF (ATMXVL.EQ.0D0) THEN                                            DISPR3........8000
         TISO = .TRUE.                                                   DISPR3........8100
      ELSE                                                               DISPR3........8200
         TISO = ((ATMXVL - ATMNVL)/ATMXVL.LT.TOLISO)                     DISPR3........8300
      END IF                                                             DISPR3........8400
C                                                                        DISPR3........8500
C.....COMPUTE THE TRANSVERSE DISPERSION DIRECTIONS AND COEFFICIENTS.     DISPR3........8600
      IF (TISO) THEN                                                     DISPR3........8700
C........ISOTROPIC CASE.                                                 DISPR3........8800
         TERM = 1D0 - VNZ*VNZ                                            DISPR3........8900
         IF (TERM.LT.TOLVRT) THEN                                        DISPR3........9000
C...........FLOW IS ESSENTIALLY IN Z-DIRECTION (VERTICAL)                DISPR3........9100
            UNX = 1D0                                                    DISPR3........9200
            UNY = 0D0                                                    DISPR3........9300
            UNZ = 0D0                                                    DISPR3........9400
            WNX = 0D0                                                    DISPR3........9500
            WNY = 1D0                                                    DISPR3........9600
            WNZ = 0D0                                                    DISPR3........9700
         ELSE                                                            DISPR3........9800
C...........FLOW IS NOT IN Z-DIRECTION (NOT VERTICAL)                    DISPR3........9900
            TERMH = DSQRT(TERM)                                          DISPR3.......10000
            UNX = -VNY/TERMH                                             DISPR3.......10100
            UNY = VNX/TERMH                                              DISPR3.......10200
            UNZ = 0D0                                                    DISPR3.......10300
            WNX = -VNZ*UNY                                               DISPR3.......10400
            WNY = VNZ*UNX                                                DISPR3.......10500
            WNZ = TERMH                                                  DISPR3.......10600
         END IF                                                          DISPR3.......10700
         AT1 = ATMAX                                                     DISPR3.......10800
         AT2 = AT1                                                       DISPR3.......10900
      ELSE                                                               DISPR3.......11000
C........ANISOTROPIC CASE.                                               DISPR3.......11100
C........ROTATE V TO "MAX-MID-MIN" COORDINATES, IF NOT DONE PREVIOUSLY.  DISPR3.......11200
         IF (LISO) THEN                                                  DISPR3.......11300
            CALL ROTMAT(ANG1,ANG2,ANG3,G11,G12,G13,G21,G22,G23,          DISPR3.......11400
     1         G31,G32,G33)                                              DISPR3.......11500
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            CALL ROTATE(G11,G21,G31,G12,G22,G32,G13,G23,G33,             DISPR3.......11600
     1         VNX,VNY,VNZ,VNXX,VNYY,VNZZ)                               DISPR3.......11700
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         END IF                                                          DISPR3.......11800
C........TRANSPOSE AXES SO THAT THE LONGEST AXIS OF THE TRANSVERSE       DISPR3.......11900
C           DISPERSIVITY ELLIPSOID IS "MAX", THE SECOND LONGEST IS       DISPR3.......12000
C           "MID", AND THE SHORTEST IS "MIN".                            DISPR3.......12100
         J(1:1) = MAXLOC(AT)                                             DISPR3.......12200
         J(3:3) = MINLOC(AT)                                             DISPR3.......12300
         J(2) = 6 - J(1) - J(3)                                          DISPR3.......12400
         VN(1) = VNXX                                                    DISPR3.......12500
         VN(2) = VNYY                                                    DISPR3.......12600
         VN(3) = VNZZ                                                    DISPR3.......12700
         VNTXX = VN(J(1))                                                DISPR3.......12800
         VNTYY = VN(J(2))                                                DISPR3.......12900
         VNTZZ = VN(J(3))                                                DISPR3.......13000
         A2 = AT(J(1))                                                   DISPR3.......13100
         B2 = AT(J(2))                                                   DISPR3.......13200
         C2 = AT(J(3))                                                   DISPR3.......13300
C........APPLY THE BIOT-FRESNEL CONSTRUCTION TO THE TRANSVERSE           DISPR3.......13400
C           DISPERSIVITY ELLIPSOID.                                      DISPR3.......13500
         A2B2 = A2*B2                                                    DISPR3.......13600
         A2C2 = A2*C2                                                    DISPR3.......13700
         B2C2 = B2*C2                                                    DISPR3.......13800
         COS2AV = (A2C2 - B2C2)/(A2B2 - B2C2)                            DISPR3.......13900
         SIN2AV = 1D0 - COS2AV                                           DISPR3.......14000
         COSAV = DSQRT(COS2AV)                                           DISPR3.......14100
         SINAV = DSQRT(SIN2AV)                                           DISPR3.......14200
         TERM1 = COSAV*VNTXX                                             DISPR3.......14300
         TERM2 = SINAV*VNTZZ                                             DISPR3.......14400
         OA1V = TERM1 + TERM2                                            DISPR3.......14500
         OA2V = TERM1 - TERM2                                            DISPR3.......14600
         IF (MAX(DABS(OA1V),DABS(OA2V)).GT.TOLCIR) THEN                  DISPR3.......14700
C...........SLICING ELLIPSE IS ESSENTIALLY A CIRCLE                      DISPR3.......14800
            UNTXX = -VNTZZ                                               DISPR3.......14900
            UNTYY = 0D0                                                  DISPR3.......15000
            UNTZZ = VNTXX                                                DISPR3.......15100
            WNTXX = 0D0                                                  DISPR3.......15200
            WNTYY = 1D0                                                  DISPR3.......15300
            WNTZZ = 0D0                                                  DISPR3.......15400
            AT1 = B2                                                     DISPR3.......15500
            AT2 = B2                                                     DISPR3.......15600
         ELSE                                                            DISPR3.......15700
C...........SLICING ELLIPSE IS NOT A CIRCLE                              DISPR3.......15800
            RVJ1MG = 1D0/DSQRT(1D0 - OA1V*OA1V)                          DISPR3.......15900
            RVJ2MG = 1D0/DSQRT(1D0 - OA2V*OA2V)                          DISPR3.......16000
            RSUM = RVJ1MG + RVJ2MG                                       DISPR3.......16100
            RDIF = RVJ1MG - RVJ2MG                                       DISPR3.......16200
            OAUXX = COSAV*RSUM                                           DISPR3.......16300
            OAUZZ = SINAV*RDIF                                           DISPR3.......16400
            OAWXX = COSAV*RDIF                                           DISPR3.......16500
            OAWZZ = SINAV*RSUM                                           DISPR3.......16600
            OAUV = OAUXX*VNTXX + OAUZZ*VNTZZ                             DISPR3.......16700
            OAWV = OAWXX*VNTXX + OAWZZ*VNTZZ                             DISPR3.......16800
            OAUOAU = OAUXX*OAUXX + OAUZZ*OAUZZ                           DISPR3.......16900
            OAWOAW = OAWXX*OAWXX + OAWZZ*OAWZZ                           DISPR3.......17000
            UMTERM = OAUOAU - OAUV*OAUV                                  DISPR3.......17100
            WMTERM = OAWOAW - OAWV*OAWV                                  DISPR3.......17200
C...........COMPUTE THE LARGER OF U AND W DIRECTLY, THEN COMPUTE THE     DISPR3.......17300
C              OTHER BY CROSS-PRODUCT WITH V.                            DISPR3.......17400
            IF (UMTERM.GT.WMTERM) THEN                                   DISPR3.......17500
               RUMAGH = 1D0/DSQRT(UMTERM)                                DISPR3.......17600
               UNTXX = (OAUXX - OAUV*VNTXX)*RUMAGH                       DISPR3.......17700
               UNTYY = -OAUV*VNTYY*RUMAGH                                DISPR3.......17800
               UNTZZ = (OAUZZ - OAUV*VNTZZ)*RUMAGH                       DISPR3.......17900
               WNTXX = UNTYY*VNTZZ - UNTZZ*VNTYY                         DISPR3.......18000
               WNTYY = UNTZZ*VNTXX - UNTXX*VNTZZ                         DISPR3.......18100
               WNTZZ = UNTXX*VNTYY - UNTYY*VNTXX                         DISPR3.......18200
            ELSE                                                         DISPR3.......18300
               RWMAGH = 1D0/DSQRT(WMTERM)                                DISPR3.......18400
               WNTXX = (OAWXX - OAWV*VNTXX)*RWMAGH                       DISPR3.......18500
               WNTYY = -OAWV*VNTYY*RWMAGH                                DISPR3.......18600
               WNTZZ = (OAWZZ - OAWV*VNTZZ)*RWMAGH                       DISPR3.......18700
               UNTXX = WNTYY*VNTZZ - WNTZZ*VNTYY                         DISPR3.......18800
               UNTYY = WNTZZ*VNTXX - WNTXX*VNTZZ                         DISPR3.......18900
               UNTZZ = WNTXX*VNTYY - WNTYY*VNTXX                         DISPR3.......19000
            END IF                                                       DISPR3.......19100
            A2B2C2 = A2B2*C2                                             DISPR3.......19200
            DEN1 = B2C2*UNTXX*UNTXX+A2C2*UNTYY*UNTYY+A2B2*UNTZZ*UNTZZ    DISPR3.......19300
            DEN2 = B2C2*WNTXX*WNTXX+A2C2*WNTYY*WNTYY+A2B2*WNTZZ*WNTZZ    DISPR3.......19400
            AT1 = A2B2C2/DEN1                                            DISPR3.......19500
            AT2 = A2B2C2/DEN2                                            DISPR3.......19600
         END IF                                                          DISPR3.......19700
C........TRANSPOSE AXES BACK TO ORIGINAL "MAX-MID-MIN" AXES.             DISPR3.......19800
         UN(J(1)) = UNTXX                                                DISPR3.......19900
         UN(J(2)) = UNTYY                                                DISPR3.......20000
         UN(J(3)) = UNTZZ                                                DISPR3.......20100
         UNXX = UN(1)                                                    DISPR3.......20200
         UNYY = UN(2)                                                    DISPR3.......20300
         UNZZ = UN(3)                                                    DISPR3.......20400
         WN(J(1)) = WNTXX                                                DISPR3.......20500
         WN(J(2)) = WNTYY                                                DISPR3.......20600
         WN(J(3)) = WNTZZ                                                DISPR3.......20700
         WNXX = WN(1)                                                    DISPR3.......20800
         WNYY = WN(2)                                                    DISPR3.......20900
         WNZZ = WN(3)                                                    DISPR3.......21000
C........ROTATE THE TRANSVERSE DISPERSION DIRECTIONS FROM "MAX-MID-MIN"  DISPR3.......21100
C           COORDINATES TO X,Y,Z-COORDINATES.                            DISPR3.......21200
         CALL ROTATE(G11,G12,G13,G21,G22,G23,G31,G32,G33,UNXX,UNYY,UNZZ, DISPR3.......21300
     1      UNX,UNY,UNZ)                                                 DISPR3.......21400
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         CALL ROTATE(G11,G12,G13,G21,G22,G23,G31,G32,G33,WNXX,WNYY,WNZZ, DISPR3.......21500
     1      WNX,WNY,WNZ)                                                 DISPR3.......21600
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
      END IF                                                             DISPR3.......21700
C.....COMPUTE TRANSVERSE DISPERSION COEFFICIENTS FROM DISPERSIVITIES     DISPR3.......21800
      DT1 = AT1*VMAG                                                     DISPR3.......21900
      DT2 = AT2*VMAG                                                     DISPR3.......22000
C                                                                        DISPR3.......22100
C.....ROTATE THE DISPERSION TENSOR FROM EIGENVECTOR COORDINATES TO       DISPR3.......22200
C     X,Y,Z-COORDINATES.                                                 DISPR3.......22300
      CALL TENSYM(DL,DT1,DT2,VNX,UNX,WNX,VNY,UNY,WNY,VNZ,UNZ,WNZ,        DISPR3.......22400
     1   DXX,DXY,DXZ,DYX,DYY,DYZ,DZX,DZY,DZZ)                            DISPR3.......22500
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
C                                                                        DISPR3.......22600
      RETURN                                                             DISPR3.......22700
      END                                                                DISPR3.......22800
C                                                                        DISPR3.......22900
C     FUNCTION          D  P  3  S  T  R           SUTRA VERSION 2.2     DP3STR.........100
C                                                                        DP3STR.........200
C *** PURPOSE :                                                          DP3STR.........300
C ***  TO RETURN THREE DOUBLE-PRECISION NUMBERS IN THE FORM OF A         DP3STR.........400
C ***  STRING.  THE THREE NUMBERS ARE PASSED IN THROUGH ARRAY DPA        DP3STR.........500
C ***  AND ARE ROUNDED USING FUNCTION CUTSML IN PREPARATION FOR OUTPUT.  DP3STR.........600
C                                                                        DP3STR.........700
      FUNCTION DP3STR(DPA)                                               DP3STR.........800
      IMPLICIT DOUBLE PRECISION (A-H, O-Z)                               DP3STR.........900
      DIMENSION DPA(3)                                                   DP3STR........1000
      CHARACTER DP3STR*45                                                DP3STR........1100
C                                                                        DP3STR........1200
C.....WRITE NUMBERS TO STRING                                            DP3STR........1300
      WRITE(UNIT=DP3STR,FMT="(3(1PE15.7))")                              DP3STR........1400
     1   CUTSML(DPA(1)), CUTSML(DPA(2)), CUTSML(DPA(3))                  DP3STR........1500
C                                                                        DP3STR........1600
      RETURN                                                             DP3STR........1700
      END                                                                DP3STR........1800
C                                                                        DP3STR........1900
C     SUBROUTINE        E  L  E  M  N  2           SUTRA VERSION 2.2     ELEMN2.........100
C                                                                        ELEMN2.........200
C *** PURPOSE :                                                          ELEMN2.........300
C ***  TO CONTROL AND CARRY OUT ALL CALCULATIONS FOR EACH ELEMENT BY     ELEMN2.........400
C ***  OBTAINING ELEMENT INFORMATION FROM THE BASIS FUNCTION ROUTINE,    ELEMN2.........500
C ***  CARRYING OUT GAUSSIAN INTEGRATION OF FINITE ELEMENT INTEGRALS,    ELEMN2.........600
C ***  AND ASSEMBLING RESULTS OF ELEMENTWISE INTEGRATIONS INTO           ELEMN2.........700
C ***  A GLOBAL MATRIX AND GLOBAL VECTOR FOR BOTH FLOW AND TRANSPORT     ELEMN2.........800
C ***  EQUATIONS. ALSO CALCULATES VELOCITY AT EACH ELEMENT CENTROID FOR  ELEMN2.........900
C ***  PRINTED OUTPUT. THIS SUBROUTINE HANDLES 2D CALCULATIONS ONLY;     ELEMN2........1000
C ***  3D CALCULATIONS ARE PERFORMED IN SUBROUTINE ELEMN3.               ELEMN2........1100
C                                                                        ELEMN2........1200
C                                                                        ELEMN2........1300
c rbw begin change
!      SUBROUTINE ELEMN2(ML,IN,X,Y,THICK,PITER,UITER,RCIT,RCITM1,POR,     ELEMN2........1400
!     1   ALMAX,ALMIN,ATMAX,ATMIN,PERMXX,PERMXY,PERMYX,PERMYY,PANGLE,     ELEMN2........1500
!     2   VMAG,VANG,VOL,PMAT,PVEC,UMAT,UVEC,GXSI,GETA,PVEL,LREG,IA,JA)    ELEMN2........1600
c rbw end change
C     SUBROUTINE        E  L  E  M  N  3           SUTRA VERSION 2.2     ELEMN3.........100
C                                                                        ELEMN3.........200
C *** PURPOSE :                                                          ELEMN3.........300
C ***  TO CONTROL AND CARRY OUT ALL CALCULATIONS FOR EACH ELEMENT BY     ELEMN3.........400
C ***  OBTAINING ELEMENT INFORMATION FROM THE BASIS FUNCTION ROUTINE,    ELEMN3.........500
C ***  CARRYING OUT GAUSSIAN INTEGRATION OF FINITE ELEMENT INTEGRALS,    ELEMN3.........600
C ***  AND ASSEMBLING RESULTS OF ELEMENTWISE INTEGRATIONS INTO           ELEMN3.........700
C ***  A GLOBAL MATRIX AND GLOBAL VECTOR FOR BOTH FLOW AND TRANSPORT     ELEMN3.........800
C ***  EQUATIONS. ALSO CALCULATES VELOCITY AT EACH ELEMENT CENTROID FOR  ELEMN3.........900
C ***  PRINTED OUTPUT. THIS SUBROUTINE HANDLES 3D CALCULATIONS ONLY.     ELEMN3........1000
C ***  2D CALCULATIONS ARE PERFORMED IN SUBROUTINE ELEMN2.               ELEMN3........1100
C                                                                        ELEMN3........1200
C                                                                        ELEMN3........1300
c rbw begin change
!      SUBROUTINE ELEMN3(ML,IN,X,Y,Z,PITER,UITER,RCIT,RCITM1,POR,         ELEMN3........1400
!     1   ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,                            ELEMN3........1500
!     2   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ, ELEMN3........1600
!     3   PANGL1,PANGL2,PANGL3,VMAG,VANG1,VANG2,VOL,PMAT,PVEC,            ELEMN3........1700
!     4   UMAT,UVEC,GXSI,GETA,GZET,PVEL,LREG,IA,JA)                       ELEMN3........1800
c rbw end change
C     SUBROUTINE        F  I  N  D  L  2           SUTRA VERSION 2.2     FINDL2.........100
C                                                                        FINDL2.........200
C *** PURPOSE :                                                          FINDL2.........300
C ***  TO DETERMINE WHETHER POINT (XK, YK) IN 2D GLOBAL COORDINATES      FINDL2.........400
C ***  IS CONTAINED WITHIN ELEMENT LL.  IF THE POINT IS INSIDE THE       FINDL2.........500
C ***  ELEMENT, SET INOUT = 1; IF OUTSIDE, SET INOUT = 0.  CONDITION     FINDL2.........600
C ***  INOUT = 99 SIGNALS CONVERGENCE FAILURE.  ADAPTED FROM SUTRAPLOT   FINDL2.........700
C ***  SUBROUTINE ITER2D.                                                FINDL2.........800
C                                                                        FINDL2.........900
      SUBROUTINE FINDL2(X,Y,IN,LL,XK,YK,XSI,ETA,INOUT)                   FINDL2........1000
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                FINDL2........1100
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              FINDL2........1200
     1   NSOP,NSOU,NBCN,NCIDB                                            FINDL2........1300
      DIMENSION IN(NE*4)                                                 FINDL2........1400
      DIMENSION X(NN), Y(NN)                                             FINDL2........1500
      DATA TOL /0.001/, ITRMAX /25/, EPSILON /0.001/                     FINDL2........1600
C                                                                        FINDL2........1700
C.....DEFINE OPE = (1. + EPSILON) FOR CONVENIENCE.                       FINDL2........1800
      OPE = 1D0 + EPSILON                                                FINDL2........1900
C                                                                        FINDL2........2000
C.....SET CORNER COORDINATES.                                            FINDL2........2100
      M0 = (LL - 1)*4                                                    FINDL2........2200
      X1 = X(IN(M0+1))                                                   FINDL2........2300
      X2 = X(IN(M0+2))                                                   FINDL2........2400
      X3 = X(IN(M0+3))                                                   FINDL2........2500
      X4 = X(IN(M0+4))                                                   FINDL2........2600
      Y1 = Y(IN(M0+1))                                                   FINDL2........2700
      Y2 = Y(IN(M0+2))                                                   FINDL2........2800
      Y3 = Y(IN(M0+3))                                                   FINDL2........2900
      Y4 = Y(IN(M0+4))                                                   FINDL2........3000
C                                                                        FINDL2........3100
C.....CALCULATE COEFFICIENTS.                                            FINDL2........3200
      AX = +X1+X2+X3+X4                                                  FINDL2........3300
      BX = -X1+X2+X3-X4                                                  FINDL2........3400
      CX = -X1-X2+X3+X4                                                  FINDL2........3500
      DX = +X1-X2+X3-X4                                                  FINDL2........3600
      AY = +Y1+Y2+Y3+Y4                                                  FINDL2........3700
      BY = -Y1+Y2+Y3-Y4                                                  FINDL2........3800
      CY = -Y1-Y2+Y3+Y4                                                  FINDL2........3900
      DY = +Y1-Y2+Y3-Y4                                                  FINDL2........4000
                                                                         FINDL2........4100
C                                                                        FINDL2........4200
C.....INITIAL GUESS OF ZERO FOR XSI AND ETA.                             FINDL2........4300
      XSI=0.0                                                            FINDL2........4400
      ETA=0.0                                                            FINDL2........4500
C                                                                        FINDL2........4600
C.....ITERATION LOOP TO SOLVE FOR LOCAL COORDINATES.                     FINDL2........4700
C                                                                        FINDL2........4800
      DO 800 I=1,ITRMAX                                                  FINDL2........4900
C                                                                        FINDL2........5000
         F10 = AX - 4.*XK + BX*XSI + CX*ETA + DX*XSI*ETA                 FINDL2........5100
         F20 = AY - 4.*YK + BY*XSI + CY*ETA + DY*XSI*ETA                 FINDL2........5200
         FP11 = BX + DX*ETA                                              FINDL2........5300
         FP12 = CX + DX*XSI                                              FINDL2........5400
         FP21 = BY + DY*ETA                                              FINDL2........5500
         FP22 = CY + DY*XSI                                              FINDL2........5600
C                                                                        FINDL2........5700
         DETXSI = -F10*FP22 + F20*FP12                                   FINDL2........5800
         DETETA = -F20*FP11 + F10*FP21                                   FINDL2........5900
         DETERM = FP11*FP22 - FP12*FP21                                  FINDL2........6000
         DELXSI = DETXSI/DETERM                                          FINDL2........6100
         DELETA = DETETA/DETERM                                          FINDL2........6200
C                                                                        FINDL2........6300
         XSI = XSI + DELXSI                                              FINDL2........6400
         ETA = ETA + DELETA                                              FINDL2........6500
C                                                                        FINDL2........6600
C........STOP ITERATING IF CHANGE IN XSI AND ETA < TOL.                  FINDL2........6700
         IF ((ABS(DELXSI).LT.TOL).AND.(ABS(DELETA).LT.TOL)) GOTO 900     FINDL2........6800
C                                                                        FINDL2........6900
  800 CONTINUE                                                           FINDL2........7000
C                                                                        FINDL2........7100
C.....ITERATONS FAILED TO CONVERGE.  SET INOUT = 99 AND RETURN.          FINDL2........7200
      INOUT = 99                                                         FINDL2........7300
      GOTO 1000                                                          FINDL2........7400
C                                                                        FINDL2........7500
C.....ITERATIONS CONVERGED.  IF POINT IS INSIDE THE ELEMENT,             FINDL2........7600
C        SET INOUT = 1.  IF OUTSIDE, SET INOUT = 0.                      FINDL2........7700
  900 INOUT = 1                                                          FINDL2........7800
      IF ((ABS(XSI).GT.OPE).OR.(ABS(ETA).GT.OPE)) INOUT = 0              FINDL2........7900
C                                                                        FINDL2........8000
 1000 RETURN                                                             FINDL2........8100
      END                                                                FINDL2........8200
C                                                                        FINDL2........8300
C     SUBROUTINE        F  I  N  D  L  3           SUTRA VERSION 2.2     FINDL3.........100
C                                                                        FINDL3.........200
C *** PURPOSE :                                                          FINDL3.........300
C ***  TO DETERMINE WHETHER POINT (XK, YK, ZK) IN 3D GLOBAL COORDINATES  FINDL3.........400
C ***  IS CONTAINED WITHIN ELEMENT LL.  IF THE POINT IS INSIDE THE       FINDL3.........500
C ***  ELEMENT, SET INOUT = 1; IF OUTSIDE, SET INOUT = 0.  CONDITION     FINDL3.........600
C ***  INOUT = 99 SIGNALS CONVERGENCE FAILURE.  ADAPTED FROM SUTRAPLOT   FINDL3.........700
C ***  SUBROUTINE ITER3D.                                                FINDL3.........800
C                                                                        FINDL3.........900
      SUBROUTINE FINDL3(X,Y,Z,IN,LL,XK,YK,ZK,XSI,ETA,ZET,INOUT)          FINDL3........1000
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                FINDL3........1100
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              FINDL3........1200
     1   NSOP,NSOU,NBCN,NCIDB                                            FINDL3........1300
      DIMENSION IN(NE*8)                                                 FINDL3........1400
      DIMENSION X(NN), Y(NN), Z(NN)                                      FINDL3........1500
      DATA TOL /0.001/, ITRMAX /25/, EPSILON /0.001/                     FINDL3........1600
C                                                                        FINDL3........1700
C.....DEFINE OPE = (1. + EPSILON) FOR CONVENIENCE.                       FINDL3........1800
      OPE = 1D0 + EPSILON                                                FINDL3........1900
C                                                                        FINDL3........2000
C.....SET CORNER COORDINATES.                                            FINDL3........2100
      M0 = (LL - 1)*8                                                    FINDL3........2200
      X1 = X(IN(M0+1))                                                   FINDL3........2300
      X2 = X(IN(M0+2))                                                   FINDL3........2400
      X3 = X(IN(M0+3))                                                   FINDL3........2500
      X4 = X(IN(M0+4))                                                   FINDL3........2600
      X5 = X(IN(M0+5))                                                   FINDL3........2700
      X6 = X(IN(M0+6))                                                   FINDL3........2800
      X7 = X(IN(M0+7))                                                   FINDL3........2900
      X8 = X(IN(M0+8))                                                   FINDL3........3000
      Y1 = Y(IN(M0+1))                                                   FINDL3........3100
      Y2 = Y(IN(M0+2))                                                   FINDL3........3200
      Y3 = Y(IN(M0+3))                                                   FINDL3........3300
      Y4 = Y(IN(M0+4))                                                   FINDL3........3400
      Y5 = Y(IN(M0+5))                                                   FINDL3........3500
      Y6 = Y(IN(M0+6))                                                   FINDL3........3600
      Y7 = Y(IN(M0+7))                                                   FINDL3........3700
      Y8 = Y(IN(M0+8))                                                   FINDL3........3800
      Z1 = Z(IN(M0+1))                                                   FINDL3........3900
      Z2 = Z(IN(M0+2))                                                   FINDL3........4000
      Z3 = Z(IN(M0+3))                                                   FINDL3........4100
      Z4 = Z(IN(M0+4))                                                   FINDL3........4200
      Z5 = Z(IN(M0+5))                                                   FINDL3........4300
      Z6 = Z(IN(M0+6))                                                   FINDL3........4400
      Z7 = Z(IN(M0+7))                                                   FINDL3........4500
      Z8 = Z(IN(M0+8))                                                   FINDL3........4600
C                                                                        FINDL3........4700
C.....CALCULATE COEFFICIENTS.                                            FINDL3........4800
      AX = +X1+X2+X3+X4+X5+X6+X7+X8                                      FINDL3........4900
      BX = -X1+X2+X3-X4-X5+X6+X7-X8                                      FINDL3........5000
      CX = -X1-X2+X3+X4-X5-X6+X7+X8                                      FINDL3........5100
      DX = -X1-X2-X3-X4+X5+X6+X7+X8                                      FINDL3........5200
      EX = +X1-X2+X3-X4+X5-X6+X7-X8                                      FINDL3........5300
      FX = +X1-X2-X3+X4-X5+X6+X7-X8                                      FINDL3........5400
      GX = +X1+X2-X3-X4-X5-X6+X7+X8                                      FINDL3........5500
      HX = -X1+X2-X3+X4+X5-X6+X7-X8                                      FINDL3........5600
      AY = +Y1+Y2+Y3+Y4+Y5+Y6+Y7+Y8                                      FINDL3........5700
      BY = -Y1+Y2+Y3-Y4-Y5+Y6+Y7-Y8                                      FINDL3........5800
      CY = -Y1-Y2+Y3+Y4-Y5-Y6+Y7+Y8                                      FINDL3........5900
      DY = -Y1-Y2-Y3-Y4+Y5+Y6+Y7+Y8                                      FINDL3........6000
      EY = +Y1-Y2+Y3-Y4+Y5-Y6+Y7-Y8                                      FINDL3........6100
      FY = +Y1-Y2-Y3+Y4-Y5+Y6+Y7-Y8                                      FINDL3........6200
      GY = +Y1+Y2-Y3-Y4-Y5-Y6+Y7+Y8                                      FINDL3........6300
      HY = -Y1+Y2-Y3+Y4+Y5-Y6+Y7-Y8                                      FINDL3........6400
      AZ = +Z1+Z2+Z3+Z4+Z5+Z6+Z7+Z8                                      FINDL3........6500
      BZ = -Z1+Z2+Z3-Z4-Z5+Z6+Z7-Z8                                      FINDL3........6600
      CZ = -Z1-Z2+Z3+Z4-Z5-Z6+Z7+Z8                                      FINDL3........6700
      DZ = -Z1-Z2-Z3-Z4+Z5+Z6+Z7+Z8                                      FINDL3........6800
      EZ = +Z1-Z2+Z3-Z4+Z5-Z6+Z7-Z8                                      FINDL3........6900
      FZ = +Z1-Z2-Z3+Z4-Z5+Z6+Z7-Z8                                      FINDL3........7000
      GZ = +Z1+Z2-Z3-Z4-Z5-Z6+Z7+Z8                                      FINDL3........7100
      HZ = -Z1+Z2-Z3+Z4+Z5-Z6+Z7-Z8                                      FINDL3........7200
C                                                                        FINDL3........7300
C.....INITIAL GUESS OF ZERO FOR XSI, ETA, AND ZETA.                      FINDL3........7400
      XSI=0.0                                                            FINDL3........7500
      ETA=0.0                                                            FINDL3........7600
      ZET=0.0                                                            FINDL3........7700
C                                                                        FINDL3........7800
C.....ITERATION LOOP TO SOLVE FOR LOCAL COORDINATES.                     FINDL3........7900
C                                                                        FINDL3........8000
      DO 800 I=1,ITRMAX                                                  FINDL3........8100
C                                                                        FINDL3........8200
         F10 = AX - 8.*XK + BX*XSI + CX*ETA + DX*ZET + EX*XSI*ETA        FINDL3........8300
     1        + FX*XSI*ZET + GX*ETA*ZET + HX*XSI*ETA*ZET                 FINDL3........8400
         F20 = AY - 8.*YK + BY*XSI + CY*ETA + DY*ZET + EY*XSI*ETA        FINDL3........8500
     1        + FY*XSI*ZET + GY*ETA*ZET + HY*XSI*ETA*ZET                 FINDL3........8600
         F30 = AZ - 8.*ZK + BZ*XSI + CZ*ETA + DZ*ZET + EZ*XSI*ETA        FINDL3........8700
     1        + FZ*XSI*ZET + GZ*ETA*ZET + HZ*XSI*ETA*ZET                 FINDL3........8800
         FP11 = BX + EX*ETA + FX*ZET + HX*ETA*ZET                        FINDL3........8900
         FP12 = CX + EX*XSI + GX*ZET + HX*XSI*ZET                        FINDL3........9000
         FP13 = DX + FX*XSI + GX*ETA + HX*XSI*ETA                        FINDL3........9100
         FP21 = BY + EY*ETA + FY*ZET + HY*ETA*ZET                        FINDL3........9200
         FP22 = CY + EY*XSI + GY*ZET + HY*XSI*ZET                        FINDL3........9300
         FP23 = DY + FY*XSI + GY*ETA + HY*XSI*ETA                        FINDL3........9400
         FP31 = BZ + EZ*ETA + FZ*ZET + HZ*ETA*ZET                        FINDL3........9500
         FP32 = CZ + EZ*XSI + GZ*ZET + HZ*XSI*ZET                        FINDL3........9600
         FP33 = DZ + FZ*XSI + GZ*ETA + HZ*XSI*ETA                        FINDL3........9700
C                                                                        FINDL3........9800
         S11 = FP22*FP33 - FP32*FP23                                     FINDL3........9900
         S12 = FP21*FP33 - FP31*FP23                                     FINDL3.......10000
         S13 = FP21*FP32 - FP31*FP22                                     FINDL3.......10100
         CF12 = -F20*FP33 + F30*FP23                                     FINDL3.......10200
         CF34 = -F20*FP32 + F30*FP22                                     FINDL3.......10300
         CF43 = -CF34                                                    FINDL3.......10400
         CF56 = -F30*FP21 + F20*FP31                                     FINDL3.......10500
C                                                                        FINDL3.......10600
         DETXSI = -F10*S11 - FP12*CF12 + FP13*CF34                       FINDL3.......10700
         DETETA = FP11*CF12 + F10*S12 + FP13*CF56                        FINDL3.......10800
         DETZET = FP11*CF43 - FP12*CF56 - F10*S13                        FINDL3.......10900
         DETERM = FP11*S11 - FP12*S12 + FP13*S13                         FINDL3.......11000
         DELXSI = DETXSI/DETERM                                          FINDL3.......11100
         DELETA = DETETA/DETERM                                          FINDL3.......11200
         DELZET = DETZET/DETERM                                          FINDL3.......11300
C                                                                        FINDL3.......11400
         XSI = XSI + DELXSI                                              FINDL3.......11500
         ETA = ETA + DELETA                                              FINDL3.......11600
         ZET = ZET + DELZET                                              FINDL3.......11700
C                                                                        FINDL3.......11800
C........STOP ITERATING IF CHANGE IN XSI, ETA, AND ZETA < TOL.           FINDL3.......11900
         IF ((ABS(DELXSI).LT.TOL).AND.(ABS(DELETA).LT.TOL).AND.          FINDL3.......12000
     1       (ABS(DELZET).LT.TOL)) GOTO 900                              FINDL3.......12100
C                                                                        FINDL3.......12200
  800 CONTINUE                                                           FINDL3.......12300
C                                                                        FINDL3.......12400
C.....ITERATONS FAILED TO CONVERGE.  SET INOUT = 99 AND RETURN.          FINDL3.......12500
      INOUT = 99                                                         FINDL3.......12600
      GOTO 1000                                                          FINDL3.......12700
C                                                                        FINDL3.......12800
C.....ITERATIONS CONVERGED.  IF POINT IS INSIDE THE ELEMENT,             FINDL3.......12900
C        SET INOUT = 1.  IF OUTSIDE, SET INOUT = 0.                      FINDL3.......13000
  900 INOUT = 1                                                          FINDL3.......13100
      IF ((ABS(XSI).GT.OPE).OR.(ABS(ETA).GT.OPE).OR.(ABS(ZET).GT.OPE))   FINDL3.......13200
     1   INOUT = 0                                                       FINDL3.......13300
C                                                                        FINDL3.......13400
 1000 RETURN                                                             FINDL3.......13500
      END                                                                FINDL3.......13600
C                                                                        FINDL3.......13700
C     SUBROUTINE        F  O  P  E  N              SUTRA VERSION 2.2     FOPEN..........100
C                                                                        FOPEN..........200
C *** PURPOSE :                                                          FOPEN..........300
C ***  OPENS FILES FOR SUTRA SIMULATION.  READS AND PROCESSES FILE       FOPEN..........400
C ***  SPECIFICATIONS FROM "SUTRA.FIL" AND OPENS INPUT AND OUTPUT FILES. FOPEN..........500
C                                                                        FOPEN..........600
c RBW begin change
!      SUBROUTINE FOPEN()                                                 FOPEN..........700
      SUBROUTINE FOPEN(InputFile)
c rbw end change
      USE EXPINT                                                         FOPEN..........800
      USE SCHDEF                                                         FOPEN..........900
      USE BCSDEF                                                         FOPEN.........1000
      USE FINDEF                                                         FOPEN.........1100
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                FOPEN.........1200
      PARAMETER (IUNMIN=11)                                              FOPEN.........1300
      CHARACTER*80 FT,FN,UNAME,FNAME,ENAME,ENDEF,FTSTR                   FOPEN.........1400
      CHARACTER*80 FNROOT,FNEXTN                                         FOPEN.........1500
      CHARACTER*80 ERRCOD,CHERR(10)                                      FOPEN.........1600
      CHARACTER*8 VERNUM, VERNIN                                         FOPEN.........1700
      CHARACTER INTFIL*1000                                              FOPEN.........1800
c RBW begin change
      character (len=*) InputFile
      intent (in) InputFile
c rbw end change
      LOGICAL IS                                                         FOPEN.........1900
      LOGICAL ONCEFO                                                     FOPEN.........2000
      LOGICAL ALCBCS,ALCFIN,ALCOBS                                       FOPEN.........2100
      DIMENSION FNAME(0:13),IUNIT(0:13)                                  FOPEN.........2200
      DIMENSION FTSTR(0:13)                                              FOPEN.........2300
      DIMENSION INERR(10),RLERR(10)                                      FOPEN.........2400
      DIMENSION KTYPE(2)                                                 FOPEN.........2500
      COMMON /ALC/ ALCBCS,ALCFIN,ALCOBS                                  FOPEN.........2600
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  FOPEN.........2700
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           FOPEN.........2800
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      FOPEN.........2900
      COMMON /FNAMES/ UNAME,FNAME                                        FOPEN.........3000
      COMMON /FO/ONCEFO                                                  FOPEN.........3100
      COMMON /FUNIB/ NFBCS                                               FOPEN.........3200
      COMMON /FUNITA/ IUNIT                                              FOPEN.........3300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 FOPEN.........3400
     1   K10,K11,K12,K13                                                 FOPEN.........3500
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      FOPEN.........3600
      COMMON /SCH/ NSCH,ISCHTS,NSCHAU                                    FOPEN.........3700
      COMMON /VER/ VERNUM, VERNIN                                        FOPEN.........3800
      DATA (FTSTR(NFT),NFT=0,13)/'SMY','INP','ICS','LST','RST',          FOPEN.........3900
     1   'NOD','ELE','OBS','OBC','BCS','BCOF','BCOS','BCOP','BCOU'/      FOPEN.........4000
C                                                                        FOPEN.........4100
C.....IF THIS IS THE FIRST CALL, READ AND PROCESS FILE SPECIFICATIONS    FOPEN.........4200
C        FROM "SUTRA.FIL" AND OPEN ALL OUTPUT FILES EXCEPT OBSERVATION   FOPEN.........4300
C        OUTPUT.  OBSERVATION OUTPUT FILES ARE CREATED ON THE SECOND     FOPEN.........4400
C        CALL, AFTER DATASET 8D HAS BEEN READ.                           FOPEN.........4500
      IF (.NOT.ONCEFO) THEN                                              FOPEN.........4600
C                                                                        FOPEN.........4700
C........INITIALIZE FLAGS THAT INDICATE WHETHER CERTAIN ARRAYS           FOPEN.........4800
C           HAVE BEEN ALLOCATED.  THEY ARE USED BY SUBROUTINE NAFU.      FOPEN.........4900
         ALCBCS = .FALSE.                                                FOPEN.........5000
         ALCFIN = .FALSE.                                                FOPEN.........5100
         ALCOBS = .FALSE.                                                FOPEN.........5200
C                                                                        FOPEN.........5300
C........INITIALIZE UNIT NUMBERS AND FILENAMES                           FOPEN.........5400
         K1 = -1                                                         FOPEN.........5500
         K2 = -1                                                         FOPEN.........5600
         K3 = -1                                                         FOPEN.........5700
         K4 = -1                                                         FOPEN.........5800
         K5 = -1                                                         FOPEN.........5900
         K6 = -1                                                         FOPEN.........6000
         K7 = -1                                                         FOPEN.........6100
         K8 = -1                                                         FOPEN.........6200
         K9 = -1                                                         FOPEN.........6300
         K10 = -1                                                        FOPEN.........6400
         K11 = -1                                                        FOPEN.........6500
         K12 = -1                                                        FOPEN.........6600
         K13 = -1                                                        FOPEN.........6700
         DO 20 NF=0,13                                                   FOPEN.........6800
            IUNIT(NF) = -1                                               FOPEN.........6900
            FNAME(NF) = ""                                               FOPEN.........7000
   20    CONTINUE                                                        FOPEN.........7100
C                                                                        FOPEN.........7200
C........SET DEFAULT VALUES FOR THE SMY FILE.  THE DEFAULT FILE WILL     FOPEN.........7300
C           NOT ACTUALLY BE CREATED UNLESS IT IS NEEDED.                 FOPEN.........7400
         K00 = K0 + 1                                                    FOPEN.........7500
         ENDEF = 'SUTRA.SMY'                                             FOPEN.........7600
C                                                                        FOPEN.........7700
C........OPEN FILE UNIT CONTAINING UNIT NUMBERS AND FILE ASSIGNMENTS     FOPEN.........7800
         IU=K0                                                           FOPEN.........7900
         FN=UNAME                                                        FOPEN.........8000
c rbw begin change
!         INQUIRE(FILE=UNAME,EXIST=IS)                                    FOPEN.........8100
!         IF (IS) THEN                                                    FOPEN.........8200
!            OPEN(UNIT=IU,FILE=UNAME,STATUS='OLD',FORM='FORMATTED',       FOPEN.........8300
!     1         IOSTAT=KERR)                                              FOPEN.........8400
!            IF(KERR.GT.0) GOTO 9000                                      FOPEN.........8500
!         ELSE                                                            FOPEN.........8600
!            CALL NAFU(K00,0,ENDEF)                                       FOPEN.........8700
!            OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                   FOPEN.........8800
!            GOTO 8000                                                    FOPEN.........8900
!         ENDIF                                                           FOPEN.........9000
c rbw end change
C                                                                        FOPEN.........9100
C........COUNT HOW MANY BCS FILES LISTED, THEN REWIND.  ALLOCATE AND     FOPEN.........9200
C           INITIALIZE BCS-RELATED ARRAYS IUNIB AND FNAMB, AS WELL AS    FOPEN.........9300
C           NKS, KLIST, AND FNAIN.                                       FOPEN.........9400
!         NFBCS = 0                                                       FOPEN.........9500
!   30    READ(K0,'(A)',IOSTAT=INERR(1),END=32) INTFIL                    FOPEN.........9600
!         IF (INERR(1).NE.0) THEN                                         FOPEN.........9700
!            CALL NAFU(K00,0,ENDEF)                                       FOPEN.........9800
!            OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                   FOPEN.........9900
!            ERRCOD = 'REA-FIL'                                           FOPEN........10000
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     FOPEN........10100
!         END IF                                                          FOPEN........10200
!         FT = ''                                                         FOPEN........10300
!         READ(INTFIL,*,IOSTAT=INERR(1)) FT                               FOPEN........10400
!         IF (FT.EQ.'BCS') NFBCS = NFBCS + 1                              FOPEN........10500
!         GOTO 30                                                         FOPEN........10600
!   32    REWIND(K0)                                                      FOPEN........10700
!         ALLOCATE (IUNIB(NFBCS),FNAMB(NFBCS))                            FOPEN........10800
!         ALCBCS = .TRUE.                                                 FOPEN........10900
!         ALLOCATE (NKS(2+NFBCS),KLIST(2+NFBCS,20),FNAIN(2+NFBCS,20))     FOPEN........11000
!         ALCFIN = .TRUE.                                                 FOPEN........11100
!         DO 33 N=1,2+NFBCS                                               FOPEN........11200
!            NKS(N) = 0                                                   FOPEN........11300
!   33    CONTINUE                                                        FOPEN........11400
!         DO 35 NFB=1,NFBCS                                               FOPEN........11500
!            IUNIB(NFB) = -1                                              FOPEN........11600
!            FNAMB(NFB) = ""                                              FOPEN........11700
!   35    CONTINUE                                                        FOPEN........11800
!C........COMPUTE TOTAL NUMBER OF FILE SPECIFICATIONS.                    FOPEN........11900
!         NFSPEC = 12 + NFBCS                                             FOPEN........12000
C                                                                        FOPEN........12100
C........READ IN UNIT NUMBERS AND FILE ASSIGNMENTS.  ASSIGN COMPATIBLE   FOPEN........12200
C           UNIT NUMBERS.  CLOSE UNIT K0.                                FOPEN........12300
!         NFB = 0                                                         FOPEN........12400
!         DO 90 NF=0,NFSPEC                                               FOPEN........12500
!C...........READ A FILE SPECIFICATION                                    FOPEN........12600
!            READ(K0,'(A)',IOSTAT=INERR(1),END=99) INTFIL                 FOPEN........12700
!            IF (INERR(1).NE.0) THEN                                      FOPEN........12800
!               CALL NAFU(K00,0,ENDEF)                                    FOPEN........12900
!               OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                FOPEN........13000
!               ERRCOD = 'REA-FIL'                                        FOPEN........13100
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  FOPEN........13200
!            END IF                                                       FOPEN........13300
!            IF (VERIFY(INTFIL,' ').EQ.0) GOTO 99                         FOPEN........13400
!            READ(INTFIL,*,IOSTAT=INERR(1)) FT, IU, FN                    FOPEN........13500
!            IF (INERR(1).NE.0) THEN                                      FOPEN........13600
!               CALL NAFU(K00,0,ENDEF)                                    FOPEN........13700
!               OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                FOPEN........13800
!               ERRCOD = 'REA-FIL'                                        FOPEN........13900
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  FOPEN........14000
!            END IF                                                       FOPEN........14100
!C...........CHECK FOR ILLEGAL SPECIFICATIONS                             FOPEN........14200
!            IF (FN.EQ.UNAME) THEN                                        FOPEN........14300
!               CALL NAFU(K00,0,ENDEF)                                    FOPEN........14400
!               OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                FOPEN........14500
!               ERRCOD = 'FIL-9'                                          FOPEN........14600
!               CHERR(1) = UNAME                                          FOPEN........14700
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  FOPEN........14800
!            END IF                                                       FOPEN........14900
C...........IF THE SPECIFIED UNIT NUMBER IS LESS THAN IUNMIN,            FOPEN........15000
C              SET IT TO IUNMIN                                          FOPEN........15100
!            IU = MAX(IU, IUNMIN)                                         FOPEN........15200
!C...........STORE THE FILE INFORMATION, CHECKING FOR INVALID AND         FOPEN........15300
!C              REPEATED FILE TYPE SPECIFICATIONS AND ASSIGNING UNIT      FOPEN........15400
!C              NUMBERS TO NON-OBSERVATION FILES ALONG THE WAY            FOPEN........15500
!            IF (FT.EQ.'BCS') THEN                                        FOPEN........15600
!               CALL NAFU(IU,0,FN)                                        FOPEN........15700
!               IUNIT(9) = IU                                             FOPEN........15800
!               FNAME(9) = FN                                             FOPEN........15900
!               NFB = NFB + 1                                             FOPEN........16000
!               IUNIB(NFB) = IU                                           FOPEN........16100
!               FNAMB(NFB) = FN                                           FOPEN........16200
!               GOTO 60                                                   FOPEN........16300
!            END IF                                                       FOPEN........16400
!            DO 50 NFT=0,13                                               FOPEN........16500
!               IF (FT.EQ.FTSTR(NFT)) THEN                                FOPEN........16600
!                  IF (IUNIT(NFT).EQ.-1) THEN                             FOPEN........16700
!                     IF ((NFT.LE.6).OR.(NFT.GE.9)) CALL NAFU(IU,0,FN)    FOPEN........16800
!                     IUNIT(NFT) = IU                                     FOPEN........16900
!                     FNAME(NFT) = FN                                     FOPEN........17000
!                     GOTO 60                                             FOPEN........17100
!                  ELSE                                                   FOPEN........17200
!                     CALL NAFU(K00,0,ENDEF)                              FOPEN........17300
!                     OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')          FOPEN........17400
!                     ERRCOD = 'FIL-6'                                    FOPEN........17500
!                     CHERR(1) = UNAME                                    FOPEN........17600
!                     CHERR(2) = FT                                       FOPEN........17700
!                     CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)            FOPEN........17800
!                  END IF                                                 FOPEN........17900
!               END IF                                                    FOPEN........18000
!   50       CONTINUE                                                     FOPEN........18100
!            CALL NAFU(K00,0,ENDEF)                                       FOPEN........18200
!            OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                   FOPEN........18300
!            ERRCOD = 'FIL-5'                                             FOPEN........18400
!            CHERR(1) = UNAME                                             FOPEN........18500
!            CHERR(2) = FT                                                FOPEN........18600
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     FOPEN........18700
!   60       CONTINUE                                                     FOPEN........18800
!   90    CONTINUE                                                        FOPEN........18900
!   99    CLOSE(K0)                                                       FOPEN........19000
C                                                                        FOPEN........19100
C........OPEN THE SMY FILE.                                              FOPEN........19200
C                                                                        FOPEN........19300
C........IF NO SMY SPECIFICATION, USE THE DEFAULT.                       FOPEN........19400
!         IF (IUNIT(0).EQ.-1) THEN                                        FOPEN........19500
!            CALL NAFU(K00,0,ENDEF)                                       FOPEN........19600
!            IUNIT(0) = K00                                               FOPEN........19700
!            FNAME(0) = ENDEF                                             FOPEN........19800
!         END IF                                                          FOPEN........19900
!         IU = IUNIT(0)                                                   FOPEN........20000
!         FN = FNAME(0)                                                   FOPEN........20100
!         OPEN(UNIT=IU,FILE=FN,STATUS='REPLACE',IOSTAT=KERR)              FOPEN........20200
!C........IN CASE OF ERROR WHILE OPENING SMY FILE, WRITE ERROR            FOPEN........20300
!C           MESSAGE TO DEFAULT FILE                                      FOPEN........20400
!         IF (KERR.GT.0) THEN                                             FOPEN........20500
!            CALL NAFU(K00,0,ENDEF)                                       FOPEN........20600
!            OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                   FOPEN........20700
!            GOTO 9000                                                    FOPEN........20800
!         END IF                                                          FOPEN........20900
!C........SET K00 AND ENAME                                               FOPEN........21000
!         K00 = IU                                                        FOPEN........21100
!         ENAME = FN                                                      FOPEN........21200
!C                                                                        FOPEN........21300
!C........CHECK FOR REPEATED FILENAMES (EXCEPT OBS AND OBC FILES)         FOPEN........21400
!C           AND MISSING SPECIFICATIONS FOR REQUIRED FILE TYPES           FOPEN........21500
!         DO 260 NF=0,13                                                  FOPEN........21600
!            IF ((NF.GE.7).OR.(NF.LE.9)) CYCLE                            FOPEN........21700
!            IF (IUNIT(NF).EQ.-1) THEN                                    FOPEN........21800
!               IF ((NF.GE.1).AND.(NF.LE.3)) THEN                         FOPEN........21900
!                  ERRCOD = 'FIL-7'                                       FOPEN........22000
!                  CHERR(1) = UNAME                                       FOPEN........22100
!                  CHERR(2) = FTSTR(NF)                                   FOPEN........22200
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               FOPEN........22300
!               ELSE                                                      FOPEN........22400
!                  CYCLE                                                  FOPEN........22500
!               END IF                                                    FOPEN........22600
!            END IF                                                       FOPEN........22700
!            DO 250 NF2=NF+1,13                                           FOPEN........22800
!               IF ((NF2.GE.7).OR.(NF2.LE.9)) CYCLE                       FOPEN........22900
!               IF (FNAME(NF2).EQ.FNAME(NF)) THEN                         FOPEN........23000
!                  ERRCOD = 'FIL-4'                                       FOPEN........23100
!                  CHERR(1) = UNAME                                       FOPEN........23200
!                  CHERR(2) = FNAME(NF)                                   FOPEN........23300
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               FOPEN........23400
!               END IF                                                    FOPEN........23500
!  250       CONTINUE                                                     FOPEN........23600
!            DO 255 NFB=1,NFBCS                                           FOPEN........23700
!               IF (FNAME(NFB).EQ.FNAME(NF)) THEN                         FOPEN........23800
!                  ERRCOD = 'FIL-4'                                       FOPEN........23900
!                  CHERR(1) = UNAME                                       FOPEN........24000
!                  CHERR(2) = FNAME(NF)                                   FOPEN........24100
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               FOPEN........24200
!               END IF                                                    FOPEN........24300
!  255       CONTINUE                                                     FOPEN........24400
!  260    CONTINUE                                                        FOPEN........24500
!         DO 280 NFB=1,NFBCS                                              FOPEN........24600
!            DO 270 NFB2=NFB+1,NFBCS                                      FOPEN........24700
!               IF (FNAMB(NFB2).EQ.FNAMB(NFB)) THEN                       FOPEN........24800
!                  ERRCOD = 'FIL-4'                                       FOPEN........24900
!                  CHERR(1) = UNAME                                       FOPEN........25000
!                  CHERR(2) = FNAMB(NF)                                   FOPEN........25100
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               FOPEN........25200
!               END IF                                                    FOPEN........25300
!  270       CONTINUE                                                     FOPEN........25400
!  280    CONTINUE                                                        FOPEN........25500
!C                                                                        FOPEN........25600
!C........SET UNIT NUMBERS K1 - K13.  (K00 HAS BEEN SET PREVIOUSLY.)      FOPEN........25700
!         K1=IUNIT(1)                                                     FOPEN........25800
!         K2=IUNIT(2)                                                     FOPEN........25900
!         K3=IUNIT(3)                                                     FOPEN........26000
!         K4=IUNIT(4)                                                     FOPEN........26100
!         K5=IUNIT(5)                                                     FOPEN........26200
!         K6=IUNIT(6)                                                     FOPEN........26300
!         K7=IUNIT(7)                                                     FOPEN........26400
!         K8=IUNIT(8)                                                     FOPEN........26500
!         K9=IUNIT(9)                                                     FOPEN........26600
!         K10=IUNIT(10)                                                   FOPEN........26700
!         K11=IUNIT(11)                                                   FOPEN........26800
!         K12=IUNIT(12)                                                   FOPEN........26900
!         K13=IUNIT(13)                                                   FOPEN........27000
C                                                                        FOPEN........27100
         K1=50
         K2=0
         K3=0
         K4=0
         K5=0
         K6=0
         K7=0
         K8=0
         K9=0
         K10=0
         K11=0
         K12=0
         K13=0
         NFILE=1
         IUNIT(NFILE)=K1
         FNAME(NFILE)=InputFile

C........CHECK FOR EXISTENCE OF INPUT FILES AND OPEN INPUT AND OUTPUT    FOPEN........27200
C           FILES (EXCEPT SMY, OBS, AND OBC)                             FOPEN........27300
c RBW begin change
!         DO 300 NF=1,13                                                  FOPEN........27400
         DO 300 NF=1,NFILE                                                  FOPEN........27400
c rbw end change
            IF ((NF.EQ.7).OR.(NF.EQ.8)) CYCLE                            FOPEN........27500
            IU=IUNIT(NF)                                                 FOPEN........27600
            FN=FNAME(NF)                                                 FOPEN........27700
            IF (IU.EQ.-1) GOTO 300                                       FOPEN........27800
            IF (NF.LE.2) THEN                                            FOPEN........27900
               INQUIRE(FILE=FN,EXIST=IS)                                 FOPEN........28000
               IF(IS) THEN                                               FOPEN........28100
                  OPEN(UNIT=IU,FILE=FN,STATUS='OLD',FORM='FORMATTED',    FOPEN........28200
     1               IOSTAT=KERR)                                        FOPEN........28300
               ELSE                                                      FOPEN........28400
                  GOTO 8000                                              FOPEN........28500
               ENDIF                                                     FOPEN........28600
            ELSE IF (NF.EQ.9) THEN                                       FOPEN........28700
               DO 290 NFB=1,NFBCS                                        FOPEN........28800
                  IU = IUNIB(NFB)                                        FOPEN........28900
                  FN = FNAMB(NFB)                                        FOPEN........29000
                  INQUIRE(FILE=FN,EXIST=IS)                              FOPEN........29100
                  IF(IS) THEN                                            FOPEN........29200
                     OPEN(UNIT=IU,FILE=FN,STATUS='OLD',FORM='FORMATTED', FOPEN........29300
     1                  IOSTAT=KERR)                                     FOPEN........29400
                  ELSE                                                   FOPEN........29500
                     GOTO 8000                                           FOPEN........29600
                  ENDIF                                                  FOPEN........29700
  290          CONTINUE                                                  FOPEN........29800
            ELSE                                                         FOPEN........29900
               OPEN(UNIT=IU,FILE=FN,STATUS='REPLACE',FORM='FORMATTED',   FOPEN........30000
     1            IOSTAT=KERR)                                           FOPEN........30100
            ENDIF                                                        FOPEN........30200
            IF(KERR.GT.0) GOTO 9000                                      FOPEN........30300
  300    CONTINUE                                                        FOPEN........30400
C                                                                        FOPEN........30500
C........SET FLAG TO INDICATE THAT FIRST CALL IS COMPLETED, THEN RETURN  FOPEN........30600
         ONCEFO = .TRUE.                                                 FOPEN........30700
         RETURN                                                          FOPEN........30800
C                                                                        FOPEN........30900
      ELSE                                                               FOPEN........31000
C                                                                        FOPEN........31100
C........ALLOCATE AND INITIALIZE OBSERVATION-RELATED UNIT NUMBERS        FOPEN........31200
C           AND FILENAMES                                                FOPEN........31300
         ALLOCATE(IUNIO(NFLOMX),FNAMO(NFLOMX))                           FOPEN........31400
         ALCOBS = .TRUE.                                                 FOPEN........31500
         DO 330 NFO=1,NFLOMX                                             FOPEN........31600
            IUNIO(NFO) = -1                                              FOPEN........31700
            FNAMO(NFO) = ""                                              FOPEN........31800
  330    CONTINUE                                                        FOPEN........31900
C                                                                        FOPEN........32000
C........OPEN OBS AND OBC FILES, AUTOMATICALLY GENERATING UNIT NUMBERS   FOPEN........32100
C           AND FILENAMES                                                FOPEN........32200
C                                                                        FOPEN........32300
C........LOOP OVER THE TWO FILE TYPES                                    FOPEN........32400
!         DO 400 NF=7,8                                                   FOPEN........32500
!C...........IF NO FILE SPECIFICATION OF THIS TYPE, MOVE ON               FOPEN........32600
!            IF (IUNIT(NF).EQ.-1) CYCLE                                   FOPEN........32700
!C...........DETERMINE LENGTH OF THE SPECIFIED FILENAME AND ITS ROOT      FOPEN........32800
!            LNAME = LEN_TRIM(FNAME(NF))                                  FOPEN........32900
!            LROOT = SCAN(FNAME(NF),'.',BACK=.TRUE.) - 1                  FOPEN........33000
!C...........SET THE ROOT NAME AND EXTENSION THAT WILL BE USED FOR FILES  FOPEN........33100
!C              OF THIS TYPE                                              FOPEN........33200
!            IF (LROOT.NE.-1) THEN                                        FOPEN........33300
!               IF (LROOT.NE.0) THEN                                      FOPEN........33400
!                  FNROOT = FNAME(NF)(1:LROOT)                            FOPEN........33500
!               ELSE                                                      FOPEN........33600
!                  FNROOT = "SUTRA"                                       FOPEN........33700
!               END IF                                                    FOPEN........33800
!               IF (LROOT.NE.LNAME-1) THEN                                FOPEN........33900
!                  FNEXTN = FNAME(NF)(LROOT+1:LNAME)                      FOPEN........34000
!               ELSE                                                      FOPEN........34100
!                  FNEXTN = "." // FTSTR(NF)                              FOPEN........34200
!               END IF                                                    FOPEN........34300
!            ELSE                                                         FOPEN........34400
!               IF (LNAME.NE.0) THEN                                      FOPEN........34500
!                  FNROOT = FNAME(NF)                                     FOPEN........34600
!               ELSE                                                      FOPEN........34700
!                  FNROOT = "SUTRA"                                       FOPEN........34800
!               END IF                                                    FOPEN........34900
!               FNEXTN = "." // FTSTR(NF)                                 FOPEN........35000
!            END IF                                                       FOPEN........35100
!C...........INITIALIZE UNIT NUMBER                                       FOPEN........35200
!            IUNEXT = IUNIT(NF)                                           FOPEN........35300
!C...........LOOP OVER OBSERVATION OUTPUT FILES                           FOPEN........35400
!            DO 380 J=1,NFLOMX                                            FOPEN........35500
!               JM1 = J - 1                                               FOPEN........35600
!C..............IF FILE IS NOT OF THE TYPE CURRENTLY BEING PROCESSED,     FOPEN........35700
!C                 SKIP FILE                                              FOPEN........35800
!               IF (OFP(J)%FRMT.NE.FTSTR(NF)) CYCLE                       FOPEN........35900
!C..............CONSTRUCT FILENAME FROM ROOT NAME, SCHEDULE NAME,         FOPEN........36000
!C                 AND EXTENSION                                          FOPEN........36100
!               IF ((ISSTRA.NE.1).AND.                                    FOPEN........36200
!     1             (SCHDLS(OFP(J)%ISCHED)%NAME.NE."-")) THEN             FOPEN........36300
!                  FN = TRIM(FNROOT) // "_"                               FOPEN........36400
!     1               // TRIM(SCHDLS(OFP(J)%ISCHED)%NAME) // FNEXTN       FOPEN........36500
!               ELSE                                                      FOPEN........36600
!                  FN = TRIM(FNROOT) // FNEXTN                            FOPEN........36700
!               END IF                                                    FOPEN........36800
!C..............CHECK FOR DUPLICATE FILENAME AMONG NON-OBSERVATION        FOPEN........36900
!C                 FILES                                                  FOPEN........37000
!               DO 350 NFF=0,13                                           FOPEN........37100
!                  IF ((NFF.GE.7).OR.(NFF.LE.9)) CYCLE                    FOPEN........37200
!                  IF (FN.EQ.FNAME(NFF)) THEN                             FOPEN........37300
!                     ERRCOD = 'FIL-4'                                    FOPEN........37400
!                     CHERR(1) = UNAME                                    FOPEN........37500
!                     CHERR(2) = FN                                       FOPEN........37600
!                     CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)            FOPEN........37700
!                  END IF                                                 FOPEN........37800
!  350          CONTINUE                                                  FOPEN........37900
!               DO 352 NFB=1,NFBCS                                        FOPEN........38000
!                  IF (FN.EQ.FNAMB(NFB)) THEN                             FOPEN........38100
!                     ERRCOD = 'FIL-4'                                    FOPEN........38200
!                     CHERR(1) = UNAME                                    FOPEN........38300
!                     CHERR(2) = FN                                       FOPEN........38400
!                     CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)            FOPEN........38500
!                  END IF                                                 FOPEN........38600
!  352          CONTINUE                                                  FOPEN........38700
!C..............CHECK FOR DUPLICATE FILENAME AMONG PREVIOUSLY DEFINED     FOPEN........38800
!C                 OBSERVATION OUTPUT FILES                               FOPEN........38900
!               DO 355 NJ=1,J-1                                           FOPEN........39000
!                  IF (FN.EQ.FNAMO(NJ)) THEN                              FOPEN........39100
!                     ERRCOD = 'FIL-4'                                    FOPEN........39200
!                     CHERR(1) = UNAME                                    FOPEN........39300
!                     CHERR(2) = FN                                       FOPEN........39400
!                     CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)            FOPEN........39500
!                  END IF                                                 FOPEN........39600
!  355          CONTINUE                                                  FOPEN........39700
!C..............ASSIGN NEXT AVAILABLE UNIT NUMBER, RECORD FILE            FOPEN........39800
!C                 INFORMATION, AND OPEN THE FILE                         FOPEN........39900
!               CALL NAFU(IUNEXT,JM1,FN)                                  FOPEN........40000
!               IU = IUNEXT                                               FOPEN........40100
!               IUNIO(J) = IU                                             FOPEN........40200
!               FNAMO(J) = FN                                             FOPEN........40300
!               INQUIRE(UNIT=IU, OPENED=IS)                               FOPEN........40400
!               OPEN(UNIT=IU,FILE=FN,STATUS='REPLACE',FORM='FORMATTED',   FOPEN........40500
!     1            IOSTAT=KERR)                                           FOPEN........40600!
!               IF(KERR.GT.0) GOTO 9000                                   FOPEN........40700
!  380       CONTINUE                                                     FOPEN........40800
!  400    CONTINUE                                                        FOPEN........40900
C                                                                        FOPEN........41000
C........SECOND CALL IS COMPLETED, SO RETURN                             FOPEN........41100
         RETURN                                                          FOPEN........41200
C                                                                        FOPEN........41300
      END IF                                                             FOPEN........41400
C                                                                        FOPEN........41500
 8000 CONTINUE                                                           FOPEN........41600
c rbw begin change
       IErrorFlag = 37
       return
c rbw end change
C.....GENERATE ERROR                                                     FOPEN........41700
      ERRCOD = 'FIL-1'                                                   FOPEN........41800
      CHERR(1) = UNAME                                                   FOPEN........41900
      CHERR(2) = FN                                                      FOPEN........42000
      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           FOPEN........42100
C                                                                        FOPEN........42200
 9000 CONTINUE                                                           FOPEN........42300
C.....GENERATE ERROR                                                     FOPEN........42400
c rbw begin change
           IErrorFlag = 38
           return
c rbw end change
      ERRCOD = 'FIL-2'                                                   FOPEN........42500
      CHERR(1) = UNAME                                                   FOPEN........42600
      CHERR(2) = FN                                                      FOPEN........42700
      INERR(1) = IU                                                      FOPEN........42800
      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           FOPEN........42900
C                                                                        FOPEN........43000
      END                                                                FOPEN........43100
C                                                                        FOPEN........43200
C     FUNCTION          F  R  C  S  T  P           SUTRA VERSION 2.2     FRCSTP.........100
C                                                                        FRCSTP.........200
C *** PURPOSE :                                                          FRCSTP.........300
C ***  TO RETURN THE FRACTIONAL TIME STEP FOR A GIVEN TIME.  IF THE      FRCSTP.........400
C ***  SPECIFIED TIME IS GREATER THAN THE MAXIMUM, A VALUE OF            FRCSTP.........500
C ***  +HUGE(1D0) (THE LARGEST NUMBER THAT CAN BE REPRESENTED IN DOUBLE  FRCSTP.........600
C ***  PRECISION) IS RETURNED.  IF THE SPECIFIED TIME IS LESS THAN       FRCSTP.........700
C ***  TSTART, A VALUE OF -HUGE(1D0) IS RETURNED.  IF THE TIME STEP      FRCSTP.........800
C ***  SCHEDULE HAS NOT YET BEEN DEFINED, A VALUE OF ZERO IS RETURNED.   FRCSTP.........900
C                                                                        FRCSTP........1000
      DOUBLE PRECISION FUNCTION FRCSTP(TIME)                             FRCSTP........1100
      USE LLDEF                                                          FRCSTP........1200
      USE SCHDEF                                                         FRCSTP........1300
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                FRCSTP........1400
      TYPE (LLD), POINTER :: DEN                                         FRCSTP........1500
      COMMON /SCH/ NSCH,ISCHTS,NSCHAU                                    FRCSTP........1600
C                                                                        FRCSTP........1700
      IF (ISCHTS.EQ.0) THEN                                              FRCSTP........1800
         FRCSTP = DNINT(DBLE(0))                                         FRCSTP........1900
         RETURN                                                          FRCSTP........2000
      END IF                                                             FRCSTP........2100
C                                                                        FRCSTP........2200
      NSMAX = SCHDLS(ISCHTS)%LLEN - 1                                    FRCSTP........2300
C                                                                        FRCSTP........2400
      DEN => SCHDLS(ISCHTS)%SLIST                                        FRCSTP........2500
      T1 = DEN%DVALU1                                                    FRCSTP........2600
      IF (TIME.EQ.T1) THEN                                               FRCSTP........2700
         FRCSTP = DNINT(DBLE(0))                                         FRCSTP........2800
         RETURN                                                          FRCSTP........2900
      ELSE IF (TIME.LT.T1) THEN                                          FRCSTP........3000
         FRCSTP = -HUGE(1D0)                                             FRCSTP........3100
         RETURN                                                          FRCSTP........3200
      END IF                                                             FRCSTP........3300
      DO 100 NS=1,NSMAX                                                  FRCSTP........3400
         DEN => DEN%NENT                                                 FRCSTP........3500
         T2 = DEN%DVALU1                                                 FRCSTP........3600
         IF (TIME.EQ.T2) THEN                                            FRCSTP........3700
            FRCSTP = DNINT(DBLE(NS))                                     FRCSTP........3800
            RETURN                                                       FRCSTP........3900
         ELSE IF (TIME.LT.T2) THEN                                       FRCSTP........4000
            WT = (TIME - T1)/(T2 - T1)                                   FRCSTP........4100
            S1 = DBLE(NS - 1)                                            FRCSTP........4200
            S2 = DBLE(NS)                                                FRCSTP........4300
            FRCSTP = (1D0 - WT)*S1 + WT*S2                               FRCSTP........4400
            RETURN                                                       FRCSTP........4500
         END IF                                                          FRCSTP........4600
  100 CONTINUE                                                           FRCSTP........4700
      FRCSTP = +HUGE(1D0)                                                FRCSTP........4800
C                                                                        FRCSTP........4900
      RETURN                                                             FRCSTP........5000
      END                                                                FRCSTP........5100
C                                                                        FRCSTP........5200
C     SUBROUTINE        G  L  O  B  A  N           SUTRA VERSION 2.2     GLOBAN.........100
C                                                                        GLOBAN.........200
C *** PURPOSE :                                                          GLOBAN.........300
C ***  TO ASSEMBLE RESULTS OF ELEMENTWISE INTEGRATIONS INTO              GLOBAN.........400
C ***  A GLOBAL BANDED MATRIX AND GLOBAL VECTOR FOR BOTH                 GLOBAN.........500
C ***  FLOW AND TRANSPORT EQUATIONS.                                     GLOBAN.........600
C                                                                        GLOBAN.........700
c rbw begin change
!      SUBROUTINE GLOBAN(L,ML,VOLE,BFLOWE,DFLOWE,BTRANE,DTRANE,           GLOBAN.........800
!     1      IN,VOL,PMAT,PVEC,UMAT,UVEC)                                  GLOBAN.........900
c rbw end change
C     SUBROUTINE        G  L  O  C  O  L           SUTRA VERSION 2.2     GLOCOL.........100
C                                                                        GLOCOL.........200
C *** PURPOSE :                                                          GLOCOL.........300
C ***  TO ASSEMBLE RESULTS OF ELEMENTWISE INTEGRATIONS INTO              GLOCOL.........400
C ***  A GLOBAL "SLAP COLUMN"-FORMAT MATRIX AND GLOBAL VECTOR            GLOCOL.........500
C ***  FOR BOTH FLOW AND TRANSPORT EQUATIONS.                            GLOCOL.........600
C                                                                        GLOCOL.........700
c rbw begin change
!      SUBROUTINE GLOCOL(L,ML,VOLE,BFLOWE,DFLOWE,BTRANE,DTRANE,           GLOCOL.........800
!     1      IN,VOL,PMAT,PVEC,UMAT,UVEC,IA,JA)                            GLOCOL.........900
c rbw end change
C     SUBROUTINE        I  N  D  A  T  0           SUTRA VERSION 2.2     INDAT0.........100
C                                                                        INDAT0.........200
C *** PURPOSE :                                                          INDAT0.........300
C ***  TO INPUT, OUTPUT, AND ORGANIZE A PORTION OF THE INP FILE          INDAT0.........400
C ***  INPUT DATA (DATASETS 5 THROUGH 7)                                 INDAT0.........500
C                                                                        INDAT0.........600
      SUBROUTINE INDAT0()                                                INDAT0.........700
c rbw begin change
      USE ErrorFlag
c rbw end change
      USE EXPINT                                                         INDAT0.........800
      USE LLDEF                                                          INDAT0.........900
      USE SCHDEF                                                         INDAT0........1000
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                INDAT0........1100
      CHARACTER INTFIL*1000                                              INDAT0........1200
      CHARACTER*10 ADSMOD                                                INDAT0........1300
      CHARACTER SOLWRD(0:10)*10,SOLNAM(0:10)*40                          INDAT0........1400
      CHARACTER*10 CSOLVP,CSOLVU                                         INDAT0........1500
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:13)                    INDAT0........1600
      CHARACTER SCHTYP*12, CDUM10*10, CDUM80*80                          INDAT0........1700
      CHARACTER*10 SCHNAM                                                INDAT0........1800
      CHARACTER CTICS*20, CREFT*8                                        INDAT0........1900
      DIMENSION INERR(10),RLERR(10)                                      INDAT0........2000
      DIMENSION KTYPE(2)                                                 INDAT0........2100
      ALLOCATABLE :: ISLIST(:), TLIST(:), DTMP1(:), DTMP2(:)             INDAT0........2200
      CHARACTER*8 VERNUM, VERNIN                                         INDAT0........2300
      LOGICAL, ALLOCATABLE :: SBASED(:), ELAPSD(:)                       INDAT0........2400
      LOGICAL TSYES                                                      INDAT0........2500
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  INDAT0........2600
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           INDAT0........2700
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      INDAT0........2800
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              INDAT0........2900
     1   NSOP,NSOU,NBCN,NCIDB                                            INDAT0........3000
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        INDAT0........3100
      COMMON /DIMX2/ NELTA,NNVEC,NDIMIA,NDIMJA                           INDAT0........3200
      COMMON /FNAMES/ UNAME,FNAME                                        INDAT0........3300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 INDAT0........3400
     1   K10,K11,K12,K13                                                 INDAT0........3500
      COMMON /GRAVEC/ GRAVX,GRAVY,GRAVZ                                  INDAT0........3600
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      INDAT0........3700
      COMMON /ITSOLI/ ITRMXP,ITOLP,NSAVEP,ITRMXU,ITOLU,NSAVEU            INDAT0........3800
      COMMON /ITSOLR/ TOLP,TOLU                                          INDAT0........3900
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,                INDAT0........4000
     1   KPANDS,KVEL,KCORT,KBUDG,KSCRN,KPAUSE                            INDAT0........4100
      COMMON /MODSOR/ ADSMOD                                             INDAT0........4200
      COMMON /SCH/ NSCH,ISCHTS,NSCHAU                                    INDAT0........4300
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      INDAT0........4400
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        INDAT0........4500
      COMMON /SOLVC/ SOLWRD,SOLNAM                                       INDAT0........4600
      COMMON /SOLVI/ KSOLVP,KSOLVU,NN1,NN2,NN3                           INDAT0........4700
      COMMON /SOLVN/ NSLVRS                                              INDAT0........4800
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       INDAT0........4900
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART      INDAT0........5000
      COMMON /VER/ VERNUM, VERNIN                                        INDAT0........5100
C                                                                        INDAT0........5200
      INSTOP=0                                                           INDAT0........5300
C                                                                        INDAT0........5400
C.....INPUT DATASET 5: NUMERICAL CONTROL PARAMETERS                      INDAT0........5500
      ERRCOD = 'REA-INP-5'                                               INDAT0........5600
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT0........5700
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 158
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) UP,GNUP,GNUU                        INDAT0........5800
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0........5900
      IF (INERR(1).NE.0) then
        IErrorFlag = 39
        return
      endif
!      IF(ME.EQ.-1) WRITE(K3,70) UP,GNUP,GNUU                             INDAT0........6000
c rbw end change
   70 FORMAT(////11X,'N U M E R I C A L   C O N T R O L   D A T A'//     INDAT0........6100
     1   11X,F15.5,5X,'"UPSTREAM WEIGHTING" FACTOR'/                     INDAT0........6200
     2   11X,1PE15.4,5X,'SPECIFIED PRESSURE BOUNDARY CONDITION FACTOR'/  INDAT0........6300
     3   11X,1PE15.4,5X,'SPECIFIED CONCENTRATION BOUNDARY CONDITION ',   INDAT0........6400
     4   'FACTOR')                                                       INDAT0........6500
c rbw begin change
!      IF(ME.EQ.+1) WRITE(K3,80) UP,GNUP,GNUU                             INDAT0........6600
c rbw end change
   80 FORMAT(////11X,'N U M E R I C A L   C O N T R O L   D A T A'//     INDAT0........6700
     1   11X,F15.5,5X,'"UPSTREAM WEIGHTING" FACTOR'/                     INDAT0........6800
     2   11X,1PE15.4,5X,'SPECIFIED PRESSURE BOUNDARY CONDITION FACTOR'/  INDAT0........6900
     3   11X,1PE15.4,5X,'SPECIFIED TEMPERATURE BOUNDARY CONDITION ',     INDAT0........7000
     4   'FACTOR')                                                       INDAT0........7100
C                                                                        INDAT0........7200
C.....INPUT DATASET 6: TEMPORAL CONTROL AND SOLUTION CYCLING DATA        INDAT0........7300
c rbw begin change
!      ERRCOD = 'REA-ICS-1'                                               INDAT0........7400
!      CALL READIF(K2, 0, INTFIL, ERRCOD)                                 INDAT0........7500
c rbw end change
      TICS = 0
!      IF (IREAD.EQ.+1) THEN                                              INDAT0........7600
!         READ(INTFIL,*,IOSTAT=INERR(1)) TICS                             INDAT0........7700
!      ELSE                                                               INDAT0........7800
!         READ(INTFIL,*,IOSTAT=INERR(1)) TICS,DUM,DUM,IDUM,TICS0          INDAT0........7900
!      END IF                                                             INDAT0........8000
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0........8100
!      REWIND(K2)                                                         INDAT0........8200
!      WRITE(CTICS,'(E20.10)') TICS                                       INDAT0........8300
!      WRITE(K3,120)                                                      INDAT0........8400
c rbw end change
  120 FORMAT('1'////11X,'T E M P O R A L   C O N T R O L   A N D   ',    INDAT0........8500
     1   'S O L U T I O N   C Y C L I N G   D A T A')                    INDAT0........8600
      ERRCOD = 'REA-INP-6'                                               INDAT0........8700
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT0........8800
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 160
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NSCH                                INDAT0........8900
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0........9000
      IF (INERR(1).NE.0) then
        IErrorFlag = 41
        return
      endif
c rbw end change
C.....SET NUMBER OF USUAL AUTOMATIC SCHEDULES THAT WILL BE CREATED.      INDAT0........9100
C        CURRENTLY, THESE ARE "STEPS_1&UP", "STEP_0", AND "STEP_1".      INDAT0........9200
      NSCHAU = 3                                                         INDAT0........9300
C.....IF VERSION 2.0 INPUT, RE-READ DATASET IN OLD FORMAT.  ELSE IF      INDAT0........9400
C        NSCH>0, RE-READ FIRST LINE OF DATASET IN NEW FORMAT.  ELSE      INDAT0........9500
C        IF NSCH<0, OR NSCH=0 AND TRANSPORT IS NOT STEADY-STATE,         INDAT0........9600
C        GENERATE ERROR.                                                 INDAT0........9700
      IF (VERNIN.EQ."2.0") THEN                                          INDAT0........9800
C........READ TEMPORAL AND SOLUTION CYCLING CONTROLS.                    INDAT0........9900
         READ(INTFIL,*,IOSTAT=INERR(1)) ITMAX,DELT,TMAX,ITCYC,DTMULT,    INDAT0.......10000
     1      DTMAX,NPCYC,NUCYC                                            INDAT0.......10100
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......10200
         IF (INERR(1).NE.0) then
           IErrorFlag = 42
           return
         endif
c rbw end change
C........ERROR CHECKING SPECIFIC TO OLD FORMAT.                          INDAT0.......10300
         IF (DELT.GT.DTMAX) THEN                                         INDAT0.......10400
c rbw begin change
           IErrorFlag = 43
           return
!            ERRCOD = 'INP-6-3'                                           INDAT0.......10500
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......10600
c rbw end change
         END IF                                                          INDAT0.......10700
      ELSE IF (NSCH.GT.0) THEN                                           INDAT0.......10800
C........READ FIRST LINE OF DATASET.                                     INDAT0.......10900
         READ(INTFIL,*,IOSTAT=INERR(1)) NSCH, NPCYC, NUCYC               INDAT0.......11000
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......11100
         IF (INERR(1).NE.0) then
           IErrorFlag = 44
           return
         endif
c rbw end change
      ELSE IF (NSCH.LT.0) THEN                                           INDAT0.......11200
c rbw begin change
           IErrorFlag = 45
           return
!            ERRCOD = 'INP-6-8'                                           INDAT0.......11300
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......11400
c rbw end change
      ELSE                                                               INDAT0.......11500
         IF (ISSTRA.EQ.0) THEN                                           INDAT0.......11600
c rbw begin change
           IErrorFlag = 46
           return
!            ERRCOD = 'INP-6-13'                                          INDAT0.......11700
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......11800
c rbw end change
         END IF                                                          INDAT0.......11900
         NPCYC = 1                                                       INDAT0.......12000
         NUCYC = 1                                                       INDAT0.......12100
      END IF                                                             INDAT0.......12200
C.....ERROR CHECKING COMMON TO BOTH FORMATS.                             INDAT0.......12300
      IF (NPCYC.LT.1.OR.NUCYC.LT.1) THEN                                 INDAT0.......12400
c rbw begin change
           IErrorFlag = 47
           return
!         ERRCOD = 'INP-6-1'                                              INDAT0.......12500
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......12600
c rbw end change
      ELSE IF (NPCYC.NE.1.AND.NUCYC.NE.1) THEN                           INDAT0.......12700
c rbw begin change
           IErrorFlag = 48
           return
!         ERRCOD = 'INP-6-2'                                              INDAT0.......12800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......12900
c rbw end change
      END IF                                                             INDAT0.......13000
C.....IF TRANSPORT IS STEADY-STATE, SKIP THROUGH THE REST OF THE         INDAT0.......13100
C        DATASET AND CREATE A TRIVIAL "TIME_STEPS" SCHEDULE.             INDAT0.......13200
C        (NOTE THAT IF TRANSPORT IS STEADY-STATE, SO IS FLOW.)           INDAT0.......13300
C        EVENTUALLY, IN ADDITION, THE USUAL AUTOMATIC SCHEDULES WILL     INDAT0.......13400
C        BE CREATED.                                                     INDAT0.......13500
      IF (ISSTRA.EQ.1) THEN                                              INDAT0.......13600
         TSTART = TICS                                                   INDAT0.......13700
         IF (VERNIN.NE."2.0") THEN                                       INDAT0.......13800
            ERRCOD = 'REA-INP-6'                                         INDAT0.......13900
            CDUM10 = ''                                                  INDAT0.......14000
            DO WHILE (CDUM10.NE.'-')                                     INDAT0.......14100
               CALL READIF(K1, 0, INTFIL, ERRCOD)                        INDAT0.......14200

c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 161
        return
      endif
c rbw end change
c rbw begin change
!               IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR,      INDAT0.......14300
!     1            RLERR)                                                 INDAT0.......14400
               IF (INERR(1).NE.0) then
                 IErrorFlag = 49
                 return
               endif
c rbw end change
               READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10                     INDAT0.......14500
            END DO                                                       INDAT0.......14600
            DELT = MAX(1D-1*DABS(TSTART), 1D0)                           INDAT0.......14700
         END IF                                                          INDAT0.......14800
         NSCH = 1 + NSCHAU                                               INDAT0.......14900
         ALLOCATE(SCHDLS(NSCH))                                          INDAT0.......15000
         DO 135 NS=1,NSCH                                                INDAT0.......15100
            ALLOCATE(SCHDLS(NS)%SLIST, SCHDLS(NS)%SLAST)                 INDAT0.......15200
            SCHDLS(NS)%LLEN = 0                                          INDAT0.......15300
  135    CONTINUE                                                        INDAT0.......15400
         ISCHTS = 1                                                      INDAT0.......15500
         SCHDLS(ISCHTS)%NAME = 'TIME_STEPS'                              INDAT0.......15600
         NS1UP = 2                                                       INDAT0.......15700
         SCHDLS(NS1UP)%NAME = 'STEPS_1&UP'                               INDAT0.......15800
         NS0 = 3                                                         INDAT0.......15900
         SCHDLS(NS0)%NAME = 'STEP_0'                                     INDAT0.......16000
         NS1 = 4                                                         INDAT0.......16100
         SCHDLS(NS1)%NAME = 'STEP_1'                                     INDAT0.......16200
         TIME = TSTART                                                   INDAT0.......16300
         STEP = 0D0                                                      INDAT0.......16400
         CALL LLDINS(SCHDLS(ISCHTS)%LLEN, SCHDLS(ISCHTS)%SLIST, TIME,    INDAT0.......16500
     1      STEP, SCHDLS(ISCHTS)%SLAST)                                  INDAT0.......16600
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         CALL LLDINS(SCHDLS(NS0)%LLEN, SCHDLS(NS0)%SLIST, TIME, STEP,    INDAT0.......16700
     1      SCHDLS(NS0)%SLAST)                                           INDAT0.......16800
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         TIME = TIME + DELT                                              INDAT0.......16900
         STEP = 1D0                                                      INDAT0.......17000
         CALL LLDINS(SCHDLS(ISCHTS)%LLEN, SCHDLS(ISCHTS)%SLIST, TIME,    INDAT0.......17100
     1      STEP, SCHDLS(ISCHTS)%SLAST)                                  INDAT0.......17200
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         CALL LLDINS(SCHDLS(NS1)%LLEN, SCHDLS(NS1)%SLIST, TIME, STEP,    INDAT0.......17300
     1      SCHDLS(NS1)%SLAST)                                           INDAT0.......17400
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         CALL LLDINS(SCHDLS(NS1UP)%LLEN, SCHDLS(NS1UP)%SLIST, TIME,      INDAT0.......17500
     1       STEP, SCHDLS(NS1UP)%SLAST)                                  INDAT0.......17600
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         ITMAX = 1                                                       INDAT0.......17700
C........WRITE STEADY-STATE OUTPUT INFORMATION AND BEGIN WRITING         INDAT0.......17800
C           DESCRIPTIONS OF SCHEDULES DEFINED BY SUTRA.                  INDAT0.......17900
c rbw begin change
!         WRITE(K3,138) NSCH                                              INDAT0.......18000
c rbw end change
  138    FORMAT (/13X,'NOTE: BECAUSE FLOW AND TRANSPORT ARE STEADY-',    INDAT0.......18100
     1      'STATE, USER-DEFINED SCHEDULES ARE NOT IN EFFECT.  '         INDAT0.......18200
     2      /13X,'STEADY-STATE RESULTS WILL BE WRITTEN TO THE ',         INDAT0.......18300
     3      'APPROPRIATE OUTPUT FILES.'                                  INDAT0.......18400
     4      //13X,'THE FOLLOWING ',I1,' SCHEDULES CAN BE USED ',         INDAT0.......18500
     5      'TO CONTROL SPECIFICATION OF STEADY-STATE BOUNDARY'          INDAT0.......18600
     6      /13X,'CONDITIONS IN (OPTIONAL) .BCS FILES:')                 INDAT0.......18700
c rbw begin change
!         WRITE(K3,139) "TIME_STEPS"                                      INDAT0.......18800
c rbw end change
  139    FORMAT(/16X,'SCHEDULE ',A10, 3X,'CONSISTS OF TIME STEPS 0 ',    INDAT0.......18900
     1      '(STEADY FLOW) AND 1 (STEADY TRANSPORT);',                   INDAT0.......19000
     2      /41X,'THIS SCHEDULE IS DEFINED AUTOMATICALLY BY SUTRA')      INDAT0.......19100
C........SKIP OVER PROCESSING AND WRITING OF TEMPORAL DATA.              INDAT0.......19200
         GOTO 846                                                        INDAT0.......19300
      END IF                                                             INDAT0.......19400
C.....IF DATASET IN OLD FORMAT, WRITE SPECIFICATIONS AND                 INDAT0.......19500
C        CREATE A CORRESPONDING SCHEDULE CALLED "TIME_STEPS".            INDAT0.......19600
C        IF NSCH=0, GENERATE AN ERROR.  IF IN NEW FORMAT, READ           INDAT0.......19700
C        AND PROCESS USER-DEFINED SCHEDULES.                             INDAT0.......19800
      IF (VERNIN.EQ."2.0") THEN                                          INDAT0.......19900
         TSTART = TICS                                                   INDAT0.......20000
c rbw begin change
!         WRITE(K3,150) ITMAX,DELT,TMAX,ITCYC,DTMULT,DTMAX                INDAT0.......20100
c rbw end change
  150    FORMAT (/13X,'NOTE: BECAUSE TEMPORAL CONTROL AND SOLUTION ',    INDAT0.......20200
     1      'CYCLING DATA WERE ENTERED USING THE OLD (VERSION 2D3D.1) ', INDAT0.......20300
     2      'INPUT FORMAT,'/13X,'A CORRESPONDING SCHEDULE, ',            INDAT0.......20400
     3      '"TIME_STEPS", WAS CREATED AUTOMATICALLY FROM THE ',         INDAT0.......20500
     4      'FOLLOWING PARAMETERS:'                                      INDAT0.......20600
     5      //11X,I15,5X,'MAXIMUM ALLOWED NUMBER OF TIME STEPS'          INDAT0.......20700
     6      /11X,1PE15.4,5X,'INITIAL TIME STEP (IN SECONDS)'             INDAT0.......20800
     7      /11X,1PE15.4,5X,'MAXIMUM ALLOWED SIMULATION TIME ',          INDAT0.......20900
     8      '(IN SECONDS)'                                               INDAT0.......21000
     9      //11X,I15,5X,'TIME STEP MULTIPLIER CYCLE (IN TIME STEPS)'    INDAT0.......21100
     1      /11X,0PF15.5,5X,'MULTIPLICATION FACTOR FOR TIME STEP CHANGE' INDAT0.......21200
     2      /11X,1PE15.4,5X,'MAXIMUM ALLOWED TIME STEP (IN SECONDS)')    INDAT0.......21300
C........FIVE DEFAULT SCHEDULES WILL EVENTUALLY BE DEFINED:              INDAT0.......21400
C           "TIME_STEPS", WHICH CONTROLS TIME STEPPING; "STEPS_1&UP",    INDAT0.......21500
C           WHICH IS IDENTICAL TO "TIME_STEPS" EXCEPT THAT IT OMITS      INDAT0.......21600
C           TIME STEP 0; "STEP_0", WHICH CONSISTS ONLY OF TIME STEP 0;   INDAT0.......21700
C           "STEP_1", WHICH CONSISTS ONLY OF TIME STEP 1; AND "OBS",     INDAT0.......21800
C           WHICH CONTROLS TIMING OF OBSERVATION OUTPUT.  SET THE        INDAT0.......21900
C           NUMBER OF SCHEDULES ACCORDINGLY AND ALLOCATE THE SCHEDULE    INDAT0.......22000
C           ARRAY AND ITS LINKED LISTS.                                  INDAT0.......22100
         NSCH = 5                                                        INDAT0.......22200
         ALLOCATE(SCHDLS(NSCH))                                          INDAT0.......22300
         DO 185 NS=1,NSCH                                                INDAT0.......22400
            ALLOCATE(SCHDLS(NS)%SLIST, SCHDLS(NS)%SLAST)                 INDAT0.......22500
            SCHDLS(NS)%LLEN = 0                                          INDAT0.......22600
  185    CONTINUE                                                        INDAT0.......22700
C........DEFINE THE DEFAULT "TIME_STEPS" SCHEDULE BASED ON THE           INDAT0.......22800
C           TEMPORAL CONTROLS.  NOTE THAT, FOR BACKWARD COMPATIBILITY    INDAT0.......22900
C           WITH OLD DATASETS, THE ORIGINAL METHOD OF HANDLING CHANGES   INDAT0.......23000
C           IN TIME STEP SIZE [BASED ON MOD(JT,ITCYC).EQ.0, NOT          INDAT0.......23100
C           MOD(JT-1,ITCYC).EQ.0] HAS BEEN RETAINED.                     INDAT0.......23200
C           AT THE SAME TIME, DEFINE SCHEDULE "STEPS_1&UP".              INDAT0.......23300
         SCHDLS(1)%NAME = "TIME_STEPS"                                   INDAT0.......23400
         SCHDLS(3)%NAME = "STEPS_1&UP"                                   INDAT0.......23500
         TIME = TSTART                                                   INDAT0.......23600
         STEP = 0D0                                                      INDAT0.......23700
         CALL LLDINS(SCHDLS(1)%LLEN, SCHDLS(1)%SLIST, TIME, STEP,        INDAT0.......23800
     1      SCHDLS(1)%SLAST)                                             INDAT0.......23900
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         DTIME = DELT                                                    INDAT0.......24000
         DO 580 JT=1,ITMAX                                               INDAT0.......24100
            IF (MOD(JT,ITCYC).EQ.0 .AND. JT.GT.1) DTIME=DTIME*DTMULT     INDAT0.......24200
            IF (DTIME.GT.DTMAX) DTIME = DTMAX                            INDAT0.......24300
            TIME = TIME + DTIME                                          INDAT0.......24400
            STEP = DBLE(JT)                                              INDAT0.......24500
            CALL LLDINS(SCHDLS(1)%LLEN, SCHDLS(1)%SLIST, TIME, STEP,     INDAT0.......24600
     1         SCHDLS(1)%SLAST)                                          INDAT0.......24700
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            CALL LLDINS(SCHDLS(3)%LLEN, SCHDLS(3)%SLIST, TIME, STEP,     INDAT0.......24800
     1         SCHDLS(3)%SLAST)                                          INDAT0.......24900
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            IF (TIME.GE.TMAX) EXIT                                       INDAT0.......25000
  580    CONTINUE                                                        INDAT0.......25100
         ITMAX = SCHDLS(1)%LLEN - 1                                      INDAT0.......25200
         ISCHTS = 1                                                      INDAT0.......25300
C........SKIP OVER THE CODE THAT READS SCHEDULE SPECIFICATIONS.          INDAT0.......25400
         GOTO 850                                                        INDAT0.......25500
      END IF                                                             INDAT0.......25600
C.....INCREMENT NSCH TO ACCOUNT FOR THREE AUTOMATICALLY DEFINED          INDAT0.......25700
C        SCHEDULES: "STEPS_1&UP", WHICH IS IDENTICAL TO "TIME_STEPS"     INDAT0.......25800
C        EXCEPT THAT IT OMITS TIME STEP 0; "STEP_0", WHICH CONSISTS      INDAT0.......25900
C        ONLY OF TIME STEP 0; AND "STEP_1", WHICH CONSISTS ONLY OF       INDAT0.......26000
C        TIME STEP 1.                                                    INDAT0.......26100
      NSCH = NSCH + NSCHAU                                               INDAT0.......26200
C.....WRITE SCHEDULE PARAMETERS.                                         INDAT0.......26300
c rbw begin change
!      WRITE(K3,700) NSCH                                                 INDAT0.......26400
c rbw end change
  700 FORMAT(/13X,'THE ',I5,' SCHEDULES ARE LISTED BELOW.'               INDAT0.......26500
     1   '  SCHEDULE "TIME_STEPS" CONTROLS TIME STEPPING.')              INDAT0.......26600
C.....ALLOCATE SCHEDULE-RELATED ARRAYS AND INITIALIZE SCHEDULE NUMBER    INDAT0.......26700
C        FOR "TIME_STEPS".                                               INDAT0.......26800
      ALLOCATE(SCHDLS(NSCH), SBASED(NSCH), ELAPSD(NSCH))                 INDAT0.......26900
      ISCHTS = 0                                                         INDAT0.......27000
C.....LOOP THROUGH THE LIST OF SCHEDULE SPECIFICATIONS, CONSTRUCTING     INDAT0.......27100
C        SCHEDULES.                                                      INDAT0.......27200
      DO 800 I=1,NSCH-NSCHAU                                             INDAT0.......27300
C........ALLOCATE HEAD OF LINKED LIST FOR THE CURRENT SCHEDULE AND SET   INDAT0.......27400
C           LIST LENGTH TO ZERO.                                         INDAT0.......27500
         ALLOCATE(SCHDLS(I)%SLIST, SCHDLS(I)%SLAST)                      INDAT0.......27600
         SCHDLS(I)%LLEN = 0                                              INDAT0.......27700
C........READ SCHEDULE NAME AND DO SOME ERROR CHECKING.                  INDAT0.......27800
         ERRCOD = 'REA-INP-6'                                            INDAT0.......27900
         CALL READIF(K1, 0, INTFIL, ERRCOD)                              INDAT0.......28000
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 162
        return
      endif
c rbw end change
         READ(INTFIL,*,IOSTAT=INERR(1)) CDUM80                           INDAT0.......28100
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......28200
         IF (INERR(1).NE.0) then
                 IErrorFlag = 50
                 return
               endif
c rbw end change
         IF (LEN_TRIM(CDUM80).GT.10) THEN                                INDAT0.......28300
c rbw begin change
           IErrorFlag = 162
        return
!            ERRCOD = 'INP-6-15'                                          INDAT0.......28400
!            CHERR(1) = CDUM80                                            INDAT0.......28500
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......28600
c rbw end change
         ELSE IF (CDUM80.EQ."-") THEN                                    INDAT0.......28700
           IErrorFlag = 153
           return
!            ERRCOD = 'INP-6-4'                                           INDAT0.......28800
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......28900
         ELSE IF ((CDUM80.EQ."STEPS_1&UP").OR.                           INDAT0.......29000
     1            (CDUM80.EQ."STEP_0").OR.(CDUM80.EQ."STEP_1")) THEN     INDAT0.......29100
c rbw begin change
                 IErrorFlag = 51
                 return
!            ERRCOD = 'INP-6-11'                                          INDAT0.......29200
!            CHERR(1) = CDUM80                                            INDAT0.......29300
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......29400
c rbw end change
         ELSE                                                            INDAT0.......29500
            DO 710 II=1,I-1                                              INDAT0.......29600
               IF (CDUM80.EQ.SCHDLS(II)%NAME) THEN                       INDAT0.......29700
c rbw begin change
                 IErrorFlag = 51
                 return
!                  ERRCOD = 'INP-6-5'                                     INDAT0.......29800
!                  CHERR(1) = CDUM80                                      INDAT0.......29900
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......30000
c rbw end change
               END IF                                                    INDAT0.......30100
  710       CONTINUE                                                     INDAT0.......30200
         END IF                                                          INDAT0.......30300
C........(RE)READ SCHEDULE NAME AND TYPE.                                INDAT0.......30400
         READ(INTFIL,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP                   INDAT0.......30500
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......30600
         IF (INERR(1).NE.0) then
                 IErrorFlag = 53
                 return
         endif
c rbw end change
C........BASED ON THE SCHEDULE TYPE, READ IN THE SPECIFICATIONS AND      INDAT0.......30700
C           CONSTRUCT THE SCHEDULE.                                      INDAT0.......30800
         IF (SCHTYP.EQ."STEP CYCLE") THEN                                INDAT0.......30900
            SBASED(I) = .TRUE.                                           INDAT0.......31000
C...........READ ALL THE SPECIFICATIONS.                                 INDAT0.......31100
            READ(INTFIL,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP,               INDAT0.......31200
     1         NSMAX, ISTEPI, ISTEPL, ISTEPC                             INDAT0.......31300
c rbw begin change
!            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......31400
            IF (INERR(1).NE.0) then
                 IErrorFlag = 54
                 return
            endif
c rbw end change
            SCHDLS(I)%NAME = SCHNAM                                      INDAT0.......31500
            ELAPSD(I) = .FALSE.                                          INDAT0.......31600
C...........CONSTRUCT THE SCHEDULE BY STEPPING THROUGH THE STEP CYCLE    INDAT0.......31700
C              AND STORING THE RESULTS IN THE LINKED LIST.  SET TIME     INDAT0.......31800
C              EQUAL TO STEP FOR NOW SO THAT THE LIST IS CONSTRUCTED     INDAT0.......31900
C              IN THE PROPER ORDER.                                      INDAT0.......32000
            NSTEP = ISTEPI                                               INDAT0.......32100
            NDSTEP = ISTEPC                                              INDAT0.......32200
            STEP = DNINT(DBLE(NSTEP))                                    INDAT0.......32300
            TIME = STEP                                                  INDAT0.......32400
            CALL LLDINS(SCHDLS(I)%LLEN, SCHDLS(I)%SLIST, TIME, STEP,     INDAT0.......32500
     1         SCHDLS(I)%SLAST)                                          INDAT0.......32600
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            DO 720 NS=1,NSMAX                                            INDAT0.......32700
               NSTEP = NSTEP + NDSTEP                                    INDAT0.......32800
               STEP = DNINT(DBLE(NSTEP))                                 INDAT0.......32900
               TIME = STEP                                               INDAT0.......33000
               CALL LLDINS(SCHDLS(I)%LLEN, SCHDLS(I)%SLIST, TIME, STEP,  INDAT0.......33100
     1            SCHDLS(I)%SLAST)                                       INDAT0.......33200
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
  720       CONTINUE                                                     INDAT0.......33300
C...........WRITE OUT THE SPECIFICATIONS.                                INDAT0.......33400
c rbw begin change
!            WRITE(K3,722) SCHDLS(I)%NAME, NSMAX, ISTEPI, ISTEPL, ISTEPC  INDAT0.......33500
c rbw end change
  722       FORMAT(/16X,'SCHEDULE ',A, 3X,'STEP CYCLE WITH THE ',        INDAT0.......33600
     1         'FOLLOWING SPECIFICATIONS:'                               INDAT0.......33700
     2         /40X, I8, 5X, 'MAXIMUM NUMBER OF TIME STEPS AFTER ',      INDAT0.......33800
     3            'INITIAL TIME STEP NUMBER'                             INDAT0.......33900
     4         /40X, I8, 5X, 'INITIAL TIME STEP NUMBER'                  INDAT0.......34000
     5         /40X, I8, 5X, 'LIMITING TIME STEP NUMBER'                 INDAT0.......34100
     6         /40X, I8, 5X, 'TIME STEP INCREMENT')                      INDAT0.......34200
         ELSE IF (SCHTYP.EQ."TIME CYCLE") THEN                           INDAT0.......34300
            SBASED(I) = .FALSE.                                          INDAT0.......34400
C...........READ ALL THE SPECIFICATIONS.                                 INDAT0.......34500
            READ(INTFIL,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP, CREFT,        INDAT0.......34600
     1         SCALT, NTMAX, TIMEI, TIMEL, TIMEC, NTCYC,                 INDAT0.......34700
     2         TCMULT, TCMIN, TCMAX                                      INDAT0.......34800
c rbw begin change
!            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......34900
            IF (INERR(1).NE.0) then
                 IErrorFlag = 55
                 return
            endif
c rbw end change
            SCHDLS(I)%NAME = SCHNAM                                      INDAT0.......35000
            IF (CREFT.EQ.'ELAPSED ') THEN                                INDAT0.......35100
               IF ((SCHNAM.EQ.'TIME_STEPS').AND.(TIMEI.NE.0D0)) THEN     INDAT0.......35200
c rbw begin change
                 IErrorFlag = 56
                 return
!                  ERRCOD = 'INP-6-7'                                     INDAT0.......35300
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......35400
c rbw end change
               END IF                                                    INDAT0.......35500
               ELAPSD(I) = .TRUE.                                        INDAT0.......35600
            ELSE IF (CREFT.EQ.'ABSOLUTE') THEN                           INDAT0.......35700
               ELAPSD(I) = .FALSE.                                       INDAT0.......35800
            ELSE                                                         INDAT0.......35900
c rbw begin change
                 IErrorFlag = 57
                 return
!               ERRCOD = 'INP-6-6'                                        INDAT0.......36000
!               CHERR(1) = CREFT                                          INDAT0.......36100
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  INDAT0.......36200
c rbw end change
            END IF                                                       INDAT0.......36300
C...........SCALE ALL TIME SPECIFICATIONS                                INDAT0.......36400
            TIMEI = TIMEI*SCALT                                          INDAT0.......36500
            TIMEL = TIMEL*SCALT                                          INDAT0.......36600
            TIMEC = TIMEC*SCALT                                          INDAT0.......36700
            TCMIN = TCMIN*SCALT                                          INDAT0.......36800
            TCMAX = TCMAX*SCALT                                          INDAT0.......36900
C...........CONSTRUCT THE SCHEDULE BY STEPPING THROUGH THE TIME CYCLE    INDAT0.......37000
C              AND STORING THE RESULTS IN THE LINKED LIST.               INDAT0.......37100
            TIME = TIMEI                                                 INDAT0.......37200
            STEP = FRCSTP(TIME)                                          INDAT0.......37300
            DTIME = TIMEC                                                INDAT0.......37400
            CALL LLDINS(SCHDLS(I)%LLEN, SCHDLS(I)%SLIST, TIME, STEP,     INDAT0.......37500
     1         SCHDLS(I)%SLAST)                                          INDAT0.......37600
            DO 730 NT=1,NTMAX                                            INDAT0.......37700
               IF (MOD(NT-1,NTCYC).EQ.0 .AND. NT.GT.1)                   INDAT0.......37800
     1            DTIME=DTIME*TCMULT                                     INDAT0.......37900
               IF (DTIME.GT.TCMAX) DTIME = TCMAX                         INDAT0.......38000
               IF (DTIME.LT.TCMIN) DTIME = TCMIN                         INDAT0.......38100
               TIME = TIME + DTIME                                       INDAT0.......38200
               STEP = FRCSTP(TIME)                                       INDAT0.......38300
               CALL LLDINS(SCHDLS(I)%LLEN, SCHDLS(I)%SLIST, TIME, STEP,  INDAT0.......38400
     1            SCHDLS(I)%SLAST)                                       INDAT0.......38500
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
               IF (TIME.GE.TIMEL) EXIT                                   INDAT0.......38600
  730       CONTINUE                                                     INDAT0.......38700
C...........WRITE OUT THE SPECIFICATIONS.                                INDAT0.......38800
c rbw begin change
!            WRITE(K3,732) SCHDLS(I)%NAME, TRIM(CREFT), NTMAX, TIMEI,     INDAT0.......38900
!     1          TIMEL, TIMEC, NTCYC, TCMULT, TCMIN, TCMAX                INDAT0.......39000
c rbw end change
  732       FORMAT(/16X,'SCHEDULE ',A, 3X,'TIME CYCLE WITH THE ',        INDAT0.......39100
     1         'FOLLOWING SPECIFICATIONS IN TERMS OF ', A, ' TIMES:'     INDAT0.......39200
     2         /46X, I8, 5X, 'MAXIMUM NUMBER OF TIMES AFTER ',           INDAT0.......39300
     3            'INITIAL TIME'                                         INDAT0.......39400
     4         /39X, 1PE15.7, 5X, 'INITIAL TIME'                         INDAT0.......39500
     5         /39X, 1PE15.7, 5X, 'LIMITING TIME'                        INDAT0.......39600
     6         /39X, 1PE15.7, 5X, 'INITIAL TIME INCREMENT'               INDAT0.......39700
     7         /46X, I8, 5X, 'TIME INCREMENT CHANGE CYCLE '              INDAT0.......39800
     8         /39X, 1PE15.7, 5X, 'TIME INCREMENT MULTIPLIER'            INDAT0.......39900
     9         /39X, 1PE15.7, 5X, 'MINIMUM TIME INCREMENT'               INDAT0.......40000
     1         /39X, 1PE15.7, 5X, 'MAXIMUM TIME INCREMENT')              INDAT0.......40100
         ELSE IF (SCHTYP.EQ."STEP LIST") THEN                            INDAT0.......40200
            SBASED(I) = .TRUE.                                           INDAT0.......40300
C...........READ THE SCHEDULE NAME, TYPE, AND LENGTH.                    INDAT0.......40400
            BACKSPACE(K1)                                                INDAT0.......40500
            READ(K1,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP, NSLIST            INDAT0.......40600
c rbw begin change
!            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......40700
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
C...........ALLOCATE A TEMPORARY ARRAY TO HOLD THE STEP LIST.            INDAT0.......40800
            ALLOCATE (ISLIST(NSLIST))                                    INDAT0.......40900
C...........READ ALL THE SPECIFICATIONS.                                 INDAT0.......41000
            BACKSPACE(K1)                                                INDAT0.......41100
            READ(K1,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP,                   INDAT0.......41200
     1         NSLIST, (ISLIST(NS),NS=1,NSLIST)                          INDAT0.......41300
c rbw end change
!            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......41400
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
            SCHDLS(I)%NAME = SCHNAM                                      INDAT0.......41500
            ELAPSD(I) = .FALSE.                                          INDAT0.......41600
C...........CONSTRUCT THE SCHEDULE BY TRANSFERRING THE LIST FROM ARRAY   INDAT0.......41700
C              ISLIST TO THE LINKED LIST.  SET TIME EQUAL TO STEP FOR    INDAT0.......41800
C              NOW SO THAT THE LIST IS CONSTRUCTED IN THE PROPER ORDER.  INDAT0.......41900
            DO 740 NS=1,NSLIST                                           INDAT0.......42000
               NSTEP = ISLIST(NS)                                        INDAT0.......42100
               STEP = DNINT(DBLE(NSTEP))                                 INDAT0.......42200
               TIME = STEP                                               INDAT0.......42300
               CALL LLDINS(SCHDLS(I)%LLEN, SCHDLS(I)%SLIST, TIME, STEP,  INDAT0.......42400
     1            SCHDLS(I)%SLAST)                                       INDAT0.......42500
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
  740       CONTINUE                                                     INDAT0.......42600
C...........WRITE OUT THE SPECIFICATIONS.                                INDAT0.......42700
c rbw begin change
!            WRITE(K3,742) SCHDLS(I)%NAME, (ISLIST(NS),NS=1,NSLIST)       INDAT0.......42800
c rbw end change
  742       FORMAT(/16X,'SCHEDULE ',A, 3X,'STEP LIST THAT INCLUDES ',    INDAT0.......42900
     1         'THE FOLLOWING TIME STEPS:'/:(38X,8(2X,I8)))              INDAT0.......43000
C...........DEALLOCATE THE TEMPORARY ARRAY.                              INDAT0.......43100
            DEALLOCATE (ISLIST)                                          INDAT0.......43200
         ELSE IF (SCHTYP.EQ."TIME LIST") THEN                            INDAT0.......43300
            SBASED(I) = .FALSE.                                          INDAT0.......43400
C...........READ THE SCHEDULE NAME, TYPE, SCALE FACTOR, AND LENGTH.      INDAT0.......43500
            BACKSPACE(K1)                                                INDAT0.......43600
            READ(K1,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP, CREFT,            INDAT0.......43700
     1         SCALT, NTLIST                                             INDAT0.......43800
c rbw begin change
!            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......43900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
C...........ALLOCATE A TEMPORARY ARRAY TO HOLD THE TIME LIST.            INDAT0.......44000
            ALLOCATE (TLIST(NTLIST))                                     INDAT0.......44100
C...........READ ALL THE SPECIFICATIONS.                                 INDAT0.......44200
            BACKSPACE(K1)                                                INDAT0.......44300
            READ(K1,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP, CREFT,            INDAT0.......44400
     1         SCALT, NTLIST, (TLIST(NT),NT=1,NTLIST)                    INDAT0.......44500
c rbw begin change
!            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......44600
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
            SCHDLS(I)%NAME = SCHNAM                                      INDAT0.......44700
            IF (CREFT.EQ.'ELAPSED ') THEN                                INDAT0.......44800
               IF ((SCHNAM.EQ.'TIME_STEPS').AND.(TLIST(1).NE.0D0)) THEN  INDAT0.......44900
           IErrorFlag = 153
           return
!                  ERRCOD = 'INP-6-7'                                     INDAT0.......45000
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......45100
               END IF                                                    INDAT0.......45200
               ELAPSD(I) = .TRUE.                                        INDAT0.......45300
            ELSE IF (CREFT.EQ.'ABSOLUTE') THEN                           INDAT0.......45400
               ELAPSD(I) = .FALSE.                                       INDAT0.......45500
            ELSE                                                         INDAT0.......45600
c rbw begin change
           IErrorFlag = 153
           return
!               ERRCOD = 'INP-6-6'                                        INDAT0.......45700
!               CHERR(1) = CREFT                                          INDAT0.......45800
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  INDAT0.......45900
c rbw end change
            END IF                                                       INDAT0.......46000
C...........SCALE ALL TIME SPECIFICATIONS                                INDAT0.......46100
            DO 745 NT=1,NTLIST                                           INDAT0.......46200
               TLIST(NT) = TLIST(NT)*SCALT                               INDAT0.......46300
  745       CONTINUE                                                     INDAT0.......46400
C...........CONSTRUCT THE SCHEDULE BY TRANSFERRING THE LIST FROM ARRAY   INDAT0.......46500
C              TLIST TO THE LINKED LIST.                                 INDAT0.......46600
            DO 750 NT=1,NTLIST                                           INDAT0.......46700
               TIME = TLIST(NT)                                          INDAT0.......46800
               STEP = FRCSTP(TIME)                                       INDAT0.......46900
               CALL LLDINS(SCHDLS(I)%LLEN, SCHDLS(I)%SLIST, TIME, STEP,  INDAT0.......47000
     1            SCHDLS(I)%SLAST)                                       INDAT0.......47100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
  750       CONTINUE                                                     INDAT0.......47200
C...........WRITE OUT THE SPECIFICATIONS.                                INDAT0.......47300
c rbw begin change
!            WRITE(K3,752) SCHDLS(I)%NAME, TRIM(CREFT),                   INDAT0.......47400
!     1         (TLIST(NT),NT=1,NTLIST)                                   INDAT0.......47500
c rbw end change
  752       FORMAT(/16X,'SCHEDULE ',A, 3X,'TIME LIST THAT INCLUDES ',    INDAT0.......47600
     1         'THE FOLLOWING ', A, ' TIMES (SEC):'                      INDAT0.......47700
     2         /:(38X,4(1X,1PE15.7)))                                    INDAT0.......47800
            DEALLOCATE (TLIST)                                           INDAT0.......47900
         ELSE                                                            INDAT0.......48000
C...........THE SPECIFIED SCHEDULE TYPE IS INVALID, SO GENERATE AN       INDAT0.......48100
C              ERROR.                                                    INDAT0.......48200
c rbw begin change
           IErrorFlag = 153
           return
!             ERRCOD = 'INP-6-9'                                           INDAT0.......48300
!            CHERR(1) = SCHTYP                                            INDAT0.......48400
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......48500
c rbw end change
         END IF                                                          INDAT0.......48600
  800 CONTINUE                                                           INDAT0.......48700
C.....READ ONE MORE LINE TO CHECK FOR THE END-OF-LIST MARKER ('-').      INDAT0.......48800
C        IF NOT FOUND, GENERATE AN ERROR.                                INDAT0.......48900
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT0.......49000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10                              INDAT0.......49100
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......49200
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      IF (CDUM10.NE.'-') THEN                                            INDAT0.......49300
c rbw begin change
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-6-4'                                              INDAT0.......49400
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......49500
c rbw end change
      END IF                                                             INDAT0.......49600
C.....FIND SCHEDULE "TIME_STEPS".                                        INDAT0.......49700
      DO 810 I=1,NSCH-NSCHAU                                             INDAT0.......49800
         IF (SCHDLS(I)%NAME.EQ."TIME_STEPS") THEN                        INDAT0.......49900
            ISCHTS=I                                                     INDAT0.......50000
            TSYES = .TRUE.                                               INDAT0.......50100
            EXIT                                                         INDAT0.......50200
         END IF                                                          INDAT0.......50300
  810 CONTINUE                                                           INDAT0.......50400
C.....IF TRANSPORT IS TRANSIENT AND SCHEDULE "TIME_STEPS" HAS NOT        INDAT0.......50500
C        BEEN DEFINED, GENERATE ERROR                                    INDAT0.......50600
      IF ((ISSTRA.EQ.0).AND.(.NOT.TSYES)) THEN                           INDAT0.......50700
c rbw begin change
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-6-14'                                             INDAT0.......50800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......50900
c rbw end change
      END IF                                                             INDAT0.......51000
C.....IF "TIME_STEPS" LENGTH IS <=1 (SCHEDULE CONTAINS, AT MOST,         INDAT0.......51100
C        ONLY THE INITIAL TIME, AND NO SUBSEQUENT TIME STEPS),           INDAT0.......51200
C        GENERATE AN ERROR.                                              INDAT0.......51300
      IF (SCHDLS(ISCHTS)%LLEN.LE.1) THEN                                 INDAT0.......51400
c rbw begin change
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-6-10'                                             INDAT0.......51500
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......51600
c rbw end change
      END IF                                                             INDAT0.......51700
C.....IN SCHEDULE TIME_STEPS, FILL IN TIME STEP NUMBERS, ADDING          INDAT0.......51800
C        TICS TO ELAPSED TIMES IF NECESSARY.  GENERATE ERROR IF          INDAT0.......51900
C        ANY TIMES ARE REPEATED.                                         INDAT0.......52000
C        AT THE SAME TIME, DEFINE SCHEDULE "STEPS_1&UP".                 INDAT0.......52100
      NSMAX = SCHDLS(ISCHTS)%LLEN                                        INDAT0.......52200
      ALLOCATE(DTMP1(NSMAX),DTMP2(NSMAX))                                INDAT0.......52300
      CALL LLD2AR(NSMAX, SCHDLS(ISCHTS)%SLIST, DTMP1, DTMP2)             INDAT0.......52400
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      NS1UP = NSCH - NSCHAU + 1                                          INDAT0.......52500
      ALLOCATE (SCHDLS(NS1UP)%SLIST, SCHDLS(NS1UP)%SLAST)                INDAT0.......52600
      SCHDLS(ISCHTS)%LLEN = 0                                            INDAT0.......52700
      SCHDLS(NS1UP)%NAME = "STEPS_1&UP"                                  INDAT0.......52800
      SCHDLS(NS1UP)%LLEN = 0                                             INDAT0.......52900
      IF (ELAPSD(ISCHTS)) THEN                                           INDAT0.......53000
         IF (IREAD.EQ.+1) THEN                                           INDAT0.......53100
            TREF = TICS                                                  INDAT0.......53200
         ELSE                                                            INDAT0.......53300
            TREF = TICS0                                                 INDAT0.......53400
         END IF                                                          INDAT0.......53500
      ELSE                                                               INDAT0.......53600
         TREF = 0D0                                                      INDAT0.......53700
      END IF                                                             INDAT0.......53800
      ITMAX = NSMAX - 1                                                  INDAT0.......53900
      TSTART = TREF + DTMP1(1)                                           INDAT0.......54000
      TFINSH = TREF + DTMP1(NSMAX)                                       INDAT0.......54100
      DELT = DTMP1(2) - DTMP1(1)                                         INDAT0.......54200
      DO 820 NS=1,NSMAX                                                  INDAT0.......54300
         IF (NS.GT.1) THEN                                               INDAT0.......54400
         IF (DTMP1(NS).EQ.DTMP1(NS-1)) THEN                              INDAT0.......54500
c rbw begin change
           IErrorFlag = 153
           return
!            ERRCOD = 'INP-6-12'                                          INDAT0.......54600
!            IF (ELAPSD(ISCHTS)) THEN                                     INDAT0.......54700
!               CHERR(1) = "elapsed time"                                 INDAT0.......54800
!            ELSE                                                         INDAT0.......54900
!               CHERR(1) = "absolute time"                                INDAT0.......55000
!            END IF                                                       INDAT0.......55100
!            CHERR(2) = "TIME_STEPS"                                      INDAT0.......55200
!            RLERR(1) = DTMP1(NS)                                         INDAT0.......55300
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......55400
c rbw end change
         END IF                                                          INDAT0.......55500
         END IF                                                          INDAT0.......55600
         NSTEP = NS - 1                                                  INDAT0.......55700
         TIME = TREF + DTMP1(NS)                                         INDAT0.......55800
         STEP = DNINT(DBLE(NSTEP))                                       INDAT0.......55900
         CALL LLDINS(SCHDLS(ISCHTS)%LLEN, SCHDLS(ISCHTS)%SLIST, TIME,    INDAT0.......56000
     1      STEP, SCHDLS(ISCHTS)%SLAST)                                  INDAT0.......56100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
         IF (NS.GT.1) CALL LLDINS(SCHDLS(NS1UP)%LLEN,                    INDAT0.......56200
     1       SCHDLS(NS1UP)%SLIST, TIME, STEP, SCHDLS(NS1UP)%SLAST)       INDAT0.......56300
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
  820 CONTINUE                                                           INDAT0.......56400
      DEALLOCATE(DTMP1,DTMP2)                                            INDAT0.......56500
C.....DEFINE SCHEDULES STEP_0 AND STEP_1.                                INDAT0.......56600
      NS0 = NSCH - NSCHAU + 2                                            INDAT0.......56700
      ALLOCATE (SCHDLS(NS0)%SLIST, SCHDLS(NS0)%SLAST)                    INDAT0.......56800
      SCHDLS(NS0)%NAME = "STEP_0"                                        INDAT0.......56900
      SCHDLS(NS0)%LLEN = 0                                               INDAT0.......57000
      STEP = 0                                                           INDAT0.......57100
      TIME = TIMETS(INT(STEP))                                           INDAT0.......57200
      CALL LLDINS(SCHDLS(NS0)%LLEN, SCHDLS(NS0)%SLIST, TIME,             INDAT0.......57300
     1      STEP, SCHDLS(NS0)%SLAST)                                     INDAT0.......57400
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      NS1 = NS0 + 1                                                      INDAT0.......57500
      ALLOCATE (SCHDLS(NS1)%SLIST, SCHDLS(NS1)%SLAST)                    INDAT0.......57600
      SCHDLS(NS1)%NAME = "STEP_1"                                        INDAT0.......57700
      SCHDLS(NS1)%LLEN = 0                                               INDAT0.......57800
      STEP = 1                                                           INDAT0.......57900
      TIME = TIMETS(INT(STEP))                                           INDAT0.......58000
      CALL LLDINS(SCHDLS(NS1)%LLEN, SCHDLS(NS1)%SLIST, TIME,             INDAT0.......58100
     1      STEP, SCHDLS(NS1)%SLAST)                                     INDAT0.......58200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
C.....FILL IN TIMES OR STEPS FOR REMAINING SCHEDULES, SHIFTING           INDAT0.......58300
C        ELAPSED TIMES TO ABSOLUTE TIMES IF NECESSARY.  PRUNE ENTRIES    INDAT0.......58400
C        THAT ARE OUTSIDE THE RANGE OF SCHEDULE "TIME_STEPS".            INDAT0.......58500
C        GENERATE ERROR IF ANY TIME STEPS OR TIMES ARE REPEATED.         INDAT0.......58600
      DO 845 I=1,NSCH-NSCHAU                                             INDAT0.......58700
         IF (I.EQ.ISCHTS) CYCLE                                          INDAT0.......58800
         NSMAX = SCHDLS(I)%LLEN                                          INDAT0.......58900
         ALLOCATE(DTMP1(NSMAX),DTMP2(NSMAX))                             INDAT0.......59000
         CALL LLD2AR(NSMAX, SCHDLS(I)%SLIST, DTMP1, DTMP2)               INDAT0.......59100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
         SCHDLS(I)%LLEN = 0                                              INDAT0.......59200
         IF (ELAPSD(I)) THEN                                             INDAT0.......59300
            TREF = TSTART                                                INDAT0.......59400
         ELSE                                                            INDAT0.......59500
            TREF = 0D0                                                   INDAT0.......59600
         END IF                                                          INDAT0.......59700
         IF (SBASED(I)) THEN                                             INDAT0.......59800
            DO 840 NS=1,NSMAX                                            INDAT0.......59900
               IF (NS.GT.1) THEN                                         INDAT0.......60000
               IF (DTMP2(NS).EQ.DTMP2(NS-1)) THEN                        INDAT0.......60100
c rbw begin change
           IErrorFlag = 153
           return
c rbw end change
!                  ERRCOD = 'INP-6-12'                                    INDAT0.......60200
!                  CHERR(1) = "time step"                                 INDAT0.......60300
!                  CHERR(2) = SCHDLS(I)%NAME                              INDAT0.......60400
!                  RLERR(1) = DTMP2(NS)                                   INDAT0.......60500
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......60600
               END IF                                                    INDAT0.......60700
               END IF                                                    INDAT0.......60800
               STEP = DTMP2(NS)                                          INDAT0.......60900
               NSTEP = NINT(STEP)                                        INDAT0.......61000
               IF ((NSTEP.LT.0).OR.(NSTEP.GT.ITMAX)) CYCLE               INDAT0.......61100
               TIME = TIMETS(NSTEP)                                      INDAT0.......61200
               CALL LLDINS(SCHDLS(I)%LLEN, SCHDLS(I)%SLIST, TIME,        INDAT0.......61300
     1            STEP, SCHDLS(I)%SLAST)                                 INDAT0.......61400
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
  840       CONTINUE                                                     INDAT0.......61500
         ELSE                                                            INDAT0.......61600
            DO 842 NS=1,NSMAX                                            INDAT0.......61700
               IF (NS.GT.1) THEN                                         INDAT0.......61800
               IF (DTMP1(NS).EQ.DTMP1(NS-1)) THEN                        INDAT0.......61900
c rbw begin change
           IErrorFlag = 153
           return
!                  ERRCOD = 'INP-6-12'                                    INDAT0.......62000
!                  IF (ELAPSD(I)) THEN                                    INDAT0.......62100
!                     CHERR(1) = "elapsed time"                           INDAT0.......62200
!                  ELSE                                                   INDAT0.......62300
!                     CHERR(1) = "absolute time"                          INDAT0.......62400
!                  END IF                                                 INDAT0.......62500
!                  CHERR(2) = SCHDLS(I)%NAME                              INDAT0.......62600
!                  RLERR(1) = DTMP1(NS)                                   INDAT0.......62700
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......62800
c rbw end change
               END IF                                                    INDAT0.......62900
               END IF                                                    INDAT0.......63000
               TIME = TREF + DTMP1(NS)                                   INDAT0.......63100
               IF ((TIME.LT.TSTART).OR.(TIME.GT.TFINSH)) CYCLE           INDAT0.......63200
               STEP = FRCSTP(TIME)                                       INDAT0.......63300
               CALL LLDINS(SCHDLS(I)%LLEN, SCHDLS(I)%SLIST, TIME,        INDAT0.......63400
     1            STEP, SCHDLS(I)%SLAST)                                 INDAT0.......63500
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
  842       CONTINUE                                                     INDAT0.......63600
         END IF                                                          INDAT0.......63700
         DEALLOCATE(DTMP1,DTMP2)                                         INDAT0.......63800
  845 CONTINUE                                                           INDAT0.......63900
C.....DEALLOCATE ARRAY THAT INDICATES METHODS OF SCHEDULE SPECIFICATION  INDAT0.......64000
      DEALLOCATE(SBASED)                                                 INDAT0.......64100
C.....WRITE SPECIFICATIONS OF SCHEDULES "STEPS_1&UP", "STEP_0", AND      INDAT0.......64200
C        "STEP_1".                                                       INDAT0.......64300
c rbw begin change
  846  CONTINUE
!  846 WRITE(K3,847) "STEPS_1&UP"                                         INDAT0.......64400
c rbw end change
  847 FORMAT(/16X,'SCHEDULE ',A10, 3X,'IDENTICAL TO SCHEDULE ',          INDAT0.......64500
     1   '"TIME_STEPS", EXCEPT THAT IT OMITS TIME STEP 0;',              INDAT0.......64600
     2   /41X,'THIS SCHEDULE IS DEFINED AUTOMATICALLY BY SUTRA')         INDAT0.......64700
c rbw begin change
!      WRITE(K3,848) "STEP_0", 0                                          INDAT0.......64800
!      WRITE(K3,848) "STEP_1", 1                                          INDAT0.......64900
c rbw end change
  848 FORMAT(/16X,'SCHEDULE ',A6, 4X,                                    INDAT0.......65000
     1   3X,'CONSISTS ONLY OF TIME STEP ', I1, ';',                      INDAT0.......65100
     2   /41X,'THIS SCHEDULE IS DEFINED AUTOMATICALLY BY SUTRA')         INDAT0.......65200
C.....WRITE THE SOLUTION CYCLING CONTROLS.                               INDAT0.......65300
c rbw begin change
  850 CONTINUE
!  850 WRITE(K3,874) NPCYC,NUCYC                                          INDAT0.......65400
c rbw end change
  874 FORMAT (/13X,'SOLUTION CYCLING DATA:'                              INDAT0.......65500
     1      //11X,I15,5X,'FLOW SOLUTION CYCLE (IN TIME STEPS)'           INDAT0.......65600
     2      /11X,I15,5X,'TRANSPORT SOLUTION CYCLE (IN TIME STEPS)'       INDAT0.......65700
     3      //16X,'FLOW AND TRANSPORT SOLUTIONS ARE ALSO COMPUTED '      INDAT0.......65800
     4      'AUTOMATICALLY ON TIME STEPS ON WHICH FLOW-RELATED '         INDAT0.......65900
     5      /16X,'AND TRANSPORT-RELATED BOUNDARY CONDITIONS, '           INDAT0.......66000
     5      'RESPECTIVELY, ARE SET IN (OPTIONAL) BCS FILES.')            INDAT0.......66100
C.....SET SOLUTION CYCLING FOR STEADY-STATE FLOW                         INDAT0.......66200
      IF(ISSFLO.EQ.1) THEN                                               INDAT0.......66300
         NPCYC=ITMAX+1                                                   INDAT0.......66400
         NUCYC=1                                                         INDAT0.......66500
      END IF                                                             INDAT0.......66600
C                                                                        INDAT0.......66700
C.....INPUT DATASET 7A:  ITERATION CONTROLS FOR RESOLVING NONLINEARITIES INDAT0.......66800
      ERRCOD = 'REA-INP-7A'                                              INDAT0.......66900
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT0.......67000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) ITRMAX                              INDAT0.......67100
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......67200
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      IF (ITRMAX.GT.1) THEN                                              INDAT0.......67300
         ERRCOD = 'REA-INP-7A'                                           INDAT0.......67400
         READ(INTFIL,*,IOSTAT=INERR(1)) ITRMAX,RPMAX,RUMAX               INDAT0.......67500
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......67600
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      END IF                                                             INDAT0.......67700
c rbw begin change
!      IF(ITRMAX-1) 1192,1192,1194                                        INDAT0.......67800
! 1192 WRITE(K3,1193)                                                     INDAT0.......67900
 1193 FORMAT(////11X,'I T E R A T I O N   C O N T R O L   D A T A',      INDAT0.......68000
     1   //11X,'  NON-ITERATIVE SOLUTION')                               INDAT0.......68100
!      GOTO 1196                                                          INDAT0.......68200
! 1194 WRITE(K3,1195) ITRMAX,RPMAX,RUMAX                                  INDAT0.......68300
 1195 FORMAT(////11X,'I T E R A T I O N   C O N T R O L   D A T A',      INDAT0.......68400
     1   //11X,I15,5X,'MAXIMUM NUMBER OF ITERATIONS PER TIME STEP',      INDAT0.......68500
     2   /11X,1PE15.4,5X,'ABSOLUTE CONVERGENCE CRITERION FOR FLOW',      INDAT0.......68600
     3   ' SOLUTION'/11X,1PE15.4,5X,'ABSOLUTE CONVERGENCE CRITERION',    INDAT0.......68700
     4   ' FOR TRANSPORT SOLUTION')                                      INDAT0.......68800
! 1196 CONTINUE                                                           INDAT0.......68900
c rbw end change
C                                                                        INDAT0.......69000
C.....INPUT DATASETS 7B & 7C:  MATRIX EQUATION SOLVER CONTROLS FOR       INDAT0.......69100
C        PRESSURE AND TRANSPORT SOLUTIONS                                INDAT0.......69200
      ERRCOD = 'REA-INP-7B'                                              INDAT0.......69300
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT0.......69400
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVP                              INDAT0.......69500
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......69600
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      IF ((CSOLVP.NE.SOLWRD(0))) THEN                                    INDAT0.......69700
         ERRCOD = 'REA-INP-7B'                                           INDAT0.......69800
         READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVP,ITRMXP,TOLP               INDAT0.......69900
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......70000
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      END IF                                                             INDAT0.......70100
      ERRCOD = 'REA-INP-7C'                                              INDAT0.......70200
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT0.......70300
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVU                              INDAT0.......70400
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......70500
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      IF ((CSOLVU.NE.SOLWRD(0))) THEN                                    INDAT0.......70600
         ERRCOD = 'REA-INP-7C'                                           INDAT0.......70700
         READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVU,ITRMXU,TOLU               INDAT0.......70800
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......70900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      END IF                                                             INDAT0.......71000
      KSOLVP = -1                                                        INDAT0.......71100
      KSOLVU = -1                                                        INDAT0.......71200
      DO 1250 M=0,NSLVRS-1                                               INDAT0.......71300
         IF (CSOLVP.EQ.SOLWRD(M)) KSOLVP = M                             INDAT0.......71400
         IF (CSOLVU.EQ.SOLWRD(M)) KSOLVU = M                             INDAT0.......71500
 1250 CONTINUE                                                           INDAT0.......71600
      IF ((KSOLVP.LT.0).OR.(KSOLVU.LT.0)) THEN                           INDAT0.......71700
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-7B&C-1'                                           INDAT0.......71800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......71900
      ELSE IF ((KSOLVP*KSOLVU.EQ.0).AND.(KSOLVP+KSOLVU.NE.0)) THEN       INDAT0.......72000
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-7B&C-2'                                           INDAT0.......72100
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......72200
      ELSE IF ((KSOLVU.EQ.1).OR.((KSOLVP.EQ.1).AND.(UP.NE.0D0))) THEN    INDAT0.......72300
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-7B&C-3'                                           INDAT0.......72400
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......72500
      END IF                                                             INDAT0.......72600
      IF (KSOLVP.EQ.2) THEN                                              INDAT0.......72700
         ITOLP = 0                                                       INDAT0.......72800
      ELSE                                                               INDAT0.......72900
         ITOLP = 1                                                       INDAT0.......73000
      END IF                                                             INDAT0.......73100
      IF (KSOLVU.EQ.2) THEN                                              INDAT0.......73200
         ITOLU = 0                                                       INDAT0.......73300
      ELSE                                                               INDAT0.......73400
         ITOLU = 1                                                       INDAT0.......73500
      END IF                                                             INDAT0.......73600
      NSAVEP = 10                                                        INDAT0.......73700
      NSAVEU = 10                                                        INDAT0.......73800
C                                                                        INDAT0.......73900
C                                                                        INDAT0.......74000
      RETURN                                                             INDAT0.......74100
      END                                                                INDAT0.......74200
C                                                                        INDAT0.......74300
C     SUBROUTINE        I  N  D  A  T  1           SUTRA VERSION 2.2     INDAT1.........100
C                                                                        INDAT1.........200
C *** PURPOSE :                                                          INDAT1.........300
C ***  TO INPUT, OUTPUT, AND ORGANIZE A MAJOR PORTION OF INP FILE        INDAT1.........400
C ***  INPUT DATA (DATASETS 8 THROUGH 15)                                INDAT1.........500
C                                                                        INDAT1.........600
c rbw begin change
!      SUBROUTINE INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,         INDAT1.........700
!     1   ATMIN,PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,                       INDAT1.........800
!     2   PERMYZ,PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG, INDAT1.........900
!     3   OBSPTS)                                                         INDAT1........1000
      SUBROUTINE INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,         INDAT1.........700
     1   ATMIN,PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,                       INDAT1.........800
     2   PERMYZ,PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG, INDAT1.........900
     3   OBSPTS, InputFile)                                                         INDAT1........1000
      USE ErrorFlag
c rbw end change
      USE ALLARR, ONLY : OBSDAT                                          INDAT1........1100
      USE LLDEF                                                          INDAT1........1200
      USE EXPINT                                                         INDAT1........1300
      USE SCHDEF                                                         INDAT1........1400
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                INDAT1........1500
      PARAMETER (NCOLMX=9)                                               INDAT1........1600
c rbw begin
      character (len=*) InputFile
      intent (in) InputFile
c rbw end
      CHARACTER*10 ADSMOD,CDUM10                                         INDAT1........1700
      CHARACTER*6 STYPE(2)                                               INDAT1........1800
      CHARACTER K5SYM(7)*1, NCOL(NCOLMX)*1, VARNK5(7)*25                 INDAT1........1900
      CHARACTER K6SYM(7)*2, LCOL(NCOLMX)*2, VARNK6(7)*25                 INDAT1........2000
      CHARACTER*1 CNODAL,CELMNT,CINCID,CPANDS,CVEL,CCORT,CBUDG,          INDAT1........2100
     1   CSCRN,CPAUSE,CINACT                                             INDAT1........2200
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:13)                    INDAT1........2300
      CHARACTER INTFIL*1000,DOTS45*45                                    INDAT1........2400
      CHARACTER OBSNAM*40, OBSSCH*10, OBSFMT*3, CDUM80*80                INDAT1........2500
      CHARACTER*8 VERNUM, VERNIN                                         INDAT1........2600
      TYPE (OBSDAT), DIMENSION (NOBSN) :: OBSPTS                         INDAT1........2700
      DIMENSION J5COL(NCOLMX), J6COL(NCOLMX)                             INDAT1........2800
      DIMENSION X(NN),Y(NN),Z(NN),POR(NN),SOP(NN),NREG(NN)               INDAT1........2900
      DIMENSION PERMXX(NE),PERMXY(NE),PERMXZ(NEX),PERMYX(NE),PERMYY(NE), INDAT1........3000
     1   PERMYZ(NEX),PERMZX(NEX),PERMZY(NEX),PERMZZ(NEX),PANGL1(NE),     INDAT1........3100
     2   PANGL2(NEX),PANGL3(NEX),ALMAX(NE),ALMID(NEX),ALMIN(NE),         INDAT1........3200
     3   ATMAX(NE),ATMID(NEX),ATMIN(NE),LREG(NE)                         INDAT1........3300
      DIMENSION INERR(10),RLERR(10)                                      INDAT1........3400
      DIMENSION KTYPE(2)                                                 INDAT1........3500
      DIMENSION IUNIT(0:13)                                              INDAT1........3600
      ALLOCATABLE :: INOB(:)                                             INDAT1........3700
      TYPE (LLD), POINTER :: DENTS                                       INDAT1........3800
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  INDAT1........3900
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           INDAT1........4000
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      INDAT1........4100
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              INDAT1........4200
     1   NSOP,NSOU,NBCN,NCIDB                                            INDAT1........4300
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        INDAT1........4400
      COMMON /FNAMES/ UNAME,FNAME                                        INDAT1........4500
      COMMON /FUNITA/ IUNIT                                              INDAT1........4600
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 INDAT1........4700
     1   K10,K11,K12,K13                                                 INDAT1........4800
      COMMON /GRAVEC/ GRAVX,GRAVY,GRAVZ                                  INDAT1........4900
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      INDAT1........5000
      COMMON /JCOLS/ NCOLPR, LCOLPR, NCOLS5, NCOLS6, J5COL, J6COL        INDAT1........5100
      COMMON /KPRBCS/ KINACT                                             INDAT1........5200
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,                INDAT1........5300
     1   KPANDS,KVEL,KCORT,KBUDG,KSCRN,KPAUSE                            INDAT1........5400
      COMMON /MODSOR/ ADSMOD                                             INDAT1........5500
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      INDAT1........5600
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      INDAT1........5700
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        INDAT1........5800
      COMMON /SCH/ NSCH,ISCHTS,NSCHAU                                    INDAT1........5900
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       INDAT1........6000
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART      INDAT1........6100
      COMMON /VER/ VERNUM, VERNIN                                        INDAT1........6200
      DATA STYPE(1)/'ENERGY'/,STYPE(2)/'SOLUTE'/                         INDAT1........6300
      DATA (K5SYM(MM), MM=1,7) /'N', 'X', 'Y', 'Z', 'P', 'U', 'S'/       INDAT1........6400
      DATA (VARNK5(MM), MM=1,7) /'NODE NUMBER',                          INDAT1........6500
     1   'X-COORDINATE', 'Y-COORDINATE', 'Z-COORDINATE',                 INDAT1........6600
     2   'PRESSURE', 'CONCENTRATION/TEMPERATURE', 'SATURATION'/          INDAT1........6700
      DATA (K6SYM(MM), MM=1,7) /'E', 'X', 'Y', 'Z', 'VX', 'VY', 'VZ'/    INDAT1........6800
      DATA (VARNK6(MM), MM=1,7) /'ELEMENT NUMBER',                       INDAT1........6900
     1   'X-COORDINATE OF CENTROID', 'Y-COORDINATE OF CENTROID',         INDAT1........7000
     2   'Z-COORDINATE OF CENTROID', 'X-VELOCITY', 'Y-VELOCITY',         INDAT1........7100
     3   'Z-VELOCITY'/                                                   INDAT1........7200
      DATA DOTS45 /'.............................................'/      INDAT1........7300
      SAVE STYPE,K5SYM,VARNK5,K6SYM,VARNK6                               INDAT1........7400
C                                                                        INDAT1........7500
      INSTOP=0                                                           INDAT1........7600
C                                                                        INDAT1........7700
C.....INPUT DATASET 8A:  OUTPUT CONTROLS AND OPTIONS FOR LST FILE        INDAT1........7800
C        AND SCREEN                                                      INDAT1........7900
      ERRCOD = 'REA-INP-8A'                                              INDAT1........8000
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1........8100
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 167
        return
      endif
c rbw end change
      IF ((VERNIN.EQ.'2.0').OR.(VERNIN.EQ.'2.1')) THEN                   INDAT1........8200
         READ(INTFIL,*,IOSTAT=INERR(1)) NPRINT,CNODAL,CELMNT,CINCID,     INDAT1........8300
     1      CVEL,CBUDG,CSCRN,CPAUSE                                      INDAT1........8400
         CPANDS = 'Y'                                                    INDAT1........8500
         CCORT = 'Y'                                                     INDAT1........8600
      ELSE                                                               INDAT1........8700
         READ(INTFIL,*,IOSTAT=INERR(1)) NPRINT,CNODAL,CELMNT,CINCID,     INDAT1........8800
     1      CPANDS,CVEL,CCORT,CBUDG,CSCRN,CPAUSE                         INDAT1........8900
      END IF                                                             INDAT1........9000
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1........9100
      IF (INERR(1).NE.0) then
                 IErrorFlag = 80
                 return
      endif
c rbw end change
       IF (CNODAL.EQ.'Y') THEN                                            INDAT1........9200
         KNODAL = +1                                                     INDAT1........9300
      ELSE IF (CNODAL.EQ.'N') THEN                                       INDAT1........9400
         KNODAL = 0                                                      INDAT1........9500
      ELSE                                                               INDAT1........9600
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-1'                                             INDAT1........9700
!         CHERR(1) = 'CNODAL '                                            INDAT1........9800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1........9900
      END IF                                                             INDAT1.......10000
      IF (CELMNT.EQ.'Y') THEN                                            INDAT1.......10100
         KELMNT = +1                                                     INDAT1.......10200
      ELSE IF (CELMNT.EQ.'N') THEN                                       INDAT1.......10300
         KELMNT = 0                                                      INDAT1.......10400
      ELSE                                                               INDAT1.......10500
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-2'                                             INDAT1.......10600
!         CHERR(1) = 'CELMNT'                                             INDAT1.......10700
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......10800
      END IF                                                             INDAT1.......10900
      IF (CINCID.EQ.'Y') THEN                                            INDAT1.......11000
         KINCID = +1                                                     INDAT1.......11100
      ELSE IF (CINCID.EQ.'N') THEN                                       INDAT1.......11200
         KINCID = 0                                                      INDAT1.......11300
      ELSE                                                               INDAT1.......11400
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-3'                                             INDAT1.......11500
!         CHERR(1) = 'CINCID'                                             INDAT1.......11600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......11700
      END IF                                                             INDAT1.......11800
      IF (CPANDS.EQ.'Y') THEN                                            INDAT1.......11900
         KPANDS = +1                                                     INDAT1.......12000
      ELSE IF (CPANDS.EQ.'N') THEN                                       INDAT1.......12100
         KPANDS = 0                                                      INDAT1.......12200
      ELSE                                                               INDAT1.......12300
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-8'                                             INDAT1.......12400
!         CHERR(1) = 'CPANDS'                                             INDAT1.......12500
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......12600
      END IF                                                             INDAT1.......12700
      IF (CVEL.EQ.'Y') THEN                                              INDAT1.......12800
         KVEL = +1                                                       INDAT1.......12900
      ELSE IF (CVEL.EQ.'N') THEN                                         INDAT1.......13000
         KVEL = 0                                                        INDAT1.......13100
      ELSE                                                               INDAT1.......13200
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-4'                                             INDAT1.......13300
!         CHERR(1) = 'CVEL  '                                             INDAT1.......13400
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......13500
      END IF                                                             INDAT1.......13600
      IF (CCORT.EQ.'Y') THEN                                             INDAT1.......13700
         KCORT = +1                                                      INDAT1.......13800
      ELSE IF (CCORT.EQ.'N') THEN                                        INDAT1.......13900
         KCORT = 0                                                       INDAT1.......14000
      ELSE                                                               INDAT1.......14100
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-9'                                             INDAT1.......14200
!         CHERR(1) = 'CCORT '                                             INDAT1.......14300
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......14400
      END IF                                                             INDAT1.......14500
      IF (CBUDG.EQ.'Y') THEN                                             INDAT1.......14600
         KBUDG = +1                                                      INDAT1.......14700
      ELSE IF (CBUDG.EQ.'N') THEN                                        INDAT1.......14800
         KBUDG = 0                                                       INDAT1.......14900
      ELSE                                                               INDAT1.......15000
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-5'                                             INDAT1.......15100
!         CHERR(1) = 'CBUDG '                                             INDAT1.......15200
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......15300
      END IF                                                             INDAT1.......15400
      IF (CSCRN.EQ.'Y') THEN                                             INDAT1.......15500
         KSCRN = +1                                                      INDAT1.......15600
      ELSE IF (CSCRN.EQ.'N') THEN                                        INDAT1.......15700
         KSCRN = 0                                                       INDAT1.......15800
      ELSE                                                               INDAT1.......15900
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-6'                                             INDAT1.......16000
!         CHERR(1) = 'CSCRN '                                             INDAT1.......16100
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......16200
      END IF                                                             INDAT1.......16300
      IF (CPAUSE.EQ.'Y') THEN                                            INDAT1.......16400
         KPAUSE = +1                                                     INDAT1.......16500
      ELSE IF (CPAUSE.EQ.'N') THEN                                       INDAT1.......16600
         KPAUSE = 0                                                      INDAT1.......16700
      ELSE                                                               INDAT1.......16800
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8A-7'                                             INDAT1.......16900
!         CHERR(1) = 'CPAUSE'                                             INDAT1.......17000
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......17100
      END IF                                                             INDAT1.......17200
C                                                                        INDAT1.......17300
!      WRITE(K3,72) NPRINT                                                INDAT1.......17400
   72 FORMAT(////11X,'O U T P U T   C O N T R O L S   A N D   ',         INDAT1.......17500
     1   'O P T I O N S'//13X,'.LST FILE'/13X,'---------'                INDAT1.......17600
     2   //13X,I8,3X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)')             INDAT1.......17700
!      IF(KNODAL.EQ.+1) WRITE(K3,74)                                      INDAT1.......17800
!      IF(KNODAL.EQ.0) WRITE(K3,75)                                       INDAT1.......17900
   74 FORMAT(/13X,'- PRINT NODE COORDINATES, THICKNESSES AND',           INDAT1.......18000
     1   ' POROSITIES')                                                  INDAT1.......18100
   75 FORMAT(/13X,'- CANCEL PRINT OF NODE COORDINATES, THICKNESSES AND', INDAT1.......18200
     1   ' POROSITIES')                                                  INDAT1.......18300
!      IF(KELMNT.EQ.+1) WRITE(K3,76)                                      INDAT1.......18400
!      IF(KELMNT.EQ.0) WRITE(K3,77)                                       INDAT1.......18500
   76 FORMAT(13X,'- PRINT ELEMENT PERMEABILITIES AND DISPERSIVITIES')    INDAT1.......18600
   77 FORMAT(13X,'- CANCEL PRINT OF ELEMENT PERMEABILITIES AND ',        INDAT1.......18700
     1   'DISPERSIVITIES')                                               INDAT1.......18800
!      IF(KINCID.EQ.+1) WRITE(K3,78)                                      INDAT1.......18900
!      IF(KINCID.EQ.0) WRITE(K3,79)                                       INDAT1.......19000
   78 FORMAT(13X,'- PRINT NODE INCIDENCES IN EACH ELEMENT')              INDAT1.......19100
   79 FORMAT(13X,'- CANCEL PRINT OF NODE INCIDENCES IN EACH ELEMENT')    INDAT1.......19200
      IME=2                                                              INDAT1.......19300
      IF(ME.EQ.+1) IME=1                                                 INDAT1.......19400
!      IF(KPANDS.EQ.+1) WRITE(K3,81)                                      INDAT1.......19500
!      IF(KPANDS.EQ.0) WRITE(K3,82)                                       INDAT1.......19600
   81 FORMAT(/13X,'- PRINT PRESSURES AND SATURATIONS AT NODES ',         INDAT1.......19700
     1   'ON EACH TIME STEP WITH OUTPUT')                                INDAT1.......19800
   82 FORMAT(/13X,'- CANCEL PRINT OF PRESSURES AND SATURATIONS')         INDAT1.......19900
!      IF(KVEL.EQ.+1) WRITE(K3,84)                                        INDAT1.......20000
!      IF(KVEL.EQ.0) WRITE(K3,85)                                         INDAT1.......20100
   84 FORMAT(13X,'- CALCULATE AND PRINT VELOCITIES AT ELEMENT ',         INDAT1.......20200
     1   'CENTROIDS ON EACH TIME STEP WITH OUTPUT')                      INDAT1.......20300
   85 FORMAT(13X,'- CANCEL PRINT OF VELOCITIES')                         INDAT1.......20400
!      IF(KCORT.EQ.+1) THEN                                               INDAT1.......20500
!         IF (ME.EQ.-1) THEN                                              INDAT1.......20600
!            WRITE(K3,86)                                                 INDAT1.......20700
!         ELSE                                                            INDAT1.......20800
!            WRITE(K3,87)                                                 INDAT1.......20900
!         END IF                                                          INDAT1.......21000
!      ELSE                                                               INDAT1.......21100
 !        IF (ME.EQ.-1) THEN                                              INDAT1.......21200
 !           WRITE(K3,88)                                                 INDAT1.......21300
 !        ELSE                                                            INDAT1.......21400
 !           WRITE(K3,89)                                                 INDAT1.......21500
 !        END IF                                                          INDAT1.......21600
 !     END IF                                                             INDAT1.......21700
   86 FORMAT(13X,'- PRINT CONCENTRATIONS AT NODES ',                     INDAT1.......21800
     1   'ON EACH TIME STEP WITH OUTPUT')                                INDAT1.......21900
   87 FORMAT(13X,'- PRINT TEMPERATURES AT NODES ',                       INDAT1.......22000
     1   'ON EACH TIME STEP WITH OUTPUT')                                INDAT1.......22100
   88 FORMAT(13X,'- CANCEL PRINT OF CONCENTRATIONS')                     INDAT1.......22200
   89 FORMAT(13X,'- CANCEL PRINT OF TEMPERATURES')                       INDAT1.......22300
!      IF(KBUDG.EQ.+1) WRITE(K3,90) STYPE(IME)                            INDAT1.......22400
!      IF(KBUDG.EQ.0) WRITE(K3,91)                                        INDAT1.......22500
   90 FORMAT(/13X,'- CALCULATE AND PRINT FLUID AND ',A6,' BUDGETS ',     INDAT1.......22600
     1   'ON EACH TIME STEP WITH OUTPUT')                                INDAT1.......22700
   91 FORMAT(/13X,'- CANCEL PRINT OF BUDGETS')                           INDAT1.......22800
C                                                                        INDAT1.......22900
C.....INPUT DATASET 8B:  OUTPUT CONTROLS AND OPTIONS FOR NOD FILE        INDAT1.......23000
      ERRCOD = 'REA-INP-8B'                                              INDAT1.......23100
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......23200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NCOLPR                              INDAT1.......23300
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......23400
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      DO 140 M=1,NCOLMX                                                  INDAT1.......23500
         READ(INTFIL,*,IOSTAT=INERR(1)) NCOLPR, (NCOL(MM), MM=1,M)       INDAT1.......23600
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......23700
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
         IF (NCOL(M).EQ.'-') THEN                                        INDAT1.......23800
            NCOLS5 = M - 1                                               INDAT1.......23900
            GOTO 142                                                     INDAT1.......24000
         END IF                                                          INDAT1.......24100
  140 CONTINUE                                                           INDAT1.......24200
      NCOLS5 = NCOLMX                                                    INDAT1.......24300
  142 CONTINUE                                                           INDAT1.......24400
!      WRITE(K3,144) NCOLPR                                               INDAT1.......24500
  144 FORMAT (//13X,'.NOD FILE'/13X,'---------'                          INDAT1.......24600
     1   //13X,I8,3X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)'/)            INDAT1.......24700
      DO 148 M=1,NCOLS5                                                  INDAT1.......24800
         DO 146 MM=1,7                                                   INDAT1.......24900
            IF (NCOL(M).EQ.K5SYM(MM)) THEN                               INDAT1.......25000
               IF ((MM.EQ.1).AND.(M.NE.1)) THEN                          INDAT1.......25100
           IErrorFlag = 153
           return
!                  ERRCOD = 'INP-8B-1'                                    INDAT1.......25200
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......25300
               END IF                                                    INDAT1.......25400
               IF ((MM.EQ.4).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......25500
            IErrorFlag = 153
           return
!                 ERRCOD = 'INP-8B-2'                                    INDAT1.......25600
!                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......25700
               END IF                                                    INDAT1.......25800
               J5COL(M) = MM                                             INDAT1.......25900
               GOTO 148                                                  INDAT1.......26000
            END IF                                                       INDAT1.......26100
  146    CONTINUE                                                        INDAT1.......26200
            IErrorFlag = 153
           return
!        ERRCOD = 'INP-8B-3'                                             INDAT1.......26300
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......26400
  148 CONTINUE                                                           INDAT1.......26500
!      WRITE(K3,150) (M,VARNK5(J5COL(M)),M=1,NCOLS5)                      INDAT1.......26600
  150 FORMAT (13X,'COLUMN ',I1,':',2X,A)                                 INDAT1.......26700
C                                                                        INDAT1.......26800
C.....INPUT DATASET 8C:  OUTPUT CONTROLS AND OPTIONS FOR ELE FILE        INDAT1.......26900
      ERRCOD = 'REA-INP-8C'                                              INDAT1.......27000
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......27100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) LCOLPR                              INDAT1.......27200
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......27300
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      DO 160 M=1,NCOLMX                                                  INDAT1.......27400
         READ(INTFIL,*,IOSTAT=INERR(1)) LCOLPR, (LCOL(MM), MM=1,M)       INDAT1.......27500
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......27600
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
         IF (LCOL(M).EQ.'-') THEN                                        INDAT1.......27700
            NCOLS6 = M - 1                                               INDAT1.......27800
            GOTO 162                                                     INDAT1.......27900
         END IF                                                          INDAT1.......28000
  160 CONTINUE                                                           INDAT1.......28100
      NCOLS6 = NCOLMX                                                    INDAT1.......28200
  162 CONTINUE                                                           INDAT1.......28300
!      WRITE(K3,164) LCOLPR                                               INDAT1.......28400
  164 FORMAT (//13X,'.ELE FILE'/13X,'---------'                          INDAT1.......28500
     1   //13X,I8,3X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)'/)            INDAT1.......28600
      DO 168 M=1,NCOLS6                                                  INDAT1.......28700
         DO 166 MM=1,7                                                   INDAT1.......28800
            IF (LCOL(M).EQ.K6SYM(MM)) THEN                               INDAT1.......28900
               IF ((MM.EQ.1).AND.(M.NE.1)) THEN                          INDAT1.......29000
           IErrorFlag = 153
           return
!                  ERRCOD = 'INP-8C-1'                                    INDAT1.......29100
 !                 CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......29200
               END IF                                                    INDAT1.......29300
               IF ((MM.EQ.4).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......29400
           IErrorFlag = 153
           return
!                  ERRCOD = 'INP-8C-2'                                    INDAT1.......29500
 !                 CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......29600
               END IF                                                    INDAT1.......29700
               IF ((MM.EQ.7).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......29800
           IErrorFlag = 153
           return
!                  ERRCOD = 'INP-8C-4'                                    INDAT1.......29900
 !                 CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......30000
               END IF                                                    INDAT1.......30100
               J6COL(M) = MM                                             INDAT1.......30200
               GOTO 168                                                  INDAT1.......30300
            END IF                                                       INDAT1.......30400
  166    CONTINUE                                                        INDAT1.......30500
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8C-3'                                             INDAT1.......30600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......30700
  168 CONTINUE                                                           INDAT1.......30800
!      WRITE(K3,170) (M,VARNK6(J6COL(M)),M=1,NCOLS6)                      INDAT1.......30900
  170 FORMAT (13X,'COLUMN ',I1,':',2X,A)                                 INDAT1.......31000
C                                                                        INDAT1.......31100
C.....INPUT DATASET 8D:  OUTPUT CONTROLS AND OPTIONS FOR OBSERVATIONS    INDAT1.......31200
      NOBCYC = ITMAX + 1                                                 INDAT1.......31300
      IF (NOBSN-1.EQ.0) GOTO 999                                         INDAT1.......31400
C.....NOBS IS ACTUAL NUMBER OF OBSERVATION POINTS                        INDAT1.......31500
C.....NTOBS IS MAXIMUM NUMBER OF TIME STEPS WITH OBSERVATIONS            INDAT1.......31600
      NOBS=NOBSN-1                                                       INDAT1.......31700
C.....READ IN OBSERVATION POINTS                                         INDAT1.......31800
      ERRCOD = 'REA-INP-8D'                                              INDAT1.......31900
C.....DO THIS READ NOW TO SKIP ANY COMMENTS AND BLANK LINES.             INDAT1.......32000
C        (BACKSPACE LATER IF IT MUST BE REREAD IN OLD FORMAT.)           INDAT1.......32100
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......32200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
c rbw begin change
      READ(INTFIL,*,IOSTAT=INERR(1)) NOBLIN                              INDAT1.......32300
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......32400
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
C.....IF OLD (VERSION 2.0) INPUT FORMAT IS BEING USED, CONSTRUCT A       INDAT1.......32500
C        CORRESPONDING OBSERVATION OUTPUT SCHEDULE IF TRANSPORT IS       INDAT1.......32600
C        TRANSIENT.                                                      INDAT1.......32700
      IF (VERNIN.EQ."2.0") THEN                                          INDAT1.......32800
C........SET THE MAX NUMBER OF OBSERVATIONS PER LINE TO THE TOTAL        INDAT1.......32900
C           NUMBER OF OBSERVATIONS.                                      INDAT1.......33000
         NOBLIN = NOBS                                                   INDAT1.......33100
C........SET UP A TEMPORARY ARRAY TO HOLD OBSERVATION NODES.             INDAT1.......33200
         ALLOCATE(INOB(NOBSN))                                           INDAT1.......33300
C........BACKSPACE AND REREAD DATASET IN OLD FORMAT                      INDAT1.......33400
         BACKSPACE(K1)                                                   INDAT1.......33500
         READ(K1,*,IOSTAT=INERR(1)) NOBCYC, (INOB(JJ), JJ=1,NOBSN)       INDAT1.......33600
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......33700
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
C........IF THE LAST NODE NUMBER IS NOT ZERO, GENERATE AN ERROR.         INDAT1.......33800
         IF (INOB(NOBSN).NE.0) THEN                                      INDAT1.......33900
           IErrorFlag = 153
           return
!            ERRCOD = 'INP-8D-1'                                          INDAT1.......34000
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT1.......34100
         END IF                                                          INDAT1.......34200
C........IF A NODE NUMBER IS INVALID, GENERATE AN ERROR.                 INDAT1.......34300
         DO 510 JJ=1,NOBS                                                INDAT1.......34400
            IF ((INOB(JJ).LT.1).OR.(INOB(JJ).GT.NN)) THEN                INDAT1.......34500
           IErrorFlag = 153
           return
!               ERRCOD = 'INP-8D-2'                                       INDAT1.......34600
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  INDAT1.......34700
            END IF                                                       INDAT1.......34800
  510    CONTINUE                                                        INDAT1.......34900
C........IF TRANSPORT IS TRANSIENT, CONSTRUCT A SCHEDULE THAT            INDAT1.......35000
C           CORRESPONDS TO THE CYCLE SPECIFIED BY NOBCYC.                INDAT1.......35100
         IF (ISSTRA.EQ.0) THEN                                           INDAT1.......35200
            SCHDLS(2)%NAME = "-"                                         INDAT1.......35300
            ISTEPI = 0                                                   INDAT1.......35400
            ISTEPL = ITMAX                                               INDAT1.......35500
            ITERM = ISTEPL - ISTEPI                                      INDAT1.......35600
C...........IF NOBCYC=0, SET THE CYCLE TO THE TOTAL NUMBER OF TIME       INDAT1.......35700
C              STEPS, SO THAT THE SCHEDULE CONSISTS OF TIME STEPS        INDAT1.......35800
C              0, 1, AND ITMAX.  (VERSION 2.0 SIMPLY BOMBS IF            INDAT1.......35900
C              NOBCYC=0.)                                                INDAT1.......36000
            IF (NOBCYC.EQ.0) THEN                                        INDAT1.......36100
               ISTEPC = ITERM                                            INDAT1.......36200
            ELSE                                                         INDAT1.......36300
               ISTEPC = IABS(NOBCYC)                                     INDAT1.......36400
            END IF                                                       INDAT1.......36500
            NTORS = INT(ITERM/ISTEPC) + 1                                INDAT1.......36600
            IF (MOD(ITERM,ISTEPC).NE.0) NTORS = NTORS + 1                INDAT1.......36700
            NSTEP = ISTEPI                                               INDAT1.......36800
            DENTS => SCHDLS(ISCHTS)%SLIST                                INDAT1.......36900
            JT = 0                                                       INDAT1.......37000
            DO 580 NT=1,NTORS                                            INDAT1.......37100
               NSTEP = MIN(ISTEPL, ISTEPI + (NT - 1)*ISTEPC)             INDAT1.......37200
               DO WHILE (NSTEP.GT.JT)                                    INDAT1.......37300
                  DENTS => DENTS%NENT                                    INDAT1.......37400
                  JT = JT + 1                                            INDAT1.......37500
               END DO                                                    INDAT1.......37600
               STEP = DENTS%DVALU2                                       INDAT1.......37700
               TIME = DENTS%DVALU1                                       INDAT1.......37800
               CALL LLDINS(SCHDLS(2)%LLEN, SCHDLS(2)%SLIST, TIME, STEP,  INDAT1.......37900
     1            SCHDLS(2)%SLAST)                                       INDAT1.......38000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
  580       CONTINUE                                                     INDAT1.......38100
C...........IF NOBCYC>=0, INCLUDE TIME STEP 1 IF NOT ALREADY INCLUDED.   INDAT1.......38200
            IF ((NOBCYC.GE.0).AND.(NOBCYC.NE.1)) THEN                    INDAT1.......38300
               DENTS => SCHDLS(ISCHTS)%SLIST                             INDAT1.......38400
               STEP = DNINT(DBLE(1))                                     INDAT1.......38500
               TIME = DENTS%NENT%DVALU1                                  INDAT1.......38600
               CALL LLDINS(SCHDLS(2)%LLEN, SCHDLS(2)%SLIST, TIME, STEP,  INDAT1.......38700
     1            SCHDLS(2)%SLAST)                                       INDAT1.......38800
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
            END IF                                                       INDAT1.......38900
         END IF                                                          INDAT1.......39000
C........CONVERT NODES TO GENERALIZED OBSERVATION POINTS.  THE POINTS    INDAT1.......39100
C           ARE NAMED "NODE_#", WHERE # IS THE NODE NUMBER.              INDAT1.......39200
         DO 540 I=1,NOBS                                                 INDAT1.......39300
            WRITE(OBSPTS(I)%NAME,*) INOB(I)                              INDAT1.......39400
            OBSPTS(I)%NAME = "NODE_" // ADJUSTL(OBSPTS(I)%NAME)          INDAT1.......39500
            OBSPTS(I)%SCHED = "-"                                        INDAT1.......39600
            OBSPTS(I)%FRMT = "OBS"                                       INDAT1.......39700
            OBSPTS(I)%L = INOB(I)                                        INDAT1.......39800
  540    CONTINUE                                                        INDAT1.......39900
C........DEALLOCATE TEMPORARY ARRAY.                                     INDAT1.......40000
         DEALLOCATE(INOB)                                                INDAT1.......40100
C........SKIP PAST THE CODE THAT READS A LIST OF GENERALIZED             INDAT1.......40200
C           OBSERVATION POINTS.                                          INDAT1.......40300
         GOTO 820                                                        INDAT1.......40400
      END IF                                                             INDAT1.......40500
C.....READ THE LIST OF GENERALIZED OBSERVATION POINTS.                   INDAT1.......40600
      NOBCYC = -1                                                        INDAT1.......40700
      DO 690 I=1,NOBS                                                    INDAT1.......40800
C........READ THE OBSERVATION NAME.                                      INDAT1.......40900
         CALL READIF(K1, 0, INTFIL, ERRCOD)                              INDAT1.......41000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
         READ(INTFIL,*,IOSTAT=INERR(1)) OBSNAM                           INDAT1.......41100
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......41200
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
C........IF END-OF-LIST MARKER ENCOUNTERED TOO SOON, GENERATE ERROR.     INDAT1.......41300
         IF (OBSNAM.EQ.'-') THEN                                         INDAT1.......41400
           IErrorFlag = 153
           return
!            ERRCOD = 'INP-8D-4'                                          INDAT1.......41500
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT1.......41600
         END IF                                                          INDAT1.......41700
C........READ IN (X,Y,Z) OR (X,Y) COORDINATES, DEPENDING ON PROBLEM      INDAT1.......41800
C           DIMENSIONALITY, AS WELL AS OUTPUT SCHEDULE AND FORMAT.       INDAT1.......41900
         IF (KTYPE(1).EQ.3) THEN                                         INDAT1.......42000
            READ(INTFIL,*,IOSTAT=INERR(1)) OBSNAM, XOBS, YOBS, ZOBS,     INDAT1.......42100
     1         CDUM80, OBSFMT                                            INDAT1.......42200
         ELSE                                                            INDAT1.......42300
            READ(INTFIL,*,IOSTAT=INERR(1)) OBSNAM, XOBS, YOBS,           INDAT1.......42400
     1         CDUM80, OBSFMT                                            INDAT1.......42500
            ZOBS = 0D0                                                   INDAT1.......42600
         END IF                                                          INDAT1.......42700
c rbw begin change
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......42800
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
         IF (LEN_TRIM(CDUM80).GT.10) THEN                                INDAT1.......42900
           IErrorFlag = 153
           return
!            ERRCOD = 'INP-8D-6'                                          INDAT1.......43000
!            CHERR(1) = CDUM80                                            INDAT1.......43100
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT1.......43200
         END IF                                                          INDAT1.......43300
         OBSSCH = CDUM80                                                 INDAT1.......43400
         OBSPTS(I)%NAME = OBSNAM                                         INDAT1.......43500
         OBSPTS(I)%X = XOBS                                              INDAT1.......43600
         OBSPTS(I)%Y = YOBS                                              INDAT1.......43700
         OBSPTS(I)%Z = ZOBS                                              INDAT1.......43800
         IF (ISSTRA.EQ.1) THEN                                           INDAT1.......43900
            OBSPTS(I)%SCHED = "TIME_STEPS"                               INDAT1.......44000
         ELSE                                                            INDAT1.......44100
            OBSPTS(I)%SCHED = OBSSCH                                     INDAT1.......44200
         END IF                                                          INDAT1.......44300
         OBSPTS(I)%FRMT = OBSFMT                                         INDAT1.......44400
  690 CONTINUE                                                           INDAT1.......44500
C.....READ ONE MORE LINE TO CHECK FOR THE END-OF-LIST MARKER ('-').      INDAT1.......44600
C        IF NOT FOUND, GENERATE ERROR.                                   INDAT1.......44700
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......44800
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) OBSNAM                              INDAT1.......44900
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......45000
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      IF (OBSNAM.NE.'-') THEN                                            INDAT1.......45100
           IErrorFlag = 153
           return
         ERRCOD = 'INP-8D-4'                                             INDAT1.......45200
         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......45300
      END IF                                                             INDAT1.......45400
C                                                                        INDAT1.......45500
C.....CONDENSE SCHEDULE AND FILE TYPE INFORMATION FROM OBSDAT INTO       INDAT1.......45600
C        ARRAY OFP, CHECKING FOR UNDEFINED SCHEDULES                     INDAT1.......45700
  820 ALLOCATE (OFP(NSCH*2))                                             INDAT1.......45800
      IF (ISSTRA.EQ.1) THEN                                              INDAT1.......45900
         NFLOMX=0                                                        INDAT1.......46000
         DO 840 I=1,NOBS                                                 INDAT1.......46100
            DO 835 J=1,NFLOMX                                            INDAT1.......46200
               IF (OBSPTS(I)%FRMT.EQ.OFP(J)%FRMT) GOTO 840               INDAT1.......46300
  835       CONTINUE                                                     INDAT1.......46400
            NFLOMX = NFLOMX + 1                                          INDAT1.......46500
            OFP(NFLOMX)%ISCHED = 2                                       INDAT1.......46600
            OFP(NFLOMX)%FRMT = OBSPTS(I)%FRMT                            INDAT1.......46700
  840    CONTINUE                                                        INDAT1.......46800
      ELSE                                                               INDAT1.......46900
         NFLOMX = 0                                                      INDAT1.......47000
         DO 860 I=1,NOBS                                                 INDAT1.......47100
            DO 850 NS=1,NSCH                                             INDAT1.......47200
               IF (OBSPTS(I)%SCHED.EQ.SCHDLS(NS)%NAME) THEN              INDAT1.......47300
                  INS = NS                                               INDAT1.......47400
                  GOTO 852                                               INDAT1.......47500
               END IF                                                    INDAT1.......47600
  850       CONTINUE                                                     INDAT1.......47700
           IErrorFlag = 153
           return
!            ERRCOD = 'INP-8D-5'                                          INDAT1.......47800
!            CHERR(1) = OBSPTS(I)%SCHED                                   INDAT1.......47900
!            CHERR(2) = OBSPTS(I)%NAME                                    INDAT1.......48000
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT1.......48100
  852       DO 855 J=1,NFLOMX                                            INDAT1.......48200
               IF ((OBSPTS(I)%SCHED.EQ.SCHDLS(OFP(J)%ISCHED)%NAME).AND.  INDAT1.......48300
     1             (OBSPTS(I)%FRMT.EQ.OFP(J)%FRMT)) GOTO 860             INDAT1.......48400
  855       CONTINUE                                                     INDAT1.......48500
            NFLOMX = NFLOMX + 1                                          INDAT1.......48600
            OFP(NFLOMX)%ISCHED = INS                                     INDAT1.......48700
            OFP(NFLOMX)%FRMT = OBSPTS(I)%FRMT                            INDAT1.......48800
  860    CONTINUE                                                        INDAT1.......48900
      END IF                                                             INDAT1.......49000
C                                                                        INDAT1.......49100
C.....ASSIGN UNIT NUMBERS AND OPEN FILE UNITS FOR OBSERVATION OUTPUT     INDAT1.......49200
C        FILES.                                                          INDAT1.......49300
c rbw begin change
!      CALL FOPEN()                                                       INDAT1.......49400
      CALL FOPEN(InputFile)
c rbw end change
C                                                                        INDAT1.......49500
C.....OUTPUT OBSERVATION FILE INFORMATION                                INDAT1.......49600
      IF (ISSTRA.EQ.1) THEN                                              INDAT1.......49700
!         WRITE(K3,868) IUNIO(1),FNAMO(1)                                 INDAT1.......49800
  868    FORMAT (//13X,'.OBS AND .OBC FILES'/13X,'-------------------'// INDAT1.......49900
     1      (13X,'UNIT ',I7,4X,'ASSIGNED TO ',A80))                      INDAT1.......50000
!         WRITE(K3,869)                                                   INDAT1.......50100
  869    FORMAT (/13X,'NOTE: BECAUSE FLOW AND TRANSPORT ARE STEADY-',    INDAT1.......50200
     1      'STATE, USER-DEFINED SCHEDULES ARE NOT IN EFFECT.  '         INDAT1.......50300
     2      /13X,'STEADY-STATE OBSERVATIONS WILL BE WRITTEN TO THE ',    INDAT1.......50400
     3      'APPROPRIATE OUTPUT FILES.')                                 INDAT1.......50500
      ELSE IF (VERNIN.NE."2.0") THEN                                     INDAT1.......50600
!         WRITE(K3,870) (SCHDLS(OFP(J)%ISCHED)%NAME,OFP(J)%FRMT,          INDAT1.......50700
!     1      IUNIO(J),FNAMO(J),J=1,NFLOMX)                                INDAT1.......50800
  870    FORMAT (//13X,'.OBS AND .OBC FILES'/13X,'-------------------'// INDAT1.......50900
     1      (13X,'SCHEDULE ',A,', FORMAT ',A,', UNIT ',I7,4X,            INDAT1.......51000
     2      'ASSIGNED TO ',A80))                                         INDAT1.......51100
      ELSE                                                               INDAT1.......51200
!         WRITE(K3,868) IUNIO(1),FNAMO(1)                                 INDAT1.......51300
!         WRITE(K3,872) NOBCYC, SCHDLS(2)%LLEN                            INDAT1.......51400
  872    FORMAT (/13X,'NOTE: OBSERVATION OUTPUT CYCLING ',               INDAT1.......51500
     1      'INFORMATION WAS ENTERED USING THE OLD (VERSION 2D3D.1) '    INDAT1.......51600
     2      'INPUT FORMAT.'/13X,'OBSERVATIONS WILL BE MADE EVERY ',I8,   INDAT1.......51700
     3      ' TIME STEPS, AS WELL AS ON THE FIRST AND LAST TIME STEP,'   INDAT1.......51800
     4      /13X,'FOR A TOTAL OF ',I8,' TIME STEPS.')                    INDAT1.......51900
      END IF                                                             INDAT1.......52000
C                                                                        INDAT1.......52100
C.....OUTPUT GENERALIZED OBSERVATION POINT INFORMATION.                  INDAT1.......52200
!      WRITE(K3,982)                                                      INDAT1.......52300
  982 FORMAT(////11X,'O B S E R V A T I O N   P O I N T S')              INDAT1.......52400
C.....3D PROBLEM.                                                        INDAT1.......52500
      IF (KTYPE(1).EQ.3) THEN                                            INDAT1.......52600
C........WRITE HEADER.                                                   INDAT1.......52700
!         WRITE(K3,987)                                                   INDAT1.......52800
  987    FORMAT(                                                         INDAT1.......52900
     1        //13X,'NAME',42X,'COORDINATES',37X,'SCHEDULE',4X,'FORMAT'  INDAT1.......53000
     2         /13X,'----',42X,'-----------',37X,'--------',4X,'------') INDAT1.......53100
C........PRINT INFORMATION FOR EACH POINT.  IF POINTS WERE CONVERTED     INDAT1.......53200
C           FROM NODES, COORDINATES HAVE YET TO BE READ IN, SO PUT IN    INDAT1.......53300
C           A PLACEHOLDER.                                               INDAT1.......53400
         IF (NOBCYC.NE.-1) THEN                                          INDAT1.......53500
            DO 989 JJ=1,NOBS                                             INDAT1.......53600
               LTOP = LEN_TRIM(OBSPTS(JJ)%NAME)                          INDAT1.......53700
               IF (ISSTRA.EQ.1) THEN                                     INDAT1.......53800
                  OBSSCH = '-'                                           INDAT1.......53900
               ELSE                                                      INDAT1.......54000
                  OBSSCH = OBSPTS(JJ)%SCHED                              INDAT1.......54100
               END IF                                                    INDAT1.......54200
!               WRITE(K3,988) TRIM(OBSPTS(JJ)%NAME),DOTS45(1:43-LTOP),    INDAT1.......54300
!     1            OBSSCH,OBSPTS(JJ)%FRMT                                 INDAT1.......54400
  988          FORMAT(13X,A,1X,A,1X,                                     INDAT1.......54500
     1            '( _______ TO BE READ FROM DATASET 14 _______ )',      INDAT1.......54600
     2            3X,A,2X,A)                                             INDAT1.......54700
  989       CONTINUE                                                     INDAT1.......54800
         ELSE                                                            INDAT1.......54900
            DO 991 JJ=1,NOBS                                             INDAT1.......55000
               LTOP = LEN_TRIM(OBSPTS(JJ)%NAME)                          INDAT1.......55100
               IF (ISSTRA.EQ.1) THEN                                     INDAT1.......55200
                  OBSSCH = '-'                                           INDAT1.......55300
               ELSE                                                      INDAT1.......55400
                  OBSSCH = OBSPTS(JJ)%SCHED                              INDAT1.......55500
               END IF                                                    INDAT1.......55600
!               WRITE(K3,990) TRIM(OBSPTS(JJ)%NAME),DOTS45(1:43-LTOP),    INDAT1.......55700
!     1            OBSPTS(JJ)%X,OBSPTS(JJ)%Y,OBSPTS(JJ)%Z,                INDAT1.......55800
 !    2            OBSSCH,OBSPTS(JJ)%FRMT                                 INDAT1.......55900
  990          FORMAT(13X,A,1X,A,1X,'(',2(1PE14.7,','),1PE14.7,')',      INDAT1.......56000
     1            3X,A,2X,A)                                             INDAT1.......56100
  991       CONTINUE                                                     INDAT1.......56200
         END IF                                                          INDAT1.......56300
C.....2D PROBLEM.                                                        INDAT1.......56400
      ELSE                                                               INDAT1.......56500
C........WRITE HEADER.                                                   INDAT1.......56600
!         WRITE(K3,993)                                                   INDAT1.......56700
  993    FORMAT(                                                         INDAT1.......56800
     1        //13X,'NAME',42X,'COORDINATES',22X,'SCHEDULE',4X,'FORMAT'  INDAT1.......56900
     2         /13X,'----',42X,'-----------',22X,'--------',4X,'------') INDAT1.......57000
C........PRINT INFORMATION FOR EACH POINT.  IF POINTS WERE CONVERTED     INDAT1.......57100
C           FROM NODES, COORDINATES HAVE YET TO BE READ IN, SO PUT IN    INDAT1.......57200
C           A PLACEHOLDER.                                               INDAT1.......57300
         IF (NOBCYC.NE.-1) THEN                                          INDAT1.......57400
            DO 995 JJ=1,NOBS                                             INDAT1.......57500
               LTOP = LEN_TRIM(OBSPTS(JJ)%NAME)                          INDAT1.......57600
               IF (ISSTRA.EQ.1) THEN                                     INDAT1.......57700
                  OBSSCH = '-'                                           INDAT1.......57800
               ELSE                                                      INDAT1.......57900
                  OBSSCH = OBSPTS(JJ)%SCHED                              INDAT1.......58000
               END IF                                                    INDAT1.......58100
!               WRITE(K3,994) TRIM(OBSPTS(JJ)%NAME),DOTS45(1:43-LTOP),    INDAT1.......58200
!     1            OBSSCH,OBSPTS(JJ)%FRMT                                 INDAT1.......58300
  994          FORMAT(13X,A,1X,A,1X,'( TO BE READ FROM DATASET 14  )',   INDAT1.......58400
     1            3X,A,2X,A)                                             INDAT1.......58500
  995       CONTINUE                                                     INDAT1.......58600
         ELSE                                                            INDAT1.......58700
            DO 997 JJ=1,NOBS                                             INDAT1.......58800
               LTOP = LEN_TRIM(OBSPTS(JJ)%NAME)                          INDAT1.......58900
               IF (ISSTRA.EQ.1) THEN                                     INDAT1.......59000
                  OBSSCH = '-'                                           INDAT1.......59100
               ELSE                                                      INDAT1.......59200
                  OBSSCH = OBSPTS(JJ)%SCHED                              INDAT1.......59300
               END IF                                                    INDAT1.......59400
!               WRITE(K3,996) TRIM(OBSPTS(JJ)%NAME),DOTS45(1:43-LTOP),    INDAT1.......59500
!     1            OBSPTS(JJ)%X,OBSPTS(JJ)%Y,                             INDAT1.......59600
!     2            OBSSCH,OBSPTS(JJ)%FRMT                                 INDAT1.......59700
  996          FORMAT(13X,A,1X,A,1X,'(',1PE14.7,',',1PE14.7,')',         INDAT1.......59800
     1            3X,A,2X,A)                                             INDAT1.......59900
  997       CONTINUE                                                     INDAT1.......60000
         END IF                                                          INDAT1.......60100
      END IF                                                             INDAT1.......60200
  999 CONTINUE                                                           INDAT1.......60300
C                                                                        INDAT1.......60400
C.....INPUT DATASET 8E:  OUTPUT CONTROLS AND OPTIONS FOR BCOF, BCOP,     INDAT1.......60500
C        BCOS, AND BCOU FILES                                            INDAT1.......60600
      IF ((VERNIN.EQ.'2.0').OR.(VERNIN.EQ.'2.1')) THEN                   INDAT1.......60700
         NBCFPR = HUGE(1)                                                INDAT1.......60800
         NBCSPR = HUGE(1)                                                INDAT1.......60900
         NBCPPR = HUGE(1)                                                INDAT1.......61000
         NBCUPR = HUGE(1)                                                INDAT1.......61100
C........CINACT IS IRRELEVANT IN THIS CASE                               INDAT1.......61200
         GOTO 1100                                                       INDAT1.......61300
      END IF                                                             INDAT1.......61400
      ERRCOD = 'REA-INP-8E'                                              INDAT1.......61500
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......61600
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NBCFPR, NBCSPR, NBCPPR, NBCUPR,     INDAT1.......61700
     1   CINACT                                                          INDAT1.......61800
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......61900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
      IF (CINACT.EQ.'Y') THEN                                            INDAT1.......62000
         KINACT = +1                                                     INDAT1.......62100
      ELSE IF (CINACT.EQ.'N') THEN                                       INDAT1.......62200
         KINACT = 0                                                      INDAT1.......62300
      ELSE                                                               INDAT1.......62400
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-8E-1'                                             INDAT1.......62500
!         CHERR(1) = 'CINACT'                                             INDAT1.......62600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......62700
      END IF                                                             INDAT1.......62800
      IF (ME.EQ.-1) THEN                                                 INDAT1.......62900
!         WRITE(K3,1050) NBCFPR, NBCSPR, NBCPPR, NBCUPR                   INDAT1.......63000
 1050    FORMAT(//13X,'.BCOF, .BCOS, .BCOP, AND .BCOU FILES'             INDAT1.......63100
     1           /13X,'------------------------------------'             INDAT1.......63200
     2      //13X,I8,3X,'PRINTED OUTPUT CYCLE FOR FLUID SOURCES/SINK ',  INDAT1.......63300
     3        'NODES TO .BCOF FILE (IN TIME STEPS)'                      INDAT1.......63400
     4       /13X,I8,3X,'PRINTED OUTPUT CYCLE FOR SOLUTE ',              INDAT1.......63500
     5        'SOURCES/SINK NODES TO .BCOS FILE (IN TIME STEPS)'         INDAT1.......63600
     6       /13X,I8,3X,'PRINTED OUTPUT CYCLE FOR SPECIFIED PRESSURE ',  INDAT1.......63700
     7        'NODES TO .BCOP FILE (IN TIME STEPS)'                      INDAT1.......63800
     8       /13X,I8,3X,'PRINTED OUTPUT CYCLE FOR SPECIFIED ',           INDAT1.......63900
     9        'CONCENTRATION NODES TO .BCOU FILE (IN TIME STEPS)')       INDAT1.......64000
      ELSE                                                               INDAT1.......64100
!         WRITE(K3,1051) NBCFPR, NBCSPR, NBCPPR, NBCUPR                   INDAT1.......64200
 1051    FORMAT(//13X,'.BCOF, .BCOS, .BCOP, AND .BCOU FILES'             INDAT1.......64300
     1           /13X,'------------------------------------'             INDAT1.......64400
     2      //13X,I8,3X,'PRINTED OUTPUT CYCLE FOR FLUID SOURCES/SINK ',  INDAT1.......64500
     3        'NODES TO .BCOF FILE (IN TIME STEPS)'                      INDAT1.......64600
     4       /13X,I8,3X,'PRINTED OUTPUT CYCLE FOR ENERGY ',              INDAT1.......64700
     5        'SOURCES/SINK NODES TO .BCOS FILE (IN TIME STEPS)'         INDAT1.......64800
     6       /13X,I8,3X,'PRINTED OUTPUT CYCLE FOR SPECIFIED PRESSURE ',  INDAT1.......64900
     7        'NODES TO .BCOP FILE (IN TIME STEPS)'                      INDAT1.......65000
     8       /13X,I8,3X,'PRINTED OUTPUT CYCLE FOR SPECIFIED ',           INDAT1.......65100
     9        'TEMPERATURE NODES TO .BCOU FILE (IN TIME STEPS)')         INDAT1.......65200
      END IF                                                             INDAT1.......65300
!      IF(KINACT.EQ.+1) WRITE(K3,1052)                                    INDAT1.......65400
!      IF(KINACT.EQ.0) WRITE(K3,1053)                                     INDAT1.......65500
 1052 FORMAT(/13X,'- PRINT INACTIVE BOUNDARY CONDITIONS')                INDAT1.......65600
 1053 FORMAT(/13X,'- CANCEL PRINT OF INACTIVE BOUNDARY CONDITIONS')      INDAT1.......65700
C                                                                        INDAT1.......65800
C.....INPUT DATASET 9:  FLUID PROPERTIES                                 INDAT1.......65900
 1100 ERRCOD = 'REA-INP-9'                                               INDAT1.......66000
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......66100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) COMPFL,CW,SIGMAW,RHOW0,URHOW0,      INDAT1.......66200
     1   DRWDU,VISC0                                                     INDAT1.......66300
c rbw end change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......66400
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
C.....INPUT DATASET 10:  SOLID MATRIX PROPERTIES                         INDAT1.......66500
      ERRCOD = 'REA-INP-10'                                              INDAT1.......66600
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......66700
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) COMPMA,CS,SIGMAS,RHOS               INDAT1.......66800
c rbw begin change
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......66900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
c rbw end change
!      IF(ME.EQ.+1)                                                       INDAT1.......67000
!     1  WRITE(K3,1210) COMPFL,COMPMA,CW,CS,VISC0,RHOS,RHOW0,DRWDU,       INDAT1.......67100
!     2     URHOW0,SIGMAW,SIGMAS                                          INDAT1.......67200
 1210 FORMAT('1'////11X,'C O N S T A N T   P R O P E R T I E S   O F',   INDAT1.......67300
     1   '   F L U I D   A N D   S O L I D   M A T R I X'                INDAT1.......67400
     2   //11X,1PE15.4,5X,'COMPRESSIBILITY OF FLUID'/11X,1PE15.4,5X,     INDAT1.......67500
     3   'COMPRESSIBILITY OF POROUS MATRIX'//11X,1PE15.4,5X,             INDAT1.......67600
     4   'SPECIFIC HEAT CAPACITY OF FLUID',/11X,1PE15.4,5X,              INDAT1.......67700
     5   'SPECIFIC HEAT CAPACITY OF SOLID GRAIN'//13X,'FLUID VISCOSITY', INDAT1.......67800
     6   ' IS CALCULATED BY SUTRA AS A FUNCTION OF TEMPERATURE IN ',     INDAT1.......67900
     7   'UNITS OF {kg/(m*s)}'//11X,1PE15.4,5X,'VISC0, CONVERSION ',     INDAT1.......68000
     8   'FACTOR FOR VISCOSITY UNITS,  {desired units} = VISC0*',        INDAT1.......68100
     9   '{kg/(m*s)}'//11X,1PE15.4,5X,'DENSITY OF A SOLID GRAIN'         INDAT1.......68200
     *   //13X,'FLUID DENSITY, RHOW'/13X,'CALCULATED BY ',               INDAT1.......68300
     1   'SUTRA IN TERMS OF TEMPERATURE, U, AS:'/13X,'RHOW = RHOW0 + ',  INDAT1.......68400
     2   'DRWDU*(U-URHOW0)'//11X,1PE15.4,5X,'FLUID BASE DENSITY, RHOW0'  INDAT1.......68500
     3   /11X,1PE15.4,5X,'COEFFICIENT OF DENSITY CHANGE WITH ',          INDAT1.......68600
     4   'TEMPERATURE, DRWDU'/11X,1PE15.4,5X,'TEMPERATURE, URHOW0, ',    INDAT1.......68700
     5   'AT WHICH FLUID DENSITY IS AT BASE VALUE, RHOW0'                INDAT1.......68800
     6   //11X,1PE15.4,5X,'THERMAL CONDUCTIVITY OF FLUID'                INDAT1.......68900
     7   /11X,1PE15.4,5X,'THERMAL CONDUCTIVITY OF SOLID GRAIN')          INDAT1.......69000
!      IF(ME.EQ.-1)                                                       INDAT1.......69100
!     1  WRITE(K3,1220) COMPFL,COMPMA,VISC0,RHOS,RHOW0,DRWDU,             INDAT1.......69200
!     2     URHOW0,SIGMAW                                                 INDAT1.......69300
 1220 FORMAT('1'////11X,'C O N S T A N T   P R O P E R T I E S   O F',   INDAT1.......69400
     1   '   F L U I D   A N D   S O L I D   M A T R I X'                INDAT1.......69500
     2   //11X,1PE15.4,5X,'COMPRESSIBILITY OF FLUID'/11X,1PE15.4,5X,     INDAT1.......69600
     3   'COMPRESSIBILITY OF POROUS MATRIX'                              INDAT1.......69700
     4   //11X,1PE15.4,5X,'FLUID VISCOSITY'                              INDAT1.......69800
     4   //11X,1PE15.4,5X,'DENSITY OF A SOLID GRAIN'                     INDAT1.......69900
     5   //13X,'FLUID DENSITY, RHOW'/13X,'CALCULATED BY ',               INDAT1.......70000
     6   'SUTRA IN TERMS OF SOLUTE CONCENTRATION, U, AS:',               INDAT1.......70100
     7   /13X,'RHOW = RHOW0 + DRWDU*(U-URHOW0)'                          INDAT1.......70200
     8   //11X,1PE15.4,5X,'FLUID BASE DENSITY, RHOW0'                    INDAT1.......70300
     9   /11X,1PE15.4,5X,'COEFFICIENT OF DENSITY CHANGE WITH ',          INDAT1.......70400
     *   'SOLUTE CONCENTRATION, DRWDU'                                   INDAT1.......70500
     1   /11X,1PE15.4,5X,'SOLUTE CONCENTRATION, URHOW0, ',               INDAT1.......70600
     4   'AT WHICH FLUID DENSITY IS AT BASE VALUE, RHOW0'                INDAT1.......70700
     5   //11X,1PE15.4,5X,'MOLECULAR DIFFUSIVITY OF SOLUTE IN FLUID')    INDAT1.......70800
C                                                                        INDAT1.......70900
C.....INPUT DATASET 11:  ADSORPTION PARAMETERS                           INDAT1.......71000
      ERRCOD = 'REA-INP-11'                                              INDAT1.......71100
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......71200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) ADSMOD                              INDAT1.......71300
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......71400
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IF (ADSMOD.NE.'NONE      ') THEN                                   INDAT1.......71500
         READ(INTFIL,*,IOSTAT=INERR(1)) ADSMOD,CHI1,CHI2                 INDAT1.......71600
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......71700
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      END IF                                                             INDAT1.......71800
      IF(ME.EQ.+1) GOTO 1248                                             INDAT1.......71900
!      IF(ADSMOD.EQ.'NONE      ') GOTO 1234                               INDAT1.......72000
!      WRITE(K3,1232) ADSMOD                                              INDAT1.......72100
 1232 FORMAT(////11X,'A D S O R P T I O N   P A R A M E T E R S'         INDAT1.......72200
     1   //16X,A10,5X,'EQUILIBRIUM SORPTION ISOTHERM')                   INDAT1.......72300
!      GOTO 1236                                                          INDAT1.......72400
! 1234 WRITE(K3,1235)                                                     INDAT1.......72500
 1235 FORMAT(////11X,'A D S O R P T I O N   P A R A M E T E R S'         INDAT1.......72600
     1   //16X,'NON-SORBING SOLUTE')                                     INDAT1.......72700
 1236 IF((ADSMOD.EQ.'NONE      ').OR.(ADSMOD.EQ.'LINEAR    ').OR.        INDAT1.......72800
     1   (ADSMOD.EQ.'FREUNDLICH').OR.(ADSMOD.EQ.'LANGMUIR  ')) GOTO 1238 INDAT1.......72900
           IErrorFlag = 153
           return
!      ERRCOD = 'INP-11-1'                                                INDAT1.......73000
!      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           INDAT1.......73100
 1238 CONTINUE
! 1238 IF(ADSMOD.EQ.'LINEAR    ') WRITE(K3,1242) CHI1                     INDAT1.......73200
 1242 FORMAT(11X,1PE15.4,5X,'LINEAR DISTRIBUTION COEFFICIENT')           INDAT1.......73300
!      IF(ADSMOD.EQ.'FREUNDLICH') WRITE(K3,1244) CHI1,CHI2                INDAT1.......73400
 1244 FORMAT(11X,1PE15.4,5X,'FREUNDLICH DISTRIBUTION COEFFICIENT'        INDAT1.......73500
     1   /11X,1PE15.4,5X,'SECOND FREUNDLICH COEFFICIENT')                INDAT1.......73600
      IF(ADSMOD.EQ.'FREUNDLICH'.AND.CHI2.LE.0.D0) THEN                   INDAT1.......73700
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-11-2'                                             INDAT1.......73800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......73900
      ENDIF                                                              INDAT1.......74000
!      IF(ADSMOD.EQ.'LANGMUIR  ') WRITE(K3,1246) CHI1,CHI2                INDAT1.......74100
 1246 FORMAT(11X,1PE15.4,5X,'LANGMUIR DISTRIBUTION COEFFICIENT'          INDAT1.......74200
     1   /11X,1PE15.4,5X,'SECOND LANGMUIR COEFFICIENT')                  INDAT1.......74300
C                                                                        INDAT1.......74400
C.....INPUT DATASET 12:  PRODUCTION OF ENERGY OR SOLUTE MASS             INDAT1.......74500
 1248 ERRCOD = 'REA-INP-12'                                              INDAT1.......74600
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......74700
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) PRODF0,PRODS0,PRODF1,PRODS1         INDAT1.......74800
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......74900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
!      IF(ME.EQ.-1) WRITE(K3,1250) PRODF0,PRODS0,PRODF1,PRODS1            INDAT1.......75000
 1250 FORMAT(////11X,'P R O D U C T I O N   A N D   D E C A Y   O F   ', INDAT1.......75100
     1   'S P E C I E S   M A S S'//13X,'PRODUCTION RATE (+)'/13X,       INDAT1.......75200
     2   'DECAY RATE (-)'//11X,1PE15.4,5X,'ZERO-ORDER RATE OF SOLUTE ',  INDAT1.......75300
     3   'MASS PRODUCTION/DECAY IN FLUID'/11X,1PE15.4,5X,                INDAT1.......75400
     4   'ZERO-ORDER RATE OF ADSORBATE MASS PRODUCTION/DECAY IN ',       INDAT1.......75500
     5   'IMMOBILE PHASE'/11X,1PE15.4,5X,'FIRST-ORDER RATE OF SOLUTE ',  INDAT1.......75600
     3   'MASS PRODUCTION/DECAY IN FLUID'/11X,1PE15.4,5X,                INDAT1.......75700
     4   'FIRST-ORDER RATE OF ADSORBATE MASS PRODUCTION/DECAY IN ',      INDAT1.......75800
     5   'IMMOBILE PHASE')                                               INDAT1.......75900
!      IF(ME.EQ.+1) WRITE(K3,1260) PRODF0,PRODS0                          INDAT1.......76000
 1260 FORMAT(////11X,'P R O D U C T I O N   A N D   L O S S   O F   ',   INDAT1.......76100
     1   'E N E R G Y'//13X,'PRODUCTION RATE (+)'/13X,                   INDAT1.......76200
     2   'LOSS RATE (-)'//11X,1PE15.4,5X,'ZERO-ORDER RATE OF ENERGY ',   INDAT1.......76300
     3   'PRODUCTION/LOSS IN FLUID'/11X,1PE15.4,5X,                      INDAT1.......76400
     4   'ZERO-ORDER RATE OF ENERGY PRODUCTION/LOSS IN ',                INDAT1.......76500
     5   'SOLID GRAINS')                                                 INDAT1.......76600
C.....SET PARAMETER SWITCHES FOR EITHER ENERGY OR SOLUTE TRANSPORT       INDAT1.......76700
      IF(ME) 1272,1272,1274                                              INDAT1.......76800
C     FOR SOLUTE TRANSPORT:                                              INDAT1.......76900
 1272 CS=0.0D0                                                           INDAT1.......77000
      CW=1.D00                                                           INDAT1.......77100
      SIGMAS=0.0D0                                                       INDAT1.......77200
      GOTO 1278                                                          INDAT1.......77300
C     FOR ENERGY TRANSPORT:                                              INDAT1.......77400
 1274 ADSMOD='NONE      '                                                INDAT1.......77500
      CHI1=0.0D0                                                         INDAT1.......77600
      CHI2=0.0D0                                                         INDAT1.......77700
      PRODF1=0.0D0                                                       INDAT1.......77800
      PRODS1=0.0D0                                                       INDAT1.......77900
 1278 CONTINUE                                                           INDAT1.......78000
C                                                                        INDAT1.......78100
      IF (KTYPE(1).EQ.3) THEN                                            INDAT1.......78200
C.....READ 3D INPUT FROM DATASETS 13 - 15.                               INDAT1.......78300
C                                                                        INDAT1.......78400
C.....INPUT DATASET 13:  ORIENTATION OF COORDINATES TO GRAVITY           INDAT1.......78500
      ERRCOD = 'REA-INP-13'                                              INDAT1.......78600
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......78700
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) GRAVX,GRAVY,GRAVZ                   INDAT1.......78800
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......78900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
!      WRITE(K3,1320) GRAVX,GRAVY,GRAVZ                                   INDAT1.......79000
 1320 FORMAT(////11X,'C O O R D I N A T E   O R I E N T A T I O N   ',   INDAT1.......79100
     1   'T O   G R A V I T Y'//13X,'COMPONENT OF GRAVITY VECTOR',       INDAT1.......79200
     2   /13X,'IN +X DIRECTION, GRAVX'/11X,1PE15.4,5X,                   INDAT1.......79300
     3   'GRAVX = -GRAV * D(ELEVATION)/DX'//13X,'COMPONENT OF GRAVITY',  INDAT1.......79400
     4   ' VECTOR'/13X,'IN +Y DIRECTION, GRAVY'/11X,1PE15.4,5X,          INDAT1.......79500
     5   'GRAVY = -GRAV * D(ELEVATION)/DY'//13X,'COMPONENT OF GRAVITY',  INDAT1.......79600
     6   ' VECTOR'/13X,'IN +Z DIRECTION, GRAVZ'/11X,1PE15.4,5X,          INDAT1.......79700
     7   'GRAVZ = -GRAV * D(ELEVATION)/DZ')                              INDAT1.......79800
C                                                                        INDAT1.......79900
C.....INPUT DATASETS 14A & 14B:  NODEWISE DATA                           INDAT1.......80000
      ERRCOD = 'REA-INP-14A'                                             INDAT1.......80100
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......80200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,SCALX,SCALY,SCALZ,PORFAC     INDAT1.......80300
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......80400
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IF (CDUM10.NE.'NODE      ') THEN                                   INDAT1.......80500
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-14A-1'                                            INDAT1.......80600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......80700
      END IF                                                             INDAT1.......80800
      NRTEST=1                                                           INDAT1.......80900
      DO 1450 I=1,NN                                                     INDAT1.......81000
      ERRCOD = 'REA-INP-14B'                                             INDAT1.......81100
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......81200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) II,NREG(II),X(II),Y(II),Z(II),      INDAT1.......81300
     1   POR(II)                                                         INDAT1.......81400
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......81500
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      X(II)=X(II)*SCALX                                                  INDAT1.......81600
      Y(II)=Y(II)*SCALY                                                  INDAT1.......81700
      Z(II)=Z(II)*SCALZ                                                  INDAT1.......81800
      POR(II)=POR(II)*PORFAC                                             INDAT1.......81900
      IF(I.GT.1.AND.NREG(II).NE.NROLD) NRTEST=NRTEST+1                   INDAT1.......82000
      NROLD=NREG(II)                                                     INDAT1.......82100
C.....SET SPECIFIC PRESSURE STORATIVITY, SOP.                            INDAT1.......82200
 1450 SOP(II)=(1.D0-POR(II))*COMPMA+POR(II)*COMPFL                       INDAT1.......82300
! 1460 IF(KNODAL.EQ.0) WRITE(K3,1461) SCALX,SCALY,SCALZ,PORFAC            INDAT1.......82400
 1461 FORMAT('1'////11X,'N O D E   I N F O R M A T I O N'//16X,          INDAT1.......82500
     1   'PRINTOUT OF NODE COORDINATES AND POROSITIES ',                 INDAT1.......82600
     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PE15.4,5X,'X-SCALE'/   INDAT1.......82700
     3   33X,1PE15.4,5X,'Y-SCALE'/33X,1PE15.4,5X,'Z-SCALE'/              INDAT1.......82800
     4   33X,1PE15.4,5X,'POROSITY FACTOR')                               INDAT1.......82900
!      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.NE.1) WRITE(K3,1463)     INDAT1.......83000
!      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.EQ.1) WRITE(K3,1465)     INDAT1.......83100
 1463 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......83200
     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......83300
 1465 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......83400
     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......83500
!      IF(KNODAL.EQ.+1.AND.IUNSAT.NE.1)                                   INDAT1.......83600
!     1   WRITE(K3,1470)(I,X(I),Y(I),Z(I),POR(I),I=1,NN)                  INDAT1.......83700
 1470 FORMAT('1'//11X,'N O D E   I N F O R M A T I O N'//14X,            INDAT1.......83800
     1   'NODE',7X,'X',16X,'Y',16X,'Z',15X,'POROSITY'//                  INDAT1.......83900
     2   (9X,I9,3(3X,1PE14.5),6X,0PF8.5))                                INDAT1.......84000
!      IF(KNODAL.EQ.+1.AND.IUNSAT.EQ.1)                                   INDAT1.......84100
!     1   WRITE(K3,1480)(I,NREG(I),X(I),Y(I),Z(I),POR(I),I=1,NN)          INDAT1.......84200
 1480 FORMAT('1'//11X,'N O D E   I N F O R M A T I O N'//14X,'NODE',3X,  INDAT1.......84300
     1   'REGION',7X,'X',16X,'Y',16X,'Z',15X,'POROSITY'//                INDAT1.......84400
     2   (9X,I9,3X,I6,3(3X,1PE14.5),6X,0PF8.5))                          INDAT1.......84500
C                                                                        INDAT1.......84600
C.....INPUT DATASETS 15A & 15B:  ELEMENTWISE DATA                        INDAT1.......84700
      ERRCOD = 'REA-INP-15A'                                             INDAT1.......84800
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......84900
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,PMAXFA,PMIDFA,PMINFA,        INDAT1.......85000
     1   ANG1FA,ANG2FA,ANG3FA,ALMAXF,ALMIDF,ALMINF,                      INDAT1.......85100
     1   ATMXF,ATMDF,ATMNF                                               INDAT1.......85200
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......85300
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IF (CDUM10.NE.'ELEMENT   ') THEN                                   INDAT1.......85400
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-15A-1'                                            INDAT1.......85500
!         CHERR(1) = '3D'                                                 INDAT1.......85600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......85700
      END IF                                                             INDAT1.......85800
      IF(KELMNT.EQ.+1) THEN                                              INDAT1.......85900
         IF (IUNSAT.EQ.1) THEN                                           INDAT1.......86000
!            WRITE(K3,1500)                                               INDAT1.......86100
 1500       FORMAT('1'//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......86200
     1         11X,'ELEMENT',3X,'REGION',4X,                             INDAT1.......86300
     2         'MAXIMUM',9X,'MIDDLE',10X,'MINIMUM',18X,                  INDAT1.......86400
     2         'ANGLE1',9X,'ANGLE2',9X,'ANGLE3',4X,                      INDAT1.......86500
     2         'LONGITUDINAL',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,    INDAT1.......86600
     2         'TRANSVERSE',5X,'TRANSVERSE',5X,'TRANSVERSE'/             INDAT1.......86700
     3         31X,'PERMEABILITY',4X,'PERMEABILITY',4X,'PERMEABILITY',   INDAT1.......86800
     4         8X,'(IN DEGREES)',3X,'(IN DEGREES)',3X,'(IN DEGREES)',3X, INDAT1.......86900
     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY',3X,    INDAT1.......87000
     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY'/       INDAT1.......87100
     4         2(64X),' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM' INDAT1.......87200
     4         3X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM'/    INDAT1.......87300
     1         2(64X),'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION' INDAT1.......87400
     2         3X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)   INDAT1.......87500
         ELSE                                                            INDAT1.......87600
!            WRITE(K3,1501)                                               INDAT1.......87700
 1501       FORMAT('1'//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......87800
     1         11X,'ELEMENT',4X,                                         INDAT1.......87900
     2         'MAXIMUM',9X,'MIDDLE',10X,'MINIMUM',18X,                  INDAT1.......88000
     2         'ANGLE1',9X,'ANGLE2',9X,'ANGLE3',4X,                      INDAT1.......88100
     2         'LONGITUDINAL',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,    INDAT1.......88200
     2         'TRANSVERSE',5X,'TRANSVERSE',5X,'TRANSVERSE'/             INDAT1.......88300
     3         22X,'PERMEABILITY',4X,'PERMEABILITY',4X,'PERMEABILITY',   INDAT1.......88400
     4         8X,'(IN DEGREES)',3X,'(IN DEGREES)',3X,'(IN DEGREES)',3X, INDAT1.......88500
     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY',3X,    INDAT1.......88600
     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY'/       INDAT1.......88700
     4         119X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM',  INDAT1.......88800
     4         3X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM'/    INDAT1.......88900
     1         119X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION',  INDAT1.......89000
     2         3X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)   INDAT1.......89100
         END IF                                                          INDAT1.......89200
      END IF                                                             INDAT1.......89300
      LRTEST=1                                                           INDAT1.......89400
      DO 1550 LL=1,NE                                                    INDAT1.......89500
      ERRCOD = 'REA-INP-15B'                                             INDAT1.......89600
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......89700
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) L,LREG(L),PMAX,PMID,PMIN,           INDAT1.......89800
     1   ANGLE1,ANGLE2,ANGLE3,ALMAX(L),ALMID(L),ALMIN(L),                INDAT1.......89900
     1   ATMAX(L),ATMID(L),ATMIN(L)                                      INDAT1.......90000
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......90100
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IF(LL.GT.1.AND.LREG(L).NE.LROLD) LRTEST=LRTEST+1                   INDAT1.......90200
      LROLD=LREG(L)                                                      INDAT1.......90300
      PMAX=PMAX*PMAXFA                                                   INDAT1.......90400
      PMID=PMID*PMIDFA                                                   INDAT1.......90500
      PMIN=PMIN*PMINFA                                                   INDAT1.......90600
      ANGLE1=ANGLE1*ANG1FA                                               INDAT1.......90700
      ANGLE2=ANGLE2*ANG2FA                                               INDAT1.......90800
      ANGLE3=ANGLE3*ANG3FA                                               INDAT1.......90900
      ALMAX(L)=ALMAX(L)*ALMAXF                                           INDAT1.......91000
      ALMID(L)=ALMID(L)*ALMIDF                                           INDAT1.......91100
      ALMIN(L)=ALMIN(L)*ALMINF                                           INDAT1.......91200
      ATMAX(L)=ATMAX(L)*ATMXF                                            INDAT1.......91300
      ATMID(L)=ATMID(L)*ATMDF                                            INDAT1.......91400
      ATMIN(L)=ATMIN(L)*ATMNF                                            INDAT1.......91500
!      IF(KELMNT.EQ.+1.AND.IUNSAT.NE.1) WRITE(K3,1520) L,                 INDAT1.......91600
!     1   PMAX,PMID,PMIN,ANGLE1,ANGLE2,ANGLE3,                            INDAT1.......91700
!     2   ALMAX(L),ALMID(L),ALMIN(L),ATMAX(L),ATMID(L),ATMIN(L)           INDAT1.......91800
 1520 FORMAT(9X,I9,2X,3(1PE14.5,2X),7X,9(G11.4,4X))                      INDAT1.......91900
!      IF(KELMNT.EQ.+1.AND.IUNSAT.EQ.1) WRITE(K3,1530) L,LREG(L),         INDAT1.......92000
!     1   PMAX,PMID,PMIN,ANGLE1,ANGLE2,ANGLE3,                            INDAT1.......92100
!     2   ALMAX(L),ALMID(L),ALMIN(L),ATMAX(L),ATMID(L),ATMIN(L)           INDAT1.......92200
 1530 FORMAT(9X,I9,4X,I5,2X,3(1PE14.5,2X),7X,9(G11.4,4X))                INDAT1.......92300
C                                                                        INDAT1.......92400
C.....ROTATE PERMEABILITY FROM MAX/MID/MIN TO X/Y/Z DIRECTIONS.          INDAT1.......92500
C        BASED ON CODE WRITTEN BY DAVID POLLOCK (USGS).                  INDAT1.......92600
      D2R=1.745329252D-2                                                 INDAT1.......92700
      PANGL1(L)=D2R*ANGLE1                                               INDAT1.......92800
      PANGL2(L)=D2R*ANGLE2                                               INDAT1.......92900
      PANGL3(L)=D2R*ANGLE3                                               INDAT1.......93000
      ZERO = 0D0                                                         INDAT1.......93100
      CALL ROTMAT(PANGL1(L),PANGL2(L),PANGL3(L),Q11,Q12,Q13,             INDAT1.......93200
     1   Q21,Q22,Q23,Q31,Q32,Q33)                                        INDAT1.......93300
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      CALL TENSYM(PMAX,PMID,PMIN,Q11,Q12,Q13,Q21,Q22,Q23,Q31,Q32,Q33,    INDAT1.......93400
     1   PERMXX(L),PERMXY(L),PERMXZ(L),PERMYX(L),PERMYY(L),PERMYZ(L),    INDAT1.......93500
     2   PERMZX(L),PERMZY(L),PERMZZ(L))                                  INDAT1.......93600
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
 1550 CONTINUE                                                           INDAT1.......93700
!      IF(KELMNT.EQ.0)                                                    INDAT1.......93800
!     1   WRITE(K3,1569) PMAXFA,PMIDFA,PMINFA,ANG1FA,ANG2FA,ANG3FA,       INDAT1.......93900
!     2      ALMAXF,ALMIDF,ALMINF,ATMXF,ATMDF,ATMNF                       INDAT1.......94000
 1569 FORMAT(////11X,'E L E M E N T   I N F O R M A T I O N'//           INDAT1.......94100
     1   16X,'PRINTOUT OF ELEMENT PERMEABILITIES AND DISPERSIVITIES ',   INDAT1.......94200
     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PE15.4,5X,'MAXIMUM ',  INDAT1.......94300
     3   'PERMEABILITY FACTOR'/33X,1PE15.4,5X,'MIDDLE PERMEABILITY ',    INDAT1.......94400
     4   'FACTOR '/33X,1PE15.4,5X,'MINIMUM PERMEABILITY FACTOR'/         INDAT1.......94500
     5   33X,1PE15.4,5X,'ANGLE1 FACTOR'/33X,1PE15.4,5X,'ANGLE2 FACTOR'/  INDAT1.......94600
     6   33X,1PE15.4,5X,'ANGLE3 FACTOR'/                                 INDAT1.......94700
     7   33X,1PE15.4,5X,'FACTOR FOR LONGITUDINAL DISPERSIVITY IN ',      INDAT1.......94800
     8   'MAX-PERM DIRECTION'/33X,1PE15.4,5X,'FACTOR FOR LONGITUDINAL ', INDAT1.......94900
     9   'DISPERSIVITY IN MID-PERM DIRECTION'/33X,1PE15.4,5X,'FACTOR ',  INDAT1.......95000
     T   'FOR LONGITUDINAL DISPERSIVITY IN MIN-PERM DIRECTION'/          INDAT1.......95100
     1   33X,1PE15.4,5X,'FACTOR FOR TRANSVERSE DISPERSIVITY IN ',        INDAT1.......95200
     2   'MAX-PERM DIRECTION'/33X,1PE15.4,5X,'FACTOR FOR TRANSVERSE ',   INDAT1.......95300
     3   'DISPERSIVITY IN MID-PERM DIRECTION'/33X,1PE15.4,5X,'FACTOR',   INDAT1.......95400
     4   ' FOR TRANSVERSE DISPERSIVITY IN MIN-PERM DIRECTION')           INDAT1.......95500
!      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.NE.1) WRITE(K3,1573)     INDAT1.......95600
!      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.EQ.1) WRITE(K3,1575)     INDAT1.......95700
 1573 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......95800
     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......95900
 1575 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......96000
     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......96100
C                                                                        INDAT1.......96200
      ELSE                                                               INDAT1.......96300
C.....READ 2D INPUT FROM DATASETS 13 - 15.                               INDAT1.......96400
C.....NOTE THAT Z = THICKNESS AND PANGL1 = PANGLE.                       INDAT1.......96500
C                                                                        INDAT1.......96600
C.....INPUT DATASET 13:  ORIENTATION OF COORDINATES TO GRAVITY           INDAT1.......96700
      ERRCOD = 'REA-INP-13'                                              INDAT1.......96800
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......96900
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) GRAVX,GRAVY                         INDAT1.......97000
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......97100
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      GRAVZ = 0D0                                                        INDAT1.......97200
!      WRITE(K3,2320) GRAVX,GRAVY                                         INDAT1.......97300
 2320 FORMAT(////11X,'C O O R D I N A T E   O R I E N T A T I O N   ',   INDAT1.......97400
     1   'T O   G R A V I T Y'//13X,'COMPONENT OF GRAVITY VECTOR',       INDAT1.......97500
     2   /13X,'IN +X DIRECTION, GRAVX'/11X,1PE15.4,5X,                   INDAT1.......97600
     3   'GRAVX = -GRAV * D(ELEVATION)/DX'//13X,'COMPONENT OF GRAVITY',  INDAT1.......97700
     4   ' VECTOR'/13X,'IN +Y DIRECTION, GRAVY'/11X,1PE15.4,5X,          INDAT1.......97800
     5   'GRAVY = -GRAV * D(ELEVATION)/DY')                              INDAT1.......97900
C                                                                        INDAT1.......98000
C.....INPUT DATASETS 14A & 14B:  NODEWISE DATA                           INDAT1.......98100
      ERRCOD = 'REA-INP-14A'                                             INDAT1.......98200
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......98300
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,SCALX,SCALY,SCALTH,PORFAC    INDAT1.......98400
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......98500
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IF (CDUM10.NE.'NODE      ') THEN                                   INDAT1.......98600
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-14A-1'                                            INDAT1.......98700
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......98800
      END IF                                                             INDAT1.......98900
      NRTEST=1                                                           INDAT1.......99000
      DO 2450 I=1,NN                                                     INDAT1.......99100
      ERRCOD = 'REA-INP-14B'                                             INDAT1.......99200
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1.......99300
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) II,NREG(II),X(II),Y(II),Z(II),      INDAT1.......99400
     1   POR(II)                                                         INDAT1.......99500
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......99600
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      X(II)=X(II)*SCALX                                                  INDAT1.......99700
      Y(II)=Y(II)*SCALY                                                  INDAT1.......99800
      Z(II)=Z(II)*SCALTH                                                 INDAT1.......99900
      POR(II)=POR(II)*PORFAC                                             INDAT1......100000
      IF(I.GT.1.AND.NREG(II).NE.NROLD) NRTEST=NRTEST+1                   INDAT1......100100
      NROLD=NREG(II)                                                     INDAT1......100200
C.....SET SPECIFIC PRESSURE STORATIVITY, SOP.                            INDAT1......100300
 2450 SOP(II)=(1.D0-POR(II))*COMPMA+POR(II)*COMPFL                       INDAT1......100400
! 2460 IF(KNODAL.EQ.0) WRITE(K3,2461) SCALX,SCALY,SCALTH,PORFAC           INDAT1......100500
 2461 FORMAT('1'////11X,'N O D E   I N F O R M A T I O N'//16X,          INDAT1......100600
     1   'PRINTOUT OF NODE COORDINATES, THICKNESSES AND POROSITIES ',    INDAT1......100700
     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PE15.4,5X,'X-SCALE'/   INDAT1......100800
     1   33X,1PE15.4,5X,'Y-SCALE'/33X,1PE15.4,5X,'THICKNESS FACTOR'/     INDAT1......100900
     2   33X,1PE15.4,5X,'POROSITY FACTOR')                               INDAT1......101000
!      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.NE.1) WRITE(K3,2463)     INDAT1......101100
!      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.EQ.1) WRITE(K3,2465)     INDAT1......101200
 2463 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1......101300
     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1......101400
 2465 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1......101500
     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1......101600
!      IF(KNODAL.EQ.+1.AND.IUNSAT.NE.1)                                   INDAT1......101700
!     1   WRITE(K3,2470)(I,X(I),Y(I),Z(I),POR(I),I=1,NN)                  INDAT1......101800
 2470 FORMAT('1'//11X,'N O D E   I N F O R M A T I O N'//14X,            INDAT1......101900
     1   'NODE',7X,'X',16X,'Y',17X,'THICKNESS',6X,'POROSITY'//           INDAT1......102000
     2   (9X,I9,3(3X,1PE14.5),6X,0PF8.5))                                INDAT1......102100
!      IF(KNODAL.EQ.+1.AND.IUNSAT.EQ.1)                                   INDAT1......102200
!     1   WRITE(K3,2480)(I,NREG(I),X(I),Y(I),Z(I),POR(I),I=1,NN)          INDAT1......102300
 2480 FORMAT('1'//11X,'N O D E   I N F O R M A T I O N'//14X,'NODE',3X,  INDAT1......102400
     1   'REGION',7X,'X',16X,'Y',17X,'THICKNESS',6X,'POROSITY'//         INDAT1......102500
     2   (9X,I9,3X,I6,3(3X,1PE14.5),6X,0PF8.5))                          INDAT1......102600
C                                                                        INDAT1......102700
C.....INPUT DATASETS 15A & 15B:  ELEMENTWISE DATA                        INDAT1......102800
      ERRCOD = 'REA-INP-15A'                                             INDAT1......102900
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1......103000
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,PMAXFA,PMINFA,ANGFAC,        INDAT1......103100
     1   ALMAXF,ALMINF,ATMAXF,ATMINF                                     INDAT1......103200
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1......103300
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IF (CDUM10.NE.'ELEMENT   ') THEN                                   INDAT1......103400
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-15A-1'                                            INDAT1......103500
 !        CHERR(1) = '2D'                                                 INDAT1......103600
  !       CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1......103700
      END IF                                                             INDAT1......103800
      IF (KELMNT.EQ.+1) THEN                                             INDAT1......103900
         IF (IUNSAT.EQ.1) THEN                                           INDAT1......104000
!            WRITE(K3,2500)                                               INDAT1......104100
 2500       FORMAT('1'//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1......104200
     1         11X,'ELEMENT',3X,'REGION',4X,'MAXIMUM',9X,'MINIMUM',12X,  INDAT1......104300
     2         'ANGLE BETWEEN',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,   INDAT1......104400
     3         'TRANSVERSE',5X,'TRANSVERSE'/                             INDAT1......104500
     4         31X,'PERMEABILITY',4X,'PERMEABILITY',4X,                  INDAT1......104600
     5         '+X-DIRECTION AND',3X,'DISPERSIVITY',3X,'DISPERSIVITY',   INDAT1......104700
     6         3X,'DISPERSIVITY',3X,'DISPERSIVITY'/                      INDAT1......104800
     7         59X,'MAXIMUM PERMEABILITY',3X,' IN MAX-PERM',             INDAT1......104900
     8         3X,' IN MIN-PERM',3X,' IN MAX-PERM',3X,' IN MIN-PERM'/    INDAT1......105000
     9         67X,'(IN DEGREES)',3X,'   DIRECTION',3X,                  INDAT1......105100
     1         '   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)      INDAT1......105200
         ELSE                                                            INDAT1......105300
!            WRITE(K3,2501)                                               INDAT1......105400
 2501       FORMAT('1'//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1......105500
     1         11X,'ELEMENT',4X,'MAXIMUM',9X,'MINIMUM',12X,              INDAT1......105600
     2         'ANGLE BETWEEN',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,   INDAT1......105700
     3         'TRANSVERSE',5X,'TRANSVERSE'/                             INDAT1......105800
     4         22X,'PERMEABILITY',4X,'PERMEABILITY',4X,                  INDAT1......105900
     5         '+X-DIRECTION AND',3X,'DISPERSIVITY',3X,'DISPERSIVITY',   INDAT1......106000
     6         3X,'DISPERSIVITY',3X,'DISPERSIVITY'/                      INDAT1......106100
     7         50X,'MAXIMUM PERMEABILITY',3X,' IN MAX-PERM',             INDAT1......106200
     8         3X,' IN MIN-PERM',3X,' IN MAX-PERM',3X,' IN MIN-PERM'/    INDAT1......106300
     9         58X,'(IN DEGREES)',3X,'   DIRECTION',3X,                  INDAT1......106400
     1         '   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)      INDAT1......106500
         END IF                                                          INDAT1......106600
      END IF                                                             INDAT1......106700
      LRTEST=1                                                           INDAT1......106800
      DO 2550 LL=1,NE                                                    INDAT1......106900
      ERRCOD = 'REA-INP-15B'                                             INDAT1......107000
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 INDAT1......107100
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) L,LREG(L),PMAX,PMIN,ANGLEX,         INDAT1......107200
     1   ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)                             INDAT1......107300
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1......107400
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IF(LL.GT.1.AND.LREG(L).NE.LROLD) LRTEST=LRTEST+1                   INDAT1......107500
      LROLD=LREG(L)                                                      INDAT1......107600
      PMAX=PMAX*PMAXFA                                                   INDAT1......107700
      PMIN=PMIN*PMINFA                                                   INDAT1......107800
      ANGLEX=ANGLEX*ANGFAC                                               INDAT1......107900
      ALMAX(L)=ALMAX(L)*ALMAXF                                           INDAT1......108000
      ALMIN(L)=ALMIN(L)*ALMINF                                           INDAT1......108100
      ATMAX(L)=ATMAX(L)*ATMAXF                                           INDAT1......108200
      ATMIN(L)=ATMIN(L)*ATMINF                                           INDAT1......108300
!      IF(KELMNT.EQ.+1.AND.IUNSAT.NE.1) WRITE(K3,2520) L,                 INDAT1......108400
!     1   PMAX,PMIN,ANGLEX,ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)            INDAT1......108500
 2520 FORMAT(9X,I9,2X,2(1PE14.5,2X),7X,5(G11.4,4X))                      INDAT1......108600
!      IF(KELMNT.EQ.+1.AND.IUNSAT.EQ.1) WRITE(K3,2530) L,LREG(L),         INDAT1......108700
!     1   PMAX,PMIN,ANGLEX,ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)            INDAT1......108800
 2530 FORMAT(9X,I9,4X,I5,2X,2(1PE14.5,2X),7X,5(G11.4,4X))                INDAT1......108900
C                                                                        INDAT1......109000
C.....ROTATE PERMEABILITY FROM MAXIMUM/MINIMUM TO X/Y DIRECTIONS         INDAT1......109100
      RADIAX=1.745329D-2*ANGLEX                                          INDAT1......109200
      SINA=DSIN(RADIAX)                                                  INDAT1......109300
      COSA=DCOS(RADIAX)                                                  INDAT1......109400
      SINA2=SINA*SINA                                                    INDAT1......109500
      COSA2=COSA*COSA                                                    INDAT1......109600
      PERMXX(L)=PMAX*COSA2+PMIN*SINA2                                    INDAT1......109700
      PERMYY(L)=PMAX*SINA2+PMIN*COSA2                                    INDAT1......109800
      PERMXY(L)=(PMAX-PMIN)*SINA*COSA                                    INDAT1......109900
      PERMYX(L)=PERMXY(L)                                                INDAT1......110000
      PANGL1(L)=RADIAX                                                   INDAT1......110100
 2550 CONTINUE                                                           INDAT1......110200
!      IF(KELMNT.EQ.0)                                                    INDAT1......110300
!     1   WRITE(K3,2569) PMAXFA,PMINFA,ANGFAC,ALMAXF,ALMINF,ATMAXF,ATMINF INDAT1......110400
 2569 FORMAT(////11X,'E L E M E N T   I N F O R M A T I O N'//           INDAT1......110500
     1   16X,'PRINTOUT OF ELEMENT PERMEABILITIES AND DISPERSIVITIES ',   INDAT1......110600
     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PE15.4,5X,'MAXIMUM ',  INDAT1......110700
     3   'PERMEABILITY FACTOR'/33X,1PE15.4,5X,'MINIMUM PERMEABILITY ',   INDAT1......110800
     4   'FACTOR'/33X,1PE15.4,5X,'ANGLE FROM +X TO MAXIMUM DIRECTION',   INDAT1......110900
     5   ' FACTOR'/33X,1PE15.4,5X,'FACTOR FOR LONGITUDINAL DISPERSIVITY' INDAT1......111000
     6  ,' IN MAX-PERM DIRECTION'/33X,1PE15.4,5X,                        INDAT1......111100
     7   'FACTOR FOR LONGITUDINAL DISPERSIVITY IN MIN-PERM DIRECTION',   INDAT1......111200
     8   /33X,1PE15.4,5X,'FACTOR FOR TRANSVERSE DISPERSIVITY',           INDAT1......111300
     9   ' IN MAX-PERM DIRECTION'/33X,1PE15.4,5X,                        INDAT1......111400
     *   'FACTOR FOR TRANSVERSE DISPERSIVITY IN MIN-PERM DIRECTION')     INDAT1......111500
!      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.NE.1) WRITE(K3,2573)     INDAT1......111600
!      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.EQ.1) WRITE(K3,2575)     INDAT1......111700
 2573 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1......111800
     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1......111900
 2575 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1......112000
     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1......112100
C                                                                        INDAT1......112200
      END IF                                                             INDAT1......112300
C                                                                        INDAT1......112400
      RETURN                                                             INDAT1......112500
      END                                                                INDAT1......112600
C                                                                        INDAT1......112700
C     SUBROUTINE        I  N  D  A  T  2           SUTRA VERSION 2.2     INDAT2.........100
C                                                                        INDAT2.........200
C *** PURPOSE :                                                          INDAT2.........300
C ***  TO READ INITIAL CONDITIONS FROM ICS FILE, AND TO                  INDAT2.........400
C ***  INITIALIZE DATA FOR EITHER WARM OR COLD START OF                  INDAT2.........500
C ***  THE SIMULATION.                                                   INDAT2.........600
C                                                                        INDAT2.........700
c rbw begin change
!      SUBROUTINE INDAT2(PVEC,UVEC,PM1,UM1,UM2,CS1,CS2,CS3,SL,SR,RCIT,    INDAT2.........800
!     1   SW,DSWDP,PBC,IPBC,IPBCT,NREG,QIN,DPDTITR,GNUP1,GNUU1,UIN,UBC,   INDAT2.........900
!     2   QUIN,IBCPBC,IBCUBC,IBCSOP,IBCSOU,IIDPBC,IIDUBC,IIDSOP,IIDSOU)   INDAT2........1000
c rbw end change

C     SUBROUTINE        L  L  D  2  A  R           SUTRA VERSION 2.2     LLD2AR.........100
C                                                                        LLD2AR.........200
C *** PURPOSE :                                                          LLD2AR.........300
C ***  TO LOAD A LINKED LIST OF DOUBLE-PRECISION PAIRS INTO TWO ARRAYS.  LLD2AR.........400
C                                                                        LLD2AR.........500
      SUBROUTINE LLD2AR(LSTLEN, DLIST, DARR1, DARR2)                     LLD2AR.........600
      USE LLDEF                                                          LLD2AR.........700
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                LLD2AR.........800
      TYPE (LLD), POINTER :: DEN, DLIST                                  LLD2AR.........900
      DIMENSION DARR1(*), DARR2(*)                                       LLD2AR........1000
C                                                                        LLD2AR........1100
      DEN => DLIST                                                       LLD2AR........1200
      DO 100 K=1,LSTLEN                                                  LLD2AR........1300
         DARR1(K) = DEN%DVALU1                                           LLD2AR........1400
         DARR2(K) = DEN%DVALU2                                           LLD2AR........1500
         DEN => DEN%NENT                                                 LLD2AR........1600
  100 CONTINUE                                                           LLD2AR........1700
C                                                                        LLD2AR........1800
      RETURN                                                             LLD2AR........1900
      END                                                                LLD2AR........2000
C                                                                        LLD2AR........2100
C                                                                        LLD2AR........2200
C     SUBROUTINE        L  L  D  I  N  S           SUTRA VERSION 2.2     LLDINS.........100
C                                                                        LLDINS.........200
C *** PURPOSE :                                                          LLDINS.........300
C ***  TO INSERT A PAIR OF DOUBLE-PRECISION VALUES INTO A LINKED         LLDINS.........400
C ***  LIST, IN ASCENDING ORDER BASED ON THE FIRST VALUE IN THE PAIR.    LLDINS.........500
C                                                                        LLDINS.........600
      SUBROUTINE LLDINS(LSTLEN, DLIST, DNUM1, DNUM2, DLAST)              LLDINS.........700
      USE LLDEF                                                          LLDINS.........800
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                LLDINS.........900
      TYPE (LLD), POINTER :: DEN, DENPV, DENNW, DLIST, DLAST             LLDINS........1000
C                                                                        LLDINS........1100
C.....IF LIST IS EMPTY, PLACE PAIR AT HEAD OF LIST, ELSE INSERT          LLDINS........1200
C        INTO LIST IN ASCENDING ORDER BASED ON FIRST VALUE               LLDINS........1300
      IF (LSTLEN.EQ.0) THEN                                              LLDINS........1400
C........PLACE AT HEAD                                                   LLDINS........1500
         DLIST%DVALU1 = DNUM1                                            LLDINS........1600
         DLIST%DVALU2 = DNUM2                                            LLDINS........1700
         DLAST => DLIST                                                  LLDINS........1800
      ELSE IF (DNUM1.GE.DLAST%DVALU1) THEN                               LLDINS........1900
C........APPEND TO TAIL                                                  LLDINS........2000
         ALLOCATE(DENNW)                                                 LLDINS........2100
         DENNW%DVALU1 = DNUM1                                            LLDINS........2200
         DENNW%DVALU2 = DNUM2                                            LLDINS........2300
         DLAST%NENT => DENNW                                             LLDINS........2400
         DLAST => DENNW                                                  LLDINS........2500
      ELSE                                                               LLDINS........2600
C........INSERT INTO LISTS                                               LLDINS........2700
         DEN => DLIST                                                    LLDINS........2800
         DO 770 K=1,LSTLEN                                               LLDINS........2900
            IF (DNUM1.LT.DEN%DVALU1) THEN                                LLDINS........3000
               ALLOCATE(DENNW)                                           LLDINS........3100
               DENNW%DVALU1 = DNUM1                                      LLDINS........3200
               DENNW%DVALU2 = DNUM2                                      LLDINS........3300
               DENNW%NENT => DEN                                         LLDINS........3400
               IF (K.EQ.1) THEN                                          LLDINS........3500
                  DLIST => DENNW                                         LLDINS........3600
               ELSE                                                      LLDINS........3700
                  DENPV%NENT => DENNW                                    LLDINS........3800
               END IF                                                    LLDINS........3900
               GOTO 780                                                  LLDINS........4000
            END IF                                                       LLDINS........4100
            DENPV => DEN                                                 LLDINS........4200
            DEN => DEN%NENT                                              LLDINS........4300
  770    CONTINUE                                                        LLDINS........4400
      END IF                                                             LLDINS........4500
C                                                                        LLDINS........4600
  780 LSTLEN = LSTLEN + 1                                                LLDINS........4700
      RETURN                                                             LLDINS........4800
      END                                                                LLDINS........4900
C                                                                        LLDINS........5000
C     SUBROUTINE        L  O  D  O  B  S           SUTRA VERSION 2.2     LODOBS.........100
C                                                                        LODOBS.........200
C *** PURPOSE :                                                          LODOBS.........300
C ***  TO LOAD OBSERVATION POINT INDICES NOBLIN AT A TIME, STARTING      LODOBS.........400
C ***  WITH INDEX JNEXT, INTO ARRAY JSET.  ONLY OBSERVATION POINTS       LODOBS.........500
C ***  WHOSE SCHEDULE AND OUTPUT FORMAT MATCH THOSE THAT CORRESPOND      LODOBS.........600
C ***  TO FILE INDEX NFLO ARE LOADED.  THE NUMBER OF OBSERVATIONS        LODOBS.........700
C ***  LOADED, JLOAD, CAN BE LESS THAN NOBLIN IF THE LIST OF             LODOBS.........800
C ***  OBSERVATION POINT INDICES IS EXHAUSTED.                           LODOBS.........900
C                                                                        LODOBS........1000
      SUBROUTINE LODOBS(NFLO,JNEXT,OBSPTS,JSET,JLOAD)                    LODOBS........1100
      USE ALLARR, ONLY : OBSDAT                                          LODOBS........1200
      USE SCHDEF                                                         LODOBS........1300
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                LODOBS........1400
      TYPE (OBSDAT), DIMENSION (NOBSN) :: OBSPTS                         LODOBS........1500
      DIMENSION JSET(*)                                                  LODOBS........1600
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      LODOBS........1700
C                                                                        LODOBS........1800
      NOBS = NOBSN - 1                                                   LODOBS........1900
C                                                                        LODOBS........2000
      JLOAD = 0                                                          LODOBS........2100
      DO 300 J=JNEXT,NOBS                                                LODOBS........2200
         IF ((OBSPTS(J)%FRMT.EQ."OBS").AND.                              LODOBS........2300
     1      (OBSPTS(J)%SCHED.EQ.SCHDLS(OFP(NFLO)%ISCHED)%NAME))          LODOBS........2400
     2      THEN                                                         LODOBS........2500
            JLOAD = JLOAD + 1                                            LODOBS........2600
            JSET(JLOAD) = J                                              LODOBS........2700
            IF ((JLOAD.EQ.NOBLIN).OR.(J.EQ.NOBS)) THEN                   LODOBS........2800
               JNEXT = J + 1                                             LODOBS........2900
               RETURN                                                    LODOBS........3000
            END IF                                                       LODOBS........3100
         END IF                                                          LODOBS........3200
  300 CONTINUE                                                           LODOBS........3300
C                                                                        LODOBS........3400
      JNEXT = NOBS + 1                                                   LODOBS........3500
      RETURN                                                             LODOBS........3600
      END                                                                LODOBS........3700
C                                                                        LODOBS........3800
C     SUBROUTINE        N  A  F  U                 SUTRA VERSION 2.2     NAFU...........100
C                                                                        NAFU...........200
C *** PURPOSE :                                                          NAFU...........300
C ***  TO FIND THE NEXT AVAILABLE FORTRAN UNIT.  ON INPUT, IUNEXT IS     NAFU...........400
C ***  THE UNIT NUMBER FROM WHICH THE SEARCH IS TO BEGIN.  ON OUTPUT,    NAFU...........500
C ***  IUNEXT IS THE NEXT AVAILABLE UNIT NUMBER.                         NAFU...........600
C                                                                        NAFU...........700
      SUBROUTINE NAFU(IUNEXT,NJMAX,FN)                                   NAFU...........800
c rbw begin change
      USE ErrorFlag
c rbw end change
      USE SCHDEF, ONLY : IUNIO                                           NAFU...........900
      USE BCSDEF                                                         NAFU..........1000
      USE FINDEF                                                         NAFU..........1100
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                NAFU..........1200
      CHARACTER*80 FN,UNAME,FNAME(0:13)                                  NAFU..........1300
      CHARACTER*80 ERRCOD,CHERR(10)                                      NAFU..........1400
      LOGICAL EXST                                                       NAFU..........1500
      LOGICAL ALCBCS,ALCFIN,ALCOBS                                       NAFU..........1600
      DIMENSION INERR(10),RLERR(10)                                      NAFU..........1700
      DIMENSION IUNIT(0:13)                                              NAFU..........1800
      COMMON /ALC/ ALCBCS,ALCFIN,ALCOBS                                  NAFU..........1900
      COMMON /FNAMES/ UNAME,FNAME                                        NAFU..........2000
      COMMON /FUNIB/ NFBCS                                               NAFU..........2100
      COMMON /FUNITA/ IUNIT                                              NAFU..........2200
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 NAFU..........2300
     1   K10,K11,K12,K13                                                 NAFU..........2400
C                                                                        NAFU..........2500
C.....CHECK "SUTRA.FIL" (UNIT K0)                                        NAFU..........2600
  100 IF (IUNEXT.EQ.K0) IUNEXT = IUNEXT + 1                              NAFU..........2700
C.....CHECK NON-INSERTED, NON-OBSERVATION FILES                          NAFU..........2800
  200 DO 300 NFF=0,13                                                    NAFU..........2900
         IF ((NFF.EQ.7).OR.(NFF.EQ.8)) CYCLE                             NAFU..........3000
         IF (IUNEXT.EQ.IUNIT(NFF)) THEN                                  NAFU..........3100
            IUNEXT = IUNEXT + 1                                          NAFU..........3200
            GOTO 100                                                     NAFU..........3300
         END IF                                                          NAFU..........3400
  300 CONTINUE                                                           NAFU..........3500
      IF (ALCBCS) THEN                                                   NAFU..........3600
         DO 350 NFB=1,NFBCS                                              NAFU..........3700
            IF (IUNEXT.EQ.IUNIB(NFB)) THEN                               NAFU..........3800
               IUNEXT = IUNEXT + 1                                       NAFU..........3900
               GOTO 100                                                  NAFU..........4000
            END IF                                                       NAFU..........4100
  350    CONTINUE                                                        NAFU..........4200
      END IF                                                             NAFU..........4300
C.....CHECK OBSERVATION FILES                                            NAFU..........4400
      IF (ALCOBS) THEN                                                   NAFU..........4500
  400    DO 500 NJ=1,NJMAX                                               NAFU..........4600
            IF (IUNEXT.EQ.IUNIO(NJ)) THEN                                NAFU..........4700
               IUNEXT = IUNEXT + 1                                       NAFU..........4800
               GOTO 100                                                  NAFU..........4900
            END IF                                                       NAFU..........5000
  500    CONTINUE                                                        NAFU..........5100
      END IF                                                             NAFU..........5200
C.....CHECK INSERTED FILES                                               NAFU..........5300
      IF ((IUNEXT.EQ.K1).OR.(IUNEXT.EQ.K2).OR.(IUNEXT.EQ.K9)) THEN       NAFU..........5400
         IUNEXT = IUNEXT + 1                                             NAFU..........5500
         GOTO 100                                                        NAFU..........5600
      END IF                                                             NAFU..........5700
      IF (ALCFIN) THEN                                                   NAFU..........5800
         DO 600 I=1,2+NFBCS                                              NAFU..........5900
            DO 600 K=1,NKS(I)                                            NAFU..........6000
               IF (IUNEXT.EQ.KLIST(I,K)) THEN                            NAFU..........6100
                  IUNEXT = IUNEXT + 1                                    NAFU..........6200
                  GOTO 100                                               NAFU..........6300
               END IF                                                    NAFU..........6400
  600    CONTINUE                                                        NAFU..........6500
      END IF                                                             NAFU..........6600
C.....IF THE UNIT NUMBER SELECTED IS NOT VALID, GENERATE ERROR           NAFU..........6700
      INQUIRE(UNIT=IUNEXT, EXIST=EXST)                                   NAFU..........6800
      IF (.NOT.EXST) THEN                                                NAFU..........6900
c rbw begin change
                 IErrorFlag = 129
                 return
!         ERRCOD = 'FIL-10'                                               NAFU..........7000
!         INERR(1) = IUNEXT                                               NAFU..........7100
!         CHERR(1) = UNAME                                                NAFU..........7200
!         CHERR(2) = FN                                                   NAFU..........7300
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        NAFU..........7400
c rbw end change
      END IF                                                             NAFU..........7500
C                                                                        NAFU..........7600
      RETURN                                                             NAFU..........7700
      END                                                                NAFU..........7800
C                                                                        NAFU..........7900
C     SUBROUTINE        N  O  D  A  L              SUTRA VERSION 2.2     NODAL..........100
C                                                                        NODAL..........200
C *** PURPOSE :                                                          NODAL..........300
C ***  (1) TO CARRY OUT ALL CELLWISE CALCULATIONS AND TO ADD CELLWISE    NODAL..........400
C ***      TERMS TO THE GLOBAL MATRIX AND GLOBAL VECTOR FOR BOTH FLOW    NODAL..........500
C ***      AND TRANSPORT EQUATIONS.                                      NODAL..........600
C ***  (2) TO ADD FLUID SOURCE AND SOLUTE MASS OR ENERGY SOURCE TERMS    NODAL..........700
C ***      TO THE MATRIX EQUATIONS.                                      NODAL..........800
C                                                                        NODAL..........900
c rbw begin change
!      SUBROUTINE NODAL(ML,VOL,PMAT,PVEC,UMAT,UVEC,PITER,UITER,PM1,UM1,   NODAL.........1000
!     1   UM2,POR,QIN,UIN,QUIN,QINITR,CS1,CS2,CS3,SL,SR,SW,DSWDP,RHO,SOP, NODAL.........1100
!     1   NREG,JA)                                                        NODAL.........1200
c rbw end change

C     SUBROUTINE        O  U  T  B  C  O  F        SUTRA VERSION 2.2     OUTBCOF........100
C                                                                        OUTBCOF........200
C *** PURPOSE :                                                          OUTBCOF........300
C ***  TO PRINT BOUNDARY CONDITION INFORMATION AT FLUID SOURCE/SINK      OUTBCOF........400
C ***  NODES IN A FLEXIBLE, COLUMNWISE FORMAT.  OUTPUT IS TO THE         OUTBCOF........500
C ***  BCOF FILE.                                                        OUTBCOF........600
C                                                                        OUTBCOF........700
c rbw begin change
!      SUBROUTINE OUTBCOF(QIN,IQSOP,UVEC,UIN,QINITR,IBCSOP,TITLE1,TITLE2, OUTBCOF........800
!     1   IIDSOP)                                                         OUTBCOF........900
c rbw end change
C     SUBROUTINE        O  U  T  B  C  O  P        SUTRA VERSION 2.2     OUTBCOP........100
C                                                                        OUTBCOP........200
C *** PURPOSE :                                                          OUTBCOP........300
C ***  TO PRINT BOUNDARY CONDITION INFORMATION AT SPECIFIED PRESSURE     OUTBCOP........400
C ***  NODES IN A FLEXIBLE, COLUMNWISE FORMAT.  OUTPUT IS TO THE         OUTBCOP........500
C ***  BCOP FILE.                                                        OUTBCOP........600
C                                                                        OUTBCOP........700
c rbw begin change
!      SUBROUTINE OUTBCOP(PVEC,UVEC,PBC,UBC,QPLITR,GNUP1,IPBC,IBCPBC,     OUTBCOP........800
!     1   TITLE1,TITLE2,IIDPBC)                                           OUTBCOP........900
c rbw end change
C     SUBROUTINE        O  U  T  B  C  O  S        SUTRA VERSION 2.2     OUTBCOS........100
C                                                                        OUTBCOS........200
C *** PURPOSE :                                                          OUTBCOS........300
C ***  TO PRINT BOUNDARY CONDITION INFORMATION AT SOLUTE/ENERGY          OUTBCOS........400
C ***  SOURCE/SINK NODES IN A FLEXIBLE, COLUMNWISE FORMAT.  OUTPUT IS    OUTBCOS........500
C ***  TO THE BCOS FILE.                                                 OUTBCOS........600
C                                                                        OUTBCOS........700
c rbw begin change
!      SUBROUTINE OUTBCOS(QUIN,IQSOU,IBCSOU,TITLE1,TITLE2,IIDSOU)         OUTBCOS........800
c rbw end change
C     SUBROUTINE        O  U  T  B  C  O  U        SUTRA VERSION 2.2     OUTBCOU........100
C                                                                        OUTBCOU........200
C *** PURPOSE :                                                          OUTBCOU........300
C ***  TO PRINT BOUNDARY CONDITION INFORMATION AT SPECIFIED CONC/TEMP    OUTBCOU........400
C ***  NODES IN A FLEXIBLE, COLUMNWISE FORMAT.  OUTPUT IS TO THE         OUTBCOU........500
C ***  BCOU FILE.                                                        OUTBCOU........600
C                                                                        OUTBCOU........700
c rbw begin change
!      SUBROUTINE OUTBCOU(UVEC,UBC,GNUU1,IUBC,IBCUBC,TITLE1,TITLE2,       OUTBCOU........800
!     1   IIDUBC)                                                         OUTBCOU........900
c rbw end change
C     SUBROUTINE        O  U  T  E  L  E           SUTRA VERSION 2.2     OUTELE.........100
C                                                                        OUTELE.........200
C *** PURPOSE :                                                          OUTELE.........300
C ***  TO PRINT ELEMENT CENTROID COORDINATES AND VELOCITY COMPONENTS     OUTELE.........400
C ***  IN A FLEXIBLE, COLUMNWISE FORMAT.  OUTPUT IS TO THE ELE FILE.     OUTELE.........500
C                                                                        OUTELE.........600
c rbw begin change
!      SUBROUTINE OUTELE(VMAG,VANG1,VANG2,IN,X,Y,Z,TITLE1,TITLE2,         OUTELE.........700
!     1   BCSFL,BCSTR)                                                    OUTELE.........800
c rbw end change
C     SUBROUTINE        O  U  T  L  S  T  2        SUTRA VERSION 2.2     OUTLST2........100
C                                                                        OUTLST2........200
C *** PURPOSE :                                                          OUTLST2........300
C ***  TO PRINT PRESSURE AND TEMPERATURE OR CONCENTRATION                OUTLST2........400
C ***  SOLUTIONS AND TO OUTPUT INFORMATION ON TIME STEP, ITERATIONS,     OUTLST2........500
C ***  SATURATIONS, AND FLUID VELOCITIES FOR 2D PROBLEMS.                OUTLST2........600
C ***  OUTPUT IS TO THE LST FILE.                                        OUTLST2........700
C                                                                        OUTLST2........800
c rbw begin change
!      SUBROUTINE OUTLST2(ML,ISTOP,IGOI,IERRP,ITRSP,ERRP,                 OUTLST2........900
!     1   IERRU,ITRSU,ERRU,PVEC,UVEC,VMAG,VANG,SW)                        OUTLST2.......1000
c rbw end change
C     SUBROUTINE        O  U  T  L  S  T  3        SUTRA VERSION 2.2     OUTLST3........100
C                                                                        OUTLST3........200
C *** PURPOSE :                                                          OUTLST3........300
C ***  TO PRINT PRESSURE AND TEMPERATURE OR CONCENTRATION                OUTLST3........400
C ***  SOLUTIONS AND TO OUTPUT INFORMATION ON TIME STEP, ITERATIONS,     OUTLST3........500
C ***  SATURATIONS, AND FLUID VELOCITIES FOR 3D PROBLEMS.                OUTLST3........600
C ***  OUTPUT IS TO THE LST FILE.                                        OUTLST3........700
C                                                                        OUTLST3........800
c rbw begin change
!      SUBROUTINE OUTLST3(ML,ISTOP,IGOI,IERRP,ITRSP,ERRP,                 OUTLST3........900
!     1   IERRU,ITRSU,ERRU,PVEC,UVEC,VMAG,VANG1,VANG2,SW)                 OUTLST3.......1000
c rbw end change
C     SUBROUTINE        O  U  T  N  O  D           SUTRA VERSION 2.2     OUTNOD.........100
C                                                                        OUTNOD.........200
C *** PURPOSE :                                                          OUTNOD.........300
C ***  TO PRINT NODE COORDINATES, PRESSURES, CONCENTRATIONS OR           OUTNOD.........400
C ***  TEMPERATURES, AND SATURATIONS IN A FLEXIBLE, COLUMNWISE FORMAT.   OUTNOD.........500
C ***  OUTPUT IS TO THE NOD FILE.                                        OUTNOD.........600
C                                                                        OUTNOD.........700
c rbw begin change
!      SUBROUTINE OUTNOD(PVEC,UVEC,SW,X,Y,Z,TITLE1,TITLE2,BCSFL,BCSTR)    OUTNOD.........800
c rbw end change
C     SUBROUTINE        O  U  T  O  B  C           SUTRA VERSION 2.2     OUTOBC.........100
C                                                                        OUTOBC.........200
C *** PURPOSE :                                                          OUTOBC.........300
C ***  TO PRINT THE SOLUTION AT OBSERVATION POINTS.  SPECIFICALLY,       OUTOBC.........400
C ***  TO PRINT PRESSURES, CONCENTRATIONS OR TEMPERATURES, AND           OUTOBC.........500
C ***  SATURATIONS IN A COLUMNWISE FORMAT SIMILAR TO THAT USED IN THE    OUTOBC.........600
C ***  NODEWISE AND ELEMENTWISE OUTPUT FILES.                            OUTOBC.........700
C                                                                        OUTOBC.........800
c rbw begin change
!      SUBROUTINE OUTOBC(NFLO,OBSPTS,TIME,STEP,PM1,UM1,PVEC,UVEC,         OUTOBC.........900
!     1   TITLE1,TITLE2,IN,LREG,BCSFL,BCSTR)                              OUTOBC........1000
c rbw end change
C     SUBROUTINE        O  U  T  O  B  S           SUTRA VERSION 2.2     OUTOBS.........100
C                                                                        OUTOBS.........200
C *** PURPOSE :                                                          OUTOBS.........300
C ***  TO PRINT THE SOLUTION AT OBSERVATION POINTS.  SPECIFICALLY,       OUTOBS.........400
C ***  TO PRINT PRESSURES, CONCENTRATIONS OR TEMPERATURES, AND           OUTOBS.........500
C ***  SATURATIONS IN A COLUMNWISE FORMAT.                               OUTOBS.........600
C                                                                        OUTOBS.........700
c rbw begin change
!      SUBROUTINE OUTOBS(NFLO,OBSPTS,TIME,STEP,PM1,UM1,PVEC,UVEC,         OUTOBS.........800
!     1   TITLE1,TITLE2,IN,LREG,BCSFL,BCSTR)                              OUTOBS.........900
c rbw end change
C     SUBROUTINE        O  U  T  R  S  T           SUTRA VERSION 2.2     OUTRST.........100
C                                                                        OUTRST.........200
C *** PURPOSE :                                                          OUTRST.........300
C ***  TO STORE RESULTS THAT MAY LATER BE USED TO RESTART                OUTRST.........400
C ***  THE SIMULATION.                                                   OUTRST.........500
C                                                                        OUTRST.........600
c rbw begin change
!      SUBROUTINE OUTRST(PVEC,UVEC,PM1,UM1,CS1,RCIT,SW,QIN,PBC,           OUTRST.........700
!     1   UIN,UBC,QUIN,IBCPBC,IBCUBC,IBCSOP,IBCSOU,                       OUTRST.........800
!     2   IIDPBC,IIDUBC,IIDSOP,IIDSOU)                                    OUTRST.........900
c rbw end change
C     SUBROUTINE        P  R  S  W  D  S           SUTRA VERSION 2.2     PRSWDS.........100
C                                                                        PRSWDS.........200
C *** PURPOSE :                                                          PRSWDS.........300
C ***  PARSE A CHARACTER STRING INTO WORDS.  WORDS ARE CONSIDERED TO BE  PRSWDS.........400
C ***  SEPARATED BY ONE OR MORE OF THE SINGLE-CHARACTER DELIMITER DELIM  PRSWDS.........500
C ***  AND/OR BLANKS.  PARSING CONTINUES UNTIL THE ENTIRE STRING HAS     PRSWDS.........600
C ***  BEEN PROCESSED OR THE NUMBER OF WORDS PARSED EQUALS NWMAX.  IF    PRSWDS.........700
C ***  NWMAX IS SET TO ZERO, PRSWDS SIMPLY COMPUTES THE NUMBER OF WORDS. PRSWDS.........800
C                                                                        PRSWDS.........900
      SUBROUTINE PRSWDS(STRING, DELIM, NWMAX, WORD, NWORDS)              PRSWDS........1000
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                PRSWDS........1100
      CHARACTER*(*) STRING, WORD(NWMAX)                                  PRSWDS........1200
      CHARACTER DELIM*1, DELIM2*2                                        PRSWDS........1300
C                                                                        PRSWDS........1400
C.....DEFINE SET OF DELIMITERS (SPACE PLUS USER-SPECIFIED CHARACTER)     PRSWDS........1500
      DELIM2 = " " // DELIM                                              PRSWDS........1600
C                                                                        PRSWDS........1700
C.....COMPUTE LENGTH OF STRING WITHOUT TRAILING BLANKS                   PRSWDS........1800
      LSTRNG = LEN_TRIM(STRING)                                          PRSWDS........1900
C                                                                        PRSWDS........2000
C.....INITIALIZE WORD LIST AND COUNTERS                                  PRSWDS........2100
      DO 50 I=1,NWMAX                                                    PRSWDS........2200
         WORD(I) = ""                                                    PRSWDS........2300
   50 CONTINUE                                                           PRSWDS........2400
      NWORDS = 0                                                         PRSWDS........2500
      M2 = 0                                                             PRSWDS........2600
C                                                                        PRSWDS........2700
  300 CONTINUE                                                           PRSWDS........2800
C.....FIND THE NEXT CHARACTER THAT IS NOT A DELIMITER                    PRSWDS........2900
      M1L = VERIFY(STRING(M2+1:LSTRNG),DELIM2)                           PRSWDS........3000
      IF (M1L.EQ.0) RETURN                                               PRSWDS........3100
      M1 = M2 + M1L                                                      PRSWDS........3200
C                                                                        PRSWDS........3300
  400 CONTINUE                                                           PRSWDS........3400
C.....FIND THE NEXT CHARACTER THAT IS A DELIMITER                        PRSWDS........3500
      M2L = SCAN(STRING(M1+1:LSTRNG),DELIM2)                             PRSWDS........3600
      IF (M2L.EQ.0) THEN                                                 PRSWDS........3700
         M2 = LSTRNG + 1                                                 PRSWDS........3800
      ELSE                                                               PRSWDS........3900
         M2 = M1 + M2L                                                   PRSWDS........4000
      END IF                                                             PRSWDS........4100
C                                                                        PRSWDS........4200
  500 CONTINUE                                                           PRSWDS........4300
C.....STORE THE LATEST WORD FOUND                                        PRSWDS........4400
      NWORDS = NWORDS + 1                                                PRSWDS........4500
      IF (NWMAX.GT.0) WORD(NWORDS) = STRING(M1:M2-1)                     PRSWDS........4600
C                                                                        PRSWDS........4700
C.....IF END OF STRING NOT REACHED AND NUMBER OF WORDS IS LESS THAN      PRSWDS........4800
C        THE MAXIMUM ALLOWED, CONTINUE PARSING                           PRSWDS........4900
      IF ((M2.LT.LSTRNG).AND.((NWORDS.LT.NWMAX).OR.(NWMAX.EQ.0)))        PRSWDS........5000
     1   GOTO 300                                                        PRSWDS........5100
C                                                                        PRSWDS........5200
      RETURN                                                             PRSWDS........5300
      END                                                                PRSWDS........5400
C                                                                        PRSWDS........5500
C     SUBROUTINE        P  T  R  S  E  T           SUTRA VERSION 2.2     PTRSET.........100
C                                                                        PTRSET.........200
C *** PURPOSE :                                                          PTRSET.........300
C ***  TO SET UP POINTER ARRAYS NEEDED TO SPECIFY THE MATRIX STRUCTURE.  PTRSET.........400
C                                                                        PTRSET.........500
      SUBROUTINE PTRSET()                                                PTRSET.........600
      USE ALLARR                                                         PTRSET.........700
      USE PTRDEF                                                         PTRSET.........800
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                PTRSET.........900
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              PTRSET........1000
     1   NSOP,NSOU,NBCN,NCIDB                                            PTRSET........1100
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        PTRSET........1200
      COMMON /DIMX2/ NELTA, NNVEC, NDIMIA, NDIMJA                        PTRSET........1300
C                                                                        PTRSET........1400
C.....SET UP POINTER ARRAYS IA AND JA THAT SPECIFY MATRIX STRUCTURE IN   PTRSET........1500
C        "SLAP COLUMN" FORMAT.  FOR EACH NODE, CONSTRUCT A LINKED LIST   PTRSET........1600
C        OF NEIGHBORING NODES.  HLIST(K) POINTS TO THE HEAD OF THE LIST  PTRSET........1700
C        FOR NODE K.  THEN, TRANSFER THE LISTS TO ARRAYS IA AND JA.      PTRSET........1800
C                                                                        PTRSET........1900
C.....ALLOCATE HLIST AND LLIST, AND INITIALIZE LIST LENGTHS TO ZERO.     PTRSET........2000
      ALLOCATE(LLIST(NN), HLIST(NN))                                     PTRSET........2100
      DO 490 I=1,NN                                                      PTRSET........2200
         ALLOCATE(HLIST(I)%PL)                                           PTRSET........2300
         LLIST(I) = 0                                                    PTRSET........2400
  490 CONTINUE                                                           PTRSET........2500
C.....LOOP THROUGH INCIDENCE LIST.                                       PTRSET........2600
      DO 500 L=1,NE                                                      PTRSET........2700
      DO 500 IL=1,N48                                                    PTRSET........2800
         IC = IN((L-1)*N48+IL)                                           PTRSET........2900
      DO 500 JL=1,N48                                                    PTRSET........3000
         JC = IN((L-1)*N48+JL)                                           PTRSET........3100
C........INSERT NEIGHBOR JC IN LIST FOR NODE IC IN ASCENDING ORDER.      PTRSET........3200
C           (IF DUPLICATE OR SELF-NEIGHBOR, SKIP IT.)                    PTRSET........3300
         IF (JC.EQ.IC) THEN                                              PTRSET........3400
C...........SKIP SELF-NEIGHBOR.                                          PTRSET........3500
            GOTO 500                                                     PTRSET........3600
         ELSE IF (LLIST(IC).EQ.0) THEN                                   PTRSET........3700
C...........PLACE FIRST LIST ENTRY AT HEAD.                              PTRSET........3800
            HLIST(IC)%PL%NODNUM = JC                                     PTRSET........3900
            GOTO 498                                                     PTRSET........4000
         ELSE                                                            PTRSET........4100
C...........INSERT INTO LIST, OR SKIP IF DUPLICATE.                      PTRSET........4200
            ALLOCATE(DENTPV)                                             PTRSET........4300
            DENTPI => DENTPV                                             PTRSET........4400
            DENTPV%NENT => HLIST(IC)%PL                                  PTRSET........4500
            DO 495 K=1,LLIST(IC)                                         PTRSET........4600
               DENT => DENTPV%NENT                                       PTRSET........4700
               IF (JC.EQ.DENT%NODNUM) THEN                               PTRSET........4800
                  GOTO 500                                               PTRSET........4900
               ELSE IF (JC.LT.DENT%NODNUM) THEN                          PTRSET........5000
                  ALLOCATE(DENTNW)                                       PTRSET........5100
                  DENTNW%NODNUM = JC                                     PTRSET........5200
                  DENTNW%NENT => DENT                                    PTRSET........5300
                  IF (K.EQ.1) THEN                                       PTRSET........5400
                     HLIST(IC)%PL => DENTNW                              PTRSET........5500
                  ELSE                                                   PTRSET........5600
                     DENTPV%NENT => DENTNW                               PTRSET........5700
                  END IF                                                 PTRSET........5800
                  DEALLOCATE(DENTPI)                                     PTRSET........5900
                  GOTO 498                                               PTRSET........6000
               END IF                                                    PTRSET........6100
               DENTPV => DENT                                            PTRSET........6200
  495       CONTINUE                                                     PTRSET........6300
C...........APPEND TO TAIL.                                              PTRSET........6400
            ALLOCATE(DENTNW)                                             PTRSET........6500
            DENTNW%NODNUM = JC                                           PTRSET........6600
            DENT%NENT => DENTNW                                          PTRSET........6700
            DEALLOCATE(DENTPI)                                           PTRSET........6800
         END IF                                                          PTRSET........6900
  498    LLIST(IC) = LLIST(IC) + 1                                       PTRSET........7000
  500 CONTINUE                                                           PTRSET........7100
C.....COMPUTE THE ARRAY DIMENSION NELT AND ALLOCATE ARRAY IA.            PTRSET........7200
      NELT = 0                                                           PTRSET........7300
      DO 600 I=1,NN                                                      PTRSET........7400
  600    NELT = NELT + LLIST(I) + 1                                      PTRSET........7500
      NDIMIA = NELT                                                      PTRSET........7600
      ALLOCATE(IA(NDIMIA))                                               PTRSET........7700
C.....TRANSFER THE LINKED LISTS TO ARRAYS IA AND JA IN SLAP COLUMN       PTRSET........7800
C        FORMAT.  DEALLOCATE POINTERS AS THEY ARE TRANSFERRED.           PTRSET........7900
      JASTRT = 1                                                         PTRSET........8000
      DO 660 I=1,NN                                                      PTRSET........8100
         JA(I) = JASTRT                                                  PTRSET........8200
         IA(JASTRT) = I                                                  PTRSET........8300
         DENT => HLIST(I)%PL                                             PTRSET........8400
         DO 650 K=1,LLIST(I)                                             PTRSET........8500
            IA(JASTRT + K) = DENT%NODNUM                                 PTRSET........8600
            DENTPV => DENT                                               PTRSET........8700
            DENT => DENT%NENT                                            PTRSET........8800
            DEALLOCATE(DENTPV)                                           PTRSET........8900
  650    CONTINUE                                                        PTRSET........9000
         JASTRT = JASTRT + LLIST(I) + 1                                  PTRSET........9100
  660 CONTINUE                                                           PTRSET........9200
      JA(NN + 1) = NELT + 1                                              PTRSET........9300
      DEALLOCATE(HLIST, LLIST)                                           PTRSET........9400
C                                                                        PTRSET........9500
      RETURN                                                             PTRSET........9600
      END                                                                PTRSET........9700
C                                                                        PTRSET........9800
C                                                                        PTRSET........9900
C     SUBROUTINE        P  U                       SUTRA VERSION 2.2     PU.............100
C                                                                        PU.............200
C *** PURPOSE :                                                          PU.............300
C ***  TO EVALUATE P AND U AT SPECIFIED LOCAL COORDINATES WITHIN A       PU.............400
C ***  2D OR 3D ELEMENT.  ADAPTED FROM SUBROUTINES BASIS2 AND BASIS3.    PU.............500
C                                                                        PU.............600
c rbw begin change
!      SUBROUTINE PU(L,XLOC,YLOC,ZLOC,PVEC,UVEC,IN,P,U)                   PU.............700
c rbw end change
C     FUNCTION          P  U  S  W  F              SUTRA VERSION 2.2     PUSWF..........100
C                                                                        PUSWF..........200
C *** PURPOSE :                                                          PUSWF..........300
C ***  TO INTERPOLATE P, U, AND SW AT A FRACTIONAL TIME STEP (BETWEEN    PUSWF..........400
C ***  THE CURRENT AND PREVIOUS TIME STEPS) AND RETURN THE VALUES IN     PUSWF..........500
C ***  AN ARRAY.                                                         PUSWF..........600
C                                                                        PUSWF..........700
c rbw begin change
!      FUNCTION PUSWF(L,XLOC,YLOC,ZLOC,SFRAC,PM1,UM1,PVEC,UVEC,IN,LREG)   PUSWF..........800
c rbw end change
C     SUBROUTINE        R  E  A  D  I  F           SUTRA VERSION 2.2     READIF.........100
C                                                                        READIF.........200
C *** PURPOSE :                                                          READIF.........300
C ***  TO READ A LINE FROM AN INPUT FILE INTO THE CHARACTER VARIABLE     READIF.........400
C ***  INTFIL.  HANDLE OPENING AND CLOSING OF INSERTED FILES AS          READIF.........500
C ***  NECESSARY.                                                        READIF.........600
C                                                                        READIF.........700
      SUBROUTINE READIF(KUU, NFB, INTFIL, ERRCIO, CHERIN)                READIF.........800
c rbw begin change
      USE ErrorFlag
c rbw end change
      USE SCHDEF, ONLY : IUNIO, FNAMO                                    READIF.........900
      USE BCSDEF                                                         READIF........1000
      USE FINDEF                                                         READIF........1100
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                READIF........1200
      PARAMETER (KINMIN=10)                                              READIF........1300
      CHARACTER INTFIL*1000                                              READIF........1400
      CHARACTER*80 ERRCOD,ERRCIO,CHERR(10)                               READIF........1500
      CHARACTER*80, DIMENSION(10), OPTIONAL :: CHERIN                    READIF........1600
      CHARACTER*80 UNAME,FNAME                                           READIF........1700
      CHARACTER ERRF*3, FINS*80                                          READIF........1800
      LOGICAL IS                                                         READIF........1900
      DIMENSION INERR(10),RLERR(10)                                      READIF........2000
      DIMENSION IUNIT(0:13)                                              READIF........2100
      DIMENSION FNAME(0:13)                                              READIF........2200
      COMMON /FNAMES/ UNAME,FNAME                                        READIF........2300
      COMMON /FUNIB/ NFBCS                                               READIF........2400
      COMMON /FUNITA/ IUNIT                                              READIF........2500
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 READIF........2600
     1   K10,K11,K12,K13                                                 READIF........2700
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      READIF........2800
C                                                                        READIF........2900
C.....COPY ERRCIO INTO ERRCOD AND ARRAY CHERIN (IF PRESENT AS AN         READIF........3000
C        ARGUMENT) INTO CHERR.                                           READIF........3100
      ERRCOD = ERRCIO                                                    READIF........3200
      IF (PRESENT(CHERIN)) CHERR = CHERIN                                READIF........3300
C                                                                        READIF........3400
C.....COPY KUU INTO KU. SHOULD AVOID CHANGING KUU, SINCE IT IS ALREADY   READIF........3500
C        LINKED TO K1, K2, OR K9 THROUGH THE ARGUMENT LIST, AND THE      READIF........3600
C        LATTER ARE ALSO PASSED IN THROUGH COMMON BLOCK FUNITS.          READIF........3700
      KU = KUU                                                           READIF........3800
C                                                                        READIF........3900
C.....READ A LINE OF INPUT (UP TO 1000 CHARACTERS) FROM UNIT KU          READIF........4000
C        INTO INTFIL                                                     READIF........4100
100   READ(KU,'(A)',IOSTAT=INERR(1)) INTFIL                              READIF........4200
C.....IF THE END OF AN INSERTED FILE IS REACHED, CLOSE THAT FILE AND     READIF........4300
C        CONTINUE READING FROM THE NEXT-LEVEL-UP FILE                    READIF........4400
      IF (INERR(1).LT.0) THEN                                            READIF........4500
C........SET FLAG IK TO INDICATE WHETHER THE READ WAS ATTEMPTED FROM     READIF........4600
C           AN INP DATASET (IK=1), AN ICS DATASET (IK=2), OR A BCS       READIF........4700
C           DATASET (IK>2)                                               READIF........4800
         IF (KU.EQ.K1) THEN                                              READIF........4900
            IK = 1                                                       READIF........5000
            IIK = 1                                                      READIF........5100
         ELSE IF (KU.EQ.K2) THEN                                         READIF........5200
            IK = 2                                                       READIF........5300
            IIK = 2                                                      READIF........5400
         ELSE                                                            READIF........5500
            IK = 2 + NFB                                                 READIF........5600
            IIK = 9                                                      READIF........5700
         END IF                                                          READIF........5800
C........IF READING FROM AN INSERTED FILE, CLOSE THAT FILE, UPDATE       READIF........5900
C           UNIT NUMBERS, FILENAME, AND COUNTER TO INDICATE THE          READIF........6000
C           NEXT-LEVEL-UP FILE, AND CONTINUE READING                     READIF........6100
         IF (NKS(IK).GT.0) THEN                                          READIF........6200
            CLOSE(KU)                                                    READIF........6300
            IF (KU.EQ.K1) THEN                                           READIF........6400
               K1 = KLIST(IK, NKS(IK))                                   READIF........6500
               FNAME(IIK) = FNAIN(IK, NKS(IK))                           READIF........6600
            ELSE IF (KU.EQ.K2) THEN                                      READIF........6700
               K2 = KLIST(IK, NKS(IK))                                   READIF........6800
               FNAME(IIK) = FNAIN(IK, NKS(IK))                           READIF........6900
            ELSE                                                         READIF........7000
               K9 = KLIST(IK, NKS(IK))                                   READIF........7100
               FNAMB(NFB) = FNAIN(IK, NKS(IK))                           READIF........7200
               IUNIB(NFB) = K9                                           READIF........7300
               FNAME(IIK) = FNAIN(IK, NKS(IK))                           READIF........7400
            END IF                                                       READIF........7500
            KU = KLIST(IK, NKS(IK))                                      READIF........7600
            NKS(IK) = NKS(IK) - 1                                        READIF........7700
            GOTO 100                                                     READIF........7800
         ELSE                                                            READIF........7900
C...........REACHED END OF ZERO-LEVEL FILE. IF ERRCOD="NO_EOF_ERR"       READIF........8000
C                ON INPUT, RETURN; ELSE GENERATE ERROR.                  READIF........8100
            IF (ERRCIO.EQ."NO_EOF_ERR") THEN                             READIF........8200
               ERRCIO = "EOF"                                            READIF........8300
               GOTO 999                                                  READIF........8400
            ELSE                                                         READIF........8500
                 IErrorFlag = 130
                 return
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF........8600
            END IF                                                       READIF........8700
         END IF                                                          READIF........8800
C.....ELSE IF THE READ RESULTS IN A DIFFERENT KIND OF ERROR, GENERATE    READIF........8900
C        ERROR MESSAGE                                                   READIF........9000
      ELSE IF (INERR(1).GT.0) THEN                                       READIF........9100
                 IErrorFlag = 130
                 return
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        READIF........9200
      END IF                                                             READIF........9300
C                                                                        READIF........9400
C.....IF BLANK OR COMMENT LINE, SKIP IT.                                 READIF........9500
      IF ((INTFIL(1:1).EQ.'#').OR.(INTFIL.EQ.'')) GOTO 100               READIF........9600
C                                                                        READIF........9700
C.....IF INSERT STATEMENT, OPEN THE FILE AND CONTINUE READING            READIF........9800
      IF (INTFIL(1:7).EQ.'@INSERT') THEN                                 READIF........9900
C........SET FLAG IK TO INDICATE WHETHER THE READ WAS DONE FROM          READIF.......10000
C           AN INP DATASET (IK=1), AN ICS DATASET (IK=2), OR A BCS       READIF.......10100
C           DATASET (IK>2).  SET ERRF TO THE FILE TYPE ('INP', 'ICS',    READIF.......10200
C           OR 'BCS').                                                   READIF.......10300
         IF (KU.EQ.K1) THEN                                              READIF.......10400
            IK = 1                                                       READIF.......10500
            IIK = 1                                                      READIF.......10600
            ERRF = 'INP'                                                 READIF.......10700
         ELSE IF (KU.EQ.K2) THEN                                         READIF.......10800
            IK = 2                                                       READIF.......10900
            IIK = 2                                                      READIF.......11000
            ERRF = 'ICS'                                                 READIF.......11100
         ELSE                                                            READIF.......11200
            IK = 2 + NFB                                                 READIF.......11300
            IIK = 9                                                      READIF.......11400
            ERRF = 'BCS'                                                 READIF.......11500
         END IF                                                          READIF.......11600
C........READ THE FILE SPECIFICATION FOR THE INSERTED FILE               READIF.......11700
         READ(INTFIL(8:),*,IOSTAT=INERR(1)) KINS, FINS                   READIF.......11800
         IF (INERR(1).NE.0) THEN                                         READIF.......11900
                 IErrorFlag = 130
                 return
!            CHERR(1) = ERRCOD                                            READIF.......12000
!            ERRCOD = 'REA-' // ERRF // '-INS'                            READIF.......12100
 !           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF.......12200
         END IF                                                          READIF.......12300
C........CHECK FOR DUPLICATE FILENAME AMONG INSERTED FILES               READIF.......12400
         DO 550 I=1,2+NFB                                                READIF.......12500
         DO 550 K=1,NKS(I)                                               READIF.......12600
            IF (FINS.EQ.FNAIN(I, K)) THEN                                READIF.......12700
                 IErrorFlag = 130
                 return
!               ERRCOD = 'FIL-4'                                          READIF.......12800
!               INERR(1) = KINS                                           READIF.......12900
 !              CHERR(1) = FNAME(IIK)                                     READIF.......13000
!               CHERR(2) = FINS                                           READIF.......13100
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF.......13200
            END IF                                                       READIF.......13300
  550    CONTINUE                                                        READIF.......13400
C........CHECK FOR DUPLICATE FILENAME AMONG NON-INSERTED,                READIF.......13500
C           NON-OBSERVATION FILES                                        READIF.......13600
         DO 560 NFF=0,13                                                 READIF.......13700
            IF ((NFF.GE.7).OR.(NFF.LE.9)) CYCLE                          READIF.......13800
            IF (FINS.EQ.FNAME(NFF)) THEN                                 READIF.......13900
                 IErrorFlag = 130
                 return
!               ERRCOD = 'FIL-4'                                          READIF.......14000
!               INERR(1) = KINS                                           READIF.......14100
!               CHERR(1) = FNAME(IIK)                                     READIF.......14200
!               CHERR(2) = FINS                                           READIF.......14300
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF.......14400
            END IF                                                       READIF.......14500
  560    CONTINUE                                                        READIF.......14600
         DO 565 NFFB=1,NFBCS                                             READIF.......14700
            IF (FINS.EQ.FNAMB(NFFB)) THEN                                READIF.......14800
                 IErrorFlag = 130
                 return
!               ERRCOD = 'FIL-4'                                          READIF.......14900
!               INERR(1) = KINS                                           READIF.......15000
 !              CHERR(1) = FNAME(IIK)                                     READIF.......15100
!               CHERR(2) = FINS                                           READIF.......15200
               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF.......15300
            END IF                                                       READIF.......15400
  565    CONTINUE                                                        READIF.......15500
C........CHECK FOR DUPLICATE FILENAME AMONG OBSERVATION FILES            READIF.......15600
         DO 570 NJ=1,NFLOMX                                              READIF.......15700
            IF (FINS.EQ.FNAMO(NJ)) THEN                                  READIF.......15800
                 IErrorFlag = 130
                 return
!               ERRCOD = 'FIL-4'                                          READIF.......15900
!               INERR(1) = KINS                                           READIF.......16000
!               CHERR(1) = FNAME(IIK)                                     READIF.......16100
!               CHERR(2) = FINS                                           READIF.......16200
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF.......16300
            END IF                                                       READIF.......16400
  570    CONTINUE                                                        READIF.......16500
C........IF THE SPECIFIED UNIT NUMBER IS LESS THAN KINMIN,               READIF.......16600
C           SET IT TO KINMIN                                             READIF.......16700
         KINS = MAX(KINS, KINMIN)                                        READIF.......16800
C........IF THE FILE TO BE INSERTED EXISTS, ASSIGN IT A UNIT NUMBER      READIF.......16900
C           AND OPEN IT                                                  READIF.......17000
         INQUIRE(FILE=FINS,EXIST=IS)                                     READIF.......17100
         IF (IS) THEN                                                    READIF.......17200
            CALL NAFU(KINS,NFLOMX,FINS)                                  READIF.......17300
            OPEN(UNIT=KINS,FILE=FINS,STATUS='OLD',FORM='FORMATTED',      READIF.......17400
     1         IOSTAT=KERR)                                              READIF.......17500
            IF (KERR.GT.0) THEN                                          READIF.......17600
                 IErrorFlag = 130
                 return
!               CHERR(1) = FNAME(IIK)                                     READIF.......17700
!               CHERR(2) = FINS                                           READIF.......17800
!               INERR(1) = KINS                                           READIF.......17900
!               ERRCOD = 'FIL-2'                                          READIF.......18000
!               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF.......18100
            END IF                                                       READIF.......18200
         ELSE                                                            READIF.......18300
                  IErrorFlag = 130
                 return
!            CHERR(1) = FNAME(IIK)                                        READIF.......18400
!            CHERR(2) = FINS                                              READIF.......18500
!            ERRCOD = 'FIL-1'                                             READIF.......18600
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF.......18700
         END IF                                                          READIF.......18800
C........UPDATE THE INSERTION COUNTER.  IF THE COUNT EXCEEDS 20,         READIF.......18900
C           GENERATE AN ERROR                                            READIF.......19000
         NKS(IK) = NKS(IK) + 1                                           READIF.......19100
         IF (NKS(IK).GT.20) THEN                                         READIF.......19200
                 IErrorFlag = 130
                 return
!            CHERR(1) = FNAME(IIK)                                        READIF.......19300
!            CHERR(2) = FINS                                              READIF.......19400
!            ERRCOD = 'FIL-8'                                             READIF.......19500
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF.......19600
         END IF                                                          READIF.......19700
C........UPDATE UNIT NUMBERS AND FILENAMES TO INDICATE THE NEWLY         READIF.......19800
C           INSERTED FILE, AND CONTINUE READING                          READIF.......19900
         IF (KU.EQ.K1) THEN                                              READIF.......20000
            K1 = KINS                                                    READIF.......20100
            FNAIN(IK, NKS(IK)) = FNAME(IIK)                              READIF.......20200
            FNAME(IIK) = FINS                                            READIF.......20300
         ELSE IF (KU.EQ.K2) THEN                                         READIF.......20400
            K2 = KINS                                                    READIF.......20500
            FNAIN(IK, NKS(IK)) = FNAME(IIK)                              READIF.......20600
            FNAME(IIK) = FINS                                            READIF.......20700
         ELSE                                                            READIF.......20800
            K9 = KINS                                                    READIF.......20900
            FNAIN(IK, NKS(IK)) = FNAMB(NFB)                              READIF.......21000
            FNAMB(NFB) = FINS                                            READIF.......21100
            IUNIB(NFB) = KINS                                            READIF.......21200
C...........SET FNAME(9) EQUAL TO FNAMB(NFB) FOR CONVENIENCE IN          READIF.......21300
C              ERROR HANDLING                                            READIF.......21400
            FNAME(9) = FNAMB(NFB)                                        READIF.......21500
         END IF                                                          READIF.......21600
         KLIST(IK, NKS(IK)) = KU                                         READIF.......21700
         KU = KINS                                                       READIF.......21800
         GOTO 100                                                        READIF.......21900
      END IF                                                             READIF.......22000
C                                                                        READIF.......22100
  999 RETURN                                                             READIF.......22200
      END                                                                READIF.......22300
C                                                                        READIF.......22400
C     SUBROUTINE        R  O  T  A  T  E           SUTRA VERSION 2.2     ROTATE.........100
C                                                                        ROTATE.........200
C *** PURPOSE :                                                          ROTATE.........300
C ***  TO TRANSFORM THE COORDINATES OF A VECTOR, {x}, BY APPLYING THE    ROTATE.........400
C ***  ROTATION MATRIX, [G]:  {xp}=[G]{x}.                               ROTATE.........500
C                                                                        ROTATE.........600
      SUBROUTINE ROTATE(G11,G12,G13,G21,G22,G23,G31,G32,G33,X,Y,Z,       ROTATE.........700
     1   XP,YP,ZP)                                                       ROTATE.........800
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                ROTATE.........900
C                                                                        ROTATE........1000
C.....COMPUTE VECTOR {xp} AS THE PRODUCT OF MATRIX [G] AND VECTOR {x}    ROTATE........1100
      XP= G11*X + G12*Y + G13*Z                                          ROTATE........1200
      YP= G21*X + G22*Y + G23*Z                                          ROTATE........1300
      ZP= G31*X + G32*Y + G33*Z                                          ROTATE........1400
C                                                                        ROTATE........1500
      RETURN                                                             ROTATE........1600
      END                                                                ROTATE........1700
C                                                                        ROTATE........1800
C     SUBROUTINE        R  O  T  M  A  T           SUTRA VERSION 2.2     ROTMAT.........100
C                                                                        ROTMAT.........200
C *** PURPOSE :                                                          ROTMAT.........300
C ***  TO COMPUTE A TRANSFORMATION MATRIX, [G], THAT CONVERTS            ROTMAT.........400
C ***  COORDINATES OF A VECTOR, {v}, FROM A COORDINATE SYSTEM (X, Y, Z)  ROTMAT.........500
C ***  TO A NEW COORDINATE SYSTEM (X', Y', Z'):  {v'} = [G]{v}.          ROTMAT.........600
C ***  THE OVERALL TRANSFORMATION IS THE RESULT OF THREE ROTATIONS       ROTMAT.........700
C ***  APPLIED CONSECUTIVELY:                                            ROTMAT.........800
C ***  A1 = ROTATION IN THE XY-PLANE, COUNTER-CLOCKWISE FROM THE         ROTMAT.........900
C ***     +X-AXIS (LOOKING DOWN THE +Z-AXIS TOWARD THE ORIGIN),          ROTMAT........1000
C ***  A2 = ROTATION IN THE NEW XZ-PLANE, COUNTER-CLOCKWISE FROM THE     ROTMAT........1100
C ***     NEW +X-AXIS (LOOKING DOWN THE NEW +Y-AXIS TOWARD THE ORIGIN),  ROTMAT........1200
C ***  A3 = ROTATION IN THE NEW YZ-PLANE, COUNTER-CLOCKWISE FROM THE     ROTMAT........1300
C ***     NEW +Y-AXIS (LOOKING DOWN THE NEW +X-AXIS TOWARD THE ORIGIN).  ROTMAT........1400
C                                                                        ROTMAT........1500
      SUBROUTINE ROTMAT(A1,A2,A3,G11,G12,G13,G21,G22,G23,G31,G32,G33)    ROTMAT........1600
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                ROTMAT........1700
C                                                                        ROTMAT........1800
C.....COMPUTE SINES AND COSINES OF ANGLES.                               ROTMAT........1900
      S1= DSIN(A1)                                                       ROTMAT........2000
      C1= DCOS(A1)                                                       ROTMAT........2100
      S2= DSIN(A2)                                                       ROTMAT........2200
      C2= DCOS(A2)                                                       ROTMAT........2300
      S3= DSIN(A3)                                                       ROTMAT........2400
      C3= DCOS(A3)                                                       ROTMAT........2500
C                                                                        ROTMAT........2600
C.....COMPUTE ROTATION MATRIX.                                           ROTMAT........2700
      G11 =  C1*C2                                                       ROTMAT........2800
      G12 =  -C1*S2*S3 - S1*C3                                           ROTMAT........2900
      G13 =  -C1*S2*C3 + S1*S3                                           ROTMAT........3000
      G21 =  S1*C2                                                       ROTMAT........3100
      G22 =  -S1*S2*S3 + C1*C3                                           ROTMAT........3200
      G23 =  -S1*S2*C3 - C1*S3                                           ROTMAT........3300
      G31 =  S2                                                          ROTMAT........3400
      G32 =  C2*S3                                                       ROTMAT........3500
      G33 =  C2*C3                                                       ROTMAT........3600
      RETURN                                                             ROTMAT........3700
      END                                                                ROTMAT........3800
C                                                                        ROTMAT........3900
C     SUBROUTINE        S  O  L  V  E  B           SUTRA VERSION 2.2     SOLVEB.........100
C                                                                        SOLVEB.........200
C *** PURPOSE :                                                          SOLVEB.........300
C ***  TO SOLVE THE MATRIX EQUATION BY:                                  SOLVEB.........400
C ***   (1) DECOMPOSING THE MATRIX                                       SOLVEB.........500
C ***   (2) MODIFYING THE RIGHT-HAND SIDE                                SOLVEB.........600
C ***   (3) BACK-SUBSTITUTING FOR THE SOLUTION                           SOLVEB.........700
C                                                                        SOLVEB.........800
c rbw begin change
!      SUBROUTINE SOLVEB(KMT,C,R,NNP,IHALFB,MAXNP,MAXBW)                  SOLVEB.........900
c rbw end change
C     SUBROUTINE        S  O  L  V  E  R           SUTRA VERSION 2.2     SOLVER.........100
C                                                                        SOLVER.........200
C *** PURPOSE :                                                          SOLVER.........300
C ***  TO CALL THE APPROPRIATE MATRIX EQUATION SOLVER.                   SOLVER.........400
C                                                                        SOLVER.........500
c rbw begin change
!      SUBROUTINE SOLVER(KMT,KPU,KSOLVR,C,R,XITER,B,NNP,IHALFB,MAXNP,     SOLVER.........600
!     1                  MAXBW,IWK,FWK,IA,JA,IERR,ITRS,ERR)               SOLVER.........700
c rbw end change
C     SUBROUTINE        S  O  L  W  R  P           SUTRA VERSION 2.2     SOLWRP.........100
C                                                                        SOLWRP.........200
C *** PURPOSE :                                                          SOLWRP.........300
C ***  TO SERVE AS A WRAPPER FOR THE ITERATIVE SOLVERS, PERFORMING       SOLWRP.........400
C ***  SOME PRELIMINARIES ON VECTORS BEFORE CALLING A SOLVER.            SOLWRP.........500
C                                                                        SOLWRP.........600
c rbw begin change
!      SUBROUTINE SOLWRP(KPU, KSOLVR, A, R, XITER, B, NNP,                SOLWRP.........700
!     1                  IWK, FWK, IA, JA, IERR, ITRS, ERR)               SOLWRP.........800
c rbw end change
C     SUBROUTINE        S  O  U  R  C  E           SUTRA VERSION 2.2     SOURCE.........100
C                                                                        SOURCE.........200
C *** PURPOSE :                                                          SOURCE.........300
C ***  TO READ AND ORGANIZE DEFAULT VALUES FOR FLUID MASS SOURCE DATA    SOURCE.........400
C ***  AND ENERGY OR SOLUTE MASS SOURCE DATA.                            SOURCE.........500
C                                                                        SOURCE.........600
      SUBROUTINE SOURCE(QIN,UIN,IQSOP,QUIN,IQSOU,IQSOPT,IQSOUT,          SOURCE.........700
     1   IBCSOP,IBCSOU)                                                  SOURCE.........800
c rbw begin change
      USE ErrorFlag
c rbw end change
      USE EXPINT                                                         SOURCE.........900
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                SOURCE........1000
      CHARACTER INTFIL*1000                                              SOURCE........1100
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:13)                    SOURCE........1200
      INTEGER(1) IBCSOP(NSOP),IBCSOU(NSOU)                               SOURCE........1300
      DIMENSION KTYPE(2)                                                 SOURCE........1400
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  SOURCE........1500
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           SOURCE........1600
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      SOURCE........1700
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              SOURCE........1800
     1   NSOP,NSOU,NBCN,NCIDB                                            SOURCE........1900
      COMMON /FNAMES/ UNAME,FNAME                                        SOURCE........2000
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 SOURCE........2100
     1   K10,K11,K12,K13                                                 SOURCE........2200
      DIMENSION QIN(NN),UIN(NN),IQSOP(NSOP),QUIN(NN),IQSOU(NSOU)         SOURCE........2300
      DIMENSION INERR(10),RLERR(10)                                      SOURCE........2400
C                                                                        SOURCE........2500
C.....NSOPI IS ACTUAL NUMBER OF FLUID SOURCE NODES.                      SOURCE........2600
C.....NSOUI IS ACTUAL NUMBER OF SOLUTE MASS OR ENERGY SOURCE NODES.      SOURCE........2700
      NSOPI=NSOP-1                                                       SOURCE........2800
      NSOUI=NSOU-1                                                       SOURCE........2900
      NIQP=0                                                             SOURCE........3200
      NIQU=0                                                             SOURCE........3300
      IF(NSOPI.EQ.0) GOTO 1000                                           SOURCE........3400
!      IF(ME) 50,50,150                                                   SOURCE........3500
!   50 WRITE(K3,100)                                                      SOURCE........3600
  100 FORMAT('1'////11X,'F L U I D   S O U R C E   D A T A'              SOURCE........3700
     1   ////11X,'**** NODES AT WHICH FLUID INFLOWS OR OUTFLOWS ARE ',   SOURCE........3800
     2   'SPECIFIED ****'                                                SOURCE........3900
     3   //16X,13X,'DEFAULT FLUID',5X,'DEFAULT CONCENTRATION'            SOURCE........4000
     4    /16X,6X,'INFLOW(+)/OUTFLOW(-)',8X,'OF INFLOWING FLUID'         SOURCE........4100
     5    /12X,'NODE',7X,'(FLUID MASS/SECOND)',2X,                       SOURCE........4200
     6   '(MASS SOLUTE/MASS WATER)'//)                                   SOURCE........4300
!      GOTO 300                                                           SOURCE........4400
!  150 WRITE(K3,200)                                                      SOURCE........4500
  200 FORMAT('1'////11X,'F L U I D   S O U R C E   D A T A'              SOURCE........4600
     1   ////11X,'**** NODES AT WHICH FLUID INFLOWS OR OUTFLOWS ARE ',   SOURCE........4700
     2   'SPECIFIED ****'                                                SOURCE........4800
     3   //16X,13X,'DEFAULT FLUID',5X,'  DEFAULT TEMPERATURE'            SOURCE........4900
     4    /16X,6X,'INFLOW(+)/OUTFLOW(-)',8X,'OF INFLOWING FLUID'         SOURCE........5000
     5    /12X,'NODE',7X,'(FLUID MASS/SECOND)',2X,                       SOURCE........5100
     6   '       (DEGREES CELSIUS)'//)                                   SOURCE........5200
C                                                                        SOURCE........5300
C.....INPUT DATASET 17:  DATA FOR FLUID SOURCES AND SINKS                SOURCE........5400
  300 CONTINUE                                                           SOURCE........5500
  305 NIQP=NIQP+1                                                        SOURCE........5600
      ERRCOD = 'REA-INP-17'                                              SOURCE........5700
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 SOURCE........5800
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 187
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IQCP                                SOURCE........5900
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SOURCE........6000
      IF (INERR(1).NE.0) then
                 IErrorFlag = 138
                 return
      endif
      IQCPA = IABS(IQCP)                                                 SOURCE........6100
      IF (IQCP.EQ.0) THEN                                                SOURCE........6200
         GOTO 700                                                        SOURCE........6300
      ELSE IF (IQCPA.GT.NN) THEN                                         SOURCE........6400
           IErrorFlag = 187
        return
!         ERRCOD = 'INP-17-1'                                             SOURCE........6500
!         INERR(1) = IQCPA                                                SOURCE........6600
!         INERR(2) = NN                                                   SOURCE........6700
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE........6800
      ELSE IF (NIQP.GT.NSOPI) THEN                                       SOURCE........6900
         GOTO 305                                                        SOURCE........7000
      END IF                                                             SOURCE........7100
      ERRCOD = 'REA-INP-17'                                              SOURCE........7200
      IF (IQCP.GT.0) THEN                                                SOURCE........7300
         READ(INTFIL,*,IOSTAT=INERR(1)) IQCP,QINC                        SOURCE........7400
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SOURCE........7500
      IF (INERR(1).NE.0) then
                 IErrorFlag = 138
                 return
      endif
         IF (QINC.GT.0D0) THEN                                           SOURCE........7600
            READ(INTFIL,*,IOSTAT=INERR(1)) IQCP,QINC,UINC                SOURCE........7700
!            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  SOURCE........7800
       IF (INERR(1).NE.0) then
                 IErrorFlag = 138
                 return
      endif
        ELSE                                                            SOURCE........7900
            UINC = 0D0                                                   SOURCE........8000
         END IF                                                          SOURCE........8100
      ELSE                                                               SOURCE........8200
         QINC = 0D0                                                      SOURCE........8300
         UINC = 0D0                                                      SOURCE........8400
      END IF                                                             SOURCE........8500
      IQSOP(NIQP)=IQCP                                                   SOURCE........8600
      IF(IQCP.LT.0) IQSOPT=-1                                            SOURCE........8700
      IQP=IABS(IQCP)                                                     SOURCE........8800
      QIN(IQP)=QINC                                                      SOURCE........8900
      UIN(IQP)=UINC                                                      SOURCE........9000
!      IF(IQCP.GT.0) GOTO 450                                             SOURCE........9100
!      WRITE(K3,500) IQCP                                                 SOURCE........9200
!      GOTO 600                                                           SOURCE........9300
!  450 IF(QINC.GT.0) GOTO 460                                             SOURCE........9400
!      WRITE(K3,500) IQCP,QINC                                            SOURCE........9500
!      GOTO 600                                                           SOURCE........9600
!  460 WRITE(K3,500) IQCP,QINC,UINC                                       SOURCE........9700
!  500 FORMAT(7X,I9,6X,1PE20.13,6X,1PE20.13)                              SOURCE........9800
  600 GOTO 305                                                           SOURCE........9900
  700 NIQP = NIQP - 1                                                    SOURCE.......10000
      IF(NIQP.EQ.NSOPI) GOTO 800                                         SOURCE.......10100
                 IErrorFlag = 138
                 return
!         ERRCOD = 'INP-3,17-1'                                           SOURCE.......10200
!         INERR(1) = NIQP                                                 SOURCE.......10300
!         INERR(2) = NSOPI                                                SOURCE.......10400
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE.......10500
  800 CONTINUE
!  800 IF(IQSOPT.NE.-1) GOTO 950                                          SOURCE.......10600
!      IF(ME) 805,805,815                                                 SOURCE.......10700
!  805 WRITE(K3,806)                                                      SOURCE.......10800
!  806 FORMAT(//12X,'TIME-DEPENDENT FLUID SOURCE/SINK OR INFLOW ',        SOURCE.......10900
!     1   'CONCENTRATION'/12X,'SET IN SUBROUTINE BCTIME IS INDICATED ',   SOURCE.......11000
!     2   'BY NEGATIVE NODE NUMBER')                                      SOURCE.......11100
!      GOTO 950                                                           SOURCE.......11200
!  815 WRITE(K3,816)                                                      SOURCE.......11300
!  816 FORMAT(//12X,'TIME-DEPENDENT FLUID SOURCE/SINK OR INFLOW ',        SOURCE.......11400
!     1   'TEMPERATURE'/12X,'SET IN SUBROUTINE BCTIME IS INDICATED ',     SOURCE.......11500
!     2   'BY NEGATIVE NODE NUMBER')                                      SOURCE.......11600
!  950 WRITE(K3,952)                                                      SOURCE.......11700
!  952 FORMAT(/11X,'SPECIFICATIONS MADE IN (OPTIONAL) ',                  SOURCE.......11800
!     1   'BCS INPUT FILES TAKE PRECEDENCE OVER THE'/11X,                 SOURCE.......11900
!     2   'DEFAULT VALUES LISTED ABOVE AND ANY VALUES ',                  SOURCE.......12000
!     3   'SET IN SUBROUTINE BCTIME.')                                    SOURCE.......12100
C.....INITIALIZE ARRAY THAT INDICATES WHERE FLUID SOURCE                 SOURCE.......12200
C        CONDITIONS WERE SET (0 = INP FILE)                              SOURCE.......12300
      IBCSOP = 0                                                         SOURCE.......12400
C                                                                        SOURCE.......12500
C                                                                        SOURCE.......12600
C                                                                        SOURCE.......12700
 1000 IF(NSOUI.EQ.0) GOTO 9000                                           SOURCE.......12800
!      IF(ME) 1050,1050,1150                                              SOURCE.......12900
! 1050 WRITE(K3,1100)                                                     SOURCE.......13000
! 1100 FORMAT(////////11X,'S O L U T E   S O U R C E   D A T A'           SOURCE.......13100
!     1   ////11X,'**** NODES AT WHICH SOURCES OR SINKS OF SOLUTE ',      SOURCE.......13200
!     2   'MASS ARE SPECIFIED ****'                                       SOURCE.......13300
!     3   //16X,12X,'DEFAULT SOLUTE'/16X,9X,'SOURCE(+)/SINK(-)'           SOURCE.......13400
!     4    /12X,'NODE',6X,'(SOLUTE MASS/SECOND)'//)                       SOURCE.......13500
!      GOTO 1305                                                          SOURCE.......13600
! 1150 WRITE(K3,1200)                                                     SOURCE.......13700
!! 1200 FORMAT(////////11X,'E N E R G Y   S O U R C E   D A T A'           SOURCE.......13800
 !    1   ////11X,'**** NODES AT WHICH SOURCES OR SINKS OF ',             SOURCE.......13900
 !    2   'ENERGY ARE SPECIFIED ****'                                     SOURCE.......14000
 !    3   //16X,12X,'DEFAULT ENERGY'/16X,9X,'SOURCE(+)/SINK(-)'           SOURCE.......14100
!     4    /12X,'NODE',11X,'(ENERGY/SECOND)'//)                           SOURCE.......14200
C                                                                        SOURCE.......14300
C.....INPUT DATASET 18:  DATA FOR ENERGY OR SOLUTE MASS SOURCES OR SINKS SOURCE.......14400
 1305 NIQU=NIQU+1                                                        SOURCE.......14500
      ERRCOD = 'REA-INP-18'                                              SOURCE.......14600
      CALL READIF(K1, 0, INTFIL, ERRCOD)                                 SOURCE.......14700
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IQCU                                SOURCE.......14800
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SOURCE.......14900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IQCUA = IABS(IQCU)                                                 SOURCE.......15000
      IF (IQCU.EQ.0) THEN                                                SOURCE.......15100
         GOTO 1700                                                       SOURCE.......15200
      ELSE IF (IQCUA.GT.NN) THEN                                         SOURCE.......15300
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-18-1'                                             SOURCE.......15400
!         INERR(1) = IQCUA                                                SOURCE.......15500
!         INERR(2) = NN                                                   SOURCE.......15600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE.......15700
      ELSE IF (NIQU.GT.NSOUI) THEN                                       SOURCE.......15800
         GOTO 1305                                                       SOURCE.......15900
      END IF                                                             SOURCE.......16000
      IF (IQCU.GT.0) THEN                                                SOURCE.......16100
         ERRCOD = 'REA-INP-18'                                           SOURCE.......16200
         READ(INTFIL,*,IOSTAT=INERR(1)) IQCU,QUINC                       SOURCE.......16300
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SOURCE.......16400
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      ELSE                                                               SOURCE.......16500
         QUINC = 0D0                                                     SOURCE.......16600
      END IF                                                             SOURCE.......16700
      IQSOU(NIQU)=IQCU                                                   SOURCE.......16800
      IF(IQCU.LT.0) IQSOUT=-1                                            SOURCE.......16900
      IQU=IABS(IQCU)                                                     SOURCE.......17000
      QUIN(IQU)=QUINC                                                    SOURCE.......17100
      IF(IQCU.GT.0) GOTO 1450                                            SOURCE.......17200
!      WRITE(K3,1500) IQCU                                                SOURCE.......17300
      GOTO 1600                                                          SOURCE.......17400
 1450 CONTINUE
 !1450 WRITE(K3,1500) IQCU,QUINC                                          SOURCE.......17500
 1500 FORMAT(7X,I9,6X,1PE20.13)                                          SOURCE.......17600
 1600 GOTO 1305                                                          SOURCE.......17700
 1700 NIQU = NIQU - 1                                                    SOURCE.......17800
      IF(NIQU.EQ.NSOUI) GOTO 1800                                        SOURCE.......17900
           IErrorFlag = 153
           return
!         ERRCOD = 'INP-3,18-1'                                           SOURCE.......18000
!         IF (ME.EQ.1) THEN                                               SOURCE.......18100
!            CHERR(1) = 'energy'                                          SOURCE.......18200
!         ELSE                                                            SOURCE.......18300
!            CHERR(1) = 'solute'                                          SOURCE.......18400
!         END IF                                                          SOURCE.......18500
!         INERR(1) = NIQU                                                 SOURCE.......18600
!         INERR(2) = NSOUI                                                SOURCE.......18700
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE.......18800
 1800 IF(IQSOPT.NE.-1) GOTO 6000                                         SOURCE.......18900
!      IF(ME) 1805,1805,1815                                              SOURCE.......19000
! 1805 WRITE(K3,1806)                                                     SOURCE.......19100
 1806 FORMAT(//12X,'TIME-DEPENDENT SOLUTE SOURCE/SINK SET IN ',          SOURCE.......19200
     1   /12X,'SUBROUTINE BCTIME IS INDICATED ',                         SOURCE.......19300
     2   'BY NEGATIVE NODE NUMBER')                                      SOURCE.......19400
!      GOTO 6000                                                          SOURCE.......19500
! 1815 WRITE(K3,1816)                                                     SOURCE.......19600
 1816 FORMAT(//12X,'TIME-DEPENDENT ENERGY SOURCE/SINK SET IN ',          SOURCE.......19700
     1   /12X,'SUBROUTINE BCTIME IS INDICATED ',                         SOURCE.......19800
     2   'BY NEGATIVE NODE NUMBER')                                      SOURCE.......19900
 6000  CONTINUE
! 6000 WRITE(K3,952)                                                      SOURCE.......20000
C.....INITIALIZE ARRAY THAT INDICATES WHERE ENERGY OR SOLUTE SOURCE      SOURCE.......20100
C        CONDITIONS WERE SET (0 = INP FILE)                              SOURCE.......20200
      IBCSOU = 0                                                         SOURCE.......20300
C                                                                        SOURCE.......20400
C                                                                        SOURCE.......20500
 9000 RETURN                                                             SOURCE.......20600
C                                                                        SOURCE.......20700
      END                                                                SOURCE.......20800
C                                                                        SOURCE.......20900
C     SUBROUTINE        S  O  U  R  C  E  1        SUTRA VERSION 2.2     SOURCE1........100
C                                                                        SOURCE1........200
C *** PURPOSE :                                                          SOURCE1........300
C ***  TO READ AND ORGANIZE TIME-DEPENDENT FLUID MASS SOURCE DATA AND    SOURCE1........400
C ***  ENERGY OR SOLUTE MASS SOURCE DATA SPECIFIED IN THE OPTIONAL       SOURCE1........500
C ***  BCS INPUT FILE.                                                   SOURCE1........600
C                                                                        SOURCE1........700
      SUBROUTINE SOURCE1(QIN1,UIN1,IQSOP1,QUIN1,IQSOU1,IQSOPT1,IQSOUT1,  SOURCE1........800
     1   NSOP1,NSOU1,NFB,BCSID)                                          SOURCE1........900
c rbw begin change
      USE ErrorFlag
c rbw end change
      USE EXPINT                                                         SOURCE1.......1000
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                SOURCE1.......1100
      CHARACTER INTFIL*1000                                              SOURCE1.......1200
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:13)                    SOURCE1.......1300
      CHARACTER*40 BCSID                                                 SOURCE1.......1400
      DIMENSION KTYPE(2)                                                 SOURCE1.......1500
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  SOURCE1.......1600
     1   NPCYC,NUCYC,NPRINT,NBCFPR,NBCSPR,NBCPPR,NBCUPR,IREAD,           SOURCE1.......1700
     2   ISTORE,NOUMAT,IUNSAT,KTYPE                                      SOURCE1.......1800
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              SOURCE1.......1900
     1   NSOP,NSOU,NBCN,NCIDB                                            SOURCE1.......2000
      COMMON /FNAMES/ UNAME,FNAME                                        SOURCE1.......2100
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 SOURCE1.......2200
     1   K10,K11,K12,K13                                                 SOURCE1.......2300
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       SOURCE1.......2400
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITBCS,ITRST,ITMAX,TSTART      SOURCE1.......2500
      DIMENSION QIN1(NN),UIN1(NN),IQSOP1(NSOP1)                          SOURCE1.......2600
      DIMENSION QUIN1(NN),IQSOU1(NSOU1)                                  SOURCE1.......2700
      DIMENSION INERR(10),RLERR(10)                                      SOURCE1.......2800
C                                                                        SOURCE1.......2900
C.....NSOPI1 IS ACTUAL NUMBER OF TIME-STEP-DEPENDENT FLUID SOURCE NODES. SOURCE1.......3000
C.....NSOUI1 IS ACTUAL NUMBER OF TIME-STEP-DEPENDENT SOLUTE MASS OR      SOURCE1.......3100
C        ENERGY SOURCE NODES.                                            SOURCE1.......3200
      NSOPI1=NSOP1 - 1                                                   SOURCE1.......3300
      NSOUI1=NSOU1 - 1                                                   SOURCE1.......3400
C                                                                        SOURCE1.......3500
      NIQP = 0                                                           SOURCE1.......3600
      NIQU = 0                                                           SOURCE1.......3700
      IQSOPT1 = +1                                                       SOURCE1.......3800
      IQSOUT1 = +1                                                       SOURCE1.......3900
C                                                                        SOURCE1.......4000
      IF (NSOPI1.EQ.0) GOTO 1000                                         SOURCE1.......4100
C                                                                        SOURCE1.......4200
C.....INPUT BCS DATASET 3:  DATA FOR FLUID SOURCES AND SINKS             SOURCE1.......4300
      IQSOPT1 = -1                                                       SOURCE1.......4400
  305 NIQP = NIQP + 1                                                    SOURCE1.......4500
      ERRCOD = 'REA-BCS-3'                                               SOURCE1.......4600
!      WRITE(CHERR(1),*) ITBCS                                            SOURCE1.......4700
      CHERR(2) = BCSID                                                   SOURCE1.......4800
      CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)                        SOURCE1.......4900
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IQCP                                SOURCE1.......5000
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SOURCE1.......5100
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IQP = IABS(IQCP)                                                   SOURCE1.......5200
      IF (IQCP.EQ.0) THEN                                                SOURCE1.......5300
         GOTO 700                                                        SOURCE1.......5400
      ELSE IF (IQP.GT.NN) THEN                                           SOURCE1.......5500
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-3-1'                                              SOURCE1.......5600
!         INERR(1) = IQP                                                  SOURCE1.......5700
!         INERR(2) = NN                                                   SOURCE1.......5800
!         INERR(3) = ITBCS                                                SOURCE1.......5900
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE1.......6000
      ELSE IF (NIQP.GT.NSOPI1) THEN                                      SOURCE1.......6100
         GOTO 305                                                        SOURCE1.......6200
      END IF                                                             SOURCE1.......6300
      ERRCOD = 'REA-BCS-3'                                               SOURCE1.......6400
!      WRITE(CHERR(1),*) ITBCS                                            SOURCE1.......6500
      CHERR(2) = BCSID                                                   SOURCE1.......6600
      IF (IQCP.GT.0) THEN                                                SOURCE1.......6700
         READ(INTFIL,*,IOSTAT=INERR(1)) IQCP,QINC                        SOURCE1.......6800
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SOURCE1.......6900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
         IF (QINC.GT.0D0) THEN                                           SOURCE1.......7000
            READ(INTFIL,*,IOSTAT=INERR(1)) IQCP,QINC,UINC                SOURCE1.......7100
!            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  SOURCE1.......7200
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
            QIN1(IQP)=QINC                                               SOURCE1.......7300
            UIN1(IQP)=UINC                                               SOURCE1.......7400
         ELSE                                                            SOURCE1.......7500
            QIN1(IQP)=QINC                                               SOURCE1.......7600
         END IF                                                          SOURCE1.......7700
      END IF                                                             SOURCE1.......7800
      IQSOP1(NIQP)=IQCP                                                  SOURCE1.......7900
  600 GOTO 305                                                           SOURCE1.......8000
  700 NIQP = NIQP - 1                                                    SOURCE1.......8100
      IF(NIQP.EQ.NSOPI1) GOTO 1000                                       SOURCE1.......8200
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-2,3-1'                                            SOURCE1.......8300
!         INERR(1) = NIQP                                                 SOURCE1.......8400
!         INERR(2) = NSOPI1                                               SOURCE1.......8500
!         INERR(3) = ITBCS                                                SOURCE1.......8600
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE1.......8700
C                                                                        SOURCE1.......8800
C                                                                        SOURCE1.......8900
 1000 IF(NSOUI1.EQ.0) GOTO 9000                                          SOURCE1.......9000
C                                                                        SOURCE1.......9100
C.....INPUT BCS DATASET 4:  DATA FOR ENERGY OR SOLUTE MASS SOURCES       SOURCE1.......9200
C        OR SINKS                                                        SOURCE1.......9300
      IQSOUT1 = -1                                                       SOURCE1.......9400
 1305 NIQU=NIQU+1                                                        SOURCE1.......9500
      ERRCOD = 'REA-BCS-4'                                               SOURCE1.......9600
!      WRITE(CHERR(1),*) ITBCS                                            SOURCE1.......9700
      CHERR(2) = BCSID                                                   SOURCE1.......9800
      CALL READIF(K9, NFB, INTFIL, ERRCOD, CHERR)                        SOURCE1.......9900
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IQCU                                SOURCE1......10000
!      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SOURCE1......10100
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
      IQU = IABS(IQCU)                                                   SOURCE1......10200
      IF (IQCU.EQ.0) THEN                                                SOURCE1......10300
         GOTO 1700                                                       SOURCE1......10400
      ELSE IF (IQU.GT.NN) THEN                                           SOURCE1......10500
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-4-1'                                              SOURCE1......10600
!         INERR(1) = IQU                                                  SOURCE1......10700
!         INERR(2) = NN                                                   SOURCE1......10800
!         INERR(3) = ITBCS                                                SOURCE1......10900
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE1......11000
      ELSE IF (NIQU.GT.NSOUI1) THEN                                      SOURCE1......11100
         GOTO 1305                                                       SOURCE1......11200
      END IF                                                             SOURCE1......11300
      IF (IQCU.GT.0) THEN                                                SOURCE1......11400
         ERRCOD = 'REA-BCS-4'                                            SOURCE1......11500
!         WRITE(CHERR(1),*) ITBCS                                         SOURCE1......11600
         CHERR(2) = BCSID                                                SOURCE1......11700
         READ(INTFIL,*,IOSTAT=INERR(1)) IQCU,QUINC                       SOURCE1......11800
!         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SOURCE1......11900
      IF (INERR(1).NE.0) then
           IErrorFlag = 153
           return
      endif
         QUIN1(IQU)=QUINC                                                SOURCE1......12000
      END IF                                                             SOURCE1......12100
      IQSOU1(NIQU)=IQCU                                                  SOURCE1......12200
 1600 GOTO 1305                                                          SOURCE1......12300
 1700 NIQU = NIQU - 1                                                    SOURCE1......12400
      IF(NIQU.EQ.NSOUI1) GOTO 9000                                       SOURCE1......12500
           IErrorFlag = 153
           return
!         ERRCOD = 'BCS-2,4-1'                                            SOURCE1......12600
!         IF (ME.EQ.1) THEN                                               SOURCE1......12700
!            CHERR(1) = 'energy'                                          SOURCE1......12800
!         ELSE                                                            SOURCE1......12900
!            CHERR(1) = 'solute'                                          SOURCE1......13000
!         END IF                                                          SOURCE1......13100
!         INERR(1) = NIQU                                                 SOURCE1......13200
!         INERR(2) = NSOUI1                                               SOURCE1......13300
!         INERR(3) = ITBCS                                                SOURCE1......13400
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE1......13500
C                                                                        SOURCE1......13600
 9000 RETURN                                                             SOURCE1......13700
C                                                                        SOURCE1......13800
      END                                                                SOURCE1......13900
C                                                                        SOURCE1......14000
C     SUBROUTINE        S  U  T  E  R  R           SUTRA VERSION 2.2     SUTERR.........100
C                                                                        SUTERR.........200
C *** PURPOSE :                                                          SUTERR.........300
C ***  TO HANDLE SUTRA AND FORTRAN ERRORS.                               SUTERR.........400
C                                                                        SUTERR.........500
c rbw begin change
!      SUBROUTINE SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTERR.........600
c rbw end change
C     SUBROUTINE        S  U  T  R  A              SUTRA VERSION 2.2     SUTRA..........100
C                                                                        SUTRA..........200
C *** PURPOSE :                                                          SUTRA..........300
C ***  MAIN CONTROL ROUTINE FOR SUTRA SIMULATION.  ORGANIZES             SUTRA..........400
C ***  INITIALIZATION, CALCULATIONS FOR EACH TIME STEP AND ITERATION,    SUTRA..........500
C ***  AND VARIOUS OUTPUTS.                                              SUTRA..........600
C                                                                        SUTRA..........700
c rbw begin change
!      SUBROUTINE SUTRA(TITLE1,TITLE2,PMAT,UMAT,PITER,UITER,PM1,DPDTITR,  SUTRA..........800
!     1   UM1,UM2,PVEL,SL,SR,X,Y,Z,VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,  SUTRA..........900
!     2   QIN,UIN,QUIN,QINITR,RCIT,RCITM1,PVEC,UVEC,                      SUTRA.........1000
!     3   ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,VMAG,VANG1,VANG2,           SUTRA.........1100
!     4   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ, SUTRA.........1200
!     5   PANGL1,PANGL2,PANGL3,PBC,UBC,QPLITR,GXSI,GETA,GZET,FWK,B,       SUTRA.........1300
!     6   GNUP1,GNUU1,IN,IQSOP,IQSOU,IPBC,IUBC,OBSPTS,NREG,LREG,IWK,      SUTRA.........1400
!     7   IA,JA,IBCPBC,IBCUBC,IBCSOP,IBCSOU,IIDPBC,IIDUBC,IIDSOP,IIDSOU,  SUTRA.........1500
!     8   IQSOPT,IQSOUT,IPBCT,IUBCT,BCSFL,BCSTR)                          SUTRA.........1600
c rbw end change
C     SUBROUTINE        T  E  N  S  Y  M           SUTRA VERSION 2.2     TENSYM.........100
C                                                                        TENSYM.........200
C *** PURPOSE :                                                          TENSYM.........300
C ***  TO TRANSFORM A DIAGONAL MATRIX TO A NEW COORDINATE SYSTEM.        TENSYM.........400
C ***  [T] IS THE DIAGONAL MATRIX EXPRESSED IN THE FIRST (INPUT)         TENSYM.........500
C ***  COORDINATE SYSTEM; [P] IS THE (SYMMETRIC) MATRIX EXPRESSED        TENSYM.........600
C ***  IN THE SECOND (OUTPUT) COORDINATE SYSTEM; AND [Q] IS THE          TENSYM.........700
C ***  THE TRANSFORMATION MATRIX.                                        TENSYM.........800
C                                                                        TENSYM.........900
      SUBROUTINE TENSYM(T11,T22,T33,Q11,Q12,Q13,Q21,Q22,Q23,             TENSYM........1000
     1   Q31,Q32,Q33,P11,P12,P13,P21,P22,P23,P31,P32,P33)                TENSYM........1100
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                TENSYM........1200
C                                                                        TENSYM........1300
C.....COMPUTE TRANSFORMED MATRIX.                                        TENSYM........1400
      P11= T11*Q11*Q11 + T22*Q12*Q12 + T33*Q13*Q13                       TENSYM........1500
      P12= T11*Q11*Q21 + T22*Q12*Q22 + T33*Q13*Q23                       TENSYM........1600
      P13= T11*Q11*Q31 + T22*Q12*Q32 + T33*Q13*Q33                       TENSYM........1700
      P22= T11*Q21*Q21 + T22*Q22*Q22 + T33*Q23*Q23                       TENSYM........1800
      P23= T11*Q21*Q31 + T22*Q22*Q32 + T33*Q23*Q33                       TENSYM........1900
      P33= T11*Q31*Q31 + T22*Q32*Q32 + T33*Q33*Q33                       TENSYM........2000
      P21= P12                                                           TENSYM........2100
      P31= P13                                                           TENSYM........2200
      P32= P23                                                           TENSYM........2300
C                                                                        TENSYM........2400
      RETURN                                                             TENSYM........2500
      END                                                                TENSYM........2600
C                                                                        TENSYM........2700
C     SUBROUTINE        T  E  R  S  E  Q           SUTRA VERSION 2.2     TERSEQ.........100
C                                                                        TERSEQ.........200
C *** PURPOSE :                                                          TERSEQ.........300
C ***  TO GRACEFULLY TERMINATE A SUTRA RUN BY DEALLOCATING THE MAIN      TERSEQ.........400
C ***  ALLOCATABLE ARRAYS AND CLOSING ALL FILES.                         TERSEQ.........500
C                                                                        TERSEQ.........600
      SUBROUTINE TERSEQ()                                                TERSEQ.........700
      USE ALLARR                                                         TERSEQ.........800
      USE BCSDEF                                                         TERSEQ.........900
      USE FINDEF                                                         TERSEQ........1000
      USE SCHDEF                                                         TERSEQ........1100
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                TERSEQ........1200
      CHARACTER CDUM*1                                                   TERSEQ........1300
      LOGICAL ALCBCS,ALCFIN,ALCOBS                                       TERSEQ........1400
      COMMON /ALC/ ALCBCS,ALCFIN,ALCOBS                                  TERSEQ........1500
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8,K9,                 TERSEQ........1600
     1   K10,K11,K12,K13                                                 TERSEQ........1700
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,                TERSEQ........1800
     1   KPANDS,KVEL,KCORT,KBUDG,KSCRN,KPAUSE                            TERSEQ........1900
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      TERSEQ........2000
C                                                                        TERSEQ........2100
C.....TERMINATION SEQUENCE: DEALLOCATE ARRAYS, CLOSE FILES, AND STOP     TERSEQ........2200
      IF (ALLO1) THEN                                                    TERSEQ........2300
         DEALLOCATE(PITER,UITER,PM1,DPDTITR,UM1,UM2,PVEL,SL,SR,X,Y,Z,    TERSEQ........2400
     1      VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,QIN,UIN,QUIN,QINITR,    TERSEQ........2500
     2      RCIT,RCITM1,GNUP1,GNUU1)                                     TERSEQ........2600
         DEALLOCATE(PVEC,UVEC)                                           TERSEQ........2700
         DEALLOCATE(ALMAX,ALMIN,ATMAX,ATMIN,VMAG,VANG1,PERMXX,PERMXY,    TERSEQ........2800
     1      PERMYX,PERMYY,PANGL1)                                        TERSEQ........2900
         DEALLOCATE(ALMID,ATMID,VANG2,PERMXZ,PERMYZ,PERMZX,PERMZY,       TERSEQ........3000
     1      PERMZZ,PANGL2,PANGL3)                                        TERSEQ........3100
         DEALLOCATE(PBC,UBC,QPLITR)                                      TERSEQ........3200
         DEALLOCATE(GXSI,GETA,GZET)                                      TERSEQ........3300
         DEALLOCATE(B)                                                   TERSEQ........3400
         DEALLOCATE(IN,IQSOP,IQSOU,IPBC,IUBC,NREG,LREG,JA)               TERSEQ........3500
         DEALLOCATE(IBCPBC,IBCUBC,IBCSOP,IBCSOU)                         TERSEQ........3600
         DEALLOCATE(IIDPBC,IIDUBC,IIDSOP,IIDSOU)                         TERSEQ........3610
         DEALLOCATE(BCSFL,BCSTR)                                         TERSEQ........3620
         DEALLOCATE(OBSPTS)                                              TERSEQ........3700
      END IF                                                             TERSEQ........3800
      IF (ALLO2) THEN                                                    TERSEQ........3900
         DEALLOCATE(PMAT,UMAT,FWK)                                       TERSEQ........4000
         DEALLOCATE(IWK)                                                 TERSEQ........4100
      END IF                                                             TERSEQ........4200
      IF (ALLO3) THEN                                                    TERSEQ........4300
         DEALLOCATE(IA)                                                  TERSEQ........4400
      END IF                                                             TERSEQ........4500
      IF (ALCFIN) THEN                                                   TERSEQ........4600
         DEALLOCATE(NKS,KLIST,FNAIN)                                     TERSEQ........4700
      END IF                                                             TERSEQ........4800
      IF (ALCBCS) THEN                                                   TERSEQ........4900
         DEALLOCATE(IUNIB,FNAMB)                                         TERSEQ........5000
      END IF                                                             TERSEQ........5100
      IF (ALLOCATED(SCHDLS)) DEALLOCATE(SCHDLS)                          TERSEQ........5200
      IF (ALLOCATED(OFP)) DEALLOCATE(OFP)                                TERSEQ........5300
      IF (ALCOBS) DEALLOCATE(FNAMO)                                      TERSEQ........5400
      IF (ALLOCATED(ONCK78)) DEALLOCATE(ONCK78)                          TERSEQ........5500
      IF (ALLOCATED(CIDBCS)) DEALLOCATE(CIDBCS)                          TERSEQ........5510
      IF (ALLOCATED(BFP)) DEALLOCATE(BFP)                          
C.....ARRAY IUNIO WILL BE DEALLOCATED AFTER THE OBSERVATION OUTPUT       TERSEQ........5600
C        FILES ARE CLOSED                                                TERSEQ........5700
      CLOSE(K00)                                                         TERSEQ........5800
      CLOSE(K0)                                                          TERSEQ........5900
      CLOSE(K1)                                                          TERSEQ........6000
      CLOSE(K2)                                                          TERSEQ........6100
      CLOSE(K3)                                                          TERSEQ........6200
      CLOSE(K4)                                                          TERSEQ........6300
      CLOSE(K5)                                                          TERSEQ........6400
      CLOSE(K6)                                                          TERSEQ........6500
      CLOSE(K7)                                                          TERSEQ........6600
      CLOSE(K8)                                                          TERSEQ........6700
      DO 8000 NFO=1,NFLOMX                                               TERSEQ........6800
         CLOSE(IUNIO(NFO))                                               TERSEQ........6900
 8000 CONTINUE                                                           TERSEQ........7000
      IF (ALCOBS) DEALLOCATE(IUNIO)                                      TERSEQ........7100
!      IF ((KSCRN.EQ.1).AND.(KPAUSE.EQ.1)) THEN                           TERSEQ........7200
!         WRITE(*,9990)                                                   TERSEQ........7300
! 9990    FORMAT(/' Press ENTER to exit ...')                             TERSEQ........7400
!         READ(*,'(A1)') CDUM                                             TERSEQ........7500
!      END IF                                                             TERSEQ........7600
!      STOP ' '                                                           TERSEQ........7700
C                                                                        TERSEQ........7800
      RETURN                                                             TERSEQ........7900
      END                                                                TERSEQ........8000
C                                                                        TERSEQ........8100
C     FUNCTION          T  I  M  E  T  S           SUTRA VERSION 2.2     TIMETS.........100
C                                                                        TIMETS.........200
C *** PURPOSE :                                                          TIMETS.........300
C ***  TO RETURN THE TIME ASSOCIATED WITH A GIVEN TIME STEP.  IF THE     TIMETS.........400
C ***  SPECIFIED TIME STEP IS GREATER THAN THE MAXIMUM, A VALUE OF       TIMETS.........500
C ***  +HUGE(1D0) (THE LARGEST NUMBER THAT CAN BE REPRESENTED IN DOUBLE  TIMETS.........600
C ***  PRECISION) IS RETURNED.  IF THE SPECIFIED TIME STEP IS LESS THAN  TIMETS.........700
C ***  ZERO, A VALUE OF -HUGE(1D0) IS RETURNED.  IF THE TIME STEP        TIMETS.........800
C ***  SCHEDULE HAS NOT YET BEEN DEFINED, A VALUE OF ZERO IS RETURNED.   TIMETS.........900
C                                                                        TIMETS........1000
      DOUBLE PRECISION FUNCTION TIMETS(NSTEP)                            TIMETS........1100
      USE LLDEF                                                          TIMETS........1200
      USE SCHDEF                                                         TIMETS........1300
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                TIMETS........1400
      TYPE (LLD), POINTER :: DEN                                         TIMETS........1500
      COMMON /SCH/ NSCH,ISCHTS,NSCHAU                                    TIMETS........1600
C                                                                        TIMETS........1700
      IF (ISCHTS.EQ.0) THEN                                              TIMETS........1800
         TIMETS = 0D0                                                    TIMETS........1900
         RETURN                                                          TIMETS........2000
      END IF                                                             TIMETS........2100
C                                                                        TIMETS........2200
      NSMAX = SCHDLS(ISCHTS)%LLEN - 1                                    TIMETS........2300
C                                                                        TIMETS........2400
      IF (NSTEP.LT.0) THEN                                               TIMETS........2500
         TIMETS = -HUGE(1D0)                                             TIMETS........2600
         RETURN                                                          TIMETS........2700
      ELSE IF (NSTEP.GT.NSMAX) THEN                                      TIMETS........2800
         TIMETS = +HUGE(1D0)                                             TIMETS........2900
         RETURN                                                          TIMETS........3000
      END IF                                                             TIMETS........3100
C                                                                        TIMETS........3200
      DEN => SCHDLS(ISCHTS)%SLIST                                        TIMETS........3300
      DO 100 NS=1,NSTEP                                                  TIMETS........3400
         DEN => DEN%NENT                                                 TIMETS........3500
  100 CONTINUE                                                           TIMETS........3600
      TIMETS = DEN%DVALU1                                                TIMETS........3700
C                                                                        TIMETS........3800
      RETURN                                                             TIMETS........3900
      END                                                                TIMETS........4000
C                                                                        TIMETS........4100
C     SUBROUTINE        Z  E  R  O                 SUTRA VERSION 2.2     ZERO...........100
C                                                                        ZERO...........200
C *** PURPOSE :                                                          ZERO...........300
C ***  TO FILL AN ARRAY WITH A CONSTANT VALUE (USUALLY ZERO).            ZERO...........400
C                                                                        ZERO...........500
      SUBROUTINE ZERO(A,IADIM,FILL)                                      ZERO...........600
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                ZERO...........700
      DIMENSION A(IADIM)                                                 ZERO...........800
C                                                                        ZERO...........900
C.....FILL ARRAY A WITH VALUE IN VARIABLE 'FILL'                         ZERO..........1000
      DO 10 I=1,IADIM                                                    ZERO..........1100
   10 A(I)=FILL                                                          ZERO..........1200
C                                                                        ZERO..........1300
C                                                                        ZERO..........1400
      RETURN                                                             ZERO..........1500
      END                                                                ZERO..........1600
