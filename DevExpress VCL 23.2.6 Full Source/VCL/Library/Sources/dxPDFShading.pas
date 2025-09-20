{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPDFViewer                                         }
{                                                                    }
{           Copyright (c) 2015-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPDFVIEWER AND ALL              }
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

unit dxPDFShading;

{$I cxVer.inc}

interface

uses
  UITypes,
  Windows, Types, SysUtils, Classes, Graphics, Generics.Defaults, Generics.Collections, dxCoreClasses, dxCoreGraphics,
  dxGDIPlusClasses, dxGDIPlusAPI, cxGraphics, cxGeometry, dxPDFCore, dxPDFTypes, dxPDFCommandInterpreter;

type
  { IdxPDFShadingCoordinateConverter }

  IdxPDFShadingCoordinateConverter = interface
  ['{A1DCB705-85A5-49A9-B674-D09B596BC927}']
    function Convert(const APoint: TdxPointF): TdxPointF;
  end;

  { IdxPDFShadingColorConverter }

  IdxPDFShadingColorConverter = interface
  ['{AB0505D6-6463-4891-9230-D3525C801787}']
    function Convert(const AComponent: Double): TdxAlphaColor; overload;
    function Convert(const AComponents: TDoubleDynArray): TdxAlphaColor; overload;
  end;

  { TdxPDFGradientShading }

  TdxPDFGradientShading = class(TdxPDFCustomShading)
  strict private
    FDomain: TdxPDFRange;
    FExtendX: Boolean;
    FExtendY: Boolean;
    //
    function CreateDomain(AArray: TdxPDFArray): TdxPDFRanges; overload;
    function CreateDomain(AArray: TdxPDFArray; AIndex: Integer): TdxPDFRanges; overload;
    function IsValidCoordinateArray(AArray: TdxPDFArray): Boolean;
    function WriteCoords(AHelper: TdxPDFWriterHelper): TdxPDFArray;
    function WriteDomain(AHelper: TdxPDFWriterHelper): TdxPDFArray;
    function WriteExtend(AHelper: TdxPDFWriterHelper): TdxPDFArray;
    procedure ReadCoords(AArray: TdxPDFArray);
    procedure ReadDomain(AArray: TdxPDFArray);
    procedure ReadExtend(AArray: TdxPDFArray);
  protected
    FBounds: TdxRectF;
    //
    function GetPainter: IdxPDFShadingPainter; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Initialize; override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function GetValidCoordinateArraySize: Integer; virtual; abstract;
    procedure DoReadCoordinates(AArray: TdxPDFArray); virtual; abstract;
    procedure DoWriteCoordinates(AArray: TdxPDFArray); virtual; abstract;
  public
    property Bounds: TdxRectF read FBounds;
    property Domain: TdxPDFRange read FDomain;
    property ExtendX: Boolean read FExtendX;
    property ExtendY: Boolean read FExtendY;
  end;

  { TdxPDFAxialShading }

  TdxPDFAxialShading = class(TdxPDFGradientShading)
  protected
    function GetPainter: IdxPDFShadingPainter; override;
    function GetValidCoordinateArraySize: Integer; override;
    procedure DoReadCoordinates(AArray: TdxPDFArray); override;
    procedure DoWriteCoordinates(AArray: TdxPDFArray); override;
  public
    class function GetShadingType: Integer; override;
  end;

  { TdxPDFFunctionBasedShading }

  TdxPDFFunctionBasedShading = class(TdxPDFCustomShading)
  protected
    class function GetShadingType: Integer; override;
    function GetDomainDimension: Integer; override;
    function GetPainter: IdxPDFShadingPainter; override;
  end;

  { TdxPDFRadialShading }

  TdxPDFRadialShading = class(TdxPDFGradientShading)
  strict private
    FRadius: TdxPointDouble;
  protected
    function GetPainter: IdxPDFShadingPainter; override;
    function GetValidCoordinateArraySize: Integer; override;
    procedure DoReadCoordinates(AArray: TdxPDFArray); override;
    procedure DoWriteCoordinates(AArray: TdxPDFArray); override;
  public
    class function GetShadingType: Integer; override;
    //
    property Radius: TdxPointDouble read FRadius;
  end;

  { TdxPDFShadingPainter }

  TdxPDFShadingPainter = class
  strict private
    FInterpreter: IdxPDFCommandInterpreter;
    FPainter: IdxPDFShadingPainter;
    FShading: TdxPDFCustomShading;
    //
    function DoCreateBitmap(const AMatrix: TdxPDFTransformationMatrix; const ASize: TdxSizeF;
      AUseTransparency: Boolean): TcxBitmap32;
    function CreatePainter: Boolean;
    procedure DoDraw(const AInfo: TdxPDFShadingInfo);
    procedure Init(AInterpreter: IdxPDFCommandInterpreter; AShading: TdxPDFCustomShading);
  strict protected
    function GetBitmap(AInterpreter: IdxPDFCommandInterpreter; APattern: TdxPDFShadingPattern): TcxBitmap32; overload;
    function GetBitmap(AInterpreter: IdxPDFCommandInterpreter; AShading: TdxPDFCustomShading): TcxBitmap32; overload;
    procedure DrawShading(AGraphics: TdxGPCanvas; AInterpreter: IdxPDFCommandInterpreter; AShading: TdxPDFCustomShading);
  public
    class function CreateBitmap(const AInterpreter: IdxPDFCommandInterpreter;
      APattern: TdxPDFShadingPattern): TcxBitmap32; overload; static;
    class function CreateBitmap(const AInterpreter: IdxPDFCommandInterpreter;
      AShading: TdxPDFCustomShading): TcxBitmap32; overload; static;
    class procedure Draw(AGraphics: TdxGPCanvas; const AInterpreter: IdxPDFCommandInterpreter;
      AShading: TdxPDFCustomShading); static;
  end;

implementation

uses
  Math, dxCore, dxShapeBrushes, dxPDFBase, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFShading';

const
  cdxDegree90 = 90;
  cdxDegree180 = 180;
  cdxDegree360 = 360;
  cdxRadianToDegreeFactor = cdxDegree180 / Pi;

type
  TdxPDFCustomShadingAccess = class(TdxPDFCustomShading);

  { TdxPDFCustomShadingPainter }

  TdxPDFCustomShadingPainter = class(TInterfacedObject, IdxPDFShadingPainter)
  strict private
    FCoordinateConverter: IdxPDFShadingCoordinateConverter;
    FColorConverter: IdxPDFShadingColorConverter;
    FNeedDrawBackground: Boolean;
    FUseTransparentBackgroundColor: Boolean;

    procedure Initialize(const AInfo: TdxPDFShadingInfo);
  private
    FBounds: TdxRectF;
    FShading: TdxPDFCustomShading;
  protected
    procedure Calculate(const AInfo: TdxPDFShadingInfo); virtual;
    procedure DoDraw(const AInfo: TdxPDFShadingInfo); virtual;

    function ConvertColor(const AComponents: TDoubleDynArray): TdxAlphaColor;

    property ColorConverter: IdxPDFShadingColorConverter read FColorConverter write FColorConverter;
    property CoordinateConverter: IdxPDFShadingCoordinateConverter read FCoordinateConverter;
  public
    procedure Draw(const AInfo: TdxPDFShadingInfo);
  end;

  TdxPDFCustomShadingPainterClass = class of TdxPDFCustomShadingPainter;

  { TdxPDFGradientShadingPainter }

  TdxPDFGradientShadingPainter = class(TdxPDFCustomShadingPainter)
  private
    FRotateAngle: Double;
  protected
    procedure Calculate(const AInfo: TdxPDFShadingInfo); override;
    procedure CalculateBounds(const ABounds: TdxRectF); virtual;
    procedure CalculateRotateAngle; virtual;
  end;

  { TdxPDFAxialShadingPainter }

  TdxPDFAxialShadingPainter = class(TdxPDFGradientShadingPainter)
  strict private
    FBitmapSize: TSize;
    FBrushBitmapWidth: Integer;
    FLocation: TdxPointF;
    FPenWidth: Single;
    function CreateRange(V1, V2, V3, V4: Single): TdxPDFRange;
    function GetColorComponents: Integer;
    procedure CalculatePenWidth(const ABoundsSize: TdxSizeF);
    procedure CalculateTextureBrushWidth;
    procedure CalculateTextureData(out AData: TBytes);
    procedure CalculateTextureSize(const ABoundsSize: TdxSizeF);
    procedure DrawNonlinearGradientLine(AGraphics: GpGraphics; const ATextureData: TBytes; ABrushBitmapWidth, AStride: Integer;
      const ABrushMatrix: TdxPDFTransformationMatrix; const AStartPoint, AEndPoint: TdxPointF; AGradientBrushPenWidth: Single);
    procedure DrawOuterSpaces(AGraphics: TdxGPCanvas);
  protected
    procedure Calculate(const AInfo: TdxPDFShadingInfo); override;
    procedure CalculateBounds(const ABounds: TdxRectF); override;
    procedure CalculateRotateAngle; override;
    procedure DoDraw(const AInfo: TdxPDFShadingInfo); override;
    //
    property ColorComponents: Integer read GetColorComponents;
  end;

  { TdxPDFRadialShadingPainter }

  TdxPDFRadialShadingPainter = class(TdxPDFGradientShadingPainter)
  strict private
    FLength: Integer;
    FRadius: TPoint;
    FMaxShadingSide: Integer;

    function GetCircleDistance: Single;
    function GetTangentAngle: Single;

    function CreateOuterSpaceStartPath: TdxGPPath;
    function CreateOuterSpaceEndPath: TdxGPPath;

    procedure CalculateLength;
    procedure DrawOuterSpaceStart(AGraphics: TdxGPCanvas; AShading: TdxPDFRadialShading);
    procedure DrawOuterSpaceEnd(AGraphics: TdxGPCanvas; AShading: TdxPDFRadialShading);
    procedure DrawPath(AGraphics: TdxGPCanvas; APath: TdxGPPath; const P: TdxPointF; ABrush: TdxGPBrush);
    procedure DrawSpace(AGraphics: TdxGPCanvas; AShading: TdxPDFRadialShading);
  protected
    procedure CalculateBounds(const ABounds: TdxRectF); override;
    procedure CalculateRotateAngle; override;
    procedure Calculate(const AInfo: TdxPDFShadingInfo); override;
    procedure DoDraw(const AInfo: TdxPDFShadingInfo); override;
  end;

  { TdxPDFBitmapShadingCoordsConverter }

  TdxPDFBitmapShadingCoordsConverter = class(TInterfacedObject, IdxPDFShadingCoordinateConverter)
  strict private
    FShading: TdxPDFCustomShading;
    FSize: TSize;
  protected
    function Convert(const APoint: TdxPointF): TdxPointF;
  public
    constructor Create(AShading: TdxPDFCustomShading; const ASize: TSize);
  end;

  { TdxPDFUserSpaceShadingCoordsConverter }

  TdxPDFUserSpaceShadingCoordsConverter = class(TInterfacedObject, IdxPDFShadingCoordinateConverter)
  strict private
    FInterpreter: IdxPDFCommandInterpreter;
    FMatrix: TdxPDFTransformationMatrix;
  protected
    function Convert(const APoint: TdxPointF): TdxPointF;
  public
    constructor Create(AInterpreter: IdxPDFCommandInterpreter; const AMatrix: TdxPDFTransformationMatrix);
  end;

  { TdxPDFShadingColorConverter }

  TdxPDFShadingColorConverter = class(TInterfacedObject, IdxPDFShadingColorConverter)
  strict private
    FShadingPainter: TdxPDFCustomShadingPainter;
  protected
    function Convert(const AComponents: TDoubleDynArray): TdxAlphaColor; overload;
    function Convert(const AComponent: Double): TdxAlphaColor; overload;
  public
    constructor Create(AShadingPainter: TdxPDFCustomShadingPainter);
  end;

{ TdxPDFBitmapShadingCoordsConverter }

constructor TdxPDFBitmapShadingCoordsConverter.Create(AShading: TdxPDFCustomShading; const ASize: TSize);
begin
  inherited Create;
  FShading := AShading;
  FSize := ASize;
end;

function TdxPDFBitmapShadingCoordsConverter.Convert(const APoint: TdxPointF): TdxPointF;
var
  ABoundingBoxLeft, ABoundingBoxBottom: Double;
begin
  if FShading.BoundingBox.IsNull then
    Result := dxPointF(0, 0)
  else
  begin
    ABoundingBoxLeft := FShading.BoundingBox.Left;
    ABoundingBoxBottom := FShading.BoundingBox.Bottom;
    Result.X := (APoint.X - ABoundingBoxLeft) * FSize.cx / (FShading.BoundingBox.Right - ABoundingBoxLeft);
    Result.Y := FSize.cy - (APoint.Y - ABoundingBoxBottom) * FSize.cy / (FShading.BoundingBox.Top - ABoundingBoxBottom);
  end;
end;

{ TdxPDFUserSpaceShadingCoordsConverter }

constructor TdxPDFUserSpaceShadingCoordsConverter.Create(AInterpreter: IdxPDFCommandInterpreter;
  const AMatrix: TdxPDFTransformationMatrix);
begin
  inherited Create;
  FInterpreter := AInterpreter;
  FMatrix := AMatrix;
end;

function TdxPDFUserSpaceShadingCoordsConverter.Convert(const APoint: TdxPointF): TdxPointF;
begin
  Result := FInterpreter.TransformShadingPoint(FMatrix.Transform(APoint));
end;

{ TdxPDFShadingColorConverter }

constructor TdxPDFShadingColorConverter.Create(AShadingPainter: TdxPDFCustomShadingPainter);
begin
  inherited Create;
  FShadingPainter := AShadingPainter;
end;

function TdxPDFShadingColorConverter.Convert(const AComponents: TDoubleDynArray): TdxAlphaColor;
begin
  Result := FShadingPainter.ConvertColor(AComponents);
end;

function TdxPDFShadingColorConverter.Convert(const AComponent: Double): TdxAlphaColor;
var
  AComponents: TDoubleDynArray;
begin
  SetLength(AComponents, 1);
  AComponents[0] := AComponent;
  Result := Convert(AComponents);
end;

{ TdxPDFShadingPainter }

class function TdxPDFShadingPainter.CreateBitmap(const AInterpreter: IdxPDFCommandInterpreter;
  APattern: TdxPDFShadingPattern): TcxBitmap32;
var
  APainter: TdxPDFShadingPainter;
begin
  APainter := TdxPDFShadingPainter.Create;
  try
    Result := APainter.GetBitmap(AInterpreter, APattern);
  finally
    APainter.Free;
  end;
end;

class function TdxPDFShadingPainter.CreateBitmap(const AInterpreter: IdxPDFCommandInterpreter;
  AShading: TdxPDFCustomShading): TcxBitmap32;
var
  APainter: TdxPDFShadingPainter;
begin
  APainter := TdxPDFShadingPainter.Create;
  try
    Result := APainter.GetBitmap(AInterpreter, AShading);
  finally
    APainter.Free;
  end;
end;

class procedure TdxPDFShadingPainter.Draw(AGraphics: TdxGPCanvas; const AInterpreter: IdxPDFCommandInterpreter;
  AShading: TdxPDFCustomShading);
var
  APainter: TdxPDFShadingPainter;
begin
  APainter := TdxPDFShadingPainter.Create;
  try
    APainter.DrawShading(AGraphics, AInterpreter, AShading);
  finally
    APainter.Free;
  end;
end;

function TdxPDFShadingPainter.GetBitmap(AInterpreter: IdxPDFCommandInterpreter; APattern: TdxPDFShadingPattern): TcxBitmap32;
var
  AMatrix: TdxPDFTransformationMatrix;
begin
  Init(AInterpreter, APattern.Shading);
  AMatrix := TdxPDFTransformationMatrix.Multiply(APattern.Matrix, AInterpreter.TransformMatrix);
  Result := DoCreateBitmap(AMatrix, dxSizeF(AInterpreter.ActualSize.cx, AInterpreter.ActualSize.cy), False);
end;

function TdxPDFShadingPainter.GetBitmap(AInterpreter: IdxPDFCommandInterpreter; AShading: TdxPDFCustomShading): TcxBitmap32;
var
  ASize: TdxSizeF;
begin
  Init(AInterpreter, AShading);
  ASize := AInterpreter.TransformSize(AInterpreter.TransformMatrix, AShading.BoundingBox);
  if (ASize.cx = 0) or (ASize.cy = 0) then
    Result := nil
  else
    Result := DoCreateBitmap(TdxPDFTransformationMatrix.Null, ASize, True);
end;

procedure TdxPDFShadingPainter.DrawShading(AGraphics: TdxGPCanvas; AInterpreter: IdxPDFCommandInterpreter;
  AShading: TdxPDFCustomShading);
var
  AInfo: TdxPDFShadingInfo;
begin
  Init(AInterpreter, AShading);
  if CreatePainter then
  begin
    AInfo.Size := dxSizeF(FInterpreter.ActualSize.cx, FInterpreter.ActualSize.cy);
    AInfo.Graphics := AGraphics;
    AInfo.Interpreter := FInterpreter;
    AInfo.Shading := FShading;
    AInfo.TransformMatrix := FInterpreter.TransformMatrix;
    AInfo.NeedDrawBackground := False;
    AInfo.UseTransparency := False;
    DoDraw(AInfo);
  end;
end;

function TdxPDFShadingPainter.DoCreateBitmap(const AMatrix: TdxPDFTransformationMatrix; const ASize: TdxSizeF;
  AUseTransparency: Boolean): TcxBitmap32;
var
  AInfo: TdxPDFShadingInfo;
begin
  Result := nil;
  if CreatePainter then
  begin
    Result := TcxBitmap32.CreateSize(Round(ASize.cx), Round(ASize.cy));
    Result.Canvas.Lock;
    dxGPPaintCanvas.BeginPaint(Result.Canvas.Handle, Result.ClientRect);
    try
      AInfo.Size := ASize;
      AInfo.Graphics := dxGPPaintCanvas;
      AInfo.Interpreter := FInterpreter;
      AInfo.Shading := FShading;
      AInfo.TransformMatrix := AMatrix;
      AInfo.NeedDrawBackground := True;
      AInfo.UseTransparency := AUseTransparency;
      DoDraw(AInfo);
    finally
      dxGPPaintCanvas.EndPaint;
      Result.Canvas.Unlock;
    end;
  end;
end;

function TdxPDFShadingPainter.CreatePainter: Boolean;
begin
  Result := FShading <> nil;
  if Result then
  begin
    FPainter := TdxPDFCustomShadingAccess(FShading).GetPainter;
    Result := FPainter <> nil;
  end;
end;

procedure TdxPDFShadingPainter.DoDraw(const AInfo: TdxPDFShadingInfo);
begin
  FPainter.Draw(AInfo);
end;

procedure TdxPDFShadingPainter.Init(AInterpreter: IdxPDFCommandInterpreter;
  AShading: TdxPDFCustomShading);
begin
  FInterpreter := AInterpreter;
  FShading := AShading;
end;

{ TdxPDFCustomShadingPainter }

procedure TdxPDFCustomShadingPainter.Draw(const AInfo: TdxPDFShadingInfo);
begin
  Calculate(AInfo);
  DoDraw(AInfo);
end;

function TdxPDFCustomShadingPainter.ConvertColor(const AComponents: TDoubleDynArray): TdxAlphaColor;
begin
  Result := TdxPDFUtils.ConvertToAlphaColor(FShading.TransformFunction(AComponents), 1);
end;

procedure TdxPDFCustomShadingPainter.Calculate(const AInfo: TdxPDFShadingInfo);
begin
  Initialize(AInfo);
end;

procedure TdxPDFCustomShadingPainter.DoDraw(const AInfo: TdxPDFShadingInfo);
var
  AColor: TdxAlphaColor;
begin
  if AInfo.NeedDrawBackground then
  begin
    if AInfo.UseTransparency then
      AColor := TdxAlphaColors.Transparent
    else
      if FShading.BackgroundColor.IsNull then
        AColor := TdxAlphaColors.Transparent
      else
        AColor := TdxPDFUtils.ConvertToAlphaColor(FShading.BackgroundColor, 1);
    AInfo.Graphics.Clear(dxAlphaColorToColor(AColor));
  end;
end;

procedure TdxPDFCustomShadingPainter.Initialize(const AInfo: TdxPDFShadingInfo);
var
  ASize: TSize;
begin
  FShading := AInfo.Shading;
  FNeedDrawBackground := AInfo.NeedDrawBackground;
  FUseTransparentBackgroundColor := AInfo.UseTransparency;
  ASize.cx := Round(AInfo.Size.cx);
  ASize.cy := Round(AInfo.Size.cy);
  if AInfo.TransformMatrix.IsNull then
    FCoordinateConverter := TdxPDFBitmapShadingCoordsConverter.Create(FShading, ASize)
  else
    FCoordinateConverter := TdxPDFUserSpaceShadingCoordsConverter.Create(AInfo.Interpreter, AInfo.TransformMatrix);
  FColorConverter := TdxPDFShadingColorConverter.Create(Self);
end;

{ TdxPDFGradientShadingPainter }

procedure TdxPDFGradientShadingPainter.Calculate(const AInfo: TdxPDFShadingInfo);
begin
  inherited Calculate(AInfo);
  CalculateBounds((FShading as TdxPDFGradientShading).Bounds);
  CalculateRotateAngle;
end;

procedure TdxPDFGradientShadingPainter.CalculateBounds(const ABounds: TdxRectF);
begin
// do nothing
end;

procedure TdxPDFGradientShadingPainter.CalculateRotateAngle;
begin
// do nothing
end;

{ TdxPDFAxialShadingPainter }

procedure TdxPDFAxialShadingPainter.CalculateTextureSize(const ABoundsSize: TdxSizeF);
var
  AAdjacentTop, AOppositeTop, AAdjacentBottom, AOppositeBottom: Double;
  ARangeX, ARangeY: TdxPDFRange;
  ASize: TdxPointF;
begin
  ARangeX := CreateRange(0, FBounds.Left, FBounds.Right, ABoundsSize.cx);
  ARangeY := CreateRange(0, FBounds.Top, FBounds.Bottom, ABoundsSize.cy);
  ASize := dxPointF(ARangeX.Max - ARangeX.Min, ARangeY.Max - ARangeY.Min);
  if (FRotateAngle >= 0.0) and (FRotateAngle < PI / 2.0) or (FRotateAngle >= PI) and (FRotateAngle < PI + PI / 2.0) then
  begin
    AAdjacentTop := Cos(FRotateAngle) * ASize.X;
    AOppositeTop := Sin(FRotateAngle) * ASize.X;
    AAdjacentBottom := Cos(FRotateAngle) * ASize.Y;
    AOppositeBottom := Sin(FRotateAngle) * ASize.Y;
  end
  else
  begin
    AAdjacentTop := Sin(FRotateAngle) * ASize.Y;
    AOppositeTop := Cos(FRotateAngle) * ASize.Y;
    AAdjacentBottom := Sin(FRotateAngle) * ASize.X;
    AOppositeBottom := Cos(FRotateAngle) * ASize.X;
  end;
  FBitmapSize.cx := TdxPDFUtils.ConvertToInt(Ceil(Abs(AAdjacentTop) + Abs(AOppositeBottom)));
  FBitmapSize.cy := TdxPDFUtils.ConvertToInt(Ceil(Abs(AAdjacentBottom) + Abs(AOppositeTop)));
end;

procedure TdxPDFAxialShadingPainter.DrawNonlinearGradientLine(AGraphics: GpGraphics; const ATextureData: TBytes; ABrushBitmapWidth, AStride: Integer;
  const ABrushMatrix: TdxPDFTransformationMatrix; const AStartPoint, AEndPoint: TdxPointF; AGradientBrushPenWidth: Single);
var
  ABitmap: GpBitmap;
  AGradientBrush: GPTexture;
  APen: GpPen;
  M: TdxGPMatrix;
begin
  GdipCheck(GdipCreateBitmapFromScan0(ABrushBitmapWidth, 1, AStride, PixelFormat32bppArgb, @ATextureData[0], ABitmap));
  try
    GdipCheck(GdipCreateTexture2(ABitmap, WrapModeTileFlipXY, 0, 0, ABrushBitmapWidth, 1, AGradientBrush));
    try
      M := TdxPDFUtils.ConvertToGpMatrix(ABrushMatrix);
      try
        GdipCheck(GdipSetTextureTransform(AGradientBrush, M.Handle));
      finally
        M.Free;
      end;
      GdipCheck(GdipCreatePen2(AGradientBrush, AGradientBrushPenWidth, guWorld, APen));
      try
        GdipCheck(GdipDrawLine(AGraphics, APen, FBounds.Left, FBounds.Top, FBounds.Right, FBounds.Bottom));
      finally
        GdipCheck(GdipDeletePen(APen));
      end;
    finally
      GdipCheck(GdipDeleteBrush(AGradientBrush));
    end;
  finally
    GdipCheck(GdipDisposeImage(ABitmap));
  end;
end;

procedure TdxPDFAxialShadingPainter.Calculate(const AInfo: TdxPDFShadingInfo);
begin
  inherited Calculate(AInfo);
  CalculateTextureSize(AInfo.Size);
  CalculatePenWidth(AInfo.Size);
  CalculateTextureBrushWidth;
end;

procedure TdxPDFAxialShadingPainter.CalculateRotateAngle;
begin
  FRotateAngle := ArcTan2(FBounds.Height, FBounds.Width);
end;

function TdxPDFAxialShadingPainter.CreateRange(V1, V2, V3, V4: Single): TdxPDFRange;
var
  AMinValue, AMaxValue: Single;
begin
  if V1 > V2 then
  begin
    AMaxValue := V1;
    AMinValue := V2;
  end
  else
  begin
    AMaxValue := V2;
    AMinValue := V1;
  end;
  if V3 > AMaxValue then
    AMaxValue := V3
  else
    if V3 < AMinValue then
      AMinValue := V3;
  if V4 > AMaxValue then
    AMaxValue := V4
  else
    if V4 < AMinValue then
      AMinValue := V4;
  Result := TdxPDFRange.Create(AMinValue, AMaxValue);
end;

function TdxPDFAxialShadingPainter.GetColorComponents: Integer;
begin
  Result := 4;
end;

procedure TdxPDFAxialShadingPainter.CalculateBounds(const ABounds: TdxRectF);
begin
  FBounds.TopLeft := CoordinateConverter.Convert(ABounds.TopLeft);
  FBounds.BottomRight := CoordinateConverter.Convert(ABounds.BottomRight);
  FLocation := dxPointF(FBounds.Left + FBounds.Width / 2, FBounds.Top + FBounds.Height / 2);
end;

procedure TdxPDFAxialShadingPainter.CalculatePenWidth(const ABoundsSize: TdxSizeF);
var
  A, B, C: Single;
  ARange: TdxPDFRange;
begin
  if Abs(FBounds.Width) >= Abs(FBounds.Height) then
  begin
    if FBounds.Width = 0 then
      A := 0
    else
      A := FBounds.Height / FBounds.Width;
    B := -1;
    C := FBounds.Top - A * FBounds.Left;
  end
  else
  begin
    A := -1;
    if FBounds.Height = 0 then
      B := 0
    else
      B := FBounds.Width / FBounds.Height;
    C := FBounds.Left - B * FBounds.Top;
  end;
  ARange := CreateRange(Abs(C), Abs(A * ABoundsSize.cx + C), Abs(B * ABoundsSize.cy + C), Abs(A * ABoundsSize.cx +
    B * ABoundsSize.cy + C));
  FPenWidth := ARange.Max / Sqrt(A * A + B * B) * 2;
end;

procedure TdxPDFAxialShadingPainter.CalculateTextureBrushWidth;
begin
  FBrushBitmapWidth := TdxPDFUtils.ConvertToInt(Sqrt(FBounds.Width * FBounds.Width + FBounds.Height * FBounds.Height)) + 1;
end;

procedure TdxPDFAxialShadingPainter.CalculateTextureData(out AData: TBytes);
var
  AColor: TdxAlphaColor;
  ADomain: TdxPDFRange;
  I, J, AMaxBrushPixelPosition: Integer;
  ADomainSize: Double;
begin
  ADomain := (FShading as TdxPDFGradientShading).Domain;
  ADomainSize := ADomain.Max - ADomain.Min;
  AMaxBrushPixelPosition := FBrushBitmapWidth - 1;
  SetLength(AData, ColorComponents * FBrushBitmapWidth);
  J := 0;
  for I := 0 to FBrushBitmapWidth - 1 do
  begin
    AColor := ColorConverter.Convert(ADomain.Min + I * ADomainSize / AMaxBrushPixelPosition);
    AData[J] := dxAlphaColorToRGBQuad(AColor).rgbBlue;
    AData[J + 1] := dxAlphaColorToRGBQuad(AColor).rgbGreen;
    AData[J + 2] := dxAlphaColorToRGBQuad(AColor).rgbRed;
    AData[J + 3] := 255;
    Inc(J, ColorComponents);
  end;
end;

procedure TdxPDFAxialShadingPainter.DrawOuterSpaces(AGraphics: TdxGPCanvas);
var
  AShading: TdxPDFGradientShading;
  ASavedState: TdxGpGraphicsState;
begin
  AShading := FShading as TdxPDFGradientShading;
  if (AShading.ExtendX) or (AShading.ExtendY) then
  begin
    GdipCheck(GdipSaveGraphics(AGraphics.Handle, ASavedState));
    try
      AGraphics.TranslateWorldTransform(FLocation.X, FLocation.Y);
      AGraphics.RotateWorldTransform(FRotateAngle * cdxRadianToDegreeFactor);
      if AShading.ExtendX then
        AGraphics.FillRectangle(TdxRectF.CreateSize(-FBitmapSize.cx, -FBitmapSize.cy, FBitmapSize.cx, FBitmapSize.cy * 2),
          ColorConverter.Convert(AShading.Domain.Min));
      if AShading.ExtendY then
        AGraphics.FillRectangle(TdxRectF.CreateSize(0, -FBitmapSize.cy, FBitmapSize.cx, FBitmapSize.cy * 2),
          ColorConverter.Convert(AShading.Domain.Max));
    finally
      GdipCheck(GdipRestoreGraphics(AGraphics.Handle, ASavedState));
    end;
  end;
end;

procedure TdxPDFAxialShadingPainter.DoDraw(const AInfo: TdxPDFShadingInfo);
var
  ATextureData: TBytes;
  AMatrix: TdxPDFTransformationMatrix;
begin
  inherited DoDraw(AInfo);
  DrawOuterSpaces(AInfo.Graphics);

  AMatrix := TdxPDFTransformationMatrix.Create(1, 0, 0, 1, FBounds.Left, FBounds.Top);
  AMatrix := TdxPDFTransformationMatrix.Multiply(
    TdxPDFTransformationMatrix.CreateRotate(FRotateAngle * cdxRadianToDegreeFactor), AMatrix);
  if (FRotateAngle > PI / 2.0) or (FRotateAngle < 0.0) then
    AMatrix := TdxPDFTransformationMatrix.Multiply(TdxPDFTransformationMatrix.Create(1, 0, 0, 1, 1, 0), AMatrix);

  CalculateTextureData(ATextureData);
  DrawNonlinearGradientLine(AInfo.Graphics.Handle, ATextureData, FBrushBitmapWidth, ColorComponents * FBrushBitmapWidth,
    AMatrix, FBounds.TopLeft, FBounds.BottomRight, FPenWidth);
end;

{ TdxPDFRadialShadingPainter }

procedure TdxPDFRadialShadingPainter.CalculateBounds(const ABounds: TdxRectF);
var
  ACircleStartLeft: TdxPointF;
  ACircleEndLeft: TdxPointF;
  AShading: TdxPDFRadialShading;
begin
  FBounds.TopLeft := CoordinateConverter.Convert(ABounds.TopLeft);
  FBounds.BottomRight := CoordinateConverter.Convert(ABounds.BottomRight);

  AShading := FShading as TdxPDFRadialShading;
  ACircleStartLeft := CoordinateConverter.Convert(dxPointF(ABounds.Left - AShading.Radius.X, ABounds.Top));
  ACircleEndLeft := CoordinateConverter.Convert(dxPointF(ABounds.Right - AShading.Radius.Y, ABounds.Bottom));

  FRadius := cxPoint(Trunc(cxPointDistanceF(ACircleStartLeft, FBounds.TopLeft)), Trunc(cxPointDistanceF(ACircleEndLeft,
    FBounds.BottomRight)));
end;

procedure TdxPDFRadialShadingPainter.CalculateRotateAngle;
begin
  FRotateAngle := ArcTan2(FBounds.BottomRight.Y - FBounds.TopLeft.Y, FBounds.BottomRight.X - FBounds.TopLeft.X);
end;

procedure TdxPDFRadialShadingPainter.Calculate(const AInfo: TdxPDFShadingInfo);
begin
  inherited Calculate(AInfo);
  FMaxShadingSide := Max(AInfo.Interpreter.ActualSize.cx, AInfo.Interpreter.ActualSize.cy);
  CalculateLength;
end;

procedure TdxPDFRadialShadingPainter.DoDraw(const AInfo: TdxPDFShadingInfo);
var
  AShading: TdxPDFRadialShading;
begin
  inherited DoDraw(AInfo);
  if (FRadius.X <> 0) or (FRadius.Y <> 0) then
  begin
    AShading := FShading as TdxPDFRadialShading;
    DrawSpace(AInfo.Graphics, AShading);
    DrawOuterSpaceStart(AInfo.Graphics, AShading);
    DrawOuterSpaceEnd(AInfo.Graphics, AShading);
  end;
end;

function TdxPDFRadialShadingPainter.GetCircleDistance: Single;
begin
  Result := cxPointDistanceF(FBounds.BottomRight, FBounds.TopLeft);
end;

function TdxPDFRadialShadingPainter.GetTangentAngle: Single;
var
  ADistanceBetweenCircleCenters: Single;
  AValue: Single;
begin
  ADistanceBetweenCircleCenters := GetCircleDistance;
  if ADistanceBetweenCircleCenters = 0 then
    Result := cdxDegree360
  else
  begin
    AValue := Abs(FRadius.Y - FRadius.X) / ADistanceBetweenCircleCenters;
    if InRange(AValue, -1, 1) then
      Result := (ArcCos(AValue) * cdxRadianToDegreeFactor)
    else
      Result := dxPDFInvalidValue;
  end;
end;

function TdxPDFRadialShadingPainter.CreateOuterSpaceStartPath: TdxGPPath;

  function GetDistance: Single;
  var
    ADr: Integer;
  begin
    ADr := FRadius.Y - FRadius.X;
    if ADr = 0 then
      Exit(FMaxShadingSide * 2);
    if ADr > 0 then
      Result := (FRadius.X * GetCircleDistance / ADr)
    else
      Result := (FMaxShadingSide * 2 - FRadius.X) * GetCircleDistance / -ADr;
  end;

var
  ARadius: Integer;
  AAngle, ASweepAngle, ADiameter, ADistance: Single;
begin
  ARadius := FRadius.Y - FRadius.X;
  ADiameter := FRadius.X * 2;
  ADistance := GetDistance;
  Result := TdxGPPath.Create;
  Result.FigureStart;
  if ARadius = 0 then
  begin
    Result.AddArc(-FRadius.X, -FRadius.X, ADiameter, ADiameter, cdxDegree90, cdxDegree180);
    Result.AddArc(-ADistance - FRadius.X, -FRadius.X, ADiameter, ADiameter, -cdxDegree90, -cdxDegree180);
  end
  else
  begin
    AAngle := GetTangentAngle;
    if ARadius > 0 then
    begin
      if TdxPDFUtils.IsDoubleValid(AAngle) then
      begin
        Result.AddArc(-FRadius.X, -FRadius.X, ADiameter, ADiameter, cdxDegree180 - AAngle, AAngle * 2);
        Result.AddLine(-ADistance, 0, -ADistance, 0);
      end;
    end
    else
      if TdxPDFUtils.IsDoubleValid(AAngle) then
      begin
        ASweepAngle := cdxDegree360 - AAngle * 2;
        Result.AddArc(-FRadius.X, -FRadius.X, ADiameter, ADiameter, AAngle, ASweepAngle);
        ADiameter := FMaxShadingSide * 4;
        Result.AddArc(-ADistance - FMaxShadingSide * 2, -FMaxShadingSide * 2, ADiameter, ADiameter, -AAngle, -ASweepAngle);
      end;
  end;
  Result.FigureFinish;
end;

function TdxPDFRadialShadingPainter.CreateOuterSpaceEndPath: TdxGPPath;

  function GetDistance: Single;
  var
    ADistance: Integer;
  begin
    ADistance := FRadius.Y - FRadius.X;
    if ADistance = 0 then
      Exit(FMaxShadingSide * 2);
    if ADistance > 0 then
      Result := ((FMaxShadingSide * 2 - FRadius.Y) * GetCircleDistance / ADistance)
    else
      Result := (FBounds.BottomRight.X * GetCircleDistance / -ADistance);
  end;

var
  ARadius: Integer;
  AAngle, AStartAngle, ASweepAngle, ADiameter, ADistance: Single;
begin
  ARadius := FRadius.Y - FRadius.X;
  ADiameter := FRadius.Y * 2;
  ADistance := GetDistance;
  Result := TdxGPPath.Create;
  Result.FigureStart;
  if ARadius = 0 then
  begin
    Result.AddArc(-FRadius.Y, -FRadius.Y, ADiameter, ADiameter, cdxDegree90, cdxDegree180);
    Result.AddArc(ADistance - FRadius.Y, -FRadius.Y, ADiameter, ADiameter, -cdxDegree90, -cdxDegree180);
  end
  else
  begin
    AAngle := GetTangentAngle;
    if ARadius < 0 then
    begin
      Result.AddArc(-FRadius.Y, -FRadius.Y, ADiameter, ADiameter, AAngle, cdxDegree360 - AAngle * 2);
      Result.AddLine(ADistance, 0, ADistance, 0);
    end
    else
    begin
      AStartAngle := cdxDegree180 - AAngle;
      ASweepAngle := AAngle * 2;
      Result.AddArc(-FRadius.Y, -FRadius.Y, ADiameter, ADiameter, AStartAngle, ASweepAngle);
      ARadius := FMaxShadingSide * 2;
      ADiameter := ARadius * 2;
      Result.AddArc(ADistance - ARadius, -ARadius, ADiameter, ADiameter, -AStartAngle, -ASweepAngle);
    end;
  end;
  Result.FigureFinish;
end;

procedure TdxPDFRadialShadingPainter.CalculateLength;
var
  D: TdxPointDouble;
begin
  D.X := Max(Abs((FBounds.Right - FRadius.Y) - (FBounds.Left - FRadius.X)), Abs((FBounds.Right + FRadius.Y) - (FBounds.Left + FRadius.X)));
  D.Y := Max(Abs((FBounds.Bottom - FRadius.Y) - (FBounds.Top - FRadius.X)), Abs((FBounds.Bottom + FRadius.Y) - (FBounds.Top + FRadius.X)));
  FLength := Trunc(Sqrt((D.X * D.X + D.Y * D.Y)) * 1.5);
end;

procedure TdxPDFRadialShadingPainter.DrawPath(AGraphics: TdxGPCanvas; APath: TdxGPPath; const P: TdxPointF;
  ABrush: TdxGPBrush);
var
  APen: TdxGPPen;
begin
  AGraphics.SaveWorldTransform;
  try
    AGraphics.TranslateWorldTransform(P.X, P.Y);
    AGraphics.RotateWorldTransform(FRotateAngle * cdxRadianToDegreeFactor);
    APen := TdxGPPen.Create;
    APen.Brush := ABrush;
    try
      AGraphics.Path(APath, APen, ABrush);
    finally
      APen.Free;
    end;
  finally
    AGraphics.RestoreWorldTransform;
  end;
end;

procedure TdxPDFRadialShadingPainter.DrawSpace(AGraphics: TdxGPCanvas; AShading: TdxPDFRadialShading);
var
  I: Integer;
  R: TdxRectF;
  AFactor, ARadius, AComponentOffset: Single;
  APen: TdxGPPen;
  ASize: TdxPointF;
begin
  ASize := dxPointF(FBounds.Width, FBounds.Height);
  ARadius := FRadius.Y - FRadius.X;
  AComponentOffset := (AShading.Domain.Max - AShading.Domain.Min) / (FLength - 1);
  APen := TdxGPPen.Create;
  try
    for I := 0 to FLength - 1 do
    begin
      AFactor := I / FLength - 1;
      ARadius := FRadius.X + AFactor * ARadius;
      R.TopLeft := dxPointF(FBounds.Left + AFactor * ASize.X - ARadius, FBounds.Top + AFactor * ASize.Y - ARadius);
      R.BottomRight := cxPointOffset(R.TopLeft, dxPointF(ARadius * 2, ARadius * 2));
      APen.Brush.Color := ColorConverter.Convert(AShading.Domain.Min + I * AComponentOffset);
      AGraphics.Ellipse(R, APen, APen.Brush);
    end;
  finally
    APen.Free;
  end;
end;

procedure TdxPDFRadialShadingPainter.DrawOuterSpaceStart(AGraphics: TdxGPCanvas; AShading: TdxPDFRadialShading);
var
  APath: TdxGPPath;
  ABrush: TdxGPBrush;
begin
  if AShading.ExtendX and (FRadius.X <> 0) then
  begin
    ABrush := TdxGPBrush.Create;
    ABrush.Color := ColorConverter.Convert(AShading.Domain.Min);
    try
      APath := CreateOuterSpaceStartPath;
      try
        DrawPath(AGraphics, APath, FBounds.TopLeft, ABrush);
      finally
        APath.Free;
      end
    finally
      ABrush.Free;
    end;
  end;
end;

procedure TdxPDFRadialShadingPainter.DrawOuterSpaceEnd(AGraphics: TdxGPCanvas; AShading: TdxPDFRadialShading);
var
  APath: TdxGPPath;
  ABrush: TdxGPBrush;
begin
  if AShading.ExtendY and (FRadius.Y <> 0) then
  begin
    ABrush := TdxGPBrush.Create;
    ABrush.Color := ColorConverter.Convert(AShading.Domain.Max);
    try
      APath := CreateOuterSpaceEndPath;
      try
        DrawPath(AGraphics, APath, FBounds.BottomRight, ABrush);
      finally
        APath.Free;
      end
    finally
      ABrush.Free;
    end;
  end;
end;

{ TdxPDFGradientShading }

function TdxPDFGradientShading.GetPainter: IdxPDFShadingPainter;
begin
  Result := TdxPDFGradientShadingPainter.Create;
end;

procedure TdxPDFGradientShading.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  ReadDomain(ADictionary.GetArray(TdxPDFKeywords.Domain));
  ReadExtend(ADictionary.GetArray(TdxPDFKeywords.Extend));
  ReadCoords(ADictionary.GetArray(TdxPDFKeywords.Coords));
end;

procedure TdxPDFGradientShading.Initialize;
begin
  inherited Initialize;
  FDomain := TdxPDFRange.Create(0, 1);
end;

procedure TdxPDFGradientShading.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.Domain, WriteDomain(AHelper));
  ADictionary.Add(TdxPDFKeywords.Extend, WriteExtend(AHelper));
  ADictionary.Add(TdxPDFKeywords.Coords, WriteCoords(AHelper));
end;

function TdxPDFGradientShading.CreateDomain(AArray: TdxPDFArray): TdxPDFRanges;
var
  I, AIndex: Integer;
begin
  if (AArray = nil) or (AArray.Count = 0) or (AArray.Count mod 2 > 0) then
    TdxPDFUtils.Abort;
  AIndex := 0;
  for I := 0 to AArray.Count div 2 - 1 do
  begin
    TdxPDFUtils.AddData(CreateDomain(AArray, AIndex), Result);
    Inc(AIndex, 2);
  end;
end;

function TdxPDFGradientShading.CreateDomain(AArray: TdxPDFArray; AIndex: Integer): TdxPDFRanges;
begin
  SetLength(Result, 1);
  Result[0] := TdxPDFRange.Create(
    TdxPDFUtils.ConvertToDouble(AArray[AIndex]),
    TdxPDFUtils.ConvertToDouble(AArray[AIndex + 1]));
end;

function TdxPDFGradientShading.IsValidCoordinateArray(AArray: TdxPDFArray): Boolean;
begin
  Result := (AArray <> nil) and (AArray.Count = GetValidCoordinateArraySize);
end;

function TdxPDFGradientShading.WriteCoords(AHelper: TdxPDFWriterHelper): TdxPDFArray;
begin
  Result := AHelper.CreateArray;
  DoWriteCoordinates(Result);
end;

function TdxPDFGradientShading.WriteDomain(AHelper: TdxPDFWriterHelper): TdxPDFArray;
begin
  Result := AHelper.CreateArray;
  Result.Add(Domain);
end;

function TdxPDFGradientShading.WriteExtend(AHelper: TdxPDFWriterHelper): TdxPDFArray;
begin
  Result := AHelper.CreateArray;
  Result.Add(FExtendX);
  Result.Add(FExtendY);
end;

procedure TdxPDFGradientShading.ReadCoords(AArray: TdxPDFArray);
begin
  if IsValidCoordinateArray(AArray) then
    DoReadCoordinates(AArray);
end;

procedure TdxPDFGradientShading.ReadDomain(AArray: TdxPDFArray);
var
  ADomain: TdxPDFRanges;
begin
  if AArray <> nil then
  begin
    ADomain := CreateDomain(AArray);
    FDomain := TdxPDFRange.Create(ADomain[0].Min, ADomain[0].Max);
  end;
end;

procedure TdxPDFGradientShading.ReadExtend(AArray: TdxPDFArray);
begin
  if (AArray <> nil) and (AArray.Count = 2) then
  begin
    FExtendX := (AArray[0] as TdxPDFBoolean).Value;
    FExtendY := (AArray[1] as TdxPDFBoolean).Value;
  end;
end;

{ TdxPDFAxialShading }

class function TdxPDFAxialShading.GetShadingType: Integer;
begin
  Result := 2;
end;

function TdxPDFAxialShading.GetPainter: IdxPDFShadingPainter;
begin
  Result := TdxPDFAxialShadingPainter.Create;
end;

function TdxPDFAxialShading.GetValidCoordinateArraySize: Integer;
begin
  Result := 4;
end;

procedure TdxPDFAxialShading.DoReadCoordinates(AArray: TdxPDFArray);
begin
  FBounds.TopLeft := TdxPDFUtils.ArrayToPointF(AArray, 0);
  FBounds.BottomRight := TdxPDFUtils.ArrayToPointF(AArray, 2);
end;

procedure TdxPDFAxialShading.DoWriteCoordinates(AArray: TdxPDFArray);
begin
  AArray.Add(FBounds.Left);
  AArray.Add(FBounds.Top);
  AArray.Add(FBounds.Right);
  AArray.Add(FBounds.Bottom);
end;

{ TdxPDFFunctionBasedShading }

class function TdxPDFFunctionBasedShading.GetShadingType: Integer;
begin
  Result := 1;
end;

function TdxPDFFunctionBasedShading.GetDomainDimension: Integer;
begin
  Result := 2;
end;

function TdxPDFFunctionBasedShading.GetPainter: IdxPDFShadingPainter;
begin
  Result := nil; // TODO: IMPLEMENT
end;

{ TdxPDFRadialShading }

class function TdxPDFRadialShading.GetShadingType: Integer;
begin
  Result := 3;
end;

function TdxPDFRadialShading.GetPainter: IdxPDFShadingPainter;
begin
  Result := TdxPDFRadialShadingPainter.Create;
end;

function TdxPDFRadialShading.GetValidCoordinateArraySize: Integer;
begin
  Result := 6;
end;

procedure TdxPDFRadialShading.DoReadCoordinates(AArray: TdxPDFArray);
begin
  FBounds.TopLeft := TdxPDFUtils.ArrayToPointF(AArray, 0);
  FBounds.BottomRight := TdxPDFUtils.ArrayToPointF(AArray, 3);
  FRadius := dxPointDouble(Max(TdxPDFUtils.ConvertToDouble(AArray[2]), 0), Max(TdxPDFUtils.ConvertToDouble(AArray[5]), 0));
end;

procedure TdxPDFRadialShading.DoWriteCoordinates(AArray: TdxPDFArray);
begin
  AArray.Add(FBounds.Left);
  AArray.Add(FBounds.Top);
  AArray.Add(FRadius.X);
  AArray.Add(FBounds.Right);
  AArray.Add(FBounds.Bottom);
  AArray.Add(FRadius.Y);
end;

end.

