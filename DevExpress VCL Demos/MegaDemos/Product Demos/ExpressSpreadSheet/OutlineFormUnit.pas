unit OutlineFormUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, 
  dxSpreadSheetBaseFormUnit, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, 
  dxCore, dxCoreClasses, dxHashUtils, dxSpreadSheetCore, dxSpreadSheetCoreHistory, dxSpreadSheetPrinting, 
  dxSpreadSheetFormulas, dxSpreadSheetFunctions, dxSpreadSheetGraphics, dxSpreadSheetClasses, dxSpreadSheetTypes, 
  dxBarBuiltInMenu, cxContainer, cxEdit, Menus, dxLayoutContainer, dxLayoutcxEditAdapters, dxLayoutControlAdapters, 
  cxClasses, StdCtrls, cxButtons, cxMemo, cxTextEdit, cxMaskEdit, cxDropDownEdit, dxSpreadSheet, dxLayoutControl,
  dxSpreadSheetConditionalFormatting, dxSpreadSheetConditionalFormattingRules,
  dxSpreadSheetContainers, dxSpreadSheetHyperlinks, dxSpreadSheetUtils,
  ExtCtrls;

type
  TfrmOutline = class(TdxSpreadSheetDemoUnitForm)
  protected
    function GetDescription: string; override;
  public
    function GetCaption: string; override;
    class function GetID: Integer; override;
    procedure InitializeBook; override;
    function ShowExtendedMenu: Boolean; override;
  end;

var
  frmOutline: TfrmOutline;

implementation

{$R *.dfm}

{ TdxSpreadSheetDemoUnitForm1 }

function TfrmOutline.GetCaption: string;
begin
  Result := 'Outline';
end;

function TfrmOutline.GetDescription: string;
begin
  Result := 'The Spreadsheet Control allows you to group/summarize data and to create an outline to display summary' +
  ' rows, columns, and detail data for each group. This demo illustrates how to split worksheet data across separate' +
  ' groups and display summary rows/columns for each group.';
end;

class function TfrmOutline.GetID: Integer;
begin
  Result := 10;
end;

procedure TfrmOutline.InitializeBook;
begin
  inherited InitializeBook;
  LoadFromFile('Data\OutlineGrouping_template.xlsx');
end;

function TfrmOutline.ShowExtendedMenu: Boolean;
begin
  Result := True;
end;

initialization
  TfrmOutline.Register;

finalization


end.
