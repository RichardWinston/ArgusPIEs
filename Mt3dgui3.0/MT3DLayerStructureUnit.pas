unit MT3DLayerStructureUnit;

interface

uses
  ANE_LayerUnit, MFLayerStructureUnit;

type
  TMT3DGeologicUnit = Class(TMFGeologicUnit)
    constructor Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
  Index: Integer); override;
  end;

  TMT3DLayerStructure = class (TMFLayerStructure)
    constructor Create;
  end;

implementation

uses Variables;

constructor TMT3DGeologicUnit.Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
  Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
//  LayerOrder.Add(ModflowTypes.GetMFRBWStreamLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFLakeLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFLineSeepageLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMFAreaSeepageLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DInactiveAreaLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DPorosityLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DPointConstantConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DAreaConstantConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DPointTimeVaryConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName);
  LayerOrder.Add(ModflowTypes.GetMT3DAreaInitConcLayerType.ANE_LayerName);
{  if frmMODFLOW.cbRBWSTR.Checked then
  begin
    ModflowTypes.GetMFRBWStreamLayerType.Create(self, -1);
  end;   }
  if frmMODFLOW.cbLAK.Checked then
  begin
    ModflowTypes.GetMFLakeLayerType.Create(self, -1);
  end;
  if frmMODFLOW.cbSPG.Checked then
  begin
    ModflowTypes.GetMFLineSeepageLayerType.Create(self, -1);
    ModflowTypes.GetMFAreaSeepageLayerType.Create(self, -1);
  end;
  if frmMODFLOW.cbMT3D.Checked then
  begin
    ModflowTypes.GetMT3DInactiveAreaLayerType.Create(self, -1);
    ModflowTypes.GetMT3DPorosityLayerType.Create(self, -1);
    ModflowTypes.GetMT3DObservationsLayerType.Create(self, -1);
    ModflowTypes.GetMT3DPointInitConcLayerType.Create(self, -1);
    ModflowTypes.GetMT3DAreaInitConcLayerType.Create(self, -1);
    if frmMODFLOW.cbSSM.Checked then
    begin
      ModflowTypes.GetMT3DPointConstantConcLayerType.Create(self, -1);
      ModflowTypes.GetMT3DAreaConstantConcLayerType.Create(self, -1);
      if frmMODFLOW.cbMT3D_TVC.Checked then
      begin
        ModflowTypes.GetMT3DPointTimeVaryConcLayerType.Create(self, -1);
        ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.Create(self, -1);
      end;
    end;
  end;
end;

constructor TMT3DLayerStructure.Create;
begin
  inherited Create;
  UnIndexedLayers.LayerOrder.Add(ModflowTypes.GetMT3DDomOutlineLayerType.ANE_LayerName);
  if frmMODFLOW.cbMT3D.Checked then
  begin
    ModflowTypes.GetMT3DDomOutlineLayerType.Create(UnIndexedLayers, -1);
  end;
end;


end.
