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

unit dxChartXYSeriesBarView;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  System.UITypes,
  Types, Classes, Math, Graphics, SysUtils,
  dxCore, dxCoreClasses, dxCoreGraphics, cxGeometry, cxClasses, cxGraphics, dxTypeHelpers, cxDataStorage,
  cxCustomCanvas, dxChartCore, dxChartXYDiagram, dxChartStrs;

type
  TdxChartXYSeriesBarViewInfo = class;

  TdxChartSeriesBarValueLabelsResolveOverlappingMode =
    TdxChartSeriesValueLabelsResolveOverlappingMode.None..TdxChartSeriesValueLabelsResolveOverlappingMode.HideOverlapped;

  { TdxChartXYSeriesBarAppearance }

  TdxChartXYSeriesBarAppearance = class(TdxChartSeriesViewAppearance)
  protected
    function DefaultParentBackground: Boolean; override;
    function HasFillOptions: Boolean; override;
    function HasStrokeOptions: Boolean; override;
  published
    property FillOptions;
    property StrokeOptions;
  end;

  { TdxChartXYSeriesBarValueLabelAppearance }

  TdxChartXYSeriesBarValueLabelAppearance = class(TdxChartSeriesValueLabelAppearance)
  protected
    function DefaultBorder: Boolean; override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
  end;

  { TdxChartXYSeriesBarView }

  TdxChartXYSeriesBarView = class(TdxChartXYSeriesCustomView)
  public const
    DefaultBarDistance: Integer = 1;
    DefaultBarWidth: Single = 60;
  strict private
    FBarDistance: Integer;
    FBarWidth: Single;
    function GetAppearance: TdxChartXYSeriesBarAppearance;
    function GetViewInfo: TdxChartXYSeriesBarViewInfo; inline;
    procedure SetAppearance(AValue: TdxChartXYSeriesBarAppearance);
    procedure SetBarDistance(AValue: Integer);
    procedure SetBarWidth(AValue: Single);
    function IsBarDistanceStored: Boolean;
    function IsBarWidthStored: Boolean;
  protected
    procedure ChangeScale(M, D: Integer); override;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function CreateValueLabels: TdxChartSeriesValueLabels; override;
    function CreateViewInfo: TdxChartSeriesViewCustomViewInfo; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetDefaultLineLength: Single; override;
    function GetValueLabelAppearanceClass: TdxChartSeriesValueLabelAppearanceClass; override;
    function IsZeroBased: Boolean; override;

    property ViewInfo: TdxChartXYSeriesBarViewInfo read GetViewInfo;
  public
    constructor Create(AOwner: TPersistent); override;
    class function GetDescription: string; override;
  published
    property Appearance: TdxChartXYSeriesBarAppearance read GetAppearance write SetAppearance;
    property BarDistance: Integer read FBarDistance write SetBarDistance stored IsBarDistanceStored;
    property BarWidth: Single read FBarWidth write SetBarWidth stored IsBarWidthStored;  
    property ValueLabels;
  end;

  { TdxChartXYSeriesBarValueViewInfo }

  TdxChartXYSeriesBarValueViewInfo = class(TdxChartXYSeriesValueViewInfo)
  strict private
    function GetBarBounds: TdxRectF; inline;
    function GetOwner: TdxChartXYSeriesBarViewInfo; inline;
  protected
    FBaseDisplayValue: TdxPointF;
    function CreateValueLabel: TdxChartValueLabelCustomViewInfo; override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetLabelAnchorPoint: TdxPointF; override;
    function GetCrosshairAnchorPoint: TdxPointF; override;

    property Owner: TdxChartXYSeriesBarViewInfo read GetOwner;
  public
    function GetDistanceTo(const APoint: TdxPointF; AMeasuringMode: TdxChartCrosshairSnapToPointMode): Single; override;
    procedure Draw(ACanvas: TcxCustomCanvas); override;

    property BarBounds: TdxRectF read GetBarBounds;
  end;

  { TdxChartXYSeriesBarValueLabels }

  TdxChartXYSeriesBarValueLabels = class(TdxChartXYSeriesValueLabels)
  strict private
    FResolveOverlappingMode: TdxChartSeriesBarValueLabelsResolveOverlappingMode;
    procedure SetResolveOverlappingMode(AValue: TdxChartSeriesBarValueLabelsResolveOverlappingMode);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode; override;
  public
    constructor Create(AOwner: TPersistent); override;

  published
    property ResolveOverlappingMode: TdxChartSeriesBarValueLabelsResolveOverlappingMode read FResolveOverlappingMode write SetResolveOverlappingMode
      default TdxChartSeriesValueLabelsResolveOverlappingMode.Default;
  end;

  { TdxChartXYSeriesBarValueLabelViewInfo }

  TdxChartXYSeriesBarValueLabelViewInfo = class(TdxChartXYSeriesValueLabelViewInfo)
  protected
    function GetValidRect: TdxRectF; override;
  end;

  { TdxChartXYSeriesBarViewInfo }

  TdxChartXYSeriesBarViewInfo = class(TdxChartXYSeriesViewCustomViewInfo)
  strict private
    function GetAppearance: TdxChartXYSeriesBarAppearance; inline;
    function GetActualDistance: Single;
    function GetActualIndex: Integer;
    function GetBarsCount: Integer;
    function GetView: TdxChartXYSeriesBarView; inline;
  protected
    FActualBrush: TcxCanvasBasedBrush;
    FActualPen: TcxCanvasBasedPen;
    FBarOffset: Single;
    FBarWidth: Single;
    FHighlightingFillOptions: TdxFillOptions;
    FSingleLine: Boolean;
    procedure CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo); override;
    function CalculateBarWidth: Single;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DrawHighlightedValue(ACanvas: TcxCustomCanvas; const AValue: TdxChartXYSeriesValueViewInfo); override;
    function GetMaxLegendGlyphPenWidth: Single; override;
    procedure DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF); override;
    procedure DrawValue(ACanvas: TcxCustomCanvas; const AValue: TdxChartSeriesValueViewInfo); override;
    function GetLegendItemColor: TdxAlphaColor; override;
    function GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass; override;
    function IsPointAppropriateForCrosshair(APoint: TdxPointF; ANearestValue: TdxChartXYSeriesValueViewInfo; AMode: TdxChartCrosshairSnapToPointMode): Boolean; override;
  public
    constructor Create(AOwner: TdxChartSeriesCustomView); override;
    destructor Destroy; override;
    property Appearance: TdxChartXYSeriesBarAppearance read GetAppearance;
    property BarWidth: Single read FBarWidth;
    property BarOffset: Single read FBarOffset;
    property View: TdxChartXYSeriesBarView read GetView;
  end;

  { TdxChartXYSeriesStackedBarView }

  TdxChartXYSeriesStackedBarView = class(TdxChartXYSeriesBarView)
  protected
    class function CanAggregate(AView: TdxChartSeriesCustomView): Boolean; override;
    class function GetNegativeValuesStackingStyle: TdxChartXYSeriesStackedBarView.TNegativeValuesStackingStyle; override;
  public
    class function GetDescription: string; override;
    class function IsCompatibleWith(AView: TdxChartSeriesCustomView): Boolean; override;
  end;

  { TdxChartXYSeriesStackedBarSideBySideView }

  TdxChartXYSeriesStackedBarSideBySideView = class(TdxChartXYSeriesStackedBarView); // for internal use

  { TdxChartXYSeriesFullStackedBarView }

  TdxChartXYSeriesFullStackedBarView = class(TdxChartXYSeriesStackedBarView)
  public
    class function GetDescription: string; override;
  end;

  { TdxChartXYSeriesFullStackedBarSideBySideView }

  TdxChartXYSeriesFullStackedBarSideBySideView = class(TdxChartXYSeriesStackedBarSideBySideView); // for internal use


implementation

const
  dxThisUnitName = 'dxChartXYSeriesBarView';

{ TdxChartXYSeriesBarAppearance }

function TdxChartXYSeriesBarAppearance.DefaultParentBackground: Boolean;
begin
  Result := False;
end;

function TdxChartXYSeriesBarAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartXYSeriesBarAppearance.HasStrokeOptions: Boolean;
begin
  Result := True;
end;

{ TdxChartXYSeriesBarValueLabelAppearance }

function TdxChartXYSeriesBarValueLabelAppearance.DefaultBorder: Boolean;
begin
  Result := True;
end;

function TdxChartXYSeriesBarValueLabelAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  Result := inherited GetActualColor(AIndex);
  if AIndex = ColorIndex then
    Result := ColorScheme.Chart.BackgroundColor;
    Result := TdxAlphaColors.FromColor(TdxAlphaColors.ToColor(Result)); 
end;

{ TdxChartXYSeriesBarView }

constructor TdxChartXYSeriesBarView.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FBarDistance := DefaultBarDistance;
  FBarWidth := DefaultBarWidth;
end;

class function TdxChartXYSeriesBarView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlBarDisplayName);
end;

procedure TdxChartXYSeriesBarView.ChangeScale(M, D: Integer);
begin
  FBarDistance := Max(1, Round(FBarDistance * M / D));
  inherited ChangeScale(M, D);
end;

function TdxChartXYSeriesBarView.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartXYSeriesBarAppearance.Create(Self);
end;

function TdxChartXYSeriesBarView.CreateValueLabels: TdxChartSeriesValueLabels;
begin
  Result := TdxChartXYSeriesBarValueLabels.Create(Self);
end;

function TdxChartXYSeriesBarView.CreateViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
  Result := TdxChartXYSeriesBarViewInfo.Create(Self);
end;

procedure TdxChartXYSeriesBarView.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYSeriesBarView then
  begin
    FBarDistance := TdxChartXYSeriesBarView(Source).FBarDistance;
    FBarWidth := TdxChartXYSeriesBarView(Source).FBarWidth;
  end;
end;

function TdxChartXYSeriesBarView.GetDefaultLineLength: Single;
begin
  Result := 0;
end;

function TdxChartXYSeriesBarView.GetValueLabelAppearanceClass: TdxChartSeriesValueLabelAppearanceClass;
begin
  Result := TdxChartXYSeriesBarValueLabelAppearance;
end;

function TdxChartXYSeriesBarView.GetAppearance: TdxChartXYSeriesBarAppearance;
begin
  Result := TdxChartXYSeriesBarAppearance(inherited Appearance);
end;

function TdxChartXYSeriesBarView.GetViewInfo: TdxChartXYSeriesBarViewInfo;
begin
  Result := TdxChartXYSeriesBarViewInfo(inherited ViewInfo);
end;

function TdxChartXYSeriesBarView.IsZeroBased: Boolean;
begin
  Result := True;
end;

procedure TdxChartXYSeriesBarView.SetAppearance(AValue: TdxChartXYSeriesBarAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartXYSeriesBarView.SetBarDistance(AValue: Integer);
begin
  AValue := Max(1, AValue);
  if AValue <> FBarDistance then
  begin
    FBarDistance := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartXYSeriesBarView.SetBarWidth(AValue: Single);
begin
  AValue := Max(1, Min(100, AValue));
  if AValue <> FBarWidth then
  begin
    FBarWidth := AValue;
    LayoutChanged;
  end;
end;

function TdxChartXYSeriesBarView.IsBarDistanceStored: Boolean;
begin
  Result := not SameValue(FBarDistance, DefaultBarDistance);
end;

function TdxChartXYSeriesBarView.IsBarWidthStored: Boolean;
begin
  Result := not SameValue(FBarWidth, DefaultBarWidth);
end;

{ TdxChartXYSeriesBarValueViewInfo }

function TdxChartXYSeriesBarValueViewInfo.GetDistanceTo(const APoint: TdxPointF;
  AMeasuringMode: TdxChartCrosshairSnapToPointMode): Single;

  function GetArgumentCoordinate(P: TdxPointF): Single;
  begin
    Result := IfThen(Owner.Diagram.Rotated, P.Y, P.X);
  end;

begin
  if (AMeasuringMode = TdxChartCrosshairSnapToPointMode.Argument) and (Owner.View.Chart.ToolTips.CrosshairOptions.SnapToSeriesMode = TdxChartCrosshairSnapToSeriesMode.All) then
  begin
    if Owner.DiagramViewInfo.AxisXViewInfo.IsNumeric then
      Result := Abs(GetArgumentCoordinate(APoint) - GetArgumentCoordinate(DisplayValue) + Owner.BarOffset)
    else
      Result := Abs(Round(Owner.DiagramViewInfo.AxisXViewInfo.CanvasValueToAxisValue(GetArgumentCoordinate(APoint))) - Argument);
  end
  else
    Result := inherited GetDistanceTo(APoint, AMeasuringMode);
end;

function TdxChartXYSeriesBarValueViewInfo.GetBarBounds: TdxRectF;
begin
  Result.TopLeft := FDisplayValue;
  Result.BottomRight := FBaseDisplayValue;
  if Result.Top > Result.Bottom then
    ExchangeSingle(Result.Top, Result.Bottom);
  if Result.Left > Result.Right then
    ExchangeSingle(Result.Left, Result.Right);
end;

function TdxChartXYSeriesBarValueViewInfo.GetOwner: TdxChartXYSeriesBarViewInfo;
begin
  Result := TdxChartXYSeriesBarViewInfo(inherited Owner);
end;

function TdxChartXYSeriesBarValueViewInfo.CreateValueLabel: TdxChartValueLabelCustomViewInfo;
begin
  Result := TdxChartXYSeriesBarValueLabelViewInfo.Create(Self);
end;

procedure TdxChartXYSeriesBarValueViewInfo.Draw(ACanvas: TcxCustomCanvas);
begin
  if not ACanvas.RectVisible(BarBounds) then
    Exit;
  ACanvas.EnableAntialiasing(False);
  ACanvas.FillRect(BarBounds, Owner.FActualBrush);
  if not Owner.FSingleLine then
    ACanvas.FrameRect(BarBounds, TcxCanvasBasedPenHandle(Owner.FActualPen.Handle).Color, TcxCanvasBasedPenHandle(Owner.FActualPen.Handle).Width);
  ACanvas.RestoreAntialiasing;
end;

function TdxChartXYSeriesBarValueViewInfo.GetCrosshairAnchorPoint: TdxPointF;
begin
  if Owner.Diagram.Rotated then
    Result := cxPointF(DisplayValue.X, (DisplayValue.Y + FBaseDisplayValue.Y) / 2)
  else
    Result := cxPointF((DisplayValue.X + FBaseDisplayValue.X) / 2, DisplayValue.Y);
end;

function TdxChartXYSeriesBarValueViewInfo.GetLabelAnchorPoint: TdxPointF;
begin
  Result := cxRectF(FDisplayValue, FBaseDisplayValue).CenterPoint;
end;

function TdxChartXYSeriesBarValueViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  if Visible and BarBounds.Contains(P) then
    Result := TdxChartSeriesPointHitElement.Create(CreateSeriesPointInfo, ToolTipText)
  else
    Result := nil;
end;

{ TdxChartXYSeriesBarViewInfo }

procedure TdxChartXYSeriesBarViewInfo.CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo);
var
  ABarValue: TdxChartXYSeriesBarValueViewInfo absolute AValue;
begin
  inherited CalculateCanvasValue(AValue);
  FPointToDisplayPointProc(ABarValue.FArgument, ABarValue.FBaseValue, ABarValue.FBaseDisplayValue);
  if not Diagram.Rotated then
  begin
    ABarValue.FDisplayValue.X := ABarValue.FDisplayValue.X + BarOffset;
    ABarValue.FBaseDisplayValue.X := ABarValue.FDisplayValue.X + BarWidth;
  end
  else
  begin
    ABarValue.FDisplayValue.Y := ABarValue.FDisplayValue.Y + BarOffset;
    ABarValue.FBaseDisplayValue.Y := ABarValue.FDisplayValue.Y + BarWidth;
  end;
end;

constructor TdxChartXYSeriesBarViewInfo.Create(AOwner: TdxChartSeriesCustomView);
begin
  inherited Create(AOwner);
  FHighlightingFillOptions := TdxFillOptions.Create(nil);
  FHighlightingFillOptions.Mode := TdxFillOptionsMode.Hatch;
  FHighlightingFillOptions.HatchStyle := TdxFillOptionsHatchStyle.BackwardDiagonal;
  FHighlightingFillOptions.Color := TdxAlphaColors.Transparent;
  FHighlightingFillOptions.Color2 := $E0FFFFFF;
end;

function TdxChartXYSeriesBarViewInfo.CalculateBarWidth: Single;
begin
  if Index = 0 then
  begin
    Result := TickInterval;
    if Result = 0 then
      Result := AxisXWidth;
    Result := Max(1, Max(1, Result / GetBarsCount - GetActualDistance) * View.BarWidth / 100);
  end
  else
    Result := TdxChartXYSeriesBarView(Group.Views[0]).ViewInfo.BarWidth;
end;

destructor TdxChartXYSeriesBarViewInfo.Destroy;
begin
  FreeAndNil(FHighlightingFillOptions);
  inherited Destroy;
end;

procedure TdxChartXYSeriesBarViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
begin
  FActualBrush := Appearance.ActualBrush;
  FActualPen := Appearance.ActualPen;
  FBarWidth := CalculateBarWidth;
  FSingleLine := SameValue(FBarWidth, 1);
  FBarOffset := (FBarWidth + GetActualDistance) * GetActualIndex  -
    ((FBarWidth  + GetActualDistance) * GetBarsCount - GetActualDistance) / 2;
  inherited DoCalculate(ACanvas);
end;

procedure TdxChartXYSeriesBarViewInfo.DrawHighlightedValue(ACanvas: TcxCustomCanvas;
  const AValue: TdxChartXYSeriesValueViewInfo);
var
  ABarValue: TdxChartXYSeriesBarValueViewInfo absolute AValue;
begin
  if not ACanvas.RectVisible(ABarValue.BarBounds) then
    Exit;
  ACanvas.EnableAntialiasing(False);
  ACanvas.FillRect(ABarValue.BarBounds, FActualBrush);
  ACanvas.FillRect(ABarValue.BarBounds, FHighlightingFillOptions.GetHandle(ACanvas));
  if not FSingleLine then
    ACanvas.FrameRect(ABarValue.BarBounds, TcxCanvasBasedPenHandle(FActualPen.Handle).Color, TcxCanvasBasedPenHandle(FActualPen.Handle).Width);
  ACanvas.RestoreAntialiasing;
end;

procedure TdxChartXYSeriesBarViewInfo.DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF);
begin
  ACanvas.EnableAntialiasing(False);
  ACanvas.FillRect(R, Appearance.ActualBrush);
  ACanvas.FrameRect(R, TcxCanvasBasedPenHandle(LegendGlyphPen.Handle).Color, TcxCanvasBasedPenHandle(LegendGlyphPen.Handle).Width);
  ACanvas.RestoreAntialiasing;
end;

procedure TdxChartXYSeriesBarViewInfo.DrawValue(ACanvas: TcxCustomCanvas; const AValue: TdxChartSeriesValueViewInfo);
begin
  AValue.Draw(ACanvas);
end;

function TdxChartXYSeriesBarViewInfo.GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass;
begin
  Result := TdxChartXYSeriesBarValueViewInfo;
end;

function TdxChartXYSeriesBarViewInfo.GetAppearance: TdxChartXYSeriesBarAppearance;
begin
  Result := TdxChartXYSeriesBarAppearance(inherited Appearance);
end;

function TdxChartXYSeriesBarViewInfo.GetActualDistance: Single;
begin
  Result := 0;
  if (View.GetValuesStacking = TdxChartXYSeriesBarView.TValuesStacking.None) and (Group <> nil) then
    Result := TdxChartXYSeriesBarView(Group.Views[0]).BarDistance + 1;
end;

function TdxChartXYSeriesBarViewInfo.GetActualIndex: Integer;
begin
  Result := 0;
  if GetBarsCount > 1 then
  begin
    Result := FIndex;
    if Rotated then
      Result := GetBarsCount - 1 - FIndex;
  end;
end;

function TdxChartXYSeriesBarViewInfo.GetBarsCount: Integer;
begin
  Result := 1;
  if (View.GetValuesStacking = TdxChartXYSeriesBarView.TValuesStacking.None) and (Group <> nil) then
    Result := Max(Result, Group.Count);
end;

function TdxChartXYSeriesBarViewInfo.GetMaxLegendGlyphPenWidth: Single;
begin
  Result := Appearance.ScaleFactor.ApplyF(3);
end;

function TdxChartXYSeriesBarViewInfo.GetLegendItemColor: TdxAlphaColor;
begin
   Result:= Appearance.ActualColor;
end;

function TdxChartXYSeriesBarViewInfo.GetView: TdxChartXYSeriesBarView;
begin
  Result := TdxChartXYSeriesBarView(inherited View);
end;

function TdxChartXYSeriesBarViewInfo.IsPointAppropriateForCrosshair(APoint: TdxPointF;
  ANearestValue: TdxChartXYSeriesValueViewInfo; AMode: TdxChartCrosshairSnapToPointMode): Boolean;

  function GetArgumentCoordinate(P: TdxPointF): Single;
  begin
    Result := IfThen(Diagram.Rotated, P.Y, P.X);
  end;

  function GetValueCoordinate(P: TdxPointF): Single;
  begin
    Result := IfThen(Diagram.Rotated, P.X, P.Y);
  end;
var
  AViewData: TdxChartXYSeriesViewCustomViewData;
  AReverseAxis: Boolean;
begin
  AViewData := TdxChartXYSeriesViewCustomViewData(ViewData);
  case AMode of
    TdxChartCrosshairSnapToPointMode.Argument:
      Result := Abs(GetArgumentCoordinate(APoint) - GetArgumentCoordinate(ANearestValue.DisplayValue) + BarOffset) <= (BarWidth * Group.Count + GetActualDistance * (Group.Count - 1))/ 2;
    TdxChartCrosshairSnapToPointMode.Value:
      begin
        AReverseAxis := Diagram.Axes.AxisY.Reverse;
        Result := ((GetValueCoordinate(APoint) >= FValueToCanvasValue(Max(0, AViewData.StackedValueMax.Value))) xor AReverseAxis) and
                  ((GetValueCoordinate(APoint) <= FValueToCanvasValue(Min(0, AViewData.StackedValueMin.Value))) xor AReverseAxis);
     end;
  else
    Result := inherited IsPointAppropriateForCrosshair(APoint, ANearestValue, AMode);
  end;
end;

{ TdxChartXYSeriesStackedBarView }

class function TdxChartXYSeriesStackedBarView.CanAggregate(AView: TdxChartSeriesCustomView): Boolean;
begin
  Result := IsEqual(AView);
end;

class function TdxChartXYSeriesStackedBarView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlStackedBarDisplayName);
end;

class function TdxChartXYSeriesStackedBarView.IsCompatibleWith(AView: TdxChartSeriesCustomView): Boolean;
begin
  Result := IsEqual(AView);
end;

class function TdxChartXYSeriesStackedBarView.GetNegativeValuesStackingStyle: TdxChartXYSeriesStackedBarView.TNegativeValuesStackingStyle;
begin
  Result := TdxChartXYSeriesCustomView.TNegativeValuesStackingStyle.StackAlways;
end;

{ TdxChartXYSeriesFullStackedBarView }

class function TdxChartXYSeriesFullStackedBarView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlFullStackedBarDisplayName);
end;

{ TdxChartXYSeriesBarValueLabelViewInfo }

function TdxChartXYSeriesBarValueLabelViewInfo.GetValidRect: TdxRectF;
begin
  Result := TdxChartXYSeriesBarValueViewInfo(Owner).BarBounds;
end;

{ TdxChartXYSeriesBarValueLabels }

constructor TdxChartXYSeriesBarValueLabels.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FResolveOverlappingMode := TdxChartSeriesValueLabelsResolveOverlappingMode.Default;
end;

procedure TdxChartXYSeriesBarValueLabels.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYSeriesBarValueLabels then
    FResolveOverlappingMode := TdxChartXYSeriesBarValueLabels(Source).ResolveOverlappingMode;
end;

function TdxChartXYSeriesBarValueLabels.GetResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode;
begin
  Result := FResolveOverlappingMode;
end;

procedure TdxChartXYSeriesBarValueLabels.SetResolveOverlappingMode(
  AValue: TdxChartSeriesBarValueLabelsResolveOverlappingMode);
begin
  if AValue <> ResolveOverlappingMode then
  begin
    FResolveOverlappingMode := AValue;
    LayoutChanged;
  end;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartXYSeriesBarView.Register;
  TdxChartXYSeriesStackedBarView.Register;
//  TdxChartXYSeriesStackedBarSideBySideView.Register;
  TdxChartXYSeriesFullStackedBarView.Register;
//  TdxChartXYSeriesFullStackedBarSideBySideView.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartXYSeriesBarView.UnRegister;
  TdxChartXYSeriesStackedBarView.UnRegister;
//  TdxChartXYSeriesStackedBarSideBySideView.UnRegister;
  TdxChartXYSeriesFullStackedBarView.UnRegister;
//  TdxChartXYSeriesFullStackedBarSideBySideView.UnRegister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
