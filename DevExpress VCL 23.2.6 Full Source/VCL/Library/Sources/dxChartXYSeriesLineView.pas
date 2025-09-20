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

unit dxChartXYSeriesLineView;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  Types, Math, Classes, SysUtils, Controls, Graphics, Generics.Collections, Generics.Defaults, Windows,
  dxCore, dxCoreClasses, cxClasses, cxGraphics, cxGeometry, cxCustomCanvas, dxCoreGraphics,
  dxChartCore, dxChartXYDiagram, dxChartMarkers, dxChartStrs;

type
  TdxChartXYSeriesLineView = class;
  TdxChartXYSeriesStackedLineView = class;
  TdxChartXYSeriesFullStackedLineView = class;
  TdxChartXYSeriesLineViewInfo = class;

  TdxChartXYMarkerKind = (Circle, Square, Diamond, Triangle, InvertedTriangle, Plus, Cross, Star, Pentagon, Hexagon);

  TdxChartSeriesLineOptimization = (Default, None, RemoveOverlaps, PiecewiseLinear, Full);

  TdxChartSeriesLineValueLabelsResolveOverlappingMode =
    TdxChartSeriesValueLabelsResolveOverlappingMode.None..TdxChartSeriesValueLabelsResolveOverlappingMode.JustifyAllAroundPoint;

  { TdxChartPolyline }

  TdxChartPolyline = class
  strict private
    FCanvas: TcxCustomCanvas;
    FCapacity: Integer;
    FPen: TcxCanvasBasedPen;
    FPointCount: Integer;
    FPoints: array of TdxPointF;

    procedure SetCapacity(ACapacity: Integer);
  public
    procedure Append(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen);
    procedure EnsureCapacity(ALineCount: Integer);
    procedure Initialize(ACanvas: TcxCustomCanvas);
    procedure Output;
  end;

  { TdxChartXYSeriesLineAppearance }

  TdxChartXYSeriesLineAppearance = class(TdxChartSeriesViewAppearance)
  protected
    function DefaultParentBackground: Boolean; override;
    function HasStrokeOptions: Boolean; override;
  published
    property StrokeOptions;
  end;

  { TdxChartXYSeriesLineMarkerAppearance }

  TdxChartXYSeriesLineMarkerAppearance = class(TdxChartVisualElementAppearance)
  strict private const
    DefaultBorderColorFactor = 235;
  strict private
    function GetView: TdxChartXYSeriesLineView;
  protected
    function DefaultBorder: Boolean; override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function HasFillOptions: Boolean; override;

    property View: TdxChartXYSeriesLineView read GetView;
  published
    property Border;
    property BorderColor;
    property FillOptions;
  end;

  { TdxChartXYSeriesLineMarkers }

  TdxChartXYSeriesLineMarkers = class(TdxChartVisualElementPersistent)
  public const
    DefaultMarkerSize: Integer = 9;
  strict private
    FKind: TdxChartXYMarkerKind;
    FSize: Single;

    function GetAppearance: TdxChartXYSeriesLineMarkerAppearance; inline;
    function GetView: TdxChartXYSeriesLineView; inline;
    procedure SetAppearance(AValue: TdxChartXYSeriesLineMarkerAppearance);
    procedure SetKind(AValue: TdxChartXYMarkerKind);
    procedure SetSize(AValue: Single);
    //
    function IsSizeStored: Boolean;
  protected
    function ActuallyVisible: Boolean; override;
    procedure ChangeScale(M, D: Integer); override;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetDefaultVisible: Boolean; override;
    function GetParentElement: IdxChartVisualElement; override;

    property View: TdxChartXYSeriesLineView read GetView;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property Appearance: TdxChartXYSeriesLineMarkerAppearance read GetAppearance write SetAppearance;
    property Size: Single read FSize write SetSize stored IsSizeStored;
    property Kind: TdxChartXYMarkerKind read FKind write SetKind default TdxChartXYMarkerKind.Circle;
    property Visible;
  end;

  { TdxChartXYSeriesLineView }

  TdxChartXYSeriesLineView = class(TdxChartXYSeriesCustomView)
  strict private
    FMarkers: TdxChartXYSeriesLineMarkers;
    FOptimization: TdxChartSeriesLineOptimization;
    function GetAppearance: TdxChartXYSeriesLineAppearance; inline;
    procedure SetAppearance(AValue: TdxChartXYSeriesLineAppearance);
    procedure SetMarkers(AValue: TdxChartXYSeriesLineMarkers);
    procedure SetOptimization(AValue: TdxChartSeriesLineOptimization);
  protected
    procedure ChangeScale(M, D: Integer); override;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function CreateMarkers: TdxChartXYSeriesLineMarkers; virtual;
    function CreateValueLabels: TdxChartSeriesValueLabels; override;
    function CreateViewInfo: TdxChartSeriesViewCustomViewInfo; override;
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    class function GetDescription: string; override;
  published
    property Appearance: TdxChartXYSeriesLineAppearance read GetAppearance write SetAppearance;
    property Markers: TdxChartXYSeriesLineMarkers read FMarkers write SetMarkers;
    property Optimization: TdxChartSeriesLineOptimization read FOptimization write SetOptimization default TdxChartSeriesLineOptimization.Default;
    property ValueLabels;
  end;

  { TdxChartXYSeriesLineValueViewInfo }

  TdxChartXYSeriesLineValueViewInfo = class(TdxChartXYSeriesValueViewInfo)
  strict private
    function GetOwner: TdxChartXYSeriesLineViewInfo; inline;
    function GetNext: TdxChartXYSeriesLineValueViewInfo; inline;
    function GetPrior: TdxChartXYSeriesLineValueViewInfo; inline;
  protected
    FMarkerBounds: TdxRectF;
    procedure CalculateLabelLeaderLinePoints(var AStartPoint, AMiddlePoint, AEndPoint: TdxPointF); override;
    procedure CalculateMarkerBounds(const AHalfSize: Single); inline;
    function CreateValueLabel: TdxChartValueLabelCustomViewInfo; override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetLabelAnchorPoint: TdxPointF; override;
    function GetMarkerHitElement(const P: TdxPointF): IdxChartHitTestElement;
    function NextDisplayValue: TdxChartXYSeriesLineValueViewInfo; inline;
    function PriorDisplayValue: TdxChartXYSeriesLineValueViewInfo; inline;

    property Owner: TdxChartXYSeriesLineViewInfo read GetOwner;
  public
    property BaseDisplayValue: Single read FBaseDisplayValue;
    property MarkerBounds: TdxRectF read FMarkerBounds;
    property Next: TdxChartXYSeriesLineValueViewInfo read GetNext;
    property Prior: TdxChartXYSeriesLineValueViewInfo read GetPrior;
  end;

  { TdxChartXYSeriesLineValueLabels }

  TdxChartXYSeriesLineValueLabels = class(TdxChartXYSeriesValueLabels)
  strict private
    FResolveOverlappingMode: TdxChartSeriesLineValueLabelsResolveOverlappingMode;
    procedure SetResolveOverlappingMode(AValue: TdxChartSeriesLineValueLabelsResolveOverlappingMode);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode; override;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property ResolveOverlappingMode: TdxChartSeriesLineValueLabelsResolveOverlappingMode read FResolveOverlappingMode write SetResolveOverlappingMode
      default TdxChartSeriesValueLabelsResolveOverlappingMode.Default;
  end;

  { TdxChartXYSeriesLineValueLabelViewInfo }

  TdxChartXYSeriesLineValueLabelViewInfo = class(TdxChartXYSeriesValueLabelViewInfo)
  protected
    function GetExcludedBounds: TdxRectF; override;
  end;

  { TdxChartXYSeriesLineViewInfo }

  TdxChartXYSeriesLineViewInfo = class(TdxChartXYSeriesViewCustomViewInfo)
  strict private const
    HighlightedMarkerIncrease = 3;
  strict private
    FLabelOffset: Single;
    function GetAppearance: TdxChartXYSeriesLineAppearance; inline;
    function GetView: TdxChartXYSeriesLineView; inline;
  protected
    FActualPen: TcxCanvasBasedPen;
    FActualPenWidth: Single;
    FHighlightedMarker: TdxChartMarkerViewInfo;
    FOptimization: TdxChartSeriesLineOptimization;
    FMarker: TdxChartMarkerViewInfo;
    FMarkerHalfSize: Single;
    FMarkersVisible: Boolean;
    FPolyline: TdxChartPolyline;

    procedure CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo); override;
    procedure CalculateValues(ACanvas: TcxCustomCanvas); override;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DrawHighlightedValue(ACanvas: TcxCustomCanvas; const AValue: TdxChartXYSeriesValueViewInfo); override;
    procedure DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF); override;
    procedure DrawMarker(ACanvas: TcxCustomCanvas; AValue: TdxChartXYSeriesLineValueViewInfo); virtual;
    procedure DrawSegment(ACanvas: TcxCustomCanvas; AValue1, AValue2: TdxChartXYSeriesLineValueViewInfo); virtual;
    procedure DrawValue(ACanvas: TcxCustomCanvas; const AValue: TdxChartSeriesValueViewInfo); override;
    procedure DrawValues(ACanvas: TcxCustomCanvas); override;
    procedure EnableExportMode(AEnable: Boolean); override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetMaxLegendGlyphPenWidth: Single; override;
    function GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass; override;
    function NeedValuesResampling: Boolean; override;
    procedure ResampleValues(const AStartValue, AFinishValue: TdxChartSeriesValueViewInfo); override;
    procedure ValidateValueLabels; override;

    property LabelOffset: Single read FLabelOffset;
    property MarkersVisible: Boolean read FMarkersVisible;
  public
    constructor Create(AOwner: TdxChartSeriesCustomView); override;
    destructor Destroy; override;

    property Appearance: TdxChartXYSeriesLineAppearance read GetAppearance;
    property Optimization: TdxChartSeriesLineOptimization read FOptimization;
    property View: TdxChartXYSeriesLineView read GetView;
  end;

  { TdxChartXYSeriesStackedLineView }

  TdxChartXYSeriesStackedLineView = class(TdxChartXYSeriesLineView)
  public
    class function GetDescription: string; override;
  end;

  { TdxChartXYSeriesFullStackedLineView }

  TdxChartXYSeriesFullStackedLineView = class(TdxChartXYSeriesStackedLineView)
  public
    class function GetDescription: string; override;
  end;

implementation

const
  dxThisUnitName = 'dxChartXYSeriesLineView';

type
  TdxChartAccess = class(TdxChart);

const
  XYMarkerKind2MarkerKind: array[TdxChartXYMarkerKind] of TdxChartMarkerKind = (
    TdxChartMarkerKind.Circle, TdxChartMarkerKind.Square, TdxChartMarkerKind.Diamond,
    TdxChartMarkerKind.Triangle, TdxChartMarkerKind.InvertedTriangle, TdxChartMarkerKind.Plus,
    TdxChartMarkerKind.Cross, TdxChartMarkerKind.Star5, TdxChartMarkerKind.Pentagon,
    TdxChartMarkerKind.Hexagon);

function dxOneLinePoints(const K, B: Single; const P: TdxPointF; const AEpsilon: Single): Boolean; inline;
begin
  Result := Abs(K * P.X - P.Y + B) / Sqrt(1 + Sqr(K)) <= AEpsilon;
end;

{ TdxChartPolyline }

procedure TdxChartPolyline.Append(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen);
begin
  if FPen <> APen then
    Output;
  if FPointCount + 2 > FCapacity then
    SetCapacity((3 * FCapacity) div 2);

  FPen := APen;
  FPoints[FPointCount] := P1;
  Inc(FPointCount);
  FPoints[FPointCount] := P2;
  Inc(FPointCount);
end;

procedure TdxChartPolyline.EnsureCapacity(ALineCount: Integer);
begin
  SetCapacity(2 * ALineCount);
end;

procedure TdxChartPolyline.Initialize(ACanvas: TcxCustomCanvas);
begin
  FCanvas := ACanvas;
  FPointCount := 0;
  FPen := nil;
end;

procedure TdxChartPolyline.Output;
begin
  if FPointCount > 0 then
    FCanvas.Polyline(@FPoints[0], FPointCount, FPen);
  FPointCount := 0;
end;

procedure TdxChartPolyline.SetCapacity(ACapacity: Integer);
begin
  if ACapacity <> FCapacity then
  begin
    FCapacity := ACapacity;
    FPointCount := Min(FPointCount, FCapacity);
    SetLength(FPoints, FCapacity);
  end;
end;

{ TdxChartXYSeriesLineAppearance }

function TdxChartXYSeriesLineAppearance.DefaultParentBackground: Boolean;
begin
  Result := False;
end;

function TdxChartXYSeriesLineAppearance.HasStrokeOptions: Boolean;
begin
  Result := True;
end;

{ TdxChartXYSeriesLineMarkerAppearance }

function TdxChartXYSeriesLineMarkerAppearance.DefaultBorder: Boolean;
begin
  Result := True;
end;

function TdxChartXYSeriesLineMarkerAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartXYSeriesLineMarkerAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  Result := View.Appearance.GetActualColor(AIndex);
  if AIndex = BorderColorIndex then
  begin
    Result := TdxAlphaColors.FromArgb(TdxAlphaColors.R(Result) * DefaultBorderColorFactor div 255,
                                      TdxAlphaColors.G(Result) * DefaultBorderColorFactor div 255,
                                      TdxAlphaColors.B(Result) * DefaultBorderColorFactor div 255
                                     );
  end;
end;

function TdxChartXYSeriesLineMarkerAppearance.GetView: TdxChartXYSeriesLineView;
begin
  Result := TdxChartXYSeriesLineMarkers(Owner).View;
end;

{ TdxChartXYSeriesLineMarkers }

constructor TdxChartXYSeriesLineMarkers.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FSize := DefaultMarkerSize;
end;

function TdxChartXYSeriesLineMarkers.ActuallyVisible: Boolean;
begin
  Result := Visible and View.ActuallyVisible;
end;

procedure TdxChartXYSeriesLineMarkers.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  FSize := dxScale(FSize, M, D);
end;

function TdxChartXYSeriesLineMarkers.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartXYSeriesLineMarkerAppearance.Create(Self);
end;

procedure TdxChartXYSeriesLineMarkers.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYSeriesLineMarkers then
  begin
    Kind := TdxChartXYSeriesLineMarkers(Source).Kind;
    Size := TdxChartXYSeriesLineMarkers(Source).Size;
  end;
end;

function TdxChartXYSeriesLineMarkers.GetAppearance: TdxChartXYSeriesLineMarkerAppearance;
begin
  Result := TdxChartXYSeriesLineMarkerAppearance(inherited Appearance);
end;

function TdxChartXYSeriesLineMarkers.GetDefaultVisible: Boolean;
begin
  Result := False;
end;

function TdxChartXYSeriesLineMarkers.GetParentElement: IdxChartVisualElement;
begin
  Result := View;
end;

function TdxChartXYSeriesLineMarkers.GetView: TdxChartXYSeriesLineView;
begin
  Result := TdxChartXYSeriesLineView(Owner);
end;

procedure TdxChartXYSeriesLineMarkers.SetAppearance(AValue: TdxChartXYSeriesLineMarkerAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartXYSeriesLineMarkers.SetKind(AValue: TdxChartXYMarkerKind);
begin
  if AValue <> FKind then
  begin
    FKind := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartXYSeriesLineMarkers.SetSize(AValue: Single);
begin
  AValue := Max(AValue, 1);
  if AValue <> FSize then
  begin
    FSize := AValue;
    LayoutChanged;
  end;
end;

function TdxChartXYSeriesLineMarkers.IsSizeStored: Boolean;
begin
  Result := not SameValue(FSize, DefaultMarkerSize);
end;

{ TdxChartXYSeriesLineView }

constructor TdxChartXYSeriesLineView.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FMarkers := CreateMarkers;
end;

destructor TdxChartXYSeriesLineView.Destroy;
begin
  FreeAndNil(FMarkers);
  inherited Destroy;
end;

class function TdxChartXYSeriesLineView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlLineDisplayName);
end;

procedure TdxChartXYSeriesLineView.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYSeriesLineView then
  begin
    FOptimization := TdxChartXYSeriesLineView(Source).Optimization;
    Markers := TdxChartXYSeriesLineView(Source).Markers;
  end;
end;

function TdxChartXYSeriesLineView.GetAppearance: TdxChartXYSeriesLineAppearance;
begin
  Result := TdxChartXYSeriesLineAppearance(inherited Appearance);
end;

procedure TdxChartXYSeriesLineView.SetAppearance(AValue: TdxChartXYSeriesLineAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartXYSeriesLineView.SetMarkers(AValue: TdxChartXYSeriesLineMarkers);
begin
  Markers.Assign(AValue);
end;

procedure TdxChartXYSeriesLineView.SetOptimization(AValue: TdxChartSeriesLineOptimization);
begin
  if AValue <> FOptimization then
  begin
    FOptimization := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartXYSeriesLineView.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  Markers.ChangeScale(M, D);
end;

function TdxChartXYSeriesLineView.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartXYSeriesLineAppearance.Create(Self);
end;

function TdxChartXYSeriesLineView.CreateMarkers: TdxChartXYSeriesLineMarkers;
begin
  Result := TdxChartXYSeriesLineMarkers.Create(Self);
end;

function TdxChartXYSeriesLineView.CreateValueLabels: TdxChartSeriesValueLabels;
begin
  Result := TdxChartXYSeriesLineValueLabels.Create(Self);
end;

function TdxChartXYSeriesLineView.CreateViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
  Result := TdxChartXYSeriesLineViewInfo.Create(Self);
end;

{ TdxChartXYSeriesLineValueViewInfo }

function TdxChartXYSeriesLineValueViewInfo.GetOwner: TdxChartXYSeriesLineViewInfo;
begin
  Result := TdxChartXYSeriesLineViewInfo(inherited Owner);
end;

procedure TdxChartXYSeriesLineValueViewInfo.CalculateLabelLeaderLinePoints(
  var AStartPoint, AMiddlePoint, AEndPoint: TdxPointF);
begin
  AStartPoint := DisplayValue;
  AMiddlePoint := DisplayValue;
  if Owner.Rotated then
    AMiddlePoint.X := AMiddlePoint.X + Owner.LabelOffset
  else
    AMiddlePoint.Y := AMiddlePoint.Y - Owner.LabelOffset;
  AEndPoint := TdxPointF.Null;
end;

procedure TdxChartXYSeriesLineValueViewInfo.CalculateMarkerBounds(const AHalfSize: Single);
begin
  FMarkerBounds.Left := DisplayValue.X - AHalfSize;
  FMarkerBounds.Top := DisplayValue.Y - AHalfSize;
  FMarkerBounds.Right := DisplayValue.X + AHalfSize;
  FMarkerBounds.Bottom := DisplayValue.Y + AHalfSize;
end;

function TdxChartXYSeriesLineValueViewInfo.CreateValueLabel: TdxChartValueLabelCustomViewInfo;
begin
  Result := TdxChartXYSeriesLineValueLabelViewInfo.Create(Self);
end;

function TdxChartXYSeriesLineValueViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
  function Production(const P, A, B: TdxPointF): Single; inline
  begin
    Result := (B.X - A.X) * (P.Y - A.Y) - (B.Y - A.Y) * (P.X - A.X);
  end;
var
  ASegmentLength: Single;
  AThicknessVector: TdxPointF;
  P2: TdxPointF;
  AFactor: Single;
  AVertices: array[0..3] of TdxPointF;
  AOnSegment: Boolean;
begin
  Result := nil;
  if not SegmentStart then
  begin
    P2 := PriorDisplayValue.DisplayValue;
    ASegmentLength := TdxVectors.Length(DisplayValue, P2);
    if not IsZero(ASegmentLength) then
    begin
      AFactor := TdxChartXYSeriesLineViewInfo(Owner).FActualPenWidth / ASegmentLength / 2;
      AThicknessVector := TdxPointF.Create(-(P2.Y - DisplayValue.Y) * AFactor, (P2.X - DisplayValue.X) * AFactor);
      AVertices[0] := TdxPointF.Create(P2.X + AThicknessVector.X, P2.Y + AThicknessVector.Y);
      AVertices[1] := TdxPointF.Create(P2.X - AThicknessVector.X, P2.Y - AThicknessVector.Y);
      AVertices[2] := TdxPointF.Create(DisplayValue.X - AThicknessVector.X, DisplayValue.Y - AThicknessVector.Y);
      AVertices[3] := TdxPointF.Create(DisplayValue.X + AThicknessVector.X, DisplayValue.Y + AThicknessVector.Y);
      if Production(P, AVertices[3], AVertices[0]) > 0 then
        AOnSegment := (Production(P, AVertices[0], AVertices[1]) > 0) and (Production(P, AVertices[1], AVertices[2]) > 0) and (Production(P, AVertices[2], AVertices[3]) > 0)
      else
        AOnSegment := (Production(P, AVertices[0], AVertices[1]) < 0) and (Production(P, AVertices[1], AVertices[2]) < 0) and (Production(P, AVertices[2], AVertices[3]) < 0);
      if AOnSegment then
        Result := TdxChartSeriesHitElement.Create(TdxChartXYSeriesLineViewInfo(Owner).Series);
    end;
  end;
end;

function TdxChartXYSeriesLineValueViewInfo.GetLabelAnchorPoint: TdxPointF;
begin
  Result := inherited GetLabelAnchorPoint;
  if not Owner.Rotated then
    Result.Y := Result.Y - Owner.LabelOffset - (ValueLabel.Bounds.Height / 2)
  else
    Result.X := Result.X + Owner.LabelOffset + (ValueLabel.Bounds.Width / 2);
end;

function TdxChartXYSeriesLineValueViewInfo.GetMarkerHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  if FMarkerBounds.Contains(P) then
    Result := TdxChartSeriesPointHitElement.Create(CreateSeriesPointInfo, ToolTipText)
  else
    Result := nil;
end;

function TdxChartXYSeriesLineValueViewInfo.NextDisplayValue: TdxChartXYSeriesLineValueViewInfo;
begin
  Result := TdxChartXYSeriesLineValueViewInfo(FNextDisplayValue);
end;

function TdxChartXYSeriesLineValueViewInfo.PriorDisplayValue: TdxChartXYSeriesLineValueViewInfo;
begin
  Result := TdxChartXYSeriesLineValueViewInfo(FPriorDisplayValue);
end;

function TdxChartXYSeriesLineValueViewInfo.GetNext: TdxChartXYSeriesLineValueViewInfo;
begin
  Result := TdxChartXYSeriesLineValueViewInfo(inherited Next);
end;

function TdxChartXYSeriesLineValueViewInfo.GetPrior: TdxChartXYSeriesLineValueViewInfo;
begin
  Result := TdxChartXYSeriesLineValueViewInfo(inherited Prior);
end;

{ TdxChartXYSeriesLineViewInfo }

procedure TdxChartXYSeriesLineViewInfo.CalculateValues(ACanvas: TcxCustomCanvas);
begin
  inherited CalculateValues(ACanvas);
  ValidateValueLabels;
end;

constructor TdxChartXYSeriesLineViewInfo.Create(AOwner: TdxChartSeriesCustomView);
begin
  inherited Create(AOwner);
  FPolyline := TdxChartPolyline.Create;
  FMarker := TdxChartMarkerViewInfo.Create;
  FHighlightedMarker := TdxChartMarkerViewInfo.Create;
end;

destructor TdxChartXYSeriesLineViewInfo.Destroy;
begin
  FreeAndNil(FPolyline);
  FreeAndNil(FHighlightedMarker);
  FreeAndNil(FMarker);
  inherited Destroy;
end;

function TdxChartXYSeriesLineViewInfo.GetAppearance: TdxChartXYSeriesLineAppearance;
begin
  Result := TdxChartXYSeriesLineAppearance(inherited Appearance);
end;

function TdxChartXYSeriesLineViewInfo.GetView: TdxChartXYSeriesLineView;
begin
  Result := TdxChartXYSeriesLineView(inherited View);
end;

procedure TdxChartXYSeriesLineViewInfo.ResampleValues(const AStartValue, AFinishValue: TdxChartSeriesValueViewInfo);
type
  TLineType = (Horizontal, Vertical, Custom);

  procedure ExcludeOverlappedPoints(AEpsilon: Single);
  var
    P1, P2: TdxChartXYSeriesLineValueViewInfo;
  begin
    if AStartValue = AFinishValue then
      Exit;
    AEpsilon := Sqr(AEpsilon);

    P1 := TdxChartXYSeriesLineValueViewInfo(AStartValue);
    P2 := P1.NextDisplayValue;
    while P2 <> AFinishValue do
    begin
      if not P2.SegmentStart and not P2.SegmentFinish and (Sqr(P1.DisplayValue.X - P2.DisplayValue.X) + Sqr(P1.DisplayValue.Y - P2.DisplayValue.Y) <= AEpsilon) then
      begin
        P1.FNextDisplayValue := P2.NextDisplayValue;
        P2.NextDisplayValue.FPriorDisplayValue := P1;
        P2.FNextDisplayValue := nil;
        P2.FPriorDisplayValue := nil;
      end
      else
        P1 := P2;
      P2 := P1.NextDisplayValue;
    end;
  end;

  function GetK(const P1, P2: TdxChartXYSeriesLineValueViewInfo): Single; inline;
  begin
    Result := (P2.DisplayValue.Y - P1.DisplayValue.Y) / (P2.DisplayValue.X - P1.DisplayValue.X);
  end;

  procedure ExcludeOneLinePoints(AEpsilon: Single);
  var
    ADirection: Boolean;
    AIsOneLine: Boolean;
    ALineType: TLineType;
    K, B: single;
    P1, P2, P3: TdxChartXYSeriesLineValueViewInfo;
  begin
    if AStartValue = AFinishValue then
      Exit;
    P1 := TdxChartXYSeriesLineValueViewInfo(AStartValue);
    P2 := P1.NextDisplayValue;
    P3 := P2.NextDisplayValue;
    while P2 <> AFinishValue do
    begin
      K := 1;
      B := 0;

      if SameValue(P2.DisplayValue.X, P1.DisplayValue.X, 1e-4) then
      begin
        ADirection := P2.DisplayValue.Y > P1.DisplayValue.Y;
        ALineType := TLineType.Vertical;
      end
      else

      if SameValue(P2.DisplayValue.Y, P1.DisplayValue.Y, 1e-4) then
      begin
        ADirection := P2.DisplayValue.X > P1.DisplayValue.X;
        ALineType := TLineType.Horizontal;
      end
      else
      begin
        K := GetK(P1, P2);
        B := P1.DisplayValue.Y - K * P1.DisplayValue.X;
        ALineType := TLineType.Custom;
        ADirection := K > 0;
      end;

      repeat
        if P2.SegmentStart or P2.SegmentFinish then
          AIsOneLine := False
        else
        begin
          if ALineType = TLineType.Horizontal then
            AIsOneLine := ((P3.DisplayValue.X > P3.PriorDisplayValue.DisplayValue.X) = ADirection) and (Abs(P3.DisplayValue.Y - P1.DisplayValue.Y) <= AEpsilon)
          else if ALineType = TLineType.Vertical then
            AIsOneLine := ((P3.DisplayValue.Y > P3.PriorDisplayValue.DisplayValue.Y) = ADirection) and (Abs(P3.DisplayValue.X - P1.DisplayValue.X) <= AEpsilon)
          else
            AIsOneLine := ((GetK(P3.PriorDisplayValue, P3) > 0) = ADirection) and dxOneLinePoints(K, B, P3.DisplayValue, AEpsilon);
        end;
        if AIsOneLine then
        begin
          P1.FNextDisplayValue := P3;
          P3.FPriorDisplayValue := P1;
        end
        else begin
          P1 := P2;
        end;
        P2 := P3;
        P3 := P2.NextDisplayValue;
      until not AIsOneLine or (P2 = AFinishValue);
    end;
  end;

begin
  if FOptimization in [TdxChartSeriesLineOptimization.RemoveOverlaps, TdxChartSeriesLineOptimization.Full] then
    ExcludeOverlappedPoints(Appearance.StrokeOptions.Width / 2);
  if FOptimization in [TdxChartSeriesLineOptimization.PiecewiseLinear, TdxChartSeriesLineOptimization.Full] then
    ExcludeOneLinePoints(Appearance.StrokeOptions.Width / 2);
end;

procedure TdxChartXYSeriesLineViewInfo.CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo);
var
  AValueViewInfo: TdxChartXYSeriesLineValueViewInfo absolute AValue;
begin
  inherited CalculateCanvasValue(AValue);
  if FMarkersVisible then
    AValueViewInfo.CalculateMarkerBounds(FMarkerHalfSize);
end;

procedure TdxChartXYSeriesLineViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
begin
  FActualPen := Appearance.ActualPen;
  FActualPenWidth := Appearance.StrokeOptions.Width;
  FMarkersVisible := View.Markers.ActuallyVisible;
  FLabelOffset := ValueLabels.LineLength;
  FOptimization := View.Optimization;
  if FOptimization = TdxChartSeriesLineOptimization.Default then
  begin
    if Count > Bounds.Width * 2 then
      FOptimization := TdxChartSeriesLineOptimization.RemoveOverlaps
    else
      FOptimization := TdxChartSeriesLineOptimization.None;
  end;
  FMarkerHalfSize := View.Markers.Size / 2 + View.Markers.Appearance.ActualBorderThickness;
  if FMarkersVisible then
  begin
    FLabelOffset := FLabelOffset + FMarkerHalfSize;
    FMarker.Kind := XYMarkerKind2MarkerKind[View.Markers.Kind];
    FMarker.ForegroundColor := View.Markers.Appearance.ActualBorderColor;
    FMarker.FillOptions := View.Markers.Appearance.FillOptions;
    FMarker.StrokeColor := View.Markers.Appearance.ActualBorderColor;
  end;
  FHighlightedMarker.Kind := XYMarkerKind2MarkerKind[View.Markers.Kind];
  FHighlightedMarker.ForegroundColor := View.Markers.Appearance.ActualBorderColor;
  FHighlightedMarker.FillOptions := View.Markers.Appearance.FillOptions;
  FHighlightedMarker.StrokeColor := View.Markers.Appearance.ActualBorderColor;
  inherited DoCalculate(ACanvas);
  FPolyline.EnsureCapacity(Count);
end;

function TdxChartXYSeriesLineViewInfo.GetMaxLegendGlyphPenWidth: Single;
begin
  Result:= Appearance.ScaleFactor.ApplyF(15);
end;

procedure TdxChartXYSeriesLineViewInfo.DrawValues(ACanvas: TcxCustomCanvas);
var
  AValue: TdxChartXYSeriesLineValueViewInfo;
begin
  FPolyline.Initialize(ACanvas);
  inherited DrawValues(ACanvas);
  FPolyline.Output;
  if FMarkersVisible and (Count > 0) then
  begin
    AValue := TdxChartXYSeriesLineValueViewInfo(FFirstVisibleValue);
    while AValue <> nil do
    begin
      DrawMarker(ACanvas, AValue);
      AValue := AValue.NextDisplayValue;
    end;
  end;
end;

procedure TdxChartXYSeriesLineViewInfo.EnableExportMode(AEnable: Boolean);
begin
  inherited EnableExportMode(AEnable);
  FMarker.UseVectorDrawing := AEnable;
end;

procedure TdxChartXYSeriesLineViewInfo.DrawHighlightedValue(ACanvas: TcxCustomCanvas;
  const AValue: TdxChartXYSeriesValueViewInfo);
var
  AMarkerBounds: TdxRectF;
  AHalfSize: Single;
begin
  AHalfSize := FMarkerHalfSize + Appearance.ScaleFactor.Apply(HighlightedMarkerIncrease);
  AMarkerBounds.Left := AValue.DisplayValue.X - AHalfSize;
  AMarkerBounds.Top := AValue.DisplayValue.Y - AHalfSize;
  AMarkerBounds.Right := AValue.DisplayValue.X + AHalfSize;
  AMarkerBounds.Bottom := AValue.DisplayValue.Y + AHalfSize;
  if not ACanvas.RectVisible(AMarkerBounds) then
    Exit;
  FHighlightedMarker.Calculate(AMarkerBounds);
  FHighlightedMarker.Draw(ACanvas);
end;

procedure TdxChartXYSeriesLineViewInfo.DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF);
var
  AMarkerRect, ALineRect: TdxRectF;
  AMarkerSize: Single;
begin
  ALineRect := R.AlignVertically(dxSizeF(R.Width, 0), TdxAlignment.Center);
  ACanvas.Line(ALineRect.TopLeft, ALineRect.BottomRight, LegendGlyphPen);
  if FMarkersVisible then
  begin
    AMarkerSize := Min(R.Width * 2 / 3, R.Height);
    AMarkerRect := TdxRectF.CreateSize(0, 0, AMarkerSize, AMarkerSize);
    AMarkerRect.SetCenter(R.CenterPoint);
    FMarker.Calculate(AMarkerRect);
    FMarker.Draw(ACanvas);
  end;
end;

procedure TdxChartXYSeriesLineViewInfo.DrawMarker(ACanvas: TcxCustomCanvas; AValue: TdxChartXYSeriesLineValueViewInfo);
begin
  if not FMarkersVisible or not ACanvas.RectVisible(AValue.MarkerBounds) then
    Exit;
  FMarker.Calculate(AValue.MarkerBounds);
  FMarker.Draw(ACanvas);
end;

procedure TdxChartXYSeriesLineViewInfo.DrawSegment(
  ACanvas: TcxCustomCanvas; AValue1, AValue2: TdxChartXYSeriesLineValueViewInfo);
begin
  if AValue1.SegmentStart then
    FPolyline.Output;
  FPolyline.Append(AValue1.DisplayValue, AValue2.DisplayValue, FActualPen);
end;

procedure TdxChartXYSeriesLineViewInfo.DrawValue(
  ACanvas: TcxCustomCanvas; const AValue: TdxChartSeriesValueViewInfo);
var
  APoint: TdxChartXYSeriesLineValueViewInfo absolute AValue;
begin
  if not APoint.SegmentStart then
    DrawSegment(ACanvas, APoint.PriorDisplayValue, APoint);
end;

function TdxChartXYSeriesLineViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  Result := nil;
  if (Count > 0) and ActuallyVisible and FMarkersVisible then
  begin
    AValue := FLastVisibleValue;
    while AValue <> nil do
    begin
      Result := TdxChartXYSeriesLineValueViewInfo(AValue).GetMarkerHitElement(P);
      if Result <> nil then
        Break;
      AValue := AValue.PriorVisibleValue;
    end;
  end;
  if Result = nil then
    Result := inherited GetHitElement(P);
end;

function TdxChartXYSeriesLineViewInfo.GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass;
begin
  Result := TdxChartXYSeriesLineValueViewInfo;
end;

function TdxChartXYSeriesLineViewInfo.NeedValuesResampling: Boolean;
begin
  Result := FOptimization <> TdxChartSeriesLineOptimization.None;
end;

procedure TdxChartXYSeriesLineViewInfo.ValidateValueLabels;
var
  AValidBoundings: TdxRectF;
begin
  if not DrawLabels then
    Exit;
  AValidBoundings := DiagramViewInfo.PlotArea;
  ForEachVisibleValue(
    procedure(AValue: TdxChartSeriesValueViewInfo)
    var
      AXYValue: TdxChartXYSeriesValueViewInfo absolute AValue;
    begin
      if (AXYValue.ValueLabel <> nil) and not AValidBoundings.Contains(AXYValue.DisplayValue) then
        AXYValue.ValueLabel.Visible := False;
    end);
end;

{ TdxChartXYSeriesStackedLineView }

class function TdxChartXYSeriesStackedLineView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlStackedLineDisplayName);
end;

{ TdxChartXYSeriesFullStackedLineView }

class function TdxChartXYSeriesFullStackedLineView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlFullStackedLineDisplayName);
end;

{ TdxChartXYSeriesLineValueLabelViewInfo }

function TdxChartXYSeriesLineValueLabelViewInfo.GetExcludedBounds: TdxRectF;
begin
  Result.InitSize(Owner.DisplayValue.X, Owner.DisplayValue.Y, 0, 0);
  if TdxChartXYSeriesLineValueViewInfo(Owner).Owner.MarkersVisible then
    Result := TdxChartXYSeriesLineValueViewInfo(Owner).MarkerBounds;
  if not Result.Contains(MiddlePoint) then
    Result.Inflate(Options.LineLength - Result.Width / 2, Options.LineLength - Result.Height / 2);
end;

{ TdxChartXYSeriesLineValueLabels }

constructor TdxChartXYSeriesLineValueLabels.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FResolveOverlappingMode := TdxChartSeriesValueLabelsResolveOverlappingMode.Default;
end;

procedure TdxChartXYSeriesLineValueLabels.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYSeriesLineValueLabels then
    FResolveOverlappingMode := TdxChartXYSeriesLineValueLabels(Source).ResolveOverlappingMode;
end;

function TdxChartXYSeriesLineValueLabels.GetResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode;
begin
  Result := FResolveOverlappingMode;
end;

procedure TdxChartXYSeriesLineValueLabels.SetResolveOverlappingMode(
  AValue: TdxChartSeriesLineValueLabelsResolveOverlappingMode);
begin
  if AValue <> ResolveOverlappingMode then
  begin
    FResolveOverlappingMode := AValue;
    LayoutChanged;
  end;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartXYSeriesLineView.Register;
  TdxChartXYSeriesStackedLineView.Register;
  TdxChartXYSeriesFullStackedLineView.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartXYSeriesLineView.UnRegister;
  TdxChartXYSeriesStackedLineView.UnRegister;
  TdxChartXYSeriesFullStackedLineView.UnRegister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
