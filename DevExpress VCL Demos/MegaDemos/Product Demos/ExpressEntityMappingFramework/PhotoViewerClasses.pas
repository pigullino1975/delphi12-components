unit PhotoViewerClasses;

interface

uses
  Graphics, dxGDIPlusClasses, dxGDIPlusAPI, uEntityEditor, dxEMF.Attributes, dxEMF.Types, dxEMF.Linq, dxEMF.Linq.Expressions;

type
  IAlbumExpression = interface(IdxEntityInfo)
  ['{466BCD8A-361B-498E-9909-9BAA0359B0BA}']
    function Caption: TdxLinqExpression;
    function Comment: TdxLinqExpression;
    function Content: TdxLinqExpression;
    function Date: TdxLinqExpression;
    function ID: TdxLinqExpression;
  end;

  IPhotoViewerContext = interface(IdxDataContext)
  ['{A95EEAB8-1E79-4BD8-86BE-4A8AD91EE269}']
    function Album: IAlbumExpression;
  end;

  TAlbumContent = class;
  TPhoto = class;

  { TAlbum }

  [Entity]
  [Discriminator(2)]
  [Inheritance(TdxMapInheritanceType.OwnTable)]
  [Table('Albums')]
  TAlbum = class(TPhotoViewerEntity)
  private
    FComment: string;
    [Association('Album_AlbumContent_Album'), Aggregated]
    FContent: IdxEMFCollection<TAlbumContent>;
    procedure SetComment(const AValue: string);
  public
    constructor Create; override;

    class function GetEntityCaption: string; override;
    class function GetEditorClass: TEntityEditorClass; override;

    function Description: string;
    procedure AddPhoto(APhoto: TPhoto);
    procedure RemovePhoto(APhoto: TPhoto);

    [Column('Comment'), DbType('nvarchar(100)'), Size(100), Nullable]
    property Comment: string read FComment write SetComment;
    property Content: IdxEMFCollection<TAlbumContent> read FContent write FContent;
  end;

  { TPhoto }

  [Entity]
  [Discriminator(3)]
  [Inheritance(TdxMapInheritanceType.OwnTable)]
  [Table('Photos')]
  TPhoto = class(TPhotoViewerEntity)
  private
    FImage: TdxSmartImage;
    FRating: Integer;
    [Association('Photo_AlbumContent_Photo'), Aggregated]
    FAlbumContent_Photo: IdxEMFCollection<TAlbumContent>;
    function GetSize: Int64;
    procedure SetImage(AValue: TdxSmartImage);
  public
    constructor Create; override;
    destructor Destroy; override;

    class function GetEntityCaption: string; override;
    class function GetEditorClass: TEntityEditorClass; override;

    function Description: string;

    property AlbumContent_Photo: IdxEMFCollection<TAlbumContent> read FAlbumContent_Photo;
    [Column('Image'), DbType('image'), Nullable]
    property Image: TdxSmartImage read FImage write SetImage;
    [Column('Rating'), DbType('int'), Nullable]
    property Rating: Integer read FRating write FRating;
  end;

  { AlbumContent }

  [Entity]
  [Table('AlbumContent')]
  [Indexes('Photo')]
  [Indexes('Album')]
  TAlbumContent = class
  private
    FAlbum: TAlbum;
    [Column('ID'), DbType('INTEGER'), Generator(TdxGeneratorType.Identity), Key, Nullable]
    FID: Integer;
    FPhoto: TPhoto;
    procedure SetAlbum(AValue: TAlbum);
    procedure SetPhoto(AValue: TPhoto);
  public
    [Association('Album_AlbumContent_Album'), Column('Album'), DbType('int')]
    property Album: TAlbum read FAlbum write SetAlbum;
    property ID: Integer read FID;
    [Association('Photo_AlbumContent_Photo'), Column('Photo'), DbType('int')]
    property Photo: TPhoto read FPhoto write SetPhoto;
  end;

  { TCustomFilter }

  [Entity]
  [Discriminator(1)]
  [Inheritance(TdxMapInheritanceType.OwnTable)]
  [Table('CustomFilters')]
  TCustomFilter = class(TPhotoViewerEntity)
  private
    FImage: TdxSmartImage;
    procedure SetImage(AValue: TdxSmartImage);
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Apply(ASource: TdxSmartImage; ADestination: TPicture); overload; virtual;
    procedure Apply(ASource: TdxSmartImage; ADestination: TdxSmartImage); overload;

    [Column('Image'), DbType('image'), Nullable]
    property Image: TdxSmartImage read FImage write SetImage;
  end;

  { TEffect }

  [Entity]
  [Discriminator(5)]
  [Inheritance(TdxMapInheritanceType.OwnTable)]
  [Table('Effects')]
  [Indexes('ID')]
  TEffect = class(TCustomFilter)
  private
    FM00: Single;
    FM01: Single;
    FM02: Single;
    FM03: Single;
    FM04: Single;
    FM10: Single;
    FM11: Single;
    FM12: Single;
    FM13: Single;
    FM14: Single;
    FM20: Single;
    FM21: Single;
    FM22: Single;
    FM23: Single;
    FM24: Single;
    FM30: Single;
    FM31: Single;
    FM32: Single;
    FM33: Single;
    FM34: Single;
    FM40: Single;
    FM41: Single;
    FM42: Single;
    FM43: Single;
    FM44: Single;
  public
    procedure Apply(ASource: TdxSmartImage; ADestination: TPicture); override;
    procedure Assign(const AColorMatrix: TdxGpColorMatrix);

    [Column('M00'), DbType('float'), Nullable]
    property M00: Single read FM00 write FM00;
    [Column('M01'), DbType('float'), Nullable]
    property M01: Single read FM01 write FM01;
    [Column('M02'), DbType('float'), Nullable]
    property M02: Single read FM02 write FM02;
    [Column('M03'), DbType('float'), Nullable]
    property M03: Single read FM03 write FM03;
    [Column('M04'), DbType('float'), Nullable]
    property M04: Single read FM04 write FM04;
    [Column('M10'), DbType('float'), Nullable]
    property M10: Single read FM10 write FM10;
    [Column('M11'), DbType('float'), Nullable]
    property M11: Single read FM11 write FM11;
    [Column('M12'), DbType('float'), Nullable]
    property M12: Single read FM12 write FM12;
    [Column('M13'), DbType('float'), Nullable]
    property M13: Single read FM13 write FM13;
    [Column('M14'), DbType('float'), Nullable]
    property M14: Single read FM14 write FM14;
    [Column('M20'), DbType('float'), Nullable]
    property M20: Single read FM20 write FM20;
    [Column('M21'), DbType('float'), Nullable]
    property M21: Single read FM21 write FM21;
    [Column('M22'), DbType('float'), Nullable]
    property M22: Single read FM22 write FM22;
    [Column('M23'), DbType('float'), Nullable]
    property M23: Single read FM23 write FM23;
    [Column('M24'), DbType('float'), Nullable]
    property M24: Single read FM24 write FM24;
    [Column('M30'), DbType('float'), Nullable]
    property M30: Single read FM30 write FM30;
    [Column('M31'), DbType('float'), Nullable]
    property M31: Single read FM31 write FM31;
    [Column('M32'), DbType('float'), Nullable]
    property M32: Single read FM32 write FM32;
    [Column('M33'), DbType('float'), Nullable]
    property M33: Single read FM33 write FM33;
    [Column('M34'), DbType('float'), Nullable]
    property M34: Single read FM34 write FM34;
    [Column('M40'), DbType('float'), Nullable]
    property M40: Single read FM40 write FM40;
    [Column('M41'), DbType('float'), Nullable]
    property M41: Single read FM41 write FM41;
    [Column('M42'), DbType('float'), Nullable]
    property M42: Single read FM42 write FM42;
    [Column('M43'), DbType('float'), Nullable]
    property M43: Single read FM43 write FM43;
    [Column('M44'), DbType('float'), Nullable]
    property M44: Single read FM44 write FM44;
  end;

  { TFilter }

  [Entity]
  [Discriminator(4)]
  [Inheritance(TdxMapInheritanceType.OwnTable)]
  [Table('Filters')]
  [Indexes('ID')]
  TFilter = class(TCustomFilter)
  private
    FBrightness: Byte;
    FColor: Integer;
    FContrast: Byte;
  private
    function GetB: Byte;
    function GetG: Byte;
    function GetR: Byte;
  public
    class function GetEntityCaption: string; override;
    class function GetEditorClass: TEntityEditorClass; override;

    procedure Apply(ASource: TdxSmartImage; ADestination: TPicture); override;

    [Column('Brightness'), DbType('tinyint'), Nullable]
    property Brightness: Byte read FBrightness write FBrightness;
    [Column('Color'), DbType('int'), Nullable]
    property Color: Integer read FColor write FColor;
    [Column('Contrast'), DbType('tinyint'), Nullable]
    property Contrast: Byte read FContrast write FContrast;

    property R: Byte read GetR;
    property G: Byte read GetG;
    property B: Byte read GetB;
  end;

{ TImageFilterHelper }

  TImageFilterHelper = class
  public
    class function ApplyBrightness(AImage: TdxSmartImage; ABrightnessValue: Byte): TdxSmartImage;
    class function ApplyColorMatrics(AImage: TdxSmartImage; AColorMatrix: TdxGpColorMatrix): TdxSmartImage;
    class function ApplyContrast(AImage: TdxSmartImage; AContrastValue: Byte): TdxSmartImage;
    class function ApplyRGB(AImage: TdxSmartImage; R, G, B: Byte): TdxSmartImage;
  end;

implementation

uses
  SysUtils, Classes, dxCore, dxCoreGraphics, dxEMF.Core, uAlbumEditor, uPhotoEditor, uFilterEditor;

{ TAlbum }

constructor TAlbum.Create;
begin
  inherited Create;
  FContent := TdxEMFCollections.Create<TAlbumContent>(Self, 'FContent');
end;

class function TAlbum.GetEntityCaption: string;
begin
  Result := 'Album';
end;

class function TAlbum.GetEditorClass: TEntityEditorClass;
begin
  Result := TAlbumEditor;
end;

function TAlbum.Description: string;
begin
  Result := Caption;
  if Trim(Comment) <> '' then
    Result := Result + ' - ' + Comment;
end;

procedure TAlbum.AddPhoto(APhoto: TPhoto);
var
  AContent: TAlbumContent;
begin
  AContent := TAlbumContent.Create;
  AContent.Photo := APhoto;
  FContent.Add(AContent);
end;

procedure TAlbum.RemovePhoto(APhoto: TPhoto);
var
  AContent: TAlbumContent;
begin
  for AContent in FContent do
    if AContent.Photo.ID = APhoto.ID then
    begin
      FContent.Remove(AContent);
      Break;
    end;
end;

procedure TAlbum.SetComment(const AValue: string);
begin
  FComment := Copy(AValue, 1, 100);
end;

{ TPhoto }

constructor TPhoto.Create;
begin
  inherited Create;
  FAlbumContent_Photo := TdxEMFCollections.Create<TAlbumContent>(Self, 'FAlbumContent_Photo');
  FImage := TdxSmartImage.Create;
end;

destructor TPhoto.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TPhoto.SetImage(AValue: TdxSmartImage);
begin
  FImage.Assign(AValue)
end;

class function TPhoto.GetEntityCaption: string;
begin
  Result := 'Photo';
end;

class function TPhoto.GetEditorClass: TEntityEditorClass;
begin
  Result := TPhotoEditor;
end;

function TPhoto.Description: string;
var
  ASize: Int64;
begin
  ASize := GetSize div 1024;
  Result := IntToStr(Image.Width) + 'x' + IntToStr(Image.Height) + dxCRLF + IntToStr(ASize) + ' KB';
end;

function TPhoto.GetSize: Int64;
var
  AMemoryStream: TMemoryStream;
begin
  Result := 0;
  if not Image.Empty then
  begin
    AMemoryStream := TMemoryStream.Create;
    try
      Image.SaveToStream(AMemoryStream);
      Result := AMemoryStream.Size;
    finally
      AMemoryStream.Free;
    end;
  end;
end;

{ TAlbumContent }

procedure TAlbumContent.SetAlbum(AValue: TAlbum);
begin
  FAlbum := AValue;
  if FAlbum <> nil then
    FAlbum.Content.Add(Self);
end;

procedure TAlbumContent.SetPhoto(AValue: TPhoto);
begin
  FPhoto := AValue;
  if FPhoto <> nil then
    FPhoto.AlbumContent_Photo.Add(Self);
end;

{ TCustomFilter }

constructor TCustomFilter.Create;
begin
  inherited Create;
  FImage := TdxSmartImage.Create;
end;

destructor TCustomFilter.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TCustomFilter.Apply(ASource: TdxSmartImage; ADestination: TPicture);
begin
//
end;

procedure TCustomFilter.Apply(ASource: TdxSmartImage; ADestination: TdxSmartImage);
var
  APicture: TPicture;
begin
  APicture := TPicture.Create;
  try
    Apply(ASource, APicture);
    ADestination.Assign(APicture.Graphic);
  finally
    APicture.Free;
  end;
end;

procedure TCustomFilter.SetImage(AValue: TdxSmartImage);
begin
  FImage.Assign(AValue);
end;

{ TEffect }

procedure TEffect.Apply(ASource: TdxSmartImage; ADestination: TPicture);
var
  AColorMatrix: TdxGpColorMatrix;
  AImage: TdxSmartImage;
begin
  AColorMatrix[0, 0] := FM00;
  AColorMatrix[0, 1] := FM01;
  AColorMatrix[0, 2] := FM02;
  AColorMatrix[0, 3] := FM03;
  AColorMatrix[0, 4] := FM04;

  AColorMatrix[1, 0] := FM10;
  AColorMatrix[1, 1] := FM11;
  AColorMatrix[1, 2] := FM12;
  AColorMatrix[1, 3] := FM13;
  AColorMatrix[1, 4] := FM14;

  AColorMatrix[2, 0] := FM20;
  AColorMatrix[2, 1] := FM21;
  AColorMatrix[2, 2] := FM22;
  AColorMatrix[2, 3] := FM23;
  AColorMatrix[2, 4] := FM24;

  AColorMatrix[3, 0] := FM30;
  AColorMatrix[3, 1] := FM31;
  AColorMatrix[3, 2] := FM32;
  AColorMatrix[3, 3] := FM33;
  AColorMatrix[3, 4] := FM34;

  AColorMatrix[4, 0] := FM40;
  AColorMatrix[4, 1] := FM41;
  AColorMatrix[4, 2] := FM42;
  AColorMatrix[4, 3] := FM43;
  AColorMatrix[4, 4] := FM44;

  AImage := TImageFilterHelper.ApplyColorMatrics(ASource, AColorMatrix);
  try
    ADestination.Assign(AImage);
  finally
    AImage.Free;
  end;
end;

procedure TEffect.Assign(const AColorMatrix: TdxGpColorMatrix);
begin
  FM00 := AColorMatrix[0, 0];
  FM01 := AColorMatrix[0, 1];
  FM02 := AColorMatrix[0, 2];
  FM03 := AColorMatrix[0, 3];
  FM04 := AColorMatrix[0, 4];

  FM10 := AColorMatrix[1, 0];
  FM11 := AColorMatrix[1, 1];
  FM12 := AColorMatrix[1, 2];
  FM13 := AColorMatrix[1, 3];
  FM14 := AColorMatrix[1, 4];

  FM20 := AColorMatrix[2, 0];
  FM21 := AColorMatrix[2, 1];
  FM22 := AColorMatrix[2, 2];
  FM23 := AColorMatrix[2, 3];
  FM24 := AColorMatrix[2, 4];

  FM30 := AColorMatrix[3, 0];
  FM31 := AColorMatrix[3, 1];
  FM32 := AColorMatrix[3, 2];
  FM33 := AColorMatrix[3, 3];
  FM34 := AColorMatrix[3, 4];

  FM40 := AColorMatrix[4, 0];
  FM41 := AColorMatrix[4, 1];
  FM42 := AColorMatrix[4, 2];
  FM43 := AColorMatrix[4, 3];
  FM44 := AColorMatrix[4, 4];
end;

{ TFilter }

class function TFilter.GetEntityCaption: string;
begin
  Result := 'Filter';
end;

function TFilter.GetB: Byte;
begin
  Result := dxColorToRGBQuad(Color).rgbBlue;
end;

function TFilter.GetG: Byte;
begin
  Result := dxColorToRGBQuad(Color).rgbGreen;
end;

function TFilter.GetR: Byte;
begin
  Result := dxColorToRGBQuad(Color).rgbRed;
end;

class function TFilter.GetEditorClass: TEntityEditorClass;
begin
  Result := TFilterEditor;
end;

procedure TFilter.Apply(ASource: TdxSmartImage; ADestination: TPicture);
var
  AImage, AImage1, AImage3: TdxSmartImage;
begin
  AImage := TImageFilterHelper.ApplyContrast(ASource, Contrast);
  AImage1 := TImageFilterHelper.ApplyBrightness(AImage, Brightness);
  AImage3 := nil;
  try
    AImage3 := TImageFilterHelper.ApplyRGB(AImage1, R, G, B);
    ADestination.Assign(AImage3);
  finally
    AImage3.Free;
    AImage1.Free;
    AImage.Free;
  end;
end;

{ TImageFilterHelper }

class function TImageFilterHelper.ApplyBrightness(AImage: TdxSmartImage; ABrightnessValue: Byte): TdxSmartImage;
begin
  Result := ApplyRGB(AImage, ABrightnessValue, ABrightnessValue, ABrightnessValue);
end;

class function TImageFilterHelper.ApplyColorMatrics(AImage: TdxSmartImage; AColorMatrix: TdxGpColorMatrix): TdxSmartImage;
var
  AAttributes: TdxGPImageAttributes;
  AGpCanvas: TdxGPCanvas;
begin
  Result := TdxSmartImage.CreateSize(AImage.ClientRect);
  AAttributes := TdxGPImageAttributes.Create;
  try
    AAttributes.SetColorMatrix(@AColorMatrix, ColorMatrixFlagsDefault, ColorAdjustTypeBitmap);
    AGpCanvas := Result.CreateCanvas;
    try
      AGpCanvas.Draw(AImage, AImage.ClientRect, AAttributes);
    finally
      AGpCanvas.Free;
    end;
  finally
    AAttributes.Free;
  end;
end;

class function TImageFilterHelper.ApplyContrast(AImage: TdxSmartImage; AContrastValue: Byte): TdxSmartImage;
const
  ColorMatrix: TdxGpColorMatrix =
    ((1, 0, 0, 0, 0),
     (0, 1, 0, 0, 0),
     (0, 0, 1, 0, 0),
     (0, 0, 0, 1, 0),
     (0, 0, 0, 0, 1));
var
  AColorMatrix: TdxGpColorMatrix;
  AScale: Single;
  ATranslate: Single;
begin
  AScale := AContrastValue/100;
  ATranslate := (-0.5 * AContrastValue + 0.5) * 255;
  AColorMatrix := ColorMatrix;
  AColorMatrix[0, 0] := ColorMatrix[0, 0] + AScale;
  AColorMatrix[1, 1] := ColorMatrix[1, 1] + AScale;
  AColorMatrix[2, 2] := ColorMatrix[2, 2] + AScale;
  AColorMatrix[0, 4] := ATranslate;
  AColorMatrix[1, 4] := ATranslate;
  AColorMatrix[2, 4] := ATranslate;
  Result := ApplyColorMatrics(AImage, AColorMatrix);
end;

class function TImageFilterHelper.ApplyRGB(AImage: TdxSmartImage; R, G, B: Byte): TdxSmartImage;

const
  ColorMatrix: TdxGpColorMatrix =
    ((1, 0, 0, 0, 0),
     (0, 1, 0, 0, 0),
     (0, 0, 1, 0, 0),
     (0, 0, 0, 1, 0),
     (0.1, 0.1, 0.1, 0, 1));

var
  AColorMatrix: TdxGpColorMatrix;
  I: Integer;
begin
  AColorMatrix := ColorMatrix;
  AColorMatrix[0, 0] := ColorMatrix[0, 0] + R / 255;
  AColorMatrix[1, 1] := ColorMatrix[1, 1] + G / 255;
  AColorMatrix[2, 2] := ColorMatrix[2, 2] + B / 255;
  if (R = 0) and (G = 0) and (B = 0) then
    for I := 0 to 3 do
      AColorMatrix[4, I] := 0;
  Result := ApplyColorMatrics(AImage, AColorMatrix);
end;

end.
