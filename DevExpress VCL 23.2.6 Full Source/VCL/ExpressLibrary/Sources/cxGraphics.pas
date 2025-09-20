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

unit cxGraphics;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, Classes, SysUtils, Controls, Graphics, Menus, CommCtrl, ComCtrls, ImgList, ActiveX,
  Generics.Defaults, Generics.Collections,
  dxCore, dxCoreClasses, dxCoreGraphics, dxMessages, cxClasses, cxGeometry, dxGDIPlusClasses, dxGDIPlusApi,
  dxSmartImage, cxImageList, cxCustomCanvas, dxGenerics, dxDPIAwareUtils, dxTypeHelpers;

const
  cxAlignLeft            = 1;
  cxAlignRight           = 2;
  cxAlignHCenter         = 4;
  cxAlignTop             = 8;
  cxAlignBottom          = 16;
  cxAlignVCenter         = 32;
  cxAlignCenter          = 36;
  cxSingleLine           = 64;
  cxDontClip             = 128;
  cxExpandTabs           = 256;
  cxShowPrefix           = 512;
  cxWordBreak            = 1024;
  cxShowEndEllipsis      = 2048;
  cxCalcRect             = 4096;
  cxShowPathEllipsis     = 8192;
  cxDontBreakChars       = 16384;
  cxNoFullWidthCharBreak = 32768;
  cxRtlReading           = 65536;
  cxShowWordEllipsis     = 131072;
  cxDontPrint            = cxCalcRect;

  SystemAlignmentsHorz: array[TAlignment] of Integer = (DT_LEFT, DT_RIGHT, DT_CENTER);
  SystemAlignmentsVert: array[TcxAlignmentVert] of Integer = (DT_TOP, DT_BOTTOM, DT_VCENTER);
  cxAlignmentsHorz: array[TAlignment] of Integer = (cxAlignLeft, cxAlignRight, cxAlignHCenter);
  cxAlignmentsVert: array[TcxAlignmentVert] of Integer = (cxAlignTop, cxAlignBottom, cxAlignVCenter);

  clcxLightGray = $CFCFCF;

  cxEmptyRect: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

  cxDesignSelectionWidth = 2;
  cxTransparencyCheckerboardSizeDefault = 8;
  cxTransparencyCheckerboardSizeSmall = 2;

  cxDefaultAlphaValue = 200;

  cxHalfToneBrush: TBrush = nil;

  cxDoubleBufferedBitmapPixelFormat: TPixelFormat = pfDevice;

  cxMaxRegionSize = 30000;

type
  TcxBorder = cxGeometry.TcxBorder;
  TcxBorders = cxGeometry.TcxBorders;
  TcxModifyStringType = dxCoreGraphics.TcxModifyStringType; // for internal use
  TcxImageDrawMode = cxCustomCanvas.TcxImageDrawMode;

const
  cxBordersAll = cxGeometry.cxBordersAll;
  {$EXTERNALSYM cxBordersAll}

  idmNormal = cxCustomCanvas.idmNormal;
  {$EXTERNALSYM idmNormal}
  idmDisabled = cxCustomCanvas.idmDisabled;
  {$EXTERNALSYM idmDisabled}
  idmFaded = cxCustomCanvas.idmFaded;
  {$EXTERNALSYM idmFaded}
  idmGrayScale = cxCustomCanvas.idmGrayScale;
  {$EXTERNALSYM idmGrayScale}
  idmDingy = cxCustomCanvas.idmDingy;
  {$EXTERNALSYM idmDingy}
  idmShadowed = cxCustomCanvas.idmShadowed;
  {$EXTERNALSYM idmShadowed}

  bBottom = cxGeometry.bBottom;
  {$EXTERNALSYM bBottom}
  bLeft = cxGeometry.bLeft;
  {$EXTERNALSYM bLeft}
  bRight = cxGeometry.bRight;
  {$EXTERNALSYM bRight}
  bTop = cxGeometry.bTop;
  {$EXTERNALSYM bTop}
  mstEndEllipsis = dxCoreGraphics.mstEndEllipsis;
  {$EXTERNALSYM mstEndEllipsis}
  mstPathEllipsis = dxCoreGraphics.mstPathEllipsis;
  {$EXTERNALSYM mstPathEllipsis}

  ra0 = cxCustomCanvas.ra0;
  {$EXTERNALSYM ra0}
  raPlus90 = cxCustomCanvas.raPlus90;
  {$EXTERNALSYM raPlus90}
  raMinus90 = cxCustomCanvas.raMinus90;
  {$EXTERNALSYM raMinus90}
  ra180 = cxCustomCanvas.ra180;
  {$EXTERNALSYM ra180}

type
  TcxRotationAngle = cxCustomCanvas.TcxRotationAngle;

  IcxFontListener = interface
    ['{B144DD7E-0B27-439A-B908-FC3ACFE6A2D3}']
    procedure Changed(Sender: TObject; AFont: TFont);
  end;

  IdxMultiPartGlyphSupport = interface
  ['{9F33E339-DEDD-422A-9908-5B44FDADEBD9}']
    function GetStateCaption(AIndex: Integer): string;
    function GetGlyphCount: Integer;
    procedure SetGlyphCount(AValue: Integer);

    property GlyphCount: Integer read GetGlyphCount write SetGlyphCount;
  end;

  TcxArrowDirection = (adUp, adDown, adLeft, adRight);
  TcxArrowDirections = set of TcxArrowDirection;
  TcxArrowPoints = array[0..2] of TPoint;

type
  TBrushHandle = HBRUSH;

  TcxColorPart = -100..100;

  TcxGridLines = (glBoth, glNone, glVertical, glHorizontal);

  PcxViewParams = ^TcxViewParams;
  TcxViewParams = record
    Bitmap: TBitmap;
    Color: TColor;
    Font: TFont;
    TextColor: TColor;
  end;

  { IcxPaintControlsHelper }

  IcxPaintControlsHelper = interface
  ['{7EFAF634-E8D2-489D-9603-FCFC03ACA460}']
    function AllowDrawEdgesAndBorders: Boolean;
  end;

  { IcxImageCollectionListener }

  IcxImageCollectionListener = interface
  ['{FDFF372B-F49E-40C9-9E03-E0D6B110774A}']
    procedure ImageCollectionChanged;
    procedure ImageCollectionDestroyed;
  end;

  { TdxHSV }

  TdxHSV = record
    H: Double;
    S: Double;
    V: Double;
  end;

  { TdxHSL }

  TdxHSL = record
    H: Double;
    S: Double;
    L: Double;
  end;

  TcxImageIndex = System.UITypes.TImageIndex;

  { TcxRegion }

  TcxRegionHandle = HRGN;
  TcxRegionOperation = (roSet, roAdd, roSubtract, roIntersect);

  TcxRegion = class  {6}
  private
    FHandle: TcxRegionHandle;
    function GetBoundsRect: TRect;
    function GetIsEmpty: Boolean;
  protected
    procedure DestroyHandle;
  public
    constructor Create(AHandle: TcxRegionHandle); overload;
    constructor Create(const ABounds: TRect); overload;
    constructor Create; overload;
    constructor Create(ALeft, ATop, ARight, ABottom: Integer); overload;
    constructor CreateFromWindow(AHandle: HWND; ADummy: Integer = 0); overload;
    constructor CreateRoundCorners(ALeft, ATop, ARight, ABottom, AWidthEllipse, AHeightEllipse: Integer); overload;
    constructor CreateRoundCorners(const ABounds: TRect; AWidthEllipse, AHeightEllipse: Integer); overload;
    destructor Destroy; override;

    function Clone: TcxRegion;
    procedure Combine(ARegion: TcxRegion; AOperation: TcxRegionOperation; ADestroyRegion: Boolean = True); overload;
    procedure Combine(ARegionHandle: TcxRegionHandle; AOperation: TcxRegionOperation); overload;
    procedure Combine(const R: TRect; AOperation: TcxRegionOperation); overload;
    function IsEqual(ARegion: TcxRegion): Boolean; overload;
    function IsEqual(ARegionHandle: TcxRegionHandle): Boolean; overload;
    procedure Offset(const P: TPoint); overload;
    procedure Offset(DX, DY: Integer); overload;
    function PtInRegion(const Pt: TPoint): Boolean; overload;
    function PtInRegion(X, Y: Integer): Boolean; overload;
    function RectInRegion(const R: TRect): Boolean; overload;
    function RectInRegion(ALeft, ATop, ARight, ABottom: Integer): Boolean; overload;

    property BoundsRect: TRect read GetBoundsRect;
    property Handle: TcxRegionHandle read FHandle write FHandle;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  { TcxCanvas }

  TcxCanvas = class(TcxGdiBasedCanvas)
  strict private type
  {$REGION 'Internal Types'}
    TcxCanvasState = record
      Font: TFont;
      Brush: TBrush;
      Pen: TPen;
      UseRightToLeftAlignment: TdxDefaultBoolean;
      TextFlags: LongInt;
    end;
    TcxCanvasStates = array of TcxCanvasState;

    TcxDCState = record
      Handle: THandle;
      State: Integer;
    end;
    TcxDCStates = array of TcxDCState;
  {$ENDREGION}
  private
    FSavedDCs: TcxDCStates;
    FSavedRegions: TList;
    FSavedStates: TcxCanvasStates;

    function GetBrush: TBrush;
    function GetCopyMode: TCopyMode;
    function GetFont: TFont;
    function GetDpiX: Integer;
    function GetDpiY: Integer;
    function GetPen: TPen;
    function GetTextFlags: LongInt;
    procedure SetBrush(Value: TBrush);
    procedure SetCopyMode(Value: TCopyMode);
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetPixel(X, Y: Integer; Value: TColor);
    procedure SetTextFlags(Value: LongInt);
  protected
    FCanvas: TCanvas;

    function GetDefaultUseRightToLeftAlignment: Boolean; override;
    function GetHandle: HDC; override;
    procedure InitializePen(AColor: TColor; AStyle: TPenStyle; AWidth: Integer);
    procedure SetCanvas(Value: TCanvas); virtual;
    procedure SynchronizeObjects(ACanvas: TCanvas; ADC: THandle); overload;
    procedure SynchronizeObjects(ADC: THandle); overload;
  public
    constructor Create(ACanvas: TCanvas); virtual;
    destructor Destroy; override;

    procedure AngleArc(X, Y: Integer; ARadius: Cardinal; AStartAngle, ASweepAngle: Single);
    procedure Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); reintroduce; overload;
    procedure Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
      AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); overload; override;
    procedure ArcTo(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
    procedure Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
    procedure Ellipse(X1, Y1, X2, Y2: Integer); overload;
    procedure Ellipse(const Rect: TRect); overload;
    procedure Ellipse(const Rect: TRect; ABrushColor, APenColor: TColor; APenStyle: TPenStyle; APenWidth: Integer); overload; override;
    procedure FloodFill(X, Y: Integer; Color: TColor; FillStyle: TFillStyle);
    procedure Line(const P1, P2: TPoint); reintroduce; overload;
    procedure Line(X1, Y1, X2, Y2: Integer); reintroduce; overload;
    procedure LineTo(X, Y: Integer);
    procedure MoveTo(X, Y: Integer);
    procedure PolyBezier(const Points: array of TPoint);
    procedure PolyBezierTo(const Points: array of TPoint);
    procedure Polygon(const Points: array of TPoint); reintroduce; overload;
    procedure Polygon(const Points: array of TPoint; ABrushColor, APenColor: TColor); overload; override;
    procedure Polyline(const Points: array of TPoint); reintroduce; overload;
    procedure Polyline(const Points: array of TPoint; AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); overload; override;
    procedure Rectangle(const R: TRect); overload;
    procedure Rectangle(X1, Y1, X2, Y2: Integer); overload;
    procedure Rectangle(R: TRect; const AParams: TcxViewParams; const ABorders: TcxBorders = cxBordersAll;
      ABorderColor: TColor = clDefault; ALineWidth: Integer = 1; AExcludeRect: Boolean = False); overload;
    procedure Rectangle(const R: TRect; ABrushColor: TColor; APenColor: TColor; APenStyle: TPenStyle; APenWidth: Integer = 1); override;
    procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);  overload;
    procedure RoundRect(const R: TRect; CX, CY: Integer); overload;
    procedure FillRect(const R: TRect; ABitmap: TBitmap = nil; AExcludeRect: Boolean = False); overload;
    procedure FillRect(const R: TRect; AColor: TColor); override;
    procedure FillRect(const R: TRect; const AParams: TcxViewParams; AExcludeRect: Boolean = False); overload;
    procedure FillRegion(ARegion: TcxRegion; AColor: TColor = clDefault); overload;
    procedure FillRegion(ARegion: TcxRegionHandle; AColor: TColor = clDefault); overload;
    procedure FrameRect(const R: TRect); overload;
    procedure FrameRect(const R: TRect; AColor: TColor; ALineWidth: Integer = 1; ABorders: TcxBorders = cxBordersAll); overload; override;
    procedure FrameRect(const R: TRect; AColor: TColor; ALineWidth: Integer; const ABorders: TcxBorders; AExcludeFrame: Boolean); overload;
    procedure FrameRegion(ARegion: TcxRegion; AColor: TColor = clDefault;
      ABorderWidth: Integer = 1; ABorderHeight: Integer = 1); overload;
    procedure FrameRegion(ARegion: TcxRegionHandle; AColor: TColor = clDefault;
      ABorderWidth: Integer = 1; ABorderHeight: Integer = 1); overload;
    procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); reintroduce; overload;
    procedure Pie(const R: TRect; const ARadial1, ARadial2: TPoint); reintroduce; overload;
    procedure Pie(const R: TRect; AStartAngle, ASweepAngle: Integer); reintroduce; overload;

    procedure BrushCopy(const Dest: TRect; Bitmap: TBitmap; const Source: TRect; Color: TColor);
    procedure CopyRect(const Dest: TRect; ACanvas: TCanvas; const Source: TRect);
    procedure Draw(X, Y: Integer; Graphic: TGraphic); overload;
    procedure Draw(X, Y: Integer; Graphic: TGraphic; Opacity: Byte); overload;
    procedure DrawDesignSelection(ARect: TRect; AWidth: Integer = cxDesignSelectionWidth);
    procedure DrawFocusRect(const R: TRect);
    procedure DrawFocusRectEx(const R: TRect; ABorders: TcxBorders; AExclude: Boolean = False);
    procedure DrawGlyph(X, Y: Integer; AGlyph: TBitmap; AEnabled: Boolean = True; ABackgroundColor: TColor = clNone);
    procedure DrawImage(Images: TCustomImageList; X, Y, Index: Integer; Enabled: Boolean = True);
    procedure DrawRegion(ARegion: TcxRegion; AContentColor: TColor = clDefault;
      ABorderColor: TColor = clDefault; ABorderWidth: Integer = 1; ABorderHeight: Integer = 1); overload;
    procedure DrawRegion(ARegion: TcxRegionHandle; AContentColor: TColor = clDefault;
      ABorderColor: TColor = clDefault; ABorderWidth: Integer = 1; ABorderHeight: Integer = 1); overload;
    procedure DrawTexT(const Text: string; R: TRect; Flags: Integer; Enabled: Boolean = True); overload;
    procedure DrawTexT(const Text: string; R: TRect; Flags: Integer; Enabled: Boolean; ARotationAngle: TcxRotationAngle); overload;
    procedure DrawTexT(const Text: string; R: TRect; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean); overload;
    procedure FlipHorizontally(ABitmap: TBitmap);
    procedure InvertFrame(const R: TRect; ABorderSize: Integer);
    procedure InvertRect(const R: TRect);
    procedure RotateBitmap(ABitmap: TBitmap; ARotationAngle: TcxRotationAngle; AFlipVertically: Boolean = False);
    procedure StretchDraw(const Rect: TRect; Graphic: TGraphic);
    procedure TextOut(X, Y: Integer; const Text: string);
    procedure TransparentDraw(X, Y: Integer; ABitmap: TBitmap; AAlpha: Byte; ABackground: TBitmap = nil);

    function HandleAllocated: Boolean;
    procedure Lock;
    procedure Refresh;
    procedure Unlock;

    procedure AlignMultiLineTextRectVertically(var R: TRect; const AText: string;
      AAlignmentVert: TcxAlignmentVert; AWordBreak, AShowPrefix: Boolean;
      AEnabled: Boolean = True; ADontBreakChars: Boolean = False; AEndEllipsis: Boolean = False; AExpandTabs: Boolean = False);
    procedure GetTextStringsBounds(Text: string; R: TRect; Flags: Integer;
      Enabled: Boolean; var ABounds: TRects);
    function FontHeight(AFont: TFont): Integer;
    function TextExtent(const Text: string): TSize; overload;
    procedure TextExtent(const Text: string; var R: TRect; Flags: Integer); overload;
    function TextHeight(const Text: string): Integer;
    function TextWidth(const Text: string): Integer;

    procedure RestoreDC;
    procedure SaveDC;
    procedure RestoreClipRegion; override;
    procedure SaveClipRegion; override;
    procedure RestoreState; override;
    procedure SaveState; override;

    procedure GetParams(var AParams: TcxViewParams);
    procedure SetParams(const AParams: TcxViewParams);
    procedure SetBrushColor(Value: TColor);
    procedure SetFontAngle(Value: Integer);

    procedure BeginPath;
    procedure EndPath;
    function PathToRegion(AConsiderOrigin: Boolean = True): TcxRegion;
    procedure WidenPath;

    procedure ExcludeFrameRect(const R: TRect; ALineWidth: Integer = 1; ABorders: TcxBorders = cxBordersAll);
    function GetClipRegion(AConsiderOrigin: Boolean = True): TcxRegion;
    procedure SetClipRegion(ARegion: TcxRegion; AOperation: TcxRegionOperation;
      ADestroyRegion: Boolean = True; AConsiderOrigin: Boolean = True);
    function RectFullyVisible(const R: TRect): Boolean;
    procedure OffsetClipRegion(AOffsetX, AOffsetY: Integer); // for internal use

    property Brush: TBrush read GetBrush write SetBrush;
    property Canvas: TCanvas read FCanvas write SetCanvas;
    property CopyMode: TCopyMode read GetCopyMode write SetCopyMode;
    property DpiX: Integer read GetDpiX;
    property DpiY: Integer read GetDpiY;
    property Font: TFont read GetFont write SetFont;
    property Pen: TPen read GetPen write SetPen;
    property Pixels[X, Y: Integer]: TColor write SetPixel;
    property TextFlags: LongInt read GetTextFlags write SetTextFlags;
  end;

  { TcxMeasureCanvas }

  TcxMeasureCanvas = class(TcxCanvas)
  strict private
    FBitmap: TBitmap;
  public
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
  end;

  { TcxScreenCanvas }

  TcxScreenCanvas = class(TcxCanvas)
  public
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
    procedure Dormant;
  end;

  { TcxPaintCanvas }

  TcxPaintCanvasState = record
    PrevCanvas: TCanvas;
    FSaveDC: Integer;
  end;
  TcxPaintCanvasStates = array of TcxPaintCanvasState;

  TcxPaintCanvas = class(TcxCanvas)
  private
    FCounter: Integer;
    FSavedStates: TcxPaintCanvasStates;

    procedure SetCapacity(AValue: Integer);
  protected
    procedure SetCanvas(Value: TCanvas); override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure BeginPaint(ADC: THandle); overload;
    procedure BeginPaint(ACanvas: TCanvas); overload;
    procedure EndPaint;
  end;

  { TcxBitmap }

  TcxBitmap = class(TBitmap)
  private
    FCompressData: Boolean;
    FcxCanvas: TcxCanvas;
    FLockCount: Integer;
    FModified: Boolean;

    function GetCanvas: TcxCanvas;
    function GetClientRect: TRect;
    function GetIsDormant: Boolean;

    procedure CompressByBlock(ASourceStream, ADestStream: TStream; ASize, ABlockSize: Integer);
    procedure DecompressByBlock(ASourceStream, ADestStream: TStream; ASize, ABlockSize: Integer);

    procedure Compress(ASourceStream, ADestStream: TStream; ASize: Integer);
    procedure Decompress1(ASourceStream, ADestStream: TStream; ASize: Integer);
    procedure Decompress2(ASourceStream, ADestStream: TStream; ASize: Integer);
  protected
    procedure Changed(Sender: TObject); override;
    function ChangeLocked: Boolean;
    procedure Initialize(AWidth, AHeight: Integer; APixelFormat: TPixelFormat); virtual;
    procedure Update; virtual;

    procedure ReadData(Stream: TStream); override;
    procedure WriteData(Stream: TStream); override;

    property IsDormant: Boolean read GetIsDormant;
  public
    constructor Create; overload; override;
    constructor CreateSize(AWidth, AHeight: Integer); overload; virtual;
    constructor CreateSize(AWidth, AHeight: Integer; APixelFormat: TPixelFormat); overload;
    constructor CreateSize(const ASize: TSize); overload;
    constructor CreateSize(const ARect: TRect); overload;
    constructor CreateSize(const ARect: TRect; APixelFormat: TPixelFormat); overload;
    destructor Destroy; override;

    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure EndUpdate(AForceUpdate: Boolean = True);

    procedure CopyBitmap(ASrcBitmap: TBitmap; ACopyMode: DWORD = SRCCOPY); overload;
    procedure CopyBitmap(ASrcBitmap: TBitmap; const ADestRect: TRect; const ASrcTopLeft: TPoint; ACopyMode: DWORD = SRCCOPY); overload;
    procedure Dormant;
    procedure Flip(AFlipHorizontally, AFlipVertically: Boolean);
    procedure Rotate(ARotationAngle: TcxRotationAngle; AFlipVertically: Boolean = False);
    procedure SetSize(AWidth, AHeight: Integer); overload; override;
    procedure SetSize(const ARect: TRect); reintroduce; overload;

    property CompressData: Boolean read FCompressData write FCompressData;
    property ClientRect: TRect read GetClientRect;
    property cxCanvas: TcxCanvas read GetCanvas;
  end;

  { TcxBitmap }

  TcxImageFitMode = (ifmNormal, ifmStretch, ifmProportionalStretch, ifmFit, ifmFill);
  TcxBitmapTransformationMode = (btmDingy, btmDirty, btmGrayScale, btmSetOpaque, btmMakeMask, btmFade,
    btmDisable, btmCorrectBlend, btmHatch, btmClear, btmResetAlpha, btmExtractLayer);
  TcxBitmapTransformationProc = procedure(var AColor: TRGBQuad) of object;
  TcxDrawImageProc = function (ACanvas: TCanvas; AImages: TCustomImageList; AImageIndex: Integer;
    AGlyph: TGraphic; ARect: TRect; ADrawMode: TcxImageDrawMode): Boolean;

  TcxColorTransitionMap = record
    RedScale: Single;
    GreenScale: Single;
    BlueScale: Single;
    SrcAlpha: Byte;
    SrcConstantAlpha: Byte;
  end;

  TcxHatchData = record
    Color1: TRGBQuad;
    Alpha1: Byte;
    Color2: TRGBQuad;
    Alpha2: Byte;
    Step: Byte;
  end;

  { TcxBitmap32 }

  TcxBitmap32 = class(TcxBitmap)
  strict private
    FIsAlphaUsed: TdxDefaultBoolean;

    function GetIsAlphaUsed: Boolean;
  protected
    procedure Update; override;

    procedure Resize(ANewWidth, ANewHeight: Integer; AStretch, ASmooth: Boolean; AFillColor: TColor = clNone);
  public
    constructor CreateSize(AWidth, AHeight: Integer); overload; override;
    constructor CreateSize(AWidth, AHeight: Integer; AClear: Boolean); overload;
    constructor CreateSize(const ARect: TRect; AClear: Boolean); overload;
    constructor CreateSize(const ASize: TSize; AClear: Boolean); overload;
    procedure AfterConstruction; override;

    procedure GetBitmapColors(out AColors: TRGBColors);
    procedure SetBitmapColors(const AColors: TRGBColors);

    procedure AlphaBlend(ADestBitmap: TcxBitmap32; const ADestRect: TRect; ASmoothImage: Boolean; AConstantAlpha: Byte = $FF);
    procedure Clear; virtual;
    procedure Darken(APercent: Byte);
    procedure Filter(AMaskBitmap: TcxBitmap32);
    procedure Invert;
    procedure Lighten(APercent: Byte);
    procedure LoadFromStream(Stream: TStream); override;
    procedure MakeOpaque;
    procedure RecoverTransparency(ATransparentColor: TColor);
    procedure SetAlphaChannel(Alpha: Byte);

    property IsAlphaUsed: Boolean read GetIsAlphaUsed;
  end;

  { TcxColorList }

  TcxColorList = class(TList)
  public
    function Add(AColor: TColor): Integer;
  end;

  { TcxAlphaBitmap }

  TcxAlphaBitmap = class(TcxBitmap32)
  private
    FTransparentBkColor: TRGBQuad;
    FTransparentPixels: TcxColorList;

    FCurrentColorIndex: TPoint;
    FHatchData: TcxHatchData;

    procedure CorrectBlend(var AColor: TRGBQuad);
    procedure ClearColor(var AColor: TRGBQuad);
    procedure Dingy(var AColor: TRGBQuad);
    procedure Dirty(var AColor: TRGBQuad);
    procedure Disable(var AColor: TRGBQuad);
    procedure ExtractLayerProc(var AColor: TRGBQuad);
    procedure Fade(var AColor: TRGBQuad);
    procedure GrayScale(var AColor: TRGBQuad);
    procedure Hatch(var AColor: TRGBQuad);
    procedure MakeMask(var AColor: TRGBQuad);
    procedure SetOpaque(var AColor: TRGBQuad);
    procedure ResetAlpha(var AColor: TRGBQuad);

    function IsColorTransparent(const AColor: TRGBQuad): Boolean;
  protected
    procedure Initialize(AWidth, AHeight: Integer; APixelFormat: TPixelFormat); override;

    procedure ScaleColor(var AColor: TRGBQuad; const AColorMap: TcxColorTransitionMap);

    property HatchData: TcxHatchData read FHatchData write FHatchData;
    property TransparentBkColor: TRGBQuad read FTransparentBkColor write FTransparentBkColor;
    property TransparentPixels: TcxColorList read FTransparentPixels;
  public
    constructor CreateSize(AWidth, AHeight: Integer); overload; override;
    constructor CreateSize(AWidth, AHeight: Integer; ATransparentBkColor: TRGBQuad); overload;
    destructor Destroy; override;

    procedure Clear; override;
    procedure DrawHatch(const AHatchData: TcxHatchData); overload;
    procedure DrawHatch(AColor1, AColor2: TColor; AStep: Byte; AAlpha1: Byte = $FF; AAlpha2: Byte = $FF); overload;
    procedure DrawShadow(AMaskBitmap: TcxAlphaBitmap; AShadowSize: Integer; AShadowColor: TColor; AInflateSize: Boolean = False);
    procedure ExtractLayer(ATransparentColor: TColor);
    procedure RecoverAlphaChannel(ATransparentColor: TColor); overload;
    procedure RecoverAlphaChannel(ARect: TRect; ATransparentColor: TColor); overload;
    procedure Shade(AMaskBitmap: TcxAlphaBitmap);
    procedure TransformBitmap(AMode: TcxBitmapTransformationMode);

    procedure RefreshImage(AWidth, AHeight: Integer); overload;
    procedure RefreshImage(const ARect: TRect); overload;
  end;

  { TcxImageList }

  TcxImageList = class(TcxCustomImageList);

  { TcxImageCollectionItem }

  TcxImageCollection = class;

  TcxImageCollectionItem = class(TcxComponentCollectionItem)
  private
    FPicture: TPicture;
    FTag: TcxTag;
    function GetClientRect: TRect;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetPicture(AValue: TPicture);
  protected
    function GetDisplayName: string; override;
    function GetCollectionFromParent(AParent: TComponent): TcxComponentCollection; override;
    procedure DoPictureChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(ACanvas: TCanvas; X, Y: Integer); overload;
    procedure Draw(ACanvas: TCanvas; const R: TRect; AStretch: Boolean = True;
      ASmoothResize: Boolean = False; AEnabled: Boolean = True); overload;
    //
    property ClientRect: TRect read GetClientRect;
    property Height: Integer read GetHeight;
    property Width: Integer read GetWidth;
  published
    property Picture: TPicture read FPicture write SetPicture;
    property Tag: TcxTag read FTag write FTag default 0;
  end;

  { TcxImageCollectionItems }

  TcxImageCollectionItems = class(TcxComponentCollection)
  private
    FCollection: TcxImageCollection;
    function GetItem(Index: Integer): TcxImageCollectionItem;
    procedure SetItem(Index: Integer; AValue: TcxImageCollectionItem);
  protected
    procedure SetItemName(AItem: TcxComponentCollectionItem; ABaseIndex: Integer = -1); override;
    procedure Update(AItem: TcxComponentCollectionItem;
      AAction: TcxComponentCollectionNotification); override;
  public
    constructor Create(ACollection: TcxImageCollection); reintroduce;
    function Add: TcxImageCollectionItem;
    function FindItemByName(const AName: string; out AItem: TcxImageCollectionItem): Boolean;
    function FindItemByID(ID: Integer): TcxImageCollectionItem;
    function Insert(Index: Integer): TcxImageCollectionItem;
    //
    property Items[Index: Integer]: TcxImageCollectionItem read GetItem write SetItem; default;
  end;

  { TcxImageCollection }

  TcxImageCollection = class(TcxCustomComponent)
  private
    FItems: TcxImageCollectionItems;
    FListeners: TInterfaceList;
    function GetCount: Integer;
    function GetFrame(AFrameIndex: Integer; const ASize: TSize; AMode: TcxImageFitMode; var AFrame: TdxSmartImage): Boolean;
    procedure SetItems(AItems: TcxImageCollectionItems);
  protected
    // override
    procedure Changed;
    procedure DoDestroyed;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AddFromMultiFrameImage(ASource: TdxSmartImage);
    function GetAsMultiFrameTIFF: TdxSmartImage; overload;
    function GetAsMultiFrameTIFF(const ASize: TSize; AMode: TcxImageFitMode): TdxSmartImage; overload;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure Draw(ACanvas: TCanvas; X, Y, AIndex: Integer); overload;
    procedure Draw(ACanvas: TCanvas; const R: TRect; AIndex: Integer;
      AStretch: Boolean = True; ASmoothResize: Boolean = False;
      AEnabled: Boolean = True); overload;
    //
    procedure AddListener(AListener: IcxImageCollectionListener);
    procedure RemoveListener(AListener: IcxImageCollectionListener);
    //
    property Count: Integer read GetCount;
  published
    property Items: TcxImageCollectionItems read FItems write SetItems;
  end;

  { TcxSystemImageList }

  TcxSystemImageList = class(TImageList, IdxSourceDPI)
  strict private
    FSourceDPI: Integer;
  protected
    // IdxSourceDPI
    function GetSourceDPI: Integer;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  { TdxSolidBrushCacheManager }

  TdxSolidBrushCacheManager = class(TdxValueCacheManager<TColor, TBrushHandle>)
  protected
    procedure DoRemove(const Value: TBrushHandle); override;
  end;

  { TdxSolidBrushCache }

  TdxSolidBrushCache = class
  strict private const
    Capacity = 128;
  strict private
    class var FData: TdxSolidBrushCacheManager;
    class var FSystemPaletteChangedNotifier: TObject;
  protected
    class procedure Initialize;
    class procedure Finalize;
  public
    class procedure Clear;
    class function Get(const AColor: TColor): TBrushHandle;
  end;

  { TdxColorUtils }

  TdxColorUtils = class
  public const
    DefaultTextContrast = 4.5;
  public
    // HSL
    class function AlphaColorToHSL(AColor: TdxAlphaColor): TdxHSL; overload;
    class function AlphaColorToHSL(AColor: TdxAlphaColor; out AAlpha: Byte): TdxHSL; overload;
    class function ColorToHSL(AColor: TColor): TdxHSL;
    class function HSLToAlphaColor(const AHSL: TdxHSL; AAlpha: Byte = MaxByte): TdxAlphaColor; overload;
    class function HSLToColor(const AHSL: TdxHSL): TColor; overload; inline;
    class function HSLToColor(const H, S, L: Double): TColor; overload;
    class function HSLToRGB(const AHSL: TdxHSL): TRGBQuad; overload;
    class function HSLToRGB(const H, S, L: Double): TRGBQuad; overload;
    class procedure HSLToRGB(const H, S, L: Double; out R, G, B: Byte); overload;
    class function RGBToHSL(const ARGB: TRGBQuad): TdxHSL;

    // HSV
    class function ColorToHSV(AColor: TColor): TdxHSV;
    class function HSVToColor(const AHSV: TdxHSV): TColor; overload;
    class function HSVToColor(const H, S, V: Double): TColor; overload;
    class function RGBToHSV(const ARGB: TRGBQuad): TdxHSV;

    // General
    class function ChangeLightness(AColor: TColor; const ALightnessDelta: Double): TColor;
    class function ChangeSaturation(AColor: TColor; const ASaturationDelta: Double): TColor;
    class function Colorize(ABaseColor, AColor: TColor): TColor;
    class function ComponentToXYZ(const AComponent: Byte): Double;
    class function Contrast(const AForegroundColor, ABackgroundColor: TColor): Double;
    class function InvertLightness(AColor: TdxAlphaColor): TdxAlphaColor; overload;
    class function InvertLightness(AColor: TColor): TColor; overload;
    class function Luminance(const AColor: TColor): Double; overload;
    class function Luminance(const R, G, B: Byte): Double; overload;
    class function MakeForegroundColor(ABackgroundColor: TColor): TColor;
    class function MultiplyLightness(AColor: TColor; const AFactor: Double): TColor;
  end;

  { TdxColorPaletteBuilder }

  TdxColorPaletteBuilder = class
  public const
    DefaultLightnessDelta = 0.15;
    MaxBaseLightness = 0.8;
    MaxLightness = 0.9;
    MinBaseLightness = 0.4;
    MinLightness = 0.2;
    MinSaturation = 0.4;
  strict private
    FBaseColor: TdxHSL;

    procedure EnsureCapacity(AList: TdxAlphaColorList; ACount: Integer); overload;
    procedure EnsureCapacity(AList: TdxColorList; ACount: Integer); overload;
  public
    constructor Create(const ABaseColor: TColor); overload;
    constructor Create(const ABaseColor: TdxAlphaColor); overload;
    constructor Create(const ABaseColor: TRGBQuad); overload;
    procedure Build(ATargetList: TdxAlphaColorList; ABasePalette: array of TdxAlphaColor); overload;
    procedure Build(ATargetList: TdxAlphaColorList; ABasePalette: array of TdxAlphaColor; ALightnessDelta: Single); overload;
    procedure Build(ATargetList: TdxColorList; ABasePalette: array of TColor); overload;
    procedure Build(ATargetList: TdxColorList; ABasePalette: array of TColor; ALightnessDelta: Single); overload;
    function Build(AColor: TdxAlphaColor; ALightnessDelta: Single = 0): TdxAlphaColor; overload;
  end;

  { TdxAdjustFontSizeCustomHelper }

  TdxAdjustFontSizeCustomHelper = class
  strict private const
    LineSpacingScaleFactor = 100;
  protected type
    TCheckParamFunc = function (ALastSuitableValue, AOriginalValue, AMinValue: Integer): Integer of object;
    TMeasureTextFunc = function (const AText: string; AParam: Integer): Integer of object;
  strict private
    FAllowAdjustLineSpacing: Boolean;
    FFont: TFont;
    FLineSpacing: Single;
    FWidth: Integer;

    procedure SetFont(AValue: TFont);
  protected
    FFlags: Cardinal;

    procedure AfterCalculate; virtual;
    procedure BeforeCalculate; virtual;
    function CalculateCore(AAvailableSize, AParam, AParamLow: Integer; const AText: string;
      AMeasureFunc: TMeasureTextFunc; ACheckParamFunc: TCheckParamFunc): Integer;
    function CompareTextSize(ATextSize, AAvailableSize: Integer): Integer; virtual;

    function CheckFontSize(ALastSuitableSize, AOriginalSize, AMinSize: Integer): Integer; virtual;
    function CalculateCoreHeight(AAvailableWidth, AParam, AParamLow: Integer; const AText: string;
      AMeasureFunc: TMeasureTextFunc; ACheckParamFunc: TCheckParamFunc): Integer; // for internal use
    function CheckFontHeight(ALastSuitableHeight, AOriginalHeight, AMinHeight: Integer): Integer; virtual; // for internal use

    function DoMeasureTextHeight1(const AText: string; ALineSpacing: Integer): Integer;
    function DoMeasureTextHeight2(const AText: string; AFontSize: Integer): Integer;
    function DoMeasureTextWidth(const AText: string; AFontSize: Integer): Integer;
    {$IFDEF DELPHIXE8}
    function DoMeasureTextWidthUsingFontHeight(const AText: string; AFontHeight: Integer): Integer; // for internal use;
    {$ENDIF}
    function GetMinFontSize: Integer; virtual; abstract;
    {$IFDEF DELPHIXE8}
    function GetMinFontHeight: Integer; // for internal use
    {$ENDIF}
    function GetMinLineSpacing: Single; virtual;
    function GetTextHeight(const AText: string; AWidth: Integer; ALineSpacing: Single): Integer; virtual; abstract;
    function GetTextWidth(const AText: string): Integer; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Calculate(const AAvailableWidth: Integer; const AText: string); overload;
    {$IFDEF DELPHIXE8}
    procedure CalculateHeight(const AAvailableWidth: Integer; const AText: string); overload; // for internal use
    {$ENDIF}
    procedure Calculate(const AAvailableSize: TSize; const AText: string;
      AMultiline: Boolean; AFlags: Cardinal; AMaxFontSize: Integer = -1); overload;

    property AllowAdjustLineSpacing: Boolean read FAllowAdjustLineSpacing write FAllowAdjustLineSpacing;
    property Font: TFont read FFont write SetFont;
    property LineSpacing: Single read FLineSpacing;
  end;

  { TdxAdjustFontSizeHelper }

  TdxAdjustFontSizeHelper = class(TdxAdjustFontSizeCustomHelper)
  strict private
    FZoomFactor: Integer;
    FPrevXForm: TXForm;
  protected
    procedure AfterCalculate; override;
    procedure BeforeCalculate; override;
    function GetMinFontSize: Integer; override;
    function GetTextHeight(const AText: string; AWidth: Integer; ALineSpacing: Single): Integer; override;
    function GetTextWidth(const AText: string): Integer; override;
  public
    constructor Create;
    //
    property ZoomFactor: Integer read FZoomFactor write FZoomFactor;
  end;

  { TdxImageAnimationController }

  TdxImageAnimationController = class(TdxSmartImageAnimationController)
  strict private
    FTimer: TcxTimer;
  protected
    procedure ActivateTimer; override;
    procedure DeactivateTimer; override;
    function IsTimerActive: Boolean; override;

    property Timer: TcxTimer read FTimer;
  public
    destructor Destroy; override;
  end;

  { TdxDrawImageCacheID }

  TdxDrawImageCacheID = packed record
    BrushHandle: HBRUSH;
    DrawMode: TcxImageDrawMode;
    Glyph: TGraphic;
    ImageIndex: Integer;
    ImageList: TCustomImageList;
    PaletteID: TGUID;
    SmoothImage: Boolean;
    TransparentColor: TColor;
    UseLeftBottomPixelAsTransparent: Boolean;

    constructor Create(AGlyph: TGraphic; AImageList: TCustomImageList; AImageIndex: Integer;
      ADrawMode: TcxImageDrawMode; AUseLeftBottomPixelAsTransparent, ASmoothImage: Boolean;
      ATransparentColor: TColor; const APalette: IdxColorPalette; ABrushHandle: HBRUSH = 0);
    function GetHashCode: Integer;
    function IsEqual(const ID: TdxDrawImageCacheID): Boolean;
    procedure Reset;
  end;

  { TdxImageListPaintCache }

  TdxImageListPaintCache = class
{$REGION 'internal types'}
  protected type

    { TImageIdComparer }

    TImageIdComparer = class(TEqualityComparer<TdxDrawImageCacheID>)
    public
      function Equals(const Left, Right: TdxDrawImageCacheID): Boolean; override;
      function GetHashCode(const Value: TdxDrawImageCacheID): Integer; override;
    end;

    { TImageListCacheHelper }

    TImageListCacheHelper = class(TComponent)
    strict private type

      TImages = class(TObjectDictionary<TdxDrawImageCacheID, TdxGPImage>)
      public
        constructor Create(ACapacity: Integer);
      end;

      TSizeImages = class(TObjectDictionary<TSize, TImages>);

    strict private
      FImageList: TCustomImageList;
      FImagesChangeLink: TChangeLink;
      FLastImages: TImages;
      FLastSize: TSize;
      FMaxSizeCount: Integer;
      FSizedImages: TSizeImages;
      FSizes: TQueue<TSize>;
    protected
      function GetImage(const ABounds: TRect; AIndex: Integer; ADrawMode: TcxImageDrawMode;
        AUseLeftBottomPixelAsTransparent: Boolean; const APalette: IdxColorPalette; ASmoothImage: Boolean): TdxGPImage;
      procedure ImageListChanged(Sender: TObject);
      procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    public
      constructor Create(AImages: TCustomImageList; AMaxSizeCount: Integer = 0); reintroduce;
      destructor Destroy; override;
      procedure Draw(ADC: THandle; const ABounds: TRect; AIndex: Integer; ADrawMode: TcxImageDrawMode;
        AUseLeftBottomPixelAsTransparent: Boolean; const APalette: IdxColorPalette; ASmoothImage: Boolean); overload;
      procedure Draw(AGraphic: TdxGPGraphics; const ABounds: TRect; AIndex: Integer; ADrawMode: TcxImageDrawMode;
        AUseLeftBottomPixelAsTransparent: Boolean; const APalette: IdxColorPalette); overload;
      procedure Invalidate;

      property ImageList: TCustomImageList read FImageList;
    end;
{$ENDREGION}
  strict private class var
    FLastImages: TCustomImageList;
    FLastHelper: TImageListCacheHelper;
    FImages: TObjectDictionary<TCustomImageList, TImageListCacheHelper>;
    FTransferBitmap: TcxAlphaBitmap;

    class constructor Initialize;
  {$HINTS OFF}
    class destructor Finalize;
  {$HINTS ON}
  protected
    class procedure SetupHelper(AImages: TCustomImageList); static;
    class procedure RemoveHelper(AHelper: TImageListCacheHelper); static;

    class property TransferBitmap: TcxAlphaBitmap read FTransferBitmap;
  public
    class procedure Draw(ADC: THandle; const ABounds: TRect; AImages: TCustomImageList; AIndex: Integer;
      ADrawMode: TcxImageDrawMode; AUseLeftBottomPixelAsTransparent: Boolean; APalette: IdxColorPalette; ASmoothImage: Boolean); overload; static;
    class procedure Draw(AGraphic: TdxGPGraphics; const ABounds: TRect; AImages: TCustomImageList; AIndex: Integer;
      ADrawMode: TcxImageDrawMode; AUseLeftBottomPixelAsTransparent: Boolean; APalette: IdxColorPalette); overload; static;
    class procedure InvalidateImageList(AImages: TCustomImageList); static;
    class procedure PrepareImage(ATarget: TdxGpImage; const ASize: TSize; const ID: TdxDrawImageCacheID; const AColorPalette: IdxColorPalette);
  end;

  TdxImageDrawer = class
  public
    class procedure DrawBitmap(ADestDC: THandle; ASrcBitmap: TBitmap; const ADestRect: TRect; const ASrcPoint: TPoint; AMode: Integer = SRCCOPY);
    class procedure DrawUncachedImage(ADC: THandle; AGlyphRect, ABackgroundRect: TRect; AGlyph: TGraphic; AImages: TCustomImageList;
      AImageIndex: Integer; ADrawMode: TcxImageDrawMode; ASmoothImage: Boolean = False; ABrush: THandle = 0;
      ATransparentColor: TColor = clNone; AUseLeftBottomPixelAsTransparent: Boolean = True; APalette: IdxColorPalette = nil); overload; static;
    class procedure DrawImage(ACanvas: TCanvas; const ARect: TRect;
      AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer; // image info
      AFitMode: TcxImageFitMode; ADrawMode: TcxImageDrawMode = idmNormal; AUseLeftBottomPixelAsTransparent: Boolean = True;
      APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil; ASmoothImage: Boolean = False); overload; static;
    class procedure DrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect;
      AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer; // image info
      AFitMode: TcxImageFitMode; ADrawMode: TcxImageDrawMode = idmNormal; AUseLeftBottomPixelAsTransparent: Boolean = True;
      APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil; ASmoothImage: Boolean = False); overload; static;
    class procedure DrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect;
      AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer; AEnabled: Boolean;
      APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil); overload; static;
    class procedure DrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect; AImage: TGraphic; AFitMode: TcxImageFitMode;
      APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil; ASmoothResize: Boolean = False); overload; static;
  end;


const
  DisableMap: TcxColorTransitionMap = (RedScale: 0.0729; GreenScale: 0.7146; BlueScale: 0.2125; SrcAlpha: 105; SrcConstantAlpha: 151);
  FadeMap: TcxColorTransitionMap = (RedScale: 0.299; GreenScale: 0.587; BlueScale: 0.114; SrcAlpha: 192; SrcConstantAlpha: 64);
  GrayMap: TcxColorTransitionMap = (RedScale: 0.299; GreenScale: 0.587; BlueScale: 0.114; SrcAlpha: $FF; SrcConstantAlpha: $FF);

  EnabledImageDrawModeMap: array [Boolean] of TcxImageDrawMode = (idmDisabled, idmNormal);

type
  TcxColorInfo = record
    Name: string;
    Color: TColor;
  end;

const
  cxColorsByName: array[0..168] of TcxColorInfo = (
    (Name: 'aliceblue';            Color: $00FFF8F0),
    (Name: 'antiquewhite';         Color: $00D7EBFA),
    (Name: 'aqua';                 Color: clAqua),
    (Name: 'aquamarine';           Color: $007FD4FF),
    (Name: 'azure';                Color: $00FFFFF0),
    (Name: 'beige';                Color: $00DCF5F5),
    (Name: 'bisque';               Color: $00C4E4FF),
    (Name: 'black';                Color: clBlack),
    (Name: 'blanchedalmond';       Color: $00CDFFFF),
    (Name: 'blue';                 Color: clBlue),
    (Name: 'blueviolet';           Color: $00E22B8A),
    (Name: 'brown';                Color: $002A2AA5),
    (Name: 'burlywood';            Color: $0087B8DE),
    (Name: 'cadetblue';            Color: $00A09E5F),
    (Name: 'chartreuse';           Color: $0000FF7F),
    (Name: 'chocolate';            Color: $001E69D2),
    (Name: 'coral';                Color: $00507FFF),
    (Name: 'cornflowerblue';       Color: $00ED9564),
    (Name: 'cornsilk';             Color: $00DCF8FF),
    (Name: 'crimson';              Color: $003C14DC),
    (Name: 'cyan';                 Color: $00FFFF00),
    (Name: 'darkblue';             Color: $008B0000),
    (Name: 'darkcyan';             Color: $008B8B00),
    (Name: 'darkgoldenrod';        Color: $000B86B8),
    (Name: 'darkgray';             Color: $00A9A9A9),
    (Name: 'darkgreen';            Color: $00006400),
    (Name: 'darkkhaki';            Color: $006BB7BD),
    (Name: 'darkmagenta';          Color: $008B008B),
    (Name: 'darkolivegreen';       Color: $002F6B55),
    (Name: 'darkorange';           Color: $00008CFF),
    (Name: 'darkorchid';           Color: $00CC3299),
    (Name: 'darkred';              Color: $0000008B),
    (Name: 'darksalmon';           Color: $007A96E9),
    (Name: 'darkseagreen';         Color: $008FBC8F),
    (Name: 'darkslateblue';        Color: $008B3D48),
    (Name: 'darkslategray';        Color: $004F4F2F),
    (Name: 'darkturquoise';        Color: $00D1CE00),
    (Name: 'darkviolet';           Color: $00D30094),
    (Name: 'deeppink';             Color: $009314FF),
    (Name: 'deepskyblue';          Color: $00FFBF00),
    (Name: 'dimgray';              Color: $00696969),
    (Name: 'dodgerblue';           Color: $00FF901E),
    (Name: 'firebrick';            Color: $002222B2),
    (Name: 'floralwhite';          Color: $00F0FAFF),
    (Name: 'forestgreen';          Color: $00228B22),
    (Name: 'fuchsia';              Color: $00FF00FF),
    (Name: 'gainsboro';            Color: $00DCDCDC),
    (Name: 'ghostwhite';           Color: $00FFF8F8),
    (Name: 'gold';                 Color: $0000D7FF),
    (Name: 'goldenrod';            Color: $0020A5DA),
    (Name: 'gray';                 Color: clGray),
    (Name: 'green';                Color: clGreen),
    (Name: 'greenyellow';          Color: $002FFFAD),
    (Name: 'honeydew';             Color: $00F0FFF0),
    (Name: 'hotpink';              Color: $00B469FF),
    (Name: 'indianred';            Color: $005C5CCD),
    (Name: 'indigo';               Color: $0082004B),
    (Name: 'ivory';                Color: $00F0F0FF),
    (Name: 'khaki';                Color: $008CE6F0),
    (Name: 'lavender';             Color: $00FAE6E6),
    (Name: 'lavenderblush';        Color: $00F5F0FF),
    (Name: 'lawngreen';            Color: $0000FC7C),
    (Name: 'lemonchiffon';         Color: $00CDFAFF),
    (Name: 'lightblue';            Color: $00E6D8AD),
    (Name: 'lightcoral';           Color: $008080F0),
    (Name: 'lightcyan';            Color: $00FFFFE0),
    (Name: 'lightgoldenrodyellow'; Color: $00D2FAFA),
    (Name: 'lightgreen';           Color: $0090EE90),
    (Name: 'lightgrey';            Color: $00D3D3D3),
    (Name: 'lightpink';            Color: $00C1B6FF),
    (Name: 'lightsalmon';          Color: $007AA0FF),
    (Name: 'lightseagreen';        Color: $00AAB220),
    (Name: 'lightskyblue';         Color: $00FACE87),
    (Name: 'lightslategray';       Color: $00998877),
    (Name: 'lightsteelblue';       Color: $00DEC4B0),
    (Name: 'lightyellow';          Color: $00E0FFFF),
    (Name: 'lime';                 Color: clLime),
    (Name: 'limegreen';            Color: $0032CD32),
    (Name: 'linen';                Color: $00E6F0FA),
    (Name: 'magenta';              Color: $00FF00FF),
    (Name: 'maroon';               Color: clMaroon),
    (Name: 'mediumaquamarine';     Color: $00AACD66),
    (Name: 'mediumblue';           Color: $00CD0000),
    (Name: 'mediumorchid';         Color: $00D355BA),
    (Name: 'mediumpurple';         Color: $00DB7093),
    (Name: 'mediumseagreen';       Color: $0071B33C),
    (Name: 'mediumpurple';         Color: $00DB7093),
    (Name: 'mediumslateblue';      Color: $00EE687B),
    (Name: 'mediumspringgreen';    Color: $009AFA00),
    (Name: 'mediumturquoise';      Color: $00CCD148),
    (Name: 'mediumvioletred';      Color: $008515C7),
    (Name: 'midnightblue';         Color: $00701919),
    (Name: 'mintcream';            Color: $00FAFFF5),
    (Name: 'mistyrose';            Color: $00E1E4FF),
    (Name: 'moccasin';             Color: $00B5E4FF),
    (Name: 'navajowhite';          Color: $00ADDEFF),
    (Name: 'navy';                 Color: clNavy),
    (Name: 'oldlace';              Color: $00E6F5FD),
    (Name: 'olive';                Color: $00008080),
    (Name: 'olivedrab';            Color: $00238E6B),
    (Name: 'orange';               Color: $0000A5FF),
    (Name: 'orangered';            Color: $000045FF),
    (Name: 'orchid';               Color: $00D670DA),
    (Name: 'palegoldenrod';        Color: $00AAE8EE),
    (Name: 'palegreen';            Color: $0098FB98),
    (Name: 'paleturquoise';        Color: $00EEEEAF),
    (Name: 'palevioletred';        Color: $009370DB),
    (Name: 'papayawhip';           Color: $00D5EFFF),
    (Name: 'peachpuff';            Color: $00BDDBFF),
    (Name: 'peru';                 Color: $003F85CD),
    (Name: 'pink';                 Color: $00CBC0FF),
    (Name: 'plum';                 Color: $00DDA0DD),
    (Name: 'powderblue';           Color: $00E6E0B0),
    (Name: 'purple';               Color: $00800080),
    (Name: 'red';                  Color: clRed),
    (Name: 'rosybrown';            Color: $008F8FBC),
    (Name: 'royalblue';            Color: $00E16941),
    (Name: 'saddlebrown';          Color: $0013458B),
    (Name: 'salmon';               Color: $007280FA),
    (Name: 'sandybrown';           Color: $0060A4F4),
    (Name: 'seagreen';             Color: $00578B2E),
    (Name: 'seashell';             Color: $00EEF5FF),
    (Name: 'sienna';               Color: $002D52A0),
    (Name: 'silver';               Color: $00C0C0C0),
    (Name: 'skyblue';              Color: $00EBCE87),
    (Name: 'slateblue';            Color: $00CD5A6A),
    (Name: 'slategray';            Color: $00908070),
    (Name: 'snow';                 Color: $00FAFAFF),
    (Name: 'springgreen';          Color: $007FFF00),
    (Name: 'steelblue';            Color: $00B48246),
    (Name: 'tan';                  Color: $008CB4D2),
    (Name: 'teal';                 Color: clTeal),
    (Name: 'thistle';              Color: $00D8BFD8),
    (Name: 'tomato';               Color: $004763FD),
    (Name: 'turquoise';            Color: $00D0E040),
    (Name: 'violet';               Color: $00EE82EE),
    (Name: 'wheat';                Color: $00B3DEF5),
    (Name: 'white';                Color: clWhite),
    (Name: 'whitesmoke';           Color: $00F5F5F5),
    (Name: 'yellow';               Color: clYellow),
    (Name: 'yellowgreen';          Color: $0032CD9A),

    (Name: 'activeborder';         Color: clActiveBorder),
    (Name: 'activecaption';        Color: clActiveCaption),
    (Name: 'appworkspace';         Color: clAppWorkSpace),
    (Name: 'background';           Color: clBackground),
    (Name: 'buttonface';           Color: clBtnFace),
    (Name: 'buttonhighlight';      Color: clBtnHighlight),
    (Name: 'buttonshadow';         Color: clBtnShadow),
    (Name: 'buttontext';           Color: clBtnText),
    (Name: 'captiontext';          Color: clCaptionText),
    (Name: 'graytext';             Color: clGrayText),
    (Name: 'highlight';            Color: clHighlight),
    (Name: 'highlighttext';        Color: clHighlightText),
    (Name: 'inactiveborder';       Color: clInactiveBorder),
    (Name: 'inactivecaption';      Color: clInactiveCaption),
    (Name: 'inactivecaptiontext';  Color: clInactiveCaptionText),
    (Name: 'infobackground';       Color: clInfoBk),
    (Name: 'infotext';             Color: clInfoText),
    (Name: 'menu';                 Color: clMenu),
    (Name: 'menutext';             Color: clMenuText),
    (Name: 'scrollbar';            Color: clScrollBar),
    (Name: 'threeddarkshadow';     Color: cl3DDkShadow),
    (Name: 'threedface';           Color: clBtnFace),
    (Name: 'threedhighlight';      Color: clHighlightText),
    (Name: 'threedlightshadow';    Color: cl3DLight),
    (Name: 'threedshadow';         Color: clBtnShadow),
    (Name: 'window';               Color: clWindow),
    (Name: 'windowframe';          Color: clWindowFrame),
    (Name: 'windowtext';           Color: clWindowText)
  );

const
  dxDefaultFontSizeCount = 16;
  dxDefaultFontSizes: array [0..dxDefaultFontSizeCount - 1] of Integer = (
    8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48, 72
  );

var
  CustomDrawImageProc: TcxDrawImageProc = nil;
  dxUseAntialiasingForRotatedText: Boolean = True;

function cxFlagsToDTFlags(Flags: Integer): Integer;

procedure cxSetImageList(const AValue: TCustomImageList; var AFieldValue: TCustomImageList;
  AChangeLink: TChangeLink; ANotifyComponent: TComponent; ANotificationProc: TdxComponentNotificationProc = nil);
function IsGlyphAssigned(AGlyph: TGraphic): Boolean;
function IsImageAssigned(AGlyph: TGraphic; AImageList: TCustomImageList; AImageIndex: Integer): Boolean; overload;
function IsImageAssigned(AImage: TGraphic): Boolean; overload;
function IsImageAssigned(AImageList: TCustomImageList; AImageIndex: Integer): Boolean; overload;
function IsPictureAssigned(APicture: TPicture): Boolean;
function dxGetImageSize(AImage: TGraphic): TSize; overload;
function dxGetImageSize(AImage: TGraphic; AScaleFactor: TdxScaleFactor): TSize; overload;
function dxGetImageSize(AImage: TGraphic; AImageList: TCustomImageList; AImageIndex: Integer): TSize; overload; 
function dxGetImageSize(AImage: TGraphic; AImageList: TCustomImageList; AImageIndex: Integer; AScaleFactor: TdxScaleFactor): TSize; overload;
function dxGetImageSize(AImageList: TCustomImageList; AScaleFactor: TdxScaleFactor): TSize; overload;
function dxGetImageSize(AImageList: TCustomImageList; APPI: Integer): TSize; overload;
function dxGetImageSize(APicture: TPicture; AScaleFactor: TdxScaleFactor): TSize; overload;
function dxGetImageSize(APicture: TPicture): TSize; overload; 
function dxGetImageSourceDPI(AImage: TObject): Integer;

function IsXPManifestEnabled: Boolean;
function dxGetNearestColor(AColor: TColor): TColor;
function dxInvertColor(AColor: TColor): TColor;
function dxOffsetColor(AColor: TColor; ARed, AGreen, ABlue: Byte): TColor;


function dxColorToHSV(AColor: TColor): TdxHSV;
function dxHSVToColor(const AHSV: TdxHSV): TColor;
function dxGetColorTint(AColor: TColor; ATintPercent: Integer): TColor;

// light colors
function GetLightColor(ABtnFaceColorPart, AHighlightColorPart, AWindowColorPart: TcxColorPart): TColor;
function GetLightBtnFaceColor: TColor;
function GetLightDownedColor: TColor;
function GetLightDownedSelColor: TColor;
function GetLightSelColor: TColor;

function dxGetDarkerColor(AColor: TColor; APercent: Byte): TColor;
function dxGetMiddleRGB(AColor1, AColor2: TColor; APercent: Integer): TColor;
function dxGetLighterColor(AColor: TColor; APercent: Byte): TColor;
function dxGetColorRelativeLuminance(AColor: TColor): Single;

function IsHighContrast: Boolean;
function IsHighContrastBlack: Boolean;
function IsHighContrastWhite: Boolean;
function IsHighContrast2: Boolean;

function cxIntersectClipRect(DC: HDC; const R: TRect): Boolean;
procedure cxExcludeClipRect(DC: HDC; const R: TRect);

procedure FillGradientRect(DC: HDC; const ARect: TRect; AColor1, AColor2: TColor; AHorizontal: Boolean);
procedure FillTubeGradientRect(DC: HDC; const ARect: TRect; AColor1, AColor2: TColor; AGradientPercent: Integer; AHorizontal: Boolean);
procedure FillRectByColor(DC: HDC; const R: TRect; AColor: TColor);
procedure FillRegionByColor(DC: HDC; ARegion: HRGN; AColor: TColor);
procedure FrameRectByColor(DC: HDC; const R: TRect; AColor: TColor);
function GetGradientColorRect(const ARect: TRect; X: Integer; AColor1, AColor2: TColor; AHorizontal: Boolean): TColor;

function cxColorByName(const AText: string; var AColor: TColor): Boolean;
function cxColorIsEqual(const AColor1, AColor2: TRGBQuad): Boolean;
function cxColorIsValid(AColor: TColor): Boolean; inline;
function cxGetActualAlphaColor(const AValue, ADefaultValue: TdxAlphaColor): TdxAlphaColor;
function cxGetActualColor(const AValue, ADefaultValue: TColor): TColor;
function cxNameByColor(AColor: TColor; var AText: string): Boolean;
procedure cxExchangeColors(var AColor1, AColor2: TColor);

function cxGetCurrentDPI: Integer;
function cxGetValueCurrentDPI(AValue: Integer): Integer; overload;
function cxGetValueCurrentDPI(const AValue: TPoint): TPoint; overload;
function cxGetValueCurrentDPI(const AValue: TRect): TRect; overload;
function cxGetValueCurrentDPI(const AValue: TSize): TSize; overload;
function cxGetPixelsPerInch: TSize;

procedure cxAlphaBlend(ADestBitmap, ASrcBitmap: TBitmap; const ADestRect, ASrcRect: TRect; ASmoothImage: Boolean = False; AConstantAlpha: Byte = $FF); overload;
procedure cxAlphaBlend(ADestDC: HDC; ASrcBitmap: TBitmap; const ADestRect, ASrcRect: TRect; ASmoothImage: Boolean = False; AConstantAlpha: Byte = $FF); overload;
procedure cxAlphaBlend(ADestDC, ASrcDC: HDC; const ADestRect, ASrcRect: TRect; ASmoothImage: Boolean = False; AConstantAlpha: Byte = $FF); overload;
procedure cxBitBlt(ADestDC, ASrcDC: HDC; const ADestRect: TRect; const ASrcTopLeft: TPoint; ROP: DWORD);
//procedure cxBitmapToTrueColorBitmap(ABitmap: TBitmap); -> cxMakeTrueColorBitmap
procedure cxBlendFunction(const ASource: TRGBQuad; var ADest: TRGBQuad; ASourceConstantAlpha: Byte);
function cxCreateBitmap(const ASize: TSize; AFormat: TPixelFormat = pf24bit): TBitmap; overload;
function cxCreateBitmap(const ARect: TRect; AFormat: TPixelFormat = pf24bit): TBitmap; overload;
function cxCreateBitmap(AWidth, AHeight: Integer; AFormat: TPixelFormat = pf24bit): TBitmap; overload;
function cxCreateTrueColorBitmap(const ASize: TSize): TBitmap; overload;
function cxCreateTrueColorBitmap(AWidth, AHeight: Integer): TBitmap; overload;
function cxCreateTrueColorBitmapHandle(AWidth, AHeight: Integer; ABPP: Integer = 32): HBitmap;
function cxCreateRegionFromBitmap(ABitmap: TBitmap; ATransparentColor: TColor): HRGN; overload;
function cxCreateRegionFromBitmap(APixels: PRGBQuad; AWidth, AHeight: Integer; ATransparentColor: TColor): HRGN; overload;
procedure cxDrawHatchRect(ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor; ADrawShadow: Boolean = True);
procedure cxDrawDesignRect(ACanvas: TcxCanvas; const ARect: TRect; ASelected: Boolean; ADrawShadow: Boolean = True);
procedure cxDrawBitmap(ADestDC: THandle; ASrcBitmap: TBitmap;
  const ADestRect: TRect; const ASrcPoint: TPoint; AMode: Integer = SRCCOPY); deprecated;
procedure cxDrawImage(ADC: THandle; AGlyphRect, ABackgroundRect: TRect; AGlyph: TGraphic;
  AImages: TCustomImageList; AImageIndex: Integer; ADrawMode: TcxImageDrawMode; ASmoothImage: Boolean = False;
  ABrush: THandle = 0; ATransparentColor: TColor = clNone; AUseLeftBottomPixelAsTransparent: Boolean = True;
  APalette: IdxColorPalette = nil); overload; deprecated 'Use TdxImageDrawer.DrawUncachedImage';
procedure cxDrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect;
  AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer; // image info
  AFitMode: TcxImageFitMode; ADrawMode: TcxImageDrawMode = idmNormal; AUseLeftBottomPixelAsTransparent: Boolean = True;
  APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil; ASmoothImage: Boolean = False); overload; deprecated 'Use TdxImageDrawer.DrawImage';
procedure cxDrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect;
  AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer; AEnabled: Boolean;
  APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil); overload;  deprecated 'Use TdxImageDrawer.DrawImage';
procedure cxDrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect; AImage: TGraphic; AFitMode: TcxImageFitMode;
  APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil; ASmoothResize: Boolean = False); overload;  deprecated 'Use TdxImageDrawer.DrawImage';
procedure cxDrawImageList(AImageListHandle: HIMAGELIST; AImageIndex: Integer;
  ADC: HDC; APoint: TPoint; ADrawingStyle: TDrawingStyle; AImageType: TImageType);
procedure cxDrawPicture(ACanvas: TcxCanvas; const ARect: TRect; APicture: TPicture; AFitMode: TcxImageFitMode; AScaleFactor: TdxScaleFactor = nil);
procedure cxDrawHatch(ADC: HDC; const ARect: TRect; AColor1, AColor2: TColor; AStep: Byte; AAlpha1: Byte = $FF; AAlpha2: Byte = $FF);
procedure cxDrawTransparencyCheckerboard(DC: HDC; const ARect: TRect; ACellSize: Integer = cxTransparencyCheckerboardSizeDefault); overload;
procedure cxDrawTransparencyCheckerboard(ACanvas: TcxCanvas; const ARect: TRect; ACellSize: Integer = cxTransparencyCheckerboardSizeDefault); overload;
procedure cxTransformImage(ABitmap: TBitmap; AMode: TcxBitmapTransformationMode); overload;
procedure cxTransformImage(AImage: TdxSmartImage; AMode: TcxBitmapTransformationMode); overload;
function cxGetAsBitmap(AGraphic: TGraphic): TBitmap;
function cxGetImageRect(const ADrawRect: TRect; const AImageSize: TSize;
  AFitMode: TcxImageFitMode; ACentre: Boolean = True; AScale: Integer = 100): TRect; overload;
function cxGetImageRect(const ADrawRect: TdxRectF; const AImageSize: TdxSizeF;
  AFitMode: TcxImageFitMode; ACentre: Boolean = True; AScale: Single = 100): TdxRectF; overload;

function cxPrepareBitmapForDrawing(AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer;
  AUseLeftBottomPixelAsTransparent: Boolean; ATransparentColor: TColor; APalette: IdxColorPalette = nil;
  AGlyphWidth: Integer = 0; AGlyphHeight: Integer = 0): TcxAlphaBitmap; overload;
function cxPrepareBitmapForDrawing(AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer;
  AUseLeftBottomPixelAsTransparent: Boolean; ATransparentColor: TColor; APalette: IdxColorPalette;
  AGlyphWidth: Integer; AGlyphHeight: Integer; ASmoothResize: Boolean;
  out AMaskBitmap: TcxAlphaBitmap; out AIsAlphaUsed: Boolean): TcxAlphaBitmap; overload;

function cxSmoothDrawingNeeded(const ADest: TRect; AGraphic: TGraphic; AScaleFactor: TdxScaleFactor): Boolean;

procedure cxSmoothResizeBitmap(ASource, ADestination: TBitmap; AForceUseLanczos3Filter: Boolean = False);
procedure cxStretchBlt(ADestDC, ASrcDC: HDC; const ADestRect, ASrcRect: TRect; ROP: DWORD);
procedure cxStretchGraphic(ADestination: TBitmap; ASource: TGraphic;
  ASmoothStretch: Boolean = False; APalette: IdxColorPalette = nil); overload;
procedure cxStretchGraphic(ADestination: TBitmap; ASource: TGraphic; const ADestRect, ASourceRect: TRect;
  ASmoothStretch: Boolean = False; APalette: IdxColorPalette = nil); overload;

procedure cxMakeColoredBitmap(ABitmap: TBitmap; AColor: TColor);
procedure cxMakeMaskBitmap(ASourceBitmap, AMaskBitmap: TBitmap);
procedure cxMakeTrueColorBitmap(ASourceBitmap, ATrueColorBitmap: TBitmap);

{!!! TODO: adapt to .net}
// mouse cursor size
function cxGetCursorSize: TSize;

// image helper routines
function CanApplySystemAlphaBlending: Boolean;
function SystemAlphaBlend(ADestDC, ASrcDC: HDC; const ADestRect, ASrcRect: TRect;
  AAlpha: Byte = $FF; AHasPerPixelAlpha: Boolean = True): Boolean;
procedure cxAlphaBlend(ASource: TBitmap; ARect: TRect; const ASelColor: TColor; Alpha: Byte = 170); overload;
procedure cxAlphaBlend(ADest, ABkSource, ASource: TBitmap; Alpha: Byte = cxDefaultAlphaValue); overload;
procedure cxApplyViewParams(ACanvas: TcxCanvas; const AViewParams: TcxViewParams);
procedure cxCopyImage(ASource, ADest: TBitmap; const ASrcOffset, ADstOffset: TPoint; const ARect: TRect); overload;
procedure cxCopyImage(ASource, ADest: TCanvas; const ASrcOffset, ADstOffset: TPoint; const ARect: TRect); overload;
function cxCopyImage(ASrcHandle: HBITMAP): HBITMAP; overload;
procedure cxClearBitmap(ABitmap: TBitmap);
procedure cxFillHalfToneRect(Canvas: TCanvas; const ARect: TRect; ABkColor, AColor: TColor);
procedure cxFillRectWithCustomBrush(ACanvas: TCanvas; ABrush: TBrush;
  const ARect: TRect; ABkColor, AColor: TColor; ATransparentBackground: Boolean = False);

function cxGetTextExtentPoint32(ADC: THandle; const AText: string; out ASize: TSize; ACharCount: Integer = -1): Boolean;
procedure cxGetTextLines(const AText: string; ACanvas: TcxCanvas; const ARect: TRect; ALines: TStrings);
function cxDrawText(ADC: THandle; const AText: string; var ARect: TRect;
  AFormat: UINT; ACharCount: Integer = - 1; ATextColor: TColor = clDefault; ABkMode: Integer = TRANSPARENT): Integer; overload;
function cxDrawText(ACanvas: TCanvas; const AText: string; ARect: TRect;
  AFormat: UINT; ATextColor: TColor = clDefault): Integer; overload;
function cxDrawText(ACanvas: TcxCanvas; const AText: string; const ARect: TRect;
  AFormat: UINT; ATextColor: TColor = clDefault; ARotationAngle: TcxRotationAngle = ra0): Integer; overload;
function cxDrawMultilineText(ACanvas: TcxCanvas; const AText: string;
  const ARect: TRect; AFormat: UINT; ATextColor: TColor = clDefault): Integer; overload;
function cxDrawMultilineText(ACanvas: TcxCanvas; const AText: string; const ARect: TRect;
  ATextAlignHorz: TAlignment = taLeftJustify; ATextAlignVert: TcxAlignmentVert = vaTop;
  ATextColor: TColor = clDefault): Integer; overload;
function cxExtTextOut(ADC: THandle; const AText: string; const APoint: TPoint;
  const ARect: TRect; AOptions: UINT; ACharCount: Integer = -1): Boolean; overload;
function cxExtTextOut(ADC: THandle; const AText: string; const APoint: TPoint;
  AOptions: UINT; ACharCount: Integer = -1): Boolean; overload;

function cxTextHeight(AFont: TFont): Integer; overload; inline;
function cxTextHeight(ADC: THandle): Integer; overload; inline;
function cxTextHeight(AFont: TFont; const S: string; AFontSize: Integer = 0): Integer; overload; inline;
function cxTextHeight(AFont: TFont; const S: string; ARect: TRect; AFlags: Integer): Integer; overload; inline;
function cxTextWidth(AFont: TFont; const S: string; AFontSize: Integer = 0): Integer; inline;
function cxTextExtent(AFontHandle: THandle; const S: string): TSize; overload; inline;
function cxTextExtent(AFont: TFont; const S: string; AFontSize: Integer = 0): TSize; overload; inline;
function cxTextSize(ADC: THandle; const AText: string): TSize; overload; inline;
function cxTextSize(AFont: TFont; const AText: string; AFlags: Integer = 0): TSize; overload; inline;
function cxGetTextRect(ADC: THandle; const AText: string; ARowCount: Integer;
  AReturnMaxRectHeight: Boolean = False; ADTFlags: Integer = 0): TRect; overload; inline;
function cxGetTextRect(AFont: TFont; const AText: string; ARowCount: Integer; AConsiderLineBreaks: Boolean = False): TRect; overload;
procedure cxGetTextRect(var ARect: TRect; const AText: string; AFont: TFont; ADTFlags: Integer); overload; inline;
function cxGetStringAdjustedToWidth(ADC: HDC; AFontHandle: HFONT; const S: string; AWidth: Integer; AModifyStringType: TcxModifyStringType = mstEndEllipsis): string; overload; inline;
function cxGetStringAdjustedToWidth(AFont: TFont; const S: string; AWidth: Integer; AModifyStringType: TcxModifyStringType = mstEndEllipsis): string; overload; inline;

function cxCompareBitmaps(ABitmap1, ABitmap2: TBitmap): Boolean;
function cxCompareGraphics(AGraphic1, AGraphic2: TGraphic): Boolean;
function cxGetBitmapData(ABitmapHandle: HBITMAP; out ABitmapData: Windows.TBitmap): Boolean;
function cxGetImageClientRect(AImage: TGraphic): TRect; inline;
function cxGetBrushData(ABrushHandle: HBRUSH; out ALogBrush: TLogBrush): Boolean; overload;
function cxGetBrushData(ABrushHandle: HBRUSH): TLogBrush; overload;
function cxGetFontData(AFontHandle: HFONT; out ALogFont: TLogFont): Boolean;
function cxGetPenData(APenHandle: HPEN; out ALogPen: TLogPen): Boolean;
function cxGetTextMetrics(AFont: TFont; out ATextMetric: TTextMetric): Boolean;

procedure cxInitLogFont(var ALogFont: TLogFont; const AFontName: string);
procedure cxResetFont(AFont: TFont; AScaleFactor: TdxScaleFactor);

function cxGetWritingDirection(AFontCharset: TFontCharset; const AText: string): TCanvasOrientation;
procedure cxDrawThemeParentBackground(AControl: TWinControl; ACanvas: TcxCanvas; const ARect: TRect); overload;
procedure cxDrawThemeParentBackground(AControl: TWinControl; ACanvas: TCanvas; const ARect: TRect); overload;

procedure cxDrawTransparentControlBackground(AControl: TWinControl;
  ACanvas: TcxCanvas; ARect: TRect; APaintParentWithChildren: Boolean = True); overload;
procedure cxDrawTransparentControlBackground(AControl: TWinControl;
  ACanvas: TCanvas; const ARect: TRect; APaintParentWithChildren: Boolean = True); overload;
procedure cxDrawTransparentControlBackground(AControl: TWinControl;
  ACanvas: TcxCanvas; const ASourceRect: TRect; const ADestinationPoint: TPoint; APaintParentWithChildren: Boolean = True); overload;
function cxIsTransparentBackgroundDrawing(ABackgroundControl: TWinControl): Boolean;

procedure cxRightToLeftDependentDraw(ACanvas: TcxCanvas; const R: TRect; AProc: TProc); overload;
procedure cxRightToLeftDependentDraw(DC: HDC; const R: TRect; AIsRightToLeftLayout: Boolean; AProc: TProc;
  ACorrectNeeded: Boolean = True); overload;

function cxMeasureCanvas: TcxCanvas;
function cxPaintCanvas: TcxPaintCanvas;
function cxScreenCanvas: TcxScreenCanvas;

procedure cxPaintControlTo(ADrawingControl: TWinControl; ACanvas: TcxCanvas;
  const ADestinationPoint: TPoint; const ADrawingRect: TRect; ADrawParentWithChildren, ADrawNC: Boolean;
  AConsiderWindowRegion: Boolean = True; ACheckVisibility: Boolean = True);
procedure cxPaintTo(ASourceControl: TWinControl; ADestinationCanvas: TcxCanvas; const ADestinationPoint: TPoint;
  const ASourceRect: TRect; ASkipList: TList = nil);
procedure cxPaintToBitmap(AControl: TWinControl; ABitmap: TcxBitmap; ADrawNCArea: Boolean = False);

function cxPtInRegion(ARegionHandle: HRGN; const P: TPoint): Boolean; overload; inline;
function cxPtInRegion(ARegionHandle: HRGN; const X, Y: Integer): Boolean; overload; inline;

procedure cxTransformImages(AImageList: TcxImageList; ABkColor: TColor; AEnabled: Boolean = True); overload;
procedure cxTransformImages(ASourceImageList, ADestinationImageList: TcxImageList; ABkColor: TColor; AEnabled: Boolean = True); overload;

procedure cxAdvancedDrawPopupMenuItem(AMenuItem: TMenuItem; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState; AExternalImages: TCustomImageList = nil); overload;
procedure cxAdvancedDrawPopupMenuItem(AMenuItem: TMenuItem; ACanvas: TcxCanvas; ARect: TRect;
  AState: TOwnerDrawState; AExternalImages: TCustomImageList = nil); overload;

procedure dxSetFontAsNonAntialiased(AFont : TFont);
procedure dxSetZoomFactor(ACanvas: TcxCanvas; AZoomFactor: Integer; var APrevTransform: XFORM);

function dxPictureToImage(APicture: TPicture; ASize: TSize; AMode: TcxImageFitMode; var AImage: TdxSmartImage): Boolean;
function dxImageFrameToGraphic(ASource: TdxSmartImage; AFrameIndex: Integer; AImageDataFormat: TdxImageDataFormat = dxImageTiff): TdxSmartImage;

function cxRectExcludeBorders(const ABounds, ABordersWidth: TRect; ABorders: TcxBorders): TRect; overload;
function cxRectExcludeBorders(const ABounds: TRect; ABorderWidth: Integer; const ABorders: TcxBorders): TRect; overload;

type
  TdxGetImageFrameProc = function(AIndex: Integer; const ASize: TSize; AMode: TcxImageFitMode; var AFrame: TdxSmartImage): Boolean of object;

function dxCreateMultiFrameTIFF(AFrameCount: Integer; const ASize: TSize; AMode: TcxImageFitMode; AProc: TdxGetImageFrameProc): TdxSmartImage;

function cxGraphicExtension(AGraphic: TGraphic): string; overload;
function cxGraphicExtension(AGraphicClass: TGraphicClass): string; overload;
function cxGraphicFileMask(AGraphicClass: TGraphicClass): string;
function cxGraphicFilter(AGraphic: TGraphic; AForExport: Boolean = False): string; overload;
function cxGraphicFilter(AGraphicClass: TGraphicClass): string; overload;
procedure cxGraphicDormant(AGraphic: TGraphic);

const
  LAYOUT_LTR = 0;
{$EXTERNALSYM LAYOUT_RTL}
  LAYOUT_RTL = $1; // Right to left
{$EXTERNALSYM LAYOUT_BITMAPORIENTATIONPRESERVED}
  LAYOUT_BITMAPORIENTATIONPRESERVED = $8;

function SetLayout(DC: HDC; Layout: DWORD): DWORD; stdcall; external gdi32 name 'SetLayout';
{$EXTERNALSYM SetLayout}

implementation

uses
{$IFDEF DELPHIXE8}
  System.Hash,
{$ENDIF}
{$IFDEF DELPHI103}
  Vcl.VirtualImageList,
{$ENDIF}
  Forms, Messages, Math, Contnrs, StrUtils, Consts, Themes,
  cxControls, dxUxTheme, dxOffice11, dxThemeConsts, dxThemeManager, cxDrawTextUtils,
  dxSVGImage, dxHash, cxLookAndFeels, dxPopupMenus;

const
  dxThisUnitName = 'cxGraphics';

type
  TCanvasAccess = class(TCanvas);
  TComponentAccess = class(TComponent);
  TcxImageListAccess = class(TcxImageList);
  TdxCustomSmartImageAccess = class(TdxCustomSmartImage);
  TdxSmartGlyphAccess = class(TdxSmartGlyph);
  TWinControlAccess = class(TWinControl);

  TScreenCanvas = class(TCanvas)
  private
    FDeviceContext: HDC;
    FWindowHandle: HWND;
  protected
    procedure CreateHandle; override;
    procedure FreeHandle;
  public
    destructor Destroy; override;
  end;

const
{!!! TODO: adapt to .net}
  BaseRgns: array[0..3, 0..6, 0..1] of Integer =
  (((0, -1), (-5, -6),(-2, -6), (-2, -9), (2, -9), (2, -6), (5, -6)),
   ((0, 0), (5, 5), (2, 5), (2, 8), (-2, 8), (-2, 5), (-5, 5)),
   ((-1, 0), (-6, -5), (-6, -2), (-9, -2), (-9, 2), (-6, 2), (-6, 5)),
   ((0, 0), (5, 5), (5, 2), (8, 2), (8, -2), (5, -2), (5, -5)));
  DefaultBlendFunction: TBlendFunction =
   (BlendOp: AC_SRC_OVER;
    BlendFlags: 0;
    SourceConstantAlpha: cxDefaultAlphaValue;
    AlphaFormat: $0);

var
  FUnitIsFinalized: Boolean;
  MeasureCanvas: TcxMeasureCanvas = nil;
  PaintCanvas: TcxPaintCanvas = nil;
  ScreenCanvas: TcxScreenCanvas = nil;
  DrawBitmap, ImageBitmap, MaskBitmap: TcxAlphaBitmap;
  FMsimg32DLL: HMODULE;
  FPixelsPerInch: TSize;
  PaintSkipList: TList;

  VCLAlphaBlend: function(DC: LongWord; p2, p3, p4, p5: Integer; DC6: LongWord;  p7, p8, p9, p10: Integer; p11: TBlendFunction): BOOL; stdcall;
  GradientFill: function (ADC: THandle; AVertex: PTriVertex; ANumVertex: Integer; AMesh: PGradientRect; ANumMesh: Integer; AMode: DWORD): LongBool; stdcall;

function cxGetCurrentDPI: Integer;
begin
  Result := cxGetPixelsPerInch.cy;
end;

function cxGetValueCurrentDPI(AValue: Integer): Integer;
begin
  Result := MulDiv(AValue, cxGetCurrentDPI, dxDefaultDPI);
end;

function cxGetValueCurrentDPI(const AValue: TPoint): TPoint;
begin
  Result := cxPoint(cxGetValueCurrentDPI(AValue.X), cxGetValueCurrentDPI(AValue.Y));
end;

function cxGetValueCurrentDPI(const AValue: TRect): TRect;
begin
  Result.Bottom := cxGetValueCurrentDPI(AValue.Bottom);
  Result.Left := cxGetValueCurrentDPI(AValue.Left);
  Result.Right := cxGetValueCurrentDPI(AValue.Right);
  Result.Top := cxGetValueCurrentDPI(AValue.Top);
end;

function cxGetValueCurrentDPI(const AValue: TSize): TSize;
begin
  Result.Init(cxGetValueCurrentDPI(AValue.cx), cxGetValueCurrentDPI(AValue.cy));
end;

function cxGetPixelsPerInch: TSize;
begin
  Result := FPixelsPerInch;
end;

procedure cxBitmapInit(var ABitmap: TcxAlphaBitmap; AWidth, AHeight: Integer);
begin
  if ABitmap = nil then
    ABitmap := TcxAlphaBitmap.CreateSize(AWidth, AHeight, True)
  else
    ABitmap.RefreshImage(AWidth, AHeight);
end;

function GetDrawBitmap(AWidth, AHeight: Integer): TcxAlphaBitmap;
begin
  cxBitmapInit(DrawBitmap, AWidth, AHeight);
  Result := DrawBitmap;
end;

function GetImageBitmap(AWidth, AHeight: Integer): TcxAlphaBitmap;
begin
  cxBitmapInit(ImageBitmap, AWidth, AHeight);
  Result := ImageBitmap;
end;

function GetMaskBitmap(AWidth, AHeight: Integer): TcxAlphaBitmap;
begin
  cxBitmapInit(MaskBitmap, AWidth, AHeight);
  Result := MaskBitmap;
end;

function cxFlagsToDTFlags(Flags: Integer): Integer;
const
  DT_NOFULLWIDTHCHARBREAK = $80000;
begin
  Result := DT_NOPREFIX;
  if cxAlignLeft and Flags <> 0 then
    Result := Result or DT_LEFT;
  if cxAlignRight and Flags <> 0 then
    Result := Result or DT_RIGHT;
  if cxAlignHCenter and Flags <> 0 then
    Result := Result or DT_CENTER;
  if cxAlignTop and Flags <> 0 then
    Result := Result or DT_TOP;
  if cxAlignBottom and Flags <> 0 then
    Result := Result or DT_BOTTOM;
  if cxAlignVCenter and Flags <> 0 then
    Result := Result or DT_VCENTER;
  if cxSingleLine and Flags <> 0 then
    Result := Result or DT_SINGLELINE;
  if cxDontClip and Flags <> 0 then
    Result := Result or DT_NOCLIP;
  if cxExpandTabs and Flags <> 0 then
    Result := Result or DT_EXPANDTABS;
  if cxShowPrefix and Flags <> 0 then
    Result := Result and not DT_NOPREFIX;
  if cxWordBreak and Flags <> 0 then
  begin
    Result := Result or DT_WORDBREAK;
    if cxDontBreakChars and Flags = 0 then
      Result := Result or DT_EDITCONTROL
    else
      if cxNoFullWidthCharBreak and Flags <> 0 then
        Result := Result or DT_NOFULLWIDTHCHARBREAK;
  end;
  if cxShowEndEllipsis and Flags <> 0 then
    Result := Result or DT_END_ELLIPSIS;
  if cxShowWordEllipsis and Flags <> 0 then
    Result := Result or DT_WORD_ELLIPSIS;
  if cxDontPrint and Flags <> 0 then
    Result := Result or DT_CALCRECT;
  if cxShowPathEllipsis and Flags <> 0 then
    Result := Result or DT_PATH_ELLIPSIS;
  if cxRtlReading and Flags <> 0 then
    Result := Result or DT_RTLREADING;
end;

procedure cxSetImageList(const AValue: TCustomImageList; var AFieldValue: TCustomImageList;
  AChangeLink: TChangeLink; ANotifyComponent: TComponent; ANotificationProc: TdxComponentNotificationProc = nil);
begin
  if AValue <> AFieldValue then
  begin
    if AFieldValue <> nil then
    begin
      AFieldValue.RemoveFreeNotification(ANotifyComponent);
      if AChangeLink <> nil then
        AFieldValue.UnRegisterChanges(AChangeLink);
      if Assigned(ANotificationProc) then
        ANotificationProc(AFieldValue, opRemove);
    end;
    AFieldValue := AValue;
    if AFieldValue <> nil then
    begin
      if AChangeLink <> nil then
        AFieldValue.RegisterChanges(AChangeLink);
      AFieldValue.FreeNotification(ANotifyComponent);
      if Assigned(ANotificationProc) then
        ANotificationProc(AFieldValue, opInsert);
    end;
    if AChangeLink <> nil then
      AChangeLink.Change;
  end;
end;

function IsGlyphAssigned(AGlyph: TGraphic): Boolean;
begin
  Result := IsImageAssigned(AGlyph);
end;

function IsImageAssigned(AImageList: TCustomImageList; AImageIndex: Integer): Boolean;
begin
  Result := (AImageList <> nil) and (0 <= AImageIndex) and (AImageIndex < AImageList.Count);
end;

function IsImageAssigned(AGlyph: TGraphic; AImageList: TCustomImageList; AImageIndex: Integer): Boolean;
begin
  Result := IsImageAssigned(AGlyph) or IsImageAssigned(AImageList, AImageIndex);
end;

function IsImageAssigned(AImage: TGraphic): Boolean;
begin
  Result := (AImage <> nil) and not AImage.Empty;
end;

function IsPictureAssigned(APicture: TPicture): Boolean;
begin
  Result := (APicture <> nil) and IsImageAssigned(APicture.Graphic);
end;

function dxGetImageSize(AImage: TGraphic): TSize;
var
  ASourceSizeIntf: IdxSourceSize;
begin
  if AImage <> nil then
  begin
    if Supports(AImage, IdxSourceSize, ASourceSizeIntf) then
      Result := ASourceSizeIntf.GetSourceSize
    else
      Result := Size(AImage.Width, AImage.Height);
  end
  else
    Result := cxNullSize;
end;

function dxGetImageSize(AImage: TGraphic; AImageList: TCustomImageList; AImageIndex: Integer; AScaleFactor: TdxScaleFactor): TSize;
begin
  if IsImageAssigned(AImage) then
    Result := AScaleFactor.Apply(dxGetImageSize(AImage), dxGetImageSourceDPI(AImage), dxDefaultDPI)
  else
    if IsImageAssigned(AImageList, AImageIndex) then
      Result := dxGetImageSize(AImageList, AScaleFactor)
    else
      Result := cxNullSize;
end;

function dxGetImageSize(AImage: TGraphic; AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := dxGetImageSize(AImage, nil, -1, AScaleFactor);
end;

function dxGetImageSize(AImage: TGraphic; AImageList: TCustomImageList; AImageIndex: Integer): TSize;
begin
  Result := dxGetImageSize(AImage, AImageList, AImageIndex, dxSystemScaleFactor);
end;

function dxGetImageSize(AImageList: TCustomImageList; AScaleFactor: TdxScaleFactor): TSize;
begin
  if AImageList <> nil then
  begin
    Result.Init(AImageList.Width, AImageList.Height);
  {$IFDEF DELPHI103}
    if not (AImageList is TVirtualImageList) then
  {$ENDIF}
      Result := AScaleFactor.Apply(Result, dxGetImageSourceDPI(AImageList), dxDefaultDPI);
  end
  else
    Result := cxNullSize;
end;

function dxGetImageSize(AImageList: TCustomImageList; APPI: Integer): TSize; overload;
var
  AImageSourceDPI: Integer;
begin
  if AImageList <> nil then
  begin
    Result.Init(AImageList.Width, AImageList.Height);
  {$IFDEF DELPHI103}
    if not (AImageList is TVirtualImageList) then
  {$ENDIF}
    begin
      AImageSourceDPI := dxGetImageSourceDPI(AImageList);
      Result.cx := MulDiv(Result.cx, APPI, AImageSourceDPI);
      Result.cy := MulDiv(Result.cy, APPI, AImageSourceDPI);
    end;
  end
  else
    Result := cxNullSize;
end;

function dxGetImageSize(APicture: TPicture; AScaleFactor: TdxScaleFactor): TSize;
begin
  if IsPictureAssigned(APicture) then
    Result := dxGetImageSize(APicture.Graphic, nil, -1, AScaleFactor)
  else
    Result := cxNullSize;
end;

function dxGetImageSize(APicture: TPicture): TSize;
begin
  Result := dxGetImageSize(APicture, dxSystemScaleFactor);
end;

function dxGetImageSourceDPI(AImage: TObject): Integer;
var
  AIntf: IdxSourceDPI;
begin
  if Supports(AImage, IdxSourceDPI, AIntf) then
    Result := AIntf.GetSourceDPI
  else
    if not (Assigned(FGetSourceDPIFunc) and FGetSourceDPIFunc(AImage, Result)) then
      Result := dxDefaultDPI;
end;

function IsXPManifestEnabled: Boolean;
begin
  Result := GetComCtlVersion >= ComCtlVersionIE6
end;

function dxGetNearestColor(AColor: TColor): TColor;
var
  DC: HDC;
begin
  DC := GetDC(0);
  Result := GetNearestColor(DC, AColor);
  ReleaseDC(0, DC);
end;

function dxInvertColor(AColor: TColor): TColor;
begin
  Result := $FFFFFF xor ColorToRGB(AColor);
end;

function dxOffsetColor(AColor: TColor; ARed, AGreen, ABlue: Byte): TColor;
var
  Red, Green, Blue: Integer;
begin
  AColor := ColorToRGB(AColor);
  Red := GetRValue(AColor) + ARed;
  if Red > High(Byte) then Red := High(Byte);
  if Red < Low(Byte) then Red := Low(Byte);

  Green := GetGValue(AColor) + AGreen;
  if Green > High(Byte) then Green := High(Byte);
  if Green < Low(Byte) then Green := Low(Byte);

  Blue := GetBValue(AColor) + ABlue;
  if Blue > High(Byte) then Blue := High(Byte);
  if Blue < Low(Byte) then Blue := Low(Byte);

  Result := RGB(Red, Green, Blue);
end;

function cxGetActualAlphaColor(const AValue, ADefaultValue: TdxAlphaColor): TdxAlphaColor;
begin
  Result := AValue;
  if Result = TdxAlphaColors.Default then
    Result := ADefaultValue;
end;

function cxGetActualColor(const AValue, ADefaultValue: TColor): TColor;
begin
  Result := AValue;
  if Result = clDefault then
    Result := ADefaultValue;
end;

function dxColorToHSV(AColor: TColor): TdxHSV;
begin
  Result := TdxColorUtils.ColorToHSV(AColor);
end;

function dxHSVToColor(const AHSV: TdxHSV): TColor;
begin
  Result := TdxColorUtils.HSVToColor(AHSV);
end;

function dxGetColorTint(AColor: TColor; ATintPercent: Integer): TColor;
var
  AHSV: TdxHSV;
begin
  AHSV := dxColorToHSV(AColor);
  if ATintPercent < 0 then
  begin
    if AHSV.S <> 0 then
      AHSV.S := Max(0, Min(1, AHSV.S + (1 - AHSV.S) * Abs(ATintPercent) / 100));
    AHSV.V := Max(0, Min(1, AHSV.V - AHSV.V * Abs(ATintPercent) / 100));
  end
  else
  begin
    if AHSV.S <> 0 then
      AHSV.S := Max(0, Min(1, AHSV.S - AHSV.S * ATintPercent / 100));
    AHSV.V := Max(0, Min(1, AHSV.V + (1 - AHSV.V) * ATintPercent / 100));
  end;

  Result := dxHSVToColor(AHSV);
end;

function GetChannelValue(AValue: Integer): Byte;
begin
  if AValue < 0 then
    Result := 0
  else
    if AValue > 255 then
      Result := 255
    else
      Result := AValue;
end;

function GetLightColor(ABtnFaceColorPart, AHighlightColorPart, AWindowColorPart: TcxColorPart): TColor;
var
  ABtnFaceColor, AHighlightColor, AWindowColor: TColor;

  function GetLightIndex(ABtnFaceValue, AHighlightValue, AWindowValue: Byte): Integer;
  begin
    Result := GetChannelValue(
      MulDiv(ABtnFaceValue, ABtnFaceColorPart, 100) +
      MulDiv(AHighlightValue, AHighlightColorPart, 100) +
      MulDiv(AWindowValue, AWindowColorPart, 100));
  end;

begin
  ABtnFaceColor := ColorToRGB(clBtnFace);
  AHighlightColor := ColorToRGB(clHighlight);
  AWindowColor := ColorToRGB(clWindow);
  if ((ABtnFaceColor = 0) or (ABtnFaceColor = $FFFFFF)) and (AHighlightColor <> 0) then
    Result := AHighlightColor
  else
    Result := RGB(
      GetLightIndex(GetRValue(ABtnFaceColor), GetRValue(AHighlightColor), GetRValue(AWindowColor)),
      GetLightIndex(GetGValue(ABtnFaceColor), GetGValue(AHighlightColor), GetGValue(AWindowColor)),
      GetLightIndex(GetBValue(ABtnFaceColor), GetBValue(AHighlightColor), GetBValue(AWindowColor)));
end;

function GetLightBtnFaceColor: TColor;

  function GetLightValue(Value: Byte): Byte;
  begin
    Result := GetChannelValue(Value + MulDiv(255 - Value, 16, 100));
  end;

begin
  Result := ColorToRGB(clBtnFace);
  Result := RGB(
    GetLightValue(GetRValue(Result)),
    GetLightValue(GetGValue(Result)),
    GetLightValue(GetBValue(Result)));
  Result := dxGetNearestColor(Result);
end;

function GetLightDownedColor: TColor;
begin
  Result := dxGetNearestColor(GetLightColor(11, 9, 73));
end;

function GetLightDownedSelColor: TColor;
begin
  Result := dxGetNearestColor(GetLightColor(14, 44, 40));
end;

function GetLightSelColor: TColor;
begin
  Result := dxGetNearestColor(GetLightColor(-2, 30, 72));
end;

function dxGetDarkerColor(AColor: TColor; APercent: Byte): TColor;
var
  R, G, B: Byte;
begin
  AColor := ColorToRGB(AColor);
  R := Trunc(GetRValue(AColor) * APercent / 100);
  G := Trunc(GetGValue(AColor) * APercent / 100);
  B := Trunc(GetBValue(AColor) * APercent / 100);
  Result := RGB(R, G, B);
end;

function dxGetMiddleRGB(AColor1, AColor2: TColor; APercent: Integer): TColor;

  function CalcValue(Value1, Value2: Byte): Byte;
  var
    I: Integer;
  begin
    I := MulDiv(Value1, APercent, 100) + MulDiv(Value2, 100 - APercent, 100);
    if I > 255 then I := 255;
    Result := I;
  end;

begin
  AColor1 := ColorToRGB(AColor1);
  AColor2 := ColorToRGB(AColor2);
  Result := RGB(
    CalcValue(GetRValue(AColor1), GetRValue(AColor2)),
    CalcValue(GetGValue(AColor1), GetGValue(AColor2)),
    CalcValue(GetBValue(AColor1), GetBValue(AColor2)));
  Result := dxGetNearestColor(Result);
end;

function dxGetLighterColor(AColor: TColor; APercent: Byte): TColor;
var
  R, G, B: Byte;
begin
  AColor := ColorToRGB(AColor);
  R := Trunc(255 - APercent / 100 * (255 - GetRValue(AColor)));
  G := Trunc(255 - APercent / 100 * (255 - GetGValue(AColor)));
  B := Trunc(255 - APercent / 100 * (255 - GetBValue(AColor)));
  Result := RGB(R, G, B);
end;

function dxGetColorRelativeLuminance(AColor: TColor): Single;
var
  R, G, B: Byte;
begin
  AColor := ColorToRGB(AColor);
  R := GetRValue(AColor);
  G := GetGValue(AColor);
  B := GetBValue(AColor);
  Result := (0.2126 * R + 0.7152 * G + 0.0722 * B) / 255;
end;

function IsHighContrast: Boolean;
begin
  Result := IsHighContrastBlack or IsHighContrastWhite or IsHighContrast2;
end;

function IsHighContrastBlack: Boolean;
begin
  Result := GetSysColor(COLOR_BTNFACE) = 0; // Black
end;

function IsHighContrastWhite: Boolean;
begin
  Result := (GetSysColor(COLOR_BTNFACE) = $FFFFFF); // White
end;

function IsHighContrast2: Boolean;
begin
  Result := (GetSysColor(COLOR_BTNFACE) = 0) and (GetSysColor(COLOR_BTNTEXT) <> $FFFFFF); // #2
end;

function cxIntersectClipRect(DC: HDC; const R: TRect): Boolean;
begin
  Result := Windows.IntersectClipRect(DC, R.Left, R.Top, R.Right, R.Bottom) <> NULLREGION;
end;

procedure cxExcludeClipRect(DC: HDC; const R: TRect);
begin
  Windows.ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
end;

procedure FillGradientRect(DC: HDC; const ARect: TRect; AColor1, AColor2: TColor; AHorizontal: Boolean);

  procedure SoftwareGradientFill(ARGBColor1, ARGBColor2: DWORD);
  var
    FromR, ToR, FromG, ToG, FromB, ToB: Byte;
    SR: TRect;
    W, I, N: Integer;
    R, G, B: Byte;
  begin
    FromR := GetRValue(ARGBColor1);
    FromG := GetGValue(ARGBColor1);
    FromB := GetBValue(ARGBColor1);
    ToR := GetRValue(ARGBColor2);
    ToG := GetGValue(ARGBColor2);
    ToB := GetBValue(ARGBColor2);
    SR := ARect;
    if AHorizontal then
      W := SR.Right - SR.Left
    else
      W := SR.Bottom - SR.Top;
    N := 256;
    if W < N then
      N := W;
    for I := 0 to N - 1 do
    begin
      if AHorizontal then
        SR.Right := ARect.Left + MulDiv(I + 1, W, N)
      else
        SR.Bottom := ARect.Top + MulDiv(I + 1, W, N);
      R := FromR + MulDiv(I, ToR - FromR, N - 1);
      G := FromG + MulDiv(I, ToG - FromG, N - 1);
      B := FromB + MulDiv(I, ToB - FromB, N - 1);
      if not IsRectEmpty(SR) then
        FillRectByColor(DC, SR, RGB(R, G, B));
      if AHorizontal then
      begin
        SR.Left := SR.Right;
        if SR.Left >= ARect.Right then
          Break;
      end
      else
      begin
        SR.Top := SR.Bottom;
        if SR.Top >= ARect.Bottom then
          Break;
      end;
    end;
  end;

  procedure SystemGradientFill(ARGBColor1, ARGBColor2: DWORD);

    procedure SetVertex(var AVertex: TTriVertex; const APoint: TPoint; ARGBColor: DWORD);
    begin
      AVertex.X := APoint.X;
      AVertex.Y := APoint.Y;
      AVertex.Red := MakeWord(0, GetRValue(ARGBColor));
      AVertex.Green := MakeWord(0, GetGValue(ARGBColor));
      AVertex.Blue := MakeWord(0, GetBValue(ARGBColor));
      AVertex.Alpha := 0;
    end;

  const
    ModesMap: array[Boolean] of DWORD = (GRADIENT_FILL_RECT_V, GRADIENT_FILL_RECT_H);
  var
    AGradientRect: TGradientRect;
    AVertices: array[0..1] of TTriVertex;
  begin
    SetVertex(AVertices[0], ARect.TopLeft, ARGBColor1);
    SetVertex(AVertices[1], ARect.BottomRight, ARGBColor2);
    AGradientRect.UpperLeft := 0;
    AGradientRect.LowerRight := 1;
    GradientFill(DC, @AVertices[0], 2, @AGradientRect, 1, ModesMap[AHorizontal]);
  end;

var
  ARGBColor1, ARGBColor2: DWORD;
begin
  ARGBColor1 := ColorToRGB(AColor1);
  ARGBColor2 := ColorToRGB(AColor2);
  if ARGBColor1 = ARGBColor2 then
    FillRectByColor(DC, ARect, AColor1)
  else
    if Assigned(GradientFill) then
      SystemGradientFill(ARGBColor1, ARGBColor2)
    else
      SoftwareGradientFill(ARGBColor1, ARGBColor2);
end;

procedure FillTubeGradientRect(DC: HDC; const ARect: TRect; AColor1, AColor2: TColor; AGradientPercent: Integer;
  AHorizontal: Boolean);
var
  FromR, FromG, FromB, ToR, ToG, ToB: Integer;
  ToR1, ToG1, ToB1, ToR2, ToG2, ToB2: Integer;
  SR: TRect;
  W, I, N, M: Integer;
  R, G, B: Byte;
begin
  AColor1 := ColorToRGB(AColor1);
  AColor2 := ColorToRGB(AColor2);
  if AColor1 = AColor2 then
  begin
    FillRect(DC, ARect, TdxSolidBrushCache.Get(AColor1));
    Exit;
  end;

  FromR := GetRValue(AColor1);
  FromG := GetGValue(AColor1);
  FromB := GetBValue(AColor1);
  ToR := GetRValue(AColor2);
  ToG := GetGValue(AColor2);
  ToB := GetBValue(AColor2);
  SR := ARect;
  if AHorizontal then
    W := SR.Right - SR.Left
  else
    W := SR.Bottom - SR.Top;
  M := W div 2;
  ToR1 := FromR - MulDiv(FromR - ToR, AGradientPercent, 200);
  ToG1 := FromG - MulDiv(FromG - ToG, AGradientPercent, 200);
  ToB1 := FromB - MulDiv(FromB - ToB, AGradientPercent, 200);

  ToR2 := FromR - MulDiv(FromR - ToR1, W, M);
  ToG2 := FromG - MulDiv(FromG - ToG1, W, M);
  ToB2 := FromB - MulDiv(FromB - ToB1, W, M);

//  N := 256;
//  if W < N then
//    N := W;
  N := W;

  for I := 0 to N - 1 do
  begin
    if AHorizontal then
      SR.Right := ARect.Left + MulDiv(I + 1, W, N)
    else
      SR.Bottom := ARect.Top + MulDiv(I + 1, W, N);
    if I < M then
    begin
      R := FromR + MulDiv(I, ToR2 - FromR, N - 1);
      G := FromG + MulDiv(I, ToG2 - FromG, N - 1);
      B := FromB + MulDiv(I, ToB2 - FromB, N - 1);
    end
    else
      if I = M then
      begin
        R := ToR1;
        G := ToG1;
        B := ToB1;
        FromR := ToR + MulDiv(ToR1 - ToR, W, M);
        FromG := ToG + MulDiv(ToG1 - ToG, W, M);
        FromB := ToB + MulDiv(ToB1 - ToB, W, M);
      end
      else
      begin
        R := FromR + MulDiv(I, ToR - FromR, N - 1);
        G := FromG + MulDiv(I, ToG - FromG, N - 1);
        B := FromB + MulDiv(I, ToB - FromB, N - 1);
      end;

    if not IsRectEmpty(SR) then
      FillRect(DC, SR, TdxSolidBrushCache.Get(RGB(R, G, B)));
    if AHorizontal then
    begin
      SR.Left := SR.Right;
      if SR.Left >= ARect.Right then
        Break;
    end
    else
    begin
      SR.Top := SR.Bottom;
      if SR.Top >= ARect.Bottom then
        Break;
    end;
  end;
end;

procedure FillRectByColor(DC: HDC; const R: TRect; AColor: TColor);
begin
  if AColor <> clNone then
    FillRect(DC, R, TdxSolidBrushCache.Get(AColor));
end;

procedure FillRegionByColor(DC: HDC; ARegion: HRGN; AColor: TColor);
begin
  if AColor <> clNone then
    FillRgn(DC, ARegion, TdxSolidBrushCache.Get(AColor));
end;

procedure FrameRectByColor(DC: HDC; const R: TRect; AColor: TColor);
begin
  if AColor <> clNone then
    FrameRect(DC, R, TdxSolidBrushCache.Get(AColor));
end;

function GetGradientColorRect(const ARect: TRect; X: Integer; AColor1, AColor2: TColor;
  AHorizontal: Boolean): TColor;
var
  FromR, ToR, FromG, ToG, FromB, ToB: Byte;
  ARectLeft, W, I, N: Integer;
  R, G, B: Byte;
begin
  AColor1 := ColorToRGB(AColor1);
  AColor2 := ColorToRGB(AColor2);
  FromR := GetRValue(AColor1);
  FromG := GetGValue(AColor1);
  FromB := GetBValue(AColor1);
  ToR := GetRValue(AColor2);
  ToG := GetGValue(AColor2);
  ToB := GetBValue(AColor2);
  if AHorizontal then
  begin
    ARectLeft := ARect.Left;
    W := ARect.Right - ARect.Left;
  end
  else
  begin
    ARectLeft := ARect.Top;
    W := ARect.Bottom - ARect.Top;
  end;
  N := 256;
  if W < N then
    N := W;
  I := MulDiv(X - ARectLeft + 1, N, W) - 1;
  if I < 0 then I := 0;
  R := FromR + MulDiv(I, ToR - FromR, N - 1);
  G := FromG + MulDiv(I, ToG - FromG, N - 1);
  B := FromB + MulDiv(I, ToB - FromB, N - 1);
  Result := RGB(R, G, B);
end;

function CanApplySystemAlphaBlending: Boolean;
begin
  Result := {not IsWOW64 and }Assigned(VCLAlphaBlend);
end;

function SystemAlphaBlend(ADestDC, ASrcDC: HDC; const ADestRect, ASrcRect: TRect;
  AAlpha: Byte = $FF; AHasPerPixelAlpha: Boolean = True): Boolean;
const
  AlphaFormatMode: array[Boolean] of Integer = (0, AC_SRC_ALPHA);
var
  ABlendFunction: TBlendFunction;
begin
  ABlendFunction.BlendOp := AC_SRC_OVER;
  ABlendFunction.BlendFlags := 0;
  ABlendFunction.SourceConstantAlpha := AAlpha;
  ABlendFunction.AlphaFormat := AlphaFormatMode[AHasPerPixelAlpha];
  Result := CanApplySystemAlphaBlending and VCLAlphaBlend(
    ADestDC, ADestRect.Left, ADestRect.Top, ADestRect.Width, ADestRect.Height,
    ASrcDC, ASrcRect.Left, ASrcRect.Top, ASrcRect.Width, ASrcRect.Height, ABlendFunction);
end;

function cxColorByName(const AText: string; var AColor: TColor): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Low(cxColorsByName) to High(cxColorsByName) do
    if SameText(AText, cxColorsByName[I].Name) then
    begin
      AColor := cxColorsByName[I].Color;
      Result := True;
      Break;
    end;
end;

function cxNameByColor(AColor: TColor; var AText: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Low(cxColorsByName) to High(cxColorsByName) do
    if AColor = cxColorsByName[I].Color then
    begin
      AText := cxColorsByName[I].Name;
      Result := True;
      Break;
    end;
end;

procedure CommonAlphaBlend(ADestDC, ASrcDC: HDC; const ADestRect, ASrcRect: TRect;
  ASmoothImage: Boolean; AConstantAlpha: Byte = MaxByte; ADestBitmap: TBitmap = nil; ASrcBitmap: TBitmap = nil);

  function CreateDirectBitmap(ASrcDC: HDC; ASrcBitmap: TBitmap; const ASrcRect: TRect): TBitmap;
  begin
    if ASrcBitmap <> nil then
      Result := ASrcBitmap
    else
    begin
      Result := TcxBitmap.CreateSize(ASrcRect, pf32bit);
      Result.AlphaFormat := afPremultiplied; 
      Result.Canvas.Brush.Color := 0;
      Result.Canvas.FillRect(cxGetImageClientRect(Result));
      cxBitBlt(Result.Canvas.Handle, ASrcDC, cxGetImageClientRect(Result), ASrcRect.TopLeft, SRCCOPY);
    end;
  end;

  procedure ReleaseDirectBitmap(var ABitmap: TBitmap; ASrcBitmap: TBitmap);
  begin
    if ABitmap <> ASrcBitmap then
      FreeAndNil(ABitmap);
  end;

  procedure InternalAlphaBlend(ADestBitmap, ASrcBitmap: TBitmap);

    procedure SoftwareAlphaBlend(AWidth, AHeight: Integer);
    var
      ASourceColors, ADestColors: TRGBColors;
      I: Integer;
    begin
      GetBitmapBits(ASrcBitmap, ASourceColors, False);
      GetBitmapBits(ADestBitmap, ADestColors, False);
      for I := 0 to AWidth * AHeight - 1 do
        cxBlendFunction(ASourceColors[I], ADestColors[I], AConstantAlpha);
      SetBitmapBits(ADestBitmap, ADestColors, False);
    end;

  var
    AClientRect: TRect;
  begin
    AClientRect := cxGetImageClientRect(ADestBitmap);
    if not SystemAlphaBlend(ADestBitmap.Canvas.Handle, ASrcBitmap.Canvas.Handle, AClientRect, AClientRect, AConstantAlpha) then
      SoftwareAlphaBlend(AClientRect.Right, AClientRect.Bottom);
  end;

  procedure ComplexAlphaBlend;
  var
    ADirectDestBitmap: TBitmap;
    ADirectSrcBitmap: TBitmap;
    AGraphics: TdxGPGraphics;
    AStretchedSrcBitmap: TcxBitmap;
  begin
    ADirectSrcBitmap := CreateDirectBitmap(ASrcDC, ASrcBitmap, ASrcRect);
    try
      if IsWin64Bit then
      begin
        AGraphics := dxGpBeginPaint(ADestDC, ADestRect);
        try
          AGraphics.InterpolationMode := dxGpSmoothStretchModeMap[ASmoothImage];
          AGraphics.PixelOffsetMode := PixelOffsetModeHalf;
          AGraphics.DrawBitmap(ADirectSrcBitmap, ADestRect, AConstantAlpha);
        finally
          dxGpEndPaint(AGraphics);
        end;
      end
      else
      begin
        ADirectDestBitmap := CreateDirectBitmap(ADestDC, ADestBitmap, ADestRect);
        try
          AStretchedSrcBitmap := TcxBitmap.CreateSize(ADestRect, pf32bit);
          try
            cxStretchGraphic(AStretchedSrcBitmap, ADirectSrcBitmap, ASmoothImage);
            InternalAlphaBlend(ADirectDestBitmap, AStretchedSrcBitmap);
            cxBitBlt(ADestDC, ADirectDestBitmap.Canvas.Handle, ADestRect, cxNullPoint, SRCCOPY);
          finally
            AStretchedSrcBitmap.Free;
          end;
        finally
          ReleaseDirectBitmap(ADirectDestBitmap, ADestBitmap);
        end;
      end;
    finally
      ReleaseDirectBitmap(ADirectSrcBitmap, ASrcBitmap);
    end;
  end;

begin
  if not (cxRectIsEmpty(ADestRect) or cxRectIsEmpty(ASrcRect)) then
  begin
    ASmoothImage := ASmoothImage and not cxSizeIsEqual(ADestRect, ASrcRect);
    if IsWin64Bit or IsWin9X or not CanApplySystemAlphaBlending or ASmoothImage then
      ComplexAlphaBlend
    else
      SystemAlphaBlend(ADestDC, ASrcDC, ADestRect, ASrcRect, AConstantAlpha);
  end;
end;

procedure cxAlphaBlend(ADestBitmap, ASrcBitmap: TBitmap; const ADestRect, ASrcRect: TRect; ASmoothImage: Boolean = False; AConstantAlpha: Byte = $FF); overload;
begin
  CommonAlphaBlend(ADestBitmap.Canvas.Handle, ASrcBitmap.Canvas.Handle, ADestRect, ASrcRect, ASmoothImage, AConstantAlpha, ADestBitmap, ASrcBitmap);
end;

procedure cxAlphaBlend(ADestDC: HDC; ASrcBitmap: TBitmap; const ADestRect, ASrcRect: TRect; ASmoothImage: Boolean = False; AConstantAlpha: Byte = $FF); overload;
begin
  CommonAlphaBlend(ADestDC, ASrcBitmap.Canvas.Handle, ADestRect, ASrcRect, ASmoothImage, AConstantAlpha, nil, ASrcBitmap);
end;

procedure cxAlphaBlend(ADestDC, ASrcDC: HDC; const ADestRect, ASrcRect: TRect; ASmoothImage: Boolean = False; AConstantAlpha: Byte = $FF); overload;
begin
  CommonAlphaBlend(ADestDC, ASrcDC, ADestRect, ASrcRect, ASmoothImage, AConstantAlpha);
end;

procedure cxBitBlt(ADestDC, ASrcDC: HDC; const ADestRect: TRect; const ASrcTopLeft: TPoint; ROP: DWORD);
begin
  BitBlt(ADestDC, ADestRect.Left, ADestRect.Top, ADestRect.Width, ADestRect.Height,
    ASrcDC, ASrcTopLeft.X, ASrcTopLeft.Y, ROP);
end;

procedure cxBlendFunction(const ASource: TRGBQuad; var ADest: TRGBQuad; ASourceConstantAlpha: Byte);

  function GetValue(AValue: Single): Byte;
  begin
    Result := GetChannelValue(Round(AValue));
  end;

var
  ASCA, ASrcAlpha: Single;
begin
  ASCA := ASourceConstantAlpha / 255;
  ASrcAlpha := 1 - ASource.rgbReserved * ASCA / 255;

  ADest.rgbRed := GetValue(ASource.rgbRed * ASCA + ASrcAlpha * ADest.rgbRed);
  ADest.rgbGreen := GetValue(ASource.rgbGreen * ASCA + ASrcAlpha * ADest.rgbGreen);
  ADest.rgbBlue := GetValue(ASource.rgbBlue * ASCA + ASrcAlpha * ADest.rgbBlue);
  ADest.rgbReserved := GetValue(ASource.rgbReserved * ASCA + ASrcAlpha * ADest.rgbReserved);
end;

const
  ClrNone: TRGBQuad = (rgbBlue: $FF; rgbGreen: $FF; rgbRed: $FF; rgbReserved: $FF);
  ClrTransparent: TRGBQuad = (rgbBlue: 0; rgbGreen: 0; rgbRed: 0; rgbReserved: 0);

function cxColorIsValid(AColor: TColor): Boolean;
begin
  Result := (AColor <> clNone) and (AColor <> clDefault);
end;

function cxColorIsEqual(const AColor1, AColor2: TRGBQuad): Boolean;
begin
  Result := DWORD(AColor1) = DWORD(AColor2);
end;

procedure cxExchangeColors(var AColor1, AColor2: TColor);
begin
  ExchangeLongWords(AColor1, AColor2);
end;

function cxColorEssence(const AColor: TRGBQuad): DWORD; inline;
begin
  Result := DWORD(AColor) and $00FFFFFF;
end;

function cxCreateRegionFromBitmap(ABitmap: TBitmap; ATransparentColor: TColor): HRGN;
var
  AColors: TRGBColors;
begin
  GetBitmapBits(ABitmap, AColors, True);
  Result := cxCreateRegionFromBitmap(@AColors[0], ABitmap.Width, ABitmap.Height, ATransparentColor);
end;

function cxCreateRegionFromBitmap(APixels: PRGBQuad; AWidth, AHeight: Integer; ATransparentColor: TColor): HRGN;

  procedure CombineRegion(X, Y: Integer; var ACount: Integer; var ACombined: HRGN);
  var
    ARgn: HRGN;
  begin
    if ACount > 0 then
    begin
      ARgn := CreateRectRgn(X - ACount, Y, X, Y + 1);
      if ACombined = 0 then
        ACombined := ARgn
      else
      begin
        CombineRgn(ACombined, ACombined, ARGN, RGN_OR);
        DeleteObject(ARgn);
      end;
      ACount := 0;
    end;
  end;

var
  ACount: Integer;
  ATransparent: TRGBQuad;
  X, Y: Integer;
begin
  Result := 0;
  ATransparent := dxColorToRGBQuad(ATransparentColor);
  for Y := 0 to AHeight - 1 do
  begin
    ACount := 0;
    for X := 0 to AWidth - 1 do
    begin
      if cxColorEssence(APixels^) = cxColorEssence(ATransparent) then
        CombineRegion(X, Y, ACount, Result)
      else
        Inc(ACount);

      Inc(APixels);
    end;
    CombineRegion(AWidth, Y, ACount, Result);
  end;
end;

procedure cxSetBitmapParams(ABitmap: TBitmap; AWidth, AHeight: Integer; AFormat: TPixelFormat); inline;
begin
  ABitmap.PixelFormat := AFormat;
  ABitmap.SetSize(AWidth, AHeight);
end;

function cxCreateBitmap(const ASize: TSize; AFormat: TPixelFormat = pf24bit): TBitmap;
begin
  Result := cxCreateBitmap(ASize.cx, ASize.cy, AFormat);
end;

function cxCreateBitmap(const ARect: TRect; AFormat: TPixelFormat = pf24bit): TBitmap;
begin
  Result := cxCreateBitmap(ARect.Width, ARect.Height, AFormat);
end;

function cxCreateBitmap(AWidth, AHeight: Integer; AFormat: TPixelFormat = pf24bit): TBitmap;
begin
  Result := TBitmap.Create;
  cxSetBitmapParams(Result, AWidth, AHeight, AFormat);
end;

function cxCreateTrueColorBitmap(const ASize: TSize): TBitmap;
begin
  Result := cxCreateTrueColorBitmap(ASize.cx, ASize.cy);
end;

function cxCreateTrueColorBitmap(AWidth, AHeight: Integer): TBitmap;
begin
  Result := TBitmap.Create;
  Result.Handle := cxCreateTrueColorBitmapHandle(AWidth, AHeight);
end;

function cxCreateTrueColorBitmapHandle(AWidth, AHeight: Integer; ABPP: Integer = 32): HBitmap;
begin
  Result := CreateBitmap(AWidth, AHeight, 1, ABPP, nil);
end;

procedure cxDrawHatchRect(ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor; ADrawShadow: Boolean = True);
var
  I: Integer;
  AShadowRect: TRect;
begin
  if not IsRectEmpty(ARect) then
  begin
    ACanvas.SaveState;
    try
      ACanvas.SetClipRegion(TcxRegion.Create(ARect), roSet);
      ACanvas.FillRect(ARect, AColor);
      ACanvas.Pen.Color := dxGetDarkerColor(AColor, 75);
      for I := 1 to MulDiv(Max(ARect.Right, ARect.Bottom), 3, 2) do
        ACanvas.Polyline([Point(ARect.Right - I * 3, ARect.Top), Point(ARect.Right, ARect.Top + I * 3)]);
      ACanvas.FrameRect(ARect, dxGetDarkerColor(AColor, 50));
    finally
      ACanvas.RestoreState;
    end;
    ACanvas.ExcludeClipRect(ARect);
    if ADrawShadow then
    begin
      AShadowRect := cxRectOffset(ARect, 1, 1);
      ACanvas.FillRect(AShadowRect, clBtnShadow);
      ACanvas.ExcludeClipRect(AShadowRect);
    end;
  end;
end;

procedure cxDrawDesignRect(ACanvas: TcxCanvas; const ARect: TRect; ASelected, ADrawShadow: Boolean);
const
  Colors: array[Boolean] of TColor = ($A0FFA0, $9090FF);
begin
  cxDrawHatchRect(ACanvas, ARect, Colors[ASelected], ADrawShadow);
end;

procedure cxDrawBitmap(ADestDC: THandle; ASrcBitmap: TBitmap;
  const ADestRect: TRect; const ASrcPoint: TPoint; AMode: Integer = SRCCOPY);
begin
  TdxImageDrawer.DrawBitmap(ADestDC, ASrcBitmap, ADestRect, ASrcPoint, AMode);
end;

procedure cxDrawImage(ADC: THandle; AGlyphRect, ABackgroundRect: TRect; AGlyph: TGraphic; AImages: TCustomImageList;
  AImageIndex: Integer; ADrawMode: TcxImageDrawMode; ASmoothImage: Boolean = False; ABrush: THandle = 0;
  ATransparentColor: TColor = clNone; AUseLeftBottomPixelAsTransparent: Boolean = True; APalette: IdxColorPalette = nil);
begin
  TdxImageDrawer.DrawUncachedImage(ADC, AGlyphRect, ABackgroundRect, AGlyph, AImages, AImageIndex, ADrawMode, ASmoothImage,
    ABrush, ATransparentColor, AUseLeftBottomPixelAsTransparent, APalette);
end;

function cxCalculateImageSize(const ADrawRect: TdxRectF; const AImageSize: TdxSizeF; AFitMode: TcxImageFitMode): TdxSizeF;
var
  APrevPrecisionMode: TFPUPrecisionMode;
  ARectSize: TdxSizeF;
  K1, K2: Double;
begin
  if cxSizeIsEmpty(AImageSize) then
    Exit(AImageSize);

  APrevPrecisionMode := SetPrecisionMode(pmDouble);
  try
    ARectSize := ADrawRect.Size;
    K1 := ARectSize.cx / AImageSize.cx;
    K2 := ARectSize.cy / AImageSize.cy;
    case AFitMode of
      ifmStretch:
        Result := ARectSize;

      ifmProportionalStretch:
        if K1 < K2 then
          Result := dxSizeF(ARectSize.cx, AImageSize.cy * K1)
        else
          Result := dxSizeF(AImageSize.cx * K2, ARectSize.cy);

      ifmFill:
        if K1 > K2 then
          Result := dxSizeF(ARectSize.cx, AImageSize.cy * K1)
        else
          Result := dxSizeF(AImageSize.cx * K2, ARectSize.cy);

      ifmFit:
        if Min(K1, K2) >= 1 then
          Result := AImageSize
        else
          if K1 < K2 then
            Result := dxSizeF(ARectSize.cx, AImageSize.cy * K1)
          else
            Result := dxSizeF(AImageSize.cx * K2, ARectSize.cy);

    else // ifmNormal:
      Result := AImageSize;
    end;
  finally
    SetPrecisionMode(APrevPrecisionMode);
  end;
end;

function cxGetImageRect(const ADrawRect: TRect; const AImageSize: TSize;
  AFitMode: TcxImageFitMode; ACentre: Boolean = True; AScale: Integer = 100): TRect;
var
  AGlyphSize: TSize;
begin
  AGlyphSize := cxSize(cxCalculateImageSize(cxRectF(ADrawRect), dxSizeF(AImageSize), AFitMode), True);
  if (AFitMode = ifmNormal) and (AScale <> 100) then
    AGlyphSize := cxSizeScale(AGlyphSize, AScale, 100);
  if ACentre then
    Result := cxRectCenter(ADrawRect, AGlyphSize)
  else
    Result := cxRectBounds(ADrawRect.Left, ADrawRect.Top, AGlyphSize);
end;

function cxGetImageRect(const ADrawRect: TdxRectF; const AImageSize: TdxSizeF;
  AFitMode: TcxImageFitMode; ACentre: Boolean = True; AScale: Single = 100): TdxRectF;
var
  AGlyphSize: TdxSizeF;
begin
  AGlyphSize := cxCalculateImageSize(ADrawRect, AImageSize, AFitMode);
  if (AFitMode = ifmNormal) and (AScale <> 100) then
    AGlyphSize := cxSizeScale(AGlyphSize, AScale / 100);
  if ACentre then
    Result := cxRectCenter(ADrawRect, AGlyphSize)
  else
    Result := TdxRectF.Create(ADrawRect.Left, ADrawRect.Top, ADrawRect.Left + AGlyphSize.cx, ADrawRect.Top + AGlyphSize.cy);
end;

procedure cxDrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect; AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer;
  AFitMode: TcxImageFitMode; ADrawMode: TcxImageDrawMode = idmNormal; AUseLeftBottomPixelAsTransparent: Boolean = True;
  APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil; ASmoothImage: Boolean = False);
begin
  TdxImageDrawer.DrawImage(ACanvas, ARect, AGlyph, AImages, AImageIndex, AFitMode, ADrawMode, AUseLeftBottomPixelAsTransparent, APalette, AScaleFactor, ASmoothImage);
end;

procedure cxDrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect; AGlyph: TGraphic; AImages: TCustomImageList;
  AImageIndex: Integer; AEnabled: Boolean; APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil);
begin
  TdxImageDrawer.DrawImage(ACanvas, ARect, AGlyph, AImages, AImageIndex,
    ifmNormal, EnabledImageDrawModeMap[AEnabled], True, APalette, AScaleFactor);
end;

procedure cxDrawPicture(ACanvas: TcxCanvas; const ARect: TRect;
  APicture: TPicture; AFitMode: TcxImageFitMode; AScaleFactor: TdxScaleFactor = nil);
var
  APrevEvent: TNotifyEvent;
begin
  if (APicture <> nil) and (APicture.Graphic <> nil) then
  begin
    APrevEvent := APicture.OnChange;
    try
      APicture.OnChange := nil;
      if AScaleFactor = nil then
        AScaleFactor := dxDefaultScaleFactor;
      TdxImageDrawer.DrawImage(ACanvas, ARect, APicture.Graphic, nil, -1, AFitMode, idmNormal,
        (APicture.Graphic is TBitmap) and TBitmap(APicture.Graphic).Transparent, nil, AScaleFactor,
        cxSmoothDrawingNeeded(ARect, APicture.Graphic, AScaleFactor));
    finally
      APicture.OnChange := APrevEvent;
    end;
  end;
end;

procedure cxDrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect; AImage: TGraphic; AFitMode: TcxImageFitMode;
  APalette: IdxColorPalette = nil; AScaleFactor: TdxScaleFactor = nil; ASmoothResize: Boolean = False);
begin
  TdxImageDrawer.DrawImage(ACanvas, ARect, AImage, nil, -1, AFitMode, idmNormal,
    AImage.Transparent and not (AImage is TMetaFile), APalette, AScaleFactor, ASmoothResize);
end;

procedure cxDrawImageList(AImageListHandle: HIMAGELIST; AImageIndex: Integer;
  ADC: HDC; APoint: TPoint; ADrawingStyle: TDrawingStyle; AImageType: TImageType);
begin
  ImageList_Draw(AImageListHandle, AImageIndex, ADC, APoint.X, APoint.Y, cxGetImageListStyle(ADrawingStyle, AImageType));
end;

procedure cxDrawHatch(ADC: HDC; const ARect: TRect; AColor1, AColor2: TColor; AStep: Byte; AAlpha1: Byte = $FF; AAlpha2: Byte = $FF);
var
  ADrawBitmap: TcxAlphaBitmap;
begin
  ADrawBitmap := TcxAlphaBitmap.CreateSize(ARect);
  try
    cxBitBlt(ADrawBitmap.Canvas.Handle, ADC, ADrawBitmap.ClientRect, ARect.TopLeft, SRCCOPY);
    ADrawBitmap.DrawHatch(AColor1, AColor2, AStep, AAlpha1, AAlpha2);
    cxBitBlt(ADC, ADrawBitmap.Canvas.Handle, ARect, cxNullPoint, SRCCOPY);
  finally
    ADrawBitmap.Free;
  end;
end;

procedure cxDrawTransparencyCheckerboard(DC: HDC; const ARect: TRect; ACellSize: Integer);
begin
  cxDrawHatch(DC, ARect, $BFBFBF, clWhite, ACellSize)
end;

procedure cxDrawTransparencyCheckerboard(ACanvas: TcxCanvas; const ARect: TRect; ACellSize: Integer);
begin
  cxDrawTransparencyCheckerboard(ACanvas.Handle, ARect, ACellSize);
end;

procedure cxTransformImage(ABitmap: TBitmap; AMode: TcxBitmapTransformationMode);
var
  AAlphaBitmap: TcxAlphaBitmap;
begin
  if ABitmap is TcxAlphaBitmap then
    TcxAlphaBitmap(ABitmap).TransformBitmap(AMode)
  else
  begin
    AAlphaBitmap := TcxAlphaBitmap.Create;
    try
      AAlphaBitmap.Assign(ABitmap);
      AAlphaBitmap.TransformBitmap(AMode);
      ABitmap.Assign(AAlphaBitmap);
    finally
      AAlphaBitmap.Free;
    end;
  end;
end;

procedure cxTransformImage(AImage: TdxSmartImage; AMode: TcxBitmapTransformationMode);
var
  ABitmap: TBitmap;
begin
  ABitmap := AImage.GetAsBitmap;
  try
    cxTransformImage(ABitmap, AMode);
    AImage.SetBitmap(ABitmap);
  finally
    ABitmap.Free;
  end;
end;

function cxGetAsBitmap(AGraphic: TGraphic): TBitmap;
begin
  if AGraphic = nil then
    Result := nil
  else
    if AGraphic is TBitmap then
    begin
      Result := TcxBitmap.Create;
      Result.Assign(AGraphic);
    end
    else
      if AGraphic is TdxCustomSmartImage then
        Result := TdxCustomSmartImage(AGraphic).GetAsBitmap
      else
      begin
        Result := TcxBitmap32.CreateSize(AGraphic.Width, AGraphic.Height, True);
        Result.Canvas.Draw(0, 0, AGraphic);
      end;
end;

function cxPrepareBitmapForDrawing(AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer;
  AUseLeftBottomPixelAsTransparent: Boolean; ATransparentColor: TColor; APalette: IdxColorPalette = nil;
  AGlyphWidth: Integer = 0; AGlyphHeight: Integer = 0): TcxAlphaBitmap;
var
  AIsAlphaUsed: Boolean;
  AMask: TcxAlphaBitmap;
begin
  Result := cxPrepareBitmapForDrawing(AGlyph, AImages, AImageIndex,
    AUseLeftBottomPixelAsTransparent, ATransparentColor,
    APalette, AGlyphWidth, AGlyphHeight, True, AMask, AIsAlphaUsed);
end;

function cxPrepareBitmapForDrawing(AGlyph: TGraphic; AImages: TCustomImageList; AImageIndex: Integer;
  AUseLeftBottomPixelAsTransparent: Boolean; ATransparentColor: TColor; APalette: IdxColorPalette;
  AGlyphWidth: Integer; AGlyphHeight: Integer; ASmoothResize: Boolean;
  out AMaskBitmap: TcxAlphaBitmap; out AIsAlphaUsed: Boolean): TcxAlphaBitmap; overload;

  procedure CheckGlyphSize(var AWidth, AHeight: Integer);
  var
    ASizeIsEmpty: Boolean;
  begin
    ASizeIsEmpty := (AWidth = 0) or (AHeight = 0);
    if IsGlyphAssigned(AGlyph) then
    begin
      if ASizeIsEmpty then
      begin
        AHeight := AGlyph.Height;
        AWidth := AGlyph.Width;
      end;
    end
    else
      if (AImages <> nil) and (ASizeIsEmpty or not (AImages is TcxCustomImageList)) then
      begin
        AHeight := AImages.Height;
        AWidth := AImages.Width;
      end;
  end;

  procedure MakeImage(AImageBitmap: TcxAlphaBitmap; out AIsAlphaUsed: Boolean);
  var
    AHasAlpha: TdxDefaultBoolean;
  begin
    AHasAlpha := bDefault;
    if IsGlyphAssigned(AGlyph) then
    begin
      cxStretchGraphic(AImageBitmap, AGlyph, ASmoothResize, APalette);
      if TcxImageInfoHelper.GetPixelFormat(AGlyph) <> pf32bit then
        AHasAlpha := bFalse;
    end
    else
    begin
      if TcxImageList.GetPixelFormat(AImages.Handle) < 32 then
        AHasAlpha := bFalse;
      TcxImageListAccess.GetImageInfoCore(AImages, AImageIndex, AImageBitmap, nil, APalette, AHasAlpha);
    end;
    if AHasAlpha = bDefault then
      AHasAlpha := dxBooleanToDefaultBoolean(AImageBitmap.IsAlphaUsed);
    AIsAlphaUsed := AHasAlpha = bTrue;
    if not AIsAlphaUsed then
      AImageBitmap.TransformBitmap(btmSetOpaque);
  end;

  function IsMaskNeeded(AIsAlphaUsed: Boolean): Boolean;
  begin
    Result := not AIsAlphaUsed or AUseLeftBottomPixelAsTransparent and IsGlyphAssigned(AGlyph) and
      (AGlyph is TdxSmartGlyph) and not TdxSmartGlyphAccess(AGlyph).FTransparent and
      (TdxSmartGlyphAccess(AGlyph).AlphaState = asOpaque);
  end;

  function MakeMask(AImageBitmap, AMaskBitmap: TcxAlphaBitmap; AIsAlphaUsed: Boolean): TcxAlphaBitmap;
  var
    AImageListMask: TcxAlphaBitmap;
  begin
    if IsMaskNeeded(AIsAlphaUsed) then
    begin
      Result := GetMaskBitmap(AGlyphWidth, AGlyphHeight);
      Result.CopyBitmap(AImageBitmap);
      if not IsGlyphAssigned(AGlyph) then
      begin
        AImageListMask := TcxAlphaBitmap.CreateSize(Result.ClientRect);
        try
          TcxImageList.GetImageInfo(AImages, AImageIndex, nil, AImageListMask);
          AImageListMask.TransformBitmap(btmCorrectBlend);
          Result.Filter(AImageListMask);
        finally
          AImageListMask.Free;
        end;
      end;
      if cxColorIsValid(ATransparentColor) then
        Result.TransparentPixels.Add(ATransparentColor);
      if AUseLeftBottomPixelAsTransparent and IsGlyphAssigned(AGlyph) then
        Result.TransparentPixels.Add(Result.TransparentColor);
      Result.TransformBitmap(btmMakeMask);
    end
    else
      Result := nil;
  end;

begin
  CheckGlyphSize(AGlyphWidth, AGlyphHeight);
  Result := GetImageBitmap(AGlyphWidth, AGlyphHeight);
  MakeImage(Result, AIsAlphaUsed);

  AMaskBitmap := MakeMask(Result, AMaskBitmap, AIsAlphaUsed);
  if AMaskBitmap <> nil then
    Result.Filter(AMaskBitmap);
end;

function cxSmoothDrawingNeeded(const ADest: TRect; AGraphic: TGraphic; AScaleFactor: TdxScaleFactor): Boolean;
var
  ASize: TSize;
begin
  ASize := dxGetImageSize(AGraphic, AScaleFactor);
  Result := cxRectSquare(ADest) < ASize.cx * ASize.cy;
end;

procedure cxSmoothResizeBitmap(ASource, ADestination: TBitmap; AForceUseLanczos3Filter: Boolean = False);
var
  ADestHeight: Integer;
  ADestWidth: Integer;
  AOldMode: Cardinal;
  ASrcHeight: Integer;
  ASrcWidth: Integer;
begin
  ADestWidth := ADestination.Width;
  ADestHeight := ADestination.Height;
  ASrcWidth := ASource.Width;
  ASrcHeight := ASource.Height;
  if (ADestWidth = 0) or (ADestHeight = 0) or (ASrcWidth = 0) or (ASrcHeight = 0) then Exit;
  ASource.Canvas.Lock;
  ADestination.Canvas.Lock;
  try
    if IsWinNT and not AForceUseLanczos3Filter then
    begin
      AOldMode := SetStretchBltMode(ADestination.Canvas.Handle, HALFTONE);
      StretchBlt(ADestination.Canvas.Handle, 0, 0, ADestWidth, ADestHeight, ASource.Canvas.Handle, 0, 0, ASrcWidth, ASrcHeight, srcCopy);
      SetStretchBltMode(ADestination.Canvas.Handle, AOldMode);
    end
    else
      TdxColors.SmoothResize(ASource, ADestination, TdxColors.FilterLanczos3);
  finally
    ADestination.Canvas.Unlock;
    ASource.Canvas.Unlock;
  end;
end;

procedure cxStretchBlt(ADestDC, ASrcDC: HDC; const ADestRect, ASrcRect: TRect; ROP: DWORD);
begin
  StretchBlt(ADestDC, ADestRect.Left, ADestRect.Top,
    ADestRect.Right - ADestRect.Left, ADestRect.Bottom - ADestRect.Top,
    ASrcDC, ASrcRect.Left, ASrcRect.Top, ASrcRect.Right - ASrcRect.Left,
    ASrcRect.Bottom - ASrcRect.Top, ROP);
end;

procedure cxStretchGraphic(ADestination: TBitmap; ASource: TGraphic; ASmoothStretch: Boolean; APalette: IdxColorPalette);
begin
  cxStretchGraphic(ADestination, ASource, cxGetImageClientRect(ADestination), cxGetImageClientRect(ASource), ASmoothStretch, APalette);
end;

procedure cxStretchGraphic(ADestination: TBitmap; ASource: TGraphic;
  const ADestRect, ASourceRect: TRect; ASmoothStretch: Boolean; APalette: IdxColorPalette);

  procedure StretchBitmap(ASource: TBitmap);
  var
    ATempDst: TcxBitmap32;
    ATempSrc: TcxBitmap32;
  begin
    if cxSizeIsEqual(ADestRect, ASourceRect) then
      cxBitBlt(ADestination.Canvas.Handle, ASource.Canvas.Handle, ADestRect, ASourceRect.TopLeft, SRCCOPY)
    else
      if ASmoothStretch then
      begin
        if cxRectIsEqual(ADestRect, cxGetImageClientRect(ADestination)) and cxRectIsEqual(ASourceRect, cxGetImageClientRect(ASource)) then
          cxSmoothResizeBitmap(ASource, ADestination, True)
        else
        begin
          ATempDst := TcxBitmap32.CreateSize(ADestRect);
          ATempSrc := TcxBitmap32.CreateSize(ASourceRect);
          try
            ATempSrc.CopyBitmap(ASource, ATempSrc.ClientRect, ASourceRect.TopLeft);
            cxSmoothResizeBitmap(ATempSrc, ATempDst, True);
            cxBitBlt(ADestination.Canvas.Handle, ATempDst.Canvas.Handle, ADestRect, cxNullPoint, SRCCOPY);
          finally
            ATempSrc.Free;
            ATempDst.Free;
          end;
        end;
      end
      else
        cxStretchBlt(ADestination.Canvas.Handle, ASource.Canvas.Handle, ADestRect, ASourceRect, SRCCOPY);
  end;

var
  AGraphics: TdxGPGraphics;
  ATempBitmap: TBitmap;
begin

  cxClearBitmap(ADestination);
  if ASource is TBitmap then
    StretchBitmap(TBitmap(ASource))
  else

  if ASource is TdxSmartImage then
  begin
    AGraphics := dxGpBeginPaint(ADestination.Canvas.Handle, ADestRect);
    try
      AGraphics.InterpolationMode := dxGpSmoothStretchModeMap[ASmoothStretch];
      AGraphics.PixelOffsetMode := PixelOffsetModeHalf;
      TdxSmartImage(ASource).StretchDraw(AGraphics, ADestRect, ASourceRect, nil, APalette);
    finally
      dxGpEndPaint(AGraphics);
    end;
  end
  else

  if ASource is TdxCustomSmartImage then
    TdxCustomSmartImage(ASource).StretchDraw(ADestination.Canvas.Handle, ADestRect, ASourceRect, MaxByte, APalette)
  else
  begin
    ATempBitmap := cxGetAsBitmap(ASource);
    try
      StretchBitmap(ATempBitmap);
    finally
      ATempBitmap.Free;
    end;
  end;

  ADestination.Modified := True;
end;

function cxCreateBitmapCopy(ASourceBitmap: TBitmap): TcxAlphaBitmap;
begin
  Result := TcxAlphaBitmap.CreateSize(ASourceBitmap.Width, ASourceBitmap.Height);
  Result.CopyBitmap(ASourceBitmap);
end;

procedure cxMakeColoredBitmap(ABitmap: TBitmap; AColor: TColor);

  procedure CalculateValue(var AValue: Byte; AColorValue, AAlpha: Byte);
  var
    ATemp: Integer;
  begin
    AValue := AValue * 255 div AAlpha;
    ATemp := (AValue - 128) * (AValue - 128);
    if AValue < 128 then
      AValue := AColorValue - AColorValue * ATemp div 16384
    else
      AValue := AColorValue + (255 - AColorValue) * ATemp div 16384;
    AValue := AValue * AAlpha div 255
  end;

var
  AColors: TRGBColors;
  AColorValue: TRGBQuad;
  APixel: PRGBQuad;
  I: Integer;
begin
  AColorValue := dxColorToRGBQuad(AColor);

  if GetBitmapBits(ABitmap, AColors, True) then
  begin
    APixel := @AColors[0];
    for I := 0 to Length(AColors) - 1 do
    begin
      if APixel^.rgbReserved > 0 then
      begin
        CalculateValue(APixel^.rgbRed, AColorValue.rgbRed, APixel^.rgbReserved);
        CalculateValue(APixel^.rgbGreen, AColorValue.rgbGreen, APixel^.rgbReserved);
        CalculateValue(APixel^.rgbBlue, AColorValue.rgbBlue, APixel^.rgbReserved);
      end;
      Inc(APixel);
    end;
    SetBitmapBits(ABitmap, AColors, True);
  end;
end;

procedure cxMakeTrueColorBitmap(ASourceBitmap, ATrueColorBitmap: TBitmap);
var
  AcxBitmap, AcxMask: TcxAlphaBitmap;
begin
  AcxBitmap := cxCreateBitmapCopy(ASourceBitmap);
  try
    AcxBitmap.TransformBitmap(btmSetOpaque);
    AcxMask := cxCreateBitmapCopy(ASourceBitmap);
    try
      AcxMask.TransparentPixels.Add(ASourceBitmap.TransparentColor);
      AcxMask.TransformBitmap(btmMakeMask);
      AcxBitmap.Filter(AcxMask);
      ATrueColorBitmap.Assign(AcxBitmap);
    finally
      AcxMask.Free;
    end;
  finally
    AcxBitmap.Free;
  end;
end;

procedure cxMakeMaskBitmap(ASourceBitmap, AMaskBitmap: TBitmap);
var
  ABitmap: TcxAlphaBitmap;
begin
  ABitmap := cxCreateBitmapCopy(ASourceBitmap);
  try
    if not ABitmap.IsAlphaUsed then
      ABitmap.RecoverAlphaChannel(ASourceBitmap.TransparentColor);
    ABitmap.TransformBitmap(btmMakeMask);
    cxBitBlt(AMaskBitmap.Canvas.Handle, ABitmap.Canvas.Handle, ABitmap.ClientRect, cxNullPoint, SRCCOPY);
  finally
    ABitmap.Free;
  end;
end;

function FindScanline(Source: Pointer; MaxLen: Cardinal;
  Value: Cardinal): Cardinal; assembler;
asm
{$IF Defined(CPUX64)}
    PUSH    R8
    MOV     R8,RDI
    MOV     RDI,Source
    MOV     RCX, RDX
    POP     RAX
    REPE    SCASB
    MOV     RAX,RCX
    MOV     RDI,R8
{$ELSE}
    PUSH    ECX
    MOV     ECX,EDX
    MOV     EDX,EDI
    MOV     EDI,Source
    POP     EAX
    REPE    SCASB
    MOV     EAX,ECX
    MOV     EDI,EDX
{$IFEND}
end;

function cxGetCursorSize: TSize;
var
  IconInfo: TIconInfo;
  BitmapInfoSize, BitmapBitsSize, ImageSize: DWORD;
  Bitmap: PBitmapInfoHeader;
  Bits: Pointer;
  BytesPerScanline: Integer;

begin
  { Default value is entire icon height }
  Result.cy := GetSystemMetrics(SM_CYCURSOR);
  Result.cx := GetSystemMetrics(SM_CXCURSOR);

  if GetIconInfo(GetCursor, IconInfo) then
  try
    GetDIBSizes(IconInfo.hbmMask, BitmapInfoSize, BitmapBitsSize);
    Bitmap := AllocMem(TdxNativeUInt(BitmapInfoSize) + BitmapBitsSize);
    try
    Bits := Pointer(TdxNativeUInt(Bitmap) + BitmapInfoSize);
    if GetDIB(IconInfo.hbmMask, 0, Bitmap^, Bits^) and
      (Bitmap^.biBitCount = 1) then
    begin
      { Point Bits to the end of this bottom-up bitmap }
      with Bitmap^ do
      begin
        Result.cx := biWidth;
        BytesPerScanline := ((biWidth * biBitCount + 31) and not 31) div 8;
        ImageSize := biWidth * BytesPerScanline;
        Bits := Pointer(TdxNativeUInt(Bits) + BitmapBitsSize - ImageSize);
        { Use the width to determine the height since another mask bitmap
          may immediately follow }
        Result.cy := FindScanline(Bits, ImageSize, $FF);
        { In case the and mask is blank, look for an empty scanline in the
          xor mask. }
        if (Result.cy = 0) and (biHeight >= 2 * biWidth) then
          Result.cy := FindScanline(Pointer(TdxNativeUInt(Bits) - ImageSize),
          ImageSize, $00);
        Result.cy := Result.cy div BytesPerScanline;
      end;
      Dec(Result.cy, IconInfo.yHotSpot);
    end;
    finally
      FreeMem(Bitmap);
    end;
  finally
    if IconInfo.hbmColor <> 0 then DeleteObject(IconInfo.hbmColor);
    if IconInfo.hbmMask <> 0 then DeleteObject(IconInfo.hbmMask);
  end;
end;

procedure cxAlphaBlend(ASource: TBitmap; ARect: TRect;
  const ASelColor: TColor; Alpha: Byte = 170);
var
  ARow, ACol: Integer;
  SrcLine: Pointer;
  C1, C2: Double;
  AColorValues: array[0..3] of Byte;
  P: TPoint;
begin
  C1 := Alpha / 255;
  C2 := 1.0 - C1;
  AColorValues[0] := Round(GetBValue(ASelColor) * C1);
  AColorValues[1] := Round(GetGValue(ASelColor) * C1);
  AColorValues[2] := Round(GetRValue(ASelColor) * C1);
  AColorValues[3] := 0;
  GetWindowOrgEx(ASource.Canvas.Handle, P);
  OffsetRect(ARect, -P.X, -P.Y);
  for ARow := Max(ARect.Top, 0) to Min(ARect.Bottom, ASource.Height - 1) do
  begin
    SrcLine := ASource.ScanLine[ARow];
    ACol := Max(0, ARect.Left * 4);
    while ACol < Min(ARect.Right * 4, ASource.Width * 4 - 1) do
    begin
      WriteByte(SrcLine, AColorValues[ACol mod 4] + Round(ReadByte(SrcLine, ACol) * C2), ACol);
      Inc(ACol);
    end;
  end;
end;

procedure cxAlphaBlend(
  ADest, ABkSource, ASource: TBitmap; Alpha: Byte = cxDefaultAlphaValue);

  function SystemAlphaPaint: Boolean;
  var
    ABlendFunction: TBlendFunction;
  begin
    if CanApplySystemAlphaBlending then
    begin
      ABlendFunction := DefaultBlendFunction;
      ABlendFunction.SourceConstantAlpha := Alpha;
      with ADest do
      begin
        Canvas.Draw(0, 0, ABkSource); //      Assign(ABkSource); todo: graphics bug image not copying but _AddRef called
        Result := VCLAlphaBlend(Canvas.Handle,
          0, 0, Width, Height, ASource.Canvas.Handle, 0, 0, Width, Height, ABlendFunction);
      end;
    end
    else
      Result := False;
  end;

  procedure AlphaPaint;
  var
    ACount, K: Integer;
    DstLine, BkSrcLine, SrcLine: Pointer;
    C1, C2: Double;
  begin
    C1 := Alpha / 255;
    C2 := 1.0 - C1;
    with ASource do
    begin
      K := Height;
      ACount := ((Width * 24 + 31) and not 31) shr 3 * K;
    end;
    BkSrcLine := ABkSource.ScanLine[K - 1];
    SrcLine := ASource.ScanLine[K - 1];
    DstLine := ADest.ScanLine[K - 1];
    for K := 0 to ACount - 1 do
      WriteByte(DstLine,
        Round(ReadByte(SrcLine, K) * C1) + Round(ReadByte(BkSrcLine, K) * C2), K);
  end;

  procedure DoAlphaPaint;
  begin
    if GetDeviceCaps(cxScreenCanvas.Handle, BITSPIXEL) in [16, 24, 32] then
      AlphaPaint
    else
      ADest.Canvas.Draw(0, 0, ASource); // .Assign(ASource);
    cxScreenCanvas.Dormant;
  end;

begin
  if not SystemAlphaPaint then DoAlphaPaint;
end;

procedure cxApplyViewParams(ACanvas: TcxCanvas;
  const AViewParams: TcxViewParams);
begin
  with ACanvas do
  begin
    Font := AViewParams.Font;
    Font.Color := AViewParams.TextColor;
    Brush.Color := AViewParams.Color;
  end;
end;

procedure cxCopyImage(ASource, ADest: TBitmap; const ASrcOffset, ADstOffset: TPoint; const ARect: TRect);
var
  ADstRect, ASrcRect: TRect;
begin
  ADstRect := ARect;
  ASrcRect := ARect;
  OffsetRect(ASrcRect, ASrcOffset.X, ASrcOffset.Y);
  OffsetRect(ADstRect, ADstOffset.X, ADstOffset.Y);
  ADest.Canvas.CopyRect(ASrcRect, ASource.Canvas, ADstRect);
end;

procedure cxCopyImage(ASource, ADest: TCanvas; const ASrcOffset, ADstOffset: TPoint; const ARect: TRect);
var
  ADstRect, ASrcRect: TRect;
begin
  ADstRect := ARect;
  ASrcRect := ARect;
  OffsetRect(ASrcRect, ASrcOffset.X, ASrcOffset.Y);
  OffsetRect(ADstRect, ADstOffset.X, ADstOffset.Y);
  ADest.CopyRect(ADstRect, ASource, ASrcRect);
end;

function cxCopyImage(ASrcHandle: HBITMAP): HBITMAP; overload;

  function SystemCopyImage: HBITMAP;
  begin
    Result := CopyImage(ASrcHandle, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION);
  end;

  function SoftwareCopyImage: HBITMAP;
  var
    ABitmapData: Windows.TBitmap;
    ABitmapInfo: TBitmapInfo;
    ADestinationBits: Pointer;
    ABits: TBytes;
  begin
    cxGetBitmapData(ASrcHandle, ABitmapData);
    if ABitmapData.bmBitsPixel = 32 then
    begin
      dxFillBitmapInfoHeader(ABitmapInfo.bmiHeader, ABitmapData.bmWidth, ABitmapData.bmHeight, False);
      if ABitmapData.bmBits = nil then
      begin
        SetLength(ABits, ABitmapData.bmWidth * ABitmapData.bmHeight * 4);
        GetDIBits(cxScreenCanvas.Handle, ASrcHandle, 0, ABitmapData.bmHeight, ABits, ABitmapInfo, 0);
        cxScreenCanvas.Dormant;
        ABitmapData.bmBits := ABits;
      end;
      Result := CreateDIBSection(0, ABitmapInfo, DIB_RGB_COLORS, ADestinationBits, 0, 0);
      cxCopyData(ABitmapData.bmBits, ADestinationBits, ABitmapData.bmWidth * ABitmapData.bmHeight * 4);
    end
    else
      Result := SystemCopyImage;
  end;

begin
  if IsWin9X then
    Result := SoftwareCopyImage
  else
    Result := SystemCopyImage;
end;

procedure cxClearBitmap(ABitmap: TBitmap);
begin
  FillRect(ABitmap.Canvas.Handle, cxGetImageClientRect(ABitmap), GetStockObject(BLACK_BRUSH));
end;

procedure cxFillHalfToneRect(Canvas: TCanvas; const ARect: TRect; ABkColor, AColor: TColor);
begin
  cxFillRectWithCustomBrush(Canvas, cxHalfToneBrush, ARect, ABkColor, AColor);
end;

procedure cxFillRectWithCustomBrush(ACanvas: TCanvas; ABrush: TBrush;
  const ARect: TRect; ABkColor, AColor: TColor; ATransparentBackground: Boolean = False);

  procedure DoFillRect(ACanvas: TCanvas; const ARect: TRect; const AOrigin: TPoint);
  var
    APrevOrigin: TPoint;
  begin
    ABkColor := SetBkColor(ACanvas.Handle, ColorToRgb(ABkColor));
    AColor := SetTextColor(ACanvas.Handle, ColorToRgb(AColor));
    SetBrushOrgEx(ACanvas.Handle, -AOrigin.X, -AOrigin.Y, @APrevOrigin);
    Windows.FillRect(ACanvas.Handle, ARect, ABrush.Handle);
    SetBrushOrgEx(ACanvas.Handle, APrevOrigin.X, APrevOrigin.Y, nil);
    ABkColor := SetBkColor(ACanvas.Handle, ABkColor);
    AColor := SetTextColor(ACanvas.Handle, AColor);
  end;

var
  ABitmap: TcxBitmap;
  AOrigin: TPoint;
begin
  if ATransparentBackground then
  begin
    ABitmap := TcxBitmap.CreateSize(ARect);
    try
      ABitmap.cxCanvas.WindowOrg := ARect.TopLeft;
      GetWindowOrgEx(ACanvas.Handle, AOrigin);
      DoFillRect(ABitmap.Canvas, ARect, cxPointOffset(AOrigin, ARect.TopLeft));
      ABitmap.Transparent := True;
      ABitmap.TransparentColor := ABkColor;
      ACanvas.Draw(ARect.Left, ARect.Top, ABitmap);
    finally
      ABitmap.Free;
    end;
  end
  else
  begin
    GetBrushOrgEx(ACanvas.Handle, AOrigin);
    DoFillRect(ACanvas, ARect, AOrigin);
  end;
end;

function cxGetTextExtentPoint32(ADC: THandle; const AText: string; out ASize: TSize; ACharCount: Integer = -1): Boolean;
begin
  ASize := cxNullSize;
  if ACharCount = -1 then
    ACharCount := Length(AText);
  Result := GetTextExtentPoint32(ADC, PChar(AText), ACharCount, ASize);
end;

{TODO:
procedure cxGetTextLines(const AText: string; ACanvas: TcxCanvas;
  const ARect: TRect; ALines: TStrings);
var
  ATextRows: TcxTextRows;
  ATextParams: TcxTextParams;
  I, ACount, ALen: Integer;
  S: WideString;
begin
  ATextParams := cxCalcTextParams(ACanvas.Handle, CXTO_WORDBREAK or CXTO_CALCROWCOUNT);
  cxMakeTextRows(ACanvas.Handle, PChar(AText), Length(AText), ARect, ATextParams, ATextRows, ACount);
  for I := 0 to ACount - 1 do
  begin
    ALen := cxGetTextRow(ATextRows, I).TextLength;
    SetString(S, cxGetTextRow(ATextRows, I).Text, ALen);
    if (ALen > 0) and ((S[ALen] = ' ') or (S[ALen] = #9)) then
      SetLength(S, ALen - 1);
    ALines.Add(S);
  end;
  cxResetTextRows(ATextRows);
end;
}

type
  TcxWordPosition = record
    Start: Integer;
    Finish: Integer;
  end;

procedure cxGetTextLines(const AText: string; ACanvas: TcxCanvas; const ARect: TRect; ALines: TStrings);

  function IsNewLineSymbol(const S: string; AIndex: Integer): Boolean;
  begin
    Result := (S[AIndex] = #13) or (S[AIndex] = #10);
  end;

  procedure GetNextWordPos(const S: string; ALength: Integer; const ACurrentWord: TcxWordPosition; var ANextWord: TcxWordPosition);

    function IsDelimiter(AIndex: Integer): Boolean;
    begin
      Result := (S[AIndex] = ' ') or (S[AIndex] = #9) or
        IsNewLineSymbol(S, AIndex);
    end;

    function IsDoubleDelimiter(AIndex: Integer): Boolean;
    begin
      Result := (AIndex > 1) and IsDelimiter(AIndex) and IsDelimiter(AIndex - 1);
    end;

    function IsWordStart(AIndex: Integer): Boolean;
    begin
      Result := not IsDelimiter(AIndex);
    end;

    function IsWordEnd(AIndex: Integer): Boolean;
    begin
      Result := IsDelimiter(AIndex);
    end;

  var
    ACharPos: Integer;
  begin
    ANextWord.Start := ACurrentWord.Finish + 1;

    while (ANextWord.Start < ALength) and not IsWordStart(ANextWord.Start) and not IsDoubleDelimiter(ANextWord.Start) do
      Inc(ANextWord.Start);
    ACharPos := ANextWord.Start;
    while (ACharPos + 1 <= ALength) and not IsWordEnd(ACharPos + 1) and not IsDoubleDelimiter(ACharPos) do
      Inc(ACharPos);
    ANextWord.Finish := ACharPos;
  end;

  procedure FindNextWordStart(const S: string; var ACharIndex: Integer; var ANextWord: TcxWordPosition);
  var
    I, ALineBreakCount: Integer;
  begin
    ALineBreakCount := 0;
    while (ACharIndex <= Length(S)) do
    begin
      if S[ACharIndex] = #13 then
        Inc(ACharIndex)
      else
        if S[ACharIndex] = #10 then
        begin
          Inc(ACharIndex);
          Inc(ALineBreakCount);
        end
        else
          Break;
    end;

    if ACharIndex > Length(S) then
      for I := 0 to ALineBreakCount - 1 do
        ALines.Add('')
    else
      for I := 0 to ALineBreakCount - 2 do
        ALines.Add('');

    ANextWord.Start := ACharIndex;
  end;

  function CheckNewLineSymbol(const S: string; var ANextWord: TcxWordPosition; var ALineStartIndex: Integer): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := ALineStartIndex to ANextWord.Finish do
      if IsNewLineSymbol(S, I) then
      begin
        ALines.Add(Copy(S, ALineStartIndex, I - ALineStartIndex));
        ALineStartIndex := I;
        FindNextWordStart(S, ALineStartIndex, ANextWord);
        Result := True;
        Break;
      end;
  end;

var
  ADrawText: string;
  ACurrentWord, ANextWord: TcxWordPosition;
  ALineStart, ALength, ARectWidth: Integer;
begin
  ALength := Length(AText);
  if ALength = 0 then
    Exit;
  ARectWidth := ARect.Width;
  ACurrentWord.Finish := 0;
  ALineStart := 1;
  repeat
    GetNextWordPos(AText, ALength, ACurrentWord, ANextWord);

    ADrawText := Copy(AText, ALineStart, ANextWord.Finish - ALineStart + 1);
    if not CheckNewLineSymbol(AText, ANextWord, ALineStart) then
      if cxTextSize(ACanvas.Handle, ADrawText).cx > ARectWidth then
      begin
        if ACurrentWord.Finish > 0 then
        begin
          ALines.Add(Copy(AText, ALineStart, ACurrentWord.Finish - ALineStart + 1));
          ALineStart := ANextWord.Start;
        end;
        FindNextWordStart(AText, ALineStart, ANextWord);
      end;
    ACurrentWord := ANextWord;
  until ACurrentWord.Finish >= ALength;
  if ALineStart <= ALength then
    ALines.Add(Copy(AText, ALineStart, ALength));
end;

function cxDrawText(ADC: THandle; const AText: string; var ARect: TRect;
  AFormat: UINT; ACharCount: Integer = - 1; ATextColor: TColor = clDefault; ABkMode: Integer = TRANSPARENT): Integer;
var
  APrevColor, APrevBkMode: Cardinal;
begin
  if ACharCount = -1 then
    ACharCount := Length(AText);
  if ACharCount = 0 then
  begin
    Result := Windows.DrawText(ADC, PChar(AText), 0, ARect, AFormat);
    Exit;
  end;
  if ATextColor <> clDefault then
    APrevColor := SetTextColor(ADC, ColorToRGB(ATextColor))
  else
    APrevColor := 0; // to make compiler happy
  APrevBkMode := SetBkMode(ADC, ABkMode);
  Result := Windows.DrawText(ADC, PChar(AText), ACharCount, ARect, AFormat);

  SetBkMode(ADC, APrevBkMode);
  if ATextColor <> clDefault then
    SetTextColor(ADC, APrevColor);
end;

function cxDrawText(ACanvas: TCanvas; const AText: string; ARect: TRect;
  AFormat: UINT; ATextColor: TColor = clDefault): Integer;
begin
  if ACanvas.TextFlags and ETO_RTLREADING <> 0 then
    AFormat := AFormat or DT_RTLREADING;
  Result := cxDrawText(ACanvas.Handle, AText, ARect, AFormat, -1, ATextColor);
end;

function cxDrawText(ACanvas: TcxCanvas; const AText: string; const ARect: TRect;
  AFormat: UINT; ATextColor: TColor = clDefault; ARotationAngle: TcxRotationAngle = ra0): Integer;
var
  ABitmap: TcxBitmap;
begin
  if ARotationAngle = ra0 then
    Result := cxDrawText(ACanvas.Canvas, AText, ARect, AFormat, ATextColor)
  else
  begin
    ABitmap := TcxBitmap.CreateSize(ARect, pf32bit);
    try
      cxBitBlt(ABitmap.Canvas.Handle, ACanvas.Handle, ABitmap.ClientRect, ARect.TopLeft, SRCCOPY);
      ABitmap.Rotate(cxOppositeRotationAngle[ARotationAngle]);
      ABitmap.Canvas.Font.Assign(ACanvas.Font);
      ABitmap.Canvas.TextFlags := ACanvas.Canvas.TextFlags;
      if not dxUseAntialiasingForRotatedText then
        dxSetFontAsNonAntialiased(ABitmap.Canvas.Font);
      Result := cxDrawText(ABitmap.Canvas, AText, ABitmap.ClientRect, AFormat, ATextColor);

      ABitmap.Rotate(ARotationAngle);
      cxBitBlt(ACanvas.Handle, ABitmap.Canvas.Handle, ARect, cxNullPoint, SRCCOPY);
    finally
      ABitmap.Free;
    end;
  end;
end;

function cxDrawMultilineText(ACanvas: TcxCanvas; const AText: string;
  const ARect: TRect; AFormat: UINT; ATextColor: TColor = clDefault): Integer;
var
  ALineHeight: Integer;
  ALineRect: TRect;
  ALines: TStrings;
  AOffset: Integer;
  I: Integer;
begin
  ALines := TStringList.Create;
  try
    cxGetTextLines(AText, ACanvas, ARect, ALines);
    Result := ALines.Count;
    ALineHeight := cxTextHeight(ACanvas.Handle);

    if AFormat and DT_VCENTER = DT_VCENTER then
      AOffset := Max(ARect.Top, cxRectCenterVertically(ARect, ALineHeight * Result).Top)
    else
      if AFormat and DT_BOTTOM = DT_BOTTOM then
        AOffset := Max(ARect.Top, ARect.Bottom - ALineHeight * Result)
      else
        AOffset := ARect.Top;

    ALineRect := cxRectSetTop(ARect, AOffset, ALineHeight);
    if ACanvas.Canvas.TextFlags and ETO_RTLREADING <> 0 then
      AFormat := AFormat or DT_RTLREADING;
    for I := 0 to ALines.Count - 1 do
    begin
      cxDrawText(ACanvas.Handle, ALines[I], ALineRect, AFormat or DT_SINGLELINE, -1, ATextColor);
      OffsetRect(ALineRect, 0, ALineHeight);
    end;
  finally
    ALines.Free;
  end;
end;

function cxDrawMultilineText(ACanvas: TcxCanvas; const AText: string; const ARect: TRect;
  ATextAlignHorz: TAlignment = taLeftJustify; ATextAlignVert: TcxAlignmentVert = vaTop;
  ATextColor: TColor = clDefault): Integer;
const
  TextAlignHorzMap: array[TAlignment] of Integer = (DT_LEFT, DT_RIGHT, DT_CENTER);
  TextAlignVertMap: array[TcxAlignmentVert] of Integer = (DT_TOP, DT_BOTTOM, DT_VCENTER);
begin
  Result := cxDrawMultilineText(ACanvas, AText, ARect,
    TextAlignHorzMap[ATextAlignHorz] or TextAlignVertMap[ATextAlignVert], ATextColor);
end;

function cxExtTextOut(ADC: THandle; const AText: string; const APoint: TPoint;
  const ARect: TRect; AOptions: UINT; ACharCount: Integer = -1): Boolean;
begin
 if ACharCount = -1 then
   ACharCount := Length(AText);
  Result := ExtTextOut(ADC, APoint.X, APoint.Y, AOptions,
    @ARect, PChar(AText), ACharCount, nil);
end;

function cxExtTextOut(ADC: THandle; const AText: string; const APoint: TPoint;
  AOptions: UINT; ACharCount: Integer = -1): Boolean; overload;
begin
 if ACharCount = -1 then
   ACharCount := Length(AText);
  Result := ExtTextOut(ADC, APoint.X, APoint.Y, AOptions,
    nil, PChar(AText), ACharCount, nil);
end;


function cxTextHeight(ADC: THandle): Integer;
begin
  Result := TdxTextMeasurer.TextLineHeight(ADC);
end;

function cxTextHeight(AFont: TFont): Integer;
begin
  Result := TdxTextMeasurer.TextLineHeight(AFont);
end;

function cxTextHeight(AFont: TFont; const S: string; ARect: TRect; AFlags: Integer): Integer;
begin
  Result := TdxTextMeasurer.TextHeightDT(AFont, S, ARect, AFlags);
end;

function cxTextExtent(AFontHandle: THandle; const S: string): TSize;
begin
  Result := TdxTextMeasurer.TextSizeTO(AFontHandle, S);
end;

function cxTextHeight(AFont: TFont; const S: string; AFontSize: Integer = 0): Integer;
begin
  Result := TdxTextMeasurer.TextHeightTO(AFont, S, AFontSize);
end;

function cxTextWidth(AFont: TFont; const S: string; AFontSize: Integer = 0): Integer;
begin
  Result := TdxTextMeasurer.TextWidthTO(AFont, S, AFontSize);
end;

function cxTextExtent(AFont: TFont; const S: string; AFontSize: Integer = 0): TSize;
begin
  Result := TdxTextMeasurer.TextSizeTO(AFont, S, AFontSize);
end;

function cxGetTextRect(ADC: THandle; const AText: string; ARowCount: Integer; AReturnMaxRectHeight: Boolean = False;
  ADTFlags: Integer = 0): TRect;
begin
  Result := TdxTextMeasurer.TextRectDT(ADC, AText, ARowCount, AReturnMaxRectHeight, ADTFlags);
end;

function cxGetTextRect(AFont: TFont; const AText: string; ARowCount: Integer; AConsiderLineBreaks: Boolean): TRect;
begin
  Result := TdxTextMeasurer.TextRectDT(AFont, AText, ARowCount, AConsiderLineBreaks);
end;

procedure cxGetTextRect(var ARect: TRect; const AText: string; AFont: TFont; ADTFlags: Integer);
begin
  TdxTextMeasurer.TextRectDT(ARect, AText, AFont, ADTFlags);
end;

function cxTextSize(ADC: THandle; const AText: string): TSize; // differs from cxTextExtent
begin
  Result := TdxTextMeasurer.TextSizeDT(ADC, AText);
end;

function cxTextSize(AFont: TFont; const AText: string; AFlags: Integer): TSize;
begin
  Result := TdxTextMeasurer.TextSizeDT(AFont, AText, AFlags);
end;

function cxGetStringAdjustedToWidth(ADC: HDC; AFontHandle: HFONT; const S: string; AWidth: Integer; AModifyStringType: TcxModifyStringType): string; overload;
begin
  Result := TdxTextMeasurer.GetStringAdjustedToWidthDT(ADC, AFontHandle, S, AWidth, AModifyStringType);
end;

function cxGetStringAdjustedToWidth(AFont: TFont; const S: string; AWidth: Integer; AModifyStringType: TcxModifyStringType): string; overload;
begin
  Result := TdxTextMeasurer.GetStringAdjustedToWidthDT(AFont, S, AWidth, AModifyStringType);
end;

function cxCompareBitmaps(ABitmap1, ABitmap2: TBitmap): Boolean;

  function CompareByBitmapBits: Boolean;
  var
    AColors1, AColors2: TRGBColors;
  begin
    GetBitmapBits(ABitmap1, AColors1, True);
    GetBitmapBits(ABitmap2, AColors2, True);
    Result := CompareMem(@AColors1[0], @AColors2[0], Length(AColors1) * 4);
  end;

var
  APixelFormat, AHeight: Integer;
begin
  if ABitmap1 = ABitmap2 then
    Exit(True);

  Result := (ABitmap1 <> nil) and (ABitmap2 <> nil) and
    (ABitmap1.Width = ABitmap2.Width) and (ABitmap1.Height = ABitmap2.Height) and
    (cxGetBitmapPixelFormat(ABitmap1) = cxGetBitmapPixelFormat(ABitmap2));
  if Result and not ABitmap1.Empty then
  begin
    AHeight := ABitmap2.Height;
    APixelFormat := cxGetBitmapPixelFormat(ABitmap2);
    Result := CompareMem(ABitmap1.ScanLine[AHeight - 1], ABitmap2.ScanLine[AHeight - 1],
      ABitmap2.Height * ABitmap2.Width * APixelFormat div 8);
    Result := Result or CompareByBitmapBits;
  end;
end;

function cxCompareGraphics(AGraphic1, AGraphic2: TGraphic): Boolean;
var
  AStream1, AStream2: TMemoryStream;
begin
  if AGraphic1 = AGraphic2 then
    Exit(True);

  Result := (AGraphic1 <> nil) and (AGraphic2 <> nil) and
    (AGraphic1.Width = AGraphic2.Width) and (AGraphic1.Height = AGraphic2.Height);

  if Result then
  begin
    AStream1 := TMemoryStream.Create;
    AStream2 := TMemoryStream.Create;
    try
      AGraphic1.SaveToStream(AStream1);
      AGraphic2.SaveToStream(AStream2);
      Result := (AStream1.Size = AStream2.Size) and CompareMem(AStream1.Memory, AStream2.Memory, AStream1.Size);
    finally
      AStream2.Free;
      AStream1.Free;
    end;
  end;
end;

function cxGetBitmapData(ABitmapHandle: HBITMAP; out ABitmapData: Windows.TBitmap): Boolean;
begin
  Result := GetObject(ABitmapHandle, SizeOf(Windows.TBitmap), @ABitmapData) <> 0;
end;

function cxGetImageClientRect(AImage: TGraphic): TRect;
begin
  Result.Init(0, 0, AImage.Width, AImage.Height)
end;

function cxGetBrushData(ABrushHandle: HBRUSH; out ALogBrush: TLogBrush): Boolean;
begin
  Result := GetObject(ABrushHandle, SizeOf(TLogBrush), @ALogBrush) <> 0;
end;

function cxGetBrushData(ABrushHandle: HBRUSH): TLogBrush;
begin
  cxGetBrushData(ABrushHandle, Result);
end;

function cxGetFontData(AFontHandle: HFONT; out ALogFont: TLogFont): Boolean;
begin
  Result := GetObject(AFontHandle, SizeOf(TLogFont), @ALogFont) <> 0;
end;

function cxGetPenData(APenHandle: HPEN; out ALogPen: TLogPen): Boolean;
begin
  Result := GetObject(APenHandle, SizeOf(TLogPen), @ALogPen) <> 0;
end;

function cxGetTextMetrics(AFont: TFont; out ATextMetric: TTextMetric): Boolean;
begin
  Result := TdxTextMeasurer.TextMetrics(AFont, ATextMetric);
end;

procedure cxInitLogFont(var ALogFont: TLogFont; const AFontName: string);
begin
  FillChar(ALogFont, SizeOf(ALogFont), 0);
  StrPCopy(ALogFont.lfFaceName, AFontName);
  ALogFont.lfCharset := DEFAULT_CHARSET;
end;

function cxGetWritingDirection(AFontCharset: TFontCharset; const AText: string): TCanvasOrientation;

  function IsStandardASCIIChar: Boolean;
  begin
    Result := (Length(AText) > 0)  and (Ord(AText[1]) < 128);
  end;

begin
  if AFontCharset = DEFAULT_CHARSET then
    AFontCharset := GetDefFontCharset;
  if not IsStandardASCIIChar and (AFontCharset in [ARABIC_CHARSET, CHINESEBIG5_CHARSET, GB2312_CHARSET]) then
    Result := coRightToLeft
  else
    Result := coLeftToRight;
end;

procedure cxDrawThemeParentBackground(AControl: TWinControl; ACanvas: TcxCanvas; const ARect: TRect);
var
  AHandle: THandle;
begin
  AHandle := ACanvas.Handle;
  if AControl.Parent.DoubleBuffered or not IsThemeLibraryLoaded then
    cxDrawTransparentControlBackground(AControl, ACanvas, ARect, False)
  else
    DrawThemeParentBackground(AControl.Handle, AHandle, ARect);
end;

procedure cxDrawThemeParentBackground(AControl: TWinControl; ACanvas: TCanvas; const ARect: TRect);
var
  AcxCanvas: TcxCanvas;
begin
  AcxCanvas := TcxCanvas.Create(ACanvas);
  try
    cxDrawThemeParentBackground(AControl, AcxCanvas, ARect);
  finally
    AcxCanvas.Free;
  end;
end;

type
  PcxChildInfo = ^TcxChildInfo;
  TcxChildInfo = record
    Parent: THandle;
    List: TList;
  end;

function GetChildWindowsProc(AHandle: THandle; AInfo: PcxChildInfo): BOOL; stdcall;
begin
  Result := True;
  if GetAncestor(AHandle, GA_PARENT) = AInfo.Parent then
    AInfo.List.Add(Pointer(AHandle));
end;

procedure GetChildWindows(AParent: THandle; AChildWindows: TList);
var
  AInfo: TcxChildInfo;
begin
  AInfo.Parent := AParent;
  AInfo.List := AChildWindows;
  EnumChildWindows(AParent, @GetChildWindowsProc, LPARAM(@AInfo));
end;

function cxGetPrintClientOffset(AWindow: THandle; const AWindowRect, AClientRect: TRect): TPoint;
var
  P: TPoint;
begin
  if dxWindowHasRightToLeftLayout(AWindow) then
    P := cxClientToScreen(AWindow, Point(AClientRect.Right, AClientRect.Top))
  else
    P := cxClientToScreen(AWindow, AClientRect.TopLeft);
  Result.X := P.X - AWindowRect.Left;
  Result.Y := P.Y - AWindowRect.Top;
end;

procedure cxPrintWindow(AWindow, ADC: THandle; ADrawNC, ADrawChildren: Boolean); overload;

  function HasNonClientArea(AWindow: THandle; var AWindowRect, AClientRect: TRect): Boolean;
  begin
    AWindowRect := cxGetWindowRect(AWindow);
    AClientRect := cxGetClientRect(AWindow);
    Result := not cxSizeIsEqual(AWindowRect, AClientRect);
  end;

  procedure DoPrintWindow(AWindow, ADC: THandle; AFlags: DWORD; const AClientOffset: TPoint);
  var
    AOrigin: TPoint;
  begin
    GetWindowOrgEx(ADC, AOrigin);
    SetWindowOrgEx(ADC, AOrigin.X - AClientOffset.X, AOrigin.Y - AClientOffset.Y, nil);
    if AFlags and WM_ERASEBKGND <> 0 then
    begin
      SendMessage(AWindow, WM_ERASEBKGND, ADC, ADC);
      AFlags := AFlags and not PRF_ERASEBKGND;
    end;

    if AFlags and PRF_CLIENT <> 0 then
    begin
      SendMessage(AWindow, WM_PRINT, ADC, AFlags and not PRF_NONCLIENT);
      AFlags := AFlags and not PRF_CLIENT;
    end;
    SetWindowOrgEx(ADC, AOrigin.X, AOrigin.Y, nil);

    if AFlags <> 0 then
      SendMessage(AWindow, WM_PRINT, ADC, AFlags);
  end;

  procedure DoPrintChildren(AWindow, ADC: THandle; AFlags: DWORD; const AWindowRect: TRect);
  var
    AChildWindow: THandle;
    AChildWindows: TList;
    AOrigin: TPoint;
    I: Integer;
  begin
    AChildWindows := TList.Create;
    try
      GetChildWindows(AWindow, AChildWindows);
      for I := 0 to AChildWindows.Count - 1 do
      begin
        AChildWindow := THandle(AChildWindows.List[I]);
        if dxIsWindowStyleSet(AChildWindow, WS_VISIBLE) then
        begin
          AOrigin := cxPointOffset(cxGetWindowRect(AChildWindow).TopLeft, AWindowRect.TopLeft, False);
          MoveWindowOrg(ADC, AOrigin.X, AOrigin.Y);
          cxPrintWindow(AChildWindow, ADC, ADrawNC, ADrawChildren);
          MoveWindowOrg(ADC, -AOrigin.X, -AOrigin.Y);
        end;
      end;
    finally
      AChildWindows.Free;
    end;
  end;

var
  AClientOffset: TPoint;
  AClientRect: TRect;
  AControl: TWinControl;
  AFlags: Cardinal;
  AMemBmp: HBITMAP;
  AMemDC: HDC;
  AWindowRect: TRect;
begin
  AFlags := PRF_ERASEBKGND or PRF_CLIENT;

  if HasNonClientArea(AWindow, AWindowRect, AClientRect) and ADrawNC then
  begin
    AMemDC := CreateCompatibleDC(ADC);
    AMemBmp := CreateCompatibleBitmap(ADC, AWindowRect.Width, AWindowRect.Height);
    try
      SelectObject(AMemDC, AMemBmp);

      AControl := FindControl(AWindow);
      if AControl <> nil then
        FillRectByColor(AMemDC, cxRectSetNullOrigin(AWindowRect), TWinControlAccess(AControl).Color); 

      AClientOffset := cxGetPrintClientOffset(AWindow, AWindowRect, AClientRect);
      if ADrawChildren then
      begin
        DoPrintWindow(AWindow, AMemDC, AFlags, AClientOffset);
        DoPrintChildren(AWindow, AMemDC, AFlags, AWindowRect); 
        DoPrintWindow(AWindow, AMemDC, PRF_NONCLIENT, AClientOffset);
      end
      else
        DoPrintWindow(AWindow, AMemDC, AFlags or PRF_NONCLIENT, AClientOffset);

      cxBitBlt(ADC, AMemDC, cxRectSetNullOrigin(AWindowRect), cxNullPoint, SRCCOPY);
    finally
      DeleteObject(AMemBmp);
      DeleteDC(AMemDC);
    end;
  end
  else
  begin
    if ADrawChildren then
      AFlags := AFlags or PRF_CHILDREN;
    DoPrintWindow(AWindow, ADC, AFlags, cxGetPrintClientOffset(AWindow, AWindowRect, AClientRect));
  end;
end;

procedure cxPrintWindow(AControl: TWinControl; ACanvas: TCanvas; ADrawNC: Boolean); overload;
begin
  ACanvas.Lock;
  cxPrintWindow(AControl.Handle, ACanvas.Handle, ADrawNC, False);
  ACanvas.Unlock;
end;

procedure cxPaintControlTo(ADrawingControl: TWinControl; ACanvas: TcxCanvas; const ADestinationPoint: TPoint;
  const ADrawingRect: TRect; ADrawParentWithChildren, ADrawNC: Boolean; AConsiderWindowRegion: Boolean = True;
  ACheckVisibility: Boolean = True);

  procedure ConsiderWindowRegion(ACanvas: TcxCanvas);
  var
    AWindowRegion: TcxRegion;
  begin
    AWindowRegion := TcxRegion.Create;
    try
      if GetWindowRgn(ADrawingControl.Handle, AWindowRegion.Handle) in [NULLREGION, SIMPLEREGION, COMPLEXREGION] then
        ACanvas.SetClipRegion(AWindowRegion, roIntersect, False);
    finally
      AWindowRegion.Free;
    end;
  end;

  procedure PaintChildTo(AParentControl, AChildControl: TWinControl);
  var
    ADrawingRect, AControlRect: TRect;
  begin
    AControlRect := cxGetWindowBounds(AChildControl);
    ADrawingRect := dxMapWindowRect(AChildControl.Handle, AParentControl.Handle, AControlRect, False);
    if RectVisible(ACanvas.Handle, ADrawingRect) then
      cxPaintControlTo(AChildControl, ACanvas, ADrawingRect.TopLeft, AControlRect, ADrawParentWithChildren, True);
  end;

  procedure PaintChildToEx(AParentControl: TWinControl; AChildHandle: THandle);
  var
    ADrawingRect, AControlRect: TRect;
  begin
    AControlRect := cxGetWindowBounds(AChildHandle);
    ADrawingRect := dxMapWindowRect(AChildHandle, AParentControl.Handle, AControlRect, False);
    if RectVisible(ACanvas.Handle, ADrawingRect) then
    begin
      MoveWindowOrg(ACanvas.Handle, ADrawingRect.Left, ADrawingRect.Top);
      cxPrintWindow(AChildHandle, ACanvas.Handle, True, ADrawParentWithChildren);
      MoveWindowOrg(ACanvas.Handle, -ADrawingRect.Left, -ADrawingRect.Top);
    end;
  end;

  procedure PaintChildren(ADrawingControl: TWinControl);
  var
    AChildControl: TControl;
    AChilds: TList;
    AChildWndHandle: THandle;
    I: Integer;
  begin
    AChilds := TList.Create;
    try
      GetChildWindows(ADrawingControl.Handle, AChilds);
      for I := 0 to ADrawingControl.ControlCount - 1 do
      begin
        AChildControl := ADrawingControl.Controls[I];
        if (AChildControl is TWinControl) and TWinControl(AChildControl).HandleAllocated then
        begin
          AChilds.Remove(Pointer(TWinControl(AChildControl).Handle));
          if TWinControl(AChildControl).Visible and (PaintSkipList.IndexOf(Pointer(TWinControl(AChildControl).Handle)) < 0) then
            PaintChildTo(ADrawingControl, TWinControl(AChildControl));
        end;
      end;

      for I := 0 to AChilds.Count - 1 do
      begin
        AChildWndHandle := THandle(AChilds.List[I]);
        if (PaintSkipList.IndexOf(Pointer(AChildWndHandle)) < 0) and (not ACheckVisibility or IsWindowVisible(AChildWndHandle)) then
          PaintChildToEx(ADrawingControl, AChildWndHandle);
      end;
    finally
      AChilds.Free;
    end;
  end;

var
  AClientRect: TRect;
  ASaveControlState: TControlState;
  AWindowRect: TRect;
  P: TPoint;
begin
  if (csDestroying in ADrawingControl.ComponentState) or not ADrawingControl.HandleAllocated then Exit;

  ACanvas.SaveDC;
  try
    P := cxPointOffset(ADestinationPoint, ADrawingRect.TopLeft, false);
    MoveWindowOrg(ACanvas.Handle, P.X, P.Y);
    ACanvas.IntersectClipRect(ADrawingRect);
    if AConsiderWindowRegion then
      ConsiderWindowRegion(ACanvas);

    if not RectVisible(ACanvas.Handle, ADrawingRect) then Exit;

    ASaveControlState := ADrawingControl.ControlState;
    ADrawingControl.ControlState := ADrawingControl.ControlState + [csPaintCopy];
    try
      ACanvas.SaveState;
      try
        cxPrintWindow(ADrawingControl, ACanvas.Canvas, ADrawNC);
      finally
        ACanvas.RestoreState;
      end;
      if ADrawParentWithChildren then
      begin
        if ADrawNC and GetWindowRect(ADrawingControl.Handle, AWindowRect) and GetClientRect(ADrawingControl.Handle, AClientRect) and not cxSizeIsEqual(AWindowRect, AClientRect) then
        begin
          AClientRect := cxRectOffset(AClientRect, cxGetPrintClientOffset(ADrawingControl.Handle, AWindowRect, AClientRect));
          if (AClientRect.Width <> ADrawingControl.Width) or (AClientRect.Height <> ADrawingControl.Height) then
            ACanvas.IntersectClipRect(AClientRect);
        end;
        PaintChildren(ADrawingControl);
      end;
    finally
      ADrawingControl.ControlState := ASaveControlState;
    end;
  finally
    ACanvas.RestoreDC;
  end;
end;

var
  FLockList: TList;

procedure cxDrawTransparentControlBackground(AControl: TWinControl;
  ACanvas: TcxCanvas; ARect: TRect; APaintParentWithChildren: Boolean = True);
begin
  cxDrawTransparentControlBackground(AControl, ACanvas, ARect, ARect.TopLeft, APaintParentWithChildren);
end;

procedure cxDrawTransparentControlBackground(AControl: TWinControl;
  ACanvas: TCanvas; const ARect: TRect; APaintParentWithChildren: Boolean = True);
var
  AcxCanvas: TcxCanvas;
begin
  AcxCanvas := TcxCanvas.Create(ACanvas);
  try
    cxDrawTransparentControlBackground(AControl, AcxCanvas, ARect, ARect.TopLeft, APaintParentWithChildren);
  finally
    AcxCanvas.Free;
  end;
end;

procedure BeginDrawTransparentBackground(AControl: TWinControl);
begin
  if FLockList = nil then
    FLockList := TList.Create;
  FLockList.Add(AControl.Parent);
end;

procedure EndDrawTransparentBackground(AControl: TWinControl);
begin
  FLockList.Remove(AControl.Parent);
  if FLockList.Count = 0 then
    FreeAndNil(FLockList);
end;

procedure cxDrawTransparentControlBackground(AControl: TWinControl;
  ACanvas: TcxCanvas; const ASourceRect: TRect; const ADestinationPoint: TPoint; APaintParentWithChildren: Boolean = True);
var
  ARect: TRect;
  AStyle: TCustomStyleServices;
begin
  if (AControl <> nil) and (AControl.Parent <> nil) and not cxIsTransparentBackgroundDrawing(AControl.Parent) then
  begin
    ARect := dxMapWindowRect(AControl.Handle, AControl.Parent.Handle, ASourceRect, False);
    BeginDrawTransparentBackground(AControl);
    try
      AStyle := StyleServices;
      if AStyle.Enabled and not AStyle.IsSystemStyle and not (csDesigning in AControl.ComponentState) then
        AStyle.DrawParentBackground(AControl.Handle, ACanvas.Handle, nil, False, ARect)
      else
      begin
        PaintSkipList.Add(Pointer(AControl.Handle));
        try
          cxPaintControlTo(AControl.Parent, ACanvas, ADestinationPoint, ARect, APaintParentWithChildren, False);
        finally
          PaintSkipList.Remove(Pointer(AControl.Handle));
        end;
      end;
    finally
      EndDrawTransparentBackground(AControl);
    end;
  end;
end;

function cxIsTransparentBackgroundDrawing(ABackgroundControl: TWinControl): Boolean;
begin
  Result := (FLockList <> nil) and (FLockList.IndexOf(ABackgroundControl) > -1);
end;

procedure cxRightToLeftDependentDraw(ACanvas: TcxCanvas; const R: TRect; AProc: TProc);
begin
  cxRightToLeftDependentDraw(ACanvas.Handle, R, ACanvas.UseRightToLeftAlignment, AProc);
end;

procedure cxRightToLeftDependentDraw(DC: HDC; const R: TRect; AIsRightToLeftLayout: Boolean; AProc: TProc;
  ACorrectNeeded: Boolean = True);
var
  APrevMode: Integer;
  APrevXForm: TXForm;
begin
  if AIsRightToLeftLayout then
  begin
    APrevMode := SetGraphicsMode(DC, GM_ADVANCED);
    GetWorldTransform(DC, APrevXForm);
    try
      ModifyWorldTransform(DC, TXForm.CreateFlip(True, False, (R.Left + R.Right - IfThen(ACorrectNeeded, 1)) / 2, 0), MWT_LEFTMULTIPLY);
      AProc;
    finally
      SetWorldTransform(DC, APrevXForm);
      SetGraphicsMode(DC, APrevMode);
    end;
  end
  else
    AProc;
end;

procedure cxPaintTo(ASourceControl: TWinControl; ADestinationCanvas: TcxCanvas;
  const ADestinationPoint: TPoint; const ASourceRect: TRect; ASkipList: TList = nil);
begin
  if ASkipList <> nil then
    PaintSkipList.Assign(ASkipList);
  cxPaintControlTo(ASourceControl, ADestinationCanvas, ADestinationPoint, ASourceRect, True, True);
  if ASkipList <> nil then
    PaintSkipList.Assign(ASkipList, laXor);
end;

procedure cxPaintToBitmap(AControl: TWinControl; ABitmap: TcxBitmap; ADrawNCArea: Boolean = False);
var
  AOffset: TPoint;
begin
  if AControl.HandleAllocated then
  begin
    if ADrawNCArea then
      AOffset := cxNullPoint
    else
      AOffset := cxGetClientOffset(AControl.Handle);
    cxPaintTo(AControl, ABitmap.cxCanvas, cxPointInvert(AOffset), cxGetWindowBounds(AControl));
  end;
end;

procedure cxResetFont(AFont: TFont; AScaleFactor: TdxScaleFactor);
var
  ATempFont: TFont;
begin
  ATempFont := TFont.Create;
  try
    if AScaleFactor <> nil then
      dxAssignFont(AFont, ATempFont, AScaleFactor, dxSystemScaleFactor)
    else
      AFont.Assign(ATempFont);
  finally
    ATempFont.Free;
  end;
end;

{ TcxRegion }

constructor TcxRegion.Create(AHandle: TcxRegionHandle);
begin
  inherited Create;
  FHandle := AHandle;
end;

constructor TcxRegion.Create(const ABounds: TRect);
begin
  Create(CreateRectRgnIndirect(ABounds));
end;

constructor TcxRegion.Create;
begin
  Create(cxNullRect);
end;

constructor TcxRegion.Create(ALeft, ATop, ARight, ABottom: Integer);
begin
  Create(TRect.Create(ALeft, ATop, ARight, ABottom));
end;

constructor TcxRegion.CreateFromWindow(AHandle: HWND; ADummy: Integer = 0);
begin
  Create;
  if GetWindowRgn(AHandle, Handle) = RGN_ERROR then
    Combine(cxGetWindowBounds(AHandle), roSet);
end;

constructor TcxRegion.CreateRoundCorners(const ABounds: TRect; AWidthEllipse, AHeightEllipse: Integer);
begin
  CreateRoundCorners(ABounds.Left, ABounds.Top, ABounds.Right, ABounds.Bottom, AWidthEllipse, AHeightEllipse);
end;

constructor TcxRegion.CreateRoundCorners(ALeft, ATop, ARight, ABottom, AWidthEllipse, AHeightEllipse: Integer);
begin
  Create(CreateRoundRectRgn(ALeft + 1, ATop + 1, ARight, ABottom, AWidthEllipse, AHeightEllipse));
end;

destructor TcxRegion.Destroy;
begin
  DestroyHandle;
  inherited Destroy;
end;

function TcxRegion.Clone: TcxRegion;
begin
  Result := TcxRegion.Create(cxNullRect);
  Result.Combine(Self, roAdd, False);
end;

procedure TcxRegion.Combine(ARegion: TcxRegion; AOperation: TcxRegionOperation; ADestroyRegion: Boolean = True);
begin
  Combine(ARegion.Handle, AOperation);
  if ADestroyRegion then
    ARegion.Free;
end;

procedure TcxRegion.Combine(ARegionHandle: TcxRegionHandle; AOperation: TcxRegionOperation);
const
  RegionOperationMap: array[TcxRegionOperation] of Integer = (RGN_COPY, RGN_OR, RGN_DIFF, RGN_AND);
begin
  if AOperation = roSet then
    CombineRgn(FHandle, ARegionHandle, 0, RegionOperationMap[AOperation])
  else
    CombineRgn(FHandle, FHandle, ARegionHandle, RegionOperationMap[AOperation]);
end;

procedure TcxRegion.Combine(const R: TRect; AOperation: TcxRegionOperation);
var
  ARegionHandle: TcxRegionHandle;
begin
  ARegionHandle := CreateRectRgnIndirect(R);
  try
    Combine(ARegionHandle, AOperation);
  finally
    DeleteObject(ARegionHandle);
  end;
end;

function TcxRegion.IsEqual(ARegion: TcxRegion): Boolean;
begin
  Result := (ARegion <> nil) and ((IsEmpty and ARegion.IsEmpty) or IsEqual(ARegion.Handle));
end;

function TcxRegion.IsEqual(ARegionHandle: TcxRegionHandle): Boolean;
begin
  Result := EqualRgn(Handle, ARegionHandle);
end;

procedure TcxRegion.Offset(const P: TPoint);
begin
  Offset(P.X, P.Y);
end;

procedure TcxRegion.Offset(DX, DY: Integer);
begin
  OffsetRgn(FHandle, DX, DY);
end;

function TcxRegion.PtInRegion(const Pt: TPoint): Boolean;
begin
  Result := PtInRegion(Pt.X, Pt.Y);
end;

function TcxRegion.PtInRegion(X, Y: Integer): Boolean;
begin
  Result := Windows.PtInRegion(Handle, X, Y);
end;

function TcxRegion.RectInRegion(const R: TRect): Boolean;
begin
  Result := Windows.RectInRegion(Handle, R);
end;

function TcxRegion.RectInRegion(ALeft, ATop, ARight, ABottom: Integer): Boolean;
begin
  Result := RectInRegion(Rect(ALeft, ATop, ARight, ABottom));
end;

procedure TcxRegion.DestroyHandle;
begin
  if FHandle <> 0 then
  begin
    DeleteObject(FHandle);
    FHandle := 0;
  end;
end;

function TcxRegion.GetBoundsRect: TRect;
begin
  if GetRgnBox(FHandle, Result) = NULLREGION then
    Result := cxNullRect;
end;

function TcxRegion.GetIsEmpty: Boolean;
var
  R: TRect;
begin
  Result := GetRgnBox(FHandle, R) = NULLREGION;
end;

{ TcxCanvas }

constructor TcxCanvas.Create(ACanvas: TCanvas);
begin
  inherited Create;
  FCanvas := ACanvas;
  FSavedRegions := TList.Create;
end;

destructor TcxCanvas.Destroy;
begin
  FCanvas := nil;
  FreeAndNil(FSavedRegions);
  inherited;
end;

function TcxCanvas.GetBrush: TBrush;
begin
  Result := Canvas.Brush;
end;

function TcxCanvas.GetCopyMode: TCopyMode;
begin
  Result := Canvas.CopyMode;
end;

function TcxCanvas.GetFont: TFont;
begin
  Result := Canvas.Font;
end;

function TcxCanvas.GetHandle: HDC;
begin
  Result := Canvas.Handle;
end;

function TcxCanvas.GetDpiX: Integer;
begin
  Result := GetDeviceCaps(Handle, LOGPIXELSX);
end;

function TcxCanvas.GetDpiY: Integer;
begin
  Result := GetDeviceCaps(Handle, LOGPIXELSY);
end;

function TcxCanvas.GetPen: TPen;
begin
  Result := Canvas.Pen;
end;

function TcxCanvas.HandleAllocated: Boolean;
begin
  Result := Canvas.HandleAllocated;
end;

procedure TcxCanvas.Lock;
begin
  Canvas.Lock;
end;

procedure TcxCanvas.Refresh;
begin
  Canvas.Refresh;
end;

procedure TcxCanvas.Unlock;
begin
  Canvas.Unlock;
end;

procedure TcxCanvas.SetBrush(Value: TBrush);
begin
  Canvas.Brush := Value;
end;

procedure TcxCanvas.InitializePen(AColor: TColor; AStyle: TPenStyle; AWidth: Integer);
begin
  if AColor = clNone then
    AStyle := psClear;
  Pen.Color := AColor;
  Pen.Style := AStyle;
  Pen.Width := AWidth;
end;

procedure TcxCanvas.SetCanvas(Value: TCanvas);
begin

  FCanvas := Value;
end;

procedure TcxCanvas.SetCopyMode(Value: TCopyMode);
begin
  Canvas.CopyMode := Value;
end;

procedure TcxCanvas.SetFont(Value: TFont);
begin
  Canvas.Font := Value;
end;

procedure TcxCanvas.SetPen(Value: TPen);
begin
  Canvas.Pen := Value;
end;

procedure TcxCanvas.SetPixel(X, Y: Integer; Value: TColor);
begin
  Canvas.Pixels[X, Y] := Value;
end;

procedure TcxCanvas.StretchDraw(const Rect: TRect; Graphic: TGraphic);
begin
  Canvas.StretchDraw(Rect, Graphic);
end;

function TcxCanvas.GetDefaultUseRightToLeftAlignment: Boolean;
begin
  Result := (Canvas is TControlCanvas) and TControlCanvas(Canvas).Control.UseRightToLeftAlignment
end;

procedure TcxCanvas.SynchronizeObjects(ADC: THandle);
begin
  SynchronizeObjects(Canvas, ADC);
end;

procedure TcxCanvas.SynchronizeObjects(ACanvas: TCanvas; ADC: THandle);

  procedure AssignFont;
  var
    ALogFont: TLogFont;
  begin
    cxGetFontData(GetCurrentObject(ADC, OBJ_FONT), ALogFont);
    ACanvas.Font.Handle := CreateFontIndirect(ALogFont);
    ACanvas.Font.Color := GetTextColor(ADC);
  end;

  procedure AssignBrush;

    function GetBrushStyle(const ALogBrush: TLogBrush): TBrushStyle;
    begin
      Result := bsSolid;
      case ALogBrush.lbStyle of  // TODO lbStyle = BS_PATTERN
        BS_HATCHED:
          case ALogBrush.lbHatch of
            HS_BDIAGONAL: Result := bsBDiagonal;
            HS_CROSS: Result := bsCross;
            HS_DIAGCROSS: Result := bsDiagCross;
            HS_FDIAGONAL: Result := bsFDiagonal;
            HS_HORIZONTAL: Result := bsHorizontal;
            HS_VERTICAL: Result := bsVertical;
          end;
        BS_HOLLOW:
          Result := bsClear;
      end;
    end;

  var
    ALogBrush: TLogBrush;
  begin
    cxGetBrushData(GetCurrentObject(ADC, OBJ_BRUSH), ALogBrush);
    ACanvas.Brush.Handle := CreateBrushIndirect(ALogBrush);
    ACanvas.Brush.Color := ALogBrush.lbColor;  // required: set Color before Style
    ACanvas.Brush.Style := GetBrushStyle(ALogBrush)
  end;

  procedure AssignPen;

    function GetPenStyle(const ALogPen: TLogPen): TPenStyle;
    begin
      Result := TPenStyle(ALogPen.lopnStyle);
    end;

    function GetPenMode: TPenMode;
    const
      PenModes: array[TPenMode] of Integer =
        (R2_BLACK, R2_WHITE, R2_NOP, R2_NOT, R2_COPYPEN, R2_NOTCOPYPEN, R2_MERGEPENNOT,
         R2_MASKPENNOT, R2_MERGENOTPEN, R2_MASKNOTPEN, R2_MERGEPEN, R2_NOTMERGEPEN,
         R2_MASKPEN, R2_NOTMASKPEN, R2_XORPEN, R2_NOTXORPEN);
    var
      I: TPenMode;
      ADrawMode: Integer;
    begin
      Result := pmCopy;
      ADrawMode := GetROP2(ADC);
      for I := Low(TPenMode) to High(TPenMode) do
        if PenModes[I] = ADrawMode then
          Result := I;
    end;

  var
    ALogPen: TLogPen;
  begin
    cxGetPenData(GetCurrentObject(ADC, OBJ_PEN), ALogPen);
    ACanvas.Pen.Handle := CreatePenIndirect(ALogPen);
    ACanvas.Pen.Color := ALogPen.lopnColor;
    ACanvas.Pen.Style := GetPenStyle(ALogPen);
    ACanvas.Pen.Mode := GetPenMode;
    ACanvas.Pen.Width := ALogPen.lopnWidth.X;
  end;

begin
  AssignFont;
  AssignBrush;
  AssignPen;
end;

procedure TcxCanvas.AlignMultiLineTextRectVertically(var R: TRect;
  const AText: string; AAlignmentVert: TcxAlignmentVert;
  AWordBreak, AShowPrefix: Boolean; AEnabled: Boolean = True;
  ADontBreakChars: Boolean = False; AEndEllipsis: Boolean = False; AExpandTabs: Boolean = False);
var
  ASizeR: TRect;
  AFlags: Integer;
begin
  if AAlignmentVert = vaTop then Exit;
  ASizeR := Rect(0, 0, R.Right - R.Left - Ord(not AEnabled), 0);
  AFlags := cxAlignLeft or cxAlignTop;
  if AWordBreak then
    AFlags := AFlags or cxWordBreak;
  if AShowPrefix then
    AFlags := AFlags or cxShowPrefix;
  if ADontBreakChars then
    AFlags := AFlags or cxDontBreakChars;
  if AExpandTabs then
    AFlags := AFlags or cxExpandTabs;
  if AEndEllipsis and AWordBreak then
  begin
    AFlags := cxFlagsToDTFlags(AFlags or cxShowEndEllipsis);
    ASizeR.Height := TdxTextMeasurer.GetEndEllipsisTextHeightDT(Font, AText, ASizeR.Width, R.Height, AFlags);
  end
  else
    TextExtent(AText, ASizeR, AFlags);
  case AAlignmentVert of
    vaCenter:
      R.Top := (R.Top + R.Bottom - ASizeR.Height) div 2;
    vaBottom:
      R.Top := R.Bottom - (ASizeR.Bottom - ASizeR.Top + Ord(not AEnabled));
  end;
end;

procedure TcxCanvas.Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  Canvas.Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

procedure TcxCanvas.CopyRect(const Dest: TRect; ACanvas: TCanvas;
  const Source: TRect);
begin
  Canvas.CopyRect(Dest, ACanvas, Source);
end;

procedure TcxCanvas.Draw(X, Y: Integer; Graphic: TGraphic);
begin
  Canvas.Draw(X, Y, Graphic);
end;

procedure TcxCanvas.Draw(X, Y: Integer; Graphic: TGraphic; Opacity: Byte);
begin
  Canvas.Draw(X, Y, Graphic, Opacity);
end;

procedure TcxCanvas.DrawFocusRect(const R: TRect);
begin
  SaveState;
  try
    SetBrushColor(clWhite);
    Canvas.Font.Color := clBlack;
    TCanvasAccess(Canvas).RequiredState([csFontValid]);
    Canvas.DrawFocusRect(R);
  finally
    RestoreState;
  end;
end;

procedure TcxCanvas.DrawFocusRectEx(const R: TRect; ABorders: TcxBorders; AExclude: Boolean = False);

  function GetInvertedBorders: TcxBorders;
  var
    I: TcxBorder;
  begin
    Result := cxBordersAll;
    for I := Low(TcxBorder) to High(TcxBorder) do
      if I in ABorders then
        Exclude(Result, I);
  end;

begin
  if ABorders = [] then
    Exit;
  SaveClipRegion;
  try
    ExcludeFrameRect(R, 1, GetInvertedBorders);
    DrawFocusRect(R);
  finally
    RestoreClipRegion;
  end;
  if AExclude then
    ExcludeFrameRect(R, 1, ABorders);
end;

procedure TcxCanvas.DrawGlyph(X, Y: Integer; AGlyph: TBitmap; AEnabled: Boolean = True;
  ABackgroundColor: TColor = clNone);
var
  APrevBrushStyle: TBrushStyle;
  AImageList: TImageList;
  ABitmap: TBitmap;
begin
  if AEnabled then
  begin
    APrevBrushStyle := Brush.Style;
    if ABackgroundColor = clNone then
      Brush.Style := bsClear
    else
      Brush.Color := ABackgroundColor;
    Canvas.BrushCopy(Bounds(X, Y, AGlyph.Width, AGlyph.Height), AGlyph,
      cxGetImageClientRect(AGlyph), AGlyph.TransparentColor);
    Brush.Style := APrevBrushStyle;
    Exit;
  end;

  AImageList := nil;
  ABitmap := nil;
  try
    AImageList := TImageList.Create(nil);
    AImageList.Width := AGlyph.Width;
    AImageList.Height := AGlyph.Height;
    if ABackgroundColor <> clNone then
    begin
      ABitmap := TBitmap.Create;
      ABitmap.Width := AImageList.Width;
      ABitmap.Height := AImageList.Height;
      with ABitmap.Canvas do
      begin
        Brush.Color := ABackgroundColor;
        FillRect(cxGetImageClientRect(ABitmap));
      end;
    end;

    if AGlyph.TransparentMode = tmFixed then
      AImageList.AddMasked(AGlyph, AGlyph.TransparentColor)
    else
      AImageList.AddMasked(AGlyph, clDefault);

    if ABitmap <> nil then
    begin
      AImageList.Draw(ABitmap.Canvas, 0, 0, 0, AEnabled); // ??? itMask TODO
      Draw(X, Y, ABitmap);
    end
    else
      AImageList.Draw(Canvas, X, Y, 0, AEnabled); // ??? itMask TODO
  finally
    ABitmap.Free;
    AImageList.Free;
  end;
end;

procedure TcxCanvas.DrawImage(Images: TCustomImageList; X, Y, Index: Integer;
  Enabled: Boolean = True);
begin
  if (0 <= Index) and (Index < Images.Count) then
  begin
    SaveDC;
    Images.Draw(Canvas, X, Y, Index, Enabled);
    RestoreDC;
  end;
end;

procedure TcxCanvas.DrawTexT(const Text: string; R: TRect; Flags: Integer; Enabled: Boolean = True);
begin
  DrawTexT(Text, R, Flags, Enabled, ra0);
end;

procedure TcxCanvas.DrawText(const Text: string; R: TRect; Flags: Integer;
  Enabled: Boolean; ARotationAngle: TcxRotationAngle);
var
  AUseDrawText: Boolean;
  PrevBrushStyle: TBrushStyle;
  PrevFontColor: TColor;
  AClipRect: TRect;

  procedure ProcessFlags;
  var
    ASize: TSize;
    AAlignmentVert: TcxAlignmentVert;
    AIsRTLReading: Boolean;
  begin
    AClipRect := R;
    ASize := TextExtent(Text);
    if (ASize.cx <= R.Right - R.Left) and (ASize.cy <= R.Bottom - R.Top) then
      Flags := Flags or cxDontClip;
    if AUseDrawText then
    begin
      if (Flags and cxSingleLine = 0) and (Flags and (cxAlignBottom or cxAlignVCenter) <> 0) and (ARotationAngle = ra0) then
      begin
        if Flags and cxAlignBottom <> 0 then
          AAlignmentVert := vaBottom
        else
          AAlignmentVert := vaCenter;
        AlignMultiLineTextRectVertically(R, Text, AAlignmentVert,
          cxWordBreak and Flags <> 0, cxShowPrefix and Flags <> 0, Enabled,
          cxDontBreakChars and Flags <> 0, (cxShowEndEllipsis or cxShowWordEllipsis) and Flags <> 0, cxExpandTabs and Flags <> 0);
      end;
      Flags := cxFlagsToDTFlags(Flags);
    end
    else
    begin
      AIsRTLReading := Canvas.TextFlags and ETO_RTLREADING <> 0;
      if (ASize.cx < R.Right - R.Left) or AIsRTLReading then
        case Flags and (cxAlignLeft or cxAlignRight or cxAlignHCenter) of
          cxAlignRight:
            R.Left := R.Right - ASize.cx - Ord(not Enabled);
          cxAlignHCenter:
            R.Left := (R.Left + R.Right - ASize.cx) div 2;
        end;
      if ASize.cy < R.Bottom - R.Top then
        case Flags and (cxAlignTop or cxAlignBottom or cxAlignVCenter) of
          cxAlignBottom:
            R.Top := R.Bottom - ASize.cy - Ord(not Enabled);
          cxAlignVCenter:
            R.Top := (R.Top + R.Bottom - ASize.cy) div 2;
        end;
      if not AIsRTLReading then
        AClipRect := R;
      if Flags and cxDontClip = 0 then
        Flags := ETO_CLIPPED
      else
        Flags := 0;
    end;
  end;

  procedure DoDrawText;
  begin
    if AUseDrawText then
      cxDrawText(Self, Text, R, Flags, clDefault, ARotationAngle)
    else
    begin
      if Canvas.TextFlags and ETO_RTLREADING <> 0 then
        Flags := Flags or ETO_RTLREADING;
      cxExtTextOut(Canvas.Handle, Text, R.TopLeft, AClipRect, Flags);
    end;
  end;

begin
  if Length(Text) = 0 then Exit;
  AUseDrawText := (Flags and cxSingleLine = 0) or (ARotationAngle <> ra0) or
    (Flags and (cxShowPrefix or cxShowEndEllipsis or cxShowPathEllipsis or cxShowWordEllipsis) <> 0);
  ProcessFlags;
  PrevBrushStyle := Brush.Style;
  PrevFontColor := Font.Color;
  if not Enabled then
  begin
    Inc(R.Left);
    Inc(R.Top);
    Brush.Style := bsClear;
    Font.Color := clBtnHighlight;
    DoDrawText;
    OffsetRect(R, -1, -1);
    Font.Color := clBtnShadow;
  end;
  DoDrawText;
  if Brush.Style <> PrevBrushStyle then
    Brush.Style := PrevBrushStyle;
  Font.Color := PrevFontColor;
end;

procedure TcxCanvas.DrawTexT(const Text: string; R: TRect;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
  AMultiLine, AShowEndEllipsis: Boolean);
const
  MultiLines: array[Boolean] of Integer = (cxSingleLine, cxWordBreak);
  ShowEndEllipses: array[Boolean] of Integer = (0, cxShowEndEllipsis);
begin
  if Text = '' then Exit;
  DrawTexT(Text, R, cxAlignmentsHorz[AAlignmentHorz] or  cxAlignmentsVert[AAlignmentVert] or
    MultiLines[AMultiLine] or ShowEndEllipses[AShowEndEllipsis]);
end;

procedure TcxCanvas.FillRect(const R: TRect; AColor: TColor);
begin
  if AColor = clNone then Exit;
  if AColor <> clDefault then
    SetBrushColor(AColor);
  Canvas.FillRect(R);
end;

procedure TcxCanvas.FillRect(const R: TRect; ABitmap: TBitmap = nil;
  AExcludeRect: Boolean = False);
var
  ABitmapSize, AOffset: TPoint;
  AFirstCol, AFirstRow, ALastCol, ALastRow, I, J: Integer;
  ABitmapRect, ACellRect: TRect;
begin
  if IsRectEmpty(R) then Exit;
  if not IsGlyphAssigned(ABitmap) then
    Canvas.FillRect(R)
  else
    with ABitmapSize do
    begin
      X := ABitmap.Width;
      Y := ABitmap.Height;
      AFirstCol := R.Left div X;
      AFirstRow := R.Top div Y;
      ALastCol := R.Right div X - Ord(R.Right mod X = 0);
      ALastRow := R.Bottom div Y - Ord(R.Bottom mod Y = 0);
      for J := AFirstRow to ALastRow do
        for I := AFirstCol to ALastCol do
        begin
          AOffset.X := I * X;
          AOffset.Y := J * Y;
          ACellRect := Bounds(AOffset.X, AOffset.Y, X, Y);
          IntersectRect(ACellRect, ACellRect, R);
          ABitmapRect := ACellRect;
          OffsetRect(ABitmapRect, -AOffset.X, -AOffset.Y);
          CopyRect(ACellRect, ABitmap.Canvas, ABitmapRect);
        end;
    end;
  if AExcludeRect then
    SetClipRegion(TcxRegion.Create(R), roSubtract);
end;

procedure TcxCanvas.FillRect(const R: TRect; const AParams: TcxViewParams; AExcludeRect: Boolean = False);
begin
  SetBrushColor(AParams.Color);
  FillRect(R, AParams.Bitmap, AExcludeRect);
end;

procedure TcxCanvas.DrawDesignSelection(ARect: TRect; AWidth: Integer = cxDesignSelectionWidth);
var
  I: Integer;
begin
  for I := 0 to AWidth - 1 do
  begin
    DrawFocusRect(ARect);
    InflateRect(ARect, -1, -1);
  end;
end;

procedure TcxCanvas.DrawRegion(ARegion: TcxRegion; AContentColor: TColor = clDefault;
  ABorderColor: TColor = clDefault; ABorderWidth: Integer = 1; ABorderHeight: Integer = 1);
begin
  DrawRegion(ARegion.Handle, AContentColor, ABorderColor, ABorderWidth, ABorderHeight);
end;

procedure TcxCanvas.DrawRegion(ARegion: TcxRegionHandle; AContentColor: TColor = clDefault;
  ABorderColor: TColor = clDefault; ABorderWidth: Integer = 1; ABorderHeight: Integer = 1);
begin
  FillRegion(ARegion, AContentColor);
  FrameRegion(ARegion, ABorderColor, ABorderWidth, ABorderHeight);
end;

procedure TcxCanvas.FillRegion(ARegion: TcxRegion; AColor: TColor = clDefault);
begin
  FillRegion(ARegion.Handle, AColor);
end;

procedure TcxCanvas.FillRegion(ARegion: TcxRegionHandle; AColor: TColor = clDefault);
begin
  if AColor <> clNone then
  begin
    SetBrushColor(AColor);
    FillRgn(Handle, ARegion, Brush.Handle);
  end;
end;

procedure TcxCanvas.FlipHorizontally(ABitmap: TBitmap);
var
  Bits: TRGBColors;
  ARow, ACol, W, H, ARowStart: Integer;
  AValue: TRGBQuad;
begin
  W := ABitmap.Width;
  H := ABitmap.Height;

  GetBitmapBits(ABitmap, Bits, True);
  ARowStart := 0;
  for ARow := 0 to H - 1 do
  begin
    for ACol := 0 to (W - 1) div 2 do
    begin
      AValue := Bits[ARowStart + ACol];
      Bits[ARowStart + ACol] := Bits[ARowStart + W - 1 - ACol];
      Bits[ARowStart + W - 1 - ACol] := AValue;
    end;
    Inc(ARowStart, W);
  end;
  SetBitmapBits(ABitmap, Bits, True);
end;

procedure TcxCanvas.FloodFill(X, Y: Integer; Color: TColor; FillStyle: TFillStyle);
begin
  Canvas.FloodFill(X, Y, Color, FillStyle);
end;

procedure TcxCanvas.Line(const P1, P2: TPoint);
begin
  Line(P1.X, P1.Y, P2.X, P2.Y);
end;

procedure TcxCanvas.Line(X1, Y1, X2, Y2: Integer);
begin
  MoveTo(X1, Y1);
  LineTo(X2, Y2);
end;

procedure TcxCanvas.FrameRegion(ARegion: TcxRegion; AColor: TColor = clDefault;
  ABorderWidth: Integer = 1; ABorderHeight: Integer = 1);
begin
  FrameRegion(ARegion.Handle, AColor, ABorderWidth, ABorderHeight);
end;

procedure TcxCanvas.FrameRegion(ARegion: TcxRegionHandle; AColor: TColor = clDefault;
  ABorderWidth: Integer = 1; ABorderHeight: Integer = 1);
begin
  if AColor <> clNone then
  begin
    SetBrushColor(AColor);
    FrameRgn(Handle, ARegion, Brush.Handle, ABorderWidth, ABorderHeight);
  end;
end;

procedure TcxCanvas.Pie(const R: TRect; const ARadial1, ARadial2: TPoint);
begin
  with R do
    Canvas.Pie(Left, Top, Right, Bottom, ARadial1.X, ARadial1.Y, ARadial2.X, ARadial2.Y);
end;

procedure TcxCanvas.Pie(const R: TRect; AStartAngle, ASweepAngle: Integer);
var
  AFinishPoint: TdxPointF;
  AStartPoint: TdxPointF;
begin
  if cxRectIsEmpty(R) or (ASweepAngle = 0) then
    Exit;

  dxCalculateArcSegment(dxRectF(R), AStartAngle, ASweepAngle, AStartPoint, AFinishPoint);
  if not cxPointIsEqual(AStartPoint, AFinishPoint) or (ASweepAngle > 180) then
    Pie(R, cxPoint(AStartPoint, False), cxPoint(AFinishPoint, False));
end;

procedure TcxCanvas.Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  Canvas.Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

function TcxCanvas.FontHeight(AFont: TFont): Integer;
begin
  Font := AFont;
  Result := cxTextHeight(Handle);
end;

procedure TcxCanvas.FrameRect(const R: TRect);
begin
  FrameRect(R, clDefault);
end;

procedure TcxCanvas.FrameRect(const R: TRect; AColor: TColor; ALineWidth: Integer = 1; ABorders: TcxBorders = cxBordersAll);
begin
  FrameRect(R, AColor, ALineWidth, ABorders, False);
end;

procedure TcxCanvas.FrameRect(const R: TRect; AColor: TColor; ALineWidth: Integer; const ABorders: TcxBorders; AExcludeFrame: Boolean);
begin
  if IsRectEmpty(R) or (AColor = clNone) then
    Exit;
  if AColor <> clDefault then
    SetBrushColor(AColor);
  with R do
  begin
    if bLeft in ABorders then
      FillRect(Rect(Left, Top, Min(Left + ALineWidth, Right), Bottom), nil, AExcludeFrame);
    if bRight in ABorders then
      FillRect(Rect(Max(Right - ALineWidth, Left), Top, Right, Bottom), nil, AExcludeFrame);
    if bTop in ABorders then
      FillRect(Rect(Left, Top, Right, Min(Top + ALineWidth, Bottom)), nil, AExcludeFrame);
    if bBottom in ABorders then
      FillRect(Rect(Left, Max(Bottom - ALineWidth, Top), Right, Bottom), nil, AExcludeFrame);
  end;
end;

procedure TcxCanvas.ExcludeFrameRect(const R: TRect; ALineWidth: Integer = 1; ABorders: TcxBorders = cxBordersAll);
begin
  with R do
  begin
    if bLeft in ABorders then
      ExcludeClipRect(Rect(Left, Top, Min(Left + ALineWidth, Right), Bottom));
    if bRight in ABorders then
      ExcludeClipRect(Rect(Max(Right - ALineWidth, Left), Top, Right, Bottom));
    if bTop in ABorders then
      ExcludeClipRect(Rect(Left, Top, Right, Min(Top + ALineWidth, Bottom)));
    if bBottom in ABorders then
      ExcludeClipRect(Rect(Left, Max(Bottom - ALineWidth, Top), Right, Bottom));
  end;
end;

procedure TcxCanvas.InvertFrame(const R: TRect; ABorderSize: Integer);
begin
  with R do
  begin
    InvertRect(Rect(Left, Top, Left + ABorderSize, Bottom));
    InvertRect(Rect(Right - ABorderSize, Top, Right, Bottom));
    InvertRect(Rect(Left + ABorderSize, Top, Right - ABorderSize, Top + ABorderSize));
    InvertRect(Rect(Left + ABorderSize, Bottom - ABorderSize, Right - ABorderSize, Bottom));
  end;
end;

procedure TcxCanvas.InvertRect(const R: TRect);
begin
  with Canvas do
  begin
    CopyMode := cmDstInvert;
    CopyRect(R, Canvas, R);
    CopyMode := cmSrcCopy;
  end;
end;

procedure TcxCanvas.LineTo(X, Y: Integer);
begin
  Canvas.LineTo(X, Y);
end;

procedure TcxCanvas.MoveTo(X, Y: Integer);
begin
  Canvas.MoveTo(X, Y);
end;

procedure TcxCanvas.OffsetClipRegion(AOffsetX, AOffsetY: Integer);
begin
  Windows.OffsetClipRgn(Handle, AOffsetX, AOffsetY);
end;

procedure TcxCanvas.PolyBezier(const Points: array of TPoint);
begin
  Canvas.PolyBezier(Points);
end;

procedure TcxCanvas.PolyBezierTo(const Points: array of TPoint);
begin
  Canvas.PolyBezierTo(Points);
end;

procedure TcxCanvas.Polygon(const Points: array of TPoint);
begin
  Canvas.Polygon(Points);
end;

procedure TcxCanvas.Polygon(const Points: array of TPoint; ABrushColor, APenColor: TColor);
begin
  InitializePen(APenColor, psSolid, 1);
  SetBrushColor(ABrushColor);
  Polygon(Points);
end;

procedure TcxCanvas.Polyline(const Points: array of TPoint);
begin
  Canvas.Polyline(Points);
end;

procedure TcxCanvas.Polyline(const Points: array of TPoint; AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid);
begin
  InitializePen(AColor, APenStyle, APenWidth);
  Polyline(Points);
end;

procedure TcxCanvas.Rectangle(const R: TRect);
begin
  Canvas.Rectangle(R);
end;

procedure TcxCanvas.Rectangle(X1, Y1, X2, Y2: Integer);
begin
  Canvas.Rectangle(X1, Y1, X2, Y2);
end;

procedure TcxCanvas.Rectangle(R: TRect; const AParams: TcxViewParams;
  const ABorders: TcxBorders = cxBordersAll; ABorderColor: TColor = clDefault;
  ALineWidth: Integer = 1; AExcludeRect: Boolean = False);
begin
  if ABorders <> [] then
  begin
    FrameRect(R, ABorderColor, ALineWidth, ABorders, AExcludeRect);
    with R do
    begin
      if bLeft in ABorders then
        Inc(Left, ALineWidth);
      if bRight in ABorders then
        Dec(Right, ALineWidth);
      if bTop in ABorders then
        Inc(Top, ALineWidth);
      if bBottom in ABorders then
        Dec(Bottom, ALineWidth);
    end;
  end;
  SetBrushColor(AParams.Color);
  FillRect(R, AParams.Bitmap, AExcludeRect);
end;

procedure TcxCanvas.Rectangle(const R: TRect; ABrushColor: TColor; APenColor: TColor; APenStyle: TPenStyle; APenWidth: Integer = 1);
begin
  InitializePen(APenColor, APenStyle, APenWidth);
  SetBrushColor(ABrushColor);
  Rectangle(R);
end;

procedure TcxCanvas.RotateBitmap(ABitmap: TBitmap; ARotationAngle: TcxRotationAngle; AFlipVertically: Boolean = False);
var
  SourceRGBs, DestRGBs: TRGBColors;
  ARow, ACol, H, W, ASourceI, ADestI: Integer;
begin
  SourceRGBs := nil; // to remove compiler's warning
  if (ARotationAngle = ra0) and not AFlipVertically then exit;
  H := ABitmap.Height;
  W := ABitmap.Width;

  GetBitmapBits(ABitmap, SourceRGBs, True);
  SetLength(DestRGBs, Length(SourceRGBs));

  for ARow := 0 to H - 1 do
    for ACol := 0 to W - 1 do
    begin
      ASourceI := ARow * W + ACol;
      case ARotationAngle of
        raPlus90:
          if AFlipVertically then
            ADestI := ACol * H + ARow
          else
            ADestI := (W - ACol - 1) * H + ARow;
        ra0:
          ADestI := (H - 1 - ARow) * W + ACol;
        ra180:
          if AFlipVertically then
            ADestI := ARow * W + W - ACol - 1
          else
            ADestI := (H - ARow - 1) * W + W - ACol - 1;
      else
        if AFlipVertically then
          ADestI := (W - ACol - 1) * H + H - ARow - 1
        else
          ADestI := H - 1 + ACol * H - ARow;
      end;
      DestRGBs[ADestI] := SourceRGBs[ASourceI];
    end;

  if ARotationAngle in [raPlus90, raMinus90] then
  begin
    ABitmap.Height := 0;
    ABitmap.Width := H;
    ABitmap.Height := W;
  end;
  SetBitmapBits(ABitmap, DestRGBs, True);
end;

procedure TcxCanvas.RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);
begin
  Canvas.RoundRect(X1, Y1, X2, Y2, X3, Y3);
end;

procedure TcxCanvas.RoundRect(const R: TRect; CX, CY: Integer);
begin
  RoundRect(R.Left, R.Top, R.Right, R.Bottom, CX, CY);
end;

function TcxCanvas.TextExtent(const Text: string): TSize;
begin
  TCanvasAccess(Canvas).RequiredState([csHandleValid, csFontValid]);
  cxGetTextExtentPoint32(Handle, Text, Result);
end;

procedure TcxCanvas.TextExtent(const Text: string; var R: TRect; Flags: Integer);
var
  RWidth, RHeight, TextWidth, TextHeight: Integer;

  procedure CalcRSizes(var AWidth, AHeight: Integer);
  begin
    with R do
    begin
      AWidth := Right - Left;
      AHeight := Bottom - Top;
    end;
  end;

  procedure AlignR;
  begin
    if Flags and DT_CENTER <> 0 then
      OffsetRect(R, (RWidth - TextWidth) div 2, 0)
    else
      if Flags and DT_RIGHT <> 0 then
        OffsetRect(R, RWidth - TextWidth, 0);
    if Flags and DT_VCENTER <> 0 then
      OffsetRect(R, 0, (RHeight - TextHeight) div 2)
    else
      if Flags and DT_BOTTOM <> 0 then
        OffsetRect(R, 0, RHeight - TextHeight);
  end;

begin
  CalcRSizes(RWidth, RHeight);
  Flags := cxFlagsToDTFlags(Flags);
  if (RWidth <= 0) and (Text <> '') then  
    R.Right := R.Left + 1;
  if cxDrawText(Canvas.Handle, Text, R, Flags and not DT_VCENTER or DT_CALCRECT) = 0 then
  begin
    R.Right := R.Left;
    R.Bottom := R.Top;
  end;
  CalcRSizes(TextWidth, TextHeight);
  AlignR;
end;

function TcxCanvas.TextHeight(const Text: string): Integer;
begin
  Result := TextExtent(Text).cy;
end;

procedure TcxCanvas.TextOut(X, Y: Integer; const Text: string);
begin
  Canvas.TextOut(X, Y, Text);
end;

function TcxCanvas.TextWidth(const Text: string): Integer;
begin
  Result := TextExtent(Text).cx;
end;

procedure TcxCanvas.TransparentDraw(X, Y: Integer; ABitmap: TBitmap; AAlpha: Byte;
  ABackground: TBitmap = nil);

  function BlendValues(ASource, ADestination: DWORD): DWORD;
  begin
    Result := MulDiv(ASource, AAlpha, 255) + MulDiv(ADestination, 255 - AAlpha, 255);
  end;

  procedure BlendValue(const ASource: TRGBQuad; var ADestination: TRGBQuad);
  begin
    ADestination.rgbBlue := BlendValues(ASource.rgbBlue, ADestination.rgbBlue);
    ADestination.rgbGreen := BlendValues(ASource.rgbGreen, ADestination.rgbGreen);
    ADestination.rgbRed := BlendValues(ASource.rgbRed, ADestination.rgbRed);
  end;

var
  W, H, ARow, ACol: Integer;
  ABackgroundBitmap: TBitmap;
  ABlendFunction: TBlendFunction;
  ABits, ABackgroundBits: TRGBColors;
begin
  ABits := nil; // to remove compiler's warning
  W := ABitmap.Width;
  H := ABitmap.Height;

  ABackgroundBitmap := TBitmap.Create;
  try
    ABackgroundBitmap.Width := W;
    ABackgroundBitmap.Height := H;

    if ABackground = nil then
      ABackgroundBitmap.Canvas.CopyRect(Rect(0, 0, W, H), Canvas, Bounds(X, Y, W, H))
    else
      ABackgroundBitmap.Canvas.Draw(0, 0, ABackground);

    if Assigned(VCLAlphaBlend) then
    begin
      ABlendFunction := DefaultBlendFunction;
      ABlendFunction.SourceConstantAlpha := AAlpha;
      VCLAlphaBlend(ABackgroundBitmap.Canvas.Handle,
        0, 0, W, H, ABitmap.Canvas.Handle, 0, 0, W, H, ABlendFunction);
    end
    else
    begin
      GetBitmapBits(ABitmap, ABits, True);
      GetBitmapBits(ABackgroundBitmap, ABackgroundBits, True);

      for ARow := 0 to H - 1 do
        for ACol := 0 to W - 1 do
          BlendValue(ABits[ACol * H + ARow], ABackgroundBits[ACol * H + ACol]);

      SetBitmapBits(ABackgroundBitmap, ABackgroundBits, True);
    end;

    Draw(X, Y, ABackgroundBitmap);
  finally
    ABackgroundBitmap.Free;
  end;
end;

procedure TcxCanvas.RestoreDC;
begin
  if Length(FSavedDCs) > 0 then
  begin
    Canvas.Handle := FSavedDCs[High(FSavedDCs)].Handle;
    Windows.RestoreDC(Handle, FSavedDCs[High(FSavedDCs)].State);
    SetLength(FSavedDCs, Length(FSavedDCs) - 1);
    Canvas.Unlock;
  end;
end;

procedure TcxCanvas.SaveDC;
begin
  Canvas.Lock;
  SetLength(FSavedDCs, Length(FSavedDCs) + 1);
  FSavedDCs[High(FSavedDCs)].Handle := Handle;
  FSavedDCs[High(FSavedDCs)].State := Windows.SaveDC(Handle);
end;

procedure TcxCanvas.RestoreClipRegion;
var
  ALastSavedRegionIndex: Integer;
begin
  ALastSavedRegionIndex := FSavedRegions.Count - 1;
  if ALastSavedRegionIndex >= 0 then
  begin
    SetClipRegion(TcxRegion(FSavedRegions[ALastSavedRegionIndex]), roSet);
    FSavedRegions.Delete(ALastSavedRegionIndex);
  end;
end;

procedure TcxCanvas.SaveClipRegion;
begin
  FSavedRegions.Add(GetClipRegion);
end;

procedure TcxCanvas.RestoreState;

  procedure InternalRestoreState(var ACurrentState: TcxCanvasState);
  begin
    TextFlags := ACurrentState.TextFlags;
    FUseRightToLeftAlignment := ACurrentState.UseRightToLeftAlignment;
    Font.Assign(ACurrentState.Font);
    ACurrentState.Font.Free;
    Brush.Assign(ACurrentState.Brush);
    ACurrentState.Brush.Free;
    Pen.Assign(ACurrentState.Pen);
    ACurrentState.Pen.Free;
  end;

begin
  if Length(FSavedStates) > 0 then
  begin
    InternalRestoreState(FSavedStates[High(FSavedStates)]);
    SetLength(FSavedStates, Length(FSavedStates) - 1);
    RestoreDC;
  end;
end;

procedure TcxCanvas.SaveState;

  procedure InternalSaveState(var ACurrentState: TcxCanvasState);
  begin
    ACurrentState.Font := TFont.Create;
    ACurrentState.Font.Assign(Font);
    ACurrentState.Brush := TBrush.Create;
    ACurrentState.Brush.Assign(Brush);
    ACurrentState.Pen := TPen.Create;
    ACurrentState.Pen.Assign(Pen);
    ACurrentState.UseRightToLeftAlignment := FUseRightToLeftAlignment;
    ACurrentState.TextFlags := TextFlags;
  end;

begin
  SaveDC;
  SetLength(FSavedStates, Length(FSavedStates) + 1);
  InternalSaveState(FSavedStates[High(FSavedStates)]);
end;

procedure TcxCanvas.GetParams(var AParams: TcxViewParams);
begin
  AParams.Color := Brush.Color;
  AParams.Font := Font;
  AParams.TextColor := Font.Color;
end;

procedure TcxCanvas.SetParams(const AParams: TcxViewParams);
begin
  SetBrushColor(AParams.Color);
  Font := AParams.Font;
  Font.Color := AParams.TextColor;
end;

procedure TcxCanvas.SetBrushColor(Value: TColor);
begin
  if Value <> clNone then
  begin
    Brush.Style := bsSolid;
    Brush.Color := Value
  end
  else
    Brush.Style := bsClear;
end;

procedure TcxCanvas.SetFontAngle(Value: Integer);
var
  ALogFont: TLogFont;
begin
  cxGetFontData(Font.Handle, ALogFont);
  ALogFont.lfEscapement := Value * 10;
  if Value <> 0 then
    ALogFont.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  Font.Handle := CreateFontIndirect(ALogFont);
end;

procedure TcxCanvas.GetTextStringsBounds(Text: string; R: TRect; Flags: Integer;
  Enabled: Boolean; var ABounds: TRects);
var
  AAlignHorz, AAlignVert, AMaxCharCount: Integer;
  ATextR: TRect;
  AStringSize: TSize;

  procedure PrepareRects;
  begin
    if not Enabled then
      with R do
      begin
        Dec(Right);
        Dec(Bottom);
      end;
    ATextR := R;
    TextExtent(Text, ATextR, Flags);
    case AAlignVert of
      cxAlignBottom:
        OffsetRect(ATextR, 0, R.Bottom - ATextR.Bottom);
      cxAlignVCenter:
        OffsetRect(ATextR, 0, (R.Bottom - ATextR.Bottom) div 2);
    end;
  end;

  procedure CheckMaxCharCount;

    function ProcessSpecialChars: Boolean;
    var
      I, ACharCount: Integer;
    begin
      Result := False;
      for I := 1 to AMaxCharCount do
        if dxCharInSet(Text[I], dxBreakLineCharacters) then
        begin
          AMaxCharCount := I - 1;
          ACharCount := 1;
          if (I < Length(Text)) and
            dxCharInSet(Text[I + 1], dxBreakLineCharacters) and (Text[I] <> Text[I + 1]) then
            Inc(ACharCount);
          Delete(Text, I, ACharCount);
          Result := True;
          Break;
        end;
    end;

    procedure ProcessSpaces;
    var
      I: Integer;
    begin
      if AMaxCharCount < Length(Text) then
        for I := AMaxCharCount + 1 downto 1 do
          if Text[I] = ' ' then
          begin
            if I < AMaxCharCount then
            begin
              AMaxCharCount := I;
              if AAlignHorz <> cxAlignLeft then
              begin
                Delete(Text, I, 1);
                Dec(AMaxCharCount);
              end;
            end;
            Break;
          end;
    end;

  begin
    AMaxCharCount := Max(1, AMaxCharCount);
    if not ProcessSpecialChars then
      ProcessSpaces;
  end;

  procedure GetStringSize;
  begin
    cxGetTextExtentPoint32(Handle, Copy(Text, 1, AMaxCharCount), AStringSize, AMaxCharCount);
  end;

  function GetBounds: TRect;
  begin
    Result := ATextR;
    with Result, AStringSize do
    begin
      case AAlignHorz of
        cxAlignLeft:
          Right := Left + cx;
        cxAlignRight:
          Left := Right - cx;
        cxAlignHCenter:
          begin
            Left := (Left + Right - cx) div 2;
            Right := Left + cx;
          end;
      end;
      Bottom := Top + cy;
    end;
    ATextR.Top := Result.Bottom;
  end;

begin
  if Text = '' then Exit;
  if Flags and cxShowPrefix <> 0 then
  begin
    Text := StripHotKey(Text);
    Flags := Flags and not cxShowPrefix;
  end;
  AAlignHorz := Flags and (cxAlignLeft or cxAlignRight or cxAlignHCenter);
  AAlignVert := Flags and (cxAlignTop or cxAlignBottom or cxAlignVCenter);
  PrepareRects;
  repeat
    GetTextExtentExPoint(Handle, PChar(Text), Length(Text), R.Right - R.Left, @AMaxCharCount, nil, AStringSize);
    CheckMaxCharCount;
    GetStringSize;
    SetLength(ABounds, High(ABounds) + 2);
    ABounds[High(ABounds)] := GetBounds;
    Delete(Text, 1, AMaxCharCount);
  until Text = '';
end;

procedure TcxCanvas.AngleArc(X, Y: Integer; ARadius: Cardinal; AStartAngle, ASweepAngle: Single);
begin
  Canvas.AngleArc(X, Y, ARadius, AStartAngle, ASweepAngle);
end;

procedure TcxCanvas.Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
  AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid);
begin
  InitializePen(AColor, APenStyle, APenWidth);
  if APenStyle = psSolid then
    Arc(AEllipse.Left, AEllipse.Top, AEllipse.Right, AEllipse.Bottom, AStartPoint.X, AStartPoint.Y, AEndPoint.X, AEndPoint.Y)
  else
    inherited Arc(AEllipse, AStartPoint, AEndPoint, AColor, APenWidth, APenStyle);
end;

procedure TcxCanvas.Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  Canvas.Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

procedure TcxCanvas.ArcTo(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  Canvas.ArcTo(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

procedure TcxCanvas.BeginPath;
begin
  Windows.BeginPath(Handle);
end;

procedure TcxCanvas.BrushCopy(const Dest: TRect; Bitmap: TBitmap;
  const Source: TRect; Color: TColor);
begin
  Canvas.BrushCopy(Dest, Bitmap, Source, Color);
end;

procedure TcxCanvas.Ellipse(X1, Y1, X2, Y2: Integer);
begin
  Canvas.Ellipse(X1, Y1, X2, Y2);
end;

procedure TcxCanvas.Ellipse(const Rect: TRect);
begin
  Canvas.Ellipse(Rect);
end;

procedure TcxCanvas.Ellipse(const Rect: TRect;
  ABrushColor, APenColor: TColor; APenStyle: TPenStyle; APenWidth: Integer);
begin
  InitializePen(APenColor, APenStyle, APenWidth);
  SetBrushColor(ABrushColor);
  Ellipse(Rect);
end;

procedure TcxCanvas.EndPath;
begin
  Windows.EndPath(Handle);
end;

function TcxCanvas.PathToRegion(AConsiderOrigin: Boolean = True): TcxRegion;
begin
  Result := TcxRegion.Create(Windows.PathToRegion(Handle));
  if AConsiderOrigin then
    Result.Offset(cxPointInvert(DCOrigin));
end;

procedure TcxCanvas.WidenPath;
begin
  Windows.WidenPath(Handle);
end;

function TcxCanvas.GetClipRegion(AConsiderOrigin: Boolean = True): TcxRegion;
begin
  Result := TcxRegion.Create;
  if GetClipRgn(Handle, Result.Handle) = 0 then
    SetRectRgn(Result.Handle, 0, 0, cxMaxRegionSize, cxMaxRegionSize);
  if AConsiderOrigin then
    Result.Offset(-DCOrigin.X, -DCOrigin.Y);
end;

function TcxCanvas.GetTextFlags: LongInt;
begin
  Result := Canvas.TextFlags;
end;

procedure TcxCanvas.SetClipRegion(ARegion: TcxRegion; AOperation: TcxRegionOperation;
  ADestroyRegion: Boolean = True; AConsiderOrigin: Boolean = True);
var
  AClipRegion: TcxRegion;
  ARegionOrigin: TPoint;
begin
  if AOperation = roSet then
  begin
    if AConsiderOrigin then
    begin
      ARegionOrigin := DCOrigin;
      ARegion.Offset(ARegionOrigin.X, ARegionOrigin.Y);
    end;
    SelectClipRgn(Handle, ARegion.Handle);
    if ADestroyRegion then
      ARegion.Free
    else
      if AConsiderOrigin then
        ARegion.Offset(-ARegionOrigin.X, -ARegionOrigin.Y);
  end
  else
  begin
    AClipRegion := GetClipRegion(AConsiderOrigin);
    AClipRegion.Combine(ARegion, AOperation, ADestroyRegion);
    SetClipRegion(AClipRegion, roSet, True, AConsiderOrigin);
  end;
end;

function TcxCanvas.RectFullyVisible(const R: TRect): Boolean;
var
  AClipRegion, ARegion: TcxRegion;
begin
  AClipRegion := GetClipRegion;
  ARegion := TcxRegion.Create(R);
  try
    CombineRgn(AClipRegion.Handle, AClipRegion.Handle, ARegion.Handle, RGN_AND);
    Result := AClipRegion.IsEqual(ARegion) and PtVisible(Handle, R.Left, R.Top) and
      PtVisible(Handle, R.Right - 1, R.Bottom - 1); 
  finally
    ARegion.Free;
    AClipRegion.Free;
  end;
end;

procedure TcxCanvas.SetTextFlags(Value: LongInt);
begin
  Canvas.TextFlags := Value;
end;

{ TcxScreen }

destructor TScreenCanvas.Destroy;
begin
  FreeHandle;
  inherited;
end;

procedure TScreenCanvas.CreateHandle;
begin
  FWindowHandle := GetDesktopWindow;
  FDeviceContext := GetDCEx(FWindowHandle, 0, DCX_CACHE or DCX_LOCKWINDOWUPDATE); //B96653
  Handle := FDeviceContext;
end;

procedure TScreenCanvas.FreeHandle;
begin
  if FDeviceContext <> 0 then
  begin
    Handle := 0;
    ReleaseDC(FWindowHandle, FDeviceContext);
    FDeviceContext := 0;
    FWindowHandle := 0;
  end;
end;

{ TcxMeasureCanvas }

constructor TcxMeasureCanvas.Create;
begin
  FBitmap := TcxBitmap.CreateSize(1, 1);
//  FBitmap.Canvas.Lock;
  inherited Create(FBitmap.Canvas);
end;

destructor TcxMeasureCanvas.Destroy;
begin
//  FBitmap.Canvas.Unlock;
  inherited;
  FreeAndNil(FBitmap);
end;

{ TcxScreenCanvas }

constructor TcxScreenCanvas.Create;
begin
  inherited Create(TScreenCanvas.Create);
end;

destructor TcxScreenCanvas.Destroy;
begin
  FreeAndNil(FCanvas);
  inherited;
end;

procedure TcxScreenCanvas.Dormant;
begin
  TScreenCanvas(Canvas).FreeHandle;
end;

function cxScreenCanvas: TcxScreenCanvas;
begin
  if (ScreenCanvas = nil) and not FUnitIsFinalized then
    ScreenCanvas := TcxScreenCanvas.Create;
  Result := ScreenCanvas;
end;

{ TcxPaintCanvas }

constructor TcxPaintCanvas.Create;
begin
  inherited Create(nil);
end;

destructor TcxPaintCanvas.Destroy;
begin
  Finalize(FSavedStates);
  inherited;
end;

procedure TcxPaintCanvas.BeginPaint(ADC: THandle);
var
  ACanvas: TCanvas;
begin
  SetCapacity(FCounter + 1);
  FSavedStates[FCounter].PrevCanvas := Canvas;

  FSavedStates[FCounter].FSaveDC := Windows.SaveDC(ADC);
  ACanvas := TCanvas.Create;
  ACanvas.Handle := ADC;
  SynchronizeObjects(ACanvas, ADC);
  Canvas := ACanvas;
  SaveState;

  Inc(FCounter);
end;

procedure TcxPaintCanvas.BeginPaint(ACanvas: TCanvas);
begin
  SetCapacity(FCounter + 1);
  FSavedStates[FCounter].PrevCanvas := Canvas;

  FSavedStates[FCounter].FSaveDC := 0;
  Canvas := ACanvas;
  SaveState;

  Inc(FCounter);
end;

procedure TcxPaintCanvas.EndPaint;
var
  ADC: THandle;
begin
  if FCounter > 0 then
  begin
    Dec(FCounter);

    RestoreState;
    if FSavedStates[FCounter].FSaveDC <> 0 then
    begin
      ADC := Canvas.Handle;
      Canvas.Free;
      Windows.RestoreDC(ADC, FSavedStates[FCounter].FSaveDC);
    end;

    Canvas := FSavedStates[FCounter].PrevCanvas;
  end;
end;

procedure TcxPaintCanvas.SetCanvas(Value: TCanvas);
begin
  FCanvas := Value;
end;

procedure TcxPaintCanvas.SetCapacity(AValue: Integer);
begin
  if AValue > Length(FSavedStates) then
    SetLength(FSavedStates, Max(AValue, Length(FSavedStates) + 4));
end;

function cxMeasureCanvas: TcxCanvas;
begin
  if (MeasureCanvas = nil) and not FUnitIsFinalized then
    MeasureCanvas := TcxMeasureCanvas.Create;
  Result := MeasureCanvas;
end;

function cxPaintCanvas: TcxPaintCanvas;
begin
  if (PaintCanvas = nil) and not FUnitIsFinalized then
    PaintCanvas := TcxPaintCanvas.Create;
  Result := PaintCanvas;
end;

function cxPtInRegion(ARegionHandle: HRGN; const X, Y: Integer): Boolean;
begin
  Result := PtInRegion(ARegionHandle, X, Y);
end;

function cxPtInRegion(ARegionHandle: HRGN; const P: TPoint): Boolean;
begin
  Result := cxPtInRegion(ARegionHandle, P.X, P.Y);
end;

procedure cxTransformImages(AImageList: TcxImageList; ABkColor: TColor; AEnabled: Boolean = True);
var
  ACopy: TcxImageList;
begin
  ACopy := TcxImageList.CreateSize(AImageList.Width, AImageList.Height);
  try
    ACopy.CopyImages(AImageList);
    cxTransformImages(ACopy, AImageList, ABkColor, AEnabled);
  finally
    ACopy.Free;
  end;
end;

procedure cxTransformImages(ASourceImageList, ADestinationImageList: TcxImageList; ABkColor: TColor; AEnabled: Boolean = True);
var
  AAlphaBitmap: TcxAlphaBitmap;
  ABitmap: TcxBitmap;
  I: Integer;
begin
  ADestinationImageList.Clear;
  AAlphaBitmap := TcxAlphaBitmap.CreateSize(ASourceImageList.Width, ASourceImageList.Height, dxColorToRGBQuad(ABkColor, $FF));
  ABitmap := TcxBitmap.CreateSize(AAlphaBitmap.ClientRect, pf24bit);
  try
    for I := 0 to ASourceImageList.Count - 1 do
    begin
      AAlphaBitmap.Clear;
      ASourceImageList.Draw(AAlphaBitmap.Canvas, AAlphaBitmap.ClientRect, I, True, False, AEnabled);
      ABitmap.CopyBitmap(AAlphaBitmap);
      ADestinationImageList.AddMasked(ABitmap, ABkColor);
    end;
  finally
    ABitmap.Free;
    AAlphaBitmap.Free;
  end;
end;

procedure cxAdvancedDrawPopupMenuItem(AMenuItem: TMenuItem; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState; AExternalImages: TCustomImageList = nil);
var
  ACxCanvas: TcxCanvas;
begin
  if AMenuItem = nil then Exit;
  ACxCanvas := TcxCanvas.Create(ACanvas);
  try
    cxAdvancedDrawPopupMenuItem(AMenuItem, ACxCanvas, ARect, AState, AExternalImages);
  finally
    ACxCanvas.Free;
  end;
end;

procedure cxAdvancedDrawPopupMenuItem(AMenuItem: TMenuItem; ACanvas: TcxCanvas; ARect: TRect;
  AState: TOwnerDrawState; AExternalImages: TCustomImageList = nil); overload;
begin
  if AMenuItem = nil then Exit;
  with TdxPopupMenuItemInfo.CreateFromMenuItem(AMenuItem, AExternalImages) do
  try
    CalculateLayout(ACanvas, ARect, AState);
    Draw(ACanvas, ARect, AState);
  finally
    Free;
  end;
end;

procedure dxSetFontAsNonAntialiased(AFont : TFont);
var
  LogFont: TLogFont;
begin
  cxGetFontData(AFont.Handle, LogFont);
  LogFont.lfQuality := NONANTIALIASED_QUALITY;
  AFont.Handle := CreateFontIndirect(LogFont);
end;

procedure dxSetZoomFactor(ACanvas: TcxCanvas; AZoomFactor: Integer; var APrevTransform: XFORM);
var
  ATransform: TXForm;
begin
  SetGraphicsMode(ACanvas.Handle, GM_ADVANCED);
  GetWorldTransform(ACanvas.Handle, APrevTransform);
  ATransform := APrevTransform;
  ATransform.eM11 := AZoomFactor / 100;
  ATransform.eM22 := AZoomFactor / 100;
  SetWorldTransform(ACanvas.Handle, ATransform);
end;

function dxPictureToImage(APicture: TPicture; ASize: TSize; AMode: TcxImageFitMode; var AImage: TdxSmartImage): Boolean;
var
  ABitmap: TcxBitmap32;
begin
  Result := False;
  if AMode = ifmNormal then
  begin
    ASize.cx := APicture.Graphic.Width;
    ASize.cy := APicture.Graphic.Height;
  end;
  if (ASize.cx <= 0) or (ASize.cy <= 0) then
    Exit;
  ABitmap := TcxBitmap32.CreateSize(ASize.cx, ASize.cy);
  try
    ABitmap.cxCanvas.FillRect(Rect(0, 0, ASize.cx, ASize.cy), clWhite);
    ABitmap.RecoverTransparency(clWhite);
    cxDrawPicture(ABitmap.cxCanvas, TRect.Create(0, 0, ASize.cx, ASize.cy), APicture, AMode);
    AImage := TdxSmartImage.CreateFromBitmap(ABitmap);
  finally
    ABitmap.Free;
  end;
  Result := AImage <> nil;
end;

function dxImageFrameToGraphic(ASource: TdxSmartImage; AFrameIndex: Integer; AImageDataFormat: TdxImageDataFormat = dxImageTiff): TdxSmartImage;
var
  ABitmap: TBitmap;
  ASaveFrame: Integer;
  ASaveEventHandler: TNotifyEvent;
begin
  ASaveFrame := ASource.ActiveFrame;
  ASaveEventHandler := ASource.OnChange;
  try
    ASource.OnChange := nil;
    ASource.ActiveFrame := AFrameIndex;

    ABitmap := ASource.GetAsBitmap;
    try
      Result := TdxSmartImage.CreateFromBitmap(ABitmap);
      Result.ImageDataFormat := AImageDataFormat;
    finally
      ABitmap.Free;
    end;
  finally
    ASource.ActiveFrame := ASaveFrame;
    ASource.OnChange := ASaveEventHandler;
  end;
end;

function cxRectExcludeBorders(const ABounds, ABordersWidth: TRect; ABorders: TcxBorders): TRect;
begin
  Result := ABounds;
  if not (bLeft in ABorders) then
    Dec(Result.Left, ABordersWidth.Left);
  if not (bTop in ABorders) then
    Dec(Result.Top, ABordersWidth.Top);
  if not (bRight in ABorders) then
    Inc(Result.Right, ABordersWidth.Right);
  if not (bBottom in ABorders) then
    Inc(Result.Bottom, ABordersWidth.Bottom);
end;

function cxRectExcludeBorders(const ABounds: TRect; ABorderWidth: Integer; const ABorders: TcxBorders): TRect;
begin
  Result := ABounds;
  if not (bLeft in ABorders) then
    Dec(Result.Left, ABorderWidth);
  if not (bTop in ABorders) then
    Dec(Result.Top, ABorderWidth);
  if not (bRight in ABorders) then
    Inc(Result.Right, ABorderWidth);
  if not (bBottom in ABorders) then
    Inc(Result.Bottom, ABorderWidth);
end;


function dxCreateMultiFrameTIFF(AFrameCount: Integer; const ASize: TSize; AMode: TcxImageFitMode; AProc: TdxGetImageFrameProc): TdxSmartImage;
var
  I: Integer;
  AFrame: TdxSmartImage;
  //
  AParams: TEncoderParameters;
  AParameterValue: Cardinal;
  //
  AStream: TdxGPMemoryStream;
  AStreamAdapter: IStream;
begin
  Result := nil;
  if AFrameCount =  0 then
    Exit;
  //
  AStream := TdxGPMemoryStream.Create;
  try
    AStreamAdapter := TdxGPStreamAdapter.Create(AStream, soReference);
    AParams.Count := 1;
    AParams.Parameter[0].Guid := EncoderSaveFlag;
    AParams.Parameter[0].Type_ := EncoderParameterValueTypeLong;
    AParams.Parameter[0].NumberOfValues := 1;
    AParams.Parameter[0].Value := @AParameterValue;
    AParameterValue := Cardinal(TGpEncoderValues.evMultiFrame);
    // process frames
    for I := 0 to AFrameCount - 1 do
      if AProc(I, ASize, AMode, AFrame) then
      begin
        if Result = nil then
        begin
          Result := AFrame;
          AParameterValue := Cardinal(TGpEncoderValues.evMultiFrame);
          GdipCheck(GdipSaveImageToStream(Result.Handle, AStreamAdapter, @TIFFEncoder, @AParams));
        end
        else
        begin
          AParameterValue := Cardinal(TGpEncoderValues.evFrameDimensionPage);
          GdipCheck(GdipSaveAddImage(Result.Handle, AFrame.Handle, @AParams));
          AFrame.Free;
        end
      end;
    //
    AParameterValue := Cardinal(TGpEncoderValues.evFlush);
    GdipSaveAdd(Result.Handle, @AParams);
    // refresh multi frames image data
    AStream.Position := 0;
    Result.LoadFromStream(AStream);
  finally
    AStreamAdapter := nil;
    AStream.Free;
  end;
end;

{ Filters }

function cxGraphicExtension(AGraphic: TGraphic): string;
begin
  if IsGlyphAssigned(AGraphic) and (AGraphic is TdxCustomSmartImage) then
    Result := TdxSmartImageCodecsRepository.GetDefaultExt(TdxCustomSmartImage(AGraphic).ImageCodec)
  else
    Result := cxGraphicExtension(TGraphicClass(AGraphic.ClassType));
end;

function cxGraphicExtension(AGraphicClass: TGraphicClass): string;
begin
  Result := GraphicExtension(AGraphicClass);
end;

function cxGraphicFileMask(AGraphicClass: TGraphicClass): string;
begin
  if (AGraphicClass <> nil) and AGraphicClass.InheritsFrom(TdxCustomSmartImage) then
    Result := TdxSmartImageCodecsRepository.GetSupportedExtensions
  else
    Result := GraphicFileMask(AGraphicClass)
end;

function cxGraphicFilter(AGraphic: TGraphic; AForExport: Boolean = False): string;
begin
  if AForExport and IsGlyphAssigned(AGraphic) and (AGraphic is TdxCustomSmartImage) then
    Result := TdxSmartImageCodecsRepository.GetSaveDialogFilter(TdxCustomSmartImageAccess(AGraphic).Handle)
  else
    Result := cxGraphicFilter(TGraphicClass(AGraphic.ClassType));
end;

function cxGraphicFilter(AGraphicClass: TGraphicClass): string;
begin
  if (AGraphicClass <> nil) and AGraphicClass.InheritsFrom(TdxCustomSmartImage) then
    Result := TdxSmartImageCodecsRepository.GetOpenDialogFilter
  else
    Result := GraphicFilter(AGraphicClass);
end;

procedure cxGraphicDormant(AGraphic: TGraphic);
begin
  if (AGraphic <> nil) and not AGraphic.Empty then
  begin
    if AGraphic is TBitmap then
      TBitmap(AGraphic).Dormant
    else
      if AGraphic is TdxCustomSmartImage then
        TdxCustomSmartImage(AGraphic).Dormant;
  end;
end;

{ TcxBitmap }

constructor TcxBitmap.Create;
begin
  CreateSize(0, 0);
end;

constructor TcxBitmap.CreateSize(const ASize: TSize);
begin
  CreateSize(ASize.cx, ASize.cy);
end;

constructor TcxBitmap.CreateSize(const ARect: TRect);
begin
  CreateSize(ARect.Width, ARect.Height);
end;

constructor TcxBitmap.CreateSize(AWidth, AHeight: Integer);
begin
  CreateSize(AWidth, AHeight, pf24bit);
end;

constructor TcxBitmap.CreateSize(const ARect: TRect; APixelFormat: TPixelFormat);
begin
  CreateSize(ARect.Width, ARect.Height, APixelFormat);
end;

constructor TcxBitmap.CreateSize(AWidth, AHeight: Integer; APixelFormat: TPixelFormat);
begin
  inherited Create;
  Initialize(AWidth, AHeight, APixelFormat);
end;

destructor TcxBitmap.Destroy;
begin
  FreeAndNil(FcxCanvas);
  inherited;
end;

procedure TcxBitmap.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TcxBitmap.CancelUpdate;
begin
  Dec(FLockCount);
end;

procedure TcxBitmap.EndUpdate(AForceUpdate: Boolean = True);
begin
  Dec(FLockCount);
  if (FLockCount = 0) and (AForceUpdate or FModified) then
    Changed(Self);
end;

procedure TcxBitmap.CopyBitmap(ASrcBitmap: TBitmap; ACopyMode: DWORD = SRCCOPY);
begin
  CopyBitmap(ASrcBitmap, ClientRect, cxNullPoint, ACopyMode);
end;

procedure TcxBitmap.CopyBitmap(ASrcBitmap: TBitmap; const ADestRect: TRect; const ASrcTopLeft: TPoint; ACopyMode: DWORD);
begin
  cxBitBlt(Canvas.Handle, ASrcBitmap.Canvas.Handle, ADestRect, ASrcTopLeft, ACopyMode);
end;

procedure TcxBitmap.Dormant;
begin
  FreeAndNil(FcxCanvas);
  inherited Dormant;
end;

procedure TcxBitmap.Flip(AFlipHorizontally, AFlipVertically: Boolean);
var
  ABitmap: TcxBitmap;
  APrevMode: Integer;
begin
  if AFlipHorizontally or AFlipVertically then
  begin
    ABitmap := TcxBitmap.CreateSize(Width, Height);
    try
      APrevMode := SetGraphicsMode(ABitmap.Canvas.Handle, GM_ADVANCED);
      SetWorldTransform(ABitmap.Canvas.Handle,
        TXForm.CreateFlip(AFlipHorizontally, AFlipVertically, (ABitmap.Width - 1) / 2, (ABitmap.Height - 1) / 2));
      cxBitBlt(ABitmap.Canvas.Handle, Canvas.Handle, ABitmap.ClientRect, cxNullPoint, SRCCOPY);
      SetWorldTransform(ABitmap.Canvas.Handle, cxIdentityMatrix);
      SetGraphicsMode(ABitmap.Canvas.Handle, APrevMode);
      cxBitBlt(Canvas.Handle, ABitmap.Canvas.Handle, ClientRect, cxNullPoint, SRCCOPY);
    finally
      ABitmap.Free;
    end;
  end;
end;

procedure TcxBitmap.Rotate(ARotationAngle: TcxRotationAngle; AFlipVertically: Boolean);
begin
  cxCanvas.RotateBitmap(Self, ARotationAngle, AFlipVertically);
end;

procedure TcxBitmap.SetSize(AWidth, AHeight: Integer);
begin
  AWidth  := Max(0, AWidth);
  AHeight := Max(0, AHeight);
  if (AWidth <> Width) or (AHeight <> Height) then
  begin
    BeginUpdate;
    try
      inherited SetSize(AWidth, AHeight);
    finally
      EndUpdate(False);
    end;
  end;
end;

procedure TcxBitmap.SetSize(const ARect: TRect);
begin
  SetSize(ARect.Width, ARect.Height);
end;

procedure TcxBitmap.Changed(Sender: TObject);
begin
  if not ChangeLocked then
  begin
    inherited;
    Update;
    FModified := False;
  end
  else
    FModified := True;
end;

function TcxBitmap.ChangeLocked: Boolean;
begin
  Result := FLockCount > 0;
end;

procedure TcxBitmap.Initialize(AWidth, AHeight: Integer; APixelFormat: TPixelFormat);
begin
  BeginUpdate;
  try
    PixelFormat := APixelFormat;
    SetSize(AWidth, AHeight);
  finally
    EndUpdate;
  end;
end;

procedure TcxBitmap.Update;
begin
// do nothing
end;

const
  ADXBMSignature: Integer = $4D424458; //DXBM
  ADXBMVersion: Word = 2;

procedure TcxBitmap.ReadData(Stream: TStream);
var
  ASize: Integer;
  ASignature: Integer;
  AVersion: Word;
  AStreamPos: Integer;
  AMemoryStream: TMemoryStream;
begin
  AStreamPos := Stream.Position;
  Stream.Read(ASize, SizeOf(ASize));
  Stream.Read(ASignature, SizeOf(ASignature));
  Stream.Read(AVersion, SizeOf(AVersion));
  if ASignature <> ADXBMSignature then
  begin
    Stream.Position := AStreamPos;
    inherited ReadData(Stream);
  end
  else
  begin
    AMemoryStream := TMemoryStream.Create;
    try
      case AVersion of
        1: Decompress1(Stream, AMemoryStream, ASize);
        2: Decompress2(Stream, AMemoryStream, ASize);
      end;
      AMemoryStream.Position := 0;
      inherited ReadData(AMemoryStream);
    finally
      AMemoryStream.Free;
    end;
  end;
end;

procedure TcxBitmap.WriteData(Stream: TStream);

  procedure WriteSignature(AStream: TStream; ASize, ASignaturePosition: Integer);
  var
    ACurrentPos: Integer;
  begin
    ACurrentPos := AStream.Position;
    AStream.Position := ASignaturePosition;
    AStream.Write(ASize, SizeOf(ASize));
    AStream.Write(ADXBMSignature, SizeOf(ADXBMSignature));
    AStream.Write(ADXBMVersion, SizeOf(ADXBMVersion));
    AStream.Position := ACurrentPos;
  end;

var
  AMemoryStream: TMemoryStream;
  ASignaturePosition, ADataOffset: Integer;
  ASize: Integer;
begin
  if CompressData then
  begin
    AMemoryStream := TMemoryStream.Create;
    try
      inherited WriteData(AMemoryStream);
      AMemoryStream.Position := 0;
      ASignaturePosition := Stream.Position;
      ADataOffset := SizeOf(ASize) + SizeOf(ADXBMSignature) + SizeOf(ADXBMVersion);
      Stream.Position := Stream.Position + ADataOffset;
      Compress(AMemoryStream, Stream, AMemoryStream.Size);
    finally
      AMemoryStream.Free;
    end;
    ASize := Stream.Position - ADataOffset;
    WriteSignature(Stream, ASize, ASignaturePosition);
  end
  else
    inherited;
end;

type
  TSeekMode = (smDup, smUnique);
const
  AModeMap: array[Boolean] of TSeekMode = (smDup, smUnique);
  AModeMask: array[TSeekMode] of Byte = (0, 128);

function ReadByte(AStream: TStream; AMaxPos: Integer; var AByte: Byte): Boolean;
begin
  Result := AStream.Position < AMaxPos;
  if Result then
    AStream.Read(AByte, SizeOf(Byte));
end;

procedure WriteByte(AStream: TStream; AByte: Byte);
begin
  AStream.Write(AByte, SizeOf(Byte));
end;

function CompareBlock(ABlock1, ABlock2: TBytes): Boolean;
begin
  Result := (Length(ABlock1) = Length(ABlock2)) and CompareMem(ABlock1, ABlock2, Length(ABlock1));
end;

function ReadBlock(AStream: TStream; AMaxPos: Integer; var ABlock: TBytes; ABlockSize: Integer): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to ABlockSize - 1 do
    Result := Result and ReadByte(AStream, AMaxPos, ABlock[I]);
end;

procedure WriteBlock(AStream: TStream; ABlock: TBytes; ABlockSize: Integer);
var
  I: Integer;
begin
  for I := 0 to ABlockSize - 1 do
    WriteByte(AStream, ABlock[I]);
end;

procedure TcxBitmap.CompressByBlock(ASourceStream, ADestStream: TStream; ASize, ABlockSize: Integer);

  function GetCounter(ASeekBlock: TBytes; AMode: TSeekMode; AMaxPos: Integer): Integer;
  var
    ABlock: TBytes;
  begin
    Result := 1;
    SetLength(ABlock, ABlockSize);
    while (Result < 125) and ReadBlock(ASourceStream, AMaxPos, ABlock, ABlockSize) do
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
  ACounter, AReadedCount: Integer;
  AStreamPos, AMaxPos: Integer;
  AMode: TSeekMode;
begin
  AMaxPos := ASourceStream.Position + ASize;

  SetLength(AReadBlock1, ABlockSize);
  SetLength(AReadBlock2, ABlockSize);

  while ReadBlock(ASourceStream, AMaxPos, AReadBlock1, ABlockSize) do
  begin
    AReadedCount := ABlockSize;
    AStreamPos := ASourceStream.Position - ABlockSize;
    if ReadBlock(ASourceStream, AMaxPos, AReadBlock2, ABlockSize) then
    begin
      Inc(AReadedCount, ABlockSize);
      AMode := AModeMap[(AReadedCount = ABlockSize) or not CompareBlock(AReadBlock1, AReadBlock2)];
      ASourceStream.Position := ASourceStream.Position - (AReadedCount - ABlockSize);
      ACounter := GetCounter(AReadBlock1, AMode, AMaxPos);
    end
    else
    begin
      AMode := smUnique;
      ACounter := 1;
    end;

    WriteByte(ADestStream, ACounter or AModeMask[AMode]);
    case AMode of
      smUnique:
        begin
          ASourceStream.Position := AStreamPos;
          ADestStream.CopyFrom(ASourceStream, ACounter * ABlockSize);
        end;
      smDup:
        WriteBlock(ADestStream, AReadBlock1, ABlockSize);
    end;
    ASourceStream.Position := AStreamPos + ACounter * ABlockSize;
  end;
end;

procedure TcxBitmap.DecompressByBlock(ASourceStream, ADestStream: TStream; ASize, ABlockSize: Integer);
var
  ACode: Byte;
  AReadBlob: TBytes;
  AMaxPos: Integer;
  I: Integer;
  ACounter: Integer;
begin
  AMaxPos := ASourceStream.Position + ASize;

  SetLength(AReadBlob, ABlockSize);

  while ReadByte(ASourceStream, AMaxPos, ACode) do
  begin
    ACounter := ACode and 127;
    if (ACode and AModeMask[smUnique]) <> 0 then
      ADestStream.CopyFrom(ASourceStream, ACounter * ABlockSize)
    else
    begin
      ReadBlock(ASourceStream, AMaxPos, AReadBlob, ABlockSize);
      for I := 0 to ACounter - 1 do
        WriteBlock(ADestStream, AReadBlob, ABlockSize);
    end;
  end;
end;

procedure TcxBitmap.Compress(ASourceStream, ADestStream: TStream; ASize: Integer);
var
  ABlockSize, AShift: Byte;
begin
  ABlockSize := Max(cxGetBitmapPixelFormat(Self) div 8, 1);
  AShift := ASourceStream.Size mod ABlockSize;
  WriteByte(ADestStream, ABlockSize);
  WriteByte(ADestStream, AShift);
  if AShift > 0 then
    ADestStream.CopyFrom(ASourceStream, AShift);
  CompressByBlock(ASourceStream, ADestStream, ASize - AShift, ABlockSize);
end;

procedure TcxBitmap.Decompress1(ASourceStream, ADestStream: TStream; ASize: Integer);
begin
  DecompressByBlock(ASourceStream, ADestStream, ASize, 1);
end;

procedure TcxBitmap.Decompress2(ASourceStream, ADestStream: TStream; ASize: Integer);
var
  ABlockSize, AShift: Byte;
begin
  ReadByte(ASourceStream, ASize, ABlockSize);
  ReadByte(ASourceStream, ASize, AShift);
  if AShift > 0 then
    ADestStream.CopyFrom(ASourceStream, AShift);
  DecompressByBlock(ASourceStream, ADestStream, ASize - (2 + AShift), ABlockSize);
end;

function TcxBitmap.GetCanvas: TcxCanvas;
begin
  if FcxCanvas = nil then
    FcxCanvas := TcxCanvas.Create(Canvas);
  Result := FcxCanvas;
end;

function TcxBitmap.GetClientRect: TRect;
begin
  Result := Rect(0, 0, Width, Height);
end;

function TcxBitmap.GetIsDormant: Boolean;
begin
  Result := FcxCanvas = nil;
end;

{ TcxAlphaBitmap }

function TcxColorList.Add(AColor: TColor): Integer;
begin
  Result := inherited Add(Pointer(cxColorEssence(dxColorToRGBQuad(AColor))));
end;

{ TcxBitmap32 }

constructor TcxBitmap32.CreateSize(AWidth, AHeight: Integer);
begin
  CreateSize(AWidth, AHeight, pf32bit);
end;

constructor TcxBitmap32.CreateSize(AWidth, AHeight: Integer; AClear: Boolean);
begin
  CreateSize(AWidth, AHeight, pf32bit);
  if AClear then
    Clear;
end;

constructor TcxBitmap32.CreateSize(const ARect: TRect; AClear: Boolean);
begin
  CreateSize(ARect, pf32bit);
  if AClear then
    Clear;
end;

constructor TcxBitmap32.CreateSize(const ASize: TSize; AClear: Boolean);
begin
  CreateSize(ASize);
  if AClear then
    Clear;
end;

procedure TcxBitmap32.AfterConstruction;
begin
  inherited;
  FIsAlphaUsed := bDefault;
end;

procedure TcxBitmap32.GetBitmapColors(out AColors: TRGBColors);
begin
  GetBitmapBits(Self, AColors, False)
end;

procedure TcxBitmap32.SetBitmapColors(const AColors: TRGBColors);
begin
  SetBitmapBits(Self, AColors, False);
end;

procedure TcxBitmap32.AlphaBlend(ADestBitmap: TcxBitmap32; const ADestRect: TRect; ASmoothImage: Boolean; AConstantAlpha: Byte = $FF);
begin
  cxAlphaBlend(ADestBitmap, Self, ADestRect, ClientRect, ASmoothImage, AConstantAlpha);
end;

procedure TcxBitmap32.Clear;
begin
  cxClearBitmap(Self);
end;

procedure TcxBitmap32.Darken(APercent: Byte);
var
  AColors: TRGBColors;
  I: Integer;
begin
  GetBitmapColors(AColors);
  for I := 0 to Length(AColors) - 1 do
    with AColors[I] do
    begin
      rgbRed := Trunc(rgbRed * APercent / 100);
      rgbGreen := Trunc(rgbGreen * APercent / 100);
      rgbBlue := Trunc(rgbBlue * APercent / 100);
    end;
  SetBitmapColors(AColors);
end;

procedure TcxBitmap32.Filter(AMaskBitmap: TcxBitmap32);
const
  DSna = $00220326;
begin
  CopyBitmap(AMaskBitmap, DSna);
end;

procedure TcxBitmap32.Invert;
begin
  CopyBitmap(Self, NOTSRCCOPY);
end;

procedure TcxBitmap32.Lighten(APercent: Byte);
var
  AColors: TRGBColors;
  I: Integer;
begin
  GetBitmapColors(AColors);
  for I := 0 to Length(AColors) - 1 do
    with AColors[I] do
    begin
      rgbRed := Byte(Trunc(255 - APercent / 100 * (255 - rgbRed)));
      rgbGreen := Byte(Trunc(255 - APercent / 100 * (255 - rgbGreen)));
      rgbBlue := Byte(Trunc(255 - APercent / 100 * (255 - rgbBlue)));
    end;
  SetBitmapColors(AColors);
end;

procedure TcxBitmap32.LoadFromStream(Stream: TStream);
begin
  BeginUpdate;
  try
    inherited LoadFromStream(Stream);
  finally
    PixelFormat := pf32bit;
    EndUpdate;
  end;
end;

procedure TcxBitmap32.MakeOpaque;
begin
  SetAlphaChannel($FF);
end;

procedure TcxBitmap32.RecoverTransparency(ATransparentColor: TColor);
var
  AColors: TRGBColors;
  AColor: TRGBQuad;
  ATransparentBGR: DWORD;
  I: Integer;
begin
  ATransparentBGR := cxColorEssence(dxColorToRGBQuad(ATransparentColor));
  GetBitmapColors(AColors);
  for I := 0 to Length(AColors) - 1 do
  begin
    AColor := AColors[I];
    if cxColorEssence(AColor) = ATransparentBGR then
      Cardinal(AColors[I]) := 0
    else
      if AColor.rgbReserved = 0 then
        AColors[I].rgbReserved := 255;
  end;
  SetBitmapColors(AColors);
end;

procedure TcxBitmap32.SetAlphaChannel(Alpha: Byte);
var
  AColors: TRGBColors;
  I: Integer;
begin
  GetBitmapColors(AColors);
  for I := 0 to Length(AColors) - 1 do
    AColors[I].rgbReserved := Alpha;
  SetBitmapColors(AColors);
end;

procedure TcxBitmap32.Update;
begin
  FIsAlphaUsed := bDefault;
  if cxGetBitmapPixelFormat(Self) <> 32 then
    raise EdxException.Create('Wrong PixelFormat');
end;

procedure TcxBitmap32.Resize(ANewWidth, ANewHeight: Integer; AStretch, ASmooth: Boolean; AFillColor: TColor = clNone);
var
  ABitmap: TcxBitmap32;
begin
  ABitmap := TcxBitmap32.CreateSize(ClientRect);
  try
    ABitmap.CopyBitmap(Self);
    SetSize(ANewWidth, ANewHeight);
    if not AStretch and (AFillColor <> clNone) then
      cxCanvas.FillRect(ClientRect, AFillColor)
    else
      Clear;
    if AStretch then
      ABitmap.AlphaBlend(Self, ClientRect, ASmooth)
    else
      CopyBitmap(ABitmap, cxRectCenter(ClientRect, ABitmap.Width, ABitmap.Height), cxNullPoint);
  finally
    ABitmap.Free;
  end;
end;

function TcxBitmap32.GetIsAlphaUsed: Boolean;
begin
  if FIsAlphaUsed = bDefault then
    FIsAlphaUsed := dxBooleanToDefaultBoolean(dxIsAlphaUsed(Self));
  Result := FIsAlphaUsed = bTrue;
end;

{ TcxAlphaBitmap }

constructor TcxAlphaBitmap.CreateSize(AWidth, AHeight: Integer);
begin
  inherited; //CBUILDER workaround
end;

constructor TcxAlphaBitmap.CreateSize(AWidth, AHeight: Integer; ATransparentBkColor: TRGBQuad);
begin
  inherited CreateSize(AWidth, AHeight, pf32bit);

  TransparentBkColor := ATransparentBkColor;
end;

destructor TcxAlphaBitmap.Destroy;
begin
  FreeAndNil(FTransparentPixels);
  inherited;
end;

procedure TcxAlphaBitmap.Clear;
begin
  if FTransparentBkColor.rgbReserved <> 0 then
    TransformBitmap(btmClear)
  else
    inherited;
end;

procedure TcxAlphaBitmap.DrawHatch(const AHatchData: TcxHatchData);
begin
  HatchData := AHatchData;
  TransformBitmap(btmHatch);
end;

procedure TcxAlphaBitmap.DrawHatch(AColor1, AColor2: TColor; AStep, AAlpha1, AAlpha2: Byte);
var
  AHatchData: TcxHatchData;
begin
  AHatchData.Color1 := dxColorToRGBQuad(AColor1, $FF);
  AHatchData.Alpha1 := AAlpha1;
  AHatchData.Color2 := dxColorToRGBQuad(AColor2, $FF);
  AHatchData.Alpha2 := AAlpha2;
  AHatchData.Step := AStep;
  DrawHatch(AHatchData);
end;

procedure TcxAlphaBitmap.DrawShadow(AMaskBitmap: TcxAlphaBitmap; AShadowSize: Integer; AShadowColor: TColor; AInflateSize: Boolean);
const
  DPSnaa = $00200F09;
var
  AShadowBitmap, ASelfCopy: TcxAlphaBitmap;
begin
  AShadowBitmap := TcxAlphaBitmap.CreateSize(Width + AShadowSize * 2, Height + AShadowSize * 2, ClrNone);
  try
    AShadowBitmap.Clear;
    AShadowBitmap.CopyBitmap(AMaskBitmap, cxRectOffset(ClientRect, AShadowSize, AShadowSize), cxNullPoint);
    AShadowBitmap.Canvas.Brush.Color := AShadowColor;
    AShadowBitmap.Canvas.CopyMode := DPSnaa;
    AShadowBitmap.Canvas.Draw(AShadowSize, AShadowSize, AShadowBitmap);

    AShadowBitmap.TransparentBkColor := ClrTransparent;
    AShadowBitmap.TransformBitmap(btmCorrectBlend);

    ASelfCopy := TcxAlphaBitmap.CreateSize(Width + AShadowSize, Height + AShadowSize, True);
    try
      ASelfCopy.CopyBitmap(Self);
      ASelfCopy.CopyBitmap(AShadowBitmap, ASelfCopy.ClientRect, Point(AShadowSize, AShadowSize), SRCPAINT);
      if AInflateSize then
        SetSize(Width + AShadowSize, Height + AShadowSize);
      CopyBitmap(ASelfCopy);
    finally
      ASelfCopy.Free;
    end;
  finally
    AShadowBitmap.Free;
  end;
end;

procedure TcxAlphaBitmap.RecoverAlphaChannel(ATransparentColor: TColor);
begin
  TransparentPixels.Clear;
  TransparentPixels.Add(ATransparentColor);
  TransparentBkColor := dxColorToRGBQuad(ATransparentColor);
  TransformBitmap(btmCorrectBlend);
end;

procedure TcxAlphaBitmap.RecoverAlphaChannel(ARect: TRect; ATransparentColor: TColor);
var
  ABitmap: TcxAlphaBitmap;
begin
  ABitmap := TcxAlphaBitmap.CreateSize(ARect);
  try
    ABitmap.CopyBitmap(Self, ABitmap.ClientRect, ARect.TopLeft);
    ABitmap.RecoverAlphaChannel(ATransparentColor);
    cxCanvas.SaveClipRegion;
    cxCanvas.SetClipRegion(TcxRegion.Create(ARect), roSet);
    CopyBitmap(ABitmap, ARect, cxNullPoint);
    cxCanvas.RestoreClipRegion;
 finally
    ABitmap.Free;
  end;
end;

procedure TcxAlphaBitmap.ExtractLayer(ATransparentColor: TColor);
begin
  TransparentPixels.Clear;
  TransparentPixels.Add(ColorToRGB(ATransparentColor));
  TransparentBkColor := dxColorToRGBQuad(ATransparentColor);
  TransformBitmap(btmExtractLayer);
end;

procedure TcxAlphaBitmap.Shade(AMaskBitmap: TcxAlphaBitmap);
const
  DSPDxax = $00E20746;
begin
  AMaskBitmap.Canvas.CopyMode := cmPatInvert;
  AMaskBitmap.Canvas.Draw(0, 0, AMaskBitmap);

  Canvas.CopyMode := cmSrcCopy;
  Canvas.Draw(1, 1, AMaskBitmap);

  Canvas.CopyMode := DSPDxax;
  Canvas.Brush.Color := clBtnShadow;
  Canvas.Draw(0, 0, AMaskBitmap);

  TransformBitmap(btmCorrectBlend);
end;

procedure TcxAlphaBitmap.TransformBitmap(AMode: TcxBitmapTransformationMode);
var
  AColors: TRGBColors;
  I, J: Integer;
  ATransformProc: TcxBitmapTransformationProc;
begin
  case AMode of
    btmDingy:
      ATransformProc := Dingy;
    btmDirty:
      ATransformProc := Dirty;
    btmGrayScale:
      ATransformProc := GrayScale;
    btmSetOpaque:
      ATransformProc := SetOpaque;
    btmMakeMask:
      ATransformProc := MakeMask;
    btmFade:
      ATransformProc := Fade;
    btmDisable:
      ATransformProc := Disable;
    btmCorrectBlend:
      ATransformProc := CorrectBlend;
    btmHatch:
      ATransformProc := Hatch;
    btmClear:
      ATransformProc := ClearColor;
    btmResetAlpha:
      ATransformProc := ResetAlpha;
    btmExtractLayer:
      ATransformProc := ExtractLayerProc;
  else
    Exit;
  end;

  GetBitmapColors(AColors);

  for I := 0 to Width - 1 do
    for J := 0 to Height - 1 do
    begin
      FCurrentColorIndex.X := I;
      FCurrentColorIndex.Y := J;

      ATransformProc(AColors[J * Width + I]);
    end;

  SetBitmapColors(AColors);
  Changed(Self);
end;

procedure TcxAlphaBitmap.Initialize(AWidth, AHeight: Integer; APixelFormat: TPixelFormat);
begin
  FTransparentPixels := TcxColorList.Create;
  inherited;
end;

procedure TcxAlphaBitmap.RefreshImage(AWidth, AHeight: Integer);
begin
  SetSize(AWidth, AHeight);
  TransparentPixels.Clear;
  Clear;
end;

procedure TcxAlphaBitmap.RefreshImage(const ARect: TRect);
begin
  RefreshImage(ARect.Width, ARect.Height);
end;

procedure TcxAlphaBitmap.CorrectBlend(var AColor: TRGBQuad);
begin
  if (AColor.rgbReserved = 0) and not IsColorTransparent(AColor) then
    AColor.rgbReserved := $FF;
end;

procedure TcxAlphaBitmap.ClearColor(var AColor: TRGBQuad);
begin
  AColor := TransparentBkColor;
end;

procedure TcxAlphaBitmap.Dingy(var AColor: TRGBQuad);

  procedure LightColor(var AColor: Byte);
  begin
    AColor := GetChannelValue(AColor + MulDiv(255 - AColor, 3, 10));
  end;

  procedure BlendColor(var AColor: Byte);
  begin
    AColor := GetChannelValue(MulDiv(AColor, 200, 255));
  end;

begin
  if not IsColorTransparent(AColor) then
  begin
    if AColor.rgbReserved = $FF then
    begin
      LightColor(AColor.rgbRed);
      LightColor(AColor.rgbGreen);
      LightColor(AColor.rgbBlue);
    end
    else
    begin
      BlendColor(AColor.rgbRed);
      BlendColor(AColor.rgbGreen);
      BlendColor(AColor.rgbBlue);
      BlendColor(AColor.rgbReserved);
    end;
  end;
end;

procedure TcxAlphaBitmap.Dirty(var AColor: TRGBQuad);
var
  ADirtyScreen:TRGBQuad;
begin
  if not IsColorTransparent(AColor) then
  begin
    ScaleColor(AColor, GrayMap);

    ADirtyScreen := dxColorToRGBQuad(clBtnShadow);
    ADirtyScreen.rgbReserved := $C0;

    cxBlendFunction(ADirtyScreen, AColor, $EE);
  end;
end;

procedure TcxAlphaBitmap.Disable(var AColor: TRGBQuad);
begin
  if not IsColorTransparent(AColor) then
    ScaleColor(AColor, DisableMap);
end;

procedure TcxAlphaBitmap.ExtractLayerProc(var AColor: TRGBQuad);
begin
  if IsColorTransparent(AColor) then
    AColor := ClrTransparent;
end;

procedure TcxAlphaBitmap.Fade(var AColor: TRGBQuad);
begin
  if not IsColorTransparent(AColor) then
    ScaleColor(AColor, FadeMap);
end;

procedure TcxAlphaBitmap.GrayScale(var AColor: TRGBQuad);
var
  AValue: Byte;
begin
  if not IsColorTransparent(AColor) then
  begin
    AValue := (AColor.rgbRed + AColor.rgbGreen + AColor.rgbBlue) div 3;
    AColor.rgbRed := AValue;
    AColor.rgbGreen := AValue;
    AColor.rgbBlue := AValue;
  end;
end;

procedure TcxAlphaBitmap.Hatch(var AColor: TRGBQuad);
begin
  if Odd(FCurrentColorIndex.X div FHatchData.Step + FCurrentColorIndex.Y div FHatchData.Step) then
    cxBlendFunction(FHatchData.Color2, AColor, FHatchData.Alpha2)
  else
    cxBlendFunction(FHatchData.Color1, AColor, FHatchData.Alpha1);
end;

procedure TcxAlphaBitmap.MakeMask(var AColor: TRGBQuad);
begin
  if IsColorTransparent(AColor) then
    AColor := ClrNone
  else
    AColor := ClrTransparent;
end;

procedure TcxAlphaBitmap.SetOpaque(var AColor: TRGBQuad);
begin
  AColor.rgbReserved := $FF;
end;

procedure TcxAlphaBitmap.ResetAlpha(var AColor: TRGBQuad);
begin
  AColor.rgbReserved := 0;
end;

procedure TcxAlphaBitmap.ScaleColor(var AColor: TRGBQuad; const AColorMap: TcxColorTransitionMap);
var
  AResultValue: Byte;
begin
  AResultValue := GetChannelValue(Round(AColorMap.RedScale * AColor.rgbRed + AColorMap.GreenScale * AColor.rgbGreen + AColorMap.BlueScale * AColor.rgbBlue));

  AColor.rgbBlue := AResultValue;
  AColor.rgbGreen := AResultValue;
  AColor.rgbRed := AResultValue;
end;

function TcxAlphaBitmap.IsColorTransparent(const AColor: TRGBQuad): Boolean;

  function IsTransparentPixel(AColor: DWORD): Boolean;
  begin
    Result := TransparentPixels.IndexOf(Pointer(AColor)) <> -1;
  end;

begin
  Result := cxColorIsEqual(AColor, TransparentBkColor) or IsTransparentPixel(cxColorEssence(AColor));
end;

{ TcxImageCollection }

constructor TcxImageCollection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TcxImageCollectionItems.Create(Self);
  FListeners := TInterfaceList.Create;
end;

destructor TcxImageCollection.Destroy;
begin
  DoDestroyed;
  FreeAndNil(FItems);
  FreeAndNil(FListeners);
  inherited Destroy;
end;

procedure TcxImageCollection.Assign(Source: TPersistent);
begin
  if Source is TcxImageCollection then
    Items := TcxImageCollection(Source).Items
  else
    inherited Assign(Source);
end;

procedure TcxImageCollection.AddFromMultiFrameImage(ASource: TdxSmartImage);
var
  ACount, I: Integer;
  AFrame: TdxSmartImage;
begin
  ACount := Count;
  Items.BeginUpdate;
  try
    for I := 0 to ASource.AnimationFrameCount - 1 do
    begin
      AFrame := dxImageFrameToGraphic(ASource, I);
      try
        Items.Add.Picture.Graphic := AFrame;
      finally
        AFrame.Free;
      end;
    end;
  finally
    Items.EndUpdate;
  end;
  if ACount <> Count then
    Changed;
end;

function TcxImageCollection.GetAsMultiFrameTIFF: TdxSmartImage;
begin
  Result := GetAsMultiFrameTIFF(cxNullSize, ifmNormal);
end;

function TcxImageCollection.GetAsMultiFrameTIFF(const ASize: TSize; AMode: TcxImageFitMode): TdxSmartImage;
begin
  Result := dxCreateMultiFrameTIFF(Count, ASize, AMode, GetFrame);
end;

procedure TcxImageCollection.AddListener(AListener: IcxImageCollectionListener);
begin
  FListeners.Add(AListener);
end;

procedure TcxImageCollection.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    if Items[I].Owner = Root then Proc(Items[I]);
end;

procedure TcxImageCollection.Changed;
var
  AListener: IcxImageCollectionListener;
  I: Integer;
begin
  for I := FListeners.Count - 1 downto 0 do
  begin
    AListener := FListeners[I] as IcxImageCollectionListener;
    AListener.ImageCollectionChanged;
    AListener := nil;
  end;
end;

procedure TcxImageCollection.DoDestroyed;
var
  AListener: IcxImageCollectionListener;
  I: Integer;
begin
  for I := FListeners.Count - 1 downto 0 do
  begin
    AListener := FListeners[I] as IcxImageCollectionListener;
    AListener.ImageCollectionDestroyed;
    AListener := nil;
  end;
end;

procedure TcxImageCollection.Draw(ACanvas: TCanvas; X, Y, AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < Count) then
    Items[AIndex].Draw(ACanvas, X, Y);
end;

procedure TcxImageCollection.Draw(ACanvas: TCanvas; const R: TRect;
  AIndex: Integer; AStretch: Boolean = True; ASmoothResize: Boolean = False;
  AEnabled: Boolean = True);
begin
  if (AIndex >= 0) and (AIndex < Count) then
    Items[AIndex].Draw(ACanvas, R, AStretch, ASmoothResize, AEnabled);
end;

procedure TcxImageCollection.RemoveListener(AListener: IcxImageCollectionListener);
begin
  if Assigned(FListeners) then
    FListeners.Remove(AListener);
end;

function TcxImageCollection.GetCount: Integer;
begin
  Result := Items.Count;
end;

function TcxImageCollection.GetFrame(AFrameIndex: Integer; const ASize: TSize; AMode: TcxImageFitMode;
  var AFrame: TdxSmartImage): Boolean;
begin
  Result := dxPictureToImage(Items[AFrameIndex].Picture, ASize, AMode, AFrame);
end;

procedure TcxImageCollection.SetItems(AItems: TcxImageCollectionItems);
begin
  FItems.Assign(AItems);
end;

{ TcxImageCollectionItem }

constructor TcxImageCollectionItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
  FPicture.OnChange := DoPictureChanged;
end;

destructor TcxImageCollectionItem.Destroy;
begin
  FreeAndNil(FPicture);
  inherited Destroy;
end;

procedure TcxImageCollectionItem.Assign(Source: TPersistent);
begin
  if Source is TcxImageCollectionItem then
    Picture.Assign(TcxImageCollectionItem(Source).Picture)
  else
    inherited Assign(Source);
end;

procedure TcxImageCollectionItem.Draw(ACanvas: TCanvas; X, Y: Integer);
begin
  Draw(ACanvas, cxRectOffset(ClientRect, X, Y));
end;

procedure TcxImageCollectionItem.Draw(ACanvas: TCanvas; const R: TRect;
  AStretch: Boolean = True; ASmoothResize: Boolean = False; AEnabled: Boolean = True);

  function HasAlphaChannel(AGraphic: TGraphic): Boolean;
  begin
    Result := (AGraphic is TdxPNGImage) or (AGraphic is TIcon) or
      ((AGraphic is TBitmap) and (TBitmap(AGraphic).PixelFormat = pf32bit));
  end;

  function CreateBitmapBuffer: TBitmap;
  begin
    if HasAlphaChannel(Picture.Graphic) then
      Result := TcxBitmap32.CreateSize(Width, Height, True)
    else
      Result := cxCreateBitmap(Width, Height);
  end;

var
  ABitmap: TBitmap;
  ARect: TRect;
begin
  if AStretch then
    ARect := R
  else
    ARect := cxRectCenter(R, Width, Height);

  ABitmap := CreateBitmapBuffer;
  try
    ABitmap.Canvas.Draw(0, 0, Picture.Graphic);
    TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, ARect, R, ABitmap, nil, 0, EnabledImageDrawModeMap[AEnabled], ASmoothResize);
  finally
    ABitmap.Free;
  end;
end;

function TcxImageCollectionItem.GetDisplayName: string;
begin
  Result := inherited GetDisplayName;
  if (Picture.Graphic <> nil) then
   with Picture.Graphic do
     if not Empty then
       Result := Result + Format(' (%dx%d %s)', [Width, Height, ClassName]);
end;

function TcxImageCollectionItem.GetCollectionFromParent(
  AParent: TComponent): TcxComponentCollection;
begin
  Result := (AParent as TcxImageCollection).Items;
end;

procedure TcxImageCollectionItem.DoPictureChanged(Sender: TObject);
begin
  Changed(False);
end;

function TcxImageCollectionItem.GetClientRect: TRect;
begin
  Result := Bounds(0, 0, Width, Height);
end;

function TcxImageCollectionItem.GetHeight: Integer;
begin
  Result := Picture.Height;
end;

function TcxImageCollectionItem.GetWidth: Integer;
begin
  Result := Picture.Width;
end;

procedure TcxImageCollectionItem.SetPicture(AValue: TPicture);
begin
  FPicture.Assign(AValue);
end;

{ TcxImageCollectionItems }

constructor TcxImageCollectionItems.Create(ACollection: TcxImageCollection);
begin
  inherited Create(ACollection, TcxImageCollectionItem);
  FCollection := ACollection;
end;

function TcxImageCollectionItems.Add: TcxImageCollectionItem;
begin
  Result := TcxImageCollectionItem(inherited Add);
end;

function TcxImageCollectionItems.FindItemByName(
  const AName: string; out AItem: TcxImageCollectionItem): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    Result := SameText(Items[I].Name, AName);
    if Result then
    begin
      AItem := Items[I];
      Break;
    end;
  end;
end;

function TcxImageCollectionItems.FindItemByID(ID: Integer): TcxImageCollectionItem;
begin
  Result := TcxImageCollectionItem(inherited FindItemByID(ID));
end;

function TcxImageCollectionItems.GetItem(Index: Integer): TcxImageCollectionItem;
begin
  Result := TcxImageCollectionItem(inherited Items[Index]);
end;

function TcxImageCollectionItems.Insert(Index: Integer): TcxImageCollectionItem;
begin
  Result := TcxImageCollectionItem(inherited Insert(Index));
end;

procedure TcxImageCollectionItems.SetItem(Index: Integer; AValue: TcxImageCollectionItem);
begin
  inherited Items[Index] := AValue;
end;

procedure TcxImageCollectionItems.SetItemName(AItem: TcxComponentCollectionItem; ABaseIndex: Integer = -1);
begin
  AItem.Name := CreateUniqueName(FCollection.Owner, FCollection, AItem, 'TcxImageCollection', '', ABaseIndex);
end;

procedure TcxImageCollectionItems.Update(AItem: TcxComponentCollectionItem; AAction: TcxComponentCollectionNotification);
begin
  inherited Update(AItem, AAction);
  FCollection.Changed;
end;

{ TcxSystemImageList }

constructor TcxSystemImageList.Create(AOwner: TComponent);
begin
  inherited;
  FSourceDPI := dxGetSystemDPI;
end;

function TcxSystemImageList.GetSourceDPI: Integer;
begin
  Result := FSourceDPI;
end;

{ TdxSolidBrushCacheManager }

procedure TdxSolidBrushCacheManager.DoRemove(const Value: TBrushHandle);
begin
  DeleteObject(Value);
end;

{ TdxSolidBrushCache }

class function TdxSolidBrushCache.Get(const AColor: TColor): TBrushHandle;
begin
  if not FData.Get(AColor, Result) then
  begin
    Result := CreateSolidBrush(ColorToRGB(AColor));
    FData.Add(AColor, Result);
  end;
end;

class procedure TdxSolidBrushCache.Clear;
begin
  FData.Clear;
end;

class procedure TdxSolidBrushCache.Finalize;
begin
  FreeAndNil(FSystemPaletteChangedNotifier);
  FreeAndNil(FData);
end;

class procedure TdxSolidBrushCache.Initialize;
var
  ANotifier: TcxSystemPaletteChangedNotifier;
begin
  FData := TdxSolidBrushCacheManager.Create(Capacity);

  ANotifier := TcxSystemPaletteChangedNotifier.Create(True);
  ANotifier.OnSystemPaletteChanged := Clear;
  FSystemPaletteChangedNotifier := ANotifier;
end;

{ TdxColorUtils }

class function TdxColorUtils.AlphaColorToHSL(AColor: TdxAlphaColor): TdxHSL;
begin
  Result := RGBToHSL(dxAlphaColorToRGBQuad(AColor));
end;

class function TdxColorUtils.AlphaColorToHSL(AColor: TdxAlphaColor; out AAlpha: Byte): TdxHSL;
var
  ARgb: TRGBQuad;
begin
  ARgb := dxAlphaColorToRGBQuad(AColor);
  AAlpha := ARgb.rgbReserved;
  Result := RGBToHSL(ARgb);
end;

class function TdxColorUtils.ColorToHSL(AColor: TColor): TdxHSL;
begin
  if cxColorIsValid(AColor) then
    Result := RGBToHSL(dxColorToRGBQuad(AColor))
  else
    FillChar(Result, SizeOf(Result), 0);
end;

class function TdxColorUtils.ColorToHSV(AColor: TColor): TdxHSV;
begin
  if cxColorIsValid(AColor) then
    Result := RGBToHSV(dxColorToRGBQuad(AColor))
  else
    FillChar(Result, SizeOf(Result), 0);
end;

class function TdxColorUtils.HSLToAlphaColor(const AHSL: TdxHSL; AAlpha: Byte = MaxByte): TdxAlphaColor;
var
  ARgb: TRGBQuad;
begin
  HSLToRGB(AHSL.H, AHSL.S, AHSL.L, ARgb.rgbRed, ARgb.rgbGreen, ARgb.rgbBlue);
  ARgb.rgbReserved := AAlpha;
  Result := dxRGBQuadToAlphaColor(ARgb);
end;

class function TdxColorUtils.HSLToColor(const AHSL: TdxHSL): TColor;
begin
  Result := HSLToColor(AHSL.H, AHSL.S, AHSL.L);
end;

class function TdxColorUtils.HSLToColor(const H, S, L: Double): TColor;
var
  R, G, B: Byte;
begin
  HSLToRGB(H, S, L, R, G, B);
  Result := RGB(R, G, B);
end;

class function TdxColorUtils.HSLToRGB(const AHSL: TdxHSL): TRGBQuad;
begin
  Result := HSLToRGB(AHSL.H, AHSL.S, AHSL.L);
end;

class function TdxColorUtils.HSLToRGB(const H, S, L: Double): TRGBQuad;
begin
  HSLToRGB(H, S, L, Result.rgbRed, Result.rgbGreen, Result.rgbBlue);
  Result.rgbReserved := MaxByte;
end;

class procedure TdxColorUtils.HSLToRGB(const H, S, L: Double; out R, G, B: Byte);

  function HueToColor(const AHue, M1, M2: Double): Byte;
  var
    AValue, AHue6: Double;
  begin
    AHue6 := 6 * (AHue - Floor(AHue));
    if AHue6 < 1 then
      AValue := M1 + (M2 - M1) * AHue6
    else

    if AHue6 < 3 then
      AValue := M2
    else

    if AHue6 < 4 then
      AValue := M1 + (M2 - M1) * (4 - AHue6)
    else
      AValue := M1;

    Result := Round(255 * AValue);
  end;

var
  M1, M2: Double;
begin
  if S = 0 then
  begin
    R := Round(255 * L);
    G := R;
    B := R;
  end
  else
  begin
    if L <= 0.5 then
      M2 := L * (1 + S)
    else
      M2 := L * (1 - S) + S;

    M1 := 2 * L - M2;
    R := HueToColor(H + 1 / 3, M1, M2);
    G := HueToColor(H, M1, M2);
    B := HueToColor(H - 1 / 3, M1, M2);
  end;
end;

class function TdxColorUtils.HSVToColor(const AHSV: TdxHSV): TColor;
begin
  Result := HSVToColor(AHSV.H, AHSV.S, AHSV.V);
end;

class function TdxColorUtils.HSVToColor(const H, S, V: Double): TColor;

  function GetColor(R, G, B: Byte): TColor;
  var
    ARGB: TRGBQuad;
  begin
    ARGB.rgbRed := R;
    ARGB.rgbGreen := G;
    ARGB.rgbBlue := B;
    ARGB.rgbReserved :=0;
    Result := dxRGBQuadToColor(ARGB);
  end;

var
  AMax, AMin, ASector: Byte;
  AMid_1, AMid_2: Byte;
  AFrac: Double;
begin
  AMax := Round(V * 255);
  AMin := Round(AMax * (1 - S));
  ASector := Trunc(H / 60) mod 6;
  AFrac := H / 60 - ASector;
  AMid_1 := Round(AMax * (1 - AFrac * S));
  AMid_2 := Round(AMax * (1 - (1 - AFrac) * S));
  case ASector of
    0: Result := GetColor(AMax, AMid_2, AMin);
    1: Result := GetColor(AMid_1, AMax, AMin);
    2: Result := GetColor(AMin, AMax, AMid_2);
    3: Result := GetColor(AMin, AMid_1, AMax);
    4: Result := GetColor(AMid_2, AMin, AMax);
  else
    Result := GetColor(AMax, AMin, AMid_1); //5
  end;
end;

class function TdxColorUtils.InvertLightness(AColor: TColor): TColor;
var
  AHSL: TdxHSL;
begin
  AHSL := ColorToHSL(AColor);
  AHSL.L := 1 - AHSL.L;
  Result := HSLToColor(AHSL);
end;

class function TdxColorUtils.InvertLightness(AColor: TdxAlphaColor): TdxAlphaColor;
var
  AHSL: TdxHSL;
  ARgb: TRGBQuad;
begin
  ARgb := dxAlphaColorToRGBQuad(AColor);
  AHSL := RGBToHSL(ARgb);
  AHSL.L := 1 - AHSL.L;
  Result := HSLToAlphaColor(AHSL, ARgb.rgbReserved);
end;

class function TdxColorUtils.Luminance(const R, G, B: Byte): Double;
begin
  Result := ComponentToXYZ(R) * 0.2126 + ComponentToXYZ(G) * 0.7152 + ComponentToXYZ(B) * 0.0722;
end;

class function TdxColorUtils.Luminance(const AColor: TColor): Double;
begin
  with dxColorToRGBQuad(AColor) do
    Result := Luminance(rgbRed, rgbGreen, rgbBlue);
end;

class function TdxColorUtils.RGBToHSL(const ARGB: TRGBQuad): TdxHSL;
var
  R, G, B, D, CMax, CMin: Double;
begin
  R := ARGB.rgbRed / MaxByte;
  G := ARGB.rgbGreen / MaxByte;
  B := ARGB.rgbBlue / MaxByte;

  CMax := Max(R, Max(G, B));
  CMin := Min(R, Min(G, B));
  Result.L := (CMax + CMin) / 2;

  D := CMax - CMin;
  if D <> 0 then
  begin
    if Result.L < 0.5 then
      Result.S := D / (CMax + CMin)
    else
      Result.S := D / (2 - CMax - CMin);

    if R = CMax then
      Result.H := (G - B) / D
    else
      if G = Cmax then
        Result.H := 2 + (B - R) / D
      else
        Result.H := 4 + (R - G) / D;

    Result.H := Result.H / 6;
    if Result.H < 0 then
      Result.H := Result.H + 1;
  end
  else
  begin
    Result.H := 0;
    Result.S := 0;
  end;
end;

class function TdxColorUtils.RGBToHSV(const ARGB: TRGBQuad): TdxHSV;
var
  AMax, AMin: Byte;
begin
  AMax := Max(Max(ARGB.rgbBlue, ARGB.rgbGreen), ARGB.rgbRed);
  AMin := Min(Min(ARGB.rgbBlue, ARGB.rgbGreen), ARGB.rgbRed);

  Result.V := AMax / 255;

  if Result.V = 0 then
    Result.S := 0
  else
    Result.S := 1 - AMin / AMax;

  if AMax = AMin then
    Result.H := 0
  else

  if AMax = ARGB.rgbRed then
    Result.H := 60 * (ARGB.rgbGreen - ARGB.rgbBlue) / (AMax - AMin) + 0
  else

  if AMax = ARGB.rgbGreen then
    Result.H := 60 * (ARGB.rgbBlue - ARGB.rgbRed) / (AMax - AMin) + 120
  else

  if AMax = ARGB.rgbBlue then
    Result.H := 60 * (ARGB.rgbRed - ARGB.rgbGreen) / (AMax - AMin) + 240;

  if Result.H < 0 then
    Result.H := Result.H + 360;
end;

class function TdxColorUtils.ChangeLightness(AColor: TColor; const ALightnessDelta: Double): TColor;
var
  HSL: TdxHSL;
begin
  HSL := TdxColorUtils.ColorToHSL(AColor);
  HSL.L := EnsureRange(HSL.L + ALightnessDelta, 0, 1);
  Result := TdxColorUtils.HSLToColor(HSL);
end;

class function TdxColorUtils.ChangeSaturation(AColor: TColor; const ASaturationDelta: Double): TColor;
var
  HSL: TdxHSL;
begin
  HSL := TdxColorUtils.ColorToHSL(AColor);
  HSL.S := EnsureRange(HSL.S + ASaturationDelta, 0, 1);
  Result := TdxColorUtils.HSLToColor(HSL);
end;

class function TdxColorUtils.Colorize(ABaseColor, AColor: TColor): TColor;
var
  AHSL: TdxHSL;
begin
  AHSL := ColorToHSL(ABaseColor);
  AHSL.S := EnsureRange(AHSL.S, 0.6, 0.9);
  AHSL.L := EnsureRange(AHSL.L, 0.4, 0.8);
  Result := HSLToColor(ColorToHSL(AColor).H, AHSL.S, AHSL.L);
end;

class function TdxColorUtils.ComponentToXYZ(const AComponent: Byte): Double;
begin
  Result := AComponent / MaxByte;
  if Result < 0.04045 then
    Result := Result / 12.92
  else
    Result := Power((Result + 0.055) / 1.055, 2.4);
end;

class function TdxColorUtils.Contrast(const AForegroundColor, ABackgroundColor: TColor): Double;
var
  ABackgroundLuminance: Double;
  AForegroundLuminance: Double;
begin
  ABackgroundLuminance := Luminance(ABackgroundColor) + 0.05;
  AForegroundLuminance := Luminance(AForegroundColor) + 0.05;
  Result := Max(ABackgroundLuminance, AForegroundLuminance) / Min(ABackgroundLuminance, AForegroundLuminance);
end;

class function TdxColorUtils.MakeForegroundColor(ABackgroundColor: TColor): TColor;

  function Test(const AColorToTest: TColor; var AResultColor: TColor): Boolean;
  begin
    Result := Contrast(AColorToTest, ABackgroundColor) > DefaultTextContrast;
    if Result then
      AResultColor := AColorToTest
  end;

var
  AHSL: TdxHSL;
begin
  AHSL := ColorToHSL(ABackgroundColor);
  if Test(HSLToColor(AHSL.H, AHSL.S, 0.05), Result) then
    Exit;
  if Test(HSLToColor(AHSL.H, AHSL.S, 0.95), Result) then
    Exit;
  Result := clDefault;
end;

class function TdxColorUtils.MultiplyLightness(AColor: TColor; const AFactor: Double): TColor;
var
  AValue: TdxHSL;
begin
  AValue := TdxColorUtils.ColorToHSL(AColor);
  Result := TdxColorUtils.HSLToColor(AValue.H, AValue.S, AValue.L * AFactor);
end;

{ TdxColorPaletteBuilder }

constructor TdxColorPaletteBuilder.Create(const ABaseColor: TColor);
begin
  Create(dxColorToRGBQuad(ABaseColor, MaxByte));
end;

constructor TdxColorPaletteBuilder.Create(const ABaseColor: TdxAlphaColor);
begin
  Create(dxAlphaColorToRGBQuad(ABaseColor))
end;

constructor TdxColorPaletteBuilder.Create(const ABaseColor: TRGBQuad);
begin
  FBaseColor := TdxColorUtils.RGBToHSL(ABaseColor);
end;

procedure TdxColorPaletteBuilder.Build(ATargetList: TdxAlphaColorList; ABasePalette: array of TdxAlphaColor);
begin
  EnsureCapacity(ATargetList, 3 * Length(ABasePalette));
  Build(ATargetList, ABasePalette, 0);
  Build(ATargetList, ABasePalette, -DefaultLightnessDelta);
  Build(ATargetList, ABasePalette,  DefaultLightnessDelta);
end;

procedure TdxColorPaletteBuilder.Build(ATargetList: TdxColorList; ABasePalette: array of TColor);
begin
  EnsureCapacity(ATargetList, 3 * Length(ABasePalette));
  Build(ATargetList, ABasePalette, 0);
  Build(ATargetList, ABasePalette, -DefaultLightnessDelta);
  Build(ATargetList, ABasePalette,  DefaultLightnessDelta);
end;

procedure TdxColorPaletteBuilder.Build(ATargetList: TdxColorList; ABasePalette: array of TColor; ALightnessDelta: Single);
var
  I: Integer;
begin
  EnsureCapacity(ATargetList, Length(ABasePalette));
  for I := 0 to Length(ABasePalette) - 1 do
    ATargetList.Add(dxAlphaColorToColor(Build(dxColorToAlphaColor(ABasePalette[I]), ALightnessDelta)));
end;

function TdxColorPaletteBuilder.Build(AColor: TdxAlphaColor; ALightnessDelta: Single = 0): TdxAlphaColor;
var
  AHSL: TdxHSL;
begin
  if dxAlphaColorIsValid(AColor) then
  begin
    AHSL := TdxColorUtils.RGBToHSL(dxAlphaColorToRGBQuad(AColor));
    AHSL.L := EnsureRange(FBaseColor.L, MinBaseLightness, MaxBaseLightness);
    AHSL.S := Max(FBaseColor.S, MinSaturation);
    if ALightnessDelta <> 0 then
      AHSL.L := EnsureRange(AHSL.L + ALightnessDelta, MinLightness, MaxLightness);
    Result := dxRGBQuadToAlphaColor(TdxColorUtils.HSLToRGB(AHSL));
  end
  else
    Result := AColor;
end;

procedure TdxColorPaletteBuilder.Build(ATargetList: TdxAlphaColorList; ABasePalette: array of TdxAlphaColor; ALightnessDelta: Single);
var
  I: Integer;
begin
  EnsureCapacity(ATargetList, Length(ABasePalette));
  for I := 0 to Length(ABasePalette) - 1 do
    ATargetList.Add(Build(ABasePalette[I], ALightnessDelta));
end;

procedure TdxColorPaletteBuilder.EnsureCapacity(AList: TdxColorList; ACount: Integer);
begin
  AList.Capacity := Max(AList.Capacity, AList.Count + ACount);
end;

procedure TdxColorPaletteBuilder.EnsureCapacity(AList: TdxAlphaColorList; ACount: Integer);
begin
  AList.Capacity := Max(AList.Capacity, AList.Count + ACount);
end;

{ TdxAdjustFontSizeCustomHelper }

constructor TdxAdjustFontSizeCustomHelper.Create;
begin
  inherited Create;
  FFont := TFont.Create;
  FAllowAdjustLineSpacing := True;
  FLineSpacing := 1;
end;

destructor TdxAdjustFontSizeCustomHelper.Destroy;
begin
  FreeAndNil(FFont);
  inherited Destroy;
end;

procedure TdxAdjustFontSizeCustomHelper.Calculate(const AAvailableWidth: Integer; const AText: string);
begin
  BeforeCalculate;
  try
    FFlags := 0;
    FWidth := 0;
    Font.Size := CalculateCore(AAvailableWidth, Font.Size, GetMinFontSize, AText, DoMeasureTextWidth, CheckFontSize);
  finally
    AfterCalculate;
  end;
end;

procedure TdxAdjustFontSizeCustomHelper.Calculate(const AAvailableSize: TSize;
  const AText: string; AMultiline: Boolean; AFlags: Cardinal; AMaxFontSize: Integer = -1);
begin
  BeforeCalculate;
  try
    FFlags := AFlags;
    if AMaxFontSize < 0 then
      AMaxFontSize := Font.Size;
    if AMultiline then
    begin
      FWidth := AAvailableSize.cx;
      if AllowAdjustLineSpacing then
      begin
        FLineSpacing := CalculateCore(AAvailableSize.cy, LineSpacingScaleFactor,
          Round(GetMinLineSpacing * LineSpacingScaleFactor), AText, DoMeasureTextHeight1, nil) / LineSpacingScaleFactor;
      end;
      Font.Size := CalculateCore(AAvailableSize.cy, AMaxFontSize, GetMinFontSize, AText, DoMeasureTextHeight2, CheckFontSize);
    end
    else
    begin
      Font.Size := CalculateCore(AAvailableSize.cx, AMaxFontSize, GetMinFontSize, AText, DoMeasureTextWidth, CheckFontSize);
      Font.Size := CalculateCore(AAvailableSize.cy, Font.Size, GetMinFontSize, AText, DoMeasureTextHeight2, CheckFontSize);
    end;
  finally
    AfterCalculate;
  end;
end;

{$IFDEF DELPHIXE8}
procedure TdxAdjustFontSizeCustomHelper.CalculateHeight(const AAvailableWidth: Integer; const AText: string);
begin
  BeforeCalculate;
  try
    FFlags := 0;
    FWidth := 0;
    Font.Height := CalculateCoreHeight(AAvailableWidth, Font.Height, GetMinFontHeight, AText, DoMeasureTextWidthUsingFontHeight, CheckFontHeight);
  finally
    AfterCalculate;
  end;
end;
{$ENDIF}

procedure TdxAdjustFontSizeCustomHelper.AfterCalculate;
begin
  // do nothing
end;

procedure TdxAdjustFontSizeCustomHelper.BeforeCalculate;
begin
  // do nothing
end;

function TdxAdjustFontSizeCustomHelper.CompareTextSize(ATextSize, AAvailableSize: Integer): Integer;
begin
  Result := ATextSize - AAvailableSize;
end;

function TdxAdjustFontSizeCustomHelper.CalculateCore(AAvailableSize, AParam, AParamLow: Integer;
  const AText: string; AMeasureFunc: TMeasureTextFunc; ACheckParamFunc: TCheckParamFunc): Integer;
var
  ALastSuitableParam: Integer;
  AParamHigh: Integer;
  ATextSize, ACompare: Integer;
begin
  Result := AParam;
  ATextSize := AMeasureFunc(AText, AParam);
  ACompare := CompareTextSize(ATextSize, AAvailableSize);
  if ACompare > 0 then
  begin
    ALastSuitableParam := -1;
    AParamHigh := AParam;
    while AParamLow <= AParamHigh do
    begin
      Result := (AParamLow + AParamHigh) div 2;
      ATextSize := AMeasureFunc(AText, Result);
      ACompare := CompareTextSize(ATextSize, AAvailableSize);
      if ACompare > 0 then
        AParamHigh := Result - 1
      else
      begin
        ALastSuitableParam := Result;
        if ACompare < 0 then
          AParamLow := Result + 1
        else
          Break;
      end;
    end;
    if ALastSuitableParam > 0 then
      Result := ALastSuitableParam
    else
      Result := AParam;

    if ATextSize > AAvailableSize then
    begin
      if Assigned(ACheckParamFunc) then
        Result := ACheckParamFunc(ALastSuitableParam, AParam, AParamLow);
    end;
  end;
end;

function TdxAdjustFontSizeCustomHelper.CalculateCoreHeight(
  AAvailableWidth, AParam, AParamLow: Integer; const AText: string;
  AMeasureFunc: TMeasureTextFunc;
  ACheckParamFunc: TCheckParamFunc): Integer;
var
  ALastSuitableParam: Integer;
  AParamHigh: Integer;
  ATextWidth: Integer;
begin
  Result := AParam;
  ATextWidth := AMeasureFunc(AText, AParam);
  if ATextWidth > AAvailableWidth then
  begin
    ALastSuitableParam := 1;
    AParamHigh := AParam;
    while AParamLow >= AParamHigh do
    begin
      Result := (AParamLow + AParamHigh) div 2;
      ATextWidth := AMeasureFunc(AText, Result);
      if ATextWidth > AAvailableWidth then
        AParamHigh := Result + 1
      else
      begin
        ALastSuitableParam := Result;
        if ATextWidth < AAvailableWidth then
          AParamLow := Result - 1
        else
          Break;
      end;
    end;

    if ALastSuitableParam < 0 then
      Result := ALastSuitableParam
    else
      Result := AParam;

    if ATextWidth > AAvailableWidth then
    begin
      if Assigned(ACheckParamFunc) then
        Result := ACheckParamFunc(ALastSuitableParam, AParam, AParamLow);
    end;
  end;
end;

function TdxAdjustFontSizeCustomHelper.CheckFontHeight(ALastSuitableHeight,
  AOriginalHeight, AMinHeight: Integer): Integer;
begin
  if ALastSuitableHeight < 0 then
    Result := ALastSuitableHeight
  else
    Result := AMinHeight;
end;

function TdxAdjustFontSizeCustomHelper.CheckFontSize(ALastSuitableSize, AOriginalSize, AMinSize: Integer): Integer;
begin
  if ALastSuitableSize > 0 then
    Result := ALastSuitableSize
  else
    Result := AMinSize;
end;

{$IFDEF DELPHIXE8}
function TdxAdjustFontSizeCustomHelper.GetMinFontHeight: Integer;
begin
  Result := -1;
end;
{$ENDIF}

function TdxAdjustFontSizeCustomHelper.GetMinLineSpacing: Single;
begin
  Result := 0.8;
end;

function TdxAdjustFontSizeCustomHelper.DoMeasureTextHeight1(const AText: string; ALineSpacing: Integer): Integer;
begin
  Result := GetTextHeight(AText, FWidth, ALineSpacing / LineSpacingScaleFactor);
end;

function TdxAdjustFontSizeCustomHelper.DoMeasureTextHeight2(const AText: string; AFontSize: Integer): Integer;
begin
  Font.Size := AFontSize;
  Result := GetTextHeight(AText, FWidth, LineSpacing);
end;

function TdxAdjustFontSizeCustomHelper.DoMeasureTextWidth(const AText: string; AFontSize: Integer): Integer;
begin
  Font.Size := AFontSize;
  Result := GetTextWidth(AText);
end;

{$IFDEF DELPHIXE8}
function TdxAdjustFontSizeCustomHelper.DoMeasureTextWidthUsingFontHeight(
  const AText: string; AFontHeight: Integer): Integer;
begin
  Font.Height := AFontHeight;
  Result := GetTextWidth(AText);
end;
{$ENDIF}

procedure TdxAdjustFontSizeCustomHelper.SetFont(AValue: TFont);
begin
  FFont.Assign(AValue);
end;

{ TdxAdjustFontSizeHelper }

constructor TdxAdjustFontSizeHelper.Create;
begin
  inherited Create;
  FZoomFactor := 100;
  AllowAdjustLineSpacing := False;
end;

procedure TdxAdjustFontSizeHelper.AfterCalculate;
begin
  if ZoomFactor <> 100 then
    SetWorldTransform(cxMeasureCanvas.Canvas.Handle, FPrevXForm);
end;

procedure TdxAdjustFontSizeHelper.BeforeCalculate;
begin
  if ZoomFactor <> 100 then
    dxSetZoomFactor(cxMeasureCanvas, ZoomFactor, FPrevXForm);
end;

function TdxAdjustFontSizeHelper.GetMinFontSize: Integer;
begin
  Result := 1;
end;

function TdxAdjustFontSizeHelper.GetTextHeight(const AText: string; AWidth: Integer; ALineSpacing: Single): Integer;
var
  ATextRect: TRect;
  AMeasureDC: HDC;
begin
  AMeasureDC := cxMeasureCanvas.Canvas.Handle;
  SelectObject(AMeasureDC, Font.Handle);
  ATextRect.Init(0, 0, AWidth, 2 * cxTextSpace);
  Windows.DrawText(AMeasureDC, PChar(AText), Length(AText), ATextRect, FFlags or DT_CALCRECT);
  Result := ATextRect.Height;
end;

function TdxAdjustFontSizeHelper.GetTextWidth(const AText: string): Integer;
begin
  Result := cxTextExtent(Font.Handle, AText).cx;
end;

{ TdxImageAnimationController }

destructor TdxImageAnimationController.Destroy;
begin
  DeactivateTimer;
  inherited Destroy;
end;

procedure TdxImageAnimationController.ActivateTimer;
begin
  if FTimer = nil then
  begin
    FTimer := TcxTimer.Create(nil);
    Timer.OnTimer := TimerHandler;
    Timer.Interval := Image.AnimationFrameDelay;
    Timer.Enabled := True;
  end;
end;

procedure TdxImageAnimationController.DeactivateTimer;
begin
  FreeAndNil(FTimer);
end;

function TdxImageAnimationController.IsTimerActive: Boolean;
begin
  Result := (Timer <> nil) and Timer.Enabled;
end;

{ TdxImageListPaintCache.TImageListCacheHelper.TImages.TImageComparer }

function TdxImageListPaintCache.TImageIdComparer.Equals(const Left, Right: TdxDrawImageCacheID): Boolean;
begin
  Result := Left.IsEqual(Right);
end;

function TdxImageListPaintCache.TImageIdComparer.GetHashCode(const Value: TdxDrawImageCacheID): Integer;
begin
  Result := Value.GetHashCode;
end;

{ TdxImageListPaintCache.TImageListCacheHelper.TImages }

constructor TdxImageListPaintCache.TImageListCacheHelper.TImages.Create(ACapacity: Integer);
begin
  inherited Create([doOwnsValues], ACapacity, TImageIdComparer.Create);
end;

{ TdxImageListPaintCache }

constructor TdxImageListPaintCache.TImageListCacheHelper.Create(AImages: TCustomImageList; AMaxSizeCount: Integer = 0);
begin
  inherited Create(nil);
  FImageList := AImages;
  if AMaxSizeCount = 0 then
    AMaxSizeCount := Screen.MonitorCount * 2;
  FMaxSizeCount := AMaxSizeCount;
  FLastSize := cxInvalidSize;
  FSizedImages := TSizeImages.Create([doOwnsValues], FMaxSizeCount);
  FSizes := TQueue<TSize>.Create;
  FSizes.Capacity := FMaxSizeCount;
  AImages.FreeNotification(Self);
  if not (AImages is TcxCustomImageList) then
  begin
    FImagesChangeLink := TChangeLink.Create;
    FImagesChangeLink.OnChange := ImageListChanged;
  end;
end;

destructor TdxImageListPaintCache.TImageListCacheHelper.Destroy;
begin
  FreeAndNil(FImagesChangeLink);
  FreeAndNil(FSizedImages);
  FreeAndNil(FSizes);
  inherited Destroy;
end;

function TdxImageListPaintCache.TImageListCacheHelper.GetImage(
  const ABounds: TRect; AIndex: Integer; ADrawMode: TcxImageDrawMode; AUseLeftBottomPixelAsTransparent: Boolean;
  const APalette: IdxColorPalette; ASmoothImage: Boolean): TdxGPImage;
var
  AImageID: TdxDrawImageCacheID;
  AImages: TImages;
  ASize: TSize;
begin
  ASize := ABounds.Size;
  if ASize.IsEqual(FLastSize) then
    AImages := FLastImages
  else
  begin
    if not FSizedImages.TryGetValue(ASize, AImages) then
    begin
      if FSizes.Count = FMaxSizeCount then
        FSizedImages.Remove(FSizes.Dequeue);
      FSizes.Enqueue(ASize);
      AImages := TImages.Create(FImageList.Count);
      FSizedImages.Add(ASize, AImages);
    end;
    FLastSize := ASize;
    FLastImages := AImages;
  end;

  AImageID := TdxDrawImageCacheID.Create(nil, ImageList, AIndex, ADrawMode,
    AUseLeftBottomPixelAsTransparent, ASmoothImage, clNone, APalette);
  if not AImages.TryGetValue(AImageID, Result) then
  begin
    Result := TdxGPImage.Create;
    PrepareImage(Result, ASize, AImageID, APalette);
    AImages.Add(AImageID, Result);
  end;
end;

procedure TdxImageListPaintCache.TImageListCacheHelper.Draw(
  ADC: THandle; const ABounds: TRect; AIndex: Integer; ADrawMode: TcxImageDrawMode;
  AUseLeftBottomPixelAsTransparent: Boolean; const APalette: IdxColorPalette; ASmoothImage: Boolean);
begin
  GetImage(ABounds, AIndex, ADrawMode, AUseLeftBottomPixelAsTransparent,
    APalette, ASmoothImage).StretchDraw(ADC, ABounds);
end;

procedure TdxImageListPaintCache.TImageListCacheHelper.Draw(
  AGraphic: TdxGPGraphics; const ABounds: TRect; AIndex: Integer; ADrawMode: TcxImageDrawMode;
  AUseLeftBottomPixelAsTransparent: Boolean; const APalette: IdxColorPalette);
begin
  AGraphic.Draw(GetImage(ABounds, AIndex, ADrawMode, AUseLeftBottomPixelAsTransparent, APalette, True), ABounds);
end;

procedure TdxImageListPaintCache.TImageListCacheHelper.Invalidate;
begin
  FLastSize := cxInvalidSize;
  FSizes.Clear;
  FSizedImages.Clear;
end;

procedure TdxImageListPaintCache.TImageListCacheHelper.ImageListChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TdxImageListPaintCache.TImageListCacheHelper.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FImageList) then
  begin
    RemoveFreeNotification(AComponent);
    TdxImageListPaintCache.RemoveHelper(Self);
  end;
end;

{ TdxDrawImageCacheID }

constructor TdxDrawImageCacheID.Create(
  AGlyph: TGraphic; AImageList: TCustomImageList; AImageIndex: Integer; ADrawMode: TcxImageDrawMode;
  AUseLeftBottomPixelAsTransparent, ASmoothImage: Boolean; ATransparentColor: TColor;
  const APalette: IdxColorPalette; ABrushHandle: HBRUSH);
begin
  Glyph := AGlyph;
  ImageList := AImageList;
  ImageIndex := AImageIndex;
  DrawMode := ADrawMode;
  UseLeftBottomPixelAsTransparent := AUseLeftBottomPixelAsTransparent;
  SmoothImage := ASmoothImage;
  TransparentColor := ATransparentColor;
  PaletteID := dxGetColorPaletteID(APalette);
  BrushHandle := ABrushHandle;
end;

function TdxDrawImageCacheID.GetHashCode: Integer;
begin
  Result := dxBobJenkinsHash(Self, SizeOf(Self), 0);
end;

function TdxDrawImageCacheID.IsEqual(const ID: TdxDrawImageCacheID): Boolean;
begin
  Result := CompareMem(@Self, @ID, SizeOf(Self));
end;

procedure TdxDrawImageCacheID.Reset;
begin
  ZeroMemory(@Self, SizeOf(Self));
end;

{ TdxImageListPaintCache }

class constructor TdxImageListPaintCache.Initialize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorStarted(UnitName, 'TdxImageListPaintCache.Initialize', SysInit.HInstance);{$ENDIF}
  FImages := TObjectDictionary<TCustomImageList, TImageListCacheHelper>.Create([doOwnsValues]);
  FLastImages := nil;
  FLastHelper := nil;
  FTransferBitmap := TcxAlphaBitmap.Create;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorFinished(UnitName, 'TdxImageListPaintCache.Initialize', SysInit.HInstance);{$ENDIF}
end;

{$HINTS OFF}
class destructor TdxImageListPaintCache.Finalize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TdxImageListPaintCache.Finalize', SysInit.HInstance);{$ENDIF}
  FreeAndNil(FTransferBitmap);
  FreeAndNil(FImages);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TdxImageListPaintCache.Finalize', SysInit.HInstance);{$ENDIF}
end;
{$HINTS ON}

class procedure TdxImageListPaintCache.RemoveHelper(AHelper: TImageListCacheHelper);
begin
  if FLastHelper = AHelper then
  begin
    FLastHelper := nil;
    FLastImages := nil;
  end;
  FImages.Remove(AHelper.ImageList);
end;

class procedure TdxImageListPaintCache.SetupHelper(AImages: TCustomImageList);
var
  AHelper: TImageListCacheHelper;
begin
  Assert(AImages <> nil);
  if AImages <> FLastImages then
  begin
    if not FImages.TryGetValue(AImages, AHelper) then
    begin
      AHelper := TImageListCacheHelper.Create(AImages);
      FImages.Add(AImages, AHelper);
    end;
    FLastHelper := AHelper;
    FLastImages := AImages;
  end;
end;

class procedure TdxImageListPaintCache.Draw(ADC: THandle; const ABounds: TRect; AImages: TCustomImageList;
  AIndex: Integer; ADrawMode: TcxImageDrawMode; AUseLeftBottomPixelAsTransparent: Boolean;
  APalette: IdxColorPalette; ASmoothImage: Boolean);
begin
  SetupHelper(AImages);
  FLastHelper.Draw(ADC, ABounds, AIndex, ADrawMode, AUseLeftBottomPixelAsTransparent, APalette, ASmoothImage)
end;

class procedure TdxImageListPaintCache.Draw(AGraphic: TdxGPGraphics; const ABounds: TRect; AImages: TCustomImageList;
  AIndex: Integer; ADrawMode: TcxImageDrawMode; AUseLeftBottomPixelAsTransparent: Boolean; APalette: IdxColorPalette);
begin
  SetupHelper(AImages);
  FLastHelper.Draw(AGraphic, ABounds, AIndex, ADrawMode, AUseLeftBottomPixelAsTransparent, APalette)
end;

class procedure TdxImageListPaintCache.InvalidateImageList(AImages: TCustomImageList);
var
  AHelper: TImageListCacheHelper;
begin
  Assert(AImages <> nil);
  if AImages = FLastImages then
    FLastHelper.Invalidate
  else
    if FImages.TryGetValue(AImages, AHelper) then
      AHelper.Invalidate;
end;

class procedure TdxImageListPaintCache.PrepareImage(ATarget: TdxGpImage;
  const ASize: TSize; const ID: TdxDrawImageCacheID; const AColorPalette: IdxColorPalette);
begin
  TransferBitmap.RefreshImage(ASize.cx, ASize.cy);
  TdxImageDrawer.DrawUncachedImage(TransferBitmap.cxCanvas.Handle, TransferBitmap.ClientRect, TransferBitmap.ClientRect,
    ID.Glyph, ID.ImageList, ID.ImageIndex, ID.DrawMode, ID.SmoothImage, ID.BrushHandle, ID.TransparentColor,
    ID.UseLeftBottomPixelAsTransparent, AColorPalette);
  if ID.BrushHandle <> 0 then
    TransferBitmap.MakeOpaque;
  ATarget.SetBitmap(TransferBitmap);
end;

//

procedure InitPredefinedBrushes;
const
  Pattern: array[0..7] of Word = ($00AA, $0055, $00AA, $0055, $00AA, $0055, $00AA, $0055);
var
  ABitmap:  HBitmap;
begin
  ABitmap := CreateBitmap(8, 8, 1, 1, @Pattern);
  cxHalfToneBrush := TBrush.Create;
  cxHalfToneBrush.Handle := CreatePatternBrush(ABitmap);
  DeleteObject(ABitmap);
end;

procedure DestroyPredefinedBrushes;
begin
  FreeAndNil(cxHalfToneBrush);
end;

procedure GetDPI;
var
  DC: Integer;
begin
  DC := GetDC(0);
  try
    FPixelsPerInch.cx := GetDeviceCaps(DC, LOGPIXELSX);
    FPixelsPerInch.cy := GetDeviceCaps(DC, LOGPIXELSY);
  finally
    ReleaseDC(0, DC);
  end;
end;

procedure InitGraphics;
begin
  FUnitIsFinalized := False;
  TdxSolidBrushCache.Initialize;
  InitPredefinedBrushes;
  FMsimg32DLL := LoadLibrary(msimg32);
  if FMsimg32DLL <> 0 then
  begin
    GradientFill := GetProcAddress(FMsimg32DLL, 'GradientFill');
    VCLAlphaBlend := GetProcAddress(FMsimg32DLL, 'AlphaBlend');
  end
  else
  begin
    GradientFill := nil;
    VCLAlphaBlend := nil;
  end;
  cxRegisterVclClasses([TcxBitmap, TcxBitmap32]);
  GetDPI;
  PaintSkipList := TList.Create;
  ImageAnimationControllerClass := TdxImageAnimationController;
end;

procedure DoneGraphics;
begin
  FUnitIsFinalized := True;
  ImageAnimationControllerClass := TdxSmartImageAnimationController;
  DestroyPredefinedBrushes;
  TdxSolidBrushCache.Finalize;
  FreeAndNil(MeasureCanvas);
  FreeAndNil(PaintSkipList);
  FreeAndNil(ScreenCanvas);
  FreeAndNil(PaintCanvas);
  FreeAndNil(MaskBitmap);
  FreeAndNil(ImageBitmap);
  FreeAndNil(DrawBitmap);
  if FMsimg32DLL > 32 then
    FreeLibrary(FMsimg32DLL);
end;


{ TdxImageDrawer }

class procedure TdxImageDrawer.DrawImage(ACanvas: TCanvas; const ARect: TRect; AGlyph: TGraphic;
  AImages: TCustomImageList; AImageIndex: Integer; AFitMode: TcxImageFitMode; ADrawMode: TcxImageDrawMode;
  AUseLeftBottomPixelAsTransparent: Boolean; APalette: IdxColorPalette; AScaleFactor: TdxScaleFactor;
  ASmoothImage: Boolean);
var
  AcxCanvas: TcxCanvas;
begin
  AcxCanvas := TcxCanvas.Create(ACanvas);
  try
    DrawImage(AcxCanvas, ARect, AGlyph, AImages, AImageIndex, AFitMode, ADrawMode, AUseLeftBottomPixelAsTransparent, APalette, AScaleFactor, ASmoothImage);
  finally
    AcxCanvas.Free;
  end;
end;

class procedure TdxImageDrawer.DrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect; AGlyph: TGraphic;
  AImages: TCustomImageList; AImageIndex: Integer; AFitMode: TcxImageFitMode; ADrawMode: TcxImageDrawMode;
  AUseLeftBottomPixelAsTransparent: Boolean; APalette: IdxColorPalette; AScaleFactor: TdxScaleFactor;
  ASmoothImage: Boolean);
var
  AGlyphRect: TRect;
  AImageSize: TSize;
begin
  if AScaleFactor = nil then
    AScaleFactor := dxDefaultScaleFactor;

  AImageSize := dxGetImageSize(AGlyph, AImages, AImageIndex, AScaleFactor);
  if not cxSizeIsEqual(AImageSize, cxNullSize) then
  begin
    AGlyphRect := cxGetImageRect(ARect, AImageSize, AFitMode);
    if not IsGlyphAssigned(AGlyph) and (AImages is TcxCustomImageList) then
      TdxImageListPaintCache.Draw(ACanvas.Handle, AGlyphRect, AImages, AImageIndex, ADrawMode, AUseLeftBottomPixelAsTransparent, APalette, ASmoothImage)
    else
      DrawUncachedImage(ACanvas.Handle, AGlyphRect, AGlyphRect, AGlyph, AImages, AImageIndex, ADrawMode, ASmoothImage, 0, clNone, AUseLeftBottomPixelAsTransparent, APalette);
  end;
end;

class procedure TdxImageDrawer.DrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect; AGlyph: TGraphic;
  AImages: TCustomImageList; AImageIndex: Integer; AEnabled: Boolean; APalette: IdxColorPalette;
  AScaleFactor: TdxScaleFactor);
begin
  DrawImage(ACanvas, ARect, AGlyph, AImages, AImageIndex, ifmNormal, EnabledImageDrawModeMap[AEnabled], True, APalette, AScaleFactor);
end;

class procedure TdxImageDrawer.DrawImage(ACanvas: TcxGdiBasedCanvas; const ARect: TRect; AImage: TGraphic;
  AFitMode: TcxImageFitMode; APalette: IdxColorPalette; AScaleFactor: TdxScaleFactor; ASmoothResize: Boolean);
begin
  DrawImage(ACanvas, ARect, AImage, nil, -1, AFitMode, idmNormal, AImage.Transparent and not (AImage is TMetaFile), APalette, AScaleFactor, ASmoothResize);
end;

class procedure TdxImageDrawer.DrawBitmap(ADestDC: THandle; ASrcBitmap: TBitmap; const ADestRect: TRect;
  const ASrcPoint: TPoint; AMode: Integer = SRCCOPY);

  procedure InternalDrawBitmap;

    procedure SoftwareBitBlt;
    var
      ABitmap: TcxAlphaBitmap;
    begin
      ABitmap := TcxAlphaBitmap.CreateSize(ADestRect);
      try
        cxBitBlt(ABitmap.Canvas.Handle, ASrcBitmap.Canvas.Handle, ABitmap.ClientRect, ASrcPoint, SRCCOPY);
        ABitmap.TransformBitmap(btmResetAlpha);
        cxBitBlt(ADestDC, ABitmap.Canvas.Handle, ADestRect, cxNullPoint, AMode);
      finally
        ABitmap.Free;
      end;
    end;

   begin
    if IsWin9X and (GetDeviceCaps(ADestDC, BITSPIXEL) = 32) and (cxGetBitmapPixelFormat(ASrcBitmap) < 32) then
      SoftwareBitBlt
    else
      cxBitBlt(ADestDC, ASrcBitmap.Canvas.Handle, ADestRect, ASrcPoint, AMode);
  end;

var
  APrevPalette: HPALETTE;
begin
  if (ASrcBitmap.Palette <> 0) and (GetDeviceCaps(ADestDC, BITSPIXEL) <= 8) then
  begin
    APrevPalette := SelectPalette(ADestDC, ASrcBitmap.Palette, True);
    RealizePalette(ADestDC);
    InternalDrawBitmap;
    SelectPalette(ADestDC, APrevPalette, True);
  end
  else
    InternalDrawBitmap;
end;

class procedure TdxImageDrawer.DrawUncachedImage(ADC: THandle; AGlyphRect, ABackgroundRect: TRect; AGlyph: TGraphic; AImages: TCustomImageList;
  AImageIndex: Integer; ADrawMode: TcxImageDrawMode; ASmoothImage: Boolean = False; ABrush: THandle = 0;
  ATransparentColor: TColor = clNone; AUseLeftBottomPixelAsTransparent: Boolean = True; APalette: IdxColorPalette = nil);

  procedure DrawBackground(ABitmap: TcxAlphaBitmap);
  begin
    if ABrush = 0 then
      cxBitBlt(ABitmap.Canvas.Handle, ADC, ABitmap.ClientRect, ABackgroundRect.TopLeft, SRCCOPY)
    else
      FillRect(ABitmap.Canvas.Handle, ABitmap.ClientRect, ABrush);
  end;

  procedure DrawImageToBitmap(ABitmap: TcxAlphaBitmap; ADrawMode: TcxImageDrawMode);
  const
    ImageShadowSize = 2;
  var
    AConstantAlpha: Byte;
    AImageBitmap: TcxAlphaBitmap;
    AIsAlphaUsed: Boolean;
    AMaskBitmap: TcxAlphaBitmap;
  begin
    OffsetRect(AGlyphRect, -ABackgroundRect.Left, -ABackgroundRect.Top);
    if not Assigned(CustomDrawImageProc) or not CustomDrawImageProc(ABitmap.Canvas, AImages, AImageIndex, AGlyph, AGlyphRect, ADrawMode) then
    begin
      AImageBitmap := cxPrepareBitmapForDrawing(AGlyph, AImages, AImageIndex, AUseLeftBottomPixelAsTransparent,
        ATransparentColor, APalette, AGlyphRect.Width, AGlyphRect.Height, ASmoothImage, AMaskBitmap, AIsAlphaUsed);

      AConstantAlpha := $FF;
      case ADrawMode of
        idmGrayScale:
          AImageBitmap.TransformBitmap(btmGrayScale);
        idmDingy:
          AImageBitmap.TransformBitmap(btmDingy);

        idmFaded:
          begin
            AImageBitmap.TransformBitmap(btmFade);
            AConstantAlpha := FadeMap.SrcConstantAlpha;
          end;

        idmShadowed:
          begin
            if AMaskBitmap = nil then
            begin
              AMaskBitmap := GetMaskBitmap(AGlyphRect.Width, AGlyphRect.Height);
              AMaskBitmap.CopyBitmap(AImageBitmap);
              AMaskBitmap.TransformBitmap(btmMakeMask);
            end;
            AImageBitmap.DrawShadow(AMaskBitmap, ImageShadowSize, clBtnShadow, True);
            AGlyphRect := cxRectInflate(AGlyphRect, 0, 0, ImageShadowSize, ImageShadowSize);
            OffsetRect(AGlyphRect, -ImageShadowSize div 2, -ImageShadowSize div 2);
          end;

        idmDisabled:
          if AIsAlphaUsed or (AMaskBitmap = nil) then
          begin
            AImageBitmap.TransformBitmap(btmDisable);
            AConstantAlpha := DisableMap.SrcConstantAlpha;
          end
          else
          begin
            AImageBitmap.TransformBitmap(btmDirty);
            AImageBitmap.DrawShadow(AMaskBitmap, 1, clBtnHighlight);
          end;
      end;
      AImageBitmap.AlphaBlend(ABitmap, AGlyphRect, ASmoothImage, AConstantAlpha);
    end;
  end;

var
  ADrawBitmap: TcxAlphaBitmap;
begin
  if IsGlyphAssigned(AGlyph) or IsImageAssigned(AImages, AImageIndex) then
  begin
    ADrawBitmap := GetDrawBitmap(ABackgroundRect.Width, ABackgroundRect.Height);
    DrawBackground(ADrawBitmap);
    DrawImageToBitmap(ADrawBitmap, ADrawMode);
    TdxImageDrawer.DrawBitmap(ADC, ADrawBitmap, ABackgroundRect, cxNullPoint);
  end;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  InitGraphics;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  DoneGraphics;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
