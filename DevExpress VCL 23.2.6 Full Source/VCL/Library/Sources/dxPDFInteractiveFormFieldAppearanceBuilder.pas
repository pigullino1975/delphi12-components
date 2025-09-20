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

unit dxPDFInteractiveFormFieldAppearanceBuilder; // for internal use

{$I cxVer.inc}

interface

uses
  Generics.Defaults, Generics.Collections, cxGeometry, dxPDFTypes, dxPDFCore, dxPDFAnnotation,
  dxPDFInteractiveFormField, dxPDFCommandConstructor, dxPDFAppearanceBuilder, dxFontFile, dxPDFCharacterMapping,
  dxPDFFontUtils;

type
  TdxPDFHotkeyPrefix = (hpNone, hpHide); // for internal use
  TdxPDFStringAlignment = (saNear, saCenter, saFar); // for internal use
  TdxPDFStringFormatFlags = (sffMeasureTrailingSpaces = 1, sffNoWrap = 2, sffLineLimit = 4, sffNoClip = 8); // for internal use
  TdxPDFStringTrimming = (stNone, stCharacter, stWord, stEllipsisCharacter, stEllipsisWord); // for internal use

  { TdxPDFStringFormat }

  TdxPDFStringFormat = record // for internal use
  strict private
    FAlignment: TdxPDFStringAlignment;
    FDirectionRightToLeft: Boolean;
    FFormatFlags: TdxPDFStringFormatFlags;
    FHotkeyPrefix: TdxPDFHotkeyPrefix;
    FLeadingMarginFactor: Double;
    FLineAlignment: TdxPDFStringAlignment;
    FTabStopInterval: Double;
    FTrailingMarginFactor: Double;
    FTrimming: TdxPDFStringTrimming;
  public
    class function Create: TdxPDFStringFormat; overload; static;
    class function Create(AFormatFlags: TdxPDFStringFormatFlags): TdxPDFStringFormat; overload; static;
    class function Create(AFormat: TdxPDFStringFormat): TdxPDFStringFormat; overload; static;
    class function CreateGenericDefault: TdxPDFStringFormat; overload; static;
    class function CreateGenericTypographic: TdxPDFStringFormat; overload; static;
    function Clone: TdxPDFStringFormat;
    //
    property Alignment: TdxPDFStringAlignment read FAlignment write FAlignment;
    property DirectionRightToLeft: Boolean read FDirectionRightToLeft write FDirectionRightToLeft;
    property FormatFlags: TdxPDFStringFormatFlags read FFormatFlags write FFormatFlags;
    property HotkeyPrefix: TdxPDFHotkeyPrefix read FHotkeyPrefix write FHotkeyPrefix;
    property LeadingMarginFactor: Double read FLeadingMarginFactor write FLeadingMarginFactor;
    property LineAlignment: TdxPDFStringAlignment read FLineAlignment write FLineAlignment;
    property TabStopInterval: Double read FTabStopInterval write FTabStopInterval;
    property TrailingMarginFactor: Double read FTrailingMarginFactor write FTrailingMarginFactor;
    property Trimming: TdxPDFStringTrimming read FTrimming write FTrimming;
  end;

  { TdxPDFTextFieldAppearanceBuilder }

  TdxPDFTextFieldAppearanceBuilder = class(TdxPDFTextBasedFieldAppearanceBuilder) // for internal use
  strict private
    function GetField: TdxPDFInteractiveFormTextField;
    function GetStringFormat: TdxPDFStringFormat;
    function IsMultiLine: Boolean;
    procedure DrawTextField(AConstructor: TdxPDFXFormCommandConstructor; const AContentRect: TdxPDFRectangle; const AText: string);
  protected
    procedure DrawContent(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure DrawSolidBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    function CalculateAutoFontSize: Double; override;
    property Field: TdxPDFInteractiveFormTextField read GetField;
  public
    constructor Create(AWidget: TdxPDFWidgetAnnotation; AField: TdxPDFInteractiveFormTextField;
      const ABackgroundColor: TdxPDFARGBColor; const AFontProvider: IdxPDFFontProvider); reintroduce;
  end;

  { TdxPDFButtonFieldAppearanceBuilder }

  TdxPDFButtonFieldAppearanceBuilder = class(TdxPDFWidgetAnnotationAppearanceBuilder)
  strict private
    FButtonStyle: TdxPDFButtonStyle;
    FChecked: Boolean;
    FForeColor: TdxPDFColor;
    FIsRadioButton: Boolean;
    //
    procedure AppendEllipticStroke(AConstructor: TdxPDFXFormCommandConstructor; const AStartPoint: TdxPointF);
  protected
    procedure DrawBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure DrawContent(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure DrawInsetBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure DrawSolidBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure DrawUnderlineBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
    procedure FillBackground(AConstructor: TdxPDFXFormCommandConstructor); override;
    //
    function UseCircularAppearance: Boolean;
  public
    constructor Create(AWidget: TdxPDFWidgetAnnotation; AField: TdxPDFInteractiveFormButtonField;
      AButtonStyle: TdxPDFButtonStyle; const AForeColor: TdxPDFColor; AChecked, AIsRadioButton: Boolean;
      const ABackgroundColor: TdxPDFARGBColor); reintroduce;
  end;

  { TdxPDFButtonFieldFadedAppearanceBuilder }

  TdxPDFButtonFieldFadedAppearanceBuilder = class(TdxPDFButtonFieldAppearanceBuilder)
  strict private const
    FadeFactor = 64 / 255;
  strict private
    function GetFadedColor(const AValue: TdxPDFARGBColor): TdxPDFARGBColor;
    function FadeColorComponent(const AColorComponent: Double): Double;
  protected
    function GetBackgroundColor: TdxPDFARGBColor; override;
    procedure DrawBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor); override;
  end;

  { TdxPDFChoiceFieldAppearanceBuilder }

  TdxPDFChoiceFieldAppearanceBuilder = class(TdxPDFTextBasedFieldAppearanceBuilder)
  strict private
    FSelectionBackColor: TdxPDFColor;
    FSelectionForeColor: TdxPDFColor;
    //
    procedure DrawTextBox(AConstructor: TdxPDFXFormCommandConstructor; const AClipRect: TdxPDFRectangle;
      const AText: string; const AColor: TdxPDFColor);
  protected
    procedure DrawContent(AConstructor: TdxPDFXFormCommandConstructor); override;
  public
    constructor Create(AWidget: TdxPDFWidgetAnnotation; AField: TdxPDFInteractiveFormChoiceField;
      const ABackgroundColor: TdxPDFARGBColor; const AFontProvider: IdxPDFFontProvider); reintroduce;
  end;

  { TdxPDFPushButtonFieldAppearanceBuilder }

  TdxPDFPushButtonFieldAppearanceBuilder = class(TdxPDFTextBasedFieldAppearanceBuilder)
  strict private
    class function CalculateScale(const AContentRectangle: TdxPDFRectangle; AWidth, AHeight: Double; AIconFit: TdxPDFIconFit): TdxPointF; static;
    //
    procedure DrawCenteredTextBox(AConstructor: TdxPDFXFormCommandConstructor; const AContentRectangle: TdxPDFRectangle;  const ATextWidth: Double; const AText: string);
    procedure DrawIcon(AConstructor: TdxPDFXFormCommandConstructor; const AContentRectangle: TdxPDFRectangle);
    procedure DrawTextBox(AConstructor: TdxPDFXFormCommandConstructor; const AXOffset, AYOffset: Double; const AText: string);
  protected
    function GetContentRectangle: TdxPDFRectangle; override;
    procedure DrawContent(AConstructor: TdxPDFXFormCommandConstructor); override;
  public
    constructor Create(AWidget: TdxPDFWidgetAnnotation; AField: TdxPDFInteractiveFormButtonField;
      const AFontProvider: IdxPDFFontProvider); reintroduce;
  end;

implementation

uses
  Types, SysUtils, Classes, Math, dxCore, dxTypeHelpers, dxStringHelper, cxDrawTextUtils, dxPDFBase, dxPDFUtils,
  dxPDFCommand, dxPDFCommandInterpreter;

const
  dxThisUnitName = 'dxPDFInteractiveFormFieldAppearanceBuilder';

const
  StringAlignmentMap: array[TdxPDFTextJustify] of TdxPDFStringAlignment = (saNear, saCenter, saFar); // for internal use

type
  TdxPDFLineFormatter = class;

  TdxPDFStringLine = record
  strict private
    FBeginPoint: TdxPointF;
    FEndPoint: TdxPointF;
  public
    class function Create(const ABeginPoint, AEndPoint: TdxPointF): TdxPDFStringLine; static;
    property BeginPoint: TdxPointF read FBeginPoint;
    property EndPoint: TdxPointF read FEndPoint;
  end;

  { TdxPDFCustomSpacing }

  TdxPDFCustomSpacing = class
  public
    function GetValue(AFontSize: Single): Single; virtual; abstract;
  end;

  { TdxPDFLineSpacing }

  TdxPDFLineSpacing = class(TdxPDFCustomSpacing)
  strict private
    FMetrics: TdxFontFileFontMetrics;
  protected
    property Metrics: TdxFontFileFontMetrics read FMetrics;
  public
    constructor Create(const AMetrics: TdxFontFileFontMetrics);
    function GetValue(AFontSize: Single): Single; override;
  end;

  { TdxPDFMultiLineWidgetLineSpacing }

  TdxPDFMultiLineWidgetLineSpacing = class(TdxPDFCustomSpacing)
  strict private
    FActualSpacing: Double;
  public
    constructor Create(AFont: TdxPDFCustomFont);
    function GetValue(AFontSize: Single): Single; override;
  end;

  { TdxPDFStringMeasurer }

  TdxPDFStringMeasurer = class
  strict private
    FEmFactor: Double;
    FFontSize: Double;
    FFormat: TdxPDFStringFormat;
    FLeadingOffset: Double;
    FLineSpacing: TdxPDFCustomSpacing;
    FMetrics: TdxFontFileFontMetrics;
    FTrailingOffset: Double;
  protected
    property EmFactor: Double read FEmFactor;
  public
    constructor Create(const AFontInfo: TdxPDFFontInfo; const AFormat: TdxPDFStringFormat); overload;
    constructor Create(const AFontInfo: TdxPDFFontInfo; const AFormat: TdxPDFStringFormat;
      ALineSpacing: TdxPDFCustomSpacing); overload;

    function MeasureWidth(ALine: TdxPDFGlyphRun): Double; virtual;

    function MeasureStringWidth(ALine: TdxPDFGlyphRun): Double;
    function MeasureStringHeight(ALineCount: Integer): Double;

    property Format: TdxPDFStringFormat read FFormat;
    property LeadingOffset: Double read FLeadingOffset;
    property TrailingOffset: Double read FTrailingOffset;
  end;

  { TdxPDFWidgetStringMeasurer }

  TdxPDFWidgetStringMeasurer = class(TdxPDFStringMeasurer)
  strict private
    FCharSpacing: Double;
    FHorizontalScaling: Double;
    FSpaceGlyph: TdxPDFGlyph;
    FWordSpacing: Double;
  public
    constructor Create(const AFontInfo: TdxPDFFontInfo; const AFormat: TdxPDFStringFormat;
      ATextState: TdxPDFInteractiveFormFieldTextState; ASpaceGlyphRun: TdxPDFGlyphRun; ALineSpacing: TdxPDFCustomSpacing);
    function MeasureWidth(ALine: TdxPDFGlyphRun): Double; override;
  end;

  { TdxPDFStringPaintingStrategy }

  TdxPDFStringPaintingStrategy = class
  strict private
    FConstructor: TdxPDFCommandConstructor;
    FMeasurer: TdxPDFStringMeasurer;
  protected
    property CommandConstructor: TdxPDFCommandConstructor read FConstructor;
  public
    constructor Create(AConstructor: TdxPDFCommandConstructor; AMeasurer: TdxPDFStringMeasurer);

    function GetFirstLineVerticalPosition(ALineCount: Integer): Double; virtual; abstract;
    function GetHorizontalPosition(ALine: TdxPDFGlyphRun): Double; virtual; abstract;
    procedure Clip; virtual; abstract;
    procedure ShowText(ALine: TdxPDFGlyphRun; AUseKerning: Boolean); virtual;

    property Measurer: TdxPDFStringMeasurer read FMeasurer;
  end;

  { TdxPDFStringPaintingInsideRectStrategy }

  TdxPDFStringPaintingInsideRectStrategy = class(TdxPDFStringPaintingStrategy)
  strict private
    FClip: Boolean;
    FRect: TdxPDFRectangle;
  public
    constructor Create(AConstructor: TdxPDFCommandConstructor; AMeasurer: TdxPDFStringMeasurer; const ARect: TdxPDFRectangle);
    function GetFirstLineVerticalPosition(ALineCount: Integer): Double; override;
    function GetHorizontalPosition(ALine: TdxPDFGlyphRun): Double; override;
    procedure Clip; override;
  end;

  { TdxPDFStringPaintingAtPointStrategy }

  TdxPDFStringPaintingAtPointStrategy = class(TdxPDFStringPaintingStrategy)
  strict private
    FLocation: TdxPointF;
  public
    constructor Create(AConstructor: TdxPDFCommandConstructor; AMeasurer: TdxPDFStringMeasurer; const ALocation: TdxPointF);

    function GetFirstLineVerticalPosition(ALineCount: Integer): Double; override;
    function GetHorizontalPosition(ALine: TdxPDFGlyphRun): Double; override;
    procedure Clip; override;
  end;

  { TdxPDFLineTrimmingAlgorithm }

  TdxPDFLineTrimmingAlgorithm = class abstract
  strict private
    FEllipsis: TdxPDFGlyphRun;
    FEllipsisPosition: Integer;
    FFormatter: TdxPDFLineFormatter;
  protected
    function GetUseEllipsis: Boolean; virtual;
    procedure TryInsertEllipsis;
    procedure SaveEllipsisPosition;

    property Ellipsis: TdxPDFGlyphRun read FEllipsis;
    property Formatter: TdxPDFLineFormatter read FFormatter;
    property UseEllipsis: Boolean read GetUseEllipsis;
  public
    constructor Create(AFormatter: TdxPDFLineFormatter; AEllipsis: TdxPDFGlyphRun);

    class function CreateAlgorithm(ATrimming: TdxPDFStringTrimming; AFormatter: TdxPDFLineFormatter; AEllipsis: TdxPDFGlyphRun): TdxPDFLineTrimmingAlgorithm; static;

    function ProcessWord(AWord: TdxPDFGlyphRun): Boolean; virtual; abstract;
  end;

  { TdxPDFLineTrimmingCharAlgorithm }

  TdxPDFLineTrimmingCharAlgorithm = class(TdxPDFLineTrimmingAlgorithm)
  public
    function ProcessWord(AWord: TdxPDFGlyphRun): Boolean; override;
  end;

  { TdxPDFLineTrimmingWordAlgorithm }

  TdxPDFLineTrimmingWordAlgorithm = class(TdxPDFLineTrimmingCharAlgorithm)
  public
    function ProcessWord(AWord: TdxPDFGlyphRun): Boolean; override;
  end;

  { TdxPDFLineTrimmingEllipsisCharAlgorithm }

  TdxPDFLineTrimmingEllipsisCharAlgorithm = class(TdxPDFLineTrimmingCharAlgorithm)
  protected
    function GetUseEllipsis: Boolean; override;
  end;

  { TdxPDFLineTrimmingEllipsisWordAlgorithm }

  TdxPDFLineTrimmingEllipsisWordAlgorithm = class(TdxPDFLineTrimmingWordAlgorithm)
  protected
    function GetUseEllipsis: Boolean; override;
  end;

  { TdxPDFFormatterWord }

  TdxPDFFormatterWord = record
  strict private
    FEndsWithSoftHyphen: Boolean;
    FGlyphs: TdxPDFGlyphRun;
    FText: string;
    function GetWidth: Double;
    function GetTextWithoutLeadingSpaces: string;
  public
    class function Create(const AText: string; AGlyphs: TdxPDFGlyphRun; AEndsWithSoftHyphen: Boolean): TdxPDFFormatterWord; static;
    procedure FreeGlyphs;

    property EndsWithSoftHyphen: Boolean read FEndsWithSoftHyphen;
    property Glyphs: TdxPDFGlyphRun read FGlyphs;
    property TextWithoutLeadingSpaces: string read GetTextWithoutLeadingSpaces;
    property Width: Double read GetWidth;
  end;

  { TdxPDFLineFormatter }

  TdxPDFLineFormatter = class
  strict private
    FCurrentLine: TdxPDFGlyphRun;
    FEmTabStopInterval: Double;
    FFlags: TdxPDFGlyphMappingFlags;
    FFontData: TdxPDFEditableFontData;
    FHyphenRun: TdxPDFGlyphRun;
    FLayoutLineCount: Integer;
    FLayoutWidth: Double;
    FLines: TdxPDFGlyphRunList;
    FNonBreakingSpace: Char;
    FNoWrap: Boolean;
    FShouldAppendHyphen: Boolean;
    FSoftHyphenChar: Char;
    FSoftHyphenString: string;
    FTrimmingAlgorithm: TdxPDFLineTrimmingAlgorithm;

    class function IsBeginWordSymbol(C: Char): Boolean; static;
    class function IsEndWordSymbol(C: Char): Boolean; static;
    class function CanBreak(C: Char): Boolean; overload; static;
    class function CanBreak(APrevious: Char; ANext: Char): Boolean; overload; static;

    function GetHyphenRun: TdxPDFGlyphRun;
    function GetIsCurrentLineEmpty: Boolean;
    function GetCurrentLineGlyphCount: Integer;
    function GetCurrentLineWidth: Double;
    function GetLines: TdxPDFGlyphRunList;
  protected
    function GetWordGlyphs(AActualWord: TdxPDFGlyphRun): TdxPDFGlyphList; virtual;

    procedure EnsureCurrentLine;
    function MapString(const AStr: string): TdxPDFFormatterWord;
    function AppendWord(var AActualWord: TdxPDFFormatterWord): Boolean;
    procedure FinishLine(AIgnoreHyphen: Boolean);
    procedure ApplyTabStops(var AWord: TdxPDFFormatterWord; ATabCount: Integer);

    property HyphenRun: TdxPDFGlyphRun read GetHyphenRun;
    property CurrentLine: TdxPDFGlyphRun read FCurrentLine;
  public
    constructor Create(ALayoutWidth: Double; ALayoutLineCount: Integer; const AFormat: TdxPDFStringFormat;
      AEllipsis: TdxPDFGlyphRun; AFontData: TdxPDFEditableFontData; AEmTabStopInterval: Double);
    destructor Destroy; override;

    procedure AddGlyph(const AGlyph: TdxPDFGlyph); virtual;
    procedure AddWord(const AWord: TdxPDFGlyphRun); virtual;
    procedure RemoveLastGlyph;
    procedure FormatLine(const ALine: string; AFlags: TdxPDFGlyphMappingFlags);
    procedure Clear;

    property CurrentLineGlyphCount: Integer read GetCurrentLineGlyphCount;
    property CurrentLineWidth: Double read GetCurrentLineWidth;
    property IsCurrentLineEmpty: Boolean read GetIsCurrentLineEmpty;
    property LayoutWidth: Double read FLayoutWidth;
    property Lines: TdxPDFGlyphRunList read GetLines;
  end;

  { TdxPDFRTLLineFormatter }

  TdxPDFRTLLineFormatter = class(TdxPDFLineFormatter)
  strict private
    FSpaceGlyphIndex: Integer;
  protected
    function GetWordGlyphs(AActualWord: TdxPDFGlyphRun): TdxPDFGlyphList; override;
  public
    constructor Create(ALayoutWidth: Double; ASpaceGlyphIndex, ALayoutLineCount: Integer;
      const AFormat: TdxPDFStringFormat; AEllipsis: TdxPDFGlyphRun; AFontData: TdxPDFEditableFontData; AEmTabStopInterval: Double);

    procedure AddGlyph(const AGlyph: TdxPDFGlyph); override;
    procedure AddWord(const AWord: TdxPDFGlyphRun); override;
  end;

  { TdxPDFStringFormatter }

  TdxPDFStringFormatter = class
  strict private
    FEllipsis: TdxPDFGlyphRun;
    FFontData: TdxPDFEditableFontData;
    FFontSize: Double;
    FLineAppearanceFactor: Double;
    FLineSpacing: TdxPDFCustomSpacing;
    FShowWithGlyphOffsets: Boolean;
    FSpaceGlyphIndex: Integer;
    class function ProcessHotkeyPrefixes(const AText: string; APrefix: TdxPDFHotkeyPrefix): string; static;
  protected
    function ShouldApplyKerning(ALinesCount: Integer): Boolean; virtual;
  public
    constructor Create(const AFontInfo: TdxPDFFontInfo); overload;
    constructor Create(const AFontInfo: TdxPDFFontInfo; ALineSpacing: TdxPDFCustomSpacing); overload;
    destructor Destroy; override;

    function FormatString(const AStr: string; const APoint: TdxPointF; const AFormat: TdxPDFStringFormat;
      AUseKerning: Boolean; AEmTabStopInterval: Double): TdxPDFGlyphRunList; overload;
    function FormatString(const AStr: string; const ALayoutRect: TdxPDFRectangle; const AFormat: TdxPDFStringFormat;
      AUseKerning: Boolean; AEmTabStopInterval: Double): TdxPDFGlyphRunList; overload;
    function FormatString(const AText: TStringDynArray; AFormatter: TdxPDFLineFormatter; ALimitedLines: Boolean;
      ALineCount: Integer; const AFormat: TdxPDFStringFormat; AUseKerning: Boolean): TdxPDFGlyphRunList; overload;

    property ShowWithGlyphOffsets: Boolean read FShowWithGlyphOffsets;
  end;

  { TdxPDFTabbedStringFormatter }

  TdxPDFTabbedStringFormatter = class
  strict private
    FFontData: TdxPDFEditableFontData;
    FEmTabStop: Double;
    FShouldUseKerning: Boolean;
    FGlyphRun: TdxPDFGlyphRun;
    FRightToLeft: Boolean;
    procedure AppendGlyphRun(const ATabPiece: string; ATabCount: Integer);
    function MapString(const ALine: string): TdxPDFGlyphRun;
  public
    constructor Create(AFontData: TdxPDFEditableFontData; AEmTabStopInterval: Double;
      ARightToLeft: Boolean; AShouldUseKerning: Boolean);
    function FormatString(const ALine: string): TdxPDFGlyphRun;
  end;

  { TdxPDFStringPainter }

  TdxPDFStringPainter = class
  strict private
    FConstructor: TdxPDFCommandConstructor;
  protected
    function CreateMeasurer(const AFontInfo: TdxPDFFontInfo; const AFormat: TdxPDFStringFormat): TdxPDFStringMeasurer; virtual;
    function GetLineSpacing(const AMetrics: TdxFontFileFontMetrics): TdxPDFCustomSpacing; virtual;
    procedure BeginTextDrawing; virtual;
    procedure EndTextDrawing; virtual;
  public
    constructor Create(AConstructor: TdxPDFCommandConstructor);

    procedure DrawLines(ALines: TdxPDFGlyphRunList; const AFontInfo: TdxPDFFontInfo;
      const ALayoutRect: TdxPDFRectangle; const AFormat: TdxPDFStringFormat; AShowWithGlyphOffsets: Boolean); overload;
    procedure DrawLines(ALines: TdxPDFGlyphRunList; const AFontInfo: TdxPDFFontInfo;
      const ALocation: TdxPointF; const AFormat: TdxPDFStringFormat; AShowWithGlyphOffsets: Boolean); overload;
    procedure DrawLines(ALines: TdxPDFGlyphRunList; const AFontInfo: TdxPDFFontInfo;
      AStrategy: TdxPDFStringPaintingStrategy; AShowWithGlyphOffsets: Boolean); overload;
  end;

  { TdxPDFWidgetStringPainter }

  TdxPDFWidgetStringPainter = class(TdxPDFStringPainter)
  strict private
    FLineSpacing: TdxPDFCustomSpacing;
    FSpaceGlyphRun: TdxPDFGlyphRun;
    FState: TdxPDFInteractiveFormFieldTextState;
  protected
    function CreateMeasurer(const AFontInfo: TdxPDFFontInfo; const AFormat: TdxPDFStringFormat): TdxPDFStringMeasurer; override;
    function GetLineSpacing(const AMetrics: TdxFontFileFontMetrics): TdxPDFCustomSpacing; override;
    procedure BeginTextDrawing; override;
    procedure EndTextDrawing; override;
  public
    constructor Create(AConstructor: TdxPDFCommandConstructor; ASpaceGlyphRun: TdxPDFGlyphRun; ALineSpacing: TdxPDFCustomSpacing);
    destructor Destroy; override;

    procedure UpdateSpacing(AState: TdxPDFInteractiveFormFieldTextState);
  end;

  { TdxPdfAutoFontSizeCalculator }

  TdxPdfAutoFontSizeCalculator = class
  strict protected type
  {$SCOPEDENUMS ON}
    TSearchType = (MultiLine, SingleLineBasedWidth, SingleLineBasedHeight);
  {$SCOPEDENUMS OFF}
    TCompareFunc = reference to function (AIndex: Integer): Double;
  strict protected const
    DefaultFontSizeStep = 0.01;
    MinSize = TdxPDFInteractiveFormFieldTextState.DefaultMinFontSize;
    MaxSize = TdxPDFInteractiveFormFieldTextState.DefaultMaxFontSize;
    DefaultSize = TdxPDFInteractiveFormFieldTextState.DefaultFontSize;
  strict private
    FBuilder: TdxPDFTextFieldAppearanceBuilder;
    FText: string;
    FContentSize: TSizeF;
    FIsMultiLine: Boolean;
    FLineCount: Integer;
    FStep: Double;
    function GetContentSize: TSizeF;
    function GetMultiLineFontSize: Double;
    function GetSingleLineFontSize: Double;
    function GetLineCount: Integer;
    function SearchFontSize(ASearchType: TSearchType; AMinFontSize, AMaxFontSize: Double): Double;
    function SizeIndexToFontSize(AFontSizeIndex: Integer): Double;
    function FontSizeToSizeIndex(AFontSize: Double): Integer;
    class function BinarySearch(AStartIndex, AStopIndex: Integer;var AFoundIndex: Integer; const ACompareFunc: TCompareFunc): Boolean;
  protected
    property ContentSize: TSizeF read FContentSize;
    property Builder: TdxPDFTextFieldAppearanceBuilder read FBuilder;
    property IsMultiLine: Boolean read FIsMultiLine;
    property Text: string read FText;
    property LineCount: Integer read FLineCount;
    property Step: Double read FStep write FStep;
  public
    constructor Create;
    function CalculateFontSize(AFieldAppearanceBuilder: TdxPDFTextFieldAppearanceBuilder): Double;
  end;


function HasFlag(ASourceFlags, AFlags: TdxPDFStringFormatFlags): Boolean; overload;
begin
  Result := (Integer(ASourceFlags) and Integer(AFlags)) <> 0;
end;

{ TdxPDFStringPainter }

constructor TdxPDFStringPainter.Create(AConstructor: TdxPDFCommandConstructor);
begin
  inherited Create;
  FConstructor := AConstructor;
end;

procedure TdxPDFStringPainter.DrawLines(ALines: TdxPDFGlyphRunList; const AFontInfo: TdxPDFFontInfo;
  const ALayoutRect: TdxPDFRectangle; const AFormat: TdxPDFStringFormat; AShowWithGlyphOffsets: Boolean);
var
  AMeasurer: TdxPDFStringMeasurer;
  AStrategy: TdxPDFStringPaintingInsideRectStrategy;
begin
  AMeasurer := CreateMeasurer(AFontInfo, AFormat);
  try
    AStrategy := TdxPDFStringPaintingInsideRectStrategy.Create(FConstructor, AMeasurer, ALayoutRect);
    try
      DrawLines(ALines, AFontInfo, AStrategy, AShowWithGlyphOffsets);
    finally
      AStrategy.Free;
    end;
  finally
    AMeasurer.Free;
  end;
end;

procedure TdxPDFStringPainter.DrawLines(ALines: TdxPDFGlyphRunList; const AFontInfo: TdxPDFFontInfo;
  const ALocation: TdxPointF; const AFormat: TdxPDFStringFormat; AShowWithGlyphOffsets: Boolean);
var
  AMeasurer: TdxPDFStringMeasurer;
  AStrategy: TdxPDFStringPaintingAtPointStrategy;
begin
  AMeasurer := CreateMeasurer(AFontInfo, AFormat);
  try
    AStrategy := TdxPDFStringPaintingAtPointStrategy.Create(FConstructor, AMeasurer, ALocation);
    try
      DrawLines(ALines, AFontInfo, AStrategy, AShowWithGlyphOffsets);
    finally
      AStrategy.Free;
    end;
  finally
    AMeasurer.Free;
  end;
end;

procedure TdxPDFStringPainter.DrawLines(ALines: TdxPDFGlyphRunList; const AFontInfo: TdxPDFFontInfo;
  AStrategy: TdxPDFStringPaintingStrategy; AShowWithGlyphOffsets: Boolean);
var
  ABaselineY, AUnderlineY, AStrikeoutY: Double;
  ACount, I: Integer;
  AFontData: TdxPDFEditableFontData;
  AFontSize, ALineSpacing, AAscent, AFirstLineY, APreviousXOffset, X, ADescent, ARight: Double;
  ALine: TdxPDFGlyphRun;
  AOblique, AEmulateBold, AShouldDrawLines: Boolean;
  AStringLine: TdxPDFStringLine;
  AStringLines: TList<TdxPDFStringLine>;
begin
  ACount := 0;
  if ALines <> nil then
    ACount := ALines.Count;
  if ACount > 0 then
  begin
    AFontData := AFontInfo.FontData as TdxPDFEditableFontData;
    AOblique := AFontData.NeedEmulateItalic;
    AFontSize := AFontInfo.FontSize;
    BeginTextDrawing;
    ALineSpacing := GetLineSpacing(AFontData.Metrics).GetValue(AFontSize);
    AAscent := AFontData.Metrics.GetAscent(AFontSize);
    AFirstLineY := AStrategy.GetFirstLineVerticalPosition(ACount) - AAscent;
    AStrategy.Clip;
    AEmulateBold := AFontData.NeedEmulateBold;
    FConstructor.BeginText;
    FConstructor.SetTextFont(AFontData.Font, AFontSize);
    if AEmulateBold then
    begin
      FConstructor.SetLineWidth(AFontSize / 30);
      FConstructor.SetTextRenderingMode(trmFillAndStroke);
    end;
    APreviousXOffset := 0;
    AShouldDrawLines := AFontData.Underline or AFontData.Strikeout;
    AStringLines := TList<TdxPDFStringLine>.Create;
    try
      for I := 0 to ACount - 1 do
      begin
        ALine := ALines[I];
        X := AStrategy.GetHorizontalPosition(ALine);
        if AOblique then
          FConstructor.SetObliqueTextMatrix(X, AFirstLineY - I * ALineSpacing)
        else
        begin
          FConstructor.StartTextLineWithOffsets(X - APreviousXOffset, IfThen(I = 0, AFirstLineY, -ALineSpacing));
        end;
        if not ALine.Empty then
        begin
          AStrategy.ShowText(ALine, AShowWithGlyphOffsets);
          if AShouldDrawLines then
          begin
            ADescent := AFontData.Metrics.GetDescent(AFontSize);
            ARight := X + AStrategy.Measurer.MeasureWidth(ALine);
            ABaselineY := AFirstLineY - ALineSpacing * I;
            if AFontData.Underline then
            begin
              AUnderlineY := ABaselineY - ADescent / 2;
              AStringLines.Add(TdxPDFStringLine.Create(TdxPointF.Create(X, AUnderlineY), TdxPointF.Create(ARight, AUnderlineY)));
            end;
            if AFontData.Strikeout then
            begin
              AStrikeoutY := ABaselineY + AAscent / 2 - ADescent;
              AStringLines.Add(TdxPDFStringLine.Create(TdxPointF.Create(X, AStrikeoutY), TdxPointF.Create(ARight, AStrikeoutY)));
            end;
          end;
        end;
        APreviousXOffset := IfThen(AOblique, 0, X);
      end;
      FConstructor.EndText;
      if AStringLines.Count <> 0 then
      begin
        FConstructor.SetLineWidth(AFontInfo.FontLineSize);
        for AStringLine in AStringLines do
          FConstructor.DrawLine(AStringLine.BeginPoint, AStringLine.EndPoint);
      end;
    finally
      AStringLines.Free;
    end;
    EndTextDrawing;
  end;
end;

function TdxPDFStringPainter.CreateMeasurer(const AFontInfo: TdxPDFFontInfo;
  const AFormat: TdxPDFStringFormat): TdxPDFStringMeasurer;
begin
  Result := TdxPDFStringMeasurer.Create(AFontInfo, AFormat);
end;

function TdxPDFStringPainter.GetLineSpacing(const AMetrics: TdxFontFileFontMetrics): TdxPDFCustomSpacing;
begin
  Result := TdxPDFLineSpacing.Create(AMetrics);
end;

procedure TdxPDFStringPainter.BeginTextDrawing;
begin
  FConstructor.SaveGraphicsState;
end;

procedure TdxPDFStringPainter.EndTextDrawing;
begin
  FConstructor.RestoreGraphicsState;
end;

{ TdxPDFWidgetStringPainter }

constructor TdxPDFWidgetStringPainter.Create(AConstructor: TdxPDFCommandConstructor; ASpaceGlyphRun: TdxPDFGlyphRun;
  ALineSpacing: TdxPDFCustomSpacing);
begin
  inherited Create(AConstructor);
  FLineSpacing := ALineSpacing;
  FSpaceGlyphRun := ASpaceGlyphRun;
end;

destructor TdxPDFWidgetStringPainter.Destroy;
begin
  FreeAndNil(FSpaceGlyphRun);
  inherited Destroy;
end;

procedure TdxPDFWidgetStringPainter.UpdateSpacing(AState: TdxPDFInteractiveFormFieldTextState);
begin
  FState := AState;
end;

function TdxPDFWidgetStringPainter.CreateMeasurer(const AFontInfo: TdxPDFFontInfo;
  const AFormat: TdxPDFStringFormat): TdxPDFStringMeasurer;
begin
  Result := TdxPDFWidgetStringMeasurer.Create(AFontInfo, AFormat, FState, FSpaceGlyphRun, FLineSpacing);
end;

function TdxPDFWidgetStringPainter.GetLineSpacing(const AMetrics: TdxFontFileFontMetrics): TdxPDFCustomSpacing;
begin
  Result := FLineSpacing;
end;

procedure TdxPDFWidgetStringPainter.BeginTextDrawing;
begin
// do nothing
end;

procedure TdxPDFWidgetStringPainter.EndTextDrawing;
begin
// do nothing
end;

{ TdxPDFStringLine }

class function TdxPDFStringLine.Create(const ABeginPoint, AEndPoint: TdxPointF): TdxPDFStringLine;
begin
  Result.FBeginPoint := ABeginPoint;
  Result.FEndPoint := AEndPoint;
end;

{ TdxPDFLineSpacing }

constructor TdxPDFLineSpacing.Create(const AMetrics: TdxFontFileFontMetrics);
begin
  inherited Create;
  FMetrics := AMetrics;
end;

function TdxPDFLineSpacing.GetValue(AFontSize: Single): Single;
begin
  Result := FMetrics.GetLineSpacing(AFontSize);
end;

{ TdxPDFMultiLineWidgetLineSpacing }

constructor TdxPDFMultiLineWidgetLineSpacing.Create(AFont: TdxPDFCustomFont);
begin
  inherited Create;
  FActualSpacing := AFont.Metrics.LineSpacing / 1000;
end;

function TdxPDFMultiLineWidgetLineSpacing.GetValue(AFontSize: Single): Single;
begin
  Result := FActualSpacing * AFontSize;
end;

{ TdxPDFStringFormat }

class function TdxPDFStringFormat.Create(AFormat: TdxPDFStringFormat): TdxPDFStringFormat;
begin
  Result.FLeadingMarginFactor := 1.0 / 6.0;
  Result.FTrailingMarginFactor := 1.0 / 6.0;
  Result.FAlignment := saNear;
  Result.FLineAlignment := saNear;
  Result.FTrimming := stCharacter;
  Result.FHotkeyPrefix := hpNone;
  Result.FFormatFlags := AFormat.FormatFlags;
  Result.FAlignment := AFormat.Alignment;
  Result.FLineAlignment := AFormat.LineAlignment;
  Result.FTrimming := AFormat.Trimming;
  Result.FHotkeyPrefix := AFormat.HotkeyPrefix;
  Result.FLeadingMarginFactor := AFormat.LeadingMarginFactor;
  Result.FTrailingMarginFactor := AFormat.TrailingMarginFactor;
  Result.FTabStopInterval := AFormat.TabStopInterval;
  Result.FDirectionRightToLeft := AFormat.DirectionRightToLeft;
end;

class function TdxPDFStringFormat.CreateGenericDefault: TdxPDFStringFormat;
begin
  Result := TdxPDFStringFormat.CreateGenericTypographic;
end;

class function TdxPDFStringFormat.CreateGenericTypographic: TdxPDFStringFormat;
begin
  Result := TdxPDFStringFormat.Create(TdxPDFStringFormatFlags(Integer(sffLineLimit) or Integer(sffNoClip)));
  Result.FTrimming := stNone;
  Result.FLeadingMarginFactor := 0;
  Result.FTrailingMarginFactor := 0;
end;

class function TdxPDFStringFormat.Create(AFormatFlags: TdxPDFStringFormatFlags): TdxPDFStringFormat;
begin
  Result.FLeadingMarginFactor := 1.0 / 6.0;
  Result.FTrailingMarginFactor := 1.0 / 6.0;
  Result.FAlignment := saNear;
  Result.FLineAlignment := saNear;
  Result.FTrimming := stCharacter;
  Result.FHotkeyPrefix := hpNone;
  Result.FFormatFlags := AFormatFlags;
end;

class function TdxPDFStringFormat.Create: TdxPDFStringFormat;
begin
  Result.FLeadingMarginFactor := 1.0 / 6.0;
  Result.FTrailingMarginFactor := 1.0 / 6.0;
  Result.FAlignment := saNear;
  Result.FLineAlignment := saNear;
  Result.FTrimming := stCharacter;
  Result.FHotkeyPrefix := hpNone;
end;

function TdxPDFStringFormat.Clone: TdxPDFStringFormat;
begin
  Result := TdxPDFStringFormat.Create(Self);
end;

{ TdxPDFStringMeasurer }

constructor TdxPDFStringMeasurer.Create(const AFontInfo: TdxPDFFontInfo; const AFormat: TdxPDFStringFormat);
begin
  Create(AFontInfo, AFormat, TdxPDFLineSpacing.Create((AFontInfo.FontData as TdxPDFEditableFontData).Metrics));
end;

constructor TdxPDFStringMeasurer.Create(const AFontInfo: TdxPDFFontInfo; const AFormat: TdxPDFStringFormat;
  ALineSpacing: TdxPDFCustomSpacing);
begin
  inherited Create;
  FMetrics := (AFontInfo.FontData as TdxPDFEditableFontData).Metrics;
  FFontSize := AFontInfo.FontSize;
  FLineSpacing := ALineSpacing;
  FLeadingOffset := AFormat.LeadingMarginFactor * FFontSize;
  FTrailingOffset := AFormat.TrailingMarginFactor * FFontSize;
  FFormat := TdxPDFStringFormat.Create(AFormat);
  FEmFactor := FFontSize / 1000;
end;

function TdxPDFStringMeasurer.MeasureWidth(ALine: TdxPDFGlyphRun): Double;
begin
  Result := ALine.Width * FEmFactor;
end;

function TdxPDFStringMeasurer.MeasureStringWidth(ALine: TdxPDFGlyphRun): Double;
begin
  Result := MeasureWidth(ALine);
  if (FLeadingOffset <> 0) or (FTrailingOffset <> 0) then
    Result := Result * 1.03 + FLeadingOffset + FTrailingOffset
end;

function TdxPDFStringMeasurer.MeasureStringHeight(ALineCount: Integer): Double;
var
  ALineSpacing: Double;
begin
  Result := 0;
  if ALineCount > 0 then
  begin
    ALineSpacing := FLineSpacing.GetValue(FFontSize);
    if ALineCount = 1 then
      Result := FMetrics.GetAscent(FFontSize) + FMetrics.GetDescent(FFontSize)
    else
      Result := ALineCount * ALineSpacing;
    Result :=  Result + FTrailingOffset * 3 / 4;
  end;
end;

{ TdxPDFWidgetStringMeasurer }

constructor TdxPDFWidgetStringMeasurer.Create(const AFontInfo: TdxPDFFontInfo; const AFormat: TdxPDFStringFormat;
  ATextState: TdxPDFInteractiveFormFieldTextState; ASpaceGlyphRun: TdxPDFGlyphRun; ALineSpacing: TdxPDFCustomSpacing);
begin
  inherited Create(AFontInfo, AFormat, ALineSpacing);
  FHorizontalScaling := 1;
  if ATextState <> nil then
  begin
    FCharSpacing := ATextState.CharacterSpacing;
    FWordSpacing := ATextState.WordSpacing;
    FHorizontalScaling := ATextState.HorizontalScaling / 100;
  end;
  if ASpaceGlyphRun.Empty then
    FSpaceGlyph := TdxPDFGlyph.Create(0, 0, 0)
  else
    FSpaceGlyph := ASpaceGlyphRun.Glyphs[0];
end;

function TdxPDFWidgetStringMeasurer.MeasureWidth(ALine: TdxPDFGlyphRun): Double;
var
  AGlyphWidth: Double;
  AGlyph: TdxPDFGlyph;
begin
  Result := 0;
  for AGlyph in ALine.Glyphs do
  begin
    AGlyphWidth := AGlyph.ActualWidth * EmFactor * FHorizontalScaling;
    AGlyphWidth := IfThen(AGlyphWidth > 0, AGlyphWidth + FCharSpacing, 0);
    if AGlyph.Index = FSpaceGlyph.Index then
      AGlyphWidth := AGlyphWidth + FWordSpacing;
    Result := Result + AGlyphWidth;
  end;
end;

{ TdxPDFStringPaintingStrategy }

constructor TdxPDFStringPaintingStrategy.Create(AConstructor: TdxPDFCommandConstructor; AMeasurer: TdxPDFStringMeasurer);
begin
  inherited Create;
  FConstructor := AConstructor;
  FMeasurer := AMeasurer;
end;

procedure TdxPDFStringPaintingStrategy.ShowText(ALine: TdxPDFGlyphRun; AUseKerning: Boolean);
var
  AOffsets: TDoubleDynArray;
begin
  if AUseKerning then
    AOffsets := ALine.GlyphOffsets
  else
    SetLength(AOffsets, 0);
  FConstructor.ShowText(ALine.TextData, AOffsets);
end;

{ TdxPDFStringPaintingInsideRectStrategy }

constructor TdxPDFStringPaintingInsideRectStrategy.Create(AConstructor: TdxPDFCommandConstructor;
  AMeasurer: TdxPDFStringMeasurer; const ARect: TdxPDFRectangle);
begin
  inherited Create(AConstructor, AMeasurer);
  FRect := ARect;
  FClip := not (Integer(AMeasurer.Format.FormatFlags) and Integer(sffNoClip) <> 0)
end;

function TdxPDFStringPaintingInsideRectStrategy.GetFirstLineVerticalPosition(ALineCount: Integer): Double;
begin
  case Measurer.Format.LineAlignment of
    saCenter:
      Result := FRect.Top - (FRect.Height - Measurer.MeasureStringHeight(ALineCount)) / 2;
    saFar:
      Result := FRect.Top - (FRect.Height - Measurer.MeasureStringHeight(ALineCount));
  else
    Result := FRect.Top;
  end;
end;

function TdxPDFStringPaintingInsideRectStrategy.GetHorizontalPosition(ALine: TdxPDFGlyphRun): Double;
begin
  case Measurer.Format.Alignment of
    saCenter:
      Result := FRect.Left + (FRect.Width - Measurer.MeasureWidth(ALine)) / 2;
    saFar:
      Result := FRect.Right - Measurer.MeasureWidth(ALine) - Measurer.TrailingOffset;
  else
    Result := FRect.Left + Measurer.LeadingOffset;
  end;
end;

procedure TdxPDFStringPaintingInsideRectStrategy.Clip;
begin
  if FClip then
    CommandConstructor.IntersectClip(FRect);
end;

{ TdxPDFStringPaintingAtPointStrategy }

constructor TdxPDFStringPaintingAtPointStrategy.Create(AConstructor: TdxPDFCommandConstructor;
  AMeasurer: TdxPDFStringMeasurer; const ALocation: TdxPointF);
begin
  inherited Create(AConstructor, AMeasurer);
  FLocation := ALocation;
end;

function TdxPDFStringPaintingAtPointStrategy.GetFirstLineVerticalPosition(ALineCount: Integer): Double;
begin
  case Measurer.Format.LineAlignment of
    saCenter:
      Result := FLocation.Y + Measurer.MeasureStringHeight(ALineCount) / 2;
    saFar:
      Result := FLocation.Y + Measurer.MeasureStringHeight(ALineCount);
  else
    Result := FLocation.Y;
  end;
end;

function TdxPDFStringPaintingAtPointStrategy.GetHorizontalPosition(ALine: TdxPDFGlyphRun): Double;
begin
  case Measurer.Format.Alignment of
    saCenter:
      Result := FLocation.X - Measurer.MeasureWidth(ALine) / 2;
    saFar:
      Result := FLocation.X - Measurer.MeasureWidth(ALine) - Measurer.TrailingOffset;
  else
    Result := FLocation.X + Measurer.LeadingOffset;
  end;
end;

procedure TdxPDFStringPaintingAtPointStrategy.Clip;
begin
// do nothing
end;

{ TdxPDFStringFormatter }

constructor TdxPDFStringFormatter.Create(const AFontInfo: TdxPDFFontInfo);
begin
  Create(AFontInfo, TdxPDFLineSpacing.Create((AFontInfo.FontData as TdxPDFEditableFontData).Metrics));
end;

constructor TdxPDFStringFormatter.Create(const AFontInfo: TdxPDFFontInfo; ALineSpacing: TdxPDFCustomSpacing);
var
  ASpaceGlyphRun: TdxPDFGlyphRun;
begin
  inherited Create;
  FLineAppearanceFactor := 0.25;
  FFontData := AFontInfo.FontData as TdxPDFEditableFontData;
  FFontSize := AFontInfo.FontSize;
  FLineSpacing := ALineSpacing;
  FEllipsis := FFontData.ProcessString(cxEndEllipsis, mfNone);
  ASpaceGlyphRun := FFontData.ProcessString(' ', mfNone);
  try
    if (ASpaceGlyphRun.Glyphs = nil) or (ASpaceGlyphRun.Glyphs.Count = 0) then
      FSpaceGlyphIndex := 32
    else
      FSpaceGlyphIndex := ASpaceGlyphRun.Glyphs[0].Index;
  finally
    ASpaceGlyphRun.Free;
  end;
end;

destructor TdxPDFStringFormatter.Destroy;
begin
  FreeAndNil(FEllipsis);
  inherited Destroy;
end;

class function TdxPDFStringFormatter.ProcessHotkeyPrefixes(const AText: string; APrefix: TdxPDFHotkeyPrefix): string;
var
  ABuilder: TStringBuilder;
  ACh: Char;
  AInPrefix: Boolean;
begin
  Result := AText;
  if APrefix <> hpNone then
  begin
    AInPrefix := False;
    ABuilder := TdxStringBuilderManager.Get(Length(AText));
    try
      for ACh in AText do
        if ACh = '&' then
          if AInPrefix then
          begin
            AInPrefix := False;
            ABuilder.Append(ACh);
          end
          else
            AInPrefix := True
        else
          ABuilder.Append(ACh);
      Result := ABuilder.ToString;
    finally
      TdxStringBuilderManager.Release(ABuilder);
    end;
  end;
end;

function TdxPDFStringFormatter.FormatString(const AStr: string; const APoint: TdxPointF;
  const AFormat: TdxPDFStringFormat; AUseKerning: Boolean; AEmTabStopInterval: Double): TdxPDFGlyphRunList;
var
  ALine: string;
  AFormatter: TdxPDFTabbedStringFormatter;
begin
  Result := TdxPDFGlyphRunList.Create;
  FShowWithGlyphOffsets := AUseKerning or (AEmTabStopInterval <> 0);
  AFormatter := TdxPDFTabbedStringFormatter.Create(FFontData, AEmTabStopInterval, AFormat.DirectionRightToLeft, AUseKerning);
  try
    for ALine in TdxPDFUtils.Split(ProcessHotkeyPrefixes(AStr, AFormat.HotkeyPrefix), #10#13) do
      Result.Add(AFormatter.FormatString(ALine));
  finally
    AFormatter.Free;
  end;
end;

function TdxPDFStringFormatter.FormatString(const AStr: string; const ALayoutRect: TdxPDFRectangle;
  const AFormat: TdxPDFStringFormat; AUseKerning: Boolean; AEmTabStopInterval: Double): TdxPDFGlyphRunList;

  procedure CalculateLineCount(out ALayoutWidth: Double; out ALineCount: Integer; out ALimitedLines: Boolean);
  var
    ALineSpacing, AFirstLineHeight, ALayoutHeight, APartialLineCount: Double;
  begin
    ALimitedLines := HasFlag(AFormat.FormatFlags, sffLineLimit);
    ALineSpacing := FLineSpacing.GetValue(FFontSize);
    AFirstLineHeight := FFontData.Metrics.GetAscent(FFontSize) + FFontData.Metrics.GetDescent(FFontSize);
    ALayoutHeight := ALayoutRect.Height;
    if ALayoutHeight < AFirstLineHeight then
      ALineCount := IfThen(not ALimitedLines and (ALayoutHeight >= ALineSpacing * FLineAppearanceFactor), 1, 0)
    else
    begin
      APartialLineCount := (ALayoutHeight - AFirstLineHeight) / ALineSpacing;
      ALineCount := Floor(APartialLineCount);
      if not ALimitedLines and ((APartialLineCount - ALineCount) >= FLineAppearanceFactor) then
        Inc(ALineCount);
      Inc(ALineCount);
    end;
    ALimitedLines := ALimitedLines or (AFormat.Trimming <> stNone);
    ALayoutWidth := Max(0, (ALayoutRect.Width - (AFormat.TrailingMarginFactor + AFormat.LeadingMarginFactor) *
      FFontSize) * 1000 / FFontSize);
  end;

var
  AFormatter: TdxPDFLineFormatter;
  ALayoutWidth: Double;
  ALimitedLines: Boolean;
  ALineCount, I: Integer;
  ALines: TdxPDFGlyphRunList;
  AText: TStringDynArray;
begin
  FShowWithGlyphOffsets := AEmTabStopInterval <> 0;
  CalculateLineCount(ALayoutWidth, ALineCount, ALimitedLines);
  if TdxPDFTextUtils.HasRTLMarker(AStr) then
    AFormatter := TdxPDFRTLLineFormatter.Create(ALayoutWidth, FSpaceGlyphIndex, ALineCount, AFormat, FEllipsis,
      FFontData, AEmTabStopInterval)
  else
    AFormatter := TdxPDFLineFormatter.Create(ALayoutWidth, ALineCount, AFormat, FEllipsis, FFontData, AEmTabStopInterval);
  try
    AText := TdxPDFUtils.Split(ProcessHotkeyPrefixes(StringReplace(AStr, #13#10, #10, [rfReplaceAll]), AFormat.HotkeyPrefix), #10#13);
    ALines := FormatString(AText, AFormatter, ALimitedLines, ALineCount, AFormat, AUseKerning or ShouldApplyKerning(Length(AText)));
    Result := TdxPDFGlyphRunList.Create;
    for I := 0 to ALines.Count - 1 do
    begin
      Result.Add(ALines[I]);
      if ALimitedLines and (I >= ALineCount) then
        Break;
    end;
  finally
    AFormatter.Free;
  end;
end;

function TdxPDFStringFormatter.FormatString(const AText: TStringDynArray; AFormatter: TdxPDFLineFormatter;
  ALimitedLines: Boolean; ALineCount: Integer; const AFormat: TdxPDFStringFormat; AUseKerning: Boolean): TdxPDFGlyphRunList;
var
  AFlags: TdxPDFGlyphMappingFlags;
  ALine: string;
begin
  FShowWithGlyphOffsets := FShowWithGlyphOffsets or AUseKerning;
  AFlags := mfNone;
  if AUseKerning then
    AFlags := mfUseKerning;
  if AFormat.DirectionRightToLeft then
    AFlags := TdxPDFGlyphMappingFlags(Integer(AFlags) or Integer(mfDirectionRightToLeft));
  for ALine in AText do
  begin
    AFormatter.FormatLine(ALine, AFlags);
    if not AUseKerning and ShouldApplyKerning(AFormatter.Lines.Count) then
    begin
      AFormatter.Clear;
      Exit(FormatString(AText, AFormatter, ALimitedLines, ALineCount, AFormat, True));
    end;
    if ALimitedLines and (AFormatter.Lines.Count >= ALineCount) then
      Break;
  end;
  Result := AFormatter.Lines;
end;

function TdxPDFStringFormatter.ShouldApplyKerning(ALinesCount: Integer): Boolean;
begin
  Result := False;
end;

{ TdxPDFTabbedStringFormatter }

constructor TdxPDFTabbedStringFormatter.Create(AFontData: TdxPDFEditableFontData; AEmTabStopInterval: Double;
  ARightToLeft: Boolean; AShouldUseKerning: Boolean);
begin
  FFontData := AFontData;
  FEmTabStop := AEmTabStopInterval;
  FRightToLeft := ARightToLeft;
  FShouldUseKerning := AShouldUseKerning;
end;

procedure TdxPDFTabbedStringFormatter.AppendGlyphRun(const ATabPiece: string; ATabCount: Integer);
var
  AGlyph: TdxPDFGlyph;
  AGlyphRunWidth, ATabOffset: Double;
  APieceGlyphRun: TdxPDFGlyphRun;
begin
  APieceGlyphRun := MapString(ATabPiece);
  if FEmTabStop <> 0 then
  begin
    AGlyph := APieceGlyphRun.Glyphs[0];
    AGlyphRunWidth := 0;
    if FGlyphRun <> nil then
      AGlyphRunWidth := FGlyphRun.Width;
    ATabOffset := (Round(AGlyphRunWidth / FEmTabStop) + ATabCount) * FEmTabStop - AGlyphRunWidth;
    APieceGlyphRun.Glyphs[0] := TdxPDFGlyph.Create(AGlyph.Index, AGlyph.Width, -ATabOffset);
  end;
  if FGlyphRun = nil then
    FGlyphRun := APieceGlyphRun
  else
    FGlyphRun.Append(APieceGlyphRun);
end;

function TdxPDFTabbedStringFormatter.MapString(const ALine: string): TdxPDFGlyphRun;
var
  AFlags: TdxPDFGlyphMappingFlags;
begin
  AFlags := mfNone;
  if FRightToLeft then
    AFlags := TdxPDFGlyphMappingFlags(Integer(AFlags) or Integer(mfDirectionRightToLeft));
  if FShouldUseKerning then
    AFlags := TdxPDFGlyphMappingFlags(Integer(AFlags) or Integer(mfUseKerning));
  Result := FFontData.ProcessString(ALine, AFlags, True);
end;

function TdxPDFTabbedStringFormatter.FormatString(const ALine: string): TdxPDFGlyphRun;
var
  ATabbedPiece: string;
  ATabbedPieces: TStringDynArray;
  ATabCount: Integer;
begin
  if TdxStringHelper.Trim(ALine, []) <> '' then
  begin
    FGlyphRun := nil;
    ATabCount := 0;
    ATabbedPieces := TdxPDFUtils.Split(ALine, #9);
    for ATabbedPiece in ATabbedPieces do
      if ATabbedPiece = '' then
        Inc(ATabCount)
      else
      begin
        AppendGlyphRun(ATabbedPiece, ATabCount);
        ATabCount := 1;
      end;
    Result := FGlyphRun;
  end
  else
    Result := MapString(ALine);
end;

{ TdxPDFLineTrimmingAlgorithm }

constructor TdxPDFLineTrimmingAlgorithm.Create(AFormatter: TdxPDFLineFormatter; AEllipsis: TdxPDFGlyphRun);
begin
  inherited Create;
  FFormatter := AFormatter;
  FEllipsis := AEllipsis;
end;

class function TdxPDFLineTrimmingAlgorithm.CreateAlgorithm(ATrimming: TdxPDFStringTrimming;
  AFormatter: TdxPDFLineFormatter; AEllipsis: TdxPDFGlyphRun): TdxPDFLineTrimmingAlgorithm;
begin
  case ATrimming of
    stCharacter:
      Result := TdxPDFLineTrimmingCharAlgorithm.Create(AFormatter, AEllipsis);
    stWord:
      Result := TdxPDFLineTrimmingWordAlgorithm.Create(AFormatter, AEllipsis);
    stEllipsisCharacter:
      Result := TdxPDFLineTrimmingEllipsisCharAlgorithm.Create(AFormatter, AEllipsis);
    stEllipsisWord:
      Result := TdxPDFLineTrimmingEllipsisWordAlgorithm.Create(AFormatter, AEllipsis);
  else
    Result := nil;
  end;
end;

function TdxPDFLineTrimmingAlgorithm.GetUseEllipsis: Boolean;
begin
  Result := False;
end;

procedure TdxPDFLineTrimmingAlgorithm.TryInsertEllipsis;
var
  AGlyphsToRemove, I: Integer;
begin
  if FEllipsisPosition <> 0 then
  begin
    AGlyphsToRemove := FFormatter.CurrentLineGlyphCount - FEllipsisPosition;
    for I := 0 to AGlyphsToRemove - 1 do
      FFormatter.RemoveLastGlyph;
    if FFormatter.CurrentLineWidth + FEllipsis.Width <= FFormatter.LayoutWidth then
      FFormatter.AddWord(FEllipsis);
  end;
end;

procedure TdxPDFLineTrimmingAlgorithm.SaveEllipsisPosition;
begin
  if FFormatter.CurrentLineWidth + FEllipsis.Width <= FFormatter.LayoutWidth then
    FEllipsisPosition := FFormatter.CurrentLineGlyphCount;
end;

{ TdxPDFLineTrimmingCharAlgorithm }

function TdxPDFLineTrimmingCharAlgorithm.ProcessWord(AWord: TdxPDFGlyphRun): Boolean;
var
  AGlyph: TdxPDFGlyph;
  AWidthWithGlyph: Double;
begin
  Result := False;
  for AGlyph in AWord.Glyphs do
  begin
    AWidthWithGlyph := Formatter.CurrentLineWidth + AGlyph.Width;
    if UseEllipsis then
    begin
      SaveEllipsisPosition;
      if AWidthWithGlyph > Formatter.LayoutWidth then
      begin
        TryInsertEllipsis;
        if Formatter.CurrentLineGlyphCount = 0 then
          Formatter.AddGlyph(AGlyph);
        Exit(True);
      end;
    end
    else
      if Formatter.CurrentLineWidth + AGlyph.Width > Formatter.LayoutWidth then
        Exit(True);
    Formatter.AddGlyph(AGlyph);
  end;
end;

{ TdxPDFLineTrimmingWordAlgorithm }

function TdxPDFLineTrimmingWordAlgorithm.ProcessWord(AWord: TdxPDFGlyphRun): Boolean;
var
  AWidthWithWord: Double;
begin
  if Formatter.IsCurrentLineEmpty and (AWord.Width > Formatter.LayoutWidth) then
    Result := inherited ProcessWord(AWord)
  else
  begin
    AWidthWithWord := Formatter.CurrentLineWidth + AWord.Width;
    if UseEllipsis then
    begin
      SaveEllipsisPosition;
      if AWidthWithWord > Formatter.LayoutWidth then
      begin
        TryInsertEllipsis;
        Exit(True);
      end;
    end
    else
      if Formatter.CurrentLineWidth + AWord.Width > Formatter.LayoutWidth then
        Exit(True);
    Formatter.AddWord(AWord);
    Result := False;
  end;
end;

{ TdxPDFLineTrimmingEllipsisCharAlgorithm }

function TdxPDFLineTrimmingEllipsisCharAlgorithm.GetUseEllipsis: Boolean;
begin
  Result := True;
end;

{ TdxPDFLineTrimmingEllipsisWordAlgorithm }

function TdxPDFLineTrimmingEllipsisWordAlgorithm.GetUseEllipsis: Boolean;
begin
  Result := True;
end;

{ TdxPDFFormatterWord }

class function TdxPDFFormatterWord.Create(const AText: string; AGlyphs: TdxPDFGlyphRun;
  AEndsWithSoftHyphen: Boolean): TdxPDFFormatterWord;
begin
  Result.FText := AText;
  Result.FGlyphs := AGlyphs;
  Result.FEndsWithSoftHyphen := AEndsWithSoftHyphen;
end;

procedure TdxPDFFormatterWord.FreeGlyphs;
begin
  if FGlyphs <> nil then
    FreeAndNil(FGlyphs);
end;

function TdxPDFFormatterWord.GetWidth: Double;
begin
  Result := FGlyphs.Width;
end;

function TdxPDFFormatterWord.GetTextWithoutLeadingSpaces: string;
begin
  Result := TdxStringHelper.TrimStart(FText, [' ']);
end;

{ TdxPDFLineFormatter }

constructor TdxPDFLineFormatter.Create(ALayoutWidth: Double; ALayoutLineCount: Integer;
  const AFormat: TdxPDFStringFormat; AEllipsis: TdxPDFGlyphRun; AFontData: TdxPDFEditableFontData;
  AEmTabStopInterval: Double);
begin
  inherited Create;
  FNonBreakingSpace := Char($0A0);
  FSoftHyphenChar := Char($00AD);
  FSoftHyphenString := #$AD;
  FLayoutWidth := ALayoutWidth;
  FLayoutLineCount := ALayoutLineCount;
  FFontData := AFontData;
  FEmTabStopInterval := AEmTabStopInterval;
  FNoWrap := HasFlag(AFormat.FormatFlags, sffNoWrap);

  FLines := TdxPDFGlyphRunList.Create;
  FTrimmingAlgorithm := TdxPDFLineTrimmingAlgorithm.CreateAlgorithm(AFormat.Trimming, Self, AEllipsis);
  FHyphenRun := FFontData.ProcessString(FSoftHyphenString, mfNone);
end;

destructor TdxPDFLineFormatter.Destroy;
begin
  FLines.Remove(FCurrentLine);
  FreeAndNil(FCurrentLine);
  FreeAndNil(FLines);
  FreeAndNil(FHyphenRun);
  FreeAndNil(FTrimmingAlgorithm);
  inherited Destroy;
end;

class function TdxPDFLineFormatter.IsBeginWordSymbol(C: Char): Boolean;
begin
  Result := (C = '(') or (C = '[') or (C = '{') or (C = #10#13) or (C = ' ');
end;

class function TdxPDFLineFormatter.IsEndWordSymbol(C: Char): Boolean;
begin
  Result := (C = ')') or (C = ']') or (C = '}') or (C = '?') or (C = '!') or (C = #10#13);
end;

class function TdxPDFLineFormatter.CanBreak(C: Char): Boolean;
begin
  Result := (C = #9) or (C = '%');
end;

class function TdxPDFLineFormatter.CanBreak(APrevious: Char; ANext: Char): Boolean;
begin
  Result := not (IsBeginWordSymbol(APrevious) or IsEndWordSymbol(ANext));
  if Result then
    Result := CanBreak(APrevious) or CanBreak(ANext) or IsBeginWordSymbol(ANext) or IsEndWordSymbol(APrevious);
end;

function TdxPDFLineFormatter.GetHyphenRun: TdxPDFGlyphRun;
begin
  Result := FHyphenRun;
end;

function TdxPDFLineFormatter.GetIsCurrentLineEmpty: Boolean;
begin
  Result := (FCurrentLine = nil) or FCurrentLine.Empty;
end;

function TdxPDFLineFormatter.GetCurrentLineGlyphCount: Integer;
begin
  Result := 0;
  if FCurrentLine <> nil then
    Result := FCurrentLine.Glyphs.Count;
end;

function TdxPDFLineFormatter.GetCurrentLineWidth: Double;
begin
  Result := 0;
  if FCurrentLine <> nil then
    Result := FCurrentLine.Width;
end;

function TdxPDFLineFormatter.GetLines: TdxPDFGlyphRunList;
var
  ALastIndex: Integer;
begin
  ALastIndex := FLines.Count - 1;
  if (ALastIndex < 0) or not FLines[ALastIndex].Empty then
    Result := FLines
  else
  begin
    Result := TdxPDFGlyphRunList.Create(FLines);
    Result.Delete(ALastIndex);
  end;
end;

procedure TdxPDFLineFormatter.AddGlyph(const AGlyph: TdxPDFGlyph);
begin
  EnsureCurrentLine;
  FCurrentLine.Append(AGlyph);
end;

procedure TdxPDFLineFormatter.AddWord(const AWord: TdxPDFGlyphRun);
begin
  EnsureCurrentLine;
  FCurrentLine.Append(AWord);
end;

procedure TdxPDFLineFormatter.RemoveLastGlyph;
begin
  FCurrentLine.RemoveLast;
end;

procedure TdxPDFLineFormatter.FormatLine(const ALine: string; AFlags: TdxPDFGlyphMappingFlags);
var
  ALastSubstringEndIndex, ALength, ATabCount, I: Integer;
  AWord: TdxPDFFormatterWord;
  ALastWord: string;
begin
  FFlags := AFlags;
  EnsureCurrentLine;
  ALastSubstringEndIndex := 0;
  ALength := Length(ALine);
  ATabCount := 0;
  for I := 0 to ALength - 2 do
  begin
    if CanBreak(ALine[I + 1], ALine[I + 2]) then
    begin
      if ALine[I + 1] = #9 then
      begin
        Inc(ATabCount);
        Inc(ALastSubstringEndIndex);
        Continue;
      end;
      AWord := MapString(TdxStringHelper.Substring(ALine, ALastSubstringEndIndex, I - ALastSubstringEndIndex + 1));
      try
        ApplyTabStops(AWord, ATabCount);
        ATabCount := 0;
        if AppendWord(AWord) then
        begin
          FinishLine(True);
          Exit;
        end;
        ALastSubstringEndIndex := I + 1;
      finally
        AWord.FreeGlyphs;
      end;
    end;
  end;
  ALastWord := TdxStringHelper.TrimEnd(TdxStringHelper.Substring(ALine, ALastSubstringEndIndex,
    ALength - ALastSubstringEndIndex), [' ']);
  if Length(ALastWord) > 0 then
  begin
    AWord := MapString(ALastWord);
    try
      ApplyTabStops(AWord, ATabCount);
      AppendWord(AWord);
    finally
      AWord.FreeGlyphs;
    end;
  end;
  FinishLine(True);
end;

procedure TdxPDFLineFormatter.Clear;
begin
  FLines.Clear;
  FCurrentLine := nil;
end;

function TdxPDFLineFormatter.GetWordGlyphs(AActualWord: TdxPDFGlyphRun): TdxPDFGlyphList;
begin
  Result := AActualWord.Glyphs;
end;

procedure TdxPDFLineFormatter.EnsureCurrentLine;
begin
  if FCurrentLine = nil then
    FCurrentLine := FFontData.CreateGlyphRun;
end;

function TdxPDFLineFormatter.MapString(const AStr: string): TdxPDFFormatterWord;
var
  S: string;
  AEndsWithSoftHyphen: Boolean;
begin
  AEndsWithSoftHyphen := TdxStringHelper.EndsWith(AStr, FSoftHyphenString);
  S := AStr;
  if AEndsWithSoftHyphen then
    S := TdxStringHelper.TrimEnd(AStr, FSoftHyphenChar);
  Result := TdxPDFFormatterWord.Create(S, FFontData.ProcessString(AStr, FFlags, True), AEndsWithSoftHyphen);
end;

function TdxPDFLineFormatter.AppendWord(var AActualWord: TdxPDFFormatterWord): Boolean;
var
  AGlyph: TdxPDFGlyph;
  ATextWithoutLeadingSpaces: string;
begin
  Result := False;
  FShouldAppendHyphen := AActualWord.EndsWithSoftHyphen;
  if (FLines.Count > 0) and IsCurrentLineEmpty then
  begin
    ATextWithoutLeadingSpaces := AActualWord.TextWithoutLeadingSpaces;
    AActualWord.FreeGlyphs;
    AActualWord := MapString(ATextWithoutLeadingSpaces);
  end;
  if (FTrimmingAlgorithm <> nil) and (FNoWrap or (FLines.Count = FLayoutLineCount - 1)) then
    Result := FTrimmingAlgorithm.ProcessWord(AActualWord.Glyphs)
  else
    if FNoWrap then
      AddWord(AActualWord.Glyphs)
    else
      if IfThen(AActualWord.EndsWithSoftHyphen, AActualWord.Width + HyphenRun.Width, AActualWord.Width) + CurrentLineWidth <= FLayoutWidth then
        AddWord(AActualWord.Glyphs)
      else
        if not IsCurrentLineEmpty then
        begin
          FinishLine(False);
          AppendWord(AActualWord);
        end
        else
          for AGlyph in GetWordGlyphs(AActualWord.Glyphs) do
            if CurrentLineWidth + AGlyph.Width <= FLayoutWidth then
              AddGlyph(AGlyph)
            else
              if (AGlyph.Width > FLayoutWidth) and IsCurrentLineEmpty then
              begin
                AddGlyph(AGlyph);
                FinishLine(False);
              end
              else
              begin
                FinishLine(False);
                AddGlyph(AGlyph);
              end;
end;

procedure TdxPDFLineFormatter.FinishLine(AIgnoreHyphen: Boolean);
begin
  if FCurrentLine <> nil then
  begin
    if FShouldAppendHyphen and not AIgnoreHyphen then
      FCurrentLine.Append(HyphenRun);
    FShouldAppendHyphen := False;
    FLines.Add(FCurrentLine);
    FCurrentLine := FFontData.CreateGlyphRun;
  end;
end;

procedure TdxPDFLineFormatter.ApplyTabStops(var AWord: TdxPDFFormatterWord; ATabCount: Integer);
var
  AGlyph: TdxPDFGlyph;
begin
  if (FEmTabStopInterval <> 0) and (ATabCount <> 0) and (AWord.Glyphs.Glyphs.Count <> 0) then
  begin
    AGlyph := AWord.Glyphs.Glyphs[0];
    AWord.Glyphs.Glyphs[0] := TdxPDFGlyph.Create(AGlyph.Index, AGlyph.Width,
      FCurrentLine.Width - (Ceil(FCurrentLine.Width / FEmTabStopInterval) + ATabCount - 1) * FEmTabStopInterval);
  end;
end;

{ TdxPDFRTLLineFormatter }

constructor TdxPDFRTLLineFormatter.Create(ALayoutWidth: Double; ASpaceGlyphIndex, ALayoutLineCount: Integer;
  const AFormat: TdxPDFStringFormat; AEllipsis: TdxPDFGlyphRun; AFontData: TdxPDFEditableFontData; AEmTabStopInterval: Double);
begin
  inherited Create(ALayoutWidth, ALayoutLineCount, AFormat, AEllipsis, AFontData, AEmTabStopInterval);
  FSpaceGlyphIndex := ASpaceGlyphIndex;
end;

procedure TdxPDFRTLLineFormatter.AddGlyph(const AGlyph: TdxPDFGlyph);
begin
  CurrentLine.Prepend(AGlyph);
end;

procedure TdxPDFRTLLineFormatter.AddWord(const AWord: TdxPDFGlyphRun);
begin
  CurrentLine.Prepend(AWord, FSpaceGlyphIndex);
end;

function TdxPDFRTLLineFormatter.GetWordGlyphs(AActualWord: TdxPDFGlyphRun): TdxPDFGlyphList;
var
  I: Integer;
begin
  Result := TdxPDFGlyphList.Create;
  for I := AActualWord.Glyphs.Count - 1 downto 0 do
    Result.Add(AActualWord.Glyphs[I]);
end;

{ TdxPdfAutoFontSizeCalculator }

constructor TdxPdfAutoFontSizeCalculator.Create;
begin
  inherited Create;
  FStep := DefaultFontSizeStep;
end;

function TdxPdfAutoFontSizeCalculator.CalculateFontSize(AFieldAppearanceBuilder: TdxPDFTextFieldAppearanceBuilder): Double;
begin
  FBuilder := AFieldAppearanceBuilder;
  FText := Builder.Field.AppearanceText;
  if Length(Text) = 0 then
    Exit(DefaultSize);
  FContentSize := GetContentSize;
  FIsMultiLine := Builder.Field.MultiLine;
  if IsMultiLine then
    Result := GetMultiLineFontSize
  else
    Result := GetSingleLineFontSize;
end;

function TdxPdfAutoFontSizeCalculator.GetContentSize: TSizeF;
var
  AContentRect: TdxPDFRectangle;
begin
  AContentRect := Builder.GetContentRectangle;
  Result:= TSizeF.Create(AContentRect.Width, AContentRect.Height);
end;

function TdxPdfAutoFontSizeCalculator.GetMultiLineFontSize: Double;
begin
  FLineCount := GetLineCount;
  Result := SearchFontSize(TSearchType.MultiLine, MinSize, DefaultSize);
  Result := EnsureRange(Result, MinSize, DefaultSize);
end;

function TdxPdfAutoFontSizeCalculator.GetSingleLineFontSize: Double;
begin
  Result := SearchFontSize(TSearchType.SingleLineBasedHeight, MinSize, MaxSize);
  Result := SearchFontSize(TSearchType.SingleLineBasedWidth, MinSize, Result);
  Result := EnsureRange(Result, MinSize, MaxSize);
end;

function TdxPdfAutoFontSizeCalculator.GetLineCount: Integer;
begin
  Result := Text.CountChar(#13) + 1;
end;

function TdxPdfAutoFontSizeCalculator.SizeIndexToFontSize(AFontSizeIndex: Integer): Double;
begin
  Result := FStep * AFontSizeIndex;
end;

function TdxPdfAutoFontSizeCalculator.FontSizeToSizeIndex(AFontSize: Double): Integer;
begin
  Result := Trunc(AFontSize / FStep);
end;

function TdxPdfAutoFontSizeCalculator.SearchFontSize(ASearchType: TSearchType; AMinFontSize, AMaxFontSize: Double): Double;
var
  AFoundIndex, AMinFontSizeIndex, AMaxFontSizeIndex: Integer;
begin
  AMinFontSizeIndex := FontSizeToSizeIndex(AMinFontSize);
  AMaxFontSizeIndex := FontSizeToSizeIndex(AMaxFontSize);
  BinarySearch(AMinFontSizeIndex, AMaxFontSizeIndex, AFoundIndex,
    function (AFontSizeIndex: Integer): Double
    var
      AFontSize, AOffset, AActualHeight: Double;
      B: Boolean;
    begin
      Result := 0;
      AFontSize := SizeIndexToFontSize(AFontSizeIndex);
      case ASearchType of
         TSearchType.MultiLine:
           begin
             AOffset := Builder.GetTextHeight(AFontSize, 1) / 2;
             B := (Builder.FontData.Metrics.EmBBox.Height <> 0) and (AOffset < ContentSize.Height);
             AActualHeight := ContentSize.Height - IfThen(B, AOffset, 0);
             Result := Builder.GetTextHeight(AFontSize, LineCount) - AActualHeight;
           end;
         TSearchType.SingleLineBasedWidth: Result := Builder.GetTextWidth(Text, AFontSize) - ContentSize.Width;
         TSearchType.SingleLineBasedHeight: Result := Builder.GetTextHeight(AFontSize, 1) - ContentSize.Height;
      end;
    end);
  Result := SizeIndexToFontSize(AFoundIndex);
end;

class function TdxPdfAutoFontSizeCalculator.BinarySearch(AStartIndex, AStopIndex: Integer;var AFoundIndex: Integer; const ACompareFunc: TCompareFunc): Boolean;
var
  L, H, M: Integer;
  ACompare: Double;
begin
  Result := False;
  L := AStartIndex;
  H := AStopIndex;
  AFoundIndex := L;
  while L <= H do
  begin
    M := L + (H - L) shr 1;
    ACompare := ACompareFunc(M);
    if ACompare > 0 then
      H := M - 1
    else
    begin
      AFoundIndex := M;
      L := M + 1;
      Result := Result or (ACompare = 0);
    end;
  end;
end;

{ TdxPDFTextFieldAppearanceBuilder }

constructor TdxPDFTextFieldAppearanceBuilder.Create(AWidget: TdxPDFWidgetAnnotation;
  AField: TdxPDFInteractiveFormTextField; const ABackgroundColor: TdxPDFARGBColor; const AFontProvider: IdxPDFFontProvider);
begin
  inherited Create(AWidget, AField, ABackgroundColor, AFontProvider);
end;

function TdxPDFTextFieldAppearanceBuilder.CalculateAutoFontSize: Double;
var
  ACalculator : TdxPdfAutoFontSizeCalculator;
begin
  ACalculator := TdxPdfAutoFontSizeCalculator.Create;
  try
    Result := ACalculator.CalculateFontSize(Self);
  finally
    ACalculator.Free;
  end;
end;

procedure TdxPDFTextFieldAppearanceBuilder.DrawContent(AConstructor: TdxPDFXFormCommandConstructor);
var
  ACh: string;
  AField: TdxPDFInteractiveFormTextField;
  AMaxLen, ALength, I: Integer;
  AStep, APreviousCharWidth, AInitialPosition, ACharWidth: Double;
  AChars: TArray<Char>;
  AText: string;
begin
  AField := GetField;
  AText := AField.AppearanceText;
  if AText <> '' then
  begin
    AMaxLen := IfThen(TdxPDFUtils.IsIntegerValid(AField.MaxLen), AField.MaxLen, 0);
    if GetField.IsComposite and (AMaxLen <> 0) then
    begin
      StartDrawTextBox(AConstructor, TdxPDFColor.Null);
      AStep := AConstructor.BoundingBox.Width / AMaxLen;
      AChars := AText.ToCharArray;
      ACh := AChars[0];
      APreviousCharWidth := GetTextWidth(ACh);
      AInitialPosition := (AStep - APreviousCharWidth) / 2;
      ALength := Min(Length(AChars), AMaxLen);
      case AField.TextJustify of
        tjCentered:
          AInitialPosition := AInitialPosition + AStep * (AMaxLen / 2 - ALength / 2);
        tjRightJustified:
          AInitialPosition := AInitialPosition + AStep * (AMaxLen - ALength);
      end;
      DrawTextBoxText(AConstructor, dxPointF(AInitialPosition, CalculateCenteredLineYOffset(GetContentRectangle)), ACh);
      for I := 1 to ALength - 1 do
      begin
        ACh := AChars[I];
        ACharWidth := GetTextWidth(ACh);
        DrawTextBoxText(AConstructor, dxPointF(AStep + (APreviousCharWidth - ACharWidth) / 2, 0), ACh);
        APreviousCharWidth := ACharWidth;
      end;
      EndDrawTextBox(AConstructor);
    end
    else
      DrawTextField(AConstructor, GetContentRectangle, AText);
  end;
end;

procedure TdxPDFTextFieldAppearanceBuilder.DrawSolidBorder(AConstructor: TdxPDFXFormCommandConstructor);
begin
  inherited DrawSolidBorder(AConstructor);
  if GetField.IsComposite then
    DrawTextCombs(AConstructor, GetContentRectangle, GetField.MaxLen);
end;

function TdxPDFTextFieldAppearanceBuilder.GetField: TdxPDFInteractiveFormTextField;
begin
  Result := TdxPDFInteractiveFormTextField(FField);
end;

function TdxPDFTextFieldAppearanceBuilder.GetStringFormat: TdxPDFStringFormat;
begin
  Result := TdxPDFStringFormat.Create(sffNoClip);
  Result.LeadingMarginFactor := 0;
  Result.TrailingMarginFactor := 0;
  Result.Trimming := stNone;
  Result.Alignment := StringAlignmentMap[FField.TextJustify];
  if not IsMultiLine then
  begin
    Result.FormatFlags := TdxPDFStringFormatFlags(Integer(Result.FormatFlags) or Integer(sffNoWrap));
    Result.LineAlignment := saCenter;
  end;
end;

function TdxPDFTextFieldAppearanceBuilder.IsMultiLine: Boolean;
begin
  Result := GetField.MultiLine;
end;

procedure TdxPDFTextFieldAppearanceBuilder.DrawTextField(AConstructor: TdxPDFXFormCommandConstructor;
  const AContentRect: TdxPDFRectangle; const AText: string);

  procedure FormatAndDrawString(APainter: TdxPDFWidgetStringPainter; ALineSpacing: TdxPDFCustomSpacing;
    const ARect: TdxPDFRectangle; const AText: string);
  var
    AFontInfo: TdxPDFFontInfo;
    AFormat: TdxPDFStringFormat;
    AFormatter: TdxPDFStringFormatter;
    AGlyphRun: TdxPDFGlyphRun;
    ALines: TdxPDFGlyphRunList;
  begin
    AFormat := GetStringFormat;
    AFontInfo.FontData := FontData;
    AFontInfo.FontSize := FontSize;
    AFormatter := TdxPDFStringFormatter.Create(AFontInfo, ALineSpacing);
    try
      ALines := AFormatter.FormatString(AText, ARect, AFormat, False, 0);
      try
        if not IsMultiLine and (ALines.Count > 1) then
          ALines.DeleteRange(1, ALines.Count - 1);
        APainter.DrawLines(ALines, AFontInfo, ARect, AFormat, False);
        FontData.UpdateFont;
        while ALines.Count > 0 do
        begin
          AGlyphRun := ALines[0];
          ALines.Delete(0);
          AGlyphRun.Free;
        end;
      finally
        ALines.Free;
      end;
    finally
      AFormatter.Free;
    end;
  end;

  function GetActualFont(AFontCommand: TdxPDFSetTextFontCommand): TdxPDFCustomFont;
  begin
    if (AFontCommand <> nil) and (AFontCommand.Font <> nil) then
      Result := AFontCommand.Font
    else
      Result := FontData.Font;
  end;

var
  AFontCommand: TdxPDFSetTextFontCommand;
  AField: TdxPDFInteractiveFormTextField;
  ALineSpacing: TdxPDFCustomSpacing;
  APainter: TdxPDFWidgetStringPainter;
  ATextRect: TdxPDFRectangle;
begin
  RemoveFont(FontData.Font);
  ATextRect := AContentRect;
  AFontCommand := nil;
  AField := GetField;
  if (AField.TextState.FontCommand <> nil) and (AField.TextState.FontCommand is TdxPDFSetTextFontCommand) then
    AFontCommand := TdxPDFSetTextFontCommand(AField.TextState.FontCommand);
  ALineSpacing := TdxPDFMultiLineWidgetLineSpacing.Create(GetActualFont(AFontCommand));
  try
    if IsMultiLine and (ALineSpacing.GetValue(FontSize) < AContentRect.Height) then
      ATextRect := TdxPDFRectangle.Create(ATextRect.Left, AContentRect.Bottom, ATextRect.Right,
        AContentRect.Top - ALineSpacing.GetValue(FontSize) + FontData.Metrics.GetAscent(FontSize))
    else
    begin
      ALineSpacing.Free;
      ALineSpacing := TdxPDFLineSpacing.Create(FontData.Metrics);
    end;
    APainter := TdxPDFWidgetStringPainter.Create(AConstructor, FontData.ProcessString(' ', mfNone), ALineSpacing);
    try
      if AField.TextState <> nil then
      begin
        APainter.UpdateSpacing(AField.TextState);
        AConstructor.AddCommands(AField.TextState.CommandsAsBytes);
      end;
      FormatAndDrawString(APainter, ALineSpacing, ATextRect, AText);
    finally
      APainter.Free;
    end;
  finally
    ALineSpacing.Free;
  end;
end;

{ TdxPDFButtonFieldAppearanceBuilder }

constructor TdxPDFButtonFieldAppearanceBuilder.Create(AWidget: TdxPDFWidgetAnnotation;
  AField: TdxPDFInteractiveFormButtonField; AButtonStyle: TdxPDFButtonStyle; const AForeColor: TdxPDFColor; AChecked,
  AIsRadioButton: Boolean; const ABackgroundColor: TdxPDFARGBColor);
begin
  inherited Create(AWidget, AField, ABackgroundColor);
  FButtonStyle := AButtonStyle;
  FForeColor := AForeColor;
  FChecked := AChecked;
  FIsRadioButton := AIsRadioButton;
end;

function TdxPDFButtonFieldAppearanceBuilder.UseCircularAppearance: Boolean;
begin
  Result := FIsRadioButton and (FButtonStyle = bfsCircle);
end;

procedure TdxPDFButtonFieldAppearanceBuilder.DrawBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor);
var
  AContentSquare: TdxPDFRectangle;
begin
  if UseCircularAppearance then
  begin
    AContentSquare := AConstructor.ContentSquare;
    AConstructor.SaveGraphicsState;
    AConstructor.SetLineWidth(BorderWidth);
    AConstructor.SetColorForStrokingOperations(TdxPDFColor.Create(1.0));
    AppendEllipticStroke(AConstructor, AContentSquare.TopLeft);
    AConstructor.SetColorForStrokingOperations(TdxPDFColor.Create(0.5));
    AppendEllipticStroke(AConstructor, AContentSquare.BottomRight);
    AConstructor.RestoreGraphicsState;
  end
  else
    DrawRectangularBeveledBorder(AConstructor);
end;

procedure TdxPDFButtonFieldAppearanceBuilder.DrawContent(AConstructor: TdxPDFXFormCommandConstructor);
var
  AContentRectangle, ACheckRectangle, AInflatedCheckRectangle: TdxPDFRectangle;
  AHalfDimension, AXCenter, AYCenter, AFourth, AOctet, ATan54, ATan72, AY23, AX45: Double;
  AP1, AP2, AP3, AP4, AP5: TdxPointF;
  APoints: TdxPointsF;
  ATextState: TdxPDFInteractiveFormFieldTextState;
begin
  if FChecked then
  begin
    AContentRectangle := ContentRectangle;
    AConstructor.SaveGraphicsState;
    ATextState := FField.TextState;
    if (ATextState <> nil) and (ATextState.FontCommand <> nil) and (ATextState.FontSize > 0) and
      ((FButtonStyle = bfsCheck) or (FButtonStyle = bfsDiamond) or (FButtonStyle = bfsSquare) or (FButtonStyle = bfsStar)) then
      AHalfDimension := ATextState.FontSize / 2
    else
      AHalfDimension := TdxPDFUtils.Min(AContentRectangle.Width, AContentRectangle.Height) / 2;
    AXCenter := (AContentRectangle.Left + AContentRectangle.Right) / 2;
    AYCenter := (AContentRectangle.Bottom + AContentRectangle.Top) / 2;
    ACheckRectangle := TdxPDFRectangle.Create(AXCenter - AHalfDimension, AYCenter - AHalfDimension, AXCenter + AHalfDimension, AYCenter + AHalfDimension);
    AHalfDimension := AHalfDimension * 0.75;
    AInflatedCheckRectangle := TdxPDFRectangle.Create(AXCenter - AHalfDimension, AYCenter - AHalfDimension, AXCenter + AHalfDimension, AYCenter + AHalfDimension);
    case FButtonStyle of
      bfsCircle:
        begin
          if not FForeColor.IsNull then
            AConstructor.SetColorForNonStrokingOperations(FForeColor);
          AConstructor.FillEllipse(AInflatedCheckRectangle);
        end;
      bfsCross:
        begin
          if not FForeColor.IsNull then
            AConstructor.SetColorForStrokingOperations(FForeColor);
          AConstructor.DrawLine(ACheckRectangle.BottomLeft, ACheckRectangle.TopRight);
          AConstructor.DrawLine(ACheckRectangle.TopLeft, ACheckRectangle.BottomRight);
        end;
      bfsCheck:
        begin
          AFourth := ACheckRectangle.Width / 4;
          AOctet := AFourth / 2;
          if not FForeColor.IsNull then
            AConstructor.SetColorForStrokingOperations(FForeColor);
          AConstructor.SetLineWidth(AOctet);
          SetLength(APoints, 3);
          APoints[0] := dxPointF(ACheckRectangle.Left + AOctet, AYCenter);
          APoints[1] := dxPointF(AXCenter - AOctet, AYCenter - AFourth);
          APoints[2] := dxPointF(ACheckRectangle.Right - AOctet, AYCenter + AFourth);
          AConstructor.DrawLines(APoints);
        end;
      bfsDiamond:
        begin
          if not FForeColor.IsNull then
            AConstructor.SetColorForNonStrokingOperations(FForeColor);
          SetLength(APoints, 4);
          APoints[0] := dxPointF(AXCenter, AInflatedCheckRectangle.Top);
          APoints[1] := dxPointF(AInflatedCheckRectangle.Right, AYCenter);
          APoints[2] := dxPointF(AXCenter, AInflatedCheckRectangle.Bottom);
          APoints[3] := dxPointF(AInflatedCheckRectangle.Left, AYCenter);
          AConstructor.FillPolygon(APoints, True);
        end;
      bfsSquare:
        begin
          if not FForeColor.IsNull then
            AConstructor.SetColorForNonStrokingOperations(FForeColor);
          AConstructor.FillRectangle(AInflatedCheckRectangle);
        end;
      bfsStar:
        begin
          ATan54 := 1.3763819204711734;
          ATan72 := 3.0776835371752527;
          AP2 := dxPointF(AXCenter, AInflatedCheckRectangle.Top);
          AY23 := AInflatedCheckRectangle.Top - AHalfDimension / ATan54;
          AP4 := dxPointF(AInflatedCheckRectangle.Left, AY23);
          AP5 := dxPointF(AInflatedCheckRectangle.Right, AY23);
          AX45 := (AY23 - AInflatedCheckRectangle.Bottom) / ATan72;
          AP1 := dxPointF(AInflatedCheckRectangle.Left + AX45, AInflatedCheckRectangle.Bottom);
          AP3 := dxPointF(AInflatedCheckRectangle.Right - AX45, AInflatedCheckRectangle.Bottom);
          if not FForeColor.IsNull then
            AConstructor.SetColorForNonStrokingOperations(FForeColor);
          SetLength(APoints, 6);
          APoints[0] := AP1;
          APoints[1] := AP2;
          APoints[2] := AP3;
          APoints[4] := AP4;
          APoints[5] := AP5;
          AConstructor.FillPolygon(APoints, True);
        end;
    end;
    AConstructor.RestoreGraphicsState;
  end;
end;

procedure TdxPDFButtonFieldAppearanceBuilder.DrawInsetBorder(AConstructor: TdxPDFXFormCommandConstructor);
var
  AContentSquare: TdxPDFRectangle;
begin
  if UseCircularAppearance then
  begin
    AContentSquare := AConstructor.ContentSquare;
    AConstructor.SaveGraphicsState;
    AConstructor.SetLineWidth(BorderWidth);
    AConstructor.SetColorForStrokingOperations(TdxPDFColor.Create(0.5));
    AppendEllipticStroke(AConstructor, AContentSquare.TopLeft);
    AConstructor.SetColorForStrokingOperations(TdxPDFColor.Create(0.75));
    AppendEllipticStroke(AConstructor, AContentSquare.BottomRight);
    AConstructor.RestoreGraphicsState;
  end
  else
    DrawRectangularInsetBorder(AConstructor);
end;

procedure TdxPDFButtonFieldAppearanceBuilder.DrawSolidBorder(AConstructor: TdxPDFXFormCommandConstructor);
begin
  if UseCircularAppearance then
    AConstructor.DrawEllipse(TdxPDFRectangle.Inflate(AConstructor.ContentSquare, BorderWidth / 2))
  else
    DrawRectangularBorderStroke(AConstructor);
end;

procedure TdxPDFButtonFieldAppearanceBuilder.DrawUnderlineBorder(AConstructor: TdxPDFXFormCommandConstructor);
begin
  if not UseCircularAppearance then
    DrawRectangularUnderlineBorder(AConstructor);
end;

procedure TdxPDFButtonFieldAppearanceBuilder.FillBackground(AConstructor: TdxPDFXFormCommandConstructor);
begin
  if UseCircularAppearance then
    FillBackgroundEllipse(AConstructor, AConstructor.ContentSquare)
  else
    FillBackgroundRectangle(AConstructor, AConstructor.BoundingBox);
end;

procedure TdxPDFButtonFieldAppearanceBuilder.AppendEllipticStroke(AConstructor: TdxPDFXFormCommandConstructor;
  const AStartPoint: TdxPointF);
var
  AContentSquare: TdxPDFRectangle;
  APath: TdxPDFGraphicsPath;
begin
  AConstructor.SaveGraphicsState;
  AContentSquare := AConstructor.ContentSquare;
  APath := TdxPDFGraphicsPath.Create(AStartPoint);
  try
    APath.AppendLineSegment(AContentSquare.TopRight);
    APath.AppendLineSegment(AContentSquare.BottomLeft);
    AConstructor.IntersectClip(APath);
    AConstructor.DrawEllipse(TdxPDFRectangle.Inflate(AContentSquare, 3 * BorderWidth / 2));
    AConstructor.RestoreGraphicsState;
  finally
    APath.Free;
  end;
end;

{ TdxPDFButtonFieldFadedAppearanceBuilder }

function TdxPDFButtonFieldFadedAppearanceBuilder.GetBackgroundColor: TdxPDFARGBColor;
begin
  Result := GetFadedColor(inherited GetBackgroundColor);
end;

procedure TdxPDFButtonFieldFadedAppearanceBuilder.DrawBeveledBorder(AConstructor: TdxPDFXFormCommandConstructor);
begin
  DrawInsetBorder(AConstructor);
end;

function TdxPDFButtonFieldFadedAppearanceBuilder.GetFadedColor(const AValue: TdxPDFARGBColor): TdxPDFARGBColor;
var
  AColor: TdxPDFARGBColor;
begin
  if AColor.IsNull then
    AColor := TdxPDFARGBColor.Create(1, 1, 1, 1)
  else
    AColor := AValue;
  Result := TdxPDFARGBColor.Create(
    FadeColorComponent(AColor.Red),
    FadeColorComponent(AColor.Green),
    FadeColorComponent(AColor.Blue),
    AColor.Alpha);
end;

function TdxPDFButtonFieldFadedAppearanceBuilder.FadeColorComponent(const AColorComponent: Double): Double;
begin
  Result := TdxPDFUtils.Max(0, AColorComponent - FadeFactor);
end;

{ TdxPDFChoiceFieldAppearanceBuilder }

constructor TdxPDFChoiceFieldAppearanceBuilder.Create(AWidget: TdxPDFWidgetAnnotation;
  AField: TdxPDFInteractiveFormChoiceField; const ABackgroundColor: TdxPDFARGBColor; const AFontProvider: IdxPDFFontProvider);
begin
  inherited Create(AWidget, AField, ABackgroundColor, AFontProvider);
  FSelectionForeColor := TdxPDFColor.Create(0, 0, 0);
  FSelectionBackColor := TdxPDFColor.Create(0.6, 0.75686, 0.8549);
end;

procedure TdxPDFChoiceFieldAppearanceBuilder.DrawContent(AConstructor: TdxPDFXFormCommandConstructor);
var
  AField: TdxPDFInteractiveFormChoiceField;
  ASelectedValues: TStringList;
  AText: string;
  AItem: TdxPDFChoiceFieldValue;
  AItems: TdxPDFChoiceFieldValueList;
  AContentRectangle, AItemBox: TdxPDFRectangle;
  ALeft, ARight, ATop, AItemHeight, ABottom: Double;
  ATopIndex, ACount, I: Integer;
  AColor: TdxPDFColor;
begin
  AField := TdxPDFInteractiveFormChoiceField(FField);
  ASelectedValues := AField.SelectedValues;
  AItems := AField.Items;
  if AField.IsComboBox then
  begin
    if ASelectedValues.Count > 0 then
    begin
      AText := '';
      for AItem in AItems do
        if AItem.ExportValue = ASelectedValues[0] then
        begin
          AText := AItem.Value;
          Break;
        end;
      if AText = '' then
        AText := ASelectedValues[0];
      DrawTextBox(AConstructor, ContentRectangle, AText, TdxPDFColor.Null);
    end;
  end
  else
  begin
    AContentRectangle := ContentRectangle;
    ALeft := AContentRectangle.Left;
    ARight := AContentRectangle.Right;
    ATop := AContentRectangle.Top;
    AItemHeight := FontSize + 1;
    ATopIndex := AField.TopIndex;
    ACount := AItems.Count;
    for I := 0 to ACount - 1 do
      if I >= ATopIndex then
      begin
        ABottom := ATop - AItemHeight;
        AItemBox := TdxPDFRectangle.Create(ALeft, ABottom, ARight, ATop);
        ATop := ABottom;
        AItem := AItems[I];
        if ASelectedValues.IndexOf(AItem.ExportValue) <> -1 then
        begin
          AConstructor.SetColorForNonStrokingOperations(FSelectionBackColor);
          AConstructor.FillRectangle(AItemBox);
          AColor := FSelectionForeColor;
        end
        else
          AColor := TdxPDFColor.Null;
        DrawTextBox(AConstructor, AItemBox, AItem.Value, AColor);
      end;
  end;
end;

procedure TdxPDFChoiceFieldAppearanceBuilder.DrawTextBox(AConstructor: TdxPDFXFormCommandConstructor;
  const AClipRect: TdxPDFRectangle; const AText: string; const AColor: TdxPDFColor);
var
  AXOffset: Double;
begin
  StartDrawTextBox(AConstructor, AColor);
  case FField.TextJustify of
    tjLeftJustified:
      AXOffset := AClipRect.Left + 1;
    tjCentered:
      AXOffset := AClipRect.Left + (AClipRect.Width - GetTextWidth(AText)) / 2;
    tjRightJustified:
      AXOffset := AClipRect.Right - GetTextWidth(AText) - 1;
    else
      AXOffset := 0;
  end;
  DrawTextBoxText(AConstructor, dxPointF(AXOffset, CalculateCenteredLineYOffset(AClipRect)), AText);
  EndDrawTextBox(AConstructor);
end;

{ TdxPDFPushButtonFieldAppearanceBuilder }

constructor TdxPDFPushButtonFieldAppearanceBuilder.Create(AWidget: TdxPDFWidgetAnnotation;
  AField: TdxPDFInteractiveFormButtonField; const AFontProvider: IdxPDFFontProvider);
begin
  inherited Create(AWidget, AField, TdxPDFARGBColor.Null, AFontProvider);
end;

class function TdxPDFPushButtonFieldAppearanceBuilder.CalculateScale(const AContentRectangle: TdxPDFRectangle;
  AWidth, AHeight: Double; AIconFit: TdxPDFIconFit): TdxPointF;
var
  AXScale, AYScale, AScale: Double;
  AShouldPerformScale: Boolean;
begin
  AXScale := AContentRectangle.Width / AWidth;
  AYScale := AContentRectangle.Height / AHeight;
  case AIconFit.ScalingCircumstances of
    iscBiggerThanAnnotationRectangle:
      AShouldPerformScale := (AXScale < 1) or (AYScale < 1);
    iscSmallerThanAnnotationRectangle:
      AShouldPerformScale := (AXScale > 1) or (AYScale > 1);
    iscNever:
      AShouldPerformScale := False;
  else
    AShouldPerformScale := True;
  end;
  if not AShouldPerformScale then
  begin
    AXScale := 1;
    AYScale := 1;
  end
  else
    if AIconFit.ScalingType = istProportional then
    begin
      AScale := TdxPDFUtils.Min(AXScale, AYScale);
      AXScale := AScale;
      AYScale := AScale;
    end;
  Result := dxPointF(AXScale, AYScale);
end;

procedure TdxPDFPushButtonFieldAppearanceBuilder.DrawCenteredTextBox(AConstructor: TdxPDFXFormCommandConstructor;
  const AContentRectangle: TdxPDFRectangle; const ATextWidth: Double; const AText: string);
begin
  DrawTextBox(AConstructor, AContentRectangle.Left + (AContentRectangle.Width - ATextWidth) / 2,
    CalculateCenteredLineYOffset(AContentRectangle), AText);
end;

procedure TdxPDFPushButtonFieldAppearanceBuilder.DrawIcon(AConstructor: TdxPDFXFormCommandConstructor;
  const AContentRectangle: TdxPDFRectangle);
var
  AAppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics;
  ANormalIcon: TdxPDFXForm;
  AIconFit: TdxPDFIconFit;
  AIconBBox: TdxPDFRectangle;
  AScale, ABottomLeft, AIconSize: TdxPointF;
  AScaleMatrix: TdxPDFTransformationMatrix;
  E, F: Double;
  AImage: TdxPDFDocumentImage;
begin
  AAppearanceCharacteristics := GetAnnotation.AppearanceCharacteristics;
  ANormalIcon := Safe<TdxPDFXForm>.Cast(AAppearanceCharacteristics.NormalIcon);

  AIconFit := AAppearanceCharacteristics.IconFit;
  if (ANormalIcon <> nil) and (ANormalIcon <> AConstructor.Form) then
  begin
    AIconBBox := ANormalIcon.BBox;
    AScale := CalculateScale(AContentRectangle, AIconBBox.Width, AIconBBox.Height, AIconFit);
    AScaleMatrix := TdxPDFTransformationMatrix.Create(AScale.X, 0, 0, AScale.Y, 0, 0);
    ABottomLeft := AScaleMatrix.Transform(ANormalIcon.Matrix.Transform(AIconBBox.BottomLeft));
    AIconSize := AScaleMatrix.Transform(dxPointF(AIconBBox.Width, AIconBBox.Height));
    E := AContentRectangle.Left + (AContentRectangle.Width - AIconSize.X) * AIconFit.HorizontalPosition - ABottomLeft.X;
    F := AContentRectangle.Bottom + (AContentRectangle.Height - AIconSize.Y) * AIconFit.VerticalPosition - ABottomLeft.Y;
    AConstructor.DrawForm(ANormalIcon, TdxPDFTransformationMatrix.Create(AScale.X, 0, 0, AScale.Y, E, F));
  end
  else
  begin
    AImage := Safe<TdxPDFDocumentImage>.Cast(AAppearanceCharacteristics.NormalIcon);
    if AImage <> nil then
    begin
      AScale := CalculateScale(AContentRectangle, AImage.Width, AImage.Height, AIconFit);
      AIconSize := TdxPDFTransformationMatrix.Create(AScale.X, 0, 0, AScale.Y, 0, 0).Transform(
        dxPointF(AImage.Width, AImage.Height));
      E := AContentRectangle.Left + (AContentRectangle.Width - AIconSize.X) * AIconFit.HorizontalPosition;
      F := AContentRectangle.Bottom + (AContentRectangle.Height - AIconSize.Y) * AIconFit.VerticalPosition;
      AConstructor.DrawXObject(AImage, TdxPDFTransformationMatrix.Create(AIconSize.X, 0, 0, AIconSize.Y, E, F));
    end;
  end;
end;

procedure TdxPDFPushButtonFieldAppearanceBuilder.DrawTextBox(AConstructor: TdxPDFXFormCommandConstructor;
  const AXOffset, AYOffset: Double; const AText: string);
begin
  if AText <> '' then
  begin
    StartDrawTextBox(AConstructor, TdxPDFColor.Null);
    DrawTextBoxText(AConstructor, dxPointF(AXOffset, AYOffset), AText);
    EndDrawTextBox(AConstructor);
  end;
end;

function TdxPDFPushButtonFieldAppearanceBuilder.GetContentRectangle: TdxPDFRectangle;
var
  AWidget: TdxPDFWidgetAnnotation;
begin
  AWidget := GetAnnotation;
  if AWidget.AppearanceCharacteristics.IconFit.FitToAnnotationBounds then
    Result := AWidget.AppearanceBBox
  else
    Result := inherited GetContentRectangle
end;

procedure TdxPDFPushButtonFieldAppearanceBuilder.DrawContent(AConstructor: TdxPDFXFormCommandConstructor);
var
  AAppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics;
  AContentRectangle: TdxPDFRectangle;
  ATextPosition: TdxPDFWidgetAnnotationTextPosition;
  ACaption: string;
  AFontSize, ADescent, AOffset, ALineSpacing, ATextWidth, ALeft, ABottom: Double;
  AMetrics: TdxFontFileFontMetrics;
begin
  AAppearanceCharacteristics := GetAnnotation.AppearanceCharacteristics;
  if AAppearanceCharacteristics <> nil then
  begin
    AContentRectangle := GetContentRectangle;
    if (AAppearanceCharacteristics.IconFit = nil) or (not AAppearanceCharacteristics.IconFit.FitToAnnotationBounds) then
      AContentRectangle := TdxPDFRectangle.Inflate(AContentRectangle, GetAnnotation.BorderWidth);
    ATextPosition := AAppearanceCharacteristics.TextPosition;
    if ATextPosition <> wtpNoCaption then
    begin
      ACaption := AAppearanceCharacteristics.Caption;
      AFontSize := FontSize;
      AMetrics := FontData.Metrics;
      ADescent := AMetrics.GetDescent(AFontSize);
      AOffset := ADescent / 2;
      ALineSpacing := AMetrics.GetLineSpacing(AFontSize) + ADescent;
      ATextWidth := GetTextWidth(ACaption);
      ALeft := AContentRectangle.Left;
      ABottom := AContentRectangle.Bottom;
      case AAppearanceCharacteristics.TextPosition of
        wtpCaptionBelowTheIcon:
          begin
            DrawTextBox(AConstructor, ALeft + (AContentRectangle.Width - ATextWidth) / 2, ABottom + AOffset + AMetrics.GetDescent(FontSize), ACaption);
            AContentRectangle := TdxPDFRectangle.Create(ALeft, ABottom + ALineSpacing, AContentRectangle.Right, AContentRectangle.Top);
          end;
        wtpCaptionAboveTheIcon:
          begin
            DrawTextBox(AConstructor, ALeft + (AContentRectangle.Width - ATextWidth) / 2, AContentRectangle.Top - AOffset - AMetrics.GetAscent(FontSize), ACaption);
            AContentRectangle := TdxPDFRectangle.Create(ALeft, ABottom, AContentRectangle.Right, AContentRectangle.Top - ALineSpacing);
          end;
        wtpCaptionToTheRightOfTheIcon:
          begin
            DrawTextBox(AConstructor, ALeft + AContentRectangle.Width - ATextWidth, CalculateCenteredLineYOffset(AContentRectangle), ACaption);
            AContentRectangle := TdxPDFRectangle.Create(ALeft, ABottom, AContentRectangle.Right - ATextWidth, AContentRectangle.Top);
          end;
        wtpCaptionToTheLeftOfTheIcon:
          begin
            DrawTextBox(AConstructor, ALeft, CalculateCenteredLineYOffset(AContentRectangle), ACaption);
            AContentRectangle := TdxPDFRectangle.Create(ALeft + ATextWidth, ABottom, AContentRectangle.Right, AContentRectangle.Top);
          end;
        wtpCaptionOverlaidDirectlyOnTheIcon:
          begin
            DrawIcon(AConstructor, AContentRectangle);
            DrawCenteredTextBox(AConstructor, AContentRectangle, ATextWidth, ACaption);
            Exit;
          end;
        else
          DrawCenteredTextBox(AConstructor, AContentRectangle, ATextWidth, ACaption);
          Exit;
      end;
    end;
    DrawIcon(AConstructor, AContentRectangle);
  end;
end;

end.
