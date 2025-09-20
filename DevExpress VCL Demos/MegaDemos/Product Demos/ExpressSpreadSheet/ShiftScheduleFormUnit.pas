unit ShiftScheduleFormUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSpreadSheetBaseFormUnit, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxCore,
  dxCoreClasses, dxHashUtils, dxSpreadSheetCore, dxSpreadSheetPrinting, dxSpreadSheetFormulas, dxSpreadSheetFunctions,
  dxSpreadSheetGraphics, dxSpreadSheetClasses, dxSpreadSheetTypes, dxBarBuiltInMenu, cxContainer, cxEdit, Menus,
  dxLayoutContainer, dxLayoutcxEditAdapters, dxLayoutControlAdapters, StdCtrls, cxButtons, cxMemo, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxSpreadSheet, dxLayoutControl,
  dxSpreadSheetCoreHistory, dxSpreadSheetConditionalFormatting,
  dxSpreadSheetConditionalFormattingRules, dxSpreadSheetContainers,
  dxSpreadSheetHyperlinks, dxSpreadSheetUtils, cxClasses, ExtCtrls;

type
  TfrmShiftSchedule = class(TdxSpreadSheetDemoUnitForm)
  protected
    function GetDescription: string; override;
  public
    function GetCaption: string; override;
    class function GetID: Integer; override;
    procedure InitializeBook; override;
    function ShowExtendedMenu: Boolean; override;
  end;

implementation

{$R *.dfm}

const
  ShiftSchedulePath: string = 'Data\ShiftSchedule.xlsx';

function TfrmShiftSchedule.GetCaption: string;
begin
  Result := 'Shift Schedule';
end;

function TfrmShiftSchedule.GetDescription: string;
begin
  Result := 'This demo illustrates how to use the Spreadsheet''s API to create a Shift Schedule spreadsheet template. ' +
  'The TOTAL column contains formulas for calculating the total number of work hours per shift for each employee.';
end;

class function TfrmShiftSchedule.GetID: Integer;
begin
  Result := 4;
end;

procedure TfrmShiftSchedule.InitializeBook;
begin
  inherited;
  LoadFromFile(ShiftSchedulePath);
end;

function TfrmShiftSchedule.ShowExtendedMenu: Boolean;
begin
  Result := True;
end;

initialization
  TfrmShiftSchedule.Register;

end.
