{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressGanttControl                                      }
{                                                                    }
{           Copyright (c) 2020-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSGANTTCONTROL AND ALL           }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxGanttControlGraphicExporters;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Windows, Generics.Defaults, Generics.Collections, Classes,
  dxCore, dxCoreClasses, dxXMLDoc, dxSmartImage,
  dxGanttControlCustomClasses,
  dxGanttControlExporter,
  dxGanttControlCustomDataModel,
  dxGanttControlDataModel,
  dxGanttControl;

type
  TdxGanttControlGraphicExporter = class abstract(TdxGanttControlExporter)
  protected
    function GetImageCodec: TdxSmartImageCodecClass; virtual; abstract;
    function ExportToImage(AControl: TdxCustomGanttControl): TdxCustomSmartImage;
  public
    procedure Export(const AStream: TStream; AControl: TdxGanttControlBase); override;
  end;

  { TdxGanttControlSVGExporter }

  TdxGanttControlSVGExporter = class(TdxGanttControlGraphicExporter)
  protected
    class function GetExtensions: TArray<string>; override;
    function GetImageCodec: TdxSmartImageCodecClass; override;
  end;

  { TdxGanttControlBMPExporter }

  TdxGanttControlBMPExporter = class(TdxGanttControlGraphicExporter)
  protected
    class function GetExtensions: TArray<string>; override;
    function GetImageCodec: TdxSmartImageCodecClass; override;
  end;

  { TdxGanttControlJPEGExporter }

  TdxGanttControlJPEGExporter = class(TdxGanttControlGraphicExporter)
  protected
    class function GetExtensions: TArray<string>; override;
    function GetImageCodec: TdxSmartImageCodecClass; override;
  end;

  { TdxGanttControlPNGExporter }

  TdxGanttControlPNGExporter = class(TdxGanttControlGraphicExporter)
  protected
    class function GetExtensions: TArray<string>; override;
    function GetImageCodec: TdxSmartImageCodecClass; override;
  end;

  { TdxGanttControlEMFExporter }

  TdxGanttControlEMFExporter = class(TdxGanttControlGraphicExporter)
  protected
    class function GetExtensions: TArray<string>; override;
    function GetImageCodec: TdxSmartImageCodecClass; override;
  end;

  { TdxGanttControlWMFExporter }

  TdxGanttControlWMFExporter = class(TdxGanttControlGraphicExporter)
  protected
    class function GetExtensions: TArray<string>; override;
    function GetImageCodec: TdxSmartImageCodecClass; override;
  end;

  { TdxGanttControlTIFFExporter }

  TdxGanttControlTIFFExporter = class(TdxGanttControlGraphicExporter)
  protected
    class function GetExtensions: TArray<string>; override;
    function GetImageCodec: TdxSmartImageCodecClass; override;
  end;

  { TdxGanttControlGIFExporter }

  TdxGanttControlGIFExporter = class(TdxGanttControlGraphicExporter)
  protected
    class function GetExtensions: TArray<string>; override;
    function GetImageCodec: TdxSmartImageCodecClass; override;
  end;

implementation

uses
  Graphics, Math, RTLConsts,
  dxTypeHelpers, cxCustomCanvas, cxLookAndFeelPainters, cxLookAndFeels, dxSVGCanvas, cxGeometry,
  dxSVGImage, dxGDIPlusClasses,
  dxGanttControlStrs,
  dxGanttControlUtils,
  dxGanttControlViewChart,
  dxGanttControlViewResourceSheet,
  dxGanttControlViewTimeline,
  dxGanttControlSplitter,
  dxGanttControlCustomView,
  dxGanttControlTasks,
  dxGanttControlCustomSheet;

const
  dxThisUnitName = 'dxGanttControlGraphicExporters';

type
  TdxGanttControlChartViewAccess = class(TdxGanttControlChartView);
  TdxGanttControlCustomItemViewInfoAccess = class(TdxGanttControlCustomItemViewInfo);
  TdxCustomGanttControlAccess = class(TdxCustomGanttControl);
  TdxGanttControlViewChartAreaHeaderViewInfoAccess = class(TdxGanttControlViewChartAreaHeaderViewInfo);

  { TExportSVGNoDataToDisplayViewInfo }

  TExportSVGNoDataToDisplayViewInfo = class(TdxGanttControlCustomOwnedItemViewInfo)
  strict private
    FTextLayout: TcxCanvasBasedTextLayout;
  protected
    function CalculateSize: TSize; override;
    procedure DoDraw; override;
  public
    constructor Create(AOwner: TdxGanttControlCustomItemViewInfo); override;
    destructor Destroy; override;
    procedure Calculate(const R: TRect); override;
  end;

  { TExportSVGSplitterViewInfo }

  TExportSVGSplitterViewInfo = class(TdxGanttControlViewChartSplitterViewInfo)
  protected
    function CalculateSize: TSize; override;
    procedure DoDraw; override;
  end;

  { TExportSVGViewChartAreaViewInfo }

  TExportSVGViewChartAreaViewInfo = class(TdxGanttControlViewChartAreaViewInfo)
  protected
    function CalculateClientRect: TRect; override;
    procedure CalculateScrollBars; override;
    function CalculateSize: TSize; override;
    procedure DrawSizeGrip; override;
    function GetFocusedRowIndex: Integer; override;
    procedure UpdateCachedValues; override;
  end;

  { TExportSVGViewChartSheetViewInfo }

  TExportSVGViewChartSheetViewInfo = class(TdxGanttControlViewChartSheetViewInfo)
  protected
    FCachedSize: TSize;
    function AreExpandButtonsVisible: Boolean; override;
    function CalculateClientRect: TRect; override;
    procedure CalculateScrollBars; override;
    procedure DrawSizeGrip; override;
    function CalculateSize: TSize; override;
    function GetFocusedCell: TPoint; override;
    function IsTouchModeEnabled: Boolean; override;
    procedure UpdateCachedValues; override;
  end;

  { TExportSVGViewChartDataProvider }

  TExportSVGViewChartDataProvider = class(TdxGanttControlChartViewDataProvider);

  { TExportSVGViewChartViewInfo }

  TExportSVGViewChartViewInfo = class(TdxGanttControlViewChartViewInfo)
  strict private
    FDataProvider: TExportSVGViewChartDataProvider;
  protected
    function CreateChartAreaViewInfo: TdxGanttControlViewChartAreaViewInfo; override;
    function CreateSheetViewInfo: TdxGanttControlViewChartSheetViewInfo; override;
    function CreateSplitterViewInfo: TdxGanttControlViewChartSplitterViewInfo; override;

    function CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect; override;
    function CalculateSize: TSize; override;
    function IsSheetVisible: Boolean; override;

    property DataProvider: TExportSVGViewChartDataProvider read FDataProvider;
  public
    constructor Create(AOwner: TdxGanttControlCustomItemViewInfo; AView: TdxGanttControlCustomView); override;
    destructor Destroy; override;
    procedure CalculateLayout; override;
  end;

  { TExportSVGResourceSheetViewInfo }

  TExportSVGResourceSheetViewInfo = class(TdxGanttControlResourceSheetViewInfo)
  protected
    FCachedSize: TSize;
    function AreExpandButtonsVisible: Boolean; override;
    function CalculateClientRect: TRect; override;
    procedure CalculateScrollBars; override;
    procedure DrawSizeGrip; override;
    function CalculateSize: TSize; override;
    function GetFocusedCell: TPoint; override;
    function IsTouchModeEnabled: Boolean; override;
    procedure UpdateCachedValues; override;
  end;

  { TExportSVGViewResourceSheetViewInfo }

  TExportSVGViewResourceSheetViewInfo = class(TdxGanttControlViewResourceSheetViewInfo)
  protected
    function CalculateSize: TSize; override;
    function CreateInnerViewInfo: TdxGanttControlResourceSheetViewInfo; override;
  public
    procedure CalculateLayout; override;
  end;

  { TExportSVGViewTimelineViewInfo }

  TExportSVGViewTimelineViewInfo = class(TdxGanttControlViewTimelineViewInfo)
  strict private
    FCachedSize: TSize;
  protected
    function CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect; override;
    function CalculateSize: TSize; override;
    function CanCalculateTaskViewInfos: Boolean; override;
    procedure DoDraw; override;
  public
    procedure CalculateLayout; override;
  end;

  { TExportSVGViewInfo }

  TExportSVGViewInfo = class(TdxGanttControlCustomViewInfo)
  strict private
    FCanvasCache: TdxGanttControlCanvasCustomCache;
    FControl: TdxCustomGanttControl;
    FScaleFactor: TdxScaleFactor;
    function GetCanvas: TdxSVGCanvas; inline;
  protected
    function CalculateSize: TSize; override;
    function GetCanvasCache: TdxGanttControlCanvasCustomCache; override;
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter; override;
    function GetScaleFactor: TdxScaleFactor; override;
  public
    constructor Create(AControl: TdxCustomGanttControl); reintroduce;
    destructor Destroy; override;

    procedure Calculate; reintroduce;
    procedure CalculateLayout; override;

    procedure SaveToStream(AStream: TStream);

    property Canvas: TdxSVGCanvas read GetCanvas;
    property Control: TdxCustomGanttControl read FControl;
  end;

  { TExportSVGCanvasCache }

  TExportSVGCanvasCache = class(TdxGanttControlCanvasCustomCache)
  strict private
    FCanvas: TdxSVGCanvas;
    FViewInfo: TExportSVGViewInfo;
  protected
    function GetCanvas: TcxCustomCanvas; override;
    function GetLookAndFeel: TcxLookAndFeel; override;
  public
    constructor Create(AViewInfo: TExportSVGViewInfo);
    destructor Destroy; override;
    function GetBaseFont: TFont; override;
  end;

{ TExportSVGNoDataToDisplayViewInfo }

constructor TExportSVGNoDataToDisplayViewInfo.Create(
  AOwner: TdxGanttControlCustomItemViewInfo);
begin
  inherited Create(AOwner);
  FTextLayout := Canvas.CreateTextLayout;
  FTextLayout.SetText(cxGetResourceString(@sdxGanttControlNoDataInfoText));
  FTextLayout.SetColor(LookAndFeelPainter.GridLikeControlContentTextColor);
  FTextLayout.SetFont(CanvasCache.GetBaseFont);
end;

destructor TExportSVGNoDataToDisplayViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited Destroy;
end;

procedure TExportSVGNoDataToDisplayViewInfo.Calculate(const R: TRect);
begin
  inherited Calculate(R);
  FTextLayout.SetLayoutConstraints(Bounds);
  FTextLayout.MeasureSize;
end;

function TExportSVGNoDataToDisplayViewInfo.CalculateSize: TSize;
begin
  FTextLayout.SetLayoutConstraints(MaxInt, MaxInt);
  Result := FTextLayout.MeasureSize;
end;

procedure TExportSVGNoDataToDisplayViewInfo.DoDraw;
begin
  Canvas.FillRect(Bounds, LookAndFeelPainter.DefaultContentColor);
  FTextLayout.Draw(Bounds);
end;

{ TExportSVGSplitterViewInfo }

function TExportSVGSplitterViewInfo.CalculateSize: TSize;
begin
  Result := TSize.Empty;
end;

procedure TExportSVGSplitterViewInfo.DoDraw;
begin
// do nothing
end;

{ TExportSVGViewChartAreaViewInfo }

function TExportSVGViewChartAreaViewInfo.CalculateClientRect: TRect;
begin
  Result := Bounds;
end;

procedure TExportSVGViewChartAreaViewInfo.CalculateScrollBars;
begin
// do nothing
end;

function TExportSVGViewChartAreaViewInfo.CalculateSize: TSize;
var
  AFinish, ADateTime: TDateTime;
  AHeaderViewInfo: TdxGanttControlViewChartAreaHeaderViewInfoAccess;
begin
  UpdateCachedValues;
  Result := TSize.Empty;
  AHeaderViewInfo := TdxGanttControlViewChartAreaHeaderViewInfoAccess(HeaderViewInfo);
  AFinish := AHeaderViewInfo.GetMajorDateTime(DataProvider.DataModel.Tasks[0].Finish);
  AFinish := AHeaderViewInfo.GetNextMajorDateTime(AFinish);
  ADateTime := FFirstVisibleDateTime;
  while ADateTime < AFinish do
  begin
    Result.cx := Result.cx + AHeaderViewInfo.CalculateMinorHeaderWidth;
    ADateTime := AHeaderViewInfo.GetNextMinorDateTime(ADateTime);
  end;
end;

procedure TExportSVGViewChartAreaViewInfo.DrawSizeGrip;
begin
// do nothing
end;

function TExportSVGViewChartAreaViewInfo.GetFocusedRowIndex: Integer;
begin
  Result := -1;
end;

procedure TExportSVGViewChartAreaViewInfo.UpdateCachedValues;
var
  AHeaderViewInfo: TdxGanttControlViewChartAreaHeaderViewInfoAccess;
begin
  inherited UpdateCachedValues;
  FFirstVisibleRowIndex := 0;
  AHeaderViewInfo := TdxGanttControlViewChartAreaHeaderViewInfoAccess(HeaderViewInfo);
  FFirstVisibleDateTime := AHeaderViewInfo.GetMajorDateTime(DataProvider.DataModel.Tasks[0].Start);
end;

{ TExportSVGViewChartSheetViewInfo }

function TExportSVGViewChartSheetViewInfo.AreExpandButtonsVisible: Boolean;
begin
  Result := False;
end;

function TExportSVGViewChartSheetViewInfo.CalculateClientRect: TRect;
begin
  Result := Bounds;
end;

procedure TExportSVGViewChartSheetViewInfo.CalculateScrollBars;
begin
// do nothing
end;

function TExportSVGViewChartSheetViewInfo.CalculateSize: TSize;
var
  I: Integer;
begin
  if not FCachedSize.IsZero then
    Exit(FCachedSize);
  FCachedSize.cx := Options.RowHeaderWidth;
  FCachedSize.cy := 0;
  for I := 0 to Options.Columns.Count - 1 do
    if Options.Columns[I].Visible then
      FCachedSize.cx := FCachedSize.cx + Options.Columns[I].Width;
  UpdateCachedValues;
  FCachedSize.cy := GetColumnHeaderHeight;
  for I := 0 to DataProvider.Count - 1 do
  begin
    with TdxGanttControlSheetDataRowViewInfo.Create(Self, I, DataProvider[I]) do
    try
      FCachedSize.cy := FCachedSize.cy + MeasureHeight;
    finally
      Free;
    end;
  end;
  Result := FCachedSize;
end;

procedure TExportSVGViewChartSheetViewInfo.DrawSizeGrip;
begin
// do nothing
end;

function TExportSVGViewChartSheetViewInfo.GetFocusedCell: TPoint;
begin
  Result := TPoint.Create(-1, -1);
end;

function TExportSVGViewChartSheetViewInfo.IsTouchModeEnabled: Boolean;
begin
  Result := False;
end;

procedure TExportSVGViewChartSheetViewInfo.UpdateCachedValues;
begin
  inherited UpdateCachedValues;
  FDataProvider := TExportSVGViewChartViewInfo(Owner).DataProvider;
  FFirstVisibleColumnIndex := 0;
  FFirstVisibleRowIndex := 0;
end;

{ TExportSVGViewChartViewInfo }

constructor TExportSVGViewChartViewInfo.Create(AOwner: TdxGanttControlCustomItemViewInfo; AView: TdxGanttControlCustomView);
begin
  inherited Create(AOwner, AView);
  FDataProvider := TExportSVGViewChartDataProvider.Create(View.Controller.Control);
  FDataProvider.Populate(True);
end;

destructor TExportSVGViewChartViewInfo.Destroy;
begin
  FreeAndNil(FDataProvider);
  inherited Destroy;
end;

function TExportSVGViewChartViewInfo.CalculateItemBounds(
  AItem: TdxGanttControlCustomItemViewInfo): TRect;
begin
  if AItem is TExportSVGNoDataToDisplayViewInfo then
    Result := TRect.CreateSize(TExportSVGNoDataToDisplayViewInfo(AItem).CalculateSize)
  else
    Result := inherited CalculateItemBounds(AItem);
end;

procedure TExportSVGViewChartViewInfo.CalculateLayout;
begin
  if DataProvider.Count = 0 then
    AddChild(TExportSVGNoDataToDisplayViewInfo.Create(Self))
  else
    inherited CalculateLayout;
end;

function TExportSVGViewChartViewInfo.CalculateSize: TSize;
var
  ASize: TSize;
begin
  if DataProvider.Count = 0 then
    Result := TdxGanttControlCustomItemViewInfoAccess(ViewInfos[0]).CalculateSize
  else
  begin
    Result := TdxGanttControlCustomItemViewInfoAccess(ChartAreaViewInfo).CalculateSize;
    if SheetViewInfo <> nil then
    begin
      ASize := TdxGanttControlCustomItemViewInfoAccess(SheetViewInfo).CalculateSize;
      Result.cx := ASize.cx + Result.cx + TdxGanttControlCustomItemViewInfoAccess(SplitterViewInfo).CalculateSize.cx;
      Result.cy := Max(Result.cy, ASize.cy);
    end;
  end;
end;

function TExportSVGViewChartViewInfo.CreateChartAreaViewInfo: TdxGanttControlViewChartAreaViewInfo;
begin
  Result := TExportSVGViewChartAreaViewInfo.Create(Self);
end;

function TExportSVGViewChartViewInfo.CreateSheetViewInfo: TdxGanttControlViewChartSheetViewInfo;
begin
  Result := TExportSVGViewChartSheetViewInfo.Create(Self, View.OptionsSheet);
end;

function TExportSVGViewChartViewInfo.CreateSplitterViewInfo: TdxGanttControlViewChartSplitterViewInfo;
begin
  Result := TExportSVGSplitterViewInfo.Create(Self, TdxGanttControlChartViewAccess(View).OptionsSplitter);
end;

function TExportSVGViewChartViewInfo.IsSheetVisible: Boolean;
begin
  Result := True;
end;

{ TExportSVGResourceSheetViewInfo }

function TExportSVGResourceSheetViewInfo.AreExpandButtonsVisible: Boolean;
begin
  Result := False;
end;

function TExportSVGResourceSheetViewInfo.CalculateClientRect: TRect;
begin
  Result := Bounds;
end;

procedure TExportSVGResourceSheetViewInfo.CalculateScrollBars;
begin
// do nothing
end;

function TExportSVGResourceSheetViewInfo.CalculateSize: TSize;
var
  I: Integer;
begin
  if not FCachedSize.IsZero then
    Exit(FCachedSize);
  FCachedSize.cx := Options.RowHeaderWidth;
  FCachedSize.cy := 0;
  for I := 0 to Options.Columns.Count - 1 do
    if Options.Columns[I].Visible then
      FCachedSize.cx := FCachedSize.cx + Options.Columns[I].Width;
  UpdateCachedValues;
  FCachedSize.cy := GetColumnHeaderHeight;
  for I := 0 to DataProvider.Count - 1 do
  begin
    with TdxGanttControlSheetDataRowViewInfo.Create(Self, I, DataProvider[I]) do
    try
      FCachedSize.cy := FCachedSize.cy + MeasureHeight;
    finally
      Free;
    end;
  end;
  Result := FCachedSize;
end;

procedure TExportSVGResourceSheetViewInfo.DrawSizeGrip;
begin
// do nothing
end;

function TExportSVGResourceSheetViewInfo.GetFocusedCell: TPoint;
begin
  Result := TPoint.Create(-1, -1);
end;

function TExportSVGResourceSheetViewInfo.IsTouchModeEnabled: Boolean;
begin
  Result := False;
end;

procedure TExportSVGResourceSheetViewInfo.UpdateCachedValues;
begin
  inherited UpdateCachedValues;
  FFirstVisibleColumnIndex := 0;
  FFirstVisibleRowIndex := 0;
end;

{ TExportSVGViewResourceSheetViewInfo }

procedure TExportSVGViewResourceSheetViewInfo.CalculateLayout;
begin
  if DataProvider.Count = 0 then
    AddChild(TExportSVGNoDataToDisplayViewInfo.Create(Self))
  else
    inherited CalculateLayout;
end;

function TExportSVGViewResourceSheetViewInfo.CalculateSize: TSize;
begin
  if ViewInfoCount > 0 then
    Result := TdxGanttControlCustomItemViewInfoAccess(ViewInfos[0]).CalculateSize
  else
    Result := TSize.Empty;
end;

function TExportSVGViewResourceSheetViewInfo.CreateInnerViewInfo: TdxGanttControlResourceSheetViewInfo;
begin
  Result := TExportSVGResourceSheetViewInfo.Create(Self, View.OptionsSheet);
end;

{ TExportSVGViewTimelineViewInfo }

function TExportSVGViewTimelineViewInfo.CalculateItemBounds(
  AItem: TdxGanttControlCustomItemViewInfo): TRect;
begin
  if AItem is TExportSVGNoDataToDisplayViewInfo then
    Result := TRect.CreateSize(TExportSVGNoDataToDisplayViewInfo(AItem).CalculateSize)
  else
    Result := inherited CalculateItemBounds(AItem);
end;

procedure TExportSVGViewTimelineViewInfo.CalculateLayout;
begin
  if DataProvider.Count = 0 then
    AddChild(TExportSVGNoDataToDisplayViewInfo.Create(Self))
  else
    inherited CalculateLayout;
end;

function TExportSVGViewTimelineViewInfo.CalculateSize: TSize;
begin
  if FCachedSize.IsZero then
  begin
    if ViewInfoCount = 1 then
      FCachedSize := TdxGanttControlCustomItemViewInfoAccess(ViewInfos[0]).CalculateSize
    else
    begin
      inherited Calculate(TRect.CreateSize(TSize.Create(Controller.Control.ClientWidth, MaxInt)));
      FCachedSize := TSize.Create(ContentWidth, ContentHeight);
    end;
  end;
  Result := FCachedSize;
end;

function TExportSVGViewTimelineViewInfo.CanCalculateTaskViewInfos: Boolean;
begin
  Result := True;
end;

procedure TExportSVGViewTimelineViewInfo.DoDraw;
begin
  if ViewInfoCount = 1 then
    TdxGanttControlCustomItemViewInfoAccess(ViewInfos[0]).Draw
  else
    inherited DoDraw;
end;

{ TExportSVGViewInfo }

constructor TExportSVGViewInfo.Create(AControl: TdxCustomGanttControl);
begin
  inherited Create(nil);
  FControl := AControl;
  FCanvasCache := TExportSVGCanvasCache.Create(Self);
  FScaleFactor := TdxScaleFactor.Create;
end;

destructor TExportSVGViewInfo.Destroy;
begin
  FreeAndNil(FScaleFactor);
  FreeAndNil(FCanvasCache);
  inherited Destroy;
end;

function TExportSVGViewInfo.GetCanvas: TdxSVGCanvas;
begin
  Result := TdxSVGCanvas(inherited Canvas);
end;

function TExportSVGViewInfo.GetCanvasCache: TdxGanttControlCanvasCustomCache;
begin
  Result := FCanvasCache;
end;

function TExportSVGViewInfo.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := TdxCustomGanttControlAccess(FControl).LookAndFeelPainter;
end;

function TExportSVGViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := FScaleFactor;
end;

procedure TExportSVGViewInfo.Calculate;
var
  R: TRect;
begin
  CalculateLayout;
  R := TRect.CreateSize(CalculateSize);          
  Canvas.Initialize(R);
  inherited Calculate(R);
end;

procedure TExportSVGViewInfo.CalculateLayout;
begin
  if Control.ViewChart.Active then
    AddChild(TExportSVGViewChartViewInfo.Create(Self, FControl.ViewChart))
  else if Control.ViewResourceSheet.Active then
    AddChild(TExportSVGViewResourceSheetViewInfo.Create(Self, FControl.ViewResourceSheet))
  else if Control.ViewTimeline.Active then
    AddChild(TExportSVGViewTimelineViewInfo.Create(Self, FControl.ViewTimeline));
  inherited CalculateLayout;
end;

procedure TExportSVGViewInfo.SaveToStream(AStream: TStream);
begin
  Canvas.Export(AStream);
end;

function TExportSVGViewInfo.CalculateSize: TSize;
begin
  if ViewInfoCount > 0 then
    Result :=  TdxGanttControlCustomItemViewInfoAccess(ViewInfos[0]).CalculateSize
  else
    Result := TSize.Empty;
end;

{ TExportSVGCanvasCache }

constructor TExportSVGCanvasCache.Create(AViewInfo: TExportSVGViewInfo);
begin
  inherited Create;
  FViewInfo := AViewInfo;
  FCanvas := TdxSVGCanvas.Create;
end;

destructor TExportSVGCanvasCache.Destroy;
begin
  FreeAndNil(FCanvas);
  inherited Destroy;
end;

function TExportSVGCanvasCache.GetBaseFont: TFont;
begin
  Result := FViewInfo.Control.Font;
end;

function TExportSVGCanvasCache.GetCanvas: TcxCustomCanvas;
begin
  Result := FCanvas;
end;

function TExportSVGCanvasCache.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := FViewInfo.Control.LookAndFeel;
end;

{ TdxGanttControlGraphicExporter }

procedure TdxGanttControlGraphicExporter.Export(const AStream: TStream;
  AControl: TdxGanttControlBase);
var
  AImage: TdxCustomSmartImage;
begin
  AImage := ExportToImage(AControl as TdxCustomGanttControl);
  try
    AImage.SaveToStream(AStream);
  finally
    AImage.Free;
  end;
end;

function TdxGanttControlGraphicExporter.ExportToImage(AControl: TdxCustomGanttControl): TdxCustomSmartImage;
var
  AViewInfo: TExportSVGViewInfo;
  AStream: TMemoryStream;
begin
  Result := TdxCustomSmartImage.Create;
  AStream := TMemoryStream.Create;
  try
    AViewInfo := TExportSVGViewInfo.Create(AControl);
    try
      AViewInfo.Calculate;
      AViewInfo.Draw;
      AViewInfo.SaveToStream(AStream);
    finally
      AViewInfo.Free;
    end;
    AStream.Position := 0;
    Result.LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
  Result.ImageCodec := GetImageCodec;
end;

{ TdxGanttControlSVGExporter }

class function TdxGanttControlSVGExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.svg');
end;

function TdxGanttControlSVGExporter.GetImageCodec: TdxSmartImageCodecClass;
begin
  Result := TdxSVGImageCodec;
end;

{ TdxGanttControlBMPExporter }

class function TdxGanttControlBMPExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.bmp');
end;

function TdxGanttControlBMPExporter.GetImageCodec: TdxSmartImageCodecClass;
begin
  Result := TdxGPImageCodecBMP;
end;

{ TdxGanttControlJPEGExporter }

class function TdxGanttControlJPEGExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.jpg', '.jpeg');
end;

function TdxGanttControlJPEGExporter.GetImageCodec: TdxSmartImageCodecClass;
begin
  Result := TdxGPImageCodecJPEG;
end;

{ TdxGanttControlPNGExporter }

class function TdxGanttControlPNGExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.png');
end;

function TdxGanttControlPNGExporter.GetImageCodec: TdxSmartImageCodecClass;
begin
  Result := TdxGPImageCodecPNG;
end;

{ TdxGanttControlEMFExporter }

class function TdxGanttControlEMFExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.emf');
end;

function TdxGanttControlEMFExporter.GetImageCodec: TdxSmartImageCodecClass;
begin
  Result := TdxGPImageCodecEMF;
end;

{ TdxGanttControlWMFExporter }

class function TdxGanttControlWMFExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.wmf');
end;

function TdxGanttControlWMFExporter.GetImageCodec: TdxSmartImageCodecClass;
begin
  Result := TdxGPImageCodecWMF;
end;

{ TdxGanttControlTIFFExporter }

class function TdxGanttControlTIFFExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.tiff', '.tif');
end;

function TdxGanttControlTIFFExporter.GetImageCodec: TdxSmartImageCodecClass;
begin
  Result := TdxGPImageCodecTIFF;
end;

{ TdxGanttControlGIFExporter }

class function TdxGanttControlGIFExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.gif');
end;

function TdxGanttControlGIFExporter.GetImageCodec: TdxSmartImageCodecClass;
begin
  Result := TdxGPImageCodecGIF;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxGanttControlSVGExporter.Register;
  TdxGanttControlBMPExporter.Register;
  TdxGanttControlJPEGExporter.Register;
  TdxGanttControlPNGExporter.Register;
  TdxGanttControlEMFExporter.Register;
  TdxGanttControlWMFExporter.Register;
  TdxGanttControlTIFFExporter.Register;
  TdxGanttControlGIFExporter.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxGanttControlSVGExporter.Unregister;
  TdxGanttControlBMPExporter.Unregister;
  TdxGanttControlJPEGExporter.Unregister;
  TdxGanttControlPNGExporter.Unregister;
  TdxGanttControlEMFExporter.Unregister;
  TdxGanttControlWMFExporter.Unregister;
  TdxGanttControlTIFFExporter.Unregister;
  TdxGanttControlGIFExporter.Unregister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
