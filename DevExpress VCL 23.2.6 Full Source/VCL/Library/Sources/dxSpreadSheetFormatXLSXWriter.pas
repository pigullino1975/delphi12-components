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

unit dxSpreadSheetFormatXLSXWriter;

{$I cxVer.Inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics,
  dxCore, dxCoreClasses, cxClasses, cxGeometry, dxCustomTree, dxXMLDoc, dxZIPUtils, dxXMLClasses, dxXMLWriter, dxGenerics,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxSpreadSheetStrs, dxSpreadSheetPackedFileFormatCore,
  dxSpreadSheetUtils, dxSpreadSheetGraphics, Generics.Defaults, Generics.Collections, dxGDIPlusClasses, dxCoreGraphics,
  dxSpreadSheetPrinting, dxSpreadSheetConditionalFormattingRules, dxSpreadSheetContainers, dxSpreadSheetHyperlinks,
  dxSpreadSheetFormatXLSXTags, dxSpreadSheetProtection, dxSpreadSheetCoreStyles, dxSpreadSheetFormatXLSXUtils;

type

  { TdxXLSXWriterResourceList }

  TdxXLSXWriterResourceList = class
  strict private const
    DefaultCapacity = 10240;
  strict private
    FData: TdxFastList;
    FIndex: TdxObjectIntegerDictionary;

    function GetCount: Integer; inline;
    function GetList: PdxPointerList; inline;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AObject: TObject): Integer;// inline;
    function IndexOf(AObject: TObject): Integer;// inline;
    //
    property Count: Integer read GetCount;
    property List: PdxPointerList read GetList;
  end;

  { TdxXLSXCustomWriter }

  TdxXLSXCustomWriter = class(TdxSpreadSheetCustomPackedWriter)
  strict private
    FTargetStream: TStream;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    destructor Destroy; override;
  end;

  { TdxSpreadSheetXLSXWriter }

  TdxSpreadSheetXLSXWriter = class(TdxXLSXCustomWriter)
  strict private
    FBorders: TdxXLSXWriterResourceList;
    FCellStyleDefault: TdxSpreadSheetCellStyleHandle;
    FCellStyles: TdxXLSXWriterResourceList;
    FColumnWidthHelper: TdxSpreadSheetExcelColumnWidthHelper;
    FConditionalFormattingStyles: TdxXLSXWriterResourceList;
    FContentType: TStrings;
    FCustomFormats: TdxXLSXWriterResourceList;
    FFills: TdxXLSXWriterResourceList;
    FFonts: TdxXLSXWriterResourceList;
    FImages: TDictionary<TdxGPImage, string>;
    FSharedStrings: TdxXLSXWriterResourceList;
  protected
    function CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper; override;
    function GetContentTypeID: string; virtual;
    procedure AddDefaultResources;

    procedure RegisterFile(const AFileName, AContentType: string;
      const ARelationship: string = ''; ARels: TdxXLSXRelationships = nil); virtual;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    destructor Destroy; override;
    procedure WriteData; override;
    procedure WriteRels(const AFileName: string; ARels: TdxXLSXRelationships; AConvertPaths: Boolean = True);

    property Borders: TdxXLSXWriterResourceList read FBorders;
    property CellStyleDefault: TdxSpreadSheetCellStyleHandle read FCellStyleDefault;
    property CellStyles: TdxXLSXWriterResourceList read FCellStyles;
    property ConditionalFormattingStyles: TdxXLSXWriterResourceList read FConditionalFormattingStyles;
    property CustomFormats: TdxXLSXWriterResourceList read FCustomFormats;
    property Fills: TdxXLSXWriterResourceList read FFills;
    property Fonts: TdxXLSXWriterResourceList read FFonts;
    property Images: TDictionary<TdxGPImage, string> read FImages;
    property SharedStrings: TdxXLSXWriterResourceList read FSharedStrings;
    //
    property ColumnWidthHelper: TdxSpreadSheetExcelColumnWidthHelper read FColumnWidthHelper;
  end;

  { TdxXLSXWriterCustomBuilder }

  TdxXLSXWriterCustomBuilder = class(TdxSpreadSheetCustomFilerSubTask)
  strict private
    FOwnerRels: TdxXLSXRelationships;

    function GetOwner: TdxSpreadSheetXLSXWriter;
  protected
    procedure RegisterFile(const AFileName, AContentType: string;
      const ARelationship: string = ''; ARels: TdxXLSXRelationships = nil); inline;
  public
    constructor Create(AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships);
    function WriteImage(AImage: TdxGPImage): string;
    //
    property Owner: TdxSpreadSheetXLSXWriter read GetOwner;
    property OwnerRels: TdxXLSXRelationships read FOwnerRels;
  end;

  { TdxXLSXWriterCustomFileBuilder }

  TdxXLSXWriterCustomFileBuilder = class(TdxXLSXWriterCustomBuilder)
  strict private
    FTargetFileName: string;

    function GetTargetFileNameRels: string; inline;
  public
    constructor Create(AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships; const ATargetFileName: string);
    //
    property TargetFileName: string read FTargetFileName;
    property TargetFileNameRels: string read GetTargetFileNameRels;
  end;

  { TdxXLSXWriterCustomXMLBuilder }

  TdxXLSXWriterCustomXMLBuilder = class(TdxXLSXWriterCustomFileBuilder)
  strict private const
    BufferCapacity = 1048576;
  protected
    function GetContentRelationship: string; virtual; abstract;
    function GetContentType: string; virtual; abstract;
  public
    procedure Execute; override; final;
    procedure ExecuteCore(AWriter: TdxXmlWriter); virtual; abstract;
  end;

  { TdxXLSXWriterContentTypeBuilder }

  TdxXLSXWriterContentTypeBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    FContentType: TStrings;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;
  public
    constructor Create(AOwner: TdxSpreadSheetXLSXWriter; AContentType: TStrings; const ATargetFileName: string);
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
  end;

  { TdxXLSXWriterMetadataBuilder }

  TdxXLSXWriterMetadataBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    function GetMetadata: TdxSpreadSheetOptionsMetadata;
    procedure WriteValue(AWriter: TdxXmlWriter; const ANamespace, AValueName, AValue: string); overload;
    procedure WriteValue(AWriter: TdxXmlWriter; const ANamespace, AValueName: string; const AValue: TDateTime); overload;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;
  public
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
    //
    property Metadata: TdxSpreadSheetOptionsMetadata read GetMetadata;
  end;

  { TdxXLSXWriterExternalLinkBuilder }

  TdxXLSXWriterExternalLinkBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    FLink: TdxSpreadSheetExternalLink;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;
  public
    constructor Create(AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships;
      ALink: TdxSpreadSheetExternalLink; const ATargetFileName: string);
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
    //
    property Link: TdxSpreadSheetExternalLink read FLink;
  end;

  { TdxXLSXWriterFormattedStringBuilder }

  TdxXLSXWriterFormattedStringBuilder = class(TdxXLSXWriterCustomBuilder)
  strict private
    FString: TdxSpreadSheetFormattedSharedString;
    FWriter: TdxXmlWriter;
  public
    constructor Create(AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships;
      AWriter: TdxXmlWriter; AString: TdxSpreadSheetFormattedSharedString);
    procedure Execute; override;
  end;

  { TdxXLSXWriterSharedStringsBuilder }

  TdxXLSXWriterSharedStringsBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    function GetSharedStrings: TdxXLSXWriterResourceList; inline;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;
  public
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
    //
    property SharedStrings: TdxXLSXWriterResourceList read GetSharedStrings;
  end;

  { TdxXLSXWriterRelationshipsBuilder }

  TdxXLSXWriterRelationshipsBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    FRels: TdxXLSXRelationships;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;
  public
    constructor Create(AOwner: TdxSpreadSheetXLSXWriter; ARels: TdxXLSXRelationships; const AFileName: string);
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
  end;

  { TdxXLSXWriterStylesBuilder }

  TdxXLSXStyleForEachProc = reference to procedure (AWriter: TdxXmlWriter; AUserData: Pointer);

  TdxXLSXWriterStylesBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    FFormats: TdxXLSXWriterResourceList;

    function GetBorders: TdxXLSXWriterResourceList; inline;
    function GetCellStyleDefault: TdxSpreadSheetCellStyleHandle; inline;
    function GetCellStyles: TdxXLSXWriterResourceList; inline;
    function GetConditionalFormattingStyles: TdxXLSXWriterResourceList; inline;
    function GetCustomFormats: TdxXLSXWriterResourceList; inline;
    function GetFills: TdxXLSXWriterResourceList; inline;
    function GetFonts: TdxXLSXWriterResourceList; inline;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;
    procedure PrepareResources;

    procedure ProcessStylesGroup(AWriter: TdxXmlWriter; const ANodeName: string;
      AStyles: TdxXLSXWriterResourceList; AProc: TdxXLSXStyleForEachProc);

    procedure ProcessStylesGroupBorders(AWriter: TdxXmlWriter; AData: Pointer);
    procedure ProcessStylesGroupCellStyle(AWriter: TdxXmlWriter; AData: Pointer);
    procedure ProcessStylesGroupConditionalFormatting(AWriter: TdxXmlWriter; AData: Pointer);
    procedure ProcessStylesGroupFill(AWriter: TdxXmlWriter; AData: Pointer);
    procedure ProcessStylesGroupFont(AWriter: TdxXmlWriter; AData: Pointer);
    procedure ProcessStylesGroupNumberFormat(AWriter: TdxXmlWriter; AData: Pointer);
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
    class procedure WriteColor(AWriter: TdxXmlWriter; const ANodeName: string; AColor: TColor);
    class procedure WriteFont(AWriter: TdxXmlWriter; const ANodeName, AFontNameNodeName: string; AFont: TdxSpreadSheetFontHandle);

    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
    function GetFormatID(AFormat: TdxSpreadSheetFormatHandle): Integer;

    property Borders: TdxXLSXWriterResourceList read GetBorders;
    property CellStyleDefault: TdxSpreadSheetCellStyleHandle read GetCellStyleDefault;
    property CellStyles: TdxXLSXWriterResourceList read GetCellStyles;
    property ConditionalFormattingStyles: TdxXLSXWriterResourceList read GetConditionalFormattingStyles;
    property CustomFormats: TdxXLSXWriterResourceList read GetCustomFormats;
    property Fills: TdxXLSXWriterResourceList read GetFills;
    property Fonts: TdxXLSXWriterResourceList read GetFonts;
    property Formats: TdxXLSXWriterResourceList read FFormats;
  end;

  { TdxXLSXWriterWorkbookBuilder }

  TdxXLSXWriterWorkbookBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    FHasPrintableAreas: Boolean;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;
    function HasPrintableAreas(AView: TdxSpreadSheetTableView): Boolean; virtual;
    procedure WriteCalcProperties(AWriter: TdxXmlWriter); virtual;
    procedure WriteDefinedName(AWriter: TdxXmlWriter; ADefinedName: TdxSpreadSheetDefinedName); overload;
    procedure WriteDefinedName(AWriter: TdxXmlWriter; const ACaption, AReference, AComment: string; AScope: TdxSpreadSheetCustomView); overload; virtual;
    procedure WriteDefinedNames(AWriter: TdxXmlWriter); virtual;
    procedure WriteExternalLink(const AFileName: string; ALink: TdxSpreadSheetExternalLink; ARels: TdxXLSXRelationships); virtual;
    procedure WriteExternalLinks(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships); virtual;
    procedure WritePrintableAreas(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView); virtual;
    procedure WriteProperties(AWriter: TdxXmlWriter); virtual;
    procedure WriteProtection(AWriter: TdxXmlWriter); virtual;
    procedure WriteSharedStrings(const AFileName: string; ARels: TdxXLSXRelationships); virtual;
    procedure WriteSheet(AWriter: TdxXmlWriter; AView: TdxSpreadSheetCustomView; ARels: TdxXLSXRelationships); virtual;
    procedure WriteSheets(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships); virtual;
    procedure WriteSheetView(const AFileName: string; AView: TdxSpreadSheetCustomView; ARels: TdxXLSXRelationships); virtual;
    procedure WriteStyles(const AFileName: string; ARels: TdxXLSXRelationships); virtual;
  public
    procedure AfterConstruction; override;
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
  end;

  { TdxXLSXWriterWorksheetTableViewBuilder }

  TdxXLSXWriterWorksheetTableViewBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    FComments: TList;
    FContainers: TList;
    FView: TdxSpreadSheetTableView;

    procedure ExtendDimensionsByGroups(AGroups: TdxSpreadSheetTableItemGroups; var AStartIndex, AFinishIndex: Integer);
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;
  protected
    procedure InitializeContainers;

    function ConvertRowHeight(const AValue: Integer): Double; virtual;
    function EncodeFloat(const AValue: Double): string;
    function GetActivePane(out AValue: string): Boolean;
    function ValidateDimensions(const R: TRect): TRect;

    procedure WriteBreaks(AWriter: TdxXMLWriter; const ANodeName: string; AList: TList<Cardinal>; AMaxIndex: Integer); virtual;
    procedure WriteCell(AWriter: TdxXmlWriter; ACell: TdxSpreadSheetCell; ARowIndex, AColumnIndex: Integer); virtual;
    procedure WriteColumns(AWriter: TdxXmlWriter; ADimension: TRect); virtual;
    procedure WriteComments(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships); virtual;
    procedure WriteConditionalFormatting(AWriter: TdxXmlWriter); virtual;
    procedure WriteContainers(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships); virtual;
    procedure WriteContent(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships); virtual;
    procedure WriteExtensions(AWriter: TdxXmlWriter); virtual;
    procedure WriteFixedPaneProperties(AWriter: TdxXmlWriter); virtual;
    procedure WriteHeaderFooter(AWriter: TdxXmlWriter; AHeaderFooter: TdxSpreadSheetTableViewOptionsPrintHeaderFooter); virtual;
    procedure WriteHeaderFooterText(AWriter: TdxXmlWriter; const ANodeName: string; AText: TdxSpreadSheetTableViewOptionsPrintHeaderFooterText);
    procedure WriteHyperlink(AWriter: TdxXmlWriter; AHyperlink: TdxSpreadSheetHyperLink; ARels: TdxXLSXRelationships); virtual;
    procedure WriteHyperlinks(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships); virtual;
    procedure WriteMergedCells(AWriter: TdxXmlWriter; AMergedCells: TdxSpreadSheetMergedCellList); virtual;
    procedure WritePageMargins(AWriter: TdxXmlWriter; AMargins: TdxSpreadSheetTableViewOptionsPrintPageMargins); virtual;
    procedure WritePageSetup(AWriter: TdxXmlWriter); virtual;
    procedure WritePrintOptions(AWriter: TdxXmlWriter); virtual;
    procedure WriteProperties(AWriter: TdxXmlWriter); virtual;
    procedure WriteRows(AWriter: TdxXmlWriter; ADimension: TRect); virtual;
    procedure WriteSelection(AWriter: TdxXmlWriter; ASelection: TdxSpreadSheetTableViewSelection); virtual;
    procedure WriteViewProperties(AWriter: TdxXmlWriter); virtual;
    procedure WriteViewProtection(AWriter: TdxXmlWriter); virtual;
  public
    constructor Create(AOwner: TdxSpreadSheetXLSXWriter;
      AOwnerRels: TdxXLSXRelationships; const ATargetFileName: string; AView: TdxSpreadSheetTableView);
    destructor Destroy; override;
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
    //
    property Comments: TList read FComments;
    property Containers: TList read FContainers;
    property View: TdxSpreadSheetTableView read FView;
  end;

  { TdxSpreadSheetXLTXWriter }

  TdxSpreadSheetXLTXWriter = class(TdxSpreadSheetXLSXWriter)
  protected
    function GetContentTypeID: string; override;
  end;

implementation

uses
  System.ZLib,
  AnsiStrings, Math, TypInfo, StrUtils, dxColorPicker, cxGraphics, dxHashUtils, dxTypeHelpers,
  dxSpreadSheetFormulas, dxSpreadSheetFormatXLSX, dxSpreadSheetFormatUtils, dxSpreadSheetFormatXLSXWriterComments,
  dxSpreadSheetFormatXLSXWriterConditionalFormatting, dxSpreadSheetFormatXLSXWriterDrawing, dxOLECryptoContainer,
  dxSpreadSheetCoreFormulasParser, dxSpreadSheetCoreStrs, dxStringHelper, dxSpreadSheetCoreHelpers;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXWriter';

const
  CustomNumberFormatBase = 164;
  MaxZoomFactor = 400;
  MinZoomFactor = 10;

const
  sMsgWrongDataType = 'wrong data type';

type
  TdxDynamicListItemAccess = class(TdxDynamicListItem);
  TdxSpreadSheetTableColumnAccess = class(TdxSpreadSheetTableColumn);
  TdxSpreadSheetTableItemGroupAccess = class(TdxSpreadSheetTableItemGroup);
  TdxSpreadSheetTableRowAccess = class(TdxSpreadSheetTableRow);
  TdxSpreadSheetTableViewAccess = class(TdxSpreadSheetTableView);

  { TdxXMLWriterHelper }

  TdxXMLWriterHelper = class helper for TdxXmlWriter
  public
    procedure WriteElementStringEx(const AName, AValue: string);
  end;

{ TdxXMLWriterHelper }

procedure TdxXMLWriterHelper.WriteElementStringEx(const AName, AValue: string);
begin
  WriteStartElement(AName);
  if AValue <> '' then
  begin
    if TdxXMLHelper.IsPreserveSpacesNeeded(AValue) then
      WriteAttributeString('xml', 'space', '', 'preserve');
    WriteString(TdxXmlConvert.EncodeValue(AValue));
  end;
  WriteEndElement;
end;

{ TdxXLSXWriterResourceList }

constructor TdxXLSXWriterResourceList.Create;
begin
  inherited Create;
  FData := TdxFastList.Create(DefaultCapacity);
  FIndex := TdxObjectIntegerDictionary.Create(DefaultCapacity);
end;

destructor TdxXLSXWriterResourceList.Destroy;
begin
  FreeAndNil(FIndex);
  FreeAndNil(FData);
  inherited;
end;

function TdxXLSXWriterResourceList.Add(AObject: TObject): Integer;
begin
  if not FIndex.TryGetValue(AObject, Result) then
  begin
    Result := FData.Add(AObject);
    FIndex.Add(AObject, Result);
  end;
end;

function TdxXLSXWriterResourceList.IndexOf(AObject: TObject): Integer;
begin
  Result := FIndex.Items[AObject];
end;

function TdxXLSXWriterResourceList.GetCount: Integer;
begin
  Result := FData.Count;
end;

function TdxXLSXWriterResourceList.GetList: PdxPointerList;
begin
  Result := FData.List;
end;

{ TdxXLSXCustomWriter }

constructor TdxXLSXCustomWriter.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  if AOwner.Password <> '' then
  begin
    FTargetStream := AStream;
    AStream := TMemoryStream.Create;
  end;
  inherited Create(AOwner, AStream);
end;

destructor TdxXLSXCustomWriter.Destroy;
begin
  inherited Destroy;
  if FTargetStream <> nil then
  try
    TdxOLECryptoContainer.Encrypt(Stream, FTargetStream, SpreadSheet.Password, TdxOLECryptoContainerEncryptorStandard);
  finally
    Stream.Free;
  end;
end;

{ TdxSpreadSheetXLSXWriter }

constructor TdxSpreadSheetXLSXWriter.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  inherited Create(AOwner, AStream);
  FImages := TDictionary<TdxGPImage, string>.Create;
  FContentType := TStringList.Create;

  FConditionalFormattingStyles := TdxXLSXWriterResourceList.Create;
  FCustomFormats := TdxXLSXWriterResourceList.Create;
  FCellStyles := TdxXLSXWriterResourceList.Create;
  FFonts := TdxXLSXWriterResourceList.Create;
  FSharedStrings := TdxXLSXWriterResourceList.Create;
  FFills := TdxXLSXWriterResourceList.Create;
  FBorders := TdxXLSXWriterResourceList.Create;

  FCellStyleDefault := SpreadSheet.CellStyles.AddStyle(SpreadSheet.CellStyles.CreateStyle);
  FCellStyleDefault.AddRef;

  AddDefaultResources;

  FColumnWidthHelper := TdxSpreadSheetExcelColumnWidthHelper.Create;
  FCellStyleDefault.Font.AssignToFont(FColumnWidthHelper.Font);
end;

destructor TdxSpreadSheetXLSXWriter.Destroy;
begin
  FCellStyleDefault.Release;
  FCellStyleDefault := nil;

  FreeAndNil(FImages);
  FreeAndNil(FFonts);
  FreeAndNil(FBorders);
  FreeAndNil(FFills);
  FreeAndNil(FCellStyles);
  FreeAndNil(FContentType);
  FreeAndNil(FSharedStrings);
  FreeAndNil(FColumnWidthHelper);
  FreeAndNil(FConditionalFormattingStyles);
  FreeAndNil(FCustomFormats);
  inherited Destroy;
end;

procedure TdxSpreadSheetXLSXWriter.WriteData;
var
  ARels: TdxXLSXRelationships;
begin
  if SpreadSheet.VisibleSheetCount = 0 then
    raise EdxSpreadSheetError.Create(cxGetResourceString(@sdxErrorCannotSaveDocumentWithoutSheets));

  ARels := TdxXLSXRelationships.Create;
  try
    ExecuteSubTask(TdxXLSXWriterWorkbookBuilder.Create(Self, ARels, sdxXLSXWorkbookFileName));
    if SpreadSheet.OptionsMetadata.HasData then
      ExecuteSubTask(TdxXLSXWriterMetadataBuilder.Create(Self, ARels, sdxXLSXCorePropertiesFileName));
    RegisterFile(TdxXLSXUtils.GetRelsFileNameForFile(''), sdxXLSXRelsContentType);
    WriteRels(TdxXLSXUtils.GetRelsFileNameForFile(''), ARels);
    ExecuteSubTask(TdxXLSXWriterContentTypeBuilder.Create(Self, FContentType, sdxXLSXContentTypeFileName));
  finally
    ARels.Free;
  end;
end;

function TdxSpreadSheetXLSXWriter.CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper;
begin
  Result := TdxSpreadSheetCustomFilerProgressHelper.Create(Self, SpreadSheet.SheetCount + 2);
end;

function TdxSpreadSheetXLSXWriter.GetContentTypeID: string;
begin
  Result := sdxXLSXWorkbookContentType;
end;

procedure TdxSpreadSheetXLSXWriter.AddDefaultResources;
var
  ABrush: TdxSpreadSheetBrushHandle;
begin
  Fills.Add(SpreadSheet.CellStyles.Brushes.AddBrush(SpreadSheet.CellStyles.Brushes.CreateBrush));

  ABrush := SpreadSheet.CellStyles.Brushes.CreateBrush;
  ABrush.Style := sscfsGray12;
  Fills.Add(SpreadSheet.CellStyles.Brushes.AddBrush(ABrush));

  CellStyles.Add(FCellStyleDefault);
  CellStyles.Add(SpreadSheet.DefaultCellStyle.Handle);
end;

procedure TdxSpreadSheetXLSXWriter.RegisterFile(const AFileName, AContentType: string;
  const ARelationship: string = ''; ARels: TdxXLSXRelationships = nil);
begin
  if ARels <> nil then
    ARels.AddNew(dxUnixPathDelim + AFileName, ARelationship);
  if AContentType <> '' then
    FContentType.Add(dxUnixPathDelim + AFileName + FContentType.NameValueSeparator + AContentType);
end;

procedure TdxSpreadSheetXLSXWriter.WriteRels(const AFileName: string; ARels: TdxXLSXRelationships; AConvertPaths: Boolean = True);
var
  APath: string;
begin
  if AConvertPaths then
  begin
    APath := TdxZIPPathHelper.ExtractFilePath(AFileName);
    APath := TdxZIPPathHelper.ExcludeTrailingPathDelimiter(APath);
    APath := TdxZIPPathHelper.ExtractFilePath(APath);
    ARels.ConvertToRelativePaths(APath);
  end;
  ExecuteSubTask(TdxXLSXWriterRelationshipsBuilder.Create(Self, ARels, AFileName));
end;

{ TdxXLSXWriterCustomBuilder }

constructor TdxXLSXWriterCustomBuilder.Create(
  AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships);
begin
  inherited Create(AOwner);
  FOwnerRels := AOwnerRels;
end;

function TdxXLSXWriterCustomBuilder.WriteImage(AImage: TdxGPImage): string;
const
  CodecMap: array[Boolean] of TdxImageDataFormat = (dxImagePng, dxImageJpeg);
  ExtMap: array[Boolean] of string = (sdxXLSXMimeTypePNGExt, sdxXLSXMimeTypeJPGExt);
var
  AFileName: string;
  AMemStream: TMemoryStream;
  ASaveAsJPEG: Boolean;
begin
  if not Owner.Images.TryGetValue(AImage, AFileName) then
  begin
    AMemStream := TMemoryStream.Create;
    try
      ASaveAsJPEG := AImage.ImageDataFormat = dxImageJpeg;
      AImage.SaveToStreamByCodec(AMemStream, CodecMap[ASaveAsJPEG]);

      AFileName := Format(sdxXLSXFileTemplateImage, [Owner.Images.Count + 1, ExtMap[ASaveAsJPEG]]);
      Owner.Images.Add(AImage, AFileName);
      Owner.WriteFile(AFileName, AMemStream);
    finally
      AMemStream.Free;
    end;
  end;
  Result := OwnerRels.AddNew(dxUnixPathDelim + AFileName, sdxXLSXImageRelationship);
end;

procedure TdxXLSXWriterCustomBuilder.RegisterFile(const AFileName, AContentType: string;
  const ARelationship: string = ''; ARels: TdxXLSXRelationships = nil);
begin
  Owner.RegisterFile(AFileName, AContentType, ARelationship, ARels);
end;

function TdxXLSXWriterCustomBuilder.GetOwner: TdxSpreadSheetXLSXWriter;
begin
  Result := TdxSpreadSheetXLSXWriter(inherited Owner);
end;

{ TdxXLSXWriterCustomFileBuilder }

constructor TdxXLSXWriterCustomFileBuilder.Create(
  AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships; const ATargetFileName: string);
begin
  inherited Create(AOwner, AOwnerRels);
  FTargetFileName := ATargetFileName;
end;

function TdxXLSXWriterCustomFileBuilder.GetTargetFileNameRels: string;
begin
  Result := TdxXLSXUtils.GetRelsFileNameForFile(TargetFileName);
end;

{ TdxXLSXWriterCustomXMLBuilder }

procedure TdxXLSXWriterCustomXMLBuilder.Execute;
var
  AStream: TStream;
  AWriter: TdxXmlWriter;
  AWriterSettings: TdxXmlWriterSettings;
begin
  AStream := TdxCompressedStream.Create(clDefault, BufferCapacity);
  try
    AWriterSettings := TdxXmlWriterSettings.Create;
    AWriterSettings.CheckCharacters := False;
    AWriterSettings.EncodeInvalidXmlCharAsUCS2 := True;
    
    AWriter := TdxXmlWriter.Create(AStream, AWriterSettings);
    try
      ExecuteCore(AWriter);
      AWriter.Flush;
    finally
      AWriter.Free;
    end;

    RegisterFile(TargetFileName, GetContentType, GetContentRelationship, OwnerRels);
  finally
    Owner.WriteFile(TargetFileName, AStream, soOwned);
  end;
end;

{ TdxXLSXWriterContentTypeBuilder }

constructor TdxXLSXWriterContentTypeBuilder.Create(
  AOwner: TdxSpreadSheetXLSXWriter; AContentType: TStrings; const ATargetFileName: string);
begin
  inherited Create(AOwner, nil, ATargetFileName);
  FContentType := AContentType;
end;

procedure TdxXLSXWriterContentTypeBuilder.ExecuteCore(AWriter: TdxXmlWriter);

  procedure AddDefault(const AExtension, AContentType: AnsiString);
  begin
    AWriter.WriteStartElement(sdxXLSXNodeDefault);
    AWriter.WriteAttributeString(sdxXLSXAttrExtension, AExtension);
    AWriter.WriteAttributeString(sdxXLSXAttrContentType, AContentType);
    AWriter.WriteEndElement;
  end;

  procedure AddOverride(const AName, AContentType: string);
  begin
    AWriter.WriteStartElement(sdxXLSXNodeOverride);
    AWriter.WriteAttributeString(sdxXLSXAttrPartName, AName);
    AWriter.WriteAttributeString(sdxXLSXAttrContentType, AContentType);
    AWriter.WriteEndElement;
  end;

var
  I: Integer;
begin
  AWriter.WriteStartElement('Types');
  AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXContentTypeNameSpace);

  AddDefault(sdxXLSXMimeTypePNGExt, sdxXLSXMimeTypePNG);
  AddDefault(sdxXLSXMimeTypeJPGExt, sdxXLSXMimeTypeJPG);
  AddDefault(sdxXLSXMimeTypeRELSExt, sdxXLSXMimeTypeRELS);
  AddDefault(sdxXLSXMimeTypeXMLExt, sdxXLSXMimeTypeXML);
  AddDefault(sdxXLSXMimeTypeVMLExt, sdxXLSXMimeTypeVML);

  for I := 0 to FContentType.Count - 1 do
    AddOverride(FContentType.Names[I], FContentType.ValueFromIndex[I]);

  AWriter.WriteEndElement;
end;

function TdxXLSXWriterContentTypeBuilder.GetContentRelationship: string;
begin
  Result := '';
end;

function TdxXLSXWriterContentTypeBuilder.GetContentType: string;
begin
  Result := '';
end;

{ TdxXLSXWriterMetadataBuilder }

procedure TdxXLSXWriterMetadataBuilder.ExecuteCore(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceCoreProperties, sdxXLSXNodeCoreProperties, 'http://schemas.openxmlformats.org/package/2006/metadata/core-properties');
  AWriter.WriteAttributeString('xmlns', 'xsi', '', 'http://www.w3.org/2001/XMLSchema-instance');
  AWriter.WriteAttributeString('xmlns', 'dcmitype', '', 'http://purl.org/dc/dcmitype/');
  AWriter.WriteAttributeString('xmlns', 'dcterms', '', 'http://purl.org/dc/terms/');
  AWriter.WriteAttributeString('xmlns', 'dc', '', 'http://purl.org/dc/elements/1.1/');

  WriteValue(AWriter, sdxXLSXNamespaceDublinCore, sdxXLSXNodeTitle, Metadata.Title);
  WriteValue(AWriter, sdxXLSXNamespaceDublinCore, sdxXLSXNodeSubject, Metadata.Subject);
  WriteValue(AWriter, sdxXLSXNamespaceDublinCore, sdxXLSXNodeCreator, Metadata.CreatedBy);
  WriteValue(AWriter, sdxXLSXNamespaceCoreProperties, sdxXLSXNodeKeywords, Metadata.Keywords);
  WriteValue(AWriter, sdxXLSXNamespaceDublinCore, sdxXLSXNodeDescription, Metadata.Description);
  WriteValue(AWriter, sdxXLSXNamespaceCoreProperties, sdxXLSXNodeLastModifiedBy, Metadata.LastModifiedBy);
  WriteValue(AWriter, sdxXLSXNamespaceCoreProperties, sdxXLSXNodeLastPrinted, Metadata.LastPrinted);
  WriteValue(AWriter, sdxXLSXNamespaceDublinCoreTerms, sdxXLSXNodeCreationDate, Metadata.Created);
  WriteValue(AWriter, sdxXLSXNamespaceDublinCoreTerms, sdxXLSXNodeModificationDate, Metadata.LastModified);

  AWriter.WriteEndElement;
end;

function TdxXLSXWriterMetadataBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXCorePropertiesRelationship;
end;

function TdxXLSXWriterMetadataBuilder.GetContentType: string;
begin
  Result := sdxXLSXCorePropertiesContentType;
end;

procedure TdxXLSXWriterMetadataBuilder.WriteValue(
  AWriter: TdxXmlWriter; const ANamespace, AValueName: string; const AValue: TDateTime);
begin
  if AValue <> 0 then
  begin
    AWriter.WriteStartElement(ANamespace, AValueName, '');
    if ANamespace = sdxXLSXNamespaceDublinCoreTerms then
      AWriter.WriteAttributeString('xsi', 'type', '', sdxXLSXValueW3CDTF);
    AWriter.WriteValue(TdxXMLDateTime.Create(AValue, True).ToString);
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterMetadataBuilder.WriteValue(
  AWriter: TdxXmlWriter; const ANamespace, AValueName, AValue: string);
begin
  if AValue <> '' then
  begin
    AWriter.WriteStartElement(ANamespace, AValueName, '');
    AWriter.WriteValue(AValue);
    AWriter.WriteEndElement;
  end;
end;

function TdxXLSXWriterMetadataBuilder.GetMetadata: TdxSpreadSheetOptionsMetadata;
begin
  Result := SpreadSheet.OptionsMetadata;
end;

{ TdxXLSXWriterExternalLinkBuilder }

constructor TdxXLSXWriterExternalLinkBuilder.Create(AOwner: TdxSpreadSheetXLSXWriter;
  AOwnerRels: TdxXLSXRelationships; ALink: TdxSpreadSheetExternalLink; const ATargetFileName: string);
begin
  inherited Create(AOwner, AOwnerRels, ATargetFileName);
  FLink := ALink;
end;

procedure TdxXLSXWriterExternalLinkBuilder.ExecuteCore(AWriter: TdxXmlWriter);
var
  ARelId: string;
  ARels: TdxXLSXRelationships;
begin
  AWriter.WriteStartElement(sdxXLSXNodeExternalLink);
  AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXWorkbookNameSpace);

  ARels := TdxXLSXRelationships.Create;
  try
    ARelId := ARels.AddNew(Link.Target, sdxXLSXExternalLinkPathRelationship, sdxXLSXValueTargetModeExternal);

    AWriter.WriteStartElement(sdxXLSXNodeExternalBook);
    AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXNamespaceRelationship, '', sdxXLSXCommonRelationshipPath);
    AWriter.WriteAttributeString(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '', ARelId);
    AWriter.WriteEndElement;

    Owner.WriteRels(TargetFileNameRels, ARels);
  finally
    ARels.Free;
  end;

  AWriter.WriteEndElement;
end;

function TdxXLSXWriterExternalLinkBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXExternalLinkRelationship;
end;

function TdxXLSXWriterExternalLinkBuilder.GetContentType: string;
begin
  Result := sdxXLSXExternalLinkContentType;
end;

{ TdxXLSXWriterFormattedStringBuilder }

constructor TdxXLSXWriterFormattedStringBuilder.Create(
  AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships;
  AWriter: TdxXmlWriter; AString: TdxSpreadSheetFormattedSharedString);
begin
  inherited Create(AOwner, AOwnerRels);
  FWriter := AWriter;
  FString := AString;
end;

procedure TdxXLSXWriterFormattedStringBuilder.Execute;

  function GetRunLength(AStartIndex, ARunIndex: Integer): Integer;
  begin
    if ARunIndex + 1 < FString.Runs.Count then
      Result := FString.Runs[ARunIndex + 1].StartIndex - AStartIndex
    else
      Result := Length(FString.Value) - AStartIndex + 1;
  end;

var
  ALength: Integer;
  ARun: TdxSpreadSheetFormattedSharedStringRun;
  I: Integer;
begin
  ALength := GetRunLength(1, -1);
  if ALength > 0 then
  begin
    FWriter.WriteStartElement(sdxXLSXNodeRichTextRun);
    FWriter.WriteElementStringEx(sdxXLSXNodeText, Copy(FString.Value, 1, ALength));
    FWriter.WriteEndElement;
  end;

  for I := 0 to FString.Runs.Count - 1 do
  begin
    ARun := FString.Runs[I];
    ALength := GetRunLength(ARun.StartIndex, I);

    FWriter.WriteStartElement(sdxXLSXNodeRichTextRun);
    if ARun.FontHandle <> nil then
      TdxXLSXWriterStylesBuilder.WriteFont(FWriter, sdxXLSXNodeRichTextRunParagraph, sdxXLSXNodeFontName, ARun.FontHandle);
    FWriter.WriteElementStringEx(sdxXLSXNodeText, Copy(FString.Value, ARun.StartIndex, ALength));
    FWriter.WriteEndElement;
  end;
end;

{ TdxXLSXWriterSharedStringsBuilder }

procedure TdxXLSXWriterSharedStringsBuilder.ExecuteCore(AWriter: TdxXmlWriter);
var
  AString: TdxSpreadSheetSharedString;
  I: Integer;
begin
  AWriter.WriteStartElement(sdxXLSXNodeSST, sdxXLSXWorkbookNameSpace);
  AWriter.WriteAttributeInteger(sdxXLSXAttrCount, SharedStrings.Count);
  AWriter.WriteAttributeInteger(sdxXLSXAttrUniqueCount, SharedStrings.Count);

  Owner.ProgressHelper.BeginStage(SharedStrings.Count);
  try
    for I := 0 to SharedStrings.Count - 1 do
    begin
      AString := TdxSpreadSheetSharedString(SharedStrings.List[I]);
      AWriter.WriteStartElement(sdxXLSXAttrSharedIndex);
      if AString is TdxSpreadSheetFormattedSharedString then
        ExecuteSubTask(TdxXLSXWriterFormattedStringBuilder.Create(Owner, OwnerRels, AWriter, TdxSpreadSheetFormattedSharedString(AString)))
      else
        AWriter.WriteElementStringEx(sdxXLSXNodeText, AString.Value);
      AWriter.WriteEndElement;
      Owner.ProgressHelper.NextTask;
    end;
  finally
    Owner.ProgressHelper.EndStage;
  end;
  AWriter.WriteEndElement;
end;

function TdxXLSXWriterSharedStringsBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXSharedStringRelationship;
end;

function TdxXLSXWriterSharedStringsBuilder.GetContentType: string;
begin
  Result := sdxXLSXSharedStringsContentType;
end;

function TdxXLSXWriterSharedStringsBuilder.GetSharedStrings: TdxXLSXWriterResourceList;
begin
  Result := Owner.SharedStrings;
end;

{ TdxXLSXWriterRelationshipsBuilder }

constructor TdxXLSXWriterRelationshipsBuilder.Create(
  AOwner: TdxSpreadSheetXLSXWriter; ARels: TdxXLSXRelationships; const AFileName: string);
begin
  inherited Create(AOwner, nil, AFileName);
  FRels := ARels;
end;

procedure TdxXLSXWriterRelationshipsBuilder.ExecuteCore(AWriter: TdxXmlWriter);
var
  AItem: TdxXLSXRelationship;
  I: Integer;
begin
  AWriter.WriteStartElement(sdxXLSXNodeRelationships, '');
  AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXRelsNameSpace);

  for I := 0 to FRels.Count - 1 do
  begin
    AItem := FRels[I];

    AWriter.WriteStartElement(sdxXLSXNodeRelationship);
    AWriter.WriteAttributeString(sdxXLSXAttrId, AItem.ID);
    AWriter.WriteAttributeString(sdxXLSXAttrType, AItem.TargetType);
    AWriter.WriteAttributeString(sdxXLSXAttrTarget, AItem.Target);
    if AItem.Mode <> '' then
      AWriter.WriteAttributeString(sdxXLSXAttrTargetMode, AItem.Mode);
    AWriter.WriteEndElement;
  end;

  AWriter.WriteEndElement;
end;

function TdxXLSXWriterRelationshipsBuilder.GetContentRelationship: string;
begin
  Result := '';
end;

function TdxXLSXWriterRelationshipsBuilder.GetContentType: string;
begin
  Result := '';
end;

{ TdxXLSXWriterStylesBuilder }

procedure TdxXLSXWriterStylesBuilder.AfterConstruction;
begin
  inherited;
  FFormats := TdxXLSXWriterResourceList.Create;
end;

destructor TdxXLSXWriterStylesBuilder.Destroy;
begin
  FreeAndNil(FFormats);
  inherited;
end;

class procedure TdxXLSXWriterStylesBuilder.WriteColor(
  AWriter: TdxXmlWriter; const ANodeName: string; AColor: TColor);
begin
  if cxColorIsValid(AColor) then
  begin
    AWriter.WriteStartElement(ANodeName);
    AWriter.WriteAttributeString(sdxXLSXAttrRGB, TdxAlphaColors.ToHexCode(dxColorToAlphaColor(AColor), True));
    AWriter.WriteEndElement;
  end;
end;

class procedure TdxXLSXWriterStylesBuilder.WriteFont(
  AWriter: TdxXmlWriter; const ANodeName, AFontNameNodeName: string; AFont: TdxSpreadSheetFontHandle);
const
  ScriptMap: array[TdxSpreadSheetFontScript] of AnsiString = (
    '', sdxXLSXValueSuperscript, sdxXLSXValueSubscript
  );
var
  AStyle: TFontStyle;
begin
  AWriter.WriteStartElement(ANodeName);
  try
    WriteColor(AWriter, sdxXLSXNodeColor, AFont.Color);

    if AFont.Script <> fsNone then
    begin
      AWriter.WriteStartElement(sdxXLSXNodeVertAlign);
      AWriter.WriteAttributeString(sdxXLSXAttrVal, ScriptMap[AFont.Script]);
      AWriter.WriteEndElement;
    end;

    AWriter.WriteStartElement(sdxXLSXNodeSZ);
    AWriter.WriteAttributeInteger(sdxXLSXAttrVal, AFont.Size);
    AWriter.WriteEndElement;

    AWriter.WriteStartElement(AFontNameNodeName);
    AWriter.WriteAttributeString(sdxXLSXAttrVal, AFont.Name);
    AWriter.WriteEndElement;

    AWriter.WriteStartElement(sdxXLSXNodeCharset);
    AWriter.WriteAttributeInteger(sdxXLSXAttrVal, AFont.Charset);
    AWriter.WriteEndElement;

    for AStyle := Low(AStyle) to High(AStyle) do
    begin
      if AStyle in AFont.Style then
        AWriter.WriteElementString(dxXLSXFontStyles[AStyle], '');
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterStylesBuilder.ExecuteCore(AWriter: TdxXmlWriter);
begin
  PrepareResources;

  AWriter.WriteStartElement(sdxXLSXNodeStyleSheet, sdxXLSXWorkbookNameSpace);
  try
    Owner.ProgressHelper.BeginStage(CellStyles.Count + Borders.Count + Formats.Count + Fonts.Count + ConditionalFormattingStyles.Count);
    try
      ProcessStylesGroup(AWriter, sdxXLSXNodeStyleNumberFormats, Formats, ProcessStylesGroupNumberFormat);
      ProcessStylesGroup(AWriter, sdxXLSXNodeStyleFonts, Fonts, ProcessStylesGroupFont);
      ProcessStylesGroup(AWriter, sdxXLSXNodeStyleFills, Fills, ProcessStylesGroupFill);
      ProcessStylesGroup(AWriter, sdxXLSXNodeStyleBorders, Borders, ProcessStylesGroupBorders);

      AWriter.WriteStartElement(sdxXLSXNodeStyleCellStyleXfs);
      AWriter.WriteAttributeInteger(sdxXLSXAttrCount, 1);
      AWriter.WriteStartElement(sdxXLSXNodeStyleCellXf);
      AWriter.WriteAttributeInteger(sdxXLSXAttrBorderId, 0);
      AWriter.WriteAttributeInteger(sdxXLSXAttrFillId, 0);
      AWriter.WriteAttributeInteger(sdxXLSXAttrFontId, 0);
      AWriter.WriteAttributeInteger(sdxXLSXAttrNumFmtId, 0);
      AWriter.WriteEndElement;
      AWriter.WriteEndElement;

      ProcessStylesGroup(AWriter, sdxXLSXNodeStyleCellXfs, CellStyles, ProcessStylesGroupCellStyle);
      ProcessStylesGroup(AWriter, sdxXLSXNodeDXFS, ConditionalFormattingStyles, ProcessStylesGroupConditionalFormatting);
    finally
      Owner.ProgressHelper.EndStage;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

function TdxXLSXWriterStylesBuilder.GetFormatID(AFormat: TdxSpreadSheetFormatHandle): Integer;
begin
  if SpreadSheet.CellStyles.Formats.IsCustom(AFormat) then
  begin
    Result := CustomFormats.Add(AFormat);
    Inc(Result, CustomNumberFormatBase);
  end
  else
    Result := AFormat.FormatCodeID;
end;

procedure TdxXLSXWriterStylesBuilder.ProcessStylesGroup(
  AWriter: TdxXmlWriter; const ANodeName: string; AStyles: TdxXLSXWriterResourceList; AProc: TdxXLSXStyleForEachProc);
var
  I: Integer;
begin
  AWriter.WriteStartElement(ANodeName);
  try
    AWriter.WriteAttributeInteger(sdxXLSXAttrCount, AStyles.Count);
    for I := 0 to AStyles.Count - 1 do
    begin
      AProc(AWriter, AStyles.List[I]);
      Owner.ProgressHelper.NextTask;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterStylesBuilder.ProcessStylesGroupBorders(AWriter: TdxXmlWriter; AData: Pointer);
const
  BordersOrder: array [0..3] of TcxBorder = (bLeft, bRight, bTop, bBottom);
var
  ABorder: TcxBorder;
  ABordersHandle: TdxSpreadSheetBordersHandle;
  ABorderStyle: AnsiString;
  I: Integer;
begin
  ABordersHandle := TdxSpreadSheetBordersHandle(AData);
  AWriter.WriteStartElement(sdxXLSXNodeStyleBorder);
  try
    for I := 0 to Length(BordersOrder) - 1 do
    begin
      ABorder := BordersOrder[I];
      AWriter.WriteStartElement(dxAnsiStringToString(dxXLSXBorderNames[ABorder]));
      if not ABordersHandle.BorderIsAuto[ABorder] then
      begin
        ABorderStyle := TdxSpreadSheetXLSXHelper.BorderStyleToString(ABordersHandle.BorderStyle[ABorder]);
        if ABorderStyle <> '' then
          AWriter.WriteAttributeString(sdxXLSXAttrStyle, ABorderStyle);
        WriteColor(AWriter, sdxXLSXNodeColor, ABordersHandle.BorderColor[ABorder]);
      end;
      AWriter.WriteEndElement;
    end;
    AWriter.WriteElementString(sdxXLSXNodeDiagonal, '');
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterStylesBuilder.ProcessStylesGroupCellStyle(AWriter: TdxXmlWriter; AData: Pointer);
var
  AStyleHandle: TdxSpreadSheetCellStyleHandle;
begin
  AWriter.WriteStartElement(sdxXLSXNodeStyleCellXf);
  try
    AStyleHandle := TdxSpreadSheetCellStyleHandle(AData);

    AWriter.WriteAttributeBoolean(sdxXLSXAttrApplyAlignment, True);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrApplyBorder, True);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrApplyFill, True);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrApplyNumberFormat, True);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrApplyFont, True);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrApplyProtection, True);

    AWriter.WriteAttributeInteger(sdxXLSXAttrBorderId, Borders.IndexOf(AStyleHandle.Borders));
    AWriter.WriteAttributeInteger(sdxXLSXAttrFillId, Fills.IndexOf(AStyleHandle.Brush));
    AWriter.WriteAttributeInteger(sdxXLSXAttrFontId, Fonts.IndexOf(AStyleHandle.Font));
    AWriter.WriteAttributeInteger(sdxXLSXAttrNumFmtId, GetFormatID(AStyleHandle.DataFormat));
    AWriter.WriteAttributeInteger(sdxXLSXAttrXFId, 0);

    AWriter.WriteStartElement(sdxXLSXNodeAlignment);
    try
      AWriter.WriteAttributeString(sdxXLSXAttrHorizontal, TdxSpreadSheetXLSXHelper.AlignHorzToString(AStyleHandle.AlignHorz));
      AWriter.WriteAttributeString(sdxXLSXAttrVertical, TdxSpreadSheetXLSXHelper.AlignVertToString(AStyleHandle.AlignVert));
      if AStyleHandle.AlignHorzIndent <> 0 then
        AWriter.WriteAttributeInteger(sdxXLSXAttrIndent, Owner.ColumnWidthHelper.PixelsToSpacesNumber(AStyleHandle.AlignHorzIndent));
      AWriter.WriteAttributeInteger(sdxXLSXAttrTextRotation, AStyleHandle.Rotation);
      AWriter.WriteAttributeBoolean(sdxXLSXAttrShrinkToFit, csShrinkToFit in AStyleHandle.States);
      AWriter.WriteAttributeBoolean(sdxXLSXAttrWrapText, csWordWrap in AStyleHandle.States);
    finally
      AWriter.WriteEndElement;
    end;

    AWriter.WriteStartElement(sdxXLSXNodeProtection);
    try
      AWriter.WriteAttributeBoolean(sdxXLSXAttrHidden, csHidden in AStyleHandle.States);
      AWriter.WriteAttributeBoolean(sdxXLSXAttrLocked, csLocked in AStyleHandle.States);
    finally
      AWriter.WriteEndElement;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterStylesBuilder.ProcessStylesGroupConditionalFormatting(AWriter: TdxXmlWriter; AData: Pointer);
var
  AStyle: TdxSpreadSheetCellStyleHandle;
begin
  AStyle := TdxSpreadSheetCellStyleHandle(AData);

  AWriter.WriteStartElement(sdxXLSXNodeDXF);
  try
    if AStyle.Font <> CellStyleDefault.Font then
      ProcessStylesGroupFont(AWriter, AStyle.Font);
    if AStyle.DataFormat <> CellStyleDefault.DataFormat then
      ProcessStylesGroupNumberFormat(AWriter, AStyle.DataFormat);
    if AStyle.Brush <> CellStyleDefault.Brush then
      ProcessStylesGroupFill(AWriter, AStyle.Brush);
    if AStyle.Borders <> CellStyleDefault.Borders then
      ProcessStylesGroupBorders(AWriter, AStyle.Borders);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterStylesBuilder.ProcessStylesGroupFill(AWriter: TdxXmlWriter; AData: Pointer);
var
  ABrushHandle: TdxSpreadSheetBrushHandle;
begin
  ABrushHandle := TdxSpreadSheetBrushHandle(AData);

  AWriter.WriteStartElement(sdxXLSXNodeStyleFill);
  try
    AWriter.WriteStartElement(sdxXLSXNodeCellStylePatternFill);
    AWriter.WriteAttributeString(sdxXLSXAttrPatternType, TdxSpreadSheetXLSXHelper.FillStyleToString(ABrushHandle));

    if ABrushHandle.Style = sscfsSolid then
    begin
      WriteColor(AWriter, sdxXLSXNodeForegroundColor, ABrushHandle.BackgroundColor);
      WriteColor(AWriter, sdxXLSXNodeBackgroundColor, ABrushHandle.BackgroundColor);
    end
    else
    begin
      WriteColor(AWriter, sdxXLSXNodeForegroundColor, ABrushHandle.ForegroundColor);
      WriteColor(AWriter, sdxXLSXNodeBackgroundColor, ABrushHandle.BackgroundColor);
    end;

    AWriter.WriteEndElement;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterStylesBuilder.ProcessStylesGroupFont(AWriter: TdxXmlWriter; AData: Pointer);
begin
  WriteFont(AWriter, sdxXLSXNodeStyleFont, sdxXLSXNodeName, TdxSpreadSheetFontHandle(AData));
end;

procedure TdxXLSXWriterStylesBuilder.ProcessStylesGroupNumberFormat(AWriter: TdxXmlWriter; AData: Pointer);
var
  AFormatID: Integer;
begin
  AFormatID := GetFormatID(TdxSpreadSheetFormatHandle(AData));
  if AFormatID >= CustomNumberFormatBase then
  begin
    AWriter.WriteStartElement(sdxXLSXNodeStyleNumberFormat);
    try
      AWriter.WriteAttributeString(sdxXLSXAttrFormatCode, TdxSpreadSheetFormatHandle(AData).FormatCode);
      AWriter.WriteAttributeInteger(sdxXLSXAttrNumFmtId, AFormatID);
    finally
      AWriter.WriteEndElement;
    end;
  end;
end;

function TdxXLSXWriterStylesBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXStyleRelationship;
end;

function TdxXLSXWriterStylesBuilder.GetContentType: string;
begin
  Result := sdxXLSXStylesContentType;
end;

procedure TdxXLSXWriterStylesBuilder.PrepareResources;
var
  AStyle: TdxSpreadSheetCellStyleHandle;
  I: Integer;
begin
  for I := 0 to CellStyles.Count - 1 do
  begin
    AStyle := TdxSpreadSheetCellStyleHandle(CellStyles.List[I]);
    Borders.Add(AStyle.Borders);
    Fills.Add(AStyle.Brush);
    Fonts.Add(AStyle.Font);
    if GetFormatID(AStyle.DataFormat) >= CustomNumberFormatBase then
      Formats.Add(AStyle.DataFormat);
  end;
end;

function TdxXLSXWriterStylesBuilder.GetBorders: TdxXLSXWriterResourceList;
begin
  Result := Owner.Borders;
end;

function TdxXLSXWriterStylesBuilder.GetCellStyleDefault: TdxSpreadSheetCellStyleHandle;
begin
  Result := Owner.CellStyleDefault;
end;

function TdxXLSXWriterStylesBuilder.GetCellStyles: TdxXLSXWriterResourceList;
begin
  Result := Owner.CellStyles;
end;

function TdxXLSXWriterStylesBuilder.GetConditionalFormattingStyles: TdxXLSXWriterResourceList;
begin
  Result := Owner.ConditionalFormattingStyles;
end;

function TdxXLSXWriterStylesBuilder.GetCustomFormats: TdxXLSXWriterResourceList;
begin
  Result := Owner.CustomFormats;
end;

function TdxXLSXWriterStylesBuilder.GetFills: TdxXLSXWriterResourceList;
begin
  Result := Owner.Fills;
end;

function TdxXLSXWriterStylesBuilder.GetFonts: TdxXLSXWriterResourceList;
begin
  Result := Owner.Fonts;
end;

{ TdxXLSXWriterWorkbookBuilder }

procedure TdxXLSXWriterWorkbookBuilder.AfterConstruction;
begin
  inherited AfterConstruction;
  FHasPrintableAreas := False;
end;

procedure TdxXLSXWriterWorkbookBuilder.ExecuteCore(AWriter: TdxXmlWriter);
var
  AWorkbookRels: TdxXLSXRelationships;
begin
  AWorkbookRels := TdxXLSXRelationships.Create;
  try
    AWriter.WriteStartElement(sdxXLSXNodeWorkbook);
    AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXWorkbookNameSpace);
    AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXNamespaceRelationship, '', sdxXLSXCommonRelationshipPath);

    WriteProperties(AWriter);
    WriteSheets(AWriter, AWorkbookRels);
    WriteExternalLinks(AWriter, AWorkbookRels);
    WriteDefinedNames(AWriter);
    WriteCalcProperties(AWriter);

    WriteSharedStrings(sdxXLSXSharedStringsFileName, AWorkbookRels); 
    WriteStyles(sdxXLSXStylesFileName, AWorkbookRels);

    AWriter.WriteEndElement; // sdxXLSXNodeWorkbook

    Owner.WriteRels(TargetFileNameRels, AWorkbookRels);
  finally
    AWorkbookRels.Free;
  end;
end;

function TdxXLSXWriterWorkbookBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXWorkbookRelationship;
end;

function TdxXLSXWriterWorkbookBuilder.GetContentType: string;
begin
  Result := Owner.GetContentTypeID;
end;

function TdxXLSXWriterWorkbookBuilder.HasPrintableAreas(AView: TdxSpreadSheetTableView): Boolean;
begin
  Result :=
    AView.OptionsPrint.Source.Area.Assigned or
    AView.OptionsPrint.Source.RowsToRepeat.Assigned or
    AView.OptionsPrint.Source.ColumnsToRepeat.Assigned;
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteCalcProperties(AWriter: TdxXmlWriter);
const
  Map: array[Boolean] of AnsiString = (sdxXLSXValueA1, sdxXLSXValueR1C1);
var
  AOptions: TdxSpreadSheetOptionsBehavior;
begin
  AOptions := SpreadSheet.OptionsBehavior;

  AWriter.WriteStartElement(sdxXLSXNodeCalcPr);
  AWriter.WriteAttributeString(sdxXLSXAttrRefMode, Map[SpreadSheet.OptionsView.R1C1Reference]);
  if AOptions.IterativeCalculation then
  begin
    AWriter.WriteAttributeInteger(sdxXLSXAttrIterate, 1);
    if AOptions.IterativeCalculationMaxCount <> 100 then
      AWriter.WriteAttributeInteger(sdxXLSXAttrIterateCount, AOptions.IterativeCalculationMaxCount);
  end;
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteDefinedName(AWriter: TdxXmlWriter; ADefinedName: TdxSpreadSheetDefinedName);
begin
  WriteDefinedName(AWriter, ADefinedName.Caption, ADefinedName.Reference, ADefinedName.Comment, ADefinedName.Scope);
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteDefinedName(
  AWriter: TdxXmlWriter; const ACaption, AReference, AComment: string; AScope: TdxSpreadSheetCustomView);
begin
  AWriter.WriteStartElement(sdxXLSXNodeDefinedName);
  AWriter.WriteAttributeString(sdxXLSXAttrName, ACaption);
  if AScope <> nil then
    AWriter.WriteAttributeInteger(sdxXLSXAttrLocalSheetId, AScope.Index);
  if AComment <> '' then
    AWriter.WriteAttributeString(sdxXLSXAttrComment, AComment);
  AWriter.WriteString(dxSpreadSheetFormulaExcludeEqualSymbol(AReference));
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteDefinedNames(AWriter: TdxXmlWriter);
var
  AView: TdxSpreadSheetCustomView;
  I: Integer;
begin
  if (SpreadSheet.DefinedNames.Count > 0) or FHasPrintableAreas then
  begin
    AWriter.WriteStartElement(sdxXLSXNodeDefinedNames);
    for I := 0 to SpreadSheet.DefinedNames.Count - 1 do
      WriteDefinedName(AWriter, SpreadSheet.DefinedNames[I]);
    for I := 0 to SpreadSheet.SheetCount - 1 do
    begin
      AView := SpreadSheet.Sheets[I];
      if AView is TdxSpreadSheetTableView then
        WritePrintableAreas(AWriter, TdxSpreadSheetTableView(AView));
    end;
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteExternalLink(
  const AFileName: string; ALink: TdxSpreadSheetExternalLink; ARels: TdxXLSXRelationships);
begin
  ExecuteSubTask(TdxXLSXWriterExternalLinkBuilder.Create(Owner, ARels, ALink, AFileName));
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteExternalLinks(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships);
var
  AFileName: string;
  I: Integer;
begin
  if SpreadSheet.ExternalLinks.Count > 0 then
  begin
    AWriter.WriteStartElement(sdxXLSXNodeExternalReferences);
    for I := 0 to SpreadSheet.ExternalLinks.Count - 1 do
    begin
      AFileName := Format(sdxXLSXFileTemplateExternalLink, [I + 1]);
      WriteExternalLink(AFileName, SpreadSheet.ExternalLinks[I], ARels);

      AWriter.WriteStartElement(sdxXLSXNodeExternalReference);
      AWriter.WriteAttributeString(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '', ARels.GetIdByTarget(dxUnixPathDelim + AFileName));
      AWriter.WriteEndElement;
    end;
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorkbookBuilder.WritePrintableAreas(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView);
begin
  if AView.OptionsPrint.Source.Area.Assigned then
  begin
    WriteDefinedName(AWriter, sdxXLSXPrintAreaDefinedName,
      TdxSpreadSheetDefinedNameHelper.BuildReference(AView, AView.OptionsPrint.Source.Area.Rect), '', AView);
  end;

  if AView.OptionsPrint.Source.RowsToRepeat.Assigned or AView.OptionsPrint.Source.ColumnsToRepeat.Assigned then
  begin
    WriteDefinedName(AWriter, sdxXLSXPrintTitlesDefinedName,
      TdxSpreadSheetPrintAreasHelper.BuildPrintTitlesReference(AView), '', AView);
  end;
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteProperties(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNodeWorkbookPr);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrDate1904, SpreadSheet.OptionsView.ActualDateTimeSystem = dts1904);
  AWriter.WriteEndElement;

  WriteProtection(AWriter);

  AWriter.WriteStartElement(sdxXLSXNodeBookViews);
  AWriter.WriteStartElement(sdxXLSXNodeWorkBookView);
  AWriter.WriteAttributeInteger(sdxXLSXAttrActiveTab, SpreadSheet.ActiveSheetIndex);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrShowHorizontalScroll, SpreadSheet.OptionsView.HorizontalScrollBar);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrShowVerticalScroll, SpreadSheet.OptionsView.VerticalScrollBar);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrShowSheetTabs, SpreadSheet.PageControl.Visible);
  AWriter.WriteEndElement; // sdxXLSXNodeWorkBookView
  AWriter.WriteEndElement; // sdxXLSXNodeBookViews
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteProtection(AWriter: TdxXmlWriter);
var
  AProtection: TdxSpreadSheetStrongProtectionInfo;
begin
  if SpreadSheet.OptionsProtection.Protected then
  begin
    AWriter.WriteStartElement(sdxXLSXNodeWorkbookProtection);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrLockStructure, not SpreadSheet.OptionsProtection.AllowChangeStructure);

    if SpreadSheet.OptionsProtection.ProtectionInfo is TdxSpreadSheetStandardProtectionInfo then
    begin
      AWriter.WriteAttributeString(sdxXLSXAttrWorkbookPassword,
        TdxSpreadSheetStandardProtectionInfo(SpreadSheet.OptionsProtection.ProtectionInfo).KeyWordAsString);
    end
    else

    if SpreadSheet.OptionsProtection.ProtectionInfo is TdxSpreadSheetStrongProtectionInfo then
    begin
      AProtection := TdxSpreadSheetStrongProtectionInfo(SpreadSheet.OptionsProtection.ProtectionInfo);
      AWriter.WriteAttributeString(sdxXLSXAttrWorkbookAlgorithmName, dxXLSXHashAlgorithmTypeNames[AProtection.HashAlgorithm]);
      AWriter.WriteAttributeString(sdxXLSXAttrWorkbookHashValue, AProtection.HashValueAsString);
      AWriter.WriteAttributeString(sdxXLSXAttrWorkbookSaltValue, AProtection.SaltValueAsString);
      AWriter.WriteAttributeInteger(sdxXLSXAttrWorkbookSpinCount, AProtection.SpinCount);
    end;

    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteSheets(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships);
var
  I: Integer;
begin
  AWriter.WriteStartElement(sdxXLSXNodeSheets);
  for I := 0 to SpreadSheet.SheetCount - 1 do
    WriteSheet(AWriter, SpreadSheet.Sheets[I], ARels);
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteSheetView(
  const AFileName: string; AView: TdxSpreadSheetCustomView; ARels: TdxXLSXRelationships);
var
  ATableView: TdxSpreadSheetTableView;
begin
  if AView is TdxSpreadSheetTableView then
  begin
    ATableView := TdxSpreadSheetTableView(AView);
    ExecuteSubTask(TdxXLSXWriterWorksheetTableViewBuilder.Create(Owner, ARels, AFileName, ATableView));
    FHasPrintableAreas := FHasPrintableAreas or HasPrintableAreas(ATableView);
  end
  else
    DoError(sdxErrorInternal, ['export of ' + AView.ClassName + ' is not supported'], ssmtError);
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteStyles(const AFileName: string; ARels: TdxXLSXRelationships);
begin
  ExecuteSubTask(TdxXLSXWriterStylesBuilder.Create(Owner, ARels, AFileName));
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteSharedStrings(const AFileName: string; ARels: TdxXLSXRelationships);
begin
  ExecuteSubTask(TdxXLSXWriterSharedStringsBuilder.Create(Owner, ARels, AFileName));
end;

procedure TdxXLSXWriterWorkbookBuilder.WriteSheet(
  AWriter: TdxXmlWriter; AView: TdxSpreadSheetCustomView; ARels: TdxXLSXRelationships);
var
  AFileName: string;
begin
  AWriter.WriteStartElement(sdxXLSXNodeSheet);

  AFileName := Format(sdxXLSXFileTemplateWorksheet, [AView.Index + 1]);
  AWriter.WriteAttributeString(sdxXLSXAttrName, AView.Caption);
  AWriter.WriteAttributeInteger(sdxXLSXAttrSheetId, AView.Index + 1);
  if not AView.Visible then
    AWriter.WriteAttributeString(sdxXLSXAttrState, sdxXLSXValueHidden);
  WriteSheetView(AFileName, AView, ARels);
  AWriter.WriteAttributeString(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '', ARels.GetIdByTarget(dxUnixPathDelim + AFileName));

  AWriter.WriteEndElement;
end;

{ TdxXLSXWriterWorksheetTableViewBuilder }

constructor TdxXLSXWriterWorksheetTableViewBuilder.Create(AOwner: TdxSpreadSheetXLSXWriter;
  AOwnerRels: TdxXLSXRelationships; const ATargetFileName: string; AView: TdxSpreadSheetTableView);
begin
  inherited Create(AOwner, AOwnerRels, ATargetFileName);
  FView := AView;
  FContainers := TList.Create;
  FComments := TList.Create;
end;

destructor TdxXLSXWriterWorksheetTableViewBuilder.Destroy;
begin
  FreeAndNil(FContainers);
  FreeAndNil(FComments);
  inherited Destroy;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.ExecuteCore(AWriter: TdxXmlWriter);
var
  ARels: TdxXLSXRelationships;
begin
  InitializeContainers;

  ARels := TdxXLSXRelationships.Create;
  try
    AWriter.WriteStartElement(sdxXLSXNodeWorksheet, sdxXLSXWorkbookNameSpace);
    AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, 'r', '', sdxXLSXCommonRelationshipPath);
    WriteContent(AWriter, ARels);
    AWriter.WriteEndElement;

    Owner.WriteRels(TargetFileNameRels, ARels);
  finally
    ARels.Free;
  end;
end;

function TdxXLSXWriterWorksheetTableViewBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXWorksheetRelationship;
end;

function TdxXLSXWriterWorksheetTableViewBuilder.GetContentType: string;
begin
  Result := sdxXLSXWorksheetContentType;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.InitializeContainers;
var
  AContainer: TdxSpreadSheetContainer;
  I: Integer;
begin
  for I := 0 to View.Containers.Count - 1 do
  begin
    AContainer := View.Containers[I];
    if AContainer is TdxSpreadSheetCommentContainer then
      Comments.Add(TdxSpreadSheetCommentContainer(AContainer))
    else
      Containers.Add(AContainer);
  end;
end;

function TdxXLSXWriterWorksheetTableViewBuilder.ConvertRowHeight(const AValue: Integer): Double;
begin
  Result := TdxValueUnitsHelper.PixelsToPoints(Max(AValue, 1));
end;

function TdxXLSXWriterWorksheetTableViewBuilder.EncodeFloat(const AValue: Double): string;
begin
  Result := FloatToStr(AValue, dxInvariantFormatSettings);
end;

function TdxXLSXWriterWorksheetTableViewBuilder.GetActivePane(out AValue: string): Boolean;
begin
  Result := (View.FrozenColumn >= 0) or (View.FrozenRow >= 0);
  if Result then
  begin
    if View.FrozenRow < 0 then
      AValue := sdxXLSXValuePaneTopRight
    else
      if View.FrozenColumn >= 0 then
        AValue := sdxXLSXValuePaneBottomRight
      else
        AValue := sdxXLSXValuePaneBottomLeft;
  end;
end;

function TdxXLSXWriterWorksheetTableViewBuilder.ValidateDimensions(const R: TRect): TRect;
begin
  Result := R;
  Result.Right := Min(Result.Right, dxXLSXMaxColumnIndex);
  Result.Bottom := Min(Result.Bottom, dxXLSXMaxRowIndex);
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteBreaks(
  AWriter: TdxXMLWriter; const ANodeName: string; AList: TList<Cardinal>; AMaxIndex: Integer);
var
  I: Integer;
begin
  AList.Sort;
  AWriter.WriteStartElement(ANodeName);
  try
    AWriter.WriteAttributeInteger(sdxXLSXAttrBreaksCount, AList.Count);
    AWriter.WriteAttributeInteger(sdxXLSXAttrBreaksManualBreakCount, AList.Count);
    for I := 0 to AList.Count - 1 do
    begin
      AWriter.WriteStartElement(sdxXLSXNodeBreak);
      AWriter.WriteAttributeInteger(sdxXLSXAttrBreakID, AList[I]);
      AWriter.WriteAttributeInteger(sdxXLSXAttrMin, 0);
      AWriter.WriteAttributeInteger(sdxXLSXAttrMax, AMaxIndex);
      AWriter.WriteAttributeBoolean(sdxXLSXAttrBreakManual, True);
      AWriter.WriteEndElement;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteCell(
  AWriter: TdxXmlWriter; ACell: TdxSpreadSheetCell; ARowIndex, AColumnIndex: Integer);
const
  Map: array[TdxSpreadSheetCellDataType] of TdxSpreadSheetXLSXCellType = (
    sxctUnknown, sxctBoolean, sxctError, sxctFloat, sxctFloat, sxctFloat, sxctFloat, sxctSharedString, sxctFormula
  );
var
  ADataType: TdxSpreadSheetXLSXCellType;
begin
  AWriter.WriteStartElement('c');
  try
    AWriter.WriteAttributeString(sdxXLSXAttrCellColumn, dxReferenceToString(ARowIndex, AColumnIndex));
    AWriter.WriteAttributeInteger(sdxXLSXAttrStyleIndex, Owner.CellStyles.Add(ACell.StyleHandle));

    ADataType := Map[ACell.DataType];
    if ADataType <> sxctUnknown then
    begin
      if dxXLSXCellDataTypeNames[ADataType] <> '' then
        AWriter.WriteAttributeString(sdxXLSXAttrCellType, dxXLSXCellDataTypeNames[ADataType]);

      case ADataType of
        sxctFloat:
          AWriter.WriteElementString(sdxXLSXNodeCellValue, EncodeFloat(ACell.AsFloat));
        sxctBoolean:
          AWriter.WriteElementString(sdxXLSXNodeCellValue, TdxXMLHelper.EncodeBoolean(ACell.AsBoolean));
        sxctError:
          AWriter.WriteElementString(sdxXLSXNodeCellValue, dxSpreadSheetErrorCodeToString(ACell.AsError));
        sxctSharedString:
          AWriter.WriteElementStringEx(sdxXLSXNodeCellValue, IntToStr(Owner.SharedStrings.Add(ACell.AsSharedString)));
        sxctFormula:
          begin
            AWriter.WriteStartElement(sdxXLSXNodeCellFunction);
            if ACell.AsFormula.IsArrayFormula then
            begin
              AWriter.WriteAttributeString(sdxXLSXAttrCellType, sdxXLSXValueArray);
              AWriter.WriteAttributeString(sdxXLSXAttrRef, dxReferenceToString(
                cxRect(ACell.ColumnIndex, ACell.RowIndex,
                  ACell.ColumnIndex + ACell.AsFormula.ArrayFormulaSize.cx - 1,
                  ACell.RowIndex + ACell.AsFormula.ArrayFormulaSize.cy - 1)
              ));
            end;
            AWriter.WriteValue(Copy(ACell.AsFormula.AsText, 2, MaxInt));
            AWriter.WriteEndElement;
          end;
      else
        DoError(sdxErrorInternal, [sMsgWrongDataType], ssmtError);
      end;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteColumns(AWriter: TdxXmlWriter; ADimension: TRect);
var
  ANodeStarted: Boolean;

  function CompareColumns(AColumn1, AColumn2: TdxSpreadSheetTableColumnAccess): Boolean;
  begin
    Result := (AColumn1 = nil) and (AColumn2 = nil) or
      (AColumn1 <> nil) and (AColumn2 <> nil) and (AColumn1.Style.Handle = AColumn2.Style.Handle) and
      (AColumn1.CustomSize = AColumn2.CustomSize) and (AColumn1.Visible = AColumn2.Visible);
  end;

  function GetColumnStyle(AColumn: TdxSpreadSheetTableColumnAccess): TdxSpreadSheetCellStyleHandle;
  begin
    if AColumn <> nil then
      Result := AColumn.Style.Handle
    else
      Result := View.CellStyles.DefaultStyle;
  end;

  function GetColumnSize(AColumn: TdxSpreadSheetTableColumnAccess): Integer;
  begin
    if (AColumn = nil) or AColumn.DefaultSize then
      Result := View.Columns.DefaultSize
    else
      Result := AColumn.CustomSize;
  end;

  procedure AddColumnInfo(AColumn: TdxSpreadSheetTableColumnAccess; AColumnIndex: Integer;
    AColumnGroup: TdxSpreadSheetTableItemGroupAccess; ACollapsed: Boolean; AFinishIndex: Integer;
    AForce: Boolean = False);
  begin
    if AColumnIndex > AFinishIndex then
      Exit;
    if AColumnIndex > dxXLSXMaxColumnIndex then
      Exit;
    if not AForce and (AColumn = nil) and (AColumnGroup = nil) and not ACollapsed then
      Exit;

    if not ANodeStarted then
    begin
      AWriter.WriteStartElement(sdxXLSXNodeColumns);
      ANodeStarted := True;
    end;

    AWriter.WriteStartElement(sdxXLSXNodeColumn);
    try
      AWriter.WriteAttributeInteger(sdxXLSXAttrMax, AFinishIndex + 1);
      AWriter.WriteAttributeInteger(sdxXLSXAttrMin, AColumnIndex + 1);
      AWriter.WriteAttributeInteger(sdxXLSXAttrStyle, Owner.CellStyles.Add(GetColumnStyle(AColumn)));
      AWriter.WriteAttributeFloat(sdxXLSXAttrWidth, Owner.ColumnWidthHelper.PixelsToWidth(GetColumnSize(AColumn)));
      if AColumnGroup <> nil then
        AWriter.WriteAttributeInteger(sdxXLSXAttrOutlineLevel, AColumnGroup.Level + 1);
      if ACollapsed then
        AWriter.WriteAttributeBoolean(sdxXLSXAttrCollapsed, True);
      if (AColumn <> nil) and not AColumn.DefaultSize then
      begin
        AWriter.WriteAttributeBoolean(sdxXLSXAttrCustomWidth, True);
        if not AColumn.IsCustomSize then
          AWriter.WriteAttributeBoolean(sdxXLSXAttrBestFit, True);
      end;
      if (AColumn <> nil) and not AColumn.Visible then
        AWriter.WriteAttributeBoolean(sdxXLSXAttrHidden, True);
    finally
      AWriter.WriteEndElement;
    end;
  end;

var
  ACollapsed: Boolean;
  AColumn: TdxSpreadSheetTableColumnAccess;
  AColumnGroup: TdxSpreadSheetTableItemGroupAccess;
  AColumnIndex: Integer;
  APrevColumn: TdxSpreadSheetTableColumnAccess;
  APrevColumnGroup: TdxSpreadSheetTableItemGroupAccess;
  APrevColumnIndex: Integer;
begin
  ANodeStarted := False;
  ADimension.Right := Max(ADimension.Right, View.Columns.LastIndex);
  ExtendDimensionsByGroups(View.Columns.Groups, ADimension.Left, ADimension.Right);
  ADimension := ValidateDimensions(ADimension);

  ACollapsed := False;
  APrevColumnIndex := ADimension.Left;
  APrevColumnGroup := TdxSpreadSheetTableItemGroupAccess(View.Columns.Groups.Find(APrevColumnIndex));
  APrevColumn := TdxSpreadSheetTableColumnAccess(View.Columns.Items[APrevColumnIndex]);

  for AColumnIndex := ADimension.Left + 1 to ADimension.Right do
  begin
    AColumn := TdxSpreadSheetTableColumnAccess(View.Columns.Items[AColumnIndex]);
    AColumnGroup := TdxSpreadSheetTableItemGroupAccess(View.Columns.Groups.Find(AColumnIndex));

    if (APrevColumnGroup <> AColumnGroup) or not CompareColumns(AColumn, APrevColumn) then
    begin
      AddColumnInfo(APrevColumn, APrevColumnIndex, APrevColumnGroup, ACollapsed, AColumnIndex - 1);
      ACollapsed := (APrevColumnGroup <> nil) and APrevColumnGroup.IsCollapsedByUser;
      APrevColumnGroup := AColumnGroup;
      APrevColumnIndex := AColumnIndex;
      APrevColumn := AColumn;
    end;
  end;

  AddColumnInfo(APrevColumn, APrevColumnIndex, APrevColumnGroup, ACollapsed, ADimension.Right);

  if Owner.CellStyleDefault <> SpreadSheet.DefaultCellStyle.Handle then
    AddColumnInfo(nil, ADimension.Right + 1, nil, False, dxXLSXMaxColumnIndex, True);
  if ANodeStarted then
    AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteComments(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships);
var
  AFileName: string;
begin
  AWriter.WriteStartElement(sdxXLSXNodeLegacyDrawing);
  try
    AFileName := Format(sdxXLSXFileTemplateVMLDrawing, [View.Index + 1]);
    ExecuteSubTask(TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder.Create(AFileName, ARels, Self));
    ExecuteSubTask(TdxXLSXWriterWorksheetTableViewCommentsBuilder.Create(Self, ARels, Format(sdxXLSXFileTemplateComments, [View.Index + 1])));
    AWriter.WriteAttributeString('r', 'id', '', ARels.GetIdByTarget(dxUnixPathDelim + AFileName));
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteConditionalFormatting(AWriter: TdxXmlWriter);
begin
  ExecuteSubTask(TdxXLSXWriterWorksheetConditionalFormattingBuilder.Create(Owner, AWriter, View.ConditionalFormatting));
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteContainers(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships);
var
  AFileName: string;
begin
  AWriter.WriteStartElement(sdxXLSXNodeDrawing);
  try
    AFileName := Format(sdxXLSXFileTemplateDrawing, [View.Index + 1]);
    ExecuteSubTask(TdxXLSXWriterWorksheetContainersBuilder.Create(AFileName, Containers, Owner, ARels));
    AWriter.WriteAttributeString('r', 'id', '', ARels.GetIdByTarget(dxUnixPathDelim + AFileName));
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteContent(
  AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships);
var
  ADimension: TRect;
begin
  ADimension := ValidateDimensions(View.Dimensions);
  // sdxXLSXNodeSheetPr
  AWriter.WriteStartElement(sdxXLSXNodeSheetPr);
  AWriter.WriteStartElement(sdxXLSXNodeOutlinePr);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrSummaryBelow, View.Rows.Groups.ExpandButtonPosition = gebpGroupFinish);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrSummaryRight, View.Columns.Groups.ExpandButtonPosition = gebpGroupFinish);
  AWriter.WriteEndElement;
  if View.OptionsPrint.Page.ScaleMode <> oppsmDefault then
  begin
    AWriter.WriteStartElement(sdxXLSXNodePageSetUpPr);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrFitToPage, View.OptionsPrint.Page.ScaleMode = oppsmFitToPage);
    AWriter.WriteEndElement;
  end;
  AWriter.WriteEndElement;

  // sdxXLSXNodeDimension
  AWriter.WriteStartElement(sdxXLSXNodeDimension);
  AWriter.WriteAttributeString(sdxXLSXAttrRef, dxReferenceToString(ADimension));
  AWriter.WriteEndElement;

  WriteViewProperties(AWriter);
  WriteProperties(AWriter);
  WriteColumns(AWriter, ADimension);
  WriteRows(AWriter, ADimension);

  if View.Options.Protected then
    WriteViewProtection(AWriter);
  if View.MergedCells.Count > 0 then
    WriteMergedCells(AWriter, View.MergedCells);

  WriteConditionalFormatting(AWriter);
  WriteHyperlinks(AWriter, ARels);
  WritePrintOptions(AWriter);

  if View.OptionsPrint.Page.Margins.Assigned then
    WritePageMargins(AWriter, View.OptionsPrint.Page.Margins);

  WritePageSetup(AWriter);

  if View.OptionsPrint.HeaderFooter.Assigned then
    WriteHeaderFooter(AWriter, View.OptionsPrint.HeaderFooter);
  if View.OptionsPrint.Pagination.RowPageBreaks.Count > 0 then
    WriteBreaks(AWriter, sdxXLSXNodeRowBreaks, View.OptionsPrint.Pagination.RowPageBreaks, View.Dimensions.Bottom);
  if View.OptionsPrint.Pagination.ColumnPageBreaks.Count > 0 then
    WriteBreaks(AWriter, sdxXLSXNodeColBreaks, View.OptionsPrint.Pagination.ColumnPageBreaks, View.Dimensions.Right);
  if Containers.Count > 0 then
    WriteContainers(AWriter, ARels);
  if Comments.Count > 0 then
    WriteComments(AWriter, ARels);
  WriteExtensions(AWriter);
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteExtensions(AWriter: TdxXmlWriter);
begin
  ExecuteSubTask(TdxXLSXWriterWorksheetConditionalFormattingExBuilder.Create(Owner, AWriter, View.ConditionalFormatting));
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteFixedPaneProperties(AWriter: TdxXmlWriter);
var
  AValue: string;
begin
  AWriter.WriteStartElement(sdxXLSXNodePane);
  try
    AWriter.WriteAttributeString(sdxXLSXAttrTopLeftCell, dxReferenceToString(
      TdxSpreadSheetTableViewAccess(View).ViewInfo.FirstScrollableRow,
      TdxSpreadSheetTableViewAccess(View).ViewInfo.FirstScrollableColumn));
    AWriter.WriteAttributeString(sdxXLSXAttrState, sdxXLSXValueFrozen);
    if GetActivePane(AValue) then
      AWriter.WriteAttributeString(sdxXLSXAttrActivePane, AValue);
    if View.FrozenColumn >= 0 then
      AWriter.WriteAttributeInteger(sdxXLSXAttrSplitX, View.FrozenColumn + 1);
    if View.FrozenRow >= 0 then
      AWriter.WriteAttributeInteger(sdxXLSXAttrSplitY, View.FrozenRow + 1);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteHeaderFooter(
  AWriter: TdxXmlWriter; AHeaderFooter: TdxSpreadSheetTableViewOptionsPrintHeaderFooter);
begin
  AWriter.WriteStartElement(sdxXLSXNodeHeaderFooter);
  try
    if AHeaderFooter.AlignWithMargins <> bDefault then
      AWriter.WriteAttributeBoolean(sdxXLSXAttrHeaderFooterAlignWithMargins, AHeaderFooter.AlignWithMargins = bTrue);
    if AHeaderFooter.ScaleWithDocument <> bDefault then
      AWriter.WriteAttributeBoolean(sdxXLSXAttrHeaderFooterScaleWithDocument, AHeaderFooter.ScaleWithDocument = bTrue);
    if AHeaderFooter.EvenPagesFooter.Assigned or AHeaderFooter.EvenPagesHeader.Assigned then
      AWriter.WriteAttributeBoolean(sdxXLSXAttrHeaderFooterDifferentOddEven, True);
    if AHeaderFooter.FirstPageFooter.Assigned or AHeaderFooter.FirstPageHeader.Assigned then
      AWriter.WriteAttributeBoolean(sdxXLSXAttrHeaderFooterDifferentFirst, True);

    WriteHeaderFooterText(AWriter, sdxXLSXNodeOddHeader, AHeaderFooter.CommonHeader);
    WriteHeaderFooterText(AWriter, sdxXLSXNodeOddFooter, AHeaderFooter.CommonFooter);

    if AHeaderFooter.EvenPagesFooter.Assigned or AHeaderFooter.EvenPagesHeader.Assigned then
    begin
      WriteHeaderFooterText(AWriter, sdxXLSXNodeEvenHeader, AHeaderFooter.EvenPagesHeader);
      WriteHeaderFooterText(AWriter, sdxXLSXNodeEvenFooter, AHeaderFooter.EvenPagesFooter);
    end;

    if AHeaderFooter.FirstPageFooter.Assigned or AHeaderFooter.FirstPageHeader.Assigned then
    begin
      WriteHeaderFooterText(AWriter, sdxXLSXNodeFirstHeader, AHeaderFooter.FirstPageHeader);
      WriteHeaderFooterText(AWriter, sdxXLSXNodeFirstFooter, AHeaderFooter.FirstPageFooter);
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteHeaderFooterText(
  AWriter: TdxXmlWriter; const ANodeName: string; AText: TdxSpreadSheetTableViewOptionsPrintHeaderFooterText);
begin
  AWriter.WriteElementStringEx(ANodeName, TdxSpreadSheetHeaderFooterHelper.Build(AText));
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteHyperlink(
  AWriter: TdxXmlWriter; AHyperlink: TdxSpreadSheetHyperLink; ARels: TdxXLSXRelationships);
begin
  AWriter.WriteStartElement(sdxXLSXNodeHyperlink);
  try
    AWriter.WriteAttributeString(sdxXLSXAttrRef, dxReferenceToString(AHyperlink.Area));
    if havDisplayText in AHyperlink.AssignedValues then
      AWriter.WriteAttributeString(sdxXLSXAttrDisplay, AHyperlink.DisplayText);
    if havScreenTip in AHyperlink.AssignedValues then
      AWriter.WriteAttributeString(sdxXLSXAttrTooltip, AHyperlink.ScreenTip);
    if AHyperlink.ValueType = hvtReference then
      AWriter.WriteAttributeString(sdxXLSXAttrLocation, dxSpreadSheetFormulaExcludeEqualSymbol(AHyperlink.Value))
    else
    begin
      AWriter.WriteAttributeString('r', 'id', '',
        ARels.AddNew(AHyperlink.Value, sdxXLSXHyperlinkRelationship, sdxXLSXValueTargetModeExternal));
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteHyperlinks(
  AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships);
var
  ANodeStarted: Boolean;
  AHyperlink: TdxSpreadSheetHyperlink;
begin
  ANodeStarted := False;
  AHyperlink := View.Hyperlinks.First;
  while AHyperlink <> nil do
  begin
    if AHyperlink.IsAreaCorrect then
    begin
      if not ANodeStarted then
      begin
        ANodeStarted := True;
        AWriter.WriteStartElement(sdxXLSXNodeHyperlinks);
      end;
      WriteHyperlink(AWriter, AHyperlink, ARels);
    end;
    AHyperlink := AHyperlink.Next;
  end;
  if ANodeStarted then
    AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteMergedCells(
  AWriter: TdxXmlWriter; AMergedCells: TdxSpreadSheetMergedCellList);
var
  AItem: TdxSpreadSheetMergedCell;
begin
  AWriter.WriteStartElement(sdxXLSXNodeMergeCells);
  try
    AItem := AMergedCells.First;
    while AItem <> nil do
    begin
      AWriter.WriteStartElement(sdxXLSXNodeMergeCell);
      AWriter.WriteAttributeString(sdxXLSXAttrRef, dxReferenceToString(AItem.Area));
      AWriter.WriteEndElement;

      AItem := TdxSpreadSheetMergedCell(AItem.Next);
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WritePageMargins(
  AWriter: TdxXmlWriter; AMargins: TdxSpreadSheetTableViewOptionsPrintPageMargins);
begin
  AWriter.WriteStartElement(sdxXLSXNodePageMargins);
  try
    AWriter.WriteAttributeFloat(sdxXLSXAttrPageMarginsLeft, AMargins.Left);
    AWriter.WriteAttributeFloat(sdxXLSXAttrPageMarginsTop, AMargins.Top);
    AWriter.WriteAttributeFloat(sdxXLSXAttrPageMarginsRight, AMargins.Right);
    AWriter.WriteAttributeFloat(sdxXLSXAttrPageMarginsBottom, AMargins.Bottom);
    AWriter.WriteAttributeFloat(sdxXLSXAttrPageMarginsHeader, AMargins.Header);
    AWriter.WriteAttributeFloat(sdxXLSXAttrPageMarginsFooter, AMargins.Footer);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WritePageSetup(AWriter: TdxXmlWriter);
var
  APage: TdxSpreadSheetTableViewOptionsPrintPage;
  APaper: TdxSpreadSheetTableViewOptionsPrintPagePaper;
  APrinting: TdxSpreadSheetTableViewOptionsPrintPrinting;
begin
  AWriter.WriteStartElement(sdxXLSXNodePageSetup);
  try
    APage := View.OptionsPrint.Page;
    AWriter.WriteAttributeString(sdxXLSXAttrPageSetupOrientation, dxXLSXPrintPageOrientation[APage.Orientation]);
    if APage.ScaleMode = oppsmFitToPage then
    begin
      AWriter.WriteAttributeInteger(sdxXLSXAttrPageSetupFitToHeight, APage.FitToHeight);
      AWriter.WriteAttributeInteger(sdxXLSXAttrPageSetupFitToWidth, APage.FitToWidth);
    end;

    if APage.Scale <> 100 then
      AWriter.WriteAttributeInteger(sdxXLSXAttrPageSetupScale, APage.Scale);

    if APage.FirstPageNumber > 0 then
    begin
      AWriter.WriteAttributeInteger(sdxXLSXAttrPageSetupFirstPageNumber, APage.FirstPageNumber);
      AWriter.WriteAttributeBoolean(sdxXLSXAttrPageSetupUseFirstPageNumber, True);
    end;

    APaper := View.OptionsPrint.Page.Paper;
    if APaper.Assigned then
    begin
      if APaper.SizeID > 0 then
        AWriter.WriteAttributeInteger(sdxXLSXAttrPageSetupPaperSize, APaper.SizeID)
      else
        if (APaper.CustomSize.X > 0) and (APaper.CustomSize.Y > 0) then
        begin
          AWriter.WriteAttributeString(sdxXLSXAttrPageSetupPaperWidth, FloatToStr(APaper.CustomSize.X, dxInvariantFormatSettings) + 'in');
          AWriter.WriteAttributeString(sdxXLSXAttrPageSetupPaperHeight, FloatToStr(APaper.CustomSize.Y, dxInvariantFormatSettings) + 'in');
        end;
    end;

    APrinting := View.OptionsPrint.Printing;
    if APrinting.BlackAndWhite <> bDefault then
      AWriter.WriteAttributeBoolean(sdxXLSXAttrPageSetupBlackAndWhite, APrinting.BlackAndWhite = bTrue);
    if APrinting.Draft <> bDefault then
      AWriter.WriteAttributeBoolean(sdxXLSXAttrPageSetupDraft, APrinting.Draft = bTrue);
    if APrinting.Copies > 0 then
      AWriter.WriteAttributeInteger(sdxXLSXAttrPageSetupCopies, Min(APrinting.Copies, MAXSHORT));
    if APrinting.PageOrder <> opppDefault then
      AWriter.WriteAttributeString(sdxXLSXAttrPageSetupPageOrder, dxXLSXPrintPageOrder[APrinting.PageOrder]);
    if View.OptionsPrint.Source.ErrorIndication <> pseiDefault then
      AWriter.WriteAttributeString(sdxXLSXAttrPageSetupErrors, dxXLSXPrintErrorIndication[View.OptionsPrint.Source.ErrorIndication]);
    AWriter.WriteAttributeString(sdxXLSXAttrPageSetupCellComments, dxXLSXPrintCellComments[View.OptionsPrint.Source.CellComments]);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WritePrintOptions(AWriter: TdxXmlWriter);

  function ArePrintOptionsAssigned: Boolean;
  begin
    Result :=
      (View.OptionsPrint.Source.Headers <> bDefault) or
      (View.OptionsPrint.Source.GridLines <> bDefault) or
      (View.OptionsPrint.Printing.HorizontalCentered <> bDefault) or
      (View.OptionsPrint.Printing.VerticalCentered <> bDefault);
  end;

begin
  if ArePrintOptionsAssigned then
  begin
    AWriter.WriteStartElement(sdxXLSXNodePrintOptions);
    try
      if View.OptionsPrint.Printing.HorizontalCentered <> bDefault then
        AWriter.WriteAttributeBoolean(sdxXLSXAttrPrintOptionsHorzCenter, View.OptionsPrint.Printing.HorizontalCentered = bTrue);
      if View.OptionsPrint.Printing.VerticalCentered <> bDefault then
        AWriter.WriteAttributeBoolean(sdxXLSXAttrPrintOptionsVertCenter, View.OptionsPrint.Printing.VerticalCentered = bTrue);
      if View.OptionsPrint.Source.Headers <> bDefault then
        AWriter.WriteAttributeBoolean(sdxXLSXAttrPrintOptionsHeadings, View.OptionsPrint.Source.Headers = bTrue);
      if View.OptionsPrint.Source.GridLines <> bDefault then
      begin
        AWriter.WriteAttributeBoolean(sdxXLSXAttrPrintOptionsGridLines, View.OptionsPrint.Source.GridLines = bTrue);
        AWriter.WriteAttributeBoolean(sdxXLSXAttrPrintOptionsGridLinesSet, True);
      end;
    finally
      AWriter.WriteEndElement;
    end;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteProperties(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNodeSheetFormatPr);
  try
    AWriter.WriteAttributeFloat(sdxXLSXAttrDefaultColumnWidth, Owner.ColumnWidthHelper.PixelsToWidth(View.Columns.DefaultSize));
    AWriter.WriteAttributeBoolean(sdxXLSXAttrCustomHeight, True);
    AWriter.WriteAttributeFloat(sdxXLSXAttrDefaultRowHeight, ConvertRowHeight(View.Rows.DefaultSize));
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteRows(AWriter: TdxXmlWriter; ADimension: TRect);
var
  ACell: TdxDynamicListItem;
  AGroup: TdxSpreadSheetTableItemGroupAccess;
  APrevGroupCollapsed: Boolean;
  ARow: TdxSpreadSheetTableRowAccess;
  ARowIndex: Integer;
begin
  APrevGroupCollapsed := False;
  ExtendDimensionsByGroups(View.Rows.Groups, ADimension.Top, ADimension.Bottom);
  ADimension := ValidateDimensions(ADimension);

  Owner.ProgressHelper.BeginStage(cxRectHeight(ADimension) + 1);
  try
    AWriter.WriteStartElement(sdxXLSXNodeSheetData);
    try
      for ARowIndex := ADimension.Top to ADimension.Bottom do
      begin
        ARow := TdxSpreadSheetTableRowAccess(View.Rows.Items[ARowIndex]);
        AGroup := TdxSpreadSheetTableItemGroupAccess(View.Rows.Groups.Find(ARowIndex));
        if (ARow <> nil) or (AGroup <> nil) then
        begin
          AWriter.WriteStartElement(sdxXLSXNodeRow);
          AWriter.WriteAttributeInteger(sdxXLSXAttrRowIndex, ARowIndex + 1);

          if APrevGroupCollapsed then
            AWriter.WriteAttributeBoolean(sdxXLSXAttrCollapsed, True);
          if AGroup <> nil then
            AWriter.WriteAttributeInteger(sdxXLSXAttrOutlineLevel, AGroup.Level + 1);
          APrevGroupCollapsed := (AGroup <> nil) and AGroup.IsCollapsedByUser;

          if ARow <> nil then
          begin
            if not ARow.Visible then
              AWriter.WriteAttributeBoolean(sdxXLSXAttrHidden, True);

            if not ARow.DefaultSize then
            begin
              if ARow.IsCustomSize then
                AWriter.WriteAttributeBoolean(sdxXLSXAttrCustomHeight, True);
              AWriter.WriteAttributeFloat(sdxXLSXAttrRowHeight, ConvertRowHeight(ARow.CustomSize));
            end;

            if ARow.Style.Handle <> Owner.CellStyleDefault then
            begin
              AWriter.WriteAttributeBoolean(sdxXLSXAttrCustomFormat, True);
              AWriter.WriteAttributeInteger(sdxXLSXAttrStyleIndex, Owner.CellStyles.Add(ARow.Style.Handle));
            end;

            ACell := ARow.FirstCell;
            while ACell <> nil do
            begin
              WriteCell(AWriter, TdxSpreadSheetCell(ACell), ARowIndex, ACell.Index);
              ACell := TdxDynamicListItemAccess(ACell).FNext;
            end;
          end;

          AWriter.WriteEndElement; // sdxXLSXNodeRow
        end;
        Owner.ProgressHelper.NextTask;
      end;
    finally
      AWriter.WriteEndElement;
    end;
  finally
    Owner.ProgressHelper.EndStage;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteSelection(
  AWriter: TdxXmlWriter; ASelection: TdxSpreadSheetTableViewSelection);

  function UniqueSelection: TStringList;
  var
    I: Integer;
  begin
    Result := TStringList.Create;
    Result.Duplicates := dupIgnore;
    Result.Sorted := True;
    for I := 0 to ASelection.Count - 1 do
      Result.Add(dxReferenceToString(ValidateDimensions(ASelection.Items[I].Rect)));
  end;

  function EncodeSelection: string;
  var
    B: TStringBuilder;
    I: Integer;
    S: TStringList;
  begin
    S := UniqueSelection;
    try
      if S.Count = 1 then
        Exit(S[0]);

      B := TdxStringBuilderManager.Get;
      try
        for I := 0 to S.Count - 1 do
        begin
          if I > 0 then
            B.Append(' ');
          B.Append(S[I]);
        end;
        Result := B.ToString;
      finally
        TdxStringBuilderManager.Release(B);
      end;
    finally
      S.Free;
    end;
  end;

var
  AValue: string;
begin
  AWriter.WriteStartElement(sdxXLSXNodeSelection);
  try
    if GetActivePane(AValue) then
      AWriter.WriteAttributeString(sdxXLSXAttrPane, AValue);

    AWriter.WriteAttributeString(sdxXLSXAttrSqRef, EncodeSelection);
    if InRange(ASelection.FocusedRow, 0, dxXLSXMaxRowIndex) and InRange(ASelection.FocusedColumn, 0, dxXLSXMaxColumnIndex) then
      AWriter.WriteAttributeString(sdxXLSXAttrActiveCell, dxReferenceToString(ASelection.FocusedRow, ASelection.FocusedColumn));
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteViewProperties(AWriter: TdxXmlWriter);
var
  AZoomFactor: Integer;
begin
  AWriter.WriteStartElement(sdxXLSXNodeSheetViews);
  AWriter.WriteStartElement(sdxXLSXNodeSheetView);
  AWriter.WriteAttributeInteger(sdxXLSXAttrWorkbookViewId, 0);

  AZoomFactor := Max(Min(View.Options.ZoomFactor, MaxZoomFactor), MinZoomFactor);
  if AZoomFactor <> 100 then
  begin
    AWriter.WriteAttributeInteger(sdxXLSXAttrZoomScale, AZoomFactor);
    AWriter.WriteAttributeInteger(sdxXLSXAttrZoomScaleNormal, AZoomFactor);
  end;

  if View.Active then
    AWriter.WriteAttributeBoolean(sdxXLSXAttrTabSelected, True);

  AWriter.WriteAttributeBoolean(sdxXLSXAttrZeroValues, View.Options.ActualZeroValues);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrShowFormulas, View.Options.ActualShowFormulas);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrGridLines, View.Options.ActualGridLines);
  AWriter.WriteAttributeBoolean(sdxXLSXAttrShowRowColHeaders, View.Options.ActualHeaders);
  if View.Options.ActualRightToLeftLayout then
    AWriter.WriteAttributeBoolean(sdxXLSXAttrRightToLeft, True);

  if (View.FrozenColumn >= 0) or (View.FrozenRow >= 0) then
    WriteFixedPaneProperties(AWriter);

  if View.Selection.Count > 0 then
    WriteSelection(AWriter, View.Selection);

  AWriter.WriteEndElement; // sdxXLSXNodeSheetView
  AWriter.WriteEndElement; // sdxXLSXNodeSheetsView
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.WriteViewProtection(AWriter: TdxXmlWriter);
var
  AProtection: TdxSpreadSheetStrongProtectionInfo;
begin
  AWriter.WriteStartElement(sdxXLSXNodeSheetProtection);
  try
    AWriter.WriteAttributeBoolean(sdxXLSXAttrSheet, View.OptionsProtection.Protected);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrDeleteColumns, not View.OptionsProtection.AllowDeleteColumns);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrDeleteRows, not View.OptionsProtection.AllowDeleteRows);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrFormatCells, not View.OptionsProtection.AllowFormatCells);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrFormatColumns, not View.OptionsProtection.AllowResizeColumns);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrFormatRows, not View.OptionsProtection.AllowResizeRows);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrInsertColumns, not View.OptionsProtection.AllowInsertColumns);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrInsertRows, not View.OptionsProtection.AllowInsertRows);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrInsertHyperlinks, not View.OptionsProtection.AllowEditHyperlinks);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrObjects, not View.OptionsProtection.AllowEditContainers);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrSelectLockedCells, not View.OptionsProtection.AllowSelectLockedCells);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrSelectUnlockedCell, not View.OptionsProtection.AllowSelectUnlockedCells);
    AWriter.WriteAttributeBoolean(sdxXLSXAttrSort, not View.OptionsProtection.AllowSort);

    if View.OptionsProtection.ProtectionInfo is TdxSpreadSheetStandardProtectionInfo then
      AWriter.WriteAttributeString(sdxXLSXAttrPassword, TdxSpreadSheetStandardProtectionInfo(View.OptionsProtection.ProtectionInfo).KeyWordAsString)
    else

    if View.OptionsProtection.ProtectionInfo is TdxSpreadSheetStrongProtectionInfo then
    begin
      AProtection := TdxSpreadSheetStrongProtectionInfo(View.OptionsProtection.ProtectionInfo);
      AWriter.WriteAttributeString(sdxXLSXAttrAlgorithmName, dxXLSXHashAlgorithmTypeNames[AProtection.HashAlgorithm]);
      AWriter.WriteAttributeString(sdxXLSXAttrHashValue, AProtection.HashValueAsString);
      AWriter.WriteAttributeString(sdxXLSXAttrSaltValue, AProtection.SaltValueAsString);
      AWriter.WriteAttributeInteger(sdxXLSXAttrSpinCount, AProtection.SpinCount);
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewBuilder.ExtendDimensionsByGroups(
  AGroups: TdxSpreadSheetTableItemGroups; var AStartIndex, AFinishIndex: Integer);
begin
  if AGroups.Count > 0 then
  begin
    AFinishIndex := Max(AFinishIndex, AGroups[AGroups.Count - 1].FinishIndex);
    AStartIndex := Min(AStartIndex, AGroups[0].StartIndex);
  end;
end;

{ TdxSpreadSheetXLTXWriter }

function TdxSpreadSheetXLTXWriter.GetContentTypeID: string;
begin
  Result := sdxXLSXWorkbookTemplateContentType;
end;

end.
