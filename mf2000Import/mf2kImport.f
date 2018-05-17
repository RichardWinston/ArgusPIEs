C RBW BEGIN CHANGE
      MODULE MF2K_ARRAYS
      REAL GX, X, RX, XHS, FHBValues
      DOUBLE PRECISION GZ, VAR, Z
      INTEGER IG, IX, IR
      CHARACTER*10 EQNAM, NIPRNAM
      CHARACTER*12 NAMES, OBSNAM
      CHARACTER*32 MNWSITE
      CHARACTER*200 FNAME
      integer INUNIT
      ALLOCATABLE GX(:), IG(:), X(:), IX(:), RX(:), IR(:), GZ(:), Z(:),
     &            XHS(:), NIPRNAM(:), EQNAM(:), NAMES(:), OBSNAM(:),
     &            FHBValues(:)
      ALLOCATABLE MNWSITE(:)
      PARAMETER (NIUNIT=100)
      PARAMETER (MXPER=1000)
C
      CHARACTER*16 VBNM(NIUNIT)
      CHARACTER*10 APARAMNAME, AUnitName, AMultName, AZoneName
      Character*10 AnInstance
      CHARACTER*4 APARAMTYP
      DIMENSION VBVL(4,NIUNIT),IREWND(NIUNIT)
      CHARACTER*80 HEADNG(2)
      DOUBLE PRECISION AP
      INTEGER LAYHDT(200)
C
      CHARACTER*4 PIDTMP
      CHARACTER*20 CHEDFM,CDDNFM,CBOUFM
c rbw begin change
c      CHARACTER*200 FNAME, OUTNAM, COMLIN
      CHARACTER*200 OUTNAM, COMLIN
c rbw end change
      CHARACTER*200 MNWNAME
C
      LOGICAL EXISTS, BEFIRST, SHOWPROG, RESETDD, RESETDDNEXT, OBSALL
      INTEGER NPEVT, NPGHB, NPDRN, NPHFB, NPRIV, NPSTR, NPWEL, NPRCH,
     *  NPETS
      INTEGER IUBE(2), IBDT(8)
      INTEGER IOWELL2(3)  ! FOR MNW1 PACKAGE
      CHARACTER*4 CUNIT(NIUNIT)
C      CHARACTER*10 PARNEG(MXPAR)
      CHARACTER*10 PARNEG(500)
      DATA CUNIT/'BCF6', 'WEL ', 'DRN ', 'RIV ', 'EVT ', '    ', 'GHB ',  !  7
     &           'RCH ', 'SIP ', 'DE4 ', 'SOR ', 'OC  ', 'PCG ', 'LMG ',  ! 14
     &           'gwt ', 'FHB ', 'RES ', 'STR ', 'IBS ', 'CHD ', 'HFB6',  ! 21
     &           'LAK ', 'LPF ', 'DIS ', 'SEN ', 'PES ', 'OBS ', 'HOB ',  ! 28
     &           'ADV2', 'COB ', 'ZONE', 'MULT', 'DROB', 'RVOB', 'GBOB',  ! 35
     &           'STOB', 'HUF2', 'CHOB', 'ETS ', 'DRT ', 'DTOB', 'GMG ',  ! 42
     &           'HYD ', 'sfr ', 'SFOB', 'GAGE', 'LVDA', '    ', 'LMT6',  ! 49
     &           'MNW1', 'DAF ', 'DAFG', 'KDEP', 'SUB ', '    ', '    ',  ! 56
     &           44*'    '/
      END MODULE MF2K_ARRAYS
c
c
c
      module CurrentParameters
      parameter (MyMaxPar = 500,MyMXMLT=500)
      CHARACTER*10 CurrentNames(MyMaxPar), CurrentInstance(MyMaxPar)
      CHARACTER*200 MultiplierFunction(MyMXMLT)
      integer CurrentNameCount, InstanceCount
      integer CellLimits(2,MyMaxPar)
      end module CurrentParameters
C
      subroutine InitializeVariables
      include 'MyInc.inc'
      IPWBEG = 0
      IOUTG = 0
      IOUT = 0
      IBSDIM = 0
      MXWELL = 0
      NWELVL = 0
      IWELAL = 0
      IFREFM = 0
      NNPWEL = 0
      NOPRWL = 0
      MXDRN = 0
      NDRNVL = 0
      IDRNAL = 0
      NNPDRN = 0
      IDRNPB = 0
      NOPRDR = 0
      NGHBV = 0
      MXBND = 0
      NGHBVL = 0
      NRIVVL = 0
      MXRIVR = 0
      IRIVAL = 0
      IGHBAL = 0
      NNPRIV = 0
      IRIVPB = 0
      NOPRRV = 0
      NNPGHB = 0
      NOPRGB = 0
      NNPCHD = 0
      return
      end subroutine InitializeVariables

      subroutine GetIETS(ICol, IRow, NCOL, NROW,
     1  IVALUE)
      DLL_EXPORT GetIETS
      include 'MyInc.inc'
      call RetrieveIRIntegerValue(2, LCIETS, NCOL, NROW,
     1 0, ICol, IRow, 0, IVALUE)
      return
      end subroutine GetIETS
c
c
C
      subroutine GetETSR(ICol, IRow, NCOL, NROW,
     1  VALUE)
      DLL_EXPORT GetETSR
      include 'MyInc.inc'
      call RetrieveRXRealValue(2, LCETSR, NCOL, NROW,
     1 0, ICol, IRow, 0, VALUE)
      return
      end subroutine GetETSR

      subroutine GetETSX(ICol, IRow, NCOL, NROW,
     1  VALUE)
      DLL_EXPORT GetETSX
      include 'MyInc.inc'
      call RetrieveRXRealValue(2, LCETSX, NCOL, NROW,
     1 0, ICol, IRow, 0, VALUE)
      return
      end subroutine GetETSX

      subroutine GetETSS(ICol, IRow, NCOL, NROW,
     1  VALUE)
      DLL_EXPORT GetETSS
      include 'MyInc.inc'
      call RetrieveRXRealValue(2, LCETSS, NCOL, NROW,
     1 0, ICol, IRow, 0, VALUE)
      return
      end subroutine GetETSS

      subroutine GetPXDP(ICol, IRow, ISeg, NCOL, NROW, NETSEG,
     1  VALUE)
      DLL_EXPORT GetPXDP
      include 'MyInc.inc'
      if (ISeg.LT.NETSEG) THEN
        call RetrieveRXRealValue(3, LCPXDP, NCOL, NROW,
     1    NETSEG-1, ICol, IRow, ISeg, VALUE)
      ELSE
        VALUE = 0
      ENDIF
      return
      end subroutine GetPXDP

      subroutine GetPETM(ICol, IRow, ISeg, NCOL, NROW, NETSEG,
     1  VALUE)
      DLL_EXPORT GetPETM
      include 'MyInc.inc'
      if (ISeg.LT.NETSEG) THEN
        call RetrieveRXRealValue(3, LCPETM, NCOL, NROW,
     1    NETSEG-1, ICol, IRow, ISeg, VALUE)
      ELSE
        VALUE = 1
      ENDIF
      return
      end subroutine GetPETM

      SUBROUTINE GetFhbValue(I, VALUE)
      use MF2K_ARRAYS
      DLL_EXPORT GetFhbValue
c
      VALUE = FHBValues(I)
      return
      end subroutine GetFhbValue

      SUBROUTINE GetFhbBDTIM(I, NBDTIM, VALUE)
      DLL_EXPORT GetFhbBDTIM
      include 'MyInc.inc'
c
      call RetrieveRXRealValue(1, LCBDTM, NBDTIM, 1, 1,
     1 I, 1, 1, VALUE)
      return
      end subroutine GetFhbBDTIM

      SUBROUTINE GETAnInstance(Value)
      USE MF2K_ARRAYS
      CHARACTER(LEN=*) VALUE
      DLL_EXPORT GETAnInstance
      call RetrieveString(VALUE, AnInstance)
      return
      end subroutine GETAnInstance

      SUBROUTINE GETUNITNAME(Value)
      USE MF2K_ARRAYS
      CHARACTER(LEN=*) VALUE
      DLL_EXPORT GETUNITNAME
      call RetrieveString(VALUE, AUnitName)
      return
      end subroutine GETUNITNAME

      SUBROUTINE GETMULTNAME(Value)
      USE MF2K_ARRAYS
      CHARACTER(LEN=*) VALUE
      DLL_EXPORT GETMULTNAME
      call RetrieveString(VALUE, AMultName)
      return
      end subroutine GETMULTNAME

      SUBROUTINE GETZONENAME(Value)
      USE MF2K_ARRAYS
      CHARACTER(LEN=*) VALUE
      DLL_EXPORT GETZONENAME
      call RetrieveString(VALUE, AZoneName)
      return
      end subroutine GETZONENAME

      SUBROUTINE GETPARAMNAME(Value)
      USE MF2K_ARRAYS
      CHARACTER(LEN=*) VALUE
      DLL_EXPORT GETPARAMNAME
      call RetrieveString(VALUE, APARAMNAME)
      return
      end subroutine GETPARAMNAME

      SUBROUTINE GETPARAMTYPE(Value)
      USE MF2K_ARRAYS
      CHARACTER(LEN=*) VALUE
      DLL_EXPORT GETPARAMTYPE
      call RetrieveString(VALUE, APARAMTYP)
      return
      end subroutine GETPARAMTYPE

      subroutine GetHGUNAME(Layer, Value)
      CHARACTER*10 HGUNAM
      CHARACTER(LEN=*) VALUE
      COMMON /HUFCOMC/HGUNAM(200)
      DLL_EXPORT GetHGUNAME
      call RetrieveString(VALUE, HGUNAM(Layer))
      return
      end subroutine GetHGUNAME

      subroutine GetHGUHANI(Layer, Value)
      COMMON /HUFCOM/LTHUF(200),HGUHANI(200),HGUVANI(200),LAYWT(200)
      DLL_EXPORT GetHGUHANI
      Value = HGUHANI(Layer)
      return
      end subroutine GetHGUHANI

      subroutine GetHGUVANI(Layer, Value)
      COMMON /HUFCOM/LTHUF(200),HGUHANI(200),HGUVANI(200),LAYWT(200)
      DLL_EXPORT GetHGUVANI
      Value = HGUVANI(Layer)
      return
      end subroutine GetHGUVANI

      subroutine GetHufLaytype(Layer, IValue)
      COMMON /HUFCOM/LTHUF(200),HGUHANI(200),HGUVANI(200),LAYWT(200)
      DLL_EXPORT GetHufLaytype
      IValue = LTHUF(Layer)
      return
      end subroutine GetHufLaytype
c
      subroutine GetHufLaywet(Layer, IValue)
      COMMON /HUFCOM/LTHUF(200),HGUHANI(200),HGUVANI(200),LAYWT(200)
      DLL_EXPORT GetHufLaywet
      IValue = LAYWT(Layer)
      return
      end subroutine GetHufLaywet
c
      subroutine GetCellLimits(IParam, ISTART, ISTOP)
      use CurrentParameters
      DLL_EXPORT GetCellLimits
      ISTART = CellLimits(1,IParam)
      ISTOP  = CellLimits(2,IParam)
      return
      end subroutine GetCellLimits
c
c
      subroutine GetIPCLST(Item, IParam, IVALUE)
      DLL_EXPORT GetIPCLST
c IPCLST(1, IParam) = unit number
c IPCLST(2, IParam) = multiplier array number
c IPCLST(3, IParam) = zone array number
c IPCLST(4, IParam) = number of zones
c IPCLST(5-14, IParam) = zone numbers

      include 'param.inc'
      IVALUE = IPCLST(Item, IParam)
      return
      end subroutine GetIPCLST
c
c
c
      subroutine GetGHBInternal(BNDS, Layer, Row, Column,
     *  Elevation, Cond, IIndex)
      include 'MyInc.inc'
      integer Layer, Row, Column, IIndex
      DIMENSION BNDS(NGHBVL,MXBND)
      Layer     = BNDS(1,IIndex)
      Row       = BNDS(2,IIndex)
      Column    = BNDS(3,IIndex)
      Elevation = BNDS(4,IIndex)
      Cond      = BNDS(5,IIndex)
      return
      end subroutine GetGHBInternal
c
c
c
      subroutine GetGHB(Layer, Row, Column,
     *  Elevation, Cond, IIndex)
      use MF2K_ARRAYS
      DLL_EXPORT GetGHB
      include 'MyInc.inc'
      call GetGHBInternal(RX(LCBNDS), Layer, Row, Column,
     *  Elevation, Cond, IIndex)
      return
      end subroutine GetGHB
c
c
c
      subroutine GetRiverInternal(RIVR, Layer, Row, Column,
     *  Elevation, Cond, RBOT, IIndex)
      include 'MyInc.inc'
      integer Layer, Row, Column, IIndex
      DIMENSION RIVR(NRIVVL,MXRIVR)
      Layer     = RIVR(1,IIndex)
      Row       = RIVR(2,IIndex)
      Column    = RIVR(3,IIndex)
      Elevation = RIVR(4,IIndex)
      Cond      = RIVR(5,IIndex)
      RBOT      = RIVR(6,IIndex)
      return
      end subroutine GetRiverInternal
c
c
c
      subroutine GetRiver(Layer, Row, Column,
     *  Elevation, Cond, RBOT, IIndex)
      use MF2K_ARRAYS
      DLL_EXPORT GetRiver
      include 'MyInc.inc'
      call GetRiverInternal(RX(LCRIVR), Layer, Row, Column,
     *  Elevation, Cond, RBOT, IIndex)
      return
      end subroutine GetRiver
c
c
c
      subroutine GetWellInternal(WELL, Layer, Row, Column,
     *  Q, IIndex)
      include 'MyInc.inc'
      integer Layer, Row, Column, IIndex
      DIMENSION WELL(NWELVL,MXWELL)
      Layer     = WELL(1,IIndex)
      Row       = WELL(2,IIndex)
      Column    = WELL(3,IIndex)
      Q         = WELL(4,IIndex)
      return
      end subroutine GetWellInternal
c
c
c
      subroutine GetWell(Layer, Row, Column,
     *  Q, IIndex)
      use MF2K_ARRAYS
      DLL_EXPORT GetWell
      include 'MyInc.inc'
      call GetWellInternal(RX(LCWELL), Layer, Row, Column,
     *  Q, IIndex)
      return
      end subroutine GetWell
c
c
c
      subroutine GetDrainInternal(DRAI, Layer, Row, Column,
     *  Elevation, Cond, IIndex)
      include 'MyInc.inc'
      integer Layer, Row, Column, IIndex
      DIMENSION DRAI(NDRNVL,MXDRN)
      Layer     = DRAI(1,IIndex)
      Row       = DRAI(2,IIndex)
      Column    = DRAI(3,IIndex)
      Elevation = DRAI(4,IIndex)
      Cond      = DRAI(5,IIndex)
      return
      end subroutine GetDrainInternal
c
c
c
      subroutine GetDrain(Layer, Row, Column,
     *  Elevation, Cond, IIndex)
      use MF2K_ARRAYS
      DLL_EXPORT GetDrain
      include 'MyInc.inc'
      call GetDrainInternal(RX(LCDRAI), Layer, Row, Column,
     *  Elevation, Cond, IIndex)
      return
      end subroutine GetDrain
c
c
c
      subroutine GetCHD_Internal(CHDS, Layer, Row, Column,
     *  SHEAD, EHEAD, IIndex)
      include 'MyInc.inc'
      integer Layer, Row, Column, IIndex
      DIMENSION CHDS(NCHDVL,MXCHD)
      Layer     = CHDS(1,IIndex)
      Row       = CHDS(2,IIndex)
      Column    = CHDS(3,IIndex)
      SHEAD     = CHDS(4,IIndex)
      EHEAD     = CHDS(5,IIndex)
      return
      end subroutine GetCHD_Internal
c
c
c
      subroutine GetCHD(Layer, Row, Column,
     *  SHEAD, EHEAD, IIndex)
      use MF2K_ARRAYS
      DLL_EXPORT GetCHD
      include 'MyInc.inc'
      call GetCHD_Internal(RX(LCCHDS), Layer, Row, Column,
     *  SHEAD, EHEAD, IIndex)
      return
      end subroutine GetCHD
c
c
c
! NNPWEL, ingeger, number of non-parameter wells in current stress period
      subroutine GetStressPeriodCounts(I_NNPWEL, I_NNPDRN, I_NNPRIV,
     *  I_NNPGHB, I_NNPCHD, I_CurrentNameCount)
      use CurrentParameters
      include 'MyInc.inc'
      DLL_EXPORT GetStressPeriodCounts
      I_NNPWEL = NNPWEL
      I_NNPDRN = NNPDRN
      I_NNPRIV = NNPRIV
      I_NNPGHB = NNPGHB
      I_NNPCHD = NNPCHD
      I_CurrentNameCount = CurrentNameCount
      return
      end subroutine GetStressPeriodCounts
C
C
C
      subroutine GetParameterCounts(I_NPEVT, I_NPGHB, I_NPDRN, I_NPHFB,
     *  I_NPRIV, I_NPSTR, I_NPWEL, I_NPRCH, I_NPETS, I_InstanceCount)
      use MF2K_ARRAYS
      use CurrentParameters
      DLL_EXPORT GetParameterCounts
c
      I_NPEVT = NPEVT
      I_NPGHB = NPGHB
      I_NPDRN = NPDRN
      I_NPHFB = NPHFB
      I_NPRIV = NPRIV
      I_NPSTR = NPSTR
      I_NPWEL = NPWEL
      I_NPRCH = NPRCH
      I_NPETS = NPETS
      I_InstanceCount = InstanceCount
      return
      end subroutine GetParameterCounts
c
c
c
      SUBROUTINE GetIPSUM(IVALUE)
      DLL_EXPORT GetIPSUM
      INCLUDE 'param.inc'
      IVALUE = IPSUM
      RETURN
      END SUBROUTINE GetIPSUM
C
C
c
      subroutine GetClusterRange(I,ISTART,ISTOP)
      DLL_EXPORT GetClusterRange
      include 'param.inc'
      ISTART = IPLOC(1,I)
      ISTOP  = IPLOC(2,I)
      return
      end subroutine GetClusterRange
C
C
c
      subroutine GetInstanceCount(I,IVALUE)
      DLL_EXPORT GetInstanceCount
      include 'param.inc'
      IVALUE = IPLOC(3,I)
      if (IVALUE.eq.0) then
        IVALUE = 1
      endif
      return
      end subroutine GetInstanceCount
c
c
c
      subroutine GetInstanceStart(I,IVALUE)
      DLL_EXPORT GetInstanceStart
      include 'param.inc'
      IVALUE = IPLOC(4,I)
      return
      end subroutine GetInstanceStart
c
c
      SUBROUTINE ParameterValue(I,VALUE)
      DLL_EXPORT ParameterValue
      INCLUDE 'param.inc'
      VALUE = B(I)
      return
      end SUBROUTINE ParameterValue
c
c
C
      SUBROUTINE GetHUFTOP(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      USE MF2K_ARRAYS
      DLL_EXPORT GetHUFTOP
      include 'MyInc.inc'
c
      I = 1
      call RETRIEVE_4D_REAL_VALUE(X(LCHUFTHK), NCOL, NROW, NLAY, 2,
     1 ICol, IRow, ILAY, I, VALUE)
      return
      end subroutine GetHUFTOP
C
C
C
      SUBROUTINE GetHUFTHK(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      USE MF2K_ARRAYS
      DLL_EXPORT GetHUFTHK
      include 'MyInc.inc'
c
      I = 2
      call RETRIEVE_4D_REAL_VALUE(X(LCHUFTHK), NCOL, NROW, NLAY, 2,
     1 ICol, IRow, ILAY, I, VALUE)
      return
      end subroutine GetHUFTHK
C
C
C
      SUBROUTINE GetHY(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      DLL_EXPORT GetHY
      include 'MyInc.inc'
c
      call RetrieveRXRealValue(3, LCHY, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetHY
C
C
C
      SUBROUTINE GetCC(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      DLL_EXPORT GetCC
      include 'MyInc.inc'
c
      call RetrieveGXRealValue(3, LCCC, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetCC
C
C
C
      SUBROUTINE GetCV(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      DLL_EXPORT GetCV
      include 'MyInc.inc'
c
      call RetrieveGXRealValue(3, LCCV, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetCV
C
C
C
      SUBROUTINE GetSTRT(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      DLL_EXPORT GetSTRT
      include 'MyInc.inc'
c
      call RetrieveGXRealValue(3, LCSTRT, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetSTRT
C
C
C
      SUBROUTINE GetLAYFLG(I, ILAY, NLAY, IVALUE)
      DLL_EXPORT GetLAYFLG
      include 'MyInc.inc'
C
      call RetrieveIXIntegerValue(2, LCLAYF, 6, NLAY, I, ILAY, IVALUE)
      return
      end subroutine GetLAYFLG
C
C
C
      SUBROUTINE GetISENS(I, NPLIST, IVALUE)
      DLL_EXPORT GetISENS
      include 'MyInc.inc'
C
      call RetrieveIXIntegerValue(1, LCISEN, NPLIST, I, IVALUE)
      return
      end subroutine GetISENS
C
C
C
      SUBROUTINE GetHANI(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      DLL_EXPORT GetHANI
      include 'MyInc.inc'
c
      call RetrieveXRealValue(3, LCHANI, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetHANI
C
C
C
      SUBROUTINE GetVKCB(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      DLL_EXPORT GetVKCB
      include 'MyInc.inc'
c
      call RetrieveXRealValue(3, LCVKCB, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetVKCB
C
C
C
      SUBROUTINE GetVKA(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      DLL_EXPORT GetVKA
      include 'MyInc.inc'
c
      call RetrieveXRealValue(3, LCVKA, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetVKA
C
C
C
      SUBROUTINE GetHK(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE)
      DLL_EXPORT GetHK
      include 'MyInc.inc'
c
      call RetrieveXRealValue(3, LCHK, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetHK
C
C
C
      SUBROUTINE GetWETDRY(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE, IUnitBCF)
      DLL_EXPORT GetWETDRY
      include 'MyInc.inc'
c
      if (IUnitBCF.GT.0) THEN
        call RetrieveRXRealValue(3, LCWETD, NCOL, NROW, NLAY,
     1    ICol, IRow, ILAY, VALUE)
      ELSE
        call RetrieveXRealValue(3, LCWETD, NCOL, NROW, NLAY,
     1    ICol, IRow, ILAY, VALUE)
      ENDIF
      return
      end subroutine GetWETDRY
C
C
C
      SUBROUTINE GetTRPY(ILAY, NLAY, VALUE)
      DLL_EXPORT GetTRPY
      include 'MyInc.inc'
c
      call RetrieveRXRealValue(1, LCTRPY, NLAY, 0, 0, ILAY, 0, 0, VALUE)
      return
      end subroutine GetTRPY
C
C
C
      SUBROUTINE GetSC2(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE, IUnitBCF)
      DLL_EXPORT GetSC2
      include 'MyInc.inc'
c
      if (IUnitBCF.GT.0) THEN
        call RetrieveRXRealValue(3, LCSC2, NCOL, NROW, NLAY,
     1    ICol, IRow, ILAY, VALUE)
      ELSE
        call RetrieveXRealValue(3, LCSC2, NCOL, NROW, NLAY,
     1    ICol, IRow, ILAY, VALUE)
      ENDIF
      return
      end subroutine GetSC2
C
C
C
      SUBROUTINE GetSC1(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  VALUE, IUnitBCF)
      DLL_EXPORT GetSC1
      include 'MyInc.inc'
c
      if (IUnitBCF.GT.0) THEN
        call RetrieveRXRealValue(3, LCSC1, NCOL, NROW, NLAY,
     1    ICol, IRow, ILAY, VALUE)
      ELSE
        call RetrieveXRealValue(3, LCSC1, NCOL, NROW, NLAY,
     1    ICol, IRow, ILAY, VALUE)
      ENDIF
      return
      end subroutine GetSC1
C
C
C
      SUBROUTINE GetIBOUND(ICol, IRow, ILAY, NCOL, NROW, NLAY,
     1  IVALUE)
      DLL_EXPORT GetIBOUND
      include 'MyInc.inc'
c
      call RetrieveIGIntegerValue(3, LCIBOU, NCOL, NROW, NLAY,
     1 ICol, IRow, ILAY, IVALUE)
      return
      end subroutine GetIBOUND
C
C
C
      SUBROUTINE GetBOTM(ICol, IRow, ILAY, NCOL, NROW, NLAY_Plus_1,
     1  VALUE)
      DLL_EXPORT GetBOTM
      include 'MyInc.inc'
c
      call RetrieveGXRealValue(3, LCBOTM, NCOL, NROW, NLAY_Plus_1,
     1 ICol, IRow, ILAY, VALUE)
      return
      end subroutine GetBOTM
C
C
C
      SUBROUTINE GetRMLT(ICol, IRow, IArray, NCOL, NROW, NMLTAR,
     1  VALUE)
      DLL_EXPORT GetRMLT
      include 'MyInc.inc'
c
      call RetrieveGXRealValue(3, LCRMLT, NCOL, NROW, NMLTAR,
     1 ICol, IRow, IArray, VALUE)
      return
      end subroutine GetRMLT
C
C
C
      SUBROUTINE GetIZONE(ICol, IRow, IArray, NCOL, NROW, NZONAR,
     1  IVALUE)
      DLL_EXPORT GetIZONE
      include 'MyInc.inc'
C      IVALUE = 1
c
      call RetrieveIGIntegerValue(3, LCIZON, NCOL, NROW, NZONAR,
     1 ICol, IRow, IArray, IVALUE)
      return
      end subroutine GetIZONE
C
C
C
      SUBROUTINE GetDELR(ICol, NCOL, VALUE)
      DLL_EXPORT GetDELR
      include 'MyInc.inc'
c
      call RetrieveGXRealValue(1, LCDELR, NCOL, 0,
     1 0, ICol, 0, 0, VALUE)
      return
      end subroutine GetDELR
C
C
C
      SUBROUTINE GetDELC(IROW, NROW, VALUE)
      DLL_EXPORT GetDELC
      include 'MyInc.inc'
c
      call RetrieveGXRealValue(1, LCDELC, NROW, 0,
     1 0, IROW, 0, 0, VALUE)
      return
      end subroutine GetDELC
C
C
C
      SUBROUTINE RetrieveNIPRNAM(I, VALUE)
      USE MF2K_ARRAYS
      DLL_EXPORT RetrieveNIPRNAM
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, NIPRNAM(I))
      RETURN
      END SUBROUTINE RetrieveNIPRNAM
C
C
      SUBROUTINE RetrieveCurrentParamAndInstance(I, PARAM, INSTANCE)
      USE CurrentParameters
      DLL_EXPORT RetrieveCurrentParamAndInstance
      CHARACTER(LEN=*) PARAM, INSTANCE
      call RetrieveString(PARAM, CurrentNames(I))
      call RetrieveString(INSTANCE, CurrentInstance(I))
      RETURN
      END SUBROUTINE RetrieveCurrentParamAndInstance
C
C
C
      SUBROUTINE RetrieveMultiplierFuction(I, VALUE)
      USE CurrentParameters
      DLL_EXPORT RetrieveMultiplierFuction
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, MultiplierFunction(I))
      RETURN
      END SUBROUTINE RetrieveMultiplierFuction
C
C
C
      SUBROUTINE RetrieveEQNAM(I, VALUE)
      USE MF2K_ARRAYS
      DLL_EXPORT RetrieveEQNAM
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, EQNAM(I))
      RETURN
      END SUBROUTINE RetrieveEQNAM
C
C
C
      SUBROUTINE RetrieveNAMES(I, VALUE)
      USE MF2K_ARRAYS
      DLL_EXPORT RetrieveNAMES
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, NAMES(I))
      RETURN
      END SUBROUTINE RetrieveNAMES
C
C
C
      SUBROUTINE RetrieveOBSNAM(I, VALUE)
      USE MF2K_ARRAYS
      DLL_EXPORT RetrieveOBSNAM
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, OBSNAM(I))
      RETURN
      END SUBROUTINE RetrieveOBSNAM
C
C
C
      SUBROUTINE RetrievePARNAM(I, VALUE)
      INCLUDE 'param.inc'
      DLL_EXPORT RetrievePARNAM
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, PARNAM(I))
      RETURN
      END SUBROUTINE RetrievePARNAM
C
      subroutine RetrieveString(Value, NewValue)
      INCLUDE 'MyInc.inc'
      CHARACTER(LEN=*) VALUE
      CHARACTER(LEN=*) NewValue
      INTEGER LIMIT
      LIMIT = len(VALUE)-1
      IF (LEN(NewValue).LT.LIMIT) THEN
        LIMIT = LEN(NewValue)
      ENDIF
      do j = 1, LIMIT
        VALUE(j+1:j+1) = NewValue(j:j)
      end do
!      IF (LIMIT.LT.len(VALUE)-1) THEN
!        do j = LIMIT+1, len(VALUE)-1
!          VALUE(j+1:j+1) = ' '
!        end do
!      ENDIF

      return
      end subroutine RetrieveString
C
C
      SUBROUTINE RetrievePARTYP(I, VALUE)
      INCLUDE 'param.inc'
      DLL_EXPORT RetrievePARTYP
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, PARTYP(I))
      RETURN
      END SUBROUTINE RetrievePARTYP
C
C
C
      SUBROUTINE RetrieveINAME(I, VALUE)
      INCLUDE 'param.inc'
      DLL_EXPORT RetrieveINAME
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, INAME(I))
      RETURN
      END SUBROUTINE RetrieveINAME
C
C
C
      SUBROUTINE RetrieveMLTNAM(I, VALUE)
      INCLUDE 'param.inc'
      DLL_EXPORT RetrieveMLTNAM
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, MLTNAM(I))
      RETURN
      END SUBROUTINE RetrieveMLTNAM
C
C
C
      SUBROUTINE RetrieveZONNAM(I, VALUE)
      INCLUDE 'param.inc'
      DLL_EXPORT RetrieveZONNAM
      CHARACTER(LEN=*) VALUE
      call RetrieveString(VALUE, ZONNAM(I))
      RETURN
      END SUBROUTINE RetrieveZONNAM
C
C
C
      SUBROUTINE RetrieveRXRealValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, VALUE)
      USE MF2K_ARRAYS
      IF (IDIM.EQ.1) THEN
        CALL RETRIEVE_1D_REAL_VALUE(RX(LOC), LENGTH1,
     1    I1, VALUE)
      ELSEIF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_REAL_VALUE(RX(LOC), LENGTH1, LENGTH2,
     1    I1, I2, VALUE)
      ELSE
        CALL RETRIEVE_3D_REAL_VALUE(RX(LOC), LENGTH1, LENGTH2, LENGTH3,
     1    I1, I2, I3, VALUE)
      ENDIF
      RETURN
      END SUBROUTINE RetrieveRXRealValue
C
C
C
      SUBROUTINE RetrieveGXRealValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, VALUE)
      USE MF2K_ARRAYS
      IF (IDIM.EQ.1) THEN
        CALL RETRIEVE_1D_REAL_VALUE(GX(LOC), LENGTH1,
     1    I1, VALUE)
      ELSEIF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_REAL_VALUE(GX(LOC), LENGTH1, LENGTH2,
     1    I1, I2, VALUE)
      ELSE
        CALL RETRIEVE_3D_REAL_VALUE(GX(LOC), LENGTH1, LENGTH2, LENGTH3,
     1    I1, I2, I3, VALUE)
      ENDIF
      RETURN
      END SUBROUTINE RetrieveGXRealValue
C
C
C
      SUBROUTINE RetrieveXRealValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, VALUE)
      USE MF2K_ARRAYS
      IF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_REAL_VALUE(X(LOC), LENGTH1, LENGTH2,
     1    I1, I2, VALUE)
      ELSE 
        CALL RETRIEVE_3D_REAL_VALUE(X(LOC), LENGTH1, LENGTH2, LENGTH3,
     1    I1, I2, I3, VALUE)
      ENDIF
      RETURN
      END SUBROUTINE RetrieveXRealValue
C
C
C
      SUBROUTINE RetrieveZDoubleValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, VALUE)
      USE MF2K_ARRAYS
      DOUBLE PRECISION VALUE
      IF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_DOUBLE_VALUE(Z(LOC), LENGTH1, LENGTH2,
     1    I1, I2, VALUE)
      ELSE
        CALL RETRIEVE_3D_DOUBLE_VALUE(Z(LOC), LENGTH1, LENGTH2,
     1    LENGTH3, I1, I2, I3, VALUE)
      ENDIF
      RETURN
      END SUBROUTINE RetrieveZDoubleValue
C
C
C
      SUBROUTINE RetrieveGZDoubleValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, VALUE)
      USE MF2K_ARRAYS
      DOUBLE PRECISION VALUE
      IF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_DOUBLE_VALUE(GZ(LOC), LENGTH1, LENGTH2,
     1    I1, I2, VALUE)
      ELSE
        CALL RETRIEVE_3D_DOUBLE_VALUE(GZ(LOC), LENGTH1, LENGTH2,
     1    LENGTH3, I1, I2, I3, VALUE)
      ENDIF
      RETURN
      END SUBROUTINE RetrieveGZDoubleValue
C
c
c
      subroutine GetIRCH(ICol, IRow, NCOL, NROW,
     1  IVALUE)
      DLL_EXPORT GetIRCH
      include 'MyInc.inc'
      call RetrieveIRIntegerValue(2, LCIRCH, NCOL, NROW,
     1 0, ICol, IRow, 0, IVALUE)
      return
      end subroutine GetIRCH
c
c
C
      subroutine GetRECH(ICol, IRow, NCOL, NROW,
     1  VALUE)
      DLL_EXPORT GetRECH
      include 'MyInc.inc'
      call RetrieveRXRealValue(2, LCRECH, NCOL, NROW,
     1 0, ICol, IRow, 0, VALUE)
      return
      end subroutine GetRECH
c
c
C
      subroutine GetIEVT(ICol, IRow, NCOL, NROW,
     1  IVALUE)
      DLL_EXPORT GetIEVT
      include 'MyInc.inc'
      call RetrieveIRIntegerValue(2, LCIRCH, NCOL, NROW,
     1 0, ICol, IRow, 0, IVALUE)
      return
      end subroutine GetIEVT
c
c
C
      subroutine GetEVTR(ICol, IRow, NCOL, NROW,
     1  VALUE)
      DLL_EXPORT GetEVTR
      include 'MyInc.inc'
      call RetrieveRXRealValue(2, LCEVTR, NCOL, NROW,
     1 0, ICol, IRow, 0, VALUE)
      return
      end subroutine GetEVTR
c
c
C
      subroutine GetEXDP(ICol, IRow, NCOL, NROW,
     1  VALUE)
      DLL_EXPORT GetEXDP
      include 'MyInc.inc'
      call RetrieveRXRealValue(2, LCEXDP, NCOL, NROW,
     1 0, ICol, IRow, 0, VALUE)
      return
      end subroutine GetEXDP
c
c
C
      subroutine GetSURF(ICol, IRow, NCOL, NROW,
     1  VALUE)
      DLL_EXPORT GetSURF
      include 'MyInc.inc'
      call RetrieveRXRealValue(2, LCSURF, NCOL, NROW,
     1 0, ICol, IRow, 0, VALUE)
      return
      end subroutine GetSURF
c
c
C
      SUBROUTINE RetrieveIRIntegerValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, IVALUE)
      USE MF2K_ARRAYS
      IF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_INTEGER_VALUE(IR(LOC), LENGTH1, LENGTH2,
     1    I1, I2, IVALUE)
      ELSE
        CALL RETRIEVE_3D_INTEGER_VALUE(IR(LOC), LENGTH1, LENGTH2,
     1    LENGTH3,I1, I2, I3, IVALUE)
      ENDIF
      RETURN
      END SUBROUTINE RetrieveIRIntegerValue
C
C
C
      SUBROUTINE RetrieveIXIntegerValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, IVALUE)
      USE MF2K_ARRAYS
      IF (IDIM.EQ.1) THEN
        CALL RETRIEVE_1D_INTEGER_VALUE(IX(LOC), LENGTH1,
     1    I1, IVALUE)
      ELSEIF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_INTEGER_VALUE(IX(LOC), LENGTH1, LENGTH2,
     1    I1, I2, IVALUE)
      ELSE
        CALL RETRIEVE_3D_INTEGER_VALUE(IX(LOC), LENGTH1, LENGTH2,
     1    LENGTH3,I1, I2, I3, IVALUE)
      ENDIF
      RETURN
      END SUBROUTINE RetrieveIXIntegerValue
C
C
C
      SUBROUTINE RetrieveIGIntegerValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, IVALUE)
      USE MF2K_ARRAYS
      IF (IDIM.EQ.1) THEN
        CALL RETRIEVE_1D_INTEGER_VALUE(IG(LOC), LENGTH1,
     1    I1, IVALUE)
      ELSEIF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_INTEGER_VALUE(IG(LOC), LENGTH1, LENGTH2,
     1    I1, I2, IVALUE)
      ELSEIF (IDIM.EQ.3) THEN
        CALL RETRIEVE_3D_INTEGER_VALUE(IG(LOC), LENGTH1, LENGTH2,
     1    LENGTH3, I1, I2, I3, IVALUE)
      ELSE
        IVALUE = -1
      ENDIF
      RETURN
      END SUBROUTINE RetrieveIGIntegerValue
C
C
C
      SUBROUTINE RetrieveXIntegerValue(IDIM, LOC, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, IVALUE)
      USE MF2K_ARRAYS
      IF (IDIM.EQ.2) THEN
        CALL RETRIEVE_2D_INTEGER_VALUE(X(LOC), LENGTH1, LENGTH2,
     1    I1, I2, IVALUE)
      ELSE
        CALL RETRIEVE_3D_INTEGER_VALUE(X(LOC), LENGTH1, LENGTH2,
     1    LENGTH3,I1, I2, I3, IVALUE)
      ENDIF
      RETURN
      END SUBROUTINE RetrieveXIntegerValue
C
C
C
      SUBROUTINE RETRIEVE_1D_REAL_VALUE(X, LENGTH1,
     1 I1, VALUE)
      REAL X(LENGTH1)
      VALUE = X(I1)
      RETURN
      END SUBROUTINE RETRIEVE_1D_REAL_VALUE
C
C
C
      SUBROUTINE RETRIEVE_2D_REAL_VALUE(X, LENGTH1, LENGTH2,
     1 I1, I2, VALUE)
      REAL X(LENGTH1, LENGTH2)
      VALUE = X(I1, I2)
      RETURN
      END SUBROUTINE RETRIEVE_2D_REAL_VALUE
C
C
C
      SUBROUTINE RETRIEVE_1D_INTEGER_VALUE(IX, LENGTH1,
     1 I1, IVALUE)
      INTEGER IX(LENGTH1)
      IVALUE = IX(I1)
      RETURN
      END SUBROUTINE RETRIEVE_1D_INTEGER_VALUE
C
C
C
      SUBROUTINE RETRIEVE_2D_INTEGER_VALUE(IX, LENGTH1, LENGTH2,
     1 I1, I2, IVALUE)
      INTEGER IX(LENGTH1, LENGTH2)
      IVALUE = IX(I1, I2)
      RETURN
      END SUBROUTINE RETRIEVE_2D_INTEGER_VALUE
C
C
C
      SUBROUTINE RETRIEVE_2D_DOUBLE_VALUE(X, LENGTH1, LENGTH2,
     1 I1, I2, VALUE)
      DOUBLE PRECISION  X(LENGTH1, LENGTH2), VALUE
      VALUE = X(I1, I2)
      RETURN
      END SUBROUTINE RETRIEVE_2D_DOUBLE_VALUE
C
C
C
      SUBROUTINE RETRIEVE_3D_REAL_VALUE(X, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, VALUE)
      REAL X(LENGTH1, LENGTH2, LENGTH3)
      VALUE = X(I1, I2, I3)
      RETURN
      END SUBROUTINE RETRIEVE_3D_REAL_VALUE
C
C
C
      SUBROUTINE RETRIEVE_4D_REAL_VALUE(X, LENGTH1, LENGTH2,
     1 LENGTH3, LENGTH4, I1, I2, I3, I4, VALUE)
      dimension X(LENGTH1, LENGTH2, LENGTH3, LENGTH4)
      VALUE = X(I1, I2, I3, I4)
      RETURN
      END SUBROUTINE RETRIEVE_4D_REAL_VALUE
C
C
C
      SUBROUTINE RETRIEVE_3D_INTEGER_VALUE(IARRAY, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, IVALUE)
      integer IARRAY(LENGTH1, LENGTH2, LENGTH3)
      IVALUE = IARRAY(I1, I2, I3)
      RETURN
      END SUBROUTINE RETRIEVE_3D_INTEGER_VALUE
C
C
C
      SUBROUTINE RETRIEVE_3D_DOUBLE_VALUE(X, LENGTH1, LENGTH2,
     1 LENGTH3, I1, I2, I3, VALUE)
      DOUBLE PRECISION  X(LENGTH1, LENGTH2, LENGTH3), VALUE
      VALUE = X(I1, I2, I3)
      RETURN
      END SUBROUTINE RETRIEVE_3D_DOUBLE_VALUE
C
C
C
      SUBROUTINE GetBCFLayavg(Layer, I)
      COMMON /FLWAVG/LAYAVG(200)
      Layer = LAYAVG(I)
      RETURN
      END SUBROUTINE GetBCFLayavg
C
C
C
      SUBROUTINE TransferBCFLayavg
      COMMON /LPFCOM/LAYTYP(200),LAYAVG(200),CHANI(200),LAYVKA(200),
     1               LAYWET(200)
      do i=1, 200
        call  GetBCFLayavg(Layer, I)
        LAYAVG(I) = Layer
      end do
      RETURN
      END SUBROUTINE TransferBCFLayavg
C
C
C
      SUBROUTINE CLOSE_MF2K
      USE MF2K_ARRAYS
      DLL_EXPORT CLOSE_MF2K
      LOGICAL LOP
      CALL CLOSEFILES(INUNIT,FNAME)
      do IU = 96, 99
      INQUIRE(UNIT=IU,OPENED=LOP)
      IF (LOP) THEN
        CLOSE(UNIT=IU,ERR=100)
  100   CONTINUE
      ENDIF
      enddo

      IF (ALLOCATED(GX)) DEALLOCATE(GX)
      IF (ALLOCATED(IG)) DEALLOCATE(IG)
      IF (ALLOCATED(X))  DEALLOCATE(X)
      IF (ALLOCATED(IX)) DEALLOCATE(IX)
      IF (ALLOCATED(RX)) DEALLOCATE(RX)
      IF (ALLOCATED(GX)) DEALLOCATE(GX)
      IF (ALLOCATED(IR)) DEALLOCATE(IR)
      IF (ALLOCATED(GZ)) DEALLOCATE(GZ)
      IF (ALLOCATED(Z))  DEALLOCATE(Z)
      IF (ALLOCATED(XHS)) DEALLOCATE(XHS)
      IF (ALLOCATED(NIPRNAM)) DEALLOCATE(NIPRNAM)
      IF (ALLOCATED(EQNAM)) DEALLOCATE(EQNAM)
      IF (ALLOCATED(NAMES)) DEALLOCATE(NAMES)
      IF (ALLOCATED(OBSNAM)) DEALLOCATE(OBSNAM)
      IF (ALLOCATED(MNWSITE)) DEALLOCATE(MNWSITE)
      IF (ALLOCATED(FHBValues)) DEALLOCATE(FHBValues)
      RETURN
      END SUBROUTINE CLOSE_MF2K
C RBW END CHANGE

