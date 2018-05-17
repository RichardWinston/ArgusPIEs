unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, ArgusDataEntry, ExtCtrls, Grids, ComCtrls,
  Buttons, ANE_LayerUnit;

type
  TfrmMain = class(TArgusForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    tab2: TTabSheet;
    tab1: TTabSheet;
    Panel2: TPanel;
    sgGeolUnits: TStringGrid;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    Panel5: TPanel;
    btnAddUnit: TButton;
    btnInsertUnit: TButton;
    btnDeleteUnit: TButton;
    btnDeleteTime: TButton;
    btnInsertTime: TButton;
    btnAddTime: TButton;
    adeInteger: TArgusDataEntry;
    adeReal: TArgusDataEntry;
    Label1: TLabel;
    Label2: TLabel;
    edString: TEdit;
    Label3: TLabel;
    cbOptionalParameter: TCheckBox;
    cbOptionalLayers: TCheckBox;
    sgTimes: TStringGrid;
    Label4: TLabel;
    Label5: TLabel;
    lblVersionCaption: TLabel;
    lblVersion: TLabel;
    tabProblem: TTabSheet;
    reProblem: TRichEdit;
    edModelPath: TEdit;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure cbOptionalParameterClick(Sender: TObject);
    procedure cbOptionalLayersClick(Sender: TObject);
    procedure ChangeNumberOfTimes(Sender: TObject);
    procedure ChangeNumUnits(Sender: TObject);
    procedure btnInsertUnitClick(Sender: TObject);
    procedure btnDeleteTimeClick(Sender: TObject);
    procedure btnInsertTimeClick(Sender: TObject);
  private
    GeologicUnitParametersList : TList;
    GeologicUnitsList : TList;
    procedure InitializeGrids;
    procedure CreateGeologicLayer(Position: integer);
    procedure DeleteGeologicLayer(Position: integer);
    procedure DeleteTimeParameters(Position: Integer);
    procedure InsertTimeParameters(Position: integer);
    { Private declarations }
  public
    LayerStructure : TLayerStructure;
    procedure AssociateTimes;
    procedure AssociateUnits;
    function NumberOfGeologicUnits : integer;
    function NumberOfTimes : integer;
    procedure LoadMyForm(UnreadData: TStringlist; DataToRead: string;
      var VersionInString: string);
    procedure ModelComponentName(AStringList: TStringList); override;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses MainLayerStructure;

{ TfrmMain }

function TfrmMain.NumberOfGeologicUnits: integer;
begin
  result := sgGeolUnits.RowCount -1;
end;

function TfrmMain.NumberOfTimes: integer;
begin
  result := sgTimes.RowCount -1;
end;

procedure TfrmMain.LoadMyForm(UnreadData: TStringlist;
  DataToRead: string; var VersionInString: string);
begin
  // called by btnOpenValClick
  // called by ReadValFile
  // called by GLoadForm in Project Functions
  // in cases where ArgusDataEntries check maximum values, temporarily
  // disable the checks.
  adeInteger.CheckMax := False;
  adeInteger.CheckMin := False;

  LoadForm(UnreadData, DataToRead, VersionInString, lblVersion);

  // in cases where ArgusDataEntries check maximum values,
  // re-enable the checks.
  adeInteger.CheckMax := True;
  adeInteger.CheckMin := True;

end;

Procedure TfrmMain.AssociateUnits;
var
  GeolUnitIndex : Integer;
  AGeologicUnit : T_ANE_IndexedLayerList;
begin

  // Free the list of layer-lists and the list of parameter-lists
  GeologicUnitsList.Free;
  GeologicUnitParametersList.Free;

  // create a new list of layer-lists
  GeologicUnitsList := TList.Create;

  // Add geologic units whose status is not sDeleted to te list of layer-lists
  for GeolUnitIndex := 0 to NumberOfGeologicUnits -1 do
  begin
    AGeologicUnit := LayerStructure.ListsOfIndexedLayers.
      GetNonDeletedIndLayerListByIndex(GeolUnitIndex);

    GeologicUnitsList.Add(AGeologicUnit);
  end;

  // create a new list of parameter-lists that are related to a geologic unit.
  // By convention, ParameterList1 is used for parameter lists related to
  // geologic units
  GeologicUnitParametersList
    := LayerStructure.MakeParameter1Lists(NumberOfGeologicUnits);

end;

Procedure TfrmMain.AssociateTimes;
Var
  ListOfParameterLists  : TList;
  AParameterList : TList ;
  ParameterListIndex : integer;
begin

  // This procedure associates lists of time-related parameters with
  // sgTimes grid.

  // First get rid of all the existing lists of parameter lists.
  for ParameterListIndex := 1 to sgTimes.RowCount -1 do
  begin
    AParameterList := sgTimes.Objects[0, ParameterListIndex] as TList;
    AParameterList.Free;
    sgTimes.Objects[0, ParameterListIndex] := nil;
  end;

  // create new lists of parameter-lists.
  ListOfParameterLists
    := LayerStructure.MakeParameter2Lists(NumberOfTimes);

  // put those lists in the objects property of dgTime
  for ParameterListIndex := 0 to ListOfParameterLists.Count -1 do
  begin
    AParameterList := ListOfParameterLists.Items[ParameterListIndex];
    sgTimes.Objects[0, ParameterListIndex + 1] := AParameterList;
  end;

  // get rid of the list of parameter-lists.
  ListOfParameterLists.Free;
end;

procedure TfrmMain.InitializeGrids;
var
  Index : integer;
begin
  sgGeolUnits.Cells[0,0] := 'N';
  sgGeolUnits.Cells[1,0] := 'Geologic Unit';
  for Index := 1 to sgGeolUnits.RowCount -1 do
  begin
    sgGeolUnits.Cells[0,Index] := IntToStr(Index);
    if sgGeolUnits.Cells[1,Index] = '' then
    begin
      sgGeolUnits.Cells[1,Index] := 'Geologic Unit '
        + sgGeolUnits.Cells[0,Index]
    end;
  end;

  sgTimes.Cells[0,0] := 'N';
  sgTimes.Cells[1,0] := 'Time Period';
  for Index := 1 to sgTimes.RowCount -1 do
  begin
    sgTimes.Cells[0,Index] := IntToStr(Index);
    if sgTimes.Cells[1,Index] = '' then
    begin
      sgTimes.Cells[1,Index] := 'Time Period '
        + sgTimes.Cells[0,Index]
    end;
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited;
  InitializeGrids;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  inherited;
  LayerStructure.Free;
end;

procedure TfrmMain.ModelComponentName(AStringList : TStringList);
begin
  AStringList.Add(edModelPath.Name);
end;


procedure TfrmMain.cbOptionalParameterClick(Sender: TObject);
begin
  inherited;
  LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (TMyInformationLayer,TMyOptionalParameter,
     TMyOptionalParameter.IncludeOptionalParameters);

  LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (TMyInformationLayer,TMyOptionalTimeParameter,
     TMyOptionalTimeParameter.IncludeOptionalParameters);

  LayerStructure.UnIndexedLayers.AddOrRemoveUnIndexedParameter
    (TMyOptionalInformationLayer,TMyOptionalParameter,
     TMyOptionalInformationLayer.IncludeOptionalLayer and
     TMyOptionalParameter.IncludeOptionalParameters);

  LayerStructure.UnIndexedLayers.AddOrRemoveIndexedParameter2
    (TMyOptionalInformationLayer,TMyOptionalTimeParameter,
     TMyOptionalInformationLayer.IncludeOptionalLayer and
     TMyOptionalTimeParameter.IncludeOptionalParameters);

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (TMyInformationLayer,TMyOptionalParameter,
     TMyOptionalParameter.IncludeOptionalParameters);

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (TMyInformationLayer,TMyOptionalTimeParameter,
     TMyOptionalTimeParameter.IncludeOptionalParameters);

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveUnIndexedParameter
    (TMyOptionalInformationLayer,TMyOptionalParameter,
     TMyOptionalInformationLayer.IncludeOptionalLayer and
     TMyOptionalParameter.IncludeOptionalParameters);

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveIndexedParameter2
    (TMyOptionalInformationLayer,TMyOptionalTimeParameter,
     TMyOptionalInformationLayer.IncludeOptionalLayer and
     TMyOptionalTimeParameter.IncludeOptionalParameters);
end;

procedure TfrmMain.cbOptionalLayersClick(Sender: TObject);
begin
  inherited;
  LayerStructure.UnIndexedLayers.AddOrRemoveLayer(TMyOptionalInformationLayer,
    TMyOptionalInformationLayer.IncludeOptionalLayer);

  LayerStructure.ListsOfIndexedLayers.AddOrRemoveLayer(TMyOptionalInformationLayer,
    TMyOptionalInformationLayer.IncludeOptionalLayer);
end;


procedure TfrmMain.ChangeNumUnits(Sender: TObject);
var
  PrevNumUnits, NewNumUnits : integer;
  RowIndex, ColIndex : integer;
begin
  // triggering event: edNumUnits.OnExit;
  // called by btnInsertUnitClick
  // called by btnAddUnitClick
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  // called by GLoadForm in ProjectFunctions
  inherited;
  PrevNumUnits := NumberOfGeologicUnits;
  if (Sender = btnAddUnit) or (Sender = btnInsertUnit) then
  begin
    NewNumUnits := PrevNumUnits + 1;
  end
  else if (Sender = btnDeleteUnit) then
  begin
    NewNumUnits := PrevNumUnits - 1;
  end
  else
  begin
    Assert(False);
  end;
  // determine the new number of units.

  // If the new number of units is > 0 proceed, otherwise
  // handle the error.
  if NewNumUnits >0
  then
    begin
      // change the number of rows in sgGeolUnits to reflect the
      // new number of units

      // If the new number of units is greater than the previous number
      // of units, add more units, otherwise, delete some units.
      If NewNumUnits > PrevNumUnits
      then
        begin
          // increase the number of rows in dtabGeol to reflect the new
          // number of units.
          sgGeolUnits.RowCount := NewNumUnits + 1;

          // Copy data into the new cells in dtabGeol.
          For RowIndex := PrevNumUnits  to NewNumUnits -1 do
          begin

            sgGeolUnits.Cells[0,RowIndex + 1] := IntToStr(RowIndex + 1);
            For ColIndex := 1 to sgGeolUnits.ColCount -1 do
            begin
              sgGeolUnits.Cells[ColIndex,RowIndex + 1]
                := sgGeolUnits.Cells[ColIndex,RowIndex];
            end;


            // for each row of new cells, create a new geologic unit
            // at the end of the layer structure.
            if (Sender <> btnInsertUnit) and not Cancelling then
            begin
              CreateGeologicLayer(-1)
            end;

          end;

        end
      else // If NewNumUnits > PrevNumUnits
        begin
          // delete geologic units
          For RowIndex := PrevNumUnits  downto NewNumUnits +1  do
          begin
              if (Sender <> btnDeleteUnit) and not Cancelling then
              begin
                DeleteGeologicLayer(RowIndex-1);
              end;
          end;
          // delete rows in dtabGeol.
//              dtabGeol.RowSet.Count := NewNumUnits ;
          sgGeolUnits.RowCount := NewNumUnits + 1;
        end;

    end
  else // if NewNumUnits >0
    begin
      // prevent the number of units from being less than 1.
      Beep;
      NewNumUnits := PrevNumUnits
    end;
  // enable delete button if the new number of units > 1
  btnDeleteUnit.Enabled := (NewNumUnits > 1);
  if (Sender <> btnDeleteUnit) and (Sender <> btnInsertUnit) then
  begin
    // make lists of the current geologic units.
    // This re-creates the GeologicUnitsList used in step 3.
    AssociateUnits;
  end;
end;

procedure TfrmMain.CreateGeologicLayer(Position : integer);
{var
  MeshLayer : T_ANE_TriMeshLayer;}
begin
  // called by edNumUnitsExit;
  // called by btnInsertUnitClick;

  // create the information layers for a new geologic unit at the
  // appropriate position.

  TGeologicUnit.Create(LayerStructure.ListsOfIndexedLayers, Position);


  // get the grid layer.
{  MeshLayer := LayerStructure.UnIndexedLayers.GetLayerByName
    (TMyMesh.ANE_LayerName) as T_ANE_TriMeshLayer;

  // create grid parameters for a new geologic unit in the grid layer at the
  // appropriate position.
  TGeologicUnitParameters.Create
    (TMyMesh.IndexedParamList1,
     Position);  }
end;

procedure TfrmMain.DeleteGeologicLayer(Position : integer);
var
  UnitParamIndex : integer;
  AGeologicUnitParameters : T_ANE_IndexedParameterList;
  AGeologicUnit : T_ANE_IndexedLayerList;
  AUnitParamList : TList;
//  ALayerList : T_ANE_LayerList;
//  ALeakanceLayer : T_ANE_MapsLayer;
begin
  // called by edNumUnitsExit;
  // called by btnDeleteUnitClick

  // get the geologic unit.
  AGeologicUnit := GeologicUnitsList.Items[Position];

  // set the status of the geologic unit and all it's layers to sDeleted.
  AGeologicUnit.DeleteSelf;

  // get the list of parameterslists related to geologic units
  AUnitParamList := GeologicUnitParametersList.Items[Position];

  // loop over the lists of parameter lists and set the status of
  // the parameterlists and the parameters they contain to sDeleted.
  for UnitParamIndex := AUnitParamList.Count -1 downto 0 do
  begin
    AGeologicUnitParameters := AUnitParamList.Items[UnitParamIndex];
    if AGeologicUnitParameters <> nil then
    begin
      AGeologicUnitParameters.DeleteSelf;
    end;
  end;
end;

procedure TfrmMain.btnInsertUnitClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
  PositionToInsert : integer;

  AGeologicUnit : T_ANE_IndexedLayerList;
begin
  // triggering event: btnInsertUnit.OnClick;
  inherited;

  //1. first add another line to the grid displaying the geologic units.
  ChangeNumUnits(Sender);

  CurrentRow := sgGeolUnits.Row;

  // copy data from each row from the end of the grid down
  // to the currently selected row to one row further down in the grid.
  for RowIndex := sgGeolUnits.RowCount -2 downto CurrentRow do
  begin
    // number the first column
    sgGeolUnits.Cells[0,RowIndex] := IntToStr(RowIndex);
    // copy data to latter row.
    for ColIndex := 1 to sgGeolUnits.ColCount -1 do
    begin
      sgGeolUnits.Cells[ColIndex,RowIndex +1] := sgGeolUnits.Cells[ColIndex,RowIndex];
    end;
  end;



  //3. Determine where in the layer structure the new unit should be inserted.
  if CurrentRow = 0
  then
    begin
      PositionToInsert := 0;
    end
  else
    begin
      AGeologicUnit := GeologicUnitsList.Items[CurrentRow-1];
      PositionToInsert := LayerStructure.ListsOfIndexedLayers.
        IndexOf(AGeologicUnit);
    end;

  //4. Create a new geologic unit at the correct position.
  CreateGeologicLayer(PositionToInsert);

  //6. make lists of the current geologic units.
  // This re-creates the GeologicUnitsList used in step 3.
  AssociateUnits;
end;

procedure TfrmMain.ChangeNumberOfTimes(Sender: TObject);
var
  RowIndex : integer;
  NewNumPeriods, PrevNumPeriods : integer;
  ColIndex : integer;
begin
  // triggering event: edNumPer.OnExit;
  // called by btnInsertTimeClick
  // called by btnAddTimeClick
  // called by IsOldFile in ReadOldUnit
  // called by IsOldMT3DFile in ReadOldMT3D
  // called by GLoadForm in ProjectFunctions
  inherited;
  PrevNumPeriods := NumberOfTimes;
  // get the new number of periods
  if (Sender = btnAddTime) or (Sender = btnInsertTime) then
  begin
    NewNumPeriods := PrevNumPeriods + 1;
  end
  else if (Sender = btnDeleteTime) then
  begin
    NewNumPeriods := PrevNumPeriods - 1;
  end
  else
  begin
    Assert(False);
  end;

  // Check that the new number of periods is valid.
  if NewNumPeriods >0
  then
    begin

      // check if number of periods is greater than before.
      If NewNumPeriods > PrevNumPeriods
      then
        begin
          // set the number of rows in the time grid to the proper number.
          sgTimes.RowCount := NewNumPeriods + 1;

          // copy data into the new rows.
          For RowIndex := PrevNumPeriods + 1 to sgTimes.RowCount -1 do
          begin
            // label the first column of the new row
            sgTimes.Cells[0,RowIndex] := IntToStr(RowIndex);

            // copy data from earlier row.
            For ColIndex := 1 to sgTimes.ColCount -1 do
            begin
              sgTimes.Cells[ColIndex,RowIndex]
                := sgTimes.Cells[ColIndex,RowIndex-1];
            end;

            // unless you are inserting a new time step
            // add new time parameters.
            if not (Sender = btnInsertTime) then
            begin
              InsertTimeParameters (-1);
            end;

          end;
        end
      else
        begin
          // The number of periods has declined.

          if not (Sender = btnDeleteTime) then
          begin
            // unless you are deleting a specific time step
            // delete the time parameters for the rows that are
            // being deleted
            For RowIndex := sgTimes.RowCount -1 downto NewNumPeriods + 1 do
            begin
              DeleteTimeParameters (RowIndex);
            end;
          end;

          // set the number of rows to the correct number.
          sgTimes.RowCount := NewNumPeriods + 1;
        end;
    end
  else
    begin
      // if the new number of periods is invalid, go back to
      // the previous number.
      Beep;
    end;

  // if there are 2 or more time periods, you can delete time periods.
  btnDeleteTime.Enabled := (sgTimes.RowCount > 2);

  // if you have added or deleted time parameters make new lists of
  // time parameters.
  if not (Sender = btnInsertTime) and not (Sender = btnDeleteTime) then
  begin
    AssociateTimes;
  end;

end;

procedure TfrmMain.DeleteTimeParameters (Position : Integer);
var
  ListOfParameterLists : TList;
  AParameterList : T_ANE_IndexedParameterList ;
  ParameterListIndex : integer;
begin
  // called by edNumPerExit
  // called by btnDeleteTimeClick

  // a list of time-related parameter lists is stored in the objects
  // property of the first column of the dgTime grid.
  // Calling this function, causes all those parameter lists and the
  // parameters they hold them to have their status set
  // to sDeleted.
  // This procedure may be overriden in descendents.

  // Get the list of parameter lists for the appropriate time step.
  ListOfParameterLists := sgTimes.Objects[0, Position] as TList;

  // loop over all the parameter lists and delete them.
  for ParameterListIndex := ListOfParameterLists.Count -1 downto 0 do
  begin
    AParameterList := ListOfParameterLists.Items[ParameterListIndex];
    if AParameterList <> nil then
    begin
      AParameterList.DeleteSelf;
    end;
  end;

  // Free the list of parameter lists.
  ListOfParameterLists.Free;

  // reset the objects property of the appropriate cell to nil.
  sgTimes.Objects[0, Position] := nil;
end;

Procedure TfrmMain.InsertTimeParameters (Position : integer) ;
begin
  // create the time parameters at Position
  LayerStructure.UnIndexedLayers.MakeIndexedList2
    (TMyInformationLayer, TTimeParameterList, Position);

  if TMyOptionalInformationLayer.IncludeOptionalLayer then
  begin
    LayerStructure.UnIndexedLayers.MakeIndexedList2
      (TMyOptionalInformationLayer, TTimeParameterList, Position);
  end;

  LayerStructure.ListsOfIndexedLayers.MakeIndexedList2
    (TMyInformationLayer, TTimeParameterList, Position);

  if TMyOptionalInformationLayer.IncludeOptionalLayer then
  begin
    LayerStructure.ListsOfIndexedLayers.MakeIndexedList2
      (TMyOptionalInformationLayer, TTimeParameterList, Position);
  end;

end;

procedure TfrmMain.btnDeleteTimeClick(Sender: TObject);
Var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
//  NewNumPeriods : Integer;
begin
  // triggering event: btnDeleteTime.OnClick;
  inherited;

  // get the currently selected fow.
  CurrentRow := sgTimes.Row;

  // copy data from later time steps over the data for the time
  // step to be deleted.
  for RowIndex := CurrentRow +1 to sgTimes.RowCount -1 do
  begin
    For ColIndex := 1 to sgTimes.ColCount -1 do
    begin
      sgTimes.Cells[ColIndex,RowIndex-1] := sgTimes.Cells[ColIndex,RowIndex];
    end;
  end;

  // store the new number of periods
  // decrease the number of rows in the time grid by one.
  sgTimes.RowCount := sgTimes.RowCount - 1;

  // enable the delete button if there are at least two time periods.
  btnDeleteTime.Enabled := (sgTimes.RowCount > 2);

  // delete the time-related parameters for the current time step
  // from the layer structure
  DeleteTimeParameters (CurrentRow);

  // associate all the time-related parameters with the object properties
  // of the first cell in each row of the time grid.
  AssociateTimes;
//  comboRchSteadyChange(Sender);
end;

procedure TfrmMain.btnInsertTimeClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
  PostionToInsert : integer;
  ListOfParameterLists  : TList;
  AnIndexedParameterList : T_ANE_IndexedParameterList;
begin
  // triggering event: btnInsertTime.OnClick;
  inherited;

  // first increase the number of periods by 1.
  ChangeNumberOfTimes(Sender);

  // get the current row.
  CurrentRow := sgTimes.Row;

  // copy data from each row from the end of the grid down
  // to the currently selected row to one row further down in the grid.
  for RowIndex := sgTimes.RowCount -2 downto CurrentRow do
  begin
    // number the first column
    sgTimes.Cells[0,RowIndex] := IntToStr(RowIndex);
    // copy data to latter row.
    for ColIndex := 1 to sgTimes.ColCount -1 do
    begin
      sgTimes.Cells[ColIndex,RowIndex +1] := sgTimes.Cells[ColIndex,RowIndex];
    end;
  end;

  // enable delete button if there are at least two time periods.
  btnDeleteTime.Enabled := (sgTimes.RowCount > 2);

  // get the list of time-related parameters for the currently selected
  // row.
  ListOfParameterLists := sgTimes.Objects[0, CurrentRow] as TList;

  // determine where new time-related parameters should be inserted into
  // the layer structure.
  if ListOfParameterLists.Count > 0 then
  begin
    // for the first row, insert time related parameters at the beginning
    if CurrentRow = 1
    then
      begin
        PostionToInsert := 0
      end
    else
      begin
        // for other rows, get an indexed parameter list associated with
        // the current time step and
        // insert the new parameters before that one.
        AnIndexedParameterList := ListOfParameterLists.Items[0] ;
        PostionToInsert := AnIndexedParameterList.GetIndex ;
      end;
    // create new time-related parameters at the position indicated by
    // PostionToInsert
    InsertTimeParameters (PostionToInsert);
  end;

  // associate all the time-related parameters with the object properties
  // of the first cell in each row of the time grid.
  AssociateTimes;

end;

end.
