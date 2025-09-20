unit dxCustomSpreadSheetBaseFormUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSpreadSheetCore, dxSpreadSheetClasses,
  dxSpreadSheetTypes, dxSpreadSheet, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutContainer, dxLayoutControl, cxClasses;

const
  UM_FOCUSINGSPREADSHEET = WM_USER + 1;

var
  DemoFolder: string;

type

  { TdxCustomSpreadSheetDemoUnitForm }

  TdxCustomSpreadSheetDemoUnitFormClass = class of TdxCustomSpreadSheetDemoUnitForm;
  TdxCustomSpreadSheetDemoUnitForm = class(TFrame)
    lcCustomGroup_Root: TdxLayoutGroup;
    lcCustom: TdxLayoutControl;
    lgFeedback: TdxLayoutGroup;
    lliDescriprion: TdxLayoutLabeledItem;
  strict private
    FFileName: string;

    FOnSpreadSheetEdited: TdxSpreadSheetViewNotifyEvent;
    FOnSpreadSheetEditing: TdxSpreadSheetViewInplaceEditingEvent;
    FOnSpreadSheetHistoryChanged: TNotifyEvent;
    FOnSpreadSheetLayoutChanged: TNotifyEvent;
    FOnSpreadSheetSelectionChanged: TNotifyEvent;
  protected
    procedure FocusedSpreadSheet(var AMessage: TMessage); message UM_FOCUSINGSPREADSHEET;
    function GetDescription: string; virtual;
    procedure LoadFromFile(const AFileName: string);
    procedure InitializeControl; virtual;
    function GetSpreadSheet: TdxCustomSpreadSheet; virtual;
  public
    FSeparator: string;
    FShortDateFormat: string;

    class procedure Register;
    class function GetID: Integer; virtual;
    procedure FrameActivated; virtual;
    function GetCaption: string; virtual;
    procedure InitializeBook; virtual;
    procedure PrepareBook; virtual;
    function ShowExtendedMenu: Boolean; virtual;
    function UseDocumentPrintOptions: Boolean; virtual;

    property Caption: string read GetCaption;
    property SpreadSheet: TdxCustomSpreadSheet read GetSpreadSheet;
    property SpreadSheetFileName: string read FFileName write FFileName;

    property OnSpreadSheetEdited: TdxSpreadSheetViewNotifyEvent read FOnSpreadSheetEdited write FOnSpreadSheetEdited;
    property OnSpreadSheetEditing: TdxSpreadSheetViewInplaceEditingEvent read FOnSpreadSheetEditing write FOnSpreadSheetEditing;
    property OnSpreadSheetHistoryChanged: TNotifyEvent read FOnSpreadSheetHistoryChanged write FOnSpreadSheetHistoryChanged;
    property OnSpreadSheetLayoutChanged: TNotifyEvent read FOnSpreadSheetLayoutChanged write FOnSpreadSheetLayoutChanged;
    property OnSpreadSheetSelectionChanged: TNotifyEvent read FOnSpreadSheetSelectionChanged write FOnSpreadSheetSelectionChanged;
  end;

implementation

{$R *.dfm}

uses
  Main, dxCore;

{ TdxCustomSpreadSheetDemoUnitForm }

class procedure TdxCustomSpreadSheetDemoUnitForm.Register;
begin
  dxSpreadSheetRegisterDemoUnit(Self);
end;

function TdxCustomSpreadSheetDemoUnitForm.ShowExtendedMenu: Boolean;
begin
  Result := False;
end;

function TdxCustomSpreadSheetDemoUnitForm.GetCaption: string;
begin
  Result := '';
end;

class function TdxCustomSpreadSheetDemoUnitForm.GetID: Integer;
begin
  Result := 0;
end;

procedure TdxCustomSpreadSheetDemoUnitForm.FocusedSpreadSheet(var AMessage: TMessage);
begin
  SpreadSheet.SetFocus;
  dxCallNotify(OnSpreadSheetSelectionChanged, Self);
end;

function TdxCustomSpreadSheetDemoUnitForm.GetDescription: string;
begin
  Result := 'SpreadSheet Demo';
end;

procedure TdxCustomSpreadSheetDemoUnitForm.FrameActivated;
begin
  SpreadSheet.History.Lock;
  ShowHourglassCursor;
  try
    lliDescriprion.Caption := GetDescription;
    SpreadSheet.BeginUpdate;
    try
      PrepareBook;
    finally
      SpreadSheet.EndUpdate;
    end;
    FSeparator := SpreadSheet.FormulaController.FormatSettings.ListSeparator;
    FShortDateFormat := SpreadSheet.FormulaController.FormatSettings.Data.ShortDateFormat;
    InitializeControl;
    InitializeBook;
  finally
    HideHourglassCursor;
    SpreadSheet.History.Unlock;
  end;
  PostMessage(Handle, UM_FOCUSINGSPREADSHEET, 0, 0);
end;

function TdxCustomSpreadSheetDemoUnitForm.GetSpreadSheet: TdxCustomSpreadSheet;
begin
  Result := nil;
end;

procedure TdxCustomSpreadSheetDemoUnitForm.LoadFromFile(const AFileName: string);
begin
  SpreadSheet.LoadFromFile(DemoFolder + AFileName);
end;

procedure TdxCustomSpreadSheetDemoUnitForm.InitializeControl;
begin
  SpreadSheet.OptionsBehavior.History := True;
end;

procedure TdxCustomSpreadSheetDemoUnitForm.InitializeBook;
begin
  // do nothing
end;

procedure TdxCustomSpreadSheetDemoUnitForm.PrepareBook;
begin
  // do nothing
end;

function TdxCustomSpreadSheetDemoUnitForm.UseDocumentPrintOptions: Boolean;
begin
  Result := False;
end;

end.
