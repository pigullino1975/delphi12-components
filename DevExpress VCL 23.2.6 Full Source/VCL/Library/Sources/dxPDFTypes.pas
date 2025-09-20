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

unit dxPDFTypes;

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Graphics, Classes, Windows, Generics.Defaults, Generics.Collections, Math, dxCore, dxGenerics,
  dxCoreClasses, cxClasses, cxGraphics, dxCoreGraphics, cxGeometry, dxGDIPlusClasses, dxProtectionUtils, dxPDFBase;

type
  TdxPDFPoints = TdxPointsF;

  EdxPDFException = class(EdxException);

  EdxPDFAbortException = class(EAbort);
  EdxPDFEncryptionException = class(EdxPDFException);
  EdxPDFExceptionClass = class of EdxPDFException;
  TdxPDFArray = class;
  TdxPDFCustomRepository = class;
  TdxPDFCustomRepositoryClass = class of TdxPDFCustomRepository;
  TdxPDFDictionary = class;
  TdxPDFName = class;
  TdxPDFNumericObject = class;
  TdxPDFReference = class;
  TdxPDFStream = class;
  TdxPDFString = class;

  TdxPDFAnnotationBorderEffectStyle = (esNo, esCloudy); // for internal use
  TdxPDFAnnotationLineEndingStyle = (lesNone, lesSquare, lesCircle, lesDiamond, lesOpenArrow, lesClosedArrow, lesButt,
    lesROpenArrow, lesRClosedArrow, lesSlash); // for internal use
  TdxPDFFreeTextAnnotationIntent = (aiFreeText, aiFreeTextCallout, aiFreeTextTypeWriter); // for internal use
  TdxPDFBlendMode = (bmNormal, bmCompatible, bmMultiply, bmScreen, bmOverlay, bmDarken, bmLighten, bmColorDodge,
    bmColorBurn, bmHardLight, bmSoftLight, bmDifference, bmExclusion, bmHue, bmSaturation, bmColor, bmLuminosity); // for internal use
  TdxPDFInteractiveFormFieldType = (ftUnknown, ftNode, ftPushButton, ftCheckBox, ftRadioGroup, ftListBox, ftComboBox, ftText,
    ftSignature);
  TdxPDFLineCapStyle = (lcsButt, lcsRound, lcsProjectingSquare); // for internal use
  TdxPDFLineJoinStyle = (ljsMiter, ljsRound, ljsBevel); // for internal use
  TdxPDFPixelFormat = (pfUnknown, pfGray1bit, pfGray8bit, pfArgb24bpp, pfArgb32bpp); // for internal use
  TdxPDFRenderingIntent = (riAbsoluteColorimetric, riRelativeColorimetric, riSaturation, riPerceptual); // for internal use
  TdxPDFSignatureFlag = (sfNone, sfSignaturesExist, sfAppendOnly); // for internal use
  TdxPDFSignatureFlags = set of TdxPDFSignatureFlag; // for internal use
  TdxPDFTextRenderingMode = (trmFill, trdStroke, trmFillAndStroke, trmInvisible, trmFillAndClip, trmStrokeAndClip,
    trmFillStrokeAndClip, trmClip); // for internal use
  TdxPDFVersion = (v1_0, v1_1, v1_2, v1_3, v1_4, v1_5, v1_6, v1_7);

  TdxPDFDocumentDecodedImageData = record // for internal use
    Data: TBytes;
    PixelFormat: TdxPDFPixelFormat;
  end;

  TdxPDFBytesDynArray = array of TBytes; // for internal use

  { TdxPDFStringCommandData }

  TdxPDFStringCommandData = record // for internal use
  private
    FCharCodes: TdxPDFBytesDynArray;
    FOffsets: TDoubleDynArray;
    FStr: TWordDynArray;
  public
    class function Create(const ACharCodes: TdxPDFBytesDynArray; const AStr: TWordDynArray;
      const AOffsets: TDoubleDynArray): TdxPDFStringCommandData; static;

    property CharCodes: TdxPDFBytesDynArray read FCharCodes;
    property Offsets: TDoubleDynArray read FOffsets;
    property Str: TWordDynArray read FStr;
  end;

  { TdxPDFStringData }

  TdxPDFStringData = record  // for internal use
  strict private
    FAdvances: TDoubleDynArray;
    FCommandData: TdxPDFStringCommandData;
    FWidths: TDoubleDynArray;
    function GetCharCodes: TdxPDFBytesDynArray;
    function GetStr: TWordDynArray;
    function GetOffsets: TDoubleDynArray;
  public
    class function Create(const ACodePointData: TdxPDFStringCommandData;
      const AWidths, AAdvances: TDoubleDynArray): TdxPDFStringData; static;

    property Advances: TDoubleDynArray read FAdvances;
    property CharCodes: TdxPDFBytesDynArray read GetCharCodes;
    property Offsets: TDoubleDynArray read GetOffsets;
    property Str: TWordDynArray read GetStr;
    property Widths: TDoubleDynArray read FWidths;
  end;

  { TdxPDFPagePoint }

  TdxPDFPagePoint = record
  strict private
    FPageIndex: Integer;
    FPoint: TdxPointF;
  public
    class function Create: TdxPDFPagePoint; overload; static;
    class function Create(APageIndex: Integer; const APoint: TPoint): TdxPDFPagePoint; overload; static;
    class function Create(APageIndex: Integer; const APoint: TdxPointF): TdxPDFPagePoint; overload; static;
    //
    function IsValid: Boolean;
    procedure Invalid;
    //
    property PageIndex: Integer read FPageIndex write FPageIndex;
    property Point: TdxPointF read FPoint write FPoint;
  end;

  { TdxPDFPageRect }

  TdxPDFPageRect = record
  strict private
    FPageIndex: Integer;
    FRect: TdxRectF;
    //
    function GetBottomRight: TdxPDFPagePoint;
    function GetTopLeft: TdxPDFPagePoint;
  public
    class function Create: TdxPDFPageRect; overload; static;
    class function Create(APageIndex: Integer; const ARect: TRect): TdxPDFPageRect; overload; static;
    class function Create(APageIndex: Integer; const ARect: TdxRectF): TdxPDFPageRect; overload; static;
    class function Create(const P1, P2: TdxPDFPagePoint): TdxPDFPageRect; overload; static;
    //
    function IsValid: Boolean;
    procedure Invalid;
    //
    property BottomRight: TdxPDFPagePoint read GetBottomRight;
    property PageIndex: Integer read FPageIndex write FPageIndex;
    property Rect: TdxRectF read FRect write FRect;
    property TopLeft: TdxPDFPagePoint read GetTopLeft;
  end;

  { TdxPDFOrientedRect }

  TdxPDFOrientedRect = record // for internal use
  public
    Angle: Single;
    Height: Single;
    Left: Single;
    Top: Single;
    Width: Single;
  end;

  TdxPDFDocumentID = array[0..1] of TBytes;
  TdxPDFOrientedRectList = class(TList<TdxPDFOrientedRect>);

  TdxPDFRange = TdxDoubleRange;
  TdxPDFRanges = TdxDoubleRanges;

  TdxPDFRangeHelper = record helper for TdxPDFRange
    class function Invalid: TdxDoubleRange; static;
  end;

  { TdxPDFRectangle }

  TdxPDFRectangle = record // for internal use
  private
    FLeft: Single;
    FBottom: Single;
    FRight: Single;
    FTop: Single;
    //
    function GetBottomLeft: TdxPointF;
    function GetBottomRight: TdxPointF;
    function GetTopLeft: TdxPointF;
    function GetTopRight: TdxPointF;
    function GetHeight: Single;
    function GetWidth: Single;
    class function IsSame(A, B, ADelta: Double): Boolean; static;
  public
    class function Create(ALeft, ABottom, ARight, ATop: Single): TdxPDFRectangle; overload; static;
    class function Create(const P1, P2: TdxPointF): TdxPDFRectangle; overload; static;
    class function Create(AArray: TdxPDFArray): TdxPDFRectangle; overload; static;
    class function Create(const APoints: TdxPDFPoints): TdxPDFRectangle; overload; static;
    class function Equal(const R1, R2: TdxPDFRectangle; ADelta: Double): Boolean; overload; static;
    class function Inflate(const R: TdxPDFRectangle; AAmount: Double): TdxPDFRectangle; static;
    class function Intersect(const R1, R2: TdxPDFRectangle): TdxPDFRectangle; static;
    class function Null: TdxPDFRectangle; static;
    class function Union(const R1, R2: TdxPDFRectangle): TdxPDFRectangle; static;
    //
    function Contains(const P: TdxPointF): Boolean;
    function Equals(const R: TdxPDFRectangle): Boolean; overload;
    function Intersects(const R: TdxPDFRectangle): Boolean;
    function IsNull: Boolean;
    function Trim(const ARectangle: TdxPDFRectangle): TdxPDFRectangle;
    function ToRectF: TdxRectF;
    //
    property Bottom: Single read FBottom;
    property BottomLeft: TdxPointF read GetBottomLeft;
    property BottomRight: TdxPointF read GetBottomRight;
    property Height: Single read GetHeight;
    property Left: Single read FLeft;
    property Right: Single read FRight;
    property Top: Single read FTop;
    property TopLeft: TdxPointF read GetTopLeft;
    property TopRight: TdxPointF read GetTopRight;
    property Width: Single read GetWidth;
  end;

  { TdxPDFQuadrilateral }

  TdxPDFQuadrilateral = record
  strict private
    FP1: TdxPointF;
    FP2: TdxPointF;
    FP3: TdxPointF;
    FP4: TdxPointF;
    //
    class function TriangleContainsPoint(const P1, P2, P3, ATargetPoint: TdxPointF): Boolean; static;
  public
    class function Create(const P1, P2, P3, P4: TdxPointF): TdxPDFQuadrilateral; overload; static;
    class function Create(const ARect: TdxPDFOrientedRect): TdxPDFQuadrilateral; overload; static;
    //
    function Contains(const P: TdxPointF): Boolean;
    function GetAsArray: TDoubleDynArray;
    //
    property P1: TdxPointF read FP1;
    property P2: TdxPointF read FP2;
    property P3: TdxPointF read FP3;
    property P4: TdxPointF read FP4;
  end;

  TdxPDFQuadrilateralArray = array of TdxPDFQuadrilateral;

  { TdxPDFOrientedRectHelper }

  TdxPDFOrientedRectHelper = record helper for TdxPDFOrientedRect // for internal use
  strict private
    function GetBottom: Single;
    function GetBoundingRect: TdxPDFRectangle;
    function GetRect: TdxRectF;
    function GetRight: Single;
    function GetRotatedRect: TdxRectF;
    function GetTopLeft: TdxPointF; inline;
    function GetTopRight: TdxPointF;
    function GetBottomLeft: TdxPointF; inline;
    //
    function CalculateBottomLeft(const ASin, ACos: Double): TdxPointF;
    function CalculateTopRight(const ASin, ACos: Double): TdxPointF;
  protected
    class function Invalid: TdxPDFOrientedRect; static;
  public
    class function Create: TdxPDFOrientedRect; overload; static;
    class function Create(const ATopLeft: TdxPointF; AWidth, AHeight, AAngle: Single): TdxPDFOrientedRect; overload; static;
    class function Create(const ARect: TdxRectF): TdxPDFOrientedRect; overload; static;
    class function Create(const ARect: TdxPDFRectangle): TdxPDFOrientedRect; overload; static;
    class function Create(const ARect: TdxRectF; AAngle: Single): TdxPDFOrientedRect; overload; static;

    function GetVertices: TdxPointsF;
    function IsValid: Boolean;
    function Overlap(const R: TdxPDFOrientedRect): Boolean;
    function PtInRect(const APoint: TdxPointF; AExpandX: Single = 0; AExpandY: Single = 0): Boolean;

    property Bottom: Single read GetBottom;
    property BoundingRect: TdxPDFRectangle read GetBoundingRect;
    property Rect: TdxRectF read GetRect;
    property Right: Single read GetRight;
    property RotatedRect: TdxRectF read GetRotatedRect;
    property TopLeft: TdxPointF read GetTopLeft;
    property TopRight: TdxPointF read GetTopRight;
    property BottomLeft: TdxPointF read GetBottomLeft;
  end;

  { TdxPDFFixedPointNumber }

  TdxPDFFixedPointNumber = record // for internal use
  strict private const
    FractionPartSize = 22;
    FloatToFixedFactor = 1 shl FractionPartSize;
    Half = 1 shl (FractionPartSize - 1);
  strict private
    FValue: Integer;
  private
    class function Create(AValue: Integer): TdxPDFFixedPointNumber; overload; static;
  public
    class function Create(AValue: Single): TdxPDFFixedPointNumber; overload; static;
    class operator Add(const A, B: TdxPDFFixedPointNumber): TdxPDFFixedPointNumber;
    class operator Multiply(A: Integer; const B: TdxPDFFixedPointNumber): TdxPDFFixedPointNumber;
    function RoundToByte: Byte;
  end;
  TdxPDFFixedPointNumbers = array of TdxPDFFixedPointNumber; // for internal use

  { TdxPDFNamedObjectDictionary }

  TdxPDFNamedObjectDictionary = class  // for internal use
  strict private
    FDictionary: TdxPDFStringIntegerDictionary;
    FResourceKey: string;
    FPrefix: string;
    FNextResourceNumber: Integer;
  public
    constructor Create(const AResourceKey, APrefix: string);
    destructor Destroy; override;

    function GetNewResourceName(ADictionary: TdxPDFStringReferencedObjectDictionary): string; overload;
    function GetNewResourceName(ADictionary: TdxPDFStringReferencedObjectDictionary; const AName: string): string; overload;
    function ContainsValue(AValue: Integer): Boolean;
    procedure ClearResourceNames;

    property ResourceKey: string read FResourceKey;
  end;

  { TdxPDFArray }

  TdxPDFArray = class(TdxPDFBase)
  strict private
    FElementList: TdxPDFBaseList;
    //
    function GetCount: Integer;
    function GetElement(AIndex: Integer): TdxPDFBase;
    function TryGetObject<T: TdxPDFBase>(AIndex: Integer; out AObject: T): Boolean;
    procedure SetElement(Index: Integer; const Value: TdxPDFBase);
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
  public
    constructor Create; overload; override;
    constructor Create(const AValues: array of Integer); overload;
    constructor Create(const AValues: array of Single); overload;
    constructor Create(const AValues: array of string); overload;
    constructor Create(const AValue: TdxPointF); overload;
    destructor Destroy; override;
    //
    function GetSingle(AIndex: Integer): Single;
    function TryGetArray(AIndex: Integer; out AArray: TdxPDFArray): Boolean;
    function TryGetDictionary(AIndex: Integer; out ADictionary: TdxPDFDictionary): Boolean;
    function TryGetSingle(AIndex: Integer; out AValue: Single): Boolean;
    function TryGetString(AIndex: Integer; out AName: TdxPDFString): Boolean;
    procedure Add(const AValue: Boolean); overload;
    procedure Add(const AValue: Double); overload;
    procedure Add(const AValue: Integer); overload;
    procedure Add(const AValue: Single); overload;
    procedure Add(const AValue: TdxPDFBase); overload;
    procedure Add(const AValue: TdxPDFRange); overload;
    procedure Add(const AValue: string); overload;
    procedure Add(const AValue: array of Double); overload;
    procedure Add(const AValue: array of Integer); overload;
    procedure Add(const AValue: array of Single); overload;
    procedure Add(const AValue: array of string); overload;
    procedure Add(const AValue: TdxPointF); overload;
    procedure AddBytes(const AValue: TBytes);
    procedure AddName(const AValue: string);
    procedure AddNull;
    procedure AddReference(ANumber: Integer; AGeneration: Integer = 0);
    procedure Clear;
    function AsString: string;
    function IsString: Boolean;
    //
    property Count: Integer read GetCount;
    property Elements[Index: Integer]: TdxPDFBase read GetElement write SetElement; default;
    property ElementList: TdxPDFBaseList read FElementList;
  end;

  { TdxPDFKeywords }

  TdxPDFKeywords = class
  public const
  {$REGION 'public const'}
    &Function = 'Function';
    AcroForm = 'AcroForm';
    Action = 'Action';
    ActionDestination = 'D';
    ActionFirst = 'First';
    ActionName = 'N';
    ActionNamed = 'Named';
    ActionNext = 'Next';
    ActionType = 'S';
    AESCryptMethodName = 'AESV3';
    Alternate = 'Alternate';
    Annotation = 'Annot';
    AnnotationAppearance = 'AP';
    AnnotationAppearanceDown = 'D';
    AnnotationAppearanceName = 'AS';
    AnnotationAppearanceNormal = 'N';
    AnnotationAppearanceRollover = 'R';
    AnnotationBorderEffect = 'BE';
    AnnotationBorderEffectIntensity = 'I';
    AnnotationBorderEffectStyle = 'S';
    AnnotationBorderStyle = 'BS';
    AnnotationCallout = 'CL';
    AnnotationColor = 'C';
    AnnotationFlags = 'F';
    AnnotationHighlightingMode = 'H';
    AnnotationName = 'NM';
    Annotations = 'Annots';
    AntiAlias = 'AntiAlias';
    AppearanceCharacteristics = 'MK';
    AppearanceCharacteristicsAlternateCaption = 'AC';
    AppearanceCharacteristicsAlternateIcon = 'AX';
    AppearanceCharacteristicsBackgroundColor = 'BG';
    AppearanceCharacteristicsBorderColor = 'BC';
    AppearanceCharacteristicsCaption = 'CA';
    AppearanceCharacteristicsIconFit = 'IF';
    AppearanceCharacteristicsNormalIcon = 'I';
    AppearanceCharacteristicsTextPosition = 'TP';
    AppearanceCharacteristicsRolloverIcon = 'RI';
    AppearanceCharacteristicsRolloverCaption = 'RC';
    AppearanceCharacteristicsRotation = 'R';
    ArialBoldFontName = 'Arial,Bold';
    ArialFontName = 'Arial';
    ArialItalicFontName = 'Arial,Italic';
    ArialUnicodeMS = 'Arial Unicode MS';
    ArtBox = 'ArtBox';
    AssociatedFileRelationship = 'AFRelationship';
    Author = 'Author';
    BackdropColor = 'BC';
    Background = 'Background';
    BaseEncoding = 'BaseEncoding';
    BaseFont = 'BaseFont';
    BaseVersion = 'BaseVersion';
    BBox = 'BBox';
    BitsPerComponent = 'BitsPerComponent';
    BitsPerSample = 'BitsPerSample';
    BlackPoint = 'BlackPoint';
    BleedBox = 'BleedBox';
    BlendMode = 'BM';
    Bold = 'Bold';
    Border = 'Border';
    BorderStyle = 'BorderStyle';
    BorderStyleName = 'S';
    BorderStyleWidth = 'W';
    Bounds = 'Bounds';
    ByteRange = 'ByteRange';
    C0 = 'C0';
    C1 = 'C1';
    CaretAnnotation = 'Caret';
    Catalog = 'Catalog';
    CCITTFaxDecodeFilterBlackIs1 = 'BlackIs1';
    CCITTFaxDecodeFilterColumns = 'Columns';
    CCITTFaxDecodeFilterDamagedRowsBeforeError = 'DamagedRowsBeforeError';
    CCITTFaxDecodeFilterEncodedByteAlign = 'EncodedByteAlign';
    CCITTFaxDecodeFilterEncodingScheme = 'K';
    CCITTFaxDecodeFilterEndOfBlock = 'EndOfBlock';
    CCITTFaxDecodeFilterEndOfLine = 'EndOfLine';
    CCITTFaxDecodeFilterRows = 'Rows';
    CharProcs = 'CharProcs';
    ChoiceSelectedIndexes = 'I';
    ChoiceTopIndex = 'TI';
    CIDFontType0 = 'CIDFontType0';
    CIDFontType0C = 'CIDFontType0C';
    CIDFontType2 = 'CIDFontType2';
    CIDSystemInfo = 'CIDSystemInfo';
    CIDToGIDMap = 'CIDToGIDMap';
    CircleAnnotation = 'Circle';
    CMap = 'CMap';
    CMapName = 'CMapName';
    CollectionItem = 'CI';
    Colorants = 'Colorants';
    Colors = 'Colors';
    ColorSpace = 'ColorSpace';
    ColorTransform = 'ColorTransform';
    Columns = 'Columns';
    Components = 'Components';
    ContactInfo = 'ContactInfo';
    Contents = 'Contents';
    Coords = 'Coords';
    Count = 'N';
    CountFull = 'Count';
    CourierBoldFontName = 'Courier-Bold';
    CourierBoldObliqueFontName = 'Courier-BoldOblique';
    CourierFontName = 'Courier';
    CourierNewBoldFontName = 'CourierNew,Bold';
    CourierNewFontName = 'CourierNew';
    CourierNewFontName2 = 'Courier New';
    CourierNewItalicFontName = 'CourierNew,Italic';
    CourierObliqueFontName = 'Courier-Oblique';
    CreationDate = 'CreationDate';
    Creator = 'Creator';
    CropBox = 'CropBox';
    CryptFilterMode = 'CFM';
    CryptFilters = 'CF';
    DCTDecode = 'DCTDecode';
    Decode = 'Decode';
    DecodeParameters = 'DecodeParms';
    DefaultStyle = 'DefaultStyle';
    DefaultWidth = 'DW';
    DescendantFonts = 'DescendantFonts';
    Destination = 'Dest';
    Destinations = 'Dests';
    DictionaryAppearance = 'DA';
    DictionaryResources = 'DR';
    Differences = 'Differences';
    DisplayDuration = 'Dur';
    DocumentInfo = 'Info';
    Domain = 'Domain';
    EarlyChange = 'EarlyChange';
    EmbeddedFile = 'EmbeddedFile';
    EmbeddedFileReference = 'EF';
    EmbeddedFiles = 'EmbeddedFiles';
    EmbeddedFilesCryptFilter = 'EFF';
    Encode = 'Encode';
    EncodedOwnerPassword = 'OE';
    EncodedUserPassword = 'UE';
    Encoding = 'Encoding';
    Encrypt = 'Encrypt';
    EncryptedPermissions = 'Perms';
    EncryptMetadata = 'EncryptMetadata';
    EndStream = 'endstream';
    EOF = '%%EOF';
    Extend = 'Extend';
    ExtensionLevel = 'ExtensionLevel';
    ExtGState = 'ExtGState';
    FDF = 'FDF';
    FDFField = 'T';
    FieldFlags = 'Ff';
    FieldOptions = 'Opt';
    Fields = 'Fields';
    FieldType = 'FT';
    FileAttachmentAnnotationDesc = 'Desc';
    FileAttachmentAnnotationName = 'Name';
    FileCreationDate = 'CreationDate';
    FileData = 'F';
    FileDescription = 'Desc';
    FileIndex = 'Index';
    FileModificationDate = 'ModDate';
    FileName = 'F';
    FileParameters = 'Params';
    FileSize = 'Size';
    FileSpec = 'Filespec';
    FileSystem = 'FS';
    Filter = 'Filter';
    FirstChar = 'FirstChar';
    FlateDecode = 'FlateDecode';
    FlatnessTolerance = 'FL';
    Font = 'Font';
    FontDescriptor = 'FontDescriptor';
    FontDescriptorAscent = 'Ascent';
    FontDescriptorAvgWidth = 'AvgWidth';
    FontDescriptorBBox = 'FontBBox';
    FontDescriptorCapHeight = 'CapHeight';
    FontDescriptorCharSet = 'CharSet';
    FontDescriptorCIDSet = 'CIDSet';
    FontDescriptorDescent = 'Descent';
    FontDescriptorFamily = 'FontFamily';
    FontDescriptorFlags = 'Flags';
    FontDescriptorItalicAngle = 'ItalicAngle';
    FontDescriptorLeading = 'Leading';
    FontDescriptorMaxWidth = 'MaxWidth';
    FontDescriptorMissingWidth = 'MissingWidth';
    FontDescriptorStemH = 'StemH';
    FontDescriptorStemV = 'StemV';
    FontDescriptorWeight = 'FontWeight';
    FontDescriptorWeightNormal = 400;
    FontDescriptorWeightRegular = 'Regular';
    FontDescriptorXHeight = 'XHeight';
    FontFile = 'FontFile';
    FontFile2 = 'FontFile2';
    FontFile3 = 'FontFile3';
    FontFileDictionaryKey = 'FontFile';
    FontMatrix = 'FontMatrix';
    FontMMType1 = 'MMType1';
    FontMTSuffix = 'MT';
    FontName = 'FontName';
    FontStretch = 'FontStretch';
    FontType0 = 'Type0';
    FontType1 = 'Type1';
    FontType3 = 'Type3';
    Form = 'Form';
    FormType = 'FormType';
    FreeTextAnnotation = 'FreeText';
    FreeTextAnnotationDefaultStyle = 'DS';
    Functions = 'Functions';
    FunctionType = 'FunctionType';
    Gamma = 'Gamma';
    Group = 'Group';
    GroupType = 'G';
    Height = 'Height';
    HelveticaBoldFontName = 'Helvetica-Bold';
    HelveticaBoldObliqueFontName = 'Helvetica-BoldOblique';
    HelveticaFontName = 'Helvetica';
    HelveticaObliqueFontName = 'Helvetica-Oblique';
    HighlightAnnotation = 'Highlight';
    IconFitFitToAnnotationBounds = 'FB';
    IconFitPosition = 'A';
    IconFitScalingCircumstances = 'SW';
    IconFitScalingType = 'S';
    ID = 'ID';
    Identity = 'Identity';
    IdentityH = 'Identity-H';
    IdentityV = 'Identity-V';
    ImageMask = 'ImageMask';
    Info = 'Info';
    InkAnnotation = 'Ink';
    InkList = 'InkList';
    InlineImageBegin = 'BI';
    InlineImageData = 'ID';
    InlineImageEnd = 'EI';
    Intent = 'Intent';
    InteriorColor = 'IC';
    Interpolate = 'Interpolate';
    IsOpen = 'Open';
    Italic = 'Italic';
    JBIG2Globals = 'JBIG2Globals';
    Keywords = 'Keywords';
    Kids = 'Kids';
    LastChar = 'LastChar';
    LastModified = 'LastModified';
    Length = 'Length';
    Length1 = 'Length1';
    Length2 = 'Length2';
    Length3 = 'Length3';
    LineAnnotation = 'Line';
    LineAnnotationCaptionOffsets = 'CO';
    LineAnnotationCaptionPosition = 'CP';
    LineAnnotationLeaderLineExtensionsLength = 'LLE';
    LineAnnotationLeaderLineOffset = 'LLO';
    LineAnnotationLeaderLinesLength = 'LL';
    LineAnnotationShowCaption = 'Cap';
    LineCap = 'LC';
    LineEnding = 'LE';
    LineJoinStyle = 'LJ';
    LineStyle = 'D';
    LineWidth = 'LW';
    Location = 'Location';
    Lock = 'Lock';
    LZWDecode = 'LZWDecode';
    Marked = 'Marked';
    MarkupAnnotationCreationDate = 'CreationDate';
    MarkupAnnotationIntent = 'IT';
    MarkupAnnotationOpacity = 'CA';
    MarkupAnnotationRichText = 'RC';
    MarkupAnnotationSubject = 'Subj';
    MarkupAnnotationTitle = 'T';
    Mask = 'Mask';
    MaskStyle = 'S';
    Matrix = 'Matrix';
    Matte = 'Matte';
    MaxLength = 'MaxLen';
    Measure = 'Measure';
    MediaBox = 'MediaBox';
    Metadata = 'Metadata';
    MiterLimit = 'ML';
    ModDate = 'ModDate';
    Modified = 'M';
    Movie = 'Movie';
    Name = 'Name';
    Names = 'Names';
    NeedAppearances = 'NeedAppearances';
    NonStrokingColorAlpha = 'ca';
    NumberFormatConversionFactor = 'C';
    NumberFormatDecimalDelimiter = 'RD';
    NumberFormatDigitalGroupingDelimiter = 'RT';
    NumberFormatDisplayFormat = 'F';
    NumberFormatLabel = 'U';
    NumberFormatLabelPosition = 'O';
    NumberFormatPrecision = 'D';
    NumberFormatPrefix = 'PS';
    NumberFormatSuffix = 'SS';
    NumberFormatTruncateLowOrderZeros = 'FD';
    ObjectStream = 'ObjStm';
    Oblique = 'Oblique';
    OffStateName = 'Off';
    OpenAction = 'OpenAction';
    OpenTypeFont = 'OpenType';
    Order = 'Order';
    Ordering = 'Ordering';
    Outline = 'Outline';
    OutlineAction = 'A';
    OutlineColor = 'C';
    OutlineCount = 'Count';
    OutlineDestination = Destination;
    OutlineFirst = 'First';
    OutlineFlags = 'F';
    OutlineLast = 'Last';
    OutlineNext = 'Next';
    OutlinePrev = 'Prev';
    Outlines = 'Outlines';
    OutlineTitle = 'Title';
    OwnerPasswordHash = 'O';
    Padding = 'RD';
    Page = 'Page';
    Pages = 'Pages';
    PaintType = 'PaintType';
    Parent = 'Parent';
    Pattern = 'Pattern';
    PatternType = 'PatternType';
    Permissions = 'P';
    PolygonAnnotation = 'Polygon';
    PolyLineAnnotation = 'PolyLine';
    Predictor = 'Predictor';
    PreferredZoom = 'PZ';
    Process = 'Process';
    Producer = 'Producer';
    QuadPoints = 'QuadPoints';
    Range = 'Range';
    Reason = 'Reason';
    Rect = 'Rect';
    RectilinearMeasureAngleNumberFormats = 'T';
    RectilinearMeasureAreaNumberFormats = 'A';
    RectilinearMeasureDistanceNumberFormats = 'D';
    RectilinearMeasureLineSlopeNumberFormats = 'S';
    RectilinearMeasureOrigin = 'O';
    RectilinearMeasureScaleRatio = 'R';
    RectilinearMeasureXAxisNumberFormats = 'X';
    RectilinearMeasureYAxisNumberFormats = 'Y';
    RectilinearMeasureYToXFactor = 'CYX';
    RedactAnnotation = 'Redact';
    Registry = 'Registry';
    Resources = 'Resources';
    Revision = 'R';
    RichTextData = 'RV';
    Root = 'Root';
    Rotate = 'Rotate';
    Shading = 'Shading';
    ShadingType = 'ShadingType';
    ShortAction = 'A';
    ShortBitsPerComponent = 'BPC';
    ShortColorSpace = 'CS';
    ShortDecode = 'D';
    ShortDecodeParameters = 'DP';
    ShortDefaultValue = 'DV';
    ShortFilter = 'F';
    ShortHeight = 'H';
    ShortImageMask = 'IM';
    ShortInterpolate = 'I';
    ShortPage = 'P';
    ShortRotationAngle = 'R';
    ShortValue = 'V';
    ShortWidth = 'W';
    ShortWidths = 'W';
    SigFlags = 'SigFlags';
    Size = 'Size';
    SMaskInData = 'SMaskInData';
    SmoothnessTolerance = 'SM';
    SoftMask = 'SMask';
    SquareAnnotation = 'Square';
    SquigglyAnnotation = 'Squiggly';
    StampAnnotation = 'Stamp';
    Standard = 'Standard';
    StandardEncoding = 'StandardEncoding';
    StandardFilterName = 'StdCF';
    StartXRef = 'startxref';
    State = 'State';
    StateModel = 'StateModel';
    StdCF = 'StdCF';
    Stream = 'stream';
    StreamCryptFilter = 'StmF';
    StrikeOutAnnotation = 'StrikeOut';
    StringCryptFilter = 'StrF';
    StrokingColorAlpha = 'CA';
    StructParent = 'StructParent';
    StructParents = 'StructParents';
    SubFilter = 'SubFilter';
    Subject = 'Subject';
    Subtype = 'Subtype';
    Supplement = 'Supplement';
    Suspects = 'Suspects';
    SymbolFontName = 'Symbol';
    Text = 'T';
    TextAlternate = 'TU';
    TextAnnotation = 'Text';
    TextDefaultValue = 'DV';
    TextJustify = 'Q';
    TextKnockout = 'TK';
    TextMapping = 'TM';
    TextValue = 'V';
    TilingType = 'TilingType';
    TimesBoldFontName = 'Times-Bold';
    TimesBoldItalicFontName = 'Times-BoldItalic';
    TimesFontFamilyName = 'Times';
    TimesItalicFontName = 'Times-Italic';
    TimesNewRomanBoldFontName = 'TimesNewRoman,Bold';
    TimesNewRomanFontName = 'TimesNewRoman';
    TimesNewRomanFontName2 = 'Times New Roman';
    TimesNewRomanPSMTPrefix = 'TimesNewRomanPS';
    TimesRomanFontName = 'Times-Roman';
    Title = 'Title';
    ToUnicode = 'ToUnicode';
    Trailer = 'trailer';
    TransferFunction = 'TR';
    Transparency = 'Transparency';
    TrimBox = 'TrimBox';
    TrueType = 'TrueType';
    Type1C = 'Type1C';
    TypeKey = 'Type';
    UnderlineAnnotation = 'Underline';
    UseCMap = 'UseCMap';
    UserPasswordHash = 'U';
    UserProperties = 'UserProperties';
    UserUnit = 'UserUnit';
    Version = 'V';
    VersionSignature = '%PDF-';
    WhitePoint = 'WhitePoint';
    Width = 'Width';
    Widths = 'Widths';
    WinAnsiEncoding = 'WinAnsiEncoding';
    WMode = 'WMode';
    XFA = 'XFA';
    XObject = 'XObject';
    XObject2 = 'Xobject';
    XStep = 'XStep';
    XYZDestination = 'XYZ';
    YStep = 'YStep';
    ZapfDingbatsFontName = 'ZapfDingbats';
  {$ENDREGION}
  end;

  { TdxPDFStream }

  TdxPDFStream = class(TdxPDFBaseStream)
  strict private
    FEncryptionInfo: IdxPDFEncryptionInfo;
    FDictionary: TdxPDFDictionary;
    //
    function GetDecryptedData: TBytes;
    function GetUncompressedData: TBytes;
    procedure SetDictionary(const AValue: TdxPDFDictionary);
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
  public
    constructor Create(const AData: TBytes; ADictionary: TdxPDFDictionary); reintroduce; overload;
    constructor Create(const AData: TBytes; ADictionary: TdxPDFDictionary; AEncryptionInfo: IdxPDFEncryptionInfo); reintroduce; overload;
    destructor Destroy; override;
    //
    function UncompressData(ADecryptData: Boolean): TBytes; overload;  // for internal uses
    function UncompressData(AFilters: TObject; ADecryptData: Boolean): TBytes; overload; // for internal uses
    //
    property DecryptedData: TBytes read GetDecryptedData;
    property Dictionary: TdxPDFDictionary read FDictionary write SetDictionary;
    property EncryptionInfo: IdxPDFEncryptionInfo read FEncryptionInfo write FEncryptionInfo;
    property UncompressedData: TBytes read GetUncompressedData;
  end;

  { TdxPDFTransformationMatrix }

  TdxPDFTransformationMatrix = record
  private
    FMatrix: TdxNullableValue<TXForm>;
    //
    function GetA: Single;
    function GetB: Single;
    function GetC: Single;
    function GetD: Single;
    function GetE: Single;
    function GetF: Single;
    function GetDistanceToX: Single;
    function GetDistanceToY: Single;
    function GetDeterminant: Single;
    function GetIsInvertable: Boolean;
    function GetIsRotated: Boolean;
    function GetXForm: TXForm;
    procedure SetXForm(const AValue: TXForm);
    //
    procedure DoMultiply(const AXForm: TXForm; AOrder: TdxTransformationOrder = moPrepend);
  public
    class function Create: TdxPDFTransformationMatrix; overload; static;
    class function Create(const M: TdxPDFTransformationMatrix): TdxPDFTransformationMatrix; overload; static;
    class function Create(M11, M12, M21, M22, DX, DY: Single): TdxPDFTransformationMatrix; overload; static;
    class function CreateRotate(ADegree: Single): TdxPDFTransformationMatrix; static;
    class function CreateScale(AScaleX, AScaleY: Single): TdxPDFTransformationMatrix; static;
    class function Invert(const M: TdxPDFTransformationMatrix): TdxPDFTransformationMatrix; static;
    class function Multiply(const M1, M2: TdxPDFTransformationMatrix): TdxPDFTransformationMatrix; overload; static;
    class function Null: TdxPDFTransformationMatrix; static;
    class function Rotate(const M: TdxPDFTransformationMatrix; ADegree: Single): TdxPDFTransformationMatrix; static;
    class function Translate(const M: TdxPDFTransformationMatrix; const AOffset: TdxPointF): TdxPDFTransformationMatrix; overload; static;
    //
    function Equals(const M: TdxPDFTransformationMatrix): Boolean;
    function IsIdentity: Boolean;
    function IsNull: Boolean;
    function Transform(const APoint: TdxPointF): TdxPointF; overload;
    function Transform(const ARect: TdxPDFRectangle): TdxPDFRectangle; overload;
    function TransformBoundingBox(const ARect: TdxPDFRectangle): TdxPDFRectangle;
    function TransformPoints(const APoints: TdxPDFPoints): TdxPDFPoints;
    procedure Assign(const M: TdxPDFTransformationMatrix); overload;
    procedure Assign(M11, M12, M21, M22, DX, DY: Single); overload;
    procedure Multiply(const M: TdxPDFTransformationMatrix; AOrder: TdxTransformationOrder = moPrepend); overload;
    procedure Reset;
    procedure Translate(DX, DY: Single; AOrder: TdxTransformationOrder = moPrepend); overload;
    procedure Write(AWriter: TdxPDFWriter);
    //
    property A: Single read GetA;
    property B: Single read GetB;
    property C: Single read GetC;
    property D: Single read GetD;
    property E: Single read GetE;
    property F: Single read GetF;
    property DistanceToX: Single read GetDistanceToX;
    property DistanceToY: Single read GetDistanceToY;
    property IsInvertable: Boolean read GetIsInvertable;
    property IsRotated: Boolean read GetIsRotated;
    property XForm: TXForm read GetXForm write SetXForm;
  end;

  { TdxPDFDictionary }

  TdxPDFDictionary = class(TdxPDFBase) // for internal use
  strict private
    FEncryptionInfo: IdxPDFEncryptionInfo;
    FStreamRef: TdxPDFStream;
    //
    function GetLineEndingStyle(const AValue: string): TdxPDFAnnotationLineEndingStyle;
    function GetValue(const AKey: string): TdxPDFBase;
    procedure SetValue(const AKey: string; AValue: TdxPDFBase);
    function TryGetValue<T: TdxPDFBase>(const AKey: string; out AValue: T): Boolean;
    procedure ParseDateTimeComponent(var ADateTime: string; AComponent: PInteger; ADefaultValue: Byte = 0);
  strict protected
    FDictionary: TdxPDFCustomReferencedObjectDictionary<string, TdxPDFBase>;
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure ResolveArrayElements(AArray: TdxPDFArray); virtual;
    procedure Write(AWriter: TdxPDFWriter); override;
    procedure WriteContent(AWriter: TdxPDFWriter);
    procedure WriteStream(AWriter: TdxPDFWriter); virtual;
    procedure WriteStreamData(AWriter: TdxPDFWriter; const AData: TBytes);
    //
    function GetCount: Integer;
    function ParseDateTime(ADateTime: string): TDateTime;
  public type
    TEnumKeyProc = reference to procedure (const AKey: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    function GetObject(const AKey: string): TdxPDFBase; virtual;
    function Contains(const AKey: string): Boolean;
    procedure EnumKeys(AProc: TEnumKeyProc);
    procedure Remove(const AKey: string);
    //
    procedure Add(const AKey: string; const AValue, ADefaultValue: Double); overload;
    procedure Add(const AKey: string; AValue, ADefaultValue: Integer); overload;
    procedure Add(const AKey: string; AValue, ADefaultValue: Boolean); overload;
    procedure Add(const AKey: string; AValue: Boolean); overload;
    procedure Add(const AKey: string; const AValue: Double); overload;
    procedure Add(const AKey: string; AValue: Integer); overload;
    procedure Add(const AKey: string; AValue: TdxPDFBase); overload;
    procedure Add(const AKey: string; const AMatrix: TdxPDFTransformationMatrix; ASkipNullOrIdentity: Boolean = True); overload;
    procedure Add(const AKey: string; const AValue, ADefaultValue: TdxRectF); overload;
    procedure Add(const AKey: string; const AValue: string); overload;
    procedure Add(const AKey: string; const AValue, ADefaultValue: string); overload;
    procedure Add(const AKey: string; const AValue: string; AEncoding: TEncoding); overload;
    procedure Add(const AKey: string; const AValue: TBytes); overload;
    procedure Add(const AKey: string; const AValue: TDoubleDynArray; ASkipIfNull: Boolean = True); overload;
    procedure Add(const AKey: string; const AValue: TStringDynArray); overload;
    procedure Add(const AKey: string; const AValue: TdxPDFRanges); overload;
    procedure Add(const AKey: string; const AValue: TdxPDFRectangle; ASkipIfNull: Boolean = True); overload;
    procedure Add(const AKey: string; const AValue: TdxRectF; ACheckRect: Boolean = True; ASkipIfNull: Boolean = True); overload;
    procedure Add(const AKey: string; const AValue: TIntegerDynArray); overload;
    procedure Add(const AKey: string; const AStart, AFinish: TdxPDFAnnotationLineEndingStyle); overload;
    procedure Add(const AKey: string; const AValue: TdxPDFSignatureFlags); overload;
    procedure Add(const AKey: string; const AValue: TdxPointF); overload;
    procedure Add(const AKey: string; const AValue: TdxPointsF); overload;
    procedure AddBytes(const AKey: string; const AValue: TBytes);
    procedure AddDate(const AKey: string; AValue: TDateTime);
    procedure AddName(const AKey: string; const AValue: string; ASkipIfNull: Boolean = True); overload;
    procedure AddName(const AKey: string; const AValue: TdxPDFRenderingIntent); overload;
    procedure AddQuadrilateralArray(const AValue: TdxPDFQuadrilateralArray);
    procedure AddReference(const AKey: string; ANumber: Integer; AGeneration: Integer = 0); overload;
    procedure AddReference(const AKey: string; const AData: TBytes; ASkipIfNull: Boolean = True); overload; virtual;
    procedure Clear;
    //
    function CreateNumericList(const AKey: string): TDoubleDynArray;
    function GetArray(const AKey: string): TdxPDFArray; overload;
    function GetArray(const AKey, AAlternativeKey: string): TdxPDFArray; overload;
    function GetArray(const AKey: string; out AArray: TdxPDFArray): Boolean; overload;
    function GetBoolean(const AKey: string; ADefaultValue: Boolean = False): Boolean;
    function GetBytes(const AKey: string): TBytes;
    function GetDate(const AKey: string): TDateTime;
    function GetDictionary(const AKey: string): TdxPDFDictionary;
    function GetDouble(const AKey: string; ADefaultValue: Double = dxPDFInvalidValue): Double;
    function GetDoubleArray(const AKey: string): TDoubleDynArray;
    function GetInteger(const AKey, AAlternativeKey: string): Integer; overload;
    function GetInteger(const AKey: string; ADefaultValue: Integer = dxPDFInvalidValue): Integer; overload;
    function GetMatrix(const AKey: string): TdxPDFTransformationMatrix;
    function GetPadding(const ABounds: TdxPDFRectangle): TdxPDFRectangle;
    function GetPoints(const AKey: string): TdxPointsF;
    function GetQuadrilateralArray: TdxPDFQuadrilateralArray;
    function GetRectangle(const AKey: string): TdxRectF; overload;
    function GetRectangle(const AKey: string; const ADefaultValue: TdxRectF): TdxRectF; overload;
    function GetRectangleEx(const AKey: string): TdxPDFRectangle;
    function GetRenderingIntent(const AKey: string): TdxPDFRenderingIntent;
    function GetSignatureFlags(const AKey: string): TdxPDFSignatureFlags;
    function GetSmallInt(const AKey: string; ADefaultValue: SmallInt): SmallInt;
    function GetStream(const AKey: string): TdxPDFStream;
    function GetString(const AKey, ADefaultValue: string): string; overload;
    function GetString(const AKey: string): string; overload;
    function GetTextString(const AKey: string): string; overload;
    function GetTextString(const AKey, ADefaultValue: string): string; overload;
    //
    function TryGetArray(const AKey: string; out AValue: TdxPDFArray): Boolean; virtual;
    function TryGetBoolean(const AKey: string; out AValue: Boolean): Boolean;
    function TryGetDictionary(const AKey: string; out AValue: TdxPDFDictionary): Boolean;
    function TryGetLineEndingStyle(out AStart, AFinish: TdxPDFAnnotationLineEndingStyle): Boolean;
    function TryGetObject(const AKey: string; out AValue: TdxPDFBase): Boolean;
    function TryGetReference(const AKey: string; out AValue: Integer): Boolean;
    function TryGetStream(const AKey: string; out AValue: TdxPDFStream): Boolean;
    function TryGetString(const AKey: string; out AValue: string): Boolean;
    function TryGetTextString(const AKey: string; out AValue: string): Boolean;
    //
    property Count: Integer read GetCount;
    property EncryptionInfo: IdxPDFEncryptionInfo read FEncryptionInfo;
    property StreamRef: TdxPDFStream read FStreamRef write FStreamRef;
    property Value[const AKey: string]: TdxPDFBase read GetValue write SetValue; default;
  end;

  { TdxPDFValue }

  TdxPDFValue = class(TdxPDFBase)
  strict private
    FValue: Variant;
  protected
    procedure InternalSetValue(const AValue: Variant);

    property InternalValue: Variant read FValue;
  public
    constructor Create(ANumber, AGeneration: Integer; const AValue: Variant); reintroduce; overload;
    constructor Create(const AValue: Variant); reintroduce; overload;
  end;

  { TdxPDFBoolean }

  TdxPDFBoolean = class(TdxPDFValue)
  strict private
    function GetValue: Boolean; inline;
    procedure SetValue(const AValue: Boolean);
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
  public
    property Value: Boolean read GetValue write SetValue;
  end;

  { TdxPDFNull }

  TdxPDFNull = class(TdxPDFValue)
  strict private
    function GetValue: Variant; inline;
  protected
    procedure Write(AWriter: TdxPDFWriter); override;
  public
    property Value: Variant read GetValue;
  end;

  { TdxPDFCustomBytes }

  TdxPDFCustomBytes = class(TdxPDFValue)
  protected
    FData: TBytes;

    procedure Write(AWriter: TdxPDFWriter); override;
  public
    constructor Create(const AValue: TBytes); reintroduce;
  end;

  { TdxPDFBytes }

  TdxPDFBytes = class(TdxPDFCustomBytes)
  protected
    procedure Write(AWriter: TdxPDFWriter); override;
  end;

  { TdxPDFPlaceHolder }

  TdxPDFPlaceHolder = class(TdxPDFCustomBytes)
  strict private
    FOffset: Int64;
    function GetSize: Int64;
  protected
    procedure Write(AWriter: TdxPDFWriter); override;
  public
    constructor Create(ALength: Int64); reintroduce;
    function IsValid: Boolean;
    //
    property Size: Int64 read GetSize;
    property Offset: Int64 read FOffset;
  end;

  { TdxPDFSpecialBytes }

  TdxPDFSpecialBytes = class(TdxPDFCustomBytes);

  { TdxPDFString }

  TdxPDFString = class(TdxPDFValue)
  strict private
    function GetText: string;
    function GetValue: string;
    procedure SetValue(const AValue: string);
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
  public
    property Text: string read GetText;
    property Value: string read GetValue write SetValue;
  end;

  { TdxPDFComment }

  TdxPDFComment = class(TdxPDFString)
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
  end;

  { TdxPDFName }

  TdxPDFName = class(TdxPDFString)
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
  end;

  { TdxPDFNumericObject }

  TdxPDFNumericObject = class(TdxPDFValue)
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
    function GetValue: Variant; inline;
  end;

  { TdxPDFInteger }

  TdxPDFInteger = class(TdxPDFNumericObject)
  strict private
    function GetValue: Integer;
    procedure SetValue(const AValue: Integer);
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
  public
    property Value: Integer read GetValue write SetValue;
  end;

  { TdxPDFDouble }

  TdxPDFDouble = class(TdxPDFNumericObject)
  strict private
    function GetValue: Double;
    procedure SetValue(const AValue: Double);
  public
    property Value: Double read GetValue write SetValue;
  end;

  { TdxPDFReference }

  TdxPDFReference = class(TdxPDFBase)
  strict private
    FIsFree: Boolean;
    FIsSlot: Boolean;
    FOffset: Int64;
  protected
    class function GetObjectType: TdxPDFBaseType; override;
    procedure Write(AWriter: TdxPDFWriter); override;
  public
    constructor Create(ANumber, AGeneration: Integer; AOffset: Int64 = 0; AIsFree: Boolean = False;
      AIsSlot: Boolean = False); reintroduce;

    property IsFree: Boolean read FIsFree;
    property IsSlot: Boolean read FIsSlot;
    property Offset: Int64 read FOffset write FOffset;
  end;

  { TdxPDFIndirectObject }

  TdxPDFIndirectObject = class(TdxPDFBase)
  strict private
    FData: TBytes;
  protected
    class function GetObjectType: TdxPDFBaseType; override;
  public
    constructor Create(ANumber, AGeneration: Integer; const AData: TBytes);
    destructor Destroy; override;

    property Data: TBytes read FData;
  end;

  { TdxPDFTokenDescription }

  TdxPDFTokenDescription = class
  strict private
    FCurrentComparingSymbol: Byte;
    FIndexToCompare: Integer;
    FSequence: TBytes;
    FSequenceLength: Integer;
  public
    constructor Create(const ADescription: string); overload;
    constructor Create(const ASequence: TBytes); overload;

    class function BeginCompare(AToken: TdxPDFTokenDescription): TdxPDFTokenDescription; overload; inline;
    function IsStartWithComment: Boolean; inline; 
    function Compare(ASymbol: Byte): Boolean; inline;
    procedure Reset; overload; inline;

    property Sequence: TBytes read FSequence;
    property SequenceLength: Integer read FSequenceLength;
  end;

  { TdxPDFStreamElement }

  TdxPDFStreamElement = class(TdxPDFReference)
  strict private
    FIndex: Integer;
  protected
    class function GetObjectType: TdxPDFBaseType; override;
  public
    constructor Create(ANumber: Integer; AIndex: Integer);

    property Index: Integer read FIndex;
  end;

  { TdxPDFCustomRepository }

  TdxPDFCustomRepository = class(TdxPDFReferencedObject)
  strict private
    FReferences: TdxPDFBaseReferences;
    function GetMaxObjectNumber: Integer;
  protected
    function ResolveObject(ANumber: Integer): TdxPDFReferencedObject; virtual;
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;

    procedure Replace(ANumber: Integer; AObject: TdxPDFReferencedObject);
    procedure TryAdd(ANumber: Integer; AObject: TdxPDFReferencedObject; ACanReplace: Boolean);

    property References: TdxPDFBaseReferences read FReferences;
  public
    constructor Create;
    destructor Destroy; override;

    function DecryptString(const S: string): string; virtual;

    function GetArray(ANumber: Integer): TdxPDFArray;
    function GetDictionary(ANumber: Integer): TdxPDFDictionary;
    function GetInteger(ANumber: Integer): TdxPDFInteger;
    function GetNumericObject(ANumber: Integer): TdxPDFNumericObject;
    function GetObject(ANumber: Integer): TdxPDFReferencedObject;
    function GetStream(ANumber: Integer): TdxPDFStream;
    function ResolveReference(AObject: TdxPDFBase): TdxPDFBase;

    procedure Add(ANumber: Integer; AObject: TdxPDFReferencedObject; ACanReplace: Boolean = True);
    procedure Clear; virtual;
    procedure Remove(ANumber: Integer);
    procedure TrimExcess;

    property MaxObjectNumber: Integer read GetMaxObjectNumber;
  end;

  { TdxPDFColor }

  TdxPDFColor = record
  strict private
    FComponents: TDoubleDynArray;
    FPattern: TdxPDFReferencedObject;
    FIsNull: Boolean;

    procedure AddComponent(const AValue: Double);
    procedure SetPattern(const AValue: TdxPDFReferencedObject);
  public
    class function Create: TdxPDFColor; overload; static;
    class function Create(APattern: TdxPDFReferencedObject; const AComponents: TDoubleDynArray): TdxPDFColor; overload; static;
    class function Create(const AArray: TdxPDFArray): TdxPDFColor; overload; static;
    class function Create(const AColor: TColor): TdxPDFColor; overload; static;
    class function Create(const AColor: TdxPDFColor): TdxPDFColor; overload; static;
    class function Create(const X, Y, Z, AWhitePointZ: Double): TdxPDFColor; overload; static;
    class function Create(const C1: Double): TdxPDFColor; overload; static;
    class function Create(const C1, C2, C3: Double): TdxPDFColor; overload; static;
    class function Create(const AComponents: TDoubleDynArray): TdxPDFColor; overload; static;
    class function ClipColorComponent(const AComponent: Double): Double; static;
    class function ColorComponentTransferFunction(const AComponent: Double): Double; static;
    class function GetComponents(const X, Y, Z, AWhitePointZ: Double): TDoubleDynArray; static;
    class function Null: TdxPDFColor; static;

    procedure Assign(const AColor: TdxPDFColor);
    procedure AssignAndTransferComponents(const AComponents: TDoubleDynArray);
    function IsNull: Boolean;
    function ToColor: TColor;

    property Components: TDoubleDynArray read FComponents;
    property Pattern: TdxPDFReferencedObject read FPattern write SetPattern;
  end;

  { TdxPDFARGBColor }

  TdxPDFARGBColor = record
  private
    FAlpha: Byte;
    FBlue: Double;
    FGreen: Double;
    FRed: Double;
    //
    FIsNull: Boolean;
  public
    class function Create(AColor: TColor): TdxPDFARGBColor; overload; static;
    class function Create(const AColor: TdxPDFColor): TdxPDFARGBColor; overload; static;
    class function Create(const ARed, AGreen, ABlue: Double; AAlpha: Byte = 1): TdxPDFARGBColor; overload; static;
    class function CreateFromCMYK(const ACyan, AMagenta, AYellow, ABlack: Double): TdxPDFARGBColor; overload; static;
    class function Convert(const AColor: TdxPDFARGBColor): TdxPDFColor; static;
    class function ConvertToBytes(ACyan, AMagenta, AYellow, ABlack: Byte): TBytes; inline; static;
    class function ConvertToRGB(const AData: TBytes; APixelFormat: TdxPDFPixelFormat): TBytes; static;
    class function Null: TdxPDFARGBColor; static;
    function IsNull: Boolean;
    function ToPDFColor: TdxPDFColor;

    property Alpha: Byte read FAlpha;
    property Blue: Double read FBlue;
    property Green: Double read FGreen;
    property Red: Double read FRed;
  end;

  { TdxPDFCustomProperties }

  TdxPDFCustomProperties = class(TdxPDFBase)
  strict private
    FDictionary: TdxPDFDictionary;

    procedure SetDictionary(const AValue: TdxPDFDictionary);
  protected
    procedure Write(AWriter: TdxPDFWriter); override;
    //
    property Dictionary: TdxPDFDictionary read FDictionary write SetDictionary;
  public
    constructor Create(ADictionary: TdxPDFDictionary);
    destructor Destroy; override;
  end;

  { TdxPDFBlendModeDictionary }

  TdxPDFBlendModeDictionary = class
  strict private const
    Map: array[TdxPDFBlendMode] of string = (
      'Normal', 'Compatible', 'Multiply', 'Screen', 'Overlay', 'Darken', 'Lighten', 'ColorDodge',
      'ColorBurn', 'HardLight', 'SoftLight', 'Difference', 'Exclusion', 'Hue', 'Saturation', 'Color', 'Luminosity'
    );
  public
    class function ToString(AValue: TdxPDFBlendMode): string; reintroduce;
    class function ToValue(const AString: string): TdxPDFBlendMode;
    class function TryGetValue(const AKey: string; out AValue: TdxPDFBlendMode): Boolean;
  end;

  { TdxPDFCommandOperandStack }

  TdxPDFCommandOperandStack = class(TdxPDFReferencedObject) // for internal use
  strict private
    FStack: TdxObjectStack<TdxPDFBase>;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function TryPopLastName: string;
    function PopAsArray: TdxPDFArray;
    function PopAsBytes: TBytes;
    function PopAsInteger: Integer;
    function PopAsObject: TdxPDFBase;
    function PopAsSingle: Single;
    function PopAsString: string;
    procedure Clear;
    procedure Push(AObject: TdxPDFBase);

    property Count: Integer read GetCount;
  end;

  { TdxPDFFontMetricsMetadata }

  TdxPDFFontMetricsMetadata = record
  strict private
    FAscent: Double;
    FDescent: Double;
    FEmSize: Double;
    FLineSpacing: Double;
    FIsNull: Boolean;
    function GetHeight: Double;
  public
    class function Create: TdxPDFFontMetricsMetadata; overload; static;
    class function Create(const AAscent, ADescent, AEmSize, ACalculatedLineSpacing: Double): TdxPDFFontMetricsMetadata; overload; static;
    function IsNull: Boolean;

    property Ascent: Double read FAscent;
    property Descent: Double read FDescent;
    property EmSize: Double read FEmSize;
    property Height: Double read GetHeight;
    property LineSpacing: Double read FLineSpacing;
  end;

  { TdxPDFLineStyle }

  TdxPDFLineStyle = class(TdxPDFReferencedObject) // for internal use
  strict private
    FPattern: TDoubleDynArray;
    FPhase: Double;
    //
    function AsDouble(AValue: TdxPDFReferencedObject): Double;
    procedure ReadPattern(APattern: TdxPDFArray);
  protected
    function Write: TdxPDFArray;
    function WritePattern: TdxPDFArray;
  public
    constructor Create(const APattern: TDoubleDynArray; APhase: Double); reintroduce; overload;
    constructor Create(APattern: TdxPDFReferencedObject); reintroduce; overload;
    constructor Create(APattern, APhase: TdxPDFReferencedObject); reintroduce; overload;
    constructor Create(AParameters: TdxPDFArray); reintroduce; overload;
    //
    function IsDashed: Boolean;
    //
    property Pattern: TDoubleDynArray read FPattern;
    property Phase: Double read FPhase;
  end;

function dxPDFChangeValue(AValue: TdxPDFReferencedObject; var ACurrentValue: TdxPDFReferencedObject): Boolean; inline;
function dxPDFGenerateDocumentID: TdxPDFDocumentID;
procedure dxPDFFreeObject(AObject: TdxPDFReferencedObject);

implementation

uses
  System.UITypes,
  Contnrs, StrUtils, Variants, cxVariants, dxCharacters, dxHash, dxStringHelper, cxDateUtils, dxGDIPlusAPI,
  dxPDFStreamFilter, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFTypes';

type
  TdxPDFBaseAccess = class(TdxPDFBase);

function dxPDFChangeValue(AValue: TdxPDFReferencedObject; var ACurrentValue: TdxPDFReferencedObject): Boolean;
var
  APreviousValue: TdxPDFReferencedObject;
begin
  Result := ACurrentValue <> AValue;
  if Result then
  begin
    APreviousValue := ACurrentValue;
    ACurrentValue := AValue;

    if ACurrentValue <> nil then
      ACurrentValue.Reference;

    if APreviousValue <> nil then
      APreviousValue.Release;
  end;
end;

function dxPDFGenerateDocumentID: TdxPDFDocumentID;

  function Generate: TBytes;
  var
    I: Integer;
    S: string;
  begin
    SetLength(Result, 16);
    S := LowerCase(dxMD5CalcStr(dxGenerateGUID));
    for I := 0 to 15 do
      Result[I] := StrToInt('$' + S[2 * I + 1] + S[2 * (I + 1)]);
  end;

begin
  Result[0] := Generate;
  Result[1] := Generate;
end;

procedure dxPDFFreeObject(AObject: TdxPDFReferencedObject);
begin
  dxPDFChangeValue(nil, AObject);
end;

{ TdxPDFOrientedRectHelper }

class function TdxPDFOrientedRectHelper.Create: TdxPDFOrientedRect;
begin
  Result := Invalid;
end;

class function TdxPDFOrientedRectHelper.Create(const ATopLeft: TdxPointF;
  AWidth, AHeight, AAngle: Single): TdxPDFOrientedRect;
begin
  Result.Angle := TdxPDFUtils.NormalizeAngle(AAngle);
  Result.Top := ATopLeft.Y;
  Result.Left := ATopLeft.X;
  Result.Width := AWidth;
  Result.Height := AHeight;
end;

class function TdxPDFOrientedRectHelper.Create(const ARect: TdxRectF): TdxPDFOrientedRect;
begin
  Result := Create(ARect, 0);
end;

class function TdxPDFOrientedRectHelper.Create(const ARect: TdxPDFRectangle): TdxPDFOrientedRect;
begin
  Result := Create(TdxRectF.Create(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom), 0);
end;

class function TdxPDFOrientedRectHelper.Create(const ARect: TdxRectF; AAngle: Single): TdxPDFOrientedRect;
begin
  Result.Angle := AAngle;
  Result.Top := ARect.Top;
  Result.Left := ARect.Left;
  Result.Width := Abs(ARect.Width);
  Result.Height := Abs(ARect.Height);
end;

class function TdxPDFOrientedRectHelper.Invalid: TdxPDFOrientedRect;
begin
  Result.Angle := -1;
  Result.Top := -1;
  Result.Left := -1;
  Result.Width := -1;
  Result.Height := -1;
end;

function TdxPDFOrientedRectHelper.GetTopLeft: TdxPointF;
begin
  Result := dxPointF(Left, Top);
end;

function TdxPDFOrientedRectHelper.GetBottom: Single;
begin
  Result := Top + Width * Sin(Angle) - Height * Cos(Angle);
end;

function TdxPDFOrientedRectHelper.GetBottomLeft: TdxPointF;
begin
  Result := dxPointF(Left, Bottom);
end;

function TdxPDFOrientedRectHelper.GetBoundingRect: TdxPDFRectangle;
var
  APoints: TdxPointsF;
  ARotatedLeft, ARotatedTop, ARotatedBottom: Double;
  ATopLeft, ARotatedTopLeft: TdxPointF;
begin
  ATopLeft := TopLeft;
  ARotatedTopLeft := TdxPDFUtils.RotatePoint(ATopLeft, -Angle);
  ARotatedLeft := ARotatedTopLeft.X;
  ARotatedTop := ARotatedTopLeft.Y;
  ARotatedBottom := ARotatedTop - Height;
  SetLength(APoints, 4);
  APoints[0] := ATopLeft;
  APoints[1] := TdxPDFUtils.RotatePoint(TdxPointF.Create(ARotatedLeft + Width, ARotatedTop), Angle);
  APoints[2] := TdxPDFUtils.RotatePoint(TdxPointF.Create(ARotatedLeft, ARotatedBottom), Angle);
  APoints[3] := TdxPDFUtils.RotatePoint(TdxPointF.Create(ARotatedLeft + Width, ARotatedBottom), Angle);
  Result := TdxPDFRectangle.Create(APoints);
end;

function TdxPDFOrientedRectHelper.GetRect: TdxRectF;
begin
  Result.Left := Left;
  Result.Top := Bottom;
  Result.Width := Width;
  Result.Height := Height;
end;

function TdxPDFOrientedRectHelper.GetRight: Single;
begin
  Result := Left + Width * Cos(Angle) + Height * Sin(Angle);
end;

function TdxPDFOrientedRectHelper.GetRotatedRect: TdxRectF;
var
  ARealTopLeft, ARotatedTopLeft, ARealTopRight, ARealBottomLeft, ARealBottomRight: TdxPointF;
begin
  ARealTopLeft := TopLeft;
  ARotatedTopLeft := TdxPDFUtils.RotatePoint(ARealTopLeft, -Angle);
  ARealTopRight := TdxPDFUtils.RotatePoint(dxPointF(ARotatedTopLeft.X + Width, ARotatedTopLeft.Y), Angle);
  ARealBottomLeft := TdxPDFUtils.RotatePoint(dxPointF(ARotatedTopLeft.X, ARotatedTopLeft.Y - Height), Angle);
  ARealBottomRight := TdxPDFUtils.RotatePoint(dxPointF(ARotatedTopLeft.X + Width, ARotatedTopLeft.Y - Height), Angle);

  Result.Left := Min(Min(ARealTopLeft.X, ARealTopRight.X), Min(ARealBottomLeft.X, ARealBottomRight.X));
  Result.Top := Min(Min(ARealTopLeft.Y, ARealTopRight.Y), Min(ARealBottomLeft.Y, ARealBottomRight.Y));
  Result.Right := Max(Max(ARealTopLeft.X, ARealTopRight.X), Max(ARealBottomLeft.X, ARealBottomRight.X));
  Result.Bottom := Max(Max(ARealTopLeft.Y, ARealTopRight.Y), Max(ARealBottomLeft.Y, ARealBottomRight.Y));
end;

function TdxPDFOrientedRectHelper.GetTopRight: TdxPointF;
var
  ARotatedTopLeft: TdxPointF;
begin
  ARotatedTopLeft := TdxPDFUtils.RotatePoint(TopLeft, -Angle);
  Result := TdxPDFUtils.RotatePoint(dxPointF(ARotatedTopLeft.X + Width, ARotatedTopLeft.Y), Angle);
end;

function TdxPDFOrientedRectHelper.CalculateBottomLeft(const ASin, ACos: Double): TdxPointF;
begin
  Result := dxPointF(Left + Height * ASin, Top - Height * ACos);
end;

function TdxPDFOrientedRectHelper.CalculateTopRight(const ASin, ACos: Double): TdxPointF;
begin
  Result := dxPointF(Left + Width * ACos, Top + Width * ASin);
end;

function TdxPDFOrientedRectHelper.GetVertices: TdxPointsF;
var
  ACos, ASin: Double;
begin
  ACos := Cos(Angle);
  ASin := Sin(Angle);
  SetLength(Result, 4);
  Result[0] := TopLeft;
  Result[1] := CalculateTopRight(ASin, ACos);
  Result[2] := TdxPointF.Create(Left + Width * ACos + Height * ASin, Top - Height * ACos + Width * ASin);
  Result[3] := CalculateBottomLeft(ASin, ACos);
end;

function TdxPDFOrientedRectHelper.IsValid: Boolean;
var
  AInvalidRect: TdxPDFOrientedRect;
begin
  AInvalidRect := Invalid;
  Result := (AInvalidRect.Angle <> Angle) and (AInvalidRect.Height <> Angle) and (AInvalidRect.Width <> Width);
end;

function TdxPDFOrientedRectHelper.Overlap(const R: TdxPDFOrientedRect): Boolean;
const
  Distance = 1;
begin
  Result := (Abs(R.Left - Left) < Distance) and (Abs(R.Top - Top) < Distance) and
    (Abs(R.Width - Width) < Distance) and (Abs(R.Height - Height) < Distance) and (Angle = R.Angle);
end;

function TdxPDFOrientedRectHelper.PtInRect(const APoint: TdxPointF; AExpandX: Single = 0; AExpandY: Single = 0): Boolean;
var
  ARotatedPoint, ARotatedTopLeft: TdxPointF;
begin
  ARotatedPoint := TdxPDFUtils.RotatePoint(APoint, -Angle);
  ARotatedTopLeft := TdxPDFUtils.RotatePoint(TopLeft, -Angle);
  Result := (((ARotatedPoint.X >= (ARotatedTopLeft.X - AExpandX)) and
    (ARotatedPoint.X <= (ARotatedTopLeft.X + Width + AExpandX))) and
    (ARotatedPoint.Y <= (ARotatedTopLeft.Y + AExpandY))) and
    (ARotatedPoint.Y >= (ARotatedTopLeft.Y - Height - AExpandY));
end;

{ TdxPDFFixedPointNumber }

class function TdxPDFFixedPointNumber.Create(AValue: Single): TdxPDFFixedPointNumber;
begin
  Result.FValue := Trunc(AValue * Result.FloatToFixedFactor);
end;

class operator TdxPDFFixedPointNumber.Add(const A, B: TdxPDFFixedPointNumber): TdxPDFFixedPointNumber;
begin
  Result := TdxPDFFixedPointNumber.Create(A.FValue + B.FValue);
end;

class operator TdxPDFFixedPointNumber.Multiply(A: Integer; const B: TdxPDFFixedPointNumber): TdxPDFFixedPointNumber;
begin
  Result := TdxPDFFixedPointNumber.Create(A * B.FValue);
end;

class function TdxPDFFixedPointNumber.Create(AValue: Integer): TdxPDFFixedPointNumber;
begin
  Result.FValue := AValue;
end;

function TdxPDFFixedPointNumber.RoundToByte: Byte;
var
  AActualValue: Integer;
begin
  AActualValue := (FValue + Half) shr FractionPartSize;
  Result := IfThen(AActualValue > 255, 255, AActualValue);
end;

{ TdxPDFNamedObjectDictionary }

constructor TdxPDFNamedObjectDictionary.Create(const AResourceKey: string; const APrefix: string);
begin
  inherited Create;
  FDictionary := TdxPDFStringIntegerDictionary.Create;
  FNextResourceNumber := 0;
  FResourceKey := AResourceKey;
  FPrefix := APrefix;
end;

destructor TdxPDFNamedObjectDictionary.Destroy;
begin
  FreeAndNil(FDictionary);
  inherited Destroy;
end;

function TdxPDFNamedObjectDictionary.GetNewResourceName(ADictionary: TdxPDFStringReferencedObjectDictionary): string;
begin
  Result := GetNewResourceName(ADictionary, FPrefix + IntToStr(FNextResourceNumber));
  Inc(FNextResourceNumber);
end;

function TdxPDFNamedObjectDictionary.GetNewResourceName(ADictionary: TdxPDFStringReferencedObjectDictionary;
  const AName: string): string;
begin
  Result := AName;
  while ADictionary.ContainsKey(Result) do
  begin
    Result := FPrefix + IntToStr(FNextResourceNumber);
    Inc(FNextResourceNumber);
  end;
end;

function TdxPDFNamedObjectDictionary.ContainsValue(AValue: Integer): Boolean;
begin
  Result := FDictionary.ContainsValue(AValue)
end;

procedure TdxPDFNamedObjectDictionary.ClearResourceNames;
begin
  FDictionary.Clear;
  FNextResourceNumber := 0;
end;

{ TdxPDFArray }

constructor TdxPDFArray.Create;
begin
  inherited Create;
  FElementList := TdxPDFBaseList.Create;
end;

constructor TdxPDFArray.Create(const AValues: array of Integer);
begin
  Create;
  Add(AValues);
end;

constructor TdxPDFArray.Create(const AValues: array of Single);
begin
  Create;
  Add(AValues);
end;

constructor TdxPDFArray.Create(const AValues: array of string);
begin
  Create;
  Add(AValues);
end;

constructor TdxPDFArray.Create(const AValue: TdxPointF);
begin
  Create;
  Add(AValue.X);
  Add(AValue.Y);
end;

destructor TdxPDFArray.Destroy;
begin
  FreeAndNil(FElementList);
  inherited Destroy;
end;

procedure TdxPDFArray.Add(const AValue: TdxPDFBase);
begin
  FElementList.Add(AValue);
end;

procedure TdxPDFArray.Add(const AValue: TdxPDFRange);
begin
  Add(AValue.Min);
  Add(AValue.Max);
end;

procedure TdxPDFArray.Add(const AValue: Integer);
begin
  Add(TdxPDFInteger.Create(AValue));
end;

procedure TdxPDFArray.Add(const AValue: Double);
begin
  Add(TdxPDFDouble.Create(AValue));
end;

procedure TdxPDFArray.Add(const AValue: Single);
begin
  Add(TdxPDFDouble.Create(AValue));
end;

procedure TdxPDFArray.Add(const AValue: string);
begin
  Add(TdxPDFString.Create(AValue));
end;

procedure TdxPDFArray.AddReference(ANumber, AGeneration: Integer);
begin
  FElementList.Add(TdxPDFReference.Create(ANumber, 0));
end;

procedure TdxPDFArray.Add(const AValue: array of Integer);
var
  ACurrentValue: Integer;
begin
  for ACurrentValue in AValue do
    Add(ACurrentValue);
end;

procedure TdxPDFArray.Add(const AValue: array of Single);
var
  ACurrentValue: Single;
begin
  for ACurrentValue in AValue do
    Add(ACurrentValue);
end;

procedure TdxPDFArray.Add(const AValue: array of string);
var
  ACurrentValue: string;
begin
  for ACurrentValue in AValue do
    Add(ACurrentValue);
end;

procedure TdxPDFArray.Add(const AValue: TdxPointF);
begin
  Add(AValue.X);
  Add(AValue.Y);
end;

procedure TdxPDFArray.Add(const AValue: array of Double);
var
  ACurrentValue: Double;
begin
  for ACurrentValue in AValue do
    Add(ACurrentValue);
end;

function TdxPDFArray.GetSingle(AIndex: Integer): Single;
begin
  TryGetSingle(AIndex, Result);
end;

function TdxPDFArray.TryGetArray(AIndex: Integer; out AArray: TdxPDFArray): Boolean;
begin
  Result := TryGetObject<TdxPDFArray>(AIndex, AArray);
end;

function TdxPDFArray.TryGetDictionary(AIndex: Integer; out ADictionary: TdxPDFDictionary): Boolean;
begin
  Result := TryGetObject<TdxPDFDictionary>(AIndex, ADictionary);
end;

function TdxPDFArray.TryGetString(AIndex: Integer; out AName: TdxPDFString): Boolean;
begin
  Result := TryGetObject<TdxPDFString>(AIndex, AName);
end;

function TdxPDFArray.TryGetSingle(AIndex: Integer; out AValue: Single): Boolean;
var
  ARawObject: TdxPDFNumericObject;
begin
  Result := TryGetObject<TdxPDFNumericObject>(AIndex, ARawObject);
  if Result then
    AValue := TdxPDFNumericObject(ARawObject).InternalValue;
end;

procedure TdxPDFArray.Add(const AValue: Boolean);
begin
  Add(TdxPDFBoolean.Create(AValue));
end;

procedure TdxPDFArray.AddBytes(const AValue: TBytes);
begin
  Add(TdxPDFBytes.Create(AValue));
end;

procedure TdxPDFArray.AddName(const AValue: string);
begin
  Add(TdxPDFName.Create(AValue));
end;

procedure TdxPDFArray.AddNull;
begin
  Add(TdxPDFNull.Create);
end;

function TdxPDFArray.IsString: Boolean;
var
  AItem: TdxPDFString;
begin
  Result := (Count > 0) and TryGetString(0, AItem);
end;

function TdxPDFArray.AsString: string;
var
  AItem: TdxPDFString;
  ABuilder: TStringBuilder;
  I: Integer;
begin
  ABuilder := TdxStringBuilderManager.Get;
  try
    for I := 0 to Count - 1 do
      if TryGetString(I, AItem) then
      begin
        ABuilder.Append(AItem.Value);
        if I <> Count - 1 then
          ABuilder.AppendLine;
      end;
    Result := ABuilder.ToString;
  finally
    TdxStringBuilderManager.Release(ABuilder);
  end;
end;

procedure TdxPDFArray.Clear;
begin
  ElementList.Clear;
end;

class function TdxPDFArray.GetObjectType: TdxPDFBaseType;
begin
  Result := otArray;
end;

procedure TdxPDFArray.Write(AWriter: TdxPDFWriter);
var
  I: Integer;
begin
  AWriter.WriteOpenBracket;
  for I := 0 to ElementList.Count - 1 do
  begin
    if I > 0 then
      AWriter.WriteSpace;
    TdxPDFBaseAccess(ElementList[I]).Write(AWriter);
  end;
  AWriter.WriteCloseBracket;
end;

function TdxPDFArray.GetElement(AIndex: Integer): TdxPDFBase;
begin
  Result := FElementList[AIndex];
end;

function TdxPDFArray.TryGetObject<T>(AIndex: Integer; out AObject: T): Boolean;
begin
  AObject := Safe<T>.Cast(Elements[AIndex]);
  Result := AObject <> nil;
end;

function TdxPDFArray.GetCount: Integer;
begin
  Result := FElementList.Count;
end;

procedure TdxPDFArray.SetElement(Index: Integer; const Value: TdxPDFBase);
begin
  FElementList[Index] := Value;
end;

{ TdxPDFStream }

constructor TdxPDFStream.Create(const AData: TBytes; ADictionary: TdxPDFDictionary);
begin
  Create(AData, ADictionary, nil);
end;

constructor TdxPDFStream.Create(const AData: TBytes; ADictionary: TdxPDFDictionary; AEncryptionInfo: IdxPDFEncryptionInfo);
begin
  inherited Create(AData);
  Dictionary := ADictionary;
  EncryptionInfo := AEncryptionInfo;
end;

destructor TdxPDFStream.Destroy;
begin
  Dictionary := nil;
  inherited Destroy;
end;

class function TdxPDFStream.GetObjectType: TdxPDFBaseType;
begin
  Result := otStream;
end;

procedure TdxPDFStream.Write(AWriter: TdxPDFWriter);
begin
  Dictionary.Write(AWriter);
end;

function TdxPDFStream.UncompressData(ADecryptData: Boolean): TBytes;
var
  AFilters: TdxPDFStreamFilters;
begin
  AFilters := dxPDFCreateFilterList(Dictionary);
  try
    Result := UncompressData(AFilters, ADecryptData);
  finally
    AFilters.Free;
  end;
end;

function TdxPDFStream.UncompressData(AFilters: TObject; ADecryptData: Boolean): TBytes;
var
  AData: TBytes;
  AFilterList: TdxPDFStreamFilters;
  I: Integer;
begin
  AFilterList := AFilters as TdxPDFStreamFilters;
  if ADecryptData then
    Result := DecryptedData
  else
    Result := Data;
  if AFilterList.Count > 0 then
  begin
    AData := Result;
    SetLength(Result, 0);
    for I := 0 to AFilterList.Count - 1 do
    begin
      TdxPDFUtils.AddData(AFilterList[I].Decode(AData), Result);
      SetLength(AData, 0);
      TdxPDFUtils.AddData(Result, AData);
      SetLength(Result, 0);
    end;
    Result := AData;
  end;
end;

function TdxPDFStream.GetDecryptedData: TBytes;
begin
  if (EncryptionInfo <> nil) and (Length(Data) > 0) then
    Result := EncryptionInfo.Decrypt(Data, Number)
  else
    Result := Data;
end;

function TdxPDFStream.GetUncompressedData: TBytes;
begin
  Result := UncompressData(True);
end;

procedure TdxPDFStream.SetDictionary(const AValue: TdxPDFDictionary);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDictionary))
end;

{ TdxPDFTransformationMatrix }

class function TdxPDFTransformationMatrix.Create: TdxPDFTransformationMatrix;
begin
  Result.FMatrix := TXForm.CreateIdentityMatrix;
end;

class function TdxPDFTransformationMatrix.Create(const M: TdxPDFTransformationMatrix): TdxPDFTransformationMatrix;
begin
  Result.FMatrix := TXForm.CreateMatrix(M.A, M.B, M.C, M.D, M.E, M.F);
end;

class function TdxPDFTransformationMatrix.Create(M11, M12, M21, M22, DX, DY: Single): TdxPDFTransformationMatrix;
begin
  Result.Assign(M11, M12, M21, M22, DX, DY);
end;

class function TdxPDFTransformationMatrix.CreateRotate(ADegree: Single): TdxPDFTransformationMatrix;
var
  ARadians, ASin, ACos: Single;
begin
  ARadians := ADegree / (180 / PI);
  ASin := Sin(ARadians);
  ACos := Cos(ARadians);
  Result := Create(ACos, ASin, -ASin, ACos, 0, 0);
end;

class function TdxPDFTransformationMatrix.CreateScale(AScaleX, AScaleY: Single): TdxPDFTransformationMatrix;
begin
  Result := TdxPDFTransformationMatrix.Create(AScaleX, 0, 0, AScaleY, 0, 0);
end;

class function TdxPDFTransformationMatrix.Invert(const M: TdxPDFTransformationMatrix): TdxPDFTransformationMatrix;
var
  ADeterminant: Single;
begin
  ADeterminant := M.GetDeterminant;
  Result := Create(M.D / ADeterminant, -M.B / ADeterminant, -M.C / ADeterminant, M.A / ADeterminant,
    (M.C * M.F - M.E * M.D) / ADeterminant, (M.B * M.E - M.F * M.A) / ADeterminant);
end;

class function TdxPDFTransformationMatrix.Multiply(const M1, M2: TdxPDFTransformationMatrix): TdxPDFTransformationMatrix;
var
  AMatrix1A, AMatrix1B, AMatrix1C, AMatrix1D, AMatrix1E, AMatrix1F, AMatrix2A, AMatrix2B, AMatrix2C, AMatrix2D: Single;
begin
  AMatrix1A := M1.A;
  AMatrix1B := M1.B;
  AMatrix1C := M1.C;
  AMatrix1D := M1.D;
  AMatrix1E := M1.E;
  AMatrix1F := M1.F;
  AMatrix2A := M2.A;
  AMatrix2B := M2.B;
  AMatrix2C := M2.C;
  AMatrix2D := M2.D;
  Result := Create;
  Result.Assign(
    AMatrix1A * AMatrix2A + AMatrix1B * AMatrix2C,
    AMatrix1A * AMatrix2B + AMatrix1B * AMatrix2D,
    AMatrix1C * AMatrix2A + AMatrix1D * AMatrix2C,
    AMatrix1C * AMatrix2B + AMatrix1D * AMatrix2D,
    AMatrix1E * AMatrix2A + AMatrix1F * AMatrix2C + M2.E,
    AMatrix1E * AMatrix2B + AMatrix1F * AMatrix2D + M2.F);
end;

class function TdxPDFTransformationMatrix.Null: TdxPDFTransformationMatrix;
begin
  Result.FMatrix.Reset;
end;

class function TdxPDFTransformationMatrix.Rotate(const M: TdxPDFTransformationMatrix; ADegree: Single): TdxPDFTransformationMatrix;
begin
  Result := Multiply(CreateRotate(ADegree), M);
end;

class function TdxPDFTransformationMatrix.Translate(const M: TdxPDFTransformationMatrix;
  const AOffset: TdxPointF): TdxPDFTransformationMatrix;
begin
  Result := Create(M.A, M.B, M.C, M.D, M.E + AOffset.X, M.F + AOffset.Y);
end;

function TdxPDFTransformationMatrix.Equals(const M: TdxPDFTransformationMatrix): Boolean;
begin
  Result := TXForm.IsEqual(XForm, M.XForm);
end;

function TdxPDFTransformationMatrix.IsIdentity: Boolean;
var
  AXForm: TXForm;
begin
  AXForm := XForm;
  Result :=
    (AXForm.eM11 = 1) and (AXForm.eM12 = 0) and (AXForm.eDx = 0) and
    (AXForm.eM21 = 0) and (AXForm.eM22 = 1) and (AXForm.eDy = 0);
end;

function TdxPDFTransformationMatrix.IsNull: Boolean;
begin
  Result := FMatrix.IsNull;
end;

function TdxPDFTransformationMatrix.Transform(const APoint: TdxPointF): TdxPointF;
var
  AXForm: TXForm;
begin
  AXForm := XForm;
  Result.X := APoint.X * AXForm.eM11 + APoint.Y * AXForm.eM21 + AXForm.eDx;
  Result.Y := APoint.X * AXForm.eM12 + APoint.Y * AXForm.eM22 + AXForm.eDy;
end;

function TdxPDFTransformationMatrix.Transform(const ARect: TdxPDFRectangle): TdxPDFRectangle;
var
  APoints: TdxPointsF;
begin
  SetLength(APoints, 4);
  APoints[0] := ARect.BottomLeft;
  APoints[1] := ARect.TopLeft;
  APoints[2] := ARect.TopRight;
  APoints[3] := ARect.BottomRight;
  Result := TdxPDFRectangle.Create(TransformPoints(APoints));
end;

function TdxPDFTransformationMatrix.TransformBoundingBox(const ARect: TdxPDFRectangle): TdxPDFRectangle;
var
  APoints: TdxPointsF;
begin
  SetLength(APoints, 4);
  APoints[0] := ARect.BottomLeft;
  APoints[1] := ARect.TopLeft;
  APoints[2] := ARect.TopRight;
  APoints[3] := ARect.BottomRight;
  Result := TdxPDFRectangle.Create(TransformPoints(APoints));
end;

function TdxPDFTransformationMatrix.TransformPoints(const APoints: TdxPDFPoints): TdxPDFPoints;
var
  ALength, I: Integer;
begin
  ALength := Length(APoints);
  SetLength(Result, ALength);
  for I := 0 to ALength - 1 do
    Result[I] := Transform(APoints[I]);
end;

procedure TdxPDFTransformationMatrix.Assign(const M: TdxPDFTransformationMatrix);
begin
  FMatrix := M.FMatrix;
end;

procedure TdxPDFTransformationMatrix.Assign(M11, M12, M21, M22, DX, DY: Single);
begin
  FMatrix := TXForm.CreateMatrix(M11, M12, M21, M22, DX, DY);
end;

procedure TdxPDFTransformationMatrix.Multiply(const M: TdxPDFTransformationMatrix; AOrder: TdxTransformationOrder = moPrepend);
begin
  DoMultiply(M.FMatrix, AOrder);
end;

procedure TdxPDFTransformationMatrix.Reset;
begin
  FMatrix := TXForm.CreateIdentityMatrix;
end;

procedure TdxPDFTransformationMatrix.Translate(DX, DY: Single; AOrder: TdxTransformationOrder = moPrepend);
begin
  DoMultiply(TXForm.CreateTranslateMatrix(DX, DY), AOrder);
end;

procedure TdxPDFTransformationMatrix.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteSpace;
  AWriter.WriteDouble(A);
  AWriter.WriteSpace;
  AWriter.WriteDouble(B);
  AWriter.WriteSpace;
  AWriter.WriteDouble(C);
  AWriter.WriteSpace;
  AWriter.WriteDouble(D);
  AWriter.WriteSpace;
  AWriter.WriteDouble(E);
  AWriter.WriteSpace;
  AWriter.WriteDouble(F);
end;

function TdxPDFTransformationMatrix.GetA: Single;
begin
  Result := XForm.eM11;
end;

function TdxPDFTransformationMatrix.GetB: Single;
begin
  Result := XForm.eM12;
end;

function TdxPDFTransformationMatrix.GetC: Single;
begin
  Result := XForm.eM21;
end;

function TdxPDFTransformationMatrix.GetD: Single;
begin
  Result := XForm.eM22;
end;

function TdxPDFTransformationMatrix.GetE: Single;
begin
  Result := XForm.eDx;
end;

function TdxPDFTransformationMatrix.GetF: Single;
begin
  Result := XForm.eDy;
end;

function TdxPDFTransformationMatrix.GetDeterminant: Single;
begin
  Result := A * D - B * C;
end;

function TdxPDFTransformationMatrix.GetDistanceToX: Single;
begin
  Result := Sqrt(A * A + B * B);
end;

function TdxPDFTransformationMatrix.GetDistanceToY: Single;
begin
  Result := Sqrt(C * C + D * D);
end;

function TdxPDFTransformationMatrix.GetIsInvertable: Boolean;
var
  AMax: Single;
begin
  AMax := TdxPDFUtils.Max(Abs(C * F - E * D), Abs(B * E - F * A));
  AMax := TdxPDFUtils.Max(AMax, TdxPDFUtils.Max(Abs(A), Abs(B)));
  AMax := TdxPDFUtils.Max(AMax, TdxPDFUtils.Max(Abs(C), Abs(D)));
  Result := (AMax + GetDeterminant <> AMax);
end;

function TdxPDFTransformationMatrix.GetIsRotated: Boolean;

  function IsZeroComponent(AComponent: Single): Boolean;
  begin
    Result := Abs(AComponent) < 1e-6;
  end;

begin
  Result := not (IsZeroComponent(A) and IsZeroComponent(D) or IsZeroComponent(B) and IsZeroComponent(C));
end;

function TdxPDFTransformationMatrix.GetXForm: TXForm;
begin
  Result := FMatrix.Value;
end;

procedure TdxPDFTransformationMatrix.SetXForm(const AValue: TXForm);
begin
  FMatrix := AValue;
end;

procedure TdxPDFTransformationMatrix.DoMultiply(const AXForm: TXForm; AOrder: TdxTransformationOrder = moPrepend);
begin
  if AOrder = moPrepend then
    FMatrix := TXForm.Combine(AXForm, FMatrix)
  else
    FMatrix := TXForm.Combine(FMatrix, AXForm);
end;

{ TdxPDFDictionary }

constructor TdxPDFDictionary.Create;
begin
  inherited Create;
  FDictionary := TdxPDFCustomReferencedObjectDictionary<string, TdxPDFBase>.Create;
  FStreamRef := nil;
end;

destructor TdxPDFDictionary.Destroy;
begin
  FStreamRef := nil;
  FreeAndNil(FDictionary);
  inherited Destroy;
end;

function TdxPDFDictionary.GetObject(const AKey: string): TdxPDFBase;
begin
  if not FDictionary.TryGetValue(AKey, Result) then
    Result := nil;
end;

function TdxPDFDictionary.Contains(const AKey: string): Boolean;
begin
  Result := FDictionary.ContainsKey(AKey);
end;

procedure TdxPDFDictionary.EnumKeys(AProc: TEnumKeyProc);
var
  AKey: string;
begin
  if not Assigned(AProc) then
    Exit;
  for AKey in FDictionary.Keys do
    AProc(AKey);
end;

procedure TdxPDFDictionary.Remove(const AKey: string);
begin
  FDictionary.Remove(AKey);
end;

function TdxPDFDictionary.CreateNumericList(const AKey: string): TDoubleDynArray;
var
  AArray: TdxPDFArray;
begin
  AArray := GetArray(AKey);
  if AArray <> nil then
    Result := TdxPDFUtils.ArrayToDoubleArray(AArray)
  else
    Result := nil;
end;

function TdxPDFDictionary.GetArray(const AKey: string): TdxPDFArray;
var
  AObject: TdxPDFBase;
begin
  AObject := GetObject(AKey);
  if (AObject <> nil) and (AObject.ObjectType = otArray) then
    Result := AObject as TdxPDFArray
  else
    Result := nil;
end;

function TdxPDFDictionary.GetArray(const AKey, AAlternativeKey: string): TdxPDFArray;
begin
  Result := GetArray(AKey);
  if Result = nil then
    Result := GetArray(AAlternativeKey);
end;

function TdxPDFDictionary.GetArray(const AKey: string; out AArray: TdxPDFArray): Boolean;
begin
  AArray := GetArray(AKey);
  Result := AArray <> nil;
end;

function TdxPDFDictionary.GetBoolean(const AKey: string; ADefaultValue: Boolean = False): Boolean;
begin
  Result := ADefaultValue;
  if Contains(AKey) then
    Result := TdxPDFBoolean(GetObject(AKey)).Value;
end;

function TdxPDFDictionary.GetBytes(const AKey: string): TBytes;
var
  AObject: TdxPDFBase;
begin
  SetLength(Result, 0);
  if not Contains(AKey) then
    Exit;
  AObject := GetObject(AKey);
  if AObject is TdxPDFString then
    Result := TdxPDFUtils.StrToByteArray(TdxPDFString(AObject).Value)
  else
    if (AObject is TdxPDFArray) and TdxPDFArray(AObject).IsString then
      Result := TdxPDFUtils.StrToByteArray(TdxPDFArray(AObject).AsString);
end;

function TdxPDFDictionary.GetDate(const AKey: string): TDateTime;
var
  APosition: Integer;
  S: string;
begin
  S := GetString(AKey);
  APosition := Pos('D', S);
  if APosition > 0 then
    S := Copy(S, APosition, MaxInt)
  else
    S := '';

  if S <> '' then
  try
    Result := ParseDateTime(S);
  except
    on E: EConvertError do
      Result := NullDate
    else
      raise;
  end
  else
    Result := NullDate;
end;

function TdxPDFDictionary.GetDictionary(const AKey: string): TdxPDFDictionary;
var
  AObject: TdxPDFBase;
begin
  AObject := GetObject(AKey);
  if (AObject <> nil) and (AObject.ObjectType = otDictionary) then
    Result := AObject as TdxPDFDictionary
  else
    Result := nil;
end;

function TdxPDFDictionary.GetDouble(const AKey: string; ADefaultValue: Double = dxPDFInvalidValue): Double;
var
  AObject: TdxPDFBase;
begin
  if TryGetObject(AKey, AObject) and (AObject is TdxPDFNumericObject) then
    Result := TdxPDFNumericObject(AObject).GetValue
  else
    Result := ADefaultValue;
end;

function TdxPDFDictionary.GetDoubleArray(const AKey: string): TDoubleDynArray;
var
  I: Integer;
  AArray: TdxPDFArray;
begin
  SetLength(Result, 0);
  AArray := GetArray(AKey);
  if AArray <> nil then
  begin
    SetLength(Result, AArray.Count);
    for I := 0 to AArray.Count - 1 do
      Result[I] := TdxPDFUtils.ConvertToDouble(AArray.Elements[I]);
  end;
end;

function TdxPDFDictionary.GetInteger(const AKey: string; ADefaultValue: Integer = dxPDFInvalidValue): Integer;
begin
  Result := ADefaultValue;
  if Contains(AKey) then
    Result := TdxPDFInteger(GetObject(AKey)).Value;
end;

function TdxPDFDictionary.GetInteger(const AKey, AAlternativeKey: string): Integer;
begin
  Result := GetInteger(AKey);
  if not TdxPDFUtils.IsIntegerValid(Result) then
    Result := GetInteger(AAlternativeKey);
end;

function TdxPDFDictionary.GetRectangle(const AKey: string): TdxRectF;
begin
  Result := TdxPDFUtils.ArrayToRectF(GetObject(AKey) as TdxPDFArray);
  if Result.Top < Result.Bottom then
    ExchangeSingle(Result.Top, Result.Bottom);
end;

function TdxPDFDictionary.GetRectangle(const AKey: string; const ADefaultValue: TdxRectF): TdxRectF;
begin
  if Contains(AKey) then
    Result := GetRectangle(AKey)
  else
    Result := ADefaultValue;
end;

procedure TdxPDFDictionary.ResolveArrayElements(AArray: TdxPDFArray);
begin
end;

function TdxPDFDictionary.GetRectangleEx(const AKey: string): TdxPDFRectangle;
var
  AArray: TdxPDFArray;
begin
  AArray := GetObject(AKey) as TdxPDFArray;
  ResolveArrayElements(AArray);
  Result := TdxPDFUtils.ArrayToRectangle(AArray);
end;

function TdxPDFDictionary.GetRenderingIntent(const AKey: string): TdxPDFRenderingIntent;
begin
  Result := TdxPDFUtils.ConvertToRenderingIntent(GetString(AKey));
end;

function TdxPDFDictionary.GetSignatureFlags(const AKey: string): TdxPDFSignatureFlags;
var
  AValue: Integer;
begin
  AValue := GetInteger(AKey, 0);
  if AValue > 2 then
    Result := [sfSignaturesExist, sfAppendOnly]
  else
    Result := [TdxPDFSignatureFlag(AValue)];
end;

function TdxPDFDictionary.GetSmallInt(const AKey: string; ADefaultValue: SmallInt): SmallInt;
var
  AValue: Double;
begin
  AValue := GetDouble(AKey, ADefaultValue);
  if InRange(AValue, Low(SmallInt), High(SmallInt)) then
    Result := Trunc(AValue)
  else
    Result := ADefaultValue;
end;

function TdxPDFDictionary.GetStream(const AKey: string): TdxPDFStream;
begin
  Result := GetObject(AKey) as TdxPDFStream;
end;

function TdxPDFDictionary.GetString(const AKey: string): string;
var
  AData: TBytes;
begin
  AData := GetBytes(AKey);
  if Length(AData) <> 0 then
    Result := TdxPDFUtils.ConvertToStr(AData)
  else
    Result := '';
end;

function TdxPDFDictionary.GetString(const AKey, ADefaultValue: string): string;
begin
  Result := GetString(AKey);
  if Result = '' then
    Result := ADefaultValue;
end;

function TdxPDFDictionary.GetTextString(const AKey: string): string;
begin
  Result := GetTextString(AKey, '');
end;

function TdxPDFDictionary.GetTextString(const AKey, ADefaultValue: string): string;
var
  AData: TBytes;
begin
  AData := GetBytes(AKey);
  if Length(AData) <> 0 then
    Result := TdxPDFUtils.ConvertToText(AData)
  else
    Result := ADefaultValue;
end;

function TdxPDFDictionary.TryGetArray(const AKey: string; out AValue: TdxPDFArray): Boolean;
begin
  Result := TryGetValue<TdxPDFArray>(AKey, AValue);
end;

function TdxPDFDictionary.TryGetBoolean(const AKey: string; out AValue: Boolean): Boolean;
var
  AObject: TdxPDFBoolean;
begin
  Result := TryGetValue<TdxPDFBoolean>(AKey, AObject);
  if Result then
    AValue := AObject.Value;
end;

function TdxPDFDictionary.TryGetDictionary(const AKey: string; out AValue: TdxPDFDictionary): Boolean;
begin
  Result := TryGetValue<TdxPDFDictionary>(AKey, AValue);
end;

function TdxPDFDictionary.TryGetLineEndingStyle(out AStart, AFinish: TdxPDFAnnotationLineEndingStyle): Boolean;
var
  AArray: TdxPDFArray;
  AName: string;
  AStringObject: TdxPDFString;
begin
  Result := TryGetArray(TdxPDFKeywords.LineEnding, AArray) and (AArray.Count = 2);
  if Result then
  begin
    if AArray.TryGetString(0, AStringObject) then
      AStart := GetLineEndingStyle(AStringObject.Value);
    if AArray.TryGetString(1, AStringObject) then
      AFinish := GetLineEndingStyle(AStringObject.Value);
  end
  else
    if TryGetString(TdxPDFKeywords.LineEnding, AName) then
      AFinish := GetLineEndingStyle(AName);
end;

function TdxPDFDictionary.TryGetObject(const AKey: string; out AValue: TdxPDFBase): Boolean;
begin
  Result := FDictionary.TryGetValue(AKey, AValue);
end;

function TdxPDFDictionary.TryGetReference(const AKey: string; out AValue: Integer): Boolean;
var
  AObject: TdxPDFBase;
begin
  Result := TryGetObject(AKey, AObject);
  if Result then
    AValue := AObject.Number;
end;

function TdxPDFDictionary.TryGetStream(const AKey: string; out AValue: TdxPDFStream): Boolean;
var
  AObject: TdxPDFBase;
begin
  AValue := nil;
  AObject := GetObject(AKey);
  if AObject <> nil then
    case AObject.ObjectType of
      otStream:
        AValue := AObject as TdxPDFStream;
      otDictionary:
        AValue := TdxPDFDictionary(AObject).StreamRef;
    else
      AValue := nil;
    end;
  Result := AValue <> nil;
end;

function TdxPDFDictionary.TryGetString(const AKey: string; out AValue: string): Boolean;
var
  AObject: TdxPDFString;
begin
  Result := TryGetValue<TdxPDFString>(AKey, AObject);
  if Result then
    AValue := AObject.Value;
end;

function TdxPDFDictionary.TryGetTextString(const AKey: string; out AValue: string): Boolean;
begin
  Result := Contains(AKey);
  if Result then
    AValue := GetTextString(AKey)
  else
    AValue := '';
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TDoubleDynArray; ASkipIfNull: Boolean = True);
var
  AArray: TdxPDFArray;
  ALength: Integer;
  I: Integer;
begin
  ALength := Length(AValue);
  if not ASkipIfNull or (ALength > 0) then
  begin
    AArray := TdxPDFArray.Create;
    for I := 0 to ALength - 1 do
      AArray.Add(AValue[I]);
    Add(AKey, AArray);
  end;
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TStringDynArray);
var
  AArray: TdxPDFArray;
  ALength: Integer;
  I: Integer;
begin
  ALength := Length(AValue);
  if ALength > 0 then
  begin
    AArray := TdxPDFArray.Create;
    for I := 0 to ALength - 1 do
      AArray.Add(AValue[I]);
    Add(AKey, AArray);
  end;
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TIntegerDynArray);
var
  AArray: TdxPDFArray;
  ALength: Integer;
  I: Integer;
begin
  ALength := Length(AValue);
  if ALength > 0 then
  begin
    AArray := TdxPDFArray.Create;
    for I := 0 to ALength - 1 do
      AArray.Add(AValue[I]);
    Add(AKey, AArray);
  end;
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AStart, AFinish: TdxPDFAnnotationLineEndingStyle);
const
  Map: array[TdxPDFAnnotationLineEndingStyle] of string = ('None', 'Square', 'Circle', 'Diamond', 'OpenArrow',
    'ClosedArrow', 'Butt', 'ROpenArrow', 'RClosedArrow', 'Slash');
begin
  if (AStart <> lesNone) or (AFinish <> lesNone) then
    Add(AKey, TdxPDFArray.Create([Map[AStart], Map[AFinish]]));
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TdxPDFSignatureFlags);
var
  AFlag: TdxPDFSignatureFlag;
  AValueAsInteger: Integer;
begin
  AValueAsInteger := 0;
  for AFlag in AValue do
    Inc(AValueAsInteger, Ord(AFlag));
  Add(AKey, AValueAsInteger);
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TdxPointF);
begin
  Add(AKey, TdxPDFUtils.PointToArray(AValue));
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TdxPointsF);
begin
  if Length(AValue) = 0 then
    Exit;
  Add(AKey, TdxPDFUtils.PointsToArray(AValue));
end;

procedure TdxPDFDictionary.AddBytes(const AKey: string; const AValue: TBytes);
begin
  if Length(AValue) > 0 then
    Add(AKey, TdxPDFBytes.Create(AValue));
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TBytes);
begin
  if Length(AValue) > 0 then
    Add(AKey, TdxPDFString.Create(TdxPDFUtils.BytesToStr(AValue)));
end;

procedure TdxPDFDictionary.Add(const AKey: string; AValue: TdxPDFBase);
var
  ATemp: TdxPDFBase;
begin
  ATemp := nil;
  if FDictionary.TryGetValue(AKey, ATemp) and (AValue <> ATemp) or (ATemp = nil) then
  begin
    if AValue = nil then
      FDictionary.AddOrSetValue(AKey, TdxPDFNull.Create)
    else
      FDictionary.AddOrSetValue(AKey, AValue);
  end;
end;

procedure TdxPDFDictionary.Add(const AKey: string; AValue: Integer);
begin
  if dxPDFIsIntegerValid(AValue) then
    Add(AKey, TdxPDFInteger.Create(AValue));
end;

procedure TdxPDFDictionary.Add(const AKey: string; AValue, ADefaultValue: Integer);
begin
  if AValue <> ADefaultValue then
    Add(AKey, AValue);
end;

procedure TdxPDFDictionary.Add(const AKey: string; AValue, ADefaultValue: Boolean);
begin
  if ADefaultValue <> AValue then
    Add(AKey, AValue);
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: Double);
begin
  if dxPDFIsDoubleValid(AValue) then
    Add(AKey, TdxPDFNumericObject.Create(AValue));
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue, ADefaultValue: Double);
begin
  if not SameValue(AValue, ADefaultValue) then
    Add(AKey, AValue);
end;

procedure TdxPDFDictionary.Add(const AKey: string; AValue: Boolean);
begin
  Add(AKey, TdxPDFBoolean.Create(AValue));
end;

procedure TdxPDFDictionary.Add(const AKey, AValue: string);
begin
  if AValue <> '' then
    Add(AKey, TdxPDFString.Create(AValue));
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue, ADefaultValue: string);
var
  AActualValue: string;
begin
  if AValue <> '' then
    AActualValue := AValue
  else
    AActualValue := ADefaultValue;
  Add(AKey, AValue);
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: string; AEncoding: TEncoding);
begin
  if AValue <> '' then
    Add(AKey, AEncoding.GetBytes(AValue));
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TdxRectF; ACheckRect: Boolean = True;
  ASkipIfNull: Boolean = True);
begin
  if not ASkipIfNull or not TdxPDFUtils.IsRectEmpty(AValue) then
    Add(AKey, TdxPDFUtils.RectToArray(AValue, ACheckRect));
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TdxPDFRanges);
var
  AArray: TdxPDFArray;
  I, ALength: Integer;
begin
  ALength := Length(AValue);
  if ALength > 0 then
  begin
    AArray := TdxPDFArray.Create;
    for I := 0 to ALength - 1 do
      AArray.Add(AValue[I]);
    Add(AKey, AArray);
  end;
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AMatrix: TdxPDFTransformationMatrix;
  ASkipNullOrIdentity: Boolean = True);
begin
  if not (ASkipNullOrIdentity and (AMatrix.IsNull or AMatrix.IsIdentity)) then
    Add(AKey, TdxPDFUtils.MatrixToArray(AMatrix));
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue: TdxPDFRectangle; ASkipIfNull: Boolean = True);
var
  AArray: TdxPDFArray;
begin
  if not (ASkipIfNull and AValue.IsNull) then
  begin
    AArray := TdxPDFArray.Create;
    AArray.Add(AValue.Left);
    AArray.Add(AValue.Bottom);
    AArray.Add(AValue.Right);
    AArray.Add(AValue.Top);
    Add(AKey, AArray);
  end;
end;

procedure TdxPDFDictionary.Add(const AKey: string; const AValue, ADefaultValue: TdxRectF);
begin
  if not TdxPDFUtils.RectIsEqual(AValue, ADefaultValue, 0.001) then
    Add(AKey, AValue);
 end;

procedure TdxPDFDictionary.AddDate(const AKey: string; AValue: TDateTime);
begin
  if AValue <> NullDate then
    Add(AKey, TdxPDFUtils.ConvertToStr(AValue));
end;

procedure TdxPDFDictionary.AddName(const AKey: string; const AValue: string; ASkipIfNull: Boolean = True);
begin
  if not (ASkipIfNull and (AValue = '')) then
    Add(AKey, TdxPDFName.Create(AValue));
end;

procedure TdxPDFDictionary.AddName(const AKey: string; const AValue: TdxPDFRenderingIntent);
begin
  AddName(AKey, TdxPDFUtils.ConvertToStr(AValue));
end;

procedure TdxPDFDictionary.AddQuadrilateralArray(const AValue: TdxPDFQuadrilateralArray);
var
  AArray: TdxPDFArray;
  I, J, L: Integer;
  ADoubleDynArray: TDoubleDynArray;
begin
  L := Length(AValue);
  if L = 0 then
    Exit;
  AArray := TdxPDFArray.Create;
  for I := 0 to L - 1 do
  begin
    ADoubleDynArray := AValue[I].GetAsArray;
    for J := 0 to Length(ADoubleDynArray) - 1 do
      AArray.Add(ADoubleDynArray[J]);
  end;
  Add(TdxPDFKeywords.QuadPoints, AArray);
end;

procedure TdxPDFDictionary.AddReference(const AKey: string; ANumber: Integer; AGeneration: Integer = 0);
begin
  Add(AKey, TdxPDFReference.Create(ANumber, AGeneration));
end;

procedure TdxPDFDictionary.AddReference(const AKey: string; const AData: TBytes; ASkipIfNull: Boolean = True);
begin
  TdxPDFUtils.RaiseException('AddReference(TBytes) is not supported');
end;

procedure TdxPDFDictionary.Clear;
begin
  FDictionary.Clear;
end;

class function TdxPDFDictionary.GetObjectType: TdxPDFBaseType;
begin
  Result := otDictionary;
end;

function TdxPDFDictionary.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

procedure TdxPDFDictionary.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteOpenDictionary;
  WriteContent(AWriter);
  AWriter.WriteCloseDictionary;
  WriteStream(AWriter);
end;

procedure TdxPDFDictionary.WriteContent(AWriter: TdxPDFWriter);
var
  APair: TPair<string, TdxPDFBase>;
  AName: TdxPDFName;
  ACount: Integer;
begin
  AName := TdxPDFName.Create;
  try
    ACount := Count;
    for APair in FDictionary do
    begin
      Dec(ACount);
      if APair.Value is TdxPDFBase then
      begin
        AName.Value := APair.Key;
        AName.Write(AWriter);
        AWriter.WriteSpace;
        TdxPDFBaseAccess(APair.Value).Write(AWriter);
        if ACount > 0 then
          AWriter.WriteSpace;
      end;
    end;
  finally
    AName.Free;
  end;
end;

procedure TdxPDFDictionary.WriteStream(AWriter: TdxPDFWriter);
begin
  if StreamRef <> nil then
    WriteStreamData(AWriter, StreamRef.Data);
end;

procedure TdxPDFDictionary.WriteStreamData(AWriter: TdxPDFWriter; const AData: TBytes);
begin
  if Length(AData) > 0 then
  begin
    AWriter.WriteLineFeed;
    AWriter.WriteString(TdxPDFKeywords.Stream, True);
    AWriter.WriteBytes(AData);
    AWriter.WriteLineFeed;
    AWriter.WriteString(TdxPDFKeywords.EndStream);
  end;
end;

function TdxPDFDictionary.GetMatrix(const AKey: string): TdxPDFTransformationMatrix;
begin
  Result := TdxPDFUtils.ArrayToMatrix(GetArray(AKey));
end;

function TdxPDFDictionary.GetPadding(const ABounds: TdxPDFRectangle): TdxPDFRectangle;
var
  ALeft, ARight, APaddingWidth, ARemainWidth, AFactor, ATop, ABottom, APaddingHeight, ARemainHeight: Double;
begin
  Result := GetRectangleEx(TdxPDFKeywords.Padding);

  if Result.IsNull then
    Exit;

  ALeft := Max(0, Result.Left);
  ARight := Max(0, Result.Right);
  APaddingWidth := ALeft + ARight;
  ARemainWidth := APaddingWidth - ABounds.Width;
  if ARemainWidth > 0 then
  begin
    AFactor := ARemainWidth / APaddingWidth;
    ALeft := ALeft + ALeft * AFactor;
    ARight := ARight + ARight * AFactor;
  end;

  ATop := Max(0, Result.Top);
  ABottom := Max(0, Result.Bottom);
  APaddingHeight := ATop + ABottom;
  ARemainHeight := APaddingHeight - ABounds.Height;
  if ARemainHeight > 0 then
  begin
    AFactor := ARemainHeight / APaddingHeight;
    ATop := ATop + ATop * AFactor;
    ABottom := ABottom +  ABottom * AFactor;
  end;

  Result := TdxPDFRectangle.Create(ALeft, ABottom, ARight, ATop);
end;

function TdxPDFDictionary.GetPoints(const AKey: string): TdxPointsF;
var
  AArray: TdxPDFArray;
begin
  if TryGetArray(AKey, AArray) then
    Result := TdxPDFUtils.ArrayToPoints(AArray)
  else
    Result := nil;
end;

function TdxPDFDictionary.GetQuadrilateralArray: TdxPDFQuadrilateralArray;
var
  AArray: TdxPDFArray;
  I, AIndex, ACount: Integer;
  P1, P2, P3, P4: TdxPointF;
begin
  if not TryGetArray(TdxPDFKeywords.QuadPoints, AArray) or (AArray.Count mod 8 <> 0) then
    Exit(nil);
  ACount := AArray.Count div 8;
  SetLength(Result, ACount);
  AIndex := 0;
  for I := 0 to ACount - 1 do
  begin
    P1 := TdxPDFUtils.ArrayToPointF(AArray, AIndex);
    Inc(AIndex, 2);
    P2 := TdxPDFUtils.ArrayToPointF(AArray, AIndex);
    Inc(AIndex, 2);
    P3 := TdxPDFUtils.ArrayToPointF(AArray, AIndex);
    Inc(AIndex, 2);
    P4 := TdxPDFUtils.ArrayToPointF(AArray, AIndex);
    Inc(AIndex, 2);
    Result[I] := TdxPDFQuadrilateral.Create(P1, P2, P3, P4);
  end;
end;

function TdxPDFDictionary.GetLineEndingStyle(const AValue: string): TdxPDFAnnotationLineEndingStyle;
begin
  if AValue = 'Square' then
    Exit(lesSquare);

  if AValue = 'Circle' then
    Exit(lesCircle);

  if AValue = 'Diamond' then
    Exit(lesDiamond);

  if AValue = 'OpenArrow' then
    Exit(lesOpenArrow);

  if AValue = 'ClosedArrow' then
    Exit(lesClosedArrow);

  if AValue = 'Butt' then
    Exit(lesButt);

  if AValue = 'ROpenArrow' then
    Exit(lesROpenArrow);

  if AValue = 'RClosedArrow' then
    Exit(lesRClosedArrow);

  if AValue = 'Slash' then
    Exit(lesSlash);

  Result := lesNone;
end;

function TdxPDFDictionary.GetValue(const AKey: string): TdxPDFBase;
begin
  if not TryGetValue<TdxPDFBase>(AKey, Result) then
    Result := nil;
end;

procedure TdxPDFDictionary.SetValue(const AKey: string; AValue: TdxPDFBase);
begin
  Add(AKey, AValue);
end;

function TdxPDFDictionary.ParseDateTime(ADateTime: string): TDateTime;
var
  AUTC: TcxDateTime;
begin
  if (Length(ADateTime) > 2) and (ADateTime[1] = 'D') and (ADateTime[2] = ':') then
    Delete(ADateTime, 1, 2);
  ADateTime := StringReplace(ADateTime, '"', '', [rfReplaceAll]);
  ADateTime := StringReplace(ADateTime, '''', '', [rfReplaceAll]);
  if Length(ADateTime) >= 4 then
  begin
    AUTC.Year :=
      TdxPDFUtils.ConvertToDigit(Byte(ADateTime[1])) * 1000 + TdxPDFUtils.ConvertToDigit(Byte(ADateTime[2])) * 100 +
      TdxPDFUtils.ConvertToDigit(Byte(ADateTime[3])) * 10 + TdxPDFUtils.ConvertToDigit(Byte(ADateTime[4]));
    Delete(ADateTime, 1, 4);
    ParseDateTimeComponent(ADateTime, PInteger(@AUTC.Month), 1);
    ParseDateTimeComponent(ADateTime, PInteger(@AUTC.Day), 1);
    ParseDateTimeComponent(ADateTime, PInteger(@AUTC.Hours));
    ParseDateTimeComponent(ADateTime, PInteger(@AUTC.Minutes));
    ParseDateTimeComponent(ADateTime, PInteger(@AUTC.Seconds));
    Result := cxGetLocalCalendar.ToDateTime(AUTC);
  end
  else
    Result := NullDate;
end;

function TdxPDFDictionary.TryGetValue<T>(const AKey: string; out AValue: T): Boolean;
var
  AObject: TdxPDFBase;
begin
  Result := FDictionary.TryGetValue(AKey, AObject);
  if Result then
  begin
    AValue := Safe<T>.Cast(AObject);
    Result := AValue <> nil;
  end;
end;

procedure TdxPDFDictionary.ParseDateTimeComponent(var ADateTime: string; AComponent: PInteger; ADefaultValue: Byte = 0);
begin
  if Length(ADateTime) >= 2 then
  begin
    AComponent^ := TdxPDFUtils.ConvertToDigit(Byte(ADateTime[1])) * 10 + TdxPDFUtils.ConvertToDigit(Byte(ADateTime[2]));
    Delete(ADateTime, 1, 2);
  end
  else
    AComponent^ := ADefaultValue;
end;

{ TdxPDFValue }

constructor TdxPDFValue.Create(ANumber, AGeneration: Integer; const AValue: Variant);
begin
  inherited Create(ANumber, AGeneration);
  InternalSetValue(AValue);
end;

constructor TdxPDFValue.Create(const AValue: Variant);
begin
  inherited Create;
  InternalSetValue(AValue);
end;

procedure TdxPDFValue.InternalSetValue(const AValue: Variant);
begin
  FValue := AValue;
end;

{ TdxPDFBoolean }

class function TdxPDFBoolean.GetObjectType: TdxPDFBaseType;
begin
  Result := otBoolean;
end;

procedure TdxPDFBoolean.Write(AWriter: TdxPDFWriter);
const
  Map: array[Boolean] of string = ('false', 'true');
begin
  AWriter.WriteString(Map[Value]);
end;

function TdxPDFBoolean.GetValue: Boolean;
begin
  Result := InternalValue;
end;

procedure TdxPDFBoolean.SetValue(const AValue: Boolean);
begin
  SetValue(AValue);
end;

{ TdxPDFNull }

procedure TdxPDFNull.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteString('null', False);
end;

function TdxPDFNull.GetValue: Variant;
begin
  Result := varEmpty;
end;

{ TdxPDFCustomBytes }

constructor TdxPDFCustomBytes.Create(const AValue: TBytes);
begin
  inherited Create;
  FData := AValue;
end;

procedure TdxPDFCustomBytes.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteHexadecimalString(FData);
end;

{ TdxPDFBytes }

procedure TdxPDFBytes.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteHexadecimalString(AWriter.Encrypt(FData));
end;

{ TdxPDFPlaceHolder }

constructor TdxPDFPlaceHolder.Create(ALength: Int64);
var
  AData: TBytes;
begin
  SetLength(AData, ALength);
  inherited Create(AData);
  FOffset := -1;
end;

function TdxPDFPlaceHolder.IsValid: Boolean;
begin
  Result := FOffset <> -1;
end;

procedure TdxPDFPlaceHolder.Write(AWriter: TdxPDFWriter);
begin
  FOffset := AWriter.Stream.Position;
  AWriter.WriteBytes(FData);
end;

function TdxPDFPlaceHolder.GetSize: Int64;
begin
  Result := Length(FData);
end;

{ TdxPDFString }

class function TdxPDFString.GetObjectType: TdxPDFBaseType;
begin
  Result := otString;
end;

procedure TdxPDFString.Write(AWriter: TdxPDFWriter);
var
  AStream: TdxPDFMemoryStream;
  AValue: string;
begin
  AValue := Value;
  if TdxPDFUtils.IsUnicodeString(AValue) then
  begin
    AStream := TdxPDFMemoryStream.Create;
    try
      AStream.WriteByte(254);
      AStream.WriteByte(255);
      AStream.WriteArray(TEncoding.BigEndianUnicode.GetBytes(AValue));
      AWriter.WriteHexadecimalString(AWriter.Encrypt(AStream.Data));
    finally
      AStream.Free;
    end;
  end
  else
    AWriter.WriteStringValue(AWriter.Encrypt(TEncoding.Default.GetBytes(AValue)));
end;

function TdxPDFString.GetText: string;
begin
  Result := TdxPDFUtils.ConvertToText(TdxPDFUtils.StrToByteArray(Value));
end;

function TdxPDFString.GetValue: string;
begin
  Result := VarToStr(InternalValue);
end;

procedure TdxPDFString.SetValue(const AValue: string);
begin
  InternalSetValue(AValue);
end;

{ TdxPDFComment }

class function TdxPDFComment.GetObjectType: TdxPDFBaseType;
begin
  Result := otComment;
end;

procedure TdxPDFComment.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteString('%' + Value);
end;

{ TdxPDFName }

class function TdxPDFName.GetObjectType: TdxPDFBaseType;
begin
  Result := otName;
end;

procedure TdxPDFName.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteName(Value);
end;

{ TdxPDFNumericObject }

class function TdxPDFNumericObject.GetObjectType: TdxPDFBaseType;
begin
  Result := otDouble;
end;

procedure TdxPDFNumericObject.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteDouble(InternalValue);
end;

function TdxPDFNumericObject.GetValue: Variant;
begin
  Result := InternalValue;
end;

{ TdxPDFInteger }

class function TdxPDFInteger.GetObjectType: TdxPDFBaseType;
begin
  Result := otInteger;
end;

procedure TdxPDFInteger.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteInteger(Value);
end;

function TdxPDFInteger.GetValue: Integer;
begin
  Result := InternalValue;
end;

procedure TdxPDFInteger.SetValue(const AValue: Integer);
begin
  InternalSetValue(AValue);
end;

{ TdxPDFDouble }

function TdxPDFDouble.GetValue: Double;
begin
  Result := InternalValue;
end;

procedure TdxPDFDouble.SetValue(const AValue: Double);
begin
  InternalSetValue(AValue);
end;

{ TdxPDFReference }

constructor TdxPDFReference.Create(ANumber, AGeneration: Integer; AOffset: Int64 = 0;
  AIsFree: Boolean = False; AIsSlot: Boolean = False);
begin
  inherited Create(ANumber, AGeneration);
  FIsFree := AIsFree;
  FIsSlot := AIsSlot;
  FOffset := AOffset;
end;

class function TdxPDFReference.GetObjectType: TdxPDFBaseType;
begin
  Result := otIndirectReference;
end;

procedure TdxPDFReference.Write(AWriter: TdxPDFWriter);
begin
  AWriter.WriteString(IntToStr(Number) + ' ' + IntToStr(Generation) + ' R');
end;

{ TdxPDFIndirectObject }

constructor TdxPDFIndirectObject.Create(ANumber, AGeneration: Integer; const AData: TBytes);
begin
  inherited Create(ANumber, AGeneration);
  FData := AData;
end;

destructor TdxPDFIndirectObject.Destroy;
begin
  SetLength(FData, 0);
  inherited Destroy;
end;

class function TdxPDFIndirectObject.GetObjectType: TdxPDFBaseType;
begin
  Result := otIndirectObject;
end;

{ TdxPDFTokenDescription }

constructor TdxPDFTokenDescription.Create(const ADescription: string);
begin
  Create(TdxPDFUtils.StrToByteArray(ADescription));
end;

constructor TdxPDFTokenDescription.Create(const ASequence: TBytes);
begin
  FSequence := ASequence;
  FSequenceLength := Length(FSequence);
  Reset;
end;

class function TdxPDFTokenDescription.BeginCompare(AToken: TdxPDFTokenDescription): TdxPDFTokenDescription;
begin
  Result := TdxPDFTokenDescription.Create(AToken.Sequence);
end;

function TdxPDFTokenDescription.Compare(ASymbol: Byte): Boolean;
begin
  if ASymbol = FCurrentComparingSymbol then
  begin
    if FIndexToCompare = FSequenceLength - 1 then
      Exit(True);
    Inc(FIndexToCompare);
    FCurrentComparingSymbol := FSequence[FIndexToCompare];
  end
  else
    if FIndexToCompare <> 0 then
      Reset;
  Result := False;
end;

procedure TdxPDFTokenDescription.Reset;
begin
  FIndexToCompare := 0;
  FCurrentComparingSymbol := FSequence[0];
end;

function TdxPDFTokenDescription.IsStartWithComment: Boolean;
begin
  Result := FSequence[0] = TdxPDFDefinedSymbols.Comment;
end;

{ TdxPDFStreamElement }

constructor TdxPDFStreamElement.Create(ANumber: Integer; AIndex: Integer);
begin
  inherited Create(ANumber, 0, 0, False);
  FIndex := AIndex;
end;

class function TdxPDFStreamElement.GetObjectType: TdxPDFBaseType;
begin
  Result := otStreamElement;
end;

{ TdxPDFCustomRepository }

constructor TdxPDFCustomRepository.Create;
begin
  inherited Create;
  CreateSubClasses;
end;

destructor TdxPDFCustomRepository.Destroy;
begin
  DestroySubClasses;
  inherited Destroy;
end;

function TdxPDFCustomRepository.DecryptString(const S: string): string;
begin
  Result := S;
end;

function TdxPDFCustomRepository.GetArray(ANumber: Integer): TdxPDFArray;
var
  AResult: TdxPDFReferencedObject;
begin
  AResult := GetObject(ANumber);
  if TdxPDFBase(AResult).ObjectType = otArray then
    Result := TdxPDFArray(AResult)
  else
    Result := nil;
end;

function TdxPDFCustomRepository.GetDictionary(ANumber: Integer): TdxPDFDictionary;
var
  AResult: TdxPDFReferencedObject;
begin
  AResult := ResolveObject(ANumber);
  Result := nil;
  if (AResult <> nil) and (AResult is TdxPDFBase) then
    case TdxPDFBase(AResult).ObjectType of
      otStream:
        Result := TdxPDFStream(AResult).Dictionary;
      otDictionary:
        Result := AResult as TdxPDFDictionary;
    end;
end;

function TdxPDFCustomRepository.GetInteger(ANumber: Integer): TdxPDFInteger;
begin
  Result := GetObject(ANumber) as TdxPDFInteger;
end;

function TdxPDFCustomRepository.GetNumericObject(ANumber: Integer): TdxPDFNumericObject;
begin
  Result := GetObject(ANumber) as TdxPDFNumericObject;
end;

function TdxPDFCustomRepository.GetObject(ANumber: Integer): TdxPDFReferencedObject;
begin
  Result := ResolveObject(ANumber);
end;

function TdxPDFCustomRepository.GetStream(ANumber: Integer): TdxPDFStream;
var
  AObject: TdxPDFBase;
begin
  Result := nil;
  AObject := GetObject(ANumber) as TdxPDFBase;
  if AObject <> nil then
    if AObject.ObjectType = otDictionary then
      Result := TdxPDFDictionary(AObject).StreamRef
    else
      Result := AObject as TdxPDFStream;
end;

function TdxPDFCustomRepository.ResolveReference(AObject: TdxPDFBase): TdxPDFBase;
begin
  if TdxPDFUtils.IsReference(AObject) then
    Result := GetObject(AObject.Number) as TdxPDFBase
  else
    Result := AObject;
end;

procedure TdxPDFCustomRepository.Add(ANumber: Integer; AObject: TdxPDFReferencedObject; ACanReplace: Boolean = True);
begin
  TryAdd(ANumber, AObject, ACanReplace);
end;

procedure TdxPDFCustomRepository.Clear;
begin
  References.Clear;
end;

procedure TdxPDFCustomRepository.Remove(ANumber: Integer);
begin
  if References.ContainsKey(ANumber) then
    References.Remove(ANumber);
end;

procedure TdxPDFCustomRepository.TrimExcess;
begin
  FReferences.TrimExcess;
end;

function TdxPDFCustomRepository.ResolveObject(ANumber: Integer): TdxPDFReferencedObject;
begin
  if not References.TryGetValue(ANumber, Result) then
    Result := nil;
end;

procedure TdxPDFCustomRepository.CreateSubClasses;
begin
  FReferences := TdxPDFBaseReferences.Create;
end;

procedure TdxPDFCustomRepository.DestroySubClasses;
begin
  FreeAndNil(FReferences);
end;

procedure TdxPDFCustomRepository.Replace(ANumber: Integer; AObject: TdxPDFReferencedObject);
var
  ATemp: TdxPDFReferencedObject;
begin
  if References.TryGetValue(ANumber, ATemp) and ((ATemp <> AObject) or (ATemp = nil)) then
  begin
    Remove(ANumber);
    Add(ANumber, AObject);
  end;
end;

procedure TdxPDFCustomRepository.TryAdd(ANumber: Integer; AObject: TdxPDFReferencedObject; ACanReplace: Boolean);
begin
  if not References.ContainsKey(ANumber) then
    References.Add(ANumber, AObject)
  else
    if ACanReplace then
      Replace(ANumber, AObject)
    else
      dxPDFFreeObject(AObject);
end;

function TdxPDFCustomRepository.GetMaxObjectNumber: Integer;
begin
  Result := References.MaxKey;
end;

{ TdxPDFStringCommandData }

class function TdxPDFStringCommandData.Create(const ACharCodes: TdxPDFBytesDynArray; const AStr: TWordDynArray;
  const AOffsets: TDoubleDynArray): TdxPDFStringCommandData;
begin
  Result.FCharCodes := ACharCodes;
  Result.FStr := AStr;
  Result.FOffsets := AOffsets;
end;

{ TdxPDFStringData }

class function TdxPDFStringData.Create(const ACodePointData: TdxPDFStringCommandData;
  const AWidths, AAdvances: TDoubleDynArray): TdxPDFStringData;
begin
  Result.FCommandData := ACodePointData;
  Result.FWidths := AWidths;
  Result.FAdvances := AAdvances;
end;

function TdxPDFStringData.GetCharCodes: TdxPDFBytesDynArray;
begin
  Result := FCommandData.CharCodes;
end;

function TdxPDFStringData.GetStr: TWordDynArray;
begin
  Result := FCommandData.Str;
end;

function TdxPDFStringData.GetOffsets: TDoubleDynArray;
begin
  Result := FCommandData.Offsets;
end;

{ TdxPDFPagePoint }

class function TdxPDFPagePoint.Create: TdxPDFPagePoint;
begin
  Result.Invalid;
end;

class function TdxPDFPagePoint.Create(APageIndex: Integer; const APoint: TPoint): TdxPDFPagePoint;
begin
  Result := Create(APageIndex, dxPointF(APoint));
end;

class function TdxPDFPagePoint.Create(APageIndex: Integer; const APoint: TdxPointF): TdxPDFPagePoint;
begin
  Result.PageIndex := APageIndex;
  Result.Point := APoint;
end;

function TdxPDFPagePoint.IsValid: Boolean;
begin
  Result := PageIndex >= 0;
end;

procedure TdxPDFPagePoint.Invalid;
begin
  PageIndex := -1;
  Point := dxNullPointF;
end;

{ TdxPDFPageRect }

class function TdxPDFPageRect.Create: TdxPDFPageRect;
begin
  Result.Invalid;
end;

class function TdxPDFPageRect.Create(APageIndex: Integer; const ARect: TRect): TdxPDFPageRect;
begin
  Result := Create(APageIndex, dxRectF(ARect))
end;

class function TdxPDFPageRect.Create(APageIndex: Integer; const ARect: TdxRectF): TdxPDFPageRect;
begin
  Result.PageIndex := APageIndex;
  Result.Rect := ARect;
end;

class function TdxPDFPageRect.Create(const P1, P2: TdxPDFPagePoint): TdxPDFPageRect;
var
  APoint1, APoint2: TdxPointF;
begin
  Result.Invalid;
  if P1.PageIndex <> P2.PageIndex then
    Exit;
  try
    APoint1 := P1.Point;
    APoint2 := P2.Point;
    Result := TdxPDFPageRect.Create(P1.PageIndex,
      dxRectF(TdxPDFUtils.Min(APoint1.X, APoint2.X), TdxPDFUtils.Min(APoint1.Y, APoint2.Y),
              TdxPDFUtils.Max(APoint1.X, APoint2.X), TdxPDFUtils.Max(APoint1.Y, APoint2.Y)));
  except
    Result.Invalid;
  end;
end;

function TdxPDFPageRect.IsValid: Boolean;
begin
  Result := PageIndex >= 0;
end;

procedure TdxPDFPageRect.Invalid;
begin
  FPageIndex := -1;
  FRect := dxNullRectF;
end;

function TdxPDFPageRect.GetBottomRight: TdxPDFPagePoint;
begin
  Result := TdxPDFPagePoint.Create(PageIndex, Rect.BottomRight)
end;

function TdxPDFPageRect.GetTopLeft: TdxPDFPagePoint;
begin
  Result := TdxPDFPagePoint.Create(PageIndex, Rect.TopLeft)
end;

{ TdxPDFRectangle }

class function TdxPDFRectangle.Create(ALeft, ABottom, ARight, ATop: Single): TdxPDFRectangle;
begin
  Result.FLeft := ALeft;
  Result.FBottom := ABottom;
  Result.FRight := ARight;
  Result.FTop := ATop;
end;

class function TdxPDFRectangle.Create(const P1, P2: TdxPointF): TdxPDFRectangle;
var
  AX1, AX2, AY1, AY2: Double;
begin
  AX1 := P1.X;
  AX2 := P2.X;
  if AX1 < AX2 then
  begin
    Result.FLeft := AX1;
    Result.FRight := AX2;
  end
  else
  begin
    Result.FLeft := AX2;
    Result.FRight := AX1;
  end;
  AY1 := P1.Y;
  AY2 := P2.Y;
  if AY1 < AY2 then
  begin
    Result.FBottom := AY1;
    Result.FTop := AY2;
  end
  else
  begin
    Result.FBottom := AY2;
    Result.FTop := AY1;
  end;
end;

class function TdxPDFRectangle.Create(AArray: TdxPDFArray): TdxPDFRectangle;
var
  ALeft, ABottom, ARight, ATop, ATemp: Double;
begin
  if (AArray <> nil) and (AArray.Count = 4) then
  begin
    ALeft := TdxPDFDouble(AArray[0]).Value;
    ABottom := TdxPDFDouble(AArray[1]).Value;
    ARight := TdxPDFDouble(AArray[2]).Value;
    ATop := TdxPDFDouble(AArray[3]).Value;
    if ARight < ALeft then
    begin
      ATemp := ARight;
      ARight := ALeft;
      ALeft := ATemp;
    end;
    if ATop < ABottom then
    begin
      ATemp := ABottom;
      ABottom := ATop;
      ATop := ATemp;
    end;
    Result := TdxPDFRectangle.Create(ALeft, ABottom, ARight, ATop);
  end
  else
    Result := TdxPDFRectangle.Null;
end;

class function TdxPDFRectangle.Create(const APoints: TdxPDFPoints): TdxPDFRectangle;
var
  ACount, I: Integer;
  APoint: TdxPointF;
  AXMin, AXMax, AYMin, AYMax, X, Y: Double;
begin
  ACount := Length(APoints);
  if ACount = 0 then
    Exit(TdxPDFRectangle.Null);
  APoint := APoints[0];
  AXMin := APoint.X;
  AXMax := AXMin;
  AYMin := APoint.Y;
  AYMax := AYMin;
  for I := 1 to ACount - 1 do
  begin
    APoint := APoints[I];
    X := APoint.X;
    if X < AXMin then
      AXMin := X
    else
      if X > AXMax then
        AXMax := X;
    Y := APoint.Y;
    if Y < AYMin then
      AYMin := Y
    else
      if Y > AYMax then
        AYMax := Y;
  end;
  Result := TdxPDFRectangle.Create(AXMin, AYMin, AXMax, AYMax);
end;

class function TdxPDFRectangle.Equal(const R1, R2: TdxPDFRectangle; ADelta: Double): Boolean;
begin
  Result := IsSame(R1.Left, R2.Left, ADelta) and IsSame(R1.Bottom, R2.Bottom, ADelta) and
    IsSame(R1.Right, R2.Right, ADelta) and IsSame(R1.Top, R2.Top, ADelta);
end;

class function TdxPDFRectangle.Inflate(const R: TdxPDFRectangle; AAmount: Double): TdxPDFRectangle;
var
  ALeft, ABottom, ARight, ATop: Double;
begin
  if (AAmount * 2 > R.Width) or (AAmount * 2 > R.Height) then
    Exit(R);
  ALeft := R.Left + AAmount;
  ABottom := R.Bottom + AAmount;
  ARight := R.Right - AAmount;
  ATop := R.Top - AAmount;
  Result := TdxPDFRectangle.Create(ALeft, ABottom, ARight, ATop);
end;

class function TdxPDFRectangle.Intersect(const R1, R2: TdxPDFRectangle): TdxPDFRectangle;
begin
  if R1.Intersects(R2) then
    Result := TdxPDFRectangle.Create(Max(R1.Left, R2.Left), Max(R1.Bottom, R2.Bottom), Min(R1.Right, R2.Right), Min(R1.Top, R2.Top))
  else
    Result := TdxPDFRectangle.Null;
end;

class function TdxPDFRectangle.Null: TdxPDFRectangle;
begin
  Result := TdxPDFRectangle.Create(dxNullRectF.Left, dxNullRectF.Top, dxNullRectF.Right, dxNullRectF.Bottom);
end;

class function TdxPDFRectangle.Union(const R1, R2: TdxPDFRectangle): TdxPDFRectangle;
begin
  if R1.IsNull then
    Exit(R2);
  if R2.IsNull then
    Exit(R1);
  Result := TdxPDFRectangle.Create(TdxPDFUtils.Min(R1.Left, R2.Left), TdxPDFUtils.Min(R1.Bottom, R2.Bottom),
    TdxPDFUtils.Max(R1.Right, R2.Right), TdxPDFUtils.Max(R1.Top, R2.Top));
end;

function TdxPDFRectangle.Contains(const P: TdxPointF): Boolean;
begin
  Result := (FLeft <= P.X) and (FRight >= P.X) and (FTop >= P.Y) and (FBottom <= P.Y);
end;

function TdxPDFRectangle.Equals(const R: TdxPDFRectangle): Boolean;
begin
  Result := TdxPDFUtils.RectIsEqual(ToRectF, R.ToRectF, 0.001);
end;

function TdxPDFRectangle.Intersects(const R: TdxPDFRectangle): Boolean;
begin
  Result := (FLeft <= R.Right) and (FRight >= R.Left) and (FTop >= R.Bottom) and (FBottom <= R.Top);
end;

function TdxPDFRectangle.IsNull: Boolean;
begin
  Result := ToRectF.IsZero;
end;

function TdxPDFRectangle.Trim(const ARectangle: TdxPDFRectangle): TdxPDFRectangle;
var
  ALeft, ABottom, ARight, ATop: Double;
begin
  ALeft := Max(FLeft, ARectangle.left);
  ABottom := Max(FBottom, ARectangle.bottom);
  ARight := Min(FRight, ARectangle.right);
  ATop := Min(FTop, ARectangle.top);
  if (ALeft > ARight) or (ABottom > ATop) then
    Result := TdxPDFRectangle.Null
  else
    Result := TdxPDFRectangle.Create(ALeft, ABottom, ARight, ATop);
end;

function TdxPDFRectangle.ToRectF: TdxRectF;
begin
  Result := dxRectF(FLeft, FTop, FRight, FBottom);
end;

function TdxPDFRectangle.GetBottomLeft: TdxPointF;
begin
  Result := dxPointF(FLeft, FBottom);
end;

function TdxPDFRectangle.GetBottomRight: TdxPointF;
begin
  Result := dxPointF(FRight, FBottom);
end;

function TdxPDFRectangle.GetTopLeft: TdxPointF;
begin
  Result := dxPointF(FLeft, FTop);
end;

function TdxPDFRectangle.GetTopRight: TdxPointF;
begin
  Result := dxPointF(FRight, FTop);
end;

function TdxPDFRectangle.GetHeight: Single;
begin
  Result := FTop - FBottom;
end;

function TdxPDFRectangle.GetWidth: Single;
begin
  Result := FRight - FLeft;
end;

class function TdxPDFRectangle.IsSame(A, B, ADelta: Double): Boolean;
begin
  Result := Abs(A - B) <= ADelta;
end;

{ TdxPDFQuadrilateral }

class function TdxPDFQuadrilateral.Create(const P1, P2, P3, P4: TdxPointF): TdxPDFQuadrilateral;
begin
  Result.FP1 := P1;
  Result.FP2 := P2;
  Result.FP3 := P3;
  Result.FP4 := P4;
end;

class function TdxPDFQuadrilateral.Create(const ARect: TdxPDFOrientedRect): TdxPDFQuadrilateral;
var
  AVertices: TdxPointsF;
begin
  AVertices := ARect.GetVertices;
  Result.FP1 := AVertices[0];
  Result.FP2 := AVertices[1];
  Result.FP3 := AVertices[3];
  Result.FP4 := AVertices[2];
end;

function TdxPDFQuadrilateral.GetAsArray: TDoubleDynArray;
begin
  SetLength(Result, 8);
  Result[0] := P1.X;
  Result[1] := P1.Y;
  Result[2] := P2.X;
  Result[3] := P2.Y;
  Result[4] := P3.X;
  Result[5] := P3.Y;
  Result[6] := P4.X;
  Result[7] := P4.Y;
end;

function TdxPDFQuadrilateral.Contains(const P: TdxPointF): Boolean;
begin
  Result := TriangleContainsPoint(FP1, FP2, FP3, P) or TriangleContainsPoint(FP2, FP3, FP4, P);
end;

class function TdxPDFQuadrilateral.TriangleContainsPoint(const P1, P2, P3, ATargetPoint: TdxPointF): Boolean;
var
  ADot00, ADot01, ADot02, ADot11, ADot12, ADenominator, U, V: Double;
  AVector0, AVector1, AVector2: TdxPointF;
begin
  AVector0 := TdxPDFUtils.Subtract(P3, P1);
  AVector1 := TdxPDFUtils.Subtract(P2, P1);
  AVector2 := TdxPDFUtils.Subtract(ATargetPoint, P1);

  ADot00 := TdxPDFUtils.Dot(AVector0, AVector0);
  ADot01 := TdxPDFUtils.Dot(AVector0, AVector1);
  ADot02 := TdxPDFUtils.Dot(AVector0, AVector2);
  ADot11 := TdxPDFUtils.Dot(AVector1, AVector1);
  ADot12 := TdxPDFUtils.Dot(AVector1, AVector2);

  ADenominator := 1 / (ADot00 * ADot11 - ADot01 * ADot01);
  U := (ADot11 * ADot02 - ADot01 * ADot12) * ADenominator;
  V := (ADot00 * ADot12 - ADot01 * ADot02) * ADenominator;

  Result := (U > 0) and (V > 0) and (U + V <= 1);
end;

{ TdxPDFColor }

class function TdxPDFColor.Create: TdxPDFColor;
begin
  Result.FPattern := nil;
  Result.FIsNull := False;
  SetLength(Result.FComponents, 0);
end;

class function TdxPDFColor.Create(APattern: TdxPDFReferencedObject; const AComponents: TDoubleDynArray): TdxPDFColor;
begin
  Result := Create(AComponents);
  Result.FPattern := APattern;
end;

class function TdxPDFColor.Create(const AComponents: TDoubleDynArray): TdxPDFColor;
begin
  Result := Create;
  TdxPDFUtils.AddData(AComponents, Result.FComponents);
end;

class function TdxPDFColor.Create(const AArray: TdxPDFArray): TdxPDFColor;
var
  AComponent: Double;
  AComponents: TDoubleDynArray;
  I: Integer;
begin
  SetLength(AComponents, AArray.ElementList.Count);
  for I := 0 to AArray.ElementList.Count - 1 do
  begin
    AComponent := TdxPDFUtils.ConvertToDouble(AArray.ElementList[I]);
    AComponent := TdxPDFColor.ClipColorComponent(AComponent);
    AComponents[I] := AComponent;
  end;
  Result := Create(AComponents);
end;

class function TdxPDFColor.Create(const AColor: TColor): TdxPDFColor;
begin
  Result := TdxPDFUtils.ConvertToColor(AColor);
end;

class function TdxPDFColor.Create(const AColor: TdxPDFColor): TdxPDFColor;
begin
  Result := Create;
  Result.Assign(AColor);
end;

class function TdxPDFColor.Create(const X, Y, Z, AWhitePointZ: Double): TdxPDFColor;
begin
  Result := Create(GetComponents(X, Y, X, AWhitePointZ));
end;

class function TdxPDFColor.Create(const C1: Double): TdxPDFColor;
begin
  Result := Create;
  Result.AddComponent(C1);
end;

class function TdxPDFColor.Create(const C1, C2, C3: Double): TdxPDFColor;
begin
  Result := Create(C1);
  Result.AddComponent(C2);
  Result.AddComponent(C3);
end;

class function TdxPDFColor.GetComponents(const X, Y, Z, AWhitePointZ: Double): TDoubleDynArray;
var
  ARed, AGreen, ABlue: Double;
begin
  if AWhitePointZ < 1 then
  begin
    ARed := X * 3.1339 + Y * -1.6170 + Z * -0.4906;
    AGreen := X * -0.9785 + Y * 1.9160 + Z * 0.0333;
    ABlue := X * 0.0720 + Y * -0.2290 + Z * 1.4057;
  end
  else
  begin
    ARed := X * 3.2406 + Y * -1.5372 + Z * -0.4986;
    AGreen := X * -0.9689 + Y * 1.8758 + Z * 0.0415;
    ABlue := X * 0.0557 + Y * -0.2040 + Z * 1.0570;
  end;
  SetLength(Result, 3);
  Result[0] := ColorComponentTransferFunction(ARed);
  Result[1] := ColorComponentTransferFunction(AGreen);
  Result[2] := ColorComponentTransferFunction(ABlue);
end;

class function TdxPDFColor.Null: TdxPDFColor;
begin
  Result := Create;
  Result.FIsNull := True;
end;

procedure TdxPDFColor.Assign(const AColor: TdxPDFColor);
begin
  Pattern := AColor.Pattern;
  SetLength(FComponents, 0);
  TdxPDFUtils.AddData(AColor.Components, FComponents);
end;

class function TdxPDFColor.ClipColorComponent(const AComponent: Double): Double;
begin
  Result := TdxPDFUtils.Min(1, TdxPDFUtils.Max(0, AComponent));
end;

class function TdxPDFColor.ColorComponentTransferFunction(const AComponent: Double): Double;
var
  ATemp: Double;
begin
  ATemp := ClipColorComponent(AComponent);
  if ATemp > 0.0031308 then
    Result := ClipColorComponent(Power(ATemp, 1 / 2.4) * 1.055 - 0.055)
  else
    Result := ClipColorComponent(ATemp * 12.92);
end;

function TdxPDFColor.IsNull: Boolean;
begin
  Result := FIsNull;
end;

function TdxPDFColor.ToColor: TColor;
begin
  Result := TdxPDFUtils.ConvertToColor(Self);
end;

procedure TdxPDFColor.AssignAndTransferComponents(const AComponents: TDoubleDynArray);
var
  AValue: Double;
begin
  SetLength(FComponents, 0);
  if AComponents <> nil then
    for AValue in AComponents do
      AddComponent(AValue);
end;

procedure TdxPDFColor.AddComponent(const AValue: Double);
begin
  TdxPDFUtils.AddValue(ColorComponentTransferFunction(AValue), FComponents);
end;

procedure TdxPDFColor.SetPattern(const AValue: TdxPDFReferencedObject);
begin
  FPattern := AValue;
end;

{ TdxPDFARGBColor }

class function TdxPDFARGBColor.Create(AColor: TColor): TdxPDFARGBColor;
begin
  Result := TdxPDFARGBColor.Create(TdxPDFColor.Create(AColor));
end;

class function TdxPDFARGBColor.Create(const AColor: TdxPDFColor): TdxPDFARGBColor;
begin
  if not AColor.IsNull then
  begin
    case Length(AColor.Components) of
      1:
        Result := Create(AColor.Components[0], AColor.Components[0], AColor.Components[0]);
      3:
        Result := Create(AColor.Components[0], AColor.Components[1], AColor.Components[2]);
      4:
        Result := CreateFromCMYK(AColor.Components[0], AColor.Components[1], AColor.Components[2], AColor.Components[3]);
    else
      Result := Create(0, 0, 0);
    end;
    Result.FIsNull := False;
  end
  else
    Result.FIsNull := True;
end;

class function TdxPDFARGBColor.Create(const ARed, AGreen, ABlue: Double; AAlpha: Byte = 1): TdxPDFARGBColor;
begin
  Result.FRed := ARed;
  Result.FGreen := AGreen;
  Result.FBlue := ABlue;
  Result.FAlpha := AAlpha;
  Result.FIsNull := False;
end;

class function TdxPDFARGBColor.CreateFromCMYK(const ACyan, AMagenta, AYellow, ABlack: Double): TdxPDFARGBColor;
var
  ACyanComplement, AMagentaComplement, AYellowComplement, ABlackComplement, AAddition, ARed, AGreen, ABlue: Double;
begin
  ACyanComplement := 1 - ACyan;
  AMagentaComplement := 1 - AMagenta;
  AYellowComplement := 1 - AYellow;
  ABlackComplement := 1 - ABlack;
  AAddition := ACyanComplement * AMagentaComplement * AYellowComplement * ABlackComplement;
  ARed := AAddition;
  AGreen := AAddition;
  ABlue := AAddition;
  AAddition := ACyanComplement * AMagentaComplement * AYellowComplement * ABlack;

  ARed := ARed + 0.1373 * AAddition;
  AGreen := AGreen + 0.1216 * AAddition;
  ABlue := ABlue + 0.1255 * AAddition;
  AAddition := ACyanComplement * AMagentaComplement * AYellow * ABlackComplement;

  ARed := ARed + AAddition;
  AGreen := AGreen + 0.9490 * AAddition;
  AAddition := ACyanComplement * AMagentaComplement * AYellow * ABlack;

  ARed := ARed + 0.1098 * AAddition;
  AGreen := AGreen + 0.1020 * AAddition;
  AAddition := ACyanComplement * AMagenta * AYellowComplement * ABlackComplement;

  ARed := ARed + 0.9255 * AAddition;
  ABlue := ABlue + 0.5490 * AAddition;
  ARed := ARed + 0.1412 * (ACyanComplement * AMagenta * AYellowComplement * ABlack);
  AAddition := ACyanComplement * AMagenta * AYellow * ABlackComplement;

  ARed := ARed + 0.9294 * AAddition;
  AGreen := AGreen + 0.1098 * AAddition;
  ABlue := ABlue + 0.1412 * AAddition;
  ARed := ARed + 0.1333 * (ACyanComplement * AMagenta * AYellow * ABlack);
  AAddition := ACyan * AMagentaComplement * AYellowComplement * ABlackComplement;

  AGreen := AGreen + 0.6784 * AAddition;
  ABlue := ABlue + 0.9373 * AAddition;
  AAddition := ACyan * AMagentaComplement * AYellowComplement * ABlack;

  AGreen := AGreen + 0.0588 * AAddition;
  ABlue := ABlue + 0.1412 * AAddition;
  AAddition := ACyan * AMagentaComplement * AYellow * ABlackComplement;

  AGreen := AGreen + 0.6510 * AAddition;
  ABlue := ABlue + 0.3137 * AAddition;
  AGreen := AGreen + 0.0745 * (ACyan * AMagentaComplement * AYellow * ABlack);
  AAddition := ACyan * AMagenta * AYellowComplement * ABlackComplement;

  ARed := ARed + 0.1804 * AAddition;
  AGreen := AGreen + 0.1922 * AAddition;
  ABlue := ABlue + 0.5725 * AAddition;
  ABlue := ABlue + 0.0078 * (ACyan * AMagenta * AYellowComplement * ABlack);
  AAddition := ACyan * AMagenta * AYellow * ABlackComplement;

  Result.FRed := TdxPDFColor.ClipColorComponent(ARed + 0.2118 * AAddition);
  Result.FGreen := TdxPDFColor.ClipColorComponent(AGreen + 0.2119 * AAddition);
  Result.FBlue := TdxPDFColor.ClipColorComponent(ABlue + 0.2235 * AAddition);
  Result.FIsNull := False;
end;

class function TdxPDFARGBColor.Convert(const AColor: TdxPDFARGBColor): TdxPDFColor;
var
  AComponents: TDoubleDynArray;
begin
  SetLength(AComponents, 3);
  AComponents[0] := AColor.Red;
  AComponents[1] := AColor.Green;
  AComponents[2] := AColor.Blue;
  Result := TdxPDFColor.Create(AComponents);
end;

class function TdxPDFARGBColor.ConvertToBytes(ACyan, AMagenta, AYellow, ABlack: Byte): TBytes;
var
  ACyanComplement, AMagentaComplement, AYellowComplement, ABlackComplement, ABlackDiv, AAddition, ARed, AGreen, ABlue: Double;
  D: Integer;
begin
  SetLength(Result , 3);
  Result[0] := 0;
  Result[1] := 0;
  Result[2] := 0;
  if ABlack <> 255 then
  begin
    ACyanComplement := 255 - ACyan;
    AMagentaComplement := 255 - AMagenta;
    AYellowComplement := 255 - AYellow;
    ABlackComplement := 255 - ABlack;
    ABlackDiv := ABlack / ABlackComplement;

    AAddition := ACyanComplement * AMagentaComplement * AYellowComplement * ABlackComplement;
    ARed := AAddition;
    AGreen := AAddition;
    ABlue := AAddition;

    AAddition := AAddition * ABlackDiv;
    ARed := ARed + 0.1373 * AAddition;
    AGreen := AGreen  + 0.1216 * AAddition;
    ABlue := ABlue + 0.1255 * AAddition;
    AAddition := ACyanComplement * AMagentaComplement * AYellow * ABlackComplement;
    ARed := ARed + AAddition;
    AGreen := AGreen + 0.9490 * AAddition;

    AAddition := AAddition * ABlackDiv;
    ARed := ARed + 0.1098 * AAddition;
    AGreen := AGreen + 0.1020 * AAddition;
    AAddition := ACyanComplement * AMagenta * AYellowComplement * ABlackComplement;
    ARed := ARed + 0.9255 * AAddition;
    ABlue := ABlue + 0.5490 * AAddition;

    ARed := ARed + 0.1412 * (AAddition * ABlackDiv);
    AAddition := ACyanComplement * AMagenta * AYellow * ABlackComplement;
    ARed := ARed + 0.9294 * AAddition;
    AGreen := AGreen + 0.1098 * AAddition;
    ABlue := ABlue + 0.1412 * AAddition;
    ARed := ARed + 0.1333 * AAddition * ABlackDiv;
    AAddition := ACyan * AMagentaComplement * AYellowComplement * ABlackComplement;
    AGreen := AGreen + 0.6784 * AAddition;
    ABlue := ABlue + 0.9373 * AAddition;

    AAddition := AAddition * ABlackDiv;
    AGreen := AGreen + 0.0588 * AAddition;
    ABlue := ABlue + 0.1412 * AAddition;
    AAddition := ACyan * AMagentaComplement * AYellow * ABlackComplement;
    AGreen := AGreen + 0.6510 * AAddition;
    ABlue := ABlue + 0.3137 * AAddition;
    AGreen := AGreen + 0.0745 * (ACyan * AMagentaComplement * AYellow * ABlack);
    AAddition := ACyan * AMagenta * AYellowComplement * ABlackComplement;
    ARed := ARed + 0.1804 * AAddition;
    AGreen := AGreen + 0.1922 * AAddition;
    ABlue := ABlue + 0.5725 * AAddition;
    ABlue := ABlue + 0.0078 * (AAddition * ABlackDiv);
    AAddition := ACyan * AMagenta * AYellow * ABlackComplement;

    D := 16581375;
    SetLength(Result , 3);
    Result[0] := Trunc((ARed + 0.2118 * AAddition) / D);
    Result[1] := Trunc((AGreen + 0.2119 * AAddition) / D);
    Result[2] := Trunc((ABlue + 0.2235 * AAddition) / D);
  end;
end;

class function TdxPDFARGBColor.ConvertToRGB(const AData: TBytes; APixelFormat: TdxPDFPixelFormat): TBytes;
var
  I, AIndex: Integer;
begin
  case APixelFormat of
    pfGray1bit:
      SetLength(Result, 0);
    pfGray8bit:
      begin
        AIndex := 0;
        SetLength(Result, Length(AData) * 3);
        for I := 0 to Length(AData) - 1 do
        begin
          TdxPDFUtils.CopyData(AData, I, Result, AIndex, 3);
          Inc(AIndex, 3);
        end;
      end;
  else
    Result := AData;
  end;
end;

class function TdxPDFARGBColor.Null: TdxPDFARGBColor;
begin
  Result.FIsNull := True;
end;

function TdxPDFARGBColor.IsNull: Boolean;
begin
  Result := FIsNull;
end;

function TdxPDFARGBColor.ToPDFColor: TdxPDFColor;
begin
  Result := TdxPDFARGBColor.Convert(Self);
end;

{ TdxPDFCustomProperties }

constructor TdxPDFCustomProperties.Create(ADictionary: TdxPDFDictionary);
begin
  inherited Create;
  FDictionary := TdxPDFDictionary.Create;
  ADictionary.EnumKeys(
    procedure(const AKey: string)
    begin
      Dictionary.Add(AKey, ADictionary.GetObject(AKey));
    end);
end;

destructor TdxPDFCustomProperties.Destroy;
begin
  Dictionary := nil;
  inherited Destroy;
end;

procedure TdxPDFCustomProperties.Write(AWriter: TdxPDFWriter);
begin
  Dictionary.Write(AWriter);
end;

procedure TdxPDFCustomProperties.SetDictionary(const AValue: TdxPDFDictionary);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDictionary));
end;

{ TdxPDFBlendModeDictionary }

class function TdxPDFBlendModeDictionary.ToString(AValue: TdxPDFBlendMode): string;
begin
  Result := Map[AValue];
end;

class function TdxPDFBlendModeDictionary.ToValue(const AString: string): TdxPDFBlendMode;
begin
  if not TryGetValue(AString, Result) then
    Result := bmNormal;
end;

class function TdxPDFBlendModeDictionary.TryGetValue(const AKey: string; out AValue: TdxPDFBlendMode): Boolean;
var
  AIndex: TdxPDFBlendMode;
begin
  for AIndex := Low(Map) to High(Map) do
    if Map[AIndex] = AKey then
    begin
      AValue := AIndex;
      Exit(True);
    end;
  Result := False;
end;

{ TdxPDFCommandOperandStack }

constructor TdxPDFCommandOperandStack.Create;
begin
  inherited Create;
  FStack := TdxObjectStack<TdxPDFBase>.Create(True);
end;

destructor TdxPDFCommandOperandStack.Destroy;
begin
  FreeAndNil(FStack);
  inherited Destroy;
end;

function TdxPDFCommandOperandStack.TryPopLastName: string;
var
  ALastIndex: Integer;
  ALastParameter: TdxPDFBase;
begin
  ALastIndex := FStack.Count - 1;
  if ALastIndex < 0 then
    TdxPDFUtils.RaiseTestException('List index out of bounds');
  ALastParameter := PopAsObject;
  if ALastParameter <> nil then
  begin
    if (ALastParameter <> nil) and (ALastParameter.ObjectType in [otName, otString]) then
    begin
      Result := TdxPDFString(ALastParameter).Value;
      dxPDFFreeObject(ALastParameter);
      Exit;
    end;
    Result := '';
    Push(ALastParameter);
  end;
end;

function TdxPDFCommandOperandStack.PopAsArray: TdxPDFArray;
var
  AObject: TdxPDFBase;
begin
  AObject := PopAsObject;
  if (AObject <> nil) and (AObject.ObjectType = otArray) then
    Result := TdxPDFArray(AObject)
  else
    Result := nil;
end;

function TdxPDFCommandOperandStack.PopAsBytes: TBytes;
var
  AResult: string;
  I: Integer;
begin
  AResult := PopAsString;
  SetLength(Result, Length(AResult));
  for I := 0 to Length(Result) - 1 do
    Result[I] := Byte(AResult[I + 1]);
end;

function TdxPDFCommandOperandStack.PopAsInteger: Integer;
var
  AObject: TdxPDFBase;
begin
  Result := 0;
  AObject := PopAsObject;
  if AObject <> nil then
    try
      if AObject.ObjectType = otInteger then
        Result := TdxPDFInteger(AObject).Value
    finally
      dxPDFFreeObject(AObject);
    end;
end;

function TdxPDFCommandOperandStack.PopAsObject: TdxPDFBase;
begin
  Result := nil;
  if FStack.Count > 0 then
    Result := FStack.Extract
  else
    try
      TdxPDFUtils.RaiseTestException('Stack is empty');
    except
    end;
end;

function TdxPDFCommandOperandStack.PopAsSingle: Single;
var
  AObject: TdxPDFBase;
begin
  Result := 0;
  AObject := PopAsObject;
  if AObject <> nil then
    try
      case AObject.ObjectType of
        otDouble:
          Result := TdxPDFDouble(AObject).Value;
        otInteger:
          Result := TdxPDFInteger(AObject).Value;
      end;
    finally
      dxPDFFreeObject(AObject);
    end;
end;

function TdxPDFCommandOperandStack.PopAsString: string;
var
  AObject: TdxPDFBase;
begin
  Result := '';
  AObject := PopAsObject;
  if AObject <> nil then
    try
      case AObject.ObjectType of
        otName:
          Result := TdxPDFName(AObject).Value;
        otString:
          Result := TdxPDFString(AObject).Value;
      end;
    finally
      dxPDFFreeObject(AObject);
    end;
end;

procedure TdxPDFCommandOperandStack.Clear;
begin
  FStack.Clear;
end;

procedure TdxPDFCommandOperandStack.Push(AObject: TdxPDFBase);
begin
  FStack.Push(AObject);
end;

function TdxPDFCommandOperandStack.GetCount: Integer;
begin
  Result := FStack.Count;
end;

{ TdxPDFFontMetricsMetadata }

class function TdxPDFFontMetricsMetadata.Create: TdxPDFFontMetricsMetadata;
begin
  Result.FIsNull := True;
end;

class function TdxPDFFontMetricsMetadata.Create(const AAscent, ADescent, AEmSize, ACalculatedLineSpacing: Double): TdxPDFFontMetricsMetadata;
begin
  Result.FAscent := AAscent;
  Result.FDescent := ADescent;
  Result.FEmSize := AEmSize;
  Result.FIsNull := False;
  Result.FLineSpacing := ACalculatedLineSpacing;
  if Result.FLineSpacing < 1 then
    Result.FLineSpacing := Result.Height;
end;

function TdxPDFFontMetricsMetadata.IsNull: Boolean;
begin
  Result := FIsNull;
end;

function TdxPDFFontMetricsMetadata.GetHeight: Double;
begin
  Result := Max(1, FAscent - FDescent);
end;

{ TdxPDFLineStyle }

constructor TdxPDFLineStyle.Create(const APattern: TDoubleDynArray; APhase: Double);
begin
  inherited Create;
  FPattern := APattern;
  FPhase := APhase;
end;

constructor TdxPDFLineStyle.Create(APattern: TdxPDFReferencedObject);
var
  APhase: TdxPDFInteger;
begin
  APhase := TdxPDFInteger.Create(0);
  try
    Create(APattern, APhase);
  finally
    APhase.Free;
  end;
end;

constructor TdxPDFLineStyle.Create(APattern, APhase: TdxPDFReferencedObject);
begin
  inherited Create;
  if APhase <> nil then
    FPhase := AsDouble(APhase);
  if APattern <> nil then
    ReadPattern(APattern as TdxPDFArray);
end;

constructor TdxPDFLineStyle.Create(AParameters: TdxPDFArray);
begin
  inherited Create;
  if AParameters.Count = 2 then
    Create(AParameters[0], AParameters[1]);
end;

function TdxPDFLineStyle.IsDashed: Boolean;
begin
  Result := Length(FPattern) <> 0;
end;

function TdxPDFLineStyle.Write: TdxPDFArray;
begin
  if IsDashed then
  begin
    Result := TdxPDFArray.Create;
    Result.Add(WritePattern);
    Result.Add(FPhase);
  end
  else
    Result := nil;
end;

function TdxPDFLineStyle.AsDouble(AValue: TdxPDFReferencedObject): Double;
begin
  Result := (AValue as TdxPDFNumericObject).InternalValue;
end;

procedure TdxPDFLineStyle.ReadPattern(APattern: TdxPDFArray);
var
  I: Integer;
begin
  SetLength(FPattern, APattern.Count);
  for I := 0 to APattern.Count - 1 do
    FPattern[I] := AsDouble(APattern[I] as TdxPDFNumericObject);
end;

function TdxPDFLineStyle.WritePattern: TdxPDFArray;
var
  I: Integer;
begin
  Result := TdxPDFArray.Create;
  for I := 0 to Length(FPattern) - 1 do
    Result.Add(FPattern[I]);
end;

{ TdxPDFRangeHelper }

class function TdxPDFRangeHelper.Invalid: TdxDoubleRange;
begin
  Result := Create(-MaxInt, -MaxInt);
end;

end.

