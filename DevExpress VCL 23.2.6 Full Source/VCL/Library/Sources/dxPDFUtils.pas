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

unit dxPDFUtils;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  SysUtils, Types, Math, Classes, Windows, Graphics, Generics.Defaults, Generics.Collections, dxCore, dxCoreClasses, dxThreading,
  cxClasses, cxGraphics, dxCoreGraphics, cxGeometry, dxGDIPlusAPI, dxGDIPlusClasses, dxPDFBase, dxPDFTypes;

type
  { TdxPDFUtils }

  TdxPDFUtils = class // for internal use
  public const
    FieldNameDelimiter = '.';
  public
    class procedure AddByte(B: Byte; var ADestinationData: TBytes); static; inline;
    class procedure AddChar(AChar: Char; var ADestinationData: TCharArray); static; inline;
    class procedure AddData(const AData: TBytes; var ADestinationData: TBytes); overload; static; inline;
    class procedure AddData(const AData: TDoubleDynArray; var ADestinationData: TDoubleDynArray); overload; static; inline;
    class procedure AddData(const AData: TdxPDFRanges; var ADestinationData: TdxPDFRanges); overload; static; inline;
    class procedure AddPoint(const P: TdxPointF; var APoints: TdxPointsF); static; inline;
    class procedure AddRange(const ARange: TdxPDFRange; var ARanges: TdxPDFRanges); static;
    class procedure AddValue(const AValue: Double; var AData: TDoubleDynArray); overload; static;
    class procedure AddValue(const AValue: Integer; var AData: TIntegerDynArray); overload; static;
    class procedure AddValue(const AValue: Single; var AData: TSingleDynArray); overload; static;
    class procedure AddValue(const AValue: string; var AData: TStringDynArray); overload; static;
    class procedure ClearData(var AData: TBytes); static;
    class procedure CopyData(const AData: TDoubleDynArray; AIndex: Integer; var ADestinationData: TDoubleDynArray;
      ADestinationIndex, ACount: Integer); overload; static; inline;
    class procedure CopyData(const AData: TBytes; AIndex: Integer; var ADestinationData: TBytes;
      ADestinationIndex, ACount: Integer); overload; static; inline;
    class procedure CopyData(const AData: TIntegerDynArray; AIndex: Integer; var ADestinationData: TIntegerDynArray;
      ADestinationIndex, ACount: Integer); overload; static; inline;
    class procedure CopyData(const AData: TSmallIntDynArray; AIndex: Integer; var ADestinationData: TSmallIntDynArray;
      ADestinationIndex, ACount: Integer); overload; static; inline;
    class procedure DeleteData(AIndex, ACount: Integer; var ASourceData: TBytes); static; inline;
    class procedure InsertFirst(const AValue: Double; var AData: TDoubleDynArray); static;

    class function ArrayToDoubleArray(AArray: TdxPDFArray): TDoubleDynArray; static;
    class function ArrayToRectangle(AArray: TdxPDFArray): TdxPDFRectangle; static;
    class function ArrayToRectF(AArray: TdxPDFArray): TdxRectF; static;
    class function ArrayToPointF(AArray: TdxPDFArray; AIndex: Integer): TdxPointF; static; inline;
    class function ArrayToPoints(AArray: TdxPDFArray): TdxPointsF; static;
    class function ArrayToMatrix(AArray: TdxPDFArray): TdxPDFTransformationMatrix; static; inline;
    class function Distance(const P1, P2: TdxPointF): Single; static;
    class function DistanceToRect(const P: TPoint; const R: TdxRectF): Single; overload; static;
    class function DistanceToRect(const P: TdxPointF; const R: TdxRectF): Single; overload; static;
    class function DistanceToSegment(const APoint: TdxPointF; AStartX, AStartY, AEndX, AEndY: Single): Single; static;
    class function GenerateGUID: string; static;
    class function IsRectEmpty(const R: TdxRectF): Boolean; static; inline;
    class function Max(const AValue1, AValue2: Double): Double; static; inline;
    class function Lerp(const P1, P2: TdxPointF; const T: Double): TdxPointF; static;
    class function LoadGlyph(const AResourceName, AResourceType: string): TdxSmartGlyph;
    class function MatrixToArray(AMatrix: TdxPDFTransformationMatrix): TdxPDFArray; static;
    class function Min(const AValue1, AValue2: Double): Double; static; inline;
    class function MinMax(AValue, AMinValue, AMaxValue: Integer): Integer; static;
    class function NormalizeAngle(const AAngle: Double): Double; static; inline;
    class function NormalizeRectF(const R: TdxRectF): TdxRectF; static; inline;
    class function NormalizeRotate(ARotate: Integer): Integer; static;
    class function OrientedDistance(const AStart, AFinish: TdxPointF; AAngle: Single): Single; static;
    class function PointToArray(const APoint: TdxPointF): TdxPDFArray; static;
    class function PointsToArray(const APoints: TdxPointsF): TdxPDFArray; static;
    class function ReadLine(AStream: TStream): string; static;
    class function RectToArray(const ARect: TdxRectF; ACheckRect: Boolean = True): TdxPDFArray; static;
    class function RectContain(const ABounds, AInner: TdxRectF): Boolean; static; inline;
    class function RectIsEqual(const R1, R2: TdxRectF; ADelta: Single): Boolean; static;
    class function RectRotate(const R: TdxRectF): TdxRectF; static;
    class function RotatePoint(APoint: TdxPointF; AAngle: Single): TdxPointF; static;
    class function ToArray(AList: TStringList): TStringDynArray; static;

    class function EndsWith(const S, AEndsWith: string): Boolean; static;
    class function StartsWith(const S, AStartsWith: string): Boolean; static;

    class function BytesToStr(const AData: TBytes): string; static; inline;
    class function ByteToHexDigit(AByte: Byte): Byte; static;

    class function FormatFileSize(AFileSize: Int64; AAuto: Boolean = True): string; static;

    class function IsDigit(AByte: Byte): Boolean; static; inline;
    class function IsDoubleValid(const AValue: Double): Boolean; static; inline;
    class function IsIntegerValid(AValue: Integer): Boolean; static; inline;
    class function IsHexDigit(AByte: Byte): Boolean; static; inline;
    class function IsPeriod(AByte: Byte): Boolean; static; inline;
    class function IsReference(AObject: TdxPDFBase): Boolean; static; inline;
    class function IsSpace(AByte: Byte): Boolean; static; inline;
    class function IsUnicode(const AData: TBytes): Boolean; static; inline;
    class function IsUnicodeString(const AValue: string): Boolean; static; inline;
    class function IsWhiteSpace(AByte: Byte): Boolean; static; inline;

    class function StrToByteArray(const S: string): TBytes; static;

    class function Contains(const R1, R2: TdxRectF): Boolean; static; inline;
    class function Dot(const P1, P2: TdxPointF): Single; static; inline;
    class function Intersects(const R1, R2: TdxRectF): Boolean; overload; static;
    class function Intersects(out AIntersection: TdxRectF; const R1, R2: TdxRectF): Boolean; overload; static;
    class function PtInRect(const R: TdxRectF; const P: TdxPointF): Boolean; static; inline;
    class function Subtract(const P1, P2: TdxPointF): TdxPointF; static; inline;
    class function TrimRect(const R1, R2: TdxRectF): TdxRectF; static;

    class function ConvertToAlphaColor(const AValue: TdxPDFColor; const AAlpha: Double): TdxAlphaColor; static; inline;
    class function ConvertToColor(const AValue: TdxPDFColor): TColor; overload; static; inline;
    class function ConvertToColor(const AValue: TColor): TdxPDFColor; overload; static; inline;
    class function ConvertToByte(const AValue: Double): Byte; static;
    class function ConvertToBoolean(AValue: TdxPDFReferencedObject; ADefaultValue: Boolean): Boolean; static;
    class function ConvertToDigit(AValue: Byte): Byte; inline; static;
    class function ConvertToDouble(AValue: TdxPDFBase): Double; overload; static; inline;
    class function ConvertToDouble(AValue: TdxPDFReferencedObject; ADefaultValue: Double): Double; overload; static; inline;
    class function ConvertToInt(const AValue: Double): Integer; overload; static; inline;
    class function ConvertToInt(AValue: TdxPDFReferencedObject; ADefaultValue: Integer): Integer; overload; static; inline;
    class function ConvertToInt(AValue: TdxPDFBase): Integer; overload; static; inline;
    class function ConvertToIntEx(AValue: TcxRotationAngle): Integer; static;
    class function ConvertToGpMatrix(const AMatrix: TdxPDFTransformationMatrix): TdxGPMatrix; static;
    class function ConvertToGpPixelFormat(AFormat: TdxPDFPixelFormat): TdxGpPixelFormat; static;
    class function ConvertToPageRanges(const APageIndexes: TIntegerDynArray): string; static;
    class function ConvertToRenderingIntent(const AValue: string): TdxPDFRenderingIntent; static;
    class function ConvertToRotationAngle(AValue: Integer): TcxRotationAngle; static;
    class function ConvertToSingle(AValue: TdxPDFBase): Single; static;
    class function ConvertToStr(const AData: TBytes): string; overload; static;
    class function ConvertToStr(const AData: TBytes; ALength: Integer): string; overload; static;
    class function ConvertToStr(AValue: TdxPDFReferencedObject): string; overload; static;
    class function ConvertToStr(AValue: TdxPDFBase): string; overload; static;
    class function ConvertToStr(AValue: TdxPDFVersion): string; overload; static;
    class function ConvertToStr(AValue: TDateTime): string; overload; static;
    class function ConvertToStr(AValue: TdxPDFRenderingIntent): string; overload; static;
    class function ConvertToText(const AData: TBytes): string; static;
    class function ConvertToUnicode(const AData: TBytes): string; static;
    class function Split(const S, ADelimiter: string; ACount: Integer = -1): TStringDynArray; static;
    class function SplitFieldName(const AFullName: string): TStringDynArray; static;

    class function ConvertToASCIIString(const AData: TBytes): string; static;
    class function ConvertToBigEndianUnicode(const AData: TBytes; AByteIndex, ACharCount: Integer): string; overload; static;
    class function ConvertToBigEndianUnicode(const AData: TBytes): string; overload; static;
    class function ConvertToPageIndexes(APageCount: Integer): TIntegerDynArray; static;
    class function ConvertToUTF8String(const AData: TBytes): string; static;

    class function IsPageRangeValid(const APageIndexes: TIntegerDynArray; APageCount: Integer;
      AUsePageIndexes: Boolean = True): Boolean; static;

    class function UseWIC: Boolean; static;
    class procedure Abort; static;
    class procedure SaveToFile(const AFileName: string; const AData: TBytes); static;
    class procedure RaiseException(AMessage: string = ''; AExceptionClass: EdxPDFExceptionClass = nil); static;
    class procedure RaiseNotImplementedException; static;
    class procedure RaiseTestException(const AMessage: string = ''); static;
  end;

  { TdxPDFTask }

  TdxPDFTask = class(TdxTask)
  private
    FAction: TProc<Integer>;
    FIndex: Integer;
  protected
    constructor Create(AIndex: Integer; AAction: TProc<Integer>);
    procedure Execute; override;
  public
    class procedure ForEach(AStartIndex, ACount: Integer; AAction: TProc<Integer>); static;
  end;

implementation

uses
  SysConst, Character, dxStringHelper, cxDateUtils, dxPDFDocumentStrs, dxPDFViewerDialogsStrs, dxJPX, StrUtils,
  cxCustomCanvas;

const
  dxThisUnitName = 'dxPDFUtils';

const
  sdxPDFRenderingIntentAbsoluteColorimetric = 'AbsoluteColorimetric';
  sdxPDFRenderingIntentRelativeColorimetric = 'RelativeColorimetric';
  sdxPDFRenderingIntentSaturation = 'Saturation';
  sdxPDFRenderingIntentPerceptual = 'Perceptual';

{ TdxPDFUtils }

class procedure TdxPDFUtils.AddByte(B: Byte; var ADestinationData: TBytes);
var
  L: Integer;
begin
  L := Length(ADestinationData);
  SetLength(ADestinationData, L + 1);
  ADestinationData[L] := B;
end;

class procedure TdxPDFUtils.AddChar(AChar: Char; var ADestinationData: TCharArray);
var
  L: Integer;
begin
  L := Length(ADestinationData);
  SetLength(ADestinationData, L + 1);
  ADestinationData[L] := AChar;
end;

class procedure TdxPDFUtils.AddRange(const ARange: TdxPDFRange; var ARanges: TdxPDFRanges);
var
  L: Integer;
begin
  L := Length(ARanges);
  SetLength(ARanges, L + 1);
  ARanges[L] := ARange;
end;

class procedure TdxPDFUtils.AddData(const AData: TBytes; var ADestinationData: TBytes);
var
  ADestLength, ASrcLength: Integer;
begin
  ASrcLength := Length(AData);
  ADestLength := Length(ADestinationData);
  SetLength(ADestinationData, ASrcLength + ADestLength);
  cxCopyData(@AData[0], @ADestinationData[0], 0, ADestLength, ASrcLength * SizeOf(Byte));
end;

class procedure TdxPDFUtils.AddData(const AData: TDoubleDynArray; var ADestinationData: TDoubleDynArray);
var
  ADestLength, ASrcLength: Integer;
begin
  ASrcLength := Length(AData);
  ADestLength := Length(ADestinationData);
  SetLength(ADestinationData, ASrcLength + ADestLength);
  cxCopyData(@AData[0], @ADestinationData[0], 0, ADestLength, ASrcLength * SizeOf(Double));
end;

class procedure TdxPDFUtils.AddData(const AData: TdxPDFRanges; var ADestinationData: TdxPDFRanges);
var
  ADestLength, ASrcLength: Integer;
begin
  ASrcLength := Length(AData);
  ADestLength := Length(ADestinationData);
  SetLength(ADestinationData, ASrcLength + ADestLength);
  cxCopyData(@AData[0], @ADestinationData[0], 0, ADestLength, ASrcLength * SizeOf(TdxPDFRange));
end;

class procedure TdxPDFUtils.AddPoint(const P: TdxPointF; var APoints: TdxPointsF);
var
  L: Integer;
begin
  L := Length(APoints);
  SetLength(APoints, L + 1);
  APoints[L] := P;
end;

class procedure TdxPDFUtils.CopyData(const AData: TDoubleDynArray; AIndex: Integer;
  var ADestinationData: TDoubleDynArray; ADestinationIndex, ACount: Integer);
begin
  cxCopyData(@AData[0], @ADestinationData[0], AIndex, ADestinationIndex * SizeOf(Double), ACount * SizeOf(Double));
end;

class procedure TdxPDFUtils.AddValue(const AValue: Double; var AData: TDoubleDynArray);
var
  L: Integer;
begin
  L := Length(AData);
  SetLength(AData, L + 1);
  AData[L] := AValue;
end;

class procedure TdxPDFUtils.AddValue(const AValue: Integer; var AData: TIntegerDynArray);
var
  L: Integer;
begin
  L := Length(AData);
  SetLength(AData, L + 1);
  AData[L] := AValue;
end;

class procedure TdxPDFUtils.AddValue(const AValue: Single; var AData: TSingleDynArray);
var
  L: Integer;
begin
  L := Length(AData);
  SetLength(AData, L + 1);
  AData[L] := AValue;
end;

class procedure TdxPDFUtils.AddValue(const AValue: string; var AData: TStringDynArray);
var
  L: Integer;
begin
  L := Length(AData);
  SetLength(AData, L + 1);
  AData[L] := AValue;
end;

class procedure TdxPDFUtils.ClearData(var AData: TBytes);
begin
  FillChar(AData[0], Length(AData), 0);
end;

class procedure TdxPDFUtils.CopyData(const AData: TBytes; AIndex: Integer;
  var ADestinationData: TBytes; ADestinationIndex, ACount: Integer);
begin
  cxCopyData(@AData[0], @ADestinationData[0], AIndex, ADestinationIndex, ACount);
end;

class procedure TdxPDFUtils.CopyData(const AData: TIntegerDynArray; AIndex: Integer;
  var ADestinationData: TIntegerDynArray; ADestinationIndex, ACount: Integer);
begin
  cxCopyData(@AData[0], @ADestinationData[0], AIndex, ADestinationIndex * SizeOf(Integer), ACount * SizeOf(Integer));
end;

class procedure TdxPDFUtils.CopyData(const AData: TSmallIntDynArray; AIndex: Integer;
  var ADestinationData: TSmallIntDynArray; ADestinationIndex, ACount: Integer);
begin
  cxCopyData(@AData[0], @ADestinationData[0], AIndex, ADestinationIndex * SizeOf(SmallInt), ACount * SizeOf(SmallInt));
end;

class procedure TdxPDFUtils.DeleteData(AIndex, ACount: Integer; var ASourceData: TBytes);
var
  I, L: Integer;
begin
  L := Length(ASourceData);
  if (L > 0) and (ACount > 0) and (ACount <= L - AIndex) and (AIndex < L) then
    for I := AIndex + ACount to L - 1 do
      ASourceData[I - ACount] := ASourceData[I];
  SetLength(ASourceData, L - ACount);
end;

class procedure TdxPDFUtils.InsertFirst(const AValue: Double; var AData: TDoubleDynArray);
var
  L: Integer;
begin
  L := Length(AData);
  SetLength(AData, L + 1);
  TdxPDFUtils.CopyData(AData, 0, AData, 1, L);
  AData[0] := AValue;
end;

class function TdxPDFUtils.ArrayToDoubleArray(AArray: TdxPDFArray): TDoubleDynArray;
var
  I: Integer;
begin
  SetLength(Result, AArray.ElementList.Count);
  for I := 0 to AArray.ElementList.Count - 1 do
    Result[I] := ConvertToDouble(AArray.ElementList[I]);
end;

class function TdxPDFUtils.ArrayToRectangle(AArray: TdxPDFArray): TdxPDFRectangle;
begin
  Result := TdxPDFRectangle.Create(AArray);
end;

class function TdxPDFUtils.ArrayToRectF(AArray: TdxPDFArray): TdxRectF;
begin
  if (AArray <> nil) and (AArray.Count >= 4) then
  begin
    Result.Left := TdxPDFDouble(AArray[0]).Value;
    Result.Bottom := TdxPDFDouble(AArray[1]).Value;
    Result.Right := TdxPDFDouble(AArray[2]).Value;
    Result.Top := TdxPDFDouble(AArray[3]).Value;
  end
  else
    Result := dxNullRectF;
end;

class function TdxPDFUtils.ArrayToPointF(AArray: TdxPDFArray; AIndex: Integer): TdxPointF;
begin
  if AArray <> nil then
  begin
    Result.X := ConvertToDouble(AArray[AIndex]);
    Result.Y := ConvertToDouble(AArray[AIndex + 1]);
  end
  else
    Result := dxPointF(cxNullPoint);
end;

class function TdxPDFUtils.ArrayToPoints(AArray: TdxPDFArray): TdxPointsF;
var
  I, L, AIndex: Integer;
begin
  if (AArray <> nil) and (AArray.Count mod 2 = 0) then
  begin
    L := AArray.Count div 2;
    SetLength(Result, L);
    AIndex := 0;
    for I := 0 to L - 1 do
    begin
      Result[I] := ArrayToPointF(AArray, AIndex);
      Inc(AIndex, 2);
    end;
  end
  else
    Result := nil;
end;

class function TdxPDFUtils.ArrayToMatrix(AArray: TdxPDFArray): TdxPDFTransformationMatrix;
begin
  Result := TdxPDFTransformationMatrix.Create;
  if (AArray <> nil) and (AArray.Count > 5) then
  begin
    Result.Assign(
      ConvertToDouble(AArray[0]), ConvertToDouble(AArray[1]),
      ConvertToDouble(AArray[2]), ConvertToDouble(AArray[3]),
      ConvertToDouble(AArray[4]), ConvertToDouble(AArray[5]));
  end;
end;

class function TdxPDFUtils.Distance(const P1, P2: TdxPointF): Single;
begin
  Result := cxPointDistanceF(P1, P2);
end;

class function TdxPDFUtils.DistanceToRect(const P: TPoint; const R: TdxRectF): Single;
begin
  Result := DistanceToRect(dxPointF(P), R);
end;

class function TdxPDFUtils.DistanceToRect(const P: TdxPointF; const R: TdxRectF): Single;
var
  ALeft, ABottom, ARight, ATop: Double;
begin
  ALeft := R.Left;
  ABottom := R.Bottom;
  ARight := R.Right;
  ATop := R.Top;
  Result := Math.Min(
    Math.Min(DistanceToSegment(P, ALeft, ATop, ARight, ATop), DistanceToSegment(P, ARight, ATop, ARight, ABottom)),
    Math.Min(DistanceToSegment(P, ARight, ABottom, ALeft, ABottom), DistanceToSegment(P, ALeft, ABottom, ALeft, ATop)));
end;

class function TdxPDFUtils.DistanceToSegment(const APoint: TdxPointF; AStartX, AStartY, AEndX, AEndY: Single): Single;
var
  ADx, ADy, AC1, AC2, B: Double;
begin
  ADx := AEndX - AStartX;
  ADy := AEndY - AStartY;
  AC1 := ADx * (APoint.X - AStartX) + ADy * (APoint.Y - AStartY);
  if AC1 <= 0 then
    Exit(Distance(APoint, dxPointF(AStartX, AStartY)));
  AC2 := ADx * ADx + ADy * ADy;
  if AC2 <= AC1 then
    Exit(Distance(APoint, dxPointF(AEndX, AEndY)));
  B := AC1 / AC2;
  Result := Distance(APoint, dxPointF(AStartX + ADx * B, AStartY + ADy * B));
end;

class function TdxPDFUtils.GenerateGUID: string;
begin
  Result := dxGenerateGUID;
  Result := Copy(Result, 2, Length(Result) - 2);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := Copy(Result, 1, 31);
end;

class function TdxPDFUtils.IsRectEmpty(const R: TdxRectF): Boolean;
begin
  Result := R = cxRectF(cxNullRect);
end;

class function TdxPDFUtils.Max(const AValue1, AValue2: Double): Double;
begin
  Result := IfThen(AValue1 > AValue2, AValue1, AValue2);
end;

class function TdxPDFUtils.Lerp(const P1, P2: TdxPointF; const T: Double): TdxPointF;
begin
  Result := dxPointF(P1.X + (P2.X - P1.X) * T, P1.Y + (P2.Y - P1.Y) * T);
end;

class function TdxPDFUtils.LoadGlyph(const AResourceName, AResourceType: string): TdxSmartGlyph;
begin
  Result := TdxSmartGlyph.Create;
  Result.LoadFromResource(HInstance, AResourceName, PWideChar(AResourceType));
  Result.SourceDPI := 96;
end;

class function TdxPDFUtils.MatrixToArray(AMatrix: TdxPDFTransformationMatrix): TdxPDFArray;
begin
  Result := TdxPDFArray.Create;
  Result.Add(AMatrix.A);
  Result.Add(AMatrix.B);
  Result.Add(AMatrix.C);
  Result.Add(AMatrix.D);
  Result.Add(AMatrix.E);
  Result.Add(AMatrix.F);
end;

class function TdxPDFUtils.Min(const AValue1, AValue2: Double): Double;
begin
  Result := IfThen(AValue1 < AValue2, AValue1, AValue2);
end;

class function TdxPDFUtils.MinMax(AValue, AMinValue, AMaxValue: Integer): Integer;
begin
  if AMaxValue >= AMinValue then
    Result := Math.Min(AMaxValue, Math.Max(AValue, AMinValue))
  else
    Result := AMaxValue;
end;

class function TdxPDFUtils.NormalizeAngle(const AAngle: Double): Double;
var
  AResult: Double;
begin
  AResult := AAngle;
  while AResult < 0 do
		AResult := AResult + PI * 2;
  while AResult >= PI * 2 do
		AResult := AResult - PI * 2;
  Result := AResult;
end;

class function TdxPDFUtils.NormalizeRectF(const R: TdxRectF): TdxRectF;
begin
  Result.Left := R.Left;
  Result.Top :=  R.Bottom;
  Result.Right := R.Right;
  Result.Bottom := R.Top;
end;

class function TdxPDFUtils.NormalizeRotate(ARotate: Integer): Integer;
var
  AStep: Integer;
begin
  AStep := -360;
  if ARotate < 0 then
    AStep := 360;
  while (((ARotate < 0) and (AStep > 0))) or (((ARotate > 270) and (AStep < 0))) do
    Inc(ARotate, AStep);
  Result := ARotate;
end;

class function TdxPDFUtils.OrientedDistance(const AStart, AFinish: TdxPointF; AAngle: Single): Single;
begin
  Result := AFinish.X - AStart.X;
  if AAngle <> 0 then
    Result := Result * Cos(-AAngle) - (AFinish.Y - AStart.Y) * Sin(-AAngle);
end;

class function TdxPDFUtils.PointToArray(const APoint: TdxPointF): TdxPDFArray;
begin
  Result := TdxPDFArray.Create;
  Result.Add(APoint.X);
  Result.Add(APoint.Y);
end;

class function TdxPDFUtils.PointsToArray(const APoints: TdxPointsF): TdxPDFArray;
var
  I, L: Integer;
  P: TdxPointF;
begin
  L := Length(APoints);
  if L = 0 then
    Exit(nil);
  Result := TdxPDFArray.Create;
  for I := 0 to L - 1 do
  begin
    P := APoints[I];
    Result.Add(P.X);
    Result.Add(P.Y);
  end;
end;

class function TdxPDFUtils.ReadLine(AStream: TStream): string;
var
  ABuilder: TStringBuilder;
  ASymbol: Byte;
  AStreamSize: Int64;
begin
  ABuilder := TdxStringBuilderManager.Get;
  try
    AStreamSize := AStream.Size;
    while AStream.Position < AStreamSize do
    begin
      AStream.ReadBuffer(ASymbol, SizeOf(ASymbol));
      if ASymbol in [TdxPDFDefinedSymbols.LineFeed, TdxPDFDefinedSymbols.CarriageReturn] then
      begin
        Result := ABuilder.ToString;
        Break;
      end
      else
        ABuilder.Append(Char(ASymbol));
    end;
  finally
    TdxStringBuilderManager.Release(ABuilder);
  end;
end;

class function TdxPDFUtils.RectToArray(const ARect: TdxRectF; ACheckRect: Boolean = True): TdxPDFArray;
begin
  Result := TdxPDFArray.Create;
  Result.Add(ARect.Left);
  if ACheckRect then
    Result.Add(Min(ARect.Top, ARect.Bottom))
  else
    Result.Add(ARect.Bottom);
  Result.Add(ARect.Right);
  if ACheckRect then
    Result.Add(Max(ARect.Top, ARect.Bottom))
  else
    Result.Add(ARect.Top);
end;

class function TdxPDFUtils.RectContain(const ABounds, AInner: TdxRectF): Boolean;
begin
  with ABounds do
    Result := (Left <= AInner.Left) and (Right >= AInner.Right) and
      (Top <= AInner.Top) and (Bottom >= AInner.Bottom);
end;

class function TdxPDFUtils.RectIsEqual(const R1, R2: TdxRectF; ADelta: Single): Boolean;

  function CheckValue(A, B, ADelta: Single): Boolean;
  begin
    Result := Abs(A - B) <= ADelta;
  end;

begin
  Result := CheckValue(R1.Left, R2.Left, ADelta) and CheckValue(R1.Right, R2.Right, ADelta) and
    CheckValue(R1.Top, R2.Top, ADelta) and CheckValue(R1.Bottom, R2.Bottom, ADelta);
end;

class function TdxPDFUtils.RectRotate(const R: TdxRectF): TdxRectF;
begin
  Result := dxRectF(R.Top, R.Left, R.Bottom, R.Right);
end;

class function TdxPDFUtils.RotatePoint(APoint: TdxPointF; AAngle: Single): TdxPointF;
var
  ASin, ACos: Single;
begin
  if AAngle <> 0 then
  begin
    ASin := Sin(AAngle);
    ACos := Cos(AAngle);
    Result := dxPointF(APoint.X * ACos - APoint.Y * ASin, APoint.X * ASin + APoint.Y * ACos);
  end
  else
    Result := APoint;
end;

class function TdxPDFUtils.ToArray(AList: TStringList): TStringDynArray;
var
  I: Integer;
begin
  if AList = nil then
     Exit(nil);
  SetLength(Result, AList.Count);
  for I := 0 to AList.Count - 1 do
    Result[I] := AList[I];
end;

class function TdxPDFUtils.EndsWith(const S, AEndsWith: string): Boolean;
var
  L: Integer;
begin
  L := Length(AEndsWith);
  Result := (AEndsWith <> '') and (Length(S) >= L) and (Copy(S, Length(S) - L + 1, L) = AEndsWith);
end;

class function TdxPDFUtils.StartsWith(const S, AStartsWith: string): Boolean;
var
  L: Integer;
begin
  L := Length(AStartsWith);
  Result := (AStartsWith <> '') and (Length(S) >= L) and (Copy(S, 1, L) = AStartsWith);
end;

class function TdxPDFUtils.BytesToStr(const AData: TBytes): string;
var
  ABuffer: TStringBuilder;
  I: Integer;
begin
  ABuffer := TdxStringBuilderManager.Get(Length(AData));
  try
    for I := Low(AData) to High(AData) do
      ABuffer.Append(Char(AData[I]));
    Result := ABuffer.ToString;
  finally
    TdxStringBuilderManager.Release(ABuffer);
  end;
end;

class function TdxPDFUtils.ByteToHexDigit(AByte: Byte): Byte;
begin
  if (AByte >= TdxPDFDefinedSymbols.DigitStart) and (AByte <= TdxPDFDefinedSymbols.DigitEnd) then
    Exit(Byte((AByte - TdxPDFDefinedSymbols.DigitStart)));
  if (AByte >= TdxPDFDefinedSymbols.HexDigitStart) and (AByte <= TdxPDFDefinedSymbols.HexDigitEnd) then
    Exit(Byte((AByte - TdxPDFDefinedSymbols.HexDigitStart + 10)));
  if (AByte < TdxPDFDefinedSymbols.LowercaseHexDigitStart) or (AByte > TdxPDFDefinedSymbols.LowercaseHexDigitEnd) then
    TdxPDFUtils.Abort;
  Result := Byte((AByte - TdxPDFDefinedSymbols.LowercaseHexDigitStart + 10));
end;

class function TdxPDFUtils.FormatFileSize(AFileSize: Int64; AAuto: Boolean = True): string;

  function GetInBytes(const ATemplate: string): string;
  begin
    Result := FormatFloat(ATemplate, AFileSize) + ' ' + cxGetResourceString(@sdxPDFViewerBytes);
  end;

const
  FormatTemplate = '##0.##';
  KiloByte = 1024;
  MegaByte = KiloByte * KiloByte;
  GigaByte = KiloByte * MegaByte;
begin
  if AAuto then
  begin
    if AFileSize > GigaByte then
      Result := FormatFloat(FormatTemplate, AFileSize / GigaByte) + ' ' +
        cxGetResourceString(@sdxPDFViewerGigaBytes)
    else
      if AFileSize > MegaByte then
        Result := FormatFloat(FormatTemplate, AFileSize / MegaByte) + ' ' +
          cxGetResourceString(@sdxPDFViewerMegaBytes)
      else
        if AFileSize > KiloByte then
          Result := FormatFloat(FormatTemplate, AFileSize / KiloByte) + ' ' +
          cxGetResourceString(@sdxPDFViewerKiloBytes)
        else
          Result := GetInBytes(FormatTemplate)
  end
  else
    Result := GetInBytes('##0,###');
end;

class function TdxPDFUtils.IsDigit(AByte: Byte): Boolean;
begin
  Result := (AByte >= TdxPDFDefinedSymbols.DigitStart) and (AByte <= TdxPDFDefinedSymbols.DigitEnd);
end;

class function TdxPDFUtils.IsDoubleValid(const AValue: Double): Boolean;
begin
  Result := dxPDFIsDoubleValid(AValue);
end;

class function TdxPDFUtils.IsIntegerValid(AValue: Integer): Boolean;
begin
  Result := IsDoubleValid(AValue);
end;

class function TdxPDFUtils.IsHexDigit(AByte: Byte): Boolean;
begin
  Result := ((AByte >= TdxPDFDefinedSymbols.DigitStart) and (AByte <= TdxPDFDefinedSymbols.DigitEnd)) or
    ((AByte >= TdxPDFDefinedSymbols.HexDigitStart) and (AByte <= TdxPDFDefinedSymbols.HexDigitEnd)) or
    ((AByte >= TdxPDFDefinedSymbols.LowercaseHexDigitStart) and (AByte <= TdxPDFDefinedSymbols.LowercaseHexDigitEnd));
end;

class function TdxPDFUtils.IsPeriod(AByte: Byte): Boolean;
begin
  Result := (AByte in [TdxPDFDefinedSymbols.Period, Byte(',')]);
end;

class function TdxPDFUtils.IsReference(AObject: TdxPDFBase): Boolean;
begin
  Result := (AObject <> nil) and (AObject.ObjectType = otIndirectReference);
end;

class function TdxPDFUtils.IsSpace(AByte: Byte): Boolean;
begin
  Result := AByte = TdxPDFDefinedSymbols.Space;
end;

class function TdxPDFUtils.IsUnicode(const AData: TBytes): Boolean;
begin
  Result := (Length(AData) >= 2) and (AData[0] = 254) and (AData[1] = 255);
end;

class function TdxPDFUtils.IsUnicodeString(const AValue: string): Boolean;
var
  AChar: Char;
begin
  Result := False;
  for AChar in AValue do
  begin
    Result := Integer(AChar) >= 127;
    if Result then
      Exit;
  end;
end;

class function TdxPDFUtils.IsWhiteSpace(AByte: Byte): Boolean;
begin
  Result := IsSpace(AByte) or (AByte in [TdxPDFDefinedSymbols.CarriageReturn, TdxPDFDefinedSymbols.Null,
    TdxPDFDefinedSymbols.LineFeed, TdxPDFDefinedSymbols.FormFeed, TdxPDFDefinedSymbols.HorizontalTab]);
end;

class function TdxPDFUtils.StrToByteArray(const S: string): TBytes;
var
  I: Integer;
begin
  SetLength(Result, Length(S));
  for I := 1 to Length(S) do
    Result[I - 1] := Byte(S[I]);
end;

class function TdxPDFUtils.Contains(const R1, R2: TdxRectF): Boolean;
begin
  Result := (R1.Left <= R2.left) and (R1.Right >= R2.Right) and (R1.Bottom <= R2.Bottom) and (R1.Top >= R2.Top);
end;

class function TdxPDFUtils.Dot(const P1, P2: TdxPointF): Single;
begin
  Result := TdxVectors.ScalarProduct(P1, P2);
end;

class function TdxPDFUtils.Intersects(const R1, R2: TdxRectF): Boolean;
var
  R: TdxRectF;
begin
  Result := Intersects(R, R1, R2);
end;

class function TdxPDFUtils.Intersects(out AIntersection: TdxRectF; const R1, R2: TdxRectF): Boolean;
begin
  AIntersection.Left := Max(R2.Left, R1.Left);
  AIntersection.Top := Max(R2.Top, R1.Top);
  AIntersection.Right := Min(R2.Right, R1.Right);
  AIntersection.Bottom := Min(R2.Bottom, R1.Bottom);
  Result := not ((AIntersection.Right <= AIntersection.Left) or (AIntersection.Bottom <= AIntersection.Top));
end;

class function TdxPDFUtils.PtInRect(const R: TdxRectF; const P: TdxPointF): Boolean;
begin
  Result := (P.X >= R.Left) and (P.X < R.Right) and (P.Y >= R.Top) and (P.Y < R.Bottom);
end;

class function TdxPDFUtils.Subtract(const P1, P2: TdxPointF): TdxPointF;
begin
  Result := cxPointOffset(P1, P2);
end;

class function TdxPDFUtils.TrimRect(const R1, R2: TdxRectF): TdxRectF;
begin
  Result.Left := Max(R1.Left, R2.left);
  Result.Bottom := Max(R1.Bottom, R2.Bottom);
  Result.Right := Min(R1.Right, R2.Right);
  Result.Top := Min(R1.Top, R2.Top);
end;

class function TdxPDFUtils.ConvertToByte(const AValue: Double): Byte;
begin
  Result := dxDoubleToByte(AValue);
end;

class function TdxPDFUtils.ConvertToBoolean(AValue: TdxPDFReferencedObject; ADefaultValue: Boolean): Boolean;
begin
  Result := ADefaultValue;
  if (AValue is TdxPDFBase) and (AValue is TdxPDFBoolean) then
    Result := TdxPDFBoolean(AValue).Value;
end;

class function TdxPDFUtils.ConvertToDigit(AValue: Byte): Byte;
begin
  if InRange(AValue, TdxPDFDefinedSymbols.DigitStart, TdxPDFDefinedSymbols.DigitEnd) then
    Result := Byte(AValue - TdxPDFDefinedSymbols.DigitStart)
  else
    Result := 0;
end;

class function TdxPDFUtils.ConvertToDouble(AValue: TdxPDFBase): Double;
begin
  case AValue.ObjectType of
    otDouble:
      Result := TdxPDFDouble(AValue).Value;
    otInteger:
      Result := TdxPDFInteger(AValue).Value;
  else
    Result := dxPDFInvalidValue;
  end;
end;

class function TdxPDFUtils.ConvertToInt(AValue: TdxPDFBase): Integer;
begin
  case AValue.ObjectType of
    otDouble:
      Result := Trunc(TdxPDFDouble(AValue).Value);
    otInteger:
      Result := TdxPDFInteger(AValue).Value;
  else
    Result := dxPDFInvalidValue;
  end;
end;

class function TdxPDFUtils.ConvertToDouble(AValue: TdxPDFReferencedObject; ADefaultValue: Double): Double;
begin
  Result := ADefaultValue;
  if AValue is TdxPDFBase then
    Result := ConvertToDouble(TdxPDFBase(AValue));
end;

class function TdxPDFUtils.ConvertToInt(const AValue: Double): Integer;
begin
  Result := Round(AValue + 0.5);
end;

class function TdxPDFUtils.ConvertToInt(AValue: TdxPDFReferencedObject; ADefaultValue: Integer): Integer;
begin
  Result := ADefaultValue;
  if (AValue is TdxPDFBase) and (AValue is TdxPDFInteger) then
    Result := TdxPDFInteger(AValue).Value;
end;

class function TdxPDFUtils.ConvertToIntEx(AValue: TcxRotationAngle): Integer;
begin
  Result := cxRotationAngleToAngle[AValue];
end;

class function TdxPDFUtils.ConvertToGpMatrix(const AMatrix: TdxPDFTransformationMatrix): TdxGPMatrix;
begin
  Result := TdxGPMatrix.CreateEx(AMatrix.A, AMatrix.B, AMatrix.C, AMatrix.D, AMatrix.E, AMatrix.F);
end;

class function TdxPDFUtils.ConvertToGpPixelFormat(AFormat: TdxPDFPixelFormat): TdxGpPixelFormat;
const
  Map: array[TdxPDFPixelFormat] of TdxGpPixelFormat = (PixelFormat24bppRgb, PixelFormat1bppIndexed,
    PixelFormat8bppIndexed, PixelFormat24bppRgb, PixelFormat32bppArgb);
begin
  Result := Map[AFormat];
end;

class function TdxPDFUtils.ConvertToPageRanges(const APageIndexes: TIntegerDynArray): string;
var
  I, APageCount, AIndex, APrevIndex, ADifference: Integer;
  AStringBuilder: TStringBuilder;
begin
  APageCount := Length(APageIndexes);
  if APageCount > 0 then
  begin
    AStringBuilder := TdxStringBuilderManager.Get;
    try
      APrevIndex := APageIndexes[0];
      AStringBuilder.Append(APrevIndex);
      I := 1;
      while I < APageCount do
      begin
        AIndex := APageIndexes[I];
        ADifference := AIndex - APrevIndex;
        if Abs(ADifference) = 1 then
        begin
          APrevIndex := AIndex;
          Inc(I);
          while I < APageCount do
          begin
            AIndex := APageIndexes[I];
            if AIndex - APrevIndex <> ADifference then
              Break;
            APrevIndex := AIndex;
            Inc(I);
          end;
          AStringBuilder.Append('-');
          AStringBuilder.Append(APrevIndex);
          if I = APageCount then
            Break;
        end;
        AStringBuilder.Append(',');
        AStringBuilder.Append(AIndex);
        APrevIndex := AIndex;
        Inc(I);
      end;
      Result := AStringBuilder.ToString;
    finally
      TdxStringBuilderManager.Release(AStringBuilder);
    end;
  end;
end;

class function TdxPDFUtils.ConvertToRenderingIntent(const AValue: string): TdxPDFRenderingIntent;
begin
  if AValue = sdxPDFRenderingIntentRelativeColorimetric then
    Result := riRelativeColorimetric
  else

  if AValue = sdxPDFRenderingIntentSaturation then
    Result := riSaturation
  else

  if AValue = sdxPDFRenderingIntentPerceptual then
    Result := riPerceptual
  else
    Result := riAbsoluteColorimetric;
end;

class function TdxPDFUtils.ConvertToRotationAngle(AValue: Integer): TcxRotationAngle;
begin
  case AValue of
    270, -90:
      Result := raMinus90;
    90, -270:
      Result := raPlus90;
    180, -180:
      Result := ra180;
  else
    Result := ra0;
  end;
end;

class function TdxPDFUtils.ConvertToSingle(AValue: TdxPDFBase): Single;
begin
  if (AValue = nil) or (AValue.ObjectType = otNull) then
    Result := dxPDFInvalidValue
  else
    Result := ConvertToDouble(AValue);
end;

class function TdxPDFUtils.ConvertToStr(const AData: TBytes): string;
var
  AEncoding: TEncoding;
begin
  if IsUnicode(AData) then
    Result := ConvertToUnicode(AData)
  else
  begin
    AEncoding := TEncoding.GetEncoding(1252);
    try
      Result := AEncoding.GetString(AData);
    finally
      AEncoding.Free;
    end;
  end;
end;

class function TdxPDFUtils.ConvertToStr(const AData: TBytes; ALength: Integer): string;
begin
  try
    Result := TdxStringHelper.Substring(ConvertToBigEndianUnicode(AData, 0 , ALength), 1);
  except
    Result := '';
  end;
end;

class function TdxPDFUtils.ConvertToStr(AValue: TdxPDFReferencedObject): string;
begin
  Result := ConvertToStr(AValue as TdxPDFBase);
end;

class function TdxPDFUtils.ConvertToStr(AValue: TdxPDFBase): string;
begin
  if AValue is TdxPDFString then
    Result := TdxPDFString(AValue).Value
  else
    Result := '';
end;

class function TdxPDFUtils.ConvertToStr(AValue: TdxPDFVersion): string;
const
  Map: array[TdxPDFVersion] of string = ('1.0', '1.1', '1.2', '1.3', '1.4', '1.5', '1.6', '1.7');
begin
  Result := Map[AValue];
end;

class function TdxPDFUtils.ConvertToStr(AValue: TDateTime): string;

  function GetUTCOffset: Integer;
  begin
    if TdxTimeZoneHelper.IsDaylightDateTime(TdxTimeZoneHelper.CurrentTimeZone, AValue) then
      Result := (DefaultTimeZoneInfo.TZI.Bias + DefaultTimeZoneInfo.TZI.StandardBias +
        DefaultTimeZoneInfo.TZI.DaylightBias)
    else
      Result := DefaultTimeZoneInfo.TZI.Bias;
  end;

const
  SignMap: array[Boolean] of string = ('+', '-');
var
  APositive: Boolean;
  AIsUTC: Boolean;
  AUTCOffset: Integer;
begin
  AUTCOffset := GetUTCOffset;
  AIsUTC := AUTCOffset = 0;
  Result := 'D:' + FormatDateTime('YYYYMMDDHHmmSS', IfThen(AIsUTC, AValue, AValue - AUTCOffset / MinsPerDay)) +
    IfThen(AIsUTC, 'Z', '');
  if not AIsUTC then
  begin
    APositive := AUTCOffset > 0;
    if not APositive then
      AUTCOffset := -AUTCOffset;
    Result := Result + SignMap[APositive] +
      FormatFloat('00', (AUTCOffset div 60)) + #39 + FormatFloat('00', (AUTCOffset mod 60)) + #39;
  end;
end;

class function TdxPDFUtils.ConvertToStr(AValue: TdxPDFRenderingIntent): string;
const
  Map: array[TdxPDFRenderingIntent] of string = (
    sdxPDFRenderingIntentAbsoluteColorimetric,
    sdxPDFRenderingIntentRelativeColorimetric,
    sdxPDFRenderingIntentSaturation,
    sdxPDFRenderingIntentPerceptual
  );
begin
  Result := Map[AValue];
end;

class function TdxPDFUtils.ConvertToText(const AData: TBytes): string;

  function GetString(const AData: TBytes): string;
  const
    Map: array[0..255] of Char = (#$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009,
      #$000A, #$000B, #$000C, #$000D, #$000E, #$000F, #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0017, #$0017,
      #$02D8, #$02C7, #$02C6, #$02D9, #$02DD, #$02DB, #$02DA, #$02DC, #$0020, #$0021, #$0022, #$0023, #$0024, #$0025,
      #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F, #$0030, #$0031, #$0032, #$0033,
      #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F, #$0040, #$0041,
      #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D,
      #$005E, #$005F, #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B,
      #$006C, #$006D, #$006E, #$006F, #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079,
      #$007A, #$007B, #$007C, #$007D, #$007E, #$002D, #$2022, #$2020, #$2021, #$2026, #$2014, #$2013, #$0192, #$2044,
      #$2039, #$203A, #$2212, #$2030, #$201E, #$201C, #$201D, #$2018, #$2019, #$201A, #$2122, #$FB01, #$FB02, #$0141,
      #$0152, #$0160, #$0178, #$017D, #$0131, #$0142, #$0153, #$0161, #$017E, #$002D, #$20AC, #$00A1, #$00A2, #$00A3,
      #$00A4, #$00A5, #$00A6, #$00A7, #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$002D, #$00AE, #$00AF, #$00B0, #$00B1,
      #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF,
      #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD,
      #$00CE, #$00CF, #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7, #$00D8, #$00D9, #$00DA, #$00DB,
      #$00DC, #$00DD, #$00DE, #$00DF, #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7, #$00E8, #$00E9,
      #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF, #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00F7,
      #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00FF);
  var
    I: Integer;
    ABuilder: TStringBuilder;
  begin
    ABuilder := TdxStringBuilderManager.Get(Length(AData));
    try
      for I := 0 to Length(AData) - 1 do
        ABuilder.Append(Map[AData[I]]);
      Result := ABuilder.ToString;
    finally
      TdxStringBuilderManager.Release(ABuilder);
    end;
  end;

begin
  if IsUnicode(AData) then
    Result := ConvertToUnicode(AData)
  else
    Result := GetString(AData);
end;

class function TdxPDFUtils.ConvertToUnicode(const AData: TBytes): string;
begin
  Result := ConvertToStr(AData, Length(AData));
end;

class function TdxPDFUtils.Split(const S, ADelimiter: string; ACount: Integer = -1): TStringDynArray;
var
  AArray: TArray<string>;
  I, ALength: Integer;
  ADelimiters: array of string;
begin
  if Length(ADelimiter) > 1 then
  begin
    SetLength(ADelimiters, Length(ADelimiter));
    for I := 0 to Length(ADelimiter) - 1 do
      ADelimiters[I] := ADelimiter[I + 1];
    AArray := TdxStringHelper.Split(S, ADelimiters);
    ALength := IfThen(ACount = -1, Length(AArray), ACount);
    SetLength(Result, ALength);
    for I := 0 to ALength - 1 do
      Result[I] := AArray[I];
  end
  else
    Result := SplitString(S, ADelimiter);
end;

class function TdxPDFUtils.SplitFieldName(const AFullName: string): TStringDynArray;
begin
  Result := Split(AFullName, FieldNameDelimiter, 2);
end;

class function TdxPDFUtils.ConvertToASCIIString(const AData: TBytes): string;
begin
  if Length(AData) > 0 then
  try
    Result := TEncoding.ASCII.GetString(AData);
  except
    Result := '';
  end
  else
    Result := '';
end;

class function TdxPDFUtils.ConvertToBigEndianUnicode(const AData: TBytes; AByteIndex, ACharCount: Integer): string;
begin
  if Length(AData) > 0 then
  try
    Result := TEncoding.BigEndianUnicode.GetString(AData, AByteIndex, ACharCount);
  except
    Result := '';
  end
  else
    Result := '';
end;

class function TdxPDFUtils.ConvertToBigEndianUnicode(const AData: TBytes): string;
begin
  try
    Result := TEncoding.BigEndianUnicode.GetString(AData);
  except
    Result := '';
  end
end;

class function TdxPDFUtils.ConvertToPageIndexes(APageCount: Integer): TIntegerDynArray;
var
  I: Integer;
begin
  SetLength(Result, 0);
  for I := 0 to APageCount - 1 do
    TdxPDFUtils.AddValue(I, Result);
end;

class function TdxPDFUtils.ConvertToUTF8String(const AData: TBytes): string;
begin
  if Length(AData) > 0 then
  try
    Result := TEncoding.UTF8.GetString(AData);
  except
    Result := '';
  end
  else
    Result := '';
end;

class function TdxPDFUtils.IsPageRangeValid(const APageIndexes: TIntegerDynArray; APageCount: Integer;
  AUsePageIndexes: Boolean = True): Boolean;
var
  AStart, AEnd: Integer;
begin
  if Length(APageIndexes) = 0 then
    Exit(False);
  AStart := IfThen(AUsePageIndexes, 0, 1);
  AEnd := IfThen(AUsePageIndexes, APageCount - 1, APageCount);
  Result := (MinIntValue(APageIndexes) >= AStart) and (MaxIntValue(APageIndexes) <= AEnd);
end;

class function TdxPDFUtils.ConvertToAlphaColor(const AValue: TdxPDFColor; const AAlpha: Double): TdxAlphaColor;
var
  AColor: TdxPDFARGBColor;
  A, R, G, B: Byte;
begin
  AColor := TdxPDFARGBColor.Create(AValue);
  if AValue.IsNull then
    A := 255
  else
    A := Trunc(AAlpha * 255);
  R := ConvertToByte(AColor.Red * 255);
  G := ConvertToByte(AColor.Green * 255);
  B := ConvertToByte(AColor.Blue * 255);

  Result := TdxAlphaColors.FromArgb(A, R, G, B);
end;

class function TdxPDFUtils.ConvertToColor(const AValue: TdxPDFColor): TColor;
var
  AColor: TdxPDFARGBColor;
  ARGBQuad: TRGBQuad;
begin
  if AValue.IsNull then
    Exit(clNone);
  AColor := TdxPDFARGBColor.Create(AValue);
  ARGBQuad.rgbRed := ConvertToByte(AColor.Red * 255);
  ARGBQuad.rgbGreen := ConvertToByte(AColor.Green * 255);
  ARGBQuad.rgbBlue := ConvertToByte(AColor.Blue * 255);
  ARGBQuad.rgbReserved := 0;
  Result := dxRGBQuadToColor(ARGBQuad);
end;

class function TdxPDFUtils.ConvertToColor(const AValue: TColor): TdxPDFColor;
var
  AComponents: TDoubleDynArray;
  ARGBQuad: TRGBQuad;
begin
  if AValue = clNone then
    Exit(TdxPDFColor.Null);
  ARGBQuad := dxColorToRGBQuad(AValue);
  SetLength(AComponents, 3);
  AComponents[0] := ARGBQuad.rgbRed / 255;
  AComponents[1] := ARGBQuad.rgbGreen / 255;
  AComponents[2] := ARGBQuad.rgbBlue / 255;
  Result := TdxPDFColor.Create(AComponents);
end;

class procedure TdxPDFUtils.SaveToFile(const AFileName: string; const AData: TBytes);
var
  AFileStream: TFileStream;
begin
  if FileExists(AFileName) then
    DeleteFile(PWideChar(AFileName));
  AFileStream := TFileStream.Create(AFileName, fmCreate);
  try
    AFileStream.WriteBuffer(AData[0], Length(AData));
  finally
    AFileStream.Free;
  end;
end;

class function TdxPDFUtils.UseWIC: Boolean;
begin
  Result := IsWinVistaOrLater;
end;

class procedure TdxPDFUtils.Abort;
begin
  raise EdxPDFAbortException.Create('');
end;

class procedure TdxPDFUtils.RaiseException(AMessage: string = ''; AExceptionClass: EdxPDFExceptionClass = nil);
begin
  if AMessage = '' then
    AMessage := cxGetResourceString(@sdxPDFDocumentInvalidFormatMessage);
  if AExceptionClass = nil then
    AExceptionClass := EdxPDFException;
  raise AExceptionClass.Create(AMessage);
end;

class procedure TdxPDFUtils.RaiseNotImplementedException;
begin
  RaiseException('Not implemented');
end;

class procedure TdxPDFUtils.RaiseTestException(const AMessage: string = '');
begin
end;

{ TdxPDFTask }

class procedure TdxPDFTask.ForEach(AStartIndex, ACount: Integer; AAction: TProc<Integer>);
var
  I: Integer;
  ATaskGroup: TdxTaskGroup;
begin
  ATaskGroup := TdxTaskGroup.Create;
  try
    for I := AStartIndex to ACount - 1 do
      ATaskGroup.AddTask(TdxPDFTask.Create(I,
        procedure(AIndex: Integer)
        begin
          AAction(AIndex);
        end));
    ATaskGroup.RunAndWait;
  finally
    ATaskGroup.Free;
  end;
end;

constructor TdxPDFTask.Create(AIndex: Integer; AAction: TProc<Integer>);
begin
  inherited Create;
  FIndex := AIndex;
  FAction := AAction;
end;

procedure TdxPDFTask.Execute;
begin
  if Assigned(FAction) then
    FAction(FIndex);
end;

end.

