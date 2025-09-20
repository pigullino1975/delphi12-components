unit QImport3Reg;

{$I QImport3VerCtrl.Inc}

interface

uses
{$IFDEF VCL16}
  System.SysUtils,
  System.Classes,
  Data.DB,
  Vcl.Dialogs,
{$ELSE}
  SysUtils,
  Classes,
  DB,
  Dialogs,
{$ENDIF}
{$IFNDEF VCL6}
  DsgnIntf,
{$ELSE}
  DesignIntf,
  DesignEditors,
{$ENDIF}
{$IFDEF SPLASH}
   ToolsAPI,
  {$IFDEF VCL16}
    Vcl.Graphics,
    Winapi.Windows,
  {$ELSE}
    Graphics,
    Windows,
  {$ENDIF}
{$ENDIF}
  QImport3,
  QImport3XLS,
  QImport3DBF,
  QImport3ASCII,
  QImport3XML,
  QImport3DataSet,
  QImport3Wizard,
  {$IFDEF HTML}QImport3HTML, fuQImport3HTMLEditor,{$ENDIF}
  {$IFDEF XMLDOC}QImport3XMLDoc, fuQImport3XMLDocEditor,{$ENDIF}
  {$IFDEF XLSX}QImport3Xlsx, fuQImport3XlsxEditor,{$ENDIF}
  {$IFDEF DOCX}QImport3Docx, fuQImport3DocxEditor,{$ENDIF}
  {$IFDEF ODS}QImport3ODS, fuQImport3ODSEditor,{$ENDIF}
  {$IFDEF ODT}QImport3ODT, fuQImport3ODTEditor,{$ENDIF}
  {$IFDEF ADO}ADO_QImport3Access,{$ENDIF}
  {$IFDEF USESCRIPT}QImport3JScriptEngine,{$ENDIF}
  QImport3Common,
  QImport3StrIDs,
  fuQImport3DBFEditor,
  fuQImport3XMLEditor,
  fuQImport3TXTEditor,
  fuQImport3CSVEditor,
  fuQImport3DataSetEditor,
  fuQImport3About,
  fuQImport3FormatsEditor,
  fuQImport3XLSEditor,
  QImport3StrTypes;

type
// ********************
// Property editors ***
// ********************
  TQFileNameProperty = class(TStringProperty)
  protected
    function GetDefaultExt: string; virtual; abstract;
    function GetFilter: string; virtual; abstract;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TQASCIIFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;

  TQDBFFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;

  TQXMLFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;

  TQXLSFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;

  TQTemplateFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;

  TQWizardFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;

  TQImportAboutProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TQImportVersionProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  TQFieldNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{$IFDEF HTML}
  TQHTMLFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;
{$ENDIF}

{$IFDEF XMLDOC}
  TQXMLDocFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;
{$ENDIF}

{$IFDEF XLSX}
  TQXlsxFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;
{$ENDIF}

{$IFDEF DOCX}
  TQDocxFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;
{$ENDIF}

{$IFDEF ODS}
  TQODSFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;
{$ENDIF}

{$IFDEF ODT}
  TQODTFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;
{$ENDIF}

{$IFDEF ADO}
  TQAccessFileNameProperty = class(TQFileNameProperty)
  protected
    function GetDefaultExt: string; override;
    function GetFilter: string; override;
  end;

  TQAccessTableNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;
{$ENDIF}

// *************************
// *** Component editors ***
// *************************

  TQImportWizardEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

  TQImportXLSEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

  TQImportDataSetEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

  TQImportXMLEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

  TQImportDBFEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

  TQImportASCIIEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

{$IFDEF HTML}
  TQImportHTMLEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;
{$ENDIF}

{$IFDEF XMLDOC}
  TQImportXMLDocEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;
{$ENDIF}

{$IFDEF XLSX}
  TQImportXlsxEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;
{$ENDIF}

{$IFDEF DOCX}
  TQImportDocxEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;
{$ENDIF}

{$IFDEF ODS}
  TQImportODSEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;
{$ENDIF}

{$IFDEF ODT}
  TQImportODTEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;
{$ENDIF}

procedure Register;

implementation

const
  S_IDE_ABOUT_TITLE       = 'EMS ' + QI_FULL_PRODUCT_NAME;
  S_IDE_ABOUT_DESCRIPTION = 'The Set of Native Delphi Components to import data from most popular formats.';
  S_IDE_PALETTE_PAGE      = S_IDE_ABOUT_TITLE;

{$IFDEF VCL10}
{$R QImport3RegD10.dcr}
{$ELSE}
{$R QImport3Reg.dcr}
{$ENDIF}

{$IFDEF SPLASH}
{$R RegisterSplashScreen.res}

procedure RegisterWithSplashScreen;
var
  AboutSvcs: IOTAAboutBoxServices;
  S: string;
  ProductImage: HBITMAP;
begin
  ProductImage := LoadBitmap(FindResourceHInstance(HInstance), 'SPLASH');
  S := S_IDE_ABOUT_TITLE + ' ' + QI_VERSION_NUMBER;;
  SplashScreenServices.AddPluginBitmap(S, ProductImage, {$IFDEF ADVANCED_DATA_IMPORT_TRIAL_VERSION}True{$ELSE}False{$ENDIF}, QI_VERSION);
	AboutSvcs := (BorlandIDEServices AS IOTAAboutBoxServices);
	if Assigned(AboutSvcs) then
  begin
    ProductImage := LoadBitmap(FindResourceHInstance(HInstance), 'SPLASH');
	  AboutSvcs.AddPluginInfo(S, S_IDE_ABOUT_DESCRIPTION, ProductImage, {$IFDEF ADVANCED_DATA_IMPORT_TRIAL_VERSION}True{$ELSE}False{$ENDIF}, QI_VERSION);
  end;
end;
{$ENDIF}

procedure Register;
begin
  RegisterComponents(S_IDE_PALETTE_PAGE,
    [TQImport3Wizard, TQImport3XLS, TQImport3DBF, TQImport3ASCII, TQImport3XML,
     TQImport3DataSet
    {$IFDEF USESCRIPT}, TQImport3JScriptEngine{$ENDIF}
    {$IFDEF HTML}, TQImport3HTML {$ENDIF}
    {$IFDEF XMLDOC}, TQImport3XMLDoc {$ENDIF}
    {$IFDEF DOCX}, TQImport3Docx {$ENDIF}
    {$IFDEF XLSX}, TQImport3Xlsx {$ENDIF}
    {$IFDEF ODS}, TQImport3ODS {$ENDIF}
    {$IFDEF ODT}, TQImport3ODT {$ENDIF}
    {$IFDEF ADO}, TADO_QImport3Access {$ENDIF}]);

// *********************************
// *** Register property editors ***
// *********************************

  RegisterPropertyEditor(TypeInfo(string), TQImport3ASCII, 'FileName', TQASCIIFileNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3DBF, 'FileName', TQDBFFileNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3XLS, 'FileName', TQXLSFileNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3Wizard, 'FileName', TQWizardFileNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3, 'About', TQImportAboutProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3, 'Version', TQImportVersionProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3Wizard, 'About', TQImportAboutProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3Wizard, 'Version', TQImportVersionProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3Wizard, 'TemplateFileName', TQTemplateFileNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImportFieldFormat, 'FieldName', TQFieldNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TQImport3XML, 'FileName', TQXMLFileNameProperty);
{$IFDEF HTML}
  RegisterPropertyEditor(TypeInfo(string), TQImport3HTML, 'FileName', TQHTMLFileNameProperty);
{$ENDIF}
{$IFDEF XMLDOC}
  RegisterPropertyEditor(TypeInfo(string), TQImport3XMLDoc, 'FileName', TQXMLDocFileNameProperty);
{$ENDIF}
{$IFDEF XLSX}
  RegisterPropertyEditor(TypeInfo(string), TQImport3Xlsx, 'FileName', TQXlsxFileNameProperty);
{$ENDIF}
{$IFDEF DOCX}
  RegisterPropertyEditor(TypeInfo(string), TQImport3Docx, 'FileName', TQDocxFileNameProperty);
{$ENDIF}
{$IFDEF ODS}
  RegisterPropertyEditor(TypeInfo(string), TQImport3ODS, 'FileName', TQODSFileNameProperty);
{$ENDIF}
{$IFDEF ODT}
  RegisterPropertyEditor(TypeInfo(string), TQImport3ODT, 'FileName', TQODTFileNameProperty);
{$ENDIF}
{$IFDEF ADO}
  RegisterPropertyEditor(TypeInfo(string), TADO_QImport3Access, 'FileName', TQAccessFileNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TADO_QImport3Access, 'TableName', TQAccessTableNameProperty);
{$ENDIF}

// *********************************
// *** Register component editors ***
// *********************************

  RegisterComponentEditor(TQImport3Wizard, TQImportWizardEditor);
  RegisterComponentEditor(TQImport3XLS, TQImportXLSEditor);
  RegisterComponentEditor(TQImport3DataSet, TQImportDataSetEditor);
  RegisterComponentEditor(TQImport3DBF, TQImportDBFEditor);
  RegisterComponentEditor(TQImport3XML, TQImportXMLEditor);
  RegisterComponentEditor(TQImport3ASCII, TQImportASCIIEditor);
{$IFDEF HTML}
  RegisterComponentEditor(TQImport3HTML, TQImportHTMLEditor);
{$ENDIF}
{$IFDEF XMLDOC}
  RegisterComponentEditor(TQImport3XMLDoc, TQImportXMLDocEditor);
{$ENDIF}
{$IFDEF XLSX}
  RegisterComponentEditor(TQImport3Xlsx, TQImportXlsxEditor);
{$ENDIF}
{$IFDEF DOCX}
  RegisterComponentEditor(TQImport3Docx, TQImportDocxEditor);
{$ENDIF}
{$IFDEF ODS}
  RegisterComponentEditor(TQImport3ODS, TQImportODSEditor);
{$ENDIF}
{$IFDEF ODT}
  RegisterComponentEditor(TQImport3ODT, TQImportODTEditor);
{$ENDIF}
{$IFDEF SPLASH}
  RegisterWithSplashScreen;
{$ENDIF}
end;

{ TQFileNameProperty }

procedure TQFileNameProperty.Edit;
var
  OD: TOpenDialog;
begin
  OD := TOpenDialog.Create(nil);
  try
    OD.DefaultExt := GetDefaultExt;
    OD.Filter := GetFilter;
    OD.FileName := GetStrValue;
    if OD.Execute then SetStrValue(OD.FileName);
  finally
    OD.Free;
  end;
end;

function TQFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

{ TQASCIIFileNameProperty }

function TQASCIIFileNameProperty.GetDefaultExt: string;
begin
  Result := 'txt';
end;

function TQASCIIFileNameProperty.GetFilter: string;
begin
  Result := QImportLoadStr(QIF_ASCII);
end;

{ TQDBFFileNameProperty }

function TQDBFFileNameProperty.GetDefaultExt: string;
begin
  Result := 'dbf';
end;

function TQDBFFileNameProperty.GetFilter: string;
begin
  Result := QImportLoadStr(QIF_DBF);
end;

{ TQHTMLFileNameProperty }

{$IFDEF HTML}
function TQHTMLFileNameProperty.GetDefaultExt: string;
begin
  Result := 'html';
end;

function TQHTMLFileNameProperty.GetFilter: string;
begin
  Result := 'HTML files (*.htm, *.html)|*.htm; *.html';
end;
{$ENDIF}

{ TQXMLFileNameProperty }

function TQXMLFileNameProperty.GetDefaultExt: string;
begin
  Result := 'xml';
end;

function TQXMLFileNameProperty.GetFilter: string;
begin
  Result := QImportLoadStr(QIF_XML);
end;

{ TQXMLDocFileNameProperty }

{$IFDEF XMLDOC}
function TQXMLDocFileNameProperty.GetDefaultExt: string;
begin
  Result := 'xml';
end;

function TQXMLDocFileNameProperty.GetFilter: string;
begin
  Result := QImportLoadStr(QIF_XML);
end;
{$ENDIF}

{ TQXLSFileNameProperty }

function TQXLSFileNameProperty.GetDefaultExt: string;
begin
  Result := 'xls';
end;

function TQXLSFileNameProperty.GetFilter: string;
begin
  Result := QImportLoadStr(QIF_XLS);
end;

{ TQTemplateFileNameProperty }

function TQTemplateFileNameProperty.GetDefaultExt: string;
begin
  Result := 'imp';
end;

function TQTemplateFileNameProperty.GetFilter: string;
begin
  Result := QImportLoadStr(QIF_TEMPLATE);
end;

{ TQWizardFileNameProperty }

function TQWizardFileNameProperty.GetDefaultExt: string;
begin
  Result := EmptyStr;
end;

function TQWizardFileNameProperty.GetFilter: string;
begin
  Result := QImportLoadStr(QIF_ALL);
end;

{ TQImportAboutProperty }

procedure TQImportAboutProperty.Edit;
begin
  ShowAboutForm;
end;

function TQImportAboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paReadOnly, paDialog];
end;

function TQImportAboutProperty.GetValue: string;
begin
  Result := QI_ABOUT;
end;

{ TQImportVersionProperty }

function TQImportVersionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paReadOnly];
end;

function TQImportVersionProperty.GetValue: string;
begin
  Result := QI_VERSION_NUMBER;
end;

{ TQImportDBFEditor }

function TQImportDBFEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

function TQImportDBFEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

procedure TQImportDBFEditor.ExecuteVerb(Index: integer);
begin
  case Index of
    0: RunQImportDBFEditor(Component as TQImport3DBF);
    1: if RunFormatsEditor(Component as TQImport3) then Designer.Modified;
  end;
end;

{ TQImportHTMLEditor }

{$IFDEF HTML}
function TQImportHTMLEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

function TQImportHTMLEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

procedure TQImportHTMLEditor.ExecuteVerb(Index: integer);
var
  NeedModify: boolean;
begin
  NeedModify := false;
  case Index of
    0: RunQImportHTMLEditor(Component as TQImport3HTML);
    1: NeedModify := RunFormatsEditor(Component as TQImport3);
  end;
  if NeedModify then Designer.Modified;
end;
{$ENDIF}

{ TQImportXMLEditor }

function TQImportXMLEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

function TQImportXMLEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

procedure TQImportXMLEditor.ExecuteVerb(Index: integer);
begin
  case Index of
    0: RunQImportXMLEditor(Component as TQImport3XML);
    1: if RunFormatsEditor(Component as TQImport3) then Designer.Modified;
  end;
end;

{ TQImportDataSetEditor }

function TQImportDataSetEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

function TQImportDataSetEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

procedure TQImportDataSetEditor.ExecuteVerb(Index: integer);
begin
  case Index of
    0: RunQImportDataSetEditor(Component as TQImport3DataSet);
    1: if RunFormatsEditor(Component as TQImport3) then Designer.Modified;
  end;
end;

{ TQImportASCIIEditor }

function TQImportASCIIEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

function TQImportASCIIEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

procedure TQImportASCIIEditor.ExecuteVerb(Index: integer);
var
  NeedModify: boolean;
begin
  NeedModify := false;
  case Index of
    0: if Component is TQImport3ASCII then
       begin
         if (Component as TQImport3ASCII).Comma = #0
           then NeedModify := RunQImportTXTEditor(Component as TQImport3ASCII)
           else NeedModify := RunQImportCSVEditor(Component as TQImport3ASCII);
       end;
    1: NeedModify := RunFormatsEditor(Component as TQImport3);
  end;
  if NeedModify then
    Designer.Modified;
end;

{ TQImportXLSEditor }

function TQImportXLSEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

function TQImportXLSEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

procedure TQImportXLSEditor.ExecuteVerb(Index: integer);
var
  NeedModify: boolean;
begin
  NeedModify := false;
  case Index of
    0: NeedModify := RunQImportXLSEditor(Component as TQImport3XLS);
    1: NeedModify := RunFormatsEditor(Component as TQImport3);
  end;
  if NeedModify then Designer.Modified;
end;

{ TQFieldNameProperty }

function TQFieldNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList]
end;

procedure TQFieldNameProperty.GetValues(Proc: TGetStrProc);
var
  WasInActive: Boolean;
  Import: TQImport3;
  Wizard: TQImport3Wizard;
  i: Integer;
  Component: TComponent;
  DataSet: TDataSet;
begin
  Import := nil;
  Wizard := nil;

  Component := (((GetComponent(0) as TQImportFieldFormat).Collection as
    TQImportFieldFormats).Holder);
  if Component is TQImport3 then
    Import := Component as TQImport3
  else if Component is TQImport3Wizard then
    Wizard := Component as TQImport3Wizard;

  if Assigned(Import) then
    DataSet := Import.DataSet
  else if Assigned(Wizard) then
    DataSet := Wizard.DataSet
  else
    DataSet := nil;

  if not Assigned(DataSet) then Exit;

  WasInActive :=  not Dataset.Active;
  if WasInActive then
  try
    Dataset.Open;
  except
    Exit;
  end;
  for I := 0 to DataSet.FieldCount - 1 do
  begin
    Proc(DataSet.Fields[I].FieldName);
  end;
  if WasInActive then
  try
    Dataset.Close;
  except
  end;
end;

{ TQImportWizardEditor }

procedure TQImportWizardEditor.ExecuteVerb(Index: integer);
begin
  if RunFormatsEditor(Component as TComponent{TQImport3Wizard}) then
    Designer.Modified;
end;

function TQImportWizardEditor.GetVerb(Index: integer): string;
begin
  Result := 'Field formats...'
end;

function TQImportWizardEditor.GetVerbCount: integer;
begin
  Result := 1;
end;

{ TQImportXMLDocEditor }

{$IFDEF XMLDOC}
function TQImportXMLDocEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

function TQImportXMLDocEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

procedure TQImportXMLDocEditor.ExecuteVerb(Index: integer);
begin
  case Index of
    0: RunQImportXMLDocEditor(Component as TQImport3XMLDoc);
    1: if RunFormatsEditor(Component as TQImport3) then Designer.Modified;
  end;
end;
{$ENDIF}

{$IFDEF ADO}
function TQAccessFileNameProperty.GetDefaultExt: string;
begin
  Result := 'mdb';
end;

function TQAccessFileNameProperty.GetFilter: string;
begin
  Result := QImportLoadStr(QIF_Access);
end;

{ TQAccessTableNameProperty }

function TQAccessTableNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TQAccessTableNameProperty.GetValues(Proc: TGetStrProc);
var
  Imp: TADO_QImport3Access;
  List: TStrings;
  i: integer;
begin
  Imp := GetComponent(0) as TADO_QImport3Access;
  List := TStringList.Create;
  try
    Imp.GetTableNames(List);
    for i := 0 to List.Count - 1 do Proc(List[i]);
  finally
    List.Free;
  end;
end;
{$ENDIF}

{ TQXlsxFileNameProperty }

{$IFDEF XLSX}
function TQXlsxFileNameProperty.GetDefaultExt: string;
begin
  Result := 'xlsx';
end;

function TQXlsxFileNameProperty.GetFilter: string;
begin
  Result := 'Microsoft Excel 2007 files (*.xlsx)|*.xlsx';
end;
{$ENDIF}

{ TQDocxFileNameProperty }

{$IFDEF DOCX}
function TQDocxFileNameProperty.GetDefaultExt: string;
begin
  Result := 'docx';
end;

function TQDocxFileNameProperty.GetFilter: string;
begin
  Result := 'Microsoft Word 2007 files (*.docx)|*.docx';
end;
{$ENDIF}

{ TQODSFileNameProperty }

{$IFDEF ODS}
function TQODSFileNameProperty.GetDefaultExt: string;
begin
  Result := 'ods';
end;

function TQODSFileNameProperty.GetFilter: string;
begin
  Result := 'Open Document Spreadsheet files (*.ods)|*.ods';
end;
{$ENDIF}

{ TQODTFileNameProperty }

{$IFDEF ODT}
function TQODTFileNameProperty.GetDefaultExt: string;
begin
  Result := 'odt';
end;

function TQODTFileNameProperty.GetFilter: string;
begin
  Result := 'Open Document Text files (*.odt)|*.odt';
end;
{$ENDIF}

{ TQImportXlsxEditor }

{$IFDEF XLSX}
procedure TQImportXlsxEditor.ExecuteVerb(Index: integer);
var
  NeedModify: boolean;
begin
  NeedModify := False;
  case Index of
    0: RunQImportXlsxEditor(Component as TQImport3Xlsx);
    1: NeedModify := RunFormatsEditor(Component as TQImport3);
  end;
  if NeedModify then Designer.Modified;
end;

function TQImportXlsxEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

function TQImportXlsxEditor.GetVerbCount: integer;
begin
  Result := 2;
end;
{$ENDIF}

{ TQImportDocxEditor }

{$IFDEF DOCX}
procedure TQImportDocxEditor.ExecuteVerb(Index: integer);
var
  NeedModify: boolean;
begin
  NeedModify := False;
  case Index of
    0: RunQImportDocxEditor(Component as TQImport3Docx);
    1: NeedModify := RunFormatsEditor(Component as TQImport3);
  end;
  if NeedModify then Designer.Modified;
end;

function TQImportDocxEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

function TQImportDocxEditor.GetVerbCount: integer;
begin
  Result := 2;
end;
{$ENDIF}

{ TQImportODSEditor }

{$IFDEF ODS}
procedure TQImportODSEditor.ExecuteVerb(Index: integer);
var
  NeedModify: boolean;
begin
  NeedModify := False;
  case Index of
    0: RunQImportODSEditor(Component as TQImport3ODS);
    1: NeedModify := RunFormatsEditor(Component as TQImport3);
  end;
  if NeedModify then Designer.Modified;
end;

function TQImportODSEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

function TQImportODSEditor.GetVerbCount: integer;
begin
  Result := 2;
end;
{$ENDIF}

{ TQImportODTEditor }

{$IFDEF ODT}
procedure TQImportODTEditor.ExecuteVerb(Index: integer);
var
  NeedModify: boolean;
begin
  NeedModify := False;
  case Index of
    0: RunQImportODTEditor(Component as TQImport3ODT);
    1: NeedModify := RunFormatsEditor(Component as TQImport3);
  end;
  if NeedModify then Designer.Modified;
end;

function TQImportODTEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Map...';
    1: Result := 'Field formats...';
  end;
end;

function TQImportODTEditor.GetVerbCount: integer;
begin
  Result := 2;
end;
{$ENDIF}

end.
