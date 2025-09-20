{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSpreadSheet                                       }
{                                                                    }
{           Copyright (c) 2001-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSPREADSHEET CONTROL AND ALL    }
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

unit dxSpreadSheetCoreStyles;

{$I cxVer.Inc}

interface

uses
{$IFDEF DELPHIXE8}
  System.Hash,
{$ENDIF}
  System.UITypes,
  AnsiStrings, Types,
  Windows, SysUtils, Classes, Generics.Defaults, Generics.Collections, Graphics,
  // DX
  dxCore, dxCoreClasses, cxGeometry, cxGraphics, dxGDIPlusAPI, dxGDIPlusClasses,
  dxHash, dxHashUtils, cxClasses, cxFormats, cxVariants,
  // SpreadSheet
  dxSpreadSheetTypes, dxSpreadSheetGraphics;

type
  TdxSpreadSheetBrushes = class;
  TdxSpreadSheetCellStyles = class;
  TdxSpreadSheetFonts = class;
  TdxSpreadSheetFormats = class;
  TdxSpreadSheetCellStyleHandle = class;
  TdxSpreadSheetFormattedSharedString = class;

  { TdxSpreadSheetBordersHandle }

  TdxSpreadSheetBordersHandle = class(TdxHashTableItem)
  protected
    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
    BorderColor: array[TcxBorder] of TColor;
    BorderIsAuto: array[TcxBorder] of Boolean;
    BorderStyle: array[TcxBorder] of TdxSpreadSheetCellBorderStyle;

    constructor Create(AOwner: TdxDynamicItemList; AIndex: Integer); override;
    procedure Assign(ASource: TdxSpreadSheetBordersHandle); reintroduce; overload;
    procedure Assign(ASource: TdxSpreadSheetBordersHandle; ABorder: TcxBorder); reintroduce; overload;
    function Clone: TdxSpreadSheetBordersHandle;
    function IsEqual(ASource: TdxSpreadSheetBordersHandle; ABorder: TcxBorder): Boolean; overload; inline;
    function IsEqual(ASource: TdxSpreadSheetBordersHandle; ABorder, ASourceBorder: TcxBorder): Boolean; overload; inline;
    procedure LoadFromStream(AReader: TcxReader);
    procedure SaveToStream(AWriter: TcxWriter);
  end;

  { TdxSpreadSheetBorders }

  TdxSpreadSheetBorders = class(TdxHashTable)
  strict private
    FDefaultBorders: TdxSpreadSheetBordersHandle;
    FStyles: TdxSpreadSheetCellStyles;
  public
    constructor Create(AStyles: TdxSpreadSheetCellStyles); reintroduce; overload;
    destructor Destroy; override;
  {$REGION 'for internal use'}
    function AddBorders(const ABorders: TdxSpreadSheetBordersHandle): TdxSpreadSheetBordersHandle;
    function AddClone(const ABorders: TdxSpreadSheetBordersHandle): TdxSpreadSheetBordersHandle;
    function CreateBorders: TdxSpreadSheetBordersHandle;
    function CreateFromStream(AReader: TcxReader): TdxSpreadSheetBordersHandle;
  {$ENDREGION}

    property DefaultBorders: TdxSpreadSheetBordersHandle read FDefaultBorders; // for internal use
    property Styles: TdxSpreadSheetCellStyles read FStyles;
  end;

  { TdxSpreadSheetBrushHandle }

  TdxSpreadSheetBrushHandle = class(TdxHashTableItem)
  protected
    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
    BackgroundColor: TColor;
    ForegroundColor: TColor;
    Style: TdxSpreadSheetCellFillStyle;

    constructor Create(AOwner: TdxDynamicItemList; AIndex: Integer); override;
    procedure Assign(ASource: TdxSpreadSheetBrushHandle); reintroduce; overload;
    function Clone: TdxSpreadSheetBrushHandle;
    procedure LoadFromStream(AReader: TcxReader);
    procedure SaveToStream(AWriter: TcxWriter);
  end;

  { TdxSpreadSheetCustomBrush }

  TdxSpreadSheetCustomBrush = class
  strict private
    FBrushes: TdxSpreadSheetBrushes;

    function GetBackgroundColor: TColor;
    function GetForegroundColor: TColor;
    function GetIsDefault: Boolean;
    function GetStyle: TdxSpreadSheetCellFillStyle;
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetForegroundColor(const Value: TColor);
    procedure SetStyle(const Value: TdxSpreadSheetCellFillStyle);
  protected
    procedure ChangeBrush(AStyle: TdxSpreadSheetCellFillStyle; ABackgroundColor, AForegroundColor: TColor);
    function GetHandle: TdxSpreadSheetBrushHandle; virtual; abstract;
    procedure SetHandle(const AValue: TdxSpreadSheetBrushHandle); virtual; abstract;
    //
    property Brushes: TdxSpreadSheetBrushes read FBrushes;
    property Handle: TdxSpreadSheetBrushHandle read GetHandle write SetHandle;
  public
    constructor Create(ABrushes: TdxSpreadSheetBrushes);
    procedure Assign(ABrush: TdxSpreadSheetCustomBrush); virtual;

    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor;
    property ForegroundColor: TColor read GetForegroundColor write SetForegroundColor;
    property Style: TdxSpreadSheetCellFillStyle read GetStyle write SetStyle;
    //
    property IsDefault: Boolean read GetIsDefault;
  end;

  { TdxSpreadSheetBrushes }

  TdxSpreadSheetBrushes = class(TdxHashTable)
  strict private
    FDefaultBrush: TdxSpreadSheetBrushHandle;
    FStyles: TdxSpreadSheetCellStyles;
  public
    constructor Create(AStyles: TdxSpreadSheetCellStyles); reintroduce; overload;
    destructor Destroy; override;
  {$REGION 'for internal use'}
    function AddBrush(const ABrush: TdxSpreadSheetBrushHandle): TdxSpreadSheetBrushHandle;
    function AddClone(const ABrush: TdxSpreadSheetBrushHandle): TdxSpreadSheetBrushHandle;
    function CreateBrush: TdxSpreadSheetBrushHandle;
    function CreateFromStream(AReader: TcxReader): TdxSpreadSheetBrushHandle;
  {$ENDREGION}

    property DefaultBrush: TdxSpreadSheetBrushHandle read FDefaultBrush; // for internal use
    property Styles: TdxSpreadSheetCellStyles read FStyles;
  end;

  { TdxSpreadSheetFontHandle }

  TdxSpreadSheetFontHandle = class(TdxHashTableItem)
  strict private
    FGraphicObject: TFont;

    function GetGraphicObject: TFont; inline;
  protected
    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
    Charset: TFontCharset;
    Color: TColor;
    Name: TFontName;
    Pitch: TFontPitch;
    Script: TdxSpreadSheetFontScript;
    Size: Integer;
    Style: TFontStyles;

    destructor Destroy; override;
    procedure Assign(ASource: TdxSpreadSheetFontHandle); reintroduce; overload;
    procedure AssignToFont(ATargetFont: TFont); virtual;
    function Clone: TdxSpreadSheetFontHandle;
    procedure FlushCache;
    procedure Initialize(const AName: TFontName; ACharset: TFontCharset;
      AColor: TColor; ASize: Integer; APitch: TFontPitch; AStyle: TFontStyles);
    procedure LoadFromStream(AReader: TcxReader);
    procedure SaveToStream(AWriter: TcxWriter);

    property GraphicObject: TFont read GetGraphicObject;
  end;

  { TdxSpreadSheetCustomFont }

  TdxSpreadSheetCustomFont = class
  strict private
    FFonts: TdxSpreadSheetFonts;

    function GetCharset: TFontCharset;
    function GetColor: TColor;
    function GetHeight: Integer;
    function GetIsDefault: Boolean;
    function GetName: TFontName;
    function GetPitch: TFontPitch;
    function GetSize: Integer;
    function GetStyle: TFontStyles;
    procedure SetCharset(const AValue: TFontCharset);
    procedure SetColor(const AValue: TColor);
    procedure SetHeight(const AValue: Integer);
    procedure SetName(const AValue: TFontName);
    procedure SetPitch(const AValue: TFontPitch);
    procedure SetSize(const AValue: Integer);
    procedure SetStyle(const AValue: TFontStyles);
  protected
    procedure ChangeFont(const AName: TFontName; ACharset: TFontCharset;
      AColor: TColor; ASize: Integer; APitch: TFontPitch; AStyle: TFontStyles);
    function GetHandle: TdxSpreadSheetFontHandle; virtual; abstract;
    procedure SetHandle(const AValue: TdxSpreadSheetFontHandle); virtual; abstract;
    //
    property Fonts: TdxSpreadSheetFonts read FFonts;
    property Handle: TdxSpreadSheetFontHandle read GetHandle write SetHandle;
  public
    constructor Create(AFonts: TdxSpreadSheetFonts); virtual;
    procedure Assign(AFont: TdxSpreadSheetCustomFont); overload;
    procedure Assign(AFont: TdxSpreadSheetFontHandle); overload; // for internal use
    procedure Assign(AFont: TFont); overload;
    procedure AssignToFont(ATargetFont: TFont);
    //
    property Charset: TFontCharset read GetCharset write SetCharset;
    property Color: TColor read GetColor write SetColor;
    property Height: Integer read GetHeight write SetHeight;
    property Name: TFontName read GetName write SetName;
    property Pitch: TFontPitch read GetPitch write SetPitch default fpDefault;
    property Size: Integer read GetSize write SetSize stored False;
    property Style: TFontStyles read GetStyle write SetStyle;
    //
    property IsDefault: Boolean read GetIsDefault;
  end;

  { TdxSpreadSheetFont }

  TdxSpreadSheetFont = class(TdxSpreadSheetCustomFont)
  strict private
    FHandle: TdxSpreadSheetFontHandle;
  protected
    procedure Changed; virtual;
    function GetHandle: TdxSpreadSheetFontHandle; override;
    procedure SetHandle(const AValue: TdxSpreadSheetFontHandle); override;
  public
    constructor Create(AFonts: TdxSpreadSheetFonts); override;
    destructor Destroy; override;
    //
    property Handle; // for internal use
  end;

  { TdxSpreadSheetFonts }

  TdxSpreadSheetFonts = class(TdxHashTable)
  strict private
    FDefaultFont: TdxSpreadSheetFontHandle;
    FStyles: TdxSpreadSheetCellStyles;

    function InternalAddFont(const AName: TFontName; ASize: Integer): TdxSpreadSheetFontHandle;
  public
    constructor Create(AStyles: TdxSpreadSheetCellStyles); reintroduce; overload;
    destructor Destroy; override;
  {$REGION 'for internal use'}
    function AddClone(const AFont: TdxSpreadSheetFontHandle): TdxSpreadSheetFontHandle;
    function AddFont(const AFont: TdxSpreadSheetFontHandle): TdxSpreadSheetFontHandle;
    function CreateFont: TdxSpreadSheetFontHandle;
    function CreateFromStream(AReader: TcxReader): TdxSpreadSheetFontHandle;
  {$ENDREGION}

    property DefaultFont: TdxSpreadSheetFontHandle read FDefaultFont; // for internal use
    property Styles: TdxSpreadSheetCellStyles read FStyles;
  end;

  { TdxSpreadSheetFormatHandle }

  TdxSpreadSheetFormatHandle = class(TdxHashTableItem)
  strict private
    procedure SetFormatCode(const AValue: string);
  protected
    FFormatCode: string;
    FFormatCodeID: Integer;
    FFormatter: TObject;

    procedure CalculateHash(var AHash: Integer); override;
    procedure FormatterNeeded; inline;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
    function GetIsDateTime: Boolean;
    function GetIsText: Boolean;
    function GetIsTime: Boolean;
  public
    constructor Create(const AFormatCode: string; const AFormatCodeID: Integer = -1); reintroduce; overload;
    destructor Destroy; override;
    procedure Format(const AValue: Variant; AValueType: TdxSpreadSheetCellDataType; const AFormatSettings: TObject; var AResult);
    function IsDependedFromRegionalSettings: Boolean;
    function IsLocalized: Boolean;
    procedure LoadFromStream(AReader: TcxReader);
    procedure SaveToStream(AWriter: TcxWriter);
    //
    property FormatCode: string read FFormatCode write SetFormatCode;
    property FormatCodeID: Integer read FFormatCodeID write FFormatCodeID;
    //
    property IsDateTime: Boolean read GetIsDateTime;
    property IsText: Boolean read GetIsText;
    property IsTime: Boolean read GetIsTime;
  end;

  { TdxSpreadSheetPredefinedFormats }

  TdxSpreadSheetPredefinedFormats = class(TList<TdxSpreadSheetFormatHandle>)
  strict private
    FOwner: TdxSpreadSheetFormats;

    function GenerateCurrencyFormat(const AFormatString, APattern, APatternZero: string; ABlindCurrencySymbol: Boolean = False): string;
    procedure InternalAdd(ID: Integer; const AFormatCode: string);
  protected
    procedure Notify(const Item: TdxSpreadSheetFormatHandle; Action: TCollectionNotification); override;
  public
    constructor Create(AOwner: TdxSpreadSheetFormats);
    function GetFormatHandleByID(ID: Integer): TdxSpreadSheetFormatHandle;
    function GetIDByFormatCode(const AFormatCode: string): Integer;
    procedure Refresh;
  end;

  { TdxSpreadSheetCustomDataFormat }

  TdxSpreadSheetCustomDataFormat = class
  strict private
    FFormats: TdxSpreadSheetFormats;

    function GetFormatCode: string;
    function GetFormatCodeID: Integer;
    procedure SetFormatCode(const AValue: string);
    procedure SetFormatCodeID(AValue: Integer);
  protected
    function GetHandle: TdxSpreadSheetFormatHandle; virtual; abstract;
    procedure SetHandle(AValue: TdxSpreadSheetFormatHandle); virtual; abstract;
    //
    property Formats: TdxSpreadSheetFormats read FFormats;
    property Handle: TdxSpreadSheetFormatHandle read GetHandle write SetHandle;
  public
    constructor Create(AFormats: TdxSpreadSheetFormats);
    procedure Assign(ADataFormat: TdxSpreadSheetCustomDataFormat); virtual;
    //
    property FormatCode: string read GetFormatCode write SetFormatCode;
    property FormatCodeID: Integer read GetFormatCodeID write SetFormatCodeID;
  end;

  { TdxSpreadSheetFormats }

  TdxSpreadSheetFormats = class(TdxHashTable)
  strict private
    FDefaultFormat: TdxSpreadSheetFormatHandle;
    FPredefinedFormats: TdxSpreadSheetPredefinedFormats;
    FStyles: TdxSpreadSheetCellStyles;
  protected
    function CreatePredefinedFormats: TdxSpreadSheetPredefinedFormats; virtual;
  public
    constructor Create(AStyles: TdxSpreadSheetCellStyles); reintroduce; overload;
    destructor Destroy; override;
  {$REGION 'for internal use'}
    function AddClone(const AFormat: TdxSpreadSheetFormatHandle): TdxSpreadSheetFormatHandle;
    function AddFormat(const AFormatCode: string; AFormatCodeID: Integer = -1): TdxSpreadSheetFormatHandle;
    function CreateFromStream(AReader: TcxReader): TdxSpreadSheetFormatHandle;
    function IsCustom(AFormat: TdxSpreadSheetFormatHandle): Boolean;
  {$ENDREGION}

    property DefaultFormat: TdxSpreadSheetFormatHandle read FDefaultFormat; // for internal use
    property PredefinedFormats: TdxSpreadSheetPredefinedFormats read FPredefinedFormats;
    property Styles: TdxSpreadSheetCellStyles read FStyles;
  end;

  { TdxSpreadSheetSharedImageHandle }

  TdxSpreadSheetSharedImageHandle = class(TdxHashTableItem)
  strict private
    FImage: TdxSmartImage;
  protected
    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
    constructor Create; reintroduce; overload; virtual;
    constructor Create(AImage: TdxSmartImage); reintroduce; overload;
    constructor Create(AStream: TStream); reintroduce; overload;
    destructor Destroy; override;
    //
    property Image: TdxSmartImage read FImage;
  end;

  { TdxSpreadSheetSharedImages }

  TdxSpreadSheetSharedImages = class(TdxHashTable)
  public
  {$REGION 'for internal use'}
    function Add(AImage: TdxSmartImage): TdxSpreadSheetSharedImageHandle; overload;
    function Add(AStream: TStream): TdxSpreadSheetSharedImageHandle; overload;
    function Add(const AFileName: string): TdxSpreadSheetSharedImageHandle; overload;
  {$ENDREGION}
  end;

  { TdxSpreadSheetSharedString }

  TdxSpreadSheetSharedString = class(TdxHashTableItem)
  strict private
    FValue: string;
  protected
    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
    class function ObjectID: Integer; virtual;
  public
    constructor CreateObject(const AValue: string); virtual;
    procedure LoadFromStream(AReader: TcxReader); virtual;
    procedure SaveToStream(AWriter: TcxWriter); virtual;

    property Value: string read FValue;
  end;

  { TdxSpreadSheetSharedStringTable }

  TdxSpreadSheetSharedStringTable = class(TdxHashTable)
  strict private
    FFontTable: TdxSpreadSheetFonts;

    function GetUniqueCount: Integer;
  protected
    function CreateStringClassByID(const ID: Integer): TdxSpreadSheetSharedString; virtual;
  public
    constructor Create(AFontTable: TdxSpreadSheetFonts); reintroduce; virtual;
    function Add(AString: TdxSpreadSheetSharedString): TdxSpreadSheetSharedString; overload;
    function Add(const AValue: string): TdxSpreadSheetSharedString; overload;
    function LoadItemFromStream(AReader: TcxReader): TdxSpreadSheetSharedString;

    property FontTable: TdxSpreadSheetFonts read FFontTable;
    property UniqueCount: Integer read GetUniqueCount;
  end;

  { TdxSpreadSheetFormattedSharedStringRun }

  TdxSpreadSheetFormattedSharedStringRun = class
  strict private
    FFontHandle: TdxSpreadSheetFontHandle;
    FStartIndex: Integer;
    FTag: TdxNativeUInt;

    procedure SetFontHandle(AValue: TdxSpreadSheetFontHandle);
  public
    destructor Destroy; override;
    procedure Assign(ASource: TdxSpreadSheetFormattedSharedStringRun);
    procedure Offset(ADelta: Integer); inline;
    //
    property FontHandle: TdxSpreadSheetFontHandle read FFontHandle write SetFontHandle;
    property StartIndex: Integer read FStartIndex write FStartIndex;
    property Tag: TdxNativeUInt read FTag write FTag;
  end;

  { TdxSpreadSheetFormattedSharedStringRuns }

  TdxSpreadSheetFormattedSharedStringRuns = class(TcxObjectList)
  strict private
    function GetItem(Index: TdxListIndex): TdxSpreadSheetFormattedSharedStringRun; inline;
  public
    function Add: TdxSpreadSheetFormattedSharedStringRun; overload;
    function Add(AStartIndex: Integer; AFontHandle: TdxSpreadSheetFontHandle; ATag: TdxNativeUInt = 0): TdxSpreadSheetFormattedSharedStringRun; overload;
    procedure Append(ASource: TdxSpreadSheetFormattedSharedStringRuns);
    procedure Assign(ASource: TdxSpreadSheetFormattedSharedStringRuns);
    procedure Offset(ADelta: Integer);
    //
    property Items[Index: TdxListIndex]: TdxSpreadSheetFormattedSharedStringRun read GetItem; default;
  end;

  { TdxSpreadSheetFormattedSharedString }

  TdxSpreadSheetFormattedSharedString = class(TdxSpreadSheetSharedString)
  strict private
    FRuns: TdxSpreadSheetFormattedSharedStringRuns;
  protected
    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
    procedure FontChanged(APrevFont, ANewFont: TdxSpreadSheetFontHandle);
    class function ObjectID: Integer; override;
  public
    constructor CreateObject(const AValue: string); override;
    destructor Destroy; override;
    procedure LoadFromStream(AReader: TcxReader); override;
    procedure SaveToStream(AWriter: TcxWriter); override;

    property Runs: TdxSpreadSheetFormattedSharedStringRuns read FRuns;
  end;

  { TdxSpreadSheetCellStyleHandle }

  TdxSpreadSheetCellStyleHandle = class(TdxHashTableItem)
  strict private
    FAlignHorz: TdxSpreadSheetDataAlignHorz;
    FAlignHorzIndent: Integer;
    FAlignVert: TdxSpreadSheetDataAlignVert;
    FBorders: TdxSpreadSheetBordersHandle;
    FBrush: TdxSpreadSheetBrushHandle;
    FDataFormat: TdxSpreadSheetFormatHandle;
    FFont: TdxSpreadSheetFontHandle;
    FRotation: Integer;
    FStates: TdxSpreadSheetCellStates;

    procedure SetAlignHorzIndent(AValue: Integer);
    procedure SetBorders(AValue: TdxSpreadSheetBordersHandle);
    procedure SetBrush(AValue: TdxSpreadSheetBrushHandle);
    procedure SetDataFormat(AValue: TdxSpreadSheetFormatHandle);
    procedure SetFont(AValue: TdxSpreadSheetFontHandle);
  protected
    FIsDefault: Boolean;

    procedure AssignFields(ASource: TdxSpreadSheetCellStyleHandle);
    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
  {$REGION 'for internal use'}
    constructor Create(AOwner: TdxDynamicItemList; AIndex: Integer); override;
    destructor Destroy; override;
    procedure Assign(ASource: TdxSpreadSheetCellStyleHandle); reintroduce; overload;
    function Clone: TdxSpreadSheetCellStyleHandle;
    procedure LoadFromStream(AReader: TcxReader);
    procedure SaveToStream(AWriter: TcxWriter);

    property AlignHorz: TdxSpreadSheetDataAlignHorz read FAlignHorz write FAlignHorz;
    property AlignHorzIndent: Integer read FAlignHorzIndent write SetAlignHorzIndent;
    property AlignVert: TdxSpreadSheetDataAlignVert read FAlignVert write FAlignVert;
    property Borders: TdxSpreadSheetBordersHandle read FBorders write SetBorders;
    property Brush: TdxSpreadSheetBrushHandle read FBrush write SetBrush;
    property DataFormat: TdxSpreadSheetFormatHandle read FDataFormat write SetDataFormat;
    property Font: TdxSpreadSheetFontHandle read FFont write SetFont;
    property IsDefault: Boolean read FIsDefault;
    property Rotation: Integer read FRotation write FRotation;
    property States: TdxSpreadSheetCellStates read FStates write FStates;
  {$ENDREGION}
  end;

  { TdxSpreadSheetCellStyleHandleList }

  TdxSpreadSheetCellStyleHandleList = class(TdxHashTableItemList)
  strict private
    function GetItem(Index: TdxListIndex): TdxSpreadSheetCellStyleHandle; inline;
  public
    property Items[Index: TdxListIndex]: TdxSpreadSheetCellStyleHandle read GetItem; default;
  end;

  { TdxSpreadSheetCellStyles }

  TdxSpreadSheetCellStyles = class(TdxHashTable, IUnknown, IcxFormatControllerListener)
  strict private
    FBorders: TdxSpreadSheetBorders;
    FBrushes: TdxSpreadSheetBrushes;
    FDefaultStyle: TdxSpreadSheetCellStyleHandle;
    FFonts: TdxSpreadSheetFonts;
    FFormats: TdxSpreadSheetFormats;

    FOnChange: TNotifyEvent;
  protected
    Palette: TColors;

    function CreateBorders: TdxSpreadSheetBorders; virtual;
    function CreateBrushes: TdxSpreadSheetBrushes; virtual;
    function CreateDefaultStyle: TdxSpreadSheetCellStyleHandle; virtual;
    function CreateFonts: TdxSpreadSheetFonts; virtual;
    function CreateFormats: TdxSpreadSheetFormats; virtual;
    procedure DeleteItem(AItem: TdxHashTableItem); override;
    // IUnknown
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    // IcxFormatControllerListener
    procedure FormatChanged;
  public
    constructor Create; override;
    destructor Destroy; override;
  {$REGION 'for internal use'}
    function AddClone(AStyle: TdxSpreadSheetCellStyleHandle): TdxSpreadSheetCellStyleHandle;
    function AddStyle(AStyle: TdxSpreadSheetCellStyleHandle): TdxSpreadSheetCellStyleHandle;
    function CreateStyle(AFont: TdxSpreadSheetFontHandle = nil; AFormat: TdxSpreadSheetFormatHandle = nil;
      ABrush: TdxSpreadSheetBrushHandle = nil; ABorders: TdxSpreadSheetBordersHandle = nil): TdxSpreadSheetCellStyleHandle;
    function CreateStyleFromStream(AReader: TcxReader): TdxSpreadSheetCellStyleHandle;
  {$ENDREGION}

    property Borders: TdxSpreadSheetBorders read FBorders;
    property Brushes: TdxSpreadSheetBrushes read FBrushes;
    property Fonts: TdxSpreadSheetFonts read FFonts;
    property Formats: TdxSpreadSheetFormats read FFormats;

    property DefaultStyle: TdxSpreadSheetCellStyleHandle read FDefaultStyle; // for internal use

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TdxSpreadSheetFormattedSharedStringCache }

  TdxSpreadSheetFormattedSharedStringCache = class
  public const
    MaxCount: Integer = 128;
  strict private type
  {$REGION 'Private Types'}
    TKey = class
    protected
      FString: TdxSpreadSheetSharedString;
      FDefaultFontHandle: TdxSpreadSheetFontHandle;
    public
      constructor Create(AString: TdxSpreadSheetSharedString; ADefaultFontHandle: TdxSpreadSheetFontHandle);
      destructor Destroy; override;
      function Equals(Obj: TObject): Boolean; override;
      function GetHashCode: Integer; override;
    end;
  {$ENDREGION}
  strict private
    FItems: TObjectDictionary<TKey, TObject>;
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddRender(AString: TdxSpreadSheetSharedString;
      ADefaultFontHandle: TdxSpreadSheetFontHandle; const ARender: TObject);
    function TryGetRender(AString: TdxSpreadSheetSharedString;
      ADefaultFontHandle: TdxSpreadSheetFontHandle; out ARender: TObject): Boolean;
    procedure Clear;
    procedure RemoveItems(ADefaultFontHandle: TdxSpreadSheetFontHandle); overload;
    procedure RemoveItems(AString: TdxSpreadSheetSharedString); overload;
  end;

implementation

uses
  Math, StrUtils, dxTypeHelpers, dxDPIAwareUtils,
  dxSpreadSheetNumberFormat, dxSpreadSheetClasses, dxSpreadSheetCoreStrs;

const
  dxThisUnitName = 'dxSpreadSheetCoreStyles';

function CalculateLogicalFontSize(const AName: TFontName; ASize: Integer; APitch: TFontPitch; AStyle: TFontStyles): Integer;
var
  APrevPixelsPerInch: Integer;
  ATextMetric: TTextMetricW;
begin
  Result := ASize;
  if Result < 0 then
  begin

    APrevPixelsPerInch := cxMeasureCanvas.Font.PixelsPerInch;
    try
      cxMeasureCanvas.Font.PixelsPerInch := dxDefaultDPI;
      cxMeasureCanvas.Font.Name := AName;
      cxMeasureCanvas.Font.Pitch := APitch;
      cxMeasureCanvas.Font.Style := AStyle;
      cxMeasureCanvas.Font.Size := ASize;
      GetTextMetrics(cxMeasureCanvas.Handle, ATextMetric);
      cxMeasureCanvas.Font.Height := -(ATextMetric.tmHeight - ATextMetric.tmInternalLeading);
      Result := cxMeasureCanvas.Font.Size;
    finally
      cxMeasureCanvas.Font.PixelsPerInch := APrevPixelsPerInch;
    end;
  end;
end;

{ TdxSpreadSheetBordersHandle }

constructor TdxSpreadSheetBordersHandle.Create(AOwner: TdxDynamicItemList; AIndex: Integer);
var
  ABorder: TcxBorder;
begin
  inherited Create(AOwner, AIndex);
  for ABorder := Low(TcxBorder) to High(TcxBorder) do
    BorderColor[ABorder] := clDefault;
end;

procedure TdxSpreadSheetBordersHandle.Assign(ASource: TdxSpreadSheetBordersHandle);
begin
  Move(ASource.BorderIsAuto, BorderIsAuto, SizeOf(BorderIsAuto));
  Move(ASource.BorderColor, BorderColor, SizeOf(BorderColor));
  Move(ASource.BorderStyle, BorderStyle, SizeOf(BorderStyle));
end;

procedure TdxSpreadSheetBordersHandle.Assign(ASource: TdxSpreadSheetBordersHandle; ABorder: TcxBorder);
begin
  BorderColor[ABorder] := ASource.BorderColor[ABorder];
  BorderIsAuto[ABorder] := ASource.BorderIsAuto[ABorder];
  BorderStyle[ABorder] := ASource.BorderStyle[ABorder];
end;

function TdxSpreadSheetBordersHandle.Clone: TdxSpreadSheetBordersHandle;
begin
  Result := TdxSpreadSheetBordersHandle.Create(nil, 0);
  Result.Assign(Self);
end;

function TdxSpreadSheetBordersHandle.IsEqual(ASource: TdxSpreadSheetBordersHandle; ABorder: TcxBorder): Boolean;
begin
  Result := IsEqual(ASource, ABorder, ABorder)
end;

function TdxSpreadSheetBordersHandle.IsEqual(ASource: TdxSpreadSheetBordersHandle; ABorder, ASourceBorder: TcxBorder): Boolean;
begin
  Result :=
    (BorderColor[ABorder] = ASource.BorderColor[ASourceBorder]) and
    (BorderStyle[ABorder] = ASource.BorderStyle[ASourceBorder]);
end;

procedure TdxSpreadSheetBordersHandle.LoadFromStream(AReader: TcxReader);
var
  ASide: TcxBorder;
begin
  for ASide := Low(TcxBorder) to High(TcxBorder) do
  begin
    BorderColor[ASide] := AReader.ReadInteger;
    BorderStyle[ASide] := TdxSpreadSheetCellBorderStyle(AReader.ReadByte);
    if AReader.Version > 15 then
      BorderIsAuto[ASide] := AReader.ReadBoolean;
  end;
end;

procedure TdxSpreadSheetBordersHandle.SaveToStream(AWriter: TcxWriter);
var
  ASide: TcxBorder;
begin
  for ASide := Low(TcxBorder) to High(TcxBorder) do
  begin
    AWriter.WriteInteger(BorderColor[ASide]);
    AWriter.WriteByte(Byte(BorderStyle[ASide]));
    if AWriter.Version > 15 then
      AWriter.WriteBoolean(BorderIsAuto[ASide]);
  end;
end;

procedure TdxSpreadSheetBordersHandle.CalculateHash(var AHash: Integer);
var
  ABorder: TcxBorder;
begin
  for ABorder := Low(TcxBorder) to High(TcxBorder) do
  begin
    AddToHash(AHash, BorderIsAuto[ABorder], SizeOf(Boolean));
    AddToHash(AHash, BorderColor[ABorder], SizeOf(TColor));
    AddToHash(AHash, BorderStyle[ABorder], SizeOf(TdxSpreadSheetCellBorderStyle));
  end;
end;

function TdxSpreadSheetBordersHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
var
  ABorder: TcxBorder;
begin
  for ABorder := Low(TcxBorder) to High(TcxBorder) do
  begin
    Result :=
      (BorderIsAuto[ABorder] = TdxSpreadSheetBordersHandle(AItem).BorderIsAuto[ABorder]) and
      (BorderColor[ABorder] = TdxSpreadSheetBordersHandle(AItem).BorderColor[ABorder]) and
      (BorderStyle[ABorder] = TdxSpreadSheetBordersHandle(AItem).BorderStyle[ABorder]);
    if not Result then
      Break;
  end;
end;

{ TdxSpreadSheetBorders }

constructor TdxSpreadSheetBorders.Create(AStyles: TdxSpreadSheetCellStyles);
begin
  inherited Create;
  FStyles := AStyles;
  FDefaultBorders := AddBorders(TdxSpreadSheetBordersHandle.Create(nil, 0));
  FDefaultBorders.AddRef;
end;

function TdxSpreadSheetBorders.AddBorders(const ABorders: TdxSpreadSheetBordersHandle): TdxSpreadSheetBordersHandle;
begin
  Result := ABorders;
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetBorders.AddClone(const ABorders: TdxSpreadSheetBordersHandle): TdxSpreadSheetBordersHandle;
begin
  Result := ABorders;
  if Result = nil then
    Exit;
  Result := CreateBorders;
  Result.Assign(ABorders);
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetBorders.CreateBorders: TdxSpreadSheetBordersHandle;
begin
  Result := DefaultBorders.Clone;
end;

function TdxSpreadSheetBorders.CreateFromStream(AReader: TcxReader): TdxSpreadSheetBordersHandle;
begin
  Result := CreateBorders;
  Result.LoadFromStream(AReader);
  Result := AddBorders(Result);
end;

destructor TdxSpreadSheetBorders.Destroy;
begin
  FDefaultBorders.Release;
  FDefaultBorders := nil;
  inherited Destroy;
end;

{ TdxSpreadSheetBrushHandle }

constructor TdxSpreadSheetBrushHandle.Create(AOwner: TdxDynamicItemList; AIndex: Integer);
begin
  inherited Create(AOwner, AIndex);
  ForegroundColor := clDefault;
  BackgroundColor := clDefault;
end;

procedure TdxSpreadSheetBrushHandle.Assign(ASource: TdxSpreadSheetBrushHandle);
begin
  Style := ASource.Style;
  ForegroundColor := ASource.ForegroundColor;
  BackgroundColor := ASource.BackgroundColor;
end;

procedure TdxSpreadSheetBrushHandle.CalculateHash(var AHash: Integer);
begin
  AddToHash(AHash, ForegroundColor, SizeOf(ForegroundColor));
  AddToHash(AHash, BackgroundColor, SizeOf(BackgroundColor));
  AddToHash(AHash, Style, SizeOf(Style));
end;

function TdxSpreadSheetBrushHandle.Clone: TdxSpreadSheetBrushHandle;
begin
  Result := TdxSpreadSheetBrushHandle.Create(nil, 0);
  Result.Assign(Self);
end;

procedure TdxSpreadSheetBrushHandle.LoadFromStream(AReader: TcxReader);
begin
  BackgroundColor := AReader.ReadInteger;
  ForegroundColor := AReader.ReadInteger;
  Style := TdxSpreadSheetCellFillStyle(AReader.ReadByte);
end;

procedure TdxSpreadSheetBrushHandle.SaveToStream(AWriter: TcxWriter);
begin
  AWriter.WriteInteger(BackgroundColor);
  AWriter.WriteInteger(ForegroundColor);
  AWriter.WriteByte(Byte(Style));
end;

function TdxSpreadSheetBrushHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result :=
    (ForegroundColor = TdxSpreadSheetBrushHandle(AItem).ForegroundColor) and
    (BackgroundColor = TdxSpreadSheetBrushHandle(AItem).BackgroundColor) and
    (Style = TdxSpreadSheetBrushHandle(AItem).Style);
end;

{ TdxSpreadSheetCustomBrush }

constructor TdxSpreadSheetCustomBrush.Create(ABrushes: TdxSpreadSheetBrushes);
begin
  inherited Create;
  FBrushes := ABrushes;
end;

procedure TdxSpreadSheetCustomBrush.Assign(ABrush: TdxSpreadSheetCustomBrush);
begin
  ChangeBrush(ABrush.Style, ABrush.BackgroundColor, ABrush.ForegroundColor);
end;

procedure TdxSpreadSheetCustomBrush.ChangeBrush(AStyle: TdxSpreadSheetCellFillStyle; ABackgroundColor, AForegroundColor: TColor);
var
  ABrushHandle: TdxSpreadSheetBrushHandle;
begin
  if (Style <> AStyle) or (BackgroundColor <> ABackgroundColor) or (ForegroundColor <> AForegroundColor) then
  begin
    ABrushHandle := Handle.Clone;
    ABrushHandle.BackgroundColor := ABackgroundColor;
    ABrushHandle.ForegroundColor := AForegroundColor;
    ABrushHandle.Style := AStyle;
    Handle := Brushes.AddBrush(ABrushHandle);
  end;
end;

function TdxSpreadSheetCustomBrush.GetBackgroundColor: TColor;
begin
  Result := Handle.BackgroundColor;
end;

function TdxSpreadSheetCustomBrush.GetStyle: TdxSpreadSheetCellFillStyle;
begin
  Result := Handle.Style;
end;

function TdxSpreadSheetCustomBrush.GetForegroundColor: TColor;
begin
  Result := Handle.ForegroundColor;
end;

function TdxSpreadSheetCustomBrush.GetIsDefault: Boolean;
begin
  Result := Handle = Brushes.DefaultBrush;
end;

procedure TdxSpreadSheetCustomBrush.SetBackgroundColor(const Value: TColor);
begin
  ChangeBrush(Style, Value, ForegroundColor);
end;

procedure TdxSpreadSheetCustomBrush.SetStyle(const Value: TdxSpreadSheetCellFillStyle);
begin
  ChangeBrush(Value, BackgroundColor, ForegroundColor);
end;

procedure TdxSpreadSheetCustomBrush.SetForegroundColor(const Value: TColor);
begin
  ChangeBrush(Style, BackgroundColor, Value);
end;

{ TdxSpreadSheetBrushes }

constructor TdxSpreadSheetBrushes.Create(AStyles: TdxSpreadSheetCellStyles);
begin
  inherited Create;
  FStyles := AStyles;
  FDefaultBrush := AddBrush(TdxSpreadSheetBrushHandle.Create(nil, 0));
  FDefaultBrush.AddRef;
end;

destructor TdxSpreadSheetBrushes.Destroy;
begin
  FDefaultBrush.Release;
  FDefaultBrush := nil;
  inherited Destroy;
end;

function TdxSpreadSheetBrushes.AddBrush(const ABrush: TdxSpreadSheetBrushHandle): TdxSpreadSheetBrushHandle;
begin
  Result := ABrush;
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetBrushes.AddClone(const ABrush: TdxSpreadSheetBrushHandle): TdxSpreadSheetBrushHandle;
begin
  Result := ABrush;
  if Result = nil then
    Exit;
  Result := CreateBrush;
  Result.Assign(ABrush);
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetBrushes.CreateBrush: TdxSpreadSheetBrushHandle;
begin
  Result := DefaultBrush.Clone;
end;

function TdxSpreadSheetBrushes.CreateFromStream(AReader: TcxReader): TdxSpreadSheetBrushHandle;
begin
  Result := CreateBrush;
  Result.LoadFromStream(AReader);
  Result := AddBrush(Result);
end;

{ TdxSpreadSheetFontHandle }

destructor TdxSpreadSheetFontHandle.Destroy;
begin
  FreeAndNil(FGraphicObject);
  inherited Destroy;
end;

procedure TdxSpreadSheetFontHandle.Assign(ASource: TdxSpreadSheetFontHandle);
begin
  Charset := ASource.Charset;
  Color := ASource.Color;
  Size := ASource.Size;
  Name := ASource.Name;
  Pitch := ASource.Pitch;
  Style := ASource.Style;
  FlushCache;
end;

procedure TdxSpreadSheetFontHandle.AssignToFont(ATargetFont: TFont);
begin
  ATargetFont.PixelsPerInch := dxDefaultDPI;
  ATargetFont.Charset := Charset;
  ATargetFont.Color := Color;
  ATargetFont.Size := Size;
  ATargetFont.Name := Name;
  ATargetFont.Pitch := Pitch;
  ATargetFont.Style := Style;
end;

procedure TdxSpreadSheetFontHandle.CalculateHash(var AHash: Integer);
begin
  AddToHash(AHash, dxStringToAnsiString(Name));
  AddToHash(AHash, Charset, SizeOf(TFontCharset));
  AddToHash(AHash, Color, SizeOf(TColor));
  AddToHash(AHash, Size, SizeOf(Integer));
  AddToHash(AHash, Pitch, SizeOf(TFontPitch));
  AddToHash(AHash, Style, SizeOf(TFontStyles));
  AddToHash(AHash, Script, SizeOf(Script));
end;

function TdxSpreadSheetFontHandle.Clone: TdxSpreadSheetFontHandle;
begin
  Result := TdxSpreadSheetFontHandle.Create(nil, 0);
  Result.Assign(Self);
end;

procedure TdxSpreadSheetFontHandle.FlushCache;
begin
  FreeAndNil(FGraphicObject);
end;

procedure TdxSpreadSheetFontHandle.Initialize(const AName: TFontName;
  ACharset: TFontCharset; AColor: TColor; ASize: Integer; APitch: TFontPitch; AStyle: TFontStyles);
begin
  if ASize < 0 then
    ASize := CalculateLogicalFontSize(AName, ASize, APitch, AStyle);

  Name := AName;
  Charset := ACharset;
  Color := AColor;
  Size := ASize;
  Pitch := APitch;
  Style := AStyle;
  FlushCache;
end;

procedure TdxSpreadSheetFontHandle.LoadFromStream(AReader: TcxReader);
begin
  Charset := AReader.ReadByte;
  Color := AReader.ReadInteger;
  Size := AReader.ReadInteger;
  Name := AReader.ReadWideString;
  Pitch := TFontPitch(AReader.ReadByte);
  AReader.Stream.ReadBuffer(Style, SizeOf(Style));
  if AReader.Version >= 10 then
    Byte(Script) := AReader.ReadByte;
  FlushCache;
end;

procedure TdxSpreadSheetFontHandle.SaveToStream(AWriter: TcxWriter);
begin
  AWriter.WriteByte(Charset);
  AWriter.WriteInteger(Color);
  AWriter.WriteInteger(Size);
  AWriter.WriteWideString(Name);
  AWriter.WriteByte(Byte(Pitch));
  AWriter.Stream.WriteBuffer(Style, SizeOf(Style));
  AWriter.WriteByte(Byte(Script));
end;

function TdxSpreadSheetFontHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result :=
    (Charset = TdxSpreadSheetFontHandle(AItem).Charset) and
    (Color = TdxSpreadSheetFontHandle(AItem).Color) and
    (Size = TdxSpreadSheetFontHandle(AItem).Size) and
    (Pitch = TdxSpreadSheetFontHandle(AItem).Pitch) and
    (Style = TdxSpreadSheetFontHandle(AItem).Style) and
    (Script = TdxSpreadSheetFontHandle(AItem).Script) and
    dxSameText(Name, TdxSpreadSheetFontHandle(AItem).Name);
end;

function TdxSpreadSheetFontHandle.GetGraphicObject: TFont;
begin
  if FGraphicObject = nil then
  begin
    FGraphicObject := TFont.Create;
    FGraphicObject.PixelsPerInch := dxDefaultDPI;
    AssignToFont(FGraphicObject);
  end;
  Result := FGraphicObject;
end;

{ TdxSpreadSheetCustomFont }

constructor TdxSpreadSheetCustomFont.Create(AFonts: TdxSpreadSheetFonts);
begin
  inherited Create;
  FFonts := AFonts;
end;

procedure TdxSpreadSheetCustomFont.Assign(AFont: TdxSpreadSheetCustomFont);
begin
  Assign(AFont.Handle);
end;

procedure TdxSpreadSheetCustomFont.Assign(AFont: TdxSpreadSheetFontHandle);
begin
  ChangeFont(AFont.Name, AFont.Charset, AFont.Color, AFont.Size, AFont.Pitch, AFont.Style);
end;

procedure TdxSpreadSheetCustomFont.Assign(AFont: TFont);
begin
  ChangeFont(AFont.Name, AFont.Charset, AFont.Color,
    -MulDiv(AFont.Height, 72, AFont.PixelsPerInch), AFont.Pitch, AFont.Style);
end;

procedure TdxSpreadSheetCustomFont.AssignToFont(ATargetFont: TFont);
begin
  ATargetFont.Assign(Handle.GraphicObject);
end;

procedure TdxSpreadSheetCustomFont.ChangeFont(const AName: TFontName;
  ACharset: TFontCharset; AColor: TColor; ASize: Integer; APitch: TFontPitch; AStyle: TFontStyles);
var
  AFontHandle: TdxSpreadSheetFontHandle;
begin
  if (Charset <> ACharset) or (Color <> AColor) or (Size <> ASize) or (Pitch <> APitch) or (Style <> AStyle) or (Name <> AName) then
  begin
    AFontHandle := Handle.Clone;
    AFontHandle.Initialize(AName, ACharset, AColor, ASize, APitch, AStyle);
    Handle := Fonts.AddFont(AFontHandle);
  end;
end;

function TdxSpreadSheetCustomFont.GetCharset: TFontCharset;
begin
  Result := Handle.Charset;
end;

function TdxSpreadSheetCustomFont.GetColor: TColor;
begin
  Result := Handle.Color;
end;

function TdxSpreadSheetCustomFont.GetHeight: Integer;
begin
  Result := -MulDiv(Size, dxDefaultDPI, 72)
end;

function TdxSpreadSheetCustomFont.GetIsDefault: Boolean;
begin
  Result := Handle = Fonts.DefaultFont;
end;

function TdxSpreadSheetCustomFont.GetName: TFontName;
begin
  Result := Handle.Name;
end;

function TdxSpreadSheetCustomFont.GetPitch: TFontPitch;
begin
  Result := Handle.Pitch;
end;

function TdxSpreadSheetCustomFont.GetSize: Integer;
begin
  Result := Handle.Size;
end;

function TdxSpreadSheetCustomFont.GetStyle: TFontStyles;
begin
  Result := Handle.Style;
end;

procedure TdxSpreadSheetCustomFont.SetCharset(const AValue: TFontCharset);
begin
  ChangeFont(Name, AValue, Color, Size, Pitch, Style);
end;

procedure TdxSpreadSheetCustomFont.SetColor(const AValue: TColor);
begin
  ChangeFont(Name, Charset, AValue, Size, Pitch, Style);
end;

procedure TdxSpreadSheetCustomFont.SetHeight(const AValue: Integer);
begin
  Size := -MulDiv(AValue, 72, dxDefaultDPI);
end;

procedure TdxSpreadSheetCustomFont.SetName(const AValue: TFontName);
begin
  ChangeFont(AValue, Charset, Color, Size, Pitch, Style);
end;

procedure TdxSpreadSheetCustomFont.SetPitch(const AValue: TFontPitch);
begin
  ChangeFont(Name, Charset, Color, Size, AValue, Style);
end;

procedure TdxSpreadSheetCustomFont.SetSize(const AValue: Integer);
begin
  ChangeFont(Name, Charset, Color, AValue, Pitch, Style);
end;

procedure TdxSpreadSheetCustomFont.SetStyle(const AValue: TFontStyles);
begin
  ChangeFont(Name, Charset, Color, Size, Pitch, AValue);
end;

{ TdxSpreadSheetFont }

constructor TdxSpreadSheetFont.Create(AFonts: TdxSpreadSheetFonts);
begin
  inherited Create(AFonts);
  FHandle := Fonts.DefaultFont;
  FHandle.AddRef;
end;

destructor TdxSpreadSheetFont.Destroy;
begin
  FHandle.Release;
  FHandle := nil;
  inherited Destroy;
end;

procedure TdxSpreadSheetFont.Changed;
begin
  // do nothing
end;

function TdxSpreadSheetFont.GetHandle: TdxSpreadSheetFontHandle;
begin
  Result := FHandle;
end;

procedure TdxSpreadSheetFont.SetHandle(const AValue: TdxSpreadSheetFontHandle);
begin
  if AValue <> nil then
  begin
    if dxChangeHandle(FHandle, AValue) then
      Changed;
  end;
end;

{ TdxSpreadSheetFonts }

constructor TdxSpreadSheetFonts.Create(AStyles: TdxSpreadSheetCellStyles);
begin
  inherited Create;
  FStyles := AStyles;
  FDefaultFont := InternalAddFont('Calibri', 11);
  FDefaultFont.AddRef;
end;

destructor TdxSpreadSheetFonts.Destroy;
begin
  FDefaultFont.Release;
  FDefaultFont := nil;
  inherited Destroy;
end;

function TdxSpreadSheetFonts.AddClone(const AFont: TdxSpreadSheetFontHandle): TdxSpreadSheetFontHandle;
begin
  Result := AFont;
  if Result = nil then
    Exit;
  Result := CreateFont;
  Result.Assign(AFont);
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetFonts.AddFont(const AFont: TdxSpreadSheetFontHandle): TdxSpreadSheetFontHandle;
begin
  Result := AFont;
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetFonts.CreateFont: TdxSpreadSheetFontHandle;
begin
  Result := DefaultFont.Clone;
  Result.Charset := DEFAULT_CHARSET;
end;

function TdxSpreadSheetFonts.CreateFromStream(AReader: TcxReader): TdxSpreadSheetFontHandle;
begin
  Result := CreateFont;
  Result.LoadFromStream(AReader);
  Result := AddFont(Result);
end;

function TdxSpreadSheetFonts.InternalAddFont(const AName: TFontName; ASize: Integer): TdxSpreadSheetFontHandle;
begin
  Result := TdxSpreadSheetFontHandle.Create(nil, 0);
  Result.Name := AName;
  Result.Charset := DEFAULT_CHARSET;
  Result.Color := clDefault;
  Result.Size := ASize;
  CheckAndAddItem(Result);
end;

{ TdxSpreadSheetFormatHandle }

constructor TdxSpreadSheetFormatHandle.Create(const AFormatCode: string; const AFormatCodeID: Integer = -1);
begin
  FormatCode := AFormatCode;
  FormatCodeID := AFormatCodeID;
  inherited Create(nil, 0);
end;

destructor TdxSpreadSheetFormatHandle.Destroy;
begin
  FreeAndNil(FFormatter);
  inherited Destroy;
end;

procedure TdxSpreadSheetFormatHandle.Format(const AValue: Variant;
  AValueType: TdxSpreadSheetCellDataType; const AFormatSettings: TObject; var AResult);
begin
  FormatterNeeded;
  TdxSpreadSheetNumberFormat(FFormatter).Format(AValue, AValueType,
    TdxSpreadSheetCustomFormatSettings(AFormatSettings),
    TdxSpreadSheetNumberFormatResult(AResult));
end;

function TdxSpreadSheetFormatHandle.IsDependedFromRegionalSettings: Boolean;
begin
  Result := FormatCodeID = 14;
end;

function TdxSpreadSheetFormatHandle.IsLocalized: Boolean;
begin
  Result := InRange(FormatCodeID, 5, 8) or InRange(FormatCodeID, $29, $2C)
end;

procedure TdxSpreadSheetFormatHandle.LoadFromStream(AReader: TcxReader);
begin
  FormatCode := AReader.ReadWideString;
  FormatCodeID := AReader.ReadInteger;
  FreeAndNil(FFormatter);
end;

procedure TdxSpreadSheetFormatHandle.SaveToStream(AWriter: TcxWriter);
begin
  AWriter.WriteWideString(FormatCode);
  AWriter.WriteInteger(FormatCodeID);
end;

procedure TdxSpreadSheetFormatHandle.CalculateHash(var AHash: Integer);
begin
  AHash := FFormatCodeID;
  AddToHash(AHash, FFormatCode);
end;

function TdxSpreadSheetFormatHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result :=
    (FormatCodeID = TdxSpreadSheetFormatHandle(AItem).FormatCodeID) and
    (FormatCode = TdxSpreadSheetFormatHandle(AItem).FormatCode);
end;

procedure TdxSpreadSheetFormatHandle.FormatterNeeded;
var
  AFormatter: TdxSpreadSheetNumberFormat;
begin
  if FFormatter = nil then
  begin
    AFormatter := TdxSpreadSheetNumberFormat.Create(FormatCode, FormatCodeID);
    if InterlockedCompareExchangePointer(Pointer(FFormatter), Pointer(AFormatter), nil) <> nil then
      AFormatter.Free;
  end;
end;

function TdxSpreadSheetFormatHandle.GetIsDateTime: Boolean;
begin
  FormatterNeeded;
  Result := TdxSpreadSheetNumberFormat(FFormatter).IsDateTime;
end;

function TdxSpreadSheetFormatHandle.GetIsText: Boolean;
begin
  FormatterNeeded;
  Result := TdxSpreadSheetNumberFormat(FFormatter).IsText;
end;

function TdxSpreadSheetFormatHandle.GetIsTime: Boolean;
begin
  FormatterNeeded;
  Result := TdxSpreadSheetNumberFormat(FFormatter).IsTime;
end;

procedure TdxSpreadSheetFormatHandle.SetFormatCode(const AValue: string);
begin
  FFormatCode := AValue;
  FreeAndNil(FFormatter);
end;

{ TdxSpreadSheetPredefinedFormats }

constructor TdxSpreadSheetPredefinedFormats.Create(AOwner: TdxSpreadSheetFormats);
begin
  inherited Create;
  FOwner := AOwner;
  Refresh;
end;

function TdxSpreadSheetPredefinedFormats.GetFormatHandleByID(ID: Integer): TdxSpreadSheetFormatHandle;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[I].FormatCodeID = ID then
      Exit(Items[I]);
  end;
end;

function TdxSpreadSheetPredefinedFormats.GetIDByFormatCode(const AFormatCode: string): Integer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Items[I].FormatCode = AFormatCode then
      Exit(Items[I].FormatCodeID);
  end;
  Result := -1;
end;

procedure TdxSpreadSheetPredefinedFormats.Notify(
  const Item: TdxSpreadSheetFormatHandle; Action: TCollectionNotification);
begin
  inherited Notify(Item, Action);
  case Action of
    cnAdded:
      Item.AddRef;
    cnRemoved:
      Item.Release;
  end;
end;

procedure TdxSpreadSheetPredefinedFormats.Refresh;
begin
  InternalAdd($00, 'GENERAL');
  InternalAdd($01, '0');
  InternalAdd($02, '0.00');
  InternalAdd($03, '#,##0');
  InternalAdd($04, '#,##0.00');
  InternalAdd($05, GenerateCurrencyFormat('%0:s_);%1:s',      '#,##0',    ''));
  InternalAdd($06, GenerateCurrencyFormat('%0:s_);[Red]%1:s', '#,##0',    ''));
  InternalAdd($07, GenerateCurrencyFormat('%0:s_);%1:s',      '#,##0.00', ''));
  InternalAdd($08, GenerateCurrencyFormat('%0:s_);[Red]%1:s', '#,##0.00', ''));
  InternalAdd($29, GenerateCurrencyFormat('_(%0:s_);_(%1:s;_(%2:s_);_(@_)', '* #,##0',    '* "-"', True));
  InternalAdd($2A, GenerateCurrencyFormat('_(%0:s_);_(%1:s;_(%2:s_);_(@_)', '* #,##0',    '* "-"'));
  InternalAdd($2B, GenerateCurrencyFormat('_(%0:s_);_(%1:s;_(%2:s_);_(@_)', '* #,##0.00', '* "-"??', True));
  InternalAdd($2C, GenerateCurrencyFormat('_(%0:s_);_(%1:s;_(%2:s_);_(@_)', '* #,##0.00', '* "-"??'));
  InternalAdd($09, '0%');
  InternalAdd($0a, '0.00%');
  InternalAdd($0b, '0.00E+00');
  InternalAdd($0c, '# ?/?');
  InternalAdd($0d, '# ??/??');
  InternalAdd($0e, 'm/d/yy');
  InternalAdd($0f, 'd-mmm-yy');
  InternalAdd($10, 'd-mmm');
  InternalAdd($11, 'mmm-yy');
  InternalAdd($12, 'h:mm AM/PM');
  InternalAdd($13, 'h:mm:ss AM/PM');
  InternalAdd($14, 'h:mm');
  InternalAdd($15, 'h:mm:ss');
  InternalAdd($16, 'm/d/yy h:mm');
  InternalAdd($25, '#,##0_);(#,##0)');
  InternalAdd($26, '#,##0_);[Red](#,##0)');
  InternalAdd($27, '#,##0.00_);(#,##0.00)');
  InternalAdd($28, '#,##0.00_);[Red](#,##0.00)');
  InternalAdd($2d, 'mm:ss');
  InternalAdd($2e, '[h]:mm:ss');
  InternalAdd($2f, 'mm:ss.0');
  InternalAdd($30, '##0.0E+0');
  InternalAdd($31, '@');
end;

function TdxSpreadSheetPredefinedFormats.GenerateCurrencyFormat(
  const AFormatString, APattern, APatternZero: string; ABlindCurrencySymbol: Boolean = False): string;
begin
  Result := TdxSpreadSheetCurrencyFormatHelper.GenerateCurrencyFormat(
    dxFormatSettings, AFormatString, APattern, APatternZero, ABlindCurrencySymbol);
end;

procedure TdxSpreadSheetPredefinedFormats.InternalAdd(ID: Integer; const AFormatCode: string);
var
  AHandle: TdxSpreadSheetFormatHandle;
begin
  AHandle := GetFormatHandleByID(ID);
  if AHandle <> nil then
    AHandle.FormatCode := AFormatCode
  else
    Add(FOwner.AddFormat(AFormatCode, ID));
end;

{ TdxSpreadSheetCustomDataFormat }

constructor TdxSpreadSheetCustomDataFormat.Create(AFormats: TdxSpreadSheetFormats);
begin
  inherited Create;
  FFormats := AFormats;
end;

procedure TdxSpreadSheetCustomDataFormat.Assign(ADataFormat: TdxSpreadSheetCustomDataFormat);
begin
  FormatCode := ADataFormat.FormatCode;
end;

function TdxSpreadSheetCustomDataFormat.GetFormatCode: string;
begin
  Result := Handle.FormatCode;
end;

function TdxSpreadSheetCustomDataFormat.GetFormatCodeID: Integer;
begin
  Result := Handle.FormatCodeID;
end;

procedure TdxSpreadSheetCustomDataFormat.SetFormatCode(const AValue: string);
var
  ID: Integer;
begin
  if FormatCode <> AValue then
  begin
    ID := Formats.PredefinedFormats.GetIDByFormatCode(AValue);
    if ID >= 0 then
      FormatCodeID := ID
    else
      Handle := Formats.AddFormat(AValue);
  end;
end;

procedure TdxSpreadSheetCustomDataFormat.SetFormatCodeID(AValue: Integer);
var
  AHandle: TdxSpreadSheetFormatHandle;
begin
  if FormatCodeID <> AValue then
  begin
    AHandle := Formats.PredefinedFormats.GetFormatHandleByID(AValue);
    if AHandle = nil then
      raise EdxSpreadSheetError.CreateFmt(cxGetResourceString(@sdxErrorInvalidFormatCodeID), [AValue]);
    Handle := AHandle;
  end;
end;

{ TdxSpreadSheetFormats }

constructor TdxSpreadSheetFormats.Create(AStyles: TdxSpreadSheetCellStyles);
begin
  inherited Create;
  FStyles := AStyles;
  FPredefinedFormats := CreatePredefinedFormats;
  FDefaultFormat := PredefinedFormats.First;
  FDefaultFormat.AddRef;
end;

destructor TdxSpreadSheetFormats.Destroy;
begin
  FreeAndNil(FPredefinedFormats);
  FDefaultFormat.Release;
  FDefaultFormat := nil;
  inherited Destroy;
end;

function TdxSpreadSheetFormats.AddClone(const AFormat: TdxSpreadSheetFormatHandle): TdxSpreadSheetFormatHandle;
begin
  Result := AFormat;
  if Result = nil then
    Exit;
  Result := TdxSpreadSheetFormatHandle.Create(AFormat.FormatCode, AFormat.FormatCodeID);
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetFormats.AddFormat(const AFormatCode: string; AFormatCodeID: Integer = -1): TdxSpreadSheetFormatHandle;
begin
  Result := TdxSpreadSheetFormatHandle.Create(AFormatCode, AFormatCodeID);
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetFormats.CreateFromStream(AReader: TcxReader): TdxSpreadSheetFormatHandle;
var
  AValue: string;
  ACode: Integer;
begin
  AValue := AReader.ReadWideString;
  ACode := AReader.ReadInteger;
  Result := AddFormat(AValue, ACode);
end;

function TdxSpreadSheetFormats.IsCustom(AFormat: TdxSpreadSheetFormatHandle): Boolean;
begin
  Result := (AFormat.FormatCodeID < 0) or (PredefinedFormats.IndexOf(AFormat) < 0);
end;

function TdxSpreadSheetFormats.CreatePredefinedFormats: TdxSpreadSheetPredefinedFormats;
begin
  Result := TdxSpreadSheetPredefinedFormats.Create(Self);
end;

{ TdxSpreadSheetSharedImageHandle }

constructor TdxSpreadSheetSharedImageHandle.Create;
begin
  inherited Create(nil, 0);
  FImage := TdxSmartImage.Create;
end;

constructor TdxSpreadSheetSharedImageHandle.Create(AImage: TdxSmartImage);
begin
  Create;
  try
    Image.Assign(AImage);
    Image.HandleNeeded;
  except
    Image.Clear;
  end;
end;

constructor TdxSpreadSheetSharedImageHandle.Create(AStream: TStream);
begin
  Create;
  try
    Image.LoadFromStream(AStream);
    Image.HandleNeeded;
  except
    Image.Clear;
  end;
end;

destructor TdxSpreadSheetSharedImageHandle.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TdxSpreadSheetSharedImageHandle.CalculateHash(var AHash: Integer);
begin
  AHash := Image.GetHashCode;
end;

function TdxSpreadSheetSharedImageHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result := Image.Compare(TdxSpreadSheetSharedImageHandle(AItem).Image);
end;

{ TdxSpreadSheetSharedImages }

function TdxSpreadSheetSharedImages.Add(AStream: TStream): TdxSpreadSheetSharedImageHandle;
begin
  Result := TdxSpreadSheetSharedImageHandle.Create(AStream);
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetSharedImages.Add(const AFileName: string): TdxSpreadSheetSharedImageHandle;
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := Add(AStream);
  finally
    AStream.Free;
  end;
end;

function TdxSpreadSheetSharedImages.Add(AImage: TdxSmartImage): TdxSpreadSheetSharedImageHandle;
begin
  Result := TdxSpreadSheetSharedImageHandle.Create(AImage);
  CheckAndAddItem(Result);
end;

{ TdxSpreadSheetSharedString }

constructor TdxSpreadSheetSharedString.CreateObject(const AValue: string);
begin
  FValue := AValue;
  inherited Create(nil, 0);
end;

procedure TdxSpreadSheetSharedString.LoadFromStream(AReader: TcxReader);
var
  ALength: Integer;
begin
  ALength := AReader.ReadInteger;
  if ALength > 0 then
  begin
    SetLength(FValue, ALength);
    AReader.Stream.ReadBuffer(FValue[1], ALength * SizeOf(WideChar));
  end
  else
    FValue := '';
end;

procedure TdxSpreadSheetSharedString.SaveToStream(AWriter: TcxWriter);
var
  ALength: Integer;
begin
  ALength := Length(FValue);
  AWriter.WriteInteger(ObjectID);
  AWriter.WriteInteger(ALength);
  if ALength > 0 then
    AWriter.Stream.WriteBuffer(FValue[1], ALength * SizeOf(WideChar));
end;

procedure TdxSpreadSheetSharedString.CalculateHash(var AHash: Integer);
begin
  AddToHash(AHash, Value);
end;

function TdxSpreadSheetSharedString.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result := (ClassType = AItem.ClassType) and dxSameText(Value, TdxSpreadSheetSharedString(AItem).Value);
end;

class function TdxSpreadSheetSharedString.ObjectID: Integer;
begin
  Result := 0;
end;

{ TdxSpreadSheetSharedStringTable }

constructor TdxSpreadSheetSharedStringTable.Create(AFontTable: TdxSpreadSheetFonts);
begin
  inherited Create;
  FFontTable := AFontTable;
end;

function TdxSpreadSheetSharedStringTable.Add(const AValue: string): TdxSpreadSheetSharedString;
begin
  Result := Add(TdxSpreadSheetSharedString.CreateObject(AValue));
end;

function TdxSpreadSheetSharedStringTable.Add(AString: TdxSpreadSheetSharedString): TdxSpreadSheetSharedString;
begin
  Result := AString;
  CheckAndAddItem(Result);
end;

function TdxSpreadSheetSharedStringTable.LoadItemFromStream(AReader: TcxReader): TdxSpreadSheetSharedString;
begin
  Result := CreateStringClassByID(AReader.ReadInteger);
  Result.HashTable := Self;
  Result.LoadFromStream(AReader);
  Result := Add(Result);
end;

function TdxSpreadSheetSharedStringTable.CreateStringClassByID(const ID: Integer): TdxSpreadSheetSharedString;
begin
  if ID = 0 then
    Result := TdxSpreadSheetSharedString.CreateObject('')
  else
    Result := TdxSpreadSheetFormattedSharedString.CreateObject('')
end;

function TdxSpreadSheetSharedStringTable.GetUniqueCount: Integer;
var
  AUniqueCount: Integer;
begin
  AUniqueCount := 0;
  ForEach(
    procedure(AItem: TdxDynamicListItem)
    begin
      Inc(AUniqueCount);
    end);
  Result := AUniqueCount;
end;

{ TdxSpreadSheetFormattedSharedStringRun }

destructor TdxSpreadSheetFormattedSharedStringRun.Destroy;
begin
  FontHandle := nil;
  inherited Destroy;
end;

procedure TdxSpreadSheetFormattedSharedStringRun.Assign(ASource: TdxSpreadSheetFormattedSharedStringRun);
begin
  StartIndex := ASource.StartIndex;
  FontHandle := ASource.FontHandle;
  Tag := ASource.Tag;
end;

procedure TdxSpreadSheetFormattedSharedStringRun.Offset(ADelta: Integer);
begin
  Inc(FStartIndex, ADelta);
end;

procedure TdxSpreadSheetFormattedSharedStringRun.SetFontHandle(AValue: TdxSpreadSheetFontHandle);
begin
  dxChangeHandle(FFontHandle, AValue);
end;

{ TdxSpreadSheetFormattedSharedStringRuns }

function TdxSpreadSheetFormattedSharedStringRuns.Add: TdxSpreadSheetFormattedSharedStringRun;
begin
  Result := TdxSpreadSheetFormattedSharedStringRun.Create;
  inherited Add(Result);
end;

function TdxSpreadSheetFormattedSharedStringRuns.Add(AStartIndex: Integer;
  AFontHandle: TdxSpreadSheetFontHandle; ATag: TdxNativeUInt = 0): TdxSpreadSheetFormattedSharedStringRun;
begin
  Result := Add;
  Result.StartIndex := AStartIndex;
  Result.FontHandle := AFontHandle;
  Result.Tag := ATag;
end;

procedure TdxSpreadSheetFormattedSharedStringRuns.Append(ASource: TdxSpreadSheetFormattedSharedStringRuns);
var
  I: Integer;
begin
  Capacity := Max(Capacity, Count + ASource.Count);
  for I := 0 to ASource.Count - 1 do
    Add.Assign(ASource[I]);
end;

procedure TdxSpreadSheetFormattedSharedStringRuns.Assign(ASource: TdxSpreadSheetFormattedSharedStringRuns);
begin
  Clear;
  Append(ASource);
end;

procedure TdxSpreadSheetFormattedSharedStringRuns.Offset(ADelta: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    TdxSpreadSheetFormattedSharedStringRun(List[I]).Offset(ADelta);
end;

function TdxSpreadSheetFormattedSharedStringRuns.GetItem(Index: TdxListIndex): TdxSpreadSheetFormattedSharedStringRun;
begin
  Result := TdxSpreadSheetFormattedSharedStringRun(inherited Items[Index]);
end;

{ TdxSpreadSheetFormattedSharedString }

constructor TdxSpreadSheetFormattedSharedString.CreateObject(const AValue: string);
begin
  inherited CreateObject(AValue);
  FRuns := TdxSpreadSheetFormattedSharedStringRuns.Create;
end;

destructor TdxSpreadSheetFormattedSharedString.Destroy;
begin
  FreeAndNil(FRuns);
  inherited Destroy;
end;

procedure TdxSpreadSheetFormattedSharedString.LoadFromStream(AReader: TcxReader);
var
  AIndex, I: Integer;
  AFont: TdxSpreadSheetFontHandle;
begin
  inherited LoadFromStream(AReader);
  for I := 0 to AReader.ReadInteger - 1 do
  begin
    AIndex := AReader.ReadInteger;
    AFont := TdxSpreadSheetSharedStringTable(HashTable).FontTable.CreateFromStream(AReader);
    Runs.Add(AIndex, AFont);
  end;
end;

procedure TdxSpreadSheetFormattedSharedString.SaveToStream(AWriter: TcxWriter);
var
  I: Integer;
begin
  inherited SaveToStream(AWriter);
  AWriter.WriteInteger(Runs.Count);
  for I := 0 to Runs.Count - 1 do
  begin
    AWriter.WriteInteger(Runs[I].StartIndex);
    Runs[I].FontHandle.SaveToStream(AWriter);
  end;
end;

procedure TdxSpreadSheetFormattedSharedString.CalculateHash(var AHash: Integer);
var
  ARun: TdxSpreadSheetFormattedSharedStringRun;
  AValue: Cardinal;
  I: Integer;
begin
  AddToHash(AHash, Value);
  for I := 0 to Runs.Count - 1 do
  begin
    ARun := Runs[I];

    AValue := ARun.StartIndex;
    AddToHash(AHash, AValue, SizeOf(AValue));

    AValue := ARun.FontHandle.Key;
    AddToHash(AHash, AValue, SizeOf(AValue));
  end;
end;

function TdxSpreadSheetFormattedSharedString.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
var
  I: Integer;
begin
  Result := inherited DoIsEqual(AItem) and (Runs.Count = TdxSpreadSheetFormattedSharedString(AItem).Runs.Count);
  if Result then
    for I := 0 to Runs.Count - 1 do
    begin
      Result := Result and (Runs[I].StartIndex = TdxSpreadSheetFormattedSharedString(AItem).Runs[I].StartIndex);
      Result := Result and (Runs[I].FontHandle = TdxSpreadSheetFormattedSharedString(AItem).Runs[I].FontHandle);
      if not Result then
        Break;
    end;
end;

procedure TdxSpreadSheetFormattedSharedString.FontChanged(APrevFont, ANewFont: TdxSpreadSheetFontHandle);
var
  I: Integer;
  AFonts: TdxSpreadSheetFonts;
  ARunFont: TdxSpreadSheetFontHandle;
  AIsNameChanged: Boolean;
  AIncludeStyle, AExcludeStyle: TFontStyles;
begin
  AIncludeStyle := ANewFont.Style - APrevFont.Style;
  AExcludeStyle := APrevFont.Style - ANewFont.Style;
  AIsNameChanged := not SameText(APrevFont.Name, ANewFont.Name);
  AFonts := TdxSpreadSheetSharedStringTable(HashTable).FontTable;
  for I := 0 to Runs.Count - 1 do
  begin
    ARunFont := Runs[I].FontHandle.Clone;
    if APrevFont.Charset <> ANewFont.Charset then
      ARunFont.Charset := ANewFont.Charset;
    if APrevFont.Color <> ANewFont.Color then
      ARunFont.Color := ANewFont.Color;
    if AIsNameChanged then
      ARunFont.Name := ANewFont.Name;
    if APrevFont.Pitch <> ANewFont.Pitch then
      ARunFont.Pitch := ANewFont.Pitch;
    if APrevFont.Script <> ANewFont.Script then
      ARunFont.Script := ANewFont.Script;
    if APrevFont.Size <> ANewFont.Size then
      ARunFont.Size := ANewFont.Size;
    ARunFont.Style := ARunFont.Style + AIncludeStyle - AExcludeStyle;
    AFonts.CheckAndAddItem(ARunFont);
    Runs[I].FontHandle := ARunFont;
  end;
end;

class function TdxSpreadSheetFormattedSharedString.ObjectID: Integer;
begin
  Result := 1;
end;

{ TdxSpreadSheetCellStyleHandle }

constructor TdxSpreadSheetCellStyleHandle.Create(AOwner: TdxDynamicItemList; AIndex: Integer);
begin
  inherited Create(AOwner, AIndex);
  AlignVert := ssavBottom;
  States := States + [csLocked];
end;

destructor TdxSpreadSheetCellStyleHandle.Destroy;
begin
  Borders := nil;
  Brush := nil;
  DataFormat := nil;
  Font := nil;
  inherited Destroy;
end;

procedure TdxSpreadSheetCellStyleHandle.Assign(ASource: TdxSpreadSheetCellStyleHandle);
begin
  AssignFields(ASource);
  Font := ASource.Font;
  DataFormat := ASource.DataFormat;
  Brush := ASource.Brush;
  Borders := ASource.Borders;
end;

function TdxSpreadSheetCellStyleHandle.Clone: TdxSpreadSheetCellStyleHandle;
begin
  Result := TdxSpreadSheetCellStyleHandle.Create(nil, 0);
  Result.Assign(Self);
end;

procedure TdxSpreadSheetCellStyleHandle.LoadFromStream(AReader: TcxReader);
begin
  Byte(FAlignHorz) := AReader.ReadByte;
  Byte(FAlignVert) := AReader.ReadByte;
  FAlignHorzIndent := AReader.ReadInteger;
  FRotation := AReader.ReadInteger;
  AReader.Stream.ReadBuffer(FStates, SizeOf(FStates));
end;

procedure TdxSpreadSheetCellStyleHandle.SaveToStream(AWriter: TcxWriter);
begin
  Font.SaveToStream(AWriter);
  Brush.SaveToStream(AWriter);
  Borders.SaveToStream(AWriter);
  DataFormat.SaveToStream(AWriter);
  AWriter.WriteByte(Byte(AlignHorz));
  AWriter.WriteByte(Byte(AlignVert));
  AWriter.WriteInteger(AlignHorzIndent);
  AWriter.WriteInteger(Rotation);
  AWriter.Stream.WriteBuffer(FStates, SizeOf(FStates));
end;

procedure TdxSpreadSheetCellStyleHandle.AssignFields(ASource: TdxSpreadSheetCellStyleHandle);
begin
  AlignHorz := ASource.AlignHorz;
  AlignHorzIndent := ASource.AlignHorzIndent;
  AlignVert := ASource.AlignVert;
  States := ASource.States;
  Rotation := ASource.Rotation;
end;

procedure TdxSpreadSheetCellStyleHandle.CalculateHash(var AHash: Integer);
var
  AValue: Boolean;
  I: TdxSpreadSheetCellState;
begin
  AddToHash(AHash, AlignHorz, SizeOf(AlignHorz));
  AddToHash(AHash, AlignHorzIndent, SizeOf(AlignHorzIndent));
  AddToHash(AHash, AlignVert, SizeOf(AlignVert));
  AddToHash(AHash, Font, SizeOf(Font));
  AddToHash(AHash, DataFormat, SizeOf(DataFormat));
  AddToHash(AHash, Brush, SizeOf(Brush));
  AddToHash(AHash, Borders, SizeOf(Borders));
  AddToHash(AHash, Rotation, SizeOf(Rotation));

  for I := Low(I) to High(I) do
  begin
    AValue := I in States;
    AddToHash(AHash, AValue, SizeOf(AValue));
  end;
end;

function TdxSpreadSheetCellStyleHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
var
  I: TdxSpreadSheetCellState;
begin
  Result :=
    (AlignHorz = TdxSpreadSheetCellStyleHandle(AItem).AlignHorz) and
    (AlignHorzIndent = TdxSpreadSheetCellStyleHandle(AItem).AlignHorzIndent) and
    (AlignVert = TdxSpreadSheetCellStyleHandle(AItem).AlignVert) and
    (Rotation = TdxSpreadSheetCellStyleHandle(AItem).Rotation) and
    Font.IsEqual(TdxSpreadSheetCellStyleHandle(AItem).Font) and
    DataFormat.IsEqual(TdxSpreadSheetCellStyleHandle(AItem).DataFormat) and
    Brush.IsEqual(TdxSpreadSheetCellStyleHandle(AItem).Brush) and
    Borders.IsEqual(TdxSpreadSheetCellStyleHandle(AItem).Borders);

  if Result then
    for I := Low(I) to High(I) do
    begin
      Result := (I in States) = (I in TdxSpreadSheetCellStyleHandle(AItem).States);
      if not Result then
        Break;
    end;
end;

procedure TdxSpreadSheetCellStyleHandle.SetAlignHorzIndent(AValue: Integer);
begin
  FAlignHorzIndent := Max(0, Min(AValue, 250));
end;

procedure TdxSpreadSheetCellStyleHandle.SetBorders(AValue: TdxSpreadSheetBordersHandle);
begin
  dxChangeHandle(FBorders, AValue);
end;

procedure TdxSpreadSheetCellStyleHandle.SetBrush(AValue: TdxSpreadSheetBrushHandle);
begin
  dxChangeHandle(FBrush, AValue);
end;

procedure TdxSpreadSheetCellStyleHandle.SetDataFormat(AValue: TdxSpreadSheetFormatHandle);
begin
  dxChangeHandle(FDataFormat, AValue);
end;

procedure TdxSpreadSheetCellStyleHandle.SetFont(AValue: TdxSpreadSheetFontHandle);
begin
  dxChangeHandle(FFont, AValue);
end;

{ TdxSpreadSheetCellStyleHandleList }

function TdxSpreadSheetCellStyleHandleList.GetItem(Index: TdxListIndex): TdxSpreadSheetCellStyleHandle;
begin
  Result := TdxSpreadSheetCellStyleHandle(List[Index]);
end;

{ TdxSpreadSheetCellStyles }

constructor TdxSpreadSheetCellStyles.Create;
begin
  inherited Create;
  FFonts := CreateFonts;
  FBrushes := CreateBrushes;
  FFormats := CreateFormats;
  FBorders := CreateBorders;

  FDefaultStyle := CreateDefaultStyle;
  FDefaultStyle.FIsDefault := True;
  FDefaultStyle.AddRef;
  FDefaultStyle.CalculateHash;
  cxFormatController.AddListener(Self);
end;

destructor TdxSpreadSheetCellStyles.Destroy;
begin
  cxFormatController.RemoveListener(Self);
  FDefaultStyle.Release;
  Clear;
  FreeAndNil(FBorders);
  FreeAndNil(FBrushes);
  FreeAndNil(FFormats);
  FreeAndNil(FFonts);
  inherited Destroy;
end;

function TdxSpreadSheetCellStyles.AddClone(AStyle: TdxSpreadSheetCellStyleHandle): TdxSpreadSheetCellStyleHandle;
var
  AFont: TdxSpreadSheetFontHandle;
  ABrush: TdxSpreadSheetBrushHandle;
  ABorders: TdxSpreadSheetBordersHandle;
  ADataFormat: TdxSpreadSheetFormatHandle;
begin
  AFont := Fonts.AddClone(AStyle.Font);
  ABrush := Brushes.AddClone(AStyle.Brush);
  ABorders := Borders.AddClone(AStyle.Borders);
  ADataFormat := Formats.AddClone(AStyle.DataFormat);

  Result := CreateStyle(AFont, ADataFormat, ABrush, ABorders);
  Result.AssignFields(AStyle);

  Result := AddStyle(Result);
end;

function TdxSpreadSheetCellStyles.AddStyle(AStyle: TdxSpreadSheetCellStyleHandle): TdxSpreadSheetCellStyleHandle;
begin
  Result := AStyle;
  Result.CalculateHash;
  if (DefaultStyle.Index = Result.Index) and DefaultStyle.IsEqual(AStyle) then
  begin
    Result.Free;
    Result := DefaultStyle;
  end
  else
    CheckAndAddItem(Result);
end;

function TdxSpreadSheetCellStyles.CreateBorders: TdxSpreadSheetBorders;
begin
  Result := TdxSpreadSheetBorders.Create(Self);
end;

function TdxSpreadSheetCellStyles.CreateStyle(
  AFont: TdxSpreadSheetFontHandle = nil; AFormat: TdxSpreadSheetFormatHandle = nil;
  ABrush: TdxSpreadSheetBrushHandle = nil; ABorders: TdxSpreadSheetBordersHandle = nil): TdxSpreadSheetCellStyleHandle;
begin
  if AFont = nil then
    AFont := Fonts.DefaultFont;
  if AFormat = nil then
    AFormat := Formats.DefaultFormat;
  if ABrush = nil then
    ABrush := Brushes.DefaultBrush;
  if ABorders = nil then
    ABorders := Borders.DefaultBorders;

  Result := TdxSpreadSheetCellStyleHandle.Create(nil, 0);
  Result.Borders := ABorders;
  Result.DataFormat := AFormat;
  Result.Brush := ABrush;
  Result.Font := AFont;
end;

function TdxSpreadSheetCellStyles.CreateStyleFromStream(AReader: TcxReader): TdxSpreadSheetCellStyleHandle;
var
  AFont: TdxSpreadSheetFontHandle;
  ABrush: TdxSpreadSheetBrushHandle;
  ABorders: TdxSpreadSheetBordersHandle;
  ADataFormat: TdxSpreadSheetFormatHandle;
begin
  AFont := Fonts.CreateFromStream(AReader);
  ABrush := Brushes.CreateFromStream(AReader);
  ABorders := Borders.CreateFromStream(AReader);
  ADataFormat := Formats.CreateFromStream(AReader);

  Result := CreateStyle(AFont, ADataFormat, ABrush, ABorders);
  Result.LoadFromStream(AReader);
  Result := AddStyle(Result);
end;

function TdxSpreadSheetCellStyles.CreateDefaultStyle: TdxSpreadSheetCellStyleHandle;
begin
  Result := TdxSpreadSheetCellStyleHandle.Create(nil, 0);
  Result.HashTable := Self;
  Result.Font := Fonts.DefaultFont;
  Result.DataFormat := Formats.DefaultFormat;
  Result.Brush := Brushes.DefaultBrush;
  Result.Borders := Borders.DefaultBorders;
  Inc(FCount);
end;

function TdxSpreadSheetCellStyles.CreateBrushes: TdxSpreadSheetBrushes;
begin
  Result := TdxSpreadSheetBrushes.Create(Self);
end;

function TdxSpreadSheetCellStyles.CreateFonts: TdxSpreadSheetFonts;
begin
  Result := TdxSpreadSheetFonts.Create(Self);
end;

function TdxSpreadSheetCellStyles.CreateFormats: TdxSpreadSheetFormats;
begin
  Result := TdxSpreadSheetFormats.Create(Self);
end;

procedure TdxSpreadSheetCellStyles.DeleteItem(AItem: TdxHashTableItem);
begin
  if AItem = FDefaultStyle then
  begin
    Dec(FCount);
    FDefaultStyle := nil;
  end;
end;

function TdxSpreadSheetCellStyles._AddRef: Integer;
begin
  Result := -1;
end;

function TdxSpreadSheetCellStyles._Release: Integer;
begin
  Result := -1;
end;

function TdxSpreadSheetCellStyles.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := cxE_NOINTERFACE;
end;

procedure TdxSpreadSheetCellStyles.FormatChanged;
begin
  Formats.PredefinedFormats.Refresh;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{ TdxSpreadSheetFormattedSharedStringCache }

constructor TdxSpreadSheetFormattedSharedStringCache.Create;
begin
  inherited Create;
  FList := TList.Create;
  FItems := TObjectDictionary<TKey, TObject>.Create([doOwnsKeys, doOwnsValues]);
end;

destructor TdxSpreadSheetFormattedSharedStringCache.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TdxSpreadSheetFormattedSharedStringCache.Clear;
begin
  FItems.Clear;
  FList.Clear;
end;

procedure TdxSpreadSheetFormattedSharedStringCache.AddRender(
  AString: TdxSpreadSheetSharedString; ADefaultFontHandle: TdxSpreadSheetFontHandle; const ARender: TObject);
var
  AKey: TKey;
begin
  AKey := TKey.Create(AString, ADefaultFontHandle);
  if FItems.ContainsKey(AKey) then
  begin
    ARender.Free;
    AKey.Free;
  end
  else
  begin
    FItems.Add(AKey, ARender);
    FList.Add(AKey);
    if FList.Count > MaxCount then
    begin
      FItems.Remove(FList.First);
      FList.Delete(0);
    end;
  end;
end;

function TdxSpreadSheetFormattedSharedStringCache.TryGetRender(
  AString: TdxSpreadSheetSharedString; ADefaultFontHandle: TdxSpreadSheetFontHandle; out ARender: TObject): Boolean;
var
  AKey: TKey;
begin
  AKey := TKey.Create(AString, ADefaultFontHandle);
  try
    Result := FItems.TryGetValue(AKey, ARender);
  finally
    AKey.Free;
  end;
end;

procedure TdxSpreadSheetFormattedSharedStringCache.RemoveItems(ADefaultFontHandle: TdxSpreadSheetFontHandle);
var
  AKey: TKey;
  I: Integer;
begin
  for I := FList.Count - 1 downto 0 do
  begin
    AKey := TKey(FList.List[I]);
    if AKey.FDefaultFontHandle = ADefaultFontHandle then
    begin
      FItems.Remove(AKey);
      FList.Delete(I);
    end;
  end;
end;

procedure TdxSpreadSheetFormattedSharedStringCache.RemoveItems(AString: TdxSpreadSheetSharedString);
var
  AKey: TKey;
  I: Integer;
begin
  for I := FList.Count - 1 downto 0 do
  begin
    AKey := TKey(FList.List[I]);
    if AKey.FString = AString then
    begin
      FItems.Remove(AKey);
      FList.Delete(I);
    end;
  end;
end;

{ TdxSpreadSheetFormattedSharedStringCache.TKey }

constructor TdxSpreadSheetFormattedSharedStringCache.TKey.Create(
  AString: TdxSpreadSheetSharedString; ADefaultFontHandle: TdxSpreadSheetFontHandle);
begin
  dxChangeHandle(FString, AString);
  dxChangeHandle(FDefaultFontHandle, ADefaultFontHandle);
end;

destructor TdxSpreadSheetFormattedSharedStringCache.TKey.Destroy;
begin
  dxChangeHandle(FDefaultFontHandle, nil);
  dxChangeHandle(FString, nil);
  inherited;
end;

function TdxSpreadSheetFormattedSharedStringCache.TKey.Equals(Obj: TObject): Boolean;
begin
  Result := (Obj is TKey) and (TKey(Obj).FString = FString) and (TKey(Obj).FDefaultFontHandle = FDefaultFontHandle);
end;

function TdxSpreadSheetFormattedSharedStringCache.TKey.GetHashCode: Integer;
begin
  Result := FString.GetHashCode xor FDefaultFontHandle.GetHashCode;
end;

end.
