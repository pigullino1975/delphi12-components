{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
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

unit dxBitmapBitsConverter; // for internal use

{$I cxVer.inc}

interface

uses
  SysUtils, Classes, Windows, dxCore, dxCoreClasses, cxGeometry, dxCoreGraphics, dxGDIPlusAPI, dxGDIPlusClasses, dxZIPUtils;

const
  CMYKDeviceColorSpace = 1;
  GrayDeviceColorSpace = 2;
  IndexedColorSpace    = 3;
  RGBDeviceColorSpace  = 4;

type
  TdxColorSpace = Integer;

  { TdxDecodeColorRanges }

  TdxDecodeColorRanges = class
  private class var
    FCMYK: TdxDoubleRanges;
    FRGB: TdxDoubleRanges;
    FGray: TdxDoubleRanges;
  public
    class function ConvertToString(ADecodeRanges: TdxDoubleRanges): string;
    class procedure InitializeRanges; static;
    class procedure FinalizeRanges; static;

    class property CMYK: TdxDoubleRanges read FCMYK;
    class property RGB: TdxDoubleRanges read FRGB;
    class property Gray: TdxDoubleRanges read FGray;
  end;

  { TdxBitmapDataEncoder }

  TdxBitmapDataEncoder = class
  private
    FEncoder: TdxDeflateHelper;
    FLastBitmapRow: TBytes;
    FOffset: Integer;
    FRowBuffer: TBytes;
    FUsePNGUpPrediction: Boolean; 
  protected
    procedure Add(AValue: Byte); inline;
    procedure EndRow; inline;
    function GetData(AUseDeflate: Boolean): TBytes;

    property UsePNGUpPrediction: Boolean read FUsePNGUpPrediction;
  public
    constructor Create(ARowLength: Integer; AUsePNGUpPrediction: Boolean = False);
    destructor Destroy; override;
  end;

  { TdxImageBitmapDataReader }

  TdxImageBitmapDataReader = class
  private
    FBitmapData: TBitmapData;
    FImageHandle: TdxGPImageHandle;
    FLength: Integer;
    FPosition: Integer;
  public
    constructor Create(AImageHandle: TdxGPImageHandle; AComponentCount: Integer);
    destructor Destroy; override;
    //
    function ReadRow(var ABuffer: TBytes; ACount: Integer): Integer;
  end;

  { TdxImageToBitmapDataConverter }

  TdxImageToBitmapDataConverter = class abstract
  protected const
    CMYK32bppPixelFormat = 8207;
    JPEGHighestQuality = 100;
    NonRGBImageFlags = Ord(TdxGpImageFlags.ColorSpaceCmyk) or Ord(TdxGpImageFlags.ColorSpaceYcck) or
      Ord(TdxGpImageFlags.ColorSpaceGray);
  private
    FBitsPerComponent: Integer;
    FColorSpace: TdxColorSpace;
    FDecodeRanges: TdxDoubleRanges;
    FDeflateImageData: Boolean;
    FImageData: TBytes;
    FSize: TSize;

    class function CreateBitmapConverter(AImageHandle: TdxGPImageHandle; ADeflateImageData, AExtractSoftMask: Boolean): TdxImageToBitmapDataConverter; static;

    function GetColorSpaceName: string;
  protected
    class function GetJPEGImageData(AImageHandle: TdxGPImageHandle; AQuality: Integer = -1): TBytes; static;
    class function SaveBitmapToBytes(AProc: TProc<TStream>): TBytes; static;

    function GetBitsPerComponent(APixelFormat: TdxGpPixelFormat): Integer;
    function GetSoftMaskData: TBytes; virtual;
  public
    constructor Create(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean = True); overload; virtual;
    constructor Create(const ASize: TSize); overload; virtual;

    class function ColorSpaceToString(AColorSpace: Integer): string;
    class function CreateConverter(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean = True;
      AConvertToJPEG: Boolean = False; AJPEGQuality: Cardinal = 100; AExtractSoftMask: Boolean = True): TdxImageToBitmapDataConverter; static;

    property BitsPerComponent: Integer read FBitsPerComponent;
    property ColorSpace: TdxColorSpace read FColorSpace;
    property ColorSpaceName: string read GetColorSpaceName;
    property DecodeRanges: TdxDoubleRanges read FDecodeRanges;
    property DeflateImageData: Boolean read FDeflateImageData;
    property ImageData: TBytes read FImageData;
    property ImageSize: TSize read FSize;
    property SoftMaskData: TBytes read GetSoftMaskData;
  end;

  { TdxDeviceImageBitmapConverter }

  TdxDeviceImageBitmapConverter = class(TdxImageToBitmapDataConverter)
  protected
  public
    constructor Create(const ASize: TSize; AColorSpace: TdxColorSpace; const ADecodeRanges: TdxDoubleRanges); overload;
  end;

  { TdxImageBitmapConverter }

  TdxImageBitmapConverter = class(TdxDeviceImageBitmapConverter)
  protected
    procedure ConvertBitmapBits(AImageHandle: TdxGPImageHandle); virtual;
    function GetComponentCount: Integer; virtual; abstract;
    procedure ReadImageRow(const AData: TBytes; AEncoder: TdxBitmapDataEncoder); virtual; abstract;
  public
    constructor Create(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean = True); override;
    //
    property ComponentCount: Integer read GetComponentCount;
    property SoftMaskData: TBytes read GetSoftMaskData;
  end;

  { TdxImage24bppBitmapConverter }

  TdxImage24bppBitmapConverter = class(TdxImageBitmapConverter)
  protected
    function GetComponentCount: Integer; override;
    procedure ReadImageRow(const AData: TBytes; AEncoder: TdxBitmapDataEncoder); override;
  end;

  { TdxImage32bppBitmapConverter }

  TdxImage32bppBitmapConverter = class(TdxImageBitmapConverter)
  private
    FAlphaState: TdxAlphaState;
    FSoftMaskEncoder: TdxBitmapDataEncoder;
    FSoftMaskData: TBytes;
  protected
    procedure ConvertBitmapBits(AImageHandle: TdxGPImageHandle); override;
    function GetComponentCount: Integer; override;
    function GetSoftMaskData: TBytes; override;
    procedure ReadImageRow(const AData: TBytes; AEncoder: TdxBitmapDataEncoder); override;
  public
    constructor Create(AImageHandle: TdxGPImageHandle; ADeflateImageData, AExtractSoftMask: Boolean);
  end;

  { TdxImageToDCTImageConverter }

  TdxImageToDCTImageConverter = class(TdxDeviceImageBitmapConverter)
  private
    FUseDecodePredictorForSoftMask: Boolean;
    FSoftMaskData: TBytes;
  protected
    function GetSoftMaskData: TBytes; override;
  public
    constructor Create(const AImageSize: TSize; const AImageData: TBytes); overload;
    constructor Create(const AImageSize: TSize; const AImageData: TBytes; ASoftMaskData: TBytes;
      AUseDecodePredictorForSoftMask: Boolean); overload;
    constructor Create(const AImageSize: TSize; const AImageData: TBytes; ASoftMaskData: TBytes;
      AColorSpace: TdxColorSpace; const AColorRanges: TdxDoubleRanges); overload;
    //
    class function ConvertToJPEG(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean;
      AQuality: Cardinal; AExtractSoftMask: Boolean): TdxImageToDCTImageConverter; static;
    class function CreateFromYCCKJPEG(const AImageSize: TSize;
      const AImageData: TBytes): TdxImageToDCTImageConverter; overload; static;
    class function CreateFromYCCKJPEG(const AImageSize: TSize;
      const AImageData: TBytes; const ASoftMaskData: TBytes): TdxImageToDCTImageConverter; overload; static;

    property UseDecodePredictorForSoftMask: Boolean read FUseDecodePredictorForSoftMask;
  end;

  { TdxIndexedImageBitmapToSoftMaskConverter }

  TdxIndexedImageBitmapToSoftMaskConverter = class(TdxImageToBitmapDataConverter)
  private
    function ExtractImageData(AImageHandle: TdxGPImageHandle): TBytes;
  public
    constructor Create(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean = True); override;
  end;

  { TdxIndexedImageBitmapConverter }

  TdxIndexedImageBitmapConverter = class(TdxImageToBitmapDataConverter)
  private
    FBaseColorSpace: TdxColorSpace;
    FColorKeyMask: TdxDoubleRanges;
    FLookupTable: TBytes;
    FMaxValue: Integer;

    function ExtractImageData(AImageHandle: TdxGPImageHandle): TBytes;
  public
    constructor Create(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean = True); override;

    property BaseColorSpace: TdxColorSpace read FBaseColorSpace;
    property ColorKeyMask: TdxDoubleRanges read FColorKeyMask;
    property LookupTable: TBytes read FLookupTable;
    property MaxValue: Integer read FMaxValue;
  end;

implementation

uses
  Types, Math, StrUtils;

const
  dxThisUnitName = 'dxBitmapBitsConverter';

type
  TdxGPImageHandleAccess = class(TdxGPImageHandle);

{ TdxBitmapDataEncoder }

constructor TdxBitmapDataEncoder.Create(ARowLength: Integer; AUsePNGUpPrediction: Boolean);
begin
  inherited Create;
  FEncoder := TdxDeflateHelper.Create;
  SetLength(FRowBuffer, ARowLength);
  SetLength(FLastBitmapRow, ARowLength);
  FUsePNGUpPrediction := AUsePNGUpPrediction;
end;

destructor TdxBitmapDataEncoder.Destroy;
begin
  FreeAndNil(FEncoder);
  inherited Destroy;
end;

procedure TdxBitmapDataEncoder.Add(AValue: Byte);
begin
  if UsePNGUpPrediction then
  begin
    FRowBuffer[FOffset] := AValue - FLastBitmapRow[FOffset];
    FLastBitmapRow[FOffset] := AValue;
  end
  else
    FRowBuffer[FOffset] := AValue;
  Inc(FOffset);
end;

procedure TdxBitmapDataEncoder.EndRow;
begin
  if UsePNGUpPrediction then
    FEncoder.WriteByte(2);
  FEncoder.WriteData(FRowBuffer);
  FOffset := 0;
end;

function TdxBitmapDataEncoder.GetData(AUseDeflate: Boolean): TBytes;
begin
  if AUseDeflate then
    Result := FEncoder.GetCompressedData
  else
    Result := FEncoder.GetRawData;
end;

{ TdxImageBitmapDataReader }

constructor TdxImageBitmapDataReader.Create(AImageHandle: TdxGPImageHandle; AComponentCount: Integer);
begin
  inherited Create;
  FImageHandle := AImageHandle;
  FBitmapData := AImageHandle.LockBits(TRect.Create(0, 0, AImageHandle.Width, AImageHandle.Height), ImageLockModeRead, AImageHandle.PixelFormat);
  FLength := AImageHandle.Height * FBitmapData.Stride;
end;

destructor TdxImageBitmapDataReader.Destroy;
begin
  FImageHandle.UnlockBits(FBitmapData);
  inherited Destroy;
end;

function TdxImageBitmapDataReader.ReadRow(var ABuffer: TBytes; ACount: Integer): Integer;
var
  ARemainByteCount: Integer;
begin
  ARemainByteCount := FLength - FPosition;
  if ARemainByteCount > ACount then
    Result := ACount
  else
    Result := ARemainByteCount;
  SetLength(ABuffer, Result);
  cxCopyData(FBitmapData.Scan0, @ABuffer[0], FPosition, 0, Result);
  Inc(FPosition, FBitmapData.Stride);
end;

{ TdxImageToBitmapDataConverter }

constructor TdxImageToBitmapDataConverter.Create(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean);
begin
  Create(AImageHandle.Size);
  FBitsPerComponent := GetBitsPerComponent(AImageHandle.PixelFormat);
  FDeflateImageData := ADeflateImageData;
end;

constructor TdxImageToBitmapDataConverter.Create(const ASize: TSize);
begin
  inherited Create;
  FBitsPerComponent := 8;
  FColorSpace := RGBDeviceColorSpace;
  FDecodeRanges := TdxDecodeColorRanges.RGB;
  FDeflateImageData := True;
  FSize := ASize;
end;

class function TdxImageToBitmapDataConverter.CreateConverter(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean;
  AConvertToJPEG: Boolean; AJPEGQuality: Cardinal; AExtractSoftMask: Boolean): TdxImageToBitmapDataConverter;
var
  ADCTConverter: TdxImageToBitmapDataConverter;
begin
  AConvertToJPEG := AConvertToJPEG and
    (((AImageHandle.PixelFormat and PixelFormatIndexed) <> 0) or
     (AImageHandle.PixelFormat = PixelFormat24bppRgb) or
     (AImageHandle.PixelFormat = PixelFormat32bppArgb) and ((AImageHandle.PixelFormat and PixelFormatAlpha) <> 0)); 

  if AImageHandle.ImageDataFormat = dxImageJPEG then
    if Ord(AImageHandle.PixelFormat) = CMYK32bppPixelFormat then
      Result := TdxImageToDCTImageConverter.CreateFromYCCKJPEG(AImageHandle.Size, GetJPEGImageData(AImageHandle))
    else
      if Ord(AImageHandle.Flags) and Ord(NonRGBImageFlags) = 0 then
        Result := TdxImageToDCTImageConverter.Create(AImageHandle.Size, GetJPEGImageData(AImageHandle))
      else
        Result := TdxImageToDCTImageConverter.ConvertToJPEG(AImageHandle, ADeflateImageData, JPEGHighestQuality, False)
  else
    if AImageHandle.ImageDataFormat = dxImageTiff then
      Exit(nil)
    else
      if AConvertToJPEG and (AJPEGQuality = JPEGHighestQuality) then
        Result := TdxImageToDCTImageConverter.ConvertToJPEG(AImageHandle, ADeflateImageData,
          JPEGHighestQuality, AExtractSoftMask)
      else
        Result := CreateBitmapConverter(AImageHandle, ADeflateImageData, AExtractSoftMask);

  if AConvertToJPEG and (AJPEGQuality <> JPEGHighestQuality) then
  begin
    ADCTConverter := TdxImageToDCTImageConverter.ConvertToJPEG(AImageHandle, ADeflateImageData,
      AJPEGQuality, AExtractSoftMask);
    if Result = nil then
      Result := ADCTConverter
    else
      if Length(ADCTConverter.ImageData) < Length(Result.ImageData) then
      begin
        Result.Free;
        Result := ADCTConverter;
      end
      else
        ADCTConverter.Free;
  end;
end;

class function TdxImageToBitmapDataConverter.ColorSpaceToString(AColorSpace: Integer): string;
begin
  case AColorSpace of
    CMYKDeviceColorSpace: Result := 'DeviceCMYK';
    GrayDeviceColorSpace: Result := 'DeviceGray';
    IndexedColorSpace:    Result := 'Indexed';
    RGBDeviceColorSpace:  Result := 'DeviceRGB';
  else
    Result := '';
  end;
end;

function TdxImageToBitmapDataConverter.GetBitsPerComponent(APixelFormat: TdxGpPixelFormat): Integer;
begin
  case Ord(APixelFormat) of
    PixelFormat1bppIndexed:
      Result := 1;
    PixelFormat4bppIndexed:
      Result := 4;
    else
      Result := 8;
  end;
end;

function TdxImageToBitmapDataConverter.GetColorSpaceName: string;
begin
  Result := ColorSpaceToString(FColorSpace);
end;

class function TdxImageToBitmapDataConverter.GetJPEGImageData(AImageHandle: TdxGPImageHandle;
  AQuality: Integer = -1): TBytes;
var
  AUseQuality: Boolean;
begin
  AUseQuality := AQuality > -1;
  Result := SaveBitmapToBytes(
    procedure(AStream: TStream)
    begin
      if AUseQuality then
        TdxGPImageCodecJPEG.Quality := AQuality;
      try
        TdxGPImageCodecJPEG.Save(AStream, AImageHandle);
      finally
        if AUseQuality then
          TdxGPImageCodecJPEG.Quality := TdxGPImageCodecJPEG.DefaultQuality;
      end;
    end);
end;

function TdxImageToBitmapDataConverter.GetSoftMaskData: TBytes;
begin
  Result := nil;
end;

class function TdxImageToBitmapDataConverter.SaveBitmapToBytes(AProc: TProc<TStream>): TBytes;
var
  AStream: TdxMemoryStream;
begin
  AStream := TdxMemoryStream.Create;
  try
    AProc(AStream);
    Result := AStream.ToArray;
  finally
    AStream.Free;
  end;
end;

class function TdxImageToBitmapDataConverter.CreateBitmapConverter(AImageHandle: TdxGPImageHandle;
  ADeflateImageData, AExtractSoftMask: Boolean): TdxImageToBitmapDataConverter;

  function CloneImageAndExecute(AImageHandle: TdxGPImageHandle; APixelFormat: TdxGpPixelFormat;
    ACreateConverterFunc: TFunc<TdxGPImageHandle, TdxImageToBitmapDataConverter>): TdxImageToBitmapDataConverter;
  var
    AClone: TdxGPImageHandle;
  begin
    AClone := AImageHandle.Clone(cxRect(AImageHandle.Size), APixelFormat);
    try
      Result := ACreateConverterFunc(AClone);
    finally
      AClone.Free;
    end;
  end;

var
  APixelFormat: Integer;
begin
  APixelFormat := Ord(AImageHandle.PixelFormat);
  if (APixelFormat and PixelFormatIndexed) <> 0 then
    Exit(TdxIndexedImageBitmapConverter.Create(AImageHandle, ADeflateImageData));

  if APixelFormat = PixelFormat24bppRgb then
    Exit(TdxImage24bppBitmapConverter.Create(AImageHandle, ADeflateImageData));

  if APixelFormat = PixelFormat32bppArgb then
    Exit(TdxImage32bppBitmapConverter.Create(AImageHandle, ADeflateImageData, AExtractSoftMask));

  if (APixelFormat and PixelFormatAlpha) <> 0 then
    Exit(CloneImageAndExecute(AImageHandle, PixelFormat32bppArgb,
      function(AClone: TdxGPImageHandle): TdxImageToBitmapDataConverter
      begin
        Result := TdxImage32bppBitmapConverter.Create(AClone, ADeflateImageData, AExtractSoftMask);
      end));

  Result := CloneImageAndExecute(AImageHandle, PixelFormat24bppRgb,
    function(AClone: TdxGPImageHandle): TdxImageToBitmapDataConverter
    begin
      Result := TdxImage24bppBitmapConverter.Create(AClone, ADeflateImageData);
    end);
end;

{ TdxDeviceImageBitmapConverter }

constructor TdxDeviceImageBitmapConverter.Create(const ASize: TSize;
  AColorSpace: TdxColorSpace; const ADecodeRanges: TdxDoubleRanges);
begin
  Create(ASize);
  FColorSpace := AColorSpace;
  FDecodeRanges := ADecodeRanges;
end;

{ TdxImageBitmapConverter }

constructor TdxImageBitmapConverter.Create(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean = True);
begin
  inherited Create(AImageHandle, ADeflateImageData);
  ConvertBitmapBits(AImageHandle);
end;

procedure TdxImageBitmapConverter.ConvertBitmapBits(AImageHandle: TdxGPImageHandle);
var
  AReader: TdxImageBitmapDataReader;
  AEncoder: TdxBitmapDataEncoder;
  ABufferSize: Integer;
  ABuffer: TArray<System.Byte>;
  Y: Integer;
begin
  AReader := TdxImageBitmapDataReader.Create(AImageHandle, ComponentCount);
  try
    AEncoder := TdxBitmapDataEncoder.Create(ImageSize.Width * 3, FDeflateImageData);
    try
      ABufferSize := ImageSize.Width * ComponentCount;
      SetLength(ABuffer, ABufferSize);
      for Y := 0 to ImageSize.Height - 1 do
      begin
        AReader.ReadRow(ABuffer, ABufferSize);
        ReadImageRow(ABuffer, AEncoder);
        AEncoder.EndRow;
      end;
      FImageData := AEncoder.GetData(FDeflateImageData);
    finally
      AEncoder.Free;
    end;
  finally
    AReader.Free;
  end;
end;

{ TdxImage24bppBitmapConverter }

function TdxImage24bppBitmapConverter.GetComponentCount: Integer;
begin
  Result := 3;
end;

procedure TdxImage24bppBitmapConverter.ReadImageRow(const AData: TBytes; AEncoder: TdxBitmapDataEncoder);
var
  X, APosition: Integer;
begin
  APosition := 0;
  for X := 0 to ImageSize.Width - 1 do
  begin
    AEncoder.Add(AData[APosition + 2]); 
    AEncoder.Add(AData[APosition + 1]); 
    AEncoder.Add(AData[APosition]); 
    Inc(APosition, 3);
  end;
end;

{ TdxImage32bppBitmapConverter }

procedure TdxImage32bppBitmapConverter.ConvertBitmapBits(AImageHandle: TdxGPImageHandle);
begin
  FAlphaState := asOpaque;
  inherited ConvertBitmapBits(AImageHandle);
end;

constructor TdxImage32bppBitmapConverter.Create(AImageHandle: TdxGPImageHandle; ADeflateImageData, AExtractSoftMask: Boolean);
begin
  inherited Create(AImageHandle, ADeflateImageData);
  if AExtractSoftMask and (FAlphaState = asSemitransparent) then
    FSoftMaskData := FSoftMaskEncoder.GetData(ADeflateImageData);
  FreeAndNil(FSoftMaskEncoder);
end;

function TdxImage32bppBitmapConverter.GetComponentCount: Integer;
begin
  Result := 4;
end;

function TdxImage32bppBitmapConverter.GetSoftMaskData: TBytes;
begin
  Result := FSoftMaskData;
end;

procedure TdxImage32bppBitmapConverter.ReadImageRow(const AData: TBytes; AEncoder: TdxBitmapDataEncoder);
var
  ARed, AGreen, ABlue, AAlpha: Byte;
  X, APosition: Integer;
begin
  if FSoftMaskEncoder = nil then
    FSoftMaskEncoder := TdxBitmapDataEncoder.Create(ImageSize.Width, AEncoder.UsePNGUpPrediction);

  APosition := 0;
  for X := 0 to ImageSize.Width - 1 do
  begin
    ABlue := AData[APosition];
    Inc(APosition);
    AGreen := AData[APosition];
    Inc(APosition);
    ARed := AData[APosition];
    Inc(APosition);
    AAlpha := AData[APosition];
    Inc(APosition);
    AEncoder.Add(ARed);
    AEncoder.Add(AGreen);
    AEncoder.Add(ABlue);
    if AAlpha <> 255 then
      FAlphaState := asSemitransparent;
    FSoftMaskEncoder.Add(AAlpha);
  end;
  FSoftMaskEncoder.EndRow;
end;

{ TdxImageToDCTImageConverter }

constructor TdxImageToDCTImageConverter.Create(const AImageSize: TSize; const AImageData: TBytes;
  ASoftMaskData: TBytes; AColorSpace: TdxColorSpace; const AColorRanges: TdxDoubleRanges);
begin
  inherited Create(AImageSize, AColorSpace, AColorRanges);
  FImageData := AImageData;
  FSoftMaskData := ASoftMaskData;
  FUseDecodePredictorForSoftMask := True;
end;

constructor TdxImageToDCTImageConverter.Create(const AImageSize: TSize; const AImageData: TBytes;
  ASoftMaskData: TBytes; AUseDecodePredictorForSoftMask: Boolean);
begin
  Create(AImageSize, AImageData, ASoftMaskData, RGBDeviceColorSpace, TdxDecodeColorRanges.RGB);
  FUseDecodePredictorForSoftMask := AUseDecodePredictorForSoftMask;
end;

constructor TdxImageToDCTImageConverter.Create(const AImageSize: TSize; const AImageData: TBytes);
begin
  Create(AImageSize, AImageData, nil, False);
end;

class function TdxImageToDCTImageConverter.ConvertToJPEG(AImageHandle: TdxGPImageHandle;
  ADeflateImageData: Boolean; AQuality: Cardinal; AExtractSoftMask: Boolean): TdxImageToDCTImageConverter;
var
  AAlpha: Byte;
  AEncoder: TdxBitmapDataEncoder;
  AHasMask: Boolean;
  AImageData, AImageRow, ASoftMaskData: TBytes;
  AImageRowLength, X, Y, APosition: Integer;
  AImageSize: TSize;
  APalette: TdxAlphaColorDynArray;
  APaletteFlags: UInt;
  APixelFormat: Integer;
  AReader: TdxImageBitmapDataReader;
  ASoftMaskConverter: TdxIndexedImageBitmapToSoftMaskConverter;
  ATempImageHandle: TdxGPImageHandle;
  AUseDecodePredictorForSoftMask: Boolean;
begin
  AImageData := GetJPEGImageData(AImageHandle, AQuality);
  AImageSize := AImageHandle.Size;
  APixelFormat := Ord(AImageHandle.PixelFormat);
  AUseDecodePredictorForSoftMask := True;

  if AExtractSoftMask then
  begin
    if (APixelFormat and PixelFormatIndexed) <> 0 then
    begin
      APalette := TdxGPImageHandleAccess(AImageHandle).GetColorPalette(APaletteFlags);
      for X := 0 to Length(APalette) - 1 do
        if TdxAlphaColors.Alpha(APalette[X]) <> 255 then
        begin
          ASoftMaskConverter := TdxIndexedImageBitmapToSoftMaskConverter.Create(AImageHandle, ADeflateImageData);
          try
            ASoftMaskData := ASoftMaskConverter.ImageData;
            AUseDecodePredictorForSoftMask := False;
          finally
            ASoftMaskConverter.Free;
          end;
          Break;
        end;
    end
    else
      if (APixelFormat <> PixelFormat24bppRgb) and (APixelFormat and PixelFormatAlpha <> 0) then
      begin
        ATempImageHandle := AImageHandle.Clone(cxRect(AImageSize), PixelFormat32bppArgb);
        try
          AEncoder := TdxBitmapDataEncoder.Create(AImageSize.Width, ADeflateImageData);
          try
            AReader := TdxImageBitmapDataReader.Create(ATempImageHandle, 4);
            try
              AHasMask := False;
              AImageRowLength := AImageSize.Width * 4;
              SetLength(AImageRow, AImageRowLength);
              for Y := 0 to AImageSize.Height - 1 do
              begin
                AReader.ReadRow(AImageRow, AImageRowLength);
                APosition := 0;
                for X := 0 to AImageSize.Width - 1 do
                begin
                  Inc(APosition, 3);
                  AAlpha := AImageRow[APosition];
                  Inc(APosition);
                  AEncoder.Add(AAlpha);
                  AHasMask := AHasMask or (AAlpha <> 255);
                end;
                AEncoder.EndRow;
              end;
              if AHasMask then
                ASoftMaskData := AEncoder.GetData(ADeflateImageData);
              AUseDecodePredictorForSoftMask := ADeflateImageData;
            finally
              AReader.Free;
            end
          finally
            AEncoder.Free;
          end;
        finally
          ATempImageHandle.Free;
        end;
      end;
  end
  else
    ASoftMaskData := nil;

  if (APixelFormat = CMYK32bppPixelFormat) and (AImageHandle.ImageDataFormat = dxImageJPEG) then
    Result := CreateFromYCCKJPEG(AImageSize, AImageData, ASoftMaskData)
  else
    Result := TdxImageToDCTImageConverter.Create(AImageSize, AImageData, ASoftMaskData, AUseDecodePredictorForSoftMask);
end;

class function TdxImageToDCTImageConverter.CreateFromYCCKJPEG(const AImageSize: TSize;
  const AImageData: TBytes; const ASoftMaskData: TBytes): TdxImageToDCTImageConverter;
begin
  Result := TdxImageToDCTImageConverter.Create(AImageSize, AImageData, ASoftMaskData,
    CMYKDeviceColorSpace, TdxDecodeColorRanges.CMYK);
end;

function TdxImageToDCTImageConverter.GetSoftMaskData: TBytes;
begin
  Result := FSoftMaskData;
end;

class function TdxImageToDCTImageConverter.CreateFromYCCKJPEG(const AImageSize: TSize;
  const AImageData: TBytes): TdxImageToDCTImageConverter;
begin
  Result := CreateFromYCCKJPEG(AImageSize, AImageData, nil);
end;

{ TdxIndexedImageBitmapToSoftMaskConverter }

constructor TdxIndexedImageBitmapToSoftMaskConverter.Create(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean);
begin
  inherited Create(AImageHandle, ADeflateImageData);
  FColorSpace := GrayDeviceColorSpace;
  FDecodeRanges := TdxDecodeColorRanges.Gray;
  FImageData := ExtractImageData(AImageHandle);
end;

function TdxIndexedImageBitmapToSoftMaskConverter.ExtractImageData(AImageHandle: TdxGPImageHandle): TBytes;
var
  ABitsPerRow, ABytesPerRow, ARemain, AStride, ASamplesPerByte, ADestinationOffset, ASamplesCount: Integer;
  ABuffer: TBytes;
  AFlags: Cardinal;
  ALookup: TdxAlphaColorDynArray;
  AShift, I, J, K: Integer;
  ASourceOffset: Int64;
  AStream: TMemoryStream;
  AValueMask, B: Byte;
begin
  AStream := TMemoryStream.Create;
  try
    TdxGPImageCodecBMP.Save(AStream, AImageHandle);

    ABitsPerRow := FBitsPerComponent * ImageSize.Width;
    ABytesPerRow := ABitsPerRow div 8;
    if ABitsPerRow mod 8 <> 0 then
      Inc(ABytesPerRow);

    SetLength(Result, ImageSize.Width * ImageSize.Height);
    ARemain := ABytesPerRow mod 4;
    if ARemain = 0 then
      AStride := ABytesPerRow
    else
      AStride := ABytesPerRow + 4 - ARemain;
    ADestinationOffset := 0;
    ASourceOffset := AStream.Size - AStride;

    SetLength(ABuffer, ABytesPerRow);
    ALookup := TdxGPImageHandleAccess(AImageHandle).GetColorPalette(AFlags);
    ASamplesPerByte := 8 div FBitsPerComponent;
    AValueMask := Byte((1 shl FBitsPerComponent) - 1);
    for I := 0 to ImageSize.Height - 1 do
    begin
      AStream.Position := ASourceOffset;
      ReadBufferFromStream(AStream, ABuffer, ABytesPerRow);
      for J := 0 to ABytesPerRow - 1 do
      begin
        B := ABuffer[J];
        AShift := 8 - FBitsPerComponent;
        ASamplesCount := Min(ASamplesPerByte, ImageSize.Width - J * ASamplesPerByte);
        for K := 0 to ASamplesCount - 1 do
        begin
          Result[ADestinationOffset] := TdxAlphaColors.Alpha(ALookup[(B shr AShift) and AValueMask]);
          Dec(AShift, FBitsPerComponent);
          Inc(ADestinationOffset);
        end;
      end;
      Dec(ASourceOffset, AStride);
    end;
    if DeflateImageData then
      Result := TdxDeflateHelper.Compress(Result);
  finally
    AStream.Free;
  end;
end;

{ TdxIndexedImageBitmapConverter }

constructor TdxIndexedImageBitmapConverter.Create(AImageHandle: TdxGPImageHandle; ADeflateImageData: Boolean);

  function CreateColorKeyMask(AIndex: Integer): TdxDoubleRanges;
  begin
    SetLength(Result, 1);
    Result[0] := TdxDoubleRange.Create(AIndex, AIndex);
  end;

var
  AColor: TdxAlphaColor;
  AFlags: Cardinal;
  APalette: TdxAlphaColorDynArray;
  I, AColorPos: Integer;
begin
  inherited Create(AImageHandle, ADeflateImageData);
  FColorSpace := IndexedColorSpace;
  SetLength(FDecodeRanges, 1);
  FDecodeRanges[0] := TdxDoubleRange.Create(0, 1 shl FBitsPerComponent - 1);

  APalette := TdxGPImageHandleAccess(AImageHandle).GetColorPalette(AFlags);
  FMaxValue := Length(APalette);
  if (AFlags and $2) = 0 then 
  begin
    FBaseColorSpace := RGBDeviceColorSpace;
    AColorPos := 0;
    SetLength(FLookupTable, FMaxValue * 3);
    for I := 0 to FMaxValue - 1 do
    begin
      AColor := APalette[I];
      FLookupTable[AColorPos] := TdxAlphaColors.R(AColor);
      FLookupTable[AColorPos + 1] := TdxAlphaColors.G(AColor);
      FLookupTable[AColorPos + 2] := TdxAlphaColors.B(AColor);
      Inc(AColorPos, 3);
      if (TdxAlphaColors.Alpha(AColor) = 0) and (FColorKeyMask = nil) then
        FColorKeyMask := CreateColorKeyMask(I);
    end;
  end
  else
  begin
    FBaseColorSpace := GrayDeviceColorSpace;
    SetLength(FLookupTable, FMaxValue);
    for I := 0 to FMaxValue - 1 do
    begin
      AColor := APalette[I];
      FLookupTable[I] := TdxAlphaColors.R(AColor);
      if (TdxAlphaColors.Alpha(AColor) = 0) and (FColorKeyMask = nil) then
        FColorKeyMask := CreateColorKeyMask(I);
    end;
  end;
  FImageData := ExtractImageData(AImageHandle);
end;

function TdxIndexedImageBitmapConverter.ExtractImageData(AImageHandle: TdxGPImageHandle): TBytes;
var
  AStream: TMemoryStream;
  ABitsPerRow, ABytesPerRow, ARemain, AStride, I, ADstOffset: Integer;
  AImageData, ABuffer: TBytes;
  ASrcOffset: Int64;
begin
  AStream := TMemoryStream.Create;
  try
    TdxGPImageCodecBMP.Save(AStream, AImageHandle);

    ABitsPerRow := FBitsPerComponent * ImageSize.Width;
    ABytesPerRow := ABitsPerRow div 8;
    if ABitsPerRow mod 8 <> 0 then
      Inc(ABytesPerRow);

    SetLength(AImageData, ABytesPerRow * ImageSize.Height);
    ARemain := ABytesPerRow mod 4;
    if ARemain = 0 then
      AStride := ABytesPerRow
    else
      AStride := ABytesPerRow + 4 - ARemain;
    ASrcOffset := AStream.Size - AStride;

    SetLength(ABuffer, ABytesPerRow);
    ADstOffset := 0;
    for I := 0 to ImageSize.Height - 1 do
    begin
      AStream.Position := ASrcOffset;
      ReadBufferFromStream(AStream, ABuffer, ABytesPerRow);
      cxCopyData(@ABuffer[0], @AImageData[0], 0, ADstOffset, ABytesPerRow);
      Inc(ADstOffset, ABytesPerRow);
      Dec(ASrcOffset, AStride);
    end;
    if DeflateImageData then
      Result := TdxDeflateHelper.Compress(AImageData)
    else
      Result := AImageData;
  finally
    AStream.Free;
  end;
end;

{ TdxDecodeColorRanges }

class procedure TdxDecodeColorRanges.FinalizeRanges;
begin
  SetLength(FGray, 0);
  SetLength(FRGB, 0);
  SetLength(FCMYK, 0);
end;

class procedure TdxDecodeColorRanges.InitializeRanges;
begin
  SetLength(FCMYK, 4);
  FCMYK[0] := TdxDoubleRange.Create(1, 0);
  FCMYK[1] := TdxDoubleRange.Create(1, 0);
  FCMYK[2] := TdxDoubleRange.Create(1, 0);
  FCMYK[3] := TdxDoubleRange.Create(1, 0);

  SetLength(FRGB, 3);
  FRGB[0] := TdxDoubleRange.Create(0, 1);
  FRGB[1] := TdxDoubleRange.Create(0, 1);
  FRGB[2] := TdxDoubleRange.Create(0, 1);

  SetLength(FGray, 1);
  FGray[0] := TdxDoubleRange.Create(0, 1);
end;

class function TdxDecodeColorRanges.ConvertToString(ADecodeRanges: TdxDoubleRanges): string;
var
  I, ACount: Integer;
begin
  Result := '';
  ACount := Length(ADecodeRanges);
  for I := 0 to ACount - 1 do
    Result := Result + IfThen(Result <> '', ' ') +
      IntToStr(Round(ADecodeRanges[I].Min)) + ' ' + IntToStr(Round(ADecodeRanges[I].Max));
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxDecodeColorRanges.InitializeRanges;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxDecodeColorRanges.FinalizeRanges;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
