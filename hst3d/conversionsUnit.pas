unit conversionsUnit;

interface

function m2Ft(Value : double) : double;
function ft2m(Value : double) : double;
function Pa2psi(Value : double) : double;
function psi2Pa(Value : double) : double;
function InvPa2Invpsi(Value : double) : double;
function Invpsi2InvPa(Value : double) : double;
function C2F (Value : double) : double;
function F2C (Value : double) : double;
function kg_per_cum_2_lb_per_cuft(Value : double) : double;
function lb_per_cuft_2_kg_per_cum(Value : double) : double;
function Pas2cP (Value : double) : double;
function cP2Pas (Value : double) : double;
function J_per_kgC_2_BTU_per_lbF (Value : double) : double;
function BTU_per_lbF_2_J_per_kgC (Value : double) : double;
function W_per_mC_2_BTU_per_fthrF (Value : double) : double;
function BTU_per_fthrF_2_W_per_mC (Value : double) : double;
function InvC2InvF(Value : double) : double;
function InvF2InvC(Value : double) : double;
function cum2cuft(Value : double) : double;
function cuft2cum(Value : double) : double;
function sqm2sqft(Value : double) : double;
function sqft2sqm(Value : double) : double;
function cum_per_s_2_cuft_per_d(Value : double) : double;
function cuft_per_d_2_cum_per_s(Value : double) : double;
function W_per_sqmC_2_BTU_per_hrSqftF(Value : double) : double;
function BTU_per_hrSqftF_2_W_per_sqmC(Value : double) : double;
function sqm_per_s_2_sqft_per_day(Value : double) : double;
function sqft_per_day_2_sqm_per_s(Value : double) : double;

implementation

uses Math;

const

kPa2psi = 1.450377e-4;
kkg2lb = 2.204622;
Km2ft = 1/0.3048;
kPas2cP = 1000;
Kkg_per_sqm_2_lb_per_sqft = kkg2lb/(km2ft*km2ft);
Kkg_per_cum_2_lb_per_cuft = kkg2lb/(km2ft*km2ft*km2ft);
kJ_per_kgC_2_BTU_per_lbF =  2.388459e-4;
kW_per_mC_2_BTU_per_fthrF = 13.86941;
sec_per_day = 24*3600 ;
kW_per_sqmC_2_BTU_per_hrSqftF = 0.1761102;
ksqm_per_s_2_sqft_per_day = 9.300018e5;

function m2Ft(Value : double) : double;
begin
  result := Value * Km2ft;
end;
function ft2m(Value : double) : double;
begin
  result := Value / Km2ft;
end;
function Pa2psi(Value : double) : double;
begin
  result := Value * kPa2psi;
end;
function psi2Pa(Value : double) : double;
begin
  result := Value / kPa2psi;
end;
function InvPa2Invpsi(Value : double) : double;
begin
  if Value = 0
  then
    begin
      result := 0;
    end
  else
    begin
      result := 1/Pa2psi(1/Value);
    end;
end;
function Invpsi2InvPa(Value : double) : double;
begin
  if Value = 0
  then
    begin
      result := 0;
    end
  else
    begin
      result := 1/psi2Pa(1/Value);
    end;
end;
function C2F (Value : double) : double;
begin
  result := Value * 9/5 + 32;
end;
function F2C (Value : double) : double;
begin
  result := (Value - 32) * 5/9 ;
end;
function kg_per_cum_2_lb_per_cuft(Value : double) : double;
begin
  result := Value * Kkg_per_cum_2_lb_per_cuft;
end;
function lb_per_cuft_2_kg_per_cum(Value : double) : double;
begin
  result := Value / Kkg_per_cum_2_lb_per_cuft;
end;
function Pas2cP (Value : double) : double;
begin
  result := Value * kPas2cP;
end;
function cP2Pas (Value : double) : double;
begin
  result := Value / kPas2cP;
end;
function J_per_kgC_2_BTU_per_lbF (Value : double) : double;
begin
  result := Value * kJ_per_kgC_2_BTU_per_lbF;
end;
function BTU_per_lbF_2_J_per_kgC (Value : double) : double;
begin
  result := Value / kJ_per_kgC_2_BTU_per_lbF;
end;
function W_per_mC_2_BTU_per_fthrF (Value : double) : double;
begin
  result := Value * kW_per_mC_2_BTU_per_fthrF;
end;
function BTU_per_fthrF_2_W_per_mC (Value : double) : double;
begin
  result := Value / kW_per_mC_2_BTU_per_fthrF;
end;
function InvC2InvF(Value : double) : double;
begin
  result := Value*5/9;
end;
function InvF2InvC(Value : double) : double;
begin
  result := Value*9/5;
end;
function cum2cuft(Value : double) : double;
begin
  result := Value * Power(km2ft,3);
end;
function cuft2cum(Value : double) : double;
begin
  result := Value / Power(km2ft,3);
end;
function sqm2sqft(Value : double) : double;
begin
  result := Value * Sqr(km2ft);
end;
function sqft2sqm(Value : double) : double;
begin
  result := Value / Sqr(km2ft);
end;
function cum_per_s_2_cuft_per_d(Value : double) : double;
begin
  result := Value * Power(Km2ft,3) * sec_per_day;
end;
function cuft_per_d_2_cum_per_s(Value : double) : double;
begin
  result := Value / Power(Km2ft,3) / sec_per_day;
end;

function W_per_sqmC_2_BTU_per_hrSqftF(Value : double) : double;
begin
  result := Value * kW_per_sqmC_2_BTU_per_hrSqftF;
end;

function BTU_per_hrSqftF_2_W_per_sqmC(Value : double) : double;
begin
  result := Value / kW_per_sqmC_2_BTU_per_hrSqftF;
end;

function sqm_per_s_2_sqft_per_day(Value : double) : double;
begin
  result := Value * ksqm_per_s_2_sqft_per_day;
end;

function sqft_per_day_2_sqm_per_s(Value : double) : double;
begin
  result := Value / ksqm_per_s_2_sqft_per_day;
end;

end.
