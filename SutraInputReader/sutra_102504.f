c RBW begin
      MODULE SutArrays
c       IMPLICIT DOUBLE PRECISION (A-H,O-Z)
c       ALLOCATABLE :: X(:),Y(:),Z(:),IPBC(:),PBC(:),IUBC(:),UBC(:),IN(:)
       DIMENSION KRV(100)
       integer KIMV4, KIMV5
      end module SutArrays
!
      subroutine GetCoordinates(AnX, AY, AZ, I)
       use SutArrays
       use ALLARR
       IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               A810....
       DLL_EXPORT GetCoordinates
      COMMON/DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              @111798b
     1   NSOP,NSOU,NBCN                                                 B210....
c      DIMENSION X(NN),Y(NN),Z(NN)
      AnX = X(I)
      AY  = Y(I)
      AZ  = Z(I)
      return
      end
!
      subroutine GetNodeNumber(NodeNum, IElem, INode)
       use SutArrays
       use ALLARR
       DLL_EXPORT GetNodeNumber
      COMMON/DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,
     1   NSOP,NSOU,NBCN
      COMMON /DIMX/ NBIX,NWI,NWF,NWL,NELT,NNNX,NEX,N48
c      COMMON /DIMX/ NBIX,NWI,NWF,NWL,NELT,NNNX,NEX,N48
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
       DLL_EXPORT GetSpecPresNodeNumber
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
       DLL_EXPORT GetSpecConcNodeNumber
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
       DLL_EXPORT CLOSE_FILE
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
C     MAIN PROGRAM       S U T R A _ M A I N       SUTRA VERSION 1.1     SUTRA_MAIN.....100
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
C|            02-4231, 250p.                                           | SUTRA_MAIN....6200
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
C|    *                                                           *    | SUTRA_MAIN...10005
C|    *  Fourth Revision: ______ 2004, Version 1.1                *    | SUTRA_MAIN...10006  ! kluge - fill in date
C|    *  by: A.M. Provost & C.I. Voss, U.S. Geological Survey     *    | SUTRA_MAIN...10007
C|    *                                                           *    | SUTRA_MAIN...10100
C|    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    | SUTRA_MAIN...10200
C|                                                                     | SUTRA_MAIN...10300
C|                                                                     | SUTRA_MAIN...10400
C|_____________________________________________________________________| SUTRA_MAIN...10500
C                                                                        SUTRA_MAIN...10600
C                                                                        SUTRA_MAIN...10700
C                                                                        SUTRA_MAIN...10800
c RBW begin
c      PROGRAM SUTRA_MAIN                                                 SUTRA_MAIN...10900
      SUBROUTINE INITIALIZE(NumNodes, NumElem, NPresB, NConcB,
     1   IERRORCODE, InputFile )
      use SutArrays
c RBW end
      USE ALLARR                                                         SUTRA_MAIN...10910
      USE PTRDEF                                                         SUTRA_MAIN...10930
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                SUTRA_MAIN...11000
      PARAMETER (NCOLMX=9)                                               SUTRA_MAIN...11050
C                                                                        SUTRA_MAIN...11100
C.....PROGRAMMERS SET SUTRA VERSION NUMBER HERE (8 CHARACTERS MAXIMUM)   SUTRA_MAIN...11200
      CHARACTER*8, PARAMETER :: VERN='1.1'                               SUTRA_MAIN...11300
C                                                                        SUTRA_MAIN...11400
c rbw begin
      character (len=*) InputFile
c rbw end
      CHARACTER*8 VERNUM                                                 SUTRA_MAIN...11500
      CHARACTER*1 TITLE1(80),TITLE2(80)                                  SUTRA_MAIN...11600
      CHARACTER*80 SIMULA(2),MSHTYP(2),LAYNOR(2),SIMSTR,MSHSTR,LAYSTR    SUTRA_MAIN...11700
      CHARACTER*80 CUNSAT, CSSFLO ,CSSTRA, CREAD                         SUTRA_MAIN...11800
      CHARACTER*80 UNSSTR, SSFSTR ,SSTSTR, RDSTR                         SUTRA_MAIN...11900
      CHARACTER*80 UNAME,FNAME                                           SUTRA_MAIN...12000
      CHARACTER*80 ERRCOD,CHERR(10)                                      SUTRA_MAIN...12100
      CHARACTER*40 SOLNAM(0:10)                                          SUTRA_MAIN...12200
      CHARACTER*10 SOLWRD(0:10)                                          SUTRA_MAIN...12300
      CHARACTER*10 ADSMOD                                                SUTRA_MAIN...12400
      CHARACTER INTFIL*1000                                              SUTRA_MAIN...12600
      CHARACTER*80 FNAIN                                                 READIF........1040
      INTEGER RMVDIM,IMVDIM                                              SUTRA_MAIN...12700
      LOGICAL ONCEK5,ONCEK6,ONCEK7                                       SUTRA_MAIN...12800
      DIMENSION FNAME(0:7),IUNIT(0:7)                                    SUTRA_MAIN...13100
      DIMENSION FNAIN(2,20)                                              SUTRA_MAIN...13150
      DIMENSION INERR(10), RLERR(10)                                     SUTRA_MAIN...13200
      DIMENSION J5COL(NCOLMX), J6COL(NCOLMX)                             SUTRA_MAIN...13240
      DIMENSION NKS(2), KLIST(2,20)                                      SUTRA_MAIN...13260
      DIMENSION KTYPE(2)                                                 ! ktype
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  SUTRA_MAIN...14800
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             SUTRA_MAIN...14900
      COMMON /DIMLAY/ NLAYS,NNLAY,NELAY                                  ! ktype
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              SUTRA_MAIN...15000
     1   NSOP,NSOU,NBCN                                                  SUTRA_MAIN...15100
      COMMON /DIMX/ NBIX,NWI,NWF,NWL,NELT,NNNX,NEX,N48                        SUTRA_MAIN...15200
      COMMON /DIMX2/ NELTA, NNVEC, NDIMIA, NDIMJA                        SUTRA_MAIN...15300
      COMMON /FNAINS/ FNAIN                                              SUTRA_MAIN...15450
      COMMON /FNAMES/ FNAME                                              SUTRA_MAIN...15500
      COMMON /FUNINS/ NKS,KLIST                                          SUTRA_MAIN...15550
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        SUTRA_MAIN...15600
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      SUTRA_MAIN...15700
      COMMON /ITSOLI/ ITRMXP,ITOLP,NSAVEP,ITRMXU,ITOLU,NSAVEU            SUTRA_MAIN...15800
      COMMON /ITSOLR/ TOLP,TOLU                                          SUTRA_MAIN...15900
      COMMON /JCOLS/ NCOLPR, LCOLPR, NCOLS5, NCOLS6, J5COL, J6COL        SUTRA_MAIN...16000
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     SUTRA_MAIN...16100
     1   KSCRN,KPAUSE                                                    SUTRA_MAIN...16200
      COMMON /MODSOR/ ADSMOD                                             SUTRA_MAIN...16300
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC                                    SUTRA_MAIN...16400
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      SUTRA_MAIN...16500
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        SUTRA_MAIN...16600
      COMMON /PLT1/ ONCEK5, ONCEK6, ONCEK7                               SUTRA_MAIN...16700
      COMMON /SOLVC/ SOLWRD, SOLNAM                                      SUTRA_MAIN...16800
      COMMON /SOLVN/ NSLVRS                                              SUTRA_MAIN...16900
      COMMON /SOLVI/ KSOLVP, KSOLVU, NN1, NN2, NN3                       SUTRA_MAIN...17000
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       SUTRA_MAIN...17100
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITMAX,TSTART                  SUTRA_MAIN...17200
      COMMON /VER/ VERNUM                                                SUTRA_MAIN...17300
c rbw begin
       DLL_EXPORT INITIALIZE
c rbw end
C....."NSLVRS" AND THE ARRAYS "SOLWRD" AND "SOLNAM" ARE INITIALIZED      SUTRA_MAIN...17500
C        IN THE BLOCK-DATA SUBPROGRAM "BDINIT"                           SUTRA_MAIN...17600
C                                                                        SUTRA_MAIN...17700
C                                                                        SUTRA_MAIN...17800
C.....SET THE ALLOCATION FLAGS TO FALSE                                  SUTRA_MAIN...18100
      ALLO1 = .FALSE.                                                    SUTRA_MAIN...18200
      ALLO2 = .FALSE.                                                    SUTRA_MAIN...18300
      ALLO3 = .FALSE.                                                    SUTRA_MAIN...18350
C                                                                        SUTRA_MAIN...18400
C_______________________________________________________________________ SUTRA_MAIN...18500
C|                                                                     | SUTRA_MAIN...18600
C|  *****************************************************************  | SUTRA_MAIN...18700
C|  *                                                               *  | SUTRA_MAIN...18800
C|  *   **********  M E M O R Y   A L L O C A T I O N  **********   *  | SUTRA_MAIN...18900
C|  *                                                               *  | SUTRA_MAIN...19000
C|  *   The main arrays used by SUTRA are dimensioned dynamically   *  | SUTRA_MAIN...19100
C|  *   in the main program, SUTRA_MAIN.  The amount of storage     *  | SUTRA_MAIN...19200
C|  *   required by these arrays depends on the dimensionality of   *  | SUTRA_MAIN...19300
C|  *   the problem (2D or 3D) and the particular solver(s) used.   *  | SUTRA_MAIN...19400
C|  *                                                               *  | SUTRA_MAIN...19500
C|  *               |---------------------|---------------------|   *  | SUTRA_MAIN...19600
C|  *               |     sum of real     |    sum of integer   |   *  | SUTRA_MAIN...19700
C|  *               |   array dimensions  |   array dimensions  |   *  | SUTRA_MAIN...19800
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...19900
C|  *   | 2D,       | (2*NBI+27)*NN+19*NE |  NN+5*NE+NSOP+NSOU  |   *  | SUTRA_MAIN...20000
C|  *   | direct    |     +3*NBCN+16      |    +2*NBCN+NOBS+4   |   *  | SUTRA_MAIN...20100
C|  *   | solver    |                     |                     |   *  | SUTRA_MAIN...20200
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...20300
C|  *   | 2D,       | 2*NELT+28*NN+19*NE  | NELT+2*NN+5*NE+NSOP |   *  | SUTRA_MAIN...20400
C|  *   | iterative |   +3*NBCN+NWF+14    |  +NSOU+2*NBCN+NOBS  |   *  | SUTRA_MAIN...20500
C|  *   | solver(s) |                     |       +NWI+2        |   *  | SUTRA_MAIN...20600
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...20700
C|  *   | 3D,       | (2*NBI+27)*NN+45*NE |  NN+9*NE+NSOP+NSOU  |   *  | SUTRA_MAIN...20800
C|  *   | direct    |      +3*NBCN+2      |    +2*NBCN+NOBS+4   |   *  | SUTRA_MAIN...20900
C|  *   | solver    |                     |                     |   *  | SUTRA_MAIN...21000
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...21100
C|  *   | 3D,       | 2*NELT+28*NN+45*NE  | NELT+2*NN+9*NE+NSOP |   *  | SUTRA_MAIN...21200
C|  *   | iterative |     +3*NBCN+NWF     |  +NSOU+2*NBCN+NOBS  |   *  | SUTRA_MAIN...21300
C|  *   | solver(s) |                     |       +NWI+2        |   *  | SUTRA_MAIN...21400
C|  *   |-----------|---------------------|---------------------|   *  | SUTRA_MAIN...21500
C|  *                                                               *  | SUTRA_MAIN...21600
C|  *   Quantities in the table above are defined in Section 7.3    *  | SUTRA_MAIN...21700
C|  *   of the published documentation (Voss & Provost, 2002,       *  | SUTRA_MAIN...21800
C|  *   USGS Water-Resources Investigations Report 02-4231).        *  | SUTRA_MAIN...21900
C|  *                                                               *  | SUTRA_MAIN...22000
C|  *   During each run, SUTRA writes memory usage information to   *  | SUTRA_MAIN...22100
C|  *   the LST output file.                                        *  | SUTRA_MAIN...22200
C|  *                                                               *  | SUTRA_MAIN...22300
C|  *****************************************************************  | SUTRA_MAIN...22400
C|_____________________________________________________________________| SUTRA_MAIN...22500
C                                                                        SUTRA_MAIN...22600
C ---> Programmers making code changes that affect dimensions must       SUTRA_MAIN...22700
C ---> check and change the following assignments for NNV and NEV:       SUTRA_MAIN...22800
C                                                                        SUTRA_MAIN...22900
C.....NNV IS NUMBER OF REAL VECTORS THAT ARE NN LONG.                    SUTRA_MAIN...23000
         NNV = 27                                                        SUTRA_MAIN...23100
C.....NEV IS NUMBER OF REAL VECTORS THAT ARE NE LONG.                    SUTRA_MAIN...23200
C        NEV = NEV2 for 2D; NEV3 for 3D                                  SUTRA_MAIN...23300
         NEV2 = 11                                                       SUTRA_MAIN...23400
         NEV3 = 21                                                       SUTRA_MAIN...23500
C                                                                        SUTRA_MAIN...23600
C_______________________________________________________________________ SUTRA_MAIN...23700
C|                                                                     | SUTRA_MAIN...23800
C|  *****************************************************************  | SUTRA_MAIN...23900
C|  *                                                               *  | SUTRA_MAIN...24000
C|  *   ***********  F I L E   A S S I G N M E N T S  ***********   *  | SUTRA_MAIN...24100
C|  *                                                               *  | SUTRA_MAIN...24200
C|  *   Unit K0 contains the FORTRAN unit number and filename       *  | SUTRA_MAIN...24300
C|  *   assignments for the various SUTRA input and output files.   *  | SUTRA_MAIN...24400
C|  *   Each line of Unit K0 begins with a file type, followed by   *  | SUTRA_MAIN...24500
C|  *   a unit number and a filename for that type, all in free     *  | SUTRA_MAIN...24600
C|  *   format. Permitted file types are INP, ICS, LST, RST, NOD,   *  | SUTRA_MAIN...24700
C|  *   ELE, OBS, and SMY. Assignments may be listed in any order.  *  | SUTRA_MAIN...24800
C|  *   Example ("#" indicates a comment):                          *  | SUTRA_MAIN...24900
C|  *   'INP'  50  'project.inp'   # required                       *  | SUTRA_MAIN...25000
C|  *   'ICS'  55  'project.ics'   # required                       *  | SUTRA_MAIN...25100
C|  *   'LST'  60  'project.lst'   # required                       *  | SUTRA_MAIN...25200
C|  *   'RST'  66  'project.rst'   # required if ISTORE>0           *  | SUTRA_MAIN...25300
C|  *   'NOD'  70  'project.nod'   # optional                       *  | SUTRA_MAIN...25400
C|  *   'ELE'  80  'project.ele'   # optional                       *  | SUTRA_MAIN...25500
C|  *   'OBS'  90  'project.obs'   # optional                       *  | SUTRA_MAIN...25600
C|  *   'SMY'  40  'project.smy'   # optional; defaults to unit=1,  *  | SUTRA_MAIN...25700
C|  *                              #           filename="SUTRA.SMY" *  | SUTRA_MAIN...25800
C|  *                                                               *  | SUTRA_MAIN...25900
C|  *****************************************************************  | SUTRA_MAIN...26000
C|_____________________________________________________________________| SUTRA_MAIN...26100
C                                                                        SUTRA_MAIN...26200
C.....SET FILENAME AND FORTRAN UNIT NUMBER FOR UNIT K0                   SUTRA_MAIN...26300
c RBW begin
      IERRORCODE = 0
c RBW end
      UNAME = 'SUTRA.FIL'                                                SUTRA_MAIN...26400
      K0 = 99                                                            SUTRA_MAIN...26500
C.....INITIALIZE "INSERT" FILE COUNTERS                                  SUTRA_MAIN...26550
      NKS(1) = 0                                                         SUTRA_MAIN...26555
      NKS(2) = 0                                                         SUTRA_MAIN...26560
C.....ASSIGN UNIT NUMBERS AND OPEN FILE UNITS FOR THIS SIMULATION        SUTRA_MAIN...26600
c rbw begin
c      CALL FOPEN(UNAME,IUNIT,NFILE)                                      SUTRA_MAIN...26700
      CALL FOPEN(UNAME,NFILE,IERRORCODE,InputFile)                      SUTRA_MAIN...23201
      if (IERRORCODE.ne.0) then
        goto 1000
      endif
c rbw end
C                                                                        SUTRA_MAIN...26900
C                                                                        SUTRA_MAIN...27000
C.....COPY PARAMETER VERN (SUTRA VERSION NUMBER) TO VARIABLE VERNUM,     SUTRA_MAIN...27100
C        WHICH IS PASSED THROUGH COMMON BLOCK VER.                       SUTRA_MAIN...27200
      VERNUM = VERN                                                      SUTRA_MAIN...27300
C                                                                        SUTRA_MAIN...27400
C.....KEEP TRACK IF OUTPUT ROUTINES HAVE BEEN EXECUTED, TO PRINT         SUTRA_MAIN...27500
C        HEADERS ONLY ONCE.                                              SUTRA_MAIN...27600
      ONCEK5 = .FALSE.                                                   SUTRA_MAIN...27700
      ONCEK6 = .FALSE.                                                   SUTRA_MAIN...27800
C                                                                        SUTRA_MAIN...27900
C.....OUTPUT BANNER                                                      SUTRA_MAIN...28000
c rbw begin
c      WRITE(K3,110) VERNUM(1:LEN_TRIM(VERNUM))                           SUTRA_MAIN...28100
c  110 FORMAT(1H1,131(1H*)////3(132(1H*)////)////                         SUTRA_MAIN...28200
c     1   47X,' SSSS   UU  UU  TTTTTT  RRRRR     AA  '/                   SUTRA_MAIN...28300
c     2   47X,'SS   S  UU  UU  T TT T  RR  RR   AAAA '/                   SUTRA_MAIN...28400
c     3   47X,'SSSS    UU  UU    TT    RRRRR   AA  AA'/                   SUTRA_MAIN...28500
c     4   47X,'    SS  UU  UU    TT    RR R    AAAAAA'/                   SUTRA_MAIN...28600
c     5   47X,'SS  SS  UU  UU    TT    RR RR   AA  AA'/                   SUTRA_MAIN...28700
c     6   47X,' SSSS    UUUU     TT    RR  RR  AA  AA'/                   SUTRA_MAIN...28800
c     7   7(/),37X,'U N I T E D    S T A T E S   ',                       SUTRA_MAIN...28900
c     8   'G E O L O G I C A L   S U R V E Y'////                         SUTRA_MAIN...29000
c     9   45X,'SUBSURFACE FLOW AND TRANSPORT SIMULATION MODEL'/           SUTRA_MAIN...29100
c     *   //58X,'-SUTRA VERSION ',A,'-'///                                SUTRA_MAIN...29200
c     A   36X,'*  SATURATED-UNSATURATED FLOW AND SOLUTE OR ENERGY',       SUTRA_MAIN...29300
c     B   ' TRANSPORT  *'////4(////132(1H*)))                             SUTRA_MAIN...29400
c rbw end
C                                                                        SUTRA_MAIN...29500
C_______________________________________________________________________ SUTRA_MAIN...29600
C|                                                                     | SUTRA_MAIN...29700
C|  *****************************************************************  | SUTRA_MAIN...29800
C|  *                                                               *  | SUTRA_MAIN...29900
C|  *   *********  R E A D I N G   I N P U T   D A T A  *********   *  | SUTRA_MAIN...30000
C|  *   *********  A N D   E R R O R   H A N D L I N G  *********   *  | SUTRA_MAIN...30100
C|  *                                                               *  | SUTRA_MAIN...30200
C|  *   SUTRA typically reads input data line by line as follows.   *  | SUTRA_MAIN...30300
C|  *   Subroutine READIF is called to skip over any comment        *  | SUTRA_MAIN...30400
C|  *   lines and read a single line of input data (up to 1000      *  | SUTRA_MAIN...30500
C|  *   characters) into internal file INTFIL. The input data       *  | SUTRA_MAIN...30600
C|  *   are then read from INTFIL. In case of an error, subroutine  *  | SUTRA_MAIN...30700
C|  *   SUTERR is called to report it, and control passes to the    *  | SUTRA_MAIN...30800
C|  *   termination sequence in subroutine TERSEQ.  The variable    *  | SUTRA_MAIN...30900
C|  *   ERRCOD is used to identify the nature of the error and is   *  | SUTRA_MAIN...31000
C|  *   set prior to calling READIF. The variables CHERR, INERR,    *  | SUTRA_MAIN...31100
C|  *   and RLERR can be used to send character, integer, or real   *  | SUTRA_MAIN...31200
C|  *   error information to subroutine SUTERR.                     *  | SUTRA_MAIN...31300
C|  *   Example from the main program:                              *  | SUTRA_MAIN...31400
C|  *                                                               *  | SUTRA_MAIN...31500
C|  *   ERRCOD = 'REA-INP-3'                                        *  | SUTRA_MAIN...31600
C|  *   CALL READIF(K1, INTFIL, ERRCOD)                             *  | SUTRA_MAIN...31700
C|  *   READ(INTFIL,*,IOSTAT=INERR(1)) NN,NE,NPBC,NUBC,             *  | SUTRA_MAIN...31800
C|  *  1   NSOP,NSOU,NOBS                                           *  | SUTRA_MAIN...31900
C|  *   IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR) *  | SUTRA_MAIN...32000
C|  *                                                               *  | SUTRA_MAIN...32100
C|  *****************************************************************  | SUTRA_MAIN...33100
C|_____________________________________________________________________| SUTRA_MAIN...33200
C                                                                        SUTRA_MAIN...33300
C.....INPUT DATASET 1:  OUTPUT HEADING                                   SUTRA_MAIN...33400
      ERRCOD = 'REA-INP-1'                                               SUTRA_MAIN...33500
c rbw begin
c      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...33600
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    SUTRA_MAIN...33600
      if (IERRORCODE.ne.0) then
        IERRORCODE = 1
        goto 1000
      endif
c rbw end
      READ(INTFIL,117,IOSTAT=INERR(1)) TITLE1                            SUTRA_MAIN...33700
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...33800
      IF (INERR(1).NE.0) THEN
         IERRORCODE = 2
         goto 1000
      END IF
c rbw end
      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...33900
      READ(INTFIL,117,IOSTAT=INERR(1)) TITLE2                            SUTRA_MAIN...34000
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...34100
      IF (INERR(1).NE.0) THEN
         IERRORCODE = 3
         goto 1000
      END IF
c rbw end
  117 FORMAT(80A1)                                                       SUTRA_MAIN...34200
C                                                                        SUTRA_MAIN...34500
C.....INPUT DATASET 2A:  SIMULATION TYPE (TYPE OF TRANSPORT)             SUTRA_MAIN...34600
C        (SET ME=-1 FOR SOLUTE TRANSPORT, ME=+1 FOR ENERGY TRANSPORT)    SUTRA_MAIN...34700
      ERRCOD = 'REA-INP-2A'                                              SUTRA_MAIN...35100
c rbw begin
c      CALL READIF(K1, INTFIL, ERRCOD)                                    SUTRA_MAIN...35200
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    SUTRA_MAIN...35200
      IF (IERRORCODE.NE.0) then
         IERRORCODE = 4
         goto 1000
      end if
c rbw end
      READ(INTFIL,*,IOSTAT=INERR(1)) SIMSTR                              SUTRA_MAIN...35400
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...35500
      IF (INERR(1).NE.0) then
         IERRORCODE = 5
         goto 1000
      end if
c rbw end
      CALL PRSWDS(SIMSTR, ' ', 2, SIMULA, NWORDS)                        SUTRA_MAIN...35900
      IF(SIMULA(1).NE.'SUTRA     ') THEN                                 SUTRA_MAIN...36000
         ERRCOD = 'INP-2A-1'                                             SUTRA_MAIN...36100
c rbw begin
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...36200
         IERRORCODE = 6
         goto 1000
c rbw end
      END IF                                                             SUTRA_MAIN...36400
      IF(SIMULA(2).EQ.'SOLUTE    ') GOTO 120                             SUTRA_MAIN...36500
      IF(SIMULA(2).EQ.'ENERGY    ') GOTO 140                             SUTRA_MAIN...36600
c rbw begin
      IERRORCODE = 7
      goto 1000
c rbw end
c      ERRCOD = 'INP-2A-2'                                                SUTRA_MAIN...36700
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           SUTRA_MAIN...36800
  120 ME=-1                                                              SUTRA_MAIN...37000
c      WRITE(K3,130)                                                      SUTRA_MAIN...37100
c  130 FORMAT(1H1//132(1H*)///20X,'* * * * *   S U T R A   S O L U ',     SUTRA_MAIN...37200
c     1   'T E   T R A N S P O R T   S I M U L A T I O N   * * * * *'//   SUTRA_MAIN...37300
c     2   /132(1H*)/)                                                     SUTRA_MAIN...37400
      GOTO 160                                                           SUTRA_MAIN...37500
  140 ME=+1                                                              SUTRA_MAIN...37600
c      WRITE(K3,150)                                                      SUTRA_MAIN...37700
c  150 FORMAT(1H1//132(1H*)///20X,'* * * * *   S U T R A   E N E R ',     SUTRA_MAIN...37800
c     1   'G Y   T R A N S P O R T   S I M U L A T I O N   * * * * *'//   SUTRA_MAIN...37900
c     2   /132(1H*)/)                                                     SUTRA_MAIN...38000
  160 CONTINUE                                                           SUTRA_MAIN...38100
C                                                                        SUTRA_MAIN...38200
C.....INPUT DATASET 2B:  MESH STRUCTURE                                  SUTRA_MAIN...38300
      ERRCOD = 'REA-INP-2B'                                              SUTRA_MAIN...38700
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    SUTRA_MAIN...38800
      if (IERRORCODE.ne.0) goto 1000
      READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR                              SUTRA_MAIN...39000
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...39100
      IF (INERR(1).NE.0) then
         IERRORCODE = 8
         goto 1000
      end if
c rbw end
      CALL PRSWDS(MSHSTR, ' ', 2, MSHTYP, NWORDS)                        SUTRA_MAIN...39500
C.....KTYPE SET ACCORDING TO THE TYPE OF FINITE-ELEMENT MESH:            SUTRA_MAIN...39600
C        2D MESH          ==>   KTYPE(1) = 2                             ! ktype
C        3D MESH          ==>   KTYPE(1) = 3                             
C        IRREGULAR MESH   ==>   KTYPE(2) = 0                             
C        LAYERED MESH     ==>   KTYPE(2) = 1                             
C        REGULAR MESH     ==>   KTYPE(2) = 2                             
C        BLOCKWISE MESH   ==>   KTYPE(2) = 3                             
ccccccC        3D, IRREGULAR MESH   ==>   KTYPE = +3                           SUTRA_MAIN...39650
ccccccC        3D, REGULAR MESH     ==>   KTYPE = -3                           SUTRA_MAIN...39700
ccccccC        2D, IRREGULAR MESH   ==>   KTYPE = +2                           SUTRA_MAIN...39800
ccccccC        2D, REGULAR MESH     ==>   KTYPE = -2                           SUTRA_MAIN...39900
      IF (MSHTYP(1).EQ.'2D        ') THEN                                SUTRA_MAIN...40100
         KTYPE(1) = 2                                                    SUTRA_MAIN...40200
      ELSE IF (MSHTYP(1).EQ.'3D        ') THEN                           SUTRA_MAIN...40300
         KTYPE(1) = 3                                                    SUTRA_MAIN...40400
      ELSE                                                               SUTRA_MAIN...40500
c rbw begin
         IERRORCODE = 9
         goto 1000
c         ERRCOD = 'INP-2B-1'                                             SUTRA_MAIN...40600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...40700
c rbw end
      END IF                                                             SUTRA_MAIN...40900
      IF ((MSHTYP(2).EQ.'REGULAR   ').OR.                                SUTRA_MAIN...41600
     1    (MSHTYP(2).EQ.'BLOCKWISE ')) THEN                              SUTRA_MAIN...41700
         ERRCOD = 'REA-INP-2B'                                           SUTRA_MAIN...41900
         IF (KTYPE(1).EQ.2) THEN                                         SUTRA_MAIN...42000
            READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR, NN1, NN2              SUTRA_MAIN...42100
            NN3 = 1                                                      SUTRA_MAIN...42200
         ELSE                                                            SUTRA_MAIN...42300
            READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR, NN1, NN2, NN3         SUTRA_MAIN...42400
         END IF                                                          SUTRA_MAIN...42500
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SUTRA_MAIN...42600
         IF (INERR(1).NE.0) THEN
            IERRORCODE = 10
            goto 1000
         end if
c rbw end
         IF (MSHTYP(2).EQ.'BLOCKWISE ') THEN                             SUTRA_MAIN...43600
            KTYPE(2) = 3                                                 ! ktype
            ERRCOD = 'REA-INP-2B'                                        SUTRA_MAIN...43700
            DO 177 I1=1,KTYPE(1)                                         SUTRA_MAIN...43800
               CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                           SUTRA_MAIN...43900
               if (IERRORCODE.ne.0) goto 1000
               READ(INTFIL,*,IOSTAT=INERR(1)) IDUM1, (IDUM2, I2=1,IDUM1) SUTRA_MAIN...44100
c rbw begin
c               IF (INERR(1).NE.0) CALL SUTERR(ERRCOD,CHERR,INERR,RLERR)  SUTRA_MAIN...44200
               IF (INERR(1).NE.0) then
                 IERRORCODE = 11
                 goto 1000
               end if
c rbw end
  177       CONTINUE                                                     SUTRA_MAIN...44600
         ELSE                                                            ! ktype
            KTYPE(2) = 2                                                 ! ktype
         END IF                                                          SUTRA_MAIN...44700
      ELSE IF (MSHTYP(2).EQ.'LAYERED   ') THEN                           SUTRA_MAIN...44710
         IF (KTYPE(1).EQ.2) THEN                                         SUTRA_MAIN...44715
                 IERRORCODE = 12
                 goto 1000
c            ERRCOD = 'INP-2B-5'                                          SUTRA_MAIN...44720
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...44725
         END IF                                                          SUTRA_MAIN...44730
         KTYPE(2) = 1                                                    ! ktype
         ERRCOD = 'REA-INP-2B'                                           SUTRA_MAIN...44735
         READ(INTFIL,*,IOSTAT=INERR(1)) MSHSTR,NLAYS,NNLAY,NELAY,LAYSTR  SUTRA_MAIN...44740
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD,CHERR,INERR,RLERR)        SUTRA_MAIN...44745
          IF (INERR(1).NE.0) then
             IERRORCODE = 13
             goto 1000
          end if
c rbw end
         CALL PRSWDS(LAYSTR, ' ', 1, LAYNOR, NWORDS)                     SUTRA_MAIN...44750
         IF ((LAYNOR(1).NE.'ACROSS').AND.(LAYNOR(1).NE.'WITHIN')) THEN   SUTRA_MAIN...44755
                 IERRORCODE = 14
                 goto 1000
c            ERRCOD = 'INP-2B-6'                                          SUTRA_MAIN...44760
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTRA_MAIN...44765
         END IF                                                          SUTRA_MAIN...44770
      ELSE IF (MSHTYP(2).EQ.'IRREGULAR ') THEN                           ! ktype
         KTYPE(2) = 0
      ELSE
                 IERRORCODE = 15
                 goto 1000
c         ERRCOD = 'INP-2B-4'                                             SUTRA_MAIN...44900
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...45000
      END IF                                                             SUTRA_MAIN...45200
C                                                                        SUTRA_MAIN...45300
C.....OUTPUT DATASET 1                                                   SUTRA_MAIN...45400
c rbw begin
c      WRITE(K3,180) TITLE1,TITLE2                                        SUTRA_MAIN...45500
c  180 FORMAT(////1X,131(1H-)//26X,80A1//26X,80A1//1X,131(1H-))           SUTRA_MAIN...45600
C                                                                        SUTRA_MAIN...45700
C.....OUTPUT FILE UNIT ASSIGNMENTS                                       SUTRA_MAIN...45800
c      WRITE(K3,202) (IUNIT(NF),FNAME(NF),NF=1,2),IUNIT(0),FNAME(0),      SUTRA_MAIN...45900
c     1   IUNIT(3),FNAME(3)                                               SUTRA_MAIN...46000
c  202 FORMAT(/////11X,'F I L E   U N I T   A S S I G N M E N T S'//      SUTRA_MAIN...46100
c     1   13X,'INPUT UNITS:'/                                             SUTRA_MAIN...46200
c     2   13X,' INP FILE (MAIN INPUT)         ',I3,4X,                    SUTRA_MAIN...46300
c     3      'ASSIGNED TO ',A80/                                          SUTRA_MAIN...46400
c     4   13X,' ICS FILE (INITIAL CONDITIONS) ',I3,4X,                    SUTRA_MAIN...46500
c     5      'ASSIGNED TO ',A80//                                         SUTRA_MAIN...46600
c     6   13X,'OUTPUT UNITS:'/                                            SUTRA_MAIN...46700
c     7   13X,' SMY FILE (RUN SUMMARY)        ',I3,4X,                    SUTRA_MAIN...46800
c     8      'ASSIGNED TO ',A80/                                          SUTRA_MAIN...46900
c     9   13X,' LST FILE (GENERAL OUTPUT)     ',I3,4X,                    SUTRA_MAIN...47000
c     T      'ASSIGNED TO ',A80)                                          SUTRA_MAIN...47100
c      IF(IUNIT(4).NE.-1) WRITE(K3,203) IUNIT(4),FNAME(4)                 SUTRA_MAIN...47200
c  203 FORMAT(13X,' RST FILE (RESTART DATA)       ',I3,4X,                SUTRA_MAIN...47300
c     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...47400
c      IF(IUNIT(5).NE.-1) WRITE(K3,204) IUNIT(5),FNAME(5)                 SUTRA_MAIN...47500
c  204 FORMAT(13X,' NOD FILE (NODEWISE OUTPUT)    ',I3,4X,                SUTRA_MAIN...47600
c     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...47700
c      IF(IUNIT(6).NE.-1) WRITE(K3,206) IUNIT(6),FNAME(6)                 SUTRA_MAIN...47800
c  206 FORMAT(13X,' ELE FILE (VELOCITY OUTPUT)    ',I3,4X,                SUTRA_MAIN...47900
c     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...48000
c      IF(IUNIT(7).NE.-1) WRITE(K3,207) IUNIT(7),FNAME(7)                 SUTRA_MAIN...48100
c  207 FORMAT(13X,' OBS FILE (OBSERVATION OUTPUT) ',I3,4X,                SUTRA_MAIN...48200
c     1   'ASSIGNED TO ',A80)                                             SUTRA_MAIN...48300
c rbw end
C                                                                        SUTRA_MAIN...48400
C.....INPUT DATASET 3:  SIMULATION CONTROL NUMBERS                       SUTRA_MAIN...48500
      ERRCOD = 'REA-INP-3'                                               SUTRA_MAIN...48900
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    SUTRA_MAIN...49000
               if (IERRORCODE.ne.0) goto 1000
      READ(INTFIL,*,IOSTAT=INERR(1)) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS      SUTRA_MAIN...49200
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...49300
               IF (INERR(1).NE.0) then
                 IERRORCODE = 16
                 goto 1000
               end if
c rbw end
c rbw begin
      NumNodes = NN
      NumElem = NE
      NPresB = NPBC
      NConcB = NUBC
c rbw end
      IF (KTYPE(2).GT.1) THEN                                            SUTRA_MAIN...49700 ! ktype
         NN123 = NN1*NN2*NN3                                             SUTRA_MAIN...49800
         IF(NN123.NE.NN) THEN                                            SUTRA_MAIN...49900
c rbw begin
c           ERRCOD = 'INP-2B,3-1'                                         SUTRA_MAIN...50000
c           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...50100
                 IERRORCODE = 17
                 goto 1000
c rbw end
         END IF                                                          SUTRA_MAIN...50300
         IF (KTYPE(1).EQ.3) THEN                                         SUTRA_MAIN...50400 ! ktype
            NE123 = (NN1 - 1)*(NN2 - 1)*(NN3 - 1)                        SUTRA_MAIN...50500
         ELSE                                                            SUTRA_MAIN...50600
            NE123 = (NN1 - 1)*(NN2 - 1)                                  SUTRA_MAIN...50700
         END IF                                                          SUTRA_MAIN...50800
         IF(NE123.NE.NE) THEN                                            SUTRA_MAIN...50900
c rbw begin
c           ERRCOD = 'INP-2B,3-2'                                         SUTRA_MAIN...51000
c           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...51100
                 IERRORCODE = 18
                 goto 1000
c rbw end
         END IF                                                          SUTRA_MAIN...51300
      ELSE IF (MSHTYP(2).EQ.'LAYERED   ') THEN                           SUTRA_MAIN...51310
         NNTOT = NLAYS*NNLAY                                             SUTRA_MAIN...51315
         IF(NNTOT.NE.NN) THEN                                            SUTRA_MAIN...51320
c rbw begin
c           ERRCOD = 'INP-2B,3-3'                                         SUTRA_MAIN...51325
c           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...51330
                 IERRORCODE = 19
                 goto 1000
c rbw end
         END IF                                                          SUTRA_MAIN...51335
         NETOT = (NLAYS - 1)*NELAY                                       SUTRA_MAIN...51340
         IF(NETOT.NE.NE) THEN                                            SUTRA_MAIN...51345
c rbw begin
c           ERRCOD = 'INP-2B,3-4'                                         SUTRA_MAIN...51350
c           CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                      SUTRA_MAIN...51355
                 IERRORCODE = 20
                 goto 1000
c rbw end
         END IF                                                          SUTRA_MAIN...51360
      ENDIF                                                              SUTRA_MAIN...51400
C                                                                        SUTRA_MAIN...51500
C.....INPUT AND OUTPUT DATASET 4:  SIMULATION MODE OPTIONS               SUTRA_MAIN...51600
      ERRCOD = 'REA-INP-4'                                               SUTRA_MAIN...52000
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    SUTRA_MAIN...52100
               if (IERRORCODE.ne.0) goto 1000
      READ(INTFIL,*,IOSTAT=INERR(1)) UNSSTR,SSFSTR,SSTSTR,RDSTR,ISTORE   SUTRA_MAIN...52300
      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SUTRA_MAIN...52400
      CALL PRSWDS(UNSSTR, ' ', 1, CUNSAT, NWORDS)                        SUTRA_MAIN...52800
      CALL PRSWDS(SSFSTR, ' ', 1, CSSFLO, NWORDS)                        SUTRA_MAIN...52900
      CALL PRSWDS(SSTSTR, ' ', 1, CSSTRA, NWORDS)                        SUTRA_MAIN...53000
      CALL PRSWDS(RDSTR,  ' ', 1, CREAD, NWORDS)                         SUTRA_MAIN...53100
      ISMERR = 0                                                         SUTRA_MAIN...53200
      IF (CUNSAT.EQ.'UNSATURATED') THEN                                  SUTRA_MAIN...53300
         IUNSAT = +1                                                     SUTRA_MAIN...53400
      ELSE IF (CUNSAT.EQ.'SATURATED') THEN                               SUTRA_MAIN...53500
         IUNSAT = 0                                                      SUTRA_MAIN...53600
      ELSE                                                               SUTRA_MAIN...53700
c rbw begin
c         ERRCOD = 'INP-4-1'                                              SUTRA_MAIN...53800
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...53900
                 IERRORCODE = 21
                 goto 1000
c rbw end
      END IF                                                             SUTRA_MAIN...54100
      IF (CSSFLO.EQ.'TRANSIENT') THEN                                    SUTRA_MAIN...54200
         ISSFLO = 0                                                      SUTRA_MAIN...54300
      ELSE IF (CSSFLO.EQ.'STEADY') THEN                                  SUTRA_MAIN...54400
         ISSFLO = +1                                                     SUTRA_MAIN...54500
      ELSE                                                               SUTRA_MAIN...54600
c rbw begin
c         ERRCOD = 'INP-4-2'                                              SUTRA_MAIN...54700
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...54800
                 IERRORCODE = 22
                 goto 1000
c rbw end
      END IF                                                             SUTRA_MAIN...55000
      IF (CSSTRA.EQ.'TRANSIENT') THEN                                    SUTRA_MAIN...55100
         ISSTRA = 0                                                      SUTRA_MAIN...55200
      ELSE IF (CSSTRA.EQ.'STEADY') THEN                                  SUTRA_MAIN...55300
         ISSTRA = +1                                                     SUTRA_MAIN...55400
      ELSE                                                               SUTRA_MAIN...55500
c rbw begin
c         ERRCOD = 'INP-4-3'                                              SUTRA_MAIN...55600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...55700
                 IERRORCODE = 23
                 goto 1000
c rbw end
      END IF                                                             SUTRA_MAIN...55900
      IF (CREAD.EQ.'COLD') THEN                                          SUTRA_MAIN...56000
         IREAD = +1                                                      SUTRA_MAIN...56100
      ELSE IF (CREAD.EQ.'WARM') THEN                                     SUTRA_MAIN...56200
         IREAD = -1                                                      SUTRA_MAIN...56300
      ELSE                                                               SUTRA_MAIN...56400
c rbw begin
c         ERRCOD = 'INP-4-4'                                              SUTRA_MAIN...56500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...56600
                 IERRORCODE = 24
                 goto 1000
c rbw end
      END IF                                                             SUTRA_MAIN...56800
c rbw begin
c      WRITE(K3,210)                                                      SUTRA_MAIN...56900
c  210 FORMAT(////11X,'S I M U L A T I O N   M O D E   ',                 SUTRA_MAIN...57000
c     1   'O P T I O N S'/)                                               SUTRA_MAIN...57100
c rbw end
      IF(ISSTRA.EQ.1.AND.ISSFLO.NE.1) THEN                               SUTRA_MAIN...57200
c rbw begin
c         ERRCOD = 'INP-4-5'                                              SUTRA_MAIN...57300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SUTRA_MAIN...57400
                 IERRORCODE = 25
                 goto 1000
c rbw end
      ENDIF                                                              SUTRA_MAIN...57600
c rbw begin
c      IF(IUNSAT.EQ.+1) WRITE(K3,215)                                     SUTRA_MAIN...57700
c      IF(IUNSAT.EQ.0) WRITE(K3,216)                                      SUTRA_MAIN...57800
c  215 FORMAT(11X,'- ALLOW UNSATURATED AND SATURATED FLOW:  UNSATURATED', SUTRA_MAIN...57900
c     1   ' PROPERTIES ARE USER-PROGRAMMED IN SUBROUTINE   U N S A T')    SUTRA_MAIN...58000
c  216 FORMAT(11X,'- ASSUME SATURATED FLOW ONLY')                         SUTRA_MAIN...58100
c      IF(ISSFLO.EQ.+1.AND.ME.EQ.-1) WRITE(K3,219)                        SUTRA_MAIN...58200
c      IF(ISSFLO.EQ.+1.AND.ME.EQ.+1) WRITE(K3,220)                        SUTRA_MAIN...58300
c      IF(ISSFLO.EQ.0) WRITE(K3,221)                                      SUTRA_MAIN...58400
c  219 FORMAT(11X,'- ASSUME STEADY-STATE FLOW FIELD CONSISTENT WITH ',    SUTRA_MAIN...58500
c     1   'INITIAL CONCENTRATION CONDITIONS')                             SUTRA_MAIN...58600
c  220 FORMAT(11X,'- ASSUME STEADY-STATE FLOW FIELD CONSISTENT WITH ',    SUTRA_MAIN...58700
c     1   'INITIAL TEMPERATURE CONDITIONS')                               SUTRA_MAIN...58800
c  221 FORMAT(11X,'- ALLOW TIME-DEPENDENT FLOW FIELD')                    SUTRA_MAIN...58900
c      IF(ISSTRA.EQ.+1) WRITE(K3,225)                                     SUTRA_MAIN...59000
c      IF(ISSTRA.EQ.0) WRITE(K3,226)                                      SUTRA_MAIN...59100
c  225 FORMAT(11X,'- ASSUME STEADY-STATE TRANSPORT')                      SUTRA_MAIN...59200
c  226 FORMAT(11X,'- ALLOW TIME-DEPENDENT TRANSPORT')                     SUTRA_MAIN...59300
c      IF(IREAD.EQ.-1) WRITE(K3,230)                                      SUTRA_MAIN...59400
c      IF(IREAD.EQ.+1) WRITE(K3,231)                                      SUTRA_MAIN...59500
c  230 FORMAT(11X,'- WARM START - SIMULATION IS TO BE ',                  SUTRA_MAIN...59600
c     1   'CONTINUED FROM PREVIOUSLY-STORED DATA')                        SUTRA_MAIN...59700
c  231 FORMAT(11X,'- COLD START - BEGIN NEW SIMULATION')                  SUTRA_MAIN...59800
c      IF(ISTORE.GT.0) WRITE(K3,240) ISTORE                               SUTRA_MAIN...59900
c      IF(ISTORE.EQ.0) WRITE(K3,241)                                      SUTRA_MAIN...60000
c  240 FORMAT(11X,'- STORE RESULTS AFTER EVERY',I9,' TIME STEPS IN',      SUTRA_MAIN...60100
c     1   ' RESTART FILE AS BACKUP AND FOR USE IN A SIMULATION RESTART')  SUTRA_MAIN...60200
c  241 FORMAT(11X,'- DO NOT STORE RESULTS FOR USE IN A',                  SUTRA_MAIN...60300
c     1   ' RESTART OF SIMULATION')                                       SUTRA_MAIN...60400
cC.....OUTPUT DATASET 3                                                   SUTRA_MAIN...60500
c      IF(ME.EQ.-1)                                                       SUTRA_MAIN...60600
c     1   WRITE(K3,245) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS                    SUTRA_MAIN...60700
c  245 FORMAT(////11X,'S I M U L A T I O N   C O N T R O L   ',           SUTRA_MAIN...60800
c     1   'N U M B E R S'// 8X,I9,5X,'NUMBER OF NODES IN FINITE-',        SUTRA_MAIN...60900
c     2   'ELEMENT MESH'/ 8X,I9,5X,'NUMBER OF ELEMENTS IN MESH'//         SUTRA_MAIN...61000
c     3    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...61100
c     4   'PRESSURE IS A SPECIFIED CONSTANT OR FUNCTION OF TIME'/         SUTRA_MAIN...61200
c     5    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...61300
c     6   'SOLUTE CONCENTRATION IS A SPECIFIED CONSTANT OR ',             SUTRA_MAIN...61400
c     7   'FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES AT',       SUTRA_MAIN...61500
c     8   ' WHICH FLUID INFLOW OR OUTFLOW IS A SPECIFIED CONSTANT',       SUTRA_MAIN...61600
c     9   ' OR FUNCTION OF TIME'/ 8X,I9,5X,'EXACT NUMBER OF NODES AT',    SUTRA_MAIN...61700
c     A   ' WHICH A SOURCE OR SINK OF SOLUTE MASS IS A SPECIFIED ',       SUTRA_MAIN...61800
c     B   'CONSTANT OR FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF ',   SUTRA_MAIN...61900
c     C   'NODES AT WHICH PRESSURE AND CONCENTRATION WILL BE OBSERVED')   SUTRA_MAIN...62000
cC                                                                        SUTRA_MAIN...62100
c      IF(ME.EQ.+1)                                                       SUTRA_MAIN...62200
c     1    WRITE(K3,247) NN,NE,NPBC,NUBC,NSOP,NSOU,NOBS                   SUTRA_MAIN...62300
c  247 FORMAT(////11X,'S I M U L A T I O N   C O N T R O L   ',           SUTRA_MAIN...62400
c     1   'N U M B E R S'// 8X,I9,5X,'NUMBER OF NODES IN FINITE-',        SUTRA_MAIN...62500
c     2   'ELEMENT MESH'/ 8X,I9,5X,'NUMBER OF ELEMENTS IN MESH'//         SUTRA_MAIN...62600
c     3    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...62700
c     4   'PRESSURE IS A SPECIFIED CONSTANT OR FUNCTION OF TIME'/         SUTRA_MAIN...62800
c     5    8X,I9,5X,'EXACT NUMBER OF NODES IN MESH AT WHICH ',            SUTRA_MAIN...62900
c     6   'TEMPERATURE IS A SPECIFIED CONSTANT OR ',                      SUTRA_MAIN...63000
c     7   'FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES AT',       SUTRA_MAIN...63100
c     8   ' WHICH FLUID INFLOW OR OUTFLOW IS A SPECIFIED CONSTANT',       SUTRA_MAIN...63200
c     9   ' OR FUNCTION OF TIME'/ 8X,I9,5X,'EXACT NUMBER OF NODES AT',    SUTRA_MAIN...63300
c     A   ' WHICH A SOURCE OR SINK OF ENERGY IS A SPECIFIED CONSTANT',    SUTRA_MAIN...63400
c     B   ' OR FUNCTION OF TIME'// 8X,I9,5X,'EXACT NUMBER OF NODES ',     SUTRA_MAIN...63500
c     C   'AT WHICH PRESSURE AND TEMPERATURE WILL BE OBSERVED')           SUTRA_MAIN...63600
c rbw end
C                                                                        SUTRA_MAIN...63700
C.....INPUT DATASETS 5 - 7 (NUMERICAL, TEMPORAL, AND ITERATION CONTROLS) SUTRA_MAIN...63800
c rbw begin
c      CALL INDAT0()                                                      SUTRA_MAIN...63900
      CALL INDAT0(IERRORCODE)                                                      SUTRA_MAIN...55200
      if (IERRORCODE.ne.0) then
            goto 1000
      end if
c rbw end
C.....KSOLVP AND KSOLVU HAVE BEEN SET ACCORDING TO THE SOLVERS SELECTED: SUTRA_MAIN...64100
C        BANDED GAUSSIAN ELIMINATION (DIRECT)   ==>   0                  SUTRA_MAIN...64200
C        IC-PRECONDITIONED CG                   ==>   1                  SUTRA_MAIN...64300
C        ILU-PRECONDITIONED GMRES               ==>   2                  SUTRA_MAIN...64400
C        ILU-PRECONDITIONED ORTHOMIN            ==>   3                  SUTRA_MAIN...64500
C                                                                        SUTRA_MAIN...64600
C.....OUTPUT DATASETS 7B & 7C                                            SUTRA_MAIN...64700
c rbw begin
c      WRITE(K3,261)                                                      SUTRA_MAIN...64800
c  261 FORMAT(////11X,'S O L V E R - R E L A T E D   ',                   SUTRA_MAIN...64900
c     1   'P A R A M E T E R S')                                          SUTRA_MAIN...65000
cC.....OUTPUT DATASETS 3B & 3C                                            SUTRA_MAIN...65600
c  266 IF (KSOLVP.NE.0) THEN                                              SUTRA_MAIN...65700
c      WRITE(K3,268) NN1, NN2, NN3,                                       SUTRA_MAIN...65800
c     1   SOLNAM(KSOLVP), ITRMXP, TOLP,                                   SUTRA_MAIN...65900
c     2   SOLNAM(KSOLVU), ITRMXU, TOLU                                    SUTRA_MAIN...66000
c  268 FORMAT(                                                            SUTRA_MAIN...66100
c     1   /8X,I9,5X,'NUMBER OF NODES IN 1ST NUMBERING DIRECTION'          SUTRA_MAIN...66200
c     2   /8X,I9,5X,'NUMBER OF NODES IN 2ND NUMBERING DIRECTION'          SUTRA_MAIN...66300
c     3   /8X,I9,5X,'NUMBER OF NODES IN 3RD NUMBERING DIRECTION'          SUTRA_MAIN...66400
c     3   //13X,'SOLVER FOR P: ',A40                                      SUTRA_MAIN...66500
c     4   //20X,I6,5X,'MAXIMUM NUMBER OF MATRIX SOLVER ITERATIONS',       SUTRA_MAIN...66600
c     5        ' DURING P SOLUTION'                                       SUTRA_MAIN...66700
c     8   /11X,1PD15.4,5X,'CONVERGENCE TOLERANCE FOR MATRIX',             SUTRA_MAIN...66800
c     9        ' SOLVER ITERATIONS DURING P SOLUTION'                     SUTRA_MAIN...66900
c     1   //13X,'SOLVER FOR U: ',A40                                      SUTRA_MAIN...67000
c     2   //20X,I6,5X,'MAXIMUM NUMBER OF MATRIX SOLVER ITERATIONS',       SUTRA_MAIN...67100
c     3        ' DURING U SOLUTION'                                       SUTRA_MAIN...67200
c     6   /11X,1PD15.4,5X,'CONVERGENCE TOLERANCE FOR MATRIX',             SUTRA_MAIN...67300
c     7        ' SOLVER ITERATIONS DURING U SOLUTION' )                   SUTRA_MAIN...67400
c      ELSE                                                               SUTRA_MAIN...67500
c      WRITE(K3,269) SOLNAM(KSOLVP)                                       SUTRA_MAIN...67600
c  269 FORMAT(/13X,'SOLVER FOR P AND U: ',A40)                            SUTRA_MAIN...67700
c      END IF                                                             SUTRA_MAIN...67800
c rbw end
C                                                                        SUTRA_MAIN...67900
C.....CALCULATE ARRAY DIMENSIONS, EXCEPT THOSE THAT DEPEND ON            SUTRA_MAIN...74000
C        BANDWIDTH OR NELT                                               SUTRA_MAIN...74005
C                                                                        SUTRA_MAIN...74100
      IF (KSOLVP.EQ.0) THEN                                              SUTRA_MAIN...74200
C........SET DIMENSIONS FOR DIRECT SOLVER                                SUTRA_MAIN...74300
         NNNX = 1                                                        SUTRA_MAIN...74400
         NDIMJA = 1                                                      SUTRA_MAIN...74750
         NNVEC = NN                                                      SUTRA_MAIN...74800
      ELSE                                                               SUTRA_MAIN...75100
C........SET DIMENSIONS FOR ITERATIVE SOLVER(S)                          SUTRA_MAIN...75200
         NNNX = NN                                                       SUTRA_MAIN...75300
         NDIMJA = NN + 1                                                 SUTRA_MAIN...76000
         NNVEC = NN                                                      SUTRA_MAIN...76100
      END IF                                                             SUTRA_MAIN...77000
      NBCN=NPBC+NUBC+1                                                   SUTRA_MAIN...77100
      NSOP=NSOP+1                                                        SUTRA_MAIN...77200
      NSOU=NSOU+1                                                        SUTRA_MAIN...77300
      NOBSN=NOBS+1                                                       SUTRA_MAIN...77500
      IF (KTYPE(1).EQ.3) THEN                                            SUTRA_MAIN...77600 ! ktype
         NEV = NEV3                                                      SUTRA_MAIN...77700
         N48 = 8                                                         SUTRA_MAIN...77800
         NEX = NE                                                        SUTRA_MAIN...77900
      ELSE                                                               SUTRA_MAIN...78000
         NEV = NEV2                                                      SUTRA_MAIN...78100
         N48 = 4                                                         SUTRA_MAIN...78200
         NEX = 1                                                         SUTRA_MAIN...78300
      END IF                                                             SUTRA_MAIN...78400
      NIN=NE*N48                                                         SUTRA_MAIN...78450
C.....NEXV IS THE NUMBER OF VECTORS THAT ARE OF LENGTH NE IN 3D AND      SUTRA_MAIN...78500
C        ARE TO BE DIMENSIONED TO LENGTH 1 IN 2D BECAUSE THEY ARE NOT    SUTRA_MAIN...78600
C        NEEDED.  THUS, IN 3D, NEXV=0; IN 2D, NEXV=NEV3-NEV2.            SUTRA_MAIN...78700
      NEVX = NEV3 - NEV                                                  SUTRA_MAIN...78800
      NEVG = 2*N48                                                       SUTRA_MAIN...78900
      NE8 = NE*N48                                                       SUTRA_MAIN...79000
      NE8X = NEX*N48                                                     SUTRA_MAIN...79100
C                                                                        SUTRA_MAIN...79200
C.....ALLOCATE REAL ARRAYS, EXCEPT THOSE THAT DEPEND ON BANDWIDTH        SUTRA_MAIN...79300
      ALLOCATE(PITER(NN),UITER(NN),PM1(NN),DPDTITR(NN),UM1(NN),UM2(NN),  SUTRA_MAIN...79400
     1   PVEL(NN),SL(NN),SR(NN),X(NN),Y(NN),Z(NN),VOL(NN),POR(NN),       SUTRA_MAIN...79500
     2   CS1(NN),CS2(NN),CS3(NN),SW(NN),DSWDP(NN),RHO(NN),SOP(NN),       SUTRA_MAIN...79600
     3   QIN(NN),UIN(NN),QUIN(NN),QINITR(NN),RCIT(NN),RCITM1(NN))        SUTRA_MAIN...79700
      ALLOCATE(PVEC(NNVEC),UVEC(NNVEC))                                  SUTRA_MAIN...79800
      ALLOCATE(ALMAX(NE),ALMIN(NE),ATMAX(NE),ATMIN(NE),VMAG(NE),         SUTRA_MAIN...79900
     1   VANG1(NE),PERMXX(NE),PERMXY(NE),PERMYX(NE),PERMYY(NE),          SUTRA_MAIN...80000
     2   PANGL1(NE))                                                     SUTRA_MAIN...80100
      ALLOCATE(ALMID(NEX),ATMID(NEX),                                    SUTRA_MAIN...80200
     1   VANG2(NEX),PERMXZ(NEX),PERMYZ(NEX),PERMZX(NEX),                 SUTRA_MAIN...80300
     2   PERMZY(NEX),PERMZZ(NEX),PANGL2(NEX),PANGL3(NEX))                SUTRA_MAIN...80400
      ALLOCATE(PBC(NBCN),UBC(NBCN),QPLITR(NBCN))                         SUTRA_MAIN...80500
      ALLOCATE(GXSI(NE,N48),GETA(NE,N48),GZET(NEX,N48))                  SUTRA_MAIN...80600
      ALLOCATE(B(NNNX))                                                  SUTRA_MAIN...80700
C.....ALLOCATE INTEGER ARRAYS, EXCEPT THOSE THAT DEPEND ON BANDWIDTH     SUTRA_MAIN...80800
C        OR NELT                                                         SUTRA_MAIN...80810
      ALLOCATE(IN(NIN),IQSOP(NSOP),IQSOU(NSOU),IPBC(NBCN),IUBC(NBCN),    SUTRA_MAIN...80900
     1   IOBS(NOBSN),NREG(NN),LREG(NE),JA(NDIMJA))                       SUTRA_MAIN...81000
      ALLO1 = .TRUE.                                                     SUTRA_MAIN...81100
C                                                                        SUTRA_MAIN...81200
C.....INPUT DATASETS 8 - 15 (OUTPUT CONTROLS; FLUID AND SOLID MATRIX     SUTRA_MAIN...81300
C        PROPERTIES; ADSORPTION PARAMETERS; PRODUCTION OF ENERGY OR      SUTRA_MAIN...81400
C        SOLUTE MASS; GRAVITY; AND NODEWISE AND ELEMENTWISE DATA)        SUTRA_MAIN...81500
c rbw begin
c      CALL INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,         SUTRA_MAIN...81600
c     1   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,                      SUTRA_MAIN...81700
c     2   PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG,IOBS)   SUTRA_MAIN...81800
      CALL INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,         SUTRA_MAIN...81600
     1   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,                      SUTRA_MAIN...81700
     2   PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG,IOBS,   SUTRA_MAIN...81800
     3   IERRORCODE)                                                     SUTRA_MAIN...71200
      if(IERRORCODE.ne.0) then
        goto 1000
      end if
c rbw end
C                                                                        SUTRA_MAIN...82000
C.....INPUT DATASETS 17 & 18 (SOURCES OF FLUID MASS AND ENERGY OR        SUTRA_MAIN...82100
C        SOLUTE MASS)                                                    SUTRA_MAIN...82200
      CALL ZERO(QIN,NN,0.0D0)                                            SUTRA_MAIN...82300
      CALL ZERO(UIN,NN,0.0D0)                                            SUTRA_MAIN...82400
      CALL ZERO(QUIN,NN,0.0D0)                                           SUTRA_MAIN...82500
c rbw begin
      IF(NSOP-1.GT.0.OR.NSOU-1.GT.0)                                     SUTRA_MAIN...82600
c     1   CALL SOURCE(QIN,UIN,IQSOP,QUIN,IQSOU,IQSOPT,IQSOUT)             SUTRA_MAIN...82700
     1   CALL SOURCE(QIN,UIN,IQSOP,QUIN,IQSOU,IQSOPT,IQSOUT,             SUTRA_MAIN...82700
     2    IERRORCODE)
      if(IERRORCODE.ne.0) then
        goto 1000
      end if
c rbw end
C                                                                        SUTRA_MAIN...83000
C.....INPUT DATASETS 19 & 20 (SPECIFIED P AND U BOUNDARY CONDITIONS)     SUTRA_MAIN...83100
c rbw begin
c      IF(NBCN-1.GT.0) CALL BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT)          SUTRA_MAIN...83200
      IF(NBCN-1.GT.0) CALL BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT,          SUTRA_MAIN...83200
     1   IERRORCODE)
      if(IERRORCODE.ne.0) then
        goto 1000
      end if
c rbw end
C                                                                        SUTRA_MAIN...83600
C.....INPUT DATASET 22 (ELEMENT INCIDENCE [MESH CONNECTION] DATA)        SUTRA_MAIN...83700
      CALL CONNEC(IN, IERRORCODE)                                                    SUTRA_MAIN...83800
      if(IERRORCODE.ne.0) then
        goto 1000
      end if
 1000 continue
      if (Allocated(POR)) deallocate(POR)
      if (Allocated(QIN)) deallocate(QIN)
      if (Allocated(UIN)) deallocate(UIN)
      if (Allocated(QUIN)) deallocate(QUIN)
      if (Allocated(ALMAX)) deallocate(ALMAX)
      if (Allocated(ALMIN)) deallocate(ALMIN)
      if (Allocated(ATMAX)) deallocate(ATMAX)
      if (Allocated(ATMIN)) deallocate(ATMIN)
      if (Allocated(PERMXX)) deallocate(PERMXX)
      if (Allocated(PERMXY)) deallocate(PERMXY)
      if (Allocated(PERMYX)) deallocate(PERMYX)
      if (Allocated(PERMYY)) deallocate(PERMYY)
      if (Allocated(PANGL1)) deallocate(PANGL1)
      if (Allocated(ALMID)) deallocate(ALMID)
      if (Allocated(ATMID)) deallocate(ATMID)
      if (Allocated(PERMXZ)) deallocate(PERMXZ)
      if (Allocated(PERMYZ)) deallocate(PERMYZ)
      if (Allocated(PERMZX)) deallocate(PERMZX)
      if (Allocated(PERMZY)) deallocate(PERMZY)
      if (Allocated(PERMZZ)) deallocate(PERMZZ)
      if (Allocated(PANGL2)) deallocate(PANGL2)
      if (Allocated(PANGL3)) deallocate(PANGL3)
      if (Allocated(IQSOP)) deallocate(IQSOP)
      if (Allocated(IQSOU)) deallocate(IQSOU)
      if (Allocated(IOBS)) deallocate(IOBS)
      if (Allocated(NREG)) deallocate(NREG)
      if (Allocated(LREG)) deallocate(LREG)
      return
C                                                                        SUTRA_MAIN...84000
C.....IF ITERATIVE SOLVER IS USED, SET UP POINTER ARRAYS IA AND JA THAT  SUTRA_MAIN...84010
C        SPECIFY MATRIX STRUCTURE IN "SLAP COLUMN" FORMAT.  DIMENSION    SUTRA_MAIN...84012
C        NELT GETS SET HERE.                                             SUTRA_MAIN...84014
c      IF (KSOLVP.NE.0) THEN                                              SUTRA_MAIN...84020
c         CALL PTRSET()                                                   SUTRA_MAIN...84025
c      ELSE                                                               SUTRA_MAIN...84030
c         NELT = NN                                                       SUTRA_MAIN...84035
c         NDIMIA = 1                                                      SUTRA_MAIN...84037
c         ALLOCATE(IA(NDIMIA))                                            SUTRA_MAIN...84040
c      END IF                                                             SUTRA_MAIN...84045
c      ALLO3 = .TRUE.                                                     SUTRA_MAIN...84050
cC                                                                        SUTRA_MAIN...84055
cC.....CALCULATE BANDWIDTH                                                SUTRA_MAIN...84100
c      CALL BANWID(IN)                                                    SUTRA_MAIN...84200
cC                                                                        SUTRA_MAIN...84300
C.....CALCULATE ARRAY DIMENSIONS THAT DEPEND ON BANDWIDTH OR NELT        SUTRA_MAIN...84400
c      IF (KSOLVP.EQ.0) THEN                                              SUTRA_MAIN...84500
C........SET DIMENSIONS FOR DIRECT SOLVER                                SUTRA_MAIN...84600
c         NCBI = NBI                                                      SUTRA_MAIN...84700
c         NELTA = NELT                                                    SUTRA_MAIN...84810
c         NWI = 1                                                         SUTRA_MAIN...84820
c         NWF = 1                                                         SUTRA_MAIN...84830
c      ELSE                                                               SUTRA_MAIN...84900
C........SET DIMENSIONS FOR ITERATIVE SOLVER(S)                          SUTRA_MAIN...85000
c         NCBI = 1                                                        SUTRA_MAIN...85100
c         NELTA = NELT                                                    SUTRA_MAIN...85210
c         KSOLVR = KSOLVP                                                 SUTRA_MAIN...85220
c         NSAVE = NSAVEP                                                  SUTRA_MAIN...85225
c         CALL DIMWRK(KSOLVR, NSAVE, NN, NELTA, NWIP, NWFP)               SUTRA_MAIN...85230
c         KSOLVR = KSOLVU                                                 SUTRA_MAIN...85235
c         NSAVE = NSAVEU                                                  SUTRA_MAIN...85240
c         CALL DIMWRK(KSOLVR, NSAVE, NN, NELTA, NWIU, NWFU)               SUTRA_MAIN...85245
c         NWI = MAX(NWIP, NWIU)                                           SUTRA_MAIN...85250
c         NWF = MAX(NWFP, NWFU)                                           SUTRA_MAIN...85255
c      END IF                                                             SUTRA_MAIN...85300
c      MATDIM=NELT*NCBI                                                   SUTRA_MAIN...85400
C                                                                        SUTRA_MAIN...85500
C.....ALLOCATE REAL AND INTEGER ARRAYS THAT DEPEND ON BANDWIDTH OR NELT  SUTRA_MAIN...85600
c      ALLOCATE(PMAT(NELT,NCBI),UMAT(NELT,NCBI),FWK(NWF))                 SUTRA_MAIN...85700
c      ALLOCATE(IWK(NWI))                                                 SUTRA_MAIN...85800
c      ALLO2 = .TRUE.                                                     SUTRA_MAIN...85900
C                                                                        SUTRA_MAIN...86000
C.....INPUT INITIAL OR RESTART CONDITIONS FROM THE ICS FILE AND          SUTRA_MAIN...86100
C        INITIALIZE PARAMETERS                                           SUTRA_MAIN...86200
c      CALL INDAT2(PVEC,UVEC,PM1,UM1,UM2,CS1,CS2,CS3,SL,SR,RCIT,SW,DSWDP, SUTRA_MAIN...86300
c     1   PBC,IPBC,IPBCT,NREG,QIN,DPDTITR)                                SUTRA_MAIN...86400
C                                                                        SUTRA_MAIN...86600
C.....COMPUTE AND OUTPUT DIMENSIONS OF SIMULATION                        SUTRA_MAIN...86700
c      RMVDIM = 27*NN + 11*NE + 10*NEX + 3*NBCN + N48*(2*NE + NEX)        SUTRA_MAIN...87300
c     1   + NNNX + 2*NELT*NCBI + NWF                                      SUTRA_MAIN...87350
c      IMVDIM = NIN + NSOP + NSOU + 2*NBCN + NOBSN + NN + NE              SUTRA_MAIN...87400
c     1   + NDIMJA + NDIMIA + NWI                                         SUTRA_MAIN...87450
c      TOTMB = (DBLE(RMVDIM)*8D0 + DBLE(IMVDIM)*4D0)/1000000.0            SUTRA_MAIN...87500
c      WRITE(K3,3000) RMVDIM, IMVDIM, TOTMB                               SUTRA_MAIN...87600
c 3000 FORMAT(////11X,'S I M U L A T I O N   D I M E N S I O N S'//       SUTRA_MAIN...87700
c     1   13X,'REAL    ARRAYS WERE ALLOCATED ',I12/                       SUTRA_MAIN...87800
c     2   13X,'INTEGER ARRAYS WERE ALLOCATED ',I12//                      SUTRA_MAIN...87900
c     3   13X,F10.3,' Mbytes MEMORY USED FOR MAIN ARRAYS')                SUTRA_MAIN...88000
C                                                                        SUTRA_MAIN...88100
c      WRITE(K3,4000)                                                     SUTRA_MAIN...88200
c 4000 FORMAT(////////8(132("-")/))                                       SUTRA_MAIN...88300
C                                                                        SUTRA_MAIN...88400
C.....CALL MAIN CONTROL ROUTINE, SUTRA                                   SUTRA_MAIN...88500
c      CALL SUTRA(TITLE1,TITLE2,PMAT,UMAT,PITER,UITER,PM1,DPDTITR,        SUTRA_MAIN...88600
c     1   UM1,UM2,PVEL,SL,SR,X,Y,Z,VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,  SUTRA_MAIN...88700
c     2   QIN,UIN,QUIN,QINITR,RCIT,RCITM1,PVEC,UVEC,                      SUTRA_MAIN...88800
c     3   ALMAX,ALMID,ALMIN,ATMAX,ATMID,ATMIN,VMAG,VANG1,VANG2,           SUTRA_MAIN...88900
c     4   PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,PERMYZ,PERMZX,PERMZY,PERMZZ, SUTRA_MAIN...89000
c     5   PANGL1,PANGL2,PANGL3,PBC,UBC,QPLITR,GXSI,GETA,GZET,FWK,B,       SUTRA_MAIN...89100
c     6   IN,IQSOP,IQSOU,IPBC,IUBC,IOBS,NREG,LREG,IWK,IA,JA,              SUTRA_MAIN...89200
c     7   IQSOPT,IQSOUT,IPBCT,IUBCT)                                      SUTRA_MAIN...89300
C                                                                        SUTRA_MAIN...89500
C.....TERMINATION SEQUENCE: DEALLOCATE ARRAYS, CLOSE FILES, AND END      SUTRA_MAIN...89600
c9000  CONTINUE                                                           SUTRA_MAIN...89700
      CALL TERSEQ()                                                      SUTRA_MAIN...89750
      END                                                                SUTRA_MAIN...93000
C                                                                        SUTRA_MAIN...93100
C     SUBPROGRAM        B  D  I  N  I  T           SUTRA VERSION 1.1     BDINIT.........100
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
C     SUBROUTINE        B  O  U  N  D              SUTRA VERSION 1.1     BOUND..........100
C                                                                        BOUND..........200
C *** PURPOSE :                                                          BOUND..........300
C ***  TO READ AND ORGANIZE SPECIFIED PRESSURE DATA AND                  BOUND..........400
C ***  SPECIFIED TEMPERATURE OR CONCENTRATION DATA.                      BOUND..........500
C                                                                        BOUND..........600
c rbw begin
c      SUBROUTINE BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT)                    BOUND..........700
      SUBROUTINE BOUND(IPBC,PBC,IUBC,UBC,IPBCT,IUBCT, IERRORCODE )                    BOUND..........700
c rbw end
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                BOUND..........800
      CHARACTER INTFIL*1000                                              BOUND..........900
      CHARACTER*80 ERRCOD,CHERR(10),FNAME(0:7)                           BOUND.........1000
c rbw begin
      INTEGER IERRORCODE
c rbw end
      DIMENSION IPBC(NBCN),PBC(NBCN),IUBC(NBCN),UBC(NBCN)                BOUND.........1100
      DIMENSION INERR(10)!,RLERR(10)                                      BOUND.........1200
      DIMENSION KTYPE(2)                                                 ! ktype
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  BOUND.........1300
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             BOUND.........1400
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              BOUND.........1500
     1   NSOP,NSOU,NBCN                                                  BOUND.........1600
      COMMON /FNAMES/ FNAME                                              BOUND.........1800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        BOUND.........1900
C                                                                        BOUND.........2000
C                                                                        BOUND.........2100
      IPBCT=1                                                            BOUND.........2200
      IUBCT=1                                                            BOUND.........2300
      IP=0                                                               BOUND.........2400
      IPU=0                                                              BOUND.........2500
c      WRITE(K3,50)                                                       BOUND.........2600
c   50 FORMAT(1H1////11X,'B O U N D A R Y   C O N D I T I O N S')         BOUND.........2700
      IF(NPBC.EQ.0) GOTO 400                                             BOUND.........2800
c      WRITE(K3,100)                                                      BOUND.........2900
c  100 FORMAT(//11X,'**** NODES AT WHICH PRESSURES ARE',                  BOUND.........3000
c     1   ' SPECIFIED ****'/)                                             BOUND.........3100
c      IF(ME) 107,107,114                                                 BOUND.........3200
c  107 WRITE(K3,108)                                                      BOUND.........3300
c  108 FORMAT(11X,'     (AS WELL AS SOLUTE CONCENTRATION OF ANY'          BOUND.........3400
c     1   /16X,' FLUID INFLOW WHICH MAY OCCUR AT THE POINT'               BOUND.........3500
c     2   /16X,' OF SPECIFIED PRESSURE)'//12X,'NODE',18X,'PRESSURE',      BOUND.........3600
c     3   13X,'CONCENTRATION'//)                                          BOUND.........3700
c      GOTO 125                                                           BOUND.........3800
c  114 WRITE(K3,115)                                                      BOUND.........3900
c  115 FORMAT(11X,'     (AS WELL AS TEMPERATURE {DEGREES CELSIUS} OF ANY' BOUND.........4000
c     1   /16X,' FLUID INFLOW WHICH MAY OCCUR AT THE POINT'               BOUND.........4100
c     2   /16X,' OF SPECIFIED PRESSURE)'//12X,'NODE',18X,                 BOUND.........4200
c     2   'PRESSURE',13X,'  TEMPERATURE'//)                               BOUND.........4300
C                                                                        BOUND.........4400
C.....INPUT DATASET 19:  DATA FOR SPECIFIED PRESSURE NODES               BOUND.........4500
  125 IPU=IPU+1                                                          BOUND.........4900
      ERRCOD = 'REA-INP-19'                                              BOUND.........5000
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE )                                    BOUND.........5100
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) IDUM                                BOUND.........5300
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        BOUND.........5400
         IF (INERR(1).NE.0) then
           IERRORCODE = 26
           return
         end if
c rbw end
      IDUMA = IABS(IDUM)                                                 BOUND.........5800
      IF (IDUM.EQ.0) THEN                                                BOUND.........5900
         GOTO 180                                                        BOUND.........6000
      ELSE IF (IDUMA.GT.NN) THEN                                         BOUND.........6100
c rbw begin
c         ERRCOD = 'INP-19-1'                                             BOUND.........6200
c         INERR(1) = IDUMA                                                BOUND.........6300
c         INERR(2) = NN                                                   BOUND.........6400
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND.........6500
           IERRORCODE = 27
           return
c rbw end
      ELSE IF (IPU.GT.NPBC) THEN                                         BOUND.........6700
         GOTO 125                                                        BOUND.........6800
      END IF                                                             BOUND.........6900
      IPBC(IPU) = IDUM                                                   BOUND.........7000
      IF (IPBC(IPU).GT.0) THEN                                           BOUND.........7100
         ERRCOD = 'REA-INP-19'                                           BOUND.........7200
         READ(INTFIL,*,IOSTAT=INERR(1)) IPBC(IPU),PBC(IPU),UBC(IPU)      BOUND.........7300
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BOUND.........7400
c         WRITE(K3,160) IPBC(IPU),PBC(IPU),UBC(IPU)                       BOUND.........7800
         IF (INERR(1).NE.0) then
           IERRORCODE = 28
           return
         end if
c rbw end
      ELSE IF (IPBC(IPU).LT.0) THEN                                      BOUND.........7900
         IPBCT = -1                                                      BOUND.........8000
c         WRITE(K3,160) IPBC(IPU)                                         BOUND.........8100
      ELSE                                                               BOUND.........8200
         GOTO 180                                                        BOUND.........8300
      END IF                                                             BOUND.........8400
c  160 FORMAT(7X,I9,6X,1PD20.13,6X,1PD20.13)                              BOUND.........8500
      GOTO 125                                                           BOUND.........8600
  180 IPU=IPU-1                                                          BOUND.........8700
      IP=IPU                                                             BOUND.........8800
      IF(IP.EQ.NPBC) GOTO 200                                            BOUND.........8900
c rbw begin
c      ERRCOD = 'INP-3,19-1'                                              BOUND.........9000
c      INERR(1) = IP                                                      BOUND.........9100
c      INERR(2) = NPBC                                                    BOUND.........9200
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           BOUND.........9300
           IERRORCODE = 29
           return
c rbw end
  200 IF(IPBCT.NE.-1) GOTO 400                                           BOUND.........9500
c      IF(ME) 205,205,215                                                 BOUND.........9600
c  205 WRITE(K3,206)                                                      BOUND.........9700
c  206 FORMAT(//12X,'TIME-DEPENDENT SPECIFIED PRESSURE'/12X,'OR INFLOW ', BOUND.........9800
c     1   'CONCENTRATION INDICATED'/12X,'BY NEGATIVE NODE NUMBER')        BOUND.........9900
c      GOTO 400                                                           BOUND........10000
c  215 WRITE(K3,216)                                                      BOUND........10100
c  216 FORMAT(//11X,'TIME-DEPENDENT SPECIFIED PRESSURE'/12X,'OR INFLOW ', BOUND........10200
c     1   'TEMPERATURE INDICATED'/12X,'BY NEGATIVE NODE NUMBER')          BOUND........10300
  400 IF(NUBC.EQ.0) GOTO 6000                                            BOUND........10400
C                                                                        BOUND........10500
c      IF(ME) 500,500,550                                                 BOUND........10600
c  500 WRITE(K3,1000)                                                     BOUND........10700
c 1000 FORMAT(////11X,'**** NODES AT WHICH SOLUTE CONCENTRATIONS ARE ',   BOUND........10800
c     1   'SPECIFIED TO BE INDEPENDENT OF LOCAL FLOWS AND FLUID SOURCES', BOUND........10900
c     2   ' ****'//12X,'NODE',13X,'CONCENTRATION'//)                      BOUND........11000
c      GOTO 1125                                                          BOUND........11100
c  550 WRITE(K3,1001)                                                     BOUND........11200
c 1001 FORMAT(////11X,'**** NODES AT WHICH TEMPERATURES ARE ',            BOUND........11300
c     1   'SPECIFIED TO BE INDEPENDENT OF LOCAL FLOWS AND FLUID SOURCES', BOUND........11400
c     2   ' ****'//12X,'NODE',15X,'TEMPERATURE'//)                        BOUND........11500
C                                                                        BOUND........11600
C.....INPUT DATASET 20:  DATA FOR SPECIFIED CONCENTRATION OR             BOUND........11700
C        TEMPERATURE NODES                                               BOUND........11800
 1125 IPU=IPU+1                                                          BOUND........12200
      ERRCOD = 'REA-INP-20'                                              BOUND........12300
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE )                                    BOUND........12400
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) IDUM                                BOUND........12600
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        BOUND........12700
         IF (INERR(1).NE.0) then
           IERRORCODE = 30
           return
         end if
c rbw end
      IDUMA = IABS(IDUM)                                                 BOUND........13100
      IF (IDUM.EQ.0) THEN                                                BOUND........13200
         GOTO 1180                                                       BOUND........13300
      ELSE IF (IDUMA.GT.NN) THEN                                         BOUND........13400
c rbw begin
c         ERRCOD = 'INP-20-1'                                             BOUND........13500
c         INERR(1) = IDUMA                                                BOUND........13600
c         INERR(2) = NN                                                   BOUND........13700
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        BOUND........13800
           IERRORCODE = 31
           return
c rbw end
      ELSE IF (IPU.GT.NPBC+NUBC) THEN                                    BOUND........14000
         GOTO 1125                                                       BOUND........14100
      END IF                                                             BOUND........14200
      IUBC(IPU) = IDUM                                                   BOUND........14300
      IF (IUBC(IPU).GT.0) THEN                                           BOUND........14400
         ERRCOD = 'REA-INP-20'                                           BOUND........14500
         READ(INTFIL,*,IOSTAT=INERR(1)) IUBC(IPU),UBC(IPU)               BOUND........14600
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     BOUND........14700
c         WRITE(K3,1150) IUBC(IPU),UBC(IPU)                               BOUND........15100
           IERRORCODE = 32
           return
c rbw end
      ELSE IF (IUBC(IPU).LT.0) THEN                                      BOUND........15200
         IUBCT = -1                                                      BOUND........15300
c         WRITE(K3,1150) IUBC(IPU)                                        BOUND........15400
      ELSE                                                               BOUND........15500
         GOTO 1180                                                       BOUND........15600
      END IF                                                             BOUND........15700
c 1150 FORMAT(11X,I9,6X,1PD20.13)                                         BOUND........15800
      GOTO 1125                                                          BOUND........15900
 1180 IPU=IPU-1                                                          BOUND........16000
      IU=IPU-IP                                                          BOUND........16100
      IF(IU.EQ.NUBC) GOTO 1200                                           BOUND........16200
c rbw begin
c      IF (ME.EQ.1) THEN                                                  BOUND........16300
c         ERRCOD = 'INP-3,20-2'                                           BOUND........16400
c      ELSE                                                               BOUND........16500
c         ERRCOD = 'INP-3,20-1'                                           BOUND........16600
c      END IF                                                             BOUND........16700
c      INERR(1) = IU                                                      BOUND........16800
c      INERR(2) = NUBC                                                    BOUND........16900
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           BOUND........17000
           IERRORCODE = 33
           return
c rbw end
 1200 continue
c 1200 IF(IUBCT.NE.-1) GOTO 6000                                          BOUND........17200
c      IF(ME) 1205,1205,1215                                              BOUND........17300
c 1205 WRITE(K3,1206)                                                     BOUND........17400
c 1206 FORMAT(//12X,'TIME-DEPENDENT SPECIFIED CONCENTRATION'/12X,'IS ',   BOUND........17500
c     1   'INDICATED BY NEGATIVE NODE NUMBER')                            BOUND........17600
c      GOTO 6000                                                          BOUND........17700
c 1215 WRITE(K3,1216)                                                     BOUND........17800
c 1216 FORMAT(//11X,'TIME-DEPENDENT SPECIFIED TEMPERATURE'/12X,'IS ',     BOUND........17900
c     1   'INDICATED BY NEGATIVE NODE NUMBER')                            BOUND........18000
C                                                                        BOUND........18100
c 6000 IF(IPBCT.EQ.-1.OR.IUBCT.EQ.-1) WRITE(K3,7000)                      BOUND........18200
c 7000 FORMAT(////11X,'THE SPECIFIED TIME VARIATIONS ARE ',               BOUND........18300
c     1   'USER-PROGRAMMED IN SUBROUTINE  B C T I M E .')                 BOUND........18400
C                                                                        BOUND........18500
C                                                                        BOUND........18600
 6000 continue
      RETURN                                                             BOUND........18700
      END                                                                BOUND........18800
C                                                                        BOUND........18900

C     SUBROUTINE        C  O  N  N  E  C           SUTRA VERSION 2D3D.1  CONNEC.........100
C                                                                        CONNEC.........200
C *** PURPOSE :                                                          CONNEC.........300
C ***  TO READ, ORGANIZE, AND CHECK DATA ON NODE INCIDENCES.             CONNEC.........400
C                                                                        CONNEC.........500
      SUBROUTINE CONNEC(IN, IERRORCODE)                                              CONNEC.........600
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                CONNEC.........700
      CHARACTER INTFIL*1000                                              CONNEC.........800
      CHARACTER CDUM10*10                                                CONNEC.........900
      CHARACTER*80 ERRCOD,CHERR(10),FNAME(0:7)                           CONNEC........1000
      DIMENSION IN(NIN)                                                  CONNEC........1100
      DIMENSION IIN(8)                                                   CONNEC........1200
      DIMENSION INERR(10),RLERR(10)                                      CONNEC........1300
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              CONNEC........1400
     1   NSOP,NSOU,NBCN                                                  CONNEC........1500
      COMMON /DIMX/ NBIX,NWI,NWF,NWL,NELT,NNNX,NEX,N48                   CONNEC........1600
      COMMON /ERRHAN/ ISERR                                              CONNEC........1700
      COMMON /FNAMES/ FNAME                                              CONNEC........1800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        CONNEC........1900
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     CONNEC........2000
     1   KSCRN,KPAUSE                                                    CONNEC........2100
C                                                                        CONNEC........2200
      IPIN=0                                                             CONNEC........2300
!      IF(KINCID.EQ.0) WRITE(K3,1)                                        CONNEC........2400
!    1 FORMAT(1H1////11X,'M E S H   C O N N E C T I O N   D A T A'//      CONNEC........2500
!     1   16X,'PRINTOUT OF NODAL INCIDENCES CANCELLED.')                  CONNEC........2600
!      IF(KINCID.EQ.+1) WRITE(K3,2)                                       CONNEC........2700
!    2 FORMAT(1H1////11X,'M E S H   C O N N E C T I O N   D A T A',       CONNEC........2800
!     1   ///11X,'**** NODAL INCIDENCES ****'///)                         CONNEC........2900
C                                                                        CONNEC........3000
C.....INPUT DATASET 22 AND CHECK FOR ERRORS                              CONNEC........3100
      ERRCOD = 'REA-INP-S22'                                             CONNEC........3200
      CALL SKPCOM(K1, NLSKIP, ERRCOD, IERRORCODE)                                    CONNEC........3300
      if (IERRORCODE.ne.0) then
        return
      endif
!      IF (ISERR) then                                                    CONNEC........3400
!           IERRORCODE = 1000
!           return
!      endif
      ERRCOD = 'REA-INP-22'                                              CONNEC........3500
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    CONNEC........3600
      if (IERRORCODE.ne.0) then
        return
      endif
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10                              CONNEC........3800
      IF (INERR(1).NE.0) THEN                                            CONNEC........3900
           IERRORCODE = 1002
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        CONNEC........4000
         RETURN                                                          CONNEC........4100
      END IF                                                             CONNEC........4200
      IF (CDUM10.NE.'INCIDENCE ') THEN                                   CONNEC........4300
           IERRORCODE = 1003
!         ERRCOD = 'INP-22-1'                                             CONNEC........4400
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        CONNEC........4500
         RETURN                                                          CONNEC........4600
      END IF                                                             CONNEC........4700
      DO 1000 L=1,NE                                                     CONNEC........4800
      ERRCOD = 'REA-INP-22'                                              CONNEC........4900
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    CONNEC........5000
      if (IERRORCODE.ne.0) then
        return
      endif
      READ(INTFIL,*,IOSTAT=INERR(1)) LL,(IIN(II),II=1,N48)               CONNEC........5200
      IF (INERR(1).NE.0) THEN                                            CONNEC........5300
           IERRORCODE = 1005
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        CONNEC........5400
         RETURN                                                          CONNEC........5500
      END IF                                                             CONNEC........5600
C.....PREPARE NODE INCIDENCE LIST FOR MESH, IN.                          CONNEC........5700
      DO 5 II=1,N48                                                      CONNEC........5800
      III=II+(L-1)*N48                                                   CONNEC........5900
    5 IN(III)=IIN(II)                                                    CONNEC........6000
      IF(IABS(LL).EQ.L) GOTO 500                                         CONNEC........6100
           IERRORCODE = 1006
!      ERRCOD = 'INP-22-2'                                                CONNEC........6200
!      INERR(1) = LL                                                      CONNEC........6300
!      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           CONNEC........6400
      RETURN                                                             CONNEC........6500
C                                                                        CONNEC........6600
C                                                                        CONNEC........6700
  500 M1=(L-1)*N48+1                                                     CONNEC........6800
      M8=M1+N48-1                                                        CONNEC........6900
      IF(KINCID.EQ.0) GOTO 1000                                          CONNEC........7000
!      WRITE(K3,650) L,(IN(M),M=M1,M8)                                    CONNEC........7100
!  650 FORMAT(11X,'ELEMENT',I9,5X,' NODES AT : ',6X,'CORNERS ',           CONNEC........7200
!     1   5(1H*),8I9,1X,5(1H*))                                           CONNEC........7300
C                                                                        CONNEC........7400
 1000 CONTINUE                                                           CONNEC........7500
C                                                                        CONNEC........7600
C                                                                        CONNEC........7700
 5000 RETURN                                                             CONNEC........7800
      END                                                                CONNEC........7900


C     SUBROUTINE        F  O  P  E  N              SUTRA VERSION 1.1     FOPEN..........100
C                                                                        FOPEN..........200
C *** PURPOSE :                                                          FOPEN..........300
C ***  OPENS FILES FOR SUTRA SIMULATION.                                 FOPEN..........400
C ***  OPENS ERROR OUTPUT FILE, READS FILE NUMBERS AND NAMES,            FOPEN..........500
C ***  AND CHECKS FOR EXISTENCE OF INPUT FILES.                          FOPEN..........600
C                                                                        FOPEN..........700
c RBW begin                                                              FOPEN..........800
c      SUBROUTINE FOPEN(UNAME,IUNIT,NFILE)                                FOPEN..........800
      SUBROUTINE FOPEN(UNAME,NFILE,IERRORCODE,                           FOPEN..........802
     1   InputFile)                                                      FOPEN..........803
c RBW end                                                                FOPEN..........804
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                FOPEN..........900
c      CHARACTER*80 FT,FN,UNAME,FNAME,ENAME,FTYPE,FTSTR,FNTMP             FOPEN.........1000
      CHARACTER*80 FN,UNAME,FNAME
c      CHARACTER*80 ERRCOD,CHERR(10)                                      FOPEN.........1100
      LOGICAL IS                                                         FOPEN.........1200
c RBW begin                                                              FOPEN..........800
      character (len=*) InputFile
      INTEGER IERRORCODE
c RBW end                                                                FOPEN..........804
c      DIMENSION FTYPE(0:7),FNAME(0:7),IUNIT(0:7)                         FOPEN.........1300
      DIMENSION FNAME(0:7),IUNIT(0:7)                                    FOPEN.........1300
c      DIMENSION FTSTR(0:7),FNTMP(0:7),IUTMP(0:7)                         FOPEN.........1400
c      DIMENSION INERR(10),RLERR(10)                                      FOPEN.........1500
      COMMON /FNAMES/ FNAME                                              FOPEN.........1600
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        FOPEN.........1700
      common /IUNITS/ IUNIT
c      DATA (FTSTR(NFT),NFT=0,7)/'SMY','INP','ICS','LST','RST',           FOPEN.........1800
c     1   'NOD','ELE','OBS'/                                              FOPEN.........1900
C                                                                        FOPEN.........2000
C.....INITIALIZE UNIT NUMBERS                                            FOPEN.........2100
      K1 = -1                                                            FOPEN.........2200
      K2 = -1                                                            FOPEN.........2300
      K3 = -1                                                            FOPEN.........2400
      K4 = -1                                                            FOPEN.........2500
      K5 = -1                                                            FOPEN.........2600
      K6 = -1                                                            FOPEN.........2700
      K7 = -1                                                            FOPEN.........2800
C                                                                        FOPEN.........2900
C.....SET DEFAULT VALUES FOR THE ERROR OUTPUT FILE                       FOPEN.........3000
      K00 = 1                                                            FOPEN.........3100
c      ENAME = 'SUTRA.SMY'                                                FOPEN.........3200
C                                                                        FOPEN.........3300
C.....OPEN FILE UNIT CONTAINING UNIT NUMBERS AND FILE ASSIGNMENTS        FOPEN.........3400
      IU=K0                                                              FOPEN.........3500
      FN=UNAME                                                           FOPEN.........3600
c RBW begin
c      INQUIRE(FILE=UNAME,EXIST=IS)                                       FOPEN.........3700
c      IF(IS) THEN                                                        FOPEN.........3800
c       OPEN(UNIT=IU,FILE=UNAME,STATUS='OLD',FORM='FORMATTED',            FOPEN.........3900
c     1   IOSTAT=KERR)                                                    FOPEN.........4000
c      ELSE                                                               FOPEN.........4100
C......OPEN DEFAULT ERROR OUTPUT FILE                                    FOPEN.........4200
c       OPEN(UNIT=K00,FILE=ENAME,STATUS='REPLACE')                        FOPEN.........4300
c       GOTO 8000                                                         FOPEN.........4400
c      ENDIF                                                              FOPEN.........4500
c      IF(KERR.GT.0) THEN                                                 FOPEN.........4600
C......OPEN DEFAULT ERROR OUTPUT FILE                                    FOPEN.........4700
c       OPEN(UNIT=K00,FILE=ENAME,STATUS='REPLACE')                        FOPEN.........4800
c       GOTO 9000                                                         FOPEN.........4900
c      END IF                                                             FOPEN.........5000
C                                                                        FOPEN.........5100
C.....IDENTIFY AND OPEN ERROR OUTPUT FILE (IF ASSIGNED), OTHERWISE       FOPEN.........5200
C        OPEN DEFAULT ERROR OUTPUT FILE                                  FOPEN.........5300
c      DO 90 NF=0,7                                                       FOPEN.........5400
c         READ(K0,*,IOSTAT=INERR(1),END=99) FT, IU, FN                    FOPEN.........5500
c         IF (INERR(1).NE.0) THEN                                         FOPEN.........5600
C...........OPEN DEFAULT ERROR OUTPUT FILE                               FOPEN.........5700
c            OPEN(UNIT=K00,FILE=ENAME,STATUS='REPLACE')                   FOPEN.........5800
c            ERRCOD = 'REA-FIL'                                           FOPEN.........5900
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     FOPEN.........6000
c         END IF                                                          FOPEN.........6200
c         IF (FT.EQ.FTSTR(0)) THEN                                        FOPEN.........6300
c            K00 = IU                                                     FOPEN.........6400
c            ENAME = FN                                                   FOPEN.........6500
c            GOTO 99                                                      FOPEN.........6600
c         END IF                                                          FOPEN.........6700
c   90 CONTINUE                                                           FOPEN.........6800
c   99 OPEN(UNIT=K00,FILE=ENAME,STATUS='REPLACE',IOSTAT=KERR)             FOPEN.........6900
c      IF (KERR.GT.0) THEN                                                FOPEN.........7000
c         IU = K00                                                        FOPEN.........7100
c         FN = ENAME                                                      FOPEN.........7200
c         K00 = 1                                                         FOPEN.........7300
c         ENAME = 'SUTRA.SMY'                                             FOPEN.........7400
C........OPEN DEFAULT ERROR OUTPUT FILE                                  FOPEN.........7500
c         OPEN(UNIT=K00,FILE=ENAME,STATUS='REPLACE')                      FOPEN.........7600
c         GOTO 9000                                                       FOPEN.........7700
c      END IF                                                             FOPEN.........7800
c      REWIND(K0)                                                         FOPEN.........7900
c      FTYPE(0) = FTSTR(0)                                                FOPEN.........8000
c      IUTMP(0) = K00                                                     FOPEN.........8100
c      FNTMP(0) = ENAME                                                   FOPEN.........8200
c      NFILE = 0                                                          FOPEN.........8300
C                                                                        FOPEN.........8400
C.....REREAD FILE CONTAINING UNIT NUMBERS AND FILE ASSIGNMENTS           FOPEN.........8500
C        AND CHECK FOR VALIDITY OF FILE TYPE SPECIFICATIONS              FOPEN.........8600
c      ILOG = 0                                                           FOPEN.........8700
c      DO 190 NF=0,7                                                      FOPEN.........8800
c  100    READ(K0,*,IOSTAT=INERR(1),END=200) FT, IU, FN                   FOPEN.........8900
c         IF (INERR(1).NE.0) THEN                                         FOPEN.........9000
c            ERRCOD = 'REA-FIL'                                           FOPEN.........9100
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     FOPEN.........9200
c         END IF                                                          FOPEN.........9400
c         IF (FT.EQ.FTSTR(0)) THEN                                        FOPEN.........9500
c            ILOG = ILOG + 1                                              FOPEN.........9600
c            IF (ILOG.EQ.1) THEN                                          FOPEN.........9700
c               GOTO 190                                                  FOPEN.........9800
c            ELSE                                                         FOPEN.........9900
c               GOTO 170                                                  FOPEN........10000
c            END IF                                                       FOPEN........10100
c         END IF                                                          FOPEN........10200
c         DO 160 NFT=1,7                                                  FOPEN........10300
c            IF (FT.EQ.FTSTR(NFT)) GOTO 170                               FOPEN........10400
c  160    CONTINUE                                                        FOPEN........10500
c         ERRCOD = 'FIL-5'                                                FOPEN........10600
c         CHERR(1) = UNAME                                                FOPEN........10700
c         CHERR(2) = FT                                                   FOPEN........10800
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        FOPEN........10900
c  170    NFILE=NFILE+1                                                   FOPEN........11100
c         FTYPE(NFILE)=FT                                                 FOPEN........11200
c         IUTMP(NFILE)=IU                                                 FOPEN........11300
c         FNTMP(NFILE)=FN                                                 FOPEN........11400
c  190 CONTINUE                                                           FOPEN........11500
c  200 CONTINUE                                                           FOPEN........11600
C                                                                        FOPEN........11700
cC.....CHECK FOR REPEATED UNIT NUMBERS AND FILENAMES                      FOPEN........11800
c      DO 250 NF=0,NFILE-1                                                FOPEN........11900
c      DO 250 NF2=NF+1,NFILE                                              FOPEN........12000
c         IF (IUTMP(NF2).EQ.IUTMP(NF)) THEN                               FOPEN........12100
c            ERRCOD = 'FIL-3'                                             FOPEN........12200
c            INERR(1) = IUTMP(NF)                                         FOPEN........12300
c            CHERR(1) = UNAME                                             FOPEN........12400
c            CHERR(2) = FNTMP(NF)                                         FOPEN........12500
c            CHERR(3) = FNTMP(NF2)                                        FOPEN........12600
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     FOPEN........12700
c         END IF                                                          FOPEN........12900
c         IF (FNTMP(NF2).EQ.FNTMP(NF)) THEN                               FOPEN........13000
c            ERRCOD = 'FIL-4'                                             FOPEN........13100
c            CHERR(1) = UNAME                                             FOPEN........13200
c            CHERR(2) = FNTMP(NF)                                         FOPEN........13300
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     FOPEN........13400
c         END IF                                                          FOPEN........13600
c  250 CONTINUE                                                           FOPEN........13700
C                                                                        FOPEN........13800
C.....PUT FILES IN STANDARD ORDER                                        FOPEN........13900
c      DO 280 NFT=0,7                                                     FOPEN........14000
c         IUNIT(NFT) = -1                                                 FOPEN........14100
c         DO 270 NF=0,NFILE                                               FOPEN........14200
c            IF (FTYPE(NF).EQ.FTSTR(NFT)) THEN                            FOPEN........14300
c               IF (IUNIT(NFT).EQ.-1) THEN                                FOPEN........14400
c                  IUNIT(NFT) = IUTMP(NF)                                 FOPEN........14500
c                  FNAME(NFT) = FNTMP(NF)                                 FOPEN........14600
c               ELSE                                                      FOPEN........14700
c                  ERRCOD = 'FIL-6'                                       FOPEN........14800
c                  CHERR(1) = UNAME                                       FOPEN........14900
c                  CHERR(2) = FTYPE(NF)                                   FOPEN........15000
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               FOPEN........15100
c               END IF                                                    FOPEN........15300
c            END IF                                                       FOPEN........15400
c  270    CONTINUE                                                        FOPEN........15500
c         IF ((NFT.GE.1).AND.(NFT.LE.4).AND.(IUNIT(NFT).EQ.-1)) THEN      FOPEN........15600
c            ERRCOD = 'FIL-7'                                             FOPEN........15700
c            CHERR(1) = UNAME                                             FOPEN........15800
c            CHERR(2) = FTSTR(NFT)                                        FOPEN........15900
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     FOPEN........16000
c         END IF                                                          FOPEN........16200
c  280 CONTINUE                                                           FOPEN........16300
c RBW end                                                                FOPEN..........804
C.....(K00 HAS BEEN SET PREVIOUSLY)                                      FOPEN........16400
c RBW begin                                                              FOPEN..........804
c      K1=IUNIT(1)                                                        FOPEN........16500
c      K2=IUNIT(2)                                                        FOPEN........16600
c      K3=IUNIT(3)                                                        FOPEN........16700
c      K4=IUNIT(4)                                                        FOPEN........16800
c      K5=IUNIT(5)                                                        FOPEN........16900
c      K6=IUNIT(6)                                                        FOPEN........17000
c      K7=IUNIT(7)                                                        FOPEN........17100
      K1=50                                                              FOPEN........15800
      K2=0                                                                FOPEN........15900
      K3=0                                                                FOPEN........16000
      K4=0                                                                FOPEN........16100
      K5=0                                                                FOPEN........16200
      K6=0                                                                FOPEN........16300
      K7=0                                                                FOPEN........16400
      NFILE=1                                                           Z320...$
      IUNIT(NFILE)=K1                                                   Z330...$
      FNAME(NFILE)=InputFile                                                  Z340...$
c RBW end                                                                FOPEN..........804
C                                                                        FOPEN........17200
C.....CHECK FOR EXISTENCE OF INPUT FILES                                 FOPEN........17300
C        AND OPEN INPUT AND OUTPUT FILES (EXCEPT SMY FILE)               FOPEN........17400
c RBW begin                                                                FOPEN..........804
c      DO 300 NF=1,7                                                      FOPEN........17500
      DO 300 NF=1,NFILE                                                      FOPEN........17500
c RBW end                                                                FOPEN..........804
      IU=IUNIT(NF)                                                       FOPEN........17600
      FN=FNAME(NF)                                                       FOPEN........17700
      IF (IU.EQ.-1) GOTO 300                                             FOPEN........17800
      IF(NF.LE.2) THEN                                                   FOPEN........17900
       INQUIRE(FILE=FN,EXIST=IS)                                         FOPEN........18000
       IF(IS) THEN                                                       FOPEN........18100
        OPEN(UNIT=IU,FILE=FN,STATUS='OLD',FORM='FORMATTED',IOSTAT=KERR)  FOPEN........18200
       ELSE                                                              FOPEN........18300
        GOTO 8000                                                        FOPEN........18400
       ENDIF                                                             FOPEN........18500
      ELSE                                                               FOPEN........18600
       OPEN(UNIT=IU,FILE=FN,STATUS='REPLACE',FORM='FORMATTED',           FOPEN........18700
     1    IOSTAT=KERR)                                                   FOPEN........18800
      ENDIF                                                              FOPEN........18900
      IF(KERR.GT.0) GOTO 9000                                            FOPEN........19000
  300 CONTINUE                                                           FOPEN........19100
      RETURN                                                             FOPEN........19200
C                                                                        FOPEN........19300
 8000 CONTINUE                                                           FOPEN........19400
C.....WRITE ERROR MESSAGE AND RETURN                                     FOPEN........19500
c RBW begin                                                                FOPEN..........804
      IERRORCODE = 34
      RETURN
c      ERRCOD = 'FIL-1'                                                   FOPEN........19600
c      CHERR(1) = UNAME                                                   FOPEN........19700
c      CHERR(2) = FN                                                      FOPEN........19800
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           FOPEN........19900
c RBW end                                                                FOPEN..........804
C                                                                        FOPEN........20100
 9000 CONTINUE                                                           FOPEN........20200
C.....WRITE ERROR MESSAGE AND RETURN                                     FOPEN........20300
c RBW begin                                                                FOPEN..........804
      IERRORCODE = 35
      RETURN
c      ERRCOD = 'FIL-2'                                                   FOPEN........20400
c      CHERR(1) = UNAME                                                   FOPEN........20500
c      CHERR(2) = FN                                                      FOPEN........20600
c      INERR(1) = IU                                                      FOPEN........20700
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           FOPEN........20800
c RBW end                                                                FOPEN..........804
C                                                                        FOPEN........21000
      END                                                                FOPEN........21100
C                                                                        FOPEN........21200
C     SUBROUTINE        I  N  D  A  T  0           SUTRA VERSION 1.1     INDAT0.........100
C                                                                        INDAT0.........200
C *** PURPOSE :                                                          INDAT0.........300
C ***  TO INPUT, OUTPUT, AND ORGANIZE A PORTION OF THE INP FILE          INDAT0.........400
C ***  INPUT DATA (DATASETS 5 THROUGH 7)                                 INDAT0.........500
C                                                                        INDAT0.........600
c rbw begin
c      SUBROUTINE INDAT0()                                                INDAT0.........700
      SUBROUTINE INDAT0(IERRORCODE)                                                INDAT0.........700
c rbw end
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                INDAT0.........800
      CHARACTER INTFIL*1000                                              INDAT0.........900
      CHARACTER*10 ADSMOD                                                INDAT0........1000
      CHARACTER SOLWRD(0:10)*10,SOLNAM(0:10)*40                          INDAT0........1100
      CHARACTER*10 CSOLVP,CSOLVU                                         INDAT0........1400
c      CHARACTER*80 ERRCOD,CHERR(10),FNAME(0:7)                           INDAT0........1500
      CHARACTER*80 ERRCOD,FNAME(0:7)                                     INDAT0........1500
      DIMENSION INERR(10),RLERR(10)                                      INDAT0........1600
      DIMENSION KTYPE(2)                                                 ! ktype
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  INDAT0........1700
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             INDAT0........1800
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              INDAT0........1900
     1   NSOP,NSOU,NBCN                                                  INDAT0........2000
      COMMON /DIMX/ NBIX,NWI,NWF,NWL,NELT,NNNX,NEX,N48                        INDAT0........2100
      COMMON /DIMX2/ NELTA,NNVEC,NDIMIA,NDIMJA                           INDAT0........2200
      COMMON /FNAMES/ FNAME                                              INDAT0........2400
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        INDAT0........2500
      COMMON /GRAVEC/ GRAVX,GRAVY,GRAVZ                                  INDAT0........2600
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      INDAT0........2700
      COMMON /ITSOLI/ ITRMXP,ITOLP,NSAVEP,ITRMXU,ITOLU,NSAVEU            INDAT0........2800
      COMMON /ITSOLR/ TOLP,TOLU                                          INDAT0........2900
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     INDAT0........3000
     1   KSCRN,KPAUSE                                                    INDAT0........3100
      COMMON /MODSOR/ ADSMOD                                             INDAT0........3200
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      INDAT0........3300
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        INDAT0........3400
      COMMON /SOLVC/ SOLWRD,SOLNAM                                       INDAT0........3500
      COMMON /SOLVI/ KSOLVP,KSOLVU,NN1,NN2,NN3                           INDAT0........3600
      COMMON /SOLVN/ NSLVRS                                              INDAT0........3700
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       INDAT0........3800
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITMAX,TSTART                  INDAT0........3900
C                                                                        INDAT0........4300
c rbw begin
      INTEGER IERRORCODE
c rbw end
      INSTOP=0                                                           INDAT0........4400
C                                                                        INDAT0........4500
C.....INPUT DATASET 5: NUMERICAL CONTROL PARAMETERS                      INDAT0........4600
      ERRCOD = 'REA-INP-5'                                               INDAT0........5000
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT0........5100
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) UP,GNUP,GNUU                        INDAT0........5300
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0........5400
      IF (INERR(1).NE.0) then
        IERRORCODE = 36
        return
      end if
c      IF(ME.EQ.-1) WRITE(K3,70) UP,GNUP,GNUU                             INDAT0........5800
c   70 FORMAT(////11X,'N U M E R I C A L   C O N T R O L   D A T A'//     INDAT0........5900
c     1   11X,F15.5,5X,'"UPSTREAM WEIGHTING" FACTOR'/                     INDAT0........6000
c     2   11X,1PD15.4,5X,'SPECIFIED PRESSURE BOUNDARY CONDITION FACTOR'/  INDAT0........6100
c     3   11X,1PD15.4,5X,'SPECIFIED CONCENTRATION BOUNDARY CONDITION ',   INDAT0........6200
c     4   'FACTOR')                                                       INDAT0........6300
c      IF(ME.EQ.+1) WRITE(K3,80) UP,GNUP,GNUU                             INDAT0........6400
c   80 FORMAT(////11X,'N U M E R I C A L   C O N T R O L   D A T A'//     INDAT0........6500
c     1   11X,F15.5,5X,'"UPSTREAM WEIGHTING" FACTOR'/                     INDAT0........6600
c     2   11X,1PD15.4,5X,'SPECIFIED PRESSURE BOUNDARY CONDITION FACTOR'/  INDAT0........6700
c     3   11X,1PD15.4,5X,'SPECIFIED TEMPERATURE BOUNDARY CONDITION ',     INDAT0........6800
c     4   'FACTOR')                                                       INDAT0........6900
c rbw end
C                                                                        INDAT0........7000
C.....INPUT DATASET 6: TEMPORAL CONTROL AND SOLUTION CYCLING DATA        INDAT0........7100
      ERRCOD = 'REA-INP-6'                                               INDAT0........7500
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT0........7600
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) ITMAX,DELT,TMAX,ITCYC,DTMULT,DTMAX, INDAT0........7800
     1   NPCYC,NUCYC                                                     INDAT0........7900
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0........8000
      IF (INERR(1).NE.0) then
        IERRORCODE = 37
        return
      end if
c rbw end
c      WRITE(K3,120) ITMAX,DELT,TMAX,ITCYC,DTMULT,DTMAX,NPCYC,NUCYC       INDAT0........8400
c  120 FORMAT(1H1////11X,'T E M P O R A L   C O N T R O L   A N D   ',    INDAT0........8500
c     1   'S O L U T I O N   C Y C L I N G   D A T A',                    INDAT0........8600
c     2   //11X,I15,5X,'MAXIMUM ALLOWED NUMBER OF TIME STEPS'             INDAT0........8700
c     3   /11X,1PD15.4,5X,'INITIAL TIME STEP (IN SECONDS)'                INDAT0........8800
c     4   /11X,1PD15.4,5X,'MAXIMUM ALLOWED SIMULATION TIME (IN SECONDS)'  INDAT0........8900
c     5   //11X,I15,5X,'TIME STEP MULTIPLIER CYCLE (IN TIME STEPS)'       INDAT0........9000
c     6   /11X,0PF15.5,5X,'MULTIPLICATION FACTOR FOR TIME STEP CHANGE'    INDAT0........9100
c     7   /11X,1PD15.4,5X,'MAXIMUM ALLOWED TIME STEP (IN SECONDS)'        INDAT0........9200
c     8   //11X,I15,5X,'FLOW SOLUTION CYCLE (IN TIME STEPS)'              INDAT0........9300
c     9   /11X,I15,5X,'TRANSPORT SOLUTION CYCLE (IN TIME STEPS)')         INDAT0........9400
      IF(NPCYC.GE.1.AND.NUCYC.GE.1) GOTO 140                             INDAT0........9500
c rbw begin
c      ERRCOD = 'INP-6-1'                                                 INDAT0........9600
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           INDAT0........9700
        IERRORCODE = 38
        return
c rbw end
  140 IF(NPCYC.EQ.1.OR.NUCYC.EQ.1) GOTO 160                              INDAT0........9900
c rbw begin
c      ERRCOD = 'INP-6-2'                                                 INDAT0.......10000
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           INDAT0.......10100
        IERRORCODE = 39
        return
c rbw end
  160 IF (DELT.LE.DTMAX) GOTO 180                                        INDAT0.......10300
c rbw begin
c      ERRCOD = 'INP-6-3'                                                 INDAT0.......10400
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           INDAT0.......10500
        IERRORCODE = 40
        return
c rbw end
  180 CONTINUE                                                           INDAT0.......10700
C.....SET MAXIMUM ALLOWED TIME STEPS IN SIMULATION FOR                   INDAT0.......10800
C        STEADY-STATE FLOW AND STEADY-STATE TRANSPORT SOLUTION MODES     INDAT0.......10900
      IF(ISSFLO.EQ.1) THEN                                               INDAT0.......11000
         NPCYC=ITMAX+1                                                   INDAT0.......11100
         NUCYC=1                                                         INDAT0.......11200
      END IF                                                             INDAT0.......11300
      IF(ISSTRA.EQ.1) ITMAX=1                                            INDAT0.......11400
C                                                                        INDAT0.......11500
C.....INPUT DATASET 7A:  ITERATION CONTROLS FOR RESOLVING NONLINEARITIES INDAT0.......11600
      ERRCOD = 'REA-INP-7A'                                              INDAT0.......12000
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT0.......12100
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) ITRMAX                              INDAT0.......12300
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......12400
      IF (INERR(1).NE.0) then
        IERRORCODE = 41
        return
      end if
c rbw end
      IF (ITRMAX.GT.1) THEN                                              INDAT0.......12800
         ERRCOD = 'REA-INP-7A'                                           INDAT0.......12900
         READ(INTFIL,*,IOSTAT=INERR(1)) ITRMAX,RPMAX,RUMAX               INDAT0.......13000
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......13100
         IF (INERR(1).NE.0) then
           IERRORCODE = 42
           return
         end if
c rbw end
      END IF                                                             INDAT0.......13500
c rbw begin
c      IF(ITRMAX-1) 192,192,194                                           INDAT0.......13600
c  192 WRITE(K3,193)                                                      INDAT0.......13700
c  193 FORMAT(////11X,'I T E R A T I O N   C O N T R O L   D A T A',      INDAT0.......13800
c     1   //11X,'  NON-ITERATIVE SOLUTION')                               INDAT0.......13900
c      GOTO 196                                                           INDAT0.......14000
c  194 WRITE(K3,195) ITRMAX,RPMAX,RUMAX                                   INDAT0.......14100
c  195 FORMAT(////11X,'I T E R A T I O N   C O N T R O L   D A T A',      INDAT0.......14200
c     1   //11X,I15,5X,'MAXIMUM NUMBER OF ITERATIONS PER TIME STEP',      INDAT0.......14300
c     2   /11X,1PD15.4,5X,'ABSOLUTE CONVERGENCE CRITERION FOR FLOW',      INDAT0.......14400
c     3   ' SOLUTION'/11X,1PD15.4,5X,'ABSOLUTE CONVERGENCE CRITERION',    INDAT0.......14500
c     4   ' FOR TRANSPORT SOLUTION')                                      INDAT0.......14600
c rbw end
  196 CONTINUE                                                           INDAT0.......14700
C                                                                        INDAT0.......14800
C.....INPUT DATASETS 7B & 7C:  MATRIX EQUATION SOLVER CONTROLS FOR       INDAT0.......14900
C        PRESSURE AND TRANSPORT SOLUTIONS                                INDAT0.......15000
      ERRCOD = 'REA-INP-7B'                                              INDAT0.......15400
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT0.......15500
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVP                              INDAT0.......15700
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......15800
         IF (INERR(1).NE.0) then
           IERRORCODE = 43
           return
         end if
c rbw end
      IF ((CSOLVP.NE.SOLWRD(0))) THEN                                    INDAT0.......16200
         ERRCOD = 'REA-INP-7B'                                           INDAT0.......16300
         READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVP,ITRMXP,TOLP               INDAT0.......16400
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......16500
         IF (INERR(1).NE.0) then
           IERRORCODE = 44
           return
         end if
c rbw end
      END IF                                                             INDAT0.......16900
      ERRCOD = 'REA-INP-7C'                                              INDAT0.......17300
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT0.......17400
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVU                              INDAT0.......17600
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT0.......17700
         IF (INERR(1).NE.0) then
           IERRORCODE = 45
           return
         end if
c rbw end
      IF ((CSOLVU.NE.SOLWRD(0))) THEN                                    INDAT0.......18100
         ERRCOD = 'REA-INP-7C'                                           INDAT0.......18200
         READ(INTFIL,*,IOSTAT=INERR(1)) CSOLVU,ITRMXU,TOLU               INDAT0.......18300
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT0.......18400
         IF (INERR(1).NE.0) then
           IERRORCODE = 46
           return
         end if
c rbw end
      END IF                                                             INDAT0.......18800
      KSOLVP = -1                                                        INDAT0.......18900
      KSOLVU = -1                                                        INDAT0.......19000
      DO 250 M=0,NSLVRS-1                                                INDAT0.......19100
         IF (CSOLVP.EQ.SOLWRD(M)) KSOLVP = M                             INDAT0.......19200
         IF (CSOLVU.EQ.SOLWRD(M)) KSOLVU = M                             INDAT0.......19300
  250 CONTINUE                                                           INDAT0.......19400
      IF ((KSOLVP.LT.0).OR.(KSOLVU.LT.0)) THEN                           INDAT0.......19500
c rbw begin
c         ERRCOD = 'INP-7B&C-1'                                           INDAT0.......19600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......19700
           IERRORCODE = 47
           return
c         end if
c rbw end
      ELSE IF ((KSOLVP*KSOLVU.EQ.0).AND.(KSOLVP+KSOLVU.NE.0)) THEN       INDAT0.......19900
c rbw begin
c         ERRCOD = 'INP-7B&C-2'                                           INDAT0.......20000
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......20100
           IERRORCODE = 48
           return
c         end if
c rbw end
      ELSE IF ((KSOLVU.EQ.1).OR.((KSOLVP.EQ.1).AND.(UP.NE.0D0))) THEN    INDAT0.......20300
c rbw begin
c         ERRCOD = 'INP-7B&C-3'                                           INDAT0.......20400
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT0.......20500
           IERRORCODE = 49
           return
c         end if
c rbw end
      END IF                                                             INDAT0.......20700
      IF (KSOLVP.EQ.2) THEN                                              INDAT0.......20800
         ITOLP = 0                                                       INDAT0.......20900
      ELSE                                                               INDAT0.......21000
         ITOLP = 1                                                       INDAT0.......21100
      END IF                                                             INDAT0.......21200
      IF (KSOLVU.EQ.2) THEN                                              INDAT0.......21300
         ITOLU = 0                                                       INDAT0.......21400
      ELSE                                                               INDAT0.......21500
         ITOLU = 1                                                       INDAT0.......21600
      END IF                                                             INDAT0.......21700
      NSAVEP = 10                                                        INDAT0.......21800
      NSAVEU = 10                                                        INDAT0.......21900
C                                                                        INDAT0.......22000
C                                                                        INDAT0.......22100
 1000 RETURN                                                             INDAT0.......22200
      END                                                                INDAT0.......22300
C     SUBROUTINE        I  N  D  A  T  1           SUTRA VERSION 1.1     INDAT1.........100
C                                                                        INDAT1.........200
C *** PURPOSE :                                                          INDAT1.........300
C ***  TO INPUT, OUTPUT, AND ORGANIZE A MAJOR PORTION OF INP FILE        INDAT1.........400
C ***  INPUT DATA (DATASETS 8 THROUGH 15)                                INDAT1.........500
C                                                                        INDAT1.........600
c rbw begin
c      SUBROUTINE INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,         INDAT1.........700
c     1   ATMIN,PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,                       INDAT1.........800
c     2   PERMYZ,PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG, INDAT1.........900
c     3   IOBS)                                                           INDAT1........1000
      SUBROUTINE INDAT1(X,Y,Z,POR,ALMAX,ALMID,ALMIN,ATMAX,ATMID,         INDAT1.........700
     1   ATMIN,PERMXX,PERMXY,PERMXZ,PERMYX,PERMYY,                       INDAT1.........800
     2   PERMYZ,PERMZX,PERMZY,PERMZZ,PANGL1,PANGL2,PANGL3,SOP,NREG,LREG, INDAT1.........900
     3   IOBS,IERRORCODE)                                                           INDAT1........1000
c rbw end
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                INDAT1........1100
      PARAMETER (NCOLMX=9)                                               INDAT1........1200
      CHARACTER*10 ADSMOD,CDUM10                                         INDAT1........1300
      CHARACTER*6 STYPE(2)                                               INDAT1........1500
      CHARACTER K5SYM(7)*1, NCOL(NCOLMX)*1, VARNK5(7)*25                 INDAT1........1600
      CHARACTER K6SYM(7)*2, LCOL(NCOLMX)*2, VARNK6(7)*25                 INDAT1........1700
      CHARACTER*1 CNODAL,CELMNT,CINCID,CVEL,CBUDG,CSCRN,CPAUSE           INDAT1........1800
      CHARACTER*80 ERRCOD,CHERR(10),FNAME(0:7)                           INDAT1........1900
      CHARACTER INTFIL*1000                                              INDAT1........2000
      DIMENSION IOBS(NOBSN)                                              INDAT1........2100
      DIMENSION J5COL(NCOLMX), J6COL(NCOLMX)                             INDAT1........2200
      DIMENSION X(NN),Y(NN),Z(NN),POR(NN),SOP(NN),NREG(NN)               INDAT1........2300
      DIMENSION PERMXX(NE),PERMXY(NE),PERMXZ(NEX),PERMYX(NE),PERMYY(NE), INDAT1........2400
     1   PERMYZ(NEX),PERMZX(NEX),PERMZY(NEX),PERMZZ(NEX),PANGL1(NE),     INDAT1........2500
     2   PANGL2(NEX),PANGL3(NEX),ALMAX(NE),ALMID(NEX),ALMIN(NE),         INDAT1........2600
     3   ATMAX(NE),ATMID(NEX),ATMIN(NE),LREG(NE)                         INDAT1........2700
      DIMENSION INERR(10),RLERR(10)                                      INDAT1........2800
      DIMENSION KTYPE(2)                                                 ! ktype
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  INDAT1........2900
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             INDAT1........3000
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              INDAT1........3100
     1   NSOP,NSOU,NBCN                                                  INDAT1........3200
      COMMON /DIMX/ NBIX,NWI,NWF,NWL,NELT,NNNX,NEX,N48                        INDAT1........3300
      COMMON /FNAMES/ FNAME                                              INDAT1........3500
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        INDAT1........3600
      COMMON /GRAVEC/ GRAVX,GRAVY,GRAVZ                                  INDAT1........3700
      COMMON /ITERAT/ RPM,RPMAX,RUM,RUMAX,ITER,ITRMAX,IPWORS,IUWORS      INDAT1........3800
      COMMON /JCOLS/ NCOLPR, LCOLPR, NCOLS5, NCOLS6, J5COL, J6COL        INDAT1........3900
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     INDAT1........4000
     1   KSCRN,KPAUSE                                                    INDAT1........4100
      COMMON /MODSOR/ ADSMOD                                             INDAT1........4200
      COMMON /OBS/ NOBSN,NTOBS,NOBCYC                                    INDAT1........4300
      COMMON /PARAMS/ COMPFL,COMPMA,DRWDU,CW,CS,RHOS,SIGMAW,SIGMAS,      INDAT1........4400
     1   RHOW0,URHOW0,VISC0,PRODF1,PRODS1,PRODF0,PRODS0,CHI1,CHI2        INDAT1........4500
      COMMON /TIMES/ DELT,TSEC,TMIN,THOUR,TDAY,TWEEK,TMONTH,TYEAR,       INDAT1........4600
     1   TMAX,DELTP,DELTU,DLTPM1,DLTUM1,IT,ITMAX,TSTART                  INDAT1........4700
      DATA STYPE(1)/'ENERGY'/,STYPE(2)/'SOLUTE'/                         INDAT1........4900
      DATA (K5SYM(MM), MM=1,7) /'N', 'X', 'Y', 'Z', 'P', 'U', 'S'/       INDAT1........5000
      DATA (VARNK5(MM), MM=1,7) /'NODE NUMBER',                          INDAT1........5100
     1   'X-COORDINATE', 'Y-COORDINATE', 'Z-COORDINATE',                 INDAT1........5200
     2   'PRESSURE', 'CONCENTRATION/TEMPERATURE', 'SATURATION'/          INDAT1........5300
      DATA (K6SYM(MM), MM=1,7) /'E', 'X', 'Y', 'Z', 'VX', 'VY', 'VZ'/    INDAT1........5400
      DATA (VARNK6(MM), MM=1,7) /'ELEMENT NUMBER',                       INDAT1........5500
     1   'X-COORDINATE OF CENTROID', 'Y-COORDINATE OF CENTROID',         INDAT1........5600
     2   'Z-COORDINATE OF CENTROID', 'X-VELOCITY', 'Y-VELOCITY',         INDAT1........5700
     3   'Z-VELOCITY'/                                                   INDAT1........5800
      SAVE STYPE,K5SYM,VARNK5,K6SYM,VARNK6                               INDAT1........5900
C                                                                        INDAT1........6000
c rbw begin
      INTEGER IERRORCODE
c rbw end
      INSTOP=0                                                           INDAT1........6100
C                                                                        INDAT1........6200
C.....INPUT DATASET 8A:  OUTPUT CONTROLS AND OPTIONS FOR LST FILE        INDAT1........6300
C        AND SCREEN                                                      INDAT1........6400
      ERRCOD = 'REA-INP-8A'                                              INDAT1........6800
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT1........6900
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) NPRINT,CNODAL,CELMNT,CINCID,        INDAT1........7100
     1   CVEL,CBUDG,CSCRN,CPAUSE                                         INDAT1........7200
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1........7300
         IF (INERR(1).NE.0) then
           IERRORCODE = 50
           return
         end if
c rbw end
      IF (CNODAL.EQ.'Y') THEN                                            INDAT1........7700
         KNODAL = +1                                                     INDAT1........7800
      ELSE IF (CNODAL.EQ.'N') THEN                                       INDAT1........7900
         KNODAL = 0                                                      INDAT1........8000
      ELSE                                                               INDAT1........8100
c rbw begin
c         ERRCOD = 'INP-8A-1'                                             INDAT1........8200
c         CHERR(1) = 'CNODAL '                                            INDAT1........8300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1........8400
           IERRORCODE = 51
           return
c rbw end
      END IF                                                             INDAT1........8600
      IF (CELMNT.EQ.'Y') THEN                                            INDAT1........8700
         KELMNT = +1                                                     INDAT1........8800
      ELSE IF (CELMNT.EQ.'N') THEN                                       INDAT1........8900
         KELMNT = 0                                                      INDAT1........9000
      ELSE                                                               INDAT1........9100
c rbw begin
c         ERRCOD = 'INP-8A-2'                                             INDAT1........9200
c         CHERR(1) = 'CELMNT'                                             INDAT1........9300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1........9400
           IERRORCODE = 52
           return
c rbw end
      END IF                                                             INDAT1........9600
      IF (CINCID.EQ.'Y') THEN                                            INDAT1........9700
         KINCID = +1                                                     INDAT1........9800
      ELSE IF (CINCID.EQ.'N') THEN                                       INDAT1........9900
         KINCID = 0                                                      INDAT1.......10000
      ELSE                                                               INDAT1.......10100
c rbw begin
c         ERRCOD = 'INP-8A-3'                                             INDAT1.......10200
c         CHERR(1) = 'CINCID'                                             INDAT1.......10300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......10400
           IERRORCODE = 53
           return
c rbw end
      END IF                                                             INDAT1.......10600
      IF (CVEL.EQ.'Y') THEN                                              INDAT1.......10700
         KVEL = +1                                                       INDAT1.......10800
      ELSE IF (CVEL.EQ.'N') THEN                                         INDAT1.......10900
         KVEL = 0                                                        INDAT1.......11000
      ELSE                                                               INDAT1.......11100
c rbw begin
c         ERRCOD = 'INP-8A-4'                                             INDAT1.......11200
c         CHERR(1) = 'CVEL  '                                             INDAT1.......11300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......11400
           IERRORCODE = 54
           return
c rbw end
      END IF                                                             INDAT1.......11600
      IF (CBUDG.EQ.'Y') THEN                                             INDAT1.......11700
         KBUDG = +1                                                      INDAT1.......11800
      ELSE IF (CBUDG.EQ.'N') THEN                                        INDAT1.......11900
         KBUDG = 0                                                       INDAT1.......12000
      ELSE                                                               INDAT1.......12100
c rbw begin
c         ERRCOD = 'INP-8A-5'                                             INDAT1.......12200
c         CHERR(1) = 'CBUDG '                                             INDAT1.......12300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......12400
           IERRORCODE = 55
           return
c rbw end
      END IF                                                             INDAT1.......12600
      IF (CSCRN.EQ.'Y') THEN                                             INDAT1.......12700
         KSCRN = +1                                                      INDAT1.......12800
      ELSE IF (CSCRN.EQ.'N') THEN                                        INDAT1.......12900
         KSCRN = 0                                                       INDAT1.......13000
      ELSE                                                               INDAT1.......13100
c rbw begin
c         ERRCOD = 'INP-8A-6'                                             INDAT1.......13200
c         CHERR(1) = 'CSCRN '                                             INDAT1.......13300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......13400
           IERRORCODE = 56
           return
c rbw end
      END IF                                                             INDAT1.......13600
      IF (CPAUSE.EQ.'Y') THEN                                            INDAT1.......13700
         KPAUSE = +1                                                     INDAT1.......13800
      ELSE IF (CPAUSE.EQ.'N') THEN                                       INDAT1.......13900
         KPAUSE = 0                                                      INDAT1.......14000
      ELSE                                                               INDAT1.......14100
c rbw begin
c         ERRCOD = 'INP-8A-7'                                             INDAT1.......14200
c         CHERR(1) = 'CPAUSE'                                             INDAT1.......14300
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......14400
           IERRORCODE = 57
           return
c rbw end
      END IF                                                             INDAT1.......14600
C                                                                        INDAT1.......14700
c      WRITE(K3,72) NPRINT                                                INDAT1.......14800
c   72 FORMAT(////11X,'O U T P U T   C O N T R O L S   A N D   ',         INDAT1.......14900
c     1   'O P T I O N S'//13X,'.LST FILE'/13X,'---------'                INDAT1.......15000
c     2   //13X,I6,5X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)')             INDAT1.......15100
c      IF(KNODAL.EQ.+1) WRITE(K3,74)                                      INDAT1.......15200
c      IF(KNODAL.EQ.0) WRITE(K3,75)                                       INDAT1.......15300
c   74 FORMAT(/13X,'- PRINT NODE COORDINATES, THICKNESSES AND',           INDAT1.......15400
c     1   ' POROSITIES')                                                  INDAT1.......15500
c   75 FORMAT(/13X,'- CANCEL PRINT OF NODE COORDINATES, THICKNESSES AND', INDAT1.......15600
c     1   ' POROSITIES')                                                  INDAT1.......15700
c      IF(KELMNT.EQ.+1) WRITE(K3,76)                                      INDAT1.......15800
c      IF(KELMNT.EQ.0) WRITE(K3,77)                                       INDAT1.......15900
c   76 FORMAT(13X,'- PRINT ELEMENT PERMEABILITIES AND DISPERSIVITIES')    INDAT1.......16000
c   77 FORMAT(13X,'- CANCEL PRINT OF ELEMENT PERMEABILITIES AND ',        INDAT1.......16100
c     1   'DISPERSIVITIES')                                               INDAT1.......16200
c      IF(KINCID.EQ.+1) WRITE(K3,78)                                      INDAT1.......16300
c      IF(KINCID.EQ.0) WRITE(K3,79)                                       INDAT1.......16400
c   78 FORMAT(13X,'- PRINT NODE INCIDENCES IN EACH ELEMENT')              INDAT1.......16500
c   79 FORMAT(13X,'- CANCEL PRINT OF NODE INCIDENCES IN EACH ELEMENT')    INDAT1.......16600
      IME=2                                                              INDAT1.......16700
      IF(ME.EQ.+1) IME=1                                                 INDAT1.......16800
c      IF(KVEL.EQ.+1) WRITE(K3,84)                                        INDAT1.......16900
c      IF(KVEL.EQ.0) WRITE(K3,85)                                         INDAT1.......17000
c   84 FORMAT(/13X,'- CALCULATE AND PRINT VELOCITIES AT ELEMENT ',        INDAT1.......17100
c     1   'CENTROIDS ON EACH TIME STEP WITH OUTPUT')                      INDAT1.......17200
c   85 FORMAT(/13X,'- CANCEL PRINT OF VELOCITIES')                        INDAT1.......17300
c      IF(KBUDG.EQ.+1) WRITE(K3,86) STYPE(IME)                            INDAT1.......17400
c      IF(KBUDG.EQ.0) WRITE(K3,87)                                        INDAT1.......17500
c   86 FORMAT(/13X,'- CALCULATE AND PRINT FLUID AND ',A6,' BUDGETS ',     INDAT1.......17600
c     1   'ON EACH TIME STEP WITH OUTPUT')                                INDAT1.......17700
c   87 FORMAT(/13X,'- CANCEL PRINT OF BUDGETS')                           INDAT1.......17800
C                                                                        INDAT1.......17900
C.....INPUT DATASET 8B:  OUTPUT CONTROLS AND OPTIONS FOR NOD FILE        INDAT1.......18000
      ERRCOD = 'REA-INP-8B'                                              INDAT1.......18400
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT1.......18500
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) NCOLPR                              INDAT1.......18700
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......18800
         IF (INERR(1).NE.0) then
           IERRORCODE = 58
           return
         end if
c rbw end
      DO 140 M=1,NCOLMX                                                  INDAT1.......19200
         READ(INTFIL,*,IOSTAT=INERR(1)) NCOLPR, (NCOL(MM), MM=1,M)       INDAT1.......19300
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......19400
         IF (INERR(1).NE.0) then
           IERRORCODE = 59
           return
         end if
c rbw end
         IF (NCOL(M).EQ.'-') THEN                                        INDAT1.......19800
            NCOLS5 = M - 1                                               INDAT1.......19900
            GOTO 142                                                     INDAT1.......20000
         END IF                                                          INDAT1.......20100
  140 CONTINUE                                                           INDAT1.......20200
      NCOLS5 = NCOLMX                                                    INDAT1.......20300
  142 CONTINUE                                                           INDAT1.......20400
c      WRITE(K3,144) NCOLPR                                               INDAT1.......20500
c  144 FORMAT (//13X,'.NOD FILE'/13X,'---------'                          INDAT1.......20600
c     1   //13X,I6,5X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)'/)            INDAT1.......20700
      DO 148 M=1,NCOLS5                                                  INDAT1.......20800
         DO 146 MM=1,7                                                   INDAT1.......20900
            IF (NCOL(M).EQ.K5SYM(MM)) THEN                               INDAT1.......21000
               IF ((MM.EQ.1).AND.(M.NE.1)) THEN                          INDAT1.......21100
c rbw begin
c                  ERRCOD = 'INP-8B-1'                                    INDAT1.......21200
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......21300
                  IERRORCODE = 60
                  return
c rbw end
               END IF                                                    INDAT1.......21500
               IF ((MM.EQ.4).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......21600 ! ktype
c rbw begin
c                  ERRCOD = 'INP-8B-2'                                    INDAT1.......21700
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......21800
                  IERRORCODE = 61
                  return
c rbw end
               END IF                                                    INDAT1.......22000
               J5COL(M) = MM                                             INDAT1.......22100
               GOTO 148                                                  INDAT1.......22200
            END IF                                                       INDAT1.......22300
  146    CONTINUE                                                        INDAT1.......22400
c rbw begin
c         ERRCOD = 'INP-8B-3'                                             INDAT1.......22500
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......22600
                  IERRORCODE = 62
                  return
c rbw end
  148 CONTINUE                                                           INDAT1.......22800
c      WRITE(K3,150) (M,VARNK5(J5COL(M)),M=1,NCOLS5)                      INDAT1.......22900
c  150 FORMAT (13X,'COLUMN ',I1,':',2X,A)                                 INDAT1.......23000
C                                                                        INDAT1.......23100
C.....INPUT DATASET 8C:  OUTPUT CONTROLS AND OPTIONS FOR ELE FILE        INDAT1.......23200
      ERRCOD = 'REA-INP-8C'                                              INDAT1.......23600
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......23700
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) LCOLPR                              INDAT1.......23900
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......24000
         IF (INERR(1).NE.0) then
           IERRORCODE = 63
           return
         end if
c rbw end
      DO 160 M=1,NCOLMX                                                  INDAT1.......24400
         READ(INTFIL,*,IOSTAT=INERR(1)) LCOLPR, (LCOL(MM), MM=1,M)       INDAT1.......24500
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......24600
         IF (INERR(1).NE.0) then
           IERRORCODE = 64
           return
         end if
c rbw end
         IF (LCOL(M).EQ.'-') THEN                                        INDAT1.......25000
            NCOLS6 = M - 1                                               INDAT1.......25100
            GOTO 162                                                     INDAT1.......25200
         END IF                                                          INDAT1.......25300
  160 CONTINUE                                                           INDAT1.......25400
      NCOLS6 = NCOLMX                                                    INDAT1.......25500
  162 CONTINUE                                                           INDAT1.......25600
c      WRITE(K3,164) LCOLPR                                               INDAT1.......25700
c  164 FORMAT (//13X,'.ELE FILE'/13X,'---------'                          INDAT1.......25800
c     1   //13X,I6,5X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)'/)            INDAT1.......25900
      DO 168 M=1,NCOLS6                                                  INDAT1.......26000
         DO 166 MM=1,7                                                   INDAT1.......26100
            IF (LCOL(M).EQ.K6SYM(MM)) THEN                               INDAT1.......26200
               IF ((MM.EQ.1).AND.(M.NE.1)) THEN                          INDAT1.......26300
c rbw begin
c                  ERRCOD = 'INP-8C-1'                                    INDAT1.......26400
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......26500
                  IERRORCODE = 65
                  return
c rbw end
               END IF                                                    INDAT1.......26700
               IF ((MM.EQ.4).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......26800 ! ktype
c rbw begin
c                  ERRCOD = 'INP-8C-2'                                    INDAT1.......26900
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......27000
                  IERRORCODE = 66
                  return
c rbw end
               END IF                                                    INDAT1.......27200
               IF ((MM.EQ.7).AND.(KTYPE(1).EQ.2)) THEN                   INDAT1.......27300 ! ktype
c rbw begin
c                  ERRCOD = 'INP-8C-4'                                    INDAT1.......27400
c                  CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)               INDAT1.......27500
                  IERRORCODE = 67
                  return
c rbw end
               END IF                                                    INDAT1.......27700
               J6COL(M) = MM                                             INDAT1.......27800
               GOTO 168                                                  INDAT1.......27900
            END IF                                                       INDAT1.......28000
  166    CONTINUE                                                        INDAT1.......28100
c rbw begin
c         ERRCOD = 'INP-8C-3'                                             INDAT1.......28200
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......28300
                  IERRORCODE = 68
                  return
c rbw end
  168 CONTINUE                                                           INDAT1.......28500
c      WRITE(K3,170) (M,VARNK6(J6COL(M)),M=1,NCOLS6)                      INDAT1.......28600
c  170 FORMAT (13X,'COLUMN ',I1,':',2X,A)                                 INDAT1.......28700
C                                                                        INDAT1.......28800
C.....INPUT DATASET 8D:  OUTPUT CONTROLS AND OPTIONS FOR OBS FILE        INDAT1.......28900
      NOBCYC = ITMAX + 1                                                 INDAT1.......29000
      IF (NOBSN-1.EQ.0) GOTO 199                                         INDAT1.......29100
C.....NOBS IS ACTUAL NUMBER OF OBSERVATION NODES                         INDAT1.......29500
C.....NTOBS IS MAXIMUM NUMBER OF TIME STEPS WITH OBSERVATIONS            INDAT1.......29600
      NOBS=NOBSN-1                                                       INDAT1.......29700
      ERRCOD = 'REA-INP-8D'                                              INDAT1.......29800
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT1.......29850
      if (IERRORCODE.ne.0) return
      BACKSPACE(K1)                                                      INDAT1.......29855
c rbw begin
      READ(K1,*,IOSTAT=INERR(1)) NOBCYC, (IOBS(JJ), JJ=1,NOBSN)          INDAT1.......29900
         IF (INERR(1).NE.0) then
           IERRORCODE = 69
           return
         end if
c rbw end
      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......30000
      NTOBS = 0                                                          INDAT1.......30100
      IF (NOBS.EQ.0) GOTO 177                                            INDAT1.......30110
      TS=TSTART                                                          INDAT1.......30120
      JT=0                                                               INDAT1.......30130
      IF (ISSTRA.NE.1) THEN                                              INDAT1.......30140
         KT = 1                                                          INDAT1.......30150
      ELSE                                                               INDAT1.......30160
         KT = 0                                                          INDAT1.......30170
      END IF                                                             INDAT1.......30180
      DELTK=DELT                                                         INDAT1.......30190
  175 CONTINUE                                                           INDAT1.......30200
         JT=JT+1                                                         INDAT1.......30210
         IF (MOD(JT,ITCYC).EQ.0 .AND. JT.GT.1) DELTK=DELTK*DTMULT        INDAT1.......30220
         IF (DELTK.GT.DTMAX) DELTK=DTMAX                                 INDAT1.......30230
         TS=TS+DELTK                                                     INDAT1.......30240
         IF (MOD(JT,NOBCYC).EQ.0 .OR.                                    INDAT1.......30250
     1      ((JT.EQ.1).AND.((ISSTRA.NE.0).OR.(NOBCYC.GT.0))))            INDAT1.......30260
     2      KT = KT + 1                                                  INDAT1.......30270
      IF(JT.LT.ITMAX .AND. TS.LT.TMAX) GOTO 175                          INDAT1.......30280
      JTMAX = JT                                                         INDAT1.......30290
      IF(JTMAX.GT.1 .AND. MOD(JT,NOBCYC).NE.0) KT = KT + 1               INDAT1.......30300
      NTOBS = KT                                                         INDAT1.......30310
  177 CONTINUE                                                           INDAT1.......30320
c      WRITE(K3,180) NOBCYC                                               INDAT1.......30400
c  180 FORMAT (//13X,'.OBS FILE'/13X,'---------'                          INDAT1.......30500
c     1   //13X,I6,5X,'PRINTED OUTPUT CYCLE (IN TIME STEPS)'/)            INDAT1.......30600
      JSTOP=0                                                            INDAT1.......30700
c      WRITE(K3,182)                                                      INDAT1.......30800
c  182 FORMAT(////11X,'O B S E R V A T I O N   N O D E S')                INDAT1.......30900
c      WRITE(K3,184) NOBCYC, NTOBS                                        INDAT1.......31000
c  184 FORMAT(//13X,'OBSERVATIONS WILL BE MADE EVERY ',I5,' TIME STEPS,'  INDAT1.......31100
c     1   /13X,'AS WELL AS ON THE FIRST AND LAST TIME STEP,'              INDAT1.......31200
c     2   /13X,'FOR A TOTAL OF ',I5,' TIME STEPS.')                       INDAT1.......31300
c      WRITE(K3,186)                                                      INDAT1.......31400
c  186 FORMAT(//13X,'**** NODES AT WHICH OBSERVATIONS WILL BE MADE',      INDAT1.......31500
c     1   ' ****'//)                                                      INDAT1.......31600
      IF (IOBS(NOBSN).NE.0) THEN                                         INDAT1.......31700
c rbw begin
c         ERRCOD = 'INP-8D-1'                                             INDAT1.......31800
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......31900
           IERRORCODE = 70
           return
c         end if
c rbw end
      END IF                                                             INDAT1.......32100
      DO 188 JJ=1,NOBS                                                   INDAT1.......32200
         IF (IOBS(JJ).LE.0) THEN                                         INDAT1.......32300
c rbw begin
c            ERRCOD = 'INP-8D-2'                                          INDAT1.......32400
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     INDAT1.......32500
           IERRORCODE = 71
           return
c         end if
c rbw end
         END IF                                                          INDAT1.......32700
  188 CONTINUE                                                           INDAT1.......32800
c      WRITE(K3,190) (IOBS(JJ),JJ=1,NOBS)                                 INDAT1.......32900
c  190 FORMAT((13X,10(1X,I9)))                                            INDAT1.......33000
  199 CONTINUE                                                           INDAT1.......33100
C                                                                        INDAT1.......33200
C.....INPUT DATASET 9:  FLUID PROPERTIES                                 INDAT1.......33300
      ERRCOD = 'REA-INP-9'                                               INDAT1.......33700
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......33800
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) COMPFL,CW,SIGMAW,RHOW0,URHOW0,      INDAT1.......34000
     1   DRWDU,VISC0                                                     INDAT1.......34100
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......34200
         IF (INERR(1).NE.0) then
           IERRORCODE = 72
           return
         end if
c rbw end
C.....INPUT DATASET 10:  SOLID MATRIX PROPERTIES                         INDAT1.......34600
      ERRCOD = 'REA-INP-10'                                              INDAT1.......35000
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......35100
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) COMPMA,CS,SIGMAS,RHOS               INDAT1.......35300
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......35400
         IF (INERR(1).NE.0) then
           IERRORCODE = 73
           return
         end if
c rbw begin
c rbw begin
c      IF(ME.EQ.+1)                                                       INDAT1.......35800
c     1  WRITE(K3,210) COMPFL,COMPMA,CW,CS,VISC0,RHOS,RHOW0,DRWDU,URHOW0, INDAT1.......35900
c     2                SIGMAW,SIGMAS                                      INDAT1.......36000
c  210 FORMAT(1H1////11X,'C O N S T A N T   P R O P E R T I E S   O F',   INDAT1.......36100
c     1   '   F L U I D   A N D   S O L I D   M A T R I X'                INDAT1.......36200
c     2   //11X,1PD15.4,5X,'COMPRESSIBILITY OF FLUID'/11X,1PD15.4,5X,     INDAT1.......36300
c     3   'COMPRESSIBILITY OF POROUS MATRIX'//11X,1PD15.4,5X,             INDAT1.......36400
c     4   'SPECIFIC HEAT CAPACITY OF FLUID',/11X,1PD15.4,5X,              INDAT1.......36500
c     5   'SPECIFIC HEAT CAPACITY OF SOLID GRAIN'//13X,'FLUID VISCOSITY', INDAT1.......36600
c     6   ' IS CALCULATED BY SUTRA AS A FUNCTION OF TEMPERATURE IN ',     INDAT1.......36700
c     7   'UNITS OF {kg/(m*s)}'//11X,1PD15.4,5X,'VISC0, CONVERSION ',     INDAT1.......36800
c     8   'FACTOR FOR VISCOSITY UNITS,  {desired units} = VISC0*',        INDAT1.......36900
c     9   '{kg/(m*s)}'//11X,1PD15.4,5X,'DENSITY OF A SOLID GRAIN'         INDAT1.......37000
c     *   //13X,'FLUID DENSITY, RHOW'/13X,'CALCULATED BY ',               INDAT1.......37100
c     1   'SUTRA IN TERMS OF TEMPERATURE, U, AS:'/13X,'RHOW = RHOW0 + ',  INDAT1.......37200
c     2   'DRWDU*(U-URHOW0)'//11X,1PD15.4,5X,'FLUID BASE DENSITY, RHOW0'  INDAT1.......37300
c     3   /11X,1PD15.4,5X,'COEFFICIENT OF DENSITY CHANGE WITH ',          INDAT1.......37400
c     4   'TEMPERATURE, DRWDU'/11X,1PD15.4,5X,'TEMPERATURE, URHOW0, ',    INDAT1.......37500
c     5   'AT WHICH FLUID DENSITY IS AT BASE VALUE, RHOW0'                INDAT1.......37600
c     6   //11X,1PD15.4,5X,'THERMAL CONDUCTIVITY OF FLUID'                INDAT1.......37700
c     7   /11X,1PD15.4,5X,'THERMAL CONDUCTIVITY OF SOLID GRAIN')          INDAT1.......37800
c      IF(ME.EQ.-1)                                                       INDAT1.......37900
c     1  WRITE(K3,220) COMPFL,COMPMA,VISC0,RHOS,RHOW0,DRWDU,URHOW0,SIGMAW INDAT1.......38000
c  220 FORMAT(1H1////11X,'C O N S T A N T   P R O P E R T I E S   O F',   INDAT1.......38100
c     1   '   F L U I D   A N D   S O L I D   M A T R I X'                INDAT1.......38200
c     2   //11X,1PD15.4,5X,'COMPRESSIBILITY OF FLUID'/11X,1PD15.4,5X,     INDAT1.......38300
c     3   'COMPRESSIBILITY OF POROUS MATRIX'                              INDAT1.......38400
c     4   //11X,1PD15.4,5X,'FLUID VISCOSITY'                              INDAT1.......38500
c     4   //11X,1PD15.4,5X,'DENSITY OF A SOLID GRAIN'                     INDAT1.......38600
c     5   //13X,'FLUID DENSITY, RHOW'/13X,'CALCULATED BY ',               INDAT1.......38700
c     6   'SUTRA IN TERMS OF SOLUTE CONCENTRATION, U, AS:',               INDAT1.......38800
c     7   /13X,'RHOW = RHOW0 + DRWDU*(U-URHOW0)'                          INDAT1.......38900
c     8   //11X,1PD15.4,5X,'FLUID BASE DENSITY, RHOW0'                    INDAT1.......39000
c     9   /11X,1PD15.4,5X,'COEFFICIENT OF DENSITY CHANGE WITH ',          INDAT1.......39100
c     *   'SOLUTE CONCENTRATION, DRWDU'                                   INDAT1.......39200
c     1   /11X,1PD15.4,5X,'SOLUTE CONCENTRATION, URHOW0, ',               INDAT1.......39300
c     4   'AT WHICH FLUID DENSITY IS AT BASE VALUE, RHOW0'                INDAT1.......39400
c     5   //11X,1PD15.4,5X,'MOLECULAR DIFFUSIVITY OF SOLUTE IN FLUID')    INDAT1.......39500
c rbw begin
C                                                                        INDAT1.......39600
C.....INPUT DATASET 11:  ADSORPTION PARAMETERS                           INDAT1.......39700
      ERRCOD = 'REA-INP-11'                                              INDAT1.......40100
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......40200
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) ADSMOD                              INDAT1.......40400
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......40500
         IF (INERR(1).NE.0) then
           IERRORCODE = 74
           return
         end if
c rbw end
      IF (ADSMOD.NE.'NONE      ') THEN                                   INDAT1.......40900
         READ(INTFIL,*,IOSTAT=INERR(1)) ADSMOD,CHI1,CHI2                 INDAT1.......41000
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     INDAT1.......41100
         IF (INERR(1).NE.0) then
           IERRORCODE = 75
           return
         end if
c rbw end
      END IF                                                             INDAT1.......41500
      IF(ME.EQ.+1) GOTO 248                                              INDAT1.......41600
c      IF(ADSMOD.EQ.'NONE      ') GOTO 234                                INDAT1.......41700
c      WRITE(K3,232) ADSMOD                                               INDAT1.......41800
c  232 FORMAT(////11X,'A D S O R P T I O N   P A R A M E T E R S'         INDAT1.......41900
c     1   //16X,A10,5X,'EQUILIBRIUM SORPTION ISOTHERM')                   INDAT1.......42000
c      GOTO 236                                                           INDAT1.......42100
c  234 WRITE(K3,235)                                                      INDAT1.......42200
c  235 FORMAT(////11X,'A D S O R P T I O N   P A R A M E T E R S'         INDAT1.......42300
c     1   //16X,'NON-SORBING SOLUTE')                                     INDAT1.......42400
  236 IF((ADSMOD.EQ.'NONE ').OR.(ADSMOD.EQ.'LINEAR    ').OR.             INDAT1.......42500
     1   (ADSMOD.EQ.'FREUNDLICH').OR.(ADSMOD.EQ.'LANGMUIR  ')) GOTO 238  INDAT1.......42600
c rbw begin
c      ERRCOD = 'INP-11-1'                                                INDAT1.......42700
c      CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                           INDAT1.......42800
           IERRORCODE = 76
           return
c rbw end
  238 continue
c  238 IF(ADSMOD.EQ.'LINEAR    ') WRITE(K3,242) CHI1                      INDAT1.......43000
c  242 FORMAT(11X,1PD15.4,5X,'LINEAR DISTRIBUTION COEFFICIENT')           INDAT1.......43100
c      IF(ADSMOD.EQ.'FREUNDLICH') WRITE(K3,244) CHI1,CHI2                 INDAT1.......43200
c  244 FORMAT(11X,1PD15.4,5X,'FREUNDLICH DISTRIBUTION COEFFICIENT'        INDAT1.......43300
c     1   /11X,1PD15.4,5X,'SECOND FREUNDLICH COEFFICIENT')                INDAT1.......43400
      IF(ADSMOD.EQ.'FREUNDLICH'.AND.CHI2.LE.0.D0) THEN                   INDAT1.......43500
c rbw begin
c         ERRCOD = 'INP-11-2'                                             INDAT1.......43600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......43700
           IERRORCODE = 77
           return
c rbw end
      ENDIF                                                              INDAT1.......43900
c      IF(ADSMOD.EQ.'LANGMUIR  ') WRITE(K3,246) CHI1,CHI2                 INDAT1.......44000
c  246 FORMAT(11X,1PD15.4,5X,'LANGMUIR DISTRIBUTION COEFFICIENT'          INDAT1.......44100
c     1   /11X,1PD15.4,5X,'SECOND LANGMUIR COEFFICIENT')                  INDAT1.......44200
C                                                                        INDAT1.......44300
C.....INPUT DATASET 12:  PRODUCTION OF ENERGY OR SOLUTE MASS             INDAT1.......44400
  248 ERRCOD = 'REA-INP-12'                                              INDAT1.......44500
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......44900
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) PRODF0,PRODS0,PRODF1,PRODS1         INDAT1.......45100
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......45200
         IF (INERR(1).NE.0) then
           IERRORCODE = 78
           return
         end if
c rbw end
c      IF(ME.EQ.-1) WRITE(K3,250) PRODF0,PRODS0,PRODF1,PRODS1             INDAT1.......45600
c  250 FORMAT(////11X,'P R O D U C T I O N   A N D   D E C A Y   O F   ', INDAT1.......45700
c     1   'S P E C I E S   M A S S'//13X,'PRODUCTION RATE (+)'/13X,       INDAT1.......45800
c     2   'DECAY RATE (-)'//11X,1PD15.4,5X,'ZERO-ORDER RATE OF SOLUTE ',  INDAT1.......45900
c     3   'MASS PRODUCTION/DECAY IN FLUID'/11X,1PD15.4,5X,                INDAT1.......46000
c     4   'ZERO-ORDER RATE OF ADSORBATE MASS PRODUCTION/DECAY IN ',       INDAT1.......46100
c     5   'IMMOBILE PHASE'/11X,1PD15.4,5X,'FIRST-ORDER RATE OF SOLUTE ',  INDAT1.......46200
c     3   'MASS PRODUCTION/DECAY IN FLUID'/11X,1PD15.4,5X,                INDAT1.......46300
c     4   'FIRST-ORDER RATE OF ADSORBATE MASS PRODUCTION/DECAY IN ',      INDAT1.......46400
c     5   'IMMOBILE PHASE')                                               INDAT1.......46500
c      IF(ME.EQ.+1) WRITE(K3,260) PRODF0,PRODS0                           INDAT1.......46600
c  260 FORMAT(////11X,'P R O D U C T I O N   A N D   L O S S   O F   ',   INDAT1.......46700
c     1   'E N E R G Y'//13X,'PRODUCTION RATE (+)'/13X,                   INDAT1.......46800
c     2   'LOSS RATE (-)'//11X,1PD15.4,5X,'ZERO-ORDER RATE OF ENERGY ',   INDAT1.......46900
c     3   'PRODUCTION/LOSS IN FLUID'/11X,1PD15.4,5X,                      INDAT1.......47000
c     4   'ZERO-ORDER RATE OF ENERGY PRODUCTION/LOSS IN ',                INDAT1.......47100
c     5   'SOLID GRAINS')                                                 INDAT1.......47200
C.....SET PARAMETER SWITCHES FOR EITHER ENERGY OR SOLUTE TRANSPORT       INDAT1.......47300
      IF(ME) 272,272,274                                                 INDAT1.......47400
C     FOR SOLUTE TRANSPORT:                                              INDAT1.......47500
  272 CS=0.0D0                                                           INDAT1.......47600
      CW=1.D00                                                           INDAT1.......47700
      SIGMAS=0.0D0                                                       INDAT1.......47800
      GOTO 278                                                           INDAT1.......47900
C     FOR ENERGY TRANSPORT:                                              INDAT1.......48000
  274 ADSMOD='NONE      '                                                INDAT1.......48100
      CHI1=0.0D0                                                         INDAT1.......48200
      CHI2=0.0D0                                                         INDAT1.......48300
      PRODF1=0.0D0                                                       INDAT1.......48400
      PRODS1=0.0D0                                                       INDAT1.......48500
  278 CONTINUE                                                           INDAT1.......48600
C                                                                        INDAT1.......48700
      IF (KTYPE(1).EQ.3) THEN                                            INDAT1.......48800 ! ktype
C.....READ 3D INPUT FROM DATASETS 13 - 15.                               INDAT1.......48900
C                                                                        INDAT1.......49000
C.....INPUT DATASET 13:  ORIENTATION OF COORDINATES TO GRAVITY           INDAT1.......49100
      ERRCOD = 'REA-INP-13'                                              INDAT1.......49500
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......49600
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) GRAVX,GRAVY,GRAVZ                   INDAT1.......49800
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......49900
         IF (INERR(1).NE.0) then
           IERRORCODE = 79
           return
         end if
c rbw end
c      WRITE(K3,320) GRAVX,GRAVY,GRAVZ                                    INDAT1.......50300
c  320 FORMAT(////11X,'C O O R D I N A T E   O R I E N T A T I O N   ',   INDAT1.......50400
c     1   'T O   G R A V I T Y'//13X,'COMPONENT OF GRAVITY VECTOR',       INDAT1.......50500
c     2   /13X,'IN +X DIRECTION, GRAVX'/11X,1PD15.4,5X,                   INDAT1.......50600
c     3   'GRAVX = -GRAV * D(ELEVATION)/DX'//13X,'COMPONENT OF GRAVITY',  INDAT1.......50700
c     4   ' VECTOR'/13X,'IN +Y DIRECTION, GRAVY'/11X,1PD15.4,5X,          INDAT1.......50800
c     5   'GRAVY = -GRAV * D(ELEVATION)/DY'//13X,'COMPONENT OF GRAVITY',  INDAT1.......50900
c     6   ' VECTOR'/13X,'IN +Z DIRECTION, GRAVZ'/11X,1PD15.4,5X,          INDAT1.......51000
c     7   'GRAVZ = -GRAV * D(ELEVATION)/DZ')                              INDAT1.......51100
C                                                                        INDAT1.......51200
C.....INPUT DATASETS 14A & 14B:  NODEWISE DATA                           INDAT1.......51300
      ERRCOD = 'REA-INP-14A'                                             INDAT1.......51700
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......51800
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,SCALX,SCALY,SCALZ,PORFAC     INDAT1.......52000
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......52100
         IF (INERR(1).NE.0) then
           IERRORCODE = 80
           return
         end if
c rbw end
      IF (CDUM10.NE.'NODE      ') THEN                                   INDAT1.......52500
c rbw begin
c         ERRCOD = 'INP-14A-1'                                            INDAT1.......52600
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......52700
           IERRORCODE = 81
           return
c rbw end
      END IF                                                             INDAT1.......52900
      NRTEST=1                                                           INDAT1.......53000
      DO 450 I=1,NN                                                      INDAT1.......53400
      ERRCOD = 'REA-INP-14B'                                             INDAT1.......53500
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......53600
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) II,NREG(II),X(II),Y(II),Z(II),      INDAT1.......53800
     1   POR(II)                                                         INDAT1.......53900
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......54000
         IF (INERR(1).NE.0) then
           IERRORCODE = 82
           return
         end if
c rbw end
      X(II)=X(II)*SCALX                                                  INDAT1.......54400
      Y(II)=Y(II)*SCALY                                                  INDAT1.......54500
      Z(II)=Z(II)*SCALZ                                                  INDAT1.......54600
      POR(II)=POR(II)*PORFAC                                             INDAT1.......54700
      IF(I.GT.1.AND.NREG(II).NE.NROLD) NRTEST=NRTEST+1                   INDAT1.......54800
      NROLD=NREG(II)                                                     INDAT1.......54900
C.....SET SPECIFIC PRESSURE STORATIVITY, SOP.                            INDAT1.......55000
  450 SOP(II)=(1.D0-POR(II))*COMPMA+POR(II)*COMPFL                       INDAT1.......55100
c  460 IF(KNODAL.EQ.0) WRITE(K3,461) SCALX,SCALY,SCALZ,PORFAC             INDAT1.......55200
c  461 FORMAT(1H1////11X,'N O D E   I N F O R M A T I O N'//16X,          INDAT1.......55300
c     1   'PRINTOUT OF NODE COORDINATES AND POROSITIES ',                 INDAT1.......55400
c     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PD15.4,5X,'X-SCALE'/   INDAT1.......55500
c     3   33X,1PD15.4,5X,'Y-SCALE'/33X,1PD15.4,5X,'Z-SCALE'/              INDAT1.......55600
c     4   33X,1PD15.4,5X,'POROSITY FACTOR')                               INDAT1.......55700
c      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.NE.1) WRITE(K3,463)      INDAT1.......55800
c      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.EQ.1) WRITE(K3,465)      INDAT1.......55900
c  463 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......56000
c     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......56100
c  465 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......56200
c     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......56300
c      IF(KNODAL.EQ.+1.AND.IUNSAT.NE.1)                                   INDAT1.......56400
c     1   WRITE(K3,470)(I,X(I),Y(I),Z(I),POR(I),I=1,NN)                   INDAT1.......56500
c  470 FORMAT(1H1//11X,'N O D E   I N F O R M A T I O N'//14X,            INDAT1.......56600
c     1   'NODE',7X,'X',16X,'Y',16X,'Z',15X,'POROSITY'//                  INDAT1.......56700
c     2   (9X,I9,3(3X,1PD14.5),6X,0PF8.5))                                INDAT1.......56800
c      IF(KNODAL.EQ.+1.AND.IUNSAT.EQ.1)                                   INDAT1.......56900
c     1   WRITE(K3,480)(I,NREG(I),X(I),Y(I),Z(I),POR(I),I=1,NN)           INDAT1.......57000
c  480 FORMAT(1H1//11X,'N O D E   I N F O R M A T I O N'//14X,'NODE',3X,  INDAT1.......57100
c     1   'REGION',7X,'X',16X,'Y',16X,'Z',15X,'POROSITY'//                INDAT1.......57200
c     2   (9X,I9,3X,I6,3(3X,1PD14.5),6X,0PF8.5))                          INDAT1.......57300
C                                                                        INDAT1.......57400
C.....INPUT DATASETS 15A & 15B:  ELEMENTWISE DATA                        INDAT1.......57500
      ERRCOD = 'REA-INP-15A'                                             INDAT1.......57900
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......58000
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,PMAXFA,PMIDFA,PMINFA,        INDAT1.......58200
     1   ANG1FA,ANG2FA,ANG3FA,ALMAXF,ALMIDF,ALMINF,                      INDAT1.......58300
     1   ATMXF,ATMDF,ATMNF                                               INDAT1.......58400
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......58500
         IF (INERR(1).NE.0) then
           IERRORCODE = 83
           return
         end if
c rbw end
      IF (CDUM10.NE.'ELEMENT   ') THEN                                   INDAT1.......58900
c rbw begin
c         ERRCOD = 'INP-15A-1'                                            INDAT1.......59000
c         CHERR(1) = '3D'                                                 INDAT1.......59100
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......59200
           IERRORCODE = 84
           return
c rbw end
      END IF                                                             INDAT1.......59400
c      IF(KELMNT.EQ.+1) THEN                                              INDAT1.......59500
c         IF (IUNSAT.EQ.1) THEN                                           INDAT1.......59600
c            WRITE(K3,500)                                                INDAT1.......59700
c  500       FORMAT(1H1//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......59800
c     1         11X,'ELEMENT',3X,'REGION',4X,                             INDAT1.......59900
c     2         'MAXIMUM',9X,'MIDDLE',10X,'MINIMUM',18X,                  INDAT1.......60000
c     2         'ANGLE1',9X,'ANGLE2',9X,'ANGLE3',4X,                      INDAT1.......60100
c     2         'LONGITUDINAL',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,    INDAT1.......60200
c     2         'TRANSVERSE',5X,'TRANSVERSE',5X,'TRANSVERSE'/             INDAT1.......60300
c     3         31X,'PERMEABILITY',4X,'PERMEABILITY',4X,'PERMEABILITY',   INDAT1.......60400
c     4         8X,'(IN DEGREES)',3X,'(IN DEGREES)',3X,'(IN DEGREES)',3X, INDAT1.......60500
c     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY',3X,    INDAT1.......60600
c     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY'/       INDAT1.......60700
c     4         128X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM',  INDAT1.......60800
c     4         3X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM'/    INDAT1.......60900
c     1         128X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION',  INDAT1.......61000
c     2         3X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)   INDAT1.......61100
c         ELSE                                                            INDAT1.......61200
c            WRITE(K3,501)                                                INDAT1.......61300
c  501       FORMAT(1H1//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......61400
c     1         11X,'ELEMENT',4X,                                         INDAT1.......61500
c     2         'MAXIMUM',9X,'MIDDLE',10X,'MINIMUM',18X,                  INDAT1.......61600
c     2         'ANGLE1',9X,'ANGLE2',9X,'ANGLE3',4X,                      INDAT1.......61700
c     2         'LONGITUDINAL',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,    INDAT1.......61800
c     2         'TRANSVERSE',5X,'TRANSVERSE',5X,'TRANSVERSE'/             INDAT1.......61900
c     3         22X,'PERMEABILITY',4X,'PERMEABILITY',4X,'PERMEABILITY',   INDAT1.......62000
c     4         8X,'(IN DEGREES)',3X,'(IN DEGREES)',3X,'(IN DEGREES)',3X, INDAT1.......62100
c     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY',3X,    INDAT1.......62200
c     4         'DISPERSIVITY',3X,'DISPERSIVITY',3X,'DISPERSIVITY'/       INDAT1.......62300
c     4         119X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM',  INDAT1.......62400
c     4         3X,' IN MAX-PERM',3X,' IN MID-PERM',3X,' IN MIN-PERM'/    INDAT1.......62500
c     1         119X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION',  INDAT1.......62600
c     2         3X,'   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)   INDAT1.......62700
c         END IF                                                          INDAT1.......62800
c      END IF                                                             INDAT1.......62900
      LRTEST=1                                                           INDAT1.......63000
      DO 550 LL=1,NE                                                     INDAT1.......63400
      ERRCOD = 'REA-INP-15B'                                             INDAT1.......63500
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT1.......63600
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) L,LREG(L),PMAX,PMID,PMIN,           INDAT1.......63800
     1   ANGLE1,ANGLE2,ANGLE3,ALMAX(L),ALMID(L),ALMIN(L),                INDAT1.......63900
     1   ATMAX(L),ATMID(L),ATMIN(L)                                      INDAT1.......64000
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......64100
         IF (INERR(1).NE.0) then
           IERRORCODE = 85
           return
         end if
c rbw end
      IF(LL.GT.1.AND.LREG(L).NE.LROLD) LRTEST=LRTEST+1                   INDAT1.......64500
      LROLD=LREG(L)                                                      INDAT1.......64600
      PMAX=PMAX*PMAXFA                                                   INDAT1.......64700
      PMID=PMID*PMIDFA                                                   INDAT1.......64800
      PMIN=PMIN*PMINFA                                                   INDAT1.......64900
      ANGLE1=ANGLE1*ANG1FA                                               INDAT1.......65000
      ANGLE2=ANGLE2*ANG2FA                                               INDAT1.......65100
      ANGLE3=ANGLE3*ANG3FA                                               INDAT1.......65200
      ALMAX(L)=ALMAX(L)*ALMAXF                                           INDAT1.......65300
      ALMID(L)=ALMID(L)*ALMIDF                                           INDAT1.......65400
      ALMIN(L)=ALMIN(L)*ALMINF                                           INDAT1.......65500
      ATMAX(L)=ATMAX(L)*ATMXF                                            INDAT1.......65600
      ATMID(L)=ATMID(L)*ATMDF                                            INDAT1.......65700
      ATMIN(L)=ATMIN(L)*ATMNF                                            INDAT1.......65800
c      IF(KELMNT.EQ.+1.AND.IUNSAT.NE.1) WRITE(K3,520) L,                  INDAT1.......65900
c     1   PMAX,PMID,PMIN,ANGLE1,ANGLE2,ANGLE3,                            INDAT1.......66000
c     2   ALMAX(L),ALMID(L),ALMIN(L),ATMAX(L),ATMID(L),ATMIN(L)           INDAT1.......66100
c  520 FORMAT(9X,I9,2X,3(1PD14.5,2X),7X,9(G11.4,4X))                      INDAT1.......66200
c      IF(KELMNT.EQ.+1.AND.IUNSAT.EQ.1) WRITE(K3,530) L,LREG(L),          INDAT1.......66300
c     1   PMAX,PMID,PMIN,ANGLE1,ANGLE2,ANGLE3,                            INDAT1.......66400
c     2   ALMAX(L),ALMID(L),ALMIN(L),ATMAX(L),ATMID(L),ATMIN(L)           INDAT1.......66500
c  530 FORMAT(9X,I9,4X,I5,2X,3(1PD14.5,2X),7X,9(G11.4,4X))                INDAT1.......66600
C                                                                        INDAT1.......66700
C.....ROTATE PERMEABILITY FROM MAX/MID/MIN TO X/Y/Z DIRECTIONS.          INDAT1.......66800
C        BASED ON CODE WRITTEN BY DAVID POLLOCK (USGS).                  INDAT1.......66900
      D2R=1.745329252D-2                                                 INDAT1.......67000
      PANGL1(L)=D2R*ANGLE1                                               INDAT1.......67100
      PANGL2(L)=D2R*ANGLE2                                               INDAT1.......67200
      PANGL3(L)=D2R*ANGLE3                                               INDAT1.......67300
      ZERO = 0D0                                                         INDAT1.......67400
      CALL ROTMAT(PANGL1(L),PANGL2(L),PANGL3(L),Q11,Q12,Q13,             INDAT1.......67500
     1   Q21,Q22,Q23,Q31,Q32,Q33)                                        INDAT1.......67600
      CALL TENSYM(PMAX,PMID,PMIN,Q11,Q12,Q13,Q21,Q22,Q23,Q31,Q32,Q33,    INDAT1.......67700
     1   PERMXX(L),PERMXY(L),PERMXZ(L),PERMYX(L),PERMYY(L),PERMYZ(L),    INDAT1.......67800
     2   PERMZX(L),PERMZY(L),PERMZZ(L))                                  INDAT1.......67900
  550 CONTINUE                                                           INDAT1.......68000
c      IF(KELMNT.EQ.0)                                                    INDAT1.......68100
c     1   WRITE(K3,569) PMAXFA,PMIDFA,PMINFA,ANG1FA,ANG2FA,ANG3FA,        INDAT1.......68200
c     2      ALMAXF,ALMIDF,ALMINF,ATMXF,ATMDF,ATMNF                       INDAT1.......68300
c  569 FORMAT(////11X,'E L E M E N T   I N F O R M A T I O N'//           INDAT1.......68400
c     1   16X,'PRINTOUT OF ELEMENT PERMEABILITIES AND DISPERSIVITIES ',   INDAT1.......68500
c     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PD15.4,5X,'MAXIMUM ',  INDAT1.......68600
c     3   'PERMEABILITY FACTOR'/33X,1PD15.4,5X,'MIDDLE PERMEABILITY ',    INDAT1.......68700
c     4   'FACTOR '/33X,1PD15.4,5X,'MINIMUM PERMEABILITY FACTOR'/         INDAT1.......68800
c     5   33X,1PD15.4,5X,'ANGLE1 FACTOR'/33X,1PD15.4,5X,'ANGLE2 FACTOR'/  INDAT1.......68900
c     6   33X,1PD15.4,5X,'ANGLE3 FACTOR'/                                 INDAT1.......69000
c     7   33X,1PD15.4,5X,'FACTOR FOR LONGITUDINAL DISPERSIVITY IN ',      INDAT1.......69100
c     8   'MAX-PERM DIRECTION'/33X,1PD15.4,5X,'FACTOR FOR LONGITUDINAL ', INDAT1.......69200
c     9   'DISPERSIVITY IN MID-PERM DIRECTION'/33X,1PD15.4,5X,'FACTOR ',  INDAT1.......69300
c     T   'FOR LONGITUDINAL DISPERSIVITY IN MIN-PERM DIRECTION'/          INDAT1.......69400
c     1   33X,1PD15.4,5X,'FACTOR FOR TRANSVERSE DISPERSIVITY IN ',        INDAT1.......69500
c     2   'MAX-PERM DIRECTION'/33X,1PD15.4,5X,'FACTOR FOR TRANSVERSE ',   INDAT1.......69600
c     3   'DISPERSIVITY IN MID-PERM DIRECTION'/33X,1PD15.4,5X,'FACTOR',   INDAT1.......69700
c     4   ' FOR TRANSVERSE DISPERSIVITY IN MIN-PERM DIRECTION')           INDAT1.......69800
c      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.NE.1) WRITE(K3,573)      INDAT1.......69900
c      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.EQ.1) WRITE(K3,575)      INDAT1.......70000
c  573 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......70100
c     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......70200
c  575 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......70300
c     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......70400
cC                                                                        INDAT1.......70500
      ELSE                                                               INDAT1.......70600C.....READ 2D INPUT FROM DATASETS 13 - 15.                               INDAT1.......70700
C.....NOTE THAT Z = THICKNESS AND PANGL1 = PANGLE.                       INDAT1.......70800
C                                                                        INDAT1.......70900
C.....INPUT DATASET 13:  ORIENTATION OF COORDINATES TO GRAVITY           INDAT1.......71000
      ERRCOD = 'REA-INP-13'                                              INDAT1.......71400
      CALL READIF(K1, INTFIL, ERRCOD,IERRORCODE)                                    INDAT1.......71500
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) GRAVX,GRAVY                         INDAT1.......71700
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......71800
         IF (INERR(1).NE.0) then
           IERRORCODE = 86
           return
         end if
c rbw end
      GRAVZ = 0D0                                                        INDAT1.......72200
c      WRITE(K3,1320) GRAVX,GRAVY                                         INDAT1.......72300
c 1320 FORMAT(////11X,'C O O R D I N A T E   O R I E N T A T I O N   ',   INDAT1.......72400
c     1   'T O   G R A V I T Y'//13X,'COMPONENT OF GRAVITY VECTOR',       INDAT1.......72500
c     2   /13X,'IN +X DIRECTION, GRAVX'/11X,1PD15.4,5X,                   INDAT1.......72600
c     3   'GRAVX = -GRAV * D(ELEVATION)/DX'//13X,'COMPONENT OF GRAVITY',  INDAT1.......72700
c     4   ' VECTOR'/13X,'IN +Y DIRECTION, GRAVY'/11X,1PD15.4,5X,          INDAT1.......72800
c     5   'GRAVY = -GRAV * D(ELEVATION)/DY')                              INDAT1.......72900
C                                                                        INDAT1.......73000
C.....INPUT DATASETS 14A & 14B:  NODEWISE DATA                           INDAT1.......73100
      ERRCOD = 'REA-INP-14A'                                             INDAT1.......73500
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......73600
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,SCALX,SCALY,SCALTH,PORFAC    INDAT1.......73800
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......73900
         IF (INERR(1).NE.0) then
           IERRORCODE = 87
           return
         end if
c rbw end
      IF (CDUM10.NE.'NODE      ') THEN                                   INDAT1.......74300
c rbw begin
c         ERRCOD = 'INP-14A-1'                                            INDAT1.......74400
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......74500
           IERRORCODE = 88
           return
c rbw end
      END IF                                                             INDAT1.......74700
      NRTEST=1                                                           INDAT1.......74800
      DO 1450 I=1,NN                                                     INDAT1.......75200
      ERRCOD = 'REA-INP-14B'                                             INDAT1.......75300
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......75400
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) II,NREG(II),X(II),Y(II),Z(II),      INDAT1.......75600
     1   POR(II)                                                         INDAT1.......75700
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......75800
         IF (INERR(1).NE.0) then
           IERRORCODE = 89
           return
         end if
c rbw end
      X(II)=X(II)*SCALX                                                  INDAT1.......76200
      Y(II)=Y(II)*SCALY                                                  INDAT1.......76300
      Z(II)=Z(II)*SCALTH                                                 INDAT1.......76400
      POR(II)=POR(II)*PORFAC                                             INDAT1.......76500
      IF(I.GT.1.AND.NREG(II).NE.NROLD) NRTEST=NRTEST+1                   INDAT1.......76600
      NROLD=NREG(II)                                                     INDAT1.......76700
C.....SET SPECIFIC PRESSURE STORATIVITY, SOP.                            INDAT1.......76800
 1450 SOP(II)=(1.D0-POR(II))*COMPMA+POR(II)*COMPFL                       INDAT1.......76900
c 1460 IF(KNODAL.EQ.0) WRITE(K3,1461) SCALX,SCALY,SCALTH,PORFAC           INDAT1.......77000
c 1461 FORMAT(1H1////11X,'N O D E   I N F O R M A T I O N'//16X,          INDAT1.......77100
c     1   'PRINTOUT OF NODE COORDINATES, THICKNESSES AND POROSITIES ',    INDAT1.......77200
c     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PD15.4,5X,'X-SCALE'/   INDAT1.......77300
c     1   33X,1PD15.4,5X,'Y-SCALE'/33X,1PD15.4,5X,'THICKNESS FACTOR'/     INDAT1.......77400
c     2   33X,1PD15.4,5X,'POROSITY FACTOR')                               INDAT1.......77500
c      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.NE.1) WRITE(K3,1463)     INDAT1.......77600
c      IF(IUNSAT.EQ.1.AND.KNODAL.EQ.0.AND.NRTEST.EQ.1) WRITE(K3,1465)     INDAT1.......77700
c 1463 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......77800
c     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......77900
c 1465 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......78000
c     1   'BEEN SPECIFIED AMONG THE NODES.')                              INDAT1.......78100
c      IF(KNODAL.EQ.+1.AND.IUNSAT.NE.1)                                   INDAT1.......78200
c     1   WRITE(K3,1470)(I,X(I),Y(I),Z(I),POR(I),I=1,NN)                  INDAT1.......78300
c 1470 FORMAT(1H1//11X,'N O D E   I N F O R M A T I O N'//14X,            INDAT1.......78400
c     1   'NODE',7X,'X',16X,'Y',17X,'THICKNESS',6X,'POROSITY'//           INDAT1.......78500
c     2   (9X,I9,3(3X,1PD14.5),6X,0PF8.5))                                INDAT1.......78600
c      IF(KNODAL.EQ.+1.AND.IUNSAT.EQ.1)                                   INDAT1.......78700
c     1   WRITE(K3,1480)(I,NREG(I),X(I),Y(I),Z(I),POR(I),I=1,NN)          INDAT1.......78800
c 1480 FORMAT(1H1//11X,'N O D E   I N F O R M A T I O N'//14X,'NODE',3X,  INDAT1.......78900
c     1   'REGION',7X,'X',16X,'Y',17X,'THICKNESS',6X,'POROSITY'//         INDAT1.......79000
c     2   (9X,I9,3X,I6,3(3X,1PD14.5),6X,0PF8.5))                          INDAT1.......79100
C                                                                        INDAT1.......79200
C.....INPUT DATASETS 15A & 15B:  ELEMENTWISE DATA                        INDAT1.......79300
      ERRCOD = 'REA-INP-15A'                                             INDAT1.......79700
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......79800
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) CDUM10,PMAXFA,PMINFA,ANGFAC,        INDAT1.......80000
     1   ALMAXF,ALMINF,ATMAXF,ATMINF                                     INDAT1.......80100
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......80200
         IF (INERR(1).NE.0) then
           IERRORCODE = 90
           return
         end if
c rbw end
      IF (CDUM10.NE.'ELEMENT   ') THEN                                   INDAT1.......80600
c rbw begin
c         ERRCOD = 'INP-15A-1'                                            INDAT1.......80700
c         CHERR(1) = '2D'                                                 INDAT1.......80800
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        INDAT1.......80900
           IERRORCODE = 91
           return
c rbw end
      END IF                                                             INDAT1.......81100
c      IF (KELMNT.EQ.+1) THEN                                             INDAT1.......81200
c         IF (IUNSAT.EQ.1) THEN                                           INDAT1.......81300
c            WRITE(K3,1500)                                               INDAT1.......81400
c 1500       FORMAT(1H1//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......81500
c     1         11X,'ELEMENT',3X,'REGION',4X,'MAXIMUM',9X,'MINIMUM',12X,  INDAT1.......81600
c     2         'ANGLE BETWEEN',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,   INDAT1.......81700
c     3         'TRANSVERSE',5X,'TRANSVERSE'/                             INDAT1.......81800
c     4         31X,'PERMEABILITY',4X,'PERMEABILITY',4X,                  INDAT1.......81900
c     5         '+X-DIRECTION AND',3X,'DISPERSIVITY',3X,'DISPERSIVITY',   INDAT1.......82000
c     6         3X,'DISPERSIVITY',3X,'DISPERSIVITY'/                      INDAT1.......82100
c     7         59X,'MAXIMUM PERMEABILITY',3X,' IN MAX-PERM',             INDAT1.......82200
c     8         3X,' IN MIN-PERM',3X,' IN MAX-PERM',3X,' IN MIN-PERM'/    INDAT1.......82300
c     9         67X,'(IN DEGREES)',3X,'   DIRECTION',3X,                  INDAT1.......82400
c     1         '   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)      INDAT1.......82500
c         ELSE                                                            INDAT1.......82600
c            WRITE(K3,1501)                                               INDAT1.......82700
c 1501       FORMAT(1H1//11X,'E L E M E N T   I N F O R M A T I O N'//    INDAT1.......82800
c     1         11X,'ELEMENT',4X,'MAXIMUM',9X,'MINIMUM',12X,              INDAT1.......82900
c     2         'ANGLE BETWEEN',3X,'LONGITUDINAL',3X,'LONGITUDINAL',5X,   INDAT1.......83000
c     3         'TRANSVERSE',5X,'TRANSVERSE'/                             INDAT1.......83100
c     4         22X,'PERMEABILITY',4X,'PERMEABILITY',4X,                  INDAT1.......83200
c     5         '+X-DIRECTION AND',3X,'DISPERSIVITY',3X,'DISPERSIVITY',   INDAT1.......83300
c     6         3X,'DISPERSIVITY',3X,'DISPERSIVITY'/                      INDAT1.......83400
c     7         50X,'MAXIMUM PERMEABILITY',3X,' IN MAX-PERM',             INDAT1.......83500
c     8         3X,' IN MIN-PERM',3X,' IN MAX-PERM',3X,' IN MIN-PERM'/    INDAT1.......83600
c     9         58X,'(IN DEGREES)',3X,'   DIRECTION',3X,                  INDAT1.......83700
c     1         '   DIRECTION',3X,'   DIRECTION',3X,'   DIRECTION'/)      INDAT1.......83800
c         END IF                                                          INDAT1.......83900
c      END IF                                                             INDAT1.......84000
      LRTEST=1                                                           INDAT1.......84100
      DO 1550 LL=1,NE                                                    INDAT1.......84500
      ERRCOD = 'REA-INP-15B'                                             INDAT1.......84600
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    INDAT1.......84700
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) L,LREG(L),PMAX,PMIN,ANGLEX,         INDAT1.......84900
     1   ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)                             INDAT1.......85000
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        INDAT1.......85100
         IF (INERR(1).NE.0) then
           IERRORCODE = 92
           return
         end if
c rbw end
      IF(LL.GT.1.AND.LREG(L).NE.LROLD) LRTEST=LRTEST+1                   INDAT1.......85500
      LROLD=LREG(L)                                                      INDAT1.......85600
      PMAX=PMAX*PMAXFA                                                   INDAT1.......85700
      PMIN=PMIN*PMINFA                                                   INDAT1.......85800
      ANGLEX=ANGLEX*ANGFAC                                               INDAT1.......85900
      ALMAX(L)=ALMAX(L)*ALMAXF                                           INDAT1.......86000
      ALMIN(L)=ALMIN(L)*ALMINF                                           INDAT1.......86100
      ATMAX(L)=ATMAX(L)*ATMAXF                                           INDAT1.......86200
      ATMIN(L)=ATMIN(L)*ATMINF                                           INDAT1.......86300
c      IF(KELMNT.EQ.+1.AND.IUNSAT.NE.1) WRITE(K3,1520) L,                 INDAT1.......86400
c     1   PMAX,PMIN,ANGLEX,ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)            INDAT1.......86500
c 1520 FORMAT(9X,I9,2X,2(1PD14.5,2X),7X,5(G11.4,4X))                      INDAT1.......86600
c      IF(KELMNT.EQ.+1.AND.IUNSAT.EQ.1) WRITE(K3,1530) L,LREG(L),         INDAT1.......86700
c     1   PMAX,PMIN,ANGLEX,ALMAX(L),ALMIN(L),ATMAX(L),ATMIN(L)            INDAT1.......86800
c 1530 FORMAT(9X,I9,4X,I5,2X,2(1PD14.5,2X),7X,5(G11.4,4X))                INDAT1.......86900
C                                                                        INDAT1.......87000
C.....ROTATE PERMEABILITY FROM MAXIMUM/MINIMUM TO X/Y DIRECTIONS         INDAT1.......87100
      RADIAX=1.745329D-2*ANGLEX                                          INDAT1.......87200
      SINA=DSIN(RADIAX)                                                  INDAT1.......87300
      COSA=DCOS(RADIAX)                                                  INDAT1.......87400
      SINA2=SINA*SINA                                                    INDAT1.......87500
      COSA2=COSA*COSA                                                    INDAT1.......87600
      PERMXX(L)=PMAX*COSA2+PMIN*SINA2                                    INDAT1.......87700
      PERMYY(L)=PMAX*SINA2+PMIN*COSA2                                    INDAT1.......87800
      PERMXY(L)=(PMAX-PMIN)*SINA*COSA                                    INDAT1.......87900
      PERMYX(L)=PERMXY(L)                                                INDAT1.......88000
      PANGL1(L)=RADIAX                                                   INDAT1.......88100
 1550 CONTINUE                                                           INDAT1.......88200
c      IF(KELMNT.EQ.0)                                                    INDAT1.......88300
c     1   WRITE(K3,1569) PMAXFA,PMINFA,ANGFAC,ALMAXF,ALMINF,ATMAXF,ATMINF INDAT1.......88400
c 1569 FORMAT(////11X,'E L E M E N T   I N F O R M A T I O N'//           INDAT1.......88500
c     1   16X,'PRINTOUT OF ELEMENT PERMEABILITIES AND DISPERSIVITIES ',   INDAT1.......88600
c     2   'CANCELLED.'//16X,'SCALE FACTORS :'/33X,1PD15.4,5X,'MAXIMUM ',  INDAT1.......88700
c     3   'PERMEABILITY FACTOR'/33X,1PD15.4,5X,'MINIMUM PERMEABILITY ',   INDAT1.......88800
c     4   'FACTOR'/33X,1PD15.4,5X,'ANGLE FROM +X TO MAXIMUM DIRECTION',   INDAT1.......88900
c     5   ' FACTOR'/33X,1PD15.4,5X,'FACTOR FOR LONGITUDINAL DISPERSIVITY' INDAT1.......89000
c     6  ,' IN MAX-PERM DIRECTION'/33X,1PD15.4,5X,                        INDAT1.......89100
c     7   'FACTOR FOR LONGITUDINAL DISPERSIVITY IN MIN-PERM DIRECTION',   INDAT1.......89200
c     8   /33X,1PD15.4,5X,'FACTOR FOR TRANSVERSE DISPERSIVITY',           INDAT1.......89300
c     9   ' IN MAX-PERM DIRECTION'/33X,1PD15.4,5X,                        INDAT1.......89400
c     *   'FACTOR FOR TRANSVERSE DISPERSIVITY IN MIN-PERM DIRECTION')     INDAT1.......89500
c      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.NE.1) WRITE(K3,1573)     INDAT1.......89600
c      IF(IUNSAT.EQ.1.AND.KELMNT.EQ.0.AND.LRTEST.EQ.1) WRITE(K3,1575)     INDAT1.......89700
c 1573 FORMAT(33X,'MORE THAN ONE REGION OF UNSATURATED PROPERTIES HAS ',  INDAT1.......89800
c     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......89900
c 1575 FORMAT(33X,'ONLY ONE REGION OF UNSATURATED PROPERTIES HAS ',       INDAT1.......90000
c     1   'BEEN SPECIFIED AMONG THE ELEMENTS.')                           INDAT1.......90100
C                                                                        INDAT1.......90200
      END IF                                                             INDAT1.......90300
C                                                                        INDAT1.......90400
      RETURN                                                             INDAT1.......90500
      END                                                                INDAT1.......90600
C                                                                        INDAT1.......90700
C     SUBROUTINE        P  R  S  W  D  S           SUTRA VERSION 1.1     PRSWDS.........100
C                                                                        PRSWDS.........200
C *** PURPOSE :                                                          PRSWDS.........300
C ***  PARSE A CHARACTER STRING INTO WORDS.  WORDS ARE CONSIDERED TO BE  PRSWDS.........400
C ***  SEPARATED BY ONE OR MORE OF THE SINGLE-CHARACTER DELIMITER DELIM  PRSWDS.........500
C ***  AND/OR BLANKS.  PARSING CONTINUES UNTIL THE ENTIRE STRING HAS     PRSWDS.........600
C ***  BEEN PROCESSED OR THE NUMBER OF WORDS PARSED EQUALS NWMAX.        PRSWDS.........700
C                                                                        PRSWDS.........800
      SUBROUTINE PRSWDS(STRING, DELIM, NWMAX, WORD, NWORDS)              PRSWDS.........900
      CHARACTER*80 STRING,WORD(NWMAX)                                    PRSWDS........1000
      CHARACTER*1 DELIM                                                  PRSWDS........1100
C                                                                        PRSWDS........1200
C.....INITIALIZE WORD LIST AND COUNTERS                                  PRSWDS........1300
      DO 50 I=1,NWMAX                                                    PRSWDS........1400
         WORD(I) = ""                                                    PRSWDS........1500
   50 CONTINUE                                                           PRSWDS........1600
      NWORDS = 0                                                         PRSWDS........1700
      M2 = 1                                                             PRSWDS........1800
C                                                                        PRSWDS........1900
  300 CONTINUE                                                           PRSWDS........2000
C.....FIND THE NEXT CHARACTER THAT IS NOT A DELIMITER                    PRSWDS........2100
      DO 350 M=M2,80                                                     PRSWDS........2200
         IF ((STRING(M:M).NE.DELIM).AND.(STRING(M:M).NE.' ')) THEN       PRSWDS........2300
            M1 = M                                                       PRSWDS........2400
            GOTO 400                                                     PRSWDS........2500
         END IF                                                          PRSWDS........2600
  350 CONTINUE                                                           PRSWDS........2700
      RETURN                                                             PRSWDS........2800
C                                                                        PRSWDS........2900
  400 CONTINUE                                                           PRSWDS........3000
C.....FIND THE NEXT CHARACTER THAT IS A DELIMITER                        PRSWDS........3100
      DO 450 M=M1+1,80                                                   PRSWDS........3200
         IF ((STRING(M:M).EQ.DELIM).OR.(STRING(M:M).EQ.' ')) THEN        PRSWDS........3300
            M2 = M                                                       PRSWDS........3400
            GOTO 500                                                     PRSWDS........3500
         END IF                                                          PRSWDS........3600
  450 CONTINUE                                                           PRSWDS........3700
      M2 = 80                                                            PRSWDS........3800
C                                                                        PRSWDS........3900
  500 CONTINUE                                                           PRSWDS........4000
C.....STORE THE LATEST WORD FOUND                                        PRSWDS........4100
      NWORDS = NWORDS + 1                                                PRSWDS........4200
      WORD(NWORDS) = STRING(M1:M2-1)                                     PRSWDS........4300
C                                                                        PRSWDS........4400
C.....IF END OF STRING NOT REACHED AND NUMBER OF WORDS IS LESS THAN      PRSWDS........4500
C        NWMAX, CONTINUE PARSING                                         PRSWDS........4600
      IF ((M2.LT.80).AND.(NWORDS.LT.NWMAX)) GOTO 300                     PRSWDS........4700
C                                                                        PRSWDS........4800
      RETURN                                                             PRSWDS........4900
      END                                                                PRSWDS........5000
C                                                                        PRSWDS........5100
C     SUBROUTINE        R  E  A  D  I  F           SUTRA VERSION 1.1     READIF.........100
C                                                                        READIF.........200
C *** PURPOSE :                                                          READIF.........300
C ***  TO READ A LINE FROM AN INPUT FILE INTO THE CHARACTER VARIABLE     READIF.........400
C ***  INTFIL.                                                           READIF.........500
C                                                                        READIF.........600
c rbw begin
c      SUBROUTINE READIF(KUU, INTFIL, ERRCOD)                             READIF.........700
      SUBROUTINE READIF(KUU, INTFIL, ERRCOD,IERRORCODE)                              READIF.........700
c rbw end
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                READIF.........800
      CHARACTER INTFIL*1000                                              READIF.........900
c      CHARACTER*80 ERRCOD,CHERR(10)                                      READIF........1000
c rbw begin
      integer IERRORCODE
c rbw end
      CHARACTER*80 ERRCOD
      CHARACTER*80 FNAME, FNAIN                                          READIF........1040
      CHARACTER ERRF*3, FINS*80                                          READIF........1050
      LOGICAL IS                                                         READIF........1060
c      DIMENSION INERR(10),RLERR(10)                                      READIF........1100
      DIMENSION INERR(10)
      DIMENSION NKS(2), KLIST(2,20), KDUM(0:7)                           READIF........1110
      DIMENSION FNAME(0:7), FNAIN(2,20)                                  READIF........1115
      COMMON /FNAINS/ FNAIN                                              READIF........1120
      COMMON /FNAMES/ FNAME                                              READIF........1125
      COMMON /FUNINS/ NKS,KLIST                                          READIF........1130
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        READIF........1135
C                                                                        READIF........1140
C.....COPY KUU INTO KU. SHOULD AVOID CHANGING KUU, SINCE IT IS ALREADY   READIF........1145
C        LINKED TO K1 OR K2 THROUGH THE ARGUMENT LIST, AND THE LATTER    READIF........1150
C        ARE ALSO PASSED IN THROUGH COMMON BLOCK FUNITS.                 READIF........1155
      KU = KUU                                                           READIF........1160
C                                                                        READIF........1200
C.....READ A LINE OF INPUT (UP TO 1000 CHARACTERS) FROM UNIT KU          READIF........1300
C        INTO INTFIL                                                     READIF........1400
100   READ(KU,'(A)',IOSTAT=INERR(1)) INTFIL                              READIF........1500
      IF (INERR(1).LT.0) THEN                                            READIF........1505
         IF (KU.EQ.K1) THEN                                              READIF........1510
            IK = 1                                                       READIF........1515
         ELSE                                                            READIF........1520
            IK = 2                                                       READIF........1525
         END IF                                                          READIF........1530
         IF (NKS(IK).GT.0) THEN                                          READIF........1535
            IF (KU.EQ.K1) THEN                                           READIF........1540
               K1 = KLIST(IK, NKS(IK))                                   READIF........1545
            ELSE                                                         READIF........1550
               K2 = KLIST(IK, NKS(IK))                                   READIF........1555
            END IF                                                       READIF........1560
            CLOSE(KU)                                                    READIF........1565
            KU = KLIST(IK, NKS(IK))                                      READIF........1570
            FNAME(IK) = FNAIN(IK, NKS(IK))                               READIF........1575
            NKS(IK) = NKS(IK) - 1                                        READIF........1580
            GOTO 100                                                     READIF........1585
         END IF                                                          READIF........1590
      END IF                                                             READIF........1595
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        READIF........1600
      IF (INERR(1).NE.0) then
        IERRORCODE = 93
        return
      end if
c rbw end
C                                                                        READIF........1605
C.....IF BLANK OR COMMENT LINE, SKIP IT.                                 READIF........1610
      IF ((INTFIL(1:1).EQ.'#').OR.(INTFIL.EQ.'')) GOTO 100               READIF........1615
C                                                                        READIF........1620
C.....IF FILE "INSERTED", OPEN THE FILE AND UPDATE THE APPROPRIATE       READIF........1625
C        UNIT NUMBER                                                     READIF........1630
      IF (INTFIL(1:7).EQ.'@INSERT') THEN                                 READIF........1635
         IF (KU.EQ.K1) THEN                                              READIF........1640
            IK = 1                                                       READIF........1645
            ERRF = 'INP'                                                 READIF........1650
         ELSE                                                            READIF........1655
            IK = 2                                                       READIF........1660
            ERRF = 'ICS'                                                 READIF........1665
         END IF                                                          READIF........1670
         READ(INTFIL(8:),*,IOSTAT=INERR(1)) KINS, FINS                   READIF........1675
         IF (INERR(1).NE.0) THEN                                         READIF........1680
c rbw begin
            IERRORCODE = 94
            return
c            CHERR(1) = ERRCOD                                            READIF........1685
c            ERRCOD = 'REA-' // ERRF // '-INS'                            READIF........1690
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF........1695
c rbw end
         END IF                                                          READIF........1700
         KDUM(0) = K00                                                   READIF........1705
         KDUM(1) = K1                                                    READIF........1710
         KDUM(2) = K2                                                    READIF........1715
         KDUM(3) = K3                                                    READIF........1720
         KDUM(4) = K4                                                    READIF........1725
         KDUM(5) = K5                                                    READIF........1730
         KDUM(6) = K6                                                    READIF........1735
         KDUM(7) = K7                                                    READIF........1740
         DO 500 K=0,7                                                    READIF........1745
            IF (KINS.EQ.KDUM(K)) THEN                                    READIF........1750
c rbw begin
               IERRORCODE = 95
               return
c               ERRCOD = 'FIL-3'                                          READIF........1755
c               INERR(1) = KINS                                           READIF........1760
c               CHERR(1) = FNAME(IK)                                      READIF........1765
c               CHERR(2) = FNAME(K)                                       READIF........1770
c               CHERR(3) = FINS                                           READIF........1775
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF........1780
c rbw end
            ELSE IF (FINS.EQ.FNAME(K)) THEN                              READIF........1785
c rbw begin
               IERRORCODE = 96
               return
c               ERRCOD = 'FIL-4'                                          READIF........1790
c               INERR(1) = KINS                                           READIF........1795
c               CHERR(1) = FNAME(IK)                                      READIF........1800
c               CHERR(2) = FINS                                           READIF........1805
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF........1810
c rbw end
            END IF                                                       READIF........1815
  500    CONTINUE                                                        READIF........1820
         DO 550 I=1,2                                                    READIF........1825
         DO 550 K=1,NKS(I)                                               READIF........1830
            IF (KINS.EQ.KLIST(I, K)) THEN                                READIF........1835
c rbw begin
               IERRORCODE = 97
               return
c               ERRCOD = 'FIL-3'                                          READIF........1840
c               INERR(1) = KINS                                           READIF........1845
c               CHERR(1) = FNAME(IK)                                      READIF........1850
c               CHERR(2) = FNAIN(I, K)                                    READIF........1855
c               CHERR(3) = FINS                                           READIF........1860
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF........1865
c rbw end
            ELSE IF (FINS.EQ.FNAIN(I, K)) THEN                           READIF........1870
c rbw begin
               IERRORCODE = 98
               return
c               ERRCOD = 'FIL-4'                                          READIF........1875
c               INERR(1) = KINS                                           READIF........1880
c               CHERR(1) = FNAME(IK)                                      READIF........1885
c               CHERR(2) = FINS                                           READIF........1890
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF........1895
c rbw end
            END IF                                                       READIF........1900
  550    CONTINUE                                                        READIF........1905
         INQUIRE(FILE=FINS,EXIST=IS)                                     READIF........1910
         IF (IS) THEN                                                    READIF........1915
            OPEN(UNIT=KINS,FILE=FINS,STATUS='OLD',FORM='FORMATTED',      READIF........1920
     1         IOSTAT=KERR)                                              READIF........1925
            IF (KERR.GT.0) THEN                                          READIF........1930
c rbw begin
               IERRORCODE = 99
               return
c               CHERR(1) = FNAME(IK)                                      READIF........1935
c               CHERR(2) = FINS                                           READIF........1940
c               INERR(1) = KINS                                           READIF........1945
c               ERRCOD = 'FIL-2'                                          READIF........1950
c               CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                  READIF........1955
c rbw end
            END IF                                                       READIF........1960
         ELSE                                                            READIF........1965
c rbw begin
               IERRORCODE = 100
               return
c            CHERR(1) = FNAME(IK)                                         READIF........1970
c            CHERR(2) = FINS                                              READIF........1975
c            ERRCOD = 'FIL-1'                                             READIF........1980
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF........1985
c rbw end
         END IF                                                          READIF........1990
         NKS(IK) = NKS(IK) + 1                                           READIF........1995
         IF (NKS(IK).GT.20) THEN                                         READIF........2000
c rbw begin
               IERRORCODE = 101
               return
c            CHERR(1) = FNAME(IK)                                         READIF........2005
c            CHERR(2) = FINS                                              READIF........2010
c            ERRCOD = 'FIL-8'                                             READIF........2015
c            CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                     READIF........2020
c rbw end
         END IF                                                          READIF........2025
         IF (KU.EQ.K1) THEN                                              READIF........2030
            K1 = KINS                                                    READIF........2035
         ELSE                                                            READIF........2040
            K2 = KINS                                                    READIF........2045
         END IF                                                          READIF........2050
         KLIST(IK, NKS(IK)) = KU                                         READIF........2055
         FNAIN(IK, NKS(IK)) = FNAME(IK)                                  READIF........2060
         KU = KINS                                                       READIF........2065
         FNAME(IK) = FINS                                                READIF........2070
         GOTO 100                                                        READIF........2075
      END IF                                                             READIF........2080
C                                                                        READIF........2085
      RETURN                                                             READIF........2100
      END                                                                READIF........2200
C                                                                        READIF........2300
C     SUBROUTINE        R  O  T  A  T  E           SUTRA VERSION 1.1     ROTATE.........100
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
C     SUBROUTINE        R  O  T  M  A  T           SUTRA VERSION 1.1     ROTMAT.........100
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

C     SUBROUTINE        S  K  P  C  O  M           SUTRA VERSION 2D3D.1  SKPCOM.........100
C                                                                        SKPCOM.........200
C *** PURPOSE :                                                          SKPCOM.........300
C ***  TO IDENTIFY AND SKIP OVER COMMENT LINES IN AN INPUT FILE          SKPCOM.........400
C ***  AND RETURN THE NUMBER OF LINES SKIPPED.                           SKPCOM.........500
C                                                                        SKPCOM.........600
      SUBROUTINE SKPCOM(KU, NLSKIP, ERRCOD, IERRORCODE)                              SKPCOM.........700
      IMPLICIT DOUBLE PRECISION (A-H, O-Z)                               SKPCOM.........800
      CHARACTER*1 CDUM                                                   SKPCOM.........900
      CHARACTER*80 ERRCOD,CHERR(10),FNAME(0:7)                           SKPCOM........1000
      DIMENSION INERR(10),RLERR(10)                                      SKPCOM........1100
      COMMON /FNAMES/ FNAME                                              SKPCOM........1200
C                                                                        SKPCOM........1300
C.....SKIP LINES UNTIL A NON-COMMENT LINE IS ENCOUNTERED                 SKPCOM........1400
      NLSKIP = 0                                                         SKPCOM........1500
  100 READ(KU,111,IOSTAT=INERR(1)) CDUM                                  SKPCOM........1600
  111 FORMAT (A1)                                                        SKPCOM........1700
      IF (INERR(1).NE.0) THEN                                            SKPCOM........1800
!         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SKPCOM........1900
         IERRORCODE = 1100
         RETURN                                                          SKPCOM........2000
      END IF                                                             SKPCOM........2100
      IF (CDUM.EQ.'#') THEN                                              SKPCOM........2200
         NLSKIP = NLSKIP + 1                                             SKPCOM........2300
         GOTO 100                                                        SKPCOM........2400
      END IF                                                             SKPCOM........2500
C                                                                        SKPCOM........2600
C.....BACKSPACE THE INPUT FILE TO THE LAST LINE READ (WHICH IS A         SKPCOM........2700
C        NON-COMMENT LINE)                                               SKPCOM........2800
      BACKSPACE(KU)                                                      SKPCOM........2900
C                                                                        SKPCOM........3000
  900 RETURN                                                             SKPCOM........3100
      END                                                                SKPCOM........3200

C     SUBROUTINE        S  O  U  R  C  E           SUTRA VERSION 1.1     SOURCE.........100
C                                                                        SOURCE.........200
C *** PURPOSE :                                                          SOURCE.........300
C ***  TO READ AND ORGANIZE FLUID MASS SOURCE DATA AND ENERGY OR         SOURCE.........400
C ***  SOLUTE MASS SOURCE DATA.                                          SOURCE.........500
C                                                                        SOURCE.........600
c rbw begin
c      SUBROUTINE SOURCE(QIN,UIN,IQSOP,QUIN,IQSOU,IQSOPT,IQSOUT)          SOURCE.........700
      SUBROUTINE SOURCE(QIN,UIN,IQSOP,QUIN,IQSOU,IQSOPT,IQSOUT,
     1   IERRORCODE )                                                    SOURCE.........700
c rbw end
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                SOURCE.........800
      CHARACTER INTFIL*1000                                              SOURCE.........900
      CHARACTER*80 ERRCOD,CHERR(10),FNAME(0:7)                           SOURCE........1000
      DIMENSION KTYPE(2)                                                 ! ktype
      COMMON /CONTRL/ GNUP,GNUU,UP,DTMULT,DTMAX,ME,ISSFLO,ISSTRA,ITCYC,  SOURCE........1100
     1   NPCYC,NUCYC,NPRINT,IREAD,ISTORE,NOUMAT,IUNSAT,KTYPE             SOURCE........1200
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              SOURCE........1300
     1   NSOP,NSOU,NBCN                                                  SOURCE........1400
      COMMON /FNAMES/ FNAME                                              SOURCE........1600
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        SOURCE........1700
c rbw begin
      integer IERRORCODE
c rbw end
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
c      IF(ME) 50,50,150                                                   SOURCE........3000
c   50 WRITE(K3,100)                                                      SOURCE........3100
c  100 FORMAT(1H1////11X,'F L U I D   S O U R C E   D A T A'              SOURCE........3200
c     1   ////11X,'**** NODES AT WHICH FLUID INFLOWS OR OUTFLOWS ARE ',   SOURCE........3300
c     2   'SPECIFIED ****'//11X,'NODE NUMBER',10X,                        SOURCE........3400
c     3   'FLUID INFLOW(+)/OUTFLOW(-)',5X,'SOLUTE CONCENTRATION OF'       SOURCE........3500
c     4   /11X,'(MINUS INDICATES',5X,'(FLUID MASS/SECOND)',               SOURCE........3600
c     5   12X,'INFLOWING FLUID'/12X,'TIME-VARYING',39X,                   SOURCE........3700
c     6   '(MASS SOLUTE/MASS WATER)'/12X,'FLOW RATE OR'/12X,              SOURCE........3800
c     7   'CONCENTRATION)'//)                                             SOURCE........3900
c      GOTO 300                                                           SOURCE........4000
c  150 WRITE(K3,200)                                                      SOURCE........4100
c  200 FORMAT(1H1////11X,'F L U I D   S O U R C E   D A T A'              SOURCE........4200
c     1   ////11X,'**** NODES AT WHICH FLUID INFLOWS OR OUTFLOWS ARE ',   SOURCE........4300
c     2   'SPECIFIED ****'//11X,'NODE NUMBER',10X,                        SOURCE........4400
c     3   'FLUID INFLOW(+)/OUTFLOW(-)',5X,'TEMPERATURE {DEGREES CELSIUS}' SOURCE........4500
c     4   /11X,'(MINUS INDICATES',5X,'(FLUID MASS/SECOND)',12X,           SOURCE........4600
c     5   'OF INFLOWING FLUID'/12X,'TIME-VARYING'/12X,'FLOW OR'/12X,      SOURCE........4700
c     6   'TEMPERATURE)'//)                                               SOURCE........4800
C                                                                        SOURCE........4900
C.....INPUT DATASET 17:  DATA FOR FLUID SOURCES AND SINKS                SOURCE........5000
  300 CONTINUE                                                           SOURCE........5100
  305 NIQP=NIQP+1                                                        SOURCE........5500
      ERRCOD = 'REA-INP-17'                                              SOURCE........5600
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    SOURCE........5700
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) IQCP                                SOURCE........5900
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SOURCE........6000
         IF (INERR(1).NE.0) then
           IERRORCODE = 102
           return
         end if
c rbw end
      IQCPA = IABS(IQCP)                                                 SOURCE........6400
      IF (IQCP.EQ.0) THEN                                                SOURCE........6500
         GOTO 700                                                        SOURCE........6600
      ELSE IF (IQCPA.GT.NN) THEN                                         SOURCE........6700
c rbw begin
c         ERRCOD = 'INP-17-1'                                             SOURCE........6800
c         INERR(1) = IQCPA                                                SOURCE........6900
c         INERR(2) = NN                                                   SOURCE........7000
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE........7100
           IERRORCODE = 103
           return
c rbw end
      ELSE IF (NIQP.GT.NSOPI) THEN                                       SOURCE........7300
         GOTO 305                                                        SOURCE........7400
      END IF                                                             SOURCE........7500
      ERRCOD = 'REA-INP-17'                                              SOURCE........7600
      IF (IQCP.GT.0) THEN                                                SOURCE........7700
         READ(INTFIL,*,IOSTAT=INERR(1)) IQCP,QINC                        SOURCE........7800
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SOURCE........7900
         IF (INERR(1).NE.0) then
           IERRORCODE = 104
           return
         end if
c rbw end
         IF (QINC.GT.0D0) THEN                                           SOURCE........8300
            READ(INTFIL,*,IOSTAT=INERR(1)) IQCP,QINC,UINC                SOURCE........8400
c rbw begin
c            IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)  SOURCE........8500
            IF (INERR(1).NE.0) then
              IERRORCODE = 105
              return
            end if
c rbw end
         END IF                                                          SOURCE........8900
      END IF                                                             SOURCE........9000
      IQSOP(NIQP)=IQCP                                                   SOURCE........9100
      IF(IQCP.LT.0) IQSOPT=-1                                            SOURCE........9200
      IQP=IABS(IQCP)                                                     SOURCE........9300
      QIN(IQP)=QINC                                                      SOURCE........9400
      UIN(IQP)=UINC                                                      SOURCE........9500
      IF(IQCP.GT.0) GOTO 450                                             SOURCE........9600
c      WRITE(K3,500) IQCP                                                 SOURCE........9700
      GOTO 600                                                           SOURCE........9800
  450 IF(QINC.GT.0) GOTO 460                                             SOURCE........9900
c      WRITE(K3,500) IQCP,QINC                                            SOURCE.......10000
      GOTO 600                                                           SOURCE.......10100
  460 continue
c  460 WRITE(K3,500) IQCP,QINC,UINC                                       SOURCE.......10200
c  500 FORMAT(11X,I10,13X,1PE14.7,16X,1PE14.7)                            SOURCE.......10300
  600 GOTO 305                                                           SOURCE.......10400
  700 NIQP = NIQP - 1                                                    SOURCE.......10500
      IF(NIQP.EQ.NSOPI) GOTO 890                                         SOURCE.......10600
c rbw begin
c         ERRCOD = 'INP-3,17-1'                                           SOURCE.......10700
c         INERR(1) = NIQP                                                 SOURCE.......10800
c         INERR(2) = NSOPI                                                SOURCE.......10900
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE.......11000
           IERRORCODE = 106
           return
c rbw end
 890  continue
c  890 IF(IQSOPT.EQ.-1) WRITE(K3,900)                                     SOURCE.......11200
c  900 FORMAT(////11X,'THE SPECIFIED TIME VARIATIONS ARE ',               SOURCE.......11300
c     1   'USER-PROGRAMMED IN SUBROUTINE  B C T I M E .')                 SOURCE.......11400
C                                                                        SOURCE.......11500
C                                                                        SOURCE.......11600
 1000 IF(NSOUI.EQ.0) GOTO 9000                                           SOURCE.......11700
c      IF(ME) 1050,1050,1150                                              SOURCE.......11800
c 1050 WRITE(K3,1100)                                                     SOURCE.......11900
c 1100 FORMAT(////////11X,'S O L U T E   S O U R C E   D A T A'           SOURCE.......12000
c     1   ////11X,'**** NODES AT WHICH SOURCES OR SINKS OF SOLUTE ',      SOURCE.......12100
c     2   'MASS ARE SPECIFIED ****'//11X,'NODE NUMBER',10X,               SOURCE.......12200
c     3   'SOLUTE SOURCE(+)/SINK(-)'/11X,'(MINUS INDICATES',5X,           SOURCE.......12300
c     4   '(SOLUTE MASS/SECOND)'/12X,'TIME-VARYING'/12X,                  SOURCE.......12400
c     5   'SOURCE OR SINK)'//)                                            SOURCE.......12500
c      GOTO 1305                                                          SOURCE.......12600
c 1150 WRITE(K3,1200)                                                     SOURCE.......12700
c 1200 FORMAT(////////11X,'E N E R G Y   S O U R C E   D A T A'           SOURCE.......12800
c     1   ////11X,'**** NODES AT WHICH SOURCES OR SINKS OF ',             SOURCE.......12900
c     2   'ENERGY ARE SPECIFIED ****'//11X,'NODE NUMBER',10X,             SOURCE.......13000
c     3   'ENERGY SOURCE(+)/SINK(-)'/11X,'(MINUS INDICATES',5X,           SOURCE.......13100
c     4   '(ENERGY/SECOND)'/12X,'TIME-VARYING'/12X,                       SOURCE.......13200
c     5   'SOURCE OR SINK)'//)                                            SOURCE.......13300
C                                                                        SOURCE.......13400
C.....INPUT DATASET 18:  DATA FOR ENERGY OR SOLUTE MASS SOURCES OR SINKS SOURCE.......13500
 1305 NIQU=NIQU+1                                                        SOURCE.......13900
      ERRCOD = 'REA-INP-18'                                              SOURCE.......14000
      CALL READIF(K1, INTFIL, ERRCOD, IERRORCODE)                                    SOURCE.......14100
      if (IERRORCODE.ne.0) return
      READ(INTFIL,*,IOSTAT=INERR(1)) IQCU                                SOURCE.......14300
c rbw begin
c      IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)        SOURCE.......14400
         IF (INERR(1).NE.0) then
           IERRORCODE = 107
           return
         end if
c rbw end
      IQCUA = IABS(IQCU)                                                 SOURCE.......14800
      IF (IQCU.EQ.0) THEN                                                SOURCE.......14900
         GOTO 1700                                                       SOURCE.......15000
      ELSE IF (IQCUA.GT.NN) THEN                                         SOURCE.......15100
c rbw begin
c         ERRCOD = 'INP-18-1'                                             SOURCE.......15200
c         INERR(1) = IQCUA                                                SOURCE.......15300
c         INERR(2) = NN                                                   SOURCE.......15400
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE.......15500
           IERRORCODE = 108
           return
c rbw end
      ELSE IF (NIQU.GT.NSOUI) THEN                                       SOURCE.......15700
         GOTO 1305                                                       SOURCE.......15800
      END IF                                                             SOURCE.......15900
      IF (IQCU.GT.0) THEN                                                SOURCE.......16000
         ERRCOD = 'REA-INP-18'                                           SOURCE.......16100
         READ(INTFIL,*,IOSTAT=INERR(1)) IQCU,QUINC                       SOURCE.......16200
c rbw begin
c         IF (INERR(1).NE.0) CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)     SOURCE.......16300
         IF (INERR(1).NE.0) then
           IERRORCODE = 109
           return
         end if
c rbw end
      END IF                                                             SOURCE.......16700
      IQSOU(NIQU)=IQCU                                                   SOURCE.......16800
      IF(IQCU.LT.0) IQSOUT=-1                                            SOURCE.......16900
      IQU=IABS(IQCU)                                                     SOURCE.......17000
      QUIN(IQU)=QUINC                                                    SOURCE.......17100
      IF(IQCU.GT.0) GOTO 1450                                            SOURCE.......17200
c      WRITE(K3,1500) IQCU                                                SOURCE.......17300
      GOTO 1600                                                          SOURCE.......17400
 1450 continue
c 1450 WRITE(K3,1500) IQCU,QUINC                                          SOURCE.......17500
c 1500 FORMAT(11X,I10,13X,1PE14.7)                                        SOURCE.......17600
 1600 GOTO 1305                                                          SOURCE.......17700
 1700 NIQU = NIQU - 1                                                    SOURCE.......17800
      IF(NIQU.EQ.NSOUI) GOTO 1890                                        SOURCE.......17900
c rbw begin
c         ERRCOD = 'INP-3,18-1'                                           SOURCE.......18000
c         IF (ME.EQ.1) THEN                                               SOURCE.......18100
c            CHERR(1) = 'energy'                                          SOURCE.......18200
c         ELSE                                                            SOURCE.......18300
c            CHERR(1) = 'solute'                                          SOURCE.......18400
c         END IF                                                          SOURCE.......18500
c         INERR(1) = NIQU                                                 SOURCE.......18600
c         INERR(2) = NSOUI                                                SOURCE.......18700
c         CALL SUTERR(ERRCOD, CHERR, INERR, RLERR)                        SOURCE.......18800
           IERRORCODE = 110
           return
c rbw end
 1890 continue
c 1890 IF(IQSOUT.EQ.-1) WRITE(K3,900)                                     SOURCE.......19000
C                                                                        SOURCE.......19100
 9000 RETURN                                                             SOURCE.......19200
C                                                                        SOURCE.......19300
      END                                                                SOURCE.......19400
C                                                                        SOURCE.......19500
C     SUBROUTINE        S  U  T  E  R  R           SUTRA VERSION 1.1     SUTERR.........100
C                                                                        SUTERR.........200
C *** PURPOSE :                                                          SUTERR.........300
C ***  TO HANDLE SUTRA AND FORTRAN ERRORS.                               SUTERR.........400
C                                                                        SUTERR.........500
      SUBROUTINE SUTERR(ERRCOD, CHERR, INERR, RLERR)                     SUTERR.........600
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                                SUTERR.........700
      CHARACTER*80 ERRCOD,CHERR(10),CODE(3),CODUM(3),FNAME(0:7)          SUTERR.........800
      CHARACTER*70 DS(50),EX(50)                                         SUTERR.........900
      CHARACTER CDUM80*80                                                SUTERR........1000
      CHARACTER CINERR(10)*9,CRLERR(10)*15                               SUTERR........1100
      CHARACTER SOLNAM(0:10)*40,SOLWRD(0:10)*10                          SUTERR........1200
      DIMENSION INERR(10), RLERR(10)                                     SUTERR........1400
      COMMON /DIMS/ NN,NE,NIN,NBI,NCBI,NB,NBHALF,NPBC,NUBC,              SUTERR........1500
     1   NSOP,NSOU,NBCN                                                  SUTERR........1600
      COMMON /FNAMES/ FNAME                                              SUTERR........1800
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        SUTERR........1900
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     SUTERR........2000
     1   KSCRN,KPAUSE                                                    SUTERR........2100
      COMMON /SOLVC/ SOLWRD,SOLNAM                                       SUTERR........2200
      COMMON /SOLVN/ NSLVRS                                              SUTERR........2300
C                                                                        SUTERR........2400
C.....PARSE THE ERROR CODE                                               SUTERR........2800
      CALL PRSWDS(ERRCOD, '-', 3, CODE, NWORDS)                          SUTERR........2900
C                                                                        SUTERR........3000
C.....IF AN ERROR OTHER THAN A MATRIX SOLVER OR NONLINEAR CONVERGENCE    SUTERR........3100
C        ERROR HAS OCCURRED, OVERRIDE THE SCREEN OUTPUT CONTROLS SO      SUTERR........3200
C        THAT THE ERROR IS PRINTED TO THE SCREEN AND SUTRA PAUSES FOR    SUTERR........3300
C        A USER RESPONSE.                                                SUTERR........3400
      IF ((CODE(1).NE.'SOL').AND.(CODE(1).NE.'CON')) THEN                SUTERR........3500
         KSCRN = +1                                                      SUTERR........3600
         KPAUSE = +1                                                     SUTERR........3700
      END IF                                                             SUTERR........3800
C                                                                        SUTERR........3900
C.....COPY INTEGER AND REAL ERROR PARAMETERS INTO CHARACTER STRINGS      SUTERR........4000
      DO 150 I=1,10                                                      SUTERR........4100
         WRITE(UNIT=CINERR(I), FMT='(I9)') INERR(I)                      SUTERR........4200
         WRITE(UNIT=CRLERR(I), FMT='(1PE15.7)') RLERR(I)                 SUTERR........4300
  150 CONTINUE                                                           SUTERR........4400
C                                                                        SUTERR........4500
C.....INITIALIZE THE ERROR OUTPUT STRINGS                                SUTERR........4600
      DO 200 I=1,50                                                      SUTERR........4700
         DS(I) = "null_line"                                             SUTERR........4800
         EX(I) = "null_line"                                             SUTERR........4900
  200 CONTINUE                                                           SUTERR........5000
C                                                                        SUTERR........5100
C.....SET THE ERROR OUTPUT STRINGS ACCORDING TO THE TYPE OF ERROR        SUTERR........5200
      IF (ERRCOD.EQ.'INP-2A-1') THEN                                     SUTERR........5300
        DS(1)="The first word of SIMULA is not 'SUTRA'."                 SUTERR........5400
        EX(1)="In dataset 2A of the main input file, the first word"     SUTERR........5500
        EX(2)="of the variable SIMULA must be 'SUTRA'."                  SUTERR........5600
        EX(3)=" "                                                        SUTERR........5700
        EX(4)="Example of a valid dataset 2A:"                           SUTERR........5800
        EX(5)="'SUTRA SOLUTE TRANSPORT'"                                 SUTERR........5900
      ELSE IF (ERRCOD.EQ.'INP-2A-2') THEN                                SUTERR........6000
        DS(1)="The second word of SIMULA is not 'SOLUTE' or 'ENERGY'."   SUTERR........6100
        EX(1)="In dataset 2A of the main input file, the second word"    SUTERR........6200
        EX(2)="of the variable SIMULA must be 'SOLUTE' or 'ENERGY'."     SUTERR........6300
        EX(3)=" "                                                        SUTERR........6400
        EX(4)="Example of a valid dataset 2A:"                           SUTERR........6500
        EX(5)="'SUTRA SOLUTE TRANSPORT'"                                 SUTERR........6600
      ELSE IF (ERRCOD.EQ.'INP-2B-1') THEN                                SUTERR........6700
        DS(1)="The first word of MSHSTR is not '2D' or '3D'."            SUTERR........6800
        EX(1)="In dataset 2B of the main input file, the first word"     SUTERR........6900
        EX(2)="of the variable MSHSTR must be '2D' or '3D'."             SUTERR........7000
        EX(3)=" "                                                        SUTERR........7100
        EX(4)="Example of a valid dataset 2B:"                           SUTERR........7200
        EX(5)="'3D REGULAR MESH'  10  20  30"                            SUTERR........7300
C     ERROR CODE 'INP-2B-2' IS NO LONGER USED.                           SUTERR........7400
C     ERROR CODE 'INP-2B-3' IS NO LONGER USED.                           SUTERR........8200
      ELSE IF (ERRCOD.EQ.'INP-2B-4') THEN                                SUTERR........9300
        DS(1)="The second word of MSHSTR is not 'IRREGULAR', 'REGULAR'," SUTERR........9400
        DS(2)="'BLOCKWISE', or 'LAYERED'."                               SUTERR........9500
        EX(1)="In dataset 2B of the main input file, the second word"    SUTERR........9600
        EX(2)="of the variable MSHSTR must be 'IRREGULAR', 'REGULAR',"   SUTERR........9700
        EX(3)="'BLOCKWISE' or 'LAYERED'.  By definition, only 3D meshes" SUTERR........9800
        EX(4)="can be LAYERED."                                          SUTERR........9900
        EX(5)=" "                                                        SUTERR.......10000
        EX(6)="Example of a valid dataset 2B:"                           SUTERR.......10100
        EX(7)="'3D REGULAR MESH'  10  20  30"                            SUTERR.......10200
      ELSE IF (ERRCOD.EQ.'INP-2B-5') THEN                                SUTERR.......10210
        DS(1)="A 2D LAYERED mesh has been specified."                    SUTERR.......10215
        EX(1)="By definition, only 3D meshes can be LAYERED."            SUTERR.......10220
        EX(2)=" "                                                        SUTERR.......10225
        EX(3)="Example of a valid dataset 2B:"                           SUTERR.......10230
        EX(4)="'3D LAYERED MESH'  10  2560  2210  'ACROSS'"              SUTERR.......10235  ! finalize?
      ELSE IF (ERRCOD.EQ.'INP-2B-6') THEN                                SUTERR.......10240
        DS(1)="The first word of LAYSTR is not 'ACROSS' or 'WITHIN'."    SUTERR.......10245
        EX(1)="In dataset 2B of the main input file, the first word"     SUTERR.......10250
        EX(2)="of the variable LAYSTR must be 'ACROSS' or 'WITHIN'."     SUTERR.......10255
        EX(3)=" "                                                        SUTERR.......10260
        EX(4)="Example of a valid dataset 2B:"                           SUTERR.......10265
        EX(5)="'3D LAYERED MESH'  10  2560  2210  'ACROSS'"              SUTERR.......10270  ! finalize?
      ELSE IF (ERRCOD.EQ.'INP-2B,3-1') THEN                              SUTERR.......10300
        DS(1)="The number of nodes, NN, does not match the rectangular"  SUTERR.......10400
        DS(2)="dimensions, NN1*NN2*NN3."                                 SUTERR.......10500
        EX(1)="In datasets 2B and 3 of the main input file, the total"   SUTERR.......10600
        EX(2)="number of nodes, NN, must equal the product of the"       SUTERR.......10700
        EX(3)="rectangular dimensions, NN1*NN2*NN3."                     SUTERR.......10800
        EX(4)=" "                                                        SUTERR.......10900
        EX(5)="Example:"                                                 SUTERR.......11000
        EX(6)="If NN1=10, NN2=20, and NN3=30 (dataset 2B), then"         SUTERR.......11100
        EX(7)="NN=10*20*30=6000 (dataset 3)."                            SUTERR.......11200
      ELSE IF (ERRCOD.EQ.'INP-2B,3-2') THEN                              SUTERR.......11300
        DS(1)="The number of elements, NE, does not match the"           SUTERR.......11400
        DS(2)="rectangular dimensions, (NN1-1)*(NN2-1)*(NN3-1)."         SUTERR.......11500
        EX(1)="In datasets 2B and 3 of the main input file, the total"   SUTERR.......11600
        EX(2)="number of elements, NE, must equal the product of the"    SUTERR.......11700
        EX(3)="rectangular dimensions, (NN1-1)*(NN2-1)*(NN3-1)."         SUTERR.......11800
        EX(4)=" "                                                        SUTERR.......11900
        EX(5)="Example:"                                                 SUTERR.......12000
        EX(6)="If NN1=10, NN2=20, and NN3=30 (dataset 2B), then"         SUTERR.......12100
        EX(7)="NE=9*19*29=4959 (dataset 3)."                             SUTERR.......12200
      ELSE IF (ERRCOD.EQ.'INP-2B,3-3') THEN                              SUTERR.......12220
        DS(1)="The number of nodes, NN, does not match the layered"      SUTERR.......12222
        DS(2)="dimensions, NLAYS*NNLAY."                                 SUTERR.......12224
        EX(1)="In datasets 2B and 3 of the main input file, the total"   SUTERR.......12226
        EX(2)="number of nodes, NN, must equal the product of the"       SUTERR.......12228
        EX(3)="layered dimensions, NLAYS*NNLAY."                         SUTERR.......12230
        EX(4)=" "                                                        SUTERR.......12232
        EX(5)="Example:"                                                 SUTERR.......12234
        EX(6)="If NLAYS=10 and NNLAY=2560 (dataset 2B), then"            SUTERR.......12236
        EX(7)="NN=10*2560=25600 (dataset 3)."                            SUTERR.......12238
      ELSE IF (ERRCOD.EQ.'INP-2B,3-4') THEN                              SUTERR.......12250
        DS(1)="The number of nodes, NE, does not match the layered"      SUTERR.......12252
        DS(2)="dimensions, (NLAYS-1)*NELAY."                             SUTERR.......12254
        EX(1)="In datasets 2B and 3 of the main input file, the total"   SUTERR.......12256
        EX(2)="number of nodes, NE, must equal the product of the"       SUTERR.......12258
        EX(3)="layered dimensions, (NLAYS-1)*NELAY."                     SUTERR.......12260
        EX(4)=" "                                                        SUTERR.......12262
        EX(5)="Example:"                                                 SUTERR.......12264
        EX(6)="If NLAYS=10 and NELAY=2210 (dataset 2B), then"            SUTERR.......12266
        EX(7)="NN=9*2210=19890 (dataset 3)."                             SUTERR.......12268
      ELSE IF (ERRCOD.EQ.'INP-4-1') THEN                                 SUTERR.......12300
        DS(1)="The first word of CUNSAT is not 'SATURATED' or"           SUTERR.......12400
        DS(2)="'UNSATURATED'."                                           SUTERR.......12500
        EX(1)="In dataset 4 of the main input file, the first word"      SUTERR.......12600
        EX(2)="of the variable CUNSAT must be 'SATURATED' or"            SUTERR.......12700
        EX(3)="'UNSATURATED'."                                           SUTERR.......12800
        EX(4)=" "                                                        SUTERR.......12900
        EX(5)="Example of a valid dataset 4:"                            SUTERR.......13000
        EX(6)="'SATURATED FLOW' 'STEADY FLOW' 'TRANSIENT TRANSPORT'" //  SUTERR.......13100
     1        " 'COLD' 10"                                               SUTERR.......13200
      ELSE IF (ERRCOD.EQ.'INP-4-2') THEN                                 SUTERR.......13300
        DS(1)="The first word of CSSFLO is not 'STEADY' or 'TRANSIENT'." SUTERR.......13400
        EX(1)="In dataset 4 of the main input file, the first word"      SUTERR.......13500
        EX(2)="of the variable CSSFLO must be 'STEADY' or 'TRANSIENT'."  SUTERR.......13600
        EX(3)=" "                                                        SUTERR.......13700
        EX(4)="Example of a valid dataset 4:"                            SUTERR.......13800
        EX(5)="'SATURATED FLOW' 'STEADY FLOW' 'TRANSIENT TRANSPORT'" //  SUTERR.......13900
     1        " 'COLD' 10"                                               SUTERR.......14000
      ELSE IF (ERRCOD.EQ.'INP-4-3') THEN                                 SUTERR.......14100
        DS(1)="The first word of CSSTRA is not 'STEADY' or 'TRANSIENT'." SUTERR.......14200
        EX(1)="In dataset 4 of the main input file, the first word"      SUTERR.......14300
        EX(2)="of the variable CSSTRA must be 'STEADY' or 'TRANSIENT'."  SUTERR.......14400
        EX(3)=" "                                                        SUTERR.......14500
        EX(4)="Example of a valid dataset 4:"                            SUTERR.......14600
        EX(5)="'SATURATED FLOW' 'STEADY FLOW' 'TRANSIENT TRANSPORT'" //  SUTERR.......14700
     1        " 'COLD' 10"                                               SUTERR.......14800
      ELSE IF (ERRCOD.EQ.'INP-4-4') THEN                                 SUTERR.......14900
        DS(1)="The first word of CREAD is not 'COLD' or 'WARM'."         SUTERR.......15000
        EX(1)="In dataset 4 of the main input file, the first word"      SUTERR.......15100
        EX(2)="of the variable CREAD must be 'COLD' or 'WARM'."          SUTERR.......15200
        EX(3)=" "                                                        SUTERR.......15300
        EX(4)="Example of a valid dataset 4:"                            SUTERR.......15400
        EX(5)="'SATURATED FLOW' 'STEADY FLOW' 'TRANSIENT TRANSPORT'" //  SUTERR.......15500
     1        " 'COLD' 10"                                               SUTERR.......15600
      ELSE IF (ERRCOD.EQ.'INP-4-5') THEN                                 SUTERR.......15700
        DS(1)="Specified TRANSIENT flow with STEADY transport."          SUTERR.......15800
        EX(1)="In dataset 4 of the main input file, TRANSIENT flow"      SUTERR.......15900
        EX(2)="requires TRANSIENT transport.  Likewise, STEADY"          SUTERR.......16000
        EX(3)="transport requires STEADY flow.  The following are"       SUTERR.......16100
        EX(4)="valid combinations:"                                      SUTERR.......16200
        EX(5)=" "                                                        SUTERR.......16300
        EX(6)="     CSSFLO      CSSTRA"                                  SUTERR.......16400
        EX(7)="   ----------- -----------"                               SUTERR.......16500
        EX(8)="    'STEADY'    'STEADY'"                                 SUTERR.......16600
        EX(9)="    'STEADY'   'TRANSIENT'"                               SUTERR.......16700
        EX(10)="   'TRANSIENT' 'TRANSIENT'"                              SUTERR.......16800
        EX(11)=" "                                                       SUTERR.......16900
        EX(12)="Example of a valid dataset 4:"                           SUTERR.......17000
        EX(13)="'SATURATED FLOW' 'STEADY FLOW' 'STEADY TRANSPORT'" //    SUTERR.......17100
     1        " 'COLD' 10"                                               SUTERR.......17200
      ELSE IF (ERRCOD.EQ.'INP-7B&C-1') THEN                              SUTERR.......17300
        DS(1)="Unrecognized solver name."                                SUTERR.......17400
        EX(1)="In datasets 7B&C, valid solver selections are:"           SUTERR.......17500
        EX(2)=" "                                                        SUTERR.......17600
        DO 400 M=0,NSLVRS-1                                              SUTERR.......17700
           EX(M+3)=SOLWRD(M) // " --> " // SOLNAM(M)                     SUTERR.......17800
  400   CONTINUE                                                         SUTERR.......17900
        EX(NSLVRS+3)=" "                                                 SUTERR.......18000
        EX(NSLVRS+4)="Note that solver selections for P and U must be"   SUTERR.......18100
        EX(NSLVRS+5)="both DIRECT or both iterative."                    SUTERR.......18200
      ELSE IF (ERRCOD.EQ.'INP-7B&C-2') THEN                              SUTERR.......18300
        DS(1)="Solver selections for P and U are not both DIRECT or"     SUTERR.......18400
        DS(2)="both iterative."                                          SUTERR.......18500
        EX(1)="The solver selections for P and U must be both"           SUTERR.......18600
        EX(2)="DIRECT or both iterative."                                SUTERR.......18700
      ELSE IF (ERRCOD.EQ.'INP-7B&C-3') THEN                              SUTERR.......18800
        DS(1)="Invalid selection of the CG solver."                      SUTERR.......18900
        EX(1)="The CG solver may be used only for the flow (P) equation" SUTERR.......19000
        EX(2)="with no upstream weighting (UP=0.0).  It may not be used" SUTERR.......19100
        EX(3)="for the transport (U) equation."                          SUTERR.......19200
C     ERROR CODE 'INP-7B&C-4' IS NO LONGER USED.                         SUTERR.......19300
      ELSE IF (ERRCOD.EQ.'INP-3,19-1') THEN                              SUTERR.......19700
        DS(1)="The actual number of specified pressure nodes, "          SUTERR.......19800
     1        // CINERR(1) // ","                                        SUTERR.......19900
        DS(2)="does not equal the input value,                "          SUTERR.......20000
     1        // CINERR(2) // "."                                        SUTERR.......20100
        EX(1)="In dataset 3 of the main input file, the variable NPBC"   SUTERR.......20200
        EX(2)="must specify the exact number of specified pressure"      SUTERR.......20300
        EX(3)="nodes listed in dataset 19."                              SUTERR.......20400
      ELSE IF (ERRCOD.EQ.'INP-3,20-1') THEN                              SUTERR.......20500
        DS(1)="The actual number of specified conc. nodes, "             SUTERR.......20600
     1        // CINERR(1) // ","                                        SUTERR.......20700
        DS(2)="does not equal the input value,             "             SUTERR.......20800
     1        // CINERR(2) // "."                                        SUTERR.......20900
        EX(1)="In dataset 3 of the main input file, the variable NUBC"   SUTERR.......21000
        EX(2)="must specify the exact number of specified concentration" SUTERR.......21100
        EX(3)="nodes listed in dataset 20."                              SUTERR.......21200
      ELSE IF (ERRCOD.EQ.'INP-3,20-2') THEN                              SUTERR.......21300
        DS(1)="The actual number of specified temp. nodes, "             SUTERR.......21400
     1        // CINERR(1) // ","                                        SUTERR.......21500
        DS(2)="does not equal the input value,             "             SUTERR.......21600
     1        // CINERR(2) // "."                                        SUTERR.......21700
        EX(1)="In dataset 3 of the main input file, the variable NUBC"   SUTERR.......21800
        EX(2)="must specify the exact number of specified temperature"   SUTERR.......21900
        EX(3)="nodes listed in dataset 20."                              SUTERR.......22000
      ELSE IF (ERRCOD.EQ.'INP-22-1') THEN                                SUTERR.......22100
        DS(1)="Line 1 of the element incidence data does not begin with" SUTERR.......22200
        DS(2)="the word 'INCIDENCE'."                                    SUTERR.......22300
        EX(1)="In dataset 22 of the main input file, the first line"     SUTERR.......22400
        EX(2)="must begin with the word 'INCIDENCE'."                    SUTERR.......22500
      ELSE IF (ERRCOD.EQ.'INP-22-2') THEN                                SUTERR.......22600
        DS(1)="The incidence data for element " // CINERR(1)             SUTERR.......22700
        DS(2)="are not in numerical order in the dataset."               SUTERR.......22800
        EX(1)="In dataset 22 of the main input file, incidence data"     SUTERR.......22900
        EX(2)="must be listed in order of increasing element number."    SUTERR.......23000
        EX(3)="Note that the numbering of elements must begin at 1"      SUTERR.......23100
        EX(4)="and be continuous; element numbers may not be skipped."   SUTERR.......23200
      ELSE IF (ERRCOD.EQ.'INP-14B,22-1') THEN                            SUTERR.......23300
        DS(1)="At least one element has incorrect geometry."             SUTERR.......23400
        EX(1)="Incorrect element geometry can result from improper"      SUTERR.......23500
        EX(2)="specification of node coordinates in dataset 14B of the"  SUTERR.......23600
        EX(3)="main input file, or from improper ordering of nodes in"   SUTERR.......23700
        EX(4)="a node incidence list in dataset 22 of the same file."    SUTERR.......23800
      ELSE IF (ERRCOD.EQ.'FIL-1') THEN                                   SUTERR.......23900
        DS(1)="The file " // CHERR(2)                                    SUTERR.......24000
        DS(2)="does not exist."                                          SUTERR.......24100
        EX(1)="One of the files required by SUTRA does not exist."       SUTERR.......24200
        EX(2)="Check the filename and the directory path."               SUTERR.......24300
      ELSE IF (ERRCOD.EQ.'FIL-2') THEN                                   SUTERR.......24400
        DS(1)="The file " // CHERR(2)                                    SUTERR.......24500
        DS(2)="could not be opened on FORTRAN unit " // CINERR(1) // "." SUTERR.......24600
        EX(1)="One of the files required by SUTRA could not be opened."  SUTERR.......24700
        EX(2)="Check to make sure the file is not protected or in use"   SUTERR.......24800
        EX(3)="by another application, and that the FORTRAN unit number" SUTERR.......24900
        EX(4)="is valid."                                                SUTERR.......25000
      ELSE IF (ERRCOD.EQ.'FIL-3') THEN                                   SUTERR.......25100
        DS(1)="An attempt was made to use"                               SUTERR.......25200
        DS(2)="FORTRAN unit number " // CINERR(1)                        SUTERR.......25250
        DS(3)="for more than one purpose simultaneously."                SUTERR.......25300
        DS(4)="The filenames involved are:"                              SUTERR.......25350
        DS(5)=CHERR(2)                                                   SUTERR.......25400
        DS(6)=CHERR(3)                                                   SUTERR.......25450
        EX(1)='Each FORTRAN unit number used in "SUTRA.FIL" must be'     SUTERR.......25500
        EX(2)='unique and may not be reused in an "@INSERT" statement.'  SUTERR.......25550
        EX(3)='Also, if you have nested "@INSERT" statements'            SUTERR.......25600
        EX(4)='(i.e., a file inserted into a file, which is itself'      SUTERR.......25650
        EX(5)='inserted into a file, etc.), a given unit number may'     SUTERR.......25700
        EX(6)='be used only once in the nested sequence.'                SUTERR.......25750
      ELSE IF (ERRCOD.EQ.'FIL-4') THEN                                   SUTERR.......25800
        DS(1)="An attempt was made to use the file"                      SUTERR.......25850
        DS(2)=CHERR(2)                                                   SUTERR.......25900
        DS(3)="for more than one purpose simultaneously."                SUTERR.......25950
        EX(1)='Each filename listed in "SUTRA.FIL" must be unique'       SUTERR.......26000
        EX(2)='and may not be reused in an "@INSERT" statement.'         SUTERR.......26050
        EX(3)='Also, if you have nested "@INSERT" statements'            SUTERR.......26100
        EX(4)='(i.e., a file inserted into a file, which is itself'      SUTERR.......26150
        EX(5)='inserted into a file, etc.), a given file may be'         SUTERR.......26200
        EX(6)='used only once in the nested sequence.'                   SUTERR.......26250
      ELSE IF (ERRCOD.EQ.'FIL-5') THEN                                   SUTERR.......26300
        DS(1)="Invalid file type: " // CHERR(2)                          SUTERR.......26400
        EX(1)="Valid file types are:"                                    SUTERR.......26500
        EX(2)='   INP (".inp" input file)'                               SUTERR.......26600
        EX(3)='   ICS (".ics" input file)'                               SUTERR.......26700
        EX(4)='   SMY (".smy" output file)'                              SUTERR.......26800
        EX(5)='   LST (".lst" output file)'                              SUTERR.......26900
        EX(6)='   RST (".rst" output file)'                              SUTERR.......27000
        EX(7)='   NOD (".nod" output file)'                              SUTERR.......27100
        EX(8)='   ELE (".ele" output file)'                              SUTERR.......27200
        EX(9)='   OBS (".obs" output file)'                              SUTERR.......27300
      ELSE IF (ERRCOD.EQ.'FIL-6') THEN                                   SUTERR.......27400
        DS(1)="File type " // CHERR(2)                                   SUTERR.......27500
        DS(2)="has been assigned more than once."                        SUTERR.......27600
        EX(1)="The following file types must be assigned:"               SUTERR.......27700
        EX(2)='   INP (".inp" input file)'                               SUTERR.......27800
        EX(3)='   ICS (".ics" input file)'                               SUTERR.......27900
        EX(4)='   LST (".lst" output file)'                              SUTERR.......28000
        EX(5)='   RST (".rst" output file)'                              SUTERR.......28100
        EX(6)="The following file types are optional:"                   SUTERR.......28200
        EX(7)='   SMY (".smy" output file; defaults to "SUTRA.SMY")'     SUTERR.......28300
        EX(8)='   NOD (".nod" output file)'                              SUTERR.......28400
        EX(9)='   ELE (".ele" output file)'                              SUTERR.......28500
        EX(10)='   OBS (".obs" output file)'                             SUTERR.......28600
        EX(11)="No file type may be assigned more than once."            SUTERR.......28700
      ELSE IF (ERRCOD.EQ.'FIL-7') THEN                                   SUTERR.......28800
        DS(1)="Required file type " // CHERR(2)                          SUTERR.......28900
        DS(2)="has not been assigned."                                   SUTERR.......29000
        EX(1)="The following file types must be assigned:"               SUTERR.......29100
        EX(2)='   INP (".inp" input file)'                               SUTERR.......29200
        EX(3)='   ICS (".ics" input file)'                               SUTERR.......29300
        EX(4)='   LST (".lst" output file)'                              SUTERR.......29400
        EX(5)='   RST (".rst" output file)'                              SUTERR.......29500
        EX(6)="The following file types are optional:"                   SUTERR.......29600
        EX(7)='   SMY (".smy" output file; defaults to "SUTRA.SMY")'     SUTERR.......29700
        EX(8)='   NOD (".nod" output file)'                              SUTERR.......29800
        EX(9)='   ELE (".ele" output file)'                              SUTERR.......29900
        EX(10)='   OBS (".obs" output file)'                             SUTERR.......30000
        EX(11)="No file type may be assigned more than once."            SUTERR.......30100
      ELSE IF (ERRCOD.EQ.'FIL-8') THEN                                   SUTERR.......30100
        DS(1)="The file " // CHERR(2)                                    SUTERR.......30120
        DS(2)="could not be inserted. Inserts cannot be nested"          SUTERR.......30140
        DS(3)="more than 20 levels deep."                                SUTERR.......30160
      ELSE IF (ERRCOD.EQ.'INP-6-1') THEN                                 SUTERR.......30200
        DS(1)="NPCYC<1 and/or NUCYC<1."                                  SUTERR.......30300
        EX(1)="In dataset 6 of the main input file, both NPCYC and"      SUTERR.......30400
        EX(2)="NUCYC must be set greater than or equal to 1."            SUTERR.......30500
      ELSE IF (ERRCOD.EQ.'INP-6-2') THEN                                 SUTERR.......30600
        DS(1)="Neither NPCYC nor NUCYC is set to 1."                     SUTERR.......30700
        EX(1)="In dataset 6 of the main input file, either NPCYC or"     SUTERR.......30800
        EX(2)="NUCYC (or both) must be set to 1."                        SUTERR.......30900
      ELSE IF (ERRCOD.EQ.'INP-6-3') THEN                                 SUTERR.......31000
        DS(1)="DELT is greater than DTMAX."                              SUTERR.......31100
        EX(1)="In dataset 6 of the main input file, DELT must be set"    SUTERR.......31200
        EX(2)="less than or equal to DTMAX."                             SUTERR.......31300
      ELSE IF ((ERRCOD.EQ.'INP-8A-1').OR.(ERRCOD.EQ.'INP-8A-2')          SUTERR.......31400
     1     .OR.(ERRCOD.EQ.'INP-8A-3').OR.(ERRCOD.EQ.'INP-8A-4')          SUTERR.......31500
     1     .OR.(ERRCOD.EQ.'INP-8A-5').OR.(ERRCOD.EQ.'INP-8A-6')          SUTERR.......31600
     1     .OR.(ERRCOD.EQ.'INP-8A-7')) THEN                              SUTERR.......31700
        DS(1)=CHERR(1)(1:6) // " is not 'Y' or 'N'."                     SUTERR.......31800
        EX(1)="In dataset 8A of the main input file, " // CHERR(1)(1:6)  SUTERR.......31900
        EX(2)="must be set to either 'Y' or 'N'."                        SUTERR.......32000
        EX(3)=" "                                                        SUTERR.......32100
        EX(4)="Example of a valid dataset 8A:"                           SUTERR.......32200
        EX(5)="10   'N'   'N'   'N'   'Y'   'Y'   'Y'   'Y'"             SUTERR.......32300
      ELSE IF (ERRCOD.EQ.'INP-8B-1') THEN                                SUTERR.......32400
        DS(1)="Node number listed in column other than column 1."        SUTERR.......32500
        EX(1)="In dataset 8B of the main input file, if the node number" SUTERR.......32600
        EX(2)="is to appear, it must appear only in column 1, i.e.,"     SUTERR.......32700
        EX(3)="only NCOL(1) can be set to 'N'."                          SUTERR.......32800
      ELSE IF (ERRCOD.EQ.'INP-8B-2') THEN                                SUTERR.......32900
        DS(1)="Specified that 'Z' be output for a 2D problem."           SUTERR.......33000
        EX(1)="In dataset 8B of the main input file, 'Z' can be listed"  SUTERR.......33100
        EX(2)="only if the problem is 3D."                               SUTERR.......33200
      ELSE IF (ERRCOD.EQ.'INP-8B-3') THEN                                SUTERR.......33300
        DS(1)="Unrecognized value for NCOL."                             SUTERR.......33400
        EX(1)="In dataset 8B of the main input file, the following"      SUTERR.......33500
        EX(2)="variables may be listed:"                                 SUTERR.......33600
        EX(3)=" "                                                        SUTERR.......33700
        EX(4)="'N'  =  node number (if used, it must appear first)"      SUTERR.......33800
        EX(5)="'X'  =  X-coordinate of node"                             SUTERR.......33900
        EX(6)="'Y'  =  Y-coordinate of node"                             SUTERR.......34000
        EX(7)="'Z'  =  Z-coordinate of node (3D only)"                   SUTERR.......34100
        EX(8)="'P'  =  pressure"                                         SUTERR.......34200
        EX(9)="'U'  =  concentration or temperature"                     SUTERR.......34300
        EX(10)="'S'  =  saturation"                                      SUTERR.......34400
        EX(11)=" "                                                       SUTERR.......34500
        EX(12)="The symbol '-' (a single dash) is used to end the list." SUTERR.......34600
        EX(13)="Any symbols following '-' are ignored."                  SUTERR.......34700
        EX(14)=" "                                                       SUTERR.......34800
        EX(15)="Example of a valid dataset 8B for a 3D problem:"         SUTERR.......34900
        EX(16)="10  'N'  'X'  'Y'  'Z'  'S'  'U'  '-'"                   SUTERR.......35000
      ELSE IF (ERRCOD.EQ.'INP-8C-1') THEN                                SUTERR.......35100
        DS(1)="Element number listed in column other than column 1."     SUTERR.......35200
        EX(1)="In dataset 8C of the main input file, if the element"     SUTERR.......35300
        EX(2)="number is to appear, it must appear only in column 1,"    SUTERR.......35400
        EX(3)="i.e., only LCOL(1) can be set to 'E'."                    SUTERR.......35500
      ELSE IF (ERRCOD.EQ.'INP-8C-2') THEN                                SUTERR.......35600
        DS(1)="Specified that 'Z' be output for a 2D problem."           SUTERR.......35700
        EX(1)="In dataset 8C of the main input file, 'Z' can be listed"  SUTERR.......35800
        EX(2)="only if the problem is 3D."                               SUTERR.......35900
      ELSE IF (ERRCOD.EQ.'INP-8C-3') THEN                                SUTERR.......36000
        DS(1)="Unrecognized value for LCOL."                             SUTERR.......36100
        EX(1)="In dataset 8C of the main input file, the following"      SUTERR.......36200
        EX(2)="variables may be listed:"                                 SUTERR.......36300
        EX(3)=" "                                                        SUTERR.......36400
        EX(4)="'E'  =  element number (if used, it must appear first)"   SUTERR.......36500
        EX(5)="'X'  =  X-coordinate of element centroid"                 SUTERR.......36600
        EX(6)="'Y'  =  Y-coordinate of element centroid"                 SUTERR.......36700
        EX(7)="'Z'  =  Z-coordinate of element centroid (3D only)"       SUTERR.......36800
        EX(8)="'VX'  =  X-component of fluid velocity"                   SUTERR.......36900
        EX(9)="'VY'  =  Y-component of fluid velocity"                   SUTERR.......37000
        EX(10)="'VZ'  =  Z-component of fluid velocity (3D only)"        SUTERR.......37100
        EX(11)=" "                                                       SUTERR.......37200
        EX(12)="The symbol '-' (a single dash) is used to end the list." SUTERR.......37300
        EX(13)="Any symbols following '-' are ignored."                  SUTERR.......37400
        EX(14)=" "                                                       SUTERR.......37500
        EX(15)="Example of a valid dataset 8B for a 3D problem:"         SUTERR.......37600
        EX(16)="10  'E'  'X'  'Y'  'Z'  'VX'  'VY'  'VZ'  '-'"           SUTERR.......37700
      ELSE IF (ERRCOD.EQ.'INP-8C-4') THEN                                SUTERR.......37800
        DS(1)="Specified that 'VZ' be output for a 2D problem."          SUTERR.......37900
        EX(1)="In dataset 8C of the main input file, 'VZ' can be listed" SUTERR.......38000
        EX(2)="only if the problem is 3D."                               SUTERR.......38100
      ELSE IF (ERRCOD.EQ.'INP-8D-1') THEN                                SUTERR.......38200
        DS(1)="The actual number of observation nodes listed does not"   SUTERR.......38300
        DS(2)="equal the input value, or the observation node list"      SUTERR.......38400
        DS(3)="does not end with a zero."                                SUTERR.......38500
        EX(1)="In dataset 8D of the main input file, the number of"      SUTERR.......38600
        EX(2)="nodes listed must equal the number, NOBS, specified in"   SUTERR.......38700
        EX(3)="dataset 3 of the same file, and a zero must appear after" SUTERR.......38800
        EX(4)="the last node in the list.  Any information appearing"    SUTERR.......38900
        EX(5)="after the zero is ignored."                               SUTERR.......39000
        EX(6)=" "                                                        SUTERR.......39100
        EX(7)="Example of a valid dataset 8D with three observation"     SUTERR.......39200
        EX(8)="nodes (45, 46, and 7347):"                                SUTERR.......39300
        EX(9)="10   45   46   7347   0"                                  SUTERR.......39400
      ELSE IF (ERRCOD.EQ.'INP-8D-2') THEN                                SUTERR.......39500
        DS(1)="The observation node list contains a node number that"    SUTERR.......39600
        DS(2)="is negative or zero."                                     SUTERR.......39700
        EX(1)="In dataset 8D of the main input file, all node numbers"   SUTERR.......39800
        EX(2)="must be positive.  The last entry must be a zero, which"  SUTERR.......39900
        EX(3)="signals the end of the list."                             SUTERR.......40000
        EX(4)=" "                                                        SUTERR.......40100
        EX(5)="Example of a valid dataset 8D with three observation"     SUTERR.......40200
        EX(6)="nodes (45, 46, and 7347):"                                SUTERR.......40300
        EX(7)="10   45   46   7347   0"                                  SUTERR.......40400
      ELSE IF (ERRCOD.EQ.'INP-11-1') THEN                                SUTERR.......40500
        DS(1)="Unrecognized sorption model."                             SUTERR.......40600
        EX(1)="In dataset 11 of the main input file, the sorption model" SUTERR.......40700
        EX(2)="may be chosen from the following:"                        SUTERR.......40800
        EX(3)=" "                                                        SUTERR.......40900
        EX(4)="'NONE'       =  No sorption"                              SUTERR.......41000
        EX(5)="'LINEAR'     =  Linear sorption model"                    SUTERR.......41100
        EX(6)="'FREUNDLICH' =  Freundlich sorption model"                SUTERR.......41200
        EX(7)="'LANGMUIR'   =  Langmuir sorption model"                  SUTERR.......41300
      ELSE IF (ERRCOD.EQ.'INP-11-2') THEN                                SUTERR.......41400
        DS(1)="The second Freundlich sorption coefficient is less than"  SUTERR.......41500
        DS(2)="or equal to zero."                                        SUTERR.......41600
        EX(1)="In dataset 11 of the main input file, the second"         SUTERR.......41700
        EX(2)="coefficient, CHI2, must be positive if Freundlich"        SUTERR.......41800
        EX(3)="sorption is chosen."                                      SUTERR.......41900
      ELSE IF (ERRCOD.EQ.'INP-14A-1') THEN                               SUTERR.......42000
        DS(1)="Dataset 14A does not begin with the word 'NODE'."         SUTERR.......42100
        EX(1)="Dataset 14A of the main input file must begin with the"   SUTERR.......42200
        EX(2)="word 'NODE'."                                             SUTERR.......42300
        EX(3)=" "                                                        SUTERR.......42400
        EX(4)="Example of a valid dataset 14A:"                          SUTERR.......42500
        EX(5)="'NODE'  1000.  1000.  1.  0.1"                            SUTERR.......42600
      ELSE IF (ERRCOD.EQ.'INP-15A-1') THEN                               SUTERR.......42700
        DS(1)="Dataset 15A does not begin with the word 'ELEMENT'."      SUTERR.......42800
        EX(1)="Dataset 15A of the main input file must begin with the"   SUTERR.......42900
        EX(2)="word 'ELEMENT'."                                          SUTERR.......43000
        EX(3)=" "                                                        SUTERR.......43100
        EX(4)="Example of a valid dataset 15A for a " // CHERR(1)(1:2)   SUTERR.......43200
     1         // " problem:"                                            SUTERR.......43300
        IF (CHERR(1).EQ."3D") THEN                                       SUTERR.......43400
          EX(5)="'ELEMENT' 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1. 1." SUTERR.......43500
        ELSE                                                             SUTERR.......43600
          EX(5)="'ELEMENT' 1. 1. 1. 1. 1. 1. 1."                         SUTERR.......43700
        END IF                                                           SUTERR.......43800
      ELSE IF (ERRCOD.EQ.'ICS-2-1') THEN                                 SUTERR.......43900
        DS(1)="Unrecognized initialization type."                        SUTERR.......44000
        EX(1)="In dataset 2 of the initial conditions input file,"       SUTERR.......44100
        EX(2)="the valid types of initializations for P are UNIFORM"     SUTERR.......44200
        EX(3)="and NONUNIFORM."                                          SUTERR.......44300
      ELSE IF (ERRCOD.EQ.'ICS-2-2') THEN                                 SUTERR.......44400
        DS(1)="Did not specify NONUNIFORM initial values during a WARM"  SUTERR.......44500
        DS(2)="start."                                                   SUTERR.......44600
        EX(1)="In dataset 2 of the initial conditions input file,"       SUTERR.......44700
        EX(2)="initial values for P must be specified as NONUNIFORM"     SUTERR.......44800
        EX(3)="during a WARM start (i.e., if CREAD='WARM' in dataset 4"  SUTERR.......44900
        EX(4)="of the main input file)."                                 SUTERR.......45000
      ELSE IF (ERRCOD.EQ.'ICS-3-1') THEN                                 SUTERR.......45100
        DS(1)="Unrecognized initialization type."                        SUTERR.......45200
        EX(1)="In dataset 3 of the initial conditions input file,"       SUTERR.......45300
        EX(2)="the valid types of initializations for U are UNIFORM"     SUTERR.......45400
        EX(3)="and NONUNIFORM."                                          SUTERR.......45500
      ELSE IF (ERRCOD.EQ.'ICS-3-2') THEN                                 SUTERR.......45600
        DS(1)="Did not specify NONUNIFORM initial values during a WARM"  SUTERR.......45700
        DS(2)="start."                                                   SUTERR.......45800
        EX(1)="In dataset 3 of the initial conditions input file,"       SUTERR.......45900
        EX(2)="initial values for U must be specified as NONUNIFORM"     SUTERR.......46000
        EX(3)="during a WARM start (i.e., if CREAD='WARM' in dataset 4"  SUTERR.......46100
        EX(4)="of the main input file)."                                 SUTERR.......46200
      ELSE IF (ERRCOD.EQ.'SOL-1') THEN                                   SUTERR.......46300
        DS(1)="Error returned by the " // CHERR(2)(1:10)                 SUTERR.......46400
        DS(2)="solver while solving for " // CHERR(1)(1:1) // "."        SUTERR.......46500
        EX(1)="The iterative solver has stopped because of an error."    SUTERR.......46600
        EX(2)="Error flag values are interpreted as follows:"            SUTERR.......46700
        EX(3)="  "                                                       SUTERR.......46800
        EX(4)="IERR = 2  =>  Method stalled or failed to converge in"    SUTERR.......46900
        EX(5)="              the maximum number of iterations allowed."  SUTERR.......47000
        EX(6)="IERR = 4  =>  Convergence tolerance set too tight for"    SUTERR.......47100
        EX(7)="              machine precision."                         SUTERR.......47200
        EX(8)="IERR = 5  =>  Method broke down because preconditioning"  SUTERR.......47300
        EX(9)="              matrix is non-positive-definite."           SUTERR.......47400
        EX(10)="IERR = 6  =>  Method broke down because matrix is non-"  SUTERR.......47500
        EX(11)="              positive-definite or nearly so."           SUTERR.......47600
        EX(12)=" "                                                       SUTERR.......47700
        EX(13)="If the P-solution resulted in a solver error, an"        SUTERR.......47800
        EX(14)="attempt was still made to obtain a U-solution."          SUTERR.......47900
        EX(15)="The last P and U solutions were written to the"          SUTERR.......48000
        EX(16)="appropriate output files (except the restart file)"      SUTERR.......48100
        EX(17)="whether or not they resulted in solver errors."          SUTERR.......48200
      ELSE IF (ERRCOD.EQ.'INP-3,17-1') THEN                              SUTERR.......48300
        DS(1)="The actual number of"                                     SUTERR.......48400
        DS(2)="specified fluid source nodes,   " // CINERR(1) // ","     SUTERR.......48500
        DS(3)="does not equal the input value, " // CINERR(2) // "."     SUTERR.......48600
        EX(1)="In dataset 3 of the main input file, the variable NSOP"   SUTERR.......48700
        EX(2)="must specify the exact number of specified fluid source"  SUTERR.......48800
        EX(3)="nodes listed in dataset 17."                              SUTERR.......48900
      ELSE IF (ERRCOD.EQ.'INP-3,18-1') THEN                              SUTERR.......49000
        DS(1)="The actual number of"                                     SUTERR.......49100
        DS(2)="specified " // CHERR(1)(1:6) // " source nodes,  "        SUTERR.......49200
     1         // CINERR(1) // ","                                       SUTERR.......49300
        DS(3)="does not equal the input value, " // CINERR(2) // "."     SUTERR.......49400
        EX(1)="In dataset 3 of the main input file, the variable NSOU"   SUTERR.......49500
        EX(2)="must specify the exact number of specified "              SUTERR.......49600
     1         // CHERR(1)(1:6) // " source"                             SUTERR.......49700
        EX(3)="nodes listed in dataset 18."                              SUTERR.......49800
      ELSE IF (ERRCOD.EQ.'INP-17-1') THEN                                SUTERR.......49900
        DS(1)="Invalid node number referenced in dataset 17: "           SUTERR.......50000
     1         // CINERR(1)                                              SUTERR.......50100
        EX(1)="Dataset 17 of the main input file contains a reference"   SUTERR.......50200
        EX(2)="to a non-existent node number.  All node numbers must"    SUTERR.......50300
        EX(3)="be less than or equal to the total number of nodes,"      SUTERR.......50400
        EX(4)="NN = " // CINERR(2)                                       SUTERR.......50500
        EX(5)="(excluding the negative sign that precedes nodes with"    SUTERR.......50600
        EX(6)="time-dependent boundary conditions)."                     SUTERR.......50700
      ELSE IF (ERRCOD.EQ.'INP-18-1') THEN                                SUTERR.......50800
        DS(1)="Invalid node number referenced in dataset 18: "           SUTERR.......50900
     1         // CINERR(1)                                              SUTERR.......51000
        EX(1)="Dataset 18 of the main input file contains a reference"   SUTERR.......51100
        EX(2)="to a non-existent node number.  All node numbers must"    SUTERR.......51200
        EX(3)="be less than or equal to the total number of nodes,"      SUTERR.......51300
        EX(4)="NN = " // CINERR(2)                                       SUTERR.......51400
        EX(5)="(excluding the negative sign that precedes nodes with"    SUTERR.......51500
        EX(6)="time-dependent boundary conditions)."                     SUTERR.......51600
      ELSE IF (ERRCOD.EQ.'INP-19-1') THEN                                SUTERR.......51700
        DS(1)="Invalid node number referenced in dataset 19: "           SUTERR.......51800
     1         // CINERR(1)                                              SUTERR.......51900
        EX(1)="Dataset 19 of the main input file contains a reference"   SUTERR.......52000
        EX(2)="to a non-existent node number.  All node numbers must"    SUTERR.......52100
        EX(3)="be less than or equal to the total number of nodes,"      SUTERR.......52200
        EX(4)="NN = " // CINERR(2)                                       SUTERR.......52300
        EX(5)="(excluding the negative sign that precedes nodes with"    SUTERR.......52400
        EX(6)="time-dependent boundary conditions)."                     SUTERR.......52500
      ELSE IF (ERRCOD.EQ.'INP-20-1') THEN                                SUTERR.......52600
        DS(1)="Invalid node number referenced in dataset 20: "           SUTERR.......52700
     1         // CINERR(1)                                              SUTERR.......52800
        EX(1)="Dataset 20 of the main input file contains a reference"   SUTERR.......52900
        EX(2)="to a non-existent node number.  All node numbers must"    SUTERR.......53000
        EX(3)="be less than or equal to the total number of nodes,"      SUTERR.......53100
        EX(4)="NN = " // CINERR(2)                                       SUTERR.......53200
        EX(5)="(excluding the negative sign that precedes nodes with"    SUTERR.......53300
        EX(6)="time-dependent boundary conditions)."                     SUTERR.......53400
      ELSE IF (ERRCOD.EQ.'CON-1') THEN                                   SUTERR.......53500
        CDUM80 = 's'                                                     SUTERR.......53600
        IF (INERR(4).GT.13) THEN                                         SUTERR.......53700
           LDUM = 1                                                      SUTERR.......53800
        ELSE                                                             SUTERR.......53900
           LDUM = 0                                                      SUTERR.......54000
        END IF                                                           SUTERR.......54100
        DS(1)="Simulation terminated due to unconverged non-linearity"   SUTERR.......54200
        DS(2)="iterations.  Tolerance" // CDUM80(1:LDUM)                 SUTERR.......54300
     1         // " for " // CHERR(1)(1:INERR(4))                        SUTERR.......54400
        DS(3)="not reached."                                             SUTERR.......54500
        EX(1)="The " // CHERR(1)(1:INERR(4)) // " solution"              SUTERR.......54600
     1         // CDUM80(1:LDUM) // " failed"                            SUTERR.......54700
        EX(2)="to converge to the specified tolerance"                   SUTERR.......54800
     1         // CDUM80(1:LDUM) // " within"                            SUTERR.......54900
        EX(3)="the maximum number of iterations allowed to resolve"      SUTERR.......55000
        EX(4)="non-linearities.  The parameters that control these"      SUTERR.......55100
        EX(5)="iterations are set in dataset 7A of the main input file." SUTERR.......55200
      ELSE IF ((CODE(1).EQ.'REA').AND.                                   SUTERR.......55300
     1         ((CODE(2).EQ.'INP').OR.(CODE(2).EQ.'ICS'))) THEN          SUTERR.......55400
        IF (CODE(2).EQ.'INP') THEN                                       SUTERR.......55500
           CDUM80 = 'main input'                                         SUTERR.......55600
           LDUM = 10                                                     SUTERR.......55700
        ELSE                                                             SUTERR.......55800
           CDUM80 = 'initial conditions'                                 SUTERR.......55900
           LDUM = 18                                                     SUTERR.......56000
        END IF                                                           SUTERR.......56100
        IF ((CODE(2).EQ.'ICS').AND.(CODE(3).EQ.'4')) THEN                SUTERR.......56200
          DS(1)="FORTRAN returned an error while reading the restart"    SUTERR.......56300
          DS(2)="information following dataset 3 of the initial"         SUTERR.......56400
          DS(3)="conditions."                                            SUTERR.......56500
        ELSE IF (CODE(3).EQ.'INS') THEN                                  SUTERR.......56600
          CALL PRSWDS(CHERR(1), '-', 3, CODUM, NWORDS)                   SUTERR.......56700
          DS(1)="FORTRAN returned an error while reading an '@INSERT'"   SUTERR.......56800
          DS(2)="statement in the vicinity of dataset " // CODUM(3)(1:3) SUTERR.......56900
          DS(3)="of the " // CDUM80(1:LDUM) // "."                       SUTERR.......57000
        ELSE                                                             SUTERR.......57100
          DS(1)="FORTRAN returned an error while reading"                SUTERR.......57200
          DS(2)="dataset " // CODE(3)(1:3)                               SUTERR.......57300
     1           // " of the " // CDUM80(1:LDUM) // "."                  SUTERR.......57400
        END IF                                                           SUTERR.......57500
        EX(1)="A FORTRAN error has occurred while reading input data."   SUTERR.......58600
        EX(2)="Error status flag values are interpreted as follows:"     SUTERR.......58700
        EX(3)=" "                                                        SUTERR.......58800
        EX(4)="IOSTAT < 0  =>  The end of a line was reached before"     SUTERR.......58900
        EX(5)="                all the required data were read from"     SUTERR.......59000
        EX(6)="                that line.  Check the specified dataset"  SUTERR.......59100
        EX(7)="                for missing data."                        SUTERR.......59200
        EX(8)="IOSTAT > 0  =>  An error occurred while the specified"    SUTERR.......59300
        EX(9)="                dataset was being read.  Usually, this"   SUTERR.......59400
        EX(10)="                indicates that the READ statement"       SUTERR.......59500
        EX(11)="                encountered data of a type that is"      SUTERR.......59600
        EX(12)="                incompatible with the type it expected." SUTERR.......59700
        EX(13)="                Check the dataset for typographical"     SUTERR.......59800
        EX(14)="                errors and missing or extraneous data."  SUTERR.......59900
      ELSE IF ((CODE(1).EQ.'REA').AND.(CODE(2).EQ.'FIL')) THEN           SUTERR.......60000
        DS(1)='FORTRAN returned an error while reading "SUTRA.FIL".'     SUTERR.......60100
        EX(1)='A FORTRAN error has occurred while reading "SUTRA.FIL".'  SUTERR.......60200
        EX(2)="Error status flag values are interpreted as follows:"     SUTERR.......60300
        EX(3)=" "                                                        SUTERR.......60400
        EX(4)="IOSTAT < 0  =>  The end of a line was reached before"     SUTERR.......60500
        EX(5)="                all the required data were read from"     SUTERR.......60600
        EX(6)='                that line.  Check "SUTRA.FIL" for'        SUTERR.......60700
        EX(7)="                missing data."                            SUTERR.......60800
        EX(8)="IOSTAT > 0  =>  An error occurred while the input"        SUTERR.......60900
        EX(9)="                file was being read.  Usually, this"      SUTERR.......61000
        EX(10)="                indicates that the READ statement"       SUTERR.......61100
        EX(11)="                encountered data of a type that is"      SUTERR.......61200
        EX(12)="                incompatible with the type it expected." SUTERR.......61300
        EX(13)='                Check "SUTRA.FIL" for typographical'     SUTERR.......61400
        EX(14)="                errors and missing or extraneous data."  SUTERR.......61500
      END IF                                                             SUTERR.......61600
C                                                                        SUTERR.......61700
C.....WRITE ERROR MESSAGE.  FORMAT DEPENDS ON THE TYPE OF ERROR.         SUTERR.......61800
      IF ((CODE(1).EQ.'INP').OR.(CODE(1).EQ.'ICS')) THEN                 SUTERR.......61900
C........ERROR TYPES 'INP' AND 'ICS' (INPUT DATA ERROR)                  SUTERR.......62000
         IF (KSCRN.EQ.1)                                                 SUTERR.......62100
     1      WRITE (*,1888) '           INPUT DATA ERROR           '      SUTERR.......62200
         WRITE (K00,1888) '           INPUT DATA ERROR           '       SUTERR.......62300
         IF (KSCRN.EQ.1) WRITE (*,1011)                                  SUTERR.......62400
         WRITE (K00,1011)                                                SUTERR.......62500
 1011    FORMAT (/1X,'DESCRIPTION')                                      SUTERR.......62600
         IF (CODE(1).EQ.'INP') THEN                                      SUTERR.......62700
            CDUM80 = FNAME(1)                                            SUTERR.......62800
         ELSE                                                            SUTERR.......62900
            CDUM80 = FNAME(2)                                            SUTERR.......63000
         END IF                                                          SUTERR.......63100
         IF (KSCRN.EQ.1) WRITE (*,1013) ERRCOD, CDUM80, CODE(2)          SUTERR.......63200
         WRITE (K00,1013) ERRCOD, CDUM80, CODE(2)                        SUTERR.......63300
 1013    FORMAT (/4X,'Error code:',2X,A40                                SUTERR.......63400
     1           /4X,'File:      ',2X,A40                                SUTERR.......63500
     1           /4X,'Dataset(s):',2X,A40/)                              SUTERR.......63600
         DO 1015 I=1,50                                                  SUTERR.......63700
            IF (DS(I).EQ.'null_line') EXIT                               SUTERR.......63800
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') DS(I)                    SUTERR.......63900
            WRITE(K00,'(4X,A70)') DS(I)                                  SUTERR.......64000
 1015    CONTINUE                                                        SUTERR.......64100
         IF (KSCRN.EQ.1) WRITE (*,1021)                                  SUTERR.......64200
         WRITE (K00,1021)                                                SUTERR.......64300
 1021    FORMAT (/1X,'EXPLANATION'/)                                     SUTERR.......64400
         DO 1025 I=1,50                                                  SUTERR.......64500
            IF (EX(I).EQ.'null_line') EXIT                               SUTERR.......64600
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') EX(I)                    SUTERR.......64700
            WRITE(K00,'(4X,A70)') EX(I)                                  SUTERR.......64800
 1025    CONTINUE                                                        SUTERR.......64900
         IF (KSCRN.EQ.1) WRITE (*,1081)                                  SUTERR.......65000
         WRITE (K00,1081)                                                SUTERR.......65100
 1081    FORMAT (/1X,'GENERAL NOTE'/                                     SUTERR.......65200
     1     /4X,'If the dataset for which SUTRA has reported an error'    SUTERR.......65300
     1     /4X,'appears to be correct, check the preceding lines'        SUTERR.......65400
     1     /4X,'for missing data or extraneous characters.')             SUTERR.......65500
      ELSE IF (CODE(1).EQ.'FIL') THEN                                    SUTERR.......65600
C........ERROR TYPE 'FIL' (FILE ERROR)                                   SUTERR.......65700
         IF (KSCRN.EQ.1)                                                 SUTERR.......65800
     1      WRITE (*,1888)'              FILE ERROR              '       SUTERR.......65900
         WRITE (K00,1888) '              FILE ERROR              '       SUTERR.......66000
         IF (KSCRN.EQ.1) WRITE (*,1211)                                  SUTERR.......66100
         WRITE (K00,1211)                                                SUTERR.......66200
 1211    FORMAT (/1X,'DESCRIPTION')                                      SUTERR.......66300
         IF (KSCRN.EQ.1) WRITE (*,1213) ERRCOD, CHERR(1)                 SUTERR.......66400
         WRITE (K00,1213) ERRCOD, CHERR(1)                               SUTERR.......66500
 1213    FORMAT (/4X,'Error code:',2X,A40                                SUTERR.......66600
     1           /4X,'File:      ',2X,A40/)                              SUTERR.......66700
         DO 1215 I=1,50                                                  SUTERR.......66800
            IF (DS(I).EQ.'null_line') EXIT                               SUTERR.......66900
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') DS(I)                    SUTERR.......67000
            WRITE(K00,'(4X,A70)') DS(I)                                  SUTERR.......67100
 1215    CONTINUE                                                        SUTERR.......67200
         IF (KSCRN.EQ.1) WRITE (*,1221)                                  SUTERR.......67300
         WRITE (K00,1221)                                                SUTERR.......67400
 1221    FORMAT (/1X,'EXPLANATION'/)                                     SUTERR.......67500
         DO 1225 I=1,50                                                  SUTERR.......67600
            IF (EX(I).EQ.'null_line') EXIT                               SUTERR.......67700
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') EX(I)                    SUTERR.......67800
            WRITE(K00,'(4X,A70)') EX(I)                                  SUTERR.......67900
 1225    CONTINUE                                                        SUTERR.......68000
      ELSE IF (CODE(1).EQ.'SOL') THEN                                    SUTERR.......68100
C........ERROR TYPE 'SOL' (MATRIX SOLVER ERROR)                          SUTERR.......68200
         IF (KSCRN.EQ.1)                                                 SUTERR.......68300
     1      WRITE (*,1888) '         MATRIX SOLVER ERROR          '      SUTERR.......68400
         WRITE (K00,1888) '         MATRIX SOLVER ERROR          '       SUTERR.......68500
         IF (KSCRN.EQ.1) WRITE (*,1311)                                  SUTERR.......68600
         WRITE (K00,1311)                                                SUTERR.......68700
 1311    FORMAT (/1X,'DESCRIPTION')                                      SUTERR.......68800
         IF (KSCRN.EQ.1) WRITE (*,1313) ERRCOD, CHERR(2),                SUTERR.......68900
     1      INERR(1), INERR(2), RLERR(1), RLERR(2)                       SUTERR.......69000
         WRITE (K00,1313) ERRCOD, CHERR(2), INERR(1), INERR(2),          SUTERR.......69100
     1      RLERR(1), RLERR(2)                                           SUTERR.......69200
 1313    FORMAT (/4X,'Error code:',2X,A40                                SUTERR.......69300
     1           /4X,'Solver:    ',2X,A40                                SUTERR.......69400
     1          //4X,'Error flag..........IERR = ',I3                    SUTERR.......69500
     1           /4X,'# of solver iters...ITRS = ',I5                    SUTERR.......69600
     1           /4X,'Error estimate.......ERR = ',1PE8.1                SUTERR.......69700
     1           /4X,'Error tolerance......TOL = ',1PE8.1/)              SUTERR.......69800
         DO 1315 I=1,50                                                  SUTERR.......69900
            IF (DS(I).EQ.'null_line') EXIT                               SUTERR.......70000
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') DS(I)                    SUTERR.......70100
            WRITE(K00,'(4X,A70)') DS(I)                                  SUTERR.......70200
 1315    CONTINUE                                                        SUTERR.......70300
         IF (KSCRN.EQ.1) WRITE (*,1321)                                  SUTERR.......70400
         WRITE (K00,1321)                                                SUTERR.......70500
 1321    FORMAT (/1X,'EXPLANATION'/)                                     SUTERR.......70600
         DO 1325 I=1,50                                                  SUTERR.......70700
            IF (EX(I).EQ.'null_line') EXIT                               SUTERR.......70800
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') EX(I)                    SUTERR.......70900
            WRITE(K00,'(4X,A70)') EX(I)                                  SUTERR.......71000
 1325    CONTINUE                                                        SUTERR.......71100
      ELSE IF (CODE(1).EQ.'CON') THEN                                    SUTERR.......71200
C........ERROR TYPE 'CON' (CONVERGENCE ERROR)                            SUTERR.......71300
         IF (KSCRN.EQ.1)                                                 SUTERR.......71400
     1      WRITE (*,1888) '          CONVERGENCE ERROR           '      SUTERR.......71500
         WRITE (K00,1888) '         CONVERGENCE ERROR          '         SUTERR.......71600
         IF (KSCRN.EQ.1) WRITE (*,1411)                                  SUTERR.......71700
         WRITE (K00,1411)                                                SUTERR.......71800
 1411    FORMAT (/1X,'DESCRIPTION')                                      SUTERR.......71900
         IF (KSCRN.EQ.1) WRITE (*,1413) ERRCOD, CHERR(1), INERR(3),      SUTERR.......72000
     1       RLERR(1), INERR(1), RLERR(2), RLERR(3), INERR(2), RLERR(4)  SUTERR.......72100
         WRITE (K00,1413) ERRCOD, CHERR(1), INERR(3),                    SUTERR.......72200
     1       RLERR(1), INERR(1), RLERR(2), RLERR(3), INERR(2), RLERR(4)  SUTERR.......72300
 1413    FORMAT (/4X,'Error code: ',2X,A40                               SUTERR.......72400
     1           /4X,'Unconverged:',2X,A40                               SUTERR.......72500
     1      //4X,'# of iterations.....ITER = ',I5                        SUTERR.......72600
     1       /4X,'Maximum P change.....RPM = ',1PD14.5,' (node ',I9,')'  SUTERR.......72700
     1       /4X,'Tolerance for P....RPMAX = ',1PD14.5                   SUTERR.......72800
     1       /4X,'Maximum U change.....RUM = ',1PD14.5,' (node ',I9,')'  SUTERR.......72900
     1       /4X,'Tolerance for U....RUMAX = ',1PD14.5/)                 SUTERR.......73000
         DO 1415 I=1,50                                                  SUTERR.......73100
            IF (DS(I).EQ.'null_line') EXIT                               SUTERR.......73200
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') DS(I)                    SUTERR.......73300
            WRITE(K00,'(4X,A70)') DS(I)                                  SUTERR.......73400
 1415    CONTINUE                                                        SUTERR.......73500
         IF (KSCRN.EQ.1) WRITE (*,1421)                                  SUTERR.......73600
         WRITE (K00,1421)                                                SUTERR.......73700
 1421    FORMAT (/1X,'EXPLANATION'/)                                     SUTERR.......73800
         DO 1425 I=1,50                                                  SUTERR.......73900
            IF (EX(I).EQ.'null_line') EXIT                               SUTERR.......74000
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') EX(I)                    SUTERR.......74100
            WRITE(K00,'(4X,A70)') EX(I)                                  SUTERR.......74200
 1425    CONTINUE                                                        SUTERR.......74300
      ELSE IF ((CODE(1).EQ.'REA').AND.                                   SUTERR.......74400
     1         ((CODE(2).EQ.'INP').OR.(CODE(2).EQ.'ICS'))) THEN          SUTERR.......74500
C........ERROR TYPE 'REA-INP' OR 'REA-ICS' (FORTRAN READ ERROR)          SUTERR.......74600
         IF (KSCRN.EQ.1)                                                 SUTERR.......74700
     1      WRITE (*,1888) '          FORTRAN READ ERROR          '      SUTERR.......74800
         WRITE (K00,1888) '          FORTRAN READ ERROR          '       SUTERR.......74900
         IF (KSCRN.EQ.1) WRITE (*,1511)                                  SUTERR.......75000
         WRITE (K00,1511)                                                SUTERR.......75100
 1511    FORMAT (/1X,'DESCRIPTION')                                      SUTERR.......75200
         IF (CODE(2).EQ.'INP') THEN                                      SUTERR.......75300
            CDUM80 = FNAME(1)                                            SUTERR.......75400
         ELSE                                                            SUTERR.......75500
            CDUM80 = FNAME(2)                                            SUTERR.......75600
         END IF                                                          SUTERR.......75700
         IF (((CODE(2).EQ.'ICS').AND.(CODE(3).EQ.'4')).OR.               SUTERR.......75800
     1       (CODE(3).EQ.'INS')) THEN                                    SUTERR.......75850
           IF (KSCRN.EQ.1) WRITE (*,1513) ERRCOD, CDUM80, INERR(1)       SUTERR.......75900
           WRITE (K00,1513) ERRCOD, CDUM80, INERR(1)                     SUTERR.......76000
 1513      FORMAT (/4X,'Error code:',2X,A40                              SUTERR.......76100
     1             /4X,'File:      ',2X,A40                              SUTERR.......76200
     1            //4X,'Error status flag.....IOSTAT = ',I5/)            SUTERR.......76300
         ELSE                                                            SUTERR.......76400
           IF (KSCRN.EQ.1) WRITE (*,1514) ERRCOD, CDUM80, CODE(3)(1:3),  SUTERR.......76500
     1        INERR(1)                                                   SUTERR.......76600
           WRITE (K00,1514) ERRCOD, CDUM80, CODE(3)(1:3), INERR(1)       SUTERR.......76700
 1514      FORMAT (/4X,'Error code:',2X,A40                              SUTERR.......76800
     1             /4X,'File:      ',2X,A40                              SUTERR.......76900
     1             /4X,'Dataset:   ',2X,A3                               SUTERR.......77000
     1            //4X,'Error status flag.....IOSTAT = ',I5/)            SUTERR.......77100
         END IF                                                          SUTERR.......77200
         DO 1515 I=1,50                                                  SUTERR.......77300
            IF (DS(I).EQ.'null_line') EXIT                               SUTERR.......77400
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') DS(I)                    SUTERR.......77500
            WRITE(K00,'(4X,A70)') DS(I)                                  SUTERR.......77600
 1515    CONTINUE                                                        SUTERR.......77700
         IF (KSCRN.EQ.1) WRITE (*,1521)                                  SUTERR.......77800
         WRITE (K00,1521)                                                SUTERR.......77900
 1521    FORMAT (/1X,'EXPLANATION'/)                                     SUTERR.......78000
         DO 1525 I=1,50                                                  SUTERR.......78100
            IF (EX(I).EQ.'null_line') EXIT                               SUTERR.......78200
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') EX(I)                    SUTERR.......78300
            WRITE(K00,'(4X,A70)') EX(I)                                  SUTERR.......78400
 1525    CONTINUE                                                        SUTERR.......78500
         IF (KSCRN.EQ.1) WRITE (*,1581)                                  SUTERR.......78600
         WRITE (K00,1581)                                                SUTERR.......78700
 1581    FORMAT (/1X,'GENERAL NOTE'/                                     SUTERR.......78800
     1     /4X,'If the dataset for which SUTRA has reported an error'    SUTERR.......78900
     1     /4X,'appears to be correct, check the preceding lines'        SUTERR.......79000
     1     /4X,'for missing data or extraneous characters.')             SUTERR.......79100
      ELSE IF ((CODE(1).EQ.'REA').AND.(CODE(2).EQ.'FIL')) THEN           SUTERR.......79200
C........ERROR TYPE 'REA-FIL' (FORTRAN READ ERROR)                       SUTERR.......79300
         IF (KSCRN.EQ.1)                                                 SUTERR.......79400
     1      WRITE (*,1888) '          FORTRAN READ ERROR          '      SUTERR.......79500
         WRITE (K00,1888) '          FORTRAN READ ERROR          '       SUTERR.......79600
         IF (KSCRN.EQ.1) WRITE (*,1611)                                  SUTERR.......79700
         WRITE (K00,1611)                                                SUTERR.......79800
 1611    FORMAT (/1X,'DESCRIPTION')                                      SUTERR.......79900
         IF (KSCRN.EQ.1) WRITE (*,1613) ERRCOD, INERR(1)                 SUTERR.......80000
         WRITE (K00,1613) ERRCOD, INERR(1)                               SUTERR.......80100
 1613    FORMAT (/4X,'Error code:',2X,A40                                SUTERR.......80200
     1           /4X,'File:      ',2X,'SUTRA.FIL'                        SUTERR.......80300
     1          //4X,'Error status flag.....IOSTAT = ',I5/)              SUTERR.......80400
         DO 1615 I=1,50                                                  SUTERR.......80500
            IF (DS(I).EQ.'null_line') EXIT                               SUTERR.......80600
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') DS(I)                    SUTERR.......80700
            WRITE(K00,'(4X,A70)') DS(I)                                  SUTERR.......80800
 1615    CONTINUE                                                        SUTERR.......80900
         IF (KSCRN.EQ.1) WRITE (*,1621)                                  SUTERR.......81000
         WRITE (K00,1621)                                                SUTERR.......81100
 1621    FORMAT (/1X,'EXPLANATION'/)                                     SUTERR.......81200
         DO 1625 I=1,50                                                  SUTERR.......81300
            IF (EX(I).EQ.'null_line') EXIT                               SUTERR.......81400
            IF (KSCRN.EQ.1) WRITE(*,'(4X,A70)') EX(I)                    SUTERR.......81500
            WRITE(K00,'(4X,A70)') EX(I)                                  SUTERR.......81600
 1625    CONTINUE                                                        SUTERR.......81700
      END IF                                                             SUTERR.......81800
 1888 FORMAT (                                                           SUTERR.......81900
     1   /1X,'+--------+',38('-'),'+--------+'                           SUTERR.......82000
     1   /1X,'| \\  // |',38('-'),'| \\  // |'                           SUTERR.......82100
     1   /1X,'|  \\//  |',38(' '),'|  \\//  |'                           SUTERR.......82200
     1   /1X,'|   //   |',A38     '|   //   |'                           SUTERR.......82300
     1   /1X,'|  //\\  |',38(' '),'|  //\\  |'                           SUTERR.......82400
     1   /1X,'| //  \\ |',38('-'),'| //  \\ |'                           SUTERR.......82500
     1   /1X,'+--------+',38('-'),'+--------+')                          SUTERR.......82600
C                                                                        SUTERR.......82700
C.....WRITE RUN TERMINATION MESSAGES AND CALL TERMINATION SEQUENCE       SUTERR.......82800
      IF (KSCRN.EQ.1) WRITE (*,8888)                                     SUTERR.......82900
      WRITE (K00,8888)                                                   SUTERR.......83000
      IF (K3.NE.-1) WRITE (K3,8889)                                      SUTERR.......83100
      IF (K5.NE.-1) WRITE (K5,8889)                                      SUTERR.......83200
      IF (K6.NE.-1) WRITE (K6,8889)                                      SUTERR.......83300
      IF (K7.NE.-1) WRITE (K7,8889)                                      SUTERR.......83400
 8888 FORMAT (/1X,'+',56('-'),'+'/1X,'| ',54X,' |'/1X,'|',3X,            SUTERR.......83500
     1   8('*'),3X,'RUN TERMINATED DUE TO ERROR',3X,9('*'),              SUTERR.......83600
     1   3X,'|'/1X,'| ',54X,' |'/1X,'+',56('-'),'+')                     SUTERR.......83700
 8889 FORMAT (//13X,'+',56('-'),'+'/13X,'| ',54X,' |'/13X,'|',3X,        SUTERR.......83800
     1   8('*'),3X,'RUN TERMINATED DUE TO ERROR',3X,9('*'),              SUTERR.......83900
     1   3X,'|'/13X,'| ',54X,' |'/13X,'+',56('-'),'+')                   SUTERR.......84000
      IF (KSCRN.EQ.1) WRITE (*,8890)                                     SUTERR.......84100
 8890 FORMAT (/' The above error message also appears in the SMY file,'  SUTERR.......84200
     1        /' which may contain additional error information.')       SUTERR.......84300
      CALL TERSEQ()                                                      SUTERR.......84350
C                                                                        SUTERR.......84400
      RETURN                                                             SUTERR.......84500
      END                                                                SUTERR.......84600
C                                                                        SUTERR.......84700
C     SUBROUTINE        T  E  N  S  Y  M           SUTRA VERSION 1.1     TENSYM.........100
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
C     SUBROUTINE        T  E  R  S  E  Q           SUTRA VERSION 1.1     TERSEQ.........100
C                                                                        TERSEQ.........200
C *** PURPOSE :                                                          TERSEQ.........300
C ***  TO GRACEFULLY TERMINATE A SUTRA RUN BY DEALLOCATING THE MAIN      TERSEQ.........400
C ***  ALLOCATABLE ARRAYS AND CLOSING ALL FILES.                         TERSEQ.........500
C                                                                        TERSEQ.........600
      SUBROUTINE TERSEQ()                                                TERSEQ.........700
      USE ALLARR                                                         TERSEQ.........800
      use SutArrays
      IMPLICIT NONE                                                      TERSEQ.........900
      CHARACTER CDUM*1                                                   TERSEQ........1000
      INTEGER K00,K0,K1,K2,K3,K4,K5,K6,K7                                TERSEQ........1100
      INTEGER KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,             TERSEQ........1200
     1   KSCRN,KPAUSE                                                    TERSEQ........1300
      COMMON /FUNITS/ K00,K0,K1,K2,K3,K4,K5,K6,K7                        TERSEQ........1400
      COMMON /KPRINT/ KNODAL,KELMNT,KINCID,KPLOTP,KPLOTU,KVEL,KBUDG,     TERSEQ........1500
     1   KSCRN,KPAUSE                                                    TERSEQ........1600
C                                                                        TERSEQ........1700
C.....TERMINATION SEQUENCE: DEALLOCATE ARRAYS, CLOSE FILES, AND STOP     TERSEQ........1800
      IF (ALLO1) THEN                                                    TERSEQ........1900
         DEALLOCATE(PITER,UITER,PM1,DPDTITR,UM1,UM2,PVEL,SL,SR,X,Y,Z,    TERSEQ........2000
     1      VOL,POR,CS1,CS2,CS3,SW,DSWDP,RHO,SOP,QIN,UIN,QUIN,QINITR,    TERSEQ........2100
     2      RCIT,RCITM1)                                                 TERSEQ........2200
         DEALLOCATE(PVEC,UVEC)                                           TERSEQ........2300
         DEALLOCATE(ALMAX,ALMIN,ATMAX,ATMIN,VMAG,VANG1,PERMXX,PERMXY,    TERSEQ........2400
     1      PERMYX,PERMYY,PANGL1)                                        TERSEQ........2500
         DEALLOCATE(ALMID,ATMID,VANG2,PERMXZ,PERMYZ,PERMZX,PERMZY,       TERSEQ........2600
     1      PERMZZ,PANGL2,PANGL3)                                        TERSEQ........2700
         DEALLOCATE(PBC,UBC,QPLITR)                                      TERSEQ........2800
         DEALLOCATE(GXSI,GETA,GZET)                                      TERSEQ........2900
         DEALLOCATE(B)                                                   TERSEQ........3000
         DEALLOCATE(IN,IQSOP,IQSOU,IPBC,IUBC,IOBS,NREG,LREG,JA)          TERSEQ........3100
      END IF                                                             TERSEQ........3200
      IF (ALLO2) THEN                                                    TERSEQ........3300
         DEALLOCATE(PMAT,UMAT,FWK)                                       TERSEQ........3400
         DEALLOCATE(IWK)                                                 TERSEQ........3500
      END IF                                                             TERSEQ........3600
      IF (ALLO3) THEN                                                    TERSEQ........3700
         DEALLOCATE(IA)                                                  TERSEQ........3800
      END IF                                                             TERSEQ........3900
      CLOSE(K00)                                                         TERSEQ........4000
      CLOSE(K0)                                                          TERSEQ........4100
      CLOSE(K1)                                                          TERSEQ........4200
      CLOSE(K2)                                                          TERSEQ........4300
      CLOSE(K3)                                                          TERSEQ........4400
      CLOSE(K4)                                                          TERSEQ........4500
      CLOSE(K5)                                                          TERSEQ........4600
      CLOSE(K6)                                                          TERSEQ........4700
      CLOSE(K7)                                                          TERSEQ........4800
      IF ((KSCRN.EQ.1).AND.(KPAUSE.EQ.1)) THEN                           TERSEQ........4900
         WRITE(*,9990)                                                   TERSEQ........5000
9990     FORMAT(/' Press ENTER to exit ...')                             TERSEQ........5100
         READ(*,'(A1)') CDUM                                             TERSEQ........5200
      END IF                                                             TERSEQ........5300
      STOP ' '                                                           TERSEQ........5400
C                                                                        TERSEQ........5500
      RETURN                                                             TERSEQ........5600
      END                                                                TERSEQ........5700
C                                                                        TERSEQ........5800
C     SUBROUTINE        Z  E  R  O                 SUTRA VERSION 1.1     ZERO...........100
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
