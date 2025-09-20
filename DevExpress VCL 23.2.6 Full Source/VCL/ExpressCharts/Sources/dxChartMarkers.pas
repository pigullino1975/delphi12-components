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

unit dxChartMarkers;

{$I cxVer.inc}
{$R dxChartMarkers.res}
{$SCOPEDENUMS ON}

interface

uses
  Windows, Types, Classes, Graphics, dxCore, dxCoreGraphics, dxSVGCore, cxGeometry, dxGDIPlusClasses, cxCustomCanvas,
  dxTypeHelpers, dxDPIAwareUtils;

type
  TdxChartMarkerKind = (Square, Arrow, Circle, Cross, Diamond, Dollar, Drops, Hexagon,
    Pentagon, Plus, Ring, Star3, Star4, Star5, Star6, Star10, Triangle, InvertedTriangle);

  { TdxChartMarkerRepository }

  TdxChartMarkerRepository = class
  strict private const
    ImageResNameMap: array[TdxChartMarkerKind] of string = (
      'SQUARE', 'ARROW', 'CIRCLE', 'CROSS', 'DIAMOND', 'DOLLAR', 'DROPS', 'HEXAGON', 'PENTAGON',
      'PLUS', 'RING', '3STAR', '4STAR', '5STAR', '6STAR', '10STAR', 'TRIANGLE', 'INVERTEDTRIANGLE'
    );
    ImageResNamePrefix = 'DXCHART_MARKER_';
    ImageResType = 'DXCHART';
  strict private
    class var FImages: array[TdxChartMarkerKind] of TdxSVGElementRoot;

    class function GetItem(AKind: TdxChartMarkerKind): TdxSVGElementRoot; static;
  public
    class procedure Finalize; static;
    //
    class property Items[Kind: TdxChartMarkerKind]: TdxSVGElementRoot read GetItem;
  end;

  { TdxChartMarkerViewInfo }

  TdxChartMarkerViewInfo = class
  strict private const
    StrokeWidth = 1.0;
    SmoothingIndent = 1;
  strict private
    FBounds: TdxRectF;
    FFillOptions: TdxFillOptions;
    FForegroundColor: TdxAlphaColor;
    FImage: TcxCanvasBasedImage;
    FKind: TdxChartMarkerKind;
    FStrokeColor: TdxAlphaColor;
    FUseVectorDrawing: Boolean;

    function HasStroke: Boolean; inline;
    procedure SetFillOptions(AValue: TdxFillOptions);
    procedure SetForegroundColor(AValue: TdxAlphaColor);
    procedure SetKind(AValue: TdxChartMarkerKind);
    procedure SetStrokeColor(AValue: TdxAlphaColor);
  protected
    procedure Changed;
    function GetImage(ACanvas: TcxCustomCanvas): TcxCanvasBasedImage;
    function GetOriginalImage: TdxSVGElementRoot;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Calculate(const R: TdxRectF);
    procedure Draw(ACanvas: TcxCustomCanvas);
    function MeasureSize: TdxSizeF;

    property Bounds: TdxRectF read FBounds;
    property FillOptions: TdxFillOptions read FFillOptions write SetFillOptions;
    property ForegroundColor: TdxAlphaColor read FForegroundColor write SetForegroundColor;
    property Kind: TdxChartMarkerKind read FKind write SetKind;
    property StrokeColor: TdxAlphaColor read FStrokeColor write SetStrokeColor;
    property UseVectorDrawing: Boolean read FUseVectorDrawing write FUseVectorDrawing;
  end;

implementation

uses
  Math, SysUtils, dxXMLDoc, dxGDIPlusAPI;

const
  dxThisUnitName = 'dxChartMarkers';

type

  { TdxChartMarkerRenderBrush }

  TdxChartMarkerRenderBrushStyle = (Solid, Gradient, Texture, Hatch);

  TdxChartMarkerRenderBrush = class(TdxSVGBrush)
  strict private
    FHatchColor1: TdxAlphaColor;
    FHatchColor2: TdxAlphaColor;
    FHatchStyle: TdxGpHatchStyle;

    function GetStyle: TdxChartMarkerRenderBrushStyle;
    procedure SetHatchColor1(AValue: TdxAlphaColor);
    procedure SetHatchColor2(AValue: TdxAlphaColor);
    procedure SetHatchStyle(AValue: TdxGpHatchStyle);
    procedure SetStyle(AValue: TdxChartMarkerRenderBrushStyle);
  protected
    procedure DoCreateHandle(out AHandle: Pointer); override;
    function GetIsEmpty: Boolean; override;
  public
    constructor Create(AColor: TdxAlphaColor); overload;
    constructor Create(AOptions: TdxFillOptions); overload;
    procedure Assign(ASource: TdxGPCustomGraphicObject); override;
    //
    property HatchColor1: TdxAlphaColor read FHatchColor1 write SetHatchColor1;
    property HatchColor2: TdxAlphaColor read FHatchColor2 write SetHatchColor2;
    property HatchStyle: TdxGpHatchStyle read FHatchStyle write SetHatchStyle;
    property Style: TdxChartMarkerRenderBrushStyle read GetStyle write SetStyle;
  end;

  { TdxChartMarkerRender }

  TdxChartMarkerRender = class(TdxSVGRenderer)
  strict private
    FBackgroundFill: TdxChartMarkerRenderBrush;
    FForegroundFill: TdxChartMarkerRenderBrush;
    FStroke: TdxGPPen;
  protected
    function CreateBrush: TdxSVGBrush; override;
  public
    constructor Create(ACanvas: TdxGpCanvas; AFill: TdxFillOptions;
      AForegroundColor, AStrokeColor: TdxAlphaColor; AStrokeWidth: Single);
    destructor Destroy; override;
    procedure InitializeAppearance(AElement: TdxSVGElement); override;
  end;

{ TdxChartMarkerRenderBrush }

constructor TdxChartMarkerRenderBrush.Create(AColor: TdxAlphaColor);
begin
  Create;
  Color := AColor;
end;

constructor TdxChartMarkerRenderBrush.Create(AOptions: TdxFillOptions);
begin
  Create;
  case AOptions.Mode of
    TdxFillOptionsMode.Clear:
      begin
        Color := TdxAlphaColors.Empty;
        Style := TdxChartMarkerRenderBrushStyle.Solid;
      end;
    TdxFillOptionsMode.Solid:
      begin
        Color := AOptions.ActualColor;
        Style := TdxChartMarkerRenderBrushStyle.Solid;
      end;
    TdxFillOptionsMode.Texture:
      begin
        Texture := AOptions.Texture;
        Style := TdxChartMarkerRenderBrushStyle.Texture;
      end;
    TdxFillOptionsMode.Gradient:
      begin
        GradientPoints.Add(0, AOptions.ActualColor);
        GradientPoints.Add(1, AOptions.ActualColor2);
        GradientMode := sbgmNative;
        GradientModeNative := dxFillOptionsGradientModeToBrushGradientMode[AOptions.GradientMode];
        Style := TdxChartMarkerRenderBrushStyle.Gradient;
      end;
    TdxFillOptionsMode.Hatch:
      begin
        HatchColor1 := AOptions.ActualColor;
        HatchColor2 := AOptions.ActualColor2;
        HatchStyle := TdxGpHatchStyle(AOptions.HatchStyle);
        Style := TdxChartMarkerRenderBrushStyle.Hatch;
      end;
  end;
end;

procedure TdxChartMarkerRenderBrush.Assign(ASource: TdxGPCustomGraphicObject);
begin
  inherited;
  if ASource is TdxChartMarkerRenderBrush then
  begin
    HatchColor1 := TdxChartMarkerRenderBrush(ASource).HatchColor1;
    HatchColor2 := TdxChartMarkerRenderBrush(ASource).HatchColor2;
    HatchStyle := TdxChartMarkerRenderBrush(ASource).HatchStyle;
  end;
end;

procedure TdxChartMarkerRenderBrush.DoCreateHandle(out AHandle: Pointer);
begin
  case Style of
    TdxChartMarkerRenderBrushStyle.Solid:
      CreateSolidBrushHandle(AHandle, Color);
    TdxChartMarkerRenderBrushStyle.Gradient:
      CreateGradientBrushHandle(AHandle);
    TdxChartMarkerRenderBrushStyle.Texture:
      CreateTextureBrushHandle(AHandle);
    TdxChartMarkerRenderBrushStyle.Hatch:
      GdipCheck(GdipCreateHatchBrush(FHatchStyle, HatchColor1, HatchColor2, AHandle));
  end;
end;

function TdxChartMarkerRenderBrush.GetIsEmpty: Boolean;
begin
  if Style = TdxChartMarkerRenderBrushStyle.Hatch then
    Result := not (dxAlphaColorIsValid(HatchColor1) or dxAlphaColorIsValid(HatchColor2))
  else
    Result := inherited;
end;

function TdxChartMarkerRenderBrush.GetStyle: TdxChartMarkerRenderBrushStyle;
begin
  Result := TdxChartMarkerRenderBrushStyle(inherited Style);
end;

procedure TdxChartMarkerRenderBrush.SetHatchColor1(AValue: TdxAlphaColor);
begin
  if FHatchColor1 <> AValue then
  begin
    FHatchColor1 := AValue;
    if Style = TdxChartMarkerRenderBrushStyle.Hatch then
      FreeHandle;
    Changed;
  end;
end;

procedure TdxChartMarkerRenderBrush.SetHatchColor2(AValue: TdxAlphaColor);
begin
  if FHatchColor2 <> AValue then
  begin
    FHatchColor2 := AValue;
    if Style = TdxChartMarkerRenderBrushStyle.Hatch then
      FreeHandle;
    Changed;
  end;
end;

procedure TdxChartMarkerRenderBrush.SetHatchStyle(AValue: TdxGpHatchStyle);
begin
  if FHatchStyle <> AValue then
  begin
    FHatchStyle := AValue;
    if Style = TdxChartMarkerRenderBrushStyle.Hatch then
      FreeHandle;
    Changed;
  end;
end;

procedure TdxChartMarkerRenderBrush.SetStyle(AValue: TdxChartMarkerRenderBrushStyle);
begin
  inherited Style := TdxGpBrushStyle(AValue);
end;

{ TdxChartMarkerRender }

constructor TdxChartMarkerRender.Create(ACanvas: TdxGpCanvas;
  AFill: TdxFillOptions; AForegroundColor, AStrokeColor: TdxAlphaColor; AStrokeWidth: Single);
begin
  inherited Create(ACanvas);
  FStroke := TdxGPPen.Create(AStrokeColor, AStrokeWidth);
  FBackgroundFill := TdxChartMarkerRenderBrush.Create(AFill);
  FForegroundFill := TdxChartMarkerRenderBrush.Create(AForegroundColor);
  FCanvas.PixelOffsetMode := PixelOffsetModeHalf;
  FCanvas.SmoothingMode := smAntiAlias;
  ShapeRendering := TdxSVGShapeRendering.srAuto;
end;

destructor TdxChartMarkerRender.Destroy;
begin
  FreeAndNil(FBackgroundFill);
  FreeAndNil(FForegroundFill);
  FreeAndNil(FStroke);
  inherited Destroy;
end;

function TdxChartMarkerRender.CreateBrush: TdxSVGBrush;
begin
  Result := TdxChartMarkerRenderBrush.Create;
end;

procedure TdxChartMarkerRender.InitializeAppearance(AElement: TdxSVGElement);
begin
  inherited InitializeAppearance(AElement);

  if AElement.StyleName = 'fore_color' then
    Brush.Assign(FForegroundFill)
  else
    if AElement.StyleName = 'base_color' then
    begin
      Pen.Assign(FStroke);
      Pen.Width := TransformPenWidth(FStroke.Width);
      Brush.Assign(FBackgroundFill);
    end;
end;

{ TdxChartMarkerRepository }

class procedure TdxChartMarkerRepository.Finalize;
var
  AKind: TdxChartMarkerKind;
begin
  for AKind := Low(AKind) to High(AKind) do
    FreeAndNil(FImages[AKind]);
end;

class function TdxChartMarkerRepository.GetItem(AKind: TdxChartMarkerKind): TdxSVGElementRoot;
var
  ADocument: TdxXMLDocument;
begin
  if FImages[AKind] = nil then
  begin
    ADocument := TdxXMLDocument.Create;
    try
      ADocument.LoadFromResource(HInstance, ImageResNamePrefix + ImageResNameMap[AKind], ImageResType);
      if not TdxSVGImporter.Import(ADocument, FImages[AKind]) then
        raise EInvalidArgument.Create('');
    finally
      ADocument.Free;
    end;
  end;
  Result := FImages[AKind];
end;

{ TdxChartMarkerViewInfo }

constructor TdxChartMarkerViewInfo.Create;
begin
  FStrokeColor := TdxAlphaColors.Empty;
  FForegroundColor := TdxAlphaColors.Default;
end;

destructor TdxChartMarkerViewInfo.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TdxChartMarkerViewInfo.Calculate(const R: TdxRectF);
begin
  if not cxSizeIsEqual(R, FBounds, 0.1) then
    Changed;
  FBounds := R;
end;

procedure TdxChartMarkerViewInfo.Draw(ACanvas: TcxCustomCanvas);
var
  ABounds: TRect;
  AImage: TcxCanvasBasedImage;
begin
  if UseVectorDrawing then
  begin
    ABounds := Bounds.DeflateToTRect;
    ABounds.Inflate(SmoothingIndent, SmoothingIndent, 0, 0);
    ABounds.Height := ABounds.Width;
    ACanvas.DrawNativeObject(ABounds,
      TcxCanvasBasedResourceCacheKey.Create(Pointer(GetOriginalImage), ABounds.Size, 0),
      procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
      var
        ARenderer: TdxSVGRenderer;
        AGPCanvas: TdxGPCanvas;
        ADrawBounds: TRect;
      begin
        AGPCanvas := TdxGPCanvas.Create(ACanvas.Handle);
        try
          ARenderer := TdxChartMarkerRender.Create(AGPCanvas, FillOptions, ForegroundColor, StrokeColor, StrokeWidth);
          try
            ADrawBounds := R;
            ADrawBounds.Inflate(-SmoothingIndent);
            if HasStroke then
              ADrawBounds.Inflate(-Ceil(StrokeWidth));
            GetOriginalImage.Draw(ARenderer, ADrawBounds);
          finally
            ARenderer.Free;
          end;
        finally
          AGPCanvas.Free;
        end;
      end);
  end
  else
  begin
    AImage := GetImage(ACanvas);
    AImage.Draw(cxRectCenter(Bounds, AImage.Width, AImage.Height));
  end;
end;

function TdxChartMarkerViewInfo.MeasureSize: TdxSizeF;
begin
  Result := GetOriginalImage.Size;
  Result.Width := Result.Width + 2 * SmoothingIndent;
  Result.Height := Result.Height + 2 * SmoothingIndent;
  if HasStroke then
  begin
    Result.Width := Result.Width + 2 * StrokeWidth;
    Result.Height := Result.Height + 2 * StrokeWidth;
  end;
end;

procedure TdxChartMarkerViewInfo.Changed;
begin
  FreeAndNil(FImage);
end;

function TdxChartMarkerViewInfo.GetImage(ACanvas: TcxCustomCanvas): TcxCanvasBasedImage;
var
  ABuffer: TdxGpFastDIB;
  ABufferCanvas: TdxGPCanvas;
  AIndent: Integer;
  ARender: TdxChartMarkerRender;
  ADrawBounds: TdxRectF;
  ABufferSize: TdxSizeF;
begin
  if not ACanvas.CheckIsValid(FImage) then
  begin
    ABufferSize.Width := Bounds.Width + SmoothingIndent * 2;
    ABufferSize.Height := Bounds.Height + SmoothingIndent * 2;
    ABuffer := TdxGpFastDIB.Create(ABufferSize, True);
    try
      ABufferCanvas := ABuffer.CreateCanvas;
      try
        ARender := TdxChartMarkerRender.Create(ABufferCanvas, FillOptions, ForegroundColor, StrokeColor, StrokeWidth);
        try
          AIndent := SmoothingIndent;
          if HasStroke then
            Inc(AIndent, Ceil(StrokeWidth));
          ADrawBounds := cxRectInflate(ABuffer.ClientRect, -AIndent);
          if not ADrawBounds.IsEmpty then
            GetOriginalImage.Draw(ARender, ADrawBounds);
        finally
          ARender.Free;
        end;
      finally
        ABufferCanvas.Free;
      end;
      FImage := ACanvas.CreateImage(ABuffer, afPremultiplied);
    finally
      ABuffer.Free;
    end;
  end;
  Result := FImage;
end;

function TdxChartMarkerViewInfo.GetOriginalImage: TdxSVGElementRoot;
begin
  Result := TdxChartMarkerRepository.Items[Kind];
end;

function TdxChartMarkerViewInfo.HasStroke: Boolean;
begin
  Result := dxAlphaColorIsValid(StrokeColor);
end;

procedure TdxChartMarkerViewInfo.SetForegroundColor(AValue: TdxAlphaColor);
begin
  if ForegroundColor <> AValue then
  begin
    FForegroundColor := AValue;
    Changed;
  end;
end;

procedure TdxChartMarkerViewInfo.SetFillOptions(AValue: TdxFillOptions);
begin
  FFillOptions := AValue;
  Changed;
end;

procedure TdxChartMarkerViewInfo.SetKind(AValue: TdxChartMarkerKind);
begin
  if FKind <> AValue then
  begin
    FKind := AValue;
    Changed;
  end;
end;

procedure TdxChartMarkerViewInfo.SetStrokeColor(AValue: TdxAlphaColor);
begin
  if FStrokeColor <> AValue then
  begin
    FStrokeColor := AValue;
    Changed;
  end;
end;


initialization

  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, nil, TdxChartMarkerRepository.Finalize);

finalization

  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, TdxChartMarkerRepository.Finalize);

end.
