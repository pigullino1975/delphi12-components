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

unit dxSpreadSheetFormatXLSXReader;

{$I cxVer.Inc}
{$R dxSpreadSheetFormatXLSXReader.res}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, dxCore, dxCoreClasses, cxClasses, dxCustomTree, dxXMLDoc, dxZIPUtils,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxSpreadSheetStrs, dxSpreadSheetPackedFileFormatCore,
  dxSpreadSheetUtils, dxGDIPlusClasses, Generics.Defaults, Generics.Collections, dxCoreGraphics, cxGeometry, Contnrs,
  dxSpreadSheetPrinting, dxSpreadSheetConditionalFormattingRules, dxSpreadSheetContainers, dxSpreadSheetProtection,
  dxHashUtils, Variants, dxSpreadSheetCoreStyles, dxSpreadSheetFormatUtils, dxXMLReader, dxGenerics, dxXMLReaderUtils,
  dxSpreadSheetHyperlinks, dxSpreadSheetFormatXLSXUtils;

type
  TdxSpreadSheetXLSXReader = class;

  TdxXLSXCustomDocumentReader = class;
  TdxXLSXFormulaAsTextInfoList = class;

  { TdxXLSXNodeHandler }

  TdxXLSXNodeHandlerClass = class of TdxXLSXNodeHandler;
  TdxXLSXNodeHandler = class(TdxXMLNodeHandler)
  strict private
    function GetOwner: TdxXLSXCustomDocumentReader; inline;
  protected
    procedure DoError(const AMessage: string; AType: TdxSpreadSheetMessageType); overload;
    procedure DoError(const AFormatString: string; const AArguments: array of const; AType: TdxSpreadSheetMessageType); overload;
  public
    property Owner: TdxXLSXCustomDocumentReader read GetOwner;
  end;

 { TdxXLSXFormulaAsTextInfo }

  TdxXLSXFormulaAsTextInfo = class(TdxSpreadSheetFormulaAsTextInfo)
  strict private
    FOwner: TdxXLSXFormulaAsTextInfoList;
  protected
    SharedIndex: Integer;

    procedure ResolveReferences(Parser: TObject); override;
  public
    constructor Create(AOwner: TdxXLSXFormulaAsTextInfoList);
  end;

  { TdxXLSXFormulaAsTextInfoList }

  TdxXLSXFormulaAsTextInfoList = class(TdxSpreadSheetFormulaAsTextInfoList)
  strict private
    FSharedFormulas: TDictionary<Int64, TdxSpreadSheetFormulaAsTextInfo>;
  protected
    function CreateItem: TdxSpreadSheetFormulaAsTextInfo; override;
    function GetSharedFormula(AView: TdxSpreadSheetCustomView; AIndex: Integer): TdxSpreadSheetFormulaAsTextInfo;
  public
    constructor Create(ASpreadSheet: TdxCustomSpreadSheet); override;
    destructor Destroy; override;
    procedure Add(ACell: TdxSpreadSheetCell; const AFormula: string;
      AIsArray: Boolean; ASharedIndex: Integer; const AReference: TRect); reintroduce;
    procedure ResolveReferences; override;
  end;

  { TdxXLSXCustomDocumentReader }

  TdxXLSXCustomDocumentReader = class(TdxSpreadSheetCustomFilerSubTask)
  strict private
    FDocumentHandler: TdxXMLDocumentHandler;
    FFileName: string;
    FHandlers: TdxXMLNodeHandlers;
    FProgressHelper: TcxCustomProgressCalculationHelper;
    FRels: TdxXLSXRelationships;

    function GetOwner: TdxSpreadSheetXLSXReader; inline;
  protected
    function CheckListIndex(AIndex: Integer; AList: TList;
      const AMessage: string; AMessageType: TdxSpreadSheetMessageType): Boolean; overload;
    function CheckListIndex(AIndex: Integer; AList: TdxHashTableItemList;
      const AMessage: string; AMessageType: TdxSpreadSheetMessageType): Boolean; overload;
    function GetFileRelationships: TdxXLSXRelationships; virtual;
    function GetFileStream(const AFileName: string): TStream; virtual;
    //
    property DocumentHandler: TdxXMLDocumentHandler read FDocumentHandler;
    property Handlers: TdxXMLNodeHandlers read FHandlers;
    property ProgressHelper: TcxCustomProgressCalculationHelper read FProgressHelper;
  public
    constructor Create(const AFileName: string; AOwner: TdxSpreadSheetXLSXReader;
      AProgressHelper: TcxCustomProgressCalculationHelper = nil); virtual;
    destructor Destroy; override;
    procedure Execute; override;
    //
    property FileName: string read FFileName;
    property Owner: TdxSpreadSheetXLSXReader read GetOwner;
    property Rels: TdxXLSXRelationships read FRels;
  end;

  { TdxXLSXReaderThemeData }

  TdxXLSXReaderThemeData = class
  strict private
    FBrushes: TObjectList;
    FColorMap: TDictionary<string, TColor>;
    FColors: TList;
    FPens: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    function AddBrush: TdxGPBrush;
    procedure AddColor(const AValue: TColor); inline;
    function AddPen: TdxGPPen;
    procedure Clear;
    function TryGetBrush(Index: Integer; out ABrush: TdxGPBrush): Boolean;
    function TryGetPen(Index: Integer; out APen: TdxGPPen): Boolean;

    property ColorMap: TDictionary<string, TColor> read FColorMap;
    property Colors: TList read FColors;
  end;

  { TdxXLSXColorHandler }

  TdxXLSXColorHandler = class(TdxXLSXNodeHandler)
  strict private
    FColor: PColor;

    function ExtractIndexedColor(AReader: TdxXmlReader; AColorIndex: Integer): TColor;
    function ExtractThemedColor(AReader: TdxXmlReader; AThemeIndex: Integer): TColor;
  public
    constructor Create(AOwner: TdxXLSXCustomDocumentReader; AColor: PColor); reintroduce;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXFontHandler }

  TdxXLSXFontHandler = class(TdxXLSXNodeHandler)
  strict private
    procedure ProcessStyle(const AReader: TdxXmlReader; AStyle: TFontStyle);
    function ProcessStyleBold(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessStyleItalic(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessStyleStrikeOut(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessStyleUnderline(const AReader: TdxXmlReader): TdxXMLNodeHandler;

    function ProcessCharset(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessName(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessSize(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessVerticalAlignment(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    FHandle: TdxSpreadSheetFontHandle;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXFormattedTextHandler }

  TdxXLSXFormattedTextHandler = class(TdxXLSXNodeHandler)
  strict private
    procedure ProcessText(const S: string);
    function ProcessTextRun(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    FRuns: TdxSpreadSheetFormattedSharedStringRuns;
    FText: TStringBuilder;
  public
    constructor Create(AOwner: TObject; const ANamespace: AnsiString;
      ARuns: TdxSpreadSheetFormattedSharedStringRuns; AText: TStringBuilder); reintroduce; overload;
  end;

  { TdxXLSXFormattedTextFontHandler }

  TdxXLSXFormattedTextFontHandler = class(TdxXLSXFontHandler)
  protected
    FOwner: TdxXLSXFormattedTextHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXHyperlinkHandler }

  TdxXLSXHyperlinkHandler = class(TdxXLSXNodeHandler)
  strict private
    FHyperlink: TdxSpreadSheetHyperlink;
  protected
    function ReadValue(AReader: TdxXmlReader): string; virtual;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXWorksheetReader }

  TdxXLSXWorksheetReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FConditionalFormattingHandler: TdxXLSXNodeHandler;
    FView: TdxSpreadSheetTableView;

    function ProcessConditionalFormatting(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessLegacyDrawing(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessSheetFormat(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    procedure ReadDrawings;
  public
    constructor Create(const AFileName: string; AView: TdxSpreadSheetTableView; AOwner: TdxSpreadSheetXLSXReader); reintroduce;
    procedure Execute; override;
    //
    property View: TdxSpreadSheetTableView read FView;
  end;

  { TdxSpreadSheetXLSXReader }

  TdxSpreadSheetXLSXReader = class(TdxSpreadSheetCustomPackedReader)
  strict private
    FBorders: TdxHashTableItemList;
    FColumnWidthHelper: TdxSpreadSheetExcelColumnWidthHelper;
    FConditionalFormattingStyles: TdxHashTableItemList;
    FContentTypeIndex: TdxStringsDictionary;
    FFills: TdxHashTableItemList;
    FFonts: TdxHashTableItemList;
    FFormats: TdxHashTableItemList;
    FFormulas: TdxXLSXFormulaAsTextInfoList;
    FHyperlinks: TStringList;
    FIndexedColors: TdxColorList;
    FSharedStrings: TdxHashTableItemList;
    FStyles: TdxHashTableItemList;
    FThemeData: TdxXLSXReaderThemeData;

    function GetColumnWidthHelper: TdxSpreadSheetExcelColumnWidthHelper;
    function GetContentType(const AFileName: string): string;
  protected
    FEmbeddedImageIndex: TdxXLSXStringToObjectMap;

    function CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper; override;
    procedure ParseMetadata(const AFileName: string);
    procedure ParseWorkbook(const AFileName: string);
    procedure ResolveHyperlinks;
    procedure ResolveReferences;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    destructor Destroy; override;
    function FindWorkbookFileName(ARels: TdxXLSXRelationships; out AFileName: string): Boolean;
    function GetFileRelationships(const AOwnerFileName: string): TdxXLSXRelationships;
    procedure ReadData; override;

    property Borders: TdxHashTableItemList read FBorders;
    property ColumnWidthHelper: TdxSpreadSheetExcelColumnWidthHelper read GetColumnWidthHelper;
    property ConditionalFormattingStyles: TdxHashTableItemList read FConditionalFormattingStyles;
    property ContentType[const AFileName: string]: string read GetContentType;
    property Fills: TdxHashTableItemList read FFills;
    property Fonts: TdxHashTableItemList read FFonts;
    property Formats: TdxHashTableItemList read FFormats;
    property Formulas: TdxXLSXFormulaAsTextInfoList read FFormulas;
    property Hyperlinks: TStringList read FHyperlinks;
    property IndexedColors: TdxColorList read FIndexedColors;
    property SharedStrings: TdxHashTableItemList read FSharedStrings;
    property Styles: TdxHashTableItemList read FStyles;
    property ThemeData: TdxXLSXReaderThemeData read FThemeData;
  end;

implementation

uses
  AnsiStrings, Math, cxGraphics, dxXMLClasses,
  dxSpreadSheetGraphics, dxSpreadSheetFormulas, dxSpreadSheetCoreFormulasParser, dxSpreadSheetConditionalFormattingIconSet,
  dxOLECryptoContainer, dxSpreadSheetCoreStrs, dxSpreadSheetCoreReferences,
  // XLSX
  dxSpreadSheetFormatXLSX, dxSpreadSheetFormatXLSXTags, dxSpreadSheetFormatXLSXReaderDrawing,
  dxSpreadSheetFormatXLSXReaderConditionalFormatting, dxSpreadSheetFormatXLSXReaderComments,
  dxSpreadSheetFormatXLSXReaderStyles;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXReader';

type
  TdxXLSXWorkbookReader = class;
  TdxSpreadSheetAccess = class(TdxCustomSpreadSheet);
  TdxSpreadSheetTableColumnAccess = class(TdxSpreadSheetTableColumn);
  TdxSpreadSheetTableItemGroupAccess = class(TdxSpreadSheetTableItemGroup);
  TdxSpreadSheetTableRowAccess = class(TdxSpreadSheetTableRow);
  TdxSpreadSheetTableViewAccess = class(TdxSpreadSheetTableView);

  { TdxXLSXWorkbookView }

  TdxXLSXWorkbookView = class
  public
    ActiveSheetIndex: Integer;
    ShowHorizontalScrollBar: Boolean;
    ShowTabs: Boolean;
    ShowVerticalScrollBar: Boolean;

    constructor Create;
  end;

  { TdxXLSXExternalLinkHandler }

  TdxXLSXExternalLinkHandler = class(TdxXLSXNodeHandler)
  strict private
    FLinks: TdxSpreadSheetExternalLinks;
    FRels: TdxXLSXRelationships;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXExternalLinkReader }

  TdxXLSXExternalLinkReader = class(TdxXLSXCustomDocumentReader)
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXWorkbookDefinedNameHandler }

  TdxXLSXWorkbookDefinedNameHandler = class(TdxXLSXNodeHandler)
  strict private
    FComment: string;
    FReference: string;
    FName: string;
    FSheetId: string;

    function GetOwner: TdxXLSXWorkbookReader;
  public
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    procedure OnText(const AReader: TdxXmlReader); override;
    //
    property Owner: TdxXLSXWorkbookReader read GetOwner;
  end;

  { TdxXLSXWorkbookDefinedNameCollectionHandler }

  TdxXLSXWorkbookDefinedNameCollectionHandler = class(TdxXLSXNodeHandler)
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXWorkbookExternalLinkCollectionHandler }

  TdxXLSXWorkbookExternalLinkCollectionHandler = class(TdxXLSXNodeHandler)
  strict private
    function CreateExternalLinkHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXWorkbookSheetCollectionHandler }

  TdxXLSXWorkbookSheetCollectionHandler = class(TdxXLSXNodeHandler)
  strict private
    function CreateSheetHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function GetOwner: TdxXLSXWorkbookReader;
  public
    constructor Create(AOwner, AData: TObject); override;
    //
    property Owner: TdxXLSXWorkbookReader read GetOwner;
  end;

  { TdxXLSXWorkbookViewHandler }

  TdxXLSXWorkbookViewHandler = class(TdxXLSXNodeHandler)
  strict private
    FView: TdxXLSXWorkbookView;

    function ProcessWorkbookView(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXSharedStringHandler }

  TdxXLSXSharedStringHandler = class(TdxXLSXFormattedTextHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
  end;

  { TdxXLSXSharedStringReader }

  TdxXLSXSharedStringReader = class(TdxXLSXCustomDocumentReader)
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXWorkbookReader }

  TdxXLSXWorkbookReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FLocalSheetIdMap: TdxXLSXStringToObjectMap;
    FView: TdxXLSXWorkbookView;

    function ProcessCalculationProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessDateTimeSystem(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessProtection(const AReader: TdxXmlReader): TdxXMLNodeHandler;

    procedure ApplyView;
    procedure ReadStrings;
    procedure ReadStyles;
    procedure ReadThemes;
  protected
    property LocalSheetIdMap: TdxXLSXStringToObjectMap read FLocalSheetIdMap;
  public
    constructor Create(const AFileName: string; AOwner: TdxSpreadSheetXLSXReader;
      AProgressHelper: TcxCustomProgressCalculationHelper = nil); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure Execute; override;
  end;

  { TdxXLSXMetadataReader }

  TdxXLSXMetadataReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FMetadata: TdxSpreadSheetOptionsMetadata;

    procedure DoReadCreated(const AText: string);
    procedure DoReadCreatedBy(const AText: string);
    procedure DoReadDescription(const AText: string);
    procedure DoReadKeywords(const AText: string);
    procedure DoReadLastModified(const AText: string);
    procedure DoReadLastModifiedBy(const AText: string);
    procedure DoReadLastPrinted(const AText: string);
    procedure DoReadSubject(const AText: string);
    procedure DoReadTitle(const AText: string);
    function ToDateTime(const S: string): TDateTime;
  public
    constructor Create(const AFileName: string; AOwner: TdxSpreadSheetXLSXReader;
      AProgressHelper: TcxCustomProgressCalculationHelper = nil); override;
    procedure AfterConstruction; override;
    //
    property Metadata: TdxSpreadSheetOptionsMetadata read FMetadata;
  end;

  { TdxXLSXWorksheetCustomHandler }

  TdxXLSXWorksheetCustomHandler = class(TdxXLSXNodeHandler)
  strict private
    FStyles: TdxHashTableItemList;
    FView: TdxSpreadSheetTableView;
  public
    constructor Create(AOwner, AData: TObject); override;
    property Styles: TdxHashTableItemList read FStyles;
    property View: TdxSpreadSheetTableView read FView;
  end;

  { TdxXLSXWorksheetMergedCellsHandler }

  TdxXLSXWorksheetMergedCellsHandler = class(TdxXLSXWorksheetCustomHandler)
  strict private
    function ProcessMergedCell(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXWorksheetViewHandler }

  TdxXLSXWorksheetViewHandler = class(TdxXLSXWorksheetCustomHandler)
  strict private
    FActivePane: string;
    FTopLeftCellReference: string;

    function ProcessPane(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessSelection(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    procedure AfterConstruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXWorksheetViewsHandler }

  TdxXLSXWorksheetViewsHandler = class(TdxXLSXNodeHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXWorksheetPrintingHeaderFooterHandler }

  TdxXLSXWorksheetPrintingHeaderFooterHandler = class(TdxXLSXNodeHandler)
  strict private
    FHeaderFooter: TdxSpreadSheetTableViewOptionsPrintHeaderFooter;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property HeaderFooter: TdxSpreadSheetTableViewOptionsPrintHeaderFooter read FHeaderFooter;
  end;

  { TdxXLSXWorksheetPrintingHeaderFooterTextHandler }

  TdxXLSXWorksheetPrintingHeaderFooterTextHandler = class(TdxXLSXNodeHandler)
  strict private
    FText: TdxSpreadSheetTableViewOptionsPrintHeaderFooterText;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnText(const AReader: TdxXmlReader); override;
    //
    property Text: TdxSpreadSheetTableViewOptionsPrintHeaderFooterText read FText;
  end;

  { TdxXLSXWorksheetPrintingPageBreaksHandler }

  TdxXLSXWorksheetPrintingPageBreaksHandler = class(TdxXLSXNodeHandler)
  strict private
    FBreaks: TList<Cardinal>;
  public
    constructor Create(AOwner, AData: TObject); override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
  end;

  { TdxXLSXWorksheetPrintingPageMarginsHandler }

  TdxXLSXWorksheetPrintingPageMarginsHandler = class(TdxXLSXNodeHandler)
  strict private
    FMargins: TdxSpreadSheetTableViewOptionsPrintPageMargins;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property Margins: TdxSpreadSheetTableViewOptionsPrintPageMargins read FMargins;
  end;

  { TdxXLSXWorksheetPrintingPageSetupHandler }

  TdxXLSXWorksheetPrintingPageSetupHandler = class(TdxXLSXNodeHandler)
  strict private
    FOptions: TdxSpreadSheetTableViewOptionsPrint;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property Options: TdxSpreadSheetTableViewOptionsPrint read FOptions;
  end;

  { TdxXLSXWorksheetPrintingOptionsHandler }

  TdxXLSXWorksheetPrintingOptionsHandler = class(TdxXLSXNodeHandler)
  strict private
    FOptions: TdxSpreadSheetTableViewOptionsPrint;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property Options: TdxSpreadSheetTableViewOptionsPrint read FOptions;
  end;

  { TdxXLSXWorksheetPropertiesHandler }

  TdxXLSXWorksheetPropertiesHandler = class(TdxXLSXWorksheetCustomHandler)
  strict private
    function ProcessOutlineProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessPrintingScaleMode(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    procedure AfterConstruction; override;
  end;

  { TdxXLSXWorksheetProtectionHandler }

  TdxXLSXWorksheetProtectionHandler = class(TdxXLSXWorksheetCustomHandler)
  strict private
    function ReadProtectionInfoStandard(AReader: TdxXmlReader): IdxSpreadSheetProtectionInfo;
    function ReadProtectionInfoStrong(AReader: TdxXmlReader): IdxSpreadSheetProtectionInfo;
  public
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXWorksheetHyperlinksHandler }

  TdxXLSXWorksheetHyperlinksHandler = class(TdxXLSXWorksheetCustomHandler)
  strict private
    function ProcessHyperlink(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXWorksheetCellHandler }

  TdxXLSXWorksheetCellHandler = class(TdxXLSXWorksheetCustomHandler)
  strict private
    FCell: TdxSpreadSheetCell;
    FFormulaHandler: TdxXLSXNodeHandler;
    FSharedStrings: TdxHashTableItemList;
    FValueHandler: TdxXLSXNodeHandler;
    FValueType: TdxSpreadSheetXLSXCellType;

    function ProcessFunction(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessInlineString(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessValue(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    procedure OnCellValue(const AText: string);
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    procedure OnBegin(ACell: TdxSpreadSheetCell);
    //
    property Cell: TdxSpreadSheetCell read FCell;
    property SharedStrings: TdxHashTableItemList read FSharedStrings;
    property ValueType: TdxSpreadSheetXLSXCellType read FValueType write FValueType;
  end;

  { TdxXLSXWorksheetCellFormattedTextHandler }

  TdxXLSXWorksheetCellFormattedTextHandler = class(TdxXLSXFormattedTextHandler)
  strict private
    FOwner: TdxXLSXWorksheetCellHandler;
  public
    constructor Create(AOwner: TdxXLSXWorksheetCellHandler); reintroduce;
    destructor Destroy; override;
    procedure OnEnd; override;
  end;

  { TdxXLSXWorksheetCellFormulaHandler }

  TdxXLSXWorksheetCellFormulaHandler = class(TdxXLSXNodeHandler)
  strict private
    FExpression: string;
    FOwner: TdxXLSXWorksheetCellHandler;
    FReference: string;
    FSharedIndex: Integer;
    FType: string;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    procedure OnEnd; override;
    procedure OnText(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXWorksheetCellValueHandler }

  TdxXLSXWorksheetCellValueHandler = class(TdxXLSXNodeHandler)
  strict private
    FOwner: TdxXLSXWorksheetCellHandler;
    FValuePresented: Boolean;

    function ProcessInlineString(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    procedure OnEnd; override;
    procedure OnText(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXWorksheetColumnsHandler }

  TdxXLSXWorksheetColumnsHandler = class(TdxXLSXWorksheetCustomHandler)
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
  end;

  { TdxXLSXWorksheetRowHandler }

  TdxXLSXWorksheetRowHandler = class(TdxXLSXWorksheetCustomHandler)
  strict private
    FCellHandler: TdxXLSXWorksheetCellHandler;
  protected
    FRow: TdxSpreadSheetTableRow;

    function ExtractColumnIndex(const S: string): Integer;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property Row: TdxSpreadSheetTableRow read FRow;
  end;

  { TdxXLSXWorksheetRowsHandler }

  TdxXLSXWorksheetRowsHandler = class(TdxXLSXWorksheetCustomHandler)
  strict private
    FRowHandler: TdxXLSXWorksheetRowHandler;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler; override;
  end;

  { TdxXLSXContentTypeIndexReader }

  TdxXLSXContentTypeIndexReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FIndex: TdxStringsDictionary;

    function ProcessOverrideType(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner: TdxSpreadSheetXLSXReader; AIndex: TdxStringsDictionary); reintroduce;
  end;

  { TdxXLSXRelationshipsReader }

  TdxXLSXRelationshipsReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FTarget: TdxXLSXRelationships;
    FRootPath: string;

    function ProcessRelationship(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    function GetFileRelationships: TdxXLSXRelationships; override;
  public
    constructor Create(const ARootPath, AFileName: string; ATarget: TdxXLSXRelationships; AOwner: TdxSpreadSheetXLSXReader); reintroduce;
  end;

{ TdxXLSXNodeHandler }


procedure TdxXLSXNodeHandler.DoError(const AMessage: string; AType: TdxSpreadSheetMessageType);
begin
  if FOwner <> nil then
    Owner.DoError(AMessage, AType);
end;

procedure TdxXLSXNodeHandler.DoError(const AFormatString: string; const AArguments: array of const; AType: TdxSpreadSheetMessageType);
begin
  DoError(Format(AFormatString, AArguments), AType);
end;

function TdxXLSXNodeHandler.GetOwner: TdxXLSXCustomDocumentReader;
begin
  Result := TdxXLSXCustomDocumentReader(FOwner);
end;

{ TdxXLSXFormulaAsTextInfo }

constructor TdxXLSXFormulaAsTextInfo.Create(AOwner: TdxXLSXFormulaAsTextInfoList);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TdxXLSXFormulaAsTextInfo.ResolveReferences(Parser: TObject);
begin
  if IsShared then
    Cell.AsFormula := FOwner.GetSharedFormula(Cell.View, SharedIndex).Cell.AsFormula.Clone
  else
    inherited ResolveReferences(Parser);
end;

{ TdxXLSXFormulaAsTextInfoList }

constructor TdxXLSXFormulaAsTextInfoList.Create(ASpreadSheet: TdxCustomSpreadSheet);
begin
  inherited;
  FSharedFormulas := TDictionary<Int64, TdxSpreadSheetFormulaAsTextInfo>.Create;
end;

destructor TdxXLSXFormulaAsTextInfoList.Destroy;
begin
  FreeAndNil(FSharedFormulas);
  inherited;
end;

procedure TdxXLSXFormulaAsTextInfoList.Add(ACell: TdxSpreadSheetCell;
  const AFormula: string; AIsArray: Boolean; ASharedIndex: Integer; const AReference: TRect);
var
  AInfo: TdxXLSXFormulaAsTextInfo;
begin
  if AFormula <> '' then
  begin
    AInfo := TdxXLSXFormulaAsTextInfo(inherited Add(ACell, dxSpreadSheetFormulaIncludeEqualSymbol(AFormula), AIsArray, False, AReference));
    if ASharedIndex >= 0 then
    begin
      AInfo.SharedIndex := ASharedIndex;
      FSharedFormulas.AddOrSetValue(dxMakeInt64(ACell.View.Index, AInfo.SharedIndex), AInfo);
    end;
  end
  else
    if ASharedIndex >= 0 then
    begin
      AInfo := TdxXLSXFormulaAsTextInfo(inherited Add(ACell, '', False, True, cxInvalidRect));
      AInfo.SharedIndex := ASharedIndex;
    end;
end;

procedure TdxXLSXFormulaAsTextInfoList.ResolveReferences;

  procedure ResolveReferencesCore(AParser: TObject; ASharedFormulas: Boolean);
  var
    AInfo: TdxXLSXFormulaAsTextInfo;
    I: Integer;
  begin
    for I := 0 to Count - 1 do
    begin
      AInfo := TdxXLSXFormulaAsTextInfo(Items[I]);
      if (AInfo.Cell <> nil) and (AInfo.IsShared = ASharedFormulas) then
        AInfo.ResolveReferences(AParser);
    end;
  end;

var
  AParser: TObject;
begin
  AParser := CreateParser;
  try
    ResolveReferencesCore(AParser, False);
    ResolveReferencesCore(AParser, True);
  finally
    AParser.Free;
  end;
end;

function TdxXLSXFormulaAsTextInfoList.CreateItem: TdxSpreadSheetFormulaAsTextInfo;
begin
  Result := TdxXLSXFormulaAsTextInfo.Create(Self);
end;

function TdxXLSXFormulaAsTextInfoList.GetSharedFormula(
  AView: TdxSpreadSheetCustomView; AIndex: Integer): TdxSpreadSheetFormulaAsTextInfo;
begin
  Result := FSharedFormulas.Items[dxMakeInt64(AView.Index, AIndex)];
end;

{ TdxXLSXCustomDocumentReader }

constructor TdxXLSXCustomDocumentReader.Create(const AFileName: string;
  AOwner: TdxSpreadSheetXLSXReader; AProgressHelper: TcxCustomProgressCalculationHelper = nil);
begin
  inherited Create(AOwner);
  FFileName := AFileName;
  FProgressHelper := AProgressHelper;
  FDocumentHandler := TdxXMLDocumentHandler.Create(GetFileStream(FileName), soOwned, Self, ProgressHelper);
  FDocumentHandler.SkipRootNode := True;
  FHandlers := FDocumentHandler.Handlers;
  FRels := GetFileRelationships;
end;

destructor TdxXLSXCustomDocumentReader.Destroy;
begin
  FreeAndNil(FDocumentHandler);
  FreeAndNil(FRels);
  inherited Destroy;
end;

procedure TdxXLSXCustomDocumentReader.Execute;
begin
  FDocumentHandler.Run;
end;

function TdxXLSXCustomDocumentReader.GetFileRelationships: TdxXLSXRelationships;
begin
  Result := Owner.GetFileRelationships(FileName);
end;

function TdxXLSXCustomDocumentReader.GetFileStream(const AFileName: string): TStream;
begin
  Result := Owner.ReadFile(AFileName);
end;

function TdxXLSXCustomDocumentReader.CheckListIndex(AIndex: Integer;
  AList: TList; const AMessage: string; AMessageType: TdxSpreadSheetMessageType): Boolean;
begin
  Result := (AIndex >= 0) and (AIndex < AList.Count);
  if not Result then
    DoError(AMessage, [AIndex], AMessageType);
end;

function TdxXLSXCustomDocumentReader.CheckListIndex(AIndex: Integer;
  AList: TdxHashTableItemList; const AMessage: string; AMessageType: TdxSpreadSheetMessageType): Boolean;
begin
  Result := (AIndex >= 0) and (AIndex < AList.Count);
  if not Result then
    DoError(AMessage, [AIndex], AMessageType);
end;

function TdxXLSXCustomDocumentReader.GetOwner: TdxSpreadSheetXLSXReader;
begin
  Result := TdxSpreadSheetXLSXReader(inherited Owner);
end;

{ TdxXLSXReaderThemeData }

constructor TdxXLSXReaderThemeData.Create;
begin
  FColors := TList.Create;
  FBrushes := TObjectList.Create;
  FColorMap := TDictionary<string, TColor>.Create;
  FPens := TObjectList.Create;
end;

destructor TdxXLSXReaderThemeData.Destroy;
begin
  FreeAndNil(FColorMap);
  FreeAndNil(FBrushes);
  FreeAndNil(FPens);
  FreeAndNil(FColors);
  inherited;
end;

function TdxXLSXReaderThemeData.AddBrush: TdxGPBrush;
begin
  Result := TdxGPBrush.Create;
  FBrushes.Add(Result);
end;

procedure TdxXLSXReaderThemeData.AddColor(const AValue: TColor);
begin
  FColors.Add(Pointer(AValue));
end;

function TdxXLSXReaderThemeData.AddPen: TdxGPPen;
begin
  Result := TdxGPPen.Create;
  FPens.Add(Result);
end;

procedure TdxXLSXReaderThemeData.Clear;
begin
  FColorMap.Clear;
  FBrushes.Clear;
  FColors.Clear;
  FPens.Clear;
end;

function TdxXLSXReaderThemeData.TryGetBrush(Index: Integer; out ABrush: TdxGPBrush): Boolean;
begin
  Result := (Index >= 0) and (Index < FBrushes.Count);
  if Result then
    ABrush := FBrushes.List[Index];
end;

function TdxXLSXReaderThemeData.TryGetPen(Index: Integer; out APen: TdxGPPen): Boolean;
begin
  Result := (Index >= 0) and (Index < FPens.Count);
  if Result then
    APen := FPens.List[Index];
end;

{ TdxSpreadSheetXLSXReader }

constructor TdxSpreadSheetXLSXReader.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  inherited Create(AOwner, AStream);
  FIndexedColors := TdxColorList.Create;
  FEmbeddedImageIndex := TdxXLSXStringToObjectMap.Create;
  FFormulas := TdxXLSXFormulaAsTextInfoList.Create(SpreadSheet);
  FHyperlinks := TStringList.Create;
  FConditionalFormattingStyles := TdxHashTableItemList.Create;
  FSharedStrings := TdxHashTableItemList.Create;
  FThemeData := TdxXLSXReaderThemeData.Create;
  FStyles := TdxHashTableItemList.Create;
  FFormats := TdxHashTableItemList.Create;
  FBorders := TdxHashTableItemList.Create;
  FFills := TdxHashTableItemList.Create;
  FFonts := TdxHashTableItemList.Create;
end;

destructor TdxSpreadSheetXLSXReader.Destroy;
begin
  FreeAndNil(FThemeData);
  FreeAndNil(FIndexedColors);
  FreeAndNil(FContentTypeIndex);
  FreeAndNil(FConditionalFormattingStyles);
  FreeAndNil(FEmbeddedImageIndex);
  FreeAndNil(FColumnWidthHelper);
  FreeAndNil(FFormats);
  FreeAndNil(FBorders);
  FreeAndNil(FStyles);
  FreeAndNil(FFills);
  FreeAndNil(FFonts);
  FreeAndNil(FSharedStrings);
  FreeAndNil(FFormulas);
  FreeAndNil(FHyperlinks);
  inherited Destroy;
end;

function TdxSpreadSheetXLSXReader.FindWorkbookFileName(ARels: TdxXLSXRelationships; out AFileName: string): Boolean;
const
  WorkbookSheetType = 'spreadsheetml.sheet.main';
  WorkbookTemplateType = 'spreadsheetml.template.main';
  WorkbookMacroEnabledType = 'sheet.macroenabled.main';
var
  AContentType: string;
  AItem: TdxXLSXRelationship;
begin
  Result := ARels.FindByType(sdxXLSXWorkbookRelationship, AItem);
  if Result then
  begin
    AContentType := LowerCase(ContentType[dxUnixPathDelim + AItem.Target]);
    Result := (AContentType = '') or
      (Pos(WorkbookSheetType, AContentType) > 0) or
      (Pos(WorkbookTemplateType, AContentType) > 0) or
      (Pos(WorkbookMacroEnabledType, AContentType) > 0);
    if Result then
      AFileName := AItem.Target;
  end;
end;

function TdxSpreadSheetXLSXReader.GetFileRelationships(const AOwnerFileName: string): TdxXLSXRelationships;
var
  ARelsFileName: string;
begin
  Result := TdxXLSXRelationships.Create;

  ARelsFileName := TdxXLSXUtils.GetRelsFileNameForFile(AOwnerFileName);
  if Self.FileExists(ARelsFileName) then
    ExecuteSubTask(TdxXLSXRelationshipsReader.Create(TdxZIPPathHelper.ExtractFilePath(AOwnerFileName), ARelsFileName, Result, Self));
end;

procedure TdxSpreadSheetXLSXReader.ReadData;
var
  AFileName: string;
  AItem: TdxXLSXRelationship;
  ARels: TdxXLSXRelationships;
begin
  ARels := GetFileRelationships('');
  try
    if FindWorkbookFileName(ARels, AFileName) then
    begin
      ParseWorkbook(AFileName);
      try
        ResolveHyperlinks;
        ResolveReferences;
      except
        on E: Exception do
          DoError(E.Message, ssmtError);
      end;
      if ARels.FindByType(sdxXLSXCorePropertiesRelationship, AItem) then
        ParseMetadata(AItem.Target);
    end
    else
      DoError(sdxErrorInvalidDocumentType, ssmtError);
  finally
    ARels.Free;
  end;
end;

function TdxSpreadSheetXLSXReader.CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper;
begin
  Result := TdxSpreadSheetCustomFilerProgressHelper.Create(Self, 4);
end;

procedure TdxSpreadSheetXLSXReader.ParseMetadata(const AFileName: string);
begin
  ExecuteSubTask(TdxXLSXMetadataReader.Create(AFileName, Self));
end;

procedure TdxSpreadSheetXLSXReader.ParseWorkbook(const AFileName: string);
begin
  ExecuteSubTask(TdxXLSXWorkbookReader.Create(AFileName, Self, ProgressHelper));
end;

procedure TdxSpreadSheetXLSXReader.ResolveHyperlinks;
var
  I: Integer;
begin
  for I := 0 to Hyperlinks.Count - 1 do
    TdxSpreadSheetHyperlink(Hyperlinks.Objects[I]).Value := Hyperlinks[I];
end;

procedure TdxSpreadSheetXLSXReader.ResolveReferences;
begin
  Formulas.ResolveReferences;
end;

function TdxSpreadSheetXLSXReader.GetColumnWidthHelper: TdxSpreadSheetExcelColumnWidthHelper;
begin
  if FColumnWidthHelper = nil then
  begin
    FColumnWidthHelper := TdxSpreadSheetExcelColumnWidthHelper.Create;
    CellStyles.Fonts.DefaultFont.AssignToFont(FColumnWidthHelper.Font);
  end;
  Result := FColumnWidthHelper;
end;

function TdxSpreadSheetXLSXReader.GetContentType(const AFileName: string): string;
begin
  if FContentTypeIndex = nil then
  begin
    FContentTypeIndex := TdxStringsDictionary.Create;
    ExecuteSubTask(TdxXLSXContentTypeIndexReader.Create(Self, FContentTypeIndex));
  end;
  if not FContentTypeIndex.TryGetValue(AFileName, Result) then
    Result := EmptyStr;
end;

{ TdxXLSXExternalLinkHandler }

constructor TdxXLSXExternalLinkHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FLinks := Owner.SpreadSheet.ExternalLinks;
  FRels := Owner.Rels;
end;

procedure TdxXLSXExternalLinkHandler.OnAttributes(const AReader: TdxXmlReader);
var
  ARelsID: string;
  ARelsItem: TdxXLSXRelationship;
begin
  ARelsID := AReader.GetAttribute(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '');
  if FRels.Find(ARelsID, ARelsItem) then
    FLinks.Add(ARelsItem.Target)
  else
    DoError(sdxErrorInvalidRelationshipId, [ARelsID], ssmtError);
end;

{ TdxXLSXExternalLinkReader }

procedure TdxXLSXExternalLinkReader.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeExternalBook, TdxXLSXExternalLinkHandler, Self);
end;

{ TdxXLSXSharedStringHandler }

constructor TdxXLSXSharedStringHandler.Create(AOwner, AData: TObject);
begin
  inherited Create(AOwner, '', TdxSpreadSheetFormattedSharedStringRuns.Create, TStringBuilder.Create);
end;

destructor TdxXLSXSharedStringHandler.Destroy;
begin
  FreeAndNil(FText);
  FreeAndNil(FRuns);
  inherited;
end;

procedure TdxXLSXSharedStringHandler.BeforeDestruction;
var
  AReader: TdxSpreadSheetXLSXReader;
begin
  inherited;
  AReader := Owner.Owner;
  AReader.SharedStrings.Add(AReader.AddSharedString(FText.ToString, FRuns));
end;

{ TdxXLSXSharedStringReader }

procedure TdxXLSXSharedStringReader.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXAttrSharedIndex, TdxXLSXSharedStringHandler);
end;

{ TdxXLSXWorkbookView }

constructor TdxXLSXWorkbookView.Create;
begin
  ActiveSheetIndex := -1;
  ShowHorizontalScrollBar := True;
  ShowVerticalScrollBar := True;
  ShowTabs := True;
end;

{ TdxXLSXWorkbookReader }

constructor TdxXLSXWorkbookReader.Create(const AFileName: string;
  AOwner: TdxSpreadSheetXLSXReader; AProgressHelper: TcxCustomProgressCalculationHelper = nil);
begin
  inherited;
  FView := TdxXLSXWorkbookView.Create;
  FLocalSheetIdMap := TdxXLSXStringToObjectMap.Create;
end;

destructor TdxXLSXWorkbookReader.Destroy;
begin
  FreeAndNil(FLocalSheetIdMap);
  FreeAndNil(FView);
  inherited;
end;

procedure TdxXLSXWorkbookReader.AfterConstruction;
begin
  inherited;

  SpreadSheet.OptionsBehavior.IterativeCalculation := False;
  SpreadSheet.OptionsBehavior.IterativeCalculationMaxCount := 100;
  SpreadSheet.OptionsProtection.Protected := False;
  SpreadSheet.OptionsProtection.ProtectionInfo := nil;
  SpreadSheet.OptionsView.DateTimeSystem := dts1900;
  SpreadSheet.OptionsView.R1C1Reference := False;

  Handlers.Add(sdxXLSXNodeBookViews, TdxXLSXWorkbookViewHandler, FView);
  Handlers.Add(sdxXLSXNodeCalcPr, ProcessCalculationProperties);
  Handlers.Add(sdxXLSXNodeDefinedNames, TdxXLSXWorkbookDefinedNameCollectionHandler);
  Handlers.Add(sdxXLSXNodeExternalReferences, TdxXLSXWorkbookExternalLinkCollectionHandler);
  Handlers.Add(sdxXLSXNodeSheets, TdxXLSXWorkbookSheetCollectionHandler);
  Handlers.Add(sdxXLSXNodeWorkbookPr, ProcessDateTimeSystem);
  Handlers.Add(sdxXLSXNodeWorkbookProtection, ProcessProtection);
end;

procedure TdxXLSXWorkbookReader.Execute;
begin
  ReadThemes;
  ReadStyles;
  ReadStrings;
  inherited;
  ApplyView;
end;

function TdxXLSXWorkbookReader.ProcessCalculationProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  SpreadSheet.OptionsBehavior.IterativeCalculationMaxCount := AReader.GetAttributeAsInteger(sdxXLSXAttrIterateCount, 100);
  SpreadSheet.OptionsBehavior.IterativeCalculation := AReader.GetAttributeAsBoolean(sdxXLSXAttrIterate);
  SpreadSheet.OptionsView.R1C1Reference := dxSameText(AReader.GetAttribute(sdxXLSXAttrRefMode), sdxXLSXValueR1C1);
  Result := nil;
end;

function TdxXLSXWorkbookReader.ProcessDateTimeSystem(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if AReader.GetAttributeAsBoolean(sdxXLSXAttrDate1904) then
    SpreadSheet.OptionsView.DateTimeSystem := dts1904
  else
    SpreadSheet.OptionsView.DateTimeSystem := dts1900;

  Result := nil;
end;

function TdxXLSXWorkbookReader.ProcessProtection(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AStandardProtection: TdxSpreadSheetStandardProtectionInfo;
  AStrongProtection: TdxSpreadSheetStrongProtectionInfo;
  AValue: string;
begin
  SpreadSheet.OptionsProtection.Protected := True;
  SpreadSheet.OptionsProtection.AllowChangeStructure := not AReader.GetAttributeAsBoolean(sdxXLSXAttrLockStructure);

  if AReader.TryGetAttribute(sdxXLSXAttrWorkbookAlgorithmName, AValue) then
  begin
    AStrongProtection := TdxSpreadSheetStrongProtectionInfo.Create;
    AStrongProtection.HashAlgorithm := TdxSpreadSheetXLSXHelper.StringToHashAlgorithm(AReader.GetAttribute(sdxXLSXAttrWorkbookAlgorithmName));
    AStrongProtection.HashValueAsString := AReader.GetAttribute(sdxXLSXAttrWorkbookHashValue);
    AStrongProtection.SaltValueAsString := AReader.GetAttribute(sdxXLSXAttrWorkbookSaltValue);
    AStrongProtection.SpinCount := AReader.GetAttributeAsInteger(sdxXLSXAttrWorkbookSpinCount);
    SpreadSheet.OptionsProtection.ProtectionInfo := AStrongProtection;
  end
  else

  if AReader.TryGetAttribute(sdxXLSXAttrWorkbookPassword, AValue) then
  begin
    AStandardProtection := TdxSpreadSheetStandardProtectionInfo.Create;
    AStandardProtection.KeyWordAsString := AReader.GetAttribute(sdxXLSXAttrWorkbookPassword);
    SpreadSheet.OptionsProtection.ProtectionInfo := AStandardProtection;
  end;

  Result := nil;
end;

procedure TdxXLSXWorkbookReader.ApplyView;
begin
  if FView.ActiveSheetIndex >= 0 then
    SpreadSheet.ActiveSheetIndex := FView.ActiveSheetIndex;
  SpreadSheet.OptionsView.HorizontalScrollBar := FView.ShowHorizontalScrollBar;
  SpreadSheet.OptionsView.VerticalScrollBar := FView.ShowVerticalScrollBar;
  SpreadSheet.PageControl.Visible := FView.ShowTabs;
end;

procedure TdxXLSXWorkbookReader.ReadStrings;
var
  AItem: TdxXLSXRelationship;
begin
  if Rels.FindByType(sdxXLSXSharedStringRelationship, AItem) then
    ExecuteSubTask(TdxXLSXSharedStringReader.Create(AItem.Target, Owner, ProgressHelper))
  else
    ProgressHelper.SkipStage;
end;

procedure TdxXLSXWorkbookReader.ReadStyles;
var
  AItem: TdxXLSXRelationship;
begin
  if Rels.FindByType(sdxXLSXStyleRelationship, AItem) then
  begin
    ExecuteSubTask(TdxXLSXIndexedColorsReader.Create(AItem.Target, Owner)); // before TdxXLSXStyleReader
    ExecuteSubTask(TdxXLSXStyleReader.Create(AItem.Target, Owner, ProgressHelper));
  end
  else
    ProgressHelper.SkipStage;
end;

procedure TdxXLSXWorkbookReader.ReadThemes;
var
  AItem: TdxXLSXRelationship;
begin
  if Rels.FindByType(sdxXLSXThemeRelationship, AItem) then
    ExecuteSubTask(TdxXLSXThemeReader.Create(AItem.Target, Owner, Owner.ThemeData));
end;

{ TdxXLSXColorHandler }

constructor TdxXLSXColorHandler.Create(AOwner: TdxXLSXCustomDocumentReader; AColor: PColor);
begin
  inherited Create(AOwner, nil);
  FColor := AColor;
end;

procedure TdxXLSXColorHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrRGB, AValue) then
    FColor^ := TdxXLSXUtils.DecodeColor(AValue)
  else if AReader.TryGetAttribute(sdxXLSXAttrTheme, AValue) then
    FColor^ := ExtractThemedColor(AReader, StrToIntDef(AValue, 0))
  else if AReader.TryGetAttribute(sdxXLSXAttrIndexed, AValue) then
    FColor^ := ExtractIndexedColor(AReader, StrToIntDef(AValue, 0))
  else if AReader.GetAttributeAsBoolean(sdxXLSXAttrAuto) then
    FColor^ := clDefault
  else
    FColor^ := clNone;
end;

function TdxXLSXColorHandler.ExtractIndexedColor(AReader: TdxXmlReader; AColorIndex: Integer): TColor;
var
  AIndexedColors: TdxColorList;
begin
  AIndexedColors := Owner.Owner.IndexedColors;
  if AIndexedColors.Count > 0 then
  begin
    if AColorIndex >= AIndexedColors.Count then
      Result := clDefault
    else
      Result := AIndexedColors[AColorIndex];
  end
  else
  begin
    if AColorIndex >= 8 then
      Dec(AColorIndex, 8);

    if (AColorIndex >= Low(dxExcelStandardColors)) and (AColorIndex <= High(dxExcelStandardColors)) then
      Result := dxExcelStandardColors[AColorIndex]
    else
    begin
      Result := clDefault;
      if (AColorIndex <> 56) and (AColorIndex <> 57) then
        DoError(sdxErrorInvalidColorIndex, [AColorIndex], ssmtWarning);
    end;
  end;
end;

function TdxXLSXColorHandler.ExtractThemedColor(AReader: TdxXmlReader; AThemeIndex: Integer): TColor;
var
  AAttr: string;
  AThemeData: TdxXLSXReaderThemeData;
begin
  AThemeData := Owner.Owner.ThemeData;
  if Owner.CheckListIndex(AThemeIndex, AThemeData.Colors, sdxErrorInvalidColorIndex, ssmtWarning) then
  begin
    Result := TColor(AThemeData.Colors[AThemeIndex]);
    if AReader.TryGetAttribute(sdxXLSXAttrThemeTint, AAttr) then 
      Result := TdxSpreadSheetColorHelper.ApplyTint(Result, StrToFloat(AAttr, dxInvariantFormatSettings));
  end
  else
    Result := clDefault;
end;

{ TdxXLSXFontHandler }

constructor TdxXLSXFontHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FHandle := AData as TdxSpreadSheetFontHandle;

  Handlers.Add(dxStringToAnsiString(dxXLSXFontStyles[fsBold]), ProcessStyleBold);
  Handlers.Add(dxStringToAnsiString(dxXLSXFontStyles[fsItalic]), ProcessStyleItalic);
  Handlers.Add(dxStringToAnsiString(dxXLSXFontStyles[fsStrikeOut]), ProcessStyleStrikeOut);
  Handlers.Add(dxStringToAnsiString(dxXLSXFontStyles[fsUnderline]), ProcessStyleUnderline);

  Handlers.Add(sdxXLSXNodeCharset, ProcessCharset);
  Handlers.Add(sdxXLSXNodeColor, ProcessColor);
  Handlers.Add(sdxXLSXNodeFontName, ProcessName);
  Handlers.Add(sdxXLSXNodeName, ProcessName);
  Handlers.Add(sdxXLSXNodeSZ, ProcessSize);
  Handlers.Add(sdxXLSXNodeVertAlign, ProcessVerticalAlignment);
end;

function TdxXLSXFontHandler.ProcessCharset(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FHandle.Charset := AReader.GetAttributeAsInteger(sdxXLSXAttrVal);
  Result := nil;
end;

function TdxXLSXFontHandler.ProcessColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXColorHandler.Create(Owner, @FHandle.Color);
end;

function TdxXLSXFontHandler.ProcessName(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FHandle.Name := AReader.GetAttribute(sdxXLSXAttrVal);
  Result := nil;
end;

function TdxXLSXFontHandler.ProcessSize(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FHandle.Size := Round(StrToFloat(AReader.GetAttribute(sdxXLSXAttrVal), dxInvariantFormatSettings));
  Result := nil;
end;

procedure TdxXLSXFontHandler.ProcessStyle(const AReader: TdxXmlReader; AStyle: TFontStyle);
var
  AValue: string;
begin
  AValue := AReader.GetAttribute(sdxXLSXAttrVal);
  if (AValue = '') or TdxXMLHelper.DecodeBoolean(AValue) then
    Include(FHandle.Style, AStyle);
end;

function TdxXLSXFontHandler.ProcessStyleBold(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  ProcessStyle(AReader, fsBold);
  Result := nil;
end;

function TdxXLSXFontHandler.ProcessStyleItalic(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  ProcessStyle(AReader, fsItalic);
  Result := nil;
end;

function TdxXLSXFontHandler.ProcessStyleStrikeOut(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  ProcessStyle(AReader, fsStrikeOut);
  Result := nil;
end;

function TdxXLSXFontHandler.ProcessStyleUnderline(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  ProcessStyle(AReader, fsUnderline);
  Result := nil;
end;

function TdxXLSXFontHandler.ProcessVerticalAlignment(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AValue: string;
begin
  AValue := AReader.GetAttribute(sdxXLSXAttrVal);
  if dxSameText(AValue, sdxXLSXValueSuperscript) then
    FHandle.Script := fsSuperscript
  else if dxSameText(AValue, sdxXLSXValueSubscript) then
    FHandle.Script := fsSubscript;
  Result := nil;
end;

{ TdxXLSXFormattedTextHandler }

constructor TdxXLSXFormattedTextHandler.Create(AOwner: TObject;
  const ANamespace: AnsiString; ARuns: TdxSpreadSheetFormattedSharedStringRuns; AText: TStringBuilder);
begin
  inherited Create(AOwner, nil);
  FRuns := ARuns;
  FText := AText;

  Handlers.Add(ANamespace, sdxXLSXNodeRichTextRun, ProcessTextRun);
  Handlers.Add(ANamespace, sdxXLSXNodeRichTextRunParagraph, TdxXLSXFormattedTextFontHandler, Self);
  Handlers.Add(ANamespace, sdxXLSXNodeText, ProcessText, True);
end;

procedure TdxXLSXFormattedTextHandler.ProcessText(const S: string);
begin
  if S <> '' then
    FText.Append(S);
end;

function TdxXLSXFormattedTextHandler.ProcessTextRun(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := Self;
end;

{ TdxXLSXFormattedTextFontHandler }

procedure TdxXLSXFormattedTextFontHandler.BeforeDestruction;
begin
  inherited;
  if (FOwner.FText.Length > 0) or not FHandle.IsEqual(Owner.Owner.CellStyles.Fonts.DefaultFont) then
    FOwner.FRuns.Add(FOwner.FText.Length + 1, Owner.Owner.AddFont(FHandle))
  else
    FHandle.Free;
end;

constructor TdxXLSXFormattedTextFontHandler.Create(AOwner, AData: TObject);
begin
  FOwner := AData as TdxXLSXFormattedTextHandler;
  inherited Create(AOwner, TdxXLSXCustomDocumentReader(AOwner).Owner.CreateTempFontHandle);
end;

{ TdxXLSXHyperlinkHandler }

constructor TdxXLSXHyperlinkHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FHyperlink := AData as TdxSpreadSheetHyperlink;
end;

procedure TdxXLSXHyperlinkHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrDisplay, AValue) then
    FHyperlink.DisplayText := AValue;
  if AReader.TryGetAttribute(sdxXLSXAttrTooltip, AValue) then
    FHyperlink.ScreenTip := AValue;
  Owner.Owner.Hyperlinks.AddObject(ReadValue(AReader), FHyperlink);
end;

function TdxXLSXHyperlinkHandler.ReadValue(AReader: TdxXmlReader): string;
var
  ARelsItem: TdxXLSXRelationship;
  AValue: string;
begin
  Result := '';
  if AReader.TryGetAttribute(sdxXLSXAttrLocation, AValue) then
    Result := dxSpreadSheetFormulaIncludeEqualSymbol(AValue)
  else
    if AReader.TryGetAttribute(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '', AValue) then
    begin
      if Owner.Rels.Find(AValue, ARelsItem) then
        Result := ARelsItem.Target;
    end;
end;

{ TdxXLSXMetadataReader }

constructor TdxXLSXMetadataReader.Create(const AFileName: string;
  AOwner: TdxSpreadSheetXLSXReader; AProgressHelper: TcxCustomProgressCalculationHelper = nil);
begin
  inherited;
  FMetadata := AOwner.SpreadSheet.OptionsMetadata;
  FMetadata.Reset;
end;

procedure TdxXLSXMetadataReader.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceCoreProperties, sdxXLSXNodeKeywords, DoReadKeywords);
  Handlers.Add(sdxXLSXNamespaceCoreProperties, sdxXLSXNodeLastModifiedBy, DoReadLastModifiedBy);
  Handlers.Add(sdxXLSXNamespaceCoreProperties, sdxXLSXNodeLastPrinted, DoReadLastPrinted);
  Handlers.Add(sdxXLSXNamespaceDublinCore, sdxXLSXNodeCreator, DoReadCreatedBy);
  Handlers.Add(sdxXLSXNamespaceDublinCore, sdxXLSXNodeDescription, DoReadDescription);
  Handlers.Add(sdxXLSXNamespaceDublinCore, sdxXLSXNodeSubject, DoReadSubject);
  Handlers.Add(sdxXLSXNamespaceDublinCore, sdxXLSXNodeTitle, DoReadTitle);
  Handlers.Add(sdxXLSXNamespaceDublinCoreTerms, sdxXLSXNodeCreationDate, DoReadCreated);
  Handlers.Add(sdxXLSXNamespaceDublinCoreTerms, sdxXLSXNodeModificationDate, DoReadLastModified);
end;

procedure TdxXLSXMetadataReader.DoReadCreated(const AText: string);
begin
  Metadata.Created := ToDateTime(AText);
end;

procedure TdxXLSXMetadataReader.DoReadCreatedBy(const AText: string);
begin
  Metadata.CreatedBy := AText;
end;

procedure TdxXLSXMetadataReader.DoReadDescription(const AText: string);
begin
  Metadata.Description := AText;
end;

procedure TdxXLSXMetadataReader.DoReadKeywords(const AText: string);
begin
  Metadata.Keywords := AText;
end;

procedure TdxXLSXMetadataReader.DoReadLastModified(const AText: string);
begin
  Metadata.LastModified := ToDateTime(AText)
end;

procedure TdxXLSXMetadataReader.DoReadLastModifiedBy(const AText: string);
begin
  Metadata.LastModifiedBy := AText;
end;

procedure TdxXLSXMetadataReader.DoReadLastPrinted(const AText: string);
begin
  Metadata.LastPrinted := ToDateTime(AText)
end;

procedure TdxXLSXMetadataReader.DoReadSubject(const AText: string);
begin
  Metadata.Subject := AText;
end;

procedure TdxXLSXMetadataReader.DoReadTitle(const AText: string);
begin
  Metadata.Title := AText;
end;

function TdxXLSXMetadataReader.ToDateTime(const S: string): TDateTime;
var
  ADateTime: TdxXMLDateTime;
begin
  try
    ADateTime.Parse(S);
    Result := ADateTime.ToDateTime;
  except
    Result := 0;
  end;
end;

{ TdxXLSXWorkbookDefinedNameHandler }

procedure TdxXLSXWorkbookDefinedNameHandler.BeforeDestruction;
var
  ADefinedName: TdxSpreadSheetDefinedName;
  AScope: TdxSpreadSheetCustomView;
begin
  inherited;

  AScope := nil;
  if FSheetId <> '' then
  begin
    if not Owner.LocalSheetIdMap.TryGetValue(FSheetId, TObject(AScope)) then
      DoError(sdxErrorInvalidSheetId, [FSheetId], ssmtWarning);
  end;

  ADefinedName := Owner.SpreadSheet.DefinedNames.AddOrSet(FName, FReference, AScope);
  ADefinedName.Comment := FComment;

  if ADefinedName.Caption = sdxXLSXPrintAreaDefinedName then
    TdxSpreadSheetPrintAreasHelper.ImportPrintArea(ADefinedName)
  else if ADefinedName.Caption = sdxXLSXPrintTitlesDefinedName then
    TdxSpreadSheetPrintAreasHelper.ImportPrintTitles(ADefinedName);
end;

procedure TdxXLSXWorkbookDefinedNameHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FName := AReader.GetAttribute(sdxXLSXAttrName);
  FSheetId := AReader.GetAttribute(sdxXLSXAttrLocalSheetId);
  FComment := AReader.GetAttribute(sdxXLSXAttrComment);
end;

procedure TdxXLSXWorkbookDefinedNameHandler.OnText(const AReader: TdxXmlReader);
begin
  FReference := AReader.ActualValue;
end;

function TdxXLSXWorkbookDefinedNameHandler.GetOwner: TdxXLSXWorkbookReader;
begin
  Result := TdxXLSXWorkbookReader(inherited Owner);
end;

{ TdxXLSXWorkbookDefinedNameCollectionHandler }

procedure TdxXLSXWorkbookDefinedNameCollectionHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeDefinedName, TdxXLSXWorkbookDefinedNameHandler);
end;

{ TdxXLSXWorkbookExternalLinkCollectionHandler }

procedure TdxXLSXWorkbookExternalLinkCollectionHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeExternalReference, CreateExternalLinkHandler);
end;

function TdxXLSXWorkbookExternalLinkCollectionHandler.CreateExternalLinkHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  ARelsId: string;
  ARelsItem: TdxXLSXRelationship;
begin
  ARelsId := AReader.GetAttribute(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '');
  if Owner.Rels.Find(ARelsId, ARelsItem) then
    Owner.ExecuteSubTask(TdxXLSXExternalLinkReader.Create(ARelsItem.Target, Owner.Owner))
  else
    DoError(sdxErrorInvalidRelationshipId, [ARelsId], ssmtError);
  Result := nil;
end;

{ TdxXLSXWorkbookSheetCollectionHandler }

constructor TdxXLSXWorkbookSheetCollectionHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNodeSheet, CreateSheetHandler);
end;

function TdxXLSXWorkbookSheetCollectionHandler.CreateSheetHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  ARelsId: string;
  ARelsItem: TdxXLSXRelationship;
  AView: TdxSpreadSheetTableView;
begin
  ARelsId := AReader.GetAttribute(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '');
  if not Owner.Rels.Find(ARelsId, ARelsItem) then
    DoError(sdxErrorInvalidRelationshipId, [ARelsId], ssmtError)
  else
    if dxSameText(ARelsItem.TargetType, sdxXLSXWorksheetRelationship) then
    begin
      AView := Owner.Owner.AddTableView(AReader.GetAttribute(sdxXLSXAttrName));
      AView.Visible := not dxSameText(AReader.GetAttribute(sdxXLSXAttrState), sdxXLSXValueHidden);
      Owner.LocalSheetIdMap.Add(IntToStr(AView.Index), AView);
      Owner.ExecuteSubTask(TdxXLSXWorksheetReader.Create(ARelsItem.Target, AView, Owner.Owner));
    end;

  Result := nil;
end;

function TdxXLSXWorkbookSheetCollectionHandler.GetOwner: TdxXLSXWorkbookReader;
begin
  Result := TdxXLSXWorkbookReader(inherited Owner);
end;

{ TdxXLSXWorkbookViewHandler }

constructor TdxXLSXWorkbookViewHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FView := AData as TdxXLSXWorkbookView;
  Handlers.Add(sdxXLSXNodeWorkBookView, ProcessWorkbookView);
end;

function TdxXLSXWorkbookViewHandler.ProcessWorkbookView(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FView.ActiveSheetIndex := AReader.GetAttributeAsInteger(sdxXLSXAttrActiveTab, -1);
  FView.ShowHorizontalScrollBar := AReader.GetAttributeAsBoolean(sdxXLSXAttrShowHorizontalScroll, True);
  FView.ShowVerticalScrollBar := AReader.GetAttributeAsBoolean(sdxXLSXAttrShowVerticalScroll, True);
  FView.ShowTabs := AReader.GetAttributeAsBoolean(sdxXLSXAttrShowSheetTabs, True);
  Result := nil;
end;

{ TdxXLSXWorksheetCustomHandler }

constructor TdxXLSXWorksheetCustomHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FStyles := Owner.Owner.Styles;
  FView := AData as TdxSpreadSheetTableView;
end;

{ TdxXLSXWorksheetViewsHandler }

constructor TdxXLSXWorksheetViewsHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNodeSheetView, TdxXLSXWorksheetViewHandler, AData);
end;

{ TdxXLSXWorksheetMergedCellsHandler }

constructor TdxXLSXWorksheetMergedCellsHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNodeMergeCell, ProcessMergedCell);
end;

function TdxXLSXWorksheetMergedCellsHandler.ProcessMergedCell(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  ARect: TRect;
begin
  ARect := dxStringToReferenceArea(AReader.GetAttribute(sdxXLSXAttrRef));
  if (ARect.Left >= 0) and (ARect.Top >= 0) and (ARect.Right >= 0) and (ARect.Bottom >= 0) then
    View.MergedCells.Add(ARect);
  Result := nil;
end;

{ TdxXLSXWorksheetViewHandler }

procedure TdxXLSXWorksheetViewHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodePane, ProcessPane);
  Handlers.Add(sdxXLSXNodeSelection, ProcessSelection);
end;

procedure TdxXLSXWorksheetViewHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  inherited;
  FTopLeftCellReference := AReader.GetAttribute(sdxXLSXAttrTopLeftCell);

  View.Options.ZoomFactor := AReader.GetAttributeAsInteger(sdxXLSXAttrZoomScaleNormal, 100);
  View.Options.ZeroValues := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrZeroValues);
  View.Options.ShowFormulas := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrShowFormulas);
  View.Options.GridLines := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrGridLines);
  View.Options.Headers := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrShowRowColHeaders);
  View.Options.RightToLeftLayout := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrRightToLeft);

  if AReader.GetAttributeAsBoolean(sdxXLSXAttrTabSelected) then
    View.Active := True;
end;

function TdxXLSXWorksheetViewHandler.ProcessPane(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AColumnIndex: Integer;
  AFrozenColumn: Integer;
  AFrozenRow: Integer;
  ARowIndex: Integer;
begin
  FActivePane := AReader.GetAttribute(sdxXLSXAttrActivePane);

  AFrozenRow := AReader.GetAttributeAsInteger(sdxXLSXAttrSplitY) - 1;
  AFrozenColumn := AReader.GetAttributeAsInteger(sdxXLSXAttrSplitX) - 1;
  if dxTryStringToReference(FTopLeftCellReference, False, ARowIndex, AColumnIndex) then
  begin
    if AFrozenColumn >= 0 then
      Inc(AFrozenColumn, AColumnIndex);
    if AFrozenRow >= 0 then
      Inc(AFrozenRow, ARowIndex);
  end;
  View.FrozenColumn := AFrozenColumn;
  View.FrozenRow := AFrozenRow;

  if dxTryStringToReference(AReader.GetAttribute(sdxXLSXAttrTopLeftCell), False, ARowIndex, AColumnIndex) then
  begin
    TdxSpreadSheetTableViewAccess(View).ViewInfo.FirstScrollableColumn := AColumnIndex;
    TdxSpreadSheetTableViewAccess(View).ViewInfo.FirstScrollableRow := ARowIndex;
  end;

  Result := nil;
end;

function TdxXLSXWorksheetViewHandler.ProcessSelection(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AFocus: TPoint;
  AParts: TStringList;
  ARect: TRect;
  ASelection: TdxSpreadSheetTableViewSelection;
  AValue: string;
  I: Integer;
begin
  if dxSameText(AReader.GetAttribute(sdxXLSXAttrPane), FActivePane) then
  begin
    ASelection := View.Selection;
    ASelection.Clear;

    if AReader.TryGetAttribute(sdxXLSXAttrActiveCell, AValue) then
      AFocus := dxStringToReferenceArea(AValue).TopLeft
    else
      AFocus := cxInvalidPoint;

    if AReader.TryGetAttribute(sdxXLSXAttrSqRef, AValue) then
    begin
      AParts := TStringList.Create;
      try
        AParts.Delimiter := ' ';
        AParts.DelimitedText := AValue;
        for I := 0 to AParts.Count - 1 do
        begin
          ARect := dxStringToReferenceArea(AParts[I]);
          if (ARect.Left = 0) and (ARect.Right = dxXLSXMaxColumnIndex) then
            ARect.Right := MaxInt;
          if (ARect.Top = 0) and (ARect.Bottom = dxXLSXMaxRowIndex) then
            ARect.Bottom := MaxInt;
          if not ASelection.HasArea(ARect) then
            ASelection.Add(ARect, [ssCtrl], AFocus.Y, AFocus.X);
        end;
      finally
        AParts.Free;
      end;
    end;
  end;
  Result := nil;
end;

{ TdxXLSXWorksheetPrintingHeaderFooterHandler }

constructor TdxXLSXWorksheetPrintingHeaderFooterHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FHeaderFooter := AData as TdxSpreadSheetTableViewOptionsPrintHeaderFooter;
  Handlers.Add(sdxXLSXNodeOddFooter, TdxXLSXWorksheetPrintingHeaderFooterTextHandler, FHeaderFooter.CommonFooter);
  Handlers.Add(sdxXLSXNodeOddHeader, TdxXLSXWorksheetPrintingHeaderFooterTextHandler, FHeaderFooter.CommonHeader);
end;

procedure TdxXLSXWorksheetPrintingHeaderFooterHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  HeaderFooter.AlignWithMargins := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrHeaderFooterAlignWithMargins);
  HeaderFooter.ScaleWithDocument := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrHeaderFooterScaleWithDocument);

  if AReader.GetAttributeAsBoolean(sdxXLSXAttrHeaderFooterDifferentFirst) then
  begin
    Handlers.Add(sdxXLSXNodeFirstFooter, TdxXLSXWorksheetPrintingHeaderFooterTextHandler, HeaderFooter.FirstPageFooter);
    Handlers.Add(sdxXLSXNodeFirstHeader, TdxXLSXWorksheetPrintingHeaderFooterTextHandler, HeaderFooter.FirstPageHeader);
  end;

  if AReader.GetAttributeAsBoolean(sdxXLSXAttrHeaderFooterDifferentOddEven) then
  begin
    Handlers.Add(sdxXLSXNodeEvenFooter, TdxXLSXWorksheetPrintingHeaderFooterTextHandler, HeaderFooter.EvenPagesFooter);
    Handlers.Add(sdxXLSXNodeEvenHeader, TdxXLSXWorksheetPrintingHeaderFooterTextHandler, HeaderFooter.EvenPagesHeader);
  end;
end;

{ TdxXLSXWorksheetPrintingHeaderFooterTextHandler }

constructor TdxXLSXWorksheetPrintingHeaderFooterTextHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FText := AData as TdxSpreadSheetTableViewOptionsPrintHeaderFooterText;
  FText.Reset;
end;

procedure TdxXLSXWorksheetPrintingHeaderFooterTextHandler.OnText(const AReader: TdxXmlReader);
begin
  TdxSpreadSheetHeaderFooterHelper.Parse(Text, TdxXMLConvert.DecodeName(AReader.ActualValue));
end;

{ TdxXLSXWorksheetPrintingPageBreaksHandler }

constructor TdxXLSXWorksheetPrintingPageBreaksHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FBreaks := TList<Cardinal>(AData);
  FBreaks.Clear;
end;

function TdxXLSXWorksheetPrintingPageBreaksHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if AReader.GetAttributeAsBoolean(sdxXLSXAttrBreakManual) then
    FBreaks.Add(AReader.GetAttributeAsInteger(sdxXLSXAttrBreakID));
  Result := nil;
end;

{ TdxXLSXWorksheetPrintingPageMarginsHandler }

constructor TdxXLSXWorksheetPrintingPageMarginsHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FMargins := AData as TdxSpreadSheetTableViewOptionsPrintPageMargins;
end;

procedure TdxXLSXWorksheetPrintingPageMarginsHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  Margins.Left := AReader.GetAttributeAsSingle(sdxXLSXAttrPageMarginsLeft);
  Margins.Top := AReader.GetAttributeAsSingle(sdxXLSXAttrPageMarginsTop);
  Margins.Right := AReader.GetAttributeAsSingle(sdxXLSXAttrPageMarginsRight);
  Margins.Bottom := AReader.GetAttributeAsSingle(sdxXLSXAttrPageMarginsBottom);
  Margins.Header := AReader.GetAttributeAsSingle(sdxXLSXAttrPageMarginsHeader);
  Margins.Footer := AReader.GetAttributeAsSingle(sdxXLSXAttrPageMarginsFooter);
  Margins.Assigned := True;
end;

{ TdxXLSXWorksheetPrintingPageSetupHandler }

constructor TdxXLSXWorksheetPrintingPageSetupHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FOptions := AData as TdxSpreadSheetTableViewOptionsPrint;
end;

procedure TdxXLSXWorksheetPrintingPageSetupHandler.OnAttributes(const AReader: TdxXmlReader);
var
  APage: TdxSpreadSheetTableViewOptionsPrintPage;
  APaper: TdxSpreadSheetTableViewOptionsPrintPagePaper;
  APrevScaleMode: TdxSpreadSheetTableViewOptionsPrintPageScaleMode;
  APrinting: TdxSpreadSheetTableViewOptionsPrintPrinting;
begin
  APage := Options.Page;
  APrevScaleMode := APage.ScaleMode;
  APage.FitToHeight := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupFitToHeight, 1);
  APage.FitToWidth := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupFitToWidth, 1);
  APage.Orientation := TdxSpreadSheetXLSXHelper.StringToPrintPageOrientation(AReader.GetAttribute(sdxXLSXAttrPageSetupOrientation));
  APage.Scale := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupScale, 100);
  if AReader.GetAttributeAsBoolean(sdxXLSXAttrPageSetupUseFirstPageNumber) then
    APage.FirstPageNumber := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupFirstPageNumber);
  if APrevScaleMode <> oppsmDefault then
    APage.ScaleMode := APrevScaleMode;

  APaper := Options.Page.Paper;
  APaper.SizeID := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupPaperSize);
  APaper.CustomSize.X := TdxValueUnitsHelper.ValueToInchesF(AReader.GetAttribute(sdxXLSXAttrPageSetupPaperWidth));
  APaper.CustomSize.Y := TdxValueUnitsHelper.ValueToInchesF(AReader.GetAttribute(sdxXLSXAttrPageSetupPaperHeight));
  APaper.Assigned := (APaper.SizeID <> 0) or (APaper.CustomSize.X > 0) and (APaper.CustomSize.Y > 0);

  APrinting := Options.Printing;
  APrinting.Draft := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrPageSetupDraft);
  APrinting.BlackAndWhite := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrPageSetupBlackAndWhite);
  APrinting.Copies := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupCopies);
  APrinting.PageOrder := TdxSpreadSheetXLSXHelper.StringToPrintPageOrder(AReader.GetAttribute(sdxXLSXAttrPageSetupPageOrder));

  Options.Source.ErrorIndication := TdxSpreadSheetXLSXHelper.StringToPrintErrorIndication(AReader.GetAttribute(sdxXLSXAttrPageSetupErrors));
  Options.Source.CellComments := TdxSpreadSheetXLSXHelper.StringToPrintCellComments(AReader.GetAttribute(sdxXLSXAttrPageSetupCellComments));
end;
(*
procedure TdxXLSXWorksheetPrintingPageSetupHandler.OnAttributes(const AReader: TdxXmlReader);
var
  APage: TdxSpreadSheetTableViewOptionsPrintPage;
  APaper: TdxSpreadSheetTableViewOptionsPrintPagePaper;
  APrevScaleMode: TdxSpreadSheetTableViewOptionsPrintPageScaleMode;
  APrinting: TdxSpreadSheetTableViewOptionsPrintPrinting;
  AValue: string;
begin
  APage := Options.Page;
  APrevScaleMode := APage.ScaleMode;

  if AReader.TryGetAttribute(sdxXLSXAttrPageSetupFitToHeight, AValue) then
    APage.FitToHeight := StrToIntDef(AValue, 1);
  if AReader.TryGetAttribute(sdxXLSXAttrPageSetupFitToWidth, AValue) then
    APage.FitToWidth := StrToIntDef(AValue, 1);
  if AReader.TryGetAttribute(sdxXLSXAttrPageSetupOrientation, AValue) then
    APage.Orientation := TdxSpreadSheetXLSXHelper.StringToPrintPageOrientation(AValue);
  if AReader.TryGetAttribute(sdxXLSXAttrPageSetupScale, AValue) then
    APage.Scale := StrToIntDef(AValue, 100);
  if AReader.GetAttributeAsBoolean(sdxXLSXAttrPageSetupUseFirstPageNumber) then
    APage.FirstPageNumber := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupFirstPageNumber);
  if APrevScaleMode <> oppsmDefault then
    APage.ScaleMode := APrevScaleMode;

  APaper := Options.Page.Paper;
  APaper.SizeID := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupPaperSize);
  APaper.CustomSize.X := TdxValueUnitsHelper.ValueToInchesF(AReader.GetAttribute(sdxXLSXAttrPageSetupPaperWidth));
  APaper.CustomSize.Y := TdxValueUnitsHelper.ValueToInchesF(AReader.GetAttribute(sdxXLSXAttrPageSetupPaperHeight));
  APaper.Assigned := (APaper.SizeID <> 0) or (APaper.CustomSize.X > 0) and (APaper.CustomSize.Y > 0);

  APrinting := Options.Printing;
  APrinting.Draft := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrPageSetupDraft);
  APrinting.BlackAndWhite := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrPageSetupBlackAndWhite);
  APrinting.Copies := AReader.GetAttributeAsInteger(sdxXLSXAttrPageSetupCopies);
  APrinting.PageOrder := TdxSpreadSheetXLSXHelper.StringToPrintPageOrder(AReader.GetAttribute(sdxXLSXAttrPageSetupPageOrder));

  Options.Source.ErrorIndication := TdxSpreadSheetXLSXHelper.StringToPrintErrorIndication(AReader.GetAttribute(sdxXLSXAttrPageSetupErrors));
  Options.Source.CellComments := TdxSpreadSheetXLSXHelper.StringToPrintCellComments(AReader.GetAttribute(sdxXLSXAttrPageSetupCellComments));
end;
*)

{ TdxXLSXWorksheetPrintingOptionsHandler }

constructor TdxXLSXWorksheetPrintingOptionsHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FOptions := AData as TdxSpreadSheetTableViewOptionsPrint;
end;

procedure TdxXLSXWorksheetPrintingOptionsHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FOptions.Printing.HorizontalCentered := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrPrintOptionsHorzCenter);
  FOptions.Printing.VerticalCentered := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrPrintOptionsVertCenter);
  FOptions.Source.GridLines := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrPrintOptionsGridLines);
  FOptions.Source.Headers := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrPrintOptionsHeadings);
end;

{ TdxXLSXWorksheetPropertiesHandler }

procedure TdxXLSXWorksheetPropertiesHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodePageSetUpPr, ProcessPrintingScaleMode);
  Handlers.Add(sdxXLSXNodeOutlinePr, ProcessOutlineProperties);
end;

function TdxXLSXWorksheetPropertiesHandler.ProcessOutlineProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if not AReader.GetAttributeAsBoolean(sdxXLSXAttrSummaryRight, True) then
    View.Columns.Groups.ExpandButtonPosition := gebpGroupStart;
  if not AReader.GetAttributeAsBoolean(sdxXLSXAttrSummaryBelow, True) then
    View.Rows.Groups.ExpandButtonPosition := gebpGroupStart;
  Result := nil;
end;

function TdxXLSXWorksheetPropertiesHandler.ProcessPrintingScaleMode(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if AReader.GetAttributeAsBoolean(sdxXLSXAttrFitToPage) then
    View.OptionsPrint.Page.ScaleMode := oppsmFitToPage
  else
    View.OptionsPrint.Page.ScaleMode := oppsmAdjustToScale;

  Result := nil;
end;

{ TdxXLSXWorksheetProtectionHandler }

procedure TdxXLSXWorksheetProtectionHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  View.OptionsProtection.AllowDeleteColumns := not AReader.GetAttributeAsBoolean(sdxXLSXAttrDeleteColumns, True);
  View.OptionsProtection.AllowDeleteRows := not AReader.GetAttributeAsBoolean(sdxXLSXAttrDeleteRows, True);
  View.OptionsProtection.AllowFormatCells := not AReader.GetAttributeAsBoolean(sdxXLSXAttrFormatCells, True);
  View.OptionsProtection.AllowResizeColumns := not AReader.GetAttributeAsBoolean(sdxXLSXAttrFormatColumns, True);
  View.OptionsProtection.AllowResizeRows := not AReader.GetAttributeAsBoolean(sdxXLSXAttrFormatRows, True);
  View.OptionsProtection.AllowInsertColumns := not AReader.GetAttributeAsBoolean(sdxXLSXAttrInsertColumns, True);
  View.OptionsProtection.AllowInsertRows := not AReader.GetAttributeAsBoolean(sdxXLSXAttrInsertRows, True);
  View.OptionsProtection.AllowEditHyperlinks := not AReader.GetAttributeAsBoolean(sdxXLSXAttrInsertHyperlinks, True);
  View.OptionsProtection.AllowEditContainers := not AReader.GetAttributeAsBoolean(sdxXLSXAttrObjects);
  View.OptionsProtection.AllowSelectLockedCells := not AReader.GetAttributeAsBoolean(sdxXLSXAttrSelectLockedCells);
  View.OptionsProtection.AllowSelectUnlockedCells := not AReader.GetAttributeAsBoolean(sdxXLSXAttrSelectUnlockedCell);
  View.OptionsProtection.AllowSort := not AReader.GetAttributeAsBoolean(sdxXLSXAttrSort);
  View.OptionsProtection.Protected := AReader.GetAttributeAsBoolean(sdxXLSXAttrSheet);

  if AReader.TryGetAttribute(sdxXLSXAttrAlgorithmName, AValue) then
    View.OptionsProtection.ProtectionInfo := ReadProtectionInfoStrong(AReader)
  else if AReader.TryGetAttribute(sdxXLSXAttrPassword, AValue) then
    View.OptionsProtection.ProtectionInfo := ReadProtectionInfoStandard(AReader);
end;

function TdxXLSXWorksheetProtectionHandler.ReadProtectionInfoStandard(AReader: TdxXmlReader): IdxSpreadSheetProtectionInfo;
var
  AProtection: TdxSpreadSheetStandardProtectionInfo;
begin
  AProtection := TdxSpreadSheetStandardProtectionInfo.Create;
  AProtection.KeyWordAsString := AReader.GetAttribute(sdxXLSXAttrPassword);
  Result := AProtection;
end;

function TdxXLSXWorksheetProtectionHandler.ReadProtectionInfoStrong(AReader: TdxXmlReader): IdxSpreadSheetProtectionInfo;
var
  AProtection: TdxSpreadSheetStrongProtectionInfo;
begin
  AProtection := TdxSpreadSheetStrongProtectionInfo.Create;
  AProtection.HashAlgorithm := TdxSpreadSheetXLSXHelper.StringToHashAlgorithm(AReader.GetAttribute(sdxXLSXAttrAlgorithmName));
  AProtection.HashValueAsString := AReader.GetAttribute(sdxXLSXAttrHashValue);
  AProtection.SaltValueAsString := AReader.GetAttribute(sdxXLSXAttrSaltValue);
  AProtection.SpinCount := AReader.GetAttributeAsInteger(sdxXLSXAttrSpinCount);
  Result := AProtection;
end;

{ TdxXLSXWorksheetHyperlinksHandler }

constructor TdxXLSXWorksheetHyperlinksHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNodeHyperlink, ProcessHyperlink);
end;

function TdxXLSXWorksheetHyperlinksHandler.ProcessHyperlink(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXHyperlinkHandler.Create(Owner, View.Hyperlinks.Add(dxStringToReferenceArea(AReader.GetAttribute(sdxXLSXAttrRef))));
end;

{ TdxXLSXWorksheetCellHandler }

constructor TdxXLSXWorksheetCellHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FSharedStrings := Owner.Owner.SharedStrings;

  FValueHandler := TdxXLSXWorksheetCellValueHandler.Create(Owner, Self);
  FValueHandler.AddReference;

  FFormulaHandler := TdxXLSXWorksheetCellFormulaHandler.Create(Owner, Self);
  FFormulaHandler.AddReference;

  Handlers.Add(sdxXLSXNodeCellFunction, ProcessFunction);
  Handlers.Add(sdxXLSXNodeCellInlineString, ProcessInlineString);
  Handlers.Add(sdxXLSXNodeCellValue, ProcessValue);
end;

destructor TdxXLSXWorksheetCellHandler.Destroy;
begin
  FFormulaHandler.RemoveReference;
  FValueHandler.RemoveReference;
  inherited;
end;

procedure TdxXLSXWorksheetCellHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AStyleIndex: Integer;
begin
  AStyleIndex := AReader.GetAttributeAsInteger(sdxXLSXAttrStyleIndex, -1);
  if AStyleIndex >= 0 then
  begin
    if Owner.CheckListIndex(AStyleIndex, Styles, sdxErrorInvalidStyleIndex, ssmtError) then
      FCell.StyleHandle := TdxSpreadSheetCellStyleHandle(Styles[AStyleIndex]);
  end;

  FValueType := TdxSpreadSheetXLSXHelper.StringToCellType(AReader.GetAttribute(sdxXLSXAttrCellType));
end;

procedure TdxXLSXWorksheetCellHandler.OnBegin(ACell: TdxSpreadSheetCell);
begin
  FCell := ACell;
  FValueType := sxctUnknown;
end;

procedure TdxXLSXWorksheetCellHandler.OnCellValue(const AText: string);
var
  AErrorCode: TdxSpreadSheetFormulaErrorCode;
  AIndex: Integer;
  AValue: Double;
begin
  case ValueType of

    sxctFormula:
      {todo: set calculated value};
    sxctBoolean:
      Cell.AsBoolean := TdxXMLHelper.DecodeBoolean(AText);
    sxctString:
      Cell.AsString := AText;
    sxctFloat:
      if dxTryStrToFloat(AText, AValue, dxInvariantFormatSettings) then
        Cell.AsFloat := AValue;

    sxctError:
      if dxSpreadSheetIsErrorString(AText, AErrorCode) then
        Cell.AsError := AErrorCode
      else
        Cell.AsString := AText;

    sxctUndefined:
      if TryStrToFloat(AText, AValue, dxInvariantFormatSettings) then
        Cell.AsFloat := AValue
      else
        Cell.AsString := AText;

    sxctSharedString:
      begin
        AIndex := StrToIntDef(AText, -1);
        if Owner.CheckListIndex(AIndex, SharedStrings, sdxErrorInvalidSharedStringIndex, ssmtWarning) then
          Cell.AsSharedString := TdxSpreadSheetSharedString(SharedStrings[AIndex]);
      end;
  end;
end;

function TdxXLSXWorksheetCellHandler.ProcessFunction(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := FFormulaHandler;
end;

function TdxXLSXWorksheetCellHandler.ProcessInlineString(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXWorksheetCellFormattedTextHandler.Create(Self);
end;

function TdxXLSXWorksheetCellHandler.ProcessValue(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := FValueHandler;
end;

{ TdxXLSXWorksheetCellFormattedTextHandler }

constructor TdxXLSXWorksheetCellFormattedTextHandler.Create(AOwner: TdxXLSXWorksheetCellHandler);
begin
  FOwner := AOwner;
  inherited Create(AOwner.Owner, '', TdxSpreadSheetFormattedSharedStringRuns.Create, TStringBuilder.Create);
end;

destructor TdxXLSXWorksheetCellFormattedTextHandler.Destroy;
begin
  FreeAndNil(FText);
  FreeAndNil(FRuns);
  inherited;
end;

procedure TdxXLSXWorksheetCellFormattedTextHandler.OnEnd;
begin
  FOwner.ValueType := sxctRichText;
  FOwner.Cell.AsSharedString := Owner.Owner.AddSharedString(FText.ToString, FRuns);
end;

{ TdxXLSXWorksheetCellFormulaHandler }

constructor TdxXLSXWorksheetCellFormulaHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FOwner := AData as TdxXLSXWorksheetCellHandler;
end;

procedure TdxXLSXWorksheetCellFormulaHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FExpression := EmptyStr;
  FType := AReader.GetAttribute(sdxXLSXAttrCellType);
  FReference := AReader.GetAttribute(sdxXLSXAttrRef);

  if dxSameText(FType, sdxXLSXValueShared) then
    FSharedIndex := AReader.GetAttributeAsInteger(sdxXLSXAttrSharedIndex, -1)
  else
    FSharedIndex := -1;
end;

procedure TdxXLSXWorksheetCellFormulaHandler.OnEnd;
begin
  FOwner.ValueType := sxctFormula;
  FOwner.Owner.Owner.Formulas.Add(
    FOwner.Cell, FExpression, dxSameText(FType, sdxXLSXValueArray),
    FSharedIndex, dxStringToReferenceArea(FReference));
end;

procedure TdxXLSXWorksheetCellFormulaHandler.OnText(const AReader: TdxXmlReader);
begin
  FExpression := AReader.ActualValue;
end;

{ TdxXLSXWorksheetCellValueHandler }

constructor TdxXLSXWorksheetCellValueHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FOwner := AData as TdxXLSXWorksheetCellHandler;
  Handlers.Add(sdxXLSXNodeCellInlineString, ProcessInlineString);
end;

procedure TdxXLSXWorksheetCellValueHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FValuePresented := False;
end;

procedure TdxXLSXWorksheetCellValueHandler.OnEnd;
begin
  if not FValuePresented then
    FOwner.OnCellValue(EmptyStr);
end;

procedure TdxXLSXWorksheetCellValueHandler.OnText(const AReader: TdxXmlReader);
begin
  FValuePresented := True;
  FOwner.OnCellValue(AReader.ActualValue);
end;

function TdxXLSXWorksheetCellValueHandler.ProcessInlineString(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FValuePresented := True;
  Result := TdxXLSXWorksheetCellFormattedTextHandler.Create(FOwner);
end;

{ TdxXLSXWorksheetColumnsHandler }

procedure TdxXLSXWorksheetColumnsHandler.AfterConstruction;
begin
  inherited;
  Include(TdxSpreadSheetAccess(View.SpreadSheet).FState, sssReadingCells);
end;

procedure TdxXLSXWorksheetColumnsHandler.BeforeDestruction;
begin
  inherited;
  Exclude(TdxSpreadSheetAccess(View.SpreadSheet).FState, sssReadingCells);
end;

function TdxXLSXWorksheetColumnsHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AAttr: string;
  AColumn: TdxSpreadSheetTableColumnAccess;
  AGroup: TdxSpreadSheetTableItemGroupAccess;
  AHidden: Boolean;
  AIsCustomWidth: Boolean;
  AMax: Integer;
  AMin: Integer;
  AStyleHandle: TdxSpreadSheetCellStyleHandle;
  AStyleIndex: Integer;
  AWidth: Integer;
  I: Integer;
begin
  Result := nil;


  AMin := Min(AReader.GetAttributeAsInteger(sdxXLSXAttrMin) - 1, MAXWORD);
  AMax := Min(AReader.GetAttributeAsInteger(sdxXLSXAttrMax) - 1, MAXWORD);

  if AMax < 0 then
    Exit;

  TdxSpreadSheetOutlineHelper.IncreaseOutlineLevelTo(View.Columns, AMin, AMax,
    AReader.GetAttributeAsInteger(sdxXLSXAttrOutlineLevel) - 1);
  AGroup := TdxSpreadSheetTableItemGroupAccess(View.Columns.Groups.Find(AMin - 1));
  if AGroup <> nil then
    AGroup.FCollapsedByUser := AReader.GetAttributeAsBoolean(sdxXLSXAttrCollapsed);

  AIsCustomWidth := AReader.GetAttributeAsBoolean(sdxXLSXAttrCustomWidth);
  if AReader.TryGetAttribute(sdxXLSXAttrWidth, AAttr) then
    AWidth := Owner.Owner.ColumnWidthHelper.WidthToPixels(StrToFloatDef(AAttr, 0, dxInvariantFormatSettings))
  else
    AWidth := -1;

  AStyleIndex := AReader.GetAttributeAsInteger(sdxXLSXAttrStyle, -1);
  if (AStyleIndex >= 0) and Owner.CheckListIndex(AStyleIndex, Styles, sdxErrorInvalidStyleIndex, ssmtError) then
    AStyleHandle := TdxSpreadSheetCellStyleHandle(Styles[AStyleIndex])
  else
    AStyleHandle := nil;

  AHidden := AReader.GetAttributeAsBoolean(sdxXLSXAttrHidden);
  if (AMax = dxSpreadSheetMaxColumnIndex) and ((AMin = 0) or (AMin = View.Columns.Count)) then
  begin
    View.Columns.DefaultSize := AWidth;
    if AStyleHandle <> nil then
      Owner.SpreadSheet.DefaultCellStyle.Handle := AStyleHandle;
  end
  else
    for I := AMin to AMax do
    begin
      AColumn := TdxSpreadSheetTableColumnAccess(View.Columns.CreateItem(I));
      if AStyleHandle <> nil then
        AColumn.Style.Handle := AStyleHandle;
      if AWidth >= 0 then
      begin
        AColumn.Size := AWidth;
        AColumn.IsCustomSize := AIsCustomWidth;
      end;
      AColumn.Visible := not AHidden;
    end;
end;

{ TdxXLSXWorksheetRowHandler }

constructor TdxXLSXWorksheetRowHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FCellHandler := TdxXLSXWorksheetCellHandler.Create(Owner, View);
  FCellHandler.AddReference;
end;

destructor TdxXLSXWorksheetRowHandler.Destroy;
begin
  FCellHandler.RemoveReference;
  inherited;
end;

function TdxXLSXWorksheetRowHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AColumnIndex: Integer;
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrCellColumn, AValue) then
    AColumnIndex := ExtractColumnIndex(AValue)
  else
    AColumnIndex := Row.CellCount;

  FCellHandler.OnBegin(Row.CreateCell(AColumnIndex));
  Result := FCellHandler;
end;

procedure TdxXLSXWorksheetRowHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AGroup: TdxSpreadSheetTableItemGroupAccess;
  AIndex: Integer;
  AValue: string;
begin
  TdxSpreadSheetOutlineHelper.IncreaseOutlineLevelTo(View.Rows, Row.Index, AReader.GetAttributeAsInteger(sdxXLSXAttrOutlineLevel) - 1);

  AGroup := TdxSpreadSheetTableItemGroupAccess(View.Rows.Groups.Find(Row.Index - 1));
  if AGroup <> nil then
    AGroup.FCollapsedByUser := AReader.GetAttributeAsBoolean(sdxXLSXAttrCollapsed);

  if AReader.TryGetAttribute(sdxXLSXAttrRowHeight, AValue) then
  begin
    TdxSpreadSheetTableRowAccess(Row).Size := TdxValueUnitsHelper.PointsToPixels(StrToFloatDef(AValue, 0, dxInvariantFormatSettings));
    TdxSpreadSheetTableRowAccess(Row).IsCustomSize := AReader.GetAttributeAsBoolean(sdxXLSXAttrCustomHeight);
  end;
  Row.Visible := not AReader.GetAttributeAsBoolean(sdxXLSXAttrHidden);

  if AReader.GetAttributeAsBoolean(sdxXLSXAttrCustomFormat) then
  begin
    AIndex := AReader.GetAttributeAsInteger(sdxXLSXAttrStyleIndex, 0);
    if Owner.CheckListIndex(AIndex, Styles, sdxErrorInvalidStyleIndex, ssmtError) then
      Row.Style.Handle := TdxSpreadSheetCellStyleHandle(Styles[AIndex]);
  end;
end;

function TdxXLSXWorksheetRowHandler.ExtractColumnIndex(const S: string): Integer;
var
  X: Integer;
begin
  dxStringToReference(S, Result, X);
  if (Result < 0) or (Result > dxSpreadSheetMaxColumnIndex) then
  begin
    DoError(sdxErrorInvalidColumnIndex, [S], ssmtError);
    Result := 0;
  end;
end;

{ TdxXLSXWorksheetRowsHandler }

procedure TdxXLSXWorksheetRowsHandler.AfterConstruction;
begin
  inherited;
  FRowHandler := TdxXLSXWorksheetRowHandler.Create(Owner, View);
  FRowHandler.AddReference;
  Include(TdxSpreadSheetAccess(View.SpreadSheet).FState, sssReadingCells);
end;

procedure TdxXLSXWorksheetRowsHandler.BeforeDestruction;
begin
  inherited;
  Exclude(TdxSpreadSheetAccess(View.SpreadSheet).FState, sssReadingCells);
  FRowHandler.RemoveReference;
end;

function TdxXLSXWorksheetRowsHandler.CreateHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AIndex: Integer;
begin
  AIndex := AReader.GetAttributeAsInteger(sdxXLSXAttrRowIndex) - 1;
  if AIndex < 0 then
    AIndex := View.Rows.Count;
  FRowHandler.FRow := View.Rows.CreateItem(AIndex);
  Result := FRowHandler;
end;

{ TdxXLSXWorksheetReader }

constructor TdxXLSXWorksheetReader.Create(const AFileName: string; AView: TdxSpreadSheetTableView; AOwner: TdxSpreadSheetXLSXReader);
begin
  FView := AView;
  inherited Create(AFileName, AOwner);

  FConditionalFormattingHandler := TdxXLSXConditionalFormattingHandler.Create(Self, View.ConditionalFormatting);
  FConditionalFormattingHandler.AddReference;

  Handlers.Add(sdxXLSXNodeColBreaks, TdxXLSXWorksheetPrintingPageBreaksHandler, View.OptionsPrint.Pagination.ColumnPageBreaks);
  Handlers.Add(sdxXLSXNodeColumns, TdxXLSXWorksheetColumnsHandler, View);
  Handlers.Add(sdxXLSXNodeConditionalFormatting, ProcessConditionalFormatting);
  Handlers.Add(sdxXLSXNodeHeaderFooter, TdxXLSXWorksheetPrintingHeaderFooterHandler, View.OptionsPrint.HeaderFooter);
  Handlers.Add(sdxXLSXNodeHyperlinks, TdxXLSXWorksheetHyperlinksHandler, View);
  Handlers.Add(sdxXLSXNodeLegacyDrawing, ProcessLegacyDrawing);
  Handlers.Add(sdxXLSXNodeMergeCells, TdxXLSXWorksheetMergedCellsHandler, View);
  Handlers.Add(sdxXLSXNodePageMargins, TdxXLSXWorksheetPrintingPageMarginsHandler, View.OptionsPrint.Page.Margins);
  Handlers.Add(sdxXLSXNodePageSetup, TdxXLSXWorksheetPrintingPageSetupHandler, View.OptionsPrint);
  Handlers.Add(sdxXLSXNodePrintOptions, TdxXLSXWorksheetPrintingOptionsHandler, View.OptionsPrint);
  Handlers.Add(sdxXLSXNodeRowBreaks, TdxXLSXWorksheetPrintingPageBreaksHandler, View.OptionsPrint.Pagination.RowPageBreaks);
  Handlers.Add(sdxXLSXNodeSheetData, TdxXLSXWorksheetRowsHandler, View);
  Handlers.Add(sdxXLSXNodeSheetFormatPr, ProcessSheetFormat);
  Handlers.Add(sdxXLSXNodeSheetPr, TdxXLSXWorksheetPropertiesHandler, View);
  Handlers.Add(sdxXLSXNodeSheetProtection, TdxXLSXWorksheetProtectionHandler, View);
  Handlers.Add(sdxXLSXNodeSheetViews, TdxXLSXWorksheetViewsHandler, View);
  Handlers.Add(sdxXLSXNodeExtList, TdxXLSXConditionalFormattingExtensionsHandler, FConditionalFormattingHandler);
end;

procedure TdxXLSXWorksheetReader.Execute;
begin
  inherited;
  FConditionalFormattingHandler.RemoveReference;
  ReadDrawings;
end;

function TdxXLSXWorksheetReader.ProcessConditionalFormatting(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := FConditionalFormattingHandler;
end;

function TdxXLSXWorksheetReader.ProcessLegacyDrawing(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AItem: TdxXLSXRelationship;
begin
  if Rels.FindByType(sdxXLSXCommentsRelationship, AItem) then
    ExecuteSubTask(TdxXLSXCommentsReader.Create(AItem.Target, View, Owner));
  if Rels.Find(AReader.GetAttribute(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, ''), AItem) then
    ExecuteSubTask(TdxXLSXCommentContainersReader.Create(AItem.Target, View, Owner));
  Result := nil;
end;

function TdxXLSXWorksheetReader.ProcessSheetFormat(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrDefaultColumnWidth, AValue) then
    View.Columns.DefaultSize := Owner.ColumnWidthHelper.WidthToPixels(StrToFloatDef(AValue, 0, dxInvariantFormatSettings))
  else
    View.Columns.DefaultSize := 3 + Owner.ColumnWidthHelper.CharsNumberToPixels(AReader.GetAttributeAsInteger(sdxXLSXAttrBaseColumnWidth, 8));

  if AReader.GetAttributeAsBoolean(sdxXLSXAttrCustomHeight, True) then
    View.Rows.DefaultSize := TdxValueUnitsHelper.PointsToPixels(AReader.GetAttributeAsSingle(sdxXLSXAttrDefaultRowHeight));

  Result := nil;
end;

procedure TdxXLSXWorksheetReader.ReadDrawings;
var
  AItem: TdxXLSXRelationship;
  I: Integer;
begin
  for I := 0 to Rels.Count - 1 do
  begin
    AItem := Rels[I];
    if AItem.TargetType = sdxXLSXDrawingRelationship then
      ExecuteSubTask(TdxXLSXDrawingReader.Create(AItem.Target, Owner, View));
  end;
end;

{ TdxXLSXContentTypeIndexReader }

constructor TdxXLSXContentTypeIndexReader.Create(AOwner: TdxSpreadSheetXLSXReader; AIndex: TdxStringsDictionary);
begin
  inherited Create(sdxXLSXContentTypeFileName, AOwner);
  FIndex := AIndex;
  Handlers.Add(sdxXLSXNodeOverride, ProcessOverrideType);
end;

function TdxXLSXContentTypeIndexReader.ProcessOverrideType(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FIndex.AddOrSetValue(AReader.GetAttribute(sdxXLSXAttrPartName), AReader.GetAttribute(sdxXLSXAttrContentType));
  Result := nil;
end;

{ TdxXLSXRelationshipsReader }

constructor TdxXLSXRelationshipsReader.Create(
  const ARootPath, AFileName: string; ATarget: TdxXLSXRelationships; AOwner: TdxSpreadSheetXLSXReader);
begin
  inherited Create(AFileName, AOwner);
  FTarget := ATarget;
  FRootPath := ARootPath;
  Handlers.Add(sdxXLSXNodeRelationship, ProcessRelationship);
end;

function TdxXLSXRelationshipsReader.GetFileRelationships: TdxXLSXRelationships;
begin
  Result := TdxXLSXRelationships.Create;
end;

function TdxXLSXRelationshipsReader.ProcessRelationship(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AFileName: string;
  AId: string;
  AMode: string;
  AType: string;
begin
  AFileName := AReader.GetAttribute(sdxXLSXAttrTarget);
  AFileName := TdxZIPPathHelper.EncodePath(AFileName); 
  AMode := AReader.GetAttribute(sdxXLSXAttrTargetMode);
  AType := AReader.GetAttribute(sdxXLSXAttrType);
  AId := AReader.GetAttribute(sdxXLSXAttrId);

  if not dxSameText(AMode, sdxXLSXValueTargetModeExternal) and (AType <> sdxXLSXHyperlinkRelationship) then
    AFileName := TdxZIPPathHelper.AbsoluteFileName(FRootPath, AFileName);
  FTarget.AddOrUpdate(AId, TdxZIPPathHelper.ExpandFileName(AFileName), AType, AMode);

  Result := nil;
end;

end.
