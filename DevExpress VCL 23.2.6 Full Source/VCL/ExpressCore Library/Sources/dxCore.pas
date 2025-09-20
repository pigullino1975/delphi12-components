{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCore Library                                      }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCORE LIBRARY AND ALL           }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
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

unit dxCore;

{$I cxVer.inc}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
  {$IFDEF VCL}
    Graphics,
  {$ENDIF}
{$ENDIF}
  System.UITypes,
{$IFDEF DX_INITIALIZATION_LOGGING}
  System.Diagnostics,
{$ENDIF}
  Classes, SysUtils, Variants, Character, Contnrs, AnsiStrings,
  Generics.Defaults, Generics.Collections, Types;

const
  dxVersion = 20230206;
  dxBuildNumber: Cardinal = dxVersion;
  dxUnicodePrefix: Word = $FEFF;
  dxTab = #9;
  dxLF = #10;
  dxCR = #13;
  dxSpace = #32;
  dxCRLF = #13#10;
  dxVKSelectAll = #1; 
  dxVKCopy = #3; 
  dxVKPaste = #22; 
  dxVKCut = #24; 
  dxVKBack = #8;
  dxVKTab = #9;
  dxVKReturn = #13;
  dxVKEscape = #27;
  dxVKSpace = #32;
  dxVKDelete = #46;

  dxBreakLineCharacters = [dxCR, dxLF];
  dxSpaceCharacters = [dxSpace, dxTab, dxCR, dxLF];

  MinInt   = -2147483647 - 1;          
  MinInt64 = -9223372036854775807 - 1; 
  MaxInt64 = 9223372036854775807;

const
  dxUserNameUnknown            = 0;
  dxUserNameFullyQualifiedDN   = 1;
  dxUserNameSamCompatible      = 2;
  dxUserNameDisplay            = 3;
  dxUserNameUniqueId           = 6;
  dxUserNameCanonical          = 7;
  dxUserNameUserPrincipal      = 8;
  dxUserNameCanonicalEx        = 9;
  dxUserNameServicePrincipal   = 10;
  dxUserNameDnsDomain          = 12;
{$IFNDEF MSWINDOWS}
  MAXWORD = 65535;
{$ENDIF}

type
  TColors = array of System.UITypes.TColor;
  TPoints = array of TPoint;
  TRects = array of TRect;
  PdxNativeInt = ^TdxNativeInt;
  TdxNativeInt = NativeInt;
  PdxNativeUInt = ^TdxNativeUInt;
  TdxNativeUInt = NativeUInt;
  TdxListIndex = {$IFDEF DELPHI120}NativeInt{$ELSE}Integer{$ENDIF};

  TcxResourceStringID = Pointer;

  PRectArray = ^TRectArray;
  TRectArray = array [0..0] of TRect;

  TdxDefaultBoolean = (bFalse, bTrue, bDefault);
  TdxObjectOwnership = (ooOwned, ooReferenced, ooCloned);

  TdxCorner = (coTopLeft, coTopRight, coBottomLeft, coBottomRight);
  TdxCorners = set of TdxCorner;

const
  dxAllCorners = [Low(TdxCorner)..High(TdxCorner)];

type
  TdxSortOrder = (soNone, soAscending, soDescending);

  TdxOrientation = (orHorizontal, orVertical);
  TdxDirectedOrientation = (doLeftToRight, doTopToBottom, doBottomToTop, doRightToLeft);
  TdxTextOrientation = (toLeftToRight, toTopToBottom, toBottomToTop);

  PdxPWideCharArray = ^TdxPWideCharArray;
  TdxPWideCharArray = array[0..0] of PWideChar;

  { IdxLocalizerListener }

  IdxLocalizerListener = interface
  ['{84103A37-1A56-4599-B2C4-1E710E182032}']
    procedure TranslationChanged;
  end;

  { IdxDebugVisualizer }

  IdxDebugVisualizer = interface
  ['{159F61D6-24F4-47B6-A635-9AD95A904780}']
    function GetDebugVisualizerData: string; 
  end;


{$IFDEF DX_INITIALIZATION_LOGGING}
  TdxUnitSectionsLogger = class // for internal use only
  private const FileExtention: string = '.units_logger.log';
  strict private
    class var FFileName: string;
    class var FWatch: TStopwatch;
    class procedure InternalLog(const AData: string); overload; static;
    class procedure InternalLog(const AData: string; AhInstance: HMODULE); overload; static;
  public
    const ThresholdInMs: Int64 = 3;
    const UseTimingsThreshold: Boolean = {$IFDEF DX_INITIALIZATION_LOGGING_TIMINGS_ONLY}True{$ELSE}False{$ENDIF};
    class procedure InitializationStarted(const AUnitName: string; AhInstance: HMODULE); static;
    class procedure InitializationFinished(const AUnitName: string; AhInstance: HMODULE); static;
    class procedure FinalizationStarted(const AUnitName: string; AhInstance: HMODULE); static;
    class procedure FinalizationFinished(const AUnitName: string; AhInstance: HMODULE); static;
    class procedure Log(const AData: string); overload; static;
    class procedure Log(const AData: string; AhInstance: HMODULE); overload; static;
    class procedure ConstructorStarted(const AUnitName, AClassOrRecordNameDotMethodName: string; AhInstance: HMODULE); static;
    class procedure ConstructorFinished(const AUnitName, AClassOrRecordNameDotMethodName: string; AhInstance: HMODULE); static;
    class procedure DestructorStarted(const AUnitName, AClassOrRecordNameDotMethodName: string; AhInstance: HMODULE); static;
    class procedure DestructorFinished(const AUnitName, AClassOrRecordNameDotMethodName: string; AhInstance: HMODULE); static;
    class constructor Create;
    class procedure StartLogging;
  end;
{$ENDIF}

  TdxAnsiCharSet = set of AnsiChar;

  { TdxByteArray }

  TdxByteArray = class
  public
    class function Clone(const ABytes: TBytes): TBytes; overload;
    class function Clone(const ABytes: TBytes; AMaxLength: Integer): TBytes; overload;
    class function Compare(const AB1, AB2: TBytes): Boolean;
    class function Concatenate(ANum: Integer; const ABytes: TBytes): TBytes; overload;
    class function Concatenate(const AB1: TBytes; const AB2: TBytes): TBytes; overload;
    class function Concatenate(const ABytes: TBytes; ANum: Integer): TBytes; overload;
    class function Resize(const ABytes: TBytes; ATargetSize: Integer; AFillBy: Byte = 0): TBytes;
  end;

  { TdxStream }

  TdxStream = class(TStream)
  private
    FIsUnicode: Boolean;
    FStream: TStream;
  protected
    function GetSize: Int64; override;
  public
    constructor Create(AStream: TStream); virtual;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;

    property IsUnicode: Boolean read FIsUnicode;
    property Stream: TStream read FStream;
  end;

  { TdxProductResourceStrings }

  TdxProductResourceStrings = class;

  TdxAddResourceStringsProcedure = procedure(AProduct: TdxProductResourceStrings);

  TdxProductResourceStrings = class
  private
    FName: string;
    FInitializeProcedures: TList;
    FResStringNames: TStrings;

    function GetNames(AIndex: Integer): string;
    function GetResStringsCount: Integer;
    procedure SetTranslation(AIndex: Integer);
    function GetValues(AIndex: Integer): string;
  protected
    procedure AddProcedure(AProc: TdxAddResourceStringsProcedure);
    procedure RemoveProcedure(AProc: TdxAddResourceStringsProcedure);
    procedure Translate;

    property InitializeProcedures: TList read FInitializeProcedures;
  public
    constructor Create(const AName: string; AInitializeProc: TdxAddResourceStringsProcedure); virtual;
    destructor Destroy; override;
    procedure Add(const AResStringName: string; AResStringAddr: Pointer);
    procedure Clear;
    function GetIndexByName(const AName: string): Integer;

    property Name: string read FName;
    property Names[AIndex: Integer]: string read GetNames;
    property ResStringsCount: Integer read GetResStringsCount;
    property Values[AIndex: Integer]: string read GetValues;
  end;

  TdxLocalizationTranslateResStringEvent = procedure(const AResStringName: string; AResString: Pointer) of object;

  { TdxResourceStringsRepository }

  TdxResourceStringsRepository = class
  private
    FListeners: TList;
    FProducts: TObjectList;
    FOnTranslateResString: TdxLocalizationTranslateResStringEvent;

    function GetProducts(AIndex: Integer): TdxProductResourceStrings;
    function GetProductsCount: Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure AddListener(AListener: IdxLocalizerListener);
    procedure RemoveListener(AListener: IdxLocalizerListener);
    procedure NotifyListeners;

    procedure RegisterProduct(const AProductName: string; AAddStringsProc: TdxAddResourceStringsProcedure);
    function GetProductIndexByName(const AName: string): Integer;
    function GetOriginalValue(const AName: string): string;
    procedure Translate;
    procedure UnRegisterProduct(const AProductName: string; AAddStringsProc: TdxAddResourceStringsProcedure = nil);

    property Products[Index: Integer]: TdxProductResourceStrings read GetProducts;
    property ProductsCount: Integer read GetProductsCount;
    property OnTranslateResString: TdxLocalizationTranslateResStringEvent read FOnTranslateResString write FOnTranslateResString;
  end;

  { Safe }

  Safe = class
  public
    class function Cast(const AObject: TObject; const AClass: TClass; out AValue): Boolean; inline;
  end;

  { Safe }

  Safe<T: class> = class
  public
    class function Cast(AObject: TObject): T;
  end;

  { TdxUnitsLoader }

  TdxProc = procedure;
  TdxProcRec = record
    UnitName: string;
    Proc: TdxProc;
    hInstance: HMODULE;
  end;

  TdxProcList = class(TList<TdxProcRec>)
  private
    function RemoveProc(AProc: TdxProc): Integer;
  end;

  TdxUnitsLoader = class
  private
    FInRegsvr32: Boolean;
  protected
    FinalizeList: TdxProcList;
    InitializeList: TdxProcList;
    procedure CallProc(AProc: TdxProc);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddUnit(AhInstance: HMODULE; const AUnitName: string; const AInitializeProc, AFinalizeProc: TdxProc);
    procedure RemoveUnit(AhInstance: HMODULE; const AUnitName: string; const AFinalizeProc: TdxProc);
    procedure Finalize;
    procedure Initialize;
  end;

  { TdxDoubleRange }

  TdxDoubleRange = record
  private
    FMax: Double;
    FMin: Double;
  public
    class function Create(const AMin, AMax: Double): TdxDoubleRange; static;
    function Contains(const AValue: Double): Boolean;
    class operator Equal(const L, R : TdxDoubleRange) : Boolean;
    class operator NotEqual(const L, R : TdxDoubleRange): Boolean;
    //
    property Max: Double read FMax;
    property Min: Double read FMin;
  end;
  TdxDoubleRanges = array of TdxDoubleRange;

  EdxException = class(Exception);

  EdxTestException = class(EdxException);

procedure dxAbstractError;
procedure dxTestCheck(AValue: WordBool; const AMessage: string);
procedure dxCheckOrientation(var AValue: TdxOrientation; ADefaultOrientation: TdxOrientation);
procedure dxShowException(AException: TObject);

procedure dxCallNotify(ANotifyEvent: TNotifyEvent; ASender: TObject);
{$IFDEF MSWINDOWS}
function dxGetTickCount: Int64;
{$ENDIF}
function dxBooleanToDefaultBoolean(AValue: Boolean): TdxDefaultBoolean; inline;
function dxDefaultBooleanToBoolean(AValue: TdxDefaultBoolean; ADefault: Boolean): Boolean; inline;
function dxSameMethods(const Method1, Method2): Boolean; inline;

function dxMakeInt64(const A, B: Integer): Int64;

// math
function dxFMod(const ANumerator, ADenominator: Single): Single; overload;
function dxFMod(const ANumerator, ADenominator: Double): Double; overload;
function dxFMod(const ANumerator, ADenominator: Extended): Extended; overload;

// string functions
function dxBinToHex(const ABuffer: AnsiString): AnsiString; overload;
function dxBinToHex(const ABuffer: PAnsiChar; ABufSize: Integer): AnsiString; overload;
function dxHexToBin(const AText: AnsiString): AnsiString; overload;
function dxHexToBin(const AText: PAnsiChar): AnsiString; overload;
function dxHexToByte(const AHex: string): Byte;
function dxCharCount(const S: string): Integer; inline;
function dxCharInSet(C: Char; const ACharSet: TdxAnsiCharSet): Boolean; inline;
function dxStringSize(const S: string): Integer; inline;

{$IFDEF MSWINDOWS}
function dxAnsiIsAlpha(Ch: AnsiChar): Boolean;
function dxAnsiIsNumeric(Ch: AnsiChar): Boolean;
function dxCharIsAlpha(Ch: Char): Boolean;
function dxCharIsNumeric(Ch: Char): Boolean;
function dxWideIsAlpha(Ch: WideChar): Boolean;
function dxWideIsNumeric(Ch: WideChar): Boolean;
function dxWideIsSpace(Ch: WideChar): Boolean;
{$ENDIF}
function dxIsLowerCase(AChar: Char): Boolean; inline;
function dxIsWhiteSpace(AChar: Char): Boolean; inline;
function dxLowerCase(AChar: Char): Char; inline;
function dxUpperCase(AChar: Char): Char; inline;

function dxStrComp(const Str1, Str2: PAnsiChar): Integer; inline;
function dxStrCopy(ADest: PAnsiChar; const ASource: PAnsiChar): PAnsiChar; inline;
function dxStrLCopy(ADest: PAnsiChar; const ASource: PAnsiChar; AMaxLen: Cardinal): PAnsiChar; inline;
function dxStrLen(const AStr: PAnsiChar): Cardinal; inline;

{$IFDEF MSWINDOWS}
function dxGetCodePageFromCharset(ACharset: Integer): Integer;
function dxGetStringTypeA(Locale: LCID; dwInfoType: DWORD; const lpSrcStr: PAnsiChar; cchSrc: Integer; var lpCharType): BOOL;
function dxGetStringTypeW(dwInfoType: DWORD; const lpSrcStr: PWideChar; cchSrc: Integer; var lpCharType): BOOL;
function dxGetAnsiCharCType1(Ch: AnsiChar): Word;
function dxGetWideCharCType1(Ch: WideChar): Word;
{$ENDIF}

// string conversions
function dxAnsiStringToWideString(const ASource: AnsiString; ACodePage: Cardinal = CP_ACP): WideString; inline;
function dxWideStringToAnsiString(const ASource: WideString; ACodePage: Cardinal = CP_ACP): AnsiString; inline;

function dxAnsiStringToString(const S: AnsiString; ACodePage: Integer = CP_ACP): string;
function dxStringToAnsiString(const S: string; ACodePage: Integer = CP_ACP): AnsiString;

function dxShortStringToString(const S: ShortString): string; inline;
function dxStringToShortString(const S: string): ShortString; inline;

function dxVariantToAnsiString(const V: Variant): AnsiString;
function dxVariantToString(const V: Variant): string;

function dxVarIsBlob(const V: Variant): Boolean;

function dxConcatenateStrings(const AStrings: array of PChar): string;
procedure dxStringToBytes(const S: string; var Buf);
function dxStrToFloat(const S: string; const ADecimalSeparator: Char = '.'): Extended;
function dxStrToFloatDef(const S: string; const ADecimalSeparator: Char = '.'; ADefaultValue: Extended = 0): Extended;
function dxFloatToStr(AValue: Extended; ADecimalSeparator: Char = '.'): string;
function RemoveAccelChars(const S: string; AAppendTerminatingUnderscore: Boolean = True): string;

function dxAnsiStrToInt(const S: AnsiString): Integer;
function dxUTF8StringToAnsiString(const S: UTF8String): AnsiString;
function dxAnsiStringToUTF8String(const S: AnsiString): UTF8String;
function dxUTF8StringToString(const S: UTF8String): string;
function dxUTF8StringToWideString(const S: UTF8String): WideString;
function dxStringToUTF8String(const S: string): UTF8String;
function dxWideStringToUTF8String(const S: WideString): UTF8String;

function dxAnsiStringReplace(const AString, AOldPattern, ANewPattern: AnsiString; AFlags: TReplaceFlags): AnsiString;

// streaming
function dxIsUnicodeStream(AStream: TStream): Boolean;
procedure dxWriteStandardEncodingSignature(AStream: TStream);
procedure dxWriteStreamType(AStream: TStream);

function dxReadStr(Stream: TStream; AIsUnicode: Boolean): string;
procedure dxWriteStr(Stream: TStream; const S: string);

function dxStreamToHGlobal(AStream: TMemoryStream): HGLOBAL;
function dxStreamToVariant(AStream: TStream): Variant; overload;
function dxStreamToVariant(AStream: TStream; ASize: Integer): Variant; overload;

procedure dxCompressStream(ASourceStream, ADestStream: TStream; ACompressMethod: Byte; ASize: Integer = 0);
procedure dxDecompressStream(ASourceStream, ADestStream: TStream);

function dxResourceStringsRepository: TdxResourceStringsRepository;
function cxGetResourceString(AResString: TcxResourceStringID): string; overload;
procedure cxSetResourceString(AResString: TcxResourceStringID; const Value: string);
function cxGetResourceString(const AResString: string): string; overload; deprecated;
function cxGetResourceStringNet(const AResString: string): string; deprecated;
procedure cxSetResourceStringNet(const AResString, Value: string); deprecated;
procedure cxClearResourceStrings;

function dxFindLocalizedResourceString(const AdxResourceString: string; out ALocalizedString: string): Boolean;
function dxGetSystemResourceString(ALibraryHandle: THandle; const AStringID: Integer;
  const ADefaultValue: string = ''): string; // for internal use only
function dxGetLocalizedSystemResourceString(const AdxResourceString: string; ALibraryHandle: THandle;
  const AStringID: Integer): string; overload; // for internal use only
function dxGetLocalizedSystemResourceString(const AdxResourceString: string; const ALibraryName: string;
  const AStringID: Integer): string; overload; // for internal use only

// file utils
{$IFDEF MSWINDOWS}
function dxCreateTempFile(const AExtension: string = ''): string;
{$ENDIF}
function dxExcludeTrailingPathDelimiter(const APath: string; const APathDelimiter: Char = PathDelim): string;
function dxExtractFileName(const APath: string; const APathDelimiter: Char = PathDelim): string;
function dxIncludeTrailingPathDelimiter(const APath: string; const APathDelimiter: Char = PathDelim): string;
function dxIsPathDelimiter(const S: string; Index: Integer; const APathDelimiter: Char = PathDelim): Boolean;
function dxReplacePathDelimiter(const APath: AnsiString; const AOldDelimiter, ANewDelimiter: AnsiChar): AnsiString; overload;
function dxReplacePathDelimiter(const APath: string; const AOldDelimiter, ANewDelimiter: Char): string; overload;

// memory functions
{$IFDEF MSWINDOWS}
function dxCanReadMemory(P: Pointer; ASize: Cardinal): Boolean; // for internal use
procedure cxZeroMemory(ADestination: Pointer; ACount: Integer);
function cxAllocMem(Size: Cardinal): Pointer;
{$ENDIF}
procedure cxFreeMem(P: Pointer);
procedure dxFillChar(var ADest; Count: Integer; const APattern: Char);
procedure dxFreeAndNil(var AObject);

procedure cxCopyData(ASource, ADestination: Pointer; ACount: Integer); overload; inline;
procedure cxCopyData(ASource, ADestination: Pointer; ASourceOffSet, ADestinationOffSet, ACount: Integer); overload; inline;

function ReadBoolean(ASource: Pointer; AOffset: Integer = 0): WordBool; inline;
function ReadByte(ASource: Pointer; AOffset: Integer = 0): Byte; inline;
function ReadInteger(ASource: Pointer; AOffset: Integer = 0): Integer; inline;
function ReadPointer(ASource: Pointer): Pointer; inline;
function ReadWord(ASource: Pointer; AOffset: Integer = 0): Word; inline;
procedure WriteBoolean(ADestination: Pointer; AValue: WordBool; AOffset: Integer = 0); inline;
procedure WriteByte(ADestination: Pointer; AValue: Byte; AOffset: Integer = 0); inline;
procedure WriteInteger(ADestination: Pointer; AValue: Integer; AOffset: Integer = 0); inline;
procedure WritePointer(ADestination: Pointer; AValue: Pointer); inline;
procedure WriteWord(ADestination: Pointer; AValue: Word; AOffset: Integer = 0); inline;

function ReadBufferFromStream(AStream: TStream; ABuffer: Pointer; Count: Integer): Boolean;
function ReadStringFromStream(AStream: TStream; out AValue: AnsiString): Longint;
function WriteBufferToStream(AStream: TStream; ABuffer: Pointer; ACount: Longint): Longint;
function WriteCharToStream(AStream: TStream; AValue: AnsiChar): Longint;
function WriteDoubleToStream(AStream: TStream; AValue: Double): Longint;
function WriteIntegerToStream(AStream: TStream; AValue: Integer): Longint;
function WriteSmallIntToStream(AStream: TStream; AValue: SmallInt): Longint;
function WriteStringToStream(AStream: TStream; const AValue: AnsiString): Longint;

function dxSwap16(const AValue: Word): Word;
function dxSwap32(const AValue: DWORD): DWORD;
procedure ExchangeBooleans(var AValue1, AValue2: Boolean);
procedure ExchangeIntegers(var AValue1, AValue2: Integer);
procedure ExchangeLongWords(var AValue1, AValue2);
procedure ExchangePointers(var AValue1, AValue2);
procedure ExchangeSingle(var AValue1, AValue2: Single);
procedure ExchangeStrings(var AValue1, AValue2: string);
function ShiftPointer(P: Pointer; AOffset: Integer): Pointer; inline;
{$IFDEF MSWINDOWS}
function dxPointToLParam(P: TPoint): LPARAM;
function dxLParamToPoint(AParam: LPARAM): TPoint;
{$ENDIF}

// List functions
procedure dxAppendList(ASource, ADestination: TList);
procedure dxCopyList(ASource, ADestination: TList);

{$IFDEF MSWINDOWS}
// locale functions
function dxGetInvariantLocaleID: Integer;
procedure dxGetLocaleFormatSettings(ALocale: Integer; var AFormatSettings: TFormatSettings);
function dxGetLocaleInfo(ALocale, ALocaleType: Integer; const ADefaultValue: string = ''): string;
function dxGetSubLangID(ALangId: Word): Word;
function dxMakeLangID(APrimaryLang, ASubLang: Word): Word;
function dxMakeLCID(ALangId, ASortId: Word): DWORD;

function dxGetUserName: string;
function dxGetUserNameEx(AFormat: DWORD): string;
function dxShellExecute(AHandle: HWND; const AFileName: string; AShowCmd: Integer = SW_SHOWNORMAL): Boolean; overload;
function dxShellExecute(const AFileName: string; AShowCmd: Integer = SW_SHOWNORMAL): Boolean; overload;
{$ENDIF}

//compare functions
function dxCompareValues(A, B: Integer): Integer; overload; inline;
function dxCompareValues(A, B: Pointer): Integer; overload; inline;
function dxSameText(const A, B: string): Boolean; inline;

function dxGetBuildNumberAsString(ABuildNumber: Cardinal = 0): string;
function dxGetShortBuildNumberAsString(ABuildNumber: Cardinal = 0): string;
procedure dxFactorizeBuildNumber(ABuildNumber: Cardinal; out AMajor, AMinor, ABuild: Integer);

function dxGenerateGUID: string;
function dxGenerateID: string;
function dxIsDLL: Boolean;
function dxIsIntResource(AType: PChar): BOOL;

procedure dxFreeGlobalObject(var AObject);
function dxUnitsLoader: TdxUnitsLoader;
procedure dxInitialize; stdcall;
procedure dxFinalize; stdcall;


{$IFDEF MSWINDOWS}
var
// platform info
  IsWin9X: Boolean;
  IsWin95, IsWin98, IsWinMe: Boolean;

  IsWinNT: Boolean;
  IsWin2K, IsWin2KOrLater: Boolean;
  IsWinXP, IsWinXPOrLater: Boolean;
  IsWin2KOrXP: Boolean;

  IsWinVista, IsWinVistaOrLater: Boolean;
  IsWinSeven, IsWinSevenOrLater: Boolean;
  IsWin8, IsWin8OrLater: Boolean;

  IsWin10OrLater: Boolean;
  IsWin10v1809OrLater: Boolean;
  IsWin10v2004OrLater: Boolean;
  IsWin10FallCreatorsUpdate: Boolean; 
  IsWin11OrLater: Boolean;
  IsWinSupportsAcrylicEffect: Boolean; 

  IsWin64Bit: Boolean;
  IsWinServer: Boolean;
{$ENDIF}
  dxInvariantFormatSettings: TFormatSettings;

var
  dxIsDesignTime: Boolean = False;

function cxFileTimeToDateTime(fTime:FILETIME):TDateTime;

implementation


uses
{$IFDEF VCL}
  Menus, Forms,
{$ENDIF}
{$IFDEF MSWINDOWS}
  ShellAPI,
{$ENDIF}
  Math, StrUtils, SysConst, DateUtils;

const
  dxThisUnitName = 'dxCore';

type
  TdxGlobalObjectDestroyer = class(TComponent)
  private
    FObjects: TList;
  protected
    property Objects: TList read FObjects;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FGlobalObjectDestroyer: TdxGlobalObjectDestroyer;

constructor TdxGlobalObjectDestroyer.Create(Owner: TComponent);
begin
  inherited;
  FObjects := TList.Create;
end;

destructor TdxGlobalObjectDestroyer.Destroy;
var
  I: Integer;
begin
  if FGlobalObjectDestroyer = Self then
    FGlobalObjectDestroyer := nil;
  for I := 0 to FObjects.Count - 1 do
    TObject(FObjects.List[I]).Free;
  FreeAndNil(FObjects);
  inherited;
end;

function cxFileTimeToDateTime(fTime:FILETIME): TDateTime;
var
  LocalTime:TFileTime;
  Age:Integer;
begin
  FileTimeToLocalFileTime(FTime,LocalTime);
  if FileTimeToDosDateTime(LocalTime,LongRec(Age).Hi,LongRec(Age).Lo) then
     Result:=FileDateToDateTime(Age)
  else
     Result:=-1;
end;

const
  MaxUserNameSize = 256; 

type
  TdxStreamHeader = array[0..5] of AnsiChar;

{$IFDEF MSWINDOWS}
type
  TGetUserNameExW = function (NameFormat: DWORD; lpNameBuffer: LPWSTR; var nSize: ULONG): BOOL; stdcall;
  TRtlGetVersion = function (var lpVersionInformation: TOSVersionInfoExW): Integer; stdcall;
{$ENDIF}

const
  StreamFormatANSI: TdxStreamHeader = 'DXAFMT';
  StreamFormatUNICODE: TdxStreamHeader = 'DXUFMT';

var
  FdxResourceStringsRepository: TdxResourceStringsRepository;
  IsInitialized: Boolean;
  UnitsLoader: TdxUnitsLoader;

{$IFDEF MSWINDOWS}
  FGetUserNameExChecked: Boolean = False;
  FGetUserNameExProc: TGetUserNameExW = nil;
{$ENDIF}


{$IF DEFINED(MSWINDOWS)}
function GetStringTypeA(ALocale: Cardinal; dwInfoType: DWORD; const lpSrcStr: PAnsiChar;
  cchSrc: Integer; var lpCharType): BOOL; stdcall; external kernel32 name 'GetStringTypeA';
function GetStringTypeW(dwInfoType: DWORD; const lpSrcStr: PWideChar;
  cchSrc: Integer; var lpCharType): BOOL; stdcall; external kernel32 name 'GetStringTypeW';
{$IFEND}


function dxIsDLL: Boolean;
begin
  Result := ModuleIsLib and not ModuleIsPackage;
end;

function dxIsIntResource(AType: PChar): BOOL;
begin
  Result := ULONG_PTR(AType) shr 16 = 0;
end;

procedure WriteBoolean(ADestination: Pointer; AValue: WordBool; AOffset: Integer = 0);
begin
  PWordBool(PByte(ADestination) + AOffset)^ := AValue;
end;

procedure WriteByte(ADestination: Pointer; AValue: Byte; AOffset: Integer = 0);
begin
  PByte(PByte(ADestination) + AOffset)^ := AValue;
end;

procedure WriteInteger(ADestination: Pointer; AValue: Integer; AOffset: Integer = 0);
begin
  PInteger(PByte(ADestination) + AOffset)^ := AValue;
end;

procedure WritePointer(ADestination: Pointer; AValue: Pointer);
begin
  Pointer(ADestination^) := AValue;
end;

procedure WriteWord(ADestination: Pointer; AValue: Word; AOffset: Integer = 0);
begin
  PWord(PByte(ADestination) + AOffset)^ := AValue;
end;

 { TdxResourceStringsRepository }

constructor TdxResourceStringsRepository.Create;
begin
  inherited;
  FProducts := TObjectList.Create;
  FListeners := TList.Create;
end;

destructor TdxResourceStringsRepository.Destroy;
begin
  FreeAndNil(FListeners);
  FreeAndNil(FProducts);
  inherited;
end;

procedure TdxResourceStringsRepository.AddListener(AListener: IdxLocalizerListener);
begin
  if FListeners.IndexOf(Pointer(AListener)) = -1 then
    FListeners.Add(Pointer(AListener));
end;

procedure TdxResourceStringsRepository.RemoveListener(AListener: IdxLocalizerListener);
begin
  FListeners.Remove(Pointer(AListener));
end;

procedure TdxResourceStringsRepository.NotifyListeners;
var
  I: Integer;
begin
  for I := 0 to FListeners.Count - 1 do
    IdxLocalizerListener(FListeners[I]).TranslationChanged;
end;

procedure TdxResourceStringsRepository.RegisterProduct(const AProductName: string; AAddStringsProc: TdxAddResourceStringsProcedure);
var
  AIndex: Integer;
begin
  AIndex := GetProductIndexByName(AProductName);
  if AIndex >= 0 then
    Products[AIndex].AddProcedure(AAddStringsProc)
  else
    FProducts.Add(TdxProductResourceStrings.Create(AProductName, AAddStringsProc));
end;

function TdxResourceStringsRepository.GetProductIndexByName(const AName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to ProductsCount - 1 do
    if Products[I].Name = AName then
    begin
      Result := I;
      Break;
    end;
end;

function TdxResourceStringsRepository.GetOriginalValue(const AName: string): string;
var
  I, AIndex: Integer;
begin
  Result := '';
  for I := 0 to ProductsCount - 1 do
  begin
    AIndex := Products[I].GetIndexByName(AName);
    if AIndex <> -1 then
    begin
      Result := Products[I].Values[AIndex];
      Break;
    end;
  end;
end;

procedure TdxResourceStringsRepository.Translate;
var
  I: Integer;
begin
  if Assigned(FOnTranslateResString) then
  begin
    for I := 0 to ProductsCount - 1 do
      Products[I].Translate;
  end;
end;

procedure TdxResourceStringsRepository.UnRegisterProduct(const AProductName: string; AAddStringsProc: TdxAddResourceStringsProcedure = nil);
var
  AIndex: Integer;
  AProduct: TdxProductResourceStrings;
begin
  AIndex := GetProductIndexByName(AProductName);
  if AIndex <> -1 then
  begin
    if Assigned(AAddStringsProc) then
    begin
      AProduct := Products[AIndex];
      AProduct.RemoveProcedure(AAddStringsProc);
      if AProduct.InitializeProcedures.Count = 0 then
        FProducts.Delete(AIndex);
    end
    else
      FProducts.Delete(AIndex);
  end;
end;

function TdxResourceStringsRepository.GetProducts(AIndex: Integer): TdxProductResourceStrings;
begin
  Result := TdxProductResourceStrings(FProducts[AIndex]);
end;

function TdxResourceStringsRepository.GetProductsCount: Integer;
begin
  Result := FProducts.Count;
end;


{ TdxByteArray }

class function TdxByteArray.Clone(const ABytes: TBytes): TBytes;
begin
  Result := Clone(ABytes, MaxInt);
end;

class function TdxByteArray.Clone(const ABytes: TBytes; AMaxLength: Integer): TBytes;
begin
  AMaxLength := Min(AMaxLength, Length(ABytes));
  if ABytes <> nil then
  begin
    SetLength(Result, AMaxLength);
    Move(ABytes[0], Result[0], AMaxLength);
  end
  else
    Result := nil;
end;

class function TdxByteArray.Compare(const AB1, AB2: TBytes): Boolean;
begin
  if Pointer(AB1) = Pointer(AB2) then
    Exit(True);
  if (AB1 = nil) or (AB2 = nil) then
    Exit(False);
  if Length(AB1) <> Length(AB2) then
    Exit(False);
  Result := CompareMem(@AB1[0], @AB2[0], Length(AB1));
end;

class function TdxByteArray.Concatenate(ANum: Integer; const ABytes: TBytes): TBytes;
var
  ACountBytes: TBytes;
  AArrayLength: Integer;
begin
  AArrayLength := Length(ABytes);
  SetLength(Result, AArrayLength + 4);
  SetLength(ACountBytes, 4);
  ACountBytes[3] := Byte((ANum and $FF000000) shr 24);
  ACountBytes[2] := Byte((ANum and $00FF0000) shr 16);
  ACountBytes[1] := Byte((ANum and $0000FF00) shr 8);
  ACountBytes[0] := Byte(ANum and $000000FF);
  Move(ACountBytes[0], Result[0], Length(ACountBytes));
  if AArrayLength > 0 then
    Move(ABytes[0], Result[Length(ACountBytes)], AArrayLength);
end;

class function TdxByteArray.Concatenate(const AB1, AB2: TBytes): TBytes;
begin
  if AB1 = nil then
    Exit(AB2);
  if AB2 = nil then
    Exit(AB1);
  SetLength(Result, Length(AB1) + Length(AB2));
  Move(AB1[0], Result[0], Length(AB1));
  Move(AB2[0], Result[Length(AB1)], Length(AB2));
end;

class function TdxByteArray.Concatenate(const ABytes: TBytes; ANum: Integer): TBytes;
var
  ACountBytes: TBytes;
  AArrayLength: Integer;
begin
  AArrayLength := Length(ABytes);
  SetLength(Result, AArrayLength + 4);
  SetLength(ACountBytes, 4);
  ACountBytes[3] := Byte((ANum and $FF000000) shr 24);
  ACountBytes[2] := Byte((ANum and $00FF0000) shr 16);
  ACountBytes[1] := Byte((ANum and $0000FF00) shr 8);
  ACountBytes[0] := Byte(ANum and $000000FF);
  if AArrayLength > 0 then
    Move(ABytes[0], Result[0], AArrayLength);
  Move(ACountBytes[0], Result[AArrayLength], Length(ACountBytes));
end;

class function TdxByteArray.Resize(const ABytes: TBytes; ATargetSize: Integer; AFillBy: Byte): TBytes;
begin
  if Length(ABytes) = ATargetSize then
    Exit(ABytes);

  SetLength(Result, ATargetSize);
  ATargetSize := Min(ATargetSize, Length(ABytes));
  Move(ABytes[0], Result[0], ATargetSize);
  FillChar(Result[ATargetSize], Length(Result) - ATargetSize, AFillBy);
end;

{ TdxStream }

constructor TdxStream.Create(AStream: TStream);
begin
  FIsUnicode := dxIsUnicodeStream(AStream);
  if not IsUnicode and (AStream is TdxStream) then
    FIsUnicode := (AStream as TdxStream).IsUnicode;
  FStream := AStream;
end;

function TdxStream.GetSize: Int64;
begin
  Result := FStream.Size;
end;

function TdxStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := FStream.Read(Buffer, Count);
end;

function TdxStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  Result := FStream.Seek(Offset, Origin);
end;

function TdxStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := FStream.Write(Buffer, Count);
end;


function dxSwap16(const AValue: Word): Word;
begin
  Result := MakeWord(HiByte(AValue), LoByte(AValue));
end;

function dxSwap32(const AValue: DWORD): DWORD;
var
  B: array [1..4] of Byte absolute AValue;
  I: Integer;
begin
  Result := 0;
  for I := 1 to 4 do
    Result := DWORD(Result shl 8) or DWORD(B[I]);
end;

procedure ExchangeBooleans(var AValue1, AValue2: Boolean);
var
  ATempValue: Boolean;
begin
  ATempValue := AValue1;
  AValue1 := AValue2;
  AValue2 := ATempValue;
end;

procedure ExchangeIntegers(var AValue1, AValue2: Integer);
var
  ATempValue: Integer;
begin
  ATempValue := AValue1;
  AValue1 := AValue2;
  AValue2 := ATempValue;
end;

procedure ExchangeLongWords(var AValue1, AValue2);
var
  ATempValue: LongWord;
begin
  ATempValue := LongWord(AValue1);
  LongWord(AValue1) := LongWord(AValue2);
  LongWord(AValue2) := ATempValue;
end;

procedure ExchangePointers(var AValue1, AValue2);
var
  ATempValue: Pointer;
begin
  ATempValue := Pointer(AValue1);
  Pointer(AValue1) := Pointer(AValue2);
  Pointer(AValue2) := ATempValue;
end;

procedure ExchangeSingle(var AValue1, AValue2: Single);
var
  ATempValue: Single;
begin
  ATempValue := AValue1;
  AValue1 := AValue2;
  AValue2 := ATempValue;
end;

procedure ExchangeStrings(var AValue1, AValue2: string);
var
  ATempValue: string;
begin
  ATempValue := AValue1;
  AValue1 := AValue2;
  AValue2 := ATempValue;
end;

function ReadBufferFromStream(AStream: TStream; ABuffer: Pointer; Count: Integer): Boolean;
begin
  Result := AStream.Read(ABuffer^, Count) = Count;
end;

function ReadStringFromStream(AStream: TStream; out AValue: AnsiString): Longint;
begin
  SetLength(AValue, AStream.Size);
  Result := AStream.Read(AValue[1], AStream.Size);
end;


{$IFDEF MSWINDOWS}
procedure InitPlatformInfo;
type
  PWKSTA_INFO_100 = ^WKSTA_INFO_100;
  WKSTA_INFO_100 = record
    wki100_platform_id: DWORD;
    wki100_computerName: LPWSTR;
    wki100_LanGroup: LPWSTR;
    wki100_ver_major: DWORD;
    wki100_ver_minor: DWORD;
  end;

  function CheckIsWindowsServer: Boolean;
  const
    VER_EQUAL = 1;
    VER_NT_DOMAIN_CONTROLLER = $0000002;
    VER_NT_SERVER = $0000003;
    VER_NT_WORKSTATION = $0000001;
  var
    AVersionInfo: TOSVersionInfoEx;
  begin
    ZeroMemory(@AVersionInfo, SizeOf(AVersionInfo));
    AVersionInfo.dwOSVersionInfoSize := SizeOf(AVersionInfo);
    AVersionInfo.wProductType := VER_NT_WORKSTATION;
    Result := VerifyVersionInfo(AVersionInfo, VER_PRODUCT_TYPE, VerSetConditionMask(0, VER_PRODUCT_TYPE, VER_EQUAL)) = FALSE;
  end;

  function CheckWindowsVersion(const AVersionInfo: TOSVersionInfoExW; AMajor, AMinor, ABuildNumber: Cardinal): Boolean;
  begin
    Result := (AVersionInfo.dwMajorVersion > AMajor) or
      (AVersionInfo.dwMajorVersion = AMajor) and (AVersionInfo.dwMinorVersion > AMinor) or
      (AVersionInfo.dwMajorVersion = AMajor) and (AVersionInfo.dwMinorVersion = AMinor) and (AVersionInfo.dwBuildNumber >= ABuildNumber);
  end;

var
{$IFNDEF CPUX64}
  AIsWow64Process: function (AHandle: THandle; AWow64Process: PBOOL): BOOL; stdcall;
  AIsWow64: BOOL;
{$ENDIF CPUX64}
  ARtlHandle: THandle;
  ARtlGetVersion: TRtlGetVersion;
  AVersionInfo: TOSVersionInfoExW;
begin
  IsWin9X := Win32Platform = VER_PLATFORM_WIN32_WINDOWS;

  IsWin95 := IsWin9X and (Win32MinorVersion = 0);
  IsWin98 := IsWin9X and (Win32MinorVersion = 10);
  IsWinMe := IsWin9X and (Win32MinorVersion = 90);

  IsWinNT := Win32Platform = VER_PLATFORM_WIN32_NT;

  IsWin2K := IsWinNT and (Win32MajorVersion = 5) and (Win32MinorVersion = 0);
  IsWin2KOrLater := IsWinNT and (Win32MajorVersion >= 5);
  IsWinXP := IsWinNT and (Win32MajorVersion = 5) and (Win32MinorVersion > 0);
  IsWinXPOrLater := IsWinNT and (Win32MajorVersion >= 5) and not IsWin2K;
  IsWin2KOrXP := IsWin2K or IsWinXP;

  IsWinVista := IsWinNT and (Win32MajorVersion = 6) and (Win32MinorVersion = 0);
  IsWinVistaOrLater := IsWinNT and (Win32MajorVersion >= 6);
  IsWinSeven := IsWinNT and (Win32MajorVersion = 6) and (Win32MinorVersion = 1);
  IsWinSevenOrLater := IsWinVistaOrLater and not IsWinVista;
  IsWin8 := IsWinNT and (Win32MajorVersion = 6) and (Win32MinorVersion = 2);
  IsWin8OrLater := IsWinSevenOrLater and not IsWinSeven;

  IsWinServer := IsWinSevenOrLater and CheckIsWindowsServer;

  IsWin10OrLater := False;
  if IsWin8OrLater then
  begin
    ARtlHandle := LoadLibrary('ntdll.dll');
    if ARtlHandle > 32 then
    try
      ARtlGetVersion := GetProcAddress(ARtlHandle, 'RtlGetVersion');
      if Assigned(ARtlGetVersion) then
      begin
        ZeroMemory(@AVersionInfo, SizeOf(AVersionInfo));
        AVersionInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfoExW);
        if ARtlGetVersion(AVersionInfo) = 0 then
        begin
          IsWin10OrLater := CheckWindowsVersion(AVersionInfo, 10, 0, 0);
          IsWin10FallCreatorsUpdate := IsWin10OrLater and (AVersionInfo.dwBuildNumber = 16299);
          IsWin10v1809OrLater := CheckWindowsVersion(AVersionInfo, 10, 0, 17762);
          IsWin10v2004OrLater := CheckWindowsVersion(AVersionInfo, 10, 0, 19041);
          IsWinSupportsAcrylicEffect := CheckWindowsVersion(AVersionInfo, 10, 0, 17064);
          IsWin11OrLater := CheckWindowsVersion(AVersionInfo, 10, 0, 22000);
        end;
      end;
    finally
      FreeLibrary(ARtlHandle);
    end;
  end;

  // IsWow64Process
{$IFDEF CPUX64}
  IsWin64Bit := True;
{$ELSE}
  AIsWow64Process := GetProcAddress(GetModuleHandle(kernel32), 'IsWow64Process');
  if Assigned(AIsWow64Process) and AIsWow64Process(GetCurrentProcess, @AIsWow64) then
    IsWin64Bit := AIsWow64
  else
    IsWin64Bit := False;
{$ENDIF CPUX64}
end;
{$ENDIF}

function dxCompareValues(A, B: Integer): Integer;
begin
  if A < B then
    Result := -1
  else
    if A > B then
      Result := 1
    else
      Result := 0;
end;

function dxCompareValues(A, B: Pointer): Integer;
begin
  if TdxNativeUInt(A) < TdxNativeUInt(B) then
    Result := -1
  else
    if TdxNativeUInt(A) > TdxNativeUInt(B) then
      Result := 1
    else
      Result := 0;
end;

function dxSameText(const A, B: string): Boolean;
begin
  Result := (Length(A) = Length(B)) and SameText(A, B);
end;

function dxGetBuildNumberAsString(ABuildNumber: Cardinal = 0): string;
var
  AMajor, AMinor, ABuild: Integer;
begin
  if ABuildNumber = 0 then
    ABuildNumber := dxBuildNumber;
  dxFactorizeBuildNumber(ABuildNumber, AMajor, AMinor, ABuild);
  Result := Format('%d.%d.%d', [AMajor mod 100, AMinor, ABuild]);
end;

function dxGetShortBuildNumberAsString(ABuildNumber: Cardinal = 0): string;
var
  AMajor, AMinor, ABuild: Integer;
begin
  if ABuildNumber = 0 then
    ABuildNumber := dxBuildNumber;
  dxFactorizeBuildNumber(ABuildNumber, AMajor, AMinor, ABuild);
  Result := Format('%d.%d', [AMajor mod 1000, AMinor]);
end;

procedure dxFactorizeBuildNumber(ABuildNumber: Cardinal; out AMajor, AMinor, ABuild: Integer);
var
  AMinorAndBuild: Integer;
begin
  if ABuildNumber = 0 then
    ABuildNumber := dxBuildNumber;

  AMajor := ABuildNumber div 10000;
  AMinorAndBuild := ABuildNumber mod 10000;
  AMinor := AMinorAndBuild div 100;
  ABuild := AMinorAndBuild mod 100;
end;

function dxGenerateGUID: string;
var
  AGuid: TGUID;
begin
  CreateGUID(AGuid);
  Result := GUIDToString(AGuid);
end;

function dxGenerateID: string;
begin
  Result := dxGenerateGUID;
  Result := Copy(Result, 2, Length(Result) - 2);
end;


  { TdxProductResourceStrings }

constructor TdxProductResourceStrings.Create(const AName: string; AInitializeProc: TdxAddResourceStringsProcedure);
begin
  inherited Create;
  FName := AName;
  FResStringNames := TStringList.Create;
  TStringList(FResStringNames).Sorted := True;
  FInitializeProcedures := TList.Create;
  AddProcedure(AInitializeProc);
end;

destructor TdxProductResourceStrings.Destroy;
begin
  FreeAndNil(FInitializeProcedures);
  FreeAndNil(FResStringNames);
  inherited Destroy;
end;

procedure TdxProductResourceStrings.Add(const AResStringName: string; AResStringAddr: Pointer);
begin
  FResStringNames.AddObject(AResStringName, AResStringAddr);
end;

procedure TdxProductResourceStrings.Clear;
begin
  FResStringNames.Clear;
end;

function TdxProductResourceStrings.GetIndexByName(const AName: string): Integer;
begin
  if not TStringList(FResStringNames).Find(AName, Result) then
    Result := -1;
end;

procedure TdxProductResourceStrings.AddProcedure(AProc: TdxAddResourceStringsProcedure);
begin
  if Assigned(AProc) and (FInitializeProcedures.IndexOf(@AProc) = -1) then
  begin
    FInitializeProcedures.Add(@AProc);
    AProc(Self);
  end;
end;

procedure TdxProductResourceStrings.RemoveProcedure(AProc: TdxAddResourceStringsProcedure);
begin
  FInitializeProcedures.Remove(@AProc);
end;

procedure TdxProductResourceStrings.Translate;
var
  I: Integer;
begin
  for I := 0 to ResStringsCount - 1 do
    SetTranslation(I);
end;

function TdxProductResourceStrings.GetNames(AIndex: Integer): string;
begin
  Result := FResStringNames[AIndex];
end;

function TdxProductResourceStrings.GetResStringsCount: Integer;
begin
  Result := FResStringNames.Count;
end;

procedure TdxProductResourceStrings.SetTranslation(AIndex: Integer);
begin
  dxResourceStringsRepository.OnTranslateResString(Names[AIndex], FResStringNames.Objects[AIndex]);
end;

function TdxProductResourceStrings.GetValues(AIndex: Integer): string;
begin
  Result := LoadResString(PResStringRec(FResStringNames.Objects[AIndex]));
end;

function ShiftPointer(P: Pointer; AOffset: Integer): Pointer;
begin
  Result := Pointer(TdxNativeInt(P) + AOffset);
end;

{$IFDEF MSWINDOWS}
function dxPointToLParam(P: TPoint): LPARAM;
begin
  Result := PointToLParam(P);
end;

function dxLParamToPoint(AParam: LPARAM): TPoint;
begin
{$IFDEF CPUX64}
  Result := TSmallPoint(LongWord(AParam));
{$ELSE}
  Result := SmallPointToPoint(TSmallPoint(AParam));
{$ENDIF}
end;
{$ENDIF}

type
  TSeekMode = (smDup, smUnique);
const
  AModeMap: array[Boolean] of TSeekMode = (smDup, smUnique);
  AModeMask: array[TSeekMode] of Byte = (0, 128);

function ReadStreamByte(AStream: TStream; AMaxPos: Integer; var AByte: Byte): Boolean;
begin
  Result := AStream.Position < AMaxPos;
  if Result then
    AStream.Read(AByte, SizeOf(Byte));
end;

procedure WriteStreamByte(AStream: TStream; AByte: Byte);
begin
  AStream.Write(AByte, SizeOf(Byte));
end;

function CompareBlock(const ABlock1, ABlock2: TBytes): Boolean;
begin
  Result := (Length(ABlock1) = Length(ABlock2)) and CompareMem(ABlock1, ABlock2, Length(ABlock1));
end;

function ReadStreamBlock(AStream: TStream; AMaxPos: Integer; var ABlock: TBytes; ABlockSize: Integer): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to ABlockSize - 1 do
    Result := Result and ReadStreamByte(AStream, AMaxPos, ABlock[I]);
end;

procedure WriteStreamBlock(AStream: TStream; const ABlock: TBytes; ABlockSize: Integer);
var
  I: Integer;
begin
  for I := 0 to ABlockSize - 1 do
    WriteStreamByte(AStream, ABlock[I]);
end;

procedure dxCompressStream(ASourceStream, ADestStream: TStream; ACompressMethod: Byte; ASize: Integer);

  procedure CompressByBlock(ASourceStream, ADestStream: TStream; ASize, ABlockSize: Integer);

    function GetCounter(const ASeekBlock: TBytes; AMode: TSeekMode; AMaxPos: Integer): Integer;
    var
      ABlock: TBytes;
    begin
      Result := 1;
      SetLength(ABlock, ABlockSize);
      while (Result < 125) and ReadStreamBlock(ASourceStream, AMaxPos, ABlock, ABlockSize) do
      begin
        if (AMode = smDup) and CompareBlock(ABlock, ASeekBlock) or (AMode = smUnique) and not CompareBlock(ABlock, ASeekBlock) then
          Inc(Result)
        else
        begin
          if AMode = smUnique then
            Dec(Result);
          Break;
        end;
        cxCopyData(ABlock, ASeekBlock, ABlockSize);
      end;
    end;

  var
    AReadBlock1, AReadBlock2: TBytes;
    ACounter, AReadCount: Integer;
    AStreamPos, AMaxPos: Integer;
    AMode: TSeekMode;
  begin
    AMaxPos := ASourceStream.Position + ASize;

    SetLength(AReadBlock1, ABlockSize);
    SetLength(AReadBlock2, ABlockSize);

    while ReadStreamBlock(ASourceStream, AMaxPos, AReadBlock1, ABlockSize) do
    begin
      AReadCount := ABlockSize;
      AStreamPos := ASourceStream.Position - ABlockSize;
      if ReadStreamBlock(ASourceStream, AMaxPos, AReadBlock2, ABlockSize) then
      begin
        Inc(AReadCount, ABlockSize);
        AMode := AModeMap[(AReadCount = ABlockSize) or not CompareBlock(AReadBlock1, AReadBlock2)];
        ASourceStream.Position := ASourceStream.Position - (AReadCount - ABlockSize);
        ACounter := GetCounter(AReadBlock1, AMode, AMaxPos);
      end
      else
      begin
        AMode := smUnique;
        ACounter := 1;
      end;

      WriteStreamByte(ADestStream, ACounter or AModeMask[AMode]);
      case AMode of
        smUnique:
          begin
            ASourceStream.Position := AStreamPos;
            ADestStream.CopyFrom(ASourceStream, ACounter * ABlockSize);
          end;
        smDup:
          WriteStreamBlock(ADestStream, AReadBlock1, ABlockSize);
      end;
      ASourceStream.Position := AStreamPos + ACounter * ABlockSize;
    end;
  end;

var
  ABlockSize, AShift: Byte;
  APrevPosition: Integer;
begin
  if ASize = 0 then
    ASize := ASourceStream.Size - ASourceStream.Position;
  APrevPosition := ADestStream.Position;
  ADestStream.Position := ADestStream.Position + SizeOf(Integer);
  WriteStreamByte(ADestStream, ACompressMethod);
  if (ACompressMethod >= 1) and (ACompressMethod <= 4) then
  begin
    ABlockSize := ACompressMethod;
    AShift := ASize mod ABlockSize;
    WriteStreamByte(ADestStream, AShift);
    if AShift > 0 then
      ADestStream.CopyFrom(ASourceStream, AShift);
    CompressByBlock(ASourceStream, ADestStream, ASize - AShift, ABlockSize);
  end
  else
{    if ACompressMethod = 5 then
    begin

    end;
    else
    }
      ADestStream.CopyFrom(ASourceStream, ASize);
  ASize := ADestStream.Position - APrevPosition;
  ADestStream.Position := APrevPosition;
  ADestStream.Write(ASize, SizeOf(ASize));
  ADestStream.Position := APrevPosition + ASize;
end;

procedure dxDecompressStream(ASourceStream, ADestStream: TStream);

  procedure DecompressByBlock(ASourceStream, ADestStream: TStream; ASize, ABlockSize: Integer);
  var
    ACode: Byte;
    AReadBlob: TBytes;
    AMaxPos: Integer;
    I: Integer;
    ACounter: Integer;
  begin
    AMaxPos := ASourceStream.Position + ASize;

    SetLength(AReadBlob, ABlockSize);

    while ReadStreamByte(ASourceStream, AMaxPos, ACode) do
    begin
      ACounter := ACode and 127;
      if (ACode and AModeMask[smUnique]) <> 0 then
        ADestStream.CopyFrom(ASourceStream, ACounter * ABlockSize)
      else
      begin
        ReadStreamBlock(ASourceStream, AMaxPos, AReadBlob, ABlockSize);
        for I := 0 to ACounter - 1 do
          WriteStreamBlock(ADestStream, AReadBlob, ABlockSize);
      end;
    end;
  end;

var
  ASize: Integer;
  ACompressMethod, AShift: Byte;
begin
  ASourceStream.Read(ASize, SizeOf(ASize));
  ASourceStream.Read(ACompressMethod, SizeOf(ACompressMethod));
  if (ACompressMethod >= 1) and (ACompressMethod <= 4) then
  begin
    ASourceStream.Read(AShift, SizeOf(AShift));
    if AShift > 0 then
      ADestStream.CopyFrom(ASourceStream, AShift);
    DecompressByBlock(ASourceStream, ADestStream, ASize - 6 - AShift, ACompressMethod);
  end
  else
    ADestStream.CopyFrom(ASourceStream, ASize - 5);
end;

{$IFDEF MSWINDOWS}

function dxCanReadMemory(P: Pointer; ASize: Cardinal): Boolean;
var
  AInfo: TMemoryBasicInformation;
begin
  if VirtualQuery(P, AInfo, SizeOf(AInfo)) = SizeOf(AInfo) then
    Result := (AInfo.Protect and PAGE_NOACCESS = 0) and
      ((NativeUInt(AInfo.BaseAddress) + AInfo.RegionSize) > (NativeUInt(P) + ASize))
  else
    Result := False;
end;

function dxGetAnsiCharCType1(Ch: AnsiChar): Word;
begin
  if not dxGetStringTypeA(GetThreadLocale, CT_CTYPE1, @Ch, 1, Result) then
    Result := 0;
end;

function dxGetWideCharCType1(Ch: WideChar): Word;
begin
  if not dxGetStringTypeW(CT_CTYPE1, @Ch, 1, Result) then
    Result := 0;
end;

procedure cxZeroMemory(ADestination: Pointer; ACount: Integer);
begin
  ZeroMemory(ADestination, ACount);
end;

function cxAllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  cxZeroMemory(Result, Size);
end;
{$ENDIF}

procedure cxFreeMem(P: Pointer);
begin
  FreeMem(P);
end;

{$IFDEF MSWINDOWS}
function dxGetStringTypeA(Locale: LCID; dwInfoType: DWORD; const lpSrcStr: PAnsiChar;
  cchSrc: Integer; var lpCharType): BOOL;
begin
  Result := GetStringTypeA(Locale, dwInfoType, lpSrcStr, cchSrc, lpCharType);
end;

function dxGetStringTypeW(dwInfoType: DWORD; const lpSrcStr: PWideChar;
  cchSrc: Integer; var lpCharType): BOOL;
begin
  Result := GetStringTypeW(dwInfoType, lpSrcStr, cchSrc, lpCharType);
end;
{$ENDIF}

procedure cxCopyData(ASource, ADestination: Pointer; ACount: Integer);
begin
  Move(ASource^, ADestination^, ACount);
end;

procedure cxCopyData(ASource, ADestination: Pointer; ASourceOffSet, ADestinationOffSet, ACount: Integer);
begin
  cxCopyData(PByte(ASource) + ASourceOffset, PByte(ADestination) + ADestinationOffset, ACount);
end;

procedure dxFillChar(var ADest; Count: Integer; const APattern: Char);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    PWordArray(@ADest)^[I] := Word(APattern);
end;

procedure dxFreeAndNil(var AObject);
begin
  TObject(AObject).Free;
  Pointer(AObject) := nil;
end;

procedure dxAppendList(ASource, ADestination: TList);
var
  APrevDestinationCount: Integer;
begin
  APrevDestinationCount := ADestination.Count;
  ADestination.Count := ADestination.Count + ASource.Count;
  cxCopyData(ASource.List, ADestination.List, 0, APrevDestinationCount * SizeOf(Pointer),
    ASource.Count * SizeOf(Pointer));
end;

procedure dxCopyList(ASource, ADestination: TList);
begin
  ADestination.Count := ASource.Count;
  cxCopyData(ASource.List, ADestination.List, ASource.Count * SizeOf(Pointer));
end;

function dxAnsiStringToString(const S: AnsiString; ACodePage: Integer = CP_ACP): string;
const
{$IFNDEF MSWINDOWS}
  MB_PRECOMPOSED = 1;
{$ENDIF}
  ConversionFlags: array[Boolean] of Integer = (MB_PRECOMPOSED, 0);
var
  ADestLength: Integer;
begin
  if S = '' then
    Exit('');
  if {$IFDEF MSWINDOWS} not IsWinNT and {$ENDIF}
    (ACodePage = CP_UTF8) then //CP_UTF8 not supported on Windows 95
    Exit(UTF8ToString(S));
  ADestLength := UnicodeFromLocaleChars(ACodePage, 0, PAnsiChar(S), Length(S), nil, 0);
  SetLength(Result, ADestLength);
  UnicodeFromLocaleChars(ACodePage, ConversionFlags[ACodePage = CP_UTF8], PAnsiChar(S), Length(S), PWideChar(Result), ADestLength);
end;

function dxStringToAnsiString(const S: string; ACodePage: Integer = CP_ACP): AnsiString;
var
  ADestLength: Integer;
begin
  if S = '' then
    Exit('');
  if {$IFDEF MSWINDOWS} not IsWinNT and {$ENDIF}
    (ACodePage = CP_UTF8) then //CP_UTF8 not supported on Windows 95
    Exit(UTF8Encode(S));
  ADestLength := LocaleCharsFromUnicode(ACodePage, 0, PWideChar(S), Length(S), nil, 0, nil, nil);
  SetLength(Result, ADestLength);
  LocaleCharsFromUnicode(ACodePage, 0, PWideChar(S), Length(S), PAnsiChar(Result), ADestLength, nil, nil);
end;

function dxVariantToString(const V: Variant): string;
begin
  if VarIsStr(V) then
    Result := VarToStr(V)
  else
    Result := dxAnsiStringToString(dxVariantToAnsiString(V));
end;

function dxVariantToAnsiString(const V: Variant): AnsiString;
var
  ASize: Integer;
begin
  if VarIsArray(V) and (VarArrayDimCount(V) = 1) then
  begin
    ASize := VarArrayHighBound(V, 1) - VarArrayLowBound(V, 1) + 1;
    SetLength(Result, ASize);
    Move(VarArrayLock(V)^, Result[1], ASize);
    VarArrayUnlock(V);
  end
  else
    if VarType(V) = varString then
      Result := AnsiString(TVarData(V).VString)
    else
      Result := dxStringToAnsiString(VarToStr(V))
end;

function dxVarIsBlob(const V: Variant): Boolean;
begin
  Result := VarIsStr(V) or (VarIsArray(V) and (VarArrayDimCount(V) = 1));
end;

function dxShortStringToString(const S: ShortString): string;
begin
  Result := UTF8ToString(S);
end;

function dxStringToShortString(const S: string): ShortString;
begin
  Result := UTF8EncodeToShortString(S);
end;


procedure dxAbstractError;
begin
  dxTestCheck(False, SAbstractError);
end;

procedure dxTestCheck(AValue: WordBool; const AMessage: string);
begin
//do nothing
end;

procedure dxCheckOrientation(var AValue: TdxOrientation; ADefaultOrientation: TdxOrientation);
begin
  if Ord(AValue) = -1 then
    AValue := ADefaultOrientation;
end;

procedure dxShowException(AException: TObject);
begin
{$IFDEF VCL}
  if Assigned(Application) then
    Application.ShowException(AException as Exception)
  else
{$ENDIF}
   SysUtils.ShowException(AException, nil);
end;

{$IFDEF MSWINDOWS}
function dxGetInvariantLocaleID: Integer;
begin
  if IsWinXPOrLater then
    Result := LOCALE_INVARIANT
  else
    Result := dxMakeLCID(dxMakeLangID(LANG_ENGLISH, SUBLANG_ENGLISH_US), SORT_DEFAULT);
end;

procedure dxGetLocaleFormatSettings(ALocale: Integer; var AFormatSettings: TFormatSettings);

  procedure DoGetLocaleFormatSettings(var AFormatSettings: TFormatSettings);
  begin
    AFormatSettings := TFormatSettings.Create(ALocale)
  end;

var
  APrevLocale: Integer;
begin
  if not IsValidLocale(ALocale, LCID_INSTALLED) and IsValidLocale(ALocale, LCID_SUPPORTED) then
  begin
    APrevLocale := GetThreadLocale;
    try
      SetThreadLocale(ALocale);
      DoGetLocaleFormatSettings(AFormatSettings);
    finally
      SetThreadLocale(APrevLocale);
    end;
  end
  else
    DoGetLocaleFormatSettings(AFormatSettings);
end;

function dxGetLocaleInfo(ALocale, ALocaleType: Integer; const ADefaultValue: string = ''): string;
var
  ABuffer: string;
  ABufferSize: Integer;
begin
  ABufferSize := GetLocaleInfo(ALocale, ALocaleType, nil, 0);
  if ABufferSize = 0 then
    Result := ADefaultValue
  else
  begin
    SetLength(ABuffer, ABufferSize);
    GetLocaleInfo(ALocale, ALocaleType, PChar(ABuffer), ABufferSize);
    Result := Copy(ABuffer, 1, ABufferSize - 1)
  end;
end;

function dxMakeLangID(APrimaryLang, ASubLang: Word): Word;
begin
  Result := MAKELANGID(APrimaryLang, ASubLang);
end;

function dxMakeLCID(ALangId, ASortId: Word): DWORD;
begin
  Result := MAKELCID(ALangId, ASortId)
end;

function dxGetSubLangID(ALangId: Word): Word;
begin
  Result := SUBLANGID(ALangId);
end;

function dxGetUserName: string;
var
  ABuffer:  array[0..MaxUserNameSize + 1] of Char;
  ABufferSize: Cardinal;
begin
  ABufferSize := MaxUserNameSize + 1;
  GetUserName(ABuffer, ABufferSize);
  SetString(Result, ABuffer, ABufferSize - 1);
end;

function dxGetUserNameEx(AFormat: DWORD): string;
var
  ABuffer:  array[0..MaxUserNameSize] of WideChar;
  ABufferSize: Cardinal;
begin
  if not IsWin10OrLater then
  begin
    if not FGetUserNameExChecked then
    begin
      FGetUserNameExChecked := True;
      FGetUserNameExProc := GetProcAddress(LoadLibrary('secur32.dll'), 'GetUserNameExW');
    end;

    if Assigned(FGetUserNameExProc) then
    begin
      ABufferSize := MaxUserNameSize;
      ZeroMemory(@ABuffer, SizeOf(ABuffer));
      if FGetUserNameExProc(AFormat, @ABuffer[0], ABufferSize) and (ABufferSize > 0) and (ABuffer[0] <> #0) then
      begin
        SetString(Result, ABuffer, ABufferSize);
        Exit;
      end;
    end;
  end;
  Result := dxGetUserName;
end;

function dxShellExecute(AHandle: HWND; const AFileName: string; AShowCmd: Integer = SW_SHOWNORMAL): Boolean;
begin
  Result := ShellExecute(AHandle, 'open', PChar(AFileName), nil, nil, AShowCmd) >= 32;
end;

function dxShellExecute(const AFileName: string; AShowCmd: Integer = SW_SHOWNORMAL): Boolean;
begin
  Result := dxShellExecute(0, AFileName, AShowCmd);
end;
{$ENDIF}

procedure dxCallNotify(ANotifyEvent: TNotifyEvent; ASender: TObject);
begin
  if Assigned(ANotifyEvent) then
    ANotifyEvent(ASender);
end;

{$IFDEF MSWINDOWS}
function dxGetTickCount: Int64;
begin
  if not QueryPerformanceCounter(Result) then
    Result := GetTickCount
  else
    Result := Result div 1000;
end;
{$ENDIF}

function dxSameMethods(const Method1, Method2): Boolean;
begin
  Result := (TMethod(Method1).Code = TMethod(Method2).Code) and
    (TMethod(Method1).Data = TMethod(Method2).Data);
end;

function dxBooleanToDefaultBoolean(AValue: Boolean): TdxDefaultBoolean;
begin
  Result := TdxDefaultBoolean(AValue);
end;

function dxDefaultBooleanToBoolean(AValue: TdxDefaultBoolean; ADefault: Boolean): Boolean;
begin
  if AValue = bDefault then
    Result := ADefault
  else
    Result := Boolean(AValue);
end;

function dxMakeInt64(const A, B: Integer): Int64;
begin
  Result := Int64(A) or (Int64(B) shl 32);
end;

// math
function dxFMod(const ANumerator, ADenominator: Single): Single;
begin
  Result := ANumerator - Trunc(ANumerator / ADenominator) * ADenominator;
end;

function dxFMod(const ANumerator, ADenominator: Double): Double;
begin
  Result := ANumerator - Trunc(ANumerator / ADenominator) * ADenominator;
end;

function dxFMod(const ANumerator, ADenominator: Extended): Extended;
begin
  Result := ANumerator - Trunc(ANumerator / ADenominator) * ADenominator;
end;

// string functions
function dxBinToHex(const ABuffer: AnsiString): AnsiString;
begin
  Result := dxBinToHex(PAnsiChar(ABuffer), Length(ABuffer));
end;

function dxBinToHex(const ABuffer: PAnsiChar; ABufSize: Integer): AnsiString;
begin
  SetLength(Result, ABufSize * 2);
  BinToHex(ABuffer, PAnsiChar(Result), ABufSize);
end;

function dxHexToBin(const AText: AnsiString): AnsiString;
begin
  Result := dxHexToBin(PAnsiChar(AText));
end;

function dxHexToBin(const AText: PAnsiChar): AnsiString;
begin
  SetLength(Result, Length(AText) div 2);
  HexToBin(AText, PAnsiChar(Result), Length(Result));
end;

function dxHexToByte(const AHex: string): Byte;
var
  S: string;
begin
  S := DupeString('0', 2 - Length(AHex)) + AHex;
  HexToBin(PChar(S), @Result, SizeOf(Result));
end;

function dxCharCount(const S: string): Integer;
begin
  Result := ElementToCharLen(S, Length(S));
end;

procedure dxWriteStandardEncodingSignature(AStream: TStream);
begin
  AStream.WriteBuffer(dxUnicodePrefix, SizeOf(dxUnicodePrefix));
end;

procedure dxWriteStreamType(AStream: TStream);
begin
{$IFNDEF STREAMANSIFORMAT}
   AStream.WriteBuffer(StreamFormatUNICODE, SizeOf(TdxStreamHeader));
{$ENDIF}
end;

function WriteBufferToStream(AStream: TStream; ABuffer: Pointer; ACount: Longint): Longint;
var
  AData: TBytes;
begin
  SetLength(AData, ACount);
  if ABuffer <> nil then
    cxCopyData(ABuffer, AData, ACount);

  Result := AStream.Write(AData[0], ACount);
end;

function WriteCharToStream(AStream: TStream; AValue: AnsiChar): Longint;
begin
  Result := AStream.Write(AValue, 1);
end;

function WriteDoubleToStream(AStream: TStream; AValue: Double): Longint;
begin
  Result := AStream.Write(AValue, SizeOf(Double));
end;

function WriteIntegerToStream(AStream: TStream; AValue: Integer): Longint;
begin
  Result := AStream.Write(AValue, SizeOf(Integer));
end;

function WriteSmallIntToStream(AStream: TStream; AValue: SmallInt): Longint;
begin
  Result := AStream.Write(AValue, SizeOf(SmallInt));
end;

function WriteStringToStream(AStream: TStream; const AValue: AnsiString): Longint;
begin
  Result := AStream.Write(PAnsiChar(AValue)^, Length(AValue));
end;

procedure dxWriteStr(Stream: TStream; const S: string);
var
  L: Integer;
{$IFDEF STREAMANSIFORMAT}
  SA: AnsiString;
{$ENDIF}
begin
  L := Length(S);
  if L > $FFFF then L := $FFFF;
  Stream.WriteBuffer(L, SizeOf(Word));
  if L > 0 then
  begin
  {$IFDEF STREAMANSIFORMAT}
    SA := UTF8Encode(S);
    Stream.WriteBuffer(SA[1], L);
  {$ELSE}
    Stream.WriteBuffer(S[1], L * SizeOf(Char));
  {$ENDIF}
  end;
end;

function dxStreamToHGlobal(AStream: TMemoryStream): HGLOBAL;
var
  ABuffer: Pointer;
  ASize: Int64;
begin
  Result := 0;
  if AStream <> nil then
  begin
    ASize := AStream.Size;
    if ASize > 0 then
    begin
      Result := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, ASize);
      if Result <> 0 then
      try
        ABuffer := GlobalLock(Result);
        try
          Move(AStream.Memory^, ABuffer^, ASize);
        finally
          GlobalUnlock(Result);
        end;
      except
        GlobalFree(Result);
        raise;
      end;
    end;
  end;
end;

function dxStreamToVariant(AStream: TStream): Variant;
var
  ASavePos: Integer;
begin
  Result := Null;
  ASavePos := AStream.Position;
  try
    AStream.Position := 0;
    Result := dxStreamToVariant(AStream, AStream.Size);
  finally
    AStream.Position := ASavePos;
  end;
end;

function dxStreamToVariant(AStream: TStream; ASize: Integer): Variant;
var
  ASavePos: Integer;
  ABinaryData: AnsiString;
begin
  Result := Null;
  if ASize > AStream.Size - AStream.Position then
    ASize := AStream.Size - AStream.Position;
  if ASize <= 0 then
    Exit;
  SetLength(ABinaryData, ASize);
  ASavePos := AStream.Position;
  AStream.ReadBuffer(ABinaryData[1], ASize);
  AStream.Position := ASavePos;
  Result := ABinaryData;
end;

function dxCharInSet(C: Char; const ACharSet: TdxAnsiCharSet): Boolean;
begin
  Result := CharInSet(C, ACharSet);
end;

function dxStringSize(const S: string): Integer;
begin
  Result := Length(S) * SizeOf(Char);
end;

{$IFDEF MSWINDOWS}
function dxCreateTempFile(const AExtension: string = ''): string;
var
  ABuffer: array[0..MAX_PATH] of Char;
begin
  repeat
    GetTempPath(MAX_PATH, ABuffer);
    GetTempFileName(ABuffer, '~DX', 0, ABuffer);
    if AExtension = '' then
      Exit(ABuffer);

    Result := ChangeFileExt(ABuffer, AExtension);
    if RenameFile(ABuffer, Result) then
      Exit;
    if GetLastError = ERROR_ALREADY_EXISTS then
      DeleteFile(ABuffer)
    else
      RaiseLastOSError;
  until False;
end;
{$ENDIF}

function dxIsPathDelimiter(const S: string; Index: Integer; const APathDelimiter: Char = PathDelim): Boolean;
begin
  Result := (Index > 0) and (Index <= Length(S)) and (S[Index] = APathDelimiter) and (ByteType(S, Index) = mbSingleByte);
end;

function dxExcludeTrailingPathDelimiter(const APath: string; const APathDelimiter: Char = PathDelim): string;
var
  AIndex: Integer;
begin
  Result := APath;
  AIndex := Length(Result);
  if dxIsPathDelimiter(Result, AIndex, APathDelimiter) then
    SetLength(Result, AIndex - 1);
end;

function dxExtractFileName(const APath: string; const APathDelimiter: Char = PathDelim): string;
var
  AIndex: Integer;
begin
  AIndex := LastDelimiter(APathDelimiter + DriveDelim, APath);
  Result := Copy(APath, AIndex + 1, MaxInt);
end;

function dxIncludeTrailingPathDelimiter(const APath: string; const APathDelimiter: Char = PathDelim): string;
begin
  if dxIsPathDelimiter(APath, Length(APath), APathDelimiter) then
    Result := APath
  else
    Result := APath + APathDelimiter;
end;

function dxReplacePathDelimiter(const APath: AnsiString; const AOldDelimiter, ANewDelimiter: AnsiChar): AnsiString;
begin
  if AOldDelimiter <> ANewDelimiter then
    Result := AnsiStrings.StringReplace(APath, AOldDelimiter, ANewDelimiter, [rfReplaceAll])
  else
    Result := APath;
end;

function dxReplacePathDelimiter(const APath: string; const AOldDelimiter, ANewDelimiter: Char): string;
begin
  if AOldDelimiter <> ANewDelimiter then
    Result := StringReplace(APath, AOldDelimiter, ANewDelimiter, [rfReplaceAll])
  else
    Result := APath;
end;

function dxReadStr(Stream: TStream; AIsUnicode: Boolean): string;
var
  L: Word;
  SA: AnsiString;
  SW: WideString;
begin
  Stream.ReadBuffer(L, SizeOf(Word));
  if AIsUnicode then
  begin
    SetLength(SW, L);
    if L > 0 then Stream.ReadBuffer(SW[1], L * 2);
    Result := SW;
  end
  else
  begin
    SetLength(SA, L);
    if L > 0 then Stream.ReadBuffer(SA[1], L);
    Result := UTF8ToWideString(SA);
  end;
end;

function dxResourceStringsRepository: TdxResourceStringsRepository;
begin
  if FdxResourceStringsRepository = nil then
    FdxResourceStringsRepository := TdxResourceStringsRepository.Create;
  Result := FdxResourceStringsRepository;
end;

type
  TcxResourceStringsModificationMode = (rmmByResStringValue, rmmByResStringID, rmmUndefined);

  TcxResOriginalStrings = class(TStringList)
  public
    constructor Create;
  end;

var
  FResOriginalStrings: TcxResOriginalStrings;
  FResStrings: TStringList;
  FResStringsModificationMode: TcxResourceStringsModificationMode = rmmUndefined;

procedure DestroyResStringLists;
begin
  FResStringsModificationMode := rmmUndefined;
  FreeAndNil(FResOriginalStrings);
  FreeAndNil(FResStrings);
end;

constructor TcxResOriginalStrings.Create;
begin
  inherited Create;
  CaseSensitive := True;
end;

procedure CreateResStringLists(AResStringsModificationMode: TcxResourceStringsModificationMode);
begin
  if AResStringsModificationMode = rmmUndefined then
    raise EdxException.Create('');
  if (FResStringsModificationMode <> rmmUndefined) and
    (AResStringsModificationMode <> FResStringsModificationMode) then
      raise EdxException.Create('You cannot mix cxSetResourceString and cxSetResourceStringNet calls');

  if FResStringsModificationMode = rmmUndefined then
  begin
    FResStringsModificationMode := AResStringsModificationMode;
    FResOriginalStrings := TcxResOriginalStrings.Create;
    FResStrings := TStringList.Create;
  end;
end;

function GetResOriginalStringIndex(AResString: TcxResourceStringID): Integer;
begin
  case FResStringsModificationMode of
    rmmByResStringValue:
      Result := FResOriginalStrings.IndexOf(LoadResString(AResString));
    rmmByResStringID:
      Result := FResOriginalStrings.IndexOfObject(TObject(AResString));
  else
    Result := -1;
  end;
end;

function cxGetResourceString(AResString: TcxResourceStringID): string;
var
  AIndex: Integer;
begin
  AIndex := GetResOriginalStringIndex(AResString);
  if AIndex <> -1 then
    Result := FResStrings[AIndex]
  else
    Result := LoadResString(AResString);
end;

procedure cxSetResourceString(AResString: TcxResourceStringID; const Value: string);
var
  AIndex: Integer;
begin
  CreateResStringLists(rmmByResStringID);
  AIndex := GetResOriginalStringIndex(AResString);
  if AIndex <> -1 then
    FResStrings[AIndex] := Value
  else
  begin
    FResOriginalStrings.AddObject(LoadResString(AResString), TObject(AResString));
    FResStrings.Add(Value);
  end;
end;

function cxGetResourceString(const AResString: string): string; deprecated;
begin
  Result := cxGetResourceStringNet(AResString);
end;

function cxGetResourceStringNet(const AResString: string): string; deprecated;
var
  AIndex: Integer;
begin
  Result := AResString;
  if FResOriginalStrings <> nil then
  begin
    AIndex := FResOriginalStrings.IndexOf(AResString);
    if AIndex <> -1 then
      Result := FResStrings[AIndex];
  end
end;

procedure cxSetResourceStringNet(const AResString, Value: string); deprecated;
var
  AIndex: Integer;
begin
  CreateResStringLists(rmmByResStringValue);
  AIndex := FResOriginalStrings.IndexOf(AResString);
  if AIndex <> -1 then
    FResStrings[AIndex] := Value
  else
  begin
    FResOriginalStrings.Add(AResString);
    FResStrings.Add(Value);
  end;
end;

procedure cxClearResourceStrings;
begin
  if FResStrings <> nil then
    FResStrings.Clear;
  if FResOriginalStrings <> nil then
    FResOriginalStrings.Clear;
end;

function dxFindLocalizedResourceString(const AdxResourceString: string; out ALocalizedString: string): Boolean;
begin
{$WARNINGS OFF}
  ALocalizedString := cxGetResourceString(AdxResourceString); 
{$WARNINGS ON}
  Result := ALocalizedString <> AdxResourceString; 
end;

function dxGetSystemResourceString(ALibraryHandle: THandle; const AStringID: Integer;
  const ADefaultValue: string = ''): string;
const
  MaxResourceStringLength = 4097; 
var
  ABuffer: array [0..MaxResourceStringLength - 1] of Char;
  ACount: Integer;
  P: PChar;
begin 
  Result := ADefaultValue;
  if ALibraryHandle > 0 then
  begin
    P := @ABuffer[0];
    ACount := LoadString(ALibraryHandle, AStringID, P, MaxResourceStringLength);
    if ACount > 0 then
      SetString(Result, P, ACount);
  end;
end;

function dxGetLocalizedSystemResourceString(const AdxResourceString: string; ALibraryHandle: THandle;
  const AStringID: Integer): string;
begin
  if not dxFindLocalizedResourceString(AdxResourceString, Result) then
    Result := dxGetSystemResourceString(ALibraryHandle, AStringID, Result);
end;

function dxGetLocalizedSystemResourceString(const AdxResourceString: string; const ALibraryName: string;
  const AStringID: Integer): string;
var
  ALibraryHandle: THandle;
begin
  ALibraryHandle := LoadLibraryEx(PChar(ALibraryName), 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    Result := dxGetLocalizedSystemResourceString(AdxResourceString, ALibraryHandle, AStringID);
  finally
    if ALibraryHandle <> 0 then
      FreeLibrary(ALibraryHandle);
  end;
end;

function dxIsUnicodeStream(AStream: TStream): Boolean;
var
  B: TdxStreamHeader;
begin
  Result := False;
  if (AStream.Size - AStream.Position) >= SizeOf(TdxStreamHeader) then
  begin
    AStream.ReadBuffer(B, SizeOf(TdxStreamHeader));
    Result := B = StreamFormatUNICODE;
    if not Result and (B <> StreamFormatANSI) then
      AStream.Position := AStream.Position - SizeOf(TdxStreamHeader);
  end;
end;

function ReadBoolean(ASource: Pointer; AOffset: Integer = 0): WordBool;
begin
  Result := PWordBool(PByte(ASource) + AOffset)^;
end;

function ReadByte(ASource: Pointer; AOffset: Integer = 0): Byte;
begin
  Result := (PByte(ASource) + AOffset)^;
end;

function ReadInteger(ASource: Pointer; AOffset: Integer = 0): Integer;
begin
  Result := PInteger(PByte(ASource) + AOffset)^;
end;

function ReadPointer(ASource: Pointer): Pointer;
begin
  Result := Pointer(ASource^);
end;

function ReadWord(ASource: Pointer; AOffset: Integer = 0): Word;
begin
  Result := PWord(PByte(ASource) + AOffset)^;
end;

{$IFDEF MSWINDOWS}
function dxAnsiIsAlpha(Ch: AnsiChar): Boolean;
begin
  Result := dxGetAnsiCharCType1(Ch) and C1_ALPHA > 0;
end;

function dxCharIsAlpha(Ch: Char): Boolean;
begin
  Result := dxWideIsAlpha(Ch);
end;

function dxWideIsAlpha(Ch: WideChar): Boolean;
begin
  Result := dxGetWideCharCType1(Ch) and C1_ALPHA > 0;
end;

function dxAnsiIsNumeric(Ch: AnsiChar): Boolean;
begin
  Result := dxGetAnsiCharCType1(Ch) and C1_DIGIT > 0;
end;

function dxCharIsNumeric(Ch: Char): Boolean;
begin
  Result := dxWideIsNumeric(Ch);
end;

function dxWideIsNumeric(Ch: WideChar): Boolean;
begin
  Result := dxGetWideCharCType1(Ch) and C1_DIGIT > 0;
end;

function dxWideIsSpace(Ch: WideChar): Boolean;
begin
  Result := dxGetWideCharCType1(Ch) and C1_SPACE > 0;
end;
{$ENDIF}

function dxIsWhiteSpace(AChar: Char): Boolean; inline;
begin
  Result := AChar.IsWhiteSpace;
end;

function dxIsLowerCase(AChar: Char): Boolean; inline;
begin
  Result := AChar.IsLower;
end;

function dxLowerCase(AChar: Char): Char; inline;
begin
  Result := AChar.ToLower;
end;

function dxUpperCase(AChar: Char): Char; inline;
begin
  Result := AChar.ToUpper;
end;

function dxStrComp(const Str1, Str2: PAnsiChar): Integer;
begin
  Result := AnsiStrings.StrComp(Str1, Str2);
end;

function dxStrCopy(ADest: PAnsiChar; const ASource: PAnsiChar): PAnsiChar;
begin
  Result := AnsiStrings.StrCopy(ADest, ASource)
end;

function dxStrLCopy(ADest: PAnsiChar; const ASource: PAnsiChar; AMaxLen: Cardinal): PAnsiChar;
begin
  Result := AnsiStrings.StrLCopy(ADest, ASource, AMaxLen)
end;

function dxStrLen(const AStr: PAnsiChar): Cardinal;
begin
  Result := AnsiStrings.StrLen(AStr);
end;

{$IFDEF MSWINDOWS}
function dxGetCodePageFromCharset(ACharset: Integer): Integer;
begin
  if (ACharset = DEFAULT_CHARSET) or (ACharset = ANSI_CHARSET) then //speedup
  begin
    Result := 0;
    Exit;
  end;
  case ACharset of
    THAI_CHARSET:
      Result := 874;
    SHIFTJIS_CHARSET:
      Result := 932;
    GB2312_CHARSET:
      Result := 936;
    HANGEUL_CHARSET, JOHAB_CHARSET:
      Result := 949;
    CHINESEBIG5_CHARSET:
      Result := 950;
    EASTEUROPE_CHARSET:
      Result := 1250;
    RUSSIAN_CHARSET:
      Result := 1251;
    GREEK_CHARSET:
      Result := 1253;
    TURKISH_CHARSET:
      Result := 1254;
    HEBREW_CHARSET:
      Result := 1255;
    ARABIC_CHARSET:
      Result := 1256;
    BALTIC_CHARSET:
      Result := 1257;
  else
    Result := 0;
  end;
end;

{$ENDIF}

function dxAnsiStringToWideString(const ASource: AnsiString; ACodePage: Cardinal = CP_ACP): WideString;
begin
  Result := dxAnsiStringToString(ASource, ACodePage);
end;

function dxWideStringToAnsiString(const ASource: WideString; ACodePage: Cardinal = CP_ACP): AnsiString;
begin
  Result := dxStringToAnsiString(ASource, ACodePage);
end;

function dxAnsiStrToInt(const S: AnsiString): Integer;
begin
  Result := StrToInt(dxAnsiStringToString(S));
end;

function dxConcatenateStrings(const AStrings: array of PChar): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(AStrings) - 1 do
    Result := Result + AStrings[I];
end;

procedure dxStringToBytes(const S: string; var Buf);
begin
  if Length(S) > 0 then
    Move(S[1], Buf, dxStringSize(S));
end;

function dxStrToFloat(const S: string; const ADecimalSeparator: Char = '.'): Extended;
var
  AFormatSettings: TFormatSettings;
begin
  FillChar(AFormatSettings, SizeOf(AFormatSettings), 0);
  AFormatSettings.DecimalSeparator := ADecimalSeparator;
  Result := StrToFloat(S, AFormatSettings);
end;

function dxStrToFloatDef(const S: string; const ADecimalSeparator: Char = '.'; ADefaultValue: Extended = 0): Extended;
var
  AFormatSettings: TFormatSettings;
begin
  FillChar(AFormatSettings, SizeOf(AFormatSettings), 0);
  AFormatSettings.DecimalSeparator := ADecimalSeparator;
  Result := StrToFloatDef(S, ADefaultValue, AFormatSettings);
end;

function dxFloatToStr(AValue: Extended; ADecimalSeparator: Char = '.'): string;
var
  AFormatSettings: TFormatSettings;
begin
  FillChar(AFormatSettings, SizeOf(AFormatSettings), 0);
  AFormatSettings.DecimalSeparator := ADecimalSeparator;
  Result := FloatToStr(AValue, AFormatSettings);
end;

function RemoveAccelChars(const S: string; AAppendTerminatingUnderscore: Boolean = True): string;
var
  ALastIndex, I: Integer;
begin
  Result := S;
  ALastIndex := Length(Result);
  for I := 1 to ALastIndex do
    if Result[I] = cHotkeyPrefix then
    begin
      Delete(Result, I, 1);
      if (I < ALastIndex) or not AAppendTerminatingUnderscore then
        Dec(ALastIndex)
      else
        Result := Result + '_';
    end;
end;

function dxUTF8StringToAnsiString(const S: UTF8String): AnsiString;
begin
  Result := dxStringToAnsiString(Utf8ToAnsi(S));
end;

function dxAnsiStringToUTF8String(const S: AnsiString): UTF8String;
begin
  Result := UTF8Encode(dxAnsiStringToString(S));
end;

function dxUTF8StringToString(const S: UTF8String): string;
begin
  Result := UTF8ToUnicodeString(S);
end;

function dxUTF8StringToWideString(const S: UTF8String): WideString;
begin
  Result := UTF8ToWideString(S);
end;

function dxStringToUTF8String(const S: string): UTF8String;
begin
  Result := UTF8Encode(S);
end;

function dxWideStringToUTF8String(const S: WideString): UTF8String;
begin
  Result := UTF8Encode(S);
end;

function dxAnsiStringReplace(const AString, AOldPattern, ANewPattern: AnsiString; AFlags: TReplaceFlags): AnsiString;
begin
  Result := AnsiStrings.StringReplace(AString, AOldPattern, ANewPattern, AFlags);
end;


{ Safe }

class function Safe.Cast(const AObject: TObject; const AClass: TClass; out AValue): Boolean;
begin
  Result := (AObject <> nil) and AObject.InheritsFrom(AClass);
  if Result then
    TObject(AValue) := AObject
  else
    TObject(AValue) := nil;
end;

{ Safe<T> }

class function Safe<T>.Cast(AObject: TObject): T;
begin
  if (AObject <> nil) and AObject.InheritsFrom(T) then
    Result := T(AObject)
  else
    Result := nil;
end;

{ TdxUnitsLoader }

constructor TdxUnitsLoader.Create;
begin
  inherited Create;
  FInRegsvr32 := Pos('regsvr32', ParamStr(0).ToLower) >= 1;
  FinalizeList := TdxProcList.Create;
  InitializeList := TdxProcList.Create;
end;

destructor TdxUnitsLoader.Destroy;
begin
  Finalize;
  FreeAndNil(InitializeList);
  FreeAndNil(FinalizeList);
  inherited Destroy;
end;

procedure TdxUnitsLoader.AddUnit(AhInstance: HMODULE; const AUnitName: string; const AInitializeProc, AFinalizeProc: TdxProc);
var
  AProc: TdxProc;
  ARec: TdxProcRec;
{$IFDEF DX_INITIALIZATION_LOGGING}
  AWatch: TStopwatch;
  AElapsedMs: Int64;
{$ENDIF}
begin
  if FInRegsvr32 then
    Exit;
  if Assigned(AInitializeProc) then
  begin
    AProc := AInitializeProc;
    if not dxIsDLL then
    begin
      IsInitialized := True;
      {$IFDEF DX_INITIALIZATION_LOGGING}
      if not TdxUnitSectionsLogger.UseTimingsThreshold then
        TdxUnitSectionsLogger.Log(AUnitName + ': initialize*', AhInstance);
      AWatch := TStopwatch.StartNew;
      {$ENDIF}
      AProc;
      {$IFDEF DX_INITIALIZATION_LOGGING}
      AElapsedMs := AWatch.ElapsedMilliseconds;
      if AElapsedMs >= TdxUnitSectionsLogger.ThresholdInMs then
        TdxUnitSectionsLogger.Log(AUnitName + ': initialized* - ' + IntToStr(AElapsedMs) + ' ms', AhInstance)
      else if not TdxUnitSectionsLogger.UseTimingsThreshold then
        TdxUnitSectionsLogger.Log(AUnitName + ': initialized*', AhInstance);
      {$ENDIF}
    end
    else
    begin
      ARec.UnitName := AUnitName;
      ARec.Proc := AInitializeProc;
      ARec.hInstance := AhInstance;
      InitializeList.Add(ARec);
    end;
  end;
  if Assigned(AFinalizeProc) then
  begin
    ARec.UnitName := AUnitName;
    ARec.Proc := AFinalizeProc;
    ARec.hInstance := AhInstance;
    FinalizeList.Add(ARec);
  end;
end;

procedure TdxUnitsLoader.CallProc(AProc: TdxProc);
begin
  if Assigned(AProc) then AProc;
end;

procedure TdxUnitsLoader.RemoveUnit(AhInstance: HMODULE; const AUnitName: string; const AFinalizeProc: TdxProc);
var
  AProc: TdxProc;
{$IFDEF DX_INITIALIZATION_LOGGING}
  AWatch: TStopwatch;
  AElapsedMs: Int64;
{$ENDIF}
begin
  if FInRegsvr32 then
    Exit;
  AProc := AFinalizeProc;
  if FinalizeList.RemoveProc(AFinalizeProc) <> -1 then
  begin
    if IsInitialized then
    begin
      {$IFDEF DX_INITIALIZATION_LOGGING}
      if not TdxUnitSectionsLogger.UseTimingsThreshold then
        TdxUnitSectionsLogger.Log(AUnitName + ': finalize*', AhInstance);
      AWatch := TStopwatch.StartNew;
      {$ENDIF}
      CallProc(AProc);
      {$IFDEF DX_INITIALIZATION_LOGGING}
      AElapsedMs := AWatch.ElapsedMilliseconds;
      if AElapsedMs >= TdxUnitSectionsLogger.ThresholdInMs then
        TdxUnitSectionsLogger.Log(AUnitName + ': finalized*'  + ' - ' + IntToStr(AElapsedMs) + ' ms', AhInstance)
      else if not TdxUnitSectionsLogger.UseTimingsThreshold then
        TdxUnitSectionsLogger.Log(AUnitName + ': finalized*', AhInstance);
      {$ENDIF}
    end;
  end;
end;

procedure TdxUnitsLoader.Finalize;
var
  I: Integer;
  ARec: TdxProcRec;
{$IFDEF DX_INITIALIZATION_LOGGING}
  AWatch: TStopwatch;
  ATotalWatch: TStopwatch;
  AElapsedMs: Int64;
{$ENDIF}
begin
  if IsInitialized then
  begin
    {$IFDEF DX_INITIALIZATION_LOGGING}
    if not TdxUnitSectionsLogger.UseTimingsThreshold then
      TdxUnitSectionsLogger.Log('Finalize ' + IntToStr(InitializeList.Count) + ' units:');
    ATotalWatch := TStopwatch.StartNew;
    {$ENDIF}
    for I := FinalizeList.Count - 1 downto 0 do
    begin
      ARec := FinalizeList[I];
      {$IFDEF DX_INITIALIZATION_LOGGING}
      if not TdxUnitSectionsLogger.UseTimingsThreshold then
        TdxUnitSectionsLogger.Log('finalize: ' + ARec.UnitName, ARec.hInstance);
      AWatch := TStopwatch.StartNew;
      {$ENDIF}
      CallProc(ARec.Proc);
      {$IFDEF DX_INITIALIZATION_LOGGING}
      AElapsedMs := AWatch.ElapsedMilliseconds;
      if AElapsedMs >= TdxUnitSectionsLogger.ThresholdInMs then
        TdxUnitSectionsLogger.Log('finalized: ' + ARec.UnitName + ' - ' + IntToStr(AElapsedMs) + ' ms', ARec.hInstance)
      else if not TdxUnitSectionsLogger.UseTimingsThreshold then
        TdxUnitSectionsLogger.Log('finalized: ' + ARec.UnitName, ARec.hInstance);
      {$ENDIF}
    end;
    {$IFDEF DX_INITIALIZATION_LOGGING}
    AElapsedMs := ATotalWatch.ElapsedMilliseconds;
    if AElapsedMs >= TdxUnitSectionsLogger.ThresholdInMs then
      TdxUnitSectionsLogger.Log('Finalized ' + IntToStr(InitializeList.Count) + ' units' + ' - ' + IntToStr(AElapsedMs) + ' ms')
    else if not TdxUnitSectionsLogger.UseTimingsThreshold then
      TdxUnitSectionsLogger.Log('Finalized ' + IntToStr(InitializeList.Count) + ' units.');
    {$ENDIF}
  end;
  IsInitialized := False;
  FinalizeList.Clear;
end;

procedure TdxUnitsLoader.Initialize;
var
  I: Integer;
  ARec: TdxProcRec;
{$IFDEF DX_INITIALIZATION_LOGGING}
  AWatch: TStopwatch;
  ATotalWatch: TStopwatch;
  AElapsedMs: Int64;
{$ENDIF}
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}
  if not TdxUnitSectionsLogger.UseTimingsThreshold then
    TdxUnitSectionsLogger.Log('Initialize ' + IntToStr(InitializeList.Count) + ' units:');
  ATotalWatch := TStopwatch.StartNew;
  {$ENDIF}
  for I := 0 to InitializeList.Count - 1 do
  begin
    ARec := InitializeList[I];
    {$IFDEF DX_INITIALIZATION_LOGGING}
    if not TdxUnitSectionsLogger.UseTimingsThreshold then
      TdxUnitSectionsLogger.Log('initialize: ' + ARec.UnitName, ARec.hInstance);
    AWatch := TStopwatch.StartNew;
    {$ENDIF}
    CallProc(ARec.Proc);
    {$IFDEF DX_INITIALIZATION_LOGGING}
    AElapsedMs := AWatch.ElapsedMilliseconds;
    if AElapsedMs >= TdxUnitSectionsLogger.ThresholdInMs then
      TdxUnitSectionsLogger.Log('initialized: ' + ARec.UnitName + ' - ' + IntToStr(AElapsedMs) + ' ms', ARec.hInstance)
    else if not TdxUnitSectionsLogger.UseTimingsThreshold then
      TdxUnitSectionsLogger.Log('initialized: ' + ARec.UnitName, ARec.hInstance);
    {$ENDIF}
  end;
  {$IFDEF DX_INITIALIZATION_LOGGING}
  AElapsedMs := ATotalWatch.ElapsedMilliseconds;
  if AElapsedMs >= TdxUnitSectionsLogger.ThresholdInMs then
    TdxUnitSectionsLogger.Log('Initialized ' + IntToStr(InitializeList.Count) + ' units' + ' - ' + IntToStr(AElapsedMs) + ' ms')
  else if not TdxUnitSectionsLogger.UseTimingsThreshold then
    TdxUnitSectionsLogger.Log('Initialized ' + IntToStr(InitializeList.Count) + ' units.');
  {$ENDIF}
  InitializeList.Clear;
  IsInitialized := True;
end;

function dxGarbage: TList;
begin
  if FGlobalObjectDestroyer = nil then
    FGlobalObjectDestroyer := TdxGlobalObjectDestroyer.Create(Application);
  Result := FGlobalObjectDestroyer.Objects;
end;

procedure dxFreeGlobalObject(var AObject);
begin
  if TObject(AObject) <> nil then
    if ModuleIsLib or (Application = nil) or (csDestroying in Application.ComponentState) then
      FreeAndNil(TObject(AObject))
    else
      dxGarbage.Add(TObject(AObject));
end;

function dxUnitsLoader: TdxUnitsLoader;
begin
  if UnitsLoader = nil then
    UnitsLoader := TdxUnitsLoader.Create;
  Result := UnitsLoader;
end;


procedure dxInitialize;
begin
  dxUnitsLoader.Initialize;
end;

procedure dxFinalize;
begin
  dxUnitsLoader.Finalize;
end;

{$IFDEF DX_INITIALIZATION_LOGGING}

{ TdxUnitSectionsLogger }

class procedure TdxUnitSectionsLogger.ConstructorFinished(const AUnitName,
  AClassOrRecordNameDotMethodName: string; AhInstance: HMODULE);
var
  AElapsedMs: Int64;
begin
  AElapsedMs := FWatch.ElapsedMilliseconds;
  if AElapsedMs >= ThresholdInMs then
    InternalLog(AUnitName + ': class constructor ' + AClassOrRecordNameDotMethodName + ' (leave) - ' + IntToStr(AElapsedMs) + ' ms', AhInstance)
  else if not UseTimingsThreshold then
    InternalLog(AUnitName + ': class constructor ' + AClassOrRecordNameDotMethodName + ' (leave)', AhInstance);
end;

class procedure TdxUnitSectionsLogger.ConstructorStarted(const AUnitName,
  AClassOrRecordNameDotMethodName: string; AhInstance: HMODULE);
begin
  if not UseTimingsThreshold then
    InternalLog(AUnitName + ': class constructor ' + AClassOrRecordNameDotMethodName + ' (enter)', AhInstance);
  FWatch := TStopwatch.StartNew;
end;

class constructor TdxUnitSectionsLogger.Create;
begin
  FFileName := ChangeFileExt(ParamStr(0), FileExtention);
end;

class procedure TdxUnitSectionsLogger.DestructorFinished(const AUnitName,
  AClassOrRecordNameDotMethodName: string; AhInstance: HMODULE);
var
  AElapsedMs: Int64;
begin
  AElapsedMs := FWatch.ElapsedMilliseconds;
  if AElapsedMs >= ThresholdInMs then
    InternalLog(AUnitName + ': class destructor ' + AClassOrRecordNameDotMethodName + ' (leave) - ' + IntToStr(AElapsedMs) + ' ms', AhInstance)
  else if not UseTimingsThreshold then
    InternalLog(AUnitName + ': class destructor ' + AClassOrRecordNameDotMethodName + ' (leave)', AhInstance);
end;

class procedure TdxUnitSectionsLogger.DestructorStarted(const AUnitName,
  AClassOrRecordNameDotMethodName: string; AhInstance: HMODULE);
begin
  if not UseTimingsThreshold then
    InternalLog(AUnitName + ': class destructor ' + AClassOrRecordNameDotMethodName + ' (enter)', AhInstance);
  FWatch := TStopwatch.StartNew;
end;

class procedure TdxUnitSectionsLogger.FinalizationFinished(const AUnitName: string; AhInstance: HMODULE);
var
  AElapsedMs: Int64;
begin
  AElapsedMs := FWatch.ElapsedMilliseconds;
  if AElapsedMs >= ThresholdInMs then
    InternalLog(AUnitName + ': Finalization finished - ' + IntToStr(AElapsedMs) + ' ms', AhInstance)
  else if not UseTimingsThreshold then
    InternalLog(AUnitName + ': Finalization finished', AhInstance);
end;

class procedure TdxUnitSectionsLogger.FinalizationStarted(const AUnitName: string; AhInstance: HMODULE);
begin
  if not UseTimingsThreshold then
    InternalLog(AUnitName + ': Finalization started', AhInstance);
  FWatch := TStopwatch.StartNew;
end;

class procedure TdxUnitSectionsLogger.InitializationFinished(const AUnitName: string; AhInstance: HMODULE);
var
  AElapsedMs: Int64;
begin
  AElapsedMs := FWatch.ElapsedMilliseconds;
  if AElapsedMs >= ThresholdInMs then
    InternalLog(AUnitName + ': Initialization finished - ' + IntToStr(AElapsedMs) + ' ms', AhInstance)
  else if not UseTimingsThreshold then
    InternalLog(AUnitName + ': Initialization finished', AhInstance);
end;

class procedure TdxUnitSectionsLogger.InitializationStarted(const AUnitName: string; AhInstance: HMODULE);
begin
  if not UseTimingsThreshold then
    InternalLog(AUnitName + ': Initialization started', AhInstance);
  FWatch := TStopwatch.StartNew;
end;

class procedure TdxUnitSectionsLogger.InternalLog(const AData: string);
const
  INVALID_SET_FILE_POINTER: DWORD = $FFFFFFFF;
var
  AHandle: THandle;
  AWritten: DWORD;
  AAnsiData: AnsiString;
begin
  OutputDebugString(PChar(AData));
  AHandle := CreateFile(PChar(FFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if AHandle <> INVALID_HANDLE_VALUE then
  begin
    AAnsiData := AnsiString(AData) + dxCRLF;
    if SetFilePointer(AHandle, 0, nil, FILE_END) <> INVALID_SET_FILE_POINTER then
      WriteFile(AHandle, Pointer(AAnsiData)^, Length(AAnsiData), AWritten, nil);
    FileClose(AHandle);
  end;
end;

class procedure TdxUnitSectionsLogger.InternalLog(const AData: string; AhInstance: HMODULE);
var
  ALibName: string;
begin
  ALibName := SysUtils.GetModuleName(AhInstance);
  if ALibName <> '' then
    InternalLog(ExtractFileName(ALibName) + ' - ' + AData)
  else
    InternalLog(AData);
end;

class procedure TdxUnitSectionsLogger.Log(const AData: string);
begin
  InternalLog(AData);
end;

class procedure TdxUnitSectionsLogger.Log(const AData: string; AhInstance: HMODULE);
begin
  InternalLog(AData, AhInstance);
end;

class procedure TdxUnitSectionsLogger.StartLogging;
var
  AHandle: THandle;
begin
  AHandle := CreateFile(PChar(FFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if AHandle <> INVALID_HANDLE_VALUE then
    FileClose(AHandle);
end;

{$ENDIF}

{ TdxProcList }

function TdxProcList.RemoveProc(AProc: TdxProc): Integer;
var
  I: Integer;
begin
  if Assigned(AProc) then
  begin
    for I := 0 to Count - 1 do
      if @Items[I].Proc = @AProc then
      begin
        Result := I;
        Delete(I);
        Exit;
      end;
  end;
  Result := -1;
end;

{$IFDEF DX_PATCH_TFONT_D12}
type
  TFontPatcher = class
  strict private type
    TFontAccess = class(TFont);

    TXRedirCode = packed record
      Jump: Byte;
      Offset: Integer;
    end;

    TRedirectCode = packed record
      RealProc: Pointer;
      Count: Integer;
      case Byte of
        0: (Code: TXRedirCode);
        1: (Code2: Int64);
    end;

    {$IFDEF CPUX64}
    PAbsoluteIndirectJmp64 = ^TAbsoluteIndirectJmp64;
    TAbsoluteIndirectJmp64 = packed record
      OpCode: Word;   //$FF25(Jmp, FF /4)
      Rel: Integer;
    end;
    {$ELSE}
    PAbsoluteIndirectJmp32 = ^TAbsoluteIndirectJmp32;
    TAbsoluteIndirectJmp32 = packed record
      OpCode: Word;   //$FF25(Jmp, FF /4)
      Addr: ^Pointer;
    end;
    {$ENDIF CPUX64}
    class function GetActualAddr(Proc: Pointer): Pointer; static;
    class procedure CodeRedirect(Proc: Pointer; NewProc: Pointer; out Data: TRedirectCode); static;
    class procedure TFont_SetSize(ASelf: TFont; const AValue: Integer); static;
    class procedure TFont_ChangeScale1(ASelf: TFont; M, D: Integer; isDpiChange: Boolean); static;
    class procedure TFont_ChangeScale2(ASelf: TFont; AHeight: Integer; M, D: Integer; isDpiChange: Boolean); static;
  public
    class procedure RedirectTFontSetSize; static;
    class procedure RedirectTFontChangeScale1; static;
    class procedure RedirectTFontChangeScale2; static;
  end;

class function TFontPatcher.GetActualAddr(Proc: Pointer): Pointer;
begin
  Result := Proc;
  if Result <> nil then
  begin
    {$IFDEF CPUX64}
    if (PAbsoluteIndirectJmp64(Result).OpCode = $25FF) then
      Result := PPointer(PByte(@PAbsoluteIndirectJmp64(Result).OpCode) + SizeOf(TAbsoluteIndirectJmp64) + PAbsoluteIndirectJmp64(Result).Rel)^;
    {$ELSE}
    if (PAbsoluteIndirectJmp32(Result).OpCode = $25FF) then
      Result := PAbsoluteIndirectJmp32(Result).Addr^;
    {$ENDIF CPUX64}
  end;
end;

class procedure TFontPatcher.CodeRedirect(Proc: Pointer; NewProc: Pointer; out Data: TRedirectCode);
var
  OldProtect: Cardinal;
begin
  if Proc = nil then
  begin
    Data.RealProc := nil;
    Exit;
  end;
  if Data.Count = 0 then // do not overwrite an already backuped code
  begin
    Proc := GetActualAddr(Proc);
    if VirtualProtectEx(GetCurrentProcess, Proc, SizeOf(Data.Code) + 1, PAGE_EXECUTE_READWRITE, OldProtect) then
    begin
      Data.RealProc := Proc;
      Data.Code2 := Int64(Proc^);
      TXRedirCode(Proc^).Jump := $E9;
      TXRedirCode(Proc^).Offset := PAnsiChar(NewProc) - PAnsiChar(Proc) - (SizeOf(Data.Code));
      VirtualProtectEx(GetCurrentProcess, Proc, SizeOf(Data.Code) + 1, OldProtect, @OldProtect);
      FlushInstructionCache(GetCurrentProcess, Proc, SizeOf(Data.Code) + 1);
    end;
  end;
  Inc(Data.Count);
end;

class procedure TFontPatcher.TFont_SetSize(ASelf: TFont; const AValue: Integer);
begin
  ASelf.Height := -MulDiv(AValue, ASelf.PixelsPerInch, 72);
end;

class procedure TFontPatcher.TFont_ChangeScale1(ASelf: TFont; M, D: Integer; isDpiChange: Boolean);
begin
  ASelf.Height := MulDiv(ASelf.Height, M, D);
end;

class procedure TFontPatcher.TFont_ChangeScale2(ASelf: TFont; AHeight: Integer; M, D: Integer; isDpiChange: Boolean);
begin
  ASelf.Height := MulDiv(AHeight, M, D);
end;

class procedure TFontPatcher.RedirectTFontSetSize;
var
  LRedir: TRedirectCode;
  AProc: procedure(const Value: Integer) of object;
begin
  LRedir.Count := 0;
  LRedir.RealProc := nil;
  AProc := TFontAccess(nil).SetSize;
  CodeRedirect(TMethod(AProc).Code, @TFont_SetSize, LRedir);
end;

class procedure TFontPatcher.RedirectTFontChangeScale1;
var
  LRedir: TRedirectCode;
  AProc: procedure(M, D: Integer; isDpiChange: Boolean) of object;
begin
  LRedir.Count := 0;
  LRedir.RealProc := nil;
  AProc := TFont(nil).ChangeScale;
  CodeRedirect(TMethod(AProc).Code, @TFont_ChangeScale1, LRedir);
end;

class procedure TFontPatcher.RedirectTFontChangeScale2;
var
  LRedir: TRedirectCode;
  AProc: procedure(AHeight: Integer; M, D: Integer; isDpiChange: Boolean) of object;
begin
  LRedir.Count := 0;
  LRedir.RealProc := nil;
  AProc := TFont(nil).ChangeScale;
  CodeRedirect(TMethod(AProc).Code, @TFont_ChangeScale2, LRedir);
end;

{$ENDIF}

{ TdxDoubleRange }

class function TdxDoubleRange.Create(const AMin, AMax: Double): TdxDoubleRange;
begin
  Result.FMin := AMin;
  Result.FMax := AMax;
end;

class operator TdxDoubleRange.Equal(const L, R: TdxDoubleRange): Boolean;
begin
  Result := SameValue(L.Min, R.Min) and SameValue(L.Max, R.Max);
end;

class operator TdxDoubleRange.NotEqual(const L, R: TdxDoubleRange): Boolean;
begin
  Result := not (L = R);
end;

function TdxDoubleRange.Contains(const AValue: Double): Boolean;
begin
  Result := InRange(AValue, Min, Max);
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.StartLogging;{$ENDIF}
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
{$IFDEF DX_PATCH_TFONT_D12}
  if not ModuleIsPackage then
  begin
    TFontPatcher.RedirectTFontChangeScale1;
    TFontPatcher.RedirectTFontChangeScale2;
    TFontPatcher.RedirectTFontSetSize;
  end;
{$ENDIF}
  dxGarbage; 
{$IFDEF MSWINDOWS}
  InitPlatformInfo;
{$ENDIF}
  dxGetLocaleFormatSettings(dxGetInvariantLocaleID, dxInvariantFormatSettings);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxFreeGlobalObject(FdxResourceStringsRepository);
  DestroyResStringLists;
  if ModuleIsLib then
    FreeAndNil(FGlobalObjectDestroyer);
  if dxIsDLL then
  begin
    if Assigned(UnitsLoader) and (UnitsLoader.FinalizeList.Count > 0) then
      raise Exception.Create('Need call dxFinalize before free library!');
  end;
  FreeAndNil(UnitsLoader);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
