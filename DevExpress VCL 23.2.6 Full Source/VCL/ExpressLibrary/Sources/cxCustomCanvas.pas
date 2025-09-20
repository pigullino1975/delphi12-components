
{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
{   ACCOMPANYING VCL AND CLX CONTROLS AS PART OF AN EXECUTABLE       }
{   PROGRAM ONLY.                                                    }
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

unit cxCustomCanvas;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHIXE8}
  System.Hash,
  System.ImageList,
{$ENDIF}
  UITypes,
  Types, Windows, SysUtils, Generics.Collections, Generics.Defaults, Classes, Graphics, Controls, ImgList,
  cxGeometry, dxCore, dxCoreClasses, dxSmartImage, dxGDIPlusAPI, dxGDIPlusClasses, dxCoreGraphics, dxGenerics,
  cxDrawTextUtils, dxDPIAwareUtils, dxHash, dxHashUtils;

const
  sdxInternalErrorFontNotSet = 'Font is not set';
  sdxInternalErrorResourceAbandoned = 'Resource is in abandoned state';
  sdxInternalErrorResourceOwnerMismatch = 'Resource was created for different Canvas';

type
  TcxRotationAngle = (ra0, raPlus90, raMinus90, ra180);
  TcxImageDrawMode = (idmNormal, idmDisabled, idmFaded, idmGrayScale, idmDingy, idmShadowed);

  TcxCanvasBasedFont = class;
  TcxCanvasBasedPen = class;
  TcxCanvasBasedBrush = class;
  TcxCustomCanvas = class;

  { IcxControlCanvas }

  IcxControlCanvas = interface
  ['{E40B5E3C-CD3C-4D2C-81DA-2A41800CA183}']
    procedure BeginPaint;
    procedure EndPaint;
  end;

  { IcxControlDirectCanvas }

  IcxControlDirectCanvas = interface(IcxControlCanvas)
  ['{0920AC2D-5CED-4DF4-ABCB-4D12248AC63D}']
    procedure CopyToDC(DC: HDC); overload;
    procedure CopyToDC(DC: HDC; const ATargetRect, ASourceRect: TRect); overload;
    procedure SetWndHandle(AHandle: HWND);
  end;

  { IcxCanvasCacheControl }

  IcxCanvasCacheControl = interface
  ['{A1DEDC74-DBA2-4EAC-BC91-5016E48F4E7B}']
    procedure FlushCache;
  end;

  { IcxCanvasBuffer }

  IcxCanvasBuffer = interface
  ['{C5B683CB-EC4A-41AA-AE0D-DBF0EE320C9C}']
    procedure CopyToDC(DC: HDC);
    procedure Invalidate;
    function IsValid: Boolean;
  end;

  { IcxCustomCanvasSupport }

  IcxCustomCanvasSupport = interface
  ['{F0C3C819-F9BB-4ECF-97D0-F274B0EBB658}']
  end;


  { TdxFillOptions }

{$SCOPEDENUMS ON}

  TdxFillOptionsMode = (
    Clear,
    Solid,
    Gradient,
    Texture,
    Hatch
  );

  TdxFillOptionsGradientMode = (
    Horizontal,
    Vertical,
    ForwardDiagonal,
    BackwardDiagonal
  );

  TdxFillOptionsHatchStyle = (
    Horizontal,
    Vertical,
    ForwardDiagonal,
    BackwardDiagonal,
    Cross,
    DiagonalCross,
    Percent05,
    Percent10,
    Percent20,
    Percent25,
    Percent30,
    Percent40,
    Percent50,
    Percent60,
    Percent70,
    Percent75,
    Percent80,
    Percent90,
    LightDownwardDiagonal,
    LightUpwardDiagonal,
    DarkDownwardDiagonal,
    DarkUpwardDiagonal,
    WideDownwardDiagonal,
    WideUpwardDiagonal,
    LightVertical,
    LightHorizontal,
    NarrowVertical,
    NarrowHorizontal,
    DarkVertical,
    DarkHorizontal,
    DashedDownwardDiagonal,
    DashedUpwardDiagonal,
    DashedHorizontal,
    DashedVertical,
    SmallConfetti,
    LargeConfetti,
    ZigZag,
    Wave,
    DiagonalBrick,
    HorizontalBrick,
    Weave,
    Plaid,
    Divot,
    DottedGrid,
    DottedDiamond,
    Shingle,
    Trellis,
    Sphere,
    SmallGrid,
    SmallCheckerBoard,
    LargeCheckerBoard,
    OutlinedDiamond,
    SolidDiamond
  );

  { TdxFillOptions }

  TdxFillOptions = class(TcxLockablePersistent, IcxCanvasCacheControl)
  strict private
    FColor: TdxAlphaColor;
    FColor2: TdxAlphaColor;
    FGradientMode: TdxFillOptionsGradientMode;
    FHatchStyle: TdxFillOptionsHatchStyle;
    FMode: TdxFillOptionsMode;
    FTexture: TdxSmartImage;

    FOnChange: TNotifyEvent;

    FCachedBrush: TcxCanvasBasedBrush;

    function GetActualColor: TdxAlphaColor;
    function GetActualColor2: TdxAlphaColor;
    procedure SetColor(AValue: TdxAlphaColor);
    procedure SetColor2(AValue: TdxAlphaColor);
    procedure SetGradientMode(AValue: TdxFillOptionsGradientMode);
    procedure SetHatchStyle(AValue: TdxFillOptionsHatchStyle);
    procedure SetMode(AValue: TdxFillOptionsMode);
    procedure SetTexture(AValue: TdxSmartImage);

    function IsModeStored: Boolean;
    function IsTextureStored: Boolean;
    procedure TextureChangeHandler(Sender: TObject);
  protected
    FOnGetDefaultColor: TdxAlphaColorFunc;
    FOnGetDefaultColor2: TdxAlphaColorFunc;

    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;
  public
    constructor Create(AOwner: TPersistent); overload; override;
    constructor Create(AOwner: TPersistent; AGetDefaultColorFunc, AGetDefaultColor2Func: TdxAlphaColorFunc); reintroduce; overload;
    destructor Destroy; override;
  {$REGION 'for internal use'}
    procedure FlushCache;
    function GetHandle(ACanvas: TcxCustomCanvas): TcxCanvasBasedBrush;
  {$ENDREGION}

    property ActualColor: TdxAlphaColor read GetActualColor;
    property ActualColor2: TdxAlphaColor read GetActualColor2;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Color: TdxAlphaColor read FColor write SetColor default TdxAlphaColors.Default;
    property Color2: TdxAlphaColor read FColor2 write SetColor2 default TdxAlphaColors.Default;
    property GradientMode: TdxFillOptionsGradientMode read FGradientMode write SetGradientMode default TdxFillOptionsGradientMode.Horizontal;
    property HatchStyle: TdxFillOptionsHatchStyle read FHatchStyle write SetHatchStyle default TdxFillOptionsHatchStyle.Horizontal;
    property Texture: TdxSmartImage read FTexture write SetTexture stored IsTextureStored;
    property Mode: TdxFillOptionsMode read FMode write SetMode stored IsModeStored;
  end;

  { TdxStrokeOptions }

  TdxStrokeStyle = (Solid, Dash, Dot, DashDot, DashDotDot);

  TdxStrokeOptions = class(TcxLockablePersistent, IcxCanvasCacheControl)
  strict private
    FColor: TdxAlphaColor;
    FStyle: TdxStrokeStyle;
    FWidth: Single;

    FOnChange: TNotifyEvent;

    FCachedPen: TcxCanvasBasedPen;

    function GetActualColor: TdxAlphaColor;
    function IsWidthStored: Boolean;
    procedure SetColor(AValue: TdxAlphaColor);
    procedure SetStyle(AValue: TdxStrokeStyle);
    procedure SetWidth(AValue: Single);
  protected
    FOnGetDefaultColor: TdxAlphaColorFunc;

    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;
    procedure DoChangeScale(M, D: Integer); virtual;
  public
    constructor Create(AOwner: TPersistent); overload; override;
    constructor Create(AOwner: TPersistent; AGetDefaultColorFunc: TdxAlphaColorFunc); reintroduce; overload;
    destructor Destroy; override;
    procedure ChangeScale(M, D: Integer);
  {$REGION 'for internal use'}
    procedure FlushCache;
    function GetHandle(ACanvas: TcxCustomCanvas): TcxCanvasBasedPen;
  {$ENDREGION}

    property ActualColor: TdxAlphaColor read GetActualColor;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Color: TdxAlphaColor read FColor write SetColor default TdxAlphaColors.Default;
    property Style: TdxStrokeStyle read FStyle write SetStyle default TdxStrokeStyle.Solid;
    property Width: Single read FWidth write SetWidth stored IsWidthStored;
  end;

  { TdxFontOptions }

  TdxFontPitch = (Default, Fixed, Variable); 
  TdxFontQuality = (Default, Draft, Proof, NonAntialiased, Antialiased, ClearType, ClearTypeNatural); 

  TdxFontOptions = class(TcxLockablePersistent, IcxCanvasCacheControl)
  strict private
    FBold: Boolean;
    FCharset: TFontCharset;
    FHeight: Integer;
    FItalic: Boolean;
    FName: TFontName;
    FPitch: TdxFontPitch;
    FQuality: TdxFontQuality;
    FStrikeOut: Boolean;
    FUnderline: Boolean;

    FCachedFont: TcxCanvasBasedFont;

    FOnChange: TNotifyEvent;
  protected
    FDefaultName: string;
    FDefaultSize: Integer;

    procedure AssignTo(Dest: TPersistent); override;
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;

    function GetBold: Boolean; virtual;
    function GetCharset: TFontCharset; virtual;
    function GetHeight: Integer; virtual;
    function GetItalic: Boolean; virtual;
    function GetName: TFontName; virtual;
    function GetPitch: TdxFontPitch; virtual;
    function GetQuality: TdxFontQuality; virtual;
    function GetSize: Integer;
    function GetStrikeOut: Boolean; virtual;
    function GetStyle: TFontStyles;
    function GetUnderline: Boolean; virtual;
    function IsBoldStored: Boolean; virtual;
    function IsCharsetStored: Boolean; virtual;
    function IsItalicStored: Boolean; virtual;
    function IsNameStored: Boolean; virtual;
    function IsPitchStored: Boolean; virtual;
    function IsQualityStored: Boolean; virtual;
    function IsSizeStored: Boolean; virtual;
    function IsStrikeOutStored: Boolean; virtual;
    function IsUnderlineStored: Boolean; virtual;
    procedure SetBold(const AValue: Boolean); virtual;
    procedure SetCharset(AValue: TFontCharset); virtual;
    procedure SetHeight(AValue: Integer); virtual;
    procedure SetItalic(const AValue: Boolean); virtual;
    procedure SetName(const AValue: TFontName); virtual;
    procedure SetPitch(AValue: TdxFontPitch); virtual;
    procedure SetQuality(AValue: TdxFontQuality); virtual;
    procedure SetSize(AValue: Integer);
    procedure SetStrikeOut(const AValue: Boolean); virtual;
    procedure SetStyle(AValue: TFontStyles);
    procedure SetUnderline(const AValue: Boolean); virtual;
    class function SizeToHeight(ASize: Integer): Integer;
  public
    constructor Create(AOwner: TPersistent); overload; override;
    constructor Create(AOwner: TPersistent; const ADefaultName: TFontName; const ADefaultSize: Integer); reintroduce; overload;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure ChangeScale(M, D: Integer); virtual;
  {$REGION 'for internal use'}
    procedure FlushCache;
    function GetHandle(ACanvas: TcxCustomCanvas): TcxCanvasBasedFont;
  {$ENDREGION}

    property Height: Integer read GetHeight write SetHeight;
    property Style: TFontStyles read GetStyle write SetStyle;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Bold: Boolean read GetBold write SetBold stored IsBoldStored;
    property Charset: TFontCharset read GetCharset write SetCharset stored IsCharsetStored;
    property Italic: Boolean read GetItalic write SetItalic stored IsItalicStored;
    property Name: TFontName read GetName write SetName stored IsNameStored;
    property Pitch: TdxFontPitch read GetPitch write SetPitch stored IsPitchStored;
    property Quality: TdxFontQuality read GetQuality write SetQuality stored IsQualityStored;
    property Size: Integer read GetSize write SetSize stored IsSizeStored;
    property StrikeOut: Boolean read GetStrikeOut write SetStrikeOut stored IsStrikeOutStored;
    property Underline: Boolean read GetUnderline write SetUnderline stored IsUnderlineStored;
  end;


  TdxFontOptionsValue = (Bold, Charset, Italic, Name, Pitch, Quality, Size, StrikeOut, Underline);
  TdxFontOptionsValues = set of TdxFontOptionsValue;

  TdxChildFontOptions = class abstract(TdxFontOptions)
  strict private
    FAssignedValues: TdxFontOptionsValues;
    procedure SetAssignedValues(const AValue: TdxFontOptionsValues);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetBold: Boolean; override;
    function GetCharset: TFontCharset; override;
    function GetHeight: Integer; override;
    function GetItalic: Boolean; override;
    function GetParent: TdxFontOptions; virtual; abstract;
    function GetName: TFontName; override;
    function GetPitch: TdxFontPitch; override;
    function GetQuality: TdxFontQuality; override;
    function GetStrikeOut: Boolean; override;
    function GetUnderline: Boolean; override;
    function IsBoldStored: Boolean; override;
    function IsCharsetStored: Boolean; override;
    function IsItalicStored: Boolean; override;
    function IsNameStored: Boolean; override;
    function IsPitchStored: Boolean; override;
    function IsQualityStored: Boolean; override;
    function IsSizeStored: Boolean; override;
    function IsStrikeOutStored: Boolean; override;
    function IsUnderlineStored: Boolean; override;
    procedure SetBold(const AValue: Boolean); override;
    procedure SetCharset(AValue: TFontCharset); override;
    procedure SetHeight(AValue: Integer); override;
    procedure SetItalic(const AValue: Boolean); override;
    procedure SetName(const AValue: TFontName); override;
    procedure SetPitch(AValue: TdxFontPitch); override;
    procedure SetQuality(AValue: TdxFontQuality); override;
    procedure SetStrikeOut(const AValue: Boolean); override;
    procedure SetUnderline(const AValue: Boolean); override;
  published
    property AssignedValues: TdxFontOptionsValues read FAssignedValues write SetAssignedValues stored False;
  end;

{$SCOPEDENUMS OFF}


  TcxGdiBasedCanvas = class;

{$REGION 'for internal use'}
  TcxCanvasBasedResourceHandle = class;
  TcxCanvasBasedImageListHandle = class;
  TcxCanvasBasedTextLayoutCustomTransform = class;

  { TcxCanvasBasedResource }

  PcxCanvasBasedResource = ^TcxCanvasBasedResource;
  TcxCanvasBasedResource = class
  strict private
    FCanvas: TcxCustomCanvas;
    FHandle: TcxCanvasBasedResourceHandle;
  protected
    procedure CheckState;
  public
    constructor Create(ACanvas: TcxCustomCanvas; AHandle: TcxCanvasBasedResourceHandle = nil);
    procedure BeforeDestruction; override;
    function IsEmpty: Boolean; virtual;
    procedure Release; virtual;
    //
    property Canvas: TcxCustomCanvas read FCanvas;
    property Handle: TcxCanvasBasedResourceHandle read FHandle;
  end;

  { TcxCanvasBasedResourceCacheKey }

  TcxCanvasBasedResourceCacheKey = packed record
    Owner: Pointer;
    Size: TSize;
    Part: Integer;
    State: Integer;
    TargetDPI: Word;

    class function Create(AOwner: Pointer; const ASize: TSize; AState: Integer;
      APart: Integer = 0; ATargetDPI: Word = dxDefaultDPI): TcxCanvasBasedResourceCacheKey; static;
  end;

  { TcxCanvasBasedResourceHandle }

  TcxCanvasBasedResourceHandle = class(TdxHashTableItem)
  protected
    procedure CreateNativeHandle(ACanvas: TcxCustomCanvas); virtual; abstract;
    procedure FreeNativeHandle; virtual; abstract;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function IsEmpty: Boolean; virtual;
  end;

  { TcxCanvasBasedSharedResources }

  TcxCanvasBasedSharedResources = class(TcxCanvasBasedResource)
  strict private
    FHashTable: TdxHashTable;
  public
    constructor Create(ACanvas: TcxCustomCanvas);
    destructor Destroy; override;
    procedure Release; override;
    function Share(AResource: TcxCanvasBasedResourceHandle): TcxCanvasBasedResourceHandle;
  end;

  { TcxCanvasBasedBrush }

  TcxCanvasBasedBrush = class(TcxCanvasBasedResource);

  { TcxCanvasBasedBrushHandle }

  TcxCanvasBasedBrushHandleClass = class of TcxCanvasBasedBrushHandle;
  TcxCanvasBasedBrushHandle = class(TcxCanvasBasedResourceHandle)
  protected
    FColor1: TdxAlphaColor;
    FColor2: TdxAlphaColor;
    FGradientMode: TdxGPBrushGradientMode;
    FHatchStyle: TdxGpHatchStyle;
    FMode: TdxFillOptionsMode;
    FTexture: TdxSmartImage;

    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
    constructor Create(AColor: TdxAlphaColor); reintroduce; overload;
    constructor Create(AOptions: TdxFillOptions); reintroduce; overload;
    destructor Destroy; override;
  end;

  { TcxCanvasBasedFont }

  TcxCanvasBasedFont = class(TcxCanvasBasedResource)
  strict private
    function GetLineHeight: Integer; inline;
  public
    function IsEmpty: Boolean; override;
    //
    property LineHeight: Integer read GetLineHeight;
  end;

  { TcxCanvasBasedFontHandle }

  TcxCanvasBasedFontHandleClass = class of TcxCanvasBasedFontHandle;
  TcxCanvasBasedFontHandle = class(TcxCanvasBasedResourceHandle)
  strict private
    FLineHeight: Integer;
  protected
    FCharset: TFontCharset;
    FHeight: Integer;
    FName: TFontName;
    FPitch: TdxFontPitch;
    FQuality: TdxFontQuality;
    FStyle: TFontStyles;

    procedure CalculateHash(var AHash: Integer); override;
    procedure Initialize(AFont: TFont);
    function DoGetLineHeight(ACanvas: TcxCustomCanvas): Integer; virtual;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
    constructor Create(const AFont: TFont; AOwnership: TdxObjectOwnership = ooCloned); overload; virtual;
    constructor Create(const AFont: TdxFontOptions); overload;
    function GetLineHeight(ACanvas: TcxCustomCanvas): Integer;
    //
    property Style: TFontStyles read FStyle;
  end;

  { TcxCanvasBasedImage }

  PcxCanvasBasedImage = ^TcxCanvasBasedImage;
  TcxCanvasBasedImage = class(TcxCanvasBasedResource)
  strict private
    FHeight: Integer;
    FWidth: Integer;

    function GetClientRect: TRect; inline;
    function GetSize: TSize; inline;
  public
    constructor Create(ACanvas: TcxCustomCanvas; AWidth, AHeight: Integer);
    procedure Draw(const ATargetRect: TdxRectF; AAlpha: Byte = MaxByte); overload; virtual;
    procedure Draw(const ATargetRect: TRect; AAlpha: Byte = MaxByte); overload; virtual;
    procedure Draw(const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte = MaxByte); overload; virtual;
    procedure Draw(const ATargetRect, ASourceRect: TRect; AAlpha: Byte = MaxByte); overload; virtual;
    function IsEmpty: Boolean; override;

    property ClientRect: TRect read GetClientRect;
    property Height: Integer read FHeight;
    property Size: TSize read GetSize;
    property Width: Integer read FWidth;
  end;

  { TcxCanvasBasedImageList }

  TcxCanvasBasedImageList = class(TcxCanvasBasedResource)
  strict private
    function GetHandle: TcxCanvasBasedImageListHandle;
    function TryGetImage(AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode;
      const AColorPalette: IdxColorPalette; out AImage: TcxCanvasBasedImage): Boolean;
  public
    procedure Draw(const R: TdxRectF; AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode;
      AAlpha: Byte = MaxByte; const AColorPalette: IdxColorPalette = nil); overload;
    procedure Draw(const R: TdxRectF; AImageIndex: Integer; AMode: TcxImageDrawMode;
      AAlpha: Byte = MaxByte; const AColorPalette: IdxColorPalette = nil); overload;
    procedure Draw(const R: TRect; AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode;
      AAlpha: Byte = MaxByte; const AColorPalette: IdxColorPalette = nil); overload;
    procedure Draw(const R: TRect; AImageIndex: Integer; AMode: TcxImageDrawMode;
      AAlpha: Byte = MaxByte; const AColorPalette: IdxColorPalette = nil); overload;
    function GetSize(AScaleFactor: TdxScaleFactor): TSize;
    //
    property Handle: TcxCanvasBasedImageListHandle read GetHandle;
  end;

  { TcxCanvasBasedImageListHandle }

  TcxCanvasBasedImageListHandleClass = class of TcxCanvasBasedImageListHandle;
  TcxCanvasBasedImageListHandle = class(TcxCanvasBasedResourceHandle)
  strict private
    FCache: TObject;
    FChangeLink: TChangeLink;
    FUseNativeDrawing: Boolean;

    procedure ChangeHandler(Sender: TObject);
  protected
    FImageList: TCustomImageList;

    procedure CalculateHash(var AHash: Integer); override;
    procedure CreateNativeHandle(ACanvas: TcxCustomCanvas); override;
    procedure FreeNativeHandle; override;

    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
    constructor Create(AImageList: TCustomImageList);
    function GetSize(AScaleFactor: TdxScaleFactor): TSize;
    function IsEmpty: Boolean; override;
    function TryGetImage(ACanvas: TcxCustomCanvas; AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode;
      const AColorPalette: IdxColorPalette; out AImage: TcxCanvasBasedImage): Boolean;
  end;

  { TcxCanvasBasedImageListMap }

  TcxCanvasBasedImageListMap = class(TcxCanvasBasedResource)
  strict private
    FFreeNotificator: TcxFreeNotificator;
    FMap: TdxObjectDictionary;

    procedure FreeNotificationHandler(Sender: TComponent);
  public
    constructor Create(ACanvas: TcxCustomCanvas);
    destructor Destroy; override;
    procedure Clear;
    function GetOrCreate(AImageList: TCustomImageList): TcxCanvasBasedImageList;
    procedure Remove(AImageList: TCustomImageList);
  end;

  { TcxCanvasBasedPath }

  TcxCanvasBasedPath = class(TcxCanvasBasedResource)
  public
    // Commands
    procedure AddArc(const AEllipse: TdxRectF; const AStartAngle, ASweepAngle: Single); virtual; abstract;
    procedure AddLine(const P1, P2: TdxPointF); virtual;
    procedure AddPolyline(const Points: array of TdxPointF); overload;
    procedure AddPolyline(Points: PdxPointF; Count: Integer); overload; virtual; abstract;
    // General
    procedure FigureClose; virtual; abstract;
    procedure FigureStart; virtual; abstract;
  end;

  { TcxCanvasBasedPen }

  TcxCanvasBasedPen = class(TcxCanvasBasedResource);

  { TcxCanvasBasedPenHandle }

  TcxCanvasBasedPenHandleClass = class of TcxCanvasBasedPenHandle;
  TcxCanvasBasedPenHandle = class(TcxCanvasBasedResourceHandle)
  protected
    FColor: TdxAlphaColor;
    FStyle: TdxStrokeStyle;
    FWidth: Single;

    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
  public
    constructor Create(AColor: TdxAlphaColor; AWidth: Single; AStyle: TdxStrokeStyle); reintroduce; overload;
    constructor Create(AOptions: TdxStrokeOptions); reintroduce; overload;

    property Color: TdxAlphaColor read FColor;
    property Style: TdxStrokeStyle read FStyle;
    property Width: Single read FWidth;
  end;

  { TcxCanvasBasedTextLayout }

  TcxCanvasBasedTextLayout = class(TcxCanvasBasedResource)
  strict private
    FFill: TcxCanvasBasedBrushHandle;
    FIsDirty: Boolean;
    FMaxHeight: Integer;
    FMaxRowCount: Integer;
    FMaxWidth: Integer;
    FPadding: TRect;
    FSize: TSize;
    FStroke: TcxCanvasBasedPenHandle;

    function CalculateOrigin(const ARect: TRect; const ASize: TSize): TPoint;
    function FloatRectToRect(const R: TdxRectF): TRect;
    procedure SetTransform(ATransform: TcxCanvasBasedTextLayoutCustomTransform);
  protected
    FFlags: Integer;
    FFontHandle: TcxCanvasBasedFontHandle;
    FPaintOnGlass: Boolean;
    FRowCount: Integer;
    FText: string;
    FTextSize: TSize;
    FTextTruncated: Boolean;
    FTransform: TcxCanvasBasedTextLayoutCustomTransform;

    procedure ApplyFlags; virtual;
    function CalculateRowCount(AMaxHeight, ARowHeight: Single): Integer;
    procedure CheckCalculated; inline;
    procedure DoCalculate; overload;
    procedure DoCalculate(AMaxWidth, AMaxHeight, AMaxRowCount: Integer); overload; virtual; abstract;
    procedure DoDraw(const R: TRect); virtual; abstract;
    procedure DoSetFont(AFontHandle: TcxCanvasBasedFontHandle); virtual;
    procedure FontChanged; virtual;
    procedure LayoutChanged; virtual;
    procedure TextChanged; virtual;
  public
    destructor Destroy; override;
    procedure Draw(const ARect: TdxRectF); overload;
    procedure Draw(const ARect: TRect); overload; virtual;
    function IsTruncated: Boolean; virtual;
    function MeasureSize: TSize;
    function MeasureSizeF: TdxSizeF;
    procedure Release; override;
    procedure SetColor(AColor: TColor); overload;
    procedure SetColor(AColor: TdxAlphaColor); overload; virtual; abstract;
    procedure SetBackgroundAppearance(AFill: TcxCanvasBasedBrush; AStroke: TcxCanvasBasedPen);
    procedure SetFlag(ACxToFlag: Integer; AFlagState: Boolean);
    procedure SetFlags(ACxTOFlags: Integer); virtual;
    procedure SetFont(AFont: TcxCanvasBasedFont; AOwnership: TdxObjectOwnership = ooReferenced); overload;
    procedure SetFont(AFont: TFont; AOwnership: TdxObjectOwnership = ooReferenced); overload;
    procedure SetLayoutConstraints(AMaxWidth, AMaxHeight: Integer; AMaxRowCount: Integer = 0); overload;
    procedure SetLayoutConstraints(const R: TdxRectF; AMaxRowCount: Integer = 0); overload;
    procedure SetLayoutConstraints(const R: TRect; AMaxRowCount: Integer = 0); overload;
    procedure SetPadding(const APadding: TRect);
    procedure SetPaintOnGlass(AValue: Boolean);
    procedure SetRotation(AAngle: Single); overload;
    procedure SetRotation(AAngle: TcxRotationAngle); overload;
    procedure SetText(const AText: string); virtual;
    //
    property Text: string read FText write SetText;
  end;

  { TcxCanvasBasedTextLayoutCustomTransform }

  TcxCanvasBasedTextLayoutCustomTransform = class
  strict private
    FAngle: Single;
    FMatrix: TXForm;
  public
    constructor Create(const AAngle: Single);
    procedure CalculateConstraints(var AMaxWidth, AMaxHeight: Integer); virtual; abstract;
    procedure CalculateSize(var ASize: TSize); virtual; abstract;
    function Equals(const AAngle: Single): Boolean; reintroduce; overload;
    function Equals(const AAngle: TcxRotationAngle): Boolean; reintroduce; overload;
    //
    property Angle: Single read FAngle;
    property Matrix: TXForm read FMatrix;
  end;

  { TcxCanvasBasedSharedBrushes }

  TcxCanvasBasedSharedBrushes = class(TcxCanvasBasedSharedResources)
  strict private
    FClass: TcxCanvasBasedBrushHandleClass;
  public
    constructor Create(ACanvas: TcxCustomCanvas; AClass: TcxCanvasBasedBrushHandleClass);
    function GetOrCreate(AColor: TdxAlphaColor): TcxCanvasBasedBrushHandle; overload;
    function GetOrCreate(AOptions: TdxFillOptions): TcxCanvasBasedBrushHandle; overload;
  end;

  { TcxCanvasBasedSharedFonts }

  TcxCanvasBasedSharedFonts = class(TcxCanvasBasedSharedResources)
  strict private
    FClass: TcxCanvasBasedFontHandleClass;
  public
    constructor Create(ACanvas: TcxCustomCanvas; AClass: TcxCanvasBasedFontHandleClass);
    function GetOrCreate(const AFont: TdxFontOptions): TcxCanvasBasedFontHandle; overload;
    function GetOrCreate(const AFont: TFont; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedFontHandle; overload;
  end;

  { TcxCanvasBasedSharedImageLists }

  TcxCanvasBasedSharedImageLists = class(TcxCanvasBasedSharedResources)
  strict private
    FClass: TcxCanvasBasedImageListHandleClass;
  public
    constructor Create(ACanvas: TcxCustomCanvas; AClass: TcxCanvasBasedImageListHandleClass);
    function GetOrCreate(const AImageList: TCustomImageList): TcxCanvasBasedImageListHandle;
  end;

  { TcxCanvasBasedSharedPens }

  TcxCanvasBasedSharedPens = class(TcxCanvasBasedSharedResources)
  strict private
    FClass: TcxCanvasBasedPenHandleClass;
  public
    constructor Create(ACanvas: TcxCustomCanvas; AClass: TcxCanvasBasedPenHandleClass);
    function GetOrCreate(AColor: TdxAlphaColor; AWidth: Single; AStyle: TdxStrokeStyle): TcxCanvasBasedPenHandle; overload;
    function GetOrCreate(AOptions: TdxStrokeOptions): TcxCanvasBasedPenHandle; overload;
  end;

{$ENDREGION}

  { TcxCustomCanvas }

  TcxCanvasNativeDrawProc = reference to procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect); // for internal use
  TcxCanvasNativeDrawExProc = reference to procedure (ACanvas: TdxGPCanvas; const R: TRect); // for internal use

  TcxCanvasImageStretchQuality = (isqStandard, isqHigh);

  TcxCustomCanvas = class(TcxIUnknownObject)
  strict private
    FImageStretchQuality: TcxCanvasImageStretchQuality;

    function AllocateTempImage(AImage: TdxGPImage; AImageCache: PcxCanvasBasedImage): TcxCanvasBasedImage;
    procedure ReleaseTempResource(AResource: TcxCanvasBasedResource; ACache: Pointer{PcxCanvasBasedResource});

    procedure DrawFastDIB(AFastDIB: TdxCustomFastDIB; const ATargetRect, ASourceRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload;
    procedure DrawFastDIB(AFastDIB: TdxCustomFastDIB; const ATargetRect, ASourceRect: TdxRectF;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload;

    function GetUseRightToLeftAlignment: Boolean;
    procedure SetUseRightToLeftAlignment(const Value: Boolean);
  protected
    FResources: TList;
    FUseRightToLeftAlignment: TdxDefaultBoolean;
    FUseGDITextCalculation: Boolean;

    procedure DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte); overload; virtual; abstract;
    procedure DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte); overload; virtual; abstract;
    procedure FillRectByGradientCore(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode); virtual; abstract;
    procedure RectangleCore(const R: TdxRectF; ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle); virtual; abstract;

    function GetDefaultUseRightToLeftAlignment: Boolean; virtual;
    function GetIsLowColorsMode: Boolean; virtual;
    function GetSharedBrushes: TcxCanvasBasedSharedBrushes; virtual; abstract;
    function GetSharedFonts: TcxCanvasBasedSharedFonts; virtual; abstract;
    function GetSharedImageLists: TcxCanvasBasedSharedImageLists; virtual; abstract;
    function GetSharedPens: TcxCanvasBasedSharedPens; virtual; abstract;
    function GetWindowOrg: TPoint; virtual; abstract;
    procedure SetWindowOrg(const Value: TPoint); virtual; abstract;

    procedure ReleaseResources;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BeforeDestruction; override;

  {$REGION 'For internal use'}
    function CheckIsValid(var AResource{: TcxCanvasBasedResource}): Boolean; inline;
    function CreateBrush(ABrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedBrush; overload; virtual; abstract;
    function CreateBrush(AColor: TdxAlphaColor): TcxCanvasBasedBrush; overload; virtual;
    function CreateBrush(AFillOptions: TdxFillOptions): TcxCanvasBasedBrush; overload; virtual;
    function CreateFonT(AFont: TFont; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedFont; overload; virtual; 
    function CreateFonT(AFont: TdxFontOptions): TcxCanvasBasedFont; overload; virtual; 
    function CreateImage(ABitmap: TBitmap; AAlphaFormat: TAlphaFormat = afIgnored): TcxCanvasBasedImage; overload; virtual; abstract;
    function CreateImage(ABitmap: TdxCustomFastDIB; AAlphaFormat: TAlphaFormat = afIgnored): TcxCanvasBasedImage; overload; virtual; abstract;
    function CreateImage(AGraphic: TGraphic): TcxCanvasBasedImage; overload; virtual;
    function CreateImage(AImage: TdxGPImage; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedImage; overload; virtual;
    function CreateImageList(AImageList: TCustomImageList): TcxCanvasBasedImageList; virtual;
    function CreatePath: TcxCanvasBasedPath; virtual; abstract;
    function CreatePeN(AColor: TdxAlphaColor; AWidth: Single; AStyle: TdxStrokeStyle): TcxCanvasBasedPen; overload; virtual; 
    function CreatePeN(APen: TdxGPPen; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedPen; overload; virtual; abstract; 
    function CreatePeN(AStrokeOptions: TdxStrokeOptions): TcxCanvasBasedPen; overload; virtual; 
    function CreateTextLayout: TcxCanvasBasedTextLayout; virtual; abstract;

    procedure DrawNativeObject(const R: TRect; const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawExProc); overload; virtual;
    procedure DrawNativeObject(const R: TRect; const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc); overload; virtual; abstract;
  {$ENDREGION}

    procedure DrawBitmap(ABitmap: TBitmap; const ATargetRect: TRect; ACache: PcxCanvasBasedImage = nil); overload;
    procedure DrawBitmap(ABitmap: TBitmap; const ATargetRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload;
    procedure DrawBitmap(ABitmap: TBitmap; const ATargetRect, ASourceRect: TRect; ACache: PcxCanvasBasedImage = nil); overload;
    procedure DrawBitmap(ABitmap: TBitmap; const ATargetRect, ASourceRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload; virtual;
    procedure DrawBitmap(ABitmap: TdxFastDIB; const ATargetRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload;
    procedure DrawBitmap(ABitmap: TdxFastDIB; const ATargetRect: TdxRectF;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload;
    procedure DrawBitmap(ABitmap: TdxFastDIB; const ATargetRect, ASourceRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload; virtual;
    procedure DrawBitmap(ABitmap: TdxFastDIB; const ATargetRect, ASourceRect: TdxRectF;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload; virtual;
    procedure DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect: TdxRectF;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload;
    procedure DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload;
    procedure DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect, ASourceRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload; virtual;
    procedure DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect, ASourceRect: TdxRectF;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); overload; virtual;

    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; ACache: PcxCanvasBasedImage = nil); overload; virtual;
    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TdxRectF; ACache: PcxCanvasBasedImage = nil); overload; virtual;

    procedure DrawComplexFrame(const R: TRect; ALeftTopColor, ARightBottomColor: TColor;
      ABorders: TcxBorders = cxBordersAll; ABorderWidth: Integer = 1); virtual;
    procedure DrawEdge(const R: TRect; ASunken: Boolean;
      AOuter: Boolean; ABorders: TcxBorders = cxBordersAll); virtual;
    procedure FrameRect(const R: TRect; AColor: TColor;
      ALineWidth: Integer = 1; ABorders: TcxBorders = cxBordersAll); overload; virtual;
    procedure FrameRect(const R: TRect; AColor: TdxAlphaColor;
      ALineWidth: Integer = 1; ABorders: TcxBorders = cxBordersAll); overload; virtual;
    procedure FrameRect(const R: TdxRectF; AColor: TdxAlphaColor;
      ALineWidth: Single = 1; ABorders: TcxBorders = cxBordersAll); overload; virtual;

    procedure Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
      AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); overload; virtual;
    procedure Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
      AColor: TdxAlphaColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); overload; virtual; abstract;
    procedure DonutSlice(const R: TdxRectF; AStartAngle, ASweepAngle, AWholePercent: Single;
      ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); virtual; abstract; // for internal use
    procedure Ellipse(const R: TRect; ABrushColor, APenColor: TColor;
      APenStyle: TPenStyle = psSolid; APenWidth: Integer = 1); overload; virtual;
    procedure Ellipse(const R: TRect; ABrushColor, APenColor: TdxAlphaColor;
      APenStyle: TPenStyle = psSolid; APenWidth: Integer = 1); overload; virtual; abstract;
    procedure Ellipse(const R: TdxRectF;
      ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); overload; virtual; abstract; // for internal use
    procedure FillPixel(X, Y: Integer; AColor: TColor); virtual;
    procedure FillPolygon(const P: array of TPoint; AColor: TColor); overload; virtual;
    procedure FillPolygon(const P: array of TPoint; AColor: TdxAlphaColor); overload; virtual;
    procedure FillPolygon(const P: array of TdxPointF; ABrush: TcxCanvasBasedBrush); overload; virtual;
    procedure FillRect(const R: TRect; AColor: TColor); overload; virtual;
    procedure FillRect(const R: TRect; AColor: TColor; AAlpha: Byte); overload;
    procedure FillRect(const R: TRect; AColor: TdxAlphaColor); overload; virtual; abstract;
    procedure FillRect(const R: TRect; AImage: TcxCanvasBasedImage); overload; virtual; // for internal use
    procedure FillRect(const R: TRect; AImage: TdxGPImage; ACache: PcxCanvasBasedImage = nil); overload; virtual;
    procedure FillRect(const R: TdxRectF; AColor: TdxAlphaColor); overload;
    procedure FillRect(const R: TdxRectF; ABrush: TcxCanvasBasedBrush); overload; virtual; // for internal use
    procedure FillRectByGradient(const R: TRect; AColor1, AColor2: TColor; AHorizontal: Boolean); overload; virtual;
    procedure FillRectByGradient(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode); overload;
    procedure FocusRectangle(const R: TRect); virtual;
    procedure Line(const P1, P2: TPoint; AColor: TColor;
      APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); overload; virtual;
    procedure Line(const P1, P2: TPoint; AColor: TdxAlphaColor;
      APenWidth: Integer; APenStyle: TPenStyle = psSolid); overload; virtual;
    procedure Line(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen); overload; virtual; // for internal use
    procedure Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); virtual; abstract; // for internal use
    procedure Pie(const R: TdxRectF; AStartAngle, ASweepAngle: Single;
      ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); virtual; abstract; // for internal use
    procedure Polygon(const P: array of TPoint; ABrushColor, APenColor: TColor); overload; virtual;
    procedure Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor); overload; virtual; abstract;
    procedure Polygon(const P: array of TdxPointF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); overload; virtual;
    procedure Polygon(const P: PdxPointF; ACount: Integer; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); overload; virtual; abstract;
    procedure Polyline(const P: array of TPoint; AColor: TColor;
      APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); overload; virtual;
    procedure Polyline(const P: array of TPoint; AColor: TdxAlphaColor;
      APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); overload; virtual; abstract;
    procedure Polyline(const P: array of TdxPointF; APen: TcxCanvasBasedPen); overload; virtual; // for internal use
    procedure Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen); overload; virtual; abstract; // for internal use
    procedure Rectangle(const R: TRect; ABrushColor, APenColor: TColor;
      APenStyle: TPenStyle = psSolid; APenWidth: Integer = 1); overload; virtual;
    procedure Rectangle(const R: TRect; ABrushColor, APenColor: TdxAlphaColor;
      APenStyle: TPenStyle = psSolid; APenWidth: Integer = 1); overload; virtual; abstract;
    procedure Rectangle(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); overload; // for internal use

    procedure ModifyWorldTransform(const AForm: TXForm); virtual; abstract;
    procedure RestoreWorldTransform; virtual; abstract;
    procedure SaveWorldTransform; virtual; abstract;

    procedure RestoreState; virtual; abstract;
    procedure SaveState; virtual; abstract;

    function MoveWindowOrg(const P: TPoint): TPoint; virtual;

    procedure EnableAntialiasing(AEnable: Boolean); virtual;
    procedure RestoreAntialiasing; virtual;

    procedure IntersectClipRect(const ARect: TRect); overload; virtual; abstract;
    procedure IntersectClipRect(const ARect: TdxRectF); overload; virtual;
    function RectVisible(const R: TdxRectF): Boolean; overload; virtual;
    function RectVisible(const R: TRect): Boolean; overload; virtual; abstract;
    procedure RestoreClipRegion; virtual; abstract;
    procedure SaveClipRegion; virtual; abstract;

    property IsLowColorsMode: Boolean read GetIsLowColorsMode;
    property ImageStretchQuality: TcxCanvasImageStretchQuality read FImageStretchQuality write FImageStretchQuality;
    property UseRightToLeftAlignment: Boolean read GetUseRightToLeftAlignment write SetUseRightToLeftAlignment;
    property UseGDITextCalculation: Boolean read FUseGDITextCalculation write FUseGDITextCalculation;
    property WindowOrg: TPoint read GetWindowOrg write SetWindowOrg;
  end;


  { TcxCustomGdiBasedCanvas }

  TcxCustomGdiBasedCanvas = class(TcxCustomCanvas)
  protected
    function DoCreateBrush(AGpBrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership;
      AUseTargetRectCorrection: Boolean = False): TcxCanvasBasedBrush;
    function GetGpBrushAndPen(ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen;
      out AGpBrush: TdxGPCustomBrush; out AGpPen: TdxGPPen): Boolean;

    function GetSharedBrushes: TcxCanvasBasedSharedBrushes; override;
    function GetSharedFonts: TcxCanvasBasedSharedFonts; override;
    function GetSharedImageLists: TcxCanvasBasedSharedImageLists; override;
    function GetSharedPens: TcxCanvasBasedSharedPens; override;
  public
  {$REGION 'for internal use'}
    function CreateBrush(AGpBrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership): TcxCanvasBasedBrush; override;
    function CreateImage(ABitmap: TBitmap; AAlphaFormat: TAlphaFormat = afIgnored): TcxCanvasBasedImage; override; final;
    function CreateImage(ABitmap: TdxCustomFastDIB; AAlphaFormat: TAlphaFormat = afIgnored): TcxCanvasBasedImage; override; final;
    function CreateImage(AGpImage: TdxGPImage; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedImage; override;
    function CreatePath: TcxCanvasBasedPath; override;
    function CreatePeN(AGpPen: TdxGPPen; AOwnership: TdxObjectOwnership): TcxCanvasBasedPen; override; 
    //
    procedure FillRect(const R: TRect; AImage: TcxCanvasBasedImage); override;
  {$ENDREGION}
  end;

  { TcxGdiBasedCanvas }

  TcxGdiBasedCanvas = class(TcxCustomGdiBasedCanvas)
  strict private const
    CompositionModeMap: array[TAlphaFormat] of TdxGpCompositionMode = (cmSourceCopy, cmSourceOver, cmSourceOver);
  strict private
    FBaseOrigin: TPoint;
    FBrushOrigin: TPoint;
    FSavedWorldTransforms: TStack<TXForm>;

    function GetDCOrigin: TPoint;
  protected
    procedure RestoreBaseOrigin;
    procedure SaveBaseOrigin;

    procedure FillRectByGradientCore(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode); override;
    procedure DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte); override;
    procedure DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte); override;
    procedure RectangleCore(const R: TdxRectF; ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle); override;

    function GetHandle: HDC; virtual; abstract;
    function GetIsLowColorsMode: Boolean; override;
    function GetViewportOrg: TPoint;
    function GetWindowOrg: TPoint; override;
    procedure SetViewportOrg(const P: TPoint);
    procedure SetWindowOrg(const P: TPoint); override;
  public
    destructor Destroy; override;

  {$REGION 'for internal use'}
    function CreateTextLayout: TcxCanvasBasedTextLayout; override;

    procedure DrawNativeObject(const R: TRect; const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc); override;
  {$ENDREGION}

    procedure DrawBitmap(ABitmap: TBitmap; const ATargetRect, ASourceRect: TRect; 
      AAlphaFormat: TAlphaFormat = afIgnored; ACache: PcxCanvasBasedImage = nil); override;
    procedure DrawBitmap(ABitmap: TdxFastDIB; const ATargetRect, ASourceRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); override;
    procedure DrawBitmap(ABitmap: TdxFastDIB; const ATargetRect, ASourceRect: TdxRectF;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); override;
    procedure DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect, ASourceRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); override;
    procedure DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect, ASourceRect: TdxRectF;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); override;

    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; ACache: PcxCanvasBasedImage = nil); override;
    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TdxRectF; ACache: PcxCanvasBasedImage = nil); override;

    procedure Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
      AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle); override;
    procedure DonutSlice(const R: TdxRectF; AStartAngle, ASweepAngle, AWholePercent: Single;
      ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override; // for internal use
    procedure Ellipse(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer); override;
    procedure Ellipse(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure FillPixel(X, Y: Integer; AColor: TColor); override; 
    procedure FillPolygon(const P: array of TPoint; AColor: TColor); override;
    procedure FillRect(const R: TRect; AColor: TColor); override; 
    procedure FillRect(const R: TRect; AColor: TdxAlphaColor); override;
    procedure FillRect(const R: TRect; AImage: TdxGPImage; ACache: PcxCanvasBasedImage = nil); override;
    procedure FillRectByGradient(const R: TRect; AColor1, AColor2: TColor; AHorizontal: Boolean); override; 
    procedure FocusRectangle(const R: TRect); override;
    procedure Line(const P1, P2: TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle = psSolid); override;
    procedure Line(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen); override;
    procedure Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Pie(const R: TdxRectF; AStartAngle, ASweepAngle: Single;
      ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor); override;
    procedure Polygon(const P: PdxPointF; ACount: Integer; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen); override;
    procedure Polyline(const P: array of TPoint; AColor: TdxAlphaColor;
      APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); override;
    procedure Rectangle(const R: TRect; ABrushColor, APenColor: TdxAlphaColor;
      APenStyle: TPenStyle = psSolid; APenWidth: Integer = 1); override;

    procedure ModifyWorldTransform(const AForm: TXForm); override;
    procedure RestoreWorldTransform; override;
    procedure SaveWorldTransform; override;

    procedure ExcludeClipRect(const R: TRect);
    procedure IntersectClipRect(const R: TRect); override;
    function RectVisible(const R: TRect): Boolean; override;

    property BaseOrigin: TPoint read FBaseOrigin;
    property DCOrigin: TPoint read GetDCOrigin;
    property Handle: HDC read GetHandle;
    property ViewportOrg: TPoint read GetViewportOrg write SetViewportOrg;
  end;

{$REGION 'for internal use'}

  { TcxGdiCanvasBasedBrushHandle }

  TcxGdiCanvasBasedBrushHandle = class(TcxCanvasBasedBrushHandle)
  protected
    FBrush: TdxGPCustomBrush;
    FBrushOwnership: TdxObjectOwnership;

    procedure CreateNativeHandle(ACanvas: TcxCustomCanvas); override;
    procedure FreeNativeHandle; override;
  public
    constructor Create(ABrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership); overload;
    function IsEmpty: Boolean; override;
    //
    property Brush: TdxGPCustomBrush read FBrush;
  end;

  { TcxGdiCanvasBasedFontHandle }

  TcxGdiCanvasBasedFontHandle = class(TcxCanvasBasedFontHandle)
  strict private
    FFont: TFont;
    FFontOwnership: TdxObjectOwnership;
  protected
    procedure CreateNativeHandle(ACanvas: TcxCustomCanvas); override;
    procedure FreeNativeHandle; override;
  public
    constructor Create(const AFont: TFont; AOwnership: TdxObjectOwnership = ooCloned); override;
    property Font: TFont read FFont;
  end;

  { TcxGdiCanvasBasedImage }

  TcxGdiCanvasBasedImage = class(TcxCanvasBasedImage)
  strict private
    FImage: TdxGPImage;
    FImageOwnership: TdxObjectOwnership;
  public
    constructor Create(ACanvas: TcxCustomCanvas; AImage: TdxGPImage; AOwnership: TdxObjectOwnership = ooOwned);
    destructor Destroy; override;
    //
    property Image: TdxGPImage read FImage;
  end;

  { TcxGdiCanvasBasedPath }

  TcxGdiCanvasBasedPath = class(TcxCanvasBasedPath)
  strict private
    FPath: TdxGPPath;
  public
    constructor Create(ACanvas: TcxCustomCanvas);
    destructor Destroy; override;
    // Commands
    procedure AddArc(const AEllipse: TdxRectF; const AStartAngle, ASweepAngle: Single); override;
    procedure AddLine(const P1, P2: TdxPointF); override;
    procedure AddPolyline(Points: PdxPointF; Count: Integer); override;
    // Figures
    procedure FigureClose; override;
    procedure FigureStart; override;
    //
    property Path: TdxGPPath read FPath;
  end;

  { TcxGdiCanvasBasedPenHandle }

  TcxGdiCanvasBasedPenHandle = class(TcxCanvasBasedPenHandle)
  protected
    FPen: TdxGPPen;
    FPenOwnership: TdxObjectOwnership;

    procedure CreateNativeHandle(ACanvas: TcxCustomCanvas); override;
    procedure FreeNativeHandle; override;
  public
    constructor Create(APen: TdxGPPen; AOwnership: TdxObjectOwnership); overload;
    function IsEmpty: Boolean; override;
    //
    property Pen: TdxGPPen read FPen;
  end;

  { TcxGdiCanvasBasedTextLayout }

  TcxGdiCanvasBasedTextLayout = class(TcxCanvasBasedTextLayout)
  strict private
    class function InternalCalcTextExtends(DC: HDC; AText: PChar; ATextLength: Integer;
      AExpandTabs: Boolean; AData: TcxGdiCanvasBasedTextLayout): TSize; static;
    function GetNativeFont: TFont; inline;
  protected
    FColor: TRGBQuad;
    FTextRows: TcxTextRows;

    procedure DoCalculate(AMaxWidth, AMaxHeight, AMaxRowCount: Integer); override;
    function DoCalculateTextExtends(DC: HDC; AText: PChar; ATextLength: Integer; AExpandTabs: Boolean): TSize; virtual;
    procedure DoDraw(const R: TRect); override;
    procedure DoDrawCore(DC: HDC; const R: TRect); virtual;
    procedure DoSetFont(AFontHandle: TcxCanvasBasedFontHandle); override;
  public
    constructor Create(ACanvas: TcxCustomCanvas);
    destructor Destroy; override;
    procedure SetColor(AColor: TdxAlphaColor); override;

    property NativeFont: TFont read GetNativeFont;
  end;

  { TcxGdiCanvasBasedSharedBrushes }

  TcxGdiCanvasBasedSharedBrushes = class(TcxCanvasBasedSharedBrushes)
  strict private
    class var FInstance: TcxGdiCanvasBasedSharedBrushes;
  protected
    class procedure Finalize;
  public
    class function CreateBrush(AOptions: TcxCanvasBasedBrushHandle): TdxGPCustomBrush;
    class function Instance: TcxGdiCanvasBasedSharedBrushes;
  end;

  { TcxGdiCanvasBasedSharedFonts }

  TcxGdiCanvasBasedSharedFonts = class(TcxCanvasBasedSharedFonts)
  strict private
    class var FInstance: TcxGdiCanvasBasedSharedFonts;
  protected
    class procedure Finalize;
  public
    class function Instance: TcxGdiCanvasBasedSharedFonts;
  end;

  { TcxGdiCanvasBasedSharedImageLists }

  TcxGdiCanvasBasedSharedImageLists = class(TcxCanvasBasedSharedImageLists)
  strict private
    class var FInstance: TcxGdiCanvasBasedSharedImageLists;
  protected
    class procedure Finalize;
  public
    class function Instance: TcxGdiCanvasBasedSharedImageLists;
  end;

  { TcxGdiCanvasBasedSharedPens }

  TcxGdiCanvasBasedSharedPens = class(TcxCanvasBasedSharedPens)
  strict private
    class var FInstance: TcxGdiCanvasBasedSharedPens;
  protected
    class procedure Finalize;
  public
    class function Instance: TcxGdiCanvasBasedSharedPens;
  end;

{$ENDREGION}
const
  cxOppositeRotationAngle: array [TcxRotationAngle] of TcxRotationAngle = (ra0, raMinus90, raPlus90, ra180);
  cxRotationAngleToAngle: array[TcxRotationAngle] of Integer = (0, 90, -90, 180);
  dxFillOptionsGradientModeToBrushGradientMode: array[TdxFillOptionsGradientMode] of TdxGPBrushGradientMode = (
    gpbgmHorizontal, gpbgmVertical, gpbgmForwardDiagonal, gpbgmBackwardDiagonal
  );

function cxCopyDirectCanvasContentToGdiCanvas(AActualCanvas: TcxCustomCanvas; AGdiCanvas: TcxGdiBasedCanvas): Boolean;
function cxIsCustomCanvasSupported(AObject: TObject): Boolean;
implementation

uses
  Math, cxGraphics, cxControls, dxShapeBrushes, CommCtrl, dxTypeHelpers;

const
  dxThisUnitName = 'cxCustomCanvas';

type
  TdxCustomSmartImageAccess = class(TdxCustomSmartImage);
  TdxHashTableAccess = class(TdxHashTable);

  { TCanvasHelper }

  TCanvasHelper = class helper for TCanvas
  public
    procedure SelectFont;
  end;

  { TcxCanvasBasedImageCacheKey }

  TcxCanvasBasedImageCacheKey = packed record
    Index: Integer;
    Mode: TcxImageDrawMode;
    OverlayIndex: Integer;
    PaletteID: TGUID;
  end;

  { TcxCanvasBasedImageCacheKeyComparer }

  TcxCanvasBasedImageCacheKeyComparer = class(TEqualityComparer<TcxCanvasBasedImageCacheKey>)
  public
    function Equals(const Left, Right: TcxCanvasBasedImageCacheKey): Boolean; override;
    function GetHashCode(const Value: TcxCanvasBasedImageCacheKey): Integer; override;
  end;

  { TcxCanvasBasedImageCache }

  TcxCanvasBasedImageCache = class(TObjectDictionary<TcxCanvasBasedImageCacheKey, TcxCanvasBasedImage>)
  public
    constructor Create;
  end;

  { TcxCanvasBasedTextLayoutSimpleTransform }

  TcxCanvasBasedTextLayoutSimpleTransform = class(TcxCanvasBasedTextLayoutCustomTransform)
  strict private
    FIsVertical: Boolean;
  public
    constructor Create(AAngle: TcxRotationAngle);
    procedure CalculateConstraints(var AMaxWidth, AMaxHeight: Integer); override;
    procedure CalculateSize(var ASize: TSize); override;
  end;

  { TcxCanvasBasedTextLayoutComplexTransform }

  TcxCanvasBasedTextLayoutComplexTransform = class(TcxCanvasBasedTextLayoutCustomTransform)
  public
    procedure CalculateConstraints(var AMaxWidth, AMaxHeight: Integer); override;
    procedure CalculateSize(var ASize: TSize); override;
  end;

function cxCopyDirectCanvasContentToGdiCanvas(AActualCanvas: TcxCustomCanvas; AGdiCanvas: TcxGdiBasedCanvas): Boolean;
var
  ADirectCanvas: IcxControlDirectCanvas;
begin
  Result := (AActualCanvas <> AGdiCanvas) and Supports(AActualCanvas, IcxControlDirectCanvas, ADirectCanvas);
  if Result then
    ADirectCanvas.CopyToDC(AGdiCanvas.Handle);
end;

function cxIsCustomCanvasSupported(AObject: TObject): Boolean;
begin
  Result := Supports(AObject, IcxCustomCanvasSupport);
end;

procedure cxSetGpResource(var AField; var AOwnership: TdxObjectOwnership;
  ASource: TdxGPCustomGraphicObject; ASourceOwnership: TdxObjectOwnership);
begin
  if ASourceOwnership = ooCloned then
  begin
    TObject(AField) := ASource.Clone;
    AOwnership := ooOwned;
  end
  else
  begin
    TObject(AField) := ASource;
    AOwnership := ASourceOwnership;
  end;
end;

{ TCanvasHelper }

procedure TCanvasHelper.SelectFont;
begin
  RequiredState([csHandleValid, csFontValid]);
end;

{ TdxStrokeOptions }

constructor TdxStrokeOptions.Create(AOwner: TPersistent);
begin
  inherited;
  FColor := TdxAlphaColors.Default;
  Width := 1.0;
end;

constructor TdxStrokeOptions.Create(AOwner: TPersistent; AGetDefaultColorFunc: TdxAlphaColorFunc);
begin
  Create(AOwner);
  FOnGetDefaultColor := AGetDefaultColorFunc;
end;

destructor TdxStrokeOptions.Destroy;
begin
  FreeAndNil(FCachedPen);
  inherited;
end;

procedure TdxStrokeOptions.ChangeScale(M, D: Integer);
begin
  BeginUpdate;
  try
    DoChangeScale(M, D);
  finally
    EndUpdate;
  end;
end;

procedure TdxStrokeOptions.FlushCache;
begin
  FreeAndNil(FCachedPen);
end;

function TdxStrokeOptions.GetHandle(ACanvas: TcxCustomCanvas): TcxCanvasBasedPen;
begin
  if not ACanvas.CheckIsValid(FCachedPen) then
    FCachedPen := ACanvas.CreatePen(Self);
  Result := FCachedPen;
end;

procedure TdxStrokeOptions.DoAssign(Source: TPersistent);
begin
  if Source is TdxStrokeOptions then
  begin
    Color := TdxStrokeOptions(Source).Color;
    Style := TdxStrokeOptions(Source).Style;
    Width := TdxStrokeOptions(Source).Width;
  end;
end;

procedure TdxStrokeOptions.DoChanged;
begin
  FlushCache;
  dxCallNotify(FOnChange, Self);
end;

procedure TdxStrokeOptions.DoChangeScale(M, D: Integer);
begin
  Width := dxScale(Width, M, D);
end;

function TdxStrokeOptions.GetActualColor: TdxAlphaColor;
begin
  Result := Color;
  if Result = TdxAlphaColors.Default then
  begin
    if Assigned(FOnGetDefaultColor) then
      Result := FOnGetDefaultColor;
  end;
end;

function TdxStrokeOptions.IsWidthStored: Boolean;
begin
  Result := not SameValue(Width, 1);
end;

procedure TdxStrokeOptions.SetColor(AValue: TdxAlphaColor);
begin
  if FColor <> AValue then
  begin
    FColor := AValue;
    Changed;
  end;
end;

procedure TdxStrokeOptions.SetStyle(AValue: TdxStrokeStyle);
begin
  if FStyle <> AValue then
  begin
    FStyle := AValue;
    Changed;
  end;
end;

procedure TdxStrokeOptions.SetWidth(AValue: Single);
begin
  AValue := Max(AValue, 0);
  if not SameValue(AValue, FWidth) then
  begin
    FWidth := AValue;
    Changed;
  end;
end;

{ TdxFillOptions }

constructor TdxFillOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FColor := TdxAlphaColors.Default;
  FColor2 := TdxAlphaColors.Default;
  FMode := TdxFillOptionsMode.Solid;
  FTexture := TdxSmartImage.Create;
  FTexture.OnChange := TextureChangeHandler;
end;

constructor TdxFillOptions.Create(AOwner: TPersistent; AGetDefaultColorFunc, AGetDefaultColor2Func: TdxAlphaColorFunc);
begin
  Create(AOwner);
  FOnGetDefaultColor := AGetDefaultColorFunc;
  FOnGetDefaultColor2 := AGetDefaultColor2Func;
end;

destructor TdxFillOptions.Destroy;
begin
  FreeAndNil(FCachedBrush);
  FreeAndNil(FTexture);
  inherited Destroy;
end;

procedure TdxFillOptions.FlushCache;
begin
  FreeAndNil(FCachedBrush);
end;

function TdxFillOptions.GetHandle(ACanvas: TcxCustomCanvas): TcxCanvasBasedBrush;
begin
  if not ACanvas.CheckIsValid(FCachedBrush) then
    FCachedBrush := ACanvas.CreateBrush(Self);
  Result := FCachedBrush;
end;

procedure TdxFillOptions.DoAssign(Source: TPersistent);
begin
  if Source is TdxFillOptions then
  begin
    Color := TdxFillOptions(Source).Color;
    Color2 := TdxFillOptions(Source).Color2;
    Texture := TdxFillOptions(Source).Texture;
    GradientMode := TdxFillOptions(Source).GradientMode;
    HatchStyle := TdxFillOptions(Source).HatchStyle;
    Mode := TdxFillOptions(Source).Mode;
  end;
end;

procedure TdxFillOptions.DoChanged;
begin
  FlushCache;
  dxCallNotify(FOnChange, Self);
end;

function TdxFillOptions.GetActualColor: TdxAlphaColor;
begin
  Result := Color;
  if Result = TdxAlphaColors.Default then
  begin
    if Assigned(FOnGetDefaultColor) then
      Result := FOnGetDefaultColor;
  end;
end;

function TdxFillOptions.GetActualColor2: TdxAlphaColor;
begin
  Result := Color2;
  if Result = TdxAlphaColors.Default then
  begin
    if Assigned(FOnGetDefaultColor2) then
      Result := FOnGetDefaultColor2;
  end;
end;

procedure TdxFillOptions.SetColor(AValue: TdxAlphaColor);
begin
  if AValue <> FColor then
  begin
    FColor := AValue;
    Changed;
  end;
end;

procedure TdxFillOptions.SetColor2(AValue: TdxAlphaColor);
begin
  if AValue <> FColor2 then
  begin
    FColor2 := AValue;
    if (Mode = TdxFillOptionsMode.Gradient) or (Mode = TdxFillOptionsMode.Hatch) then
      Changed;
  end;
end;

procedure TdxFillOptions.SetMode(AValue: TdxFillOptionsMode);
begin
  if AValue <> FMode then
  begin
    FMode := AValue;
    Changed;
  end;
end;

procedure TdxFillOptions.SetGradientMode(AValue: TdxFillOptionsGradientMode);
begin
  if AValue <> FGradientMode then
  begin
    FGradientMode := AValue;
    if Mode = TdxFillOptionsMode.Gradient then
      Changed;
  end;
end;

procedure TdxFillOptions.SetHatchStyle(AValue: TdxFillOptionsHatchStyle);
begin
  if AValue <> FHatchStyle then
  begin
    FHatchStyle := AValue;
    if Mode = TdxFillOptionsMode.Hatch then
      Changed;
  end;
end;

procedure TdxFillOptions.SetTexture(AValue: TdxSmartImage);
begin
  Texture.Assign(AValue);
end;

function TdxFillOptions.IsModeStored: Boolean;
begin
  Result := (FMode <> TdxFillOptionsMode.Solid) or IsTextureStored;
end;

function TdxFillOptions.IsTextureStored: Boolean;
begin
  Result := not FTexture.Empty;
end;

procedure TdxFillOptions.TextureChangeHandler(Sender: TObject);
begin
  if Texture.Empty then
    FMode := TdxFillOptionsMode.Clear
  else
    FMode := TdxFillOptionsMode.Texture;

  Changed;
end;

{ TdxFontOptions }

constructor TdxFontOptions.Create(AOwner: TPersistent);
begin
  Create(AOwner, string(DefFontData.Name), -MulDiv(DefFontData.Height, 72, dxDefaultDPI));
end;

constructor TdxFontOptions.Create(AOwner: TPersistent; const ADefaultName: TFontName; const ADefaultSize: Integer);
begin
  inherited Create(AOwner);

  FDefaultName := ADefaultName;
  FDefaultSize := ADefaultSize;
  FCharset := DEFAULT_CHARSET;
  FName := FDefaultName;
  FHeight := SizeToHeight(FDefaultSize);
end;

destructor TdxFontOptions.Destroy;
begin
  FreeAndNil(FCachedFont);
  inherited Destroy;
end;

procedure TdxFontOptions.Assign(Source: TPersistent);
begin
  BeginUpdate;
  try
    if Source is TFont then
    begin
      Name := TFont(Source).Name;
      Height := TFont(Source).Height;
      Pitch := TdxFontPitch(TFont(Source).Pitch);
      Style := TFont(Source).Style;
    {$IFDEF DELPHIBERLIN}
      Quality := TdxFontQuality(TFont(Source).Quality);
    {$ENDIF}
    end
    else
      inherited Assign(Source);
  finally
    EndUpdate;
  end;
end;

procedure TdxFontOptions.ChangeScale(M, D: Integer);
begin
  FHeight := MulDiv(FHeight, M, D);
  Changed;
end;

procedure TdxFontOptions.FlushCache;
begin
  FreeAndNil(FCachedFont);
end;

function TdxFontOptions.GetHandle(ACanvas: TcxCustomCanvas): TcxCanvasBasedFont;
begin
  if not ACanvas.CheckIsValid(FCachedFont) then
    FCachedFont := ACanvas.CreateFont(Self);
  Result := FCachedFont;
end;

function TdxFontOptions.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TdxFontOptions.GetItalic: Boolean;
begin
  Result := FItalic;
end;

procedure TdxFontOptions.AssignTo(Dest: TPersistent);
var
  ADest: TFont;
begin
  if Dest is TFont then
  begin
    ADest := TFont(Dest);
    ADest.Name := Name;
    ADest.Charset := Charset;
    ADest.Height := Height;
    ADest.Style := Style;
    ADest.Pitch := TFontPitch(Pitch);
  {$IFDEF DELPHIBERLIN}
    ADest.Quality := TFontQuality(Quality);
  {$ENDIF}
  end
  else
    inherited AssignTo(Dest);
end;

procedure TdxFontOptions.DoAssign(Source: TPersistent);
begin
  if Source is TdxFontOptions then
  begin
    FCharset := TdxFontOptions(Source).Charset;
    FHeight := TdxFontOptions(Source).Height;
    FName := TdxFontOptions(Source).Name;
    FPitch := TdxFontOptions(Source).Pitch;
    FQuality := TdxFontOptions(Source).Quality;
    FBold := TdxFontOptions(Source).Bold;
    FItalic := TdxFontOptions(Source).Italic;
    FStrikeOut := TdxFontOptions(Source).StrikeOut;
    FUnderline := TdxFontOptions(Source).Underline;
    Changed;
  end;
end;

procedure TdxFontOptions.DoChanged;
begin
  FlushCache;
  dxCallNotify(FOnChange, Self);
end;

function TdxFontOptions.GetBold: Boolean;
begin
  Result := FBold;
end;

function TdxFontOptions.GetCharset: TFontCharset;
begin
  Result := FCharset;
end;

function TdxFontOptions.GetName: TFontName;
begin
  Result := FName;
end;

function TdxFontOptions.GetPitch: TdxFontPitch;
begin
  Result := FPitch;
end;

function TdxFontOptions.GetQuality: TdxFontQuality;
begin
  Result := FQuality;
end;

function TdxFontOptions.GetSize: Integer;
begin
  Result := -MulDiv(Height, 72, dxDefaultDPI);
end;

function TdxFontOptions.GetStrikeOut: Boolean;
begin
  Result := FStrikeOut;
end;

function TdxFontOptions.GetStyle: TFontStyles;
begin
  Result := [];
  if Bold then Include(Result, fsBold);
  if Italic then Include(Result, fsItalic);
  if Underline then Include(Result, fsUnderline);
  if StrikeOut then Include(Result, fsStrikeOut);
end;

function TdxFontOptions.GetUnderline: Boolean;
begin
  Result := FUnderline;
end;

function TdxFontOptions.IsBoldStored: Boolean;
begin
  Result := FBold;
end;

function TdxFontOptions.IsCharsetStored: Boolean;
begin
  Result := FCharset <> DEFAULT_CHARSET;
end;

function TdxFontOptions.IsItalicStored: Boolean;
begin
  Result := FItalic;
end;

function TdxFontOptions.IsNameStored: Boolean;
begin
  Result := Name <> FDefaultName;
end;

function TdxFontOptions.IsPitchStored: Boolean;
begin
  Result := FPitch <> TdxFontPitch.Default;
end;

function TdxFontOptions.IsQualityStored: Boolean;
begin
  Result := FQuality <> TdxFontQuality.Default;
end;

function TdxFontOptions.IsSizeStored: Boolean;
begin
  Result := Size <> FDefaultSize;
end;

function TdxFontOptions.IsStrikeOutStored: Boolean;
begin
  Result := FStrikeOut;
end;

function TdxFontOptions.IsUnderlineStored: Boolean;
begin
  Result := FUnderline;
end;

procedure TdxFontOptions.SetBold(const AValue: Boolean);
begin
  if AValue <> FBold then
  begin
    FBold := AValue;
    Changed;
  end;
end;

procedure TdxFontOptions.SetCharset(AValue: TFontCharset);
begin
  if AValue <> FCharset then
  begin
    FCharset := AValue;
    Changed;
  end;
end;

procedure TdxFontOptions.SetHeight(AValue: Integer);
begin
  if AValue <> FHeight then
  begin
    FHeight := AValue;
    Changed;
  end;
end;

procedure TdxFontOptions.SetItalic(const AValue: Boolean);
begin
  if AValue <> FItalic then
  begin
    FItalic := AValue;
    Changed;
  end;
end;

procedure TdxFontOptions.SetName(const AValue: TFontName);
begin
  if AValue <> FName then
  begin
    if AValue = '' then
      FName := FDefaultName
    else
      FName := AValue;
    Changed;
  end;
end;

procedure TdxFontOptions.SetPitch(AValue: TdxFontPitch);
begin
  if AValue <> FPitch then
  begin
    FPitch := AValue;
    Changed;
  end;
end;

procedure TdxFontOptions.SetQuality(AValue: TdxFontQuality);
begin
  if AValue <> FQuality then
  begin
    FQuality := AValue;
    Changed;
  end;
end;

procedure TdxFontOptions.SetSize(AValue: Integer);
begin
  Height := SizeToHeight(AValue);
end;

procedure TdxFontOptions.SetStrikeOut(const AValue: Boolean);
begin
  if AValue <> FStrikeOut then
  begin
    FStrikeOut := AValue;
    Changed;
  end;
end;

procedure TdxFontOptions.SetStyle(AValue: TFontStyles);
begin
  Bold := fsBold in AValue;
  Italic := fsItalic in AValue;
  StrikeOut := fsStrikeOut in AValue;
  Underline := fsUnderline in AValue;
end;

procedure TdxFontOptions.SetUnderline(const AValue: Boolean);
begin
  if AValue <> FUnderline then
  begin
    FUnderline := AValue;
    Changed;
  end;
end;

class function TdxFontOptions.SizeToHeight(ASize: Integer): Integer;
begin
  Result := -MulDiv(ASize, dxDefaultDPI, 72)
end;

{ TdxChildFontOptions }

procedure TdxChildFontOptions.DoAssign(Source: TPersistent);
begin
  if Source is TdxChildFontOptions then
    AssignedValues := TdxChildFontOptions(Source).AssignedValues;
  inherited DoAssign(Source);
end;

function TdxChildFontOptions.GetBold: Boolean;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Bold in FAssignedValues) or (AParent = nil) then
    Result := inherited GetBold
  else
    Result := AParent.Bold;
end;

function TdxChildFontOptions.GetCharset: TFontCharset;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Charset in FAssignedValues) or (AParent = nil) then
    Result := inherited GetCharset
  else
    Result := AParent.Charset;
end;

function TdxChildFontOptions.GetHeight: Integer;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Size in FAssignedValues) or (AParent = nil) then
    Result := inherited GetHeight
  else
    Result := AParent.Height;
end;

function TdxChildFontOptions.GetItalic: Boolean;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Italic in AssignedValues) or (AParent = nil) then
    Result := inherited GetItalic
  else
    Result := AParent.Italic;
end;

function TdxChildFontOptions.GetName: TFontName;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Name in FAssignedValues) or (AParent = nil) then
    Result := inherited GetName
  else
    Result := AParent.Name;
end;

function TdxChildFontOptions.GetPitch: TdxFontPitch;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Pitch in FAssignedValues) or (AParent = nil) then
    Result := inherited GetPitch
  else
    Result := AParent.Pitch;
end;

function TdxChildFontOptions.GetQuality: TdxFontQuality;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Quality in FAssignedValues) or (AParent = nil) then
    Result := inherited GetQuality
  else
    Result := AParent.Quality;
end;

function TdxChildFontOptions.GetStrikeOut: Boolean;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.StrikeOut in FAssignedValues) or (AParent = nil) then
    Result := inherited GetStrikeOut
  else
    Result := AParent.StrikeOut;
end;

function TdxChildFontOptions.GetUnderline: Boolean;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Underline in FAssignedValues) or (AParent = nil) then
    Result := inherited GetUnderline
  else
    Result := AParent.Underline;
end;

function TdxChildFontOptions.IsBoldStored: Boolean;
begin
  Result := TdxFontOptionsValue.Bold in FAssignedValues;
end;

function TdxChildFontOptions.IsCharsetStored: Boolean;
begin
  Result := TdxFontOptionsValue.Charset in FAssignedValues;
end;

function TdxChildFontOptions.IsItalicStored: Boolean;
begin
  Result := TdxFontOptionsValue.Italic in FAssignedValues;
end;

function TdxChildFontOptions.IsNameStored: Boolean;
begin
  Result := TdxFontOptionsValue.Name in FAssignedValues;
end;

function TdxChildFontOptions.IsPitchStored: Boolean;
begin
  Result := TdxFontOptionsValue.Pitch in FAssignedValues;
end;

function TdxChildFontOptions.IsQualityStored: Boolean;
begin
  Result := TdxFontOptionsValue.Quality in FAssignedValues;
end;

function TdxChildFontOptions.IsSizeStored: Boolean;
begin
  Result := TdxFontOptionsValue.Size in FAssignedValues;
end;

function TdxChildFontOptions.IsStrikeOutStored: Boolean;
begin
  Result := TdxFontOptionsValue.StrikeOut in FAssignedValues;
end;

function TdxChildFontOptions.IsUnderlineStored: Boolean;
begin
  Result := TdxFontOptionsValue.Underline in FAssignedValues;
end;

procedure TdxChildFontOptions.SetBold(const AValue: Boolean);
begin
  inherited SetBold(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.Bold];
end;

procedure TdxChildFontOptions.SetCharset(AValue: TFontCharset);
begin
  inherited SetCharset(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.Charset];
end;

procedure TdxChildFontOptions.SetHeight(AValue: Integer);
begin
  inherited SetHeight(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.Size];
end;

procedure TdxChildFontOptions.SetItalic(const AValue: Boolean);
begin
  inherited SetItalic(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.Italic];
end;

procedure TdxChildFontOptions.SetName(const AValue: TFontName);
begin
  inherited SetName(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.Name];
end;

procedure TdxChildFontOptions.SetPitch(AValue: TdxFontPitch);
begin
  inherited SetPitch(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.Pitch];
end;

procedure TdxChildFontOptions.SetQuality(AValue: TdxFontQuality);
begin
  inherited SetQuality(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.Quality];
end;

procedure TdxChildFontOptions.SetStrikeOut(const AValue: Boolean);
begin
  inherited SetStrikeOut(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.StrikeOut];
end;

procedure TdxChildFontOptions.SetUnderline(const AValue: Boolean);
begin
  inherited SetUnderline(AValue);
  AssignedValues := AssignedValues + [TdxFontOptionsValue.Underline];
end;

procedure TdxChildFontOptions.SetAssignedValues(const AValue: TdxFontOptionsValues);
begin
  if FAssignedValues <> AValue then
  begin
    FAssignedValues := AValue;
    Changed;
  end;
end;

{ TcxCanvasBasedResource }

constructor TcxCanvasBasedResource.Create(ACanvas: TcxCustomCanvas; AHandle: TcxCanvasBasedResourceHandle = nil);
begin
  FCanvas := ACanvas;
  if FCanvas <> nil then
    FCanvas.FResources.Add(Self);

  FHandle := AHandle;
  if FHandle <> nil then
    FHandle.AddRef;
end;

procedure TcxCanvasBasedResource.BeforeDestruction;
begin
  inherited;
  if FCanvas <> nil then
    FCanvas.FResources.Remove(Self);
  Release;
end;

function TcxCanvasBasedResource.IsEmpty: Boolean;
begin
  Result := (FHandle = nil) or FHandle.IsEmpty;
end;

procedure TcxCanvasBasedResource.Release;
begin
  dxChangeHandle(FHandle, nil);
  FCanvas := nil;
end;

procedure TcxCanvasBasedResource.CheckState;
begin
  if Canvas = nil then
    raise EInvalidOperation.Create(sdxInternalErrorResourceAbandoned);
end;

{ TcxCanvasBasedResourceCacheKey }

class function TcxCanvasBasedResourceCacheKey.Create(AOwner: Pointer;
  const ASize: TSize; AState, APart: Integer; ATargetDPI: Word): TcxCanvasBasedResourceCacheKey;
begin
  Result.Owner := AOwner;
  Result.Size := ASize;
  Result.Part := APart;
  Result.State := AState;
  Result.TargetDPI := ATargetDPI;
end;

{ TcxCanvasBasedResourceHandle }

constructor TcxCanvasBasedResourceHandle.Create;
begin
  inherited Create(nil, 0);
end;

destructor TcxCanvasBasedResourceHandle.Destroy;
begin
  FreeNativeHandle;
  inherited;
end;

function TcxCanvasBasedResourceHandle.IsEmpty: Boolean;
begin
  Result := False;
end;

{ TcxCanvasBasedSharedResources }

constructor TcxCanvasBasedSharedResources.Create(ACanvas: TcxCustomCanvas);
begin
  inherited Create(ACanvas);
  FHashTable := TdxHashTable.Create;
end;

destructor TcxCanvasBasedSharedResources.Destroy;
begin
  FreeAndNil(FHashTable);
  inherited;
end;

function TcxCanvasBasedSharedResources.Share(AResource: TcxCanvasBasedResourceHandle): TcxCanvasBasedResourceHandle;
begin
  Result := AResource;
  TdxHashTableAccess(FHashTable).CheckAndAddItem(Result);
  if Result = AResource then
    Result.CreateNativeHandle(Canvas);
end;

procedure TcxCanvasBasedSharedResources.Release;
begin
  TdxHashTableAccess(FHashTable).ForEach(
    procedure (AItem: TdxDynamicListItem)
    begin
      TcxCanvasBasedResourceHandle(AItem).FreeNativeHandle;
    end);
  FHashTable.Clear;
  inherited;
end;

{ TcxCanvasBasedBrushHandle }

constructor TcxCanvasBasedBrushHandle.Create(AColor: TdxAlphaColor);
begin
  FMode := TdxFillOptionsMode.Solid;
  FColor1 := AColor;
end;

constructor TcxCanvasBasedBrushHandle.Create(AOptions: TdxFillOptions);
begin
  FMode := AOptions.Mode;
  FColor1 := AOptions.ActualColor;
  FColor2 := AOptions.ActualColor2;
  FGradientMode := dxFillOptionsGradientModeToBrushGradientMode[AOptions.GradientMode];
  FHatchStyle := TdxGpHatchStyle(AOptions.HatchStyle);

  if FMode = TdxFillOptionsMode.Texture then
  begin
    FTexture := TdxSmartImage.Create;
    FTexture.Assign(AOptions.Texture);
  end;
end;

destructor TcxCanvasBasedBrushHandle.Destroy;
begin
  FreeAndNil(FTexture);
  inherited;
end;

procedure TcxCanvasBasedBrushHandle.CalculateHash(var AHash: Integer);
begin
  AddToHash(AHash, FMode, SizeOf(FMode));
  case FMode of
    TdxFillOptionsMode.Solid:
      AddToHash(AHash, FColor1, SizeOf(FColor1));

    TdxFillOptionsMode.Texture:
      AHash := AHash xor FTexture.GetHashCode;

    TdxFillOptionsMode.Hatch:
      begin
        AddToHash(AHash, FColor1, SizeOf(FColor1));
        AddToHash(AHash, FColor2, SizeOf(FColor2));
        AddToHash(AHash, FHatchStyle, SizeOf(FHatchStyle));
      end;

    TdxFillOptionsMode.Gradient:
      begin
        AddToHash(AHash, FColor1, SizeOf(FColor1));
        AddToHash(AHash, FColor2, SizeOf(FColor2));
        AddToHash(AHash, FGradientMode, SizeOf(FGradientMode));
      end;
  end;
end;

function TcxCanvasBasedBrushHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result := FMode = TcxCanvasBasedBrushHandle(AItem).FMode;
  if Result then
    case FMode of
      TdxFillOptionsMode.Solid:
        Result := FColor1 = TcxCanvasBasedBrushHandle(AItem).FColor1;

      TdxFillOptionsMode.Texture:
        Result := FTexture.Equals(TcxCanvasBasedBrushHandle(AItem).FTexture);

      TdxFillOptionsMode.Hatch:
        Result :=
          (FHatchStyle = TcxCanvasBasedBrushHandle(AItem).FHatchStyle) and
          (FColor1 = TcxCanvasBasedBrushHandle(AItem).FColor1) and
          (FColor2 = TcxCanvasBasedBrushHandle(AItem).FColor2);

      TdxFillOptionsMode.Gradient:
        Result :=
          (FGradientMode = TcxCanvasBasedBrushHandle(AItem).FGradientMode) and
          (FColor1 = TcxCanvasBasedBrushHandle(AItem).FColor1) and
          (FColor2 = TcxCanvasBasedBrushHandle(AItem).FColor2);
    end;
end;

{ TcxCanvasBasedFont }

function TcxCanvasBasedFont.GetLineHeight: Integer;
begin
  if IsEmpty then
    Result := 0
  else
    Result := TcxCanvasBasedFontHandle(Handle).DoGetLineHeight(Canvas);
end;

function TcxCanvasBasedFont.IsEmpty: Boolean;
begin
  Result := (Canvas = nil) or inherited;
end;

{ TcxCanvasBasedFontHandle }

constructor TcxCanvasBasedFontHandle.Create(const AFont: TFont; AOwnership: TdxObjectOwnership = ooCloned);
begin
  try
    Initialize(AFont);
  finally
    if AOwnership = ooOwned then
      AFont.Free;
  end;
end;

constructor TcxCanvasBasedFontHandle.Create(const AFont: TdxFontOptions);
begin
  FName := AFont.Name;
  FHeight := AFont.Height;
  FPitch := AFont.Pitch;
  FStyle := AFont.Style;
  FCharset := AFont.Charset;
  FQuality := AFont.Quality;
end;

procedure TcxCanvasBasedFontHandle.CalculateHash(var AHash: Integer);
begin
  AddToHash(AHash, FName);
  AddToHash(AHash, FHeight, SizeOf(FHeight));
  AddToHash(AHash, FPitch, SizeOf(FPitch));
  AddToHash(AHash, FQuality, SizeOf(FQuality));
  AddToHash(AHash, FCharset, SizeOf(FCharset));
  AddToHash(AHash, FStyle, SizeOf(FStyle));
end;

procedure TcxCanvasBasedFontHandle.Initialize(AFont: TFont);
begin
  FName := AFont.Name;
  FHeight := AFont.Height;
  FStyle := AFont.Style;
  FCharset := AFont.Charset;
  FPitch := TdxFontPitch(AFont.Pitch);
{$IFDEF DELPHIBERLIN}
  FQuality := TdxFontQuality(AFont.Quality);
{$ENDIF}
end;

function TcxCanvasBasedFontHandle.GetLineHeight(ACanvas: TcxCustomCanvas): Integer;
begin
  if FLineHeight = 0 then
    FLineHeight := DoGetLineHeight(ACanvas);
  Result := FLineHeight;
end;

function TcxCanvasBasedFontHandle.DoGetLineHeight(ACanvas: TcxCustomCanvas): Integer;
var
  ATextLayout: TcxCanvasBasedTextLayout;
begin
  ATextLayout := ACanvas.CreateTextLayout;
  try
    ATextLayout.DoSetFont(Self);
    ATextLayout.SetText(dxMeasurePattern);
    Result := ATextLayout.MeasureSize.cy;
  finally
    ATextLayout.Free;
  end;
end;

function TcxCanvasBasedFontHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result :=
    (FHeight = TcxCanvasBasedFontHandle(AItem).FHeight) and
    (FCharset = TcxCanvasBasedFontHandle(AItem).FCharset) and
    (FQuality = TcxCanvasBasedFontHandle(AItem).FQuality) and
    (FStyle = TcxCanvasBasedFontHandle(AItem).FStyle) and
    (FPitch = TcxCanvasBasedFontHandle(AItem).FPitch) and
    (FName = TcxCanvasBasedFontHandle(AItem).FName);
end;

{ TcxCanvasBasedImage }

constructor TcxCanvasBasedImage.Create(ACanvas: TcxCustomCanvas; AWidth, AHeight: Integer);
begin
  inherited Create(ACanvas);
  FHeight := AHeight;
  FWidth := AWidth;
end;

procedure TcxCanvasBasedImage.Draw(const ATargetRect: TRect; AAlpha: Byte = MaxByte);
begin
  Draw(ATargetRect, ClientRect, AAlpha);
end;

procedure TcxCanvasBasedImage.Draw(const ATargetRect: TdxRectF; AAlpha: Byte);
begin
  Draw(ATargetRect, ClientRect, AAlpha);
end;

procedure TcxCanvasBasedImage.Draw(const ATargetRect, ASourceRect: TRect; AAlpha: Byte);
begin
  if Canvas <> nil then
    Canvas.DrawImageCore(Self, ATargetRect, ASourceRect, AAlpha);
end;

procedure TcxCanvasBasedImage.Draw(const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte);
begin
  if Canvas <> nil then
    Canvas.DrawImageCore(Self, ATargetRect, ASourceRect, AAlpha);
end;

function TcxCanvasBasedImage.IsEmpty: Boolean;
begin
  Result := (Width <= 0) or (Height <= 0);
end;

function TcxCanvasBasedImage.GetClientRect: TRect;
begin
  Result := Rect(0, 0, Width, Height);
end;

function TcxCanvasBasedImage.GetSize: TSize;
begin
  Result := cxSize(Width, Height);
end;

{ TcxCanvasBasedImageList }

procedure TcxCanvasBasedImageList.Draw(const R: TdxRectF; AImageIndex, AOverlayIndex: Integer;
  AMode: TcxImageDrawMode; AAlpha: Byte; const AColorPalette: IdxColorPalette);
var
  AImage: TcxCanvasBasedImage;
begin
  if TryGetImage(AImageIndex, AOverlayIndex, AMode, AColorPalette, AImage) then
    Canvas.DrawImageCore(AImage, R, dxRectF(AImage.ClientRect), AAlpha);
end;

procedure TcxCanvasBasedImageList.Draw(const R: TdxRectF; AImageIndex: Integer;
  AMode: TcxImageDrawMode; AAlpha: Byte; const AColorPalette: IdxColorPalette);
begin
  Draw(R, AImageIndex, -1, AMode, AAlpha, AColorPalette);
end;

procedure TcxCanvasBasedImageList.Draw(const R: TRect; AImageIndex, AOverlayIndex: Integer;
  AMode: TcxImageDrawMode; AAlpha: Byte; const AColorPalette: IdxColorPalette);
var
  AImage: TcxCanvasBasedImage;
begin
  if TryGetImage(AImageIndex, AOverlayIndex, AMode, AColorPalette, AImage) then
    Canvas.DrawImageCore(AImage, R, AImage.ClientRect, AAlpha);
end;

procedure TcxCanvasBasedImageList.Draw(const R: TRect; AImageIndex: Integer;
  AMode: TcxImageDrawMode; AAlpha: Byte; const AColorPalette: IdxColorPalette);
begin
  Draw(R, AImageIndex, -1, AMode, AAlpha, AColorPalette);
end;

function TcxCanvasBasedImageList.GetSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := Handle.GetSize(AScaleFactor);
end;

function TcxCanvasBasedImageList.TryGetImage(AImageIndex, AOverlayIndex: Integer;
  AMode: TcxImageDrawMode; const AColorPalette: IdxColorPalette; out AImage: TcxCanvasBasedImage): Boolean;
begin
  CheckState;
  Result := Handle.TryGetImage(Canvas, AImageIndex, AOverlayIndex, AMode, AColorPalette, AImage);
end;

function TcxCanvasBasedImageList.GetHandle: TcxCanvasBasedImageListHandle;
begin
  Result := TcxCanvasBasedImageListHandle(inherited Handle);
  if Result = nil then
    raise EInvalidOperation.Create(sdxInternalErrorResourceAbandoned);
end;

{ TcxCanvasBasedImageListHandle }

constructor TcxCanvasBasedImageListHandle.Create(AImageList: TCustomImageList);
begin
  inherited Create;
  FImageList := AImageList;
  FUseNativeDrawing := IsWinSevenOrLater and (AImageList.ShareImages or (AImageList is TcxSystemImageList));
end;

function TcxCanvasBasedImageListHandle.TryGetImage(
  ACanvas: TcxCustomCanvas; AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode;
  const AColorPalette: IdxColorPalette; out AImage: TcxCanvasBasedImage): Boolean;
var
  ABuffer: TdxFastDIB;
  AImageKey: TcxCanvasBasedImageCacheKey;
  AImages: TCustomImageList;
  AStyle: Integer;
begin
  if FChangeLink <> nil then
    AImages := FChangeLink.Sender
  else
    AImages := nil;

  Result := (AImages <> nil) and InRange(AImageIndex, 0, AImages.Count - 1);
  if Result then
  begin
    AImageKey.Mode := AMode;
    AImageKey.Index := AImageIndex;
    AImageKey.OverlayIndex := AOverlayIndex;
    AImageKey.PaletteID := dxGetColorPaletteID(AColorPalette);

    if not TcxCanvasBasedImageCache(FCache).TryGetValue(AImageKey, AImage) then
    begin
      ABuffer := TdxFastDIB.Create(AImages.Width, AImages.Height, True);
      try
        if FUseNativeDrawing and (AMode = idmNormal) then
        begin
          AStyle := ILD_NORMAL;
          if AOverlayIndex >= 0 then
            AStyle := AStyle or ILD_OVERLAYMASK and IndexToOverlayMask(AOverlayIndex + 1);
          ImageList_DrawEx(AImages.Handle, AImageIndex, ABuffer.DC, 0, 0, 0, 0, CLR_NONE, CLR_NONE, AStyle);
          if not TdxColors.ArePremultiplied(ABuffer.Bits, ABuffer.Width * ABuffer.Height) then
            ABuffer.Premultiply;
        end
        else
        begin
          cxPaintCanvas.BeginPaint(ABuffer.DC);
          try
            if AImageIndex >= 0 then
              TdxImageDrawer.DrawImage(cxPaintCanvas, ABuffer.ClientRect, nil, AImages, AImageIndex, ifmNormal, AMode, False, AColorPalette);
            if AOverlayIndex >= 0 then
              TdxImageDrawer.DrawImage(cxPaintCanvas, ABuffer.ClientRect, nil, AImages, AOverlayIndex, ifmNormal, AMode, False, AColorPalette);
          finally
            cxPaintCanvas.EndPaint;
          end;
        end;

        AImage := ACanvas.CreateImage(ABuffer, afPremultiplied);
        TcxCanvasBasedImageCache(FCache).Add(AImageKey, AImage);
      finally
        ABuffer.Free;
      end;
    end;
  end;
end;

procedure TcxCanvasBasedImageListHandle.CalculateHash(var AHash: Integer);
begin
  AHash := FImageList.GetHashCode;
end;

procedure TcxCanvasBasedImageListHandle.CreateNativeHandle(ACanvas: TcxCustomCanvas);
begin
  FChangeLink := TChangeLink.Create;
  FChangeLink.Sender := FImageList;
  FChangeLink.OnChange := ChangeHandler;
{$IFNDEF DELPHIXE8}
  FImageList.RegisterChanges(FChangeLink);
{$ENDIF}
  FCache := TcxCanvasBasedImageCache.Create;
end;

procedure TcxCanvasBasedImageListHandle.FreeNativeHandle;
begin
{$IFNDEF DELPHIXE8}
  FImageList.UnRegisterChanges(FChangeLink);
{$ENDIF}
  FreeAndNil(FChangeLink);
  FreeAndNil(FCache);
end;

function TcxCanvasBasedImageListHandle.GetSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if FChangeLink <> nil then
    Result := dxGetImageSize(FChangeLink.Sender, AScaleFactor)
  else
    Result := cxNullSize;
end;

function TcxCanvasBasedImageListHandle.IsEmpty: Boolean;
begin
  Result := (FChangeLink = nil) or (FChangeLink.Sender = nil);
end;

function TcxCanvasBasedImageListHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result := TcxCanvasBasedImageListHandle(AItem).FImageList = FImageList;
end;

procedure TcxCanvasBasedImageListHandle.ChangeHandler(Sender: TObject);
begin
  TcxCanvasBasedImageCache(FCache).Clear;
end;

{ TcxCanvasBasedImageListMap }

constructor TcxCanvasBasedImageListMap.Create(ACanvas: TcxCustomCanvas);
begin
  inherited Create(ACanvas);
  FMap := TdxObjectDictionary.Create([doOwnsValues], 16);
  FFreeNotificator := TcxFreeNotificator.Create(Self);
  FFreeNotificator.OnFreeNotification := FreeNotificationHandler;
end;

destructor TcxCanvasBasedImageListMap.Destroy;
begin
  Clear;
  FreeAndNil(FFreeNotificator);
  FreeAndNil(FMap);
  inherited;
end;

procedure TcxCanvasBasedImageListMap.Clear;
var
  AKey: TObject;
begin
  for AKey in FMap.Keys do
    FFreeNotificator.RemoveSender(TComponent(AKey));
  FMap.Clear;
end;

function TcxCanvasBasedImageListMap.GetOrCreate(AImageList: TCustomImageList): TcxCanvasBasedImageList;
begin
  if AImageList = nil then
    Exit(nil);
  if not FMap.TryGetValue(AImageList, TObject(Result)) then
  begin
    CheckState;
    Result := Canvas.CreateImageList(AImageList);
    FFreeNotificator.AddSender(AImageList);
    FMap.Add(AImageList, Result);
  end;
end;

procedure TcxCanvasBasedImageListMap.Remove(AImageList: TCustomImageList);
begin
  FFreeNotificator.RemoveSender(AImageList);
  FMap.Remove(AImageList);
end;

procedure TcxCanvasBasedImageListMap.FreeNotificationHandler(Sender: TComponent);
begin
  Remove(Sender as TCustomImageList);
end;

{ TcxCanvasBasedPath }

procedure TcxCanvasBasedPath.AddPolyline(const Points: array of TdxPointF);
begin
  if Length(Points) > 0 then
    AddPolyline(@Points[Low(Points)], Length(Points));
end;

procedure TcxCanvasBasedPath.AddLine(const P1, P2: TdxPointF);
begin
  AddPolyline([P1, P2]);
end;

{ TcxCanvasBasedPenHandle }

constructor TcxCanvasBasedPenHandle.Create(AColor: TdxAlphaColor; AWidth: Single; AStyle: TdxStrokeStyle);
begin
  FColor := AColor;
  FStyle := AStyle;
  FWidth := AWidth;
end;

constructor TcxCanvasBasedPenHandle.Create(AOptions: TdxStrokeOptions);
begin
  Create(AOptions.ActualColor, AOptions.Width, AOptions.Style);
end;

procedure TcxCanvasBasedPenHandle.CalculateHash(var AHash: Integer);
begin
  AddToHash(AHash, FColor, SizeOf(FColor));
  AddToHash(AHash, FStyle, SizeOf(FStyle));
  AddToHash(AHash, FWidth, SizeOf(FWidth));
end;

function TcxCanvasBasedPenHandle.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
begin
  Result :=
    (SameValue(TcxCanvasBasedPenHandle(AItem).FWidth, FWidth)) and
    (TcxCanvasBasedPenHandle(AItem).FStyle = FStyle) and
    (TcxCanvasBasedPenHandle(AItem).FColor = FColor);
end;

{ TcxCanvasBasedTextLayout }

destructor TcxCanvasBasedTextLayout.Destroy;
begin
  FreeAndNil(FTransform);
  inherited;
end;

procedure TcxCanvasBasedTextLayout.Draw(const ARect: TdxRectF);
begin
  Draw(FloatRectToRect(ARect));
end;

procedure TcxCanvasBasedTextLayout.Draw(const ARect: TRect);
var
  ACenter: TPoint;
  AClipped: Boolean;
  AClipRect: TRect;
  ASize: TSize;
  ATextBounds: TRect;
begin
  CheckState;
  ASize := MeasureSize;
  ATextBounds := cxRectBounds(CalculateOrigin(ARect, ASize), ASize.cx, ASize.cy);
  ATextBounds := cxRectContent(ATextBounds, FPadding);
  if cxRectIntersect(AClipRect, ATextBounds, ARect) then
  begin
    AClipped := not cxRectIsEqual(AClipRect, ATextBounds);
    if AClipped then
    begin
      Canvas.SaveClipRegion;
      Canvas.IntersectClipRect(AClipRect);
    end;

    if FTransform <> nil then
    begin
      ACenter := cxRectCenter(ATextBounds);

      Canvas.SaveWorldTransform;
      Canvas.ModifyWorldTransform(TXForm.CreateTranslateMatrix(ACenter.X, ACenter.Y));
      Canvas.ModifyWorldTransform(FTransform.Matrix);
      Canvas.ModifyWorldTransform(TXForm.CreateTranslateMatrix(-ACenter.X, -ACenter.Y));

      ATextBounds := cxRectBounds(ACenter.X - FTextSize.cx div 2, ACenter.Y - FTextSize.cy div 2, FTextSize);
    end;

    if (FFill <> nil) or (FStroke <> nil) then
      Canvas.RectangleCore(cxRectInflate(ATextBounds, FPadding), FFill, FStroke);

    DoDraw(ATextBounds);

    if FTransform <> nil then
      Canvas.RestoreWorldTransform;

    if AClipped then
      Canvas.RestoreClipRegion;
  end;
end;

function TcxCanvasBasedTextLayout.IsTruncated: Boolean;
begin
  CheckCalculated;
  Result := FTextTruncated;
end;

function TcxCanvasBasedTextLayout.MeasureSize: TSize;
begin
  CheckCalculated;
  Result := FSize;
end;

function TcxCanvasBasedTextLayout.MeasureSizeF: TdxSizeF;
begin
  Result := dxSizeF(MeasureSize);
end;

procedure TcxCanvasBasedTextLayout.Release;
begin
  dxChangeHandle(FFontHandle, nil);
  dxChangeHandle(FStroke, nil);
  dxChangeHandle(FFill, nil);
  inherited;
end;

procedure TcxCanvasBasedTextLayout.SetColor(AColor: TColor);
begin
  SetColor(dxColorToAlphaColor(AColor));
end;

procedure TcxCanvasBasedTextLayout.SetBackgroundAppearance(AFill: TcxCanvasBasedBrush; AStroke: TcxCanvasBasedPen);

  function GetHandle(AResource: TcxCanvasBasedResource): TcxCanvasBasedResourceHandle;
  begin
    if AResource <> nil then
      Result := AResource.Handle
    else
      Result := nil;
  end;

begin
  dxChangeHandle(FStroke, GetHandle(AStroke));
  dxChangeHandle(FFill, GetHandle(AFill));
end;

procedure TcxCanvasBasedTextLayout.SetFlag(ACxToFlag: Integer; AFlagState: Boolean);
var
  AFlags: Integer;
begin
  AFlags := FFlags;
  if AFlagState then
    AFlags := AFlags or ACxToFlag
  else
    AFlags := AFlags and not ACxToFlag;

  SetFlags(AFlags);
end;

procedure TcxCanvasBasedTextLayout.SetFlags(ACxTOFlags: Integer);
const
  LayoutRelatedFlags = CXTO_WORDBREAK or CXTO_SINGLELINE or CXTO_END_ELLIPSIS or CXTO_AUTOINDENTS or CXTO_CHARBREAK;
begin
  if FFlags <> ACxTOFlags then
  begin
    if (FFlags and LayoutRelatedFlags) <> (ACxTOFlags and LayoutRelatedFlags) then
      FIsDirty := True;
    FFlags := ACxTOFlags;
    ApplyFlags;
  end;
end;

procedure TcxCanvasBasedTextLayout.SetFont(AFont: TcxCanvasBasedFont; AOwnership: TdxObjectOwnership);
begin
  try
    DoSetFont(TcxCanvasBasedFontHandle(AFont.Handle));
  finally
    if AOwnership = ooOwned then
      AFont.Free;
  end;
end;

procedure TcxCanvasBasedTextLayout.SetFont(AFont: TFont; AOwnership: TdxObjectOwnership = ooReferenced);
begin
  CheckState;
  DoSetFont(Canvas.GetSharedFonts.GetOrCreate(AFont, AOwnership));
end;

procedure TcxCanvasBasedTextLayout.SetLayoutConstraints(AMaxWidth, AMaxHeight: Integer; AMaxRowCount: Integer = 0);
begin
  AMaxWidth := Max(AMaxWidth, 0);
  AMaxHeight := Max(AMaxHeight, 0);
  AMaxRowCount := Max(AMaxRowCount, 0);

  if AMaxRowCount <> FMaxRowCount then
  begin
    FMaxRowCount := AMaxRowCount;
    FIsDirty := True;
  end;

  if AMaxWidth <> FMaxWidth then
  begin
    if (AMaxWidth < FSize.cx) then
      FIsDirty := True;
    if (AMaxWidth > FSize.cx) and (FFlags and CXTO_WORDBREAK <> 0) then
      FIsDirty := True;
    if (FFlags and CXTO_END_ELLIPSIS <> 0) then
      FIsDirty := True;
    FMaxWidth := AMaxWidth;
  end;

  if AMaxHeight <> FMaxHeight then
  begin
    if (AMaxHeight < FSize.cy) or (AMaxHeight > FSize.cy) and (FFlags and CXTO_END_ELLIPSIS <> 0) then
      FIsDirty := True;
    FMaxHeight := AMaxHeight;
  end;
end;

procedure TcxCanvasBasedTextLayout.SetLayoutConstraints(const R: TRect; AMaxRowCount: Integer = 0);
begin
  SetLayoutConstraints(cxRectWidth(R), cxRectHeight(R), AMaxRowCount);
end;

procedure TcxCanvasBasedTextLayout.SetLayoutConstraints(const R: TdxRectF; AMaxRowCount: Integer = 0);
begin
  SetLayoutConstraints(FloatRectToRect(R), AMaxRowCount);
end;

procedure TcxCanvasBasedTextLayout.SetPadding(const APadding: TRect);
begin
  if not cxRectIsEqual(APadding, FPadding) then
  begin
    FPadding := APadding;
    FIsDirty := True;
  end;
end;

procedure TcxCanvasBasedTextLayout.SetPaintOnGlass(AValue: Boolean);
begin
  FPaintOnGlass := AValue;
end;

procedure TcxCanvasBasedTextLayout.SetRotation(AAngle: Single);
begin
  AAngle := dxNormalizeAngle(AAngle);
  if (FTransform = nil) and IsZero(AAngle) then
    Exit;
  if (FTransform = nil) or not FTransform.Equals(AAngle) then
  begin
    if IsZero(AAngle) then
      SetTransform(nil)
    else
      SetTransform(TcxCanvasBasedTextLayoutComplexTransform.Create(AAngle));
  end;
end;

procedure TcxCanvasBasedTextLayout.SetRotation(AAngle: TcxRotationAngle);
begin
  if (FTransform = nil) and (AAngle = ra0) then
    Exit;
  if (FTransform = nil) or not FTransform.Equals(AAngle) then
  begin
    if AAngle <> ra0 then
      SetTransform(TcxCanvasBasedTextLayoutSimpleTransform.Create(AAngle))
    else
      SetTransform(nil);
  end;
end;

procedure TcxCanvasBasedTextLayout.SetText(const AText: string);
begin
  if AText <> FText then
  begin
    FText := AText;
    TextChanged;
  end;
end;

procedure TcxCanvasBasedTextLayout.ApplyFlags;
begin
  // do nothing;
end;

function TcxCanvasBasedTextLayout.CalculateRowCount(AMaxHeight, ARowHeight: Single): Integer;
begin
  if FFlags and CXTO_EDITCONTROL <> 0 then
    Result := Trunc(AMaxHeight / ARowHeight)
  else
    Result := Ceil(AMaxHeight / ARowHeight);
end;

procedure TcxCanvasBasedTextLayout.CheckCalculated;
begin
  if FIsDirty then
  begin
    DoCalculate;
    FIsDirty := False;
  end;
end;

procedure TcxCanvasBasedTextLayout.DoCalculate;
var
  APaddingHeight: Integer;
  APaddingWidth: Integer;
  AMaxHeight: Integer;
  AMaxWidth: Integer;
begin
  AMaxHeight := FMaxHeight;
  AMaxWidth := FMaxWidth;
  APaddingHeight := FPadding.Top + FPadding.Bottom;
  APaddingWidth := FPadding.Left + FPadding.Right;

  if FTransform <> nil then
    FTransform.CalculateConstraints(AMaxWidth, AMaxHeight);
  if AMaxWidth <> 0 then
    Dec(AMaxWidth, APaddingWidth);
  if AMaxHeight <> 0 then
    Dec(AMaxHeight, APaddingHeight);

  DoCalculate(AMaxWidth, AMaxHeight, FMaxRowCount);

  FSize.cx := FTextSize.cx + APaddingWidth;
  FSize.cy := FTextSize.cy + APaddingHeight;

  if FTransform <> nil then
    FTransform.CalculateSize(FSize);
end;

procedure TcxCanvasBasedTextLayout.DoSetFont(AFontHandle: TcxCanvasBasedFontHandle);
begin
  if AFontHandle = nil then
    raise EInvalidArgument.Create(sdxInternalErrorFontNotSet);
  if dxChangeHandle(FFontHandle, AFontHandle) then
    FontChanged;
end;

procedure TcxCanvasBasedTextLayout.FontChanged;
begin
  FIsDirty := True;
end;

procedure TcxCanvasBasedTextLayout.LayoutChanged;
begin
  FIsDirty := True;
end;

procedure TcxCanvasBasedTextLayout.TextChanged;
begin
  FIsDirty := True;
end;

function TcxCanvasBasedTextLayout.CalculateOrigin(const ARect: TRect; const ASize: TSize): TPoint;
begin
  if FFlags and CXTO_RIGHT = CXTO_RIGHT then
    Result.X := ARect.Right - ASize.cx
  else if FFlags and CXTO_CENTER_HORIZONTALLY = CXTO_CENTER_HORIZONTALLY then
    Result.X := (ARect.Right + ARect.Left - ASize.cx) div 2
  else
    Result.X := ARect.Left;

  if FFlags and CXTO_PREVENT_LEFT_EXCEED = CXTO_PREVENT_LEFT_EXCEED then
    Result.X := Max(Result.X, ARect.Left);

  if FFlags and CXTO_BOTTOM = CXTO_BOTTOM then
    Result.Y := ARect.Bottom - ASize.cy
  else if FFlags and CXTO_CENTER_VERTICALLY = CXTO_CENTER_VERTICALLY then
    Result.Y := (ARect.Bottom + ARect.Top - ASize.cy) div 2
  else
    Result.Y := ARect.Top;

  if FFlags and CXTO_PREVENT_TOP_EXCEED = CXTO_PREVENT_TOP_EXCEED then
    Result.Y := Max(Result.Y, ARect.Top);
end;

function TcxCanvasBasedTextLayout.FloatRectToRect(const R: TdxRectF): TRect;
begin
  Result.Left := Ceil(R.Left);
  Result.Top  := Ceil(R.Top);
  Result.Right := Result.Left + Trunc(R.Width);
  Result.Bottom := Result.Top + Trunc(R.Height);
end;

procedure TcxCanvasBasedTextLayout.SetTransform(ATransform: TcxCanvasBasedTextLayoutCustomTransform);
begin
  if FTransform <> ATransform then
  begin
    FreeAndNil(FTransform);
    FTransform := ATransform;
    LayoutChanged;
  end;
end;

{ TcxCanvasBasedTextLayoutCustomTransform }

constructor TcxCanvasBasedTextLayoutCustomTransform.Create(const AAngle: Single);
begin
  FAngle := AAngle;
  FMatrix := TXForm.CreateRotationMatrix(AAngle);
end;

function TcxCanvasBasedTextLayoutCustomTransform.Equals(const AAngle: TcxRotationAngle): Boolean;
begin
  Result := Equals(cxRotationAngleToAngle[AAngle]);
end;

function TcxCanvasBasedTextLayoutCustomTransform.Equals(const AAngle: Single): Boolean;
begin
  Result := SameValue(AAngle, FAngle);
end;

{ TcxCanvasBasedSharedBrushes }

constructor TcxCanvasBasedSharedBrushes.Create(ACanvas: TcxCustomCanvas; AClass: TcxCanvasBasedBrushHandleClass);
begin
  inherited Create(ACanvas);
  FClass := AClass;
end;

function TcxCanvasBasedSharedBrushes.GetOrCreate(AColor: TdxAlphaColor): TcxCanvasBasedBrushHandle;
begin
  Result := TcxCanvasBasedBrushHandle(Share(FClass.Create(AColor)));
end;

function TcxCanvasBasedSharedBrushes.GetOrCreate(AOptions: TdxFillOptions): TcxCanvasBasedBrushHandle;
begin
  Result := TcxCanvasBasedBrushHandle(Share(FClass.Create(AOptions)));
end;

{ TcxCanvasBasedSharedFonts }

constructor TcxCanvasBasedSharedFonts.Create(ACanvas: TcxCustomCanvas; AClass: TcxCanvasBasedFontHandleClass);
begin
  inherited Create(ACanvas);
  FClass := AClass;
end;

function TcxCanvasBasedSharedFonts.GetOrCreate(const AFont: TdxFontOptions): TcxCanvasBasedFontHandle;
begin
  Result := TcxCanvasBasedFontHandle(Share(FClass.Create(AFont)));
end;

function TcxCanvasBasedSharedFonts.GetOrCreate(const AFont: TFont; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedFontHandle;
begin
  Result := TcxCanvasBasedFontHandle(Share(FClass.Create(AFont, AOwnership)));
end;

{ TcxCanvasBasedSharedImageLists }

constructor TcxCanvasBasedSharedImageLists.Create(ACanvas: TcxCustomCanvas; AClass: TcxCanvasBasedImageListHandleClass);
begin
  inherited Create(ACanvas);
  FClass := AClass;
end;

function TcxCanvasBasedSharedImageLists.GetOrCreate(const AImageList: TCustomImageList): TcxCanvasBasedImageListHandle;
begin
  Result := TcxCanvasBasedImageListHandle(Share(FClass.Create(AImageList)));
end;

{ TcxCanvasBasedSharedPens }

constructor TcxCanvasBasedSharedPens.Create(ACanvas: TcxCustomCanvas; AClass: TcxCanvasBasedPenHandleClass);
begin
  inherited Create(ACanvas);
  FClass := AClass;
end;

function TcxCanvasBasedSharedPens.GetOrCreate(AColor: TdxAlphaColor; AWidth: Single; AStyle: TdxStrokeStyle): TcxCanvasBasedPenHandle;
begin
  Result := TcxCanvasBasedPenHandle(Share(FClass.Create(AColor, AWidth, AStyle)));
end;

function TcxCanvasBasedSharedPens.GetOrCreate(AOptions: TdxStrokeOptions): TcxCanvasBasedPenHandle;
begin
  Result := TcxCanvasBasedPenHandle(Share(FClass.Create(AOptions)));
end;

{ TcxCustomCanvas }

constructor TcxCustomCanvas.Create;
begin
  inherited;
  FUseRightToLeftAlignment := bDefault;
  FResources := TList.Create;
  FResources.Capacity := 4096;
end;

destructor TcxCustomCanvas.Destroy;
begin
  FreeAndNil(FResources);
  inherited;
end;

procedure TcxCustomCanvas.BeforeDestruction;
begin
  ReleaseResources;
  inherited BeforeDestruction;
end;

function TcxCustomCanvas.CheckIsValid(var AResource{: TcxCanvasBasedResource}): Boolean;
begin
  if (TcxCanvasBasedResource(AResource) <> nil) and (TcxCanvasBasedResource(AResource).Canvas <> Self) then
    FreeAndNil(TcxCanvasBasedResource(AResource));
  Result := TcxCanvasBasedResource(AResource) <> nil;
end;

function TcxCustomCanvas.CreateBrush(AColor: TdxAlphaColor): TcxCanvasBasedBrush;
begin
  if AColor <> TdxAlphaColors.Empty then
    Result := TcxCanvasBasedBrush.Create(Self, GetSharedBrushes.GetOrCreate(AColor))
  else
    Result := nil;
end;

function TcxCustomCanvas.CreateBrush(AFillOptions: TdxFillOptions): TcxCanvasBasedBrush;
begin
  if AFillOptions <> nil then
    Result := TcxCanvasBasedBrush.Create(Self, GetSharedBrushes.GetOrCreate(AFillOptions))
  else
    Result := nil;
end;

function TcxCustomCanvas.CreateFonT(AFont: TFont; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedFont; 
begin
  if AFont <> nil then
    Result := TcxCanvasBasedFont.Create(Self, GetSharedFonts.GetOrCreate(AFont, AOwnership))
  else
    Result := nil;
end;

function TcxCustomCanvas.CreateFonT(AFont: TdxFontOptions): TcxCanvasBasedFont; 
begin
  if AFont <> nil then
    Result := TcxCanvasBasedFont.Create(Self, GetSharedFonts.GetOrCreate(AFont))
  else
    Result := nil;
end;

function TcxCustomCanvas.CreateImage(AGraphic: TGraphic): TcxCanvasBasedImage;
var
  ABitmap: TBitmap;
begin
  if AGraphic is TdxGPImage then
    Result := CreateImage(TdxGPImage(AGraphic))
  else
  begin
    ABitmap := cxGetAsBitmap(AGraphic);
    try
      Result := CreateImage(ABitmap);
    finally
      ABitmap.Free;
    end;
  end;
end;

function TcxCustomCanvas.CreateImageList(AImageList: TCustomImageList): TcxCanvasBasedImageList;
begin
  if AImageList <> nil then
    Result := TcxCanvasBasedImageList.Create(Self, GetSharedImageLists.GetOrCreate(AImageList))
  else
    Result := nil;
end;

function TcxCustomCanvas.CreateImage(AImage: TdxGPImage; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedImage;
var
  ABitmap: TBitmap;
begin
  ABitmap := AImage.GetAsBitmap;
  try
    Result := CreateImage(ABitmap, afPremultiplied);
  finally
    ABitmap.Free;
  end;
  if AOwnership = ooOwned then
    AImage.Free;
end;

function TcxCustomCanvas.CreatePeN(AColor: TdxAlphaColor; AWidth: Single; AStyle: TdxStrokeStyle): TcxCanvasBasedPen;
begin
  Result := TcxCanvasBasedPen.Create(Self, GetSharedPens.GetOrCreate(AColor, AWidth, AStyle));
end;

function TcxCustomCanvas.CreatePeN(AStrokeOptions: TdxStrokeOptions): TcxCanvasBasedPen; 
begin
  Result := TcxCanvasBasedPen.Create(Self, GetSharedPens.GetOrCreate(AStrokeOptions));
end;

procedure TcxCustomCanvas.DrawNativeObject(const R: TRect;
  const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawExProc);
begin
  if RectVisible(R) then
    DrawNativeObject(R, ACacheKey,
      procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
      begin
        dxGPPaintCanvas.BeginPaint(ACanvas.Handle, R);
        AProc(dxGPPaintCanvas, R);
        dxGPPaintCanvas.EndPaint;
      end);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TBitmap; const ATargetRect: TRect; ACache: PcxCanvasBasedImage);
begin
  DrawBitmap(ABitmap, ATargetRect, ABitmap.AlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TBitmap;
  const ATargetRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  DrawBitmap(ABitmap, ATargetRect, cxGetImageClientRect(ABitmap), AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TBitmap; const ATargetRect, ASourceRect: TRect; ACache: PcxCanvasBasedImage);
begin
  DrawBitmap(ABitmap, ATargetRect, ASourceRect, ABitmap.AlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TBitmap;
  const ATargetRect, ASourceRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
var
  AImage: TcxCanvasBasedImage;
begin
  if ACache <> nil then
  begin
    if not CheckIsValid(ACache^) then
      ACache^ := CreateImage(ABitmap, AAlphaFormat);
    ACache^.Draw(ATargetRect, ASourceRect);
  end
  else
  begin
    AImage := CreateImage(ABitmap, AAlphaFormat);
    try
      AImage.Draw(ATargetRect, ASourceRect);
    finally
      AImage.Free;
    end;
  end;
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TdxFastDIB;
  const ATargetRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  DrawBitmap(ABitmap, ATargetRect, ABitmap.ClientRect, AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TdxFastDIB;
  const ATargetRect, ASourceRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  DrawFastDIB(ABitmap, ATargetRect, ASourceRect, AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect: TRect;
  AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil);
begin
  DrawBitmap(ABitmap, ATargetRect, ABitmap.ClientRect, AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect, ASourceRect: TRect;
  AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil);
begin
  DrawFastDIB(ABitmap, ATargetRect, ASourceRect, AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TdxFastDIB;
  const ATargetRect: TdxRectF; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  DrawBitmap(ABitmap, ATargetRect, cxRectF(ABitmap.ClientRect), AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TdxFastDIB;
  const ATargetRect, ASourceRect: TdxRectF; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  DrawFastDIB(ABitmap, ATargetRect, ASourceRect, AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TdxGpFastDIB;
  const ATargetRect: TdxRectF; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  DrawBitmap(ABitmap, ATargetRect, cxRectF(ABitmap.ClientRect), AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawBitmap(ABitmap: TdxGpFastDIB;
  const ATargetRect, ASourceRect: TdxRectF; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  DrawFastDIB(ABitmap, ATargetRect, ASourceRect, AAlphaFormat, ACache);
end;

procedure TcxCustomCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; ACache: PcxCanvasBasedImage = nil);
var
  ATempImage: TcxCanvasBasedImage;
begin
  ATempImage := AllocateTempImage(AImage, ACache);
  try
    ATempImage.Draw(ATargetRect);
  finally
    ReleaseTempResource(ATempImage, ACache);
  end;
end;

procedure TcxCustomCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TdxRectF; ACache: PcxCanvasBasedImage = nil);
var
  ATempImage: TcxCanvasBasedImage;
begin
  ATempImage := AllocateTempImage(AImage, ACache);
  try
    ATempImage.Draw(ATargetRect);
  finally
    ReleaseTempResource(ATempImage, ACache);
  end;
end;

procedure TcxCustomCanvas.DrawComplexFrame(const R: TRect;
  ALeftTopColor, ARightBottomColor: TColor; ABorders: TcxBorders; ABorderWidth: Integer);
begin
  FrameRect(R, ALeftTopColor, ABorderWidth, ABorders - [bRight, bBottom]);
  FrameRect(R, ARightBottomColor, ABorderWidth, ABorders - [bLeft, bTop]);
end;

procedure TcxCustomCanvas.DrawEdge(const R: TRect; ASunken, AOuter: Boolean; ABorders: TcxBorders);
begin
  if ASunken then
  begin
    if AOuter then
      DrawComplexFrame(R, clBtnShadow, clBtnHighlight, ABorders)
    else
      DrawComplexFrame(R, cl3DDkShadow{clBtnText}, cl3DLight{clBtnFace}, ABorders)
  end
  else
  begin
    if AOuter then
      DrawComplexFrame(R, cl3DLight{clBtnFace}, cl3DDkShadow{clBtnText}, ABorders)
    else
      DrawComplexFrame(R, clBtnHighlight, clBtnShadow, ABorders);
  end;
end;

procedure TcxCustomCanvas.FrameRect(const R: TRect; AColor: TColor; ALineWidth: Integer; ABorders: TcxBorders);
begin
  if IsRectEmpty(R) or (AColor = clNone) then
    Exit;
  if bLeft in ABorders then
    FillRect(cxRect(R.Left, R.Top, Min(R.Left + ALineWidth, R.Right), R.Bottom), AColor);
  if bRight in ABorders then
    FillRect(cxRect(Max(R.Right - ALineWidth, R.Left), R.Top, R.Right, R.Bottom), AColor);
  if bTop in ABorders then
    FillRect(cxRect(R.Left, R.Top, R.Right, Min(R.Top + ALineWidth, R.Bottom)), AColor);
  if bBottom in ABorders then
    FillRect(cxRect(R.Left, Max(R.Bottom - ALineWidth, R.Top), R.Right, R.Bottom), AColor);
end;

procedure TcxCustomCanvas.FrameRect(const R: TRect; AColor: TdxAlphaColor; ALineWidth: Integer; ABorders: TcxBorders);
var
  R1: TRect;
begin
  if cxRectIsEmpty(R) or (AColor = TdxAlphaColors.Empty) or (AColor = TdxAlphaColors.Transparent) then
    Exit;

  R1 := R;

  if bLeft in ABorders then
  begin
    FillRect(cxRect(R1.Left, R1.Top, Min(R1.Left + ALineWidth, R1.Right), R1.Bottom), AColor);
    Inc(R1.Left, ALineWidth); 
  end;

  if bRight in ABorders then
  begin
    FillRect(cxRect(Max(R1.Right - ALineWidth, R1.Left), R1.Top, R1.Right, R1.Bottom), AColor);
    Dec(R1.Right, ALineWidth);
  end;

  if bTop in ABorders then
    FillRect(cxRect(R1.Left, R1.Top, R1.Right, Min(R1.Top + ALineWidth, R1.Bottom)), AColor);

  if bBottom in ABorders then
    FillRect(cxRect(R1.Left, Max(R1.Bottom - ALineWidth, R1.Top), R1.Right, R1.Bottom), AColor);
end;

procedure TcxCustomCanvas.FrameRect(const R: TdxRectF; AColor: TdxAlphaColor;
  ALineWidth: Single = 1; ABorders: TcxBorders = cxBordersAll);
var
  ABrush: TcxCanvasBasedBrush;
  R1: TdxRectF;
begin
  if cxRectIsEmpty(R) or not dxAlphaColorIsValid(AColor) or (ALineWidth <= 0) or (ABorders = []) then
    Exit;

  ABrush := CreateBrush(AColor);
  try
    R1 := R;
    if bLeft in ABorders then
    begin
      FillRect(cxRectF(R1.Left, R1.Top, Min(R1.Left + ALineWidth, R1.Right), R1.Bottom), ABrush);
      R1.Left := R1.Left + ALineWidth; 
    end;

    if bRight in ABorders then
    begin
      FillRect(cxRectF(Max(R1.Right - ALineWidth, R1.Left), R1.Top, R1.Right, R1.Bottom), ABrush);
      R1.Right := R1.Right - ALineWidth;
    end;

    if bTop in ABorders then
      FillRect(cxRectF(R1.Left, R1.Top, R1.Right, Min(R1.Top + ALineWidth, R1.Bottom)), ABrush);

    if bBottom in ABorders then
      FillRect(cxRectF(R1.Left, Max(R1.Bottom - ALineWidth, R1.Top), R1.Right, R1.Bottom), ABrush);
  finally
    ABrush.Free;
  end;
end;

procedure TcxCustomCanvas.Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
  AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid);
begin
  Arc(AEllipse, AStartPoint, AEndPoint, dxColorToAlphaColor(AColor), APenWidth, APenStyle);
end;

procedure TcxCustomCanvas.Ellipse(const R: TRect; ABrushColor, APenColor: TColor; APenStyle: TPenStyle; APenWidth: Integer);
begin
  Ellipse(R, dxColorToAlphaColor(ABrushColor), dxColorToAlphaColor(APenColor), APenStyle, APenWidth);
end;

procedure TcxCustomCanvas.FillPixel(X, Y: Integer; AColor: TColor);
begin
  FillRect(cxRect(X, Y, X + 1, Y + 1), AColor);
end;

procedure TcxCustomCanvas.FillPolygon(const P: array of TdxPointF; ABrush: TcxCanvasBasedBrush);
begin
  Polygon(P, ABrush, nil);
end;

procedure TcxCustomCanvas.FillPolygon(const P: array of TPoint; AColor: TColor);
begin
  Polygon(P, AColor, clNone);
end;

procedure TcxCustomCanvas.FillPolygon(const P: array of TPoint; AColor: TdxAlphaColor);
begin
  Polygon(P, AColor, TdxAlphaColors.Empty);
end;

procedure TcxCustomCanvas.FillRect(const R: TRect; AColor: TColor);
begin
  FillRect(R, dxColorToAlphaColor(AColor));
end;

procedure TcxCustomCanvas.FillRect(const R: TRect; AColor: TColor; AAlpha: Byte);
begin
  FillRect(R, dxColorToAlphaColor(AColor, AAlpha));
end;

procedure TcxCustomCanvas.FillRect(const R: TRect; AImage: TcxCanvasBasedImage);
var
  ACol, AColCount: Integer;
  ARect: TRect;
  ARow, ARowCount: Integer;
begin
  SaveClipRegion;
  try
    IntersectClipRect(R);
    AColCount := Ceil(cxRectWidth(R) / AImage.Width);
    ARowCount := Ceil(cxRectHeight(R) / AImage.Height);
    for ACol := 0 to AColCount - 1 do
    begin
      ARect := cxRectBounds(R.Left + ACol * AImage.Width, R.Top, AImage.Width, AImage.Height);
      for ARow := 0 to ARowCount - 1 do
      begin
        AImage.Draw(ARect);
        ARect := cxRectOffsetVert(ARect, AImage.Height);
      end;
    end;
  finally
    RestoreClipRegion;
  end;
end;

procedure TcxCustomCanvas.FillRect(const R: TRect; AImage: TdxGPImage; ACache: PcxCanvasBasedImage = nil);
var
  ATempImage: TcxCanvasBasedImage;
begin
  ATempImage := AllocateTempImage(AImage, ACache);
  try
    FillRect(R, ATempImage);
  finally
    ReleaseTempResource(ATempImage, ACache);
  end;
end;

procedure TcxCustomCanvas.FillRect(const R: TdxRectF; AColor: TdxAlphaColor);
var
  ABrush: TcxCanvasBasedBrush;
begin
  ABrush := CreateBrush(AColor);
  try
    FillRect(R, ABrush);
  finally
    ABrush.Free;
  end;
end;

procedure TcxCustomCanvas.FillRect(const R: TdxRectF; ABrush: TcxCanvasBasedBrush);
begin
  Rectangle(R, ABrush, nil);
end;

procedure TcxCustomCanvas.FillRectByGradient(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode);
begin
  if (AColor1 = AColor2) or not dxAlphaColorIsValid(AColor2) then
    FillRect(R, AColor1)
  else
    if not dxAlphaColorIsValid(AColor1) then
      FillRect(R, AColor2)
    else
      FillRectByGradientCore(R, AColor1, AColor2, AMode);
end;

procedure TcxCustomCanvas.FillRectByGradient(const R: TRect; AColor1, AColor2: TColor; AHorizontal: Boolean);
const
  Mode: array[Boolean] of TdxGPLinearGradientMode = (LinearGradientModeVertical, LinearGradientModeHorizontal);
begin
  FillRectByGradient(R, dxColorToAlphaColor(AColor1), dxColorToAlphaColor(AColor2), Mode[AHorizontal]);
end;

procedure TcxCustomCanvas.FocusRectangle(const R: TRect);
begin
  Rectangle(R, clNone, clBlack, psDash);
end;

procedure TcxCustomCanvas.Line(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen);
begin
  Polyline([P1, P2], APen);
end;

procedure TcxCustomCanvas.Line(const P1, P2: TPoint; AColor: TColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  Polyline([P1, P2], AColor, APenWidth, APenStyle);
end;

procedure TcxCustomCanvas.Line(const P1, P2: TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  Polyline([P1, P2], AColor, APenWidth, APenStyle);
end;

procedure TcxCustomCanvas.Polygon(const P: array of TPoint; ABrushColor, APenColor: TColor);
begin
  Polygon(P, dxColorToAlphaColor(ABrushColor), dxColorToAlphaColor(APenColor));
end;

procedure TcxCustomCanvas.Polygon(const P: array of TdxPointF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  ALength: Integer;
begin
  ALength := Length(P);
  if ALength > 0 then
    Polygon(@P[0], ALength, ABrush, APen);
end;

procedure TcxCustomCanvas.Polyline(const P: array of TPoint;
  AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid);
begin
  Polyline(P, dxColorToAlphaColor(AColor), APenWidth, APenStyle);
end;

procedure TcxCustomCanvas.Polyline(const P: array of TdxPointF; APen: TcxCanvasBasedPen);
var
  ALength: Integer;
begin
  ALength := Length(P);
  if ALength > 0 then
    Polyline(@P[0], ALength, APen);
end;

procedure TcxCustomCanvas.Rectangle(const R: TRect; ABrushColor, APenColor: TColor; APenStyle: TPenStyle; APenWidth: Integer);
begin
  Rectangle(R, dxColorToAlphaColor(ABrushColor), dxColorToAlphaColor(APenColor), APenStyle, APenWidth);
end;

function TcxCustomCanvas.MoveWindowOrg(const P: TPoint): TPoint;
begin
  Result := WindowOrg;
  WindowOrg := cxPointOffset(Result, P, False);
end;

function TcxCustomCanvas.GetDefaultUseRightToLeftAlignment: Boolean;
begin
  Result := False;
end;

function TcxCustomCanvas.GetIsLowColorsMode: Boolean;
begin
  Result := False;
end;

procedure TcxCustomCanvas.ReleaseResources;
var
  I: Integer;
begin
  for I := FResources.Count - 1 downto 0 do
    TcxCanvasBasedResource(FResources.List[I]).Release;
  FResources.Count := 0;
end;

function TcxCustomCanvas.AllocateTempImage(AImage: TdxGPImage; AImageCache: PcxCanvasBasedImage): TcxCanvasBasedImage;
begin
  if AImage = nil then
    Result := nil
  else
    if AImageCache <> nil then
    begin
      if not CheckIsValid(AImageCache^) then
        AImageCache^ := CreateImage(AImage, ooReferenced);
      Result := AImageCache^;
    end
    else
      Result := CreateImage(AImage, ooReferenced);
end;

procedure TcxCustomCanvas.ReleaseTempResource(AResource: TcxCanvasBasedResource; ACache: Pointer);
begin
  if (ACache = nil) or (PcxCanvasBasedResource(ACache)^ <> AResource) then
    AResource.Free;
end;

procedure TcxCustomCanvas.RestoreAntialiasing;
begin
end;

procedure TcxCustomCanvas.DrawFastDIB(
  AFastDIB: TdxCustomFastDIB; const ATargetRect, ASourceRect: TRect;
  AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil);
var
  AImage: TcxCanvasBasedImage;
begin
  if ACache <> nil then
  begin
    if not CheckIsValid(ACache^) then
      ACache^ := CreateImage(AFastDIB, AAlphaFormat);
    ACache^.Draw(ATargetRect, ASourceRect);
  end
  else
  begin
    AImage := CreateImage(AFastDIB, AAlphaFormat);
    try
      AImage.Draw(ATargetRect, ASourceRect);
    finally
      AImage.Free;
    end;
  end;
end;

procedure TcxCustomCanvas.DrawFastDIB(
  AFastDIB: TdxCustomFastDIB; const ATargetRect, ASourceRect: TdxRectF;
  AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil);
var
  AImage: TcxCanvasBasedImage;
begin
  if ACache <> nil then
  begin
    if not CheckIsValid(ACache^) then
      ACache^ := CreateImage(AFastDIB, AAlphaFormat);
    ACache^.Draw(ATargetRect, ASourceRect);
  end
  else
  begin
    AImage := CreateImage(AFastDIB, AAlphaFormat);
    try
      AImage.Draw(ATargetRect, ASourceRect);
    finally
      AImage.Free;
    end;
  end;
end;

function TcxCustomCanvas.GetUseRightToLeftAlignment: Boolean;
begin
  if FUseRightToLeftAlignment = bDefault then
    Result := GetDefaultUseRightToLeftAlignment
  else
    Result := FUseRightToLeftAlignment = bTrue;
end;

procedure TcxCustomCanvas.IntersectClipRect(const ARect: TdxRectF);
begin
  IntersectClipRect(ARect.InflateToTRect);
end;

function TcxCustomCanvas.RectVisible(const R: TdxRectF): Boolean;
begin
  Result := RectVisible(R.InflateToTRect);
end;

procedure TcxCustomCanvas.SetUseRightToLeftAlignment(const Value: Boolean);
begin
  FUseRightToLeftAlignment := dxBooleanToDefaultBoolean(Value);
end;

procedure TcxCustomCanvas.Rectangle(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  ABrushHandle: TcxCanvasBasedBrushHandle;
  APenHandle: TcxCanvasBasedPenHandle;
begin
  if APen <> nil then
    APenHandle := TcxCanvasBasedPenHandle(APen.Handle)
  else
    APenHandle := nil;

  if ABrush <> nil then
    ABrushHandle := TcxCanvasBasedBrushHandle(ABrush.Handle)
  else
    ABrushHandle := nil;

  RectangleCore(R, ABrushHandle, APenHandle);
end;

procedure TcxCustomCanvas.EnableAntialiasing(AEnable: Boolean);
begin
end;

{ TcxCustomGdiBasedCanvas }

function TcxCustomGdiBasedCanvas.CreateBrush(AGpBrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership): TcxCanvasBasedBrush;
begin
  Result := DoCreateBrush(AGpBrush, AOwnership, True);
end;

function TcxCustomGdiBasedCanvas.CreateImage(ABitmap: TBitmap; AAlphaFormat: TAlphaFormat = afIgnored): TcxCanvasBasedImage;
begin
  Result := CreateImage(TdxGPImage.CreateFromBitmap(ABitmap), ooOwned);
end;

function TcxCustomGdiBasedCanvas.CreateImage(ABitmap: TdxCustomFastDIB; AAlphaFormat: TAlphaFormat = afIgnored): TcxCanvasBasedImage;
begin
  Result := CreateImage(TdxGPImage.CreateFromBits(ABitmap.Width, ABitmap.Height, ABitmap.Bits, AAlphaFormat), ooOwned);
end;

function TcxCustomGdiBasedCanvas.CreateImage(AGpImage: TdxGPImage; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedImage;
begin
  Result := TcxGdiCanvasBasedImage.Create(Self, AGpImage, AOwnership);
end;

function TcxCustomGdiBasedCanvas.CreatePath: TcxCanvasBasedPath;
begin
  Result := TcxGdiCanvasBasedPath.Create(Self);
end;

function TcxCustomGdiBasedCanvas.CreatePeN(AGpPen: TdxGPPen; AOwnership: TdxObjectOwnership): TcxCanvasBasedPen;
begin
  Result := TcxCanvasBasedPen.Create(Self, TcxGdiCanvasBasedPenHandle.Create(AGpPen, AOwnership));
end;

function TcxCustomGdiBasedCanvas.DoCreateBrush(AGpBrush: TdxGPCustomBrush;
  AOwnership: TdxObjectOwnership; AUseTargetRectCorrection: Boolean): TcxCanvasBasedBrush;
begin
  Result := TcxCanvasBasedBrush.Create(Self, TcxGdiCanvasBasedBrushHandle.Create(AGpBrush, AOwnership));
  TcxGdiCanvasBasedBrushHandle(Result.Handle).Brush.UseTargetRectCorrection := AUseTargetRectCorrection;
end;

procedure TcxCustomGdiBasedCanvas.FillRect(const R: TRect; AImage: TcxCanvasBasedImage);
begin
  FillRect(R, TcxGdiCanvasBasedImage(AImage).Image);
end;

function TcxCustomGdiBasedCanvas.GetGpBrushAndPen(
  ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen;
  out AGpBrush: TdxGPCustomBrush; out AGpPen: TdxGPPen): Boolean;
begin
  if (ABrush <> nil) and not ABrush.IsEmpty then
    AGpBrush := TcxGdiCanvasBasedBrushHandle(ABrush.Handle).FBrush
  else
    AGpBrush := nil;

  if (APen <> nil) and not APen.IsEmpty then
    AGpPen := TcxGdiCanvasBasedPenHandle(APen.Handle).FPen
  else
    AGpPen := nil;

  Result := (AGpBrush <> nil) or (AGpPen <> nil);
end;

function TcxCustomGdiBasedCanvas.GetSharedBrushes: TcxCanvasBasedSharedBrushes;
begin
  Result := TcxGdiCanvasBasedSharedBrushes.Instance;
end;

function TcxCustomGdiBasedCanvas.GetSharedFonts: TcxCanvasBasedSharedFonts;
begin
  Result := TcxGdiCanvasBasedSharedFonts.Instance;
end;

function TcxCustomGdiBasedCanvas.GetSharedImageLists: TcxCanvasBasedSharedImageLists;
begin
  Result := TcxGdiCanvasBasedSharedImageLists.Instance;
end;

function TcxCustomGdiBasedCanvas.GetSharedPens: TcxCanvasBasedSharedPens;
begin
  Result := TcxGdiCanvasBasedSharedPens.Instance;
end;

{ TcxGdiBasedCanvas }

destructor TcxGdiBasedCanvas.Destroy;
begin
  FreeAndNil(FSavedWorldTransforms);
  inherited Destroy;
end;

function TcxGdiBasedCanvas.CreateTextLayout: TcxCanvasBasedTextLayout;
begin
  Result := TcxGdiCanvasBasedTextLayout.Create(Self);
end;

procedure TcxGdiBasedCanvas.DrawNativeObject(const R: TRect;
  const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc);
begin
  AProc(Self, R);
end;

procedure TcxGdiBasedCanvas.DrawBitmap(ABitmap: TBitmap;
  const ATargetRect, ASourceRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  if ImageStretchQuality = isqHigh then
    inherited
  else
    if AAlphaFormat <> afIgnored then
      cxAlphaBlend(Handle, ABitmap, ATargetRect, ASourceRect)
    else
      cxStretchBlt(Handle, ABitmap.Canvas.Handle, ATargetRect, ASourceRect, SRCCOPY);
end;

procedure TcxGdiBasedCanvas.DrawBitmap(ABitmap: TdxFastDIB;
  const ATargetRect, ASourceRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  if ImageStretchQuality = isqHigh then
    inherited
  else
    if AAlphaFormat <> afIgnored then
      cxAlphaBlend(Handle, ABitmap.DC, ATargetRect, ASourceRect)
    else
      cxStretchBlt(Handle, ABitmap.DC, ATargetRect, ASourceRect, SRCCOPY);
end;

procedure TcxGdiBasedCanvas.DrawBitmap(ABitmap: TdxFastDIB;
  const ATargetRect, ASourceRect: TdxRectF; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil);
begin
  DrawBitmap(ABitmap, ATargetRect.DeflateToTRect, ASourceRect.DeflateToTRect, AAlphaFormat, ACache);
end;

procedure TcxGdiBasedCanvas.DrawBitmap(ABitmap: TdxGpFastDIB;
  const ATargetRect, ASourceRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil);
begin
  dxGPPaintCanvas.BeginPaint(Handle, ATargetRect);
  try
    dxGPPaintCanvas.InterpolationMode := dxGpSmoothStretchModeMap[ImageStretchQuality = isqHigh];
    dxGPPaintCanvas.CompositionMode := CompositionModeMap[AAlphaFormat];
    dxGPPaintCanvas.PixelOffsetMode := PixelOffsetModeHalf;
    dxGpDrawImage(dxGPPaintCanvas.Handle, ATargetRect, ASourceRect, ABitmap.Handle);
  finally
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.DrawBitmap(ABitmap: TdxGpFastDIB;
  const ATargetRect, ASourceRect: TdxRectF; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil);
begin
  dxGPPaintCanvas.BeginPaint(Handle, ATargetRect);
  try
    dxGPPaintCanvas.InterpolationMode := dxGpSmoothStretchModeMap[ImageStretchQuality = isqHigh];
    dxGPPaintCanvas.CompositionMode := CompositionModeMap[AAlphaFormat];
    dxGPPaintCanvas.PixelOffsetMode := PixelOffsetModeHalf;
    dxGpDrawImage(dxGPPaintCanvas.Handle, ATargetRect, ASourceRect, ABitmap.Handle);
  finally
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; ACache: PcxCanvasBasedImage = nil);
begin
  AImage.StretchDraw(Handle, ATargetRect);
end;

procedure TcxGdiBasedCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TdxRectF; ACache: PcxCanvasBasedImage = nil);
begin
  AImage.StretchDraw(Handle, ATargetRect);
end;

function TcxGdiBasedCanvas.RectVisible(const R: TRect): Boolean;
begin
  Result := Windows.RectVisible(Handle, R);
end;

procedure TcxGdiBasedCanvas.FillPixel(X, Y: Integer; AColor: TColor);
begin
  SetPixel(Handle, X, Y, ColorToRGB(AColor));
end;

procedure TcxGdiBasedCanvas.FillPolygon(const P: array of TPoint; AColor: TColor);
begin
  Polygon(P, AColor, AColor);
end;

procedure TcxGdiBasedCanvas.FillRect(const R: TRect; AColor: TColor);
begin
  Windows.FillRect(Handle, R, TdxSolidBrushCache.Get(AColor));
end;

procedure TcxGdiBasedCanvas.FillRect(const R: TRect; AColor: TdxAlphaColor);
begin
  if dxAlphaColorIsValid(AColor) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, R);
    dxGPPaintCanvas.FillRectangle(R, AColor);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.FillRect(const R: TRect; AImage: TdxGPImage; ACache: PcxCanvasBasedImage = nil);
begin
  dxGpTilePart(Handle, R, AImage.ClientRect, AImage.Handle);
end;

procedure TcxGdiBasedCanvas.FillRectByGradient(const R: TRect; AColor1, AColor2: TColor; AHorizontal: Boolean);
begin
  FillGradientRect(Handle, R, AColor1, AColor2, AHorizontal);
end;

procedure TcxGdiBasedCanvas.FocusRectangle(const R: TRect);
var
  AOldMode: Integer;
begin
  AOldMode := SetMapMode(Handle, MM_TEXT);
  Windows.DrawFocusRect(Handle, R);
  SetMapMode(Handle, AOldMode);
end;

procedure TcxGdiBasedCanvas.ModifyWorldTransform(const AForm: TXForm);
begin
  SetGraphicsMode(Handle, GM_ADVANCED);
  Windows.ModifyWorldTransform(Handle, AForm, MWT_LEFTMULTIPLY);
end;

procedure TcxGdiBasedCanvas.Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPath: TdxGPPath;
  AGpPen: TdxGPPen;
begin
  if CheckIsValid(APath) and GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
  begin
    AGpPath := TcxGdiCanvasBasedPath(APath).Path;
    dxGPPaintCanvas.BeginPaint(Handle, AGpPath.GetBounds(AGpPen));
    dxGPPaintCanvas.Path(AGpPath, AGpPen, AGpBrush);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.Pie(const R: TdxRectF;
  AStartAngle, ASweepAngle: Single; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, R);
    dxGPPaintCanvas.Pie(R, AStartAngle, ASweepAngle, AGpBrush, AGpPen);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.Polygon(const P: PdxPointF; ACount: Integer; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, cxNullRect);
    dxGPPaintCanvas.Polygon(P, ACount, AGpPen, AGpBrush);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor);
begin
  dxGPPaintCanvas.BeginPaint(Handle, cxPointsBox(P));
  dxGPPaintCanvas.Polygon(P, APenColor, ABrushColor, 1, psSolid);
  dxGPPaintCanvas.EndPaint;
end;

procedure TcxGdiBasedCanvas.Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(nil, APen, AGpBrush, AGpPen) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, cxNullRect);
    dxGPPaintCanvas.Polyline(P, ACount, AGpPen);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.Polyline(const P: array of TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  dxGPPaintCanvas.BeginPaint(Handle, cxPointsBox(P));
  dxGPPaintCanvas.Polyline(P, AColor, APenWidth, APenStyle);
  dxGPPaintCanvas.EndPaint;
end;

procedure TcxGdiBasedCanvas.Rectangle(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer);
begin
  if dxAlphaColorIsValid(ABrushColor) or (APenWidth > 0) and dxAlphaColorIsValid(APenColor) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, R);
    dxGPPaintCanvas.Rectangle(R, APenColor, ABrushColor, APenWidth, APenStyle);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
  AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  if dxAlphaColorIsValid(AColor) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, AEllipse);
    dxGPPaintCanvas.Arc(AEllipse, AStartPoint, AEndPoint, AColor, APenWidth, APenStyle);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.Ellipse(const R: TRect;
  ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer);
begin
  dxGPPaintCanvas.BeginPaint(Handle, R);
  dxGPPaintCanvas.Ellipse(R, APenColor, ABrushColor, APenWidth, APenStyle);
  dxGPPaintCanvas.EndPaint;
end;

procedure TcxGdiBasedCanvas.DonutSlice(const R: TdxRectF;
  AStartAngle, ASweepAngle, AWholePercent: Single;
  ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, R);
    dxGPPaintCanvas.DonutSlice(R, AStartAngle, ASweepAngle, AWholePercent, AGpBrush, AGpPen);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.Ellipse(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, R);
    dxGPPaintCanvas.Ellipse(R, AGpPen, AGpBrush);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.ExcludeClipRect(const R: TRect);
begin
  Windows.ExcludeClipRect(Handle, R.Left, R.Top, R.Right, R.Bottom);
end;

procedure TcxGdiBasedCanvas.IntersectClipRect(const R: TRect);
begin
  Windows.IntersectClipRect(Handle, R.Left, R.Top, R.Right, R.Bottom);
end;

procedure TcxGdiBasedCanvas.Line(const P1, P2: TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  dxGPPaintCanvas.BeginPaint(Handle, cxPointsBox([P1, P2]));
  dxGPPaintCanvas.Line(P1.X, P1.Y, P2.X, P2.Y, AColor, APenWidth, APenStyle);
  dxGPPaintCanvas.EndPaint;
end;

procedure TcxGdiBasedCanvas.Line(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(nil, APen, AGpBrush, AGpPen) then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, cxPointsBox([P1, P2]));
    dxGPPaintCanvas.Line(P1.X, P1.Y, P2.X, P2.Y, AGpPen);
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxGdiBasedCanvas.SaveWorldTransform;
var
  ATransform: TXForm;
begin
  if FSavedWorldTransforms = nil then
    FSavedWorldTransforms := TStack<TXForm>.Create;
  GetWorldTransform(Handle, ATransform);
  FSavedWorldTransforms.Push(ATransform);
end;

procedure TcxGdiBasedCanvas.RestoreWorldTransform;
begin
  SetWorldTransform(Handle, FSavedWorldTransforms.Pop);
end;

procedure TcxGdiBasedCanvas.RestoreBaseOrigin;
begin
  SetBrushOrgEx(Handle, FBrushOrigin.X, FBrushOrigin.Y, nil);
  FBrushOrigin := cxNullPoint;
  FBaseOrigin := cxNullPoint;
end;

procedure TcxGdiBasedCanvas.SaveBaseOrigin;
begin
  GetWindowOrgEx(Handle, FBaseOrigin);
  SetBrushOrgEx(Handle, BaseOrigin.X, BaseOrigin.Y, @FBrushOrigin);
end;

procedure TcxGdiBasedCanvas.FillRectByGradientCore(const R: TRect;
  AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode);
begin
  dxGPPaintCanvas.BeginPaint(Handle, R);
  dxGPPaintCanvas.FillRectangleByGradient(R, AColor1, AColor2, AMode);
  dxGPPaintCanvas.EndPaint;
end;

procedure TcxGdiBasedCanvas.DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte);
begin
  TcxGdiCanvasBasedImage(AImage).Image.StretchDraw(Handle, ATargetRect, ASourceRect, AAlpha);
end;

procedure TcxGdiBasedCanvas.DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte);
begin
  TcxGdiCanvasBasedImage(AImage).Image.StretchDraw(Handle, ATargetRect, ASourceRect, AAlpha);
end;

procedure TcxGdiBasedCanvas.RectangleCore(const R: TdxRectF;
  ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle);
var
  AHasBrush: Boolean;
  AHasPen: Boolean;
begin
  AHasBrush := (ABrushHandle <> nil) and not ABrushHandle.IsEmpty;
  AHasPen := (APenHandle <> nil) and not APenHandle.IsEmpty;
  if AHasBrush or AHasPen then
  begin
    dxGPPaintCanvas.BeginPaint(Handle, R);
    if AHasBrush then
      dxGPPaintCanvas.FillRectangle(R, TcxGdiCanvasBasedBrushHandle(ABrushHandle).Brush);
    if AHasPen then
      dxGPPaintCanvas.DrawRectangle(R, TcxGdiCanvasBasedPenHandle(APenHandle).Pen);
    dxGPPaintCanvas.EndPaint;
  end;
end;

function TcxGdiBasedCanvas.GetIsLowColorsMode: Boolean;
begin
  Result :=
    (GetDeviceCaps(Handle, BITSPIXEL) <= 16) or
    (GetDeviceCaps(Handle, NUMCOLORS) > 1) or
    (GetDeviceCaps(Handle, TECHNOLOGY) = DT_RASPRINTER);
end;

function TcxGdiBasedCanvas.GetViewportOrg: TPoint;
begin
  GetViewportOrgEx(Handle, Result);
end;

procedure TcxGdiBasedCanvas.SetViewportOrg(const P: TPoint);
begin
  SetViewportOrgEx(Handle, P.X, P.Y, nil);
end;

function TcxGdiBasedCanvas.GetWindowOrg: TPoint;
begin
  GetWindowOrgEx(Handle, Result);
  Result := cxPointOffset(Result, FBaseOrigin, False);
end;

procedure TcxGdiBasedCanvas.SetWindowOrg(const P: TPoint);
begin
  SetWindowOrgEx(Handle, P.X + FBaseOrigin.X, P.Y + FBaseOrigin.Y, nil);
end;

function TcxGdiBasedCanvas.GetDCOrigin: TPoint;
var
  AWindowOrg, AViewportOrg: TPoint;
begin
  GetWindowOrgEx(Handle, AWindowOrg);
  GetViewportOrgEx(Handle, AViewportOrg);
  Result := Point(AViewportOrg.X - AWindowOrg.X, AViewportOrg.Y - AWindowOrg.Y);
end;

{ TcxGdiCanvasBasedTextLayout }

constructor TcxGdiCanvasBasedTextLayout.Create(ACanvas: TcxCustomCanvas);
begin
  inherited Create(ACanvas);
  SetColor(clWindowText);
end;

destructor TcxGdiCanvasBasedTextLayout.Destroy;
begin
  cxResetTextRows(FTextRows);
  inherited Destroy;
end;

procedure TcxGdiCanvasBasedTextLayout.SetColor(AColor: TdxAlphaColor);
begin
  FColor := dxAlphaColorToRGBQuad(AColor);
end;

procedure TcxGdiCanvasBasedTextLayout.DoCalculate(AMaxWidth, AMaxHeight, AMaxRowCount: Integer);
var
  AMeasureDC: HDC;
  ARect: TRect;
  ARowCount: Integer;
  ATextParams: TcxTextParams;
begin
  TdxTextMeasurer.MeasureCanvas.Font.Assign(NativeFont);
  TdxTextMeasurer.MeasureCanvas.SelectFont;
  AMeasureDC := TdxTextMeasurer.MeasureCanvas.Handle;

  if FTransform <> nil then
  begin
    SetGraphicsMode(AMeasureDC, GM_ADVANCED);
    SetWorldTransform(AMeasureDC, FTransform.Matrix);
  end;

  if (AMaxWidth = 0) and (AMaxRowCount > 0) and (FFlags and CXTO_WORDBREAK = CXTO_WORDBREAK) then
    ARect := TdxTextMeasurer.TextRectTO(AMeasureDC, FText, AMaxRowCount, FFlags)
  else
    ARect := cxRect(0, 0, IfThen(AMaxWidth > 0, AMaxWidth, MaxWord), AMaxHeight);

  ATextParams := cxCalcTextParams(AMeasureDC, FFlags or CXTO_CALCROWCOUNT);
  ATextParams.CharBreak := FFlags and CXTO_CHARBREAK <> 0;
  while True do
  begin
    FTextTruncated := not cxMakeTextRows(AMeasureDC, PChar(FText), Length(FText), ARect,
      ATextParams, FTextRows, ARowCount, IfThen(AMaxRowCount > 0, AMaxRowCount + 1), Self, @InternalCalcTextExtends);

    FRowCount := ARowCount;
    if AMaxRowCount > 0 then
      FRowCount := Min(FRowCount, AMaxRowCount);
    if AMaxHeight > 0 then
      FRowCount := Min(FRowCount, CalculateRowCount(AMaxHeight, ATextParams.FullRowHeight));

    FTextSize.cx := cxGetLongestTextRowWidth(FTextRows, FRowCount);
    FTextSize.cy := FRowCount * ATextParams.FullRowHeight;
    if cxRectWidth(ARect) < FTextSize.cx then
      ARect.Right := ARect.Left + FTextSize.cx
    else
      Break;
  end;

  if FFlags and CXTO_END_ELLIPSIS = CXTO_END_ELLIPSIS then
  begin
    FTextTruncated := FTextTruncated or (FRowCount < ARowCount) or (AMaxWidth > 0) and (FTextSize.cx > AMaxWidth);
    if AMaxWidth > 0 then
      FTextSize.cx := Min(FTextSize.cx, AMaxWidth);
    if AMaxHeight > 0 then
      FTextSize.cy := Min(FTextSize.cy, AMaxHeight);
  end;

  if FTransform <> nil then
    SetWorldTransform(AMeasureDC, cxIdentityMatrix);
end;

function TcxGdiCanvasBasedTextLayout.DoCalculateTextExtends(
  DC: HDC; AText: PChar; ATextLength: Integer; AExpandTabs: Boolean): TSize;
begin
  Result := cxCalcTextExtents(DC, AText, ATextLength, AExpandTabs);
end;

procedure TcxGdiCanvasBasedTextLayout.DoDraw(const R: TRect);
begin
  DoDrawCore(TcxGdiBasedCanvas(Canvas).Handle, R);
end;

procedure TcxGdiCanvasBasedTextLayout.DoDrawCore(DC: HDC; const R: TRect);
var
  APrevFont: HFONT;
  APrevFontColor: TColor;
  ATextParams: TcxTextParams;
begin
  APrevFont := SelectObject(DC, NativeFont.Handle);
  try
    ATextParams := cxCalcTextParams(DC, FFlags);
    cxPlaceTextRows(DC, R, ATextParams, FTextRows, FRowCount);

    if FPaintOnGlass or (FColor.rgbReserved < MaxByte) then
      cxTextRowsOutAlphaBlend(DC, R, ATextParams, FTextRows, FRowCount, FTextTruncated, FColor)
    else
    begin
      APrevFontColor := GetTextColor(DC);
      SetTextColor(DC, RGB(FColor.rgbRed, FColor.rgbGreen, FColor.rgbBlue));
      cxTextRowsOutHighlight(DC, R, ATextParams, FTextRows, FRowCount, 0, 0, clNone, clNone, FTextTruncated);
      SetTextColor(DC, APrevFontColor);
    end;
  finally
    SelectObject(DC, APrevFont);
  end;
end;

procedure TcxGdiCanvasBasedTextLayout.DoSetFont(AFontHandle: TcxCanvasBasedFontHandle);
begin
  if not (AFontHandle is TcxGdiCanvasBasedFontHandle) then
    raise EInvalidArgument.Create(sdxInternalErrorResourceOwnerMismatch);
  inherited;
end;

function TcxGdiCanvasBasedTextLayout.GetNativeFont: TFont;
begin
  if FFontHandle = nil then
    raise EInvalidArgument.Create(sdxInternalErrorFontNotSet);
  Result := TcxGdiCanvasBasedFontHandle(FFontHandle).Font;
end;

class function TcxGdiCanvasBasedTextLayout.InternalCalcTextExtends(DC: HDC; AText: PChar;
  ATextLength: Integer; AExpandTabs: Boolean; AData: TcxGdiCanvasBasedTextLayout): TSize;
begin
  Result := AData.DoCalculateTextExtends(DC, AText, ATextLength, AExpandTabs);
end;

{ TcxGdiCanvasBasedBrushHandle }

constructor TcxGdiCanvasBasedBrushHandle.Create(ABrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership);
begin
  inherited Create;
  cxSetGpResource(FBrush, FBrushOwnership, ABrush, AOwnership);
end;

function TcxGdiCanvasBasedBrushHandle.IsEmpty: Boolean;
begin
  Result := (FBrush = nil) or FBrush.IsEmpty;
end;

procedure TcxGdiCanvasBasedBrushHandle.CreateNativeHandle(ACanvas: TcxCustomCanvas);
begin
  FBrush := TcxGdiCanvasBasedSharedBrushes.CreateBrush(Self);
  FBrushOwnership := ooOwned;
end;

procedure TcxGdiCanvasBasedBrushHandle.FreeNativeHandle;
begin
  if FBrushOwnership = ooOwned then
    FreeAndNil(FBrush);
  FBrush := nil;
end;

{ TcxGdiCanvasBasedFontHandle }

constructor TcxGdiCanvasBasedFontHandle.Create(const AFont: TFont; AOwnership: TdxObjectOwnership);
begin
  if AOwnership = ooCloned then
  begin
    FFont := TFont.Create;
    FFont.Assign(AFont);
    FFontOwnership := ooOwned;
  end
  else
  begin
    FFont := AFont;
    FFontOwnership := AOwnership;
  end;
  Initialize(AFont);
end;

procedure TcxGdiCanvasBasedFontHandle.CreateNativeHandle(ACanvas: TcxCustomCanvas);
begin
  if Font = nil then
  begin
    FFont := TFont.Create;
    FFont.Style := Style;
    FFont.Name := FName;
    FFont.Height := FHeight;
    FFont.Pitch := TFontPitch(FPitch);
  {$IFDEF DELPHIBERLIN}
    FFont.Quality := TFontQuality(FQuality);
  {$ENDIF}
    FFontOwnership := ooOwned;
  end;
end;

procedure TcxGdiCanvasBasedFontHandle.FreeNativeHandle;
begin
  if FFontOwnership = ooOwned then
    FFont.Free;
  FFont := nil;
end;

{ TcxGdiCanvasBasedImage }

constructor TcxGdiCanvasBasedImage.Create(ACanvas: TcxCustomCanvas; AImage: TdxGPImage; AOwnership: TdxObjectOwnership);
begin
  inherited Create(ACanvas, AImage.Width, AImage.Height);

  if AOwnership = ooCloned then
  begin
    FImage := AImage.Clone;
    FImageOwnership := ooOwned;
  end
  else
  begin
    FImage := AImage;
    FImageOwnership := AOwnership;
  end;
end;

destructor TcxGdiCanvasBasedImage.Destroy;
begin
  if FImageOwnership = ooOwned then
    FreeAndNil(FImage);
  inherited;
end;

{ TcxGdiCanvasBasedPath }

constructor TcxGdiCanvasBasedPath.Create(ACanvas: TcxCustomCanvas);
begin
  inherited Create(ACanvas);
  FPath := TdxGPPath.Create;
end;

destructor TcxGdiCanvasBasedPath.Destroy;
begin
  FreeAndNil(FPath);
  inherited;
end;

procedure TcxGdiCanvasBasedPath.AddArc(const AEllipse: TdxRectF; const AStartAngle, ASweepAngle: Single);
begin
  FPath.AddArc(AEllipse.Left, AEllipse.Top, AEllipse.Width, AEllipse.Height, -AStartAngle, -ASweepAngle);
end;

procedure TcxGdiCanvasBasedPath.AddLine(const P1, P2: TdxPointF);
begin
  FPath.AddLine(P1, P2);
end;

procedure TcxGdiCanvasBasedPath.AddPolyline(Points: PdxPointF; Count: Integer);
begin
  FPath.AddPolyline(Points, Count)
end;

procedure TcxGdiCanvasBasedPath.FigureClose;
begin
  FPath.FigureFinish;
end;

procedure TcxGdiCanvasBasedPath.FigureStart;
begin
  FPath.FigureStart;
end;

{ TcxGdiCanvasBasedPenHandle }

constructor TcxGdiCanvasBasedPenHandle.Create(APen: TdxGPPen; AOwnership: TdxObjectOwnership);
begin
  inherited Create;
  FWidth := APen.Width;
  cxSetGpResource(FPen, FPenOwnership, APen, AOwnership);
end;

function TcxGdiCanvasBasedPenHandle.IsEmpty: Boolean;
begin
  Result := (FPen = nil) or FPen.IsEmpty;
end;

procedure TcxGdiCanvasBasedPenHandle.CreateNativeHandle(ACanvas: TcxCustomCanvas);
const
  StyleMap: array[TdxStrokeStyle] of TdxGPPenStyle = (
    gppsSolid, gppsDash, gppsDot, gppsDashDot, gppsDashDotDot
  );
begin
  FPen := TdxGpPen.Create;
  FPen.Style := StyleMap[FStyle];
  FPen.Width := FWidth;
  FPen.Brush.Color := FColor;
  FPen.Brush.Style := gpbsSolid;
  FPenOwnership := ooOwned;
end;

procedure TcxGdiCanvasBasedPenHandle.FreeNativeHandle;
begin
  if FPenOwnership = ooOwned then
    FreeAndNil(FPen);
  FPen := nil;
end;

{ TcxCanvasBasedTextLayoutSimpleTransform }

constructor TcxCanvasBasedTextLayoutSimpleTransform.Create(AAngle: TcxRotationAngle);
begin
  inherited Create(cxRotationAngleToAngle[AAngle]);
  FIsVertical := AAngle in [raPlus90, raMinus90];
end;

procedure TcxCanvasBasedTextLayoutSimpleTransform.CalculateConstraints(var AMaxWidth, AMaxHeight: Integer);
begin
  if FIsVertical then
    ExchangeIntegers(AMaxWidth, AMaxHeight);
end;

procedure TcxCanvasBasedTextLayoutSimpleTransform.CalculateSize(var ASize: TSize);
begin
  if FIsVertical then
    ExchangeIntegers(ASize.cx, ASize.cy);
end;

{ TcxCanvasBasedTextLayoutComplexTransform }

procedure TcxCanvasBasedTextLayoutComplexTransform.CalculateConstraints(var AMaxWidth, AMaxHeight: Integer);
var
  AHeight: Single;
  APoint1: TdxPointF;
  APoint2: TdxPointF;
  APoint3: TdxPointF;
  APoint4: TdxPointF;
  AWidth: Single;
begin
  if (AMaxWidth <> 0) or (AMaxHeight <> 0) then
  begin
    AWidth := IfThen(AMaxWidth <> 0, AMaxWidth, MaxWord);
    AHeight := IfThen(AMaxHeight <> 0, AMaxHeight, MaxWord);
    dxCalculateOptimalInscribedRect(cxRectF(0, 0, AWidth, AHeight), Angle, AWidth, AHeight, APoint1, APoint2, APoint3, APoint4);
    AMaxHeight := Round(AHeight);
    AMaxWidth := Round(AWidth);
    if AMaxHeight >= MaxWord - 1 then
      AMaxHeight := 0;
    if AMaxWidth >= MaxWord - 1 then
      AMaxWidth := 0;
  end;
end;

procedure TcxCanvasBasedTextLayoutComplexTransform.CalculateSize(var ASize: TSize);
var
  ATextBox: TdxRectF;
begin
  ATextBox := cxRotatedRectBox(cxRectF(0, 0, ASize.cx, ASize.cy), dxNullPointF, Angle);
  ASize := cxSize(Ceil(ATextBox.Width), Ceil(ATextBox.Height));
end;

{ TcxGdiCanvasBasedSharedBrushes }

class function TcxGdiCanvasBasedSharedBrushes.Instance: TcxGdiCanvasBasedSharedBrushes;
begin
  if FInstance = nil then
    FInstance := TcxGdiCanvasBasedSharedBrushes.Create(nil, TcxGdiCanvasBasedBrushHandle);
  Result := FInstance;
end;

class function TcxGdiCanvasBasedSharedBrushes.CreateBrush(AOptions: TcxCanvasBasedBrushHandle): TdxGPCustomBrush;
begin
  case AOptions.FMode of
    TdxFillOptionsMode.Solid:
      Result := TdxGPSolidBrush.Create(AOptions.FColor1);
    TdxFillOptionsMode.Texture:
      Result := TdxGpTextureBrush.Create(AOptions.FTexture);
    TdxFillOptionsMode.Hatch:
      Result := TdxGPHatchBrush.Create(AOptions.FColor1, AOptions.FColor2, AOptions.FHatchStyle);
    TdxFillOptionsMode.Gradient:
      begin
        Result := TdxGPBrush.Create;
        TdxGPBrush(Result).GradientMode := AOptions.FGradientMode;
        TdxGPBrush(Result).GradientPoints.Add(0, AOptions.FColor1);
        TdxGPBrush(Result).GradientPoints.Add(1, AOptions.FColor2);
        TdxGPBrush(Result).Style := gpbsGradient;
      end;
  else
    Result := TdxGPSolidBrush.Create(TdxAlphaColors.Empty);
  end;
end;

class procedure TcxGdiCanvasBasedSharedBrushes.Finalize;
begin
  FreeAndNil(FInstance);
end;

{ TcxGdiCanvasBasedSharedFonts }

class function TcxGdiCanvasBasedSharedFonts.Instance: TcxGdiCanvasBasedSharedFonts;
begin
  if FInstance = nil then
    FInstance := TcxGdiCanvasBasedSharedFonts.Create(nil, TcxGdiCanvasBasedFontHandle);
  Result := FInstance;
end;

class procedure TcxGdiCanvasBasedSharedFonts.Finalize;
begin
  FreeAndNil(FInstance);
end;

{ TcxGdiCanvasBasedSharedImageLists }

class function TcxGdiCanvasBasedSharedImageLists.Instance: TcxGdiCanvasBasedSharedImageLists;
begin
  if FInstance = nil then
    FInstance := TcxGdiCanvasBasedSharedImageLists.Create(nil, TcxCanvasBasedImageListHandle);
  Result := FInstance;
end;

class procedure TcxGdiCanvasBasedSharedImageLists.Finalize;
begin
  FreeAndNil(FInstance);
end;

{ TcxGdiCanvasBasedSharedPens }

class function TcxGdiCanvasBasedSharedPens.Instance: TcxGdiCanvasBasedSharedPens;
begin
  if FInstance = nil then
    FInstance := TcxGdiCanvasBasedSharedPens.Create(nil, TcxGdiCanvasBasedPenHandle);
  Result := FInstance;
end;

class procedure TcxGdiCanvasBasedSharedPens.Finalize;
begin
  FreeAndNil(FInstance);
end;

{ TcxCanvasBasedImageCache }

constructor TcxCanvasBasedImageCache.Create;
begin
  inherited Create([doOwnsValues], TcxCanvasBasedImageCacheKeyComparer.Create);
end;

{ TcxCanvasBasedImageCacheKeyComparer }

function TcxCanvasBasedImageCacheKeyComparer.Equals(const Left, Right: TcxCanvasBasedImageCacheKey): Boolean;
begin
  Result := CompareMem(@Left, @Right, SizeOf(Left));
end;

function TcxCanvasBasedImageCacheKeyComparer.GetHashCode(const Value: TcxCanvasBasedImageCacheKey): Integer;
begin
  Result := dxBobJenkinsHash(Value, SizeOf(Value), 0);
end;

{ unit initialization routines }

procedure RegisterAssistants;
begin
  // do nothing
end;

procedure UnregisterAssistants;
begin
  TcxGdiCanvasBasedSharedImageLists.Finalize;
  TcxGdiCanvasBasedSharedBrushes.Finalize;
  TcxGdiCanvasBasedSharedFonts.Finalize;
  TcxGdiCanvasBasedSharedPens.Finalize;
end;

initialization

  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, RegisterAssistants, UnregisterAssistants);

finalization

  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, UnregisterAssistants);

end.
