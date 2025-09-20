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

unit dxPDFText;

{$I cxVer.inc}

interface

uses
  SysUtils, Types, Generics.Defaults, Generics.Collections, cxGeometry, dxGDIPlusClasses, dxPDFBase, dxPDFTypes,
  dxPDFCharacterMapping, dxFontFile;

type
  { TdxPDFPageTextPosition }

  TdxPDFPageTextPosition = record
  public
    Offset: Integer;
    WordIndex: Integer;

    class function Create(AWordIndex: Integer; AOffset: Integer): TdxPDFPageTextPosition; static;
    class function Invalid: TdxPDFPageTextPosition; static;

    function IsSame(const AValue: TdxPDFPageTextPosition): Boolean;
    function IsValid: Boolean;
  end;

  { TdxPDFTextPosition }

  TdxPDFTextPosition = record
  public
    PageIndex: Integer;
    Position: TdxPDFPageTextPosition;

    class function Create(APageIndex, AWordIndex, AOffset: Integer): TdxPDFTextPosition; overload; static;
    class function Create(APageIndex: Integer; const APosition: TdxPDFPageTextPosition): TdxPDFTextPosition; overload; static;
    class function Invalid: TdxPDFTextPosition; overload; static;

    function IsValid: Boolean;
    function Same(const AValue: TdxPDFTextPosition): Boolean;
  end;

  { TdxPDFTextRange }

  TdxPDFTextRange = record
    StartPosition: TdxPDFTextPosition;
    EndPosition: TdxPDFTextPosition;
  end;

  { TdxPDFPageTextRange }

  TdxPDFPageTextRange = record
  public
    PageIndex: Integer;
    EndPosition: TdxPDFPageTextPosition;
    StartPosition: TdxPDFPageTextPosition;
    WholePage: Boolean;

    class function Create: TdxPDFPageTextRange; overload; static;
    class function Create(APageIndex: Integer): TdxPDFPageTextRange; overload; static;
    class function Create(APageIndex: Integer; const AStartPosition,
      AEndPosition: TdxPDFPageTextPosition): TdxPDFPageTextRange; overload; static;
    class function Create(APageIndex, AStartWordIndex, AStartOffset,
      AEndWordIndex,AEndOffset: Integer): TdxPDFPageTextRange; overload; static;
    class function Invalid: TdxPDFPageTextRange; static;
    class function Same(V1, V2: TdxPDFPageTextRange): Boolean; static;
    function IsValid: Boolean;
  end;
  TdxPDFPageTextRanges = array of TdxPDFPageTextRange;

  { TdxPDFTextRangeHelper }

  TdxPDFTextRangeHelper = record helper for TdxPDFTextRange
  public
    class function Create(const AStart, AEnd: TdxPDFTextPosition): TdxPDFTextRange; overload; static;
    class function Create(AStartPageIndex, AStartWordIndex, AStartOffset, AEndPageIndex, AEndWordIndex, AEndOffset: Integer): TdxPDFTextRange; overload; static;
  end;

  { TdxPDFTextCharacter }

  TdxPDFTextCharacter = record // for internal use
  public
    Bounds: TdxPDFOrientedRect;
    FontSizeF: Single;
    Text: string;  
    BaseLineLocation: TdxPointF;
    class function Create(AFontSizeF: Single; const ABaseLineLocation: TdxPointF; const ABounds: TdxPDFOrientedRect;
      const AText: string): TdxPDFTextCharacter; static;
  end;
  TdxPDFTextCharacters = class(TList<TdxPDFTextCharacter>)
  end;

  { TdxPDFFontRegistrationData }

  TdxPDFFontRegistrationData = record // for internal use
  public
    IsType3Font: Boolean;
    Italic: Boolean;
    Name: string;
    PitchAndFamily: Byte;
    Registrator: TObject;
    UseEmbeddedEncoding: Boolean;
    Weight: Integer;
    class function Create(const AName: string; AWeight: Integer; AItalic: Boolean; APitchAndFamily: Byte;
      AUseEmbeddedEncoding: Boolean; ARegistrator: TObject; AIsType3Font: Boolean): TdxPDFFontRegistrationData; static;
  end;

  TdxBiDiCharacterClass = (bccUnknown, bccLTR, bccRTL, bccNumeric, bccOther);
  TdxBiDiTextDirection = (btdUnknown, btdLeftToRight, btdRightToLeft);

  { TdxPDFType1FontFileData }

  TdxPDFType1FontFileData = record // for internal use
  strict private
    FCipherTextLength: Integer;
    FData: TBytes;
    FIsNull: Boolean;
    FNullSegmentLength: Integer;
    FPlainTextLength: Integer;
  public
    class function Create(const AData: TBytes; APlainTextLength, ACipherTextLength,
      ANullSegmentLength: Integer): TdxPDFType1FontFileData; static;
    class function IsPfbData(const AData: TBytes): Boolean; static;
    class function Parse(ADictionary: TdxPDFDictionary): TdxPDFType1FontFileData; static;
    function IsNull: Boolean;
    procedure Reset;

    property CipherTextLength: Integer read FCipherTextLength;
    property Data: TBytes read FData;
    property NullSegmentLength: Integer read FNullSegmentLength;
    property PlainTextLength: Integer read FPlainTextLength;
  end;

  { TdxBiDiSequence }

  TdxBiDiSequence = class // for internal use
  strict private
    FCharacterClass: TdxBiDiCharacterClass;
    FCharacters: TStringBuilder;
  public
    constructor Create(ACharacterClass: TdxBiDiCharacterClass);
    destructor Destroy; override;

    function Clone: TdxBiDiSequence;
    function IsNotEmpty: Boolean;
    procedure AppendChar(const AUnicodeChar: string);
    procedure AppendTo(ABuilder: TStringBuilder);
    procedure AppendMirroredTo(ABuilder: TStringBuilder);

    property CharacterClass: TdxBiDiCharacterClass read FCharacterClass;
  end;

  { TdxBiDiCharacterClasses }

  TdxBiDiCharacterClasses = class // for internal use
  strict private
    FCharacterClasses: TArray<TdxBiDiCharacterClass>;
  public
    constructor Create;
    destructor Destroy; override;

    function GetCharacterClass(ACharacter: Char): TdxBiDiCharacterClass;
  end;

  { TdxBiDiDirectedSequenceCollection }

  TdxBiDiDirectedSequenceCollection = class(TObjectList<TdxBiDiSequence>) // for internal use
  strict private
    FDirection: TdxBiDiTextDirection;
  public
    constructor Create(ADirection: TdxBiDiTextDirection);
    function Clone: TdxBiDiDirectedSequenceCollection;

    function GetDirectedString: string;
    property Direction: TdxBiDiTextDirection read FDirection write FDirection;
  end;

  { TdxBiDiStringBuilder }

  TdxBiDiStringBuilder = class // for internal use
  strict private
    FUnicodeReplacementCharacter: string;
    FResultBuilder: TStringBuilder;
    FCurrentLine: TObjectList<TdxBiDiDirectedSequenceCollection>;
    FCurrentDirectedSequence: TdxBiDiDirectedSequenceCollection;
    FCurrentBiDiSequence: TdxBiDiSequence;
    FEndsWithNewLine: Boolean;
    FEmpty: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function EndCurrentLineAndGetString: string;
    function Length: Integer;
    function FinishLineAndGetSequenceString: string;
    procedure Append(const AUnicodeChar: string);
    procedure AppendLine;
    procedure FinishSequence(ANewSequenceCharacterClass: TdxBiDiCharacterClass);

    property Empty: Boolean read FEmpty;
    property EndsWithNewLine: Boolean read FEndsWithNewLine;
  end;

  { TdxPDFFontData }

  TdxPDFFontData = class // for internal use
  strict private
    FMetrics: TdxPDFFontMetricsMetadata;
    FFirstChar: Integer;
    FFont: TObject;
    FMissingWidth: Single;
    FWidths: TDoubleDynArray;
    function GetCMap: TdxPDFCharacterMapping;
  public
    class function CreateFontData(AFont: TdxPDFBase): TdxPDFFontData; static;
    constructor Create(AFont: TObject; AFirstChar: Integer; AWidths: TDoubleDynArray; AMissingWidth: Single);

    property CMap: TdxPDFCharacterMapping read GetCMap;
    property FirstChar: Integer read FFirstChar;
    property Font: TObject read FFont;
    property Metrics: TdxPDFFontMetricsMetadata read FMetrics;
    property MissingWidth: Single read FMissingWidth;
    property Widths: TDoubleDynArray read FWidths;
  end;

  { TdxPDFTextState }

  TdxPDFTextState = class // for internal use
  strict private
    FCharacterSpacing: Double;
    FHorizontalScaling: Double;
    FFont: TdxPDFBase;
    FKnockout: Double;
    FLeading: Double;
    FFontSize: Double;
    FRenderingMode: TdxPDFTextRenderingMode;
    FRise: Double;
    FTextLineMatrix: TdxPDFTransformationMatrix;
    FTextMatrix: TdxPDFTransformationMatrix;
    FTextSpaceMatrix: TdxPDFTransformationMatrix;
    FWordSpacing: Double;

    function GetAbsoluteFontSize: Double;
    function GetAbsoluteHorizontalScaling: Double;
    function GetFontSizeFactor: Double;
    function GetTextSpaceMatrix: TdxPDFTransformationMatrix;
    procedure SetFont(const AValue: TdxPDFBase);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(ATextState: TdxPDFTextState);

    property AbsoluteFontSize: Double read GetAbsoluteFontSize;
    property AbsoluteHorizontalScaling: Double read GetAbsoluteHorizontalScaling;
    property CharacterSpacing: Double read FCharacterSpacing write FCharacterSpacing;
    property HorizontalScaling: Double read FHorizontalScaling write FHorizontalScaling;
    property Font: TdxPDFBase read FFont write SetFont;
    property FontSize: Double read FFontSize write FFontSize;
    property FontSizeFactor: Double read GetFontSizeFactor;
    property Knockout: Double read FKnockout write FKnockout;
    property Leading: Double read FLeading write FLeading;
    property RenderingMode: TdxPDFTextRenderingMode read FRenderingMode write FRenderingMode;
    property Rise: Double read FRise write FRise;
    property TextLineMatrix: TdxPDFTransformationMatrix read FTextLineMatrix write FTextLineMatrix;
    property TextSpaceMatrix: TdxPDFTransformationMatrix read GetTextSpaceMatrix;
    property TextMatrix: TdxPDFTransformationMatrix read FTextMatrix write FTextMatrix;
    property WordSpacing: Double read FWordSpacing write FWordSpacing;
  end;

  { TdxPDFBaseTextUtils }

  TdxPDFBaseTextUtils = class
  public
    class function IsCJK(AChar: WideChar): Boolean; static; inline;
    class function IsSeparator(const S: string): Boolean; static;
    class function IsWhiteSpace(const S: string): Boolean; static;
    class function IsWrapSymbol(const S: string): Boolean; static;
    class function HasCJKMarker(const S: string): Boolean; static;
    class function HasFlag(AFlags, AFontStyle: TdxGPFontStyle): Boolean; static;
    class function HasRTLMarker(const S: string): Boolean; static;
    class function RotatePoint(const APoint: TdxPointF; AAngle: Single): TdxPointF; static; inline;
    class function GetOrientedDistance(const AFirst, ASecond: TdxPointF; AAngle: Single): Single; static;

    class function EndsWith(const S, AEndsWith: string): Boolean; static;
    class function StartsWith(const S, AStartsWith: string): Boolean; static;
    class procedure AddRange(const ARange: TdxPDFPageTextRange; var ARanges: TdxPDFPageTextRanges); static;
  end;

implementation

uses
  Character, Classes, Math, dxCore, dxTypeHelpers, dxStringHelper,
  dxPDFUtils, dxPDFCore, dxPDFFont, dxPDFType1Font, dxPDFCommand;

const
  dxThisUnitName = 'dxPDFText';

type
  TdxPDFModifyTransformationMatrixCommandAccess = class(TdxPDFModifyTransformationMatrixCommand);

  { TdxBiDiBrackets }

  TdxBiDiBrackets = class
  strict private
    FDictionary: TdxPDFIntegerIntegerDictionary;
  public
    constructor Create;
    destructor Destroy; override;

    function TryGetMirroredBracket(ACharacter: Char): Char;
  end;

var
  dxgBiDiCharacterClasses: TdxBiDiCharacterClasses;
  dxgBiDiBrackets: TdxBiDiBrackets;

function dxBiDiCharacterClasses: TdxBiDiCharacterClasses;
begin
  if dxgBiDiCharacterClasses = nil then
    dxgBiDiCharacterClasses := TdxBiDiCharacterClasses.Create;
  Result := dxgBiDiCharacterClasses;
end;

function dxBiDiBrackets: TdxBiDiBrackets;
begin
  if dxgBiDiBrackets = nil then
    dxgBiDiBrackets := TdxBiDiBrackets.Create;
  Result := dxgBiDiBrackets;
end;

{ TdxBiDiBrackets }

constructor TdxBiDiBrackets.Create;
begin
  inherited Create;
  FDictionary := TdxPDFIntegerIntegerDictionary.Create;
  FDictionary.Add($0028, $0029);
  FDictionary.Add($0029, $0028);
  FDictionary.Add($005B, $005D);
  FDictionary.Add($005D, $005B);

  FDictionary.Add($007B, $007D);
  FDictionary.Add($007D, $007B);
  FDictionary.Add($0F3A, $0F3B);
  FDictionary.Add($0F3B, $0F3A);

  FDictionary.Add($0F3C, $0F3D);
  FDictionary.Add($0F3D, $0F3C);
  FDictionary.Add($169B, $169C);
  FDictionary.Add($169C, $169B);

  FDictionary.Add($2045, $2046);
  FDictionary.Add($2046, $2045);
  FDictionary.Add($207D, $207E);
  FDictionary.Add($207E, $207D);

  FDictionary.Add($208D, $208E);
  FDictionary.Add($208E, $208D);
  FDictionary.Add($2308, $2309);
  FDictionary.Add($2309, $2308);

  FDictionary.Add($230A, $230B);
  FDictionary.Add($230B, $230A);
  FDictionary.Add($2329, $232A);
  FDictionary.Add($232A, $2329);

  FDictionary.Add($2768, $2769);
  FDictionary.Add($2769, $2768);
  FDictionary.Add($276A, $276B);
  FDictionary.Add($276B, $276A);

  FDictionary.Add($276C, $276D);
  FDictionary.Add($276D, $276C);
  FDictionary.Add($276E, $276F);
  FDictionary.Add($276F, $276E);

  FDictionary.Add($2770, $2771);
  FDictionary.Add($2771, $2770);
  FDictionary.Add($2772, $2773);
  FDictionary.Add($2773, $2772);

  FDictionary.Add($2774, $2775);
  FDictionary.Add($2775, $2774);
  FDictionary.Add($27C5, $27C6);
  FDictionary.Add($27C6, $27C5);

  FDictionary.Add($27E6, $27E7);
  FDictionary.Add($27E7, $27E6);
  FDictionary.Add($27E8, $27E9);
  FDictionary.Add($27E9, $27E8);

  FDictionary.Add($27EA, $27EB);
  FDictionary.Add($27EB, $27EA);
  FDictionary.Add($27EC, $27ED);
  FDictionary.Add($27ED, $27EC);

  FDictionary.Add($27EE, $27EF);
  FDictionary.Add($27EF, $27EE);
  FDictionary.Add($2983, $2984);
  FDictionary.Add($2984, $2983);

  FDictionary.Add($2985, $2986);
  FDictionary.Add($2986, $2985);
  FDictionary.Add($2987, $2988);
  FDictionary.Add($2988, $2987);

  FDictionary.Add($2989, $298A);
  FDictionary.Add($298A, $2989);
  FDictionary.Add($298B, $298C);
  FDictionary.Add($298C, $298B);

  FDictionary.Add($298D, $2990);
  FDictionary.Add($298E, $298F);
  FDictionary.Add($298F, $298E);
  FDictionary.Add($2990, $298D);

  FDictionary.Add($2991, $2992);
  FDictionary.Add($2992, $2991);
  FDictionary.Add($2993, $2994);
  FDictionary.Add($2994, $2993);

  FDictionary.Add($2995, $2996);
  FDictionary.Add($2996, $2995);
  FDictionary.Add($2997, $2998);
  FDictionary.Add($2998, $2997);

  FDictionary.Add($29D8, $29D9);
  FDictionary.Add($29D9, $29D8);
  FDictionary.Add($29DA, $29DB);
  FDictionary.Add($29DB, $29DA);

  FDictionary.Add($29FC, $29FD);
  FDictionary.Add($29FD, $29FC);
  FDictionary.Add($2E22, $2E23);
  FDictionary.Add($2E23, $2E22);

  FDictionary.Add($2E24, $2E25);
  FDictionary.Add($2E25, $2E24);
  FDictionary.Add($2E26, $2E27);
  FDictionary.Add($2E27, $2E26);

  FDictionary.Add($2E28, $2E29);
  FDictionary.Add($2E29, $2E28);
  FDictionary.Add($3008, $3009);
  FDictionary.Add($3009, $3008);

  FDictionary.Add($300A, $300B);
  FDictionary.Add($300B, $300A);
  FDictionary.Add($300C, $300D);
  FDictionary.Add($300D, $300C);

  FDictionary.Add($300E, $300F);
  FDictionary.Add($300F, $300E);
  FDictionary.Add($3010, $3011);
  FDictionary.Add($3011, $3010);

  FDictionary.Add($3014, $3015);
  FDictionary.Add($3015, $3014);
  FDictionary.Add($3016, $3017);
  FDictionary.Add($3017, $3016);

  FDictionary.Add($3018, $3019);
  FDictionary.Add($3019, $3018);
  FDictionary.Add($301A, $301B);
  FDictionary.Add($301B, $301A);

  FDictionary.Add($FE59, $FE5A);
  FDictionary.Add($FE5A, $FE59);
  FDictionary.Add($FE5B, $FE5C);
  FDictionary.Add($FE5C, $FE5B);

  FDictionary.Add($FE5D, $FE5E);
  FDictionary.Add($FE5E, $FE5D);
  FDictionary.Add($FF08, $FF09);
  FDictionary.Add($FF09, $FF08);

  FDictionary.Add($FF3B, $FF3D);
  FDictionary.Add($FF3D, $FF3B);
  FDictionary.Add($FF5B, $FF5D);
  FDictionary.Add($FF5D, $FF5B);

  FDictionary.Add($FF5F, $FF60);
  FDictionary.Add($FF60, $FF5F);
  FDictionary.Add($FF62, $FF63);
  FDictionary.Add($FF63, $FF62);
  FDictionary.TrimExcess;
end;

destructor TdxBiDiBrackets.Destroy;
begin
  FreeAndNil(FDictionary);
  inherited Destroy;
end;

function TdxBiDiBrackets.TryGetMirroredBracket(ACharacter: Char): Char;
var
  AOutChar: Integer;
begin
  if FDictionary.TryGetValue(Integer(ACharacter), AOutChar) then
    Result := Char(AOutChar)
  else
    Result := ACharacter;
end;

{ TdxPDFPageTextPosition }

class function TdxPDFPageTextPosition.Create(AWordIndex, AOffset: Integer): TdxPDFPageTextPosition;
begin
  Result.Offset := AOffset;
  Result.WordIndex := AWordIndex;
end;

class function TdxPDFPageTextPosition.Invalid: TdxPDFPageTextPosition;
begin
  Result.Offset := -1;
  Result.WordIndex := -1;
end;

function TdxPDFPageTextPosition.IsSame(const AValue: TdxPDFPageTextPosition): Boolean;
begin
  Result := (WordIndex = AValue.WordIndex) and (Offset = AValue.Offset);
end;

function TdxPDFPageTextPosition.IsValid: Boolean;
begin
  Result := (WordIndex > -1) and (Offset > -1);
end;

{ TdxPDFTextPosition }

class function TdxPDFTextPosition.Create(APageIndex, AWordIndex, AOffset: Integer): TdxPDFTextPosition;
begin
  Result.PageIndex := APageIndex;
  Result.Position := TdxPDFPageTextPosition.Create(AWordIndex, AOffset);
end;

class function TdxPDFTextPosition.Create(APageIndex: Integer; const APosition: TdxPDFPageTextPosition): TdxPDFTextPosition;
begin
  Result := Create(APageIndex, APosition.WordIndex, APosition.Offset)
end;

class function TdxPDFTextPosition.Invalid: TdxPDFTextPosition;
begin
  Result.PageIndex := -1;
  Result.Position := TdxPDFPageTextPosition.Invalid;
end;

function TdxPDFTextPosition.Same(const AValue: TdxPDFTextPosition): Boolean;
begin
  Result := Position.IsSame(AValue.Position) and (PageIndex = AValue.PageIndex);
end;

function TdxPDFTextPosition.IsValid: Boolean;
begin
  Result := (PageIndex >= 0) and Position.IsValid;
end;

{ TdxPDFPageTextRange }

class function TdxPDFPageTextRange.Create: TdxPDFPageTextRange;
begin
  Result := Invalid;
end;

class function TdxPDFPageTextRange.Create(APageIndex: Integer): TdxPDFPageTextRange;
var
  P: TdxPDFPageTextPosition;
begin
  P := TdxPDFPageTextPosition.Create(0, 0);
  Result := Create(APageIndex, P, P);
  Result.WholePage := True;
end;

class function TdxPDFPageTextRange.Create(APageIndex: Integer;
  const AStartPosition, AEndPosition: TdxPDFPageTextPosition): TdxPDFPageTextRange;
begin
  Result := Create;
  Result.PageIndex := APageIndex;
  Result.StartPosition := AStartPosition;
  Result.EndPosition := AEndPosition;
end;

class function TdxPDFPageTextRange.Create(APageIndex, AStartWordIndex, AStartOffset, AEndWordIndex,
  AEndOffset: Integer): TdxPDFPageTextRange;
begin
  Result := Create(APageIndex,
    TdxPDFPageTextPosition.Create(AStartWordIndex, AStartOffset),
    TdxPDFPageTextPosition.Create(AEndWordIndex, AEndOffset));
end;

class function TdxPDFPageTextRange.Invalid: TdxPDFPageTextRange;
begin
  Result.WholePage := False;
  Result.PageIndex := -1;
  Result.EndPosition := TdxPDFPageTextPosition.Invalid;
  Result.StartPosition := TdxPDFPageTextPosition.Invalid;
end;

class function TdxPDFPageTextRange.Same(V1, V2: TdxPDFPageTextRange): Boolean;
begin
  Result := (V1.PageIndex = V2.PageIndex) and (V1.WholePage = V2.WholePage) and
    V1.StartPosition.IsSame(V2.StartPosition) and V1.EndPosition.IsSame(V2.EndPosition);
end;

function TdxPDFPageTextRange.IsValid: Boolean;
begin
  Result := (PageIndex > -1) and (StartPosition.IsValid or EndPosition.IsValid);
end;

{ TdxPDFTextRangeHelper }

class function TdxPDFTextRangeHelper.Create(const AStart, AEnd: TdxPDFTextPosition): TdxPDFTextRange;
begin
  Result.StartPosition := AStart;
  Result.EndPosition := AEnd;
end;

class function TdxPDFTextRangeHelper.Create(AStartPageIndex, AStartWordIndex, AStartOffset, AEndPageIndex,
  AEndWordIndex, AEndOffset: Integer): TdxPDFTextRange;
begin
  Result := Create(
    TdxPDFTextPosition.Create(AStartPageIndex, AStartWordIndex, AStartOffset),
    TdxPDFTextPosition.Create(AEndPageIndex, AEndWordIndex, AEndOffset));
end;

{ TdxPDFTextCharacter }

class function TdxPDFTextCharacter.Create(AFontSizeF: Single; const ABaseLineLocation: TdxPointF; const ABounds: TdxPDFOrientedRect; const AText: string): TdxPDFTextCharacter;
begin
  Result.Bounds := ABounds;
  Result.Text := AText;
  Result.FontSizeF := AFontSizeF;
  Result.BaseLineLocation:= ABaseLineLocation;
end;

{ TdxPDFTextCharacters }


{ TdxPDFFontRegistrationData }

class function TdxPDFFontRegistrationData.Create(const AName: string; AWeight: Integer;
  AItalic: Boolean; APitchAndFamily: Byte; AUseEmbeddedEncoding: Boolean; ARegistrator: TObject;
  AIsType3Font: Boolean): TdxPDFFontRegistrationData;
begin
  Result.Name := AName;
  Result.Weight := AWeight;
  Result.Italic := AItalic;
  Result.PitchAndFamily := APitchAndFamily;
  Result.UseEmbeddedEncoding := AUseEmbeddedEncoding;
  Result.Registrator := ARegistrator;
  Result.IsType3Font := AIsType3Font;
end;

{ TdxBiDiSequence }

constructor TdxBiDiSequence.Create(ACharacterClass: TdxBiDiCharacterClass);
begin
  inherited Create;
  FCharacterClass := ACharacterClass;
  FCharacters := TdxStringBuilderManager.Get;
end;

destructor TdxBiDiSequence.Destroy;
begin
  TdxStringBuilderManager.Release(FCharacters);
  inherited Destroy;
end;

function TdxBiDiSequence.Clone: TdxBiDiSequence;
begin
  Result := TdxBiDiSequence.Create(FCharacterClass);
  Result.FCharacters.Append(FCharacters.ToString);
end;

function TdxBiDiSequence.IsNotEmpty: Boolean;
begin
  Result := FCharacters.Length <> 0;
end;

procedure TdxBiDiSequence.AppendChar(const AUnicodeChar: string);
var
  I: Integer;
  ADecomposedUnicode: string;
begin
  if AUnicodeChar <> '' then
  begin
    ADecomposedUnicode := AUnicodeChar;
    if FCharacterClass = bccRTL then
    begin
      for I := Length(ADecomposedUnicode) downto 1 do
        FCharacters.Append(ADecomposedUnicode[I]);
    end
    else
      FCharacters.Append(ADecomposedUnicode);
  end;
end;

procedure TdxBiDiSequence.AppendTo(ABuilder: TStringBuilder);
begin
  ABuilder.Append(FCharacters.ToString);
end;

procedure TdxBiDiSequence.AppendMirroredTo(ABuilder: TStringBuilder);
var
  I: Integer;
  S: string;
begin
  S := FCharacters.ToString;
  for I := Length(S) downto 1 do
    ABuilder.Append(dxBiDiBrackets.TryGetMirroredBracket(S[I]));
end;

{ TdxBiDiCharacterClasses }

constructor TdxBiDiCharacterClasses.Create;
var
  I: Integer;
  ABuffer: TBytes;
  AStream: TResourceStream;
  ACharCount: Integer;
begin
  inherited Create;
  ACharCount := 65535 + 1;
  SetLength(ABuffer, ACharCount);
  AStream := TResourceStream.Create(HInstance, 'BiDiData', RT_RCDATA);
  try
    AStream.Read(ABuffer[0], ACharCount);
    SetLength(FCharacterClasses, ACharCount * SizeOf(TdxBiDiCharacterClass));
    for I := 0 to ACharCount - 1 do
      FCharacterClasses[I] := TdxBiDiCharacterClass(ABuffer[I]);
  finally
    AStream.Free;
  end;
end;

destructor TdxBiDiCharacterClasses.Destroy;
begin
  SetLength(FCharacterClasses, 0);
  inherited Destroy;
end;

function TdxBiDiCharacterClasses.GetCharacterClass(ACharacter: Char): TdxBiDiCharacterClass;
begin
  Result := TdxBiDiCharacterClass(FCharacterClasses[Integer(ACharacter)]);
end;

{ TdxBiDiDirectedSequenceCollection }

constructor TdxBiDiDirectedSequenceCollection.Create(ADirection: TdxBiDiTextDirection);
begin
  inherited Create;
  FDirection := ADirection;
end;

function TdxBiDiDirectedSequenceCollection.Clone: TdxBiDiDirectedSequenceCollection;
var
  I: Integer;
begin
  Result := TdxBiDiDirectedSequenceCollection.Create(Direction);
  for I := 0 to Count - 1 do
    Result.Add(Items[I].Clone);
end;

function TdxBiDiDirectedSequenceCollection.GetDirectedString: string;
var
  ADirectedStringBuilder: TStringBuilder;
  I: Integer;
  ASeq: TdxBiDiSequence;
  ACharacterClass: TdxBiDiCharacterClass;
begin
  ADirectedStringBuilder := TdxStringBuilderManager.Get;
  try
    if FDirection = btdRightToLeft then
    begin
      for I := Count - 1 downto 0 do
      begin
        ASeq := Self[I];
        ACharacterClass := ASeq.CharacterClass;
        if ACharacterClass = bccNumeric then
          ASeq.AppendTo(ADirectedStringBuilder)
        else
          ASeq.AppendMirroredTo(ADirectedStringBuilder);
      end;
    end
    else
      for ASeq in Self do
        ASeq.AppendTo(ADirectedStringBuilder);
    Result := ADirectedStringBuilder.ToString;
  finally
    TdxStringBuilderManager.Release(ADirectedStringBuilder);
  end;
end;

{ TdxBiDiStringBuilder }

constructor TdxBiDiStringBuilder.Create;
begin
  inherited Create;
  FUnicodeReplacementCharacter := #$FFFD;
  FResultBuilder := TStringBuilder.Create;
  FCurrentLine := TObjectList<TdxBiDiDirectedSequenceCollection>.Create;
  FCurrentDirectedSequence := TdxBiDiDirectedSequenceCollection.Create(btdUnknown);
  FCurrentBiDiSequence := TdxBiDiSequence.Create(bccLTR);
  FEndsWithNewLine := False;
  FEmpty := True;
end;

destructor TdxBiDiStringBuilder.Destroy;
begin
  FreeAndNil(FCurrentBiDiSequence);
  FreeAndNil(FCurrentDirectedSequence);
  FreeAndNil(FCurrentLine);
  FreeAndNil(FResultBuilder);
  inherited Destroy;
end;

procedure TdxBiDiStringBuilder.FinishSequence(ANewSequenceCharacterClass: TdxBiDiCharacterClass);
begin
  if FCurrentBiDiSequence.IsNotEmpty then
  begin
    case FCurrentBiDiSequence.CharacterClass of
      bccRTL:
        begin
          if FCurrentDirectedSequence.Direction = btdUnknown then
            FCurrentDirectedSequence.Direction := btdRightToLeft
          else
            if FCurrentDirectedSequence.Direction <> btdRightToLeft then
            begin
              FCurrentLine.Add(FCurrentDirectedSequence.Clone);
              FreeAndNil(FCurrentDirectedSequence);
              FCurrentDirectedSequence := TdxBiDiDirectedSequenceCollection.Create(btdRightToLeft);
            end;
          FCurrentDirectedSequence.Add(FCurrentBiDiSequence.Clone);
        end;
      bccLTR:
        begin
          if FCurrentDirectedSequence.Direction = btdUnknown then
            FCurrentDirectedSequence.Direction := btdLeftToRight
          else
            if FCurrentDirectedSequence.Direction <> btdLeftToRight then
            begin
              FCurrentLine.Add(FCurrentDirectedSequence.Clone);
              FreeAndNil(FCurrentDirectedSequence);
              FCurrentDirectedSequence := TdxBiDiDirectedSequenceCollection.Create(btdLeftToRight);
            end;
          FCurrentDirectedSequence.Add(FCurrentBiDiSequence.Clone);
        end;
      else
        FCurrentDirectedSequence.Add(FCurrentBiDiSequence.Clone);
    end;
  end;
  FreeAndNil(FCurrentBiDiSequence);
  FCurrentBiDiSequence := TdxBiDiSequence.Create(ANewSequenceCharacterClass);
end;

function TdxBiDiStringBuilder.FinishLineAndGetSequenceString: string;
var
  ALineTextBuilder: TStringBuilder;
  ASeq: TdxBiDiDirectedSequenceCollection;
begin
  FinishSequence(bccLTR);
  ALineTextBuilder := TdxStringBuilderManager.Get;
  try
    for ASeq in FCurrentLine do
      ALineTextBuilder.Append(ASeq.GetDirectedString);
    if FCurrentDirectedSequence.Count > 0 then
      ALineTextBuilder.Append(FCurrentDirectedSequence.GetDirectedString);
    FCurrentDirectedSequence.Clear;
    FCurrentLine.Clear;
    Result := Trim(ALineTextBuilder.ToString);
  finally
    TdxStringBuilderManager.Release(ALineTextBuilder);
  end;
end;

procedure TdxBiDiStringBuilder.Append(const AUnicodeChar: string);
var
  AChar: string;
  ANewCharacterClass: TdxBiDiCharacterClass;
begin
  if AUnicodeChar = #0 then
    AChar := ' '
  else
    AChar := AUnicodeChar;
  if System.Length(AChar) <> 0 then
  begin
    FEmpty := False;
    FEndsWithNewLine := False;
    ANewCharacterClass := dxBiDiCharacterClasses.GetCharacterClass(AChar[1]);
    if ANewCharacterClass <> FCurrentBiDiSequence.CharacterClass then
      FinishSequence(ANewCharacterClass);
    FCurrentBiDiSequence.AppendChar(AChar);
  end;
end;

procedure TdxBiDiStringBuilder.AppendLine;
begin
  FResultBuilder.AppendLine(FinishLineAndGetSequenceString);
  FEndsWithNewLine := True;
end;

function TdxBiDiStringBuilder.EndCurrentLineAndGetString: string;
begin
  FResultBuilder.Append(FinishLineAndGetSequenceString);
  Result := FResultBuilder.ToString;
end;

function TdxBiDiStringBuilder.Length: Integer;
begin
  Result := FResultBuilder.Length;
end;

{ TdxPDFType1FontFileData }

class function TdxPDFType1FontFileData.Create(const AData: TBytes; APlainTextLength, ACipherTextLength,
  ANullSegmentLength: Integer): TdxPDFType1FontFileData;

  function LastIndexOf(const AText, AValue: string): Integer;
  var
    I, AMin, AValueLength: Integer;
    ACharText: PChar;
  begin
    AValueLength := Length(AValue);
    if AValueLength = 0 then
      Exit(-1);
    I := Length(AText) - AValueLength;
    AMin := 0;
    ACharText := PChar(AText);
    while I >= AMin do
    begin
      if StrLComp(@ACharText[I], PChar(AValue), AValueLength) = 0 then
        Exit(I);
      Dec(I);
    end;
    Result := -1;
  end;

var
  ADiff, AClearToMarkIndex, ACipherEndIndex, APosition, ATextLength: Integer;
  AIndex, ANewPlainTextLength, ANewCipherTextLength, ANewNullSegmentLength: Integer;
  APatchedData: TBytes;
  ADataString: string;
  C: Char;
begin
  Result.FIsNull := False;
  Result.FData := AData;
  if Length(Result.FData) < APlainTextLength + ACipherTextLength + ANullSegmentLength then
    TdxPDFUtils.Abort;
  if IsPfbData(Result.FData) then
  begin
    ANewPlainTextLength := AData[2] + (AData[3] shl 8) + (AData[4] shl 16) + (AData[5] shl 24);
    APosition := ANewPlainTextLength + 8;
    ANewCipherTextLength := AData[APosition] + (AData[APosition + 1] shl 8) + (AData[APosition + 2] shl 16) +
      (AData[APosition + 3] shl 24);
    Inc(APosition, ANewCipherTextLength + 6);

    ATextLength := ANewPlainTextLength + ANewCipherTextLength;
    ANewNullSegmentLength := Min(AData[APosition] + (AData[APosition + 1] shl 8) + (AData[APosition + 2] shl 16) +
      (AData[APosition + 3] shl 24), Length(AData) - APosition - 4);

    SetLength(APatchedData, ATextLength + ANewNullSegmentLength);
    cxCopyData(@Result.FData[0], @APatchedData[0], 6, 0, ANewPlainTextLength);
    cxCopyData(@Result.FData[0], @APatchedData[0], ANewPlainTextLength + 12, ANewPlainTextLength, ANewCipherTextLength);
    cxCopyData(@Result.FData[0], @APatchedData[0], ATextLength + 18, ATextLength, ANewNullSegmentLength);

    APlainTextLength := ANewPlainTextLength;
    ACipherTextLength := ANewCipherTextLength;
    ANullSegmentLength := ANewNullSegmentLength;
    Result.FData := APatchedData;
  end;

  ADataString := TdxPDFUtils.BytesToStr(Result.FData);
  AIndex := Pos('eexec', ADataString);
  if AIndex > 0 then
  begin
    ANewPlainTextLength := AIndex + Length('eexec');
    ADiff := ANewPlainTextLength - APlainTextLength;
    if ADiff <> 0 then
    begin
      ACipherTextLength := ACipherTextLength - ADiff;
      APlainTextLength := ANewPlainTextLength;
    end;
    if ANullSegmentLength = 0 then
    begin
      AClearToMarkIndex := LastIndexOf(ADataString, 'cleartomark');
      if AClearToMarkIndex >= 0 then
      begin
        ACipherEndIndex := AClearToMarkIndex - 1;
        ANullSegmentLength := 12;

        while ACipherEndIndex >= 0 do
        begin
          C := ADataString[ACipherEndIndex];
          if (C <> '0') and not TdxPDFUtils.IsWhiteSpace(Byte(C)) then
            Break;
          Dec(ACipherEndIndex);
          Inc(ANullSegmentLength);
        end;
        ACipherTextLength := ACipherTextLength - ANullSegmentLength;
      end;
    end;
  end;
  Result.FPlainTextLength := APlainTextLength;
  Result.FCipherTextLength := ACipherTextLength;
  Result.FNullSegmentLength := ANullSegmentLength;
end;

class function TdxPDFType1FontFileData.IsPfbData(const AData: TBytes): Boolean;
begin
  Result := (Length(AData) >= 2) and (AData[0] = $80) and (AData[1] = 1);
end;

class function TdxPDFType1FontFileData.Parse(ADictionary: TdxPDFDictionary): TdxPDFType1FontFileData;
var
  AFontFileStream: TdxPDFStream;
  AFontFileDictionary: TdxPDFDictionary;
  ALength1, ALength2, ALength3: Integer;
begin
  AFontFileStream := ADictionary.GetStream(TdxPDFKeywords.FontFile);
  if AFontFileStream <> nil then
  begin
    AFontFileDictionary := AFontFileStream.Dictionary;
    ALength1 := AFontFileDictionary.GetInteger(TdxPDFKeywords.Length1);
    ALength2 := AFontFileDictionary.GetInteger(TdxPDFKeywords.Length2);
    ALength3 := AFontFileDictionary.GetInteger(TdxPDFKeywords.Length3);
    if not TdxPDFUtils.IsIntegerValid(ALength1) or not TdxPDFUtils.IsIntegerValid(ALength2) or
      not TdxPDFUtils.IsIntegerValid(ALength3) then
        TdxPDFUtils.Abort;
    Result := TdxPDFType1FontFileData.Create(AFontFileStream.UncompressedData, ALength1, ALength2, ALength3);
  end
  else
    Result.Reset;
end;

function TdxPDFType1FontFileData.IsNull: Boolean;
begin
  Result := FIsNull;
end;

procedure TdxPDFType1FontFileData.Reset;
begin
  FIsNull := True;
  SetLength(FData, 0);
end;

{ TdxPDFFontData }

constructor TdxPDFFontData.Create(AFont: TObject; AFirstChar: Integer; AWidths: TDoubleDynArray; AMissingWidth: Single);
begin
  FFont := AFont;
  FMetrics := (FFont as TdxPDFCustomFont).Metrics;
  FFirstChar := AFirstChar;
  SetLength(FWidths, 0);
  TdxPDFUtils.AddData(AWidths, FWidths);
  FMissingWidth := Max(AMissingWidth, 1);
end;

function TdxPDFFontData.GetCMap: TdxPDFCharacterMapping;
begin
  Result := (FFont as TdxPDFCustomFont).CMap;
end;

class function TdxPDFFontData.CreateFontData(AFont: TdxPDFBase): TdxPDFFontData;
var
  AFontDescriptor: TdxPDFCustomFontDescriptor;
  ASimpleFont: TdxPDFSimpleFont;
  AMissingWidth, ADefaultWidth: Single;
  AType0Font: TdxPDFType0Font;
  ASourceFont: TdxPDFCustomFont;
begin
  ASourceFont := AFont as TdxPDFCustomFont;
  AFontDescriptor := ASourceFont.FontDescriptor;

  if ASourceFont is TdxPDFSimpleFont then
    ASimpleFont := TdxPDFSimpleFont(AFont)
  else
    ASimpleFont := nil;
  if ASimpleFont <> nil then
  begin
    if AFontDescriptor = nil then
      AMissingWidth := 0
    else
    begin
      AMissingWidth := AFontDescriptor.MissingWidth;
      if AMissingWidth = 0 then
        AMissingWidth := AFontDescriptor.AvgWidth;
    end;
    Exit(TdxPDFFontData.Create(ASourceFont, ASimpleFont.FirstChar, ASimpleFont.Widths, AMissingWidth));
  end;

  if ASourceFont is TdxPDFType0Font then
    AType0Font := TdxPDFType0Font(AFont)
  else
    AType0Font := nil;

  if AType0Font = nil then
    TdxPDFUtils.Abort;
  ADefaultWidth := AType0Font.DefaultWidth;
  if (ADefaultWidth = 0) and (AFontDescriptor <> nil) then
    ADefaultWidth := AFontDescriptor.AvgWidth;
  Result := TdxPDFFontData.Create(ASourceFont, 0, AType0Font.Widths, ADefaultWidth);
end;

{ TdxPDFTextState }

constructor TdxPDFTextState.Create;
begin
  inherited Create;
  FTextLineMatrix := TdxPDFTransformationMatrix.Create;
  FTextMatrix := TdxPDFTransformationMatrix.Create;
  FTextSpaceMatrix := TdxPDFTransformationMatrix.Create;
  FHorizontalScaling := 100;
end;

destructor TdxPDFTextState.Destroy;
begin
  Font := nil;
  inherited Destroy;
end;

procedure TdxPDFTextState.Assign(ATextState: TdxPDFTextState);
begin
  CharacterSpacing := ATextState.CharacterSpacing;
  Font := ATextState.Font;
  FontSize := ATextState.FontSize;
  HorizontalScaling := ATextState.HorizontalScaling;
  Knockout := ATextState.Knockout;
  Leading := ATextState.Leading;
  RenderingMode := ATextState.RenderingMode;
  Rise := ATextState.Rise;
  WordSpacing := ATextState.WordSpacing;
end;

function TdxPDFTextState.GetAbsoluteFontSize: Double;
begin
  Result := Abs(FFontSize);
end;

function TdxPDFTextState.GetAbsoluteHorizontalScaling: Double;
begin
  Result := Abs(HorizontalScaling);
end;

function TdxPDFTextState.GetFontSizeFactor: Double;
begin
  Result := AbsoluteFontSize / 1000;
end;

function TdxPDFTextState.GetTextSpaceMatrix: TdxPDFTransformationMatrix;
begin
  FTextSpaceMatrix := TdxPDFTransformationMatrix.Create(FontSize * HorizontalScaling / 100, 0, 0, FontSize, 0, Rise);
  Result := FTextSpaceMatrix;
end;

procedure TdxPDFTextState.SetFont(const AValue: TdxPDFBase);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FFont));
end;

{ TdxPDFBaseTextUtils }

class function TdxPDFBaseTextUtils.IsCJK(AChar: WideChar): Boolean;

  function CharInRange(AChar, AMin, AMax: WideChar): Boolean;
  begin
    Result := (AChar >= AMin) and (AChar <= AMax);
  end;

const
  CJK_UNIFIED_IDOGRAPHS_START = #$4E00;
  CJK_UNIFIED_IDOGRAPHS_FINISH = #$9FFF;
  HIRAGANA_START = #$3040;
  HIRAGANA_FINISH = #$309F;
  KATAKANA_START = #$30A0;
  KATAKANA_FINISH = #$30FF;
  HANGUL_START = #$AC00;
  HANGUL_FINISH = #$D7A3;
begin
  Result := (AChar >= CJK_UNIFIED_IDOGRAPHS_START) and (AChar <= CJK_UNIFIED_IDOGRAPHS_FINISH) or
    (AChar >= HIRAGANA_START) and (AChar <= HIRAGANA_FINISH) or
    (AChar >= KATAKANA_START) and (AChar <= KATAKANA_FINISH) or
    (AChar >= HANGUL_START) and (AChar <= HANGUL_FINISH);
end;

class function TdxPDFBaseTextUtils.IsSeparator(const S: string): Boolean;
const
  Rule = ',.!@#$%^&*()+_=`\{\}\[\];:""<>\\/?\|-';
begin
  Result := Length(S) > 0;
  if Result then
    Result := Pos(S[1], Rule) > 0;
end;

class function TdxPDFBaseTextUtils.IsWhiteSpace(const S: string): Boolean;
begin
  Result := Length(S) > 0;
  if Result then
    Result := dxIsWhiteSpace(S[1]);
end;

class function TdxPDFBaseTextUtils.IsWrapSymbol(const S: string): Boolean;
var
  I: Integer;
  AWordWrappers: string;
begin
  AWordWrappers := Char($2010) + Char($AD) + Char($2D);
  Result := False;
  for I := 1 to Length(S) do
  begin
    Result := Pos(S[I], AWordWrappers) > 0;
    if Result then
      Exit;
  end;
end;

class function TdxPDFBaseTextUtils.HasCJKMarker(const S: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) do
  begin
    Result := IsCJK(S[I]);
    if Result then
      Exit;
  end;
end;

class function TdxPDFBaseTextUtils.HasFlag(AFlags, AFontStyle: TdxGPFontStyle): Boolean;
begin
  Result := (Integer(AFlags) and Integer(AFontStyle)) <> 0;
end;

class function TdxPDFBaseTextUtils.HasRTLMarker(const S: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) do
  begin
    Result := dxBiDiCharacterClasses.GetCharacterClass(S[I]) = bccRTL;
    if Result then
      Exit;
  end;
end;

class procedure TdxPDFBaseTextUtils.AddRange(const ARange: TdxPDFPageTextRange; var ARanges: TdxPDFPageTextRanges);
var
  L: Integer;
begin
  L := Length(ARanges);
  SetLength(ARanges, L + 1);
  ARanges[L] := ARange;
end;

class function TdxPDFBaseTextUtils.RotatePoint(const APoint: TdxPointF; AAngle: Single): TdxPointF;
begin
  Result := TdxPDFUtils.RotatePoint(APoint, AAngle);
end;

class function TdxPDFBaseTextUtils.GetOrientedDistance(const AFirst, ASecond: TdxPointF; AAngle: Single): Single;
begin
  Result := TdxPDFUtils.OrientedDistance(AFirst, ASecond, AAngle);
end;

class function TdxPDFBaseTextUtils.EndsWith(const S, AEndsWith: string): Boolean;
begin
  Result := TdxPDFUtils.EndsWith(S, AEndsWith);
end;

class function TdxPDFBaseTextUtils.StartsWith(const S, AStartsWith: string): Boolean;
begin
  Result := TdxPDFUtils.StartsWith(S, AStartsWith);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxgBiDiBrackets := nil;
  dxgBiDiCharacterClasses := nil;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(dxgBiDiCharacterClasses);
  FreeAndNil(dxgBiDiBrackets);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

