C     MODULE            A  L  L  A  R  R           SUTRA VERSION 1.1     ALLARR.........100
C                                                                        ALLARR.........200
C *** PURPOSE :                                                          ALLARR.........300
C ***  TO DECLARE THE MAIN ALLOCATABLE ARRAYS.                           ALLARR.........400
C                                                                        ALLARR.........500
      MODULE ALLARR                                                      ALLARR.........600
      IMPLICIT NONE                                                      ALLARR.........700
      LOGICAL ALLO1, ALLO2, ALLO3                                        ALLARR.........800
      DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE ::                   ALLARR.........900
     1   PMAT, UMAT                                                      ALLARR........1000
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE ::                     ALLARR........1100
c rbw begin
c     1   PITER, UITER, PM1, DPDTITR, UM1, UM2, PVEL, SL, SR, X, Y, Z,    ALLARR........1200
     1   PITER, UITER, PM1, DPDTITR, UM1, UM2, PVEL, SL, SR,             ALLARR........1200
c rbw end
     2   VOL, POR, CS1, CS2, CS3, SW, DSWDP, RHO, SOP, QIN, UIN, QUIN,   ALLARR........1300
     3   QINITR, RCIT, RCITM1                                            ALLARR........1400
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE ::                     ALLARR........1500
     1   PVEC, UVEC                                                      ALLARR........1600
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE ::                     ALLARR........1700
     1   ALMAX, ALMIN, ATMAX, ATMIN, VMAG, VANG1,                        ALLARR........1800
     2   PERMXX, PERMXY, PERMYX, PERMYY, PANGL1                          ALLARR........1900
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE ::                     ALLARR........2000
     1   ALMID, ATMID, VANG2, PERMXZ, PERMYZ,                            ALLARR........2100
     2   PERMZX, PERMZY, PERMZZ, PANGL2, PANGL3                          ALLARR........2200
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE ::                     ALLARR........2300
c rbw begin
c     1   PBC, UBC, QPLITR                                                ALLARR........2400
     1   QPLITR                                                          ALLARR........2400
c rbw end
      DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE ::                   ALLARR........2500
     1   GXSI, GETA, GZET                                                ALLARR........2600
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE ::                     ALLARR........2700
     1   FWK ,B                                                          ALLARR........2800
      INTEGER, DIMENSION(:), ALLOCATABLE ::                              ALLARR........2900
c rbw begin
c     1   IN, IQSOP, IQSOU, IPBC, IUBC,                                   ALLARR........3000
     1   IQSOP, IQSOU,                                                   ALLARR........3000
c rbw end
     2   IOBS, NREG, LREG, IWK, IA, JA                                   ALLARR........3100
C                                                                        ALLARR........3200
      END MODULE ALLARR                                                  ALLARR........3300
C                                                                        ALLARR........3400
C     MODULE            P  T  R  D  E  F           SUTRA VERSION 1.1     PTRDEF.........100
C                                                                        PTRDEF.........200
C *** PURPOSE :                                                          PTRDEF.........300
C ***  TO DEFINE POINTERS AND ARRAYS NEEDED TO CONSTRUCT THE             PTRDEF.........400
C ***  IA AND JA ARRAYS.                                                 PTRDEF.........500
C                                                                        PTRDEF.........600
      MODULE PTRDEF                                                      PTRDEF.........700
      IMPLICIT NONE                                                      PTRDEF.........800
C.....DEFINE DERIVED TYPE LNKLST (LINKED LIST) WITH TWO COMPONENTS:      PTRDEF.........900
C        NODNUM (NODE NUMBER) AND NENT (POINTER TO NEXT ENTRY).          PTRDEF........1000
      TYPE LNKLST                                                        PTRDEF........1100
         INTEGER :: NODNUM                                               PTRDEF........1200
         TYPE (LNKLST), POINTER :: NENT                                  PTRDEF........1300
      END TYPE LNKLST                                                    PTRDEF........1400
C.....DECLARE DENT, DENTPV, DENTPI, AND DENTNW AS GENERAL-PURPOSE        PTRDEF........1500
C        POINTERS OF TYPE LNKLST.                                        PTRDEF........1600
      TYPE (LNKLST), POINTER :: DENT, DENTPV, DENTPI, DENTNW             PTRDEF........1700
C.....DEFINE DERIVED TYPE IPOINT WITH ONE COMPONENT: A POINTER, PL,      PTRDEF........1800
C        OF TYPE LNKLST.                                                 PTRDEF........1900
      TYPE IPOINT                                                        PTRDEF........2000
         TYPE (LNKLST), POINTER :: PL                                    PTRDEF........2100
      END TYPE IPOINT                                                    PTRDEF........2200
C.....DECLARE HLIST, AN ARRAY OF POINTERS THAT WILL POINT TO THE HEAD    PTRDEF........2300
C        OF THE LINKED LIST OF NEIGHBORS FOR EACH NODE.                  PTRDEF........2400
      TYPE (IPOINT), ALLOCATABLE :: HLIST(:)                             PTRDEF........2500
C.....DECLARE ARRAY LLIST.                                               PTRDEF........2600
      INTEGER, DIMENSION(:), ALLOCATABLE :: LLIST                        PTRDEF........2700
C                                                                        PTRDEF........2800
      END MODULE PTRDEF                                                  PTRDEF........2900
