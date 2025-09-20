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

unit cxImageList;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, Classes, SysUtils, Controls, Graphics, Menus, CommCtrl, ComCtrls, ImgList, ActiveX, Contnrs,
  dxCore, dxCoreGraphics, dxMessages, cxClasses, cxGeometry, dxGDIPlusClasses, dxGDIPlusApi, dxSmartImage, dxDPIAwareUtils,
  dxTypeHelpers;

type

  { EcxUnsupportedImageListStreamFormat }

  EcxUnsupportedImageListStreamFormat = class(EdxException)
  public
    constructor Create;
  end;

  { TcxImageInfo }

  TcxImageInfo = class(TPersistent)
  strict private
    FFileName: string;
    FImage: TGraphic;
    FIsAlphaUsed: TdxDefaultBoolean;
    FKeywords: string;
    FMask: TBitmap;
    FMaskColor: TColor;

    procedure AssignBitmap(ASourceBitmap, ADestBitmap: TBitmap);
    function GetImageClass: TGraphicClass;
    function GetImageClassName: string;
    function GetImageType: string;
    function GetIsAlphaUsed: Boolean;
    procedure SetImage(Value: TGraphic);
    procedure SetImageClass(AValue: TGraphicClass);
    procedure SetImageClassName(const Value: string);
    procedure SetMask(Value: TBitmap);
  private
    FInternalMask: TBitmap;

    function HasMask: Boolean;
    function HasNativeHandle: Boolean;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure ConvertTo32Bit;
    procedure Dormant;
    function Equals(Obj: TObject): Boolean; override;
    procedure FlushMask;
    procedure Reset;
    procedure Resize(const ASize: TSize);

    property ImageClass: TGraphicClass read GetImageClass write SetImageClass;
    property ImageType: string read GetImageType;
    property IsAlphaUsed: Boolean read GetIsAlphaUsed;
  published
    property ImageClassName: string read GetImageClassName write SetImageClassName;
    property Image: TGraphic read FImage write SetImage;
    property Mask: TBitmap read FMask write SetMask;
    property MaskColor: TColor read FMaskColor write FMaskColor;
    property FileName: string read FFileName write FFileName;
    property Keywords: string read FKeywords write FKeywords;
  end;

  { TcxImageInfoHelper }

  TcxImageInfoHelper = class
  public
    class procedure CopyRect(ADest: TBitmap; const ADestRect: TRect; ASource: TGraphic); overload;
    class procedure CopyRect(ADest: TBitmap; const ADestRect: TRect; ASource: TGraphic; const ASourceRect: TRect); overload;
    class function GetDefaultTransparentColor(AImage: TGraphic; AMask: TBitmap): TColor;
    class function GetPixel(AGraphic: TGraphic; X, Y: Integer): TColor;
    class function GetPixelFormat(AGraphic: TGraphic): TPixelFormat;
    class function IsAlphaUsed(AGraphic: TGraphic): Boolean;
    class procedure Resize(AGraphic: TGraphic; const ASize: TSize);
  end;

  { TcxBaseImageList }

  TcxBaseImageList = class(TDragImageList, IdxSourceDPI)
  strict private
    FSourceDPI: Integer;

    // IdxSourceDPI
    function GetSourceDPI: Integer;
    procedure SetSourceDPI(AValue: Integer);
  protected
    procedure Initialize; override;
  public
    procedure BeforeDestruction; override;
  published
    property SourceDPI: Integer read FSourceDPI write SetSourceDPI;
  end;

  { TcxCustomImageList }

  TcxCustomImageList = class(TcxBaseImageList)
  strict private const
    DXILSignature = $4C495844; //DXIL
    DXILVersion = 1;
  strict private
    FAlphaBlending: Boolean;
    FFormatVersion: Integer;
    FImages: TCollection;
    FLockCount: Integer;
    FSynchronizationLockCount: Integer;

    procedure ReadDesignInfo(AReader: TReader);
    procedure ReadFormatVersion(AReader: TReader);
    procedure ReadImageInfo(AReader: TReader);
    procedure WriteDesignInfo(AWriter: TWriter);
    procedure WriteFormatVersion(AWriter: TWriter);
    procedure WriteImageInfo(AWriter: TWriter);

    function IsSynchronizationLocked: Boolean;
    procedure SynchronizeImageInfo;
    procedure SynchronizeHandle;

    procedure AddToInternalCollection(AImage: TGraphic;
      AMask: TBitmap; AMaskColor: TColor; const AKeywords, AFileName: string);
    class procedure CheckImageSize(AImage: TBitmap; AWidth, AHeight: Integer);
    procedure DormantImage(AIndex: Integer);
    function GetImageCount(AImage: TGraphic; AWidth, AHeight: Integer): Integer;

    function GetCompressData: Boolean;
    function GetHandle: HImageList;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetCompressData(Value: Boolean);
    procedure SetHandle(Value: HImageList);
    procedure SetHeight(AValue: Integer);
    procedure SetWidth(AValue: Integer);
  protected
    function ChangeLocked: Boolean;
  {$IFNDEF DELPHIXE8}
    procedure Change; override;
  {$ENDIF}
    procedure DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean = True); override;
    procedure DoDrawEx(AIndex: Integer; ACanvas: TCanvas; const ARect: TRect; AStyle: Cardinal; AStretch, ASmoothResize, AEnabled: Boolean);

    procedure Initialize; override;
    procedure Finalize;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Dormant;

    procedure GetImageInfoCore(AIndex: Integer; AImage, AMask: TBitmap;
      APalette: IdxColorPalette; var AIsAlphaUsed: TdxDefaultBoolean); overload;
    class procedure GetImageInfoCore(AImages: TCustomImageList; AIndex: Integer;
      AImage, AMask: TBitmap; APalette: IdxColorPalette; var AIsAlphaUsed: TdxDefaultBoolean); overload;

    // for cxImageListEditor
    function AddCore(AImage: TGraphic; AMask: TBitmap; AMaskColor: TColor; const AKeywords, AFileName: string): Integer; overload;
    function AddImageInfo(AImageInfo: TcxImageInfo): Integer;
    function CanSplitImage(AImage: TGraphic): Boolean;
    procedure ConvertTo32bit;
    procedure InternalCopyImageInfos(AImageList: TcxCustomImageList; AStartIndex, AEndIndex: Integer);
    procedure InternalCopyImages(AImageList: TCustomImageList; AStartIndex, AEndIndex: Integer);
    function GetImageInfo(AIndex: Integer): TcxImageInfo; overload;
    function HasRasterImages: Boolean;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  {$IFDEF DELPHIXE8}
    procedure Change; override; 
  {$ENDIF}

    // Base Functions
    function Add(AImage: TBitmap; AMask: TBitmap): Integer; overload;
    function Add(AImage: TdxSmartImage; const AKeywords: string = ''; const ASourceFileName: string = ''): Integer; overload;
    function Add(AImage: TGraphic; AMask: TBitmap): Integer; overload;
    function AddIcon(AIcon: TIcon): Integer;
    function AddMasked(AImage: TGraphic; AMaskColor: TColor): Integer;
    function Equals(Obj: TObject): Boolean; override;
    procedure Move(ACurIndex, ANewIndex: Integer);
    procedure Delete(AIndex: Integer);

    // Subsidiary Functions
    function AddBitmap(AImage, AMask: TBitmap; AMaskColor: TColor; AStretch, ASmooth: Boolean): Integer;
    function AddImage(AImages: TCustomImageList; AIndex: Integer): Integer;
    procedure AddImagesFromResZipStream(AInstance: THandle; const AResourceName: string; AResType: PChar);
    procedure AddImagesFromZipStream(AStream: TStream);
    function AddImageFromResource(AInstance: THandle; const AResourceName: string; AResType: PChar): Integer;
    procedure AddImages(AImages: TCustomImageList);
    procedure CopyImages(AImages: TCustomImageList; AStartIndex: Integer = 0; AEndIndex: Integer = -1);
    procedure Clear;
    procedure Insert(AIndex: Integer; AImage: TGraphic; AMask: TBitmap);
    procedure InsertIcon(AIndex: Integer; AIcon: TIcon);
    procedure InsertMasked(AIndex: Integer; AImage: TGraphic; AMaskColor: TColor);
    procedure Replace(AIndex: Integer; AImage: TGraphic; AMask: TBitmap);
    procedure ReplaceIcon(AIndex: Integer; AIcon: TIcon);
    procedure ReplaceMasked(AIndex: Integer; AImage: TGraphic; AMaskColor: TColor);

    procedure DrawOverlay(Canvas: TCanvas; X, Y: Integer;
      ImageIndex: Integer; Overlay: TOverlay; Enabled: Boolean = True); overload;
    procedure DrawOverlay(Canvas: TCanvas; X, Y: Integer;
      ImageIndex: Integer; Overlay: TOverlay; ADrawingStyle: TDrawingStyle;
      AImageType: TImageType; Enabled: Boolean = True); overload;
    function LoadImage(AInstance: THandle; const AResourceName: string;
      AMaskColor: TColor = clDefault; AWidth: Integer = 0; AFlags: TLoadResources = []): Boolean;
    function FileLoad(AResType: TResType; const AName: string; AMaskColor: TColor): Boolean;
    function GetResource(AResType: TResType; const AName: string;
      AWidth: Integer; ALoadFlags: TLoadResources; AMaskColor: TColor): Boolean;
    function GetInstRes(AInstance: THandle; AResType: TResType; const AName: string;
      AWidth: Integer; ALoadFlags: TLoadResources; AMaskColor: TColor): Boolean; overload;
    function GetInstRes(AInstance: THandle; AResType: TResType; AResID: DWORD;
      AWidth: Integer; ALoadFlags: TLoadResources; AMaskColor: TColor): Boolean; overload;
    function ResourceLoad(AResType: TResType; const AName: string; AMaskColor: TColor): Boolean;
    function ResInstLoad(AInstance: THandle; AResType: TResType; const AName: string; AMaskColor: TColor): Boolean;

    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromResource(AInstance: THandle; const AResourceName: string; AResourceType: PChar);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToFile(const AFileName: string);
    procedure SaveToStream(AStream: TStream);

    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure EndUpdate;

    procedure Draw(ACanvas: TCanvas; const ARect: TRect; AIndex: Integer;
      AStretch: Boolean = True; ASmoothResize: Boolean = False; AEnabled: Boolean = True); overload;

    procedure GetImageInfo(AIndex: Integer; AImage, AMask: TBitmap; APalette: IdxColorPalette = nil); overload;
    procedure GetImage(AIndex: Integer; AImage: TBitmap); overload;
    procedure GetImage(AIndex: Integer; AImage: TdxSmartImage); overload;
    procedure GetMask(AIndex: Integer; AMask: TBitmap);
    function GetKeywords(AIndex: Integer): string;
    function GetSourceFileName(AIndex: Integer): string;

    class procedure GetImageInfo(AImages: TCustomImageList; AIndex: Integer; AImage, AMask: TBitmap; APalette: IdxColorPalette = nil); overload;
    class procedure GetImageInfo(AHandle: HIMAGELIST; AIndex: Integer; AImage, AMask: TBitmap); overload;
    class function GetPixelFormat(AHandle: HIMAGELIST): Integer;
    class function IsEquals(AImages1, AImages2: TCustomImageList): Boolean;

    procedure Resize(const ASize: TSize);
    procedure SetSize(AWidth, AHeight: Integer); overload;
    procedure SetSize(const ASize: TSize); overload;

    property AlphaBlending: Boolean read FAlphaBlending write FAlphaBlending;
    property Handle: HImageList read GetHandle write SetHandle;
  published
    property BlendColor;
    property BkColor;
    property ColorDepth default cd32Bit;
    property CompressData: Boolean read GetCompressData write SetCompressData default False;
    property DrawingStyle;
    property Height: Integer read GetHeight write SetHeight default 16;
    property ImageType;
    property ShareImages;
    property Width: Integer read GetWidth write SetWidth default 16;
    property OnChange;
  end;

function cxGetImageListStyle(ADrawingStyle: TDrawingStyle; AImageType: TImageType): DWORD;
implementation

uses
  cxGraphics, Math, dxFading, cxVariants, dxZIPUtils;

const
  dxThisUnitName = 'cxImageList';

const
  StreamFilerBufferSize = 4096;

type
  TBitmapAccess = class(TBitmap);
  TcxBitmap32Access = class(TcxBitmap32);

  { TcxImageInfoItem }

  TcxImageInfoItem = class(TCollectionItem)
  strict private
    FImageInfo: TcxImageInfo;

    function GetCompressData: Boolean;
    function GetFileName: string;
    function GetImage: TGraphic;
    function GetImageClass: string;
    function GetKeywords: string;
    function GetMask: TBitmap;
    function GetMaskColor: TColor;
    function IsImageClassStored: Boolean;
    procedure SetCompressData(Value: Boolean);
    procedure SetFileName(const Value: string);
    procedure SetImage(Value: TGraphic);
    procedure SetImageClass(const Value: string);
    procedure SetKeywords(const Value: string);
    procedure SetMask(Value: TBitmap);
    procedure SetMaskColor(Value: TColor);
  public
    constructor Create(ACollection: TCollection); overload; override;
    constructor Create(ACollection: TCollection; AImage: TGraphic; AMask: TBitmap; AMaskColor: TColor = clNone); reintroduce; overload;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function Equals(Obj: TObject): Boolean; override;

    property CompressData: Boolean read GetCompressData write SetCompressData;
    property ImageInfo: TcxImageInfo read FImageInfo;
  published
    property ImageClass: string read GetImageClass write SetImageClass stored IsImageClassStored;
    property Image: TGraphic read GetImage write SetImage;
    property Mask: TBitmap read GetMask write SetMask;
    property MaskColor: TColor read GetMaskColor write SetMaskColor default clNone;
    property FileName: string read GetFileName write SetFileName;
    property Keywords: string read GetKeywords write SetKeywords;
  end;

  { TcxImageInfoCollection }

  TcxImageInfoCollection = class(TCollection)
  strict private
    FCompressData: Boolean;
    FImageList: TcxCustomImageList;

    procedure SetCompressData(Value: Boolean);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AImageList: TcxCustomImageList);
    function Add(AImage: TGraphic; AMask: TBitmap; AMaskColor: TColor; const AKeywords, AFileName: string): TcxImageInfoItem;
    function Equals(Obj: TObject): Boolean; override;
    procedure Move(ACurrentIndex, ANewIndex: Integer);
    procedure Delete(AIndex: Integer);
    function GetVectorImageCount: Integer;

    property CompressData: Boolean read FCompressData write SetCompressData;
  end;

function cxGetImageListStyle(ADrawingStyle: TDrawingStyle; AImageType: TImageType): DWORD;
const
  DrawingStyles: array[TDrawingStyle] of DWORD = (ILD_FOCUS, ILD_SELECTED, ILD_NORMAL, ILD_TRANSPARENT);
  ImageTypes: array[TImageType] of DWORD = (0, ILD_MASK);
begin
  Result := DrawingStyles[ADrawingStyle] or ImageTypes[AImageType];
end;

{ EcxUnsupportedImageListStreamFormat }

constructor EcxUnsupportedImageListStreamFormat.Create;
begin
  inherited Create('Unsupported stream format');
end;

{ TcxImageInfoItem }

constructor TcxImageInfoItem.Create(ACollection: TCollection);
begin
  inherited;
  FImageInfo := TcxImageInfo.Create;
  CompressData := TcxImageInfoCollection(ACollection).CompressData;
end;

constructor TcxImageInfoItem.Create(ACollection: TCollection; AImage: TGraphic; AMask: TBitmap; AMaskColor: TColor);
begin
  Create(ACollection);
  Image := AImage;
  Mask := AMask;
  MaskColor := AMaskColor;
end;

destructor TcxImageInfoItem.Destroy;
begin
  FreeAndNil(FImageInfo);
  inherited Destroy;
end;

function TcxImageInfoItem.Equals(Obj: TObject): Boolean;
begin
  Result := (Obj is TcxImageInfoItem) and ImageInfo.Equals(TcxImageInfoItem(Obj).ImageInfo);
end;

procedure TcxImageInfoItem.Assign(Source: TPersistent);
begin
  if Source is TcxImageInfoItem then
    FImageInfo.Assign(TcxImageInfoItem(Source).ImageInfo)
  else
    inherited;
end;

function TcxImageInfoItem.GetCompressData: Boolean;
begin
  Result := TcxBitmap(Mask).CompressData;
  if Result and (Image is TcxBitmap) then
    Result := TcxBitmap(Image).CompressData;
end;

function TcxImageInfoItem.GetFileName: string;
begin
  Result := FImageInfo.FileName;
end;

function TcxImageInfoItem.GetImage: TGraphic;
begin
  Result := FImageInfo.Image;
end;

function TcxImageInfoItem.GetImageClass: string;
begin
  Result := FImageInfo.ImageClassName;
end;

function TcxImageInfoItem.GetKeywords: string;
begin
  Result := FImageInfo.Keywords;
end;

function TcxImageInfoItem.GetMask: TBitmap;
begin
  Result := FImageInfo.Mask;
end;

function TcxImageInfoItem.GetMaskColor: TColor;
begin
  Result := FImageInfo.MaskColor;
end;

function TcxImageInfoItem.IsImageClassStored: Boolean;
begin
  Result := not (Image is TcxBitmap);
end;

procedure TcxImageInfoItem.SetCompressData(Value: Boolean);
begin
  if CompressData <> Value then
  begin
    if Image is TcxBitmap then
      TcxBitmap(Image).CompressData := Value;
    TcxBitmap(Mask).CompressData := Value;
  end;
end;

procedure TcxImageInfoItem.SetFileName(const Value: string);
begin
  FImageInfo.FileName := Value;
end;

procedure TcxImageInfoItem.SetImage(Value: TGraphic);
begin
  FImageInfo.Image := Value;
end;

procedure TcxImageInfoItem.SetImageClass(const Value: string);
begin
  FImageInfo.ImageClassName := Value;
end;

procedure TcxImageInfoItem.SetKeywords(const Value: string);
begin
  FImageInfo.Keywords := Value;
end;

procedure TcxImageInfoItem.SetMask(Value: TBitmap);
begin
  FImageInfo.Mask := Value;
end;

procedure TcxImageInfoItem.SetMaskColor(Value: TColor);
begin
  FImageInfo.MaskColor := Value;
end;

{ TcxImageInfoCollection }

constructor TcxImageInfoCollection.Create(AImageList: TcxCustomImageList);
begin
  inherited Create(TcxImageInfoItem);
  FImageList := AImageList;
end;

function TcxImageInfoCollection.Add(AImage: TGraphic; AMask: TBitmap;
  AMaskColor: TColor; const AKeywords, AFileName: string): TcxImageInfoItem;
begin
  Result := TcxImageInfoItem.Create(Self, AImage, AMask, AMaskColor);
  Result.ImageInfo.Keywords := AKeywords;
  Result.ImageInfo.FileName := AFileName;
  Result.ImageInfo.Dormant;
end;

procedure TcxImageInfoCollection.Move(ACurrentIndex, ANewIndex: Integer);
begin
  Items[ACurrentIndex].Index := ANewIndex;
end;

procedure TcxImageInfoCollection.Delete(AIndex: Integer);
begin
  if AIndex = -1 then
    Clear
  else
    inherited Delete(AIndex);
end;

function TcxImageInfoCollection.Equals(Obj: TObject): Boolean;
var
  I: Integer;
begin
  if Self = Obj then
    Exit(True);

  Result := (Obj is TcxImageInfoCollection) and (Count = TcxImageInfoCollection(Obj).Count);
  if Result then
    for I := 0 to Count - 1 do
    begin
      if not Items[I].Equals(TcxImageInfoCollection(Obj).Items[I]) then
        Exit(False);
    end;
end;

function TcxImageInfoCollection.GetVectorImageCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
  begin
    if Supports(TcxImageInfoItem(Items[I]).Image, IdxVectorImage) then
      Inc(Result);
  end;
end;

function TcxImageInfoCollection.GetOwner: TPersistent;
begin
  Result := FImageList;
end;

procedure TcxImageInfoCollection.SetCompressData(Value: Boolean);
var
  I: Integer;
begin
  if CompressData <> Value then
  begin
    FCompressData := Value;
    for I := 0 to Count - 1 do
      TcxImageInfoItem(Items[I]).CompressData := Value;
  end;
end;

{ TcxImageInfo }

constructor TcxImageInfo.Create;
begin
  inherited Create;
  FImage := TcxBitmap.Create;
  FMask := TcxBitmap.Create;
  FMaskColor := clNone;
  FInternalMask := TcxBitmap.Create;
  FIsAlphaUsed := bDefault;
end;

destructor TcxImageInfo.Destroy;
begin
  FreeAndNil(FInternalMask);
  FreeAndNil(FMask);
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TcxImageInfo.Assign(Source: TPersistent);
begin
  if Source is TcxImageInfo then
  begin
    Image := TcxImageInfo(Source).Image;
    Mask := TcxImageInfo(Source).Mask;
    MaskColor := TcxImageInfo(Source).MaskColor;
    Keywords := TcxImageInfo(Source).Keywords;
    FileName := TcxImageInfo(Source).FileName;
  end
  else
    inherited;
end;

procedure TcxImageInfo.ConvertTo32Bit;
var
  ABuffer: TcxAlphaBitmap;
  ARegion: TcxRegionHandle;
begin
  if HasMask then
  begin
    ABuffer := TcxAlphaBitmap.CreateSize(Image.Width, Image.Height);
    try
      TcxImageInfoHelper.CopyRect(ABuffer, ABuffer.ClientRect, Image);
      if cxColorIsValid(MaskColor) then
        ABuffer.RecoverTransparency(MaskColor)
      else
      begin
        if not IsAlphaUsed then
          ABuffer.TransformBitmap(btmSetOpaque);
        if IsGlyphAssigned(Mask) then
        begin
          ARegion := cxCreateRegionFromBitmap(Mask, clBlack);
          if ARegion <> 0 then
          try
            SelectClipRgn(ABuffer.Canvas.Handle, ARegion);
            cxClearBitmap(ABuffer);
          finally
            DeleteObject(ARegion);
          end;
        end
      end;
      ImageClass := TBitmap;
      Image.Assign(ABuffer);
    finally
      ABuffer.Free;
    end;
    FIsAlphaUsed := bDefault;
  end;
  FlushMask;
end;

procedure TcxImageInfo.Dormant;
begin
  cxGraphicDormant(Mask);
  cxGraphicDormant(Image);
end;

function TcxImageInfo.Equals(Obj: TObject): Boolean;
begin
  Result := (Obj is TcxImageInfo) and
    (MaskColor = TcxImageInfo(Obj).MaskColor) and
    (Keywords = TcxImageInfo(Obj).Keywords) and
    (FileName = TcxImageInfo(Obj).FileName) and
    cxCompareGraphics(Mask, TcxImageInfo(Obj).Mask) and
    cxCompareGraphics(Image, TcxImageInfo(Obj).Image);
end;

procedure TcxImageInfo.FlushMask;
begin
  Mask := nil;
  MaskColor := clNone;
end;

procedure TcxImageInfo.Reset;
begin
  FlushMask;
  Image := nil;
  FileName := EmptyStr;
  Keywords := EmptyStr;
end;

procedure TcxImageInfo.Resize(const ASize: TSize);
begin
  ConvertTo32Bit;
  TcxImageInfoHelper.Resize(Image, ASize);
end;

procedure TcxImageInfo.AssignBitmap(ASourceBitmap, ADestBitmap: TBitmap);
begin
  ADestBitmap.Assign(ASourceBitmap);
  ADestBitmap.Handle; // HandleNeeded
end;

function TcxImageInfo.HasMask: Boolean;
begin
  Result := cxColorIsValid(MaskColor) or not Mask.Empty;
end;

function TcxImageInfo.HasNativeHandle: Boolean;
begin
  Result := FImage is TBitmap;
end;

function TcxImageInfo.GetImageClass: TGraphicClass;
begin
  if Image <> nil then
    Result := TGraphicClass(Image.ClassType)
  else
    Result := nil;
end;

function TcxImageInfo.GetImageClassName: string;
begin
  Result := Image.ClassName;
end;

function TcxImageInfo.GetImageType: string;
begin
  Result := UpperCase(cxGraphicExtension(Image));
  if Result = '' then
    Result := 'IMG';
end;

function TcxImageInfo.GetIsAlphaUsed: Boolean;
begin
  if FIsAlphaUsed = bDefault then
    FIsAlphaUsed := dxBooleanToDefaultBoolean(TcxImageInfoHelper.IsAlphaUsed(Image));
  Result := FIsAlphaUsed = bTrue;
end;

procedure TcxImageInfo.SetImage(Value: TGraphic);
begin
  if Value <> nil then
    ImageClass := TGraphicClass(Value.ClassType);
  FImage.Assign(Value);
  FIsAlphaUsed := bDefault;
end;

procedure TcxImageInfo.SetImageClass(AValue: TGraphicClass);
begin
  if (AValue <> nil) and (AValue <> ImageClass) then
  begin
    FreeAndNil(FImage);
    FImage := AValue.Create;
    FIsAlphaUsed := bDefault;
  end;
end;

procedure TcxImageInfo.SetImageClassName(const Value: string);
var
  AClass: TClass;
begin
  AClass := GetClass(Value);
  if (AClass = nil) or not AClass.InheritsFrom(TGraphic) then
    raise EdxException.CreateFmt('The "%s" is invalid graphic class', [Value]);
  ImageClass := TGraphicClass(AClass);
end;

procedure TcxImageInfo.SetMask(Value: TBitmap);
begin
  AssignBitmap(Value, Mask);
end;

{ TcxImageInfoHelper }

class procedure TcxImageInfoHelper.CopyRect(ADest: TBitmap; const ADestRect: TRect; ASource: TGraphic);
begin
  CopyRect(ADest, ADestRect, ASource, cxGetImageClientRect(ASource));
end;

class procedure TcxImageInfoHelper.CopyRect(ADest: TBitmap;
  const ADestRect: TRect; ASource: TGraphic; const ASourceRect: TRect);
begin
  if ASource is TBitmap then
    ADest.Canvas.CopyRect(ADestRect, TBitmap(ASource).Canvas, ASourceRect)
  else
    if ASource is TdxCustomSmartImage then
      TdxCustomSmartImage(ASource).StretchDraw(ADest.Canvas.Handle, ADestRect, ASourceRect);
end;

class function TcxImageInfoHelper.GetDefaultTransparentColor(AImage: TGraphic; AMask: TBitmap): TColor;
begin
  if IsGlyphAssigned(AMask) or not (AImage is TBitmap) or IsAlphaUsed(AImage) then
    Result := clNone
  else
    Result := TBitmap(AImage).Canvas.Pixels[0, AImage.Height - 1];
end;

class function TcxImageInfoHelper.GetPixel(AGraphic: TGraphic; X, Y: Integer): TColor;
begin
  if AGraphic is TBitmap then
    Result := TBitmap(AGraphic).Canvas.Pixels[X, Y]
  else
    Result := clNone;
end;

class function TcxImageInfoHelper.GetPixelFormat(AGraphic: TGraphic): TPixelFormat;
begin
  if AGraphic is TBitmap then
    Result := TBitmap(AGraphic).PixelFormat
  else
    if AGraphic is TMetafile then
      Result := pf24bit
    else
      Result := pf32bit; // todo
end;

class function TcxImageInfoHelper.IsAlphaUsed(AGraphic: TGraphic): Boolean;
begin
  if AGraphic is TBitmap then
    Result := dxIsAlphaUsed(TBitmap(AGraphic))
  else if AGraphic is TdxCustomSmartImage then
    Result := TdxCustomSmartImage(AGraphic).IsAlphaUsed
  else
    Result := False;
end;

class procedure TcxImageInfoHelper.Resize(AGraphic: TGraphic; const ASize: TSize);
var
  ABitmap: TcxBitmap32;
begin
  if AGraphic is TdxCustomSmartImage then
    TdxCustomSmartImage(AGraphic).Resize(ASize)
  else
    if AGraphic is TBitmap then
    begin
      ABitmap := TcxBitmap32.CreateSize(ASize.cx, ASize.cy, True);
      try
        cxStretchGraphic(ABitmap, AGraphic, True);
        AGraphic.Assign(ABitmap);
      finally
        ABitmap.Free;
      end;
    end
    else
      raise Exception.Create('');
end;

{ TcxBaseImageList }

procedure TcxBaseImageList.BeforeDestruction;
begin
  inherited BeforeDestruction;
  cxBroadcastRemoveNotifications(Self);
end;

procedure TcxBaseImageList.Initialize;
begin
  inherited;
  FSourceDPI := dxDefaultDPI;
end;

function TcxBaseImageList.GetSourceDPI: Integer;
begin
  Result := FSourceDPI;
end;

procedure TcxBaseImageList.SetSourceDPI(AValue: Integer);
begin
  AValue := dxCheckDPIValue(AValue);
  if FSourceDPI <> AValue then
  begin
    FSourceDPI := AValue;
    Change;
  end;
end;

{ TcxCustomImageList }

destructor TcxCustomImageList.Destroy;
begin
  Finalize;
  inherited Destroy;
end;

procedure TcxCustomImageList.Assign(Source: TPersistent);
var
  AImages: TCustomImageList;
begin
  if Source is TCustomImageList then
  begin
    BeginUpdate;
    try
      inherited;
      Clear;
      AImages := TCustomImageList(Source);
      if AImages is TcxCustomImageList then
        InternalCopyImageInfos(TcxCustomImageList(AImages), 0, AImages.Count - 1)
      else
        InternalCopyImages(AImages, 0, AImages.Count - 1);
    finally
      EndUpdate;
    end;
  end;
end;

function TcxCustomImageList.Add(AImage: TBitmap; AMask: TBitmap): Integer;
begin
  Result := Add(TGraphic(AImage), AMask);
end;

function TcxCustomImageList.Add(AImage: TdxSmartImage; const AKeywords: string = ''; const ASourceFileName: string = ''): Integer;
begin
  Result := AddCore(AImage, nil, clNone, AKeywords, ASourceFileName);
end;

function TcxCustomImageList.Add(AImage: TGraphic; AMask: TBitmap): Integer;
begin
  Result := AddCore(AImage, AMask, clNone, EmptyStr, EmptyStr);
end;

function TcxCustomImageList.AddIcon(AIcon: TIcon): Integer;
var
  AImage, AMask: TBitmap;
begin
  BeginUpdate;
  try
    Result := inherited AddIcon(AIcon);
    if not IsSynchronizationLocked and (Result <> -1) then
    begin
      AImage := cxCreateBitmap(Width, Height, pf32bit);
      AMask := cxCreateBitmap(Width, Height, pf1bit);
      try
        GetImageInfo(Handle, Count - 1, AImage, AMask);
        AddToInternalCollection(AImage, AMask, clNone, '', '');
      finally
        AMask.Free;
        AImage.Free
      end;
    end;
  finally
    EndUpdate;
  end;
end;

function TcxCustomImageList.AddMasked(AImage: TGraphic; AMaskColor: TColor): Integer;
begin
  Result := AddCore(AImage, nil, AMaskColor, '', '');
end;

function TcxCustomImageList.Equals(Obj: TObject): Boolean;
begin
  Result := (Self = Obj) or (Obj is TcxCustomImageList) and
    TcxImageInfoCollection(FImages).Equals(TcxCustomImageList(Obj).FImages);
end;

procedure TcxCustomImageList.Move(ACurIndex, ANewIndex: Integer);
var
  AStep, AIndex: Integer;
begin
  BeginUpdate;
  try
    AStep := cxSign(ANewIndex - ACurIndex);
    AIndex := ACurIndex;
    while AIndex <> ANewIndex do
    begin
      ImageList_Copy(Handle, AIndex + AStep, Handle, AIndex, ILCF_SWAP);
      Inc(AIndex, AStep);
    end;
    if not IsSynchronizationLocked then
      TcxImageInfoCollection(FImages).Move(ACurIndex, ANewIndex);
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.Delete(AIndex: Integer);
begin
  BeginUpdate;
  try
    inherited;
    if not IsSynchronizationLocked then
      TcxImageInfoCollection(FImages).Delete(AIndex);
  finally
    EndUpdate;
  end;
end;

function TcxCustomImageList.AddBitmap(AImage, AMask: TBitmap; AMaskColor: TColor; AStretch, ASmooth: Boolean): Integer;
var
  ASizedImage, ASizedMask: TBitmap;
begin
  if (AImage.Width <> Width) or (AImage.Height <> Height) then
  begin
    ASmooth := ASmooth and AStretch and (AImage.PixelFormat = pf32bit);
    ASizedImage := TcxBitmap32.CreateSize(AImage.Width, AImage.Height);
    TcxBitmap32Access(ASizedImage).CopyBitmap(AImage);
    TcxBitmap32Access(ASizedImage).Resize(Width, Height, AStretch, ASmooth, AMaskColor);
  end
  else
    ASizedImage := AImage;

  if (AMask <> nil) and ((AMask.Width <> Width) or (AMask.Height <> Height)) then
  begin
    ASizedMask := TcxBitmap32.CreateSize(AMask.Width, AMask.Height);
    TcxBitmap32Access(ASizedMask).CopyBitmap(AMask);
    TcxBitmap32Access(ASizedMask).Resize(Width, Height, AStretch, False);
  end
  else
    ASizedMask := AMask;

  try
    if ASizedMask <> nil then
      Result := Add(ASizedImage, ASizedMask)
    else
      Result := AddMasked(ASizedImage, AMaskColor);
  finally
    if ASizedMask <> AMask then
     ASizedMask.Free;
    if ASizedImage <> AImage then
     ASizedImage.Free;
  end;
end;

function TcxCustomImageList.AddImage(AImages: TCustomImageList; AIndex: Integer): Integer;
begin
  if (AImages <> nil) and (AIndex < AImages.Count) then
  begin
    Result := Count;
    CopyImages(AImages, AIndex, AIndex);
  end
  else
    Result := -1;
end;

function TcxCustomImageList.AddImageFromResource(AInstance: THandle;
  const AResourceName: string; AResType: PChar): Integer;
var
  AImage: TdxSmartImage;
begin
  if AResourceName = '' then
    Exit(-1);
  AImage := TdxSmartImage.Create;
  try
    AImage.LoadFromResource(AInstance, AResourceName, AResType);
    Result := Add(AImage);
  finally
    AImage.Free;
  end;
end;

procedure TcxCustomImageList.AddImages(AImages: TCustomImageList);
begin
  if AImages <> nil then
    CopyImages(AImages);
end;

procedure TcxCustomImageList.AddImagesFromResZipStream(AInstance: THandle; const AResourceName: string;
  AResType: PChar);
var
  AResourceStream: TResourceStream;
begin
  AResourceStream := TResourceStream.Create(AInstance, AResourceName, AResType);
  try
    AddImagesFromZipStream(AResourceStream)
  finally
    AResourceStream.Free;
  end;
end;

procedure TcxCustomImageList.AddImagesFromZipStream(AStream: TStream);
var
  AZipData: TdxZIPStreamReader;
  AImageStream: TMemoryStream;
  I: Integer;
  AImage: TdxSmartImage;
begin
  AZipData := TdxZIPStreamReader.Create(AStream);
  try
    for I := 0 to AZipData.Files.Count - 1 do
    begin
      AImageStream := TMemoryStream.Create;
      try
        AZipData.Extract(AZipData.Files[I], AImageStream);
        AImage := TdxSmartImage.Create;
        try
          AImageStream.Position := 0;
          AImage.LoadFromStream(AImageStream);
          AddCore(AImage, nil, clNone, '', string(AZipData.Files[I].Name));
        finally
          AImage.Free;
        end;
      finally
        AImageStream.Free;
      end;
    end;
  finally
    AZipData.Free;
  end;
end;

procedure TcxCustomImageList.CopyImages(AImages: TCustomImageList; AStartIndex, AEndIndex: Integer);

  procedure InternalCopy(AcxImages: TcxCustomImageList);
  begin
    if AEndIndex < 0 then
      AEndIndex := AcxImages.Count - 1
    else
      AEndIndex := Min(AcxImages.Count - 1, AEndIndex);
    InternalCopyImageInfos(AcxImages, AStartIndex, AEndIndex);
  end;

var
  AcxImages: TcxCustomImageList;
begin
  BeginUpdate;
  try
    if AImages is TcxCustomImageList then
      InternalCopy(TcxCustomImageList(AImages))
    else
    begin
      AcxImages := TcxCustomImageList.Create(nil);
      try
        AcxImages.Assign(AImages);
        InternalCopy(AcxImages);
      finally
        AcxImages.Free;
      end;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.Clear;
begin
  Delete(-1);
end;

procedure TcxCustomImageList.Insert(AIndex: Integer; AImage: TGraphic; AMask: TBitmap);
var
  I, ACurIndex: Integer;
begin
  if InRange(AIndex, 0, Count) then
  begin
    BeginUpdate;
    try
      ACurIndex := Add(AImage, AMask);
      for I := 0 to GetImageCount(AImage, Width, Height) - 1 do
        Move(ACurIndex + I, AIndex + I);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcxCustomImageList.InsertIcon(AIndex: Integer; AIcon: TIcon);
begin
  if InRange(AIndex, 0, Count) then
    Move(AddIcon(AIcon), AIndex);
end;

procedure TcxCustomImageList.InsertMasked(AIndex: Integer; AImage: TGraphic; AMaskColor: TColor);
var
  I, ACurIndex: Integer;
begin
  if InRange(AIndex, 0, Count) then
  begin
    BeginUpdate;
    try
      ACurIndex := AddMasked(AImage, AMaskColor);
      for I := 0 to GetImageCount(AImage, Width, Height) - 1 do
        Move(ACurIndex + I, AIndex + I);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcxCustomImageList.Replace(AIndex: Integer; AImage: TGraphic; AMask: TBitmap);
begin
  BeginUpdate;
  try
    Delete(AIndex);
    Insert(AIndex, AImage, AMask);
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.ReplaceIcon(AIndex: Integer; AIcon: TIcon);
begin
  BeginUpdate;
  try
    Delete(AIndex);
    InsertIcon(AIndex, AIcon);
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.ReplaceMasked(AIndex: Integer; AImage: TGraphic; AMaskColor: TColor);
begin
  BeginUpdate;
  try
    Delete(AIndex);
    InsertMasked(AIndex, AImage, AMaskColor);
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.DrawOverlay(Canvas: TCanvas; X, Y: Integer;
  ImageIndex: Integer; Overlay: TOverlay; Enabled: Boolean = True);
begin
  DrawOverlay(Canvas, X, Y, ImageIndex, Overlay, dsNormal, itImage, Enabled);
end;

procedure TcxCustomImageList.DrawOverlay(Canvas: TCanvas; X, Y: Integer;
  ImageIndex: Integer; Overlay: TOverlay; ADrawingStyle: TDrawingStyle;
  AImageType: TImageType; Enabled: Boolean = True);
var
  Index: Cardinal;
begin
  if HandleAllocated then
  begin
    Index := IndexToOverlayMask(Overlay + 1);
    inherited DoDraw(ImageIndex, Canvas, X, Y, cxGetImageListStyle(ADrawingStyle, AImageType) or ILD_OVERLAYMASK and Index, Enabled);
  end;
end;

function TcxCustomImageList.LoadImage(AInstance: THandle; const AResourceName: string;
  AMaskColor: TColor = clDefault; AWidth: Integer = 0; AFlags: TLoadResources = []): Boolean;
const
  FlagMap: array [TLoadResource] of DWORD = (
    LR_DEFAULTCOLOR, LR_DEFAULTSIZE, LR_LOADFROMFILE, LR_LOADMAP3DCOLORS, LR_LOADTRANSPARENT, LR_MONOCHROME
  );
var
  I: TLoadResource;
  ALoadFlags: DWORD;
  AHandle: HImageList;
  ARGBColor: DWORD;
  AImageList: TImageList;
begin
  if AMaskColor = clNone then
    ARGBColor := CLR_NONE
  else if AMaskColor = clDefault then
    ARGBColor := CLR_DEFAULT
  else
    ARGBColor := ColorToRGB(AMaskColor);

  ALoadFlags := LR_CREATEDIBSECTION;
  for I := Low(TLoadResource) to High(TLoadResource) do
  begin
    if I in AFlags then
      ALoadFlags := ALoadFlags or FlagMap[I];
  end;

  AHandle := ImageList_LoadImage(AInstance, PChar(AResourceName), AWidth, AllocBy, ARGBColor, IMAGE_BITMAP, ALoadFlags);
  Result := AHandle <> 0;
  if Result then
  begin
    AImageList := TImageList.Create(Self);
    try
      AImageList.Handle := AHandle;
      CopyImages(AImageList);
    finally
      AImageList.Free;
    end;
  end;
end;

function TcxCustomImageList.FileLoad(AResType: TResType; const AName: string; AMaskColor: TColor): Boolean;
begin
  BeginUpdate;
  try
    Result := inherited FileLoad(AResType, AName, AMaskColor);
    SynchronizeImageInfo;
  finally
    EndUpdate;
  end;
end;

function TcxCustomImageList.GetResource(AResType: TResType; const AName: string;
  AWidth: Integer; ALoadFlags: TLoadResources; AMaskColor: TColor): Boolean;
begin
  BeginUpdate;
  try
    Result := inherited GetResource(AResType, AName, AWidth, ALoadFlags, AMaskColor);
    SynchronizeImageInfo;
  finally
    EndUpdate;
  end;
end;

function TcxCustomImageList.GetSourceFileName(AIndex: Integer): string;
var
  AInfo: TcxImageInfo;
begin
  Result := '';
  if InRange(AIndex, 0, Count - 1) then
  begin
    AInfo := GetImageInfo(AIndex);
    if Assigned(AInfo) then
      Result := AInfo.FileName;
  end;
end;

function TcxCustomImageList.GetInstRes(AInstance: THandle; AResType: TResType; const AName: string;
  AWidth: Integer; ALoadFlags: TLoadResources; AMaskColor: TColor): Boolean;
begin
  BeginUpdate;
  try
    Result := inherited GetInstRes(AInstance, AResType, AName, AWidth, ALoadFlags, AMaskColor);
    SynchronizeImageInfo;
  finally
    EndUpdate;
  end;
end;

function TcxCustomImageList.GetInstRes(AInstance: THandle; AResType: TResType; AResID: DWORD;
  AWidth: Integer; ALoadFlags: TLoadResources; AMaskColor: TColor): Boolean;
begin
  BeginUpdate;
  try
    Result := inherited GetInstRes(AInstance, AResType, AResID, AWidth, ALoadFlags, AMaskColor);
    SynchronizeImageInfo;
  finally
    EndUpdate;
  end;
end;

function TcxCustomImageList.GetKeywords(AIndex: Integer): string;
var
  AInfo: TcxImageInfo;
begin
  Result := '';
  if InRange(AIndex, 0, Count - 1) then
  begin
    AInfo := GetImageInfo(AIndex);
    if Assigned(AInfo) then
      Result := AInfo.Keywords;
  end;
end;

function TcxCustomImageList.ResourceLoad(AResType: TResType; const AName: string; AMaskColor: TColor): Boolean;
begin
  BeginUpdate;
  try
    Result := inherited ResourceLoad(AResType, AName, AMaskColor);
    SynchronizeImageInfo;
  finally
    EndUpdate;
  end;
end;

function TcxCustomImageList.ResInstLoad(AInstance: THandle; AResType: TResType;
  const AName: string; AMaskColor: TColor): Boolean;
begin
  BeginUpdate;
  try
    Result := inherited ResInstLoad(AInstance, AResType, AName, AMaskColor);
    SynchronizeImageInfo;
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.LoadFromFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TcxCustomImageList.LoadFromResource(AInstance: THandle; const AResourceName: string; AResourceType: PChar);
var
  AStream: TStream;
begin
  AStream := TResourceStream.Create(AInstance, AResourceName, AResourceType);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TcxCustomImageList.LoadFromStream(AStream: TStream);
var
  ARasterData: TMemoryStream;
  AHeight: Integer;
  AReader: TReader;
  AWidth: Integer;
begin
  BeginUpdate;
  try
    if ReadIntegerFunc(AStream) <> DXILSignature then
      raise EcxUnsupportedImageListStreamFormat.Create;
    if ReadIntegerFunc(AStream) <> DXILVersion then
      raise EcxUnsupportedImageListStreamFormat.Create;

    Clear;
    FFormatVersion := DXILVersion;
    AWidth := ReadIntegerFunc(AStream);
    AHeight := ReadIntegerFunc(AStream);
    SetSize(AWidth, AHeight);

    BkColor := ReadIntegerFunc(AStream);
    BlendColor := ReadIntegerFunc(AStream);
    ColorDepth := TColorDepth(ReadIntegerFunc(AStream));

    if ReadBooleanFunc(AStream) then
    begin
      ARasterData := TMemoryStream.Create;
      try
        ARasterData.Size := ReadIntegerFunc(AStream);
        AStream.ReadBuffer(ARasterData.Memory^, ARasterData.Size);
        ReadData(ARasterData);
      finally
        ARasterData.Free;
      end;
    end;

    AReader := TReader.Create(AStream, StreamFilerBufferSize);
    try
      ReadImageInfo(AReader);
    finally
      AReader.Free;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.SaveToFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TcxCustomImageList.SaveToStream(AStream: TStream);
var
  ARasterData: TMemoryStream;
  AWriter: TWriter;
begin
  WriteIntegerProc(AStream, DXILSignature);
  WriteIntegerProc(AStream, DXILVersion);

  WriteIntegerProc(AStream, Width);
  WriteIntegerProc(AStream, Height);
  WriteIntegerProc(AStream, BkColor);
  WriteIntegerProc(AStream, BlendColor);
  WriteIntegerProc(AStream, Ord(ColorDepth));

  WriteBooleanProc(AStream, True);
  ARasterData := TMemoryStream.Create;
  try
    WriteData(ARasterData);
    WriteIntegerProc(AStream, ARasterData.Size);
    AStream.WriteBuffer(ARasterData.Memory^, ARasterData.Size);
  finally
    ARasterData.Free;
  end;

  AWriter := TWriter.Create(AStream, StreamFilerBufferSize);
  try
    WriteImageInfo(AWriter);
  finally
    AWriter.Free;
  end;
end;

procedure TcxCustomImageList.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TcxCustomImageList.CancelUpdate;
begin
  Dec(FLockCount);
end;

procedure TcxCustomImageList.EndUpdate;
begin
  Dec(FLockCount);
  if FLockCount = 0 then
    Change;
end;

procedure TcxCustomImageList.Draw(ACanvas: TCanvas; const ARect: TRect; AIndex: Integer;
  AStretch: Boolean = True; ASmoothResize: Boolean = False; AEnabled: Boolean = True);
begin
  DoDrawEx(AIndex, ACanvas, ARect, cxGetImageListStyle(DrawingStyle, ImageType), AStretch, ASmoothResize, AEnabled);
end;

procedure TcxCustomImageList.GetImageInfo(AIndex: Integer; AImage, AMask: TBitmap; APalette: IdxColorPalette = nil);
var
  AIsAlphaUsed: TdxDefaultBoolean;
begin
  AIsAlphaUsed := bFalse;
  GetImageInfoCore(AIndex, AImage, AMask, APalette, AIsAlphaUsed);
end;

procedure TcxCustomImageList.GetImage(AIndex: Integer; AImage: TBitmap);
begin
  GetImageInfo(AIndex, AImage, nil);
end;

procedure TcxCustomImageList.GetImage(AIndex: Integer; AImage: TdxSmartImage);
var
  ABitmap: TBitmap;
  AInfo: TcxImageInfo;
begin
  if InRange(AIndex, 0, Count - 1) then
  begin
    AInfo := GetImageInfo(AIndex);
    if TcxImageInfoHelper.GetPixelFormat(AInfo.Image) = pf32bit then
      AImage.Assign(AInfo.Image)
    else
    begin
      ABitmap := TcxBitmap.Create;
      try
        GetImageInfo(AIndex, ABitmap, nil);
        AImage.Assign(ABitmap);
      finally
        ABitmap.Free;
      end;
    end;
  end;
end;

procedure TcxCustomImageList.GetMask(AIndex: Integer; AMask: TBitmap);
begin
  GetImageInfo(AIndex, nil, AMask);
end;

class procedure TcxCustomImageList.GetImageInfo(AImages: TCustomImageList;
  AIndex: Integer; AImage, AMask: TBitmap; APalette: IdxColorPalette = nil);
var
  AIsAlphaUsed: TdxDefaultBoolean;
begin
  AIsAlphaUsed := bFalse;
  GetImageInfoCore(AImages, AIndex, AImage, AMask, APalette, AIsAlphaUsed);
end;

class procedure TcxCustomImageList.GetImageInfo(AHandle: HIMAGELIST; AIndex: Integer; AImage, AMask: TBitmap);

  procedure GetBitmap(ASrcHandle: HBITMAP; ADestBitmap: TBitmap; ACopyAll, ASmoothStretch: Boolean; const ARect: TRect);
  var
    ASrcBitmap: TBitmap;
  begin
    if ACopyAll then
      ADestBitmap.Handle := cxCopyImage(ASrcHandle)
    else
    begin
      ASrcBitmap := TBitmap.Create;
      try
        ASrcBitmap.Handle := cxCopyImage(ASrcHandle);
        CheckImageSize(ADestBitmap, cxRectWidth(ARect), cxRectHeight(ARect));
        cxStretchGraphic(ADestBitmap, ASrcBitmap, cxGetImageClientRect(ADestBitmap), ARect, ASmoothStretch);
        if dxIsAlphaUsed(ADestBitmap) then
          TdxFadingHelper.CorrectAlphaChannel(ADestBitmap);
      finally
        ASrcBitmap.Free;
      end;
    end;
  end;

var
  ACopyAll: Boolean;
  AImageInfo: TImageInfo;
begin
  ACopyAll := AIndex = -1;
  if ACopyAll then
    AIndex := 0;
  if ImageList_GetImageInfo(AHandle, AIndex, AImageInfo) then
    if AImage <> nil then
      GetBitmap(AImageInfo.hbmImage, AImage, ACopyAll, AImageInfo.hbmMask = 0, AImageInfo.rcImage);
    if AMask <> nil then
    begin
      if AImageInfo.hbmMask <> 0 then
        GetBitmap(AImageInfo.hbmMask, AMask, ACopyAll, False, AImageInfo.rcImage)
      else
        cxClearBitmap(AMask);
    end;
end;

class function TcxCustomImageList.GetPixelFormat(AHandle: HIMAGELIST): Integer;
var
  ABitmapInfo: Windows.TBitmap;
  AImageInfo: TImageInfo;
begin
  Result := 0;
  if ImageList_GetImageInfo(AHandle, 0, AImageInfo) then
  begin
    cxGetBitmapData(AImageInfo.hbmImage, ABitmapInfo);
    Result := ABitmapInfo.bmBitsPixel;
  end;
end;

class function TcxCustomImageList.IsEquals(AImages1, AImages2: TCustomImageList): Boolean;
var
  AStream1: TMemoryStream;
  AStream2: TMemoryStream;
begin
  if AImages1.Count <> AImages2.Count then
    Exit(False);
  if AImages1.Count = 0 then
    Exit(True);
  if (AImages1 is TcxCustomImageList) and (AImages2 is TcxCustomImageList) then
    Exit(AImages1.Equals(AImages2));

  AStream1 := TMemoryStream.Create;
  AStream2 := TMemoryStream.Create;
  try
    AStream1.WriteComponent(AImages1);
    AStream2.WriteComponent(AImages2);
    Result := (AStream1.Size = AStream2.Size) and CompareMem(AStream1.Memory, AStream2.Memory, AStream1.Size);
  finally
    AStream2.Free;
    AStream1.Free;
  end;
end;

procedure TcxCustomImageList.Resize(const ASize: TSize);
var
  I: Integer;
begin
  BeginUpdate;
  try
    Inc(FSynchronizationLockCount);
    try
      for I := 0 to FImages.Count - 1 do
        GetImageInfo(I).Resize(ASize);
      inherited SetSize(ASize.cx, ASize.cy);
      SynchronizeHandle;
    finally
      Dec(FSynchronizationLockCount);
    end;
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.SetSize(AWidth, AHeight: Integer);
begin
  AWidth := Max(AWidth, 1);
  AHeight := Max(AHeight, 1);
  if (AWidth <> Width) or (AHeight <> Height) then
  begin
    BeginUpdate;
    try
      Clear;
      inherited SetSize(AWidth, AHeight);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcxCustomImageList.SetSize(const ASize: TSize);
begin
  SetSize(ASize.cx, ASize.cy);
end;

function TcxCustomImageList.ChangeLocked: Boolean;
begin
  Result := FLockCount > 0;
end;

procedure TcxCustomImageList.Change;
begin
  if not ChangeLocked and ([csLoading, csReading, csDestroying] * ComponentState = []) then
  begin
    TdxImageListPaintCache.InvalidateImageList(Self);
    if Count <> FImages.Count then
      SynchronizeImageInfo
    else
      inherited Change;
  end;
end;

procedure TcxCustomImageList.DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean = True);
begin
  DoDrawEx(Index, Canvas, cxRectBounds(X, Y, Width, Height), Style, False, False, Enabled);
end;

procedure TcxCustomImageList.DoDrawEx(AIndex: Integer; ACanvas: TCanvas;
  const ARect: TRect; AStyle: Cardinal; AStretch, ASmoothResize, AEnabled: Boolean);
var
  AGlyphRect: TRect;
  ADrawBitmap: TBitmap;
begin
  if (cxRectWidth(ARect) = Width) and (cxRectHeight(ARect) = Height) then
    AStretch := False;
  if AStretch then
    AGlyphRect := ARect
  else
    AGlyphRect := cxRectCenter(ARect, Width, Height);

  if AlphaBlending then
    TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, AGlyphRect, ARect, nil, Self, AIndex, EnabledImageDrawModeMap[AEnabled], ASmoothResize)
  else
    if AStretch then
    begin
      ADrawBitmap := cxCreateBitmap(Width, Height, pfDevice);
      try
        inherited DoDraw(AIndex, ADrawBitmap.Canvas, 0, 0, AStyle, AEnabled);
        TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, AGlyphRect, ARect, ADrawBitmap, nil, 0, EnabledImageDrawModeMap[AEnabled], ASmoothResize);
      finally
        ADrawBitmap.Free;
      end;
    end
    else
      inherited DoDraw(AIndex, ACanvas, AGlyphRect.Left, AGlyphRect.Top, AStyle, AEnabled);
end;

procedure TcxCustomImageList.Initialize;
begin
  BeginUpdate;
  try
    inherited Initialize;
    FImages := TcxImageInfoCollection.Create(Self);
    FAlphaBlending := True;
    ColorDepth := cd32Bit;
  finally
    CancelUpdate;
  end;
end;

procedure TcxCustomImageList.Finalize;
begin
  FreeAndNil(FImages);
end;

procedure TcxCustomImageList.DefineProperties(Filer: TFiler);

  function NeedWriteImageInfo: Boolean;
  begin
    if Filer.Ancestor is TcxCustomImageList then
      Result := not Equals(Filer.Ancestor)
    else
      Result := Count > 0;
  end;

  function NeedWriteDesignInfo: Boolean;
  begin
    Result := (Filer.Ancestor = nil) or not (Filer.Ancestor is TCustomImageList) or
      (TCustomImageList(Filer.Ancestor).DesignInfo <> DesignInfo);
  end;

  function NeedWriteRasterCopyOfImageList: Boolean;
  begin
    Result := TcxImageInfoCollection(FImages).GetVectorImageCount > MulDiv(Count, 1, 3);
  end;

begin
  Filer.DefineProperty('FormatVersion', ReadFormatVersion, WriteFormatVersion, True);

  if csReading in ComponentState then
  begin
    inherited DefineProperties(Filer);
    if FFormatVersion = 0 then
      SynchronizeImageInfo;
  end
  else
    if NeedWriteRasterCopyOfImageList then
      inherited DefineProperties(Filer); // just for performance purposes

  Filer.DefineProperty('DesignInfo', ReadDesignInfo, WriteDesignInfo, NeedWriteDesignInfo);
  Filer.DefineProperty('ImageInfo', ReadImageInfo, WriteImageInfo, NeedWriteImageInfo);
end;

procedure TcxCustomImageList.Dormant;
var
  I: Integer;
begin
  for I := 0 to FImages.Count - 1 do
    DormantImage(I);
end;

procedure TcxCustomImageList.GetImageInfoCore(AIndex: Integer;
  AImage, AMask: TBitmap; APalette: IdxColorPalette; var AIsAlphaUsed: TdxDefaultBoolean);

  procedure GetBitmap(ADestBitmap: TBitmap; ASourceImage: TGraphic; ASmoothStretch: Boolean);
  begin
    CheckImageSize(ADestBitmap, Width, Height);
    cxStretchGraphic(ADestBitmap, ASourceImage, ASmoothStretch, APalette);
  end;

var
  AInfo: TcxImageInfo;
begin
  if AIndex = -1 then
    GetImageInfo(Handle, AIndex, AImage, AMask)
  else
    if InRange(AIndex, 0, Count - 1) then
    begin
      AInfo := GetImageInfo(AIndex);
      if (TcxImageInfoHelper.GetPixelFormat(AInfo.Image) = pf32bit) or IsWin9X then
      begin
        if AImage <> nil then
        begin
          GetBitmap(AImage, AInfo.Image, AInfo.Mask.Empty);
          if AIsAlphaUsed = bDefault then
            AIsAlphaUsed := dxBooleanToDefaultBoolean(AInfo.IsAlphaUsed);
        end;
        if AMask <> nil then
        begin
          if AInfo.Mask.Empty then
          begin
            if AInfo.FInternalMask.Empty then
            begin
              AInfo.FInternalMask.SetSize(Width, Height);
              GetImageInfo(Handle, AIndex, nil, AInfo.FInternalMask);
            end;
            GetBitmap(AMask, AInfo.FInternalMask, False);
          end
          else
            GetBitmap(AMask, AInfo.Mask, False);
        end;
      end
      else
        GetImageInfo(Handle, AIndex, AImage, AMask);

      if AInfo.HasNativeHandle then
        AInfo.Dormant;
    end;
end;

class procedure TcxCustomImageList.GetImageInfoCore(
  AImages: TCustomImageList; AIndex: Integer; AImage, AMask: TBitmap;
  APalette: IdxColorPalette; var AIsAlphaUsed: TdxDefaultBoolean);
begin
  if AImages is TcxCustomImageList then
    TcxCustomImageList(AImages).GetImageInfoCore(AIndex, AImage, AMask, APalette, AIsAlphaUsed)
  else
    TcxCustomImageList.GetImageInfo(AImages.Handle, AIndex, AImage, AMask);
end;

function TcxCustomImageList.AddCore(AImage: TGraphic; AMask: TBitmap; AMaskColor: TColor; const AKeywords, AFileName: string): Integer;

  function AddToImageList(AImageHandle: HBITMAP; AMask: TBitmap; AMaskColor: TColor): Integer;
  var
    AMaskBits: TBytes;
    AMaskHandle: HBITMAP;
  begin
    if IsGlyphAssigned(AMask) then
      Result := ImageList_Add(Handle, AImageHandle, AMask.Handle)
    else
      if AMaskColor <> clNone then
        Result := ImageList_AddMasked(Handle, AImageHandle, ColorToRGB(AMaskColor))
      else
      begin
        SetLength(AMaskBits, AImage.Width * AImage.Height);
        AMaskHandle := CreateBitmap(Width, Height, 1, 1, AMaskBits);
        Result := ImageList_Add(Handle, AImageHandle, AMaskHandle);
        DeleteObject(AMaskHandle);
      end;

    if Result >= Count then
      Result := -1;
  end;

  function ConvertToBitmap(AImage: TGraphic): TBitmap;
  begin
    if Supports(AImage, IdxVectorImage) then
    begin
      Result := TcxBitmap32.CreateSize(Width, Height, True);
      Result.Canvas.StretchDraw(cxGetImageClientRect(Result), AImage);
    end
    else
      Result := cxGetAsBitmap(AImage);
  end;

var
  ABitmap: TBitmap;
begin
  if AImage <> nil then
  begin
    ABitmap := ConvertToBitmap(AImage);
    try
      Result := AddToImageList(ABitmap.Handle, AMask, AMaskColor);
    finally
      ABitmap.Free;
    end;
  end
  else
    Result := AddToImageList(0, AMask, AMaskColor);

  if not IsSynchronizationLocked and (Result <> -1) then
    AddToInternalCollection(AImage, AMask, AMaskColor, AKeywords, AFileName);
  Change;
end;

function TcxCustomImageList.AddImageInfo(AImageInfo: TcxImageInfo): Integer;
begin
  Result := AddCore(AImageInfo.Image, AImageInfo.Mask, AImageInfo.MaskColor, AImageInfo.Keywords, AImageInfo.FileName);
end;

function TcxCustomImageList.CanSplitImage(AImage: TGraphic): Boolean;
begin
  Result := ((AImage.Width <> Width) or (AImage.Height <> Height)) and
    (AImage.Width mod Width + AImage.Height mod Height = 0) and not Supports(AImage, IdxVectorImage);
end;

procedure TcxCustomImageList.ConvertTo32bit;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Count - 1 do
      GetImageInfo(I).ConvertTo32Bit;
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.InternalCopyImageInfos(AImageList: TcxCustomImageList; AStartIndex, AEndIndex: Integer);
var
  I: Integer;
begin
  for I := Max(AStartIndex, 0) to AEndIndex do
    AddImageInfo(TcxImageInfoItem(AImageList.FImages.Items[I]).ImageInfo);
end;

procedure TcxCustomImageList.InternalCopyImages(AImageList: TCustomImageList; AStartIndex, AEndIndex: Integer);
var
  I: Integer;
  AImage, AMask: TBitmap;
begin
  AImage := cxCreateBitmap(Width, Height, pf32bit);
  AMask := cxCreateBitmap(Width, Height, pf1bit);
  try
    for I := Max(AStartIndex, 0) to AEndIndex do
    begin
      GetImageInfo(AImageList.Handle, I, AImage, AMask);
      Add(AImage, AMask);
    end;
  finally
    AImage.Free;
    AMask.Free;
  end;
end;

function TcxCustomImageList.GetImageInfo(AIndex: Integer): TcxImageInfo;
begin
  Result := TcxImageInfoItem(FImages.Items[AIndex]).ImageInfo;
end;

function TcxCustomImageList.HasRasterImages: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FImages.Count - 1 do
  begin
    if not Supports(GetImageInfo(I).Image, IdxVectorImage) then
      Exit(True);
  end;
end;

function TcxCustomImageList.GetCompressData: Boolean;
begin
  Result := TcxImageInfoCollection(FImages).CompressData;
end;

procedure TcxCustomImageList.SetCompressData(Value: Boolean);
begin
  TcxImageInfoCollection(FImages).CompressData := Value;
end;

function TcxCustomImageList.GetHandle: HImageList;
begin
  Result := inherited Handle;
end;

procedure TcxCustomImageList.SetHandle(Value: HImageList);
var
  AImageList: TCustomImageList;
begin
  AImageList := TCustomImageList.Create(Self);
  try
    AImageList.Handle := Value;
    Assign(AImageList);
    ImageList_Destroy(Value);
  finally
    AImageList.Free;
  end;
end;

procedure TcxCustomImageList.ReadFormatVersion(AReader: TReader);
begin
  FFormatVersion := AReader.ReadInteger;
end;

procedure TcxCustomImageList.WriteFormatVersion(AWriter: TWriter);
begin
  FFormatVersion := DXILVersion;
  AWriter.WriteInteger(FFormatVersion);
end;

procedure TcxCustomImageList.ReadImageInfo(AReader: TReader);
begin
  FImages.Clear;
  AReader.ReadValue;
  AReader.ReadCollection(FImages);
  if FImages.Count <> Count then
    SynchronizeHandle;
end;

procedure TcxCustomImageList.WriteImageInfo(AWriter: TWriter);
begin
  AWriter.WriteCollection(FImages);
end;

procedure TcxCustomImageList.ReadDesignInfo(AReader: TReader);
begin
  DesignInfo := AReader.ReadInteger;
end;

procedure TcxCustomImageList.WriteDesignInfo(AWriter: TWriter);
begin
  AWriter.WriteInteger(DesignInfo);
end;

function TcxCustomImageList.IsSynchronizationLocked: Boolean;
begin
  Result := FSynchronizationLockCount > 0;
end;

procedure TcxCustomImageList.SynchronizeImageInfo;
var
  I: Integer;
  AImage, AMask: TBitmap;
begin
  FImages.BeginUpdate;
  try
    FImages.Clear;
    if Count > 0 then
    begin
      AImage := cxCreateBitmap(Width, Height, pf32bit);
      AMask := cxCreateBitmap(Width, Height, pf1bit);
      try
        for I := 0 to Count - 1 do
        begin
          GetImageInfo(Handle, I, AImage, AMask);
          TcxImageInfoCollection(FImages).Add(AImage, AMask, clNone, '', '');
        end;
      finally
        AMask.Free;
        AImage.Free;
      end;
    end;
  finally
    FImages.EndUpdate;
  end;
end;

procedure TcxCustomImageList.SynchronizeHandle;
var
  I: Integer;
  AImageInfoItem: TcxImageInfoItem;
begin
  BeginUpdate;
  try
    Inc(FSynchronizationLockCount);
    try
      Clear;
      I := 0;
      while I < FImages.Count do
      begin
        AImageInfoItem := TcxImageInfoItem(FImages.Items[I]);
        if AddImageInfo(AImageInfoItem.ImageInfo) <> -1 then
        begin
          DormantImage(I);
          Inc(I);
        end
        else
          FImages.Delete(I);
      end;
    finally
      Dec(FSynchronizationLockCount);
    end;
  finally
    EndUpdate;
  end;
end;

procedure TcxCustomImageList.AddToInternalCollection(AImage: TGraphic;
  AMask: TBitmap; AMaskColor: TColor; const AKeywords, AFileName: string);
var
  AColCount: Integer;
  AColIndex: Integer;
  ADestBitmap: TcxBitmap;
  ADestMask: TcxBitmap;
  ARowCount: Integer;
  ARowIndex: Integer;
  ASourceRect: TRect;
begin
  if CanSplitImage(AImage) then
  begin
    AColCount := AImage.Width div Width;
    ARowCount := AImage.Height div Height;

    ADestBitmap := TcxBitmap.CreateSize(Width, Height, TcxImageInfoHelper.GetPixelFormat(AImage));
    if IsGlyphAssigned(AMask) then
      ADestMask := TcxBitmap.CreateSize(Width, Height, AMask.PixelFormat)
    else
      ADestMask := nil;
    try
      for ARowIndex := 0 to ARowCount - 1 do
        for AColIndex := 0 to AColCount - 1 do
        begin
          cxClearBitmap(ADestBitmap);
          ASourceRect := Rect(AColIndex * Width, ARowIndex * Height, (AColIndex + 1) * Width, (ARowIndex + 1) * Height);
          TcxImageInfoHelper.CopyRect(ADestBitmap, ADestBitmap.ClientRect, AImage, ASourceRect);
          if IsGlyphAssigned(AMask) then
            ADestMask.Canvas.CopyRect(ADestMask.ClientRect, AMask.Canvas, ASourceRect);
          TcxImageInfoCollection(FImages).Add(ADestBitmap, ADestMask, AMaskColor, AKeywords, AFileName);
        end;
    finally
      ADestMask.Free;
      ADestBitmap.Free;
    end;
  end
  else
    TcxImageInfoCollection(FImages).Add(AImage, AMask, AMaskColor, AKeywords, AFileName);
end;

class procedure TcxCustomImageList.CheckImageSize(AImage: TBitmap; AWidth, AHeight: Integer);
begin
  if (AImage.Width = 0) or (AImage.Height = 0) then
    AImage.SetSize(AWidth, AHeight);
end;

procedure TcxCustomImageList.DormantImage(AIndex: Integer);
begin
  GetImageInfo(AIndex).Dormant;
end;

function TcxCustomImageList.GetImageCount(AImage: TGraphic; AWidth, AHeight: Integer): Integer;
begin
  if CanSplitImage(AImage) then
    Result := (AImage.Width div AWidth) * (AImage.Height div AHeight)
  else
    Result := 1;
end;

function TcxCustomImageList.GetHeight: Integer;
begin
  Result := inherited Height;
end;

procedure TcxCustomImageList.SetHeight(AValue: Integer);
begin
  SetSize(Width, AValue);
end;

function TcxCustomImageList.GetWidth: Integer;
begin
  Result := inherited Width;
end;

procedure TcxCustomImageList.SetWidth(AValue: Integer);
begin
  SetSize(AValue, Height);
end;

end.
