unit uChartFrameArea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  dxChartCustomFrameUnit, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxGeometry, cxClasses, cxVariants, dxCustomData, cxCustomCanvas, dxCoreGraphics, dxChartCore, dxChartData,
  dxChartLegend, dxChartSimpleDiagram, dxChartXYDiagram, dxChartXYSeriesLineView, dxChartXYSeriesAreaView,
  dxChartMarkers, dxChartXYSeriesBarView, dxChartDBData, dxLayoutContainer, dxLayoutcxEditAdapters,
  dxLayoutControlAdapters, dxCoreClasses, dxLayoutLookAndFeels, dxChartControl, cxSpinEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, dxLayoutControl, MainData, Data.DB;

type
  TdxChartFrameArea = class(TdxChartCustomFrame)
    cdArea: TdxChartXYDiagram;
    csAreaDevAVNorth: TdxChartXYSeries;
    csAreaDevAVSouth: TdxChartXYSeries;
  private
    { Private declarations }
  protected
    function GetDescription: string; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  dxFrames, FrameIDs;

{ TdxChartFrameArea }

function TdxChartFrameArea.GetDescription: string;
begin
  Result := 'This demo illustrates a Chart control that displays multiple simple Area series on an XY diagram.' +
    ' Use the "Options" pane to customize diagram and series appearance.' +
    ' The "Designer" button invokes the Chart Designer dialog where you can find more chart customization options';
end;

initialization

dxFrameManager.RegisterFrame(ChartControlAreaID, TdxChartFrameArea,
  ChartControlAreaName, ChartViewsGroupIndex,
  ChartViewsGroupIndex, -1);

end.
