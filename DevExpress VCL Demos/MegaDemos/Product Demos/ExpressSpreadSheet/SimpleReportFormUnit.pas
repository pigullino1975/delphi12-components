unit SimpleReportFormUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ReportDesignerBaseUnit, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Menus, dxLayoutControlAdapters, dxLayoutcxEditAdapters, dxLayoutContainer, cxClasses, StdCtrls, cxButtons, cxMemo,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, dxSpreadSheetCore, dxSpreadSheetReportDesigner, ExtCtrls, dxLayoutControl, DB,
  dxmdaset, cxRichEdit;

type
  TfrmSimpleReport = class(TdxSpreadSheetReportBaseForm)
    mdsOrderDetails: TdxMemData;
    dsOrderDetails: TDataSource;
  protected
    function GetDescription: string; override;
  public
    function GetCaption: string; override;
    class function GetID: Integer; override;
    procedure InitializeBook; override;
  end;

implementation

{$R *.dfm}

function TfrmSimpleReport.GetCaption: string;
begin
  Result := 'Simple Report';
end;

class function TfrmSimpleReport.GetID: Integer;
begin
  Result := 14;
end;

procedure TfrmSimpleReport.InitializeBook;
begin
  LoadDataset(mdsOrderDetails, 'Data\OrderDetails.mds');
  LoadFromFile('Data\SimpleReportTemplate.xlsx');
  LoadFilter(ReportDesigner.DataBinding.DataController, 'Data\OrderDetails.flt');
end;

function TfrmSimpleReport.GetDescription: string;
begin
  Result := 'In this demo, we use a spreadsheet to generate a detailed report for customer orders. A template with mail' +
  ' merge fields is bound to a database and opened in the Spreadsheet Control.';
end;

initialization
  TfrmSimpleReport.Register;

end.
