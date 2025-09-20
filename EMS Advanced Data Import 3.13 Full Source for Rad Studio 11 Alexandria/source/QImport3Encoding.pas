unit QImport3Encoding;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    Winapi.Windows,
    System.SysUtils,
    System.Classes,
    System.Math,
    {$IFDEF VER130}
      Vcl.FileCtrl,
    {$ENDIF}
  {$ELSE}
    Windows,
    SysUtils,
    Classes,
    Math,
    {$IFDEF VER130}
      FileCtrl,
    {$ENDIF}
  {$ENDIF}
  QImport3StrTypes,
  QImport3Common;

type
  TQICharsetType = (
    ctWinDefined, ctISO8859_1, ctArmscii8, ctAscii, ctCp850, ctCp852, ctCp866,
    ctCp1250, ctCp1251, ctCp1256, ctCp1257, ctDec8, ctGeostd8, ctISO8859_7,
    ctISO8859_8, ctHp8, ctKeybcs2, ctKoi8r, ctKoi8u, ctISO8859_2, ctISO8859_9,
    ctISO8859_13, ctMacce, ctMacroman, ctSwe7, ctUtf8, ctUtf16BE, ctUtf32, ctUnicode,
    // unique in postrgesql
    ctISO8859_3, ctISO8859_4, ctISO8859_10, ctISO8859_14, ctISO8859_5, ctISO8859_6,
    //unique in db2
    ctCp1026, ctCp1254, ctCp1255, ctCp1258, ctCp437, ctCp500, ctCp737, ctCp855,
    ctCp856, ctCp857, ctCp860, ctCp862, ctCp863, ctCp864, ctCp865, ctCp869,
    ctCp874, ctCp875, ctIceland,
    //unique in IB/FB
    ctBig5, ctKSC5601, ctEUC, ctGB2312, ctSJIS_0208, ctLatin9, ctLatin13, ctISO8859_15,
    ctCp1252, ctCp1253, ctCp775, ctCp858, ctCp932, ctTIS620, ctGBK, ctGB18030);

const
  SystemCTNames: array[TQICharsetType] of Integer =
    (
    // general
      -1,           //ctWinDefined
      28591,        //ctISO8859_1
      -1,           //ctArmscii8
      20127,        //ctAscii
      850,          //ctCp850
      852,          //ctCp852
      866,          //ctCp866
      1250,         //ctCp1250
      1251,         //ctCp1251
      1256,         //ctCp1256
      1257,         //ctCp1257
      -1,           //ctDec8
      -1,           //ctGeostd8
      28597,        //ctISO8859_7
      28598,        //ctISO8859_8
      -1,           //ctHp8
      -1,           //ctKeybcs2
      20866,        //ctKoi8r
      21866,        //ctKoi8u
      28592,        //ctISO8859_2
      28599,        //ctISO8859_9
      28603,        //ctISO8859_13
      10029,        //ctMacce
      10010,        //ctMacroman
      20107,        //ctSwe7
      CP_UTF8,      //ctUtf8
      1201,         //ctUtf16BE
      12000,        //ctUtf32
      1200,         //ctUnicode
    // + postrgesql
      28593,        //ctISO8859_3
      28594,        //ctISO8859_4
      -1,           //ctISO8859_10
      -1,           //ctISO8859_14
      28595,        //ctISO8859_5
      28596,        //ctISO8859_6
    // + db2
      1026,         //ctCp1026
      1254,         //ctCp1254
      1255,         //ctCp1255
      1258,         //ctCp1258
      437,          //ctCp437
      500,          //ctCp500
      737,          //ctCp737
      855,          //ctCp855
      856,          //ctCp856
      857,          //ctCp857
      860,          //ctCp860
      862,          //ctCp862
      863,          //ctCp863
      864,          //ctCp864
      865,          //ctCp865
      869,          //ctCp869
      874,          //ctCp874
      875,          //ctCp875
      20871,        //ctIceland
    // + IB/FB
      950,          //ctBig5
      949,          //ctKSC5601
      51932,        //ctEUC
      20936,        //ctGB2312
      20932,        //ctSJIS_0208
      28605,        //ctLatin9
      -1,           //ctLatin13
      28605,        //ctISO8859_15
      1252,         //ctCp1252
      1253,         //ctCp1253
      775,          //ctCp775
      858,          //ctCp858
      932,          //ctCp932
      874,          //ctTIS620
      936,          //ctGBK
      54936         //ctGB18030
    );

  QICharsetTypeNames: array[TQICharsetType] of String =
    (
    // general
      'Windows default',                                                        //ctWinDefined
      'Western European (ISO)',                                                 //ctISO8859_1
      'Armenian (ArmSCII-8)',                                                   //ctArmscii8
      'ascii (ASCII)',                                                          //ctAscii
      'Western European (DOS)',                                                 //ctCp850
      'Central European (DOS)',                                                 //ctCp852
      'Cyrillic (DOS)',                                                         //ctCp866
      'Central European (Windows)',                                             //ctCp1250
      'Cyrillic (Windows)',                                                     //ctCp1251
      'Arabic (Windows)',                                                       //ctCp1256
      'Baltic (Windows)',                                                       //ctCp1257
      'dec8 (DEC West European)',                                               //ctDec8
      'geostd8 (GEOSTD8 Georgian)',                                             //ctGeostd8
      'Greek (ISO)',                                                            //ctISO8859_7
      'Hebrew (ISO)',                                                           //ctISO8859_8
      'hp8 (HP West European)',                                                 //ctHp8
      'keybcs2 (DOS Kamenicky Czech-Slova)',                                    //ctKeybcs2
      'Cyrillic (KOI8-R)',                                                      //ctKoi8r
      'Cyrillic (KOI8-U)',                                                      //ctKoi8u
      'Central European (ISO)',                                                 //ctISO8859_2
      'Turkish (ISO)',                                                          //ctISO8859_9
      'Latin 7 (ISO 8859-13)',                                                  //ctISO8859_13
      'Central European (Mac)',                                                 //ctMacce
      'Western European (Mac)',                                                 //ctMacroman
      'Swedish (IA5)',                                                          //ctSwe7
      'Unicode (UTF-8)',                                                        //ctUtf8
      'Unicode (Big Endian)',                                                   //ctUtf16BE
      'Unicode (UTF-32)',                                                       //ctUtf32
      'Unicode',                                                                //ctUnicode
    // + postrgesql
      'Latin 3 (ISO 8859-3)',                                                   //ctISO8859_3
      'Baltic (ISO)',                                                           //ctISO8859_4
      'Latin 6 (ISO 8859-10)',                                                  //ctISO8859_10   no system encoder
      'Latin 8 (ISO 8859-14)',                                                  //ctISO8859_14   no system encoder
      'Cyrillic (ISO)',                                                         //ctISO8859_5
      'Arabic (ISO)',                                                           //ctISO8859_6
    // + db2
      'IBM EBCDIC Turkish Latin-5',                                             //ctCp1026
      'Turkish (Windows)',                                                      //ctCp1254
      'Hebrew (Windows)',                                                       //ctCp1255
      'Vietnamese (Windows)',                                                   //ctCp1258
      'OEM United States',                                                      //ctCp437
      'IBM EBCDIC International',                                               //ctCp500
      'Greek (DOS)',                                                            //ctCp737
      'OEM Cyrillic',                                                           //ctCp855
      'Hebrew (DOS 856)',                                                       //ctCp856        no system encoder
      'Turkish (DOS)',                                                          //ctCp857
      'Portuguese (DOS)',                                                       //ctCp860
      'Hebrew (DOS 862)',                                                       //ctCp862
      'French Canadian (DOS)',                                                  //ctCp863
      'Arabic (864)',                                                           //ctCp864
      'Nordic (DOS)',                                                           //ctCp865
      'Greek, Modern (DOS)',                                                    //ctCp869
      'Thai (Windows)',                                                         //ctCp874
      'IBM EBCDIC Greek',                                                       //ctCp875
      'IBM EBCDIC Icelandic',                                                   //ctIceland
    // + IB/FB
      'Chinese Traditional (Big5)',                                             //ctBig5
      'Korean (Unified Hangul)',                                                //ctKSC5601
      'Japanese (EUC)',                                                         //ctEUC
      'Chinese Simplified (GB2312-80)',                                         //ctGB2312
      'Japanese (JIS 0208-1990 and 0212-1990)',                                 //ctSJIS_0208    rename to ctJIS_0208
      'iso8859-9 (Turkish)',                                                    //ctLatin9       duplicates ISO 8859-9
      'iso8859-4 (Baltic)',                                                     //ctLatin13      duplicates ISO 8859-4
      'Latin 9 (ISO 8859-15)',                                                  //ctISO8859_15
      'Western European (Windows)',                                             //ctCp1252
      'Greek (Windows)',                                                        //ctCp1253
      'Baltic (DOS)',                                                           //ctCp775
      'OEM Multilingual Latin 1',                                               //ctCp858
      'Japanese (Shift-JIS)',                                                   //ctCp932
      'Thai (TIS-620)',                                                         //ctTIS620       same encoder as ctCp874
      'Chinese Simplified (GB2312)',                                            //ctGBK
      'Chinese Simplified (GB18030)'                                            //ctGB18030
    );

type
  PBytes = ^TBytes;
{$IFNDEF VCL11}
  TBytes = array of Byte;
{$ENDIF}

  TQIEncoding = class
  protected
    FIsSingleByte: Boolean;
    FMaxCharSize: Integer;
    function GetByteCount(Chars: PWideChar; CharCount: Integer): Integer; overload; virtual; abstract;
    function GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer; overload; virtual; abstract;
    function GetCharCount(Bytes: PByte; ByteCount: Integer): Integer; overload; virtual; abstract;
    function GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer; overload; virtual; abstract;
  public
    class function GetBOM: TBytes; virtual;
    class function GetEncoding(CodePage: Integer): TQIEncoding; overload;
    class function GetEncoding(const Charset: TQICharsetType): TQIEncoding; overload;
    function GetBytes(const S: WideString): TBytes; overload;
    function GetString(const Bytes: TBytes; ByteIndex, ByteCount: Integer): WideString;
    function GetRightTrimSize(Buffer: PByte; BufferLen: Integer): Integer; virtual;
    property IsSingleByte: Boolean read FIsSingleByte;
    property MaxCharSize: Integer read FMaxCharSize;
  end;

  TQIMBCSEncoding = class(TQIEncoding)
  private
    FCodePage: Cardinal;
    FMBToWCharFlags: Cardinal;
    FWCharToMBFlags: Cardinal;
  protected
    function GetByteCount(Chars: PWideChar; CharCount: Integer): Integer; overload; override;
    function GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetCharCount(Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer; overload; override;
  public
    constructor Create; overload;
    constructor Create(CodePage: Integer); overload;
    constructor Create(CodePage, MBToWCharFlags, WCharToMBFlags: Integer); overload;
    function GetRightTrimSize(Buffer: PByte; BufferLen: Integer): Integer; override;
  end;

  TQIUTF8Encoding = class(TQIMBCSEncoding)
  public
    class function GetBOM: TBytes; override;
    function GetRightTrimSize(Buffer: PByte; BufferLen: Integer): Integer; override;
    constructor Create;
  end;

  PArrCharOfWideChar = ^TArrCharOfWideChar;
  TArrCharOfWideChar = array[Byte] of WideChar;

  TQITableEncoding = class(TQIEncoding)
  private
    FCharset: TQICharsetType;
  protected
    function GetByteCount(Chars: PWideChar; CharCount: Integer): Integer; overload; override;
    function GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetCharCount(Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer; overload; override;
  public
    constructor Create(const Charset: TQICharsetType);
  end;

  TQIUnicodeEncoding = class(TQIEncoding)
  protected
    function GetByteCount(Chars: PWideChar; CharCount: Integer): Integer; overload; override;
    function GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetCharCount(Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer; overload; override;
  public
    constructor Create;
    class function GetBOM: TBytes; override;
  end;

  TQIBigEndianUnicodeEncoding = class(TQIUnicodeEncoding)
  protected
    function GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer; overload; override;
  public
    class function GetBOM: TBytes; override;
  end;

  TQIUTF32Encoding = class(TQIEncoding)
  protected
    function GetByteCount(Chars: PWideChar; CharCount: Integer): Integer; overload; override;
    function GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetCharCount(Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer; overload; override;
  public
    constructor Create;
    class function GetBOM: TBytes; override;
  end;

  TQIBigEndianUTF32Encoding = class(TQIUTF32Encoding)
  protected
    function GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer; overload; override;
    function GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer; overload; override;
  public
    class function GetBOM: TBytes; override;
  end;

  EQIConversionError = class(Exception);

  EQICharsetEncodingError = class(EQIConversionError)
  public
    constructor Create(const Msg: string);
  end;

  TQICharsetAutoDetector = class
  private
    FBOMDetected: Boolean;
    function IsUTF8(Stream: TStream): Boolean;
    function IsContainBOM(const Buffer, BOM: TBytes): Boolean;
  protected
  public
    constructor Create;
    function Detect(Stream: TStream; var Charset: TQICharsetType; BOMOnly: Boolean = False): Boolean;
    function DetectBOM(Stream: TStream; var Charset: TQICharsetType): Boolean;
    property BOMDetected: Boolean read FBOMDetected;
  end;

  TQICharType = (
    xctUnknown,
    xctChar,
    xctLower,
    xctGreater,
    xctLF,
    xctCR,
    xctSglQuote,
    xctDblQuote,
    xctAmpersand,
    xctSqBracketLeft,
    xctSqBracketRight,
    xctQuery,
    xctSlash,
    xctXclam,
    xctParensLeft,
    xctParensRight,
    xctDot,
    xctColon,
    xctComma,
    xctAt,
    xctAsterisk,
    xctPlus,
    xctMinus,
    xctEqual
  );

  TQICharacter = class
  public
    class function GetCharType(const C: WideChar): TQICharType;
    class function IsBlankChar(const C: WideChar): Boolean;
    class function IsDecChar(const C: WideChar): Boolean;
    class function IsHexChar(const C: WideChar): Boolean;
    class function IsNumChar(const C: WideChar): Boolean;
    class function IsFirstIdentChar(const C: WideChar): Boolean;
    class function IsIdentChar(const C: WideChar): Boolean;
  end;

  TQIIterator = class
  private
    FPrevious: WideChar;
    FUndo: Boolean;
    function GetCurrent: WideChar;
    function GetCurrentType: TQICharType;
  protected
    FBuffLen: Integer;
    FIndex: Integer;
    function DoGetCurrent: WideChar; virtual; abstract;
    function DoMoveNext: Boolean; virtual;
    function GetEOF: Boolean; virtual;
    procedure Reset;
  public
    constructor Create;
    function MoveNext: Boolean;
    function ReadString(Count: Integer; out Buffer: WideString): LongInt; overload; virtual;
    function Rollback: Boolean;
    procedure SkipBlanks;
    property Current: WideChar read GetCurrent;
    property CurrentType: TQICharType read GetCurrentType;
    property EOF: Boolean read GetEOF;
  end;

  TQIBufferIterator = class(TQIIterator)
  private
    FBuffer: PWideChar;
    procedure SetCount(const Value: Integer);
  protected
    function DoGetCurrent: WideChar; override;
    function DoMoveNext: Boolean; override;
  public
    constructor Create;
    property Buffer: PWideChar read FBuffer write FBuffer;
    property Count: Integer read FBuffLen write SetCount;
  end;

  TEncodedReadStream = class;

  TQIStreamIterator = class(TQIIterator)
  private
    FBuffer: array of WideChar;
    FUnicodeStream: TEncodedReadStream;
    FInternalUnicodeStream: Boolean;
    procedure FillBuffer;
  protected
    function DoGetCurrent: WideChar; override;
    function DoMoveNext: Boolean; override;
    function GetEOF: Boolean; override;
  public
    constructor Create(Source: TStream); overload;
    constructor Create(Source: TStream; Charset: TQICharsetType); overload;
    constructor Create(Source: TStream; Charset: TQICharsetType; BufferSize: Cardinal); overload;
    constructor Create(const FileName: string); overload;
    constructor Create(const FileName: string; Charset: TQICharsetType); overload;
    constructor Create(const FileName: string; Charset: TQICharsetType; BufferSize: Cardinal); overload;
    constructor Create(UnicodeStream: TEncodedReadStream; BufferSize: Cardinal); overload;
    destructor Destroy; override;
  end;

  TEncodedReadStream = class(TStream)
  private
    FStream: TStream;
    FCharset: TQICharsetType;
    FEncoding: TQIEncoding;
    FReadlnBuf: TMemoryStream;
    FInternalBuffer: TBytes;
    FFromFile: Boolean;
    function InternalRead(InternalBufLen: Integer; BufPtr: PByte): Longint;
  protected
    function GetPosition: {$IFDEF VCL7}Int64;{$ELSE}Longint;{$ENDIF} virtual;
    function GetSize: {$IFDEF VCL7}Int64; override;{$ELSE}Longint; virtual;{$ENDIF}
  public
    constructor Create(Source: TStream); overload;
    constructor Create(Source: TStream; Charset: TQICharsetType); overload;
    constructor Create(const FileName: string); overload;
    constructor Create(const FileName: string; Charset: TQICharsetType); overload;
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    {$IFNDEF VCL17}
    function Write(const Buffer; Count: Longint): Longint; override;
    {$ENDIF}
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    function Readln: WideString;
    function ReadToEnd: WideString;
    function GetEof: Boolean;
    property Charset: TQICharsetType read FCharset;
  end;

function GetWindowsCharset: TQICharsetType;

procedure FillCharsetTypeList(List: TqiStrings);

function QIAliasToCharsetType(const Alias: qiString): TQICharsetType;

function IsUnicodeQICharset(Charset: TQICharsetType): Boolean;
function QICharsetToCodepage(const Value: TQICharsetType): Integer;

function CharsetToWideString(const Buffer; Count: Longint; const Charset: TQICharsetType): WideString;

function DetectCharset(Stream: TStream; DiscoverCharset: Boolean; out Charset: TQICharsetType): Boolean;
procedure SkipBOM(Stream: TStream; Charset: TQICharsetType);

function IsBlankText(const Text: WideString): Boolean;
function IsNumberText(const Text: WideString): Boolean;

function QICodePageToCharset(Value: Integer): TQICharsetType;

implementation

const
  WC_ERR_INVALID_CHARS  = $80;
  MB_ERR_INVALID_CHARS = 8;
  LF = #13#10;
  sFileNameNotDefined = 'File name is not defined';
  sFileNotFound = 'File %s not found';
  ErrorSymbol: WideChar = '?';
  MAX_BUFFER_SIZE = 64 * 1024;
  MAX_DETECT_SIZE = 100 * 1024;

  Cp866Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417, #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F,
      #$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427, #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
      #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437, #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F,
      #$2591, #$2592, #$2593, #$2502, #$2524, #$2561, #$2562, #$2556, #$2555, #$2563, #$2551, #$2557, #$255D, #$255C, #$255B, #$2510,
      #$2514, #$2534, #$252C, #$251C, #$2500, #$253C, #$255E, #$255F, #$255A, #$2554, #$2569, #$2566, #$2560, #$2550, #$256C, #$2567,
      #$2568, #$2564, #$2565, #$2559, #$2558, #$2552, #$2553, #$256B, #$256A, #$2518, #$250C, #$2588, #$2584, #$258C, #$2590, #$2580,
      #$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447, #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F,
      #$0401, #$0451, #$0404, #$0454, #$0407, #$0457, #$040E, #$045E, #$00B0, #$2219, #$00B7, #$221A, #$207F, #$00B2, #$25A0, #$00A0
    );

  Cp1251Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0402, #$0403, #$201A, #$0453, #$201E, #$2026, #$2020, #$2021, #$0000, #$2030, #$0409, #$2039, #$040A, #$040C, #$040B, #$040F,
      #$0452, #$2018, #$2019, #$201C, #$201D, #$2022, #$2013, #$2014, #$0000, #$2122, #$0459, #$203A, #$045A, #$045C, #$045B, #$045F,
      #$00A0, #$040E, #$045E, #$0408, #$00A4, #$0490, #$00A6, #$00A7, #$0401, #$00A9, #$0404, #$00AB, #$00AC, #$00AD, #$00AE, #$0407,
      #$00B0, #$00B1, #$0406, #$0456, #$0491, #$00B5, #$00B6, #$00B7, #$0451, #$2116, #$0454, #$00BB, #$0458, #$0405, #$0455, #$0457,
      #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417, #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F,
      #$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427, #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
      #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437, #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F,
      #$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447, #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F
   );

  Koi8uUni: TArrCharOfWideChar =
   (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$2500, #$2502, #$250C, #$2510, #$2514, #$2518, #$251C, #$2524, #$252C, #$2534, #$253C, #$2580, #$2584, #$2588, #$258C, #$2590,
      #$2591, #$2592, #$2593, #$2320, #$25A0, #$2022, #$221A, #$2248, #$2264, #$2265, #$00A0, #$2321, #$00B0, #$00B2, #$00B7, #$00F7,
      #$2550, #$2551, #$2552, #$0451, #$0454, #$2554, #$0456, #$0457, #$2557, #$2558, #$2559, #$255A, #$255B, #$0491, #$255D, #$255E,
      #$255F, #$2560, #$2561, #$0401, #$0404, #$2563, #$0406, #$0407, #$2566, #$2567, #$2568, #$2569, #$256A, #$0490, #$256C, #$00A9,
      #$044E, #$0430, #$0431, #$0446, #$0434, #$0435, #$0444, #$0433, #$0445, #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E,
      #$043F, #$044F, #$0440, #$0441, #$0442, #$0443, #$0436, #$0432, #$044C, #$044B, #$0437, #$0448, #$044D, #$0449, #$0447, #$044A,
      #$042E, #$0410, #$0411, #$0426, #$0414, #$0415, #$0424, #$0413, #$0425, #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E,
      #$041F, #$042F, #$0420, #$0421, #$0422, #$0423, #$0416, #$0412, #$042C, #$042B, #$0417, #$0428, #$042D, #$0429, #$0427, #$042A
   );

  Koi8rUni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000a, #$000b, #$000c, #$000d, #$000e, #$000f,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001a, #$001b, #$001c, #$001d, #$001e, #$001f,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002a, #$002b, #$002c, #$002d, #$002e, #$002f,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003a, #$003b, #$003c, #$003d, #$003e, #$003f,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004a, #$004b, #$004c, #$004d, #$004e, #$004f,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005a, #$005b, #$005c, #$005d, #$005e, #$005f,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006a, #$006b, #$006c, #$006d, #$006e, #$006f,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007a, #$007b, #$007c, #$007d, #$007e, #$007f,
      #$2500, #$2502, #$250c, #$2510, #$2514, #$2518, #$251c, #$2524, #$252c, #$2534, #$253c, #$2580, #$2584, #$2588, #$258c, #$2590,
      #$2591, #$2592, #$2593, #$2320, #$25a0, #$2219, #$221a, #$2248, #$2264, #$2265, #$00a0, #$2321, #$00b0, #$00b2, #$00b7, #$00f7,
      #$2550, #$2551, #$2552, #$0451, #$2553, #$2554, #$2555, #$2556, #$2557, #$2558, #$2559, #$255a, #$255b, #$255c, #$255d, #$255e,
      #$255f, #$2560, #$2561, #$0401, #$2562, #$2563, #$2564, #$2565, #$2566, #$2567, #$2568, #$2569, #$256a, #$256b, #$256c, #$00a9,
      #$044e, #$0430, #$0431, #$0446, #$0434, #$0435, #$0444, #$0433, #$0445, #$0438, #$0439, #$043a, #$043b, #$043c, #$043d, #$043e,
      #$043f, #$044f, #$0440, #$0441, #$0442, #$0443, #$0436, #$0432, #$044c, #$044b, #$0437, #$0448, #$044d, #$0449, #$0447, #$044a,
      #$042e, #$0410, #$0411, #$0426, #$0414, #$0415, #$0424, #$0413, #$0425, #$0418, #$0419, #$041a, #$041b, #$041c, #$041d, #$041e,
      #$041f, #$042f, #$0420, #$0421, #$0422, #$0423, #$0416, #$0412, #$042c, #$042b, #$0417, #$0428, #$042d, #$0429, #$0427, #$042a
    );

  Armscii8Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$2741, #$00A7, #$0589, #$0029, #$0028, #$00BB, #$00AB, #$2014, #$002E, #$055D, #$002C, #$002D, #$055F, #$2026, #$055C,
      #$055B, #$055E, #$0531, #$0561, #$0532, #$0562, #$0533, #$0563, #$0534, #$0564, #$0535, #$0565, #$0536, #$0566, #$0537, #$0567,
      #$0538, #$0568, #$0539, #$0569, #$053A, #$056A, #$053B, #$056B, #$053C, #$056C, #$053D, #$056D, #$053E, #$056E, #$053F, #$056F,
      #$0540, #$0570, #$0541, #$0571, #$0542, #$0572, #$0543, #$0573, #$0544, #$0574, #$0545, #$0575, #$0546, #$0576, #$0547, #$0577,
      #$0548, #$0578, #$0549, #$0579, #$054A, #$057A, #$054B, #$057B, #$054C, #$057C, #$054D, #$057D, #$054E, #$057E, #$054F, #$057F,
      #$0550, #$0580, #$0551, #$0581, #$0552, #$0582, #$0553, #$0583, #$0554, #$0584, #$0555, #$0585, #$0556, #$0586, #$2019, #$0027
    );

  AsciiUni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000
    );

  Cp850Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000a, #$000b, #$000c, #$000d, #$000e, #$000f,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001a, #$001b, #$001c, #$001d, #$001e, #$001f,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002a, #$002b, #$002c, #$002d, #$002e, #$002f,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003a, #$003b, #$003c, #$003d, #$003e, #$003f,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004a, #$004b, #$004c, #$004d, #$004e, #$004f,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005a, #$005b, #$005c, #$005d, #$005e, #$005f,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006a, #$006b, #$006c, #$006d, #$006e, #$006f,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007a, #$007b, #$007c, #$007d, #$007e, #$007f,
      #$00c7, #$00fc, #$00e9, #$00e2, #$00e4, #$00e0, #$00e5, #$00e7, #$00ea, #$00eb, #$00e8, #$00ef, #$00ee, #$00ec, #$00c4, #$00c5,
      #$00c9, #$00e6, #$00c6, #$00f4, #$00f6, #$00f2, #$00fb, #$00f9, #$00ff, #$00d6, #$00dc, #$00f8, #$00a3, #$00d8, #$00d7, #$0192,
      #$00e1, #$00ed, #$00f3, #$00fa, #$00f1, #$00d1, #$00aa, #$00ba, #$00bf, #$00ae, #$00ac, #$00bd, #$00bc, #$00a1, #$00ab, #$00bb,
      #$2591, #$2592, #$2593, #$2502, #$2524, #$00c1, #$00c2, #$00c0, #$00a9, #$2563, #$2551, #$2557, #$255d, #$00a2, #$00a5, #$2510,
      #$2514, #$2534, #$252c, #$251c, #$2500, #$253c, #$00e3, #$00c3, #$255a, #$2554, #$2569, #$2566, #$2560, #$2550, #$256c, #$00a4,
      #$00f0, #$00d0, #$00ca, #$00cb, #$00c8, #$0131, #$00cd, #$00ce, #$00cf, #$2518, #$250c, #$2588, #$2584, #$00a6, #$00cc, #$2580,
      #$00d3, #$00df, #$00d4, #$00d2, #$00f5, #$00d5, #$00b5, #$00fe, #$00de, #$00da, #$00db, #$00d9, #$00fd, #$00dd, #$00af, #$00b4,
      #$00ad, #$00b1, #$2017, #$00be, #$00b6, #$00a7, #$00f7, #$00b8, #$00b0, #$00a8, #$00b7, #$00b9, #$00b3, #$00b2, #$25a0, #$00a0
    );

  Cp852Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$00C7, #$00FC, #$00E9, #$00E2, #$00E4, #$016F, #$0107, #$00E7, #$0142, #$00EB, #$0150, #$0151, #$00EE, #$0179, #$00C4, #$0106,
      #$00C9, #$0139, #$013A, #$00F4, #$00F6, #$013D, #$013E, #$015A, #$015B, #$00D6, #$00DC, #$0164, #$0165, #$0141, #$00D7, #$010D,
      #$00E1, #$00ED, #$00F3, #$00FA, #$0104, #$0105, #$017D, #$017E, #$0118, #$0119, #$00AC, #$017A, #$010C, #$015F, #$00AB, #$00BB,
      #$2591, #$2592, #$2593, #$2502, #$2524, #$00C1, #$00C2, #$011A, #$015E, #$2563, #$2551, #$2557, #$255D, #$017B, #$017C, #$2510,
      #$2514, #$2534, #$252C, #$251C, #$2500, #$253C, #$0102, #$0103, #$255A, #$2554, #$2569, #$2566, #$2560, #$2550, #$256C, #$00A4,
      #$0111, #$0110, #$010E, #$00CB, #$010F, #$0147, #$00CD, #$00CE, #$011B, #$2518, #$250C, #$2588, #$2584, #$0162, #$016E, #$2580,
      #$00D3, #$00DF, #$00D4, #$0143, #$0144, #$0148, #$0160, #$0161, #$0154, #$00DA, #$0155, #$0170, #$00FD, #$00DD, #$0163, #$00B4,
      #$00AD, #$02DD, #$02DB, #$02C7, #$02D8, #$00A7, #$00F7, #$00B8, #$00B0, #$00A8, #$02D9, #$0171, #$0158, #$0159, #$25A0, #$00A0
    );

  Cp1250Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$20AC, #$0000, #$201A, #$0000, #$201E, #$2026, #$2020, #$2021, #$0000, #$2030, #$0160, #$2039, #$015A, #$0164, #$017D, #$0179,
      #$0000, #$2018, #$2019, #$201C, #$201D, #$2022, #$2013, #$2014, #$0000, #$2122, #$0161, #$203A, #$015B, #$0165, #$017E, #$017A,
      #$00A0, #$02C7, #$02D8, #$0141, #$00A4, #$0104, #$00A6, #$00A7, #$00A8, #$00A9, #$015E, #$00AB, #$00AC, #$00AD, #$00AE, #$017B,
      #$00B0, #$00B1, #$02DB, #$0142, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$0105, #$015F, #$00BB, #$013D, #$02DD, #$013E, #$017C,
      #$0154, #$00C1, #$00C2, #$0102, #$00C4, #$0139, #$0106, #$00C7, #$010C, #$00C9, #$0118, #$00CB, #$011A, #$00CD, #$00CE, #$010E,
      #$0110, #$0143, #$0147, #$00D3, #$00D4, #$0150, #$00D6, #$00D7, #$0158, #$016E, #$00DA, #$0170, #$00DC, #$00DD, #$0162, #$00DF,
      #$0155, #$00E1, #$00E2, #$0103, #$00E4, #$013A, #$0107, #$00E7, #$010D, #$00E9, #$0119, #$00EB, #$011B, #$00ED, #$00EE, #$010F,
      #$0111, #$0144, #$0148, #$00F3, #$00F4, #$0151, #$00F6, #$00F7, #$0159, #$016F, #$00FA, #$0171, #$00FC, #$00FD, #$0163, #$02D9
    );

  Cp1256Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$20AC, #$067E, #$201A, #$0192, #$201E, #$2026, #$2020, #$2021, #$02C6, #$2030, #$0000, #$2039, #$0152, #$0686, #$0698, #$0000,
      #$06AF, #$2018, #$2019, #$201C, #$201D, #$2022, #$2013, #$2014, #$0000, #$2122, #$0000, #$203A, #$0153, #$200C, #$200D, #$0000,
      #$00A0, #$060C, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7, #$00A8, #$00A9, #$0000, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
      #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$00B9, #$061B, #$00BB, #$00BC, #$00BD, #$00BE, #$061F,
      #$0000, #$0621, #$0622, #$0623, #$0624, #$0625, #$0626, #$0627, #$0628, #$0629, #$062A, #$062B, #$062C, #$062D, #$062E, #$062F,
      #$0630, #$0631, #$0632, #$0633, #$0634, #$0635, #$0636, #$00D7, #$0637, #$0638, #$0639, #$063A, #$0640, #$0641, #$0642, #$0643,
      #$00E0, #$0644, #$00E2, #$0645, #$0646, #$0647, #$0648, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$0649, #$064A, #$00EE, #$00EF,
      #$064B, #$064C, #$064D, #$064E, #$00F4, #$064F, #$0650, #$00F7, #$0651, #$00F9, #$0652, #$00FB, #$00FC, #$200E, #$200F, #$0000
    );

  Cp1257Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$20AC, #$0000, #$201A, #$0000, #$201E, #$2026, #$2020, #$2021, #$0000, #$2030, #$0000, #$2039, #$0000, #$00A8, #$02C7, #$00B8,
      #$0000, #$2018, #$2019, #$201C, #$201D, #$2022, #$2013, #$2014, #$0000, #$2122, #$0000, #$203A, #$0000, #$00AF, #$02DB, #$0000,
      #$00A0, #$0000, #$00A2, #$00A3, #$00A4, #$0000, #$00A6, #$00A7, #$00D8, #$00A9, #$0156, #$00AB, #$00AC, #$00AD, #$00AE, #$00C6,
      #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00F8, #$00B9, #$0157, #$00BB, #$00BC, #$00BD, #$00BE, #$00E6,
      #$0104, #$012E, #$0100, #$0106, #$00C4, #$00C5, #$0118, #$0112, #$010C, #$00C9, #$0179, #$0116, #$0122, #$0136, #$012A, #$013B,
      #$0160, #$0143, #$0145, #$00D3, #$014C, #$00D5, #$00D6, #$00D7, #$0172, #$0141, #$015A, #$016A, #$00DC, #$017B, #$017D, #$00DF,
      #$0105, #$012F, #$0101, #$0107, #$00E4, #$00E5, #$0119, #$0113, #$010D, #$00E9, #$017A, #$0117, #$0123, #$0137, #$012B, #$013C,
      #$0161, #$0144, #$0146, #$00F3, #$014D, #$00F5, #$00F6, #$00F7, #$0173, #$0142, #$015B, #$016B, #$00FC, #$017C, #$017E, #$02D9
    );

  Dec8Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$00A1, #$00A2, #$00A3, #$0000, #$00A5, #$0000, #$00A7, #$00A4, #$00A9, #$00AA, #$00AB, #$0000, #$0000, #$0000, #$0000,
      #$00B0, #$00B1, #$00B2, #$00B3, #$0000, #$00B5, #$00B6, #$00B7, #$0000, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$0000, #$00BF,
      #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
      #$0000, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$0152, #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$0178, #$0000, #$00DF,
      #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
      #$0000, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$0153, #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FF, #$0000, #$0000
    );

  SimpleUni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7, #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
      #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF,
      #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
      #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7, #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
      #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
      #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00F7, #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00FF
    );

  Geostd8Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$20AC, #$0000, #$201A, #$0000, #$201E, #$2026, #$2020, #$2021, #$0000, #$2030, #$0000, #$2039, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$2018, #$2019, #$201C, #$201D, #$2022, #$2013, #$2014, #$0000, #$0000, #$0000, #$203A, #$0000, #$0000, #$0000, #$0000,
      #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7, #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
      #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF,
      #$10D0, #$10D1, #$10D2, #$10D3, #$10D4, #$10D5, #$10D6, #$10F1, #$10D7, #$10D8, #$10D9, #$10DA, #$10DB, #$10DC, #$10F2, #$10DD,
      #$10DE, #$10DF, #$10E0, #$10E1, #$10E2, #$10F3, #$10E3, #$10E4, #$10E5, #$10E6, #$10E7, #$10E8, #$10E9, #$10EA, #$10EB, #$10EC,
      #$10ED, #$10EE, #$10F4, #$10EF, #$10F0, #$10F5, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$2116, #$0000, #$0000
    );

  ISO8859_7Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$02BD, #$02BC, #$00A3, #$0000, #$0000, #$00A6, #$00A7, #$00A8, #$00A9, #$0000, #$00AB, #$00AC, #$00AD, #$0000, #$2015,
      #$00B0, #$00B1, #$00B2, #$00B3, #$0384, #$0385, #$0386, #$00B7, #$0388, #$0389, #$038A, #$00BB, #$038C, #$00BD, #$038E, #$038F,
      #$0390, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397, #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F,
      #$03A0, #$03A1, #$0000, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7, #$03A8, #$03A9, #$03AA, #$03AB, #$03AC, #$03AD, #$03AE, #$03AF,
      #$03B0, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7, #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF,
      #$03C0, #$03C1, #$03C2, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7, #$03C8, #$03C9, #$03CA, #$03CB, #$03CC, #$03CD, #$03CE, #$0000
    );

  ISO8859_8Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$0000, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7, #$00A8, #$00A9, #$00D7, #$00AB, #$00AC, #$00AD, #$00AE, #$203E,
      #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$00B9, #$00F7, #$00BB, #$00BC, #$00BD, #$00BE, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$2017,
      #$05D0, #$05D1, #$05D2, #$05D3, #$05D4, #$05D5, #$05D6, #$05D7, #$05D8, #$05D9, #$05DA, #$05DB, #$05DC, #$05DD, #$05DE, #$05DF,
      #$05E0, #$05E1, #$05E2, #$05E3, #$05E4, #$05E5, #$05E6, #$05E7, #$05E8, #$05E9, #$05EA, #$0000, #$0000, #$0000, #$0000, #$0000
    );

  Hp8Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$00C0, #$00C2, #$00C8, #$00CA, #$00CB, #$00CE, #$00CF, #$00B4, #$02CB, #$02C6, #$00A8, #$02DC, #$00D9, #$00DB, #$20A4,
      #$00AF, #$00DD, #$00FD, #$00B0, #$00C7, #$00E7, #$00D1, #$00F1, #$00A1, #$00BF, #$00A4, #$00A3, #$00A5, #$00A7, #$0192, #$00A2,
      #$00E2, #$00EA, #$00F4, #$00FB, #$00E1, #$00E9, #$00F3, #$00FA, #$00E0, #$00E8, #$00F2, #$00F9, #$00E4, #$00EB, #$00F6, #$00FC,
      #$00C5, #$00EE, #$00D8, #$00C6, #$00E5, #$00ED, #$00F8, #$00E6, #$00C4, #$00EC, #$00D6, #$00DC, #$00C9, #$00EF, #$00DF, #$00D4,
      #$00C1, #$00C3, #$00E3, #$00D0, #$00F0, #$00CD, #$00CC, #$00D3, #$00D2, #$00D5, #$00F5, #$0160, #$0161, #$00DA, #$0178, #$00FF,
      #$00DE, #$00FE, #$00B7, #$00B5, #$00B6, #$00BE, #$2014, #$00BC, #$00BD, #$00AA, #$00BA, #$00AB, #$25A0, #$00BB, #$00B1, #$0000
    );

  Keybcs2Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$010C, #$00FC, #$00E9, #$010F, #$00E4, #$010E, #$0164, #$010D, #$011B, #$011A, #$0139, #$00CD, #$013E, #$013A, #$00C4, #$00C1,
      #$00C9, #$017E, #$017D, #$00F4, #$00F6, #$00D3, #$016F, #$00DA, #$00FD, #$00D6, #$00DC, #$0160, #$013D, #$00DD, #$0158, #$0165,
      #$00E1, #$00ED, #$00F3, #$00FA, #$0148, #$0147, #$016E, #$00D4, #$0161, #$0159, #$0155, #$0154, #$00BC, #$00A1, #$00AB, #$00BB,
      #$2591, #$2592, #$2593, #$2502, #$2524, #$2561, #$2562, #$2556, #$2555, #$2563, #$2551, #$2557, #$255D, #$255C, #$255B, #$2510,
      #$2514, #$2534, #$252C, #$251C, #$2500, #$253C, #$255E, #$255F, #$255A, #$2554, #$2569, #$2566, #$2560, #$2550, #$256C, #$2567,
      #$2568, #$2564, #$2565, #$2559, #$2558, #$2552, #$2553, #$256B, #$256A, #$2518, #$250C, #$2588, #$2584, #$258C, #$2590, #$2580,
      #$03B1, #$00DF, #$0393, #$03C0, #$03A3, #$03C3, #$00B5, #$03C4, #$03A6, #$0398, #$03A9, #$03B4, #$221E, #$03C6, #$03B5, #$2229,
      #$2261, #$00B1, #$2265, #$2264, #$2320, #$2321, #$00F7, #$2248, #$00B0, #$2219, #$00B7, #$221A, #$207F, #$00B2, #$25A0, #$00A0
    );

  cp1252Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$20AC, #$0081, #$201A, #$0192, #$201E, #$2026, #$2020, #$2021, #$02C6, #$2030, #$0160, #$2039, #$0152, #$008D, #$017D, #$008F,
      #$0090, #$2018, #$2019, #$201C, #$201D, #$2022, #$2013, #$2014, #$02DC, #$2122, #$0161, #$203A, #$0153, #$009D, #$017E, #$0178,
      #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7, #$00A4, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
      #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF,
      #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
      #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D6, #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
      #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
      #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00F6, #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00FF
    );

  cp1253Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$20AC, #$0081, #$201A, #$0192, #$201E, #$2026, #$2020, #$2021, #$0088, #$2030, #$008A, #$2039, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$2018, #$2019, #$201C, #$201D, #$2022, #$2013, #$2014, #$0098, #$2122, #$009A, #$203A, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$0385, #$0386, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7, #$00A8, #$00A9, #$F8F9, #$00AB, #$00AC, #$00AD, #$00AE, #$2015,
      #$00B0, #$00B1, #$00B2, #$00B3, #$0384, #$00B5, #$00B6, #$00B7, #$0388, #$0389, #$038A, #$00BB, #$038C, #$00BD, #$038E, #$038F,
      #$0390, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397, #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F,
      #$03A0, #$03A1, #$F8FA, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7, #$03A8, #$03A9, #$03AA, #$03AB, #$03AC, #$03AD, #$03AE, #$03AF,
      #$03B0, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7, #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF,
      #$03C0, #$03C1, #$03C2, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7, #$03C8, #$03C9, #$03CA, #$03CB, #$03CC, #$03CD, #$03CE, #$F8FB
    );

  cp775Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0106, #$00FC, #$00E9, #$0101, #$00E4, #$0123, #$00E5, #$0107, #$0142, #$0113, #$0156, #$0157, #$012B, #$0179, #$00C4, #$00C5,
      #$00C9, #$00E6, #$00C6, #$014D, #$00F6, #$0122, #$00A2, #$015A, #$015B, #$00D6, #$00DC, #$00F8, #$00A3, #$00D8, #$00D7, #$00A4,
      #$0100, #$012A, #$00F3, #$017B, #$017C, #$017A, #$201D, #$00A6, #$00A9, #$00AE, #$00AC, #$00BD, #$00BC, #$0141, #$00AB, #$00BB,
      #$2591, #$2592, #$2593, #$2502, #$2524, #$0104, #$010C, #$0118, #$0116, #$2563, #$2551, #$2557, #$255D, #$012E, #$0160, #$2510,
      #$2514, #$2534, #$252C, #$251C, #$2500, #$253C, #$0172, #$016A, #$255A, #$2554, #$2569, #$2566, #$2560, #$2550, #$256C, #$017D,
      #$0105, #$010D, #$0119, #$0117, #$012F, #$0161, #$0173, #$016B, #$017E, #$2518, #$250C, #$2588, #$2584, #$258C, #$2590, #$2580,
      #$00D3, #$00DF, #$014C, #$0143, #$00F5, #$00D5, #$00B5, #$0144, #$0136, #$0137, #$013B, #$013C, #$0146, #$0112, #$0145, #$2019,
      #$00AD, #$00B1, #$201C, #$00BE, #$00B6, #$00A7, #$00F7, #$201E, #$00B0, #$2219, #$00B7, #$00B9, #$00B3, #$00B2, #$25A0, #$00A0
    );

  cp858Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$00C7, #$00FC, #$00E9, #$00E2, #$00E4, #$00E0, #$00E5, #$00E7, #$00EA, #$00EB, #$00E8, #$00EF, #$00EE, #$00EC, #$00C4, #$00C5,
      #$00C9, #$00E6, #$00C6, #$00F4, #$00F6, #$00F2, #$00FB, #$00F9, #$00FF, #$00D6, #$00DC, #$00F8, #$00A3, #$00D8, #$00D7, #$0192,
      #$00E1, #$00ED, #$00F3, #$00FA, #$00F1, #$00D1, #$00AA, #$00BA, #$00BF, #$00AE, #$00AC, #$00BD, #$00BC, #$00A1, #$00AB, #$00BB,
      #$2591, #$2592, #$2593, #$2502, #$2524, #$00C1, #$00C2, #$00C0, #$00A9, #$2563, #$2551, #$2557, #$255D, #$00A2, #$00A5, #$2510,
      #$2514, #$2534, #$252C, #$251C, #$2500, #$253C, #$00E3, #$00C3, #$255A, #$2554, #$2569, #$2566, #$2560, #$2550, #$256C, #$00A4,
      #$00F0, #$00D0, #$00CA, #$00CB, #$00C8, #$0131, #$00CD, #$00CE, #$00CF, #$2518, #$250C, #$2588, #$2584, #$00A6, #$00CC, #$2580,
      #$00D3, #$00DF, #$00D4, #$00D2, #$00F5, #$00D5, #$00B5, #$00FE, #$00DE, #$00DA, #$00DB, #$00D9, #$00FD, #$00DD, #$00AF, #$00B4,
      #$00AD, #$00B1, #$2017, #$00BE, #$00B6, #$00A7, #$00F7, #$00B8, #$00B0, #$00A8, #$00B7, #$00B9, #$00B3, #$00B2, #$25A0, #$00A0
    );

  cpLatin9Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$00A1, #$00A2, #$00A3, #$20AC, #$00A5, #$0160, #$00A7, #$0161, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
      #$00B0, #$00B1, #$00B2, #$00B3, #$017D, #$00B5, #$00B6, #$00B7, #$017E, #$00B9, #$00BA, #$00BB, #$0152, #$0153, #$0178, #$00BF,
      #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
      #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7, #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
      #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
      #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00F7, #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00FF
    );

  cpLatin13Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$201D, #$00A2, #$00A3, #$00A4, #$201E, #$00A6, #$00A7, #$00D8, #$00A9, #$0156, #$00AB, #$00AC, #$00AD, #$00AE, #$00C6,
      #$00B0, #$00B1, #$00B2, #$00B3, #$201C, #$00B5, #$00B6, #$00B7, #$00F8, #$00B9, #$0157, #$00BB, #$00BC, #$00BD, #$00BE, #$00E6,
      #$0104, #$012E, #$0100, #$0106, #$00C4, #$00C5, #$0118, #$0112, #$010C, #$00C9, #$0179, #$0116, #$0122, #$0136, #$012A, #$013B,
      #$0160, #$0143, #$0145, #$00D3, #$014C, #$00D5, #$00D6, #$00D7, #$0172, #$0141, #$015A, #$016A, #$00DC, #$017B, #$017D, #$00DF,
      #$0105, #$012F, #$0101, #$0107, #$00E4, #$00E5, #$0119, #$0113, #$010D, #$00E9, #$017A, #$0117, #$0123, #$0137, #$012B, #$013C,
      #$0161, #$0144, #$0146, #$00F3, #$014D, #$00F5, #$00F6, #$00F7, #$0173, #$0142, #$015B, #$016B, #$00FC, #$017B, #$017E, #$2019
    );

  ISO8859_1Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7, #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
      #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF,
      #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
      #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7, #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
      #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
      #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00F7, #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00FF
    );

  ISO8859_2Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$0104, #$02D8, #$0141, #$00A4, #$013D, #$015A, #$00A7, #$00A8, #$0160, #$015E, #$0164, #$0179, #$00AD, #$017D, #$017B,
      #$00B0, #$0105, #$02DB, #$0142, #$00B4, #$013E, #$015B, #$02C7, #$00B8, #$0161, #$015F, #$0165, #$017A, #$02DD, #$017E, #$017C,
      #$0154, #$00C1, #$00C2, #$0102, #$00C4, #$0139, #$0106, #$00C7, #$010C, #$00C9, #$0118, #$00CB, #$011A, #$00CD, #$00CE, #$010E,
      #$0110, #$0143, #$0147, #$00D3, #$00D4, #$0150, #$00D6, #$00D7, #$0158, #$016E, #$00DA, #$0170, #$00DC, #$00DD, #$0162, #$00DF,
      #$0155, #$00E1, #$00E2, #$0103, #$00E4, #$013A, #$0107, #$00E7, #$010D, #$00E9, #$0119, #$00EB, #$011B, #$00ED, #$00EE, #$010F,
      #$0111, #$0144, #$0148, #$00F3, #$00F4, #$0151, #$00F6, #$00F7, #$0159, #$016F, #$00FA, #$0171, #$00FC, #$00FD, #$0163, #$02D9
    );

  ISO8859_9Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7, #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
      #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$00B5, #$00B6, #$00B7, #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF,
      #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
      #$011E, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7, #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$0130, #$015E, #$00DF,
      #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
      #$011F, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00F7, #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$0131, #$015F, #$00FF
    );

  ISO8859_13Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$201D, #$00A2, #$00A3, #$00A4, #$201E, #$00A6, #$00A7, #$00D8, #$00A9, #$0156, #$00AB, #$00AC, #$00AD, #$00AE, #$00C6,
      #$00B0, #$00B1, #$00B2, #$00B3, #$201C, #$00B5, #$00B6, #$00B7, #$00F8, #$00B9, #$0157, #$00BB, #$00BC, #$00BD, #$00BE, #$00E6,
      #$0104, #$012E, #$0100, #$0106, #$00C4, #$00C5, #$0118, #$0112, #$010C, #$00C9, #$0179, #$0116, #$0122, #$0136, #$012A, #$013B,
      #$0160, #$0143, #$0145, #$00D3, #$014C, #$00D5, #$00D6, #$00D7, #$0172, #$0141, #$015A, #$016A, #$00DC, #$017B, #$017D, #$00DF,
      #$0105, #$012F, #$0101, #$0107, #$00E4, #$00E5, #$0119, #$0113, #$010D, #$00E9, #$017A, #$0117, #$0123, #$0137, #$012B, #$013C,
      #$0161, #$0144, #$0146, #$00F3, #$014D, #$00F5, #$00F6, #$00F7, #$0173, #$0142, #$015B, #$016B, #$00FC, #$017C, #$017E, #$2019
    );

  MacceUni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$00C4, #$0100, #$0101, #$00C9, #$0104, #$00D6, #$00DC, #$00E1, #$0105, #$010C, #$00E4, #$010D, #$0106, #$0107, #$00E9, #$0179,
      #$017A, #$010E, #$00ED, #$010F, #$0112, #$0113, #$0116, #$00F3, #$0117, #$00F4, #$00F6, #$00F5, #$00FA, #$011A, #$011B, #$00FC,
      #$2020, #$00B0, #$0118, #$00A3, #$00A7, #$2022, #$00B6, #$00DF, #$00AE, #$00A9, #$2122, #$0119, #$00A8, #$2260, #$0123, #$012E,
      #$012F, #$012A, #$2264, #$2265, #$012B, #$0136, #$2202, #$2211, #$0142, #$013B, #$013C, #$013D, #$013E, #$0139, #$013A, #$0145,
      #$0146, #$0143, #$00AC, #$221A, #$0144, #$0147, #$2206, #$00AB, #$00BB, #$2026, #$00A0, #$0148, #$0150, #$00D5, #$0151, #$014C,
      #$2013, #$2014, #$201C, #$201D, #$2018, #$2019, #$00F7, #$25CA, #$014D, #$0154, #$0155, #$0158, #$2039, #$203A, #$0159, #$0156,
      #$0157, #$0160, #$201A, #$201E, #$0161, #$015A, #$015B, #$00C1, #$0164, #$0165, #$00CD, #$017D, #$017E, #$016A, #$00D3, #$00D4,
      #$016B, #$016E, #$00DA, #$016F, #$0170, #$0171, #$0172, #$0173, #$00DD, #$00FD, #$0137, #$017B, #$0141, #$017C, #$0122, #$02C7
    );

  MacromanUni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$00C4, #$00C5, #$00C7, #$00C9, #$00D1, #$00D6, #$00DC, #$00E1, #$00E0, #$00E2, #$00E4, #$00E3, #$00E5, #$00E7, #$00E9, #$00E8,
      #$00EA, #$00EB, #$00ED, #$00EC, #$00EE, #$00EF, #$00F1, #$00F3, #$00F2, #$00F4, #$00F6, #$00F5, #$00FA, #$00F9, #$00FB, #$00FC,
      #$2020, #$00B0, #$00A2, #$00A3, #$00A7, #$2022, #$00B6, #$00DF, #$00AE, #$00A9, #$2122, #$00B4, #$00A8, #$2260, #$00C6, #$00D8,
      #$221E, #$00B1, #$2264, #$2265, #$00A5, #$00B5, #$2202, #$2211, #$220F, #$03C0, #$222B, #$00AA, #$00BA, #$03A9, #$00E6, #$00F8,
      #$00BF, #$00A1, #$00AC, #$221A, #$0192, #$2248, #$2206, #$00AB, #$00BB, #$2026, #$00A0, #$00C0, #$00C3, #$00D5, #$0152, #$0153,
      #$2013, #$2014, #$201C, #$201D, #$2018, #$2019, #$00F7, #$25CA, #$00FF, #$0178, #$2044, #$20AC, #$2039, #$203A, #$FB01, #$FB02,
      #$2021, #$00B7, #$201A, #$201E, #$2030, #$00C2, #$00CA, #$00C1, #$00CB, #$00C8, #$00CD, #$00CE, #$00CF, #$00CC, #$00D3, #$00D4,
      #$F8FF, #$00D2, #$00DA, #$00DB, #$00D9, #$0131, #$02C6, #$02DC, #$00AF, #$02D8, #$02D9, #$02DA, #$00B8, #$02DD, #$02DB, #$02C7
    );

  Swe7Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$00C9, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$00C4, #$00D6, #$00C5, #$00DC, #$005F,
      #$00E9, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$00E4, #$00F6, #$00E5, #$00FC, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000
    );

  ISO8859_3Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$0126, #$02D8, #$00A3, #$00A4, #$0000, #$0124, #$00A7, #$00A8, #$0130, #$015E, #$011E, #$0134, #$00AD, #$0000, #$017B,
      #$00B0, #$0127, #$00B2, #$00B3, #$00B4, #$00B5, #$0125, #$00B7, #$00B8, #$0131, #$015F, #$011F, #$0135, #$00BD, #$0000, #$017C,
      #$00C0, #$00C1, #$00C2, #$0000, #$00C4, #$010A, #$0108, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
      #$00D1, #$00D2, #$00D3, #$0000, #$00D4, #$0120, #$00D6, #$00D7, #$011C, #$00D9, #$00DA, #$00DB, #$00DC, #$016C, #$015C, #$00DF,
      #$00E0, #$00E1, #$00E2, #$0000, #$00E4, #$010B, #$0109, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
      #$0000, #$00F1, #$00F2, #$00F3, #$00F4, #$0121, #$00F6, #$00F7, #$011D, #$00F9, #$00FA, #$00FB, #$00FC, #$016D, #$015D, #$02D9
    );

  ISO8859_4Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$0104, #$0138, #$0156, #$00A4, #$0128, #$013B, #$00A7, #$00A8, #$0160, #$0112, #$0122, #$0166, #$00AD, #$017D, #$00AF,
      #$00B0, #$0105, #$02DB, #$0157, #$00B4, #$0129, #$013C, #$02C7, #$00B8, #$0161, #$0113, #$0123, #$0167, #$014A, #$017E, #$014B,
      #$0100, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$012E, #$010C, #$00C9, #$0118, #$00CB, #$0116, #$00CD, #$00CE, #$012A,
      #$0110, #$0145, #$014C, #$0136, #$00D4, #$00D5, #$00D6, #$00D7, #$00D8, #$0172, #$00DA, #$00DB, #$00DC, #$0168, #$016A, #$00DF,
      #$0101, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$012F, #$010D, #$00E9, #$0119, #$00EB, #$0117, #$00ED, #$00EE, #$012B,
      #$0111, #$0146, #$014D, #$0137, #$00F4, #$00F5, #$00F6, #$00F7, #$00F8, #$0173, #$00FA, #$00FB, #$00FC, #$0169, #$016B, #$02D9
    );

  ISO8859_10Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$0104, #$0112, #$0122, #$012A, #$0128, #$0136, #$00A7, #$013B, #$0110, #$0160, #$0166, #$017D, #$00AD, #$016A, #$014A,
      #$00B0, #$0105, #$0113, #$0123, #$012B, #$0129, #$0137, #$00B7, #$013C, #$0111, #$0161, #$0167, #$017E, #$2015, #$016B, #$014B,
      #$0100, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$012E, #$010C, #$00C9, #$0118, #$00CB, #$0116, #$00CD, #$00CE, #$00CF,
      #$00D0, #$0145, #$014C, #$00D3, #$00D4, #$00D5, #$00D6, #$0168, #$00D8, #$0172, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
      #$0101, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$012F, #$010D, #$00E9, #$0119, #$00EB, #$0117, #$00ED, #$00EE, #$00EF,
      #$00F0, #$0146, #$014D, #$00F3, #$00F4, #$00F5, #$00F6, #$0169, #$00F8, #$0173, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$0138
    );

  ISO8859_14Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$1E02, #$1E03, #$00A3, #$010A, #$010B, #$1E0A, #$00A7, #$1E80, #$00A9, #$1E82, #$1E0B, #$1EF2, #$00AD, #$00AE, #$0178,
      #$1E1E, #$1E1F, #$0120, #$0121, #$1E40, #$1E41, #$00B6, #$1E56, #$1E81, #$1E57, #$1E83, #$1E60, #$1EF3, #$1E84, #$1E85, #$1E61,
      #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7, #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
      #$0174, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$1E6A, #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$0176, #$00DF,
      #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7, #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
      #$0175, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$1E6B, #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$0177, #$00FF
    );

  ISO8859_5Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407, #$0408, #$0409, #$040A, #$040B, #$040C, #$00AD, #$040E, #$040F,
      #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417, #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F,
      #$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427, #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
      #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437, #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F,
      #$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447, #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F,
      #$2116, #$0451, #$0452, #$0453, #$0454, #$0455, #$0456, #$0457, #$0458, #$0459, #$045A, #$045B, #$045C, #$00A7, #$045E, #$045F
    );

  ISO8859_6Uni: TArrCharOfWideChar =
    (
      #$0000, #$0001, #$0002, #$0003, #$0004, #$0005, #$0006, #$0007, #$0008, #$0009, #$000A, #$000B, #$000C, #$000D, #$000E, #$000F,
      #$0010, #$0011, #$0012, #$0013, #$0014, #$0015, #$0016, #$0017, #$0018, #$0019, #$001A, #$001B, #$001C, #$001D, #$001E, #$001F,
      #$0020, #$0021, #$0022, #$0023, #$0024, #$0025, #$0026, #$0027, #$0028, #$0029, #$002A, #$002B, #$002C, #$002D, #$002E, #$002F,
      #$0030, #$0031, #$0032, #$0033, #$0034, #$0035, #$0036, #$0037, #$0038, #$0039, #$003A, #$003B, #$003C, #$003D, #$003E, #$003F,
      #$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047, #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
      #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057, #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
      #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067, #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
      #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077, #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F,
      #$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087, #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
      #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097, #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
      #$00A0, #$0000, #$0000, #$0000, #$00A4, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$060C, #$00AD, #$0000, #$0000,
      #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$061B, #$0000, #$0000, #$0000, #$061F,
      #$0000, #$0621, #$0622, #$0623, #$0624, #$0625, #$0626, #$0627, #$0628, #$0629, #$062A, #$062B, #$062C, #$062D, #$062E, #$062F,
      #$0630, #$0631, #$0632, #$0633, #$0634, #$0635, #$0636, #$0637, #$0638, #$0639, #$063A, #$0000, #$0000, #$0000, #$0000, #$0000,
      #$0640, #$0641, #$0642, #$0643, #$0644, #$0645, #$0646, #$0647, #$0648, #$0649, #$064A, #$064B, #$064C, #$064D, #$064E, #$064F,
      #$0650, #$0651, #$0652, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000, #$0000
    );

  Cp1026Uni : TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$009C,#$0009,#$0086,#$007F,#$0097,#$008D,#$008E,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$009D,#$0085,#$0008,#$0087,#$0018,#$0019,#$0092,#$008F,#$001C,#$001D,#$001E,#$001F,
      #$0080,#$0081,#$0082,#$0083,#$0084,#$000A,#$0017,#$001B,#$0088,#$0089,#$008A,#$008B,#$008C,#$0005,#$0006,#$0007,
      #$0090,#$0091,#$0016,#$0093,#$0094,#$0095,#$0096,#$0004,#$0098,#$0099,#$009A,#$009B,#$0014,#$0015,#$009E,#$001A,
      #$0020,#$00A0,#$00E2,#$00E4,#$00E0,#$00E1,#$00E3,#$00E5,#$007B,#$00F1,#$00C7,#$002E,#$003C,#$0028,#$002B,#$0021,
      #$0026,#$00E9,#$00EA,#$00EB,#$00E8,#$00ED,#$00EE,#$00EF,#$00EC,#$00DF,#$011E,#$0130,#$002A,#$0029,#$003B,#$005E,
      #$002D,#$002F,#$00C2,#$00C4,#$00C0,#$00C1,#$00C3,#$00C5,#$005B,#$00D1,#$015F,#$002C,#$0025,#$005F,#$003E,#$003F,
      #$00F8,#$00C9,#$00CA,#$00CB,#$00C8,#$00CD,#$00CE,#$00CF,#$00CC,#$0131,#$003A,#$00D6,#$015E,#$0027,#$003D,#$00DC,
      #$00D8,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$00AB,#$00BB,#$007D,#$0060,#$00A6,#$00B1,
      #$00B0,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,#$0070,#$0071,#$0072,#$00AA,#$00BA,#$00E6,#$00B8,#$00C6,#$00A4,
      #$00B5,#$00F6,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$00A1,#$00BF,#$005D,#$0024,#$0040,#$00AE,
      #$00A2,#$00A3,#$00A5,#$00B7,#$00A9,#$00A7,#$00B6,#$00BC,#$00BD,#$00BE,#$00AC,#$007C,#$00AF,#$00A8,#$00B4,#$00D7,
      #$00E7,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$00AD,#$00F4,#$007E,#$00F2,#$00F3,#$00F5,
      #$011F,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,#$0050,#$0051,#$0052,#$00B9,#$00FB,#$005C,#$00F9,#$00FA,#$00FF,
      #$00FC,#$00F7,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$00B2,#$00D4,#$0023,#$00D2,#$00D3,#$00D5,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$00B3,#$00DB,#$0022,#$00D9,#$00DA,#$009F
    );

  Cp1254Uni : TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$20AC,#$FFFD,#$201A,#$0192,#$201E,#$2026,#$2020,#$2021,#$02C6,#$2030,#$0160,#$2039,#$0152,#$FFFD,#$FFFD,#$FFFD,
      #$FFFD,#$2018,#$2019,#$201C,#$201D,#$2022,#$2013,#$2014,#$02DC,#$2122,#$0161,#$203A,#$0153,#$FFFD,#$FFFD,#$0178,
      #$00A0,#$00A1,#$00A2,#$00A3,#$00A4,#$00A5,#$00A6,#$00A7,#$00A8,#$00A9,#$00AA,#$00AB,#$00AC,#$00AD,#$00AE,#$00AF,
      #$00B0,#$00B1,#$00B2,#$00B3,#$00B4,#$00B5,#$00B6,#$00B7,#$00B8,#$00B9,#$00BA,#$00BB,#$00BC,#$00BD,#$00BE,#$00BF,
      #$00C0,#$00C1,#$00C2,#$00C3,#$00C4,#$00C5,#$00C6,#$00C7,#$00C8,#$00C9,#$00CA,#$00CB,#$00CC,#$00CD,#$00CE,#$00CF,
      #$011E,#$00D1,#$00D2,#$00D3,#$00D4,#$00D5,#$00D6,#$00D7,#$00D8,#$00D9,#$00DA,#$00DB,#$00DC,#$0130,#$015E,#$00DF,
      #$00E0,#$00E1,#$00E2,#$00E3,#$00E4,#$00E5,#$00E6,#$00E7,#$00E8,#$00E9,#$00EA,#$00EB,#$00EC,#$00ED,#$00EE,#$00EF,
      #$011F,#$00F1,#$00F2,#$00F3,#$00F4,#$00F5,#$00F6,#$00F7,#$00F8,#$00F9,#$00FA,#$00FB,#$00FC,#$0131,#$015F,#$00FF
    );

  Cp1255Uni : TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$20AC,#$FFFD,#$201A,#$0192,#$201E,#$2026,#$2020,#$2021,#$02C6,#$2030,#$FFFD,#$2039,#$FFFD,#$FFFD,#$FFFD,#$FFFD,
      #$FFFD,#$2018,#$2019,#$201C,#$201D,#$2022,#$2013,#$2014,#$02DC,#$2122,#$FFFD,#$203A,#$FFFD,#$FFFD,#$FFFD,#$FFFD,
      #$00A0,#$00A1,#$00A2,#$00A3,#$20AA,#$00A5,#$00A6,#$00A7,#$00A8,#$00A9,#$00D7,#$00AB,#$00AC,#$00AD,#$00AE,#$00AF,
      #$00B0,#$00B1,#$00B2,#$00B3,#$00B4,#$00B5,#$00B6,#$00B7,#$00B8,#$00B9,#$00F7,#$00BB,#$00BC,#$00BD,#$00BE,#$00BF,
      #$05B0,#$05B1,#$05B2,#$05B3,#$05B4,#$05B5,#$05B6,#$05B7,#$05B8,#$05B9,#$FFFD,#$05BB,#$05BC,#$05BD,#$05BE,#$05BF,
      #$05C0,#$05C1,#$05C2,#$05C3,#$05F0,#$05F1,#$05F2,#$05F3,#$05F4,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,
      #$05D0,#$05D1,#$05D2,#$05D3,#$05D4,#$05D5,#$05D6,#$05D7,#$05D8,#$05D9,#$05DA,#$05DB,#$05DC,#$05DD,#$05DE,#$05DF,
      #$05E0,#$05E1,#$05E2,#$05E3,#$05E4,#$05E5,#$05E6,#$05E7,#$05E8,#$05E9,#$05EA,#$FFFD,#$FFFD,#$200E,#$200F,#$FFFD
    );

  Cp1258Uni : TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$20AC,#$FFFD,#$201A,#$0192,#$201E,#$2026,#$2020,#$2021,#$02C6,#$2030,#$FFFD,#$2039,#$0152,#$FFFD,#$FFFD,#$FFFD,
      #$FFFD,#$2018,#$2019,#$201C,#$201D,#$2022,#$2013,#$2014,#$02DC,#$2122,#$FFFD,#$203A,#$0153,#$FFFD,#$FFFD,#$0178,
      #$00A0,#$00A1,#$00A2,#$00A3,#$00A4,#$00A5,#$00A6,#$00A7,#$00A8,#$00A9,#$00AA,#$00AB,#$00AC,#$00AD,#$00AE,#$00AF,
      #$00B0,#$00B1,#$00B2,#$00B3,#$00B4,#$00B5,#$00B6,#$00B7,#$00B8,#$00B9,#$00BA,#$00BB,#$00BC,#$00BD,#$00BE,#$00BF,
      #$00C0,#$00C1,#$00C2,#$0102,#$00C4,#$00C5,#$00C6,#$00C7,#$00C8,#$00C9,#$00CA,#$00CB,#$0300,#$00CD,#$00CE,#$00CF,
      #$0110,#$00D1,#$0309,#$00D3,#$00D4,#$01A0,#$00D6,#$00D7,#$00D8,#$00D9,#$00DA,#$00DB,#$00DC,#$01AF,#$0303,#$00DF,
      #$00E0,#$00E1,#$00E2,#$0103,#$00E4,#$00E5,#$00E6,#$00E7,#$00E8,#$00E9,#$00EA,#$00EB,#$0301,#$00ED,#$00EE,#$00EF,
      #$0111,#$00F1,#$0323,#$00F3,#$00F4,#$01A1,#$00F6,#$00F7,#$00F8,#$00F9,#$00FA,#$00FB,#$00FC,#$01B0,#$20AB,#$00FF
    );

  Cp437Uni : TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$00C7,#$00FC,#$00E9,#$00E2,#$00E4,#$00E0,#$00E5,#$00E7,#$00EA,#$00EB,#$00E8,#$00EF,#$00EE,#$00EC,#$00C4,#$00C5,
      #$00C9,#$00E6,#$00C6,#$00F4,#$00F6,#$00F2,#$00FB,#$00F9,#$00FF,#$00D6,#$00DC,#$00A2,#$00A3,#$00A5,#$20A7,#$0192,
      #$00E1,#$00ED,#$00F3,#$00FA,#$00F1,#$00D1,#$00AA,#$00BA,#$00BF,#$2310,#$00AC,#$00BD,#$00BC,#$00A1,#$00AB,#$00BB,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$2561,#$2562,#$2556,#$2555,#$2563,#$2551,#$2557,#$255D,#$255C,#$255B,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$255E,#$255F,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$2567,
      #$2568,#$2564,#$2565,#$2559,#$2558,#$2552,#$2553,#$256B,#$256A,#$2518,#$250C,#$2588,#$2584,#$258C,#$2590,#$2580,
      #$03B1,#$00DF,#$0393,#$03C0,#$03A3,#$03C3,#$00B5,#$03C4,#$03A6,#$0398,#$03A9,#$03B4,#$221E,#$03C6,#$03B5,#$2229,
      #$2261,#$00B1,#$2265,#$2264,#$2320,#$2321,#$00F7,#$2248,#$00B0,#$2219,#$00B7,#$221A,#$207F,#$00B2,#$25A0,#$00A0
    );

  Cp500Uni : TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$009C,#$0009,#$0086,#$007F,#$0097,#$008D,#$008E,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$009D,#$0085,#$0008,#$0087,#$0018,#$0019,#$0092,#$008F,#$001C,#$001D,#$001E,#$001F,
      #$0080,#$0081,#$0082,#$0083,#$0084,#$000A,#$0017,#$001B,#$0088,#$0089,#$008A,#$008B,#$008C,#$0005,#$0006,#$0007,
      #$0090,#$0091,#$0016,#$0093,#$0094,#$0095,#$0096,#$0004,#$0098,#$0099,#$009A,#$009B,#$0014,#$0015,#$009E,#$001A,
      #$0020,#$00A0,#$00E2,#$00E4,#$00E0,#$00E1,#$00E3,#$00E5,#$00E7,#$00F1,#$005B,#$002E,#$003C,#$0028,#$002B,#$0021,
      #$0026,#$00E9,#$00EA,#$00EB,#$00E8,#$00ED,#$00EE,#$00EF,#$00EC,#$00DF,#$005D,#$0024,#$002A,#$0029,#$003B,#$005E,
      #$002D,#$002F,#$00C2,#$00C4,#$00C0,#$00C1,#$00C3,#$00C5,#$00C7,#$00D1,#$00A6,#$002C,#$0025,#$005F,#$003E,#$003F,
      #$00F8,#$00C9,#$00CA,#$00CB,#$00C8,#$00CD,#$00CE,#$00CF,#$00CC,#$0060,#$003A,#$0023,#$0040,#$0027,#$003D,#$0022,
      #$00D8,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$00AB,#$00BB,#$00F0,#$00FD,#$00FE,#$00B1,
      #$00B0,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,#$0070,#$0071,#$0072,#$00AA,#$00BA,#$00E6,#$00B8,#$00C6,#$00A4,
      #$00B5,#$007E,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$00A1,#$00BF,#$00D0,#$00DD,#$00DE,#$00AE,
      #$00A2,#$00A3,#$00A5,#$00B7,#$00A9,#$00A7,#$00B6,#$00BC,#$00BD,#$00BE,#$00AC,#$007C,#$00AF,#$00A8,#$00B4,#$00D7,
      #$007B,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$00AD,#$00F4,#$00F6,#$00F2,#$00F3,#$00F5,
      #$007D,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,#$0050,#$0051,#$0052,#$00B9,#$00FB,#$00FC,#$00F9,#$00FA,#$00FF,
      #$005C,#$00F7,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$00B2,#$00D4,#$00D6,#$00D2,#$00D3,#$00D5,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$00B3,#$00DB,#$00DC,#$00D9,#$00DA,#$009F
    );

  Cp737Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$0391,#$0392,#$0393,#$0394,#$0395,#$0396,#$0397,#$0398,#$0399,#$039A,#$039B,#$039C,#$039D,#$039E,#$039F,#$03A0,
      #$03A1,#$03A3,#$03A4,#$03A5,#$03A6,#$03A7,#$03A8,#$03A9,#$03B1,#$03B2,#$03B3,#$03B4,#$03B5,#$03B6,#$03B7,#$03B8,
      #$03B9,#$03BA,#$03BB,#$03BC,#$03BD,#$03BE,#$03BF,#$03C0,#$03C1,#$03C3,#$03C2,#$03C4,#$03C5,#$03C6,#$03C7,#$03C8,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$2561,#$2562,#$2556,#$2555,#$2563,#$2551,#$2557,#$255D,#$255C,#$255B,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$255E,#$255F,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$2567,
      #$2568,#$2564,#$2565,#$2559,#$2558,#$2552,#$2553,#$256B,#$256A,#$2518,#$250C,#$2588,#$2584,#$258C,#$2590,#$2580,
      #$03C9,#$03AC,#$03AD,#$03AE,#$03CA,#$03AF,#$03CC,#$03CD,#$03CB,#$03CE,#$0386,#$0388,#$0389,#$038A,#$038C,#$038E,
      #$038F,#$00B1,#$2265,#$2264,#$03AA,#$03AB,#$00F7,#$2248,#$00B0,#$2219,#$00B7,#$221A,#$207F,#$00B2,#$25A0,#$00A0
    );

  Cp855Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$0452,#$0402,#$0453,#$0403,#$0451,#$0401,#$0454,#$0404,#$0455,#$0405,#$0456,#$0406,#$0457,#$0407,#$0458,#$0408,
      #$0459,#$0409,#$045A,#$040A,#$045B,#$040B,#$045C,#$040C,#$045E,#$040E,#$045F,#$040F,#$044E,#$042E,#$044A,#$042A,
      #$0430,#$0410,#$0431,#$0411,#$0446,#$0426,#$0434,#$0414,#$0435,#$0415,#$0444,#$0424,#$0433,#$0413,#$00AB,#$00BB,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$0445,#$0425,#$0438,#$0418,#$2563,#$2551,#$2557,#$255D,#$0439,#$0419,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$043A,#$041A,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$00A4,
      #$043B,#$041B,#$043C,#$041C,#$043D,#$041D,#$043E,#$041E,#$043F,#$2518,#$250C,#$2588,#$2584,#$041F,#$044F,#$2580,
      #$042F,#$0440,#$0420,#$0441,#$0421,#$0442,#$0422,#$0443,#$0423,#$0436,#$0416,#$0432,#$0412,#$044C,#$042C,#$2116,
      #$00AD,#$044B,#$042B,#$0437,#$0417,#$0448,#$0428,#$044D,#$042D,#$0449,#$0429,#$0447,#$0427,#$00A7,#$25A0,#$00A0
    );

  Cp856Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$05D0,#$05D1,#$05D2,#$05D3,#$05D4,#$05D5,#$05D6,#$05D7,#$05D8,#$05D9,#$05DA,#$05DB,#$05DC,#$05DD,#$05DE,#$05DF,
      #$05E0,#$05E1,#$05E2,#$05E3,#$05E4,#$05E5,#$05E6,#$05E7,#$05E8,#$05E9,#$05EA,#$FFFD,#$00A3,#$FFFD,#$00D7,#$FFFD,
      #$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$00AE,#$00AC,#$00BD,#$00BC,#$FFFD,#$00AB,#$00BB,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$FFFD,#$FFFD,#$FFFD,#$00A9,#$2563,#$2551,#$2557,#$255D,#$00A2,#$00A5,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$FFFD,#$FFFD,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$00A4,
      #$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$2518,#$250C,#$2588,#$2584,#$00A6,#$FFFD,#$2580,
      #$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$00B5,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$00AF,#$00B4,
      #$00AD,#$00B1,#$2017,#$00BE,#$00B6,#$00A7,#$00F7,#$00B8,#$00B0,#$00A8,#$00B7,#$00B9,#$00B3,#$00B2,#$25A0,#$00A0
    );

  Cp857Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$00C7,#$00FC,#$00E9,#$00E2,#$00E4,#$00E0,#$00E5,#$00E7,#$00EA,#$00EB,#$00E8,#$00EF,#$00EE,#$0131,#$00C4,#$00C5,
      #$00C9,#$00E6,#$00C6,#$00F4,#$00F6,#$00F2,#$00FB,#$00F9,#$0130,#$00D6,#$00DC,#$00F8,#$00A3,#$00D8,#$015E,#$015F,
      #$00E1,#$00ED,#$00F3,#$00FA,#$00F1,#$00D1,#$011E,#$011F,#$00BF,#$00AE,#$00AC,#$00BD,#$00BC,#$00A1,#$00AB,#$00BB,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$00C1,#$00C2,#$00C0,#$00A9,#$2563,#$2551,#$2557,#$255D,#$00A2,#$00A5,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$00E3,#$00C3,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$00A4,
      #$00BA,#$00AA,#$00CA,#$00CB,#$00C8,#$FFFD,#$00CD,#$00CE,#$00CF,#$2518,#$250C,#$2588,#$2584,#$00A6,#$00CC,#$2580,
      #$00D3,#$00DF,#$00D4,#$00D2,#$00F5,#$00D5,#$00B5,#$FFFD,#$00D7,#$00DA,#$00DB,#$00D9,#$00EC,#$00FF,#$00AF,#$00B4,
      #$00AD,#$00B1,#$FFFD,#$00BE,#$00B6,#$00A7,#$00F7,#$00B8,#$00B0,#$00A8,#$00B7,#$00B9,#$00B3,#$00B2,#$25A0,#$00A0
    );

  Cp860Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$00C7,#$00FC,#$00E9,#$00E2,#$00E3,#$00E0,#$00C1,#$00E7,#$00EA,#$00CA,#$00E8,#$00CD,#$00D4,#$00EC,#$00C3,#$00C2,
      #$00C9,#$00C0,#$00C8,#$00F4,#$00F5,#$00F2,#$00DA,#$00F9,#$00CC,#$00D5,#$00DC,#$00A2,#$00A3,#$00D9,#$20A7,#$00D3,
      #$00E1,#$00ED,#$00F3,#$00FA,#$00F1,#$00D1,#$00AA,#$00BA,#$00BF,#$00D2,#$00AC,#$00BD,#$00BC,#$00A1,#$00AB,#$00BB,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$2561,#$2562,#$2556,#$2555,#$2563,#$2551,#$2557,#$255D,#$255C,#$255B,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$255E,#$255F,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$2567,
      #$2568,#$2564,#$2565,#$2559,#$2558,#$2552,#$2553,#$256B,#$256A,#$2518,#$250C,#$2588,#$2584,#$258C,#$2590,#$2580,
      #$03B1,#$00DF,#$0393,#$03C0,#$03A3,#$03C3,#$00B5,#$03C4,#$03A6,#$0398,#$03A9,#$03B4,#$221E,#$03C6,#$03B5,#$2229,
      #$2261,#$00B1,#$2265,#$2264,#$2320,#$2321,#$00F7,#$2248,#$00B0,#$2219,#$00B7,#$221A,#$207F,#$00B2,#$25A0,#$00A0
    );

  Cp862Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$05D0,#$05D1,#$05D2,#$05D3,#$05D4,#$05D5,#$05D6,#$05D7,#$05D8,#$05D9,#$05DA,#$05DB,#$05DC,#$05DD,#$05DE,#$05DF,
      #$05E0,#$05E1,#$05E2,#$05E3,#$05E4,#$05E5,#$05E6,#$05E7,#$05E8,#$05E9,#$05EA,#$00A2,#$00A3,#$00A5,#$20A7,#$0192,
      #$00E1,#$00ED,#$00F3,#$00FA,#$00F1,#$00D1,#$00AA,#$00BA,#$00BF,#$2310,#$00AC,#$00BD,#$00BC,#$00A1,#$00AB,#$00BB,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$2561,#$2562,#$2556,#$2555,#$2563,#$2551,#$2557,#$255D,#$255C,#$255B,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$255E,#$255F,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$2567,
      #$2568,#$2564,#$2565,#$2559,#$2558,#$2552,#$2553,#$256B,#$256A,#$2518,#$250C,#$2588,#$2584,#$258C,#$2590,#$2580,
      #$03B1,#$00DF,#$0393,#$03C0,#$03A3,#$03C3,#$00B5,#$03C4,#$03A6,#$0398,#$03A9,#$03B4,#$221E,#$03C6,#$03B5,#$2229,
      #$2261,#$00B1,#$2265,#$2264,#$2320,#$2321,#$00F7,#$2248,#$00B0,#$2219,#$00B7,#$221A,#$207F,#$00B2,#$25A0,#$00A0
    );

  Cp863Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$00C7,#$00FC,#$00E9,#$00E2,#$00C2,#$00E0,#$00B6,#$00E7,#$00EA,#$00EB,#$00E8,#$00EF,#$00EE,#$2017,#$00C0,#$00A7,
      #$00C9,#$00C8,#$00CA,#$00F4,#$00CB,#$00CF,#$00FB,#$00F9,#$00A4,#$00D4,#$00DC,#$00A2,#$00A3,#$00D9,#$00DB,#$0192,
      #$00A6,#$00B4,#$00F3,#$00FA,#$00A8,#$00B8,#$00B3,#$00AF,#$00CE,#$2310,#$00AC,#$00BD,#$00BC,#$00BE,#$00AB,#$00BB,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$2561,#$2562,#$2556,#$2555,#$2563,#$2551,#$2557,#$255D,#$255C,#$255B,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$255E,#$255F,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$2567,
      #$2568,#$2564,#$2565,#$2559,#$2558,#$2552,#$2553,#$256B,#$256A,#$2518,#$250C,#$2588,#$2584,#$258C,#$2590,#$2580,
      #$03B1,#$00DF,#$0393,#$03C0,#$03A3,#$03C3,#$00B5,#$03C4,#$03A6,#$0398,#$03A9,#$03B4,#$221E,#$03C6,#$03B5,#$2229,
      #$2261,#$00B1,#$2265,#$2264,#$2320,#$2321,#$00F7,#$2248,#$00B0,#$2219,#$00B7,#$221A,#$207F,#$00B2,#$25A0,#$00A0
    );

  Cp864Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$066A,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$00B0,#$00B7,#$2219,#$221A,#$2592,#$2500,#$2502,#$253C,#$2524,#$252C,#$251C,#$2534,#$2510,#$250C,#$2514,#$2518,
      #$03B2,#$221E,#$03C6,#$00B1,#$00BD,#$00BC,#$2248,#$00AB,#$00BB,#$FEF7,#$FEF8,#$FFFD,#$FFFD,#$FEFB,#$FEFC,#$FFFD,
      #$00A0,#$00AD,#$FE82,#$00A3,#$00A4,#$FE84,#$FFFD,#$FFFD,#$FE8E,#$FE8F,#$FE95,#$FE99,#$060C,#$FE9D,#$FEA1,#$FEA5,
      #$0660,#$0661,#$0662,#$0663,#$0664,#$0665,#$0666,#$0667,#$0668,#$0669,#$FED1,#$061B,#$FEB1,#$FEB5,#$FEB9,#$061F,
      #$00A2,#$FE80,#$FE81,#$FE83,#$FE85,#$FECA,#$FE8B,#$FE8D,#$FE91,#$FE93,#$FE97,#$FE9B,#$FE9F,#$FEA3,#$FEA7,#$FEA9,
      #$FEAB,#$FEAD,#$FEAF,#$FEB3,#$FEB7,#$FEBB,#$FEBF,#$FEC1,#$FEC5,#$FECB,#$FECF,#$00A6,#$00AC,#$00F7,#$00D7,#$FEC9,
      #$0640,#$FED3,#$FED7,#$FEDB,#$FEDF,#$FEE3,#$FEE7,#$FEEB,#$FEED,#$FEEF,#$FEF3,#$FEBD,#$FECC,#$FECE,#$FECD,#$FEE1,
      #$FE7D,#$0651,#$FEE5,#$FEE9,#$FEEC,#$FEF0,#$FEF2,#$FED0,#$FED5,#$FEF5,#$FEF6,#$FEDD,#$FED9,#$FEF1,#$25A0,#$FFFD
    );

  Cp865Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$00C7,#$00FC,#$00E9,#$00E2,#$00E4,#$00E0,#$00E5,#$00E7,#$00EA,#$00EB,#$00E8,#$00EF,#$00EE,#$00EC,#$00C4,#$00C5,
      #$00C9,#$00E6,#$00C6,#$00F4,#$00F6,#$00F2,#$00FB,#$00F9,#$00FF,#$00D6,#$00DC,#$00F8,#$00A3,#$00D8,#$20A7,#$0192,
      #$00E1,#$00ED,#$00F3,#$00FA,#$00F1,#$00D1,#$00AA,#$00BA,#$00BF,#$2310,#$00AC,#$00BD,#$00BC,#$00A1,#$00AB,#$00A4,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$2561,#$2562,#$2556,#$2555,#$2563,#$2551,#$2557,#$255D,#$255C,#$255B,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$255E,#$255F,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$2567,
      #$2568,#$2564,#$2565,#$2559,#$2558,#$2552,#$2553,#$256B,#$256A,#$2518,#$250C,#$2588,#$2584,#$258C,#$2590,#$2580,
      #$03B1,#$00DF,#$0393,#$03C0,#$03A3,#$03C3,#$00B5,#$03C4,#$03A6,#$0398,#$03A9,#$03B4,#$221E,#$03C6,#$03B5,#$2229,
      #$2261,#$00B1,#$2265,#$2264,#$2320,#$2321,#$00F7,#$2248,#$00B0,#$2219,#$00B7,#$221A,#$207F,#$00B2,#$25A0,#$00A0
    );

  Cp869Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$0386,#$FFFD,#$00B7,#$00AC,#$00A6,#$2018,#$2019,#$0388,#$2015,#$0389,
      #$038A,#$03AA,#$038C,#$FFFD,#$FFFD,#$038E,#$03AB,#$00A9,#$038F,#$00B2,#$00B3,#$03AC,#$00A3,#$03AD,#$03AE,#$03AF,
      #$03CA,#$0390,#$03CC,#$03CD,#$0391,#$0392,#$0393,#$0394,#$0395,#$0396,#$0397,#$00BD,#$0398,#$0399,#$00AB,#$00BB,
      #$2591,#$2592,#$2593,#$2502,#$2524,#$039A,#$039B,#$039C,#$039D,#$2563,#$2551,#$2557,#$255D,#$039E,#$039F,#$2510,
      #$2514,#$2534,#$252C,#$251C,#$2500,#$253C,#$03A0,#$03A1,#$255A,#$2554,#$2569,#$2566,#$2560,#$2550,#$256C,#$03A3,
      #$03A4,#$03A5,#$03A6,#$03A7,#$03A8,#$03A9,#$03B1,#$03B2,#$03B3,#$2518,#$250C,#$2588,#$2584,#$03B4,#$03B5,#$2580,
      #$03B6,#$03B7,#$03B8,#$03B9,#$03BA,#$03BB,#$03BC,#$03BD,#$03BE,#$03BF,#$03C0,#$03C1,#$03C3,#$03C2,#$03C4,#$0384,
      #$00AD,#$00B1,#$03C5,#$03C6,#$03C7,#$00A7,#$03C8,#$0385,#$00B0,#$00A8,#$03C9,#$03CB,#$03B0,#$03CE,#$25A0,#$00A0
    );

  Cp874Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$20AC,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$2026,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,
      #$FFFD,#$2018,#$2019,#$201C,#$201D,#$2022,#$2013,#$2014,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$FFFD,
      #$00A0,#$0E01,#$0E02,#$0E03,#$0E04,#$0E05,#$0E06,#$0E07,#$0E08,#$0E09,#$0E0A,#$0E0B,#$0E0C,#$0E0D,#$0E0E,#$0E0F,
      #$0E10,#$0E11,#$0E12,#$0E13,#$0E14,#$0E15,#$0E16,#$0E17,#$0E18,#$0E19,#$0E1A,#$0E1B,#$0E1C,#$0E1D,#$0E1E,#$0E1F,
      #$0E20,#$0E21,#$0E22,#$0E23,#$0E24,#$0E25,#$0E26,#$0E27,#$0E28,#$0E29,#$0E2A,#$0E2B,#$0E2C,#$0E2D,#$0E2E,#$0E2F,
      #$0E30,#$0E31,#$0E32,#$0E33,#$0E34,#$0E35,#$0E36,#$0E37,#$0E38,#$0E39,#$0E3A,#$FFFD,#$FFFD,#$FFFD,#$FFFD,#$0E3F,
      #$0E40,#$0E41,#$0E42,#$0E43,#$0E44,#$0E45,#$0E46,#$0E47,#$0E48,#$0E49,#$0E4A,#$0E4B,#$0E4C,#$0E4D,#$0E4E,#$0E4F,
      #$0E50,#$0E51,#$0E52,#$0E53,#$0E54,#$0E55,#$0E56,#$0E57,#$0E58,#$0E59,#$0E5A,#$0E5B,#$FFFD,#$FFFD,#$FFFD,#$FFFD
    );

  Cp875Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$009C,#$0009,#$0086,#$007F,#$0097,#$008D,#$008E,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$009D,#$0085,#$0008,#$0087,#$0018,#$0019,#$0092,#$008F,#$001C,#$001D,#$001E,#$001F,
      #$0080,#$0081,#$0082,#$0083,#$0084,#$000A,#$0017,#$001B,#$0088,#$0089,#$008A,#$008B,#$008C,#$0005,#$0006,#$0007,
      #$0090,#$0091,#$0016,#$0093,#$0094,#$0095,#$0096,#$0004,#$0098,#$0099,#$009A,#$009B,#$0014,#$0015,#$009E,#$001A,
      #$0020,#$0391,#$0392,#$0393,#$0394,#$0395,#$0396,#$0397,#$0398,#$0399,#$005B,#$002E,#$003C,#$0028,#$002B,#$0021,
      #$0026,#$039A,#$039B,#$039C,#$039D,#$039E,#$039F,#$03A0,#$03A1,#$03A3,#$005D,#$0024,#$002A,#$0029,#$003B,#$005E,
      #$002D,#$002F,#$03A4,#$03A5,#$03A6,#$03A7,#$03A8,#$03A9,#$03AA,#$03AB,#$007C,#$002C,#$0025,#$005F,#$003E,#$003F,
      #$00A8,#$0386,#$0388,#$0389,#$00A0,#$038A,#$038C,#$038E,#$038F,#$0060,#$003A,#$0023,#$0040,#$0027,#$003D,#$0022,
      #$0385,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$03B1,#$03B2,#$03B3,#$03B4,#$03B5,#$03B6,
      #$00B0,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,#$0070,#$0071,#$0072,#$03B7,#$03B8,#$03B9,#$03BA,#$03BB,#$03BC,
      #$00B4,#$007E,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$03BD,#$03BE,#$03BF,#$03C0,#$03C1,#$03C3,
      #$00A3,#$03AC,#$03AD,#$03AE,#$03CA,#$03AF,#$03CC,#$03CD,#$03CB,#$03CE,#$03C2,#$03C4,#$03C5,#$03C6,#$03C7,#$03C8,
      #$007B,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$00AD,#$03C9,#$0390,#$03B0,#$2018,#$2015,
      #$007D,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,#$0050,#$0051,#$0052,#$00B1,#$00BD,#$001A,#$0387,#$2019,#$00A6,
      #$005C,#$001A,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$00B2,#$00A7,#$001A,#$001A,#$00AB,#$00AC,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$00B3,#$00A9,#$001A,#$001A,#$00BB,#$009F
    );

  IcelandUni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$00C4,#$00C5,#$00C7,#$00C9,#$00D1,#$00D6,#$00DC,#$00E1,#$00E0,#$00E2,#$00E4,#$00E3,#$00E5,#$00E7,#$00E9,#$00E8,
      #$00EA,#$00EB,#$00ED,#$00EC,#$00EE,#$00EF,#$00F1,#$00F3,#$00F2,#$00F4,#$00F6,#$00F5,#$00FA,#$00F9,#$00FB,#$00FC,
      #$00DD,#$00B0,#$00A2,#$00A3,#$00A7,#$2022,#$00B6,#$00DF,#$00AE,#$00A9,#$2122,#$00B4,#$00A8,#$2260,#$00C6,#$00D8,
      #$221E,#$00B1,#$2264,#$2265,#$00A5,#$00B5,#$2202,#$2211,#$220F,#$03C0,#$222B,#$00AA,#$00BA,#$2126,#$00E6,#$00F8,
      #$00BF,#$00A1,#$00AC,#$221A,#$0192,#$2248,#$2206,#$00AB,#$00BB,#$2026,#$00A0,#$00C0,#$00C3,#$00D5,#$0152,#$0153,
      #$2013,#$2014,#$201C,#$201D,#$2018,#$2019,#$00F7,#$25CA,#$00FF,#$0178,#$2044,#$00A4,#$00D0,#$00F0,#$00DE,#$00FE,
      #$00FD,#$00B7,#$201A,#$201E,#$2030,#$00C2,#$00CA,#$00C1,#$00CB,#$00C8,#$00CD,#$00CE,#$00CF,#$00CC,#$00D3,#$00D4,
      #$FFFD,#$00D2,#$00DA,#$00DB,#$00D9,#$0131,#$02C6,#$02DC,#$00AF,#$02D8,#$02D9,#$02DA,#$00B8,#$02DD,#$02DB,#$02C7
    );

  cpGB2312Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$4E02,#$4E04,#$4E05,#$4E06,#$4E0F,#$4E12,#$4E17,#$4E1F,#$4E20,#$4E21,#$4E23,#$4E26,#$4E29,#$4E2E,#$4E2F,#$4E31,
      #$4E33,#$4E35,#$4E37,#$4E3C,#$4E40,#$4E41,#$4E42,#$4E44,#$4E46,#$4E4A,#$4E51,#$4E55,#$4E57,#$4E5A,#$4E5B,#$4E62,
      #$4E63,#$4E64,#$4E65,#$4E67,#$4E68,#$4E6A,#$4E6B,#$4E6C,#$4E6D,#$4E6E,#$4E6F,#$4E72,#$4E74,#$4E75,#$4E76,#$4E77,
      #$4E78,#$4E79,#$4E7A,#$4E7B,#$4E7C,#$4E7D,#$4E7F,#$4E80,#$4E81,#$4E82,#$4E83,#$4E84,#$4E85,#$4E87,#$4E8A,#$FFFD,
      #$4E90,#$4E96,#$4E97,#$4E99,#$4E9C,#$4E9D,#$4E9E,#$4EA3,#$4EAA,#$4EAF,#$4EB0,#$4EB1,#$4EB4,#$4EB6,#$4EB7,#$4EB8,
      #$4EB9,#$4EBC,#$4EBD,#$4EBE,#$4EC8,#$4ECC,#$4ECF,#$4ED0,#$4ED2,#$4EDA,#$4EDB,#$4EDC,#$4EE0,#$4EE2,#$4EE6,#$4EE7,
      #$4EE9,#$4EED,#$4EEE,#$4EEF,#$4EF1,#$4EF4,#$4EF8,#$4EF9,#$4EFA,#$4EFC,#$4EFE,#$4F00,#$4F02,#$4F03,#$4F04,#$4F05,
      #$4F06,#$4F07,#$4F08,#$4F0B,#$4F0C,#$4F12,#$4F13,#$4F14,#$4F15,#$4F16,#$4F1C,#$4F1D,#$4F21,#$4F23,#$4F28,#$4F29,
      #$4F2C,#$4F2D,#$4F2E,#$4F31,#$4F33,#$4F35,#$4F37,#$4F39,#$4F3B,#$4F3E,#$4F3F,#$4F40,#$4F41,#$4F42,#$4F44,#$4F45,
      #$4F47,#$4F48,#$4F49,#$4F4A,#$4F4B,#$4F4C,#$4F52,#$4F54,#$4F56,#$4F61,#$4F62,#$4F66,#$4F68,#$4F6A,#$4F6B,#$4F6D,
      #$4F6E,#$4F71,#$4F72,#$4F75,#$4F77,#$4F78,#$4F79,#$4F7A,#$4F7D,#$4F80,#$4F81,#$4F82,#$4F85,#$4F86,#$4F87,#$4F8A,
      #$4F8C,#$4F8E,#$4F90,#$4F92,#$4F93,#$4F95,#$4F96,#$4F98,#$4F99,#$4F9A,#$4F9C,#$4F9E,#$4F9F,#$4FA1,#$4FA2,#$FFFD
    );

  ISO8859_15Uni: TArrCharOfWideChar =
    (
      #$0000,#$0001,#$0002,#$0003,#$0004,#$0005,#$0006,#$0007,#$0008,#$0009,#$000A,#$000B,#$000C,#$000D,#$000E,#$000F,
      #$0010,#$0011,#$0012,#$0013,#$0014,#$0015,#$0016,#$0017,#$0018,#$0019,#$001A,#$001B,#$001C,#$001D,#$001E,#$001F,
      #$0020,#$0021,#$0022,#$0023,#$0024,#$0025,#$0026,#$0027,#$0028,#$0029,#$002A,#$002B,#$002C,#$002D,#$002E,#$002F,
      #$0030,#$0031,#$0032,#$0033,#$0034,#$0035,#$0036,#$0037,#$0038,#$0039,#$003A,#$003B,#$003C,#$003D,#$003E,#$003F,
      #$0040,#$0041,#$0042,#$0043,#$0044,#$0045,#$0046,#$0047,#$0048,#$0049,#$004A,#$004B,#$004C,#$004D,#$004E,#$004F,
      #$0050,#$0051,#$0052,#$0053,#$0054,#$0055,#$0056,#$0057,#$0058,#$0059,#$005A,#$005B,#$005C,#$005D,#$005E,#$005F,
      #$0060,#$0061,#$0062,#$0063,#$0064,#$0065,#$0066,#$0067,#$0068,#$0069,#$006A,#$006B,#$006C,#$006D,#$006E,#$006F,
      #$0070,#$0071,#$0072,#$0073,#$0074,#$0075,#$0076,#$0077,#$0078,#$0079,#$007A,#$007B,#$007C,#$007D,#$007E,#$007F,
      #$0080,#$0081,#$0082,#$0083,#$0084,#$0085,#$0086,#$0087,#$0088,#$0089,#$008A,#$008B,#$008C,#$008D,#$008E,#$008F,
      #$0090,#$0091,#$0092,#$0093,#$0094,#$0095,#$0096,#$0097,#$0098,#$0099,#$009A,#$009B,#$009C,#$009D,#$009E,#$009F,
      #$00A0,#$00A1,#$00A2,#$00A3,#$20AC,#$00A5,#$0160,#$00A7,#$0161,#$00A9,#$00AA,#$00AB,#$00AC,#$00AD,#$00AE,#$00AF,
      #$00B0,#$00B1,#$00B2,#$00B3,#$017D,#$00B5,#$00B6,#$00B7,#$017E,#$00B9,#$00BA,#$00BB,#$0152,#$0153,#$0178,#$00BF,
      #$00C0,#$00C1,#$00C2,#$00C3,#$00C4,#$00C5,#$00C6,#$00C7,#$00C8,#$00C9,#$00CA,#$00CB,#$00CC,#$00CD,#$00CE,#$00CF,
      #$00D0,#$00D1,#$00D2,#$00D3,#$00D4,#$00D5,#$00D6,#$00D7,#$00D8,#$00D9,#$00DA,#$00DB,#$00DC,#$00DD,#$00DE,#$00DF,
      #$00E0,#$00E1,#$00E2,#$00E3,#$00E4,#$00E5,#$00E6,#$00E7,#$00E8,#$00E9,#$00EA,#$00EB,#$00EC,#$00ED,#$00EE,#$00EF,
      #$00F0,#$00F1,#$00F2,#$00F3,#$00F4,#$00F5,#$00F6,#$00F7,#$00F8,#$00F9,#$00FA,#$00FB,#$00FC,#$00FD,#$00FE,#$00FF
    );

  QICharsetTypeAliases: array[TQICharsetType] of String =
    (
    // general
      '',                                                                //ctWinDefined
      'iso-8859-1, cp819, Latin1, ibm819, iso_8859-1, ' +
        'iso_8859-1:1987, iso8859-1, iso-ir-100, l1, csISOLatin1',       //ctISO8859_1
      '',                                                                //ctArmscii8
      'us-ascii, ANSI_X3.4-1968, ANSI_X3.4-1986, ascii, cp367, ' +
        'csASCII, IBM367, ISO_646.irv:1991, ISO646-US, iso-ir-6us, ' +
        'iso-ir-6, us',                                                  //ctAscii
      'ibm850, cp850, 850, csPC850Multilingual',                         //ctCp850
      'ibm852, cp852, 852, csPCp852',                                    //ctCp852
      'cp866, ibm866, 866, csIBM866',                                    //ctCp866
      'windows-1250, x-cp1250, CP1250, MS-EE',                           //ctCp1250
      'windows-1251, x-cp1251, CP1251, MS-CYRL',                         //ctCp1251
      'windows-1256, cp1256 , cp1256, MS-ARAB',                          //ctCp1256
      'windows-1257, CP1257, WINBALTRIM',                                //ctCp1257
      '',                                                                //ctDec8
      '',                                                                //ctGeostd8
      'iso-8859-7, csISOLatinGreek, ECMA-118, ELOT_928, greek, ' +
        'greek8, ISO_8859-7, ISO_8859-7:1987, iso-ir-126, iso8859-7',    //ctISO8859_7
      'iso-8859-8, csISOLatinHebrew, hebrew, ISO_8859-8, ' +
        'ISO_8859-8:1988, iso-ir-138, visual, iso8859-8',                //ctISO8859_8
      '',                                                                //ctHp8
      '',                                                                //ctKeybcs2
      'koi8-r, csKOI8R, koi, koi8, koi8r',                               //ctKoi8r
      'koi8-u, koi8-ru',                                                 //ctKoi8u
      'iso-8859-2, csISOLatin2, iso_8859-2, iso_8859-2:1987, ' +
        'iso8859-2, iso-ir-101, l2, latin2',                             //ctISO8859_2
      'iso-8859-9, Latin5, ISO_8859-9, ISO_8859-9:1989, iso-ir-148, ' +
        'l5, iso8859-9',                                                 //ctISO8859_9
      'ISO-8859-13, iso8859-13',                                         //ctISO8859_13
      'x-mac-ce',                                                        //ctMacce
      'x-mac-romanian',                                                  //ctMacroman
      'x-IA5-Swedish',                                                   //ctSwe7
      'utf-8, unicode-1-1-utf-8, unicode-2-0-utf-8, ' +
        'x-unicode-2-0-utf-8, CP65001, UTF8',                            //ctUtf8
      'unicodeFFFE, CP1201, UTF16BE, UCS-2BE, UTF-16BE',                 //ctUtf16BE
      'UTF-32, UTF-32LE, CP12000, UTF32LE, UTF32',                       //ctUtf32
      'unicode, utf-16, CP1200, UTF16LE, UCS-2LE, UTF16, ' +
        'UCS-2, UTF-16LE',                                               //ctUnicode
    // + postrgesql
      'iso-8859-3, Latin3, ISO_8859-3, ISO_8859-3:1988, iso-ir-109, ' +
        'l3, csISOLatin3, iso8859-3',                                    //ctISO8859_3
      'iso-8859-4, csISOLatin4, ISO_8859-4, ISO_8859-4:1988, ' +
        'iso-ir-110, l4, latin4, iso8859-4',                             //ctISO8859_4
      'ISO-8859-10, iso-ir-157, l6, ISO_8859-10:1992, ' +
        'csISOLatin6, latin6',                                           //ctISO8859_10
      'ISO-8859-14, iso-ir-199, ISO_8859-14:1998, ISO_8859-14, ' +
        'latin8, iso-celtic, l8',                                        //ctISO8859_14
      'iso-8859-5, csISOLatin5, csISOLatinCyrillic, cyrillic, ' +
        'ISO_8859-5, ISO_8859-5:1988, iso-ir-144, iso8859-5',            //ctISO8859_5
      'iso-8859-6, arabic, csISOLatinArabic, ECMA-114, ISO_8859-6, ' +
        'ISO_8859-6:1987, iso-ir-127, iso8859-6',                        //ctISO8859_6
    // + db2
      'CP1026, csIBM1026, IBM1026',                                      //ctCp1026
      'windows-1254, CP1254, MS-TURK',                                   //ctCp1254
      'windows-1255, CP1255, MS-HEBR',                                   //ctCp1255
      'windows-1258, CP1258',                                            //ctCp1258
      'IBM437, 437, cp437, csPC8, CodePage437, csPC8CodePage437',        //ctCp437
      'ibm500',                                                          //ctCp500
      'ibm737, CP737',                                                   //ctCp737
      'IBM855, cp855, 855, csIBM855',                                    //ctCp855
      '856, cp856, ibm-856, ibm856',                                     //ctCp856
      'ibm857, cp857, 857, csIBM857',                                    //ctCp857
      'IBM860, cp860, 860, csIBM860',                                    //ctCp860
      'DOS-862, IBM862, cp862, 862, csPC862LatinHebrew',                 //ctCp862
      'IBM863, cp863, 863, csIBM863',                                    //ctCp863
      'IBM864, cp864, csIBM864',                                         //ctCp864
      'IBM865, cp865, 865, csIBM865',                                    //ctCp865
      'ibm869, cp869, 869, cp-gr, csIBM869',                             //ctCp869
      'windows-874, DOS-874, iso-8859-11, TIS-620, CP874',               //ctCp874
      'x-EBCDIC-GreekModern, cp875',                                     //ctCp875
      'x-EBCDIC-Icelandic, IBM871, CP871, ebcdic-cp-is, csIBM871',       //ctIceland
    // + IB/FB
      'big5, cn-big5, csbig5, x-x-big5, CP950, Big5-HKSCS',              //ctBig5
      'ks_c_5601-1987, csKSC56011987, iso-ir-149, korean, ks_c_5601, ' +
        'ks_c_5601_1987, ks_c_5601-1989, KSC_5601, KSC5601, ks-c-5601, ' +
        'ks-c5601, CP949, UHC',                                          //ctKSC5601
      'x-euc, x-euc-jp, CP51932, MS51932, WINDOWS-51932',                //ctEUC
      'gb2312, chinese, CN-GB, csGB2312, csGB231280, csISO58GB231280, ' +
        'GB_2312-80, GB231280, GB2312-80, GBK, iso-ir-58, CP936, ' +
        'MS936, windows-936',                                            //ctGB2312
      'EUC-JP, Extended_UNIX_Code_Packed_Format_for_Japanese, ' +
        'csEUCPkdFmtJapanese',                                           //ctSJIS_0208
      'iso-8859-15, Latin9, ISO_8859-15, l9, Latin-9, iso8859-15',       //ctLatin9
      '',                                                                //ctLatin13
      'iso-8859-15, Latin9, ISO_8859-15, l9, Latin-9, iso8859-15',       //ctISO8859_15
      'Windows-1252, x-ansi, CP1252, MS-ANSI',                           //ctCp1252
      'windows-1253, CP1253, MS-GREEK',                                  //ctCp1253
      'ibm775, CP500, ebcdic-cp-be, ebcdic-cp-ch, csIBM500, cp775, ' +
        'csPC775Baltic',                                                 //ctCp775
      'IBM00858, CCSID00858, CP00858, PC-Multilingual-850+euro, CP858',  //ctCp858
      'shift_jis, csShiftJIS, csWindows31J, ms_Kanji, shift-jis, ' +
        'x-ms-cp932, x-sjis, sjis, CP932, MS932, SHIFFT_JIS, ' +
        'SHIFFT_JIS-MS, SJIS-MS, SJIS-OPEN, SJIS-WIN, WINDOWS-932, ' +
        'Windows-31J',                                                   //ctCp932
      'windows-874, DOS-874, iso-8859-11, TIS-620, CP874',               //ctTIS620
      'gb2312, chinese, CN-GB, csGB2312, csGB231280, csISO58GB231280, ' +
        'GB_2312-80, GB231280, GB2312-80, GBK, iso-ir-58, CP936, ' +
        'MS936, windows-936',                                            //ctGBK
      'GB18030, ISO-4873:1986'                                           //ctGB18030
    );

var
  WideStringToCharsetArray: array[TQICharsetType] of TBytes;

function QICodePageToCharset(Value: Integer): TQICharsetType;
var
  CurrentCharset: TQICharsetType;
begin
  Result := ctWinDefined;
  for CurrentCharset := Low(TQICharsetType) to High(TQICharsetType) do
    if SystemCTNames[CurrentCharset] = Value then
    begin
      Result := CurrentCharset;
      Break;
    end;
end;

function GetWindowsCharset: TQICharsetType;
begin
  Result := QICodePageToCharset(GetACP);
end;

function GetCharsetTable(Charset: TQICharsetType): PArrCharOfWideChar;
begin
  if Charset = ctWinDefined then
    Charset := GetWindowsCharset;
  case Charset of
    ctKoi8r     : Result := @Koi8rUni;
    ctKoi8u     : Result := @Koi8uUni;
    ctArmscii8  : Result := @armscii8Uni;
    ctAscii     : Result := @asciiUni;
    ctCp850     : Result := @cp850Uni;
    ctCp852     : Result := @cp852Uni;
    ctCp866     : Result := @cp866Uni;
    ctCp1250    : Result := @cp1250Uni;
    ctCp1251    : Result := @cp1251Uni;
    ctCp1256    : Result := @cp1256Uni;
    ctCp1257    : Result := @cp1257Uni;
    ctDec8      : Result := @Dec8Uni;
    ctGeostd8   : Result := @geostd8Uni;
    ctISO8859_7 : Result := @ISO8859_7Uni;
    ctISO8859_8 : Result := @ISO8859_8Uni;
    ctHp8       : Result := @hp8Uni;
    ctKeybcs2   : Result := @keybcs2Uni;
    ctISO8859_1 : Result := @ISO8859_1Uni;
    ctISO8859_2 : Result := @ISO8859_2Uni;
    ctISO8859_9 : Result := @ISO8859_9Uni;
    ctISO8859_13: Result := @ISO8859_13Uni;
    ctMacce     : Result := @macceUni;
    ctMacroman  : Result := @macromanUni;
    ctSwe7      : Result := @swe7Uni;
    ctISO8859_3 : Result := @ISO8859_3Uni;
    ctISO8859_4 : Result := @ISO8859_4Uni;
    ctISO8859_10: Result := @ISO8859_10Uni;
    ctISO8859_14: Result := @ISO8859_14Uni;
    ctISO8859_5 : Result := @ISO8859_5Uni;
    ctISO8859_6 : Result := @ISO8859_6Uni;

    //unique for DB2
    ctCp1026    : Result := @Cp1026Uni;
    ctCp1254    : Result := @Cp1254Uni;
    ctCp1255    : Result := @Cp1255Uni;
    ctCp1258    : Result := @Cp1258Uni;
    ctCp437     : Result := @Cp437Uni;
    ctCp500     : Result := @Cp500Uni;
    ctCp737     : Result := @Cp737Uni;
    ctCp855     : Result := @Cp855Uni;
    ctCp856     : Result := @Cp856Uni;
    ctCp857     : Result := @Cp857Uni;
    ctCp860     : Result := @Cp860Uni;
    ctCp862     : Result := @Cp862Uni;
    ctCp863     : Result := @Cp863Uni;
    ctCp864     : Result := @Cp864Uni;
    ctCp865     : Result := @Cp865Uni;
    ctCp869     : Result := @Cp869Uni;
    ctCp874, ctTIS620:           //dvs>> for a while
      Result := @Cp874Uni;
    ctCp875     : Result := @Cp875Uni;
    ctIceland   : Result := @IcelandUni;

    //unique for IB/FB
    ctLatin9    : Result := @cpLatin9Uni;
    ctLatin13   : Result := @cpLatin13Uni;
    ctISO8859_15: Result := @ISO8859_15Uni;
    ctCp1252    : Result := @cp1252Uni;
    ctCp1253    : Result := @cp1253Uni;
    ctCp775     : Result := @cp775Uni;
    ctCp858     : Result := @cp858Uni;
    ctGB2312, ctGBK, ctGB18030:                //dvs>> for a while
      Result := @cpGB2312Uni;
    ctBig5, ctKSC5601, ctEUC, ctSJIS_0208: Result := @SimpleUni;
  else
    Result := nil;
  end;
  if Result = nil then
    raise Exception.Create('Code page is not defined');
end;

procedure FillCharsetTypeList(List: TqiStrings);
var
  I: TQICharsetType;
begin
  List.Clear;
  for I := Low(TQICharsetType) to High(TQICharsetType) do
    if QICharsetTypeNames[I] <> '' then
      List.AddObject(QICharsetTypeNames[I], TObject(I));
  if List.InheritsFrom(TqiStringList) then
    TqiStringList(List).Sort;
end;

function IsUnicodeQICharset(Charset: TQICharsetType): Boolean;
begin
  Result := Charset in [ctUtf8, ctUtf16BE, ctUtf32, ctUnicode];
end;

function QICharsetToCodepage(const Value: TQICharsetType): Integer;
begin
  if Value = ctWinDefined then
    Result := GetACP
  else
    Result := SystemCtNames[Value];
end;

function QIAliasToCharsetType(const Alias: qiString): TQICharsetType;
var
  List: TqiStrings;
  I: TQICharsetType;
begin
  Result := ctWinDefined;
  List := TqiStringList.Create;
  try
    for I := Low(TQIcharsetType) to High(TQIcharsetType) do
    begin
      if QICharsetTypeAliases[I] = '' then
        Continue;
      List.CommaText := QICharsetTypeAliases[I];
      if List.IndexOf(Alias) < 0 then
        Continue;
      Result := I;
      Break;
    end;
  finally
    List.Free;
  end;          
end;

function CharsetToWideString(const Buffer; Count: Longint; const Charset: TQICharsetType): WideString;
var
  MemStream: TMemoryStream;
  Stream: TQIStreamIterator;
begin
  MemStream := TMemoryStream.Create;
  MemStream.Write(Buffer, Count);
  MemStream.Position := 0;
  Stream := TQIStreamIterator.Create(MemStream, Charset);
  try
    Stream.ReadString(Count, Result);
  finally
    Stream.Free;
    MemStream.Free;
  end;
end;

function DetectCharset(Stream: TStream; DiscoverCharset: Boolean; out Charset: TQICharsetType): Boolean;
var
  savedPos: Int64;
  Detector: TQICharsetAutoDetector;
begin
  if not Assigned(Stream) then
  begin
    Result := False;
    Exit;
  end;
  savedPos := Stream.Position;
  Detector := TQICharsetAutoDetector.Create;
  try
    Result := Detector.Detect(Stream, Charset, not DiscoverCharset);
  finally
    FreeAndNil(Detector);
    Stream.Position := savedPos;
  end;
end;

procedure SkipBOM(Stream: TStream; Charset: TQICharsetType);
var
  savedPos: Int64;
  LCharset: TQICharsetType;
  Detector: TQICharsetAutoDetector;
begin
  if not Assigned(Stream) then
    Exit;
  savedPos := Stream.Position;
  Detector := TQICharsetAutoDetector.Create;
  try
    if Detector.DetectBOM(Stream, LCharset) and (LCharset <> Charset) then
      Stream.Position := savedPos;
  finally
    FreeAndNil(Detector);
  end;
end;

function IsBlankText(const Text: WideString): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(Text) do
  if not TQICharacter.IsBlankChar(Text[I]) then
  begin
    Result := False;
    Break;
  end;
end;

function IsNumberText(const Text: WideString): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(Text) do
  if not QImport3Common.CharInSet(Text[I], ['0'..'9', '-', '+', '.']) then
  begin
    Result := False;
    Break;
  end;
end;

procedure QIRaiseLastOSError;
var
  Error: Cardinal;
begin
  Error := GetLastError;
  if Error = ERROR_NO_UNICODE_TRANSLATION then
    raise EQICharsetEncodingError.Create('No mapping for the Unicode character exists')
  else if Error = ERROR_INVALID_PARAMETER then
    raise EQIConversionError.Create('The parameter values are invalid.')
  else if Error = ERROR_INVALID_FLAGS then
    raise EQIConversionError.Create('The values supplied for flags are invalid.')
  else if Error = ERROR_INSUFFICIENT_BUFFER then
    raise EQIConversionError.Create('The supplied buffer size is not large enough.')
  { TODO -ogmv -cencoding :check}
//  else if Error <> 0 then
//    RaiseLastOSError(Error);
end;

{ TQIEncoding }

class function TQIEncoding.GetBOM: TBytes;
begin
  SetLength(Result, 0);
end;

class function TQIEncoding.GetEncoding(CodePage: Integer): TQIEncoding;
var
  MBToWCharFlags: Cardinal;
  WCharToMBFlags: Cardinal;
begin
  case CodePage of
    1200   : Result := TQIUnicodeEncoding.Create;
    1201   : Result := TQIBigEndianUnicodeEncoding.Create;
    12000  : Result := TQIUTF32Encoding.Create;
    12001  : Result := TQIBigEndianUTF32Encoding.Create;
    CP_UTF8: Result := TQIUTF8Encoding.Create;
    else
    begin
      case CodePage of
        50220..50222,
        50225,
        50227,
        50229,
        52936,
        54936,
        57002..57011,
        CP_UTF7,
        42:
          MBToWCharFlags := 0;
        else
          MBToWCharFlags := MB_ERR_INVALID_CHARS;
      end;
      if (CodePage = CP_UTF8) or (CodePage = 54936) then
        WCharToMBFlags := WC_ERR_INVALID_CHARS
      else
        WCharToMBFlags := 0;
      Result := TQIMBCSEncoding.Create(CodePage, MBToWCharFlags, WCharToMBFlags);
    end;
  end;
end;

class function TQIEncoding.GetEncoding(const Charset: TQICharsetType): TQIEncoding;
var
  LCodePage: Integer;
begin
  LCodePage := QICharsetToCodepage(Charset);
  if (LCodePage > 0) and (IsValidCodePage(LCodePage) or (Charset in [ctUnicode, ctUtf16BE, ctUtf32])) then
    Result := GetEncoding(LCodePage)
  else
    Result := TQITableEncoding.Create(Charset);
end;

function TQIEncoding.GetRightTrimSize(Buffer: PByte; BufferLen: Integer): Integer;
begin
  Result := 0;
end;

function TQIEncoding.GetBytes(const S: WideString): TBytes;
var
  Len: Integer;
begin
{ TODO -ogmv -cencoding :check errors}

  Len := GetByteCount(PWideChar(S), Length(S));
  SetLength(Result, Len);
  GetBytes(PWideChar(S), Length(S), @Result[0], Len);
end;

function TQIEncoding.GetString(const Bytes: TBytes; ByteIndex, ByteCount: Integer): WideString;
var
  Len: Integer;
begin
{ TODO -ogmv -cencoding :check errors}

//  if (Length(Bytes) = 0) and (ByteCount <> 0) then
//    raise EEncodingError.CreateRes(@SInvalidSourceArray);
//  if ByteIndex < 0 then
//    raise EEncodingError.CreateResFmt(@SByteIndexOutOfBounds, [ByteIndex]);
//  if ByteCount < 0 then
//    raise EEncodingError.CreateResFmt(@SInvalidCharCount, [ByteCount]);
//  if (Length(Bytes) - ByteIndex) < ByteCount then
//    raise EEncodingError.CreateResFmt(@SInvalidCharCount, [ByteCount]);

  Len := GetCharCount(@Bytes[ByteIndex], ByteCount);
//  if (ByteCount > 0) and (Len = 0) then
//    raise EEncodingError.CreateRes(@SNoMappingForUnicodeCharacter);
  SetLength(Result, Len);
  GetChars(@Bytes[ByteIndex], ByteCount, PWideChar(Result), Len);
end;

{ TQIMBCSEncoding }

constructor TQIMBCSEncoding.Create;
begin
  Create(GetACP, 0, 0);
end;

constructor TQIMBCSEncoding.Create(CodePage: Integer);
begin
  FCodePage := CodePage;
  Create(CodePage, 0, 0);
end;

constructor TQIMBCSEncoding.Create(CodePage, MBToWCharFlags, WCharToMBFlags: Integer);
var
  LCPInfo: TCPInfo;
begin
  if CodePage = CP_ACP then
    FCodePage := GetACP
  else
    FCodePage := CodePage;
  FMBToWCharFlags := MBToWCharFlags;
  FWCharToMBFlags := WCharToMBFlags;

  if not GetCPInfo(FCodePage, LCPInfo) then
    raise Exception.Create('Invalid code page.');
  FMaxCharSize := LCPInfo.MaxCharSize;
  FIsSingleByte := FMaxCharSize = 1;
end;

function TQIMBCSEncoding.GetByteCount(Chars: PWideChar; CharCount: Integer): Integer;
begin
  Result := WideCharToMultiByte(FCodePage, FWCharToMBFlags, PWideChar(Chars), CharCount, nil, 0, nil, nil);
end;

function TQIMBCSEncoding.GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer;
begin
  Result := WideCharToMultiByte(FCodePage, FWCharToMBFlags, PWideChar(Chars), CharCount, PAnsiChar(Bytes), ByteCount, nil, nil);
end;

function TQIMBCSEncoding.GetCharCount(Bytes: PByte; ByteCount: Integer): Integer;
begin
  Result := MultiByteToWideChar(FCodePage, FMBToWCharFlags, PAnsiChar(Bytes), ByteCount, nil, 0);
end;

function TQIMBCSEncoding.GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer;
begin
  Result := MultiByteToWideChar(FCodePage, FMBToWCharFlags, PAnsiChar(Bytes), ByteCount, Chars, CharCount);
end;

function TQIMBCSEncoding.GetRightTrimSize(Buffer: PByte; BufferLen: Integer): Integer;

  function IsLeadByte(CurrByte: PByte): Boolean;
  begin
    case FCodePage of
      932://Shift-JIS
        Result := ((CurrByte^ >= $81) and (CurrByte^ <= $9F)) or ((CurrByte^ >= $E0) and (CurrByte^ <= $FC));
      936,//gbk
      949,//ksc5601
      950://big5
        Result := (CurrByte^ >= $81) and (CurrByte^ <= $FE);
      20932://sjis-0208
        Result := ((CurrByte^ >= $21) and (CurrByte^ <= $7E)) or ((CurrByte^ >= $A1) and (CurrByte^ <= $FE));
      20936://gb2312
        Result := (CurrByte^ >= $A1) and (CurrByte^ <= $FE);
      54936://gb18030
        Result := ((CurrByte^ >= $30) and (CurrByte^ <= $39)) or ((CurrByte^ >= $81) and (CurrByte^ <= $FE));
      else
        Result := False;
    end;
  end;

  // Detect if an incoming byte is the second unit byte (gb18030)
  function IsSecondUnitByte(CurrByte: PByte): Boolean;
  begin
    Result := False;
    if FCodePage = 54936 then
      Result := (CurrByte^ >= $30) and (CurrByte^ <= $39);
  end;

  // Detect if an incoming byte can stay together with the existing byte (sjis-0208)
  function IsFriendByte(CurrByte: PByte; ExistByte: Byte): Boolean;
  begin
    Result := True;
    if FCodePage = 20932 then
      Result := ((ExistByte >= $21) and (ExistByte <= $7E)) and ((CurrByte^ >= $21) and (CurrByte^ <= $7E)) or
                ((ExistByte >= $A1) and (ExistByte <= $FE)) and ((CurrByte^ >= $A1) and (CurrByte^ <= $FE));
  end;

  function CalculateTrimByteSize(LeadByteCounter, SecondByteCounter: Integer): Integer;
  begin
    Result := 0;
    if (LeadByteCounter mod 2 > 0) and (SecondByteCounter mod 2 > 0) then
      Result := 3
    else if (LeadByteCounter mod 2 = 0) and (SecondByteCounter mod 2 > 0) then
      Result := 2
    else if (LeadByteCounter mod 2 > 0) and (SecondByteCounter mod 2 = 0) then
      Result := 1;
  end;

var
  CurrBytePtr: PByte;
  StoredByte: Byte;
  LeadByteCounter,
  SecondByteCounter,
  PairByteCounter: Integer;
begin
{$IFDEF VER6}
  B := Buffer + BufferLen - 1;
{$ELSE}
  CurrBytePtr := Pointer(Integer(Buffer) + BufferLen - 1);
{$ENDIF}
  StoredByte := 0;
  LeadByteCounter := 0;
  SecondByteCounter := 0;
  PairByteCounter := 0;
{$IFDEF VER6}
  while CurrBytePtr >= Buffer do
{$ELSE}
  while Cardinal(CurrBytePtr) >= Cardinal(Buffer) do
{$ENDIF}
  begin
    if not IsLeadByte(CurrBytePtr) then
      Break
    else begin
      if IsSecondUnitByte(CurrBytePtr) then
        Inc(SecondByteCounter);

      if PairByteCounter > 0 then
      begin
        if IsFriendByte(CurrBytePtr, StoredByte) then
          Inc(LeadByteCounter);
        PairByteCounter := 0;
      end
      else begin
        StoredByte := CurrBytePtr^;
        Inc(PairByteCounter);
        Inc(LeadByteCounter);
      end;
    end;
    Dec(CurrBytePtr);
  end;
  Result := CalculateTrimByteSize(LeadByteCounter, SecondByteCounter);
end;

{ TQIUTF8Encoding }

class function TQIUTF8Encoding.GetBOM: TBytes;
const
  _UTF8BOM: array[0..2] of Byte = ($EF, $BB, $BF);
begin
  SetLength(Result, Length(_UTF8BOM));
  Move(_UTF8BOM[0], Result[0], Length(_UTF8BOM));
end;

// return count of bytes of incomplete UTF-8 character at the end of buffer
function TQIUTF8Encoding.GetRightTrimSize(Buffer: PByte; BufferLen: Integer): Integer;
var
  b: PByte;
  i, n: Integer;
begin
{$IFDEF VER6}
  b := Buffer + BufferLen - 1;
{$ELSE}
  b := Pointer(Integer(Buffer) + BufferLen - 1);
{$ENDIF}
  if b^ and $80 = 0 then
  begin
    Result := 0;
    Exit;
  end;
  n := Min(6, BufferLen);
  for i := 1 to n do
  begin
    // check leading byte 11110xxx
    if b^ and $F8 = $F0 then
    begin
      if i = 4 then Result := 0 else Result := i;
      Exit;
    end;
    // check leading byte 1110xxxx
    if b^ and $F0 = $E0 then
    begin
      if i = 3 then Result := 0 else Result := i;
      Exit;
    end;
    // check leading byte 110xxxxx
    if b^ and $E0 = $C0 then
    begin
      if i = 2 then Result := 0 else Result := i;
      Exit;
    end;
    Dec(b);
  end;
  Result := 0;
end;

constructor TQIUTF8Encoding.Create;
begin
  inherited Create(CP_UTF8, MB_ERR_INVALID_CHARS, 0);
  FIsSingleByte := False;
  FMaxCharSize := 4;
end;

{ TQITableEncoding }

constructor TQITableEncoding.Create(const Charset: TQICharsetType);
begin
  FCharset := Charset;
  FIsSingleByte := True;
  FMaxCharSize := 1;
end;

function TQITableEncoding.GetByteCount(Chars: PWideChar; CharCount: Integer): Integer;
begin
  Result := CharCount;
end;

function TQITableEncoding.GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer;
var
  I: Integer;
  J: Byte;
  Table: PArrCharOfWideChar;
  CA: PBytes;
begin
  CA := @WideStringToCharsetArray[FCharset];
  if Length(CA^) = 0 then
  begin
    Table := GetCharsetTable(FCharset);
    SetLength(CA^, High(Word) + 1);
    FillChar(CA^[0], High(Word) + 1, Byte(ErrorSymbol));
    for J := Low(Byte) to High(Byte) do
      if (J = 0) or ((Table[J] <> #0) and (Table[J] <> #$FFFD)) then
        CA^[Ord(Table[J])] := J;
  end;
  for I := 0 to CharCount - 1 do
  begin
    Bytes^ := CA^[Ord(Chars^)];
    Inc(Bytes);
    Inc(Chars);
  end;
  Result := CharCount;
end;

function TQITableEncoding.GetCharCount(Bytes: PByte; ByteCount: Integer): Integer;
begin
  Result := ByteCount;
end;

function TQITableEncoding.GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer;
var
  WC: WideChar;
  I: Integer;
  Table: PArrCharOfWideChar;
begin
  Table := GetCharsetTable(FCharset);
  for I := 0 to CharCount - 1 do
  begin
    WC := Table[Bytes^];
    if (WC <> #$FFFD) and (WC <> #0) or (Bytes^ = 0) then
      Chars^ := WC
    else
      Chars^ := ErrorSymbol;
    Inc(Bytes);
    Inc(Chars);
  end;
  Result := CharCount;
end;

{ TQIUnicodeEncoding }

constructor TQIUnicodeEncoding.Create;
begin
  FIsSingleByte := False;
  FMaxCharSize := 2;
end;

class function TQIUnicodeEncoding.GetBOM: TBytes;
const
  _UnicodeBOM: array[0..1] of Byte = ($FF, $FE);
begin
  SetLength(Result, Length(_UnicodeBOM));
  Move(_UnicodeBOM[0], Result[0], Length(_UnicodeBOM));
end;

function TQIUnicodeEncoding.GetByteCount(Chars: PWideChar; CharCount: Integer): Integer;
begin
  Result := CharCount * SizeOf(WideChar);
end;

function TQIUnicodeEncoding.GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer;
begin
  Result := CharCount * SizeOf(WideChar);
  Move(Chars^, Bytes^, Result);
end;

function TQIUnicodeEncoding.GetCharCount(Bytes: PByte; ByteCount: Integer): Integer;
begin
  Result := ByteCount div SizeOf(WideChar);
end;

function TQIUnicodeEncoding.GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer;
begin
  Result := CharCount;
  Move(Bytes^, Chars^, CharCount * SizeOf(WideChar));
end;

{ TQIBigEndianUnicodeEncoding }

class function TQIBigEndianUnicodeEncoding.GetBOM: TBytes;
const
  _BigEndianUnicodeBOM: array[0..1] of Byte = ($FE, $FF);
begin
  SetLength(Result, Length(_BigEndianUnicodeBOM));
  Move(_BigEndianUnicodeBOM[0], Result[0], Length(_BigEndianUnicodeBOM));
end;

function TQIBigEndianUnicodeEncoding.GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to CharCount - 1 do
  begin
    Bytes^ := Hi(Word(Chars^));
    Inc(Bytes);
    Bytes^ := Lo(Word(Chars^));
    Inc(Bytes);
    Inc(Chars);
  end;
  Result := CharCount * SizeOf(WideChar);
end;

function TQIBigEndianUnicodeEncoding.GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer;
var
  P: PByte;
  I: Integer;
begin
  P := Bytes;
  Inc(P);
  for I := 0 to CharCount - 1 do
  begin
    Chars^ := WideChar(MakeWord(P^, Bytes^));
    Inc(Bytes, 2);
    Inc(P, 2);
    Inc(Chars);
  end;
  Result := CharCount;
end;

{ EQICharsetEncodingError }

constructor EQICharsetEncodingError.Create(const Msg: string);
begin
  Message := 'Can''t convert symbol ' + Msg;
end;

{ TQICharsetAutoDetector }

constructor TQICharsetAutoDetector.Create;
begin
  FBOMDetected := False;
end;

function TQICharsetAutoDetector.Detect(Stream: TStream; var Charset: TQICharsetType; BOMOnly: Boolean = False): Boolean;
var
  CurrentCharset: TQICharsetType;
  Charsets: set of TQICharsetType;

  function Detect(All: Boolean): Boolean;
  var
    I: TQICharsetType;
    ByteBufferLen: Integer;
    ByteBuffer: TBytes;
  begin
    Stream.Position := 0;
    Result := True;
    SetLength(ByteBuffer, MAX_BUFFER_SIZE);
    while (Stream.Position < Stream.Size) and (Charsets <> []) do
    begin
      ByteBufferLen := Stream.Read(ByteBuffer[0], MAX_BUFFER_SIZE);
      if ByteBufferLen = 0 then
        Break;
      if All then
      begin
        for I := Low(TQICharsetType) to High(TQICharsetType) do
          if I in Charsets then
          begin
            try
              CurrentCharset := I;
              CharsetToWideString(ByteBuffer[0], ByteBufferLen, CurrentCharset);
            except
              Exclude(Charsets, CurrentCharset);
            end;
          end;
      end
      else
      begin
        try
          CharsetToWideString(ByteBuffer[0], ByteBufferLen, CurrentCharset);
        except
          Exclude(Charsets, CurrentCharset);
          Result := False;
          Exit;
        end;
      end;
      if Stream.Position > MAX_DETECT_SIZE then
        Break;
    end;
  end;

begin
  Result := False;
  if not Assigned(Stream) then Exit;
  if Stream.Size = 0 then
  begin
    Result := True;
    Charset := ctUtf8;
    Exit;
  end;
  Charset := ctWinDefined;
  FBOMDetected := DetectBOM(Stream, Charset); // check for BOM
  Result := Charset <> ctWinDefined;
  if Result or BOMOnly then
    Exit;
  if IsUtf8(Stream) then // check for utf8 without BOM
  begin
    Result := True;
    Charset := ctUtf8;
  end
  else
  begin
    Charsets := [Low(TQICharsetType)..High(TQICharsetType)];
    Exclude(Charsets, ctWinDefined);
    Exclude(Charsets, ctUtf8);
    Exclude(Charsets, ctUtf16BE);
    Exclude(Charsets, ctUnicode);
    CurrentCharset := GetWindowsCharset; // check system charset
    if CurrentCharset <> ctWinDefined then
    begin
      if Detect(False) then
      begin
        Result := True;
        Charset := CurrentCharset;
      end
      else
        if Charset <> ctWinDefined then
        begin
          CurrentCharset := Charset; // check charset variable
          if Detect(False) then
            Result := True
          else
          begin
            Detect(True); // check other charset
            Result := Charsets <> [];
            Charset := ctWinDefined;
            if Result then
              for CurrentCharset := Low(TQICharsetType) to High(TQICharsetType) do
                if CurrentCharset in Charsets then
                begin
                  Charset := CurrentCharset;
                  Break;
                end;
          end;
        end;
    end;
  end;
  Stream.Position := 0;
end;

function TQICharsetAutoDetector.DetectBOM(Stream: TStream; var Charset: TQICharsetType): Boolean;
var
  I, Pos, Cnt: Integer;
  Tmp: TBytes;
begin
  Result := False;
  if not Assigned(Stream) then
    Exit;
  Pos := Stream.Position;
  Stream.Position := 0;
  Cnt := 0;
  try
    SetLength(Tmp, 4);
    I := Stream.Read(Tmp[0], 2);
    Inc(Cnt, I);
    if (I < 2) then
      Exit;
    if IsContainBOM(Tmp, TQIUnicodeEncoding.GetBOM) then
    begin
      I := Stream.Read(Tmp[2], 2);
      Inc(Cnt, I);
      if IsContainBOM(Tmp, TQIUTF32Encoding.GetBOM) then
        Charset := ctUtf32
      else
      begin
        Dec(Cnt, I);
        Charset := ctUnicode;
      end;
    end
    else
      if IsContainBOM(Tmp, TQIBigEndianUnicodeEncoding.GetBOM) then
        Charset := ctUtf16BE
      else
      begin
        I := Stream.Read(Tmp[2], 1);
        Inc(Cnt, I);
        if IsContainBOM(Tmp, TQIUTF8Encoding.GetBOM) then
          Charset := ctUtf8
        else
          Exit;
      end;
    Result := True;
  finally
    if not Result then                // stream position should be incremented if BOM
      Stream.Position := Pos          // else it should be restored
    else if Stream.Position > Cnt then
      Stream.Position := Cnt;
  end;          
end;

function TQICharsetAutoDetector.IsContainBOM(const Buffer, BOM: TBytes): Boolean;
var
  i: Integer;
begin
  if Length(Buffer) >= Length(BOM) then
  begin
    for i := 0 to Length(BOM) - 1 do
      if Buffer[i] <> BOM[i] then
      begin
        Result := False;
        Exit;
      end;
    Result := True;
  end
  else
    Result := False;
end;

function TQICharsetAutoDetector.IsUTF8(Stream: TStream): Boolean;
var
  ByteBufferLen: Integer;
  n: Integer;
  ByteBuffer: TBytes;
  encoding: TQIEncoding;
  str: WideString;
begin
  Stream.Position := 0;
  Result := True;
  SetLength(ByteBuffer, MAX_BUFFER_SIZE);
  encoding := TQIUTF8Encoding.Create;
  try
    while (Stream.Position < Stream.Size) do
    begin
      ByteBufferLen := Stream.Read(ByteBuffer[0], MAX_BUFFER_SIZE);
      if ByteBufferLen = 0 then
        Break;
      // check last UTF-8 character in buffer
      n := encoding.GetRightTrimSize(@ByteBuffer[0], ByteBufferLen);
      if n > 0 then
      begin
        ByteBufferLen := ByteBufferLen - n;
        Stream.Position := Stream.Position - n;
      end;
      str := encoding.GetString(ByteBuffer, 0, ByteBufferLen);
      Result := Length(str) > 0;
      if not Result then
        Break;
      if Result and (Stream.Position > MAX_DETECT_SIZE) then
        Break;
    end;
  finally
    FreeAndNil(encoding);
  end;
end;

{ TQIStreamIterator }

constructor TQIStreamIterator.Create(Source: TStream);
begin
  FInternalUnicodeStream := True;
  Create(TEncodedReadStream.Create(Source), MAX_BUFFER_SIZE);
end;

constructor TQIStreamIterator.Create(Source: TStream; Charset: TQICharsetType);
begin
  FInternalUnicodeStream := True;
  Create(TEncodedReadStream.Create(Source, Charset), MAX_BUFFER_SIZE);
end;

constructor TQIStreamIterator.Create(Source: TStream; Charset: TQICharsetType; BufferSize: Cardinal);
begin
  FInternalUnicodeStream := True;
  Create(TEncodedReadStream.Create(Source, Charset), BufferSize);
end;

constructor TQIStreamIterator.Create(const FileName: string);
begin
  FInternalUnicodeStream := True;
  Create(TEncodedReadStream.Create(FileName), MAX_BUFFER_SIZE);
end;

constructor TQIStreamIterator.Create(const FileName: string; Charset: TQICharsetType);
begin
  FInternalUnicodeStream := True;
  Create(TEncodedReadStream.Create(FileName, Charset), MAX_BUFFER_SIZE);
end;

constructor TQIStreamIterator.Create(const FileName: string; Charset: TQICharsetType; BufferSize: Cardinal);
begin
  FInternalUnicodeStream := True;
  Create(TEncodedReadStream.Create(FileName, Charset), BufferSize);
end;

constructor TQIStreamIterator.Create(UnicodeStream: TEncodedReadStream; BufferSize: Cardinal);
begin
  inherited Create;
  FUnicodeStream := UnicodeStream;
  SetLength(FBuffer, BufferSize);
  FBuffLen := 0;
end;

destructor TQIStreamIterator.Destroy;
begin
  if FInternalUnicodeStream then
    FreeAndNil(FUnicodeStream);
  inherited;
end;

function TQIStreamIterator.DoGetCurrent: WideChar;
begin
  Result := FBuffer[FIndex];
end;

procedure TQIStreamIterator.FillBuffer;
begin
  FBuffLen := FUnicodeStream.Read(FBuffer[0], Length(FBuffer) * SizeOf(WideChar)) div SizeOf(WideChar);
end;

function TQIStreamIterator.GetEOF: Boolean;
begin
  Result := (inherited GetEOF) and FUnicodeStream.GetEof;
end;

function TQIStreamIterator.DoMoveNext: Boolean;
begin
  Result := inherited DoMoveNext;
  if not Result then
    FIndex := 0;
  if FIndex = 0 then
  begin
    FillBuffer;
    Result := FBuffLen > FIndex;
  end;
end;

{ TQICharacter }

class function TQICharacter.GetCharType(const C: WideChar): TQICharType;
begin
  case C of
    #$0009,
    #$0020,
    #$005C,
    #$0023..#$0025,
    #$0030..#$0039,
    #$003B,
    #$0041..#$005A,
    #$005E..#$00FF,
    #$0100..#$FFFD: Result := xctChar;
    '<' : Result := xctLower;
    '>' : Result := xctGreater;
    #$0A: Result := xctLF;
    #$0D: Result := xctCR;
    '''': Result := xctSglQuote;
    '"' : Result := xctDblQuote;
    '&' : Result := xctAmpersand;
    '[' : Result := xctSqBracketLeft;
    ']' : Result := xctSqBracketRight;
    '?' : Result := xctQuery;
    '/' : Result := xctSlash;
    '!' : Result := xctXclam;
    '(' : Result := xctParensLeft;
    ')' : Result := xctParensRight;
    '*' : Result := xctAsterisk;
    '+' : Result := xctPlus;
    ',' : Result := xctComma;
    '-' : Result := xctMinus;
    '.' : Result := xctDot;
    ':' : Result := xctColon;
    '=' : Result := xctEqual;
    '@' : Result := xctAt;
  else
    Result := xctUnknown;
  end;
end;

class function TQICharacter.IsBlankChar(const C: WideChar): Boolean;
begin
  Result := QImport3Common.CharInSet(C, [#10, #9, #13, #32]);
end;

class function TQICharacter.IsDecChar(const C: WideChar): Boolean;
begin
  Result := QImport3Common.CharInSet(C, ['0'..'9']);
end;

class function TQICharacter.IsHexChar(const C: WideChar): Boolean;
begin
  Result := IsDecChar(C);
  if not Result then
    Result := QImport3Common.CharInSet(C, ['a'..'f', 'A'..'F']);
end;

class function TQICharacter.IsNumChar(const C: WideChar): Boolean;
begin
  Result := IsDecChar(C) or QImport3Common.CharInSet(C, ['-', '+', '.']);
end;

class function TQICharacter.IsFirstIdentChar(const C: WideChar): Boolean;
begin
  Result := QImport3Common.CharInSet(C, ['A'..'Z', 'a'..'z', ':', '_', #$C0..#$D6, #$D8..#$F6, #$F8..#$FF]);
  if not Result then
    case C of
      #$100..#$2FF, #$370..#$37D,
      #$37F..#$1FFF, #$200C..#$200D,
      #$2070..#$218F, #$2C00..#$2FEF,
      #$3001..#$D7FF, #$F900..#$FDCF,
      #$FDF0..#$FFFD: Result := True;
    end;
end;

class function TQICharacter.IsIdentChar(const C: WideChar): Boolean;
begin
  Result := IsFirstIdentChar(C);
  if not Result then
    Result := IsDecChar(C);
  if not Result then
  begin
    Result := QImport3Common.CharInSet(C, ['-', '.', #$B7]);
    if not Result then
      case C of
        #$0300..#$036F,
        #$203F..#$2040: Result := True;
      end;
  end;
end;

{ TQIIterator }

constructor TQIIterator.Create;
begin
  Reset;
end;

function TQIIterator.DoMoveNext: Boolean;
begin
  if FIndex >= 0 then
    FPrevious := Current;
  Inc(FIndex);
  Result := FIndex < FBuffLen;
end;

function TQIIterator.GetCurrent: WideChar;
begin
  if FIndex < 0 then
    Result := #0
  else if FUndo then
    Result := FPrevious
  else
    Result := DoGetCurrent;
end;

function TQIIterator.GetCurrentType: TQICharType;
begin
  Result := TQICharacter.GetCharType(Current);
end;

function TQIIterator.GetEOF: Boolean;
begin
  Result := (FIndex >= FBuffLen);
end;

function TQIIterator.MoveNext: Boolean;
begin
  Result := not GetEOF;
  if FUndo then
    FUndo := False
  else if Result then
    Result := DoMoveNext;
end;

function TQIIterator.ReadString(Count: Integer; out Buffer: WideString): LongInt;
begin
  Result := 0;
  if Count = 0 then
    Exit;
  SetLength(Buffer, Count);
  while MoveNext do
  begin
    Inc(Result);
    Buffer[Result] := Current;
    if Result = Count then
      Break;
  end;
  if Result <> Count then
    SetLength(Buffer, Result);
end;

procedure TQIIterator.Reset;
begin
  FIndex := -1;
  FPrevious := #0;
  FUndo := False;
end;

function TQIIterator.Rollback: Boolean;
begin
  Result := not FUndo and (FIndex >= 0);
  if Result then
    FUndo := True;
end;

procedure TQIIterator.SkipBlanks;
begin
  while TQICharacter.IsBlankChar(Current) and not EOF do
    MoveNext;
end;

{ TQIBufferIterator }

constructor TQIBufferIterator.Create;
begin
  inherited;
  FBuffer := nil;
  Count := 0;
end;

function TQIBufferIterator.DoGetCurrent: WideChar;
begin
  if Assigned(FBuffer) then
    Result := FBuffer[FIndex]
  else
    Result := #0;
end;

function TQIBufferIterator.DoMoveNext: Boolean;
begin
  Result := Assigned(FBuffer) and inherited DoMoveNext;
end;

procedure TQIBufferIterator.SetCount(const Value: Integer);
begin
  FBuffLen := Value;
  Reset;
end;

{ TEncodedReadStream }

constructor TEncodedReadStream.Create(Source: TStream);
var
  LCharset: TQICharsetType;
begin
  if not DetectCharset(Source, True, LCharset) then
    LCharset := ctWinDefined;
  Create(Source, LCharset);
end;

constructor TEncodedReadStream.Create(Source: TStream; Charset: TQICharsetType);
begin
  inherited Create;
  FStream := Source;
  FCharset := Charset;
  FEncoding := TQIEncoding.GetEncoding(FCharset);
  if Length(FEncoding.GetBOM) > 0 then
    SkipBOM(Source, FCharset);
  FReadlnBuf := TMemoryStream.Create;
end;

constructor TEncodedReadStream.Create(const FileName: string);
begin
  FFromFile := True;
  Create(TFileStream.Create(FileName, fmOpenRead {$IFDEF VCL6}, fmShareDenyWrite{$ENDIF}));
end;

constructor TEncodedReadStream.Create(const FileName: string; Charset: TQICharsetType);
begin
  FFromFile := True;
  Create(TFileStream.Create(FileName, fmOpenRead {$IFDEF VCL6}, fmShareDenyWrite{$ENDIF}), Charset);
end;

destructor TEncodedReadStream.Destroy;
begin
  if FFromFile then
    FreeAndNil(FStream);
  FreeAndNil(FEncoding);
  FreeAndNil(FReadlnBuf);
  inherited;
end;

function TEncodedReadStream.GetEof: Boolean;
begin
  Result := FStream.Position >= FStream.Size;
end;

function TEncodedReadStream.Read(var Buffer; Count: Longint): Longint;
var
  BufPtr: PByte;
  BytesConv,
  BytesLeft,
  BytesRead,
  NumChar,
  IntBufLen: Integer;
  Str: WideString;
begin
  Result := 0;
  BufPtr := @Buffer;
  case FCharset of
    ctUtf32:
      Result := InternalRead(Max(Count * 2, FEncoding.MaxCharSize), BufPtr);
    ctUtf16BE,
    ctUnicode:
      Result := InternalRead(Count, BufPtr);
  else
    if FEncoding.IsSingleByte then
      Result := InternalRead(Max(Count div SizeOf(WideChar), 1), BufPtr)
    else begin
      NumChar := Count div SizeOf(WideChar);
      IntBufLen := Max(NumChar + NumChar mod 2, FEncoding.MaxCharSize);
      if Length(FInternalBuffer) <> IntBufLen then
        SetLength(FInternalBuffer, IntBufLen);
      repeat
        BytesRead := FStream.Read(FInternalBuffer[0], Length(FInternalBuffer));
        if BytesRead = 0 then
          Break;
        BytesLeft := FEncoding.GetRightTrimSize(@FInternalBuffer[0], BytesRead);
        if BytesLeft > 0 then
        begin
          BytesRead := BytesRead - BytesLeft;
          FStream.Position := FStream.Position - BytesLeft;
        end;
        Str := FEncoding.GetString(FInternalBuffer, 0, BytesRead);
        if Length(Str) > NumChar then
        begin
          SetLength(Str, NumChar);
          FStream.Position := FStream.Position - (BytesRead - Length(FEncoding.GetBytes(Str)));
        end;
        BytesConv := Length(Str) * SizeOf(WideChar);
        Move(Str[1], BufPtr^, BytesConv);
        Result := Result + BytesConv;
        NumChar := NumChar - (BytesConv div SizeOf(WideChar));
        Inc(BufPtr, BytesConv);
      until NumChar = 0;
    end;
  end;
end;

function TEncodedReadStream.Readln: WideString;
var
  LastChar, CurrentChar: WideChar;
  NumChar: Integer;
begin
  FReadlnBuf.Clear;
  LastChar := #0;
  NumChar := 0;
  repeat
    if Read(CurrentChar, SizeOf(WideChar)) <> SizeOf(WideChar) then
      Break;
    if CurrentChar = WideChar($000A) then
    begin
      if LastChar = WideChar($000D) then
        NumChar := 1;
      Break;
    end
    else if CurrentChar = WideChar($2028) then
      Break;
    FReadlnBuf.Write(CurrentChar, SizeOf(WideChar));
    LastChar := CurrentChar;
  until False;
  SetLength(Result, (FReadlnBuf.Size - NumChar * SizeOf(WideChar)) div SizeOf(WideChar));
  if Length(Result) > 0 then
    Move(FReadlnBuf.Memory^, Result[1], FReadlnBuf.Size - NumChar * SizeOf(WideChar));
end;

function TEncodedReadStream.ReadToEnd: WideString;
const
  BUFF_SIZE = 1024 * 1024;
var
  SrcBuff: TBytes;
  DestBufPtr: PByte;
  Len, ReadBytes: LongInt;
begin
  Len := FStream.Size - FStream.Position;
  SetLength(Result, Len);
  DestBufPtr := @Result[1];
  ZeroMemory(DestBufPtr, Len * SizeOf(qiChar));
  SetLength(SrcBuff, BUFF_SIZE);
  while not GetEof do
  begin
    ReadBytes := Read(SrcBuff[0], BUFF_SIZE);
    Move(SrcBuff[0], DestBufPtr^, ReadBytes);
    Inc(DestBufPtr, ReadBytes);
  end;
  Result := TrimRight(Result);
end;

function TEncodedReadStream.GetPosition: {$IFDEF VCL7}Int64;{$ELSE}Longint;{$ENDIF}
begin
  raise Exception.Create('Not implemented');
end;

function TEncodedReadStream.GetSize: {$IFDEF VCL7}Int64;{$ELSE}Longint;{$ENDIF}
begin
  raise Exception.Create('Not implemented');
end;

{$IFNDEF VCL17}
function TEncodedReadStream.Write(const Buffer; Count: Longint): Longint;
begin
  raise Exception.Create('Not implemented');
end;
{$ENDIF}

function TEncodedReadStream.InternalRead(InternalBufLen: Integer; BufPtr: PByte): Longint;
var
  BytesRead: Integer;
  Str: WideString;
begin
  if Length(FInternalBuffer) <> InternalBufLen then
    SetLength(FInternalBuffer, InternalBufLen);
  BytesRead := FStream.Read(FInternalBuffer[0], Length(FInternalBuffer));
  Str := FEncoding.GetString(FInternalBuffer, 0, BytesRead);
  Result := Length(Str) * SizeOf(WideChar);
  if Str <> '' then
    Move(Str[1], BufPtr^, Result);
end;

function TEncodedReadStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  raise Exception.Create('Not implemented');
end;

{ TQIUTF32Encoding }

constructor TQIUTF32Encoding.Create;
begin
  FIsSingleByte := False;
  FMaxCharSize := 4;
end;

class function TQIUTF32Encoding.GetBOM: TBytes;
const
  _Utf32BOM: array[0..3] of Byte = ($FF, $FE, $00, $00);
begin
  SetLength(Result, Length(_Utf32BOM));
  Move(_Utf32BOM[0], Result[0], Length(_Utf32BOM));
end;

function TQIUTF32Encoding.GetByteCount(Chars: PWideChar; CharCount: Integer): Integer;
begin
  Result := CharCount * 4;
end;

function TQIUTF32Encoding.GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte; ByteCount: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to CharCount - 1 do
  begin
    PWord(Bytes)^ := PWord(Chars)^;
    Inc(Bytes, 2);
    PWord(Bytes)^ := 0;
    Inc(Bytes, 2);
    Inc(Chars);
  end;
  Result := CharCount * 4;
end;

function TQIUTF32Encoding.GetCharCount(Bytes: PByte; ByteCount: Integer): Integer;
begin
  Result := ByteCount div 4;
end;

function TQIUTF32Encoding.GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar; CharCount: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to CharCount - 1 do
  begin
    Chars^ := WideChar(PWord(Bytes)^);
    Inc(Bytes, 4);
    Inc(Chars);
  end;
  Result := CharCount;
end;

{ TQIBigEndianUTF32Encoding }

class function TQIBigEndianUTF32Encoding.GetBOM: TBytes;
const
  _BigEndianUtf32BOM: array[0..3] of Byte = ($00, $00, $FE, $FF);
begin
  SetLength(Result, Length(_BigEndianUtf32BOM));
  Move(_BigEndianUtf32BOM[0], Result[0], Length(_BigEndianUtf32BOM));
end;

function TQIBigEndianUTF32Encoding.GetBytes(Chars: PWideChar; CharCount: Integer; Bytes: PByte;
  ByteCount: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to CharCount - 1 do
  begin
    PWord(Bytes)^ := 0;
    Inc(Bytes, 2);
    PWord(Bytes)^ := MakeWord(Hi(Word(Chars^)), Lo(Word(Chars^)));
    Inc(Bytes, 2);
    Inc(Chars);
  end;
  Result := CharCount * 4;
end;

function TQIBigEndianUTF32Encoding.GetChars(Bytes: PByte; ByteCount: Integer; Chars: PWideChar;
  CharCount: Integer): Integer;
var
  P: PByte;
  I: Integer;
begin
  P := Bytes;
  Inc(Bytes, 2);
  Inc(P, 3);
  for I := 0 to CharCount - 1 do
  begin
    Chars^ := WideChar(MakeWord(P^, Bytes^));
    Inc(Bytes, 4);
    Inc(P, 4);
    Inc(Chars);
  end;
  Result := CharCount;
end;

end.

