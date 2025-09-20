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

unit dxPDFRecognizedObject;

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Graphics, Classes, Generics.Defaults, Generics.Collections, cxGeometry, dxPDFBase, dxPDFTypes, dxPDFText;

const
  // HitTests bits
  hcImage  = 2;

type
  TdxPDFRecognitionObject = (rmAnnotations, rmImages, rmText, rmExcludeField); // for internal use
  TdxPDFRecognitionObjects = set of TdxPDFRecognitionObject; // for internal use

  { TdxPDFRecognizedObject }

  TdxPDFRecognizedObject = class(TdxPDFReferencedObject, IUnknown)
  protected
    function GetHitCode: Integer; virtual; abstract; 

    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
  public
    property HitCode: Integer read GetHitCode;
  end;

  { TdxPDFRecognizedObjectList<T> }

  TdxPDFRecognizedObjectList<T: TdxPDFRecognizedObject> = class(TdxPDFObjectList<T>);

  { TdxPDFImage }

  TdxPDFImage = class(TdxPDFRecognizedObject)
  strict private
    FBounds: TdxRectF;
    FBitmap: Graphics.TBitmap;
    FDocumentImage: TdxPDFReferencedObject;

    function GetBitmap: Graphics.TBitmap;
    function GetGUID: string;
    procedure SetDocumentImage(const AValue: TdxPDFReferencedObject);
  protected
    function GetHitCode: Integer; override; 
    procedure SetBounds(const ABounds: TdxRectF);

    property Bounds: TdxRectF read FBounds;
    property DocumentImage: TdxPDFReferencedObject read FDocumentImage write SetDocumentImage;
    property GUID: string read GetGUID;
  public
    constructor Create;
    destructor Destroy; override;

    property Bitmap: Graphics.TBitmap read GetBitmap;
  end;
  { TdxPDFImageList }

  TdxPDFImageList = class(TdxPDFRecognizedObjectList<TdxPDFImage>)
  protected
    function Clone: TdxPDFImageList;
  end;

  { TdxPDFTextObject }

  TdxPDFTextObject = class(TdxPDFRecognizedObject)
  strict protected
    FBounds: TdxPDFOrientedRect;
    FText: string;
  protected
    function GetHitCode: Integer; override;
    function GetText: string; virtual;

    function GetBounds: TdxPDFOrientedRect; virtual;
    function IsTextEmpty: Boolean;

    property Bounds: TdxPDFOrientedRect read GetBounds;
  public
    constructor Create; overload;
    constructor Create(const ABounds: TdxPDFOrientedRect; const AText: string); overload;

    property Text: string read GetText;
  end;
  TdxPDFTextObjectList<T: TdxPDFTextObject> = class(TdxPDFRecognizedObjectList<T>);

  { TdxPDFTextWordPart }

  TdxPDFTextWordPart = class(TdxPDFTextObject)
  strict private
    FCharacters: TdxPDFTextCharacters;
    FWordEnded: Boolean;
    FWordIndex: Integer;
    FWrapOffset: Integer;

    function GetEndWordPosition: Integer;
    function GetNextWrapOffset: Integer;
  protected
    function GetText: string; override;

    property EndWordPosition: Integer read GetEndWordPosition;
    property NextWrapOffset: Integer read GetNextWrapOffset;
    property WordEnded: Boolean read FWordEnded;
    property WrapOffset: Integer read FWrapOffset;
  public
    constructor Create(const ABounds: TdxPDFOrientedRect; const ACharacters: TdxPDFTextCharacters;
      AWrapOffset: Integer; AWordEnded: Boolean);
    destructor Destroy; override;

    function IsEmpty: Boolean;
    function Same(AWordIndex, AOffset: Integer): Boolean;

    property Characters: TdxPDFTextCharacters read FCharacters;
    property WordIndex: Integer read FWordIndex write FWordIndex;
  end;

  { TdxPDFTextWordPartList }

  TdxPDFTextWordPartList = class(TdxPDFTextObjectList<TdxPDFTextWordPart>)
  strict private
  public
  end;

  { TdxPDFTextWord }

  TdxPDFTextWord = class(TdxPDFTextObject)
  strict private
    FBoundsList: TdxPDFOrientedRectList;
    FCharacters: TdxPDFTextCharacters;
    FIndex: Integer;
    FWordPartList: TdxPDFTextWordPartList;

    function GetCharacters: TdxPDFTextCharacters;
    function GetBoundsList: TdxPDFOrientedRectList;
    procedure SetIndex(const AValue: Integer);
  protected
    function GetBounds: TdxPDFOrientedRect; override;
    function GetText: string; override;
  protected
    property BoundsList: TdxPDFOrientedRectList read GetBoundsList;
    property Characters: TdxPDFTextCharacters read GetCharacters;
    property PartList: TdxPDFTextWordPartList read FWordPartList;
  public
    constructor Create(AParts: TdxPDFTextWordPartList);
    destructor Destroy; override;

    function Overlap(AWord: TdxPDFTextWord): Boolean;

    property Index: Integer read FIndex write SetIndex;
  end;
  TdxPDFTextWordList = class(TdxPDFTextObjectList<TdxPDFTextWord>)
  end;

  { TdxPDFTextLine }

  TdxPDFTextLine = class(TdxPDFTextObject)
  strict private
    FWordList: TdxPDFTextWordList;
    FWordPartList: TdxPDFTextWordPartList;
  protected
    function GetBounds: TdxPDFOrientedRect; override;
    function GetHitCode: Integer; override;
    function GetText: string; override;

    function GetLineRange: TdxPDFPageTextRange;
    function GetPosition(const APosition: TdxPDFPagePoint): TdxPDFTextPosition; overload;
    function GetPosition(APageIndex: Integer; const P: TdxPointF): TdxPDFTextPosition; overload;
    function GetRange(APageIndex: Integer; const R: TdxRectF): TdxPDFPageTextRange;

    function GetHighlight(AStartWordIndex, AStartOffset, AEndWordIndex, AEndOffset: Integer;
      ASplitBounds: Boolean; ARectIndex: Integer): TdxPDFOrientedRect; overload;
    function GetHighlight(AStartWordIndex, AStartOffset: Integer;
      ASplitBounds: Boolean; ARectIndex: Integer): TdxPDFOrientedRect; overload;
    function GetHighlights(AStartWordIndex, AStartOffset, AEndWordIndex, AEndOffset: Integer;
      ASplitBounds: Boolean): TdxPDFOrientedRectList; overload;
    function GetHighlights(AStartWordIndex, AStartOffset: Integer;
      ASplitBounds: Boolean): TdxPDFOrientedRectList; overload;

    function PositionInLine(AWordIndex: Integer; AOffset: Integer): Boolean;
    procedure PopulateWordList(AWordList: TdxPDFTextWordList);
    procedure PopulateWordPartList(AWordPartList: TdxPDFTextWordPartList);
  protected
    property WordList: TdxPDFTextWordList read FWordList;
    property WordPartList: TdxPDFTextWordPartList read FWordPartList;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { TdxPDFTextLineList }

  TdxPDFTextLineList = class(TdxPDFTextObjectList<TdxPDFTextLine>)
  strict private
    FWordList: TdxPDFTextWordList;
    //
    function CreateWordList: TdxPDFTextWordList;
    function GetWordList: TdxPDFTextWordList;
  protected
    property WordList: TdxPDFTextWordList read GetWordList;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function Clone: TdxPDFTextLineList;
    function Find(const APosition: TdxPDFPagePoint; const ATextExpansionFactor: TdxPointF; out ALine: TdxPDFTextLine): Boolean;
    function FindStartTextPosition(const APosition: TdxPDFPagePoint; const ATextExpansionFactor: TdxPointF): TdxPDFTextPosition;
  end;

  { TdxPDFTextBlock }

  TdxPDFTextBlock = class
  strict private
    FAngle: Single;
    FCharacters: TdxPDFTextCharacters;
    FCharacterSpacing: Single;
    FFontData: TdxPDFFontData;
    FFontSize: Double;
    FMinSpaceWidth: Double;
    FMaxSpaceWidth: Double;
    FBounds: TdxPdfRectangle;
    function GetFontMatrix: TdxPDFTransformationMatrix;
    procedure InitializeCharacters(const ATextData: TdxPDFStringData; const ATransFormMatrix, ATextSpaceMatrix, ATextToUserMatrix: TdxPDFTransformationMatrix);
  public
    constructor Create(const ATextData: TdxPDFStringData; AFontData: TdxPDFFontData; AGraphicsState: TObject);
    destructor Destroy; override;

    function CalculateCharacterWidth(ACharacter: Integer): Single;
    function GetActualCharacter(const ACharacter: TBytes): string;

    property Angle: Single read FAngle;
    property Characters: TdxPDFTextCharacters read FCharacters;
    property CharacterSpacing: Single read FCharacterSpacing;
    property MinSpaceWidth: Double read FMinSpaceWidth;
    property MaxSpaceWidth: Double read FMaxSpaceWidth;
    property FontData: TdxPDFFontData read FFontData;
    property FontSize: Double read FFontSize;
    property Bounds: TdxPdfRectangle read FBounds;
  end;

  { TdxPDFTextParserState }

  TdxPDFTextParserState = class
  strict private
    FActualRTL: Boolean;
    FBlocks: TList<TdxPDFTextBlock>;
    FPageCropBox: TdxRectF;
    FPreviousCharacterBlock: TdxPDFTextBlock;
    FCurrentCharacterBlock: TdxPDFTextBlock;
    FPreviousCharacter: TdxPDFTextCharacter;
    FCurrentCharacter: TdxPDFTextCharacter;
    FCurrentWordLeftBoundary: TdxPointF;
    FCurrentWordRightBoundary: TdxPointF;
    FCharacterIndex: Integer;
    FBlockIndex: Integer;
    FIsFinished: Boolean;
    FIsRTL: Boolean;
    FIsLineStart: Boolean;
    FIsSpace: Boolean;
    FIsSeparator: Boolean;
    FIsWrap: Boolean;
    FIsCJKWord: Boolean;
    FCurrentDistancesCount: Integer;
    FCurrentDistancesSum: Double;

    function IsIndex: Boolean;
    function IsNewWord: Boolean;
    function IsNewLine: Boolean;
  public
    constructor Create(ABlocks: TList<TdxPDFTextBlock>; APageCropBox: TdxRectF);

    function MoveToNextCharacter: Boolean;
    function MoveToNextBlock: Boolean;
    procedure MoveNext;
    procedure ClearDistancesCounter;

    property CurrentCharacterBlock: TdxPDFTextBlock read FCurrentCharacterBlock;
    property CurrentCharacter: TdxPDFTextCharacter read FCurrentCharacter;
    property CurrentWordLeftBoundary: TdxPointF read FCurrentWordLeftBoundary write FCurrentWordLeftBoundary;
    property CurrentWordRightBoundary: TdxPointF read FCurrentWordRightBoundary write FCurrentWordRightBoundary;
    property PreviousCharacter: TdxPDFTextCharacter read FPreviousCharacter;
    property PreviousCharacterBlock: TdxPDFTextBlock read FPreviousCharacterBlock;
    property IsCJKWord: Boolean read FIsCJKWord;
    property IsLineStart: Boolean read FIsLineStart;
    property IsFinished: Boolean read FIsFinished;
    property IsRTL: Boolean read FIsRTL;
    property IsSeparator: Boolean read FIsSeparator;
    property IsSpace: Boolean read FIsSpace;
    property IsWrap: Boolean read FIsWrap;
    property PageCropBox: TdxRectF read FPageCropBox;

  end;

  { TdxPDFPageWordBuilder }

  TdxPDFPageWordBuilder = class
  strict private
    FParserState: TdxPDFTextParserState;
    FCharacters: TdxPDFTextCharacters;
    FWordPartList: TdxPDFTextWordPartList;
    FWordMinX: Single;
    FWordMaxX: Single;
    FWordMinY: Single;
    FWordMaxY: Single;
    FWordAngle: Single;
    FWrapOffset: Integer;
  protected
    function BuildWord(ALineXOffset: Single): TdxPDFTextWord;
    procedure ClearWordPartData;
    procedure ProcessChar;
  public
    constructor Create(AParserState: TdxPDFTextParserState);
    destructor Destroy; override;
  end;

  { TdxPDFPageTextLineBuilder }

  TdxPDFPageTextLineBuilder = class
  strict private
    FParserState: TdxPDFTextParserState;
    FWordBuilder: TdxPDFPageWordBuilder;
    FWordIndex: Integer;
    FWordList: TdxPDFTextWordList;
    FWordPartList: TdxPDFTextWordPartList;
    FLineXOffset: Single;
    function OverlapsWithPreviousWords(AWord: TdxPDFTextWord): Boolean;
    procedure AddTextLine(ATextLines: TdxPDFTextLineList; AWordList: TdxPDFTextWordList; APartList: TdxPDFTextWordPartList);
    procedure Clear;
    procedure EnumerateWordsAndFillParts;
    procedure RecreateWordList;
    procedure RecreateWordPartList;
  public
    constructor Create(AParserState: TdxPDFTextParserState);
    destructor Destroy; override;

    procedure Populate(ATextLines: TdxPDFTextLineList);
  end;

  { TdxPDFRecognizedTextUtils }

  TdxPDFRecognizedTextUtils = class(TdxPDFBaseTextUtils)
  strict protected
    class procedure Append(ABuilder: TdxBiDiStringBuilder; const AStart, AEnd: TdxPDFPageTextPosition; AWordPart: TdxPDFTextWordPart); overload;
    class procedure Append(ABuilder: TdxBiDiStringBuilder; const AStart, AEnd: TdxPDFPageTextPosition; ALine: TdxPDFTextLine); overload;
    class procedure Append(ABuilder: TdxBiDiStringBuilder; const AStart, AEnd: TdxPDFPageTextPosition; ALines: TdxPDFTextLineList); overload;
    class procedure AppendWordPart(ABuilder: TdxBiDiStringBuilder; APart: TdxPDFTextWordPart); overload;
    class procedure AppendWordPart(ABuilder: TdxBiDiStringBuilder; APart: TdxPDFTextWordPart;  AStartOffset: Integer); overload;
    class procedure AppendWordPart(ABuilder: TdxBiDiStringBuilder; APart: TdxPDFTextWordPart;   AStartOffset, AEndOffset: Integer); overload;
  public
    class function ConvertToString(const AStart, AEnd: TdxPDFPageTextPosition; AWordPart: TdxPDFTextWordPart): string; overload;
    class function ConvertToString(const AStart, AEnd: TdxPDFPageTextPosition; ALine: TdxPDFTextLine): string; overload;
    class function ConvertToString(const AStart, AEnd: TdxPDFPageTextPosition; ALines: TdxPDFTextLineList): string; overload;
  end;

implementation

uses
  Math, dxCore, dxPDFCore, dxPDFCharacterMapping, dxPDFFont, dxPDFFontEncoding, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFRecognizedObject';

type
  TdxPDFDocumentImageAccess = class(TdxPDFDocumentImage);

  { TdxPDFWordPartComparer }

  TdxPDFWordPartComparer = class
    class function GetRotatedTopLeft(const AOrientedRect: TdxPDFOrientedRect): TdxPointF; static;
    class function CompareOrientedRect(const ALeft, ARight: TdxPDFOrientedRect): Integer; static;
    class function CompareWord(AWord1, AWord2: Pointer): Integer; static;
    class function CompareWordPart(AWord1, AWord2: Pointer): Integer; static;
  end;


{ TdxPDFWordPartComparer }

class function TdxPDFWordPartComparer.GetRotatedTopLeft(const AOrientedRect: TdxPDFOrientedRect): TdxPointF;
begin
  Result := TdxPDFRecognizedTextUtils.RotatePoint(AOrientedRect.TopLeft, -AOrientedRect.Angle); 
end;

class function TdxPDFWordPartComparer.CompareOrientedRect(const ALeft, ARight: TdxPDFOrientedRect): Integer;
begin
  Result := IfThen(GetRotatedTopLeft(ALeft).X < GetRotatedTopLeft(ARight).X, -1, 1);
end;

class function TdxPDFWordPartComparer.CompareWord(AWord1, AWord2: Pointer): Integer;
var
  ALeft, ARight: TdxPDFTextWord;
begin
  Result := 0;
  if AWord1 = AWord2 then
    Exit;
    ALeft := TdxPDFTextWord(AWord1);
    ARight := TdxPDFTextWord(AWord2);
  Result := CompareOrientedRect(ALeft.BoundsList[0], ARight.BoundsList[0]);
end;

class function TdxPDFWordPartComparer.CompareWordPart(AWord1, AWord2: Pointer): Integer;
var
  ALeft, ARight: TdxPDFTextWordPart;
begin
  Result := 0;
  if AWord1 = AWord2 then
    Exit;
    ALeft := TdxPDFTextWordPart(AWord1);
    ARight := TdxPDFTextWordPart(AWord2);
  Result := CompareOrientedRect(ALeft.Bounds, ARight.Bounds);
end;

{ TdxPDFRecognizedObject }

function TdxPDFRecognizedObject._AddRef: Integer; stdcall;
begin
  Result := -1;
end;

function TdxPDFRecognizedObject._Release: Integer; stdcall;
begin
  Result := -1;
end;

function TdxPDFRecognizedObject.QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

{ TdxPDFImage }

constructor TdxPDFImage.Create;
begin
  inherited Create;
  FBounds := dxNullRectF;
  FBitmap := nil;
  DocumentImage := nil;
end;

destructor TdxPDFImage.Destroy;
begin
  DocumentImage := nil;
  FreeAndNil(FBitmap);
  inherited Destroy;
end;

function TdxPDFImage.GetHitCode: Integer;
begin
  Result := hcImage;
end;

procedure TdxPDFImage.SetBounds(const ABounds: TdxRectF);
begin
  FBounds := ABounds;
end;

function TdxPDFImage.GetBitmap: Graphics.TBitmap;
begin
  if FBitmap = nil then
    FBitmap := TdxPDFDocumentImageAccess(DocumentImage as TdxPDFDocumentImage).GetAsBitmap;
  Result := FBitmap;
end;

function TdxPDFImage.GetGUID: string;
begin
  Result := (FDocumentImage as TdxPDFDocumentImage).GUID;
end;

procedure TdxPDFImage.SetDocumentImage(const AValue: TdxPDFReferencedObject);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDocumentImage));
end;

{ TdxPDFImageList }

function TdxPDFImageList.Clone: TdxPDFImageList;
var
  I: Integer;
begin
  Result := TdxPDFImageList.Create;
  for I := 0 to Count - 1 do
    Result.Add(Self[I]);
end;

{ TdxPDFTextObject }

constructor TdxPDFTextObject.Create;
begin
  Create(TdxPDFOrientedRect.Create, '');
end;

constructor TdxPDFTextObject.Create(const ABounds: TdxPDFOrientedRect; const AText: string);
begin
  inherited Create;
  FBounds := ABounds;
  FText := AText;
end;

function TdxPDFTextObject.GetHitCode: Integer;
begin
  Result := hcText;
end;

function TdxPDFTextObject.GetText: string;
begin
  Result := FText;
end;

function TdxPDFTextObject.GetBounds: TdxPDFOrientedRect;
begin
  Result := FBounds;
end;

function TdxPDFTextObject.IsTextEmpty: Boolean;
begin
  Result := FText = '';
end;

{ TdxPDFTextWordPart }

constructor TdxPDFTextWordPart.Create(const ABounds: TdxPDFOrientedRect; const ACharacters: TdxPDFTextCharacters;
  AWrapOffset: Integer; AWordEnded: Boolean);
begin
  inherited Create(ABounds, Text);
  FCharacters := TdxPDFTextCharacters.Create;
  FCharacters.AddRange(ACharacters);
  FWrapOffset := AWrapOffset;
  FWordEnded := AWordEnded;
end;

destructor TdxPDFTextWordPart.Destroy;
begin
  FreeAndNil(FCharacters);
  inherited Destroy;
end;

function TdxPDFTextWordPart.GetText: string;
var
  I: Integer;
  ABuilder: TdxBiDiStringBuilder;
begin
  if IsTextEmpty and (FCharacters <> nil) then
  begin
    ABuilder := TdxBiDiStringBuilder.Create;
    try
      for I := 0 to FCharacters.Count - 1 do
        ABuilder.Append(FCharacters[I].Text);
      FText := ABuilder.EndCurrentLineAndGetString;
    finally
      ABuilder.Free;
    end;
  end;
  Result := FText;
end;

function TdxPDFTextWordPart.IsEmpty: Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to FCharacters.Count - 1 do
  begin
    Result := Length(FCharacters[I].Text) = 0;
    if not Result then
      Break;
  end;
end;

function TdxPDFTextWordPart.Same(AWordIndex, AOffset: Integer): Boolean;
begin
  Result := (WordIndex = AWordIndex) and (WrapOffset <= AOffset) and (AOffset <= NextWrapOffset);
end;

function TdxPDFTextWordPart.GetNextWrapOffset: Integer;
begin
  Result := WrapOffset + Length(Text);
end;

function TdxPDFTextWordPart.GetEndWordPosition: Integer;
var
  APosition: Integer;
begin
  APosition := NextWrapOffset;
  if WordEnded then
    Result := APosition
  else
    Result := APosition - 1;
end;

{ TdxPDFTextWord }

constructor TdxPDFTextWord.Create(AParts: TdxPDFTextWordPartList);
var
  APart: TdxPDFTextWordPart;
begin
  inherited Create;
  FCharacters := nil;
  FWordPartList := TdxPDFTextWordPartList.Create;
  for APart in AParts do
    FWordPartList.Add(TdxPDFTextWordPart.Create(APart.Bounds, APart.Characters, APart.WrapOffset, APart.WordEnded));
end;

destructor TdxPDFTextWord.Destroy;
begin
  FreeAndNil(FCharacters);
  FreeAndNil(FWordPartList);
  FreeAndNil(FBoundsList);
  inherited Destroy;
end;

function TdxPDFTextWord.Overlap(AWord: TdxPDFTextWord): Boolean;
var
  I, L: Integer;
begin
  L := Characters.Count;
  Result := L = AWord.Characters.Count;
  if Result then
    for I := 0 to L - 1 do
    begin
      Result := Characters[I].Text = AWord.Characters[I].Text;
      if not Result then
        Break;
    end;
  if Result then
    for I := 0 to BoundsList.Count - 1 do
    begin
      Result := BoundsList[I].Overlap(AWord.BoundsList[I]);
      if not Result then
        Break;
    end;
end;

function TdxPDFTextWord.GetBounds: TdxPDFOrientedRect;
var
  R: TdxPDFOrientedRect;
  ABounds: TdxRectF;
begin
  ABounds := dxNullRectF;
  for R in BoundsList do
    ABounds := cxRectUnion(ABounds, R.Rect);
  Result := TdxPDFOrientedRect.Create(ABounds, 0);
end;

function TdxPDFTextWord.GetText: string;
var
  APartCount, I: Integer;
  APartText: string;
begin
  if IsTextEmpty then
  begin
    APartCount := FWordPartList.Count - 1;
    for I := 0 to APartCount - 1 do
    begin
      APartText := FWordPartList[I].Text;
      FText := FText + Copy(APartText, 1, Length(APartText) - 1);
    end;
    FText := FText + FWordPartList[APartCount].Text;
  end;
  Result := FText;
end;

function TdxPDFTextWord.GetCharacters: TdxPDFTextCharacters;
var
  I: Integer;
begin
  if FCharacters = nil then
  begin
    FCharacters := TdxPDFTextCharacters.Create;
    for I := 0 to FWordPartList.Count - 1 do
      FCharacters.AddRange(FWordPartList[I].Characters);
  end;
  Result := FCharacters;
end;

function TdxPDFTextWord.GetBoundsList: TdxPDFOrientedRectList;
var
  APart: TdxPDFTextWordPart;
begin
  if FBoundsList = nil then
  begin
    FBoundsList := TdxPDFOrientedRectList.Create;
    for APart in FWordPartList do
      FBoundsList.Add(APart.Bounds);
  end;
  Result := FBoundsList;
end;

procedure TdxPDFTextWord.SetIndex(const AValue: Integer);
var
  APart: TdxPDFTextWordPart;
begin
  FIndex := AValue;
  for APart in FWordPartList do
    APart.WordIndex := FIndex;
end;


{ TdxPDFTextLine }

constructor TdxPDFTextLine.Create;
begin
  inherited Create;
  FWordList := TdxPDFTextWordList.Create;
  FWordPartList := TdxPDFTextWordPartList.Create;
end;

destructor TdxPDFTextLine.Destroy;
begin
  FreeAndNil(FWordPartList);
  FreeAndNil(FWordList);
  inherited Destroy;
end;

function TdxPDFTextLine.GetBounds: TdxPDFOrientedRect;
var
  ARectList: TdxPDFOrientedRectList;
begin
  if not FBounds.IsValid then
  begin
    ARectList := GetHighlights(-1, 0, FWordPartList.Count - 1, -1, False);
    try
      FBounds := ARectList[0];
    finally
      ARectList.Free;
    end;
  end;
  Result := FBounds;
end;

function TdxPDFTextLine.GetHitCode: Integer;
begin
  Result := hcText;
end;

function TdxPDFTextLine.GetText: string;
var
  ARange: TdxPDFPageTextRange;
begin
  if IsTextEmpty then
  begin
    ARange := GetLineRange;
    FText := TdxPDFRecognizedTextUtils.ConvertToString(ARange.StartPosition, ARange.EndPosition, Self);
  end;
  Result := inherited GetText;
end;

function TdxPDFTextLine.GetLineRange: TdxPDFPageTextRange;
begin
  if WordPartList.Count > 0 then
    Result := TdxPDFPageTextRange.Create(-1, WordPartList[0].WordIndex, 0, WordPartList.Last.WordIndex,
      WordPartList.Last.Characters.Count)
  else
    Result := TdxPDFPageTextRange.Invalid;
end;

function TdxPDFTextLine.GetPosition(const APosition: TdxPDFPagePoint): TdxPDFTextPosition;
begin
  Result := GetPosition(APosition.PageIndex, APosition.Point)
end;

function TdxPDFTextLine.GetPosition(APageIndex: Integer; const P: TdxPointF): TdxPDFTextPosition;
var
  J, I: Integer;
  AAngle, ARotatedLeft, X: Single;
  ABounds, R: TdxPDFOrientedRect;
  APart, ANearestPart: TdxPDFTextWordPart;
begin
  if (FWordPartList = nil) or (FWordPartList.Count < 1) then
    Exit(TdxPDFTextPosition.Invalid);

  ANearestPart := nil;
  AAngle := TdxPDFTextWordPart(FWordPartList[0]).Bounds.Angle;
  for I := 0 to FWordPartList.Count - 1 do
  begin
    APart := FWordPartList[I];
    ARotatedLeft := TdxPDFRecognizedTextUtils.RotatePoint(APart.Bounds.TopLeft, -AAngle).X;
    X := TdxPDFRecognizedTextUtils.RotatePoint(P, -AAngle).X;
    if ARotatedLeft + APart.Bounds.Width < X then
      ANearestPart := APart
    else
    begin
      if ANearestPart = nil then
        R := TdxPDFOrientedRect.Create
      else
        R := ANearestPart.Bounds;
      if (ANearestPart = nil) or APart.Bounds.PtInRect(P) or
        (Abs(TdxPDFRecognizedTextUtils.RotatePoint(R.TopLeft, -AAngle).X + R.Width - X) >= Abs(ARotatedLeft - X)) then
        ANearestPart := APart;

      for J := 0 to ANearestPart.Characters.Count - 1 do
      begin
        ABounds := ANearestPart.Characters[J].Bounds;
        if TdxPDFRecognizedTextUtils.RotatePoint(ABounds.TopLeft, -AAngle).X + ABounds.Width / 2 >= TdxPDFRecognizedTextUtils.RotatePoint(P, -AAngle).X then
          Exit(TdxPDFTextPosition.Create(APageIndex, ANearestPart.WordIndex, ANearestPart.WrapOffset + J));
      end;
    end;
  end;
  Result := TdxPDFTextPosition.Create(APageIndex, ANearestPart.WordIndex, ANearestPart.WrapOffset + ANearestPart.Characters.Count);
end;

function TdxPDFTextLine.GetRange(APageIndex: Integer; const R: TdxRectF): TdxPDFPageTextRange;
var
  I: Integer;
  APart: TdxPDFTextWordPart;
  AStart, AEnd: TdxPDFPageTextPosition;
begin
  AStart := TdxPDFPageTextPosition.Invalid;
  AEnd := TdxPDFPageTextPosition.Invalid;
  Result := TdxPDFPageTextRange.Invalid;
  for APart in FWordPartList do
    for I := 0 to APart.Characters.Count - 1 do
    begin
      if TdxPDFUtils.Intersects(R, APart.Characters[I].Bounds.RotatedRect) then
      begin
        if not AStart.IsValid then
          AStart := TdxPDFPageTextPosition.Create(APart.WordIndex, I);
        AEnd := TdxPDFPageTextPosition.Create(APart.WordIndex, I + 1);
      end;
    end;
  if AStart.IsValid and AEnd.IsValid then
    Result := TdxPDFPageTextRange.Create(APageIndex, AStart, AEnd);
end;

function TdxPDFTextLine.GetHighlight(AStartWordIndex, AStartOffset, AEndWordIndex, AEndOffset: Integer;
  ASplitBounds: Boolean; ARectIndex: Integer): TdxPDFOrientedRect;
var
  AList: TdxPDFOrientedRectList;
begin
  AList := GetHighlights(AStartWordIndex, AStartOffset, AEndWordIndex, AEndOffset, ASplitBounds);
  try
    Result := AList[ARectIndex];
  finally
    AList.Free;
  end;
end;

function TdxPDFTextLine.GetHighlight(AStartWordIndex, AStartOffset: Integer; ASplitBounds: Boolean;
  ARectIndex: Integer): TdxPDFOrientedRect;
begin
  Result := GetHighlight(AStartWordIndex, AStartOffset, FWordPartList.Count - 1, -1, ASplitBounds, ARectIndex);
end;

function TdxPDFTextLine.GetHighlights(AStartWordIndex, AStartOffset, AEndWordIndex, AEndOffset: Integer;
  ASplitBounds: Boolean): TdxPDFOrientedRectList;
var
  AStartCharacters: TdxPDFTextCharacters;
  I, AStart, AEnd, J: Integer;
  AStartOnEndOfWord: Boolean;
  AStartCharRect, ACharRect: TdxPDFOrientedRect;
  AAngle, ALeft, ATop, ARight, ABottom: Single;
  ATopLeft, ACharTopLeft: TdxPointF;
  AStoredStartOffset: Integer;
begin
  if AStartWordIndex = -1 then
    AStartCharacters := FWordPartList[0].Characters
  else
    AStartCharacters := FWordPartList[AStartWordIndex].Characters;

  if AStartOffset > AStartCharacters.Count then
    Exit(nil);
  Result := TdxPDFOrientedRectList.Create;

  AStoredStartOffset := AStartOffset;
  AStartOnEndOfWord := AStartOffset = AStartCharacters.Count;
  if AStartOnEndOfWord then
    Dec(AStartOffset);
  AStartCharRect := AStartCharacters[AStartOffset].Bounds;

  AAngle := AStartCharRect.Angle;
  ATopLeft := TdxPDFRecognizedTextUtils.RotatePoint(AStartCharRect.TopLeft, -AAngle);
  ALeft := IfThen(AStartOnEndOfWord, ATopLeft.X + AStartCharRect.Width, ATopLeft.X);
  ATop := ATopLeft.Y;
  ARight := ALeft;
  ABottom := ATop - AStartCharRect.Height;

  if AStartWordIndex = -1 then
    Inc(AStartWordIndex);
  for I := AStartWordIndex to AEndWordIndex do
  begin
    AStart := IfThen(I = AStartWordIndex, AStoredStartOffset, 0);
    AEnd := IfThen((I = AEndWordIndex) and (AEndOffset <> -1), AEndOffset, FWordPartList[I].Characters.Count);

    if ASplitBounds and ((AStart = 0) or (AStart < AEnd)) then
    begin
      ACharRect := FWordPartList[I].Characters[AStart].Bounds;
      ACharTopLeft := TdxPDFRecognizedTextUtils.RotatePoint(ACharRect.TopLeft, -AAngle);
      if ACharTopLeft.X > ARight + 2 * ACharRect.Width then
      begin
        Result.Add(TdxPDFOrientedRect.Create(TdxPDFRecognizedTextUtils.RotatePoint(dxPointF(ALeft, ATop), AAngle),
          ARight - ALeft, ATop - ABottom, AAngle));
        ALeft := ACharTopLeft.X;
        ATop := ACharTopLeft.Y;
        ARight := ALeft;
        ABottom := ATop - ACharRect.Height;
      end;
    end;
    if AEnd = 0 then
      ARight := TdxPDFUtils.Max(ARight, TdxPDFRecognizedTextUtils.RotatePoint(FWordPartList[I].Characters[0].Bounds.TopLeft, -AAngle).X)
    else
      for J := AStart to AEnd - 1 do
      begin
        ACharRect := FWordPartList[I].Characters[J].Bounds;
        ACharTopLeft := TdxPDFRecognizedTextUtils.RotatePoint(ACharRect.TopLeft, -AAngle);
        ALeft := TdxPDFUtils.Min(ACharTopLeft.X, ALeft);
        ATop := TdxPDFUtils.Max(ACharTopLeft.Y, ATop);
        ARight := TdxPDFUtils.Max(ARight, ACharTopLeft.X + ACharRect.Width);
        ABottom := TdxPDFUtils.Min(ABottom, ACharTopLeft.Y - ACharRect.Height);
      end;
  end;
  Result.Add(TdxPDFOrientedRect.Create(TdxPDFRecognizedTextUtils.RotatePoint(dxPointF(ALeft, ATop), AAngle),
    ARight - ALeft, ATop - ABottom, AAngle));
end;

function TdxPDFTextLine.GetHighlights(AStartWordIndex, AStartOffset: Integer;
  ASplitBounds: Boolean): TdxPDFOrientedRectList;
begin
  Result := GetHighlights(AStartWordIndex, AStartOffset, FWordPartList.Count - 1, -1, ASplitBounds);
end;

function TdxPDFTextLine.PositionInLine(AWordIndex: Integer; AOffset: Integer): Boolean;
var
  I, ACharCount, AWrapOffset: Integer;
begin
  for I := 0 to FWordPartList.Count - 1 do
  begin
    ACharCount := FWordPartList[I].Characters.Count;
    if AWordIndex = FWordPartList[I].WordIndex then
    begin
      if I = 0 then
      begin
        AWrapOffset := FWordPartList[I].WrapOffset;
        Exit((AWrapOffset <= AOffset) and (AOffset - AWrapOffset <= ACharCount));
      end
      else
        Exit(AOffset <= ACharCount);
    end;
  end;
  Result := False;
end;

procedure TdxPDFTextLine.PopulateWordList(AWordList: TdxPDFTextWordList);
var
  I: Integer;
  AList: TList;
begin
  FWordList.Clear;
  if AWordList <> nil then
  begin
    AList := TList.Create;
    try
      for I := 0 to AWordList.Count - 1 do
        AList.Add(AWordList[I]);
      AList.SortList(TdxPDFWordPartComparer.CompareWord);
      for I := 0 to AList.Count - 1 do
        FWordList.Add(AList[I]);
    finally
      AList.Free;
    end;
  end;
end;

procedure TdxPDFTextLine.PopulateWordPartList(AWordPartList: TdxPDFTextWordPartList);
begin
  FWordPartList.Clear;
  if AWordPartList <> nil then
    FWordPartList.AddRange(AWordPartList);
end;

{ TdxPDFTextLineList }

constructor TdxPDFTextLineList.Create;
begin
  inherited Create;
  FWordList := nil
end;

destructor TdxPDFTextLineList.Destroy;
begin
  FreeAndNil(FWordList);
  inherited Destroy;
end;

function TdxPDFTextLineList.Clone: TdxPDFTextLineList;
var
  I: Integer;
begin
  Result := TdxPDFTextLineList.Create;
  for I := 0 to Count - 1 do
    Result.Add(Self[I]);
end;

function TdxPDFTextLineList.Find(const APosition: TdxPDFPagePoint; const ATextExpansionFactor: TdxPointF;
  out ALine: TdxPDFTextLine): Boolean;
var
  ACurrentLine: TdxPDFTextLine;
  ABounds: TdxPDFOrientedRect;
  APart: TdxPDFTextWordPart;
  I: Integer;
begin
  ALine := nil;
  if APosition.PageIndex >= 0 then
    for I := 0 to Count - 1 do
    begin
      ACurrentLine := Items[I];
      ABounds := ACurrentLine.Bounds;
      if ABounds.PtInRect(APosition.Point, ATextExpansionFactor.X) then
        for APart in ACurrentLine.WordPartList do
          if APart.Bounds.PtInRect(APosition.Point, ATextExpansionFactor.X) then
          begin
            ALine := ACurrentLine;
            Exit(True);
          end;
      if ABounds.PtInRect(APosition.Point, ATextExpansionFactor.X, ATextExpansionFactor.Y) then
        for APart in ACurrentLine.WordPartList do
          if APart.Bounds.PtInRect(APosition.Point, ATextExpansionFactor.X, ATextExpansionFactor.Y) then
            ALine := ACurrentLine;
    end;
  Result := ALine <> nil;
end;

function TdxPDFTextLineList.FindStartTextPosition(const APosition: TdxPDFPagePoint;
  const ATextExpansionFactor: TdxPointF): TdxPDFTextPosition;
var
  ALine: TdxPDFTextLine;
begin
  if Find(APosition, ATextExpansionFactor, ALine) then
    Result := ALine.GetPosition(APosition.PageIndex, APosition.Point)
  else
    Result := TdxPDFTextPosition.Invalid;
end;

function TdxPDFTextLineList.CreateWordList: TdxPDFTextWordList;
var
  I, J: Integer;
begin
  Result := TdxPDFTextWordList.Create;
  for J := 0 to Count - 1 do
    for I := 0 to Items[J].WordList.Count - 1 do
      Result.Add(Items[J].WordList[I]);
end;

function TdxPDFTextLineList.GetWordList: TdxPDFTextWordList;
begin
  if FWordList = nil then
    FWordList := CreateWordList;
  Result := FWordList;
end;


{ TdxPDFTextBlock }

constructor TdxPDFTextBlock.Create(const ATextData: TdxPDFStringData; AFontData: TdxPDFFontData; AGraphicsState: TObject);
var
  AHorizontalScaling: Double;
  AUnscaledUnitsFactor: Double;
  ATextToUserMatrix: TdxPDFTransformationMatrix;
  ATextSpaceMatrix: TdxPDFTransformationMatrix;
  ATransFormMatrix: TdxPDFTransformationMatrix;
  AState: TdxPDFGraphicsState;


begin
  FBounds := TdxPdfRectangle.Null;
  FFontData := AFontData;
  FCharacters := TdxPDFTextCharacters.Create;
  AState := AGraphicsState as TdxPDFGraphicsState;
  ATextToUserMatrix := TdxPDFTransformationMatrix.Multiply(AState.TextState.TextMatrix, AState.TransformMatrix);
  FFontSize := AState.TextState.AbsoluteFontSize * ATextToUserMatrix.DistanceToY;

  AHorizontalScaling := AState.TextState.HorizontalScaling / 100;
  AUnscaledUnitsFactor := AHorizontalScaling * ATextToUserMatrix.DistanceToX;

  FCharacterSpacing := AState.TextState.CharacterSpacing * AUnscaledUnitsFactor;
  FMinSpaceWidth := Abs(AState.TextState.FontSize * AUnscaledUnitsFactor) / 6;
  FMaxSpaceWidth := Abs(AState.TextState.FontSize * AUnscaledUnitsFactor) / 5.5;

  ATextSpaceMatrix := TdxPDFTransformationMatrix.Multiply(GetFontMatrix, AState.TextState.TextSpaceMatrix);
  ATransFormMatrix := TdxPDFTransformationMatrix.Multiply(ATextSpaceMatrix, ATextToUserMatrix);

  FAngle := ArcTan2(ATransFormMatrix.B, ATransFormMatrix.A);
  InitializeCharacters(ATextData, ATransFormMatrix, ATextSpaceMatrix, ATextToUserMatrix);
end;

destructor TdxPDFTextBlock.Destroy;
begin
  FreeAndNil(FCharacters);
  inherited Destroy;
end;

function TdxPDFTextBlock.CalculateCharacterWidth(ACharacter: Integer): Single;
var
  AIndex: Integer;
begin
  AIndex := ACharacter - FFontData.FirstChar;
  if (FFontData.Widths = nil) or (AIndex < 0) or ((FFontData.Widths <> nil) and (AIndex > Length(FFontData.Widths) - 1)) then
    Result := FontData.MissingWidth
  else
    Result := FontData.Widths[AIndex];
end;

function TdxPDFTextBlock.GetActualCharacter(const ACharacter: TBytes): string;
var
  AToUnicode: TdxPDFCharacterMapping;
  AFont: TdxPDFSimpleFont;
  ACode: Word;
  ACodeLength, I: Integer;
begin
  AToUnicode := FFontData.CMap;
  if AToUnicode <> nil then
    Exit(AToUnicode.MapCode(ACharacter));
  if FontData.Font is TdxPDFSimpleFont then
    AFont := TdxPDFSimpleFont(FFontData.Font)
  else
    AFont := nil;
  if AFont = nil then
    Exit(TdxPDFUtils.ConvertToBigEndianUnicode(ACharacter));
  ACode := 0;
  ACodeLength := Length(ACharacter);
  for I := 0 to ACodeLength - 1 do
    ACode := Word((ACode shl 8) + ACharacter[I]);
  Result := Char(TdxPDFUnicodeConverter.GetGlyphCode(AFont.Encoding, ACode));
end;

function TdxPDFTextBlock.GetFontMatrix: TdxPDFTransformationMatrix;
begin
  if FFontData.Font is TdxPdfType3Font then
    Result := TdxPdfType3Font(FFontData.Font).Matrix
  else
    Result := TdxPDFTransformationMatrix.Create(0.001, 0, 0, 0.001, 0, 0);
end;

procedure TdxPDFTextBlock.InitializeCharacters(const ATextData: TdxPDFStringData; const ATransFormMatrix,
  ATextSpaceMatrix, ATextToUserMatrix: TdxPDFTransformationMatrix);

  function GetTopLeftVertexIndex: Integer;
  begin
    if Sign(ATransFormMatrix.A) = Sign(ATransFormMatrix.D) then
      Result := 0
    else
      if ATransFormMatrix.D < 0 then
        Result := 2
      else
        Result := 1;
  end;

  function GetTranslatedMatrix(const ADelta: TdxPointF): TdxPDFTransformationMatrix;
  begin
    Result := TdxPDFTransformationMatrix.Multiply(ATextSpaceMatrix,
      TdxPDFTransformationMatrix.Multiply(TdxPDFTransformationMatrix.Create(1, 0, 0, 1, ADelta.X, ADelta.Y), ATextToUserMatrix));
  end;

  function GetValidFontAscent: Double;
  begin
    Result := IfThen(FFontData.Metrics.Ascent < 0, 1, FFontData.Metrics.Ascent);
  end;

var
  ATopLeftVertexIndex: Integer;
  APoints: TdxPDFPoints;
  ACharWidth: Double;
  ACharHeight: Double;
  APointPrevDelta: TdxPointF;
  APointCurDelta: TdxPointF;
  ACharacterBaseline: TdxPointF;
  ACharacterWidth: Double;
  I: Integer;
  AFont: TdxPDFCustomFont;
  AFullMatrix: TdxPDFTransformationMatrix;
  ABounds: TdxPDFOrientedRect;
begin
  AFont := FFontData.Font as TdxPDFCustomFont;
  ATopLeftVertexIndex := GetTopLeftVertexIndex;
  APointCurDelta := TdxPointF.Null;
  APointPrevDelta := TdxPointF.Null;
  for I := 0 to Length(ATextData.CharCodes) - 1 do
  begin
    ACharacterWidth := CalculateCharacterWidth(ATextData.Str[I]);
    APoints := [TdxPointF.Create(0, GetValidFontAscent),
                TdxPointF.Create(ACharacterWidth, GetValidFontAscent),
                TdxPointF.Create(0, FFontData.Metrics.Descent)];

    APointPrevDelta := APointCurDelta;
    if AFont.IsVertical then
      APointCurDelta.Y := APointCurDelta.Y + ATextData.Advances[I]
    else
      APointCurDelta.X := APointCurDelta.X + ATextData.Advances[I];

    AFullMatrix := GetTranslatedMatrix(APointPrevDelta);
    APoints := AFullMatrix.TransformPoints(APoints);
    ACharWidth := TdxPointF.Distance(APoints[0], APoints[1]);
    ACharHeight := TdxPointF.Distance(APoints[0], APoints[2]);
    ACharacterBaseline := AFullMatrix.Transform(TdxPointF.Null);
    ABounds := TdxPDFOrientedRect.Create(APoints[ATopLeftVertexIndex], ACharWidth, ACharHeight, FAngle);
    FBounds := TdxPDFRectangle.Union(FBounds, ABounds.BoundingRect);
    FCharacters.Add(TdxPDFTextCharacter.Create(FFontSize, ACharacterBaseline, ABounds,
      GetActualCharacter(ATextData.CharCodes[I])));
  end;
end;


{ TdxPDFTextParserState }

constructor TdxPDFTextParserState.Create(ABlocks: TList<TdxPDFTextBlock>; APageCropBox: TdxRectF);
begin
  inherited Create;
  FActualRTL := False;
  FBlocks := ABlocks;
  FPageCropBox := APageCropBox;
  FCurrentCharacterBlock := ABlocks[0];
  FPreviousCharacterBlock := FCurrentCharacterBlock;
  FCurrentCharacter := FCurrentCharacterBlock.Characters[0];
  FPreviousCharacter := FCurrentCharacter;
end;

function TdxPDFTextParserState.IsIndex: Boolean;
const
  OverlapFactor: Double = 0.35;  
  IndexHeightRatio: Double = 1.3;
var
  ABlock1FontHeight, ABlock2FontHeight: Double;
  ABlock1Angle, ABlock2Angle, ARowBlockHeight, AIndexBlockHeight, ARowBlockAngle: Double;
  AIndexBlockAngle, AOverlapValue, AActualOverlap: Double;
  ABlock1TopLeft, ABlock2TopLeft, ARowBlockTopLeft, AIndexBlockTopLeft: TdxPointF;
  ARotatedRowBlockTopLeft, ARotatedIndexBlockTopLeft: TdxPointF;
  APreviousCharacterBlockBounds: TdxPDFOrientedRect;
  ACurrentCharacterBlockBounds: TdxPDFOrientedRect;
begin
  APreviousCharacterBlockBounds := FPreviousCharacterBlock.Characters[0].Bounds;
  ACurrentCharacterBlockBounds := FCurrentCharacterBlock.Characters[0].Bounds;
  ABlock1FontHeight := APreviousCharacterBlockBounds.Height;
  ABlock2FontHeight := ACurrentCharacterBlockBounds.Height;
  ABlock1TopLeft := APreviousCharacterBlockBounds.TopLeft;
  ABlock2TopLeft := ACurrentCharacterBlockBounds.TopLeft;
  ABlock1Angle := FPreviousCharacterBlock.Angle;
  ABlock2Angle := FCurrentCharacterBlock.Angle;

  if (ABlock1FontHeight / IndexHeightRatio > ABlock2FontHeight) or
    (ABlock2FontHeight / IndexHeightRatio > ABlock1FontHeight) then
  begin
    ARowBlockTopLeft := ABlock1TopLeft;
    AIndexBlockTopLeft := ABlock2TopLeft;
    ARowBlockHeight := ABlock1FontHeight;
    AIndexBlockHeight := ABlock2FontHeight;
    ARowBlockAngle := ABlock1Angle;
    AIndexBlockAngle := ABlock2Angle;
    if ABlock1FontHeight < ABlock2FontHeight then
    begin
      ARowBlockTopLeft := ABlock2TopLeft;
      AIndexBlockTopLeft := ABlock1TopLeft;
      ARowBlockHeight := ABlock2FontHeight;
      AIndexBlockHeight := ABlock1FontHeight;
      ARowBlockAngle := ABlock2Angle;
      AIndexBlockAngle := ABlock1Angle;
    end;
    AOverlapValue := AIndexBlockHeight * OverlapFactor;
    ARotatedRowBlockTopLeft := TdxPDFRecognizedTextUtils.RotatePoint(ARowBlockTopLeft, -ARowBlockAngle);
    ARotatedIndexBlockTopLeft := TdxPDFRecognizedTextUtils.RotatePoint(AIndexBlockTopLeft, -AIndexBlockAngle);
    AActualOverlap := TdxPDFUtils.Min(ARotatedRowBlockTopLeft.Y, ARotatedIndexBlockTopLeft.Y) -
      TdxPDFUtils.Max(ARotatedRowBlockTopLeft.Y - ARowBlockHeight, ARotatedIndexBlockTopLeft.Y - AIndexBlockHeight);
    Exit(AActualOverlap >= AOverlapValue);
  end;
  Result := False;
end;

function TdxPDFTextParserState.IsNewWord: Boolean;
const
  AverageWidthSpaceFactor = 0.3; 
  NormalDistanceFactor = 0.1;
var
  AAvgWidth, AAngle, ADistanceFromLeft, ADistanceFromRight, ADistance: Double;
  ACurrentCharRectangle, APreviousCharRectangle: TdxPDFOrientedRect;
  AWordLeft, AWordRight: TdxPointF;
  ANormalDistanceInWord, AExpectedSpace: Double;

  function CalculateExpectedSpace: Double;
  begin
    if CurrentCharacterBlock <> PreviousCharacterBlock then
      Result := (CurrentCharacterBlock.MinSpaceWidth + PreviousCharacterBlock.MinSpaceWidth) / 2
    else
      Result := CurrentCharacterBlock.MaxSpaceWidth;
    Result := (AAvgWidth + Result) / 2;
  end;

  function IsAssociatedWithPreviousCharacter: Boolean;
  begin
    if ADistance < -NormalDistanceFactor then
     Result := Abs(ADistance) > FPreviousCharacter.Bounds.Width + AExpectedSpace
    else
      Result := AExpectedSpace <= ADistance * (1 + NormalDistanceFactor);
  end;

  function ResolveAssociatedCharacters: Boolean;
  begin
    Result := not((FCurrentDistancesCount <> 0) and
      (Abs(ADistance) < FCurrentDistancesSum / FCurrentDistancesCount + AExpectedSpace));
  end;

begin
  ACurrentCharRectangle := FCurrentCharacter.Bounds;
  APreviousCharRectangle := FPreviousCharacter.Bounds;
  AAvgWidth := (ACurrentCharRectangle.Width + APreviousCharRectangle.Width) / 2 * AverageWidthSpaceFactor;
  if FIsRtl then
  begin
    AWordLeft := FCurrentWordLeftBoundary;
    AWordRight := FCurrentWordRightBoundary;
    AAngle := ACurrentCharRectangle.Angle;
    ADistanceFromLeft := TdxPDFRecognizedTextUtils.GetOrientedDistance(ACurrentCharRectangle.TopRight, AWordLeft, AAngle);
    ADistanceFromRight := TdxPDFRecognizedTextUtils.GetOrientedDistance(AWordRight, ACurrentCharRectangle.TopLeft, AAngle);
    Result := (ADistanceFromLeft > AAvgWidth) or (ADistanceFromRight > AAvgWidth);
  end
  else
  begin
    ADistance := TdxPDFRecognizedTextUtils.GetOrientedDistance(PreviousCharacter.BaseLineLocation,
                                                                CurrentCharacter.BaseLineLocation,
                                                                FPreviousCharacterBlock.Angle) - APreviousCharRectangle.Width;

    ANormalDistanceInWord := AAvgWidth * NormalDistanceFactor;
    AExpectedSpace := CalculateExpectedSpace;

    if not IsZero(PreviousCharacterBlock.CharacterSpacing) and not IsZero(ADistance) and
      (Abs(1 - PreviousCharacterBlock.CharacterSpacing / ADistance) < AverageWidthSpaceFactor) then
         Exit(False);
    if IsAssociatedWithPreviousCharacter then
      Exit(ResolveAssociatedCharacters);
    if ADistance > ANormalDistanceInWord then
    begin
      FCurrentDistancesSum := FCurrentDistancesSum + ADistance;
      Inc(FCurrentDistancesCount);
    end;
    Result := False;
  end;
end;

function TdxPDFTextParserState.IsNewLine: Boolean;
var
  ALineOverlapFactor, APreviousBlockAngle, ACurrentBlockAngle, AVerticalDifference, ABlockFontHeight: Double;
  APreviousBlockLocation, ACurrentBlockLocation: TdxPointF;
  AIsNewLine: Boolean;
begin
  ALineOverlapFactor := 0.7;
  APreviousBlockLocation := FPreviousCharacterBlock.Characters[0].BaseLineLocation;
  ACurrentBlockLocation := FCurrentCharacterBlock.Characters[0].BaseLineLocation;
  APreviousBlockAngle := FPreviousCharacterBlock.Angle;
  ACurrentBlockAngle := FCurrentCharacterBlock.Angle;

  AVerticalDifference := TdxPDFRecognizedTextUtils.RotatePoint(APreviousBlockLocation, -APreviousBlockAngle).Y -
    TdxPDFRecognizedTextUtils.RotatePoint(ACurrentBlockLocation, -ACurrentBlockAngle).Y;

  ABlockFontHeight := TdxPDFUtils.Min(FCurrentCharacterBlock.Characters[0].Bounds.Height, 
                                      FPreviousCharacterBlock.Characters[0].Bounds.Height); 
  ALineOverlapFactor := 1 - ALineOverlapFactor;
  ABlockFontHeight := ABlockFontHeight * ALineOverlapFactor;
  AIsNewLine := Abs(AVerticalDifference) > ABlockFontHeight;
  Result := AIsNewLine and not IsIndex;
end;

procedure TdxPDFTextParserState.ClearDistancesCounter;
begin
  FCurrentDistancesCount := 0;
  FCurrentDistancesSum := 0;
end;


function TdxPDFTextParserState.MoveToNextCharacter: Boolean;
begin
  FPreviousCharacter := FCurrentCharacter;
  Inc(FCharacterIndex);
  if FCharacterIndex >= FCurrentCharacterBlock.Characters.Count then
    Exit(False);
  FPreviousCharacterBlock := FCurrentCharacterBlock;
  FCurrentCharacter := FCurrentCharacterBlock.Characters[FCharacterIndex];
  Result := True;
end;

function TdxPDFTextParserState.MoveToNextBlock: Boolean;
begin
  FPreviousCharacterBlock := FCurrentCharacterBlock;
  Inc(FBlockIndex);
  if FBlockIndex >= FBlocks.Count then
    Exit(False);
  FCurrentCharacterBlock := FBlocks[FBlockIndex];
  FCharacterIndex := 0;
  FPreviousCharacter := FCurrentCharacter;
  FCurrentCharacter := FCurrentCharacterBlock.Characters[FCharacterIndex];
  Result := True;
end;

procedure TdxPDFTextParserState.MoveNext;
var
  ACurrentCharUnicode, APrevCharUnicode: string;
  APreviousBlockCharacters: TdxPDFTextCharacters;
begin
  if not MoveToNextCharacter then
    if not MoveToNextBlock then
    begin
      FIsFinished := True;
      Exit;
    end;
  ACurrentCharUnicode := FCurrentCharacter.Text;
  APrevCharUnicode := FPreviousCharacter.Text;

  FIsRtl := TdxPDFRecognizedTextUtils.HasRTLMarker(ACurrentCharUnicode) or TdxPDFRecognizedTextUtils.HasRTLMarker(APrevCharUnicode);
  FIsCJKWord := TdxPDFRecognizedTextUtils.HasCJKMarker(ACurrentCharUnicode);
  FIsLineStart := not SameValue(FCurrentCharacterBlock.Angle, FPreviousCharacterBlock.Angle, 0) or IsNewLine;
  FIsSpace := FIsLineStart or TdxPDFRecognizedTextUtils.IsWhitespace(ACurrentCharUnicode) or IsNewWord;
  FIsSeparator := TdxPDFRecognizedTextUtils.IsSeparator(APrevCharUnicode);
  APreviousBlockCharacters := FPreviousCharacterBlock.Characters;
  FIsWrap := FIsLineStart and
    TdxPDFRecognizedTextUtils.IsWrapSymbol(APreviousBlockCharacters[APreviousBlockCharacters.Count - 1].Text) and
    (FCurrentCharacterBlock.Characters[0].BaseLineLocation.Y <= FPreviousCharacterBlock.Characters[0].BaseLineLocation.Y);
end;

{ TdxPDFPageWordBuilder }

constructor TdxPDFPageWordBuilder.Create(AParserState: TdxPDFTextParserState);
begin
  inherited Create;
  FParserState := AParserState;
  FCharacters := TdxPDFTextCharacters.Create;
end;

destructor TdxPDFPageWordBuilder.Destroy;
begin
  FreeAndNil(FCharacters);
  FreeAndNil(FWordPartList);
  inherited Destroy;
end;

function TdxPDFPageWordBuilder.BuildWord(ALineXOffset: Single): TdxPDFTextWord;
var
  APartRectangle: TdxPDFOrientedRect;
  APartText: string;
  AWordWrap: Boolean;
  AWordPart: TdxPDFTextWordPart;
begin
  ClearWordPartData;
  FParserState.ClearDistancesCounter;
  FWrapOffset := 0;
  FreeAndNil(FWordPartList);
  FWordPartList := TdxPDFTextWordPartList.Create;
  Result := nil;
  while Result = nil do
  begin
    ProcessChar;
    FParserState.MoveNext;
    if FParserState.IsSpace or FParserState.IsSeparator or FParserState.IsFinished or FParserState.IsCJKWord then
    begin
      FParserState.ClearDistancesCounter;
      APartRectangle := TdxPDFOrientedRect.Create(
        TdxPDFRecognizedTextUtils.RotatePoint(dxPointF(FWordMinX, FWordMaxY), FWordAngle),
        FWordMaxX - FWordMinX,
        FWordMaxY - FWordMinY,
        FWordAngle);

      AWordWrap := FParserState.IsWrap and (ALineXOffset <= APartRectangle.Left);
      AWordPart := TdxPDFTextWordPart.Create(APartRectangle, FCharacters, FWrapOffset, not AWordWrap and (FParserState.IsSpace or FParserState.IsFinished));
      if not AWordPart.IsEmpty then
      begin
        FWordPartList.Add(AWordPart);
        if (AWordWrap and (Length(AWordPart.Text) > 1)) and not FParserState.IsFinished then
        begin
          FWrapOffset := FWrapOffset + Length(APartText);
          ClearWordPartData;
        end
        else
          Result := TdxPDFTextWord.Create(FWordPartList);
      end
      else
      begin
        AWordPart.Free;
        Break;
      end;
    end
  end;
end;

procedure TdxPDFPageWordBuilder.ClearWordPartData;
begin
  FCharacters.Clear;
  FWordMinX := 0;
  FWordMaxX := 0;
  FWordMinY := 0;
  FWordMaxY := 0;
  FWordAngle := 0;
end;

procedure TdxPDFPageWordBuilder.ProcessChar;
var
  ABlock: TdxPDFTextBlock;
  ABlockAngle, AMinY, AMaxY: Single;
  ACharBox: TdxRectF;
  ACharLocation: TdxPointF;
  ACurrentChar: TdxPDFTextCharacter;
  AUnicodeData: string;
begin
  ACurrentChar := FParserState.CurrentCharacter;
  AUnicodeData := ACurrentChar.Text;
  if ((AUnicodeData = #$A0) or
    (AUnicodeData = ' ')) or
    (AUnicodeData = #9) then
      Exit;
  ABlock := FParserState.CurrentCharacterBlock;
  ABlockAngle := ABlock.Angle;
  ACharLocation := TdxPDFRecognizedTextUtils.RotatePoint(ACurrentChar.BaseLineLocation, -ABlockAngle);
  AMinY := TdxPDFRecognizedTextUtils.RotatePoint(ACurrentChar.Bounds.BottomLeft, -ABlockAngle).Y;
  AMaxY := AMinY + ACurrentChar.Bounds.Height;
  if FCharacters.Count = 0 then
  begin
    FWordMinX := ACharLocation.X;
    FWordMinY := AMinY;
    FWordMaxY := AMaxY;
    FWordAngle := ABlockAngle;
  end
  else
  begin
    FWordMinY := Math.Min(FWordMinY, AMinY);
    FWordMaxY := Math.Max(FWordMaxY, AMaxY);
  end;
  ACharBox := ACurrentChar.Bounds.RotatedRect;
  if ACharBox.Width <> 0 then
  begin
    if not TdxPDFUtils.IsRectEmpty(ACharBox) and TdxPDFUtils.Intersects(FParserState.PageCropBox, ACharBox) then
    begin
      FWordMaxX := Max(FWordMaxX, ACharLocation.X + ACharBox.Width);
      FWordMinX := Min(ACharLocation.X, FWordMinX);
      FCharacters.Add(ACurrentChar);
    end;
  end;
  FParserState.CurrentWordLeftBoundary := dxPointF(FWordMinX, FWordMaxX);
  FParserState.CurrentWordRightBoundary := dxPointF(FWordMaxX, FWordMaxY);
end;

{ TdxPDFPageTextLineBuilder }

constructor TdxPDFPageTextLineBuilder.Create(AParserState: TdxPDFTextParserState);
begin
  inherited Create;
  FWordIndex := 1;
  FLineXOffset := MinSingle;
  FParserState := AParserState;

  FWordList := TdxPDFTextWordList.Create;
  FWordPartList := TdxPDFTextWordPartList.Create;
  FWordBuilder := TdxPDFPageWordBuilder.Create(AParserState);
end;

destructor TdxPDFPageTextLineBuilder.Destroy;
begin
  FreeAndNil(FWordBuilder);
  FreeAndNil(FWordPartList);
  FreeAndNil(FWordList);
  inherited Destroy;
end;

procedure TdxPDFPageTextLineBuilder.Populate(ATextLines: TdxPDFTextLineList);
var
  ANextWord: TdxPDFTextWord;
  AWordParts: TdxPDFTextWordPartList;
  ATempWordParts: TdxPDFTextWordPartList;
  APartsCount: Integer;
  I: Integer;
begin
  while True do
  begin
    ANextWord := FWordBuilder.BuildWord(FLineXOffset);
    if ANextWord <> nil then
    begin
      if not OverlapsWithPreviousWords(ANextWord) then
      begin
        FWordList.Add(ANextWord);
        AWordParts := ANextWord.PartList;
        FLineXOffset := Math.Max(FLineXOffset, AWordParts[0].Bounds.Right);
        APartsCount := AWordParts.Count;
        if APartsCount > 1 then
        begin
          EnumerateWordsAndFillParts;
          AddTextLine(ATextLines, FWordList, FWordPartList);
          for I := 1 to APartsCount - 2 do
          begin
            ATempWordParts := TdxPDFTextWordPartList.Create;
            ATempWordParts.Add(AWordParts[I]);
            AddTextLine(ATextLines, nil, ATempWordParts);
          end;
          Clear;
          FWordPartList.Add(AWordParts[APartsCount - 1]);
          FLineXOffset := MinSingle;
        end;
      end
      else
        ANextWord.Free;
    end;
    if (FParserState.IsLineStart) or (FParserState.IsFinished) then
    begin
      if (FWordList.Count <> 0) or (FWordPartList.Count <> 0) then
      begin
        EnumerateWordsAndFillParts;
        AddTextLine(ATextLines, FWordList, FWordPartList);
        if FParserState.IsFinished then
          Break
        else
        begin
          Clear;
          Continue;
        end;
      end;
      if FParserState.IsFinished then
        Break;
      FLineXOffset := MinSingle;
    end;
  end;
end;

function TdxPDFPageTextLineBuilder.OverlapsWithPreviousWords(AWord: TdxPDFTextWord): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FWordList.Count - 1 do
    if FWordList[I].Overlap(AWord) then
      Exit(True);
end;

procedure TdxPDFPageTextLineBuilder.AddTextLine(ATextLines: TdxPDFTextLineList; AWordList: TdxPDFTextWordList;
  APartList: TdxPDFTextWordPartList);
var
  ALine: TdxPDFTextLine;
begin
  ALine := TdxPDFTextLine.Create;
  ALine.PopulateWordList(AWordList);
  ALine.PopulateWordPartList(APartList);
  ATextLines.Add(ALine);
end;

procedure TdxPDFPageTextLineBuilder.Clear;
begin
  RecreateWordList;
  RecreateWordPartList;
end;

procedure TdxPDFPageTextLineBuilder.EnumerateWordsAndFillParts;
var
  I: Integer;
begin
  FWordList.Sort(TComparer<TdxPDFTextWord>.Construct(
    function (const AWord1, AWord2: TdxPDFTextWord): Integer
    begin
      Result := TdxPDFWordPartComparer.CompareWord(AWord1, AWord2);
    end)); 
  for I := 0 to FWordList.Count - 1 do
  begin
    FWordList[I].Index := FWordIndex;
    FWordPartList.Add(FWordList[I].PartList[0]);
    Inc(FWordIndex);
  end;
end;

procedure TdxPDFPageTextLineBuilder.RecreateWordList;
begin
  FreeAndNil(FWordList);
  FWordList := TdxPDFTextWordList.Create;
end;

procedure TdxPDFPageTextLineBuilder.RecreateWordPartList;
begin
  FreeAndNil(FWordPartList);
  FWordPartList := TdxPDFTextWordPartList.Create;
end;

{ TdxPDFRecognizedTextUtils }

class procedure TdxPDFRecognizedTextUtils.AppendWordPart(ABuilder: TdxBiDiStringBuilder; APart: TdxPDFTextWordPart);
begin
  AppendWordPart(ABuilder, APart, 0, APart.Characters.Count);
end;

class procedure TdxPDFRecognizedTextUtils.AppendWordPart(ABuilder: TdxBiDiStringBuilder; APart: TdxPDFTextWordPart;
  AStartOffset: Integer);
begin
  AppendWordPart(ABuilder, APart, AStartOffset, APart.Characters.Count);
end;

class procedure TdxPDFRecognizedTextUtils.AppendWordPart(ABuilder: TdxBiDiStringBuilder; APart: TdxPDFTextWordPart;
  AStartOffset, AEndOffset: Integer);
var
  I: Integer;
begin
  for I := AStartOffset to AEndOffset - 1 do
    ABuilder.Append(APart.Characters[I].Text);
end;

class procedure TdxPDFRecognizedTextUtils.Append(ABuilder: TdxBiDiStringBuilder; const AStart, AEnd: TdxPDFPageTextPosition;
  AWordPart: TdxPDFTextWordPart);
var
  AWordIndex, APartLength, AStartOffset, AEndOffset: Integer;
  AWithoutStartWord, AWithoutEndWord: Boolean;
begin
  AWithoutStartWord := AStart.WordIndex = 0;
  AWithoutEndWord := AEnd.WordIndex = 0;
  AWordIndex := AWordPart.WordIndex;
  APartLength := Length(AWordPart.Text);

  AStartOffset := Max(AStart.Offset - AWordPart.WrapOffset, 0);
  AEndOffset := Min(AEnd.Offset - AWordPart.WrapOffset, APartLength);

  if AWithoutStartWord and AWithoutEndWord or AWithoutStartWord and (AWordIndex < AEnd.WordIndex) or  AWithoutEndWord and
  (AWordIndex > AStart.WordIndex) or (AWordIndex > AStart.WordIndex) and (AWordIndex < AEnd.WordIndex) then
  begin
    AppendWordPart(ABuilder, AWordPart);
    if AWordPart.WordEnded then
      ABuilder.Append(' ');
  end
  else
    if (AWordIndex = AEnd.WordIndex) then
    begin
      if AWordIndex = AStart.WordIndex then
      begin
        if (AStart.Offset = 0) and (AEnd.Offset < 0) then
          AppendWordPart(ABuilder, AWordPart)
        else
          if (AStartOffset <= APartLength) and (AEndOffset >= 0) then
            AppendWordPart(ABuilder, AWordPart, AStartOffset, AEndOffset);
      end
      else
        if AWithoutStartWord or (AWordIndex > AStart.WordIndex) then
        begin
          if AEnd.Offset < 0 then
            AppendWordPart(ABuilder, AWordPart)
          else
            if AEndOffset >= 0 then
              AppendWordPart(ABuilder, AWordPart, 0, AEndOffset);
        end;
    end
    else
      if (AWithoutEndWord or (AWordIndex < AEnd.WordIndex)) and (AWordIndex = AStart.WordIndex) and (AStartOffset <= APartLength) then
      begin
        AppendWordPart(ABuilder, AWordPart, AStartOffset);
        if AWordPart.WordEnded then
          ABuilder.Append(' ');
      end;
end;

class function TdxPDFRecognizedTextUtils.ConvertToString(const AStart, AEnd: TdxPDFPageTextPosition;
  AWordPart: TdxPDFTextWordPart): string;
var
  ABuilder: TdxBiDiStringBuilder;
begin
  ABuilder := TdxBiDiStringBuilder.Create;
  try
    Append(ABuilder, AStart, AEnd, AWordPart);
    Result := ABuilder.ToString;
  finally
    ABuilder.Free;
  end;
end;

class procedure TdxPDFRecognizedTextUtils.Append(ABuilder: TdxBiDiStringBuilder;
  const AStart, AEnd: TdxPDFPageTextPosition; ALine: TdxPDFTextLine);
var
  ALastWordIndex: Integer;
  ANeedNewLine: Boolean;
  APart: TdxPDFTextWordPart;
  I: Integer;
begin
  ANeedNewLine := False;
  for I := 0 to ALine.WordPartList.Count - 1 do
    try
      APart :=  ALine.WordPartList[I];
      ANeedNewLine := (APart.WordIndex = AEnd.WordIndex) and ((AEnd.Offset = APart.Characters.Count) or (AEnd.Offset < 0));
      Append(ABuilder, AStart, AEnd, APart);
    except
      Break;
    end;
  ALastWordIndex := ALine.WordPartList.Last.WordIndex;
  if not ABuilder.Empty and (ALastWordIndex >= AStart.WordIndex) and
    ((ALastWordIndex < AEnd.WordIndex) or ANeedNewLine or (AEnd.WordIndex = 0)) then
    ABuilder.AppendLine;
end;

class procedure TdxPDFRecognizedTextUtils.Append(ABuilder: TdxBiDiStringBuilder; const AStart, AEnd: TdxPDFPageTextPosition;
  ALines: TdxPDFTextLineList);
var
  ALine: TdxPDFTextLine;
begin
  for ALine in ALines do
    Append(ABuilder, AStart, AEnd, ALine);
end;

class function TdxPDFRecognizedTextUtils.ConvertToString(const AStart, AEnd: TdxPDFPageTextPosition; ALine: TdxPDFTextLine): string;
var
  ABuilder: TdxBiDiStringBuilder;
  AWordPart: TdxPDFTextWordPart;
begin
  ABuilder := TdxBiDiStringBuilder.Create;
  try
    for AWordPart in ALine.WordPartList do
      try
        Append(ABuilder, AStart, AEnd, AWordPart);
      except
      end;
    Result := ABuilder.EndCurrentLineAndGetString;
  finally
    ABuilder.Free;
  end;
end;

class function TdxPDFRecognizedTextUtils.ConvertToString(const AStart, AEnd: TdxPDFPageTextPosition; ALines: TdxPDFTextLineList): string;
var
  ABuilder: TdxBiDiStringBuilder;
begin
  ABuilder := TdxBiDiStringBuilder.Create;
  try
    Append(ABuilder, AStart, AEnd, ALines);
    Result := ABuilder.EndCurrentLineAndGetString;
  finally
    ABuilder.Free;
  end;
end;




end.
