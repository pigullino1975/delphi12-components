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

unit dxGDIPlusCanvas; // for internal use

{$I cxVer.inc}

interface

uses
  UITypes,
  Types, Windows, SysUtils, Generics.Collections, Generics.Defaults, Classes, Graphics, Controls,
  cxGeometry, dxCore, dxCoreClasses, dxSmartImage, dxGDIPlusAPI, dxGDIPlusClasses, dxCoreGraphics,
  cxDrawTextUtils, dxDPIAwareUtils, cxCustomCanvas, ImgList;

type

  { TdxCustomGDIPlusCanvas }

  TdxCustomGDIPlusCanvas = class(TcxCustomGdiBasedCanvas)
  strict private
    FPixelOffsetMode: TdxGpPixelOffsetMode;
    FSavedWindowOrgs: TStack<TPoint>;
    FSavedWorldTransforms: TStack<TXForm>;
    FSavedSmoothingMode: TStack<TdxGPSmoothingMode>;
    FSmoothingMode: TdxGPSmoothingMode;
    FWindowOrg: TPoint;

    procedure ApplyWorldTransform;
    procedure SetPixelOffsetMode(AValue: TdxGpPixelOffsetMode);
    procedure SetSmoothingMode(AValue: TdxGPSmoothingMode);
  protected
    FGpCanvas: TdxGPCanvas;
    FWorldTransform: TXForm;

    procedure DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte); override;
    procedure DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte); override;
    procedure FillRectByGradientCore(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode); override;
    procedure RectangleCore(const R: TdxRectF; ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle); override;

    function GetWindowOrg: TPoint; override;
    procedure SetWindowOrg(const Value: TPoint); override;

    procedure RestoreSmoothingMode; virtual;
    procedure SaveSmoothingMode; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateTextLayout: TcxCanvasBasedTextLayout; override;

    procedure DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect, ASourceRect: TRect;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); override;
    procedure DrawBitmap(ABitmap: TdxGpFastDIB; const ATargetRect, ASourceRect: TdxRectF;
      AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil); override;

    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; ACache: PcxCanvasBasedImage = nil); override;
    procedure DrawImage(AImage: TdxGPImage; const ATargetRect: TdxRectF; ACache: PcxCanvasBasedImage = nil); override;

    procedure DrawNativeObject(const R: TRect; AProc: TcxCanvasNativeDrawProc); overload;
    procedure DrawNativeObject(const R: TRect; const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawExProc); override;
    procedure DrawNativeObject(const R: TRect; const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc); overload; override;

    procedure Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
      AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle); override;
    procedure DonutSlice(const R: TdxRectF; AStartAngle, ASweepAngle, AWholePercent: Single;
      ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Ellipse(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Ellipse(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer); override;
    procedure FillRect(const R: TRect; AColor: TdxAlphaColor); override;
    procedure FillRect(const R: TRect; AImage: TdxGPImage; ACache: PcxCanvasBasedImage = nil); override;
    procedure Line(const P1, P2: TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle = psSolid); override;
    procedure Line(const P1, P2: TPoint; AColor: TColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); override;
    procedure Line(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen); override;
    procedure Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Pie(const R: TdxRectF; AStartAngle, ASweepAngle: Single; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor); override;
    procedure Polygon(const P: PdxPointF; ACount: Integer; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen); override;
    procedure Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen); override;
    procedure Polyline(const P: array of TPoint; AColor: TdxAlphaColor; APenWidth: Integer = 1; APenStyle: TPenStyle = psSolid); override;
    procedure Rectangle(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer = 1); override;

    procedure ModifyWorldTransform(const AForm: TXForm); override;
    procedure RestoreWorldTransform; override;
    procedure SaveWorldTransform; override;

    procedure RestoreState; override;
    procedure SaveState; override;

    procedure EnableAntialiasing(AEnable: Boolean); override;
    procedure RestoreAntialiasing; override;

    procedure IntersectClipRect(const ARect: TdxRectF); override;
    procedure IntersectClipRect(const ARect: TRect); override;
    function RectVisible(const R: TdxRectF): Boolean; override;
    function RectVisible(const R: TRect): Boolean; override;
    procedure RestoreClipRegion; override;
    procedure SaveClipRegion; override;

    property GpCanvas: TdxGPCanvas read FGpCanvas;
    property PixelOffsetMode: TdxGpPixelOffsetMode read FPixelOffsetMode write SetPixelOffsetMode;
    property SmoothingMode: TdxGPSmoothingMode read FSmoothingMode write SetSmoothingMode;
  end;

  { TdxGDIPlusCanvasBasedTextLayout }

  TdxGDIPlusCanvasBasedTextLayout = class(TcxGdiCanvasBasedTextLayout)
  protected
    procedure DoDraw(const R: TRect); override;
  end;

  { TdxGDIPlusCanvas }

  TdxGDIPlusCanvas = class(TdxCustomGDIPlusCanvas)
  strict private
    FCanvasOwnership: TStreamOwnership;
  public
    constructor Create(ACanvas: TdxGPCanvas; ACanvasOwnership: TStreamOwnership = soReference);
    destructor Destroy; override;
  end;

  { TdxGDIPlusControlCanvas }

  TdxGDIPlusControlCanvas = class(TdxCustomGDIPlusCanvas,
    IcxControlCanvas)
  strict private
    FCanvas: TCanvas;
  public
    constructor Create(ACanvas: TCanvas);
    // IcxControlCanvas
    procedure BeginPaint;
    procedure EndPaint;

    property Canvas: TCanvas read FCanvas;
  end;

implementation

uses
  cxGraphics;

const
  dxThisUnitName = 'dxGDIPlusCanvas';

{ TdxCustomGDIPlusCanvas }

constructor TdxCustomGDIPlusCanvas.Create;
begin
  inherited Create;
  FSavedWindowOrgs := TStack<TPoint>.Create;
  FSavedWorldTransforms := TStack<TXForm>.Create;
  FWorldTransform := TXForm.CreateIdentityMatrix;
  FPixelOffsetMode := PixelOffsetModeHalf;
  FSavedSmoothingMode := TStack<TdxGPSmoothingMode>.Create;
  FSmoothingMode := smAntiAlias;
end;

destructor TdxCustomGDIPlusCanvas.Destroy;
begin
  FreeAndNil(FSavedSmoothingMode);
  FreeAndNil(FSavedWorldTransforms);
  FreeAndNil(FSavedWindowOrgs);
  FreeAndNil(FGpCanvas);
  inherited;
end;

function TdxCustomGDIPlusCanvas.CreateTextLayout: TcxCanvasBasedTextLayout;
begin
  Result := TdxGDIPlusCanvasBasedTextLayout.Create(Self);
end;

procedure TdxCustomGDIPlusCanvas.DrawBitmap(ABitmap: TdxGpFastDIB;
  const ATargetRect, ASourceRect: TRect; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage);
begin
  dxGpDrawImage(GpCanvas.Handle, ATargetRect, ASourceRect, ABitmap.Handle);
end;

procedure TdxCustomGDIPlusCanvas.DrawBitmap(ABitmap: TdxGpFastDIB;
  const ATargetRect, ASourceRect: TdxRectF; AAlphaFormat: TAlphaFormat; ACache: PcxCanvasBasedImage = nil);
begin
  dxGpDrawImage(GpCanvas.Handle, ATargetRect, ASourceRect, ABitmap.Handle);
end;

procedure TdxCustomGDIPlusCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TRect; ACache: PcxCanvasBasedImage);
begin
  AImage.StretchDraw(GpCanvas, ATargetRect, AImage.ClientRect, nil);
end;

procedure TdxCustomGDIPlusCanvas.DrawImage(AImage: TdxGPImage; const ATargetRect: TdxRectF; ACache: PcxCanvasBasedImage = nil);
begin
  AImage.StretchDraw(GpCanvas, ATargetRect, cxRectF(AImage.ClientRect), nil);
end;

procedure TdxCustomGDIPlusCanvas.DrawNativeObject(const R: TRect; AProc: TcxCanvasNativeDrawProc);
var
  ADC: HDC;
  AMatrix: TdxGPMatrix;
  ARegion: TcxRegionHandle;
begin
  AMatrix := GpCanvas.GetWorldTransform;
  try
    ARegion := GpCanvas.GetClipGdiRegion;
    try
      ADC := GpCanvas.GetHDC;
      try
        cxPaintCanvas.BeginPaint(ADC);
        try
          cxPaintCanvas.ModifyWorldTransform(AMatrix.ToXForm);
          if ARegion <> 0 then
            SelectClipRgn(cxPaintCanvas.Handle, ARegion);
          AProc(cxPaintCanvas, R);
        finally
          cxPaintCanvas.EndPaint;
        end;
      finally
        GpCanvas.ReleaseHDC(ADC);
      end;
    finally
      DeleteObject(ARegion)
    end;
  finally
    AMatrix.Free;
  end;
end;

procedure TdxCustomGDIPlusCanvas.DrawNativeObject(const R: TRect;
  const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawProc);
begin
  DrawNativeObject(R, AProc);
end;

procedure TdxCustomGDIPlusCanvas.DrawNativeObject(const R: TRect;
  const ACacheKey: TcxCanvasBasedResourceCacheKey; AProc: TcxCanvasNativeDrawExProc);
begin
  AProc(GpCanvas, R);
end;

procedure TdxCustomGDIPlusCanvas.Arc(const AEllipse: TRect; const AStartPoint, AEndPoint: TPoint;
  AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  GpCanvas.Arc(AEllipse, AStartPoint, AEndPoint, AColor, APenWidth, APenStyle);
end;

procedure TdxCustomGDIPlusCanvas.DonutSlice(const R: TdxRectF;
  AStartAngle, ASweepAngle, AWholePercent: Single; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
    GpCanvas.DonutSlice(R, AStartAngle, ASweepAngle, AWholePercent, AGpBrush, AGpPen);
end;

procedure TdxCustomGDIPlusCanvas.Ellipse(const R: TdxRectF; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
    GpCanvas.Ellipse(R, AGpPen, AGpBrush);
end;

procedure TdxCustomGDIPlusCanvas.Ellipse(const R: TRect;
  ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer);
begin
  GpCanvas.Ellipse(R, APenColor, ABrushColor, APenWidth, APenStyle);
end;

procedure TdxCustomGDIPlusCanvas.EnableAntialiasing(AEnable: Boolean);
begin
  SaveSmoothingMode;
  if AEnable then
    SmoothingMode := smAntiAlias
  else
    SmoothingMode := smNone;
end;

procedure TdxCustomGDIPlusCanvas.FillRect(const R: TRect; AColor: TdxAlphaColor);
begin
  GpCanvas.FillRectangle(R, AColor);
end;

procedure TdxCustomGDIPlusCanvas.FillRect(const R: TRect; AImage: TdxGPImage; ACache: PcxCanvasBasedImage);
begin
  dxGpTilePartEx(GpCanvas.Handle, R, AImage.ClientRect, AImage.Handle);
end;

procedure TdxCustomGDIPlusCanvas.DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TRect; AAlpha: Byte);
begin
  (AImage as TcxGdiCanvasBasedImage).Image.StretchDraw(GpCanvas, ATargetRect, ASourceRect, TdxGPImageAttributes.GetAlphaBlendAttributes(AAlpha));
end;

procedure TdxCustomGDIPlusCanvas.DrawImageCore(AImage: TcxCanvasBasedImage; const ATargetRect, ASourceRect: TdxRectF; AAlpha: Byte);
begin
  (AImage as TcxGdiCanvasBasedImage).Image.StretchDraw(GpCanvas, ATargetRect, ASourceRect, TdxGPImageAttributes.GetAlphaBlendAttributes(AAlpha));
end;

procedure TdxCustomGDIPlusCanvas.FillRectByGradientCore(const R: TRect; AColor1, AColor2: TdxAlphaColor; AMode: TdxGpLinearGradientMode);
begin
  GpCanvas.FillRectangleByGradient(R, AColor1, AColor2, AMode);
end;

procedure TdxCustomGDIPlusCanvas.Line(const P1, P2: TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle = psSolid);
begin
  GpCanvas.Line(P1.X, P1.Y, P2.X, P2.Y, AColor, APenWidth, APenStyle);
end;

procedure TdxCustomGDIPlusCanvas.Line(const P1, P2: TdxPointF; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(nil, APen, AGpBrush, AGpPen) then
    GpCanvas.Line(P1.X, P1.Y, P2.X, P2.Y, AGpPen);
end;

procedure TdxCustomGDIPlusCanvas.Path(APath: TcxCanvasBasedPath; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if CheckIsValid(APath) and GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
    GpCanvas.Path(TcxGdiCanvasBasedPath(APath).Path, AGpPen, AGpBrush);
end;

procedure TdxCustomGDIPlusCanvas.Pie(const R: TdxRectF;
  AStartAngle, ASweepAngle: Single; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
    GpCanvas.Pie(R, AStartAngle, ASweepAngle, AGpBrush, AGpPen);
end;

procedure TdxCustomGDIPlusCanvas.Polygon(const P: PdxPointF; ACount: Integer; ABrush: TcxCanvasBasedBrush; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(ABrush, APen, AGpBrush, AGpPen) then
    GpCanvas.Polygon(P, ACount, AGpPen, AGpBrush);
end;

procedure TdxCustomGDIPlusCanvas.Polygon(const P: array of TPoint; ABrushColor, APenColor: TdxAlphaColor);
begin
  GpCanvas.Polygon(P, APenColor, ABrushColor);
end;

procedure TdxCustomGDIPlusCanvas.Polyline(const P: PdxPointF; ACount: Integer; APen: TcxCanvasBasedPen);
var
  AGpBrush: TdxGPCustomBrush;
  AGpPen: TdxGPPen;
begin
  if GetGpBrushAndPen(nil, APen, AGpBrush, AGpPen) then
    GpCanvas.Polyline(P, ACount, AGpPen);
end;

procedure TdxCustomGDIPlusCanvas.Polyline(const P: array of TPoint; AColor: TdxAlphaColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  GpCanvas.Polyline(P, AColor, APenWidth, APenStyle);
end;

procedure TdxCustomGDIPlusCanvas.Rectangle(const R: TRect; ABrushColor, APenColor: TdxAlphaColor; APenStyle: TPenStyle; APenWidth: Integer);
begin
  GpCanvas.Rectangle(R, APenColor, ABrushColor, APenWidth, APenStyle);
end;

procedure TdxCustomGDIPlusCanvas.RectangleCore(const R: TdxRectF;
  ABrushHandle: TcxCanvasBasedBrushHandle; APenHandle: TcxCanvasBasedPenHandle);
begin
  if (ABrushHandle <> nil) and not ABrushHandle.IsEmpty then
    GpCanvas.FillRectangle(R, TcxGdiCanvasBasedBrushHandle(ABrushHandle).Brush);
  if (APenHandle <> nil) and not APenHandle.IsEmpty then
    GpCanvas.DrawRectangle(R, TcxGdiCanvasBasedPenHandle(APenHandle).Pen);
end;

procedure TdxCustomGDIPlusCanvas.ModifyWorldTransform(const AForm: TXForm);
begin
  FWorldTransform := TXForm.Combine(AForm, FWorldTransform);
  ApplyWorldTransform;
end;

procedure TdxCustomGDIPlusCanvas.RestoreWorldTransform;
begin
  FWorldTransform := FSavedWorldTransforms.Pop;
  ApplyWorldTransform;
end;

procedure TdxCustomGDIPlusCanvas.SaveWorldTransform;
begin
  FSavedWorldTransforms.Push(FWorldTransform);
end;

procedure TdxCustomGDIPlusCanvas.IntersectClipRect(const ARect: TdxRectF);
begin
  GpCanvas.SetClipRect(ARect, gmIntersect);
end;

procedure TdxCustomGDIPlusCanvas.IntersectClipRect(const ARect: TRect);
begin
  GpCanvas.SetClipRect(ARect, gmIntersect);
end;

procedure TdxCustomGDIPlusCanvas.Line(const P1, P2: TPoint; AColor: TColor; APenWidth: Integer; APenStyle: TPenStyle);
begin
  Line(P1, P2, dxColorToAlphaColor(AColor), APenWidth, APenStyle);
end;

function TdxCustomGDIPlusCanvas.RectVisible(const R: TdxRectF): Boolean;
begin
  Result := dxGpIsRectVisible(GpCanvas.Handle, R);
end;

function TdxCustomGDIPlusCanvas.RectVisible(const R: TRect): Boolean;
begin
  Result := dxGpIsRectVisible(GpCanvas.Handle, R);
end;

procedure TdxCustomGDIPlusCanvas.RestoreAntialiasing;
begin
  RestoreSmoothingMode;
end;

procedure TdxCustomGDIPlusCanvas.RestoreClipRegion;
begin
  GpCanvas.RestoreClipRegion;
end;

procedure TdxCustomGDIPlusCanvas.RestoreSmoothingMode;
begin
  SmoothingMode := FSavedSmoothingMode.Pop;
end;

procedure TdxCustomGDIPlusCanvas.RestoreState;
begin
  WindowOrg := FSavedWindowOrgs.Pop;
  RestoreWorldTransform;
  RestoreClipRegion;
  RestoreSmoothingMode;
end;

procedure TdxCustomGDIPlusCanvas.SaveClipRegion;
begin
  GpCanvas.SaveClipRegion;
end;

procedure TdxCustomGDIPlusCanvas.SaveSmoothingMode;
begin
  FSavedSmoothingMode.Push(SmoothingMode);
end;

procedure TdxCustomGDIPlusCanvas.SaveState;
begin
  FSavedWindowOrgs.Push(WindowOrg);
  SaveWorldTransform;
  SaveClipRegion;
  SaveSmoothingMode;
end;

function TdxCustomGDIPlusCanvas.GetWindowOrg: TPoint;
begin
  Result := FWindowOrg;
end;

procedure TdxCustomGDIPlusCanvas.ApplyWorldTransform;
var
  AMatrix: TdxGPMatrix;
  ATransform: TXForm;
begin
  ATransform := TXForm.CreateTranslateMatrix(-FWindowOrg.X, -FWindowOrg.Y);
  ATransform := TXForm.Combine(FWorldTransform, ATransform);
  AMatrix := TdxGPMatrix.CreateEx(ATransform);
  try
    GpCanvas.SetWorldTransform(AMatrix);
  finally
    AMatrix.Free;
  end;
end;

procedure TdxCustomGDIPlusCanvas.SetPixelOffsetMode(AValue: TdxGpPixelOffsetMode);
begin
  FPixelOffsetMode := AValue;
  if GpCanvas <> nil then
    GpCanvas.PixelOffsetMode := AValue;
end;

procedure TdxCustomGDIPlusCanvas.SetSmoothingMode(AValue: TdxGPSmoothingMode);
begin
  FSmoothingMode := AValue;
  if GpCanvas <> nil then
    GpCanvas.SmoothingMode := AValue;
end;

procedure TdxCustomGDIPlusCanvas.SetWindowOrg(const Value: TPoint);
begin
  if not cxPointIsEqual(FWindowOrg, Value) then
  begin
    FWindowOrg := Value;
    ApplyWorldTransform;
  end;
end;

{ TdxGDIPlusCanvasBasedTextLayout }

procedure TdxGDIPlusCanvasBasedTextLayout.DoDraw(const R: TRect);
begin
  TdxCustomGDIPlusCanvas(Canvas).DrawNativeObject(R,
    procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
    begin
      DoDrawCore(ACanvas.Handle, R);
    end);
end;

{ TdxGDIPlusCanvas }

constructor TdxGDIPlusCanvas.Create(ACanvas: TdxGPCanvas; ACanvasOwnership: TStreamOwnership = soReference);
begin
  inherited Create;
  FGpCanvas := ACanvas;
  FCanvasOwnership := ACanvasOwnership;
end;

destructor TdxGDIPlusCanvas.Destroy;
begin
  if FCanvasOwnership = soReference then
    FGpCanvas := nil;
  inherited Destroy;
end;

{ TdxGDIPlusControlCanvas }

constructor TdxGDIPlusControlCanvas.Create(ACanvas: TCanvas);
begin
  inherited Create;
  FCanvas := ACanvas;
end;

procedure TdxGDIPlusControlCanvas.BeginPaint;
begin
  FWorldTransform := TXForm.CreateIdentityMatrix;
  FGpCanvas := TdxGPCanvas.Create(FCanvas.Handle);
  FGpCanvas.PixelOffsetMode := PixelOffsetMode;
  FGpCanvas.SmoothingMode := SmoothingMode;
end;

procedure TdxGDIPlusControlCanvas.EndPaint;
begin
  FreeAndNil(FGpCanvas);
end;

end.
