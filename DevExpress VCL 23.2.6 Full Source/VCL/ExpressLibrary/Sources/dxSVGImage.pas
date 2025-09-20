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

unit dxSVGImage;

{$I cxVer.inc}

{$DEFINE DXSVG_AUTOINDENT}

interface

uses
  System.ZLib,
  Types, Windows, Classes, Graphics, Generics.Collections, Generics.Defaults, dxCore, dxGenerics, cxGeometry,
  dxCoreGraphics, dxXMLDoc, dxGDIPlusClasses, dxGDIPlusAPI, dxSmartImage, dxSVGCore;

type
  TdxSVGRenderQualityValues = (srqDefault, srqLow, srqMedium, srqHigh);
  TdxSVGRenderQuality = srqLow..srqHigh;

  { TdxSVGSourceData }

  TdxSVGSourceData = class
  strict private
    FData: TdxGPMemoryStream;
  public
    constructor Create(const ADocument: TdxXMLDocument);
    destructor Destroy; override;
    procedure SaveToStream(AStream: TStream);
  end;

  { TdxSVGImageHandle }

  TdxSVGImageHandle = class(TdxSmartImageCustomHandle,
    IdxGpFlipContent,
    IdxImageDataFormatEx,
    IdxVectorImage)
  strict private const
    ActualPixelOffsetMode = PixelOffsetModeHalf;
    MaxScaleFactor: array[TdxSVGRenderQuality] of Integer = (16, 24, 32);
    RasterizedImageBufferSize: array[TdxSVGRenderQuality] of Integer = (1024, 1536, 2048);
  strict private
    FCachedImage: TdxGPImageHandle;
    FCachedImagePalette: TGUID;
    FCachedImageQuality: TdxSVGRenderQuality;
    FFlipHorizontally: Boolean;
    FFlipVertically: Boolean;
    FInterpolationMode: TdxGPInterpolationMode;
    FRenderQuality: TdxSVGRenderQualityValues;
    FSmoothingMode: TdxGPSmoothingMode;
    FSourceData: TdxSVGSourceData;

    function CalculateScaleFactor(const AViewBoxSize: TSize): Integer;
    function GetActualInterpolationMode: TdxGPInterpolationMode;
    function GetActualRenderQuality: TdxSVGRenderQuality;
    function GetActualSmoothingMode: TdxGPSmoothingMode;
    procedure SetSourceData(AData: TdxSVGSourceData);
  protected
    FRoot: TdxSVGElementRoot;

    procedure DrawCore(ACanvas: TdxGPCanvas; const R: TdxRectF; const APalette: IdxColorPalette); overload;
    procedure DrawCore(ATarget: TdxGPImageHandle; const APalette: IdxColorPalette); overload;
    procedure FlushCache;
    function GetSize: TSize; override;
    // IdxImageDataFormatEx
    function GetImageFormat: TdxSmartImageCodecClass;
    //
    property ActualInterpolationMode: TdxGPInterpolationMode read GetActualInterpolationMode;
    property ActualRenderQuality: TdxSVGRenderQuality read GetActualRenderQuality;
    property ActualSmoothingMode: TdxGPSmoothingMode read GetActualSmoothingMode;
    property SourceData: TdxSVGSourceData read FSourceData write SetSourceData;
  public
    constructor Create(ARoot: TdxSVGElementRoot);
    destructor Destroy; override;
    procedure Draw(DC: HDC; const ADest, ASource: TdxRectF; AAlpha: Byte = 255; APalette: IdxColorPalette = nil); override;
    procedure Draw(DC: HDC; const ADest, ASource: TRect; AAlpha: Byte = 255; APalette: IdxColorPalette = nil); override;
    function GetAlphaState: TdxAlphaState; override;
    function GetAsBitmap: TBitmap; override;
    function GetRasterizedImage(ASize: TSize; APalette: IdxColorPalette): TdxGPImageHandle;
    // IdxGpFlipContent
    procedure Flip(AHorizontally, AVertically: Boolean);
    property InterpolationMode: TdxGPInterpolationMode read FInterpolationMode write FInterpolationMode;
    property RenderQuality: TdxSVGRenderQualityValues read FRenderQuality write FRenderQuality;
    property SmoothingMode: TdxGPSmoothingMode read FSmoothingMode write FSmoothingMode;
  end;

  { TdxSVGImage }

  TdxSVGImage = class(TdxCustomSmartImage)
  public
    procedure SaveToStream(Stream: TStream); override; 
  end;

  { TdxSVGImageCodec }

  TdxSVGImageCodec = class(TdxSmartImageCodec)
  protected
    class function GetGraphicClassForRegistrationInVCL: TGraphicClass; override;
  public
    class function CanLoadStream(AStream: TStream): Boolean; override; 
    class function CanSaveImage(AHandle: TdxSmartImageCustomHandle): Boolean; override; 
    class function Extensions: string; override;
    class function MimeType: string; override;
    class function GetSize(AStream: TStream; out ASize: TSize): Boolean; override; 
    class function Load(AStream: TStream; out AHandle: TdxSmartImageCustomHandle): Boolean; overload; override;
    class function Load(const ADocument: TdxXMLDocument; out AHandle: TdxSmartImageCustomHandle): Boolean; overload;
    class function Load(const AFileName: string; out AHandle: TdxSmartImageCustomHandle): Boolean; overload;
    class function Save(AStream: TStream; AHandle: TdxSmartImageCustomHandle): Boolean; override; 
  end;

  { TdxSVGEditingHelper }

  TdxSVGEditingHelper = class
  strict private const
    MultiframeTextureTag = '_dx.multiframe.svg';
  strict private
    class procedure Append(ATarget, ASource: TdxSVGElementRoot; AReferences: TdxSVGReferences; AOffsetX, AOffsetY: Single);
    class function Extract(ASource: TdxSVGElement; const AFrameSize: TSize): TdxSVGImageHandle;
    class function IsMultiframeTexture(ARoot: TdxSVGElementRoot): Boolean;
    class procedure UpdateReferences(AReferences: TdxSVGReferences; AElement, ARootElement: TdxSVGElement);
  public
    class function Combine(AList: TList<TdxSVGImageHandle>): TdxSVGImageHandle;
    class function Split(AImage: TdxCustomSmartImage; out AList: TList<TdxSVGImageHandle>): Boolean; overload;
    class function Split(AImage: TdxSVGImageHandle; out AList: TList<TdxSVGImageHandle>): Boolean; overload;
  end;

var
  dxSVGRenderQuality: TdxSVGRenderQuality = srqHigh;

implementation

uses
  SysUtils, Math, cxGraphics;

const
  dxThisUnitName = 'dxSVGImage';

type
  TdxCustomSmartImageAccess = class(TdxCustomSmartImage);
  TdxSVGElementAccess = class(TdxSVGElement);

  { TdxSVGAnnotation }

  TdxSVGAnnotation = class(TdxXMLDocument)
  protected
    function CreateParser: TdxXMLParser; override;
  end;

  { TdxSVGAnnotationParser }

  TdxSVGAnnotationParser = class(TdxXMLParser)
  protected
    function ParseNodeHeader(ANode: TdxXMLNode): TdxXMLNode; override;
  end;

{ TdxSVGSourceData }

constructor TdxSVGSourceData.Create(const ADocument: TdxXMLDocument);
var
  AStream: TZCompressionStream;
begin
  FData := TdxGPMemoryStream.Create;
  AStream := TZCompressionStream.Create(clMax, FData);
  try
  {$IFDEF DXSVG_AUTOINDENT}
    ADocument.AutoIndent := True;
  {$ENDIF}
    ADocument.SaveToStream(AStream);
  finally
    AStream.Free;
  end;
end;

destructor TdxSVGSourceData.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

procedure TdxSVGSourceData.SaveToStream(AStream: TStream);
begin
  FData.Position := 0;
  ZDecompressStream(FData, AStream);
end;

{ TdxSVGImageHandle }

constructor TdxSVGImageHandle.Create(ARoot: TdxSVGElementRoot);
begin
  inherited Create;
  FRoot := ARoot;
end;

destructor TdxSVGImageHandle.Destroy;
begin
  FlushCache;
  SourceData := nil;
  FreeAndNil(FRoot);
  inherited Destroy;
end;

procedure TdxSVGImageHandle.Draw(DC: HDC; const ADest, ASource: TdxRectF; AAlpha: Byte; APalette: IdxColorPalette);
var
  ADestRect: TRect;
  AImage: TdxGPImageHandle;
begin
  if not (Empty or cxRectIsEmpty(ADest) or cxRectIsEmpty(ASource)) then
  begin
    ADestRect := ADest.InflateToTRect;
    dxGPPaintCanvas.BeginPaint(DC, ADestRect);
    try
      AImage := GetRasterizedImage(cxSize(ADestRect), APalette);
      dxGPPaintCanvas.InterpolationMode := ActualInterpolationMode;
      dxGPPaintCanvas.PixelOffsetMode := ActualPixelOffsetMode;
      dxGpDrawImage(dxGPPaintCanvas.Handle, ADest, cxRectScale(ASource, AImage.Width / Width), AImage.Handle, AAlpha);
    finally
      dxGPPaintCanvas.EndPaint;
    end;
  end;
end;

procedure TdxSVGImageHandle.Draw(DC: HDC; const ADest, ASource: TRect; AAlpha: Byte; APalette: IdxColorPalette);
begin
  Draw(DC, dxRectF(ADest), dxRectF(ASource), AAlpha, APalette);
end;

function TdxSVGImageHandle.GetAsBitmap: TBitmap;
begin
  Result := TcxBitmap32.CreateSize(Width, Height, True);
  try
    Draw(Result.Canvas.Handle, TcxBitmap32(Result).ClientRect, ClientRect);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TdxSVGImageHandle.GetAlphaState: TdxAlphaState;
begin
  Result := asSemitransparent;
end;

procedure TdxSVGImageHandle.DrawCore(ACanvas: TdxGPCanvas; const R: TdxRectF; const APalette: IdxColorPalette);
var
  ARender: TdxSVGRenderer;
begin
  ACanvas.SmoothingMode := ActualSmoothingMode;
  ARender := TdxSVGRenderer.Create(ACanvas, APalette);
  try
    FRoot.Draw(ARender, R);
  finally
    ARender.Free;
  end;
end;

procedure TdxSVGImageHandle.DrawCore(ATarget: TdxGPImageHandle; const APalette: IdxColorPalette);
var
  ACanvas: TdxGPCanvas;
begin
  ACanvas := ATarget.CreateCanvas;
  try
    DrawCore(ACanvas, dxRectF(ATarget.ClientRect), APalette);
  finally
    ACanvas.Free;
  end;
end;

procedure TdxSVGImageHandle.FlushCache;
begin
  FreeAndNil(FCachedImage);
end;

function TdxSVGImageHandle.GetSize: TSize;
begin
  if FRoot <> nil then
    Result := cxSize(FRoot.Size, False)
  else
    Result := cxNullSize;
end;

function TdxSVGImageHandle.GetImageFormat: TdxSmartImageCodecClass;
begin
  Result := TdxSVGImageCodec;
end;

function TdxSVGImageHandle.GetRasterizedImage(ASize: TSize; APalette: IdxColorPalette): TdxGPImageHandle;
var
  AViewBoxSize: TSize;
begin
  AViewBoxSize := cxSize(FRoot.ActualViewBox.Size, False);
  ASize := cxSize(cxGetImageRect(cxRect(ASize), AViewBoxSize, ifmFill));
  if FCachedImageQuality <> ActualRenderQuality then
    FlushCache;
  if not IsEqualGUID(FCachedImagePalette, dxGetColorPaletteID(APalette)) then
    FlushCache;
  if (FCachedImage <> nil) and ((FCachedImage.Width <> ASize.cx) or (FCachedImage.Height <> ASize.cy)) then
    FlushCache;
  if FCachedImage = nil then
  begin
    FCachedImage := TdxGPImageHandle.CreateSize(cxSizeScale(ASize, CalculateScaleFactor(ASize)));
    FCachedImageQuality := ActualRenderQuality;
    FCachedImagePalette := dxGetColorPaletteID(APalette);
    DrawCore(FCachedImage, APalette);
    FCachedImage.Resize(ASize, ActualInterpolationMode, ActualPixelOffsetMode);
    FCachedImage.Flip(FFlipHorizontally, FFlipVertically);
  end;
  Result := FCachedImage;
end;

procedure TdxSVGImageHandle.Flip(AHorizontally, AVertically: Boolean);
begin
  FFlipHorizontally := AHorizontally;
  FFlipVertically := AVertically;
  FlushCache;
end;


function TdxSVGImageHandle.CalculateScaleFactor(const AViewBoxSize: TSize): Integer;
var
  AQuality: TdxSVGRenderQuality;
begin
  AQuality := ActualRenderQuality;
  if (AViewBoxSize.cx < 16) and (AViewBoxSize.cy < 16) then
  begin
    Result := Trunc(768 / Max(AViewBoxSize.cx, AViewBoxSize.cy)) + 1;
    Result := Result - (Result mod 16);
    Exit;
  end
  else
    if (AViewBoxSize.cx < 32) and (AViewBoxSize.cy < 32) then
      Result := 32
    else
      if (AViewBoxSize.cx > 96) or (AViewBoxSize.cy > 96) then
      begin
        Result := Trunc(RasterizedImageBufferSize[ActualRenderQuality] / Max(AViewBoxSize.cx, AViewBoxSize.cy));
        if Result > 2 then
          Result := Result - (Result mod 2);

        if Result = 0 then
          Result := 1;
      end
      else
        Result := 16;
  Result := Min(Result, MaxScaleFactor[AQuality]);
end;

function TdxSVGImageHandle.GetActualInterpolationMode: TdxGPInterpolationMode;
begin
  if InterpolationMode <> imDefault then
    Result := InterpolationMode
  else
    if IsWinSevenOrLater then
      Result := imBilinear
    else
      Result := imHighQualityBilinear;
end;

function TdxSVGImageHandle.GetActualRenderQuality: TdxSVGRenderQuality;
begin
  if RenderQuality <> srqDefault then
    Result := RenderQuality
  else
    Result := dxSVGRenderQuality;
end;

function TdxSVGImageHandle.GetActualSmoothingMode: TdxGPSmoothingMode;
begin
  if SmoothingMode <> smDefault then
    Result := SmoothingMode
  else
    Result := smNone;
end;

procedure TdxSVGImageHandle.SetSourceData(AData: TdxSVGSourceData);
begin
  if AData <> FSourceData then
  begin
    FreeAndNil(FSourceData);
    FSourceData := AData;
  end;
end;

{ TdxSVGImage }

procedure TdxSVGImage.SaveToStream(Stream: TStream);
begin
  SaveToStreamByCodec(Stream, TdxSVGImageCodec);
end;

{ TdxSVGImageCodec }

class function TdxSVGImageCodec.CanLoadStream(AStream: TStream): Boolean;
var
  ASize: TSize;
begin
  Result := GetSize(AStream, ASize);
end;

class function TdxSVGImageCodec.CanSaveImage(AHandle: TdxSmartImageCustomHandle): Boolean;
begin
  Result := AHandle is TdxSVGImageHandle;
end;

class function TdxSVGImageCodec.Extensions: string;
begin
  Result := '*.svg;';
end;

class function TdxSVGImageCodec.MimeType: string;
begin
  Result := 'image/svg+xml';
end;

class function TdxSVGImageCodec.GetSize(AStream: TStream; out ASize: TSize): Boolean;
var
  ADocument: TdxXMLDocument;
  APosition: Int64;
begin
  try
    APosition := AStream.Position;
    try
      ADocument := TdxSVGAnnotation.Create(nil);
      try
        ADocument.LoadFromStream(AStream);
        Result := TdxSVGImporter.GetSize(ADocument, ASize);
      finally
        ADocument.Free;
      end;
    finally
      AStream.Position := APosition;
    end;
  except
    Result := False;
  end;
end;

class function TdxSVGImageCodec.Load(AStream: TStream; out AHandle: TdxSmartImageCustomHandle): Boolean;
var
  ADocument: TdxXMLDocument;
begin
  ADocument := TdxXMLDocument.Create(nil);
  try
    ADocument.LoadFromStream(AStream);
    Result := Load(ADocument, AHandle);
  finally
    ADocument.Free;
  end;
end;

class function TdxSVGImageCodec.Load(const ADocument: TdxXMLDocument; out AHandle: TdxSmartImageCustomHandle): Boolean;
var
  AImageHandle: TdxSVGImageHandle absolute AHandle;
  ARoot: TdxSVGElementRoot;
begin
  Result := TdxSVGImporter.Import(ADocument, ARoot);
  if Result then
  begin
    AImageHandle := TdxSVGImageHandle.Create(ARoot);
    AImageHandle.SourceData := TdxSVGSourceData.Create(ADocument);
  end;
end;

class function TdxSVGImageCodec.Load(const AFileName: string; out AHandle: TdxSmartImageCustomHandle): Boolean;
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := Load(AStream, AHandle);
  finally
    AStream.Free;
  end;
end;

class function TdxSVGImageCodec.Save(AStream: TStream; AHandle: TdxSmartImageCustomHandle): Boolean;
var
  ADocument: TdxXMLDocument;
  AImageHandle: TdxSVGImageHandle;
begin
  Result := CanSaveImage(AHandle);
  if Result then
  begin
    AImageHandle := TdxSVGImageHandle(AHandle);
    if AImageHandle.SourceData <> nil then
      AImageHandle.SourceData.SaveToStream(AStream)
    else
    begin
      ADocument := TdxXMLDocument.Create;
      try
        TdxSVGExporter.Export(AImageHandle.FRoot, ADocument);
      {$IFDEF DXSVG_AUTOINDENT}
        ADocument.AutoIndent := True;
      {$ENDIF}
        ADocument.SaveToStream(AStream);
      finally
        ADocument.Free;
      end;
    end;
  end;
end;

class function TdxSVGImageCodec.GetGraphicClassForRegistrationInVCL: TGraphicClass;
begin
  Result := TdxSmartImage;
end;

{ TdxSVGEditingHelper }

class function TdxSVGEditingHelper.Combine(AList: TList<TdxSVGImageHandle>): TdxSVGImageHandle;
var
  AFrameSize: TSize;
  AReferences: TdxSVGReferences;
  ARoot: TdxSVGElementRoot;
  I: Integer;
begin
  if AList.Count = 0 then
    Exit(nil);

  AFrameSize := AList.First.Size;
  for I := 1 to AList.Count - 1 do
    AFrameSize := cxSizeMax(AFrameSize, AList[I].Size);
  ARoot := TdxSVGElementRoot.Create;
  ARoot.ViewBox.Value := dxRectF(0, 0, AFrameSize.cx * AList.Count, AFrameSize.cy);

  AReferences := TdxSVGReferences.Create;
  try
    for I := 0 to AList.Count - 1 do
      Append(ARoot, AList[I].FRoot, AReferences, I * AFrameSize.cy, 0);
  finally
    AReferences.Free;
  end;

  Result := TdxSVGImageHandle.Create(ARoot);
end;

class function TdxSVGEditingHelper.Split(AImage: TdxCustomSmartImage; out AList: TList<TdxSVGImageHandle>): Boolean;
begin
  if TdxCustomSmartImageAccess(AImage).Handle is TdxSVGImageHandle then
    Result := Split(TdxSVGImageHandle(TdxCustomSmartImageAccess(AImage).Handle), AList)
  else
    Result := False;
end;

class function TdxSVGEditingHelper.Split(AImage: TdxSVGImageHandle; out AList: TList<TdxSVGImageHandle>): Boolean;
var
  AFrameSize: TSize;
  I: Integer;
begin
  Result := IsMultiframeTexture(AImage.FRoot);
  if Result then
  begin
    AFrameSize := AImage.Size;
    AFrameSize.cx := AFrameSize.cx div AImage.FRoot.Count;

    AList := TList<TdxSVGImageHandle>.Create;
    AList.Capacity := AImage.FRoot.Count;
    for I := 0 to AImage.FRoot.Count - 1 do
      AList.Add(Extract(AImage.FRoot[I], AFrameSize));
  end;
end;

class procedure TdxSVGEditingHelper.Append(ATarget, ASource: TdxSVGElementRoot;
  AReferences: TdxSVGReferences; AOffsetX, AOffsetY: Single);
var
  AGroup: TdxSVGElementGroup;
  I: Integer;
begin
  AGroup := TdxSVGElementGroup.Create;
  AGroup.Parent := ATarget;
  AGroup.Transform.Translate(AOffsetX, AOffsetY);
  AGroup.Tag := MultiframeTextureTag;
  for I := 0 to ASource.Count - 1 do
    ASource.Elements[I].Clone.Parent := AGroup;
  UpdateReferences(AReferences, AGroup, AGroup);
end;

class function TdxSVGEditingHelper.Extract(ASource: TdxSVGElement; const AFrameSize: TSize): TdxSVGImageHandle;
var
  ARoot: TdxSVGElementRoot;
  I: Integer;
begin
  ARoot := TdxSVGElementRoot.Create;
  ARoot.ViewBox.Value := dxRectF(0, 0, AFrameSize.cx, AFrameSize.cy);
  for I := 0 to ASource.Count - 1 do
    ASource.Elements[I].Clone.Parent := ARoot;
  Result := TdxSVGImageHandle.Create(ARoot);
end;

class function TdxSVGEditingHelper.IsMultiframeTexture(ARoot: TdxSVGElementRoot): Boolean;
var
  AElement: TdxSVGElement;
  I: Integer;
begin
  for I := 0 to ARoot.Count - 1 do
  begin
    AElement := ARoot.Elements[I];
    if not (AElement is TdxSVGElementGroup) then
      Exit(False);
    if TdxSVGElementGroup(AElement).Tag <> MultiframeTextureTag then
      Exit(False);
  end;
  Result := True;
end;

class procedure TdxSVGEditingHelper.UpdateReferences(AReferences: TdxSVGReferences; AElement, ARootElement: TdxSVGElement);
var
  AReference: string;
  I: Integer;
begin
  if AReferences.Contains(AElement.ID) then
  begin
    AReference := AReferences.Generate;
    AReferences.Include(AReference);
    TdxSVGElementAccess(ARootElement).UpdateReference(AElement.ID, AReference);
  end;
  for I := 0 to AElement.Count - 1 do
    UpdateReferences(AReferences, AElement[I], ARootElement);
end;

{ TdxSVGAnnotation }

function TdxSVGAnnotation.CreateParser: TdxXMLParser;
begin
  Result := TdxSVGAnnotationParser.Create(Self, False);
end;

{ TdxSVGAnnotationParser }

function TdxSVGAnnotationParser.ParseNodeHeader(ANode: TdxXMLNode): TdxXMLNode;
begin
  inherited ParseNodeHeader(ANode);
  Result := nil;
end;

procedure RegisterAssistants;
begin
  if CheckGdiPlus then
  begin
    TPicture.RegisterFileFormat('', '', TdxSVGImage); 
    TdxSmartImageCodecsRepository.Register(TdxSVGImageCodec);
  end;
end;

procedure UnregisterAssistants;
begin
  TPicture.UnregisterGraphicClass(TdxSVGImage);
  TdxSmartImageCodecsRepository.Unregister(TdxSVGImageCodec);
end;


initialization

  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, RegisterAssistants, UnregisterAssistants);

finalization

  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, UnregisterAssistants);

end.
