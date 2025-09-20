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

unit dxShapeBrushes;

interface

{$I cxVer.inc}

uses
  Windows, SysUtils,
  dxCoreGraphics, cxGeometry, dxGDIPlusAPI, dxGDIPlusClasses, dxShapePrimitives;

type
  { TdxGPSolidBrush }

  TdxGPSolidBrush = class(TdxGPCustomBrush)
  strict private
    FColor: TdxAlphaColor;

    procedure SetColor(const AValue: TdxAlphaColor);
  protected
    procedure DoCreateHandle(out AHandle: GpHandle); override;
    function GetIsEmpty: Boolean; override;
  public
    constructor Create(AColor: TdxAlphaColor); overload;
    procedure Assign(ASource: TdxGPCustomGraphicObject); override;

    property Color: TdxAlphaColor read FColor write SetColor;
  end;

  { TdxGPTextureBrush }

  TdxGPTextureBrush = class(TdxGPCustomBrush)
  strict private
    FTexture: TdxGpImage;

    procedure SetTexture(const AValue: TdxGpImage);
    procedure ChangeHandler(Sender: TObject);
  protected
    procedure DoCreateHandle(out AHandle: GpHandle); override;
    procedure DoTargetRectChanged; override;
    function GetIsEmpty: Boolean; override;
    function NeedRecreateHandleOnTargetRectChange: Boolean; override;
  public
    constructor Create; overload; override;
    constructor Create(ATexture: TdxGPImage); overload;
    destructor Destroy; override;

    procedure Assign(ASource: TdxGPCustomGraphicObject); override;

    property Texture: TdxGpImage read FTexture write SetTexture;
  end;

  { TdxGpCustomGradientBrush }

  TdxGpCustomGradientBrush = class(TdxGPCustomBrush)
  strict private
    procedure SetGradientPoints(const AValue: TdxGPBrushGradientPoints);
    procedure SetTransformMatrix(const AValue: TdxGPMatrix);
  protected
    FGradientPoints: TdxGPBrushGradientPoints;
    FTransformMatrix: TdxGPMatrix;

    procedure DoCreateHandle(out AHandle: GpHandle); override;
    function NeedRecreateHandleOnTargetRectChange: Boolean; override;
    function GetIsEmpty: Boolean; override;

    function InternalCreateHandle(AOffsets: PSingle; AColors: PdxAlphaColor; ACount: Integer): GpHandle; virtual; abstract;
    procedure PrepareGradientPoints(APoints: TdxGPBrushGradientPoints); virtual;
    function PrepareGradientPointsAndCreateHandle(APoints: TdxGPBrushGradientPoints): GpHandle;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(ASource: TdxGPCustomGraphicObject); override;

    property GradientPoints: TdxGPBrushGradientPoints read FGradientPoints write SetGradientPoints;
    property TransformMatrix: TdxGPMatrix read FTransformMatrix write SetTransformMatrix;
  end;

  { TdxGpLinearGradientBrush }

  TdxGPLinearGradientBrushMode = (gplgbmHorizontal, gplgbmVertical, gplgbmForwardDiagonal, gplgbmBackwardDiagonal, gplgbmLine);

  TdxGPLinearGradientBrush = class(TdxGpCustomGradientBrush)
  strict private
    FGradientMode: TdxGPLinearGradientBrushMode;
    FEndPoint: TdxPointF;
    FStartPoint: TdxPointF;

    procedure SetEndPoint(const AValue: TdxPointF);
    procedure SetGradientMode(const AValue: TdxGPLinearGradientBrushMode);
    procedure SetStartPoint(const AValue: TdxPointF);
    procedure CalculateTransformation(AHandle: GpHandle);
    procedure CalculateTransformMatrix(M11, M12, M21, M22, DX, DY: Single);
    procedure GetBrushTransformElements(AHandle: GpHandle; out M11, M12, M21, M22, DX, DY: Single);
  protected
    function InternalCreateHandle(AOffsets: PSingle; AColors: PdxAlphaColor; ACount: Integer): GpHandle; override;
  public
    constructor Create; override;
    procedure Assign(ASource: TdxGPCustomGraphicObject); override;
    //
    property GradientMode: TdxGPLinearGradientBrushMode read FGradientMode write SetGradientMode;
    property StartPoint: TdxPointF read FStartPoint write SetStartPoint;
    property EndPoint: TdxPointF read FEndPoint write SetEndPoint;
  end;

  { TdxGPPathGradientBrush }

  TdxGPPathGradientBrush = class(TdxGpCustomGradientBrush)
  protected
    function InternalCreateHandle(AOffsets: PSingle; AColors: PdxAlphaColor; ACount: Integer): GpHandle; override;
    procedure DoCreateHandle(out AHandle: GpHandle); override;
    procedure DoPathContent(APath: TdxGPPath); virtual;
    procedure PrepareGradientPoints(APoints: TdxGPBrushGradientPoints); override;
    //
    function GetBounds: TdxRectF; virtual;
  end;

  { TdxLinearGradientBrush }

  TdxLinearGradientBrush = class(TdxGPLinearGradientBrush);

  { TdxRadialGradientBrush }

  TdxRadialGradientBrush = class(TdxGPPathGradientBrush)
  strict private
    FCenter: TdxPointF;
    FRadius: TdxPointF;

    procedure SetCenter(const AValue: TdxPointF);
    procedure SetRadius(const AValue: TdxPointF);
  protected
    function GetBounds: TdxRectF; override;
    procedure DoPathContent(APath: TdxGPPath); override;
    function MakeTargetRect(const R: TdxGpRectF): TdxGpRectF; override;
  public
    constructor Create; override;

    procedure Assign(ASource: TdxGPCustomGraphicObject); override;

    property Center: TdxPointF read FCenter write SetCenter;
    property Radius: TdxPointF read FRadius write SetRadius;
  end;

  { TdxShapeCustomGradientBrush }

  TdxShapeCustomGradientBrush = class(TdxShapeCustomBrush)
  strict private
    function GetGradientPoints: TdxGPBrushGradientPoints;
  protected
    function GetBrushClass: TdxShapeBrushClass; override;
  public
    property GradientPoints: TdxGPBrushGradientPoints read GetGradientPoints;
  end;

  { TdxShapeLinearGradientBrush }

  TdxShapeLinearGradientBrush = class(TdxShapeCustomGradientBrush)
  private
    function GetBrush: TdxLinearGradientBrush;
    function GetEndPoint: string;
    function GetStartPoint: string;
    procedure SetEndPoint(const AValue: string);
    procedure SetStartPoint(const AValue: string);
  protected
    function GetBrushClass: TdxShapeBrushClass; override;
  public
    constructor Create; override;

    class function GetName: string; override;
  published
    property StartPoint: string read GetStartPoint write SetStartPoint;
    property EndPoint: string read GetEndPoint write SetEndPoint;
  end;

  { TdxShapeRadialGradientBrush }

  TdxShapeRadialGradientBrush = class(TdxShapeCustomGradientBrush)
  private
    function GetBrush: TdxRadialGradientBrush;
    function GetCenter: string;
    function GetRadiusX: Single;
    function GetRadiusY: Single;
    procedure SetCenter(const AValue: string);
    procedure SetRadiusX(const AValue: Single);
    procedure SetRadiusY(const AValue: Single);
  protected
    function GetBrushClass: TdxShapeBrushClass; override;
  public
    class function GetName: string; override;
  published
    property Center: string read GetCenter write SetCenter;
    property RadiusX: Single read GetRadiusX write SetRadiusX;
    property RadiusY: Single read GetRadiusY write SetRadiusY;
  end;

  { TdxShapeSolidBrush }

  TdxShapeSolidBrush = class(TdxShapeCustomBrush)
  private
    function GetBrush: TdxGPSolidBrush;
    function GetColor: TdxAlphaColor;
    procedure SetColor(const AValue: TdxAlphaColor);
  public
    class function GetName: string; override;
  published
    property Color: TdxAlphaColor read GetColor write SetColor;
  end;

  { TdxShapeBrushGradientStop }

  TdxShapeBrushGradientStop = class(TdxShapeObject)
  private
    FColor: string;
    FOffset: Single;
  public
    class function GetReaderClass: TdxShapeObjectReaderClass; override;
    class function GetName: string; override;
  published
    property Color: string read FColor write FColor;
    property Offset: Single read FOffset write FOffset;
  end;

const
  dxGpLinearGradientBrushModeToLinearGradientMode: array[TdxGPLinearGradientBrushMode] of TdxGpLinearGradientMode = (
    LinearGradientModeHorizontal, LinearGradientModeVertical, LinearGradientModeForwardDiagonal,
    LinearGradientModeBackwardDiagonal, LinearGradientModeBackwardDiagonal
  );

implementation

uses
  Classes, Graphics, Math, dxShapeReaders;

const
  dxThisUnitName = 'dxShapeBrushes';

type
  TdxGPBrushGradientPointsAccess = class(TdxGPBrushGradientPoints);

procedure dxSortGradientPoints(AGradientPoints: TdxGPBrushGradientPoints);

type
  TdxGradientPoint = record
    Offset: Single;
    Color: TdxAlphaColor;
  end;
  PdxGradientPoint = ^TdxGradientPoint;

  procedure CalculateGradientPoints(APoints: TList);

    procedure AddGradientPoint(AList: TList; AOffset: Single; const AColor: TdxAlphaColor);
    var
      AGradientPoint: PdxGradientPoint;
    begin
      GetMem(AGradientPoint, SizeOf(TdxGradientPoint));
      AGradientPoint.Color := AColor;
      AGradientPoint.Offset := AOffset;
      AList.Add(AGradientPoint)
    end;

  var
    I: Integer;
    AMinOffset, AMaxOffset: Single;
    AStartColor, AEndColor: TdxAlphaColor;
  begin
    AMinOffset := MaxSingle;
    AMaxOffset := MinSingle;
    AStartColor := dxColorToAlphaColor(clNone);
    AEndColor := dxColorToAlphaColor(clNone);
    for I := 0 to AGradientPoints.Count - 1 do
    begin
      if AGradientPoints.Offsets[I] < AMinOffset then
      begin
        AMinOffset := AGradientPoints.Offsets[I];
        AStartColor := AGradientPoints.Colors[I];
      end;
      if AGradientPoints.Offsets[I] > AMaxOffset then
      begin
        AMaxOffset := AGradientPoints.Offsets[I];
        AEndColor := AGradientPoints.Colors[I];
      end;
      AddGradientPoint(APoints, 1 - AGradientPoints.Offsets[I], AGradientPoints.Colors[I]);
    end;
    AddGradientPoint(APoints, 0, AEndColor);
    AddGradientPoint(APoints, 1, AStartColor);
  end;

  function SortOffsets(Item1, Item2: Pointer): Integer;
  var
    AOffset1, AOffset2: Single;
  begin
    AOffset1 := PdxGradientPoint(Item1).Offset;
    AOffset2 := PdxGradientPoint(Item2).Offset;
    Result := -1;
    if AOffset1 = AOffset2 then
      Result := 0;
    if AOffset1 > AOffset2 then
      Result := 1;
  end;

var
  I: Integer;
  APoints: TList;
begin
  if AGradientPoints.Count > 0 then
  begin
    APoints := TList.Create;
    try
      CalculateGradientPoints(APoints);
      APoints.Sort(@SortOffsets);
      AGradientPoints.Clear;
      for I := 0 to APoints.Count - 1 do
      begin
        AGradientPoints.Add(PdxGradientPoint(APoints[I]).Offset, PdxGradientPoint(APoints[I]).Color);
        FreeMem(PdxGradientPoint(APoints[I]), SizeOf(TdxGradientPoint));
      end;
    finally
      FreeAndNil(APoints);
    end;
  end;
end;

{ TdxGPSolidBrush }

constructor TdxGPSolidBrush.Create(AColor: TdxAlphaColor);
begin
  Create;
  Color := AColor;
end;

procedure TdxGPSolidBrush.Assign(ASource: TdxGPCustomGraphicObject);
begin
  inherited Assign(ASource);
  if ASource is TdxGPSolidBrush then
    Color := TdxGPSolidBrush(ASource).Color;
end;

procedure TdxGPSolidBrush.DoCreateHandle(out AHandle: GpHandle);
begin
  GdipCheck(GdipCreateSolidFill(FColor, AHandle));
end;

function TdxGPSolidBrush.GetIsEmpty: Boolean;
begin
  Result := not dxAlphaColorIsValid(Color);
end;

procedure TdxGPSolidBrush.SetColor(const AValue: TdxAlphaColor);
begin
  if FColor <> AValue then
  begin
    FColor := AValue;
    GdipCheck(GdipSetSolidFillColor(Handle, FColor));    
    Changed;
  end;
end;

{ TdxGPTextureBrush }

constructor TdxGPTextureBrush.Create;
begin
  inherited;
  FTexture := TdxGpImage.Create;
  FTexture.OnChange := ChangeHandler;
end;

constructor TdxGPTextureBrush.Create(ATexture: TdxGPImage);
begin
  Create;
  Texture := ATexture;
end;

destructor TdxGPTextureBrush.Destroy;
begin
  FreeAndNil(FTexture);
  inherited;
end;

procedure TdxGPTextureBrush.Assign(ASource: TdxGPCustomGraphicObject);
begin
  inherited Assign(ASource);
  if ASource is TdxGPTextureBrush then
    Texture := TdxGPTextureBrush(ASource).Texture;
end;

procedure TdxGPTextureBrush.DoCreateHandle(out AHandle: GpHandle);
begin
  if Texture.Empty then
    GdipCheck(GdipCreateSolidFill(0, AHandle))
  else
    GdipCheck(GdipCreateTexture2(Texture.Handle, WrapModeTile, 0, 0, Texture.Width, Texture.Height, AHandle));
end;

procedure TdxGPTextureBrush.DoTargetRectChanged;
begin
  inherited DoTargetRectChanged;
  GdipCheck(GdipResetTextureTransform(Handle));
  GdipCheck(GdipTranslateTextureTransform(Handle, TargetRect.X, TargetRect.Y, MatrixOrderAppend));
end;

function TdxGPTextureBrush.GetIsEmpty: Boolean;
begin
  Result := Texture.Empty;
end;

function TdxGPTextureBrush.NeedRecreateHandleOnTargetRectChange: Boolean;
begin
  Result := True;
end;

procedure TdxGPTextureBrush.SetTexture(const AValue: TdxGpImage);
begin
  FTexture.Assign(AValue);
end;

procedure TdxGPTextureBrush.ChangeHandler(Sender: TObject);
begin
  Changed;
end;

{ TdxGpCustomGradientBrush }

constructor TdxGpCustomGradientBrush.Create;
begin
  inherited Create;
  FGradientPoints := TdxGPBrushGradientPoints.Create;
  FTransformMatrix := TdxGPMatrix.Create;
end;

destructor TdxGpCustomGradientBrush.Destroy;
begin
  FreeAndNil(FTransformMatrix);
  FreeAndNil(FGradientPoints);
  inherited Destroy;
end;

procedure TdxGpCustomGradientBrush.Assign(ASource: TdxGPCustomGraphicObject);
begin
  inherited Assign(ASource);
  if ASource is TdxGpCustomGradientBrush then
  begin
    GradientPoints := TdxGpCustomGradientBrush(ASource).GradientPoints;
    TransformMatrix := TdxGpCustomGradientBrush(ASource).TransformMatrix;
  end;
end;

function TdxGpCustomGradientBrush.NeedRecreateHandleOnTargetRectChange: Boolean;
begin
  Result := True;
end;

procedure TdxGpCustomGradientBrush.DoCreateHandle(out AHandle: GpHandle);
begin
  AHandle := PrepareGradientPointsAndCreateHandle(GradientPoints);
end;

function TdxGpCustomGradientBrush.GetIsEmpty: Boolean;
begin
  Result := GradientPoints.Count = 0;
end;

procedure TdxGpCustomGradientBrush.PrepareGradientPoints(APoints: TdxGPBrushGradientPoints);
begin
  if APoints.Count = 0 then
    APoints.Add(1, 0);
end;

function TdxGpCustomGradientBrush.PrepareGradientPointsAndCreateHandle(APoints: TdxGPBrushGradientPoints): GpHandle;
var
  AColors: PdxAlphaColor;
  ACount: Integer;
  AOffsets: PSingle;
begin
  PrepareGradientPoints(APoints);
  TdxGPBrushGradientPointsAccess(APoints).CalculateParams(AColors, AOffsets, ACount);
  Result := InternalCreateHandle(AOffsets, AColors, ACount);
end;

procedure TdxGpCustomGradientBrush.SetGradientPoints(const AValue: TdxGPBrushGradientPoints);
begin
  FGradientPoints.Assign(AValue);
end;

procedure TdxGpCustomGradientBrush.SetTransformMatrix(const AValue: TdxGPMatrix);
begin
  FTransformMatrix.Assign(AValue);
end;

{ TdxGPLinearGradientBrush }

constructor TdxGPLinearGradientBrush.Create;
begin
  inherited;
  FEndPoint := dxPointF(1.0, 1.0);
end;

procedure TdxGPLinearGradientBrush.Assign(ASource: TdxGPCustomGraphicObject);
begin
  inherited Assign(ASource);
  if ASource is TdxGPLinearGradientBrush then
  begin
    GradientMode := TdxGPLinearGradientBrush(ASource).GradientMode;
    StartPoint := TdxGPLinearGradientBrush(ASource).StartPoint;
    EndPoint := TdxGPLinearGradientBrush(ASource).EndPoint;
  end;
end;

function TdxGPLinearGradientBrush.InternalCreateHandle(AOffsets: PSingle; AColors: PdxAlphaColor; ACount: Integer): GpHandle;
var
  AStartPoint, AEndPoint: TdxGpPointF;
begin
  if FGradientMode = gplgbmLine then
  begin
    AStartPoint.X := TargetRect.X + FStartPoint.X * TargetRect.Width;
    AStartPoint.Y := TargetRect.Y + FStartPoint.Y * TargetRect.Height;
    AEndPoint.X := TargetRect.X + FEndPoint.X * TargetRect.Width;
    AEndPoint.Y := TargetRect.Y + FEndPoint.Y * TargetRect.Height;
    GdipCheck(GdipCreateLineBrush(@AStartPoint, @AEndPoint, 0, 0, WrapModeTileFlipX, Result));
  end
  else
    GdipCheck(GdipCreateLineBrushFromRect(@TargetRect, 0, 0,
      dxGpLinearGradientBrushModeToLinearGradientMode[GradientMode], WrapModeTileFlipX, Result));

  GdipCheck(GdipSetLinePresetBlend(Result, AColors, AOffsets, ACount));
  CalculateTransformation(Result);
end;

procedure TdxGPLinearGradientBrush.SetEndPoint(const AValue: TdxPointF);
begin
  if (FEndPoint.X <> AValue.X) or (FEndPoint.Y <> AValue.Y) then
  begin
    FEndPoint := AValue;
    FreeHandle;
    Changed;
  end;
end;

procedure TdxGPLinearGradientBrush.SetGradientMode(const AValue: TdxGPLinearGradientBrushMode);
begin
  if FGradientMode <> AValue then
  begin
    FGradientMode := AValue;
    FreeHandle;
    Changed;
  end;
end;

procedure TdxGPLinearGradientBrush.SetStartPoint(const AValue: TdxPointF);
begin
  if (FStartPoint.X <> AValue.X) or (FStartPoint.Y <> AValue.Y) then
  begin
    FStartPoint := AValue;
    FreeHandle;
    Changed;
  end;
end;

procedure TdxGPLinearGradientBrush.CalculateTransformation(AHandle: GpHandle);

  procedure CalculateTransformElement(ATransformMatrix: TdxGPMatrix; out M11, M12, M21, M22, DX, DY: Single); 
  var
    AOffset: TdxPointF;
    AMatrix: TdxGPMatrix;
  begin
    ATransformMatrix.GetElements(M11, M12, M21, M22, DX, DY);
    AMatrix := TdxGPMatrix.CreateEx(M11, M12, M21, M22, DX, DY);
    try
      AOffset := ATransformMatrix.TransformPoint(dxPointF(DX, DY));
      DX := AOffset.X;
      DY := AOffset.Y;
      ATransformMatrix.Multiply(AMatrix);
    finally
      FreeAndNil(AMatrix);
    end;
  end;

var
  M11, M12, M21, M22: Single;
  AOffset, ACurrentOffset, ATransformOffset: TdxPointF;
begin
  AOffset := dxPointF(TargetRect.X, TargetRect.Y);
  if TransformMatrix.IsIdentity then
  begin
    GetBrushTransformElements(AHandle, M11, M12, M21, M22, ACurrentOffset.X, ACurrentOffset.Y);
    AOffset := cxPointOffset(AOffset, dxPointF(ACurrentOffset.X, ACurrentOffset.Y));
  end
  else
  begin
    CalculateTransformElement(TransformMatrix, M11, M12, M21, M22, ACurrentOffset.X, ACurrentOffset.Y);
    TransformMatrix.GetElements(M11, M12, M21, M22, ATransformOffset.X, ATransformOffset.Y);
    ACurrentOffset := cxPointOffset(AOffset, ATransformOffset);
  end;
  CalculateTransformMatrix(M11, M12, M21, M22, AOffset.X, AOffset.Y);
end;

procedure TdxGPLinearGradientBrush.CalculateTransformMatrix(M11, M12, M21, M22, DX, DY: Single);
begin
  TransformMatrix.Reset;
  TransformMatrix.SetElements(M11, M12, M21, M22, DX, DY);
end;

procedure TdxGPLinearGradientBrush.GetBrushTransformElements(AHandle: GpHandle; out M11, M12, M21, M22, DX, DY: Single);
var
  AMatrix: TdxGPMatrix;
begin
  AMatrix := TdxGpMatrix.Create;
  try
    GdipCheck(GdipGetLineTransform(AHandle, AMatrix.Handle));
    AMatrix.GetElements(M11, M12, M21, M22, DX, DY);
  finally
    FreeAndNil(AMatrix);
  end;
end;

{ TdxGPPathGradientBrush }

function TdxGPPathGradientBrush.InternalCreateHandle(AOffsets: PSingle; AColors: PdxAlphaColor; ACount: Integer): GpHandle;

  function GetCenter(const ARect: TdxRectF): TdxGpPointF;
  var
    ACenter: TdxPointF;
  begin
    ACenter := dxPointF(ARect.Left + cxRectWidth(ARect) / 2, ARect.Top + cxRectHeight(ARect) / 2);
    Result := MakePoint(ACenter.X, ACenter.Y);
  end;

var
  ACenter: TdxGpPointF;
  APath: TdxGPPath;
begin
  APath := TdxGPPath.Create;
  try
    APath.FigureStart;
    DoPathContent(APath);
    APath.FigureFinish;
    ACenter := GetCenter(GetBounds);
    GdipCheck(GdipCreatePathGradientFromPath(APath.Handle, Result));
    GdipCheck(GdipSetPathGradientCenterPoint(Result, @ACenter));
    GdipCheck(GdipSetPathGradientPresetBlend(Result, AColors, AOffsets, ACount));
    GdipCheck(GdipSetPathGradientTransform(Result, TransformMatrix.Handle));
  finally
    FreeAndNil(APath);
  end;
end;

procedure TdxGPPathGradientBrush.DoCreateHandle(out AHandle: GpHandle);
var
  AGradientPoints: TdxGPBrushGradientPoints;
begin
  AGradientPoints := TdxGPBrushGradientPoints.Create;
  try
    AGradientPoints.Assign(GradientPoints);
    AHandle := inherited PrepareGradientPointsAndCreateHandle(AGradientPoints);
  finally
    AGradientPoints.Free;
  end;
end;

procedure TdxGPPathGradientBrush.DoPathContent(APath: TdxGPPath);
begin
// do nothing
end;

procedure TdxGPPathGradientBrush.PrepareGradientPoints(APoints: TdxGPBrushGradientPoints);
begin
  inherited PrepareGradientPoints(APoints);
  dxSortGradientPoints(APoints);
end;

function TdxGPPathGradientBrush.GetBounds: TdxRectF;
begin
  Result := dxRectF(TargetRect.X, TargetRect.Y, TargetRect.X + TargetRect.Width, TargetRect.Y + TargetRect.Height);
end;

{ TdxRadialGradientBrush }

constructor TdxRadialGradientBrush.Create;
begin
  inherited;
  FCenter := dxPointF(0.5, 0.5);
  FRadius := dxPointF(0.5, 0.5);
  FUseTargetRectCorrection := True;
end;

procedure TdxRadialGradientBrush.Assign(ASource: TdxGPCustomGraphicObject);
begin
  inherited Assign(ASource);
  if ASource is TdxRadialGradientBrush then
  begin
    Center := TdxRadialGradientBrush(ASource).Center;
    Radius := TdxRadialGradientBrush(ASource).Radius;
  end;
end;

function TdxRadialGradientBrush.GetBounds: TdxRectF;
begin
  Result := inherited GetBounds;
  if (FRadius.X = 0) and (FRadius.Y = 0) then
  begin
    Result.Left := Result.Left - FRadius.X;
    Result.Top := Result.Top - FRadius.Y;
  end
  else
  begin
    Result.Left := Result.Left + (FCenter.X - FRadius.X) * TargetRect.Width;
    Result.Top := Result.Top + (FCenter.Y - FRadius.Y) * TargetRect.Height;
    Result.Right := Result.Left + FRadius.X * 2 * TargetRect.Width;
    Result.Bottom := Result.Top + FRadius.Y * 2 * TargetRect.Height;
  end;
end;

function TdxRadialGradientBrush.MakeTargetRect(const R: TdxGpRectF): TdxGpRectF;
begin
  if UseTargetRectCorrection then
    // Inflate: Avoid GDIPlus gradient fill bug
    Result := MakeRect(R.X - 1, R.Y - 1, R.Width + 2, R.Height + 2)
  else
    Result := inherited MakeTargetRect(R);
end;

procedure TdxRadialGradientBrush.DoPathContent(APath: TdxGPPath);
begin
  APath.AddEllipse(GetBounds);
end;

procedure TdxRadialGradientBrush.SetCenter(const AValue: TdxPointF);
begin
  if (FCenter.X <> AValue.X) or (FCenter.Y <> AValue.Y) then
  begin
    FCenter := AValue;
    FreeHandle;
    Changed;
  end;
end;

procedure TdxRadialGradientBrush.SetRadius(const AValue: TdxPointF);
begin
  if (FRadius.X <> AValue.X) or (FRadius.Y <> AValue.Y) then
  begin
    FRadius := AValue;
    FreeHandle;
    Changed;
  end;
end;

{ TdxShapeCustomGradientBrush }

function TdxShapeCustomGradientBrush.GetBrushClass: TdxShapeBrushClass;
begin
  Result := TdxGpCustomGradientBrush;
end;

function TdxShapeCustomGradientBrush.GetGradientPoints: TdxGPBrushGradientPoints;
begin
  Result := TdxGpCustomGradientBrush(GPBrush).GradientPoints;
end;

{ TdxShapeLinearGradientBrush }

constructor TdxShapeLinearGradientBrush.Create;
begin
  inherited;
  GetBrush.GradientMode := gplgbmLine;
end;

class function TdxShapeLinearGradientBrush.GetName: string;
begin
  Result := 'LinearGradientBrush';
end;

function TdxShapeLinearGradientBrush.GetBrushClass: TdxShapeBrushClass;
begin
  Result := TdxLinearGradientBrush;
end;

function TdxShapeLinearGradientBrush.GetBrush: TdxLinearGradientBrush;
begin
  Result := GPBrush as TdxLinearGradientBrush;
end;

function TdxShapeLinearGradientBrush.GetEndPoint: string;
begin
  Result := dxPointFToStr(GetBrush.EndPoint);
end;

function TdxShapeLinearGradientBrush.GetStartPoint: string;
begin
  Result := dxPointFToStr(GetBrush.StartPoint);
end;

procedure TdxShapeLinearGradientBrush.SetEndPoint(const AValue: string);
var
  APoint: TdxPointF;
begin
  APoint := dxStrToPointF(AValue);
  if (GetBrush.EndPoint.X <> APoint.X) or (GetBrush.EndPoint.Y <> APoint.Y) then
  begin
    GetBrush.EndPoint := APoint;
    Changed;
  end;
end;

procedure TdxShapeLinearGradientBrush.SetStartPoint(const AValue: string);
var
  APoint: TdxPointF;
begin
  APoint := dxStrToPointF(AValue);
  if (GetBrush.StartPoint.X <> APoint.X) or (GetBrush.StartPoint.Y <> APoint.Y) then
  begin
    GetBrush.StartPoint := APoint;
    Changed;
  end;
end;

{ TdxShapeRadialGradientBrush }

class function TdxShapeRadialGradientBrush.GetName: string;
begin
  Result := 'RadialGradientBrush';
end;

function TdxShapeRadialGradientBrush.GetBrushClass: TdxShapeBrushClass;
begin
  Result := TdxRadialGradientBrush;
end;

function TdxShapeRadialGradientBrush.GetBrush: TdxRadialGradientBrush;
begin
  Result := GPBrush as TdxRadialGradientBrush;
end;

function TdxShapeRadialGradientBrush.GetCenter: string;
begin
  Result := dxPointFToStr(GetBrush.Center);
end;

function TdxShapeRadialGradientBrush.GetRadiusX: Single;
begin
  Result := GetBrush.Radius.X;
end;

function TdxShapeRadialGradientBrush.GetRadiusY: Single;
begin
  Result := GetBrush.Radius.Y;
end;

procedure TdxShapeRadialGradientBrush.SetCenter(const AValue: string);
var
  APoint: TdxPointF;
begin
  APoint := dxStrToPointF(AValue);
  if (GetBrush.Center.X <> APoint.X) or (GetBrush.Center.Y <> APoint.Y) then
  begin
    GetBrush.Center := APoint;
    Changed;
  end;
end;

procedure TdxShapeRadialGradientBrush.SetRadiusX(const AValue: Single);
begin
  if GetBrush.Radius.X <> AValue then
  begin
    GetBrush.Radius := dxPointF(AValue, GetBrush.Radius.Y);
    Changed;
  end;
end;

procedure TdxShapeRadialGradientBrush.SetRadiusY(const AValue: Single);
begin
  if GetBrush.Radius.Y <> AValue then
  begin
    GetBrush.Radius := dxPointF(GetBrush.Radius.X, AValue);
    Changed;
  end;
end;

{ TdxShapeSolidBrush }

class function TdxShapeSolidBrush.GetName: string;
begin
  Result := 'Fill';
end;

function TdxShapeSolidBrush.GetBrush: TdxGPSolidBrush;
begin
  Result := GPBrush as TdxGPSolidBrush;
end;

function TdxShapeSolidBrush.GetColor: TdxAlphaColor;
begin
  Result := GetBrush.Color;
end;

procedure TdxShapeSolidBrush.SetColor(const AValue: TdxAlphaColor);
begin
  if GetBrush.Color <> AValue then
  begin
    GetBrush.Color := AValue;
    Changed;
  end;
end;

{ TdxShapeBrushGradientStop }

class function TdxShapeBrushGradientStop.GetName: string;
begin
  Result := 'GradientStop';
end;

class function TdxShapeBrushGradientStop.GetReaderClass: TdxShapeObjectReaderClass;
begin
  Result := TdxShapeGradientStopReader;
end;

end.
