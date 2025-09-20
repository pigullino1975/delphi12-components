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

unit dxSVGCoreParsers;

{$I cxVer.inc}

interface

uses
  Types, TypInfo, Windows, Classes, Rtti, Generics.Collections, Generics.Defaults, Contnrs, Graphics,
  cxGeometry, dxCoreClasses, dxGDIPlusClasses, dxXMLDoc, dxSVGCore, dxSmartImage, SysUtils;

type
  TdxSVGParserPathCommand = class;

  { TdxSVGInlineStyles }

  TdxSVGInlineStyles = class
  public const
    KeySeparator = ':';
    PairSeparator = ';';
  public
    class procedure Parse(AStyle: TdxSVGStyle; const S: string);
  end;

  { TdxSVGFontFamilyString }

  TdxSVGFontFamilyString = class
  public const
    Separator = ',';
  protected
    class function Strip(const S: string): string; static;
  public
    class function Decode(const S: string): string;
    class function Encode(const S: string): string;
    class function Include(const ACurrentValues, AValueToInclude: string): string;
  end;

  { TdxSVGFontStyleString }

  TdxSVGFontStyleString = class
  public const
    NameMap: array[TFontStyle] of string = ('bold', 'italic', 'underline', 'line-through');
  public
    class function Build(const AName: string; ASize: Single; AStyles: TFontStyles): string;
    class function Parse(const S: string; out AName: string; out ASize: Single; out AStyles: TFontStyles): Boolean;
    class function TryStringToFontStyle(const S: string; out AStyle: TFontStyle): Boolean;
    class function GetFontStyles(const S: string): TFontStyles;
  end;

  { TdxSVGParserNumbers }

  TdxSVGParserNumbers = class
  public type
    TEnumNumbers = reference to procedure (const V: Single);
    TEnumPoints = reference to procedure (const P: TdxPointF);
  public
    class function AsNumbers(const S: string; const AMaxOfNumber: Double = 100): TdxSVGSingleValues; overload;
    class procedure AsNumbers(const S: string; AProc: TEnumNumbers); overload;
    class procedure AsPoints(const S: string; AList: TdxSVGPoints); overload;
    class procedure AsPoints(const S: string; AProc: TEnumPoints); overload;
    class procedure AsPoints(const V: TdxSVGSingleValues; AProc: TEnumPoints); overload;
  end;

  { TdxSVGParserImage }

  TdxSVGParserImage = class
  strict private const
    DataDelimiter = ',';
    DataPrefix = 'data:';
    EncodingBase64 = 'base64';
    MimeTypeDelimiter = ';';
  public
    class function ImageToString(ASource: TdxSmartImage): string;
    class procedure StringToImage(ATarget: TdxSmartImage; const AData: string);
  end;

  { TdxSVGParserRect }

  TdxSVGParserRect = class
  public
    class function Parse(const S: string): TdxRectF;
  end;

  { TdxSVGParserValue }

  TdxSVGParserValue = class
  public const
    NameMap: array[TdxSVGUnitsType] of string = ('px', 'mm', 'cm', 'in', 'pc', 'pt', '%');
  strict private
    class function StringToUnitsType(const S: string): TdxSVGUnitsType;
  public
    class function Parse(S: string; out AValue: TdxSVGValue): Boolean; overload;
    class function Parse(S: string; out AValues: TdxSVGValues): Boolean; overload;
  end;

  { TdxSVGShapeRenderingString }

  TdxSVGShapeRenderingString = class
  public const
    NameMap: array[TdxSVGShapeRendering] of string = ('auto', 'optimizeSpeed', 'crispEdges', 'geometricPrecision');
  public
    class function Parse(const S: string): TdxSVGShapeRendering;
  end;

  { TdxSVGBuilderPath }

  TdxSVGBuilderPath = class
  strict private
    FBuffer: TStringBuilder;

    procedure Append(const S: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddArc(const ARadiusX, ARadiusY, ASweepAngle, AEndX, AEndY: Single);
    procedure AddCloseFigure;
    procedure AddLineTo(const P: TdxPointF); overload;
    procedure AddLineTo(const X, Y: Single); overload;
    procedure AddMoveTo(const P: TdxPointF); overload;
    procedure AddMoveTo(const X, Y: Single); overload;
    procedure AddNumber(const AValue: Integer); overload;
    procedure AddNumber(const AValue: Single); overload;
    function ToString: string; override;
  end;

{$REGION 'TdxSVGParserPath'}

  { TdxSVGParserPath }

  TdxSVGParserPath = class
  public type
    TCommandProc = procedure (const AData: string; AIsRelative: Boolean) of object;
  strict private
    FBufferPoints: TdxSVGPoints;

    function GetCommand(Index: Integer): TdxSVGParserPathCommand;
    function GetCommandCount: Integer;
    function GetLastPoint: TdxPointF;

    // Commands Handlers
    procedure ProcessCommand(const ACommand: string);
    procedure ProcessCommandArc(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandClose(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandCurveTo(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandCurveToSmooth(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandHorzLine(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandLineTo(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandMoveTo(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandOpen(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandQuadraticCurveTo(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandQuadraticCurveToSmooth(const AData: string; AIsRelative: Boolean);
    procedure ProcessCommandVertLine(const AData: string; AIsRelative: Boolean);
  strict protected
    FCommandProcs: TDictionary<Char, TCommandProc>;
    FCommands: TObjectList;

    function GetAbsolutePoint(const P: TdxPointF; AIsRelative: Boolean): TdxPointF; overload;
    function GetAbsolutePoint(const X, Y: Single; AIsRelativeX, AIsRelativeY: Boolean): TdxPointF; overload;
    function GetPoints(const AData: string): TdxSVGPoints;
    function MirrorPoint(const P, AMirror: TdxPointF): TdxPointF;

    procedure RegisterCommands; virtual;
    //
    property LastPoint: TdxPointF read GetLastPoint;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(const S: string);
    //
    property Commands[Index: Integer]: TdxSVGParserPathCommand read GetCommand; default;
    property CommandCount: Integer read GetCommandCount;
  end;

  { TdxSVGParserPathCommand }

  TdxSVGParserPathCommand = class
  protected
    FinishPoint: TdxPointF;
  public
    constructor Create(const AFinishPoint: TdxPointF);
    procedure Append(APath: TdxGPPath); virtual;
  end;

  { TdxSVGParserPathCommandArc }

  TdxSVGParserPathCommandArc = class(TdxSVGParserPathCommand)
  strict private
    procedure CalculateVectors(ARotateMatrix: TdxGPMatrix; out AVector1, AVector2, ACenterPoint, ARadius: TdxPointF);
  protected
    Angle: Single;
    LargeArc: Boolean;
    Radius: TdxPointF;
    StartPoint: TdxPointF;
    Sweep: Boolean;

    procedure AppendCore(APath: TdxGPPath; ARotateMatrix: TdxGPMatrix;
      ARadius, AStartPoint, AOffset: TdxPointF; AStartAngle, AAngleDelta: Double);
  public
    constructor Create(const AStartPoint, AFinishPoint, ARadius: TdxPointF; AAngle: Single; ASweep, ALargeArc: Boolean);
    procedure Append(APath: TdxGPPath); override;
  end;

  { TdxSVGParserPathCommandOpen }

  TdxSVGParserPathCommandOpen = class(TdxSVGParserPathCommand)
  public
    procedure Append(APath: TdxGPPath); override;
  end;

  { TdxSVGParserPathCommandClose }

  TdxSVGParserPathCommandClose = class(TdxSVGParserPathCommand)
  public
    procedure Append(APath: TdxGPPath); override;
  end;

  { TdxSVGParserPathCommandCurveTo }

  TdxSVGParserPathCommandCurveTo = class(TdxSVGParserPathCommand)
  protected
    StartPoint: TdxPointF;
    Point1: TdxPointF;
    Point2: TdxPointF;
  public
    constructor Create(const AStartPoint, APoint1, APoint2, AFinishPoint: TdxPointF);
    procedure Append(APath: TdxGPPath); override;
  end;

  { TdxSVGParserPathCommandMoveTo }

  TdxSVGParserPathCommandMoveTo = class(TdxSVGParserPathCommand);

  { TdxSVGParserPathCommandLine }

  TdxSVGParserPathCommandLine = class(TdxSVGParserPathCommand)
  protected
    StartPoint: TdxPointF;
  public
    constructor Create(const AStartPoint, AFinishPoint: TdxPointF);
    procedure Append(APath: TdxGPPath); override;
  end;

  { TdxSVGParserPathCommandQuadraticCurveTo }

  TdxSVGParserPathCommandQuadraticCurveTo = class(TdxSVGParserPathCommand)
  protected
    MiddlePoint: TdxPointF;
    StartPoint: TdxPointF;
  public
    constructor Create(const AStartPoint, AMiddlePoint, AFinishPoint: TdxPointF);
    procedure Append(APath: TdxGPPath); override;
  end;

{$ENDREGION}

  { TdxSVGParserTransform }

  TdxSVGParserTransform = class
  strict private type
    TOperatorProc = function (AValues: TdxSVGSingleValues): TXForm of object;
  strict private
    class var FOperatorsMap: TDictionary<string, TOperatorProc>;

    class function GetValue(AValues: TdxSVGSingleValues; AIndex: Integer; ADefaultValue: Single = 0): Single;
    // built-in operators
    class function OperatorMatrix(AValues: TdxSVGSingleValues): TXForm;
    class function OperatorRotate(AValues: TdxSVGSingleValues): TXForm;
    class function OperatorScale(AValues: TdxSVGSingleValues): TXForm;
    class function OperatorSkewX(AValues: TdxSVGSingleValues): TXForm;
    class function OperatorSkewY(AValues: TdxSVGSingleValues): TXForm;
    class function OperatorTranslate(AValues: TdxSVGSingleValues): TXForm;
  protected
    class function Split(const S: string): TStringList;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Parse(const S: string; AMatrix: TdxMatrix);
  end;

implementation

uses
  dxCore, StrUtils, Math, Character, dxDPIAwareUtils, dxStringHelper, dxBase64;

const
  dxThisUnitName = 'dxSVGCoreParsers';

{ TdxSVGInlineStyles }

class procedure TdxSVGInlineStyles.Parse(AStyle: TdxSVGStyle; const S: string);
var
  ADelimPos: Integer;
  AParts: TStringDynArray;
  I: Integer;
begin
  AParts := SplitString(S, PairSeparator);
  for I := 0 to Length(AParts) - 1 do
  begin
    ADelimPos := Pos(KeySeparator, AParts[I]);
    if ADelimPos > 0 then
    begin
      AStyle.Attributes.SetValue(
        dxStringToXMLString(Trim(Copy(AParts[I], 1, ADelimPos - 1))),
        dxStringToXMLString(Trim(Copy(AParts[I], ADelimPos + 1, MaxInt))));
    end;
  end;
end;

{ TdxSVGFontFamilyString }

class function TdxSVGFontFamilyString.Decode(const S: string): string;
var
  ABuffer: TStringBuilder;
  APart: string;
  AParts: TStringDynArray;
  I: Integer;
begin
  AParts := SplitString(S, Separator);
  for I := Low(AParts) to High(AParts) do
    AParts[I] := Strip(AParts[I]);

  ABuffer := TdxStringBuilderManager.Get(Length(S));
  try
    for I := Low(AParts) to High(AParts) do
    begin
      APart := AParts[I];
      if APart <> '' then
      begin
        if ABuffer.Length > 0 then
          ABuffer.Append(Separator);
        ABuffer.Append(APart);
      end;
    end;
    Result := ABuffer.ToString;
  finally
    TdxStringBuilderManager.Release(ABuffer);
  end;
end;

class function TdxSVGFontFamilyString.Encode(const S: string): string;
begin
  if Pos(' ', S) > 0 then
    Result := '"' + S + '"'
  else
    Result := S;
end;

class function TdxSVGFontFamilyString.Include(const ACurrentValues, AValueToInclude: string): string;
begin
  if AValueToInclude = '' then
    Result := ACurrentValues
  else
    if ACurrentValues <> '' then
      Result := ACurrentValues + Separator + AValueToInclude
    else
      Result := AValueToInclude;
end;

class function TdxSVGFontFamilyString.Strip(const S: string): string;
var
  I, J: Integer;
begin
  Result := Trim(S);
  J := Length(Result);
  if J = 0 then
    Exit('');
  I := 1;
  if dxCharInSet(Result[I], ['''', '"']) then
    Inc(I);
  if dxCharInSet(Result[J], ['''', '"']) then
    Dec(J);
  Result := Trim(Copy(Result, I, J - I + 1));
end;

{ TdxSVGFontStyleString }

class function TdxSVGFontStyleString.Build(const AName: string; ASize: Single; AStyles: TFontStyles): string;
var
  AResult: TStringBuilder;
begin
  AResult := TdxStringBuilderManager.Get(64);
  try
    if fsItalic in AStyles then
      AResult.Append(NameMap[fsItalic]).Append(' ');
    if fsBold in AStyles then
      AResult.Append(NameMap[fsBold]).Append(' ');
    AResult.Append(dxFloatToStr(ASize)).Append(TdxSVGParserValue.NameMap[utPx]).Append(' ');
    AResult.Append(TdxSVGFontFamilyString.Encode(AName));
    Result := AResult.ToString;
  finally
    TdxStringBuilderManager.Release(AResult);
  end;
end;

class function TdxSVGFontStyleString.GetFontStyles(const S: string): TFontStyles;
var
  AIndex: TFontStyle;
begin
  Result := [];
  for AIndex := Low(AIndex) to High(AIndex) do
    if Pos(NameMap[AIndex], S) > 0 then
      Result := Result + [AIndex];
end;

class function TdxSVGFontStyleString.Parse(const S: string;
  out AName: string; out ASize: Single; out AStyles: TFontStyles): Boolean;
var
  I, AStartIndex, ALength, APartLength: Integer;

  procedure ParsePart;
  var
    AFontStyle: TFontStyle;
    APart: string;
    AValue: TdxSVGValue;
  begin
    if APartLength = 0 then
      Exit;
    APart := TdxSVGFontFamilyString.Strip(Copy(S, AStartIndex, APartLength));
    Inc(AStartIndex, APartLength);
    APartLength := 0;
    if APart = '' then
      Exit;
    if TryStringToFontStyle(APart, AFontStyle) then
      Include(AStyles, AFontStyle)
    else
      if TdxSVGParserValue.Parse(APart, AValue) then
      begin
        if ASize = 0 then
          ASize := AValue.ToPixels(8, 96);
      end
      else
        AName := TdxSVGFontFamilyString.Include(AName, APart);
  end;

begin
  AName := '';
  AStyles := [];
  ASize := 0;

  AStartIndex := 1;
  APartLength := 0;
  ALength := Length(S);
  I := 1;
  while I <= ALength do
  begin
    case S[I] of
      '"':
        begin
          ParsePart;
          AStartIndex := I;
          APartLength := 1;
          Inc(I);
          while I <= ALength do
          begin
            Inc(APartLength);
            if S[I] = '"' then
            begin
              ParsePart;
              Inc(I);
              Break;
            end;
            Inc(I);
          end;
        end;
      ' ', '/', ',':
        begin
          ParsePart;
          Inc(I);
          AStartIndex := I;
        end;
    else
      Inc(APartLength);
      Inc(I);
    end;
  end;
  ParsePart;
  Result := (AName <> '') and (ASize > 0);
end;

class function TdxSVGFontStyleString.TryStringToFontStyle(const S: string; out AStyle: TFontStyle): Boolean;
var
  AIndex: TFontStyle;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
    if NameMap[AIndex] = S then
    begin
      AStyle := AIndex;
      Exit(True);
    end;
  Result := False;
end;

{ TdxSVGParserNumbers }

class function TdxSVGParserNumbers.AsNumbers(const S: string; const AMaxOfNumber: Double = 100): TdxSVGSingleValues;

  function CanProcess(AIndex: Integer; var ASeparatorCount: Integer): Boolean;
  begin
    Result := False;
    case S[AIndex] of
      '+', '-':
        Result := (AIndex > 0) and dxCharInSet(S[AIndex - 1], ['e', 'E']);
      '0'..'9', 'e', 'E':
        Result := True;
      '.':
        begin
          Inc(ASeparatorCount);
          Result := ASeparatorCount = 1;
        end;
    end;
  end;

  procedure TryAddValue(ATarget: TdxSVGSingleValues; AStartIndex, AIndex, ALength: Integer);
  var
    AString: UnicodeString;
    AValue: Double;
  begin
    if AIndex > AStartIndex then
    begin
      AString := Trim(Copy(S, AStartIndex, AIndex - AStartIndex));
      if TryStrToFloat(AString, AValue, dxInvariantFormatSettings) then
      begin
        if (AIndex <= ALength) and (S[AIndex] = '%') then
          AValue := AMaxOfNumber * AValue / 100;
      {$IFDEF CPUX64} // Bug in VCL - http://qc.embarcadero.com/wc/qcmain.aspx?d=110729
        if not StartsText('e', AString) then
      {$ENDIF}
          ATarget.Add(AValue);
      end;
    end;
  end;

var
  AIndex: Integer;
  ALength: Integer;
  ASeparatorCount: Integer;
  AStartIndex: Integer;
begin
  ALength := Length(S);
  Result := TdxSVGSingleValues.Create;
  Result.Capacity := ALength div 4;

  AIndex := 1;
  AStartIndex := 1;
  ASeparatorCount := 0;
  while AIndex <= ALength do
  begin
    if not CanProcess(AIndex, ASeparatorCount) then
    begin
      TryAddValue(Result, AStartIndex, AIndex, ALength);
      ASeparatorCount := Ord(S[AIndex] = '.');
      if dxCharInSet(S[AIndex], ['+', '-', '.']) then
        AStartIndex := AIndex
      else
        AStartIndex := AIndex + 1;
    end;
    Inc(AIndex);
  end;
  TryAddValue(Result, AStartIndex, AIndex, ALength);
end;

class procedure TdxSVGParserNumbers.AsNumbers(const S: string; AProc: TEnumNumbers);
var
  AValues: TdxSVGSingleValues;
  I: Integer;
begin
  AValues := AsNumbers(S);
  try
    for I := 0 to AValues.Count - 1 do
      AProc(AValues[I]);
  finally
    AValues.Free;
  end;
end;

class procedure TdxSVGParserNumbers.AsPoints(const S: string; AList: TdxSVGPoints);
var
  AValues: TdxSVGSingleValues;
begin
  AValues := AsNumbers(S);
  try
    AList.Count := 0;
    AList.Capacity := Max(AList.Capacity, AValues.Count div 2);
    AsPoints(AValues,
      procedure (const P: TdxPointF)
      begin
        AList.Add(P);
      end);
  finally
    AValues.Free;
  end;
end;

class procedure TdxSVGParserNumbers.AsPoints(const S: string; AProc: TEnumPoints);
var
  AValues: TdxSVGSingleValues;
begin
  AValues := AsNumbers(S);
  try
    AsPoints(AValues, AProc);
  finally
    AValues.Free;
  end;
end;

class procedure TdxSVGParserNumbers.AsPoints(const V: TdxSVGSingleValues; AProc: TEnumPoints);
var
  AIndex: Integer;
begin
  AIndex := 0;
  while AIndex + 1 < V.Count do
  try
    AProc(dxPointF(V[AIndex], V[AIndex + 1]));
    Inc(AIndex, 2);
  except
    Break;
  end;
end;

{ TdxSVGParserImage }

class function TdxSVGParserImage.ImageToString(ASource: TdxSmartImage): string;
var
  AImageCodec: TdxSmartImageCodecClass;
  AStream: TBytesStream;
begin
  AImageCodec := ASource.ImageCodec;
  if (AImageCodec = nil) or (AImageCodec.MimeType = '') or AImageCodec.InheritsFrom(TdxGPImageCodecBMP) then
    AImageCodec := TdxGPImageCodecPNG;

  AStream := TBytesStream.Create;
  try
    ASource.SaveToStreamByCodec(AStream, AImageCodec);
    Result := DataPrefix + AImageCodec.MimeType + MimeTypeDelimiter + EncodingBase64 + DataDelimiter +
      TdxBase64.ToBase64String(AStream.Bytes, 0, AStream.Size);
  finally
    AStream.Free;
  end;
end;

class procedure TdxSVGParserImage.StringToImage(ATarget: TdxSmartImage; const AData: string);
var
  ADataFinish: Integer;
  ADelimPos1: Integer;
  ADelimPos2: Integer;
  AEncoding: string;
  AStream: TdxMemoryStream;
begin
  ATarget.Clear;
  if StartsStr(DataPrefix, AData) then
  begin
    ADelimPos1 := PosEx(MimeTypeDelimiter, AData);
    if ADelimPos1 = 0 then Exit;
    ADelimPos2 := PosEx(DataDelimiter, AData, ADelimPos1);
    if ADelimPos2 = 0 then Exit;

    AEncoding := Copy(AData, ADelimPos1 + 1, ADelimPos2 - ADelimPos1 - 1);
    if dxSameText(AEncoding, EncodingBase64) then
    begin
      ADataFinish := Length(AData);
      while (ADataFinish > ADelimPos2) and (Ord(AData[ADataFinish]) <= Ord(' ')) do
        Dec(ADataFinish);
      if ADataFinish > ADelimPos2 then
      begin
        AStream := TdxMemoryStream.Create;
        try
          AStream.Size := Length(AData);
          AStream.Size := TdxBase64.DecodeArray(@AData[ADelimPos2 + 1], ADataFinish - ADelimPos2, AStream.Memory, AStream.Size);
          ATarget.LoadFromStream(AStream);
        finally
          AStream.Free;
        end;
      end;
    end;
  end;
end;

{ TdxSVGParserRect }

class function TdxSVGParserRect.Parse(const S: string): TdxRectF;
var
  AValues: TdxSVGSingleValues;
begin
  AValues := TdxSVGParserNumbers.AsNumbers(Trim(StringReplace(S, 'new', '', [])));
  try
    if AValues.Count = 4 then
      Result := cxRectFBounds(AValues[0], AValues[1], AValues[2], AValues[3])
    else
      Result := dxNullRectF;
  finally
    AValues.Free;
  end;
end;

{ TdxSVGShapeRenderingString }

class function TdxSVGShapeRenderingString.Parse(const S: string): TdxSVGShapeRendering;
var
  AIndex: TdxSVGShapeRendering;
begin
  Result := srAuto;
  for AIndex := Low(AIndex) to High(AIndex) do
    if NameMap[AIndex] = S then
      Exit(AIndex);
end;

{ TdxSVGParserValue }

class function TdxSVGParserValue.Parse(S: string; out AValue: TdxSVGValue): Boolean;
var
  AUnitsType: TdxSVGUnitsType;
  L: Integer;
begin
  Result := False;

  S := Trim(S);
  L := Length(S);
  if L > 0 then
  try
    while (L > 0) and not dxCharIsNumeric(S[L]) do
      Dec(L);
    if L = 0 then
      Exit(False);
    if L <> Length(S) then
    begin
      AUnitsType := StringToUnitsType(Trim(Copy(S, L + 1, MaxInt)));
      S := Trim(Copy(S, 1, L));
    end
    else
      AUnitsType := utPx;

    AValue := TdxSVGValue.Create(dxStrToFloat(S), AUnitsType);
    Result := True;
  except
    Result := False;
  end;
end;

class function TdxSVGParserValue.Parse(S: string; out AValues: TdxSVGValues): Boolean;
var
  AValue: TdxSVGValue;
  L: Integer;
begin
  Result := False;
  AValues := TdxSVGValues.Create;

  S := Trim(S);
  L := Length(S);
  if L > 0 then
  try
    while L > 0 do
    begin
      if (L = 1) or (not dxCharIsNumeric(S[L]) and (S[L] <> '.')) then
        if Parse(Copy(S, L + IfThen(L = 1, 0, 1), MaxInt), AValue) then
        begin
          AValues.Insert(0, AValue);
          if L > 1 then
          begin
            Delete(S, L + 1, MaxInt);
            while (S[L] = ' ') or (S[L] = ',') do
            begin
              Delete(S, L, 1);
              Dec(L);
            end;
            Continue;
          end;
        end;
      Dec(L);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

class function TdxSVGParserValue.StringToUnitsType(const S: string): TdxSVGUnitsType;
var
  AIndex: TdxSVGUnitsType;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if SameText(NameMap[AIndex], S) then
      Exit(AIndex);
  end;
  raise EdxException.CreateFmt('Unknown Units Type (%s)', [S]);
end;

{ TdxSVGBuilderPath }

constructor TdxSVGBuilderPath.Create;
begin
  FBuffer := TStringBuilder.Create;
end;

destructor TdxSVGBuilderPath.Destroy;
begin
  FreeAndNil(FBuffer);
  inherited;
end;

procedure TdxSVGBuilderPath.AddArc(const ARadiusX, ARadiusY, ASweepAngle, AEndX, AEndY: Single);
begin
  Append('A');
  AddNumber(ARadiusX);
  AddNumber(ARadiusY);
  AddNumber(0);
  AddNumber(Ord(Abs(ASweepAngle) > 180));
  AddNumber(Ord(ASweepAngle < 0));
  AddNumber(AEndX);
  AddNumber(AEndY);
end;

procedure TdxSVGBuilderPath.AddLineTo(const P: TdxPointF);
begin
  AddLineTo(P.X, P.Y);
end;

procedure TdxSVGBuilderPath.AddCloseFigure;
begin
  Append('z');
end;

procedure TdxSVGBuilderPath.AddLineTo(const X, Y: Single);
begin
  Append('L');
  AddNumber(X);
  AddNumber(Y);
end;

procedure TdxSVGBuilderPath.AddMoveTo(const X, Y: Single);
begin
  Append('M');
  AddNumber(X);
  AddNumber(Y);
end;

procedure TdxSVGBuilderPath.AddMoveTo(const P: TdxPointF);
begin
  AddMoveTo(P.X, P.Y);
end;

procedure TdxSVGBuilderPath.AddNumber(const AValue: Single);
begin
  Append(FormatFloat('0.00', AValue, dxInvariantFormatSettings));
end;

procedure TdxSVGBuilderPath.AddNumber(const AValue: Integer);
begin
  Append(IntToStr(AValue));
end;

function TdxSVGBuilderPath.ToString: string;
begin
  Result := FBuffer.ToString;
end;

procedure TdxSVGBuilderPath.Append(const S: string);
begin
  FBuffer.Append(S).Append(' ');
end;

{ TdxSVGParserPath }

constructor TdxSVGParserPath.Create;
begin
  FCommands := TObjectList.Create;
  FCommandProcs := TDictionary<Char, TCommandProc>.Create;
  RegisterCommands;
end;

destructor TdxSVGParserPath.Destroy;
begin
  FreeAndNil(FBufferPoints);
  FreeAndNil(FCommands);
  FreeAndNil(FCommandProcs);
  inherited Destroy;
end;

procedure TdxSVGParserPath.Parse(const S: string);
var
  ACommand: string;
  AIndex: Integer;
  ALength: Integer;
  AStart: Integer;
begin
  AStart := 1;
  ALength := Length(S);
  for AIndex := 1 to ALength do
  begin
    if dxWideIsAlpha(S[AIndex]) and (S[AIndex] <> 'e') then
    begin
      ACommand := Trim(Copy(S, AStart, AIndex - AStart));
      if ACommand <> '' then
        ProcessCommand(ACommand);
      AStart := AIndex;
    end;
  end;

  ACommand := Trim(Copy(S, AStart, ALength - AStart + 1));
  if ACommand <> '' then
    ProcessCommand(ACommand)
end;

function TdxSVGParserPath.GetAbsolutePoint(const P: TdxPointF; AIsRelative: Boolean): TdxPointF;
begin
  if AIsRelative then
    Result := cxPointOffset(P, LastPoint)
  else
    Result := P;
end;

function TdxSVGParserPath.GetAbsolutePoint(const X, Y: Single; AIsRelativeX, AIsRelativeY: Boolean): TdxPointF;
begin
  Result := cxPointF(X, Y);
  if AIsRelativeX then
    Result.X := Result.X + LastPoint.X;
  if AIsRelativeY then
    Result.Y := Result.Y + LastPoint.Y;
end;

function TdxSVGParserPath.GetPoints(const AData: string): TdxSVGPoints;
begin
  if FBufferPoints = nil then
    FBufferPoints := TdxSVGPoints.Create;
  TdxSVGParserNumbers.AsPoints(AData, FBufferPoints);
  Result := FBufferPoints;
end;

function TdxSVGParserPath.MirrorPoint(const P, AMirror: TdxPointF): TdxPointF;
begin
  Result.X := P.X + (AMirror.X - P.X) * 2;
  Result.Y := P.Y + (AMirror.Y - P.Y) * 2;
end;

procedure TdxSVGParserPath.RegisterCommands;
begin
  FCommandProcs.Add('a', ProcessCommandArc);
  FCommandProcs.Add('c', ProcessCommandCurveTo);
  FCommandProcs.Add('h', ProcessCommandHorzLine);
  FCommandProcs.Add('l', ProcessCommandLineTo);
  FCommandProcs.Add('m', ProcessCommandMoveTo);
  FCommandProcs.Add('q', ProcessCommandQuadraticCurveTo);
  FCommandProcs.Add('s', ProcessCommandCurveToSmooth);
  FCommandProcs.Add('t', ProcessCommandQuadraticCurveToSmooth);
  FCommandProcs.Add('v', ProcessCommandVertLine);
  FCommandProcs.Add('z', ProcessCommandClose);
end;

function TdxSVGParserPath.GetLastPoint: TdxPointF;
begin
  if FCommands.Count > 0 then
    Result := TdxSVGParserPathCommand(FCommands.Last).FinishPoint
  else
    Result := dxNullPointF;
end;

function TdxSVGParserPath.GetCommand(Index: Integer): TdxSVGParserPathCommand;
begin
  Result := TdxSVGParserPathCommand(FCommands[Index]);
end;

function TdxSVGParserPath.GetCommandCount: Integer;
begin
  Result := FCommands.Count;
end;

procedure TdxSVGParserPath.ProcessCommand(const ACommand: string);
var
  AProc: TCommandProc;
begin
  if FCommandProcs.TryGetValue(dxLowerCase(ACommand[1]), AProc) then
    AProc(Copy(ACommand, 2, MaxInt), dxIsLowerCase(ACommand[1]))
end;

procedure TdxSVGParserPath.ProcessCommandArc(const AData: string; AIsRelative: Boolean);
var
  AIndex: Integer;
  ANumbers: TdxSVGSingleValues;
begin
  AIndex := 0;
  ANumbers := TdxSVGParserNumbers.AsNumbers(AData);
  try
    while AIndex + 6 < ANumbers.Count do
    begin
      FCommands.Add(TdxSVGParserPathCommandArc.Create(
        LastPoint,
        GetAbsolutePoint(ANumbers[AIndex + 5], ANumbers[AIndex + 6], AIsRelative, AIsRelative),
        dxPointF(Abs(ANumbers[AIndex]), Abs(ANumbers[AIndex + 1])),
        ANumbers[AIndex + 2],
        not IsZero(ANumbers[AIndex + 4]),
        not IsZero(ANumbers[AIndex + 3])));
      Inc(AIndex, 7);
    end;
  finally
    ANumbers.Free;
  end;
end;

procedure TdxSVGParserPath.ProcessCommandClose(const AData: string; AIsRelative: Boolean);
var
  ACommand: TObject;
  APoint: TdxPointF;
  I: Integer;
begin
  APoint := LastPoint;
  for I := FCommands.Count - 1 downto 0 do
  begin
    ACommand := FCommands[I];
    if ACommand is TdxSVGParserPathCommandOpen then
    begin
      APoint := TdxSVGParserPathCommandOpen(ACommand).FinishPoint;
      Break;
    end;
  end;
  FCommands.Add(TdxSVGParserPathCommandClose.Create(APoint));
end;

procedure TdxSVGParserPath.ProcessCommandCurveTo(const AData: string; AIsRelative: Boolean);
var
  AIndex: Integer;
  APoints: TdxSVGPoints;
begin
  AIndex := 0;
  APoints := GetPoints(AData);
  while AIndex + 2 < APoints.Count do
  begin
    FCommands.Add(TdxSVGParserPathCommandCurveTo.Create(LastPoint,
      GetAbsolutePoint(APoints[AIndex], AIsRelative),
      GetAbsolutePoint(APoints[AIndex + 1], AIsRelative),
      GetAbsolutePoint(APoints[AIndex + 2], AIsRelative)));
    Inc(AIndex, 3);
  end;
end;

procedure TdxSVGParserPath.ProcessCommandCurveToSmooth(const AData: string; AIsRelative: Boolean);
var
  AControlPoint: TdxPointF;
  AIndex: Integer;
  APoints: TdxSVGPoints;
begin
  AIndex := 0;
  APoints := GetPoints(AData);
  while AIndex + 1 < APoints.Count do
  begin
    AControlPoint := LastPoint;
    if FCommands.Last is TdxSVGParserPathCommandCurveTo then
      AControlPoint := MirrorPoint(TdxSVGParserPathCommandCurveTo(FCommands.Last).Point2, AControlPoint);
    FCommands.Add(TdxSVGParserPathCommandCurveTo.Create(
      LastPoint, AControlPoint,
      GetAbsolutePoint(APoints[AIndex], AIsRelative),
      GetAbsolutePoint(APoints[AIndex + 1], AIsRelative)));
    Inc(AIndex, 2);
  end;
end;

procedure TdxSVGParserPath.ProcessCommandHorzLine(const AData: string; AIsRelative: Boolean);
begin
  TdxSVGParserNumbers.AsNumbers(AData,
    procedure (const AValue: Single)
    begin
      FCommands.Add(TdxSVGParserPathCommandLine.Create(LastPoint, GetAbsolutePoint(AValue, LastPoint.Y, AIsRelative, False)));
    end);
end;

procedure TdxSVGParserPath.ProcessCommandLineTo(const AData: string; AIsRelative: Boolean);
var
  APoints: TdxSVGPoints;
  I: Integer;
begin
  APoints := GetPoints(AData);
  for I := 0 to APoints.Count - 1 do
    FCommands.Add(TdxSVGParserPathCommandLine.Create(LastPoint, GetAbsolutePoint(APoints[I], AIsRelative)));
end;

procedure TdxSVGParserPath.ProcessCommandMoveTo(const AData: string; AIsRelative: Boolean);
var
  APoints: TdxSVGPoints;
  I: Integer;
begin
  APoints := GetPoints(AData);
  FCommands.Add(TdxSVGParserPathCommandMoveTo.Create(GetAbsolutePoint(APoints.First, AIsRelative)));
  ProcessCommandOpen(AData, AIsRelative);
  for I := 1 to APoints.Count - 1 do
    FCommands.Add(TdxSVGParserPathCommandLine.Create(LastPoint, GetAbsolutePoint(APoints[I], AIsRelative)));
end;

procedure TdxSVGParserPath.ProcessCommandOpen(const AData: string; AIsRelative: Boolean);
begin
  FCommands.Add(TdxSVGParserPathCommandOpen.Create(LastPoint));
end;

procedure TdxSVGParserPath.ProcessCommandQuadraticCurveTo(const AData: string; AIsRelative: Boolean);
var
  AIndex: Integer;
  APoints: TdxSVGPoints;
begin
  AIndex := 0;
  APoints := GetPoints(AData);
  while AIndex + 1 < APoints.Count do
  begin
    FCommands.Add(TdxSVGParserPathCommandQuadraticCurveTo.Create(LastPoint,
      GetAbsolutePoint(APoints[AIndex], AIsRelative),
      GetAbsolutePoint(APoints[AIndex + 1], AIsRelative)));
    Inc(AIndex, 2);
  end;
end;

procedure TdxSVGParserPath.ProcessCommandQuadraticCurveToSmooth(const AData: string; AIsRelative: Boolean);
var
  AIndex: Integer;
  AMiddlePoint: TdxPointF;
  APoints: TdxSVGPoints;
begin
  AIndex := 0;
  APoints := GetPoints(AData);
  while AIndex < APoints.Count do
  begin
    AMiddlePoint := LastPoint;
    if FCommands.Last is TdxSVGParserPathCommandQuadraticCurveTo then
      AMiddlePoint := MirrorPoint(TdxSVGParserPathCommandQuadraticCurveTo(FCommands.Last).MiddlePoint, AMiddlePoint);
    FCommands.Add(TdxSVGParserPathCommandQuadraticCurveTo.Create(LastPoint, AMiddlePoint, GetAbsolutePoint(APoints[AIndex], AIsRelative)));
    Inc(AIndex);
  end;
end;

procedure TdxSVGParserPath.ProcessCommandVertLine(const AData: string; AIsRelative: Boolean);
begin
  TdxSVGParserNumbers.AsNumbers(AData,
    procedure (const AValue: Single)
    begin
      FCommands.Add(TdxSVGParserPathCommandLine.Create(LastPoint, GetAbsolutePoint(LastPoint.X, AValue, False, AIsRelative)));
    end);
end;

{ TdxSVGParserPathCommand }

constructor TdxSVGParserPathCommand.Create(const AFinishPoint: TdxPointF);
begin
  FinishPoint := AFinishPoint;
end;

procedure TdxSVGParserPathCommand.Append(APath: TdxGPPath);
begin
  // do nothing
end;

{ TdxSVGParserPathCommandArc }

constructor TdxSVGParserPathCommandArc.Create(
  const AStartPoint, AFinishPoint, ARadius: TdxPointF; AAngle: Single; ASweep, ALargeArc: Boolean);
begin
  inherited Create(AFinishPoint);
  StartPoint := AStartPoint;
  LargeArc := ALargeArc;
  Radius := ARadius;
  Angle := AAngle;
  Sweep := ASweep;
end;

procedure TdxSVGParserPathCommandArc.Append(APath: TdxGPPath);
var
  AAngle, AAngleDelta: Double;
  ACenterPoint: TdxPointF;
  ARealRadius: TdxPointF;
  ARotateMatrix: TdxGPMatrix;
  AVector1, AVector2: TdxPointF;
begin
  if cxPointIsEqual(StartPoint, FinishPoint) then
    Exit;
  if IsZero(Radius.X) or IsZero(Radius.Y) then
  begin
    APath.AddLine(StartPoint.X, StartPoint.Y, FinishPoint.X, FinishPoint.Y);
    Exit;
  end;

  ARotateMatrix := TdxGPMatrix.Create;
  try
    ARotateMatrix.Rotate(-Angle);
    CalculateVectors(ARotateMatrix, AVector1, AVector2, ACenterPoint, ARealRadius);

    AAngle := TdxVectors.Angle(dxPointF(1.0, 0.0), AVector1);
    AAngleDelta := TdxVectors.Angle(AVector1, AVector2);
    if not Sweep and (AAngleDelta > 0) then
      AAngleDelta := AAngleDelta - 2.0 * PI
    else if Sweep and (AAngleDelta < 0) then
      AAngleDelta := AAngleDelta + 2.0 * PI;

    ARotateMatrix.Invert;
    ACenterPoint := ARotateMatrix.TransformPoint(ACenterPoint);
    ACenterPoint := cxPointOffset(ACenterPoint, (StartPoint.X + FinishPoint.X) / 2, (StartPoint.Y + FinishPoint.Y) / 2);

    AppendCore(APath, ARotateMatrix, ARealRadius, StartPoint, ACenterPoint, AAngle, AAngleDelta);
  finally
    ARotateMatrix.Free;
  end;
end;

procedure TdxSVGParserPathCommandArc.AppendCore(APath: TdxGPPath; ARotateMatrix: TdxGPMatrix;
  ARadius, AStartPoint, AOffset: TdxPointF; AStartAngle, AAngleDelta: Double);

  function CalculateDelta(const ASin, ACos, AScaleFactor: Double): TdxPointF;
  begin
    Result := dxPointF(ARadius.X * ASin, -ARadius.Y * ACos);
    Result := ARotateMatrix.TransformPoint(Result);
    Result := cxPointScale(Result, AScaleFactor);
  end;

var
  ACosAngle1, ACosAngle2: Double;
  AEndPoint: TdxPointF;
  AScaleFactor: Double;
  ASegmentCount: Integer;
  ASinAngle1, ASinAngle2: Double;
begin
  ASegmentCount := Ceil(Abs(AAngleDelta / (PI * 0.5)));
  AAngleDelta := AAngleDelta / ASegmentCount;
  AScaleFactor := 8 / 3 * Sqr(Sin(AAngleDelta / 4)) / Sin(AAngleDelta / 2);

  ACosAngle1 := Cos(AStartAngle);
  ASinAngle1 := Sin(AStartAngle);
  while ASegmentCount > 0 do
  begin
    ACosAngle2 := Cos(AStartAngle + AAngleDelta);
    ASinAngle2 := Sin(AStartAngle + AAngleDelta);

    AEndPoint := ARotateMatrix.TransformPoint(dxPointF(ARadius.X * ACosAngle2, ARadius.Y * ASinAngle2));
    AEndPoint := cxPointOffset(AEndPoint, AOffset);

    APath.AddBezier(
      AStartPoint,
      cxPointOffset(AStartPoint, CalculateDelta(ASinAngle1, ACosAngle1, -AScaleFactor)),
      cxPointOffset(AEndPoint, CalculateDelta(ASinAngle2, ACosAngle2, AScaleFactor)),
      AEndPoint);

    AStartAngle := AStartAngle + AAngleDelta;
    ACosAngle1 := ACosAngle2;
    ASinAngle1 := ASinAngle2;
    AStartPoint := AEndPoint;
    Dec(ASegmentCount);
  end;
end;

procedure TdxSVGParserPathCommandArc.CalculateVectors(
  ARotateMatrix: TdxGPMatrix; out AVector1, AVector2, ACenterPoint, ARadius: TdxPointF);
var
  APoint1: TdxPointF;
  ARoot: Double;
  AValue1: Double;
  AValue2: Double;
begin
  ARadius := Radius;

  APoint1 := cxPointOffset(StartPoint, FinishPoint, False);
  APoint1 := dxPointF(APoint1.X / 2, APoint1.Y / 2);
  APoint1 := ARotateMatrix.TransformPoint(APoint1);

  AValue1 := Sqr(Radius.X) * Sqr(Radius.Y);
  AValue2 := Sqr(Radius.X) * Sqr(APoint1.Y) + Sqr(Radius.Y) * Sqr(APoint1.X);
  if AValue1 < AValue2 then
  begin
    ARadius := cxPointScale(ARadius, Sqrt(AValue2 / AValue1));
    ACenterPoint := dxNullPointF;
  end
  else
  begin
    ARoot := Sqrt(AValue1 / AValue2 - 1);
    if Sweep = LargeArc then
      ARoot := -ARoot;
    ACenterPoint.X :=  ARoot * APoint1.Y * ARadius.X / ARadius.Y;
    ACenterPoint.Y := -ARoot * APoint1.X * ARadius.Y / ARadius.X;
  end;

  AVector1.X := (APoint1.X - ACenterPoint.X) / ARadius.X;
  AVector1.Y := (APoint1.Y - ACenterPoint.Y) / ARadius.Y;

  AVector2.X := -(APoint1.X + ACenterPoint.X) / ARadius.X;
  AVector2.Y := -(APoint1.Y + ACenterPoint.Y) / ARadius.Y;
end;

{ TdxSVGParserPathCommandOpen }

procedure TdxSVGParserPathCommandOpen.Append(APath: TdxGPPath);
begin
  APath.FigureStart;
end;

{ TdxSVGParserPathCommandClose }

procedure TdxSVGParserPathCommandClose.Append(APath: TdxGPPath);
begin
  APath.FigureFinish;
end;

{ TdxSVGParserPathCommandCurveTo }

constructor TdxSVGParserPathCommandCurveTo.Create(const AStartPoint, APoint1, APoint2, AFinishPoint: TdxPointF);
begin
  inherited Create(AFinishPoint);
  StartPoint := AStartPoint;
  Point1 := APoint1;
  Point2 := APoint2;
end;

procedure TdxSVGParserPathCommandCurveTo.Append(APath: TdxGPPath);
begin
  APath.AddBezier(StartPoint, Point1, Point2, FinishPoint);
end;

{ TdxSVGParserPathCommandLine }

constructor TdxSVGParserPathCommandLine.Create(const AStartPoint, AFinishPoint: TdxPointF);
begin
  StartPoint := AStartPoint;
  FinishPoint := AFinishPoint;
end;

procedure TdxSVGParserPathCommandLine.Append(APath: TdxGPPath);
begin
  APath.AddLine(StartPoint.X, StartPoint.Y, FinishPoint.X, FinishPoint.Y);
end;

{ TdxSVGParserPathCommandQuadraticCurveTo }

constructor TdxSVGParserPathCommandQuadraticCurveTo.Create(const AStartPoint, AMiddlePoint, AFinishPoint: TdxPointF);
begin
  inherited Create(AFinishPoint);
  StartPoint := AStartPoint;
  MiddlePoint := AMiddlePoint;
end;

procedure TdxSVGParserPathCommandQuadraticCurveTo.Append(APath: TdxGPPath);

  function CalcPoint(const APoint, AMiddlePoint: TdxPointF): TdxPointF;
  begin
    Result.X := APoint.X + 2.0 / 3.0 * (AMiddlePoint.X - APoint.X);
    Result.Y := APoint.Y + 2.0 / 3.0 * (AMiddlePoint.Y - APoint.Y);
  end;

begin
  APath.AddBezier(StartPoint, CalcPoint(StartPoint, MiddlePoint), CalcPoint(FinishPoint, MiddlePoint), FinishPoint);
end;

{ TdxSVGParserTransform }

class constructor TdxSVGParserTransform.Create;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorStarted(UnitName, 'TdxSVGParserTransform.Create', SysInit.HInstance);{$ENDIF}
  FOperatorsMap := TDictionary<string, TOperatorProc>.Create;
  FOperatorsMap.Add('matrix', OperatorMatrix);
  FOperatorsMap.Add('rotate', OperatorRotate);
  FOperatorsMap.Add('scale', OperatorScale);
  FOperatorsMap.Add('skewX', OperatorSkewX);
  FOperatorsMap.Add('skewY', OperatorSkewY);
  FOperatorsMap.Add('translate', OperatorTranslate);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorFinished(UnitName, 'TdxSVGParserTransform.Create', SysInit.HInstance);{$ENDIF}
end;

class destructor TdxSVGParserTransform.Destroy;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TdxSVGParserTransform.Destroy', SysInit.HInstance);{$ENDIF}
  FreeAndNil(FOperatorsMap);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TdxSVGParserTransform.Destroy', SysInit.HInstance);{$ENDIF}
end;

class procedure TdxSVGParserTransform.Parse(const S: string; AMatrix: TdxMatrix);
var
  AOperatorProc: TOperatorProc;
  AOperators: TStringList;
  AValues: TdxSVGSingleValues;
  I: Integer;
begin
  AOperators := Split(S);
  try
    AMatrix.XForm := TXForm.CreateIdentityMatrix;
    for I := 0 to AOperators.Count - 1 do
      if FOperatorsMap.TryGetValue(AOperators.Names[I], AOperatorProc) then
      begin
        AValues := TdxSVGParserNumbers.AsNumbers(AOperators.ValueFromIndex[I]);
        try
          AMatrix.XForm := TXForm.Combine(AOperatorProc(AValues), AMatrix.XForm);
        finally
          AValues.Free;
        end;
      end;
  finally
    AOperators.Free;
  end;
end;

class function TdxSVGParserTransform.Split(const S: string): TStringList;
var
  AParts: TStringDynArray;
  I: Integer;
begin
  AParts := SplitString(S, ')');

  Result := TStringList.Create;
  Result.Capacity := Length(AParts);
  Result.NameValueSeparator := '(';
  for I := 0 to Length(AParts) - 1 do
    Result.Add(Trim(AParts[I]))
end;

class function TdxSVGParserTransform.GetValue(AValues: TdxSVGSingleValues; AIndex: Integer; ADefaultValue: Single = 0): Single;
begin
  if InRange(AIndex, 0, AValues.Count - 1) then
    Result := AValues[AIndex]
  else
    Result := ADefaultValue;
end;

class function TdxSVGParserTransform.OperatorMatrix(AValues: TdxSVGSingleValues): TXForm;
begin
  Result := TXForm.CreateMatrix(
    GetValue(AValues, 0, 1), GetValue(AValues, 1),
    GetValue(AValues, 2), GetValue(AValues, 3, 1),
    GetValue(AValues, 4), GetValue(AValues, 5));
end;

class function TdxSVGParserTransform.OperatorRotate(AValues: TdxSVGSingleValues): TXForm;
begin
  Result := TXForm.CreateTranslateMatrix(GetValue(AValues, 1), GetValue(AValues, 2));
  Result := TXForm.Combine(TXForm.CreateRotationMatrix(GetValue(AValues, 0)), Result);
  Result := TXForm.Combine(TXForm.CreateTranslateMatrix(-GetValue(AValues, 1), -GetValue(AValues, 2)), Result);
end;

class function TdxSVGParserTransform.OperatorScale(AValues: TdxSVGSingleValues): TXForm;
var
  X, Y: Single;
begin
  X := GetValue(AValues, 0, 1);
  Y := GetValue(AValues, 1, X);
  Result := TXForm.CreateScaleMatrix(X, Y);
end;

class function TdxSVGParserTransform.OperatorSkewX(AValues: TdxSVGSingleValues): TXForm;
begin
  Result := TXForm.CreateMatrix(1, 0, Tan(DegToRad(GetValue(AValues, 0))), 1, 0, 0);
end;

class function TdxSVGParserTransform.OperatorSkewY(AValues: TdxSVGSingleValues): TXForm;
begin
  Result := TXForm.CreateMatrix(1, Tan(DegToRad(GetValue(AValues, 0))), 0, 1, 0, 0);
end;

class function TdxSVGParserTransform.OperatorTranslate(AValues: TdxSVGSingleValues): TXForm;
begin
  Result := TXForm.CreateTranslateMatrix(GetValue(AValues, 0), GetValue(AValues, 1));
end;

end.
