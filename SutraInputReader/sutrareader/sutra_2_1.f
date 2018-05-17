c RBW begin
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
C     MAIN PROGRAM       S U T R A _ M A I N       SUTRA VERSION 2.1     SUTRA_MAIN.....100
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
C|            02-4231, 250p. (Version of June 2, 2008)                 | SUTRA_MAIN....6200
C|                                                                     | SUTRA_MAIN....6300
C|                                                                     | SUTRA_MAIN....6400
C|                                                                     | SUTRA_MAIN....6500
C|       Users who wish to be notified of updates of the SUTRA         | SUTRA_MAIN....6600
C|       code and documentation may be added to the mailing list       | SUTRA_MAIN....6700
C|       by sending a request to :                                     | SUTRA_MAIN....6800
C|                                                                     | SUTRA_MAIN....6900
C|                           SUTRA Support                             | SUTRA_MAIN....7000
C|                       U.S. Geological Survey                        | SUTRA_MAIN....7100
C|                        431 National Center                          | SUTRA_MAIN....7200
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
C|    *  Original Release: 1984                                   *    | SUTRA_MAIN....9000
C|    *  by: Clifford I. Voss, U.S. Geological Survey             *    | SUTRA_MAIN....9100
C|    *                                                           *    | SUTRA_MAIN....9200
C|    *  First Revision: June 1990, Version V06902D               *    | SUTRA_MAIN....9300
C|    *  by: Clifford I. Voss, U.S. Geological Survey             *    | SUTRA_MAIN....9400
C|    *                                                           *    | SUTRA_MAIN....9500
C|    *  Second Revision: September 1997, Version V09972D         *    | SUTRA_MAIN....9600
C|    *  by: C.I. Voss and David Boldt, U.S. Geological Survey    *    | SUTRA_MAIN....9700
C|    *                                                           *    | SUTRA_MAIN....9800
C|    *  Third Revision: September 2003, Version 2D3D.1           *    | SUTRA_MAIN....9900
C|    *  by: A.M. Provost & C.I. Voss, U.S. Geological Survey     *    | SUTRA_MAIN...10000
C|    *                                                           *    | SUTRA_MAIN...10100
C|    *  Fourth Revision: June 2008, Version 2.1                  *    | SUTRA_MAIN...10200
C|    *  by: A.M. Provost & C.I. Voss, U.S. Geological Survey     *    | SUTRA_MAIN...10300
C|    *                                                           *    | SUTRA_MAIN...10400
C|    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    | SUTRA_MAIN...10500
C|                                                                     | SUTRA_MAIN...10600
C|                                                                     | SUTRA_MAIN...10700
C|_____________________________________________________________________| SUTRA_MAIN...10800
C                                                                        SUTRA_MAIN...10900
C                                                                        SUTRA_MAIN...11000
C                                                                        SUTRA_MAIN...11100
c RBW begin
!      PROGRAM SUTRA_MAIN                                                 SUTRA_MAIN...11200
      SUBROUTINE INITIALIZE(NumNodes, NumElem, NPresB, NConcB,
     1   IERRORCODE, InputFile )
      use SutArrays
      use ErrorFlag
c rbw end change
      USE ALLARR                                                         SUTRA_MAIN...11300
      USE PTRDEF                                                         SUTRA_MAIN...11400
      USE EXPINT                                                         SUTRA_MAIN...11500
      USE SCHDEF                                                         SUTRA_MAIN...11600
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                SUTRA_MAIN...11700
      PARAMETER (NCOLMX=9)                                               SUTRA_MAIN...11800
C                                                                        SUTRA_MAIN...11900
C.....PROGRAMMERS SET SUTRA VERSION NUMBER HERE (8 CHARACTERS MAXIMUM)   SUTRA_MAIN...12000
      CHARACTER*8, PARAMETER :: VERN='2.1'                               SUTRA_MAIN...12100
C                                                                        SUTRA_MAIN...12200
c rbw begin
      character (len=*) InputFile
c rbw end
      CHARACTER*8 VERNUM, VERNIN                                         SUTRA_MAIN...12300
      CHARACTER*1 TITLE1(80),TITLE2(80)                                  SUTRA_MAIN...12400
      CHARACTER*80 SIMULA(5),MSHTYP(2),LAYNOR(2),SIMSTR,MSHSTR,LAYSTR    SUTRA_MAIN...12500
      CHARACTER*80 CUNSAT, CSSFLO ,CSSTRA, CREAD                         SUTRA_MAIN...12600
c rbw begin change
      CHARACTER*80 FNAIN
c rbw end change
      CHARACTER*80 UNSSTR, SSFSTR ,SSTSTR, RDSTR                         SUTRA_MAIN...12700
      CHARACTER*80 UNAME,FNAME,FNINP,FNICS                               SUTRA_MAIN...12800
      CHARACTER*80 ERRCOD,CHERR(10)                                      SUTRA_MAIN...12900
      CHARACTER*40 SOLNAM(0:10)                                          SUTRA_MAIN...13000
      CHARACTER*10 SOLWRD(0:10)                                          SUTRA_MAIN...13100
      CHARACTER*10 ADSMOD                                                SUTRA_MAIN...13200
      CHARACTER INTFIL*1000                                              SUTRA_MAIN...13300
      INTEGER RMVDIM,IMVDIM,CMVDIM,PMVDIM                                SUTRA_MAIN...13400
      LOGICAL ONCEK5,ONCEK6,ONCEK7,ONCEK8                                SUTRA_MAIN...13500
      LOGICAL ONCEFO                                                     SUTRA_MAIN...13600
      DIMENSION FNAME(0:8),IUNIT(0:8)                                    SUTRA_MAIN...13700
      DIMENSION FNAIN(2,20)                                              SUTRA_MAIN...13800
      DIMENSION INERR(10), RLERR(10)                                     SUTRA_MAIN...13900
      DIMENSION J5COL(NCOLMX), J6COL(NCOLMX)                             SUTRA_MAIN...14000
      DIMENSION NKS(2), KLIST(2,20)                                      SUTRA_MAIN...14100
      DIMENSION KTYPE(2)                                                 SUTRA_MAIN...14200
      COMMON /CLAY/ LAYSTR                                               SUTRA_MAIN...14300
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  SUTRA_MAIN...14400
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             SUTRA_MAIN...14500
      COMMON /DIMLAY/ NLAYS,NNLAY,NELAY                                  SUTRA_MAIN...14600
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              SUTRA_MAIN...14700
     1   NSOP,NSOU,NBCN                                                  SUTRA_MAIN...14800
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        SUTRA_MAIN...14900
      COMMON /DIMX2/ NELTA, NNVEC, NDIMIA, NDIMJA                        SUTRA_MAIN...15000
      COMMON /FNAINS/ FNAIN                                              SUTRA_MAIN...15100
      COMMON /FNAMES/ UNAME,FNAME                                        SUTRA_MAIN...15200
      COMMON /FO/ONCEFO                                                  SUTRA_MAIN...15300
      COMMON /FUNINS/ NKS,KLIST                                          SUTRA_MAIN...15400
      COMMON /FUNITA/ IUNIT                                              SUTRA_MAIN...15500
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     SUTRA_MAIN...15600
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      SUTRA_MAIN...15700
      COMMON /ITSOLI/ ITRMXP,ITOLP,NSAVEP,ITRMXU,ITOLU,NSAVEU            SUTRA_MAIN...15800
      COMMON /ITSOLR/ TOLP,TOLU                                          SUTRA_MAIN...15900
      COMMON /JCOLS/ NCOLPR, LCOLPR, NCOLS5, NCOLS6, J5COL, J6COL        SUTRA_MAIN...16000
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     SUTRA_MAIN...16100
     1   KSCRN,KPAUSE                                                    SUTRA_MAIN...16200
      COMMON /MODSOR/ ADSMOD                                             SUTRA_MAIN...16300
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      SUTRA_MAIN...16400
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      SUTRA_MAIN...16500
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        SUTRA_MAIN...16600
      COMMON /PLT1/ ONCEK5, ONCEK6, ONCEK7, ONCEK8                       SUTRA_MAIN...16700
      COMMON /SCH/ NSCH,ISCHTS                                           SUTRA_MAIN...16800
      COMMON /SOLVC/ SOLWRD, SOLNAM                                      SUTRA_MAIN...16900
      COMMON /SOLVN/ NSLVRS                                              SUTRA_MAIN...17000
      COMMON /SOLVI/ KSOLVP, KSOLVU, NN1, NN2, NN3                       SUTRA_MAIN...17100
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       SUTRA_MAIN...17200
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITMAX,TSTART                  SUTRA_MAIN...17300
      COMMON /VER/ VERNUM, VERNIN                                        SUTRA_MAIN...17400
c rbw begin
!DEC$ attributes dllexport::INITIALIZE
!       DLL_EXPORT INITIALIZE
c rbw end
C....."NSLVRS" AND THE ARRAYS "SOLWRD" AND "SOLNAM" ARE INITIALIZED      SUTRA_MAIN...17500
C        IN THE BLOCK-DATA SUBPROGRAM "BDINIT"                           SUTRA_MAIN...17600
C                                                                        SUTRA_MAIN...17700
C                                                                        SUTRA_MAIN...17800
C.....COPY PARAMETER VERN (SUTRA VERSION NUMBER) TO VARIABLE VERNUM,     SUTRA_MAIN...17900
C        WHICH IS PASSED THROUGH COMMON BLOCK VER.                       SUTRA_MAIN...18000
      VERNUM = VERN                                                      SUTRA_MAIN...18100
C                                                                        SUTRA_MAIN...18200
C.....SET THE ALLOCATION FLAGS TO FALSE                                  SUTRA_MAIN...18300
      ALLO1 = .FALSE.                                                    SUTRA_MAIN...18400
      ALLO2 = .FALSE.                                                    SUTRA_MAIN...18500
      ALLO3 = .FALSE.                                                    SUTRA_MAIN...18600
C                                                                        SUTRA_MAIN...18700
C_______________________________________________________________________ SUTRA_MAIN...18800
C|                                                                     | SUTRA_MAIN...18900
C|  *****************************************************************  | SUTRA_MAIN...19000
C|  *                                                               *  | SUTRA_MAIN...19100
C|  *   **********  M E M O R Y   A L L O C A T I O N  **********   *  | SUTRA_MAIN...19200
C|  *                                                               *  | SUTRA_MAIN...19300
C|  *   The main arrays used by SUTRA are dimensioned dynamically   *  | SUTRA_MAIN...19400
C|  *   in the main program, SUTRA_MAIN.  The amount of storage     *  | SUTRA_MAIN...19500
C|  *   required by these arrays depends on the dimensionality of   *  | SUTRA_MAIN...19600
C|  *   the problem (2D or 3D) and the particular solver(s) used.   *  | SUTRA_MAIN...19700
C|  *                                                               *  | SUTRA_MAIN...19800
C|  *               |---------------------|---------------------|   *  | SUTRA_MAIN...19900
C|  *               |     sum of real     |    sum of integer   |   *  | SUTRA_MAIN...20000
C|  *               |   array dimensions  |   array dimensions  |   *  | SUTRA_MAIN...20100
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...20200
C|  *   | 2D,       | (2*NBI+27)*NN+19*NE |  NN+5*NE+NSOP+NSOU  |   *  | SUTRA_MAIN...20300
C|  *   | direct    |    +3*NBCN+6*NOBS   |    +2*NBCN+NOBS     |   *  | SUTRA_MAIN...20400
C|  *   | solver    |      +2*NSCH+22     |      +3*NSCH+4      |   *  | SUTRA_MAIN...20500
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...20600
C|  *   | 2D,       | 2*NELT+28*NN+19*NE  | NELT+2*NN+5*NE+NSOP |   *  | SUTRA_MAIN...20700
C|  *   | iterative |   +3*NBCN+6*NOBS    |  +NSOU+2*NBCN+NOBS  |   *  | SUTRA_MAIN...20800
C|  *   | solver(s) |   +2*NSCH+NWF+220   |    +3*NSCH+NWI+2    |   *  | SUTRA_MAIN...20900
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...21000
C|  *   | 3D,       | (2*NBI+27)*NN+45*NE |  NN+9*NE+NSOP+NSOU  |   *  | SUTRA_MAIN...21100
C|  *   | direct    |    +3*NBCN+6*NOBS   |    +2*NBCN+NOBS     |   *  | SUTRA_MAIN...21200
C|  *   | solver    |      +2*NSCH+8      |      +3*NSCH+4      |   *  | SUTRA_MAIN...21300
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...21400
C|  *   | 3D,       | 2*NELT+28*NN+45*NE  | NELT+2*NN+9*NE+NSOP |   *  | SUTRA_MAIN...21500
C|  *   | iterative |   +3*NBCN+6*NOBS    |  +NSOU+2*NBCN+NOBS  |   *  | SUTRA_MAIN...21600
C|  *   | solver(s) |   +2*NSCH+NWF+6     |    +3*NSCH+NWI+2    |   *  | SUTRA_MAIN...21700
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...21800
C|  *                                                               *  | SUTRA_MAIN...21900
C|  *               |---------------------|---------------------|   *  | SUTRA_MAIN...22000
C|  *               |  sum of character   |  sum of dimensions  |   *  | SUTRA_MAIN...22100
C|  *               |   array effective   |     of arrays of    |   *  | SUTRA_MAIN...22200
C|  *               |     dimensions      |       pointers      |   *  | SUTRA_MAIN...22300
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...22400
C|  *   | all cases |  73*NOBS + 89*NSCH  |        2*NSCH       |   *  | SUTRA_MAIN...22500
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...22600
C|  *                                                               *  | SUTRA_MAIN...22700
C|  *   Quantities in the tables above are defined in Section 7.3   *  | SUTRA_MAIN...22800
C|  *   of the published documentation (Voss & Provost, 2002,       *  | SUTRA_MAIN...22900
C|  *   USGS Water-Resources Investigations Report 02-4231,         *  | SUTRA_MAIN...23000
C|  *   Version of June 2, 2008).                                   *  | SUTRA_MAIN...23100
C|  *                                                               *  | SUTRA_MAIN...23200
C|  *   During each run, SUTRA writes memory usage information to   *  | SUTRA_MAIN...23300
C|  *   the LST output file.                                        *  | SUTRA_MAIN...23400
C|  *                                                               *  | SUTRA_MAIN...23500
C|  *****************************************************************  | SUTRA_MAIN...23600
C|_____________________________________________________________________| SUTRA_MAIN...23700
C                                                                        SUTRA_MAIN...23800
C                                                                        SUTRA_MAIN...23900
C_______________________________________________________________________ SUTRA_MAIN...24000
C|                                                                     | SUTRA_MAIN...24100
C|  *****************************************************************  | SUTRA_MAIN...24200
C|  *                                                               *  | SUTRA_MAIN...24300
C|  *   ***********  F I L E   A S S I G N M E N T S  ***********   *  | SUTRA_MAIN...24400
C|  *                                                               *  | SUTRA_MAIN...24500
C|  *   Unit K0 contains the FORTRAN unit number and filename       *  | SUTRA_MAIN...24600
C|  *   assignments for the various SUTRA input and output files.   *  | SUTRA_MAIN...24700
C|  *   Each line of Unit K0 begins with a file type, followed by   *  | SUTRA_MAIN...24800
C|  *   a unit number and a filename for that type, all in free     *  | SUTRA_MAIN...24900
C|  *   format. Permitted file types are INP, ICS, LST, RST, NOD,   *  | SUTRA_MAIN...25000
C|  *   ELE, OBS, OBC, and SMY. Assignments may be listed in any    *  | SUTRA_MAIN...25100
C|  *   order.  Example ("#" indicates a comment):                  *  | SUTRA_MAIN...25200
C|  *   'INP'  50  'project.inp'   # required                       *  | SUTRA_MAIN...25300
C|  *   'ICS'  55  'project.ics'   # required                       *  | SUTRA_MAIN...25400
C|  *   'LST'  60  'project.lst'   # required                       *  | SUTRA_MAIN...25500
C|  *   'RST'  66  'project.rst'   # required if ISTORE>0           *  | SUTRA_MAIN...25600
C|  *   'NOD'  70  'project.nod'   # optional                       *  | SUTRA_MAIN...25700
C|  *   'ELE'  80  'project.ele'   # optional                       *  | SUTRA_MAIN...25800
C|  *   'OBS'  90  'project.obs'   # optional                       *  | SUTRA_MAIN...25900
C|  *   'OBC'  90  'project.obc'   # optional                       *  | SUTRA_MAIN...26000
C|  *   'SMY'  40  'project.smy'   # optional; defaults to          *  | SUTRA_MAIN...26100
C|  *                              #           filename="SUTRA.SMY" *  | SUTRA_MAIN...26200
C|  *                                                               *  | SUTRA_MAIN...26300
C|  *   Note that the filenames for types OBS and OBC are actually  *  | SUTRA_MAIN...26400
C|  *   root names from which SUTRA will automatically generate     *  | SUTRA_MAIN...26500
C|  *   observation output filenames based on the combinations of   *  | SUTRA_MAIN...26600
C|  *   schedules and output formats that appear in the observation *  | SUTRA_MAIN...26700
C|  *   specifications.  If a unit number of zero is specified for  *  | SUTRA_MAIN...26800
C|  *   a file, SUTRA will automatically assign a valid unit number *  | SUTRA_MAIN...26900
C|  *   to that file.                                               *  | SUTRA_MAIN...27000
C|  *                                                               *  | SUTRA_MAIN...27100
C|  *****************************************************************  | SUTRA_MAIN...27200
C|_____________________________________________________________________| SUTRA_MAIN...27300
C                                                                        SUTRA_MAIN...27400
C.....SET FILENAME AND FORTRAN UNIT NUMBER FOR UNIT K0                   SUTRA_MAIN...27500
c rbw begin change
      IERRORCODE = 0
      IErrorFlag = 0
c rbw end change
      UNAME = 'SUTRA.FIL'                                                SUTRA_MAIN...27600
      K0 = 10                                                            SUTRA_MAIN...27700
C.....INITIALIZE "INSERT" FILE COUNTERS                                  SUTRA_MAIN...27800
      NKS(1) = 0                                                         SUTRA_MAIN...27900
      NKS(2) = 0                                                         SUTRA_MAIN...28000
C.....INITIALIZE NFLOMX TO ZERO NOW IN CASE TERMINATION SEQUENCE IS      SUTRA_MAIN...28100
C        CALLED BEFORE NFLOMX GETS SET.                                  SUTRA_MAIN...28200
      NFLOMX = 0                                                         SUTRA_MAIN...28300
C.....ASSIGN UNIT NUMBERS AND OPEN FILE UNITS FOR THIS SIMULATION,       SUTRA_MAIN...28400
C        EXCEPT OBSERVATION OUTPUT FILES.                                SUTRA_MAIN...28500
      ONCEFO = .FALSE.                                                   SUTRA_MAIN...28600
c rbw begin change
!      CALL FOPEN()                                                       SUTRA_MAIN...28700
      CALL FOPEN(InputFile)                                                       SUTRA_MAIN...28700
      if (IErrorFlag.ne.0) then
        IERRORCODE = IErrorFlag
        goto 1000
      endif
c rbw end change
C.....STORE INP AND ICS FILENAMES FOR LATER REFERENCE, SINCE THE         SUTRA_MAIN...28800
C        CORRESPONDING ENTRIES IN FNAME MAY BE OVERWRITTEN BY FILE       SUTRA_MAIN...28900
C        INSERTION.                                                      SUTRA_MAIN...29000
      FNINP = FNAME(1)                                                   SUTRA_MAIN...29100
      FNICS = FNAME(2)                                                   SUTRA_MAIN...29200
C                                                                        SUTRA_MAIN...29300
C                                                                        SUTRA_MAIN...29400
C.....OUTPUT BANNER                                                      SUTRA_MAIN...29500
c rbw begin change
!      WRITE(K3,110) TRIM(VERNUM)                                         SUTRA_MAIN...29600
! 1 110 FORMAT('1',131('*')////3(132('*')////)////                         SUTRA_MAIN...29700
!     1   47X,' SSSS   UU  UU  TTTTTT  RRRRR     AA  '/                   SUTRA_MAIN...29800
c     2   47X,'SS   S  UU  UU  T TT T  RR  RR   AAAA '/                   SUTRA_MAIN...29900
c     3   47X,'SSSS    UU  UU    TT    RRRRR   AA  AA'/                   SUTRA_MAIN...30000
c     4   47X,'    SS  UU  UU    TT    RR R    AAAAAA'/                   SUTRA_MAIN...30100
c     5   47X,'SS  SS  UU  UU    TT    RR RR   AA  AA'/                   SUTRA_MAIN...30200
c     6   47X,' SSSS    UUUU     TT    RR  RR  AA  AA'/                   SUTRA_MAIN...30300
c     7   7(/),37X,'U N I T E D    S T A T E S   ',                       SUTRA_MAIN...30400
c     8   'G E O L O G I C A L   S U R V E Y'////                         SUTRA_MAIN...30500
c     9   45X,'SUBSURFACE FLOW AND TRANSPORT SIMULATION MODEL'/           SUTRA_MAIN...30600
c     *   //58X,'-SUTRA VERSION ',A,'-'///                                SUTRA_MAIN...30700
c     A   36X,'*  SATURATED-UNSATURATED FLOW AND SOLUTE OR ENERGY',       SUTRA_MAIN...30800
c     B   ' TRANSPORT  *'////4(////132('*')))                             SUTRA_MAIN...30900
c rbw end change
C                                                                        SUTRA_MAIN...31000
C_______________________________________________________________________ SUTRA_MAIN...31100
C|                                                                     | SUTRA_MAIN...31200
C|  *****************************************************************  | SUTRA_MAIN...31300
C|  *                                                               *  | SUTRA_MAIN...31400
C|  *   *********  R E A D I N G   I N P U T   D A T A  *********   *  | SUTRA_MAIN...31500
C|  *   *********  A N D   E R R O R   H A N D L I N G  *********   *  | SUTRA_MAIN...31600
C|  *                                                               *  | SUTRA_MAIN...31700
C|  *   SUTRA typically reads input data line by line as follows.   *  | SUTRA_MAIN...31800
C|  *   Subroutine READIF is called to skip over any comment        *  | SUTRA_MAIN...31900
C|  *   lines and read a single line of input data (up to 1000      *  | SUTRA_MAIN...32000
C|  *   characters) into internal file INTFIL. The input data       *  | SUTRA_MAIN...32100
C|  *   are then read from INTFIL. In case of an error, subroutine  *  | SUTRA_MAIN...32200
C|  *   SUTERR is called to report it, and control passes to the    *  | SUTRA_MAIN...32300
C|  *   termination sequence in subroutine TERSEQ.  The variable    *  | SUTRA_MAIN...32400
C|  *   ERRCOD is used to identify the nature of the error and is   *  | SUTRA_MAIN...32500
C|  *   set prior to calling READIF. The variables CHERR, INERR,    *  | SUTRA_MAIN...32600
C|  *   and RLERR can be used to send character, integer, or real   *  | SUTRA_MAIN...32700
C|  *   error information to subroutine SUTERR.                     *  | SUTRA_MAIN...32800
C|  *   Example from the main program:                              *  | SUTRA_MAIN...32900
C|  *                                                               *  | SUTRA_MAIN...33000
C|  *   ERRCOD = 'REA-INP-3'                                        *  | SUTRA_MAIN...33100
C|  *   CALL READIF(K1, INTFIL, ERRCOD)                             *  | SUTRA_MAIN...33200
C|  *   READ(INTFIL,*,IOSTAT=INERR(1)) NN,NE,NPBC,NUBC,             *  | SUTRA_MAIN...33300
C|  *  1   NSOP,NSOU,NOBS                                           *  | SUTRA_MAIN...33400
C|  *   IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR) *  | SUTRA_MAIN...33500
C|  *                                                               *  | SUTRA_MAIN...33600
C|  *****************************************************************  | SUTRA_MAIN...33700
C|_____________________________________________________________________| SUTRA_MAIN...33800
C                                                                        SUTRA_MAIN...33900
C.....INPUT DATASET 1:  OUTPUT HEADING                                   SUTRA_MAIN...34000
      ERRCOD = 'REA-INP-1'                                               SUTRA_MAIN...34100
      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...34200
c rbw begin change
      if (IErrorFlag.ne.0) then
        IERRORCODE = 146
        goto 1000
      endif
c rbw end change
      READ(INTFIL,117,IOSTAT=INERR(1)) TITLE1                            SUTRA_MAIN...34300
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...34400
      IF (INERR(1).NE.0) then
        IERRORCODE = 1
        goto 1000
      endif
c rbw end change
      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...34500
c rbw begin change
      if (IErrorFlag.ne.0) then
        IERRORCODE = 147
        goto 1000
      endif
c rbw end change
      READ(INTFIL,117,IOSTAT=INERR(1)) TITLE2                            SUTRA_MAIN...34600
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...34700
      IF (INERR(1).NE.0) then
        IERRORCODE = 2
        goto 1000
      endif
c rbw end change
  117 FORMAT(80A1)                                                       SUTRA_MAIN...34800
C                                                                        SUTRA_MAIN...34900
C.....INPUT DATASET 2A:  SIMULATION TYPE (TYPE OF TRANSPORT)             SUTRA_MAIN...35000
C        (SET ME=-1 FOR SOLUTE TRANSPORT, ME=+1 FOR ENERGY TRANSPORT)    SUTRA_MAIN...35100
      ERRCOD = 'REA-INP-2A'                                              SUTRA_MAIN...35200
      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...35300
c rbw begin change
      if (IErrorFlag.ne.0) then
        IERRORCODE = 148
        goto 1000
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) SIMSTR                              SUTRA_MAIN...35400
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...35500
      IF (INERR(1).NE.0) then
        IERRORCODE = 3
        goto 1000
      endif
c rbw end change
      CALL PRSWDS(SIMSTR, ' ', 5, SIMULA, NWORDS)                        SUTRA_MAIN...35600
c rbw begin change
c      IF(SIMULA(1).NE.'SUTRA     ') THEN                                 SUTRA_MAIN...35700
c         ERRCOD = 'INP-2A-1'                                             SUTRA_MAIN...35800
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...35900
c      END IF                                                             SUTRA_MAIN...36000
      IF(SIMULA(1).NE.'SUTRA     ') THEN
        IERRORCODE = 4
        goto 1000
      endif
c rbw end change
      IF (SIMULA(2).EQ.'VERSION   ') THEN                                SUTRA_MAIN...36100
         VERNIN = SIMULA(3)                                              SUTRA_MAIN...36200
         IF (VERNIN.EQ.'2D3D.1 ') THEN                                   SUTRA_MAIN...36300
            VERNIN = '2.0'                                               SUTRA_MAIN...36400
         ELSE IF ((VERNIN.NE.'2.0 ').AND.(VERNIN.NE.'2.1 ')) THEN        SUTRA_MAIN...36500
c rbw begin change
            IERRORCODE = 5
            goto 1000
c            ERRCOD = 'INP-2A-4'                                          SUTRA_MAIN...36600
c            CHERR(1) = VERNIN                                            SUTRA_MAIN...36700
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...36800
c rbw end change
         END IF                                                          SUTRA_MAIN...36900
         IOFF = 2                                                        SUTRA_MAIN...37000
      ELSE                                                               SUTRA_MAIN...37100
         VERNIN = '2.0'                                                  SUTRA_MAIN...37200
         IOFF = 0                                                        SUTRA_MAIN...37300
      END IF                                                             SUTRA_MAIN...37400
      IF(SIMULA(2+IOFF).EQ.'SOLUTE    ') GOTO 120                        SUTRA_MAIN...37500
      IF(SIMULA(2+IOFF).EQ.'ENERGY    ') GOTO 140                        SUTRA_MAIN...37600
      IF (IOFF.EQ.0) THEN                                                SUTRA_MAIN...37700
         ERRCOD = 'INP-2A-2'                                             SUTRA_MAIN...37800
      ELSE                                                               SUTRA_MAIN...37900
         ERRCOD = 'INP-2A-3'                                             SUTRA_MAIN...38000
      END IF                                                             SUTRA_MAIN...38100
c rbw begin change
      IERRORCODE = 6
      goto 1000
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           SUTRA_MAIN...38200
c rbw end change
  120 ME=-1                                                              SUTRA_MAIN...38300
c rbw begin change
c      WRITE(K3,130)                                                      SUTRA_MAIN...38400
c rbw end change
  130 FORMAT('1'//132('*')///20X,'* * * * *   S U T R A   S O L U ',     SUTRA_MAIN...38500
     1   'T E   T R A N S P O R T   S I M U L A T I O N   * * * * *'//   SUTRA_MAIN...38600
     2   /132('*')/)                                                     SUTRA_MAIN...38700
      GOTO 160                                                           SUTRA_MAIN...38800
  140 ME=+1                                                              SUTRA_MAIN...38900
c rbw begin change
c      WRITE(K3,150)                                                      SUTRA_MAIN...39000
c rbw end change
  150 FORMAT('1'//132('*')///20X,'* * * * *   S U T R A   E N E R ',     SUTRA_MAIN...39100
     1   'G Y   T R A N S P O R T   S I M U L A T I O N   * * * * *'//   SUTRA_MAIN...39200
     2   /132('*')/)                                                     SUTRA_MAIN...39300
  160 CONTINUE                                                           SUTRA_MAIN...39400
C                                                                        SUTRA_MAIN...39500
C.....INPUT DATASET 2B:  MESH STRUCTURE                                  SUTRA_MAIN...39600
      ERRCOD = 'REA-INP-2B'                                              SUTRA_MAIN...39700
      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...39800
c rbw begin change
      if (IErrorFlag.ne.0) then
        IERRORCODE = 149
        goto 1000
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR                              SUTRA_MAIN...39900
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...40000
      IF (INERR(1).NE.0) then
        IERRORCODE = 7
        goto 1000
      endif
c rbw end change
      CALL PRSWDS(MSHSTR, ' ', 2, MSHTYP, NWORDS)                        SUTRA_MAIN...40100
C.....KTYPE SET ACCORDING TO THE TYPE OF FINITE-ELEMENT MESH:            SUTRA_MAIN...40200
C        2D MESH          ==>   KTYPE(1) = 2                             SUTRA_MAIN...40300
C        3D MESH          ==>   KTYPE(1) = 3                             SUTRA_MAIN...40400
C        IRREGULAR MESH   ==>   KTYPE(2) = 0                             SUTRA_MAIN...40500
C        LAYERED MESH     ==>   KTYPE(2) = 1                             SUTRA_MAIN...40600
C        REGULAR MESH     ==>   KTYPE(2) = 2                             SUTRA_MAIN...40700
C        BLOCKWISE MESH   ==>   KTYPE(2) = 3                             SUTRA_MAIN...40800
      IF (MSHTYP(1).EQ.'2D        ') THEN                                SUTRA_MAIN...40900
         KTYPE(1) = 2                                                    SUTRA_MAIN...41000
      ELSE IF (MSHTYP(1).EQ.'3D        ') THEN                           SUTRA_MAIN...41100
         KTYPE(1) = 3                                                    SUTRA_MAIN...41200
      ELSE                                                               SUTRA_MAIN...41300
c rbw begin change
        IERRORCODE = 8
        goto 1000
c         ERRCOD = 'INP-2B-1'                                             SUTRA_MAIN...41400
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...41500
c rbw end change
      END IF                                                             SUTRA_MAIN...41600
      IF ((MSHTYP(2).EQ.'REGULAR   ').OR.                                SUTRA_MAIN...41700
     1    (MSHTYP(2).EQ.'BLOCKWISE ')) THEN                              SUTRA_MAIN...41800
         ERRCOD = 'REA-INP-2B'                                           SUTRA_MAIN...41900
         IF (KTYPE(1).EQ.2) THEN                                         SUTRA_MAIN...42000
            READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR, NN1, NN2              SUTRA_MAIN...42100
            NN3 = 1                                                      SUTRA_MAIN...42200
         ELSE                                                            SUTRA_MAIN...42300
            READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR, NN1, NN2, NN3         SUTRA_MAIN...42400
         END IF                                                          SUTRA_MAIN...42500
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SUTRA_MAIN...42600
         IF (INERR(1).NE.0) then
           IERRORCODE = 8
           goto 1000
         endif
c rbw end change
         IF ((NN1.LT.2).OR.(NN2.LT.2).OR.                                SUTRA_MAIN...42700
     1      ((KTYPE(1).EQ.3).AND.(NN3.LT.2))) THEN                       SUTRA_MAIN...42800
c rbw begin change
            IERRORCODE = 9
            goto 1000
!            ERRCOD = 'INP-2B-3'                                          SUTRA_MAIN...42900
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...43000
c rbw end change
         END IF                                                          SUTRA_MAIN...43100
         IF (MSHTYP(2).EQ.'BLOCKWISE ') THEN                             SUTRA_MAIN...43200
            KTYPE(2) = 3                                                 SUTRA_MAIN...43300
            ERRCOD = 'REA-INP-2B'                                        SUTRA_MAIN...43400
            DO 177 I1=1,KTYPE(1)                                         SUTRA_MAIN...43500
               CALL READIF(K1, INTFIL, ERRCOD)                           SUTRA_MAIN...43600
c rbw begin change
               if (IErrorFlag.ne.0) then
                 IERRORCODE = 150
                 goto 1000
               endif
c rbw end change
               READ(INTFIL,*,IOSTAT=INERR(1)) IDUM1, (IDUM2, I2=1,IDUM1) SUTRA_MAIN...43700
c rbw begin change
c               IF (INERR(1).NE.0) CALL SUTERR(ERRCOD,CHERR,INERR,RLERR)  SUTRA_MAIN...43800
               IF (INERR(1).NE.0) then
                 IERRORCODE = 9
                 goto 1000
               endif
c rbw end change
  177       CONTINUE                                                     SUTRA_MAIN...43900
         ELSE                                                            SUTRA_MAIN...44000
            KTYPE(2) = 2                                                 SUTRA_MAIN...44100
         END IF                                                          SUTRA_MAIN...44200
      ELSE IF (MSHTYP(2).EQ.'LAYERED   ') THEN                           SUTRA_MAIN...44300
         IF (KTYPE(1).EQ.2) THEN                                         SUTRA_MAIN...44400
c rbw begin change
            IERRORCODE = 10
            goto 1000
!            ERRCOD = 'INP-2B-5'                                          SUTRA_MAIN...44500
!            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...44600
c rbw end change
         END IF                                                          SUTRA_MAIN...44700
         KTYPE(2) = 1                                                    SUTRA_MAIN...44800
         ERRCOD = 'REA-INP-2B'                                           SUTRA_MAIN...44900
         READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR,NLAYS,NNLAY,NELAY,LAYSTR  SUTRA_MAIN...45000
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD,CHERR,INERR,RLERR)        SUTRA_MAIN...45100
         IF (INERR(1).NE.0) then
            IERRORCODE = 11
            goto 1000
         endif
c rbw end change
         CALL PRSWDS(LAYSTR, ' ', 1, LAYNOR, NWORDS)                     SUTRA_MAIN...45200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
         IF ((LAYNOR(1).NE.'ACROSS').AND.(LAYNOR(1).NE.'WITHIN')) THEN   SUTRA_MAIN...45300
c rbw begin change
            IERRORCODE = 12
            goto 1000
c            ERRCOD = 'INP-2B-6'                                          SUTRA_MAIN...45400
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...45500
c rbw end change
         END IF                                                          SUTRA_MAIN...45600
         IF ((NLAYS.LT.2).OR.(NNLAY.LT.4).OR.(NELAY.LT.1)) THEN          SUTRA_MAIN...45700
c rbw begin change
            IERRORCODE = 13
            goto 1000
c            ERRCOD = 'INP-2B-7'                                          SUTRA_MAIN...45800
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...45900
c rbw end change
         END IF                                                          SUTRA_MAIN...46000
      ELSE IF (MSHTYP(2).EQ.'IRREGULAR ') THEN                           SUTRA_MAIN...46100
         KTYPE(2) = 0                                                    SUTRA_MAIN...46200
      ELSE                                                               SUTRA_MAIN...46300
c rbw begin change
         IERRORCODE = 14
         goto 1000
c         ERRCOD = 'INP-2B-4'                                             SUTRA_MAIN...46400
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...46500
c rbw end change
      END IF                                                             SUTRA_MAIN...46600
C                                                                        SUTRA_MAIN...46700
C.....OUTPUT DATASET 1                                                   SUTRA_MAIN...46800
c rbw begin change
c      WRITE(K3,180) TITLE1,TITLE2                                        SUTRA_MAIN...46900
c rbw end change
  180 FORMAT(////1X,131('-')//26X,80A1//26X,80A1//1X,131('-'))           SUTRA_MAIN...47000
C                                                                        SUTRA_MAIN...47100
C.....OUTPUT FILE UNIT ASSIGNMENTS                                       SUTRA_MAIN...47200
c rbw begin change
c      WRITE(K3,202) IUNIT(1),FNINP,IUNIT(2),FNICS,IUNIT(0),FNAME(0),     SUTRA_MAIN...47300
c     1   IUNIT(3),FNAME(3)                                               SUTRA_MAIN...47400
c rbw end change
  202 FORMAT(/////11X,'F I L E   U N I T   A S S I G N M E N T S'//      SUTRA_MAIN...47500
     1   13X,'INPUT UNITS:'/                                             SUTRA_MAIN...47600
     2   13X,' INP FILE (MAIN INPUT)          ',I7,4X,                   SUTRA_MAIN...47700
     3      'ASSIGNED TO ',A80/                                          SUTRA_MAIN...47800
     4   13X,' ICS FILE (INITIAL CONDITIONS)  ',I7,4X,                   SUTRA_MAIN...47900
     5      'ASSIGNED TO ',A80//                                         SUTRA_MAIN...48000
     6   13X,'OUTPUT UNITS:'/                                            SUTRA_MAIN...48100
     7   13X,' SMY FILE (RUN SUMMARY)         ',I7,4X,                   SUTRA_MAIN...48200
     8      'ASSIGNED TO ',A80/                                          SUTRA_MAIN...48300
     9   13X,' LST FILE (GENERAL OUTPUT)      ',I7,4X,                   SUTRA_MAIN...48400
     T      'ASSIGNED TO ',A80)                                          SUTRA_MAIN...48500
c rbw begin change
c      IF(IUNIT(4).NE.-1) WRITE(K3,203) IUNIT(4),FNAME(4)                 SUTRA_MAIN...48600
c rbw end change
  203 FORMAT(13X,' RST FILE (RESTART DATA)        ',I7,4X,               SUTRA_MAIN...48700
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...48800
c rbw begin change
c      IF(IUNIT(5).NE.-1) WRITE(K3,204) IUNIT(5),FNAME(5)                 SUTRA_MAIN...48900
c rbw end change
  204 FORMAT(13X,' NOD FILE (NODEWISE OUTPUT)     ',I7,4X,               SUTRA_MAIN...49000
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...49100
c rbw begin change
c      IF(IUNIT(6).NE.-1) WRITE(K3,206) IUNIT(6),FNAME(6)                 SUTRA_MAIN...49200
c rbw end change
  206 FORMAT(13X,' ELE FILE (VELOCITY OUTPUT)     ',I7,4X,               SUTRA_MAIN...49300
     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...49400
c rbw begin change
c      IF(IUNIT(7).NE.-1) WRITE(K3,207) IUNIT(7),                         SUTRA_MAIN...49500
c     1   TRIM(FNAME(7)) // " (BASE FILENAME)"                            SUTRA_MAIN...49600
c rbw end change
  207 FORMAT(13X,' OBS FILE (OBSERVATION OUTPUT) (',I7,')',3X,           SUTRA_MAIN...49700
     1   'ASSIGNED TO ',A)                                               SUTRA_MAIN...49800
c rbw begin change
c      IF(IUNIT(8).NE.-1) WRITE(K3,208) IUNIT(8),                         SUTRA_MAIN...49900
c     1   TRIM(FNAME(8)) // " (BASE FILENAME)"                            SUTRA_MAIN...50000
c rbw end change
  208 FORMAT(13X,' OBC FILE (OBSERVATION OUTPUT) (',I7,')',3X,           SUTRA_MAIN...50100
     1   'ASSIGNED TO ',A)                                               SUTRA_MAIN...50200
c rbw begin change
c      WRITE(K3,209)                                                      SUTRA_MAIN...50300
c rbw end change
  209 FORMAT(/14X,'NAMES FOR OBS AND OBC FILES WILL BE GENERATED',       SUTRA_MAIN...50400
     1   ' AUTOMATICALLY FROM THE BASE NAMES LISTED ABOVE AND SCHEDULE', SUTRA_MAIN...50500
     2   ' NAMES'/14X,'LISTED LATER IN THIS FILE.  UNIT NUMBERS',        SUTRA_MAIN...50600
     3   ' ASSIGNED TO THESE FILES WILL BE THE FIRST AVAILABLE',         SUTRA_MAIN...50700
     4   ' NUMBERS GREATER THAN'/14X,'OR EQUAL TO THE VALUES LISTED',    SUTRA_MAIN...50800
     5   ' ABOVE IN PARENTHESES.')                                       SUTRA_MAIN...50900
C                                                                        SUTRA_MAIN...51000
C.....INPUT DATASET 3:  SIMULATION CONTROL NUMBERS                       SUTRA_MAIN...51100
      ERRCOD = 'REA-INP-3'                                               SUTRA_MAIN...51200
      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...51300
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = 151
           goto 1000
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS      SUTRA_MAIN...51400
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...51500
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
c rbw end
      IF (KTYPE(2).GT.1) THEN                                            SUTRA_MAIN...51600
         NN123 = NN1*NN2*NN3                                             SUTRA_MAIN...51700
         IF(NN123.NE.NN) THEN                                            SUTRA_MAIN...51800
c rbw begin change
           IERRORCODE = 15
           goto 1000
c           ERRCOD = 'INP-2B,3-1'                                         SUTRA_MAIN...51900
c           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...52000
c rbw end change
         END IF                                                          SUTRA_MAIN...52100
         IF (KTYPE(1).EQ.3) THEN                                         SUTRA_MAIN...52200
            NE123 = (NN1 - 1)*(NN2 - 1)*(NN3 - 1)                        SUTRA_MAIN...52300
         ELSE                                                            SUTRA_MAIN...52400
            NE123 = (NN1 - 1)*(NN2 - 1)                                  SUTRA_MAIN...52500
         END IF                                                          SUTRA_MAIN...52600
         IF(NE123.NE.NE) THEN                                            SUTRA_MAIN...52700
c rbw begin change
           IERRORCODE = 16
           goto 1000
c           ERRCOD = 'INP-2B,3-2'                                         SUTRA_MAIN...52800
c           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...52900
c rbw end change
         END IF                                                          SUTRA_MAIN...53000
      ELSE IF (MSHTYP(2).EQ.'LAYERED   ') THEN                           SUTRA_MAIN...53100
         NNTOT = NLAYS*NNLAY                                             SUTRA_MAIN...53200
         IF(NNTOT.NE.NN) THEN                                            SUTRA_MAIN...53300
c rbw begin change
           IERRORCODE = 17
           goto 1000
c           ERRCOD = 'INP-2B,3-3'                                         SUTRA_MAIN...53400
c           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...53500
c rbw end change
         END IF                                                          SUTRA_MAIN...53600
         NETOT = (NLAYS - 1)*NELAY                                       SUTRA_MAIN...53700
         IF(NETOT.NE.NE) THEN                                            SUTRA_MAIN...53800
c rbw begin change
           IERRORCODE = 17
           goto 1000
c           ERRCOD = 'INP-2B,3-4'                                         SUTRA_MAIN...53900
c           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...54000
c rbw end change
         END IF                                                          SUTRA_MAIN...54100
      ENDIF                                                              SUTRA_MAIN...54200
C                                                                        SUTRA_MAIN...54300
C.....INPUT AND OUTPUT DATASET 4:  SIMULATION MODE OPTIONS               SUTRA_MAIN...54400
      ERRCOD = 'REA-INP-4'                                               SUTRA_MAIN...54500
      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...54600
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = 152
           goto 1000
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) UNSSTR,SSFSTR,SSTSTR,RDSTR,ISTORE   SUTRA_MAIN...54700
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...54800
      IF (INERR(1).NE.0) then
           IERRORCODE = 18
           goto 1000
      endif
c rbw end change
      CALL PRSWDS(UNSSTR, ' ', 1, CUNSAT, NWORDS)                        SUTRA_MAIN...54900
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL PRSWDS(SSFSTR, ' ', 1, CSSFLO, NWORDS)                        SUTRA_MAIN...55000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL PRSWDS(SSTSTR, ' ', 1, CSSTRA, NWORDS)                        SUTRA_MAIN...55100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL PRSWDS(RDSTR,  ' ', 1, CREAD, NWORDS)                         SUTRA_MAIN...55200
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      ISMERR = 0                                                         SUTRA_MAIN...55300
      IF (CUNSAT.EQ.'UNSATURATED') THEN                                  SUTRA_MAIN...55400
         IUNSAT = +1                                                     SUTRA_MAIN...55500
      ELSE IF (CUNSAT.EQ.'SATURATED') THEN                               SUTRA_MAIN...55600
         IUNSAT = 0                                                      SUTRA_MAIN...55700
      ELSE                                                               SUTRA_MAIN...55800
c rbw begin change
         IERRORCODE = 19
         goto 1000
c         ERRCOD = 'INP-4-1'                                              SUTRA_MAIN...55900
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...56000
c rbw end change
      END IF                                                             SUTRA_MAIN...56100
      IF (CSSFLO.EQ.'TRANSIENT') THEN                                    SUTRA_MAIN...56200
         ISSFLO = 0                                                      SUTRA_MAIN...56300
      ELSE IF (CSSFLO.EQ.'STEADY') THEN                                  SUTRA_MAIN...56400
         ISSFLO = +1                                                     SUTRA_MAIN...56500
      ELSE                                                               SUTRA_MAIN...56600
c rbw begin change
         IERRORCODE = 20
         goto 1000
c         ERRCOD = 'INP-4-2'                                              SUTRA_MAIN...56700
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...56800
c rbw end change
      END IF                                                             SUTRA_MAIN...56900
      IF (CSSTRA.EQ.'TRANSIENT') THEN                                    SUTRA_MAIN...57000
         ISSTRA = 0                                                      SUTRA_MAIN...57100
      ELSE IF (CSSTRA.EQ.'STEADY') THEN                                  SUTRA_MAIN...57200
         ISSTRA = +1                                                     SUTRA_MAIN...57300
      ELSE                                                               SUTRA_MAIN...57400
c rbw begin change
         IERRORCODE = 21
         goto 1000
c         ERRCOD = 'INP-4-3'                                              SUTRA_MAIN...57500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...57600
c rbw end change
      END IF                                                             SUTRA_MAIN...57700
      IF (CREAD.EQ.'COLD') THEN                                          SUTRA_MAIN...57800
         IREAD = +1                                                      SUTRA_MAIN...57900
      ELSE IF (CREAD.EQ.'WARM') THEN                                     SUTRA_MAIN...58000
         IREAD = -1                                                      SUTRA_MAIN...58100
      ELSE                                                               SUTRA_MAIN...58200
c rbw begin change
         IERRORCODE = 22
         goto 1000
c         ERRCOD = 'INP-4-4'                                              SUTRA_MAIN...58300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...58400
c rbw end change
      END IF                                                             SUTRA_MAIN...58500
c rbw begin change
c      WRITE(K3,210)                                                      SUTRA_MAIN...58600
c rbw end change
  210 FORMAT(////11X,'S I M U L A T I O N   M O D E   ',                 SUTRA_MAIN...58700
     1   'O P T I O N S'/)                                               SUTRA_MAIN...58800
      IF(ISSTRA.EQ.1.AND.ISSFLO.NE.1) THEN                               SUTRA_MAIN...58900
c rbw begin change
         IERRORCODE = 23
         goto 1000
c         ERRCOD = 'INP-4-5'                                              SUTRA_MAIN...59000
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...59100
c rbw end change
      ENDIF                                                              SUTRA_MAIN...59200
c rbw begin change
c      IF(IUNSAT.EQ.+1) WRITE(K3,215)                                     SUTRA_MAIN...59300
c      IF(IUNSAT.EQ.0) WRITE(K3,216)                                      SUTRA_MAIN...59400
c rbw end change
  215 FORMAT(11X,'- ALLOW UNSATURATED AND SATURATED FLOW:  UNSATURATED', SUTRA_MAIN...59500
     1   ' PROPERTIES ARE USER-PROGRAMMED IN SUBROUTINE   U N S A T')    SUTRA_MAIN...59600
  216 FORMAT(11X,'- ASSUME SATURATED FLOW ONLY')                         SUTRA_MAIN...59700
c rbw begin change
c      IF(ISSFLO.EQ.+1.AND.ME.EQ.-1) WRITE(K3,219)                        SUTRA_MAIN...59800
c      IF(ISSFLO.EQ.+1.AND.ME.EQ.+1) WRITE(K3,220)                        SUTRA_MAIN...59900
c      IF(ISSFLO.EQ.0) WRITE(K3,221)                                      SUTRA_MAIN...60000
c rbw end change
  219 FORMAT(11X,'- ASSUME STEADY-STATE FLOW FIELD CONSISTENT WITH ',    SUTRA_MAIN...60100
     1   'INITIAL CONCENTRATION CONDITIONS')                             SUTRA_MAIN...60200
  220 FORMAT(11X,'- ASSUME STEADY-STATE FLOW FIELD CONSISTENT WITH ',    SUTRA_MAIN...60300
     1   'INITIAL TEMPERATURE CONDITIONS')                               SUTRA_MAIN...60400
  221 FORMAT(11X,'- ALLOW TIME-DEPENDENT FLOW FIELD')                    SUTRA_MAIN...60500
c rbw begin change
c      IF(ISSTRA.EQ.+1) WRITE(K3,225)                                     SUTRA_MAIN...60600
c      IF(ISSTRA.EQ.0) WRITE(K3,226)                                      SUTRA_MAIN...60700
c rbw end change
  225 FORMAT(11X,'- ASSUME STEADY-STATE TRANSPORT')                      SUTRA_MAIN...60800
  226 FORMAT(11X,'- ALLOW TIME-DEPENDENT TRANSPORT')                     SUTRA_MAIN...60900
c rbw begin change
c      IF(IREAD.EQ.-1) WRITE(K3,230)                                      SUTRA_MAIN...61000
c      IF(IREAD.EQ.+1) WRITE(K3,231)                                      SUTRA_MAIN...61100
c rbw end change
  230 FORMAT(11X,'- WARM START - SIMULATION IS TO BE ',                  SUTRA_MAIN...61200
     1   'CONTINUED FROM PREVIOUSLY-STORED DATA')                        SUTRA_MAIN...61300
  231 FORMAT(11X,'- COLD START - BEGIN NEW SIMULATION')                  SUTRA_MAIN...61400
c rbw begin change
c      IF(ISTORE.GT.0) WRITE(K3,240) ISTORE                               SUTRA_MAIN...61500
c      IF(ISTORE.EQ.0) WRITE(K3,241)                                      SUTRA_MAIN...61600
c rbw end change
  240 FORMAT(11X,'- STORE RESULTS AFTER EVERY',I9,' TIME STEPS IN',      SUTRA_MAIN...61700
     1   ' RESTART FILE AS BACKUP AND FOR USE IN A SIMULATION RESTART')  SUTRA_MAIN...61800
  241 FORMAT(11X,'- DO NOT STORE RESULTS FOR USE IN A',                  SUTRA_MAIN...61900
     1   ' RESTART OF SIMULATION')                                       SUTRA_MAIN...62000
C.....OUTPUT DATASET 3                                                   SUTRA_MAIN...62100
c rbw begin change
c      IF(ME.EQ.-1)                                                       SUTRA_MAIN...62200
c     1   WRITE(K3,245) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS                    SUTRA_MAIN...62300
c rbw end change
  245 FORMAT(////11X,'S I M U L A T I O N   C O N T R O L   ',           SUTRA_MAIN...62400
     1   'N U M B E R S'// 8X,I9,5X,'NUMBER OF NODES IN FINITE-',        SUTRA_MAIN...62500
     2   'ELEMENT MESH'/ 8X,I9,5X,'NUMBER OF ELEMENTS IN MESH'//         SUTRA_MAIN...62600
     3    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...62700
     4   'PRESSURE IS A SPECIFIED CONSTANT OR FUNCTION OF TIME'/         SUTRA_MAIN...62800
     5    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...62900
     6   'SOLUTE CONCENTRATION IS A SPECIFIED CONSTANT OR ',             SUTRA_MAIN...63000
     7   'FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES AT',       SUTRA_MAIN...63100
     8   ' WHICH FLUID INFLOW OR OUTFLOW IS A SPECIFIED CONSTANT',       SUTRA_MAIN...63200
     9   ' OR FUNCTION OF TIME'/ 8X,I9,5X,'EXACT NUMBER OF NODES AT',    SUTRA_MAIN...63300
     A   ' WHICH A SOURCE OR SINK OF SOLUTE MASS IS A SPECIFIED ',       SUTRA_MAIN...63400
     B   'CONSTANT OR FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF ',   SUTRA_MAIN...63500
     C   'NODES AT WHICH PRESSURE AND CONCENTRATION WILL BE OBSERVED')   SUTRA_MAIN...63600
C                                                                        SUTRA_MAIN...63700
c rbw begin change
c      IF(ME.EQ.+1)                                                       SUTRA_MAIN...63800
c     1    WRITE(K3,247) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS                   SUTRA_MAIN...63900
c rbw end change
  247 FORMAT(////11X,'S I M U L A T I O N   C O N T R O L   ',           SUTRA_MAIN...64000
     1   'N U M B E R S'// 8X,I9,5X,'NUMBER OF NODES IN FINITE-',        SUTRA_MAIN...64100
     2   'ELEMENT MESH'/ 8X,I9,5X,'NUMBER OF ELEMENTS IN MESH'//         SUTRA_MAIN...64200
     3    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...64300
     4   'PRESSURE IS A SPECIFIED CONSTANT OR FUNCTION OF TIME'/         SUTRA_MAIN...64400
     5    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...64500
     6   'TEMPERATURE IS A SPECIFIED CONSTANT OR ',                      SUTRA_MAIN...64600
     7   'FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES AT',       SUTRA_MAIN...64700
     8   ' WHICH FLUID INFLOW OR OUTFLOW IS A SPECIFIED CONSTANT',       SUTRA_MAIN...64800
     9   ' OR FUNCTION OF TIME'/ 8X,I9,5X,'EXACT NUMBER OF NODES AT',    SUTRA_MAIN...64900
     A   ' WHICH A SOURCE OR SINK OF ENERGY IS A SPECIFIED CONSTANT',    SUTRA_MAIN...65000
     B   ' OR FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES ',     SUTRA_MAIN...65100
     C   'AT WHICH PRESSURE AND TEMPERATURE WILL BE OBSERVED')           SUTRA_MAIN...65200
C                                                                        SUTRA_MAIN...65300
C.....INPUT DATASETS 5 - 7 (NUMERICAL, TEMPORAL, AND ITERATION CONTROLS) SUTRA_MAIN...65400
      CALL INDAT0()                                                      SUTRA_MAIN...65500
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C.....KSOLVP AND KSOLVU HAVE BEEN SET ACCORDING TO THE SOLVERS SELECTED: SUTRA_MAIN...65600
C        BANDED GAUSSIAN ELIMINATION (DIRECT)   ==>   0                  SUTRA_MAIN...65700
C        IC-PRECONDITIONED CG                   ==>   1                  SUTRA_MAIN...65800
C        ILU-PRECONDITIONED GMRES               ==>   2                  SUTRA_MAIN...65900
C        ILU-PRECONDITIONED ORTHOMIN            ==>   3                  SUTRA_MAIN...66000
C                                                                        SUTRA_MAIN...66100
C.....OUTPUT DATASETS 7B & 7C                                            SUTRA_MAIN...66200
c rbw begin change
c      WRITE(K3,261)                                                      SUTRA_MAIN...66300
c rbw end change
  261 FORMAT(////11X,'S O L V E R - R E L A T E D   ',                   SUTRA_MAIN...66400
     1   'P A R A M E T E R S')                                          SUTRA_MAIN...66500
C.....OUTPUT DATASETS 3B & 3C                                            SUTRA_MAIN...66600
c rbw begin change
c  266 IF (KSOLVP.NE.0) THEN                                              SUTRA_MAIN...66700
c         WRITE(K3,268)                                                   SUTRA_MAIN...66800
c     1      SOLNAM(KSOLVP), ITRMXP, TOLP,                                SUTRA_MAIN...66900
c     2      SOLNAM(KSOLVU), ITRMXU, TOLU                                 SUTRA_MAIN...67000
c rbw end change
  268    FORMAT(                                                         SUTRA_MAIN...67100
     1      /13X,'SOLVER FOR P: ',A40                                    SUTRA_MAIN...67200
     2      //20X,I6,5X,'MAXIMUM NUMBER OF MATRIX SOLVER ITERATIONS',    SUTRA_MAIN...67300
     3           ' DURING P SOLUTION'                                    SUTRA_MAIN...67400
     4      /11X,1PE15.4,5X,'CONVERGENCE TOLERANCE FOR MATRIX',          SUTRA_MAIN...67500
     5           ' SOLVER ITERATIONS DURING P SOLUTION'                  SUTRA_MAIN...67600
     6      //13X,'SOLVER FOR U: ',A40                                   SUTRA_MAIN...67700
     7      //20X,I6,5X,'MAXIMUM NUMBER OF MATRIX SOLVER ITERATIONS',    SUTRA_MAIN...67800
     8           ' DURING U SOLUTION'                                    SUTRA_MAIN...67900
     9      /11X,1PE15.4,5X,'CONVERGENCE TOLERANCE FOR MATRIX',          SUTRA_MAIN...68000
     A           ' SOLVER ITERATIONS DURING U SOLUTION' )                SUTRA_MAIN...68100
c rbw begin change
c      ELSE                                                               SUTRA_MAIN...68200
c         WRITE(K3,269) SOLNAM(KSOLVP)                                    SUTRA_MAIN...68300
c  269    FORMAT(/13X,'SOLVER FOR P AND U: ',A40)                         SUTRA_MAIN...68400
c      END IF                                                             SUTRA_MAIN...68500
c rbw end change
C                                                                        SUTRA_MAIN...68600
C.....CALCULATE ARRAY DIMENSIONS, EXCEPT THOSE THAT DEPEND ON            SUTRA_MAIN...68700
C        BANDWIDTH OR NELT                                               SUTRA_MAIN...68800
C                                                                        SUTRA_MAIN...68900
      IF (KSOLVP.EQ.0) THEN                                              SUTRA_MAIN...69000
C........SET DIMENSIONS FOR DIRECT SOLVER                                SUTRA_MAIN...69100
         NNNX = 1                                                        SUTRA_MAIN...69200
         NDIMJA = 1                                                      SUTRA_MAIN...69300
         NNVEC = NN                                                      SUTRA_MAIN...69400
      ELSE                                                               SUTRA_MAIN...69500
C........SET DIMENSIONS FOR ITERATIVE SOLVER(S)                          SUTRA_MAIN...69600
         NNNX = NN                                                       SUTRA_MAIN...69700
         NDIMJA = NN + 1                                                 SUTRA_MAIN...69800
         NNVEC = NN                                                      SUTRA_MAIN...69900
      END IF                                                             SUTRA_MAIN...70000
      NBCN=NPBC+NUBC+1                                                   SUTRA_MAIN...70100
      NSOP=NSOP+1                                                        SUTRA_MAIN...70200
      NSOU=NSOU+1                                                        SUTRA_MAIN...70300
      NOBSN=NOBS+1                                                       SUTRA_MAIN...70400
      IF (KTYPE(1).EQ.3) THEN                                            SUTRA_MAIN...70500
         N48 = 8                                                         SUTRA_MAIN...70600
         NEX = NE                                                        SUTRA_MAIN...70700
      ELSE                                                               SUTRA_MAIN...70800
         N48 = 4                                                         SUTRA_MAIN...70900
         NEX = 1                                                         SUTRA_MAIN...71000
      END IF                                                             SUTRA_MAIN...71100
      NIN=NE*N48                                                         SUTRA_MAIN...71200
C                                                                        SUTRA_MAIN...71300
C.....ALLOCATE REAL ARRAYS, EXCEPT THOSE THAT DEPEND ON BANDWIDTH        SUTRA_MAIN...71400
      ALLOCATE(PITER(NN),UITER(NN),PM1(NN),DPDTITR(NN),UM1(NN),UM2(NN),  SUTRA_MAIN...71500
     1   PVEL(NN),SL(NN),SR(NN),X(NN),Y(NN),Z(NN),VOL(NN),POR(NN),       SUTRA_MAIN...71600
     2   CS1(NN),CS2(NN),CS3(NN),SW(NN),DSWDP(NN),RHO(NN),SOP(NN),       SUTRA_MAIN...71700
     3   QIN(NN),UIN(NN),QUIN(NN),QINITR(NN),RCIT(NN),RCITM1(NN))        SUTRA_MAIN...71800
      ALLOCATE(PVEC(NNVEC),UVEC(NNVEC))                                  SUTRA_MAIN...71900
      ALLOCATE(ALMAX(NE),ALMIN(NE),ATMAX(NE),ATMIN(NE),VMAG(NE),         SUTRA_MAIN...72000
     1   VANG1(NE),PERMXX(NE),PERMXY(NE),PERMYX(NE),PERMYY(NE),          SUTRA_MAIN...72100
     2   PANGL1(NE))                                                     SUTRA_MAIN...72200
      ALLOCATE(ALMID(NEX),ATMID(NEX),                                    SUTRA_MAIN...72300
     1   VANG2(NEX),PERMXZ(NEX),PERMYZ(NEX),PERMZX(NEX),                 SUTRA_MAIN...72400
     2   PERMZY(NEX),PERMZZ(NEX),PANGL2(NEX),PANGL3(NEX))                SUTRA_MAIN...72500
      ALLOCATE(PBC(NBCN),UBC(NBCN),QPLITR(NBCN))                         SUTRA_MAIN...72600
      ALLOCATE(GXSI(NE,N48),GETA(NE,N48),GZET(NEX,N48))                  SUTRA_MAIN...72700
      ALLOCATE(B(NNNX))                                                  SUTRA_MAIN...72800
C.....ALLOCATE INTEGER ARRAYS, EXCEPT THOSE THAT DEPEND ON BANDWIDTH     SUTRA_MAIN...72900
C        OR NELT                                                         SUTRA_MAIN...73000
      ALLOCATE(IN(NIN),IQSOP(NSOP),IQSOU(NSOU),IPBC(NBCN),IUBC(NBCN),    SUTRA_MAIN...73100
     1   NREG(NN),LREG(NE),JA(NDIMJA))                                   SUTRA_MAIN...73200
C.....ALLOCATE ARRAYS OF DERIVED TYPE, EXCEPT THOSE THAT DEPEND ON       SUTRA_MAIN...73300
C        BANDWIDTH OR NELT                                               SUTRA_MAIN...73400
      ALLOCATE(OBSPTS(NOBSN))                                            SUTRA_MAIN...73500
      ALLO1 = .TRUE.                                                     SUTRA_MAIN...73600
C                                                                        SUTRA_MAIN...73700
C.....INPUT DATASETS 8 - 15 (OUTPUT CONTROLS; FLUID AND SOLID MATRIX     SUTRA_MAIN...73800
C        PROPERTIES; ADSORPTION PARAMETERS; PRODUCTION OF ENERGY OR      SUTRA_MAIN...73900
C        SOLUTE MASS; GRAVITY; AND NODEWISE AND ELEMENTWISE DATA)        SUTRA_MAIN...74000
c rbw begin change
c      CALL INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,         SUTRA_MAIN...74100
c     1   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,                      SUTRA_MAIN...74200
c     2   PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG,        SUTRA_MAIN...74300
c     3   OBSPTS)                                                         SUTRA_MAIN...74400
      CALL INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,         SUTRA_MAIN...74100
     1   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,                      SUTRA_MAIN...74200
     2   PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG,        SUTRA_MAIN...74300
     3   OBSPTS, InputFile)                                                         SUTRA_MAIN...74400
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...74500
C.....KEEP TRACK IF OUTPUT ROUTINES HAVE BEEN EXECUTED, TO PRINT         SUTRA_MAIN...74600
C        HEADERS ONLY ONCE.                                              SUTRA_MAIN...74700
      ONCEK5 = .FALSE.                                                   SUTRA_MAIN...74800
      ONCEK6 = .FALSE.                                                   SUTRA_MAIN...74900
      ONCEK7 = .FALSE.                                                   SUTRA_MAIN...75000
      ONCEK8 = .FALSE.                                                   SUTRA_MAIN...75100
      ALLOCATE(ONCK78(NFLOMX))                                           SUTRA_MAIN...75200
      DO 400 J=1,NFLOMX                                                  SUTRA_MAIN...75300
         ONCK78(J) = .FALSE.                                             SUTRA_MAIN...75400
  400 CONTINUE                                                           SUTRA_MAIN...75500
C                                                                        SUTRA_MAIN...75600
C.....INPUT DATASETS 17 & 18 (SOURCES OF FLUID MASS AND ENERGY OR        SUTRA_MAIN...75700
C        SOLUTE MASS)                                                    SUTRA_MAIN...75800
      CALL ZERO(QIN,NN,0.0D0)                                            SUTRA_MAIN...75900
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL ZERO(UIN,NN,0.0D0)                                            SUTRA_MAIN...76000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      CALL ZERO(QUIN,NN,0.0D0)                                           SUTRA_MAIN...76100
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      IF(NSOP-1.GT.0.OR.NSOU-1.GT.0)                                     SUTRA_MAIN...76200
     1   CALL SOURCE(QIN,UIN,IQSOP,QUIN,IQSOU,IQSOPT,IQSOUT)             SUTRA_MAIN...76300
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...76400
C.....INPUT DATASETS 19 & 20 (SPECIFIED P AND U BOUNDARY CONDITIONS)     SUTRA_MAIN...76500
      IF(NBCN-1.GT.0) CALL BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT)          SUTRA_MAIN...76600
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...76700
C.....INPUT DATASET 22 (ELEMENT INCIDENCE [MESH CONNECTION] DATA)        SUTRA_MAIN...76800
      CALL CONNEC(IN)                                                    SUTRA_MAIN...76900
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...77000
C.....IF USING OLD (VERSION 2D3D.1) OBSERVATION INPUT FORMAT, LOOK UP    SUTRA_MAIN...77100
C        COORDINATES FOR OBSERVATION POINTS (NODES).                     SUTRA_MAIN...77200
      IF (NOBCYC.NE.-1) THEN                                             SUTRA_MAIN...77300
         DO 710 K=1,NOBS                                                 SUTRA_MAIN...77400
            I = OBSPTS(K)%L                                              SUTRA_MAIN...77500
            OBSPTS(K)%X = X(I)                                           SUTRA_MAIN...77600
            OBSPTS(K)%Y = Y(I)                                           SUTRA_MAIN...77700
            IF (N48.EQ.8) OBSPTS(K)%Z = Z(I)                             SUTRA_MAIN...77800
  710    CONTINUE                                                        SUTRA_MAIN...77900
      END IF                                                             SUTRA_MAIN...78000
C                                                                        SUTRA_MAIN...78100
C.....FIND THE ELEMENT EACH OBSERVATION POINT IS IN.  IN COMPONENTS OF   SUTRA_MAIN...78200
C        OBSPTS, OVERWRITE NODE NUMBERS AND GLOBAL COORDINATES WITH      SUTRA_MAIN...78300
C        ELEMENT NUMBERS AND LOCAL COORDINATES.                          SUTRA_MAIN...78400
      DO 900 K=1,NOBS                                                    SUTRA_MAIN...78500
         XK = OBSPTS(K)%X                                                SUTRA_MAIN...78600
         YK = OBSPTS(K)%Y                                                SUTRA_MAIN...78700
         IF (N48.EQ.8) ZK = OBSPTS(K)%Z                                  SUTRA_MAIN...78800
         DO 800 LL=1,NE                                                  SUTRA_MAIN...78900
            IF (N48.EQ.8) THEN                                           SUTRA_MAIN...79000
               CALL FINDL3(X,Y,Z,IN,LL,XK,YK,ZK,XSI,ETA,ZET,INOUT)       SUTRA_MAIN...79100
c rbw begin change
               if (IErrorFlag.ne.0) then
                 IERRORCODE = IErrorFlag
                 goto 1000
               endif
c rbw end change
            ELSE                                                         SUTRA_MAIN...79200
               CALL FINDL2(X,Y,IN,LL,XK,YK,XSI,ETA,INOUT)                SUTRA_MAIN...79300
c rbw begin change
               if (IErrorFlag.ne.0) then
                 IERRORCODE = IErrorFlag
                 goto 1000
               endif
c rbw end change
            END IF                                                       SUTRA_MAIN...79400
            IF (INOUT.EQ.1) THEN                                         SUTRA_MAIN...79500
               L = LL                                                    SUTRA_MAIN...79600
               GOTO 820                                                  SUTRA_MAIN...79700
            END IF                                                       SUTRA_MAIN...79800
  800    CONTINUE                                                        SUTRA_MAIN...79900
         ERRCOD = 'INP-8D-3'                                             SUTRA_MAIN...80000
         CHERR(1) = OBSPTS(K)%NAME                                       SUTRA_MAIN...80100
c rbw begin change
c         WRITE(UNIT=CHERR(2), FMT=805)                                   SUTRA_MAIN...80200
c     1      OBSPTS(K)%X, OBSPTS(K)%Y, OBSPTS(K)%Z                        SUTRA_MAIN...80300
c rbw end change
  805    FORMAT('(',2(1PE14.7,','),1PE14.7,')')                          SUTRA_MAIN...80400
c rbw begin change
         IERRORCODE = 24
         goto 1000
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...80500
c rbw end change
  820    OBSPTS(K)%L = L                                                 SUTRA_MAIN...80600
         OBSPTS(K)%XSI = XSI                                             SUTRA_MAIN...80700
         OBSPTS(K)%ETA = ETA                                             SUTRA_MAIN...80800
         IF (N48.EQ.8) OBSPTS(K)%ZET = ZET                               SUTRA_MAIN...80900
  900 CONTINUE                                                           SUTRA_MAIN...81000
C                                                                        SUTRA_MAIN...81100
C.....IF ITERATIVE SOLVER IS USED, SET UP POINTER ARRAYS IA AND JA THAT  SUTRA_MAIN...81200
C        SPECIFY MATRIX STRUCTURE IN "SLAP COLUMN" FORMAT.  DIMENSION    SUTRA_MAIN...81300
C        NELT GETS SET HERE.                                             SUTRA_MAIN...81400
      IF (KSOLVP.NE.0) THEN                                              SUTRA_MAIN...81500
         CALL PTRSET()                                                   SUTRA_MAIN...81600
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
      ELSE                                                               SUTRA_MAIN...81700
         NELT = NN                                                       SUTRA_MAIN...81800
         NDIMIA = 1                                                      SUTRA_MAIN...81900
         ALLOCATE(IA(NDIMIA))                                            SUTRA_MAIN...82000
      END IF                                                             SUTRA_MAIN...82100
      ALLO3 = .TRUE.                                                     SUTRA_MAIN...82200
C                                                                        SUTRA_MAIN...82300
C.....CALCULATE BANDWIDTH                                                SUTRA_MAIN...82400
      CALL BANWID(IN)                                                    SUTRA_MAIN...82500
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
C                                                                        SUTRA_MAIN...82600
C.....CALCULATE ARRAY DIMENSIONS THAT DEPEND ON BANDWIDTH OR NELT        SUTRA_MAIN...82700
      IF (KSOLVP.EQ.0) THEN                                              SUTRA_MAIN...82800
C........SET DIMENSIONS FOR DIRECT SOLVER                                SUTRA_MAIN...82900
         NCBI = NBI                                                      SUTRA_MAIN...83000
         NELTA = NELT                                                    SUTRA_MAIN...83100
         NWI = 1                                                         SUTRA_MAIN...83200
         NWF = 1                                                         SUTRA_MAIN...83300
      ELSE                                                               SUTRA_MAIN...83400
C........SET DIMENSIONS FOR ITERATIVE SOLVER(S)                          SUTRA_MAIN...83500
         NCBI = 1                                                        SUTRA_MAIN...83600
         NELTA = NELT                                                    SUTRA_MAIN...83700
         KSOLVR = KSOLVP                                                 SUTRA_MAIN...83800
         NSAVE = NSAVEP                                                  SUTRA_MAIN...83900
         CALL DIMWRK(KSOLVR, NSAVE, NN, NELTA, NWIP, NWFP)               SUTRA_MAIN...84000
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
         KSOLVR = KSOLVU                                                 SUTRA_MAIN...84100
         NSAVE = NSAVEU                                                  SUTRA_MAIN...84200
         CALL DIMWRK(KSOLVR, NSAVE, NN, NELTA, NWIU, NWFU)               SUTRA_MAIN...84300
c rbw begin change
         if (IErrorFlag.ne.0) then
           IERRORCODE = IErrorFlag
           goto 1000
         endif
c rbw end change
         NWI = MAX(NWIP, NWIU)                                           SUTRA_MAIN...84400
         NWF = MAX(NWFP, NWFU)                                           SUTRA_MAIN...84500
      END IF                                                             SUTRA_MAIN...84600
      MATDIM=NELT*NCBI                                                   SUTRA_MAIN...84700
C                                                                        SUTRA_MAIN...84800
C.....ALLOCATE REAL AND INTEGER ARRAYS THAT DEPEND ON BANDWIDTH OR NELT  SUTRA_MAIN...84900
      ALLOCATE(PMAT(NELT,NCBI),UMAT(NELT,NCBI),FWK(NWF))                 SUTRA_MAIN...85000
      ALLOCATE(IWK(NWI))                                                 SUTRA_MAIN...85100
      ALLO2 = .TRUE.                                                     SUTRA_MAIN...85200
C                                                                        SUTRA_MAIN...85300
C.....INPUT INITIAL OR RESTART CONDITIONS FROM THE ICS FILE AND          SUTRA_MAIN...85400
C        INITIALIZE PARAMETERS                                           SUTRA_MAIN...85500
c rbw begin change
c      CALL INDAT2(PVEC,UVEC,PM1,UM1,UM2,CS1,CS2,CS3,SL,SR,RCIT,SW,DSWDP, SUTRA_MAIN...85600
c     1   PBC,IPBC,IPBCT,NREG,QIN,DPDTITR)                                SUTRA_MAIN...85700
      if (IErrorFlag.ne.0) then
        IERRORCODE = IErrorFlag
        goto 1000
      endif
      return
 1000 continue

C.....ARRAY IUNIO WILL BE DEALLOCATED AFTER THE OBSERVATION OUTPUT       TERSEQ........4400
C        FILES ARE CLOSED                                                TERSEQ........4500
      IF (ALLO1) THEN                                                    TERSEQ........1800
         DEALLOCATE(PITER,UITER,PM1,DPDTITR,UM1,UM2,PVEL,SL,SR,X,Y,Z,    TERSEQ........1900
     1      VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,QIN,UIN,QUIN,QINITR,    TERSEQ........2000
     2      RCIT,RCITM1)                                                 TERSEQ........2100
         DEALLOCATE(PVEC,UVEC)                                           TERSEQ........2200
         DEALLOCATE(ALMAX,ALMIN,ATMAX,ATMIN,VMAG,VANG1,PERMXX,PERMXY,    TERSEQ........2300
     1      PERMYX,PERMYY,PANGL1)                                        TERSEQ........2400
         DEALLOCATE(ALMID,ATMID,VANG2,PERMXZ,PERMYZ,PERMZX,PERMZY,       TERSEQ........2500
     1      PERMZZ,PANGL2,PANGL3)                                        TERSEQ........2600
         DEALLOCATE(PBC,UBC,QPLITR)                                      TERSEQ........2700
         DEALLOCATE(GXSI,GETA,GZET)                                      TERSEQ........2800
         DEALLOCATE(B)                                                   TERSEQ........2900
         DEALLOCATE(IN,IQSOP,IQSOU,IPBC,IUBC,NREG,LREG,JA)               TERSEQ........3000
         DEALLOCATE(OBSPTS)                                              TERSEQ........3100
      END IF                                                             TERSEQ........3200
      IF (ALLO2) THEN                                                    TERSEQ........3300
         DEALLOCATE(PMAT,UMAT,FWK)                                       TERSEQ........3400
         DEALLOCATE(IWK)                                                 TERSEQ........3500
      END IF                                                             TERSEQ........3600
      IF (ALLO3) THEN                                                    TERSEQ........3700
         DEALLOCATE(IA)                                                  TERSEQ........3800
      END IF                                                             TERSEQ........3900
      IF (ALLOCATED(SCHDLS)) DEALLOCATE(SCHDLS)                          TERSEQ........4000
      IF (ALLOCATED(OFP)) DEALLOCATE(OFP)                                TERSEQ........4100
      IF (ALLOCATED(FNAMO)) DEALLOCATE(FNAMO)                            TERSEQ........4200
      IF (ALLOCATED(ONCK78)) DEALLOCATE(ONCK78)                          TERSEQ........4300
C.....ARRAY IUNIO WILL BE DEALLOCATED AFTER THE OBSERVATION OUTPUT       TERSEQ........4400
      IF (ALLOCATED(IUNIO)) DEALLOCATE(IUNIO)                            TERSEQ........5900
      return
c rbw end change
C                                                                        SUTRA_MAIN...85800
C.....COMPUTE AND OUTPUT DIMENSIONS OF SIMULATION                        SUTRA_MAIN...85900
c rbw begin change
c      RMVDIM = 27*NN + 11*NE + 10*NEX + 3*NBCN + N48*(2*NE + NEX)        SUTRA_MAIN...86000
c     1   + NNNX + 2*NELT*NCBI + NWF + 6*NOBSN + 3*NSCH                   SUTRA_MAIN...86100
c      IMVDIM = NIN + NSOP + NSOU + 2*NBCN + NN + NE                      SUTRA_MAIN...86200
c     1   + NDIMJA + NDIMIA + NWI + NOBSN + 3*NSCH                        SUTRA_MAIN...86300
c      CMVDIM = 73*NOBS + 89*NSCH                                         SUTRA_MAIN...86400
c      PMVDIM = 2*NSCH                                                    SUTRA_MAIN...86500
c      TOTMB = (DBLE(RMVDIM)*8D0 + DBLE(IMVDIM)*4D0 + DBLE(CMVDIM))/1D6   SUTRA_MAIN...86600
c      WRITE(K3,3000) RMVDIM, IMVDIM, CMVDIM, PMVDIM, TOTMB               SUTRA_MAIN...86700
 3000 FORMAT(////11X,'S I M U L A T I O N   D I M E N S I O N S'//       SUTRA_MAIN...86800
     1   13X,'REAL        ARRAYS WERE ALLOCATED ',I12/                   SUTRA_MAIN...86900
     2   13X,'INTEGER     ARRAYS WERE ALLOCATED ',I12/                   SUTRA_MAIN...87000
     3   13X,'CHARACTER   ARRAYS WERE ALLOCATED ',I12,                   SUTRA_MAIN...87100
     4       ' (SUM OF ARRAY_DIMENSION*CHARACTER_LENGTH)'/               SUTRA_MAIN...87200
     5   13X,'ARRAYS OF POINTERS WERE ALLOCATED ',I12//                  SUTRA_MAIN...87300
     6   13X,F10.3,' Mbytes MEMORY USED FOR MAIN ARRAYS'/                SUTRA_MAIN...87400
     7   13X,'- assuming 1 byte/character'/                              SUTRA_MAIN...87500
     8   13X,'- pointer storage not included')                           SUTRA_MAIN...87600
C                                                                        SUTRA_MAIN...87700
c      WRITE(K3,4000)                                                     SUTRA_MAIN...87800
 4000 FORMAT(////////8(132("-")/))                                       SUTRA_MAIN...87900
C                                                                        SUTRA_MAIN...88000
C.....CALL MAIN CONTROL ROUTINE, SUTRA                                   SUTRA_MAIN...88100
c      CALL SUTRA(TITLE1,TITLE2,PMAT,UMAT,PITER,UITER,PM1,DPDTITR,        SUTRA_MAIN...88200
c     1   UM1,UM2,PVEL,SL,SR,X,Y,Z,VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,  SUTRA_MAIN...88300
c     2   QIN,UIN,QUIN,QINITR,RCIT,RCITM1,PVEC,UVEC,                      SUTRA_MAIN...88400
c     3   ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,VMAG,VANG1,VANG2,           SUTRA_MAIN...88500
c     4   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ, SUTRA_MAIN...88600
c     5   PANGL1,PANGL2,PANGL3,PBC,UBC,QPLITR,GXSI,GETA,GZET,FWK,B,       SUTRA_MAIN...88700
c     6   IN,IQSOP,IQSOU,IPBC,IUBC,OBSPTS,NREG,LREG,IWK,IA,JA,            SUTRA_MAIN...88800
c     7   IQSOPT,IQSOUT,IPBCT,IUBCT)                                      SUTRA_MAIN...88900
C                                                                        SUTRA_MAIN...89000
C.....TERMINATION SEQUENCE: DEALLOCATE ARRAYS, CLOSE FILES, AND END      SUTRA_MAIN...89100
c9000  CONTINUE                                                           SUTRA_MAIN...89200
c      CALL TERSEQ()                                                      SUTRA_MAIN...89300
c rbw end change
      END                                                                SUTRA_MAIN...89400
C                                                                        SUTRA_MAIN...89500
C     SUBROUTINE        A  D  S  O  R  B           SUTRA VERSION 2.1     ADSORB.........100
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
     1   NSOP,NSOU,NBCN                                                  ADSORB........1200
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
C     SUBROUTINE        B  A  N  W  I  D           SUTRA VERSION 2.1     BANWID.........100
C                                                                        BANWID.........200
C *** PURPOSE :                                                          BANWID.........300
C ***  TO CALCULATE THE BANDWIDTH OF THE FINITE ELEMENT MESH.            BANWID.........400
C                                                                        BANWID.........500
      SUBROUTINE BANWID(IN)                                              BANWID.........600
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BANWID.........700
      CHARACTER*80 UNAME,FNAME(0:8)                                      BANWID.........800
      DIMENSION IN(NIN)                                                  BANWID.........900
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BANWID........1000
     1   NSOP,NSOU,NBCN                                                  BANWID........1100
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        BANWID........1200
      COMMON /FNAMES/ UNAME,FNAME                                        BANWID........1300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     BANWID........1400
      COMMON /SOLVI/ KSOLVP, KSOLVU, NN1, NN2, NN3                       BANWID........1500
C                                                                        BANWID........1600
      NDIF=0                                                             BANWID........1700
      II=0                                                               BANWID........1800
c rbw begin change
c      WRITE(K3,100)                                                      BANWID........1900
c rbw end change
  100 FORMAT(////11X,'**** MESH ANALYSIS ****'//)                        BANWID........2000
C                                                                        BANWID........2100
C.....FIND ELEMENT WITH MAXIMUM DIFFERENCE IN NODE NUMBERS               BANWID........2200
      DO 2000 L=1,NE                                                     BANWID........2300
      II=II+1                                                            BANWID........2400
      IELO=IN(II)                                                        BANWID........2500
      IEHI=IN(II)                                                        BANWID........2600
      DO 1000 I=2,N48                                                    BANWID........2700
      II=II+1                                                            BANWID........2800
      IF(IN(II).LT.IELO) IELO=IN(II)                                     BANWID........2900
 1000 IF(IN(II).GT.IEHI) IEHI=IN(II)                                     BANWID........3000
      NDIFF=IEHI-IELO                                                    BANWID........3100
      IF(NDIFF.GT.NDIF) THEN                                             BANWID........3200
       NDIF=NDIFF                                                        BANWID........3300
       LEM=L                                                             BANWID........3400
      ENDIF                                                              BANWID........3500
 2000 CONTINUE                                                           BANWID........3600
C                                                                        BANWID........3700
C.....CALCULATE FULL BANDWIDTH, NB.                                      BANWID........3800
      NB=2*NDIF+1                                                        BANWID........3900
      NBHALF=NDIF+1                                                      BANWID........4000
C.....NBI IS USED TO DIMENSION ARRAYS WHOSE SIZE DEPENDS ON THE          BANWID........4100
C        BANDWIDTH.  IT IS THE SAME AS THE ACTUAL BANDWIDTH, NB.         BANWID........4200
      NBI = NB                                                           BANWID........4300
c rbw begin change
c      WRITE(K3,2500) NB,LEM                                              BANWID........4400
c rbw end change
 2500 FORMAT(//13X,'MAXIMUM FULL BANDWIDTH, ',I9,                        BANWID........4500
     1   ', WAS CALCULATED IN ELEMENT ',I9)                              BANWID........4600
C                                                                        BANWID........4700
      RETURN                                                             BANWID........4800
      END                                                                BANWID........4900
C                                                                        BANWID........5000
C     SUBROUTINE        B  A  S  I  S  2           SUTRA VERSION 2.1     BASIS2.........100
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
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             BASIS2........2700
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BASIS2........2800
     1   NSOP,NSOU,NBCN                                                  BASIS2........2900
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      BASIS2........3000
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        BASIS2........3100
      DATA XIIX/-1.D0,+1.D0,+1.D0,-1.D0/,                                BASIS2........3200
     1     YIIY/-1.D0,-1.D0,+1.D0,+1.D0/                                 BASIS2........3300
      SAVE XIIX,YIIY                                                     BASIS2........3400
C                                                                        BASIS2........3500
C                                                                        BASIS2........3600
C.....AT THIS LOCATION IN LOCAL COORDINATES, (XLOC,YLOC),                BASIS2........3700
C        CALCULATE SYMMETRIC WEIGHTING FUNCTIONS, F(I),                  BASIS2........3800
C        SPACE DERIVATIVES, DFDXG(I) AND DFDYG(I), AND                   BASIS2........3900
C        DETERMINANT OF JACOBIAN, DET.                                   BASIS2........4000
C                                                                        BASIS2........4100
      XF1=1.D0-XLOC                                                      BASIS2........4200
      XF2=1.D0+XLOC                                                      BASIS2........4300
      YF1=1.D0-YLOC                                                      BASIS2........4400
      YF2=1.D0+YLOC                                                      BASIS2........4500
C                                                                        BASIS2........4600
C.....CALCULATE BASIS FUNCTION, F.                                       BASIS2........4700
      FX(1)=XF1                                                          BASIS2........4800
      FX(2)=XF2                                                          BASIS2........4900
      FX(3)=XF2                                                          BASIS2........5000
      FX(4)=XF1                                                          BASIS2........5100
      FY(1)=YF1                                                          BASIS2........5200
      FY(2)=YF1                                                          BASIS2........5300
      FY(3)=YF2                                                          BASIS2........5400
      FY(4)=YF2                                                          BASIS2........5500
      DO 10 I=1,4                                                        BASIS2........5600
   10 F(I)=0.250D0*FX(I)*FY(I)                                           BASIS2........5700
C                                                                        BASIS2........5800
C.....CALCULATE DERIVATIVES WITH RESPECT TO LOCAL COORDINATES.           BASIS2........5900
      DO 20 I=1,4                                                        BASIS2........6000
      DFDXL(I)=XIIX(I)*0.250D0*FY(I)                                     BASIS2........6100
   20 DFDYL(I)=YIIY(I)*0.250D0*FX(I)                                     BASIS2........6200
C                                                                        BASIS2........6300
C.....CALCULATE ELEMENTS OF JACOBIAN MATRIX, CJ.                         BASIS2........6400
      CJ11=0.D0                                                          BASIS2........6500
      CJ12=0.D0                                                          BASIS2........6600
      CJ21=0.D0                                                          BASIS2........6700
      CJ22=0.D0                                                          BASIS2........6800
      DO 100 IL=1,4                                                      BASIS2........6900
      II=(L-1)*4+IL                                                      BASIS2........7000
      I=IN(II)                                                           BASIS2........7100
      CJ11=CJ11+DFDXL(IL)*X(I)                                           BASIS2........7200
      CJ12=CJ12+DFDXL(IL)*Y(I)                                           BASIS2........7300
      CJ21=CJ21+DFDYL(IL)*X(I)                                           BASIS2........7400
  100 CJ22=CJ22+DFDYL(IL)*Y(I)                                           BASIS2........7500
C                                                                        BASIS2........7600
C.....CALCULATE DETERMINANT OF JACOBIAN MATRIX.                          BASIS2........7700
      DET=CJ11*CJ22-CJ21*CJ12                                            BASIS2........7800
C                                                                        BASIS2........7900
C.....RETURN TO ELEMEN2 WITH JACOBIAN MATRIX ON FIRST TIME STEP.         BASIS2........8000
      IF(ICALL.EQ.0) RETURN                                              BASIS2........8100
C                                                                        BASIS2........8200
C.....CALCULATE ELEMENTS OF INVERSE JACOBIAN MATRIX, CIJ.                BASIS2........8300
      ODET=1.D0/DET                                                      BASIS2........8400
      CIJ11=+ODET*CJ22                                                   BASIS2........8500
      CIJ12=-ODET*CJ12                                                   BASIS2........8600
      CIJ21=-ODET*CJ21                                                   BASIS2........8700
      CIJ22=+ODET*CJ11                                                   BASIS2........8800
C                                                                        BASIS2........8900
C.....CALCULATE DERIVATIVES WITH RESPECT TO GLOBAL COORDINATES           BASIS2........9000
      DO 200 I=1,4                                                       BASIS2........9100
      DFDXG(I)=CIJ11*DFDXL(I)+CIJ12*DFDYL(I)                             BASIS2........9200
  200 DFDYG(I)=CIJ21*DFDXL(I)+CIJ22*DFDYL(I)                             BASIS2........9300
C                                                                        BASIS2........9400
C.....CALCULATE CONSISTENT COMPONENTS OF (RHO*GRAV) TERM IN LOCAL        BASIS2........9500
C        COORDINATES AT THIS LOCATION, (XLOC,YLOC)                       BASIS2........9600
      RGXL=0.D0                                                          BASIS2........9700
      RGYL=0.D0                                                          BASIS2........9800
      RGXLM1=0.D0                                                        BASIS2........9900
      RGYLM1=0.D0                                                        BASIS2.......10000
      DO 800 IL=1,4                                                      BASIS2.......10100
      II=(L-1)*4+IL                                                      BASIS2.......10200
      I=IN(II)                                                           BASIS2.......10300
      ADFDXL=DABS(DFDXL(IL))                                             BASIS2.......10400
      ADFDYL=DABS(DFDYL(IL))                                             BASIS2.......10500
      RGXL=RGXL+RCIT(I)*GXSI(L,IL)*ADFDXL                                BASIS2.......10600
      RGYL=RGYL+RCIT(I)*GETA(L,IL)*ADFDYL                                BASIS2.......10700
      RGXLM1=RGXLM1+RCITM1(I)*GXSI(L,IL)*ADFDXL                          BASIS2.......10800
      RGYLM1=RGYLM1+RCITM1(I)*GETA(L,IL)*ADFDYL                          BASIS2.......10900
  800 CONTINUE                                                           BASIS2.......11000
C                                                                        BASIS2.......11100
C.....TRANSFORM CONSISTENT COMPONENTS OF (RHO*GRAV) TERM TO              BASIS2.......11200
C        GLOBAL COORDINATES                                              BASIS2.......11300
      RGXG=CIJ11*RGXL+CIJ12*RGYL                                         BASIS2.......11400
      RGYG=CIJ21*RGXL+CIJ22*RGYL                                         BASIS2.......11500
      RGXGM1=CIJ11*RGXLM1+CIJ12*RGYLM1                                   BASIS2.......11600
      RGYGM1=CIJ21*RGXLM1+CIJ22*RGYLM1                                   BASIS2.......11700
C                                                                        BASIS2.......11800
C.....CALCULATE PARAMETER VALUES AT THIS LOCATION, (XLOC,YLOC)           BASIS2.......11900
      PITERG=0.D0                                                        BASIS2.......12000
      UITERG=0.D0                                                        BASIS2.......12100
      DPDXG=0.D0                                                         BASIS2.......12200
      DPDYG=0.D0                                                         BASIS2.......12300
      PORG=0.D0                                                          BASIS2.......12400
      THICKG=0.0D0                                                       BASIS2.......12500
      DO 1000 IL=1,4                                                     BASIS2.......12600
      II=(L-1)*4 +IL                                                     BASIS2.......12700
      I=IN(II)                                                           BASIS2.......12800
      DPDXG=DPDXG+PVEL(I)*DFDXG(IL)                                      BASIS2.......12900
      DPDYG=DPDYG+PVEL(I)*DFDYG(IL)                                      BASIS2.......13000
      PORG=PORG+POR(I)*F(IL)                                             BASIS2.......13100
      THICKG=THICKG+THICK(I)*F(IL)                                       BASIS2.......13200
      PITERG=PITERG+PITER(I)*F(IL)                                       BASIS2.......13300
      UITERG=UITERG+UITER(I)*F(IL)                                       BASIS2.......13400
 1000 CONTINUE                                                           BASIS2.......13500
C                                                                        BASIS2.......13600
C.....SET VALUES FOR DENSITY AND VISCOSITY.                              BASIS2.......13700
C.....RHOG = FUNCTION(UITER)                                             BASIS2.......13800
      RHOG=RHOW0+DRWDU*(UITERG-URHOW0)                                   BASIS2.......13900
C.....VISCG = FUNCTION(UITER); VISCOSITY IN UNITS OF VISC0*(KG/(M*SEC))  BASIS2.......14000
      IF(ME) 1300,1300,1200                                              BASIS2.......14100
 1200 VISCG=VISC0*239.4D-7*(10.D0**(248.37D0/(UITERG+133.15D0)))         BASIS2.......14200
      GOTO 1400                                                          BASIS2.......14300
C.....FOR SOLUTE TRANSPORT, VISCG IS TAKEN TO BE CONSTANT                BASIS2.......14400
 1300 VISCG=VISC0                                                        BASIS2.......14500
 1400 CONTINUE                                                           BASIS2.......14600
C                                                                        BASIS2.......14700
C.....SET UNSATURATED FLOW PARAMETERS SWG AND RELKG                      BASIS2.......14800
      IF(IUNSAT-2) 1600,1500,1600                                        BASIS2.......14900
 1500 IF(PITERG) 1550,1600,1600                                          BASIS2.......15000
 1550 CALL UNSAT(SWG,DSWDPG,RELKG,PITERG,LREG(L))                        BASIS2.......15100
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      GOTO 1700                                                          BASIS2.......15200
 1600 SWG=1.0D0                                                          BASIS2.......15300
      RELKG=1.0D0                                                        BASIS2.......15400
 1700 CONTINUE                                                           BASIS2.......15500
C                                                                        BASIS2.......15600
C.....CALCULATE CONSISTENT FLUID VELOCITIES WITH RESPECT TO GLOBAL       BASIS2.......15700
C        COORDINATES, VXG, VYG, AND VGMAG, AT THIS LOCATION, (XLOC,YLOC) BASIS2.......15800
      DENOM=1.D0/(PORG*SWG*VISCG)                                        BASIS2.......15900
      PGX=DPDXG-RGXGM1                                                   BASIS2.......16000
      PGY=DPDYG-RGYGM1                                                   BASIS2.......16100
C.....ZERO OUT RANDOM BOUYANT DRIVING FORCES DUE TO DIFFERENCING         BASIS2.......16200
C        NUMBERS PAST PRECISION LIMIT.  MINIMUM DRIVING FORCE IS         BASIS2.......16300
C        1.D-10 OF PRESSURE GRADIENT.  (THIS VALUE MAY BE CHANGED        BASIS2.......16400
C        DEPENDING ON MACHINE PRECISION.)                                BASIS2.......16500
      IF(DPDXG) 1720,1730,1720                                           BASIS2.......16600
 1720 IF(DABS(PGX/DPDXG)-1.0D-10) 1725,1725,1730                         BASIS2.......16700
 1725 PGX=0.0D0                                                          BASIS2.......16800
 1730 IF(DPDYG) 1750,1760,1750                                           BASIS2.......16900
 1750 IF(DABS(PGY/DPDYG)-1.0D-10) 1755,1755,1760                         BASIS2.......17000
 1755 PGY=0.0D0                                                          BASIS2.......17100
 1760 VXG=-DENOM*(PERMXX(L)*PGX+PERMXY(L)*PGY)*RELKG                     BASIS2.......17200
      VYG=-DENOM*(PERMYX(L)*PGX+PERMYY(L)*PGY)*RELKG                     BASIS2.......17300
      VXG2=VXG*VXG                                                       BASIS2.......17400
      VYG2=VYG*VYG                                                       BASIS2.......17500
      VGMAG=DSQRT(VXG2+VYG2)                                             BASIS2.......17600
C                                                                        BASIS2.......17700
C.....AT THIS POINT IN LOCAL COORDINATES, (XLOC,YLOC),                   BASIS2.......17800
C        CALCULATE ASYMMETRIC WEIGHTING FUNCTIONS, W(I),                 BASIS2.......17900
C        AND SPACE DERIVATIVES, DWDXG(I) AND DWDYG(I).                   BASIS2.......18000
C                                                                        BASIS2.......18100
C.....ASYMMETRIC FUNCTIONS SIMPLIFY WHEN  UP=0.0                         BASIS2.......18200
      IF(UP.GT.1.0D-6.AND.NOUMAT.EQ.0) GOTO 1790                         BASIS2.......18300
      DO 1780 I=1,4                                                      BASIS2.......18400
      W(I)=F(I)                                                          BASIS2.......18500
      DWDXG(I)=DFDXG(I)                                                  BASIS2.......18600
      DWDYG(I)=DFDYG(I)                                                  BASIS2.......18700
 1780 CONTINUE                                                           BASIS2.......18800
C.....RETURN WHEN ONLY SYMMETRIC WEIGHTING FUNCTIONS ARE USED            BASIS2.......18900
      RETURN                                                             BASIS2.......19000
C                                                                        BASIS2.......19100
C.....CALCULATE FLUID VELOCITIES WITH RESPECT TO LOCAL COORDINATES,      BASIS2.......19200
C        VXL, VYL, AND VLMAG, AT THIS LOCATION, (XLOC,YLOC).             BASIS2.......19300
 1790 VXL=CIJ11*VXG+CIJ21*VYG                                            BASIS2.......19400
      VYL=CIJ12*VXG+CIJ22*VYG                                            BASIS2.......19500
      VLMAG=DSQRT(VXL*VXL+VYL*VYL)                                       BASIS2.......19600
C                                                                        BASIS2.......19700
      AA=0.0D0                                                           BASIS2.......19800
      BB=0.0D0                                                           BASIS2.......19900
      IF(VLMAG) 1900,1900,1800                                           BASIS2.......20000
 1800 AA=UP*VXL/VLMAG                                                    BASIS2.......20100
      BB=UP*VYL/VLMAG                                                    BASIS2.......20200
C                                                                        BASIS2.......20300
 1900 XIXI=.750D0*AA*XF1*XF2                                             BASIS2.......20400
      YIYI=.750D0*BB*YF1*YF2                                             BASIS2.......20500
      DO 2000 I=1,4                                                      BASIS2.......20600
      AFX(I)=.50D0*FX(I)+XIIX(I)*XIXI                                    BASIS2.......20700
 2000 AFY(I)=.50D0*FY(I)+YIIY(I)*YIYI                                    BASIS2.......20800
C                                                                        BASIS2.......20900
C.....CALCULATE ASYMMETRIC WEIGHTING FUNCTION, W.                        BASIS2.......21000
      DO 3000 I=1,4                                                      BASIS2.......21100
 3000 W(I)=AFX(I)*AFY(I)                                                 BASIS2.......21200
C                                                                        BASIS2.......21300
      THAAX=0.50D0-1.50D0*AA*XLOC                                        BASIS2.......21400
      THBBY=0.50D0-1.50D0*BB*YLOC                                        BASIS2.......21500
      DO 4000 I=1,4                                                      BASIS2.......21600
      XDW(I)=XIIX(I)*THAAX                                               BASIS2.......21700
 4000 YDW(I)=YIIY(I)*THBBY                                               BASIS2.......21800
C                                                                        BASIS2.......21900
C.....CALCULATE DERIVATIVES WITH RESPECT TO LOCAL COORDINATES.           BASIS2.......22000
      DO 5000 I=1,4                                                      BASIS2.......22100
      DWDXL(I)=XDW(I)*AFY(I)                                             BASIS2.......22200
 5000 DWDYL(I)=YDW(I)*AFX(I)                                             BASIS2.......22300
C                                                                        BASIS2.......22400
C.....CALCULATE DERIVATIVES WITH RESPECT TO GLOBAL COORDINATES.          BASIS2.......22500
      DO 6000 I=1,4                                                      BASIS2.......22600
      DWDXG(I)=CIJ11*DWDXL(I)+CIJ12*DWDYL(I)                             BASIS2.......22700
 6000 DWDYG(I)=CIJ21*DWDXL(I)+CIJ22*DWDYL(I)                             BASIS2.......22800
C                                                                        BASIS2.......22900
C                                                                        BASIS2.......23000
      RETURN                                                             BASIS2.......23100
      END                                                                BASIS2.......23200
C                                                                        BASIS2.......23300
C     SUBROUTINE        B  A  S  I  S  3           SUTRA VERSION 2.1     BASIS3.........100
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
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             BASIS3........3100
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BASIS3........3200
     1   NSOP,NSOU,NBCN                                                  BASIS3........3300
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      BASIS3........3400
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        BASIS3........3500
      DATA XIIX/-1.D0,+1.D0,+1.D0,-1.D0,-1.D0,+1.D0,+1.D0,-1.D0/         BASIS3........3600
      DATA YIIY/-1.D0,-1.D0,+1.D0,+1.D0,-1.D0,-1.D0,+1.D0,+1.D0/         BASIS3........3700
      DATA ZIIZ/-1.D0,-1.D0,-1.D0,-1.D0,+1.D0,+1.D0,+1.D0,+1.D0/         BASIS3........3800
      SAVE XIIX,YIIY,ZIIZ                                                BASIS3........3900
C                                                                        BASIS3........4000
C                                                                        BASIS3........4100
C.....AT THIS LOCATION IN LOCAL COORDINATES, (XLOC,YLOC,ZLOC),           BASIS3........4200
C        CALCULATE SYMMETRIC WEIGHTING FUNCTIONS, F(I),                  BASIS3........4300
C        SPACE DERIVATIVES, DFDXG(I), DFDYX(I), AND DFDZG(I),            BASIS3........4400
C        AND DETERMINANT OF JACOBIAN, DET.                               BASIS3........4500
C                                                                        BASIS3........4600
      XF1=1.D0-XLOC                                                      BASIS3........4700
      XF2=1.D0+XLOC                                                      BASIS3........4800
      YF1=1.D0-YLOC                                                      BASIS3........4900
      YF2=1.D0+YLOC                                                      BASIS3........5000
      ZF1=1.D0-ZLOC                                                      BASIS3........5100
      ZF2=1.D0+ZLOC                                                      BASIS3........5200
C                                                                        BASIS3........5300
C.....CALCULATE BASIS FUNCTION, F.                                       BASIS3........5400
      FX(1)=XF1                                                          BASIS3........5500
      FX(2)=XF2                                                          BASIS3........5600
      FX(3)=XF2                                                          BASIS3........5700
      FX(4)=XF1                                                          BASIS3........5800
      FX(5)=XF1                                                          BASIS3........5900
      FX(6)=XF2                                                          BASIS3........6000
      FX(7)=XF2                                                          BASIS3........6100
      FX(8)=XF1                                                          BASIS3........6200
      FY(1)=YF1                                                          BASIS3........6300
      FY(2)=YF1                                                          BASIS3........6400
      FY(3)=YF2                                                          BASIS3........6500
      FY(4)=YF2                                                          BASIS3........6600
      FY(5)=YF1                                                          BASIS3........6700
      FY(6)=YF1                                                          BASIS3........6800
      FY(7)=YF2                                                          BASIS3........6900
      FY(8)=YF2                                                          BASIS3........7000
      FZ(1)=ZF1                                                          BASIS3........7100
      FZ(2)=ZF1                                                          BASIS3........7200
      FZ(3)=ZF1                                                          BASIS3........7300
      FZ(4)=ZF1                                                          BASIS3........7400
      FZ(5)=ZF2                                                          BASIS3........7500
      FZ(6)=ZF2                                                          BASIS3........7600
      FZ(7)=ZF2                                                          BASIS3........7700
      FZ(8)=ZF2                                                          BASIS3........7800
      DO 10 I=1,8                                                        BASIS3........7900
   10 F(I)=0.125D0*FX(I)*FY(I)*FZ(I)                                     BASIS3........8000
C                                                                        BASIS3........8100
C.....CALCULATE DERIVATIVES WITH RESPECT TO LOCAL COORDINATES.           BASIS3........8200
      DO 20 I=1,8                                                        BASIS3........8300
      DFDXL(I)=XIIX(I)*0.125D0*FY(I)*FZ(I)                               BASIS3........8400
      DFDYL(I)=YIIY(I)*0.125D0*FX(I)*FZ(I)                               BASIS3........8500
   20 DFDZL(I)=ZIIZ(I)*0.125D0*FX(I)*FY(I)                               BASIS3........8600
C                                                                        BASIS3........8700
C.....CALCULATE ELEMENTS OF JACOBIAN MATRIX, CJ.                         BASIS3........8800
      CJ11=0.D0                                                          BASIS3........8900
      CJ12=0.D0                                                          BASIS3........9000
      CJ13=0.D0                                                          BASIS3........9100
      CJ21=0.D0                                                          BASIS3........9200
      CJ22=0.D0                                                          BASIS3........9300
      CJ23=0.D0                                                          BASIS3........9400
      CJ31=0.D0                                                          BASIS3........9500
      CJ32=0.D0                                                          BASIS3........9600
      CJ33=0.D0                                                          BASIS3........9700
      DO 100 IL=1,8                                                      BASIS3........9800
      II=(L-1)*8+IL                                                      BASIS3........9900
      I=IN(II)                                                           BASIS3.......10000
      CJ11=CJ11+DFDXL(IL)*X(I)                                           BASIS3.......10100
      CJ12=CJ12+DFDXL(IL)*Y(I)                                           BASIS3.......10200
      CJ13=CJ13+DFDXL(IL)*Z(I)                                           BASIS3.......10300
      CJ21=CJ21+DFDYL(IL)*X(I)                                           BASIS3.......10400
      CJ22=CJ22+DFDYL(IL)*Y(I)                                           BASIS3.......10500
      CJ23=CJ23+DFDYL(IL)*Z(I)                                           BASIS3.......10600
      CJ31=CJ31+DFDZL(IL)*X(I)                                           BASIS3.......10700
      CJ32=CJ32+DFDZL(IL)*Y(I)                                           BASIS3.......10800
  100 CJ33=CJ33+DFDZL(IL)*Z(I)                                           BASIS3.......10900
C                                                                        BASIS3.......11000
C.....CALCULATE DETERMINANT OF JACOBIAN MATRIX.                          BASIS3.......11100
      DET=CJ11*(CJ22*CJ33-CJ32*CJ23)                                     BASIS3.......11200
     1   -CJ21*(CJ12*CJ33-CJ32*CJ13)                                     BASIS3.......11300
     2   +CJ31*(CJ12*CJ23-CJ22*CJ13)                                     BASIS3.......11400
C                                                                        BASIS3.......11500
C.....RETURN TO ELEMEN3 WITH JACOBIAN MATRIX ON FIRST TIME STEP.         BASIS3.......11600
      IF(ICALL.EQ.0) RETURN                                              BASIS3.......11700
C                                                                        BASIS3.......11800
C                                                                        BASIS3.......11900
C.....CALCULATE ELEMENTS OF INVERSE JACOBIAN MATRIX, CIJ.                BASIS3.......12000
      ODET=1.D0/DET                                                      BASIS3.......12100
      CIJ11=+ODET*(CJ22*CJ33-CJ32*CJ23)                                  BASIS3.......12200
      CIJ12=-ODET*(CJ12*CJ33-CJ32*CJ13)                                  BASIS3.......12300
      CIJ13=+ODET*(CJ12*CJ23-CJ22*CJ13)                                  BASIS3.......12400
      CIJ21=-ODET*(CJ21*CJ33-CJ31*CJ23)                                  BASIS3.......12500
      CIJ22=+ODET*(CJ11*CJ33-CJ31*CJ13)                                  BASIS3.......12600
      CIJ23=-ODET*(CJ11*CJ23-CJ21*CJ13)                                  BASIS3.......12700
      CIJ31=+ODET*(CJ21*CJ32-CJ31*CJ22)                                  BASIS3.......12800
      CIJ32=-ODET*(CJ11*CJ32-CJ31*CJ12)                                  BASIS3.......12900
      CIJ33=+ODET*(CJ11*CJ22-CJ21*CJ12)                                  BASIS3.......13000
C                                                                        BASIS3.......13100
C.....CALCULATE DERIVATIVES WITH RESPECT TO GLOBAL COORDINATES           BASIS3.......13200
      DO 200 I=1,8                                                       BASIS3.......13300
      DFDXG(I)=CIJ11*DFDXL(I)+CIJ12*DFDYL(I)+CIJ13*DFDZL(I)              BASIS3.......13400
      DFDYG(I)=CIJ21*DFDXL(I)+CIJ22*DFDYL(I)+CIJ23*DFDZL(I)              BASIS3.......13500
  200 DFDZG(I)=CIJ31*DFDXL(I)+CIJ32*DFDYL(I)+CIJ33*DFDZL(I)              BASIS3.......13600
C                                                                        BASIS3.......13700
C.....CALCULATE CONSISTENT COMPONENTS OF (RHO*GRAV) TERM IN LOCAL        BASIS3.......13800
C        COORDINATES AT THIS LOCATION, (XLOC,YLOC,ZLOC)                  BASIS3.......13900
      RGXL=0.D0                                                          BASIS3.......14000
      RGYL=0.D0                                                          BASIS3.......14100
      RGZL=0.D0                                                          BASIS3.......14200
      RGXLM1=0.D0                                                        BASIS3.......14300
      RGYLM1=0.D0                                                        BASIS3.......14400
      RGZLM1=0.D0                                                        BASIS3.......14500
      DO 800 IL=1,8                                                      BASIS3.......14600
      II=(L-1)*8+IL                                                      BASIS3.......14700
      I=IN(II)                                                           BASIS3.......14800
      ADFDXL=DABS(DFDXL(IL))                                             BASIS3.......14900
      ADFDYL=DABS(DFDYL(IL))                                             BASIS3.......15000
      ADFDZL=DABS(DFDZL(IL))                                             BASIS3.......15100
      RGXL=RGXL+RCIT(I)*GXSI(L,IL)*ADFDXL                                BASIS3.......15200
      RGYL=RGYL+RCIT(I)*GETA(L,IL)*ADFDYL                                BASIS3.......15300
      RGZL=RGZL+RCIT(I)*GZET(L,IL)*ADFDZL                                BASIS3.......15400
      RGXLM1=RGXLM1+RCITM1(I)*GXSI(L,IL)*ADFDXL                          BASIS3.......15500
      RGYLM1=RGYLM1+RCITM1(I)*GETA(L,IL)*ADFDYL                          BASIS3.......15600
      RGZLM1=RGZLM1+RCITM1(I)*GZET(L,IL)*ADFDZL                          BASIS3.......15700
  800 CONTINUE                                                           BASIS3.......15800
C                                                                        BASIS3.......15900
C.....TRANSFORM CONSISTENT COMPONENTS OF (RHO*GRAV) TERM TO              BASIS3.......16000
C        GLOBAL COORDINATES                                              BASIS3.......16100
      RGXG=CIJ11*RGXL+CIJ12*RGYL+CIJ13*RGZL                              BASIS3.......16200
      RGYG=CIJ21*RGXL+CIJ22*RGYL+CIJ23*RGZL                              BASIS3.......16300
      RGZG=CIJ31*RGXL+CIJ32*RGYL+CIJ33*RGZL                              BASIS3.......16400
      RGXGM1=CIJ11*RGXLM1+CIJ12*RGYLM1+CIJ13*RGZLM1                      BASIS3.......16500
      RGYGM1=CIJ21*RGXLM1+CIJ22*RGYLM1+CIJ23*RGZLM1                      BASIS3.......16600
      RGZGM1=CIJ31*RGXLM1+CIJ32*RGYLM1+CIJ33*RGZLM1                      BASIS3.......16700
C                                                                        BASIS3.......16800
C.....CALCULATE PARAMETER VALUES AT THIS LOCATION, (XLOC,YLOC,ZLOC)      BASIS3.......16900
      PITERG=0.D0                                                        BASIS3.......17000
      UITERG=0.D0                                                        BASIS3.......17100
      DPDXG=0.D0                                                         BASIS3.......17200
      DPDYG=0.D0                                                         BASIS3.......17300
      DPDZG=0.D0                                                         BASIS3.......17400
      PORG=0.D0                                                          BASIS3.......17500
      DO 1000 IL=1,8                                                     BASIS3.......17600
      II=(L-1)*8 +IL                                                     BASIS3.......17700
      I=IN(II)                                                           BASIS3.......17800
      DPDXG=DPDXG+PVEL(I)*DFDXG(IL)                                      BASIS3.......17900
      DPDYG=DPDYG+PVEL(I)*DFDYG(IL)                                      BASIS3.......18000
      DPDZG=DPDZG+PVEL(I)*DFDZG(IL)                                      BASIS3.......18100
      PORG=PORG+POR(I)*F(IL)                                             BASIS3.......18200
      PITERG=PITERG+PITER(I)*F(IL)                                       BASIS3.......18300
      UITERG=UITERG+UITER(I)*F(IL)                                       BASIS3.......18400
 1000 CONTINUE                                                           BASIS3.......18500
C                                                                        BASIS3.......18600
C.....SET VALUES FOR DENSITY AND VISCOSITY.                              BASIS3.......18700
C.....RHOG = FUNCTION(UITER)                                             BASIS3.......18800
      RHOG=RHOW0+DRWDU*(UITERG-URHOW0)                                   BASIS3.......18900
C.....VISCG = FUNCTION(UITER); VISCOSITY IN UNITS OF VISC0*(KG/(M*SEC))  BASIS3.......19000
      IF(ME) 1300,1300,1200                                              BASIS3.......19100
 1200 VISCG=VISC0*239.4D-7*(10.D0**(248.37D0/(UITERG+133.15D0)))         BASIS3.......19200
      GOTO 1400                                                          BASIS3.......19300
C.....FOR SOLUTE TRANSPORT, VISCG IS TAKEN TO BE CONSTANT                BASIS3.......19400
 1300 VISCG=VISC0                                                        BASIS3.......19500
 1400 CONTINUE                                                           BASIS3.......19600
C                                                                        BASIS3.......19700
C.....SET UNSATURATED FLOW PARAMETERS SWG AND RELKG                      BASIS3.......19800
      IF(IUNSAT-2) 1600,1500,1600                                        BASIS3.......19900
 1500 IF(PITERG) 1550,1600,1600                                          BASIS3.......20000
 1550 CALL UNSAT(SWG,DSWDPG,RELKG,PITERG,LREG(L))                        BASIS3.......20100
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      GOTO 1700                                                          BASIS3.......20200
 1600 SWG=1.0D0                                                          BASIS3.......20300
      RELKG=1.0D0                                                        BASIS3.......20400
 1700 CONTINUE                                                           BASIS3.......20500
C                                                                        BASIS3.......20600
C.....CALCULATE CONSISTENT FLUID VELOCITIES WITH RESPECT TO GLOBAL       BASIS3.......20700
C        COORDINATES, VXG, VYG, VZG, AND VGMAG, AT THIS LOCATION,        BASIS3.......20800
C        (XLOC,YLOC,ZLOC)                                                BASIS3.......20900
      DENOM=1.D0/(PORG*SWG*VISCG)                                        BASIS3.......21000
      PGX=DPDXG-RGXGM1                                                   BASIS3.......21100
      PGY=DPDYG-RGYGM1                                                   BASIS3.......21200
      PGZ=DPDZG-RGZGM1                                                   BASIS3.......21300
C.....ZERO OUT RANDOM BOUYANT DRIVING FORCES DUE TO DIFFERENCING         BASIS3.......21400
C        NUMBERS PAST PRECISION LIMIT.  MINIMUM DRIVING FORCE IS         BASIS3.......21500
C        1.D-10 OF PRESSURE GRADIENT.  (THIS VALUE MAY BE CHANGED        BASIS3.......21600
C        DEPENDING ON MACHINE PRECISION.)                                BASIS3.......21700
      IF(DPDXG) 1720,1727,1720                                           BASIS3.......21800
 1720 IF(DABS(PGX/DPDXG)-1.0D-10) 1725,1725,1727                         BASIS3.......21900
 1725 PGX=0.0D0                                                          BASIS3.......22000
 1727 IF(DPDYG) 1730,1737,1730                                           BASIS3.......22100
 1730 IF(DABS(PGY/DPDYG)-1.0D-10) 1735,1735,1737                         BASIS3.......22200
 1735 PGY=0.0D0                                                          BASIS3.......22300
 1737 IF(DPDZG) 1740,1760,1740                                           BASIS3.......22400
 1740 IF(DABS(PGZ/DPDZG)-1.0D-10) 1745,1745,1760                         BASIS3.......22500
 1745 PGZ=0.0D0                                                          BASIS3.......22600
 1760 VXG=-DENOM*(PERMXX(L)*PGX+PERMXY(L)*PGY+PERMXZ(L)*PGZ)*RELKG       BASIS3.......22700
      VYG=-DENOM*(PERMYX(L)*PGX+PERMYY(L)*PGY+PERMYZ(L)*PGZ)*RELKG       BASIS3.......22800
      VZG=-DENOM*(PERMZX(L)*PGX+PERMZY(L)*PGY+PERMZZ(L)*PGZ)*RELKG       BASIS3.......22900
      VXG2=VXG*VXG                                                       BASIS3.......23000
      VYG2=VYG*VYG                                                       BASIS3.......23100
      VZG2=VZG*VZG                                                       BASIS3.......23200
      VGMAG=DSQRT(VXG2+VYG2+VZG2)                                        BASIS3.......23300
C                                                                        BASIS3.......23400
C.....AT THIS POINT IN LOCAL COORDINATES, (XLOC,YLOC,ZLOC),              BASIS3.......23500
C        CALCULATE ASYMMETRIC WEIGHTING FUNCTIONS, W(I),                 BASIS3.......23600
C        AND SPACE DERIVATIVES, DWDXG(I), DWDYG(I), AND DWDZG(I).        BASIS3.......23700
C                                                                        BASIS3.......23800
C.....ASYMMETRIC FUNCTIONS SIMPLIFY WHEN  UP=0.0                         BASIS3.......23900
      IF(UP.GT.1.0D-6.AND.NOUMAT.EQ.0) GOTO 1790                         BASIS3.......24000
      DO 1780 I=1,8                                                      BASIS3.......24100
      W(I)=F(I)                                                          BASIS3.......24200
      DWDXG(I)=DFDXG(I)                                                  BASIS3.......24300
      DWDYG(I)=DFDYG(I)                                                  BASIS3.......24400
      DWDZG(I)=DFDZG(I)                                                  BASIS3.......24500
 1780 CONTINUE                                                           BASIS3.......24600
C.....RETURN WHEN ONLY SYMMETRIC WEIGHTING FUNCTIONS ARE USED            BASIS3.......24700
      RETURN                                                             BASIS3.......24800
C                                                                        BASIS3.......24900
C.....CALCULATE FLUID VELOCITIES WITH RESPECT TO LOCAL COORDINATES,      BASIS3.......25000
C        VXL, VYL, VZL, AND VLMAG, AT THIS LOCATION, (XLOC,YLOC,ZLOC).   BASIS3.......25100
 1790 VXL=CIJ11*VXG+CIJ21*VYG+CIJ31*VZG                                  BASIS3.......25200
      VYL=CIJ12*VXG+CIJ22*VYG+CIJ32*VZG                                  BASIS3.......25300
      VZL=CIJ13*VXG+CIJ23*VYG+CIJ33*VZG                                  BASIS3.......25400
      VLMAG=DSQRT(VXL*VXL+VYL*VYL+VZL*VZL)                               BASIS3.......25500
C                                                                        BASIS3.......25600
      AA=0.0D0                                                           BASIS3.......25700
      BB=0.0D0                                                           BASIS3.......25800
      GG=0.0D0                                                           BASIS3.......25900
      IF(VLMAG) 1900,1900,1800                                           BASIS3.......26000
 1800 AA=UP*VXL/VLMAG                                                    BASIS3.......26100
      BB=UP*VYL/VLMAG                                                    BASIS3.......26200
      GG=UP*VZL/VLMAG                                                    BASIS3.......26300
C                                                                        BASIS3.......26400
 1900 XIXI=.750D0*AA*XF1*XF2                                             BASIS3.......26500
      YIYI=.750D0*BB*YF1*YF2                                             BASIS3.......26600
      ZIZI=.750D0*GG*ZF1*ZF2                                             BASIS3.......26700
      DO 2000 I=1,8                                                      BASIS3.......26800
      AFX(I)=.50D0*FX(I)+XIIX(I)*XIXI                                    BASIS3.......26900
      AFY(I)=.50D0*FY(I)+YIIY(I)*YIYI                                    BASIS3.......27000
 2000 AFZ(I)=.50D0*FZ(I)+ZIIZ(I)*ZIZI                                    BASIS3.......27100
C                                                                        BASIS3.......27200
C.....CALCULATE ASYMMETRIC WEIGHTING FUNCTION, W.                        BASIS3.......27300
      DO 3000 I=1,8                                                      BASIS3.......27400
 3000 W(I)=AFX(I)*AFY(I)*AFZ(I)                                          BASIS3.......27500
C                                                                        BASIS3.......27600
      THAAX=0.50D0-1.50D0*AA*XLOC                                        BASIS3.......27700
      THBBY=0.50D0-1.50D0*BB*YLOC                                        BASIS3.......27800
      THGGZ=0.50D0-1.50D0*GG*ZLOC                                        BASIS3.......27900
      DO 4000 I=1,8                                                      BASIS3.......28000
      XDW(I)=XIIX(I)*THAAX                                               BASIS3.......28100
      YDW(I)=YIIY(I)*THBBY                                               BASIS3.......28200
 4000 ZDW(I)=ZIIZ(I)*THGGZ                                               BASIS3.......28300
C                                                                        BASIS3.......28400
C.....CALCULATE DERIVATIVES WITH RESPECT TO LOCAL COORDINATES.           BASIS3.......28500
      DO 5000 I=1,8                                                      BASIS3.......28600
      DWDXL(I)=XDW(I)*AFY(I)*AFZ(I)                                      BASIS3.......28700
      DWDYL(I)=YDW(I)*AFX(I)*AFZ(I)                                      BASIS3.......28800
 5000 DWDZL(I)=ZDW(I)*AFX(I)*AFY(I)                                      BASIS3.......28900
C                                                                        BASIS3.......29000
C.....CALCULATE DERIVATIVES WITH RESPECT TO GLOBAL COORDINATES.          BASIS3.......29100
      DO 6000 I=1,8                                                      BASIS3.......29200
      DWDXG(I)=CIJ11*DWDXL(I)+CIJ12*DWDYL(I)+CIJ13*DWDZL(I)              BASIS3.......29300
      DWDYG(I)=CIJ21*DWDXL(I)+CIJ22*DWDYL(I)+CIJ23*DWDZL(I)              BASIS3.......29400
 6000 DWDZG(I)=CIJ31*DWDXL(I)+CIJ32*DWDYL(I)+CIJ33*DWDZL(I)              BASIS3.......29500
C                                                                        BASIS3.......29600
C                                                                        BASIS3.......29700
      RETURN                                                             BASIS3.......29800
      END                                                                BASIS3.......29900
C                                                                        BASIS3.......30000
C     SUBROUTINE        B  C                       SUTRA VERSION 2.1     BC.............100
C                                                                        BC.............200
C *** PURPOSE :                                                          BC.............300
C ***  TO IMPLEMENT SPECIFIED PRESSURE AND SPECIFIED TEMPERATURE OR      BC.............400
C ***  CONCENTRATION CONDITIONS BY MODIFYING THE GLOBAL FLOW AND         BC.............500
C ***  TRANSPORT MATRIX EQUATIONS.                                       BC.............600
C                                                                        BC.............700
      SUBROUTINE BC(ML,PMAT,PVEC,UMAT,UVEC,IPBC,PBC,IUBC,UBC,QPLITR,JA)  BC.............800
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BC.............900
      DIMENSION PMAT(NELT,NCBI),PVEC(NNVEC),UMAT(NELT,NCBI),UVEC(NNVEC), BC............1000
     1   IPBC(NBCN),PBC(NBCN),IUBC(NBCN),UBC(NBCN),QPLITR(NBCN)          BC............1100
      DIMENSION JA(NDIMJA)                                               BC............1200
      DIMENSION KTYPE(2)                                                 BC............1300
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BC............1400
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             BC............1500
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BC............1600
     1   NSOP,NSOU,NBCN                                                  BC............1700
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        BC............1800
      COMMON /DIMX2/ NELTA,NNVEC,NDIMIA,NDIMJA                           BC............1900
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      BC............2000
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        BC............2100
      COMMON /SOLVI/ KSOLVP,KSOLVU,NN1,NN2,NN3                           BC............2200
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       BC............2300
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITMAX,TSTART                  BC............2400
C                                                                        BC............2500
C                                                                        BC............2600
C.....SET UP MATRIX STRUCTURE INFORMATION                                BC............2700
      IF (KSOLVP.EQ.0) THEN                                              BC............2800
         JMID = NBHALF                                                   BC............2900
      ELSE                                                               BC............3000
         JMID = 1                                                        BC............3100
      END IF                                                             BC............3200
C                                                                        BC............3300
      IF(NPBC.EQ.0) GOTO 1050                                            BC............3400
C.....SPECIFIED P BOUNDARY CONDITIONS                                    BC............3500
      DO 1000 IP=1,NPBC                                                  BC............3600
      I=IABS(IPBC(IP))                                                   BC............3700
      IF (KSOLVP.EQ.0) THEN                                              BC............3800
         IMID = I                                                        BC............3900
      ELSE                                                               BC............4000
         IMID = JA(I)                                                    BC............4100
      END IF                                                             BC............4200
C                                                                        BC............4300
      IF(ML-1) 100,100,200                                               BC............4400
C.....MODIFY EQUATION FOR P BY ADDING FLUID SOURCE AT SPECIFIED          BC............4500
C        PRESSURE NODE                                                   BC............4600
  100 GPINL=-GNUP                                                        BC............4700
      GPINR=GNUP*PBC(IP)                                                 BC............4800
      PMAT(IMID,JMID)=PMAT(IMID,JMID)-GPINL                              BC............4900
      PVEC(I)=PVEC(I)+GPINR                                              BC............5000
C                                                                        BC............5100
      IF(ML-1) 200,1000,200                                              BC............5200
C.....MODIFY EQUATION FOR U BY ADDING U SOURCE WHEN FLUID FLOWS IN       BC............5300
C        AT SPECIFIED PRESSURE NODE                                      BC............5400
  200 GUR=0.0D0                                                          BC............5500
      GUL=0.0D0                                                          BC............5600
      IF(QPLITR(IP)) 360,360,340                                         BC............5700
  340 GUL=-CW*QPLITR(IP)                                                 BC............5800
      GUR=-GUL*UBC(IP)                                                   BC............5900
  360 IF(NOUMAT) 370,370,380                                             BC............6000
  370 UMAT(IMID,JMID)=UMAT(IMID,JMID)-GUL                                BC............6100
  380 UVEC(I)=UVEC(I)+GUR                                                BC............6200
 1000 CONTINUE                                                           BC............6300
C                                                                        BC............6400
C                                                                        BC............6500
 1050 IF(ML-1) 1100,3000,1100                                            BC............6600
 1100 IF(NUBC.EQ.0) GOTO 3000                                            BC............6700
C.....SPECIFIED U BOUNDARY CONDITIONS.                                   BC............6800
C        MODIFY EQUATION FOR U BY ADDING ENERGY/SOLUTE MASS SOURCE       BC............6900
C        AT SPECIFIED U NODE                                             BC............7000
      DO 2500 IU=1,NUBC                                                  BC............7100
      IUP=IU+NPBC                                                        BC............7200
      I=IABS(IUBC(IUP))                                                  BC............7300
      IF (KSOLVP.EQ.0) THEN                                              BC............7400
         IMID = I                                                        BC............7500
      ELSE                                                               BC............7600
         IMID = JA(I)                                                    BC............7700
      END IF                                                             BC............7800
      IF(NOUMAT) 1200,1200,2000                                          BC............7900
 1200 GUINL=-GNUU                                                        BC............8000
      UMAT(IMID,JMID)=UMAT(IMID,JMID)-GUINL                              BC............8100
 2000 GUINR=GNUU*UBC(IUP)                                                BC............8200
 2500 UVEC(I)=UVEC(I)+GUINR                                              BC............8300
C                                                                        BC............8400
 3000 CONTINUE                                                           BC............8500
C                                                                        BC............8600
C                                                                        BC............8700
      RETURN                                                             BC............8800
      END                                                                BC............8900
C                                                                        BC............9000
C     SUBPROGRAM        B  D  I  N  I  T           SUTRA VERSION 2.1     BDINIT.........100
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
C     SUBROUTINE        B  O  U  N  D              SUTRA VERSION 2.1     BOUND..........100
C                                                                        BOUND..........200
C *** PURPOSE :                                                          BOUND..........300
C ***  TO READ AND ORGANIZE SPECIFIED PRESSURE DATA AND                  BOUND..........400
C ***  SPECIFIED TEMPERATURE OR CONCENTRATION DATA.                      BOUND..........500
C                                                                        BOUND..........600
      SUBROUTINE BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT)                    BOUND..........700
c rbw begin change
      use ErrorFlag
c rbw end chagne
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BOUND..........800
      CHARACTER INTFIL*1000                                              BOUND..........900
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:8)                     BOUND.........1000
      DIMENSION IPBC(NBCN),PBC(NBCN),IUBC(NBCN),UBC(NBCN)                BOUND.........1100
      DIMENSION INERR(10),RLERR(10)                                      BOUND.........1200
      DIMENSION KTYPE(2)                                                 BOUND.........1300
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BOUND.........1400
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             BOUND.........1500
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BOUND.........1600
     1   NSOP,NSOU,NBCN                                                  BOUND.........1700
      COMMON /FNAMES/ UNAME,FNAME                                        BOUND.........1800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     BOUND.........1900
C                                                                        BOUND.........2000
C                                                                        BOUND.........2100
      IPBCT=1                                                            BOUND.........2200
      IUBCT=1                                                            BOUND.........2300
      IP=0                                                               BOUND.........2400
      IPU=0                                                              BOUND.........2500
c rbw begin change
c      WRITE(K3,50)                                                       BOUND.........2600
c rbw end chagne
   50 FORMAT('1'////11X,'B O U N D A R Y   C O N D I T I O N S')         BOUND.........2700
      IF(NPBC.EQ.0) GOTO 400                                             BOUND.........2800
c rbw begin change
c      WRITE(K3,100)                                                      BOUND.........2900
c rbw end chagne
  100 FORMAT(//11X,'**** NODES AT WHICH PRESSURES ARE',                  BOUND.........3000
     1   ' SPECIFIED ****'/)                                             BOUND.........3100
c rbw begin change
c      IF(ME) 107,107,114                                                 BOUND.........3200
c  107 WRITE(K3,108)                                                      BOUND.........3300
c rbw end chagne
  108 FORMAT(11X,'     (AS WELL AS SOLUTE CONCENTRATION OF ANY'          BOUND.........3400
     1   /16X,' FLUID INFLOW WHICH MAY OCCUR AT THE POINT'               BOUND.........3500
     2   /16X,' OF SPECIFIED PRESSURE)'//12X,'NODE',18X,'PRESSURE',      BOUND.........3600
     3   13X,'CONCENTRATION'//)                                          BOUND.........3700
      GOTO 125                                                           BOUND.........3800
c rbw begin change
c  114 WRITE(K3,115)                                                      BOUND.........3900
c rbw end chagne
  115 FORMAT(11X,'     (AS WELL AS TEMPERATURE {DEGREES CELSIUS} OF ANY' BOUND.........4000
     1   /16X,' FLUID INFLOW WHICH MAY OCCUR AT THE POINT'               BOUND.........4100
     2   /16X,' OF SPECIFIED PRESSURE)'//12X,'NODE',18X,                 BOUND.........4200
     2   'PRESSURE',13X,'  TEMPERATURE'//)                               BOUND.........4300
C                                                                        BOUND.........4400
C.....INPUT DATASET 19:  DATA FOR SPECIFIED PRESSURE NODES               BOUND.........4500
  125 IPU=IPU+1                                                          BOUND.........4600
      ERRCOD = 'REA-INP-19'                                              BOUND.........4700
      CALL READIF(K1, INTFIL, ERRCOD)                                    BOUND.........4800
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 153
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IDUM                                BOUND.........4900
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        BOUND.........5000
      IF (INERR(1).NE.0) then
        IErrorFlag = 25
        return
      endif
c rbw end change
      IDUMA = IABS(IDUM)                                                 BOUND.........5100
      IF (IDUM.EQ.0) THEN                                                BOUND.........5200
         GOTO 180                                                        BOUND.........5300
      ELSE IF (IDUMA.GT.NN) THEN                                         BOUND.........5400
c rbw begin change
        IErrorFlag = 26
        return
c         ERRCOD = 'INP-19-1'                                             BOUND.........5500
c         INERR(1) = IDUMA                                                BOUND.........5600
c         INERR(2) = NN                                                   BOUND.........5700
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND.........5800
c rbw end change
      ELSE IF (IPU.GT.NPBC) THEN                                         BOUND.........5900
         GOTO 125                                                        BOUND.........6000
      END IF                                                             BOUND.........6100
      IPBC(IPU) = IDUM                                                   BOUND.........6200
      IF (IPBC(IPU).GT.0) THEN                                           BOUND.........6300
         ERRCOD = 'REA-INP-19'                                           BOUND.........6400
         READ(INTFIL,*,IOSTAT=INERR(1)) IPBC(IPU),PBC(IPU),UBC(IPU)      BOUND.........6500
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BOUND.........6600
         IF (INERR(1).NE.0) then
           IErrorFlag = 27
           return
         endif
c         WRITE(K3,160) IPBC(IPU),PBC(IPU),UBC(IPU)                       BOUND.........6700
c rbw end change
      ELSE IF (IPBC(IPU).LT.0) THEN                                      BOUND.........6800
         IPBCT = -1                                                      BOUND.........6900
c rbw begin change
c         WRITE(K3,160) IPBC(IPU)                                         BOUND.........7000
c rbw end change
      ELSE                                                               BOUND.........7100
         GOTO 180                                                        BOUND.........7200
      END IF                                                             BOUND.........7300
  160 FORMAT(7X,I9,6X,1PE20.13,6X,1PE20.13)                              BOUND.........7400
      GOTO 125                                                           BOUND.........7500
  180 IPU=IPU-1                                                          BOUND.........7600
      IP=IPU                                                             BOUND.........7700
      IF(IP.EQ.NPBC) GOTO 200                                            BOUND.........7800
c rbw begin change
           IErrorFlag = 28
           return
c      ERRCOD = 'INP-3,19-1'                                              BOUND.........7900
c      INERR(1) = IP                                                      BOUND.........8000
c      INERR(2) = NPBC                                                    BOUND.........8100
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           BOUND.........8200
c rbw end change
  200 IF(IPBCT.NE.-1) GOTO 400                                           BOUND.........8300
c rbw begin change
c      IF(ME) 205,205,215                                                 BOUND.........8400
c  205 WRITE(K3,206)                                                      BOUND.........8500
c  206 FORMAT(//12X,'TIME-DEPENDENT SPECIFIED PRESSURE'/12X,'OR INFLOW ', BOUND.........8600
c     1   'CONCENTRATION INDICATED'/12X,'BY NEGATIVE NODE NUMBER')        BOUND.........8700
c      GOTO 400                                                           BOUND.........8800
c  215 WRITE(K3,216)                                                      BOUND.........8900
c  216 FORMAT(//11X,'TIME-DEPENDENT SPECIFIED PRESSURE'/12X,'OR INFLOW ', BOUND.........9000
c     1   'TEMPERATURE INDICATED'/12X,'BY NEGATIVE NODE NUMBER')          BOUND.........9100
c rbw end change
  400 IF(NUBC.EQ.0) GOTO 6000                                            BOUND.........9200
C                                                                        BOUND.........9300
c rbw begin change
c      IF(ME) 500,500,550                                                 BOUND.........9400
c  500 WRITE(K3,1000)                                                     BOUND.........9500
c 1000 FORMAT(////11X,'**** NODES AT WHICH SOLUTE CONCENTRATIONS ARE ',   BOUND.........9600
c     1   'SPECIFIED TO BE INDEPENDENT OF LOCAL FLOWS AND FLUID SOURCES', BOUND.........9700
c     2   ' ****'//12X,'NODE',13X,'CONCENTRATION'//)                      BOUND.........9800
c      GOTO 1125                                                          BOUND.........9900
c  550 WRITE(K3,1001)                                                     BOUND........10000
c 1001 FORMAT(////11X,'**** NODES AT WHICH TEMPERATURES ARE ',            BOUND........10100
c     1   'SPECIFIED TO BE INDEPENDENT OF LOCAL FLOWS AND FLUID SOURCES', BOUND........10200
c     2   ' ****'//12X,'NODE',15X,'TEMPERATURE'//)                        BOUND........10300
c rbw end change
C                                                                        BOUND........10400
C.....INPUT DATASET 20:  DATA FOR SPECIFIED CONCENTRATION OR             BOUND........10500
C        TEMPERATURE NODES                                               BOUND........10600
 1125 IPU=IPU+1                                                          BOUND........10700
      ERRCOD = 'REA-INP-20'                                              BOUND........10800
      CALL READIF(K1, INTFIL, ERRCOD)                                    BOUND........10900
c rbw begin change
         if (IErrorFlag.ne.0) then
           IErrorFlag = 154
           return
         endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IDUM                                BOUND........11000
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        BOUND........11100
      IF (INERR(1).NE.0) then
           IErrorFlag = 29
           return
      endif
c rbw end change
      IDUMA = IABS(IDUM)                                                 BOUND........11200
      IF (IDUM.EQ.0) THEN                                                BOUND........11300
         GOTO 1180                                                       BOUND........11400
      ELSE IF (IDUMA.GT.NN) THEN                                         BOUND........11500
c rbw begin change
           IErrorFlag = 30
           return
c         ERRCOD = 'INP-20-1'                                             BOUND........11600
c         INERR(1) = IDUMA                                                BOUND........11700
c         INERR(2) = NN                                                   BOUND........11800
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND........11900
c rbw end change
      ELSE IF (IPU.GT.NPBC+NUBC) THEN                                    BOUND........12000
         GOTO 1125                                                       BOUND........12100
      END IF                                                             BOUND........12200
      IUBC(IPU) = IDUM                                                   BOUND........12300
      IF (IUBC(IPU).GT.0) THEN                                           BOUND........12400
         ERRCOD = 'REA-INP-20'                                           BOUND........12500
         READ(INTFIL,*,IOSTAT=INERR(1)) IUBC(IPU),UBC(IPU)               BOUND........12600
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BOUND........12700
         IF (INERR(1).NE.0) then
           IErrorFlag = 31
           return
         endif
c         WRITE(K3,1150) IUBC(IPU),UBC(IPU)                               BOUND........12800
c rbw end change
      ELSE IF (IUBC(IPU).LT.0) THEN                                      BOUND........12900
         IUBCT = -1                                                      BOUND........13000
c rbw begin change
c         WRITE(K3,1150) IUBC(IPU)                                        BOUND........13100
c rbw end change
      ELSE                                                               BOUND........13200
         GOTO 1180                                                       BOUND........13300
      END IF                                                             BOUND........13400
 1150 FORMAT(11X,I9,6X,1PE20.13)                                         BOUND........13500
      GOTO 1125                                                          BOUND........13600
 1180 IPU=IPU-1                                                          BOUND........13700
      IU=IPU-IP                                                          BOUND........13800
      IF(IU.EQ.NUBC) GOTO 1200                                           BOUND........13900
c rbw begin change
           IErrorFlag = 32
           return
c      IF (ME.EQ.1) THEN                                                  BOUND........14000
c         ERRCOD = 'INP-3,20-2'                                           BOUND........14100
c      ELSE                                                               BOUND........14200
c         ERRCOD = 'INP-3,20-1'                                           BOUND........14300
c      END IF                                                             BOUND........14400
c      INERR(1) = IU                                                      BOUND........14500
c      INERR(2) = NUBC                                                    BOUND........14600
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           BOUND........14700
c rbw begin change
 1200  continue
c 1200 IF(IUBCT.NE.-1) GOTO 6000                                          BOUND........14800
c      IF(ME) 1205,1205,1215                                              BOUND........14900
c 1205 WRITE(K3,1206)                                                     BOUND........15000
c 1206 FORMAT(//12X,'TIME-DEPENDENT SPECIFIED CONCENTRATION'/12X,'IS ',   BOUND........15100
c     1   'INDICATED BY NEGATIVE NODE NUMBER')                            BOUND........15200
c      GOTO 6000                                                          BOUND........15300
c 1215 WRITE(K3,1216)                                                     BOUND........15400
c 1216 FORMAT(//11X,'TIME-DEPENDENT SPECIFIED TEMPERATURE'/12X,'IS ',     BOUND........15500
c     1   'INDICATED BY NEGATIVE NODE NUMBER')                            BOUND........15600
cC                                                                        BOUND........15700
 6000 continue
c 6000 IF(IPBCT.EQ.-1.OR.IUBCT.EQ.-1) WRITE(K3,7000)                      BOUND........15800
c 7000 FORMAT(////11X,'THE SPECIFIED TIME VARIATIONS ARE ',               BOUND........15900
c     1   'USER-PROGRAMMED IN SUBROUTINE  B C T I M E .')                 BOUND........16000
C                                                                        BOUND........16100
C                                                                        BOUND........16200
c rbw end change
      RETURN                                                             BOUND........16300
      END                                                                BOUND........16400
C                                                                        BOUND........16500
C     SUBROUTINE        B  U  D  G  E  T           SUTRA VERSION 2.1     BUDGET.........100
C                                                                        BUDGET.........200
C *** PURPOSE :                                                          BUDGET.........300
C ***  TO CALCULATE AND OUTPUT FLUID MASS AND SOLUTE MASS OR             BUDGET.........400
C ***  ENERGY BUDGETS.                                                   BUDGET.........500
C                                                                        BUDGET.........600
      SUBROUTINE BUDGET(ML,IBCT,VOL,SW,DSWDP,RHO,SOP,QIN,PVEC,PM1,       BUDGET.........700
     1   DPDTITR,PBC,QPLITR,IPBC,IQSOP,POR,UVEC,UM1,UM2,UIN,QUIN,QINITR, BUDGET.........800
     2   IQSOU,UBC,IUBC,CS1,CS2,CS3,SL,SR,NREG)                          BUDGET.........900
c rbw begin change
      use ErrorFlag
c rbw end chagne
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BUDGET........1000
      CHARACTER*10 ADSMOD                                                BUDGET........1100
      CHARACTER*13 ULABL(2)                                              BUDGET........1200
      DIMENSION QIN(NN),UIN(NN),IQSOP(NSOP),QUIN(NN),QINITR(NN),         BUDGET........1300
     1   IQSOU(NSOU)                                                     BUDGET........1400
      DIMENSION IPBC(NBCN),IUBC(NBCN),UBC(NBCN),QPLITR(NBCN),PBC(NBCN)   BUDGET........1500
      DIMENSION POR(NN),VOL(NN),PVEC(NNVEC),UVEC(NNVEC),SW(NN),          BUDGET........1600
     1   DSWDP(NN),RHO(NN),SOP(NN),PM1(NN),DPDTITR(NN),UM1(NN),UM2(NN),  BUDGET........1700
     2   CS1(NN),CS2(NN),CS3(NN),SL(NN),SR(NN),NREG(NN)                  BUDGET........1800
      DIMENSION KTYPE(2)                                                 BUDGET........1900
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BUDGET........2000
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             BUDGET........2100
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BUDGET........2200
     1   NSOP,NSOU,NBCN                                                  BUDGET........2300
      COMMON /DIMX2/ NELTA,NNVEC,NDIMIA,NDIMJA                           BUDGET........2400
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     BUDGET........2500
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      BUDGET........2600
      COMMON /MODSOR/ ADSMOD                                             BUDGET........2700
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      BUDGET........2800
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        BUDGET........2900
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       BUDGET........3000
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITMAX,TSTART                  BUDGET........3100
      DATA ULABL(1)/'CONCENTRATION'/,ULABL(2)/' TEMPERATURE '/           BUDGET........3200
      SAVE ULABL                                                         BUDGET........3300
C                                                                        BUDGET........3400
C                                                                        BUDGET........3500
      MN=2                                                               BUDGET........3600
      IF(IUNSAT.NE.0) IUNSAT=1                                           BUDGET........3700
      IF(ME.EQ.-1) MN=1                                                  BUDGET........3800
c rbw begin change
c      WRITE(K3,10)                                                       BUDGET........3900
c rbw end change
   10 FORMAT('1')                                                        BUDGET........4000
C.....SET UNSATURATED FLOW PARAMETERS, SW(I) AND DSWDP(I)                BUDGET........4100
      IF(IUNSAT-1) 40,20,40                                              BUDGET........4200
   20 DO 30 I=1,NN                                                       BUDGET........4300
      IF(PVEC(I)) 25,27,27                                               BUDGET........4400
   25 CALL UNSAT(SW(I),DSWDP(I),RELK,PVEC(I),NREG(I))                    BUDGET........4500
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      GOTO 30                                                            BUDGET........4600
   27 SW(I)=1.0D0                                                        BUDGET........4700
      DSWDP(I)=0.0D0                                                     BUDGET........4800
   30 CONTINUE                                                           BUDGET........4900
C                                                                        BUDGET........5000
C.....CALCULATE COMPONENTS OF FLUID MASS BUDGET                          BUDGET........5100
   40 IF(ML-1) 50,50,1000                                                BUDGET........5200
   50 CONTINUE                                                           BUDGET........5300
      STPPOS = 0D0                                                       BUDGET........5400
      STPNEG = 0D0                                                       BUDGET........5500
      STUPOS = 0D0                                                       BUDGET........5600
      STUNEG = 0D0                                                       BUDGET........5700
      QINPOS = 0D0                                                       BUDGET........5800
      QINNEG = 0D0                                                       BUDGET........5900
      DO 100 I=1,NN                                                      BUDGET........6000
      TERM = (1-ISSFLO/2)*RHO(I)*VOL(I)*                                 BUDGET........6100
     1   (SW(I)*SOP(I)+POR(I)*DSWDP(I))*(PVEC(I)-PM1(I))/DELTP           BUDGET........6200
      STPPOS = STPPOS + MAX(0D0, TERM)                                   BUDGET........6300
      STPNEG = STPNEG + MIN(0D0, TERM)                                   BUDGET........6400
      TERM = (1-ISSFLO/2)*POR(I)*SW(I)*DRWDU*VOL(I)*                     BUDGET........6500
     1   (UM1(I)-UM2(I))/DLTUM1                                          BUDGET........6600
      STUPOS = STUPOS + MAX(0D0, TERM)                                   BUDGET........6700
      STUNEG = STUNEG + MIN(0D0, TERM)                                   BUDGET........6800
      TERM = QIN(I)                                                      BUDGET........6900
      QINPOS = QINPOS + MAX(0D0, TERM)                                   BUDGET........7000
      QINNEG = QINNEG + MIN(0D0, TERM)                                   BUDGET........7100
  100 CONTINUE                                                           BUDGET........7200
      STPTOT = STPPOS + STPNEG                                           BUDGET........7300
      STUTOT = STUPOS + STUNEG                                           BUDGET........7400
      STFPOS = STPPOS + STUPOS                                           BUDGET........7500
      STFNEG = STPNEG + STUNEG                                           BUDGET........7600
      STFTOT = STPTOT + STUTOT                                           BUDGET........7700
      QINTOT = QINPOS + QINNEG                                           BUDGET........7800
C                                                                        BUDGET........7900
      QPLPOS = 0D0                                                       BUDGET........8000
      QPLNEG = 0D0                                                       BUDGET........8100
      DO 200 IP=1,NPBC                                                   BUDGET........8200
      I=IABS(IPBC(IP))                                                   BUDGET........8300
      TERM = GNUP*(PBC(IP)-PVEC(I))                                      BUDGET........8400
      QPLPOS = QPLPOS + MAX(0D0, TERM)                                   BUDGET........8500
      QPLNEG = QPLNEG + MIN(0D0, TERM)                                   BUDGET........8600
  200 CONTINUE                                                           BUDGET........8700
      QPLTOT = QPLPOS + QPLNEG                                           BUDGET........8800
      QFFPOS = QINPOS + QPLPOS                                           BUDGET........8900
      QFFNEG = QINNEG + QPLNEG                                           BUDGET........9000
      QFFTOT = QINTOT + QPLTOT                                           BUDGET........9100
C                                                                        BUDGET........9200
C.....OUTPUT FLUID MASS BUDGET                                           BUDGET........9300
      ACTFMB = 5D-1*(STFPOS - STFNEG + QFFPOS - QFFNEG)                  BUDGET........9400
      ERFMBA = STFTOT - QFFTOT                                           BUDGET........9500
c rbw begin change
c      WRITE(K3,300) IT,STPPOS,STPNEG,STPTOT,                             BUDGET........9600
c     1   ULABL(MN),STUPOS,STUNEG,STUTOT,STFPOS,STFNEG,STFTOT,            BUDGET........9700
c     2   QINPOS,QINNEG,QINTOT,QPLPOS,QPLNEG,QPLTOT,                      BUDGET........9800
c     3   QFFPOS,QFFNEG,QFFTOT,ACTFMB,ERFMBA                              BUDGET........9900
c rbw end change
  300 FORMAT(//11X,'F L U I D   M A S S   B U D G E T      AFTER TIME',  BUDGET.......10000
     1   ' STEP ',I8,',     IN (MASS/SECOND)'                            BUDGET.......10100
     2   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'INCREASES(+)',4X,    BUDGET.......10200
     3   'DECREASES(-)',7X,'CHANGE'/84X,3(2X,14('='))                    BUDGET.......10300
     4   /13X,'RATE OF CHANGE IN TOTAL STORED FLUID DUE TO PRESSURE',    BUDGET.......10400
     5   ' CHANGE',12X,3(1X,1PE15.7)                                     BUDGET.......10500
     6   /13X,'RATE OF CHANGE IN TOTAL STORED FLUID DUE TO ',A13,        BUDGET.......10600
     7   ' CHANGE',7X,3(1X,1PE15.7)/84X,3(2X,14('-'))                    BUDGET.......10700
     8   /13X,'TOTAL RATE OF CHANGE IN STORED FLUID [ S+, S-, S ]',      BUDGET.......10800
     9   21X,3(1X,1PE15.7)                                               BUDGET.......10900
     T   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/89X,'GAINS(+)',7X,        BUDGET.......11000
     1   'LOSSES(-)',7X,'GAIN/LOSS'/84X,3(2X,14('='))                    BUDGET.......11100
     2   /13X,'GAIN/LOSS OF FLUID THROUGH FLUID SOURCES AND SINKS',      BUDGET.......11200
     3   21X,3(1X,1PE15.7)                                               BUDGET.......11300
     4   /13X,'GAIN/LOSS OF FLUID THROUGH INFLOWS/OUTFLOWS AT'           BUDGET.......11400
     5   ' SPECIFIED P NODES',7X,3(1X,1PE15.7)/84X,3(2X,14('-'))         BUDGET.......11500
     6   /13X,'TOTAL RATE OF GAIN/LOSS OF FLUID THROUGH FLOWS',          BUDGET.......11600
     7   ' [ F+, F-, F ]',11X,3(1X,1PE15.7)                              BUDGET.......11700
     8   ///13X,'FLUID MASS BALANCE ACTIVITY',                           BUDGET.......11800
     9   ' [ A = ((S+) - (S-) + (F+) - (F-))/2 ]',14X,1PE15.7            BUDGET.......11900
     T   /13X,'ABSOLUTE FLUID MASS BALANCE ERROR [ S - F ]',36X,1PE15.7) BUDGET.......12000
      IF (ACTFMB.NE.0D0) THEN                                            BUDGET.......12100
         ERFMBR = 1D2*ERFMBA/ACTFMB                                      BUDGET.......12200
c rbw begin change
c         WRITE(K3,301) ERFMBR                                            BUDGET.......12300
c      ELSE                                                               BUDGET.......12400
c         WRITE(K3,302)                                                   BUDGET.......12500
c rbw end change
      END IF                                                             BUDGET.......12600
  301 FORMAT(13X,'RELATIVE FLUID MASS BALANCE ERROR',                    BUDGET.......12700
     1   ' [ 100*(S - F)/A ]',28X,1PE15.7,' (PERCENT)')                  BUDGET.......12800
  302 FORMAT(13X,'RELATIVE FLUID MASS BALANCE ERROR',                    BUDGET.......12900
     1   ' [ 100*(S - F)/A ]',28X,'  UNDEFINED')                         BUDGET.......13000
C                                                                        BUDGET.......13100
      IF(IBCT.EQ.4) GOTO 600                                             BUDGET.......13200
      NSOPI=NSOP-1                                                       BUDGET.......13300
      INEGCT=0                                                           BUDGET.......13400
      DO 500 IQP=1,NSOPI                                                 BUDGET.......13500
      I=IQSOP(IQP)                                                       BUDGET.......13600
      IF(I) 325,500,500                                                  BUDGET.......13700
  325 INEGCT=INEGCT+1                                                    BUDGET.......13800
c rbw begin change
c      IF(INEGCT.EQ.1) WRITE(K3,350)                                      BUDGET.......13900
c rbw end change
  350 FORMAT(///22X,'TIME-DEPENDENT FLUID SOURCES OR SINKS'//22X,        BUDGET.......14000
     1   ' NODE',5X,'INFLOW(+)/OUTFLOW(-)'/37X,'  (MASS/SECOND)'//)      BUDGET.......14100
c rbw begin change
c      WRITE(K3,450) -I,QIN(-I)                                           BUDGET.......14200
c rbw end change
  450 FORMAT(18X,I9,10X,1PE15.7)                                         BUDGET.......14300
  500 CONTINUE                                                           BUDGET.......14400
C                                                                        BUDGET.......14500
  600 IF(NPBC.EQ.0) GOTO 800                                             BUDGET.......14600
c rbw begin change
c      WRITE(K3,650)                                                      BUDGET.......14700
c rbw end change
  650 FORMAT(///22X,'FLUID SOURCES OR SINKS DUE TO SPECIFIED PRESSURES', BUDGET.......14800
     1   //22X,' NODE',5X,'INFLOW(+)/OUTFLOW(-)'/37X,'  (MASS/SECOND)'/) BUDGET.......14900
      DO 700 IP=1,NPBC                                                   BUDGET.......15000
      I=IABS(IPBC(IP))                                                   BUDGET.......15100
c rbw begin change
c      WRITE(K3,450) I, GNUP*(PBC(IP)-PVEC(I))                            BUDGET.......15200
c rbw end change
  700 CONTINUE                                                           BUDGET.......15300
C                                                                        BUDGET.......15400
C.....CALCULATE COMPONENTS OF ENERGY OR SOLUTE MASS BUDGET               BUDGET.......15500
  800 IF(ML-1) 1000,5500,1000                                            BUDGET.......15600
 1000 CONTINUE                                                           BUDGET.......15700
      FLDPOS = 0D0                                                       BUDGET.......15800
      FLDNEG = 0D0                                                       BUDGET.......15900
      SLDPOS = 0D0                                                       BUDGET.......16000
      SLDNEG = 0D0                                                       BUDGET.......16100
      DNSPOS = 0D0                                                       BUDGET.......16200
      DNSNEG = 0D0                                                       BUDGET.......16300
      P1FPOS = 0D0                                                       BUDGET.......16400
      P1FNEG = 0D0                                                       BUDGET.......16500
      P1SPOS = 0D0                                                       BUDGET.......16600
      P1SNEG = 0D0                                                       BUDGET.......16700
      P0FPOS = 0D0                                                       BUDGET.......16800
      P0FNEG = 0D0                                                       BUDGET.......16900
      P0SPOS = 0D0                                                       BUDGET.......17000
      P0SNEG = 0D0                                                       BUDGET.......17100
      QQUPOS = 0D0                                                       BUDGET.......17200
      QQUNEG = 0D0                                                       BUDGET.......17300
      QIUPOS = 0D0                                                       BUDGET.......17400
      QIUNEG = 0D0                                                       BUDGET.......17500
C.....SET ADSORPTION PARAMETERS                                          BUDGET.......17600
      IF(ME.EQ.-1.AND.ADSMOD.NE.'NONE      ')                            BUDGET.......17700
     1   CALL ADSORB(CS1,CS2,CS3,SL,SR,UVEC)                             BUDGET.......17800
c rbw begin change
         if (IErrorFlag.ne.0) then
           return
         endif
c rbw end change
      DO 1300 I=1,NN                                                     BUDGET.......17900
      ESRV=POR(I)*SW(I)*RHO(I)*VOL(I)                                    BUDGET.......18000
      EPRSV=(1.D0-POR(I))*RHOS*VOL(I)                                    BUDGET.......18100
      DUDT=(1-ISSTRA)*(UVEC(I)-UM1(I))/DELTU                             BUDGET.......18200
      TERM = ESRV*CW*DUDT                                                BUDGET.......18300
      FLDPOS = FLDPOS + MAX(0D0, TERM)                                   BUDGET.......18400
      FLDNEG = FLDNEG + MIN(0D0, TERM)                                   BUDGET.......18500
      TERM = EPRSV*CS1(I)*DUDT                                           BUDGET.......18600
      SLDPOS = SLDPOS + MAX(0D0, TERM)                                   BUDGET.......18700
      SLDNEG = SLDNEG + MIN(0D0, TERM)                                   BUDGET.......18800
      TERM = CW*UVEC(I)*(1-ISSFLO/2)*VOL(I)*                             BUDGET.......18900
     1   (RHO(I)*(SW(I)*SOP(I)+POR(I)*DSWDP(I))*DPDTITR(I)               BUDGET.......19000
     2   +POR(I)*SW(I)*DRWDU*(UM1(I)-UM2(I))/DLTUM1)                     BUDGET.......19100
      DNSPOS = DNSPOS + MAX(0D0, TERM)                                   BUDGET.......19200
      DNSNEG = DNSNEG + MIN(0D0, TERM)                                   BUDGET.......19300
      TERM = ESRV*PRODF1*UVEC(I)                                         BUDGET.......19400
      P1FPOS = P1FPOS + MAX(0D0, TERM)                                   BUDGET.......19500
      P1FNEG = P1FNEG + MIN(0D0, TERM)                                   BUDGET.......19600
      TERM = EPRSV*PRODS1*(SL(I)*UVEC(I)+SR(I))                          BUDGET.......19700
      P1SPOS = P1SPOS + MAX(0D0, TERM)                                   BUDGET.......19800
      P1SNEG = P1SNEG + MIN(0D0, TERM)                                   BUDGET.......19900
      TERM = ESRV*PRODF0                                                 BUDGET.......20000
      P0FPOS = P0FPOS + MAX(0D0, TERM)                                   BUDGET.......20100
      P0FNEG = P0FNEG + MIN(0D0, TERM)                                   BUDGET.......20200
      TERM = EPRSV*PRODS0                                                BUDGET.......20300
      P0SPOS = P0SPOS + MAX(0D0, TERM)                                   BUDGET.......20400
      P0SNEG = P0SNEG + MIN(0D0, TERM)                                   BUDGET.......20500
      TERM = QUIN(I)                                                     BUDGET.......20600
      QQUPOS = QQUPOS + MAX(0D0, TERM)                                   BUDGET.......20700
      QQUNEG = QQUNEG + MIN(0D0, TERM)                                   BUDGET.......20800
      IF (QINITR(I).LE.0D0) THEN                                         BUDGET.......20900
         TERM = QINITR(I)*CW*UVEC(I)                                     BUDGET.......21000
      ELSE                                                               BUDGET.......21100
         TERM = QINITR(I)*CW*UIN(I)                                      BUDGET.......21200
      END IF                                                             BUDGET.......21300
      QIUPOS = QIUPOS + MAX(0D0, TERM)                                   BUDGET.......21400
      QIUNEG = QIUNEG + MIN(0D0, TERM)                                   BUDGET.......21500
 1300 CONTINUE                                                           BUDGET.......21600
      FLDTOT = FLDPOS + FLDNEG                                           BUDGET.......21700
      SLDTOT = SLDPOS + SLDNEG                                           BUDGET.......21800
      DNSTOT = DNSPOS + DNSNEG                                           BUDGET.......21900
      STSPOS = FLDPOS + SLDPOS + DNSPOS                                  BUDGET.......22000
      STSNEG = FLDNEG + SLDNEG + DNSNEG                                  BUDGET.......22100
      STSTOT = FLDTOT + SLDTOT + DNSTOT                                  BUDGET.......22200
      P1FTOT = P1FPOS + P1FNEG                                           BUDGET.......22300
      P1STOT = P1SPOS + P1SNEG                                           BUDGET.......22400
      P0FTOT = P0FPOS + P0FNEG                                           BUDGET.......22500
      P0STOT = P0SPOS + P0SNEG                                           BUDGET.......22600
      PRSPOS = P1FPOS + P1SPOS + P0FPOS + P0SPOS                         BUDGET.......22700
      PRSNEG = P1FNEG + P1SNEG + P0FNEG + P0SNEG                         BUDGET.......22800
      PRSTOT = P1FTOT + P1STOT + P0FTOT + P0STOT                         BUDGET.......22900
      QQUTOT = QQUPOS + QQUNEG                                           BUDGET.......23000
      QIUTOT = QIUPOS + QIUNEG                                           BUDGET.......23100
C                                                                        BUDGET.......23200
      QPUPOS = 0D0                                                       BUDGET.......23300
      QPUNEG = 0D0                                                       BUDGET.......23400
      DO 1500 IP=1,NPBC                                                  BUDGET.......23500
      IF (QPLITR(IP).LE.0D0) THEN                                        BUDGET.......23600
         I=IABS(IPBC(IP))                                                BUDGET.......23700
         TERM = QPLITR(IP)*CW*UVEC(I)                                    BUDGET.......23800
      ELSE                                                               BUDGET.......23900
         TERM = QPLITR(IP)*CW*UBC(IP)                                    BUDGET.......24000
      END IF                                                             BUDGET.......24100
      QPUPOS = QPUPOS + MAX(0D0, TERM)                                   BUDGET.......24200
      QPUNEG = QPUNEG + MIN(0D0, TERM)                                   BUDGET.......24300
 1500 CONTINUE                                                           BUDGET.......24400
      QPUTOT = QPUPOS + QPUNEG                                           BUDGET.......24500
C                                                                        BUDGET.......24600
      QULPOS = 0D0                                                       BUDGET.......24700
      QULNEG = 0D0                                                       BUDGET.......24800
      QULTOT = 0D0                                                       BUDGET.......24900
      IF(NUBC.EQ.0) GOTO 1520                                            BUDGET.......25000
      DO 1510 IU=1,NUBC                                                  BUDGET.......25100
      IUP=IU+NPBC                                                        BUDGET.......25200
      I=IABS(IUBC(IUP))                                                  BUDGET.......25300
      QPLITR(IUP)=GNUU*(UBC(IUP)-UVEC(I))                                BUDGET.......25400
      TERM = QPLITR(IUP)                                                 BUDGET.......25500
      QULPOS = QULPOS + MAX(0D0, TERM)                                   BUDGET.......25600
      QULNEG = QULNEG + MIN(0D0, TERM)                                   BUDGET.......25700
 1510 CONTINUE                                                           BUDGET.......25800
 1520 QULTOT = QULPOS + QULNEG                                           BUDGET.......25900
      QFSPOS = QIUPOS + QPUPOS + QQUPOS + QULPOS                         BUDGET.......26000
      QFSNEG = QIUNEG + QPUNEG + QQUNEG + QULNEG                         BUDGET.......26100
      QFSTOT = QIUTOT + QPUTOT + QQUTOT + QULTOT                         BUDGET.......26200
C                                                                        BUDGET.......26300
 1540 IF(ME) 1550,1550,1615                                              BUDGET.......26400
C                                                                        BUDGET.......26500
C.....OUTPUT SOLUTE MASS BUDGET                                          BUDGET.......26600
 1550 ACTSMB = 5D-1*(STSPOS - STSNEG + PRSPOS - PRSNEG                   BUDGET.......26700
     1   + QFSPOS - QFSNEG)                                              BUDGET.......26800
      ERSMBA = STSTOT - PRSTOT - QFSTOT                                  BUDGET.......26900
c rbw begin change
c      WRITE(K3,1600) IT,FLDPOS,FLDNEG,FLDTOT,SLDPOS,SLDNEG,SLDTOT,       BUDGET.......27000
c     1   DNSPOS,DNSNEG,DNSTOT,STSPOS,STSNEG,STSTOT,                      BUDGET.......27100
c     2   P1FPOS,P1FNEG,P1FTOT,P1SPOS,P1SNEG,P1STOT,                      BUDGET.......27200
c     3   P0FPOS,P0FNEG,P0FTOT,P0SPOS,P0SNEG,P0STOT,PRSPOS,PRSNEG,PRSTOT, BUDGET.......27300
c     4   QIUPOS,QIUNEG,QIUTOT,QPUPOS,QPUNEG,QPUTOT,                      BUDGET.......27400
c     5   QQUPOS,QQUNEG,QQUTOT,QULPOS,QULNEG,QULTOT,QFSPOS,QFSNEG,QFSTOT, BUDGET.......27500
c     6   ACTSMB,ERSMBA                                                   BUDGET.......27600
c rbw end change
 1600 FORMAT(//11X,'S O L U T E   B U D G E T      AFTER TIME STEP ',I8, BUDGET.......27700
     1   ',   IN (SOLUTE MASS/SECOND)'                                   BUDGET.......27800
     2   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'INCREASES(+)',4X,    BUDGET.......27900
     3   'DECREASES(-)',7X,'CHANGE'/84X,3(2X,14('='))                    BUDGET.......28000
     4   /13X,'RATE OF CHANGE IN SOLUTE DUE TO CONCENTRATION CHANGE',    BUDGET.......28100
     5   19X,3(1X,1PE15.7)                                               BUDGET.......28200
     6   /13X,'RATE OF CHANGE OF ADSORBATE',44X,3(1X,1PE15.7)            BUDGET.......28300
     7   /13X,'RATE OF CHANGE IN SOLUTE DUE TO CHANGE IN MASS OF FLUID', BUDGET.......28400
     8   16X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......28500
     9   /13X,'TOTAL RATE OF CHANGE OF SOLUTE [ S+, S-, S ]',            BUDGET.......28600
     T   27X,3(1X,1PE15.7)                                               BUDGET.......28700
     1   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'PRODUCTION(+)',5X,   BUDGET.......28800
     2   'DECAY(-)',7X,'PROD./DECAY'/84X,3(2X,14('='))                   BUDGET.......28900
     3   /13X,'FIRST-ORDER PRODUCTION/DECAY OF SOLUTE',33X,3(1X,1PE15.7) BUDGET.......29000
     4   /13X,'FIRST-ORDER PRODUCTION/DECAY OF ADSORBATE',               BUDGET.......29100
     5   30X,3(1X,1PE15.7)                                               BUDGET.......29200
     6   /13X,'ZERO-ORDER PRODUCTION/DECAY OF SOLUTE',34X,3(1X,1PE15.7)  BUDGET.......29300
     7   /13X,'ZERO-ORDER PRODUCTION/DECAY OF ADSORBATE',                BUDGET.......29400
     8   31X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......29500
     9   /13X,'TOTAL RATE OF PRODUCTION/DECAY OF SOLUTE AND ADSORBATE',  BUDGET.......29600
     T   ' [ P+, P-, P ]',3X,3(1X,1PE15.7)                               BUDGET.......29700
     1   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/89X,'GAINS(+)',7X,        BUDGET.......29800
     2   'LOSSES(-)',7X,'GAIN/LOSS'/84X,3(2X,14('='))                    BUDGET.......29900
     3   /13X,'GAIN/LOSS OF SOLUTE THROUGH FLUID SOURCES AND SINKS',     BUDGET.......30000
     4   20X,3(1X,1PE15.7)                                               BUDGET.......30100
     5   /13X,'GAIN/LOSS OF SOLUTE THROUGH INFLOWS/OUTFLOWS AT'          BUDGET.......30200
     6   ' SPECIFIED P NODES',6X,3(1X,1PE15.7)                           BUDGET.......30300
     7   /13X,'GAIN/LOSS OF SOLUTE THROUGH SOLUTE SOURCES AND SINKS',    BUDGET.......30400
     8   19X,3(1X,1PE15.7)                                               BUDGET.......30500
     9   /13X,'GAIN/LOSS OF SOLUTE AT SPECIFIED CONCENTRATION NODES',    BUDGET.......30600
     T   19X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......30700
     1   /13X,'TOTAL RATE OF GAIN/LOSS OF SOLUTE',38X,3(1X,1PE15.7)      BUDGET.......30800
     2   /16X,' THROUGH FLOWS & SOURCES/SINKS [ F+, F-, F ]'             BUDGET.......30900
     3   ///13X,'SOLUTE MASS BAL. ACTIVITY [ A = ((S+) - (S-)',          BUDGET.......31000
     4   ' + (P+) - (P-) + (F+) - (F-))/2 ]',2X,1PE15.7                  BUDGET.......31100
     5   /13X,'ABSOLUTE SOLUTE MASS BALANCE ERROR [ S - P - F ]',        BUDGET.......31200
     6   31X,1PE15.7)                                                    BUDGET.......31300
      IF (ACTSMB.NE.0D0) THEN                                            BUDGET.......31400
         ERSMBR = 1D2*ERSMBA/ACTSMB                                      BUDGET.......31500
c rbw begin change
c         WRITE(K3,1601) ERSMBR                                           BUDGET.......31600
c      ELSE                                                               BUDGET.......31700
c         WRITE(K3,1602)                                                  BUDGET.......31800
c rbw end change
      END IF                                                             BUDGET.......31900
 1601 FORMAT(13X,'RELATIVE SOLUTE MASS BALANCE ERROR',                   BUDGET.......32000
     1   ' [ 100*(S - P - F)/A ]',23X,1PE15.7,' (PERCENT)')              BUDGET.......32100
 1602 FORMAT(13X,'RELATIVE SOLUTE MASS BALANCE ERROR',                   BUDGET.......32200
     1   ' [ 100*(S - P - F)/A ]',23X,'  UNDEFINED')                     BUDGET.......32300
      GOTO 1645                                                          BUDGET.......32400
C                                                                        BUDGET.......32500
C.....OUTPUT ENERGY BUDGET                                               BUDGET.......32600
 1615 ACTSMB = 5D-1*(STSPOS - STSNEG + PRSPOS - PRSNEG                   BUDGET.......32700
     1   + QFSPOS - QFSNEG)                                              BUDGET.......32800
      ERSMBA = STSTOT - PRSTOT - QFSTOT                                  BUDGET.......32900
c rbw begin change
c      WRITE(K3,1635) IT,FLDPOS,FLDNEG,FLDTOT,SLDPOS,SLDNEG,SLDTOT,       BUDGET.......33000
c     1   DNSPOS,DNSNEG,DNSTOT,STSPOS,STSNEG,STSTOT,                      BUDGET.......33100
c     2   P0FPOS,P0FNEG,P0FTOT,P0SPOS,P0SNEG,P0STOT,PRSPOS,PRSNEG,PRSTOT, BUDGET.......33200
c     3   QIUPOS,QIUNEG,QIUTOT,QPUPOS,QPUNEG,QPUTOT,                      BUDGET.......33300
c     4   QQUPOS,QQUNEG,QQUTOT,QULPOS,QULNEG,QULTOT,QFSPOS,QFSNEG,QFSTOT, BUDGET.......33400
c     5   ACTSMB,ERSMBA                                                   BUDGET.......33500
c rbw end change
 1635 FORMAT(//11X,'E N E R G Y   B U D G E T      AFTER TIME STEP ',I8, BUDGET.......33600
     1   ',   IN (ENERGY/SECOND)'                                        BUDGET.......33700
     2   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'INCREASES(+)',4X,    BUDGET.......33800
     3   'DECREASES(-)',7X,'CHANGE'/84X,3(2X,14('='))                    BUDGET.......33900
     4   /13X,'RATE OF CHANGE OF ENERGY IN FLUID DUE TO TEMPERATURE',    BUDGET.......34000
     5   ' CHANGE',12X,3(1X,1PE15.7)                                     BUDGET.......34100
     6   /13X,'RATE OF CHANGE OF ENERGY IN SOLID GRAINS',                BUDGET.......34200
     7   31X,3(1X,1PE15.7)                                               BUDGET.......34300
     8   /13X,'RATE OF CHANGE OF ENERGY DUE TO CHANGE IN MASS OF FLUID', BUDGET.......34400
     9   16X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......34500
     T   /13X,'TOTAL RATE OF CHANGE OF ENERGY [ S+, S-, S ]',            BUDGET.......34600
     1   27X,3(1X,1PE15.7)                                               BUDGET.......34700
     2   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/87X,'PRODUCTION(+)',5X,   BUDGET.......34800
     3   'DECAY(-)',7X,'PROD./DECAY'/84X,3(2X,14('='))                   BUDGET.......34900
     4   /13X,'ZERO-ORDER PRODUCTION/DECAY OF ENERGY IN FLUID',          BUDGET.......35000
     5   25X,3(1X,1PE15.7)                                               BUDGET.......35100
     6   /13X,'ZERO-ORDER PRODUCTION/DECAY OF ENERGY IN SOLID GRAINS',   BUDGET.......35200
     7   18X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......35300
     8   /13X,'TOTAL RATE OF PRODUCTION/DECAY OF ENERGY',                BUDGET.......35400
     9   ' [ P+, P-, P ]',17X,3(1X,1PE15.7)                              BUDGET.......35500
     T   //89X,'SUM OF',10X,'SUM OF',12X,'NET'/89X,'GAINS(+)',7X,        BUDGET.......35600
     1   'LOSSES(-)',7X,'GAIN/LOSS'/84X,3(2X,14('='))                    BUDGET.......35700
     2   /13X,'GAIN/LOSS OF ENERGY THROUGH FLUID SOURCES AND SINKS',     BUDGET.......35800
     3   20X,3(1X,1PE15.7)                                               BUDGET.......35900
     4   /13X,'GAIN/LOSS OF ENERGY THROUGH INFLOWS/OUTFLOWS AT'          BUDGET.......36000
     5   ' SPECIFIED P NODES',6X,3(1X,1PE15.7)                           BUDGET.......36100
     6   /13X,'GAIN/LOSS OF ENERGY THROUGH ENERGY SOURCES AND SINKS',    BUDGET.......36200
     7   19X,3(1X,1PE15.7)                                               BUDGET.......36300
     8   /13X,'GAIN/LOSS OF ENERGY AT SPECIFIED TEMPERATURE NODES',      BUDGET.......36400
     9   21X,3(1X,1PE15.7)/84X,3(2X,14('-'))                             BUDGET.......36500
     T   /13X,'TOTAL RATE OF GAIN/LOSS OF ENERGY',38X,3(1X,1PE15.7)      BUDGET.......36600
     1   /16X,' THROUGH FLOWS & SOURCES/SINKS [ F+, F-, F ]'             BUDGET.......36700
     2   ///13X,'ENERGY BALANCE ACTIVITY [ A = ((S+) - (S-)',            BUDGET.......36800
     3   ' + (P+) - (P-) + (F+) - (F-))/2 ]',4X,1PE15.7                  BUDGET.......36900
     4   /13X,'ABSOLUTE ENERGY BALANCE ERROR [ S - P - F ]',             BUDGET.......37000
     5   36X,1PE15.7)                                                    BUDGET.......37100
      IF (ACTSMB.NE.0D0) THEN                                            BUDGET.......37200
         ERSMBR = 1D2*ERSMBA/ACTSMB                                      BUDGET.......37300
c rbw begin change
c         WRITE(K3,1641) ERSMBR                                           BUDGET.......37400
c      ELSE                                                               BUDGET.......37500
c         WRITE(K3,1642)                                                  BUDGET.......37600
c rbw end change
      END IF                                                             BUDGET.......37700
 1641 FORMAT(13X,'RELATIVE ENERGY BALANCE ERROR',                        BUDGET.......37800
     1   ' [ 100*(S - P - F)/A ]',28X,1PE15.7,' (PERCENT)')              BUDGET.......37900
 1642 FORMAT(13X,'RELATIVE ENERGY BALANCE ERROR',                        BUDGET.......38000
     1   ' [ 100*(S - P - F)/A ]',28X,'  UNDEFINED')                     BUDGET.......38100
C                                                                        BUDGET.......38200
c rbw begin change
 1645 continue
c 1645 IF ((IT.EQ.1).AND.(ITER.EQ.1).AND.(ISSTRA.NE.1)) WRITE(K3,1646)    BUDGET.......38300
c rbw end change
 1646 FORMAT(/13X,'******** NOTE: ON THE FIRST ITERATION OF THE ',       BUDGET.......38400
     1   'FIRST TIME STEP, A LARGE RELATIVE ERROR IN THE  ********'      BUDGET.......38500
     2   /13X,'******** SOLUTE MASS OR ENERGY BUDGET DOES NOT ',         BUDGET.......38600
     3   'NECESSARILY INDICATE AN INACCURATE TRANSPORT  ********'        BUDGET.......38700
     4   /13X,'******** SOLUTION. THE BUDGET CALCULATION WILL ',         BUDGET.......38800
     5   'NOT YIELD A MEANINGFUL RESULT UNLESS THE      ********'        BUDGET.......38900
     6   /13X,'******** INITIAL CONDITIONS REPRESENT MUTUALLY ',         BUDGET.......39000
     7   'CONSISTENT SOLUTIONS FOR FLOW AND TRANSPORT   ********'        BUDGET.......39100
     8   /13X,'******** FROM A PREVIOUS SUTRA SIMULATION THAT ',         BUDGET.......39200
     9   'ARE ALSO CONSISTENT WITH THE PRESENT SOURCES  ********'        BUDGET.......39300
     T   /13X,'******** AND BOUNDARY CONDITIONS.',60X,'********')        BUDGET.......39400
C                                                                        BUDGET.......39500
      NSOPI=NSOP-1                                                       BUDGET.......39600
      IF(NSOPI.EQ.0) GOTO 2000                                           BUDGET.......39700
c rbw begin change
c      IF(ME) 1649,1649,1659                                              BUDGET.......39800
c 1649 WRITE(K3,1650)                                                     BUDGET.......39900
c 1650 FORMAT(///22X,'SOLUTE SOURCES OR SINKS AT FLUID SOURCES AND ',     BUDGET.......40000
c     1   'SINKS'//22X,' NODE',8X,'SOURCE(+)/SINK(-)'/32X,                BUDGET.......40100
c     2   '(SOLUTE MASS/SECOND)'/)                                        BUDGET.......40200
c      GOTO 1680                                                          BUDGET.......40300
c 1659 WRITE(K3,1660)                                                     BUDGET.......40400
c 1660 FORMAT(///22X,'ENERGY SOURCES OR SINKS AT FLUID SOURCES AND ',     BUDGET.......40500
c     1   'SINKS'//22X,' NODE',8X,'SOURCE(+)/SINK(-)'/37X,                BUDGET.......40600
c     2   '(ENERGY/SECOND)'/)                                             BUDGET.......40700
c rbw end change
 1680 DO 1900 IQP=1,NSOPI                                                BUDGET.......40800
      I=IABS(IQSOP(IQP))                                                 BUDGET.......40900
      IF(QINITR(I)) 1700,1700,1750                                       BUDGET.......41000
 1700 QU=QINITR(I)*CW*UVEC(I)                                            BUDGET.......41100
      GOTO 1800                                                          BUDGET.......41200
 1750 QU=QINITR(I)*CW*UIN(I)                                             BUDGET.......41300
c rbw begin change
 1800 continue
c 1800 WRITE(K3,450) I,QU                                                 BUDGET.......41400
c rbw end change
 1900 CONTINUE                                                           BUDGET.......41500
C                                                                        BUDGET.......41600
 2000 IF(NPBC.EQ.0) GOTO 4500                                            BUDGET.......41700
c rbw begin change
c      IF(ME) 2090,2090,2150                                              BUDGET.......41800
c 2090 WRITE(K3,2100)                                                     BUDGET.......41900
c 2100 FORMAT(///22X,'SOLUTE SOURCES OR SINKS DUE TO FLUID INFLOWS OR ',  BUDGET.......42000
c     1   'OUTFLOWS AT POINTS OF SPECIFIED PRESSURE'//22X,' NODE',8X,     BUDGET.......42100
c     2   'SOURCE(+)/SINK(-)'/32X,'(SOLUTE MASS/SECOND)'/)                BUDGET.......42200
c      GOTO 2190                                                          BUDGET.......42300
c 2150 WRITE(K3,2160)                                                     BUDGET.......42400
c 2160 FORMAT(///22X,'ENERGY SOURCES OR SINKS DUE TO FLUID INFLOWS OR ',  BUDGET.......42500
c     1   'OUTFLOWS AT POINTS OF SPECIFIED PRESSURE'//22X,' NODE',8X,     BUDGET.......42600
c     2   'SOURCE(+)/SINK(-)'/37X,'(ENERGY/SECOND)'/)                     BUDGET.......42700
c rbw end change
 2190 DO 2400 IP=1,NPBC                                                  BUDGET.......42800
      I=IABS(IPBC(IP))                                                   BUDGET.......42900
      IF(QPLITR(IP)) 2200,2200,2250                                      BUDGET.......43000
 2200 QPU=QPLITR(IP)*CW*UVEC(I)                                          BUDGET.......43100
      GOTO 2300                                                          BUDGET.......43200
 2250 QPU=QPLITR(IP)*CW*UBC(IP)                                          BUDGET.......43300
c rbw begin change
 2300 continue
c 2300 WRITE(K3,450) I,QPU                                                BUDGET.......43400
c rbw end change
 2400 CONTINUE                                                           BUDGET.......43500
C                                                                        BUDGET.......43600
      IF(IBCT.EQ.4) GOTO 4500                                            BUDGET.......43700
      NSOUI=NSOU-1                                                       BUDGET.......43800
      INEGCT=0                                                           BUDGET.......43900
      DO 3500 IQU=1,NSOUI                                                BUDGET.......44000
      I=IQSOU(IQU)                                                       BUDGET.......44100
      IF(I) 3400,3500,3500                                               BUDGET.......44200
 3400 INEGCT=INEGCT+1                                                    BUDGET.......44300
c rbw begin change
c      IF(ME) 3450,3450,3460                                              BUDGET.......44400
c 3450 IF(INEGCT.EQ.1) WRITE(K3,3455)                                     BUDGET.......44500
c 3455 FORMAT(///22X,'TIME-DEPENDENT SOLUTE SOURCES AND SINKS'//22X,      BUDGET.......44600
c     1   ' NODE',10X,'GAIN(+)/LOSS(-)'/30X,'  (SOLUTE MASS/SECOND)'//)   BUDGET.......44700
c      GOTO 3475                                                          BUDGET.......44800
c 3460 IF(INEGCT.EQ.1) WRITE(K3,3465)                                     BUDGET.......44900
c 3465 FORMAT(///22X,'TIME-DEPENDENT ENERGY SOURCES AND SINKS'//22X,      BUDGET.......45000
c     1   ' NODE',10X,'GAIN(+)/LOSS(-)'/35X,'  (ENERGY/SECOND)'//)        BUDGET.......45100
c rbw end change
 3475 CONTINUE                                                           BUDGET.......45200
c rbw begin change
c      WRITE(K3,3490) -I,QUIN(-I)                                         BUDGET.......45300
c rbw end change
 3490 FORMAT(22X,I9,10X,1PE15.7)                                         BUDGET.......45400
 3500 CONTINUE                                                           BUDGET.......45500
C                                                                        BUDGET.......45600
 4500 IF(NUBC.EQ.0) GOTO 5500                                            BUDGET.......45700
c rbw begin change
c      IF(ME) 4600,4600,4655                                              BUDGET.......45800
c 4600 WRITE(K3,4650)                                                     BUDGET.......45900
c 4650 FORMAT(///22X,'SOLUTE SOURCES OR SINKS DUE TO SPECIFIED ',         BUDGET.......46000
c     1   'CONCENTRATIONS'//22X,' NODE',10X,'GAIN(+)/LOSS(-)'/30X,        BUDGET.......46100
c     2   '  (SOLUTE MASS/SECOND)'/)                                      BUDGET.......46200
c      GOTO 4690                                                          BUDGET.......46300
c 4655 WRITE(K3,4660)                                                     BUDGET.......46400
c 4660 FORMAT(///22X,'ENERGY SOURCES OR SINKS DUE TO SPECIFIED ',         BUDGET.......46500
c     1   'TEMPERATURES'//22X,' NODE',10X,'GAIN(+)/LOSS(-)'/35X,          BUDGET.......46600
c     2   '  (ENERGY/SECOND)'/)                                           BUDGET.......46700
c rbw end change
 4690 CONTINUE                                                           BUDGET.......46800
      DO 4700 IU=1,NUBC                                                  BUDGET.......46900
      IUP=IU+NPBC                                                        BUDGET.......47000
      I=IABS(IUBC(IUP))                                                  BUDGET.......47100
c rbw begin change
c      WRITE(K3,450) I,QPLITR(IUP)                                        BUDGET.......47200
c rbw end change
 4700 CONTINUE                                                           BUDGET.......47300
C                                                                        BUDGET.......47400
C                                                                        BUDGET.......47500
 5500 CONTINUE                                                           BUDGET.......47600
C                                                                        BUDGET.......47700
      RETURN                                                             BUDGET.......47800
      END                                                                BUDGET.......47900
C                                                                        BUDGET.......48000
C     SUBROUTINE        C  O  N  N  E  C           SUTRA VERSION 2.1     CONNEC.........100
C                                                                        CONNEC.........200
C *** PURPOSE :                                                          CONNEC.........300
C ***  TO READ, ORGANIZE, AND CHECK DATA ON NODE INCIDENCES.             CONNEC.........400
C                                                                        CONNEC.........500
      SUBROUTINE CONNEC(IN)                                              CONNEC.........600
c rbw begin change
      use ErrorFlag
c rbw end chagne
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                CONNEC.........700
      CHARACTER INTFIL*1000                                              CONNEC.........800
      CHARACTER CDUM10*10                                                CONNEC.........900
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:8)                     CONNEC........1000
      DIMENSION IN(NIN)                                                  CONNEC........1100
      DIMENSION IIN(8)                                                   CONNEC........1200
      DIMENSION INERR(10),RLERR(10)                                      CONNEC........1300
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              CONNEC........1400
     1   NSOP,NSOU,NBCN                                                  CONNEC........1500
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        CONNEC........1600
      COMMON /FNAMES/ UNAME,FNAME                                        CONNEC........1700
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     CONNEC........1800
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     CONNEC........1900
     1   KSCRN,KPAUSE                                                    CONNEC........2000
C                                                                        CONNEC........2100
      IPIN=0                                                             CONNEC........2200
c rbw begin change
c      IF(KINCID.EQ.0) WRITE(K3,1)                                        CONNEC........2300
c    1 FORMAT('1'////11X,'M E S H   C O N N E C T I O N   D A T A'//      CONNEC........2400
c     1   16X,'PRINTOUT OF NODAL INCIDENCES CANCELLED.')                  CONNEC........2500
c      IF(KINCID.EQ.+1) WRITE(K3,2)                                       CONNEC........2600
c    2 FORMAT('1'////11X,'M E S H   C O N N E C T I O N   D A T A',       CONNEC........2700
c     1   ///11X,'**** NODAL INCIDENCES ****'///)                         CONNEC........2800
c rbw end change
C                                                                        CONNEC........2900
C.....INPUT DATASET 22 AND CHECK FOR ERRORS                              CONNEC........3000
      ERRCOD = 'REA-INP-22'                                              CONNEC........3100
      CALL READIF(K1, INTFIL, ERRCOD)                                    CONNEC........3200
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 155
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10                              CONNEC........3300
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        CONNEC........3400
      IF (INERR(1).NE.0) then
        IErrorFlag = 33
        return
      endif
c rbw end change
      IF (CDUM10.NE.'INCIDENCE ') THEN                                   CONNEC........3500
c rbw begin change
        IErrorFlag = 34
        return
c         ERRCOD = 'INP-22-1'                                             CONNEC........3600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        CONNEC........3700
c rbw end change
      END IF                                                             CONNEC........3800
      DO 1000 L=1,NE                                                     CONNEC........3900
      ERRCOD = 'REA-INP-22'                                              CONNEC........4000
      CALL READIF(K1, INTFIL, ERRCOD)                                    CONNEC........4100
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 156
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) LL,(IIN(II),II=1,N48)               CONNEC........4200
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        CONNEC........4300
      IF (INERR(1).NE.0) then
        IErrorFlag = 35
        return
      endif
c rbw end change
C.....PREPARE NODE INCIDENCE LIST FOR MESH, IN.                          CONNEC........4400
      DO 5 II=1,N48                                                      CONNEC........4500
      III=II+(L-1)*N48                                                   CONNEC........4600
    5 IN(III)=IIN(II)                                                    CONNEC........4700
      IF(IABS(LL).EQ.L) GOTO 500                                         CONNEC........4800
c rbw begin change
        IErrorFlag = 36
        return
c      ERRCOD = 'INP-22-2'                                                CONNEC........4900
c      INERR(1) = LL                                                      CONNEC........5000
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           CONNEC........5100
c rbw end change
C                                                                        CONNEC........5200
C                                                                        CONNEC........5300
  500 M1=(L-1)*N48+1                                                     CONNEC........5400
      M8=M1+N48-1                                                        CONNEC........5500
      IF(KINCID.EQ.0) GOTO 1000                                          CONNEC........5600
c rbw begin change
c      WRITE(K3,650) L,(IN(M),M=M1,M8)                                    CONNEC........5700
c rbw end change
  650 FORMAT(11X,'ELEMENT',I9,5X,' NODES AT : ',6X,'CORNERS ',           CONNEC........5800
     1   5('*'),8I9,1X,5('*'))                                           CONNEC........5900
C                                                                        CONNEC........6000
 1000 CONTINUE                                                           CONNEC........6100
C                                                                        CONNEC........6200
C                                                                        CONNEC........6300
 5000 RETURN                                                             CONNEC........6400
      END                                                                CONNEC........6500
C                                                                        CONNEC........6600
C     FUNCTION          C  U  T  S  M  L           SUTRA VERSION 2.1     CUTSML.........100
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
C     SUBROUTINE        D  I  M  W  R  K           SUTRA VERSION 2.1     DIMWRK.........100
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
C     SUBROUTINE        D  I  S  P  R  3           SUTRA VERSION 2.1     DISPR3.........100
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
C                                                                        DISPR3.......22600
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
      RETURN                                                             DISPR3.......22700
      END                                                                DISPR3.......22800
C                                                                        DISPR3.......22900
C     FUNCTION          D  P  3  S  T  R           SUTRA VERSION 2.1     DP3STR.........100
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
C     SUBROUTINE        E  L  E  M  N  2           SUTRA VERSION 2.1     ELEMN2.........100
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
C      SUBROUTINE ELEMN2(ML,IN,X,Y,THICK,PITER,UITER,RCIT,RCITM1,POR,     ELEMN2........1400
C     1   ALMAX,ALMIN,ATMAX,ATMIN,PERMXX,PERMXY,PERMYX,PERMYY,PANGLE,     ELEMN2........1500
C     2   VMAG,VANG,VOL,PMAT,PVEC,UMAT,UVEC,GXSI,GETA,PVEL,LREG,IA,JA)    ELEMN2........1600
c rbw end change
C     SUBROUTINE        E  L  E  M  N  3           SUTRA VERSION 2.1     ELEMN3.........100
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
c      SUBROUTINE ELEMN3(ML,IN,X,Y,Z,PITER,UITER,RCIT,RCITM1,POR,         ELEMN3........1400
c     1   ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,                            ELEMN3........1500
c     2   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ, ELEMN3........1600
c     3   PANGL1,PANGL2,PANGL3,VMAG,VANG1,VANG2,VOL,PMAT,PVEC,            ELEMN3........1700
c     4   UMAT,UVEC,GXSI,GETA,GZET,PVEL,LREG,IA,JA)                       ELEMN3........1800
c rbw end change
C     SUBROUTINE        F  I  N  D  L  2           SUTRA VERSION 2.1     FINDL2.........100
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
     1   NSOP,NSOU,NBCN                                                  FINDL2........1300
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
C     SUBROUTINE        F  I  N  D  L  3           SUTRA VERSION 2.1     FINDL3.........100
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
     1   NSOP,NSOU,NBCN                                                  FINDL3........1300
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
C     SUBROUTINE        F  O  P  E  N              SUTRA VERSION 2.1     FOPEN..........100
C                                                                        FOPEN..........200
C *** PURPOSE :                                                          FOPEN..........300
C ***  OPENS FILES FOR SUTRA SIMULATION.  READS AND PROCESSES FILE       FOPEN..........400
C ***  SPECIFICATIONS FROM "SUTRA.FIL" AND OPENS INPUT AND OUTPUT FILES. FOPEN..........500
C                                                                        FOPEN..........600
c RBW begin                                                              FOPEN..........800
c      SUBROUTINE FOPEN()                                                 FOPEN..........700
      SUBROUTINE FOPEN(InputFile)
c RBW end                                                                FOPEN..........804
      USE EXPINT                                                         FOPEN..........800
      USE SCHDEF                                                         FOPEN..........900
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                FOPEN.........1000
      PARAMETER (IUNMIN=11)                                              FOPEN.........1100
      CHARACTER*80 FT,FN,UNAME,FNAME,ENAME,ENDEF,FTSTR                   FOPEN.........1200
      CHARACTER*80 FNROOT,FNEXTN                                         FOPEN.........1300
      CHARACTER*80 ERRCOD,CHERR(10)                                      FOPEN.........1400
      CHARACTER*8 VERNUM, VERNIN                                         FOPEN.........1500
      CHARACTER INTFIL*1000                                              FOPEN.........1600
c RBW begin                                                              FOPEN..........800
      character (len=*) InputFile
c RBW end                                                                FOPEN..........804
      LOGICAL IS                                                         FOPEN.........1700
      LOGICAL EXST                                                       FOPEN.........1800
      LOGICAL ONCEFO                                                     FOPEN.........1900
      DIMENSION FTYPE(0:8),FNAME(0:8),IUNIT(0:8)                         FOPEN.........2000
      DIMENSION FTSTR(0:8)                                               FOPEN.........2100
      DIMENSION INERR(10),RLERR(10)                                      FOPEN.........2200
      COMMON /FNAMES/ UNAME,FNAME                                        FOPEN.........2300
      COMMON /FO/ONCEFO                                                  FOPEN.........2400
      COMMON /FUNITA/ IUNIT                                              FOPEN.........2500
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     FOPEN.........2600
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      FOPEN.........2700
      COMMON /SCH/ NSCH,ISCHTS                                           FOPEN.........2800
      COMMON /VER/ VERNUM, VERNIN                                        FOPEN.........2900
      DATA (FTSTR(NFT),NFT=0,8)/'SMY','INP','ICS','LST','RST',           FOPEN.........3000
     1   'NOD','ELE','OBS','OBC'/                                        FOPEN.........3100
C                                                                        FOPEN.........3200
C.....IF THIS IS THE FIRST PASS, READ AND PROCESS FILE SPECIFICATIONS    FOPEN.........3300
C        FROM "SUTRA.FIL" AND OPEN ALL OUTPUT FILES EXCEPT OBSERVATION   FOPEN.........3400
C        OUTPUT.  OBSERVATION OUTPUT FILES ARE CREATED ON THE SECOND     FOPEN.........3500
C        PASS, AFTER DATASET 8D HAS BEEN READ.                           FOPEN.........3600
      IF (.NOT.ONCEFO) THEN                                              FOPEN.........3700
C                                                                        FOPEN.........3800
C........INITIALIZE UNIT NUMBERS AND FILENAMES                           FOPEN.........3900
         K1 = -1                                                         FOPEN.........4000
         K2 = -1                                                         FOPEN.........4100
         K3 = -1                                                         FOPEN.........4200
         K4 = -1                                                         FOPEN.........4300
         K5 = -1                                                         FOPEN.........4400
         K6 = -1                                                         FOPEN.........4500
         K7 = -1                                                         FOPEN.........4600
         K8 = -1                                                         FOPEN.........4700
         DO 20 NF=0,8                                                    FOPEN.........4800
            IUNIT(NF) = -1                                               FOPEN.........4900
            FNAME(NF) = ""                                               FOPEN.........5000
   20    CONTINUE                                                        FOPEN.........5100
C                                                                        FOPEN.........5200
C........SET DEFAULT VALUES FOR THE SMY FILE.  THE DEFAULT FILE WILL     FOPEN.........5300
C           NOT ACTUALLY BE CREATED UNLESS IT IS NEEDED.                 FOPEN.........5400
         K00 = K0 + 1                                                    FOPEN.........5500
         ENDEF = 'SUTRA.SMY'                                             FOPEN.........5600
C                                                                        FOPEN.........5700
C........OPEN FILE UNIT CONTAINING UNIT NUMBERS AND FILE ASSIGNMENTS     FOPEN.........5800
         IU=K0                                                           FOPEN.........5900
         FN=UNAME                                                        FOPEN.........6000
c         INQUIRE(FILE=UNAME,EXIST=IS)                                    FOPEN.........6100
c         IF (IS) THEN                                                    FOPEN.........6200
c            OPEN(UNIT=IU,FILE=UNAME,STATUS='OLD',FORM='FORMATTED',       FOPEN.........6300
c     1         IOSTAT=KERR)                                              FOPEN.........6400
c            IF(KERR.GT.0) GOTO 9000                                      FOPEN.........6500
c         ELSE                                                            FOPEN.........6600
c            CALL NAFU(K00,0,ENDEF)                                       FOPEN.........6700
c            OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                   FOPEN.........6800
c            GOTO 8000                                                    FOPEN.........6900
c         ENDIF                                                           FOPEN.........7000
C                                                                        FOPEN.........7100
C........READ IN UNIT NUMBERS AND FILE ASSIGNMENTS.  ASSIGN COMPATIBLE   FOPEN.........7200
C           UNIT NUMBERS.  CLOSE UNIT K0.                                FOPEN.........7300
c         NFILE = 0                                                       FOPEN.........7400
c         DO 90 NF=0,8                                                    FOPEN.........7500
C...........READ A FILE SPECIFICATION                                    FOPEN.........7600
c            READ(K0,'(A)',IOSTAT=INERR(1),END=99) INTFIL                 FOPEN.........7700
c            IF (INERR(1).NE.0) THEN                                      FOPEN.........7800
c               CALL NAFU(K00,0,ENDEF)                                    FOPEN.........7900
c               OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                FOPEN.........8000
c               ERRCOD = 'REA-FIL'                                        FOPEN.........8100
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  FOPEN.........8200
c            END IF                                                       FOPEN.........8300
c            IF (VERIFY(INTFIL,' ').EQ.0) GOTO 99                         FOPEN.........8400
c            READ(INTFIL,*,IOSTAT=INERR(1)) FT, IU, FN                    FOPEN.........8500
c            IF (INERR(1).NE.0) THEN                                      FOPEN.........8600
c               CALL NAFU(K00,0,ENDEF)                                    FOPEN.........8700
c               OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                FOPEN.........8800
c               ERRCOD = 'REA-FIL'                                        FOPEN.........8900
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  FOPEN.........9000
c            END IF                                                       FOPEN.........9100
C...........CHECK FOR ILLEGAL SPECIFICATIONS                             FOPEN.........9200
c            IF (FN.EQ.UNAME) THEN                                        FOPEN.........9300
c               CALL NAFU(K00,0,ENDEF)                                    FOPEN.........9400
c               OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                FOPEN.........9500
c               ERRCOD = 'FIL-9'                                          FOPEN.........9600
c               CHERR(1) = UNAME                                          FOPEN.........9700
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  FOPEN.........9800
c            END IF                                                       FOPEN.........9900
C...........IF THE SPECIFIED UNIT NUMBER IS LESS THAN IUNMIN,            FOPEN........10000
C              SET IT TO IUNMIN                                          FOPEN........10100
c            IU = MAX(IU, IUNMIN)                                         FOPEN........10200
C...........STORE THE FILE INFORMATION, CHECKING FOR INVALID AND         FOPEN........10300
C              REPEATED FILE TYPE SPECIFICATIONS AND ASSIGNING UNIT      FOPEN........10400
C              NUMBERS TO NON-OBSERVATION FILES ALONG THE WAY            FOPEN........10500
c            DO 50 NFT=0,8                                                FOPEN........10600
c               IF (FT.EQ.FTSTR(NFT)) THEN                                FOPEN........10700
c                  IF (IUNIT(NFT).EQ.-1) THEN                             FOPEN........10800
c                     IF (NFT.LE.6) CALL NAFU(IU,0,FN)                    FOPEN........10900
c                     IUNIT(NFT) = IU                                     FOPEN........11000
c                     FNAME(NFT) = FN                                     FOPEN........11100
c                     GOTO 60                                             FOPEN........11200
c                  ELSE                                                   FOPEN........11300
c                     CALL NAFU(K00,0,ENDEF)                              FOPEN........11400
c                     OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')          FOPEN........11500
c                     ERRCOD = 'FIL-6'                                    FOPEN........11600
c                     CHERR(1) = UNAME                                    FOPEN........11700
c                     CHERR(2) = FT                                       FOPEN........11800
c                     CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)            FOPEN........11900
c                  END IF                                                 FOPEN........12000
c               END IF                                                    FOPEN........12100
c   50       CONTINUE                                                     FOPEN........12200
c            CALL NAFU(K00,0,ENDEF)                                       FOPEN........12300
c            OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                   FOPEN........12400
c            ERRCOD = 'FIL-5'                                             FOPEN........12500
c            CHERR(1) = UNAME                                             FOPEN........12600
c            CHERR(2) = FT                                                FOPEN........12700
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     FOPEN........12800
c   60       CONTINUE                                                     FOPEN........12900
c   90    CONTINUE                                                        FOPEN........13000
c   99    CLOSE(K0)                                                       FOPEN........13100
C                                                                        FOPEN........13200
C........OPEN THE SMY FILE.                                              FOPEN........13300
C                                                                        FOPEN........13400
C........IF NO SMY SPECIFICATION, USE THE DEFAULT.                       FOPEN........13500
c         IF (IUNIT(0).EQ.-1) THEN                                        FOPEN........13600
c            CALL NAFU(K00,0,ENDEF)                                       FOPEN........13700
c            IUNIT(0) = K00                                               FOPEN........13800
c            FNAME(0) = ENDEF                                             FOPEN........13900
c         END IF                                                          FOPEN........14000
c         IU = IUNIT(0)                                                   FOPEN........14100
c         FN = FNAME(0)                                                   FOPEN........14200
c         OPEN(UNIT=IU,FILE=FN,STATUS='REPLACE',IOSTAT=KERR)              FOPEN........14300
C........IN CASE OF ERROR WHILE OPENING SMY FILE, WRITE ERROR            FOPEN........14400
C           MESSAGE TO DEFAULT FILE                                      FOPEN........14500
c         IF (KERR.GT.0) THEN                                             FOPEN........14600
c            CALL NAFU(K00,0,ENDEF)                                       FOPEN........14700
c            OPEN(UNIT=K00,FILE=ENDEF,STATUS='REPLACE')                   FOPEN........14800
c            GOTO 9000                                                    FOPEN........14900
c         END IF                                                          FOPEN........15000
C........SET K00 AND ENAME                                               FOPEN........15100
c         K00 = IU                                                        FOPEN........15200
c         ENAME = FN                                                      FOPEN........15300
C                                                                        FOPEN........15400
C........CHECK FOR REPEATED FILENAMES (EXCEPT OBS AND OBC FILES)         FOPEN........15500
C           AND MISSING SPECIFICATIONS FOR REQUIRED FILE TYPES           FOPEN........15600
c         DO 260 NF=0,6                                                   FOPEN........15700
c            IF (IUNIT(NF).EQ.-1) THEN                                    FOPEN........15800
c               IF ((NF.GE.1).AND.(NF.LE.4)) THEN                         FOPEN........15900
c                  ERRCOD = 'FIL-7'                                       FOPEN........16000
c                  CHERR(1) = UNAME                                       FOPEN........16100
c                  CHERR(2) = FTSTR(NF)                                   FOPEN........16200
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               FOPEN........16300
c               ELSE                                                      FOPEN........16400
c                  CYCLE                                                  FOPEN........16500
c               END IF                                                    FOPEN........16600
c            END IF                                                       FOPEN........16700
c            DO 250 NF2=NF+1,6                                            FOPEN........16800
c               IF (FNAME(NF2).EQ.FNAME(NF)) THEN                         FOPEN........16900
c                  ERRCOD = 'FIL-4'                                       FOPEN........17000
c                  CHERR(1) = UNAME                                       FOPEN........17100
c                  CHERR(2) = FNAME(NF)                                   FOPEN........17200
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               FOPEN........17300
c               END IF                                                    FOPEN........17400
c  250       CONTINUE                                                     FOPEN........17500
c  260    CONTINUE                                                        FOPEN........17600
C                                                                        FOPEN........17700
C........SET UNIT NUMBERS K1 - K7.  (K00 HAS BEEN SET PREVIOUSLY.)       FOPEN........17800
c RBW begin change
c         K1=IUNIT(1)                                                     FOPEN........17900
c         K2=IUNIT(2)                                                     FOPEN........18000
c         K3=IUNIT(3)                                                     FOPEN........18100
c         K4=IUNIT(4)                                                     FOPEN........18200
c         K5=IUNIT(5)                                                     FOPEN........18300
c         K6=IUNIT(6)                                                     FOPEN........18400
c         K7=IUNIT(7)                                                     FOPEN........18500
c         K8=IUNIT(8)                                                     FOPEN........18600
         K1=50
         K2=0
         K3=0
         K4=0
         K5=0
         K6=0
         K7=0
         NFILE=1
         IUNIT(NFILE)=K1
         FNAME(NFILE)=InputFile
c RBW end change
C                                                                        FOPEN........18700
C........CHECK FOR EXISTENCE OF INPUT FILES AND OPEN INPUT AND OUTPUT    FOPEN........18800
C           FILES (EXCEPT SMY, OBS, AND OBC)                             FOPEN........18900
c RBW begin change
c         DO 300 NF=1,6                                                   FOPEN........19000
         DO 300 NF=1,NFILE                                                   FOPEN........19000
c RBW end change
            IU=IUNIT(NF)                                                 FOPEN........19100
            FN=FNAME(NF)                                                 FOPEN........19200
            IF (IU.EQ.-1) GOTO 300                                       FOPEN........19300
            IF(NF.LE.2) THEN                                             FOPEN........19400
               INQUIRE(FILE=FN,EXIST=IS)                                 FOPEN........19500
               IF(IS) THEN                                               FOPEN........19600
                  OPEN(UNIT=IU,FILE=FN,STATUS='OLD',FORM='FORMATTED',    FOPEN........19700
     1               IOSTAT=KERR)                                        FOPEN........19800
               ELSE                                                      FOPEN........19900
                  GOTO 8000                                              FOPEN........20000
               ENDIF                                                     FOPEN........20100
            ELSE                                                         FOPEN........20200
               OPEN(UNIT=IU,FILE=FN,STATUS='REPLACE',FORM='FORMATTED',   FOPEN........20300
     1            IOSTAT=KERR)                                           FOPEN........20400
            ENDIF                                                        FOPEN........20500
            IF(KERR.GT.0) GOTO 9000                                      FOPEN........20600
  300    CONTINUE                                                        FOPEN........20700
C                                                                        FOPEN........20800
C........SET FLAG TO INDICATE THAT FIRST PASS IS COMPLETED, THEN RETURN  FOPEN........20900
         ONCEFO = .TRUE.                                                 FOPEN........21000
         RETURN                                                          FOPEN........21100
C                                                                        FOPEN........21200
      ELSE                                                               FOPEN........21300
C                                                                        FOPEN........21400
C........INITIALIZE OBSERVATION-RELATED UNIT NUMBERS AND FILENAMES       FOPEN........21500
         DO 330 NFO=1,NFLOMX                                             FOPEN........21600
            IUNIO(NFO) = -1                                              FOPEN........21700
            FNAMO(NFO) = ""                                              FOPEN........21800
  330    CONTINUE                                                        FOPEN........21900
C                                                                        FOPEN........22000
C........OPEN OBS AND OBC FILES, AUTOMATICALLY GENERATING UNIT NUMBERS   FOPEN........22100
C           AND FILENAMES                                                FOPEN........22200
C                                                                        FOPEN........22300
C........LOOP OVER THE TWO FILE TYPES                                    FOPEN........22400
c         DO 400 NF=7,8                                                   FOPEN........22500
C...........IF NO FILE SPECIFICATION OF THIS TYPE, MOVE ON               FOPEN........22600
c            IF (IUNIT(NF).EQ.-1) CYCLE                                   FOPEN........22700
C...........DETERMINE LENGTH OF THE SPECIFIED FILENAME AND ITS ROOT      FOPEN........22800
c            LNAME = LEN_TRIM(FNAME(NF))                                  FOPEN........22900
c            LROOT = SCAN(FNAME(NF),'.',BACK=.TRUE.) - 1                  FOPEN........23000
C...........SET THE ROOT NAME AND EXTENSION THAT WILL BE USED FOR FILES  FOPEN........23100
C              OF THIS TYPE                                              FOPEN........23200
c            IF (LROOT.NE.-1) THEN                                        FOPEN........23300
c               IF (LROOT.NE.0) THEN                                      FOPEN........23400
c                  FNROOT = FNAME(NF)(1:LROOT)                            FOPEN........23500
c               ELSE                                                      FOPEN........23600
c                  FNROOT = "SUTRA"                                       FOPEN........23700
c               END IF                                                    FOPEN........23800
c               IF (LROOT.NE.LNAME-1) THEN                                FOPEN........23900
c                  FNEXTN = FNAME(NF)(LROOT+1:LNAME)                      FOPEN........24000
c               ELSE                                                      FOPEN........24100
c                  FNEXTN = "." // FTSTR(NF)                              FOPEN........24200
c               END IF                                                    FOPEN........24300
c            ELSE                                                         FOPEN........24400
c               IF (LNAME.NE.0) THEN                                      FOPEN........24500
c                  FNROOT = FNAME(NF)                                     FOPEN........24600
c               ELSE                                                      FOPEN........24700
c                  FNROOT = "SUTRA"                                       FOPEN........24800
c               END IF                                                    FOPEN........24900
c               FNEXTN = "." // FTSTR(NF)                                 FOPEN........25000
c            END IF                                                       FOPEN........25100
C...........INITIALIZE UNIT NUMBER                                       FOPEN........25200
c            IUNEXT = IUNIT(NF)                                           FOPEN........25300
C...........LOOP OVER OBSERVATION OUTPUT FILES                           FOPEN........25400
c            DO 380 J=1,NFLOMX                                            FOPEN........25500
c               JM1 = J - 1                                               FOPEN........25600
C..............IF FILE IS NOT OF THE TYPE CURRENTLY BEING PROCESSED,     FOPEN........25700
C                 SKIP FILE                                              FOPEN........25800
c               IF (OFP(J)%FRMT.NE.FTSTR(NF)) CYCLE                       FOPEN........25900
C..............CONSTRUCT FILENAME FROM ROOT NAME, SCHEDULE NAME,         FOPEN........26000
C                 AND EXTENSION                                          FOPEN........26100
c               IF (SCHDLS(OFP(J)%ISCHED)%NAME.NE."-") THEN               FOPEN........26200
c                  FN = TRIM(FNROOT) // "_"                               FOPEN........26300
c     1               // TRIM(SCHDLS(OFP(J)%ISCHED)%NAME) // FNEXTN       FOPEN........26400
c               ELSE                                                      FOPEN........26500
c                  FN = TRIM(FNROOT) // FNEXTN                            FOPEN........26600
c               END IF                                                    FOPEN........26700
C..............CHECK FOR DUPLICATE FILENAME AMONG NON-OBSERVATION        FOPEN........26800
C                 FILES                                                  FOPEN........26900
c               DO 350 NFF=0,6                                            FOPEN........27000
c                  IF (FN.EQ.FNAME(NFF)) THEN                             FOPEN........27100
c                     ERRCOD = 'FIL-4'                                    FOPEN........27200
c                     CHERR(1) = UNAME                                    FOPEN........27300
c                     CHERR(2) = FN                                       FOPEN........27400
c                     CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)            FOPEN........27500
c                  END IF                                                 FOPEN........27600
c  350          CONTINUE                                                  FOPEN........27700
C..............CHECK FOR DUPLICATE FILENAME AMONG PREVIOUSLY DEFINED     FOPEN........27800
C                 OBSERVATION OUTPUT FILES                               FOPEN........27900
c               DO 355 NJ=1,J-1                                           FOPEN........28000
c                  IF (FN.EQ.FNAMO(NJ)) THEN                              FOPEN........28100
c                     ERRCOD = 'FIL-4'                                    FOPEN........28200
c                     CHERR(1) = UNAME                                    FOPEN........28300
c                     CHERR(2) = FN                                       FOPEN........28400
c                     CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)            FOPEN........28500
c                  END IF                                                 FOPEN........28600
c  355          CONTINUE                                                  FOPEN........28700
C..............ASSIGN NEXT AVAILABLE UNIT NUMBER, RECORD FILE            FOPEN........28800
C                 INFORMATION, AND OPEN THE FILE                         FOPEN........28900
c               CALL NAFU(IUNEXT,JM1,FN)                                  FOPEN........29000
c               IU = IUNEXT                                               FOPEN........29100
c               IUNIO(J) = IU                                             FOPEN........29200
c               FNAMO(J) = FN                                             FOPEN........29300
c               INQUIRE(UNIT=IU, OPENED=IS)                               FOPEN........29400
c               OPEN(UNIT=IU,FILE=FN,STATUS='REPLACE',FORM='FORMATTED',   FOPEN........29500
c     1            IOSTAT=KERR)                                           FOPEN........29600
c               IF(KERR.GT.0) GOTO 9000                                   FOPEN........29700
c  380       CONTINUE                                                     FOPEN........29800
c  400    CONTINUE                                                        FOPEN........29900
C                                                                        FOPEN........30000
C........SECOND PASS IS COMPLETED, SO RETURN                             FOPEN........30100
         RETURN                                                          FOPEN........30200
C                                                                        FOPEN........30300
      END IF                                                             FOPEN........30400
C                                                                        FOPEN........30500
 8000 CONTINUE                                                           FOPEN........30600
C.....GENERATE ERROR                                                     FOPEN........30700
c rbw begin change
       IErrorFlag = 37
       return
c      ERRCOD = 'FIL-1'                                                   FOPEN........30800
c      CHERR(1) = UNAME                                                   FOPEN........30900
c      CHERR(2) = FN                                                      FOPEN........31000
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           FOPEN........31100
c rbw end change
C                                                                        FOPEN........31200
 9000 CONTINUE                                                           FOPEN........31300
C.....GENERATE ERROR                                                     FOPEN........31400
c rbw begin change
           IErrorFlag = 38
           return
c      ERRCOD = 'FIL-2'                                                   FOPEN........31500
c      CHERR(1) = UNAME                                                   FOPEN........31600
c      CHERR(2) = FN                                                      FOPEN........31700
c      INERR(1) = IU                                                      FOPEN........31800
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           FOPEN........31900
cc rbw end change
C                                                                        FOPEN........32000
      END                                                                FOPEN........32100
C                                                                        FOPEN........32200
C     FUNCTION          F  R  C  S  T  P           SUTRA VERSION 2.1     FRCSTP.........100
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
      COMMON /SCH/ NSCH,ISCHTS                                           FRCSTP........1600
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
C     SUBROUTINE        G  L  O  B  A  N           SUTRA VERSION 2.1     GLOBAN.........100
C                                                                        GLOBAN.........200
C *** PURPOSE :                                                          GLOBAN.........300
C ***  TO ASSEMBLE RESULTS OF ELEMENTWISE INTEGRATIONS INTO              GLOBAN.........400
C ***  A GLOBAL BANDED MATRIX AND GLOBAL VECTOR FOR BOTH                 GLOBAN.........500
C ***  FLOW AND TRANSPORT EQUATIONS.                                     GLOBAN.........600
C                                                                        GLOBAN.........700
c rbw begin change
c      SUBROUTINE GLOBAN(L,ML,VOLE,BFLOWE,DFLOWE,BTRANE,DTRANE,           GLOBAN.........800
c     1      IN,VOL,PMAT,PVEC,UMAT,UVEC)                                  GLOBAN.........900
c rbw end change
C     SUBROUTINE        G  L  O  C  O  L           SUTRA VERSION 2.1     GLOCOL.........100
C                                                                        GLOCOL.........200
C *** PURPOSE :                                                          GLOCOL.........300
C ***  TO ASSEMBLE RESULTS OF ELEMENTWISE INTEGRATIONS INTO              GLOCOL.........400
C ***  A GLOBAL "SLAP COLUMN"-FORMAT MATRIX AND GLOBAL VECTOR            GLOCOL.........500
C ***  FOR BOTH FLOW AND TRANSPORT EQUATIONS.                            GLOCOL.........600
C                                                                        GLOCOL.........700
c rbw begin change
c      SUBROUTINE GLOCOL(L,ML,VOLE,BFLOWE,DFLOWE,BTRANE,DTRANE,           GLOCOL.........800
c     1      IN,VOL,PMAT,PVEC,UMAT,UVEC,IA,JA)                            GLOCOL.........900
c rbw end chagne
C     SUBROUTINE        I  N  D  A  T  0           SUTRA VERSION 2.1     INDAT0.........100
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
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:8)                     INDAT0........1600
      CHARACTER SCHTYP*12, CDUM10*10                                     INDAT0........1700
      CHARACTER*10 SCHNAM                                                INDAT0........1800
      CHARACTER CTICS*20, CREFT*8                                        INDAT0........1900
      DIMENSION INERR(10),RLERR(10)                                      INDAT0........2000
      DIMENSION KTYPE(2)                                                 INDAT0........2100
      ALLOCATABLE :: ISLIST(:), TLIST(:), DTMP1(:), DTMP2(:)             INDAT0........2200
      CHARACTER*10, ALLOCATABLE :: CTMP(:)                               INDAT0........2300
      CHARACTER*8 VERNUM, VERNIN                                         INDAT0........2400
      LOGICAL, ALLOCATABLE :: SBASED(:), ELAPSD(:)                       INDAT0........2500
      LOGICAL TSYES                                                      INDAT0........2600
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  INDAT0........2700
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             INDAT0........2800
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              INDAT0........2900
     1   NSOP,NSOU,NBCN                                                  INDAT0........3000
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        INDAT0........3100
      COMMON /DIMX2/ NELTA,NNVEC,NDIMIA,NDIMJA                           INDAT0........3200
      COMMON /FNAMES/ UNAME,FNAME                                        INDAT0........3300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     INDAT0........3400
      COMMON /GRAVEC/ GRAVX,GRAVY,GRAVZ                                  INDAT0........3500
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      INDAT0........3600
      COMMON /ITSOLI/ ITRMXP,ITOLP,NSAVEP,ITRMXU,ITOLU,NSAVEU            INDAT0........3700
      COMMON /ITSOLR/ TOLP,TOLU                                          INDAT0........3800
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     INDAT0........3900
     1   KSCRN,KPAUSE                                                    INDAT0........4000
      COMMON /MODSOR/ ADSMOD                                             INDAT0........4100
      COMMON /SCH/ NSCH,ISCHTS                                           INDAT0........4200
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      INDAT0........4300
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        INDAT0........4400
      COMMON /SOLVC/ SOLWRD,SOLNAM                                       INDAT0........4500
      COMMON /SOLVI/ KSOLVP,KSOLVU,NN1,NN2,NN3                           INDAT0........4600
      COMMON /SOLVN/ NSLVRS                                              INDAT0........4700
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       INDAT0........4800
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITMAX,TSTART                  INDAT0........4900
      COMMON /VER/ VERNUM, VERNIN                                        INDAT0........5000
C                                                                        INDAT0........5100
      INSTOP=0                                                           INDAT0........5200
C                                                                        INDAT0........5300
C.....INPUT DATASET 5: NUMERICAL CONTROL PARAMETERS                      INDAT0........5400
      ERRCOD = 'REA-INP-5'                                               INDAT0........5500
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT0........5600
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 158
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) UP,GNUP,GNUU                        INDAT0........5700
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0........5800
      IF (INERR(1).NE.0) then
        IErrorFlag = 39
        return
      endif
c      IF(ME.EQ.-1) WRITE(K3,70) UP,GNUP,GNUU                             INDAT0........5900
c rbw end change
   70 FORMAT(////11X,'N U M E R I C A L   C O N T R O L   D A T A'//     INDAT0........6000
     1   11X,F15.5,5X,'"UPSTREAM WEIGHTING" FACTOR'/                     INDAT0........6100
     2   11X,1PE15.4,5X,'SPECIFIED PRESSURE BOUNDARY CONDITION FACTOR'/  INDAT0........6200
     3   11X,1PE15.4,5X,'SPECIFIED CONCENTRATION BOUNDARY CONDITION ',   INDAT0........6300
     4   'FACTOR')                                                       INDAT0........6400
c rbw begin change
c      IF(ME.EQ.+1) WRITE(K3,80) UP,GNUP,GNUU                             INDAT0........6500
c rbw end change
   80 FORMAT(////11X,'N U M E R I C A L   C O N T R O L   D A T A'//     INDAT0........6600
     1   11X,F15.5,5X,'"UPSTREAM WEIGHTING" FACTOR'/                     INDAT0........6700
     2   11X,1PE15.4,5X,'SPECIFIED PRESSURE BOUNDARY CONDITION FACTOR'/  INDAT0........6800
     3   11X,1PE15.4,5X,'SPECIFIED TEMPERATURE BOUNDARY CONDITION ',     INDAT0........6900
     4   'FACTOR')                                                       INDAT0........7000
C                                                                        INDAT0........7100
C.....INPUT DATASET 6: TEMPORAL CONTROL AND SOLUTION CYCLING DATA        INDAT0........7200
      ERRCOD = 'REA-ICS-1'                                               INDAT0........7300
c rbw begin change
      TICS = 0
c      CALL READIF(K2, INTFIL, ERRCOD)                                    INDAT0........7400
c      READ(INTFIL,*,IOSTAT=INERR(1)) TICS                                INDAT0........7500
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0........7600
c      REWIND(K2)                                                         INDAT0........7700
c      WRITE(CTICS,'(E20.10)') TICS                                       INDAT0........7800
c      WRITE(K3,120)                                                      INDAT0........7900
c rbw end change
  120 FORMAT('1'////11X,'T E M P O R A L   C O N T R O L   A N D   ',    INDAT0........8000
     1   'S O L U T I O N   C Y C L I N G   D A T A')                    INDAT0........8100
      ERRCOD = 'REA-INP-6'                                               INDAT0........8200
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT0........8300
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 160
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NSCH                                INDAT0........8400
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0........8500
      IF (INERR(1).NE.0) then
        IErrorFlag = 41
        return
      endif
c rbw end change
C.....IF VERSION 2.0 INPUT, RE-READ DATASET IN OLD FORMAT.  ELSE IF      INDAT0........8600
C        NSCH>0, RE-READ FIRST LINE OF DATASET IN NEW FORMAT.  ELSE      INDAT0........8700
C        IF NSCH<0, OR NSCH=0 AND TRANSPORT IS NOT STEADY-STATE,         INDAT0........8800
C        GENERATE ERROR.                                                 INDAT0........8900
      IF (VERNIN.EQ."2.0") THEN                                          INDAT0........9000
C........READ TEMPORAL AND SOLUTION CYCLING CONTROLS.                    INDAT0........9100
         READ(INTFIL,*,IOSTAT=INERR(1)) ITMAX,DELT,TMAX,ITCYC,DTMULT,    INDAT0........9200
     1      DTMAX,NPCYC,NUCYC                                            INDAT0........9300
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0........9400
         IF (INERR(1).NE.0) then
           IErrorFlag = 42
           return
         endif
c rbw end change
C........ERROR CHECKING SPECIFIC TO OLD FORMAT.                          INDAT0........9500
         IF (DELT.GT.DTMAX) THEN                                         INDAT0........9600
c rbw begin change
           IErrorFlag = 43
           return
c            ERRCOD = 'INP-6-3'                                           INDAT0........9700
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0........9800
c rbw end change
         END IF                                                          INDAT0........9900
      ELSE IF (NSCH.GT.0) THEN                                           INDAT0.......10000
C........READ FIRST LINE OF DATASET.                                     INDAT0.......10100
         READ(INTFIL,*,IOSTAT=INERR(1)) NSCH, NPCYC, NUCYC               INDAT0.......10200
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......10300
         IF (INERR(1).NE.0) then
           IErrorFlag = 44
           return
         endif
c rbw end change
      ELSE IF (NSCH.LT.0) THEN                                           INDAT0.......10400
c rbw begin change
           IErrorFlag = 45
           return
c            ERRCOD = 'INP-6-8'                                           INDAT0.......10500
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......10600
c rbw end change
      ELSE                                                               INDAT0.......10700
         IF (ISSTRA.EQ.0) THEN                                           INDAT0.......10800
c rbw begin change
           IErrorFlag = 46
           return
c            ERRCOD = 'INP-6-13'                                          INDAT0.......10900
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......11000
c rbw end change
         END IF                                                          INDAT0.......11100
         NPCYC = 1                                                       INDAT0.......11200
         NUCYC = 1                                                       INDAT0.......11300
      END IF                                                             INDAT0.......11400
C.....ERROR CHECKING COMMON TO BOTH FORMATS.                             INDAT0.......11500
      IF (NPCYC.LT.1.OR.NUCYC.LT.1) THEN                                 INDAT0.......11600
c rbw begin change
           IErrorFlag = 47
           return
c         ERRCOD = 'INP-6-1'                                              INDAT0.......11700
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......11800
c rbw end change
      ELSE IF (NPCYC.NE.1.AND.NUCYC.NE.1) THEN                           INDAT0.......11900
c rbw begin change
           IErrorFlag = 48
           return
c         ERRCOD = 'INP-6-2'                                              INDAT0.......12000
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......12100
c rbw end change
      END IF                                                             INDAT0.......12200
C.....IF TRANSPORT IS STEADY-STATE, SKIP THROUGH THE REST OF THE         INDAT0.......12300
C        DATASET AND CREATE A TRIVIAL "TIME_STEPS" SCHEDULE.             INDAT0.......12400
C        (NOTE THAT IF TRANSPORT IS STEADY-STATE, SO IS FLOW.)           INDAT0.......12500
C        EVENTUALLY, A TRIVIAL SCHEDULE WILL ALSO BE CREATED FOR         INDAT0.......12600
C        OBSERVATION OUTPUT, SO SET NSCH=2.                              INDAT0.......12700
      IF (ISSTRA.EQ.1) THEN                                              INDAT0.......12800
         TSTART = TICS                                                   INDAT0.......12900
         IF (VERNIN.NE."2.0") THEN                                       INDAT0.......13000
            ERRCOD = 'REA-INP-6'                                         INDAT0.......13100
            CDUM10 = ''                                                  INDAT0.......13200
            DO WHILE (CDUM10.NE.'-')                                     INDAT0.......13300
               CALL READIF(K1, INTFIL, ERRCOD)                           INDAT0.......13400
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 161
        return
      endif
c rbw end change
c rbw begin change
c               IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR,      INDAT0.......13500
c     1            RLERR)                                                 INDAT0.......13600
               IF (INERR(1).NE.0) then
                 IErrorFlag = 49
                 return
               endif
c rbw end change
               READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10                     INDAT0.......13700
            END DO                                                       INDAT0.......13800
            DELT = MAX(1D-1*DABS(TSTART), 1D0)                           INDAT0.......13900
         END IF                                                          INDAT0.......14000
         NSCH = 2                                                        INDAT0.......14100
         ALLOCATE(SCHDLS(NSCH))                                          INDAT0.......14200
         DO 135 NS=1,NSCH                                                INDAT0.......14300
            ALLOCATE(SCHDLS(NS)%SLIST)                                   INDAT0.......14400
            SCHDLS(NS)%LLEN = 0                                          INDAT0.......14500
  135    CONTINUE                                                        INDAT0.......14600
         TIME = TSTART                                                   INDAT0.......14700
         STEP = 0D0                                                      INDAT0.......14800
         LSTLEN = 0                                                      INDAT0.......14900
         CALL LLDINS(LSTLEN, SCHDLS(1)%SLIST, TIME, STEP)                INDAT0.......15000
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         TIME = TIME + DELT                                              INDAT0.......15100
         STEP = 1D0                                                      INDAT0.......15200
         CALL LLDINS(LSTLEN, SCHDLS(1)%SLIST, TIME, STEP)                INDAT0.......15300
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         SCHDLS(1)%LLEN = LSTLEN                                         INDAT0.......15400
         ISCHTS = 1                                                      INDAT0.......15500
         ITMAX = 1                                                       INDAT0.......15600
C........WRITE STEADY-STATE OUTPUT INFORMATION.                          INDAT0.......15700
c rbw begin change
c         WRITE(K3,138)                                                   INDAT0.......15800
c rbw end change
  138    FORMAT (/13X,'NOTE: BECAUSE FLOW AND TRANSPORT ARE STEADY-',    INDAT0.......15900
     1      'STATE, USER-DEFINED SCHEDULES ARE NOT IN EFFECT.  '         INDAT0.......16000
     2      /13X,'STEADY-STATE RESULTS WILL BE WRITTEN TO THE ',         INDAT0.......16100
     3      'APPROPRIATE OUTPUT FILES.')                                 INDAT0.......16200
C........SKIP OVER PROCESSING AND WRITING OF TEMPORAL DATA.              INDAT0.......16300
         GOTO 850                                                        INDAT0.......16400
      END IF                                                             INDAT0.......16500
C.....IF DATASET IN OLD FORMAT, WRITE SPECIFICATIONS AND                 INDAT0.......16600
C        CREATE A CORRESPONDING SCHEDULE CALLED "TIME_STEPS".            INDAT0.......16700
C        IF NSCH=0, GENERATE AN ERROR.  IF IN NEW FORMAT, READ           INDAT0.......16800
C        AND PROCESS USER-DEFINED SCHEDULES.                             INDAT0.......16900
      IF (VERNIN.EQ."2.0") THEN                                          INDAT0.......17000
         TSTART = TICS                                                   INDAT0.......17100
c rbw begin change
c         WRITE(K3,150) ITMAX,DELT,TMAX,ITCYC,DTMULT,DTMAX                INDAT0.......17200
c rbw end change
  150    FORMAT (/13X,'NOTE: BECAUSE TEMPORAL CONTROL AND SOLUTION ',    INDAT0.......17300
     1      'CYCLING DATA WERE ENTERED USING THE OLD (VERSION 2D3D.1) ', INDAT0.......17400
     2      'INPUT FORMAT,'/13X,'A CORRESPONDING SCHEDULE, ',            INDAT0.......17500
     3      '"TIME_STEPS", WAS CREATED AUTOMATICALLY FROM THE ',         INDAT0.......17600
     4      'FOLLOWING PARAMETERS:'                                      INDAT0.......17700
     5      //11X,I15,5X,'MAXIMUM ALLOWED NUMBER OF TIME STEPS'          INDAT0.......17800
     6      /11X,1PE15.4,5X,'INITIAL TIME STEP (IN SECONDS)'             INDAT0.......17900
     7      /11X,1PE15.4,5X,'MAXIMUM ALLOWED SIMULATION TIME ',          INDAT0.......18000
     8      '(IN SECONDS)'                                               INDAT0.......18100
     9      //11X,I15,5X,'TIME STEP MULTIPLIER CYCLE (IN TIME STEPS)'    INDAT0.......18200
     1      /11X,0PF15.5,5X,'MULTIPLICATION FACTOR FOR TIME STEP CHANGE' INDAT0.......18300
     2      /11X,1PE15.4,5X,'MAXIMUM ALLOWED TIME STEP (IN SECONDS)')    INDAT0.......18400
C........TWO DEFAULT SCHEDULES WILL EVENTUALLY BE DEFINED:               INDAT0.......18500
C           "TIME_STEPS", WHICH CONTROLS TIME STEPPING, AND              INDAT0.......18600
C           "OBS", WHICH CONTROLS TIMING OF OBSERVATION OUTPUT.          INDAT0.......18700
C           SET THE NUMBER OF SCHEDULES ACCORDINGLY AND ALLOCATE         INDAT0.......18800
C           THE SCHEDULE ARRAY AND ITS LINKED LISTS.                     INDAT0.......18900
         NSCH = 2                                                        INDAT0.......19000
         ALLOCATE(SCHDLS(NSCH))                                          INDAT0.......19100
         DO 185 NS=1,NSCH                                                INDAT0.......19200
            ALLOCATE(SCHDLS(NS)%SLIST)                                   INDAT0.......19300
            SCHDLS(NS)%LLEN = 0                                          INDAT0.......19400
  185    CONTINUE                                                        INDAT0.......19500
C........DEFINE THE DEFAULT "TIME_STEPS" SCHEDULE BASED ON THE           INDAT0.......19600
C           TEMPORAL CONTROLS.  NOTE THAT, FOR BACKWARD COMPATIBILITY    INDAT0.......19700
C           WITH OLD DATASETS, THE ORIGINAL METHOD OF HANDLING CHANGES   INDAT0.......19800
C           IN TIME STEP SIZE [BASED ON MOD(JT,ITCYC).EQ.0, NOT          INDAT0.......19900
C           MOD(JT-1,ITCYC).EQ.0] HAS BEEN RETAINED.                     INDAT0.......20000
         SCHDLS(1)%NAME = "TIME_STEPS"                                   INDAT0.......20100
         TIME = TSTART                                                   INDAT0.......20200
         STEP = 0D0                                                      INDAT0.......20300
         LSTLEN = 0                                                      INDAT0.......20400
         CALL LLDINS(LSTLEN, SCHDLS(1)%SLIST, TIME, STEP)                INDAT0.......20500
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         DTIME = DELT                                                    INDAT0.......20600
         DO 580 JT=1,ITMAX                                               INDAT0.......20700
            IF (MOD(JT,ITCYC).EQ.0 .AND. JT.GT.1) DTIME=DTIME*DTMULT     INDAT0.......20800
            IF (DTIME.GT.DTMAX) DTIME = DTMAX                            INDAT0.......20900
            TIME = TIME + DTIME                                          INDAT0.......21000
            STEP = DBLE(JT)                                              INDAT0.......21100
            CALL LLDINS(LSTLEN, SCHDLS(1)%SLIST, TIME, STEP)             INDAT0.......21200
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            IF (TIME.GE.TMAX) EXIT                                       INDAT0.......21300
  580    CONTINUE                                                        INDAT0.......21400
         SCHDLS(1)%LLEN = LSTLEN                                         INDAT0.......21500
         ISCHTS = 1                                                      INDAT0.......21600
C........SKIP OVER THE CODE THAT READS SCHEDULE SPECIFICATIONS.          INDAT0.......21700
         GOTO 850                                                        INDAT0.......21800
      END IF                                                             INDAT0.......21900
C.....WRITE SCHEDULE PARAMETERS.                                         INDAT0.......22000
c rbw begin change
c      WRITE(K3,700) NSCH                                                 INDAT0.......22100
c rbw end change
  700 FORMAT(/13X,'THE ',I5,' SCHEDULES ARE LISTED BELOW.'               INDAT0.......22200
     1   '  SCHEDULE "TIME_STEPS" CONTROLS TIME STEPPING.')              INDAT0.......22300
C.....ALLOCATE SCHEDULE-RELATED ARRAYS AND INITIALIZE SCHEDULE NUMBER    INDAT0.......22400
C        FOR "TIME_STEPS".                                               INDAT0.......22500
      ALLOCATE(SCHDLS(NSCH), SBASED(NSCH), ELAPSD(NSCH))                 INDAT0.......22600
      ISCHTS = 0                                                         INDAT0.......22700
C.....LOOP THROUGH THE LIST OF SCHEDULE SPECIFICATIONS, CONSTRUCTING     INDAT0.......22800
C        SCHEDULES.                                                      INDAT0.......22900
      DO 800 I=1,NSCH                                                    INDAT0.......23000
C........ALLOCATE HEAD OF LINKED LIST FOR THE CURRENT SCHEDULE AND SET   INDAT0.......23100
C           LIST LENGTH TO ZERO.                                         INDAT0.......23200
         ALLOCATE(SCHDLS(I)%SLIST)                                       INDAT0.......23300
         SCHDLS(I)%LLEN = 0                                              INDAT0.......23400
C........READ SCHEDULE NAME AND DO SOME ERROR CHECKING.                  INDAT0.......23500
         ERRCOD = 'REA-INP-6'                                            INDAT0.......23600
         CALL READIF(K1, INTFIL, ERRCOD)                                 INDAT0.......23700
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 162
        return
      endif
c rbw end change
         READ(INTFIL,*,IOSTAT=INERR(1)) SCHNAM                           INDAT0.......23800
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......23900
         IF (INERR(1).NE.0) then
                 IErrorFlag = 50
                 return
               endif
c rbw end change
         IF (SCHNAM.EQ."-") THEN                                         INDAT0.......24000
c rbw begin change
                 IErrorFlag = 51
                 return
c            ERRCOD = 'INP-6-4'                                           INDAT0.......24100
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......24200
c rbw end change
         ELSE                                                            INDAT0.......24300
            DO 710 II=1,I-1                                              INDAT0.......24400
               IF (SCHNAM.EQ.SCHDLS(II)%NAME) THEN                       INDAT0.......24500
c rbw begin change
                 IErrorFlag = 52
                 return
c                  ERRCOD = 'INP-6-5'                                     INDAT0.......24600
c                  CHERR(1) = SCHNAM                                      INDAT0.......24700
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......24800
c rbw end change
               END IF                                                    INDAT0.......24900
  710       CONTINUE                                                     INDAT0.......25000
         END IF                                                          INDAT0.......25100
C........(RE)READ SCHEDULE NAME AND TYPE.                                INDAT0.......25200
         READ(INTFIL,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP                   INDAT0.......25300
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......25400
         IF (INERR(1).NE.0) then
                 IErrorFlag = 53
                 return
         endif
c rbw end change
C........BASED ON THE SCHEDULE TYPE, READ IN THE SPECIFICATIONS AND      INDAT0.......25500
C           CONSTRUCT THE SCHEDULE.                                      INDAT0.......25600
         IF (SCHTYP.EQ."STEP CYCLE") THEN                                INDAT0.......25700
            SBASED(I) = .TRUE.                                           INDAT0.......25800
C...........READ ALL THE SPECIFICATIONS.                                 INDAT0.......25900
            READ(INTFIL,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP,               INDAT0.......26000
     1         NSMAX, ISTEPI, ISTEPL, ISTEPC                             INDAT0.......26100
c rbw begin change
c            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......26200
            IF (INERR(1).NE.0) then
                 IErrorFlag = 54
                 return
            endif
c rbw end change
            SCHDLS(I)%NAME = SCHNAM                                      INDAT0.......26300
            ELAPSD(I) = .FALSE.                                          INDAT0.......26400
C...........CONSTRUCT THE SCHEDULE BY STEPPING THROUGH THE STEP CYCLE    INDAT0.......26500
C              AND STORING THE RESULTS IN THE LINKED LIST.  SET TIME     INDAT0.......26600
C              EQUAL TO STEP FOR NOW SO THAT THE LIST IS CONSTRUCTED     INDAT0.......26700
C              IN THE PROPER ORDER.                                      INDAT0.......26800
            NSTEP = ISTEPI                                               INDAT0.......26900
            NDSTEP = ISTEPC                                              INDAT0.......27000
            LSTLEN = 0                                                   INDAT0.......27100
            STEP = DNINT(DBLE(NSTEP))                                    INDAT0.......27200
            TIME = STEP                                                  INDAT0.......27300
            CALL LLDINS(LSTLEN, SCHDLS(I)%SLIST, TIME, STEP)             INDAT0.......27400
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            DO 720 NS=1,NSMAX                                            INDAT0.......27500
               NSTEP = NSTEP + NDSTEP                                    INDAT0.......27600
               STEP = DNINT(DBLE(NSTEP))                                 INDAT0.......27700
               TIME = STEP                                               INDAT0.......27800
               CALL LLDINS(LSTLEN, SCHDLS(I)%SLIST, TIME, STEP)          INDAT0.......27900
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
               IF (NSTEP.GE.ISTEPL) EXIT                                 INDAT0.......28000
  720       CONTINUE                                                     INDAT0.......28100
            SCHDLS(I)%LLEN = LSTLEN                                      INDAT0.......28200
C...........WRITE OUT THE SPECIFICATIONS.                                INDAT0.......28300
c rbw begin change
c            WRITE(K3,722) SCHDLS(I)%NAME, NSMAX, ISTEPI, ISTEPL, ISTEPC  INDAT0.......28400
c rbw end change
  722       FORMAT(/16X,'SCHEDULE ',A, 3X,'STEP CYCLE WITH THE ',        INDAT0.......28500
     1         'FOLLOWING SPECIFICATIONS:'                               INDAT0.......28600
     2         /40X, I8, 5X, 'MAXIMUM NUMBER OF TIME STEPS AFTER ',      INDAT0.......28700
     3            'INITIAL TIME STEP NUMBER'                             INDAT0.......28800
     4         /40X, I8, 5X, 'INITIAL TIME STEP NUMBER'                  INDAT0.......28900
     5         /40X, I8, 5X, 'LIMITING TIME STEP NUMBER'                 INDAT0.......29000
     6         /40X, I8, 5X, 'TIME STEP INCREMENT')                      INDAT0.......29100
         ELSE IF (SCHTYP.EQ."TIME CYCLE") THEN                           INDAT0.......29200
            SBASED(I) = .FALSE.                                          INDAT0.......29300
C...........READ ALL THE SPECIFICATIONS.                                 INDAT0.......29400
            READ(INTFIL,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP, CREFT,        INDAT0.......29500
     1         SCALT, NTMAX, TIMEI, TIMEL, TIMEC, NTCYC,                 INDAT0.......29600
     2         TCMULT, TCMIN, TCMAX                                      INDAT0.......29700
c rbw begin change
c            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......29800
            IF (INERR(1).NE.0) then
                 IErrorFlag = 55
                 return
            endif
c rbw end change
            SCHDLS(I)%NAME = SCHNAM                                      INDAT0.......29900
            IF (CREFT.EQ.'ELAPSED ') THEN                                INDAT0.......30000
               IF ((SCHNAM.EQ.'TIME_STEPS').AND.(TIMEI.NE.0D0)) THEN     INDAT0.......30100
c rbw begin change
                 IErrorFlag = 56
                 return
c                  ERRCOD = 'INP-6-7'                                     INDAT0.......30200
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......30300
c rbw end change
               END IF                                                    INDAT0.......30400
               ELAPSD(I) = .TRUE.                                        INDAT0.......30500
            ELSE IF (CREFT.EQ.'ABSOLUTE') THEN                           INDAT0.......30600
               ELAPSD(I) = .FALSE.                                       INDAT0.......30700
            ELSE                                                         INDAT0.......30800
c rbw begin change
                 IErrorFlag = 57
                 return
c               ERRCOD = 'INP-6-6'                                        INDAT0.......30900
c               CHERR(1) = CREFT                                          INDAT0.......31000
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  INDAT0.......31100
c rbw end change
            END IF                                                       INDAT0.......31200
C...........SCALE ALL TIME SPECIFICATIONS                                INDAT0.......31300
            TIMEI = TIMEI*SCALT                                          INDAT0.......31400
            TIMEL = TIMEL*SCALT                                          INDAT0.......31500
            TIMEC = TIMEC*SCALT                                          INDAT0.......31600
            TCMIN = TCMIN*SCALT                                          INDAT0.......31700
            TCMAX = TCMAX*SCALT                                          INDAT0.......31800
C...........CONSTRUCT THE SCHEDULE BY STEPPING THROUGH THE TIME CYCLE    INDAT0.......31900
C              AND STORING THE RESULTS IN THE LINKED LIST.               INDAT0.......32000
            TIME = TIMEI                                                 INDAT0.......32100
            STEP = FRCSTP(TIME)                                          INDAT0.......32200
            DTIME = TIMEC                                                INDAT0.......32300
            LSTLEN = 0                                                   INDAT0.......32400
            CALL LLDINS(LSTLEN, SCHDLS(I)%SLIST, TIME, STEP)             INDAT0.......32500
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            DO 730 NT=1,NTMAX                                            INDAT0.......32600
               IF (MOD(NT-1,NTCYC).EQ.0 .AND. NT.GT.1)                   INDAT0.......32700
     1            DTIME=DTIME*TCMULT                                     INDAT0.......32800
               IF (DTIME.GT.TCMAX) DTIME = TCMAX                         INDAT0.......32900
               IF (DTIME.LT.TCMIN) DTIME = TCMIN                         INDAT0.......33000
               TIME = TIME + DTIME                                       INDAT0.......33100
               STEP = FRCSTP(TIME)                                       INDAT0.......33200
               CALL LLDINS(LSTLEN, SCHDLS(I)%SLIST, TIME, STEP)          INDAT0.......33300
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
               IF (TIME.GE.TIMEL) EXIT                                   INDAT0.......33400
  730       CONTINUE                                                     INDAT0.......33500
            SCHDLS(I)%LLEN = LSTLEN                                      INDAT0.......33600
C...........WRITE OUT THE SPECIFICATIONS.                                INDAT0.......33700
c rbw begin change
c            WRITE(K3,732) SCHDLS(I)%NAME, TRIM(CREFT), NTMAX, TIMEI,     INDAT0.......33800
c     1          TIMEL, TIMEC, NTCYC, TCMULT, TCMIN, TCMAX                INDAT0.......33900
c rbw end change
  732       FORMAT(/16X,'SCHEDULE ',A, 3X,'TIME CYCLE WITH THE ',        INDAT0.......34000
     1         'FOLLOWING SPECIFICATIONS IN TERMS OF ', A, ' TIMES:'     INDAT0.......34100
     2         /46X, I8, 5X, 'MAXIMUM NUMBER OF TIMES AFTER ',           INDAT0.......34200
     3            'INITIAL TIME'                                         INDAT0.......34300
     4         /39X, 1PE15.7, 5X, 'INITIAL TIME'                         INDAT0.......34400
     5         /39X, 1PE15.7, 5X, 'LIMITING TIME'                        INDAT0.......34500
     6         /39X, 1PE15.7, 5X, 'INITIAL TIME INCREMENT'               INDAT0.......34600
     7         /46X, I8, 5X, 'TIME INCREMENT CHANGE CYCLE '              INDAT0.......34700
     8         /39X, 1PE15.7, 5X, 'TIME INCREMENT MULTIPLIER'            INDAT0.......34800
     9         /39X, 1PE15.7, 5X, 'MINIMUM TIME INCREMENT'               INDAT0.......34900
     1         /39X, 1PE15.7, 5X, 'MAXIMUM TIME INCREMENT')              INDAT0.......35000
         ELSE IF (SCHTYP.EQ."STEP LIST") THEN                            INDAT0.......35100
            SBASED(I) = .TRUE.                                           INDAT0.......35200
C...........READ THE SCHEDULE NAME, TYPE, AND LENGTH.                    INDAT0.......35300
            BACKSPACE(K1)                                                INDAT0.......35400
            READ(K1,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP, NSLIST            INDAT0.......35500
c rbw begin change
c            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......35600
            IF (INERR(1).NE.0) then
                 IErrorFlag = 58
                 return
            endif
c rbw end change
C...........ALLOCATE A TEMPORARY ARRAY TO HOLD THE STEP LIST.            INDAT0.......35700
            ALLOCATE (ISLIST(NSLIST))                                    INDAT0.......35800
C...........READ ALL THE SPECIFICATIONS.                                 INDAT0.......35900
            BACKSPACE(K1)                                                INDAT0.......36000
            READ(K1,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP,                   INDAT0.......36100
     1         NSLIST, (ISLIST(NS),NS=1,NSLIST)                          INDAT0.......36200
c rbw begin change
c            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......36300
            IF (INERR(1).NE.0) then
                 IErrorFlag = 59
                 return
            endif
c rbw end change
            SCHDLS(I)%NAME = SCHNAM                                      INDAT0.......36400
            ELAPSD(I) = .FALSE.                                          INDAT0.......36500
C...........CONSTRUCT THE SCHEDULE BY TRANSFERRING THE LIST FROM ARRAY   INDAT0.......36600
C              ISLIST TO THE LINKED LIST.  SET TIME EQUAL TO STEP FOR    INDAT0.......36700
C              NOW SO THAT THE LIST IS CONSTRUCTED IN THE PROPER ORDER.  INDAT0.......36800
            LSTLEN = 0                                                   INDAT0.......36900
            DO 740 NS=1,NSLIST                                           INDAT0.......37000
               NSTEP = ISLIST(NS)                                        INDAT0.......37100
               STEP = DNINT(DBLE(NSTEP))                                 INDAT0.......37200
               TIME = STEP                                               INDAT0.......37300
               CALL LLDINS(LSTLEN, SCHDLS(I)%SLIST, TIME, STEP)          INDAT0.......37400
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
  740       CONTINUE                                                     INDAT0.......37500
            SCHDLS(I)%LLEN = NSLIST                                      INDAT0.......37600
C...........WRITE OUT THE SPECIFICATIONS.                                INDAT0.......37700
c rbw begin change
c            WRITE(K3,742) SCHDLS(I)%NAME, (ISLIST(NS),NS=1,NSLIST)       INDAT0.......37800
c rbw end change
  742       FORMAT(/16X,'SCHEDULE ',A, 3X,'STEP LIST THAT INCLUDES ',    INDAT0.......37900
     1         'THE FOLLOWING TIME STEPS:'/:(38X,8(2X,I8)))              INDAT0.......38000
C...........DEALLOCATE THE TEMPORARY ARRAY.                              INDAT0.......38100
            DEALLOCATE (ISLIST)                                          INDAT0.......38200
         ELSE IF (SCHTYP.EQ."TIME LIST") THEN                            INDAT0.......38300
            SBASED(I) = .FALSE.                                          INDAT0.......38400
C...........READ THE SCHEDULE NAME, TYPE, SCALE FACTOR, AND LENGTH.      INDAT0.......38500
            BACKSPACE(K1)                                                INDAT0.......38600
            READ(K1,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP, CREFT,            INDAT0.......38700
     1         SCALT, NTLIST                                             INDAT0.......38800
c rbw begin change
c            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......38900
            IF (INERR(1).NE.0) then
                 IErrorFlag = 60
                 return
            endif
c rbw end change
C...........ALLOCATE A TEMPORARY ARRAY TO HOLD THE TIME LIST.            INDAT0.......39000
            ALLOCATE (TLIST(NTLIST))                                     INDAT0.......39100
C...........READ ALL THE SPECIFICATIONS.                                 INDAT0.......39200
            BACKSPACE(K1)                                                INDAT0.......39300
            READ(K1,*,IOSTAT=INERR(1)) SCHNAM, SCHTYP, CREFT,            INDAT0.......39400
     1         SCALT, NTLIST, (TLIST(NT),NT=1,NTLIST)                    INDAT0.......39500
c rbw begin change
c            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  INDAT0.......39600
            IF (INERR(1).NE.0) then
                 IErrorFlag = 61
                 return
            endif
c rbw end change
            SCHDLS(I)%NAME = SCHNAM                                      INDAT0.......39700
            IF (CREFT.EQ.'ELAPSED ') THEN                                INDAT0.......39800
               IF ((SCHNAM.EQ.'TIME_STEPS').AND.(TLIST(1).NE.0D0)) THEN  INDAT0.......39900
c rbw begin change
                 IErrorFlag = 62
                 return
c                  ERRCOD = 'INP-6-7'                                     INDAT0.......40000
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......40100
c rbw end change
               END IF                                                    INDAT0.......40200
               ELAPSD(I) = .TRUE.                                        INDAT0.......40300
            ELSE IF (CREFT.EQ.'ABSOLUTE') THEN                           INDAT0.......40400
               ELAPSD(I) = .FALSE.                                       INDAT0.......40500
            ELSE                                                         INDAT0.......40600
c rbw begin change
                 IErrorFlag = 63
                 return
c               ERRCOD = 'INP-6-6'                                        INDAT0.......40700
c               CHERR(1) = CREFT                                          INDAT0.......40800
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  INDAT0.......40900
c rbw end change
            END IF                                                       INDAT0.......41000
C...........SCALE ALL TIME SPECIFICATIONS                                INDAT0.......41100
            DO 745 NT=1,NTLIST                                           INDAT0.......41200
               TLIST(NT) = TLIST(NT)*SCALT                               INDAT0.......41300
  745       CONTINUE                                                     INDAT0.......41400
C...........CONSTRUCT THE SCHEDULE BY TRANSFERRING THE LIST FROM ARRAY   INDAT0.......41500
C              TLIST TO THE LINKED LIST.                                 INDAT0.......41600
            LSTLEN = 0                                                   INDAT0.......41700
            DO 750 NT=1,NTLIST                                           INDAT0.......41800
               TIME = TLIST(NT)                                          INDAT0.......41900
               STEP = FRCSTP(TIME)                                       INDAT0.......42000
               CALL LLDINS(LSTLEN, SCHDLS(I)%SLIST, TIME, STEP)          INDAT0.......42100
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
  750       CONTINUE                                                     INDAT0.......42200
            SCHDLS(I)%LLEN = NTLIST                                      INDAT0.......42300
C...........WRITE OUT THE SPECIFICATIONS.                                INDAT0.......42400
c rbw begin change
c            WRITE(K3,752) SCHDLS(I)%NAME, TRIM(CREFT),                   INDAT0.......42500
c     1         (TLIST(NT),NT=1,NTLIST)                                   INDAT0.......42600
c rbw end change
  752       FORMAT(/16X,'SCHEDULE ',A, 3X,'TIME LIST THAT INCLUDES ',    INDAT0.......42700
     1         'THE FOLLOWING ', A, ' TIMES (SEC):'                      INDAT0.......42800
     2         /:(38X,4(1X,1PE15.7)))                                    INDAT0.......42900
            DEALLOCATE (TLIST)                                           INDAT0.......43000
         ELSE                                                            INDAT0.......43100
C...........THE SPECIFIED SCHEDULE TYPE IS INVALID, SO GENERATE AN       INDAT0.......43200
C              ERROR.                                                    INDAT0.......43300
c rbw begin change
                 IErrorFlag = 64
                 return
c            ERRCOD = 'INP-6-9'                                           INDAT0.......43400
c            CHERR(1) = SCHTYP                                            INDAT0.......43500
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......43600
c rbw end change
         END IF                                                          INDAT0.......43700
  800 CONTINUE                                                           INDAT0.......43800
C.....READ ONE MORE LINE TO CHECK FOR THE END-OF-LIST MARKER ('-').      INDAT0.......43900
C        IF NOT FOUND, GENERATE AN ERROR.                                INDAT0.......44000
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT0.......44100
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 163
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10                              INDAT0.......44200
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......44300
      IF (INERR(1).NE.0) then
                 IErrorFlag = 65
                 return
      endif
c rbw end change
      IF (CDUM10.NE.'-') THEN                                            INDAT0.......44400
c rbw begin change
                 IErrorFlag = 65
                 return
c         ERRCOD = 'INP-6-4'                                              INDAT0.......44500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......44600
c rbw end change
      END IF                                                             INDAT0.......44700
C.....FIND SCHEDULE "TIME_STEPS".                                        INDAT0.......44800
      DO 810 I=1,NSCH                                                    INDAT0.......44900
         IF (SCHDLS(I)%NAME.EQ."TIME_STEPS") THEN                        INDAT0.......45000
            ISCHTS=I                                                     INDAT0.......45100
            TSYES = .TRUE.                                               INDAT0.......45200
            EXIT                                                         INDAT0.......45300
         END IF                                                          INDAT0.......45400
  810 CONTINUE                                                           INDAT0.......45500
C.....IF TRANSPORT IS TRANSIENT AND SCHEDULE "TIME_STEPS" HAS NOT        INDAT0.......45600
C        BEEN DEFINED, GENERATE ERROR                                    INDAT0.......45700
      IF ((ISSTRA.EQ.0).AND.(.NOT.TSYES)) THEN                           INDAT0.......45800
c rbw begin change
                 IErrorFlag = 66
                 return
c         ERRCOD = 'INP-6-14'                                             INDAT0.......45900
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......46000
c rbw end change
      END IF                                                             INDAT0.......46100
C.....IF "TIME_STEPS" LENGTH IS <=1 (SCHEDULE CONTAINS, AT MOST,         INDAT0.......46200
C        ONLY THE INITIAL TIME, AND NO SUBSEQUENT TIME STEPS),           INDAT0.......46300
C        GENERATE AN ERROR.                                              INDAT0.......46400
      IF (SCHDLS(ISCHTS)%LLEN.LE.1) THEN                                 INDAT0.......46500
c rbw begin change
                 IErrorFlag = 67
                 return
c         ERRCOD = 'INP-6-10'                                             INDAT0.......46600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......46700
c rbw end change
      END IF                                                             INDAT0.......46800
C.....IN SCHEDULE TIME STEPS, FILL IN TIME STEP NUMBERS, ADDING          INDAT0.......46900
C        TICS TO ELAPSED TIMES IF NECESSARY.  GENERATE ERROR IF          INDAT0.......47000
C        ANY TIMES ARE REPEATED.                                         INDAT0.......47100
      NSMAX = SCHDLS(ISCHTS)%LLEN                                        INDAT0.......47200
      ALLOCATE(DTMP1(NSMAX),DTMP2(NSMAX))                                INDAT0.......47300
      CALL LLD2AR(NSMAX, SCHDLS(ISCHTS)%SLIST, DTMP1, DTMP2)             INDAT0.......47400
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
      DEALLOCATE (SCHDLS(ISCHTS)%SLIST)                                  INDAT0.......47500
      ALLOCATE (SCHDLS(ISCHTS)%SLIST)                                    INDAT0.......47600
      IF (ELAPSD(ISCHTS)) THEN                                           INDAT0.......47700
         TREF = TICS                                                     INDAT0.......47800
      ELSE                                                               INDAT0.......47900
         TREF = 0D0                                                      INDAT0.......48000
      END IF                                                             INDAT0.......48100
      ITMAX = NSMAX - 1                                                  INDAT0.......48200
      TSTART = TREF + DTMP1(1)                                           INDAT0.......48300
      TFINSH = TREF + DTMP1(NSMAX)                                       INDAT0.......48400
      DELT = DTMP1(2) - DTMP1(1)                                         INDAT0.......48500
      LSTLEN = 0                                                         INDAT0.......48600
      DO 820 NS=1,NSMAX                                                  INDAT0.......48700
         IF ((NS.GT.1).AND.(DTMP1(NS).EQ.DTMP1(NS-1))) THEN              INDAT0.......48800
c rbw begin change
                 IErrorFlag = 68
                 return
c            ERRCOD = 'INP-6-12'                                          INDAT0.......48900
c            IF (ELAPSD(ISCHTS)) THEN                                     INDAT0.......49000
c               CHERR(1) = "elapsed time"                                 INDAT0.......49100
c            ELSE                                                         INDAT0.......49200
c               CHERR(1) = "absolute time"                                INDAT0.......49300
c            END IF                                                       INDAT0.......49400
c            CHERR(2) = "TIME_STEPS"                                      INDAT0.......49500
c            RLERR(1) = DTMP1(NS)                                         INDAT0.......49600
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT0.......49700
c rbw end change
         END IF                                                          INDAT0.......49800
         NSTEP = NS - 1                                                  INDAT0.......49900
         TIME = TREF + DTMP1(NS)                                         INDAT0.......50000
         STEP = DNINT(DBLE(NSTEP))                                       INDAT0.......50100
         CALL LLDINS(LSTLEN, SCHDLS(ISCHTS)%SLIST, TIME, STEP)           INDAT0.......50200
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
  820 CONTINUE                                                           INDAT0.......50300
      DEALLOCATE(DTMP1,DTMP2)                                            INDAT0.......50400
C.....FILL IN TIMES OR STEPS FOR REMAINING SCHEDULES, SHIFTING           INDAT0.......50500
C        ELAPSED TIMES TO ABSOLUTE TIMES IF NECESSARY.  PRUNE ENTRIES    INDAT0.......50600
C        THAT ARE OUTSIDE THE RANGE OF SCHEDULE "TIME_STEPS".            INDAT0.......50700
C        GENERATE ERROR IF ANY TIME STEPS OR TIMES ARE REPEATED.         INDAT0.......50800
      DO 845 I=1,NSCH                                                    INDAT0.......50900
         IF (I.EQ.ISCHTS) CYCLE                                          INDAT0.......51000
         NSMAX = SCHDLS(I)%LLEN                                          INDAT0.......51100
         ALLOCATE(DTMP1(NSMAX),DTMP2(NSMAX))                             INDAT0.......51200
         CALL LLD2AR(NSMAX, SCHDLS(I)%SLIST, DTMP1, DTMP2)               INDAT0.......51300
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         DEALLOCATE (SCHDLS(I)%SLIST)                                    INDAT0.......51400
         ALLOCATE (SCHDLS(I)%SLIST)                                      INDAT0.......51500
         IF (ELAPSD(I)) THEN                                             INDAT0.......51600
            TREF = TSTART                                                INDAT0.......51700
         ELSE                                                            INDAT0.......51800
            TREF = 0D0                                                   INDAT0.......51900
         END IF                                                          INDAT0.......52000
         LSTLEN = 0                                                      INDAT0.......52100
         IF (SBASED(I)) THEN                                             INDAT0.......52200
            DO 840 NS=1,NSMAX                                            INDAT0.......52300
               IF ((NS.GT.1).AND.(DTMP2(NS).EQ.DTMP2(NS-1))) THEN        INDAT0.......52400
c rbw begin change
                 IErrorFlag = 69
                 return
c                  ERRCOD = 'INP-6-12'                                    INDAT0.......52500
c                  CHERR(1) = "time step"                                 INDAT0.......52600
c                  CHERR(2) = SCHDLS(I)%NAME                              INDAT0.......52700
c                  RLERR(1) = DTMP2(NS)                                   INDAT0.......52800
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......52900
c rbw end change
               END IF                                                    INDAT0.......53000
               STEP = DTMP2(NS)                                          INDAT0.......53100
               NSTEP = NINT(STEP)                                        INDAT0.......53200
               IF ((NSTEP.LT.0).OR.(NSTEP.GT.ITMAX)) CYCLE               INDAT0.......53300
               TIME = TIMETS(NSTEP)                                      INDAT0.......53400
               CALL LLDINS(LSTLEN, SCHDLS(I)%SLIST, TIME, STEP)          INDAT0.......53500
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
  840       CONTINUE                                                     INDAT0.......53600
         ELSE                                                            INDAT0.......53700
            DO 842 NS=1,NSMAX                                            INDAT0.......53800
               IF ((NS.GT.1).AND.(DTMP1(NS).EQ.DTMP1(NS-1))) THEN        INDAT0.......53900
c rbw begin change
                 IErrorFlag = 70
                 return
c                  ERRCOD = 'INP-6-12'                                    INDAT0.......54000
c                  IF (ELAPSD(I)) THEN                                    INDAT0.......54100
c                     CHERR(1) = "elapsed time"                           INDAT0.......54200
c                  ELSE                                                   INDAT0.......54300
c                     CHERR(1) = "absolute time"                          INDAT0.......54400
c                  END IF                                                 INDAT0.......54500
c                  CHERR(2) = SCHDLS(I)%NAME                              INDAT0.......54600
c                  RLERR(1) = DTMP1(NS)                                   INDAT0.......54700
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT0.......54800
c rbw end change
               END IF                                                    INDAT0.......54900
               TIME = TREF + DTMP1(NS)                                   INDAT0.......55000
               IF ((TIME.LT.TSTART).OR.(TIME.GT.TFINSH)) CYCLE           INDAT0.......55100
               STEP = FRCSTP(TIME)                                       INDAT0.......55200
               CALL LLDINS(LSTLEN, SCHDLS(I)%SLIST, TIME, STEP)          INDAT0.......55300
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
  842       CONTINUE                                                     INDAT0.......55400
         END IF                                                          INDAT0.......55500
         SCHDLS(I)%LLEN = LSTLEN                                         INDAT0.......55600
         DEALLOCATE(DTMP1,DTMP2)                                         INDAT0.......55700
  845 CONTINUE                                                           INDAT0.......55800
C.....DEALLOCATE ARRAY THAT INDICATES METHODS OF SCHEDULE SPECIFICATION  INDAT0.......55900
      DEALLOCATE(SBASED)                                                 INDAT0.......56000
C.....WRITE THE SOLUTION CYCLING CONTROLS.                               INDAT0.......56100
c rbw begin change
  850 continue
c  850 WRITE(K3,874) NPCYC,NUCYC                                          INDAT0.......56200
c rbw end change
  874 FORMAT (/13X,'SOLUTION CYCLING DATA:'                              INDAT0.......56300
     1      //11X,I15,5X,'FLOW SOLUTION CYCLE (IN TIME STEPS)'           INDAT0.......56400
     2      /11X,I15,5X,'TRANSPORT SOLUTION CYCLE (IN TIME STEPS)')      INDAT0.......56500
C.....SET SOLUTION CYCLING FOR STEADY-STATE FLOW                         INDAT0.......56600
      IF(ISSFLO.EQ.1) THEN                                               INDAT0.......56700
         NPCYC=ITMAX+1                                                   INDAT0.......56800
         NUCYC=1                                                         INDAT0.......56900
      END IF                                                             INDAT0.......57000
C                                                                        INDAT0.......57100
C.....INPUT DATASET 7A:  ITERATION CONTROLS FOR RESOLVING NONLINEARITIES INDAT0.......57200
      ERRCOD = 'REA-INP-7A'                                              INDAT0.......57300
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT0.......57400
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 164
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) ITRMAX                              INDAT0.......57500
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......57600
      IF (INERR(1).NE.0) then
                 IErrorFlag = 71
                 return
      endif
c rbw end change
      IF (ITRMAX.GT.1) THEN                                              INDAT0.......57700
         ERRCOD = 'REA-INP-7A'                                           INDAT0.......57800
         READ(INTFIL,*,IOSTAT=INERR(1)) ITRMAX,RPMAX,RUMAX               INDAT0.......57900
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......58000
         IF (INERR(1).NE.0) then
                 IErrorFlag = 72
                 return
          endif
c rbw end change
      END IF                                                             INDAT0.......58100
c rbw begin change
c      IF(ITRMAX-1) 1192,1192,1194                                        INDAT0.......58200
c 1192 WRITE(K3,1193)                                                     INDAT0.......58300
c 1193 FORMAT(////11X,'I T E R A T I O N   C O N T R O L   D A T A',      INDAT0.......58400
c     1   //11X,'  NON-ITERATIVE SOLUTION')                               INDAT0.......58500
c      GOTO 1196                                                          INDAT0.......58600
c 1194 WRITE(K3,1195) ITRMAX,RPMAX,RUMAX                                  INDAT0.......58700
c 1195 FORMAT(////11X,'I T E R A T I O N   C O N T R O L   D A T A',      INDAT0.......58800
c     1   //11X,I15,5X,'MAXIMUM NUMBER OF ITERATIONS PER TIME STEP',      INDAT0.......58900
c     2   /11X,1PE15.4,5X,'ABSOLUTE CONVERGENCE CRITERION FOR FLOW',      INDAT0.......59000
c     3   ' SOLUTION'/11X,1PE15.4,5X,'ABSOLUTE CONVERGENCE CRITERION',    INDAT0.......59100
c     4   ' FOR TRANSPORT SOLUTION')                                      INDAT0.......59200
c rbw end change
 1196 CONTINUE                                                           INDAT0.......59300
C                                                                        INDAT0.......59400
C.....INPUT DATASETS 7B & 7C:  MATRIX EQUATION SOLVER CONTROLS FOR       INDAT0.......59500
C        PRESSURE AND TRANSPORT SOLUTIONS                                INDAT0.......59600
      ERRCOD = 'REA-INP-7B'                                              INDAT0.......59700
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT0.......59800
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 165
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVP                              INDAT0.......59900
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......60000
      IF (INERR(1).NE.0) then
                 IErrorFlag = 73
                 return
          endif
c rbw end change
      IF ((CSOLVP.NE.SOLWRD(0))) THEN                                    INDAT0.......60100
         ERRCOD = 'REA-INP-7B'                                           INDAT0.......60200
         READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVP,ITRMXP,TOLP               INDAT0.......60300
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......60400
         IF (INERR(1).NE.0) then
                 IErrorFlag = 74
                 return
          endif
c rbw end change
      END IF                                                             INDAT0.......60500
      ERRCOD = 'REA-INP-7C'                                              INDAT0.......60600
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT0.......60700
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 166
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVU                              INDAT0.......60800
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......60900
      IF (INERR(1).NE.0) then
                 IErrorFlag = 75
                 return
      endif
c rbw end change
      IF ((CSOLVU.NE.SOLWRD(0))) THEN                                    INDAT0.......61000
         ERRCOD = 'REA-INP-7C'                                           INDAT0.......61100
         READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVU,ITRMXU,TOLU               INDAT0.......61200
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......61300
         IF (INERR(1).NE.0) then
                 IErrorFlag = 76
                 return
         endif
c rbw end change
      END IF                                                             INDAT0.......61400
      KSOLVP = -1                                                        INDAT0.......61500
      KSOLVU = -1                                                        INDAT0.......61600
      DO 1250 M=0,NSLVRS-1                                               INDAT0.......61700
         IF (CSOLVP.EQ.SOLWRD(M)) KSOLVP = M                             INDAT0.......61800
         IF (CSOLVU.EQ.SOLWRD(M)) KSOLVU = M                             INDAT0.......61900
 1250 CONTINUE                                                           INDAT0.......62000
      IF ((KSOLVP.LT.0).OR.(KSOLVU.LT.0)) THEN                           INDAT0.......62100
c rbw begin change
                 IErrorFlag = 77
                 return
c         ERRCOD = 'INP-7B&C-1'                                           INDAT0.......62200
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......62300
c rbw end change
      ELSE IF ((KSOLVP*KSOLVU.EQ.0).AND.(KSOLVP+KSOLVU.NE.0)) THEN       INDAT0.......62400
c rbw begin change
                 IErrorFlag = 78
                 return
c         ERRCOD = 'INP-7B&C-2'                                           INDAT0.......62500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......62600
c rbw end change
      ELSE IF ((KSOLVU.EQ.1).OR.((KSOLVP.EQ.1).AND.(UP.NE.0D0))) THEN    INDAT0.......62700
c rbw begin change
                 IErrorFlag = 79
                 return
c         ERRCOD = 'INP-7B&C-3'                                           INDAT0.......62800
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......62900
c rbw end change
      END IF                                                             INDAT0.......63000
      IF (KSOLVP.EQ.2) THEN                                              INDAT0.......63100
         ITOLP = 0                                                       INDAT0.......63200
      ELSE                                                               INDAT0.......63300
         ITOLP = 1                                                       INDAT0.......63400
      END IF                                                             INDAT0.......63500
      IF (KSOLVU.EQ.2) THEN                                              INDAT0.......63600
         ITOLU = 0                                                       INDAT0.......63700
      ELSE                                                               INDAT0.......63800
         ITOLU = 1                                                       INDAT0.......63900
      END IF                                                             INDAT0.......64000
      NSAVEP = 10                                                        INDAT0.......64100
      NSAVEU = 10                                                        INDAT0.......64200
C                                                                        INDAT0.......64300
C                                                                        INDAT0.......64400
      RETURN                                                             INDAT0.......64500
      END                                                                INDAT0.......64600
C                                                                        INDAT0.......64700
C     SUBROUTINE        I  N  D  A  T  1           SUTRA VERSION 2.1     INDAT1.........100
C                                                                        INDAT1.........200
C *** PURPOSE :                                                          INDAT1.........300
C ***  TO INPUT, OUTPUT, AND ORGANIZE A MAJOR PORTION OF INP FILE        INDAT1.........400
C ***  INPUT DATA (DATASETS 8 THROUGH 15)                                INDAT1.........500
C                                                                        INDAT1.........600
c rbw begin change
c      SUBROUTINE INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,         INDAT1.........700
c     1   ATMIN,PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,                       INDAT1.........800
c     2   PERMYZ,PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG, INDAT1.........900
c     3   OBSPTS)                                                         INDAT1........1000
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
c rbw end
      CHARACTER*10 ADSMOD,CDUM10                                         INDAT1........1700
      CHARACTER*6 STYPE(2)                                               INDAT1........1800
      CHARACTER K5SYM(7)*1, NCOL(NCOLMX)*1, VARNK5(7)*25                 INDAT1........1900
      CHARACTER K6SYM(7)*2, LCOL(NCOLMX)*2, VARNK6(7)*25                 INDAT1........2000
      CHARACTER*1 CNODAL,CELMNT,CINCID,CVEL,CBUDG,CSCRN,CPAUSE           INDAT1........2100
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:8)                     INDAT1........2200
      CHARACTER INTFIL*1000,DOTS45*45                                    INDAT1........2300
      CHARACTER OBSNAM*40, OBSSCH*10, OBSFMT*3                           INDAT1........2400
      CHARACTER*8 VERNUM, VERNIN                                         INDAT1........2500
      TYPE (OBSDAT), DIMENSION (NOBSN) :: OBSPTS                         INDAT1........2600
      DIMENSION J5COL(NCOLMX), J6COL(NCOLMX)                             INDAT1........2700
      DIMENSION X(NN),Y(NN),Z(NN),POR(NN),SOP(NN),NREG(NN)               INDAT1........2800
      DIMENSION PERMXX(NE),PERMXY(NE),PERMXZ(NEX),PERMYX(NE),PERMYY(NE), INDAT1........2900
     1   PERMYZ(NEX),PERMZX(NEX),PERMZY(NEX),PERMZZ(NEX),PANGL1(NE),     INDAT1........3000
     2   PANGL2(NEX),PANGL3(NEX),ALMAX(NE),ALMID(NEX),ALMIN(NE),         INDAT1........3100
     3   ATMAX(NE),ATMID(NEX),ATMIN(NE),LREG(NE)                         INDAT1........3200
      DIMENSION INERR(10),RLERR(10)                                      INDAT1........3300
      DIMENSION KTYPE(2)                                                 INDAT1........3400
      DIMENSION IUNIT(0:8)                                               INDAT1........3500
      ALLOCATABLE :: INOB(:)                                             INDAT1........3600
      TYPE (LLD), POINTER :: DENTS                                       INDAT1........3700
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  INDAT1........3800
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             INDAT1........3900
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              INDAT1........4000
     1   NSOP,NSOU,NBCN                                                  INDAT1........4100
      COMMON /DIMX/ NWI,NWF,NWL,NELT,NNNX,NEX,N48                        INDAT1........4200
      COMMON /FNAMES/ UNAME,FNAME                                        INDAT1........4300
      COMMON /FUNITA/ IUNIT                                              INDAT1........4400
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     INDAT1........4500
      COMMON /GRAVEC/ GRAVX,GRAVY,GRAVZ                                  INDAT1........4600
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      INDAT1........4700
      COMMON /JCOLS/ NCOLPR, LCOLPR, NCOLS5, NCOLS6, J5COL, J6COL        INDAT1........4800
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     INDAT1........4900
     1   KSCRN,KPAUSE                                                    INDAT1........5000
      COMMON /MODSOR/ ADSMOD                                             INDAT1........5100
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      INDAT1........5200
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      INDAT1........5300
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        INDAT1........5400
      COMMON /SCH/ NSCH,ISCHTS                                           INDAT1........5500
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       INDAT1........5600
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITMAX,TSTART                  INDAT1........5700
      COMMON /VER/ VERNUM, VERNIN                                        INDAT1........5800
      DATA STYPE(1)/'ENERGY'/,STYPE(2)/'SOLUTE'/                         INDAT1........5900
      DATA (K5SYM(MM), MM=1,7) /'N', 'X', 'Y', 'Z', 'P', 'U', 'S'/       INDAT1........6000
      DATA (VARNK5(MM), MM=1,7) /'NODE NUMBER',                          INDAT1........6100
     1   'X-COORDINATE', 'Y-COORDINATE', 'Z-COORDINATE',                 INDAT1........6200
     2   'PRESSURE', 'CONCENTRATION/TEMPERATURE', 'SATURATION'/          INDAT1........6300
      DATA (K6SYM(MM), MM=1,7) /'E', 'X', 'Y', 'Z', 'VX', 'VY', 'VZ'/    INDAT1........6400
      DATA (VARNK6(MM), MM=1,7) /'ELEMENT NUMBER',                       INDAT1........6500
     1   'X-COORDINATE OF CENTROID', 'Y-COORDINATE OF CENTROID',         INDAT1........6600
     2   'Z-COORDINATE OF CENTROID', 'X-VELOCITY', 'Y-VELOCITY',         INDAT1........6700
     3   'Z-VELOCITY'/                                                   INDAT1........6800
      DATA DOTS45 /'.............................................'/      INDAT1........6900
      SAVE STYPE,K5SYM,VARNK5,K6SYM,VARNK6                               INDAT1........7000
C                                                                        INDAT1........7100
      INSTOP=0                                                           INDAT1........7200
C                                                                        INDAT1........7300
C.....INPUT DATASET 8A:  OUTPUT CONTROLS AND OPTIONS FOR LST FILE        INDAT1........7400
C        AND SCREEN                                                      INDAT1........7500
      ERRCOD = 'REA-INP-8A'                                              INDAT1........7600
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1........7700
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 167
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NPRINT,CNODAL,CELMNT,CINCID,        INDAT1........7800
     1   CVEL,CBUDG,CSCRN,CPAUSE                                         INDAT1........7900
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1........8000
      IF (INERR(1).NE.0) then
                 IErrorFlag = 80
                 return
      endif
c rbw end change
      IF (CNODAL.EQ.'Y') THEN                                            INDAT1........8100
         KNODAL = +1                                                     INDAT1........8200
      ELSE IF (CNODAL.EQ.'N') THEN                                       INDAT1........8300
         KNODAL = 0                                                      INDAT1........8400
      ELSE                                                               INDAT1........8500
c rbw begin change
                 IErrorFlag = 81
                 return
c         ERRCOD = 'INP-8A-1'                                             INDAT1........8600
c         CHERR(1) = 'CNODAL '                                            INDAT1........8700
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1........8800
c rbw end change
      END IF                                                             INDAT1........8900
      IF (CELMNT.EQ.'Y') THEN                                            INDAT1........9000
         KELMNT = +1                                                     INDAT1........9100
      ELSE IF (CELMNT.EQ.'N') THEN                                       INDAT1........9200
         KELMNT = 0                                                      INDAT1........9300
      ELSE                                                               INDAT1........9400
c rbw begin change
                 IErrorFlag = 82
                 return
c         ERRCOD = 'INP-8A-2'                                             INDAT1........9500
c         CHERR(1) = 'CELMNT'                                             INDAT1........9600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1........9700
c rbw end change
      END IF                                                             INDAT1........9800
      IF (CINCID.EQ.'Y') THEN                                            INDAT1........9900
         KINCID = +1                                                     INDAT1.......10000
      ELSE IF (CINCID.EQ.'N') THEN                                       INDAT1.......10100
         KINCID = 0                                                      INDAT1.......10200
      ELSE                                                               INDAT1.......10300
c rbw begin change
                 IErrorFlag = 82
                 return
c         ERRCOD = 'INP-8A-3'                                             INDAT1.......10400
c         CHERR(1) = 'CINCID'                                             INDAT1.......10500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......10600
c rbw end change
      END IF                                                             INDAT1.......10700
      IF (CVEL.EQ.'Y') THEN                                              INDAT1.......10800
         KVEL = +1                                                       INDAT1.......10900
      ELSE IF (CVEL.EQ.'N') THEN                                         INDAT1.......11000
         KVEL = 0                                                        INDAT1.......11100
      ELSE                                                               INDAT1.......11200
c rbw begin change
                 IErrorFlag = 83
                 return
c         ERRCOD = 'INP-8A-4'                                             INDAT1.......11300
c         CHERR(1) = 'CVEL  '                                             INDAT1.......11400
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......11500
c rbw end change
      END IF                                                             INDAT1.......11600
      IF (CBUDG.EQ.'Y') THEN                                             INDAT1.......11700
         KBUDG = +1                                                      INDAT1.......11800
      ELSE IF (CBUDG.EQ.'N') THEN                                        INDAT1.......11900
         KBUDG = 0                                                       INDAT1.......12000
      ELSE                                                               INDAT1.......12100
c rbw begin change
                 IErrorFlag = 84
                 return
c         ERRCOD = 'INP-8A-5'                                             INDAT1.......12200
c         CHERR(1) = 'CBUDG '                                             INDAT1.......12300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......12400
c rbw end change
      END IF                                                             INDAT1.......12500
      IF (CSCRN.EQ.'Y') THEN                                             INDAT1.......12600
         KSCRN = +1                                                      INDAT1.......12700
      ELSE IF (CSCRN.EQ.'N') THEN                                        INDAT1.......12800
         KSCRN = 0                                                       INDAT1.......12900
      ELSE                                                               INDAT1.......13000
c rbw begin change
                 IErrorFlag = 85
                 return
c         ERRCOD = 'INP-8A-6'                                             INDAT1.......13100
c         CHERR(1) = 'CSCRN '                                             INDAT1.......13200
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......13300
c rbw end change
      END IF                                                             INDAT1.......13400
      IF (CPAUSE.EQ.'Y') THEN                                            INDAT1.......13500
         KPAUSE = +1                                                     INDAT1.......13600
      ELSE IF (CPAUSE.EQ.'N') THEN                                       INDAT1.......13700
         KPAUSE = 0                                                      INDAT1.......13800
      ELSE                                                               INDAT1.......13900
c rbw begin change
                 IErrorFlag = 86
                 return
c         ERRCOD = 'INP-8A-7'                                             INDAT1.......14000
c         CHERR(1) = 'CPAUSE'                                             INDAT1.......14100
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......14200
c rbw end change
      END IF                                                             INDAT1.......14300
C                                                                        INDAT1.......14400
c rbw begin change
c      WRITE(K3,72) NPRINT                                                INDAT1.......14500
c rbw end change
   72 FORMAT(////11X,'O U T P U T   C O N T R O L S   A N D   ',         INDAT1.......14600
     1   'O P T I O N S'//13X,'.LST FILE'/13X,'---------'                INDAT1.......14700
     2   //13X,I8,3X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)')             INDAT1.......14800
c rbw begin change
c      IF(KNODAL.EQ.+1) WRITE(K3,74)                                      INDAT1.......14900
c      IF(KNODAL.EQ.0) WRITE(K3,75)                                       INDAT1.......15000
c rbw end change
   74 FORMAT(/13X,'- PRINT NODE COORDINATES, THICKNESSES AND',           INDAT1.......15100
     1   ' POROSITIES')                                                  INDAT1.......15200
   75 FORMAT(/13X,'- CANCEL PRINT OF NODE COORDINATES, THICKNESSES AND', INDAT1.......15300
     1   ' POROSITIES')                                                  INDAT1.......15400
c rbw begin change
c      IF(KELMNT.EQ.+1) WRITE(K3,76)                                      INDAT1.......15500
c      IF(KELMNT.EQ.0) WRITE(K3,77)                                       INDAT1.......15600
c rbw end change
   76 FORMAT(13X,'- PRINT ELEMENT PERMEABILITIES AND DISPERSIVITIES')    INDAT1.......15700
   77 FORMAT(13X,'- CANCEL PRINT OF ELEMENT PERMEABILITIES AND ',        INDAT1.......15800
     1   'DISPERSIVITIES')                                               INDAT1.......15900
c rbw begin change
c      IF(KINCID.EQ.+1) WRITE(K3,78)                                      INDAT1.......16000
c      IF(KINCID.EQ.0) WRITE(K3,79)                                       INDAT1.......16100
c rbw end change
   78 FORMAT(13X,'- PRINT NODE INCIDENCES IN EACH ELEMENT')              INDAT1.......16200
   79 FORMAT(13X,'- CANCEL PRINT OF NODE INCIDENCES IN EACH ELEMENT')    INDAT1.......16300
      IME=2                                                              INDAT1.......16400
      IF(ME.EQ.+1) IME=1                                                 INDAT1.......16500
c rbw begin change
c      IF(KVEL.EQ.+1) WRITE(K3,84)                                        INDAT1.......16600
c      IF(KVEL.EQ.0) WRITE(K3,85)                                         INDAT1.......16700
c rbw end change
   84 FORMAT(/13X,'- CALCULATE AND PRINT VELOCITIES AT ELEMENT ',        INDAT1.......16800
     1   'CENTROIDS ON EACH TIME STEP WITH OUTPUT')                      INDAT1.......16900
   85 FORMAT(/13X,'- CANCEL PRINT OF VELOCITIES')                        INDAT1.......17000
c rbw begin change
c      IF(KBUDG.EQ.+1) WRITE(K3,86) STYPE(IME)                            INDAT1.......17100
c      IF(KBUDG.EQ.0) WRITE(K3,87)                                        INDAT1.......17200
c rbw end change
   86 FORMAT(/13X,'- CALCULATE AND PRINT FLUID AND ',A6,' BUDGETS ',     INDAT1.......17300
     1   'ON EACH TIME STEP WITH OUTPUT')                                INDAT1.......17400
   87 FORMAT(/13X,'- CANCEL PRINT OF BUDGETS')                           INDAT1.......17500
C                                                                        INDAT1.......17600
C.....INPUT DATASET 8B:  OUTPUT CONTROLS AND OPTIONS FOR NOD FILE        INDAT1.......17700
      ERRCOD = 'REA-INP-8B'                                              INDAT1.......17800
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......17900
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 168
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NCOLPR                              INDAT1.......18000
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......18100
      IF (INERR(1).NE.0) then
                 IErrorFlag = 87
                 return
      endif
c rbw end change
      DO 140 M=1,NCOLMX                                                  INDAT1.......18200
         READ(INTFIL,*,IOSTAT=INERR(1)) NCOLPR, (NCOL(MM), MM=1,M)       INDAT1.......18300
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......18400
         IF (INERR(1).NE.0) then
                 IErrorFlag = 88
                 return
         endif
c rbw end change
         IF (NCOL(M).EQ.'-') THEN                                        INDAT1.......18500
            NCOLS5 = M - 1                                               INDAT1.......18600
            GOTO 142                                                     INDAT1.......18700
         END IF                                                          INDAT1.......18800
  140 CONTINUE                                                           INDAT1.......18900
      NCOLS5 = NCOLMX                                                    INDAT1.......19000
  142 CONTINUE                                                           INDAT1.......19100
c rbw begin change
c      WRITE(K3,144) NCOLPR                                               INDAT1.......19200
c rbw end change
  144 FORMAT (//13X,'.NOD FILE'/13X,'---------'                          INDAT1.......19300
     1   //13X,I8,3X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)'/)            INDAT1.......19400
      DO 148 M=1,NCOLS5                                                  INDAT1.......19500
         DO 146 MM=1,7                                                   INDAT1.......19600
            IF (NCOL(M).EQ.K5SYM(MM)) THEN                               INDAT1.......19700
               IF ((MM.EQ.1).AND.(M.NE.1)) THEN                          INDAT1.......19800
c rbw begin change
                 IErrorFlag = 89
                 return
c                  ERRCOD = 'INP-8B-1'                                    INDAT1.......19900
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......20000
c rbw end change
               END IF                                                    INDAT1.......20100
               IF ((MM.EQ.4).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......20200
c rbw begin change
                 IErrorFlag = 90
                 return
c                  ERRCOD = 'INP-8B-2'                                    INDAT1.......20300
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......20400
c rbw end change
               END IF                                                    INDAT1.......20500
               J5COL(M) = MM                                             INDAT1.......20600
               GOTO 148                                                  INDAT1.......20700
            END IF                                                       INDAT1.......20800
  146    CONTINUE                                                        INDAT1.......20900
c rbw begin change
                 IErrorFlag = 91
                 return
c         ERRCOD = 'INP-8B-3'                                             INDAT1.......21000
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......21100
c rbw end change
  148 CONTINUE                                                           INDAT1.......21200
c rbw begin change
c      WRITE(K3,150) (M,VARNK5(J5COL(M)),M=1,NCOLS5)                      INDAT1.......21300
c rbw end change
  150 FORMAT (13X,'COLUMN ',I1,':',2X,A)                                 INDAT1.......21400
C                                                                        INDAT1.......21500
C.....INPUT DATASET 8C:  OUTPUT CONTROLS AND OPTIONS FOR ELE FILE        INDAT1.......21600
      ERRCOD = 'REA-INP-8C'                                              INDAT1.......21700
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......21800
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 169
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) LCOLPR                              INDAT1.......21900
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......22000
      IF (INERR(1).NE.0) then
                 IErrorFlag = 92
                 return
      endif
c rbw end change
      DO 160 M=1,NCOLMX                                                  INDAT1.......22100
         READ(INTFIL,*,IOSTAT=INERR(1)) LCOLPR, (LCOL(MM), MM=1,M)       INDAT1.......22200
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......22300
         IF (INERR(1).NE.0) then
                 IErrorFlag = 93
                 return
         endif
c rbw end change
         IF (LCOL(M).EQ.'-') THEN                                        INDAT1.......22400
            NCOLS6 = M - 1                                               INDAT1.......22500
            GOTO 162                                                     INDAT1.......22600
         END IF                                                          INDAT1.......22700
  160 CONTINUE                                                           INDAT1.......22800
      NCOLS6 = NCOLMX                                                    INDAT1.......22900
  162 CONTINUE                                                           INDAT1.......23000
c rbw begin change
c      WRITE(K3,164) LCOLPR                                               INDAT1.......23100
c rbw end change
  164 FORMAT (//13X,'.ELE FILE'/13X,'---------'                          INDAT1.......23200
     1   //13X,I8,3X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)'/)            INDAT1.......23300
      DO 168 M=1,NCOLS6                                                  INDAT1.......23400
         DO 166 MM=1,7                                                   INDAT1.......23500
            IF (LCOL(M).EQ.K6SYM(MM)) THEN                               INDAT1.......23600
               IF ((MM.EQ.1).AND.(M.NE.1)) THEN                          INDAT1.......23700
c rbw begin change
                 IErrorFlag = 94
                 return
c                  ERRCOD = 'INP-8C-1'                                    INDAT1.......23800
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......23900
c rbw end change
               END IF                                                    INDAT1.......24000
               IF ((MM.EQ.4).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......24100
c rbw begin change
                 IErrorFlag = 95
                 return
c                  ERRCOD = 'INP-8C-2'                                    INDAT1.......24200
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......24300
c rbw end change
               END IF                                                    INDAT1.......24400
               IF ((MM.EQ.7).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......24500
c rbw begin change
                 IErrorFlag = 96
                 return
c                  ERRCOD = 'INP-8C-4'                                    INDAT1.......24600
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......24700
c rbw end change
               END IF                                                    INDAT1.......24800
               J6COL(M) = MM                                             INDAT1.......24900
               GOTO 168                                                  INDAT1.......25000
            END IF                                                       INDAT1.......25100
  166    CONTINUE                                                        INDAT1.......25200
c rbw begin change
                 IErrorFlag = 97
                 return
c         ERRCOD = 'INP-8C-3'                                             INDAT1.......25300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......25400
c rbw end change
  168 CONTINUE                                                           INDAT1.......25500
c rbw begin change
c      WRITE(K3,170) (M,VARNK6(J6COL(M)),M=1,NCOLS6)                      INDAT1.......25600
c rbw end change
  170 FORMAT (13X,'COLUMN ',I1,':',2X,A)                                 INDAT1.......25700
C                                                                        INDAT1.......25800
C.....INPUT DATASET 8D:  OUTPUT CONTROLS AND OPTIONS FOR OBSERVATIONS    INDAT1.......25900
      NOBCYC = ITMAX + 1                                                 INDAT1.......26000
      IF (NOBSN-1.EQ.0) GOTO 1199                                        INDAT1.......26100
C.....NOBS IS ACTUAL NUMBER OF OBSERVATION POINTS                        INDAT1.......26200
C.....NTOBS IS MAXIMUM NUMBER OF TIME STEPS WITH OBSERVATIONS            INDAT1.......26300
      NOBS=NOBSN-1                                                       INDAT1.......26400
C.....READ IN OBSERVATION POINTS                                         INDAT1.......26500
      ERRCOD = 'REA-INP-8D'                                              INDAT1.......26600
C.....DO THIS READ NOW TO SKIP ANY COMMENTS AND BLANK LINES.             INDAT1.......26700
C        (BACKSPACE LATER IF IT MUST BE REREAD IN OLD FORMAT.)           INDAT1.......26800
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......26900
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 170
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) NOBLIN                              INDAT1.......27000
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......27100
      IF (INERR(1).NE.0) then
                 IErrorFlag = 98
                 return
      endif
c rbw end change
C.....IF TRANSPORT IS STEADY-STATE, CONSTRUCT A TRIVIAL SCHEDULE.        INDAT1.......27200
      IF (ISSTRA.EQ.1) THEN                                              INDAT1.......27300
         SCHDLS(2)%NAME = "-"                                            INDAT1.......27400
         TIME = TSTART                                                   INDAT1.......27500
         STEP = 0D0                                                      INDAT1.......27600
         LSTLEN = 0                                                      INDAT1.......27700
         CALL LLDINS(LSTLEN, SCHDLS(2)%SLIST, TIME, STEP)                INDAT1.......27800
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         STEP = 1D0                                                      INDAT1.......27900
         CALL LLDINS(LSTLEN, SCHDLS(2)%SLIST, TIME, STEP)                INDAT1.......28000
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
         SCHDLS(2)%LLEN = LSTLEN                                         INDAT1.......28100
      END IF                                                             INDAT1.......28200
C.....IF OLD (VERSION 2.0) INPUT FORMAT IS BEING USED, CONSTRUCT A       INDAT1.......28300
C        CORRESPONDING OBSERVATION OUTPUT SCHEDULE IF TRANSPORT IS       INDAT1.......28400
C        TRANSIENT.                                                      INDAT1.......28500
      IF (VERNIN.EQ."2.0") THEN                                          INDAT1.......28600
C........SET THE MAX NUMBER OF OBSERVATIONS PER LINE TO THE TOTAL        INDAT1.......28700
C           NUMBER OF OBSERVATIONS.                                      INDAT1.......28800
         NOBLIN = NOBS                                                   INDAT1.......28900
C........SET UP A TEMPORARY ARRAY TO HOLD OBSERVATION NODES.             INDAT1.......29000
         ALLOCATE(INOB(NOBSN))                                           INDAT1.......29100
C........BACKSPACE AND REREAD DATASET IN OLD FORMAT                      INDAT1.......29200
         BACKSPACE(K1)                                                   INDAT1.......29300
         READ(K1,*,IOSTAT=INERR(1)) NOBCYC, (INOB(JJ), JJ=1,NOBSN)       INDAT1.......29400
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......29500
         IF (INERR(1).NE.0) then
                 IErrorFlag = 99
                 return
         endif
c rbw end change
C........IF THE LAST NODE NUMBER IS NOT ZERO, GENERATE AN ERROR.         INDAT1.......29600
         IF (INOB(NOBSN).NE.0) THEN                                      INDAT1.......29700
c rbw begin change
                 IErrorFlag = 100
                 return
c            ERRCOD = 'INP-8D-1'                                          INDAT1.......29800
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT1.......29900
c rbw end change
         END IF                                                          INDAT1.......30000
C........IF A NODE NUMBER IS INVALID, GENERATE AN ERROR.                 INDAT1.......30100
         DO 510 JJ=1,NOBS                                                INDAT1.......30200
            IF ((INOB(JJ).LT.1).OR.(INOB(JJ).GT.NN)) THEN                INDAT1.......30300
c rbw begin change
                 IErrorFlag = 101
                 return
c               ERRCOD = 'INP-8D-2'                                       INDAT1.......30400
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  INDAT1.......30500
c rbw end change
            END IF                                                       INDAT1.......30600
  510    CONTINUE                                                        INDAT1.......30700
C........IF TRANSPORT IS TRANSIENT, CONSTRUCT A SCHEDULE THAT            INDAT1.......30800
C           CORRESPONDS TO THE CYCLE SPECIFIED BY NOBCYC.                INDAT1.......30900
         IF (ISSTRA.EQ.0) THEN                                           INDAT1.......31000
            SCHDLS(2)%LLEN = 0                                           INDAT1.......31100
            SCHDLS(2)%NAME = "-"                                         INDAT1.......31200
            ISTEPI = 0                                                   INDAT1.......31300
            ISTEPL = ITMAX                                               INDAT1.......31400
            ITERM = ISTEPL - ISTEPI                                      INDAT1.......31500
C...........IF NOBCYC=0, SET THE CYCLE TO THE TOTAL NUMBER OF TIME       INDAT1.......31600
C              STEPS, SO THAT THE SCHEDULE CONSISTS OF TIME STEPS        INDAT1.......31700
C              0, 1, AND ITMAX.  (VERSION 2.0 SIMPLY BOMBS IF            INDAT1.......31800
C              NOBCYC=0.)                                                INDAT1.......31900
            IF (NOBCYC.EQ.0) THEN                                        INDAT1.......32000
               ISTEPC = ITERM                                            INDAT1.......32100
            ELSE                                                         INDAT1.......32200
               ISTEPC = IABS(NOBCYC)                                     INDAT1.......32300
            END IF                                                       INDAT1.......32400
            NTORS = INT(ITERM/ISTEPC) + 1                                INDAT1.......32500
            IF (MOD(ITERM,ISTEPC).NE.0) NTORS = NTORS + 1                INDAT1.......32600
            NSTEP = ISTEPI                                               INDAT1.......32700
            LSTLEN = 0                                                   INDAT1.......32800
            DENTS => SCHDLS(ISCHTS)%SLIST                                INDAT1.......32900
            JT = 0                                                       INDAT1.......33000
            DO 580 NT=1,NTORS                                            INDAT1.......33100
               NSTEP = MIN(ISTEPL, ISTEPI + (NT - 1)*ISTEPC)             INDAT1.......33200
               DO WHILE (NSTEP.GT.JT)                                    INDAT1.......33300
                  DENTS => DENTS%NENT                                    INDAT1.......33400
                  JT = JT + 1                                            INDAT1.......33500
               END DO                                                    INDAT1.......33600
               STEP = DENTS%DVALU2                                       INDAT1.......33700
               TIME = DENTS%DVALU1                                       INDAT1.......33800
               CALL LLDINS(LSTLEN, SCHDLS(2)%SLIST, TIME, STEP)          INDAT1.......33900
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
  580       CONTINUE                                                     INDAT1.......34000
C...........IF NOBCYC>=0, INCLUDE TIME STEP 1 IF NOT ALREADY INCLUDED.   INDAT1.......34100
            IF ((NOBCYC.GE.0).AND.(NOBCYC.NE.1)) THEN                    INDAT1.......34200
               DENTS => SCHDLS(ISCHTS)%SLIST                             INDAT1.......34300
               STEP = DNINT(DBLE(1))                                     INDAT1.......34400
               TIME = DENTS%NENT%DVALU1                                  INDAT1.......34500
               CALL LLDINS(LSTLEN, SCHDLS(2)%SLIST, TIME, STEP)          INDAT1.......34600
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            END IF                                                       INDAT1.......34700
            SCHDLS(2)%LLEN = LSTLEN                                      INDAT1.......34800
         END IF                                                          INDAT1.......34900
C........CONVERT NODES TO GENERALIZED OBSERVATION POINTS.  THE POINTS    INDAT1.......35000
C           ARE NAMED "NODE_#", WHERE # IS THE NODE NUMBER.              INDAT1.......35100
         DO 540 I=1,NOBS                                                 INDAT1.......35200
c rbw begin change
c            WRITE(OBSPTS(I)%NAME,*) INOB(I)                              INDAT1.......35300
c rbw end change
            OBSPTS(I)%NAME = "NODE_" // ADJUSTL(OBSPTS(I)%NAME)          INDAT1.......35400
            OBSPTS(I)%SCHED = "-"                                        INDAT1.......35500
            OBSPTS(I)%FRMT = "OBS"                                       INDAT1.......35600
            OBSPTS(I)%L = INOB(I)                                        INDAT1.......35700
  540    CONTINUE                                                        INDAT1.......35800
C........DEALLOCATE TEMPORARY ARRAY.                                     INDAT1.......35900
         DEALLOCATE(INOB)                                                INDAT1.......36000
C........SKIP PAST THE CODE THAT READS A LIST OF GENERALIZED             INDAT1.......36100
C           OBSERVATION POINTS.                                          INDAT1.......36200
         GOTO 820                                                        INDAT1.......36300
      END IF                                                             INDAT1.......36400
C.....READ THE LIST OF GENERALIZED OBSERVATION POINTS.                   INDAT1.......36500
      NOBCYC = -1                                                        INDAT1.......36600
      DO 690 I=1,NOBS                                                    INDAT1.......36700
C........READ THE OBSERVATION NAME.                                      INDAT1.......36800
         CALL READIF(K1, INTFIL, ERRCOD)                                 INDAT1.......36900
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 171
        return
      endif
c rbw end change
         READ(INTFIL,*,IOSTAT=INERR(1)) OBSNAM                           INDAT1.......37000
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......37100
         IF (INERR(1).NE.0) then
                 IErrorFlag = 102
                 return
         endif
c rbw end change
C........IF END-OF-LIST MARKER ENCOUNTERED TOO SOON, GENERATE ERROR.     INDAT1.......37200
         IF (OBSNAM.EQ.'-') THEN                                         INDAT1.......37300
c rbw begin change
                 IErrorFlag = 103
                 return
c            ERRCOD = 'INP-8D-4'                                          INDAT1.......37400
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT1.......37500
c rbw end change
         END IF                                                          INDAT1.......37600
C........READ IN (X,Y,Z) OR (X,Y) COORDINATES, DEPENDING ON PROBLEM      INDAT1.......37700
C           DIMENSIONALITY, AS WELL AS OUTPUT SCHEDULE AND FORMAT.       INDAT1.......37800
         IF (KTYPE(1).EQ.3) THEN                                         INDAT1.......37900
            READ(INTFIL,*,IOSTAT=INERR(1)) OBSNAM, XOBS, YOBS, ZOBS,     INDAT1.......38000
     1         OBSSCH, OBSFMT                                            INDAT1.......38100
         ELSE                                                            INDAT1.......38200
            READ(INTFIL,*,IOSTAT=INERR(1)) OBSNAM, XOBS, YOBS,           INDAT1.......38300
     1         OBSSCH, OBSFMT                                            INDAT1.......38400
         END IF                                                          INDAT1.......38500
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......38600
         IF (INERR(1).NE.0) then
                 IErrorFlag = 104
                 return
         endif
c rbw end change
         OBSPTS(I)%NAME = OBSNAM                                         INDAT1.......38700
         OBSPTS(I)%X = XOBS                                              INDAT1.......38800
         OBSPTS(I)%Y = YOBS                                              INDAT1.......38900
         OBSPTS(I)%Z = ZOBS                                              INDAT1.......39000
         IF (ISSTRA.EQ.1) THEN                                           INDAT1.......39100
            OBSPTS(I)%SCHED = "-"                                        INDAT1.......39200
         ELSE                                                            INDAT1.......39300
            OBSPTS(I)%SCHED = OBSSCH                                     INDAT1.......39400
         END IF                                                          INDAT1.......39500
         OBSPTS(I)%FRMT = OBSFMT                                         INDAT1.......39600
  690 CONTINUE                                                           INDAT1.......39700
C.....READ ONE MORE LINE TO CHECK FOR THE END-OF-LIST MARKER ('-').      INDAT1.......39800
C        IF NOT FOUND, GENERATE ERROR.                                   INDAT1.......39900
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......40000
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 172
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) OBSNAM                              INDAT1.......40100
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......40200
      IF (INERR(1).NE.0) then
                 IErrorFlag = 105
                 return
      endif
c rbw end change
      IF (OBSNAM.NE.'-') THEN                                            INDAT1.......40300
c rbw begin change
                 IErrorFlag = 106
                 return
c         ERRCOD = 'INP-8D-4'                                             INDAT1.......40400
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......40500
c rbw end change
      END IF                                                             INDAT1.......40600
C                                                                        INDAT1.......40700
C.....CONDENSE SCHEDULE AND FILE TYPE INFORMATION FROM OBSDAT INTO       INDAT1.......40800
C        ARRAY OFP, CHECKING FOR UNDEFINED SCHEDULES                     INDAT1.......40900
  820 ALLOCATE (OFP(NSCH*2))                                             INDAT1.......41000
      IF (ISSTRA.EQ.1) THEN                                              INDAT1.......41100
         NFLOMX=0                                                        INDAT1.......41200
         DO 840 I=1,NOBS                                                 INDAT1.......41300
            DO 835 J=1,NFLOMX                                            INDAT1.......41400
               IF (OBSPTS(I)%FRMT.EQ.OFP(J)%FRMT) GOTO 840               INDAT1.......41500
  835       CONTINUE                                                     INDAT1.......41600
            NFLOMX = NFLOMX + 1                                          INDAT1.......41700
            OFP(NFLOMX)%ISCHED = 2                                       INDAT1.......41800
            OFP(NFLOMX)%FRMT = OBSPTS(I)%FRMT                            INDAT1.......41900
  840    CONTINUE                                                        INDAT1.......42000
      ELSE                                                               INDAT1.......42100
         NFLOMX = 0                                                      INDAT1.......42200
         DO 860 I=1,NOBS                                                 INDAT1.......42300
            DO 850 NS=1,NSCH                                             INDAT1.......42400
               IF (OBSPTS(I)%SCHED.EQ.SCHDLS(NS)%NAME) THEN              INDAT1.......42500
                  INS = NS                                               INDAT1.......42600
                  GOTO 852                                               INDAT1.......42700
               END IF                                                    INDAT1.......42800
  850       CONTINUE                                                     INDAT1.......42900
c rbw begin change
                 IErrorFlag = 107
                 return
c            ERRCOD = 'INP-8D-5'                                          INDAT1.......43000
c            CHERR(1) = OBSPTS(I)%SCHED                                   INDAT1.......43100
c            CHERR(2) = OBSPTS(I)%NAME                                    INDAT1.......43200
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT1.......43300
c rbw end change
  852       DO 855 J=1,NFLOMX                                            INDAT1.......43400
               IF ((OBSPTS(I)%SCHED.EQ.SCHDLS(OFP(J)%ISCHED)%NAME).AND.  INDAT1.......43500
     1             (OBSPTS(I)%FRMT.EQ.OFP(J)%FRMT)) GOTO 860             INDAT1.......43600
  855       CONTINUE                                                     INDAT1.......43700
            NFLOMX = NFLOMX + 1                                          INDAT1.......43800
            OFP(NFLOMX)%ISCHED = INS                                     INDAT1.......43900
            OFP(NFLOMX)%FRMT = OBSPTS(I)%FRMT                            INDAT1.......44000
  860    CONTINUE                                                        INDAT1.......44100
      END IF                                                             INDAT1.......44200
C                                                                        INDAT1.......44300
C.....ASSIGN UNIT NUMBERS AND OPEN FILE UNITS FOR OBSERVATION OUTPUT     INDAT1.......44400
C        FILES.                                                          INDAT1.......44500
      ALLOCATE(IUNIO(NFLOMX),FNAMO(NFLOMX))                              INDAT1.......44600
c rbw begin change
c      CALL FOPEN()                                                       INDAT1.......44700
      CALL FOPEN(InputFile)                                                       INDAT1.......44700
c rbw end change

C                                                                        INDAT1.......44800
C.....OUTPUT OBSERVATION FILE INFORMATION                                INDAT1.......44900
      IF (ISSTRA.EQ.1) THEN                                              INDAT1.......45000
c rbw begin change
c         WRITE(K3,868) IUNIO(1),FNAMO(1)                                 INDAT1.......45100
c rbw end change
  868    FORMAT (//13X,'.OBS AND .OBC FILES'/13X,'-------------------'// INDAT1.......45200
     1      (13X,'UNIT ',I7,4X,'ASSIGNED TO ',A80))                      INDAT1.......45300
c rbw begin change
c         WRITE(K3,869)                                                   INDAT1.......45400
c rbw end change
  869    FORMAT (/13X,'NOTE: BECAUSE FLOW AND TRANSPORT ARE STEADY-',    INDAT1.......45500
     1      'STATE, USER-DEFINED SCHEDULES ARE NOT IN EFFECT.  '         INDAT1.......45600
     2      /13X,'STEADY-STATE OBSERVATIONS WILL BE WRITTEN TO THE ',    INDAT1.......45700
     3      'APPROPRIATE OUTPUT FILES.')                                 INDAT1.......45800
      ELSE IF (VERNIN.NE."2.0") THEN                                     INDAT1.......45900
c rbw begin change
c         WRITE(K3,870) (SCHDLS(OFP(J)%ISCHED)%NAME,OFP(J)%FRMT,          INDAT1.......46000
c     1      IUNIO(J),FNAMO(J),J=1,NFLOMX)                                INDAT1.......46100
c rbw end change
  870    FORMAT (//13X,'.OBS AND .OBC FILES'/13X,'-------------------'// INDAT1.......46200
     1      (13X,'SCHEDULE ',A,', FORMAT ',A,', UNIT ',I7,4X,            INDAT1.......46300
     2      'ASSIGNED TO ',A80))                                         INDAT1.......46400
      ELSE                                                               INDAT1.......46500
c rbw begin change
c         WRITE(K3,868) IUNIO(1),FNAMO(1)                                 INDAT1.......46600
c         WRITE(K3,872) NOBCYC, SCHDLS(2)%LLEN                            INDAT1.......46700
c rbw end change
  872    FORMAT (/13X,'NOTE: OBSERVATION OUTPUT CYCLING ',               INDAT1.......46800
     1      'INFORMATION WAS ENTERED USING THE OLD (VERSION 2D3D.1) '    INDAT1.......46900
     2      'INPUT FORMAT.'/13X,'OBSERVATIONS WILL BE MADE EVERY ',I8,   INDAT1.......47000
     3      ' TIME STEPS, AS WELL AS ON THE FIRST AND LAST TIME STEP,'   INDAT1.......47100
     4      /13X,'FOR A TOTAL OF ',I8,' TIME STEPS.')                    INDAT1.......47200
      END IF                                                             INDAT1.......47300
C                                                                        INDAT1.......47400
C.....OUTPUT GENERALIZED OBSERVATION POINT INFORMATION.                  INDAT1.......47500
c rbw begin change
c      WRITE(K3,1182)                                                     INDAT1.......47600
c rbw end change
 1182 FORMAT(////11X,'O B S E R V A T I O N   P O I N T S')              INDAT1.......47700
C.....3D PROBLEM.                                                        INDAT1.......47800
      IF (KTYPE(1).EQ.3) THEN                                            INDAT1.......47900
C........WRITE HEADER.                                                   INDAT1.......48000
c rbw begin change
c         WRITE(K3,1187)                                                  INDAT1.......48100
c rbw end change
 1187    FORMAT(                                                         INDAT1.......48200
     1        //13X,'NAME',42X,'COORDINATES',37X,'SCHEDULE',4X,'FORMAT'  INDAT1.......48300
     2         /13X,'----',42X,'-----------',37X,'--------',4X,'------') INDAT1.......48400
C........PRINT INFORMATION FOR EACH POINT.  IF POINTS WERE CONVERTED     INDAT1.......48500
C           FROM NODES, COORDINATES HAVE YET TO BE READ IN, SO PUT IN    INDAT1.......48600
C           A PLACEHOLDER.                                               INDAT1.......48700
         IF (NOBCYC.NE.-1) THEN                                          INDAT1.......48800
            DO 1189 JJ=1,NOBS                                            INDAT1.......48900
               LTOP = LEN_TRIM(OBSPTS(JJ)%NAME)                          INDAT1.......49000
c rbw begin change
c               WRITE(K3,1188) TRIM(OBSPTS(JJ)%NAME),DOTS45(1:43-LTOP),   INDAT1.......49100
c     1            OBSPTS(JJ)%SCHED,OBSPTS(JJ)%FRMT                       INDAT1.......49200
c rbw end change
 1188          FORMAT(13X,A,1X,A,1X,                                     INDAT1.......49300
     1            '( _______ TO BE READ FROM DATASET 14 _______ )',      INDAT1.......49400
     2            3X,A,2X,A)                                             INDAT1.......49500
 1189       CONTINUE                                                     INDAT1.......49600
         ELSE                                                            INDAT1.......49700
            DO 1191 JJ=1,NOBS                                            INDAT1.......49800
               LTOP = LEN_TRIM(OBSPTS(JJ)%NAME)                          INDAT1.......49900
c rbw begin change
c               WRITE(K3,1190) TRIM(OBSPTS(JJ)%NAME),DOTS45(1:43-LTOP),   INDAT1.......50000
c     1            OBSPTS(JJ)%X,OBSPTS(JJ)%Y,OBSPTS(JJ)%Z,                INDAT1.......50100
c     2            OBSPTS(JJ)%SCHED,OBSPTS(JJ)%FRMT                       INDAT1.......50200
c rbw end change
 1190          FORMAT(13X,A,1X,A,1X,'(',2(1PE14.7,','),1PE14.7,')',      INDAT1.......50300
     1            3X,A,2X,A)                                             INDAT1.......50400
 1191       CONTINUE                                                     INDAT1.......50500
         END IF                                                          INDAT1.......50600
C.....2D PROBLEM.                                                        INDAT1.......50700
      ELSE                                                               INDAT1.......50800
C........WRITE HEADER.                                                   INDAT1.......50900
c rbw begin change
c         WRITE(K3,1193)                                                  INDAT1.......51000
c rbw end change
 1193    FORMAT(                                                         INDAT1.......51100
     1        //13X,'NAME',42X,'COORDINATES',22X,'SCHEDULE',4X,'FORMAT'  INDAT1.......51200
     2         /13X,'----',42X,'-----------',22X,'--------',4X,'------') INDAT1.......51300
C........PRINT INFORMATION FOR EACH POINT.  IF POINTS WERE CONVERTED     INDAT1.......51400
C           FROM NODES, COORDINATES HAVE YET TO BE READ IN, SO PUT IN    INDAT1.......51500
C           A PLACEHOLDER.                                               INDAT1.......51600
         IF (NOBCYC.NE.-1) THEN                                          INDAT1.......51700
            DO 1195 JJ=1,NOBS                                            INDAT1.......51800
               LTOP = LEN_TRIM(OBSPTS(JJ)%NAME)                          INDAT1.......51900
c rbw begin change
c               WRITE(K3,1194) TRIM(OBSPTS(JJ)%NAME),DOTS45(1:43-LTOP),   INDAT1.......52000
c     1            OBSPTS(JJ)%SCHED,OBSPTS(JJ)%FRMT                       INDAT1.......52100
c rbw end change
 1194          FORMAT(13X,A,1X,A,1X,'( TO BE READ FROM DATASET 14  )',   INDAT1.......52200
     1            3X,A,2X,A)                                             INDAT1.......52300
 1195       CONTINUE                                                     INDAT1.......52400
         ELSE                                                            INDAT1.......52500
            DO 1197 JJ=1,NOBS                                            INDAT1.......52600
               LTOP = LEN_TRIM(OBSPTS(JJ)%NAME)                          INDAT1.......52700
c rbw begin change
c               WRITE(K3,1196) TRIM(OBSPTS(JJ)%NAME),DOTS45(1:43-LTOP),   INDAT1.......52800
c     1            OBSPTS(JJ)%X,OBSPTS(JJ)%Y,                             INDAT1.......52900
c     2            OBSPTS(JJ)%SCHED,OBSPTS(JJ)%FRMT                       INDAT1.......53000
c rbw end change
 1196          FORMAT(13X,A,1X,A,1X,'(',1PE14.7,',',1PE14.7,')',         INDAT1.......53100
     1            3X,A,2X,A)                                             INDAT1.......53200
 1197       CONTINUE                                                     INDAT1.......53300
         END IF                                                          INDAT1.......53400
      END IF                                                             INDAT1.......53500
 1199 CONTINUE                                                           INDAT1.......53600
C                                                                        INDAT1.......53700
C.....INPUT DATASET 9:  FLUID PROPERTIES                                 INDAT1.......53800
      ERRCOD = 'REA-INP-9'                                               INDAT1.......53900
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......54000
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 173
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) COMPFL,CW,SIGMAW,RHOW0,URHOW0,      INDAT1.......54100
     1   DRWDU,VISC0                                                     INDAT1.......54200
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......54300
      IF (INERR(1).NE.0) then
                 IErrorFlag = 108
                 return
      endif
c rbw end change
C.....INPUT DATASET 10:  SOLID MATRIX PROPERTIES                         INDAT1.......54400
      ERRCOD = 'REA-INP-10'                                              INDAT1.......54500
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......54600
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 174
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) COMPMA,CS,SIGMAS,RHOS               INDAT1.......54700
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......54800
      IF (INERR(1).NE.0) then
                 IErrorFlag = 109
                 return
      endif
c      IF(ME.EQ.+1)                                                       INDAT1.......54900
c     1  WRITE(K3,1210) COMPFL,COMPMA,CW,CS,VISC0,RHOS,RHOW0,DRWDU,       INDAT1.......55000
c     2     URHOW0,SIGMAW,SIGMAS                                          INDAT1.......55100
c rbw end change
 1210 FORMAT('1'////11X,'C O N S T A N T   P R O P E R T I E S   O F',   INDAT1.......55200
     1   '   F L U I D   A N D   S O L I D   M A T R I X'                INDAT1.......55300
     2   //11X,1PE15.4,5X,'COMPRESSIBILITY OF FLUID'/11X,1PE15.4,5X,     INDAT1.......55400
     3   'COMPRESSIBILITY OF POROUS MATRIX'//11X,1PE15.4,5X,             INDAT1.......55500
     4   'SPECIFIC HEAT CAPACITY OF FLUID',/11X,1PE15.4,5X,              INDAT1.......55600
     5   'SPECIFIC HEAT CAPACITY OF SOLID GRAIN'//13X,'FLUID VISCOSITY', INDAT1.......55700
     6   ' IS CALCULATED BY SUTRA AS A FUNCTION OF TEMPERATURE IN ',     INDAT1.......55800
     7   'UNITS OF {kg/(m*s)}'//11X,1PE15.4,5X,'VISC0, CONVERSION ',     INDAT1.......55900
     8   'FACTOR FOR VISCOSITY UNITS,  {desired units} = VISC0*',        INDAT1.......56000
     9   '{kg/(m*s)}'//11X,1PE15.4,5X,'DENSITY OF A SOLID GRAIN'         INDAT1.......56100
     *   //13X,'FLUID DENSITY, RHOW'/13X,'CALCULATED BY ',               INDAT1.......56200
     1   'SUTRA IN TERMS OF TEMPERATURE, U, AS:'/13X,'RHOW = RHOW0 + ',  INDAT1.......56300
     2   'DRWDU*(U-URHOW0)'//11X,1PE15.4,5X,'FLUID BASE DENSITY, RHOW0'  INDAT1.......56400
     3   /11X,1PE15.4,5X,'COEFFICIENT OF DENSITY CHANGE WITH ',          INDAT1.......56500
     4   'TEMPERATURE, DRWDU'/11X,1PE15.4,5X,'TEMPERATURE, URHOW0, ',    INDAT1.......56600
     5   'AT WHICH FLUID DENSITY IS AT BASE VALUE, RHOW0'                INDAT1.......56700
     6   //11X,1PE15.4,5X,'THERMAL CONDUCTIVITY OF FLUID'                INDAT1.......56800
     7   /11X,1PE15.4,5X,'THERMAL CONDUCTIVITY OF SOLID GRAIN')          INDAT1.......56900
c rbw begin change
c      IF(ME.EQ.-1)                                                       INDAT1.......57000
c     1  WRITE(K3,1220) COMPFL,COMPMA,VISC0,RHOS,RHOW0,DRWDU,             INDAT1.......57100
c     2     URHOW0,SIGMAW                                                 INDAT1.......57200
c rbw end change
 1220 FORMAT('1'////11X,'C O N S T A N T   P R O P E R T I E S   O F',   INDAT1.......57300
     1   '   F L U I D   A N D   S O L I D   M A T R I X'                INDAT1.......57400
     2   //11X,1PE15.4,5X,'COMPRESSIBILITY OF FLUID'/11X,1PE15.4,5X,     INDAT1.......57500
     3   'COMPRESSIBILITY OF POROUS MATRIX'                              INDAT1.......57600
     4   //11X,1PE15.4,5X,'FLUID VISCOSITY'                              INDAT1.......57700
     4   //11X,1PE15.4,5X,'DENSITY OF A SOLID GRAIN'                     INDAT1.......57800
     5   //13X,'FLUID DENSITY, RHOW'/13X,'CALCULATED BY ',               INDAT1.......57900
     6   'SUTRA IN TERMS OF SOLUTE CONCENTRATION, U, AS:',               INDAT1.......58000
     7   /13X,'RHOW = RHOW0 + DRWDU*(U-URHOW0)'                          INDAT1.......58100
     8   //11X,1PE15.4,5X,'FLUID BASE DENSITY, RHOW0'                    INDAT1.......58200
     9   /11X,1PE15.4,5X,'COEFFICIENT OF DENSITY CHANGE WITH ',          INDAT1.......58300
     *   'SOLUTE CONCENTRATION, DRWDU'                                   INDAT1.......58400
     1   /11X,1PE15.4,5X,'SOLUTE CONCENTRATION, URHOW0, ',               INDAT1.......58500
     4   'AT WHICH FLUID DENSITY IS AT BASE VALUE, RHOW0'                INDAT1.......58600
     5   //11X,1PE15.4,5X,'MOLECULAR DIFFUSIVITY OF SOLUTE IN FLUID')    INDAT1.......58700
C                                                                        INDAT1.......58800
C.....INPUT DATASET 11:  ADSORPTION PARAMETERS                           INDAT1.......58900
      ERRCOD = 'REA-INP-11'                                              INDAT1.......59000
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......59100
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 175
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) ADSMOD                              INDAT1.......59200
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......59300
      IF (INERR(1).NE.0) then
                 IErrorFlag = 110
                 return
      endif
c rbw end change
      IF (ADSMOD.NE.'NONE      ') THEN                                   INDAT1.......59400
         READ(INTFIL,*,IOSTAT=INERR(1)) ADSMOD,CHI1,CHI2                 INDAT1.......59500
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......59600
         IF (INERR(1).NE.0) then
                 IErrorFlag = 111
                 return
      endif
c rbw end change
      END IF                                                             INDAT1.......59700
      IF(ME.EQ.+1) GOTO 1248                                             INDAT1.......59800
      IF(ADSMOD.EQ.'NONE      ') GOTO 1234                               INDAT1.......59900
c rbw begin change
c      WRITE(K3,1232) ADSMOD                                              INDAT1.......60000
c rbw end change
 1232 FORMAT(////11X,'A D S O R P T I O N   P A R A M E T E R S'         INDAT1.......60100
     1   //16X,A10,5X,'EQUILIBRIUM SORPTION ISOTHERM')                   INDAT1.......60200
      GOTO 1236                                                          INDAT1.......60300
c rbw begin change
 1234 continue
c 1234 WRITE(K3,1235)                                                     INDAT1.......60400
c rbw end change
 1235 FORMAT(////11X,'A D S O R P T I O N   P A R A M E T E R S'         INDAT1.......60500
     1   //16X,'NON-SORBING SOLUTE')                                     INDAT1.......60600
 1236 IF((ADSMOD.EQ.'NONE ').OR.(ADSMOD.EQ.'LINEAR    ').OR.             INDAT1.......60700
     1   (ADSMOD.EQ.'FREUNDLICH').OR.(ADSMOD.EQ.'LANGMUIR  ')) GOTO 1238 INDAT1.......60800
c rbw begin change
                 IErrorFlag = 112
                 return
c      ERRCOD = 'INP-11-1'                                                INDAT1.......60900
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           INDAT1.......61000
 1238 continue
c 1238 IF(ADSMOD.EQ.'LINEAR    ') WRITE(K3,1242) CHI1                     INDAT1.......61100
c rbw end change
 1242 FORMAT(11X,1PE15.4,5X,'LINEAR DISTRIBUTION COEFFICIENT')           INDAT1.......61200
c rbw begin change
c      IF(ADSMOD.EQ.'FREUNDLICH') WRITE(K3,1244) CHI1,CHI2                INDAT1.......61300
c rbw end change
 1244 FORMAT(11X,1PE15.4,5X,'FREUNDLICH DISTRIBUTION COEFFICIENT'        INDAT1.......61400
     1   /11X,1PE15.4,5X,'SECOND FREUNDLICH COEFFICIENT')                INDAT1.......61500
      IF(ADSMOD.EQ.'FREUNDLICH'.AND.CHI2.LE.0.D0) THEN                   INDAT1.......61600
c rbw begin change
                 IErrorFlag = 113
                 return
c         ERRCOD = 'INP-11-2'                                             INDAT1.......61700
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......61800
c rbw end change
      ENDIF                                                              INDAT1.......61900
c rbw begin change
c      IF(ADSMOD.EQ.'LANGMUIR  ') WRITE(K3,1246) CHI1,CHI2                INDAT1.......62000
c rbw end change
 1246 FORMAT(11X,1PE15.4,5X,'LANGMUIR DISTRIBUTION COEFFICIENT'          INDAT1.......62100
     1   /11X,1PE15.4,5X,'SECOND LANGMUIR COEFFICIENT')                  INDAT1.......62200
C                                                                        INDAT1.......62300
C.....INPUT DATASET 12:  PRODUCTION OF ENERGY OR SOLUTE MASS             INDAT1.......62400
 1248 ERRCOD = 'REA-INP-12'                                              INDAT1.......62500
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......62600
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 176
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) PRODF0,PRODS0,PRODF1,PRODS1         INDAT1.......62700
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......62800
      IF (INERR(1).NE.0) then
                 IErrorFlag = 114
                 return
      endif
c      IF(ME.EQ.-1) WRITE(K3,1250) PRODF0,PRODS0,PRODF1,PRODS1            INDAT1.......62900
c rbw end change
 1250 FORMAT(////11X,'P R O D U C T I O N   A N D   D E C A Y   O F   ', INDAT1.......63000
     1   'S P E C I E S   M A S S'//13X,'PRODUCTION RATE (+)'/13X,       INDAT1.......63100
     2   'DECAY RATE (-)'//11X,1PE15.4,5X,'ZERO-ORDER RATE OF SOLUTE ',  INDAT1.......63200
     3   'MASS PRODUCTION/DECAY IN FLUID'/11X,1PE15.4,5X,                INDAT1.......63300
     4   'ZERO-ORDER RATE OF ADSORBATE MASS PRODUCTION/DECAY IN ',       INDAT1.......63400
     5   'IMMOBILE PHASE'/11X,1PE15.4,5X,'FIRST-ORDER RATE OF SOLUTE ',  INDAT1.......63500
     3   'MASS PRODUCTION/DECAY IN FLUID'/11X,1PE15.4,5X,                INDAT1.......63600
     4   'FIRST-ORDER RATE OF ADSORBATE MASS PRODUCTION/DECAY IN ',      INDAT1.......63700
     5   'IMMOBILE PHASE')                                               INDAT1.......63800
c rbw begin change
c      IF(ME.EQ.+1) WRITE(K3,1260) PRODF0,PRODS0                          INDAT1.......63900
c rbw end change
 1260 FORMAT(////11X,'P R O D U C T I O N   A N D   L O S S   O F   ',   INDAT1.......64000
     1   'E N E R G Y'//13X,'PRODUCTION RATE (+)'/13X,                   INDAT1.......64100
     2   'LOSS RATE (-)'//11X,1PE15.4,5X,'ZERO-ORDER RATE OF ENERGY ',   INDAT1.......64200
     3   'PRODUCTION/LOSS IN FLUID'/11X,1PE15.4,5X,                      INDAT1.......64300
     4   'ZERO-ORDER RATE OF ENERGY PRODUCTION/LOSS IN ',                INDAT1.......64400
     5   'SOLID GRAINS')                                                 INDAT1.......64500
C.....SET PARAMETER SWITCHES FOR EITHER ENERGY OR SOLUTE TRANSPORT       INDAT1.......64600
      IF(ME) 1272,1272,1274                                              INDAT1.......64700
C     FOR SOLUTE TRANSPORT:                                              INDAT1.......64800
 1272 CS=0.0D0                                                           INDAT1.......64900
      CW=1.D00                                                           INDAT1.......65000
      SIGMAS=0.0D0                                                       INDAT1.......65100
      GOTO 1278                                                          INDAT1.......65200
C     FOR ENERGY TRANSPORT:                                              INDAT1.......65300
 1274 ADSMOD='NONE      '                                                INDAT1.......65400
      CHI1=0.0D0                                                         INDAT1.......65500
      CHI2=0.0D0                                                         INDAT1.......65600
      PRODF1=0.0D0                                                       INDAT1.......65700
      PRODS1=0.0D0                                                       INDAT1.......65800
 1278 CONTINUE                                                           INDAT1.......65900
C                                                                        INDAT1.......66000
      IF (KTYPE(1).EQ.3) THEN                                            INDAT1.......66100
C.....READ 3D INPUT FROM DATASETS 13 - 15.                               INDAT1.......66200
C                                                                        INDAT1.......66300
C.....INPUT DATASET 13:  ORIENTATION OF COORDINATES TO GRAVITY           INDAT1.......66400
      ERRCOD = 'REA-INP-13'                                              INDAT1.......66500
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......66600
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 177
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) GRAVX,GRAVY,GRAVZ                   INDAT1.......66700
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......66800
      IF (INERR(1).NE.0) then
                 IErrorFlag = 115
                 return
      endif
c      WRITE(K3,1320) GRAVX,GRAVY,GRAVZ                                   INDAT1.......66900
c rbw end change
 1320 FORMAT(////11X,'C O O R D I N A T E   O R I E N T A T I O N   ',   INDAT1.......67000
     1   'T O   G R A V I T Y'//13X,'COMPONENT OF GRAVITY VECTOR',       INDAT1.......67100
     2   /13X,'IN +X DIRECTION, GRAVX'/11X,1PE15.4,5X,                   INDAT1.......67200
     3   'GRAVX = -GRAV * D(ELEVATION)/DX'//13X,'COMPONENT OF GRAVITY',  INDAT1.......67300
     4   ' VECTOR'/13X,'IN +Y DIRECTION, GRAVY'/11X,1PE15.4,5X,          INDAT1.......67400
     5   'GRAVY = -GRAV * D(ELEVATION)/DY'//13X,'COMPONENT OF GRAVITY',  INDAT1.......67500
     6   ' VECTOR'/13X,'IN +Z DIRECTION, GRAVZ'/11X,1PE15.4,5X,          INDAT1.......67600
     7   'GRAVZ = -GRAV * D(ELEVATION)/DZ')                              INDAT1.......67700
C                                                                        INDAT1.......67800
C.....INPUT DATASETS 14A & 14B:  NODEWISE DATA                           INDAT1.......67900
      ERRCOD = 'REA-INP-14A'                                             INDAT1.......68000
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......68100
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 178
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,SCALX,SCALY,SCALZ,PORFAC     INDAT1.......68200
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......68300
      IF (INERR(1).NE.0) then
                 IErrorFlag = 116
                 return
      endif
c rbw end change
      IF (CDUM10.NE.'NODE      ') THEN                                   INDAT1.......68400
c rbw begin change
                 IErrorFlag = 117
                 return
c         ERRCOD = 'INP-14A-1'                                            INDAT1.......68500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......68600
c rbw end change
      END IF                                                             INDAT1.......68700
      NRTEST=1                                                           INDAT1.......68800
      DO 1450 I=1,NN                                                     INDAT1.......68900
      ERRCOD = 'REA-INP-14B'                                             INDAT1.......69000
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......69100
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 179
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) II,NREG(II),X(II),Y(II),Z(II),      INDAT1.......69200
     1   POR(II)                                                         INDAT1.......69300
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......69400
      IF (INERR(1).NE.0) then
                 IErrorFlag = 118
                 return
      endif
c rbw end change
      X(II)=X(II)*SCALX                                                  INDAT1.......69500
      Y(II)=Y(II)*SCALY                                                  INDAT1.......69600
      Z(II)=Z(II)*SCALZ                                                  INDAT1.......69700
      POR(II)=POR(II)*PORFAC                                             INDAT1.......69800
      IF(I.GT.1.AND.NREG(II).NE.NROLD) NRTEST=NRTEST+1                   INDAT1.......69900
      NROLD=NREG(II)                                                     INDAT1.......70000
C.....SET SPECIFIC PRESSURE STORATIVITY, SOP.                            INDAT1.......70100
 1450 SOP(II)=(1.D0-POR(II))*COMPMA+POR(II)*COMPFL                       INDAT1.......70200
c rbw begin change
c 1460 IF(KNODAL.EQ.0) WRITE(K3,1461) SCALX,SCALY,SCALZ,PORFAC            INDAT1.......70300
c rbw end change
 1461 FORMAT('1'////11X,'N O D E   I N F O R M A T I O N'//16X,          INDAT1.......70400
     1   'PRINTOUT OF NODE COORDINATES AND POROSITIES ',                 INDAT1.......70500
     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PE15.4,5X,'X-SCALE'/   INDAT1.......70600
     3   33X,1PE15.4,5X,'Y-SCALE'/33X,1PE15.4,5X,'Z-SCALE'/              INDAT1.......70700
     4   33X,1PE15.4,5X,'POROSITY FACTOR')                               INDAT1.......70800
c rbw begin change
c      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.NE.1) WRITE(K3,1463)     INDAT1.......70900
c      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.EQ.1) WRITE(K3,1465)     INDAT1.......71000
c rbw end change
 1463 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......71100
     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......71200
 1465 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......71300
     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......71400
c rbw begin change
c      IF(KNODAL.EQ.+1.AND.IUNSAT.NE.1)                                   INDAT1.......71500
c     1   WRITE(K3,1470)(I,X(I),Y(I),Z(I),POR(I),I=1,NN)                  INDAT1.......71600
c rbw end change
 1470 FORMAT('1'//11X,'N O D E   I N F O R M A T I O N'//14X,            INDAT1.......71700
     1   'NODE',7X,'X',16X,'Y',16X,'Z',15X,'POROSITY'//                  INDAT1.......71800
     2   (9X,I9,3(3X,1PE14.5),6X,0PF8.5))                                INDAT1.......71900
c rbw begin change
c      IF(KNODAL.EQ.+1.AND.IUNSAT.EQ.1)                                   INDAT1.......72000
c     1   WRITE(K3,1480)(I,NREG(I),X(I),Y(I),Z(I),POR(I),I=1,NN)          INDAT1.......72100
c rbw end change
 1480 FORMAT('1'//11X,'N O D E   I N F O R M A T I O N'//14X,'NODE',3X,  INDAT1.......72200
     1   'REGION',7X,'X',16X,'Y',16X,'Z',15X,'POROSITY'//                INDAT1.......72300
     2   (9X,I9,3X,I6,3(3X,1PE14.5),6X,0PF8.5))                          INDAT1.......72400
C                                                                        INDAT1.......72500
C.....INPUT DATASETS 15A & 15B:  ELEMENTWISE DATA                        INDAT1.......72600
      ERRCOD = 'REA-INP-15A'                                             INDAT1.......72700
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......72800
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 180
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,PMAXFA,PMIDFA,PMINFA,        INDAT1.......72900
     1   ANG1FA,ANG2FA,ANG3FA,ALMAXF,ALMIDF,ALMINF,                      INDAT1.......73000
     1   ATMXF,ATMDF,ATMNF                                               INDAT1.......73100
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......73200
      IF (INERR(1).NE.0) then
                 IErrorFlag = 119
                 return
      endif
c rbw end change
      IF (CDUM10.NE.'ELEMENT   ') THEN                                   INDAT1.......73300
c rbw begin change
                 IErrorFlag = 120
                 return
c         ERRCOD = 'INP-15A-1'                                            INDAT1.......73400
c         CHERR(1) = '3D'                                                 INDAT1.......73500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......73600
c rbw end change
      END IF                                                             INDAT1.......73700
      IF(KELMNT.EQ.+1) THEN                                              INDAT1.......73800
         IF (IUNSAT.EQ.1) THEN                                           INDAT1.......73900
c rbw begin change
c            WRITE(K3,1500)                                               INDAT1.......74000
c rbw end change
 1500       FORMAT('1'//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......74100
     1         11X,'ELEMENT',3X,'REGION',4X,                             INDAT1.......74200
     2         'MAXIMUM',9X,'MIDDLE',10X,'MINIMUM',18X,                  INDAT1.......74300
     2         'ANGLE1',9X,'ANGLE2',9X,'ANGLE3',4X,                      INDAT1.......74400
     2         'LONGITUDINAL',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,    INDAT1.......74500
     2         'TRANSVERSE',5X,'TRANSVERSE',5X,'TRANSVERSE'/             INDAT1.......74600
     3         31X,'PERMEABILITY',4X,'PERMEABILITY',4X,'PERMEABILITY',   INDAT1.......74700
     4         8X,'(IN DEGREES)',3X,'(IN DEGREES)',3X,'(IN DEGREES)',3X, INDAT1.......74800
     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY',3X,    INDAT1.......74900
     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY'/       INDAT1.......75000
     4      64X,64X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM',  INDAT1.......75100
     4         3X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM'/    INDAT1.......75200
     1      64X,64X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION',  INDAT1.......75300
     2         3X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)   INDAT1.......75400
         ELSE                                                            INDAT1.......75500
c rbw begin change
c            WRITE(K3,1501)                                               INDAT1.......75600
c rbw end change
 1501       FORMAT('1'//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......75700
     1         11X,'ELEMENT',4X,                                         INDAT1.......75800
     2         'MAXIMUM',9X,'MIDDLE',10X,'MINIMUM',18X,                  INDAT1.......75900
     2         'ANGLE1',9X,'ANGLE2',9X,'ANGLE3',4X,                      INDAT1.......76000
     2         'LONGITUDINAL',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,    INDAT1.......76100
     2         'TRANSVERSE',5X,'TRANSVERSE',5X,'TRANSVERSE'/             INDAT1.......76200
     3         22X,'PERMEABILITY',4X,'PERMEABILITY',4X,'PERMEABILITY',   INDAT1.......76300
     4         8X,'(IN DEGREES)',3X,'(IN DEGREES)',3X,'(IN DEGREES)',3X, INDAT1.......76400
     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY',3X,    INDAT1.......76500
     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY'/       INDAT1.......76600
     4         119X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM',  INDAT1.......76700
     4         3X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM'/    INDAT1.......76800
     1         119X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION',  INDAT1.......76900
     2         3X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)   INDAT1.......77000
         END IF                                                          INDAT1.......77100
      END IF                                                             INDAT1.......77200
      LRTEST=1                                                           INDAT1.......77300
      DO 1550 LL=1,NE                                                    INDAT1.......77400
      ERRCOD = 'REA-INP-15B'                                             INDAT1.......77500
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......77600
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 181
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) L,LREG(L),PMAX,PMID,PMIN,           INDAT1.......77700
     1   ANGLE1,ANGLE2,ANGLE3,ALMAX(L),ALMID(L),ALMIN(L),                INDAT1.......77800
     1   ATMAX(L),ATMID(L),ATMIN(L)                                      INDAT1.......77900
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......78000
      IF (INERR(1).NE.0) then
                 IErrorFlag = 121
                 return
      endif
c rbw end change
      IF(LL.GT.1.AND.LREG(L).NE.LROLD) LRTEST=LRTEST+1                   INDAT1.......78100
      LROLD=LREG(L)                                                      INDAT1.......78200
      PMAX=PMAX*PMAXFA                                                   INDAT1.......78300
      PMID=PMID*PMIDFA                                                   INDAT1.......78400
      PMIN=PMIN*PMINFA                                                   INDAT1.......78500
      ANGLE1=ANGLE1*ANG1FA                                               INDAT1.......78600
      ANGLE2=ANGLE2*ANG2FA                                               INDAT1.......78700
      ANGLE3=ANGLE3*ANG3FA                                               INDAT1.......78800
      ALMAX(L)=ALMAX(L)*ALMAXF                                           INDAT1.......78900
      ALMID(L)=ALMID(L)*ALMIDF                                           INDAT1.......79000
      ALMIN(L)=ALMIN(L)*ALMINF                                           INDAT1.......79100
      ATMAX(L)=ATMAX(L)*ATMXF                                            INDAT1.......79200
      ATMID(L)=ATMID(L)*ATMDF                                            INDAT1.......79300
      ATMIN(L)=ATMIN(L)*ATMNF                                            INDAT1.......79400
c rbw begin change
c      IF(KELMNT.EQ.+1.AND.IUNSAT.NE.1) WRITE(K3,1520) L,                 INDAT1.......79500
c     1   PMAX,PMID,PMIN,ANGLE1,ANGLE2,ANGLE3,                            INDAT1.......79600
c     2   ALMAX(L),ALMID(L),ALMIN(L),ATMAX(L),ATMID(L),ATMIN(L)           INDAT1.......79700
c rbw end change
 1520 FORMAT(9X,I9,2X,3(1PE14.5,2X),7X,9(G11.4,4X))                      INDAT1.......79800
c rbw begin change
c      IF(KELMNT.EQ.+1.AND.IUNSAT.EQ.1) WRITE(K3,1530) L,LREG(L),         INDAT1.......79900
c     1   PMAX,PMID,PMIN,ANGLE1,ANGLE2,ANGLE3,                            INDAT1.......80000
c     2   ALMAX(L),ALMID(L),ALMIN(L),ATMAX(L),ATMID(L),ATMIN(L)           INDAT1.......80100
c rbw end change
 1530 FORMAT(9X,I9,4X,I5,2X,3(1PE14.5,2X),7X,9(G11.4,4X))                INDAT1.......80200
C                                                                        INDAT1.......80300
C.....ROTATE PERMEABILITY FROM MAX/MID/MIN TO X/Y/Z DIRECTIONS.          INDAT1.......80400
C        BASED ON CODE WRITTEN BY DAVID POLLOCK (USGS).                  INDAT1.......80500
      D2R=1.745329252D-2                                                 INDAT1.......80600
      PANGL1(L)=D2R*ANGLE1                                               INDAT1.......80700
      PANGL2(L)=D2R*ANGLE2                                               INDAT1.......80800
      PANGL3(L)=D2R*ANGLE3                                               INDAT1.......80900
      ZERO = 0D0                                                         INDAT1.......81000
      CALL ROTMAT(PANGL1(L),PANGL2(L),PANGL3(L),Q11,Q12,Q13,             INDAT1.......81100
     1   Q21,Q22,Q23,Q31,Q32,Q33)                                        INDAT1.......81200
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
      CALL TENSYM(PMAX,PMID,PMIN,Q11,Q12,Q13,Q21,Q22,Q23,Q31,Q32,Q33,    INDAT1.......81300
     1   PERMXX(L),PERMXY(L),PERMXZ(L),PERMYX(L),PERMYY(L),PERMYZ(L),    INDAT1.......81400
     2   PERMZX(L),PERMZY(L),PERMZZ(L))                                  INDAT1.......81500
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
 1550 CONTINUE                                                           INDAT1.......81600
c rbw begin change
c      IF(KELMNT.EQ.0)                                                    INDAT1.......81700
c     1   WRITE(K3,1569) PMAXFA,PMIDFA,PMINFA,ANG1FA,ANG2FA,ANG3FA,       INDAT1.......81800
c     2      ALMAXF,ALMIDF,ALMINF,ATMXF,ATMDF,ATMNF                       INDAT1.......81900
c rbw end change
 1569 FORMAT(////11X,'E L E M E N T   I N F O R M A T I O N'//           INDAT1.......82000
     1   16X,'PRINTOUT OF ELEMENT PERMEABILITIES AND DISPERSIVITIES ',   INDAT1.......82100
     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PE15.4,5X,'MAXIMUM ',  INDAT1.......82200
     3   'PERMEABILITY FACTOR'/33X,1PE15.4,5X,'MIDDLE PERMEABILITY ',    INDAT1.......82300
     4   'FACTOR '/33X,1PE15.4,5X,'MINIMUM PERMEABILITY FACTOR'/         INDAT1.......82400
     5   33X,1PE15.4,5X,'ANGLE1 FACTOR'/33X,1PE15.4,5X,'ANGLE2 FACTOR'/  INDAT1.......82500
     6   33X,1PE15.4,5X,'ANGLE3 FACTOR'/                                 INDAT1.......82600
     7   33X,1PE15.4,5X,'FACTOR FOR LONGITUDINAL DISPERSIVITY IN ',      INDAT1.......82700
     8   'MAX-PERM DIRECTION'/33X,1PE15.4,5X,'FACTOR FOR LONGITUDINAL ', INDAT1.......82800
     9   'DISPERSIVITY IN MID-PERM DIRECTION'/33X,1PE15.4,5X,'FACTOR ',  INDAT1.......82900
     T   'FOR LONGITUDINAL DISPERSIVITY IN MIN-PERM DIRECTION'/          INDAT1.......83000
     1   33X,1PE15.4,5X,'FACTOR FOR TRANSVERSE DISPERSIVITY IN ',        INDAT1.......83100
     2   'MAX-PERM DIRECTION'/33X,1PE15.4,5X,'FACTOR FOR TRANSVERSE ',   INDAT1.......83200
     3   'DISPERSIVITY IN MID-PERM DIRECTION'/33X,1PE15.4,5X,'FACTOR',   INDAT1.......83300
     4   ' FOR TRANSVERSE DISPERSIVITY IN MIN-PERM DIRECTION')           INDAT1.......83400
c rbw begin change
c      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.NE.1) WRITE(K3,1573)     INDAT1.......83500
c      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.EQ.1) WRITE(K3,1575)     INDAT1.......83600
c rbw end change
 1573 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......83700
     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......83800
 1575 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......83900
     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......84000
C                                                                        INDAT1.......84100
      ELSE                                                               INDAT1.......84200
C.....READ 2D INPUT FROM DATASETS 13 - 15.                               INDAT1.......84300
C.....NOTE THAT Z = THICKNESS AND PANGL1 = PANGLE.                       INDAT1.......84400
C                                                                        INDAT1.......84500
C.....INPUT DATASET 13:  ORIENTATION OF COORDINATES TO GRAVITY           INDAT1.......84600
      ERRCOD = 'REA-INP-13'                                              INDAT1.......84700
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......84800
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 182
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) GRAVX,GRAVY                         INDAT1.......84900
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......85000
      IF (INERR(1).NE.0) then
                 IErrorFlag = 122
                 return
      endif
c rbw end change
      GRAVZ = 0D0                                                        INDAT1.......85100
c rbw begin change
c      WRITE(K3,2320) GRAVX,GRAVY                                         INDAT1.......85200
c rbw end change
 2320 FORMAT(////11X,'C O O R D I N A T E   O R I E N T A T I O N   ',   INDAT1.......85300
     1   'T O   G R A V I T Y'//13X,'COMPONENT OF GRAVITY VECTOR',       INDAT1.......85400
     2   /13X,'IN +X DIRECTION, GRAVX'/11X,1PE15.4,5X,                   INDAT1.......85500
     3   'GRAVX = -GRAV * D(ELEVATION)/DX'//13X,'COMPONENT OF GRAVITY',  INDAT1.......85600
     4   ' VECTOR'/13X,'IN +Y DIRECTION, GRAVY'/11X,1PE15.4,5X,          INDAT1.......85700
     5   'GRAVY = -GRAV * D(ELEVATION)/DY')                              INDAT1.......85800
C                                                                        INDAT1.......85900
C.....INPUT DATASETS 14A & 14B:  NODEWISE DATA                           INDAT1.......86000
      ERRCOD = 'REA-INP-14A'                                             INDAT1.......86100
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......86200
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 183
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,SCALX,SCALY,SCALTH,PORFAC    INDAT1.......86300
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......86400
      IF (INERR(1).NE.0) then
                 IErrorFlag = 123
                 return
      endif
c rbw end change
      IF (CDUM10.NE.'NODE      ') THEN                                   INDAT1.......86500
c rbw begin change
                 IErrorFlag = 124
                 return
c         ERRCOD = 'INP-14A-1'                                            INDAT1.......86600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......86700
c rbw end change
      END IF                                                             INDAT1.......86800
      NRTEST=1                                                           INDAT1.......86900
      DO 2450 I=1,NN                                                     INDAT1.......87000
      ERRCOD = 'REA-INP-14B'                                             INDAT1.......87100
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......87200
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 184
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) II,NREG(II),X(II),Y(II),Z(II),      INDAT1.......87300
     1   POR(II)                                                         INDAT1.......87400
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......87500
      IF (INERR(1).NE.0) then
                 IErrorFlag = 125
                 return
      endif
c rbw end change
      X(II)=X(II)*SCALX                                                  INDAT1.......87600
      Y(II)=Y(II)*SCALY                                                  INDAT1.......87700
      Z(II)=Z(II)*SCALTH                                                 INDAT1.......87800
      POR(II)=POR(II)*PORFAC                                             INDAT1.......87900
      IF(I.GT.1.AND.NREG(II).NE.NROLD) NRTEST=NRTEST+1                   INDAT1.......88000
      NROLD=NREG(II)                                                     INDAT1.......88100
C.....SET SPECIFIC PRESSURE STORATIVITY, SOP.                            INDAT1.......88200
 2450 SOP(II)=(1.D0-POR(II))*COMPMA+POR(II)*COMPFL                       INDAT1.......88300
c rbw begin change
c 2460 IF(KNODAL.EQ.0) WRITE(K3,2461) SCALX,SCALY,SCALTH,PORFAC           INDAT1.......88400
c rbw end change
 2461 FORMAT('1'////11X,'N O D E   I N F O R M A T I O N'//16X,          INDAT1.......88500
     1   'PRINTOUT OF NODE COORDINATES, THICKNESSES AND POROSITIES ',    INDAT1.......88600
     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PE15.4,5X,'X-SCALE'/   INDAT1.......88700
     1   33X,1PE15.4,5X,'Y-SCALE'/33X,1PE15.4,5X,'THICKNESS FACTOR'/     INDAT1.......88800
     2   33X,1PE15.4,5X,'POROSITY FACTOR')                               INDAT1.......88900
c rbw begin change
c      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.NE.1) WRITE(K3,2463)     INDAT1.......89000
c      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.EQ.1) WRITE(K3,2465)     INDAT1.......89100
c rbw end change
 2463 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......89200
     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......89300
 2465 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......89400
     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......89500
c rbw begin change
c      IF(KNODAL.EQ.+1.AND.IUNSAT.NE.1)                                   INDAT1.......89600
c     1   WRITE(K3,2470)(I,X(I),Y(I),Z(I),POR(I),I=1,NN)                  INDAT1.......89700
c rbw end change
 2470 FORMAT('1'//11X,'N O D E   I N F O R M A T I O N'//14X,            INDAT1.......89800
     1   'NODE',7X,'X',16X,'Y',17X,'THICKNESS',6X,'POROSITY'//           INDAT1.......89900
     2   (9X,I9,3(3X,1PE14.5),6X,0PF8.5))                                INDAT1.......90000
c rbw begin change
c      IF(KNODAL.EQ.+1.AND.IUNSAT.EQ.1)                                   INDAT1.......90100
c     1   WRITE(K3,2480)(I,NREG(I),X(I),Y(I),Z(I),POR(I),I=1,NN)          INDAT1.......90200
c rbw end change
 2480 FORMAT('1'//11X,'N O D E   I N F O R M A T I O N'//14X,'NODE',3X,  INDAT1.......90300
     1   'REGION',7X,'X',16X,'Y',17X,'THICKNESS',6X,'POROSITY'//         INDAT1.......90400
     2   (9X,I9,3X,I6,3(3X,1PE14.5),6X,0PF8.5))                          INDAT1.......90500
C                                                                        INDAT1.......90600
C.....INPUT DATASETS 15A & 15B:  ELEMENTWISE DATA                        INDAT1.......90700
      ERRCOD = 'REA-INP-15A'                                             INDAT1.......90800
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......90900
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 185
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,PMAXFA,PMINFA,ANGFAC,        INDAT1.......91000
     1   ALMAXF,ALMINF,ATMAXF,ATMINF                                     INDAT1.......91100
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......91200
      IF (INERR(1).NE.0) then
                 IErrorFlag = 126
                 return
      endif
c rbw end change
      IF (CDUM10.NE.'ELEMENT   ') THEN                                   INDAT1.......91300
c rbw begin change
                 IErrorFlag = 127
                 return
c         ERRCOD = 'INP-15A-1'                                            INDAT1.......91400
c         CHERR(1) = '2D'                                                 INDAT1.......91500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......91600
c rbw end change
      END IF                                                             INDAT1.......91700
      IF (KELMNT.EQ.+1) THEN                                             INDAT1.......91800
         IF (IUNSAT.EQ.1) THEN                                           INDAT1.......91900
c rbw begin change
c            WRITE(K3,2500)                                               INDAT1.......92000
c rbw end change
 2500       FORMAT('1'//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......92100
     1         11X,'ELEMENT',3X,'REGION',4X,'MAXIMUM',9X,'MINIMUM',12X,  INDAT1.......92200
     2         'ANGLE BETWEEN',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,   INDAT1.......92300
     3         'TRANSVERSE',5X,'TRANSVERSE'/                             INDAT1.......92400
     4         31X,'PERMEABILITY',4X,'PERMEABILITY',4X,                  INDAT1.......92500
     5         '+X-DIRECTION AND',3X,'DISPERSIVITY',3X,'DISPERSIVITY',   INDAT1.......92600
     6         3X,'DISPERSIVITY',3X,'DISPERSIVITY'/                      INDAT1.......92700
     7         59X,'MAXIMUM PERMEABILITY',3X,' IN MAX-PERM',             INDAT1.......92800
     8         3X,' IN MIN-PERM',3X,' IN MAX-PERM',3X,' IN MIN-PERM'/    INDAT1.......92900
     9         67X,'(IN DEGREES)',3X,'   DIRECTION',3X,                  INDAT1.......93000
     1         '   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)      INDAT1.......93100
         ELSE                                                            INDAT1.......93200
c rbw begin change
c            WRITE(K3,2501)                                               INDAT1.......93300
c rbw end change
 2501       FORMAT('1'//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......93400
     1         11X,'ELEMENT',4X,'MAXIMUM',9X,'MINIMUM',12X,              INDAT1.......93500
     2         'ANGLE BETWEEN',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,   INDAT1.......93600
     3         'TRANSVERSE',5X,'TRANSVERSE'/                             INDAT1.......93700
     4         22X,'PERMEABILITY',4X,'PERMEABILITY',4X,                  INDAT1.......93800
     5         '+X-DIRECTION AND',3X,'DISPERSIVITY',3X,'DISPERSIVITY',   INDAT1.......93900
     6         3X,'DISPERSIVITY',3X,'DISPERSIVITY'/                      INDAT1.......94000
     7         50X,'MAXIMUM PERMEABILITY',3X,' IN MAX-PERM',             INDAT1.......94100
     8         3X,' IN MIN-PERM',3X,' IN MAX-PERM',3X,' IN MIN-PERM'/    INDAT1.......94200
     9         58X,'(IN DEGREES)',3X,'   DIRECTION',3X,                  INDAT1.......94300
     1         '   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)      INDAT1.......94400
         END IF                                                          INDAT1.......94500
      END IF                                                             INDAT1.......94600
      LRTEST=1                                                           INDAT1.......94700
      DO 2550 LL=1,NE                                                    INDAT1.......94800
      ERRCOD = 'REA-INP-15B'                                             INDAT1.......94900
      CALL READIF(K1, INTFIL, ERRCOD)                                    INDAT1.......95000
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 186
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) L,LREG(L),PMAX,PMIN,ANGLEX,         INDAT1.......95100
     1   ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)                             INDAT1.......95200
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......95300
      IF (INERR(1).NE.0) then
                 IErrorFlag = 128
                 return
      endif
c rbw end change
      IF(LL.GT.1.AND.LREG(L).NE.LROLD) LRTEST=LRTEST+1                   INDAT1.......95400
      LROLD=LREG(L)                                                      INDAT1.......95500
      PMAX=PMAX*PMAXFA                                                   INDAT1.......95600
      PMIN=PMIN*PMINFA                                                   INDAT1.......95700
      ANGLEX=ANGLEX*ANGFAC                                               INDAT1.......95800
      ALMAX(L)=ALMAX(L)*ALMAXF                                           INDAT1.......95900
      ALMIN(L)=ALMIN(L)*ALMINF                                           INDAT1.......96000
      ATMAX(L)=ATMAX(L)*ATMAXF                                           INDAT1.......96100
      ATMIN(L)=ATMIN(L)*ATMINF                                           INDAT1.......96200
c rbw begin change
c      IF(KELMNT.EQ.+1.AND.IUNSAT.NE.1) WRITE(K3,2520) L,                 INDAT1.......96300
c     1   PMAX,PMIN,ANGLEX,ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)            INDAT1.......96400
c rbw end change
 2520 FORMAT(9X,I9,2X,2(1PE14.5,2X),7X,5(G11.4,4X))                      INDAT1.......96500
c rbw begin change
c      IF(KELMNT.EQ.+1.AND.IUNSAT.EQ.1) WRITE(K3,2530) L,LREG(L),         INDAT1.......96600
c     1   PMAX,PMIN,ANGLEX,ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)            INDAT1.......96700
c rbw end change
 2530 FORMAT(9X,I9,4X,I5,2X,2(1PE14.5,2X),7X,5(G11.4,4X))                INDAT1.......96800
C                                                                        INDAT1.......96900
C.....ROTATE PERMEABILITY FROM MAXIMUM/MINIMUM TO X/Y DIRECTIONS         INDAT1.......97000
      RADIAX=1.745329D-2*ANGLEX                                          INDAT1.......97100
      SINA=DSIN(RADIAX)                                                  INDAT1.......97200
      COSA=DCOS(RADIAX)                                                  INDAT1.......97300
      SINA2=SINA*SINA                                                    INDAT1.......97400
      COSA2=COSA*COSA                                                    INDAT1.......97500
      PERMXX(L)=PMAX*COSA2+PMIN*SINA2                                    INDAT1.......97600
      PERMYY(L)=PMAX*SINA2+PMIN*COSA2                                    INDAT1.......97700
      PERMXY(L)=(PMAX-PMIN)*SINA*COSA                                    INDAT1.......97800
      PERMYX(L)=PERMXY(L)                                                INDAT1.......97900
      PANGL1(L)=RADIAX                                                   INDAT1.......98000
 2550 CONTINUE                                                           INDAT1.......98100
c rbw begin change
c      IF(KELMNT.EQ.0)                                                    INDAT1.......98200
c     1   WRITE(K3,2569) PMAXFA,PMINFA,ANGFAC,ALMAXF,ALMINF,ATMAXF,ATMINF INDAT1.......98300
c rbw end change
 2569 FORMAT(////11X,'E L E M E N T   I N F O R M A T I O N'//           INDAT1.......98400
     1   16X,'PRINTOUT OF ELEMENT PERMEABILITIES AND DISPERSIVITIES ',   INDAT1.......98500
     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PE15.4,5X,'MAXIMUM ',  INDAT1.......98600
     3   'PERMEABILITY FACTOR'/33X,1PE15.4,5X,'MINIMUM PERMEABILITY ',   INDAT1.......98700
     4   'FACTOR'/33X,1PE15.4,5X,'ANGLE FROM +X TO MAXIMUM DIRECTION',   INDAT1.......98800
     5   ' FACTOR'/33X,1PE15.4,5X,'FACTOR FOR LONGITUDINAL DISPERSIVITY' INDAT1.......98900
     6  ,' IN MAX-PERM DIRECTION'/33X,1PE15.4,5X,                        INDAT1.......99000
     7   'FACTOR FOR LONGITUDINAL DISPERSIVITY IN MIN-PERM DIRECTION',   INDAT1.......99100
     8   /33X,1PE15.4,5X,'FACTOR FOR TRANSVERSE DISPERSIVITY',           INDAT1.......99200
     9   ' IN MAX-PERM DIRECTION'/33X,1PE15.4,5X,                        INDAT1.......99300
     *   'FACTOR FOR TRANSVERSE DISPERSIVITY IN MIN-PERM DIRECTION')     INDAT1.......99400
c rbw begin change
c      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.NE.1) WRITE(K3,2573)     INDAT1.......99500
c      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.EQ.1) WRITE(K3,2575)     INDAT1.......99600
c rbw end change
 2573 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......99700
     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......99800
 2575 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......99900
     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1......100000
C                                                                        INDAT1......100100
      END IF                                                             INDAT1......100200
C                                                                        INDAT1......100300
      RETURN                                                             INDAT1......100400
      END                                                                INDAT1......100500
C                                                                        INDAT1......100600
C     SUBROUTINE        I  N  D  A  T  2           SUTRA VERSION 2.1     INDAT2.........100
C                                                                        INDAT2.........200
C *** PURPOSE :                                                          INDAT2.........300
C ***  TO READ INITIAL CONDITIONS FROM ICS FILE, AND TO                  INDAT2.........400
C ***  INITIALIZE DATA FOR EITHER WARM OR COLD START OF                  INDAT2.........500
C ***  THE SIMULATION.                                                   INDAT2.........600
C                                                                        INDAT2.........700
c rbw begin change
c      SUBROUTINE INDAT2(PVEC,UVEC,PM1,UM1,UM2,CS1,CS2,CS3,SL,SR,RCIT,    INDAT2.........800
c     1   SW,DSWDP,PBC,IPBC,IPBCT,NREG,QIN,DPDTITR)                       INDAT2.........900
c rbw end change
C     SUBROUTINE        L  L  D  2  A  R           SUTRA VERSION 2.1     LLD2AR.........100
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
C     SUBROUTINE        L  L  D  I  N  S           SUTRA VERSION 2.1     LLDINS.........100
C                                                                        LLDINS.........200
C *** PURPOSE :                                                          LLDINS.........300
C ***  TO INSERT A PAIR OF DOUBLE-PRECISION VALUES INTO A LINKED         LLDINS.........400
C ***  LIST, IN ASCENDING ORDER BASED ON THE FIRST VALUE IN THE PAIR.    LLDINS.........500
C                                                                        LLDINS.........600
      SUBROUTINE LLDINS(LSTLEN, DLIST, DNUM1, DNUM2)                     LLDINS.........700
      USE LLDEF                                                          LLDINS.........800
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                LLDINS.........900
      TYPE (LLD), POINTER :: DEN, DENPV, DENPI, DENNW, DLIST             LLDINS........1000
C                                                                        LLDINS........1100
C.....IF LIST IS EMPTY, PLACE PAIR AT HEAD OF LIST, ELSE INSERT          LLDINS........1200
C        INTO LIST IN ASCENDING ORDER BASED ON FIRST VALUE               LLDINS........1300
      IF (LSTLEN.EQ.0) THEN                                              LLDINS........1400
C........PLACE AT HEAD                                                   LLDINS........1500
         DLIST%DVALU1 = DNUM1                                            LLDINS........1600
         DLIST%DVALU2 = DNUM2                                            LLDINS........1700
         GOTO 780                                                        LLDINS........1800
      ELSE                                                               LLDINS........1900
C........INSERT INTO LISTS                                               LLDINS........2000
         ALLOCATE(DENPV)                                                 LLDINS........2100
         DENPI => DENPV                                                  LLDINS........2200
         DENPV%NENT => DLIST                                             LLDINS........2300
         DO 770 K=1,LSTLEN                                               LLDINS........2400
            DEN => DENPV%NENT                                            LLDINS........2500
            IF (DNUM1.LT.DEN%DVALU1) THEN                                LLDINS........2600
               ALLOCATE(DENNW)                                           LLDINS........2700
               DENNW%DVALU1 = DNUM1                                      LLDINS........2800
               DENNW%DVALU2 = DNUM2                                      LLDINS........2900
               DENNW%NENT => DEN                                         LLDINS........3000
               IF (K.EQ.1) THEN                                          LLDINS........3100
                  DLIST => DENNW                                         LLDINS........3200
               ELSE                                                      LLDINS........3300
                  DENPV%NENT => DENNW                                    LLDINS........3400
               END IF                                                    LLDINS........3500
               DEALLOCATE(DENPI)                                         LLDINS........3600
               GOTO 780                                                  LLDINS........3700
            END IF                                                       LLDINS........3800
            DENPV => DEN                                                 LLDINS........3900
  770    CONTINUE                                                        LLDINS........4000
C........APPEND TO TAIL                                                  LLDINS........4100
         ALLOCATE(DENNW)                                                 LLDINS........4200
         DENNW%DVALU1 = DNUM1                                            LLDINS........4300
         DENNW%DVALU2 = DNUM2                                            LLDINS........4400
         DEN%NENT => DENNW                                               LLDINS........4500
         DEALLOCATE(DENPI)                                               LLDINS........4600
      END IF                                                             LLDINS........4700
C                                                                        LLDINS........4800
  780 LSTLEN = LSTLEN + 1                                                LLDINS........4900
      RETURN                                                             LLDINS........5000
      END                                                                LLDINS........5100
C                                                                        LLDINS........5200
C     SUBROUTINE        L  O  D  O  B  S           SUTRA VERSION 2.1     LODOBS.........100
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
C     SUBROUTINE        N  A  F  U                 SUTRA VERSION 2.1     NAFU...........100
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
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                NAFU..........1000
      CHARACTER*80 FN,UNAME                                              NAFU..........1100
      CHARACTER*80 ERRCOD,CHERR(10)                                      NAFU..........1200
      LOGICAL EXST                                                       NAFU..........1300
      DIMENSION INERR(10),RLERR(10)                                      NAFU..........1400
      DIMENSION IUNIT(0:8), NKS(2), KLIST(2,20)                          NAFU..........1500
c rbw begin change
      CHARACTER*80 FNAME(0:8)
c rbw end change
      COMMON /FNAMES/ UNAME,FNAME                                        NAFU..........1600
      COMMON /FUNINS/ NKS,KLIST                                          NAFU..........1700
      COMMON /FUNITA/ IUNIT                                              NAFU..........1800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     NAFU..........1900
C                                                                        NAFU..........2000
C.....CHECK "SUTRA.FIL" (UNIT K0)                                        NAFU..........2100
  100 IF (IUNEXT.EQ.K0) IUNEXT = IUNEXT + 1                              NAFU..........2200
C.....CHECK NON-INSERTED, NON-OBSERVATION FILES                          NAFU..........2300
  200 DO 300 NFF=0,6                                                     NAFU..........2400
         IF (IUNEXT.EQ.IUNIT(NFF)) THEN                                  NAFU..........2500
            IUNEXT = IUNEXT + 1                                          NAFU..........2600
            GOTO 100                                                     NAFU..........2700
         END IF                                                          NAFU..........2800
  300 CONTINUE                                                           NAFU..........2900
C.....CHECK OBSERVATION FILES                                            NAFU..........3000
  400 DO 500 NJ=1,NJMAX                                                  NAFU..........3100
         IF (IUNEXT.EQ.IUNIO(NJ)) THEN                                   NAFU..........3200
            IUNEXT = IUNEXT + 1                                          NAFU..........3300
            GOTO 100                                                     NAFU..........3400
         END IF                                                          NAFU..........3500
  500 CONTINUE                                                           NAFU..........3600
C.....CHECK INSERTED FILES                                               NAFU..........3700
      IF ((IUNEXT.EQ.K1).OR.(IUNEXT.EQ.K2)) THEN                         NAFU..........3800
         IUNEXT = IUNEXT + 1                                             NAFU..........3900
         GOTO 100                                                        NAFU..........4000
      END IF                                                             NAFU..........4100
      DO 600 I=1,2                                                       NAFU..........4200
      DO 600 K=1,NKS(I)                                                  NAFU..........4300
         IF (IUNEXT.EQ.KLIST(I,K)) THEN                                  NAFU..........4400
            IUNEXT = IUNEXT + 1                                          NAFU..........4500
            GOTO 100                                                     NAFU..........4600
         END IF                                                          NAFU..........4700
  600 CONTINUE                                                           NAFU..........4800
C.....IF THE UNIT NUMBER SELECTED IS NOT VALID, GENERATE ERROR           NAFU..........4900
      INQUIRE(UNIT=IUNEXT, EXIST=EXST)                                   NAFU..........5000
      IF (.NOT.EXST) THEN                                                NAFU..........5100
c rbw begin change
                 IErrorFlag = 129
                 return
c         ERRCOD = 'FIL-10'                                               NAFU..........5200
c         INERR(1) = IUNEXT                                               NAFU..........5300
c         CHERR(1) = UNAME                                                NAFU..........5400
c         CHERR(2) = FN                                                   NAFU..........5500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        NAFU..........5600
c rbw end change
      END IF                                                             NAFU..........5700
C                                                                        NAFU..........5800
      RETURN                                                             NAFU..........5900
      END                                                                NAFU..........6000
C                                                                        NAFU..........6100
C     SUBROUTINE        N  O  D  A  L              SUTRA VERSION 2.1     NODAL..........100
C                                                                        NODAL..........200
C *** PURPOSE :                                                          NODAL..........300
C ***  (1) TO CARRY OUT ALL CELLWISE CALCULATIONS AND TO ADD CELLWISE    NODAL..........400
C ***      TERMS TO THE GLOBAL MATRIX AND GLOBAL VECTOR FOR BOTH FLOW    NODAL..........500
C ***      AND TRANSPORT EQUATIONS.                                      NODAL..........600
C ***  (2) TO ADD FLUID SOURCE AND SOLUTE MASS OR ENERGY SOURCE TERMS    NODAL..........700
C ***      TO THE MATRIX EQUATIONS.                                      NODAL..........800
C                                                                        NODAL..........900
c rbw begin change
c      SUBROUTINE NODAL(ML,VOL,PMAT,PVEC,UMAT,UVEC,PITER,UITER,PM1,UM1,   NODAL.........1000
c     1   UM2,POR,QIN,UIN,QUIN,QINITR,CS1,CS2,CS3,SL,SR,SW,DSWDP,RHO,SOP, NODAL.........1100
c     1   NREG,JA)                                                        NODAL.........1200
c rbw end change
C     SUBROUTINE        O  U  T  E  L  E           SUTRA VERSION 2.1     OUTELE.........100
C                                                                        OUTELE.........200
C *** PURPOSE :                                                          OUTELE.........300
C ***  TO PRINT ELEMENT CENTROID COORDINATES AND VELOCITY COMPONENTS     OUTELE.........400
C ***  IN A FLEXIBLE, COLUMNWISE FORMAT.  OUTPUT IS TO THE ELE FILE.     OUTELE.........500
C                                                                        OUTELE.........600
c rbw begin change
c      SUBROUTINE OUTELE(VMAG,VANG1,VANG2,IN,X,Y,Z,TITLE1,TITLE2)         OUTELE.........700
c rbw end change
C     SUBROUTINE        O  U  T  L  S  T  2        SUTRA VERSION 2.1     OUTLST2........100
C                                                                        OUTLST2........200
C *** PURPOSE :                                                          OUTLST2........300
C ***  TO PRINT PRESSURE AND TEMPERATURE OR CONCENTRATION                OUTLST2........400
C ***  SOLUTIONS AND TO OUTPUT INFORMATION ON TIME STEP, ITERATIONS,     OUTLST2........500
C ***  SATURATIONS, AND FLUID VELOCITIES FOR 2D PROBLEMS.                OUTLST2........600
C ***  OUTPUT IS TO THE LST FILE.                                        OUTLST2........700
C                                                                        OUTLST2........800
c rbw begin change
c      SUBROUTINE OUTLST2(ML,ISTOP,IGOI,IERRP,ITRSP,ERRP,                 OUTLST2........900
c     1   IERRU,ITRSU,ERRU,PVEC,UVEC,VMAG,VANG,SW)                        OUTLST2.......1000
c rbw end change
C     SUBROUTINE        O  U  T  L  S  T  3        SUTRA VERSION 2.1     OUTLST3........100
C                                                                        OUTLST3........200
C *** PURPOSE :                                                          OUTLST3........300
C ***  TO PRINT PRESSURE AND TEMPERATURE OR CONCENTRATION                OUTLST3........400
C ***  SOLUTIONS AND TO OUTPUT INFORMATION ON TIME STEP, ITERATIONS,     OUTLST3........500
C ***  SATURATIONS, AND FLUID VELOCITIES FOR 3D PROBLEMS.                OUTLST3........600
C ***  OUTPUT IS TO THE LST FILE.                                        OUTLST3........700
C                                                                        OUTLST3........800
c rbw begin change
c      SUBROUTINE OUTLST3(ML,ISTOP,IGOI,IERRP,ITRSP,ERRP,                 OUTLST3........900
c     1   IERRU,ITRSU,ERRU,PVEC,UVEC,VMAG,VANG1,VANG2,SW)                 OUTLST3.......1000
c rbw end change
C     SUBROUTINE        O  U  T  N  O  D           SUTRA VERSION 2.1     OUTNOD.........100
C                                                                        OUTNOD.........200
C *** PURPOSE :                                                          OUTNOD.........300
C ***  TO PRINT NODE COORDINATES, PRESSURES, CONCENTRATIONS OR           OUTNOD.........400
C ***  TEMPERATURES, AND SATURATIONS IN A FLEXIBLE, COLUMNWISE FORMAT.   OUTNOD.........500
C ***  OUTPUT IS TO THE NOD FILE.                                        OUTNOD.........600
C                                                                        OUTNOD.........700
c rbw begin change
c      SUBROUTINE OUTNOD1(PVEC,UVEC,SW,X,Y,Z,TITLE1,TITLE2)                OUTNOD.........800
c rbw end change
C     SUBROUTINE        O  U  T  O  B  C           SUTRA VERSION 2.1     OUTOBC.........100
C                                                                        OUTOBC.........200
C *** PURPOSE :                                                          OUTOBC.........300
C ***  TO PRINT THE SOLUTION AT OBSERVATION POINTS.  SPECIFICALLY,       OUTOBC.........400
C ***  TO PRINT PRESSURES, CONCENTRATIONS OR TEMPERATURES, AND           OUTOBC.........500
C ***  SATURATIONS IN A COLUMNWISE FORMAT SIMILAR TO THAT USED IN THE    OUTOBC.........600
C ***  NODEWISE AND ELEMENTWISE OUTPUT FILES.                            OUTOBC.........700
C                                                                        OUTOBC.........800
c rbw begin change
c      SUBROUTINE OUTOBC(NFLO,OBSPTS,TIME,STEP,PM1,UM1,PVEC,UVEC,         OUTOBC.........900
c     1   TITLE1,TITLE2,IN,LREG)                                          OUTOBC........1000
c rbw end change
C     SUBROUTINE        O  U  T  O  B  S           SUTRA VERSION 2.1     OUTOBS.........100
C                                                                        OUTOBS.........200
C *** PURPOSE :                                                          OUTOBS.........300
C ***  TO PRINT THE SOLUTION AT OBSERVATION POINTS.  SPECIFICALLY,       OUTOBS.........400
C ***  TO PRINT PRESSURES, CONCENTRATIONS OR TEMPERATURES, AND           OUTOBS.........500
C ***  SATURATIONS IN A COLUMNWISE FORMAT.                               OUTOBS.........600
C                                                                        OUTOBS.........700
c rbw begin change
c      SUBROUTINE OUTOBS(NFLO,OBSPTS,TIME,STEP,PM1,UM1,PVEC,UVEC,         OUTOBS.........800
c     1   TITLE1,TITLE2,IN,LREG)                                          OUTOBS.........900
c rbw end change
C     SUBROUTINE        O  U  T  R  S  T           SUTRA VERSION 2.1     OUTRST.........100
C                                                                        OUTRST.........200
C *** PURPOSE :                                                          OUTRST.........300
C ***  TO STORE RESULTS THAT MAY LATER BE USED TO RESTART                OUTRST.........400
C ***  THE SIMULATION.                                                   OUTRST.........500
C                                                                        OUTRST.........600
c rbw begin change
c      SUBROUTINE OUTRST(PVEC,UVEC,PM1,UM1,CS1,RCIT,SW,QINITR,PBC)        OUTRST.........700
c rbw end change
C     SUBROUTINE        P  R  S  W  D  S           SUTRA VERSION 2.1     PRSWDS.........100
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
C     SUBROUTINE        P  T  R  S  E  T           SUTRA VERSION 2.1     PTRSET.........100
C                                                                        PTRSET.........200
C *** PURPOSE :                                                          PTRSET.........300
C ***  TO SET UP POINTER ARRAYS NEEDED TO SPECIFY THE MATRIX STRUCTURE.  PTRSET.........400
C                                                                        PTRSET.........500
      SUBROUTINE PTRSET()                                                PTRSET.........600
      USE ALLARR                                                         PTRSET.........700
      USE PTRDEF                                                         PTRSET.........800
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                PTRSET.........900
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              PTRSET........1000
     1   NSOP,NSOU,NBCN                                                  PTRSET........1100
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
                  DEALLOCATE(DENTPI)                                     PTRSET........4900
                  GOTO 500                                               PTRSET........5000
               ELSE IF (JC.LT.DENT%NODNUM) THEN                          PTRSET........5100
                  ALLOCATE(DENTNW)                                       PTRSET........5200
                  DENTNW%NODNUM = JC                                     PTRSET........5300
                  DENTNW%NENT => DENT                                    PTRSET........5400
                  IF (K.EQ.1) THEN                                       PTRSET........5500
                     HLIST(IC)%PL => DENTNW                              PTRSET........5600
                  ELSE                                                   PTRSET........5700
                     DENTPV%NENT => DENTNW                               PTRSET........5800
                  END IF                                                 PTRSET........5900
                  DEALLOCATE(DENTPI)                                     PTRSET........6000
                  GOTO 498                                               PTRSET........6100
               END IF                                                    PTRSET........6200
               DENTPV => DENT                                            PTRSET........6300
  495       CONTINUE                                                     PTRSET........6400
C...........APPEND TO TAIL.                                              PTRSET........6500
            ALLOCATE(DENTNW)                                             PTRSET........6600
            DENTNW%NODNUM = JC                                           PTRSET........6700
            DENT%NENT => DENTNW                                          PTRSET........6800
            DEALLOCATE(DENTPI)                                           PTRSET........6900
         END IF                                                          PTRSET........7000
  498    LLIST(IC) = LLIST(IC) + 1                                       PTRSET........7100
  500 CONTINUE                                                           PTRSET........7200
C.....COMPUTE THE ARRAY DIMENSION NELT AND ALLOCATE ARRAY IA.            PTRSET........7300
      NELT = 0                                                           PTRSET........7400
      DO 600 I=1,NN                                                      PTRSET........7500
  600    NELT = NELT + LLIST(I) + 1                                      PTRSET........7600
      NDIMIA = NELT                                                      PTRSET........7700
      ALLOCATE(IA(NDIMIA))                                               PTRSET........7800
C.....TRANSFER THE LINKED LISTS TO ARRAYS IA AND JA IN SLAP COLUMN       PTRSET........7900
C        FORMAT.  DEALLOCATE POINTERS AS THEY ARE TRANSFERRED.           PTRSET........8000
      JASTRT = 1                                                         PTRSET........8100
      DO 660 I=1,NN                                                      PTRSET........8200
         JA(I) = JASTRT                                                  PTRSET........8300
         IA(JASTRT) = I                                                  PTRSET........8400
         DENT => HLIST(I)%PL                                             PTRSET........8500
         DO 650 K=1,LLIST(I)                                             PTRSET........8600
            IA(JASTRT + K) = DENT%NODNUM                                 PTRSET........8700
            DENTPV => DENT                                               PTRSET........8800
            DENT => DENT%NENT                                            PTRSET........8900
            DEALLOCATE(DENTPV)                                           PTRSET........9000
  650    CONTINUE                                                        PTRSET........9100
         JASTRT = JASTRT + LLIST(I) + 1                                  PTRSET........9200
  660 CONTINUE                                                           PTRSET........9300
      JA(NN + 1) = NELT + 1                                              PTRSET........9400
      DEALLOCATE(HLIST, LLIST)                                           PTRSET........9500
C                                                                        PTRSET........9600
      RETURN                                                             PTRSET........9700
      END                                                                PTRSET........9800
C                                                                        PTRSET........9900
C                                                                        PTRSET.......10000
C     SUBROUTINE        P  U                       SUTRA VERSION 2.1     PU.............100
C                                                                        PU.............200
C *** PURPOSE :                                                          PU.............300
C ***  TO EVALUATE P AND U AT SPECIFIED LOCAL COORDINATES WITHIN A       PU.............400
C ***  2D OR 3D ELEMENT.  ADAPTED FROM SUBROUTINES BASIS2 AND BASIS3.    PU.............500
C                                                                        PU.............600
c rbw begin change
c      SUBROUTINE PU(L,XLOC,YLOC,ZLOC,PVEC,UVEC,IN,P,U)                   PU.............700
c rbw end change
C     FUNCTION          P  U  S  W  F              SUTRA VERSION 2.1     PUSWF..........100
C                                                                        PUSWF..........200
C *** PURPOSE :                                                          PUSWF..........300
C ***  TO INTERPOLATE P, U, AND SW AT A FRACTIONAL TIME STEP (BETWEEN    PUSWF..........400
C ***  THE CURRENT AND PREVIOUS TIME STEPS) AND RETURN THE VALUES IN     PUSWF..........500
C ***  AN ARRAY.                                                         PUSWF..........600
C                                                                        PUSWF..........700
c rbw begin change
c      FUNCTION PUSWF(L,XLOC,YLOC,ZLOC,SFRAC,PM1,UM1,PVEC,UVEC,IN,LREG)   PUSWF..........800
c rbw end change
C     SUBROUTINE        R  E  A  D  I  F           SUTRA VERSION 2.1     READIF.........100
C                                                                        READIF.........200
C *** PURPOSE :                                                          READIF.........300
C ***  TO READ A LINE FROM AN INPUT FILE INTO THE CHARACTER VARIABLE     READIF.........400
C ***  INTFIL.  HANDLE OPENING AND CLOSING OF INSERTED FILES AS          READIF.........500
C ***  NECESSARY.                                                        READIF.........600
C                                                                        READIF.........700
      SUBROUTINE READIF(KUU, INTFIL, ERRCOD)                             READIF.........800
c rbw begin change
      USE ErrorFlag
c rbw end change
      USE SCHDEF, ONLY : IUNIO, FNAMO                                    READIF.........900
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                READIF........1000
      PARAMETER (KINMIN=10)                                              READIF........1100
      CHARACTER INTFIL*1000                                              READIF........1200
      CHARACTER*80 ERRCOD,CHERR(10)                                      READIF........1300
      CHARACTER*80 UNAME,FNAME,FNAIN                                     READIF........1400
      CHARACTER ERRF*3, FINS*80                                          READIF........1500
      LOGICAL IS                                                         READIF........1600
      DIMENSION INERR(10),RLERR(10)                                      READIF........1700
      DIMENSION NKS(2), KLIST(2,20), IUNIT(0:8)                          READIF........1800
      DIMENSION FNAME(0:8), FNAIN(2,20)                                  READIF........1900
      COMMON /FNAINS/ FNAIN                                              READIF........2000
      COMMON /FNAMES/ UNAME,FNAME                                        READIF........2100
      COMMON /FUNINS/ NKS,KLIST                                          READIF........2200
      COMMON /FUNITA/ IUNIT                                              READIF........2300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     READIF........2400
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      READIF........2500
C                                                                        READIF........2600
C.....COPY KUU INTO KU. SHOULD AVOID CHANGING KUU, SINCE IT IS ALREADY   READIF........2700
C        LINKED TO K1 OR K2 THROUGH THE ARGUMENT LIST, AND THE LATTER    READIF........2800
C        ARE ALSO PASSED IN THROUGH COMMON BLOCK FUNITS.                 READIF........2900
      KU = KUU                                                           READIF........3000
C                                                                        READIF........3100
C.....READ A LINE OF INPUT (UP TO 1000 CHARACTERS) FROM UNIT KU          READIF........3200
C        INTO INTFIL                                                     READIF........3300
100   READ(KU,'(A)',IOSTAT=INERR(1)) INTFIL                              READIF........3400
C.....IF THE END OF AN INSERTED FILE IS REACHED, CLOSE THAT FILE AND     READIF........3500
C        CONTINUE READING FROM THE NEXT-LEVEL-UP FILE                    READIF........3600
      IF (INERR(1).LT.0) THEN                                            READIF........3700
C........SET FLAG IK TO INDICATE WHETHER THE READ WAS ATTEMPTED FROM     READIF........3800
C           AN INP DATASET (IK=1) OR AN ICS DATASET (IK=2).              READIF........3900
         IF (KU.EQ.K1) THEN                                              READIF........4000
            IK = 1                                                       READIF........4100
         ELSE                                                            READIF........4200
            IK = 2                                                       READIF........4300
         END IF                                                          READIF........4400
C........IF READING FROM AN INSERTED FILE, CLOSE THAT FILE, UPDATE       READIF........4500
C           UNIT NUMBERS, FILENAME, AND COUNTER TO INDICATE THE          READIF........4600
C           NEXT-LEVEL-UP FILE, AND CONTINUE READING                     READIF........4700
         IF (NKS(IK).GT.0) THEN                                          READIF........4800
            CLOSE(KU)                                                    READIF........4900
            IF (KU.EQ.K1) THEN                                           READIF........5000
               K1 = KLIST(IK, NKS(IK))                                   READIF........5100
            ELSE                                                         READIF........5200
               K2 = KLIST(IK, NKS(IK))                                   READIF........5300
            END IF                                                       READIF........5400
            KU = KLIST(IK, NKS(IK))                                      READIF........5500
            FNAME(IK) = FNAIN(IK, NKS(IK))                               READIF........5600
            NKS(IK) = NKS(IK) - 1                                        READIF........5700
            GOTO 100                                                     READIF........5800
         END IF                                                          READIF........5900
C.....ELSE IF THE READ RESULTS IN A DIFFERENT KIND OF ERROR, GENERATE    READIF........6000
C        ERROR MESSAGE                                                   READIF........6100
      ELSE IF (INERR(1).GT.0) THEN                                       READIF........6200
c rbw begin change
                 IErrorFlag = 130
                 return
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        READIF........6300
c rbw end change
      END IF                                                             READIF........6400
C                                                                        READIF........6500
C.....IF BLANK OR COMMENT LINE, SKIP IT.                                 READIF........6600
      IF ((INTFIL(1:1).EQ.'#').OR.(INTFIL.EQ.'')) GOTO 100               READIF........6700
C                                                                        READIF........6800
C.....IF INSERT STATEMENT, OPEN THE FILE AND CONTINUE READING            READIF........6900
      IF (INTFIL(1:7).EQ.'@INSERT') THEN                                 READIF........7000
C........SET FLAG IK TO INDICATE WHETHER THE READ WAS DONE FROM          READIF........7100
C           AN INP DATASET (IK=1) OR AN ICS DATASET (IK=2).              READIF........7200
C           SET ERRF TO THE FILE TYPE ('INP' OR 'ICS').                  READIF........7300
         IF (KU.EQ.K1) THEN                                              READIF........7400
            IK = 1                                                       READIF........7500
            ERRF = 'INP'                                                 READIF........7600
         ELSE                                                            READIF........7700
            IK = 2                                                       READIF........7800
            ERRF = 'ICS'                                                 READIF........7900
         END IF                                                          READIF........8000
C........READ THE FILE SPECIFICATION FOR THE INSERTED FILE               READIF........8100
         READ(INTFIL(8:),*,IOSTAT=INERR(1)) KINS, FINS                   READIF........8200
         IF (INERR(1).NE.0) THEN                                         READIF........8300
c rbw begin change
                 IErrorFlag = 131
                 return
c            CHERR(1) = ERRCOD                                            READIF........8400
c            ERRCOD = 'REA-' // ERRF // '-INS'                            READIF........8500
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF........8600
c rbw end change
         END IF                                                          READIF........8700
C........CHECK FOR DUPLICATE FILENAME AMONG INSERTED FILES               READIF........8800
         DO 550 I=1,2                                                    READIF........8900
         DO 550 K=1,NKS(I)                                               READIF........9000
            IF (FINS.EQ.FNAIN(I, K)) THEN                                READIF........9100
c rbw begin change
                 IErrorFlag = 132
                 return
c               ERRCOD = 'FIL-4'                                          READIF........9200
c               INERR(1) = KINS                                           READIF........9300
c               CHERR(1) = FNAME(IK)                                      READIF........9400
c               CHERR(2) = FINS                                           READIF........9500
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF........9600
c rbw end change
            END IF                                                       READIF........9700
  550    CONTINUE                                                        READIF........9800
C........CHECK FOR DUPLICATE FILENAME AMONG NON-INSERTED,                READIF........9900
C           NON-OBSERVATION FILES                                        READIF.......10000
         DO 560 NFF=0,6                                                  READIF.......10100
            IF (FINS.EQ.FNAME(NFF)) THEN                                 READIF.......10200
c rbw begin change
                 IErrorFlag = 133
                 return
c               ERRCOD = 'FIL-4'                                          READIF.......10300
c               INERR(1) = KINS                                           READIF.......10400
c               CHERR(1) = FNAME(IK)                                      READIF.......10500
c               CHERR(2) = FINS                                           READIF.......10600
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF.......10700
c rbw end change
            END IF                                                       READIF.......10800
  560    CONTINUE                                                        READIF.......10900
C........CHECK FOR DUPLICATE FILENAME AMONG OBSERVATION FILES            READIF.......11000
         DO 570 NJ=1,NFLOMX                                              READIF.......11100
            IF (FINS.EQ.FNAMO(NJ)) THEN                                  READIF.......11200
c rbw begin change
                 IErrorFlag = 134
                 return
c               ERRCOD = 'FIL-4'                                          READIF.......11300
c               INERR(1) = KINS                                           READIF.......11400
c               CHERR(1) = FNAME(IK)                                      READIF.......11500
c               CHERR(2) = FINS                                           READIF.......11600
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF.......11700
c rbw end change
            END IF                                                       READIF.......11800
  570    CONTINUE                                                        READIF.......11900
C........IF THE SPECIFIED UNIT NUMBER IS LESS THAN KINMIN,               READIF.......12000
C           SET IT TO KINMIN                                             READIF.......12100
         KINS = MAX(KINS, KINMIN)                                        READIF.......12200
C........IF THE FILE TO BE INSERTED EXISTS, ASSIGN IT A UNIT NUMBER      READIF.......12300
C           AND OPEN IT                                                  READIF.......12400
         INQUIRE(FILE=FINS,EXIST=IS)                                     READIF.......12500
         IF (IS) THEN                                                    READIF.......12600
            CALL NAFU(KINS,NFLOMX,FINS)                                  READIF.......12700
c rbw begin change
      if (IErrorFlag.ne.0) then
        return
      endif
c rbw end change
            OPEN(UNIT=KINS,FILE=FINS,STATUS='OLD',FORM='FORMATTED',      READIF.......12800
     1         IOSTAT=KERR)                                              READIF.......12900
            IF (KERR.GT.0) THEN                                          READIF.......13000
c rbw begin change
                 IErrorFlag = 135
                 return
c               CHERR(1) = FNAME(IK)                                      READIF.......13100
c               CHERR(2) = FINS                                           READIF.......13200
c               INERR(1) = KINS                                           READIF.......13300
c               ERRCOD = 'FIL-2'                                          READIF.......13400
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF.......13500
c rbw end change
            END IF                                                       READIF.......13600
         ELSE                                                            READIF.......13700
c rbw begin change
                 IErrorFlag = 136
                 return
c            CHERR(1) = FNAME(IK)                                         READIF.......13800
c            CHERR(2) = FINS                                              READIF.......13900
c            ERRCOD = 'FIL-1'                                             READIF.......14000
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF.......14100
c rbw end change
         END IF                                                          READIF.......14200
C........UPDATE THE INSERTION COUNTER.  IF THE COUNT EXCEEDS 20,         READIF.......14300
C           GENERATE AN ERROR                                            READIF.......14400
         NKS(IK) = NKS(IK) + 1                                           READIF.......14500
         IF (NKS(IK).GT.20) THEN                                         READIF.......14600
c rbw begin change
                 IErrorFlag = 137
                 return
c            CHERR(1) = FNAME(IK)                                         READIF.......14700
c            CHERR(2) = FINS                                              READIF.......14800
c            ERRCOD = 'FIL-8'                                             READIF.......14900
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF.......15000
c rbw end change
         END IF                                                          READIF.......15100
C........UPDATE UNIT NUMBERS AND FILENAMES TO INDICATE THE NEWLY         READIF.......15200
C           INSERTED FILE, AND CONTINUE READING                          READIF.......15300
         IF (KU.EQ.K1) THEN                                              READIF.......15400
            K1 = KINS                                                    READIF.......15500
         ELSE                                                            READIF.......15600
            K2 = KINS                                                    READIF.......15700
         END IF                                                          READIF.......15800
         KLIST(IK, NKS(IK)) = KU                                         READIF.......15900
         FNAIN(IK, NKS(IK)) = FNAME(IK)                                  READIF.......16000
         KU = KINS                                                       READIF.......16100
         FNAME(IK) = FINS                                                READIF.......16200
         GOTO 100                                                        READIF.......16300
      END IF                                                             READIF.......16400
C                                                                        READIF.......16500
      RETURN                                                             READIF.......16600
      END                                                                READIF.......16700
C                                                                        READIF.......16800
C     SUBROUTINE        R  O  T  A  T  E           SUTRA VERSION 2.1     ROTATE.........100
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
C     SUBROUTINE        R  O  T  M  A  T           SUTRA VERSION 2.1     ROTMAT.........100
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
C     SUBROUTINE        S  O  L  V  E  B           SUTRA VERSION 2.1     SOLVEB.........100
C                                                                        SOLVEB.........200
C *** PURPOSE :                                                          SOLVEB.........300
C ***  TO SOLVE THE MATRIX EQUATION BY:                                  SOLVEB.........400
C ***   (1) DECOMPOSING THE MATRIX                                       SOLVEB.........500
C ***   (2) MODIFYING THE RIGHT-HAND SIDE                                SOLVEB.........600
C ***   (3) BACK-SUBSTITUTING FOR THE SOLUTION                           SOLVEB.........700
C                                                                        SOLVEB.........800
c rbw begin change
c      SUBROUTINE SOLVEB1(KMT,C,R,NNP,IHALFB,MAXNP,MAXBW)                  SOLVEB.........900
c rbw end change
C     SUBROUTINE        S  O  L  V  E  R           SUTRA VERSION 2.1     SOLVER.........100
C                                                                        SOLVER.........200
C *** PURPOSE :                                                          SOLVER.........300
C ***  TO CALL THE APPROPRIATE MATRIX EQUATION SOLVER.                   SOLVER.........400
C                                                                        SOLVER.........500
c rbw begin change
c      SUBROUTINE SOLVER(KMT,KPU,KSOLVR,C,R,XITER,B,NNP,IHALFB,MAXNP,     SOLVER.........600
c     1                  MAXBW,IWK,FWK,IA,JA,IERR,ITRS,ERR)               SOLVER.........700
c rbw end change
C     SUBROUTINE        S  O  L  W  R  P           SUTRA VERSION 2.1     SOLWRP.........100
C                                                                        SOLWRP.........200
C *** PURPOSE :                                                          SOLWRP.........300
C ***  TO SERVE AS A WRAPPER FOR THE ITERATIVE SOLVERS, PERFORMING       SOLWRP.........400
C ***  SOME PRELIMINARIES ON VECTORS BEFORE CALLING A SOLVER.            SOLWRP.........500
C                                                                        SOLWRP.........600
c rbw begin change
c      SUBROUTINE SOLWRP(KPU, KSOLVR, A, R, XITER, B, NNP,                SOLWRP.........700
c     1                  IWK, FWK, IA, JA, IERR, ITRS, ERR)               SOLWRP.........800
c rbw end change
C     SUBROUTINE        S  O  U  R  C  E           SUTRA VERSION 2.1     SOURCE.........100
C                                                                        SOURCE.........200
C *** PURPOSE :                                                          SOURCE.........300
C ***  TO READ AND ORGANIZE FLUID MASS SOURCE DATA AND ENERGY OR         SOURCE.........400
C ***  SOLUTE MASS SOURCE DATA.                                          SOURCE.........500
C                                                                        SOURCE.........600
      SUBROUTINE SOURCE(QIN,UIN,IQSOP,QUIN,IQSOU,IQSOPT,IQSOUT)          SOURCE.........700
c rbw begin change
      USE ErrorFlag
c rbw end change
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                SOURCE.........800
      CHARACTER INTFIL*1000                                              SOURCE.........900
      CHARACTER*80 ERRCOD,CHERR(10),UNAME,FNAME(0:8)                     SOURCE........1000
      DIMENSION KTYPE(2)                                                 SOURCE........1100
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  SOURCE........1200
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             SOURCE........1300
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              SOURCE........1400
     1   NSOP,NSOU,NBCN                                                  SOURCE........1500
      COMMON /FNAMES/ UNAME,FNAME                                        SOURCE........1600
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     SOURCE........1700
      DIMENSION QIN(NN),UIN(NN),IQSOP(NSOP),QUIN(NN),IQSOU(NSOU)         SOURCE........1800
      DIMENSION INERR(10),RLERR(10)                                      SOURCE........1900
C                                                                        SOURCE........2000
C.....NSOPI IS ACTUAL NUMBER OF FLUID SOURCE NODES.                      SOURCE........2100
C.....NSOUI IS ACTUAL NUMBER OF SOLUTE MASS OR ENERGY SOURCE NODES.      SOURCE........2200
      NSOPI=NSOP-1                                                       SOURCE........2300
      NSOUI=NSOU-1                                                       SOURCE........2400
      IQSOPT=1                                                           SOURCE........2500
      IQSOUT=1                                                           SOURCE........2600
      NIQP=0                                                             SOURCE........2700
      NIQU=0                                                             SOURCE........2800
      IF(NSOPI.EQ.0) GOTO 1000                                           SOURCE........2900
c rbw begin change
c      IF(ME) 50,50,150                                                   SOURCE........3000
c   50 WRITE(K3,100)                                                      SOURCE........3100
c  100 FORMAT('1'////11X,'F L U I D   S O U R C E   D A T A'              SOURCE........3200
c     1   ////11X,'**** NODES AT WHICH FLUID INFLOWS OR OUTFLOWS ARE ',   SOURCE........3300
c     2   'SPECIFIED ****'//11X,'NODE NUMBER',10X,                        SOURCE........3400
c     3   'FLUID INFLOW(+)/OUTFLOW(-)',5X,'SOLUTE CONCENTRATION OF'       SOURCE........3500
c     4   /11X,'(MINUS INDICATES',5X,'(FLUID MASS/SECOND)',               SOURCE........3600
c     5   12X,'INFLOWING FLUID'/12X,'TIME-VARYING',39X,                   SOURCE........3700
c     6   '(MASS SOLUTE/MASS WATER)'/12X,'FLOW RATE OR'/12X,              SOURCE........3800
c     7   'CONCENTRATION)'//)                                             SOURCE........3900
c      GOTO 300                                                           SOURCE........4000
c  150 WRITE(K3,200)                                                      SOURCE........4100
c  200 FORMAT('1'////11X,'F L U I D   S O U R C E   D A T A'              SOURCE........4200
c     1   ////11X,'**** NODES AT WHICH FLUID INFLOWS OR OUTFLOWS ARE ',   SOURCE........4300
c     2   'SPECIFIED ****'//11X,'NODE NUMBER',10X,                        SOURCE........4400
c     3   'FLUID INFLOW(+)/OUTFLOW(-)',5X,'TEMPERATURE {DEGREES CELSIUS}' SOURCE........4500
c     4   /11X,'(MINUS INDICATES',5X,'(FLUID MASS/SECOND)',12X,           SOURCE........4600
c     5   'OF INFLOWING FLUID'/12X,'TIME-VARYING'/12X,'FLOW OR'/12X,      SOURCE........4700
c     6   'TEMPERATURE)'//)                                               SOURCE........4800
C                                                                        SOURCE........4900
C.....INPUT DATASET 17:  DATA FOR FLUID SOURCES AND SINKS                SOURCE........5000
c rbw end change
  300 CONTINUE                                                           SOURCE........5100
  305 NIQP=NIQP+1                                                        SOURCE........5200
      ERRCOD = 'REA-INP-17'                                              SOURCE........5300
      CALL READIF(K1, INTFIL, ERRCOD)                                    SOURCE........5400
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 187
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IQCP                                SOURCE........5500
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SOURCE........5600
      IF (INERR(1).NE.0) then
                 IErrorFlag = 138
                 return
      endif
c rbw end change
      IQCPA = IABS(IQCP)                                                 SOURCE........5700
      IF (IQCP.EQ.0) THEN                                                SOURCE........5800
         GOTO 700                                                        SOURCE........5900
      ELSE IF (IQCPA.GT.NN) THEN                                         SOURCE........6000
c rbw begin change
                 IErrorFlag = 139
                 return
c         ERRCOD = 'INP-17-1'                                             SOURCE........6100
c         INERR(1) = IQCPA                                                SOURCE........6200
c         INERR(2) = NN                                                   SOURCE........6300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE........6400
c rbw end change
      ELSE IF (NIQP.GT.NSOPI) THEN                                       SOURCE........6500
         GOTO 305                                                        SOURCE........6600
      END IF                                                             SOURCE........6700
      ERRCOD = 'REA-INP-17'                                              SOURCE........6800
      IF (IQCP.GT.0) THEN                                                SOURCE........6900
         READ(INTFIL,*,IOSTAT=INERR(1)) IQCP,QINC                        SOURCE........7000
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SOURCE........7100
         IF (INERR(1).NE.0) then
                 IErrorFlag = 140
                 return
         endif
c rbw end change
         IF (QINC.GT.0D0) THEN                                           SOURCE........7200
            READ(INTFIL,*,IOSTAT=INERR(1)) IQCP,QINC,UINC                SOURCE........7300
c rbw begin change
c            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  SOURCE........7400
            IF (INERR(1).NE.0) then
                 IErrorFlag = 141
                 return
            endif
c rbw end change
         END IF                                                          SOURCE........7500
      END IF                                                             SOURCE........7600
      IQSOP(NIQP)=IQCP                                                   SOURCE........7700
      IF(IQCP.LT.0) IQSOPT=-1                                            SOURCE........7800
      IQP=IABS(IQCP)                                                     SOURCE........7900
      QIN(IQP)=QINC                                                      SOURCE........8000
      UIN(IQP)=UINC                                                      SOURCE........8100
      IF(IQCP.GT.0) GOTO 450                                             SOURCE........8200
c rbw begin change
c      WRITE(K3,500) IQCP                                                 SOURCE........8300
c rbw end change
      GOTO 600                                                           SOURCE........8400
  450 IF(QINC.GT.0) GOTO 460                                             SOURCE........8500
c rbw begin change
c      WRITE(K3,500) IQCP,QINC                                            SOURCE........8600
c rbw end change
      GOTO 600                                                           SOURCE........8700
c rbw begin change
  460 continue
c  460 WRITE(K3,500) IQCP,QINC,UINC                                       SOURCE........8800
c rbw end change
  500 FORMAT(11X,I10,13X,1PE14.7,16X,1PE14.7)                            SOURCE........8900
  600 GOTO 305                                                           SOURCE........9000
  700 NIQP = NIQP - 1                                                    SOURCE........9100
      IF(NIQP.EQ.NSOPI) GOTO 890                                         SOURCE........9200
c rbw begin change
                 IErrorFlag = 141
                 return
c         ERRCOD = 'INP-3,17-1'                                           SOURCE........9300
c         INERR(1) = NIQP                                                 SOURCE........9400
c         INERR(2) = NSOPI                                                SOURCE........9500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE........9600
  890 continue
c  890 IF(IQSOPT.EQ.-1) WRITE(K3,900)                                     SOURCE........9700
c rbw end change
  900 FORMAT(////11X,'THE SPECIFIED TIME VARIATIONS ARE ',               SOURCE........9800
     1   'USER-PROGRAMMED IN SUBROUTINE  B C T I M E .')                 SOURCE........9900
C                                                                        SOURCE.......10000
C                                                                        SOURCE.......10100
 1000 IF(NSOUI.EQ.0) GOTO 9000                                           SOURCE.......10200
c rbw begin change
c      IF(ME) 1050,1050,1150                                              SOURCE.......10300
c 1050 WRITE(K3,1100)                                                     SOURCE.......10400
c 1100 FORMAT(////////11X,'S O L U T E   S O U R C E   D A T A'           SOURCE.......10500
c     1   ////11X,'**** NODES AT WHICH SOURCES OR SINKS OF SOLUTE ',      SOURCE.......10600
c     2   'MASS ARE SPECIFIED ****'//11X,'NODE NUMBER',10X,               SOURCE.......10700
c     3   'SOLUTE SOURCE(+)/SINK(-)'/11X,'(MINUS INDICATES',5X,           SOURCE.......10800
c     4   '(SOLUTE MASS/SECOND)'/12X,'TIME-VARYING'/12X,                  SOURCE.......10900
c     5   'SOURCE OR SINK)'//)                                            SOURCE.......11000
c      GOTO 1305                                                          SOURCE.......11100
c 1150 WRITE(K3,1200)                                                     SOURCE.......11200
c 1200 FORMAT(////////11X,'E N E R G Y   S O U R C E   D A T A'           SOURCE.......11300
c     1   ////11X,'**** NODES AT WHICH SOURCES OR SINKS OF ',             SOURCE.......11400
c     2   'ENERGY ARE SPECIFIED ****'//11X,'NODE NUMBER',10X,             SOURCE.......11500
c     3   'ENERGY SOURCE(+)/SINK(-)'/11X,'(MINUS INDICATES',5X,           SOURCE.......11600
c     4   '(ENERGY/SECOND)'/12X,'TIME-VARYING'/12X,                       SOURCE.......11700
c     5   'SOURCE OR SINK)'//)                                            SOURCE.......11800
c rbw end change
C                                                                        SOURCE.......11900
C.....INPUT DATASET 18:  DATA FOR ENERGY OR SOLUTE MASS SOURCES OR SINKS SOURCE.......12000
 1305 NIQU=NIQU+1                                                        SOURCE.......12100
      ERRCOD = 'REA-INP-18'                                              SOURCE.......12200
      CALL READIF(K1, INTFIL, ERRCOD)                                    SOURCE.......12300
c rbw begin change
      if (IErrorFlag.ne.0) then
           IErrorFlag = 188
        return
      endif
c rbw end change
      READ(INTFIL,*,IOSTAT=INERR(1)) IQCU                                SOURCE.......12400
c rbw begin change
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SOURCE.......12500
      IF (INERR(1).NE.0) then
                 IErrorFlag = 142
                 return
      endif
c rbw end change
      IQCUA = IABS(IQCU)                                                 SOURCE.......12600
      IF (IQCU.EQ.0) THEN                                                SOURCE.......12700
         GOTO 1700                                                       SOURCE.......12800
      ELSE IF (IQCUA.GT.NN) THEN                                         SOURCE.......12900
c rbw begin change
                 IErrorFlag = 143
                 return
c         ERRCOD = 'INP-18-1'                                             SOURCE.......13000
c         INERR(1) = IQCUA                                                SOURCE.......13100
c         INERR(2) = NN                                                   SOURCE.......13200
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE.......13300
c rbw end change
      ELSE IF (NIQU.GT.NSOUI) THEN                                       SOURCE.......13400
         GOTO 1305                                                       SOURCE.......13500
      END IF                                                             SOURCE.......13600
      IF (IQCU.GT.0) THEN                                                SOURCE.......13700
         ERRCOD = 'REA-INP-18'                                           SOURCE.......13800
         READ(INTFIL,*,IOSTAT=INERR(1)) IQCU,QUINC                       SOURCE.......13900
c rbw begin change
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SOURCE.......14000
         IF (INERR(1).NE.0) then
                 IErrorFlag = 144
                 return
         endif
c rbw end change
      END IF                                                             SOURCE.......14100
      IQSOU(NIQU)=IQCU                                                   SOURCE.......14200
      IF(IQCU.LT.0) IQSOUT=-1                                            SOURCE.......14300
      IQU=IABS(IQCU)                                                     SOURCE.......14400
      QUIN(IQU)=QUINC                                                    SOURCE.......14500
      IF(IQCU.GT.0) GOTO 1450                                            SOURCE.......14600
c rbw begin change
c      WRITE(K3,1500) IQCU                                                SOURCE.......14700
c rbw end change
      GOTO 1600                                                          SOURCE.......14800
c rbw begin change
 1450 continue
c 1450 WRITE(K3,1500) IQCU,QUINC                                          SOURCE.......14900
c rbw end change
 1500 FORMAT(11X,I10,13X,1PE14.7)                                        SOURCE.......15000
 1600 GOTO 1305                                                          SOURCE.......15100
 1700 NIQU = NIQU - 1                                                    SOURCE.......15200
      IF(NIQU.EQ.NSOUI) GOTO 1890                                        SOURCE.......15300
c rbw begin change
                 IErrorFlag = 145
                 return
c         ERRCOD = 'INP-3,18-1'                                           SOURCE.......15400
c         IF (ME.EQ.1) THEN                                               SOURCE.......15500
c            CHERR(1) = 'energy'                                          SOURCE.......15600
c         ELSE                                                            SOURCE.......15700
c            CHERR(1) = 'solute'                                          SOURCE.......15800
c         END IF                                                          SOURCE.......15900
c         INERR(1) = NIQU                                                 SOURCE.......16000
c         INERR(2) = NSOUI                                                SOURCE.......16100
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE.......16200
 1890 continue
c 1890 IF(IQSOUT.EQ.-1) WRITE(K3,900)                                     SOURCE.......16300
c rbw end change
C                                                                        SOURCE.......16400
 9000 RETURN                                                             SOURCE.......16500
C                                                                        SOURCE.......16600
      END                                                                SOURCE.......16700
C                                                                        SOURCE.......16800
C     SUBROUTINE        S  U  T  E  R  R           SUTRA VERSION 2.1     SUTERR.........100
C                                                                        SUTERR.........200
C *** PURPOSE :                                                          SUTERR.........300
C ***  TO HANDLE SUTRA AND FORTRAN ERRORS.                               SUTERR.........400
C                                                                        SUTERR.........500
c rbw begin change
c      SUBROUTINE SUTERR1(ERRCOD, CHERR, INERR, RLERR)                     SUTERR.........600
c rbw end change
C     SUBROUTINE        S  U  T  R  A              SUTRA VERSION 2.1     SUTRA..........100
C                                                                        SUTRA..........200
C *** PURPOSE :                                                          SUTRA..........300
C ***  MAIN CONTROL ROUTINE FOR SUTRA SIMULATION.  ORGANIZES             SUTRA..........400
C ***  INITIALIZATION, CALCULATIONS FOR EACH TIME STEP AND ITERATION,    SUTRA..........500
C ***  AND VARIOUS OUTPUTS.                                              SUTRA..........600
C                                                                        SUTRA..........700
c rbw begin change
c      SUBROUTINE SUTRA(TITLE1,TITLE2,PMAT,UMAT,PITER,UITER,PM1,DPDTITR,  SUTRA..........800
c     1   UM1,UM2,PVEL,SL,SR,X,Y,Z,VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,  SUTRA..........900
c     2   QIN,UIN,QUIN,QINITR,RCIT,RCITM1,PVEC,UVEC,                      SUTRA.........1000
c     3   ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,VMAG,VANG1,VANG2,           SUTRA.........1100
c     4   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ, SUTRA.........1200
c     5   PANGL1,PANGL2,PANGL3,PBC,UBC,QPLITR,GXSI,GETA,GZET,FWK,B,       SUTRA.........1300
c     6   IN,IQSOP,IQSOU,IPBC,IUBC,OBSPTS,NREG,LREG,IWK,IA,JA,            SUTRA.........1400
c     7   IQSOPT,IQSOUT,IPBCT,IUBCT)                                      SUTRA.........1500
c rbw end change
C     SUBROUTINE        T  E  N  S  Y  M           SUTRA VERSION 2.1     TENSYM.........100
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
C     SUBROUTINE        T  E  R  S  E  Q           SUTRA VERSION 2.1     TERSEQ.........100
C                                                                        TERSEQ.........200
C *** PURPOSE :                                                          TERSEQ.........300
C ***  TO GRACEFULLY TERMINATE A SUTRA RUN BY DEALLOCATING THE MAIN      TERSEQ.........400
C ***  ALLOCATABLE ARRAYS AND CLOSING ALL FILES.                         TERSEQ.........500
C                                                                        TERSEQ.........600
      SUBROUTINE TERSEQ()                                                TERSEQ.........700
      USE ALLARR                                                         TERSEQ.........800
      USE SCHDEF                                                         TERSEQ.........900
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                TERSEQ........1000
      CHARACTER CDUM*1                                                   TERSEQ........1100
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7,K8                     TERSEQ........1200
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     TERSEQ........1300
     1   KSCRN,KPAUSE                                                    TERSEQ........1400
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC,NOBLIN,NFLOMX                      TERSEQ........1500
C                                                                        TERSEQ........1600
C.....TERMINATION SEQUENCE: DEALLOCATE ARRAYS, CLOSE FILES, AND STOP     TERSEQ........1700
      IF (ALLO1) THEN                                                    TERSEQ........1800
         DEALLOCATE(PITER,UITER,PM1,DPDTITR,UM1,UM2,PVEL,SL,SR,X,Y,Z,    TERSEQ........1900
     1      VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,QIN,UIN,QUIN,QINITR,    TERSEQ........2000
     2      RCIT,RCITM1)                                                 TERSEQ........2100
         DEALLOCATE(PVEC,UVEC)                                           TERSEQ........2200
         DEALLOCATE(ALMAX,ALMIN,ATMAX,ATMIN,VMAG,VANG1,PERMXX,PERMXY,    TERSEQ........2300
     1      PERMYX,PERMYY,PANGL1)                                        TERSEQ........2400
         DEALLOCATE(ALMID,ATMID,VANG2,PERMXZ,PERMYZ,PERMZX,PERMZY,       TERSEQ........2500
     1      PERMZZ,PANGL2,PANGL3)                                        TERSEQ........2600
         DEALLOCATE(PBC,UBC,QPLITR)                                      TERSEQ........2700
         DEALLOCATE(GXSI,GETA,GZET)                                      TERSEQ........2800
         DEALLOCATE(B)                                                   TERSEQ........2900
         DEALLOCATE(IN,IQSOP,IQSOU,IPBC,IUBC,NREG,LREG,JA)               TERSEQ........3000
         DEALLOCATE(OBSPTS)                                              TERSEQ........3100
      END IF                                                             TERSEQ........3200
      IF (ALLO2) THEN                                                    TERSEQ........3300
         DEALLOCATE(PMAT,UMAT,FWK)                                       TERSEQ........3400
         DEALLOCATE(IWK)                                                 TERSEQ........3500
      END IF                                                             TERSEQ........3600
      IF (ALLO3) THEN                                                    TERSEQ........3700
         DEALLOCATE(IA)                                                  TERSEQ........3800
      END IF                                                             TERSEQ........3900
      IF (ALLOCATED(SCHDLS)) DEALLOCATE(SCHDLS)                          TERSEQ........4000
      IF (ALLOCATED(OFP)) DEALLOCATE(OFP)                                TERSEQ........4100
      IF (ALLOCATED(FNAMO)) DEALLOCATE(FNAMO)                            TERSEQ........4200
      IF (ALLOCATED(ONCK78)) DEALLOCATE(ONCK78)                          TERSEQ........4300
C.....ARRAY IUNIO WILL BE DEALLOCATED AFTER THE OBSERVATION OUTPUT       TERSEQ........4400
C        FILES ARE CLOSED                                                TERSEQ........4500
      CLOSE(K00)                                                         TERSEQ........4600
      CLOSE(K0)                                                          TERSEQ........4700
      CLOSE(K1)                                                          TERSEQ........4800
      CLOSE(K2)                                                          TERSEQ........4900
      CLOSE(K3)                                                          TERSEQ........5000
      CLOSE(K4)                                                          TERSEQ........5100
      CLOSE(K5)                                                          TERSEQ........5200
      CLOSE(K6)                                                          TERSEQ........5300
      CLOSE(K7)                                                          TERSEQ........5400
      CLOSE(K8)                                                          TERSEQ........5500
      DO 8000 NFO=1,NFLOMX                                               TERSEQ........5600
         CLOSE(IUNIO(NFO))                                               TERSEQ........5700
 8000 CONTINUE                                                           TERSEQ........5800
      IF (ALLOCATED(IUNIO)) DEALLOCATE(IUNIO)                            TERSEQ........5900
c rbw begin change
c      IF ((KSCRN.EQ.1).AND.(KPAUSE.EQ.1)) THEN                           TERSEQ........6000
c         WRITE(*,9990)                                                   TERSEQ........6100
c 9990    FORMAT(/' Press ENTER to exit ...')                             TERSEQ........6200
c         READ(*,'(A1)') CDUM                                             TERSEQ........6300
c      END IF                                                             TERSEQ........6400
c      STOP ' '                                                           TERSEQ........6500
c rbw end change
C                                                                        TERSEQ........6600
      RETURN                                                             TERSEQ........6700
      END                                                                TERSEQ........6800
C                                                                        TERSEQ........6900
C     FUNCTION          T  I  M  E  T  S           SUTRA VERSION 2.1     TIMETS.........100
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
      COMMON /SCH/ NSCH,ISCHTS                                           TIMETS........1600
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
C     SUBROUTINE        Z  E  R  O                 SUTRA VERSION 2.1     ZERO...........100
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
