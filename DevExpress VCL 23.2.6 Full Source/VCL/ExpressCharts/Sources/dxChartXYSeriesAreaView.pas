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

unit dxChartXYSeriesAreaView;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  Types, Math, Classes, SysUtils, Controls, Graphics, dxCore, dxCoreClasses, cxClasses, cxGraphics,
  cxGeometry, cxCustomCanvas, dxCoreGraphics, dxChartCore, dxChartXYDiagram, dxChartXYSeriesLineView, dxChartStrs;

type
  TdxChartXYSeriesAreaView = class;
  TdxChartXYSeriesStackedAreaView = class;
  TdxChartXYSeriesFullStackedAreaView = class;

  TdxChartXYSeriesAreaAppearance = class(TdxChartXYSeriesLineAppearance)
  strict private
    FOpacity: Byte;
    function IsOpacityStored: Boolean;
    procedure SetOpacity(AValue: Byte);
  protected const
    DefaultOpacity: Byte = 135;
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function HasFillOptions: Boolean; override;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property FillOptions;
    property StrokeOptions;
    property Opacity: Byte read FOpacity write SetOpacity stored IsOpacityStored;
  end;

  { TdxChartXYSeriesAreaView }

  TdxChartXYSeriesAreaView = class(TdxChartXYSeriesLineView)
  private
    function GetAppearance: TdxChartXYSeriesAreaAppearance; inline;
    procedure SetAppearance(AValue: TdxChartXYSeriesAreaAppearance);
  protected
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function CreateViewInfo: TdxChartSeriesViewCustomViewInfo; override;
  public
    class function GetDescription: string; override;
  published
    property Appearance: TdxChartXYSeriesAreaAppearance read GetAppearance write SetAppearance;
    property Markers;
    property ValueLabels;
  end;

  TdxChartXYSeriesAreaValueViewInfo = class(TdxChartXYSeriesLineValueViewInfo)
  protected
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
  end;

  { TdxChartXYSeriesAreaViewInfo }

  TdxChartXYSeriesAreaViewInfo = class(TdxChartXYSeriesLineViewInfo)
  private
    function GetAppearance: TdxChartXYSeriesAreaAppearance; inline;
    function GetView: TdxChartXYSeriesAreaView; inline;
  protected
    FActualBrush: TcxCanvasBasedBrush;
    procedure CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo); override;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF); override;
    procedure DrawSegment(ACanvas: TcxCustomCanvas; AValue1, AValue2: TdxChartXYSeriesLineValueViewInfo); override;
    function GetMaxLegendGlyphPenWidth: Single; override;
    function GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass; override;
  public
    property Appearance: TdxChartXYSeriesAreaAppearance read GetAppearance;
    property View: TdxChartXYSeriesAreaView read GetView;
  end;

  { TdxChartXYSeriesStackedAreaView }

  TdxChartXYSeriesStackedAreaView = class(TdxChartXYSeriesAreaView)
  protected
    function IsZeroBased: Boolean; override;
  public
    class function GetDescription: string; override;
  end;

  { TdxChartXYSeriesStackedAreaView }

  TdxChartXYSeriesFullStackedAreaView = class(TdxChartXYSeriesAreaView)
  public
    class function GetDescription: string; override;
  end;

implementation

const
  dxThisUnitName = 'dxChartXYSeriesAreaView';

{ TdxChartXYSeriesAreaAppearance }

constructor TdxChartXYSeriesAreaAppearance.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FOpacity := DefaultOpacity;
end;

procedure TdxChartXYSeriesAreaAppearance.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYSeriesAreaAppearance then
    Opacity := TdxChartXYSeriesAreaAppearance(Source).Opacity;
end;

function TdxChartXYSeriesAreaAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  Result := inherited GetActualColor(AIndex);
  if (AIndex = ColorIndex) or (AIndex = BorderColorIndex) or (AIndex = Color2Index) then
    Result := TdxAlphaColors.FromArgb(Opacity, Result);
end;

function TdxChartXYSeriesAreaAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartXYSeriesAreaAppearance.IsOpacityStored: Boolean;
begin
  Result := FOpacity <> DefaultOpacity;
end;

procedure TdxChartXYSeriesAreaAppearance.SetOpacity(AValue: Byte);
begin
  if AValue <> FOpacity then
  begin
    FOpacity := AValue;
    Changed([TAppearanceChange.Color, TAppearanceChange.Fill]);
  end;
end;

{ TdxChartXYSeriesAreaView }

class function TdxChartXYSeriesAreaView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlAreaDisplayName);
end;

function TdxChartXYSeriesAreaView.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartXYSeriesAreaAppearance.Create(Self);
end;

function TdxChartXYSeriesAreaView.CreateViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
  Result := TdxChartXYSeriesAreaViewInfo.Create(Self);
end;

function TdxChartXYSeriesAreaView.GetAppearance: TdxChartXYSeriesAreaAppearance;
begin
  Result := TdxChartXYSeriesAreaAppearance(inherited Appearance);
end;

procedure TdxChartXYSeriesAreaView.SetAppearance(AValue: TdxChartXYSeriesAreaAppearance);
begin
  Appearance.Assign(AValue);
end;

{ TdxChartXYSeriesAreaViewInfo }

function TdxChartXYSeriesAreaViewInfo.GetAppearance: TdxChartXYSeriesAreaAppearance;
begin
  Result := TdxChartXYSeriesAreaAppearance(inherited Appearance);
end;

function TdxChartXYSeriesAreaViewInfo.GetMaxLegendGlyphPenWidth: Single;
begin
  Result:= Appearance.ScaleFactor.ApplyF(5);
end;

function TdxChartXYSeriesAreaViewInfo.GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass;
begin
  Result := TdxChartXYSeriesAreaValueViewInfo;
end;

function TdxChartXYSeriesAreaViewInfo.GetView: TdxChartXYSeriesAreaView;
begin
  Result := TdxChartXYSeriesAreaView(inherited View);
end;

procedure TdxChartXYSeriesAreaViewInfo.CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo);
var
  XYValue: TdxChartXYSeriesAreaValueViewInfo absolute AValue;
begin
  inherited CalculateCanvasValue(AValue);
  XYValue.FBaseDisplayValue := FValueToCanvasValue(XYValue.FBaseValue);
  if not XYValue.SegmentStart and not XYValue.SegmentFinish then
  begin
    if Diagram.Rotated then
      XYValue.FDisplayValue.Y := Round(XYValue.FDisplayValue.Y)
    else
      XYValue.FDisplayValue.X := Round(XYValue.FDisplayValue.X);
  end;
end;

procedure TdxChartXYSeriesAreaViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
begin
  FActualBrush := TdxChartXYSeriesAreaAppearance(Appearance).ActualBrush;
  inherited DoCalculate(ACanvas);
end;

procedure TdxChartXYSeriesAreaViewInfo.DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF);
begin
  ACanvas.Polygon([R.BottomLeft, R.TopCenter, R.BottomRight], FActualBrush, LegendGlyphPen);
end;

procedure TdxChartXYSeriesAreaViewInfo.DrawSegment(
  ACanvas: TcxCustomCanvas; AValue1, AValue2: TdxChartXYSeriesLineValueViewInfo);
var
  AStart, AFinish: TdxPointF;
  V1: TdxChartXYSeriesAreaValueViewInfo absolute AValue1;
  V2: TdxChartXYSeriesAreaValueViewInfo absolute AValue2;
begin
  if Diagram.Rotated then
  begin
    AStart := TdxPointF.Create(V1.FBaseDisplayValue, AValue1.DisplayValue.Y);
    AFinish := TdxPointF.Create(V2.FBaseDisplayValue, AValue2.DisplayValue.Y);
  end
  else
  begin
    AStart := TdxPointF.Create(AValue1.DisplayValue.X, V1.FBaseDisplayValue);
    AFinish := TdxPointF.Create(AValue2.DisplayValue.X, V2.FBaseDisplayValue);
  end;

  ACanvas.Polygon([AStart, AValue1.DisplayValue, AValue2.DisplayValue, AFinish], FActualBrush, nil);

  if AValue1.SegmentStart then
  begin
    FPolyline.Output;
    FPolyline.Append(AStart, AValue1.DisplayValue, FActualPen);
  end;

  FPolyline.Append(AValue1.DisplayValue, AValue2.DisplayValue, FActualPen);

  if AValue2.SegmentFinish then
    FPolyline.Append(AValue2.DisplayValue, AFinish, FActualPen);
end;

{ TdxChartXYSeriesStackedAreaView }

class function TdxChartXYSeriesStackedAreaView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlStackedAreaDisplayName);
end;

function TdxChartXYSeriesStackedAreaView.IsZeroBased: Boolean;
begin
  Result := True;
end;

{ TdxChartXYSeriesFullStackedAreaView }

class function TdxChartXYSeriesFullStackedAreaView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlFullStackedAreaDisplayName);
end;


{ TdxChartXYSeriesAreaValueViewInfo }

function TdxChartXYSeriesAreaValueViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
var
  X1, X2: Single;
  Y1, Y2: Single;
  ABaseY1, ABaseY2: Single;
  ALimit1, ALimit2: Single;
  AFactor: Single;
  X, Y: Single;
begin
  Result := inherited GetHitElement(P);
  if (Result = nil) and not SegmentStart then
  begin
    if Owner.Rotated then
    begin
      Y1 := PriorDisplayValue.DisplayValue.X;
      Y2 := DisplayValue.X;
      X1 := PriorDisplayValue.DisplayValue.Y;
      X2 := DisplayValue.Y;
      X := P.Y;
      Y := P.X;
    end
    else
    begin
      X1 := PriorDisplayValue.DisplayValue.X;
      X2 := DisplayValue.X;
      Y1 := PriorDisplayValue.DisplayValue.Y;
      Y2 := DisplayValue.Y;
      X := P.X;
      Y := P.Y;
    end;
    ABaseY1 := PriorDisplayValue.BaseDisplayValue;
    ABaseY2 := BaseDisplayValue;
    if SameValue(X1, X2) then
    begin
      if SameValue(X, X1) then
      begin
        ALimit1 := Min(Min(ABaseY1, ABaseY2), Min(Y1, Y2));
        ALimit2 := Max(Max(ABaseY1, ABaseY2), Max(Y1, Y2));
        if (Y >= ALimit1) and (Y < ALimit2) then
          Result := TdxChartSeriesHitElement.Create(TdxChartXYSeriesAreaViewInfo(Owner).Series);
      end;
    end
    else
    begin
      if (X >= Min(X1, X2)) and (X <= Max(X1, X2)) then
      begin
        AFactor := (X - X1) / (X2 - X1);
        ALimit1 := Y1 + AFactor * (Y2 - Y1);
        ALimit2 := ABaseY1 + AFactor * (ABaseY2 - ABaseY1);
        if (Y >= Min(ALimit1, ALimit2)) and (Y < Max(ALimit1, ALimit2)) then
          Result := TdxChartSeriesHitElement.Create(TdxChartXYSeriesAreaViewInfo(Owner).Series);
      end;
    end;
  end;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartXYSeriesAreaView.Register;
  TdxChartXYSeriesStackedAreaView.Register;
  TdxChartXYSeriesFullStackedAreaView.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartXYSeriesAreaView.UnRegister;
  TdxChartXYSeriesStackedAreaView.UnRegister;
  TdxChartXYSeriesFullStackedAreaView.UnRegister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
