unit ArgusFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, ArgusDataEntry, ExtCtrls, Grids, AnePIE, OleCtrls
  {$IFDEF DataTableInstalled}
  , PVDataTable_TLB
  {$ENDIF}
  {$IFDEF StringGrid3d}
  , StringGrid3d
  {$ENDIF}
  ;

  {TArgusForm is an ancestor of forms used in a variety of PIEs. It's most
  notable feature is that it provides methods of loading and saving data to
  and from a string and for processing export templates.}

type

  TGetVersionString = function(VersionControl : TControl) : string of object;
  // A TGetVersionString is a function that returns the version of the
  // program or dll.

  TEarlierVersionInPIE = function(VersionInString, VersionInPIE : string; ShowError : boolean):
    boolean of object;
  // A TEarlierVersionInPIE is a function that is used to test whether the
  // version number that is saved when a file is saved is more recent than
  // the version of the program or dll that is attempting to read the data.

  TSpecialHandling = procedure(var LineIndex : integer; FirstList,
    IgnoreList: TStringlist;
    DataToRead : TStringList; const VersionControl : TControl) of object;
  // A TSpecialHandling procedure is a procedure for reading data from
  // a stringlist when the usual method for reading the data won't work
  // properly for some reason. The main reason for using this is when a
  // component has been removed or replaced and it's data is stored in
  // some other control.


  TSpecialHandlingObject = class(TObject)
    private
      FName : string;
      FReadData : TSpecialHandling;
    public
      constructor Create(Name : string; ReadData : TSpecialHandling);
      property ReadData : TSpecialHandling Read FReadData;
      Property Name : string read FName;
    end;
  // A TSpecialHandlingObject is used to associate a control name
  // with a TSpecialHandling

  EInvalidProcedure = class(Exception);

  TSpecialHandlingList = class(TObject)
  private
    FList : TList;
    function GetItems(Index : integer): TSpecialHandlingObject;
    function GetCount : integer;
  public
    constructor Create;
    destructor Destroy; override;
    function IndexOf(AName : string) : integer;
    function GetByName(AName : string) : TSpecialHandlingObject;
    property Items[Index : integer] : TSpecialHandlingObject read GetItems;
    procedure Add(ASpecialHandlingObject : TSpecialHandlingObject);
    Property Count : integer read GetCount;
  end;
  // A TSpecialHandlingList owns a series of TSpecialHandlingObject's.

  TArgusForm = class(TForm)
    procedure FormCreate(Sender: TObject); virtual;
    procedure FormDestroy(Sender: TObject); virtual;
  published
    procedure ReadEdit(var LineIndex: integer; FirstList, IgnoreList: TStringlist;
      AComponent: TComponent; DataToRead: TStringList;
    // read data for an edit box and call its OnEnter, OnChange and OnExit events.
      const VersionControl : TControl); virtual;
    procedure ReadArgusDataEntry(var LineIndex: integer; FirstList, IgnoreList: TStringlist;
      AComponent: TComponent; DataToRead: TStringList;
      const VersionControl : TControl); virtual;
    // read data for an ArgusDataEntry and call its OnEnter, OnChange and OnExit events.
    procedure ReadRadioGroup(var LineIndex: integer; FirstList, IgnoreList: TStringlist;
      AComponent: TComponent; DataToRead: TStringList;
      const VersionControl : TControl); virtual;
    // read data for an radiogroup and call its OnEnter, OnClick and OnExit events.
    procedure ReadComboBox(var LineIndex: integer; FirstList, IgnoreList: TStringlist;
      AComponent: TComponent; DataToRead: TStringList;
      const VersionControl : TControl); virtual;
    // read data for an combobox and call its OnEnter, OnChange and OnExit events.
    procedure ReadCheckBox(var LineIndex: integer; FirstList, IgnoreList: TStringlist;
      AComponent: TComponent; DataToRead: TStringList;
      const VersionControl : TControl); virtual;
    // read data for an checkbox and call its OnEnter, OnClick and OnExit events.
    procedure ReadRadioButton(var LineIndex: integer; FirstList, IgnoreList: TStringlist;
      AComponent: TComponent; DataToRead: TStringList;
      const VersionControl : TControl); virtual;
    // read data for an radiobutton and call its OnEnter, OnClick and OnExit events.
    procedure ReadStringGrid(var LineIndex: integer; FirstList, IgnoreList: TStringlist;
      AComponent: TComponent; DataToRead: TStringList;
      const VersionControl : TControl); virtual;
    // read data for an stringgrid and call its OnEnter, OnSelectCell,
    // OnSetEditText and OnExit events.
    procedure ReadMemo(var LineIndex: integer; FirstList, IgnoreList: TStringlist;
      AComponent: TComponent; DataToRead: TStringList;
      const VersionControl : TControl); virtual;
    // read data for an combobox and call its OnEnter, OnChange and OnExit events.
    function SetColumns(AStringGrid: TStringGrid): boolean; virtual;
    // a function used to determine whether the number of columns in a
    // stringgrid should be set to the value read from the data
    function SetRows(AStringGrid: TStringGrid): boolean; virtual;
    // a function used to determine whether the number of rows in a stringgrid
    // should be set to the value read from the data.
{$IFDEF StringGrid3d}
    procedure ReadStringGrid3D(var LineIndex: integer; FirstList,
      IgnoreList: TStringlist; AComponent: TComponent;
      DataToRead: TStringList; const VersionControl: TControl); virtual;
{$ENDIF}
    procedure ReadFrame(var LineIndex: integer; FirstList,
      IgnoreList, UnreadData: TStringlist; AComponent: TComponent;
      DataToRead: TStringList; const VersionControl: TControl);
    procedure ReadComponents(var LineIndex: integer; FirstList,
      IgnoreList: TStringlist; {AComponent: TComponent;}
      DataToRead: TStringList; const VersionControl: TControl; AName : string;
      UnreadData : TStringlist; SourceComponent : TComponent); virtual;
    procedure WriteArgusDataEntry(ComponentData: TStringList;
      AComponent: TComponent);
    procedure WriteEdit(ComponentData: TStringList;
      AComponent: TComponent);
    procedure WriteRadioGroup(ComponentData: TStringList;
      AComponent: TComponent);
    procedure WriteComboBox(ComponentData: TStringList;
      AComponent: TComponent);
    procedure WriteCheckBox(ComponentData: TStringList;
      AComponent: TComponent);
    procedure WriteRadioButton(ComponentData: TStringList;
      AComponent: TComponent);
    Procedure WriteStringGrid(ComponentData: TStringList;
      AComponent: TComponent);
    Procedure WriteMemo(ComponentData: TStringList;
      AComponent: TComponent);
    procedure writeStringGrid3D(ComponentData: TStringList;
      AComponent: TComponent);
    function WriteComponent(ComponentData: TStringList;
      AComponent: TComponent; const IgnoreList :TStringlist) : integer;
    procedure WriteFrame(ComponentData: TStringList;
      AComponent: TComponent; const IgnoreList :TStringlist);
    function WriteComponents(ComponentData: TStringList;
      const IgnoreList :TStringlist; OwningComponent: TComponent): integer; virtual;
    procedure WriteSpecial(ComponentData: TStringList;
      const IgnoreList :TStringlist; OwningComponent: TComponent); virtual;
  private
    function GetNextComponent(var LineIndex: integer; DataToRead,
      UnreadData: TStringList; const VersionControl: TControl;
      SourceComponent: TComponent; FirstList,
      IgnoreList: TStringlist) : TComponent;
    procedure ReadAComponent(var LineIndex: integer; FirstList,
      IgnoreList, UnreadData: TStringlist; AComponent: TComponent;
      DataToRead: TStringList; const VersionControl: TControl);
    { Private declarations }
  public
    Cancelling : boolean;
    Loading : boolean;
    NewModel : boolean;
    PIEDeveloper : string;
    IgnoreList :TStringList;
    FirstList :TStringList;
    // The Scaled Property of the form is set to False and the font is set
    // to a true-type font to eliminate problems with large and small fonts.
    CurrentModelHandle : ANE_PTR;
    // "CurrentModelHandle" is the handle of the current model.
    // It should be updated in any functions referenced in GetANEFunctions
    // that supply the handle. Among the functions that supply it are the
    // following function types:
    // PIEProjectNew, PIEProjectEdit, PIEProjectClean, PIEProjectSave,
    // PIEProjectLoad, PIEExportGetTemplate, PIEExportCallBack
    // "CurrentModelHandle" must be up-to-date to add or remove layers or
    // parameters.
    EarlierVersionInPIE : TEarlierVersionInPIE;
    // EarlierVersionInPIE is a function that compares two strings that
    // represent the version of the PIE that created a file and the
    // version that is reading a file. It returns true if the PIE is attempting
    // to read a file created by a later version of the PIE.
    GetVersion : TGetVersionString ;
    // GetVersion is a function that returns the version of the PIE.
    SpecialHandlingList : TSpecialHandlingList;
    // SpecialHandlingList is a list of TSpecialHandlingObject which are used
    // for backwards compatibility when the name or type of a control has
    // changed. Each TSpecialHandlingObject has a name which is the name of the
    // old control and a TSpecialHandling procedure which is a procedure that
    // can be used to read data that was created by the old control.
    OldVersionControlName : TStringList;
    // OldVersionControlName is a TStringList that holds the names of controls
    // that held version information in previous versions of a PIE.
//    constructor Create(AOwner: TComponent); override;
    procedure LoadForm(UnreadData: TStringlist; DataToRead: string;
      var VersionInString: string; const VersionControl : TControl); virtual;
    procedure ModelComponentName(AStringList: TStringList); virtual; abstract;
    procedure ModelPaths(var AStringList: TStringList;
      const Version : TControl; const Developer : string); virtual;
    class function GetFormFromArgus(aneHandle : ANE_PTR) : TArgusForm; virtual;
    // GetFormFromArgus gets the private model information from Argus
    // and casts it to a TArgusForm. It assigns aneHandle to the
    // CurrentModelHandle of the TArgusForm.
    procedure StringToForm(const DataFromArgus : String; UnreadData : TStringlist;
       const VersionControl : TControl; var VersionInString : string;
       const ShowError : boolean; FirstList, IgnoreList: TStringlist;
       var Developer : string); virtual;
    // StringToForm takes a string from Argus and reads data from it to assign
    // values to a TArgusForm. AString is the string from Argus.
    // If any data in AString can't be read, it will be added to UnreadData.
    // VersionControl is a control that can access the version information
    // of the PIE. If GetVersion is assigned, this information can be used
    // to warn the user when attempting to read data created by a latter
    // version of the PIE. The warning will only occur if ShowError is True;
    // If FirstList is not equal to nil, only data for the controls whose names
    // are in FirstList will be read. The types of controls whose data can
    // be read from the string are the same as those listed in FormToString.
    function FormToString(const Version : TControl;
      const IgnoreList :TStringlist; const Developer : string) : String;
      virtual;
    // FormToString is a function that writes a string with all the
    // information in the TArgusForm. If GetVersion has been assigned and
    // Version is not equal to nil, the version information will be at the
    // beginning of the string. The data for any controls whose names are in
    // IgnoreList will not be saved in the string.
    // Data for the following types of controls (or their descendents)
    // are saved by FormToString: TEdit, TArgusDataEntry, TRadioGroup,
    // TCheckBox, TComboBox, TRadioButton, TStringGrid, TMemo.
    // If the user defines DataTableInstalled, the data for TDataTbl will
    // also be saved. TDataTbl is a proprietary ActiveX control from
    // ProtoView Development Corporation.
    function ProcessTemplate (const DLLName, MetFileName : string;
      const ProgressCaption : string ;
      const VersionControl : TControl;
      var TemplateStringList : TStringList) : ANE_Str; virtual;
    // ProcessTemplate loads an export template named MetFileName from the
    // directory containing the PIE. To find the directory, the name of the dll
    // must be provided. DLLName holds the name of the dll. The procedure
    // will first call ReplaceTemplateFiles and then
    // will look for the names of the controls surrounded by "@" and
    // replace those strings in the export template with the data of the
    // control. For example if a TEdit named AnEdit had a Text equal to '5.4',
    // The string "@AnEdit@" in the export template would be replaced by 5.4.
    // As this is done a progress bar will be displayed. The caption of the
    // form containing the progress bar will be ProgressCaption.
    // Data for VersionControl will be skipped. This function calls
    // ReplaceValues
    function ReplaceValues(const ProgressCaption : string ;
      const VersionControl : TControl; const Template : TStringList) : string;
      virtual;
    // The ReplaceValues
    // will look for the names of the controls surrounded by "@" in Template
    // and replace those strings with the data of the
    // control. For example if a TEdit named AnEdit had a Text equal to '5.4',
    // The string "@AnEdit@" in the export template would be replaced by 5.4.
    // As this is done a progress bar will be displayed. The caption of the
    // form containing the progress bar will be ProgressCaption.
    // Data for VersionControl will be skipped.
    // This procedure only looks for controls of the following types
    // TEdit, TArgusDataEntry, TRadioGroup, TCheckBox, TRadioButton and
    // TComboBox
    // replacements are made as follows
    // @TEdit.Name@ -> TEdit.Text
    // @TArgusDataEntry.Name@ -> TArgusDataEntry.Text
    // @TRadioGroup.Name@ -> TRadioGroup.ItemIndex
    // @TCheckBox.Name@ -> TCheckBox.Checked
    // @TRadioButton.Name@ -> TRadioButton.Checked
    // @TComboBox.Name@ -> TArgusDataEntry.ItemIndex

    function ReplaceTemplateFiles(const DLLName : string;
      var Template : TStringList) : boolean;
    // ReplaceTemplateFiles is a function that reads a template
    // and inserts other text files into the template if instructed
    // to do so by special commands within the template.
    //
    //  The commands to replace files begin with the following command
    //  on a comment line.
    //  'pie command: begin_to_replace_files'
    //
    //  The commands to replace files end with the following command
    //  on a comment line.
    //  'pie command: stop_replacing_files';
    //
    //  Between those two commands, the following command will cause a
    //  a file to be inserted. The command must be followed by the name
    //  of the file. The file must be in the same directory as the file
    //  specified in DLLName
    //  'pie command: replace_file';
    //
    //  ReplaceTemplateFiles recursively calls itself so you should be sure
    //  that you don't have commands in any of the files that are inserted
    //  that will cause an infinite loop.


    { Public declarations }
    protected
      Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
        message WM_WINDOWPOSCHANGED;

  end;



var
//  ArgusForm: TArgusForm;
  TemplateString : string;
  DLLName : string;

implementation

uses ANE_LayerUnit, UtilityFunctions, ExportProgressUnit, ANECB;

{$R *.DFM}

class function TArgusForm.GetFormFromArgus(aneHandle : ANE_PTR ) : TArgusForm;
begin
  ANE_GetPIEProjectHandle(aneHandle, @result );
  result.CurrentModelHandle := aneHandle;
end;


procedure TArgusForm.StringToForm(const DataFromArgus : String; UnreadData : TStringlist;
       const VersionControl : TControl; var VersionInString : string;
       const ShowError : boolean; FirstList, IgnoreList: TStringlist; var Developer : String);
var
  {$IFDEF DataTableInstalled}
  ADatatbl : TDatatbl;
  {$ENDIF}
  AName : string; // the name of a component
  AText : string; // data to be assigned to a component
//  AComponent : TComponent; // a component on the TArgusForm to which data is
    // be assigned.
  DataToRead : TStringList; // a stringlist containing the names of
    // components and the data to be assigned to them.
  LineIndex : integer; // the current position in DataToRead
  AControl : TControl; //
//  ASpecialHandlingObject : TSpecialHandlingObject; // ASpecialHandlingObject is
    // used to read data from controls when the default method for reading the
    // data won't work for some reason.

begin
  // initialize VersionInString
  VersionInString := '';
  // create a stringlist that will hold the data to be read.
  DataToRead := TStringList.Create;
  Try // try 1 : try finally
    begin
      try // try 2 : try except
        begin
          // initialize LineIndex and UnreadData
          LineIndex := 0;
          UnreadData.Clear;
          // set the text of the stringlist to DataFromArgus
          // DataFromArgus contains carraige returns and line feed characters
          // that are used to break up the DataFromArgus string into a series
          // of individual strings.
          DataToRead.Text := DataFromArgus;
          // Check that you aren't trying to read data from an old incompatible
          // version of the PIE.
          if DataToRead.Count = 1 then
          begin
            Beep;
            MessageDlg('Unable to read data in this file. Make sure that you are '
            + 'using a compatible version of the PIE.',
            mtError, [mbOk], 0);
          end
          else
          begin
            // read the version information from the data and compare it to
            // the version of the PIE. Display a warning if appropriate.
            if not (VersionControl = nil) then
            begin
              AName := DataToRead[LineIndex];
              Inc(LineIndex);
              VersionInString := DataToRead[LineIndex];
              Inc(LineIndex);
              AControl := FindComponent(AName) as TControl;
              if (AControl = VersionControl) or (OldVersionControlName.IndexOf(AName)>-1) then
              begin
                if Assigned(GetVersion) and Assigned(EarlierVersionInPIE) then
                begin
                  AText := GetVersion(VersionControl);
                  If EarlierVersionInPIE(VersionInString, AText, ShowError) and ShowError then
                  begin
                    Beep;
                    ShowMessage('Attempting to read data from '
                       + 'a later version of the PIE.');
                  end;
                end;
              end
              else
              begin
                // The earlier version of the PIE didn't have Version assigned
                // or else used a different control so skip version comparison
                // but be sure to read the data for this control.
                LineIndex := LineIndex - 2;
              end;

            end;
            // read the name of a control
            AName := DataToRead[LineIndex];

            // skip the name of the developer
            if not ( (SpecialHandlingList <> nil)
                and (SpecialHandlingList.IndexOf(AName) > -1)) and
                (FindComponent(AName) = nil) then
            begin
              Inc(LineIndex);
            end;

            ReadComponents(LineIndex, FirstList, IgnoreList, {AComponent,}
              DataToRead, VersionControl, AName, UnreadData, self);

            // read data from DataToRead until you get to the end.
{            While LineIndex < DataToRead.Count do
            begin
              // read the name of a control
              AName := DataToRead[LineIndex];
              // go to the next line.
              Inc(LineIndex);
              // if this should be handled by a TSpecialHandlingObject
              // do so.
              if (SpecialHandlingList <> nil)
                and (SpecialHandlingList.IndexOf(AName) > -1) then
              begin
                ASpecialHandlingObject := SpecialHandlingList.GetByName(AName);
                ASpecialHandlingObject.ReadData(LineIndex, FirstList, nil,
                  DataToRead, VersionControl);
              end
              else
              begin
                // Get the current component
                AComponent := FindComponent(AName);

                // If you can't find the compenent, add it's name to UnreadData
                // The data will be added to UnreadData too except in the
                // unlikely event that the data contained in a component is
                // the name of another component.
                if (AComponent = nil) and (AName <> '')
                then
                  begin
                    UnreadData.Add(AName);
                  end
                // read data for edit boxes.
                else
                if AComponent is TEdit
                then
                  begin
                    ReadEdit(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end
                // read data for TArgusDataEntry's
                else if AComponent is TArgusDataEntry then
                  begin
                    ReadArgusDataEntry(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end
                // read data for TRadioGroup's
                else if (AComponent is TRadioGroup) then
                  begin
                    ReadRadioGroup(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end
                // read data for checkboxes.
                else if (AComponent is TCheckBox) then
                  begin
                    ReadCheckBox(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end
                // read data for comboboxes (unless they are TArgusDataEntry's)
                else if (AComponent is TComboBox) then
                  begin
                    ReadComboBox(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end
                // read data for radio buttons.
                else if (AComponent is TRadioButton) then
                  begin
                    ReadRadioButton(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end
                // read data for StringGrids
                else if (AComponent is TStringGrid) then
                  begin
                    ReadStringGrid(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end}
  {$IFDEF StringGrid3d}
{                else if (AComponent is TRBWCustom3DGrid) then
                  begin
                    ReadStringGrid3D(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end}
  {$ENDIF}
{$IFDEF DataTableInstalled}
                // obsolete
                // read data for TDatatbl
{                else if (AComponent is TDatatbl) then
                  begin
                      ADatatbl := AComponent as TDatatbl;

                      AText := DataToRead[LineIndex];
                      Inc(LineIndex);
                      RowLimit := StrToInt(AText);
                      if not (ADatatbl = VersionControl) and
                        ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                      then
                      begin
                        ADatatbl.RowSet.Count := RowLimit;
                      end;
                      AText := DataToRead[LineIndex];
                      Inc(LineIndex);
                      ColLimit := StrToInt(AText);
                      if not (ADatatbl = VersionControl) and
                        ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                      then
                      begin
                        ADatatbl.ColumnSet.Count := ColLimit;
                      end;
                      For ColIndex := 0 to ColLimit -1 do
                      begin
                        if ADatatbl.ColumnSet[ColIndex].DataType = DttLongInt then
                          begin
                            For RowIndex := 0 to RowLimit -1 do
                            begin
                              AText := DataToRead[LineIndex];
                              Inc(LineIndex);
                              if not (ADatatbl = VersionControl) and
                                ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                              then
                              begin
                                ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := StrToInt(AText);

                              end;
                            end;
                          end
                        else if ADatatbl.ColumnSet[ColIndex].DataType = DttDoubleFloat then
                          begin
                            For RowIndex := 0 to RowLimit -1 do
                            begin
                              AText := DataToRead[LineIndex];
                              Inc(LineIndex);
                              if not (ADatatbl = VersionControl) and
                                ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                              then
                              begin
                                ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := StrToFloat(AText);
                              end;
                            end;
                          end
                        else if ADatatbl.ColumnSet[ColIndex].DataType = DttString then
                          begin
                            For RowIndex := 0 to RowLimit -1 do
                            begin
                              AText := DataToRead[LineIndex];
                              Inc(LineIndex);
                              if not (ADatatbl = VersionControl) and
                                ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                              then
                              begin
                                ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := AText;
                              end;
                            end;
                          end
                      end;
                    end}
{$ENDIF}
                // read data for memo's
{                else if (AComponent is TMemo) then
                  begin
                    ReadMemo(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
                      VersionControl);
                  end //if AComponent is TEdit then ... else if (AComponent is TMemo) then
              end; // if (SpecialHandlingList <> nil) ...
            end;  // While LineIndex < DataToRead.Count do}
          end;
        end
      except // try 2
        // e
        begin
          If AName = '' then
          begin
            AName := 'an unidentified component';
          end;
          Beep;
          MessageDlg('Error reading data for the following component: '
            + AName + '. Contact the developer of the PIE used to create '
            + 'this file for assistance.', mtError, [mbOK], 0);
          raise;
        end;
      end;
    end
  finally // try 1
    begin
      DataToRead.Free;
    end;
  end;

end;

function TArgusForm.FormToString(const Version : TControl;
  const IgnoreList :TStringlist; const Developer : string) : String;
var
//  ComponentIndex : integer; // index for loop over components
  ComponentData : TStringList; // data stored in component
    // and columns in grids and lines in memos
//  AComponent : TComponent; // the current component.
begin
  ComponentData := TStringList.Create;
  try
    begin
      // write the version information
      if not (Version = nil) then
      begin
        if Assigned(GetVersion) then
        begin
          ComponentData.Add(Version.Name);
          ComponentData.Add(GetVersion(Version));
        end;
      end;
      // add the name of the developer
      ComponentData.Add(Developer);
      // add data for components.
      WriteComponents(ComponentData,IgnoreList,self);
{      For ComponentIndex := 0 to ComponentCount -1  do
      begin
        // get a component
        AComponent := Components[ComponentIndex];
        // skip the component if it doesn't have a name or if
        // it's name is in the IgnoreList.
        if not(AComponent.Name = '') and ((IgnoreList = nil)
           or (IgnoreList.IndexOf(AComponent.Name) = -1))
           then
        begin
          WriteComponent(ComponentData, AComponent);
          // add data for edit boxes.
        end;
      end;   }
      WriteSpecial(ComponentData,IgnoreList,self);
    end
  finally
    begin
      // convert data to a string for passing to Argus ONE
      result := ComponentData.Text;
      // get rid of ComponentData
      ComponentData.Free;
    end;
  end;
end;

function TArgusForm.ReplaceTemplateFiles(const DLLName : string;
  var Template : TStringList) : boolean;
const
  StartReplaceString = 'pie command: begin_to_replace_files';
  StopReplaceString = 'pie command: stop_replacing_files';
  ReplaceFileString = 'pie command: replace_file';
var
  Index, InnerIndex : integer;
  NewTemplate : TStringList;
  AString : string;
  CommentPosition : integer;
  TemplateFile : TStringList;
  DllDirectory : String;
begin
  result := true;
  // Template will be replaced by NewTemplate.
  // create NewTemplate
  NewTemplate := TStringList.Create;
  // initialize Index, and DllDirectory
  Index := -1;
  GetDllDirectory(DLLName, DllDirectory);
  // process all the lines in Template
  While (Index < Template.Count-1) and result do
  begin
    // update Index
    Inc(Index);
    // read a line from Template.
    AString := LowerCase(Trim(Template[Index]));
    // if the line is a comment check if you should check for other
    // commands. Otherwise just add the line to the new template
    CommentPosition := Pos('#', AString);
    If (CommentPosition > 0) and
      (Pos(StartReplaceString, AString) > CommentPosition) then
    begin
      // Initialize InnerIndex
      InnerIndex := Index;
      // read all lines in Template until get to the ending command
      While (InnerIndex < Template.Count-1) and result do
      begin
        // update InnerIndex
        Inc(InnerIndex);
        AString := LowerCase(Trim(Template[InnerIndex]));
        // check if you've reached the end of the lines containing
        // commands to replace file. If so, leave the inner While loop.
        CommentPosition := Pos('#', AString);
        If (CommentPosition > 0) and
          (Pos(StopReplaceString, AString) > CommentPosition) then
        begin
          break;
        end
        else
        begin
          // check if this line is a command to insert a file
          if (AString[1] = '#') and
            (Pos(ReplaceFileString, AString) > 1) then
          begin
            // if it is, get the name of the file.
            AString := Trim(Copy(AString,
              Pos(ReplaceFileString, AString) + Length(ReplaceFileString),
              Length(AString)));
            AString := DllDirectory + '\' + AString;
            // read the file from disk, process it with a recursive call
            // to ReplaceTemplateFiles and then add it's lines to
            // NewTemplate before continuing.
            TemplateFile := TStringList.Create;
            try
              try
                begin
                  TemplateFile.LoadFromFile(AString);
                  result := result and ReplaceTemplateFiles(DLLName, TemplateFile);
                  NewTemplate.AddStrings(TemplateFile);
                end
              except on E: EFOpenError do
                begin
                  Beep;
                  MessageDlg(E.Message, mtError, [mbOK], 0);
                  result := false;
                end;
              end;
            finally
              // get rid of the file just read into memory.
              //
              TemplateFile.Free;
            end; // try
          end
          else
          begin
            // if it is not a command to insert a file, just add the line to
            // NewTemplate
            NewTemplate.Add(Template[InnerIndex]);
          end; // if AString[1] := '#' then
        end; // If (CommentPosition > 0) and (Pos(StopReplaceString, AString) > CommentPosition) else
      end; // While InnerIndex < Template.Count-1 do
    end  // If (CommentPosition > 0) and
    else
    begin
      NewTemplate.Add(Template[Index]);
    end;
  end;
  // get rid of the old template
  Template.Free;
  // assign the new template to the old template.
  Template := NewTemplate;
end;

function TArgusForm.ProcessTemplate (const DLLName, MetFileName : string;
  const ProgressCaption : string ;
  const VersionControl : TControl; var TemplateStringList : TStringList) : ANE_Str;
Var
  Path : string;
  TemplateOK : boolean;
begin
  TemplateOK := True;
  // initialize the result
  result := '';

  // load the met file into memory
  if not GetDllDirectory(DLLName, Path)
  then
  begin
    Beep;
    ShowMessage('Unable to find ' + DLLName);
  end
  else
  begin
    Path := Path + '\' + MetFileName;
    if FileExists(Path)
    then
    begin
      TemplateStringList.LoadFromFile(Path);
      // call ReplaceTemplateFiles to insert files into the template
      TemplateOK := TemplateOK and ReplaceTemplateFiles(DLLName, TemplateStringList);
      // replace names of controls in the template with their data
      if TemplateOK then
      begin
        TemplateString := ReplaceValues(ProgressCaption, VersionControl ,
                        TemplateStringList);
      end;

      // convert the template to a ANE_STR

      if TemplateString = '' then
      begin
        result := nil;
      end
      else
      begin
        Result := PChar(TemplateString);
      end;
    end
    else
    begin
      Beep;
      ShowMessage(Path + ' does not exist.');
    end;
  end;

end;

function TArgusForm.ReplaceValues(const ProgressCaption : string ;
  const VersionControl : TControl; const Template : TStringList) : string;
var
  ComponentIndex : integer;
  ALabel : TLabel;
  AnEdit : TEdit;
  AnArgusDataEntry : TArgusDataEntry;
  ARadioGroup : TRadioGroup;
  ACheckBox : TCheckBox;
  AComboBox : TComboBox;
  ARadioButton : TRadioButton ;
  CurrentName : String;
  StringListIndex : integer;
  AString : String;
  Start : integer;
  DecimalPosition : integer;
  AText : String;
begin
  // create the progress bar form
  Application.CreateForm(TfrmExportProgress,frmExportProgress);
//  frmExportProgress := TfrmExportProgress.Create(Application);
  try
  begin
    frmExportProgress.CurrentModelHandle := CurrentModelHandle;
    // set the properties of the progress bar form and show it.
    frmExportProgress.ProgressBar1.Max := ComponentCount;
    if not (ProgressCaption = '') then
    begin
      frmExportProgress.Caption := ProgressCaption;
    end;
    frmExportProgress.Show;

    // loop over compenents
    for ComponentIndex := 0 to ComponentCount -1 do
    begin
      // update progressbar
      frmExportProgress.ProgressBar1.StepIt;
      if not (Components[ComponentIndex].Name = '') then
      begin
        // process lables boxes
        if (Components[ComponentIndex] is TLabel) then
        begin
          ALabel := TLabel(Components[ComponentIndex]);
          CurrentName := '@' + ALabel.Name + '@';
//          if not (AnEdit = VersionControl) then
//          begin
            for StringListIndex := 0 to Template.Count - 1 do
            begin
              AString := Template.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              while Start > 0 do
              begin
                AString := Copy(AString, 1, Start -1) + ALabel.Caption
                  + Copy(AString, Start + Length(CurrentName),
                    Length(AString));

                Template.Strings[StringListIndex] := AString;
                Start := Pos(CurrentName, AString);
              end;
            end;
//          end;
        end
        // process edit boxes
        else if (Components[ComponentIndex] is TEdit) then
        begin
          AnEdit := TEdit(Components[ComponentIndex]);
          CurrentName := '@' + AnEdit.Name + '@';
          if not (AnEdit = VersionControl) then
          begin
            for StringListIndex := 0 to Template.Count - 1 do
            begin
              AString := Template.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              while Start > 0 do
              begin
                AString := Copy(AString, 1, Start -1) + AnEdit.Text
                  + Copy(AString, Start + Length(CurrentName),
                    Length(AString));

                Template.Strings[StringListIndex] := AString;
                Start := Pos(CurrentName, AString);
              end;
            end;
          end;
        end
        // process TArgusDataEntry's
        else if (Components[ComponentIndex] is TArgusDataEntry) then
        begin
          AnArgusDataEntry
            := TArgusDataEntry(Components[ComponentIndex]);

          CurrentName := '@' + AnArgusDataEntry.Name + '@';
          if not (AnArgusDataEntry = VersionControl) then
          begin
            for StringListIndex := 0 to Template.Count - 1 do
            begin
              AString := Template.Strings[StringListIndex];

              AText := AnArgusDataEntry.Output;
              if AnArgusDataEntry.DataType = dtReal then
              begin
                DecimalPosition := Pos(',',AText);
                if DecimalPosition > 0 then
                begin
                  AText[DecimalPosition] := '.';
                end;
              end;
              
              Start := Pos(CurrentName, AString);
              while Start > 0 do
              begin
                AString := Copy(AString, 1, Start -1) + AText
                  + Copy(AString, Start + Length(CurrentName),
                    Length(AString));

                Template.Strings[StringListIndex] := AString;
                Start := Pos(CurrentName, AString);
              end;
            end;
          end;
        end
        // process Radiogroups
        else if (Components[ComponentIndex] is TRadioGroup) then
        begin
          ARadioGroup := TRadioGroup(Components[ComponentIndex]);
          CurrentName := '@' + ARadioGroup.Name + '@';
          if not (ARadioGroup = VersionControl) then
          begin
            for StringListIndex := 0 to Template.Count - 1 do
            begin
              AString := Template.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              while Start > 0 do
              begin
                AString := Copy(AString, 1, Start -1)
                  + IntToStr(ARadioGroup.ItemIndex) + Copy(AString, Start
                  + Length(CurrentName), Length(AString));

                Template.Strings[StringListIndex] := AString;
                Start := Pos(CurrentName, AString);
              end;
            end;
          end;
        end
        // process check boxes
        else if (Components[ComponentIndex] is TCheckBox) then
        begin
          ACheckBox := TCheckBox(Components[ComponentIndex]);
          CurrentName := '@' + ACheckBox.Name + '@';
          if not (ACheckBox = VersionControl) then
          begin
            for StringListIndex := 0 to Template.Count - 1 do
            begin
              AString := Template.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              while Start > 0 do
              begin
                AString := Copy(AString, 1, Start -1)
                  + IntToStr(Ord(ACheckBox.Checked)) + Copy(AString, Start
                  + Length(CurrentName), Length(AString));

                Template.Strings[StringListIndex] := AString;
                Start := Pos(CurrentName, AString);
              end;
            end;
          end;
        end
        // process comboboxes
        else if (Components[ComponentIndex] is TComboBox) and
                 not ((Components[ComponentIndex] is TArgusDataEntry)) then
        begin
          AComboBox := TComboBox(Components[ComponentIndex]);
          CurrentName := '@' + AComboBox.Name + '@';
          if not (AComboBox = VersionControl) then
          begin
            for StringListIndex := 0 to Template.Count - 1 do
            begin
              AString := Template.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              while Start > 0 do
              begin
                AString := Copy(AString, 1, Start -1)
                  + IntToStr(AComboBox.ItemIndex) + Copy(AString,
                    Start + Length(CurrentName), Length(AString));

                Template.Strings[StringListIndex] := AString;
                Start := Pos(CurrentName, AString);
              end;
            end;
          end;
        end
        // process radio buttons.
        else if (Components[ComponentIndex] is TRadioButton) then
        begin
          ARadioButton := TRadioButton(Components[ComponentIndex]);
          CurrentName := '@' + ARadioButton.Name + '@';
          if not (ARadioButton = VersionControl) then
          begin
            for StringListIndex := 0 to Template.Count - 1 do
            begin
              AString := Template.Strings[StringListIndex];
              Start := Pos(CurrentName, AString);
              while Start > 0 do
              begin
                if ARadioButton.Checked
                then
                  begin
                    AString := Copy(AString, 1, Start -1)
                        + '1' + Copy(AString,
                        Start + Length(CurrentName), Length(AString));
                  end
                else
                  begin
                    AString := Copy(AString, 1, Start -1)
                        + '0' + Copy(AString,
                        Start + Length(CurrentName), Length(AString));
                  end;

                Template.Strings[StringListIndex] := AString;
                Start := Pos(CurrentName, AString);
              end;
            end;
          end;
        end;
      end;
    end;
    result := Template.Text;
  end;
  finally
    begin
      frmExportProgress.Free;
    end;
  end;
end;

procedure TArgusForm.FormCreate(Sender: TObject);
begin
//  Application.UpdateFormatSettings := False;
  OldVersionControlName := TStringList.Create;
  // any controls whose Name's are in IgnoreList will not have their
  // properties saved when saving a file. The controls on Ignore list
  // are those that determine which model and package will be exported.
  // Thus those values are reset to their defaults when you open a file.
  IgnoreList := TStringList.Create;
  IgnoreList.Sorted := True;
  // When reading a file, those controls whos names are on FirstList will
  // be read first. This is done because in a few cases, the order in which
  // data is read is important.
  FirstList := TStringList.Create;
end;

procedure TArgusForm.ReadFrame(var LineIndex : integer; FirstList,
  IgnoreList, UnreadData : TStringlist; AComponent : TComponent; DataToRead :TStringList;
  const VersionControl : TControl);
var
  AFrame : TFrame;
  Count : integer;
  AText : String;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AFrame := AComponent as TFrame;
  Count := StrToInt(AText);
  While Count > 0 do
  begin
    AComponent := GetNextComponent(LineIndex, DataToRead,UnreadData,
      VersionControl, AFrame, FirstList,
  IgnoreList);
    If AComponent <> nil then
    begin
      ReadAComponent(LineIndex, FirstList, IgnoreList, UnreadData,
        AComponent, DataToRead, VersionControl);
      Dec(Count);
    end;
  end;
end;

procedure TArgusForm.ReadEdit(var LineIndex : integer; FirstList, IgnoreList : TStringlist;
  AComponent : TComponent; DataToRead :TStringList; const VersionControl : TControl);
var
  AText : String;
  AnEdit : TEdit;
begin
  // read data for an edit box and call its OnEnter, OnChange and OnExit events.
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AnEdit := AComponent as TEdit;
  if not (AnEdit = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1)) then
  begin
    if Assigned(AnEdit.OnEnter) then
    begin
      AnEdit.OnEnter(AnEdit);
    end;
    AnEdit.Text := AText;
    if Assigned(AnEdit.OnChange) then
    begin
      AnEdit.OnChange(AnEdit);
    end;
    if Assigned(AnEdit.OnExit) then
    begin
      AnEdit.OnExit(AnEdit);
    end;
  end;
end;

{ TSpecialHandlingObject }

constructor TSpecialHandlingObject.Create(Name: string;
  ReadData: TSpecialHandling);
begin
  inherited Create;
  FName := Name;
  FReadData := ReadData;
  try
    if not Assigned(FReadData) then raise EInvalidProcedure.Create
      ('Error: The ReadData procedure is nil in a TSpecialHandlingObject');
  except on EInvalidProcedure do
    begin
      Free;
      raise;
    end;
  end;
end;

{ TSpecialHandlingList }

procedure TSpecialHandlingList.Add(
  ASpecialHandlingObject: TSpecialHandlingObject);
begin
  FList.Add(ASpecialHandlingObject);
end;

constructor TSpecialHandlingList.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TSpecialHandlingList.Destroy;
var
  Index : integer;
begin
  For Index := FList.Count -1 downto 0 do
  begin
    TSpecialHandlingList(FList.Items[Index]).Free;
  end;
  FList.Free;
  inherited Destroy;
end;

function TSpecialHandlingList.GetByName(
  AName: string): TSpecialHandlingObject;
var
  index : integer;
begin
  index := IndexOf(AName);
  if Index > -1 then
  begin
    result := Items[index];
  end
  else
  begin
    result := nil;
  end;
end;

function TSpecialHandlingList.GetCount: integer;
begin
  result := FList.Count;
end;

function TSpecialHandlingList.GetItems(Index : integer): TSpecialHandlingObject;
begin
  result := FList.Items[Index];
end;

function TSpecialHandlingList.IndexOf(AName: string): integer;
var
  Index : integer;
begin
  result := -1;
  for Index := 0 to FList.Count -1 do
  begin
    If Items[Index].Name = AName then
    begin
      result := Index;
      break;
    end;
  end;
end;

procedure TArgusForm.WriteArgusDataEntry(ComponentData : TStringList; AComponent : TComponent);
begin
  ComponentData.Add(AComponent.Name);
  ComponentData.Add
    (TArgusDataEntry(AComponent).Output);
end;

procedure TArgusForm.ReadArgusDataEntry(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; AComponent: TComponent; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText : String;
  AnArgusDataEntry : TArgusDataEntry;
//  CommaSeparator : array[0..255] of Char;
//  DecimalLocation : integer;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AnArgusDataEntry := AComponent as TArgusDataEntry;
  if not (AnArgusDataEntry = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if Assigned(AnArgusDataEntry.OnEnter) then
    begin
      AnArgusDataEntry.OnEnter(AnArgusDataEntry);
    end;
    if AnArgusDataEntry.DataType = dtBoolean
    then
      begin
        AnArgusDataEntry.ItemIndex := StrToInt(AText);
      end
    else
      begin
{        if AnArgusDataEntry.DataType = dtReal then
        begin
          GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SDECIMAL,@CommaSeparator,255);
          if String(CommaSeparator) = '.' then
          begin
            DecimalLocation := Pos(',',AText);
            if DecimalLocation > 0 then
            begin
              AText[DecimalLocation] := '.';
            end;
          end;
          if String(CommaSeparator) = ',' then
          begin
            DecimalLocation := Pos('.',AText);
            if DecimalLocation > 0 then
            begin
              AText[DecimalLocation] := ',';
            end;
          end;
        end;}
        AnArgusDataEntry.Text := AText;
      end;
    if Assigned(AnArgusDataEntry.OnChange) then
    begin
      AnArgusDataEntry.OnChange(AnArgusDataEntry);
    end;
    if Assigned(AnArgusDataEntry.OnExit) then
    begin
      AnArgusDataEntry.OnExit(AnArgusDataEntry);
    end;
  end;

end;

procedure TArgusForm.ReadCheckBox(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; AComponent: TComponent; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText : String;
  ACheckBox : TCheckBox;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ACheckBox := AComponent as TCheckBox;
  if not (ACheckBox = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if Assigned(ACheckBox.OnEnter) then
    begin
      ACheckBox.OnEnter(ACheckBox);
    end;
    if AText = '0'
    then
        begin
          ACheckBox.State := cbUnchecked;
        end
    else if AText = '1'
    then
        begin
          ACheckBox.State := cbChecked;
        end
    else if AText = '2'
    then
        begin
          ACheckBox.State := cbGrayed;
        end;
    if Assigned(ACheckBox.OnClick) then
    begin
      ACheckBox.OnClick(ACheckBox);
    end;
    if Assigned(ACheckBox.OnExit) then
    begin
      ACheckBox.OnExit(ACheckBox);
    end;
  end;

end;

procedure TArgusForm.ReadComboBox(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; AComponent: TComponent; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText : String;
  AComboBox : TComboBox;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  AComboBox := AComponent as TComboBox;
  if not (AComboBox = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if Assigned(AComboBox.OnEnter) then
    begin
      AComboBox.OnEnter(AComboBox);
    end;
    if AComboBox.Style = csDropDownList then
    begin
      AComboBox.ItemIndex := StrToInt(AText);
    end
    else
    begin
      AComboBox.Text := AText;
      AComboBox.ItemIndex := AComboBox.Items.IndexOf(AText);
    end;
    if Assigned(AComboBox.OnChange) then
    begin
      AComboBox.OnChange(AComboBox);
    end;
    if Assigned(AComboBox.OnExit) then
    begin
      AComboBox.OnExit(AComboBox);
    end;
  end;

end;

procedure TArgusForm.ReadMemo(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; AComponent: TComponent; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText : String;
  AMemo : TMemo;
  LineCount : Integer;
  MemoIndex : Integer;
begin
  AMemo := AComponent as TMemo;
  if not (AMemo = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if Assigned(AMemo.OnEnter) then
    begin
      AMemo.OnEnter(AMemo);
    end;
    AMemo.Lines.Clear;
  end;
  LineCount := StrToInt(DataToRead[LineIndex]);
  Inc(LineIndex);
  For MemoIndex := 0 to LineCount -1 do
  begin
      AText := DataToRead[LineIndex];
      Inc(LineIndex);
      if not (AMemo = VersionControl) and
        ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
      then
      begin
        AMemo.Lines.Add( AText);
        If Assigned(AMemo.OnChange) then
        begin
          AMemo.OnChange(AMemo);
        end;
      end;
  end;
  if not (AMemo = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
  then
  begin
    if Assigned(AMemo.OnExit) then
    begin
      AMemo.OnExit(AMemo);
    end;
  end;

end;

procedure TArgusForm.ReadRadioButton(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; AComponent: TComponent; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText : String;
  ARadioButton : TRadioButton;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ARadioButton := AComponent as TRadioButton;
  if not (ARadioButton = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if Assigned(ARadioButton.OnEnter) then
    begin
      ARadioButton.OnEnter(ARadioButton);
    end;
    if AText = '0'
    then
        begin
          ARadioButton.Checked := False;
        end
    else
        begin
          ARadioButton.Checked := True;
        end ;
    if Assigned(ARadioButton.OnClick) then
    begin
      ARadioButton.OnClick(ARadioButton);
    end;
    if Assigned(ARadioButton.OnExit) then
    begin
      ARadioButton.OnExit(ARadioButton);
    end;
  end;

end;

procedure TArgusForm.ReadRadioGroup(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; AComponent: TComponent; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText : String;
  ARadioGroup : TRadioGroup;
begin
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ARadioGroup := AComponent as TRadioGroup;
  if not (ARadioGroup = VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if Assigned(ARadioGroup.OnEnter) then
    begin
      ARadioGroup.OnEnter(ARadioGroup);
    end;
    ARadioGroup.ItemIndex := StrToInt(AText);
    if Assigned(ARadioGroup.OnClick) then
    begin
      ARadioGroup.OnClick(ARadioGroup);
    end;
    if Assigned(ARadioGroup.OnExit) then
    begin
      ARadioGroup.OnExit(ARadioGroup);
    end;
  end;

end;

function TArgusForm.SetRows(AStringGrid : TStringGrid) : boolean;
begin
  Result := True;
end;

function TArgusForm.SetColumns(AStringGrid : TStringGrid) : boolean;
begin
  Result := True;
end;

{$IFDEF StringGrid3d}
procedure TArgusForm.ReadStringGrid3D(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; AComponent: TComponent; DataToRead: TStringList;
  const VersionControl: TControl);
var
  A3DGrid : TRBWCustom3DGrid;
  Index : integer;
  AText : String;
  AStringGrid : TStringGrid;
begin
  A3DGrid := AComponent as TRBWCustom3DGrid;

  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  for Index := 0 to StrToInt(AText) -1 do
  begin
    if Index > A3DGrid.PageCount -1 then
    begin
      A3DGrid.AddGrid;
      AStringGrid := A3DGrid.Grids[Index];
    end
    else
    begin
      AStringGrid := A3DGrid.Grids[Index];
    end;
    ReadStringGrid(LineIndex, FirstList, IgnoreList, AStringGrid, DataToRead,
      VersionControl);
  end;

end;
{$ENDIF}

procedure TArgusForm.ReadStringGrid(var LineIndex: integer;
  FirstList, IgnoreList: TStringlist; AComponent: TComponent; DataToRead: TStringList;
  const VersionControl: TControl);
var
  AText : String;
  AStringGrid : TStringGrid;
  RowLimit, ColLimit : integer;
  ColIndex, RowIndex : integer;
  CanSelect : boolean;
begin
  AStringGrid := AComponent as TStringGrid;

  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  RowLimit := StrToInt(AText);
  if (AComponent <> nil) and (AStringGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name) > -1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if Assigned(AStringGrid.OnEnter) then
    begin
      AStringGrid.OnEnter(AStringGrid);
    end;
    if SetRows(AStringGrid) then
    begin
      AStringGrid.RowCount := RowLimit;
    end;
  end;
  AText := DataToRead[LineIndex];
  Inc(LineIndex);
  ColLimit := StrToInt(AText);
  if (AComponent <> nil) and (AStringGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1)) and
    ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if SetColumns(AStringGrid) then
    begin
      AStringGrid.ColCount := ColLimit;
    end;
  end;
  For RowIndex := 0 to RowLimit -1 do
  begin
    For ColIndex := 0 to ColLimit -1 do
    begin
      AText := DataToRead[LineIndex];
      Inc(LineIndex);
      if (AComponent <> nil) and (AStringGrid <> VersionControl) and
        ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1)) and
        ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
      then
      begin
        if Assigned(AStringGrid.OnSelectCell) then
        begin
          CanSelect := True;
          AStringGrid.OnSelectCell(AStringGrid,ColIndex,RowIndex,CanSelect);
        end;
        AStringGrid.Cells[ColIndex,RowIndex] := AText;
        if Assigned(AStringGrid.OnSetEditText) then
        begin
          AStringGrid.OnSetEditText(AStringGrid,ColIndex,RowIndex,AText);
        end;
      end;
    end;
  end;
  if (AComponent <> nil) and (AStringGrid <> VersionControl) and
    ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1)) and
        ((IgnoreList = nil) or (IgnoreList.IndexOf(AComponent.Name) = -1))
  then
  begin
    if Assigned(AStringGrid.OnExit) then
    begin
      AStringGrid.OnExit(AStringGrid);
    end;
  end;

end;

procedure TArgusForm.FormDestroy(Sender: TObject);
begin
  inherited;
  // get rid of the stringlist containing names of controls that
  // formerly held version information.
  OldVersionControlName.Free;
  // destroy the ignorelist and FirstList stringlists
  FirstList.Free;
  IgnoreList.Free;
end;

procedure TArgusForm.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TArgusForm.ModelPaths(var AStringList : TStringList;
  const Version : TControl; const Developer : string);
var
  IgnoreList : TStringList;
  Index : integer;
  Name : string;
  ModelNames : TStringList;
begin
  inherited;
  // create a string list that can be used to set the model paths
  // in an .ini file
  IgnoreList := TStringList.Create;
  ModelNames := TStringList.Create;
  try
    ModelComponentName(ModelNames);
    for Index := 0 to ComponentCount-1 do
    begin
      Name := Components[Index].Name;
      if ModelNames.IndexOf(Name) < 0 then
      begin
        IgnoreList.Add(Name);
      end;
    end;
    AStringList.Text := FormToString(Version, IgnoreList, Developer);
  finally
    IgnoreList.Free;
    ModelNames.Free;
  end;

end;

procedure TArgusForm.LoadForm(UnreadData: TStringlist;
  DataToRead: string; var VersionInString: string;
  const VersionControl : TControl);
begin

  // read the data that has to be read first
  StringToForm(DataToRead, UnreadData,
       VersionControl, VersionInString, False,
       FirstList, IgnoreList, PIEDeveloper);

  // read all other data.
  StringToForm(DataToRead, UnreadData,
       VersionControl, VersionInString, True, nil, IgnoreList,
       PIEDeveloper);

end;

procedure TArgusForm.WriteCheckBox(ComponentData: TStringList;
  AComponent: TComponent);
begin
  ComponentData.Add(AComponent.Name);
  ComponentData.Add
    (IntToStr(Ord(TCheckBox(AComponent).State)));
end;

procedure TArgusForm.WriteComboBox(ComponentData: TStringList;
  AComponent: TComponent);
begin
  ComponentData.Add(AComponent.Name);
  if TComboBox(AComponent).Style = csDropDownList then
  begin
    ComponentData.Add
      (IntToStr(TComboBox(AComponent).ItemIndex));
  end
  else
  begin
    ComponentData.Add
      (TComboBox(AComponent).Text);
  end;
end;

procedure TArgusForm.WriteEdit(ComponentData: TStringList;
  AComponent: TComponent);
begin
  ComponentData.Add(AComponent.Name);
  ComponentData.Add(TEdit(AComponent).Text);
end;

procedure TArgusForm.WriteMemo(ComponentData: TStringList;
  AComponent: TComponent);
var
  MemoIndex : integer;
begin
  ComponentData.Add(AComponent.Name);
  ComponentData.Add
    (IntToStr(TMemo(AComponent).Lines.Count));
  For MemoIndex := 0 to
    TMemo(AComponent).Lines.Count -1 do
  begin
      ComponentData.Add
        (TMemo(AComponent).Lines[MemoIndex]);
  end;
end;

procedure TArgusForm.WriteRadioButton(ComponentData: TStringList;
  AComponent: TComponent);
begin
  ComponentData.Add(AComponent.Name);
  if TRadioButton(AComponent).Checked
  then
    begin
      ComponentData.Add('1');
    end
  else
    begin
      ComponentData.Add('0');
    end;
end;

procedure TArgusForm.WriteRadioGroup(ComponentData: TStringList;
  AComponent: TComponent);
begin
  ComponentData.Add(AComponent.Name);
  ComponentData.Add
    (IntToStr(TRadioGroup(AComponent).ItemIndex));
end;

procedure TArgusForm.WriteStringGrid(ComponentData: TStringList;
  AComponent: TComponent);
var
  RowIndex,ColIndex : integer;
begin
  ComponentData.Add(AComponent.Name);
  ComponentData.Add
    (IntToStr(TStringGrid(AComponent).RowCount));
  ComponentData.Add
    (IntToStr(TStringGrid(AComponent).ColCount));
  For RowIndex := 0 to
    TStringGrid(AComponent).RowCount -1 do
  begin
    For ColIndex := 0 to
      TStringGrid(AComponent).ColCount -1 do
    begin
      ComponentData.Add
        (TStringGrid(AComponent).Cells
        [ColIndex,RowIndex]);
    end;
  end;
end;

procedure TArgusForm.writeStringGrid3D(ComponentData: TStringList;
  AComponent: TComponent);
  {$IFDEF StringGrid3d}
var
  GridIndex : integer;
  AStringGrid : TStringGrid;
  RowIndex,ColIndex : integer;
  {$ENDIF}
begin
  {$IFDEF StringGrid3d}
  ComponentData.Add(AComponent.Name);
  ComponentData.Add
    (IntToStr(TRBWCustom3DGrid(AComponent).PageCount));
  for GridIndex := 0 to TRBWCustom3DGrid(AComponent).PageCount -1 do
  begin
    AStringGrid := TRBWCustom3DGrid(AComponent).Grids[GridIndex];

    ComponentData.Add(IntToStr(AStringGrid.RowCount));
    ComponentData.Add(IntToStr(AStringGrid.ColCount));
    For RowIndex := 0 to AStringGrid.RowCount -1 do
    begin
      For ColIndex := 0 to AStringGrid.ColCount -1 do
      begin
        ComponentData.Add(AStringGrid.Cells[ColIndex,RowIndex]);
      end;
    end;
  end;
  {$ENDIF}
end;

procedure TArgusForm.WriteFrame(ComponentData: TStringList;
  AComponent: TComponent; const IgnoreList :TStringlist);
var
  TempComponentData : TStringList;
  Count : integer;
begin
  ComponentData.Add(AComponent.Name);
  TempComponentData := TStringList.Create;
  try
    Count := WriteComponents(TempComponentData, IgnoreList, AComponent);
    ComponentData.Add(IntToStr(Count));
    if Count > 0 then
    begin
      ComponentData.AddStrings(TempComponentData);
    end;
  finally
    TempComponentData.Free;
  end;

{  ComponentData.Add
    (IntToStr(TRBWCustom3DGrid(AComponent).PageCount));
  for GridIndex := 0 to TRBWCustom3DGrid(AComponent).PageCount -1 do
  begin
    AStringGrid := TRBWCustom3DGrid(AComponent).Grids[GridIndex];

    ComponentData.Add(IntToStr(AStringGrid.RowCount));
    ComponentData.Add(IntToStr(AStringGrid.ColCount));
    For RowIndex := 0 to AStringGrid.RowCount -1 do
    begin
      For ColIndex := 0 to AStringGrid.ColCount -1 do
      begin
        ComponentData.Add(AStringGrid.Cells[ColIndex,RowIndex]);
      end;
    end;
  end; }
end;

function TArgusForm.WriteComponent(ComponentData: TStringList;
  AComponent: TComponent; const IgnoreList :TStringlist) : integer;
begin
  result := 0;
  if AComponent is TEdit then
    begin
      WriteEdit(ComponentData, AComponent);
{              ComponentData.Add(AComponent.Name);
      ComponentData.Add(TEdit(AComponent).Text);}
      result := 1;
    end
  // add data for TArgusDataEntry's
  else if AComponent is TArgusDataEntry then
    begin
      WriteArgusDataEntry(ComponentData, AComponent);
{              ComponentData.Add(AComponent.Name);
      ComponentData.Add
        (TArgusDataEntry(AComponent).Output);  }
      result := 1;
    end
  // add data for radio groups.
  else if AComponent is TRadioGroup then
    begin
      WriteRadioGroup(ComponentData, AComponent);
{              ComponentData.Add(Components[ComponentIndex].Name);
      ComponentData.Add
        (IntToStr(TRadioGroup(AComponent).ItemIndex)); }
      result := 1;
    end
  // add data for checkboxes
  else if AComponent is TCheckBox then
    begin
      WriteCheckBox(ComponentData, AComponent);
{              ComponentData.Add(AComponent.Name);
      ComponentData.Add
        (IntToStr(Ord(TCheckBox(AComponent).State)));}
      result := 1;
    end
  // add data for comboboxes (unless they are TArgusDataEntry's)
  else if AComponent is TComboBox then
    begin
      WriteComboBox(ComponentData, AComponent);
{              ComponentData.Add(AComponent.Name);
      if TComboBox(AComponent).Style = csDropDownList then
      begin
        ComponentData.Add
          (IntToStr(TComboBox(AComponent).ItemIndex));
      end
      else
      begin
        ComponentData.Add
          (TComboBox(AComponent).Text);
      end;  }
      result := 1;
    end
  // add data for radio buttons.
  else if AComponent is TRadioButton then
    begin
      WriteRadioButton(ComponentData, AComponent);
{              ComponentData.Add(AComponent.Name);
      if TRadioButton(AComponent).Checked
      then
        begin
          ComponentData.Add('1');
        end
      else
        begin
          ComponentData.Add('0');
        end;  }
      result := 1;
    end
  // add data for string grids.
  else if AComponent is TStringGrid then
    begin
      WriteStringGrid(ComponentData, AComponent);
{              ComponentData.Add(AComponent.Name);
      ComponentData.Add
        (IntToStr(TStringGrid(AComponent).RowCount));
      ComponentData.Add
        (IntToStr(TStringGrid(AComponent).ColCount));
      For RowIndex := 0 to
        TStringGrid(AComponent).RowCount -1 do
      begin
        For ColIndex := 0 to
          TStringGrid(AComponent).ColCount -1 do
        begin
          ComponentData.Add
            (TStringGrid(AComponent).Cells
            [ColIndex,RowIndex]);
        end;
      end;  }
      result := 1;
    end
{$IFDEF StringGrid3d}
  else if AComponent is TRBWCustom3DGrid then
  begin
      writeStringGrid3D(ComponentData, AComponent);
{            ComponentData.Add(AComponent.Name);
    ComponentData.Add
      (IntToStr(TRBWCustom3DGrid(AComponent).PageCount));
    for GridIndex := 0 to TRBWCustom3DGrid(AComponent).PageCount -1 do
    begin
      AStringGrid := TRBWCustom3DGrid(AComponent).Grids[GridIndex];

      ComponentData.Add(IntToStr(AStringGrid.RowCount));
      ComponentData.Add(IntToStr(AStringGrid.ColCount));
      For RowIndex := 0 to AStringGrid.RowCount -1 do
      begin
        For ColIndex := 0 to AStringGrid.ColCount -1 do
        begin
          ComponentData.Add(AStringGrid.Cells[ColIndex,RowIndex]);
        end;
      end;
    end; }
      result := 1;
  end
{$ENDIF}
{$IFDEF DataTableInstalled}
  // obsolete
  // add data for TDataTbl's
  else if AComponent is TDataTbl then
    begin
      ComponentData.Add(AComponent.Name);
      ComponentData.Add
        (IntToStr(TDataTbl(AComponent).RowSet.Count));
      ComponentData.Add
        (IntToStr(TDataTbl(AComponent).ColumnSet.Count));
      For ColIndex := 0 to
        TDataTbl(AComponent).ColumnSet.Count -1 do
      begin
          if TDataTbl(AComponent).ColumnSet[ColIndex].DataType = DttLongInt then
            begin
              For RowIndex := 0 to TDataTbl(AComponent).RowSet.Count -1 do
              begin
                ComponentData.Add
                  (IntToStr(TDataTbl(AComponent).CellSet.Item
                  [RowIndex,ColIndex].Value));
              end;
            end
          else if TDataTbl(AComponent).ColumnSet[ColIndex].DataType = DttDoubleFloat then
            begin
              For RowIndex := 0 to TDataTbl(AComponent).RowSet.Count -1 do
              begin
                ComponentData.Add
                  (FloatToStr(TDataTbl(AComponent).CellSet.Item
                  [RowIndex,ColIndex].Value));
              end;
            end
          else if TDataTbl(AComponent).ColumnSet[ColIndex].DataType = DttString then
            begin
              For RowIndex := 0 to TDataTbl(AComponent).RowSet.Count -1 do
              begin
                ComponentData.Add
                  (TDataTbl(AComponent).CellSet.Item
                  [RowIndex,ColIndex].Value);
              end;
            end
      end;
      result := 1;
    end
{$ENDIF}
  // add data for memos
  else if AComponent is TMemo then
  begin
    writeMemo(ComponentData, AComponent);
{              ComponentData.Add(Components[ComponentIndex].Name);
    ComponentData.Add
      (IntToStr(TMemo(AComponent).Lines.Count));
    For MemoIndex := 0 to
      TMemo(AComponent).Lines.Count -1 do
    begin
        ComponentData.Add
          (TMemo(AComponent).Lines[MemoIndex]);
    end; }
      result := 1;
  end // if AComponent is TEdit then .... else if Components[ComponentIndex] is TMemo then
  else if AComponent is TFrame then
  begin
    writeFrame(ComponentData, AComponent, IgnoreList);
{              ComponentData.Add(Components[ComponentIndex].Name);
    ComponentData.Add
      (IntToStr(TMemo(AComponent).Lines.Count));
    For MemoIndex := 0 to
      TMemo(AComponent).Lines.Count -1 do
    begin
        ComponentData.Add
          (TMemo(AComponent).Lines[MemoIndex]);
    end; }
      result := 1;
  end
end;

function TArgusForm.WriteComponents(ComponentData: TStringList;
  const IgnoreList :TStringlist; OwningComponent: TComponent): integer;
var
  AComponent: TComponent;
  ComponentIndex : integer;
begin
  result := 0;
  For ComponentIndex := 0 to OwningComponent.ComponentCount -1  do
  begin
    // get a component
    AComponent := OwningComponent.Components[ComponentIndex];
    // skip the component if it doesn't have a name or if
    // it's name is in the IgnoreList.
    if not(AComponent.Name = '') and ((IgnoreList = nil)
       or (IgnoreList.IndexOf(AComponent.Name) = -1))
       then
    begin
      result := result + WriteComponent(ComponentData, AComponent, IgnoreList);
      // add data for edit boxes.
    end;
  end;
end;

function TArgusForm.GetNextComponent(var LineIndex : integer;
  DataToRead,UnreadData : TStringList; const VersionControl: TControl;
  SourceComponent : TComponent; FirstList, IgnoreList: TStringlist) : TComponent;
var
  AName : string;
  ASpecialHandlingObject : TSpecialHandlingObject; // ASpecialHandlingObject is
begin
  result := nil;
  AName := DataToRead[LineIndex];
  // go to the next line.
  Inc(LineIndex);
  // if this should be handled by a TSpecialHandlingObject
  // do so.
  if (SpecialHandlingList <> nil)
    and (SpecialHandlingList.IndexOf(AName) > -1) then
  begin
    ASpecialHandlingObject := SpecialHandlingList.GetByName(AName);
    ASpecialHandlingObject.ReadData(LineIndex, FirstList, IgnoreList,
      DataToRead, VersionControl);
  end
  else
  begin
    // Get the current component
    result := SourceComponent.FindComponent(AName);

    // If you can't find the compenent, add it's name to UnreadData
    // The data will be added to UnreadData too except in the
    // unlikely event that the data contained in a component is
    // the name of another component.
    if (result = nil) and (AName <> '')
    then
    begin
      UnreadData.Add(AName);
    end
  end;
end;

procedure TArgusForm.ReadAComponent(var LineIndex : integer; FirstList,
  IgnoreList, UnreadData : TStringlist; AComponent : TComponent; DataToRead :TStringList;
  const VersionControl : TControl);
begin
  if AComponent is TEdit
  then
    begin
      ReadEdit(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
        VersionControl);
    end
  // read data for TArgusDataEntry's
  else if AComponent is TArgusDataEntry then
    begin
      ReadArgusDataEntry(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
        VersionControl);
    end
  // read data for TRadioGroup's
  else if (AComponent is TRadioGroup) then
    begin
      ReadRadioGroup(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
        VersionControl);
    end
  // read data for checkboxes.
  else if (AComponent is TCheckBox) then
    begin
      ReadCheckBox(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
        VersionControl);
    end
  // read data for comboboxes (unless they are TArgusDataEntry's)
  else if (AComponent is TComboBox) then
    begin
      ReadComboBox(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
        VersionControl);
    end
  // read data for radio buttons.
  else if (AComponent is TRadioButton) then
    begin
      ReadRadioButton(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
        VersionControl);
    end
  // read data for StringGrids
  else if (AComponent is TStringGrid) then
    begin
      ReadStringGrid(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
        VersionControl);
    end
{$IFDEF StringGrid3d}
  else if (AComponent is TRBWCustom3DGrid) then
    begin
      ReadStringGrid3D(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
        VersionControl);
    end
{$ENDIF}
{$IFDEF DataTableInstalled}
  // obsolete
  // read data for TDatatbl
  else if (AComponent is TDatatbl) then
    begin
        ADatatbl := AComponent as TDatatbl;

        AText := DataToRead[LineIndex];
        Inc(LineIndex);
        RowLimit := StrToInt(AText);
        if not (ADatatbl = VersionControl) and
          ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
        then
        begin
          ADatatbl.RowSet.Count := RowLimit;
        end;
        AText := DataToRead[LineIndex];
        Inc(LineIndex);
        ColLimit := StrToInt(AText);
        if not (ADatatbl = VersionControl) and
          ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
        then
        begin
          ADatatbl.ColumnSet.Count := ColLimit;
        end;
        For ColIndex := 0 to ColLimit -1 do
        begin
          if ADatatbl.ColumnSet[ColIndex].DataType = DttLongInt then
            begin
              For RowIndex := 0 to RowLimit -1 do
              begin
                AText := DataToRead[LineIndex];
                Inc(LineIndex);
                if not (ADatatbl = VersionControl) and
                  ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                then
                begin
                  ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := StrToInt(AText);

                end;
              end;
            end
          else if ADatatbl.ColumnSet[ColIndex].DataType = DttDoubleFloat then
            begin
              For RowIndex := 0 to RowLimit -1 do
              begin
                AText := DataToRead[LineIndex];
                Inc(LineIndex);
                if not (ADatatbl = VersionControl) and
                  ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                then
                begin
                  ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := StrToFloat(AText);
                end;
              end;
            end
          else if ADatatbl.ColumnSet[ColIndex].DataType = DttString then
            begin
              For RowIndex := 0 to RowLimit -1 do
              begin
                AText := DataToRead[LineIndex];
                Inc(LineIndex);
                if not (ADatatbl = VersionControl) and
                  ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                then
                begin
                  ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := AText;
                end;
              end;
            end
        end;
      end
{$ENDIF}
  // read data for memo's
  else if (AComponent is TMemo) then
  begin
    ReadMemo(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
      VersionControl);
  end //if AComponent is TEdit then ... else if (AComponent is TMemo) then
  else if (AComponent is TFrame) then
  begin
    ReadFrame(LineIndex, FirstList, IgnoreList, UnreadData, AComponent,
      DataToRead, VersionControl);
  end;
end;

procedure TArgusForm.ReadComponents(var LineIndex: integer; FirstList,
  IgnoreList: TStringlist; {AComponent: TComponent;} DataToRead: TStringList;
  const VersionControl: TControl; AName : string; UnreadData : TStringlist;
  SourceComponent : TComponent);
var
//  ASpecialHandlingObject : TSpecialHandlingObject; // ASpecialHandlingObject is
  AComponent: TComponent;
begin
  While LineIndex < DataToRead.Count do
  begin
    AComponent := GetNextComponent(LineIndex, DataToRead,UnreadData,
      VersionControl, SourceComponent, FirstList, IgnoreList);

{    // read the name of a control
    AName := DataToRead[LineIndex];
    // go to the next line.
    Inc(LineIndex);
    // if this should be handled by a TSpecialHandlingObject
    // do so.
    if (SpecialHandlingList <> nil)
      and (SpecialHandlingList.IndexOf(AName) > -1) then
    begin
      ASpecialHandlingObject := SpecialHandlingList.GetByName(AName);
      ASpecialHandlingObject.ReadData(LineIndex, FirstList, nil,
        DataToRead, VersionControl);
    end
    else
    begin
      // Get the current component
      AComponent := FindComponent(AName);

      // If you can't find the compenent, add it's name to UnreadData
      // The data will be added to UnreadData too except in the
      // unlikely event that the data contained in a component is
      // the name of another component.
      if (AComponent = nil) and (AName <> '')
      then
        begin
          UnreadData.Add(AName);
        end
      // read data for edit boxes.
      else  }
      If AComponent <> nil then
      begin
        ReadAComponent(LineIndex, FirstList, IgnoreList, UnreadData,
          AComponent, DataToRead, VersionControl);
{        if AComponent is TEdit
        then
          begin
            ReadEdit(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
              VersionControl);
          end
        // read data for TArgusDataEntry's
        else if AComponent is TArgusDataEntry then
          begin
            ReadArgusDataEntry(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
              VersionControl);
          end
        // read data for TRadioGroup's
        else if (AComponent is TRadioGroup) then
          begin
            ReadRadioGroup(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
              VersionControl);
          end
        // read data for checkboxes.
        else if (AComponent is TCheckBox) then
          begin
            ReadCheckBox(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
              VersionControl);
          end
        // read data for comboboxes (unless they are TArgusDataEntry's)
        else if (AComponent is TComboBox) then
          begin
            ReadComboBox(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
              VersionControl);
          end
        // read data for radio buttons.
        else if (AComponent is TRadioButton) then
          begin
            ReadRadioButton(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
              VersionControl);
          end
        // read data for StringGrids
        else if (AComponent is TStringGrid) then
          begin
            ReadStringGrid(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
              VersionControl);
          end }
  {$IFDEF StringGrid3d}
{        else if (AComponent is TRBWCustom3DGrid) then
          begin
            ReadStringGrid3D(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
              VersionControl);
          end  }
  {$ENDIF}
  {$IFDEF DataTableInstalled}
        // obsolete
        // read data for TDatatbl
{        else if (AComponent is TDatatbl) then
          begin
              ADatatbl := AComponent as TDatatbl;

              AText := DataToRead[LineIndex];
              Inc(LineIndex);
              RowLimit := StrToInt(AText);
              if not (ADatatbl = VersionControl) and
                ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
              then
              begin
                ADatatbl.RowSet.Count := RowLimit;
              end;
              AText := DataToRead[LineIndex];
              Inc(LineIndex);
              ColLimit := StrToInt(AText);
              if not (ADatatbl = VersionControl) and
                ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
              then
              begin
                ADatatbl.ColumnSet.Count := ColLimit;
              end;
              For ColIndex := 0 to ColLimit -1 do
              begin
                if ADatatbl.ColumnSet[ColIndex].DataType = DttLongInt then
                  begin
                    For RowIndex := 0 to RowLimit -1 do
                    begin
                      AText := DataToRead[LineIndex];
                      Inc(LineIndex);
                      if not (ADatatbl = VersionControl) and
                        ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                      then
                      begin
                        ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := StrToInt(AText);

                      end;
                    end;
                  end
                else if ADatatbl.ColumnSet[ColIndex].DataType = DttDoubleFloat then
                  begin
                    For RowIndex := 0 to RowLimit -1 do
                    begin
                      AText := DataToRead[LineIndex];
                      Inc(LineIndex);
                      if not (ADatatbl = VersionControl) and
                        ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                      then
                      begin
                        ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := StrToFloat(AText);
                      end;
                    end;
                  end
                else if ADatatbl.ColumnSet[ColIndex].DataType = DttString then
                  begin
                    For RowIndex := 0 to RowLimit -1 do
                    begin
                      AText := DataToRead[LineIndex];
                      Inc(LineIndex);
                      if not (ADatatbl = VersionControl) and
                        ((FirstList = nil) or (FirstList.IndexOf(AComponent.Name)>-1))
                      then
                      begin
                        ADatatbl.CellSet.Item[RowIndex, ColIndex].Value := AText;
                      end;
                    end;
                  end
              end;
            end}
  {$ENDIF}
        // read data for memo's
{        else if (AComponent is TMemo) then
        begin
          ReadMemo(LineIndex, FirstList, IgnoreList, AComponent, DataToRead,
            VersionControl);
        end //if AComponent is TEdit then ... else if (AComponent is TMemo) then}
      end; // if AComponent <> nil then
//    end; // if (SpecialHandlingList <> nil) ...
  end;  // While LineIndex < DataToRead.Count do
end;

procedure TArgusForm.WriteSpecial(ComponentData: TStringList;
  const IgnoreList: TStringlist; OwningComponent: TComponent);
begin
  // override in descendents
end;

{constructor TArgusForm.Create(AOwner: TComponent);
begin
//  OldCreateOrder := True;
  inherited;
end;  }

Initialization
begin
  // get the name of the current DLL.
  DLLName := GetDLLName;
end;

end.


