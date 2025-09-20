{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCharts                                            }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCHARTS AND ALL ACCOMPANYING    }
{   VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.              }
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

unit dxChartCrosshair; // for internal use

{$I cxVer.inc}

interface

uses
  dxChartCore, RTLConsts, Math;

  function dxChartCreateCrosshairController(AChart: TdxChart): IdxChartCrosshairController; // for internal use

implementation

uses
  Generics.Collections, Windows, Graphics, Forms, SysUtils, Classes, Types,
  cxGeometry, dxGDIPlusClasses, dxCoreClasses, cxDrawTextUtils, cxGraphics, dxCore,
  dxDPIAwareUtils, cxScrollBar, cxControls, cxCustomCanvas, dxCoreGraphics,
  dxChartXYDiagram;

type
  TdxChartCrosshairAxisLabelViewInfo = class;
  TdxChartCrosshairLabelItemViewInfo = class;
  TdxChartCrosshairLabelViewInfo = class;
  TdxChartCrosshairLinesViewInfo = class;
  TdxChartCrosshairPointsViewInfo = class;
  TdxChartCrosshair = class;


  TdxChartCrosshairLabelItem = class //for internal use
  strict private
    FCaption: string;
    FLabelViewInfo: TdxChartCrosshairLabelViewInfo;
    FValue: TdxChartXYSeriesValueViewInfo;
    FViewInfo: TdxChartCrosshairLabelItemViewInfo;
  public
    constructor Create(ALabelViewInfo: TdxChartCrosshairLabelViewInfo);
    destructor Destroy; override;
    procedure Update(const AValue: TdxChartXYSeriesValueViewInfo);
    property Caption: string read FCaption;
    property LabelViewInfo: TdxChartCrosshairLabelViewInfo read FLabelViewInfo;
    property Value: TdxChartXYSeriesValueViewInfo read FValue;
    property ViewInfo: TdxChartCrosshairLabelItemViewInfo read FViewInfo;
  end;

  TdxChartCrosshairLabelItemViewInfo = class(TdxChartCustomItemViewInfo) //for internal use
  strict private
    FCaptionBounds: TdxRectF;
    FImageBounds: TdxRectF;
    FOwner: TdxChartCrosshairLabelItem;
    FTextLayout: TcxCanvasBasedTextLayout;
    function GetLabelViewInfo: TdxChartCrosshairLabelViewInfo;
  protected
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    property LabelViewInfo: TdxChartCrosshairLabelViewInfo read GetLabelViewInfo;
  public
    constructor Create(AOwner: TdxChartCrosshairLabelItem);
    destructor Destroy; override;
    procedure Offset(const ADistance: TdxPointF); override;
    procedure SetPosition(const APosition: TdxPointF);
    property Owner: TdxChartCrosshairLabelItem read FOwner;
  end;

  TdxChartCrosshairLabelViewData = class //for internal use
  strict private
    FItemCount: Integer;
    FItems: TdxFastObjectList;
    FViewInfo: TdxChartCrosshairLabelViewInfo;
  private
    function GetItems(AIndex: Integer): TdxChartCrosshairLabelItem;
  public
    constructor Create(AViewInfo: TdxChartCrosshairLabelViewInfo);
    destructor Destroy; override;
    procedure Prepare(AItemCount: Integer);
    procedure UpdateItem(AIndex: Integer; const ASeriesPoint: TdxChartXYSeriesValueViewInfo);
    property ItemCount: Integer read FItemCount;
    property Items[AIndex: Integer]: TdxChartCrosshairLabelItem read GetItems;
    property ViewInfo: TdxChartCrosshairLabelViewInfo read FViewInfo;
  end;

  TdxChartCrosshairLabelViewInfo = class(TdxChartVisualElementCustomViewInfo) //for internal use
  strict private
    FCrosshair: TdxChartCrosshair;
    FItems: TdxChartItemsViewInfoList;
    FViewData: TdxChartCrosshairLabelViewData;
    function GetAppearance: TdxChartCrosshairLabelAppearance; inline;
    function GetDiagram: TdxChartXYDiagram;
  private
    function GetDiagramViewInfo: TdxChartXYDiagramViewInfo;
  protected
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
  strict protected
    procedure DoRightToLeftConversion;
    property Appearance: TdxChartCrosshairLabelAppearance read GetAppearance;
    property Diagram: TdxChartXYDiagram read GetDiagram;
    property DiagramViewInfo: TdxChartXYDiagramViewInfo read GetDiagramViewInfo;
  public
    constructor Create(ACrosshair: TdxChartCrosshair; AAppearance: TdxChartVisualElementAppearance); reintroduce;
    destructor Destroy; override;
    procedure Offset(const ADistance: TdxPointF); override;
    procedure SetPosition(const APosition: TdxPointF);
    property ViewData: TdxChartCrosshairLabelViewData read FViewData;
  end;

  TdxChartCrosshair = class(TdxChartCustomItemViewData) //for internal use
  strict private
    FDiagramViewInfo: TdxChartXYDiagramViewInfo;
    FLabelViewInfo: TdxChartCrosshairLabelViewInfo;
    FLinesViewInfo: TdxChartCrosshairLinesViewInfo;
    FNearestPoints: TdxFastList;
    FMousePos: TPoint;
    FPointsViewInfo: TdxChartCrosshairPointsViewInfo;
    function GetDiagram: TdxChartXYDiagram;
    function GetScaleFactor: TdxScaleFactor;
    function GetSnappedPointCount: Integer;
    function GetSnappedPoints(AIndex: Integer): TdxChartXYSeriesValueViewInfo;
    function GetUseRightToLeftAlignment: Boolean;
  protected
    procedure DoCalculate; override;
    procedure MakeDirty; override;
  public
    constructor Create(const ADiagramViewInfo: TdxChartXYDiagramViewInfo);
    destructor Destroy; override;
    procedure Hide;
    procedure ShowAt(AMousePos: TPoint);

    property Diagram: TdxChartXYDiagram read GetDiagram;
    property DiagramViewInfo: TdxChartXYDiagramViewInfo read FDiagramViewInfo;
    property LabelViewInfo: TdxChartCrosshairLabelViewInfo read FLabelViewInfo;
    property LinesViewInfo: TdxChartCrosshairLinesViewInfo read FLinesViewInfo;
    property MousePos: TPoint read FMousePos;
    property PointsViewInfo: TdxChartCrosshairPointsViewInfo read FPointsViewInfo;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property SnappedPointCount: Integer read GetSnappedPointCount;
    property SnappedPoints[AIndex: Integer]: TdxChartXYSeriesValueViewInfo read GetSnappedPoints;
    property UseRightToLeftAlignment: Boolean read GetUseRightToLeftAlignment;
  end;

  TdxChartCrosshairLinesViewInfo = class(TdxChartCustomItemViewInfo) // for internal use
  strict private
    FAxisLabels: TdxChartItemsViewInfoList;
    FCrosshair: TdxChartCrosshair;
    FHorizontalLines: TList<Single>;
    FHorizontalPen: TcxCanvasBasedPen;
    FVerticalLines: TList<Single>;
    FVerticalPen: TcxCanvasBasedPen;
    function GetArgumentCoordinate(ACanvasPoint: TdxPointF): Single; inline;
    function GetValueCoordinate(ACanvasPoint: TdxPointF): Single; inline;
  protected
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    function NeedClipping: Boolean; override;
  public
    constructor Create(const ACrosshair: TdxChartCrosshair);
    destructor Destroy; override;
  end;

  TdxChartCrosshairController = class(TInterfacedObject, IdxChartCrosshairController)
  strict private
    FChart: TdxChart;
    FCrosshairs: TdxFastObjectList;
    FLabelViewInfos: TdxChartItemsViewInfoList;
    FLinesViewInfos: TdxChartItemsViewInfoList;
    FPointsViewInfos: TdxChartItemsViewInfoList;
    function GetCrosshair(ADiagram: TdxChartCustomDiagram): TdxChartCrosshair;
  protected
  // IdxChartCrosshairController
    procedure DiagramsChanged;
    function GetCrosshairViewInfos(ALayer: TdxChartCrosshairLayer): TdxChartItemsViewInfoList;
    procedure HideCrosshair(ADiagram: TdxChartCustomDiagram);
    procedure LayoutChanged;
    procedure OptionsChanged;
    procedure ShowCrosshair(ADiagram: TdxChartCustomDiagram; APosition: TdxPointF);
  public
    constructor Create(AChart: TdxChart);
    destructor Destroy; override;
  end;

  TdxChartCrosshairPointsViewInfo = class(TdxChartCustomItemViewInfo)
  strict private
    FCrosshair: TdxChartCrosshair;
  protected
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    function NeedClipping: Boolean; override;
  public
    constructor Create(const ACrosshair: TdxChartCrosshair);
  end;

  TdxChartCrosshairAxisLabelViewInfo = class(TdxChartVisualElementCustomViewInfo)
  strict private
    FAppearance: TdxChartCrosshairAxisLabelAppearance;
    FAxisValue: Variant;
    FAxisViewInfo: TdxChartAxisViewInfo;
    FCanvasValue: Single;
    FOptions: TdxChartCrosshairAxisLabels;
    FText: string;
    FTextBounds: TdxRectF;
    FTextLayout: TcxCanvasBasedTextLayout;
  protected
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    property Appearance: TdxChartCrosshairAxisLabelAppearance read FAppearance;
    property Options: TdxChartCrosshairAxisLabels read FOptions;
  public
    constructor Create(AAxisViewInfo: TdxChartAxisViewInfo; AAxisValue: Variant; ACanvasValue: Single); reintroduce;
    destructor Destroy; override;
  end;

  TdxChartAccess = class(TdxChart);
  TdxChartXYDiagramAccess = class(TdxChartXYDiagram);
  TdxChartXYDiagramViewInfoAccess = class(TdxChartXYDiagramViewInfo);
  TdxChartXYSeriesCustomViewAccess = class(TdxChartXYSeriesCustomView);
  TdxChartXYSeriesViewCustomViewInfoAccess = class(TdxChartXYSeriesViewCustomViewInfo);
  TdxChartVisualElementAppearanceAccess = class(TdxChartVisualElementAppearance);
  TdxChartCrosshairLabelAppearanceAccess = class(TdxChartCrosshairLabelAppearance);
  TdxChartCrosshairLineAppearanceAccess = class(TdxChartCrosshairLabelAppearance);
  TdxChartCustomAxisAccess = class(TdxChartCustomAxis);
  TdxChartCrosshairAxisLabelsAccess = class(TdxChartCrosshairAxisLabels);

function dxChartCreateCrosshairController(AChart: TdxChart): IdxChartCrosshairController;
begin
  Result := TdxChartCrosshairController.Create(AChart);
end;

{ TdxChartCrosshairLabelViewData }

constructor TdxChartCrosshairLabelViewData.Create(AViewInfo: TdxChartCrosshairLabelViewInfo);
begin
  inherited Create;
  FItems := TdxFastObjectList.Create(True, 8);
  FViewInfo := AViewInfo;
end;

destructor TdxChartCrosshairLabelViewData.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

function TdxChartCrosshairLabelViewData.GetItems(AIndex: Integer): TdxChartCrosshairLabelItem;
begin
  Result := TdxChartCrosshairLabelItem(FItems[AIndex]);
end;

procedure TdxChartCrosshairLabelViewData.Prepare(AItemCount: Integer);
var
  I: Integer;
begin
  for I := FItemCount + 1 to AItemCount do
    FItems.Add(TdxChartCrosshairLabelItem.Create(ViewInfo));
  FItemCount := AItemCount;
  for I := 0 to FItemCount - 1 do
    Items[I].ViewInfo.Dirty := True;
end;

procedure TdxChartCrosshairLabelViewData.UpdateItem(AIndex: Integer; const ASeriesPoint: TdxChartXYSeriesValueViewInfo);
begin
  Items[AIndex].Update(ASeriesPoint);
end;


{ TdxChartCrosshairLabelViewInfo }

constructor TdxChartCrosshairLabelViewInfo.Create(ACrosshair: TdxChartCrosshair; AAppearance: TdxChartVisualElementAppearance);
begin
  inherited Create(AAppearance);
  FCrosshair := ACrosshair;
  FViewData := TdxChartCrosshairLabelViewData.Create(Self);
  FItems := TdxChartItemsViewInfoList.Create(False);
end;

destructor TdxChartCrosshairLabelViewInfo.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FViewData);
  inherited Destroy;
end;

procedure TdxChartCrosshairLabelViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);

  procedure AdjustPosition;
  const
    DistanceFromMouse = 12;
  var
    ADistanceFromMouse: Integer;
    APosition: TdxPointF;
    AAvailableArea: TdxRectF;
    AScrollBarSize: TSize;
  begin
    AScrollBarSize := GetHybridScrollBarSize(FCrosshair.ScaleFactor, True);
    AAvailableArea := FCrosshair.DiagramViewInfo.PlotArea;
    if DiagramViewInfo.AxisYViewInfo.IsScrollBarEnabled and not Diagram.Rotated or
       DiagramViewInfo.AxisXViewInfo.IsScrollBarEnabled and Diagram.Rotated then
    begin
      AAvailableArea.Right := AAvailableArea.Right - AScrollBarSize.cx;
      if UseRightToLeftAlignment then
        AAvailableArea := TdxRightToLeftLayoutConverter.ConvertRect(AAvailableArea, DiagramViewInfo.PlotArea);
    end;
    if DiagramViewInfo.AxisXViewInfo.IsScrollBarEnabled and not Diagram.Rotated or
       DiagramViewInfo.AxisYViewInfo.IsScrollBarEnabled and Diagram.Rotated then
      AAvailableArea.Bottom := AAvailableArea.Bottom - AScrollBarSize.cy;

    ADistanceFromMouse := FCrosshair.ScaleFactor.Apply(DistanceFromMouse);

    if AAvailableArea.Width >= Bounds.Width + ADistanceFromMouse * 2 then
    begin
      APosition.X := FCrosshair.MousePos.X + ADistanceFromMouse;
      if APosition.X + Bounds.Width > AAvailableArea.Right then
      begin
        APosition.X := FCrosshair.MousePos.X - ADistanceFromMouse - Bounds.Width;
        if APosition.X < AAvailableArea.Left then
          APosition.X := IfThen(FCrosshair.MousePos.X - AAvailableArea.Left > AAvailableArea.Right - FCrosshair.MousePos.X, AAvailableArea.Left, AAvailableArea.Right - Bounds.Width);
      end;
    end
    else
      APosition.X := IfThen(UseRightToLeftAlignment, AAvailableArea.Right - Bounds.Width, AAvailableArea.Left);

    if AAvailableArea.Height >= Bounds.Height + ADistanceFromMouse * 2 then
    begin
      APosition.Y := FCrosshair.MousePos.Y - ADistanceFromMouse - Bounds.Height;
      if APosition.Y < AAvailableArea.Top then
      begin
        APosition.Y := FCrosshair.MousePos.Y + ADistanceFromMouse;
        if APosition.Y + Bounds.Height >= AAvailableArea.Bottom then
          APosition.Y := IfThen(FCrosshair.MousePos.Y - AAvailableArea.Top > AAvailableArea.Bottom - FCrosshair.MousePos.Y, AAvailableArea.Top, AAvailableArea.Bottom - Bounds.Height);
      end;
    end
    else
      APosition.Y := AAvailableArea.Top;

    SetPosition(APosition);
  end;

var
  ARowCount: Integer;
  I: Integer;
  AItemBounds: TdxRectF;
  AItemViewInfo: TdxChartCrosshairLabelItemViewInfo;
  AMaxItemWidth: Single;
  R: TdxRectF;
  AAppearance: TdxChartCrosshairLabelAppearanceAccess;
begin
  FCrosshair.Calculate;
  if not Visible then
    Exit;

  AMaxItemWidth := 0;
  AItemViewInfo := nil;
  AAppearance := TdxChartCrosshairLabelAppearanceAccess(Appearance);

  FItems.Clear;
  ARowCount := ViewData.ItemCount;
  if ARowCount = 0 then
    Exit;

  AItemBounds := ContentBounds;
  for I := 0 to ARowCount - 1 do
  begin
    AItemViewInfo := ViewData.Items[I].ViewInfo;
    FItems.Add(AItemViewInfo);
    AItemViewInfo.Visible := True;
    AItemViewInfo.SetBounds(AItemBounds, VisibleBounds);
    AItemViewInfo.Calculate(ACanvas);
    AMaxItemWidth := Max(AMaxItemWidth, AItemViewInfo.Bounds.Width);
    AItemBounds.Top := AItemViewInfo.Bounds.Bottom + AAppearance.ItemIndent;
    AItemBounds.Bottom := ContentBounds.Bottom;
  end;
  R := Bounds;
  R.Right := R.Left + AMaxItemWidth + (R.Width - ContentBounds.Width);
  R.Bottom := AItemViewInfo.Bounds.Bottom + (R.Bottom - ContentBounds.Bottom);
  UpdateBounds(R);
  if AAppearance.UseRightToLeftAlignment then
    DoRightToLeftConversion;
  AdjustPosition;
end;

procedure TdxChartCrosshairLabelViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  inherited DoDraw(ACanvas);
  FItems.Draw(ACanvas);
end;

procedure TdxChartCrosshairLabelViewInfo.DoRightToLeftConversion;
var
  ARowCount: Integer;
  I: Integer;
  AItemViewInfo: TdxChartCrosshairLabelItemViewInfo;
  ANewBounds: TdxRectF;
begin
  ARowCount := ViewData.ItemCount;
  for I := 0 to ARowCount - 1 do
  begin
    AItemViewInfo := ViewData.Items[I].ViewInfo;
    ANewBounds := TdxRightToLeftLayoutConverter.ConvertRect(AItemViewInfo.Bounds, ContentBounds);
    AItemViewInfo.SetPosition(ANewBounds.TopLeft);
  end;
end;

procedure TdxChartCrosshairLabelViewInfo.Offset(const ADistance: TdxPointF);
var
  I: Integer;
begin
  inherited Offset(ADistance);
  for I := 0 to FItems.Count - 1 do
    FItems[I].Offset(ADistance);
end;

procedure TdxChartCrosshairLabelViewInfo.SetPosition(const APosition: TdxPointF);
begin
  Offset(TdxPointF.Create(APosition.X - Bounds.Left, APosition.Y - Bounds.Top));
end;

function TdxChartCrosshairLabelViewInfo.GetAppearance: TdxChartCrosshairLabelAppearance;
begin
  Result := TdxChartCrosshairLabelAppearance(inherited Appearance);
end;

function TdxChartCrosshairLabelViewInfo.GetDiagram: TdxChartXYDiagram;
begin
  Result := FCrosshair.Diagram;
end;

function TdxChartCrosshairLabelViewInfo.GetDiagramViewInfo: TdxChartXYDiagramViewInfo;
begin
  Result := FCrosshair.DiagramViewInfo;
end;

{ TdxChartCrosshair }

constructor TdxChartCrosshair.Create(const ADiagramViewInfo: TdxChartXYDiagramViewInfo);
begin
  inherited Create;
  FDiagramViewInfo := ADiagramViewInfo;
  FNearestPoints := TdxFastList.Create;
  FLabelViewInfo := TdxChartCrosshairLabelViewInfo.Create(Self, TdxChartXYDiagramAccess(ADiagramViewInfo.Diagram).Chart.ToolTips.CrosshairOptions.Labels.Appearance);
  FLinesViewInfo := TdxChartCrosshairLinesViewInfo.Create(Self);
  FPointsViewInfo := TdxChartCrosshairPointsViewInfo.Create(Self);
end;

destructor TdxChartCrosshair.Destroy;
begin
  FreeAndNil(FPointsViewInfo);
  FreeAndNil(FLinesViewInfo);
  FreeAndNil(FLabelViewInfo);
  FreeAndNil(FNearestPoints);
  inherited Destroy;
end;


procedure TdxChartCrosshair.Hide;
begin
  FLabelViewInfo.Visible := False;
  FLinesViewInfo.Visible := False;
  FPointsViewInfo.Visible := False;
  TdxChartXYDiagramAccess(Diagram).Invalidate;
end;

procedure TdxChartCrosshair.MakeDirty;
begin
  inherited MakeDirty;
  FLabelViewInfo.Dirty := True;
  FLinesViewInfo.Dirty := True;
  FPointsViewInfo.Dirty := True;
end;

procedure TdxChartCrosshair.ShowAt(AMousePos: TPoint);
var
  APlotAreaBounds: TdxRectF;
begin
  APlotAreaBounds := DiagramViewInfo.PlotAreaViewInfo.Bounds;
  FMousePos := AMousePos;
  MakeDirty;
  FLabelViewInfo.Visible := True;
  FLabelViewInfo.SetBounds(APlotAreaBounds, APlotAreaBounds);
  FLabelViewInfo.Dirty := True;
  FLinesViewInfo.Visible := True;
  FLinesViewInfo.SetBounds(DiagramViewInfo.Bounds, DiagramViewInfo.Bounds);
  FLinesViewInfo.Dirty := True;
  FPointsViewInfo.Visible := True;
  FPointsViewInfo.SetBounds(APlotAreaBounds, APlotAreaBounds);
  FPointsViewInfo.Dirty := True;
  TdxChartXYDiagramAccess(Diagram).Invalidate;
end;

procedure TdxChartCrosshair.DoCalculate;

  function IsPlotAreaTooSmall: Boolean;
  const
    MinAreaSize = 32;
  var
    AScrollBarSize: TSize;
  begin
    AScrollBarSize := GetHybridScrollBarSize(ScaleFactor, True);
    Result := (FDiagramViewInfo.PlotArea.Width < ScaleFactor.Apply(MinAreaSize) + IfThen(FDiagramViewInfo.AxisYViewInfo.IsScrollBarEnabled, AScrollBarSize.cx)) or
              (FDiagramViewInfo.PlotArea.Height < ScaleFactor.Apply(MinAreaSize) + IfThen(FDiagramViewInfo.AxisXViewInfo.IsScrollBarEnabled, AScrollBarSize.cy));
  end;

  function IsWithinVisibleRange(APoint: TdxChartXYSeriesValueViewInfo): Boolean;
  var
    ADiagram: TdxChartXYDiagramAccess;
  begin
    ADiagram := TdxChartXYDiagramAccess(Diagram);
    Result := cxRectPtIn(ADiagram.ViewInfo.PlotArea, APoint.DisplayValue);
  end;

  procedure CalculateNearestPoints;
  var
    ADiagram: TdxChartXYDiagramAccess;
    AOptions: TdxChartCrosshairOptions;
    I: Integer;
    AValueViewInfo: TdxChartXYSeriesValueViewInfo;
    AMousePos: TdxPointF;
    ASeriesChoosingMode: TdxChartCrosshairSnapToPointMode;
    AMinDistance, ACurDistance: Single;
    AView: TdxChartXYSeriesCustomViewAccess;
  begin
    ADiagram := TdxChartXYDiagramAccess(Diagram);
    AMousePos := cxPointF(MousePos);
    AOptions := ADiagram.Chart.ToolTips.CrosshairOptions;
    ASeriesChoosingMode := AOptions.SnapToPointMode;
    if AOptions.SnapToSeriesMode = TdxChartCrosshairSnapToSeriesMode.NearestToCursor then
      ASeriesChoosingMode := TdxChartCrosshairSnapToPointMode.NearestToCursor;
    AMinDistance := Math.Infinity;
    FNearestPoints.Count := 0;
    for I := 0 to Diagram.VisibleSeriesCount - 1 do
    begin
      if not ADiagram.VisibleSeries[I].ToolTips.Enabled then
        Continue;
      AView := TdxChartXYSeriesCustomViewAccess(ADiagram.VisibleSeries[I].View);
      AValueViewInfo := AView.ViewInfo.GetNearestPoint(AMousePos, AOptions.SnapToPointMode);
      if (AValueViewInfo <> nil) and (AOptions.SnapToOutRangePoints or IsWithinVisibleRange(AValueViewInfo)) then
      begin
        if (AOptions.SnapToSeriesMode = TdxChartCrosshairSnapToSeriesMode.All) or (FNearestPoints.Count = 0) then
        begin
          FNearestPoints.Add(AValueViewInfo);
          if AOptions.SnapToSeriesMode <> TdxChartCrosshairSnapToSeriesMode.All then
            AMinDistance := AValueViewInfo.GetDistanceTo(AMousePos, ASeriesChoosingMode);
        end
        else
        begin
          ACurDistance := AValueViewInfo.GetDistanceTo(AMousePos, ASeriesChoosingMode);
          if ACurDistance <= AMinDistance then
          begin
            FNearestPoints[0] := AValueViewInfo;
            AMinDistance := ACurDistance;
          end;
        end;
      end;
    end;
  end;

var
  ADiagram: TdxChartXYDiagramAccess;
  AOptions: TdxChartCrosshairOptions;
  I: Integer;
begin
  ADiagram := TdxChartXYDiagramAccess(Diagram);
  AOptions := ADiagram.Chart.ToolTips.CrosshairOptions;

  if (ADiagram.GetActualToolTipMode <> TdxChartToolTipMode.Crosshair) or IsPlotAreaTooSmall or not ADiagram.ActuallyVisible then
  begin
    FLabelViewInfo.Visible := False;
    FLinesViewInfo.Visible := False;
    FPointsViewInfo.Visible := False;
    Exit;
  end;

  CalculateNearestPoints;

  FLabelViewInfo.ViewData.Prepare(FNearestPoints.Count);
  for I := 0 to FNearestPoints.Count - 1 do
    FLabelViewInfo.ViewData.UpdateItem(I, TdxChartXYSeriesValueViewInfo(FNearestPoints[I]));
  FLabelViewInfo.Visible := AOptions.Labels.Visible and (FNearestPoints.Count > 0);
  FPointsViewInfo.Visible := AOptions.HighlightPoints and (FNearestPoints.Count > 0);
end;

function TdxChartCrosshair.GetDiagram: TdxChartXYDiagram;
begin
  Result := FDiagramViewInfo.Diagram;
end;

function TdxChartCrosshair.GetScaleFactor: TdxScaleFactor;
var
  ADiagram: TdxChartXYDiagramAccess;
begin
  ADiagram := TdxChartXYDiagramAccess(Diagram);
  Result := TdxChartVisualElementAppearanceAccess(ADiagram.Chart.Appearance).ScaleFactor;
end;

function TdxChartCrosshair.GetSnappedPointCount: Integer;
begin
  Result := FNearestPoints.Count;
end;

function TdxChartCrosshair.GetSnappedPoints(AIndex: Integer): TdxChartXYSeriesValueViewInfo;
begin
  Result := TdxChartXYSeriesValueViewInfo(FNearestPoints[AIndex]);
end;

function TdxChartCrosshair.GetUseRightToLeftAlignment: Boolean;
var
  ADiagram: TdxChartXYDiagramAccess;
begin
  ADiagram := TdxChartXYDiagramAccess(Diagram);
  Result := ADiagram.Chart.UseRightToLeftAlignment;
end;

{ TdxChartCrosshairLabelItem }

constructor TdxChartCrosshairLabelItem.Create(ALabelViewInfo: TdxChartCrosshairLabelViewInfo);
begin
  inherited Create;
  FViewInfo := TdxChartCrosshairLabelItemViewInfo.Create(Self);
  FLabelViewInfo := ALabelViewInfo;
end;

destructor TdxChartCrosshairLabelItem.Destroy;
begin
  FreeAndNil(FViewInfo);
  inherited Destroy;
end;

procedure TdxChartCrosshairLabelItem.Update(const AValue: TdxChartXYSeriesValueViewInfo);
begin
  FValue := AValue;
  FCaption := AValue.ToolTipText;
  FViewInfo.Dirty := True;
end;

{ TdxChartCrosshairLabelItemViewInfo }

constructor TdxChartCrosshairLabelItemViewInfo.Create(AOwner: TdxChartCrosshairLabelItem);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TdxChartCrosshairLabelItemViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited Destroy;
end;

procedure TdxChartCrosshairLabelItemViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
const
  AlignmentMap: array[Boolean] of Integer = (CXTO_LEFT, CXTO_RIGHT or CXTO_RTLREADING);
var
  ATextFlags: Integer;
  AHeight: Single;
  ATextSize: TdxSizeF;
  AAppearance: TdxChartCrosshairLabelAppearanceAccess;
begin
  inherited DoCalculate(ACanvas);
  AAppearance := TdxChartCrosshairLabelAppearanceAccess(LabelViewInfo.Appearance);

  FImageBounds := Bounds;
  FImageBounds.Width := AAppearance.ImageSize.Width;
  FImageBounds.Height := AAppearance.ImageSize.Height;

  FCaptionBounds := Bounds;
  FCaptionBounds.Left := FCaptionBounds.Left + FImageBounds.Width + AAppearance.CaptionOffset;
  if (Owner.Caption <> '') and not FCaptionBounds.IsEmpty then
  begin
    ATextFlags := AlignmentMap[Owner.LabelViewInfo.UseRightToLeftReading] or CXTO_SINGLELINE;
    if not ACanvas.CheckIsValid(FTextLayout) then
    begin
      FreeAndNil(FTextLayout);
      FTextLayout := ACanvas.CreateTextLayout;
    end;
    FTextLayout.SetColor(AAppearance.ActualTextColor);
    FTextLayout.SetFont(AAppearance.ActualFont);
    FTextLayout.SetText(Owner.Caption);
    FTextLayout.SetFlags(ATextFlags);
    FTextLayout.SetLayoutConstraints(FCaptionBounds);
    ATextSize := FTextLayout.MeasureSizeF;
    FCaptionBounds.Height := ATextSize.Height;
    FCaptionBounds.Width := Min(ATextSize.Width, FCaptionBounds.Width);
    FTextLayout.SetFlags(ATextFlags or CXTO_END_ELLIPSIS);
  end
  else
  begin
    FreeAndNil(FTextLayout);
    FCaptionBounds := TdxRectF.Null;
  end;
  AHeight := Max(FImageBounds.Height, FCaptionBounds.Height);
  UpdateBounds(cxRectF(Bounds.Left, Bounds.Top, FCaptionBounds.Right, Bounds.Top + AHeight));
  FCaptionBounds.Offset(0, (AHeight - FCaptionBounds.Height) / 2);
  FImageBounds.Offset(0, (AHeight - FImageBounds.Height) / 2);
  if AAppearance.UseRightToLeftAlignment then
  begin
    FImageBounds := TdxRightToLeftLayoutConverter.ConvertRect(FImageBounds, Bounds);
    FCaptionBounds := TdxRightToLeftLayoutConverter.ConvertRect(FCaptionBounds, Bounds);
  end;
end;

procedure TdxChartCrosshairLabelItemViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  ALegendItem: IdxChartLegendItem;
begin
  inherited DoDraw(ACanvas);
  if FTextLayout <> nil then
    FTextLayout.Draw(FCaptionBounds.DeflateToTRect);
  if not FImageBounds.IsEmpty then
  begin
    Supports(Owner.Value.View.Series, IdxChartLegendItem, ALegendItem);
    ALegendItem.DrawGlyph(ACanvas, FImageBounds);
  end;
end;

procedure TdxChartCrosshairLabelItemViewInfo.Offset(const ADistance: TdxPointF);
begin
  inherited Offset(ADistance);
  FCaptionBounds.Offset(ADistance);
  FImageBounds.Offset(ADistance);
end;

procedure TdxChartCrosshairLabelItemViewInfo.SetPosition(const APosition: TdxPointF);
begin
  Offset(TdxPointF.Create(APosition.X - Bounds.Left, APosition.Y - Bounds.Top));
end;

function TdxChartCrosshairLabelItemViewInfo.GetLabelViewInfo: TdxChartCrosshairLabelViewInfo;
begin
  Result := Owner.LabelViewInfo;
end;

{ TdxChartCrosshairLinesViewInfo }

constructor TdxChartCrosshairLinesViewInfo.Create(const ACrosshair: TdxChartCrosshair);
begin
  inherited Create;
  FCrosshair := ACrosshair;
  FHorizontalLines := TList<Single>.Create;
  FVerticalLines := TList<Single>.Create;
  FAxisLabels := TdxChartItemsViewInfoList.Create(True);
end;

destructor TdxChartCrosshairLinesViewInfo.Destroy;
begin
  FreeAndNil(FAxisLabels);
  FreeAndNil(FHorizontalLines);
  FreeAndNil(FVerticalLines);
  inherited;
end;

procedure TdxChartCrosshairLinesViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);

  procedure CalculatePens;
  var
    ADiagram: TdxChartXYDiagramAccess;
    AOptions: TdxChartCrosshairOptions;
  begin
    ADiagram := TdxChartXYDiagramAccess(FCrosshair.Diagram);
    AOptions := ADiagram.Chart.ToolTips.CrosshairOptions;
    if ADiagram.Rotated then
    begin
      FHorizontalPen := TdxChartCrosshairLineAppearanceAccess(AOptions.ArgumentLines.Appearance).ActualPen;
      FVerticalPen := TdxChartCrosshairLineAppearanceAccess(AOptions.ValueLines.Appearance).ActualPen;
    end
    else
    begin
      FHorizontalPen := TdxChartCrosshairLineAppearanceAccess(AOptions.ValueLines.Appearance).ActualPen;
      FVerticalPen := TdxChartCrosshairLineAppearanceAccess(AOptions.ArgumentLines.Appearance).ActualPen;
    end;
  end;

  function ShouldArgumentLineStick: Boolean;
  var
    AOptions: TdxChartCrosshairOptions;
  begin
    AOptions := TdxChartXYDiagramAccess(FCrosshair.Diagram).Chart.ToolTips.CrosshairOptions;
    Result := (AOptions.StickyLines = TdxChartCrosshairStickyLines.Crosshair) or
              ((AOptions.StickyLines = TdxChartCrosshairStickyLines.SingleAxis) and
              (AOptions.SnapToPointMode <> TdxChartCrosshairSnapToPointMode.Argument));
  end;

  function ShouldValueLineStick: Boolean;
  var
    AOptions: TdxChartCrosshairOptions;
  begin
    AOptions := TdxChartXYDiagramAccess(FCrosshair.Diagram).Chart.ToolTips.CrosshairOptions;
    Result := (AOptions.StickyLines = TdxChartCrosshairStickyLines.Crosshair) or
              ((AOptions.StickyLines = TdxChartCrosshairStickyLines.SingleAxis) and
              (AOptions.SnapToPointMode <> TdxChartCrosshairSnapToPointMode.Value));
  end;

  procedure CalculateLines;
  var
    ADiagram: TdxChartXYDiagramAccess;
    AOptions: TdxChartCrosshairOptions;
    I: Integer;
    AMousePos: TdxPointF;
  begin
    ADiagram := TdxChartXYDiagramAccess(FCrosshair.Diagram);
    AMousePos := cxPointF(FCrosshair.MousePos);
    AOptions := ADiagram.Chart.ToolTips.CrosshairOptions;
    FHorizontalLines.Count := 0;
    FVerticalLines.Count := 0;
    if AOptions.ArgumentLines.Visible then
    begin
      if ShouldArgumentLineStick then
      begin
        for I := 0 to FCrosshair.SnappedPointCount - 1 do
          if ADiagram.Rotated then
            FHorizontalLines.Add(Ceil(FCrosshair.SnappedPoints[I].CrosshairAnchorPoint.Y))
          else
            FVerticalLines.Add(Ceil(FCrosshair.SnappedPoints[I].CrosshairAnchorPoint.X));
      end
      else
      begin
        if ADiagram.Rotated then
          FHorizontalLines.Add(AMousePos.Y)
        else
          FVerticalLines.Add(AMousePos.X);
      end;
    end;

    if AOptions.ValueLines.Visible then
    begin
      if ShouldValueLineStick then
      begin
        for I := 0 to FCrosshair.SnappedPointCount - 1 do
          if ADiagram.Rotated then
            FVerticalLines.Add(Ceil(FCrosshair.SnappedPoints[I].CrosshairAnchorPoint.X))
          else
            FHorizontalLines.Add(Ceil(FCrosshair.SnappedPoints[I].CrosshairAnchorPoint.Y));
      end
      else
      begin
        if ADiagram.Rotated then
          FVerticalLines.Add(AMousePos.X)
        else
          FHorizontalLines.Add(AMousePos.Y);
      end;
    end;
  end;

  procedure AddAxisLabel(AAxisViewInfo: TdxChartAxisViewInfo; AAxisValue: Double; ACanvasValue: Single);
  var
    AAxisLabel: TdxChartCrosshairAxisLabelViewInfo;
    ABounds: TdxRectF;
  begin
    AAxisLabel := TdxChartCrosshairAxisLabelViewInfo.Create(AAxisViewInfo, AAxisViewInfo.ViewData.DoubleToAxisValue(AAxisValue), Ceil(ACanvasValue));  
    ABounds := AAxisViewInfo.GetCrosshairLabelsArea;
    AAxisLabel.SetBounds(ABounds, ABounds);
    FAxisLabels.Add(AAxisLabel);
  end;

  procedure CalculateAxisLabels;
  var
    ADiagram: TdxChartXYDiagramAccess;
    AOptions: TdxChartCrosshairOptions;
    I: Integer;
    AMousePos: TdxPointF;
    AAxisViewInfo: TdxChartAxisViewInfo;
  begin
    ADiagram := TdxChartXYDiagramAccess(FCrosshair.Diagram);
    AMousePos := cxPointF(FCrosshair.MousePos);
    AOptions := ADiagram.Chart.ToolTips.CrosshairOptions;
    FAxisLabels.Count := 0;
    if AOptions.ShowArgumentLabels then
    begin
      AAxisViewInfo := TdxChartCustomAxisAccess(ADiagram.Axes.AxisX).ViewInfo;
      if ShouldArgumentLineStick then
        for I := 0 to FCrosshair.SnappedPointCount - 1 do
          AddAxisLabel(AAxisViewInfo, FCrosshair.SnappedPoints[I].Argument, GetArgumentCoordinate(FCrosshair.SnappedPoints[I].CrosshairAnchorPoint))
      else
        AddAxisLabel(AAxisViewInfo, AAxisViewInfo.CanvasValueToAxisValue(GetArgumentCoordinate(AMousePos)), GetArgumentCoordinate(AMousePos));
    end;
    if AOptions.ShowValueLabels then
    begin
      AAxisViewInfo := TdxChartCustomAxisAccess(ADiagram.Axes.AxisY).ViewInfo;
      if ShouldValueLineStick then
        for I := 0 to FCrosshair.SnappedPointCount - 1 do
          AddAxisLabel(AAxisViewInfo, FCrosshair.SnappedPoints[I].Value, GetValueCoordinate(FCrosshair.SnappedPoints[I].CrosshairAnchorPoint))
      else
        AddAxisLabel(AAxisViewInfo, AAxisViewInfo.CanvasValueToAxisValue(GetValueCoordinate(AMousePos)), GetValueCoordinate(AMousePos));
    end;
    FAxisLabels.Calculate(ACanvas);
  end;

begin
  FCrosshair.Calculate;
  if not Visible then
    Exit;
  CalculateLines;
  CalculatePens;
  CalculateAxisLabels;
end;

procedure TdxChartCrosshairLinesViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  APlotAreaBounds: TdxRectF;
  X, Y: Single;
begin
  if (FHorizontalLines.Count <> 0) or (FVerticalLines.Count <> 0) then
  begin
    APlotAreaBounds := FCrosshair.DiagramViewInfo.PlotArea;
    ACanvas.SaveClipRegion;
    ACanvas.IntersectClipRect(APlotAreaBounds);
    ACanvas.EnableAntialiasing(False);
    for X in FVerticalLines do
      ACanvas.Line(cxPointF(X, APlotAreaBounds.Top), cxPointF(X, APlotAreaBounds.Bottom), FVerticalPen);
    for Y in FHorizontalLines do
      ACanvas.Line(cxPointF(APlotAreaBounds.Left, Y), cxPointF(APlotAreaBounds.Right, Y), FHorizontalPen);
    ACanvas.RestoreAntialiasing;
    ACanvas.RestoreClipRegion;
  end;
  FAxisLabels.Draw(ACanvas);
end;

function TdxChartCrosshairLinesViewInfo.NeedClipping: Boolean;
begin
  Result := True;
end;

function TdxChartCrosshairLinesViewInfo.GetArgumentCoordinate(ACanvasPoint: TdxPointF): Single;
begin
  Result := IfThen(FCrosshair.Diagram.Rotated, ACanvasPoint.Y, ACanvasPoint.X);
end;

function TdxChartCrosshairLinesViewInfo.GetValueCoordinate(ACanvasPoint: TdxPointF): Single;
begin
  Result := IfThen(FCrosshair.Diagram.Rotated, ACanvasPoint.X, ACanvasPoint.Y);
end;

{ TdxChartCrosshairController }

constructor TdxChartCrosshairController.Create(AChart: TdxChart);
begin
  inherited Create;
  FChart := AChart;
  FCrosshairs := TdxFastObjectList.Create(True);
  FLinesViewInfos := TdxChartItemsViewInfoList.Create(False);
  FLabelViewInfos := TdxChartItemsViewInfoList.Create(False);
  FPointsViewInfos := TdxChartItemsViewInfoList.Create(False);
end;

destructor TdxChartCrosshairController.Destroy;
begin
  FreeAndNil(FLabelViewInfos);
  FreeAndNil(FLinesViewInfos);
  FreeAndNil(FPointsViewInfos);
  FreeAndNil(FCrosshairs);
  inherited Destroy;
end;

procedure TdxChartCrosshairController.DiagramsChanged;
var
  I: Integer;
  ACrosshair: TdxChartCrosshair;
  ADiagram: TdxChartXYDiagramAccess;
begin
  FCrosshairs.Count := 0;
  FPointsViewInfos.Count := 0;
  FLabelViewInfos.Count := 0;
  FLinesViewInfos.Count := 0;
  for I := 0 to FChart.DiagramCount - 1 do
    if FChart.Diagrams[I] is TdxChartXYDiagram then
    begin
      ADiagram := TdxChartXYDiagramAccess(FChart.Diagrams[I]);
      ACrosshair := TdxChartCrosshair.Create(TdxChartXYDiagramViewInfo(ADiagram.ViewInfo));
      FCrosshairs.Add(ACrosshair);
      FPointsViewInfos.Add(ACrosshair.PointsViewInfo);
      FLabelViewInfos.Add(ACrosshair.LabelViewInfo);
      FLinesViewInfos.Add(ACrosshair.LinesViewInfo);
    end;
end;

function TdxChartCrosshairController.GetCrosshairViewInfos(ALayer: TdxChartCrosshairLayer): TdxChartItemsViewInfoList;
begin
  case ALayer of
    TdxChartCrosshairLayer.BelowLegend:
      Result := FLinesViewInfos;
    TdxChartCrosshairLayer.AboveLegend:
      Result := FLabelViewInfos;
  else
    Result := FPointsViewInfos;
  end;
end;

procedure TdxChartCrosshairController.HideCrosshair(ADiagram: TdxChartCustomDiagram);
var
  ACrosshair: TdxChartCrosshair;
begin
  ACrosshair := GetCrosshair(ADiagram);
  ACrosshair.Hide;
end;

procedure TdxChartCrosshairController.LayoutChanged;
var
  I: Integer;
begin
  for I := 0 to FCrosshairs.Count - 1 do
    TdxChartCrosshair(FCrosshairs[I]).MakeDirty;
end;

procedure TdxChartCrosshairController.OptionsChanged;
var
  I: Integer;
begin
  for I := 0 to FCrosshairs.Count - 1 do
    TdxChartCrosshair(FCrosshairs[I]).MakeDirty;
  TdxChartAccess(FChart).Invalidate;
end;

procedure TdxChartCrosshairController.ShowCrosshair(ADiagram: TdxChartCustomDiagram; APosition: TdxPointF);
var
  ACrosshair: TdxChartCrosshair;
begin
  ACrosshair := GetCrosshair(ADiagram);
  ACrosshair.ShowAt(APosition);
end;

function TdxChartCrosshairController.GetCrosshair(ADiagram: TdxChartCustomDiagram): TdxChartCrosshair;
var
  I: Integer;
begin
  for I := 0 to FCrosshairs.Count -1 do
    if TdxChartCrosshair(FCrosshairs[I]).Diagram = ADiagram then
      Exit(TdxChartCrosshair(FCrosshairs[I]));
  Result := nil;
end;

{ TdxChartCrosshairPointsViewInfo }

constructor TdxChartCrosshairPointsViewInfo.Create(const ACrosshair: TdxChartCrosshair);
begin
  inherited Create;
  FCrosshair := ACrosshair;
end;

procedure TdxChartCrosshairPointsViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
begin
  FCrosshair.Calculate;
end;

procedure TdxChartCrosshairPointsViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  I: Integer;
  APoint: TdxChartXYSeriesValueViewInfo;
begin
  for I := 0 to FCrosshair.SnappedPointCount - 1 do
  begin
    APoint := FCrosshair.SnappedPoints[I];
    TdxChartXYSeriesViewCustomViewInfoAccess(APoint.Owner).DrawHighlightedValue(ACanvas, APoint);
  end;
end;

function TdxChartCrosshairPointsViewInfo.NeedClipping: Boolean;
begin
  Result := True;
end;

{ TdxChartCrosshairAxisLabelViewInfo }

constructor TdxChartCrosshairAxisLabelViewInfo.Create(AAxisViewInfo: TdxChartAxisViewInfo; AAxisValue: Variant; ACanvasValue: Single);
begin
  inherited Create(TdxChartCustomAxisAccess(AAxisViewInfo.Axis).CrosshairLabels.Appearance);
  FAxisViewInfo := AAxisViewInfo;
  FAxisValue := AAxisValue;
  FCanvasValue := ACanvasValue;
  FOptions := TdxChartCustomAxisAccess(FAxisViewInfo.Axis).CrosshairLabels;
  FAppearance := FOptions.Appearance;
end;

destructor TdxChartCrosshairAxisLabelViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited;
end;

procedure TdxChartCrosshairAxisLabelViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
  procedure ExpandInsidePadding(APreferredSize: Single; AAvailableStart, AAvailableEnd: Single; AStartPadding, AEndPadding: Single; out AResultStart, AResultEnd: Single);
  var 
    AFreeArea: Single;
  begin
    AFreeArea := AAvailableEnd - AAvailableStart - APreferredSize;
    if AFreeArea <= 0 then
    begin
      AResultStart := AAvailableStart;
      AResultEnd := AAvailableEnd;
    end
    else if AFreeArea >= AStartPadding + AEndPadding then
    begin
      AResultStart := AAvailableStart + AStartPadding;
      AResultEnd := AResultStart + APreferredSize;
    end
    else if AFreeArea <= Abs(AStartPadding - AEndPadding) then
    begin
      if AStartPadding > AEndPadding then
      begin
        AResultEnd := AAvailableEnd;
        AResultStart := AResultEnd - APreferredSize;
      end
      else
      begin
        AResultStart := AAvailableStart;
        AResultEnd := AResultStart + APreferredSize;
      end;
    end
    else begin
      AResultStart := ((AAvailableStart + AStartPadding) + (AAvailableEnd - AEndPadding) - APreferredSize) / 2;
      AResultEnd := AResultStart + APreferredSize;
    end;      
  end;
const
  AlignmentMap: array[Boolean] of Integer = (CXTO_LEFT, CXTO_RIGHT or CXTO_RTLREADING);
var
  ATextFlags: Integer;
  AAppearance: TdxChartVisualElementAppearanceAccess;
  AOptions: TdxChartCrosshairAxisLabelsAccess;
  ASize, ATextSize: TdxSizeF;
begin
  inherited;
  AAppearance := TdxChartVisualElementAppearanceAccess(Appearance);
  AOptions := TdxChartCrosshairAxisLabelsAccess(Options);

  FText := TdxChartTextFormatController.FormatPattern(AOptions.TextFormatter,
    function(const AName: string; out AValue: Variant): Boolean
    begin
      Result := (AName = TdxChartTextFormatVariableNames.Value) or
        (AName = TdxChartTextFormatVariableNames.Argument) and TdxChartCustomAxisAccess(FAxisViewInfo.Axis).IsArgumentAxis;
      if Result then
        AValue := FAxisValue;
    end
  );
  Visible := FText <> '';
  if not Visible then
    Exit;

  ATextFlags := AlignmentMap[AAppearance.UseRightToLeftReading] or CXTO_SINGLELINE or CXTO_END_ELLIPSIS;
  if not ACanvas.CheckIsValid(FTextLayout) then
  begin
    FreeAndNil(FTextLayout);
    FTextLayout := ACanvas.CreateTextLayout;
  end;
  FTextLayout.SetColor(AAppearance.ActualTextColor);
  FTextLayout.SetFont(AAppearance.ActualFont);
  FTextLayout.SetText(FText);
  FTextLayout.SetFlags(ATextFlags);
  FTextLayout.SetLayoutConstraints(Bounds);
  ATextSize := FTextLayout.MeasureSizeF;
  ASize.cx := Min(ATextSize.cx + AAppearance.ActualPadding.Left + AAppearance.ActualPadding.Right, Bounds.Width);
  ASize.cy := ATextSize.cy + AAppearance.ActualPadding.Top + AAppearance.ActualPadding.Bottom;
  UpdateBounds(FAxisViewInfo.GetLabelBounds(ASize, FCanvasValue, TdxAlignment.Center));
  FTextBounds := ContentBounds;
  if ContentBounds.Width < ATextSize.cx then
    ExpandInsidePadding(ATextSize.cx, Bounds.Left, Bounds.Right, AAppearance.ActualPadding.Left, AAppearance.ActualPadding.Right, FTextBounds.Left, FTextBounds.Right);
end;

procedure TdxChartCrosshairAxisLabelViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  inherited DoDraw(ACanvas);
  if FTextLayout <> nil then
    FTextLayout.Draw(FTextBounds);
end;

end.
