{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPDFViewer                                         }
{                                                                    }
{           Copyright (c) 2015-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPDFVIEWER AND ALL              }
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

unit dxPDFImageToXObjectConverter; // for internal use

{$I cxVer.inc}

interface

uses
  SysUtils, Classes, Windows, cxGeometry, dxCoreGraphics, dxGDIPlusAPI, dxGDIPlusClasses, dxPDFTypes, dxPDFFlateLZW,
  dxPDFStreamFilter, dxPDFCore, dxPDFColorSpace, dxBitmapBitsConverter;

type
  { TdxPDFImageToXObjectConverter }

  TdxPDFImageToXObjectConverter = class
  protected
    class function CreateColorSpace(AColorSpaceNum: TdxColorSpace): TdxPDFCustomColorSpace;
    class function CreateSoftMaskObject(AConverter: TdxImageToBitmapDataConverter): TdxPDFDocumentImage; static;
  public
    class function CreateXObject(AConverter: TdxImageToBitmapDataConverter): TdxPDFDocumentImage; static;
    class function Convert(AImage: TdxGPImageHandle): TdxPDFDocumentImage; static;
  end;

implementation

uses
  Types, Math, dxCore, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFImageToXObjectConverter';

{ TdxPDFImageToXObjectConverter }

class function TdxPDFImageToXObjectConverter.Convert(AImage: TdxGPImageHandle): TdxPDFDocumentImage;
var
  AConverter: TdxImageToBitmapDataConverter;
begin
  AConverter := TdxImageToBitmapDataConverter.CreateConverter(AImage, True, False, 0, True);
  if AConverter = nil then
    TdxPDFUtils.RaiseNotImplementedException;
  try
    Result := CreateXObject(AConverter);
  finally
    AConverter.Free;
  end;
end;

class function TdxPDFImageToXObjectConverter.CreateColorSpace(AColorSpaceNum: TdxColorSpace): TdxPDFCustomColorSpace;
begin
  case AColorSpaceNum of
    CMYKDeviceColorSpace:
      Result := TdxPDFCMYKDeviceColorSpace.Create;
    GrayDeviceColorSpace:
      Result := TdxPDFGrayDeviceColorSpace.Create;
    IndexedColorSpace:
      Result := TdxPDFIndexedColorSpace.Create;
    RGBDeviceColorSpace:
      Result := TdxPDFRGBDeviceColorSpace.Create
  else
    Result := nil;
  end;
end;

class function TdxPDFImageToXObjectConverter.CreateSoftMaskObject(
  AConverter: TdxImageToBitmapDataConverter): TdxPDFDocumentImage;
var
  AFilters: TdxPDFStreamFilters;
  ASoftMaskData: TBytes;
begin
  Result := nil;
  ASoftMaskData := AConverter.SoftMaskData;
  if ASoftMaskData <> nil then
  begin
    Result := TdxPDFDocumentImage.Create(ASoftMaskData, AConverter.ImageSize, 8);

    AFilters := TdxPDFStreamFilters.Create;
    if (AConverter is TdxImageToDCTImageConverter) and
      not TdxImageToDCTImageConverter(AConverter).UseDecodePredictorForSoftMask then
      AFilters.Add(TdxPDFFlateDecodeFilter.Create(nil))
    else
      AFilters.Add(TdxPDFFlateDecodeFilter.Create(fpPNGUpPrediction, 1, 8, AConverter.ImageSize.Width));
    Result.Filters := AFilters;

    Result.ColorSpace := TdxPDFGrayDeviceColorSpace.Create;
    Result.DecodeRanges := TdxDecodeColorRanges.Gray;
  end;
end;

class function TdxPDFImageToXObjectConverter.CreateXObject(
  AConverter: TdxImageToBitmapDataConverter): TdxPDFDocumentImage;
var
  AFilters: TdxPDFStreamFilters;
  AIndexedImageBitmapConverter: TdxIndexedImageBitmapConverter;
begin
  Result := TdxPDFDocumentImage.Create(AConverter.ImageData, AConverter.ImageSize, AConverter.BitsPerComponent);

  AFilters := TdxPDFStreamFilters.Create;
  if AConverter is TdxImageToDCTImageConverter then
    AFilters.Add(TdxPDFDCTDecodeFilter.Create(nil))
  else
    if AConverter is TdxImageBitmapConverter then
      AFilters.Add(TdxPDFFlateDecodeFilter.Create(fpPNGUpPrediction, 3, 8, AConverter.ImageSize.Width))
    else
      AFilters.Add(TdxPDFFlateDecodeFilter.Create(nil));
  Result.Filters := AFilters;

  Result.ColorSpace := CreateColorSpace(AConverter.ColorSpace);
  if AConverter is TdxIndexedImageBitmapConverter then
  begin
    AIndexedImageBitmapConverter := TdxIndexedImageBitmapConverter(AConverter);
    Result.ColorSpace.AlternateColorSpace := CreateColorSpace(AIndexedImageBitmapConverter.BaseColorSpace);
    TdxPDFIndexedColorSpace(Result.ColorSpace).MaxIndex := AIndexedImageBitmapConverter.MaxValue - 1;
    TdxPDFIndexedColorSpace(Result.ColorSpace).LookupTable := AIndexedImageBitmapConverter.LookupTable;
    Result.ColorKeyMask := AIndexedImageBitmapConverter.ColorKeyMask;
  end;
  Result.DecodeRanges := AConverter.DecodeRanges;

  Result.SoftMask := CreateSoftMaskObject(AConverter);
end;

end.
