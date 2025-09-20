unit cxPivotGridChartConnectionFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxPivotBaseFormUnit, cxClasses, cxGraphics, cxCustomData,
  cxStyles, cxCustomPivotGrid, cxDBPivotGrid, cxControls,
  cxPivotGridChartConnection, cxGridCustomView, cxGridChartView,
  cxGridLevel, cxGrid, cxSplitter, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxGroupBox, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLabel,
  cxMemo, cxRichEdit, StdCtrls, cxLookAndFeels, dxLayoutContainer, dxLayoutcxEditAdapters, dxLayoutLookAndFeels,
  ActnList, dxLayoutControl, System.Actions, dxBarBuiltInMenu;

type
  TfmPivotGridChartConnection = class(TcxPivotGridDemoUnitForm)
    pgfProductName: TcxDBPivotGridField;
    pgfOrderDate: TcxDBPivotGridField;
    pgfQuantity: TcxDBPivotGridField;
    GridLevel: TcxGridLevel;
    Grid: TcxGrid;
    ChartView: TcxGridChartView;
    ChartConnection: TcxPivotGridChartConnection;
    cxGroupBox2: TcxGroupBox;
    Label1: TcxLabel;
    lblURL: TLabel;
    dxLayoutItem2: TdxLayoutItem;
    cbSourceData: TcxComboBox;
    dxLayoutItem3: TdxLayoutItem;
    cbSourceForCategorites: TcxComboBox;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutSplitterItem2: TdxLayoutSplitterItem;
    procedure cbSourceDataPropertiesChange(Sender: TObject);
    procedure lblURLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbSourceForCategoritesPropertiesChange(Sender: TObject);
  strict private
    procedure SetupChart;
  protected
    procedure DoShow; override;
  public
    destructor Destroy; override;
    class function GetID: Integer; override;
  end;

implementation

uses
  cxPivotDataModule, ShellAPI, dxThreading;

{$R *.dfm}

{ TcxPivotGridChartConnection }


destructor TfmPivotGridChartConnection.Destroy;
begin
  dxThreading.TdxUIThreadSyncService.Unsubscribe(Self);
  inherited Destroy;
end;

class function TfmPivotGridChartConnection.GetID: Integer;
begin
  Result := 24;
end;

procedure TfmPivotGridChartConnection.cbSourceDataPropertiesChange(
  Sender: TObject);
begin
  ChartConnection.SourceData := TcxPivotGridChartViewSourceData(cbSourceData.ItemIndex);
end;

procedure TfmPivotGridChartConnection.lblURLClick(Sender: TObject);
begin
  ShellExecute(Handle, PChar('OPEN'), PChar(lblURL.Caption), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TfmPivotGridChartConnection.SetupChart;
begin
  cbSourceData.ItemIndex := 1;
  DBPivotGrid.DataController.ClearSelection;
  DBPivotGrid.ViewData.Selection.Add(Rect(2, 0, 2, 3));
end;

procedure TfmPivotGridChartConnection.FormCreate(Sender: TObject);
begin
  ChartConnection.Refresh;
end;

procedure TfmPivotGridChartConnection.cbSourceForCategoritesPropertiesChange(
  Sender: TObject);
begin
  case cbSourceForCategorites.ItemIndex of
    1:
      ChartConnection.SourceForCategories := sfcRows;
    0:
      ChartConnection.SourceForCategories := sfcColumns;
  end;
end;

procedure TfmPivotGridChartConnection.DoShow;
begin
  inherited DoShow;
  dxThreading.TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
    procedure
    begin
      SetupChart;
    end);
end;

initialization
  TfmPivotGridChartConnection.Register;

end.
