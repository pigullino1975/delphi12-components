unit RightToLeftLayoutFormUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, dxSpreadSheetBaseFormUnit,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxCore, dxCoreClasses, dxHashUtils, dxSpreadSheetCore,
  dxSpreadSheetCoreHistory, dxSpreadSheetPrinting, dxSpreadSheetFormulas, dxSpreadSheetFunctions, dxSpreadSheetGraphics,
  dxSpreadSheetClasses, dxSpreadSheetTypes, cxContainer, cxEdit, Menus, dxLayoutContainer, dxLayoutcxEditAdapters,
  dxLayoutControlAdapters, cxClasses, StdCtrls, cxButtons, cxMemo, cxTextEdit, cxMaskEdit, cxDropDownEdit, StdActns,
  dxSpreadSheet, dxLayoutControl, dxSpreadSheetConditionalFormatting, dxSpreadSheetConditionalFormattingRules,
  dxSpreadSheetContainers, dxSpreadSheetHyperlinks, dxSpreadSheetUtils, ExtCtrls, dxSpreadSheetCoreFormulas,
  dxSpreadSheetCoreStyles, dxSpreadSheetCoreStrs, dxSpreadSheetStyles, ExtActns, ActnList, cxSplitter,
  dxSpreadSheetFormulaBar, cxTrackBar, dxZoomTrackBar;

type
  { TfrmRightToLeftLayout }

  TfrmRightToLeftLayout = class(TdxSpreadSheetDemoUnitForm)
  protected
    function GetDescription: string; override;
  public
    function GetCaption: string; override;
    class function GetID: Integer; override;
    procedure InitializeBook; override;
    function ShowExtendedMenu: Boolean; override;
  end;

var
  frmRightToLeftLayout: TfrmRightToLeftLayout;

implementation

{$R *.dfm}

{ TfrmRightToLeftLayout }

function TfrmRightToLeftLayout.GetCaption: string;
begin
  Result := 'Right-to-Left Layout';
end;

function TfrmRightToLeftLayout.GetDescription: string;
begin
  Result := 'In this demo, you can switch between two worksheets that use Right-to-Left and Left-to-Right layout dir' +
  'ections. Click tabs to switch between the worksheets and modify their content to see how the Spreadsheet Control ' +
  'adapts its UI and content management capabilities in response.';
end;

class function TfrmRightToLeftLayout.GetID: Integer;
begin
  Result := 19;
end;

procedure TfrmRightToLeftLayout.InitializeBook;
begin
  inherited InitializeBook;
  LoadFromFile('Data\RightToLeftLayout.xlsx');
end;

function TfrmRightToLeftLayout.ShowExtendedMenu: Boolean;
begin
  Result := True;
end;

initialization
  TfrmRightToLeftLayout.Register;
end.
