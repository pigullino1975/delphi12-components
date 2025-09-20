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

unit dxFontIconsImageLoader;

interface

uses
  Generics.Defaults, Generics.Collections, Classes, dxSVGImage, dxGDIPlusClasses, dxGallery, dxGalleryControl;

type

  { TdxFontIconSvgBuilder }

  TdxFontIconSvgBuilder = class
  strict private
    FFontFamily: string;
    FColorName: string;
  public
    constructor Create;
    function Build(ANumber: Integer): TdxSvgImage;
    function BuildCode(ANumber: Integer): string;
    function BuildAsText(ANumber: Integer): string;
    class function GetStreamFromString(const S: string): TStream; static;

    property FontFamily: string read FFontFamily write FFontFamily;
    property ColorName: string read FColorName write FColorName;
  end;

  { TdxFontIconsGalleryLoader }

  TdxFontIconsGalleryLoader = class
  public const
    SegoeMdl2AssetsName = 'segoe mdl2 assets';
    SegoeFluentIconsName = 'segoe fluent icons';
    CategoryName = 'Font Icons';
    DefaultCaption = 'font-icon';
    DefaultColor = 'Black';
    SvgExt = '.svg';
  strict private
    class function GetIconFontIsAvailable: Boolean; static;
    class function GetSegoeMDL2IsAvailable: Boolean; static;
    class function GetSegoeFluentIconsIsAvailable: Boolean; static;
    class function IsFontFamilyExists(const AFontFamily: string): Boolean; static;
  protected
    class function GetFontFamilies: TArray<string>; static;
    class function CreateItem(AGroup: TdxGalleryControlGroup; ASvgImage: TdxSvgImage; ANum: Integer): TdxGalleryItem; static;
    class function GetFirstExistingFont(const ANames: TArray<string>): TdxGpFont; static;
    class function GetFontUnicodeIndexes(AFont: TdxGPFont): TList<Integer>; static;

    class property SegoeMDL2IsAvailable: Boolean read GetSegoeMDL2IsAvailable;
    class property SegoeFluentIconsIsAvailable: Boolean read GetSegoeFluentIconsIsAvailable;
  public
    class procedure Populate(AGalleryControl: TdxGalleryControl); static;
    class property IconFontIsAvailable: Boolean read GetIconFontIsAvailable;
  end;



implementation

uses
  Windows, SysUtils, dxSVGCore, dxFontIconsMetadata;

const
  ColorValues: array [0..5] of record ColorName: string; ColorValue: string end =
    ((ColorName: 'Black';   ColorValue: '#727272'),
     (ColorName: 'Red';     ColorValue: '#D11C1C'),
     (ColorName: 'Green';   ColorValue: '#039C23'),
     (ColorName: 'Blue';    ColorValue: '#1177D7'),
     (ColorName: 'Yellow';  ColorValue: '#FFB115'),
     (ColorName: 'White';   ColorValue: '#FFFFFF'));

function GetStandartColorValue(const AColorName, ADefaultValue: string): string;
var
  I: Integer;
begin
  Result := ADefaultValue;
  for I := Low(ColorValues) to High(ColorValues) do
    if ColorValues[I].ColorName = AColorName then
      Exit(ColorValues[I].ColorValue);
end;

{ TdxFontIconSvgBuilder }

constructor TdxFontIconSvgBuilder.Create;
begin
  FontFamily := TdxFontIconsResolver.fontIconsFamily;
  ColorName := 'Black';
end;

function TdxFontIconSvgBuilder.Build(ANumber: Integer): TdxSvgImage;
var
  AStream: TStream;
begin
  AStream := GetStreamFromString(BuildCode(ANumber));
  try
    Exit(TdxSvgImage.CreateFromStream(AStream));
  finally
    AStream.Free;
  end;
end;

function TdxFontIconSvgBuilder.BuildCode(ANumber: Integer): string;
begin
  Result := BuildAsText(ANumber);
end;

function TdxFontIconSvgBuilder.BuildAsText(ANumber: Integer): string;
begin
  Result := Format(
   '<?xml version=''1.0'' encoding=''UTF-8''?>'#13#10 +
   '<svg version="1.1" id="Layer1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"'+
   ' x="0px" y="0px" viewBox="0 0 32 32" style="enable-background:new 0 0 32 32;" xml:space="preserve">'#13#10 +
   '  <style type="text/css">'#13#10 +
   '    .%s'#13#10 +
   '    {'#13#10 +
   '      fill:%s;'#13#10 +
   '      font-family:''%s'';'#13#10 +
   '      font-size:32px;'#13#10 +
   '    }'#13#10 +
   '  </style>'#13#10 +
   '  <text x="0" y="32" class="%s">%s</text>'#13#10 +
   '</svg>";',
   [ColorName, GetStandartColorValue(ColorName, '#FFB115'), FontFamily, ColorName, Char(ANumber)]);
end;

class function TdxFontIconSvgBuilder.GetStreamFromString(const S: string): TStream;
var
  AData: TBytes;
begin
  Result := TBytesStream.Create;
  AData := TEncoding.UTF8.GetPreamble;
  Result.Write(AData, Length(AData));
  AData := TEncoding.UTF8.GetBytes(S);
  Result.Write(AData, Length(AData));
  Result.Position := 0;
end;

{ TdxFontIconsGalleryLoader }

class function TdxFontIconsGalleryLoader.GetIconFontIsAvailable: Boolean;
begin
  Result := SegoeMDL2IsAvailable or SegoeFluentIconsIsAvailable;
end;

class function TdxFontIconsGalleryLoader.GetFontFamilies: TArray<string>;
begin
  Result := TArray<string>.Create(SegoeFluentIconsName, SegoeMdl2AssetsName);
end;

class function TdxFontIconsGalleryLoader.GetSegoeMDL2IsAvailable: Boolean;
begin
  Result := IsFontFamilyExists(SegoeMdl2AssetsName);
end;

class function TdxFontIconsGalleryLoader.IsFontFamilyExists(const AFontFamily: string): Boolean;
var
  F: TdxGPFontFamily;
begin
  F := TdxGPFontFamily.Create(AFontFamily);
  try
    Result := F.Handle <> nil;
  finally
    F.Free;
  end;
end;

class function TdxFontIconsGalleryLoader.GetSegoeFluentIconsIsAvailable: Boolean;
begin
  Result := IsFontFamilyExists(SegoeFluentIconsName);
end;

class function TdxFontIconsGalleryLoader.GetFirstExistingFont(const ANames: TArray<string>): TdxGpFont;
var
  AFamily: TdxGpFontFamily;
  AName: string;
begin
  for AName in ANames do
  begin
    AFamily := TdxGPFontFamily.Create(AName);
    try
      if AFamily.Handle <> nil then
        Exit(TdxGpFont.Create(AFamily, 10));
    finally
      AFamily.Free;
    end;
  end;
  Result := nil;
end;

class procedure TdxFontIconsGalleryLoader.Populate(AGalleryControl: TdxGalleryControl);
var
  AFamilies: TArray<string>;
  ASvgBuilder: TdxFontIconSvgBuilder;
  ANums: TList<Integer>;
  ANum: Integer;
  AFont: TdxGPFont;
  AGroup: TdxGalleryControlGroup;
  AImage: TdxSVGImage;
begin
  AFamilies := GetFontFamilies;
  AFont := GetFirstExistingFont(AFamilies);
  if AFont = nil then
    Exit;
  AGalleryControl.BeginUpdate;
  try
    AGroup := AGalleryControl.Gallery.Groups[0];
    try
      ASvgBuilder := TdxFontIconSvgBuilder.Create;
      try
        ANums := GetFontUnicodeIndexes(AFont);
        try
          for ANum in ANums do
          begin
            if ANum <= 32 then
              Continue;
            AImage := ASvgBuilder.Build(ANum);
            try
              CreateItem(AGroup, AImage, ANum);
            finally
              AImage.Free;
            end;
          end;
        finally
          ANums.Free;
        end;
      finally
        ASvgBuilder.Free;
      end;
    finally
      AFont.Free;
    end;
  finally
    AGalleryControl.EndUpdate;
  end;
end;

class function TdxFontIconsGalleryLoader.CreateItem(AGroup: TdxGalleryControlGroup; ASvgImage: TdxSvgImage; ANum: Integer): TdxGalleryItem;
var
  AHint: string;
  ATags: TArray<string>;
begin
  if TdxFontIconTags.Map.TryGetValue(ANum, ATags) then
    AHint := ATags[0]
  else
    AHint := DefaultCaption + ANum.ToString;
  Result := AGroup.Items.Add;
  Result.Glyph.Assign(ASvgImage);
  Result.Hint := AHint;
  Result.Tag := ANum;
end;

class function TdxFontIconsGalleryLoader.GetFontUnicodeIndexes(AFont: TdxGpFont): TList<Integer>;
var
  AFirst, ALast: Word;
  AHdc, AHFont, APrev: THandle;
  AGlyphSet: PGlyphSet;
  ASize, ACount, I, N: Integer;
  ARange: PWCRange;
begin
  Result := TList<Integer>.Create;
  AHdc := CreateCompatibleDC(0);
  try
    AHFont := AFont.ToHfont;
    APrev := SelectObject(AHdc, AHFont);
    ASize := GetFontUnicodeRanges(AHdc, nil);
    AGlyphSet := AllocMem(ASize);
    try
      GetFontUnicodeRanges(AHdc, AGlyphSet);
      ARange := @AGlyphSet.ranges[0];
      ACount := AGlyphSet.cRanges;
      for I := 0 to ACount - 1 do
      begin
        AFirst := Ord(ARange.wcLow);
        ALast := AFirst + ARange.cGlyphs - 1;
        for N := AFirst to ALast do
          if N >= $E700 then
            Result.Add(N);
        Inc(ARange);
      end;
    finally
      SelectObject(AHdc, APrev);
      FreeMem(AGlyphSet);
    end;
  finally
    DeleteDC(AHdc);
  end;
end;

end.
