{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library controls                  }
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

unit dxDirectX.D2D.Canvas; // for internal use

{$I cxVer.inc}

interface

uses
  UITypes,
  Types, Windows, SysUtils, Generics.Collections, Generics.Defaults, Classes, Graphics, D2D1, DXGiFormat, Controls,
  Contnrs, Math, cxCustomCanvas, cxGeometry, cxGraphics, dxCore, dxCoreClasses, dxCoreGraphics, dxGenerics,
  dxGDIPlusClasses, dxGDIPlusAPI, dxShapeBrushes, dxDirectX.D2D.Types, dxDirectX.D2D.Classes, dxDirectX.D2D.Utils;

const
  sdxErrorCannotCreateTextLayoutHandle = 'Cannot create TextLayout handle because %s is not set.';

type
  TdxCustomDirect2DCanvas = class;

  { TdxDWriteTextMetrics }

  TdxDWriteTextMetrics = record
    Height: Single;
    LineCount: Integer;
    LineHeight: Single;
    Truncated: Boolean;
    Width: Single;
    WidthIncludingTrailingWhitespace: Single;
  end;

  { TdxDirect2DCanvasBasedFontHandle }

  TdxDirect2DCanvasBasedFontHandle = class(TcxCanvasBasedFontHandle)
  strict private
    FEndEllipsisSign: IDWriteInlineObject;
    FNativeHandle: IDWriteTextFormat;

    function GetEndEllipsisSign: IDWriteInlineObject; inline;
  protected
    procedure CreateNativeHandle(ACanvas: TcxCustomCanvas); override;
    procedure FreeNativeHandle; override;
  public
    property EndEllipsisSign: IDWriteInlineObject read GetEndEllipsisSign;
    property NativeHandle: IDWriteTextFormat read FNativeHandle;
  end;

  { TdxDirect2DCanvasBasedImage }

  TdxDirect2DCanvasBasedImage = class(TcxCanvasBasedImage)
  strict private
    FHandle: ID2D1Bitmap;
  public
    constructor Create(ACanvas: TdxCustomDirect2DCanvas; AHandle: ID2D1Bitmap; AWidth, AHeight: Integer);
    procedure Release; override;
    property Handle: ID2D1Bitmap read FHandle;
  end;

  { TdxDirect2DCanvasBasedPath }

  TdxDirect2DCanvasBasedPath = class(TcxCanvasBasedPath)
  strict private
    FFigureStarted: Boolean;
    FHandle: ID2D1PathGeometry1;
    FSink: ID2D1GeometrySink;

    procedure CloseSink;
    procedure FinishFigureIfNecessary(const AMode: TD2D1_FigureEnd); inline;
    procedure StartFigureIfNecessary(const P: TD2D1Point2F); inline;
  public
    constructor Create(ACanvas: TdxCustomDirect2DCanvas);
    destructor Destroy; override;
    // General
    function BuildHandle: ID2D1PathGeometry1;
    procedure Release; override;
    // commands
    procedure AddArc(const AEllipse: TdxRectF; const AStartAngle, ASweepAngle: Single); override;
    procedure AddPolyline(Points: PdxPointF; Count: Integer); override;
    // figures
    procedure FigureClose; override;
    procedure FigureStart; override;
  end;

  { TdxDirect2DCanvasBasedTextLayout }

  TdxDirect2DCanvasBasedTextLayout = class(TcxCanvasBasedTextLayout)
  strict private const
    MaxSize = MaxWord;
  strict private
    FColor: TdxAlphaColor;
    FHandle: IDWriteTextLayout;
    FHasEndEllipsis: Boolean;
    FMinWidth: Single;

    procedure CalculateTextMetrics(out AMetrics: TdxDWriteTextMetrics);
    procedure HandleNeeded; inline;
    function GetCanvas: TdxCustomDirect2DCanvas; inline;
    function GetFont: TdxDirect2DCanvasBasedFontHandle;
    function GetMinWidth: Single; inline;
  protected
    procedure ApplyFlags; override;
    procedure DoCalculate(AMaxWidth, AMaxHeight, AMaxRowCount: Integer); override;
    procedure DoDraw(const R: TRect); override;
    procedure DoSetFont(AFontHandle: TcxCanvasBasedFontHandle); override;
    procedure FontChanged; override;
    procedure TextChanged; override;
  public
    constructor Create(ACanvas: TdxCustomDirect2DCanvas);
    procedure Release; override;
    procedure SetColor(AColor: TdxAlphaColor); override;
    //
    property Canvas: TdxCustomDirect2DCanvas read GetCanvas;
    property Font: TdxDirect2DCanvasBasedFontHandle read GetFont;
  end;

  { TdxDirect2DCanvasBasedBrushHandle }

  TdxDirect2DCanvasBasedBrushHandle = class(TcxCanvasBasedBrushHandle)
  protected
    FBrush: TdxDirect2DBrush;

    procedure CreateNativeHandle(ACanvas: TcxCustomCanvas); override;
    procedure FreeNativeHandle; override;
  public
    constructor Create(AHandle: TdxDirect2DBrush); overload;
    function IsEmpty: Boolean; override;
  end;

  { TdxDirect2DCanvasBasedPenHandle }

  TdxDirect2DCanvasBasedPenHandle = class(TcxCanvasBasedPenHandle)
  strict private
    FBrushHandle: TdxDirect2DCanvasBasedBrushHandle;
    FSolidBrush: ID2D1Brush;
    FStrokeStyle: ID2D1StrokeStyle;
  protected
    procedure CreateNativeHandle(ACanvas: TcxCustomCanvas); override;
    procedure FreeNativeHandle; override;
  public
    constructor Create(const AStrokeStyle: ID2D1StrokeStyle;
      AWidth: Single; ABrushHandle: TdxDirect2DCanvasBasedBrushHandle); overload;
    function GetBrush(const R: TD2D1RectF): ID2D1Brush;
    function IsEmpty: Boolean; override;
    //
    property StrokeStyle: ID2D1StrokeStyle read FStrokeStyle;
  end;

  { TdxDirect2DResourceCache }

  TdxDirect2DResourceCache<X, Y> = class(TdxValueCacheManager<X, Y>)
  protected
    FOwner: TdxCustomDirect2DCanvas;
  public
    constructor Create(AOwner: TdxCustomDirect2DCanvas; ACapacity: Integer);
  end;

  { IdxDirect2DCanvasOwner }

  IdxDirect2DCanvasOwner = interface
  ['{08D21768-F2CA-4F1B-99D6-AE30A59216CB}']
    procedure RecreateNeeded;
  end;

  { TdxCustomDirect2DCanvas }

  TdxCustomDirect2DCanvas = class(TcxCustomCanvas,
    IcxCanvasCacheControl)
  strict private const
    InterpolationModeMap: array[TcxCanvasImageStretchQuality] of TD2D1InterpolationMode = (
      D2D1_INTERPOLATION_MODE_NEAREST_NEIGHBOR,
      D2D1_INTERPOLATION_MODE_ANISOTROPIC
    );
  strict private
    FClipRect: TRect;
    FClipRectModificationCount: Integer;
    FDeviceContext: ID2D1DeviceContext;
    FMaxBitmapSize: Integer;
    FWindowOrg: TPoint;
    FWorldTransform: TD2D1Matrix3x2F;

    FSavedClipRects: TStack<TRect>;
    FSavedWindowOrgs: TStack<TPoint>;
    FSavedWorldTransforms: TStack<TD2D1Matrix3x2F>;

    procedure ApplyWorldTransform;
    procedure RollbackClipRectChanges;
    procedure SetDeviceContext(const Value: ID2D1DeviceContext);
  protected
    FCacheNativeObjects: TdxDirect2DResourceCache<TcxCanvasBasedResourceCacheKey, ID2D1Bitmap>;
    FCacheSolidBrushes: TdxDirect2DResourceCache<TdxAlphaColor, ID2D1SolidColorBrush>;
    FIsGDICompatible: Boolean;
    FSharedBrushes: TcxCanvasBasedSharedBrushes;
    FSharedImageLists: TcxCanvasBasedSharedImageLists;
    FSharedPens: TcxCanvasBasedSharedPens;
    FRecreateContextNeeded: Boolean;

    procedure DoBeginDraw(const AClipRect: TRect);
    procedure DoEndDraw;

    function GetSharedBrushes: TcxCanvasBasedSharedBrushes; override;
    function GetSharedFonts: TcxCanvasBasedSharedFonts; override;
    function GetSharedImageLists: TcxCanvasBasedSharedImageLists; override;
    function GetSharedPens: TcxCanvasBasedSharedPens; override;
    function GetWindowOrg: TPoint; override;
    procedure SetWindowOrg(const AValue: TPoint); override;

    function CacheGetPenStyle(const AStyle: TdxStrokeStyle): ID2D1StrokeStyle; overload;
    function CacheGetPenStyle(const AStyle: TPenStyle): ID2D1StrokeStyle; overload;
    function CacheGetSolidBrush(const AColor: TdxAlphaColor): ID2D1SolidColorBrush;
    function CreateBrushHandle(const ABrush: TdxGPCustomBrush): TdxDirect2DCanvasBasedBrushHandle;
    function CreatePenHandle(const APen: TdxGPPen): TdxDirect2DCanvasBasedPenHandle;
    function CreatePathGeometry(APoints: PPoint; ACount: Integer;
      AFigureBegin: TD2D1FigureBegin; AFigureEnd: TD2D1_FigureEnd): ID2D1PathGeometry1; overload;
    function CreatePathGeometry(APoints: PdxPointF; ACount: Integer;
      AFigureBegin: TD2D1FigureBegin; AFigureEnd: TD2D1_FigureEnd): ID2D1PathGeometry1; overload;

    function CreateNativeObjectTexture(const ARect, AClippedRect: TRect; AProc: TcxCanvasNativeDrawExProc): ID2D1Bitmap; overload;
    function CreateNativeObjectTexture(const ARect, AClippedRect: TRect; AProc: TcxCanvasNativeDrawProc): ID2D1Bitmap; overload;
    function CreateNativeStrokeStyle(APen: TdxGPPen): ID2D1StrokeStyle1;
    function GetGdiInteropRenderTarget(out ATarget: ID2D1GdiInteropRenderTarget; out DC: HDC): Boolean;
    function GetNativeBrushAndPen(ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen;
      out ANativeBrush: TdxDirect2DBrush; out ANativePen: TdxDirect2DCanvasBasedPenHandle): Boolean;
    function GetNativeImage(AImageResource: TcxCanvasBasedImage; out AHandle: ID2D1Bitmap): Boolean;
    function IsLargeForTexture(const R: TRect): Boolean; inline;

    procedure DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte); override;
    procedure DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte); override;
    procedure FillRectByGradientCore(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode); override;
    procedure RectangleCore(const R: TdxRectF; ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle); override;
    procedure ReleaseDevice; virtual;

    property DeviceContext: ID2D1DeviceContext read FDeviceContext write SetDeviceContext;
  public
    constructor Create;
    destructor Destroy; override;
    // IcxCanvasCacheControl
    procedure FlushCache;

    procedure DrawNativeObject(const R: TRect; const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc); override;
    procedure DrawNativeObject(const R: TRect; const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawExProc); override;

    function CreateBrush(ABrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedBrush; override;
    function CreateImage(ABitmap: TBitmap; AAlphaFormat: TAlphaFormat = afIgnored): TcxCanvasBasedImage; override;
    function CreateImage(ABitmap: TdxCustomFastDIB; AAlphaFormat: TAlphaFormat = afIgnored): TcxCanvasBasedImage; override;
    function CreatePath: TcxCanvasBasedPath; override;
    function CreatePeN(APen: TdxGPPen; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedPen; override; 
    function CreateTextLayout: TcxCanvasBasedTextLayout; override;

    procedure Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
      AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle); override;
    procedure DonutSlice(const R: TdxRectF; AStartAngle, ASweepAngle, AWholePercent: Single;
      ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Ellipse(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Ellipse(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer); override;
    procedure FillRect(const R: TRect; AColor: TdxAlphaColor); override;
    procedure Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Pie(const R: TdxRectF; AStartAngle, ASweepAngle: Single; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Line(const P1, P2: TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle = psSolid); override;
    procedure Line(const P1, P2: TPoint; AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); override;
    procedure Line(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen); override;
    procedure Polyline(const P: array of TPoint; AColor: TdxAlphaColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); override;
    procedure Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen); override;
    procedure Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor); override;
    procedure Polygon(const P: PdxPointF; ACount: Integer; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Rectangle(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer = 1); override;

    procedure DrawBitmap(const AHandle: ID2D1Bitmap; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte); reintroduce; overload;
    procedure DrawBitmap(const AHandle: ID2D1Bitmap; const ATargetRect, ASourceRect: TRect; AAlpha: Byte); reintroduce; overload;
    procedure DrawBitmap(const AHandle: ID2D1Bitmap; const ATargetRect: TRect); reintroduce; overload;
    procedure DrawTextLayout(const AHandle: IDWriteTextLayout; X, Y: Integer; AColor: TdxAlphaColor);
    procedure Geometry(const AHandle: ID2D1Geometry;
      ABrushColor, APenColor: TdxAlphaColor; APenWidth: Single = 1; APenStyle: ID2D1StrokeStyle = nil); overload;
    procedure Geometry(const AHandle: ID2D1Geometry;
      ANativeBrush: TdxDirect2DBrush; ANativePen: TdxDirect2DCanvasBasedPenHandle); overload;
    procedure Geometry(const AHandle: ID2D1Geometry; const ABoundingRect: TD2D1RectF;
      ANativeBrush: TdxDirect2DBrush; ANativePen: TdxDirect2DCanvasBasedPenHandle); overload;

    procedure ApplyClipRect;
    procedure IntersectClipRect(const ARect: TRect); override;
    function RectVisible(const R: TRect): Boolean; override;
    procedure RestoreClipRegion; override;
    procedure SaveClipRegion; override;

    procedure ModifyWorldTransform(const AForm: TXForm); override;
    procedure RestoreWorldTransform; override;
    procedure SaveWorldTransform; override;

    procedure RestoreState; override;
    procedure SaveState; override;
  end;

  { TdxDirect2DGdiCompatibleCanvas }

  TdxDirect2DGdiCompatibleCanvas = class(TdxCustomDirect2DCanvas)
  strict private
    FRenderTarget: ID2D1DCRenderTarget;

    procedure CreateRenderTarget;
  public
    constructor Create;
    procedure BeginPaint(DC: HDC; const R: TRect);
    procedure EndPaint;
  end;

  { TdxDirect2DHwndBasedCanvas }

  TdxDirect2DHwndBasedCanvas = class(TdxCustomDirect2DCanvas,
    IcxCanvasBuffer,
    IcxControlDirectCanvas,
    IcxControlCanvas)
  strict private
    FDevice: IDXGIDevice1;
    FDevice3D: ID3D11Device;
    FDevice3DContext: ID3D11DeviceContext;
    FFrontBufferContent: ID3D11Texture2D;
    FFrontBufferContentSize: TSize;
    FFrontBufferSurface: IDXGISurface;
    FIsBufferValid: Boolean;
    FOwner: IdxDirect2DCanvasOwner;
    FPaintStruct: TPaintStruct;
    FPresentParameters: TDXGIPresentParameters;
    FSwapChain: IDXGISwapChain1;
    FTextureSize: TSize;
    FUpdateRect: TRect;
    FWinControl: TWinControl;
    FWindowHandle: HWND;

    procedure CheckCreateFrontBufferContent;
    procedure DoPresentBuffer;

  protected
    function GetDefaultUseRightToLeftAlignment: Boolean; override;
    // Texture
    procedure CreateTexture;
    procedure ReleaseDevice; override;
    procedure ReleaseTexture;
    // IcxCanvasBuffer
    procedure IcxCanvasBuffer.Invalidate = MarkBufferInvalid;
    function IcxCanvasBuffer.IsValid = IsBufferValid;
    function IsBufferValid: Boolean;
    procedure MarkBufferInvalid;
    // IcxControlCanvas
    procedure BeginPaint;
    procedure EndPaint;
    // IcxControlDirectCanvas
    procedure CopyToDC(DC: HDC); overload;
    procedure CopyToDC(DC: HDC; const ATargetRect, ASourceRect: TRect); overload;
    procedure SetWndHandle(AHandle: HWND);

    property Device: IDXGIDevice1 read FDevice;
    property Device3D: ID3D11Device read FDevice3D;
    property Device3DContext: ID3D11DeviceContext read FDevice3DContext;
  public
    constructor Create(const AOwner: IdxDirect2DCanvasOwner;
      const ADevice: IDXGIDevice1; const AContext: ID2D1DeviceContext;
      const ADevice3D: ID3D11Device; const ADevice3DContext: ID3D11DeviceContext);
  end;

  TdxDirectXSwapChainSize = 2..16;

var
  dxDirectXAntialiasing: Boolean = True;
  dxDirectXSwapChainSize: TdxDirectXSwapChainSize = 2;
  dxDirectXTextAntialiasMode: TD2D1TextAntiAliasMode = D2D1_TEXT_ANTIALIAS_MODE_DEFAULT;
  dxDirectXVSync: Boolean = True;

function dxCreateDirect2DCanvas(const AOwner: IdxDirect2DCanvasOwner; out ACanvas: TcxCustomCanvas): Boolean;
implementation

uses
  ActiveX, cxDrawTextUtils, dxFading, cxControls, dxDPIAwareUtils;

const
  dxThisUnitName = 'dxDirectX.D2D.Canvas';

type
  TcxCanvasBasedResourceAccess = class(TcxCanvasBasedResource);

  TdxDirect2DCanvasBasedSharedFonts = class(TcxCanvasBasedSharedFonts)
  strict private
    class var FInstance: TdxDirect2DCanvasBasedSharedFonts;
  protected
    class procedure Finalize;
  public
    class function Instance: TdxDirect2DCanvasBasedSharedFonts;
  end;

function dxCreateDevice3DContext(out ADevice: ID3D11Device; out ADeviceContext: ID3D11DeviceContext): Boolean;
const
  Windows8Features: array[0..1] of TD3DFeatureLevel = (D3D_FEATURE_LEVEL_11_0, D3D_FEATURE_LEVEL_11_1);
var
  AErrorCode: HRESULT;
  AFeatureCount: Integer;
  AFeatures: PD3DFeatureLevel;
begin
  if IsWin8OrLater then
  begin
    AFeatures := @Windows8Features[0];
    AFeatureCount := Length(Windows8Features);
  end
  else
  begin
    AFeatures := nil;
    AFeatureCount := 0;
  end;
  AErrorCode := D3D11CreateDevice(nil, D3D_DRIVER_TYPE_HARDWARE, 0,
    D3D11_CREATE_DEVICE_BGRA_SUPPORT or D3D11_CREATE_DEVICE_SINGLETHREADED,
    AFeatures, AFeatureCount, D3D11_SDK_VERSION, ADevice, nil, ADeviceContext);
  CheckNeedSwitchToGdiRenderMode(AErrorCode);
  Result := AErrorCode = S_OK;
end;

function dxCreateDirect2DCanvas(const AOwner: IdxDirect2DCanvasOwner; out ACanvas: TcxCustomCanvas): Boolean;
var
  AContext: ID2D1DeviceContext;
  ADevice: IDXGIDevice1;
  ADevice2D: ID2D1Device;
  ADevice3D: ID3D11Device;
  ADevice3DContext: ID3D11DeviceContext;
begin
  if not IsDirectD2Available then
    Exit(False);
  if not dxCreateDevice3DContext(ADevice3D, ADevice3DContext) then
    Exit(False);
  if not Supports(ADevice3D, IDXGIDevice1, ADevice) then
    Exit(False);
  if Failed(D2D1Factory1.CreateDevice(ADevice, ADevice2D)) then
    Exit(False);
  if Failed(ADevice2D.CreateDeviceContext(D2D1_DEVICE_CONTEXT_OPTIONS_NONE, AContext)) then
    Exit(False);
  ACanvas := TdxDirect2DHwndBasedCanvas.Create(AOwner, ADevice, AContext, ADevice3D, ADevice3DContext);
  Result := True;
end;

{ TdxDirect2DCanvasBasedBrushHandle }

constructor TdxDirect2DCanvasBasedBrushHandle.Create(AHandle: TdxDirect2DBrush);
begin
  inherited Create;
  FBrush := AHandle;
end;

procedure TdxDirect2DCanvasBasedBrushHandle.CreateNativeHandle(ACanvas: TcxCustomCanvas);
var
  AGpBrush: TdxGPCustomBrush;
begin
  AGpBrush := TcxGdiCanvasBasedSharedBrushes.CreateBrush(Self);
  try
    FBrush := TdxDirect2DBrushFactory.Create(TdxCustomDirect2DCanvas(ACanvas).DeviceContext, AGpBrush);
  finally
    AGpBrush.Free;
  end;
end;

procedure TdxDirect2DCanvasBasedBrushHandle.FreeNativeHandle;
begin
  FreeAndNil(FBrush);
end;

function TdxDirect2DCanvasBasedBrushHandle.IsEmpty: Boolean;
begin
  Result := (FBrush = nil) or FBrush.IsEmpty;
end;

{ TdxDirect2DCanvasBasedPenHandle }

constructor TdxDirect2DCanvasBasedPenHandle.Create(const AStrokeStyle: ID2D1StrokeStyle;
  AWidth: Single; ABrushHandle: TdxDirect2DCanvasBasedBrushHandle);
begin
  FStrokeStyle := AStrokeStyle;
  FBrushHandle := ABrushHandle;
  FBrushHandle.AddRef;
  FWidth := AWidth;
end;

function TdxDirect2DCanvasBasedPenHandle.GetBrush(const R: TD2D1RectF): ID2D1Brush;
begin
  if FSolidBrush <> nil then
    Result := FSolidBrush
  else
    Result := FBrushHandle.FBrush.GetHandle(R);
end;

procedure TdxDirect2DCanvasBasedPenHandle.CreateNativeHandle(ACanvas: TcxCustomCanvas);
begin
  FStrokeStyle := TdxCustomDirect2DCanvas(ACanvas).CacheGetPenStyle(FStyle);
  FSolidBrush := TdxCustomDirect2DCanvas(ACanvas).CacheGetSolidBrush(FColor);
end;

procedure TdxDirect2DCanvasBasedPenHandle.FreeNativeHandle;
begin
  FStrokeStyle := nil;
  FSolidBrush := nil;
  if FBrushHandle <> nil then
    FBrushHandle.Release;
  FBrushHandle := nil;
end;

function TdxDirect2DCanvasBasedPenHandle.IsEmpty: Boolean;
begin
  if Width > 0 then
  begin
    if FSolidBrush <> nil then
      Result := False
    else
      Result := (FBrushHandle = nil) or FBrushHandle.IsEmpty;
  end
  else
    Result := True;
end;

{ TdxDirect2DResourceCache<X, Y> }

constructor TdxDirect2DResourceCache<X, Y>.Create(AOwner: TdxCustomDirect2DCanvas; ACapacity: Integer);
begin
  inherited Create(ACapacity);
  FOwner := AOwner;
end;

{ TdxCustomDirect2DCanvas }

constructor TdxCustomDirect2DCanvas.Create;
begin
  inherited;
  FIsGDICompatible := True;
  FSavedClipRects := TStack<TRect>.Create;
  FSavedWindowOrgs := TStack<TPoint>.Create;
  FSavedWorldTransforms := TStack<TD2D1Matrix3x2F>.Create;
  FCacheSolidBrushes := TdxDirect2DResourceCache<TdxAlphaColor, ID2D1SolidColorBrush>.Create(Self, 128);
  FCacheNativeObjects := TdxDirect2DResourceCache<TcxCanvasBasedResourceCacheKey, ID2D1Bitmap>.Create(Self, 256);
  FSharedImageLists := TcxCanvasBasedSharedImageLists.Create(Self, TcxCanvasBasedImageListHandle);
  FSharedBrushes := TcxCanvasBasedSharedBrushes.Create(Self, TdxDirect2DCanvasBasedBrushHandle);
  FSharedPens := TcxCanvasBasedSharedPens.Create(Self, TdxDirect2DCanvasBasedPenHandle);
end;

destructor TdxCustomDirect2DCanvas.Destroy;
begin
  ReleaseDevice;
  FreeAndNil(FSharedPens);
  FreeAndNil(FSharedBrushes);
  FreeAndNil(FSharedImageLists);
  FreeAndNil(FCacheNativeObjects);
  FreeAndNil(FCacheSolidBrushes);
  FreeAndNil(FSavedWorldTransforms);
  FreeAndNil(FSavedWindowOrgs);
  FreeAndNil(FSavedClipRects);
  inherited;
end;

procedure TdxCustomDirect2DCanvas.DrawNativeObject(const R: TRect;
  const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc);
var
  AClippedRect: TRect;
  AGdiRenderTarget: ID2D1GdiInteropRenderTarget;
  AHandle: ID2D1Bitmap;
  ATargetDC: HDC;
begin
  if not RectVisible(R) then
    Exit;

  if GetGdiInteropRenderTarget(AGdiRenderTarget, ATargetDC) then
  try
    cxPaintCanvas.BeginPaint(ATargetDC);
    try
      cxPaintCanvas.WindowOrg := FWindowOrg;
      AProc(cxPaintCanvas, R);
    finally
      cxPaintCanvas.EndPaint;
    end;
  finally
    AGdiRenderTarget.ReleaseDC(R);
  end
  else
    if IsLargeForTexture(R) then
    begin
      if cxRectIntersect(AClippedRect, FClipRect, R) then
        DrawBitmap(CreateNativeObjectTexture(R, AClippedRect, AProc), AClippedRect);
    end
    else
    begin
      if not FCacheNativeObjects.Get(ACacheKey, AHandle) then
      begin
        AHandle := CreateNativeObjectTexture(R, R, AProc);
        FCacheNativeObjects.Add(ACacheKey, AHandle);
      end;
      DrawBitmap(AHandle, R);
    end;
end;

procedure TdxCustomDirect2DCanvas.DrawNativeObject(const R: TRect;
  const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawExProc);
var
  AClippedRect: TRect;
  AGdiRenderTarget: ID2D1GdiInteropRenderTarget;
  AHandle: ID2D1Bitmap;
  ATargetDC: HDC;
begin
  if not RectVisible(R) then
    Exit;

  if GetGdiInteropRenderTarget(AGdiRenderTarget, ATargetDC) then
  try
    dxGPPaintCanvas.BeginPaint(ATargetDC, R);
    try
      dxGPPaintCanvas.TranslateWorldTransform(-FWindowOrg.X, -FWindowOrg.Y);
      AProc(dxGPPaintCanvas, R);
    finally
      dxGPPaintCanvas.EndPaint;
    end;
  finally
    AGdiRenderTarget.ReleaseDC(R);
  end
  else
    if IsLargeForTexture(R) then
    begin
      if cxRectIntersect(AClippedRect, FClipRect, R) then
        DrawBitmap(CreateNativeObjectTexture(R, AClippedRect, AProc), AClippedRect);
    end
    else
    begin
      if not FCacheNativeObjects.Get(ACacheKey, AHandle) then
      begin
        AHandle := CreateNativeObjectTexture(R, R, AProc);
        FCacheNativeObjects.Add(ACacheKey, AHandle);
      end;
      DrawBitmap(AHandle, R);
    end;
end;

procedure TdxCustomDirect2DCanvas.DrawTextLayout(const AHandle: IDWriteTextLayout; X, Y: Integer; AColor: TdxAlphaColor);
var
  ATextPoint: TD2D1Point2F;
begin
  ATextPoint.X := X - 0.5;
  ATextPoint.Y := Y - 0.5;
  DeviceContext.DrawTextLayout(ATextPoint, AHandle, CacheGetSolidBrush(AColor), D2D1_DRAW_TEXT_OPTIONS_CLIP);
end;

procedure TdxCustomDirect2DCanvas.Ellipse(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  ABox: TD2D1RectF;
  AEllipse: TD2D1Ellipse;
  ANativeBrush: TdxDirect2DBrush;
  ANativePen: TdxDirect2DCanvasBasedPenHandle;
begin
  if GetNativeBrushAndPen(ABrush, APen, ANativeBrush, ANativePen) then
  begin
    ABox := D2D1Rect(R);
    AEllipse := D2D1Ellipse(ABox);
    if ANativeBrush <> nil then
      DeviceContext.FillEllipse(AEllipse, ANativeBrush.GetHandle(ABox));
    if ANativePen <> nil then
      DeviceContext.DrawEllipse(AEllipse, ANativePen.GetBrush(ABox), ANativePen.Width, ANativePen.StrokeStyle);
  end;
end;

procedure TdxCustomDirect2DCanvas.Ellipse(const R: TRect;
  ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer);
var
  AEllipse: TD2D1Ellipse;
begin
  AEllipse := D2D1Ellipse(D2D1Rect(R));
  if dxAlphaColorIsValid(ABrushColor) then
    DeviceContext.FillEllipse(AEllipse, CacheGetSolidBrush(ABrushColor));
  if dxAlphaColorIsValid(APenColor) and (APenWidth > 0) then
    DeviceContext.DrawEllipse(AEllipse, CacheGetSolidBrush(APenColor), APenWidth, CacheGetPenStyle(APenStyle));
end;

procedure TdxCustomDirect2DCanvas.Geometry(const AHandle: ID2D1Geometry;
  ABrushColor, APenColor: TdxAlphaColor; APenWidth: Single = 1; APenStyle: ID2D1StrokeStyle = nil);
begin
  if AHandle = nil then
    Exit;
  if dxAlphaColorIsValid(ABrushColor) then
    DeviceContext.FillGeometry(AHandle, CacheGetSolidBrush(ABrushColor));
  if dxAlphaColorIsValid(APenColor) then
    DeviceContext.DrawGeometry(AHandle, CacheGetSolidBrush(APenColor), APenWidth, APenStyle);
end;

procedure TdxCustomDirect2DCanvas.Geometry(const AHandle: ID2D1Geometry;
  ANativeBrush: TdxDirect2DBrush; ANativePen: TdxDirect2DCanvasBasedPenHandle);
var
  ABoundingRect: TD2D1RectF;
begin
  if AHandle <> nil then
  begin
    if Succeeded(AHandle.GetBounds(TD2DMatrix3x2F.Identity, ABoundingRect)) then
      Geometry(AHandle, ABoundingRect, ANativeBrush, ANativePen);
  end;
end;

procedure TdxCustomDirect2DCanvas.Geometry(const AHandle: ID2D1Geometry; const ABoundingRect: TD2D1RectF;
  ANativeBrush: TdxDirect2DBrush; ANativePen: TdxDirect2DCanvasBasedPenHandle);
begin
  if AHandle = nil then
    Exit;
  if ANativeBrush <> nil then
    DeviceContext.FillGeometry(AHandle, ANativeBrush.GetHandle(ABoundingRect));
  if ANativePen <> nil then
    DeviceContext.DrawGeometry(AHandle, ANativePen.GetBrush(ABoundingRect), ANativePen.Width, ANativePen.StrokeStyle);
end;

function TdxCustomDirect2DCanvas.CreateBrush(ABrush: TdxGPCustomBrush; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedBrush;
begin
  try
    if ABrush <> nil then
      Result := TcxCanvasBasedBrush.Create(Self, CreateBrushHandle(ABrush))
    else
      Result := nil;
  finally
    if AOwnership = ooOwned then
      ABrush.Free;
  end;
end;

function TdxCustomDirect2DCanvas.CreateImage(ABitmap: TdxCustomFastDIB; AAlphaFormat: TAlphaFormat): TcxCanvasBasedImage;
begin
  Result := TdxDirect2DCanvasBasedImage.Create(Self, D2D1Bitmap(DeviceContext, ABitmap, AAlphaFormat), ABitmap.Width, ABitmap.Height);
end;

function TdxCustomDirect2DCanvas.CreateImage(ABitmap: TBitmap; AAlphaFormat: TAlphaFormat): TcxCanvasBasedImage;
begin
  Result := TdxDirect2DCanvasBasedImage.Create(Self, D2D1Bitmap(DeviceContext, ABitmap, AAlphaFormat), ABitmap.Width, ABitmap.Height);
end;

function TdxCustomDirect2DCanvas.CreatePath: TcxCanvasBasedPath;
begin
  Result := TdxDirect2DCanvasBasedPath.Create(Self);
end;

function TdxCustomDirect2DCanvas.CreatePeN(APen: TdxGPPen; AOwnership: TdxObjectOwnership = ooCloned): TcxCanvasBasedPen;
begin
  try
    if (APen <> nil) and not APen.IsEmpty then
      Result := TcxCanvasBasedPen.Create(Self, CreatePenHandle(APen))
    else
      Result := nil;
  finally
    if AOwnership = ooOwned then
      APen.Free;
  end;
end;

function TdxCustomDirect2DCanvas.CreateTextLayout: TcxCanvasBasedTextLayout;
begin
  Result := TdxDirect2DCanvasBasedTextLayout.Create(Self);
end;

procedure TdxCustomDirect2DCanvas.Arc(const AEllipse: TRect;
  const AStartPoint, AEndPoint: TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
var
  A, C: TD2D1Point2F;
  AArcSegment: TD2D1ArcSegment;
  AGeometry: ID2D1PathGeometry1;
  ASink: ID2D1GeometrySink;
begin
  if Succeeded(D2D1Factory1.CreatePathGeometry(AGeometry)) then
  begin
    AArcSegment := D2D1CalculateArcSegment(D2D1Rect(AEllipse), D2D1Point(AStartPoint), D2D1Point(AEndPoint), C, A);

    AGeometry.Open(ASink);
    try
      ASink.BeginFigure(A, D2D1_FIGURE_BEGIN_FILLED);
      try
        ASink.AddArc(AArcSegment);
      finally
        ASink.EndFigure(D2D1_FIGURE_END_OPEN);
      end;
    finally
      ASink.Close;
    end;

    Geometry(AGeometry, TdxAlphaColors.Empty, AColor, APenWidth, CacheGetPenStyle(APenStyle));
  end;
end;

procedure TdxCustomDirect2DCanvas.DonutSlice(const R: TdxRectF;
  AStartAngle, ASweepAngle, AWholePercent: Single;
  ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AArcPoint1: TD2D1Point2F;
  AArcPoint2: TD2D1Point2F;
  AArcSegment: TD2D1ArcSegment;
  ACenter: TD2D1Point2F;
  ADiameter: Single;
  AGeometry: ID2D1PathGeometry1;
  ANativeBrush: TdxDirect2DBrush;
  ANativePen: TdxDirect2DCanvasBasedPenHandle;
  ARect: TD2D1RectF;
  ASink: ID2D1GeometrySink;
  AWholeRect: TD2D1RectF;
begin
  if IsZero(ASweepAngle) then
    Exit;

  if AWholePercent > 0 then
  begin
    if GetNativeBrushAndPen(ABrush, APen, ANativeBrush, ANativePen) then
    begin
      ARect := D2D1Rect(R);
      ADiameter := Min(R.Width, R.Height) * AWholePercent / 100;
      AWholeRect := ARect.Center(ADiameter, ADiameter);

      if Succeeded(D2D1Factory1.CreatePathGeometry(AGeometry)) then
      begin
        AArcSegment := D2D1CalculateArcSegment(ARect, AStartAngle, ASweepAngle, ACenter, AArcPoint1);

        AGeometry.Open(ASink);
        try
          ASink.BeginFigure(AArcPoint1, D2D1_FIGURE_BEGIN_FILLED);
          try
            ASink.AddArc(AArcSegment);

            AArcSegment := D2D1CalculateArcSegment(AWholeRect, AStartAngle + ASweepAngle, -ASweepAngle, ACenter, AArcPoint2);
            ASink.AddLine(AArcPoint2);
            ASink.AddArc(AArcSegment);
            ASink.AddLine(AArcPoint1);
          finally
            ASink.EndFigure(D2D1_FIGURE_END_OPEN);
          end;
        finally
          ASink.Close;
        end;

        Geometry(AGeometry, ARect, ANativeBrush, ANativePen);
      end;
    end;
  end
  else
    Pie(R, AStartAngle, ASweepAngle, ABrush, APen);
end;

procedure TdxCustomDirect2DCanvas.FillRect(const R: TRect; AColor: TdxAlphaColor);
begin
  if dxAlphaColorIsValid(AColor) then
    DeviceContext.FillRectangle(D2D1Rect(R), CacheGetSolidBrush(AColor));
end;

procedure TdxCustomDirect2DCanvas.DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte);
var
  AHandle: ID2D1Bitmap;
begin
  if GetNativeImage(AImage, AHandle) then
    DrawBitmap(AHandle, ATargetRect, ASourceRect, AAlpha);
end;

procedure TdxCustomDirect2DCanvas.DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte);
var
  AHandle: ID2D1Bitmap;
begin
  if GetNativeImage(AImage, AHandle) then
    DrawBitmap(AHandle, ATargetRect, ASourceRect, AAlpha);
end;

procedure TdxCustomDirect2DCanvas.FillRectByGradientCore(
  const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode);
var
  AGradientBrush: ID2D1LinearGradientBrush;
  AGradientBrushProperties: TD2D1LinearGradientBrushProperties;
  AGradientStop: array[0..1] of TD2D1GradientStop;
  AGradientStopCollection: ID2D1GradientStopCollection;
  ATargetRect: TD2D1RectF;
begin
  ATargetRect := D2D1Rect(R);

  AGradientBrushProperties.startPoint := D2D1PointF(ATargetRect.left, ATargetRect.top);
  case AMode of
    LinearGradientModeVertical:
      AGradientBrushProperties.endPoint := D2D1PointF(ATargetRect.left, ATargetRect.bottom);
    LinearGradientModeForwardDiagonal:
      AGradientBrushProperties.endPoint := D2D1PointF(ATargetRect.right, ATargetRect.bottom);
    LinearGradientModeBackwardDiagonal:
      begin
        AGradientBrushProperties.startPoint := D2D1PointF(ATargetRect.right, ATargetRect.bottom);
        AGradientBrushProperties.endPoint := D2D1PointF(ATargetRect.left, ATargetRect.top);
      end;
  else
    AGradientBrushProperties.endPoint := D2D1PointF(ATargetRect.right, ATargetRect.top);
  end;

  AGradientStop[0].position := 0;
  AGradientStop[0].color := D2D1ColorF(AColor1);
  AGradientStop[1].position := 1;
  AGradientStop[1].color := D2D1ColorF(AColor2);

  CheckD2D1Result(DeviceContext.CreateGradientStopCollection(@AGradientStop[0],
    Length(AGradientStop), D2D1_GAMMA_2_2, D2D1_EXTEND_MODE_CLAMP, AGradientStopCollection));
  CheckD2D1Result(DeviceContext.CreateLinearGradientBrush(
    AGradientBrushProperties, nil, AGradientStopCollection, AGradientBrush));
  DeviceContext.FillRectangle(ATargetRect, AGradientBrush);
end;

procedure TdxCustomDirect2DCanvas.Rectangle(const R: TRect;
  ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer);
var
  ARect: TD2DRectF;
begin
  ARect := D2D1Rect(R);
  if dxAlphaColorIsValid(ABrushColor) then
    DeviceContext.FillRectangle(ARect, CacheGetSolidBrush(ABrushColor));
  if dxAlphaColorIsValid(APenColor) and (APenWidth > 0) then
    DeviceContext.DrawRectangle(ARect, CacheGetSolidBrush(APenColor), APenWidth, CacheGetPenStyle(APenStyle));
end;

procedure TdxCustomDirect2DCanvas.RectangleCore(const R: TdxRectF;
  ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle);
var
  ARect: TD2DRectF;
begin
  ARect := D2D1Rect(R);
  if (ABrushHandle <> nil) and not ABrushHandle.IsEmpty then
    DeviceContext.FillRectangle(ARect,
      TdxDirect2DCanvasBasedBrushHandle(ABrushHandle).FBrush.GetHandle(ARect));

  if (APenHandle <> nil) and not APenHandle.IsEmpty then
    DeviceContext.DrawRectangle(ARect,
      TdxDirect2DCanvasBasedPenHandle(APenHandle).GetBrush(ARect),
      TdxDirect2DCanvasBasedPenHandle(APenHandle).Width,
      TdxDirect2DCanvasBasedPenHandle(APenHandle).StrokeStyle);
end;

procedure TdxCustomDirect2DCanvas.Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  ANativeBrush: TdxDirect2DBrush;
  ANativePen: TdxDirect2DCanvasBasedPenHandle;
begin
  if CheckIsValid(APath) and GetNativeBrushAndPen(ABrush, APen, ANativeBrush, ANativePen) then
    Geometry(TdxDirect2DCanvasBasedPath(APath).BuildHandle, ANativeBrush, ANativePen)
end;

procedure TdxCustomDirect2DCanvas.Pie(const R: TdxRectF;
  AStartAngle, ASweepAngle: Single; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AArcPoint: TD2D1Point2F;
  AArcSegment: TD2D1ArcSegment;
  ACenter: TD2D1Point2F;
  AGeometry: ID2D1PathGeometry1;
  ANativeBrush: TdxDirect2DBrush;
  ANativePen: TdxDirect2DCanvasBasedPenHandle;
  ARect: TD2D1RectF;
  ASink: ID2D1GeometrySink;
begin
  if IsZero(ASweepAngle) then
    Exit;

  if GetNativeBrushAndPen(ABrush, APen, ANativeBrush, ANativePen) then
  begin
    if Succeeded(D2D1Factory1.CreatePathGeometry(AGeometry)) then
    begin
      ARect := D2D1Rect(R);
      AArcSegment := D2D1CalculateArcSegment(ARect, AStartAngle, ASweepAngle, ACenter, AArcPoint);

      AGeometry.Open(ASink);
      try
        ASink.BeginFigure(ACenter, D2D1_FIGURE_BEGIN_FILLED);
        try
          ASink.AddLine(AArcPoint);
          ASink.AddArc(AArcSegment);
        finally
          ASink.EndFigure(D2D1_FIGURE_END_CLOSED);
        end;
      finally
        ASink.Close;
      end;

      Geometry(AGeometry, ARect, ANativeBrush, ANativePen);
    end;
  end;
end;

procedure TdxCustomDirect2DCanvas.Polygon(const P: PdxPointF; ACount: Integer; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  ANativeBrush: TdxDirect2DBrush;
  ANativePen: TdxDirect2DCanvasBasedPenHandle;
begin
  if GetNativeBrushAndPen(ABrush, APen, ANativeBrush, ANativePen) then
    Geometry(CreatePathGeometry(P, ACount, D2D1_FIGURE_BEGIN_FILLED, D2D1_FIGURE_END_CLOSED), ANativeBrush, ANativePen);
end;

procedure TdxCustomDirect2DCanvas.Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor);
begin
  if dxAlphaColorIsValid(ABrushColor) or dxAlphaColorIsValid(APenColor) then
    Geometry(CreatePathGeometry(PPoint(@P[0]), Length(P), D2D1_FIGURE_BEGIN_FILLED, D2D1_FIGURE_END_CLOSED), ABrushColor, APenColor);
end;

procedure TdxCustomDirect2DCanvas.Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen);
var
  ANativeBrush: TdxDirect2DBrush;
  ANativePen: TdxDirect2DCanvasBasedPenHandle;
begin
  if GetNativeBrushAndPen(nil, APen, ANativeBrush, ANativePen) then
    Geometry(CreatePathGeometry(P, ACount, D2D1_FIGURE_BEGIN_HOLLOW, D2D1_FIGURE_END_OPEN), ANativeBrush, ANativePen);
end;

procedure TdxCustomDirect2DCanvas.Line(const P1, P2: TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  if dxAlphaColorIsValid(AColor) then
    DeviceContext.DrawLine(D2D1Point(P1), D2D1Point(P2), CacheGetSolidBrush(AColor), APenWidth, CacheGetPenStyle(APenStyle));
end;

procedure TdxCustomDirect2DCanvas.Line(const P1, P2: TPoint; AColor: TColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  Line(P1, P2, dxColorToAlphaColor(AColor), APenWidth, APenStyle);
end;

procedure TdxCustomDirect2DCanvas.Line(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen);
var
  ABox: TD2D1RectF;
  ANativeBrush: TdxDirect2DBrush;
  ANativePen: TdxDirect2DCanvasBasedPenHandle;
  APoint1: TD2D1Point2F;
  APoint2: TD2D1Point2F;
begin
  if GetNativeBrushAndPen(nil, APen, ANativeBrush, ANativePen) then
  begin
    APoint1 := D2D1Point(P1);
    APoint2 := D2D1Point(P2);

    ABox.left := Min(APoint1.x, APoint2.x);
    ABox.top := Min(APoint1.y, APoint2.y);
    ABox.right := Max(APoint1.x, APoint2.x);
    ABox.bottom := Max(APoint1.y, APoint2.y);

    DeviceContext.DrawLine(APoint1, APoint2, ANativePen.GetBrush(ABox), ANativePen.Width, ANativePen.StrokeStyle);
  end;
end;

procedure TdxCustomDirect2DCanvas.Polyline(const P: array of TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  if dxAlphaColorIsValid(AColor) then
    Geometry(CreatePathGeometry(PPoint(@P[0]), Length(P), D2D1_FIGURE_BEGIN_HOLLOW, D2D1_FIGURE_END_OPEN),
      TdxAlphaColors.Empty, AColor, APenWidth, CacheGetPenStyle(APenStyle));
end;

procedure TdxCustomDirect2DCanvas.DrawBitmap(const AHandle: ID2D1Bitmap; const ATargetRect: TRect);
var
  ATarget: TD2D1RectF;
begin
  ATarget := D2D1Rect(ATargetRect);
  DeviceContext.DrawBitmap(AHandle, @ATarget, 1, InterpolationModeMap[ImageStretchQuality]);
end;

procedure TdxCustomDirect2DCanvas.DrawBitmap(const AHandle: ID2D1Bitmap; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte);
var
  ASource: TD2D1RectF;
  ATarget: TD2D1RectF;
begin
  ASource := D2D1Rect(ASourceRect);
  ATarget := D2D1Rect(ATargetRect);
  DeviceContext.DrawBitmap(AHandle, @ATarget, AAlpha / MaxByte, InterpolationModeMap[ImageStretchQuality], @ASource);
end;

procedure TdxCustomDirect2DCanvas.DrawBitmap(const AHandle: ID2D1Bitmap; const ATargetRect, ASourceRect: TRect; AAlpha: Byte);
var
  ASource: TD2D1RectF;
  ATarget: TD2D1RectF;
begin
  ASource := D2D1Rect(ASourceRect);
  ATarget := D2D1Rect(ATargetRect);
  DeviceContext.DrawBitmap(AHandle, @ATarget, AAlpha / MaxByte, InterpolationModeMap[ImageStretchQuality], @ASource);
end;

procedure TdxCustomDirect2DCanvas.ApplyClipRect;
begin
  DeviceContext.PushAxisAlignedClip(D2D1Rect(FClipRect), D2D1_ANTIALIAS_MODE_ALIASED);
  Inc(FClipRectModificationCount);
end;

procedure TdxCustomDirect2DCanvas.IntersectClipRect(const ARect: TRect);
begin
  cxRectIntersect(FClipRect, ARect, FClipRect);
  ApplyClipRect;
end;

function TdxCustomDirect2DCanvas.RectVisible(const R: TRect): Boolean;
begin
  Result := cxRectIntersect(R, FClipRect);
end;

procedure TdxCustomDirect2DCanvas.RestoreClipRegion;
begin
  RollbackClipRectChanges;
  FClipRect := FSavedClipRects.Pop;
  DeviceContext.PopAxisAlignedClip;
  ApplyClipRect;
end;

procedure TdxCustomDirect2DCanvas.SaveClipRegion;
begin
  RollbackClipRectChanges;
  FSavedClipRects.Push(FClipRect);
  DeviceContext.PushAxisAlignedClip(D2D1Rect(FClipRect), D2D1_ANTIALIAS_MODE_ALIASED);
end;

procedure TdxCustomDirect2DCanvas.ModifyWorldTransform(const AForm: TXForm);
begin
  FWorldTransform := D2D1Matrix3x2(AForm) * FWorldTransform;
  ApplyWorldTransform;
end;

procedure TdxCustomDirect2DCanvas.RestoreWorldTransform;
begin
  FWorldTransform := FSavedWorldTransforms.Pop;
  ApplyWorldTransform;
end;

procedure TdxCustomDirect2DCanvas.SaveWorldTransform;
begin
  FSavedWorldTransforms.Push(FWorldTransform);
end;

procedure TdxCustomDirect2DCanvas.RestoreState;
begin
  WindowOrg := FSavedWindowOrgs.Pop;
  RestoreWorldTransform;
  RestoreClipRegion;
end;

procedure TdxCustomDirect2DCanvas.SaveState;
begin
  FSavedWindowOrgs.Push(WindowOrg);
  SaveWorldTransform;
  SaveClipRegion;
end;

procedure TdxCustomDirect2DCanvas.FlushCache;
begin
  FCacheNativeObjects.Clear;
  FCacheSolidBrushes.Clear;
end;

procedure TdxCustomDirect2DCanvas.ReleaseDevice;
begin
  ReleaseResources;
  FlushCache;
  DeviceContext := nil;
end;

procedure TdxCustomDirect2DCanvas.DoBeginDraw(const AClipRect: TRect);
const
  ModeMap: array[Boolean] of TD2D1AntiAliasMode = (
    D2D1_ANTIALIAS_MODE_ALIASED, D2D1_ANTIALIAS_MODE_PER_PRIMITIVE
  );
begin
  FClipRect := AClipRect;
  FWorldTransform := TD2DMatrix3x2F.Identity;
  DeviceContext.SetAntialiasMode(ModeMap[dxDirectXAntialiasing]);
  DeviceContext.SetTextAntialiasMode(dxDirectXTextAntialiasMode);
  DeviceContext.BeginDraw;
  IntersectClipRect(FClipRect);
end;

procedure TdxCustomDirect2DCanvas.DoEndDraw;
begin
  RollbackClipRectChanges;
  if CheckNeedRecreateContext(DeviceContext.EndDraw) then
    FRecreateContextNeeded := True;
end;

function TdxCustomDirect2DCanvas.GetSharedBrushes: TcxCanvasBasedSharedBrushes;
begin
  Result := FSharedBrushes;
end;

function TdxCustomDirect2DCanvas.GetSharedFonts: TcxCanvasBasedSharedFonts;
begin
  Result := TdxDirect2DCanvasBasedSharedFonts.Instance;
end;

function TdxCustomDirect2DCanvas.GetSharedImageLists: TcxCanvasBasedSharedImageLists;
begin
  Result := FSharedImageLists;
end;

function TdxCustomDirect2DCanvas.GetSharedPens: TcxCanvasBasedSharedPens;
begin
  Result := FSharedPens;
end;

function TdxCustomDirect2DCanvas.GetWindowOrg: TPoint;
begin
  Result := FWindowOrg;
end;

procedure TdxCustomDirect2DCanvas.SetDeviceContext(const Value: ID2D1DeviceContext);
begin
  FDeviceContext := Value;
  if DeviceContext <> nil then
    FMaxBitmapSize := DeviceContext.GetMaximumBitmapSize
  else
    FMaxBitmapSize := 0;
end;

procedure TdxCustomDirect2DCanvas.SetWindowOrg(const AValue: TPoint);
var
  ADelta: TPoint;
begin
  ADelta := cxPointOffset(AValue, FWindowOrg, False);
  if not cxPointIsNull(ADelta) then
  begin
    FClipRect := cxRectOffset(FClipRect, ADelta);
    FWindowOrg := AValue;
    ApplyWorldTransform;
  end;
end;

function TdxCustomDirect2DCanvas.CacheGetPenStyle(const AStyle: TdxStrokeStyle): ID2D1StrokeStyle;
begin
  Result := TdxDirect2DPenStyleCache.Get(AStyle);
end;

function TdxCustomDirect2DCanvas.CacheGetPenStyle(const AStyle: TPenStyle): ID2D1StrokeStyle;
begin
  case AStyle of
    psDash:
      Result := CacheGetPenStyle(TdxStrokeStyle.Dash);
    psDot:
      Result := CacheGetPenStyle(TdxStrokeStyle.Dot);
    psDashDot:
      Result := CacheGetPenStyle(TdxStrokeStyle.DashDot);
    psDashDotDot:
      Result := CacheGetPenStyle(TdxStrokeStyle.DashDotDot);
  else
    Result := CacheGetPenStyle(TdxStrokeStyle.Solid);
  end;
end;

function TdxCustomDirect2DCanvas.CacheGetSolidBrush(const AColor: TdxAlphaColor): ID2D1SolidColorBrush;
begin
  if not FCacheSolidBrushes.Get(AColor, Result) then
  begin
    DeviceContext.CreateSolidColorBrush(D2D1ColorF(AColor), nil, Result);
    FCacheSolidBrushes.Add(AColor, Result);
  end;
end;

function TdxCustomDirect2DCanvas.CreateBrushHandle(const ABrush: TdxGPCustomBrush): TdxDirect2DCanvasBasedBrushHandle;
begin
  Result := TdxDirect2DCanvasBasedBrushHandle.Create(TdxDirect2DBrushFactory.Create(DeviceContext, ABrush));
end;

function TdxCustomDirect2DCanvas.CreatePenHandle(const APen: TdxGPPen): TdxDirect2DCanvasBasedPenHandle;
begin
  Result := TdxDirect2DCanvasBasedPenHandle.Create(CreateNativeStrokeStyle(APen), APen.Width, CreateBrushHandle(APen.Brush));
end;

function TdxCustomDirect2DCanvas.CreatePathGeometry(APoints: PPoint; ACount: Integer;
  AFigureBegin: TD2D1FigureBegin; AFigureEnd: TD2D1_FigureEnd): ID2D1PathGeometry1;
var
  ASink: ID2D1GeometrySink;
begin
  if ACount <= 0 then
    Exit(nil);
  if Failed(D2D1Factory1.CreatePathGeometry(Result)) then
    Exit(nil);
  if Succeeded(Result.Open(ASink)) then
  try
    ASink.BeginFigure(D2D1Point(APoints^), AFigureBegin);
    Inc(APoints);
    Dec(ACount);

    while ACount > 0 do
    begin
      ASink.AddLine(D2D1Point(APoints^));
      Inc(APoints);
      Dec(ACount);
    end;
    ASink.EndFigure(AFigureEnd);
  finally
    ASink.Close;
  end;
end;

function TdxCustomDirect2DCanvas.CreatePathGeometry(APoints: PdxPointF; ACount: Integer;
  AFigureBegin: TD2D1FigureBegin; AFigureEnd: TD2D1_FigureEnd): ID2D1PathGeometry1;
var
  ASink: ID2D1GeometrySink;
begin
  if ACount <= 0 then
    Exit(nil);
  if Failed(D2D1Factory1.CreatePathGeometry(Result)) then
    Exit(nil);
  if Succeeded(Result.Open(ASink)) then
  try
    ASink.BeginFigure(D2D1Point(APoints^), AFigureBegin);
    ASink.AddLines(PD2D1Point2F(APoints), ACount);
    ASink.EndFigure(AFigureEnd);
  finally
    ASink.Close;
  end;
end;

function TdxCustomDirect2DCanvas.CreateNativeStrokeStyle(APen: TdxGPPen): ID2D1StrokeStyle1;
const
  DashCapStyle: array[TdxGPPenDashCapStyle] of TD2D1CapStyle = (
    D2D1_CAP_STYLE_FLAT,
    D2D1_CAP_STYLE_ROUND,
    D2D1_CAP_STYLE_TRIANGLE
  );
  LineCapMap: array[TdxGPPenLineCapStyle] of TD2D1CapStyle = (
    D2D1_CAP_STYLE_FLAT,
    D2D1_CAP_STYLE_SQUARE,
    D2D1_CAP_STYLE_ROUND
  );
  LineJoinMap: array[TdxGpLineJoin] of TD2D1LineJoin = (
    D2D1_LINE_JOIN_MITER,
    D2D1_LINE_JOIN_BEVEL,
    D2D1_LINE_JOIN_ROUND,
    D2D1_LINE_JOIN_MITER_OR_BEVEL
  );
  StyleMap: array[TdxGPPenStyle] of TD2D1DashStyle = (
    D2D1_DASH_STYLE_SOLID,
    D2D1_DASH_STYLE_DASH,
    D2D1_DASH_STYLE_DOT,
    D2D1_DASH_STYLE_DASH_DOT,
    D2D1_DASH_STYLE_DASH_DOT_DOT
  );
var
  AProperties: TD2D1StrokeStyleProperties1;
begin
  ZeroMemory(@AProperties, SizeOf(AProperties));
  AProperties.StartCap := LineCapMap[APen.LineStartCapStyle];
  AProperties.EndCap := LineCapMap[APen.LineEndCapStyle];
  AProperties.dashCap := DashCapStyle[APen.DashCapStyle];
  AProperties.LineJoin := LineJoinMap[APen.LineJoin];
  AProperties.MiterLimit := APen.MiterLimit;
  AProperties.DashStyle := StyleMap[APen.Style];
  AProperties.DashOffset := 0;
  AProperties.TransformType := D2D1_STROKE_TRANSFORM_TYPE_NORMAL;
  D2D1Factory1.CreateStrokeStyle(@AProperties, nil, 0, Result);
end;

function TdxCustomDirect2DCanvas.CreateNativeObjectTexture(
  const ARect, AClippedRect: TRect; AProc: TcxCanvasNativeDrawProc): ID2D1Bitmap;
var
  ABitmap: TcxBitmap32;
begin
  ABitmap := TcxBitmap32.CreateSize(AClippedRect, True);
  try
    ABitmap.cxCanvas.WindowOrg := AClippedRect.TopLeft;
    AProc(ABitmap.cxCanvas, ARect);
    Result := D2D1Bitmap(DeviceContext, ABitmap, afPremultiplied);
  finally
    ABitmap.Free;
  end;
end;

function TdxCustomDirect2DCanvas.CreateNativeObjectTexture(
  const ARect, AClippedRect: TRect; AProc: TcxCanvasNativeDrawExProc): ID2D1Bitmap;
var
  ACanvas: TdxGPCanvas;
  ABitmap: TdxGpFastDIB;
begin
  ABitmap := TdxGpFastDIB.Create(AClippedRect);
  try
    ACanvas := ABitmap.CreateCanvas;
    try
      ACanvas.TranslateWorldTransform(-AClippedRect.Left, -AClippedRect.Top);
      AProc(ACanvas, ARect);
    finally
      ACanvas.Free;
    end;
    Result := D2D1Bitmap(DeviceContext, ABitmap, afPremultiplied);
  finally
    ABitmap.Free;
  end;
end;

function TdxCustomDirect2DCanvas.GetGdiInteropRenderTarget(out ATarget: ID2D1GdiInteropRenderTarget; out DC: HDC): Boolean;
begin
  if FIsGDICompatible and Supports(DeviceContext, ID2D1GdiInteropRenderTarget, ATarget) then
    FIsGDICompatible := Succeeded(ATarget.GetDC(D2D1_DC_INITIALIZE_MODE_COPY, DC));
  Result := FIsGDICompatible;
end;

function TdxCustomDirect2DCanvas.GetNativeBrushAndPen(ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen;
  out ANativeBrush: TdxDirect2DBrush; out ANativePen: TdxDirect2DCanvasBasedPenHandle): Boolean;
begin
  if (ABrush <> nil) and not ABrush.IsEmpty then
    ANativeBrush := TdxDirect2DCanvasBasedBrushHandle(TcxCanvasBasedResourceAccess(ABrush).Handle).FBrush
  else
    ANativeBrush := nil;

  if (APen <> nil) and not APen.IsEmpty then
    ANativePen := TdxDirect2DCanvasBasedPenHandle(TcxCanvasBasedResourceAccess(APen).Handle)
  else
    ANativePen := nil;

  Result := (ANativeBrush <> nil) or (ANativePen <> nil);
end;

function TdxCustomDirect2DCanvas.GetNativeImage(AImageResource: TcxCanvasBasedImage; out AHandle: ID2D1Bitmap): Boolean;
begin
  if AImageResource.Canvas <> Self then
    raise EInvalidArgument.Create(sdxInternalErrorResourceOwnerMismatch);
  AHandle := (AImageResource as TdxDirect2DCanvasBasedImage).Handle;
  Result := AHandle <> nil;
end;

function TdxCustomDirect2DCanvas.IsLargeForTexture(const R: TRect): Boolean;
begin
  Result := Max(cxRectWidth(R), cxRectHeight(R)) > FMaxBitmapSize;
end;

procedure TdxCustomDirect2DCanvas.ApplyWorldTransform;
var
  ATransform: TD2D1Matrix3x2F;
begin
  ATransform := D2D1Matrix3x2(1, 0, 0, 1, -FWindowOrg.X, -FWindowOrg.Y);
  ATransform := FWorldTransform * ATransform;
  DeviceContext.SetTransform(ATransform);
end;

procedure TdxCustomDirect2DCanvas.RollbackClipRectChanges;
begin
  while FClipRectModificationCount > 0 do
  begin
    DeviceContext.PopAxisAlignedClip;
    Dec(FClipRectModificationCount);
  end;
end;

{ TdxDirect2DCanvasBasedFontHandle }

procedure TdxDirect2DCanvasBasedFontHandle.CreateNativeHandle(ACanvas: TcxCustomCanvas);
var
  AStyle: DWRITE_FONT_STYLE;
  AWeight: DWRITE_FONT_WEIGHT;
begin
  if fsItalic in Style then
    AStyle := DWRITE_FONT_STYLE_ITALIC
  else
    AStyle := DWRITE_FONT_STYLE_NORMAL;

  if fsBold in Style then
    AWeight := DWRITE_FONT_WEIGHT_BOLD
  else
    AWeight := DWRITE_FONT_WEIGHT_NORMAL;

  DWriteFactory.CreateTextFormat(PChar(FName), nil, AWeight, AStyle, DWRITE_FONT_STRETCH_NORMAL, -FHeight, 'en-us', FNativeHandle);
end;

procedure TdxDirect2DCanvasBasedFontHandle.FreeNativeHandle;
begin
  FEndEllipsisSign := nil;
  FNativeHandle := nil;
end;

function TdxDirect2DCanvasBasedFontHandle.GetEndEllipsisSign: IDWriteInlineObject;
begin
  if FEndEllipsisSign = nil then
    DWriteFactory.CreateEllipsisTrimmingSign(NativeHandle, FEndEllipsisSign);
  Result := FEndEllipsisSign;
end;

{ TdxDirect2DCanvasBasedImage }

constructor TdxDirect2DCanvasBasedImage.Create(ACanvas: TdxCustomDirect2DCanvas; AHandle: ID2D1Bitmap; AWidth, AHeight: Integer);
begin
  inherited Create(ACanvas, AWidth, AHeight);
  FHandle := AHandle;
end;

procedure TdxDirect2DCanvasBasedImage.Release;
begin
  FHandle := nil;
  inherited;
end;

{ TdxDirect2DCanvasBasedPath }

constructor TdxDirect2DCanvasBasedPath.Create(ACanvas: TdxCustomDirect2DCanvas);
begin
  inherited Create(ACanvas);
  if Failed(D2D1Factory1.CreatePathGeometry(FHandle)) or Failed(FHandle.Open(FSink)) then
  begin
    FHandle := nil;
    FSink := nil;
  end;
end;

destructor TdxDirect2DCanvasBasedPath.Destroy;
begin
  CloseSink;
  inherited;
end;

function TdxDirect2DCanvasBasedPath.BuildHandle: ID2D1PathGeometry1;
begin
  CloseSink;
  Result := FHandle;
end;

procedure TdxDirect2DCanvasBasedPath.Release;
begin
  CloseSink;
  FHandle := nil;
end;

procedure TdxDirect2DCanvasBasedPath.AddArc(const AEllipse: TdxRectF; const AStartAngle, ASweepAngle: Single);
var
  AArcSegment: TD2D1ArcSegment;
  ACenter: TD2D1Point2F;
  AStartPoint: TD2D1Point2F;
begin
  if FSink <> nil then
  begin
    AArcSegment := D2D1CalculateArcSegment(D2D1Rect(AEllipse), AStartAngle, ASweepAngle, ACenter, AStartPoint);
    StartFigureIfNecessary(AStartPoint);
    FSink.AddArc(AArcSegment);
  end;
end;

procedure TdxDirect2DCanvasBasedPath.AddPolyline(Points: PdxPointF; Count: Integer);
begin
  if (FSink <> nil) and (Points <> nil) and (Count > 0) then
  begin
    StartFigureIfNecessary(D2D1Point(Points^));
    FSink.AddLines(PD2D1Point2F(Points), Count);
  end;
end;

procedure TdxDirect2DCanvasBasedPath.CloseSink;
begin
  FinishFigureIfNecessary(D2D1_FIGURE_END_OPEN);
  if FSink <> nil then
  try
    FSink.Close;
  finally
    FSink := nil;
  end;
end;

procedure TdxDirect2DCanvasBasedPath.FigureClose;
begin
  FinishFigureIfNecessary(D2D1_FIGURE_END_CLOSED);
end;

procedure TdxDirect2DCanvasBasedPath.FigureStart;
begin
  FinishFigureIfNecessary(D2D1_FIGURE_END_OPEN);
end;

procedure TdxDirect2DCanvasBasedPath.FinishFigureIfNecessary(const AMode: TD2D1_FigureEnd);
begin
  if FFigureStarted then
  begin
    FSink.EndFigure(AMode);
    FFigureStarted := False;
  end;
end;

procedure TdxDirect2DCanvasBasedPath.StartFigureIfNecessary(const P: TD2D1Point2F);
begin
  if (FSink <> nil) and not FFigureStarted then
  begin
    FSink.BeginFigure(P, D2D1_FIGURE_BEGIN_FILLED);
    FFigureStarted := True;
  end;
end;

{ TdxDirect2DCanvasBasedTextLayout }

constructor TdxDirect2DCanvasBasedTextLayout.Create(ACanvas: TdxCustomDirect2DCanvas);
begin
  inherited Create(ACanvas);
  FColor := TdxAlphaColors.Black;
end;

procedure TdxDirect2DCanvasBasedTextLayout.Release;
begin
  FHandle := nil;
  inherited Release;
end;

procedure TdxDirect2DCanvasBasedTextLayout.SetColor(AColor: TdxAlphaColor);
begin
  FColor := AColor;
end;

procedure TdxDirect2DCanvasBasedTextLayout.DoCalculate(AMaxWidth, AMaxHeight, AMaxRowCount: Integer);

  procedure CalculateOptimalLayoutLimitedByRowCount;
  var
    AOptimalWidth: Single;
    ATextMetrics: TDWriteTextMetrics;
    AWidth, AWidthLow, AWidthHigh: Single;
  begin
    FHandle.SetMaxHeight(0);
    FHandle.SetMaxWidth(MaxWord);
    FHandle.GetMetrics(ATextMetrics);

    AOptimalWidth := MaxWord;
    AWidthHigh := ATextMetrics.widthIncludingTrailingWhitespace;
    AWidthLow := AWidthHigh / (Length(FText) + 1);
    while AWidthLow <= AWidthHigh do
    begin
      AWidth := (AWidthLow + AWidthHigh) / 2;
      FHandle.SetMaxWidth(AWidth);
      FHandle.GetMetrics(ATextMetrics);
      if ATextMetrics.lineCount <= Cardinal(AMaxRowCount) then
      begin
        AWidthHigh := AWidth - 1;
        if ATextMetrics.lineCount = Cardinal(AMaxRowCount) then
        begin
          if AWidth > AOptimalWidth then
            Break;
          AOptimalWidth := AWidth;
        end;
      end
      else
        AWidthLow := AWidth + 1;
    end;
    FHandle.SetMaxWidth(AOptimalWidth);
  end;

  function GetActualMaxHeight(AMaxHeight: Single): Single;
  var
    ATextMetrics: TdxDWriteTextMetrics;
  begin
    if AMaxHeight > 0 then
      Result := Min(AMaxHeight, MaxSize)
    else
      if AMaxRowCount > 0 then
      begin
        CalculateTextMetrics(ATextMetrics);
        Result := Ceil(AMaxRowCount * ATextMetrics.LineHeight);
      end
      else
        Result := 1;
  end;

  function GetActualMaxWidth(AMaxWidth: Single): Single;
  begin
    Result := MaxSize;
    if AMaxWidth > 0 then
    begin
      Result := Min(Result, AMaxWidth);
      if FFlags and (CXTO_CHARBREAK or CXTO_END_ELLIPSIS) = 0 then
        Result := Max(Result, GetMinWidth); 
    end;
  end;

var
  ATextMetrics: TdxDWriteTextMetrics;
begin
  HandleNeeded;

  if FText = '' then
  begin
    FTextSize := cxNullSize; 
    FTextTruncated := False;
    FRowCount := 0;
    Exit;
  end;

  if (AMaxWidth = 0) and (AMaxRowCount > 1) then
    CalculateOptimalLayoutLimitedByRowCount
  else
  begin
    FHandle.SetMaxWidth(GetActualMaxWidth(AMaxWidth));
    FHandle.SetMaxHeight(GetActualMaxHeight(AMaxHeight));
  end;

  CalculateTextMetrics(ATextMetrics);
  if AMaxRowCount > 0 then
    ATextMetrics.LineCount := Min(ATextMetrics.LineCount, AMaxRowCount);
  if AMaxHeight > 0 then
    ATextMetrics.LineCount := Min(ATextMetrics.LineCount, CalculateRowCount(AMaxHeight, ATextMetrics.LineHeight));

  FTextTruncated := ATextMetrics.Truncated;
  FTextSize.cx := Ceil(ATextMetrics.WidthIncludingTrailingWhitespace);
  FTextSize.cy := Ceil(ATextMetrics.LineCount * ATextMetrics.LineHeight);
  FRowCount := ATextMetrics.LineCount;

  FHandle.SetMaxWidth(FTextSize.cx);
  FHandle.SetMaxHeight(FTextSize.cy);
end;

procedure TdxDirect2DCanvasBasedTextLayout.DoDraw(const R: TRect);
begin
  if Canvas <> nil then
    Canvas.DrawTextLayout(FHandle, R.Left, R.Top, FColor);
end;

procedure TdxDirect2DCanvasBasedTextLayout.DoSetFont(AFontHandle: TcxCanvasBasedFontHandle);
begin
  if not (AFontHandle is TdxDirect2DCanvasBasedFontHandle) then
    raise EInvalidArgument.Create(sdxInternalErrorResourceOwnerMismatch);
  inherited;
end;

procedure TdxDirect2DCanvasBasedTextLayout.FontChanged;
begin
  TextChanged;
end;

procedure TdxDirect2DCanvasBasedTextLayout.TextChanged;
begin
  FHandle := nil;
  inherited;
end;

procedure TdxDirect2DCanvasBasedTextLayout.ApplyFlags;
var
  ARtlReading: Boolean;
  ATrimming: TDwriteTrimming;
begin
  if FHandle = nil then Exit;

  ARtlReading := FFlags and CXTO_RTLREADING = CXTO_RTLREADING;

  if ARtlReading then
    FHandle.SetReadingDirection(DWRITE_READING_DIRECTION_RIGHT_TO_LEFT)
  else
    FHandle.SetReadingDirection(DWRITE_READING_DIRECTION_LEFT_TO_RIGHT);

  if FFlags and CXTO_CENTER_HORIZONTALLY = CXTO_CENTER_HORIZONTALLY then
    FHandle.SetTextAlignment(DWRITE_TEXT_ALIGNMENT_CENTER)
  else if (FFlags and CXTO_RIGHT = CXTO_RIGHT) = not ARtlReading then
    FHandle.SetTextAlignment(DWRITE_TEXT_ALIGNMENT_TRAILING)
  else
    FHandle.SetTextAlignment(DWRITE_TEXT_ALIGNMENT_LEADING);

  if FFlags and CXTO_WORDBREAK = CXTO_WORDBREAK then
    FHandle.SetWordWrapping(DWRITE_WORD_WRAPPING_WRAP)
  else
    FHandle.SetWordWrapping(DWRITE_WORD_WRAPPING_NO_WRAP);

  ATrimming.delimiter := 0;
  ATrimming.delimiterCount := 0;
  FHasEndEllipsis := FFlags and CXTO_END_ELLIPSIS = CXTO_END_ELLIPSIS;
  if FHasEndEllipsis then
  begin
    ATrimming.granularity := DWRITE_TRIMMING_GRANULARITY_CHARACTER;
    FHandle.SetTrimming(ATrimming, Font.EndEllipsisSign);
  end
  else
  begin
    ATrimming.granularity := DWRITE_TRIMMING_GRANULARITY_NONE;
    FHandle.SetTrimming(ATrimming, nil);
  end;
end;

procedure TdxDirect2DCanvasBasedTextLayout.CalculateTextMetrics(out AMetrics: TdxDWriteTextMetrics);
var
  I: Integer;
  ALineCount: Cardinal;
  ALineMetrics: array of TDwriteLineMetrics;
  ATextMetrics: TDWriteTextMetrics;
begin
  FHandle.GetMetrics(ATextMetrics);

  ZeroMemory(@AMetrics, SizeOf(AMetrics));
  AMetrics.Height := ATextMetrics.height;
  AMetrics.Width := ATextMetrics.width;
  AMetrics.WidthIncludingTrailingWhitespace := ATextMetrics.widthIncludingTrailingWhitespace;

  if FHasEndEllipsis then
  begin
    FHandle.GetLineMetrics(nil, 0, ALineCount);
    if ALineCount > 0 then
    begin
      SetLength(ALineMetrics, ALineCount);
      FHandle.GetLineMetrics(@ALineMetrics[0], ALineCount, ALineCount);
      AMetrics.LineHeight := ALineMetrics[0].height;
      for I := 0 to ALineCount - 1 do
      begin
        if ALineMetrics[I].height > 0 then
          Inc(AMetrics.LineCount)
        else
          Break;

        AMetrics.Truncated := AMetrics.Truncated or ALineMetrics[I].isTrimmed;
      end;
    end;
  end
  else
  begin
    AMetrics.LineCount := ATextMetrics.lineCount;
    AMetrics.LineHeight := ATextMetrics.height / Max(1, ATextMetrics.lineCount);
  end;
end;

procedure TdxDirect2DCanvasBasedTextLayout.HandleNeeded;
var
  AErrorCode: HRESULT;
  ATextRange: TDwriteTextRange;
begin
  if FHandle = nil then
  begin
    if Canvas = nil then
      raise EdxDirectXInvalidStateException.CreateFmt(sdxErrorCannotCreateTextLayoutHandle, ['Canvas']);
    if Font = nil then
      raise EdxDirectXInvalidStateException.CreateFmt(sdxErrorCannotCreateTextLayoutHandle, ['Font']);
    if Font.NativeHandle = nil then
      raise EdxDirectXInvalidStateException.CreateFmt(sdxErrorCannotCreateTextLayoutHandle, ['Font']);

    FMinWidth := -1;
    AErrorCode := DWriteFactory.CreateTextLayout(PWideChar(FText), Length(FText), Font.NativeHandle, 0, 0, FHandle);
    if FHandle = nil then
      raise EdxDirectXError.Create(AErrorCode);

    ATextRange.StartPosition := 0;
    ATextRange.Length := Length(FText);
    if fsUnderline in Font.Style then
      FHandle.SetUnderline(True, ATextRange);
    if fsStrikeOut in Font.Style then
      FHandle.SetStrikethrough(True, ATextRange);
    ApplyFlags;
  end;
end;

function TdxDirect2DCanvasBasedTextLayout.GetCanvas: TdxCustomDirect2DCanvas;
begin
  Result := TdxCustomDirect2DCanvas(inherited Canvas);
end;

function TdxDirect2DCanvasBasedTextLayout.GetFont: TdxDirect2DCanvasBasedFontHandle;
begin
  Result := TdxDirect2DCanvasBasedFontHandle(FFontHandle);
end;

function TdxDirect2DCanvasBasedTextLayout.GetMinWidth: Single;
begin
  if FMinWidth < 0 then
    FHandle.DetermineMinWidth(FMinWidth);
  Result := FMinWidth;
end;

{ TdxDirect2DGdiCompatibleCanvas }

constructor TdxDirect2DGdiCompatibleCanvas.Create;
begin
  inherited Create;
  CreateRenderTarget;
end;

procedure TdxDirect2DGdiCompatibleCanvas.BeginPaint(DC: HDC; const R: TRect);
begin
  FRenderTarget.BindDC(DC, R);
  DoBeginDraw(R);
end;

procedure TdxDirect2DGdiCompatibleCanvas.EndPaint;
begin
  DoEndDraw;
  if FRecreateContextNeeded then
    CreateRenderTarget;
end;

procedure TdxDirect2DGdiCompatibleCanvas.CreateRenderTarget;
var
  AProperties: TD2D1RenderTargetProperties;
begin
  ZeroMemory(@AProperties, SizeOf(AProperties));
  AProperties.&type := D2D1_RENDER_TARGET_TYPE_DEFAULT;
  AProperties.pixelFormat := D2D1PixelFormat(DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED);
  AProperties.usage := D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE;
  CheckD2D1Result(D2D1Factory1.CreateDCRenderTarget(AProperties, FRenderTarget));
  DeviceContext := FRenderTarget as ID2D1DeviceContext;
  FRecreateContextNeeded := False;
end;

{ TdxDirect2DHwndBasedCanvas }

constructor TdxDirect2DHwndBasedCanvas.Create(const AOwner: IdxDirect2DCanvasOwner;
  const ADevice: IDXGIDevice1; const AContext: ID2D1DeviceContext;
  const ADevice3D: ID3D11Device; const ADevice3DContext: ID3D11DeviceContext);
begin
  inherited Create;
  FOwner := AOwner;
  FDevice := ADevice;
  FDevice3D := ADevice3D;
  FDevice3DContext := ADevice3DContext;
  DeviceContext := AContext;

  FPresentParameters.DirtyRectsCount := 1;
  FPresentParameters.pDirtyRects := @FUpdateRect;
end;

function TdxDirect2DHwndBasedCanvas.IsBufferValid: Boolean;
begin
  Result := FIsBufferValid;
end;

procedure TdxDirect2DHwndBasedCanvas.MarkBufferInvalid;
begin
  FIsBufferValid := False;
end;

procedure TdxDirect2DHwndBasedCanvas.BeginPaint;
var
  AWindowSize: TSize;
begin
  AWindowSize := cxSize(cxGetClientRect(FWindowHandle));
  Windows.BeginPaint(FWindowHandle, FPaintStruct);
  if dxDirectXVSync then
    FUpdateRect := FPaintStruct.rcPaint
  else
    FUpdateRect := cxRect(AWindowSize);

  if not cxSizeIsEqual(FTextureSize, AWindowSize) then
  begin
    ReleaseTexture;
    FTextureSize := AWindowSize;
    CheckD2D1Result(FSwapChain.ResizeBuffers(0, FTextureSize.cx, FTextureSize.cy, DXGI_FORMAT_UNKNOWN, 0));
    CreateTexture;
    FUpdateRect := cxRect(FTextureSize);
  end;

  DoBeginDraw(FUpdateRect);
end;

procedure TdxDirect2DHwndBasedCanvas.EndPaint;
begin
  DoEndDraw;
  DoPresentBuffer;
  Windows.EndPaint(FWindowHandle, FPaintStruct);
  if FRecreateContextNeeded then
    FOwner.RecreateNeeded;
end;

procedure TdxDirect2DHwndBasedCanvas.CopyToDC(DC: HDC);
var
  R: TRect;
begin
  R := cxRect(FTextureSize);
  if not cxRectIsEmpty(R) then
    CopyToDC(DC, R, R);
end;

procedure TdxDirect2DHwndBasedCanvas.CopyToDC(DC: HDC; const ATargetRect, ASourceRect: TRect);
var
  ASourceBox: TD3D11Box;
  ASourceDC: HDC;
  ASurface: IDXGISurface1;
begin
  CheckCreateFrontBufferContent;

  ASourceBox := TD3D11Box.Create(ASourceRect);
  Device3DContext.CopySubResourceRegion(
    FFrontBufferContent, 0, ASourceRect.Left, ASourceRect.Top, 0,
    FFrontBufferSurface as ID3D11Resource, 0, @ASourceBox);

  if Supports(FFrontBufferContent, IDXGISurface1, ASurface) then
  begin
    ASurface.GetDC(False, ASourceDC);
    cxBitBlt(DC, ASourceDC, ATargetRect, ASourceRect.TopLeft, SRCCOPY);
    ASurface.ReleaseDC(nil);
  end;
end;

procedure TdxDirect2DHwndBasedCanvas.SetWndHandle(AHandle: HWND);
const
  ScalingMode: array[Boolean] of TDXGIScaling = (DXGI_SCALING_STRETCH, DXGI_SCALING_NONE);
var
  AAdapter: IDXGIAdapter;
  AFactory: IDXGIFactory2;
  ASwapChainDescription: TDXGISwapChainDesc1;
begin
  if FWindowHandle <> AHandle then
  begin
    if FWindowHandle <> 0 then
    begin
      ReleaseTexture;
      FSwapChain := nil;
      FWindowHandle := 0;
      FWinControl := nil;
    end;
    if AHandle <> 0 then
    begin
      FWindowHandle := AHandle;
      FWinControl := FindControl(FWindowHandle);

      CheckD2D1Result(FDevice.SetMaximumFrameLatency(Ord(dxDirectXSwapChainSize) - 1));
      CheckD2D1Result(FDevice.GetAdapter(AAdapter));
      CheckD2D1Result(AAdapter.GetParent(IDXGIFactory2, AFactory));

      ZeroMemory(@ASwapChainDescription, SizeOf(ASwapChainDescription));
      ASwapChainDescription.Format := DXGI_FORMAT_B8G8R8A8_UNORM;
      ASwapChainDescription.SampleDesc.Count := 1;
      ASwapChainDescription.BufferUsage := DXGI_USAGE_RENDER_TARGET_OUTPUT;
      ASwapChainDescription.BufferCount := dxDirectXSwapChainSize;
      ASwapChainDescription.SwapEffect := DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL;
      ASwapChainDescription.Scaling := ScalingMode[IsWin8OrLater];

      CheckD2D1Result(AFactory.CreateSwapChainForHwnd(FDevice3D, AHandle, @ASwapChainDescription, nil, nil, FSwapChain));
    end;
    MarkBufferInvalid;
  end;
end;

function TdxDirect2DHwndBasedCanvas.GetDefaultUseRightToLeftAlignment: Boolean;
begin
  Result := (FWinControl <> nil) and FWinControl.UseRightToLeftAlignment;
end;

procedure TdxDirect2DHwndBasedCanvas.CreateTexture;
var
  ABufferProperties: TD2D1BitmapProperties1;
  ACanvasTarget: ID2D1Bitmap1;
  ASurface: IDXGISurface;
begin
  FSwapChain.GetBuffer(0, IDXGISurface, ASurface);
  FSwapChain.GetBuffer(1, IDXGISurface, FFrontBufferSurface);

  ZeroMemory(@ABufferProperties, SizeOf(ABufferProperties));
  ABufferProperties.pixelFormat.format := DXGI_FORMAT_B8G8R8A8_UNORM;
  ABufferProperties.pixelFormat.alphaMode := D2D1_ALPHA_MODE_PREMULTIPLIED;
  ABufferProperties.bitmapOptions := D2D1_BITMAP_OPTIONS_TARGET or D2D1_BITMAP_OPTIONS_CANNOT_DRAW;
  CheckD2D1Result(DeviceContext.CreateBitmapFromDxgiSurface(ASurface, ABufferProperties, ACanvasTarget));
  DeviceContext.SetTarget(ACanvasTarget);
  MarkBufferInvalid;
end;

procedure TdxDirect2DHwndBasedCanvas.ReleaseDevice;
begin
  ReleaseTexture;
  inherited;
end;

procedure TdxDirect2DHwndBasedCanvas.ReleaseTexture;
begin
  FFrontBufferSurface := nil;
  FFrontBufferContent := nil;
  FFrontBufferContentSize := cxNullSize;
  DeviceContext.SetTarget(nil);
  FTextureSize := cxNullSize;
  MarkBufferInvalid;
end;

procedure TdxDirect2DHwndBasedCanvas.CheckCreateFrontBufferContent;
var
  ATextureDescription: TD3D11Texture2DDesc;
  AFrontBufferTexture: ID3D11Texture2D;
begin
  if not cxSizeIsEqual(FTextureSize, FFrontBufferContentSize) then
    FFrontBufferContent := nil;

  if FFrontBufferContent = nil then
  begin
    AFrontBufferTexture := FFrontBufferSurface as ID3D11Texture2D;
    AFrontBufferTexture.GetDesc(ATextureDescription);

    ATextureDescription.BindFlags := D3D11_BIND_RENDER_TARGET;
    ATextureDescription.Usage := D3D11_USAGE_DEFAULT;
    ATextureDescription.MiscFlags := D3D11_RESOURCE_MISC_GDI_COMPATIBLE;
    ATextureDescription.MipLevels := 1;
    ATextureDescription.SampleDesc.Count := 1;
    ATextureDescription.SampleDesc.Quality := 0;

    CheckD2D1Result(Device3D.CreateTexture2D(ATextureDescription, nil, FFrontBufferContent));
    FFrontBufferContentSize := FTextureSize;
  end;
end;

procedure TdxDirect2DHwndBasedCanvas.DoPresentBuffer;
begin
  if not cxRectIsEmpty(FUpdateRect) then
  try
    FSwapChain.Present1(0, IfThen(dxDirectXVSync, 0, DXGI_PRESENT_DO_NOT_WAIT), @FPresentParameters);
    FIsBufferValid := True;
  except
    on E: Exception do
    begin
      if CheckNeedSwitchToGdiRenderMode(E) then
        FRecreateContextNeeded := True
      else
        raise;
    end;
  end;
end;

{ TdxDirect2DCanvasBasedSharedFonts }

class procedure TdxDirect2DCanvasBasedSharedFonts.Finalize;
begin
  FreeAndNil(FInstance);
end;

class function TdxDirect2DCanvasBasedSharedFonts.Instance: TdxDirect2DCanvasBasedSharedFonts;
begin
  if FInstance = nil then
    FInstance := TdxDirect2DCanvasBasedSharedFonts.Create(nil, TdxDirect2DCanvasBasedFontHandle);
  Result := FInstance;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  if IsWin8 then
    dxDirectXSwapChainSize := 4;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxDirect2DCanvasBasedSharedFonts.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
