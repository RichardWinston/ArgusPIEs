unit GetAneFunctionsUnit;

interface

uses AnePIE, FunctionPIE;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses conversionFunctionUnit;

const
  kMaxFunDesc = 59;

var
        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;

	gPIESec2DayFDesc.name := 'Sec2Day';	        // name of function
	gPIESec2DayFDesc.address := GPIESec2DayMMFun;		// function address
	gPIESec2DayFDesc.returnType := kPIEFloat;		// return value type
	gPIESec2DayFDesc.numParams :=  1;			// number of parameters
	gPIESec2DayFDesc.numOptParams := 0;			// number of optional parameters
	gPIESec2DayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIESec2DayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIESec2DayPIEDesc.name  := 'Sec2Day';		// name of PIE
	gPIESec2DayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIESec2DayPIEDesc.descriptor := @gPIESec2DayFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESec2DayPIEDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEDay2SecFDesc.name := 'Day2Sec';	        // name of function
	gPIEDay2SecFDesc.address := GPIEDay2SecMMFun;		// function address
	gPIEDay2SecFDesc.returnType := kPIEFloat;		// return value type
	gPIEDay2SecFDesc.numParams :=  1;			// number of parameters
	gPIEDay2SecFDesc.numOptParams := 0;			// number of optional parameters
	gPIEDay2SecFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEDay2SecFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEDay2SecPIEDesc.name  := 'Day2Sec';		// name of PIE
	gPIEDay2SecPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEDay2SecPIEDesc.descriptor := @gPIEDay2SecFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEDay2SecPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEK2FFDesc.name := 'K2F';	        // name of function
	gPIEK2FFDesc.address := GPIEK2FMMFun;		// function address
	gPIEK2FFDesc.returnType := kPIEFloat;		// return value type
	gPIEK2FFDesc.numParams :=  1;			// number of parameters
	gPIEK2FFDesc.numOptParams := 0;			// number of optional parameters
	gPIEK2FFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEK2FFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEK2FPIEDesc.name  := 'K2F';		// name of PIE
	gPIEK2FPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEK2FPIEDesc.descriptor := @gPIEK2FFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEK2FPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEF2KFDesc.name := 'F2K';	        // name of function
	gPIEF2KFDesc.address := GPIEF2KMMFun;		// function address
	gPIEF2KFDesc.returnType := kPIEFloat;		// return value type
	gPIEF2KFDesc.numParams :=  1;			// number of parameters
	gPIEF2KFDesc.numOptParams := 0;			// number of optional parameters
	gPIEF2KFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEF2KFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEF2KPIEDesc.name  := 'F2K';		// name of PIE
	gPIEF2KPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEF2KPIEDesc.descriptor := @gPIEF2KFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEF2KPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEJ2BTUFDesc.name := 'J2BTU';	        // name of function
	gPIEJ2BTUFDesc.address := GPIEJ2BTUMMFun;		// function address
	gPIEJ2BTUFDesc.returnType := kPIEFloat;		// return value type
	gPIEJ2BTUFDesc.numParams :=  1;			// number of parameters
	gPIEJ2BTUFDesc.numOptParams := 0;			// number of optional parameters
	gPIEJ2BTUFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEJ2BTUFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEJ2BTUPIEDesc.name  := 'J2BTU';		// name of PIE
	gPIEJ2BTUPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEJ2BTUPIEDesc.descriptor := @gPIEJ2BTUFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEJ2BTUPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTU2JFDesc.name := 'BTU2J';	        // name of function
	gPIEBTU2JFDesc.address := GPIEBTU2JMMFun;		// function address
	gPIEBTU2JFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTU2JFDesc.numParams :=  1;			// number of parameters
	gPIEBTU2JFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTU2JFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTU2JFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTU2JPIEDesc.name  := 'BTU2J';		// name of PIE
	gPIEBTU2JPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTU2JPIEDesc.descriptor := @gPIEBTU2JFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTU2JPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIESqm2sqftFDesc.name := 'sq_m2sq_ft';	        // name of function
	gPIESqm2sqftFDesc.address := GPIESqm2sqftMMFun ;		// function address
	gPIESqm2sqftFDesc.returnType := kPIEFloat;		// return value type
	gPIESqm2sqftFDesc.numParams :=  1;			// number of parameters
	gPIESqm2sqftFDesc.numOptParams := 0;			// number of optional parameters
	gPIESqm2sqftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIESqm2sqftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIESqm2sqftPIEDesc.name  := 'sq_m2sq_ft';		// name of PIE
	gPIESqm2sqftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIESqm2sqftPIEDesc.descriptor := @gPIESqm2sqftFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESqm2sqftPIEDesc ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIESqft2sqmFDesc.name := 'sq_ft2sq_m';	        // name of function
	gPIESqft2sqmFDesc.address := GPIESqft2sqmMMFun;		// function address
	gPIESqft2sqmFDesc.returnType := kPIEFloat;		// return value type
	gPIESqft2sqmFDesc.numParams :=  1;			// number of parameters
	gPIESqft2sqmFDesc.numOptParams := 0;			// number of optional parameters
	gPIESqft2sqmFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIESqft2sqmFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIESqft2sqmPIEDesc.name  := 'sq_ft2sq_m';		// name of PIE
	gPIESqft2sqmPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIESqft2sqmPIEDesc.descriptor := @gPIESqft2sqmFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESqft2sqmPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIECum2CuftFDesc.name := 'cu_m2cu_ft';	        // name of function
	gPIECum2CuftFDesc.address := GPIECum2CuftMMFun;		// function address
	gPIECum2CuftFDesc.returnType := kPIEFloat;		// return value type
	gPIECum2CuftFDesc.numParams :=  1;			// number of parameters
	gPIECum2CuftFDesc.numOptParams := 0;			// number of optional parameters
	gPIECum2CuftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIECum2CuftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIECum2CuftPIEDesc.name  := 'cu_m2cu_ft';		// name of PIE
	gPIECum2CuftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECum2CuftPIEDesc.descriptor := @gPIECum2CuftFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECum2CuftPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIECuft2CumFDesc.name := 'cu_ft2cu_m';	        // name of function
	gPIECuft2CumFDesc.address := GPIECuft2CumMMFun;		// function address
	gPIECuft2CumFDesc.returnType := kPIEFloat;		// return value type
	gPIECuft2CumFDesc.numParams :=  1;			// number of parameters
	gPIECuft2CumFDesc.numOptParams := 0;			// number of optional parameters
	gPIECuft2CumFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIECuft2CumFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIECuft2CumPIEDesc.name  := 'cu_ft2cu_m';		// name of PIE
	gPIECuft2CumPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECuft2CumPIEDesc.descriptor := @gPIECuft2CumFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECuft2CumPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEms2footdayFDesc.name := 'm_s2ft_day';	        // name of function
	gPIEms2footdayFDesc.address := GPIEms2footdayMMFun;		// function address
	gPIEms2footdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEms2footdayFDesc.numParams :=  1;			// number of parameters
	gPIEms2footdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEms2footdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEms2footdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEms2footdayPIEDesc.name  := 'm_s2ft_day';		// name of PIE
	gPIEms2footdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEms2footdayPIEDesc.descriptor := @gPIEms2footdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEms2footdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEfootday2msFDesc.name := 'ft_day2m_s';	        // name of function
	gPIEfootday2msFDesc.address := GPIEfootday2msMMFun;		// function address
	gPIEfootday2msFDesc.returnType := kPIEFloat;		// return value type
	gPIEfootday2msFDesc.numParams :=  1;			// number of parameters
	gPIEfootday2msFDesc.numOptParams := 0;			// number of optional parameters
	gPIEfootday2msFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEfootday2msFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEfootday2msPIEDesc.name  := 'ft_day2m_s';		// name of PIE
	gPIEfootday2msPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEfootday2msPIEDesc.descriptor := @gPIEfootday2msFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEfootday2msPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEPa2psiFDesc.name := 'Pa2psi';	        // name of function
	gPIEPa2psiFDesc.address := GPIEPa2psiMMFun;		// function address
	gPIEPa2psiFDesc.returnType := kPIEFloat;		// return value type
	gPIEPa2psiFDesc.numParams :=  1;			// number of parameters
	gPIEPa2psiFDesc.numOptParams := 0;			// number of optional parameters
	gPIEPa2psiFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEPa2psiFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEPa2psiPIEDesc.name  := 'Pa2psi';		// name of PIE
	gPIEPa2psiPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEPa2psiPIEDesc.descriptor := @gPIEPa2psiFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEPa2psiPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEpsi2PaFDesc.name := 'psi2Pa';	        // name of function
	gPIEpsi2PaFDesc.address := GPIEpsi2PaMMFun;		// function address
	gPIEpsi2PaFDesc.returnType := kPIEFloat;		// return value type
	gPIEpsi2PaFDesc.numParams :=  1;			// number of parameters
	gPIEpsi2PaFDesc.numOptParams := 0;			// number of optional parameters
	gPIEpsi2PaFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEpsi2PaFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEpsi2PaPIEDesc.name  := 'psi2Pa';		// name of PIE
	gPIEpsi2PaPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEpsi2PaPIEDesc.descriptor := @gPIEpsi2PaFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEpsi2PaPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEmpers2ftperdayFDesc.name := 'm_per_s2ft_per_day';	        // name of function
	gPIEmpers2ftperdayFDesc.address := GPIEmpers2ftperdayMMFun;		// function address
	gPIEmpers2ftperdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEmpers2ftperdayFDesc.numParams :=  1;			// number of parameters
	gPIEmpers2ftperdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEmpers2ftperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEmpers2ftperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEmpers2ftperdayPIEDesc.name  := 'm_per_s2ft_per_day';		// name of PIE
	gPIEmpers2ftperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEmpers2ftperdayPIEDesc.descriptor := @gPIEmpers2ftperdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEmpers2ftperdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEftperday2mpersFDesc.name := 'ft_per_day2m_per_s';	        // name of function
	gPIEftperday2mpersFDesc.address := GPIEftperday2mpersMMFun;		// function address
	gPIEftperday2mpersFDesc.returnType := kPIEFloat;		// return value type
	gPIEftperday2mpersFDesc.numParams :=  1;			// number of parameters
	gPIEftperday2mpersFDesc.numOptParams := 0;			// number of optional parameters
	gPIEftperday2mpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEftperday2mpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEftperday2mpersPIEDesc.name  := 'ft_per_day2m_per_s';		// name of PIE
	gPIEftperday2mpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEftperday2mpersPIEDesc.descriptor := @gPIEftperday2mpersFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEftperday2mpersPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEsqmpers2sqftperdayFDesc.name := 'sq_m_per_s2sq_ft_per_day';	        // name of function
	gPIEsqmpers2sqftperdayFDesc.address := GPIEsqmpers2sqftperdayMMFun;		// function address
	gPIEsqmpers2sqftperdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEsqmpers2sqftperdayFDesc.numParams :=  1;			// number of parameters
	gPIEsqmpers2sqftperdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEsqmpers2sqftperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEsqmpers2sqftperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEsqmpers2sqftperdayPIEDesc.name  := 'sq_m_per_s2sq_ft_per_day';		// name of PIE
	gPIEsqmpers2sqftperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEsqmpers2sqftperdayPIEDesc.descriptor := @gPIEsqmpers2sqftperdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEsqmpers2sqftperdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEsqftperday2sqmpersFDesc.name := 'sq_ft_per_day2sq_m_per_s';	        // name of function
	gPIEsqftperday2sqmpersFDesc.address := GPIEsqftperday2sqmpersMMFun;		// function address
	gPIEsqftperday2sqmpersFDesc.returnType := kPIEFloat;		// return value type
	gPIEsqftperday2sqmpersFDesc.numParams :=  1;			// number of parameters
	gPIEsqftperday2sqmpersFDesc.numOptParams := 0;			// number of optional parameters
	gPIEsqftperday2sqmpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEsqftperday2sqmpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEsqftperday2sqmpersPIEDesc.name  := 'sq_ft_per_day2sq_m_per_s';		// name of PIE
	gPIEsqftperday2sqmpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEsqftperday2sqmpersPIEDesc.descriptor := @gPIEsqftperday2sqmpersFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEsqftperday2sqmpersPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcumpers2cuftperdayFDesc.name := 'cu_m_per_s2cu_ft_per_day';	        // name of function
	gPIEcumpers2cuftperdayFDesc.address := GPIEcumpers2cuftperdayMMFun;		// function address
	gPIEcumpers2cuftperdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEcumpers2cuftperdayFDesc.numParams :=  1;			// number of parameters
	gPIEcumpers2cuftperdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcumpers2cuftperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcumpers2cuftperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcumpers2cuftperdayPIEDesc.name  := 'cu_m_per_s2cu_ft_per_day';		// name of PIE
	gPIEcumpers2cuftperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcumpers2cuftperdayPIEDesc.descriptor := @gPIEcumpers2cuftperdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcumpers2cuftperdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcuftperday2cumpersFDesc.name := 'cu_ft_per_day2cu_m_per_s';	        // name of function
	gPIEcuftperday2cumpersFDesc.address := GPIEcuftperday2cumpersMMFun;		// function address
	gPIEcuftperday2cumpersFDesc.returnType := kPIEFloat;		// return value type
	gPIEcuftperday2cumpersFDesc.numParams :=  1;			// number of parameters
	gPIEcuftperday2cumpersFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcuftperday2cumpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcuftperday2cumpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcuftperday2cumpersPIEDesc.name  := 'cu_ft_per_day2cu_m_per_s';		// name of PIE
	gPIEcuftperday2cumpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcuftperday2cumpersPIEDesc.descriptor := @gPIEcuftperday2cumpersFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcuftperday2cumpersPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIElpers2cuftperdayFDesc.name := 'l_per_s2cu_ft_per_day';	        // name of function
	gPIElpers2cuftperdayFDesc.address := GPIElpers2cuftperdayMMFun;		// function address
	gPIElpers2cuftperdayFDesc.returnType := kPIEFloat;		// return value type
	gPIElpers2cuftperdayFDesc.numParams :=  1;			// number of parameters
	gPIElpers2cuftperdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIElpers2cuftperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIElpers2cuftperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIElpers2cuftperdayPIEDesc.name  := 'l_per_s2cu_ft_per_day';		// name of PIE
	gPIElpers2cuftperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIElpers2cuftperdayPIEDesc.descriptor := @gPIElpers2cuftperdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIElpers2cuftperdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcuftperday2lpersFDesc.name := 'cu_ft_per_day2l_per_s';	        // name of function
	gPIEcuftperday2lpersFDesc.address := GPIEcuftperday2lpersMMFun;		// function address
	gPIEcuftperday2lpersFDesc.returnType := kPIEFloat;		// return value type
	gPIEcuftperday2lpersFDesc.numParams :=  1;			// number of parameters
	gPIEcuftperday2lpersFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcuftperday2lpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcuftperday2lpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcuftperday2lpersPIEDesc.name  := 'cu_ft_per_day2l_per_s';		// name of PIE
	gPIEcuftperday2lpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcuftperday2lpersPIEDesc.descriptor := @gPIEcuftperday2lpersFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcuftperday2lpersPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEkgpers2lbperdayFDesc.name := 'kg_per_s2lb_per_day';	        // name of function
	gPIEkgpers2lbperdayFDesc.address := GPIEkgpers2lbperdayMMFun;		// function address
	gPIEkgpers2lbperdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEkgpers2lbperdayFDesc.numParams :=  1;			// number of parameters
	gPIEkgpers2lbperdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEkgpers2lbperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEkgpers2lbperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEkgpers2lbperdayPIEDesc.name  := 'kg_per_s2lb_per_day';		// name of PIE
	gPIEkgpers2lbperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEkgpers2lbperdayPIEDesc.descriptor := @gPIEkgpers2lbperdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEkgpers2lbperdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIElbperday2kgpersFDesc.name := 'lb_per_day2kg_per_s';	        // name of function
	gPIElbperday2kgpersFDesc.address := GPIElbperday2kgpersMMFun;		// function address
	gPIElbperday2kgpersFDesc.returnType := kPIEFloat;		// return value type
	gPIElbperday2kgpersFDesc.numParams :=  1;			// number of parameters
	gPIElbperday2kgpersFDesc.numOptParams := 0;			// number of optional parameters
	gPIElbperday2kgpersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIElbperday2kgpersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIElbperday2kgpersPIEDesc.name  := 'lb_per_day2kg_per_s';		// name of PIE
	gPIElbperday2kgpersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIElbperday2kgpersPIEDesc.descriptor := @gPIElbperday2kgpersFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIElbperday2kgpersPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEPapers2psiperdayFDesc.name := 'Pa_per_s2psi_per_day';	        // name of function
	gPIEPapers2psiperdayFDesc.address := GPIEPapers2psiperdayMMFun;		// function address
	gPIEPapers2psiperdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEPapers2psiperdayFDesc.numParams :=  1;			// number of parameters
	gPIEPapers2psiperdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEPapers2psiperdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEPapers2psiperdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEPapers2psiperdayPIEDesc.name  := 'Pa_per_s2psi_per_day';		// name of PIE
	gPIEPapers2psiperdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEPapers2psiperdayPIEDesc.descriptor := @gPIEPapers2psiperdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEPapers2psiperdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEpsiperday2PapersFDesc.name := 'psi_per_day2Pa_per_s';	        // name of function
	gPIEpsiperday2PapersFDesc.address := GPIEpsiperday2PapersMMFun;		// function address
	gPIEpsiperday2PapersFDesc.returnType := kPIEFloat;		// return value type
	gPIEpsiperday2PapersFDesc.numParams :=  1;			// number of parameters
	gPIEpsiperday2PapersFDesc.numOptParams := 0;			// number of optional parameters
	gPIEpsiperday2PapersFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEpsiperday2PapersFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEpsiperday2PapersPIEDesc.name  := 'psi_per_day2Pa_per_s';		// name of PIE
	gPIEpsiperday2PapersPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEpsiperday2PapersPIEDesc.descriptor := @gPIEpsiperday2PapersFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEpsiperday2PapersPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEkgpercum2lbpercuftFDesc.name := 'kg_per_cu_m2lb_per_cu_ft';	        // name of function
	gPIEkgpercum2lbpercuftFDesc.address := GPIEkgpercum2lbpercuftMMFun;		// function address
	gPIEkgpercum2lbpercuftFDesc.returnType := kPIEFloat;		// return value type
	gPIEkgpercum2lbpercuftFDesc.numParams :=  1;			// number of parameters
	gPIEkgpercum2lbpercuftFDesc.numOptParams := 0;			// number of optional parameters
	gPIEkgpercum2lbpercuftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEkgpercum2lbpercuftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEkgpercum2lbpercuftPIEDesc.name  := 'kg_per_cu_m2lb_per_cu_ft';		// name of PIE
	gPIEkgpercum2lbpercuftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEkgpercum2lbpercuftPIEDesc.descriptor := @gPIEkgpercum2lbpercuftFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEkgpercum2lbpercuftPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIElbpercuft2kgpercumFDesc.name := 'lb_per_cu_ft2kg_per_cu_m';	        // name of function
	gPIElbpercuft2kgpercumFDesc.address := GPIElbpercuft2kgpercumMMFun;		// function address
	gPIElbpercuft2kgpercumFDesc.returnType := kPIEFloat;		// return value type
	gPIElbpercuft2kgpercumFDesc.numParams :=  1;			// number of parameters
	gPIElbpercuft2kgpercumFDesc.numOptParams := 0;			// number of optional parameters
	gPIElbpercuft2kgpercumFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIElbpercuft2kgpercumFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIElbpercuft2kgpercumPIEDesc.name  := 'lb_per_cu_ft2kg_per_cu_m';		// name of PIE
	gPIElbpercuft2kgpercumPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIElbpercuft2kgpercumPIEDesc.descriptor := @gPIElbpercuft2kgpercumFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIElbpercuft2kgpercumPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEWpercum2BTUperHcuftFDesc.name := 'W_per_cu_m2BTU_per_hr_cu_ft';	        // name of function
	gPIEWpercum2BTUperHcuftFDesc.address := GPIEWpercum2BTUperHcuftMMFun;		// function address
	gPIEWpercum2BTUperHcuftFDesc.returnType := kPIEFloat;		// return value type
	gPIEWpercum2BTUperHcuftFDesc.numParams :=  1;			// number of parameters
	gPIEWpercum2BTUperHcuftFDesc.numOptParams := 0;			// number of optional parameters
	gPIEWpercum2BTUperHcuftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEWpercum2BTUperHcuftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEWpercum2BTUperHcuftPIEDesc.name  := 'W_per_cu_m2BTU_per_hr_cu_ft';		// name of PIE
	gPIEWpercum2BTUperHcuftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEWpercum2BTUperHcuftPIEDesc.descriptor := @gPIEWpercum2BTUperHcuftFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEWpercum2BTUperHcuftPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTUperHcuft2WpercumFDesc.name := 'BTU_per_hr_cu_ft2W_per_cu_m';	        // name of function
	gPIEBTUperHcuft2WpercumFDesc.address := GPIEBTUperHcuft2WpercumMMFun;		// function address
	gPIEBTUperHcuft2WpercumFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTUperHcuft2WpercumFDesc.numParams :=  1;			// number of parameters
	gPIEBTUperHcuft2WpercumFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTUperHcuft2WpercumFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTUperHcuft2WpercumFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTUperHcuft2WpercumPIEDesc.name  := 'BTU_per_hr_cu_ft2W_per_cu_m';		// name of PIE
	gPIEBTUperHcuft2WpercumPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTUperHcuft2WpercumPIEDesc.descriptor := @gPIEBTUperHcuft2WpercumFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTUperHcuft2WpercumPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEJperkg2BTUperlbFDesc.name := 'J_per_kg2BTU_per_lb';	        // name of function
	gPIEJperkg2BTUperlbFDesc.address := GPIEJperkg2BTUperlbMMFun;		// function address
	gPIEJperkg2BTUperlbFDesc.returnType := kPIEFloat;		// return value type
	gPIEJperkg2BTUperlbFDesc.numParams :=  1;			// number of parameters
	gPIEJperkg2BTUperlbFDesc.numOptParams := 0;			// number of optional parameters
	gPIEJperkg2BTUperlbFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEJperkg2BTUperlbFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEJperkg2BTUperlbPIEDesc.name  := 'J_per_kg2BTU_per_lb';		// name of PIE
	gPIEJperkg2BTUperlbPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEJperkg2BTUperlbPIEDesc.descriptor := @gPIEJperkg2BTUperlbFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEJperkg2BTUperlbPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTUperlb2JperkgFDesc.name := 'BTU_per_lb2J_per_kg';	        // name of function
	gPIEBTUperlb2JperkgFDesc.address := GPIEBTUperlb2JperkgMMFun;		// function address
	gPIEBTUperlb2JperkgFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTUperlb2JperkgFDesc.numParams :=  1;			// number of parameters
	gPIEBTUperlb2JperkgFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTUperlb2JperkgFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTUperlb2JperkgFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTUperlb2JperkgPIEDesc.name  := 'BTU_per_lb2J_per_kg';		// name of PIE
	gPIEBTUperlb2JperkgPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTUperlb2JperkgPIEDesc.descriptor := @gPIEBTUperlb2JperkgFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTUperlb2JperkgPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEJperkg2ftlbfperlbmFDesc.name := 'J_per_kg2ft_lb_f_per_lb_m';	        // name of function
	gPIEJperkg2ftlbfperlbmFDesc.address := GPIEJperkg2ftlbfperlbmMMFun;		// function address
	gPIEJperkg2ftlbfperlbmFDesc.returnType := kPIEFloat;		// return value type
	gPIEJperkg2ftlbfperlbmFDesc.numParams :=  1;			// number of parameters
	gPIEJperkg2ftlbfperlbmFDesc.numOptParams := 0;			// number of optional parameters
	gPIEJperkg2ftlbfperlbmFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEJperkg2ftlbfperlbmFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEJperkg2ftlbfperlbmPIEDesc.name  := 'J_per_kg2ft_lb_f_per_lb_m';		// name of PIE
	gPIEJperkg2ftlbfperlbmPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEJperkg2ftlbfperlbmPIEDesc.descriptor := @gPIEJperkg2ftlbfperlbmFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEJperkg2ftlbfperlbmPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEftlbfperlbm2JperkgFDesc.name := 'ft_lb_f_per_lb_m2J_per_kg';	        // name of function
	gPIEftlbfperlbm2JperkgFDesc.address := GPIEftlbfperlbm2JperkgMMFun;		// function address
	gPIEftlbfperlbm2JperkgFDesc.returnType := kPIEFloat;		// return value type
	gPIEftlbfperlbm2JperkgFDesc.numParams :=  1;			// number of parameters
	gPIEftlbfperlbm2JperkgFDesc.numOptParams := 0;			// number of optional parameters
	gPIEftlbfperlbm2JperkgFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEftlbfperlbm2JperkgFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEftlbfperlbm2JperkgPIEDesc.name  := 'ft_lb_f_per_lb_m2J_per_kg';		// name of PIE
	gPIEftlbfperlbm2JperkgPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEftlbfperlbm2JperkgPIEDesc.descriptor := @gPIEftlbfperlbm2JperkgFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEftlbfperlbm2JperkgPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcumperkg2cuftperlbFDesc.name := 'cu_m_per_kg2cu_ft_per_lb';	        // name of function
	gPIEcumperkg2cuftperlbFDesc.address := GPIEcumperkg2cuftperlbMMFun;		// function address
	gPIEcumperkg2cuftperlbFDesc.returnType := kPIEFloat;		// return value type
	gPIEcumperkg2cuftperlbFDesc.numParams :=  1;			// number of parameters
	gPIEcumperkg2cuftperlbFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcumperkg2cuftperlbFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcumperkg2cuftperlbFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcumperkg2cuftperlbPIEDesc.name  := 'cu_m_per_kg2cu_ft_per_lb';		// name of PIE
	gPIEcumperkg2cuftperlbPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcumperkg2cuftperlbPIEDesc.descriptor := @gPIEcumperkg2cuftperlbFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcumperkg2cuftperlbPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcuftperlb2cumperkgFDesc.name := 'cu_ft_per_lb2cu_m_per_kg';	        // name of function
	gPIEcuftperlb2cumperkgFDesc.address := GPIEcuftperlb2cumperkgMMFun;		// function address
	gPIEcuftperlb2cumperkgFDesc.returnType := kPIEFloat;		// return value type
	gPIEcuftperlb2cumperkgFDesc.numParams :=  1;			// number of parameters
	gPIEcuftperlb2cumperkgFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcuftperlb2cumperkgFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcuftperlb2cumperkgFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcuftperlb2cumperkgPIEDesc.name  := 'cu_ft_per_lb2cu_m_per_kg';		// name of PIE
	gPIEcuftperlb2cumperkgPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcuftperlb2cumperkgPIEDesc.descriptor := @gPIEcuftperlb2cumperkgFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcuftperlb2cumperkgPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcumpersqms2cuftpersqftdayFDesc.name := 'cu_m_per_sq_m_s2cu_ft_per_sq_ft_day';	        // name of function
	gPIEcumpersqms2cuftpersqftdayFDesc.address := GPIEcumpersqms2cuftpersqftdayMMFun;		// function address
	gPIEcumpersqms2cuftpersqftdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEcumpersqms2cuftpersqftdayFDesc.numParams :=  1;			// number of parameters
	gPIEcumpersqms2cuftpersqftdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcumpersqms2cuftpersqftdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcumpersqms2cuftpersqftdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcumpersqms2cuftpersqftdayPIEDesc.name  := 'cu_m_per_sq_m_s2cu_ft_per_sq_ft_day';		// name of PIE
	gPIEcumpersqms2cuftpersqftdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcumpersqms2cuftpersqftdayPIEDesc.descriptor := @gPIEcumpersqms2cuftpersqftdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcumpersqms2cuftpersqftdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcuftpersqftday2cumpersqmsFDesc.name := 'cu_ft_per_sq_ft_day2cu_m_per_sq_m_s';	        // name of function
	gPIEcuftpersqftday2cumpersqmsFDesc.address := GPIEcuftpersqftday2cumpersqmsMMFun;		// function address
	gPIEcuftpersqftday2cumpersqmsFDesc.returnType := kPIEFloat;		// return value type
	gPIEcuftpersqftday2cumpersqmsFDesc.numParams :=  1;			// number of parameters
	gPIEcuftpersqftday2cumpersqmsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcuftpersqftday2cumpersqmsFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcuftpersqftday2cumpersqmsFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcuftpersqftday2cumpersqmsPIEDesc.name  := 'cu_ft_per_sq_ft_day2cu_m_per_sq_m_s';		// name of PIE
	gPIEcuftpersqftday2cumpersqmsPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcuftpersqftday2cumpersqmsPIEDesc.descriptor := @gPIEcuftpersqftday2cumpersqmsFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcuftpersqftday2cumpersqmsPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEWpersqm2BTUperHRsqftFDesc.name := 'W_per_sq_m2BTU_per_hr_sq_ft';	        // name of function
	gPIEWpersqm2BTUperHRsqftFDesc.address := GPIEWpersqm2BTUperHRsqftMMFun;		// function address
	gPIEWpersqm2BTUperHRsqftFDesc.returnType := kPIEFloat;		// return value type
	gPIEWpersqm2BTUperHRsqftFDesc.numParams :=  1;			// number of parameters
	gPIEWpersqm2BTUperHRsqftFDesc.numOptParams := 0;			// number of optional parameters
	gPIEWpersqm2BTUperHRsqftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEWpersqm2BTUperHRsqftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEWpersqm2BTUperHRsqftPIEDesc.name  := 'W_per_sq_m2BTU_per_hr_sq_ft';		// name of PIE
	gPIEWpersqm2BTUperHRsqftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEWpersqm2BTUperHRsqftPIEDesc.descriptor := @gPIEWpersqm2BTUperHRsqftFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEWpersqm2BTUperHRsqftPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTUperHRsqft2WpersqmFDesc.name := 'BTU_per_hr_sq_ft2W_per_sq_m';	        // name of function
	gPIEBTUperHRsqft2WpersqmFDesc.address := GPIEBTUperHRsqft2WpersqmMMFun;		// function address
	gPIEBTUperHRsqft2WpersqmFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTUperHRsqft2WpersqmFDesc.numParams :=  1;			// number of parameters
	gPIEBTUperHRsqft2WpersqmFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTUperHRsqft2WpersqmFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTUperHRsqft2WpersqmFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTUperHRsqft2WpersqmPIEDesc.name  := 'BTU_per_hr_sq_ft2W_per_sq_m';		// name of PIE
	gPIEBTUperHRsqft2WpersqmPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTUperHRsqft2WpersqmPIEDesc.descriptor := @gPIEBTUperHRsqft2WpersqmFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTUperHRsqft2WpersqmPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEkgpersqms2lbpersqftdayFDesc.name := 'kg_per_sq_m_s2lb_per_sq_ft_day';	        // name of function
	gPIEkgpersqms2lbpersqftdayFDesc.address := GPIEkgpersqms2lbpersqftdayMMFun ;		// function address
	gPIEkgpersqms2lbpersqftdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEkgpersqms2lbpersqftdayFDesc.numParams :=  1;			// number of parameters
	gPIEkgpersqms2lbpersqftdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEkgpersqms2lbpersqftdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEkgpersqms2lbpersqftdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEkgpersqms2lbpersqftdayPIEDesc.name  := 'kg_per_sq_m_s2lb_per_sq_ft_day';		// name of PIE
	gPIEkgpersqms2lbpersqftdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEkgpersqms2lbpersqftdayPIEDesc.descriptor := @gPIEkgpersqms2lbpersqftdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEkgpersqms2lbpersqftdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIElbpersqftday2kgpersqmsFDesc.name := 'lb_per_sq_ft_day2kg_per_sq_m_s';	        // name of function
	gPIElbpersqftday2kgpersqmsFDesc.address := GPIElbpersqftday2kgpersqmsMMFun ;		// function address
	gPIElbpersqftday2kgpersqmsFDesc.returnType := kPIEFloat;		// return value type
	gPIElbpersqftday2kgpersqmsFDesc.numParams :=  1;			// number of parameters
	gPIElbpersqftday2kgpersqmsFDesc.numOptParams := 0;			// number of optional parameters
	gPIElbpersqftday2kgpersqmsFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIElbpersqftday2kgpersqmsFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIElbpersqftday2kgpersqmsPIEDesc.name  := 'lb_per_sq_ft_day2kg_per_sq_m_s';		// name of PIE
	gPIElbpersqftday2kgpersqmsPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIElbpersqftday2kgpersqmsPIEDesc.descriptor := @gPIElbpersqftday2kgpersqmsFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIElbpersqftday2kgpersqmsPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEkgperms2cPFDesc.name := 'kg_per_m_s2cP';	        // name of function
	gPIEkgperms2cPFDesc.address := GPIEkgperms2cPMMFun ;		// function address
	gPIEkgperms2cPFDesc.returnType := kPIEFloat;		// return value type
	gPIEkgperms2cPFDesc.numParams :=  1;			// number of parameters
	gPIEkgperms2cPFDesc.numOptParams := 0;			// number of optional parameters
	gPIEkgperms2cPFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEkgperms2cPFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEkgperms2cPPIEDesc.name  := 'kg_per_m_s2cP';		// name of PIE
	gPIEkgperms2cPPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEkgperms2cPPIEDesc.descriptor := @gPIEkgperms2cPFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEkgperms2cPPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcP2kgpermsFDesc.name := 'cP2kg_per_m_s';	        // name of function
	gPIEcP2kgpermsFDesc.address := GPIEcP2kgpermsMMFun ;		// function address
	gPIEcP2kgpermsFDesc.returnType := kPIEFloat;		// return value type
	gPIEcP2kgpermsFDesc.numParams :=  1;			// number of parameters
	gPIEcP2kgpermsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcP2kgpermsFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcP2kgpermsFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcP2kgpermsPIEDesc.name  := 'cP2kg_per_m_s';		// name of PIE
	gPIEcP2kgpermsPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcP2kgpermsPIEDesc.descriptor := @gPIEcP2kgpermsFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcP2kgpermsPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEJperkgm2BTUperlbftFDesc.name := 'J_per_kg_m2BTU_per_lb_ft';	        // name of function
	gPIEJperkgm2BTUperlbftFDesc.address := GPIEJperkgm2BTUperlbftMMFun ;		// function address
	gPIEJperkgm2BTUperlbftFDesc.returnType := kPIEFloat;		// return value type
	gPIEJperkgm2BTUperlbftFDesc.numParams :=  1;			// number of parameters
	gPIEJperkgm2BTUperlbftFDesc.numOptParams := 0;			// number of optional parameters
	gPIEJperkgm2BTUperlbftFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEJperkgm2BTUperlbftFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEJperkgm2BTUperlbftPIEDesc.name  := 'J_per_kg_m2BTU_per_lb_ft';		// name of PIE
	gPIEJperkgm2BTUperlbftPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEJperkgm2BTUperlbftPIEDesc.descriptor := @gPIEJperkgm2BTUperlbftFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEJperkgm2BTUperlbftPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTUperlbft2JperkgmFDesc.name := 'BTU_per_lb_ft2J_per_kg_m';	        // name of function
	gPIEBTUperlbft2JperkgmFDesc.address := GPIEBTUperlbft2JperkgmMMFun ;		// function address
	gPIEBTUperlbft2JperkgmFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTUperlbft2JperkgmFDesc.numParams :=  1;			// number of parameters
	gPIEBTUperlbft2JperkgmFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTUperlbft2JperkgmFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTUperlbft2JperkgmFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTUperlbft2JperkgmPIEDesc.name  := 'BTU_per_lb_ft2J_per_kg_m';		// name of PIE
	gPIEBTUperlbft2JperkgmPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTUperlbft2JperkgmPIEDesc.descriptor := @gPIEBTUperlbft2JperkgmFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTUperlbft2JperkgmPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEWpermdegC2BTUperlbfthrdgFFDesc.name := 'W_per_m_deg_C2BTU_per_ft_hr_deg_F';	        // name of function
	gPIEWpermdegC2BTUperlbfthrdgFFDesc.address := GPIEWpermdegC2BTUperfthrdgFMMFun ;		// function address
	gPIEWpermdegC2BTUperlbfthrdgFFDesc.returnType := kPIEFloat;		// return value type
	gPIEWpermdegC2BTUperlbfthrdgFFDesc.numParams :=  1;			// number of parameters
	gPIEWpermdegC2BTUperlbfthrdgFFDesc.numOptParams := 0;			// number of optional parameters
	gPIEWpermdegC2BTUperlbfthrdgFFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEWpermdegC2BTUperlbfthrdgFFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEWpermdegC2BTUperlbfthrdgFPIEDesc.name  := 'W_per_m_deg_C2BTU_per_ft_hr_deg_F';		// name of PIE
	gPIEWpermdegC2BTUperlbfthrdgFPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEWpermdegC2BTUperlbfthrdgFPIEDesc.descriptor := @gPIEWpermdegC2BTUperlbfthrdgFFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEWpermdegC2BTUperlbfthrdgFPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTUperlbfthrdgF2WpermdegCFDesc.name := 'BTU_per_ft_hr_deg_F2W_per_m_deg_C';	        // name of function
	gPIEBTUperlbfthrdgF2WpermdegCFDesc.address := GPIEBTUperfthrdgF2WpermdegCMMFun ;		// function address
	gPIEBTUperlbfthrdgF2WpermdegCFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTUperlbfthrdgF2WpermdegCFDesc.numParams :=  1;			// number of parameters
	gPIEBTUperlbfthrdgF2WpermdegCFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTUperlbfthrdgF2WpermdegCFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTUperlbfthrdgF2WpermdegCFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTUperlbfthrdgF2WpermdegCPIEDesc.name  := 'BTU_per_ft_hr_deg_F2W_per_m_deg_C';		// name of PIE
	gPIEBTUperlbfthrdgF2WpermdegCPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTUperlbfthrdgF2WpermdegCPIEDesc.descriptor := @gPIEBTUperlbfthrdgF2WpermdegCFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTUperlbfthrdgF2WpermdegCPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.name := 'W_per_sq_m_deg_C2BTU_per_hr_sq_ft_deg_F';	        // name of function
	gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.address := GPIEWpersqmdegC2BTUperhrsqftdgFMMFun ;		// function address
	gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.returnType := kPIEFloat;		// return value type
	gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.numParams :=  1;			// number of parameters
	gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.numOptParams := 0;			// number of optional parameters
	gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc.name  := 'W_per_sq_m_deg_C2BTU_per_lb_sq_ft_hr_deg_F';		// name of PIE
	gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc.descriptor := @gPIEWpersqmdegC2BTUperlbsqfthrdgFFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEWpersqmdegC2BTUperlbsqfthrdgFPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.name := 'BTU_per_hr_sq_ft_deg_F2W_per_sq_m_deg_C';	        // name of function
	gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.address := GPIEBTUperhrsqftdgF2WpersqmdegCMMFun ;		// function address
	gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.numParams :=  1;			// number of parameters
	gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc.name  := 'BTU_per_lb_sq_ft_hr_deg_F2W_per_sq_m_deg_C';		// name of PIE
	gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc.descriptor := @gPIEBTUperlbsqfthrdgF2WpersqmdegCFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTUperlbsqfthrdgF2WpersqmdegCPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEJperkgdegC2BTUperlbdgFFDesc.name := 'J_per_kg_deg_C2BTU_per_lb_deg_F';	        // name of function
	gPIEJperkgdegC2BTUperlbdgFFDesc.address := GPIEJperkgdegC2BTUperlbdgFMMFun ;		// function address
	gPIEJperkgdegC2BTUperlbdgFFDesc.returnType := kPIEFloat;		// return value type
	gPIEJperkgdegC2BTUperlbdgFFDesc.numParams :=  1;			// number of parameters
	gPIEJperkgdegC2BTUperlbdgFFDesc.numOptParams := 0;			// number of optional parameters
	gPIEJperkgdegC2BTUperlbdgFFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEJperkgdegC2BTUperlbdgFFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEJperkgdegC2BTUperlbdgFPIEDesc.name  := 'J_per_kg_deg_C2BTU_per_lb_deg_F';		// name of PIE
	gPIEJperkgdegC2BTUperlbdgFPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEJperkgdegC2BTUperlbdgFPIEDesc.descriptor := @gPIEJperkgdegC2BTUperlbdgFFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEJperkgdegC2BTUperlbdgFPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTUperlbdgF2JperkgdegCFDesc.name := 'BTU_per_lb_deg_F2J_per_kg_deg_C';	        // name of function
	gPIEBTUperlbdgF2JperkgdegCFDesc.address := GPIEBTUperlbdgF2JperkgdegCMMFun ;		// function address
	gPIEBTUperlbdgF2JperkgdegCFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTUperlbdgF2JperkgdegCFDesc.numParams :=  1;			// number of parameters
	gPIEBTUperlbdgF2JperkgdegCFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTUperlbdgF2JperkgdegCFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTUperlbdgF2JperkgdegCFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTUperlbdgF2JperkgdegCPIEDesc.name  := 'BTU_per_lb_deg_F2J_per_kg_deg_C';		// name of PIE
	gPIEBTUperlbdgF2JperkgdegCPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTUperlbdgF2JperkgdegCPIEDesc.descriptor := @gPIEBTUperlbdgF2JperkgdegCFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTUperlbdgF2JperkgdegCPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEJpercumdegC2BTUpercuftdgFFDesc.name := 'J_per_cu_m_deg_C2BTU_per_cu_ft_deg_F';	        // name of function
	gPIEJpercumdegC2BTUpercuftdgFFDesc.address := GPIEJpercumdegC2BTUpercuftdgFMMFun ;		// function address
	gPIEJpercumdegC2BTUpercuftdgFFDesc.returnType := kPIEFloat;		// return value type
	gPIEJpercumdegC2BTUpercuftdgFFDesc.numParams :=  1;			// number of parameters
	gPIEJpercumdegC2BTUpercuftdgFFDesc.numOptParams := 0;			// number of optional parameters
	gPIEJpercumdegC2BTUpercuftdgFFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEJpercumdegC2BTUpercuftdgFFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEJpercumdegC2BTUpercuftdgFPIEDesc.name  := 'J_per_cu_m_deg_C2BTU_per_cu_ft_deg_F';		// name of PIE
	gPIEJpercumdegC2BTUpercuftdgFPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEJpercumdegC2BTUpercuftdgFPIEDesc.descriptor := @gPIEJpercumdegC2BTUpercuftdgFFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEJpercumdegC2BTUpercuftdgFPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEBTUpercuftdgF2JpercumdegCFDesc.name := 'BTU_per_cu_ft_deg_F2J_per_cu_m_deg_C';	        // name of function
	gPIEBTUpercuftdgF2JpercumdegCFDesc.address := GPIEBTUpercuftdgF2JpercumdegCMMFun ;		// function address
	gPIEBTUpercuftdgF2JpercumdegCFDesc.returnType := kPIEFloat;		// return value type
	gPIEBTUpercuftdgF2JpercumdegCFDesc.numParams :=  1;			// number of parameters
	gPIEBTUpercuftdgF2JpercumdegCFDesc.numOptParams := 0;			// number of optional parameters
	gPIEBTUpercuftdgF2JpercumdegCFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEBTUpercuftdgF2JpercumdegCFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEBTUpercuftdgF2JpercumdegCPIEDesc.name  := 'BTU_per_cu_ft_deg_F2J_per_cu_m_deg_C';		// name of PIE
	gPIEBTUpercuftdgF2JpercumdegCPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEBTUpercuftdgF2JpercumdegCPIEDesc.descriptor := @gPIEBTUpercuftdgF2JpercumdegCFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEBTUpercuftdgF2JpercumdegCPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcumpersmPa2cuftperdaylbsqinFDesc.name := 'cu_m_per_s_m_Pa2cu_ft_per_day_lb_sq_in';	        // name of function
	gPIEcumpersmPa2cuftperdaylbsqinFDesc.address := GPIEcumpersmPa2cuftperdaylbsqinMMFun ;		// function address
	gPIEcumpersmPa2cuftperdaylbsqinFDesc.returnType := kPIEFloat;		// return value type
	gPIEcumpersmPa2cuftperdaylbsqinFDesc.numParams :=  1;			// number of parameters
	gPIEcumpersmPa2cuftperdaylbsqinFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcumpersmPa2cuftperdaylbsqinFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcumpersmPa2cuftperdaylbsqinFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcumpersmPa2cuftperdaylbsqinPIEDesc.name  := 'cu_m_per_s_m_Pa2cu_ft_per_day_lb_sq_in';		// name of PIE
	gPIEcumpersmPa2cuftperdaylbsqinPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcumpersmPa2cuftperdaylbsqinPIEDesc.descriptor := @gPIEcumpersmPa2cuftperdaylbsqinFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcumpersmPa2cuftperdaylbsqinPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEcuftperdaylbsqin2cumpersmPaFDesc.name := 'cu_ft_per_day_lb_sq_in2cu_m_per_s_m_Pa';	        // name of function
	gPIEcuftperdaylbsqin2cumpersmPaFDesc.address := GPIEcuftperdaylbsqin2cumpersmPaMMFun ;		// function address
	gPIEcuftperdaylbsqin2cumpersmPaFDesc.returnType := kPIEFloat;		// return value type
	gPIEcuftperdaylbsqin2cumpersmPaFDesc.numParams :=  1;			// number of parameters
	gPIEcuftperdaylbsqin2cumpersmPaFDesc.numOptParams := 0;			// number of optional parameters
	gPIEcuftperdaylbsqin2cumpersmPaFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEcuftperdaylbsqin2cumpersmPaFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEcuftperdaylbsqin2cumpersmPaPIEDesc.name  := 'cu_ft_per_day_lb_sq_in2cu_m_per_s_m_Pa';		// name of PIE
	gPIEcuftperdaylbsqin2cumpersmPaPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEcuftperdaylbsqin2cumpersmPaPIEDesc.descriptor := @gPIEcuftperdaylbsqin2cumpersmPaFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEcuftperdaylbsqin2cumpersmPaPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEm_per_sq_sec2ft_per_sqdayFDesc.name := 'm_per_sq_sec2ft_per_sq_day';	        // name of function
	gPIEm_per_sq_sec2ft_per_sqdayFDesc.address := GPIEm_per_sq_sec2ft_per_sq_DayMMFun  ;		// function address
	gPIEm_per_sq_sec2ft_per_sqdayFDesc.returnType := kPIEFloat;		// return value type
	gPIEm_per_sq_sec2ft_per_sqdayFDesc.numParams :=  1;			// number of parameters
	gPIEm_per_sq_sec2ft_per_sqdayFDesc.numOptParams := 0;			// number of optional parameters
	gPIEm_per_sq_sec2ft_per_sqdayFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEm_per_sq_sec2ft_per_sqdayFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEm_per_sq_sec2ft_per_sqdayPIEDesc.name  := 'm_per_sq_sec2ft_per_sq_day';		// name of PIE
	gPIEm_per_sq_sec2ft_per_sqdayPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEm_per_sq_sec2ft_per_sqdayPIEDesc.descriptor := @gPIEm_per_sq_sec2ft_per_sqdayFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEm_per_sq_sec2ft_per_sqdayPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEft_per_sqday2m_per_sq_secFDesc.name := 'ft_per_sq_day2m_per_sq_sec';	        // name of function
	gPIEft_per_sqday2m_per_sq_secFDesc.address := GPIEft_per_sq_Day2m_per_sq_secMMFun ;		// function address
	gPIEft_per_sqday2m_per_sq_secFDesc.returnType := kPIEFloat;		// return value type
	gPIEft_per_sqday2m_per_sq_secFDesc.numParams :=  1;			// number of parameters
	gPIEft_per_sqday2m_per_sq_secFDesc.numOptParams := 0;			// number of optional parameters
	gPIEft_per_sqday2m_per_sq_secFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEft_per_sqday2m_per_sq_secFDesc.paramTypes := @gOneFloatTypes;	// pointer to parameters types list

       	gPIEft_per_sqday2m_per_sq_secPIEDesc.name  := 'ft_per_sq_day2m_per_sq_sec';		// name of PIE
	gPIEft_per_sqday2m_per_sq_secPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEft_per_sqday2m_per_sq_secPIEDesc.descriptor := @gPIEft_per_sqday2m_per_sq_secFDesc ;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEft_per_sqday2m_per_sq_secPIEDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names


	descriptors := @gFunDesc;

end;

end.
