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

unit dxPDFType1Font;

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Windows, Classes, Generics.Defaults, Generics.Collections, cxGeometry, dxCoreClasses, dxFontFile,
  dxPDFBase, dxPDFTypes, dxPDFCore, dxPDFCharacterMapping, dxPDFFont, dxPDFPostScript, dxPDFText, dxPDFFontEncoding;

type
  TdxType1FontCustomCharset = class;
  TdxType1FontCustomCharsetClass = class of TdxType1FontCustomCharset;
  TdxCompactFontFormatStringIndex = class;
  TdxCompactFontFormatDictIndexStringTwoByteOperator = class;
  TdxType1FontPrivateData = class;

  TdxType1FontPaintType = (ptInvalid = -1, ptFilled = 0, ptStroked = 2);
  TdxType1FontPredefinedEncodingID = (peStandardEncoding, peExpertEncoding);
  TdxType1FontType = (ftInvalid = -1, ftType1 = 1, ftType2 = 2);
  TdxType1FontWMode = (wmHorizontal = 0, wmVertical = 1);

  { IdxCompactFontFormatDictIndexOffsetOperator }

  IdxCompactFontFormatDictIndexOffsetOperator = interface
  ['{B35B5DF3-5BD3-4413-A0CA-EB1D04E79865}']
    function GetLength: Integer;
    function GetOffset: Integer;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer;
    procedure SetOffset(const AValue: Integer);
    procedure WriteData(AStream: TdxFontFileStream);

    property Length: Integer read GetLength;
    property Offset: Integer read GetOffset write SetOffset;
  end;
  TdxCompactFontFormatDictIndexOffsetOperatorList = class(TList<IdxCompactFontFormatDictIndexOffsetOperator>);

  TdxType1FontPredefinedCharsetID = (pcISOAdobe, pcExpert, pcExpertSubset);
  TdxCompactFontFormatTarnsformationMatrix = TXForm;

  TdxType1FontGlyphZone = record
  public
    Bottom: Double;
    Top: Double;
    class function Create(ABotom, ATop: Double): TdxType1FontGlyphZone; static;
  end;
  TdxType1FontGlyphZones = array of TdxType1FontGlyphZone;

  { TdxPDFType1FontDescriptor }

  TdxPDFType1FontDescriptor = class(TdxPDFCIDType0FontDescriptor)
  protected
    function GetSubtypeName: string; override;
    procedure ReadFontFile(ADictionary: TdxPDFReaderDictionary); override;
    procedure WriteFontFile(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  end;

  { TdxPDFType1Font }

  TdxPDFType1Font = class(TdxPDFSimpleFont)
  strict private
    FUseDefaultFontDescriptor: Boolean;
    function GetFontDescriptor: TdxPDFType1FontDescriptor;
  protected
    function GetLineSpacingForMetrics: Double; override;
    function CreateFontProgramFacade: TObject; override;
    function GetFontDescriptorClass: TdxPDFCustomFontDescriptorClass; override;
    function IsCourierFont: Boolean; override;
    function NeedWriteFontDescriptor: Boolean; override;
    procedure ReadFontDescriptor(ADictionary: TdxPDFReaderDictionary); override;
  public
    class function GetSubTypeName: string; override;
    property FontDescriptor: TdxPDFType1FontDescriptor read GetFontDescriptor;
  end;

  { TdxPDFMMType1Font }

  TdxPDFMMType1Font = class(TdxPDFType1Font)
  public
    class function GetSubTypeName: string; override;
  end;

  { TdxPDFUnknownFont }

  TdxPDFUnknownFont = class(TdxPDFType1Font);

  { TdxType1FontCIDGlyphGroupData }

  TdxType1FontCIDGlyphGroupData = class
  public
    CIDCount: Integer;
    CIDFontName: string;
    FontBBox: TdxRectF;
    FontMatrix: TdxCompactFontFormatTarnsformationMatrix;
    FontType: TdxType1FontType;
    PrivateData: TdxType1FontPrivateData;
    UnderlinePosition: Double;
    UnderlineThickness: Double;
    UniqueID: Integer;

    constructor Create;
    destructor Destroy; override;
  end;

  { TdxType1SupplementDataEntry }

  TdxType1SupplementDataEntry = record
    Code: Byte;
    GID: SmallInt;
    class function Create(AGID: SmallInt; ACode: Byte): TdxType1SupplementDataEntry; static;
  end;
  TdxType1FontEncodingEntries = array of TdxType1SupplementDataEntry;

  { TdxType1FontPrivateData }

  TdxType1FontPrivateData = class
  strict private
    FBlueFuzz: Integer;
    FBlueScale: Double;
    FBlueShift: Double;
    FBlueValues: TdxType1FontGlyphZones;
    FExpansionFactor: Double;
    FFamilyBlues: TdxType1FontGlyphZones;
    FFamilyOtherBlues: TdxType1FontGlyphZones;
    FForceBold: Boolean;
    FForceBoldThreshold: Double;
    FStdHW: Double;
    FStdVW: Double;
    FStemSnapH: TDoubleDynArray;
    FStemSnapV: TDoubleDynArray;
    FOtherBlues: TdxType1FontGlyphZones;
    class function IsInvalidBlueValues(const ABlueValues: TdxType1FontGlyphZones): Boolean; static;
    class function IsInvalidOtherBlues(const AOtherBlues: TdxType1FontGlyphZones): Boolean; static;
    class function IsInvalidStemSnap(const AStemSnap: TDoubleDynArray): Boolean; static;
  protected
    procedure Validate;
  public const
    DefaultBlueScale = 0.039625;
    DefaultBlueShift = 7;
    DefaultExpansionFactor = 0.06;
  public
    constructor Create;

    property BlueFuzz: Integer read FBlueFuzz write FBlueFuzz;
    property BlueScale: Double read FBlueScale write FBlueScale;
    property BlueShift: Double read FBlueShift write FBlueShift;
    property BlueValues: TdxType1FontGlyphZones read FBlueValues write FBlueValues;
    property ExpansionFactor: Double read FExpansionFactor write FExpansionFactor;
    property FamilyBlues: TdxType1FontGlyphZones read FFamilyBlues write FFamilyBlues;
    property FamilyOtherBlues: TdxType1FontGlyphZones read FFamilyOtherBlues write FFamilyOtherBlues;
    property ForceBold: Boolean read FForceBold write FForceBold;
    property ForceBoldThreshold: Double read FForceBoldThreshold write FForceBoldThreshold;
    property OtherBlues: TdxType1FontGlyphZones read FOtherBlues write FOtherBlues;
    property StdHW: Double read FStdHW write FStdHW;
    property StdVW: Double read FStdVW write FStdVW;
    property StemSnapH: TDoubleDynArray read FStemSnapH write FStemSnapH;
    property StemSnapV: TDoubleDynArray read FStemSnapV write FStemSnapV;
  end;

  { TdxType1FontCompactFontPrivateData }

  TdxType1FontCompactFontPrivateData = class(TdxType1FontPrivateData)
  strict private
    FDefaultWidthX: Double;
    FLanguageGroup: Integer;
    FNominalWidthX: Double;
    FSubrs: TdxPDFBytesList;
    procedure SetSubrs(const AValue: TdxPDFBytesList);
  public const
    DefaultBlueFuzz = 1;
    DefaultLanguageGroup = 0;
    DefaultDefaultWidthX = 0;
    DefaultNominalWidthX = 0;
  public
    constructor Create;
    destructor Destroy; override;

    property DefaultWidthX: Double read FDefaultWidthX write FDefaultWidthX;
    property LanguageGroup: Integer read FLanguageGroup write FLanguageGroup;
    property NominalWidthX: Double read FNominalWidthX write FNominalWidthX;
    property Subrs: TdxPDFBytesList read FSubrs write SetSubrs;
  end;

  { TdxType1FontClassicFontPrivateData }

  TdxType1FontClassicFontPrivateData = class(TdxType1FontPrivateData);

  { TdxType1FontInfo }

  TdxType1FontInfo = class
  public
    Ascent: Double;
    BaseFontName: string;
    Copyright: string;
    Descent: Double;
    Em: Double;
    FamilyName: string;
    FontMatrix: TdxCompactFontFormatTarnsformationMatrix;
    FSType: Integer;
    FullName: string;
    IsFixedPitch: Boolean;
    ItalicAngle: Double;
    Notice: string;
    UnderlinePosition: Double;
    UnderlineThickness: Double;
    Version: string;
    Weight: string;

    class function DefaultItalicAngle: Integer; static;
    class function DefaultStrokeWidth: Integer; static;
    class function DefaultUnderlinePosition: Integer; static;
    class function DefaultUnderlineThickness: Integer; static;
    class function DefaultUniqueID: Integer; static;

    constructor Create;
    procedure Read(ADictionary: TdxPDFPostScriptDictionary); virtual;
  end;

  TdxPDFType1FontClassicFontInfo = class(TdxType1FontInfo)
  strict private const
    VersionDictionaryKey = 'version';
    NoticeDictionaryKey = 'Notice';
    CopyrightDictionaryKey = 'Copyright';
    FullNameDictionaryKey = 'FullName';
    FamilyNameDictionaryKey = 'FamilyName';
    BaseFontNameDictionaryKey = 'BaseFontName';
    WeightDictionaryKey = 'Weight';
    ItalicAngleDictionaryKey = 'ItalicAngle';
    IsFixedPitchDictionaryKey = 'isFixedPitch';
    UnderlinePositionDictionaryKey = 'UnderlinePosition';
    UnderlineThicknessDictionaryKey = 'UnderlineThickness';
    EmDictionaryKey = 'em';
    AscentDictionaryKey = 'ascent';
    DescentDictionaryKey = 'descent';
    FSTypeDictionaryKey = 'FSType';
  strict private
    procedure OptionalSerializeDouble(ABuilder: TStringBuilder; const AKey: string; AValue: Double);
    procedure SerializeDouble(ABuilder: TStringBuilder; const AKey: string; AValue: Double);
    procedure SerializeString(ABuilder: TStringBuilder; const AKey, AValue: string);
  public
    function Serialize: string;
    procedure Read(ADictionary: TdxPDFPostScriptDictionary); override;
  end;

  { TdxType1FontEncoding }

  TdxType1FontEncoding = class
  public
    function GetCodeToGIDMapping(ACharset: TdxType1FontCustomCharset;
      AStringIndex: TdxCompactFontFormatStringIndex): TSmallIntDynArray; virtual; abstract;
    function GetDataLength: Integer; virtual; abstract;
    function GetOffset: Integer; virtual;
    function IsDefault: Boolean; virtual;
  end;

  { TdxType1FontPredefinedEncoding }

  TdxType1FontPredefinedEncoding = class(TdxType1FontEncoding)
  strict private
    FExpertEncoding: TdxPDFByteStringDictionary;
    FID: TdxType1FontPredefinedEncodingID;
    FStandardEncoding: TdxFontFileCustomEncoding;
    procedure InitializeExpertEncoding;
  public
    constructor Create(AID: TdxType1FontPredefinedEncodingID);
    destructor Destroy; override;
    function GetCodeToGIDMapping(ACharset: TdxType1FontCustomCharset;
      AStringIndex: TdxCompactFontFormatStringIndex): TSmallIntDynArray; override;
    function GetDataLength: Integer; override;
    function GetOffset: Integer; override;
    function IsDefault: Boolean; override;
  end;

  { TdxType1FontCustomEncoding }

  TdxType1FontCustomEncoding = class(TdxType1FontEncoding)
  strict private const
    SupplementDataFlag = $80;
    IDMask = SupplementDataFlag xor $FF;
  strict private
    FSupplementData: TdxType1FontEncodingEntries;
    //
    procedure ReadSupplementData(AStream: TdxFontFileStream);
  protected
    function CodeToGIDMapping: TSmallIntDynArray; virtual; abstract;
    function EncodingID: Byte; virtual; abstract;
    procedure WriteEncodingData(AStream: TdxFontFileStream); virtual; abstract;
    //
    function SupplementDataLength: Byte;
    procedure FillEntry(const AMapping: TSmallIntDynArray; ACode: Byte; AGid: SmallInt);
  public
    class function Parse(AStream: TdxFontFileStream): TdxType1FontCustomEncoding; static;
    //
    constructor Create(AStream: TdxFontFileStream); virtual;
    function GetCodeToGIDMapping(ACharset: TdxType1FontCustomCharset;
      AStringIndex: TdxCompactFontFormatStringIndex): TSmallIntDynArray; override;
    procedure Write(AStream: TdxFontFileStream);
  end;

  { TdxType1FontArrayEncoding }

  TdxType1FontArrayEncoding = class(TdxType1FontCustomEncoding)
  strict private
    FArray: TBytes;
  protected
    function CodeToGIDMapping: TSmallIntDynArray; override;
    function EncodingID: Byte; override;
    procedure WriteEncodingData(AStream: TdxFontFileStream); override;
  public
    constructor Create(AStream: TdxFontFileStream); override;
    function GetDataLength: Integer; override;
  end;

  { TdxType1FontRangeEncoding }

  TdxType1FontRangeEncoding = class(TdxType1FontCustomEncoding)
  strict private type
    TRange = record
      Start: Byte;
      Remain: Byte;
      class function Create(AStart, ARemain: Byte): TRange; static;
    end;
    TRanges = array of TRange;
  strict private
    FRanges: TRanges;
  protected
    function CodeToGIDMapping: TSmallIntDynArray; override;
    function EncodingID: Byte; override;
    procedure WriteEncodingData(AStream: TdxFontFileStream); override;
  public
    constructor Create(AStream: TdxFontFileStream); override;
    function GetDataLength: Integer; override;
  end;

  { TdxCompactFontFormatIndex }

  TdxCompactFontFormatIndex = class
  strict private
    function GetDataLength: Integer;
  protected
    function GetObjectCount: Integer; virtual; abstract;
    function GetObjectDataLength(AIndex: Integer): Integer; virtual; abstract;
    procedure ProcessObject(AIndex: Integer; const AData: TBytes); virtual; abstract;
    procedure ProcessObjectCount(ACount: Integer); virtual; abstract;
    procedure WriteObject(AStream: TdxFontFileStream; AIndex: Integer); virtual; abstract;
  public
    constructor Create; overload;
    constructor Create(AStream: TdxFontFileStream); overload; virtual;

    procedure Write(AStream: TdxFontFileStream);

    property DataLength: Integer read GetDataLength;
    property ObjectCount: Integer read GetObjectCount;
  end;

  { TdxCompactFontFormatBinaryIndex }

  TdxCompactFontFormatBinaryIndex = class(TdxCompactFontFormatIndex)
  strict private
    FData: TdxPDFBytesList;
  protected
    function GetObjectCount: Integer; override;
    function GetObjectDataLength(AIndex: Integer): Integer; override;
    procedure ProcessObject(AIndex: Integer; const AData: TBytes); override;
    procedure ProcessObjectCount(ACount: Integer); override;
    procedure WriteObject(AStream: TdxFontFileStream; AIndex: Integer); override;
  public
    constructor CreateEx(AData: TdxPDFBytesList);
    destructor Destroy; override;

    property Data: TdxPDFBytesList read FData;
  end;

  { TdxCompactFontFormatNameIndex }

  TdxCompactFontFormatNameIndex = class(TdxCompactFontFormatIndex)
  strict private
    FStrings: TStringDynArray;
  protected
    function GetObjectCount: Integer; override;
    function GetObjectDataLength(AIndex: Integer): Integer; override;
    procedure ProcessObject(AIndex: Integer; const AData: TBytes); override;
    procedure ProcessObjectCount(ACount: Integer); override;
    procedure WriteObject(AStream: TdxFontFileStream; AIndex: Integer); override;
  public
    procedure AddString(const AValue: string);
    property Strings: TStringDynArray read FStrings;
  end;

  { TdxCompactFontFormatStringIndex }

  TdxCompactFontFormatStringIndex = class(TdxCompactFontFormatNameIndex)
  strict private const
    StandardStringsCount = 391;
  strict private
    FSIDMapping: TdxPDFStringSmallIntegerDictionary;
    FStandardSIDMapping: TdxPDFStringSmallIntegerDictionary;
    FStandardStrings: TStringList;
    function GetItem(Index: Integer): string;
    procedure InitializeSIDMapping;
    procedure InitializeStandardStrings;
    procedure InitializeStandardSIDMapping;
  public
    constructor Create(AStream: TdxFontFileStream); override;
    destructor Destroy; override;

    function GetSID(const AValue: string): SmallInt;
    function GetString(AOperands: TDoubleDynArray): string;
    function TryGetSID(const AValue: string): SmallInt;

    property Items[Index: Integer]: string read GetItem;
  end;

  { TdxCompactFontFormatTopDictIndex }

  TdxCompactFontFormatTopDictIndex = class(TdxCompactFontFormatIndex)
  strict private
    FObjectData: TBytes;
  protected
    function GetObjectCount: Integer; override;
    function GetObjectDataLength(AIndex: Integer): Integer; override;
    procedure ProcessObject(AIndex: Integer; const AData: TBytes); override;
    procedure ProcessObjectCount(ACount: Integer); override;
    procedure WriteObject(AStream: TdxFontFileStream; AIndex: Integer); override;
  public
    constructor CreateEx(const AData: TBytes);
    property ObjectData: TBytes read FObjectData;
  end;

  { TdxType1FontCustomCharset }

  TdxType1FontCustomCharset = class
  protected
    function GetDataLength: Integer; virtual; abstract;
    function GetOffset: Integer; virtual;
    function GetSIDToGIDMapping: TdxPDFSmallIntegerDictionary; virtual; abstract;
    procedure SetSIDToGIDMapping(AValue: TdxPDFSmallIntegerDictionary); virtual;
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;
  public
    constructor Create; overload;
    constructor Create(AStream: TdxFontFileStream; ASize: Integer); overload; virtual;
    destructor Destroy; override;

    class function Parse(AStream: TdxFontFileStream; ASize: Integer): TdxType1FontCustomCharset;
    function IsDefault: Boolean; virtual;
    procedure Write(AStream: TdxFontFileStream); virtual; abstract;

    class function GetID: Integer; virtual;

    property DataLength: Integer read GetDataLength;
    property Offset: Integer read GetOffset;
    property SIDToGIDMapping: TdxPDFSmallIntegerDictionary read GetSIDToGIDMapping ;//write SetSIDToGIDMapping;
  end;

  { TdxType1FontArrayCharset }

  TdxType1FontArrayCharset = class(TdxType1FontCustomCharset)
  strict private
    FCIDToGIDMapping: TdxPDFSmallIntegerDictionary;
    FCharset: TSmallIntDynArray;
  protected
    function GetDataLength: Integer; override;
    function GetSIDToGIDMapping: TdxPDFSmallIntegerDictionary; override;
    procedure SetSIDToGIDMapping(AValue: TdxPDFSmallIntegerDictionary); override;
    procedure DestroySubClasses; override;
  public
    constructor Create(AStream: TdxFontFileStream; ASize: Integer); override;

    class function GetID: Integer; override;
    procedure Write(AStream: TdxFontFileStream); override;
  end;

  { TdxType1FontCustomRange }

  TdxType1FontCustomRangeClass = class of TdxType1FontCustomRange;
  TdxType1FontCustomRange = class
  public
    SID: SmallInt;
    constructor Create(ASID: SmallInt);
  end;

  { TdxType1FontByteRange }

  TdxType1FontByteRange = class(TdxType1FontCustomRange)
  public
    Remain: Byte;
    constructor Create(ASID: SmallInt; ARemain: Byte);
  end;

  { TdxType1FontWordRange }

  TdxType1FontWordRange = class(TdxType1FontCustomRange)
  public
    Remain: SmallInt;
    constructor Create(ASID, ARemain: SmallInt);
  end;

  { TdxType1FontCustomRangeCharset }

  TdxType1FontCustomRangeCharset = class(TdxType1FontCustomCharset)
  protected
    FCIDToGIDMapping: TdxPDFSmallIntegerDictionary;
    FRanges: TdxFastObjectList;

    function GetDataLength: Integer; override;
    function GetSIDToGIDMapping: TdxPDFSmallIntegerDictionary; override;
    procedure SetSIDToGIDMapping(AValue: TdxPDFSmallIntegerDictionary); override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;

    function GetDataLengthFactor: Integer; virtual; abstract;
    procedure PopulateRanges(AStream: TdxFontFileStream; ASize: Integer); virtual; abstract;
    procedure ProcessRemain(ARange: TdxType1FontCustomRange; var ASID: SmallInt; var AIndex: Integer); virtual; abstract;
    procedure WriteRemain(AStream: TdxFontFileStream; ARange: TdxType1FontCustomRange); virtual; abstract;

    procedure AddToCIDToGIDMapping(AKey, AValue: SmallInt);
  public
    constructor Create(AStream: TdxFontFileStream; ASize: Integer); override;

    procedure Write(AStream: TdxFontFileStream); override;
  end;

  { TdxType1FontByteRangeCharset }

  TdxType1FontByteRangeCharset = class(TdxType1FontCustomRangeCharset)
  protected
    function GetDataLengthFactor: Integer; override;
    procedure PopulateRanges(AStream: TdxFontFileStream; ASize: Integer); override;
    procedure ProcessRemain(ARange: TdxType1FontCustomRange; var ASID: SmallInt; var AIndex: Integer); override;
    procedure WriteRemain(AStream: TdxFontFileStream; ARange: TdxType1FontCustomRange); override;
  public
    class function GetID: Integer; override;
  end;

  { TdxType1FontWordRangeCharset }

  TdxType1FontWordRangeCharset = class(TdxType1FontCustomRangeCharset)
  protected
    function GetDataLengthFactor: Integer; override;
    procedure PopulateRanges(AStream: TdxFontFileStream; ASize: Integer); override;
    procedure ProcessRemain(ARange: TdxType1FontCustomRange; var ASID: SmallInt; var AIndex: Integer); override;
    procedure WriteRemain(AStream: TdxFontFileStream; ARange: TdxType1FontCustomRange); override;
  public
    class function GetID: Integer; override;
  end;

  { TdxType1FontPredefinedCharset }

  TdxType1FontPredefinedCharset = class(TdxType1FontCustomCharset)
  strict private
    FID: TdxType1FontPredefinedCharsetID;
  protected
    function GetDataLength: Integer; override;
    function GetOffset: Integer; override;
    function GetSIDToGIDMapping: TdxPDFSmallIntegerDictionary; override;
  public
    constructor Create(AID: TdxType1FontPredefinedCharsetID);
    //
    function IsDefault: Boolean; override;
    procedure Write(AStream: TdxFontFileStream); override;
  end;

  { TdxType1FontCIDGlyphGroupSelector }

  TdxType1FontCIDGlyphGroupSelector = class
  protected
    function GetGlyphGroupIndexes: TBytes; virtual; abstract;
    function GetDataLength: Integer; virtual; abstract;
  public
    constructor Create;

    class function Parse(AStream: TdxFontFileStream; ACIDCount: Integer): TdxType1FontCIDGlyphGroupSelector; static;
    procedure Write(AStream: TdxFontFileStream); virtual; abstract;

    property DataLength: Integer read GetDataLength;
    property GlyphGroupIndexes: TBytes read GetGlyphGroupIndexes;
  end;

  { TdxType1FontCIDGlyphGroupRangeSelector }

  TdxType1FontCIDGlyphGroupRangeSelector = class(TdxType1FontCIDGlyphGroupSelector)
  strict private type
    TRange = record
      First: SmallInt;
      GlyphGroupIndex: Byte;
      class function Create(AFirst: SmallInt; AGlyphGroupIndex: Byte): TRange; static;
    end;
    TRanges = array of TRange;
  strict private
    FRanges: TRanges;
    FSentinel: USHORT;
  protected
    function GetGlyphGroupIndexes: TBytes; override;
    function GetDataLength: Integer; override;
  public
    constructor Create(AStream: TdxFontFileStream; ACIDCount: Integer);
    procedure Write(AStream: TdxFontFileStream); override;
  end;

  { TdxType1FontCIDGlyphGroupArraySelector }

  TdxType1FontCIDGlyphGroupArraySelector = class(TdxType1FontCIDGlyphGroupSelector)
  strict private
    FGlyphGroupIndexes: TBytes;
  protected
    function GetGlyphGroupIndexes: TBytes; override;
    function GetDataLength: Integer; override;
  public
    constructor Create(AStream: TdxFontFileStream; ACIDCount: Integer);
    procedure Write(AStream: TdxFontFileStream); override;
  end;

  { TdxType1CustomFontProgram }

  TdxType1CustomFontProgram = class(TdxPDFBase)
  strict private
    FFontBBox: TdxRectF;
    FFontInfo: TdxType1FontInfo;
    FFontMatrix: TdxCompactFontFormatTarnsformationMatrix;
    FFontName: string;
    FPaintType: TdxType1FontPaintType;
    FPrivateData: TdxType1FontPrivateData;
    FStrokeWidth: Double;
    FUniqueID: Integer;
    FWMode: TdxType1FontWMode;
    procedure SetFontInfo(const AValue: TdxType1FontInfo);
    procedure SetPrivateData(const AValue: TdxType1FontPrivateData);
  public const
    DefaultStrokeWidth = 0;
    DefaultUniqueID = 0;
  public
    constructor Create; override;
    destructor Destroy; override;

    function FontType: TdxType1FontType; virtual; abstract;
    function GetCompositeMapping(const ACidToGidMap: TSmallIntDynArray): TObject; virtual;
    function GetSimpleMapping(AFontEncoding: TdxPDFSimpleFontEncoding): TObject; virtual; abstract;

    property FontBBox: TdxRectF read FFontBBox write FFontBBox;
    property FontInfo: TdxType1FontInfo read FFontInfo write SetFontInfo;
    property FontMatrix: TdxCompactFontFormatTarnsformationMatrix read FFontMatrix write FFontMatrix;
    property FontName: string read FFontName write FFontName;
    property PaintType: TdxType1FontPaintType read FPaintType write FPaintType;
    property PrivateData: TdxType1FontPrivateData read FPrivateData write SetPrivateData;
    property StrokeWidth: Double read FStrokeWidth write FStrokeWidth;
    property UniqueID: Integer read FUniqueID write FUniqueID;
    property WMode: TdxType1FontWMode read FWMode write FWMode;
  end;

  { TdxType1FontCompactFontProgram }

  TdxType1FontCompactFontProgram = class(TdxType1CustomFontProgram)
  strict private
    FBaseFontBlend: TDoubleDynArray;
    FCharset: TdxType1FontCustomCharset;
    FCharStrings: TdxPDFBytesList;
    FCIDFontName: string;
    FEncoding: TdxType1FontEncoding;
    FFontType: TdxType1FontType;
    FGlobalSubrs: TdxPDFBytesList;
    FMajorVersion: Byte;
    FMinorVersion: Byte;
    FPostScript: string;
    FStringIndex: TdxCompactFontFormatStringIndex;
    FXUID: TIntegerDynArray;
    procedure SetCharset(const AValue: TdxType1FontCustomCharset);
    procedure SetCharStrings(const AValue: TdxPDFBytesList);
    procedure SetEncoding(const AValue: TdxType1FontEncoding);
  protected
    procedure SetFontType(const AValue: TdxType1FontType);
  public
    constructor Create; overload; override;
    constructor Create(AMajorVersion, AMinorVersion: Byte; const AFontName: string;
      AStringIndex: TdxCompactFontFormatStringIndex; AGlobalSubrs: TdxPDFBytesList); reintroduce; overload;
    destructor Destroy; override;

    class function DefaultFontBBox: TdxRectF; static;
    class function DefaultFontMatrix: TdxCompactFontFormatTarnsformationMatrix; static;
    class function DefaultFontType: TdxType1FontType; static;
    class function Parse(const AData: TBytes): TdxType1FontCompactFontProgram; static;

    function FontType: TdxType1FontType; override;
    function GetSimpleMapping(AFontEncoding: TdxPDFSimpleFontEncoding): TObject; override;

    function Validate: Boolean; virtual;

    property BaseFontBlend: TDoubleDynArray read FBaseFontBlend write FBaseFontBlend;
    property Charset: TdxType1FontCustomCharset read FCharset write SetCharset;
    property CharStrings: TdxPDFBytesList read FCharStrings write SetCharStrings;
    property CIDFontName: string read FCIDFontName write FCIDFontName;
    property Encoding: TdxType1FontEncoding read FEncoding write SetEncoding;
    property GlobalSubrs: TdxPDFBytesList read FGlobalSubrs;
    property MajorVersion: Byte read FMajorVersion;
    property MinorVersion: Byte read FMinorVersion;
    property PostScript: string read FPostScript write FPostScript;
    property StringIndex: TdxCompactFontFormatStringIndex read FStringIndex;
    property XUID: TIntegerDynArray read FXUID write FXUID;
  end;

  { TdxType1FontCompactCIDFontProgram }

  TdxType1FontCompactCIDFontProgram = class(TdxType1FontCompactFontProgram)
  strict private
    FCIDCount: Integer;
    FCIDFontVersion: Double;
    FGlyphGroupData: TObjectList<TdxType1FontCIDGlyphGroupData>;
    FGlyphGroupSelector: TdxType1FontCIDGlyphGroupSelector;
    FOrdering: string;
    FRegistry: string;
    FSupplement: Double;
    FUIDBase: Integer;
    procedure SetGlyphGroupData(const AValue: TObjectList<TdxType1FontCIDGlyphGroupData>);
    procedure SetGlyphGroupSelector(const AValue: TdxType1FontCIDGlyphGroupSelector);
  public const
    DefaultCIDCount = 8720;
    DefaultCIDFontVersion = 0;
  public
    constructor Create; override;
    destructor Destroy; override;

    function GetCompositeMapping(const ACidToGidMap: TSmallIntDynArray): TObject; override;
    function Validate: Boolean; override;

    property CIDCount: Integer read FCIDCount write FCIDCount;
    property CIDFontVersion: Double read FCIDFontVersion write FCIDFontVersion;
    property GlyphGroupData: TObjectList<TdxType1FontCIDGlyphGroupData> read FGlyphGroupData write SetGlyphGroupData;
    property GlyphGroupSelector: TdxType1FontCIDGlyphGroupSelector read FGlyphGroupSelector write SetGlyphGroupSelector;
    property Ordering: string read FOrdering write FOrdering;
    property Registry: string read FRegistry write FRegistry;
    property Supplement: Double read FSupplement write FSupplement;
    property UIDBase: Integer read FUIDBase write FUIDBase;
  end;

  { TdxPDFType1FontClassicFontProgram }

  TdxPDFType1FontClassicFontProgram = class(TdxType1CustomFontProgram)
  strict private const
  {$REGION 'internal const'}
    DefaultUniqueID = 0;
    DefaultStrokeWidth = 0;
    CharStringsDictionaryKey = 'CharStrings';
    EncodingDictionaryKey = 'Encoding';
    FontInfoDictionaryKey = 'FontInfo';
    FontNameDictionaryKey = 'FontName';
    FontTypeDictionaryKey = 'FontType';
    FontMatrixDictionaryKey = 'FontMatrix';
    FontBBoxDictionaryKey = 'FontBBox';
    MetricsDictionaryKey = 'Metrics';
    PaintTypeDictionaryKey = 'PaintType';
    PrivateDictionaryKey = 'Private';
    SerializationPattern = '/%s %d def'#10;
    StrokeWidthDictionaryKey = 'StrokeWidth';
    UniqueIDDictionaryKey = 'UniqueID';
    WModeDictionaryKey = 'WMode';
  {$ENDREGION}
  strict private
    FCharStrings: TdxPDFPostScriptDictionary;
    FEncoding: TStringList;
    FFontType: TdxType1FontType;
    FMetrics: TdxPDFPostScriptDictionary;
    procedure ReadEncoding(AEntry: TdxPDFPostScriptDictionaryEntry);
    procedure ReadFontInfo(AEntry: TdxPDFPostScriptDictionaryEntry);
    procedure ReadFontType(AEntry: TdxPDFPostScriptDictionaryEntry);
    procedure ReadPaintType(AEntry: TdxPDFPostScriptDictionaryEntry);
    procedure SetCharStrings(const AValue: TdxPDFPostScriptDictionary);
    procedure SetEncoding(const AValue: TStringList);
    procedure SetMetrics(const AValue: TdxPDFPostScriptDictionary);
  public
    destructor Destroy; override;

    class function Parse(const AFontName: string; AFontFileData: TdxPDFType1FontFileData): TdxPDFType1FontClassicFontProgram; static;
    procedure Read(ADictionary: TdxPDFPostScriptDictionary);

    function FontType: TdxType1FontType; override;
    function GetSimpleMapping(AFontEncoding: TdxPDFSimpleFontEncoding): TObject; override;
    function ToPostScript: string;
    procedure Validate(AFont: TdxPDFCustomFont);

    property CharStrings: TdxPDFPostScriptDictionary read FCharStrings write SetCharStrings;
    property Encoding: TStringList read FEncoding write SetEncoding;
    property Metrics: TdxPDFPostScriptDictionary read FMetrics write SetMetrics;
  end;

  { TdxCompactFontFormatDictIndexOperator }

  TdxCompactFontFormatDictIndexOperatorClass = class of TdxCompactFontFormatDictIndexOperator;
  TdxCompactFontFormatDictIndexOperator = class(TcxIUnknownObject)
  protected
    function CalculateDoubleArraySize(const AArray: TDoubleDynArray): Integer;
    function CalculateDoubleSize(AValue: Double): Integer;
    function CalculateGlyphZonesSize(const AValue: TdxType1FontGlyphZones): Integer;
    function CalculateIntegerSize(AValue: Integer): Integer;
    function GetBoolean(AOperands: TDoubleDynArray): Boolean;
    function GetDouble(AOperands: TDoubleDynArray): Double;
    function GetDoubleArray(AOperands: TDoubleDynArray): TDoubleDynArray;
    function GetGlyphZones(AOperands: TDoubleDynArray): TdxType1FontGlyphZones;
    function GetInteger(AOperands: TDoubleDynArray): Integer;
    function ToCIDFontProgram(AFontProgram: TdxType1FontCompactFontProgram): TdxType1FontCompactCIDFontProgram;
    procedure WriteBoolean(AStream: TdxFontFileStream; AValue: Boolean);
    procedure WriteDouble(AStream: TdxFontFileStream; AValue: Double);
    procedure WriteDoubleArray(AStream: TdxFontFileStream; const AValue: TDoubleDynArray);
    procedure WriteGlyphZones(AStream: TdxFontFileStream; const AValue: TdxType1FontGlyphZones);
    procedure WriteInteger(AStream: TdxFontFileStream; AValue: Integer);
  public
    constructor Create; overload;
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; virtual;
    class function Code: Byte; virtual;

    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; virtual;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); overload; virtual;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); overload; virtual;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); overload; virtual;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); virtual;
  end;
  TdxCompactFontFormatDictIndexOperatorList = class(TObjectList<TdxCompactFontFormatDictIndexOperator>);

  { TdxCompactFontFormatDictIndexStringOperator }

  TdxCompactFontFormatDictIndexStringOperator = class(TdxCompactFontFormatDictIndexOperator)
  strict private
    FValue: string;
  protected
    property Value: string read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(const AValue: string); overload;

    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexIntegerOperator }

  TdxCompactFontFormatDictIndexIntegerOperator = class(TdxCompactFontFormatDictIndexOperator)
  strict private
    FValue: Integer;
  protected
    property Value: Integer read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(AValue: Integer); overload;

    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexDoubleOperator }

  TdxCompactFontFormatDictIndexDoubleOperator = class(TdxCompactFontFormatDictIndexOperator)
  strict private
    FValue: Double;
  protected
    property Value: Double read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(AValue: Double); overload;

    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexXUIDOperator }

  TdxCompactFontFormatDictIndexXUIDOperator = class(TdxCompactFontFormatDictIndexOperator)
  strict private
    FXUID: TIntegerDynArray;
  protected
    property XUID: TIntegerDynArray read FXUID;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(const AXUID: TIntegerDynArray); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexNoticeOperator }

  TdxCompactFontFormatDictIndexNoticeOperator = class(TdxCompactFontFormatDictIndexStringOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexWeightOperator }

  TdxCompactFontFormatDictIndexWeightOperator = class(TdxCompactFontFormatDictIndexStringOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexFamilyNameOperator }

  TdxCompactFontFormatDictIndexFamilyNameOperator = class(TdxCompactFontFormatDictIndexStringOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexFontBBoxOperator }

  TdxCompactFontFormatDictIndexFontBBoxOperator = class(TdxCompactFontFormatDictIndexOperator)
  strict private
    FFontBBox: TdxRectF;
  protected
    property FontBBox: TdxRectF read FFontBBox;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(const AFontBBox: TdxRectF); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexUniqueIDOperator }

  TdxCompactFontFormatDictIndexUniqueIDOperator = class(TdxCompactFontFormatDictIndexIntegerOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
  end;

  { TdxCompactFontFormatDictIndexTwoByteOperator }

  TdxCompactFontFormatDictIndexTwoByteOperator = class(TdxCompactFontFormatDictIndexOperator)
  public const
    Marker = 12;
  public
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexStringTwoByteOperator }

  TdxCompactFontFormatDictIndexStringTwoByteOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator)
  strict private
    FValue: string;
  protected
    property Value: string read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(const AValue: string); overload;

    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexBaseFontNameOperator }

  TdxCompactFontFormatDictIndexBaseFontNameOperator = class(TdxCompactFontFormatDictIndexStringTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexIntegerTwoByteOperator }

  TdxCompactFontFormatDictIndexIntegerTwoByteOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator)
  strict private
    FValue: Integer;
  protected
    property Value: Integer read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(AValue: Integer); overload;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexDoubleTwoByteOperator }

  TdxCompactFontFormatDictIndexDoubleTwoByteOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator)
  strict private
    FValue: Double;
  protected
    property Value: Double read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(AValue: Double); overload;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexPaintTypeOperator }

  TdxCompactFontFormatDictIndexPaintTypeOperator = class(TdxCompactFontFormatDictIndexIntegerTwoByteOperator)
  strict private
    FPaintType: TdxType1FontPaintType;
  public
    constructor Create(APaintType: TdxType1FontPaintType);
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
  end;

  { TdxCompactFontFormatDictIndexGlyphZonesOperator }

  TdxCompactFontFormatDictIndexGlyphZonesOperator = class(TdxCompactFontFormatDictIndexOperator)
  strict private
    FValue: TdxType1FontGlyphZones;
  protected
    property Value: TdxType1FontGlyphZones read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(const AValue: TdxType1FontGlyphZones); overload;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexDoubleDynArrayOperator }

  TdxCompactFontFormatDictIndexDoubleDynArrayOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator)
  strict private
    FValue: TDoubleDynArray;
  protected
    property Value: TDoubleDynArray read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(const AValue: TDoubleDynArray); overload;

    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexBaseFontBlendOperator }

  TdxCompactFontFormatDictIndexBaseFontBlendOperator = class(TdxCompactFontFormatDictIndexDoubleDynArrayOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexCharstringTypeOperator }

  TdxCompactFontFormatDictIndexCharstringTypeOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator)
  strict private
    FFontType: TdxType1FontType;
  protected
    property FontType: TdxType1FontType read FFontType;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(AFontType: TdxType1FontType); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexCIDCountOperator }

  TdxCompactFontFormatDictIndexCIDCountOperator = class(TdxCompactFontFormatDictIndexIntegerTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
  end;

  { TdxCompactFontFormatDictIndexCIDFontVersionOperator }

  TdxCompactFontFormatDictIndexCIDFontVersionOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexCopyrightOperator }

  TdxCompactFontFormatDictIndexCopyrightOperator = class(TdxCompactFontFormatDictIndexStringTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexCharsetOperator }

  TdxCompactFontFormatDictIndexCharsetOperator = class(TdxCompactFontFormatDictIndexOperator,
    IdxCompactFontFormatDictIndexOffsetOperator)
  strict private
    FCharset: TdxType1FontCustomCharset;
    FOffset: Integer;
    // IdxCompactFontFormatDictIndexOffsetOperator
    function GetLength: Integer;
    function GetOffset: Integer;
    procedure SetOffset(const AValue: Integer);
    procedure WriteData(AStream: TdxFontFileStream);
  protected
    property Charset: TdxType1FontCustomCharset read FCharset;
    property Offset: Integer read FOffset;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(ACharset: TdxType1FontCustomCharset); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexCharStringsOperator }

  TdxCompactFontFormatDictIndexCharStringsOperator = class(TdxCompactFontFormatDictIndexOperator,
    IdxCompactFontFormatDictIndexOffsetOperator)
  strict private
    FCharStrings: TdxCompactFontFormatBinaryIndex;
    FOffset: Integer;
    // IdxCompactFontFormatDictIndexOffsetOperator
    function GetLength: Integer;
    function GetOffset: Integer;
    procedure SetOffset(const AValue: Integer);
    procedure WriteData(AStream: TdxFontFileStream);
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(ACharStrings: TdxPDFBytesList); overload;
    destructor Destroy; override;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexEncodingOperator }

  TdxCompactFontFormatDictIndexEncodingOperator = class(TdxCompactFontFormatDictIndexOperator,
    IdxCompactFontFormatDictIndexOffsetOperator)
  strict private
    FEncoding: TdxType1FontEncoding;
    FOffset: Integer;
    // IdxCompactFontFormatDictIndexOffsetOperator
    function GetLength: Integer;
    function GetOffset: Integer;
    procedure SetOffset(const AValue: Integer);
    procedure WriteData(AStream: TdxFontFileStream);
  protected
    property Offset: Integer read FOffset;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(AEncoding: TdxType1FontEncoding); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexPrivateOperator }

  TdxCompactFontFormatDictIndexPrivateOperator = class(TdxCompactFontFormatDictIndexOperator,
    IdxCompactFontFormatDictIndexOffsetOperator)
  strict private
    FLength: Integer;
    FOffset: Integer;
    FPrivateData: TdxType1FontPrivateData;
    FSubrsLength: Integer;
    function ReadData(AStream: TdxFontFileStream): TdxType1FontPrivateData;
    // IdxCompactFontFormatDictIndexOffsetOperator
    function GetLength: Integer;
    function GetOffset: Integer;
    procedure SetOffset(const AValue: Integer);
    procedure WriteData(AStream: TdxFontFileStream);
  protected
    property Length: Integer read FLength;
    property SubrsLength: Integer read FSubrsLength;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(APrivateData: TdxType1FontPrivateData); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatCIDGlyphGroupDataWriter }

  TdxCompactFontFormatCIDGlyphGroupDataWriter = class(TObject)
  strict private
    FOperators: TdxCompactFontFormatDictIndexOperatorList;
    FPrivateOperator: TdxCompactFontFormatDictIndexPrivateOperator;
    FStringIndex: TdxCompactFontFormatStringIndex;
  public
    constructor Create(const AData: TdxType1FontCIDGlyphGroupData; AStringIndex: TdxCompactFontFormatStringIndex);
    destructor Destroy; override;

    function DataSize: Integer;
    procedure Write(AStream: TdxFontFileStream);

    property PrivateOperator: TdxCompactFontFormatDictIndexPrivateOperator read FPrivateOperator;
  end;

  { TdxCompactFontFormatDictIndexFDArrayOperator }

  TdxCompactFontFormatDictIndexFDArrayOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator,
    IdxCompactFontFormatDictIndexOffsetOperator)
  strict private
    FGlyphGroupData: TObjectList<TdxType1FontCIDGlyphGroupData>;
    FOffset: Integer;
    FOffsetOperators: TdxCompactFontFormatDictIndexOffsetOperatorList;
    FStringIndex: TdxCompactFontFormatStringIndex;
    FWriters: TObjectList<TdxCompactFontFormatCIDGlyphGroupDataWriter>;
    function GetOffsetOperators: TdxCompactFontFormatDictIndexOffsetOperatorList;
    procedure CreateWritersIfNeeded;
    // IdxCompactFontFormatDictIndexOffsetOperator
    function GetLength: Integer;
    function GetOffset: Integer;
    procedure SetOffset(const AValue: Integer);
    procedure WriteData(AStream: TdxFontFileStream);
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(ADataArray: TObjectList<TdxType1FontCIDGlyphGroupData>;
      AStringIndex: TdxCompactFontFormatStringIndex); overload;
    destructor Destroy; override;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;

    property OffsetOperators: TdxCompactFontFormatDictIndexOffsetOperatorList read GetOffsetOperators;
  end;

  { TdxCompactFontFormatDictIndexUnderlinePositionOperator }

  TdxCompactFontFormatDictIndexUnderlinePositionOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
  end;

  { TdxCompactFontFormatDictIndexUnderlineThicknessOperator }

  TdxCompactFontFormatDictIndexUnderlineThicknessOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
  end;

  { TdxCompactFontFormatDictIndexFontMatrixOperator }

  TdxCompactFontFormatDictIndexFontMatrixOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator)
  strict private
    FFontMatrix: TdxCompactFontFormatTarnsformationMatrix;
  protected
    property FontMatrix: TdxCompactFontFormatTarnsformationMatrix read FFontMatrix;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(const AFontMatrix: TdxCompactFontFormatTarnsformationMatrix); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexSubrsOperator }

  TdxCompactFontFormatPrivateDictIndexSubrsOperator = class(TdxCompactFontFormatDictIndexOperator)
  strict private
    FOffset: Integer;
    FSubrs: TdxCompactFontFormatBinaryIndex;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(ASubrs: TdxPDFBytesList); overload;
    destructor Destroy; override;

    class function Code: Byte; override;
    function DataLength: Integer;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    function UpdateOffset(AOffset: Integer): Boolean;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
    procedure WriteData(AStream: TdxFontFileStream);
  end;

  { TdxCompactFontFormatPrivateDictIndexBlueFuzzOperator }

  TdxCompactFontFormatPrivateDictIndexBlueFuzzOperator = class(TdxCompactFontFormatDictIndexIntegerTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexBlueScaleOperator }

  TdxCompactFontFormatPrivateDictIndexBlueScaleOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexBlueShiftOperator }

  TdxCompactFontFormatPrivateDictIndexBlueShiftOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexDefaultWidthXOperator }

  TdxCompactFontFormatPrivateDictIndexDefaultWidthXOperator = class(TdxCompactFontFormatDictIndexDoubleOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexExpansionFactorOperator }

  TdxCompactFontFormatPrivateDictIndexExpansionFactorOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexBlueValuesOperator }

  TdxCompactFontFormatPrivateDictIndexBlueValuesOperator = class(TdxCompactFontFormatDictIndexGlyphZonesOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexFamilyBluesOperator }

  TdxCompactFontFormatPrivateDictIndexFamilyBluesOperator = class(TdxCompactFontFormatDictIndexGlyphZonesOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexFamilyOtherBluesOperator }

  TdxCompactFontFormatPrivateDictIndexFamilyOtherBluesOperator = class(TdxCompactFontFormatDictIndexGlyphZonesOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator }

  TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator)
  strict private
    FValue: Boolean;
  protected
    property Value: Boolean read FValue;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(AValue: Boolean); overload;

    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexForceBoldOperator }

  TdxCompactFontFormatPrivateDictIndexForceBoldOperator = class(TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexForceBoldThresholdOperator }

  TdxCompactFontFormatPrivateDictIndexForceBoldThresholdOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexLanguageGroupOperator }

  TdxCompactFontFormatPrivateDictIndexLanguageGroupOperator = class(TdxCompactFontFormatDictIndexIntegerTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexNominalWidthXOperator }

  TdxCompactFontFormatPrivateDictIndexNominalWidthXOperator = class(TdxCompactFontFormatDictIndexDoubleOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexOtherBluesOperator }

  TdxCompactFontFormatPrivateDictIndexOtherBluesOperator = class(TdxCompactFontFormatDictIndexGlyphZonesOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexStdHWOperator }

  TdxCompactFontFormatPrivateDictIndexStdHWOperator = class(TdxCompactFontFormatDictIndexDoubleOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexStdVWOperator }

  TdxCompactFontFormatPrivateDictIndexStdVWOperator = class(TdxCompactFontFormatDictIndexDoubleOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexStemSnapHOperator }

  TdxCompactFontFormatPrivateDictIndexStemSnapHOperator = class(TdxCompactFontFormatDictIndexDoubleDynArrayOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatPrivateDictIndexStemSnapVOperator }

  TdxCompactFontFormatPrivateDictIndexStemSnapVOperator = class(TdxCompactFontFormatDictIndexDoubleDynArrayOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; APrivateData: TdxType1FontCompactFontPrivateData); override;
  end;

  { TdxCompactFontFormatDictIndexVersionOperator }

  TdxCompactFontFormatDictIndexVersionOperator = class(TdxCompactFontFormatDictIndexStringOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexUIDBaseOperator }

  TdxCompactFontFormatDictIndexUIDBaseOperator = class(TdxCompactFontFormatDictIndexIntegerTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexStrokeWidthOperator }

  TdxCompactFontFormatDictIndexStrokeWidthOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
  public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
  end;

  { TdxCompactFontFormatDictIndexROSOperator }

  TdxCompactFontFormatDictIndexROSOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator)
  strict private
    FOrdering: string;
    FRegistry: string;
    FSupplement: Double;
  protected
    property Ordering: string read FOrdering;
    property Registry: string read FRegistry;
    property Supplement: Double read FSupplement;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(const ARegistry, AOrdering: string; ASupplement: Double); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxCompactFontFormatDictIndexPostScriptOperator }

   TdxCompactFontFormatDictIndexPostScriptOperator = class(TdxCompactFontFormatDictIndexStringTwoByteOperator)
   public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
   end;

   { TdxCompactFontFormatDictIndexItalicAngleOperator }

   TdxCompactFontFormatDictIndexItalicAngleOperator = class(TdxCompactFontFormatDictIndexDoubleTwoByteOperator)
   public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
   end;

   { TdxCompactFontFormatDictIndexIsFixedPitchOperator }

   TdxCompactFontFormatDictIndexIsFixedPitchOperator = class(TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator)
   public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
   end;

  { TdxCompactFontFormatDictIndexFontNameOperator }

   TdxCompactFontFormatDictIndexFontNameOperator = class(TdxCompactFontFormatDictIndexStringTwoByteOperator)
   public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Execute(AStream: TdxFontFileStream; AGlyphGroupData: TdxType1FontCIDGlyphGroupData); override;
   end;

   { TdxCompactFontFormatDictIndexFullNameOperator }

   TdxCompactFontFormatDictIndexFullNameOperator = class(TdxCompactFontFormatDictIndexStringOperator)
   public
    class function Code: Byte; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
   end;

   { TdxCompactFontFormatDictIndexFDSelectOperator }

   TdxCompactFontFormatDictIndexFDSelectOperator = class(TdxCompactFontFormatDictIndexTwoByteOperator,
     IdxCompactFontFormatDictIndexOffsetOperator)
  strict private
    FOffset: Integer;
    FSelector: TdxType1FontCIDGlyphGroupSelector;
    // IdxCompactFontFormatDictIndexOffsetOperator
    function GetLength: Integer;
    function GetOffset: Integer;
    procedure SetOffset(const AValue: Integer);
    procedure WriteData(AStream: TdxFontFileStream);
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray); overload; override;
    constructor Create(ASelector: TdxType1FontCIDGlyphGroupSelector); overload;

    class function Code: Byte; override;
    function GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer; override;
    procedure Execute(AStream: TdxFontFileStream; AFontProgram: TdxType1FontCompactFontProgram); override;
    procedure Write(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex); override;
  end;

  { TdxPDFType1FontCipher }

  TdxPDFType1FontCipher = class
  strict private
    FCurrentPosition: Integer;
    FData: TBytes;
    FEndPosition: Integer;
    FR: Word;
  strict protected const
    C1 = 52845;
    C2 = 22719;
  protected
    function DecryptNextChar: SmallInt;
    function GetInitialR: Word; virtual; abstract;
    function GetSkipBytesCount: Integer; virtual;
    function NextByte: SmallInt;
    function NextChar: SmallInt; virtual; abstract;

    property InitialR: Word read GetInitialR;
    property R: Word read FR write FR;
    property SkipBytesCount: Integer read GetSkipBytesCount;
  public
    constructor Create(const AData: TBytes); overload;
    constructor Create(const AData: TBytes; AStartPosition: Integer; ADataLength: Integer); overload;

    function Decrypt: TBytes;
  end;

  { TdxPDFType1FontEexecCipher }

  TdxPDFType1FontEexecCipher = class(TdxPDFType1FontCipher)
  strict private const
    KindBytesCount = 4;
  protected
    function GetInitialR: Word; override;
    function GetSkipBytesCount: Integer; override;
  public
    class function CreateCipher(const AData: TBytes; AStartPosition, ADataLength: Integer): TdxPDFType1FontEexecCipher; static;
    class function IsASCIICipher(const AData: TBytes; AStartPosition: Integer): Boolean; static;
    class function IsASCIISymbol(C: Byte): Boolean; static;
  end;

  { TdxPDFType1FontEexecASCIICipher }

  TdxPDFType1FontEexecASCIICipher = class(TdxPDFType1FontEexecCipher)
  protected
    function NextChar: SmallInt; override;
    function ActualNextByte: SmallInt;
  end;

  { TdxPDFType1FontEexecBinaryCipher }

  TdxPDFType1FontEexecBinaryCipher = class(TdxPDFType1FontEexecCipher)
  strict private
    function DoEncrypt(P: Byte): Byte;
  protected
    function NextChar: SmallInt; override;
  public
    function Encrypt: TBytes;
  end;

  { TdxCompactFontFormatTopDictIndexWriter }

  TdxCompactFontFormatTopDictIndexWriter = class
  strict private
    FGlobalSubrs: TdxCompactFontFormatBinaryIndex;
    FMajorVersion: Byte;
    FMinorVersion: Byte;
    FName: string;
    FOffsetOperators: TdxCompactFontFormatDictIndexOffsetOperatorList;
    FOperators: TdxCompactFontFormatDictIndexOperatorList;
    FStringIndex: TdxCompactFontFormatStringIndex;
    procedure DoWrite(AStream: TdxFontFileStream);
  public
    constructor Create(AFontProgram: TdxType1FontCompactFontProgram);
    destructor Destroy; override;

    class function Write(AFontProgram: TdxType1FontCompactFontProgram): TBytes; static;
    property Name: string read FName;
    property OffsetOperators: TdxCompactFontFormatDictIndexOffsetOperatorList read FOffsetOperators;
    property Operators: TdxCompactFontFormatDictIndexOperatorList read FOperators;
  end;

  { TdxPDFCompactFontFormatTopDictIndexWriter }

  TdxPDFCompactFontFormatTopDictIndexWriter = class
  strict private
    FGlobalSubrs: TdxCompactFontFormatBinaryIndex;
    FMajorVersion: Byte;
    FMinorVersion: Byte;
    FName: string;
    FOffsetOperators: TInterfaceList;
    FOperators: TdxFastObjectList;
    FStringIndex: TdxCompactFontFormatStringIndex;
    procedure CalculateOffsets;
    procedure DoWrite(AStream: TdxFontFileStream);
    procedure Read(AFontProgram: TdxType1FontCompactFontProgram);
    procedure ReadCIDFontProgramOperators(AFontProgram: TdxType1FontCompactCIDFontProgram);
    procedure ReadCharsetOperator(ACharset: TdxType1FontCustomCharset);
    procedure ReadCharStringsOperator(ACharStrings: TdxPDFBytesList);
    procedure ReadEncodingOperator(AEncoding: TdxType1FontEncoding);
    procedure ReadFontInfoOperators(AFontInfo: TdxType1FontInfo);
    procedure ReadPrivateOperator(AData: TdxType1FontPrivateData);
  public
    constructor Create(AFontProgram: TdxType1FontCompactFontProgram);
    destructor Destroy; override;

    class function Write(AFontProgram: TdxType1FontCompactFontProgram): TBytes; static;
  end;

implementation

uses
  RTLConsts, Math, dxCore, cxVariants, dxStringHelper, dxPDFFontUtils, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFType1Font';

type
  TdxPDFPostScriptDictionaryAccess = class(TdxPDFPostScriptDictionary);

  { TdxCompactFontFormatDictIndexOperatorFactory }

  TdxCompactFontFormatDictIndexOperatorFactory = class
  strict private
    FDictionary: TDictionary<Integer, TdxCompactFontFormatDictIndexOperatorClass>;
  protected
    procedure RegisterOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass);
    procedure UnregisterOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass);
  public
    constructor Create;
    destructor Destroy; override;

    function GetOperatorClass(ACode: Byte): TdxCompactFontFormatDictIndexOperatorClass;
  end;

  { TdxCompactFontFormatNibbleValueConstructor }

  TdxCompactFontFormatNibbleValueConstructor = class
  strict private
   FStringBuilder: TStringBuilder;
   function GetResult: Double;
  protected
    function AddNibble(ANibble: Integer): Boolean;

    property Result: Double read GetResult;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { TdxCompactFontFormatDictIndexParser }

  TdxCompactFontFormatDictIndexParser = class
  strict private
    FCurrentPosition: Integer;
    FData: TBytes;
  protected
    function CreateOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass;
      AOperands: TDoubleDynArray): TdxCompactFontFormatDictIndexOperator; virtual; abstract;

    function GetNextByte: Byte;
    function HasMoreData: Boolean;
    function ParseOperator(AValue: Byte; AOperands: TDoubleDynArray): TdxCompactFontFormatDictIndexOperator;
  public
    constructor Create(const AData: TBytes);

    function ParseOperators: TdxCompactFontFormatDictIndexOperatorList;
  end;

  { TdxCompactFontFormatTopDictIndexParser }

  TdxCompactFontFormatTopDictIndexParser = class(TdxCompactFontFormatDictIndexParser)
  strict private
    FStringIndex: TdxCompactFontFormatStringIndex;
  protected
    function CreateOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass;
      AOperands: TDoubleDynArray): TdxCompactFontFormatDictIndexOperator; override;
  public
    constructor Create(AStringIndex: TdxCompactFontFormatStringIndex; const AData: TBytes);

    class function Parse(AMajorVersion, AMinorVersion: Byte; const AFontName: string;
      AStringIndex: TdxCompactFontFormatStringIndex; AGlobalSubrs: TdxPDFBytesList; AStream: TdxFontFileStream;
      const AObjectData: TBytes): TdxType1FontCompactFontProgram; overload;
    class function Parse(AStream: TdxFontFileStream; AStringIndex: TdxCompactFontFormatStringIndex;
      const AObjectData: TBytes): TdxType1FontCIDGlyphGroupData; overload;
  end;

  { TdxCompactFontFormatPrivateDictIndexParser }

   TdxCompactFontFormatPrivateDictIndexParser = class(TdxCompactFontFormatDictIndexParser)
   protected
     function CreateOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass;
       AOperands: TDoubleDynArray): TdxCompactFontFormatDictIndexOperator; override;
   public
     class function Parse(AStream: TdxFontFileStream; const AData: TBytes): TdxType1FontCompactFontPrivateData; static;
   end;

  { TdxCompactFontFormatPrivateDictIndexWriter }

  TdxCompactFontFormatPrivateDictIndexWriter = class // for internal use
  strict private
    FDataLength: Integer;
    FOperators: TdxCompactFontFormatDictIndexOperatorList;
    FSubrsOperator: TdxCompactFontFormatPrivateDictIndexSubrsOperator;
    procedure CalculateDataLength;
  public
    constructor Create(APrivateData: TdxType1FontPrivateData);
    destructor Destroy; override;

    function DataLength: Integer;
    function SubrsLength: Integer;
    procedure Write(AStream: TdxFontFileStream);
  end;

  { TdxPDFStandardFontDescriptor }

  TdxPDFStandardFontDescriptor = class
  strict private type
    TPopulateStandardFontDescriptorProc = procedure(ADictionary: TdxPDFDictionary) of object;
  strict private
    FPopulationProcDictionary: TDictionary<string, TPopulateStandardFontDescriptorProc>;
    FStandardFontNameMap: TdxPDFStringStringDictionary;
    //
    procedure PopulateCourierFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateCourierBoldFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateCourierBoldObliqueFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateCourierObliqueFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateHelveticaFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateHelveticaBoldFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateHelveticaBoldObliqueFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateHelveticaObliqueFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateSymbolFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateTimesBoldFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateTimesBoldItalicFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateTimesItalicFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateTimesNewRomanFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
    procedure PopulateZapfDingbatsFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
  public
    constructor Create;
    destructor Destroy; override;
    function CreateDictionary(ARepository: TdxPDFCustomRepository; const AFontName: string): TdxPDFDictionary;
  end;

var
  dxgPDFCompactFontFormatDictIndexOneByteOperatorFactory: TdxCompactFontFormatDictIndexOperatorFactory;
  dxgPDFCompactFontFormatDictIndexTwoByteOperatorFactory: TdxCompactFontFormatDictIndexOperatorFactory;
  dxgPDFStandardFontDescriptor: TdxPDFStandardFontDescriptor;

  dxgType1FontExpertCharset: TdxPDFSmallIntegerDictionary;
  dxgType1FontExpertSubsetCharset: TdxPDFSmallIntegerDictionary;
  dxgType1FontISOAdobeCharset: TdxPDFSmallIntegerDictionary;

procedure CreateType1FontExpertCharset;
begin
  dxgType1FontExpertCharset := TdxPDFSmallIntegerDictionary.Create;
  dxgType1FontExpertCharset.Add(1, 1);
  dxgType1FontExpertCharset.Add(229, 2);
  dxgType1FontExpertCharset.Add(230, 3);
  dxgType1FontExpertCharset.Add(231, 4);
  dxgType1FontExpertCharset.Add(232, 5);
  dxgType1FontExpertCharset.Add(233, 6);
  dxgType1FontExpertCharset.Add(234, 7);
  dxgType1FontExpertCharset.Add(235, 8);
  dxgType1FontExpertCharset.Add(236, 9);
  dxgType1FontExpertCharset.Add(237, 10);
  dxgType1FontExpertCharset.Add(238, 11);
  dxgType1FontExpertCharset.Add(13, 12);
  dxgType1FontExpertCharset.Add(14, 13);
  dxgType1FontExpertCharset.Add(15, 14);
  dxgType1FontExpertCharset.Add(99, 15);
  dxgType1FontExpertCharset.Add(239, 16);
  dxgType1FontExpertCharset.Add(240, 17);
  dxgType1FontExpertCharset.Add(241, 18);
  dxgType1FontExpertCharset.Add(242, 19);
  dxgType1FontExpertCharset.Add(243, 20);
  dxgType1FontExpertCharset.Add(244, 21);
  dxgType1FontExpertCharset.Add(245, 22);
  dxgType1FontExpertCharset.Add(246, 23);
  dxgType1FontExpertCharset.Add(247, 24);
  dxgType1FontExpertCharset.Add(248, 25);
  dxgType1FontExpertCharset.Add(27, 26);
  dxgType1FontExpertCharset.Add(28, 27);
  dxgType1FontExpertCharset.Add(249, 28);
  dxgType1FontExpertCharset.Add(250, 29);
  dxgType1FontExpertCharset.Add(251, 30);
  dxgType1FontExpertCharset.Add(252, 31);
  dxgType1FontExpertCharset.Add(253, 32);
  dxgType1FontExpertCharset.Add(254, 33);
  dxgType1FontExpertCharset.Add(255, 34);
  dxgType1FontExpertCharset.Add(256, 35);
  dxgType1FontExpertCharset.Add(257, 36);
  dxgType1FontExpertCharset.Add(258, 37);
  dxgType1FontExpertCharset.Add(259, 38);
  dxgType1FontExpertCharset.Add(260, 39);
  dxgType1FontExpertCharset.Add(261, 40);
  dxgType1FontExpertCharset.Add(262, 41);
  dxgType1FontExpertCharset.Add(263, 42);
  dxgType1FontExpertCharset.Add(264, 43);
  dxgType1FontExpertCharset.Add(265, 44);
  dxgType1FontExpertCharset.Add(266, 45);
  dxgType1FontExpertCharset.Add(109, 46);
  dxgType1FontExpertCharset.Add(110, 47);
  dxgType1FontExpertCharset.Add(267, 48);
  dxgType1FontExpertCharset.Add(268, 49);
  dxgType1FontExpertCharset.Add(269, 50);
  dxgType1FontExpertCharset.Add(270, 51);
  dxgType1FontExpertCharset.Add(271, 52);
  dxgType1FontExpertCharset.Add(272, 53);
  dxgType1FontExpertCharset.Add(273, 54);
  dxgType1FontExpertCharset.Add(274, 55);
  dxgType1FontExpertCharset.Add(275, 56);
  dxgType1FontExpertCharset.Add(276, 57);
  dxgType1FontExpertCharset.Add(277, 58);
  dxgType1FontExpertCharset.Add(278, 59);
  dxgType1FontExpertCharset.Add(279, 60);
  dxgType1FontExpertCharset.Add(280, 61);
  dxgType1FontExpertCharset.Add(281, 62);
  dxgType1FontExpertCharset.Add(282, 63);
  dxgType1FontExpertCharset.Add(283, 64);
  dxgType1FontExpertCharset.Add(284, 65);
  dxgType1FontExpertCharset.Add(285, 66);
  dxgType1FontExpertCharset.Add(286, 67);
  dxgType1FontExpertCharset.Add(287, 68);
  dxgType1FontExpertCharset.Add(288, 69);
  dxgType1FontExpertCharset.Add(289, 70);
  dxgType1FontExpertCharset.Add(290, 71);
  dxgType1FontExpertCharset.Add(291, 72);
  dxgType1FontExpertCharset.Add(292, 73);
  dxgType1FontExpertCharset.Add(293, 74);
  dxgType1FontExpertCharset.Add(294, 75);
  dxgType1FontExpertCharset.Add(295, 76);
  dxgType1FontExpertCharset.Add(296, 77);
  dxgType1FontExpertCharset.Add(297, 78);
  dxgType1FontExpertCharset.Add(298, 79);
  dxgType1FontExpertCharset.Add(299, 80);
  dxgType1FontExpertCharset.Add(300, 81);
  dxgType1FontExpertCharset.Add(301, 82);
  dxgType1FontExpertCharset.Add(302, 83);
  dxgType1FontExpertCharset.Add(303, 84);
  dxgType1FontExpertCharset.Add(304, 85);
  dxgType1FontExpertCharset.Add(305, 86);
  dxgType1FontExpertCharset.Add(306, 87);
  dxgType1FontExpertCharset.Add(307, 88);
  dxgType1FontExpertCharset.Add(308, 89);
  dxgType1FontExpertCharset.Add(309, 90);
  dxgType1FontExpertCharset.Add(310, 91);
  dxgType1FontExpertCharset.Add(311, 92);
  dxgType1FontExpertCharset.Add(312, 93);
  dxgType1FontExpertCharset.Add(313, 94);
  dxgType1FontExpertCharset.Add(314, 95);
  dxgType1FontExpertCharset.Add(315, 96);
  dxgType1FontExpertCharset.Add(316, 97);
  dxgType1FontExpertCharset.Add(317, 98);
  dxgType1FontExpertCharset.Add(318, 99);
  dxgType1FontExpertCharset.Add(158, 100);
  dxgType1FontExpertCharset.Add(155, 101);
  dxgType1FontExpertCharset.Add(163, 102);
  dxgType1FontExpertCharset.Add(319, 103);
  dxgType1FontExpertCharset.Add(320, 104);
  dxgType1FontExpertCharset.Add(321, 105);
  dxgType1FontExpertCharset.Add(322, 106);
  dxgType1FontExpertCharset.Add(323, 107);
  dxgType1FontExpertCharset.Add(324, 108);
  dxgType1FontExpertCharset.Add(325, 109);
  dxgType1FontExpertCharset.Add(326, 110);
  dxgType1FontExpertCharset.Add(150, 111);
  dxgType1FontExpertCharset.Add(164, 112);
  dxgType1FontExpertCharset.Add(169, 113);
  dxgType1FontExpertCharset.Add(327, 114);
  dxgType1FontExpertCharset.Add(328, 115);
  dxgType1FontExpertCharset.Add(329, 116);
  dxgType1FontExpertCharset.Add(330, 117);
  dxgType1FontExpertCharset.Add(331, 118);
  dxgType1FontExpertCharset.Add(332, 119);
  dxgType1FontExpertCharset.Add(333, 120);
  dxgType1FontExpertCharset.Add(334, 121);
  dxgType1FontExpertCharset.Add(335, 122);
  dxgType1FontExpertCharset.Add(336, 123);
  dxgType1FontExpertCharset.Add(337, 124);
  dxgType1FontExpertCharset.Add(338, 125);
  dxgType1FontExpertCharset.Add(339, 126);
  dxgType1FontExpertCharset.Add(340, 127);
  dxgType1FontExpertCharset.Add(341, 128);
  dxgType1FontExpertCharset.Add(342, 129);
  dxgType1FontExpertCharset.Add(343, 130);
  dxgType1FontExpertCharset.Add(344, 131);
  dxgType1FontExpertCharset.Add(345, 132);
  dxgType1FontExpertCharset.Add(346, 133);
  dxgType1FontExpertCharset.Add(347, 134);
  dxgType1FontExpertCharset.Add(348, 135);
  dxgType1FontExpertCharset.Add(349, 136);
  dxgType1FontExpertCharset.Add(350, 137);
  dxgType1FontExpertCharset.Add(351, 138);
  dxgType1FontExpertCharset.Add(352, 139);
  dxgType1FontExpertCharset.Add(353, 140);
  dxgType1FontExpertCharset.Add(354, 141);
  dxgType1FontExpertCharset.Add(355, 142);
  dxgType1FontExpertCharset.Add(356, 143);
  dxgType1FontExpertCharset.Add(357, 144);
  dxgType1FontExpertCharset.Add(358, 145);
  dxgType1FontExpertCharset.Add(359, 146);
  dxgType1FontExpertCharset.Add(360, 147);
  dxgType1FontExpertCharset.Add(361, 148);
  dxgType1FontExpertCharset.Add(362, 149);
  dxgType1FontExpertCharset.Add(363, 150);
  dxgType1FontExpertCharset.Add(364, 151);
  dxgType1FontExpertCharset.Add(365, 152);
  dxgType1FontExpertCharset.Add(366, 153);
  dxgType1FontExpertCharset.Add(367, 154);
  dxgType1FontExpertCharset.Add(368, 155);
  dxgType1FontExpertCharset.Add(369, 156);
  dxgType1FontExpertCharset.Add(370, 157);
  dxgType1FontExpertCharset.Add(371, 158);
  dxgType1FontExpertCharset.Add(372, 159);
  dxgType1FontExpertCharset.Add(373, 160);
  dxgType1FontExpertCharset.Add(374, 161);
  dxgType1FontExpertCharset.Add(375, 162);
  dxgType1FontExpertCharset.Add(376, 163);
  dxgType1FontExpertCharset.Add(377, 164);
  dxgType1FontExpertCharset.Add(378, 165);
  dxgType1FontExpertCharset.TrimExcess;
end;

procedure CreateType1FontExpertSubsetCharset;
begin
  dxgType1FontExpertSubsetCharset := TdxPDFSmallIntegerDictionary.Create;
  dxgType1FontExpertSubsetCharset.Add(1, 1);
  dxgType1FontExpertSubsetCharset.Add(231, 2);
  dxgType1FontExpertSubsetCharset.Add(232, 3);
  dxgType1FontExpertSubsetCharset.Add(235, 4);
  dxgType1FontExpertSubsetCharset.Add(236, 5);
  dxgType1FontExpertSubsetCharset.Add(237, 6);
  dxgType1FontExpertSubsetCharset.Add(238, 7);
  dxgType1FontExpertSubsetCharset.Add(13, 8);
  dxgType1FontExpertSubsetCharset.Add(14, 9);
  dxgType1FontExpertSubsetCharset.Add(15, 10);
  dxgType1FontExpertSubsetCharset.Add(99, 11);
  dxgType1FontExpertSubsetCharset.Add(239, 12);
  dxgType1FontExpertSubsetCharset.Add(240, 13);
  dxgType1FontExpertSubsetCharset.Add(241, 14);
  dxgType1FontExpertSubsetCharset.Add(242, 15);
  dxgType1FontExpertSubsetCharset.Add(243, 16);
  dxgType1FontExpertSubsetCharset.Add(244, 17);
  dxgType1FontExpertSubsetCharset.Add(245, 18);
  dxgType1FontExpertSubsetCharset.Add(246, 19);
  dxgType1FontExpertSubsetCharset.Add(247, 20);
  dxgType1FontExpertSubsetCharset.Add(248, 21);
  dxgType1FontExpertSubsetCharset.Add(27, 22);
  dxgType1FontExpertSubsetCharset.Add(28, 23);
  dxgType1FontExpertSubsetCharset.Add(249, 24);
  dxgType1FontExpertSubsetCharset.Add(250, 25);
  dxgType1FontExpertSubsetCharset.Add(251, 26);
  dxgType1FontExpertSubsetCharset.Add(253, 27);
  dxgType1FontExpertSubsetCharset.Add(254, 28);
  dxgType1FontExpertSubsetCharset.Add(255, 29);
  dxgType1FontExpertSubsetCharset.Add(256, 30);
  dxgType1FontExpertSubsetCharset.Add(257, 31);
  dxgType1FontExpertSubsetCharset.Add(258, 32);
  dxgType1FontExpertSubsetCharset.Add(259, 33);
  dxgType1FontExpertSubsetCharset.Add(260, 34);
  dxgType1FontExpertSubsetCharset.Add(261, 35);
  dxgType1FontExpertSubsetCharset.Add(262, 36);
  dxgType1FontExpertSubsetCharset.Add(263, 37);
  dxgType1FontExpertSubsetCharset.Add(264, 38);
  dxgType1FontExpertSubsetCharset.Add(265, 39);
  dxgType1FontExpertSubsetCharset.Add(266, 40);
  dxgType1FontExpertSubsetCharset.Add(109, 41);
  dxgType1FontExpertSubsetCharset.Add(110, 42);
  dxgType1FontExpertSubsetCharset.Add(267, 43);
  dxgType1FontExpertSubsetCharset.Add(268, 44);
  dxgType1FontExpertSubsetCharset.Add(269, 45);
  dxgType1FontExpertSubsetCharset.Add(270, 46);
  dxgType1FontExpertSubsetCharset.Add(272, 47);
  dxgType1FontExpertSubsetCharset.Add(300, 48);
  dxgType1FontExpertSubsetCharset.Add(301, 49);
  dxgType1FontExpertSubsetCharset.Add(302, 50);
  dxgType1FontExpertSubsetCharset.Add(305, 51);
  dxgType1FontExpertSubsetCharset.Add(314, 52);
  dxgType1FontExpertSubsetCharset.Add(315, 53);
  dxgType1FontExpertSubsetCharset.Add(158, 54);
  dxgType1FontExpertSubsetCharset.Add(155, 55);
  dxgType1FontExpertSubsetCharset.Add(163, 56);
  dxgType1FontExpertSubsetCharset.Add(320, 57);
  dxgType1FontExpertSubsetCharset.Add(321, 58);
  dxgType1FontExpertSubsetCharset.Add(322, 59);
  dxgType1FontExpertSubsetCharset.Add(323, 60);
  dxgType1FontExpertSubsetCharset.Add(324, 61);
  dxgType1FontExpertSubsetCharset.Add(325, 62);
  dxgType1FontExpertSubsetCharset.Add(326, 63);
  dxgType1FontExpertSubsetCharset.Add(150, 64);
  dxgType1FontExpertSubsetCharset.Add(164, 65);
  dxgType1FontExpertSubsetCharset.Add(169, 66);
  dxgType1FontExpertSubsetCharset.Add(327, 67);
  dxgType1FontExpertSubsetCharset.Add(328, 68);
  dxgType1FontExpertSubsetCharset.Add(329, 69);
  dxgType1FontExpertSubsetCharset.Add(330, 70);
  dxgType1FontExpertSubsetCharset.Add(331, 71);
  dxgType1FontExpertSubsetCharset.Add(332, 72);
  dxgType1FontExpertSubsetCharset.Add(333, 73);
  dxgType1FontExpertSubsetCharset.Add(334, 74);
  dxgType1FontExpertSubsetCharset.Add(335, 75);
  dxgType1FontExpertSubsetCharset.Add(336, 76);
  dxgType1FontExpertSubsetCharset.Add(337, 77);
  dxgType1FontExpertSubsetCharset.Add(338, 78);
  dxgType1FontExpertSubsetCharset.Add(339, 79);
  dxgType1FontExpertSubsetCharset.Add(340, 80);
  dxgType1FontExpertSubsetCharset.Add(341, 81);
  dxgType1FontExpertSubsetCharset.Add(342, 82);
  dxgType1FontExpertSubsetCharset.Add(343, 83);
  dxgType1FontExpertSubsetCharset.Add(344, 84);
  dxgType1FontExpertSubsetCharset.Add(345, 85);
  dxgType1FontExpertSubsetCharset.Add(346, 86);
  dxgType1FontExpertSubsetCharset.TrimExcess;
end;

procedure CreateType1FontAdobeCharset;
begin
  dxgType1FontISOAdobeCharset := TdxPDFSmallIntegerDictionary.Create;
  dxgType1FontISOAdobeCharset.Add(1, 1);
  dxgType1FontISOAdobeCharset.Add(2, 2);
  dxgType1FontISOAdobeCharset.Add(3, 3);
  dxgType1FontISOAdobeCharset.Add(4, 4);
  dxgType1FontISOAdobeCharset.Add(5, 5);
  dxgType1FontISOAdobeCharset.Add(6, 6);
  dxgType1FontISOAdobeCharset.Add(7, 7);
  dxgType1FontISOAdobeCharset.Add(8, 8);
  dxgType1FontISOAdobeCharset.Add(9, 9);
  dxgType1FontISOAdobeCharset.Add(10, 10);
  dxgType1FontISOAdobeCharset.Add(11, 11);
  dxgType1FontISOAdobeCharset.Add(12, 12);
  dxgType1FontISOAdobeCharset.Add(13, 13);
  dxgType1FontISOAdobeCharset.Add(14, 14);
  dxgType1FontISOAdobeCharset.Add(15, 15);
  dxgType1FontISOAdobeCharset.Add(16, 16);
  dxgType1FontISOAdobeCharset.Add(17, 17);
  dxgType1FontISOAdobeCharset.Add(18, 18);
  dxgType1FontISOAdobeCharset.Add(19, 19);
  dxgType1FontISOAdobeCharset.Add(20, 20);
  dxgType1FontISOAdobeCharset.Add(21, 21);
  dxgType1FontISOAdobeCharset.Add(22, 22);
  dxgType1FontISOAdobeCharset.Add(23, 23);
  dxgType1FontISOAdobeCharset.Add(24, 24);
  dxgType1FontISOAdobeCharset.Add(25, 25);
  dxgType1FontISOAdobeCharset.Add(26, 26);
  dxgType1FontISOAdobeCharset.Add(27, 27);
  dxgType1FontISOAdobeCharset.Add(28, 28);
  dxgType1FontISOAdobeCharset.Add(29, 29);
  dxgType1FontISOAdobeCharset.Add(30, 30);
  dxgType1FontISOAdobeCharset.Add(31, 31);
  dxgType1FontISOAdobeCharset.Add(32, 32);
  dxgType1FontISOAdobeCharset.Add(33, 33);
  dxgType1FontISOAdobeCharset.Add(34, 34);
  dxgType1FontISOAdobeCharset.Add(35, 35);
  dxgType1FontISOAdobeCharset.Add(36, 36);
  dxgType1FontISOAdobeCharset.Add(37, 37);
  dxgType1FontISOAdobeCharset.Add(38, 38);
  dxgType1FontISOAdobeCharset.Add(39, 39);
  dxgType1FontISOAdobeCharset.Add(40, 40);
  dxgType1FontISOAdobeCharset.Add(41, 41);
  dxgType1FontISOAdobeCharset.Add(42, 42);
  dxgType1FontISOAdobeCharset.Add(43, 43);
  dxgType1FontISOAdobeCharset.Add(44, 44);
  dxgType1FontISOAdobeCharset.Add(45, 45);
  dxgType1FontISOAdobeCharset.Add(46, 46);
  dxgType1FontISOAdobeCharset.Add(47, 47);
  dxgType1FontISOAdobeCharset.Add(48, 48);
  dxgType1FontISOAdobeCharset.Add(49, 49);
  dxgType1FontISOAdobeCharset.Add(50, 50);
  dxgType1FontISOAdobeCharset.Add(51, 51);
  dxgType1FontISOAdobeCharset.Add(52, 52);
  dxgType1FontISOAdobeCharset.Add(53, 53);
  dxgType1FontISOAdobeCharset.Add(54, 54);
  dxgType1FontISOAdobeCharset.Add(55, 55);
  dxgType1FontISOAdobeCharset.Add(56, 56);
  dxgType1FontISOAdobeCharset.Add(57, 57);
  dxgType1FontISOAdobeCharset.Add(58, 58);
  dxgType1FontISOAdobeCharset.Add(59, 59);
  dxgType1FontISOAdobeCharset.Add(60, 60);
  dxgType1FontISOAdobeCharset.Add(61, 61);
  dxgType1FontISOAdobeCharset.Add(62, 62);
  dxgType1FontISOAdobeCharset.Add(63, 63);
  dxgType1FontISOAdobeCharset.Add(64, 64);
  dxgType1FontISOAdobeCharset.Add(65, 65);
  dxgType1FontISOAdobeCharset.Add(66, 66);
  dxgType1FontISOAdobeCharset.Add(67, 67);
  dxgType1FontISOAdobeCharset.Add(68, 68);
  dxgType1FontISOAdobeCharset.Add(69, 69);
  dxgType1FontISOAdobeCharset.Add(70, 70);
  dxgType1FontISOAdobeCharset.Add(71, 71);
  dxgType1FontISOAdobeCharset.Add(72, 72);
  dxgType1FontISOAdobeCharset.Add(73, 73);
  dxgType1FontISOAdobeCharset.Add(74, 74);
  dxgType1FontISOAdobeCharset.Add(75, 75);
  dxgType1FontISOAdobeCharset.Add(76, 76);
  dxgType1FontISOAdobeCharset.Add(77, 77);
  dxgType1FontISOAdobeCharset.Add(78, 78);
  dxgType1FontISOAdobeCharset.Add(79, 79);
  dxgType1FontISOAdobeCharset.Add(80, 80);
  dxgType1FontISOAdobeCharset.Add(81, 81);
  dxgType1FontISOAdobeCharset.Add(82, 82);
  dxgType1FontISOAdobeCharset.Add(83, 83);
  dxgType1FontISOAdobeCharset.Add(84, 84);
  dxgType1FontISOAdobeCharset.Add(85, 85);
  dxgType1FontISOAdobeCharset.Add(86, 86);
  dxgType1FontISOAdobeCharset.Add(87, 87);
  dxgType1FontISOAdobeCharset.Add(88, 88);
  dxgType1FontISOAdobeCharset.Add(89, 89);
  dxgType1FontISOAdobeCharset.Add(90, 90);
  dxgType1FontISOAdobeCharset.Add(91, 91);
  dxgType1FontISOAdobeCharset.Add(92, 92);
  dxgType1FontISOAdobeCharset.Add(93, 93);
  dxgType1FontISOAdobeCharset.Add(94, 94);
  dxgType1FontISOAdobeCharset.Add(95, 95);
  dxgType1FontISOAdobeCharset.Add(96, 96);
  dxgType1FontISOAdobeCharset.Add(97, 97);
  dxgType1FontISOAdobeCharset.Add(98, 98);
  dxgType1FontISOAdobeCharset.Add(99, 99);
  dxgType1FontISOAdobeCharset.Add(100, 100);
  dxgType1FontISOAdobeCharset.Add(101, 101);
  dxgType1FontISOAdobeCharset.Add(102, 102);
  dxgType1FontISOAdobeCharset.Add(103, 103);
  dxgType1FontISOAdobeCharset.Add(104, 104);
  dxgType1FontISOAdobeCharset.Add(105, 105);
  dxgType1FontISOAdobeCharset.Add(106, 106);
  dxgType1FontISOAdobeCharset.Add(107, 107);
  dxgType1FontISOAdobeCharset.Add(108, 108);
  dxgType1FontISOAdobeCharset.Add(109, 109);
  dxgType1FontISOAdobeCharset.Add(110, 110);
  dxgType1FontISOAdobeCharset.Add(111, 111);
  dxgType1FontISOAdobeCharset.Add(112, 112);
  dxgType1FontISOAdobeCharset.Add(113, 113);
  dxgType1FontISOAdobeCharset.Add(114, 114);
  dxgType1FontISOAdobeCharset.Add(115, 115);
  dxgType1FontISOAdobeCharset.Add(116, 116);
  dxgType1FontISOAdobeCharset.Add(117, 117);
  dxgType1FontISOAdobeCharset.Add(118, 118);
  dxgType1FontISOAdobeCharset.Add(119, 119);
  dxgType1FontISOAdobeCharset.Add(120, 120);
  dxgType1FontISOAdobeCharset.Add(121, 121);
  dxgType1FontISOAdobeCharset.Add(122, 122);
  dxgType1FontISOAdobeCharset.Add(123, 123);
  dxgType1FontISOAdobeCharset.Add(124, 124);
  dxgType1FontISOAdobeCharset.Add(125, 125);
  dxgType1FontISOAdobeCharset.Add(126, 126);
  dxgType1FontISOAdobeCharset.Add(127, 127);
  dxgType1FontISOAdobeCharset.Add(128, 128);
  dxgType1FontISOAdobeCharset.Add(129, 129);
  dxgType1FontISOAdobeCharset.Add(130, 130);
  dxgType1FontISOAdobeCharset.Add(131, 131);
  dxgType1FontISOAdobeCharset.Add(132, 132);
  dxgType1FontISOAdobeCharset.Add(133, 133);
  dxgType1FontISOAdobeCharset.Add(134, 134);
  dxgType1FontISOAdobeCharset.Add(135, 135);
  dxgType1FontISOAdobeCharset.Add(136, 136);
  dxgType1FontISOAdobeCharset.Add(137, 137);
  dxgType1FontISOAdobeCharset.Add(138, 138);
  dxgType1FontISOAdobeCharset.Add(139, 139);
  dxgType1FontISOAdobeCharset.Add(140, 140);
  dxgType1FontISOAdobeCharset.Add(141, 141);
  dxgType1FontISOAdobeCharset.Add(142, 142);
  dxgType1FontISOAdobeCharset.Add(143, 143);
  dxgType1FontISOAdobeCharset.Add(144, 144);
  dxgType1FontISOAdobeCharset.Add(145, 145);
  dxgType1FontISOAdobeCharset.Add(146, 146);
  dxgType1FontISOAdobeCharset.Add(147, 147);
  dxgType1FontISOAdobeCharset.Add(148, 148);
  dxgType1FontISOAdobeCharset.Add(149, 149);
  dxgType1FontISOAdobeCharset.Add(150, 150);
  dxgType1FontISOAdobeCharset.Add(151, 151);
  dxgType1FontISOAdobeCharset.Add(152, 152);
  dxgType1FontISOAdobeCharset.Add(153, 153);
  dxgType1FontISOAdobeCharset.Add(154, 154);
  dxgType1FontISOAdobeCharset.Add(155, 155);
  dxgType1FontISOAdobeCharset.Add(156, 156);
  dxgType1FontISOAdobeCharset.Add(157, 157);
  dxgType1FontISOAdobeCharset.Add(158, 158);
  dxgType1FontISOAdobeCharset.Add(159, 159);
  dxgType1FontISOAdobeCharset.Add(160, 160);
  dxgType1FontISOAdobeCharset.Add(161, 161);
  dxgType1FontISOAdobeCharset.Add(162, 162);
  dxgType1FontISOAdobeCharset.Add(163, 163);
  dxgType1FontISOAdobeCharset.Add(164, 164);
  dxgType1FontISOAdobeCharset.Add(165, 165);
  dxgType1FontISOAdobeCharset.Add(166, 166);
  dxgType1FontISOAdobeCharset.Add(167, 167);
  dxgType1FontISOAdobeCharset.Add(168, 168);
  dxgType1FontISOAdobeCharset.Add(169, 169);
  dxgType1FontISOAdobeCharset.Add(170, 170);
  dxgType1FontISOAdobeCharset.Add(171, 171);
  dxgType1FontISOAdobeCharset.Add(172, 172);
  dxgType1FontISOAdobeCharset.Add(173, 173);
  dxgType1FontISOAdobeCharset.Add(174, 174);
  dxgType1FontISOAdobeCharset.Add(175, 175);
  dxgType1FontISOAdobeCharset.Add(176, 176);
  dxgType1FontISOAdobeCharset.Add(177, 177);
  dxgType1FontISOAdobeCharset.Add(178, 178);
  dxgType1FontISOAdobeCharset.Add(179, 179);
  dxgType1FontISOAdobeCharset.Add(180, 180);
  dxgType1FontISOAdobeCharset.Add(181, 181);
  dxgType1FontISOAdobeCharset.Add(182, 182);
  dxgType1FontISOAdobeCharset.Add(183, 183);
  dxgType1FontISOAdobeCharset.Add(184, 184);
  dxgType1FontISOAdobeCharset.Add(185, 185);
  dxgType1FontISOAdobeCharset.Add(186, 186);
  dxgType1FontISOAdobeCharset.Add(187, 187);
  dxgType1FontISOAdobeCharset.Add(188, 188);
  dxgType1FontISOAdobeCharset.Add(189, 189);
  dxgType1FontISOAdobeCharset.Add(190, 190);
  dxgType1FontISOAdobeCharset.Add(191, 191);
  dxgType1FontISOAdobeCharset.Add(192, 192);
  dxgType1FontISOAdobeCharset.Add(193, 193);
  dxgType1FontISOAdobeCharset.Add(194, 194);
  dxgType1FontISOAdobeCharset.Add(195, 195);
  dxgType1FontISOAdobeCharset.Add(196, 196);
  dxgType1FontISOAdobeCharset.Add(197, 197);
  dxgType1FontISOAdobeCharset.Add(198, 198);
  dxgType1FontISOAdobeCharset.Add(199, 199);
  dxgType1FontISOAdobeCharset.Add(200, 200);
  dxgType1FontISOAdobeCharset.Add(201, 201);
  dxgType1FontISOAdobeCharset.Add(202, 202);
  dxgType1FontISOAdobeCharset.Add(203, 203);
  dxgType1FontISOAdobeCharset.Add(204, 204);
  dxgType1FontISOAdobeCharset.Add(205, 205);
  dxgType1FontISOAdobeCharset.Add(206, 206);
  dxgType1FontISOAdobeCharset.Add(207, 207);
  dxgType1FontISOAdobeCharset.Add(208, 208);
  dxgType1FontISOAdobeCharset.Add(209, 209);
  dxgType1FontISOAdobeCharset.Add(210, 210);
  dxgType1FontISOAdobeCharset.Add(211, 211);
  dxgType1FontISOAdobeCharset.Add(212, 212);
  dxgType1FontISOAdobeCharset.Add(213, 213);
  dxgType1FontISOAdobeCharset.Add(214, 214);
  dxgType1FontISOAdobeCharset.Add(215, 215);
  dxgType1FontISOAdobeCharset.Add(216, 216);
  dxgType1FontISOAdobeCharset.Add(217, 217);
  dxgType1FontISOAdobeCharset.Add(218, 218);
  dxgType1FontISOAdobeCharset.Add(219, 219);
  dxgType1FontISOAdobeCharset.Add(220, 220);
  dxgType1FontISOAdobeCharset.Add(221, 221);
  dxgType1FontISOAdobeCharset.Add(222, 222);
  dxgType1FontISOAdobeCharset.Add(223, 223);
  dxgType1FontISOAdobeCharset.Add(224, 224);
  dxgType1FontISOAdobeCharset.Add(225, 225);
  dxgType1FontISOAdobeCharset.Add(226, 226);
  dxgType1FontISOAdobeCharset.Add(227, 227);
  dxgType1FontISOAdobeCharset.Add(228, 228);
  dxgType1FontISOAdobeCharset.TrimExcess;
end;

function DoubleAsString(AValue: Double; APrecision, ADigits: Integer): string;
begin
  Result := FloatToStrF(AValue, ffGeneral, APrecision, ADigits);
  Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
end;

function dxCompactFontFormatDictIndexOneByteOperatorFactory: TdxCompactFontFormatDictIndexOperatorFactory;
begin
  if dxgPDFCompactFontFormatDictIndexOneByteOperatorFactory = nil then
    dxgPDFCompactFontFormatDictIndexOneByteOperatorFactory := TdxCompactFontFormatDictIndexOperatorFactory.Create;
  Result := dxgPDFCompactFontFormatDictIndexOneByteOperatorFactory;
end;

function dxCompactFontFormatDictIndexTwoByteOperatorFactory: TdxCompactFontFormatDictIndexOperatorFactory;
begin
  if dxgPDFCompactFontFormatDictIndexTwoByteOperatorFactory = nil then
    dxgPDFCompactFontFormatDictIndexTwoByteOperatorFactory := TdxCompactFontFormatDictIndexOperatorFactory.Create;
  Result := dxgPDFCompactFontFormatDictIndexTwoByteOperatorFactory;
end;

function dxPDFStandardFontDescriptor: TdxPDFStandardFontDescriptor;
begin
  if dxgPDFStandardFontDescriptor = nil then
    dxgPDFStandardFontDescriptor := TdxPDFStandardFontDescriptor.Create;
  Result := dxgPDFStandardFontDescriptor;
end;

{ TdxCompactFontFormatTopDictIndexWriter }

constructor TdxCompactFontFormatTopDictIndexWriter.Create(AFontProgram: TdxType1FontCompactFontProgram);
var
  ABaseFontBlend: TDoubleDynArray;
  ACharset: TdxType1FontCustomCharset;
  ACharsetOperator: TdxCompactFontFormatDictIndexCharsetOperator;
  ACharStrings: TdxPDFBytesList;
  ACharStringsOperator: TdxCompactFontFormatDictIndexCharStringsOperator;
  ACidFontProgram: TdxType1FontCompactCIDFontProgram;
  AEncoding: TdxType1FontEncoding;
  AEncodingOperator: TdxCompactFontFormatDictIndexEncodingOperator;
  AFdArrayOperator: TdxCompactFontFormatDictIndexFDArrayOperator;
  AFdSelectOperator: TdxCompactFontFormatDictIndexFDSelectOperator;
  AFontBBox: TdxRectF;
  AFontInfo: TdxType1FontInfo;
  AFontMatrix: TdxCompactFontFormatTarnsformationMatrix;
  AFontType: TdxType1FontType;
  ANeedRecalculate: Boolean;
  ANumber: Double;
  AOffsetOperator: IdxCompactFontFormatDictIndexOffsetOperator;
  AOper: TdxCompactFontFormatDictIndexOperator;
  APrivateData: TdxType1FontPrivateData;
  APrivateOperator: TdxCompactFontFormatDictIndexPrivateOperator;
  AStr: string;
  AUidBase: Integer;
  AXuid: TIntegerDynArray;
  I, AInteger, AOffset, APreviousSize: Integer;
begin
  FOperators := TdxCompactFontFormatDictIndexOperatorList.Create;
  FOffsetOperators := TdxCompactFontFormatDictIndexOffsetOperatorList.Create;
  FGlobalSubrs := TdxCompactFontFormatBinaryIndex.CreateEx(AFontProgram.GlobalSubrs);

  FMajorVersion := AFontProgram.MajorVersion;
  FMinorVersion := AFontProgram.MinorVersion;
  FName := AFontProgram.FontName;
  FStringIndex := AFontProgram.StringIndex;

  if Safe.Cast(AFontProgram, TdxType1FontCompactCIDFontProgram, ACidFontProgram) then
  begin
    FOperators.Add(TdxCompactFontFormatDictIndexROSOperator.Create(ACidFontProgram.Registry, ACidFontProgram.Ordering,
      ACidFontProgram.Supplement));
    ANumber := ACidFontProgram.CIDFontVersion;
    if ANumber <> TdxType1FontCompactCIDFontProgram.DefaultCIDFontVersion then
      FOperators.Add(TdxCompactFontFormatDictIndexCIDFontVersionOperator.Create(ANumber));
    AInteger := ACidFontProgram.CIDCount;
    if AInteger <> TdxType1FontCompactCIDFontProgram.DefaultCIDCount then
      FOperators.Add(TdxCompactFontFormatDictIndexCIDCountOperator.Create(AInteger));
    AUidBase := ACidFontProgram.UIDBase;
    if TdxPDFUtils.IsIntegerValid(AUidBase) then
      FOperators.Add(TdxCompactFontFormatDictIndexUIDBaseOperator.Create(AUidBase));
    if ACidFontProgram.GlyphGroupSelector <> nil then
    begin
      AFdSelectOperator := TdxCompactFontFormatDictIndexFDSelectOperator.Create(ACidFontProgram.GlyphGroupSelector);
      FOperators.Add(AFdSelectOperator);
      FOffsetOperators.Add(AFdSelectOperator);
    end;
    if (ACidFontProgram.GlyphGroupData <> nil) and (ACidFontProgram.GlyphGroupData.Count > 0) then
    begin
      AFdArrayOperator := TdxCompactFontFormatDictIndexFDArrayOperator.Create(ACidFontProgram.GlyphGroupData, FStringIndex);
      FOperators.Add(AFdArrayOperator);
      FOffsetOperators.Add(AFdArrayOperator);
      for I := 0 to AFdArrayOperator.OffsetOperators.Count - 1 do
        FOffsetOperators.Add(AFdArrayOperator.OffsetOperators[I]);
    end;
  end;
  AFontInfo := AFontProgram.FontInfo;
  AStr := AFontInfo.Version;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexVersionOperator.Create(AStr));
  AStr := AFontInfo.Notice;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexNoticeOperator.Create(AStr));
  AStr := AFontInfo.Copyright;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexCopyrightOperator.Create(AStr));
  AStr := AFontInfo.FullName;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexFullNameOperator.Create(AStr));
  AStr := AFontInfo.FamilyName;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexFamilyNameOperator.Create(AStr));
  AStr := AFontInfo.Weight;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexWeightOperator.Create(AStr));
  if AFontInfo.IsFixedPitch then
    FOperators.Add(TdxCompactFontFormatDictIndexIsFixedPitchOperator.Create(True));
  ANumber := AFontInfo.ItalicAngle;
  if ANumber <> TdxType1FontInfo.DefaultItalicAngle then
    FOperators.Add(TdxCompactFontFormatDictIndexItalicAngleOperator.Create(ANumber));
  ANumber := AFontInfo.UnderlinePosition;
  if ANumber <> TdxType1FontInfo.DefaultUnderlinePosition then
    FOperators.Add(TdxCompactFontFormatDictIndexUnderlinePositionOperator.Create(ANumber));
  ANumber := AFontInfo.UnderlineThickness;
  if ANumber <> TdxType1FontInfo.DefaultUnderlineThickness then
    FOperators.Add(TdxCompactFontFormatDictIndexUnderlineThicknessOperator.Create(ANumber));
  AFontType := AFontProgram.FontType;
  if AFontType <> TdxType1FontCompactFontProgram.DefaultFontType then
    FOperators.Add(TdxCompactFontFormatDictIndexCharstringTypeOperator.Create(AFontType));
  AFontMatrix := AFontProgram.FontMatrix;
  if not AFontMatrix.IsEqual(AFontMatrix, TdxType1FontCompactFontProgram.DefaultFontMatrix) then
    FOperators.Add(TdxCompactFontFormatDictIndexFontMatrixOperator.Create(AFontMatrix));
  AInteger := AFontProgram.UniqueID;
  if AInteger <> TdxType1CustomFontProgram.DefaultUniqueID then
    FOperators.Add(TdxCompactFontFormatDictIndexUniqueIDOperator.Create(AInteger));
  if AFontProgram.PaintType <> ptFilled then
    FOperators.Add(TdxCompactFontFormatDictIndexPaintTypeOperator.Create(AFontProgram.PaintType));
  AFontBBox := AFontProgram.FontBBox;
  if not TdxPDFUtils.RectIsEqual(AFontBBox, TdxType1FontCompactFontProgram.DefaultFontBBox, 0.001) then
    FOperators.Add(TdxCompactFontFormatDictIndexFontBBoxOperator.Create(AFontBBox));
  ANumber := AFontProgram.StrokeWidth;
  if ANumber <> TdxType1CustomFontProgram.DefaultStrokeWidth then
    FOperators.Add(TdxCompactFontFormatDictIndexStrokeWidthOperator.Create(ANumber));
  AXuid := AFontProgram.XUID;
  if AXuid <> nil then
    FOperators.Add(TdxCompactFontFormatDictIndexXUIDOperator.Create(AXuid));
  AEncoding := AFontProgram.Encoding;
  if not AEncoding.IsDefault then
  begin
    AEncodingOperator := TdxCompactFontFormatDictIndexEncodingOperator.Create(AEncoding);
    FOperators.Add(AEncodingOperator);
    if AEncoding.GetOffset = 0 then
      FOffsetOperators.Add(AEncodingOperator);
  end;
  ACharset := AFontProgram.Charset;
  if not ACharset.IsDefault then
  begin
    ACharsetOperator := TdxCompactFontFormatDictIndexCharsetOperator.Create(ACharset);
    FOperators.Add(ACharsetOperator);
    if ACharset.Offset = 0 then
      FOffsetOperators.Add(ACharsetOperator);
  end;
  ACharStrings := AFontProgram.CharStrings;
  if (ACharStrings <> nil) and (ACharStrings.Count > 0) then
  begin
    ACharStringsOperator := TdxCompactFontFormatDictIndexCharStringsOperator.Create(ACharStrings);
    FOperators.Add(ACharStringsOperator);
    FOffsetOperators.Add(ACharStringsOperator);
  end;
  APrivateData := AFontProgram.PrivateData;
  if APrivateData <> nil then
  begin
    APrivateOperator := TdxCompactFontFormatDictIndexPrivateOperator.Create(APrivateData);
    FOperators.Add(APrivateOperator);
    FOffsetOperators.Add(APrivateOperator);
  end;
  AStr := AFontProgram.PostScript;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexPostScriptOperator.Create(AStr));
  AStr := AFontInfo.BaseFontName;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexBaseFontNameOperator.Create(AStr));
  ABaseFontBlend := AFontProgram.BaseFontBlend;
  if ABaseFontBlend <> nil then
    FOperators.Add(TdxCompactFontFormatDictIndexBaseFontBlendOperator.Create(ABaseFontBlend));
  AStr := AFontProgram.CIDFontName;
  if AStr <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexFontNameOperator.Create(AStr));
  ANeedRecalculate := True;
  while ANeedRecalculate do
  begin
    ANeedRecalculate := False;
    AOffset := Length(FName) + FStringIndex.DataLength + FGlobalSubrs.DataLength + 26;
    for AOper in FOperators do
      Inc(AOffset, AOper.GetSize(FStringIndex));
    for I := 0 to FOffsetOperators.Count - 1 do
    begin
      AOffsetOperator := FOffsetOperators[I] as IdxCompactFontFormatDictIndexOffsetOperator;
      APreviousSize := AOffsetOperator.GetSize(FStringIndex);
      AOffsetOperator.Offset := AOffset;
      if AOffsetOperator.GetSize(FStringIndex) <> APreviousSize then
      begin
        ANeedRecalculate := True;
        Break;
      end;
      Inc(AOffset, AOffsetOperator.Length);
    end;
  end;
end;

destructor TdxCompactFontFormatTopDictIndexWriter.Destroy;
begin
  FreeAndNil(FOffsetOperators);
  FreeAndNil(FOperators);
  FreeAndNil(FGlobalSubrs);
  inherited Destroy;
end;

class function TdxCompactFontFormatTopDictIndexWriter.Write(AFontProgram: TdxType1FontCompactFontProgram): TBytes;
var
  AWriter: TdxCompactFontFormatTopDictIndexWriter;
  AStream: TdxFontFileStream;
begin
  AWriter := TdxCompactFontFormatTopDictIndexWriter.Create(AFontProgram);
  try
    AStream := TdxFontFileStream.Create;
    try
      AWriter.DoWrite(AStream);
      Result := AStream.Data;
    finally
      AStream.Free;
    end;
  finally
    AWriter.Free;
  end;
end;

procedure TdxCompactFontFormatTopDictIndexWriter.DoWrite(AStream: TdxFontFileStream);
var
  I: Integer;
  ATopDictIndexStream: TdxFontFileStream;
  AOper: TdxCompactFontFormatDictIndexOperator;
  ANameIndex: TdxCompactFontFormatNameIndex;
  ATopDictIndex: TdxCompactFontFormatTopDictIndex;
begin
  AStream.WriteByte(FMajorVersion);
  AStream.WriteByte(FMinorVersion);
  AStream.WriteByte(4);
  AStream.WriteByte(1);
  ANameIndex := TdxCompactFontFormatNameIndex.Create;
  try
    ANameIndex.AddString(FName);
    ANameIndex.Write(AStream);
  finally
    ANameIndex.Free;
  end;
  ATopDictIndexStream := TdxFontFileStream.Create;
  try
    for AOper in FOperators do
      AOper.Write(ATopDictIndexStream, FStringIndex);
    ATopDictIndex := TdxCompactFontFormatTopDictIndex.CreateEx(ATopDictIndexStream.Data);
    try
      ATopDictIndex.Write(AStream);
    finally
      ATopDictIndex.Free;
    end;
  finally
    ATopDictIndexStream.Free;
  end;
  FStringIndex.Write(AStream);
  FGlobalSubrs.Write(AStream);
  for I := 0 to FOffsetOperators.Count - 1 do
    IdxCompactFontFormatDictIndexOffsetOperator(FOffsetOperators[I]).WriteData(AStream);
end;

{ TdxCompactFontFormatPrivateDictIndexParser }

class function TdxCompactFontFormatPrivateDictIndexParser.Parse(AStream: TdxFontFileStream;
  const AData: TBytes): TdxType1FontCompactFontPrivateData;
var
  AOperator: TdxCompactFontFormatDictIndexOperator;
  AOperators: TdxCompactFontFormatDictIndexOperatorList;
  AParser: TdxCompactFontFormatPrivateDictIndexParser;
begin
  Result := TdxType1FontCompactFontPrivateData.Create;
  AParser := TdxCompactFontFormatPrivateDictIndexParser.Create(AData);
  try
    AOperators := AParser.ParseOperators;
    try
      for AOperator in AOperators do
        AOperator.Execute(AStream, Result);
    finally
      AOperators.Free;
    end;
  finally
    AParser.Free;
  end;
end;

function TdxCompactFontFormatPrivateDictIndexParser.CreateOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass;
  AOperands: TDoubleDynArray): TdxCompactFontFormatDictIndexOperator;
begin
  Result := AClass.Create(nil, AOperands);
end;

{ TdxCompactFontFormatPrivateDictIndexWriter }

constructor TdxCompactFontFormatPrivateDictIndexWriter.Create(APrivateData: TdxType1FontPrivateData);
var
  ACompactFontPrivateData: TdxType1FontCompactFontPrivateData;
  ANumber: Double;
begin
  inherited Create;
  FOperators := TdxCompactFontFormatDictIndexOperatorList.Create;
  if Length(APrivateData.BlueValues) > 0 then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexBlueValuesOperator.Create(APrivateData.BlueValues));
  if Length(APrivateData.OtherBlues) > 0 then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexOtherBluesOperator.Create(APrivateData.OtherBlues));
  if Length(APrivateData.FamilyBlues) > 0 then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexFamilyBluesOperator.Create(APrivateData.FamilyBlues));
  if Length(APrivateData.FamilyOtherBlues) > 0 then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexFamilyOtherBluesOperator.Create(APrivateData.FamilyOtherBlues));
  if not SameValue(APrivateData.BlueScale, TdxType1FontPrivateData.DefaultBlueScale) then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexBlueScaleOperator.Create(APrivateData.BlueScale));
  if not SameValue(APrivateData.BlueShift, TdxType1FontPrivateData.DefaultBlueShift) then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexBlueShiftOperator.Create(APrivateData.BlueShift));
  if APrivateData.BlueFuzz <> TdxType1FontCompactFontPrivateData.DefaultBlueFuzz then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexBlueFuzzOperator.Create(APrivateData.BlueFuzz));
  if not SameValue(APrivateData.StdHW, dxPDFInvalidValue) then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexStdHWOperator.Create(APrivateData.StdHW));
  if not SameValue(APrivateData.StdVW, dxPDFInvalidValue) then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexStdVWOperator.Create(APrivateData.StdVW));
  if Length(APrivateData.StemSnapH) > 0 then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexStemSnapHOperator.Create(APrivateData.StemSnapH));
  if Length(APrivateData.StemSnapV) > 0 then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexStemSnapVOperator.Create(APrivateData.StemSnapV));
  if APrivateData.ForceBold then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexForceBoldOperator.Create(APrivateData.ForceBold));
  if not SameValue(APrivateData.ForceBoldThreshold, dxPDFInvalidValue) then
    FOperators.Add(TdxCompactFontFormatPrivateDictIndexForceBoldThresholdOperator.Create(APrivateData.ForceBoldThreshold));
  if APrivateData is TdxType1FontCompactFontPrivateData then
  begin
    ACompactFontPrivateData := TdxType1FontCompactFontPrivateData(APrivateData);
    if ACompactFontPrivateData.LanguageGroup <> TdxType1FontCompactFontPrivateData.DefaultLanguageGroup then
      FOperators.Add(TdxCompactFontFormatPrivateDictIndexLanguageGroupOperator.Create(ACompactFontPrivateData.LanguageGroup));
    if not SameValue(ACompactFontPrivateData.ExpansionFactor, TdxType1FontPrivateData.DefaultExpansionFactor) then
      FOperators.Add(TdxCompactFontFormatPrivateDictIndexExpansionFactorOperator.Create(ACompactFontPrivateData.ExpansionFactor));
    if (ACompactFontPrivateData.Subrs <> nil) and (ACompactFontPrivateData.Subrs.Count > 0) then
    begin
      FSubrsOperator :=  TdxCompactFontFormatPrivateDictIndexSubrsOperator.Create(ACompactFontPrivateData.Subrs);
      FOperators.Add(FSubrsOperator);
    end;
    ANumber := ACompactFontPrivateData.DefaultWidthX;
    if not SameValue(ANumber, ACompactFontPrivateData.DefaultDefaultWidthX) then
      FOperators.Add(TdxCompactFontFormatPrivateDictIndexDefaultWidthXOperator.Create(ANumber));
    ANumber := ACompactFontPrivateData.NominalWidthX;
    if not SameValue(ANumber, ACompactFontPrivateData.DefaultNominalWidthX) then
      FOperators.Add(TdxCompactFontFormatPrivateDictIndexNominalWidthXOperator.Create(ANumber));
  end;
  if FSubrsOperator = nil then
    CalculateDataLength
  else
    repeat
      CalculateDataLength;
    until not FSubrsOperator.UpdateOffset(FDataLength);
end;

destructor TdxCompactFontFormatPrivateDictIndexWriter.Destroy;
begin
  FreeAndNil(FOperators);
  inherited Destroy;
end;

function TdxCompactFontFormatPrivateDictIndexWriter.DataLength: Integer;
begin
  Result := FDataLength;
end;

function TdxCompactFontFormatPrivateDictIndexWriter.SubrsLength: Integer;
begin
  if FSubrsOperator = nil then
    Result := 0
  else
    Result := FSubrsOperator.DataLength;
end;

procedure TdxCompactFontFormatPrivateDictIndexWriter.Write(AStream: TdxFontFileStream);
var
  AOperator: TdxCompactFontFormatDictIndexOperator;
begin
  for AOperator in FOperators do
    AOperator.Write(AStream, nil);
  if FSubrsOperator <> nil then
    FSubrsOperator.WriteData(AStream);
end;

procedure TdxCompactFontFormatPrivateDictIndexWriter.CalculateDataLength;
var
  AOperator: TdxCompactFontFormatDictIndexOperator;
begin
  FDataLength := 0;
  for AOperator in FOperators do
    Inc(FDataLength, AOperator.GetSize(nil));
end;

{ TdxPDFStandardFontDescriptor }

constructor TdxPDFStandardFontDescriptor.Create;
begin
  inherited Create;
  FPopulationProcDictionary := TDictionary<string, TPopulateStandardFontDescriptorProc>.Create;
  FPopulationProcDictionary.Add(TdxPDFKeywords.TimesRomanFontName, PopulateTimesNewRomanFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.SymbolFontName, PopulateSymbolFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.TimesBoldFontName, PopulateTimesBoldFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.TimesItalicFontName, PopulateTimesItalicFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.TimesBoldItalicFontName, PopulateTimesBoldItalicFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.ArialFontName, PopulateHelveticaFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.HelveticaFontName, PopulateHelveticaFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.HelveticaObliqueFontName, PopulateHelveticaObliqueFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.HelveticaBoldFontName, PopulateHelveticaBoldFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.HelveticaBoldObliqueFontName, PopulateHelveticaBoldObliqueFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.CourierFontName, PopulateCourierFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.CourierNewFontName, PopulateCourierFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.CourierNewBoldFontName, PopulateCourierFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.CourierObliqueFontName, PopulateCourierObliqueFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.CourierBoldFontName, PopulateCourierBoldFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.CourierBoldObliqueFontName, PopulateCourierBoldObliqueFontDescriptorDictionary);
  FPopulationProcDictionary.Add(TdxPDFKeywords.ZapfDingbatsFontName, PopulateZapfDingbatsFontDescriptorDictionary);
  FPopulationProcDictionary.TrimExcess;

  FStandardFontNameMap := TdxPDFStringStringDictionary.Create(100);
  FStandardFontNameMap.Add('Arial', 'Helvetica');
  FStandardFontNameMap.Add('Arial,Bold', 'Helvetica-Bold');
  FStandardFontNameMap.Add('Arial,BoldItalic', 'Helvetica-BoldOblique');
  FStandardFontNameMap.Add('Arial,Italic', 'Helvetica-Oblique');
  FStandardFontNameMap.Add('Arial-Bold', 'Helvetica-Bold');
  FStandardFontNameMap.Add('Arial-BoldItalic', 'Helvetica-BoldOblique');
  FStandardFontNameMap.Add('Arial-BoldItalicMT', 'Helvetica-BoldOblique');
  FStandardFontNameMap.Add('Arial-BoldMT', 'Helvetica-Bold');
  FStandardFontNameMap.Add('Arial-Italic', 'Helvetica-Oblique');
  FStandardFontNameMap.Add('Arial-ItalicMT', 'Helvetica-Oblique');
  FStandardFontNameMap.Add('Helvetica-Compressed', 'Helvetica');
  FStandardFontNameMap.Add('ArialMT', 'Helvetica');
  FStandardFontNameMap.Add('CourierNew', 'Courier');
  FStandardFontNameMap.Add('CourierNew,Bold', 'Courier-Bold');
  FStandardFontNameMap.Add('CourierNew,BoldItalic', 'Courier-BoldOblique');
  FStandardFontNameMap.Add('CourierNew,Italic', 'Courier-Oblique');
  FStandardFontNameMap.Add('CourierNew-Bold', 'Courier-Bold');
  FStandardFontNameMap.Add('CourierNew-BoldItalic', 'Courier-BoldOblique');
  FStandardFontNameMap.Add('CourierNew-Italic', 'Courier-Oblique');
  FStandardFontNameMap.Add('CourierNewPS-BoldItalicMT', 'Courier-BoldOblique');
  FStandardFontNameMap.Add('CourierNewPS-BoldMT', 'Courier-Bold');
  FStandardFontNameMap.Add('CourierNewPS-ItalicMT', 'Courier-Oblique');
  FStandardFontNameMap.Add('CourierNewPSMT', 'Courier');
  FStandardFontNameMap.Add('Helvetica,Bold', 'Helvetica-Bold');
  FStandardFontNameMap.Add('Helvetica,BoldItalic', 'Helvetica-BoldOblique');
  FStandardFontNameMap.Add('Helvetica,Italic', 'Helvetica-Oblique');
  FStandardFontNameMap.Add('Helvetica-BoldItalic', 'Helvetica-BoldOblique');
  FStandardFontNameMap.Add('Helvetica-Italic', 'Helvetica-Oblique');
  FStandardFontNameMap.Add('Symbol,Bold', 'Symbol');
  FStandardFontNameMap.Add('Symbol,BoldItalic', 'Symbol');
  FStandardFontNameMap.Add('Symbol,Italic', 'Symbol');
  FStandardFontNameMap.Add('TimesNewRoman', 'Times-Roman');
  FStandardFontNameMap.Add('TimesNewRoman,Bold', 'Times-Bold');
  FStandardFontNameMap.Add('TimesNewRoman,BoldItalic', 'Times-BoldItalic');
  FStandardFontNameMap.Add('TimesNewRoman,Italic', 'Times-Italic');
  FStandardFontNameMap.Add('TimesNewRoman-Bold', 'Times-Bold');
  FStandardFontNameMap.Add('TimesNewRoman-BoldItalic', 'Times-BoldItalic');
  FStandardFontNameMap.Add('TimesNewRoman-Italic', 'Times-Italic');
  FStandardFontNameMap.Add('TimesNewRomanPS', 'Times-Roman');
  FStandardFontNameMap.Add('TimesNewRomanPS-Bold', 'Times-Bold');
  FStandardFontNameMap.Add('TimesNewRomanPS-BoldItalic', 'Times-BoldItalic');
  FStandardFontNameMap.Add('TimesNewRomanPS-BoldItalicMT', 'Times-BoldItalic');
  FStandardFontNameMap.Add('TimesNewRomanPS-BoldMT', 'Times-Bold');
  FStandardFontNameMap.Add('TimesNewRomanPS-Italic', 'Times-Italic');
  FStandardFontNameMap.Add('TimesNewRomanPS-ItalicMT', 'Times-Italic');
  FStandardFontNameMap.Add('TimesNewRomanPSMT', 'Times-Roman');
  FStandardFontNameMap.Add('TimesNewRomanPSMT,Bold', 'Times-Bold');
  FStandardFontNameMap.Add('TimesNewRomanPSMT,BoldItalic', 'Times-BoldItalic');
  FStandardFontNameMap.Add('TimesNewRomanPSMT,Italic', 'Times-Italic');
  FStandardFontNameMap.TrimExcess;
end;

destructor TdxPDFStandardFontDescriptor.Destroy;
begin
  FreeAndNil(FStandardFontNameMap);
  FreeAndNil(FPopulationProcDictionary);
  inherited Destroy;
end;

function TdxPDFStandardFontDescriptor.CreateDictionary(ARepository: TdxPDFCustomRepository;
  const AFontName: string): TdxPDFDictionary;
var
  AActualFontName: string;
  AProc: TPopulateStandardFontDescriptorProc;
begin
  Result := TdxPDFReaderDictionary.Create(ARepository as TdxPDFDocumentRepository);
  Result.Add(TdxPDFKeywords.TypeKey, TdxPDFKeywords.FontDescriptor);
  Result.Add(TdxPDFKeywords.FontName, AFontName);
  if not FStandardFontNameMap.TryGetValue(AFontName, AActualFontName) then
    AActualFontName := AFontName;
  if FPopulationProcDictionary.TryGetValue(AActualFontName, AProc) then
    AProc(Result)
  else
    FreeAndNil(Result);
end;

procedure TdxPDFStandardFontDescriptor.PopulateHelveticaObliqueFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.HelveticaFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffNonSymbolic) or Integer(ffItalic) or Integer(ffSmallCap));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-170, -225, 1116, 931), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, -12);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 718);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -207);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 718);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 523);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 88);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 76);
end;

procedure TdxPDFStandardFontDescriptor.PopulateCourierFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.CourierFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffFixedPitch) or Integer(ffSerif) or
    Integer(ffNonSymbolic) or Integer(ffSmallCap));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-23, -250, 715, 805), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 629);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -157);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 562);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 426);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 51);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 51);
end;

procedure TdxPDFStandardFontDescriptor.PopulateCourierBoldFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.CourierFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffFixedPitch) or Integer(ffSerif) or
    Integer(ffNonSymbolic) or Integer(ffSmallCap) or Integer(ffForceBold));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-113, -250, 749, 801), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 629);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -157);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 562);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 439);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 106);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 84);
end;

procedure TdxPDFStandardFontDescriptor.PopulateCourierBoldObliqueFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.CourierFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffFixedPitch) or Integer(ffSerif) or
    Integer(ffNonSymbolic) or Integer(ffItalic) or Integer(ffSmallCap) or Integer(ffForceBold));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-57, -250, 869, 801), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, -12);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 629);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -157);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 562);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 439);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 106);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 84);
end;

procedure TdxPDFStandardFontDescriptor.PopulateCourierObliqueFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.CourierFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffFixedPitch) or Integer(ffSerif) or
    Integer(ffNonSymbolic) or Integer(ffItalic) or Integer(ffSmallCap));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-27, -250, 849, 805), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, -12);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 629);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -157);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 562);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 426);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 51);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 51);
end;

procedure TdxPDFStandardFontDescriptor.PopulateHelveticaFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.HelveticaFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffNonSymbolic) or Integer(ffSmallCap));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-166, -225, 1000, 931), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 718);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -207);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 718);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 523);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 88);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 76);
end;

procedure TdxPDFStandardFontDescriptor.PopulateHelveticaBoldFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.HelveticaFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffNonSymbolic) or Integer(ffSmallCap) or Integer(ffForceBold));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-170, -228, 1003, 962), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 718);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -207);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 718);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 532);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 140);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 118);
end;

procedure TdxPDFStandardFontDescriptor.PopulateHelveticaBoldObliqueFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.HelveticaFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffNonSymbolic) or Integer(ffItalic) or
    Integer(ffSmallCap) or Integer(ffForceBold));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-174, -228, 1114, 962), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, -12);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 718);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -207);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 718);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 532);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 140);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 118);
end;

procedure TdxPDFStandardFontDescriptor.PopulateSymbolFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.SymbolFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffSymbolic));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-180, -293, 1090, 1010), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 85);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 92);
end;

procedure TdxPDFStandardFontDescriptor.PopulateTimesBoldFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.TimesFontFamilyName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffSerif) or Integer(ffNonSymbolic) or
    Integer(ffSmallCap) or Integer(ffForceBold));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-168, -218, 1000, 935), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 683);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -217);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 676);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 461);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 139);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 44);
end;

procedure TdxPDFStandardFontDescriptor.PopulateTimesBoldItalicFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.TimesFontFamilyName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffSerif) or Integer(ffNonSymbolic) or Integer(ffItalic) or
    Integer(ffSmallCap) or Integer(ffForceBold));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-200, -218, 996, 921), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, -15);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 683);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -217);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 669);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 462);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 121);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 42);
end;

procedure TdxPDFStandardFontDescriptor.PopulateTimesItalicFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.TimesFontFamilyName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffSerif) or Integer(ffNonSymbolic) or
    Integer(ffItalic) or Integer(ffSmallCap));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-169, -217, 1010, 883), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, -15.5);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 683);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -217);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 653);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 441);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 76);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 32);
end;

procedure TdxPDFStandardFontDescriptor.PopulateTimesNewRomanFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.TimesFontFamilyName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffSerif) or Integer(ffNonSymbolic) or Integer(ffSmallCap));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-168, -218, 1000, 898), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 683);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, -217);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 662);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 450);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 84);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 28);
end;

procedure TdxPDFStandardFontDescriptor.PopulateZapfDingbatsFontDescriptorDictionary(ADictionary: TdxPDFDictionary);
begin
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFamily, TdxPDFKeywords.ZapfDingbatsFontName);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorFlags, Integer(ffSymbolic));
  ADictionary.Add(TdxPDFKeywords.FontDescriptorBBox, dxRectF(-1, -143, 981, 820), False);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorItalicAngle, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorAscent, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorDescent, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorCapHeight, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorXHeight, 0);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemV, 90);
  ADictionary.Add(TdxPDFKeywords.FontDescriptorStemH, 28);
end;

{ TdxPDFType1FontCipher }

constructor TdxPDFType1FontCipher.Create(const AData: TBytes);
begin
  inherited Create;
  FData := AData;
  FR := InitialR;
  FCurrentPosition := 0;
  FEndPosition := Length(AData);
end;

constructor TdxPDFType1FontCipher.Create(const AData: TBytes; AStartPosition: Integer; ADataLength: Integer);
begin
  Create(AData);
  FEndPosition := AStartPosition + ADataLength;
  FCurrentPosition := AStartPosition;
end;

function TdxPDFType1FontCipher.GetSkipBytesCount: Integer;
begin
  Result := 0;
end;

function TdxPDFType1FontCipher.DecryptNextChar: SmallInt;
var
  C: SmallInt;
begin
  C := NextChar;
  if C >= 0 then
  begin
    Result := Byte(C xor (FR shr 8));
    FR := (C + FR) * C1 + C2;
  end
  else
    Result := C;
end;

function TdxPDFType1FontCipher.Decrypt: TBytes;
var
  ANextChar: SmallInt;
  ASkipBytesCount: Integer;
begin
  SetLength(Result, 0);
  ASkipBytesCount := SkipBytesCount;
  while True do
  begin
    ANextChar := DecryptNextChar;
    if ANextChar < 0 then
      Break
    else
      if ASkipBytesCount > 0 then
        Dec(ASkipBytesCount)
      else
        TdxPDFUtils.AddByte(Byte(ANextChar), Result);
  end;
end;

function TdxPDFType1FontCipher.NextByte: SmallInt;
begin
  if FCurrentPosition >= FEndPosition then
    Result := SmallInt(-1)
  else
  begin
    Result := FData[FCurrentPosition];
    Inc(FCurrentPosition);
  end;
end;

{ TdxPDFType1FontEexecCipher }

class function TdxPDFType1FontEexecCipher.IsASCIISymbol(C: Byte): Boolean;
begin
  Result := TdxPDFUtils.IsWhiteSpace(C) or TdxPDFUtils.IsHexDigit(C);
end;

class function TdxPDFType1FontEexecCipher.IsASCIICipher(const AData: TBytes; AStartPosition: Integer): Boolean;
var
  I, AIndex: Integer;
begin
  Result := IsASCIISymbol(AData[AStartPosition]);
  if Result then
  begin
    AIndex := AStartPosition + 1;
    for I := 1 to KindBytesCount - 1 do
    begin
      Result := IsASCIISymbol(AData[AIndex]);
      if not Result then
        Break;
      Inc(AIndex);
    end;
  end;
end;

class function TdxPDFType1FontEexecCipher.CreateCipher(const AData: TBytes;
  AStartPosition, ADataLength: Integer): TdxPDFType1FontEexecCipher;
begin
  if ADataLength >= KindBytesCount then
  begin
    if IsASCIICipher(AData, AStartPosition) then
      Result := TdxPDFType1FontEexecASCIICipher.Create(AData, AStartPosition, ADataLength)
    else
      Result := TdxPDFType1FontEexecBinaryCipher.Create(AData, AStartPosition, ADataLength);
  end
  else
    Result := nil;
end;

function TdxPDFType1FontEexecCipher.GetInitialR: Word;
begin
  Result := 55665;
end;

function TdxPDFType1FontEexecCipher.GetSkipBytesCount: Integer;
begin
  Result := KindBytesCount;
end;

{ TdxPDFType1FontEexecASCIICipher }

function TdxPDFType1FontEexecASCIICipher.NextChar: SmallInt;
var
  AHigh, ALow: SmallInt;
begin
  AHigh := ActualNextByte;
  ALow := ActualNextByte;
  if (AHigh < 0) or (ALow < 0) then
    Result := SmallInt(-1)
  else
    try
      Result := SmallInt(TdxPDFUtils.ByteToHexDigit(Byte(AHigh)) shl 4 + TdxPDFUtils.ByteToHexDigit(Byte(ALow)));
    except
      Result := -1;
    end;
end;

function TdxPDFType1FontEexecASCIICipher.ActualNextByte: SmallInt;
begin
  while True do
  begin
    Result := NextByte;
    if (Result < 0) or not TdxPDFUtils.IsWhiteSpace(Byte(Result)) then
      Exit(Result);
  end;
{$IFNDEF DELPHI104}
  Result := 0;
{$ENDIF}
end;

{ TdxPDFType1FontEexecBinaryCipher }

function TdxPDFType1FontEexecBinaryCipher.NextChar: SmallInt;
begin
  Result := NextByte;
end;

function TdxPDFType1FontEexecBinaryCipher.Encrypt: TBytes;
var
  AAdditionalBytesCount, I: Integer;
  ANextByte: SmallInt;
begin
  SetLength(Result, 0);
  Randomize;
  repeat
    R := InitialR;
    AAdditionalBytesCount := SkipBytesCount;
    for I := 0 to AAdditionalBytesCount - 1 do
      TdxPDFUtils.AddByte(DoEncrypt(Random(255)), Result);
  until not IsASCIICipher(Result, 0);

  while True do
  begin
    ANextByte := NextByte;
    if ANextByte < 0 then
      Exit;
    TdxPDFUtils.AddByte(DoEncrypt(ANextByte), Result);
  end;
end;

function TdxPDFType1FontEexecBinaryCipher.DoEncrypt(P: Byte): Byte;
var
  AR: Integer;
begin
  AR := R;
  Result := Byte((P xor (AR shr 8)));
  R := (Result + AR) * C1 + C2;
end;

{ TdxCompactFontFormatDictIndexOperatorFactory }

constructor TdxCompactFontFormatDictIndexOperatorFactory.Create;
begin
  inherited Create;
  FDictionary := TDictionary<Integer, TdxCompactFontFormatDictIndexOperatorClass>.Create;
end;

destructor TdxCompactFontFormatDictIndexOperatorFactory.Destroy;
begin
  FreeANdNIl(FDictionary);
  inherited Destroy;
end;

function TdxCompactFontFormatDictIndexOperatorFactory.GetOperatorClass(ACode: Byte): TdxCompactFontFormatDictIndexOperatorClass;
begin
  if not FDictionary.TryGetValue(ACode, Result) then
    Result := nil;
end;

procedure TdxCompactFontFormatDictIndexOperatorFactory.RegisterOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass);
begin
//  if not FDictionary.ContainsKey(AClass.Code) then
    FDictionary.Add(AClass.Code, AClass);
end;

procedure TdxCompactFontFormatDictIndexOperatorFactory.UnregisterOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass);
begin
  FDictionary.Remove(AClass.Code);
end;

{ TdxCompactFontFormatNibbleValueConstructor }

constructor TdxCompactFontFormatNibbleValueConstructor.Create;
begin
  inherited Create;
  FStringBuilder := TStringBuilder.Create;
end;

destructor TdxCompactFontFormatNibbleValueConstructor.Destroy;
begin
  FreeAndNil(FStringBuilder);
  inherited Destroy;
end;

function TdxCompactFontFormatNibbleValueConstructor.AddNibble(ANibble: Integer): Boolean;
var
  S: string;
begin
  Result := False;
  case ANibble of
    10:
      S := '.';
    11:
      S := 'E';
    12:
      S := 'E-';
    13:
      TdxPDFUtils.RaiseException;
    14:
      S := '-';
    15:
      Result := True;
  else
    S := IntToStr(ANibble);
  end;
  FStringBuilder.Append(S);
end;

function TdxCompactFontFormatNibbleValueConstructor.GetResult: Double;
begin
  Result := dxStrToFloat(FStringBuilder.ToString);
end;

{ TdxCompactFontFormatDictIndexParser }

constructor TdxCompactFontFormatDictIndexParser.Create(const AData: TBytes);
begin
  inherited Create;
  FData := AData;
end;

function TdxCompactFontFormatDictIndexParser.ParseOperators: TdxCompactFontFormatDictIndexOperatorList;
var
  AOperands: TDoubleDynArray;
  AOperand: Integer;
  AValue: Byte;
  ANibbleValueConstructor: TdxCompactFontFormatNibbleValueConstructor;
begin
  Result := TdxCompactFontFormatDictIndexOperatorList.Create;
  SetLength(AOperands, 0);
  while HasMoreData do
  begin
    AValue := GetNextByte;
    if AValue <= 27 then
    begin
      Result.Add(ParseOperator(AValue, AOperands));
      SetLength(AOperands, 0);
    end
    else
      if AValue = 28 then
        TdxPDFUtils.AddValue(SmallInt(GetNextByte shl 8 + GetNextByte), AOperands)
      else
        if AValue = 29 then
        begin
          AOperand := GetNextByte shl 24;
          Inc(AOperand, GetNextByte shl 16);
          Inc(AOperand, GetNextByte shl 8);
          Inc(AOperand, GetNextByte);
          TdxPDFUtils.AddValue(AOperand, AOperands);
        end
        else
          if AValue = 30 then
          begin
            ANibbleValueConstructor := TdxCompactFontFormatNibbleValueConstructor.Create;
            try
              while HasMoreData do
              begin
                AValue := GetNextByte;
                if ANibbleValueConstructor.AddNibble(AValue shr 4) or ANibbleValueConstructor.AddNibble(AValue and $0F) then
                  Break;
              end;
              TdxPDFUtils.AddValue(ANibbleValueConstructor.Result, AOperands);
            finally
              ANibbleValueConstructor.Free;
            end;
          end
          else
            if InRange(AValue, 32, 246) then
              TdxPDFUtils.AddValue(AValue - 139, AOperands)
            else
              if InRange(AValue, 247, 250) then
                TdxPDFUtils.AddValue((AValue - 247) * 256 + GetNextByte + 108, AOperands)
              else
                if InRange(AValue, 251, 254) then
                  TdxPDFUtils.AddValue((251 - AValue) * 256 - GetNextByte - 108, AOperands);
  end;
end;

function TdxCompactFontFormatDictIndexParser.GetNextByte: Byte;
begin
  if HasMoreData then
  begin
    Result := FData[FCurrentPosition];
    Inc(FCurrentPosition);
  end
  else
    Result := 0;
end;

function TdxCompactFontFormatDictIndexParser.HasMoreData: Boolean;
begin
  Result := FCurrentPosition < Length(FData);
end;

function TdxCompactFontFormatDictIndexParser.ParseOperator(AValue: Byte; AOperands: TDoubleDynArray): TdxCompactFontFormatDictIndexOperator;
var
  AClass: TdxCompactFontFormatDictIndexOperatorClass;
begin
  AClass := nil;
  if AValue = TdxCompactFontFormatDictIndexTwoByteOperator.Marker then
  begin
    if HasMoreData then
      AClass := dxCompactFontFormatDictIndexTwoByteOperatorFactory.GetOperatorClass(GetNextByte);
  end
  else
    AClass := dxCompactFontFormatDictIndexOneByteOperatorFactory.GetOperatorClass(AValue);
  if AClass <> nil then
    Result := CreateOperator(AClass, AOperands)
  else
    Result := nil;
end;

{ TdxCompactFontFormatTopDictIndexParser }

constructor TdxCompactFontFormatTopDictIndexParser.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  const AData: TBytes);
begin
  inherited Create(AData);
  FStringIndex := AStringIndex;
end;

class function TdxCompactFontFormatTopDictIndexParser.Parse(AMajorVersion, AMinorVersion: Byte;
  const AFontName: string; AStringIndex: TdxCompactFontFormatStringIndex; AGlobalSubrs: TdxPDFBytesList;
  AStream: TdxFontFileStream; const AObjectData: TBytes): TdxType1FontCompactFontProgram;
var
  AParser: TdxCompactFontFormatTopDictIndexParser;
  AFDSelectOperator: TdxCompactFontFormatDictIndexFDSelectOperator;
  ACharsetOperator: TdxCompactFontFormatDictIndexCharsetOperator;
  AOperator: TdxCompactFontFormatDictIndexOperator;
  AOperators: TList<TdxCompactFontFormatDictIndexOperator>;
begin
  AParser := TdxCompactFontFormatTopDictIndexParser.Create(AStringIndex, AObjectData);
  try
    ACharsetOperator := nil;
    AFDSelectOperator := nil;
    AOperators := AParser.ParseOperators;
    try
      if (AOperators.Count > 0) and (AOperators[0] is TdxCompactFontFormatDictIndexROSOperator) then
        Result := TdxType1FontCompactCIDFontProgram.Create(AMajorVersion, AMinorVersion, AFontName, AStringIndex, AGlobalSubrs)
      else
        Result := TdxType1FontCompactFontProgram.Create(AMajorVersion, AMinorVersion, AFontName, AStringIndex, AGlobalSubrs);
      for AOperator in AOperators do
        if AOperator <> nil then
        begin
          if not (AOperator is TdxCompactFontFormatDictIndexCharsetOperator) then
          begin
            if not (AOperator is TdxCompactFontFormatDictIndexFDSelectOperator) then
              AOperator.Execute(AStream, Result)
            else
              AFDSelectOperator := TdxCompactFontFormatDictIndexFDSelectOperator(AOperator);
          end
          else
            ACharsetOperator := TdxCompactFontFormatDictIndexCharsetOperator(AOperator);
        end;
      if ACharsetOperator <> nil then
        ACharsetOperator.Execute(AStream, Result);
      if AFDSelectOperator <> nil then
        AFDSelectOperator.Execute(AStream, Result);
    finally
      AOperators.Free;
    end;
  finally
    AParser.Free;
  end;
end;

class function TdxCompactFontFormatTopDictIndexParser.Parse(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex; const AObjectData: TBytes): TdxType1FontCIDGlyphGroupData;
var
  AOperator: TdxCompactFontFormatDictIndexOperator;
  AOperators: TdxCompactFontFormatDictIndexOperatorList;
  AParser: TdxCompactFontFormatTopDictIndexParser;
begin
  Result := TdxType1FontCIDGlyphGroupData.Create;
  AParser := TdxCompactFontFormatTopDictIndexParser.Create(AStringIndex, AObjectData);
  try
    AOperators := AParser.ParseOperators;
    if AOperators <> nil then
      try
        try
          for AOperator in AOperators do
            AOperator.Execute(AStream, Result);
        except
          on EdxPDFAbortException do;
          on EdxTestException do;
          else
            raise;
        end;
      finally
        AOperators.Free;
      end;
  finally
    AParser.Free;
  end;
end;

function TdxCompactFontFormatTopDictIndexParser.CreateOperator(AClass: TdxCompactFontFormatDictIndexOperatorClass;
  AOperands: TDoubleDynArray): TdxCompactFontFormatDictIndexOperator;
begin
  Result := AClass.Create(FStringIndex, AOperands);
end;

{ TdxPDFType1FontDescriptor }

function TdxPDFType1FontDescriptor.GetSubtypeName: string;
begin
  Result := TdxPDFKeywords.Type1C;
end;

procedure TdxPDFType1FontDescriptor.ReadFontFile(ADictionary: TdxPDFReaderDictionary);
var
  AStream: TdxPDFStream;
begin
  FontFileData := TdxPDFType1FontFileData.Parse(ADictionary);
  if FontFileData.IsNull then
  begin
    AStream := ADictionary.GetStream(TdxPDFKeywords.FontFile3);
    if AStream <> nil then
    begin
      OpenTypeFontFileData := GetOpenTypeFontFileData(ADictionary, True);
      if Length(OpenTypeFontFileData) > 0 then
        CompactFontFileData := TdxFontFileHelper.GetCFFData(OpenTypeFontFileData)
      else
        CompactFontFileData := TdxFontFileHelper.GetValidCFFData(AStream.UncompressedData);
    end;
  end;
end;

procedure TdxPDFType1FontDescriptor.WriteFontFile(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  if not FontFileData.IsNull then
    ADictionary.AddReference(TdxPDFKeywords.FontFile, WriteFontFileData(AHelper, FontFileData))
  else
    inherited WriteFontFile(AHelper, ADictionary);
end;

{ TdxPDFType1Font }

class function TdxPDFType1Font.GetSubTypeName: string;
begin
  Result := TdxPDFKeywords.FontType1;
end;

function TdxPDFType1Font.CreateFontProgramFacade: TObject;
begin
  if FontDescriptor.CompactFontFileData <> nil then
    Result := TdxPDFCFFFontProgramFacade.CreateForSimpleFont(Self, FontDescriptor.CompactFontFileData)
  else
    if not FontDescriptor.FontFileData.IsNull then
      Result := TdxPDFType1FontProgramFacade.CreateForSimpleFont(Self, FontDescriptor.FontFileData)
    else
      Result := TdxPDFNonEmbeddedFontProgramFacade.CreateForSimpleFont(Self);
end;

function TdxPDFType1Font.GetFontDescriptorClass: TdxPDFCustomFontDescriptorClass;
begin
  Result := TdxPDFType1FontDescriptor;
end;

function TdxPDFType1Font.IsCourierFont: Boolean;
begin
  Result :=
    (BaseFont = TdxPDFKeywords.CourierFontName) or
    (BaseFont = TdxPDFKeywords.CourierBoldFontName) or
    (BaseFont = TdxPDFKeywords.CourierObliqueFontName) or
    (BaseFont = TdxPDFKeywords.CourierBoldObliqueFontName) or
    (BaseFont = TdxPDFKeywords.CourierNewFontName);
end;

function TdxPDFType1Font.NeedWriteFontDescriptor: Boolean;
begin
  Result := inherited NeedWriteFontDescriptor and not FUseDefaultFontDescriptor;
end;

procedure TdxPDFType1Font.ReadFontDescriptor(ADictionary: TdxPDFReaderDictionary);
var
  AFontDescriptorDictionary: TdxPDFReaderDictionary;
begin
  FUseDefaultFontDescriptor := ADictionary = nil;
  if FUseDefaultFontDescriptor then
    AFontDescriptorDictionary := dxPDFStandardFontDescriptor.CreateDictionary(Repository, BaseFont) as TdxPDFReaderDictionary
  else
    AFontDescriptorDictionary := ADictionary;
  try
    inherited ReadFontDescriptor(AFontDescriptorDictionary);
  finally
    if FUseDefaultFontDescriptor then
      dxPDFFreeObject(AFontDescriptorDictionary);
  end;
end;

function TdxPDFType1Font.GetLineSpacingForMetrics: Double;
begin
  if (FontDescriptor <> nil) and not IsZero(FontDescriptor.FontBBox.Height) then
    Result := -FontDescriptor.FontBBox.Height + FontDescriptor.Leading
  else
    Result := inherited GetLineSpacingForMetrics;
end;

function TdxPDFType1Font.GetFontDescriptor: TdxPDFType1FontDescriptor;
begin
  Result := FFontDescriptor as TdxPDFType1FontDescriptor;
end;

{ TdxPDFMMType1Font }

class function TdxPDFMMType1Font.GetSubTypeName: string;
begin
  Result := TdxPDFKeywords.FontMMType1;
end;

{ TdxType1FontGlyphZone }

class function TdxType1FontGlyphZone.Create(ABotom, ATop: Double): TdxType1FontGlyphZone;
begin
  Result.Bottom := ABotom;
  Result.Top := ATop;
end;

{ TdxType1SupplementDataEntry }

class function TdxType1SupplementDataEntry.Create(AGID: SmallInt; ACode: Byte): TdxType1SupplementDataEntry;
begin
  Result.Code := ACode;
  Result.GID := AGID;
end;

{ TdxType1FontPrivateData }

constructor TdxType1FontPrivateData.Create;
begin
  inherited Create;
  FBlueScale := DefaultBlueScale;
  FBlueShift := DefaultBlueShift;
  FExpansionFactor := DefaultExpansionFactor;
  FStdHW := dxPDFInvalidValue;
  FStdVW := dxPDFInvalidValue;
  FForceBoldThreshold := dxPDFInvalidValue;
end;

class function TdxType1FontPrivateData.IsInvalidStemSnap(const AStemSnap: TDoubleDynArray): Boolean;
begin
  Result := (AStemSnap <> nil) and (Length(AStemSnap) > 12);
end;

class function TdxType1FontPrivateData.IsInvalidBlueValues(const ABlueValues: TdxType1FontGlyphZones): Boolean;
begin
  Result := (ABlueValues <> nil) and (Length(ABlueValues) > 7);
end;

class function TdxType1FontPrivateData.IsInvalidOtherBlues(const AOtherBlues: TdxType1FontGlyphZones): Boolean;
begin
  Result := (AOtherBlues <> nil) and (Length(AOtherBlues) > 5);
end;

procedure TdxType1FontPrivateData.Validate;
begin
  if (IsInvalidBlueValues(FBlueValues)) or (IsInvalidOtherBlues(FOtherBlues)) or (IsInvalidBlueValues(FFamilyBlues)) or
    (IsInvalidOtherBlues(FFamilyOtherBlues)) or (IsInvalidStemSnap(FStemSnapH)) or (IsInvalidStemSnap(FStemSnapV)) then
    TdxPDFUtils.RaiseException;
end;

{ TdxType1FontCompactFontPrivateData }

constructor TdxType1FontCompactFontPrivateData.Create;
begin
  inherited Create;
  FLanguageGroup := DefaultLanguageGroup;
  FDefaultWidthX := DefaultDefaultWidthX;
  FNominalWidthX := DefaultNominalWidthX;
  BlueFuzz := DefaultBlueFuzz;
  FSubrs := TdxPDFBytesList.Create;
  Validate;
end;

destructor TdxType1FontCompactFontPrivateData.Destroy;
begin
  FreeAndNil(FSubrs);
  inherited Destroy;
end;

procedure TdxType1FontCompactFontPrivateData.SetSubrs(const AValue: TdxPDFBytesList);
begin
  FSubrs.Clear;
  FSubrs.AddRange(AValue);
end;

{ TdxType1FontInfo }

constructor TdxType1FontInfo.Create;
begin
  inherited Create;
  ItalicAngle := DefaultItalicAngle;
  UnderlinePosition := DefaultUnderlinePosition;
  UnderlineThickness := DefaultUnderlineThickness;
end;

class function TdxType1FontInfo.DefaultItalicAngle: Integer;
begin
  Result := 0;
end;

class function TdxType1FontInfo.DefaultStrokeWidth: Integer;
begin
  Result := 0;
end;

class function TdxType1FontInfo.DefaultUnderlinePosition: Integer;
begin
  Result := -100;
end;

class function TdxType1FontInfo.DefaultUnderlineThickness: Integer;
begin
  Result := 50;
end;

class function TdxType1FontInfo.DefaultUniqueID: Integer;
begin
  Result := 0;
end;

procedure TdxType1FontInfo.Read(ADictionary: TdxPDFPostScriptDictionary);
begin
  Version := ADictionary.GetString('version');
  Notice := ADictionary.GetString('Notice');
  Copyright := ADictionary.GetString('Copyright');
  FamilyName := ADictionary.GetString('FamilyName');
  FullName := ADictionary.GetString('FullName');
  BaseFontName := ADictionary.GetString('BaseFontName');
  Weight := ADictionary.GetString('Weight');
  ItalicAngle := ADictionary.GetDouble('ItalicAngle');
  UnderlinePosition := ADictionary.GetDouble('UnderlinePosition');
  UnderlineThickness := ADictionary.GetDouble('UnderlineThickness');
  Em := ADictionary.GetDouble('em');
  Ascent := ADictionary.GetDouble('ascent');
  Descent := ADictionary.GetDouble('descent');
  FSType := ADictionary.GetInteger('FSType', dxPDFInvalidValue);
  IsFixedPitch := ADictionary.GetBoolean('isFixedPitch');
end;

{ TdxPDFType1FontClassicFontInfo }

procedure TdxPDFType1FontClassicFontInfo.Read(ADictionary: TdxPDFPostScriptDictionary);
var
  I: Integer;
  AEntry: TdxPDFPostScriptDictionaryEntry;
begin
  for I := 0 to ADictionary.Count - 1 do
  begin
    AEntry := ADictionary[I];
    if AEntry.Key = VersionDictionaryKey then
      Version := TdxPDFUtils.ConvertToStr(AEntry.Value);
    if AEntry.Key = NoticeDictionaryKey then
      Notice := TdxPDFUtils.ConvertToStr(AEntry.Value);
    if AEntry.Key = CopyrightDictionaryKey then
      Copyright := TdxPDFUtils.ConvertToStr(AEntry.Value);
    if AEntry.Key = FamilyNameDictionaryKey then
      FamilyName := TdxPDFUtils.ConvertToStr(AEntry.Value);
    if AEntry.Key = FullNameDictionaryKey then
      FullName := TdxPDFUtils.ConvertToStr(AEntry.Value);
    if AEntry.Key = BaseFontNameDictionaryKey then
      BaseFontName := TdxPDFUtils.ConvertToStr(AEntry.Value);
    if AEntry.Key = WeightDictionaryKey then
      Weight := TdxPDFUtils.ConvertToStr(AEntry.Value);
    if AEntry.Key = ItalicAngleDictionaryKey then
      ItalicAngle := TdxPDFUtils.ConvertToDouble(AEntry.Value, dxPDFInvalidValue);
    if AEntry.Key = UnderlinePositionDictionaryKey then
      UnderlinePosition := TdxPDFUtils.ConvertToDouble(AEntry.Value, dxPDFInvalidValue);
    if AEntry.Key = UnderlineThicknessDictionaryKey then
      UnderlineThickness := TdxPDFUtils.ConvertToDouble(AEntry.Value, dxPDFInvalidValue);
    if AEntry.Key = EmDictionaryKey then
      Em := TdxPDFUtils.ConvertToDouble(AEntry.Value, dxPDFInvalidValue);
    if AEntry.Key = AscentDictionaryKey then
      Ascent := TdxPDFUtils.ConvertToDouble(AEntry.Value, dxPDFInvalidValue);
    if AEntry.Key = DescentDictionaryKey then
      Descent := TdxPDFUtils.ConvertToDouble(AEntry.Value, dxPDFInvalidValue);
    if AEntry.Key = FSTypeDictionaryKey then
      FSType := TdxPDFUtils.ConvertToInt(AEntry.Value, dxPDFInvalidValue)
    else
      FSType := dxPDFInvalidValue;
    if AEntry.Key = IsFixedPitchDictionaryKey then
      IsFixedPitch := TdxPDFUtils.ConvertToBoolean(AEntry.Value, IsFixedPitch);
  end;
end;

function TdxPDFType1FontClassicFontInfo.Serialize: string;
var
  ABuilder: TStringBuilder;
begin
  ABuilder := TdxStringBuilderManager.Get;
  try
    ABuilder.Append('11 dict dup begin'#10);
    SerializeString(ABuilder, VersionDictionaryKey, Version);
    SerializeString(ABuilder, NoticeDictionaryKey, Notice);
    SerializeString(ABuilder, CopyrightDictionaryKey, Copyright);
    SerializeString(ABuilder, FullNameDictionaryKey, FullName);
    SerializeString(ABuilder, FamilyNameDictionaryKey, FamilyName);
    SerializeString(ABuilder, BaseFontNameDictionaryKey, BaseFontName);
    SerializeString(ABuilder, WeightDictionaryKey, Weight);
    SerializeDouble(ABuilder, ItalicAngleDictionaryKey, ItalicAngle);
    if IsFixedPitch then
      ABuilder.Append(Format('/%s %s def'#10, ['isFixedPitch', 'true']))
    else
      ABuilder.Append(Format('/%s %s def'#10, ['isFixedPitch', 'false']));
    SerializeDouble(ABuilder, UnderlinePositionDictionaryKey, UnderlinePosition);
    SerializeDouble(ABuilder, UnderlineThicknessDictionaryKey, UnderlineThickness);
    OptionalSerializeDouble(ABuilder, EmDictionaryKey, Em);
    OptionalSerializeDouble(ABuilder, AscentDictionaryKey, Ascent);
    OptionalSerializeDouble(ABuilder, DescentDictionaryKey, Descent);
    if TdxPDFUtils.IsIntegerValid(FSType) then
      ABuilder.Append(Format('/%s %d def'#10, [FSTypeDictionaryKey, FSType]));
    ABuilder.Append('end');
    Result := ABuilder.ToString;
  finally
    TdxStringBuilderManager.Release(ABuilder);
  end;
end;

procedure TdxPDFType1FontClassicFontInfo.OptionalSerializeDouble(ABuilder: TStringBuilder; const AKey: string; AValue: Double);
begin
  if AValue <> 0 then
    SerializeDouble(ABuilder, AKey, AValue);
end;

procedure TdxPDFType1FontClassicFontInfo.SerializeDouble(ABuilder: TStringBuilder; const AKey: string; AValue: Double);
begin
  ABuilder.Append(Format('/%s %s def'#10, [AKey, DoubleAsString(AValue, 3, 0)]));
end;

procedure TdxPDFType1FontClassicFontInfo.SerializeString(ABuilder: TStringBuilder; const AKey, AValue: string);
begin
  if AValue <> '' then
    ABuilder.Append(Format('/%s (%s) readonly def'#10, [AKey, AValue]));
end;

{ TdxType1FontEncoding }

function TdxType1FontEncoding.GetOffset: Integer;
begin
  Result := 0;
end;

function TdxType1FontEncoding.IsDefault: Boolean;
begin
  Result := False;
end;

{ TdxType1FontPredefinedEncoding }

constructor TdxType1FontPredefinedEncoding.Create(AID: TdxType1FontPredefinedEncodingID);
begin
  inherited Create;
  FID := AID;
  FStandardEncoding := TdxFontFileStandardEncoding.Create;
  FExpertEncoding := TdxPDFByteStringDictionary.Create;
  InitializeExpertEncoding;
end;

destructor TdxType1FontPredefinedEncoding.Destroy;
begin
  FreeAndNil(FExpertEncoding);
  FreeAndNil(FStandardEncoding);
  inherited Destroy;
end;

function TdxType1FontPredefinedEncoding.GetCodeToGIDMapping(ACharset: TdxType1FontCustomCharset;
  AStringIndex: TdxCompactFontFormatStringIndex): TSmallIntDynArray;
var
  AGid: SmallInt;
  AMap: TdxPDFByteStringDictionary;
  APair: TPair<Byte, string>;
  ASidToGidMapping: TdxPDFSmallIntegerDictionary;
begin
  SetLength(Result, 256);
  ASidToGidMapping := ACharset.SidToGidMapping;
  if FID = peExpertEncoding then
    AMap := FExpertEncoding
  else
    AMap := FStandardEncoding.Dictionary;
  for APair in AMap do
  begin
    if ASidToGidMapping.TryGetValue(AStringIndex.GetSID(APair.Value), AGid) then
      Result[APair.Key] := AGid;
  end;
end;

function TdxType1FontPredefinedEncoding.GetDataLength: Integer;
begin
  Result := 0;
end;

function TdxType1FontPredefinedEncoding.GetOffset: Integer;
begin
  Result := IfThen(FID = peExpertEncoding, 1, 0);
end;

function TdxType1FontPredefinedEncoding.IsDefault: Boolean;
begin
  Result := FID = peStandardEncoding;
end;

procedure TdxType1FontPredefinedEncoding.InitializeExpertEncoding;
begin
  FExpertEncoding.Add(32, 'space');
  FExpertEncoding.Add(33, 'exclamsmall');
  FExpertEncoding.Add(34, 'Hungarumlautsmall');
  FExpertEncoding.Add(36, 'dollaroldstyle');
  FExpertEncoding.Add(37, 'dollarsuperior');
  FExpertEncoding.Add(38, 'ampersandsmall');
  FExpertEncoding.Add(39, 'Acutesmall');
  FExpertEncoding.Add(40, 'parenleftsuperior');
  FExpertEncoding.Add(41, 'parenrightsuperior');
  FExpertEncoding.Add(42, 'twodotenleader');
  FExpertEncoding.Add(43, 'onedotenleader');
  FExpertEncoding.Add(44, 'comma');
  FExpertEncoding.Add(45, 'hyphen');
  FExpertEncoding.Add(46, 'period');
  FExpertEncoding.Add(47, 'fraction');
  FExpertEncoding.Add(48, 'zerooldstyle');
  FExpertEncoding.Add(49, 'oneoldstyle');
  FExpertEncoding.Add(50, 'twooldstyle');
  FExpertEncoding.Add(51, 'threeoldstyle');
  FExpertEncoding.Add(52, 'fouroldstyle');
  FExpertEncoding.Add(53, 'fiveoldstyle');
  FExpertEncoding.Add(54, 'sixoldstyle');
  FExpertEncoding.Add(55, 'sevenoldstyle');
  FExpertEncoding.Add(56, 'eightoldstyle');
  FExpertEncoding.Add(57, 'nineoldstyle');
  FExpertEncoding.Add(58, 'colon');
  FExpertEncoding.Add(59, 'semicolon');
  FExpertEncoding.Add(60, 'commasuperior');
  FExpertEncoding.Add(61, 'threequartersemdash');
  FExpertEncoding.Add(62, 'periodsuperior');
  FExpertEncoding.Add(63, 'questionsmall');
  FExpertEncoding.Add(65, 'asuperior');
  FExpertEncoding.Add(66, 'bsuperior');
  FExpertEncoding.Add(67, 'centsuperior');
  FExpertEncoding.Add(68, 'dsuperior');
  FExpertEncoding.Add(69, 'esuperior');
  FExpertEncoding.Add(73, 'isuperior');
  FExpertEncoding.Add(76, 'lsuperior');
  FExpertEncoding.Add(77, 'msuperior');
  FExpertEncoding.Add(78, 'nsuperior');
  FExpertEncoding.Add(79, 'osuperior');
  FExpertEncoding.Add(82, 'rsuperior');
  FExpertEncoding.Add(83, 'ssuperior');
  FExpertEncoding.Add(84, 'tsuperior');
  FExpertEncoding.Add(86, 'ff');
  FExpertEncoding.Add(87, 'fi');
  FExpertEncoding.Add(88, 'fl');
  FExpertEncoding.Add(89, 'ffi');
  FExpertEncoding.Add(90, 'ffl');
  FExpertEncoding.Add(91, 'parenleftinferior');
  FExpertEncoding.Add(93, 'parenrightinferior');
  FExpertEncoding.Add(94, 'Circumflexsmall');
  FExpertEncoding.Add(95, 'hyphensuperior');
  FExpertEncoding.Add(96, 'Gravesmall');
  FExpertEncoding.Add(97, 'Asmall');
  FExpertEncoding.Add(98, 'Bsmall');
  FExpertEncoding.Add(99, 'Csmall');
  FExpertEncoding.Add(100, 'Dsmall');
  FExpertEncoding.Add(101, 'Esmall');
  FExpertEncoding.Add(102, 'Fsmall');
  FExpertEncoding.Add(103, 'Gsmall');
  FExpertEncoding.Add(104, 'Hsmall');
  FExpertEncoding.Add(105, 'Ismall');
  FExpertEncoding.Add(106, 'Jsmall');
  FExpertEncoding.Add(107, 'Ksmall');
  FExpertEncoding.Add(108, 'Lsmall');
  FExpertEncoding.Add(109, 'Msmall');
  FExpertEncoding.Add(110, 'Nsmall');
  FExpertEncoding.Add(111, 'Osmall');
  FExpertEncoding.Add(112, 'Psmall');
  FExpertEncoding.Add(113, 'Qsmall');
  FExpertEncoding.Add(114, 'Rsmall');
  FExpertEncoding.Add(115, 'Ssmall');
  FExpertEncoding.Add(116, 'Tsmall');
  FExpertEncoding.Add(117, 'Usmall');
  FExpertEncoding.Add(118, 'Vsmall');
  FExpertEncoding.Add(119, 'Wsmall');
  FExpertEncoding.Add(120, 'Xsmall');
  FExpertEncoding.Add(121, 'Ysmall');
  FExpertEncoding.Add(122, 'Zsmall');
  FExpertEncoding.Add(123, 'colonmonetary');
  FExpertEncoding.Add(124, 'onefitted');
  FExpertEncoding.Add(125, 'rupiah');
  FExpertEncoding.Add(126, 'Tildesmall');
  FExpertEncoding.Add(161, 'exclamdownsmall');
  FExpertEncoding.Add(162, 'centoldstyle');
  FExpertEncoding.Add(163, 'Lslashsmall');
  FExpertEncoding.Add(166, 'Scaronsmall');
  FExpertEncoding.Add(167, 'Zcaronsmall');
  FExpertEncoding.Add(168, 'Dieresissmall');
  FExpertEncoding.Add(169, 'Brevesmall');
  FExpertEncoding.Add(170, 'Caronsmall');
  FExpertEncoding.Add(172, 'Dotaccentsmall');
  FExpertEncoding.Add(175, 'Macronsmall');
  FExpertEncoding.Add(178, 'figuredash');
  FExpertEncoding.Add(179, 'hypheninferior');
  FExpertEncoding.Add(182, 'Ogoneksmall');
  FExpertEncoding.Add(183, 'Ringsmall');
  FExpertEncoding.Add(184, 'Cedillasmall');
  FExpertEncoding.Add(188, 'onequarter');
  FExpertEncoding.Add(189, 'onehalf');
  FExpertEncoding.Add(190, 'threequarters');
  FExpertEncoding.Add(191, 'questiondownsmall');
  FExpertEncoding.Add(192, 'oneeighth');
  FExpertEncoding.Add(193, 'threeeighths');
  FExpertEncoding.Add(194, 'fiveeighths');
  FExpertEncoding.Add(195, 'seveneighths');
  FExpertEncoding.Add(196, 'onethird');
  FExpertEncoding.Add(197, 'twothirds');
  FExpertEncoding.Add(200, 'zerosuperior');
  FExpertEncoding.Add(201, 'onesuperior');
  FExpertEncoding.Add(202, 'twosuperior');
  FExpertEncoding.Add(203, 'threesuperior');
  FExpertEncoding.Add(204, 'foursuperior');
  FExpertEncoding.Add(205, 'fivesuperior');
  FExpertEncoding.Add(206, 'sixsuperior');
  FExpertEncoding.Add(207, 'sevensuperior');
  FExpertEncoding.Add(208, 'eightsuperior');
  FExpertEncoding.Add(209, 'ninesuperior');
  FExpertEncoding.Add(210, 'zeroinferior');
  FExpertEncoding.Add(211, 'oneinferior');
  FExpertEncoding.Add(212, 'twoinferior');
  FExpertEncoding.Add(213, 'threeinferior');
  FExpertEncoding.Add(214, 'fourinferior');
  FExpertEncoding.Add(215, 'fiveinferior');
  FExpertEncoding.Add(216, 'sixinferior');
  FExpertEncoding.Add(217, 'seveninferior');
  FExpertEncoding.Add(218, 'eightinferior');
  FExpertEncoding.Add(219, 'nineinferior');
  FExpertEncoding.Add(220, 'centinferior');
  FExpertEncoding.Add(221, 'dollarinferior');
  FExpertEncoding.Add(222, 'periodinferior');
  FExpertEncoding.Add(223, 'commainferior');
  FExpertEncoding.Add(224, 'Agravesmall');
  FExpertEncoding.Add(225, 'Aacutesmall');
  FExpertEncoding.Add(226, 'Acircumflexsmall');
  FExpertEncoding.Add(227, 'Atildesmall');
  FExpertEncoding.Add(228, 'Adieresissmall');
  FExpertEncoding.Add(229, 'Aringsmall');
  FExpertEncoding.Add(230, 'AEsmall');
  FExpertEncoding.Add(231, 'Ccedillasmall');
  FExpertEncoding.Add(232, 'Egravesmall');
  FExpertEncoding.Add(233, 'Eacutesmall');
  FExpertEncoding.Add(234, 'Ecircumflexsmall');
  FExpertEncoding.Add(235, 'Edieresissmall');
  FExpertEncoding.Add(236, 'Igravesmall');
  FExpertEncoding.Add(237, 'Iacutesmall');
  FExpertEncoding.Add(238, 'Icircumflexsmall');
  FExpertEncoding.Add(239, 'Idieresissmall');
  FExpertEncoding.Add(240, 'Ethsmall');
  FExpertEncoding.Add(241, 'Ntildesmall');
  FExpertEncoding.Add(242, 'Ogravesmall');
  FExpertEncoding.Add(243, 'Oacutesmall');
  FExpertEncoding.Add(244, 'Ocircumflexsmall');
  FExpertEncoding.Add(245, 'Otildesmall');
  FExpertEncoding.Add(246, 'Odieresissmall');
  FExpertEncoding.Add(247, 'OEsmall');
  FExpertEncoding.Add(248, 'Oslashsmall');
  FExpertEncoding.Add(249, 'Ugravesmall');
  FExpertEncoding.Add(250, 'Uacutesmall');
  FExpertEncoding.Add(251, 'Ucircumflexsmall');
  FExpertEncoding.Add(252, 'Udieresissmall');
  FExpertEncoding.Add(253, 'Yacutesmall');
  FExpertEncoding.Add(254, 'Thornsmall');
  FExpertEncoding.Add(255, 'Ydieresissmall');
  FExpertEncoding.TrimExcess;
end;

{ TdxType1FontCustomEncoding.TEntry }

constructor TdxType1FontCustomEncoding.Create(AStream: TdxFontFileStream);
begin
  inherited Create;
end;

class function TdxType1FontCustomEncoding.Parse(AStream: TdxFontFileStream): TdxType1FontCustomEncoding;
var
  AID: Byte;
begin
  AID := AStream.ReadByte;
  case AID and IDMask of
    0:
      Result := TdxType1FontArrayEncoding.Create(AStream);
    1:
      Result := TdxType1FontRangeEncoding.Create(AStream);
  else
    TdxPDFUtils.RaiseTestException;
    Result := nil;
  end;
  if (Result <> nil) and ((AID and SupplementDataFlag) = SupplementDataFlag) then
    Result.ReadSupplementData(AStream);
end;

function TdxType1FontCustomEncoding.GetCodeToGIDMapping(ACharset: TdxType1FontCustomCharset;
  AStringIndex: TdxCompactFontFormatStringIndex): TSmallIntDynArray;
var
  AEntry: TdxType1SupplementDataEntry;
begin
  Result := CodeToGIDMapping;
  if FSupplementData <> nil then
    for AEntry in FSupplementData do
      FillEntry(Result, AEntry.Code, AEntry.GID);
end;

function TdxType1FontCustomEncoding.SupplementDataLength: Byte;
begin
  Result := Length(FSupplementData);
  if Result > 0 then
    Result := Result * 3 + 1;
end;

procedure TdxType1FontCustomEncoding.FillEntry(const AMapping: TSmallIntDynArray; ACode: Byte; AGid: SmallInt);
begin
  if AMapping[ACode] = 0 then
    AMapping[ACode] := AGid;
end;

procedure TdxType1FontCustomEncoding.Write(AStream: TdxFontFileStream);
var
  I, ALength: Integer;
  AEntry: TdxType1SupplementDataEntry;
  AHasSupplementData: Boolean;
begin
  AHasSupplementData := FSupplementData <> nil;
  AStream.WriteByte(EncodingID or IfThen(AHasSupplementData, SupplementDataFlag, 0));
  WriteEncodingData(AStream);
  if AHasSupplementData then
  begin
    ALength := Length(FSupplementData);
    AStream.WriteByte(ALength);
    for I := 0 to ALength - 1 do
    begin
      AEntry := FSupplementData[I];
      AStream.WriteByte(AEntry.Code);
      AStream.WriteShort(AEntry.GID);
    end;
  end;
end;

procedure TdxType1FontCustomEncoding.ReadSupplementData(AStream: TdxFontFileStream);
var
  ACount, ACode: Byte;
  I: Integer;
begin
  ACount := AStream.ReadByte;
  SetLength(FSupplementData, ACount);
  for I := 0 to ACount - 1 do
  begin
    ACode := AStream.ReadByte;
    FSupplementData[I] := TdxType1SupplementDataEntry.Create(AStream.ReadShort, ACode);
  end;
end;

{ TdxType1FontArrayEncoding }

constructor TdxType1FontArrayEncoding.Create(AStream: TdxFontFileStream);
begin
  inherited Create(AStream);
  FArray := AStream.ReadArray(AStream.ReadByte);
end;

function TdxType1FontArrayEncoding.GetDataLength: Integer;
begin
  Result := Length(FArray);
  if Result > 0 then
    Result := Result + 2 + SupplementDataLength;
end;

function TdxType1FontArrayEncoding.CodeToGIDMapping: TSmallIntDynArray;
var
  I, AGid: SmallInt;
  ACount: Integer;
begin
  SetLength(Result, 256);
  ACount := Min(Length(FArray), 256);
  AGid := 1;
  for I := 0 to ACount - 1 do
  begin
    FillEntry(Result, FArray[I], AGid);
    Inc(AGid);
  end;
end;

function TdxType1FontArrayEncoding.EncodingID: Byte;
begin
  Result := 0;
end;

procedure TdxType1FontArrayEncoding.WriteEncodingData(AStream: TdxFontFileStream);
begin
  AStream.WriteByte(Length(FArray));
  AStream.WriteArray(FArray);
end;

{ TdxType1FontRangeEncoding }

constructor TdxType1FontRangeEncoding.Create(AStream: TdxFontFileStream);
var
  ACount, I: Integer;
  ARemain, AStart: Byte;
begin
  inherited Create(AStream);
  ACount := AStream.ReadByte;
  SetLength(FRanges, ACount);
  for I := 0 to ACount - 1 do
  begin
    AStart := AStream.ReadByte;
    ARemain := AStream.ReadByte;
    FRanges[I] := TRange.Create(AStart, ARemain);
  end;
end;

function TdxType1FontRangeEncoding.GetDataLength: Integer;
begin
  Result := Length(FRanges) * 2 + 2 + SupplementDataLength;
end;

function TdxType1FontRangeEncoding.CodeToGIDMapping: TSmallIntDynArray;
var
  I: Integer;
  AGid, ARemain: SmallInt;
  ARange: TRange;
  ACode: Byte;
begin
  SetLength(Result, 256);
  AGid := 1;
  for I := 0 to Length(FRanges) - 1 do
  begin
    ARange := FRanges[I];
    ACode := ARange.Start;
    for ARemain := ARange.Remain downto 0 do
    begin
      FillEntry(Result, ACode, AGid);
      Inc(AGid);
      Inc(ACode);
    end;
  end;
end;

function TdxType1FontRangeEncoding.EncodingID: Byte;
begin
  Result := 1;
end;

procedure TdxType1FontRangeEncoding.WriteEncodingData(AStream: TdxFontFileStream);
var
  I: Integer;
begin
  AStream.WriteByte(Length(FRanges));
  for I := 0 to Length(FRanges) - 1 do
  begin
    AStream.WriteByte(FRanges[I].Start);
    AStream.WriteByte(FRanges[I].Remain);
  end;
end;

class function TdxType1FontRangeEncoding.TRange.Create(AStart, ARemain: Byte): TRange;
begin
  Result.Start := AStart;
  Result.Remain := ARemain;
end;

{ TdxCompactFontFormatIndex }

constructor TdxCompactFontFormatIndex.Create;
begin
  inherited Create;
end;

constructor TdxCompactFontFormatIndex.Create(AStream: TdxFontFileStream);
var
  AObjectsCount, AOffSize, I, AIndex, APreviousOffset, AOffset, ALength: Integer;
  AOffsets: TIntegerDynArray;
  AObjectData: TBytes;
begin
  Create;
  AObjectsCount := AStream.ReadShort;
  ProcessObjectCount(AObjectsCount);
  if AObjectsCount > 0 then
  begin
    AOffSize := AStream.ReadByte;
    SetLength(AOffsets, AObjectsCount + 1);
    for I := 0 to AObjectsCount do
      AOffsets[I] := AStream.ReadOffSet(AOffSize);
    APreviousOffset := AOffsets[0];
    AIndex := 0;
    for I := 1 to AObjectsCount do
    begin
      AOffset := AOffsets[I];
      ALength := AOffset - APreviousOffset;
      if ALength < 0 then
        TdxPDFUtils.Abort
      else
      begin
        if ALength = 0 then
          SetLength(AObjectData, 0)
        else
          AObjectData := AStream.ReadArray(ALength);
        ProcessObject(AIndex, AObjectData);
      end;
      APreviousOffset := AOffset;
      Inc(AIndex);
    end;
  end;
end;

procedure TdxCompactFontFormatIndex.Write(AStream: TdxFontFileStream);
var
  I, AOffset: Integer;
  AObjectCount: SmallInt;
begin
  AObjectCount := ObjectCount;
  AStream.WriteShort(AObjectCount);
  if AObjectCount > 0 then
  begin
    AStream.WriteByte(4);
    AOffset := 1;
    AStream.WriteInt(AOffset);
    for I := 0 to AObjectCount - 1 do
    begin
      Inc(AOffset, GetObjectDataLength(I));
      AStream.WriteInt(AOffset);
    end;
    for I := 0 to AObjectCount - 1 do
      WriteObject(AStream, I);
  end;
end;

function TdxCompactFontFormatIndex.GetDataLength: Integer;
var
  I, AObjectsCount: Integer;
begin
  AObjectsCount := ObjectCount;
  Result := IfThen(AObjectsCount > 0, (AObjectsCount + 1) * 4 + 3, 2);
  for I := 0 to AObjectsCount - 1 do
    Inc(Result, GetObjectDataLength(I));
end;

{ TdxCompactFontFormatBinaryIndex }

constructor TdxCompactFontFormatBinaryIndex.CreateEx(AData: TdxPDFBytesList);
begin
  Create;
  FData := TdxPDFBytesList.Create;
  if AData <> nil then
    FData.AddRange(AData);
end;

destructor TdxCompactFontFormatBinaryIndex.Destroy;
begin
  FreeAndNil(FData);
  inherited Destroy;
end;

function TdxCompactFontFormatBinaryIndex.GetObjectCount: Integer;
begin
  Result := FData.Count;
end;

function TdxCompactFontFormatBinaryIndex.GetObjectDataLength(AIndex: Integer): Integer;
begin
  Result := Length(FData[AIndex]);
end;

procedure TdxCompactFontFormatBinaryIndex.ProcessObject(AIndex: Integer; const AData: TBytes);
begin
  FData.Add(AData);
end;

procedure TdxCompactFontFormatBinaryIndex.ProcessObjectCount(ACount: Integer);
begin
  FData := TdxPDFBytesList.Create;
  FData.Capacity := Max(ACount, 0);
end;

procedure TdxCompactFontFormatBinaryIndex.WriteObject(AStream: TdxFontFileStream; AIndex: Integer);
begin
  AStream.WriteArray(FData[AIndex]);
end;

{ TdxCompactFontFormatNameIndex }

procedure TdxCompactFontFormatNameIndex.AddString(const AValue: string);
var
  L: Integer;
begin
  L := Length(FStrings);
  SetLength(FStrings, L + 1);
  FStrings[L] := AValue;
end;

function TdxCompactFontFormatNameIndex.GetObjectCount: Integer;
begin
  Result := Length(FStrings);
end;

function TdxCompactFontFormatNameIndex.GetObjectDataLength(AIndex: Integer): Integer;
begin
  Result := Length(TEncoding.UTF8.GetBytes(Strings[AIndex]));
end;

procedure TdxCompactFontFormatNameIndex.ProcessObject(AIndex: Integer; const AData: TBytes);
var
  ALength, ACharCount: Integer;
begin
  FStrings[AIndex] := '';
  ALength := Length(AData);
  ACharCount := TEncoding.UTF8.GetCharCount(AData, 0, ALength);
  if (ALength > 0) and (AData[0] <> 0) and (ACharCount > 0) then
    FStrings[AIndex] := TdxPDFUtils.ConvertToUTF8String(AData);
end;

procedure TdxCompactFontFormatNameIndex.ProcessObjectCount(ACount: Integer);
begin
  SetLength(FStrings, ACount);
end;

procedure TdxCompactFontFormatNameIndex.WriteObject(AStream: TdxFontFileStream; AIndex: Integer);
begin
  AStream.WriteArray(TEncoding.UTF8.GetBytes(FStrings[AIndex]));
end;

{ TdxCompactFontFormatStringIndex }

constructor TdxCompactFontFormatStringIndex.Create(AStream: TdxFontFileStream);
begin
  inherited Create(AStream);
  FStandardStrings := TStringList.Create;
  FSIDMapping := TdxPDFStringSmallIntegerDictionary.Create;
  FStandardSIDMapping := TdxPDFStringSmallIntegerDictionary.Create;

  InitializeSIDMapping;
  InitializeStandardStrings;
  InitializeStandardSIDMapping;
end;

destructor TdxCompactFontFormatStringIndex.Destroy;
begin
  FreeAndNil(FStandardSIDMapping);
  FreeAndNil(FSIDMapping);
  FreeAndNil(FStandardStrings);
  inherited Destroy;
end;

function TdxCompactFontFormatStringIndex.GetSID(const AValue: string): SmallInt;
begin
  if not FStandardSIDMapping.TryGetValue(AValue, Result) and not FSIDMapping.TryGetValue(AValue, Result) then
    TdxPDFUtils.RaiseException;
end;

function TdxCompactFontFormatStringIndex.GetString(AOperands: TDoubleDynArray): string;
begin
  if Length(AOperands) <> 1 then
    TdxPDFUtils.RaiseException;
  Result := Items[Trunc(AOperands[0])];
end;

function TdxCompactFontFormatStringIndex.TryGetSID(const AValue: string): SmallInt;
begin
  if not FStandardSIDMapping.TryGetValue(AValue, Result) then
    if not FSIDMapping.TryGetValue(AValue, Result) then
      Result := 0;
end;

function TdxCompactFontFormatStringIndex.GetItem(Index: Integer): string;
begin
  if Index < StandardStringsCount then
    Result := FStandardStrings[Index]
  else
    Result := Strings[Index - StandardStringsCount];
end;

procedure TdxCompactFontFormatStringIndex.InitializeSIDMapping;
var
  I, ASID: Integer;
begin
  ASID := StandardStringsCount;
  for I := 0 to Length(Strings) - 1 do
  begin
    FSIDMapping.AddOrSetValue(Strings[I], ASID);
    Inc(ASID);
  end;
end;

procedure TdxCompactFontFormatStringIndex.InitializeStandardStrings;
begin
  FStandardStrings.Add(TdxGlyphNames._notdef);
  FStandardStrings.Add(TdxGlyphNames.Lowerspace);
  FStandardStrings.Add(TdxGlyphNames.Lowerexclam);
  FStandardStrings.Add(TdxGlyphNames.Lowerquotedbl);
  FStandardStrings.Add(TdxGlyphNames.Lowernumbersign);
  FStandardStrings.Add(TdxGlyphNames.Lowerdollar);
  FStandardStrings.Add(TdxGlyphNames.Lowerpercent);
  FStandardStrings.Add(TdxGlyphNames.Lowerampersand);
  FStandardStrings.Add(TdxGlyphNames.Lowerquoteright);
  FStandardStrings.Add(TdxGlyphNames.Lowerparenleft);
  FStandardStrings.Add(TdxGlyphNames.Lowerparenright);
  FStandardStrings.Add(TdxGlyphNames.Lowerasterisk);
  FStandardStrings.Add(TdxGlyphNames.Lowerplus);
  FStandardStrings.Add(TdxGlyphNames.Lowercomma);
  FStandardStrings.Add(TdxGlyphNames.Lowerhyphen);
  FStandardStrings.Add(TdxGlyphNames.Lowerperiod);
  FStandardStrings.Add(TdxGlyphNames.Lowerslash);
  FStandardStrings.Add(TdxGlyphNames.Lowerzero);
  FStandardStrings.Add(TdxGlyphNames.Lowerone);
  FStandardStrings.Add(TdxGlyphNames.Lowertwo);
  FStandardStrings.Add(TdxGlyphNames.Lowerthree);
  FStandardStrings.Add(TdxGlyphNames.Lowerfour);
  FStandardStrings.Add(TdxGlyphNames.Lowerfive);
  FStandardStrings.Add(TdxGlyphNames.Lowersix);
  FStandardStrings.Add(TdxGlyphNames.Lowerseven);
  FStandardStrings.Add(TdxGlyphNames.Lowereight);
  FStandardStrings.Add(TdxGlyphNames.Lowernine);
  FStandardStrings.Add(TdxGlyphNames.Lowercolon);
  FStandardStrings.Add(TdxGlyphNames.Lowersemicolon);
  FStandardStrings.Add(TdxGlyphNames.Lowerless);
  FStandardStrings.Add(TdxGlyphNames.Lowerequal);
  FStandardStrings.Add(TdxGlyphNames.Lowergreater);
  FStandardStrings.Add(TdxGlyphNames.Lowerquestion);
  FStandardStrings.Add(TdxGlyphNames.Lowerat);
  FStandardStrings.Add(TdxGlyphNames.A);
  FStandardStrings.Add(TdxGlyphNames.B);
  FStandardStrings.Add(TdxGlyphNames.C);
  FStandardStrings.Add(TdxGlyphNames.D);
  FStandardStrings.Add(TdxGlyphNames.E);
  FStandardStrings.Add(TdxGlyphNames.F);
  FStandardStrings.Add(TdxGlyphNames.G);
  FStandardStrings.Add(TdxGlyphNames.H);
  FStandardStrings.Add(TdxGlyphNames.I);
  FStandardStrings.Add(TdxGlyphNames.J);
  FStandardStrings.Add(TdxGlyphNames.K);
  FStandardStrings.Add(TdxGlyphNames.L);
  FStandardStrings.Add(TdxGlyphNames.M);
  FStandardStrings.Add(TdxGlyphNames.N);
  FStandardStrings.Add(TdxGlyphNames.O);
  FStandardStrings.Add(TdxGlyphNames.P);
  FStandardStrings.Add(TdxGlyphNames.Q);
  FStandardStrings.Add(TdxGlyphNames.R);
  FStandardStrings.Add(TdxGlyphNames.S);
  FStandardStrings.Add(TdxGlyphNames.T);
  FStandardStrings.Add(TdxGlyphNames.U);
  FStandardStrings.Add(TdxGlyphNames.V);
  FStandardStrings.Add(TdxGlyphNames.W);
  FStandardStrings.Add(TdxGlyphNames.X);
  FStandardStrings.Add(TdxGlyphNames.Y);
  FStandardStrings.Add(TdxGlyphNames.Z);
  FStandardStrings.Add(TdxGlyphNames.Lowerbracketleft);
  FStandardStrings.Add(TdxGlyphNames.Lowerbackslash);
  FStandardStrings.Add(TdxGlyphNames.Lowerbracketright);
  FStandardStrings.Add(TdxGlyphNames.Lowerasciicircum);
  FStandardStrings.Add(TdxGlyphNames.Lowerunderscore);
  FStandardStrings.Add(TdxGlyphNames.Lowerquoteleft);
  FStandardStrings.Add(TdxGlyphNames.Lowera);
  FStandardStrings.Add(TdxGlyphNames.Lowerb);
  FStandardStrings.Add(TdxGlyphNames.Lowerc);
  FStandardStrings.Add(TdxGlyphNames.Lowerd);
  FStandardStrings.Add(TdxGlyphNames.Lowere);
  FStandardStrings.Add(TdxGlyphNames.Lowerf);
  FStandardStrings.Add(TdxGlyphNames.Lowerg);
  FStandardStrings.Add(TdxGlyphNames.Lowerh);
  FStandardStrings.Add(TdxGlyphNames.Loweri);
  FStandardStrings.Add(TdxGlyphNames.Lowerj);
  FStandardStrings.Add(TdxGlyphNames.Lowerk);
  FStandardStrings.Add(TdxGlyphNames.Lowerl);
  FStandardStrings.Add(TdxGlyphNames.Lowerm);
  FStandardStrings.Add(TdxGlyphNames.Lowern);
  FStandardStrings.Add(TdxGlyphNames.Lowero);
  FStandardStrings.Add(TdxGlyphNames.Lowerp);
  FStandardStrings.Add(TdxGlyphNames.Lowerq);
  FStandardStrings.Add(TdxGlyphNames.Lowerr);
  FStandardStrings.Add(TdxGlyphNames.Lowers);
  FStandardStrings.Add(TdxGlyphNames.Lowert);
  FStandardStrings.Add(TdxGlyphNames.Loweru);
  FStandardStrings.Add(TdxGlyphNames.Lowerv);
  FStandardStrings.Add(TdxGlyphNames.Lowerw);
  FStandardStrings.Add(TdxGlyphNames.Lowerx);
  FStandardStrings.Add(TdxGlyphNames.Lowery);
  FStandardStrings.Add(TdxGlyphNames.Lowerz);
  FStandardStrings.Add(TdxGlyphNames.Lowerbraceleft);
  FStandardStrings.Add(TdxGlyphNames.Lowerbar);
  FStandardStrings.Add(TdxGlyphNames.Lowerbraceright);
  FStandardStrings.Add(TdxGlyphNames.Lowerasciitilde);
  FStandardStrings.Add(TdxGlyphNames.Lowerexclamdown);
  FStandardStrings.Add(TdxGlyphNames.Lowercent);
  FStandardStrings.Add(TdxGlyphNames.Lowersterling);
  FStandardStrings.Add(TdxGlyphNames.Lowerfraction);
  FStandardStrings.Add(TdxGlyphNames.Loweryen);
  FStandardStrings.Add(TdxGlyphNames.Lowerflorin);
  FStandardStrings.Add(TdxGlyphNames.Lowersection);
  FStandardStrings.Add(TdxGlyphNames.Lowercurrency);
  FStandardStrings.Add(TdxGlyphNames.Lowerquotesingle);
  FStandardStrings.Add(TdxGlyphNames.Lowerquotedblleft);
  FStandardStrings.Add(TdxGlyphNames.Lowerguillemotleft);
  FStandardStrings.Add(TdxGlyphNames.Lowerguilsinglleft);
  FStandardStrings.Add(TdxGlyphNames.Lowerguilsinglright);
  FStandardStrings.Add(TdxGlyphNames.Lowerfi);
  FStandardStrings.Add(TdxGlyphNames.Lowerfl);
  FStandardStrings.Add(TdxGlyphNames.Lowerendash);
  FStandardStrings.Add(TdxGlyphNames.Lowerdagger);
  FStandardStrings.Add(TdxGlyphNames.Lowerdaggerdbl);
  FStandardStrings.Add(TdxGlyphNames.Lowerperiodcentered);
  FStandardStrings.Add(TdxGlyphNames.Lowerparagraph);
  FStandardStrings.Add(TdxGlyphNames.Lowerbullet);
  FStandardStrings.Add(TdxGlyphNames.Lowerquotesinglbase);
  FStandardStrings.Add(TdxGlyphNames.Lowerquotedblbase);
  FStandardStrings.Add(TdxGlyphNames.Lowerquotedblright);
  FStandardStrings.Add(TdxGlyphNames.Lowerguillemotright);
  FStandardStrings.Add(TdxGlyphNames.Lowerellipsis);
  FStandardStrings.Add(TdxGlyphNames.Lowerperthousand);
  FStandardStrings.Add(TdxGlyphNames.Lowerquestiondown);
  FStandardStrings.Add(TdxGlyphNames.Lowergrave);
  FStandardStrings.Add(TdxGlyphNames.Loweracute);
  FStandardStrings.Add(TdxGlyphNames.Lowercircumflex);
  FStandardStrings.Add(TdxGlyphNames.Lowertilde);
  FStandardStrings.Add(TdxGlyphNames.Lowermacron);
  FStandardStrings.Add(TdxGlyphNames.Lowerbreve);
  FStandardStrings.Add(TdxGlyphNames.Lowerdotaccent);
  FStandardStrings.Add(TdxGlyphNames.Lowerdieresis);
  FStandardStrings.Add(TdxGlyphNames.Lowerring);
  FStandardStrings.Add(TdxGlyphNames.Lowercedilla);
  FStandardStrings.Add(TdxGlyphNames.Lowerhungarumlaut);
  FStandardStrings.Add(TdxGlyphNames.Lowerogonek);
  FStandardStrings.Add(TdxGlyphNames.Lowercaron);
  FStandardStrings.Add(TdxGlyphNames.Loweremdash);
  FStandardStrings.Add(TdxGlyphNames.AE);
  FStandardStrings.Add(TdxGlyphNames.Lowerordfeminine);
  FStandardStrings.Add(TdxGlyphNames.Lslash);
  FStandardStrings.Add(TdxGlyphNames.Oslash);
  FStandardStrings.Add(TdxGlyphNames.OE);
  FStandardStrings.Add(TdxGlyphNames.Lowerordmasculine);
  FStandardStrings.Add(TdxGlyphNames.Lowerae);
  FStandardStrings.Add(TdxGlyphNames.Lowerdotlessi);
  FStandardStrings.Add(TdxGlyphNames.Lowerlslash);
  FStandardStrings.Add(TdxGlyphNames.Loweroslash);
  FStandardStrings.Add(TdxGlyphNames.Loweroe);
  FStandardStrings.Add(TdxGlyphNames.Lowergermandbls);
  FStandardStrings.Add(TdxGlyphNames.Loweronesuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerlogicalnot);
  FStandardStrings.Add(TdxGlyphNames.Lowermu);
  FStandardStrings.Add(TdxGlyphNames.Lowertrademark);
  FStandardStrings.Add(TdxGlyphNames.Eth);
  FStandardStrings.Add(TdxGlyphNames.Loweronehalf);
  FStandardStrings.Add(TdxGlyphNames.Lowerplusminus);
  FStandardStrings.Add(TdxGlyphNames.Thorn);
  FStandardStrings.Add(TdxGlyphNames.Loweronequarter);
  FStandardStrings.Add(TdxGlyphNames.Lowerdivide);
  FStandardStrings.Add(TdxGlyphNames.Lowerbrokenbar);
  FStandardStrings.Add(TdxGlyphNames.Lowerdegree);
  FStandardStrings.Add(TdxGlyphNames.Lowerthorn);
  FStandardStrings.Add(TdxGlyphNames.Lowerthreequarters);
  FStandardStrings.Add(TdxGlyphNames.Lowertwosuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerregistered);
  FStandardStrings.Add(TdxGlyphNames.Lowerminus);
  FStandardStrings.Add(TdxGlyphNames.Lowereth);
  FStandardStrings.Add(TdxGlyphNames.Lowermultiply);
  FStandardStrings.Add(TdxGlyphNames.Lowerthreesuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowercopyright);
  FStandardStrings.Add(TdxGlyphNames.Aacute);
  FStandardStrings.Add(TdxGlyphNames.Acircumflex);
  FStandardStrings.Add(TdxGlyphNames.Adieresis);
  FStandardStrings.Add(TdxGlyphNames.Agrave);
  FStandardStrings.Add(TdxGlyphNames.Aring);
  FStandardStrings.Add(TdxGlyphNames.Atilde);
  FStandardStrings.Add(TdxGlyphNames.Ccedilla);
  FStandardStrings.Add(TdxGlyphNames.Eacute);
  FStandardStrings.Add(TdxGlyphNames.Ecircumflex);
  FStandardStrings.Add(TdxGlyphNames.Edieresis);
  FStandardStrings.Add(TdxGlyphNames.Egrave);
  FStandardStrings.Add(TdxGlyphNames.Iacute);
  FStandardStrings.Add(TdxGlyphNames.Icircumflex);
  FStandardStrings.Add(TdxGlyphNames.Idieresis);
  FStandardStrings.Add(TdxGlyphNames.Igrave);
  FStandardStrings.Add(TdxGlyphNames.Ntilde);
  FStandardStrings.Add(TdxGlyphNames.Oacute);
  FStandardStrings.Add(TdxGlyphNames.Ocircumflex);
  FStandardStrings.Add(TdxGlyphNames.Odieresis);
  FStandardStrings.Add(TdxGlyphNames.Ograve);
  FStandardStrings.Add(TdxGlyphNames.Otilde);
  FStandardStrings.Add(TdxGlyphNames.Scaron);
  FStandardStrings.Add(TdxGlyphNames.Uacute);
  FStandardStrings.Add(TdxGlyphNames.Ucircumflex);
  FStandardStrings.Add(TdxGlyphNames.Udieresis);
  FStandardStrings.Add(TdxGlyphNames.Ugrave);
  FStandardStrings.Add(TdxGlyphNames.Yacute);
  FStandardStrings.Add(TdxGlyphNames.Ydieresis);
  FStandardStrings.Add(TdxGlyphNames.Zcaron);
  FStandardStrings.Add(TdxGlyphNames.Loweraacute);
  FStandardStrings.Add(TdxGlyphNames.Loweracircumflex);
  FStandardStrings.Add(TdxGlyphNames.Loweradieresis);
  FStandardStrings.Add(TdxGlyphNames.Loweragrave);
  FStandardStrings.Add(TdxGlyphNames.Loweraring);
  FStandardStrings.Add(TdxGlyphNames.Loweratilde);
  FStandardStrings.Add(TdxGlyphNames.Lowerccedilla);
  FStandardStrings.Add(TdxGlyphNames.Lowereacute);
  FStandardStrings.Add(TdxGlyphNames.Lowerecircumflex);
  FStandardStrings.Add(TdxGlyphNames.Loweredieresis);
  FStandardStrings.Add(TdxGlyphNames.Loweregrave);
  FStandardStrings.Add(TdxGlyphNames.Loweriacute);
  FStandardStrings.Add(TdxGlyphNames.Lowericircumflex);
  FStandardStrings.Add(TdxGlyphNames.Loweridieresis);
  FStandardStrings.Add(TdxGlyphNames.Lowerigrave);
  FStandardStrings.Add(TdxGlyphNames.Lowerntilde);
  FStandardStrings.Add(TdxGlyphNames.Loweroacute);
  FStandardStrings.Add(TdxGlyphNames.Lowerocircumflex);
  FStandardStrings.Add(TdxGlyphNames.Lowerodieresis);
  FStandardStrings.Add(TdxGlyphNames.Lowerograve);
  FStandardStrings.Add(TdxGlyphNames.Lowerotilde);
  FStandardStrings.Add(TdxGlyphNames.Lowerscaron);
  FStandardStrings.Add(TdxGlyphNames.Loweruacute);
  FStandardStrings.Add(TdxGlyphNames.Lowerucircumflex);
  FStandardStrings.Add(TdxGlyphNames.Lowerudieresis);
  FStandardStrings.Add(TdxGlyphNames.Lowerugrave);
  FStandardStrings.Add(TdxGlyphNames.Loweryacute);
  FStandardStrings.Add(TdxGlyphNames.Lowerydieresis);
  FStandardStrings.Add(TdxGlyphNames.Lowerzcaron);
  FStandardStrings.Add(TdxGlyphNames.Lowerexclamsmall);
  FStandardStrings.Add(TdxGlyphNames.Hungarumlautsmall);
  FStandardStrings.Add(TdxGlyphNames.Lowerdollaroldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowerdollarsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerampersandsmall);
  FStandardStrings.Add(TdxGlyphNames.Acutesmall);
  FStandardStrings.Add(TdxGlyphNames.Lowerparenleftsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerparenrightsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowertwodotenleader);
  FStandardStrings.Add(TdxGlyphNames.Loweronedotenleader);
  FStandardStrings.Add(TdxGlyphNames.Lowerzerooldstyle);
  FStandardStrings.Add(TdxGlyphNames.Loweroneoldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowertwooldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowerthreeoldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowerfouroldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowerfiveoldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowersixoldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowersevenoldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowereightoldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowernineoldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lowercommasuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerthreequartersemdash);
  FStandardStrings.Add(TdxGlyphNames.Lowerperiodsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerquestionsmall);
  FStandardStrings.Add(TdxGlyphNames.Lowerasuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerbsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowercentsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerdsuperior);
  FStandardStrings.Add(TdxGlyphNames.Loweresuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerisuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerlsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowermsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowernsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerosuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerrsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerssuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowertsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerff);
  FStandardStrings.Add(TdxGlyphNames.Lowerffi);
  FStandardStrings.Add(TdxGlyphNames.Lowerffl);
  FStandardStrings.Add(TdxGlyphNames.Lowerparenleftinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowerparenrightinferior);
  FStandardStrings.Add(TdxGlyphNames.Circumflexsmall);
  FStandardStrings.Add(TdxGlyphNames.Lowerhyphensuperior);
  FStandardStrings.Add(TdxGlyphNames.Gravesmall);
  FStandardStrings.Add(TdxGlyphNames.Asmall);
  FStandardStrings.Add(TdxGlyphNames.Bsmall);
  FStandardStrings.Add(TdxGlyphNames.Csmall);
  FStandardStrings.Add(TdxGlyphNames.Dsmall);
  FStandardStrings.Add(TdxGlyphNames.Esmall);
  FStandardStrings.Add(TdxGlyphNames.Fsmall);
  FStandardStrings.Add(TdxGlyphNames.Gsmall);
  FStandardStrings.Add(TdxGlyphNames.Hsmall);
  FStandardStrings.Add(TdxGlyphNames.Ismall);
  FStandardStrings.Add(TdxGlyphNames.Jsmall);
  FStandardStrings.Add(TdxGlyphNames.Ksmall);
  FStandardStrings.Add(TdxGlyphNames.Lsmall);
  FStandardStrings.Add(TdxGlyphNames.Msmall);
  FStandardStrings.Add(TdxGlyphNames.Nsmall);
  FStandardStrings.Add(TdxGlyphNames.Osmall);
  FStandardStrings.Add(TdxGlyphNames.Psmall);
  FStandardStrings.Add(TdxGlyphNames.Qsmall);
  FStandardStrings.Add(TdxGlyphNames.Rsmall);
  FStandardStrings.Add(TdxGlyphNames.Ssmall);
  FStandardStrings.Add(TdxGlyphNames.Tsmall);
  FStandardStrings.Add(TdxGlyphNames.Usmall);
  FStandardStrings.Add(TdxGlyphNames.Vsmall);
  FStandardStrings.Add(TdxGlyphNames.Wsmall);
  FStandardStrings.Add(TdxGlyphNames.Xsmall);
  FStandardStrings.Add(TdxGlyphNames.Ysmall);
  FStandardStrings.Add(TdxGlyphNames.Zsmall);
  FStandardStrings.Add(TdxGlyphNames.Lowercolonmonetary);
  FStandardStrings.Add(TdxGlyphNames.Loweronefitted);
  FStandardStrings.Add(TdxGlyphNames.Lowerrupiah);
  FStandardStrings.Add(TdxGlyphNames.Tildesmall);
  FStandardStrings.Add(TdxGlyphNames.Lowerexclamdownsmall);
  FStandardStrings.Add(TdxGlyphNames.Lowercentoldstyle);
  FStandardStrings.Add(TdxGlyphNames.Lslashsmall);
  FStandardStrings.Add(TdxGlyphNames.Scaronsmall);
  FStandardStrings.Add(TdxGlyphNames.Zcaronsmall);
  FStandardStrings.Add(TdxGlyphNames.Dieresissmall);
  FStandardStrings.Add(TdxGlyphNames.Brevesmall);
  FStandardStrings.Add(TdxGlyphNames.Caronsmall);
  FStandardStrings.Add(TdxGlyphNames.Dotaccentsmall);
  FStandardStrings.Add(TdxGlyphNames.Macronsmall);
  FStandardStrings.Add(TdxGlyphNames.Lowerfiguredash);
  FStandardStrings.Add(TdxGlyphNames.Lowerhypheninferior);
  FStandardStrings.Add(TdxGlyphNames.Ogoneksmall);
  FStandardStrings.Add(TdxGlyphNames.Ringsmall);
  FStandardStrings.Add(TdxGlyphNames.Cedillasmall);
  FStandardStrings.Add(TdxGlyphNames.Lowerquestiondownsmall);
  FStandardStrings.Add(TdxGlyphNames.Loweroneeighth);
  FStandardStrings.Add(TdxGlyphNames.Lowerthreeeighths);
  FStandardStrings.Add(TdxGlyphNames.Lowerfiveeighths);
  FStandardStrings.Add(TdxGlyphNames.Lowerseveneighths);
  FStandardStrings.Add(TdxGlyphNames.Loweronethird);
  FStandardStrings.Add(TdxGlyphNames.Lowertwothirds);
  FStandardStrings.Add(TdxGlyphNames.Lowerzerosuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerfoursuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerfivesuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowersixsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowersevensuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowereightsuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerninesuperior);
  FStandardStrings.Add(TdxGlyphNames.Lowerzeroinferior);
  FStandardStrings.Add(TdxGlyphNames.Loweroneinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowertwoinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowerthreeinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowerfourinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowerfiveinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowersixinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowerseveninferior);
  FStandardStrings.Add(TdxGlyphNames.Lowereightinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowernineinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowercentinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowerdollarinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowerperiodinferior);
  FStandardStrings.Add(TdxGlyphNames.Lowercommainferior);
  FStandardStrings.Add(TdxGlyphNames.Agravesmall);
  FStandardStrings.Add(TdxGlyphNames.Aacutesmall);
  FStandardStrings.Add(TdxGlyphNames.Acircumflexsmall);
  FStandardStrings.Add(TdxGlyphNames.Atildesmall);
  FStandardStrings.Add(TdxGlyphNames.Adieresissmall);
  FStandardStrings.Add(TdxGlyphNames.Aringsmall);
  FStandardStrings.Add(TdxGlyphNames.AEsmall);
  FStandardStrings.Add(TdxGlyphNames.Ccedillasmall);
  FStandardStrings.Add(TdxGlyphNames.Egravesmall);
  FStandardStrings.Add(TdxGlyphNames.Eacutesmall);
  FStandardStrings.Add(TdxGlyphNames.Ecircumflexsmall);
  FStandardStrings.Add(TdxGlyphNames.Edieresissmall);
  FStandardStrings.Add(TdxGlyphNames.Igravesmall);
  FStandardStrings.Add(TdxGlyphNames.Iacutesmall);
  FStandardStrings.Add(TdxGlyphNames.Icircumflexsmall);
  FStandardStrings.Add(TdxGlyphNames.Idieresissmall);
  FStandardStrings.Add(TdxGlyphNames.Ethsmall);
  FStandardStrings.Add(TdxGlyphNames.Ntildesmall);
  FStandardStrings.Add(TdxGlyphNames.Ogravesmall);
  FStandardStrings.Add(TdxGlyphNames.Oacutesmall);
  FStandardStrings.Add(TdxGlyphNames.Ocircumflexsmall);
  FStandardStrings.Add(TdxGlyphNames.Otildesmall);
  FStandardStrings.Add(TdxGlyphNames.Odieresissmall);
  FStandardStrings.Add(TdxGlyphNames.OEsmall);
  FStandardStrings.Add(TdxGlyphNames.Oslashsmall);
  FStandardStrings.Add(TdxGlyphNames.Ugravesmall);
  FStandardStrings.Add(TdxGlyphNames.Uacutesmall);
  FStandardStrings.Add(TdxGlyphNames.Ucircumflexsmall);
  FStandardStrings.Add(TdxGlyphNames.Udieresissmall);
  FStandardStrings.Add(TdxGlyphNames.Yacutesmall);
  FStandardStrings.Add(TdxGlyphNames.Thornsmall);
  FStandardStrings.Add(TdxGlyphNames.Ydieresissmall);
  FStandardStrings.Add(TdxGlyphNames._001_000);
  FStandardStrings.Add(TdxGlyphNames._001_001);
  FStandardStrings.Add(TdxGlyphNames._001_002);
  FStandardStrings.Add(TdxGlyphNames._001_003);
  FStandardStrings.Add(TdxGlyphNames.Black);
  FStandardStrings.Add(TdxGlyphNames.Bold);
  FStandardStrings.Add(TdxGlyphNames.Book);
  FStandardStrings.Add(TdxGlyphNames.Light);
  FStandardStrings.Add(TdxGlyphNames.Medium);
  FStandardStrings.Add(TdxGlyphNames.Regular);
  FStandardStrings.Add(TdxGlyphNames.Roman);
  FStandardStrings.Add(TdxGlyphNames.Semibold);
end;

procedure TdxCompactFontFormatStringIndex.InitializeStandardSIDMapping;
var
  I: Integer;
begin
  for I := 0 to StandardStringsCount - 1 do
    FStandardSIDMapping.Add(FStandardStrings[I], I);
end;

{ TdxCompactFontFormatTopDictIndex }

constructor TdxCompactFontFormatTopDictIndex.CreateEx(const AData: TBytes);
begin
  FObjectData := AData;
end;

function TdxCompactFontFormatTopDictIndex.GetObjectCount: Integer;
begin
  Result := 1;
end;

function TdxCompactFontFormatTopDictIndex.GetObjectDataLength(AIndex: Integer): Integer;
begin
  Result := Length(FObjectData);
end;

procedure TdxCompactFontFormatTopDictIndex.ProcessObject(AIndex: Integer; const AData: TBytes);
begin
  FObjectData := AData;
end;

procedure TdxCompactFontFormatTopDictIndex.ProcessObjectCount(ACount: Integer);
begin
  if ACount <> 1 then
    TdxPDFUtils.Abort;
end;

procedure TdxCompactFontFormatTopDictIndex.WriteObject(AStream: TdxFontFileStream; AIndex: Integer);
begin
  AStream.WriteArray(FObjectData);
end;

{ TdxType1FontCustomCharset }

constructor TdxType1FontCustomCharset.Create;
begin
  inherited Create;
  CreateSubClasses;
end;

constructor TdxType1FontCustomCharset.Create(AStream: TdxFontFileStream; ASize: Integer);
begin
  Create;
end;

destructor TdxType1FontCustomCharset.Destroy;
begin
  DestroySubClasses;
  inherited Destroy;
end;

class function TdxType1FontCustomCharset.Parse(AStream: TdxFontFileStream; ASize: Integer): TdxType1FontCustomCharset;
var
  AClass: TdxType1FontCustomCharsetClass;
begin
  case AStream.ReadByte of
    0:
      AClass := TdxType1FontArrayCharset;
    1:
      AClass := TdxType1FontByteRangeCharset;
    2:
      AClass := TdxType1FontWordRangeCharset;
  else
    AClass := nil;
  end;
  if AClass <> nil then
    Result := AClass.Create(AStream, ASize)
  else
  begin
    Result := nil;
    TdxPDFUtils.RaiseTestException;
  end;
end;

function TdxType1FontCustomCharset.IsDefault: Boolean;
begin
  Result := False;
end;

class function TdxType1FontCustomCharset.GetID: Integer;
begin
  Result := -1;
end;

function TdxType1FontCustomCharset.GetOffset: Integer;
begin
  Result := 0;
end;

procedure TdxType1FontCustomCharset.SetSIDToGIDMapping(AValue: TdxPDFSmallIntegerDictionary);
begin
// do nothing
end;

procedure TdxType1FontCustomCharset.CreateSubClasses;
begin
// do nothing
end;

procedure TdxType1FontCustomCharset.DestroySubClasses;
begin
// do nothing
end;

{ TdxType1FontArrayCharset }

constructor TdxType1FontArrayCharset.Create(AStream: TdxFontFileStream; ASize: Integer);
begin
  inherited Create(AStream, ASize);
  FCharset := AStream.ReadShortArray(ASize);
end;

class function TdxType1FontArrayCharset.GetID: Integer;
begin
  Result := 0;
end;

procedure TdxType1FontArrayCharset.Write(AStream: TdxFontFileStream);
begin
  AStream.WriteByte(GetID);
  AStream.WriteShortArrayEx(FCharset);
end;

function TdxType1FontArrayCharset.GetDataLength: Integer;
begin
  Result := Length(FCharset) * 2 + 1;
end;

function TdxType1FontArrayCharset.GetSIDToGIDMapping: TdxPDFSmallIntegerDictionary;
var
  I, AGID: Integer;
begin
  if FCIDToGIDMapping = nil then
  begin
    FCIDToGIDMapping := TdxPDFSmallIntegerDictionary.Create;
    AGID := 1;
    for I := 0 to Length(FCharset) - 1 do
    begin
      FCIDToGIDMapping.AddOrSetValue(FCharset[I], AGID);
      Inc(AGID);
    end;
  end;
  Result := FCIDToGIDMapping;
end;

procedure TdxType1FontArrayCharset.SetSIDToGIDMapping(AValue: TdxPDFSmallIntegerDictionary);
begin
  FCIDToGIDMapping := AValue;
end;

procedure TdxType1FontArrayCharset.DestroySubClasses;
begin
  FreeAndNil(FCIDToGIDMapping);
  inherited DestroySubClasses;
end;

{ TdxType1FontCustomRange }

constructor TdxType1FontCustomRange.Create(ASID: SmallInt);
begin
  inherited Create;
  SID := ASID;
end;

{ TdxType1FontByteRange }

constructor TdxType1FontByteRange.Create(ASID: SmallInt; ARemain: Byte);
begin
  inherited Create(ASID);
  Remain := ARemain;
end;

{ TdxType1FontWordRange }

constructor TdxType1FontWordRange.Create(ASID, ARemain: SmallInt);
begin
  inherited Create(ASID);
  Remain := ARemain;
end;

{ TdxType1FontByteRangeCharset }

constructor TdxType1FontCustomRangeCharset.Create(AStream: TdxFontFileStream; ASize: Integer);
begin
  inherited Create(AStream, ASize);
  PopulateRanges(AStream, ASize);
end;

procedure TdxType1FontCustomRangeCharset.Write(AStream: TdxFontFileStream);
var
  I: Integer;
  ARange: TdxType1FontCustomRange;
begin
  AStream.WriteByte(GetID);
  for I := 0 to FRanges.Count - 1 do
  begin
    ARange := TdxType1FontCustomRange(FRanges[I]);
    AStream.WriteShort(ARange.SID);
    WriteRemain(AStream, ARange);
  end;
end;

function TdxType1FontCustomRangeCharset.GetDataLength: Integer;
begin
  Result := FRanges.Count * GetDataLengthFactor + 1;
end;

function TdxType1FontCustomRangeCharset.GetSIDToGIDMapping: TdxPDFSmallIntegerDictionary;
var
  I, AIndex: Integer;
  ASID: SmallInt;
begin
  if FCIDToGIDMapping = nil then
  begin
    FCIDToGIDMapping := TdxPDFSmallIntegerDictionary.Create;
    AIndex := 1;
    for I := 0 to FRanges.Count - 1 do
    begin
      ASID := TdxType1FontCustomRange(FRanges[I]).SID;
      AddToCIDToGIDMapping(ASID, AIndex);
      Inc(ASID);
      Inc(AIndex);
      ProcessRemain(TdxType1FontCustomRange(FRanges[I]), ASID, AIndex);
    end;
  end;
  Result := FCIDToGIDMapping;
end;

procedure TdxType1FontCustomRangeCharset.SetSIDToGIDMapping(AValue: TdxPDFSmallIntegerDictionary);
begin
  FCIDToGIDMapping := AValue;
end;

procedure TdxType1FontCustomRangeCharset.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FRanges := TdxFastObjectList.Create;
end;

procedure TdxType1FontCustomRangeCharset.DestroySubClasses;
begin
  FreeAndNIl(FCIDToGIDMapping);
  FreeAndNIl(FRanges);
  inherited DestroySubClasses;
end;

procedure TdxType1FontCustomRangeCharset.AddToCIDToGIDMapping(AKey, AValue: SmallInt);
begin
  FCIDToGIDMapping.AddOrSetValue(AKey, AValue);
end;

{ TdxType1FontByteRangeCharset }

class function TdxType1FontByteRangeCharset.GetID: Integer;
begin
  Result := 1;
end;

function TdxType1FontByteRangeCharset.GetDataLengthFactor: Integer;
begin
  Result := 3;
end;

procedure TdxType1FontByteRangeCharset.PopulateRanges(AStream: TdxFontFileStream; ASize: Integer);
var
  ASID: SmallInt;
  ARemain: Byte;
begin
  while ASize > 0 do
  begin
    ASID := AStream.ReadShort;
    ARemain := AStream.ReadByte;
    if ARemain >= ASize then
      ARemain := ASize - 1;
    FRanges.Add(TdxType1FontByteRange.Create(ASID, ARemain));
    Dec(ASize, ARemain + 1);
  end;
end;

procedure TdxType1FontByteRangeCharset.ProcessRemain(ARange: TdxType1FontCustomRange; var ASID: SmallInt; var AIndex: Integer);
var
  ARemain: Byte;
begin
  for ARemain := (ARange as TdxType1FontByteRange).Remain downto 1 do
  begin
    AddToCIDToGIDMapping(ASID, AIndex);
    Inc(ASID);
    Inc(AIndex);
  end;
end;

procedure TdxType1FontByteRangeCharset.WriteRemain(AStream: TdxFontFileStream; ARange: TdxType1FontCustomRange);
begin
  AStream.WriteByte((ARange as TdxType1FontByteRange).Remain);
end;

{ TdxType1FontWordRangeCharset }

class function TdxType1FontWordRangeCharset.GetID: Integer;
begin
  Result := 2;
end;

function TdxType1FontWordRangeCharset.GetDataLengthFactor: Integer;
begin
  Result := 4;
end;

procedure TdxType1FontWordRangeCharset.PopulateRanges(AStream: TdxFontFileStream; ASize: Integer);
var
  ASID: SmallInt;
  ARemain: SmallInt;
begin
  while ASize > 0 do
  begin
    ASID := AStream.ReadShort;
    ARemain := AStream.ReadShort;
    if ARemain >= ASize then
      ARemain := ASize - 1;
    FRanges.Add(TdxType1FontWordRange.Create(ASID, ARemain));
    Dec(ASize, ARemain + 1);
  end;
end;

procedure TdxType1FontWordRangeCharset.ProcessRemain(ARange: TdxType1FontCustomRange; var ASID: SmallInt;
  var AIndex: Integer);
var
  ARemain: SmallInt;
begin
  for ARemain := (ARange as TdxType1FontWordRange).Remain downto 1 do
  begin
    AddToCIDToGIDMapping(ASID, AIndex);
    Inc(ASID);
    Inc(AIndex);
  end;
end;

procedure TdxType1FontWordRangeCharset.WriteRemain(AStream: TdxFontFileStream; ARange: TdxType1FontCustomRange);
begin
  AStream.WriteShort((ARange as TdxType1FontWordRange).Remain);
end;

{ TdxType1FontPredefinedCharset }

constructor TdxType1FontPredefinedCharset.Create(AID: TdxType1FontPredefinedCharsetID);
begin
  inherited Create;
  FID := AID;
end;

function TdxType1FontPredefinedCharset.IsDefault: Boolean;
begin
  Result := FID = pcISOAdobe;
end;

procedure TdxType1FontPredefinedCharset.Write(AStream: TdxFontFileStream);
begin
// do nothing
end;

function TdxType1FontPredefinedCharset.GetDataLength: Integer;
begin
  Result := 0;
end;

function TdxType1FontPredefinedCharset.GetOffset: Integer;
begin
  Result := Integer(FID);
end;

function TdxType1FontPredefinedCharset.GetSIDToGIDMapping: TdxPDFSmallIntegerDictionary;
begin
  case FID of
    pcExpert:
      Result := dxgType1FontExpertCharset;
    pcExpertSubset:
      Result := dxgType1FontExpertSubsetCharset;
  else
    Result := dxgType1FontISOAdobeCharset;
  end;
end;

{ TdxType1FontCIDGlyphGroupSelector }

constructor TdxType1FontCIDGlyphGroupSelector.Create;
begin
  inherited Create;
end;

class function TdxType1FontCIDGlyphGroupSelector.Parse(AStream: TdxFontFileStream;
  ACIDCount: Integer): TdxType1FontCIDGlyphGroupSelector;
begin
  case AStream.ReadByte of
    0:
      Result := TdxType1FontCIDGlyphGroupArraySelector.Create(AStream, ACIDCount);
    3:
      Result := TdxType1FontCIDGlyphGroupRangeSelector.Create(AStream, ACIDCount);
    else
      Result := nil;
  end;
end;

{ TdxType1FontCIDGlyphGroupRangeSelector }

constructor TdxType1FontCIDGlyphGroupRangeSelector.Create(AStream: TdxFontFileStream; ACIDCount: Integer);
var
  ARangeCount: SmallInt;
  APreviousCID, ACID: USHORT;
  I: Integer;
  ARange: TRange;
begin
  inherited Create;
  ARangeCount := AStream.ReadShort;
  if ARangeCount = 0 then
    TdxPDFUtils.RaiseTestException;
  APreviousCID := 0;
  SetLength(FRanges, ARangeCount);
  for I := 0 to ARangeCount - 1 do
  begin
    ACID := AStream.ReadUShort;
    ARange := TRange.Create(ACID, AStream.ReadByte);
    if ACID < APreviousCID then
      TdxPDFUtils.RaiseTestException;
    APreviousCID := ACID;
    FRanges[I] := ARange;
  end;
  FSentinel := AStream.ReadUShort;
  if (FSentinel <> ACIDCount) or (FSentinel <= APreviousCID) or (FRanges[0].First <> 0) then
    TdxPDFUtils.RaiseTestException;
end;

function TdxType1FontCIDGlyphGroupRangeSelector.GetGlyphGroupIndexes: TBytes;
var
  ARangeCount, I: Integer;
  ACID, AEndCid: USHORT;
  AGlyphGroupIndex: Byte;
  ARange: TRange;
begin
  SetLength(Result, FSentinel);
  ARangeCount := Length(FRanges);
  ACID := 0;
  AGlyphGroupIndex := FRanges[0].GlyphGroupIndex;
  for I := 1 to ARangeCount - 1 do
  begin
    ARange := FRanges[I];
    AEndCid := USHORT(ARange.First);
    while ACID < AEndCid do
    begin
      Result[ACID] := AGlyphGroupIndex;
      Inc(ACID);
    end;
    AGlyphGroupIndex := ARange.GlyphGroupIndex;
  end;
  while ACID < FSentinel do
  begin
    Result[ACID] := AGlyphGroupIndex;
    Inc(ACID);
  end;
end;

function TdxType1FontCIDGlyphGroupRangeSelector.GetDataLength: Integer;
begin
  Result := Length(FRanges) * 3 + 5;
end;

procedure TdxType1FontCIDGlyphGroupRangeSelector.Write(AStream: TdxFontFileStream);
var
  ARange: TRange;
begin
  AStream.WriteByte(3);
  AStream.WriteShort(Length(FRanges));
  for ARange in FRanges do
  begin
    AStream.WriteShort(ARange.First);
    AStream.WriteByte(ARange.GlyphGroupIndex);
  end;
  AStream.WriteShort(FSentinel);
end;

class function TdxType1FontCIDGlyphGroupRangeSelector.TRange.Create(AFirst: SmallInt; AGlyphGroupIndex: Byte): TRange;
begin
  Result.First := AFirst;
  Result.GlyphGroupIndex := AGlyphGroupIndex;
end;

{ TdxType1FontCIDGlyphGroupArraySelector }

constructor TdxType1FontCIDGlyphGroupArraySelector.Create(AStream: TdxFontFileStream; ACIDCount: Integer);
begin
  inherited Create;
  FGlyphGroupIndexes := AStream.ReadArray(ACIDCount);
end;

function TdxType1FontCIDGlyphGroupArraySelector.GetGlyphGroupIndexes: TBytes;
begin
  Result := FGlyphGroupIndexes;
end;

function TdxType1FontCIDGlyphGroupArraySelector.GetDataLength: Integer;
begin
  Result := Length(FGlyphGroupIndexes) + 1;
end;

procedure TdxType1FontCIDGlyphGroupArraySelector.Write(AStream: TdxFontFileStream);
begin
  AStream.WriteByte(0);
  AStream.WriteArray(FGlyphGroupIndexes);
end;

{ TdxType1CustomFontProgram }

constructor TdxType1CustomFontProgram.Create;
begin
  inherited Create;
  FStrokeWidth := DefaultStrokeWidth;
  FUniqueID := DefaultUniqueID;
end;

destructor TdxType1CustomFontProgram.Destroy;
begin
  FreeAndNil(FFontInfo);
  FreeAndNil(FPrivateData);
  inherited Destroy;
end;

function TdxType1CustomFontProgram.GetCompositeMapping(const ACidToGidMap: TSmallIntDynArray): TObject;
begin
  Result := TdxPDFCompositeFontCodePointMapping.Create(ACidToGidMap, nil);
end;

procedure TdxType1CustomFontProgram.SetFontInfo(const AValue: TdxType1FontInfo);
begin
  FreeAndNil(FFontInfo);
  FFontInfo := AValue;
end;

procedure TdxType1CustomFontProgram.SetPrivateData(const AValue: TdxType1FontPrivateData);
begin
  FreeAndNil(FPrivateData);
  FPrivateData := AValue;
end;

{ TdxType1FontCompactFontProgram }

constructor TdxType1FontCompactFontProgram.Create;
begin
  inherited Create;
  FCharStrings := TdxPDFBytesList.Create;
end;

constructor TdxType1FontCompactFontProgram.Create(AMajorVersion, AMinorVersion: Byte; const AFontName: string;
  AStringIndex: TdxCompactFontFormatStringIndex; AGlobalSubrs: TdxPDFBytesList);
begin
  Create;
  FontBBox := DefaultFontBBox;
  FontName := AFontName;
  FontInfo := TdxType1FontInfo.Create;
  FFontType := DefaultFontType;
  PaintType := ptFilled;
  FontMatrix := DefaultFontMatrix;
  FMajorVersion := AMajorVersion;
  FMinorVersion := AMinorVersion;
  FStringIndex := AStringIndex;
  FGlobalSubrs := TdxPDFBytesList.Create;
  if AGlobalSubrs <> nil then
    FGlobalSubrs.AddRange(AGlobalSubrs);
  FCharset := TdxType1FontPredefinedCharset.Create(pcISOAdobe);
  FEncoding := TdxType1FontPredefinedEncoding.Create(peStandardEncoding);
end;

destructor TdxType1FontCompactFontProgram.Destroy;
begin
  FreeAndNil(FCharStrings);
  FreeAndNil(FCharset);
  FreeAndNil(FStringIndex);
  FreeAndNil(FGlobalSubrs);
  FreeAndNil(FEncoding);
  inherited Destroy;
end;

class function TdxType1FontCompactFontProgram.DefaultFontBBox: TdxRectF;
begin
  Result := dxNullRectF;
end;

class function TdxType1FontCompactFontProgram.DefaultFontMatrix: TdxCompactFontFormatTarnsformationMatrix;
begin
  Result := TXForm.CreateIdentityMatrix;
  Result.eM11 := 0.001;
  Result.eM22 := 0.001;
end;

class function TdxType1FontCompactFontProgram.DefaultFontType: TdxType1FontType;
begin
  Result := ftType2;
end;

class function TdxType1FontCompactFontProgram.Parse(const AData: TBytes): TdxType1FontCompactFontProgram;

 function ReadFontName(AStream: TdxFontFileStream): string;
 var
   ANameIndex: TdxCompactFontFormatNameIndex;
 begin
   ANameIndex := TdxCompactFontFormatNameIndex.Create(AStream);
   try
     if Length(ANameIndex.Strings) = 1 then
       Result := ANameIndex.Strings[0]
     else
       TdxPDFUtils.RaiseException;
   finally
     ANameIndex.Free;
   end;
 end;

var
  AMajorVersion, AMinorVersion: Byte;
  AStream: TdxFontFileStream;
  ABinaryIndex: TdxCompactFontFormatBinaryIndex;
  ATopDictIndex: TdxCompactFontFormatTopDictIndex;
  AStringIndex: TdxCompactFontFormatStringIndex;
  AFontName: string;
begin
  AStream := TdxFontFileStream.Create(AData);
  try
    AMajorVersion := AStream.ReadByte;
    AMinorVersion := AStream.ReadByte;
    AStream.Position := AStream.ReadByte;
    AFontName := ReadFontName(AStream);
    ATopDictIndex := TdxCompactFontFormatTopDictIndex.Create(AStream);
    AStringIndex := TdxCompactFontFormatStringIndex.Create(AStream);
    ABinaryIndex := TdxCompactFontFormatBinaryIndex.Create(AStream);
    try
      Result := TdxCompactFontFormatTopDictIndexParser.Parse(AMajorVersion, AMinorVersion, AFontName, AStringIndex,
        ABinaryIndex.Data, AStream, ATopDictIndex.ObjectData);
    finally
      ABinaryIndex.Free;
      ATopDictIndex.Free;
    end;
  finally
    AStream.Free;
  end;
end;

procedure TdxType1FontCompactFontProgram.SetFontType(const AValue: TdxType1FontType);
begin
  FFontType := AValue;
end;

procedure TdxType1FontCompactFontProgram.SetCharset(const AValue: TdxType1FontCustomCharset);
begin
  FreeAndNil(FCharset);
  FCharset := AValue;
end;

procedure TdxType1FontCompactFontProgram.SetCharStrings(const AValue: TdxPDFBytesList);
begin
  FCharStrings.Clear;
  FCharStrings.AddRange(AValue);
end;

procedure TdxType1FontCompactFontProgram.SetEncoding(const AValue: TdxType1FontEncoding);
begin
  FreeAndNil(FEncoding);
  FEncoding := AValue;
end;

function TdxType1FontCompactFontProgram.FontType: TdxType1FontType;
begin
  Result := FFontType;
end;

function TdxType1FontCompactFontProgram.GetSimpleMapping(AFontEncoding: TdxPDFSimpleFontEncoding): TObject;
var
  ASidTGoGidMapping: TdxPDFSmallIntegerDictionary;
  ACodeToGIDMapping: TSmallIntDynArray;
  AGid, ASid, I: SmallInt;
  APair: TPair<Integer, string>;
  AGlyphName: string;
begin
  ASidTGoGidMapping := FCharset.SidToGidMapping;
  if AFontEncoding.ShouldUseEmbeddedFontEncoding then
  begin
    ACodeToGIDMapping := FEncoding.GetCodeToGIDMapping(FCharset, FStringIndex);
    for APair in AFontEncoding.Differences do
    begin
      ASid := FStringIndex.TryGetSID(APair.Value);
      if (ASid <> 0) and ASidTGoGidMapping.TryGetValue(ASid, AGid) then
        ACodeToGIDMapping[APair.Key] := AGid;
    end;
  end
  else
  begin
    SetLength(ACodeToGIDMapping, 256);
    for I := 0 to 256 - 1 do
    begin
      AGlyphName := AFontEncoding.GetGlyphName(Byte(I));
      if AGlyphName <> TdxGlyphNames._notdef then
      begin
        ASid := FStringIndex.TryGetSID(AGlyphName);
        if (ASid <> 0) and ASidTGoGidMapping.TryGetValue(ASid, AGid) then
          ACodeToGIDMapping[I] := AGid;
      end;
    end;
  end;
  Result := TdxPDFSimpleFontCodePointMapping.Create(ACodeToGIDMapping,
    TdxPDFFontProgramFacade.GetUnicodeMapping(AFontEncoding));
end;

function TdxType1FontCompactFontProgram.Validate: Boolean;
begin
  Result := False;
end;

{ TdxType1FontCompactCIDFontProgram }

constructor TdxType1FontCompactCIDFontProgram.Create;
begin
  inherited Create;
  FUIDBase := dxPDFInvalidValue;
  FGlyphGroupData := TObjectList<TdxType1FontCIDGlyphGroupData>.Create;
  FCIDCount := DefaultCIDCount;
end;

destructor TdxType1FontCompactCIDFontProgram.Destroy;
begin
  FreeAndNil(FGlyphGroupData);
  FreeAndNil(FGlyphGroupSelector);
  inherited Destroy;
end;

function TdxType1FontCompactCIDFontProgram.GetCompositeMapping(const ACidToGidMap: TSmallIntDynArray): TObject;
var
  AMapping: TdxPDFSmallIntegerDictionary;
begin
  if Charset <> nil then
  begin
    AMapping := TdxPDFSmallIntegerDictionary.Create;
    AMapping.Assign(Charset.SidToGidMapping)
  end
  else
    AMapping := nil;
  Result := TdxPDFCompositeFontCodePointMapping.Create(ACidToGidMap, AMapping);
end;

function TdxType1FontCompactCIDFontProgram.Validate: Boolean;
var
  I: Integer;
  APatched: Boolean;
  AGlyphGroup: TdxType1FontCIDGlyphGroupData;
begin
  APatched := False;
  for I := 0 to FGlyphGroupData.Count - 1 do
  begin
    AGlyphGroup := FGlyphGroupData[I];
    if not TXForm.IsEqual(FontMatrix, AGlyphGroup.FontMatrix) then
    begin
      AGlyphGroup.FontMatrix := FontMatrix;
      APatched := True;
    end;
  end;
  Result := inherited Validate or APatched;
end;

procedure TdxType1FontCompactCIDFontProgram.SetGlyphGroupData(const AValue: TObjectList<TdxType1FontCIDGlyphGroupData>);
begin
  FreeAndNil(FGlyphGroupData);
  FGlyphGroupData := AValue;
end;

procedure TdxType1FontCompactCIDFontProgram.SetGlyphGroupSelector(const AValue: TdxType1FontCIDGlyphGroupSelector);
begin
  FreeAndNil(FGlyphGroupSelector);
  FGlyphGroupSelector := AValue;
end;

{ TdxPDFType1FontClassicFontProgram }

class function TdxPDFType1FontClassicFontProgram.Parse(const AFontName: string; AFontFileData: TdxPDFType1FontFileData):
  TdxPDFType1FontClassicFontProgram;
var
  ACipherData, APlainTextData, AData: TBytes;
  I, APlainTextLength: Integer;
  AInterpreter: TdxPDFPostScriptInterpreter;
  AOperators: TdxPDFReferencedObjects;
  AParser: TdxPDFPostScriptFileParser;
  AFontDirectory, AFontProgramDictionary: TdxPDFPostScriptDictionary;
  ACipher: TdxPDFType1FontEexecCipher;
  AObj: TdxPDFReferencedObject;
begin
  Result := nil;
  AData := AFontFileData.Data;
  APlainTextLength := AFontFileData.PlainTextLength;
  AParser := TdxPDFPostScriptFileParser.Create;
  AInterpreter := TdxPDFPostScriptInterpreter.Create;
  try
    SetLength(APlainTextData, APlainTextLength);
    TdxPDFUtils.CopyData(AData, 0, APlainTextData, 0, APlainTextLength);
    AOperators := AParser.Read(APlainTextData);
    try
      AInterpreter.Execute(AOperators);
    finally
      AOperators.Free;
    end;
    if AInterpreter.Stack.Count > 0 then
    begin
      AFontProgramDictionary := AInterpreter.Stack.Peek as TdxPDFPostScriptDictionary;
      if AFontProgramDictionary <> nil then
      begin
        ACipher := TdxPDFType1FontEexecCipher.CreateCipher(AData, APlainTextLength, AFontFileData.CipherTextLength);
        try
          ACipherData := ACipher.Decrypt;
        finally
          ACipher.Free;
        end;
        AInterpreter.Execute(ACipherData);
        AFontDirectory := AInterpreter.FontDirectory;
        if AFontDirectory.TryGetValue(AFontName, AObj) then
        begin
          Result := AObj as TdxPDFType1FontClassicFontProgram;
          Result.Reference;
        end
        else
          for I := 0 to AFontDirectory.Count - 1 do
            if AFontDirectory[I].Value is TdxPDFType1FontClassicFontProgram then
            begin
              Result := TdxPDFType1FontClassicFontProgram(AFontDirectory[I].Value);
              Result.Reference;
            end;
      end;
    end;
  finally
    AParser.Free;
    AInterpreter.Free;
  end;
end;

destructor TdxPDFType1FontClassicFontProgram.Destroy;
begin
  CharStrings := nil;
  Metrics := nil;
  FreeAndNil(FEncoding);
  inherited Destroy;
end;

procedure TdxPDFType1FontClassicFontProgram.Read(ADictionary: TdxPDFPostScriptDictionary);
var
  I: Integer;
  AEntry: TdxPDFPostScriptDictionaryEntry;
begin
  for I := 0 to ADictionary.Count - 1 do
  begin
    AEntry := ADictionary[I];
    ReadFontInfo(AEntry);
    ReadEncoding(AEntry);
    ReadFontType(AEntry);
    ReadPaintType(AEntry);
    if AEntry.Key = FontNameDictionaryKey then
      FontName := TdxPDFUtils.ConvertToStr(AEntry.Value);
    if AEntry.Key = UniqueIDDictionaryKey then
      UniqueID := TdxPDFUtils.ConvertToInt(AEntry.Value, DefaultUniqueID);
    if AEntry.Key = StrokeWidthDictionaryKey then
      StrokeWidth := TdxPDFUtils.ConvertToDouble(AEntry.Value, DefaultStrokeWidth);
    if AEntry.Key = WModeDictionaryKey then
      WMode := TdxType1FontWMode(TdxPDFUtils.ConvertToInt(AEntry.Value, 0));
    if AEntry.Value is TdxPDFArray then
    begin
      if AEntry.Key = FontMatrixDictionaryKey then
        FontMatrix := TdxPDFUtils.ArrayToMatrix(TdxPDFArray(AEntry.Value)).XForm;
      if AEntry.Key = FontBBoxDictionaryKey then
        FontBBox := TdxPDFUtils.ArrayToRectF(TdxPDFArray(AEntry.Value));
    end;
    if AEntry.Key = MetricsDictionaryKey then
      Metrics := AEntry.Value as TdxPDFPostScriptDictionary;
    if AEntry.Key = CharStringsDictionaryKey then
      CharStrings := AEntry.Value as TdxPDFPostScriptDictionary;
    PrivateData := TdxType1FontClassicFontPrivateData.Create;
  end;
end;

function TdxPDFType1FontClassicFontProgram.FontType: TdxType1FontType;
begin
  Result := FFontType;
end;

function TdxPDFType1FontClassicFontProgram.GetSimpleMapping(AFontEncoding: TdxPDFSimpleFontEncoding): TObject;
var
  AMapping: TdxPDFStringSmallIntegerDictionary;
  AGlyphIndex, I: SmallInt;
  AEntry: TdxPDFPostScriptDictionaryEntry;
  AGlyphName: string;
  ACharset: TSmallIntDynArray;
  ACount: Integer;
  AActualEncoding: TDictionary<Byte, string>;
  AIndex: Byte;
  ADifference: TPair<Integer, string>;
begin
  AMapping := TdxPDFStringSmallIntegerDictionary.Create;
  try
    AMapping.Add(TdxGlyphNames._notdef, 0);
    AGlyphIndex := 1;
    for I := 0 to FCharStrings.Count - 1 do
    begin
      AEntry := FCharStrings[I];
      AGlyphName := AEntry.Key;
      if AGlyphName <> TdxGlyphNames._notdef then
      begin
        if not AMapping.ContainsKey(AGlyphName) then
          AMapping.Add(AGlyphName, AGlyphIndex);
        Inc(AGlyphIndex);
      end;
    end;
    SetLength(ACharset, 256);
    if AFontEncoding.ShouldUseEmbeddedFontEncoding then
    begin
      ACount := FEncoding.Count;
      AActualEncoding := TDictionary<Byte, string>.Create(ACount);
      try
        for I := 0 to ACount - 1 do
        begin
          AGlyphName := FEncoding[I];
          if AGlyphName <> TdxGlyphNames._notdef then
          begin
            AIndex := Byte(I);
            AActualEncoding.Add(AIndex, AGlyphName);
            if AMapping.TryGetValue(AGlyphName, AGlyphIndex) then
              ACharset[AIndex] := AGlyphIndex;
          end;
        end;
      finally
        AActualEncoding.Free;
      end;
      for ADifference in AFontEncoding.Differences do
        if AMapping.TryGetValue(ADifference.Value, AGlyphIndex) then
          ACharset[Byte(ADifference.Key)] := AGlyphIndex;
    end
    else
      for I := 0 to 255 do
      begin
        AGlyphName := AFontEncoding.GetGlyphName(Byte(I));
        if (AGlyphName <> TdxGlyphNames._notdef) and AMapping.TryGetValue(AGlyphName, AGlyphIndex) then
          ACharset[Byte(I)] := AGlyphIndex;
      end;
  finally
    AMapping.Free;
  end;
  Result := TdxPDFSimpleFontCodePointMapping.Create(ACharset, TdxPDFFontProgramFacade.GetUnicodeMapping(AFontEncoding));
end;

function TdxPDFType1FontClassicFontProgram.ToPostScript: string;
var
  ABuilder: TStringBuilder;
  AFontName, AGlyphName: string;
  AFontInfo: TdxPDFType1FontClassicFontInfo;
  AEncodingLength, I, AUniqueID: Integer;
  AFontBBox: TdxRectF;
  AStrokeWidth: Double;
begin
  ABuilder := TdxStringBuilderManager.Get;
  try
    AFontName := FontName;
    AFontInfo := FontInfo as TdxPDFType1FontClassicFontInfo;

    if AFontInfo = nil then
      ABuilder.Append('%' + Format('!FontType1-1.0: %s %s'#10, [AFontName, '001.001']))
    else
      ABuilder.Append('%' + Format('!FontType1-1.0: %s %s'#10, [AFontName, AFontInfo.Version]));
    ABuilder.Append('11 dict begin'#10);
    if AFontInfo <> nil then
      ABuilder.Append(Format('/%s %s readonly def'#10, ['FontInfo', AFontInfo.Serialize]));
    ABuilder.Append(Format('/%s /%s def'#10, [FontNameDictionaryKey, AFontName]));
    ABuilder.Append(Format('/%s 256 array 0 1 255 {1 index exch /.notdef put} for'#10, [EncodingDictionaryKey]));
    AEncodingLength := FEncoding.Count;
    for I := 0 to AEncodingLength - 1 do
    begin
      AGlyphName := FEncoding[I];
      if AGlyphName <> TdxGlyphNames._notdef then
        ABuilder.Append(Format('dup %d /%s put'#10, [I, AGlyphName]));
    end;
    ABuilder.Append('readonly def'#10);
    ABuilder.Append(Format(SerializationPattern, [PaintTypeDictionaryKey, Integer(PaintType)]));
    ABuilder.Append(Format(SerializationPattern, [FontTypeDictionaryKey, Integer(FontType)]));
    ABuilder.Append(Format('/%s [%s %s %s %s %s %s] readonly def'#10, [FontMatrixDictionaryKey,
      DoubleAsString(FontMatrix.eM11, 3, 0), DoubleAsString(FontMatrix.eM12, 3, 0),
      DoubleAsString(FontMatrix.eM21, 3, 0), DoubleAsString(FontMatrix.eM22, 3, 0),
      DoubleAsString(FontMatrix.eDx, 3, 0), DoubleAsString(FontMatrix.eDy, 3, 0)]));

    AFontBBox := FontBBox;
    ABuilder.Append(Format('/%s {%s %s %s %s} readonly def'#10, [FontBBoxDictionaryKey,
      DoubleAsString(AFontBBox.Left, 5, 0), DoubleAsString(AFontBBox.Bottom, 5, 0),
      DoubleAsString(AFontBBox.Right, 5, 0), DoubleAsString(AFontBBox.Top, 5, 0)]));

    AUniqueID := UniqueID;
    if AUniqueID <> DefaultUniqueID then
      ABuilder.Append(Format(SerializationPattern, [UniqueIDDictionaryKey, AUniqueID]));
    if FMetrics <> nil then
    begin
      ABuilder.Append(Format('/%s 1 dict dup begin'#10, [MetricsDictionaryKey]));
      ABuilder.Append('end def'#10);
    end;
    AStrokeWidth := StrokeWidth;
    if AStrokeWidth <> DefaultStrokeWidth then
      ABuilder.Append(Format('/%s %f def'#10, [StrokeWidthDictionaryKey, AStrokeWidth]));
    if WMode <> wmHorizontal then
      ABuilder.Append(Format(SerializationPattern, [WModeDictionaryKey, Integer(WMode)]));
    ABuilder.Append('currentdict end'#10);
    ABuilder.Append('currentfile eexec'#10);
    Result := ABuilder.ToString;
  finally
    TdxStringBuilderManager.Release(ABuilder);
  end;
end;

procedure TdxPDFType1FontClassicFontProgram.Validate(AFont: TdxPDFCustomFont);
begin
  if FontBBox.IsZero then
    FontBBox := AFont.FontBBox;
  FontName := AFont.UniqueName;
end;

procedure TdxPDFType1FontClassicFontProgram.ReadEncoding(AEntry: TdxPDFPostScriptDictionaryEntry);
var
  I: Integer;
  AEncoding: TStringList;
  AObject: TdxPDFReferencedObject;
  AArray: TdxPDFArray;
begin
  if AEntry.Key = EncodingDictionaryKey then
  begin
    AObject := AEntry.Value;
    AEncoding := TStringList.Create;
    if AObject is TdxPDFArray then
    begin
      AArray := TdxPDFArray(AObject);
      for I := 0 to AArray.ElementList.Count - 1 do
        if AArray.ElementList[I] = nil then
          AEncoding.Add(TdxGlyphNames._notdef)
        else
          if AArray.ElementList[I] is TdxPDFString then
            AEncoding.Add(TdxPDFString(AArray.ElementList[I]).Value);
    end;
    Encoding := AEncoding;
  end;
end;

procedure TdxPDFType1FontClassicFontProgram.ReadFontInfo(AEntry: TdxPDFPostScriptDictionaryEntry);
begin
  if (AEntry.Key = FontInfoDictionaryKey) and (AEntry.Value is TdxPDFPostScriptDictionary) then
  begin
    FontInfo := TdxPDFType1FontClassicFontInfo.Create;
    FontInfo.Read(TdxPDFPostScriptDictionary(AEntry.Value));
  end;
end;

procedure TdxPDFType1FontClassicFontProgram.ReadFontType(AEntry: TdxPDFPostScriptDictionaryEntry);
begin
  if AEntry.Key = FontTypeDictionaryKey then
    FFontType := TdxType1FontType(TdxPDFUtils.ConvertToInt(AEntry.Value, -1));
end;

procedure TdxPDFType1FontClassicFontProgram.ReadPaintType(AEntry: TdxPDFPostScriptDictionaryEntry);
begin
  if AEntry.Key = PaintTypeDictionaryKey then
    PaintType := TdxType1FontPaintType(TdxPDFUtils.ConvertToInt(AEntry.Value, -1));
end;

procedure TdxPDFType1FontClassicFontProgram.SetCharStrings(const AValue: TdxPDFPostScriptDictionary);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FCharStrings));
end;

procedure TdxPDFType1FontClassicFontProgram.SetEncoding(const AValue: TStringList);
begin
  FreeAndNil(FEncoding);
  FEncoding := AValue;
end;

procedure TdxPDFType1FontClassicFontProgram.SetMetrics(const AValue: TdxPDFPostScriptDictionary);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FMetrics));
end;

{ TdxCompactFontFormatDictIndexOperator }

constructor TdxCompactFontFormatDictIndexOperator.Create;
begin
  inherited Create;
end;

constructor TdxCompactFontFormatDictIndexOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create;
end;

class function TdxCompactFontFormatDictIndexOperator.Code: Byte;
begin
  Result := 0;
end;

function TdxCompactFontFormatDictIndexOperator.GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := 1;
end;

procedure TdxCompactFontFormatDictIndexOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  TdxPDFUtils.RaiseTestException;
end;

procedure TdxCompactFontFormatDictIndexOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  TdxPDFUtils.RaiseTestException;
end;

procedure TdxCompactFontFormatDictIndexOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  TdxPDFUtils.RaiseTestException;
end;

procedure TdxCompactFontFormatDictIndexOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  AStream.WriteByte(Code);
end;

function TdxCompactFontFormatDictIndexOperator.GetBoolean(AOperands: TDoubleDynArray): Boolean;
begin
  Result := GetInteger(AOperands) = 1;
end;

function TdxCompactFontFormatDictIndexOperator.GetDouble(AOperands: TDoubleDynArray): Double;
begin
  Result := AOperands[0];
end;

function TdxCompactFontFormatDictIndexOperator.GetDoubleArray(AOperands: TDoubleDynArray): TDoubleDynArray;
var
  I, ALength: Integer;
  APrevious, AValue: Double;
begin
  APrevious := 0;
  ALength := Length(AOperands);
  SetLength(Result, ALength);
  for I := 0 to ALength - 1 do
  begin
    AValue := AOperands[I] + APrevious;
    Result[I] := AValue;
    APrevious := AValue;
  end;
end;

function TdxCompactFontFormatDictIndexOperator.GetInteger(AOperands: TDoubleDynArray): Integer;
begin
  Result := -1;
  if Length(AOperands) = 1 then
    Result := Trunc(AOperands[0])
  else
    TdxPDFUtils.RaiseException;
end;

function TdxCompactFontFormatDictIndexOperator.GetGlyphZones(AOperands: TDoubleDynArray): TdxType1FontGlyphZones;
var
  I, ACount, AIndex: Integer;
  APrevious, ABottom, ATop: Double;
begin
  ACount := Length(AOperands);
  if ACount mod 2 <> 0 then
    TdxPDFUtils.RaiseTestException;
  ACount := ACount div 2;
  AIndex := 0;
  APrevious := 0;
  SetLength(Result, ACount);
  for I := 0 to ACount - 1 do
  begin
    ABottom := AOperands[AIndex] + APrevious;
    ATop := AOperands[AIndex + 1] + ABottom;
    Result[I] := TdxType1FontGlyphZone.Create(ABottom, ATop);
    APrevious := ATop;
    Inc(AIndex, 2);
  end;
end;

function TdxCompactFontFormatDictIndexOperator.CalculateDoubleArraySize(const AArray: TDoubleDynArray): Integer;
var
  I: Integer;
  AValue, APrevious: Double;
begin
  Result := 0;
  APrevious := 0;
  for I := 0 to Length(AArray) - 1 do
  begin
    AValue := AArray[I];
    Inc(Result, CalculateDoubleSize(AValue - APrevious));
    APrevious := AValue;
  end;
end;

function TdxCompactFontFormatDictIndexOperator.CalculateDoubleSize(AValue: Double): Integer;
var
  AIntegerValue: Integer;
begin
  AIntegerValue := Trunc(AValue);
  if AIntegerValue = AValue then
    Result :=  CalculateIntegerSize(AIntegerValue)
  else
    Result := Length(DoubleAsString(AValue, 6, 0)) div 2 + 2;
end;

function TdxCompactFontFormatDictIndexOperator.CalculateIntegerSize(AValue: Integer): Integer;
begin
  if AValue >= 0 then
  begin
    if AValue > 32767 then
      Result := 5
    else
      if AValue > 1131 then
        Result := 3
      else
        Result := IfThen(AValue > 107, 2, 1);
  end
  else
  begin
    if AValue < -32768 then
      Result := 5
    else
      if AValue < -1131 then
        Result := 3
      else
        Result := IfThen(AValue < -107, 2, 1);
  end;
end;

function TdxCompactFontFormatDictIndexOperator.CalculateGlyphZonesSize(const AValue: TdxType1FontGlyphZones): Integer;
var
  I: Integer;
  APrevious, ABottom, ATop: Double;
  AGlyphZone: TdxType1FontGlyphZone;
begin
  Result := 0;
  APrevious := 0;
  for I := 0 to Length(AValue) - 1 do
  begin
    AGlyphZone := AValue[I];
    ABottom := AGlyphZone.Bottom;
    Inc(Result, CalculateDoubleSize(ABottom - APrevious));
    ATop := AGlyphZone.Top;
    Inc(Result, CalculateDoubleSize(ATop - ABottom));
    APrevious := ATop;
  end;
end;

function TdxCompactFontFormatDictIndexOperator.ToCIDFontProgram(
  AFontProgram: TdxType1FontCompactFontProgram): TdxType1FontCompactCIDFontProgram;
begin
  if AFontProgram is TdxType1FontCompactCIDFontProgram then
    Result := TdxType1FontCompactCIDFontProgram(AFontProgram)
  else
    Result := nil;
end;

procedure TdxCompactFontFormatDictIndexOperator.WriteBoolean(AStream: TdxFontFileStream; AValue: Boolean);
begin
  AStream.WriteByte(IfThen(AValue, 140, 139));
end;

procedure TdxCompactFontFormatDictIndexOperator.WriteDouble(AStream: TdxFontFileStream; AValue: Double);
var
  I, AIntegerValue, APrevIndex, ACount, AIndex: Integer;
  ANibbles: TBytes;
  AChar: Char;
  ADoubleAsString: string;
begin
  AIntegerValue := Trunc(AValue);
  if AIntegerValue = AValue then
    WriteInteger(AStream, AIntegerValue)
  else
  begin
    ADoubleAsString := DoubleAsString(AValue, 7, 0);
    SetLength(ANibbles, 0);
    for I := 1 to Length(ADoubleAsString) do
    begin
      AChar := ADoubleAsString[I];
      case AChar of
        '.', ',':
          TdxPDFUtils.AddByte(10, ANibbles);
        'E':
          TdxPDFUtils.AddByte(11, ANibbles);
        '-':
          begin
            APrevIndex := length(ANibbles) - 1;
            if APrevIndex >= 0 then
              ANibbles[APrevIndex] := 12
            else
              TdxPDFUtils.AddByte(14, ANibbles);
          end;
      else
        TdxPDFUtils.AddByte(Byte(AChar) - 48, ANibbles);
      end;
    end;
    TdxPDFUtils.AddByte(15, ANibbles);
    ACount := Length(ANibbles);
    if ACount mod 2 > 0 then
    begin
      TdxPDFUtils.AddByte(15, ANibbles);
      Inc(ACount);
    end;
    AStream.WriteByte(30);
    AIndex := 0;
    for I := 0 to ACount - 1 do
    begin
      AStream.WriteByte((ANibbles[AIndex] shl 4) + ANibbles[AIndex + 1]);
      Inc(AIndex, 2);
      if AIndex >= ACount then
        Break;
    end;
  end;
end;

procedure TdxCompactFontFormatDictIndexOperator.WriteDoubleArray(AStream: TdxFontFileStream;
  const AValue: TDoubleDynArray);
var
  I: Integer;
  ACurrentValue, APreviousValue: Double;
begin
  APreviousValue := 0;
  for I := 0 to Length(AValue) - 1 do
  begin
    ACurrentValue := AValue[I];
    WriteDouble(AStream, ACurrentValue - APreviousValue);
    APreviousValue := ACurrentValue;
  end;
end;

procedure TdxCompactFontFormatDictIndexOperator.WriteInteger(AStream: TdxFontFileStream; AValue: Integer);
begin
  if (AValue > 32767) or (AValue < -32768) then
  begin
    AStream.WriteByte(29);
    AStream.WriteByte(AValue shr 24);
    AStream.WriteByte((AValue shr 16) and $FF);
    AStream.WriteByte((AValue shr 8) and $FF);
    AStream.WriteByte(AValue and $FF);
  end
  else
    if (AValue > 1131) or (AValue < -1131) then
    begin
      AStream.WriteByte(28);
      AStream.WriteByte(AValue shr 8);
      AStream.WriteByte(AValue and $FF);
    end
    else
      if AValue >= 108 then
      begin
        Dec(AValue, 108);
        AStream.WriteByte(AValue div 256 + 247);
        AStream.WriteByte(AValue mod 256);
      end
      else
        if AValue <= -108 then
        begin
          AValue := -AValue - 108;
          AStream.WriteByte(AValue div 256 + 251);
          AStream.WriteByte(AValue mod 256);
        end
        else
          AStream.WriteByte(AValue + 139);
end;

procedure TdxCompactFontFormatDictIndexOperator.WriteGlyphZones(AStream: TdxFontFileStream;
  const AValue: TdxType1FontGlyphZones);
var
  I: Integer;
  APrevious, ABottom, ATop: Double;
  AGlyphZone: TdxType1FontGlyphZone;
begin
  APrevious := 0.0;
  for I := 0 to Length(AValue) - 1 do
  begin
    AGlyphZone := AValue[I];
    ABottom := AGlyphZone.Bottom;
    WriteDouble(AStream, ABottom - APrevious);
    ATop := AGlyphZone.Top;
    WriteDouble(AStream, ATop - ABottom);
    APrevious := ATop;
  end;
end;

{ TdxCompactFontFormatDictIndexStringOperator }

constructor TdxCompactFontFormatDictIndexStringOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create(AStringIndex.GetString(AOperands));
end;

constructor TdxCompactFontFormatDictIndexStringOperator.Create(const AValue: string);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatDictIndexStringOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(AStringIndex.GetSID(FValue));
end;

procedure TdxCompactFontFormatDictIndexStringOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, AStringIndex.GetSID(FValue));
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexIntegerOperator }

constructor TdxCompactFontFormatDictIndexIntegerOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create(GetInteger(AOperands));
end;

constructor TdxCompactFontFormatDictIndexIntegerOperator.Create(AValue: Integer);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatDictIndexIntegerOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(Value);
end;

procedure TdxCompactFontFormatDictIndexIntegerOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, Value);
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexDoubleOperator }

constructor TdxCompactFontFormatDictIndexDoubleOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create(GetDouble(AOperands));
end;

constructor TdxCompactFontFormatDictIndexDoubleOperator.Create(AValue: Double);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatDictIndexDoubleOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateDoubleSize(Value);
end;

procedure TdxCompactFontFormatDictIndexDoubleOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteDouble(AStream, Value);
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexXUIDOperator }

constructor TdxCompactFontFormatDictIndexXUIDOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
var
  I, ALength: Integer;
begin
  inherited Create(AStringIndex, AOperands);
  ALength := Length(AOperands);
  SetLength(FXUID, ALength);
  for I := 0 to ALength - 1 do
    FXUID[I] := Trunc(AOperands[I]);
end;

constructor TdxCompactFontFormatDictIndexXUIDOperator.Create(const AXUID: TIntegerDynArray);
begin
  Create;
  FXUID := AXUID;
end;

class function TdxCompactFontFormatDictIndexXUIDOperator.Code: Byte;
begin
  Result := 14;
end;

function TdxCompactFontFormatDictIndexXUIDOperator.GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer;
var
  I, ASize: Integer;
begin
  ASize := 0;
  for I := 0 to Length(FXUID) - 1 do
    Inc(ASize, CalculateIntegerSize(FXUID[I]));
  Result := inherited GetSize(AStringIndex) + ASize;
end;

procedure TdxCompactFontFormatDictIndexXUIDOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.XUID := FXUID;
end;

procedure TdxCompactFontFormatDictIndexXUIDOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
var
  I: Integer;
begin
  for I := 0 to Length(FXUID) - 1 do
    WriteInteger(AStream, FXUID[I]);
  AStream.WriteByte(Code);
end;

{ TdxCompactFontFormatDictIndexNoticeOperator }

class function TdxCompactFontFormatDictIndexNoticeOperator.Code: Byte;
begin
  Result := 1;
end;

procedure TdxCompactFontFormatDictIndexNoticeOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.Notice := Value;
end;

{ TdxCompactFontFormatDictIndexWeightOperator }

class function TdxCompactFontFormatDictIndexWeightOperator.Code: Byte;
begin
  Result := 4;
end;

procedure TdxCompactFontFormatDictIndexWeightOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.Weight := Value;
end;

{ TdxCompactFontFormatDictIndexFamilyNameOperator }

class function TdxCompactFontFormatDictIndexFamilyNameOperator.Code: Byte;
begin
  Result := 3;
end;

procedure TdxCompactFontFormatDictIndexFamilyNameOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.FamilyName := Value;
end;

{ TdxCompactFontFormatDictIndexFontBBoxOperator }

constructor TdxCompactFontFormatDictIndexFontBBoxOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
var
  AFontBBox: TdxRectF;
begin
  if Length(AOperands) = 4 then
  begin
    AFontBBox.Left := AOperands[0];
    AFontBBox.Bottom := AOperands[1];
    AFontBBox.Right := AOperands[2];
    AFontBBox.Top := AOperands[3];
  end
  else
    AFontBBox := dxNullRectF;
  Create(AFontBBox);
end;

constructor TdxCompactFontFormatDictIndexFontBBoxOperator.Create(const AFontBBox: TdxRectF);
begin
  Create;
  FFontBBox := AFontBBox;
end;

class function TdxCompactFontFormatDictIndexFontBBoxOperator.Code: Byte;
begin
  Result := 5;
end;

procedure TdxCompactFontFormatDictIndexFontBBoxOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontBBox := FFontBBox;
end;

function TdxCompactFontFormatDictIndexFontBBoxOperator.GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateDoubleSize(FFontBBox.Left) + CalculateDoubleSize(FFontBBox.Bottom) +
    CalculateDoubleSize(FFontBBox.Right) + CalculateDoubleSize(FFontBBox.Top);
end;

procedure TdxCompactFontFormatDictIndexFontBBoxOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteDouble(AStream, FFontBBox.Left);
  WriteDouble(AStream, FFontBBox.Bottom);
  WriteDouble(AStream, FFontBBox.Right);
  WriteDouble(AStream, FFontBBox.Top);
  AStream.WriteByte(Code);
end;

{ TdxCompactFontFormatDictIndexUniqueIDOperator }

class function TdxCompactFontFormatDictIndexUniqueIDOperator.Code: Byte;
begin
  Result := 13;
end;

procedure TdxCompactFontFormatDictIndexUniqueIDOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.UniqueID := Value;
end;

procedure TdxCompactFontFormatDictIndexUniqueIDOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  AGlyphGroupData.UniqueID := Value;
end;

{ TdxCompactFontFormatDictIndexBaseFontNameOperator }

class function TdxCompactFontFormatDictIndexBaseFontNameOperator.Code: Byte;
begin
  Result := 22;
end;

procedure TdxCompactFontFormatDictIndexBaseFontNameOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.BaseFontName := Value;
end;

{ TdxCompactFontFormatDictIndexTwoByteOperator }

function TdxCompactFontFormatDictIndexTwoByteOperator.GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := 2;
end;

procedure TdxCompactFontFormatDictIndexTwoByteOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  AStream.WriteByte(Marker);
  AStream.WriteByte(Code);
end;

{ TdxCompactFontFormatDictIndexIntegerTwoByteOperator }

constructor TdxCompactFontFormatDictIndexIntegerTwoByteOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create(GetInteger(AOperands));
  FValue := GetInteger(AOperands);
end;

constructor TdxCompactFontFormatDictIndexIntegerTwoByteOperator.Create(AValue: Integer);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatDictIndexIntegerTwoByteOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(FValue);
end;

procedure TdxCompactFontFormatDictIndexIntegerTwoByteOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, FValue);
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexDoubleTwoByteOperator }

constructor TdxCompactFontFormatDictIndexDoubleTwoByteOperator.Create(
  AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray);
begin
  Create(GetDouble(AOperands));
end;

constructor TdxCompactFontFormatDictIndexDoubleTwoByteOperator.Create(AValue: Double);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatDictIndexDoubleTwoByteOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateDoubleSize(Value);
end;

procedure TdxCompactFontFormatDictIndexDoubleTwoByteOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteDouble(AStream, Value);
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexPaintTypeOperator }

constructor TdxCompactFontFormatDictIndexPaintTypeOperator.Create(APaintType: TdxType1FontPaintType);
begin
  inherited Create;
  FPaintType := APaintType;
end;

class function TdxCompactFontFormatDictIndexPaintTypeOperator.Code: Byte;
begin
  Result := 5;
end;

procedure TdxCompactFontFormatDictIndexPaintTypeOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.PaintType := FPaintType;
end;

procedure TdxCompactFontFormatDictIndexPaintTypeOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
// do nothing
end;

{ TdxCompactFontFormatDictIndexGlyphZonesOperator }

constructor TdxCompactFontFormatDictIndexGlyphZonesOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create(GetGlyphZones(AOperands));
end;

constructor TdxCompactFontFormatDictIndexGlyphZonesOperator.Create(const AValue: TdxType1FontGlyphZones);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatDictIndexGlyphZonesOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateGlyphZonesSize(Value);
end;

procedure TdxCompactFontFormatDictIndexGlyphZonesOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteGlyphZones(AStream, Value);
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexBaseFontBlendOperator }

constructor TdxCompactFontFormatDictIndexDoubleDynArrayOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create(GetDoubleArray(AOperands));
end;

constructor TdxCompactFontFormatDictIndexDoubleDynArrayOperator.Create(const AValue: TDoubleDynArray);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatDictIndexDoubleDynArrayOperator.GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateDoubleArraySize(Value);
end;

procedure TdxCompactFontFormatDictIndexDoubleDynArrayOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteDoubleArray(AStream, Value);
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexBaseFontBlendOperator }

class function TdxCompactFontFormatDictIndexBaseFontBlendOperator.Code: Byte;
begin
  Result := 23;
end;

procedure TdxCompactFontFormatDictIndexBaseFontBlendOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.BaseFontBlend := Value;
end;

{ TdxCompactFontFormatDictIndexCharstringTypeOperator }

constructor TdxCompactFontFormatDictIndexCharstringTypeOperator.Create(
  AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray);
begin
  Create(TdxType1FontType(GetInteger(AOperands)));
end;

constructor TdxCompactFontFormatDictIndexCharstringTypeOperator.Create(AFontType: TdxType1FontType);
begin
  Create;
  FFontType := AFontType;
end;

class function TdxCompactFontFormatDictIndexCharstringTypeOperator.Code: Byte;
begin
  Result := 6;
end;

procedure TdxCompactFontFormatDictIndexCharstringTypeOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.SetFontType(FFontType);
end;

procedure TdxCompactFontFormatDictIndexCharstringTypeOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  AGlyphGroupData.FontType := FFontType;
end;

function TdxCompactFontFormatDictIndexCharstringTypeOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + 1;
end;

procedure TdxCompactFontFormatDictIndexCharstringTypeOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, Integer(FFontType));
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexCIDCountOperator }

class function TdxCompactFontFormatDictIndexCIDCountOperator.Code: Byte;
begin
  Result := 34;
end;

procedure TdxCompactFontFormatDictIndexCIDCountOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
var
  ACIDFontProgram: TdxType1FontCompactCIDFontProgram;
begin
  ACIDFontProgram := ToCIDFontProgram(AFontProgram);
  if ACIDFontProgram <> nil then
    ACIDFontProgram.CIDCount := Value
  else
    TdxPDFUtils.RaiseTestException;
end;

procedure TdxCompactFontFormatDictIndexCIDCountOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  AGlyphGroupData.CIDCount := Value;
end;

{ TdxCompactFontFormatDictIndexCIDFontVersionOperator }

class function TdxCompactFontFormatDictIndexCIDFontVersionOperator.Code: Byte;
begin
  Result := 31;
end;

procedure TdxCompactFontFormatDictIndexCIDFontVersionOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
var
  ACIDFontProgram: TdxType1FontCompactCIDFontProgram;
begin
  ACIDFontProgram := ToCIDFontProgram(AFontProgram);
  if ACIDFontProgram <> nil then
    ACIDFontProgram.CIDFontVersion := Value
  else
    TdxPDFUtils.RaiseTestException;
end;

{ TdxCompactFontFormatDictIndexStringTwoByteOperator }

constructor TdxCompactFontFormatDictIndexStringTwoByteOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create(AStringIndex.GetString(AOperands));
end;

constructor TdxCompactFontFormatDictIndexStringTwoByteOperator.Create(const AValue: string);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatDictIndexStringTwoByteOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(AStringIndex.GetSID(Value));
end;

procedure TdxCompactFontFormatDictIndexStringTwoByteOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, AStringIndex.GetSID(Value));

  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatDictIndexCopyrightOperator }

class function TdxCompactFontFormatDictIndexCopyrightOperator.Code: Byte;
begin
  Result := 0;
end;

procedure TdxCompactFontFormatDictIndexCopyrightOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.Copyright := Value;
end;

{ TdxCompactFontFormatDictIndexCharsetOperator }

constructor TdxCompactFontFormatDictIndexCharsetOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create;
  FOffset := GetInteger(AOperands);
end;

constructor TdxCompactFontFormatDictIndexCharsetOperator.Create(ACharset: TdxType1FontCustomCharset);
begin
  Create;
  FCharset := ACharset;
  FOffset := ACharset.Offset;
end;

class function TdxCompactFontFormatDictIndexCharsetOperator.Code: Byte;
begin
  Result := 15;
end;

function TdxCompactFontFormatDictIndexCharsetOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(FOffset);
end;

procedure TdxCompactFontFormatDictIndexCharsetOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
var
  ASize: Integer;
begin
  if FOffset in [Integer(pcISOAdobe), Integer(pcExpert), Integer(pcExpertSubset)] then
    FCharset := TdxType1FontPredefinedCharset.Create(TdxType1FontPredefinedCharsetID(FOffset))
  else
  begin
    if AFontProgram.CharStrings = nil then
      TdxPDFUtils.RaiseTestException;
    ASize := AFontProgram.CharStrings.Count - 1;
    AStream.Position := FOffset;
    FCharset := TdxType1FontCustomCharset.Parse(AStream, ASize);
  end;
  AFontProgram.Charset := FCharset;
end;

procedure TdxCompactFontFormatDictIndexCharsetOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, FOffset);
  inherited Write(AStream, AStringIndex);
end;

function TdxCompactFontFormatDictIndexCharsetOperator.GetLength: Integer;
begin
  Result := FCharset.DataLength;
end;

function TdxCompactFontFormatDictIndexCharsetOperator.GetOffset: Integer;
begin
  Result := FOffset;
end;

procedure TdxCompactFontFormatDictIndexCharsetOperator.SetOffset(const AValue: Integer);
begin
  FOffset := AValue;
end;

procedure TdxCompactFontFormatDictIndexCharsetOperator.WriteData(AStream: TdxFontFileStream);
begin
  FCharset.Write(AStream);
end;

{ TdxCompactFontFormatDictIndexCharStringsOperator }

constructor TdxCompactFontFormatDictIndexCharStringsOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create;
  FOffset := GetInteger(AOperands);
end;

constructor TdxCompactFontFormatDictIndexCharStringsOperator.Create(ACharStrings: TdxPDFBytesList);
begin
  Create;
  FCharStrings := TdxCompactFontFormatBinaryIndex.CreateEx(ACharStrings);
end;

destructor TdxCompactFontFormatDictIndexCharStringsOperator.Destroy;
begin
  FreeAndNil(FCharStrings);
  inherited Destroy;
end;

class function TdxCompactFontFormatDictIndexCharStringsOperator.Code: Byte;
begin
  Result := 17;
end;

function TdxCompactFontFormatDictIndexCharStringsOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(FOffset);
end;

procedure TdxCompactFontFormatDictIndexCharStringsOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AStream.Position := FOffset;
  FCharStrings := TdxCompactFontFormatBinaryIndex.Create(AStream);
  AFontProgram.CharStrings := FCharStrings.Data;
end;

procedure TdxCompactFontFormatDictIndexCharStringsOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, FOffset);
  inherited Write(AStream, AStringIndex);
end;

function TdxCompactFontFormatDictIndexCharStringsOperator.GetLength: Integer;
begin
  Result := FCharStrings.DataLength;
end;

function TdxCompactFontFormatDictIndexCharStringsOperator.GetOffset: Integer;
begin
  Result := FOffset;
end;

procedure TdxCompactFontFormatDictIndexCharStringsOperator.SetOffset(const AValue: Integer);
begin
  FOffset := AValue;
end;

procedure TdxCompactFontFormatDictIndexCharStringsOperator.WriteData(AStream: TdxFontFileStream);
begin
  FCharStrings.Write(AStream);
end;

{ TdxCompactFontFormatDictIndexEncodingOperator }

constructor TdxCompactFontFormatDictIndexEncodingOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create;
  FOffset := GetInteger(AOperands);
end;

constructor TdxCompactFontFormatDictIndexEncodingOperator.Create(AEncoding: TdxType1FontEncoding);
begin
  Create;
  FEncoding := AEncoding;
  FOffset := AEncoding.GetOffset;
end;

class function TdxCompactFontFormatDictIndexEncodingOperator.Code: Byte;
begin
  Result := 16;
end;

procedure TdxCompactFontFormatDictIndexEncodingOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
var
  AEncoding: TdxType1FontEncoding;
begin
  case FOffset of
    0:
      AEncoding := TdxType1FontPredefinedEncoding.Create(peStandardEncoding);
    1:
      AEncoding := TdxType1FontPredefinedEncoding.Create(peExpertEncoding);
  else
    AStream.Position := FOffset;
    AEncoding := TdxType1FontCustomEncoding.Parse(AStream);
  end;
  AFontProgram.Encoding := AEncoding;
end;

function TdxCompactFontFormatDictIndexEncodingOperator.GetLength: Integer;
begin
  Result := FEncoding.GetDataLength;
end;

function TdxCompactFontFormatDictIndexEncodingOperator.GetOffset: Integer;
begin
  Result := FOffset;
end;

function TdxCompactFontFormatDictIndexEncodingOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(FOffset);
end;

procedure TdxCompactFontFormatDictIndexEncodingOperator.SetOffset(const AValue: Integer);
begin
  FOffset := AValue;
end;

procedure TdxCompactFontFormatDictIndexEncodingOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, FOffset);
  inherited Write(AStream, AStringIndex);
end;

procedure TdxCompactFontFormatDictIndexEncodingOperator.WriteData(AStream: TdxFontFileStream);
var
  ACustomEncoding: TdxType1FontCustomEncoding;
begin
  ACustomEncoding := FEncoding as TdxType1FontCustomEncoding;
  if ACustomEncoding <> nil then
    ACustomEncoding.Write(AStream);
end;

{ TdxCompactFontFormatDictIndexPrivateOperator }

constructor TdxCompactFontFormatDictIndexPrivateOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create;
  FLength := Trunc(AOperands[0]);
  FOffset := Trunc(AOperands[1]);
end;

constructor TdxCompactFontFormatDictIndexPrivateOperator.Create(APrivateData: TdxType1FontPrivateData);
var
  AWriter: TdxCompactFontFormatPrivateDictIndexWriter;
begin
  Create;
  FPrivateData := APrivateData;
  AWriter := TdxCompactFontFormatPrivateDictIndexWriter.Create(FPrivateData);
  try
    FLength := AWriter.DataLength;
    FSubrsLength := AWriter.SubrsLength;
  finally
    AWriter.Free;
  end;
end;

class function TdxCompactFontFormatDictIndexPrivateOperator.Code: Byte;
begin
  Result := 18;
end;

procedure TdxCompactFontFormatDictIndexPrivateOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.PrivateData := ReadData(AStream);
end;

procedure TdxCompactFontFormatDictIndexPrivateOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  AGlyphGroupData.PrivateData := ReadData(AStream);
end;

function TdxCompactFontFormatDictIndexPrivateOperator.ReadData(AStream: TdxFontFileStream): TdxType1FontPrivateData;
var
  AData: TBytes;
begin
  AStream.Position := FOffset;
  AData := AStream.ReadArray(FLength);
  AStream.Position := FOffset;
  Result := TdxCompactFontFormatPrivateDictIndexParser.Parse(AStream, AData);
end;

function TdxCompactFontFormatDictIndexPrivateOperator.GetLength: Integer;
begin
  Result := FLength + FSubrsLength;
end;

function TdxCompactFontFormatDictIndexPrivateOperator.GetOffset: Integer;
begin
  Result := FOffset;
end;

function TdxCompactFontFormatDictIndexPrivateOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(FLength) + CalculateIntegerSize(FOffset);
end;

procedure TdxCompactFontFormatDictIndexPrivateOperator.SetOffset(const AValue: Integer);
begin
  FOffset := AValue;
end;

procedure TdxCompactFontFormatDictIndexPrivateOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, FLength);
  WriteInteger(AStream, FOffset);
  inherited Write(AStream, AStringIndex);
end;

procedure TdxCompactFontFormatDictIndexPrivateOperator.WriteData(AStream: TdxFontFileStream);
var
  AWriter: TdxCompactFontFormatPrivateDictIndexWriter;
begin
  AWriter := TdxCompactFontFormatPrivateDictIndexWriter.Create(FPrivateData);
  try
    AWriter.Write(AStream);
  finally
    AWriter.Free;
  end;
end;

{ TdxCompactFontFormatCIDGlyphGroupDataWriter }

constructor TdxCompactFontFormatCIDGlyphGroupDataWriter.Create(const AData: TdxType1FontCIDGlyphGroupData;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  inherited Create;
  FOperators := TdxCompactFontFormatDictIndexOperatorList.Create;
  FStringIndex := AStringIndex;
  if not SameValue(AData.UnderlinePosition, TdxType1FontInfo.DefaultUnderlinePosition) then
    FOperators.Add(TdxCompactFontFormatDictIndexUnderlinePositionOperator.Create(AData.UnderlinePosition));
  if not SameValue(AData.UnderlineThickness, TdxType1FontInfo.DefaultUnderlineThickness) then
    FOperators.Add(TdxCompactFontFormatDictIndexUnderlineThicknessOperator.Create(AData.UnderlineThickness));
  if AData.FontBBox <> TdxType1FontCompactFontProgram.DefaultFontBBox then
    FOperators.Add(TdxCompactFontFormatDictIndexFontBBoxOperator.Create(AData.FontBBox));
  if AData.FontType <> TdxType1FontCompactFontProgram.DefaultFontType then
    FOperators.Add(TdxCompactFontFormatDictIndexCharstringTypeOperator.Create(AData.FontType));
  if not TXForm.IsEqual(AData.FontMatrix, TdxType1FontCompactFontProgram.DefaultFontMatrix) then
    FOperators.Add(TdxCompactFontFormatDictIndexFontMatrixOperator.Create(AData.FontMatrix));
  if AData.UniqueID <> TdxType1FontInfo.DefaultUniqueID then
    FOperators.Add(TdxCompactFontFormatDictIndexUniqueIDOperator.Create(AData.UniqueID));
  if AData.PrivateData <> nil then
  begin
    FPrivateOperator := TdxCompactFontFormatDictIndexPrivateOperator.Create(AData.PrivateData);
    FOperators.Add(FPrivateOperator);
  end;
  if AData.CIDCount <> TdxType1FontCompactCIDFontProgram.DefaultCIDCount then
    FOperators.Add(TdxCompactFontFormatDictIndexCIDCountOperator.Create(AData.CIDCount));
  if AData.CIDFontName <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexFontNameOperator.Create(AData.CIDFontName));
end;

destructor TdxCompactFontFormatCIDGlyphGroupDataWriter.Destroy;
begin
  FreeAndNil(FOperators);
  inherited Destroy;
end;

function TdxCompactFontFormatCIDGlyphGroupDataWriter.DataSize: Integer;
var
  AOperator: TdxCompactFontFormatDictIndexOperator;
begin
  Result := 0;
  for AOperator in FOperators do
    Inc(Result, AOperator.GetSize(FStringIndex));
end;

procedure TdxCompactFontFormatCIDGlyphGroupDataWriter.Write(AStream: TdxFontFileStream);
var
  AOperator: TdxCompactFontFormatDictIndexOperator;
begin
  for AOperator in FOperators do
    AOperator.Write(AStream, FStringIndex);
end;

{ TdxCompactFontFormatDictIndexFDArrayOperator }

constructor TdxCompactFontFormatDictIndexFDArrayOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create;
  FOffset := GetInteger(AOperands);
end;

constructor TdxCompactFontFormatDictIndexFDArrayOperator.Create(ADataArray: TObjectList<TdxType1FontCIDGlyphGroupData>;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  Create;
  FGlyphGroupData := ADataArray;
  FStringIndex := AStringIndex;
end;

destructor TdxCompactFontFormatDictIndexFDArrayOperator.Destroy;
begin
  FreeAndNil(FOffsetOperators);
  FreeAndNil(FWriters);
  inherited Destroy;
end;

class function TdxCompactFontFormatDictIndexFDArrayOperator.Code: Byte;
begin
  Result := 36;
end;

procedure TdxCompactFontFormatDictIndexFDArrayOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
var
  I: Integer;
  ABinaryIndex: TdxCompactFontFormatBinaryIndex;
  ACIDFontProgram: TdxType1FontCompactCIDFontProgram;
  AData: TdxPDFBytesList;
begin
  FStringIndex := AFontProgram.StringIndex;
  ACIDFontProgram := ToCIDFontProgram(AFontProgram);
  if ACIDFontProgram <> nil then
  begin
    AStream.Position := FOffset;
    AData := TdxPDFBytesList.Create;
    try
      ABinaryIndex := TdxCompactFontFormatBinaryIndex.Create(AStream);
      try
        AData.AddRange(ABinaryIndex.Data);
      finally
        ABinaryIndex.Free;
      end;
      FGlyphGroupData := TObjectList<TdxType1FontCIDGlyphGroupData>.Create;
      for I := 0 to AData.Count - 1 do
        FGlyphGroupData.Add(TdxCompactFontFormatTopDictIndexParser.Parse(AStream, FStringIndex, AData[I]));
      ACIDFontProgram.GlyphGroupData := FGlyphGroupData;
    finally
      AData.Free;
    end;
  end;
end;

function TdxCompactFontFormatDictIndexFDArrayOperator.GetOffsetOperators: TdxCompactFontFormatDictIndexOffsetOperatorList;
var
  AOperator: IdxCompactFontFormatDictIndexOffsetOperator;
  AWriter: TdxCompactFontFormatCIDGlyphGroupDataWriter;
begin
  CreateWritersIfNeeded;
  if FOffsetOperators = nil then
    FOffsetOperators := TdxCompactFontFormatDictIndexOffsetOperatorList.Create;
  Result := FOffsetOperators;
  for AWriter in FWriters do
  begin
    if AWriter.PrivateOperator <> nil then
      if Supports(AWriter.PrivateOperator, IdxCompactFontFormatDictIndexOffsetOperator, AOperator) then
        Result.Add(AOperator);
  end;
end;

procedure TdxCompactFontFormatDictIndexFDArrayOperator.CreateWritersIfNeeded;
var
  I: Integer;
begin
  if FWriters = nil then
  begin
    FWriters := TObjectList<TdxCompactFontFormatCIDGlyphGroupDataWriter>.Create;
    for I := 0 to FGlyphGroupData.Count - 1 do
      FWriters.Add(TdxCompactFontFormatCIDGlyphGroupDataWriter.Create(FGlyphGroupData[I], FStringIndex));
  end;
end;

function TdxCompactFontFormatDictIndexFDArrayOperator.GetLength: Integer;
var
  AWriter: TdxCompactFontFormatCIDGlyphGroupDataWriter;
begin
  CreateWritersIfNeeded;
  Result := (FWriters.Count + 1) * 4 + 3;
  for AWriter in FWriters do
    Inc(Result, AWriter.DataSize);
end;

function TdxCompactFontFormatDictIndexFDArrayOperator.GetOffset: Integer;
begin
  Result := FOffset;
end;

function TdxCompactFontFormatDictIndexFDArrayOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(FOffset);
end;

procedure TdxCompactFontFormatDictIndexFDArrayOperator.SetOffset(const AValue: Integer);
begin
  FOffset := AValue;
end;

procedure TdxCompactFontFormatDictIndexFDArrayOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, FOffset);
  inherited Write(AStream, AStringIndex);
end;

procedure TdxCompactFontFormatDictIndexFDArrayOperator.WriteData(AStream: TdxFontFileStream);
var
  I: Integer;
  ABinaryIndex: TdxCompactFontFormatBinaryIndex;
  AGroupStream: TdxFontFileStream;
  AData: TdxPDFBytesList;
begin
  CreateWritersIfNeeded;
  AData := TdxPDFBytesList.Create;
  try
    for I := 0 to FWriters.Count - 1 do
    begin
      AGroupStream := TdxFontFileStream.Create;
      try
        FWriters[I].Write(AGroupStream);
        AData.Add(AGroupStream.Data);
      finally
        AGroupStream.Free;
      end;
    end;
    ABinaryIndex := TdxCompactFontFormatBinaryIndex.CreateEx(AData);
    try
      ABinaryIndex.Write(AStream);
    finally
      ABinaryIndex.Free;
    end;
  finally
    AData.Free;
  end;
end;

{ TdxCompactFontFormatDictIndexUnderlinePositionOperator }

class function TdxCompactFontFormatDictIndexUnderlinePositionOperator.Code: Byte;
begin
  Result := 3;
end;

procedure TdxCompactFontFormatDictIndexUnderlinePositionOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.UnderlinePosition := Value;
end;

procedure TdxCompactFontFormatDictIndexUnderlinePositionOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  AGlyphGroupData.UnderlinePosition := Value;
end;

{ TdxCompactFontFormatDictIndexUnderlineThicknessOperator }

class function TdxCompactFontFormatDictIndexUnderlineThicknessOperator.Code: Byte;
begin
  Result := 4;
end;

procedure TdxCompactFontFormatDictIndexUnderlineThicknessOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.UnderlineThickness := Value;
end;

procedure TdxCompactFontFormatDictIndexUnderlineThicknessOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  AGlyphGroupData.UnderlineThickness := Value;
end;

{ TdxCompactFontFormatDictIndexFontMatrixOperator }

constructor TdxCompactFontFormatDictIndexFontMatrixOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create;
  FFontMatrix := TXForm.CreateIdentityMatrix;
  if Length(AOperands) = 6 then
  begin
    FFontMatrix.eM11 := AOperands[0];
    FFontMatrix.eM12 := AOperands[1];
    FFontMatrix.eM21 := AOperands[2];
    FFontMatrix.eM22 := AOperands[3];
    FFontMatrix.eDx := AOperands[4];
    FFontMatrix.eDy := AOperands[5];
  end;
end;

constructor TdxCompactFontFormatDictIndexFontMatrixOperator.Create(
  const AFontMatrix: TdxCompactFontFormatTarnsformationMatrix);
begin
  Create;
  FFontMatrix := AFontMatrix;
end;

class function TdxCompactFontFormatDictIndexFontMatrixOperator.Code: Byte;
begin
  Result := 7;
end;

procedure TdxCompactFontFormatDictIndexFontMatrixOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  AGlyphGroupData.FontMatrix := FFontMatrix;
end;

procedure TdxCompactFontFormatDictIndexFontMatrixOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.FontMatrix := FFontMatrix;
end;

function TdxCompactFontFormatDictIndexFontMatrixOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) +
    CalculateDoubleSize(FFontMatrix.eM11) + CalculateDoubleSize(FFontMatrix.eM12) +
    CalculateDoubleSize(FFontMatrix.eM21) + CalculateDoubleSize(FFontMatrix.eM22) +
    CalculateDoubleSize(FFontMatrix.eDx) + CalculateDoubleSize(FFontMatrix.eDy);
end;

procedure TdxCompactFontFormatDictIndexFontMatrixOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteDouble(AStream, FFontMatrix.eM11);
  WriteDouble(AStream, FFontMatrix.eM12);
  WriteDouble(AStream, FFontMatrix.eM21);
  WriteDouble(AStream, FFontMatrix.eM22);
  WriteDouble(AStream, FFontMatrix.eDx);
  WriteDouble(AStream, FFontMatrix.eDy);
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatPrivateDictIndexSubrsOperator }

constructor TdxCompactFontFormatPrivateDictIndexSubrsOperator.Create(
  AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray);
begin
  Create;
  FOffset := GetInteger(AOperands);
end;

constructor TdxCompactFontFormatPrivateDictIndexSubrsOperator.Create(ASubrs: TdxPDFBytesList);
begin
  Create;
  FSubrs := TdxCompactFontFormatBinaryIndex.CreateEx(ASubrs);
end;

destructor TdxCompactFontFormatPrivateDictIndexSubrsOperator.Destroy;
begin
  FreeAndNil(FSubrs);
  inherited Destroy;
end;

class function TdxCompactFontFormatPrivateDictIndexSubrsOperator.Code: Byte;
begin
  Result := 19;
end;

function TdxCompactFontFormatPrivateDictIndexSubrsOperator.DataLength: Integer;
begin
  Result := FSubrs.DataLength;
end;

function TdxCompactFontFormatPrivateDictIndexSubrsOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(FOffset);
end;

function TdxCompactFontFormatPrivateDictIndexSubrsOperator.UpdateOffset(AOffset: Integer): Boolean;
var
  APrevOffset: Integer;
begin
  APrevOffset := GetSize(nil);
  FOffset := AOffset;
  Result := GetSize(nil) <> APrevOffset;
end;

procedure TdxCompactFontFormatPrivateDictIndexSubrsOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
var
  APosition: Int64;
begin
  APosition := AStream.Position;
  AStream.Position := APosition + FOffset;
  try
    FSubrs := TdxCompactFontFormatBinaryIndex.Create(AStream);
    APrivateData.Subrs := FSubrs.Data;
  finally
    AStream.Position := APosition;
  end;
end;

procedure TdxCompactFontFormatPrivateDictIndexSubrsOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, FOffset);
  inherited Write(AStream, AStringIndex);
end;

procedure TdxCompactFontFormatPrivateDictIndexSubrsOperator.WriteData(AStream: TdxFontFileStream);
begin
  FSubrs.Write(AStream);
end;

{ TdxCompactFontFormatPrivateDictIndexBlueFuzzOperator }

class function TdxCompactFontFormatPrivateDictIndexBlueFuzzOperator.Code: Byte;
begin
  Result := 11;
end;

procedure TdxCompactFontFormatPrivateDictIndexBlueFuzzOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.BlueFuzz := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexBlueScaleOperator }

class function TdxCompactFontFormatPrivateDictIndexBlueScaleOperator.Code: Byte;
begin
  Result := 9;
end;

procedure TdxCompactFontFormatPrivateDictIndexBlueScaleOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.BlueScale := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexBlueShiftOperator }

class function TdxCompactFontFormatPrivateDictIndexBlueShiftOperator.Code: Byte;
begin
  Result := 10;
end;

procedure TdxCompactFontFormatPrivateDictIndexBlueShiftOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.BlueShift := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexDefaultWidthXOperator }

class function TdxCompactFontFormatPrivateDictIndexDefaultWidthXOperator.Code: Byte;
begin
  Result := 20;
end;

procedure TdxCompactFontFormatPrivateDictIndexDefaultWidthXOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.DefaultWidthX := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexExpansionFactorOperator }

class function TdxCompactFontFormatPrivateDictIndexExpansionFactorOperator.Code: Byte;
begin
  Result := 18;
end;

procedure TdxCompactFontFormatPrivateDictIndexExpansionFactorOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.ExpansionFactor := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexBlueValuesOperator }

class function TdxCompactFontFormatPrivateDictIndexBlueValuesOperator.Code: Byte;
begin
  Result := 6;
end;

procedure TdxCompactFontFormatPrivateDictIndexBlueValuesOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.BlueValues := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexFamilyBluesOperator }

class function TdxCompactFontFormatPrivateDictIndexFamilyBluesOperator.Code: Byte;
begin
  Result := 8;
end;

procedure TdxCompactFontFormatPrivateDictIndexFamilyBluesOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.FamilyBlues := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexFamilyOtherBluesOperator }

class function TdxCompactFontFormatPrivateDictIndexFamilyOtherBluesOperator.Code: Byte;
begin
  Result := 9;
end;

procedure TdxCompactFontFormatPrivateDictIndexFamilyOtherBluesOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.FamilyOtherBlues := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator }

constructor TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator.Create(
  AStringIndex: TdxCompactFontFormatStringIndex; AOperands: TDoubleDynArray);
begin
  Create(GetBoolean(AOperands));
end;

constructor TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator.Create(AValue: Boolean);
begin
  Create;
  FValue := AValue;
end;

function TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + 1;
end;

procedure TdxCompactFontFormatPrivateDictIndexBooleanTwoByteOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteBoolean(AStream, Value);
  inherited Write(AStream, AStringIndex);
end;

{ TdxCompactFontFormatPrivateDictIndexForceBoldOperator }

class function TdxCompactFontFormatPrivateDictIndexForceBoldOperator.Code: Byte;
begin
  Result := 14;
end;

procedure TdxCompactFontFormatPrivateDictIndexForceBoldOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.ForceBold := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexForceBoldThresholdOperator }

class function TdxCompactFontFormatPrivateDictIndexForceBoldThresholdOperator.Code: Byte;
begin
  Result := 15;
end;

procedure TdxCompactFontFormatPrivateDictIndexForceBoldThresholdOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.ForceBoldThreshold := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexLanguageGroupOperator }

class function TdxCompactFontFormatPrivateDictIndexLanguageGroupOperator.Code: Byte;
begin
  Result := 17;
end;

procedure TdxCompactFontFormatPrivateDictIndexLanguageGroupOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.LanguageGroup := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexNominalWidthXOperator }

class function TdxCompactFontFormatPrivateDictIndexNominalWidthXOperator.Code: Byte;
begin
  Result := 21;
end;

procedure TdxCompactFontFormatPrivateDictIndexNominalWidthXOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.NominalWidthX := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexOtherBluesOperator }

class function TdxCompactFontFormatPrivateDictIndexOtherBluesOperator.Code: Byte;
begin
  Result := 7;
end;

procedure TdxCompactFontFormatPrivateDictIndexOtherBluesOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.OtherBlues := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexStdHWOperator }

class function TdxCompactFontFormatPrivateDictIndexStdHWOperator.Code: Byte;
begin
  Result := 10;
end;

procedure TdxCompactFontFormatPrivateDictIndexStdHWOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.StdHW := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexStdVWOperator }

class function TdxCompactFontFormatPrivateDictIndexStdVWOperator.Code: Byte;
begin
  Result := 11;
end;

procedure TdxCompactFontFormatPrivateDictIndexStdVWOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.StdVW := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexStemSnapHOperator }

class function TdxCompactFontFormatPrivateDictIndexStemSnapHOperator.Code: Byte;
begin
  Result := 12;
end;

procedure TdxCompactFontFormatPrivateDictIndexStemSnapHOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.StemSnapH := Value;
end;

{ TdxCompactFontFormatPrivateDictIndexStemSnapVOperator }

class function TdxCompactFontFormatPrivateDictIndexStemSnapVOperator.Code: Byte;
begin
  Result := 13;
end;

procedure TdxCompactFontFormatPrivateDictIndexStemSnapVOperator.Execute(AStream: TdxFontFileStream;
  APrivateData: TdxType1FontCompactFontPrivateData);
begin
  APrivateData.StemSnapV := Value;
end;

{ TdxCompactFontFormatDictIndexVersionOperator }

class function TdxCompactFontFormatDictIndexVersionOperator.Code: Byte;
begin
  Result := 0;
end;

procedure TdxCompactFontFormatDictIndexVersionOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.Version := Value;
end;

{ TdxCompactFontFormatDictIndexUIDBaseOperator }

class function TdxCompactFontFormatDictIndexUIDBaseOperator.Code: Byte;
begin
  Result := 35;
end;

procedure TdxCompactFontFormatDictIndexUIDBaseOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  ToCIDFontProgram(AFontProgram).UIDBase := Value;
end;

{ TdxCompactFontFormatDictIndexStrokeWidthOperator }

class function TdxCompactFontFormatDictIndexStrokeWidthOperator.Code: Byte;
begin
  Result := 8;
end;

procedure TdxCompactFontFormatDictIndexStrokeWidthOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.StrokeWidth := Value;
end;

{ TdxCompactFontFormatDictIndexROSOperator }

constructor TdxCompactFontFormatDictIndexROSOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
var
  ARegistry, AOrdering: string;
  ASupplement: Double;
begin
  ASupplement := 0;
  if Length(AOperands) = 3 then
  begin
    ARegistry := AStringIndex.Items[Trunc(AOperands[0])];
    AOrdering := AStringIndex.Items[Trunc(AOperands[1])];
    ASupplement := AOperands[2];
  end;
  Create(ARegistry, AOrdering, ASupplement);
end;

constructor TdxCompactFontFormatDictIndexROSOperator.Create(const ARegistry, AOrdering: string; ASupplement: Double);
begin
  Create;
  FRegistry := ARegistry;
  FOrdering := AOrdering;
  FSupplement := ASupplement;
end;

class function TdxCompactFontFormatDictIndexROSOperator.Code: Byte;
begin
  Result := 30;
end;

procedure TdxCompactFontFormatDictIndexROSOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
var
  ACIDFontProgram: TdxType1FontCompactCIDFontProgram;
begin
  ACIDFontProgram := ToCIDFontProgram(AFontProgram);
  if ACIDFontProgram <> nil then
  begin
    ACIDFontProgram.Registry := FRegistry;
    ACIDFontProgram.Ordering := FOrdering;
    ACIDFontProgram.Supplement := FSupplement;
  end;
end;

function TdxCompactFontFormatDictIndexROSOperator.GetSize(AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(AStringIndex.GetSID(FRegistry)) +
    CalculateIntegerSize(AStringIndex.GetSID(FOrdering)) + CalculateDoubleSize(FSupplement);
end;

procedure TdxCompactFontFormatDictIndexROSOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, AStringIndex.GetSID(FRegistry));
  WriteInteger(AStream, AStringIndex.GetSID(FOrdering));
  WriteDouble(AStream, FSupplement);
  AStream.WriteByte(Marker);
  AStream.WriteByte(Code);
end;

{ TdxCompactFontFormatDictIndexPostScriptOperator }

class function TdxCompactFontFormatDictIndexPostScriptOperator.Code: Byte;
begin
  Result := 21;
end;

procedure TdxCompactFontFormatDictIndexPostScriptOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.PostScript := Value;
end;

{ TdxCompactFontFormatDictIndexItalicAngleOperator }

class function TdxCompactFontFormatDictIndexItalicAngleOperator.Code: Byte;
begin
  Result := 2;
end;

procedure TdxCompactFontFormatDictIndexItalicAngleOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.ItalicAngle := Value;
end;

{ TdxCompactFontFormatDictIndexIsFixedPitchOperator }

class function TdxCompactFontFormatDictIndexIsFixedPitchOperator.Code: Byte;
begin
  Result := 1;
end;

procedure TdxCompactFontFormatDictIndexIsFixedPitchOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.IsFixedPitch := Value;
end;

{ TdxCompactFontFormatDictIndexFontNameOperator }

class function TdxCompactFontFormatDictIndexFontNameOperator.Code: Byte;
begin
  Result := 38;
end;

procedure TdxCompactFontFormatDictIndexFontNameOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.CIDFontName := Value;
end;

procedure TdxCompactFontFormatDictIndexFontNameOperator.Execute(AStream: TdxFontFileStream;
  AGlyphGroupData: TdxType1FontCIDGlyphGroupData);
begin
  AGlyphGroupData.CIDFontName := Value;
end;

{ TdxCompactFontFormatDictIndexFullNameOperator }

class function TdxCompactFontFormatDictIndexFullNameOperator.Code: Byte;
begin
  Result := 2;
end;

procedure TdxCompactFontFormatDictIndexFullNameOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AFontProgram.FontInfo.FullName := Value;
end;

{ TdxCompactFontFormatDictIndexFDSelectOperator }

constructor TdxCompactFontFormatDictIndexFDSelectOperator.Create(AStringIndex: TdxCompactFontFormatStringIndex;
  AOperands: TDoubleDynArray);
begin
  Create;
  FOffset := GetInteger(AOperands);
end;

constructor TdxCompactFontFormatDictIndexFDSelectOperator.Create(ASelector: TdxType1FontCIDGlyphGroupSelector);
begin
  Create;
  FSelector := ASelector;
end;

class function TdxCompactFontFormatDictIndexFDSelectOperator.Code: Byte;
begin
  Result := 37;
end;

procedure TdxCompactFontFormatDictIndexFDSelectOperator.Execute(AStream: TdxFontFileStream;
  AFontProgram: TdxType1FontCompactFontProgram);
begin
  AStream.Position := FOffset;
  FSelector := TdxType1FontCIDGlyphGroupSelector.Parse(AStream, AFontProgram.CharStrings.Count);
  ToCIDFontProgram(AFontProgram).GlyphGroupSelector := FSelector;
end;

function TdxCompactFontFormatDictIndexFDSelectOperator.GetLength: Integer;
begin
  Result := FSelector.DataLength;
end;

function TdxCompactFontFormatDictIndexFDSelectOperator.GetOffset: Integer;
begin
  Result := FOffset;
end;

function TdxCompactFontFormatDictIndexFDSelectOperator.GetSize(
  AStringIndex: TdxCompactFontFormatStringIndex): Integer;
begin
  Result := inherited GetSize(AStringIndex) + CalculateIntegerSize(FOffset);
end;

procedure TdxCompactFontFormatDictIndexFDSelectOperator.SetOffset(const AValue: Integer);
begin
  FOffset := AValue;
end;

procedure TdxCompactFontFormatDictIndexFDSelectOperator.Write(AStream: TdxFontFileStream;
  AStringIndex: TdxCompactFontFormatStringIndex);
begin
  WriteInteger(AStream, FOffset);
  inherited Write(AStream, AStringIndex);
end;

procedure TdxCompactFontFormatDictIndexFDSelectOperator.WriteData(AStream: TdxFontFileStream);
begin
  FSelector.Write(AStream);
end;

{ TdxType1FontCIDGlyphGroupData }

constructor TdxType1FontCIDGlyphGroupData.Create;
begin
  inherited Create;
  UnderlinePosition := TdxType1FontInfo.DefaultUnderlinePosition;
  UnderlineThickness := TdxType1FontInfo.DefaultUnderlineThickness;
  FontBBox := TdxType1FontCompactFontProgram.DefaultFontBBox;
  FontType := TdxType1FontCompactFontProgram.DefaultFontType;
  FontMatrix := TdxType1FontCompactFontProgram.DefaultFontMatrix;
  UniqueID := TdxType1CustomFontProgram.DefaultUniqueID;
  CIDCount := TdxType1FontCompactCIDFontProgram.DefaultCIDCount;
end;

destructor TdxType1FontCIDGlyphGroupData.Destroy;
begin
  FreeAndNil(PrivateData);
  inherited Destroy;
end;

{ TdxPDFCompactFontFormatTopDictIndexWriter }

constructor TdxPDFCompactFontFormatTopDictIndexWriter.Create(AFontProgram: TdxType1FontCompactFontProgram);
begin
  inherited Create;
  FOffsetOperators := TInterfaceList.Create;
  FOperators := TdxFastObjectList.Create;
end;

destructor TdxPDFCompactFontFormatTopDictIndexWriter.Destroy;
begin
  FreeAndNil(FOffsetOperators);
  FreeAndNil(FOperators);
  FreeAndNil(FGlobalSubrs);
  inherited Destroy;
end;

class function TdxPDFCompactFontFormatTopDictIndexWriter.Write(AFontProgram: TdxType1FontCompactFontProgram): TBytes;
var
  AStream: TdxFontFileStream;
  AWriter: TdxPDFCompactFontFormatTopDictIndexWriter;
begin
  AStream := TdxFontFileStream.Create;
  AWriter := TdxPDFCompactFontFormatTopDictIndexWriter.Create(AFontProgram);
  try
    AWriter.Read(AFontProgram);
    AWriter.DoWrite(AStream);
    Result := AStream.Data;
  finally
    AWriter.Free;
    AStream.Free;
  end;
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.CalculateOffsets;
var
  I, AOffset, APrevSize: Integer;
  AOffsetOperator: IdxCompactFontFormatDictIndexOffsetOperator;
  ANeedRecalculate: Boolean;
begin
  ANeedRecalculate := True;
  while ANeedRecalculate do
  begin
    ANeedRecalculate := False;
    AOffset := Length(FName) + FStringIndex.DataLength + FGlobalSubrs.DataLength + 26;
    for I := 0 to FOperators.Count - 1 do
      Inc(AOffset, TdxCompactFontFormatDictIndexOperator(FOperators[I]).GetSize(FStringIndex));
    for I := 0 to FOffsetOperators.Count - 1 do
    begin
      AOffsetOperator := FOffsetOperators[I] as IdxCompactFontFormatDictIndexOffsetOperator;
      APrevSize := AOffsetOperator.GetSize(FStringIndex);
      AOffsetOperator.Offset := AOffset;
      if AOffsetOperator.GetSize(FStringIndex) <> APrevSize then
      begin
        ANeedRecalculate := True;
        Break;
      end;
      Inc(AOffset, AOffsetOperator.Length);
    end;
  end;
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.DoWrite(AStream: TdxFontFileStream);
var
  I: Integer;
  ANameIndex: TdxCompactFontFormatNameIndex;
  ATopDictIndexStream: TdxFontFileStream;
  ATopDictIndex: TdxCompactFontFormatTopDictIndex;
  AOffsetOperator: IdxCompactFontFormatDictIndexOffsetOperator;
begin
  AStream.WriteByte(FMajorVersion);
  AStream.WriteByte(FMinorVersion);
  AStream.WriteByte(4);
  AStream.WriteByte(1);
  ANameIndex := TdxCompactFontFormatNameIndex.Create;
  try
    ANameIndex.AddString(FName);
    ANameIndex.Write(AStream);
  finally
    ANameIndex.Free;
  end;
  ATopDictIndexStream := TdxFontFileStream.Create;
  try
    for I := 0 to FOperators.Count - 1 do
      TdxCompactFontFormatDictIndexOperator(FOperators[I]).Write(ATopDictIndexStream, FStringIndex);
    ATopDictIndex := TdxCompactFontFormatTopDictIndex.CreateEx(ATopDictIndexStream.Data);
    try
      ATopDictIndex.Write(AStream);
    finally
      ATopDictIndex.Free;
    end;
  finally
    ATopDictIndexStream.Free;
  end;
  FStringIndex.Write(AStream);
  FGlobalSubrs.Write(AStream);
  for I := 0 to FOffsetOperators.Count - 1 do
  begin
    AOffsetOperator := FOffsetOperators[I] as IdxCompactFontFormatDictIndexOffsetOperator;
    AOffsetOperator.WriteData(AStream);
  end;
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.Read(AFontProgram: TdxType1FontCompactFontProgram);
begin
  FMajorVersion := AFontProgram.MajorVersion;
  FMinorVersion := AFontProgram.MinorVersion;
  FName := AFontProgram.FontName;
  FGlobalSubrs := TdxCompactFontFormatBinaryIndex.CreateEx(AFontProgram.GlobalSubrs);
  FStringIndex := AFontProgram.StringIndex;
  if AFontProgram is TdxType1FontCompactCIDFontProgram then
    ReadCIDFontProgramOperators(TdxType1FontCompactCIDFontProgram(AFontProgram));
  ReadFontInfoOperators(AFontProgram.FontInfo);
  if AFontProgram.FontType <> TdxType1FontCompactFontProgram.DefaultFontType then
    FOperators.Add(TdxCompactFontFormatDictIndexCharstringTypeOperator.Create(AFontProgram.FontType));
  if AFontProgram.UniqueID <> TdxType1CustomFontProgram.DefaultUniqueID then
    FOperators.Add(TdxCompactFontFormatDictIndexUniqueIDOperator.Create(AFontProgram.UniqueID));
  if AFontProgram.FontBBox <> TdxType1FontCompactFontProgram.DefaultFontBBox then
    FOperators.Add(TdxCompactFontFormatDictIndexFontBBoxOperator.Create(AFontProgram.FontBBox));
  if AFontProgram.StrokeWidth <> TdxType1CustomFontProgram.DefaultStrokeWidth then
    FOperators.Add(TdxCompactFontFormatDictIndexStrokeWidthOperator.Create(AFontProgram.StrokeWidth));
  if Length(AFontProgram.XUID) > 0 then
    FOperators.Add(TdxCompactFontFormatDictIndexXUIDOperator.Create(AFontProgram.XUID));
  ReadEncodingOperator(AFontProgram.Encoding);
  ReadCharsetOperator(AFontProgram.Charset);
  ReadPrivateOperator(AFontProgram.PrivateData);
  ReadCharStringsOperator(AFontProgram.CharStrings);
  if AFontProgram.PostScript <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexPostScriptOperator.Create(AFontProgram.PostScript));
  if AFontProgram.FontInfo.BaseFontName <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexBaseFontNameOperator.Create(AFontProgram.FontInfo.BaseFontName));
  if Length(AFontProgram.BaseFontBlend) > 0 then
    FOperators.Add(TdxCompactFontFormatDictIndexBaseFontBlendOperator.Create(AFontProgram.BaseFontBlend));
  if AFontProgram.CIDFontName <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexFontNameOperator.Create(AFontProgram.CIDFontName));
  CalculateOffsets;
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.ReadCIDFontProgramOperators(AFontProgram: TdxType1FontCompactCIDFontProgram);
var
  I: Integer;
  AFDArrayOperator: TdxCompactFontFormatDictIndexFDArrayOperator;
  AFDSelectOperator: TdxCompactFontFormatDictIndexFDSelectOperator;
  AOffsetOperators: TList<IdxCompactFontFormatDictIndexOffsetOperator>;
begin
  FOperators.Add(TdxCompactFontFormatDictIndexROSOperator.Create(AFontProgram.Registry, AFontProgram.Ordering,
    AFontProgram.Supplement));
  if AFontProgram.CIDFontVersion <> TdxType1FontCompactCIDFontProgram.DefaultCIDFontVersion then
    FOperators.Add(TdxCompactFontFormatDictIndexCIDFontVersionOperator.Create(AFontProgram.CIDFontVersion));

  if AFontProgram.CIDCount <> TdxType1FontCompactCIDFontProgram.DefaultCIDCount then
    FOperators.Add(TdxCompactFontFormatDictIndexCIDCountOperator.Create(AFontProgram.CIDCount));

  if TdxPDFUtils.IsIntegerValid(AFontProgram.UIDBase) then
    FOperators.Add(TdxCompactFontFormatDictIndexUIDBaseOperator.Create(AFontProgram.UIDBase));

  if AFontProgram.GlyphGroupSelector <> nil then
  begin
    AFDSelectOperator := TdxCompactFontFormatDictIndexFDSelectOperator.Create(AFontProgram.GlyphGroupSelector);
    FOperators.Add(AFDSelectOperator);
    FOffsetOperators.Add(AFDSelectOperator);
  end;

  if AFontProgram.GlyphGroupData <> nil then
  begin
    AFDArrayOperator := TdxCompactFontFormatDictIndexFDArrayOperator.Create(AFontProgram.GlyphGroupData, FStringIndex);
    FOperators.Add(AFDArrayOperator);
    FOffsetOperators.Add(AFDArrayOperator);
    AOffsetOperators := AFDArrayOperator.OffsetOperators;
    try
      for I := 0 to AOffsetOperators.Count - 1 do
        FOffsetOperators.Add(AOffsetOperators[I] as IdxCompactFontFormatDictIndexOffsetOperator);
    finally
      AOffsetOperators.Free;
    end;
  end;
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.ReadCharsetOperator(ACharset: TdxType1FontCustomCharset);
var
  AOperator: TdxCompactFontFormatDictIndexCharsetOperator;
begin
  if (ACharset <> nil) and not ACharset.IsDefault then
  begin
    AOperator := TdxCompactFontFormatDictIndexCharsetOperator.Create(ACharset);
    FOperators.Add(AOperator);
    FOffsetOperators.Add(AOperator);
  end;
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.ReadCharStringsOperator(ACharStrings: TdxPDFBytesList);
var
  AOperator: TdxCompactFontFormatDictIndexCharStringsOperator;
begin
  if ACharStrings <> nil then
  begin
    AOperator := TdxCompactFontFormatDictIndexCharStringsOperator.Create(ACharStrings);
    FOperators.Add(AOperator);
    FOffsetOperators.Add(AOperator);
  end;
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.ReadEncodingOperator(AEncoding: TdxType1FontEncoding);
var
  AOperator: TdxCompactFontFormatDictIndexEncodingOperator;
begin
  if (AEncoding <> nil) and not AEncoding.IsDefault then
  begin
    AOperator := TdxCompactFontFormatDictIndexEncodingOperator.Create(AEncoding);
    FOperators.Add(AOperator);
    if AEncoding.GetOffset = 0 then
      FOffsetOperators.Add(AOperator);
  end;
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.ReadFontInfoOperators(AFontInfo: TdxType1FontInfo);
begin
  if AFontInfo.Version <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexVersionOperator.Create(AFontInfo.Version));
  if AFontInfo.Notice <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexNoticeOperator.Create(AFontInfo.Notice));
  if AFontInfo.Copyright <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexCopyrightOperator.Create(AFontInfo.Copyright));
  if AFontInfo.FullName <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexFullNameOperator.Create(AFontInfo.FullName));
  if AFontInfo.FamilyName <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexFamilyNameOperator.Create(AFontInfo.FamilyName));
  if AFontInfo.Weight <> '' then
    FOperators.Add(TdxCompactFontFormatDictIndexWeightOperator.Create(AFontInfo.Weight));
  if AFontInfo.IsFixedPitch then
    FOperators.Add(TdxCompactFontFormatDictIndexIsFixedPitchOperator.Create(True));
  if AFontInfo.ItalicAngle <> TdxType1FontInfo.DefaultItalicAngle then
    FOperators.Add(TdxCompactFontFormatDictIndexItalicAngleOperator.Create(AFontInfo.ItalicAngle));
  if AFontInfo.UnderlinePosition <> TdxType1FontInfo.DefaultUnderlinePosition then
    FOperators.Add(TdxCompactFontFormatDictIndexUnderlinePositionOperator.Create(AFontInfo.UnderlinePosition));
  if AFontInfo.UnderlineThickness <> TdxType1FontInfo.DefaultUnderlineThickness then
    FOperators.Add(TdxCompactFontFormatDictIndexUnderlineThicknessOperator.Create(AFontInfo.UnderlineThickness));
end;

procedure TdxPDFCompactFontFormatTopDictIndexWriter.ReadPrivateOperator(AData: TdxType1FontPrivateData);
var
  APrivateOperator: TdxCompactFontFormatDictIndexPrivateOperator;
begin
  if AData <> nil then
  begin
    APrivateOperator := TdxCompactFontFormatDictIndexPrivateOperator.Create(AData);
    FOperators.Add(APrivateOperator);
    FOffsetOperators.Add(APrivateOperator);
  end;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexFamilyNameOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexXUIDOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexNoticeOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexWeightOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexFontBBoxOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexUniqueIDOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexCharsetOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexEncodingOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexPrivateOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexVersionOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexFullNameOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexSubrsOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexDefaultWidthXOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexBlueValuesOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexFamilyBluesOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexFamilyOtherBluesOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexNominalWidthXOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexOtherBluesOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexStdHWOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexStdVWOperator);
  dxCompactFontFormatDictIndexOneByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexCharStringsOperator);

  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexBaseFontBlendOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexCharstringTypeOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexCIDCountOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexCIDFontVersionOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexCopyrightOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexFDArrayOperator);  
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexUnderlinePositionOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexUnderlineThicknessOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexFontMatrixOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexUIDBaseOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexStrokeWidthOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexROSOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexPostScriptOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexItalicAngleOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexIsFixedPitchOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexFontNameOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexBaseFontNameOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexBlueFuzzOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexBlueScaleOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexBlueShiftOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexExpansionFactorOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexForceBoldOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexForceBoldThresholdOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexLanguageGroupOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexStemSnapHOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatPrivateDictIndexStemSnapVOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexFDSelectOperator);
  dxCompactFontFormatDictIndexTwoByteOperatorFactory.RegisterOperator(TdxCompactFontFormatDictIndexPaintTypeOperator);

  CreateType1FontExpertCharset;
  CreateType1FontExpertSubsetCharset;
  CreateType1FontAdobeCharset;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(dxgType1FontISOAdobeCharset);
  FreeAndNil(dxgType1FontExpertSubsetCharset);
  FreeAndNil(dxgType1FontExpertCharset);
  FreeAndNil(dxgPDFCompactFontFormatDictIndexOneByteOperatorFactory);
  FreeAndNil(dxgPDFCompactFontFormatDictIndexTwoByteOperatorFactory);
  FreeAndNil(dxgPDFStandardFontDescriptor);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

