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

unit dxDirectX.D2D.Classes; // for internal use only

interface

{$I cxVer.inc}

uses
  UITypes,
  Types, Windows, Classes, Math, Graphics, D2D1, dxCore, dxCoreGraphics, dxGenerics, cxGeometry,
  dxGdiplusApi, dxGdiplusClasses, dxDirectX.D2D.Types, cxCustomCanvas;

type

  { TdxDirect2DBrush }

  TdxDirect2DBrush = class
  strict private
    FContext: ID2D1DeviceContext;
  protected
    FHandle: ID2D1Brush;
  public
    constructor Create(const AContext: ID2D1DeviceContext);
    function GetHandle(const R: TD2DRectF): ID2D1Brush; virtual;
    function IsEmpty: Boolean; virtual;
    //
    property Context: ID2D1DeviceContext read FContext;
  end;

  { TdxDirect2DSolidBrush }

  TdxDirect2DSolidBrush = class(TdxDirect2DBrush)
  public
    constructor Create(const AContext: ID2D1DeviceContext; const AColor: TdxAlphaColor);
  end;

  { TdxDirect2DHatchBrush }

  TdxDirect2DHatchBrush = class(TdxDirect2DBrush)
  public
    constructor Create(const AContext: ID2D1DeviceContext; const ATexture: ID2D1Bitmap);
  end;

  { TdxDirect2DCustomTexturedBrush }

  TdxDirect2DCustomTexturedBrush = class(TdxDirect2DBrush)
  strict private
    FOrigin: TdxPointF;
    FOriginalTransform: TdxGpMatrix;
  protected
    procedure ApplyTransformation(const ABrush: ID2D1Brush; const AOrigin: TdxPointF); virtual;
  public
    constructor Create(const AContext: ID2D1DeviceContext; ATransform: TdxGPMatrix = nil);
    destructor Destroy; override;
    function GetHandle(const R: TD2DRectF): ID2D1Brush; override;
    //
    property OriginalTransform: TdxGpMatrix read FOriginalTransform;
  end;

  { TdxDirect2DComplexNativeBrush }

  TdxDirect2DComplexNativeBrush = class(TdxDirect2DCustomTexturedBrush)
  strict private
    FBrush: TdxGPCustomBrush;
    FSize: TD2D1SizeF;

    function CreateHandle(const S: TD2D1SizeF): ID2D1BitmapBrush1;
  public
    constructor Create(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush);
    destructor Destroy; override;
    class function CreateBrushBitmap(const AContext: ID2D1DeviceContext;
      ABrush: TdxGPCustomBrush; AWidth, AHeight: Integer): ID2D1Bitmap;
    function GetHandle(const R: TD2DRectF): ID2D1Brush; override;
    function IsEmpty: Boolean; override;
  end;

  { TdxDirect2DCustomGradientBrush }

  TdxDirect2DCustomGradientBrush = class(TdxDirect2DBrush)
  strict private
    FStopCollection: ID2D1GradientStopCollection;
    FTargetRect: TD2DRectF;
  protected
    function CreateHandle(const R: TD2DRectF; const AStops: ID2D1GradientStopCollection): ID2D1Brush; virtual; abstract;
    procedure SetGradientStops(AStops: TD2D1GradientStops);
  public
    function GetHandle(const R: TD2DRectF): ID2D1Brush; override; final;
    function IsEmpty: Boolean; override;
  end;

  { TdxDirect2DLineGradientBrush }

  TdxDirect2DLineGradientBrush = class(TdxDirect2DCustomGradientBrush)
  strict private
    FEndPoint: TdxPointF;
    FStartPoint: TdxPointF;
  protected
    function CreateHandle(const R: TD2DRectF; const AStops: ID2D1GradientStopCollection): ID2D1Brush; override;
  public
    constructor Create(const AContext: ID2D1DeviceContext; AStops: TD2D1GradientStops; const AStartPoint, AEndPoint: TdxPointF);
  end;

  { TdxDirect2DLinearGradientBrush }

  TdxDirect2DLinearGradientBrush = class(TdxDirect2DCustomGradientBrush)
  strict private
    FMode: TdxGpLinearGradientMode;
  protected
    function CreateHandle(const R: TD2DRectF; const AStops: ID2D1GradientStopCollection): ID2D1Brush; override;
  public
    constructor Create(const AContext: ID2D1DeviceContext; AStops: TD2D1GradientStops; AMode: TdxGpLinearGradientMode);
  end;

  { TdxDirect2DRadialGradientBrush }

  TdxDirect2DRadialGradientBrush = class(TdxDirect2DCustomGradientBrush)
  strict private
    FCenter: TdxPointF;
    FRadius: TdxPointF;
  protected
    function CreateHandle(const R: TD2DRectF; const AStops: ID2D1GradientStopCollection): ID2D1Brush; override;
  public
    constructor Create(const AContext: ID2D1DeviceContext; AStops: TD2D1GradientStops; const ACenter, ARadius: TdxPointF);
  end;

  { TdxDirect2DTexturedBrush }

  TdxDirect2DTexturedBrush = class(TdxDirect2DCustomTexturedBrush)
  public
    constructor Create(const AContext: ID2D1DeviceContext; const ATexture: ID2D1Bitmap; ATextureTransform: TdxGPMatrix = nil);
  end;

  { TdxDirect2DBrushFactory }

  TdxDirect2DBrushFactory = class
  strict private type
    TCreateBrushFunc = function (const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
  strict private
    class var FFactory: TdxClassDictionary<TCreateBrushFunc>;

    class function CreateBrush(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush; static;
    class function CreateComplexBrush(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush; static;
    class function CreateHatchBrush(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush; static;
    class function CreateLinearGradientBrush(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush; static;
    class function CreateLinearGradientBrushCore(const AContext: ID2D1DeviceContext;
      APoints: TdxGPBrushGradientPoints; AMode: TdxGpLinearGradientMode): TdxDirect2DBrush; overload; static;
    class function CreateLinearGradientBrushCore(const AContext: ID2D1DeviceContext;
      APoints: TdxGPBrushGradientPoints; const AStartPoint, AFinishPoint: TdxPointF): TdxDirect2DBrush; overload; static;
    class function CreateRadialBrush(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush; static;
    class function CreateSolidBrush(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush; static;
    class function CreateSolidBrushCore(const AContext: ID2D1DeviceContext; AColor: TdxAlphaColor): TdxDirect2DBrush; static;
    class function CreateTextureBrush(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush; static;
    class function CreateTextureBrushCore(const AContext: ID2D1DeviceContext;
      ATexture: TdxGPImage; ATextureTransform: TdxGPMatrix = nil): TdxDirect2DBrush; static;
  protected
    class procedure CheckCreated;
    class procedure Finalize;
  public
    class function Create(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
  end;

  { TdxDirect2DPenStyleCache }

  TdxDirect2DPenStyleCache = class
  strict private
    class var FCache: array[TdxStrokeStyle] of ID2D1StrokeStyle1;
  public
    class function Get(AStyle: TdxStrokeStyle): ID2D1StrokeStyle1;
  end;

implementation

uses
  ActiveX, SysUtils, dxDirectX.D2D.Utils, dxShapeBrushes;

const
  dxThisUnitName = 'dxDirectX.D2D.Classes';

{ TdxDirect2DPenStyleCache }

class function TdxDirect2DPenStyleCache.Get(AStyle: TdxStrokeStyle): ID2D1StrokeStyle1;
const
  Styles: array[TdxStrokeStyle] of TD2D1DashStyle = (
    D2D1_DASH_STYLE_SOLID,
    D2D1_DASH_STYLE_DASH,
    D2D1_DASH_STYLE_DOT,
    D2D1_DASH_STYLE_DASH_DOT,
    D2D1_DASH_STYLE_DASH_DOT_DOT
  );
var
  AProperties: TD2D1StrokeStyleProperties1;
begin
  if AStyle = TdxStrokeStyle.Solid then
    Exit(nil);

  Result := FCache[AStyle];
  if Result = nil then
  begin
    ZeroMemory(@AProperties, SizeOf(AProperties));
    AProperties.StartCap := D2D1_CAP_STYLE_FLAT;
    AProperties.EndCap := D2D1_CAP_STYLE_FLAT;
    AProperties.dashCap := D2D1_CAP_STYLE_SQUARE;
    AProperties.LineJoin := D2D1_LINE_JOIN_MITER;
    AProperties.MiterLimit := 10;
    AProperties.DashStyle := Styles[AStyle];
    AProperties.DashOffset := 0;
    AProperties.TransformType := D2D1_STROKE_TRANSFORM_TYPE_NORMAL;
    D2D1Factory1.CreateStrokeStyle(@AProperties, nil, 0, Result);
    FCache[AStyle] := Result;
  end;
end;

{ TdxDirect2DBrush }

constructor TdxDirect2DBrush.Create(const AContext: ID2D1DeviceContext);
begin
  FContext := AContext;
end;

function TdxDirect2DBrush.GetHandle(const R: TD2DRectF): ID2D1Brush;
begin
  Result := FHandle;
end;

function TdxDirect2DBrush.IsEmpty: Boolean;
begin
  Result := FHandle = nil;
end;

{ TdxDirect2DCustomTexturedBrush }

constructor TdxDirect2DCustomTexturedBrush.Create(const AContext: ID2D1DeviceContext; ATransform: TdxGPMatrix);
begin
  inherited Create(AContext);
  if (ATransform <> nil) and ATransform.HandleAllocated then
    FOriginalTransform := ATransform.Clone;
end;

destructor TdxDirect2DCustomTexturedBrush.Destroy;
begin
  FreeAndNil(FOriginalTransform);
  inherited;
end;

function TdxDirect2DCustomTexturedBrush.GetHandle(const R: TD2DRectF): ID2D1Brush;
begin
  Result := FHandle;
  if (R.left <> FOrigin.X) or (R.top <> FOrigin.Y) then
  begin
    FOrigin := dxPointF(R.left, R.top);
    ApplyTransformation(Result, FOrigin);
  end;
end;

procedure TdxDirect2DCustomTexturedBrush.ApplyTransformation(const ABrush: ID2D1Brush; const AOrigin: TdxPointF);
var
  ATransform: TdxGPMatrix;
begin
  if FOriginalTransform <> nil then
  begin
    ATransform := FOriginalTransform.Clone;
    try
      ATransform.Translate(AOrigin.X, AOrigin.Y, MatrixOrderAppend);
      ABrush.SetTransform(D2D1Matrix3x2(ATransform.ToXForm));
    finally
      ATransform.Free;
    end;
  end
  else
    ABrush.SetTransform(D2D1Matrix3x2(1, 0, 0, 1, AOrigin.X, AOrigin.Y));
end;

{ TdxDirect2DSolidBrush }

constructor TdxDirect2DSolidBrush.Create(const AContext: ID2D1DeviceContext; const AColor: TdxAlphaColor);
var
  ABrush: ID2D1SolidColorBrush;
begin
  inherited Create(AContext);
  AContext.CreateSolidColorBrush(D2D1ColorF(AColor), nil, ABrush);
  FHandle := ABrush;
end;

{ TdxDirect2DHatchBrush }

constructor TdxDirect2DHatchBrush.Create(const AContext: ID2D1DeviceContext; const ATexture: ID2D1Bitmap);
var
  ABrush: ID2D1BitmapBrush1;
  ABrushProperties: TD2D1BitmapBrushProperties1;
begin
  inherited Create(AContext);

  ZeroMemory(@ABrushProperties, SizeOf(ABrushProperties));
  ABrushProperties.extendModeX := D2D1_EXTEND_MODE_WRAP;
  ABrushProperties.extendModeY := D2D1_EXTEND_MODE_WRAP;
  ABrushProperties.interpolationMode := D2D1_INTERPOLATION_MODE_NEAREST_NEIGHBOR;

  CheckD2D1Result(AContext.CreateBitmapBrush(ATexture, @ABrushProperties, nil, ABrush));
  FHandle := ABrush;
end;

{ TdxDirect2DComplexNativeBrush }

constructor TdxDirect2DComplexNativeBrush.Create(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush);
begin
  inherited Create(AContext);
  FBrush := TdxGPCustomBrush(ABrush.Clone);
end;

destructor TdxDirect2DComplexNativeBrush.Destroy;
begin
  FreeAndNil(FBrush);
  inherited;
end;

class function TdxDirect2DComplexNativeBrush.CreateBrushBitmap(
  const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush; AWidth, AHeight: Integer): ID2D1Bitmap;
var
  ABuffer: TdxGpFastDIB;
  ABufferCanvas: TdxGPCanvas;
begin
  ABuffer := TdxGpFastDIB.Create(AWidth, AHeight, True);
  try
    ABufferCanvas := ABuffer.CreateCanvas;
    try
      ABufferCanvas.FillRectangle(ABuffer.ClientRect, ABrush);
    finally
      ABufferCanvas.Free;
    end;
    Result := D2D1Bitmap(AContext, ABuffer, afPremultiplied);
  finally
    ABuffer.Free;
  end;
end;

function TdxDirect2DComplexNativeBrush.GetHandle(const R: TD2DRectF): ID2D1Brush;
begin
  if not D2D1SizeIsEqual(R, FSize) then
  begin
    FSize := R.Size;
    FHandle := CreateHandle(FSize);
  end;
  Result := inherited;
end;

function TdxDirect2DComplexNativeBrush.IsEmpty: Boolean;
begin
  Result := FBrush.IsEmpty;
end;

function TdxDirect2DComplexNativeBrush.CreateHandle(const S: TD2D1SizeF): ID2D1BitmapBrush1;
var
  ABitmap: ID2D1Bitmap;
  AProperties: TD2D1BitmapBrushProperties1;
begin
  ABitmap := CreateBrushBitmap(Context, FBrush, Round(S.width), Round(S.height));

  ZeroMemory(@AProperties, SizeOf(AProperties));
  AProperties.extendModeX := D2D1_EXTEND_MODE_WRAP;
  AProperties.extendModeY := D2D1_EXTEND_MODE_WRAP;
  AProperties.interpolationMode := D2D1_INTERPOLATION_MODE_NEAREST_NEIGHBOR;

  CheckD2D1Result(Context.CreateBitmapBrush(ABitmap, @AProperties, nil, Result));
end;

{ TdxDirect2DCustomGradientBrush }

function TdxDirect2DCustomGradientBrush.GetHandle(const R: TD2DRectF): ID2D1Brush;
begin
  if not D2D1RectIsEqual(R, FTargetRect) then
  begin
    FTargetRect := R;
    FHandle := CreateHandle(R, FStopCollection);
  end;
  Result := FHandle;
end;

function TdxDirect2DCustomGradientBrush.IsEmpty: Boolean;
begin
  Result := False;
end;

procedure TdxDirect2DCustomGradientBrush.SetGradientStops(AStops: TD2D1GradientStops);
begin
  CheckD2D1Result(Context.CreateGradientStopCollection(
    @AStops[0], Length(AStops), D2D1_GAMMA_2_2, D2D1_EXTEND_MODE_CLAMP, FStopCollection));
end;

{ TdxDirect2DLineGradientBrush }

constructor TdxDirect2DLineGradientBrush.Create(
  const AContext: ID2D1DeviceContext; AStops: TD2D1GradientStops; const AStartPoint, AEndPoint: TdxPointF);
begin
  inherited Create(AContext);
  SetGradientStops(AStops);
  FStartPoint := AStartPoint;
  FEndPoint := AEndPoint;
end;

function TdxDirect2DLineGradientBrush.CreateHandle(
  const R: TD2DRectF; const AStops: ID2D1GradientStopCollection): ID2D1Brush;
var
  ABrush: ID2D1LinearGradientBrush;
  AProperties: TD2D1LinearGradientBrushProperties;
begin
  AProperties.startPoint.x := R.left + FStartPoint.X * R.width;
  AProperties.startPoint.y := R.top + FStartPoint.Y * R.height;
  AProperties.endPoint.x := R.left + FEndPoint.X * R.width;
  AProperties.endPoint.y := R.top + FEndPoint.Y * R.height;
  CheckD2D1Result(Context.CreateLinearGradientBrush(AProperties, nil, AStops, ABrush));
  Result := ABrush;
end;

{ TdxDirect2DLinearGradientBrush }

constructor TdxDirect2DLinearGradientBrush.Create(
  const AContext: ID2D1DeviceContext; AStops: TD2D1GradientStops; AMode: TdxGpLinearGradientMode);
begin
  inherited Create(AContext);
  FMode := AMode;
  SetGradientStops(AStops);
end;

function TdxDirect2DLinearGradientBrush.CreateHandle(
  const R: TD2DRectF; const AStops: ID2D1GradientStopCollection): ID2D1Brush;
var
  ABrush: ID2D1LinearGradientBrush;
  AProperties: TD2D1LinearGradientBrushProperties;
begin
  AProperties.startPoint := D2D1PointF(R.left, R.top);
  case FMode of
    LinearGradientModeVertical:
      AProperties.endPoint := D2D1PointF(R.left, R.bottom);
    LinearGradientModeHorizontal:
      AProperties.endPoint := D2D1PointF(R.right, R.top);
    LinearGradientModeBackwardDiagonal:
      begin
        AProperties.startPoint := D2D1PointF(R.right, R.top);
        AProperties.endPoint := D2D1PointF(R.left, R.bottom);
      end;
  else
    AProperties.endPoint := D2D1PointF(R.right, R.bottom);
  end;

  CheckD2D1Result(Context.CreateLinearGradientBrush(AProperties, nil, AStops, ABrush));
  Result := ABrush;
end;

{ TdxDirect2DTexturedBrush }

constructor TdxDirect2DTexturedBrush.Create(
  const AContext: ID2D1DeviceContext; const ATexture: ID2D1Bitmap; ATextureTransform: TdxGPMatrix);
var
  ABrush: ID2D1BitmapBrush1;
  ABrushProperties: TD2D1BitmapBrushProperties1;
  AProperties: TD2D1BrushProperties;
  APropertiesPtr: PD2D1BrushProperties;
begin
  inherited Create(AContext, ATextureTransform);

  if OriginalTransform <> nil then
  begin
    ZeroMemory(@AProperties, SizeOf(AProperties));
    AProperties.opacity := 1;
    AProperties.transform := D2D1Matrix3x2(OriginalTransform.ToXForm);
    APropertiesPtr := @AProperties;
  end
  else
    APropertiesPtr := nil;

  ZeroMemory(@ABrushProperties, SizeOf(ABrushProperties));
  ABrushProperties.extendModeX := D2D1_EXTEND_MODE_WRAP;
  ABrushProperties.extendModeY := D2D1_EXTEND_MODE_WRAP;
  ABrushProperties.interpolationMode := D2D1_INTERPOLATION_MODE_NEAREST_NEIGHBOR;

  CheckD2D1Result(Context.CreateBitmapBrush(ATexture, @ABrushProperties, APropertiesPtr, ABrush));
  FHandle := ABrush;
end;

{ TdxDirect2DRadialGradientBrush }

constructor TdxDirect2DRadialGradientBrush.Create(
  const AContext: ID2D1DeviceContext; AStops: TD2D1GradientStops; const ACenter, ARadius: TdxPointF);
begin
  inherited Create(AContext);
  FCenter := ACenter;
  FRadius := ARadius;
  SetGradientStops(AStops);
end;

function TdxDirect2DRadialGradientBrush.CreateHandle(
  const R: TD2DRectF; const AStops: ID2D1GradientStopCollection): ID2D1Brush;
var
  ABrush: ID2D1RadialGradientBrush;
  ABrushProperties: TD2D1RadialGradientBrushProperties;
begin
  ZeroMemory(@ABrushProperties, SizeOf(ABrushProperties));
  ABrushProperties.radiusY := FRadius.X * R.Height;
  ABrushProperties.radiusX := FRadius.Y * R.Width;
  ABrushProperties.center.x := R.left + FCenter.X * R.Width;
  ABrushProperties.center.y := R.top  + FCenter.Y * R.Height;
  CheckD2D1Result(Context.CreateRadialGradientBrush(ABrushProperties, nil, AStops, ABrush));
  Result := ABrush;
end;

{ TdxDirect2DBrushFactory }

class function TdxDirect2DBrushFactory.Create(const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
begin
  CheckCreated;
  Result := FFactory.Items[ABrush.ClassType](AContext, ABrush);
end;

class procedure TdxDirect2DBrushFactory.CheckCreated;
begin
  if FFactory = nil then
  begin
    FFactory := TdxClassDictionary<TCreateBrushFunc>.Create;
    FFactory.Add(TdxGPCustomBrush, CreateComplexBrush);
    FFactory.Add(TdxGPHatchBrush, CreateHatchBrush);
    FFactory.Add(TdxGpLinearGradientBrush, CreateLinearGradientBrush);
    FFactory.Add(TdxGPSolidBrush, CreateSolidBrush);
    FFactory.Add(TdxRadialGradientBrush, CreateRadialBrush);
    FFactory.Add(TdxGpTextureBrush, CreateTextureBrush);
    FFactory.Add(TdxGPBrush, CreateBrush);
  end;
end;

class procedure TdxDirect2DBrushFactory.Finalize;
begin
  FreeAndNil(FFactory);
end;

class function TdxDirect2DBrushFactory.CreateBrush(
  const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
begin
  case TdxGPBrush(ABrush).Style of
    gpbsSolid:
      Result := CreateSolidBrushCore(AContext, TdxGPBrush(ABrush).Color);
    gpbsGradient:
      Result := CreateLinearGradientBrushCore(AContext, TdxGPBrush(ABrush).GradientPoints,
        dxGpBrushGradientModeToLinearGradientMode[TdxGPBrush(ABrush).GradientMode]);
    gpbsTexture:
      Result := CreateTextureBrushCore(AContext, TdxGPBrush(ABrush).Texture, TdxGPBrush(ABrush).TextureTransform);
  else // gpbsClear
    Result := CreateSolidBrushCore(AContext, TdxAlphaColors.Empty);
  end;
end;

class function TdxDirect2DBrushFactory.CreateComplexBrush(
  const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
begin
  Result := TdxDirect2DComplexNativeBrush.Create(AContext, ABrush);
end;

class function TdxDirect2DBrushFactory.CreateHatchBrush(
  const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
begin
  Result := TdxDirect2DHatchBrush.Create(AContext,
    TdxDirect2DComplexNativeBrush.CreateBrushBitmap(AContext, ABrush, 8, 8));
end;

class function TdxDirect2DBrushFactory.CreateLinearGradientBrush(
  const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
var
  AGradientBrush: TdxGpLinearGradientBrush absolute ABrush;
begin
  if AGradientBrush.GradientMode = gplgbmLine then
    Result := CreateLinearGradientBrushCore(AContext, AGradientBrush.GradientPoints, AGradientBrush.StartPoint, AGradientBrush.EndPoint)
  else
    Result := CreateLinearGradientBrushCore(AContext, AGradientBrush.GradientPoints,
      dxGpLinearGradientBrushModeToLinearGradientMode[AGradientBrush.GradientMode]);
end;

class function TdxDirect2DBrushFactory.CreateLinearGradientBrushCore(const AContext: ID2D1DeviceContext;
  APoints: TdxGPBrushGradientPoints; AMode: TdxGpLinearGradientMode): TdxDirect2DBrush;
begin
  Result := TdxDirect2DLinearGradientBrush.Create(AContext, D2D1GradientStops(APoints), AMode);
end;

class function TdxDirect2DBrushFactory.CreateLinearGradientBrushCore(const AContext: ID2D1DeviceContext;
  APoints: TdxGPBrushGradientPoints; const AStartPoint, AFinishPoint: TdxPointF): TdxDirect2DBrush;
begin
  Result := TdxDirect2DLineGradientBrush.Create(AContext, D2D1GradientStops(APoints), AStartPoint, AFinishPoint);
end;

class function TdxDirect2DBrushFactory.CreateRadialBrush(
  const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
begin
  Result := TdxDirect2DRadialGradientBrush.Create(AContext,
    D2D1GradientStops(TdxRadialGradientBrush(ABrush).GradientPoints, True), 
    TdxRadialGradientBrush(ABrush).Center,
    TdxRadialGradientBrush(ABrush).Radius);
end;

class function TdxDirect2DBrushFactory.CreateSolidBrush(
  const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
begin
  Result := CreateSolidBrushCore(AContext, TdxGPSolidBrush(ABrush).Color);
end;

class function TdxDirect2DBrushFactory.CreateSolidBrushCore(
  const AContext: ID2D1DeviceContext; AColor: TdxAlphaColor): TdxDirect2DBrush;
begin
  Result := TdxDirect2DSolidBrush.Create(AContext, AColor);
end;

class function TdxDirect2DBrushFactory.CreateTextureBrush(
  const AContext: ID2D1DeviceContext; ABrush: TdxGPCustomBrush): TdxDirect2DBrush;
begin
  Result := CreateTextureBrushCore(AContext, TdxGpTextureBrush(ABrush).Texture);
end;

class function TdxDirect2DBrushFactory.CreateTextureBrushCore(const AContext: ID2D1DeviceContext;
  ATexture: TdxGPImage; ATextureTransform: TdxGPMatrix = nil): TdxDirect2DBrush;
var
  ABitmap: TBitmap;
begin
  ABitmap := ATexture.GetAsBitmap;
  try
    Result := TdxDirect2DTexturedBrush.Create(AContext, D2D1Bitmap(AContext, ABitmap, afPremultiplied), ATextureTransform);
  finally
    ABitmap.Free;
  end;
end;


initialization

finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxDirect2DBrushFactory.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
