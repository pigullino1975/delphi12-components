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

unit dxSpreadSheetFormatXMLSS; // for internal use

{$I cxVer.Inc}

interface

uses
  UITypes,
  Windows, Types, SysUtils, Classes, Graphics, Generics.Defaults, Generics.Collections,
  dxCore, dxXMLDoc, dxHashUtils, dxCoreGraphics, cxGraphics, cxGeometry, cxClasses, dxTypeHelpers,
  dxSpreadSheetCore, dxSpreadSheetClasses, dxSpreadSheetUtils, dxSpreadSheetContainers, dxSpreadSheetTypes,
  dxSpreadSheetGraphics, dxSpreadSheetCoreStyles, dxSpreadSheetFormatUtils,
  dxXMLWriter, dxXMLReader, dxXMLReaderUtils;

type
  TdxSpreadSheetXMLSSReader = class;

  { TdxSpreadSheetXMLSSReaderSettings }

  TdxSpreadSheetXMLSSReaderSettings = record
    Options: TdxSpreadSheetClipboardPasteOptions;
    TargetAnchor: TPoint;
    TargetView: TdxSpreadSheetTableView;
  end;

  { TdxSpreadSheetXMLSSReaderStylesMap }

  TdxSpreadSheetXMLSSReaderStylesMap = class(TDictionary<string, TdxSpreadSheetCellStyleHandle>)
  protected
    procedure ValueNotify(const Value: TdxSpreadSheetCellStyleHandle; Action: TCollectionNotification); override;
  end;

  { TdxSpreadSheetXMLSSReader }

  TdxSpreadSheetXMLSSReader = class(TdxSpreadSheetCustomReader)
  strict private
    FDocumentHandler: TdxXMLDocumentHandler;
    FFormulasRefs: TdxSpreadSheetFormulaAsTextInfoList;
    FNumberFormatMap: TDictionary<string, Variant>;
    FSettings: TdxSpreadSheetXMLSSReaderSettings;
    FStyles: TdxSpreadSheetXMLSSReaderStylesMap;
  protected
    function CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper; override;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    destructor Destroy; override;
    class function GetDataArea(AStream: TStream): TRect;
    procedure AfterConstruction; override;
    procedure ReadData; override;
    //
    property FormulasRefs: TdxSpreadSheetFormulaAsTextInfoList read FFormulasRefs;
    property NumberFormatMap: TDictionary<string, Variant> read FNumberFormatMap;
    property Settings: TdxSpreadSheetXMLSSReaderSettings read FSettings write FSettings;
    property Styles: TdxSpreadSheetXMLSSReaderStylesMap read FStyles;
  end;

  { TdxSpreadSheetXMLSSWriter }

  TdxSpreadSheetXMLSSWriter = class(TdxSpreadSheetCustomWriter)
  strict private
    FStyles: TdxHashTableItemList;
  protected
    function CanWriteFormula(AFormula: TdxSpreadSheetFormula): Boolean; virtual;
    function CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper; override;
    function GetActualAreaHeight(AView: TdxSpreadSheetTableView; const AArea: TRect): Integer;
    function GetActualAreaWidth(AView: TdxSpreadSheetTableView; const AArea: TRect): Integer;
    function GetCellStyleHandle(ACell: TdxSpreadSheetCell; const AMergedArea: TRect): TdxSpreadSheetCellStyleHandle;
    function GetStyleId(AHandle: TdxSpreadSheetCellStyleHandle): string;
    function GetStyleIndex(AHandle: TdxSpreadSheetCellStyleHandle): Integer;
    procedure PopulateStyles(AItems: TdxSpreadSheetTableItems; AStartIndex, AFinishIndex: Integer); overload;
    procedure PopulateStyles(AView: TdxSpreadSheetTableView; const AArea: TRect); overload;
    procedure PopulateStyles; overload; virtual;
    procedure RegisterCellStyle(AHandle: TdxSpreadSheetCellStyleHandle);
    procedure WriteCell(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView;
      ACell: TdxSpreadSheetCell; ACellIndex: Integer; const AMergedArea: TRect);
    procedure WriteCellData(AWriter: TdxXmlWriter; ACell: TdxSpreadSheetCell);
    procedure WriteColumns(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView; AArea: TRect);
    procedure WriteComment(AWriter: TdxXmlWriter; AComment: TdxSpreadSheetCommentContainer);
    procedure WriteFormattedText(AWriter: TdxXmlWriter; const AText: string; AFont: TdxSpreadSheetFontHandle);
    procedure WriteNames(AWriter: TdxXmlWriter; AScope: TdxSpreadSheetCustomView); virtual;
    procedure WriteRowCells(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView; const AArea: TRect; ARow: TdxSpreadSheetTableRow);
    procedure WriteRows(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView; const AArea: TRect);
    procedure WriteString(AWriter: TdxXmlWriter; AString: TdxSpreadSheetSharedString);
    procedure WriteStyle(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetCellStyleHandle; AStyleID: Integer);
    procedure WriteStyleAlignment(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetCellStyleHandle);
    procedure WriteStyleBorders(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetBordersHandle);
    procedure WriteStyleBrush(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetBrushHandle);
    procedure WriteStyleFont(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetFontHandle);
    procedure WriteStyleNumberFormat(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetFormatHandle);
    procedure WriteView(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView; const AArea: TRect);
    procedure WriteViews(AWriter: TdxXmlWriter); virtual;
    //
    property Styles: TdxHashTableItemList read FStyles;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    destructor Destroy; override;
    procedure WriteData; override;
  end;

implementation

uses
  dxSpreadSheetHyperlinks, dxSpreadSheetNumberFormat, Variants, dxSpreadSheetStyles, dxStringHelper,
  dxSpreadSheetCoreHelpers;

const
  dxThisUnitName = 'dxSpreadSheetFormatXMLSS';

const
  sHTMLAttrColor = 'html:Color';
  sHTMLAttrFace = 'html:Face';
  sHTMLAttrSize = 'html:Size';

  sXMLSSDefaultStyleID = 'Default';

  sXMLSSNamespaceOffice = 'o';
  sXMLSSNamespaceHTML = 'html';
  sXMLSSNamespaceExcel = 'x';
  sXMLSSNamespaceSpreadSheet = 'ss';

  sXMLSSAttrArrayRange = 'ArrayRange';
  sXMLSSAttrAuthor = 'Author';
  sXMLSSAttrAutoFitHeight = 'AutoFitHeight';
  sXMLSSAttrAutoFitWidth = 'AutoFitWidth';
  sXMLSSAttrBold = 'Bold';
  sXMLSSAttrDefaultColumnWidth = 'DefaultColumnWidth';
  sXMLSSAttrDefaultRowHeight = 'DefaultRowHeight';
  sXMLSSAttrExpandedColumnCount = 'ExpandedColumnCount';
  sXMLSSAttrExpandedRowCount = 'ExpandedRowCount';
  sXMLSSAttrFontName = 'FontName';
  sXMLSSAttrFormat = 'Format';
  sXMLSSAttrFormula = 'Formula';
  sXMLSSAttrHeight = 'Height';
  sXMLSSAttrHorizontal = 'Horizontal';
  sXMLSSAttrHRef = 'HRef';
  sXMLSSAttrID = 'ID';
  sXMLSSAttrIndent = 'Indent';
  sXMLSSAttrIndex = 'Index';
  sXMLSSAttrItalic = 'Italic';
  sXMLSSAttrLineStyle = 'LineStyle';
  sXMLSSAttrMergedAcross = 'MergeAcross';
  sXMLSSAttrMergedDown = 'MergeDown';
  sXMLSSAttrName = 'Name';
  sXMLSSAttrParent = 'Parent';
  sXMLSSAttrPattern = 'Pattern';
  sXMLSSAttrPatternColor = 'PatternColor';
  sXMLSSAttrPosition = 'Position';
  sXMLSSAttrProtected = 'Protected';
  sXMLSSAttrRefersTo = 'RefersTo';
  sXMLSSAttrShowAlways = 'ShowAlways';
  sXMLSSAttrShrinkToFit = 'ShrinkToFit';
  sXMLSSAttrSpan = 'Span';
  sXMLSSAttrStrikeThrough = 'StrikeThrough';
  sXMLSSAttrStyleID = 'StyleID';
  sXMLSSAttrType = 'Type';
  sXMLSSAttrUnderline = 'Underline';
  sXMLSSAttrVertical = 'Vertical';
  sXMLSSAttrWeight = 'Weight';
  sXMLSSAttrWidth = 'Width';
  sXMLSSAttrWrapText = 'WrapText';

  sXMLSSAttrHRefScreenTip = 'HRefScreenTip';
  sXMLSSAttrCharset = 'CharSet';

  sXMLSSAttrColor = 'Color';
  sXMLSSAttrFace = 'Face';
  sXMLSSAttrSize = 'Size';

  sXMLSSNodeAlignment = 'Alignment';
  sXMLSSNodeBorder = 'Border';
  sXMLSSNodeBorders = 'Borders';
  sXMLSSNodeCell = 'Cell';
  sXMLSSNodeColumn = 'Column';
  sXMLSSNodeComment = 'Comment';
  sXMLSSNodeData = 'Data';
  sXMLSSNodeFont = 'Font';
  sXMLSSNodeInterior = 'Interior';
  sXMLSSNodeNamedRange = 'NamedRange';
  sXMLSSNodeNames = 'Names';
  sXMLSSNodeNumberFormat = 'NumberFormat';
  sXMLSSNodeProtection = 'Protection';
  sXMLSSNodeRow = 'Row';
  sXMLSSNodeStyle = 'Style';
  sXMLSSNodeStyles = 'Styles';
  sXMLSSNodeTable = 'Table';
  sXMLSSNodeWorkbook = 'Workbook';
  sXMLSSNodeWorksheet = 'Worksheet';

  sXMLSSStyleNameTemplate = 's%d';
  sXMLSSValueSingle = 'Single';
  sXMLSSDataTypeBoolean = 'Boolean';
  sXMLSSDataTypeDateTime = 'DateTime';
  sXMLSSDataTypeError = 'Error';
  sXMLSSDataTypeNumber = 'Number';
  sXMLSSDataTypeString = 'String';

type
  TdxSpreadSheetAccess = class(TdxCustomSpreadSheet);
  TdxSpreadSheetCellAccess = class(TdxSpreadSheetCell);
  TdxSpreadSheetCellDataFormatAccess = class(TdxSpreadSheetCellDataFormat);
  TdxSpreadSheetCommentContainerAccess = class(TdxSpreadSheetCommentContainer);
  TdxSpreadSheetFormulaAccess = class(TdxSpreadSheetFormula);
  TdxSpreadSheetTableColumnsAccess = class(TdxSpreadSheetTableColumns);
  TdxSpreadSheetTableRowAccess = class(TdxSpreadSheetTableRow);
  TdxSpreadSheetTableRowCellsAccess = class(TdxSpreadSheetTableRowCells);
  TdxSpreadSheetTableRowsAccess = class(TdxSpreadSheetTableRows);

  TdxXMLSSLineStyleInfo = record
    Name: string;
    Weight: Integer;
  end;

const
  HTMLNamespace = 'http://www.w3.org/TR/REC-html40';
  FontStyleMap: array[TFontStyle] of AnsiString = ('B', 'I', 'U', 'S');
  BordersNames: array[TcxBorder] of string = (
    'Left', 'Top', 'Right', 'Bottom'
  );
  CellDataTypeMap: array[TdxSpreadSheetCellDataType] of string = ('', sXMLSSDataTypeBoolean, sXMLSSDataTypeError,
    sXMLSSDataTypeNumber, sXMLSSDataTypeNumber, sXMLSSDataTypeDateTime, sXMLSSDataTypeNumber, sXMLSSDataTypeString,
    sXMLSSDataTypeString
  );
  CellFillStyleNames: array[TdxSpreadSheetCellFillStyle] of string = (
    'Solid', 'Gray75', 'Gray50', 'Gray25', 'Gray125', 'Gray0625', 'HorzStripe', 'VertStripe', 'ReverseDiagStripe',
    'DiagStripe', 'DiagCross', 'ThickDiagCross', 'ThinHorzStripe', 'ThinVertStripe', 'ThinReverseDiagStripe',
    'ThinDiagStripe', 'ThinHorzCross', 'ThinDiagCross'
  );
  HorzAttrValuesMap: array[TdxSpreadSheetDataAlignHorz] of string = (
    'Automatic', 'Left', 'Center', 'Right', 'Fill', 'Justify', 'Distributed'
  );
  VertAttrValuesMap: array[TdxSpreadSheetDataAlignVert] of string = (
    'Top', 'Center', 'Bottom', 'Justify', 'Distributed'
  );
  LineStyleMap: array[TdxSpreadSheetCellBorderStyle] of TdxXMLSSLineStyleInfo = (
    (Name: ''; Weight: 1),
    (Name: 'Continuous'; Weight: 0),
    (Name: 'Dot'; Weight: 1),
    (Name: 'DashDotDot'; Weight: 1),
    (Name: 'DashDot'; Weight: 1),
    (Name: 'Dash'; Weight: 1),
    (Name: 'Continuous'; Weight: 1),
    (Name: 'DashDotDot'; Weight: 2),
    (Name: 'SlantDashDot'; Weight: 2),
    (Name: 'DashDot'; Weight: 2),
    (Name: 'Dash'; Weight: 2),
    (Name: 'Continuous'; Weight: 2),
    (Name: 'Continuous'; Weight: 3),
    (Name: 'Double'; Weight: 3),
    (Name: 'None'; Weight: 0)
  );

type
  TdxXMLSSNodeWorksheetTableItemHandlerClass = class of TdxXMLSSNodeWorksheetTableItemHandler;
  TdxXMLSSNodeWorksheetTableItemHandler = class;

  { TdxXMLSSFormattedString }

  TdxXMLSSFormattedString = class(TStringBuilder)
  strict private
    FRuns: TdxSpreadSheetFormattedSharedStringRuns;
  public
    constructor Create;
    destructor Destroy; override;
    //
    property Runs: TdxSpreadSheetFormattedSharedStringRuns read FRuns;
  end;

  { TdxXMLSSNodeHandler }

  TdxXMLSSNodeHandler = class(TdxXMLNodeHandler)
  strict private
    function GetOwner: TdxSpreadSheetXMLSSReader; inline;
  public
    property Owner: TdxSpreadSheetXMLSSReader read GetOwner;
  end;

  { TdxXMLSSNodeDefinedNamesHandler }

  TdxXMLSSNodeDefinedNamesHandler = class(TdxXMLSSNodeHandler)
  strict private
    FView: TdxSpreadSheetCustomView;

    function ProcessDefinedName(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner: TObject; AData: TObject); override;
  end;

  { TdxXMLSSFormattedStringHandler }

  TdxXMLSSFormattedStringHandler = class(TdxXMLSSNodeHandler)
  strict private
    FData: TdxXMLSSFormattedString;
    FDefaultFont: TdxSpreadSheetFontHandle;
    FStack: TdxHashTableItemList;

    function ModifyFont: TdxSpreadSheetFontHandle;
    function ProcessFont(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessFontStyle(const AData: TObject): TdxXMLNodeHandler;
  public
    constructor Create(AOwner: TdxSpreadSheetXMLSSReader;
      AData: TdxXMLSSFormattedString; ADefaultFont: TdxSpreadSheetFontHandle); reintroduce;
    destructor Destroy; override;
    procedure OnEnd; override;
    procedure OnText(const AReader: TdxXmlReader); override;
    //
    property Data: TdxXMLSSFormattedString read FData;
  end;

  { TdxXMLSSNodeStyleHandler }

  TdxXMLSSNodeStyleHandler = class(TdxXMLSSNodeHandler)
  strict private const
    DefaultFontSize = 10;
  strict private
    procedure ModifyState(AStateIndex: TdxSpreadSheetCellState; AValue: Boolean);
    procedure ModifyStyle(var AStyles: TFontStyles; AStyle: TFontStyle; AValue: Boolean);
    function ProcessAlignment(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessBrush(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessFont(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessNumberFormat(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessProtection(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    FStyle: TdxSpreadSheetCellStyleHandle;
    FStyleId: string;
    FStyles: TdxSpreadSheetXMLSSReaderStylesMap;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXMLSSNodeStyleBordersHandler }

  TdxXMLSSNodeStyleBordersHandler = class(TdxXMLSSNodeHandler)
  strict private
    FBorders: TdxSpreadSheetBordersHandle;
    FStyle: TdxSpreadSheetCellStyleHandle;

    function ConvertBorderStyle(const ALineStyle: string; AWeight: Integer): TdxSpreadSheetCellBorderStyle;
    function ProcessBorder(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function TryStringToBorder(const S: string; out ABorder: TcxBorder): Boolean;
  public
    constructor Create(AOwner: TObject; AData: TObject); override;
    procedure BeforeDestruction; override;
  end;

  { TdxXMLSSNodeStylesHandler }

  TdxXMLSSNodeStylesHandler = class(TdxXMLSSNodeHandler)
  public
    constructor Create(AOwner: TObject; AData: TObject); override;
  end;

  { TdxXMLSSNodeWorkbookHandler }

  TdxXMLSSNodeWorkbookHandler = class(TdxXMLSSNodeHandler)
  strict private
    FViewIndex: Integer;

    function CreateWorksheetHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    procedure AfterConstruction; override;
  end;

  { TdxXMLSSNodeWorksheetHandler }

  TdxXMLSSNodeWorksheetHandler = class(TdxXMLSSNodeHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXMLSSNodeWorksheetTableHandler }

  TdxXMLSSNodeWorksheetTableHandler = class(TdxXMLSSNodeWorksheetHandler)
  strict private
    FCurrentColumnIndex: Integer;
    FCurrentRowIndex: Integer;
  protected
    FAnchors: TPoint;
    FMergeMode: Boolean;
    FMergeOptions: TdxSpreadSheetClipboardPasteOptions;
    FView: TdxSpreadSheetTableView;

    function TestOption(AOption: TdxSpreadSheetClipboardPasteOption): Boolean; inline;
    function CreateColumnHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function CreateItemHandler(const AReader: TdxXmlReader;
      AItems: TdxSpreadSheetTableItems; var AIndex: Integer; AAnchor: Integer;
      AHandlerClass: TdxXMLSSNodeWorksheetTableItemHandlerClass): TdxXMLNodeHandler;
    function CreateRowHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure AfterConstruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXMLSSNodeWorksheetTableCustomItemHandler }

  TdxXMLSSNodeWorksheetTableCustomItemHandler = class(TdxXMLNodeHandler)
  strict private
    function GetOwner: TdxXMLSSNodeWorksheetTableHandler;
  public
    property Owner: TdxXMLSSNodeWorksheetTableHandler read GetOwner;
  end;

  { TdxXMLSSNodeWorksheetTableItemHandler }

  TdxXMLSSNodeWorksheetTableItemHandler = class(TdxXMLSSNodeWorksheetTableCustomItemHandler)
  strict private
    FItem: TdxSpreadSheetTableItem;
    FSpan: Integer;
  public
    constructor Create(AOwner: TObject; AItem: TdxSpreadSheetTableItem; ASpan: Integer); reintroduce;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    procedure OnEnd; override;
    //
    property Item: TdxSpreadSheetTableItem read FItem;
  end;

  { TdxXMLSSNodeWorksheetTableCellHandler }

  TdxXMLSSNodeWorksheetTableCellHandler = class(TdxXMLSSNodeWorksheetTableCustomItemHandler)
  strict private
    FCell: TdxSpreadSheetCell;
    FColumnIndex: Integer;
    FExpandSize: TSize;
    FRow: TdxSpreadSheetTableRow;
    FView: TdxSpreadSheetTableView;

    procedure ApplyCellStyle;
    procedure ApplyCellValue;
    procedure CreateComment;
    procedure CreateHyperlink;
    function GetCell: TdxSpreadSheetCell; inline;
    function GetFont: TdxSpreadSheetFontHandle;
    function IsBlank: Boolean;
    function ProcessNodeData(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    // Comment
    FComment: TdxXMLSSFormattedString;
    FCommentAuthor: string;
    FCommentVisible: Boolean;
    // Style
    FStyle: TdxSpreadSheetCellStyleHandle;
    // Values
    FHyperlinkRef: string;
    FHyperlinkScreenTip: string;
    FValue: TdxXMLSSFormattedString;
    FValueType: TdxSpreadSheetCellDataType;
    // Values+Formulas
    FFormula: string;
    FFormulaArrayRange: string;
  public
    constructor Create(AOwner: TObject; ARow: TdxSpreadSheetTableRow; AColumnIndex: Integer; const AExpandSize: TSize); reintroduce;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    procedure OnEnd; override;
    //
    property View: TdxSpreadSheetTableView read FView;
  end;

  { TdxXMLSSNodeWorksheetTableCellCommentHandler }

  TdxXMLSSNodeWorksheetTableCellCommentHandler = class(TdxXMLSSNodeWorksheetTableCustomItemHandler)
  strict private
    FData: TdxXMLSSNodeWorksheetTableCellHandler;

    function ProcessData(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner: TObject; AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXMLSSNodeWorksheetTableColumnHandler }

  TdxXMLSSNodeWorksheetTableColumnHandler = class(TdxXMLSSNodeWorksheetTableItemHandler)
  public
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXMLSSNodeWorksheetTableRowHandler }

  TdxXMLSSNodeWorksheetTableRowHandler = class(TdxXMLSSNodeWorksheetTableItemHandler)
  strict private
    FColumnIndex: Integer;

    function CreateCellHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    procedure AfterConstruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

function DecodeColor(S: string): TColor;
begin
  Result := dxAlphaColorToColor(TdxAlphaColors.FromHexCode(S));
end;

function DecodeSize(const AValue: string): Integer;
begin
  Result := Round(StrToFloatDef(AValue, 0, dxInvariantFormatSettings) / 0.75);
end;

function EncodeColor(AValue: TColor): string;
begin
  Result := TdxAlphaColors.ToHexCode(dxColorToAlphaColor(AValue), False, '#');
end;

function EncodeSize(AValue: Integer): Double;
begin
  Result := AValue * 0.75;
end;

function StringToAlignHorz(const S: string): TdxSpreadSheetDataAlignHorz;
var
  I: TdxSpreadSheetDataAlignHorz;
begin
  for I := Low(TdxSpreadSheetDataAlignHorz) to High(TdxSpreadSheetDataAlignHorz) do
  begin
    if S = HorzAttrValuesMap[I] then
      Exit(I);
  end;
  if S = 'JustifyDistributed' then
    Result := ssahJustify
  else
    Result := ssahGeneral;
end;

function StringToAlignVert(const S: string): TdxSpreadSheetDataAlignVert;
var
  I: TdxSpreadSheetDataAlignVert;
begin
  for I := Low(TdxSpreadSheetDataAlignVert) to High(TdxSpreadSheetDataAlignVert) do
  begin
    if S = VertAttrValuesMap[I] then
      Exit(I);
  end;
  if S = 'JustifyDistributed' then
    Result := ssavJustify
  else
    Result := ssavBottom;
end;

function StringToCellDataType(const S: string): TdxSpreadSheetCellDataType;
var
  I: TdxSpreadSheetCellDataType;
begin
  for I := Low(TdxSpreadSheetCellDataType) to High(TdxSpreadSheetCellDataType) do
  begin
    if CellDataTypeMap[I] = S then
      Exit(I);
  end;
  Result := cdtBlank;
end;

function StringToCellFillStyle(const S: string): TdxSpreadSheetCellFillStyle;
var
  I: TdxSpreadSheetCellFillStyle;
begin
  for I := Low(TdxSpreadSheetCellFillStyle) to High(TdxSpreadSheetCellFillStyle) do
    if CellFillStyleNames[I] = S then
      Exit(I);
  Result := sscfsSolid;
end;

{ TdxXMLSSFormattedString }

constructor TdxXMLSSFormattedString.Create;
begin
  inherited;
  FRuns := TdxSpreadSheetFormattedSharedStringRuns.Create;
end;

destructor TdxXMLSSFormattedString.Destroy;
begin
  FreeAndNil(FRuns);
  inherited;
end;

{ TdxSpreadSheetXMLSSReaderStylesMap }

procedure TdxSpreadSheetXMLSSReaderStylesMap.ValueNotify(
  const Value: TdxSpreadSheetCellStyleHandle; Action: TCollectionNotification);
begin
  case Action of
    cnAdded:
      Value.AddRef;
    cnRemoved:
      Value.Release;
  end;
end;

{ TdxSpreadSheetXMLSSReader }

constructor TdxSpreadSheetXMLSSReader.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  inherited;
  FStyles := TdxSpreadSheetXMLSSReaderStylesMap.Create;
  FDocumentHandler := TdxXMLDocumentHandler.Create(AStream, soReference, Self, ProgressHelper);
  FFormulasRefs := TdxSpreadSheetFormulaAsTextInfoList.Create(SpreadSheet);
  FNumberFormatMap := TDictionary<string, Variant>.Create;
end;

destructor TdxSpreadSheetXMLSSReader.Destroy;
begin
  FreeAndNil(FNumberFormatMap);
  FreeAndNil(FDocumentHandler);
  FreeAndNil(FFormulasRefs);
  FreeAndNil(FStyles);
  inherited;
end;

class function TdxSpreadSheetXMLSSReader.GetDataArea(AStream: TStream): TRect;
var
  AReader: TdxXmlReader;
  ASettings: TdxXmlReaderSettings;
  AValue: string;
begin
  Result := cxNullRect;
  try
    ASettings := TdxXmlReaderSettings.Create;
    try
      AReader := ASettings.CreateReader(AStream);
      try
        while AReader.Read do
          if (AReader.NodeType = TdxXmlNodeType.Element) and (AReader.Name = sXMLSSNodeTable) then
          begin
            if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrExpandedColumnCount, '', AValue) then
              Result.Right := StrToIntDef(AValue, 1) - 1;
            if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrExpandedRowCount, '', AValue) then
              Result.Bottom := StrToIntDef(AValue, 1) - 1;
          end;
      finally
        AReader.Free;
      end;
    finally
      ASettings.Free;
    end;
  except
    // do nothing
  end;
end;

procedure TdxSpreadSheetXMLSSReader.AfterConstruction;
begin
  inherited;

  FDocumentHandler.Handlers.Add(sXMLSSNodeWorkbook, TdxXMLSSNodeWorkbookHandler);

  FNumberFormatMap.Add('General Date', $16);
  FNumberFormatMap.Add('Long Date', $0F);
  FNumberFormatMap.Add('Medium Date', $0F);
  FNumberFormatMap.Add('Short Date', $0E);
  FNumberFormatMap.Add('Long Time', $13);
  FNumberFormatMap.Add('Medium Time', $12);
  FNumberFormatMap.Add('Short Time', $14);
  FNumberFormatMap.Add('Currency', $08);
  FNumberFormatMap.Add('Euro Currency', '[$€-2]\ ###,000_);[Red]\([$€-2]\ ###,000\)');
  FNumberFormatMap.Add('Fixed', $02);
  FNumberFormatMap.Add('Standard', $04);
  FNumberFormatMap.Add('Percent', $0A);
  FNumberFormatMap.Add('Scientific', $0B);
  FNumberFormatMap.Add('Yes/No', '"Yes";"Yes";"No"');
  FNumberFormatMap.Add('True/False', '"True";"True";"False"');
  FNumberFormatMap.Add('On/Off', '"On";"On";"Off"');
end;

procedure TdxSpreadSheetXMLSSReader.ReadData;
var
  ASavedFormatSettings: TFormatSettings;
  ASavedR1C1Reference: Boolean;
begin
  ASavedR1C1Reference := SpreadSheet.OptionsView.R1C1Reference;
  ASavedFormatSettings := SpreadSheet.FormulaController.FormatSettings.Data;
  SpreadSheet.BeginUpdate;
  try
    SpreadSheet.OptionsView.R1C1Reference := True;
    dxGetLocaleFormatSettings(dxGetInvariantLocaleID, SpreadSheet.FormulaController.FormatSettings.Data);
    FDocumentHandler.Run;
    FormulasRefs.ResolveReferences;
  finally
    SpreadSheet.FormulaController.FormatSettings.Data := ASavedFormatSettings;
    SpreadSheet.OptionsView.R1C1Reference := ASavedR1C1Reference;
    SpreadSheet.EndUpdate;
  end;
end;

function TdxSpreadSheetXMLSSReader.CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper;
begin
  Result := TdxSpreadSheetCustomFilerProgressHelper.Create(Self, 1);
end;

{ TdxSpreadSheetXMLSSWriter }

constructor TdxSpreadSheetXMLSSWriter.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  inherited;
  FStyles := TdxHashTableItemList.Create;
end;

destructor TdxSpreadSheetXMLSSWriter.Destroy;
begin
  FreeAndNil(FStyles);
  inherited;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteData;
var
  ASavedFormatSettings: TFormatSettings;
  ASavedR1C1Reference: Boolean;
  AWriter: TdxXmlWriter;
  AWriterSettings: TdxXmlWriterSettings;
  I: Integer;
begin
  ASavedR1C1Reference := SpreadSheet.OptionsView.R1C1Reference;
  ASavedFormatSettings := SpreadSheet.FormulaController.FormatSettings.Data;
  SpreadSheet.BeginUpdate;
  try
    SpreadSheet.OptionsView.R1C1Reference := True;
    dxGetLocaleFormatSettings(dxGetInvariantLocaleID, SpreadSheet.FormulaController.FormatSettings.Data);

    AWriterSettings := TdxXmlWriterSettings.Create;
    AWriterSettings.CheckCharacters := False;
    AWriterSettings.EncodeInvalidXmlCharAsUCS2 := True;

    AWriter := TdxXmlWriter.Create(Stream, AWriterSettings);
    try
      AWriter.WriteStartElement(sXMLSSNodeWorkbook);
      AWriter.WriteAttributeString('xmlns', 'urn:schemas-microsoft-com:office:spreadsheet');
      AWriter.WriteAttributeString('xmlns', sXMLSSNamespaceOffice, '', 'urn:schemas-microsoft-com:office:office');
      AWriter.WriteAttributeString('xmlns', sXMLSSNamespaceExcel, '', 'urn:schemas-microsoft-com:office:excel');
      AWriter.WriteAttributeString('xmlns', sXMLSSNamespaceSpreadSheet, '', 'urn:schemas-microsoft-com:office:spreadsheet');
      AWriter.WriteAttributeString('xmlns', sXMLSSNamespaceHTML, '', HTMLNamespace);

      PopulateStyles;
      AWriter.WriteStartElement(sXMLSSNodeStyles);
      for I := 0 to Styles.Count - 1 do
        WriteStyle(AWriter, Styles[I], I);
      AWriter.WriteEndElement;

      WriteNames(AWriter, nil);
      WriteViews(AWriter);

      AWriter.WriteEndElement;
      AWriter.Flush;
    finally
      AWriter.Free;
    end;

  finally
    SpreadSheet.FormulaController.FormatSettings.Data := ASavedFormatSettings;
    SpreadSheet.OptionsView.R1C1Reference := ASavedR1C1Reference;
    SpreadSheet.CancelUpdate;
  end;
end;

function TdxSpreadSheetXMLSSWriter.CanWriteFormula(AFormula: TdxSpreadSheetFormula): Boolean;
begin
  Result := True;
end;

function TdxSpreadSheetXMLSSWriter.CreateProgressHelper: TdxSpreadSheetCustomFilerProgressHelper;
begin
  Result := TdxSpreadSheetCustomFilerProgressHelper.Create(Self, 1);
end;

function TdxSpreadSheetXMLSSWriter.GetActualAreaHeight(AView: TdxSpreadSheetTableView; const AArea: TRect): Integer;
begin
  Result := TdxSpreadSheetTableRowsAccess(AView.Rows).GetItemVisibleCount(AArea.Top, AArea.Bottom);
end;

function TdxSpreadSheetXMLSSWriter.GetActualAreaWidth(AView: TdxSpreadSheetTableView; const AArea: TRect): Integer;
begin
  Result := TdxSpreadSheetTableColumnsAccess(AView.Columns).GetItemVisibleCount(AArea.Left, AArea.Right);
end;

function TdxSpreadSheetXMLSSWriter.GetCellStyleHandle(
  ACell: TdxSpreadSheetCell; const AMergedArea: TRect): TdxSpreadSheetCellStyleHandle;
var
  ABorders: TdxSpreadSheetBordersHandle;
  ABottomRightCellStyle: TdxSpreadSheetCellStyleHandle;
begin
  Result := ACell.StyleHandle;
  if not dxSpreadSheetIsSingleCellArea(AMergedArea) then
  begin
    ABottomRightCellStyle := ACell.View.CreateCell(AMergedArea.Bottom, AMergedArea.Right).StyleHandle;
    if Result.Borders <> ABottomRightCellStyle.Borders then
    begin
      ABorders := Result.Borders.Clone;
      ABorders.BorderColor[bRight] := ABottomRightCellStyle.Borders.BorderColor[bRight];
      ABorders.BorderStyle[bRight] := ABottomRightCellStyle.Borders.BorderStyle[bRight];
      ABorders.BorderColor[bBottom] := ABottomRightCellStyle.Borders.BorderColor[bBottom];
      ABorders.BorderStyle[bBottom] := ABottomRightCellStyle.Borders.BorderStyle[bBottom];

      Result := Result.Clone;
      Result.Borders := SpreadSheet.CellStyles.Borders.AddBorders(ABorders);
      Result := SpreadSheet.CellStyles.AddStyle(Result);
    end;
  end;
end;

function TdxSpreadSheetXMLSSWriter.GetStyleId(AHandle: TdxSpreadSheetCellStyleHandle): string;
begin
  Result := Format(sXMLSSStyleNameTemplate, [GetStyleIndex(AHandle)]);
end;

function TdxSpreadSheetXMLSSWriter.GetStyleIndex(AHandle: TdxSpreadSheetCellStyleHandle): Integer;
begin
  Result := Styles.IndexOf(AHandle);
  if Result < 0 then
    raise EdxSpreadSheetError.Create('Style was not registered');
end;

procedure TdxSpreadSheetXMLSSWriter.PopulateStyles;
var
  AView: TdxSpreadSheetCustomView;
  I: Integer;
begin
  for I := 0 to SpreadSheet.SheetCount - 1 do
  begin
    AView := SpreadSheet.Sheets[I];
    if AView is TdxSpreadSheetTableView then
      PopulateStyles(TdxSpreadSheetTableView(AView), TdxSpreadSheetTableView(AView).Dimensions);
  end;
end;

procedure TdxSpreadSheetXMLSSWriter.PopulateStyles(AItems: TdxSpreadSheetTableItems; AStartIndex, AFinishIndex: Integer);
var
  AItem: TdxSpreadSheetTableItem;
begin
  AItem := AItems.First;
  while (AItem <> nil) and (AItem.Index < AStartIndex) do
    AItem := AItem.Next;
  while (AItem <> nil) and (AItem.Index <= AFinishIndex) do
  begin
    if not AItem.Style.IsDefault then
      RegisterCellStyle(AItem.Style.Handle);
    AItem := AItem.Next;
  end;
end;

procedure TdxSpreadSheetXMLSSWriter.PopulateStyles(AView: TdxSpreadSheetTableView; const AArea: TRect);
begin
  PopulateStyles(AView.Columns, AArea.Left, AArea.Right);
  PopulateStyles(AView.Rows, AArea.Top, AArea.Bottom);

  AView.ForEachCell(AArea,
    procedure (ACell: TdxSpreadSheetCell)
    var
      AMergedArea: TRect;
    begin
      AMergedArea := AView.MergedCells.ExpandArea(ACell.ColumnIndex, ACell.RowIndex);
      if (AMergedArea.Left = ACell.ColumnIndex) and (AMergedArea.Top = ACell.RowIndex) then
        RegisterCellStyle(GetCellStyleHandle(ACell, AMergedArea));
    end);
end;

procedure TdxSpreadSheetXMLSSWriter.RegisterCellStyle(AHandle: TdxSpreadSheetCellStyleHandle);
begin
  AHandle.AddRef;
  try
    if Styles.IndexOf(AHandle) < 0 then
      Styles.Add(AHandle);
  finally
    AHandle.Release;
  end;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteCell(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView;
  ACell: TdxSpreadSheetCell; ACellIndex: Integer; const AMergedArea: TRect);
var
  AAreaSize: Integer;
  AComment: TdxSpreadSheetCommentContainer;
  AFormula: TdxSpreadSheetFormula;
  AHyperlink: TdxSpreadSheetHyperlink;
begin
  AWriter.WriteStartElement(sXMLSSNodeCell);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrStyleID, '', GetStyleId(GetCellStyleHandle(ACell, AMergedArea)));
  AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrIndex, '', ACellIndex);

  AAreaSize := GetActualAreaWidth(AView, AMergedArea);
  if AAreaSize > 1 then
    AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrMergedAcross, '', AAreaSize - 1);

  AAreaSize := GetActualAreaHeight(AView, AMergedArea);
  if AAreaSize > 1 then
    AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrMergedDown, '', AAreaSize - 1);

  if ACell.DataType = cdtFormula then
  begin
    AFormula := ACell.AsFormula;
    if CanWriteFormula(AFormula) then
    begin
      if AFormula.IsArrayFormula then
      begin
        AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrArrayRange, '',
          dxReferenceToString(cxRect(0, 0, AFormula.ArrayFormulaSize.cx - 1, AFormula.ArrayFormulaSize.cy - 1), True));
      end;
      AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrFormula, '', AFormula.AsText);
    end;
  end;

  AHyperlink := AView.Hyperlinks.FindItem(ACell.RowIndex, ACell.ColumnIndex);
  if (AHyperlink <> nil) and (AHyperlink.ValueType <> hvtReference) then
  begin
    AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrHRef, '', AHyperlink.Value);
    AWriter.WriteAttributeString(sXMLSSNamespaceExcel, sXMLSSAttrHRefScreenTip, '', AHyperlink.ScreenTip);
  end;

  if ACell.DataType <> cdtBlank then
    WriteCellData(AWriter, ACell);

  if AView.Containers.FindCommentContainer(ACell, AComment) then
    WriteComment(AWriter, AComment);

  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteCellData(AWriter: TdxXmlWriter; ACell: TdxSpreadSheetCell);
var
  AActualDataType: TdxSpreadSheetCellDataType;
begin
  AActualDataType := ACell.DataType;
  if AActualDataType = cdtString then
  begin
    WriteString(AWriter, ACell.AsSharedString);
    Exit;
  end;

  if AActualDataType = cdtFormula then
  begin
    if TdxSpreadSheetFormulaAccess(ACell.AsFormula).ActualErrorCode <> ecNone then
      AActualDataType := cdtError
    else
      AActualDataType := dxGetDataTypeByVariantValue(ACell.AsVariant);
  end;

  AWriter.WriteStartElement(sXMLSSNodeData);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrType, '', CellDataTypeMap[AActualDataType]);
  case AActualDataType of
    cdtDateTime:
      AWriter.WriteValue(TdxXMLDateTime.Create(ACell.AsDateTime).ToString);
    cdtError:
      AWriter.WriteValue(dxSpreadSheetErrorCodeToString(ACell.AsError));
    cdtFloat, cdtCurrency:
      AWriter.WriteValue(FloatToStr(ACell.AsVariant, dxInvariantFormatSettings));
    cdtBoolean:
      AWriter.WriteValue(IntToStr(Ord(ACell.AsBoolean)));
  else
    AWriter.WriteValue(ACell.AsVariant);
  end;
  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteColumns(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView; AArea: TRect);
var
  AColumn: TdxSpreadSheetTableItem;
  AColumnOffset: Integer;
begin
  AColumnOffset := AArea.Left - 1;
  AColumn := AView.Columns.First;
  while (AColumn <> nil) and (AColumn.Index < AArea.Left) do
    AColumn := AColumn.Next;
  while (AColumn <> nil) and (AColumn.Index <= AArea.Right) do
  begin
    if AColumn.Visible then
    begin
      AWriter.WriteStartElement(sXMLSSNodeColumn);
      AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrIndex, '', AColumn.Index - AColumnOffset);
      AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrAutoFitWidth, '', 0);
      if not AColumn.Style.IsDefault then
        AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrStyleID, '', GetStyleId(AColumn.Style.Handle));
      if not AColumn.DefaultSize then
        AWriter.WriteAttributeFloat(sXMLSSNamespaceSpreadSheet, sXMLSSAttrWidth, '', EncodeSize(AColumn.Size));
      AWriter.WriteEndElement;
    end
    else
      Inc(AColumnOffset);

    AColumn := AColumn.Next;
  end;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteComment(AWriter: TdxXmlWriter; AComment: TdxSpreadSheetCommentContainer);
begin
  AWriter.WriteStartElement(sXMLSSNodeComment);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrAuthor, '', AComment.Author);
  AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrShowAlways, '', Ord(AComment.Visible));

  AWriter.WriteStartElement(sXMLSSNamespaceSpreadSheet, sXMLSSNodeData, '');
  AWriter.WriteAttributeString('xmlns', HTMLNamespace);
  WriteFormattedText(AWriter, AComment.TextBox.TextAsString, AComment.TextBox.Font.Handle);
  AWriter.WriteEndElement;

  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteFormattedText(
  AWriter: TdxXmlWriter; const AText: string; AFont: TdxSpreadSheetFontHandle);
var
  AStyle: TFontStyle;
begin
  if AFont <> nil then
  begin
    for AStyle := Low(TFontStyle) to High(TFontStyle) do
    begin
      if AStyle in AFont.Style then
        AWriter.WriteStartElement(dxAnsiStringToString(FontStyleMap[AStyle]));
    end;

    AWriter.WriteStartElement(sXMLSSNodeFont);
    AWriter.WriteAttributeString(sXMLSSNamespaceHTML, sXMLSSAttrFace, '', AFont.Name);
    AWriter.WriteAttributeInteger(sXMLSSNamespaceHTML, sXMLSSAttrSize, '', AFont.Size);
    AWriter.WriteAttributeString(sXMLSSNamespaceHTML, sXMLSSAttrColor, '', EncodeColor(AFont.Color));
    if AFont.Charset <> DEFAULT_CHARSET then
      AWriter.WriteAttributeInteger(sXMLSSNamespaceExcel, sXMLSSAttrCharset, '', AFont.Charset);
    AWriter.WriteValue(AText);
    AWriter.WriteEndElement;

    for AStyle := Low(TFontStyle) to High(TFontStyle) do
    begin
      if AStyle in AFont.Style then
        AWriter.WriteEndElement;
    end;
  end
  else
    AWriter.WriteValue(AText);
end;

procedure TdxSpreadSheetXMLSSWriter.WriteNames(AWriter: TdxXmlWriter; AScope: TdxSpreadSheetCustomView);
var
  ADefinedName: TdxSpreadSheetDefinedName;
  I: Integer;
begin
  if SpreadSheet.DefinedNames.Contains(AScope) then
  begin
    AWriter.WriteStartElement(sXMLSSNodeNames);
    for I := 0 to SpreadSheet.DefinedNames.Count - 1 do
    begin
      ADefinedName := SpreadSheet.DefinedNames[I];
      if ADefinedName.Scope = AScope then
      begin
        AWriter.WriteStartElement(sXMLSSNodeNamedRange);
        AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrName, '', ADefinedName.Caption);
        AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrRefersTo, '', ADefinedName.Reference);
        AWriter.WriteEndElement;
      end;
    end;
    AWriter.WriteEndElement;
  end;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteRowCells(AWriter: TdxXmlWriter;
  AView: TdxSpreadSheetTableView; const AArea: TRect; ARow: TdxSpreadSheetTableRow);
var
  ACell: TdxSpreadSheetCell;
  ACellIndex: Integer;
  ACellLocalIndex: Integer;
  AColumns: TdxSpreadSheetTableColumnsAccess;
  AMergedArea: TRect;
begin
  ACellLocalIndex := 1;
  ACellIndex := AArea.Left;
  AColumns := TdxSpreadSheetTableColumnsAccess(AView.Columns);

  ACell := ARow.FirstCell;
  while (ACell <> nil) and (ACell.ColumnIndex < AArea.Left) do
    ACell := ACell.Next;
  while (ACell <> nil) and (ACell.ColumnIndex <= AArea.Right) do
  begin
    while ACellIndex < ACell.ColumnIndex do
    begin
      if AColumns.GetItemVisible(ACellIndex) then
        Inc(ACellLocalIndex);
      Inc(ACellIndex);
    end;

    if AColumns.GetItemVisible(ACell.ColumnIndex) then
    begin
      AMergedArea := AView.MergedCells.ExpandArea(ACell.ColumnIndex, ACell.RowIndex);
      if (AMergedArea.Left = ACell.ColumnIndex) and (AMergedArea.Top = ACell.RowIndex) then
        WriteCell(AWriter, AView, ACell, ACellLocalIndex, AMergedArea);
      Inc(ACellLocalIndex);
    end;
    Inc(ACellIndex);

    ACell := ACell.Next;
  end;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteRows(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView; const AArea: TRect);
var
  APrevRowIndex: Integer;
  ARow: TdxSpreadSheetTableItem;
  ARowLocalIndex: Integer;
begin
  ProgressHelper.BeginStage(AArea.Height);
  try
    APrevRowIndex := AArea.Top - 1;
    ARowLocalIndex := 1;
    ARow := AView.Rows.First;
    while (ARow <> nil) and (ARow.Index < AArea.Top) do
      ARow := ARow.Next;
    while (ARow <> nil) and (ARow.Index <= AArea.Bottom) do
    begin
      Inc(ARowLocalIndex, ARow.Index - APrevRowIndex - 1);
      ProgressHelper.SetTaskNumber(ARowLocalIndex);
      APrevRowIndex := ARow.Index;

      if ARow.Visible then
      begin
        AWriter.WriteStartElement(sXMLSSNodeRow);
        if not ARow.Style.IsDefault then
        begin
          AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrStyleID, '',
            Format(sXMLSSStyleNameTemplate, [GetStyleIndex(ARow.Style.Handle)]));
        end;
        AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrIndex, '', ARowLocalIndex);
        if not ARow.DefaultSize then
          AWriter.WriteAttributeFloat(sXMLSSNamespaceSpreadSheet, sXMLSSAttrHeight, '', EncodeSize(ARow.Size));
        AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrAutoFitHeight, '',
          Ord(not TdxSpreadSheetTableRowAccess(ARow).IsCustomSize));
        WriteRowCells(AWriter, AView, AArea, TdxSpreadSheetTableRow(ARow));
        AWriter.WriteEndElement;
        Inc(ARowLocalIndex);
      end;

      ARow := ARow.Next;
    end;
  finally
    ProgressHelper.EndStage;
  end;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteString(AWriter: TdxXmlWriter; AString: TdxSpreadSheetSharedString);

  function IsFormattedString(AString: TdxSpreadSheetSharedString): Boolean;
  begin
    Result := (AString is TdxSpreadSheetFormattedSharedString) and (TdxSpreadSheetFormattedSharedString(AString).Runs.Count > 0);
  end;

  procedure WriteStringRun(AStartIndex, ANextRunIndex: Integer; AFontHandle: TdxSpreadSheetFontHandle = nil);
  begin
    if AStartIndex < ANextRunIndex then
      WriteFormattedText(AWriter, Copy(AString.Value, AStartIndex, ANextRunIndex - AStartIndex), AFontHandle);
  end;

var
  ARun: TdxSpreadSheetFormattedSharedStringRun;
  ARuns: TdxSpreadSheetFormattedSharedStringRuns;
  I: Integer;
begin
  if IsFormattedString(AString) then
  begin
    AWriter.WriteStartElement(sXMLSSNamespaceSpreadSheet, sXMLSSNodeData, '');
    AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrType, '', CellDataTypeMap[cdtString]);
    AWriter.WriteAttributeString('xmlns', HTMLNamespace);

    ARuns := TdxSpreadSheetFormattedSharedString(AString).Runs;
    WriteStringRun(1, ARuns[0].StartIndex);

    for I := 1 to ARuns.Count - 1 do
    begin
      ARun := ARuns[I - 1];
      WriteStringRun(ARun.StartIndex, ARuns[I].StartIndex, ARun.FontHandle);
    end;

    ARun := ARuns[ARuns.Count - 1];
    WriteStringRun(ARun.StartIndex, Length(AString.Value) + 1, ARun.FontHandle);

    AWriter.WriteEndElement;
  end
  else
  begin
    AWriter.WriteStartElement(sXMLSSNodeData);
    AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrType, '', CellDataTypeMap[cdtString]);
    AWriter.WriteValue(AString.Value);
    AWriter.WriteEndElement;
  end;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteStyle(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetCellStyleHandle; AStyleID: Integer);
begin
  AWriter.WriteStartElement(sXMLSSNodeStyle);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrID, '', Format(sXMLSSStyleNameTemplate, [AStyleID]));

  WriteStyleAlignment(AWriter, AStyle);
  WriteStyleBorders(AWriter, AStyle.Borders);
  WriteStyleFont(AWriter, AStyle.Font);
  WriteStyleBrush(AWriter, AStyle.Brush);
  WriteStyleNumberFormat(AWriter, AStyle.DataFormat);

  AWriter.WriteStartElement(sXMLSSNodeProtection);
  AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrProtected, '', Ord(csLocked in AStyle.States));
  AWriter.WriteEndElement;

  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteStyleAlignment(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetCellStyleHandle);
begin
  AWriter.WriteStartElement(sXMLSSNodeAlignment);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrHorizontal, '', HorzAttrValuesMap[AStyle.AlignHorz]);
  if AStyle.AlignHorzIndent <> 0 then
    AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrIndent, '', AStyle.AlignHorzIndent);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrVertical, '', VertAttrValuesMap[AStyle.AlignVert]);
  AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrShrinkToFit, '', Ord(csShrinkToFit in AStyle.States));
  AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrWrapText, '', Ord(csWordWrap in AStyle.States));
  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteStyleBorders(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetBordersHandle);
var
  AHasColor: Boolean;
  ASide: TcxBorder;
  AStyleInfo: TdxXMLSSLineStyleInfo;
begin
  AWriter.WriteStartElement(sXMLSSNodeBorders);
  for ASide := Low(TcxBorder) to High(TcxBorder) do
  begin
    AHasColor := cxColorIsValid(AStyle.BorderColor[ASide]);
    AStyleInfo := LineStyleMap[AStyle.BorderStyle[ASide]];
    if AHasColor or (AStyleInfo.Name <> '') or (AStyleInfo.Weight > 0) then
    begin
      AWriter.WriteStartElement(sXMLSSNodeBorder);
      if AHasColor then
        AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrColor, '', EncodeColor(AStyle.BorderColor[ASide]));
      if AStyleInfo.Name <> '' then
        AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrLineStyle, '', AStyleInfo.Name);
      if AStyleInfo.Weight > 0 then
        AWriter.WriteAttributeFloat(sXMLSSNamespaceSpreadSheet, sXMLSSAttrWeight, '', AStyleInfo.Weight);
      AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrPosition, '', BordersNames[ASide]);
      AWriter.WriteEndElement;
    end;
  end;
  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteStyleBrush(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetBrushHandle);
begin
  AWriter.WriteStartElement(sXMLSSNodeInterior);
  if cxColorIsValid(AStyle.BackgroundColor) then
  begin
    AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrColor, '', EncodeColor(AStyle.BackgroundColor));
    AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrPattern, '', CellFillStyleNames[AStyle.Style]);
    if AStyle.Style <> sscfsSolid then
      AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrPatternColor, '', EncodeColor(AStyle.ForegroundColor));
  end;
  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteStyleFont(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetFontHandle);
begin
  AWriter.WriteStartElement(sXMLSSNodeFont);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrFontName, '', AStyle.Name);
  AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrSize, '', AStyle.Size);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrColor, '', EncodeColor(AStyle.Color));
  AWriter.WriteAttributeInteger(sXMLSSNamespaceExcel, sXMLSSAttrCharset, '', AStyle.Charset);

  if fsBold in AStyle.Style then
    AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrBold, '', 1);
  if fsItalic in AStyle.Style then
    AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrItalic, '', 1);
  if fsStrikeOut in AStyle.Style then
    AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrStrikeThrough, '', 1);
  if fsUnderline in AStyle.Style then
    AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrUnderline, '', sXMLSSValueSingle);

  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteStyleNumberFormat(AWriter: TdxXmlWriter; AStyle: TdxSpreadSheetFormatHandle);
var
  APredefinedFormat: TdxSpreadSheetFormatHandle;
begin
  AWriter.WriteStartElement(sXMLSSNodeNumberFormat);

  APredefinedFormat := SpreadSheet.CellStyles.Formats.PredefinedFormats.GetFormatHandleByID(AStyle.FormatCodeID);
  if APredefinedFormat <> nil then
    AStyle := APredefinedFormat;
  if AStyle.FormatCode <> '' then
    AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrFormat, '', AStyle.FormatCode);

  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteView(AWriter: TdxXmlWriter; AView: TdxSpreadSheetTableView; const AArea: TRect);
begin
  AWriter.WriteStartElement(sXMLSSNodeWorksheet);
  AWriter.WriteAttributeString(sXMLSSNamespaceSpreadSheet, sXMLSSAttrName, '', AView.Caption);

  WriteNames(AWriter, AView);

  AWriter.WriteStartElement(sXMLSSNodeTable);
  AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrExpandedColumnCount, '',
    TdxSpreadSheetTableColumnsAccess(AView.Columns).GetItemVisibleCount(AArea.Left, AArea.Right));
  AWriter.WriteAttributeInteger(sXMLSSNamespaceSpreadSheet, sXMLSSAttrExpandedRowCount, '',
    TdxSpreadSheetTableRowsAccess(AView.Rows).GetItemVisibleCount(AArea.Top, AArea.Bottom));
  AWriter.WriteAttributeFloat(sXMLSSNamespaceSpreadSheet, sXMLSSAttrDefaultColumnWidth, '', EncodeSize(AView.Columns.DefaultSize));
  AWriter.WriteAttributeFloat(sXMLSSNamespaceSpreadSheet, sXMLSSAttrDefaultRowHeight, '', EncodeSize(AView.Rows.DefaultSize));
  WriteColumns(AWriter, AView, AArea);
  WriteRows(AWriter, AView, AArea);
  AWriter.WriteEndElement;

  AWriter.WriteEndElement;
end;

procedure TdxSpreadSheetXMLSSWriter.WriteViews(AWriter: TdxXmlWriter);
var
  AView: TdxSpreadSheetCustomView;
  I: Integer;
begin
  for I := 0 to SpreadSheet.SheetCount - 1 do
  begin
    AView := SpreadSheet.Sheets[I];
    if AView is TdxSpreadSheetTableView then
      WriteView(AWriter, TdxSpreadSheetTableView(AView), TdxSpreadSheetTableView(AView).Dimensions);
  end;
end;

{ TdxXMLSSNodeHandler }

function TdxXMLSSNodeHandler.GetOwner: TdxSpreadSheetXMLSSReader;
begin
  Result := TdxSpreadSheetXMLSSReader(FOwner);
end;

{ TdxXMLSSNodeDefinedNamesHandler }

constructor TdxXMLSSNodeDefinedNamesHandler.Create(AOwner: TObject; AData: TObject);
begin
  inherited;
  FView := AData as TdxSpreadSheetCustomView;
  Handlers.Add(sXMLSSNodeNamedRange, ProcessDefinedName);
end;

function TdxXMLSSNodeDefinedNamesHandler.ProcessDefinedName(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AName, AValue: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrName, '', AName) and
     AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrRefersTo, '', AValue) then
  try
    Owner.SpreadSheet.DefinedNames.Add(AName, AValue, FView);
  except
    // do nothing
  end;
  Result := nil;
end;

{ TdxXMLSSFormattedStringHandler }

constructor TdxXMLSSFormattedStringHandler.Create(AOwner: TdxSpreadSheetXMLSSReader;
  AData: TdxXMLSSFormattedString; ADefaultFont: TdxSpreadSheetFontHandle);
var
  AStyle: TFontStyle;
begin
  inherited Create(AOwner, nil);
  FData := AData;
  FDefaultFont := ADefaultFont;
  FStack := TdxHashTableItemList.Create;
  for AStyle := Low(AStyle) to High(AStyle) do
    Handlers.Add(FontStyleMap[AStyle], ProcessFontStyle, TObject(AStyle));
  Handlers.Add(sXMLSSNodeFont, ProcessFont);
end;

destructor TdxXMLSSFormattedStringHandler.Destroy;
begin
  FreeAndNil(FStack);
  inherited;
end;

procedure TdxXMLSSFormattedStringHandler.OnEnd;
begin
  if FStack.Count > 0 then
    FStack.Delete(FStack.Count - 1);
  inherited;
end;

procedure TdxXMLSSFormattedStringHandler.OnText(const AReader: TdxXmlReader);
begin
  if FStack.Count > 0 then
    FData.Runs.Add(FData.Length + 1, TdxSpreadSheetFontHandle(FStack.Last));
  FData.Append(AReader.ActualValue);
end;

function TdxXMLSSFormattedStringHandler.ModifyFont: TdxSpreadSheetFontHandle;
begin
  if FStack.Count > 0 then
    Result := TdxSpreadSheetFontHandle(FStack.Last).Clone
  else
    Result := FDefaultFont.Clone;
end;

function TdxXMLSSFormattedStringHandler.ProcessFont(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AFontHandle: TdxSpreadSheetFontHandle;
  AValue: string;
begin
  AFontHandle := ModifyFont;
  if AReader.TryGetAttribute(sXMLSSNamespaceHTML, sXMLSSAttrFace, '', AValue) then
    AFontHandle.Name := AValue;
  if AReader.TryGetAttribute(sXMLSSNamespaceHTML, sXMLSSAttrSize, '', AValue) then
    AFontHandle.Size := StrToInt(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceHTML, sXMLSSAttrColor, '', AValue) then
    AFontHandle.Color := DecodeColor(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceExcel, sXMLSSAttrCharset, '', AValue) then
    AFontHandle.Charset := StrToInt(AValue);
  FStack.Add(Owner.AddFont(AFontHandle));
  Result := Self;
end;

function TdxXMLSSFormattedStringHandler.ProcessFontStyle(const AData: TObject): TdxXMLNodeHandler;
var
  AFontHandle: TdxSpreadSheetFontHandle;
begin
  AFontHandle := ModifyFont;
  AFontHandle.Style := AFontHandle.Style + [TFontStyle(AData)];
  FStack.Add(Owner.AddFont(AFontHandle));
  Result := Self;
end;

{ TdxXMLSSNodeStyleHandler }

constructor TdxXMLSSNodeStyleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FStyles := AData as TdxSpreadSheetXMLSSReaderStylesMap;
end;

procedure TdxXMLSSNodeStyleHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sXMLSSNodeAlignment, ProcessAlignment);
  Handlers.Add(sXMLSSNodeBorders, TdxXMLSSNodeStyleBordersHandler, Self);
  Handlers.Add(sXMLSSNodeFont, ProcessFont);
  Handlers.Add(sXMLSSNodeInterior, ProcessBrush);
  Handlers.Add(sXMLSSNodeNumberFormat, ProcessNumberFormat);
  Handlers.Add(sXMLSSNodeProtection, ProcessProtection);
end;

procedure TdxXMLSSNodeStyleHandler.BeforeDestruction;
begin
  inherited;
  FStyles.Add(FStyleId, Owner.CellStyles.AddStyle(FStyle));
end;

procedure TdxXMLSSNodeStyleHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AParentStyleId: string;
  AStyle: TdxSpreadSheetCellStyleHandle;
  AValue: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrID, '', AValue) then
    FStyleId := AValue;
  if not AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrParent, '', AParentStyleId) then
    AParentStyleId := sXMLSSDefaultStyleID;
  if FStyles.TryGetValue(AParentStyleId, AStyle) then
    FStyle := AStyle.Clone
  else
    FStyle := Owner.SpreadSheet.DefaultCellStyle.Handle.Clone;
end;

procedure TdxXMLSSNodeStyleHandler.ModifyState(AStateIndex: TdxSpreadSheetCellState; AValue: Boolean);
begin
  if AValue then
    FStyle.States := FStyle.States + [AStateIndex]
  else
    FStyle.States := FStyle.States - [AStateIndex];
end;

procedure TdxXMLSSNodeStyleHandler.ModifyStyle(var AStyles: TFontStyles; AStyle: TFontStyle; AValue: Boolean);
begin
  if AValue then
    Include(AStyles, AStyle)
  else
    Exclude(AStyles, AStyle);
end;

function TdxXMLSSNodeStyleHandler.ProcessAlignment(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrHorizontal, '', AValue) then
    FStyle.AlignHorz := StringToAlignHorz(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrVertical, '', AValue) then
    FStyle.AlignVert := StringToAlignVert(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrIndent, '', AValue) then
    FStyle.AlignHorzIndent := StrToIntDef(AValue, 0);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrShrinkToFit, '', AValue) then
    ModifyState(csShrinkToFit, TdxXMLHelper.DecodeBoolean(AValue));
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrWrapText, '', AValue) then
    ModifyState(csWordWrap, TdxXMLHelper.DecodeBoolean(AValue));
  Result := nil;
end;

function TdxXMLSSNodeStyleHandler.ProcessBrush(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  ABrush: TdxSpreadSheetBrushHandle;
  AValue: string;
begin
  ABrush := Owner.CreateTempBrushHandle;
  ABrush.Assign(FStyle.Brush);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrColor, '', AValue) then
    ABrush.BackgroundColor := DecodeColor(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrPatternColor, '', AValue) then
    ABrush.ForegroundColor := DecodeColor(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrPattern, '', AValue) then
    ABrush.Style := StringToCellFillStyle(AValue);
  FStyle.Brush := Owner.AddBrush(ABrush);
  Result := nil;
end;

function TdxXMLSSNodeStyleHandler.ProcessFont(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AFont: TdxSpreadSheetFontHandle;
  AValue: string;
begin
  AFont := Owner.CreateTempFontHandle;
  AFont.Assign(FStyle.Font);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrFontName, '', AValue) then
    AFont.Name := AValue;
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrColor, '', AValue) then
    AFont.Color := DecodeColor(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceExcel, sXMLSSAttrCharset, '', AValue) then
    AFont.Charset := StrToIntDef(AValue, DEFAULT_CHARSET);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrBold, '', AValue) then
    ModifyStyle(AFont.Style, fsBold, TdxXMLHelper.DecodeBoolean(AValue));
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrItalic, '', AValue) then
    ModifyStyle(AFont.Style, fsItalic, TdxXMLHelper.DecodeBoolean(AValue));
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrStrikeThrough, '', AValue) then
    ModifyStyle(AFont.Style, fsStrikeOut, TdxXMLHelper.DecodeBoolean(AValue));
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrUnderline, '', AValue) then
    ModifyStyle(AFont.Style, fsUnderline, AValue <> 'None');
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrSize, '', AValue) then
    AFont.Size := StrToIntDef(AValue, DefaultFontSize)
  else
    AFont.Size := DefaultFontSize;

  FStyle.Font := Owner.AddFont(AFont);
  Result := nil;
end;

function TdxXMLSSNodeStyleHandler.ProcessNumberFormat(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AFormatCode: Variant;
  AValue: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrFormat, '', AValue) then
  begin
    if Owner.NumberFormatMap.TryGetValue(AValue, AFormatCode) then
    begin
      if VarIsNumeric(AFormatCode) then
        FStyle.DataFormat := Owner.AddNumberFormat('', AFormatCode)
      else
        FStyle.DataFormat := Owner.AddNumberFormat(AFormatCode, -1);
    end
    else
      FStyle.DataFormat := Owner.AddNumberFormat(AValue);
  end;
  Result := nil;
end;

function TdxXMLSSNodeStyleHandler.ProcessProtection(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrProtected, '', AValue) then
    ModifyState(csLocked, TdxXMLHelper.DecodeBoolean(AValue));
  Result := nil;
end;

{ TdxXMLSSNodeStyleBordersHandler }

constructor TdxXMLSSNodeStyleBordersHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FStyle := (AData as TdxXMLSSNodeStyleHandler).FStyle;
  FBorders := Owner.CreateTempBordersHandle;
  Handlers.Add(sXMLSSNodeBorder, ProcessBorder);
end;

procedure TdxXMLSSNodeStyleBordersHandler.BeforeDestruction;
begin
  inherited;
  FStyle.Borders := Owner.AddBorders(FBorders);
end;

function TdxXMLSSNodeStyleBordersHandler.ConvertBorderStyle(
  const ALineStyle: string; AWeight: Integer): TdxSpreadSheetCellBorderStyle;
var
  AStyle: TdxSpreadSheetCellBorderStyle;
begin
  for AStyle := Low(TdxSpreadSheetCellBorderStyle) to High(TdxSpreadSheetCellBorderStyle) do
  begin
    if (LineStyleMap[AStyle].Name = ALineStyle) and (LineStyleMap[AStyle].Weight = AWeight) then
      Exit(AStyle);
  end;
  Result := sscbsDefault;
end;

function TdxXMLSSNodeStyleBordersHandler.ProcessBorder(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  ABorder: TcxBorder;
  ALineStyle: string;
  AValue: string;
  AWeightStyle: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrPosition, '', AValue) then
  begin
    if TryStringToBorder(AValue, ABorder) then
    begin
      if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrColor, '', AValue) then
        FBorders.BorderColor[ABorder] := DecodeColor(AValue);
      if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrLineStyle, '', ALineStyle) and
         AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrWeight, '', AWeightStyle)
      then
        FBorders.BorderStyle[ABorder] := ConvertBorderStyle(ALineStyle, StrToIntDef(AWeightStyle, 0));
    end;
  end;
  Result := nil;
end;

function TdxXMLSSNodeStyleBordersHandler.TryStringToBorder(const S: string; out ABorder: TcxBorder): Boolean;
var
  AIndex: TcxBorder;
begin
  for AIndex := Low(TcxBorder) to High(TcxBorder) do
    if BordersNames[AIndex] = S then
    begin
      ABorder := AIndex;
      Exit(True);
    end;
  Result := False;
end;

{ TdxXMLSSNodeStylesHandler }

constructor TdxXMLSSNodeStylesHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sXMLSSNodeStyle, TdxXMLSSNodeStyleHandler, AData);
end;

{ TdxXMLSSNodeWorkbookHandler }

procedure TdxXMLSSNodeWorkbookHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sXMLSSNodeStyles, TdxXMLSSNodeStylesHandler, Owner.Styles);
  Handlers.Add(sXMLSSNodeNames, TdxXMLSSNodeDefinedNamesHandler);
  Handlers.Add(sXMLSSNodeWorksheet, CreateWorksheetHandler);
end;

function TdxXMLSSNodeWorkbookHandler.CreateWorksheetHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AName: string;
begin
  if Owner.Settings.TargetView <> nil then
  begin
    if FViewIndex = 0 then
      Result := TdxXMLSSNodeWorksheetHandler.Create(Owner, Owner.Settings.TargetView)
    else
      Result := nil;
  end
  else
    if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrName, '', AName) then
      Result := TdxXMLSSNodeWorksheetHandler.Create(Owner, Owner.AddTableView(AName))
    else
      Result := nil;

  Inc(FViewIndex);
end;

{ TdxXMLSSNodeWorksheetHandler }

constructor TdxXMLSSNodeWorksheetHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sXMLSSNodeNames, TdxXMLSSNodeDefinedNamesHandler, AData);
  Handlers.Add(sXMLSSNodeTable, TdxXMLSSNodeWorksheetTableHandler, AData);
end;

{ TdxXMLSSNodeWorksheetTableHandler }

constructor TdxXMLSSNodeWorksheetTableHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FView := AData as TdxSpreadSheetTableView;
  FMergeMode := Owner.Settings.TargetView <> nil;
  if FMergeMode then
  begin
    FMergeOptions := Owner.Settings.Options;
    FAnchors := Owner.Settings.TargetAnchor;
  end;
end;

procedure TdxXMLSSNodeWorksheetTableHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sXMLSSNodeColumn, CreateColumnHandler);
  Handlers.Add(sXMLSSNodeRow, CreateRowHandler);
end;

function TdxXMLSSNodeWorksheetTableHandler.CreateColumnHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := CreateItemHandler(AReader, FView.Columns, FCurrentColumnIndex, FAnchors.X, TdxXMLSSNodeWorksheetTableColumnHandler);
end;

function TdxXMLSSNodeWorksheetTableHandler.CreateItemHandler(const AReader: TdxXmlReader;
  AItems: TdxSpreadSheetTableItems; var AIndex: Integer; AAnchor: Integer;
  AHandlerClass: TdxXMLSSNodeWorksheetTableItemHandlerClass): TdxXMLNodeHandler;
var
  ASpan: Integer;
  AValue: string;
begin
  ASpan := 0;
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrSpan, '', AValue) then
    ASpan := StrToIntDef(AValue, ASpan);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrIndex, '', AValue) then
    AIndex := StrToInt(AValue) - 1;
  Result := AHandlerClass.Create(Self, AItems.CreateItem(AAnchor + AIndex), ASpan);
  Inc(AIndex, 1 + ASpan);
end;

function TdxXMLSSNodeWorksheetTableHandler.CreateRowHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := CreateItemHandler(AReader, FView.Rows, FCurrentRowIndex, FAnchors.Y, TdxXMLSSNodeWorksheetTableRowHandler);
end;

procedure TdxXMLSSNodeWorksheetTableHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  inherited;

  if not FMergeMode then
  begin
    if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrDefaultColumnWidth, '', AValue) then
      FView.Columns.DefaultSize := DecodeSize(AValue);
    if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrDefaultRowHeight, '', AValue) then
      FView.Rows.DefaultSize := DecodeSize(AValue);
  end;
end;

function TdxXMLSSNodeWorksheetTableHandler.TestOption(AOption: TdxSpreadSheetClipboardPasteOption): Boolean;
begin
  Result := not FMergeMode or (AOption in FMergeOptions);
end;

{ TdxXMLSSNodeWorksheetTableCustomItemHandler }


function TdxXMLSSNodeWorksheetTableCustomItemHandler.GetOwner: TdxXMLSSNodeWorksheetTableHandler;
begin
  Result := TdxXMLSSNodeWorksheetTableHandler(FOwner);
end;

{ TdxXMLSSNodeWorksheetTableItemHandler }

constructor TdxXMLSSNodeWorksheetTableItemHandler.Create(AOwner: TObject; AItem: TdxSpreadSheetTableItem; ASpan: Integer);
begin
  inherited Create(AOwner, nil);
  FItem := AItem;
  FSpan := ASpan;
end;

procedure TdxXMLSSNodeWorksheetTableItemHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AStyle: TdxSpreadSheetCellStyleHandle;
  AValue: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrStyleID, '', AValue) then
  begin
    if Owner.Owner.Styles.TryGetValue(AValue, AStyle) then
      FItem.Style.Handle := AStyle;
  end;
end;

procedure TdxXMLSSNodeWorksheetTableItemHandler.OnEnd;
var
  AIndex: Integer;
begin
  for AIndex := Item.Index + 1 to Item.Index + FSpan do
    Item.Owner.CreateItem(AIndex).Assign(Item);
end;

{ TdxXMLSSNodeWorksheetTableCellHandler }

constructor TdxXMLSSNodeWorksheetTableCellHandler.Create(AOwner: TObject;
  ARow: TdxSpreadSheetTableRow; AColumnIndex: Integer; const AExpandSize: TSize);
begin
  inherited Create(AOwner, nil);
  FRow := ARow;
  FView := ARow.View;
  FColumnIndex := AColumnIndex;
  FExpandSize := AExpandSize;
  FValueType := cdtBlank;
end;

destructor TdxXMLSSNodeWorksheetTableCellHandler.Destroy;
begin
  FreeAndNil(FComment);
  FreeAndNil(FValue);
  inherited;
end;

procedure TdxXMLSSNodeWorksheetTableCellHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sXMLSSNamespaceSpreadSheet, sXMLSSNodeData, ProcessNodeData);
  Handlers.Add(sXMLSSNodeComment, TdxXMLSSNodeWorksheetTableCellCommentHandler, Self);
  Handlers.Add(sXMLSSNodeData, ProcessNodeData);
end;

procedure TdxXMLSSNodeWorksheetTableCellHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrStyleID, '', AValue) then
  begin
    if not Owner.Owner.Styles.TryGetValue(AValue, FStyle) then
      FStyle := nil;
  end;

  FHyperlinkRef := AReader.GetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrHRef, '');
  FHyperlinkScreenTip := AReader.GetAttribute(sXMLSSNamespaceExcel, sXMLSSAttrHRefScreenTip, '');
  FFormula := AReader.GetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrFormula, '');
  FFormulaArrayRange := AReader.GetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrArrayRange, '');
end;

procedure TdxXMLSSNodeWorksheetTableCellHandler.OnEnd;
begin
  if not (IsBlank and Owner.TestOption(cpoSkipBlanks)) then
  begin
    ApplyCellStyle;
    ApplyCellValue;
    CreateHyperlink;
    CreateComment;
  end;

  if ((FExpandSize.cx > 0) or (FExpandSize.cy > 0)) and Owner.TestOption(cpoStyles) then
  begin
    TdxSpreadSheetTableViewMergedCellStyleHelper.Calculate(
      View.MergedCells.Add(cxRectBounds(FColumnIndex, FRow.Index, FExpandSize.cx, FExpandSize.cy)), True);
  end;
end;

procedure TdxXMLSSNodeWorksheetTableCellHandler.ApplyCellStyle;
var
  ACell: TdxSpreadSheetCell;
begin
  if FStyle <> nil then
  begin
    if Owner.TestOption(cpoStyles) then
    begin
      ACell := GetCell;
      if csLocked in ACell.StyleHandle.States then
        ACell.StyleHandle := FStyle
      else
      begin
        ACell.Style.Handle := FStyle;
        ACell.Style.Locked := False;
      end
    end
    else
      if Owner.TestOption(cpoNumberFormatting) then
        TdxSpreadSheetCellDataFormatAccess(GetCell.Style.DataFormat).Handle := FStyle.DataFormat;
  end;
end;

procedure TdxXMLSSNodeWorksheetTableCellHandler.ApplyCellValue;
var
  ACell: TdxSpreadSheetCell;
begin
  if Owner.TestOption(cpoValues) then
  begin
    ACell := GetCell;
    ACell.Clear;
    if (FFormula <> '') and Owner.TestOption(cpoFormulas) then
      Owner.Owner.FormulasRefs.Add(ACell, FFormula, FFormulaArrayRange <> '', False, dxStringToReferenceArea(FFormulaArrayRange))
    else
      case FValueType of
        cdtBoolean:
          ACell.AsBoolean := TdxXMLHelper.DecodeBoolean(FValue.ToString);
        cdtError:
          ACell.AsString := FValue.ToString;
        cdtDateTime:
          ACell.AsDateTime := TdxXMLDateTime.Create(FValue.ToString).ToDateTime;
        cdtString:
          ACell.AsSharedString := Owner.Owner.AddSharedString(FValue.ToString, FValue.Runs);
        cdtCurrency, cdtFloat, cdtInteger:
          ACell.SetText(FValue.ToString);
      end;
  end;
end;

procedure TdxXMLSSNodeWorksheetTableCellHandler.CreateComment;
var
  ACell: TdxSpreadSheetCell;
  AComment: TdxSpreadSheetCommentContainerAccess;
begin
  if Owner.TestOption(cpoComments) and (FComment <> nil) then
  begin
    ACell := GetCell;

    if not View.Containers.FindCommentContainer(ACell, AComment) then
      View.Containers.Add(TdxSpreadSheetCommentContainer, AComment);

    AComment.BeginChanging;
    try
      AComment.Cell := ACell;
      AComment.Author := FCommentAuthor;
      AComment.Calculator.UpdateAnchors(TdxSpreadSheetCommentContainer.GetDefaultPosition(AComment.Cell));
      AComment.Visible := FCommentVisible;
      AComment.TextBox.TextAsString := FComment.ToString;
      if FComment.Runs.Count > 0 then
        AComment.TextBox.Font.Handle := FComment.Runs[0].FontHandle;
    finally
      AComment.EndChanging;
    end;
  end;
end;

procedure TdxXMLSSNodeWorksheetTableCellHandler.CreateHyperlink;
var
  ACell: TdxSpreadSheetCell;
  AHyperlink: TdxSpreadSheetHyperlink;
begin
  if (FHyperlinkRef <> '') and Owner.TestOption(cpoValues) then
  begin
    ACell := GetCell;
    AHyperlink := View.Hyperlinks.FindItem(ACell.RowIndex, ACell.ColumnIndex);
    if AHyperlink = nil then
      AHyperlink := View.Hyperlinks.Add(ACell.RowIndex, ACell.ColumnIndex);
    AHyperlink.ScreenTip := FHyperlinkScreenTip;
    AHyperlink.Value := FHyperlinkRef;
  end;
end;

function TdxXMLSSNodeWorksheetTableCellHandler.GetCell: TdxSpreadSheetCell;
begin
  if FCell = nil then
    FCell := FRow.CreateCell(FColumnIndex);
  Result := FCell;
end;

function TdxXMLSSNodeWorksheetTableCellHandler.GetFont: TdxSpreadSheetFontHandle;
begin
  if FStyle <> nil then
    Result := FStyle.Font
  else
    Result := View.CellStyles.DefaultStyle.Font;
end;

function TdxXMLSSNodeWorksheetTableCellHandler.IsBlank: Boolean;
begin
  Result := (FValueType = cdtBlank) and (FComment = nil);
end;

function TdxXMLSSNodeWorksheetTableCellHandler.ProcessNodeData(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FreeAndNil(FValue);
  FValue := TdxXMLSSFormattedString.Create;
  FValueType := StringToCellDataType(AReader.GetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrType, ''));
  Result := TdxXMLSSFormattedStringHandler.Create(Owner.Owner, FValue, GetFont);
end;

{ TdxXMLSSNodeWorksheetTableCellCommentHandler }

constructor TdxXMLSSNodeWorksheetTableCellCommentHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FData := AData as TdxXMLSSNodeWorksheetTableCellHandler;
  FData.FComment := TdxXMLSSFormattedString.Create;
  Handlers.Add(sXMLSSNamespaceSpreadSheet, sXMLSSNodeData, ProcessData);
end;

procedure TdxXMLSSNodeWorksheetTableCellCommentHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrAuthor, '', AValue) then
    FData.FCommentAuthor := AValue;
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrShowAlways, '', AValue) then
    FData.FCommentVisible := TdxXMLHelper.DecodeBoolean(AValue);
end;

function TdxXMLSSNodeWorksheetTableCellCommentHandler.ProcessData(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXMLSSFormattedStringHandler.Create(Owner.Owner, FData.FComment, Owner.Owner.CellStyles.DefaultStyle.Font);
end;

{ TdxXMLSSNodeWorksheetTableColumnHandler }

procedure TdxXMLSSNodeWorksheetTableColumnHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  inherited;

  if Owner.TestOption(cpoColumnWidths) then
  begin
    if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrWidth, '', AValue) then
      Item.Size := DecodeSize(AValue);
  end;
end;

{ TdxXMLSSNodeWorksheetTableRowHandler }

procedure TdxXMLSSNodeWorksheetTableRowHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sXMLSSNodeCell, CreateCellHandler);
end;

procedure TdxXMLSSNodeWorksheetTableRowHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AValue: string;
begin
  inherited;
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrHeight, '', AValue) then
    Item.Size := DecodeSize(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrAutoFitHeight, '', AValue) then
    TdxSpreadSheetTableRowAccess(Item).IsCustomSize := not TdxXMLHelper.DecodeBoolean(AValue)
  else
    TdxSpreadSheetTableRowAccess(Item).IsCustomSize := False;
end;

function TdxXMLSSNodeWorksheetTableRowHandler.CreateCellHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AExpandSize: TSize;
  AValue: string;
begin
  AExpandSize := cxNullSize;
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrIndex, '', AValue) then
    FColumnIndex := StrToInt(AValue) - 1;
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrMergedAcross, '', AValue) then
    AExpandSize.cx := StrToInt(AValue);
  if AReader.TryGetAttribute(sXMLSSNamespaceSpreadSheet, sXMLSSAttrMergedDown, '', AValue) then
    AExpandSize.cy := StrToInt(AValue);
  Result := TdxXMLSSNodeWorksheetTableCellHandler.Create(Owner, TdxSpreadSheetTableRow(Item), FColumnIndex + Owner.FAnchors.X, AExpandSize);
  Inc(FColumnIndex, AExpandSize.cx + 1);
end;

end.
