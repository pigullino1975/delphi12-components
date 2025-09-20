{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library graphics classes          }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
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

unit dxSVGCanvas; // for internal use

{$I cxVer.inc}

interface

uses
  UITypes,
  Types, Windows, SysUtils, Generics.Collections, Generics.Defaults, Classes, Graphics, Controls, ImgList,
  dxGenerics, cxGeometry, cxGraphics, dxCore, dxCoreClasses, dxSmartImage, dxGDIPlusAPI, dxGDIPlusClasses,
  dxCoreGraphics, cxDrawTextUtils, dxDPIAwareUtils, cxCustomCanvas, dxSVGCore, dxXMLDoc, dxSVGCoreParsers;

type

  { TdxSVGCanvasBasedPath }

  TdxSVGCanvasBasedPath = class(TcxCanvasBasedPath)
  strict private
    FPath: TdxSVGBuilderPath;
    FFigureStarted: Boolean;

    procedure StartFigureIfNecessary(const P: TdxPointF); inline;
  public
    constructor Create(ACanvas: TcxCustomCanvas);
    destructor Destroy; override;
    procedure AddArc(const AEllipse: TdxRectF; const AStartAngle, ASweepAngle: Single); override;
    procedure AddPolyline(Points: PdxPointF; Count: Integer); override;
    procedure FigureClose; override;
    procedure FigureStart; override;
    //
    property Path: TdxSVGBuilderPath read FPath;
  end;

  { TdxSVGCanvasBasedTextLayout }

  TdxSVGCanvasBasedTextLayout = class(TcxGdiCanvasBasedTextLayout)
  strict private
    FGdipFontCache: TdxGPFont;
    FGDIPToGDITextOffset: TdxSizeF;
  protected
    procedure DoCalculate(AMaxWidth, AMaxHeight, AMaxRowCount: Integer); override;
    function DoCalculateTextEndEllipsis(const AText: string; AFont: TdxGPFont): string;
    function DoCalculateTextExtends(DC: HDC; AText: PWideChar; ATextLength: Integer; AExpandTabs: Boolean): TSize; override;
    procedure DoDraw(const R: TRect); override;
  end;

  { TdxSVGCanvasState }

  TdxSVGCanvasState = record
    ClipRect: TRect;
    Group: TdxSVGElementGroup;
    ShapeRendering: TdxSVGShapeRendering;
    Transfrom: TXForm;
    WindowOrg: TPoint;
  end;

  { TdxSVGCanvas }

  TdxSVGCanvas = class(TcxCustomGdiBasedCanvas)
  strict private
    FCurrentState: TdxSVGCanvasState;
    FDefinitions: TdxSVGElementDefinitions;
    FInitialized: Boolean;
    FRoot: TdxSVGElementRoot;
    FSavedStates: TStack<TdxSVGCanvasState>;

    function GenerateID(AElementClass: TdxSVGElementClass; ACounter: Integer): string;
  protected
    procedure AppendDefinition(AElementClass: TdxSVGElementClass; out AElement);
    procedure AppendElement(AElementClass: TdxSVGElementClass; out AElement);
    procedure CheckInitialized;
    function GetOpacity(const AColor: TdxAlphaColor): Single; overload;
    function GetOpacity(const AFill: TdxSVGFill): Single; overload;
    procedure Pack(AElement: TdxSVGElement);
    procedure SetFillStyle(AElement: TdxSVGElement; ABrush: TcxCanvasBasedBrush); overload;
    procedure SetFillStyle(AElement: TdxSVGElement; ABrushHandle: TcxCanvasBasedBrushHandle); overload;
    procedure SetFillStyle(AElement: TdxSVGElement; AColor: TdxAlphaColor); overload;
    procedure SetStrokeDashArray(AElement: TdxSVGElement; AStyle: TdxStrokeStyle; AScaleFactor: Single);
    procedure SetStrokeStyle(AElement: TdxSVGElement; AColor: TdxAlphaColor; AStyle: TdxStrokeStyle; AWidth: Single); overload;
    procedure SetStrokeStyle(AElement: TdxSVGElement; AColor: TdxAlphaColor; AStyle: TPenStyle = psSolid; AWidth: Single = 1); overload;
    procedure SetStrokeStyle(AElement: TdxSVGElement; APen: TcxCanvasBasedPen); overload;
    procedure SetStrokeStyle(AElement: TdxSVGElement; APenHandle: TcxCanvasBasedPenHandle); overload;

    function GetWindowOrg: TPoint; override;
    procedure SetWindowOrg(const Value: TPoint); override;

    procedure DrawImageCore(AImageResource: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte); override;
    procedure DrawImageCore(AImageResource: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte); override;
    procedure FillRectByGradientCore(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode); override;
    procedure RectangleCore(const R: TdxRectF; ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle); override;
  public
    constructor Create(const AShapeRendering: TdxSVGShapeRendering = TdxSVGShapeRendering.srCrispEdges);
    destructor Destroy; override;
    procedure Initialize(const ABounds: TRect);
  {$REGION 'for internal use'}
    function CreateBrush(AGpBrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership): TcxCanvasBasedBrush; override;
  {$ENDREGION}
    function CreatePath: TcxCanvasBasedPath; override;
    function CreateTextLayout: TcxCanvasBasedTextLayout; override;
    procedure DrawNativeObject(const R: TRect; const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc); override;

    procedure Export(const AFileName: string); overload;
    procedure Export(const AStream: TStream); overload;
    procedure Export(const AXmlDoc: TdxXMLDocument); overload;

    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; AAlpha: Byte); overload;
    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; ACache: PcxCanvasBasedImage = nil); overload; override;
    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TdxRectF; ACache: PcxCanvasBasedImage = nil); overload; override;

    procedure Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
      AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle); override;
    procedure DonutSlice(const R: TdxRectF; AStartAngle, ASweepAngle, AWholePercent: Single;
      ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Ellipse(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Ellipse(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer); override;
    procedure FillRect(const R: TRect; AColor: TdxAlphaColor); override;
    procedure Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Pie(const R: TdxRectF; AStartAngle, ASweepAngle: Single; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Polygon(const P: array of TdxPointF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor); override;
    procedure Polyline(const P: array of TdxPointF; APen: TcxCanvasBasedPen); override;
    procedure Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen); override;
    procedure Polyline(const P: array of TPoint; AColor: TdxAlphaColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); override;
    procedure Rectangle(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer = 1); override;

    procedure ModifyWorldTransform(const AForm: TXForm); override;
    procedure RestoreWorldTransform; override;
    procedure SaveWorldTransform; override;

    procedure RestoreState; override;
    procedure SaveState; override;

    procedure EnableAntialiasing(AEnable: Boolean); override;
    procedure RestoreAntialiasing; override;

    procedure IntersectClipRect(const ARect: TRect); override;
    function RectVisible(const R: TRect): Boolean; override;
    procedure RestoreClipRegion; override;
    procedure SaveClipRegion; override;

  {$REGION 'optional, just for optimization reasons'}
    procedure FrameRect(const R: TRect; AColor: TColor; ALineWidth: Integer = 1; ABorders: TcxBorders = cxBordersAll); override;
    procedure FrameRect(const R: TRect; AColor: TdxAlphaColor; ALineWidth: Integer = 1; ABorders: TcxBorders = cxBordersAll); override;
    procedure FrameRect(const R: TdxRectF; AColor: TdxAlphaColor; ALineWidth: Single = 1; ABorders: TcxBorders = cxBordersAll); override;
  {$ENDREGION}

    property ShapeRendering: TdxSVGShapeRendering read FCurrentState.ShapeRendering;
  end;

implementation

uses
  StrUtils, Math, dxTypeHelpers, dxShapeBrushes;

const
  dxThisUnitName = 'dxSVGCanvas';

type
  TdxSVGElementAccess = class(TdxSVGElement);
  TdxSVGElementTextAccess = class(TdxSVGElementText);

  { TdxSVGHatchPattern }

  TdxSVGHatchPattern = class
  public const
    DefaultSize = 8;
  public
    InvertColors: Boolean;
    Path: string;
    Size: Integer;
    SolidFill: Boolean;
    StrokeLineCap: TdxSVGLineCapStyle;
    StrokeStyle: TdxStrokeStyle;
    StrokeThickness: Single;

    constructor Create(const APath: string);
    function SetInvertColors: TdxSVGHatchPattern;
    function SetLineCap(ALineCap: TdxSVGLineCapStyle): TdxSVGHatchPattern;
    function SetStyle(AStyle: TdxStrokeStyle): TdxSVGHatchPattern;
  end;

  { TdxSVGFillFactory }

  TdxSVGFillFactory = class
  strict private type
    THandler = function (ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill;
  strict private
    class var FHatchPatterns: array [TdxGpHatchStyle] of TdxSVGHatchPattern;
    class var FMap: TdxClassDictionary<THandler>;

    class procedure AssignGradientStops(AGradient: TdxSVGElementCustomGradient; APoints: TdxGPBrushGradientPoints; AFillEdges: Boolean = False);

    class function ConvertBrush(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill; static;
    class function ConvertComplexBrush(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill; static;
    class function ConvertComplexBrushCore(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF;
      ABrush: TdxGPCustomBrush; APatternWidth, APatternHeight: Integer): TdxSVGFill; static;
    class function ConvertHatchBrush(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill; static;
    class function ConvertLinearGradientBrush(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill; static;
    class function ConvertRadialGradientBrush(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill; static;
    class function ConvertSolidBrush(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill; static;
    class function ConvertTextureBrush(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill; static;

    class function CreateLinearGradientBrush(ACanvas: TdxSVGCanvas;
      APoints: TdxGPBrushGradientPoints; AMode: TdxGpLinearGradientMode): TdxSVGFill; overload; static;
    class function CreateLinearGradientBrush(ACanvas: TdxSVGCanvas;
      APoints: TdxGPBrushGradientPoints; const AStartPoint, AEndPoint: TdxPointF): TdxSVGFill; overload; static;
    class function CreateTextureFill(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF;
      ATexture: TdxGPImage; AOffsetX: Single = 0; AOffsetY: Single = 0; ATransform: TdxGPMatrix = nil): TdxSVGFill; static;
  protected
    class procedure Finalize;
    class procedure Initialize;
  public
    class function Build(ACanvas: TdxSVGCanvas; AElement: TdxSVGElement; ABrush: TdxGPCustomBrush): TdxSVGFill;
  end;

{$IFNDEF DELPHIXE8}
function FMod(const ANumerator, ADenominator: Single): Single;
begin
  Result := ANumerator - Trunc(ANumerator / ADenominator) * ADenominator;
end;
{$ENDIF}

{ TdxSVGCanvasBasedPath }

constructor TdxSVGCanvasBasedPath.Create(ACanvas: TcxCustomCanvas);
begin
  inherited Create(ACanvas);
  FPath := TdxSVGBuilderPath.Create;
end;

destructor TdxSVGCanvasBasedPath.Destroy;
begin
  FreeAndNil(FPath);
  inherited;
end;

procedure TdxSVGCanvasBasedPath.FigureClose;
begin
  if FFigureStarted then
    FPath.AddCloseFigure;
  FFigureStarted := False;
end;

procedure TdxSVGCanvasBasedPath.FigureStart;
begin
  FFigureStarted := False;
end;

procedure TdxSVGCanvasBasedPath.StartFigureIfNecessary(const P: TdxPointF);
begin
  if not FFigureStarted then
  begin
    FPath.AddMoveTo(P);
    FFigureStarted := True;
  end;
end;

procedure TdxSVGCanvasBasedPath.AddArc(const AEllipse: TdxRectF; const AStartAngle, ASweepAngle: Single);
var
  AStartPoint, AEndPoint: TdxPointF;
begin
  dxCalculateArcSegment(AEllipse, AStartAngle, ASweepAngle, AStartPoint, AEndPoint);
  StartFigureIfNecessary(AStartPoint);
  FPath.AddArc(AEllipse.Width / 2, AEllipse.Height / 2, ASweepAngle, AEndPoint.X, AEndPoint.Y);
end;

procedure TdxSVGCanvasBasedPath.AddPolyline(Points: PdxPointF; Count: Integer);
begin
  if Count > 0 then
    StartFigureIfNecessary(Points^);
  while Count > 0 do
  begin
    FPath.AddLineTo(Points^);
    Inc(Points);
    Dec(Count);
  end;
end;

{ TdxSVGCanvasBasedTextLayout }

procedure TdxSVGCanvasBasedTextLayout.DoCalculate(AMaxWidth, AMaxHeight, AMaxRowCount: Integer);
var
  AElement: TdxSVGElementTextAccess;
begin
  AElement := TdxSVGElementTextAccess.Create;
  try
    AElement.FontName := NativeFont.Name;
    AElement.FontSize := -NativeFont.Height;
    AElement.FontStyles := NativeFont.Style;
    if AElement.TryCreateFont(FGdipFontCache) then
    try
      inherited DoCalculate(AMaxWidth, AMaxHeight, AMaxRowCount);
    finally
      FreeAndNil(FGdipFontCache)
    end;
  finally
    AElement.Free;
  end;
end;

function TdxSVGCanvasBasedTextLayout.DoCalculateTextEndEllipsis(const AText: string; AFont: TdxGPFont): string;
var
  ACharactersFitted: Integer;
  AFormat: TdxGPStringFormat;
  ALinesFilled: Integer;
  AWidth: Single;
begin
  AWidth := FTextSize.Width - dxGPMeasureCanvas.MeasureString(cxEndEllipsis, AFont).Width + FGDIPToGDITextOffset.cx;
  if AWidth > 0 then
  begin
    AFormat := TdxGPStringFormat.Create(Integer(StringFormatFlagsNoWrap));
    try
      dxGPMeasureCanvas.MeasureString(AText, AFont, dxSizeF(AWidth, 0), AFormat, ACharactersFitted, ALinesFilled);
      Result := Copy(AText, 1, ACharactersFitted) + cxEndEllipsis;
    finally
      AFormat.Free;
    end;
  end
  else
    Result := cxEndEllipsis;
end;

function TdxSVGCanvasBasedTextLayout.DoCalculateTextExtends(
  DC: HDC; AText: PWideChar; ATextLength: Integer; AExpandTabs: Boolean): TSize;
var
  ABoundingBox: TdxGpRectF;
  ACharactersFitted: Integer;
  ALayoutRect: TdxGpRectF;
  ALinesFilled: Integer;
  AGDITextSize: TSize;
begin
  if FGdipFontCache = nil then
    raise EInvalidOperation.Create('Native GDI+ font was not created!');

  ALayoutRect := MakeRect(0.0, 0.0, 0.0, 0.0);
  GdipCheck(GdipMeasureString(dxGPMeasureCanvas.Handle, AText, ATextLength,
    FGdipFontCache.NativeFont, @ALayoutRect, nil, @ABoundingBox, ACharactersFitted, ALinesFilled));
  Result := ABoundingBox.SizeF;

  FGDIPToGDITextOffset.Init(0, 0);
  if Canvas.UseGDITextCalculation then
  begin
    AGDITextSize := inherited DoCalculateTextExtends(DC, AText, ATextLength, AExpandTabs);
    FGDIPToGDITextOffset.cx := (Result.cx - AGDITextSize.cx) / 2;
    FGDIPToGDITextOffset.cy := (Result.cy - AGDITextSize.cy) / 2;
    Result := AGDITextSize;
  end;
end;

procedure TdxSVGCanvasBasedTextLayout.DoDraw(const R: TRect);
var
  ACanvas: TdxSVGCanvas;
  AElement: TdxSVGElementTextAccess;
  AFont: TdxGPFont;
  AMeasureDC: HDC;
  APrevFont: HFONT;
  ARowCount: Integer;
  ARowIndex: Integer;
  ATextParams: TcxTextParams;
  ATextRow: PcxTextRow;
  ATextOffset: TdxSizeF;
begin
  ACanvas := Canvas as TdxSVGCanvas;
  AMeasureDC := cxMeasureCanvas.Handle;

  APrevFont := SelectObject(AMeasureDC, NativeFont.Handle);
  try
    ATextParams := cxCalcTextParams(AMeasureDC, FFlags);
    cxPlaceTextRows(AMeasureDC, R, ATextParams, FTextRows, FRowCount);
    ARowCount := Min(FRowCount, cxGetTextRowCount(FTextRows));
    for ARowIndex := 0 to ARowCount - 1 do
    begin
      ATextRow := cxGetTextRow(FTextRows, ARowIndex);

      ACanvas.AppendElement(TdxSVGElementText, AElement);
      AElement.Fill := TdxSVGFill.Create(dxRGBQuadToAlphaColor(FColor));
      AElement.FillOpacity := ACanvas.GetOpacity(AElement.Fill);
      AElement.FontName := NativeFont.Name;
      AElement.FontStyles := NativeFont.Style;
      AElement.FontSize := -NativeFont.Height;
      AElement.Text := ATextRow^.ToString;

      if AElement.TryCreateFont(AFont) then
      try
        ATextOffset.Init(0, 0);
        if FTextTruncated and (ARowIndex + 1 = ARowCount) then
        begin
          if (FTransform = nil) and (ATextParams.TextAlignX = taCenterX) then
            ATextOffset.cx := dxGPMeasureCanvas.MeasureString(AElement.Text, AFont).Width;
          AElement.Text := DoCalculateTextEndEllipsis(AElement.Text, AFont);
          if (FTransform = nil) and (ATextParams.TextAlignX = taCenterX) then
            ATextOffset.cx := (ATextOffset.cx - dxGPMeasureCanvas.MeasureString(AElement.Text, AFont).Width) / 2;
        end;
        ATextOffset.cx := ATextOffset.cx + AElement.CalculateTextPadding(AFont) - FGDIPToGDITextOffset.cx;
        ATextOffset.cy := ATextOffset.cy + AElement.CalculateVertOffset(AFont) - FGDIPToGDITextOffset.cy;
        AElement.X[0] := TdxSVGValue.Create(ATextRow^.TextOriginX + ATextOffset.cx, utPx);
        AElement.Y[0] := TdxSVGValue.Create(ATextRow^.TextOriginY + ATextOffset.cy, utPx);
      finally
        AFont.Free;
      end;
    end;
  finally
    SelectObject(AMeasureDC, APrevFont);
  end;
end;

{ TdxSVGCanvas }

constructor TdxSVGCanvas.Create(const AShapeRendering: TdxSVGShapeRendering);
begin
  inherited Create;
  FRoot := TdxSVGElementRoot.Create;
  FDefinitions := TdxSVGElementDefinitions.Create(FRoot);
  FSavedStates := TStack<TdxSVGCanvasState>.Create;
  FCurrentState.Group := TdxSVGElementGroup.Create(FRoot);
  FCurrentState.Transfrom := TXForm.CreateIdentityMatrix;
  FCurrentState.ShapeRendering := AShapeRendering;
end;

function TdxSVGCanvas.CreateBrush(AGpBrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership): TcxCanvasBasedBrush;
begin
  Result := DoCreateBrush(AGpBrush, AOwnership, False);
end;

destructor TdxSVGCanvas.Destroy;
begin
  FreeAndNil(FSavedStates);
  FreeAndNil(FRoot);
  inherited;
end;

procedure TdxSVGCanvas.Initialize(const ABounds: TRect);
begin
  if FInitialized then
    raise EInvalidOperation.Create('SVG Canvas is already initialized');

  FRoot.X := TdxSVGValue.Create(ABounds.Left, utPx);
  FRoot.Y := TdxSVGValue.Create(ABounds.Top, utPx);
  FRoot.Height := TdxSVGValue.Create(ABounds.Height, utPx);
  FRoot.Width := TdxSVGValue.Create(ABounds.Width, utPx);
  FRoot.Background.Value := ABounds;
  FRoot.ViewBox.Value := ABounds;
  FCurrentState.ClipRect := ABounds;
  FInitialized := True;
end;

function TdxSVGCanvas.CreatePath: TcxCanvasBasedPath;
begin
  Result := TdxSVGCanvasBasedPath.Create(Self);
end;

function TdxSVGCanvas.CreateTextLayout: TcxCanvasBasedTextLayout;
begin
  Result := TdxSVGCanvasBasedTextLayout.Create(Self);
end;

procedure TdxSVGCanvas.DrawNativeObject(const R: TRect;
  const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc);
var
  ABuffer: TdxFastDIB;
begin
  ABuffer := TdxFastDIB.Create(R, True);
  try
    cxPaintCanvas.BeginPaint(ABuffer.DC);
    cxPaintCanvas.WindowOrg := R.TopLeft;
    AProc(cxPaintCanvas, R);
    cxPaintCanvas.EndPaint;
    DrawBitmap(ABuffer, R, afPremultiplied);
  finally
    ABuffer.Free;
  end;
end;

procedure TdxSVGCanvas.Export(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    Export(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxSVGCanvas.Export(const AStream: TStream);
var
  ADocument: TdxXMLDocument;
begin
  ADocument := TdxXMLDocument.Create;
  try
    Export(ADocument);
    ADocument.SaveToStream(AStream);
  finally
    ADocument.Free;
  end;
end;

procedure TdxSVGCanvas.Export(const AXmlDoc: TdxXMLDocument);
begin
  FSavedStates.Clear; 
  Pack(FRoot);
  TdxSVGExporter.Export(FRoot, AXmlDoc);
end;

procedure TdxSVGCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; AAlpha: Byte);
var
  AElement: TdxSVGElementImage;
begin
  AppendElement(TdxSVGElementImage, AElement);
  AElement.Opacity := AAlpha / MaxByte;
  AElement.Image.Assign(AImage);
  AElement.SetBounds(ATargetRect);
end;

procedure TdxSVGCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; ACache: PcxCanvasBasedImage = nil);
begin
  DrawImage(AImage, ATargetRect, MaxByte);
end;

procedure TdxSVGCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TdxRectF; ACache: PcxCanvasBasedImage = nil);
begin
  DrawImage(AImage, ATargetRect.DeflateToTRect, ACache);
end;

procedure TdxSVGCanvas.Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
  AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
var
  ABuilder: TdxSVGBuilderPath;
  AElement: TdxSVGElementPath;
  AEndPointF: TdxPointF;
  AStartAngle: Single;
  AStartPointF: TdxPointF;
  ASweepAngle: Single;
begin
  if RectVisible(AEllipse) then
  begin
    AppendElement(TdxSVGElementPath, AElement);

    ABuilder := TdxSVGBuilderPath.Create;
    try
      dxCalculateArcAngles(AEllipse, AStartPoint, AEndPoint, AStartAngle, ASweepAngle);
      dxCalculateArcSegment(AEllipse, AStartAngle, ASweepAngle, AStartPointF, AEndPointF);
      ABuilder.AddMoveTo(AStartPointF.X, AStartPointF.Y);
      ABuilder.AddArc(AEllipse.Width * 0.5, AEllipse.Height * 0.5, ASweepAngle, AEndPointF.X, AEndPointF.Y);
      AElement.Path.FromString(ABuilder.ToString);
    finally
      ABuilder.Free;
    end;

    SetStrokeStyle(AElement, AColor, APenStyle, APenWidth);
    SetFillStyle(AElement, TdxAlphaColors.Empty);
  end;
end;

procedure TdxSVGCanvas.DonutSlice(const R: TdxRectF;
  AStartAngle, ASweepAngle, AWholePercent: Single;
  ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  ABuilder: TdxSVGBuilderPath;
  ADiameter: Single;
  AElement: TdxSVGElementPath;
  APartCount: Integer;
  AWholeRect: TdxRectF;

  procedure InternalAddArc(const AArcRect: TdxRectF; APartOfSweepAngle: Single);
  var
    APart: Integer;
    AStartPoint, AEndPoint: TdxPointF;
  begin
    for APart := 1 to APartCount do
    begin
      dxCalculateArcSegment(AArcRect, AStartAngle, APartOfSweepAngle, AStartPoint, AEndPoint);
      if APart = 1 then
        if APartOfSweepAngle > 0 then
          ABuilder.AddMoveTo(AStartPoint.X, AStartPoint.Y)
        else
          ABuilder.AddLineTo(AStartPoint.X, AStartPoint.Y);
      ABuilder.AddArc(AArcRect.Width * 0.5, AArcRect.Height * 0.5, APartOfSweepAngle, AEndPoint.X, AEndPoint.Y);
      AStartAngle := AStartAngle + APartOfSweepAngle;
    end;
  end;

begin
  if IsZero(ASweepAngle) then
    Exit;

  if ASweepAngle = 360 then
    APartCount := 2
  else
    APartCount := 1;
  ASweepAngle := ASweepAngle / APartCount;

  if AWholePercent > 0 then
  begin
    AppendElement(TdxSVGElementPath, AElement);

    ADiameter := Min(R.Width, R.Height) * AWholePercent / 100;
    AWholeRect := cxRectCenter(R, ADiameter, ADiameter);

    ABuilder := TdxSVGBuilderPath.Create;
    try
      InternalAddArc(R, ASweepAngle);
      InternalAddArc(AWholeRect, -ASweepAngle);
      ABuilder.AddCloseFigure;

      AElement.Path.FromString(ABuilder.ToString);
    finally
      ABuilder.Free;
    end;

    SetStrokeStyle(AElement, APen);
    SetFillStyle(AElement, ABrush);
  end
  else
    Pie(R, AStartAngle, ASweepAngle, ABrush, APen);
end;

procedure TdxSVGCanvas.Ellipse(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer);
var
  AElement: TdxSVGElementEllipse;
begin
  AppendElement(TdxSVGElementEllipse, AElement);
  AElement.SetBounds(R, utPx);
  SetStrokeStyle(AElement, APenColor, APenStyle, APenWidth);
  SetFillStyle(AElement, ABrushColor);
end;

procedure TdxSVGCanvas.EnableAntialiasing(AEnable: Boolean);
begin
  SaveState;
  if AEnable then
    FCurrentState.ShapeRendering := TdxSVGShapeRendering.srAuto
  else
    FCurrentState.ShapeRendering := TdxSVGShapeRendering.srOptimizeSpeed;
end;

procedure TdxSVGCanvas.Ellipse(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AElement: TdxSVGElementEllipse;
begin
  AppendElement(TdxSVGElementEllipse, AElement);
  AElement.SetBounds(R, utPx);
  SetStrokeStyle(AElement, APen);
  SetFillStyle(AElement, ABrush);
end;

procedure TdxSVGCanvas.FillRect(const R: TRect; AColor: TdxAlphaColor);
begin
  Rectangle(R, AColor, TdxAlphaColors.Empty);
end;

procedure TdxSVGCanvas.DrawImageCore(AImageResource: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte);
var
  AImage: TdxGPImage;
  AImagePart: TdxSmartImage;
  AImagePartCanvas: TdxGPCanvas;
begin
  AImage := (AImageResource as TcxGdiCanvasBasedImage).Image;
  if cxRectIsEqual(ASourceRect, AImage.ClientRect) then
    DrawImage(AImage, ATargetRect, AAlpha)
  else
  begin
    AImagePart := TdxSmartImage.CreateSize(ASourceRect);
    try
      AImagePartCanvas := AImagePart.CreateCanvas;
      try
        AImage.StretchDraw(AImagePartCanvas, AImagePart.ClientRect, ASourceRect, nil);
      finally
        AImagePartCanvas.Free;
      end;
      DrawImage(AImagePart, ATargetRect, AAlpha);
    finally
      AImagePart.Free;
    end;
  end;
end;

procedure TdxSVGCanvas.DrawImageCore(AImageResource: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte);
begin
  DrawImageCore(AImageResource, ATargetRect.DeflateToTRect, ASourceRect.DeflateToTRect, AAlpha);
end;

procedure TdxSVGCanvas.FillRectByGradientCore(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode);
var
  AElement: TdxSVGElementRectangle;
  AGradient: TdxSVGElementLinearGradient;
begin
  AppendDefinition(TdxSVGElementLinearGradient, AGradient);
  AGradient.AddStop(0, AColor1);
  AGradient.AddStop(100, AColor2);
  AGradient.SetBounds(AMode);

  AppendElement(TdxSVGElementRectangle, AElement);
  AElement.Fill := TdxSVGFill.Create(AGradient.ID);
  AElement.SetBounds(R, utPx);
end;

procedure TdxSVGCanvas.Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AElement: TdxSVGElementPath;
begin
  if CheckIsValid(APath) then
  begin
    AppendElement(TdxSVGElementPath, AElement);
    AElement.Path.FromString(TdxSVGCanvasBasedPath(APath).Path.ToString);
    SetStrokeStyle(AElement, APen);
    SetFillStyle(AElement, ABrush);
  end;
end;

procedure TdxSVGCanvas.Pie(const R: TdxRectF; AStartAngle, ASweepAngle: Single; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  ABuilder: TdxSVGBuilderPath;
  AElement: TdxSVGElementPath;
  AEndPoint: TdxPointF;
  AStartPoint: TdxPointF;
begin
  AppendElement(TdxSVGElementPath, AElement);

  ABuilder := TdxSVGBuilderPath.Create;
  try
    dxCalculateArcSegment(R, AStartAngle, ASweepAngle, AStartPoint, AEndPoint);
    ABuilder.AddMoveTo(AStartPoint);
    ABuilder.AddArc(R.Width * 0.5, R.Height * 0.5, ASweepAngle, AEndPoint.X, AEndPoint.Y);
    ABuilder.AddLineTo(R.CenterPoint);
    ABuilder.AddCloseFigure;
    AElement.Path.FromString(ABuilder.ToString);
  finally
    ABuilder.Free;
  end;

  SetStrokeStyle(AElement, APen);
  SetFillStyle(AElement, ABrush);
end;

procedure TdxSVGCanvas.Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor);
var
  AElement: TdxSVGElementPolygon;
begin
  AppendElement(TdxSVGElementPolygon, AElement);
  AElement.Points.Assign(P);
  SetStrokeStyle(AElement, APenColor);
  SetFillStyle(AElement, ABrushColor);
end;

procedure TdxSVGCanvas.Polygon(const P: array of TdxPointF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AElement: TdxSVGElementPolygon;
begin
  AppendElement(TdxSVGElementPolygon, AElement);
  AElement.Points.Assign(P);
  SetStrokeStyle(AElement, APen);
  SetFillStyle(AElement, ABrush);
end;

procedure TdxSVGCanvas.Polyline(const P: array of TdxPointF; APen: TcxCanvasBasedPen);
var
  AElement: TdxSVGElementPolyline;
begin
  AppendElement(TdxSVGElementPolyline, AElement);
  AElement.Points.Assign(P);
  SetFillStyle(AElement, TdxAlphaColors.Empty);
  SetStrokeStyle(AElement, APen);
end;

procedure TdxSVGCanvas.Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen);
var
  APoints: array of TdxPointF;
  I: Integer;
begin
  if ACount > 0 then
  begin
    SetLength(APoints, ACount);
    for I := 0 to ACount - 1 do
      APoints[I] := TdxPointsF(P)[I];
    Polyline(APoints, APen);
  end;
end;

procedure TdxSVGCanvas.Polyline(const P: array of TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
var
  AElement: TdxSVGElementPolyline;
begin
  AppendElement(TdxSVGElementPolyline, AElement);
  AElement.Points.Assign(P);
  SetStrokeStyle(AElement, AColor, APenStyle, APenWidth);
  SetFillStyle(AElement, TdxAlphaColors.Empty);
end;

procedure TdxSVGCanvas.Rectangle(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer);
var
  AElement: TdxSVGElementRectangle;
begin
  AppendElement(TdxSVGElementRectangle, AElement);
  AElement.SetBounds(R, utPx);
  SetStrokeStyle(AElement, APenColor, APenStyle, APenWidth);
  SetFillStyle(AElement, ABrushColor);
end;

procedure TdxSVGCanvas.ModifyWorldTransform(const AForm: TXForm);
begin
  CheckInitialized;
  FCurrentState.Group := TdxSVGElementGroup.Create(FCurrentState.Group);
  FCurrentState.Group.Transform.Assign(AForm);
  FCurrentState.Transfrom := TXForm.Combine(AForm, FCurrentState.Transfrom);
end;

procedure TdxSVGCanvas.RestoreWorldTransform;
begin
  RestoreState;
end;

procedure TdxSVGCanvas.SaveWorldTransform;
begin
  SaveState;
end;

procedure TdxSVGCanvas.RestoreState;
begin
  FCurrentState := FSavedStates.Pop;
end;

procedure TdxSVGCanvas.SaveState;
begin
  FSavedStates.Push(FCurrentState);
end;

procedure TdxSVGCanvas.IntersectClipRect(const ARect: TRect);
var
  AClipPath: TdxSVGElementClipPath;
  AClipRect: TRect;
begin
  cxRectIntersect(AClipRect, FCurrentState.ClipRect, ARect);
  if not cxRectIsEqual(AClipRect, FCurrentState.ClipRect) then
  begin
    AppendDefinition(TdxSVGElementClipPath, AClipPath);
    TdxSVGElementRectangle.Create(AClipPath).SetBounds(AClipRect, utPx);

    FCurrentState.ClipRect := AClipRect;
    FCurrentState.Group := TdxSVGElementGroup.Create(FCurrentState.Group);
    FCurrentState.Group.ClipPath := AClipPath.ID;
  end;
end;

function TdxSVGCanvas.RectVisible(const R: TRect): Boolean;
begin
  Result := cxRectIntersect(R, FCurrentState.ClipRect);
end;

procedure TdxSVGCanvas.RestoreAntialiasing;
begin
  RestoreState;
end;

procedure TdxSVGCanvas.RestoreClipRegion;
begin
  RestoreState;
end;

procedure TdxSVGCanvas.SaveClipRegion;
begin
  SaveState;
end;

{$REGION 'optional, just for optimization reasons'}
procedure TdxSVGCanvas.FrameRect(const R: TRect; AColor: TColor; ALineWidth: Integer; ABorders: TcxBorders);
begin
  FrameRect(R, dxColorToAlphaColor(AColor), ALineWidth, ABorders);
end;

procedure TdxSVGCanvas.FrameRect(const R: TRect; AColor: TdxAlphaColor; ALineWidth: Integer; ABorders: TcxBorders);
begin
  FrameRect(dxRectF(R), AColor, ALineWidth, ABorders);
end;

procedure TdxSVGCanvas.FrameRect(const R: TdxRectF; AColor: TdxAlphaColor; ALineWidth: Single; ABorders: TcxBorders);
var
  AElement: TdxSVGElementRectangle;
begin
  if ABorders = cxBordersAll then
  begin
    AppendElement(TdxSVGElementRectangle, AElement);
    AElement.SetBounds(R, utPx);
    SetStrokeStyle(AElement, AColor, TdxStrokeStyle.Solid, ALineWidth);
    SetFillStyle(AElement, TdxAlphaColors.Empty);
  end
  else
    inherited;
end;
{$ENDREGION}

function TdxSVGCanvas.GetWindowOrg: TPoint;
begin
  Result := FCurrentState.WindowOrg;
end;

procedure TdxSVGCanvas.SetWindowOrg(const Value: TPoint);
var
  ADelta: TPoint;
  AMatrix: TXForm;
begin
  ADelta := cxPointOffset(Value, WindowOrg, False);
  if not cxPointIsNull(ADelta) then
  begin
    AMatrix := TdxGPMatrix.Invert(FCurrentState.Transfrom);
    AMatrix.eDx := 0;
    AMatrix.eDy := 0;
    ADelta := AMatrix.Transform(ADelta);
    ModifyWorldTransform(TXForm.CreateTranslateMatrix(-ADelta.X, -ADelta.Y));
    FCurrentState.ClipRect := cxRectOffset(FCurrentState.ClipRect, ADelta);
    FCurrentState.WindowOrg := Value;
  end;
end;

procedure TdxSVGCanvas.RectangleCore(const R: TdxRectF;
  ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle);
var
  AElement: TdxSVGElementRectangle;
begin
  AppendElement(TdxSVGElementRectangle, AElement);
  AElement.SetBounds(R, utPx);
  SetStrokeStyle(AElement, APenHandle);
  SetFillStyle(AElement, ABrushHandle);
end;

procedure TdxSVGCanvas.AppendDefinition(AElementClass: TdxSVGElementClass; out AElement);
begin
  CheckInitialized;
  TdxSVGElement(AElement) := AElementClass.Create(FDefinitions);
  TdxSVGElement(AElement).ID := GenerateID(AElementClass, FDefinitions.Count);
end;

procedure TdxSVGCanvas.AppendElement(AElementClass: TdxSVGElementClass; out AElement);
begin
  CheckInitialized;
  TdxSVGElement(AElement) := AElementClass.Create(FCurrentState.Group);
  if TdxSVGElement(AElement) is TdxSVGShapedElement then
    TdxSVGShapedElement(AElement).ShapeRendering := FCurrentState.ShapeRendering;
end;

procedure TdxSVGCanvas.CheckInitialized;
begin
  if not FInitialized then
    raise EInvalidOperation.Create('SVG Canvas was not initialized');
end;

function TdxSVGCanvas.GetOpacity(const AColor: TdxAlphaColor): Single;
begin
  if AColor = TdxAlphaColors.Default then
    Result := 1
  else
    Result := dxGetAlpha(AColor) / MaxByte;
end;

function TdxSVGCanvas.GetOpacity(const AFill: TdxSVGFill): Single;
begin
  if AFill.IsReference then
    Result := 1
  else
    Result := GetOpacity(AFill.AsColor);
end;

procedure TdxSVGCanvas.Pack(AElement: TdxSVGElement);
var
  AChild: TdxSVGElement;
  I: Integer;
begin
  for I := AElement.Count - 1 downto 0 do
  begin
    AChild := AElement[I];
    if AChild.ClassType = TdxSVGElementGroup then
    begin
      Pack(AChild);
      if AChild.Count = 0 then
      begin
        AChild.Parent := nil;
        AChild.Free;
      end;
    end;
  end;
end;

procedure TdxSVGCanvas.SetFillStyle(AElement: TdxSVGElement; ABrush: TcxCanvasBasedBrush);
begin
  if ABrush <> nil then
    SetFillStyle(AElement, TcxCanvasBasedBrushHandle(ABrush.Handle))
  else
    AElement.Fill := TdxSVGFill.Create(TdxAlphaColors.Empty);
end;

procedure TdxSVGCanvas.SetFillStyle(AElement: TdxSVGElement; ABrushHandle: TcxCanvasBasedBrushHandle);
begin
  if ABrushHandle is TcxGdiCanvasBasedBrushHandle then
  begin
    AElement.Fill := TdxSVGFillFactory.Build(Self, AElement, TcxGdiCanvasBasedBrushHandle(ABrushHandle).Brush);
    AElement.FillOpacity := GetOpacity(AElement.Fill);
  end;
end;

procedure TdxSVGCanvas.SetFillStyle(AElement: TdxSVGElement; AColor: TdxAlphaColor);
begin
  if AColor = TdxAlphaColors.Default then
    AElement.Fill := TdxSVGFill.Default
  else
  begin
    AElement.Fill := TdxSVGFill.Create(AColor);
    AElement.FillOpacity := GetOpacity(AColor);
  end;
end;

procedure TdxSVGCanvas.SetStrokeDashArray(AElement: TdxSVGElement; AStyle: TdxStrokeStyle; AScaleFactor: Single);

  procedure SetDashArray(const APattern: array of Single);
  var
    I: Integer;
  begin
    AElement.StrokeDashArray.Clear;
    AElement.StrokeDashArray.Capacity := Length(APattern);
    for I := Low(APattern) to High(APattern) do
      AElement.StrokeDashArray.Add(APattern[I] * AScaleFactor);
  end;

begin
  case AStyle of
    TdxStrokeStyle.Dash:
      SetDashArray([3, 1]);
    TdxStrokeStyle.Dot:
      SetDashArray([1, 1]);
    TdxStrokeStyle.DashDot:
      SetDashArray([3, 1, 1, 1]);
    TdxStrokeStyle.DashDotDot:
      SetDashArray([3, 1, 1, 1, 1, 1]);
  end;
end;

procedure TdxSVGCanvas.SetStrokeStyle(AElement: TdxSVGElement; AColor: TdxAlphaColor; AStyle: TdxStrokeStyle; AWidth: Single);
begin
  if dxAlphaColorIsValid(AColor) and (AWidth > 0) then
  begin
    AElement.Stroke := TdxSVGFill.Create(AColor);
    AElement.StrokeOpacity := GetOpacity(AElement.Stroke);
    AElement.StrokeSize := AWidth;
    SetStrokeDashArray(AElement, AStyle, AWidth);
  end;
end;

procedure TdxSVGCanvas.SetStrokeStyle(AElement: TdxSVGElement; AColor: TdxAlphaColor; AStyle: TPenStyle; AWidth: Single);
const
  PenStyleToStrokeStyle: array[psSolid..psDashDotDot] of TdxStrokeStyle = (
    TdxStrokeStyle.Solid, TdxStrokeStyle.Dash, TdxStrokeStyle.Dot, TdxStrokeStyle.DashDot, TdxStrokeStyle.DashDotDot
  );
begin
  if (AStyle >= psSolid) and (AStyle <= psDashDotDot) then
    SetStrokeStyle(AElement, AColor, PenStyleToStrokeStyle[AStyle], AWidth);
end;

procedure TdxSVGCanvas.SetStrokeStyle(AElement: TdxSVGElement; APen: TcxCanvasBasedPen);
begin
  if APen <> nil then
    SetStrokeStyle(AElement, TcxCanvasBasedPenHandle(APen.Handle));
end;

procedure TdxSVGCanvas.SetStrokeStyle(AElement: TdxSVGElement; APenHandle: TcxCanvasBasedPenHandle);
const
  LineCapMap: array[TdxGPPenLineCapStyle] of TdxSVGLineCapStyle = (lcsDefault, lcsSquare, lcsRound);
  StyleMap: array[TdxGPPenStyle] of TdxStrokeStyle = (
    TdxStrokeStyle.Solid, TdxStrokeStyle.Dash, TdxStrokeStyle.Dot, TdxStrokeStyle.DashDot, TdxStrokeStyle.DashDotDot
  );
var
  APen: TdxGPPen;
begin
  if APenHandle is TcxGdiCanvasBasedPenHandle then
  begin
    APen := TcxGdiCanvasBasedPenHandle(APenHandle).Pen;
    AElement.Stroke := TdxSVGFillFactory.Build(Self, AElement, APen.Brush);
    AElement.StrokeOpacity := GetOpacity(AElement.Stroke);
    AElement.StrokeSize := APen.Width;
    AElement.StrokeLineJoin := APen.LineJoin;
    AElement.StrokeLineCap := LineCapMap[APen.LineStartCapStyle];
    AElement.StrokeMiterLimit := APen.MiterLimit;
    SetStrokeDashArray(AElement, StyleMap[APen.Style], APen.Width);
  end;
end;

function TdxSVGCanvas.GenerateID(AElementClass: TdxSVGElementClass; ACounter: Integer): string;
begin
{$IFDEF DEBUG}
  dxTestCheck(StartsText(TdxSVGElement.ClassName, AElementClass.ClassName), 'SVG.GenerateId');
{$ENDIF}
  Result := Copy(AElementClass.ClassName, Length(TdxSVGElement.ClassName) + 1, MaxInt) + '_' + IntToStr(ACounter);
end;

{ TdxSVGHatchPattern }

constructor TdxSVGHatchPattern.Create(const APath: string);
begin
  Path := APath;
  Size := DefaultSize;
  StrokeStyle := TdxStrokeStyle.Solid;
  StrokeThickness := 1;
  StrokeLineCap := lcsButt;
end;

function TdxSVGHatchPattern.SetInvertColors: TdxSVGHatchPattern;
begin
  InvertColors := True;
  Result := Self;
end;

function TdxSVGHatchPattern.SetLineCap(ALineCap: TdxSVGLineCapStyle): TdxSVGHatchPattern;
begin
  StrokeLineCap := ALineCap;
  Result := Self;
end;

function TdxSVGHatchPattern.SetStyle(AStyle: TdxStrokeStyle): TdxSVGHatchPattern;
begin
  StrokeStyle := AStyle;
  Result := Self;
end;

{ TdxSVGFillFactory }

class function TdxSVGFillFactory.Build(ACanvas: TdxSVGCanvas; AElement: TdxSVGElement; ABrush: TdxGPCustomBrush): TdxSVGFill;
var
  AHandler: THandler;
begin
  if FMap = nil then
    Initialize;
  if FMap.TryGetValue(ABrush.ClassType, AHandler) then
    Result := AHandler(ACanvas, TdxSVGElementAccess(AElement).GetBounds, ABrush)
  else
    Result := TdxSVGFill.Default;
end;

class procedure TdxSVGFillFactory.Finalize;
var
  AStyle: TdxGpHatchStyle;
begin
  for AStyle := Low(AStyle) to High(AStyle) do
    FreeAndNil(FHatchPatterns[AStyle]);
  FreeAndNil(FMap);
end;

class procedure TdxSVGFillFactory.Initialize;

  function InitHatchPattern(AStyle: TdxGpHatchStyle; const APath: string; AThickness: Single = 1.0): TdxSVGHatchPattern;
  begin
    Result := TdxSVGHatchPattern.Create(APath);
    Result.StrokeThickness := AThickness;
    FHatchPatterns[AStyle] := Result;
  end;

begin
  FMap := TdxClassDictionary<THandler>.Create;
  FMap.Add(TdxGPBrush, ConvertBrush);
  FMap.Add(TdxGPCustomBrush, ConvertComplexBrush);
  FMap.Add(TdxGPHatchBrush, ConvertHatchBrush);
  FMap.Add(TdxGPLinearGradientBrush, ConvertLinearGradientBrush);
  FMap.Add(TdxGPSolidBrush, ConvertSolidBrush);
  FMap.Add(TdxGPTextureBrush, ConvertTextureBrush);
  FMap.Add(TdxRadialGradientBrush, ConvertRadialGradientBrush);

  InitHatchPattern(HatchStyleHorizontal, 'M0,1 h8');
  InitHatchPattern(HatchStyleVertical, 'M1,0 v8');
  InitHatchPattern(HatchStyleForwardDiagonal, 'M0,0 L8,8 M-1,7 L1,9 M7,-1 L9,1');
  InitHatchPattern(HatchStyleBackwardDiagonal, 'M0,8 L8,0 M-1,1 L1,-1 M7,9 L9,7');
  InitHatchPattern(HatchStyleCross, 'M0,8 v-8 h8');
  InitHatchPattern(HatchStyleDiagonalCross, 'M0,0 L8,8 M0,8 L8,0');
  InitHatchPattern(HatchStyleLightDownwardDiagonal, 'M0,0 L8,8 M-1,7 L1,9 M7,-1 L9,1 M0,4 L4,8 M4,0 L8,4').SetLineCap(lcsSquare);
  InitHatchPattern(HatchStyleLightUpwardDiagonal, 'M0,8 L8,0 M-1,1 L1,-1 M7,9 L9,7 M0,4 L4,0 M4,8 L8,4').SetLineCap(lcsSquare);
  InitHatchPattern(HatchStyleDarkDownwardDiagonal, 'M0,0 L8,8 M-1,7 L1,9 M7,-1 L9,1 M0,4 L4,8 M4,0 L8,4', 2).SetLineCap(lcsSquare);
  InitHatchPattern(HatchStyleDarkUpwardDiagonal, 'M0,8 L8,0 M-1,1 L1,-1 M7,9 L9,7 M0,4 L4,0 M4,8 L8,4', 2).SetLineCap(lcsSquare);
  InitHatchPattern(HatchStyleWideDownwardDiagonal, 'M0,0 L8,8 M-1,7 L1,9 M7,-1 L9,1', 2);
  InitHatchPattern(HatchStyleWideUpwardDiagonal, 'M0,8 L8,0 M-1,1 L1,-1 M7,9 L9,7', 2);
  InitHatchPattern(HatchStyleLightHorizontal, 'M0,1 h8 M0,5 h8');
  InitHatchPattern(HatchStyleLightVertical, 'M1,0 v8 M5,0 v8');
  InitHatchPattern(HatchStyleNarrowHorizontal, 'M0,1 L8,1 M0,3 L8,3 M0,5 L8,5 M0,7 L8,7');
  InitHatchPattern(HatchStyleNarrowVertical, 'M1,0 L1,8 M3,0 L3,8 M5,0 L5,8 M7,0 L7,8');
  InitHatchPattern(HatchStyleDarkHorizontal, 'M0,1 L8,1 M0,5 L8,5', 2);
  InitHatchPattern(HatchStyleDarkVertical, 'M1,0 L1,8 M5,0 L5,8', 2);
  InitHatchPattern(HatchStyleDashedDownwardDiagonal, 'M1,2 L4,5 M4,2 L7,5');
  InitHatchPattern(HatchStyleDashedUpwardDiagonal, 'M1,5 L4,2 M4,5 L7,2');
  InitHatchPattern(HatchStyleDashedHorizontal, 'M0,1 L4,1 M4,5 L8,5');
  InitHatchPattern(HatchStyleDashedVertical, 'M1,0 L1,4 M5,4 L5,8');
  InitHatchPattern(HatchStyleZigZag, 'M0,0 L4,4 L8,0 M0,4 L4,8, L8,4 M3,-1 L4,0 L5,-1 M3,9 L4,8 L5,9').SetLineCap(lcsSquare);
  InitHatchPattern(HatchStyleWave, 'M1,2 A 2 3 0 0 0 4 2 A 2 3 0 0 1 7 2 M1,6 A 2 3 0 0 0 4 6 A 2 3 0 0 1 7 6').SetLineCap(lcsRound);
  InitHatchPattern(HatchStyleDiagonalBrick, 'M0,8 L8,0 M-1,1 L1,-1 M7,9 L9,7 M4,4 L8,8');
  InitHatchPattern(HatchStyleHorizontalBrick, 'M8,0.5 L0.5,0.5 L0.5,4.5 L8,4.5 M4.5,4.5 L4.5,8');
  InitHatchPattern(HatchStyleDivot, 'M2,1 L3.5,2.5 L2,4 M7,4 L5.5,5.5 L7,7');
  InitHatchPattern(HatchStyleDottedGrid, 'M0,8 L0,0 L8,0').SetStyle(TdxStrokeStyle.Dot);
  InitHatchPattern(HatchStyleDottedDiamond, 'M0,0 L8,8 M0,8 L8,0').SetStyle(TdxStrokeStyle.Dot);
  InitHatchPattern(HatchStyleTrellis, 'M0,0.5 L4,0.5 M1,1.5 L3,1.5 M5,1.5 L6,1.5 M0,2.5 L4,2.5 M0,3.5 L1,3.5 M3,3.5 L5,3.5').Size := 4;
  InitHatchPattern(HatchStyleSmallGrid, 'M0.5,8 L0.5,0.5 L8,0.5 M4.5,0 L4.5,8 M0,4.5 L8,4.5');
  InitHatchPattern(HatchStyleSmallCheckerBoard, 'M0.5,0.5 h1 v1 h-1 v-1 M2.5,2.5 h1 v1 h-1 v-1').SetLineCap(lcsSquare).Size := 4;
  InitHatchPattern(HatchStyleLargeCheckerBoard, 'M1,1 h2 v2 h-2 v-2 M5,5 h2 v2 h-2 v-2', 2).SetLineCap(lcsSquare);
  InitHatchPattern(HatchStyleOutlinedDiamond, 'M0,0 L8,8 M0,8 L8,0');
  InitHatchPattern(HatchStyleSolidDiamond, 'M4,0 L8,4 L4,8 L0,4').SolidFill := True;

  InitHatchPattern(HatchStyle05Percent, 'M0,0.5 h1 M4,4.5 h1');
  InitHatchPattern(HatchStyle10Percent, 'M0,0.5 h1 M4,2.5 h1 M0,4.5 h1 M4,6.5 h1');
  InitHatchPattern(HatchStyle20Percent, 'M0,0.5 h1 M2,2.5 h1').Size := 4;
  InitHatchPattern(HatchStyle25Percent, 'M0,0.5 h1 M2,1.5 h1 M0,2.5 h1 M2,3.5 h1').Size := 4;
  InitHatchPattern(HatchStyle30Percent, 'M0,0.5 h1 M2,0.5 h1 M1,1.5 h1 M0,2.5 h1 M2,2.5 h1 M3,3.5 h1').Size := 4;
  InitHatchPattern(HatchStyle40Percent,
    'M0,0.5 h1 M2,0.5 h1 M4,0.5 h1 M6,0.5 h1 ' +
    'M1,1.5 h1 M3,1.5 h1 M5,1.5 h1 M7,1.5 h1 ' +
    'M0,2.5 h1 M2,2.5 h1 M4,2.5 h1 M6,2.5 h1 ' +
    'M1,3.5 h1 M3,3.5 h1           M7,3.5 h1 ' +
    'M0,4.5 h1 M2,4.5 h1 M4,4.5 h1 M6,4.5 h1 ' +
    'M1,5.5 h1 M3,5.5 h1 M5,5.5 h1 M7,5.5 h1 ' +
    'M0,6.5 h1 M2,6.5 h1 M4,6.5 h1 M6,6.5 h1 ' +
    '          M3,7.5 h1 M5,7.5 h1 M7,7.5 h1 ');
  InitHatchPattern(HatchStyle50Percent, 'M0,0.5 h1 M1,1.5 h1').Size := 2;
  InitHatchPattern(HatchStyle60Percent, 'M0,0.5 h3 M3.5,1 v3 M1,1.5 h1 M0,2.5 h1 M2,2.5 h1 M1,3.5 h1').Size := 4;
  InitHatchPattern(HatchStyle70Percent, 'M1,0.5 h3 M0,1.5 h2 M3,1.5 h1 M1,2.5 h3 M0,3.5 h2 M3,3.5 h1').Size := 4;
  InitHatchPattern(HatchStyle75Percent, 'M0,0.5 h1 M2,2.5 h1').SetInvertColors.Size := 4;
  InitHatchPattern(HatchStyle80Percent, 'M3,0.5 h1 M7,2.5 h1 M3,4.5 h1 M7,6.5 h1').SetInvertColors;
  InitHatchPattern(HatchStyle90Percent, 'M0,7.5 h1 M4,4.5 h1').SetInvertColors;

  InitHatchPattern(HatchStyleShingle,
    'M0,1.5 h1 M1,2.5 h1 M2,3.5 h2 M4,4.5 h2 M6,5.5 h1 M7.5,6 v2 M4,2.5 h1 M5,1.5 h1 M6,0.5 h2');
  InitHatchPattern(HatchStyleSmallConfetti,
    'M0,0.5 h1 M4,1.5 h1 M1,2.5 h1 M6,3.5 h1 M3,4.5 h1 M7,5.5 h1 M2,6.5 h1 M5,7.5 h1');
  InitHatchPattern(HatchStyleLargeConfetti,
    'M0,0.5 h1 M7,0.5 h1 M0,7.5 h1 M7,7.5 h1' +
    'M2.5,0.5 h1 v1 h-1 v-1.5 ' +
    'M6.5,2.5 h1 v1 h-1 v-1.5 ' +
    'M0.5,4.5 h1 v1 h-1 v-1.5 ' +
    'M3.5,3.5 h1 v1 h-1 v-1.5 ' +
    'M4.5,6.5 h1 v1 h-1 v-1.5 ');

  InitHatchPattern(HatchStyleSphere,
    'M0,0.5 h1 M4,0.5 h1 ' +
    'M1,1.5 h3 M5,1.5 h2 ' +
    'M1,2.5 h3 ' +
    'M1,3.5 h3 ' +
    'M0,4.5 h1 M4,4.5 h1 ' +
    'M1,5.5 h2 M5,5.5 h3 ' +
    '          M5,6.5 h3 ' +
    '          M5,7.5 h3 '
  ).InvertColors := True;

  InitHatchPattern(HatchStylePlaid,
    'M0,0.5 h1 M2,0.5 h1 M4,0.5 h1 M6,0.5 h1 ' +
    'M1,1.5 h1 M3,1.5 h1 M5,1.5 h1 M7,1.5 h1 ' +
    'M0,2.5 h1 M2,2.5 h1 M4,2.5 h1 M6,2.5 h1 ' +
    'M1,3.5 h1 M3,3.5 h1 M5,3.5 h1 M7,3.5 h1 ' +
    'M0,4.5 h4 ' +
    'M0,5.5 h4 ' +
    'M0,6.5 h4 ' +
    'M0,7.5 h4 ');

  InitHatchPattern(HatchStyleWeave,
    'M0,0.5 h1 M4,0.5 h1 ' +
    'M1,1.5 h1 M3,1.5 h1 M5,1.5 h1 ' +
    'M2,2.5 h1 M6,2.5 h1 ' +
    'M1,3.5 h1 M5,3.5 h1 M7,3.5 h1 ' +
    'M0,4.5 h1 M4,4.5 h1 ' +
    'M3,5.5 h1 M5,5.5 h1 ' +
    'M2,6.5 h1 M6,6.5 h1 ' +
    'M1,7.5 h1 M3,7.5 h1 M7,7.5 h1 ');
end;

class procedure TdxSVGFillFactory.AssignGradientStops(
  AGradient: TdxSVGElementCustomGradient; APoints: TdxGPBrushGradientPoints; AFillEdges: Boolean);
var
  I: Integer;
begin
  if APoints.Count > 0 then
  begin
    if APoints.Offsets[0] > 0 then
      AGradient.AddStop(0, APoints.Colors[0], IfThen(AFillEdges, 1));
    for I := 0 to APoints.Count - 1 do
      AGradient.AddStop(APoints.Offsets[I] * 100, APoints.Colors[I]);
    if APoints.Offsets[APoints.Count - 1] < 1 then
      AGradient.AddStop(1, APoints.Colors[APoints.Count - 1], IfThen(AFillEdges, 1));
  end;
end;

class function TdxSVGFillFactory.ConvertBrush(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill;
var
  AGpBrush: TdxGPBrush absolute ABrush;
begin
  case AGpBrush.Style of
    gpbsSolid:
      Result := TdxSVGFill.Create(AGpBrush.Color);
    gpbsClear:
      Result := TdxSVGFill.Create(TdxAlphaColors.Empty);
    gpbsGradient:
      Result := CreateLinearGradientBrush(ACanvas, AGpBrush.GradientPoints, dxGpBrushGradientModeToLinearGradientMode[AGpBrush.GradientMode]);
    gpbsTexture:
      Result := CreateTextureFill(ACanvas, ABounds, AGpBrush.Texture, 0, 0, AGpBrush.TextureTransform);
  else
    raise EInvalidArgument.Create('unsupported style');
  end;
end;

class function TdxSVGFillFactory.ConvertComplexBrush(
  ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill;
begin
  Result := ConvertComplexBrushCore(ACanvas, ABounds, ABrush, Round(ABounds.Width), Round(ABounds.Height));
end;

class function TdxSVGFillFactory.ConvertComplexBrushCore(ACanvas: TdxSVGCanvas;
  const ABounds: TdxRectF; ABrush: TdxGPCustomBrush; APatternWidth, APatternHeight: Integer): TdxSVGFill;
var
  ATexture: TdxGPImage;
  ATextureCanvas: TdxGPCanvas;
begin
  ATexture := TdxGPImage.CreateSize(APatternWidth, APatternHeight);
  try
    ATextureCanvas := ATexture.CreateCanvas;
    try
      ATextureCanvas.FillRectangle(ATexture.ClientRect, ABrush);
    finally
      ATextureCanvas.Free;
    end;

    Result := CreateTextureFill(ACanvas, ABounds, ATexture,
      FMod(ABounds.Left, ATexture.Width), FMod(ABounds.Top, ATexture.Height));
  finally
    ATexture.Free;
  end;
end;

class function TdxSVGFillFactory.ConvertHatchBrush(
  ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill;
var
  ABackground: TdxSVGElementRectangle;
  ABackgroundColor: TdxAlphaColor;
  AFigure: TdxSVGElementPath;
  AForegroundColor: TdxAlphaColor;
  AHatchBrush: TdxGPHatchBrush absolute ABrush;
  AHatchPattern: TdxSVGHatchPattern;
  APattern: TdxSVGElementPattern;
begin
  AHatchPattern := FHatchPatterns[AHatchBrush.Style];
  if AHatchPattern <> nil then
  begin
    ABackgroundColor := AHatchBrush.BackgroundColor;
    AForegroundColor := AHatchBrush.ForegroundColor;
    if AHatchPattern.InvertColors then
      ExchangeLongWords(ABackgroundColor, AForegroundColor);

    ACanvas.AppendDefinition(TdxSVGElementPattern, APattern);
    if APattern.PatternUnitsType = TdxSVGContentUnits.cuObjectBoundingBox then
    begin
      APattern.X := TdxSVGValue.Create(FMod(ABounds.Left, AHatchPattern.Size), utPx);
      APattern.Y := TdxSVGValue.Create(FMod(ABounds.Top, AHatchPattern.Size), utPx);
      APattern.Width := TdxSVGValue.Create(100 * AHatchPattern.Size / ABounds.Width, utPercents);
      APattern.Height := TdxSVGValue.Create(100 * AHatchPattern.Size / ABounds.Height, utPercents);
    end
    else
    begin
      APattern.X := TdxSVGValue.Create(0, utPx);
      APattern.Y := TdxSVGValue.Create(0, utPx);
      APattern.Height := TdxSVGValue.Create(AHatchPattern.Size, utPx);
      APattern.Width := TdxSVGValue.Create(AHatchPattern.Size, utPx);
    end;
    APattern.ViewBox.Value := dxRectF(0, 0, AHatchPattern.Size, AHatchPattern.Size);

    ABackground := TdxSVGElementRectangle.Create(APattern);
    ABackground.ShapeRendering := TdxSVGShapeRendering.srOptimizeSpeed;
    ABackground.SetBounds(cxRect(0, 0, AHatchPattern.Size, AHatchPattern.Size), utPx);
    ABackground.Fill := TdxSVGFill.Create(ABackgroundColor);
    ABackground.FillOpacity := ACanvas.GetOpacity(ABackgroundColor);
    ABackground.ShapeRendering := ACanvas.ShapeRendering;

    AFigure := TdxSVGElementPath.Create(APattern);
    AFigure.ShapeRendering := TdxSVGShapeRendering.srAuto;
    AFigure.Path.FromString(AHatchPattern.Path);

    if AHatchPattern.SolidFill then
    begin
      AFigure.Fill := TdxSVGFill.Create(AForegroundColor);
      AFigure.FillOpacity := ACanvas.GetOpacity(AForegroundColor);
    end
    else
    begin
      AFigure.Fill := TdxSVGFill.Create(TdxAlphaColors.Empty);
      AFigure.Stroke := TdxSVGFill.Create(AForegroundColor);
      AFigure.StrokeOpacity := ACanvas.GetOpacity(AForegroundColor);
      AFigure.StrokeLineCap := AHatchPattern.StrokeLineCap;
      AFigure.StrokeLineJoin := LineJoinMiter;
      AFigure.StrokeSize := AHatchPattern.StrokeThickness;
      ACanvas.SetStrokeDashArray(AFigure, AHatchPattern.StrokeStyle, AFigure.StrokeSize);
    end;

    Result := TdxSVGFill.Create(APattern.ID);
  end
  else
    Result := ConvertComplexBrushCore(ACanvas, ABounds, ABrush, TdxSVGHatchPattern.DefaultSize, TdxSVGHatchPattern.DefaultSize);
end;

class function TdxSVGFillFactory.ConvertLinearGradientBrush(
  ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill;
var
  AGpBrush: TdxGpLinearGradientBrush absolute ABrush;
begin
  if AGpBrush.GradientMode = gplgbmLine then
    Result := CreateLinearGradientBrush(ACanvas, AGpBrush.GradientPoints, AGpBrush.StartPoint, AGpBrush.EndPoint)
  else
    Result := CreateLinearGradientBrush(ACanvas, AGpBrush.GradientPoints,
      dxGpLinearGradientBrushModeToLinearGradientMode[AGpBrush.GradientMode]);
end;

class function TdxSVGFillFactory.ConvertRadialGradientBrush(
  ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill;
var
  AGradient: TdxSVGElementRadialGradient;
  ARadialGradientBrush: TdxRadialGradientBrush absolute ABrush;
begin
  ACanvas.AppendDefinition(TdxSVGElementRadialGradient, AGradient);
  AssignGradientStops(AGradient, ARadialGradientBrush.GradientPoints, True);
  AGradient.CenterX := TdxSVGValue.Create(100 * ARadialGradientBrush.Center.X, utPercents);
  AGradient.CenterY := TdxSVGValue.Create(100 * ARadialGradientBrush.Center.Y, utPercents);
  AGradient.Radius := TdxSVGValue.Create(100 * ARadialGradientBrush.Radius.X, utPercents);
  Result := TdxSVGFill.Create(AGradient.ID);
end;

class function TdxSVGFillFactory.ConvertSolidBrush(
  ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill;
begin
  Result := TdxSVGFill.Create(TdxGPSolidBrush(ABrush).Color);
end;

class function TdxSVGFillFactory.ConvertTextureBrush(
  ACanvas: TdxSVGCanvas; const ABounds: TdxRectF; ABrush: TdxGPCustomBrush): TdxSVGFill;
begin
  Result := CreateTextureFill(ACanvas, ABounds, TdxGpTextureBrush(ABrush).Texture);
end;

class function TdxSVGFillFactory.CreateLinearGradientBrush(
  ACanvas: TdxSVGCanvas; APoints: TdxGPBrushGradientPoints; AMode: TdxGpLinearGradientMode): TdxSVGFill;
var
  AGradient: TdxSVGElementLinearGradient;
begin
  ACanvas.AppendDefinition(TdxSVGElementLinearGradient, AGradient);
  AssignGradientStops(AGradient, APoints);
  AGradient.SetBounds(AMode);
  Result := TdxSVGFill.Create(AGradient.ID);
end;

class function TdxSVGFillFactory.CreateLinearGradientBrush(
  ACanvas: TdxSVGCanvas; APoints: TdxGPBrushGradientPoints; const AStartPoint, AEndPoint: TdxPointF): TdxSVGFill;
var
  AGradient: TdxSVGElementLinearGradient;
begin
  ACanvas.AppendDefinition(TdxSVGElementLinearGradient, AGradient);
  AssignGradientStops(AGradient, APoints);
  AGradient.SetBounds(100 * AStartPoint.X, 100 * AStartPoint.Y, 100 * AEndPoint.X, 100 * AEndPoint.Y, utPercents);
  Result := TdxSVGFill.Create(AGradient.ID);
end;

class function TdxSVGFillFactory.CreateTextureFill(ACanvas: TdxSVGCanvas; const ABounds: TdxRectF;
  ATexture: TdxGPImage; AOffsetX: Single = 0; AOffsetY: Single = 0; ATransform: TdxGPMatrix = nil): TdxSVGFill;
var
  AImage: TdxSVGElementImage;
  APattern: TdxSVGElementPattern;
begin
  ACanvas.AppendDefinition(TdxSVGElementPattern, APattern);
  if APattern.PatternUnitsType = TdxSVGContentUnits.cuObjectBoundingBox then
  begin
    APattern.X := TdxSVGValue.Create(AOffsetX, utPx);
    APattern.Y := TdxSVGValue.Create(AOffsetY, utPx);
    APattern.Width := TdxSVGValue.Create(100 * ATexture.Width / ABounds.Width, utPercents);
    APattern.Height := TdxSVGValue.Create(100 * ATexture.Height / ABounds.Height, utPercents);
  end
  else
  begin
    APattern.X := TdxSVGValue.Create(ABounds.Left, utPx);
    APattern.Y := TdxSVGValue.Create(ABounds.Top, utPx);
    APattern.Height := TdxSVGValue.Create(ATexture.Height, utPx);
    APattern.Width := TdxSVGValue.Create(ATexture.Width, utPx);
  end;
  APattern.ViewBox.Value := dxRectF(0, 0, ATexture.Width, ATexture.Height);
  if ATransform <> nil then
    APattern.PatternTransform.Assign(ATransform.ToXForm);

  AImage := TdxSVGElementImage.Create(APattern);
  AImage.Image.Assign(ATexture);
  AImage.SetBounds(ATexture.ClientRect);

  Result := TdxSVGFill.Create(APattern.ID);
end;


initialization

finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSVGFillFactory.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
