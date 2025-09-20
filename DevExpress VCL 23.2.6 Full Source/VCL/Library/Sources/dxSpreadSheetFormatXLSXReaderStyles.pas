{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSpreadSheet                                       }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSPREADSHEET CONTROL AND ALL    }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
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

unit dxSpreadSheetFormatXLSXReaderStyles;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, dxCore, dxCoreClasses, cxClasses, dxCustomTree, dxXMLDoc, dxZIPUtils,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxSpreadSheetStrs, dxSpreadSheetPackedFileFormatCore,
  dxSpreadSheetUtils, dxGDIPlusClasses, Generics.Defaults, Generics.Collections, dxCoreGraphics, cxGeometry,
  dxSpreadSheetPrinting, dxSpreadSheetConditionalFormattingRules, dxSpreadSheetContainers, dxSpreadSheetProtection,
  dxHashUtils, Variants, dxSpreadSheetCoreStyles, dxSpreadSheetFormatUtils, dxXMLReader, dxSpreadSheetFormatXLSXReader,
  dxSpreadSheetFormatXLSXTags, dxSpreadSheetGraphics, dxXMLReaderUtils;

type

  { TdxXLSXAdvancedColorHandler }

  TdxXLSXAdvancedColorHandler = class(TdxXLSXNodeHandler)
  strict private
    FColor: PdxAlphaColor;

    function ProcessAlpha(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessCustomColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessLumMod(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessLumOff(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessShade(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessSystemColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessThemedColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    FLumOffset: Variant;
    FLumMod: Variant;
    FShade: Variant;
    FValue: TColor;
    FValueAlpha: Byte;

    function CalculateColor: TdxAlphaColor;
  public
    constructor Create(AOwner: TObject; AColor: PdxAlphaColor); reintroduce;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXCustomBrushHandler }

  TdxXLSXCustomBrushHandler = class(TdxXLSXNodeHandler)
  strict private
    FBrush: TdxGPBrush;
  public
    constructor Create(AOwner, AData: TObject); override;
    //
    property Brush: TdxGPBrush read FBrush;
  end;

  { TdxXLSXEmptyBrushHandler }

  TdxXLSXEmptyBrushHandler = class(TdxXLSXCustomBrushHandler)
  public
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXGradientBrushHandler }

  TdxXLSXGradientBrushHandler = class(TdxXLSXCustomBrushHandler)
  strict private
    function ProcessGradientStops(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessLinearGradientOptions(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXPatternBrushHandler }

  TdxXLSXPatternBrushHandler = class(TdxXLSXCustomBrushHandler)
  strict private
    FBackgroundColor: TdxAlphaColor;
    FForegroundColor: TdxAlphaColor;
    FPreset: string;

    function CreateBackgroundColorHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function CreateForegroundColorHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXSolidBrushHandler }

  TdxXLSXSolidBrushHandler = class(TdxXLSXCustomBrushHandler)
  strict private
    FColorHandler: TdxXLSXAdvancedColorHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
  end;

  { TdxXLSXTexturedBrushHandler }

  TdxXLSXTexturedBrushHandler = class(TdxXLSXCustomBrushHandler)
  strict private
    function ProcessBlip(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXPenHandler }

  TdxXLSXPenHandler = class(TdxXLSXNodeHandler)
  strict private
    FPen: TdxGPPen;

    function ProcessPenDash(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property Pen: TdxGPPen read FPen;
  end;

  { TdxXLSXIndexedColorsReader }

  TdxXLSXIndexedColorsReader = class(TdxXLSXCustomDocumentReader)
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXStyleReader }

  TdxXLSXStyleReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FCellStyleXF: TcxObjectList;
    FCellXF: TcxObjectList;

    function CreateCellStyleXF(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function CreateCellXF(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    procedure ImportCellStyles;
  public
    constructor Create(const AFileName: string; AOwner: TdxSpreadSheetXLSXReader;
      AProgressHelper: TcxCustomProgressCalculationHelper = nil); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXThemeReader }

  TdxXLSXThemeReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FThemeData: TdxXLSXReaderThemeData;
  public
    constructor Create(const AFileName: string; AOwner: TdxSpreadSheetXLSXReader; AData: TdxXLSXReaderThemeData); reintroduce;
    procedure AfterConstruction; override;
    //
    property ThemeData: TdxXLSXReaderThemeData read FThemeData;
  end;

implementation

uses
  Math,
  cxGraphics,
  dxGenerics,
  dxSpreadSheetCoreStrs,
  dxSpreadSheetFormatXLSX, dxSpreadSheetFormatXLSXUtils;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXReaderStyles';

type
  TdxSpreadSheetReaderAccess = class(TdxSpreadSheetXLSXReader);
  TdxXLSXStylesFillCollectionHandler = class;
  TdxXLSXStylesFontCollectionHandler = class;

  { TdxXLSXCellStyle }

  TdxXLSXCellStyle = class
  public
    ApplyAlignment: Boolean;
    ApplyBorder: Boolean;
    ApplyFill: Boolean;
    ApplyFont: Boolean;
    ApplyNumberFormat: Boolean;
    ApplyProtection: Boolean;

    // General
    BorderId: Integer;
    FillId: Integer;
    FontId: Integer;
    NumberFormatId: Integer;

    // Alignment
    AlignHorz: TdxSpreadSheetDataAlignHorz;
    AlignHorzIndent: Integer;
    AlignVert: TdxSpreadSheetDataAlignVert;
    Rotation: Integer;
    ShrinkToFit: Boolean;
    WordWrap: Boolean;

    // Protection
    Locked: Boolean;
    Hidden: Boolean;

    constructor Create;
    procedure Assign(ASource: TdxXLSXCellStyle);
  end;

  { TdxXLSXCellStyleHandler }

  TdxXLSXCellStyleHandler = class(TdxXLSXNodeHandler)
  strict private
    FStyle: TdxXLSXCellStyle;
  protected
    function ProcessAlignment(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessProtection(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property Style: TdxXLSXCellStyle read FStyle;
  end;

  { TdxXLSXCellStyleCollectionHandler }

  TdxXLSXCellStyleCollectionHandler = class(TdxXLSXNodeHandler)
  strict private
    FCollection: TcxObjectList;
    FDefaultCollection: TcxObjectList;

    function CreateStyleHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner: TdxXLSXCustomDocumentReader; ACollection, ADefaultCollection: TcxObjectList); reintroduce;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXGradientBrushStopHandler }

  TdxXLSXGradientBrushStopHandler = class(TdxXLSXCustomBrushHandler)
  strict private
    FColorHandler: TdxXLSXAdvancedColorHandler;
    FPosition: Double;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXIndexedColorsHandler }

  TdxXLSXIndexedColorsHandler = class(TdxXLSXNodeHandler)
  strict private
    FColors: TdxColorList;

    function ProcessIndexedColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXStylesCustomCollectionHandler }

  TdxXLSXStylesCustomCollectionHandler = class(TdxXLSXNodeHandler)
  protected
    FCollection: TdxHashTableItemList;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXStylesBorderHandler }

  TdxXLSXStylesBorderHandler = class(TdxXLSXNodeHandler)
  strict private
    FBorder: TcxBorder;
    FHandle: TdxSpreadSheetBordersHandle;

    function CreateColorHandler(const AData: TObject): TdxXMLNodeHandler;
  public
    constructor Create(AOwner: TdxXLSXCustomDocumentReader; AHandle: TdxSpreadSheetBordersHandle; ABorder: TcxBorder); reintroduce;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXStylesBordersHandler }

  TdxXLSXStylesBordersHandler = class(TdxXLSXStylesCustomCollectionHandler)
  strict private
    FHandle: TdxSpreadSheetBordersHandle;

    function CreateBorderHandler(const AData: TObject): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXStylesBordersCollectionHandler }

  TdxXLSXStylesBordersCollectionHandler = class(TdxXLSXStylesCustomCollectionHandler)
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXStylesColorCollectionHandler }

  TdxXLSXStylesColorCollectionHandler = class(TdxXLSXNodeHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXStylesFillHandler }

  TdxXLSXStylesFillHandler = class(TdxXLSXStylesCustomCollectionHandler)
  protected
    FHandle: TdxSpreadSheetBrushHandle;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXStylesFillCollectionHandler }

  TdxXLSXStylesFillCollectionHandler = class(TdxXLSXStylesCustomCollectionHandler)
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXStylesPatternFillHandler }

  TdxXLSXStylesPatternFillHandler = class(TdxXLSXNodeHandler)
  strict private
    function ProcessBackgroundColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessForegroundColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    FHandle: TdxSpreadSheetBrushHandle;
    FIsEmpty: Boolean;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXStylesConditionalFormattingHandler }

  TdxXLSXStylesConditionalFormattingHandler = class(TdxXLSXStylesCustomCollectionHandler)
  strict private
    FBorders: TdxHashTableItemList;
    FFills: TdxHashTableItemList;
    FFonts: TdxHashTableItemList;
    FFormats: TdxHashTableItemList;
    FStyle: TdxXLSXCellStyle;

    function ProcessAlignment(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXStylesConditionalFormattingCollectionHandler }

  TdxXLSXStylesConditionalFormattingCollectionHandler = class(TdxXLSXStylesCustomCollectionHandler)
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXStylesConditionalFormattingFillHandler }

  TdxXLSXStylesConditionalFormattingFillHandler = class(TdxXLSXStylesFillHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXStylesConditionalFormattingPatternFillHandler }

  TdxXLSXStylesConditionalFormattingPatternFillHandler = class(TdxXLSXStylesPatternFillHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXStylesFontHandler }

  TdxXLSXStylesFontHandler = class(TdxXLSXFontHandler)
  strict private
    FCollection: TdxHashTableItemList;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXStylesFontCollectionHandler }

  TdxXLSXStylesFontCollectionHandler = class(TdxXLSXStylesCustomCollectionHandler)
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXStylesNumberFormatHandler }

  TdxXLSXStylesNumberFormatHandler = class(TdxXLSXStylesCustomCollectionHandler)
  public
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXStylesNumberFormatCollectionHandler }

  TdxXLSXStylesNumberFormatCollectionHandler = class(TdxXLSXStylesCustomCollectionHandler)
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXThemeColorSchemeHandler }

  TdxXLSXThemeColorSchemeHandler = class(TdxXLSXNodeHandler)
  strict private
    FThemeData: TdxXLSXReaderThemeData;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
    //
    property ThemeData: TdxXLSXReaderThemeData read FThemeData;
  end;

  { TdxXLSXThemeColorSchemeItemHandler }

  TdxXLSXThemeColorSchemeItemHandler = class(TdxXLSXNodeHandler)
  strict private
    FThemeData: TdxXLSXReaderThemeData;
  protected
    FColorId: string;
    FColorValue: TColor;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property ThemeData: TdxXLSXReaderThemeData read FThemeData;
  end;

  { TdxXLSXThemeColorSchemeItemCustomValueHandler }

  TdxXLSXThemeColorSchemeItemCustomValueHandler = class(TdxXLSXNodeHandler)
  protected
    FOwner: TdxXLSXThemeColorSchemeItemHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXThemeColorSchemeItemSystemValueHandler }

  TdxXLSXThemeColorSchemeItemSystemValueHandler = class(TdxXLSXThemeColorSchemeItemCustomValueHandler)
  public
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXThemeFormatSchemeBrushHandler }

  TdxXLSXThemeFormatSchemeBrushHandler = class(TdxXLSXNodeHandler)
  strict private
    FThemeData: TdxXLSXReaderThemeData;

    function CreateBrushHandler(const AData: TObject): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXThemeFormatSchemePenHandler }

  TdxXLSXThemeFormatSchemePenHandler = class(TdxXLSXNodeHandler)
  strict private
    FThemeData: TdxXLSXReaderThemeData;
  public
    constructor Create(AOwner, AData: TObject); override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
  end;

  { TdxXLSXThemeFormatSchemeHandler }

  TdxXLSXThemeFormatSchemeHandler = class(TdxXLSXNodeHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXThemeElementsHandler }

  TdxXLSXThemeElementsHandler = class(TdxXLSXNodeHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

{ TdxXLSXCellStyle }

constructor TdxXLSXCellStyle.Create;
begin
  AlignHorz := ssahGeneral;
  AlignHorzIndent := 0;
  AlignVert := ssavBottom;
  ApplyAlignment := True;
  ApplyBorder := True;
  ApplyFill := True;
  ApplyFont := True;
  ApplyNumberFormat := True;
  ApplyProtection := True;
  BorderId := -1;
  FillId := -1;
  FontId := -1;
  Hidden := False;
  Locked := True;
  NumberFormatId := -1;
  Rotation := 0;
  ShrinkToFit := False;
  WordWrap := False;
end;

procedure TdxXLSXCellStyle.Assign(ASource: TdxXLSXCellStyle);
begin
  AlignHorz := ASource.AlignHorz;
  AlignHorzIndent := ASource.AlignHorzIndent;
  AlignVert := ASource.AlignVert;
  ApplyAlignment := ASource.ApplyAlignment;
  ApplyBorder := ASource.ApplyBorder;
  ApplyFill := ASource.ApplyFill;
  ApplyFont := ASource.ApplyFont;
  ApplyNumberFormat := ASource.ApplyNumberFormat;
  ApplyProtection := ASource.ApplyProtection;
  BorderId := ASource.BorderId;
  FillId := ASource.FillId;
  FontId := ASource.FontId;
  Hidden := ASource.Hidden;
  Locked := ASource.Locked;
  NumberFormatId := ASource.NumberFormatId;
  Rotation := ASource.Rotation;
  ShrinkToFit := ASource.ShrinkToFit;
  WordWrap := ASource.WordWrap;
end;

{ TdxXLSXCellStyleHandler }

constructor TdxXLSXCellStyleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FStyle := AData as TdxXLSXCellStyle;
  Handlers.Add(sdxXLSXNodeAlignment, ProcessAlignment);
  Handlers.Add(sdxXLSXNodeProtection, ProcessProtection);
end;

procedure TdxXLSXCellStyleHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrApplyAlignment, AValue) then
    FStyle.ApplyAlignment := TdxXMLHelper.DecodeBoolean(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrApplyBorder, AValue) then
    FStyle.ApplyBorder := TdxXMLHelper.DecodeBoolean(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrApplyFill, AValue) then
    FStyle.ApplyFill := TdxXMLHelper.DecodeBoolean(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrApplyFont, AValue) then
    FStyle.ApplyFont := TdxXMLHelper.DecodeBoolean(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrApplyNumberFormat, AValue) then
    FStyle.ApplyNumberFormat := TdxXMLHelper.DecodeBoolean(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrApplyProtection, AValue) then
    FStyle.ApplyProtection := TdxXMLHelper.DecodeBoolean(AValue);

  if AReader.TryGetAttribute(sdxXLSXAttrBorderId, AValue) then
    FStyle.BorderId := StrToIntDef(AValue, 0);
  if AReader.TryGetAttribute(sdxXLSXAttrFillId, AValue) then
    FStyle.FillId := StrToIntDef(AValue, 0);
  if AReader.TryGetAttribute(sdxXLSXAttrFontId, AValue) then
    FStyle.FontId := StrToIntDef(AValue, 0);
  if AReader.TryGetAttribute(sdxXLSXAttrNumFmtId, AValue) then
    FStyle.NumberFormatId := StrToIntDef(AValue, 0);
end;

function TdxXLSXCellStyleHandler.ProcessAlignment(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrHorizontal, AValue) then
    FStyle.AlignHorz := TdxSpreadSheetXLSXHelper.StringToAlignHorz(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrIndent, AValue) then
    FStyle.AlignHorzIndent := StrToIntDef(AValue, 0);
  if AReader.TryGetAttribute(sdxXLSXAttrVertical, AValue) then
    FStyle.AlignVert := TdxSpreadSheetXLSXHelper.StringToAlignVert(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrTextRotation, AValue) then
    FStyle.Rotation := StrToIntDef(AValue, 0);
  if AReader.TryGetAttribute(sdxXLSXAttrShrinkToFit, AValue) then
    FStyle.ShrinkToFit := TdxXMLHelper.DecodeBoolean(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrWrapText, AValue) then
    FStyle.WordWrap := TdxXMLHelper.DecodeBoolean(AValue);
  Result := nil;
end;

function TdxXLSXCellStyleHandler.ProcessProtection(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrLocked, AValue) then
    FStyle.Locked := TdxXMLHelper.DecodeBoolean(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrHidden, AValue) then
    FStyle.Hidden := TdxXMLHelper.DecodeBoolean(AValue);
  Result := nil;
end;

{ TdxXLSXCellStyleCollectionHandler }

constructor TdxXLSXCellStyleCollectionHandler.Create(
  AOwner: TdxXLSXCustomDocumentReader; ACollection, ADefaultCollection: TcxObjectList);
begin
  FCollection := ACollection;
  FDefaultCollection := ADefaultCollection;
  inherited Create(AOwner, nil);
  Handlers.Add(sdxXLSXNodeStyleCellXf, CreateStyleHandler);
end;

procedure TdxXLSXCellStyleCollectionHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FCollection.Capacity := Max(FCollection.Capacity, FCollection.Count + AReader.GetAttributeAsInteger(sdxXLSXAttrCount));
end;

function TdxXLSXCellStyleCollectionHandler.CreateStyleHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AIndex: Integer;
  AStyle: TdxXLSXCellStyle;
  AValue: string;
begin
  AStyle := TdxXLSXCellStyle.Create;
  if (FDefaultCollection <> nil) and AReader.TryGetAttribute(sdxXLSXAttrXFId, AValue) then
  begin
    AIndex := StrToIntDef(AValue, -1);
    if InRange(AIndex, 0, FDefaultCollection.Count - 1) then
      AStyle.Assign(TdxXLSXCellStyle(FDefaultCollection.List[AIndex]));
  end;
  FCollection.Add(AStyle);
  Result := TdxXLSXCellStyleHandler.Create(Owner, AStyle);
end;

{ TdxXLSXGradientBrushStopHandler }

constructor TdxXLSXGradientBrushStopHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FColorHandler := TdxXLSXAdvancedColorHandler.Create(Owner, nil);
  FColorHandler.AddReference;
end;

destructor TdxXLSXGradientBrushStopHandler.Destroy;
begin
  Brush.GradientPoints.Add(FPosition, FColorHandler.CalculateColor);
  FColorHandler.RemoveReference;
  inherited;
end;

function TdxXLSXGradientBrushStopHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := FColorHandler.CreateHandler(AReader);
end;

procedure TdxXLSXGradientBrushStopHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FPosition := TdxXLSXUtils.DecodePercents(AReader.GetAttributeAsInteger(sdxXLSXAttrGradientPointPos));
  FPosition := Min(Max(FPosition, 0), 100) / 100;
end;

{ TdxXLSXAdvancedColorHandler }

constructor TdxXLSXAdvancedColorHandler.Create(AOwner: TObject; AColor: PdxAlphaColor);
begin
  inherited Create(AOwner, nil);
  FColor := AColor;
  FLumMod := Null;
  FLumOffset := Null;
  FShade := Null;
  FValue := clDefault;
  FValueAlpha := MaxByte;
end;

procedure TdxXLSXAdvancedColorHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeColorAlpha, ProcessAlpha);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeLumMod, ProcessLumMod);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeLumOff, ProcessLumOff);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeSchemeColor, ProcessThemedColor);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeShade, ProcessShade);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeSystemColor, ProcessSystemColor);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesCustomColor, ProcessCustomColor);
end;

procedure TdxXLSXAdvancedColorHandler.BeforeDestruction;
begin
  inherited;
  if FColor <> nil then
    FColor^ := CalculateColor;
end;

function TdxXLSXAdvancedColorHandler.CalculateColor: TdxAlphaColor;
var
  AColor: TColor;
  AColorHSL: TdxHSL;
begin
  Result := TdxAlphaColors.Empty;
  if cxColorIsValid(FValue) then
  begin
    AColor := FValue;
    if not (VarIsNull(FLumOffset) and VarIsNull(FLumMod)) then
    begin
      AColorHSL := TdxColorUtils.ColorToHSL(AColor);
      if not VarIsNull(FLumMod) then
        AColorHSL.L := AColorHSL.L * FLumMod / 100;
      if not VarIsNull(FLumOffset) then
        AColorHSL.L := AColorHSL.L + FLumOffset / 100;
      AColorHSL.L := Min(Max(AColorHSL.L, 0), 1);
      AColor := TdxColorUtils.HSLToColor(AColorHSL);
    end;
    if not VarIsNull(FShade) then
      AColor := dxGetMiddleRGB(AColor, clGray, Trunc(FShade));
    Result := dxColorToAlphaColor(AColor, FValueAlpha);
  end;
end;

function TdxXLSXAdvancedColorHandler.ProcessAlpha(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FValueAlpha := TdxXLSXUtils.DecodeColorAlpha(AReader.GetAttributeAsInteger(sdxXLSXAttrVal));
  Result := nil;
end;

function TdxXLSXAdvancedColorHandler.ProcessCustomColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FValue := TdxXLSXUtils.DecodeColor(AReader.GetAttribute(sdxXLSXAttrVal));
  Result := Self;
end;

function TdxXLSXAdvancedColorHandler.ProcessLumMod(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FLumMod := TdxXLSXUtils.DecodePercents(AReader.GetAttributeAsInteger(sdxXLSXAttrVal));
  Result := nil;
end;

function TdxXLSXAdvancedColorHandler.ProcessLumOff(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FLumOffset := TdxXLSXUtils.DecodePercents(AReader.GetAttributeAsInteger(sdxXLSXAttrVal));
  Result := nil;
end;

function TdxXLSXAdvancedColorHandler.ProcessShade(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FShade := TdxXLSXUtils.DecodePercents(AReader.GetAttributeAsInteger(sdxXLSXAttrVal));
  Result := nil;
end;

function TdxXLSXAdvancedColorHandler.ProcessSystemColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FValue := TdxXLSXUtils.DecodeColor(AReader.GetAttribute(sdxXLSXAttrLastColor));
  Result := nil;
end;

function TdxXLSXAdvancedColorHandler.ProcessThemedColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AColor: TColor;
begin
  if Owner.Owner.ThemeData.ColorMap.TryGetValue(AReader.GetAttribute(sdxXLSXAttrVal), AColor) then
    FValue := AColor
  else
    FValue := clNone;

  Result := Self;
end;

{ TdxXLSXIndexedColorsHandler }

constructor TdxXLSXIndexedColorsHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FColors := AData as TdxColorList;
  Handlers.Add('rgbColor', ProcessIndexedColor);
end;

function TdxXLSXIndexedColorsHandler.ProcessIndexedColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FColors.Add(TdxXLSXUtils.DecodeColor(AReader.GetAttribute(sdxXLSXAttrRGB)));
  Result := nil;
end;

{ TdxXLSXStylesCustomCollectionHandler }

constructor TdxXLSXStylesCustomCollectionHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FCollection := AData as TdxHashTableItemList;
end;

procedure TdxXLSXStylesCustomCollectionHandler.OnAttributes(const AReader: TdxXmlReader);
var
  ACount: Integer;
begin
  ACount := AReader.GetAttributeAsInteger(sdxXLSXAttrCount);
  if ACount > 0 then
    FCollection.Capacity := Max(FCollection.Capacity, FCollection.Count + ACount);
end;

{ TdxXLSXStylesBorderHandler }

constructor TdxXLSXStylesBorderHandler.Create(AOwner: TdxXLSXCustomDocumentReader;
  AHandle: TdxSpreadSheetBordersHandle; ABorder: TcxBorder);
begin
  inherited Create(AOwner, nil);
  FHandle := AHandle;
  FBorder := ABorder;
  Handlers.Add(sdxXLSXNodeColor, CreateColorHandler, nil);
end;

function TdxXLSXStylesBorderHandler.CreateColorHandler(const AData: TObject): TdxXMLNodeHandler;
begin
  Result := TdxXLSXColorHandler.Create(Owner, @FHandle.BorderColor[FBorder]);
end;

procedure TdxXLSXStylesBorderHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FHandle.BorderStyle[FBorder] := TdxSpreadSheetXLSXHelper.StringToBorderStyle(AReader.GetAttribute(sdxXLSXAttrStyle));
end;

{ TdxXLSXStylesBordersHandler }

constructor TdxXLSXStylesBordersHandler.Create(AOwner, AData: TObject);
var
  ABorder: TcxBorder;
begin
  inherited;
  FHandle := TdxSpreadSheetReaderAccess(Owner.Owner).CreateTempBordersHandle;
  for ABorder := Low(ABorder) to High(ABorder) do
    Handlers.Add(dxXLSXBorderNames[ABorder], CreateBorderHandler, TObject(ABorder));
end;

procedure TdxXLSXStylesBordersHandler.BeforeDestruction;
begin
  inherited;
  FCollection.Add(TdxSpreadSheetReaderAccess(Owner.Owner).AddBorders(FHandle));
end;

function TdxXLSXStylesBordersHandler.CreateBorderHandler(const AData: TObject): TdxXMLNodeHandler;
begin
  Result := TdxXLSXStylesBorderHandler.Create(Owner, FHandle, TcxBorder(AData));
end;

{ TdxXLSXStylesBordersCollectionHandler }

procedure TdxXLSXStylesBordersCollectionHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeStyleBorder, TdxXLSXStylesBordersHandler, FCollection);
end;

{ TdxXLSXStylesColorCollectionHandler }

constructor TdxXLSXStylesColorCollectionHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add('indexedColors', TdxXLSXIndexedColorsHandler, AData);
end;

{ TdxXLSXStylesConditionalFormattingHandler }

constructor TdxXLSXStylesConditionalFormattingHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FStyle := TdxXLSXCellStyle.Create;
  FStyle.ApplyAlignment := False;
  FBorders := TdxHashTableItemList.Create;
  FFills := TdxHashTableItemList.Create;
  FFonts := TdxHashTableItemList.Create;
  FFormats := TdxHashTableItemList.Create;
end;

destructor TdxXLSXStylesConditionalFormattingHandler.Destroy;
begin
  FreeAndNil(FBorders);
  FreeAndNil(FFormats);
  FreeAndNil(FFills);
  FreeAndNil(FFonts);
  FreeAndNil(FStyle);
  inherited;
end;

procedure TdxXLSXStylesConditionalFormattingHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeAlignment, ProcessAlignment);
  Handlers.Add(sdxXLSXNodeStyleBorder, TdxXLSXStylesBordersHandler, FBorders);
  Handlers.Add(sdxXLSXNodeStyleFill, TdxXLSXStylesConditionalFormattingFillHandler, FFills);
  Handlers.Add(sdxXLSXNodeStyleFont, TdxXLSXStylesFontHandler, FFonts);
  Handlers.Add(sdxXLSXNodeStyleNumberFormat, TdxXLSXStylesNumberFormatHandler, FFormats);
end;

procedure TdxXLSXStylesConditionalFormattingHandler.BeforeDestruction;
var
  AHandle: TdxSpreadSheetCellStyleHandle;
begin
  inherited;

  AHandle := TdxSpreadSheetReaderAccess(Owner.Owner).CreateTempCellStyle(
    TdxSpreadSheetFontHandle(FFonts.FirstOrNil),
    TdxSpreadSheetFormatHandle(FFormats.FirstOrNil),
    TdxSpreadSheetBrushHandle(FFills.FirstOrNil),
    TdxSpreadSheetBordersHandle(FBorders.FirstOrNil)
  );

  if FStyle.ApplyAlignment then
  begin
    AHandle.States := [];
    if FStyle.ShrinkToFit then
      AHandle.States := AHandle.States + [csShrinkToFit];
    if FStyle.WordWrap then
      AHandle.States := AHandle.States + [csWordWrap];

    AHandle.AlignVert := FStyle.AlignVert;
    AHandle.AlignHorz := FStyle.AlignHorz;
    AHandle.AlignHorzIndent := Owner.Owner.ColumnWidthHelper.SpacesNumberToPixels(FStyle.AlignHorzIndent);
    AHandle.Rotation := FStyle.Rotation;
  end;

  FCollection.Add(TdxSpreadSheetReaderAccess(Owner.Owner).AddCellStyle(AHandle));
end;

function TdxXLSXStylesConditionalFormattingHandler.ProcessAlignment(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AHandler: TdxXLSXCellStyleHandler;
begin
  AHandler := TdxXLSXCellStyleHandler.Create(Owner, FStyle);
  try
    AHandler.ProcessAlignment(AReader);
    FStyle.ApplyAlignment := True;
  finally
    AHandler.Free;
  end;
  Result := nil;
end;

{ TdxXLSXStylesConditionalFormattingCollectionHandler }

procedure TdxXLSXStylesConditionalFormattingCollectionHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeDXF, TdxXLSXStylesConditionalFormattingHandler, FCollection);
end;

{ TdxXLSXStylesConditionalFormattingFillHandler }

constructor TdxXLSXStylesConditionalFormattingFillHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNodeCellStylePatternFill, TdxXLSXStylesConditionalFormattingPatternFillHandler, FHandle);
end;

{ TdxXLSXStylesConditionalFormattingPatternFillHandler }

constructor TdxXLSXStylesConditionalFormattingPatternFillHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FHandle.BackgroundColor := clNone;
  FHandle.ForegroundColor := clNone;
end;

procedure TdxXLSXStylesConditionalFormattingPatternFillHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FHandle.Style := TdxSpreadSheetXLSXHelper.StringToFillStyle(AReader.GetAttribute(sdxXLSXAttrPatternType));
end;

{ TdxXLSXStylesFillHandler }

constructor TdxXLSXStylesFillHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FHandle := TdxSpreadSheetReaderAccess(Owner.Owner).CreateTempBrushHandle;
  Handlers.Add(sdxXLSXNodeCellStylePatternFill, TdxXLSXStylesPatternFillHandler, FHandle);
end;

procedure TdxXLSXStylesFillHandler.BeforeDestruction;
begin
  inherited;
  FCollection.Add(TdxSpreadSheetReaderAccess(Owner.Owner).AddBrush(FHandle));
end;

{ TdxXLSXStylesPatternFillHandler }

constructor TdxXLSXStylesPatternFillHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FHandle := AData as TdxSpreadSheetBrushHandle;
  Handlers.Add(sdxXLSXNodeBackgroundColor, ProcessBackgroundColor);
  Handlers.Add(sdxXLSXNodeForegroundColor, ProcessForegroundColor);
end;

procedure TdxXLSXStylesPatternFillHandler.BeforeDestruction;
begin
  inherited;
  if (FHandle.Style = sscfsSolid) and (FHandle.ForegroundColor <> clNone) then
    FHandle.BackgroundColor := FHandle.ForegroundColor;
end;

procedure TdxXLSXStylesPatternFillHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrPatternType, AValue) and (AValue <> sdxXLSXValueNone) then
    FHandle.Style := TdxSpreadSheetXLSXHelper.StringToFillStyle(AValue)
  else
    FIsEmpty := True;
end;

function TdxXLSXStylesPatternFillHandler.ProcessBackgroundColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if FIsEmpty then
    Result := nil
  else
    Result := TdxXLSXColorHandler.Create(Owner, @FHandle.BackgroundColor);
end;

function TdxXLSXStylesPatternFillHandler.ProcessForegroundColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if FIsEmpty then
    Result := nil
  else
    Result := TdxXLSXColorHandler.Create(Owner, @FHandle.ForegroundColor);
end;

{ TdxXLSXStylesFillCollectionHandler }

procedure TdxXLSXStylesFillCollectionHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeStyleFill, TdxXLSXStylesFillHandler, FCollection);
end;

{ TdxXLSXStylesFontHandler }

constructor TdxXLSXStylesFontHandler.Create(AOwner, AData: TObject);
begin
  FCollection := AData as TdxHashTableItemList;
  inherited Create(AOwner, TdxSpreadSheetReaderAccess(TdxXLSXCustomDocumentReader(AOwner).Owner).CreateTempFontHandle);
end;

procedure TdxXLSXStylesFontHandler.BeforeDestruction;
begin
  inherited;
  FCollection.Add(TdxSpreadSheetReaderAccess(Owner.Owner).AddFont(FHandle));
end;

{ TdxXLSXStylesFontCollectionHandler }

procedure TdxXLSXStylesFontCollectionHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeStyleFont, TdxXLSXStylesFontHandler, FCollection);
end;

procedure TdxXLSXStylesFontCollectionHandler.BeforeDestruction;
begin
  inherited;
  if FCollection.Count > 0 then
    Owner.SpreadSheet.CellStyles.Fonts.DefaultFont.Assign(TdxSpreadSheetFontHandle(FCollection.First));
end;

{ TdxXLSXStylesNumberFormatHandler }

procedure TdxXLSXStylesNumberFormatHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FCollection.Add(
    TdxSpreadSheetReaderAccess(Owner.Owner).AddNumberFormat(
      AReader.GetAttribute(sdxXLSXAttrFormatCode),
      AReader.GetAttributeAsInteger(sdxXLSXAttrNumFmtId, -1)));
end;

{ TdxXLSXStylesNumberFormatCollectionHandler }

procedure TdxXLSXStylesNumberFormatCollectionHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeStyleNumberFormat, TdxXLSXStylesNumberFormatHandler, FCollection);
end;

{ TdxXLSXThemeColorSchemeHandler }

constructor TdxXLSXThemeColorSchemeHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FThemeData := AData as TdxXLSXReaderThemeData;
end;

procedure TdxXLSXThemeColorSchemeHandler.BeforeDestruction;
const
  Names: array[0..11] of string = (
    'lt1', 'dk1', 'lt2', 'dk2', 'accent1', 'accent2', 'accent3',
    'accent4', 'accent5', 'accent6', 'hlink', 'folHlink'
  );
var
  AColor: TColor;
  I: Integer;
begin
  inherited;

  for I := Low(Names) to High(Names) do
  begin
    if not ThemeData.ColorMap.TryGetValue(Names[I], AColor) then
    begin
      AColor := clDefault;
      ThemeData.ColorMap.Add(Names[I], AColor);
    end;
    ThemeData.AddColor(AColor);
  end;

  ThemeData.ColorMap.AddOrSetValue('tx1', ThemeData.ColorMap.Items['dk2']);
  ThemeData.ColorMap.AddOrSetValue('tx2', ThemeData.ColorMap.Items['dk1']);
  ThemeData.ColorMap.AddOrSetValue('bg1', ThemeData.ColorMap.Items['lt1']);
  ThemeData.ColorMap.AddOrSetValue('bg2', ThemeData.ColorMap.Items['lt2']);
  ThemeData.ColorMap.AddOrSetValue('phClr', ThemeData.ColorMap.Items['accent1']);
end;

function TdxXLSXThemeColorSchemeHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXThemeColorSchemeItemHandler.Create(Owner, ThemeData);
end;

{ TdxXLSXThemeColorSchemeItemHandler }

constructor TdxXLSXThemeColorSchemeItemHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FThemeData := AData as TdxXLSXReaderThemeData;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesCustomColor, TdxXLSXThemeColorSchemeItemCustomValueHandler, Self);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesSystemColor, TdxXLSXThemeColorSchemeItemSystemValueHandler, Self);
end;

procedure TdxXLSXThemeColorSchemeItemHandler.BeforeDestruction;
begin
  inherited;
  ThemeData.ColorMap.Add(FColorId, FColorValue);
end;

procedure TdxXLSXThemeColorSchemeItemHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FColorId := AReader.LocalName;
  FColorValue := clDefault;
end;

{ TdxXLSXThemeColorSchemeItemCustomValueHandler }

constructor TdxXLSXThemeColorSchemeItemCustomValueHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FOwner := AData as TdxXLSXThemeColorSchemeItemHandler;
end;

procedure TdxXLSXThemeColorSchemeItemCustomValueHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  AValue := AReader.GetAttribute(sdxXLSXAttrVal);
  try
    FOwner.FColorValue := TdxXLSXUtils.DecodeColor(AValue);
  except
    DoError(sdxErrorInvalidColor, [AValue], ssmtWarning);
  end
end;

{ TdxXLSXThemeColorSchemeItemSystemValueHandler }

procedure TdxXLSXThemeColorSchemeItemSystemValueHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AColor: Integer;
  AValue: string;
begin
  AValue := AReader.GetAttribute(sdxXLSXAttrVal);
  if IdentToColor('cl' + AValue, AColor) then
    FOwner.FColorValue := TColor(AColor)
  else
    DoError(sdxErrorInvalidColor, [AValue], ssmtWarning);
end;

{ TdxXLSXThemeFormatSchemeBrushHandler }

constructor TdxXLSXThemeFormatSchemeBrushHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FThemeData := AData as TdxXLSXReaderThemeData;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeSolidFill, CreateBrushHandler, TObject(TdxXLSXSolidBrushHandler));
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeTexturedFill, CreateBrushHandler, TObject(TdxXLSXTexturedBrushHandler));
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeGradientFill, CreateBrushHandler, TObject(TdxXLSXGradientBrushHandler));
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodePatternFill, CreateBrushHandler, TObject(TdxXLSXPatternBrushHandler));
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeNoFill, CreateBrushHandler, TObject(TdxXLSXEmptyBrushHandler));
end;

function TdxXLSXThemeFormatSchemeBrushHandler.CreateBrushHandler(const AData: TObject): TdxXMLNodeHandler;
begin
  Result := TdxXLSXNodeHandlerClass(AData).Create(Owner, FThemeData.AddBrush);
end;

{ TdxXLSXThemeFormatSchemePenHandler }

constructor TdxXLSXThemeFormatSchemePenHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FThemeData := AData as TdxXLSXReaderThemeData;
end;

function TdxXLSXThemeFormatSchemePenHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXPenHandler.Create(Owner, FThemeData.AddPen);
end;

{ TdxXLSXThemeFormatSchemeHandler }

constructor TdxXLSXThemeFormatSchemeHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesFormatSchemeFillStyleList, TdxXLSXThemeFormatSchemeBrushHandler, AData);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesFormatSchemeLineStyleList, TdxXLSXThemeFormatSchemePenHandler, AData);
end;

{ TdxXLSXThemeElementsHandler }

constructor TdxXLSXThemeElementsHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesColorScheme, TdxXLSXThemeColorSchemeHandler, AData);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesFormatScheme, TdxXLSXThemeFormatSchemeHandler, AData);
end;

{ TdxXLSXCustomBrushHandler }

constructor TdxXLSXCustomBrushHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FBrush := AData as TdxGPBrush;
end;

{ TdxXLSXPenHandler }

constructor TdxXLSXPenHandler.Create(AOwner, AData: TObject);
begin
  FPen := AData as TdxGPPen;
  inherited;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeSolidFill, TdxXLSXSolidBrushHandler, Pen.Brush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeTexturedFill, TdxXLSXTexturedBrushHandler, Pen.Brush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeGradientFill, TdxXLSXGradientBrushHandler, Pen.Brush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodePatternFill, TdxXLSXPatternBrushHandler, Pen.Brush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeNoFill, TdxXLSXEmptyBrushHandler, Pen.Brush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeLineDash, ProcessPenDash);
end;

procedure TdxXLSXPenHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: Int64;
begin
  if TryStrToInt64(AReader.GetAttribute(sdxXLSXAttrLineWidth), AValue) then
    Pen.Width := dxEMUToPixelsF(AValue);
end;

function TdxXLSXPenHandler.ProcessPenDash(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Pen.Style := TdxSpreadSheetXLSXHelper.StringToPenStyle(AReader.GetAttribute(sdxXLSXAttrVal));
  Result := nil;
end;

{ TdxXLSXIndexedColorsReader }

procedure TdxXLSXIndexedColorsReader.AfterConstruction;
begin
  inherited;
  Handlers.Add('colors', TdxXLSXStylesColorCollectionHandler, TdxSpreadSheetReaderAccess(Owner).IndexedColors);
end;

{ TdxXLSXStyleReader }

constructor TdxXLSXStyleReader.Create(
  const AFileName: string; AOwner: TdxSpreadSheetXLSXReader;
  AProgressHelper: TcxCustomProgressCalculationHelper = nil);
begin
  inherited;
  FCellXF := TcxObjectList.Create;
  FCellStyleXF := TcxObjectList.Create;
end;

destructor TdxXLSXStyleReader.Destroy;
begin
  FreeAndNil(FCellStyleXF);
  FreeAndNil(FCellXF);
  inherited;
end;

procedure TdxXLSXStyleReader.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeDXFS, TdxXLSXStylesConditionalFormattingCollectionHandler, TdxSpreadSheetReaderAccess(Owner).ConditionalFormattingStyles);
  Handlers.Add(sdxXLSXNodeStyleBorders, TdxXLSXStylesBordersCollectionHandler, TdxSpreadSheetReaderAccess(Owner).Borders);
  Handlers.Add(sdxXLSXNodeStyleFills, TdxXLSXStylesFillCollectionHandler, TdxSpreadSheetReaderAccess(Owner).Fills);
  Handlers.Add(sdxXLSXNodeStyleFonts, TdxXLSXStylesFontCollectionHandler, TdxSpreadSheetReaderAccess(Owner).Fonts);
  Handlers.Add(sdxXLSXNodeStyleNumberFormats, TdxXLSXStylesNumberFormatCollectionHandler, TdxSpreadSheetReaderAccess(Owner).Formats);
  Handlers.Add(sdxXLSXNodeStyleCellStyleXfs, CreateCellStyleXF);
  Handlers.Add(sdxXLSXNodeStyleCellXfs, CreateCellXF);
end;

procedure TdxXLSXStyleReader.BeforeDestruction;
begin
  inherited;
  ImportCellStyles;
end;

function TdxXLSXStyleReader.CreateCellStyleXF(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXCellStyleCollectionHandler.Create(Self, FCellStyleXF, nil);
end;

function TdxXLSXStyleReader.CreateCellXF(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXCellStyleCollectionHandler.Create(Self, FCellXF, FCellStyleXF);
end;

procedure TdxXLSXStyleReader.ImportCellStyles;

  function GetItem(AFlag: Boolean; AIndex: Integer; ACollection: TdxHashTableItemList): TObject;
  begin
    if AFlag and InRange(AIndex, 0, ACollection.Count - 1) then
      Result := ACollection.List[AIndex]
    else
      Result := nil;
  end;

  function GetNumberFormatHandle(AFlag: Boolean; AIndex: Integer): TObject;
  var
    I: Integer;
  begin
    for I := 0 to Owner.Formats.Count - 1 do
    begin
      if TdxSpreadSheetFormatHandle(Owner.Formats[I]).FormatCodeID = AIndex then
        Exit(TdxSpreadSheetFormatHandle(Owner.Formats[I]));
    end;
    Result := SpreadSheet.CellStyles.Formats.PredefinedFormats.GetFormatHandleByID(AIndex);
  end;

var
  AHandle: TdxSpreadSheetCellStyleHandle;
  AStyle: TdxXLSXCellStyle;
  I: Integer;
begin
  for I := 0 to FCellXF.Count - 1 do
  begin
    AStyle := FCellXF.List[I];

    AHandle := TdxSpreadSheetReaderAccess(Owner).CreateTempCellStyle(
      TdxSpreadSheetFontHandle(GetItem(AStyle.ApplyFont, AStyle.FontId, Owner.Fonts)),
      TdxSpreadSheetFormatHandle(GetNumberFormatHandle(AStyle.ApplyNumberFormat, AStyle.NumberFormatId)),
      TdxSpreadSheetBrushHandle(GetItem(AStyle.ApplyFill, AStyle.FillId, Owner.Fills)),
      TdxSpreadSheetBordersHandle(GetItem(AStyle.ApplyBorder, AStyle.BorderId, Owner.Borders)));

    AHandle.AlignHorz := AStyle.AlignHorz;
    AHandle.AlignHorzIndent := Owner.ColumnWidthHelper.SpacesNumberToPixels(AStyle.AlignHorzIndent);
    AHandle.AlignVert := AStyle.AlignVert;
    AHandle.Rotation := AStyle.Rotation;

    AHandle.States := [];
    if AStyle.ShrinkToFit then
      AHandle.States := AHandle.States + [csShrinkToFit];
    if AStyle.WordWrap then
      AHandle.States := AHandle.States + [csWordWrap];
    if AStyle.Locked then
      AHandle.States := AHandle.States + [csLocked];
    if AStyle.Hidden then
      AHandle.States := AHandle.States + [csHidden];

    Owner.Styles.Add(TdxSpreadSheetReaderAccess(Owner).AddCellStyle(AHandle));
  end;
end;

{ TdxXLSXThemeReader }

constructor TdxXLSXThemeReader.Create(const AFileName: string; AOwner: TdxSpreadSheetXLSXReader; AData: TdxXLSXReaderThemeData);
begin
  FThemeData := AData;
  inherited Create(AFileName, AOwner);
end;

procedure TdxXLSXThemeReader.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesElements, TdxXLSXThemeElementsHandler, ThemeData);
end;

{ TdxXLSXEmptyBrushHandler }

procedure TdxXLSXEmptyBrushHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  Brush.Style := gpbsClear;
end;

{ TdxXLSXGradientBrushHandler }

constructor TdxXLSXGradientBrushHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Brush.Style := gpbsGradient;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeGradientPoint, TdxXLSXGradientBrushStopHandler, Brush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeGradientPoints, ProcessGradientStops);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeLinearGradientFill, ProcessLinearGradientOptions);
end;

function TdxXLSXGradientBrushHandler.ProcessGradientStops(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Brush.GradientPoints.Clear;
  Result := Self;
end;

function TdxXLSXGradientBrushHandler.ProcessLinearGradientOptions(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AAngle: Double;
  AInverseOrder: Boolean;
begin
  AAngle := TdxXLSXUtils.DecodePositiveFixedAngle(AReader.GetAttributeAsInteger(sdxXLSXAttrAng));
  Brush.GradientMode := dxGetNearestGradientMode(AAngle, AInverseOrder); 
  if AInverseOrder then
    Brush.GradientPoints.InvertOrder;
  Result := nil;
end;

{ TdxXLSXPatternBrushHandler }

constructor TdxXLSXPatternBrushHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingPatternBackgroundColor, CreateBackgroundColorHandler);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingPatternForegroundColor, CreateForegroundColorHandler);
end;

procedure TdxXLSXPatternBrushHandler.BeforeDestruction;
begin
  dxSpreadSheetLoadBrushPattern(Brush, HInstance, 'XLSX_BRUSHPATTERN_' + UpperCase(FPreset), FForegroundColor, FBackgroundColor);
  inherited;
end;

function TdxXLSXPatternBrushHandler.CreateBackgroundColorHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXAdvancedColorHandler.Create(Owner, @FBackgroundColor);
end;

function TdxXLSXPatternBrushHandler.CreateForegroundColorHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXAdvancedColorHandler.Create(Owner, @FForegroundColor);
end;

procedure TdxXLSXPatternBrushHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FPreset := AReader.GetAttribute(sdxXLSXAttrPreset);
end;

{ TdxXLSXSolidBrushHandler }

constructor TdxXLSXSolidBrushHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Brush.Style := gpbsSolid;
  FColorHandler := TdxXLSXAdvancedColorHandler.Create(AOwner, nil);
  FColorHandler.AddReference;
end;

destructor TdxXLSXSolidBrushHandler.Destroy;
begin
  Brush.Color := FColorHandler.CalculateColor;
  FColorHandler.RemoveReference;
  inherited;
end;

function TdxXLSXSolidBrushHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := FColorHandler.CreateHandler(AReader);
end;

{ TdxXLSXTexturedBrushHandler }

constructor TdxXLSXTexturedBrushHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Brush.Style := gpbsClear;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingBlip, ProcessBlip);
end;

function TdxXLSXTexturedBrushHandler.ProcessBlip(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AEmbedResourceId: string;
  AItem: TdxXLSXRelationship;
  AStream: TStream;
begin
  AEmbedResourceId := AReader.GetAttribute(sdxXLSXNamespaceRelationship, sdxXLSXAttrDrawingResourceEmbed, '');
  if Owner.Rels.Find(AEmbedResourceId, AItem) then
  begin
    AStream := TdxSpreadSheetReaderAccess(Owner.Owner).ReadFile(AItem.Target);
    try
      Brush.Texture.LoadFromStream(AStream);
      Brush.Style := gpbsTexture;
    finally
      AStream.Free;
    end;
  end
  else
    DoError(sdxErrorPictureCannotBeFound, [Owner.FileName + ':' + AEmbedResourceId], ssmtWarning);

  Result := nil;
end;

end.
