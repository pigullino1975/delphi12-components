{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library controls                  }
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

unit dxDirectX.D2D.Utils;

interface

{$I cxVer.inc}

uses
  UITypes,
  Windows, ActiveX, Types, D2D1, DxgiFormat, Graphics,
  dxCore, dxCoreGraphics, dxDirectX.D2D.Types, cxGeometry, dxGDIPlusClasses;

type

  { EdxDirectCustomException }

  EdxDirectCustomException = class(EdxException);

  { EdxDirectXInvalidStateException }

  EdxDirectXInvalidStateException = class(EdxDirectCustomException);

  { EdxDirectXError }

  EdxDirectXError = class(EdxDirectCustomException)
  strict private
    FErrorCode: HRESULT;
  public
    constructor Create(AErrorCode: HRESULT);
    //
    property ErrorCode: HRESULT read FErrorCode;
  end;

  { TdxD2DRectFHelper }

  TdxD2DRectFHelper = record helper for TD2DRectF
  public
    function Center(AWidth, AHeight: Single): TD2D1RectF;
    function CenterPoint: TD2D1Point2F;
    function Height: Single; inline;
    function Size: TD2D1SizeF;
    function Width: Single; inline;
  end;

var
  dxNullD2DColor: TD2D1ColorF = (r: 0; g: 0; b: 0; a: 0);

procedure CheckD2D1Result(AValue: HRESULT); inline;
function D2D1Bitmap(const AContext: ID2D1DeviceContext; ABitmap: TBitmap; AAlphaFormat: TAlphaFormat): ID2D1Bitmap1; overload;
function D2D1Bitmap(const AContext: ID2D1DeviceContext; ABitmap: TdxCustomFastDIB; AAlphaFormat: TAlphaFormat): ID2D1Bitmap1; overload;
function D2D1Bitmap(const AContext: ID2D1DeviceContext; ABits: PByte;
  AWidth, AHeight, AStride: Integer; AAlphaFormat: TAlphaFormat): ID2D1Bitmap1; overload;
function D2D1CalculateArcSegment(const R: TD2D1RectF; const AArcStart, AArcEnd: TD2D1Point2F;
  out ACenter, AStartPoint: TD2D1Point2F): TD2D1ArcSegment; overload;
function D2D1CalculateArcSegment(const R: TD2D1RectF; const AStartAngle, ASweepAngle: Single;
  out ACenter, AStartPoint: TD2D1Point2F): TD2D1ArcSegment; overload;
function D2D1ColorF(const AColor: TdxAlphaColor): TD2D1ColorF; overload; inline;
function D2D1Ellipse(const R: TD2D1RectF): TD2D1Ellipse; overload;
function D2D1GradientStops(const AStops: TdxGPBrushGradientPoints; AExtendNearestColorsToEdges: Boolean = False): TD2D1GradientStops;
function D2D1Point(const P: TdxPointF): TD2D1Point2F; overload; inline;
function D2D1Point(const P: TPoint): TD2D1Point2F; overload; inline;
function D2D1Point(const X, Y: Single): TD2D1Point2F; overload; inline;
function D2D1Rect(const L, T, R, B: Single): TD2D1RectF; overload; inline;
function D2D1Rect(const R: TdxRectF): TD2D1RectF; overload; inline;
function D2D1Rect(const R: TRect): TD2D1RectF; overload; inline;
function D2D1RectIsEqual(const R1, R2: TD2D1RectF): Boolean; inline;
function D2D1SizeU(const W, H: Integer): TD2D1SizeU; overload; inline;
function D2D1SizeIsEqual(const R: TD2D1RectF; const S: TD2D1SizeF): Boolean; overload; inline;
function D2D1SizeIsEqual(const R1, R2: TD2D1RectF): Boolean; overload; inline;
function D2D1SizeIsEqual(const S1, S2: TD2D1SizeF): Boolean; overload; inline;
function D2D1Matrix3x2(const XForm: TXForm): TD2D1Matrix3x2F; overload;
function D2D1Matrix3x2(const M11, M12, M21, M22, DX, DY: Single): TD2D1Matrix3x2F; overload;
implementation

uses
  dxFading, Math;

const
  dxThisUnitName = 'dxDirectX.D2D.Utils';

const
  scxDirectXInvalidOperation = 'Invalid operation in DirectX (Code: %d)';

const
  sdxSizeComparingDelta = 0.01;

procedure CheckD2D1Result(AValue: HRESULT);
begin
  if Failed(AValue) then
    raise EdxDirectXError.Create(AValue);
end;

function D2D1Bitmap(const AContext: ID2D1DeviceContext; ABitmap: TdxCustomFastDIB; AAlphaFormat: TAlphaFormat): ID2D1Bitmap1;
begin
  Result := D2D1Bitmap(AContext, PByte(ABitmap.Bits), ABitmap.Width, ABitmap.Height, ABitmap.Width * 4, AAlphaFormat);
end;

function D2D1Bitmap(const AContext: ID2D1DeviceContext; ABits: PByte; AWidth, AHeight, AStride: Integer; AAlphaFormat: TAlphaFormat): ID2D1Bitmap1;
const
  AlphaModeMap: array[TAlphaFormat] of {$IFDEF DELPHI104SYDNEY}D2D1_ALPHA_MODE{$ELSE}Integer{$ENDIF} = (
    D2D1_ALPHA_MODE_IGNORE,
    D2D1_ALPHA_MODE_STRAIGHT,
    D2D1_ALPHA_MODE_PREMULTIPLIED
  );
var
  ABitmapProperties: TD2D1BitmapProperties1;
  ATempBits: PByte;
  ATempBitsCount: Integer;
begin
  if AAlphaFormat = afDefined then
  begin
    ATempBitsCount := AWidth * AHeight;
    ATempBits := AllocMem(SizeOf(TRGBQuad) * ATempBitsCount);
    try
      Move(ABits^, ATempBits^, SizeOf(TRGBQuad) * ATempBitsCount);
      TdxColors.Premultiply(PRGBQuad(ATempBits), ATempBitsCount);
      Result := D2D1Bitmap(AContext, ATempBits, AWidth, AHeight, AWidth * SizeOf(TRGBQuad), afPremultiplied);
    finally
      FreeMem(ATempBits);
    end;
  end
  else
  begin
    ZeroMemory(@ABitmapProperties, SizeOf(ABitmapProperties));
    ABitmapProperties.pixelFormat.format := DXGI_FORMAT_B8G8R8A8_UNORM;
    ABitmapProperties.pixelFormat.alphaMode := AlphaModeMap[AAlphaFormat];
    CheckD2D1Result(AContext.CreateBitmap(D2D1SizeU(AWidth, AHeight), ABits, AStride, @ABitmapProperties, Result));
  end;
end;

function D2D1Bitmap(const AContext: ID2D1DeviceContext; ABitmap: TBitmap; AAlphaFormat: TAlphaFormat): ID2D1Bitmap1;
var
  AColors: TRGBColors;
begin
  if ABitmap.PixelFormat <> pf32bit then
    AAlphaFormat := afIgnored;

  GetBitmapBits(ABitmap, AColors, True);
  if AAlphaFormat <> afIgnored then
    TdxFadingHelper.CorrectAlphaChannel(AColors);
  Result := D2D1Bitmap(AContext, @AColors[0], ABitmap.Width, ABitmap.Height, ABitmap.Width * 4, AAlphaFormat);
end;

function D2D1NormalizeAngle(const AAngle: Single): Single; inline;
const
  PI2 = 2 * PI;
begin
  Result := AAngle;
  while Result < 0 do
    Result := Result + PI2;
  while Result > PI2 do
    Result := Result - PI2;
end;

function D2D1CalculateArcPoint(const ACenter, APoint: TD2D1Point2F; AAngle: Single; const ARadius: TD2D1SizeF): TD2D1Point2F;
var
  AA, BB: Single;
  ASlope: Single;
begin
  AAngle := D2D1NormalizeAngle(AAngle);

  AA := Sqr(ARadius.width);
  BB := Sqr(ARadius.height);
  ASlope := Sqr(APoint.Y - ACenter.y) / Max(Sqr(APoint.X - ACenter.x), 0.1);

  Result.x := Sqrt(AA * BB / (BB + AA * ASlope));
  Result.y := Sqrt(BB * (1 - Min(Sqr(Result.x) / AA, 1)));

  if (AAngle < Pi / 2) or (AAngle > 3 * PI / 2) then
    Result.x := ACenter.x + Result.x
  else
    Result.x := ACenter.x - Result.x;

  if AAngle > PI then
    Result.y := ACenter.y + Result.y
  else
    Result.y := ACenter.y - Result.y;
end;

function D2D1CalculateArcSegment(const R: TD2D1RectF; const AStartAngle, ASweepAngle: Single;
  out ACenter, AStartPoint: TD2D1Point2F): TD2D1ArcSegment;
var
  P3, P4: TdxPointF;
begin
  ZeroMemory(@Result, SizeOf(Result));
  Result.size.width := (R.right - R.left) * 0.5;
  Result.size.height := (R.bottom - R.top) * 0.5;

  if ASweepAngle > 0 then
    Result.sweepDirection := D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE
  else
    Result.sweepDirection := D2D1_SWEEP_DIRECTION_CLOCKWISE;

  if Abs(ASweepAngle) > 180 then
    Result.arcSize := D2D1_ARC_SIZE_LARGE
  else
    Result.arcSize := D2D1_ARC_SIZE_SMALL;

  ACenter := D2D1PointF((R.right + R.left) * 0.5, (R.bottom + R.top) * 0.5);
  dxCalculateArcSegment(ACenter.x, ACenter.y, Result.size.width, Result.size.height, AStartAngle, ASweepAngle, P3, P4);
  AStartPoint := D2D1CalculateArcPoint(ACenter, D2D1PointF(P3.X, P3.Y), DegToRad(AStartAngle), Result.size);
  Result.point := D2D1CalculateArcPoint(ACenter, D2D1PointF(P4.X, P4.Y), DegToRad(AStartAngle + ASweepAngle), Result.size);
end;

function D2D1CalculateArcSegment(const R: TD2D1RectF; const AArcStart, AArcEnd: TD2D1Point2F; out ACenter, AStartPoint: TD2D1Point2F): TD2D1ArcSegment;
var
  AAngle1: Single;
  AAngle2: Single;
  ASweepAngle: Single;
begin
  ZeroMemory(@Result, SizeOf(Result));
  Result.sweepDirection := D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE;
  Result.size.width := (R.right - R.left - 1) * 0.5;
  Result.size.height := (R.bottom - R.top - 1) * 0.5;

  ACenter := D2D1PointF((R.right + R.left) * 0.5, (R.bottom + R.top) * 0.5);
  AAngle1 := Pi - ArcTan2(ACenter.Y - AArcStart.Y - 0.5, ACenter.X - AArcStart.X - 0.5);
  AAngle2 := Pi - ArcTan2(ACenter.Y - AArcEnd.Y - 0.5, ACenter.X - AArcEnd.X - 0.5);

  ASweepAngle := D2D1NormalizeAngle(AAngle2 - AAngle1);
  if ASweepAngle > PI then
    Result.arcSize := D2D1_ARC_SIZE_LARGE
  else
    Result.arcSize := D2D1_ARC_SIZE_SMALL;

  Result.point := D2D1CalculateArcPoint(ACenter, AArcEnd, AAngle2, Result.size);
  AStartPoint := D2D1CalculateArcPoint(ACenter, AArcStart, AAngle1, Result.size);
end;

function D2D1ColorF(const AColor: TdxAlphaColor): TD2D1ColorF; inline;
begin
  Result.r := dxGetRed(AColor)   / 255;
  Result.g := dxGetGreen(AColor) / 255;
  Result.b := dxGetBlue(AColor)  / 255;
  Result.a := dxGetAlpha(AColor) / 255;
end;

function D2D1Rect(const R: TdxRectF): TD2D1RectF;
begin
  Result.left := R.Left;
  Result.top := R.Top;
  Result.right := R.Right;
  Result.bottom := R.Bottom;
end;

function D2D1Rect(const R: TRect): TD2D1RectF;
begin
  Result.left := R.Left;
  Result.top := R.Top;
  Result.right := R.Right;
  Result.bottom := R.Bottom;
end;

function D2D1RectIsEqual(const R1, R2: TD2D1RectF): Boolean;
begin
  Result :=
    SameValue(R1.top, R2.top, sdxSizeComparingDelta) and
    SameValue(R1.left, R2.left, sdxSizeComparingDelta) and
    SameValue(R1.right, R2.right, sdxSizeComparingDelta) and
    SameValue(R1.bottom, R2.bottom, sdxSizeComparingDelta);
end;

function D2D1Rect(const L, T, R, B: Single): TD2D1RectF;
begin
  Result.left := L;
  Result.top := T;
  Result.right := R;
  Result.bottom := B;
end;

function D2D1Ellipse(const R: TD2D1RectF): TD2D1Ellipse;
begin
  Result.point.x := (R.left + R.right) * 0.5;
  Result.point.y := (R.top + R.bottom) * 0.5;
  Result.radiusX := (R.right - R.left) * 0.5;
  Result.radiusY := (R.bottom - R.top) * 0.5;
end;

function D2D1GradientStops(const AStops: TdxGPBrushGradientPoints; AExtendNearestColorsToEdges: Boolean = False): TD2D1GradientStops;
var
  AHasNullHead: Boolean;
  AHasNullTail: Boolean;
  AIndex: Integer;
  I: Integer;
begin
  if AStops.Count > 0 then
  begin
    AHasNullHead := AStops.Offsets[0] > 0;
    AHasNullTail := AStops.Offsets[AStops.Count - 1] < 1;

    AIndex := 0;
    SetLength(Result, AStops.Count + Ord(AHasNullHead) + Ord(AHasNullTail));
    if AHasNullHead then
    begin
      Result[AIndex].position := 0;
      if AExtendNearestColorsToEdges then
        Result[AIndex].color := D2D1ColorF(AStops.Colors[0])
      else
        Result[AIndex].color := dxNullD2DColor;
      Inc(AIndex);
    end;
    for I := 0 to AStops.Count - 1 do
    begin
      Result[AIndex].position := AStops.Offsets[I];
      Result[AIndex].color := D2D1ColorF(AStops.Colors[I]);
      Inc(AIndex);
    end;
    if AHasNullTail then
    begin
      Result[AIndex].position := 1;
      if AExtendNearestColorsToEdges then
        Result[AIndex].color := D2D1ColorF(AStops.Colors[AStops.Count - 1])
      else
        Result[AIndex].color := dxNullD2DColor;
    end;
  end
  else
    SetLength(Result, 0);
end;

function D2D1Point(const P: TdxPointF): TD2D1Point2F;
begin
  Result.x := P.X;
  Result.y := P.Y;
end;

function D2D1Point(const P: TPoint): TD2D1Point2F;
begin
  Result.x := P.X;
  Result.y := P.Y;
end;

function D2D1Point(const X, Y: Single): TD2D1Point2F;
begin
  Result.x := X;
  Result.y := Y;
end;

function D2D1SizeU(const W, H: Integer): TD2D1SizeU;
begin
  Result.Height := H;
  Result.Width := W;
end;

function D2D1SizeIsEqual(const R: TD2D1RectF; const S: TD2D1SizeF): Boolean;
begin
  Result := D2D1SizeIsEqual(R.Size, S);
end;

function D2D1SizeIsEqual(const R1, R2: TD2D1RectF): Boolean; overload;
begin
  Result := D2D1SizeIsEqual(R1.Size, R2.Size);
end;

function D2D1SizeIsEqual(const S1, S2: TD2D1SizeF): Boolean;
begin
  Result :=
    SameValue(S1.width, S2.width, sdxSizeComparingDelta) and
    SameValue(S1.height, S2.height, sdxSizeComparingDelta)
end;

function D2D1Matrix3x2(const XForm: TXForm): TD2D1Matrix3x2F;
begin
  Result._11 := XForm.eM11;
  Result._12 := XForm.eM12;
  Result._21 := XForm.eM21;
  Result._22 := XForm.eM22;
  Result._31 := XForm.eDx;
  Result._32 := XForm.eDy;
end;

function D2D1Matrix3x2(const M11, M12, M21, M22, DX, DY: Single): TD2D1Matrix3x2F;
begin
  Result._11 := M11;
  Result._12 := M12;
  Result._21 := M21;
  Result._22 := M22;
  Result._31 := Dx;
  Result._32 := Dy;
end;

{ EdxDirectXError }

constructor EdxDirectXError.Create(AErrorCode: HRESULT);
begin
  FErrorCode := AErrorCode;
  CreateFmt(scxDirectXInvalidOperation, [Ord(ErrorCode)]);
end;

{ TdxD2DRectFHelper }

function TdxD2DRectFHelper.Center(AWidth, AHeight: Single): TD2D1RectF;
begin
  Result.left := (left + right - AWidth) * 0.5;
  Result.top := (top + bottom - AHeight) * 0.5;
  Result.right := Result.left + AWidth;
  Result.bottom := Result.top + AHeight;
end;

function TdxD2DRectFHelper.CenterPoint: TD2D1Point2F;
begin
  Result := D2D1PointF((left + right) * 0.5, (top + bottom) * 0.5);
end;

function TdxD2DRectFHelper.Height: Single;
begin
  Result := bottom - top;
end;

function TdxD2DRectFHelper.Width: Single;
begin
  Result := right - left;
end;

function TdxD2DRectFHelper.Size: TD2D1SizeF;
begin
  Result := D2D1SizeF(Width, Height);
end;

end.
