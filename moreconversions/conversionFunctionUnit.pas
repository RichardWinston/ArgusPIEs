unit conversionFunctionUnit;

interface

uses

  AnePIE, FunctionPie;

var
        gPIEm_per_sq_sec2ft_per_sqdayPIEDesc : ANEPIEDesc;
        gPIEm_per_sq_sec2ft_per_sqdayFDesc   :  FunctionPIEDesc;

        gPIEft_per_sqday2m_per_sq_secPIEDesc : ANEPIEDesc;
        gPIEft_per_sqday2m_per_sq_secFDesc   :  FunctionPIEDesc;

        gPIESec2DayPIEDesc : ANEPIEDesc;
        gPIESec2DayFDesc   :  FunctionPIEDesc;

        gPIEDay2SecPIEDesc : ANEPIEDesc;
        gPIEDay2SecFDesc   :  FunctionPIEDesc;

        gPIEK2FPIEDesc : ANEPIEDesc;
        gPIEK2FFDesc   :  FunctionPIEDesc;

        gPIEF2KPIEDesc : ANEPIEDesc;
        gPIEF2KFDesc   :  FunctionPIEDesc;

        gPIEJ2BTUPIEDesc : ANEPIEDesc;
        gPIEJ2BTUFDesc   :  FunctionPIEDesc;

        gPIEBTU2JPIEDesc : ANEPIEDesc;
        gPIEBTU2JFDesc   :  FunctionPIEDesc;

        gPIESqm2sqftPIEDesc : ANEPIEDesc;
        gPIESqm2sqftFDesc   :  FunctionPIEDesc;

        gPIESqft2sqmPIEDesc : ANEPIEDesc;
        gPIESqft2sqmFDesc   :  FunctionPIEDesc;

        gPIECum2CuftPIEDesc : ANEPIEDesc;
        gPIECum2CuftFDesc   :  FunctionPIEDesc;

        gPIECuft2CumPIEDesc : ANEPIEDesc;
        gPIECuft2CumFDesc   :  FunctionPIEDesc;

        gPIEms2footdayPIEDesc : ANEPIEDesc;
        gPIEms2footdayFDesc   :  FunctionPIEDesc;

        gPIEfootday2msPIEDesc : ANEPIEDesc;
        gPIEfootday2msFDesc   :  FunctionPIEDesc;

        gPIEPa2psiPIEDesc : ANEPIEDesc;
        gPIEPa2psiFDesc   :  FunctionPIEDesc;

        gPIEpsi2PaPIEDesc : ANEPIEDesc;
        gPIEpsi2PaFDesc   :  FunctionPIEDesc;

        gPIEmpers2ftperdayPIEDesc : ANEPIEDesc;
        gPIEmpers2ftperdayFDesc   :  FunctionPIEDesc;

        gPIEftperday2mpersPIEDesc : ANEPIEDesc;
        gPIEftperday2mpersFDesc   :  FunctionPIEDesc;

        gPIEsqmpers2sqftperdayPIEDesc : ANEPIEDesc;
        gPIEsqmpers2sqftperdayFDesc   :  FunctionPIEDesc;

        gPIEsqftperday2sqmpersPIEDesc : ANEPIEDesc;
        gPIEsqftperday2sqmpersFDesc   :  FunctionPIEDesc;

        gPIEcumpers2cuftperdayPIEDesc : ANEPIEDesc;
        gPIEcumpers2cuftperdayFDesc   :  FunctionPIEDesc;

        gPIEcuftperday2cumpersPIEDesc : ANEPIEDesc;
        gPIEcuftperday2cumpersFDesc   :  FunctionPIEDesc;

        gPIElpers2cuftperdayPIEDesc : ANEPIEDesc;
        gPIElpers2cuftperdayFDesc   :  FunctionPIEDesc;

        gPIEcuftperday2lpersPIEDesc : ANEPIEDesc;
        gPIEcuftperday2lpersFDesc   :  FunctionPIEDesc;

        gPIEkgpers2lbperdayPIEDesc : ANEPIEDesc;
        gPIEkgpers2lbperdayFDesc   :  FunctionPIEDesc;

        gPIElbperday2kgpersPIEDesc : ANEPIEDesc;
        gPIElbperday2kgpersFDesc   :  FunctionPIEDesc;

        gPIEPapers2psiperdayPIEDesc : ANEPIEDesc;
        gPIEPapers2psiperdayFDesc   :  FunctionPIEDesc;

        gPIEpsiperday2PapersPIEDesc : ANEPIEDesc;
        gPIEpsiperday2PapersFDesc   :  FunctionPIEDesc;

        gPIEkgpercum2lbpercuftPIEDesc : ANEPIEDesc;
        gPIEkgpercum2lbpercuftFDesc   :  FunctionPIEDesc;

        gPIElbpercuft2kgpercumPIEDesc : ANEPIEDesc;
        gPIElbpercuft2kgpercumFDesc   :  FunctionPIEDesc;

        gPIEWpercum2BTUperHcuftPIEDesc : ANEPIEDesc;
        gPIEWpercum2BTUperHcuftFDesc   :  FunctionPIEDesc;

        gPIEBTUperHcuft2WpercumPIEDesc : ANEPIEDesc;
        gPIEBTUperHcuft2WpercumFDesc   :  FunctionPIEDesc;

        gPIEJperkg2BTUperlbPIEDesc : ANEPIEDesc;
        gPIEJperkg2BTUperlbFDesc   :  FunctionPIEDesc;

        gPIEBTUperlb2JperkgPIEDesc : ANEPIEDesc;
        gPIEBTUperlb2JperkgFDesc   :  FunctionPIEDesc;

        gPIEJperkg2ftlbfperlbmPIEDesc : ANEPIEDesc;
        gPIEJperkg2ftlbfperlbmFDesc   :  FunctionPIEDesc;

        gPIEftlbfperlbm2JperkgPIEDesc : ANEPIEDesc;
        gPIEftlbfperlbm2JperkgFDesc   :  FunctionPIEDesc;

        gPIEcumperkg2cuftperlbPIEDesc : ANEPIEDesc;
        gPIEcumperkg2cuftperlbFDesc   :  FunctionPIEDesc;

        gPIEcuftperlb2cumperkgPIEDesc : ANEPIEDesc;
        gPIEcuftperlb2cumperkgFDesc   :  FunctionPIEDesc;

        gPIEcumpersqms2cuftpersqftdayPIEDesc : ANEPIEDesc;
        gPIEcumpersqms2cuftpersqftdayFDesc   :  FunctionPIEDesc;

        gPIEcuftpersqftday2cumpersqmsPIEDesc : ANEPIEDesc;
        gPIEcuftpersqftday2cumpersqmsFDesc   :  FunctionPIEDesc;

        gPIEWpersqm2BTUperHRsqftPIEDesc : ANEPIEDesc;
        gPIEWpersqm2BTUperHRsqftFDesc   :  FunctionPIEDesc;

        gPIEBTUperHRsqft2WpersqmPIEDesc : ANEPIEDesc;
        gPIEBTUperHRsqft2WpersqmFDesc   :  FunctionPIEDesc;

        gPIEkgpersqms2lbpersqftdayPIEDesc : ANEPIEDesc;
        gPIEkgpersqms2lbpersqftdayFDesc   :  FunctionPIEDesc;

        gPIElbpersqftday2kgpersqmsPIEDesc : ANEPIEDesc;
        gPIElbpersqftday2kgpersqmsFDesc   :  FunctionPIEDesc;

        gPIEkgperms2cPPIEDesc : ANEPIEDesc;
        gPIEkgperms2cPFDesc   :  FunctionPIEDesc;

        gPIEcP2kgpermsPIEDesc : ANEPIEDesc;
        gPIEcP2kgpermsFDesc   :  FunctionPIEDesc;

        gPIEJperkgm2BTUperlbftPIEDesc : ANEPIEDesc;
        gPIEJperkgm2BTUperlbftFDesc   :  FunctionPIEDesc;

        gPIEBTUperlbft2JperkgmPIEDesc : ANEPIEDesc;
        gPIEBTUperlbft2JperkgmFDesc   :  FunctionPIEDesc;

        gPIEWpermdegC2BTUperlbfthrdgFPIEDesc : ANEPIEDesc;
        gPIEWpermdegC2BTUperlbfthrdgFFDesc   :  FunctionPIEDesc;

        gPIEBTUperlbfthrdgF2WpermdegCPIEDesc : ANEPIEDesc;
        gPIEBTUperlbfthrdgF2WpermdegCFDesc   :  FunctionPIEDesc;

        gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc : ANEPIEDesc;
        gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc   :  FunctionPIEDesc;

        gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc : ANEPIEDesc;
        gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc   :  FunctionPIEDesc;

        gPIEJperkgdegC2BTUperlbdgFPIEDesc : ANEPIEDesc;
        gPIEJperkgdegC2BTUperlbdgFFDesc   :  FunctionPIEDesc;

        gPIEBTUperlbdgF2JperkgdegCPIEDesc : ANEPIEDesc;
        gPIEBTUperlbdgF2JperkgdegCFDesc   :  FunctionPIEDesc;

        gPIEJpercumdegC2BTUpercuftdgFPIEDesc : ANEPIEDesc;
        gPIEJpercumdegC2BTUpercuftdgFFDesc   :  FunctionPIEDesc;

        gPIEBTUpercuftdgF2JpercumdegCPIEDesc : ANEPIEDesc;
        gPIEBTUpercuftdgF2JpercumdegCFDesc   :  FunctionPIEDesc;

        gPIEcumpersmPa2cuftperdaylbsqinPIEDesc : ANEPIEDesc;
        gPIEcumpersmPa2cuftperdaylbsqinFDesc   :  FunctionPIEDesc;

        gPIEcuftperdaylbsqin2cumpersmPaPIEDesc : ANEPIEDesc;
        gPIEcuftperdaylbsqin2cumpersmPaFDesc   :  FunctionPIEDesc;

const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gOneFloatTypes : array [0..1] of EPIENumberType = (kPIEFloat, 0);



procedure GPIEm_per_sq_sec2ft_per_sq_DayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEft_per_sq_Day2m_per_sq_secMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESec2DayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEDay2SecMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEK2FMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEF2KMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEJ2BTUMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTU2JMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESqm2sqftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESqft2sqmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIECum2CuftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIECuft2CumMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEms2footdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEfootday2msMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEPa2psiMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEpsi2PaMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEmpers2ftperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEftperday2mpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEsqmpers2sqftperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEsqftperday2sqmpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcumpers2cuftperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcuftperday2cumpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIElpers2cuftperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcuftperday2lpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEkgpers2lbperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIElbperday2kgpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEPapers2psiperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEpsiperday2PapersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEkgpercum2lbpercuftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIElbpercuft2kgpercumMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEWpercum2BTUperHcuftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTUperHcuft2WpercumMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEJperkg2BTUperlbMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTUperlb2JperkgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEJperkg2ftlbfperlbmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEftlbfperlbm2JperkgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcumperkg2cuftperlbMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcuftperlb2cumperkgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcumpersqms2cuftpersqftdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcuftpersqftday2cumpersqmsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEWpersqm2BTUperHRsqftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTUperHRsqft2WpersqmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEkgpersqms2lbpersqftdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIElbpersqftday2kgpersqmsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEkgperms2cPMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcP2kgpermsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEJperkgm2BTUperlbftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTUperlbft2JperkgmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEWpermdegC2BTUperfthrdgFMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTUperfthrdgF2WpermdegCMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEWpersqmdegC2BTUperhrsqftdgFMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTUperhrsqftdgF2WpersqmdegCMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEJperkgdegC2BTUperlbdgFMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTUperlbdgF2JperkgdegCMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEJpercumdegC2BTUpercuftdgFMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEBTUpercuftdgF2JpercumdegCMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcumpersmPa2cuftperdaylbsqinMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEcuftperdaylbsqin2cumpersmPaMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses GetAneFunctionsUnit;

procedure GPIESec2DayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/86400;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEDay2SecMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1*86400;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEK2FMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1*1.8 - 459.67;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEF2KMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := (param1 + 459.67)/1.8;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEJ2BTUMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1*9.47817e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTU2JMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/9.47817e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIESqm2sqftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 0.09290304;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIESqft2sqmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 0.09290304;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIECum2CuftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/  0.028316846592;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIECuft2CumMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 0.028316846592;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEms2footdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 3.797267e-5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEfootday2msMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 3.797267e-5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEPa2psiMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 1.450377e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEpsi2PaMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 1.450377e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEmpers2ftperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 2.834646e5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEftperday2mpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 2.834646e5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEsqmpers2sqftperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 9.300018e5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEsqftperday2sqmpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 9.300018e5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcumpers2cuftperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 3.051187e6;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcuftperday2cumpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 3.051187e6;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIElpers2cuftperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 3.051187e3;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcuftperday2lpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 3.051187e3;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEkgpers2lbperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 1.904794e5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIElbperday2kgpersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 1.904794e5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEPapers2psiperdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 12.53126;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEpsiperday2PapersMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 12.53126;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEkgpercum2lbpercuftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 6.242797e-2;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIElbpercuft2kgpercumMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 6.242797e-2;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEWpercum2BTUperHcuftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 9.662109e-2;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTUperHcuft2WpercumMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 9.662109e-2;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEJperkg2BTUperlbMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 4.299226e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTUperlb2JperkgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 4.299226e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEJperkg2ftlbfperlbmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 0.3345526;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEftlbfperlbm2JperkgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 0.3345526;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcumperkg2cuftperlbMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 16.01846;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcuftperlb2cumperkgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 16.01846;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcumpersqms2cuftpersqftdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 2.834646e5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcuftpersqftday2cumpersqmsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 2.834646e5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEWpersqm2BTUperHRsqftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 0.3169983;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTUperHRsqft2WpersqmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 0.3169983;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEkgpersqms2lbpersqftdayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 1.769611e4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIElbpersqftday2kgpersqmsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 1.769611e4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEkgperms2cPMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 1000;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcP2kgpermsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 1000;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEJperkgm2BTUperlbftMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 1.310404e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTUperlbft2JperkgmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 1.310404e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEWpermdegC2BTUperfthrdgFMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 13.86941;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTUperfthrdgF2WpermdegCMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 13.86941;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEWpersqmdegC2BTUperhrsqftdgFMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 0.1761102;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTUperhrsqftdgF2WpersqmdegCMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 0.1761102;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEJperkgdegC2BTUperlbdgFMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 2.388459e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTUperlbdgF2JperkgdegCMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 2.388459e-4;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEJpercumdegC2BTUpercuftdgFMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 1.491066e-5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEBTUpercuftdgF2JpercumdegCMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 1.491066e-5;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcumpersmPa2cuftperdaylbsqinMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1* 6.412138e9;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GPIEcuftperdaylbsqin2cumpersmPaMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1/ 6.412138e9;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIEm_per_sq_sec2ft_per_sq_DayMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1 / 0.3048 * 3600 * 24;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIEft_per_sq_Day2m_per_sq_secMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_DOUBLE_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param1 : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  param1 :=  param1_ptr^;
  result := param1 * 0.3048 / 3600 / 24;
  ANE_DOUBLE_PTR(reply)^ := result;
end;



end.
