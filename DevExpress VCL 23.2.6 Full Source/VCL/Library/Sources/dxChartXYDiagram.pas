{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCharts                                            }
{                                                                    }
{           Copyright (c) 2020-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCHARTS AND ALL ACCOMPANYING    }
{   VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.              }
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

unit dxChartXYDiagram;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  System.UITypes,
{$IFDEF DELPHIXE8}
  System.Hash,
{$ENDIF}
  Types, Classes, SysUtils, Generics.Defaults, Generics.Collections, Windows, Controls, Graphics, Contnrs, Math, Forms,
  StdCtrls, dxCoreClasses, dxCore, cxGeometry, cxClasses, cxGraphics, cxControls, dxHash, dxTypeHelpers, dxCustomData,
  cxCustomCanvas, dxCoreGraphics, dxGDIPlusClasses, cxLookAndFeels, dxGenerics,
  dxChartCore, dxGDIPlusCanvas, dxSVGCanvas, dxGDIPlusAPI,
  dxChartRectanglesLayoutAlgorithm;

type
  TdxChartAxisAppearance = class;
  TdxChartAxisLinesViewInfo = class;
  TdxChartAxisViewInfo = class;
  TdxChartXYDiagram = class;
  TdxChartXYDiagramViewData = class;
  TdxChartXYDiagramViewInfo = class;
  TdxChartXYSeries = class;
  TdxChartXYSeriesCustomView = class;
  TdxChartXYSeriesValueViewInfo = class;
  TdxChartXYSeriesViewCustomViewData = class;
  TdxChartXYSeriesViewCustomViewInfo = class;
  TdxChartAxes = class;
  TdxChartSecondaryCustomAxes = class;
  TdxChartSecondaryAxes = class;
  TdxChartCustomAxis = class;
  TdxChartCustomAxisX = class;
  TdxChartAxisTickLabelViewInfo = class;
  TdxChartAxisValueLabels = class;
  TdxChartXYDiagramInterlacedViewInfo = class;
  
  TdxChartAxisAlignment = (Near, Far, Zero, Center);
  TdxChartAxisValueLabelPosition = (Outside, Inside);
  TdxChartAxisTicksCrossKind = (Outside, Cross, Inside);
  TdxChartAxisTitlePosition = (Outside, Inside);

  TdxChartSecondaryAxisAlignment = (Near, Far);

  TdxChartDataRange = record
  public
    Min: Double;
    Max: Double;

    function Range: Double;
  end;

  TdxChartForEachXYValueProc = reference to procedure(AValue: TdxChartXYSeriesValueViewInfo); // for internal use
  TdxChartValueToCanvasValueFunc = function(const AValue: Double): Single of object;

  { TdxChartRange }

  TdxChartRange = class(TdxChartOwnedPersistent)
  public type
    TZoomType = (FixedBearingValue, CenteredBearingValue, ResetZoom); // for internal use
  strict private
    FAutoSideMargins: Boolean;
    FAxis: TdxChartCustomAxis;
    FIsNonNumericScrollingActive: Boolean;
    FIsVisibleRangeLocked: Boolean;
    FVisibleMax: Variant;
    FVisibleMin: Variant;
    FWholeMax: Variant;
    FWholeMin: Variant;

    procedure CalculateRealWholeRange;
    procedure CalculateSideMargin;
    procedure CalculateVisibleRange;
    function GetVisibleRangeExtended: TdxChartDataRange;
    function GetWholeRangeExtended: TdxChartDataRange;

    procedure SetAutoSideMargins(const Value: Boolean);
    procedure SetSideMarginMax(AValue: Double);
    procedure SetSideMarginMin(AValue: Double);
    procedure SetVisibleMax(AValue: Variant);
    procedure SetVisibleMin(AValue: Variant);
    procedure SetWholeMax(AValue: Variant);
    procedure SetWholeMin(AValue: Variant);

    function IsVisibleMaxStored: Boolean;
    function IsVisibleMinStored: Boolean;
    function IsWholeMaxStored: Boolean;
    function IsWholeMinStored: Boolean;
  protected
    FActualSideMarginMax: Double;
    FActualSideMarginMin: Double;
    FSideMarginMax: Double;
    FSideMarginMin: Double;
    RealVisibleRange: TdxChartDataRange;
    RealWholeRange: TdxChartDataRange;

    constructor CreateUnattached(AAxis: TdxChartCustomAxis);
    procedure Calculate;
    procedure Changed; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetValueType: TVarType;
    function GetZoomPercent: Single;
    function IsAutoVisibleRange: Boolean;
    function IsAutoWholeRange: Boolean;
    function IsValidRangeBound(const AValue: Variant): Boolean;
    function IsZoomed: Boolean;
    procedure Zoom(AZoomType: TZoomType; AStepPercent: Single; AStepCount: Integer; AMaxPercent: Single; ABearingAxisValue: Double);
    procedure ZoomIn(AVisibleMin, AVisibleMax: Double; AMaxPercent: Single);

    property Axis: TdxChartCustomAxis read FAxis;
    property IsNonNumericScrollingActive: Boolean read FIsNonNumericScrollingActive write FIsNonNumericScrollingActive;
    property VisibleRangeExtended: TdxChartDataRange read GetVisibleRangeExtended;
    property WholeRangeExtended: TdxChartDataRange read GetWholeRangeExtended;
  public
    constructor Create(AOwner: TPersistent); override;
    property ActualSideMarginMax: Double read FActualSideMarginMax;
    property ActualSideMarginMin: Double read FActualSideMarginMin;
  published
    property AutoSideMargins: Boolean read FAutoSideMargins write SetAutoSideMargins default True;
    property SideMarginMax: Double read FSideMarginMax write SetSideMarginMax;
    property SideMarginMin: Double read FSideMarginMin write SetSideMarginMin;
    property VisibleMax: Variant read FVisibleMax write SetVisibleMax stored IsVisibleMaxStored;
    property VisibleMin: Variant read FVisibleMin write SetVisibleMin stored IsVisibleMinStored;
    property WholeMax: Variant read FWholeMax write SetWholeMax stored IsWholeMaxStored;
    property WholeMin: Variant read FWholeMin write SetWholeMin stored IsWholeMinStored;
  end;

  { TdxChartAxisDataValueConverter }

  TdxChartAxisDataValueConverter = class
  public
    function AxisValueToDataValue(const AValue: Double): Double; virtual;
    function DataValueToAxisValue(const AValue: Double): Double; virtual;
  end;

  { TdxChartLogarithmicAxisDataValueConverter }

  TdxChartLogarithmicAxisDataValueConverter = class(TdxChartAxisDataValueConverter)
  strict private
    FLogarithmBase: Double;
  public
    constructor Create(const ALogarithmBase: Double);
    function AxisValueToDataValue(const AValue: Double): Double; override;
    function DataValueToAxisValue(const AValue: Double): Double; override;
  end;

  { TdxChartAxisLineViewInfo }

  TdxChartAxisLineViewInfoClass = class of TdxChartAxisLineViewInfo;
  TdxChartAxisLineViewInfo = class
  strict private
    FBounds: TdxRectF;
    FFinish: TdxPointF;
    FStart: TdxPointF;
    FVisible: Boolean;
  public
    constructor Create(AOwner: TdxChartAxisLinesViewInfo); virtual;
    procedure Offset(const ADistance: TdxPointF); virtual;
    procedure UpdateBounds(const ABounds: TdxRectF; const AStart, AFinish: TdxPointF); inline;
    //
    property Bounds: TdxRectF read FBounds;
    property Finish: TdxPointF read FFinish;
    property Start: TdxPointF read FStart;
    property Visible: Boolean read FVisible write FVisible;
  end;

  { TdxChartAxisLinesViewInfo }

  TdxChartAxisLinesViewInfo = class(TdxChartCustomItemViewInfo)
  strict private
    FOwner: TdxChartAxisViewInfo;

    function GetCount: Integer; inline;
    function GetItem(Index: Integer): TdxChartAxisLineViewInfo; inline;
  strict protected
    FItemViewInfoClass: TdxChartAxisLineViewInfoClass;
    FList: TdxFastObjectList;

    function GetActualPen: TcxCanvasBasedPen; virtual; abstract;
  protected
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
  public
    constructor Create(AOwner: TdxChartAxisViewInfo); virtual;
    destructor Destroy; override;
    function Add: TdxChartAxisLineViewInfo;
    procedure CalculateBounds(const AVisibleBounds: TdxRectF);
    procedure Clear;
    procedure EnsureCapacity(ACount: Integer);
    procedure Offset(const ADistance: TdxPointF); override;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxChartAxisLineViewInfo read GetItem; default;
    property Owner: TdxChartAxisViewInfo read FOwner;
  end;

  { TdxChartAxisCustomTickViewInfo }

  TdxChartAxisCustomTickViewInfo = class(TdxChartAxisLineViewInfo)
  strict private
    FAxis: TdxChartCustomAxis;
    FAxisValue: Double;
    FCanvasValue: Single;

    function GetDataValue: Double;
  public
    constructor Create(AOwner: TdxChartAxisLinesViewInfo); override;

    property Axis: TdxChartCustomAxis read FAxis;
    property AxisValue: Double read FAxisValue write FAxisValue;
    property CanvasValue: Single read FCanvasValue write FCanvasValue;
    property DataValue: Double read GetDataValue;
  end;

  { TdxChartAxisMinorTickViewInfo }

  TdxChartAxisMinorTickViewInfo = class(TdxChartAxisCustomTickViewInfo);

  { TdxChartAxisTickViewInfo }

  TdxChartAxisTickViewInfo = class(TdxChartAxisCustomTickViewInfo)
  strict private
    FInVisibleArea: Boolean;
  protected
    FLabel: TdxChartAxisTickLabelViewInfo;
  public
    property &Label: TdxChartAxisTickLabelViewInfo read FLabel;
    property InVisibleArea: Boolean read FInVisibleArea write FInVisibleArea;
  end;

  { TdxChartAxisTickDockedObjectViewInfo }

  TdxChartAxisTickDockedObjectViewInfo = class(TdxChartCustomItemViewInfo)
  strict private
    FAxisTick: TdxChartAxisCustomTickViewInfo;
  public
    constructor Create(AAxisTick: TdxChartAxisCustomTickViewInfo); virtual;

    property AxisTick: TdxChartAxisCustomTickViewInfo read FAxisTick;
  end;

  { TdxChartAxisTickLabelViewInfo }

  TdxChartAxisTickLabelViewInfo = class(TdxChartAxisTickDockedObjectViewInfo)
  public const
    GDIToGDIPlusTextWidthCompensation = 4;
  strict private
    FArea: TdxPolygonF;
    FAreaBox: TdxRectF;
    FBoundsBox: TdxRectF;
    FRotatedBounds: TdxPolygonF;
    FRotationMatrix: TdxGPMatrix;
    FTextLayout: TcxCanvasBasedTextLayout;
    FTextBounds: TdxRectF;

    function CreateRotatedFontBrush: TdxGPBrush;
    function CreateRotatedFontStyle: TdxGPFontStyle;
    function CreateRotatedFont: TdxGPFont;
    function CreateRotatedFontStringFormat: TdxGPStringFormat;

    function GetAxisValueLabels: TdxChartAxisValueLabels;
    function GetText: string;
    function GetTextAngle: Single; virtual;
    function GetSize: TdxSizeF;
    function GetWordWrap: Boolean;
    procedure SetText(const AValue: string);
  protected
    function CalculateArea(const ABounds: TdxRectF): TdxRectF;
    function CalculateTextFlags: Cardinal; virtual;
    procedure CalculateRotationMatrix;
    procedure CalculateTextLayout; virtual;
    procedure CreateTextLayout(ACanvas: TcxCustomCanvas);
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    function GetFont: TcxCanvasBasedFont; virtual;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetTextAlignment: TdxAlignment; virtual;
    function GetTextColor: TdxAlphaColor; virtual;
    function GetTextLayoutConstraints: TdxRectF; virtual;
    function IsOccupied(const R: TdxRectF; AAxis: TdxChartCustomAxis; ACheckArea: Boolean): Boolean;
    function MeasureGPTextSize: TdxSizeF;
    function MeasureTextSize: TdxSizeF;
    procedure OffsetForRotate;

    property Options: TdxChartAxisValueLabels read GetAxisValueLabels;
  public
    constructor Create(AAxisTick: TdxChartAxisCustomTickViewInfo); override;
    destructor Destroy; override;
    procedure Offset(const ADistance: TdxPointF); override;
    procedure SetBounds(const ABounds, AVisibleBounds: TdxRectF); override;

    property Area: TdxPolygonF read FArea;
    property AreaBox: TdxRectF read FAreaBox;
    property BoundsBox: TdxRectF read FBoundsBox;
    property Text: string read GetText write SetText;
    property TextAngle: Single read GetTextAngle;
    property TextBounds: TdxRectF read FTextBounds;
    property Size: TdxSizeF read GetSize;
    property WordWrap: Boolean read GetWordWrap;
  end;

  { TdxChartAxisCustomTicksViewInfo }

  TdxChartAxisCustomTicksViewInfo = class(TdxChartAxisLinesViewInfo)
  strict protected
    FInterval: Single;
  protected
    FFinish: Single;
    FStart: Single;
  public
    function Add: TdxChartAxisCustomTickViewInfo; inline;
    procedure CalculateInterval; virtual; abstract;
    procedure Offset(const ADistance: TdxPointF); override;

    property Finish: Single read FFinish;
    property Interval: Single read FInterval;
    property Start: Single read FStart;
  end;

  { TdxChartAxisTicksViewInfo }

  TdxChartAxisTicksViewInfo = class(TdxChartAxisCustomTicksViewInfo)
  strict private
    function GetItem(Index: Integer): TdxChartAxisTickViewInfo; inline;
  protected
    function GetActualPen: TcxCanvasBasedPen; override;
  public
    constructor Create(AOwner: TdxChartAxisViewInfo); override;
    procedure CalculateInterval; override;

    property Items[Index: Integer]: TdxChartAxisTickViewInfo read GetItem; default;
  end;

  { TdxChartAxisMinorTicksViewInfo }

  TdxChartAxisMinorTicksViewInfo = class(TdxChartAxisCustomTicksViewInfo)
  strict private
    function GetItem(Index: Integer): TdxChartAxisMinorTickViewInfo; inline;
  protected
    function GetActualPen: TcxCanvasBasedPen; override;
  public
    constructor Create(AOwner: TdxChartAxisViewInfo); override;
    procedure CalculateInterval; override;

    property Items[Index: Integer]: TdxChartAxisMinorTickViewInfo read GetItem; default;
  end;

  { TdxChartAxisGridlineViewInfo }

  TdxChartAxisGridlineViewInfo = class(TdxChartAxisLineViewInfo)
  protected
    FAxisTick: TdxChartAxisCustomTickViewInfo;
  public
    property AxisTick: TdxChartAxisCustomTickViewInfo read FAxisTick;
  end;

  { TdxChartAxisGridlinesViewInfo }

  TdxChartAxisGridlinesViewInfo = class(TdxChartAxisLinesViewInfo)
  strict private
    function GetItem(Index: Integer): TdxChartAxisGridlineViewInfo; inline;
  protected
    function GetActualPen: TcxCanvasBasedPen; override;
  public
    constructor Create(AOwner: TdxChartAxisViewInfo); override;
    function Add(ATick: TdxChartAxisCustomTickViewInfo): TdxChartAxisGridlineViewInfo;
    property Items[Index: Integer]: TdxChartAxisGridlineViewInfo read GetItem; default;
  end;

  { TdxChartAxisMinorGridlinesViewInfo }

  TdxChartAxisMinorGridlinesViewInfo = class(TdxChartAxisGridlinesViewInfo)
  protected
    function GetActualPen: TcxCanvasBasedPen; override;
  end;

  { TdxChartAxisViewData }

  TdxChartAxisViewData = class(TdxChartCustomItemViewData)
  strict private
    FAxis: TdxChartCustomAxis;
    FCalculatedStep: Double;
    FScalePrecision: Integer;
    FStepMap: TDoubleDynArray;
    FTickCount: Integer;
    FTickStart: Double;
    FTickFinish: Double;

    procedure CalculateScalePrecision;
    procedure CalculateStep;
    procedure CalculateTicks;
    function GetDiagram: TdxChartXYDiagram;
    function GetOptimalTickStep(ARange: TdxChartRange): Double;
    function GetRange: TdxChartRange;
  protected
    procedure CalculateRanges;
    procedure DoCalculate; override;
    procedure DoOffsetVisualRange(const ADistance: Double); virtual;
    function GetMax: Double; virtual;
    function GetMin: Double; virtual;
    function GetTickStep(ARange: TdxChartRange): Double;
    function GetValueAsText(const AValue: Variant): string; virtual;
    procedure OffsetVisualRange(ADistance: Double; out ARangeChanged: Boolean);

    property CalculatedStep: Double read FCalculatedStep;
    property ScalePrecision: Integer read FScalePrecision;
    property StepMap: TDoubleDynArray read FStepMap;
    property TickCount: Integer read FTickCount;
    property TickFinish: Double read FTickFinish;
    property TickStart: Double read FTickStart;
  public
    constructor Create(AAxis: TdxChartCustomAxis); virtual;
    function AxisValueAsDouble(const AValue: Variant): Double; virtual;
    function DoubleToAxisValue(const AValue: Double): Variant; virtual;

    property Axis: TdxChartCustomAxis read FAxis;
    property Diagram: TdxChartXYDiagram read GetDiagram;
    property Range: TdxChartRange read GetRange;
  end;

  { TdxChartAxisXViewData }

  TdxChartAxisXViewData = class(TdxChartAxisViewData)
  protected type

    TStringValuesHandler = class
    strict private
      function GetCount: Integer;
    protected
      FOwner: TdxChartAxisXViewData;
      FValues: TdxFastObjectList;
      FValuesMap: TObjectDictionary<TdxChartXYSeriesValueViewInfo, Integer>;
    public
      constructor Create(AOwner: TdxChartAxisXViewData);
      destructor Destroy; override;
      procedure Calculate;
      procedure Clear;
      function GetNearestValueAsText(const AValue: Double): string;
      function GetValueAsText(const AValue: Integer): string;
      function GetValueAsDouble(const ADisplayText: string): Double;

      property Count: Integer read GetCount;
    end;

  strict private
    FStringValuesHandler: TStringValuesHandler;
    FValuesDirty: Boolean;
    function GetAxis: TdxChartCustomAxisX; inline;
  protected
    FMax: Double;
    FMin: Double;
    procedure AsyncCalculateValues; virtual;
    procedure DoCalculate; override;
    procedure DoOffsetVisualRange(const ADistance: Double); override;
    procedure ForEachValue(AProc: TdxChartForEachXYValueProc);
    function GetMax: Double; override;
    function GetMin: Double; override;
    function GetValueAsText(const AValue: Variant): string; override;
    function IsNumeric: Boolean;

    property Axis: TdxChartCustomAxisX read GetAxis;
    property StringValuesHandler: TStringValuesHandler read FStringValuesHandler;
    property ValuesDirty: Boolean read FValuesDirty write FValuesDirty;
  public
    constructor Create(AAxis: TdxChartCustomAxis); override;
    destructor Destroy; override;
    function AxisValueAsDouble(const AValue: Variant): Double; override;
    function DoubleToAxisValue(const AValue: Double): Variant; override;
  end;

  { TdxChartAxisViewInfoCalculationHelper }

  TdxChartAxisViewInfoCalculationHelperClass = class of TdxChartAxisViewInfoCalculationHelper;
  TdxChartAxisViewInfoCalculationHelper = class
  protected const
    ValueIncrement: array[Boolean] of Integer = (-1, 1);
  protected
    class function GetSign: TValueSign; virtual;
    class function IsCenter: Boolean; virtual;
    class function IsFar: Boolean; virtual;
    class function IsHorizontal: Boolean; virtual;
    class function IsNear: Boolean; virtual;
    class procedure ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single); virtual;
    class procedure ExpandNearTransversalBorder(var ABounds: TdxRectF; dValue: Single); virtual;
    class function GetLongitudinalSize(const ASize: TdxSizeF): Single; virtual;
    class function GetTransversalSize(const ASize: TdxSizeF): Single; virtual;
    class function GetFarTransversalValue(const R: TdxRectF): Single; virtual;
    class function GetNearTransversalValue(const R: TdxRectF): Single; virtual;
    class procedure SetFarLongitudinalValue(var R: TdxRectF; AValue: Single); virtual;
    class procedure SetFarTransversalValue(var R: TdxRectF; AValue: Single); virtual;
    class procedure SetNearLongitudinalValue(var R: TdxRectF; AValue: Single); virtual;
    class procedure SetNearTransversalValue(var R: TdxRectF; AValue: Single); virtual;
    class function AxisIncludesTickmark(AViewInfo: TdxChartAxisViewInfo; ATickmark: TdxChartAxisCustomTickViewInfo): Boolean; virtual;
    class procedure CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo; out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF); virtual;
    class procedure CalculateLineEnds(AViewInfo: TdxChartAxisViewInfo; AAnchor, AThickness: Single; const ALineBounds: TdxRectF; var AStart, AFinish: TdxPointF); virtual;
    class procedure CalculateViewpoint(AAxis: TdxChartCustomAxis;
      const ABounds: TdxRectF; out AOffset: Single; out AOffsetDirection: TValueSign); virtual;
    class function GetActualTitlePosition(AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition; virtual;
    class function GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF; virtual;
    class function GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF; virtual;
    class function GetAxisLineProjectionCanvasValue(AViewInfo: TdxChartAxisViewInfo): Single; virtual;
    class function GetInterlacedBounds(AStart, AFinish: Single; const APattern: TdxRectF): TdxRectF; virtual;
    class function GetLabelsAreaTransversalSize(AViewInfo: TdxChartAxisViewInfo): Single; virtual;
    class function GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single; virtual;
    class function GetLabelRectStart(AViewInfo: TdxChartAxisViewInfo; ATickCanvasValue, ATextLongitudinalSize: Single; ALabelAlignment: TdxAlignment): Single; virtual;
    class function GetOccupiedSides(AViewInfo: TdxChartAxisViewInfo; const AArea: TdxRectF): TcxBorders; virtual;
    class function GetTransversalOffsetDistance(AOffset: Single): TdxPointF; virtual;
    class procedure IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo; var ABounds: TdxRectF); virtual;
    class function LabelsAreaCanIntersectsWith(const R: TdxRectF; AViewInfo: TdxChartAxisViewInfo): Boolean; virtual;
    class procedure ResolveOverlapping(AViewInfo: TdxChartAxisViewInfo); virtual;
    class function SelectFarFromBorder(AViewInfo: TdxChartAxisViewInfo; const R1, R2: TdxRectF): TdxRectF; virtual;
    class procedure UpdateGridline(AViewInfo: TdxChartAxisViewInfo; AGridline: TdxChartAxisGridlineViewInfo; const APlotArea: TdxRectF); virtual;
    class procedure UpdateInterlaced(AViewInfo: TdxChartAxisViewInfo; AInterlaced: TdxChartXYDiagramInterlacedViewInfo; const APlotArea: TdxRectF); virtual;
  end;

  { TdxChartAxisViewInfo }

  TdxChartAxisViewInfo = class(TdxChartVisualElementCustomViewInfo)
  strict private
    FActualSecondaryAxisIndent: Single;
    FActualTickInterval: Single;
    FAvailableBounds: TdxRectF;
    FAxis: TdxChartCustomAxis;
    FAxisLineFinish: TdxPointF;
    FAxisLineRect: TdxRectF;
    FAxisLineStart: TdxPointF;
    FCalculationHelper: TdxChartAxisViewInfoCalculationHelperClass;
    FGridlines: TdxChartAxisGridlinesViewInfo;
    FGridlinesFinish: Single;
    FGridlinesStart: Single;
    FInterlacedItems: TdxFastObjectList;
    FIsScrollBarEnabled: Boolean;
    FLabels: TdxFastObjectList;
    FLabelsArea: TdxRectF;
    FLabelsAreaStart: Single;
    FLabelsAreaTransversalSize: Single;
    FMinorGridlines: TdxChartAxisGridlinesViewInfo;
    FMinorTicks: TdxChartAxisMinorTicksViewInfo;
    FTicks: TdxChartAxisTicksViewInfo;
    FTitleOuterAreaSize: Single;

    FAxisScaleFactor: Double;
    FIsVisibleRangeValid: Boolean;
    FMaxAxisValue: Double;
    FMinAxisValue: Double;
    FViewpointOffset: Double;
    FViewpointScaleFactor: Double;

    procedure AddGridlineAndInterlaced(AAxisTick, APriorTick: TdxChartAxisTickViewInfo;
      AThickness, AHalfThickness: Single; const APlotArea: TdxRectF; var ACurrentInterlaced: Boolean); inline;
    procedure CalculateAxisLine;
    procedure CalculateAxisTickDockedObjects;
    procedure CalculateBounds;
    procedure CalculateGridline(AGridline: TdxChartAxisGridlineViewInfo;
      ACanvasValue, AThickness, AHalfThickness: Single; const APlotArea: TdxRectF); inline;
    procedure CalculateGridlinesStartAndFinish(const APlotArea: TdxRectF);
    procedure CalculateMinorTicksStartAndFinish;
    procedure CalculateMinorTicksAndGridlines(const APlotArea, AVisibleBounds: TdxRectF);
    procedure CalculateTickIntervals;
    function GetLabelBounds(AAxisTick: TdxChartAxisTickViewInfo; ALabelAlignment: TdxAlignment): TdxRectF; overload; inline;
    procedure CalculateTickMarkLine(ATick: TdxChartAxisCustomTickViewInfo; AMinorTick: Boolean;
      AThickness, AHalfThickness: Single; const AVisibleBounds: TdxRectF); inline;
    procedure CalculateTicksStartAndFinish;
    procedure CalculateTitle(ACanvas: TcxCustomCanvas; const AAvailableArea: TdxRectF);
    procedure IncludeInnerTitleAndLabelsInBounds;
    procedure SetTicksAndLabelsCount(ACount: Integer);

    function GetAppearance: TdxChartAxisAppearance; inline;
    function GetInterlaced(AIndex: Integer): TdxChartXYDiagramInterlacedViewInfo;
    function GetLabel(AIndex: Integer): TdxChartAxisTickLabelViewInfo;
    function GetValueLabels: TdxChartAxisValueLabels;
    function GetViewData: TdxChartAxisViewData;
  protected
    function CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean; override;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure EnableExportMode(AEnable: Boolean); override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;

    procedure ResolveLabelsOverlapping(ACompetingAxis: TdxChartCustomAxis; ACompetingSecondaryAxes: TdxChartSecondaryCustomAxes);
    procedure CorrectAvailableArea(var AArea: TdxRectF);
    function GetActualThickness: Single;
    function GetActualTitlePosition: TdxChartTitlePosition;
    function GetAvailableAreaForTitle: TdxRectF;
    function GetAxisBounds: TdxRectF;
    function GetAxisLineProjectionCanvasValue: Single;
    function GetCanvasZeroValue(const AActualBounds: TdxRectF): Single;
    function GetGridlineRect(ACanvasValue, AHalfThickness: Single): TdxRectF;
    function GetInsideTickMarkMaxLength: Single;
    function GetInterlacedBounds(AStart, AFinish: Single; const APattern: TdxRectF): TdxRectF;
    function GetLabelsAreaStart: Single;
    function GetLabelPadding: Single;
    function GetLabelRectStart(ATickCanvasValue, ATextLongitudinalSize: Single; ALabelAlignment: TdxAlignment): Single;
    function GetOccupiedSides(const AArea: TdxRectF): TcxBorders;
    function GetOutsideTickMarkMaxLength: Single;
    function GetOuterTransversalSize: Single;
    function GetTickStart(const ACrossKind: TdxChartAxisTicksCrossKind; var AActualTickLength: Single): Single;
    function GetTickMarkVisibleBounds: TdxRectF;
    function GetVisibleAreaSize: Single;
    procedure HideCrossedLabels;
    procedure HideLabels;
    function IncludesTickmark(AAxisTick: TdxChartAxisCustomTickViewInfo): Boolean;
    function IsLabelsCrossed: Boolean;
    function IsTickInVisibleArea(const AAxisValue: Double): Boolean; inline;
    function IsTickLabelsRotated: Boolean;
    function LabelsAreaCanIntersectsWith(const R: TdxRectF): Boolean;
    procedure PrepareCalculation(ACanvas: TcxCustomCanvas);
    procedure RaiseGetAxisValueLabelDrawParametersEvent(const AAxisValue: Variant; var AText: string);
    procedure RecalculateLabelAreaTransversalSize;
    procedure ResolveOverlapping;
    procedure SetAvailableBounds(const ABounds: TdxRectF; const AMakeDirty: Boolean);
    procedure TryMoveLabel(var ALabel: TdxChartAxisTickLabelViewInfo; ACompetingAxis: TdxChartCustomAxis; ACompetingSecondaryAxes: TdxChartSecondaryCustomAxes);
    procedure UpdateActualSecondaryAxisIndent(AValue: Single);
    procedure UpdateCalculationHelper;
    procedure UpdateGridlinesAndInterlacedItems(const APlotArea: TdxRectF);
    procedure UpdateLabelsArea;

    function GetFarTransversalValue(const R: TdxRectF): Single;
    function GetNearTransversalValue(const R: TdxRectF): Single;
    function GetLongitudinalSize(const ASize: TdxSizeF): Single;
    function GetTransversalSize(const ASize: TdxSizeF): Single;
    function GetSign: TValueSign;
    function GetTransversalOffsetDistance(AOffset: Single): TdxPointF;
    function IsCentered: Boolean;
    procedure SetFarLongitudinalValue(var R: TdxRectF; AValue: Single);
    procedure SetFarTransversalValue(var R: TdxRectF; AValue: Single);
    procedure SetNearLongitudinalValue(var R: TdxRectF; AValue: Single);
    procedure SetNearTransversalValue(var R: TdxRectF; AValue: Single);

    procedure CalculateViewpoint(const R: TdxRectF); overload; inline;
    procedure CalculateViewpoint; overload; inline;
    procedure CalculateVisibleRange(const AAxisSize: Single); overload; inline;
    procedure CalculateVisibleRange; overload; inline;
    function GetZoomPercent: Single;

    property ActualSecondaryAxisIndent: Single read FActualSecondaryAxisIndent;
    property ActualTickInterval: Single read FActualTickInterval;
    property Appearance: TdxChartAxisAppearance read GetAppearance;
    property AvailableBounds: TdxRectF read FAvailableBounds;
    property AxisLineFinish: TdxPointF read FAxisLineFinish;
    property AxisLineRect: TdxRectF read FAxisLineRect;
    property AxisLineStart: TdxPointF read FAxisLineStart;
    property CalculationHelper: TdxChartAxisViewInfoCalculationHelperClass read FCalculationHelper;
    property Gridlines: TdxChartAxisGridlinesViewInfo read FGridlines;
    property Interlaced[Index: Integer]: TdxChartXYDiagramInterlacedViewInfo read GetInterlaced;
    property InterlacedItems: TdxFastObjectList read FInterlacedItems;
    property &Label[Index: Integer]: TdxChartAxisTickLabelViewInfo read GetLabel;
    property Labels: TdxFastObjectList read FLabels;
    property LabelsArea: TdxRectF read FLabelsArea;
    property LabelsAreaStart: Single read FLabelsAreaStart;
    property LabelsAreaTransversalSize: Single read FLabelsAreaTransversalSize;
    property MinorGridlines: TdxChartAxisGridlinesViewInfo read FMinorGridlines;
    property MinorTicks: TdxChartAxisMinorTicksViewInfo read FMinorTicks;
    property Ticks: TdxChartAxisTicksViewInfo read FTicks;
    property ValueLabels: TdxChartAxisValueLabels read GetValueLabels;
    property VisibleAreaSize: Single read GetVisibleAreaSize;
    property IsVisibleRangeValid: Boolean read FIsVisibleRangeValid;
    property MaxAxisValue: Double read FMaxAxisValue;
    property MinAxisValue: Double read FMinAxisValue;
  public
    constructor Create(AOwner: TdxChartCustomAxis); reintroduce; virtual;
    destructor Destroy; override;
    function AxisValueToCanvasValue(const AValue: Double): Single; inline;
    function CanvasValueToAxisValue(const AValue: Single): Double;
    function CanvasValueToDataValue(const AValue: Single): Double;
    function DataValueToCanvasValue(const AValue: Double): Single;
    function GetCrosshairLabelsArea: TdxRectF;
    function GetLabelBounds(ALabelSize: TdxSizeF; ACanvasValue: Single; ALabelAlignment: TdxAlignment): TdxRectF; overload; inline;
    function IsNumeric: Boolean;
    procedure Offset(const ADistance: TdxPointF); override;
    procedure SetBounds(const ABounds: TdxRectF; const AVisibleBounds: TdxRectF); override;
    procedure UpdateBounds(const ABounds: TdxRectF); override;
    property Axis: TdxChartCustomAxis read FAxis;
    property IsScrollBarEnabled: Boolean read FIsScrollBarEnabled;
    property ViewData: TdxChartAxisViewData read GetViewData;
  end;

  { TdxChartAxisAppearance }

  TdxChartAxisAppearance = class(TdxChartVisualElementAppearance)
  strict private
    FActualMinorTickPen: TcxCanvasBasedPen;
    FActualTickPen: TcxCanvasBasedPen;
    procedure FreeHandles;
    function GetAxis: TdxChartCustomAxis; inline;
    function GetColor: TdxAlphaColor; inline;
    function GetThickness: Single; inline;
    function GetInterlacedFillOptions: TdxFillOptions;
    function IsThicknessStored: Boolean;
    procedure SetColor(AValue: TdxAlphaColor);
    procedure SetInterlacedFillOptions(AValue: TdxFillOptions);
    procedure SetThickness(AValue: Single);
  protected const
    DefaultThickness: Single = 1;
  protected
    function DefaultBorderThickness: Single; override;
    function DefaultParentBackground: Boolean; override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function HasFillOptions: Boolean; override;
    function HasStrokeOptions: Boolean; override;
    procedure UpdateActualValues(ACanvas: TcxCustomCanvas); override;

    property Axis: TdxChartCustomAxis read GetAxis;
    property ActualMinorTickPen: TcxCanvasBasedPen read FActualMinorTickPen;
    property ActualTickPen: TcxCanvasBasedPen read FActualTickPen;
  public
    destructor Destroy; override;
  published
    property Color: TdxAlphaColor read GetColor write SetColor default TdxAlphaColors.Default;
    property InterlacedFillOptions: TdxFillOptions read GetInterlacedFillOptions write SetInterlacedFillOptions;
    property Thickness: Single read GetThickness write SetThickness stored IsThicknessStored;
  end;

  { TdxChartAxisTitle }

  TdxChartAxisTitle = class(TdxChartVisualElementTitle)
  strict private
    FPosition: TdxChartAxisTitlePosition;
    function GetAxis: TdxChartCustomAxis;
    procedure SetPosition(AValue: TdxChartAxisTitlePosition);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetActualDockPosition: TdxChartTitlePosition; override;
    class function GetHitCode: TdxChartHitCode; override;
    function GetOwnerComponent: TComponent; override;
  public
    property Axis: TdxChartCustomAxis read GetAxis;
  published
    property Position: TdxChartAxisTitlePosition read FPosition write SetPosition default TdxChartAxisTitlePosition.Outside;
    property Text;
  end;

  { TdxChartAxisNumericScaleOptions }

  TdxChartAxisNumericScaleOptions = class(TdxChartOwnedPersistent)
  private
    FOffset: Double;
    FStep: Double;

    function IsStepStored: Boolean;
    function IsOffsetStored: Boolean;
    procedure SetOffset(AValue: Double);
    procedure SetStep(AValue: Double);
  protected
    procedure DoAssign(Source: TPersistent); override;
  published
    property Offset: Double read FOffset write SetOffset stored IsOffsetStored;
    property Step: Double read FStep write SetStep stored IsStepStored;
  end;

  { TdxChartAxisTicks }

  TdxChartAxisTicks = class(TcxLockablePersistent)
  strict private
    FCrossKind: TdxChartAxisTicksCrossKind;
    FLabelAlignment: TdxAlignment;
    FLength: Single;
    FMinorCrossKind: TdxChartAxisTicksCrossKind;
    FMinorLength: Single;
    FMinorThickness: Single;
    FMinorVisible: Boolean;
    FThickness: Single;
    FVisible: Boolean;
    function GetAxis: TdxChartCustomAxis;
    function IsLengthStored: Boolean;
    function IsMinorLengthStored: Boolean;
    function IsMinorThicknessStored: Boolean;
    function IsThicknessStored: Boolean;
    procedure SetCrossKind(AValue: TdxChartAxisTicksCrossKind);
    procedure SetLabelAlignment(AValue: TdxAlignment);
    procedure SetLength(AValue: Single);
    procedure SetMinorCrossKind(AValue: TdxChartAxisTicksCrossKind);
    procedure SetMinorLength(AValue: Single);
    procedure SetMinorThickness(AValue: Single);
    procedure SetMinorVisible(AValue: Boolean);
    procedure SetThickness(AValue: Single);
    procedure SetVisible(AValue: Boolean);
  protected const
    DefaultLength: Single = 5;
    DefaultMinorLength: Single = 2;
    DefaultThickness: Single = 1;
  protected
    procedure ChangeScale(M, D: Integer); virtual;
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;

    property Axis: TdxChartCustomAxis read GetAxis;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property CrossKind: TdxChartAxisTicksCrossKind read FCrossKind write SetCrossKind default TdxChartAxisTicksCrossKind.Outside;
    property LabelAlignment: TdxAlignment read FLabelAlignment write SetLabelAlignment default TdxAlignment.Default;
    property Length: Single read FLength write SetLength stored IsLengthStored;
    property MinorCrossKind: TdxChartAxisTicksCrossKind read FMinorCrossKind write SetMinorCrossKind default TdxChartAxisTicksCrossKind.Outside;
    property MinorLength: Single read FMinorLength write SetMinorLength stored IsMinorLengthStored;
    property MinorThickness: Single read FMinorThickness write SetMinorThickness stored IsMinorThicknessStored;
    property MinorVisible: Boolean read FMinorVisible write SetMinorVisible default True;
    property Thickness: Single read FThickness write SetThickness stored IsThicknessStored;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  { TdxChartAxisValueLabelsAppearance }

  TdxChartAxisValueLabelsAppearance = class(TdxChartCustomLabelsAppearance)
  protected
    function DefaultParentBackground: Boolean; override;
    procedure UpdateActualValues(ACanvas: TcxCustomCanvas); override;
  published
    property Padding;
    property TextColor;
  end;

  { TdxChartAxisValueLabels }

  TdxChartAxisValueLabels = class(TdxChartCustomLabels)
  strict private
    FPosition: TdxChartAxisValueLabelPosition;

    function GetAppearance: TdxChartAxisValueLabelsAppearance; inline;
    function GetAxis: TdxChartCustomAxis;
    procedure SetAppearance(AValue: TdxChartAxisValueLabelsAppearance);
    procedure SetPosition(AValue: TdxChartAxisValueLabelPosition);
  protected const
    DefaultMargins = 3;
    DefaultResolveOverlappingIndent = 5;
  protected
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function GetDefaultResolveOverlappingIndent: Single; override;

    property Axis: TdxChartCustomAxis read GetAxis;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property Appearance: TdxChartAxisValueLabelsAppearance read GetAppearance write SetAppearance;
    property Position: TdxChartAxisValueLabelPosition read FPosition write SetPosition default TdxChartAxisValueLabelPosition.Outside;

    property Angle;
    property MaxLineCount;
    property MaxWidth;
    property ResolveOverlappingIndent;
    property TextAlignment;
    property TextFormat;
    property Visible;
  end;

  { TdxChartAxisGridlines }

  TdxChartAxisGridlines = class(TdxChartVisualElementAppearance)
  strict private
    FActualMinorGridlinePen: TcxCanvasBasedPen;
    FMinorGridlineStrokeOptions: TdxStrokeOptions;
    FMinorVisible: Boolean;
    FVisible: Boolean;
    function GetAxis: TdxChartCustomAxis;
    function GetColor: TdxAlphaColor;
    function GetMinorColor: TdxAlphaColor;
    function GetMinorStyle: TdxStrokeStyle;
    function GetMinorThickness: Single;
    function GetStyle: TdxStrokeStyle;
    function GetThickness: Single;
    function IsMinorThicknessStored: Boolean;
    function IsMinorVisibleStored: Boolean;
    function IsThicknessStored: Boolean;
    function IsVisibleStored: Boolean;
    procedure SetColor(AValue: TdxAlphaColor);
    procedure SetMinorColor(AValue: TdxAlphaColor);
    procedure SetMinorStyle(AValue: TdxStrokeStyle);
    procedure SetMinorThickness(AValue: Single);
    procedure SetMinorVisible(AValue: Boolean);
    procedure SetStyle(AValue: TdxStrokeStyle);
    procedure SetThickness(AValue: Single);
    procedure SetVisible(AValue: Boolean);
  protected const
    GridlineColorIndex = TdxChartVisualElementAppearance.TextColorIndex + 1;
    MinorGridlineColorIndex = GridlineColorIndex + 1;
  protected
    procedure ChangeScaleCore(M, D: Integer); override;
    function DefaultMinorGridlineColor: TdxAlphaColor;
    procedure DoAssign(Source: TPersistent); override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function GetColorCount: Integer; override;
    function HasStrokeOptions: Boolean; override;
    procedure UpdateActualValues(ACanvas: TcxCustomCanvas); override;

    property ActualMinorGridlinePen: TcxCanvasBasedPen read FActualMinorGridlinePen;
    property MinorGridlineStrokeOptions: TdxStrokeOptions read FMinorGridlineStrokeOptions;
    property Axis: TdxChartCustomAxis read GetAxis;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property Color: TdxAlphaColor read GetColor write SetColor default TdxAlphaColors.Default;
    property MinorColor: TdxAlphaColor read GetMinorColor write SetMinorColor default TdxAlphaColors.Default;
    property MinorStyle: TdxStrokeStyle read GetMinorStyle write SetMinorStyle default TdxStrokeStyle.Solid;
    property MinorThickness: Single read GetMinorThickness write SetMinorThickness stored IsMinorThicknessStored;
    property MinorVisible: Boolean read FMinorVisible write SetMinorVisible stored IsMinorVisibleStored;
    property Style: TdxStrokeStyle read GetStyle write SetStyle default TdxStrokeStyle.Solid;
    property Thickness: Single read GetThickness write SetThickness stored IsThicknessStored;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored;
  end;

  TdxChartCrosshairAxisLabelAppearance = class(TdxChartVisualElementAppearance)
  strict private
    function GetFontOptions: TdxChartVisualElementFontOptions;
    procedure SetFontOptions(AValue: TdxChartVisualElementFontOptions);
  protected
    function DefaultPadding: Integer; override;
    function DefaultParentBackground: Boolean; override;
    function GetActualPadding: TRect; override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function GetAxis: TdxChartCustomAxis;
    function HasFillOptions: Boolean; override;
    function HasFontOptions: Boolean; override;
    procedure UpdateActualValues(ACanvas: TcxCustomCanvas); override;
  published
    property FillOptions;
    property FontOptions: TdxChartVisualElementFontOptions read GetFontOptions write SetFontOptions;
    property TextColor;
  end;

  TdxChartCrosshairAxisLabels = class(TdxChartVisualElementPersistent)
  strict private
    FTextFormatter: TObject;
    function GetAppearance: TdxChartCrosshairAxisLabelAppearance;
    function GetTextFormat: TdxChartTextFormat;
    procedure SetAppearance(AValue: TdxChartCrosshairAxisLabelAppearance);
    procedure SetTextFormat(AValue: TdxChartTextFormat);
  protected
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    procedure DoAssign(Source: TPersistent); override;
    property TextFormatter: TObject read FTextFormatter;
  public
    destructor Destroy; override;
  published
    property Appearance: TdxChartCrosshairAxisLabelAppearance read GetAppearance write SetAppearance;
    property TextFormat: TdxChartTextFormat read GetTextFormat write SetTextFormat;
  end;

  { TdxChartCustomAxis }

  TdxChartCustomAxis = class(TdxChartCustomVisualElement)
  strict private
    FAlignment: TdxChartAxisAlignment;
    FCrosshairLabels: TdxChartCrosshairAxisLabels;
    FGridlines: TdxChartAxisGridlines;
    FInterlaced: Boolean;
    FLogarithmic: Boolean;
    FLogarithmicBase: Single;
    FMinorCount: Integer;
    FTicks: TdxChartAxisTicks;
    FTitle: TdxChartAxisTitle;
    FDataValueConverter: TdxChartAxisDataValueConverter; // Nullable
    FNumericScaleOptions: TdxChartAxisNumericScaleOptions;
    FRange: TdxChartRange;
    FReverse: Boolean;
    FValueLabels: TdxChartAxisValueLabels;
    FViewData: TdxChartAxisViewData;

    function GetAppearance: TdxChartAxisAppearance;
    function GetStep: Double;
    function GetTickOffset: Double;
    function GetViewInfo: TdxChartAxisViewInfo; inline;
    function IsLogarithmicBaseStored: Boolean;
    procedure SetAlignment(AValue: TdxChartAxisAlignment);
    procedure SetAppearance(AValue: TdxChartAxisAppearance);
    procedure SetCrosshairLabels(AValue: TdxChartCrosshairAxisLabels);
    procedure SetGridlines(AValue: TdxChartAxisGridlines);
    procedure SetInterlaced(AValue: Boolean);
    procedure SetLogarithmic(AValue: Boolean);
    procedure SetLogarithmicBase(AValue: Single);
    procedure SetMinorCount(AValue: Integer);
    procedure SetNumericScaleOptions(AValue: TdxChartAxisNumericScaleOptions);
    procedure SetRange(AValue: TdxChartRange);
    procedure SetReverse(AValue: Boolean);
    procedure SetTicks(AValue: TdxChartAxisTicks);
    procedure SetTitle(AValue: TdxChartAxisTitle);
    procedure SetValueLabels(AValue: TdxChartAxisValueLabels);
  protected const
    DefaultLogarithmicBase: Single = 10;
    DefaultSecondaryAxisIndent: Single = 5;
  protected
    procedure BiDiModeChanged; override;
    procedure ChangeScale(M, D: Integer); override;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function CreateViewInfo: TdxChartVisualElementCustomViewInfo; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetChart: TdxChart; override;
    function GetParentElement: IdxChartVisualElement; override;
    procedure LayoutChanged; override;
    procedure StyleChanged; override;

    function CreateViewData: TdxChartAxisViewData; virtual;
    function GetAxes: TdxChartAxes; virtual;
    procedure GetDataTypes(var AValueType, AArgumentType: TVarType); virtual;
    function GetDefaultMinorCount: Integer; virtual; abstract;
    function GetDiagram: TdxChartXYDiagram; virtual;
    function GetOrthogonalAxis: TdxChartCustomAxis; virtual; abstract;
    function GetValueType: TVarType; virtual;
    function GetViewInfoCalculationHelper: TdxChartAxisViewInfoCalculationHelperClass;
    function IsArgumentAxis: Boolean; virtual; abstract;
    function IsFarAlignment: Boolean; virtual;
    function IsGridlinesVisibleByDefault: Boolean; virtual;
    function IsMinorCountStored: Boolean;
    function IsMinorGridlinesVisibleByDefault: Boolean; virtual;
    function IsNearAlignment: Boolean; virtual;
    function IsNumeric: Boolean; virtual;
    function IsSecondary: Boolean; virtual;
    function IsZeroAlignment: Boolean; virtual;
    procedure PopulateValues(AValues: TStrings); virtual;
    procedure RecreateDataValueConverter;
    procedure SetDefaultAxisAlignment; virtual;

    function GetScrollPos: Integer;
    function IsScrollableReverse: Boolean;
    function IsScrollBarEnabled: Boolean; virtual;
    procedure InitScrollbarData(AScrollBarData: TcxScrollBarData);
    procedure ScrollContent(AScrollCode: TScrollCode; AScrollPos: Integer; out ARangeChanged: Boolean);

    property Alignment: TdxChartAxisAlignment read FAlignment write SetAlignment default TdxChartAxisAlignment.Near;
    property Axes: TdxChartAxes read GetAxes;
    property CrosshairLabels: TdxChartCrosshairAxisLabels read FCrosshairLabels write SetCrosshairLabels;
    property Gridlines: TdxChartAxisGridlines read FGridlines write SetGridlines;
    property Interlaced: Boolean read FInterlaced write SetInterlaced default False;
    property Logarithmic: Boolean read FLogarithmic write SetLogarithmic default False;
    property LogarithmicBase: Single read FLogarithmicBase write SetLogarithmicBase stored IsLogarithmicBaseStored;
    property MinorCount: Integer read FMinorCount write SetMinorCount stored IsMinorCountStored;
    property Ticks: TdxChartAxisTicks read FTicks write SetTicks;
    property Title: TdxChartAxisTitle read FTitle write SetTitle;
    property ValueLabels: TdxChartAxisValueLabels read FValueLabels write SetValueLabels;
    property ViewData: TdxChartAxisViewData read FViewData;
    property ViewInfo: TdxChartAxisViewInfo read GetViewInfo;

    property Appearance: TdxChartAxisAppearance read GetAppearance write SetAppearance;
    property DataValueConverter: TdxChartAxisDataValueConverter read FDataValueConverter;
    property NumericScaleOptions: TdxChartAxisNumericScaleOptions read FNumericScaleOptions write SetNumericScaleOptions;
    property Range: TdxChartRange read FRange write SetRange;
    property Reverse: Boolean read FReverse write SetReverse default False;
    property Step: Double read GetStep;
    property TickOffset: Double read GetTickOffset;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    property Diagram: TdxChartXYDiagram read GetDiagram;
  end;

  { TdxChartCustomAxisX }

  TdxChartAxisCompareStringValuesEvent = procedure(Sender: TdxChartCustomAxis; const AValue1, AValue2: string; var ACompare: Integer) of object;

  TdxChartCustomAxisX = class(TdxChartCustomAxis)
  strict private
    FOnCompareValues: TdxChartAxisCompareStringValuesEvent;
    function GetViewData: TdxChartAxisXViewData; inline;
  protected const
    DefaultMinorCount = 4;
  protected
    function CompareValues(AValue1, AValue2: TdxChartXYSeriesValueViewInfo): Integer; 
    function CreateViewData: TdxChartAxisViewData; override;
    function GetDefaultMinorCount: Integer; override;
    function GetOrthogonalAxis: TdxChartCustomAxis; override;
    function GetValueType: TVarType; override;
    function IsArgumentAxis: Boolean; override;
    function IsNumeric: Boolean; override;
    function IsScrollBarEnabled: Boolean; override;
    procedure PopulateValues(AValues: TStrings); override;

    property ViewData: TdxChartAxisXViewData read GetViewData;
    property OnCompareValues: TdxChartAxisCompareStringValuesEvent read FOnCompareValues write FOnCompareValues;
  end;

  { TdxChartAxisX }

  TdxChartAxisX = class(TdxChartCustomAxisX)
  protected
    function ActuallyVisible: Boolean; override;
  published
    property Alignment;
    property Appearance;
    property CrosshairLabels;
    property Gridlines;
    property Interlaced;
    property MinorCount;
    property NumericScaleOptions;
    property Range;
    property Reverse;
    property Ticks;
    property Title;
    property ValueLabels;
    property Visible;
    property OnCompareValues;
  end;

  { TdxChartSecondaryAxisX }

  TdxChartSecondaryAxisX = class(TdxChartCustomAxisX)
  strict private
    FAlignment: TdxChartSecondaryAxisAlignment;

    function GetSecondaryAxes: TdxChartSecondaryAxes;
    procedure SetAlignment(AValue: TdxChartSecondaryAxisAlignment);
  protected
    function ActuallyVisible: Boolean; override;
    function GetAxes: TdxChartAxes; override;
    function GetDiagram: TdxChartXYDiagram; override;
    function IsFarAlignment: Boolean; override;
    function IsNearAlignment: Boolean; override;
    function IsSecondary: Boolean; override;
    function IsZeroAlignment: Boolean; override;
    procedure SetDefaultAxisAlignment; override;

    property SecondaryAxes: TdxChartSecondaryAxes read GetSecondaryAxes;
  published
    property Alignment: TdxChartSecondaryAxisAlignment read FAlignment write SetAlignment default TdxChartSecondaryAxisAlignment.Far;
    property Appearance;
    property Gridlines;
    property Interlaced;
    property MinorCount;
    property NumericScaleOptions;
    property Range;
    property Reverse;
    property Ticks;
    property Title;
    property ValueLabels;
    property Visible;
  end;

  { TdxChartCustomAxisY }

  TdxChartCustomAxisY = class(TdxChartCustomAxis)
  protected const
    DefaultMinorCount = 2;
  protected
    function GetDefaultMinorCount: Integer; override;
    function GetOrthogonalAxis: TdxChartCustomAxis; override;
    function IsArgumentAxis: Boolean; override;
    function IsScrollBarEnabled: Boolean; override;
  end;

  { TdxChartAxisY }

  TdxChartAxisY = class(TdxChartCustomAxisY)
  protected
    function ActuallyVisible: Boolean; override;
    function IsGridlinesVisibleByDefault: Boolean; override;
  published
    property Alignment;
    property Appearance;
    property CrosshairLabels;
    property Gridlines;
    property Interlaced;
    property MinorCount;
    property NumericScaleOptions;
    property Range;
    property Reverse;
    property Ticks;
    property Title;
    property ValueLabels;
    property Visible;
  end;

  { TdxChartSecondaryAxisY }

  TdxChartSecondaryAxisY = class(TdxChartCustomAxisY)
  strict private
    FAlignment: TdxChartSecondaryAxisAlignment;

    function GetSecondaryAxes: TdxChartSecondaryAxes;
    procedure SetAlignment(AValue: TdxChartSecondaryAxisAlignment);
  protected
    function ActuallyVisible: Boolean; override;
    function GetAxes: TdxChartAxes; override;
    function GetDiagram: TdxChartXYDiagram; override;
    function IsFarAlignment: Boolean; override;
    function IsNearAlignment: Boolean; override;
    function IsSecondary: Boolean; override;
    function IsZeroAlignment: Boolean; override;
    procedure SetDefaultAxisAlignment; override;

    property SecondaryAxes: TdxChartSecondaryAxes read GetSecondaryAxes;
  published
    property Alignment: TdxChartSecondaryAxisAlignment read FAlignment write SetAlignment default TdxChartSecondaryAxisAlignment.Far;
    property Appearance;
    property Gridlines;
    property Interlaced;
    property MinorCount;
    property NumericScaleOptions;
    property Range;
    property Reverse;
    property Ticks;
    property Title;
    property ValueLabels;
    property Visible;
  end;

  { TdxChartSecondaryCustomAxisCollectionItem }

  TdxChartSecondaryCustomAxisCollectionItem = class(TcxInterfacedCollectionItem)
  strict private
    FAxis: TdxChartCustomAxis;

    function GetAppearance: TdxChartAxisAppearance;
    function GetGridlines: TdxChartAxisGridlines;
    function GetInterlaced: Boolean;
    function GetLogarithmic: Boolean;
    function GetLogarithmicBase: Single;
    function GetMinorCount: Integer;
    function GetNumericScaleOptions: TdxChartAxisNumericScaleOptions;
    function GetRange: TdxChartRange;
    function GetReverse: Boolean;
    function GetTicks: TdxChartAxisTicks;
    function GetTitle: TdxChartAxisTitle;
    function GetValueLabels: TdxChartAxisValueLabels;
    function GetVisible: Boolean;

    procedure SetAppearance(AValue: TdxChartAxisAppearance);
    procedure SetGridlines(AValue: TdxChartAxisGridlines);
    procedure SetInterlaced(AValue: Boolean);
    procedure SetValueLabels(AValue: TdxChartAxisValueLabels);
    procedure SetLogarithmic(AValue: Boolean);
    procedure SetLogarithmicBase(AValue: Single);
    procedure SetMinorCount(AValue: Integer);
    procedure SetNumericScaleOptions(AValue: TdxChartAxisNumericScaleOptions);
    procedure SetRange(AValue: TdxChartRange);
    procedure SetReverse(AValue: Boolean);
    procedure SetTicks(AValue: TdxChartAxisTicks);
    procedure SetTitle(AValue: TdxChartAxisTitle);
    procedure SetVisible(AValue: Boolean);
  protected
    function CreateAxis: TdxChartCustomAxis; virtual; abstract;
    function IsLogarithmicBaseStored: Boolean;
    function IsMinorCountStored: Boolean;

    property Axis: TdxChartCustomAxis read FAxis;
    property Appearance: TdxChartAxisAppearance read GetAppearance write SetAppearance;
    property Gridlines: TdxChartAxisGridlines read GetGridlines write SetGridlines;
    property Interlaced: Boolean read GetInterlaced write SetInterlaced default False;
    property Logarithmic: Boolean read GetLogarithmic write SetLogarithmic default False;
    property LogarithmicBase: Single read GetLogarithmicBase write SetLogarithmicBase stored IsLogarithmicBaseStored;
    property MinorCount: Integer read GetMinorCount write SetMinorCount stored IsMinorCountStored;
    property NumericScaleOptions: TdxChartAxisNumericScaleOptions read GetNumericScaleOptions write SetNumericScaleOptions;
    property Range: TdxChartRange read GetRange write SetRange;
    property Reverse: Boolean read GetReverse write SetReverse default False;
    property Ticks: TdxChartAxisTicks read GetTicks write SetTicks;
    property Title: TdxChartAxisTitle read GetTitle write SetTitle;
    property ValueLabels: TdxChartAxisValueLabels read GetValueLabels write SetValueLabels;
    property Visible: Boolean read GetVisible write SetVisible default True;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  end;
  TdxChartSecondaryCustomAxisCollectionItemClass = class of TdxChartSecondaryCustomAxisCollectionItem;

  { TdxChartSecondaryAxisXCollectionItem }

  TdxChartSecondaryAxisXCollectionItem = class(TdxChartSecondaryCustomAxisCollectionItem)
  strict private
    function GetAlignment: TdxChartSecondaryAxisAlignment;
    function GetAxis: TdxChartSecondaryAxisX;
    procedure SetAlignment(AValue: TdxChartSecondaryAxisAlignment);
  protected
    function CreateAxis: TdxChartCustomAxis; override;
  public
    property Axis: TdxChartSecondaryAxisX read GetAxis;
  published
    property Alignment: TdxChartSecondaryAxisAlignment read GetAlignment write SetAlignment default TdxChartSecondaryAxisAlignment.Far;
    property Appearance;
    property Gridlines;
    property Interlaced;
    property Logarithmic;
    property LogarithmicBase;
    property MinorCount;
    property NumericScaleOptions;
    property Range;
    property Reverse;
    property Ticks;
    property Title;
    property ValueLabels;
    property Visible;
  end;

  { TdxChartSecondaryAxisYCollectionItem }

  TdxChartSecondaryAxisYCollectionItem = class(TdxChartSecondaryCustomAxisCollectionItem)
  strict private
    function GetAlignment: TdxChartSecondaryAxisAlignment;
    function GetAxis: TdxChartSecondaryAxisY;
    procedure SetAlignment(AValue: TdxChartSecondaryAxisAlignment);
  protected
    function CreateAxis: TdxChartCustomAxis; override;
  public
    property Axis: TdxChartSecondaryAxisY read GetAxis;
  published
    property Alignment: TdxChartSecondaryAxisAlignment read GetAlignment write SetAlignment default TdxChartSecondaryAxisAlignment.Far;
    property Appearance;
    property Gridlines;
    property Interlaced;
    property Logarithmic;
    property LogarithmicBase;
    property MinorCount;
    property NumericScaleOptions;
    property Range;
    property Reverse;
    property Ticks;
    property Title;
    property ValueLabels;
    property Visible;
  end;

  { TdxChartSecondaryCustomAxes }

  TdxChartSecondaryCustomAxes = class(TcxOwnedInterfacedCollection)
  strict private
    FDiagram: TdxChartXYDiagram;

    function GetItem(AIndex: Integer): TdxChartSecondaryCustomAxisCollectionItem;
    procedure SetItem(AIndex: Integer; AValue: TdxChartSecondaryCustomAxisCollectionItem);
  protected
    procedure BiDiModeChanged;
    procedure ChangeScale(M, D: Integer);
    procedure Draw(ACanvas: TcxCustomCanvas);
    function GetCollectionItemClass: TdxChartSecondaryCustomAxisCollectionItemClass; virtual; abstract;
    function GetDirty: Boolean;
    procedure LayoutChanged;
    procedure Update(Item: TCollectionItem); override;

    property Dirty: Boolean read GetDirty;
  public
    constructor Create(ADiagram: TdxChartXYDiagram); reintroduce; virtual;

    property Diagram: TdxChartXYDiagram read FDiagram;
    property Items[Index: Integer]: TdxChartSecondaryCustomAxisCollectionItem read GetItem write SetItem; default;
  end;

  { TdxChartSecondaryAxesX }

  TdxChartSecondaryAxesX = class(TdxChartSecondaryCustomAxes)
  strict private
    function GetItem(AIndex: Integer): TdxChartSecondaryAxisXCollectionItem;
    procedure SetItem(AIndex: Integer; AValue: TdxChartSecondaryAxisXCollectionItem);
  protected
    function GetCollectionItemClass: TdxChartSecondaryCustomAxisCollectionItemClass; override;
  public
    function Add: TdxChartSecondaryAxisXCollectionItem;

    property Items[Index: Integer]: TdxChartSecondaryAxisXCollectionItem read GetItem write SetItem; default;
  end;

  { TdxChartSecondaryAxesY }

  TdxChartSecondaryAxesY = class(TdxChartSecondaryCustomAxes)
  strict private
    function GetItem(AIndex: Integer): TdxChartSecondaryAxisYCollectionItem;
    procedure SetItem(AIndex: Integer; AValue: TdxChartSecondaryAxisYCollectionItem);
  protected
    function GetCollectionItemClass: TdxChartSecondaryCustomAxisCollectionItemClass; override;
  public
    function Add: TdxChartSecondaryAxisYCollectionItem;

    property Items[Index: Integer]: TdxChartSecondaryAxisYCollectionItem read GetItem write SetItem; default;
  end;

  { TdxChartAxes }

  TdxChartAxes = class(TdxChartOwnedPersistent)
  strict private
    FAxisX: TdxChartAxisX;
    FAxisY: TdxChartAxisY;

    function GetDiagram: TdxChartXYDiagram;
    procedure SetAxisX(AValue: TdxChartAxisX);
    procedure SetAxisY(AValue: TdxChartAxisY);
  protected
    procedure BiDiModeChanged;
    procedure ChangeScale(M, D: Integer);
    procedure DoAssign(Source: TPersistent); override;
    procedure Draw(ACanvas: TcxCustomCanvas);

    property Diagram: TdxChartXYDiagram read GetDiagram;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property AxisX: TdxChartAxisX read FAxisX write SetAxisX;
    property AxisY: TdxChartAxisY read FAxisY write SetAxisY;
  end;

  { TdxChartSecondaryAxes }

  TdxChartSecondaryAxes = class(TdxChartOwnedPersistent)
  strict private
    FAxesX: TdxChartSecondaryAxesX;
    FAxesY: TdxChartSecondaryAxesY;
    FVisible: Boolean;

    function GetDiagram: TdxChartXYDiagram;
    procedure SetAxesX(AValue: TdxChartSecondaryAxesX);
    procedure SetAxesY(AValue: TdxChartSecondaryAxesY);
    procedure SetVisible(AValue: Boolean);
  protected
    procedure BiDiModeChanged;
    procedure ChangeScale(M, D: Integer);
    procedure DoAssign(Source: TPersistent); override;
    procedure Draw(ACanvas: TcxCustomCanvas);

    property Diagram: TdxChartXYDiagram read GetDiagram;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property AxesX: TdxChartSecondaryAxesX read FAxesX write SetAxesX;
    property AxesY: TdxChartSecondaryAxesY read FAxesY write SetAxesY;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  { TdxChartXYSeriesValueLabels }

  TdxChartXYSeriesValueLabels = class(TdxChartSeriesValueLabels)
  protected
    procedure ResolveOverlappingIndentChanged; override; // for internal use
  end;

  { TdxChartXYSeriesValueLabelViewInfo }

  TdxChartXYSeriesValueLabelViewInfo = class(TdxChartSeriesValueLabelViewInfo)
  strict private
    function GetLabelOptions: TdxChartXYSeriesValueLabels; inline;
    function GetOwner: TdxChartXYSeriesValueViewInfo; inline;
  protected
    function GetExcludedBounds: TdxRectF; virtual;
    function GetValidRect: TdxRectF; virtual;

    property Options: TdxChartXYSeriesValueLabels read GetLabelOptions;
    property Owner: TdxChartXYSeriesValueViewInfo read GetOwner;
  public
    procedure Offset(const ADistance: TdxPointF); overload; override;
  end;

  { TdxChartXYSeriesValueLabelViewInfoList }

  TdxChartXYSeriesValueLabelViewInfoList = class(TdxChartSeriesValueLabelViewInfoList) // for internal use
  strict private
    function GetItem(Index: TdxListIndex): TdxChartXYSeriesValueLabelViewInfo; inline;
  public
    property Items[Index: TdxListIndex]: TdxChartXYSeriesValueLabelViewInfo read GetItem; default;
  end;

  { TdxChartXYSeriesCustomView }

  TdxChartXYSeriesCustomView = class(TdxChartSeriesCustomView)
  protected type
    TValuesStacking = (None, Normal, Full);
    TNegativeValuesStackingStyle = (StackAlways, StackIfNoPositiveValues);
  strict private
    function GetValueLabels: TdxChartXYSeriesValueLabels;
    procedure SetValueLabels(AValue: TdxChartXYSeriesValueLabels);
    function GetViewInfo: TdxChartXYSeriesViewCustomViewInfo; inline;
  protected
    class function CanAggregate(AView: TdxChartSeriesCustomView): Boolean; override;
    function CreateValueLabels: TdxChartSeriesValueLabels; override;
    function CreateViewData: TdxChartSeriesViewCustomViewData; override;
    function CreateViewInfo: TdxChartSeriesViewCustomViewInfo; override;
    class function GetValuesStacking: TValuesStacking; virtual;
    class function GetNegativeValuesStackingStyle: TNegativeValuesStackingStyle; virtual;
    function IsZeroBased: Boolean; virtual;

    property ViewInfo: TdxChartXYSeriesViewCustomViewInfo read GetViewInfo;
  public
    property ValueLabels: TdxChartXYSeriesValueLabels read GetValueLabels write SetValueLabels;
  end;

  { TdxChartXYSeries }

  TdxChartXYSeries = class(TdxChartCustomSeries)
  strict private
    function GetView: TdxChartXYSeriesCustomView; inline;
    procedure SetView(AValue: TdxChartXYSeriesCustomView);
  protected
    class function GetBaseViewClass: TdxChartSeriesViewClass; override;
  published
    property CheckableInLegend;
    property ShowInLegend;
    property SortBy;
    property SortOrder;
    property View: TdxChartXYSeriesCustomView read GetView write SetView;
  end;

  { TdxChartXYDiagramAppearance }

  TdxChartXYDiagramAppearance = class(TdxChartDiagramAppearance)
  private
    FPlotAreaBorder: Boolean;
    FPlotAreaBorderThickness: Single;

    function IsPlotAreaBorderThicknessStored: Boolean;
    procedure SetPlotAreaBorder(AValue: Boolean);
    procedure SetPlotAreaBorderThickness(AValue: Single);
  protected const
    PlotAreaBorderColorIndex = TdxChartVisualElementAppearance.TextColorIndex + 1;
  protected
    procedure ChangeScaleCore(M, D: Integer); override;
    procedure DoAssign(Source: TPersistent); override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function GetColorCount: Integer; override;

    property ActualPlotAreaBorderColor: TdxAlphaColor index PlotAreaBorderColorIndex read GetActualColorValue;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property PlotAreaBorder: Boolean read FPlotAreaBorder write SetPlotAreaBorder default True;
    property PlotAreaBorderColor: TdxAlphaColor index PlotAreaBorderColorIndex read GetColorValue write SetColorValue default TdxAlphaColors.Default;
    property PlotAreaBorderThickness: Single read FPlotAreaBorderThickness write SetPlotAreaBorderThickness stored IsPlotAreaBorderThicknessStored;
  end;

  { TdxChartXYDiagramZoomOptions }

  TdxChartXYDiagramZoomOptions = class(TcxOwnedPersistent)
  private const
    DefaultMaxZoomPercent = 10000;
  private
    FAxisXZoomingEnabled: Boolean;
    FAxisYZoomingEnabled: Boolean;
    FAxisXMaxZoomPercent: Single;
    FAxisYMaxZoomPercent: Single;
    function IsAxisXMaxZoomPercentStored: Boolean;
    function IsAxisYMaxZoomPercentStored: Boolean;
    procedure SetAxisXMaxZoomPercent(AValue: Single);
    procedure SetAxisYMaxZoomPercent(AValue: Single);
  protected
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property AxisXMaxZoomPercent: Single read FAxisXMaxZoomPercent write SetAxisXMaxZoomPercent stored IsAxisXMaxZoomPercentStored;
    property AxisXZoomingEnabled: Boolean read FAxisXZoomingEnabled write FAxisXZoomingEnabled default True;
    property AxisYMaxZoomPercent: Single read FAxisYMaxZoomPercent write SetAxisYMaxZoomPercent stored IsAxisYMaxZoomPercentStored;
    property AxisYZoomingEnabled: Boolean read FAxisYZoomingEnabled write FAxisYZoomingEnabled default True;
  end;

  TdxChartXYDiagramScrollOptions = class(TcxOwnedPersistent)
  private
    FScrollBars: TdxDefaultBoolean;
    FAxisXScrollingEnabled: Boolean;
    FAxisYScrollingEnabled: Boolean;
  protected
    procedure DoAssign(ASource: TPersistent); override;
    function GetActualScrollbars: Boolean;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property AxisXScrollingEnabled: Boolean read FAxisXScrollingEnabled write FAxisXScrollingEnabled default True;
    property AxisYScrollingEnabled: Boolean read FAxisYScrollingEnabled write FAxisYScrollingEnabled default True;
    property ScrollBars: TdxDefaultBoolean read FScrollBars write FScrollBars default bDefault;
  end;

  { TdxChartMouseActionExecutor }

  TdxChartMouseActionExecutor = class  // for internal use
  strict protected
    class function NoRange(ADiagram: TdxChartXYDiagram): Boolean;
  public
    function GetDefaultMouseCursor: TCursor; virtual;
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; virtual;
    procedure MouseUp(ADiagram: TdxChartCustomDiagram; AMouseX, AMouseY: Integer); virtual;
    function IsAvailableFor(ADiagram: TdxChartCustomDiagram): Boolean; virtual; abstract;
  end;

  TdxChartMouseActionExecutorClass = class of TdxChartMouseActionExecutor;
  TdxChartMouseActionExecutorClassArray = array[TdxChart.TChartMouseActionKind] of TdxChartMouseActionExecutorClass;

  TdxChartRangeInfo = class
  private
    FMin, FMax: Variant;
    constructor Create; overload;
    constructor Create(const AMin: Variant; const AMax: Variant); overload;
  public
    property Min: Variant read FMin;
    property Max: Variant read FMax;
  end;

  TdxChartXYDiagramRangesChangeEventArgs = class(TdxEventArgs)
  private
    FNewXRange: TdxChartRangeInfo;
    FNewYRange: TdxChartRangeInfo;
    FOldXRange: TdxChartRangeInfo;
    FOldYRange: TdxChartRangeInfo;
  protected
    constructor Create(const AOldMinX, AOldMaxX, AOldMinY, AOldMaxY: Variant);
  public
    destructor Destroy; override;
    property NewXRange: TdxChartRangeInfo read FNewXRange;
    property NewYRange: TdxChartRangeInfo read FNewYRange;
    property OldXRange: TdxChartRangeInfo read FOldXRange;
    property OldYRange: TdxChartRangeInfo read FOldYRange;
  end;

  TdxChartXYDiagramScrollEventArgs = class(TdxChartXYDiagramRangesChangeEventArgs);
  TdxChartXYDiagramScrollEvent = procedure(Sender: TdxChartXYDiagram; AArgs: TdxChartXYDiagramScrollEventArgs) of object;

  TdxChartXYDiagramZoomEventArgs = class(TdxChartXYDiagramRangesChangeEventArgs);
  TdxChartXYDiagramZoomEvent = procedure(Sender: TdxChartXYDiagram; AArgs: TdxChartXYDiagramZoomEventArgs) of object;

  TdxChartXYDiagramBeforeZoomEventArgs = class(TdxEventArgs)
  private
    FAxis: TdxChartCustomAxis;
    FCancel: Boolean;
    FNewRange: TdxChartRangeInfo;
    constructor Create(AAxis: TdxChartCustomAxis; const ANewMin, ANewMax: Variant);
  public
    destructor Destroy; override;
    property Axis: TdxChartCustomAxis read FAxis;
    property Cancel: Boolean read FCancel write FCancel;
    property NewRange: TdxChartRangeInfo read FNewRange;
  end;

  TdxChartXYDiagramBeforeZoomEvent = procedure(Sender: TdxChartXYDiagram; AArgs: TdxChartXYDiagramBeforeZoomEventArgs) of object;

  TdxChartGetAxisValueLabelDrawParametersEventArgs = class(TdxEventArgs)
  private
    FAxis: TdxChartCustomAxis;
    FValue: Variant;
    FText: string;
    constructor Create(AAxis: TdxChartCustomAxis; const AValue: Variant; AText: string);
  public
    property Axis: TdxChartCustomAxis read FAxis;
    property Value: Variant read FValue;
    property Text: string read FText write FText;
  end;

  TdxChartGetAxisValueLabelDrawParametersEvent = procedure(Sender: TdxChartCustomDiagram; AArgs: TdxChartGetAxisValueLabelDrawParametersEventArgs) of object;

  TdxChartXYDiagramToolTipMode = TdxChartToolTipMode.Default..TdxChartToolTipMode.Crosshair;

  TdxChartXYDiagramToolTipOptions = class(TdxChartDiagramToolTipOptions)
  strict private
    FMode: TdxChartXYDiagramToolTipMode;
  protected
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property Mode: TdxChartXYDiagramToolTipMode read FMode write FMode default TdxChartToolTipMode.Default;
  end;

  { TdxChartXYDiagram }

  TdxChartXYDiagram = class(TdxChartCustomDiagram)
  strict private
    FAxes: TdxChartAxes;
    FAxisXEvents: TNotifyEvent;
    FOnBeforeZoom: TdxChartXYDiagramBeforeZoomEvent;
    FOnGetAxisValueLabelDrawParameters: TdxChartGetAxisValueLabelDrawParametersEvent;
    FOnScroll: TdxChartXYDiagramScrollEvent;
    FOnZoom: TdxChartXYDiagramZoomEvent;
    FRotated: Boolean;
    FScrollOptions: TdxChartXYDiagramScrollOptions;
    FSecondaryAxes: TdxChartSecondaryAxes;
    FZoomOptions: TdxChartXYDiagramZoomOptions;

    function GetSeries(AIndex: Integer): TdxChartXYSeries;
    function GetToolTips: TdxChartXYDiagramToolTipOptions;
    function GetViewData: TdxChartXYDiagramViewData; inline;
    function GetVisibleSeries(AIndex: Integer): TdxChartXYSeries;
    procedure SetAxes(AValue: TdxChartAxes);
    procedure SetRotated(AValue: Boolean);
    procedure SetScrollOptions(AValue: TdxChartXYDiagramScrollOptions);
    procedure SetSecondaryAxes(AValue: TdxChartSecondaryAxes);
    procedure SetSeries(AIndex: Integer; const AValue: TdxChartXYSeries);
    procedure SetToolTips(AValue: TdxChartXYDiagramToolTipOptions);
    procedure SetZoomOptions(const AValue: TdxChartXYDiagramZoomOptions);
    function ZoomByUserAlongAxis(AAxis: TdxChartCustomAxis; AZoomType: TdxChartRange.TZoomType; AStepPercent: Single;
                            AStepCount: Integer; AMaxPercent: Single; ABearingValue: Double): Boolean;
  private
    procedure ScrollByUser(AScrollStyle: System.UITypes.TScrollStyle; AHScrollCode: TScrollCode; AHScrollPos: Integer;
                           AVScrollCode: TScrollCode; AVScrollPos: Integer);
    procedure ZoomByUser(AZoomType: TdxChartRange.TZoomType; AStepPercent: Single; AStepCount: Integer; ABearingPoint: TdxPointDouble);
    procedure ZoomToRect(ARect: TdxRectDouble);
  protected
    procedure AssignFrom(ASource: TdxChartCustomDiagram; ARecreate: Boolean = True; AStoreList: TdxFastObjectList = nil); override;
    procedure BiDiModeChanged; override;
    procedure ChangeScale(M, D: Integer); override;
    procedure ChangeResolveOverlappingIndent(AChangedValueLabels: TdxChartXYSeriesValueLabels);
    function CreateAppearance: TdxChartDiagramAppearance; override;
    function CreateToolTipOptions: TdxChartDiagramToolTipOptions; override;
    function CreateViewData: TdxChartDiagramCustomViewData; override;
    function CreateViewInfo: TdxChartDiagramCustomViewInfo; override;
    procedure DoBeforeZoom(AArgs: TdxChartXYDiagramBeforeZoomEventArgs); virtual;
    procedure DoGetAxisValueLabelDrawParameters(AArgs: TdxChartGetAxisValueLabelDrawParametersEventArgs);
    procedure DoScroll(AArgs: TdxChartXYDiagramScrollEventArgs); virtual;
    procedure DoZoom(AArgs: TdxChartXYDiagramZoomEventArgs); virtual;
    function GetActualToolTipMode: TdxChartActualToolTipMode; override;
    class function GetMouseActionExecutorClasses: TdxChartMouseActionExecutorClassArray;
    function GetSeriesClass: TdxChartSeriesClass; override;
    procedure Zoom(AZoomType: TdxChartRange.TZoomType; AStepPercent: Single; AStepCount: Integer; ABearingPoint: TdxPointDouble);
    procedure ZoomByMouseWheel(AWheelDelta: Integer; AMousePos: TPoint; AByX: Boolean; AByY: Boolean);

    property SecondaryAxes: TdxChartSecondaryAxes read FSecondaryAxes write SetSecondaryAxes;
    property ViewData: TdxChartXYDiagramViewData read GetViewData;
  public type
    TForEachSeriesProc = reference to procedure(ASeries: TdxChartXYSeries);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddSeries(const ACaption: string = ''): TdxChartXYSeries;
    procedure ForEachSeries(AHandler: TForEachSeriesProc);
    procedure ResetZoom;
    procedure ZoomIn;
    procedure ZoomOut;

    property Series[AIndex: Integer]: TdxChartXYSeries read GetSeries write SetSeries;
    property VisibleSeries[Index: Integer]: TdxChartXYSeries read GetVisibleSeries;
  published
    property Axes: TdxChartAxes read FAxes write SetAxes;
    property AxisXEvents: TNotifyEvent read FAxisXEvents write FAxisXEvents; //for internal use
    property OnBeforeZoom: TdxChartXYDiagramBeforeZoomEvent read FOnBeforeZoom write FOnBeforeZoom;
    property OnGetAxisValueLabelDrawParameters: TdxChartGetAxisValueLabelDrawParametersEvent read FOnGetAxisValueLabelDrawParameters write FOnGetAxisValueLabelDrawParameters;
    property OnGetValueLabelDrawParameters;
    property OnScroll: TdxChartXYDiagramScrollEvent read FOnScroll write FOnScroll;
    property OnZoom: TdxChartXYDiagramZoomEvent read FOnZoom write FOnZoom;
    property Rotated: Boolean read FRotated write SetRotated default False;
    property ScrollOptions: TdxChartXYDiagramScrollOptions read FScrollOptions write SetScrollOptions;
    property ToolTips: TdxChartXYDiagramToolTipOptions read GetToolTips write SetToolTips;
    property Visible;
    property ZoomOptions: TdxChartXYDiagramZoomOptions read FZoomOptions write SetZoomOptions;
  end;

  { TdxChartXYSeriesValueViewInfo }

  TdxChartXYSeriesValueViewInfo = class(TdxChartSeriesValueViewInfo) // for internal use
  strict private
    function GetOwner: TdxChartXYSeriesViewCustomViewInfo; inline;
    function GetView: TdxChartXYSeriesCustomView; inline;
  protected
    FArgument: Double;
    FArgumentDisplayText: string;
    FDisplayValue: TdxPointF;
    FSourceValue: Double;
    FBaseValue: Double; 
    FBaseDisplayValue: Single;

    procedure CalculateDisplayText; override;
    procedure CalculateValue; override;
    function CreateValueLabel: TdxChartValueLabelCustomViewInfo; override;
    function GetCrosshairAnchorPoint: TdxPointF; virtual;
    function GetDefaultPointToolTipFormatter: TObject; override;
    function GetLabelAnchorPoint: TdxPointF; override;
    function GetValueByName(const AName: string; out AValue: Variant): Boolean; override;
    procedure MapOnArgumentAxis(AAxisValue: Double);

  public
    function GetDistanceTo(const APoint: TdxPointF; AMeasuringMode: TdxChartCrosshairSnapToPointMode): Single; virtual;
    function SegmentFinish: Boolean; inline;
    function SegmentStart: Boolean; inline;

    property Argument: Double read FArgument;
    property ArgumentDisplayText: string read FArgumentDisplayText;
    property CrosshairAnchorPoint: TdxPointF read GetCrosshairAnchorPoint;
    property DisplayValue: TdxPointF read FDisplayValue;
    property Owner: TdxChartXYSeriesViewCustomViewInfo read GetOwner;
    property SourceValue: Double read FSourceValue;
    property View: TdxChartXYSeriesCustomView read GetView;
  end;

  { TdxChartXYSeriesViewCustomViewData }

  TdxChartXYSeriesViewCustomViewData = class(TdxChartSeriesViewCustomViewData)
  strict private
    FArgumentMax: Double;
    FArgumentMin: Double;
    FArgumentIsNumeric: Boolean;
    FStackedValueMax: TdxChartXYSeriesValueViewInfo;
    FStackedValueMin: TdxChartXYSeriesValueViewInfo;
  protected
    procedure CheckValue(AValue: TdxChartSeriesValueViewInfo); override;
    procedure CheckMappedValueArgument(AValue: TdxChartXYSeriesValueViewInfo);
    function IsSourceValueValid(ARecord: PdxDataRecord): Boolean; override;
    procedure PrepareItems(ARecords: TdxFastList); override;
    procedure ValidateStackedMinMax(AValue: TdxChartXYSeriesValueViewInfo);
 public
    property ArgumentMax: Double read FArgumentMax;
    property ArgumentMin: Double read FArgumentMin;
    property StackedValueMin: TdxChartXYSeriesValueViewInfo read FStackedValueMin;
    property StackedValueMax: TdxChartXYSeriesValueViewInfo read FStackedValueMax;
  end;

  { TdxChartXYSeriesViewCustomViewInfo }

  TdxChartXYSeriesViewCustomViewInfo = class(TdxChartSeriesViewCustomViewInfo)
  strict private type
    TPointToDisplayPointProc = procedure(const AArgument, AValue: Double; var ADisplayPoint: TdxPointF) of object;

    TLegendGlyphPenProvider = class
    strict private type
       TAppearanceAccess = class(TdxChartVisualElementAppearance);
    var
       FOwner: TdxChartXYSeriesViewCustomViewInfo;
       FPen: TcxCanvasBasedPen;
       FColor: TdxAlphaColor;
       FStyle: TdxStrokeStyle;
       FWidth: Single;
       function GetAppearance: TAppearanceAccess; inline;
       function GetPen: TcxCanvasBasedPen;
       function NeedUpdate: Boolean;
       procedure Update(ACanvas: TcxCustomCanvas);
       function UseAppearancePen: Boolean;
     protected
       property Appearance: TAppearanceAccess read GetAppearance;
     public
       constructor Create(AOwner: TdxChartXYSeriesViewCustomViewInfo);
       destructor Destroy; override;
       procedure Validate(ACanvas: TcxCustomCanvas);
       property Pen: TcxCanvasBasedPen read GetPen;
    end;

  strict private
    FLegendGlyphPenProvider: TLegendGlyphPenProvider;
    function GetAxisXWidth: Single;
    function GetDiagram: TdxChartXYDiagram;
    function GetDiagramViewInfo: TdxChartXYDiagramViewInfo;
    function GetLegendGlyphPen: TcxCanvasBasedPen;
    function GetRotated: Boolean;
    function GetTickInterval: Single;
    function GetView: TdxChartXYSeriesCustomView; inline;
    function GetViewData: TdxChartXYSeriesViewCustomViewData; inline;
    procedure PointToDisplayPoint(const AArgument, AValue: Double; var ADisplayPoint: TdxPointF);
    procedure PointToDisplayPointRotated(const AArgument, AValue: Double; var ADisplayPoint: TdxPointF);
  protected
    FArgumentToCanvasValue: TdxChartValueToCanvasValueFunc;
    FPointToDisplayPointProc: TPointToDisplayPointProc;
    FStacked: Boolean;
    FValueToCanvasValue: TdxChartValueToCanvasValueFunc;

    procedure CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo); override;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DrawHighlightedValue(ACanvas: TcxCustomCanvas; const AValue: TdxChartXYSeriesValueViewInfo); virtual;
    function GetMaxLegendGlyphPenWidth: Single; virtual;
    function GetValueLabelVisibleBounds: TdxRectF; override;
    function GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass; override;
    function IsPointAppropriateForCrosshair(APoint: TdxPointF; ANearestValue: TdxChartXYSeriesValueViewInfo; AMode: TdxChartCrosshairSnapToPointMode): Boolean; virtual;

    property AxisXWidth: Single read GetAxisXWidth;
    property LegendGlyphPen: TcxCanvasBasedPen read GetLegendGlyphPen;
    property TickInterval: Single read GetTickInterval;
  public
    constructor Create(AOwner: TdxChartSeriesCustomView); override;
    destructor Destroy; override;
    function GetNearestPoint(const APoint: TdxPointF; AMode: TdxChartCrosshairSnapToPointMode): TdxChartXYSeriesValueViewInfo;

    property Diagram: TdxChartXYDiagram read GetDiagram;
    property DiagramViewInfo: TdxChartXYDiagramViewInfo read GetDiagramViewInfo;
    property Rotated: Boolean read GetRotated;
    property View: TdxChartXYSeriesCustomView read GetView;
    property ViewData: TdxChartXYSeriesViewCustomViewData read GetViewData;
  end;

  { TdxChartXYDiagramInterlacedViewInfo }

  TdxChartXYDiagramInterlacedViewInfo = class(TdxChartAxisTickDockedObjectViewInfo)
  protected
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
  end;

  { TdxChartXYDiagramPlotAreaViewInfo }

  TdxChartXYDiagramPlotAreaViewInfo = class(TdxChartCustomItemViewInfo)
  strict private
    FBorderSides: TcxBorders;
    FDiagram: TdxChartXYDiagram;
    FHitElement: IdxChartHitTestPlotAreaElement;
    function GetAppearance: TdxChartXYDiagramAppearance;
    function GetAxisXGridlines: TdxChartAxisGridlinesViewInfo;
    function GetAxisXInterlacedItems: TdxFastObjectList;
    function GetAxisXMinorGridlines: TdxChartAxisGridlinesViewInfo;
    function GetAxisYGridlines: TdxChartAxisGridlinesViewInfo;
    function GetAxisYInterlacedItems: TdxFastObjectList;
    function GetAxisYMinorGridlines: TdxChartAxisGridlinesViewInfo;
    function GetBorderColor: TdxAlphaColor;
    function GetBorderThickness: Single;
    function GetBorderVisible: Boolean;
    function GetDiagramViewInfo: TdxChartXYDiagramViewInfo;
  protected
    function CanDrawBorder: Boolean;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure DrawGridlines(ACanvas: TcxCustomCanvas);
    procedure DrawInterlaced(ACanvas: TcxCustomCanvas);
    procedure DrawMinorGridlines(ACanvas: TcxCustomCanvas);
    function GetHitPlotArea(const P: TdxPointF): IdxChartHitTestPlotAreaElement; override;

    property Appearance: TdxChartXYDiagramAppearance read GetAppearance;
    property AxisXGridlines: TdxChartAxisGridlinesViewInfo read GetAxisXGridlines;
    property AxisXInterlacedItems: TdxFastObjectList read GetAxisXInterlacedItems;
    property AxisXMinorGridlines: TdxChartAxisGridlinesViewInfo read GetAxisXMinorGridlines;
    property AxisYGridlines: TdxChartAxisGridlinesViewInfo read GetAxisYGridlines;
    property AxisYInterlacedItems: TdxFastObjectList read GetAxisYInterlacedItems;
    property AxisYMinorGridlines: TdxChartAxisGridlinesViewInfo read GetAxisYMinorGridlines;
    property Diagram: TdxChartXYDiagram read FDiagram;
    property DiagramViewInfo: TdxChartXYDiagramViewInfo read GetDiagramViewInfo;
  public
    constructor Create(ADiagram: TdxChartXYDiagram); reintroduce; virtual;

    property BorderColor: TdxAlphaColor read GetBorderColor;
    property BorderSides: TcxBorders read FBorderSides;
    property BorderThickness: Single read GetBorderThickness;
    property BorderVisible: Boolean read GetBorderVisible;
  end;

  { TdxChartXYDiagramSeriesGroup }

  TdxChartXYDiagramSeriesGroup = class(TdxChartDiagramSeriesGroup)
  protected
    FMaxValue: Double;
    FMinValue: Double;
    procedure DoCalculate; override;
    procedure DoCheckBoundsValuesForZeroBase(AView: TdxChartXYSeriesCustomView); inline;
    procedure BeforeCalculate; override;
    procedure CheckValue(const AValue: Double; var AMinValue, AMaxValue: Double); inline;
    procedure ForEachValue(AProc: TdxChartForEachXYValueProc);
    procedure GetDataTypes(var AValueType, AArgumentType: TVarType);
  public
    property MaxValue: Double read FMaxValue;
    property MinValue: Double read FMinValue;
  end;

  { TdxChartXYDiagramStackedSeriesGroup }

  TdxChartXYDiagramStackedSeriesGroup = class(TdxChartXYDiagramSeriesGroup)
  protected type
    TSeriesStackingStyle = (StackPositiveValues, StackNegativeValues, PerPoint);
    TStackedValue = class
    public
      StackedPositiveValue: Double;
      StackedNegativeValue: Double;
      function ProcessValue(AValue: TdxChartXYSeriesValueViewInfo; AStackingStyle: TSeriesStackingStyle): Double;
      function StackValue(AValueViewInfo: TdxChartXYSeriesValueViewInfo; AActualValue: Double; var ABaseValue: Double): Double; inline;
    end;
  protected
    FValuesMap: TObjectDictionary<TdxChartXYSeriesValueViewInfo, TStackedValue>;
    procedure BeforeCalculate; override;
    procedure CheckViewInfoValue(AValue: TdxChartXYSeriesValueViewInfo; AStackingStyle: TSeriesStackingStyle; var AMinValue, AMaxValue: Double);
    procedure DoCalculate; override;
    function EnableReverseOrder: Boolean; override;
  public
    constructor Create(AOwner: TdxChartDiagramCustomViewData; AMasterSeries: TdxChartCustomSeries); override;
    destructor Destroy; override;
  end;

  { TdxChartXYDiagramFullStackedSeriesGroup }

  TdxChartXYDiagramFullStackedSeriesGroup = class(TdxChartXYDiagramStackedSeriesGroup)
  protected
    procedure AfterCalculate; override;
  end;

  TdxChartXYDiagramSelectionViewInfo = class(TdxChartCustomItemViewInfo) //for internal use
  protected
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
  end;

  { TdxChartXYDiagramViewData }

  TdxChartXYDiagramViewData = class(TdxChartDiagramCustomViewData)
  strict private
    FMaxValue: Double;
    FMinValue: Double;
    function GetDiagram: TdxChartXYDiagram;
  protected
    procedure DoCalculate; override;
    function GetSeriesGroupClass(ASeries: TdxChartCustomSeries): TdxChartDiagramSeriesGroupClass; override;
    function IsReverseOrder: Boolean; override;
    procedure MakeDirty; override;
  public
    property Diagram: TdxChartXYDiagram read GetDiagram;
    property MaxValue: Double read FMaxValue;
    property MinValue: Double read FMinValue;
  end;

  { TdxChartXYDiagramViewInfo }

  TdxChartXYDiagramViewInfo = class(TdxChartDiagramCustomViewInfo)  //for internal use
  strict private
    FPlotAreaViewInfo: TdxChartXYDiagramPlotAreaViewInfo;
    FAxisXViewInfo: TdxChartAxisViewInfo;
    FAxisYViewInfo: TdxChartAxisViewInfo;
    FFarEdgeAxisX: TdxChartCustomAxis;
    FFarEdgeAxisY: TdxChartCustomAxis;
    FNearEdgeAxisX: TdxChartCustomAxis;
    FNearEdgeAxisY: TdxChartCustomAxis;
    FSecondaryAxesX: TObjectList<TdxChartAxisViewInfo>;
    FSecondaryAxesY: TObjectList<TdxChartAxisViewInfo>;
    FSelectionViewInfo: TdxChartXYDiagramSelectionViewInfo;

    function CheckNeedCalculationRestart(ACurrentAxis: TdxChartCustomAxis): Boolean;
    procedure CorrectAvailableAreas(ACurrentAxis: TdxChartAxisViewInfo; ASecondaryIndex: Integer; var APlotArea: TdxRectF; var ANeedCalculationRestart: Boolean);
    function GetDiagram: TdxChartXYDiagram;
    function IsSecondaryAxesXDirty: Boolean;
    function IsSecondaryAxesYDirty: Boolean;
    procedure OffsetIntoItProjection(AAxis: TdxChartAxisViewInfo; var APlotArea: TdxRectF; var ANeedCalculationRestart: Boolean);
    procedure PrepareCustomAxisViewInfo(AViewInfo: TdxChartAxisViewInfo; ACanvas: TcxCustomCanvas);
    procedure PrepareSecondaryAxes(AForArguments: Boolean; ACanvas: TcxCustomCanvas);
    procedure PrepareSecondaryAxesIndents(AForArguments: Boolean; var ANearEdgeAxis, AFarEdgeAxis: TdxChartCustomAxis);
  protected
    function AdjustPlotAreaByLabelsBounding(ACanvas: TcxCustomCanvas): Boolean; override;
    procedure BeforeAxesCalculate(ACanvas: TcxCustomCanvas);
    procedure CalculateAxes(ACanvas: TcxCustomCanvas);
    function CalculateChartHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean; override;
    procedure CalculateViews(ACanvas: TcxCustomCanvas); override;
    procedure ResolveAxisLabelsOverlapping;
    procedure ResolveValueLabelsOverlapping;
    procedure DrawChart(ACanvas: TcxCustomCanvas); override;
    procedure EnableExportMode(AEnable: Boolean); override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetHitScrollableElement(const P: TdxPointF): IdxChartHitTestScrollableElement; override;
    function HasZeroBasedSeries: Boolean; override;
    function IsLabelsOutsideOfPlotArea: Boolean; override;
    function IsZoomed: Boolean;
    procedure RemoveSelectionRectangle;
    procedure UpdateLabelsBoundingRect(AValue: TdxChartSeriesValueViewInfo); override;
    procedure UpdateSelectionRectangle(ARect: TRect);

    property SecondaryAxesX: TObjectList<TdxChartAxisViewInfo> read FSecondaryAxesX;
    property SecondaryAxesY: TObjectList<TdxChartAxisViewInfo> read FSecondaryAxesY;
  public
    constructor Create(AOwner: TdxChartCustomDiagram); override;
    destructor Destroy; override;
    procedure DrawSecondLayer(ACanvas: TcxCustomCanvas);

    property AxisXViewInfo: TdxChartAxisViewInfo read FAxisXViewInfo;
    property AxisYViewInfo: TdxChartAxisViewInfo read FAxisYViewInfo;
    property Diagram: TdxChartXYDiagram read GetDiagram;
    property PlotAreaViewInfo: TdxChartXYDiagramPlotAreaViewInfo read FPlotAreaViewInfo;
  end;

  { TdxChartXYDiagramScrollableElement }

  TdxChartXYDiagramScrollableElement = class(TdxComponentReference<TdxChartXYDiagram>,
    IdxChartHitTestElement,
    IdxChartHitTestScrollableElement) //for internal use
  strict private
    FChangedHandlers: TdxNotifyEventHandler;
    FViewInfo: TdxChartXYDiagramViewInfo;
    function GetDiagram: TdxChartXYDiagram;
    function GetXAxisScrollBarData: TcxScrollBarData;
    function GetYAxisScrollBarData: TcxScrollBarData;

    // IdxChartHitTestElement
    function GetChartElement: TObject;
    function GetHitCode: TdxChartHitCode;
    function GetSubAreaCode: Integer;

    // IdxChartHitTestScrollableElement
    procedure AddChangedListener(AHandler: TNotifyEvent);
    function GetHorizontalScrollBarData: TcxScrollBarData;
    function GetScrollableArea: TRect;
    function GetVerticalScrollBarData: TcxScrollBarData;
    function IsPanArea(const APoint: TPoint): Boolean;
    function IsValid: Boolean;
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer);
    procedure RemoveChangedListener(AHandler: TNotifyEvent);

    property Diagram: TdxChartXYDiagram read GetDiagram;
  protected
    procedure DoObjectRemoved; override;
  public
    constructor Create(AViewInfo: TdxChartXYDiagramViewInfo);
  end;

  { TdxChartAxisValueLabelInfo }

  TdxChartAxisValueLabelInfo = class
  strict private
    FAxis: TdxChartCustomAxis;
    FAxisValue: Double;
    FText: string;
  public
    constructor Create(const AAxis: TdxChartCustomAxis; AAxisValue: Double; const AValueLabelText: string);
    function Equals(Obj: TObject): Boolean; override;
    property Axis: TdxChartCustomAxis read FAxis;
    property Text: string read FText;
  end;

  { TdxChartXYSeriesValueLabelsOverlappingResolver }

  TdxChartXYSeriesValueLabelsOverlappingResolver = class // for internal use
  strict private
    class procedure ArrangeLabel(AAlgorithm: TdxChartRectanglesLayoutAlgorithm; ALabel: TdxChartXYSeriesValueLabelViewInfo);
    class function IsVisible(const ARect: TRect; const APoint: TPoint): Boolean; inline;
    class procedure PopulateRects(AAlgorithm: TdxChartRectanglesLayoutAlgorithm; ALabels: TdxChartXYSeriesValueLabelViewInfoList);
  public
    class procedure Arrange(ALabels: TdxChartXYSeriesValueLabelViewInfoList; const ADiagramBounds: TdxRectF; AIndent: Single);
  end;


implementation

uses
  RTLConsts, Variants, cxVariants, dxChartColorScheme, cxLibraryConsts, dxChartCrosshair;

const
  dxThisUnitName = 'dxChartXYDiagram';

type
  TdxChartAccess = class(TdxChart);
  TdxChartCustomItemViewInfoAccess = class(TdxChartCustomItemViewInfo);
  TdxChartVisualElementAppearanceAccess = class(TdxChartVisualElementAppearance);
  TdxChartCustomLegendAccess = class(TdxChartCustomLegend);
  TdxChartSeriesAccess = class(TdxChartCustomSeries);

  TdxChartXYDiagramPlotAreaHitElement = class(TInterfacedObject, IdxChartHitTestPlotAreaElement) //for internal use
  strict private
    FDiagramViewInfo: TdxChartXYDiagramViewInfo;
  protected
    // IdxChartHitTestPlotAreaElement
    procedure GetDataPointFromCanvasPoint(const P: TdxPointF; out AArgument, AValue: Variant);
    function GetPlotArea: TObject;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseLeave;
  public
    constructor Create(ADiagramViewInfo: TdxChartXYDiagramViewInfo);
  end;

  { TdxChartNumericValueComparer }

  TdxChartNumericValueComparer = class(TEqualityComparer<TdxChartXYSeriesValueViewInfo>)
  public
    function Equals(const Left, Right: TdxChartXYSeriesValueViewInfo): Boolean; override;
    function GetHashCode(const Value: TdxChartXYSeriesValueViewInfo): Integer; override;
  end;

  { TdxChartStringValueComparer }

  TdxChartStringValueComparer = class(TEqualityComparer<TdxChartXYSeriesValueViewInfo>)
  public
    function Equals(const Left, Right: TdxChartXYSeriesValueViewInfo): Boolean; override;
    function GetHashCode(const Value: TdxChartXYSeriesValueViewInfo): Integer; override;
  end;

  { TdxChartAxisHorizontalDirectionHelper }

  TdxChartAxisHorizontalDirectionHelper = class(TdxChartAxisViewInfoCalculationHelper)
  protected
    class function IsHorizontal: Boolean; override;
    class function GetLongitudinalSize(const ASize: TdxSizeF): Single; override;
    class function GetTransversalSize(const ASize: TdxSizeF): Single; override;
    class procedure SetFarLongitudinalValue(var R: TdxRectF; AValue: Single); override;
    class procedure SetNearLongitudinalValue(var R: TdxRectF; AValue: Single); override;
    class function AxisIncludesTickmark(AViewInfo: TdxChartAxisViewInfo; ATickmark: TdxChartAxisCustomTickViewInfo): Boolean; override;
    class procedure CalculateLineEnds(AViewInfo: TdxChartAxisViewInfo;
      AAnchor, AThickness: Single; const ALineBounds: TdxRectF; var AStart, AFinish: TdxPointF); override;
    class procedure CalculateViewpoint(AAxis: TdxChartCustomAxis;
      const ABounds: TdxRectF; out AOffset: Single; out AOffsetDirection: TValueSign); override;
    class function GetAxisLineProjectionCanvasValue(AViewInfo: TdxChartAxisViewInfo): Single; override;
    class function GetInterlacedBounds(AStart, AFinish: Single; const APattern: TdxRectF): TdxRectF; override;
    class function GetLabelsAreaTransversalSize(AViewInfo: TdxChartAxisViewInfo): Single; override;
    class function GetLabelRectStart(AViewInfo: TdxChartAxisViewInfo; ATickCanvasValue, ATextLongitudinalSize: Single; ALabelAlignment: TdxAlignment): Single; override;
    class function GetOccupiedSides(AViewInfo: TdxChartAxisViewInfo; const AArea: TdxRectF): TcxBorders; override;
    class function GetTransversalOffsetDistance(AOffset: Single): TdxPointF; override;
    class function LabelsAreaCanIntersectsWith(const R: TdxRectF; AViewInfo: TdxChartAxisViewInfo): Boolean; override;
    class function SelectFarFromBorder(AViewInfo: TdxChartAxisViewInfo; const R1, R2: TdxRectF): TdxRectF; override;
    class procedure UpdateGridline(AViewInfo: TdxChartAxisViewInfo; AGridline: TdxChartAxisGridlineViewInfo; const APlotArea: TdxRectF); override;
    class procedure UpdateInterlaced(AViewInfo: TdxChartAxisViewInfo; AInterlaced: TdxChartXYDiagramInterlacedViewInfo; const APlotArea: TdxRectF); override;
    class procedure ResolveOverlapping(AViewInfo: TdxChartAxisViewInfo); override;
    class procedure StaggerLabels(AViewInfo: TdxChartAxisViewInfo);
  end;

  { TdxChartAxisHorizontalFarDirectionHelper }

  TdxChartAxisHorizontalFarDirectionHelper = class(TdxChartAxisHorizontalDirectionHelper)
  protected
    class function GetSign: TValueSign; override;
    class function IsFar: Boolean; override;
    class procedure ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single); override;
    class function GetFarTransversalValue(const R: TdxRectF): Single; override;
    class function GetNearTransversalValue(const R: TdxRectF): Single; override;
    class procedure SetFarTransversalValue(var R: TdxRectF; AValue: Single); override;
    class procedure SetNearTransversalValue(var R: TdxRectF; AValue: Single); override;
    class procedure CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo; out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF); override;
    class function GetActualTitlePosition(AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition; override;
    class function GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single; override;
    class procedure IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo; var ABounds: TdxRectF); override;
  end;

  { TdxChartAxisHorizontalNearDirectionHelper }

  TdxChartAxisHorizontalNearDirectionHelper = class(TdxChartAxisHorizontalDirectionHelper)
  protected
    class function IsNear: Boolean; override;
    class procedure ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single); override;
    class function GetFarTransversalValue(const R: TdxRectF): Single; override;
    class function GetNearTransversalValue(const R: TdxRectF): Single; override;
    class procedure SetFarTransversalValue(var R: TdxRectF; AValue: Single); override;
    class procedure SetNearTransversalValue(var R: TdxRectF; AValue: Single); override;
    class procedure CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo; out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF); override;
    class function GetActualTitlePosition(AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition; override;
    class function GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single; override;
    class procedure IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo; var ABounds: TdxRectF); override;
  end;

  { TdxChartAxisHorizontalCenterDirectionHelper }

  TdxChartAxisHorizontalCenterDirectionHelper = class(TdxChartAxisHorizontalNearDirectionHelper)
  protected
    class function IsCenter: Boolean; override;
    class procedure ExpandNearTransversalBorder(var ABounds: TdxRectF; dValue: Single); override;
    class function GetActualTitlePosition(AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition; override;
    class function GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
  end;

  { TdxChartAxisVerticalDirectionHelper }

  TdxChartAxisVerticalDirectionHelper = class(TdxChartAxisViewInfoCalculationHelper)
  protected
    class function GetLongitudinalSize(const ASize: TdxSizeF): Single; override;
    class function GetTransversalSize(const ASize: TdxSizeF): Single; override;
    class procedure SetFarLongitudinalValue(var R: TdxRectF; AValue: Single); override;
    class procedure SetNearLongitudinalValue(var R: TdxRectF; AValue: Single); override;
    class function AxisIncludesTickmark(AViewInfo: TdxChartAxisViewInfo; ATickmark: TdxChartAxisCustomTickViewInfo): Boolean; override;
    class procedure CalculateLineEnds(AViewInfo: TdxChartAxisViewInfo; AAnchor, AThickness: Single;
      const ALineBounds: TdxRectF; var AStart, AFinish: TdxPointF); override;
    class procedure CalculateViewpoint(AAxis: TdxChartCustomAxis;
      const ABounds: TdxRectF; out AOffset: Single; out AOffsetDirection: TValueSign); override;
    class function GetAxisLineProjectionCanvasValue(AViewInfo: TdxChartAxisViewInfo): Single; override;
    class function GetInterlacedBounds(AStart, AFinish: Single; const APattern: TdxRectF): TdxRectF; override;
    class function GetLabelsAreaTransversalSize(AViewInfo: TdxChartAxisViewInfo): Single; override;
    class function GetLabelRectStart(AViewInfo: TdxChartAxisViewInfo; ATickCanvasValue, ATextLongitudinalSize: Single; ALabelAlignment: TdxAlignment): Single; override;
    class function GetOccupiedSides(AViewInfo: TdxChartAxisViewInfo; const AArea: TdxRectF): TcxBorders; override;
    class function GetTransversalOffsetDistance(AOffset: Single): TdxPointF; override;
    class function LabelsAreaCanIntersectsWith(const R: TdxRectF; AViewInfo: TdxChartAxisViewInfo): Boolean; override;
    class function SelectFarFromBorder(AViewInfo: TdxChartAxisViewInfo; const R1, R2: TdxRectF): TdxRectF; override;
    class procedure UpdateGridline(AViewInfo: TdxChartAxisViewInfo; AGridline: TdxChartAxisGridlineViewInfo; const APlotArea: TdxRectF); override;
    class procedure UpdateInterlaced(AViewInfo: TdxChartAxisViewInfo; AInterlaced: TdxChartXYDiagramInterlacedViewInfo; const APlotArea: TdxRectF); override;
    class procedure ResolveOverlapping(AViewInfo: TdxChartAxisViewInfo); override;
    class procedure StaggerLabels(AViewInfo: TdxChartAxisViewInfo);
  end;

  { TdxChartAxisVerticalFarDirectionHelper }

  TdxChartAxisVerticalFarDirectionHelper = class(TdxChartAxisVerticalDirectionHelper)
  protected
    class function IsFar: Boolean; override;
    class procedure ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single); override;
    class function GetFarTransversalValue(const R: TdxRectF): Single; override;
    class function GetNearTransversalValue(const R: TdxRectF): Single; override;
    class procedure SetFarTransversalValue(var R: TdxRectF; AValue: Single); override;
    class procedure SetNearTransversalValue(var R: TdxRectF; AValue: Single); override;
    class procedure CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo; out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF); override;
    class function GetActualTitlePosition(AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition; override;
    class function GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single; override;
    class procedure IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo; var ABounds: TdxRectF); override;
  end;

  { TdxChartAxisVerticalNearDirectionHelper }

  TdxChartAxisVerticalNearDirectionHelper = class(TdxChartAxisVerticalDirectionHelper)
  protected
    class function GetSign: TValueSign; override;
    class function IsNear: Boolean; override;
    class procedure ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single); override;
    class function GetFarTransversalValue(const R: TdxRectF): Single; override;
    class function GetNearTransversalValue(const R: TdxRectF): Single; override;
    class procedure SetFarTransversalValue(var R: TdxRectF; AValue: Single); override;
    class procedure SetNearTransversalValue(var R: TdxRectF; AValue: Single); override;
    class procedure CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo; out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF); override;
    class function GetActualTitlePosition(AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition; override;
    class function GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single; override;
    class procedure IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo; var ABounds: TdxRectF); override;
  end;

  { TdxChartAxisVerticalCenterDirectionHelper }

  TdxChartAxisVerticalCenterDirectionHelper = class(TdxChartAxisVerticalNearDirectionHelper)
  protected
    class function IsCenter: Boolean; override;
    class procedure ExpandNearTransversalBorder(var ABounds: TdxRectF; dValue: Single); override;
    class function GetActualTitlePosition(AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition; override;
    class function GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
    class function GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF; override;
  end;

  { TdxChartMarqueeZoomDragAndDropObject }

  TdxChartMarqueeZoomDragAndDropObject = class(TdxChartDragAndDropObjectBase)
  private
    FEndPoint: TPoint;
    function GetDiagramViewInfo: TdxChartXYDiagramViewInfo;
    function GetDiagram: TdxChartXYDiagram;
    function GetSelectionRect: TdxRectF;
    property Diagram: TdxChartXYDiagram read GetDiagram;
    property DiagramViewInfo: TdxChartXYDiagramViewInfo read GetDiagramViewInfo;
  protected
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    procedure EndDragAndDrop(Accepted: Boolean); override;
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
  end;

  TdxChartPanDragAndDropObject = class(TdxChartDragAndDropObjectBase)
  private
    FInitialScrollPos: TPoint;
    function GetDiagram: TdxChartXYDiagram;
  protected
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
    property Diagram: TdxChartXYDiagram read GetDiagram;
  public
    procedure Init(ADiagram: TdxChartCustomDiagram; AStartPoint: TPoint); override;
  end;

  TdxChartZoomInActionExecutorBase = class(TdxChartMouseActionExecutor)
    function GetDefaultMouseCursor: TCursor; override;
    function IsAvailableFor(ADiagram: TdxChartCustomDiagram): Boolean; override;
  end;

  TdxChartMarqueeZoomActionExecutor = class(TdxChartZoomInActionExecutorBase)
  protected
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; override;
  end;

  TdxChartZoomInActionExecutor = class(TdxChartZoomInActionExecutorBase)
  protected
    procedure MouseUp(ADiagram: TdxChartCustomDiagram; AMouseX, AMouseY: Integer); override;
  end;

  TdxChartZoomOutActionExecutor = class(TdxChartMouseActionExecutor)
  protected
    function GetDefaultMouseCursor: TCursor; override;
    function IsAvailableFor(ADiagram: TdxChartCustomDiagram): Boolean; override;
    procedure MouseUp(ADiagram: TdxChartCustomDiagram; AMouseX, AMouseY: Integer); override;
  end;

  TdxChartPanActionExecutor = class(TdxChartMouseActionExecutor)
  protected
    function GetDefaultMouseCursor: TCursor; override;
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; override;
    function IsAvailableFor(ADiagram: TdxChartCustomDiagram): Boolean; override;
  end;

function AreaWasDecrease(const AArea, AOldArea: TdxRectF): Boolean; inline;
begin
  Result := (AArea.Width < AOldArea.Width) or (AArea.Height < AOldArea.Height);
end;

function HasRectIntersection(R1, R2, R3: PdxRectF): Boolean; inline;
begin
  Result := (R1 <> nil) and cxRectIntersect(R1^, R3^) or (R2 <> nil) and cxRectIntersect(R2^, R3^);
end;

function HasPolygonIntersection(const Pg1, Pg2, Pg3: PdxPolygonF): Boolean;
var
  AIntersectionPoint: TdxPointF;
begin
  Result := (Pg1 <> nil) and Pg1^.IntersectsWith(Pg3^, AIntersectionPoint) or
            (Pg2 <> nil) and Pg2^.IntersectsWith(Pg3^, AIntersectionPoint);
end;

procedure CheckMin(var AFieldValue: Double; const AValue: Double); inline;
begin
  if IsNan(AFieldValue) then
    AFieldValue := AValue
  else
    if AFieldValue > AValue then
      AFieldValue := AValue;
end;

procedure CheckMax(var AFieldValue: Double; const AValue: Double); inline;
begin
  if IsNan(AFieldValue) then
    AFieldValue := AValue
  else
    if AFieldValue < AValue then
      AFieldValue := AValue;
end;

procedure CheckMinMax(var AMinValue, AMaxValue: Double; const AMinCandidate, AMaxCandidate: Double); overload;
begin
  CheckMax(AMaxValue, AMaxCandidate);
  CheckMin(AMinValue, AMinCandidate);
end;

procedure CheckMinMax(var AMinValue, AMaxValue: Double; const AValue: Double); overload;
begin
  CheckMin(AMinValue, AValue);
  CheckMax(AMaxValue, AValue);
end;

function IsNotAssigned(const AValue: Variant): Boolean; inline;
begin
  Result := VarIsSoftEmpty(AValue) or VarIsSoftNull(AValue);
end;

function IsAssigned(const AValue: Variant): Boolean; inline;
begin
  Result := not IsNotAssigned(AValue);
end;

{ TdxChartViewInfoNumericValueComparer }

function TdxChartNumericValueComparer.Equals(const Left, Right: TdxChartXYSeriesValueViewInfo): Boolean;
begin
  Result := SameValue(Left.Argument, Right.Argument);
end;

function TdxChartNumericValueComparer.GetHashCode(const Value: TdxChartXYSeriesValueViewInfo): Integer;
begin
  Result := dxBobJenkinsHash(Value.FArgument, SizeOf(Double), 0);
end;

{ TdxChartStringValueComparer }

function TdxChartStringValueComparer.Equals(const Left, Right: TdxChartXYSeriesValueViewInfo): Boolean;
begin
  Result := Left.ArgumentDisplayText = Right.ArgumentDisplayText;
end;

function TdxChartStringValueComparer.GetHashCode(const Value: TdxChartXYSeriesValueViewInfo): Integer;
begin
  Result := dxElfHash(Value.ArgumentDisplayText);
end;

{ TdxChartDataRange }

function TdxChartDataRange.Range: Double;
begin
  Result := Max - Min;
end;

{ TdxChartRange }

constructor TdxChartRange.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FAutoSideMargins := True;
  FAxis := AOwner as TdxChartCustomAxis;
end;

constructor TdxChartRange.CreateUnattached(AAxis: TdxChartCustomAxis);
begin
  inherited Create(nil);
  FAxis := AAxis;
end;

procedure TdxChartRange.Calculate;
begin
  CalculateRealWholeRange;
  CalculateSideMargin;
  CalculateVisibleRange;
end;

procedure TdxChartRange.Changed;
begin
  if Owner <> nil then
  begin
    Axis.ViewData.MakeDirty;
    TdxChartXYDiagramViewData(Axis.Diagram.ViewData).MakeDirty;
    inherited Changed;
  end;
end;

procedure TdxChartRange.DoAssign(Source: TPersistent);
var
  ASource: TdxChartRange;
begin
  inherited DoAssign(Source);
  if Source is TdxChartRange then
  begin
    ASource := TdxChartRange(Source);
    FWholeMin := ASource.WholeMin;
    FWholeMax := ASource.WholeMax;
    FVisibleMin := ASource.VisibleMin;
    FVisibleMax := ASource.VisibleMax;
    FAutoSideMargins := ASource.AutoSideMargins;
    FSideMarginMax := ASource.SideMarginMax;
    FSideMarginMin := ASource.SideMarginMin;
    RealVisibleRange := ASource.RealVisibleRange;
    FIsNonNumericScrollingActive := ASource.IsNonNumericScrollingActive;
    FIsVisibleRangeLocked := ASource.FIsVisibleRangeLocked;
  end;
end;

function TdxChartRange.GetValueType: TVarType;
begin
  Result := Axis.GetValueType;
end;

function TdxChartRange.GetZoomPercent: Single;
begin
  if IsZero(RealWholeRange.Range) then
    Result := 100
  else if IsZero(VisibleRangeExtended.Range) then
    Result := Infinity
  else
    Result := RealWholeRange.Range / VisibleRangeExtended.Range * 100;
end;

function TdxChartRange.IsAutoVisibleRange: Boolean;
begin
  Result := IsNotAssigned(VisibleMin) and IsNotAssigned(VisibleMax);
end;

function TdxChartRange.IsAutoWholeRange: Boolean;
begin
  Result := IsNotAssigned(WholeMin) and IsNotAssigned(WholeMax);
end;

function TdxChartRange.IsValidRangeBound(const AValue: Variant): Boolean;
begin
  Result := IsNotAssigned(AValue) or not IsNaN(Axis.ViewData.AxisValueAsDouble(AValue));
end;

procedure TdxChartRange.Zoom(AZoomType: TZoomType; AStepPercent: Single;
  AStepCount: Integer; AMaxPercent: Single; ABearingAxisValue: Double);
var
  AResultRange: TdxChartDataRange;
  AResultRangeSize: Double;
  AMinRangeSize: Double;
begin
  if IsZero(VisibleRangeExtended.Range) or IsZero(WholeRangeExtended.Range) then
    Exit;
  if AZoomType = TZoomType.ResetZoom then
  begin
    VisibleMin := Unassigned;
    VisibleMax := Unassigned;
  end
  else
  begin
    if (AStepCount = 0) or IsZero(AStepPercent) then
      Exit;
    AMinRangeSize := RealWholeRange.Range / (AMaxPercent / 100);
    if not Axis.IsNumeric and (AMinRangeSize < 1) then
      AMinRangeSize := 1;
    if AStepPercent < 0 then
    begin
      AStepPercent := -AStepPercent;
      AStepCount := -AStepCount;
    end;
    AResultRangeSize := VisibleRangeExtended.Range / Power(1 + AStepPercent / 100, AStepCount);
    if AResultRangeSize < AMinRangeSize then
      AResultRangeSize := AMinRangeSize;
    if AZoomType = TZoomType.CenteredBearingValue then
      AResultRange.Min := ABearingAxisValue - AResultRangeSize / 2
    else
      AResultRange.Min := ABearingAxisValue - AResultRangeSize * (ABearingAxisValue - VisibleRangeExtended.Min) / VisibleRangeExtended.Range;
    AResultRange.Max := AResultRange.Min + AResultRangeSize;
    if AutoSideMargins and (AStepCount < 0) and Axis.IsNumeric
       and ((AResultRange.Max > WholeRangeExtended.Max) or (AResultRange.Min < WholeRangeExtended.Min)) then
    begin
      if AResultRangeSize <= WholeRangeExtended.Range then
      begin
        VisibleMin := WholeRangeExtended.Min;
        VisibleMax := WholeRangeExtended.Min + AResultRangeSize;
      end
      else
      begin
        VisibleMin := RealWholeRange.Min - (AResultRangeSize - RealWholeRange.Range) / 2;
        VisibleMax := RealWholeRange.Max + (AResultRangeSize - RealWholeRange.Range) / 2;
      end;
      CalculateSideMargin;
      CalculateVisibleRange;
    end;
    AResultRange.Max := Min(AResultRange.Max, WholeRangeExtended.Max);
    AResultRange.Min := Max(AResultRange.Max - AResultRangeSize, WholeRangeExtended.Min);
    AResultRange.Max := Min(AResultRange.Min + AResultRangeSize, WholeRangeExtended.Max);
    if Axis.IsNumeric then
    begin
      VisibleMin := AResultRange.Min;
      VisibleMax := AResultRange.Max;
    end
    else
    begin
      VisibleMin := AResultRange.Min + 0.5;
      VisibleMax := AResultRange.Max - 0.5;
    end;
  end;
end;

procedure TdxChartRange.ZoomIn(AVisibleMin, AVisibleMax: Double; AMaxPercent: Single);
var
  AResultRange: TdxChartDataRange;
  AMinRangeSize: Double;
  ACenter: Double;
begin
  if IsZero(VisibleRangeExtended.Range) or IsZero(WholeRangeExtended.Range) then
    Exit;
  if AVisibleMax - AVisibleMin >= VisibleRangeExtended.Range then
    Exit;
  AMinRangeSize := RealWholeRange.Range / (AMaxPercent / 100);
  if not Axis.IsNumeric and (AMinRangeSize < 1) then
    AMinRangeSize := 1;
  if AVisibleMax - AVisibleMin < AMinRangeSize then
  begin
    ACenter := (AVisibleMin + AVisibleMax) / 2;
    AResultRange.Min := Max(ACenter - AMinRangeSize / 2, WholeRangeExtended.Min);
    AResultRange.Max := Min(AResultRange.Min + AMinRangeSize, WholeRangeExtended.Max);
  end
  else
  begin
    AResultRange.Min := AVisibleMin;
    AResultRange.Max := AVisibleMax;
  end;
  if AutoSideMargins and Axis.IsNumeric and ((AResultRange.Min < RealWholeRange.Min) or (AResultRange.Max > RealWholeRange.Max)) then
  begin
    if AResultRange.Range <= RealWholeRange.Range then
    begin
      VisibleMin := RealWholeRange.Min;
      VisibleMax := RealWholeRange.Min + AResultRange.Range;
    end
    else
    begin
      VisibleMin := RealWholeRange.Min - (AResultRange.Range - RealWholeRange.Range) * ActualSideMarginMin / (ActualSideMarginMin + ActualSideMarginMax);
      VisibleMax := VisibleMin + AResultRange.Range;
    end;
    CalculateSideMargin;
    CalculateVisibleRange;
    AResultRange.Max := Min(AResultRange.Max, WholeRangeExtended.Max);
    AResultRange.Min := Max(AResultRange.Max - VisibleRangeExtended.Range, WholeRangeExtended.Min);
    AResultRange.Max := Min(AResultRange.Min + VisibleRangeExtended.Range, WholeRangeExtended.Max);
  end;
  if Axis.IsNumeric then
  begin
    VisibleMin := AResultRange.Min;
    VisibleMax := AResultRange.Max;
  end
  else
  begin
    VisibleMin := AResultRange.Min + 0.5;
    VisibleMax := AResultRange.Max - 0.5;
  end;
end;


procedure TdxChartRange.CalculateRealWholeRange;
begin
  RealWholeRange.Min := Axis.ViewData.AxisValueAsDouble(WholeMin);
  if IsNaN(RealWholeRange.Min) then
    RealWholeRange.Min := Axis.ViewData.GetMin;

  RealWholeRange.Max := Axis.ViewData.AxisValueAsDouble(WholeMax);
  if IsNaN(RealWholeRange.Max) then
    RealWholeRange.Max := Axis.ViewData.GetMax;

  RealWholeRange.Max := Max(RealWholeRange.Min, RealWholeRange.Max);
end;

procedure TdxChartRange.CalculateSideMargin;

  function GetAutoSideMargin(const AWholeRangeBorderValue: Double): Double;
  begin
    if not Axis.IsArgumentAxis and TdxChartXYDiagramViewInfo(TdxChartXYDiagram(Axis.Diagram).ViewInfo).HasZeroBasedSeries and
       IsZero(AWholeRangeBorderValue) then
      Result := 0
    else
      Result := Axis.ViewData.GetTickStep(Self) / 2;
  end;

begin
  if AutoSideMargins then
  begin
    FActualSideMarginMax := GetAutoSideMargin(RealWholeRange.Max);
    FActualSideMarginMin := GetAutoSideMargin(RealWholeRange.Min);
  end
  else
  begin
    FActualSideMarginMax := FSideMarginMax;
    FActualSideMarginMin := FSideMarginMin;
  end;
end;

procedure TdxChartRange.CalculateVisibleRange;
var
  AOldRangeSize: Double;
begin
  if FIsNonNumericScrollingActive then
  begin
    FIsNonNumericScrollingActive := False;
    Exit;
  end;

  if IsZero(RealWholeRange.Range) and not FIsVisibleRangeLocked then
  begin
    FVisibleMin := Unassigned;
    FVisibleMax := Unassigned;
  end;

  AOldRangeSize := RealVisibleRange.Range;
  if Axis.IsNumeric then
  begin
    RealVisibleRange.Min := WholeRangeExtended.Min;
    RealVisibleRange.Max := WholeRangeExtended.Max;
    if IsAssigned(VisibleMin) and IsValidRangeBound(VisibleMin) then
      RealVisibleRange.Min := Min(Max(Axis.ViewData.AxisValueAsDouble(VisibleMin), WholeRangeExtended.Min), WholeRangeExtended.Max);
    if IsAssigned(VisibleMax) and IsValidRangeBound(VisibleMax) then
      RealVisibleRange.Max := Max(Min(Axis.ViewData.AxisValueAsDouble(VisibleMax), WholeRangeExtended.Max), WholeRangeExtended.Min);
    RealVisibleRange.Max := Max(RealVisibleRange.Min, RealVisibleRange.Max);
    if (IsZero(RealVisibleRange.Range) or not FIsVisibleRangeLocked and (RealVisibleRange.Range < AOldRangeSize)) and not IsZero(RealWholeRange.Range) then
    begin
      if SameValue(RealVisibleRange.Min, WholeRangeExtended.Min) then
        RealVisibleRange.Max := Min(RealVisibleRange.Min + AOldRangeSize, WholeRangeExtended.Max)
      else if SameValue(RealVisibleRange.Max, WholeRangeExtended.Max) then
        RealVisibleRange.Min := Max(RealVisibleRange.Max - AOldRangeSize, WholeRangeExtended.Min);
    end;
  end
  else
  begin
    RealVisibleRange.Min := WholeRangeExtended.Min + 0.5;
    RealVisibleRange.Max := WholeRangeExtended.Max - 0.5;
    if IsAssigned(VisibleMin) and IsValidRangeBound(VisibleMin) then
      RealVisibleRange.Min := Min(Max(Axis.ViewData.AxisValueAsDouble(VisibleMin), WholeRangeExtended.Min + 0.5), WholeRangeExtended.Max - 0.5);
    if IsAssigned(VisibleMax) and IsValidRangeBound(VisibleMax) then
      RealVisibleRange.Max := Max(Min(Axis.ViewData.AxisValueAsDouble(VisibleMax), WholeRangeExtended.Max - 0.5), WholeRangeExtended.Min + 0.5);
    if RealVisibleRange.Min > RealVisibleRange.Max then
    begin
      RealVisibleRange.Min := (RealVisibleRange.Min + RealVisibleRange.Max) / 2;
      RealVisibleRange.Max := RealVisibleRange.Min;
    end;
    if not FIsVisibleRangeLocked and (RealVisibleRange.Range < AOldRangeSize) and not IsZero(RealWholeRange.Range) then
    begin
      if SameValue(RealVisibleRange.Min, WholeRangeExtended.Min + 0.5) then
        RealVisibleRange.Max := Min(RealVisibleRange.Min + AOldRangeSize, WholeRangeExtended.Max - 0.5)
      else if SameValue(RealVisibleRange.Max, WholeRangeExtended.Max - 0.5) then
        RealVisibleRange.Min := Max(RealVisibleRange.Max - AOldRangeSize, WholeRangeExtended.Min + 0.5);
    end;
  end;
  if IsAssigned(FVisibleMin) and not VarEquals(FVisibleMin, RealVisibleRange.Min) then
    FVisibleMin := FAxis.ViewData.DoubleToAxisValue(RealVisibleRange.Min);
  if IsAssigned(FVisibleMax) and not VarEquals(FVisibleMax, RealVisibleRange.Max) then
    FVisibleMax := FAxis.ViewData.DoubleToAxisValue(RealVisibleRange.Max);
  FIsVisibleRangeLocked := False;
end;

function TdxChartRange.GetVisibleRangeExtended: TdxChartDataRange;
begin
  if Axis.IsNumeric then
  begin
    Result.Min := RealVisibleRange.Min;
    Result.Max := RealVisibleRange.Max;
  end
  else
  begin
    Result.Min := RealVisibleRange.Min - 0.5;
    Result.Max := RealVisibleRange.Max + 0.5;
  end;
end;

function TdxChartRange.GetWholeRangeExtended: TdxChartDataRange;
begin
  Result.Min := RealWholeRange.Min - FActualSideMarginMin;
  Result.Max := RealWholeRange.Max + FActualSideMarginMax;
end;

procedure TdxChartRange.SetAutoSideMargins(const Value: Boolean);
begin
  if FAutoSideMargins <> Value then
  begin
    FAutoSideMargins := Value;
    Changed;
  end;
end;

procedure TdxChartRange.SetSideMarginMax(AValue: Double);
begin
  if not VarEquals(FSideMarginMax, AValue) or FAutoSideMargins then
  begin
    if AValue.SpecialType = fsPositive then
      FSideMarginMax := AValue
    else
      FSideMarginMax := 0;
    Changed;
  end;
end;

procedure TdxChartRange.SetSideMarginMin(AValue: Double);
begin
  if not VarEquals(FSideMarginMin, AValue) or FAutoSideMargins then
  begin
    if AValue.SpecialType = fsPositive then
      FSideMarginMin := AValue
    else
      FSideMarginMin := 0;
    Changed;
  end;
end;

procedure TdxChartRange.SetVisibleMax(AValue: Variant);
begin
  if (VarType(FVisibleMax) <> VarType(AValue)) or not VarEquals(FVisibleMax, AValue) then
  begin
    FVisibleMax := AValue;
    FIsNonNumericScrollingActive := False;
    FIsVisibleRangeLocked := True;
    Changed;
  end;
end;

procedure TdxChartRange.SetVisibleMin(AValue: Variant);
begin
  if (VarType(FVisibleMin) <> VarType(AValue)) or not VarEquals(FVisibleMin, AValue) then
  begin
    FVisibleMin := AValue;
    FIsNonNumericScrollingActive := False;
    FIsVisibleRangeLocked := True;
    Changed;
  end;
end;

procedure TdxChartRange.SetWholeMin(AValue: Variant);
begin
  if (VarType(FWholeMin) <> VarType(AValue)) or not VarEquals(FWholeMin, AValue) then
  begin
    FWholeMin := AValue;
    Changed;
  end;
end;

procedure TdxChartRange.SetWholeMax(AValue: Variant);
begin
  if (VarType(FWholeMax) <> VarType(AValue)) or not VarEquals(FWholeMax, AValue) then
  begin
    FWholeMax := AValue;
    Changed;
  end;
end;

function TdxChartRange.IsVisibleMaxStored: Boolean;
begin
  Result := IsAssigned(FVisibleMax);
end;

function TdxChartRange.IsVisibleMinStored: Boolean;
begin
  Result := IsAssigned(FVisibleMin);
end;

function TdxChartRange.IsWholeMaxStored: Boolean;
begin
  Result := IsAssigned(FWholeMax);
end;

function TdxChartRange.IsWholeMinStored: Boolean;
begin
  Result := IsAssigned(FWholeMin);
end;

function TdxChartRange.IsZoomed: Boolean;
begin
  Result := not SameValue(WholeRangeExtended.Range, VisibleRangeExtended.Range);
end;

{ TdxChartAxisDataValueConverter }

function TdxChartAxisDataValueConverter.AxisValueToDataValue(const AValue: Double): Double;
begin
  Result := AValue;
end;

function TdxChartAxisDataValueConverter.DataValueToAxisValue(const AValue: Double): Double;
begin
  Result := AValue;
end;

{ TdxChartLogarithmicAxisDataValueConverter }

constructor TdxChartLogarithmicAxisDataValueConverter.Create(const ALogarithmBase: Double);
begin
  FLogarithmBase := ALogarithmBase;
end;

function TdxChartLogarithmicAxisDataValueConverter.AxisValueToDataValue(const AValue: Double): Double;
begin
  Result := Power(FLogarithmBase, AValue);
end;

function TdxChartLogarithmicAxisDataValueConverter.DataValueToAxisValue(const AValue: Double): Double;
begin
  if AValue <> 0 then
  begin
    if AValue >= 0 then
      Result := LogN(FLogarithmBase, AValue)
    else
      Result := -LogN(FLogarithmBase, -AValue);
  end
  else
    Result := NaN;
end;

{ TdxChartAxisLineViewInfo }

constructor TdxChartAxisLineViewInfo.Create(AOwner: TdxChartAxisLinesViewInfo);
begin
  // do nothing
end;

procedure TdxChartAxisLineViewInfo.Offset(const ADistance: TdxPointF);
begin
  Start.Offset(ADistance);
  Finish.Offset(ADistance);
  Bounds.Offset(ADistance);
end;

procedure TdxChartAxisLineViewInfo.UpdateBounds(const ABounds: TdxRectF; const AStart, AFinish: TdxPointF);
begin
  FBounds := ABounds;
  FFinish := AFinish;
  FStart := AStart;
end;

{ TdxChartAxisLinesViewInfo }

constructor TdxChartAxisLinesViewInfo.Create(AOwner: TdxChartAxisViewInfo);
begin
  inherited Create;
  FOwner := AOwner;
  FList := TdxFastObjectList.Create(True);
end;

destructor TdxChartAxisLinesViewInfo.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TdxChartAxisLinesViewInfo.Add: TdxChartAxisLineViewInfo;
begin
  Result := FItemViewInfoClass.Create(Self);
  FList.Add(Result);
end;

procedure TdxChartAxisLinesViewInfo.CalculateBounds(const AVisibleBounds: TdxRectF);
var
  ABounds: TdxRectF;
  I: Integer;
begin
  ABounds := TdxRectF.Null;
  if Count > 0 then
  begin
    ABounds := Items[0].Bounds;
    for I := 1 to Count - 1 do
      ABounds.Union(Items[I].Bounds);
  end;
  UpdateBounds(ABounds, AVisibleBounds);
end;

procedure TdxChartAxisLinesViewInfo.Clear;
begin
  FList.Clear;
end;

procedure TdxChartAxisLinesViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  ALine: TdxChartAxisLineViewInfo;
  APath: TcxCanvasBasedPath;
  APen: TcxCanvasBasedPen;
  I: Integer;
begin
  APen := GetActualPen;
  if FIsExportMode then
  begin
    for I := 0 to FList.Count - 1 do
    begin
      ALine := TdxChartAxisLineViewInfo(FList.List[I]);
      if ALine.Visible then
        ACanvas.Line(ALine.Start, ALine.Finish, APen);
    end;
  end
  else
  begin
    APath := ACanvas.CreatePath;
    try
      for I := 0 to FList.Count - 1 do
      begin
        ALine := TdxChartAxisLineViewInfo(FList.List[I]);
        if ALine.Visible then
        begin
          APath.FigureStart;
          APath.AddLine(ALine.Start, ALine.Finish);
        end;
      end;
      ACanvas.Path(APath, nil, APen);
    finally
      APath.Free;
    end;
  end;
end;

procedure TdxChartAxisLinesViewInfo.EnsureCapacity(ACount: Integer);
begin
  FList.Capacity := Max(FList.Capacity, FList.Count + ACount);
end;

procedure TdxChartAxisLinesViewInfo.Offset(const ADistance: TdxPointF);
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    TdxChartAxisLineViewInfo(FList.List[I]).Offset(ADistance);
  inherited Offset(ADistance);
end;

function TdxChartAxisLinesViewInfo.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TdxChartAxisLinesViewInfo.GetItem(Index: Integer): TdxChartAxisLineViewInfo;
begin
  Result := FList.List[Index];
end;

{ TdxChartAxisCustomTickViewInfo }

constructor TdxChartAxisCustomTickViewInfo.Create(AOwner: TdxChartAxisLinesViewInfo);
begin
  inherited Create(AOwner);
  FAxis := AOwner.Owner.Axis;
end;

function TdxChartAxisCustomTickViewInfo.GetDataValue: Double;
begin
  Result := AxisValue;
  if FAxis.DataValueConverter <> nil then
    FAxis.DataValueConverter.AxisValueToDataValue(Result);
end;

{ TdxChartAxisTickDockedObjectViewInfo }

constructor TdxChartAxisTickDockedObjectViewInfo.Create(AAxisTick: TdxChartAxisCustomTickViewInfo);
begin
  inherited Create;
  FAxisTick := AAxisTick;
end;

{ TdxChartAxisTickLabelViewInfo }

constructor TdxChartAxisTickLabelViewInfo.Create(AAxisTick: TdxChartAxisCustomTickViewInfo);
begin
  inherited Create(AAxisTick);
  (AxisTick as TdxChartAxisTickViewInfo).FLabel := Self;
  FRotationMatrix := TdxGPMatrix.Create;
end;

procedure TdxChartAxisTickLabelViewInfo.CreateTextLayout(ACanvas: TcxCustomCanvas);
begin
  if not ACanvas.CheckIsValid(FTextLayout) then
  begin
    FreeAndNil(FTextLayout);
    FTextLayout := ACanvas.CreateTextLayout;
  end;
end;

destructor TdxChartAxisTickLabelViewInfo.Destroy;
begin
  FRotationMatrix.Free;
  FTextLayout.Free;
  inherited Destroy;
end;

function TdxChartAxisTickLabelViewInfo.CalculateArea(const ABounds: TdxRectF): TdxRectF;
begin
  Result := ABounds;
  Result.Inflate(Options.ResolveOverlappingIndent * 0.5);
end;

procedure TdxChartAxisTickLabelViewInfo.CalculateRotationMatrix;
begin
  FRotationMatrix.Reset;
  FRotationMatrix.Rotate(TextAngle, Bounds.CenterPoint);
end;

function TdxChartAxisTickLabelViewInfo.CalculateTextFlags: Cardinal;
begin
  Result := dxChartCalculateTextFlags(GetTextAlignment, IsZero(TextAngle), WordWrap, Options.Appearance.UseRightToLeftReading);
end;

procedure TdxChartAxisTickLabelViewInfo.CalculateTextLayout;
begin
  FTextLayout.SetFlags(CalculateTextFlags);
  FTextLayout.SetColor(GetTextColor);
  FTextLayout.SetFont(GetFont);
  FTextLayout.SetLayoutConstraints(GetTextLayoutConstraints, Options.MaxLineCount);
end;

procedure TdxChartAxisTickLabelViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  AAppearance: TdxChartAxisValueLabelsAppearance;
  ABounds, ATextBounds: TRect;
  AGPGraphics: TdxGPGraphics;
  AGPBrush: TdxGPBrush;
  AGPFont: TdxGPFont;
  AGPStringFormat: TdxGPStringFormat;
begin
  if TextBounds.IsEmpty or (FTextLayout = nil) or (FTextLayout.Text = '') then
    Exit;
  AAppearance := Options.Appearance;
  ABounds := Bounds.DeflateToTRect;
  ATextBounds := TextBounds.DeflateToTRect;
  ACanvas.SaveWorldTransform;
  try
    ACanvas.ModifyWorldTransform(FRotationMatrix.ToXForm);
    if TextAngle = 0 then
      ACanvas.EnableAntialiasing(False);
    if not TdxAlphaColors.IsTransparentOrEmpty(AAppearance.ActualColor) then
      if (TextAngle = 0) or not AAppearance.HasBorder then
        ACanvas.FillRect(ABounds, AAppearance.ActualBrush)
      else
        ACanvas.FillRect(cxRectInflate(ABounds, -0.6, -0.6, -0.6, -0.6), AAppearance.ActualBrush);
    if AAppearance.HasBorder then
      ACanvas.FrameRect(ABounds, AAppearance.ActualBorderColor, AAppearance.ActualBorderThickness);
    if TextAngle = 0 then
      ACanvas.RestoreAntialiasing;

    if (TextAngle > 0) and (ACanvas is TdxGDIPlusControlCanvas) then
    begin
      AGPGraphics := dxGpBeginPaint(TdxGDIPlusControlCanvas(ACanvas).Canvas.Handle, ATextBounds);
      try
        AGPGraphics.SmoothingMode := smAntiAlias;
        AGPGraphics.SetWorldTransform(FRotationMatrix);

        AGPFont := CreateRotatedFont;
        AGPStringFormat := CreateRotatedFontStringFormat;
        AGPBrush := CreateRotatedFontBrush;
        try
          AGPGraphics.DrawString(FTextLayout.Text, AGPFont, AGPBrush, cxRectInflate(ATextBounds, 2, 0), AGPStringFormat);
        finally
          AGPBrush.Free;
          AGPStringFormat.Free;
          AGPFont.Free;
        end;
      finally
        dxGpEndPaint(AGPGraphics);
      end;
    end
    else
      FTextLayout.Draw(TextBounds);

  finally
    ACanvas.RestoreWorldTransform;
  end;
end;

function TdxChartAxisTickLabelViewInfo.GetAxisValueLabels: TdxChartAxisValueLabels;
begin
  Result := AxisTick.Axis.ValueLabels;
end;

function TdxChartAxisTickLabelViewInfo.GetFont: TcxCanvasBasedFont;
begin
  Result := Options.Appearance.ActualFont;
end;

function TdxChartAxisTickLabelViewInfo.CreateRotatedFontBrush: TdxGPBrush;
begin
  Result := TdxGPBrush.Create;
  Result.Color := GetTextColor;
end;

function TdxChartAxisTickLabelViewInfo.CreateRotatedFont: TdxGPFont;
begin
  Result := TdxGPFont.SafeCreate(TcxGdiCanvasBasedFontHandle(GetFont.Handle).Font.Name,
    TcxGdiCanvasBasedFontHandle(GetFont.Handle).Font.Size, CreateRotatedFontStyle);
end;

function TdxChartAxisTickLabelViewInfo.CreateRotatedFontStyle: TdxGPFontStyle;
begin
  Result := TdxGPFontStyle(dxFontStylesToGpFontStyles(TcxGdiCanvasBasedFontHandle(GetFont.Handle).Font.Style));
end;

function TdxChartAxisTickLabelViewInfo.CreateRotatedFontStringFormat: TdxGPStringFormat;
begin
  Result := TdxGPStringFormat.GenericDefault.Clone;
  case GetTextAlignment of
    TdxAlignment.Near:
      Result.Alignment := StringAlignmentNear;
    TdxAlignment.Far:
      Result.Alignment := StringAlignmentFar;
  else
    Result.Alignment := StringAlignmentCenter;
  end;
  Result.LineAlignment := StringAlignmentNear;
  Result.Trimming := TdxGpStringTrimming.StringTrimmingEllipsisCharacter;
  if Options.Appearance.UseRightToLeftReading then
    Result.FormatFlags := Ord(StringFormatFlagsDirectionRightToLeft);
  Result.FormatFlags := Result.FormatFlags or Ord(dxGpWordWrapFlagsMap[WordWrap])
end;

function TdxChartAxisTickLabelViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
var
  ALabelInfo: TdxChartAxisValueLabelInfo;
begin
  if FRotatedBounds.Contains(P) then
  begin
    ALabelInfo := TdxChartAxisValueLabelInfo.Create(AxisTick.Axis, AxisTick.AxisValue, Text);
    Result := TdxChartComponentDependentHitElement.Create(ALabelInfo, True, AxisTick.Axis.Diagram, TdxChartHitCode.AxisValueLabel)
  end
  else
    Result := inherited GetHitElement(P);
end;

function TdxChartAxisTickLabelViewInfo.GetText: string;
begin
  Result := FTextLayout.Text;
end;

function TdxChartAxisTickLabelViewInfo.GetTextAlignment: TdxAlignment;
begin
  Result := Options.TextAlignment;
end;

function TdxChartAxisTickLabelViewInfo.GetTextAngle: Single;
begin
  Result := dxNormalizeAngle(Options.Angle);
end;

function TdxChartAxisTickLabelViewInfo.GetTextColor: TdxAlphaColor;
begin
  Result := Options.Appearance.ActualTextColor;
end;

function TdxChartAxisTickLabelViewInfo.GetTextLayoutConstraints: TdxRectF;
begin
  Result := AxisTick.Axis.Diagram.ViewInfo.ContentBounds;
  if not IsZero(Options.MaxWidth) then
    Result.Width := Min(Result.Width, Options.MaxWidth);
end;

function TdxChartAxisTickLabelViewInfo.GetSize: TdxSizeF;
begin
  Result := MeasureTextSize;
  if not IsZero(Result.Width) and not IsZero(Result.Height) then
  begin
    Result.Width := Result.Width + Options.Appearance.ActualPadding.Left + Options.Appearance.ActualPadding.Right +
      (Options.Appearance.ActualBorderThickness * 2);
    Result.Height := Result.Height + Options.Appearance.ActualPadding.Top + Options.Appearance.ActualPadding.Bottom +
      (Options.Appearance.ActualBorderThickness * 2);
  end;
end;

function TdxChartAxisTickLabelViewInfo.GetWordWrap: Boolean;
begin
  Result := ((Options.MaxWidth > 0) or (Pos(dxCR, Text) > 0)) and (Options.MaxLineCount <> 1);
end;

function TdxChartAxisTickLabelViewInfo.IsOccupied(const R: TdxRectF; AAxis: TdxChartCustomAxis; ACheckArea: Boolean): Boolean;
var
  I: Integer;
  ALabel2: TdxChartAxisTickLabelViewInfo;
begin
  Result := False;
  if not Visible then
    Exit;
  for I := 0 to AAxis.ViewInfo.Labels.Count - 1 do
  begin
    ALabel2 := AAxis.ViewInfo.&Label[I];
    if ALabel2.Visible and (ALabel2 <> Self) then
    begin
      if ACheckArea then
        Result := R.IntersectsWith(ALabel2.AreaBox)
      else
        Result := R.IntersectsWith(ALabel2.BoundsBox);
      if Result then
        Break;
    end;
  end;
end;

function TdxChartAxisTickLabelViewInfo.MeasureGPTextSize: TdxSizeF;
var
  AGPFont: TdxGPFont;
  AGPStringFormat: TdxGPStringFormat;
  ACharactersFitted, ALinesFilled: Integer;
begin
  Result.Init(0, 0);
  AGPFont := CreateRotatedFont;
  AGPStringFormat := CreateRotatedFontStringFormat;
  try
    Result := dxGPMeasureCanvas.MeasureString(FTextLayout.Text, AGPFont, GetTextLayoutConstraints.Size, AGPStringFormat,
      ACharactersFitted, ALinesFilled);
    if (ALinesFilled <> 0) and (Options.MaxLineCount <> 0) and (ALinesFilled > Options.MaxLineCount) then
      Result.Height := Result.Height / ALinesFilled * Options.MaxLineCount;
  finally
    AGPStringFormat.Free;
    AGPFont.Free;
  end;
end;

function TdxChartAxisTickLabelViewInfo.MeasureTextSize: TdxSizeF;
begin
  if (TextAngle > 0) and ((FTextLayout.ClassType = TdxGDIPlusCanvasBasedTextLayout) or
    (FTextLayout.ClassType = TdxSVGCanvasBasedTextLayout)) then
    Result := MeasureGPTextSize
  else
  begin
    Result := FTextLayout.MeasureSizeF;
    Result.Width := Result.Width + GDIToGDIPlusTextWidthCompensation;
  end;
end;

procedure TdxChartAxisTickLabelViewInfo.Offset(const ADistance: TdxPointF);
begin
  FTextBounds.Offset(ADistance);
  FArea.Offset(ADistance);
  inherited Offset(ADistance);
  CalculateRotationMatrix;
  FAreaBox.Offset(ADistance);
  FBoundsBox.Offset(ADistance);
  FRotatedBounds.Offset(ADistance);
  FHasClipping := cxRectIntersect(FClipRect, FBoundsBox, VisibleBounds) and (FClipRect <> FBoundsBox);
end;

procedure TdxChartAxisTickLabelViewInfo.OffsetForRotate;
var
  ADistance: TdxPointF;
  ADirection: Integer;
begin
  ADirection := AxisTick.Axis.ViewInfo.GetSign * IfThen(AxisTick.Axis.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside, -1, 1);
  if AxisTick.Axis.ViewInfo.CalculationHelper.IsHorizontal then
    ADistance.Init(0, ADirection * (FBoundsBox.Height / 2 - FBounds.Height / 2))
  else
    ADistance.Init(ADirection * (FBoundsBox.Width / 2 - FBounds.Width / 2), 0);
  if not SameValue(ADistance.X, 0) or not SameValue(ADistance.Y, 0) then
    Offset(ADistance);
end;

procedure TdxChartAxisTickLabelViewInfo.SetText(const AValue: string);
begin
  FTextLayout.SetText(AValue);
end;

procedure TdxChartAxisTickLabelViewInfo.SetBounds(const ABounds, AVisibleBounds: TdxRectF);
var
  AArea: TdxRectF;
  ARadians: Single;
begin
  inherited SetBounds(ABounds, AVisibleBounds);
  FTextBounds := ABounds.Content(Options.Appearance.ActualPadding);
  FTextBounds.Inflate(-Options.Appearance.ActualBorderThickness);
  ARadians := DegToRad(TextAngle);
  CalculateRotationMatrix;
  AArea := CalculateArea(ABounds);
  FArea.Init(AArea);
  FArea.Rotate(ARadians, AArea.CenterPoint);
  FAreaBox := cxPointsBox(FArea.Points);
  FRotatedBounds.Init(ABounds);
  FRotatedBounds.Rotate(ARadians, ABounds.CenterPoint);
  FBoundsBox := cxPointsBox(FRotatedBounds.Points);
  OffsetForRotate;
end;

{ TdxChartAxisHorizontalDirectionHelper }

class function TdxChartAxisHorizontalDirectionHelper.IsHorizontal: Boolean;
begin
  Result := True;
end;

class function TdxChartAxisHorizontalDirectionHelper.GetLongitudinalSize(const ASize: TdxSizeF): Single;
begin
  Result := ASize.Width;
end;

class function TdxChartAxisHorizontalDirectionHelper.GetTransversalSize(const ASize: TdxSizeF): Single;
begin
  Result := ASize.Height;
end;

class function TdxChartAxisHorizontalDirectionHelper.AxisIncludesTickmark(AViewInfo: TdxChartAxisViewInfo; ATickmark: TdxChartAxisCustomTickViewInfo): Boolean;
begin
  Result := (AViewInfo.AxisLineRect.Top <= ATickmark.CanvasValue) and (ATickmark.CanvasValue <= AViewInfo.AxisLineRect.Bottom);
end;

class procedure TdxChartAxisHorizontalDirectionHelper.CalculateLineEnds(AViewInfo: TdxChartAxisViewInfo;
  AAnchor, AThickness: Single; const ALineBounds: TdxRectF; var AStart, AFinish: TdxPointF);
begin
  AStart.X := AAnchor;
  AStart.Y := ALineBounds.Top;
  AFinish.X := AStart.X;
  AFinish.Y := ALineBounds.Bottom;
end;

class procedure TdxChartAxisHorizontalDirectionHelper.CalculateViewpoint(
  AAxis: TdxChartCustomAxis; const ABounds: TdxRectF; out AOffset: Single; out AOffsetDirection: TValueSign);
begin
  if AAxis.Reverse then
  begin
    AOffset := ABounds.Right;
    AOffsetDirection := -1;
  end
  else
  begin
    AOffset := ABounds.Left;
    AOffsetDirection := 1;
  end;
end;

class function TdxChartAxisHorizontalDirectionHelper.GetAxisLineProjectionCanvasValue(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  Result := AViewInfo.AxisLineStart.Y;
end;

class function TdxChartAxisHorizontalDirectionHelper.GetInterlacedBounds(AStart, AFinish: Single;
  const APattern: TdxRectF): TdxRectF;
begin
  Result := APattern;
  Result.Left := AStart;
  Result.Right := AFinish;
end;

class function TdxChartAxisHorizontalDirectionHelper.GetLabelsAreaTransversalSize(AViewInfo: TdxChartAxisViewInfo): Single;
var
  I, AVisibleIndex: Integer;
  ALabel: TdxChartAxisTickLabelViewInfo;
  AMinValue, AMaxValue: Single;
begin
  AMinValue := 0;
  AMaxValue := 0;
  AVisibleIndex := 0;
  for I := 0 to AViewInfo.Labels.Count - 1 do
  begin
    ALabel := AViewInfo.&Label[I];
    if ALabel.Visible then
    begin
      if AVisibleIndex = 0 then
      begin
        AMinValue := ALabel.BoundsBox.Top;
        AMaxValue := ALabel.BoundsBox.Bottom;
      end
      else
      begin
        AMinValue := Min(AMinValue, ALabel.BoundsBox.Top);
        AMaxValue := Max(AMaxValue, ALabel.BoundsBox.Bottom);
      end;
      Inc(AVisibleIndex);
    end;
  end;
  Result := Ceil(AMaxValue - AMinValue);
end;

class function TdxChartAxisHorizontalDirectionHelper.GetLabelRectStart(AViewInfo: TdxChartAxisViewInfo;
  ATickCanvasValue, ATextLongitudinalSize: Single; ALabelAlignment: TdxAlignment): Single;
begin
  case ALabelAlignment of
    TdxAlignment.Near:
      Result := ATickCanvasValue - ATextLongitudinalSize;
    TdxAlignment.Far:
      Result := ATickCanvasValue;
  else  
    Result := ATickCanvasValue - ATextLongitudinalSize / 2;
  end;
end;

class function TdxChartAxisHorizontalDirectionHelper.GetOccupiedSides(AViewInfo: TdxChartAxisViewInfo;
  const AArea: TdxRectF): TcxBorders;
begin
  Result := [];
  if AViewInfo.Axis.ActuallyVisible then
    if not(AViewInfo.Axis.IsFarAlignment or AViewInfo.IsCentered) and
       InRange(AArea.Bottom, AViewInfo.AxisLineRect.Top, AViewInfo.AxisLineRect.Bottom) then
      Result := [TcxBorder.bBottom]
    else
      if not(AViewInfo.Axis.IsNearAlignment or AViewInfo.IsCentered) and
         InRange(AArea.Top, AViewInfo.AxisLineRect.Top, AViewInfo.AxisLineRect.Bottom) then
        Result := [TcxBorder.bTop];
end;

class function TdxChartAxisHorizontalDirectionHelper.GetTransversalOffsetDistance(AOffset: Single): TdxPointF;
begin
  Result := cxPointF(0, AOffset);
end;

class function TdxChartAxisHorizontalDirectionHelper.LabelsAreaCanIntersectsWith(const R: TdxRectF; AViewInfo: TdxChartAxisViewInfo): Boolean;
var
  ALabelsArea: TdxRectF;
begin
  ALabelsArea := AViewInfo.LabelsArea;
  ALabelsArea.Left := Min(ALabelsArea.Left, R.Left);
  ALabelsArea.Right := Max(ALabelsArea.Right, R.Right);
  Result := ALabelsArea.IntersectsWith(R);
end;

class function TdxChartAxisHorizontalDirectionHelper.SelectFarFromBorder(AViewInfo: TdxChartAxisViewInfo; const R1, R2: TdxRectF): TdxRectF;
begin
  Result := R1;
  if AViewInfo.AvailableBounds.Right - R2.Right > R1.Left - AViewInfo.AvailableBounds.Left then
    Result := R2;
end;

class procedure TdxChartAxisHorizontalDirectionHelper.UpdateGridline(AViewInfo: TdxChartAxisViewInfo;
  AGridline: TdxChartAxisGridlineViewInfo; const APlotArea: TdxRectF);
var
  ABounds: TdxRectF;
  AStart, AFinish: TdxPointF;
begin
  if AGridline.Visible then
  begin
    ABounds := AGridline.Bounds;
    AStart := AGridline.Start;
    AStart.Y := AViewInfo.GetNearTransversalValue(APlotArea);
    AFinish := AGridline.Finish;
    AFinish.Y := AViewInfo.GetFarTransversalValue(APlotArea);
    ABounds.Top := APlotArea.Top;
    ABounds.Bottom := APlotArea.Bottom;
    AGridline.UpdateBounds(ABounds, AStart, AFinish);
  end;
end;

class procedure TdxChartAxisHorizontalDirectionHelper.UpdateInterlaced(AViewInfo: TdxChartAxisViewInfo;
  AInterlaced: TdxChartXYDiagramInterlacedViewInfo; const APlotArea: TdxRectF);
var
  ABounds: TdxRectF;
begin
  if not AInterlaced.Visible then
    Exit;
  ABounds := AInterlaced.Bounds;
  ABounds.Top := APlotArea.Top;
  ABounds.Bottom := APlotArea.Bottom;
  AInterlaced.UpdateBounds(ABounds, APlotArea);
end;

class procedure TdxChartAxisHorizontalDirectionHelper.ResolveOverlapping(AViewInfo: TdxChartAxisViewInfo);
begin
  if not AViewInfo.IsTickLabelsRotated and AViewInfo.IsLabelsCrossed then
    StaggerLabels(AViewInfo);
  AViewInfo.HideCrossedLabels;
end;

class procedure TdxChartAxisHorizontalDirectionHelper.StaggerLabels(AViewInfo: TdxChartAxisViewInfo);
const
  RowDistance = 2;
var
  I, AVisibleIndex, ADirection: Integer;
  ALabel: TdxChartAxisTickLabelViewInfo;
  AFirstRowFinish, ASecondRowStart: Single;
  ASecondRow: TList<Integer>;
begin
  AVisibleIndex := 0;
  ADirection := GetSign * ValueIncrement[AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside];
  AFirstRowFinish := AViewInfo.LabelsAreaStart;
  ASecondRow := TList<Integer>.Create;
  try
    for I := 0 to AViewInfo.Labels.Count - 1 do
    begin
      ALabel := AViewInfo.&Label[I];
      if ALabel.Visible then
      begin
        if AVisibleIndex mod 2 = 0 then
          ASecondRow.Add(I)
        else
          if ADirection > 0 then
            AFirstRowFinish := Max(AFirstRowFinish, ALabel.BoundsBox.Bottom)
          else
            AFirstRowFinish := Min(AFirstRowFinish, ALabel.BoundsBox.Top);
        Inc(AVisibleIndex);
      end;
    end;
    ASecondRowStart := AFirstRowFinish + ADirection * (AViewInfo.ValueLabels.ResolveOverlappingIndent + RowDistance);
    for I := 0 to ASecondRow.Count - 1 do
    begin
      ALabel := AViewInfo.&Label[ASecondRow[I]];
      if ADirection > 0 then
        ALabel.Offset(TdxPointF.Create(0, ASecondRowStart - ALabel.BoundsBox.Top))
      else
        ALabel.Offset(TdxPointF.Create(0, ASecondRowStart - ALabel.BoundsBox.Bottom));
    end;
  finally
    ASecondRow.Free;
  end;
end;

class procedure TdxChartAxisHorizontalDirectionHelper.SetFarLongitudinalValue(var R: TdxRectF; AValue: Single);
begin
  R.Right := AValue;
end;

class procedure TdxChartAxisHorizontalDirectionHelper.SetNearLongitudinalValue(var R: TdxRectF; AValue: Single);
begin
  R.Left := AValue;
end;

{ TdxChartAxisHorizontalFarDirectionHelper }

class procedure TdxChartAxisHorizontalFarDirectionHelper.CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo;
  out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF);
begin
  ALineRect := AViewInfo.Bounds;
  ALineRect.Init(Ceil(ALineRect.Left), Ceil(ALineRect.Bottom - AViewInfo.GetActualThickness), Floor(ALineRect.Right), Floor(ALineRect.Bottom));
  ALineStart := cxPointF(ALineRect.Left, Ceil(ALineRect.CenterPoint.Y));
  ALineFinish := cxPointF(ALineRect.Right, ALineStart.Y);
end;

class function TdxChartAxisHorizontalFarDirectionHelper.GetActualTitlePosition(
  AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition;
begin
  Result := TdxChartTitlePosition.Top;
end;

class function TdxChartAxisHorizontalFarDirectionHelper.GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  Result.Bottom := Min(Result.Bottom, Result.Top + AViewInfo.GetOuterTransversalSize);
end;

class function TdxChartAxisHorizontalFarDirectionHelper.GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  if AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Inside then
  begin
    AViewInfo.CorrectAvailableArea(Result);
    if AViewInfo.ValueLabels.Visible and (AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
      Result.Top := AViewInfo.LabelsAreaStart + AViewInfo.LabelsAreaTransversalSize
    else
      Result.Top := Result.Top + AViewInfo.GetInsideTickMarkMaxLength;
  end;
end;

class function TdxChartAxisHorizontalFarDirectionHelper.GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  if AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside then
    Result := Min(Min(AViewInfo.AxisLineRect.Top, AViewInfo.Ticks.Finish), AViewInfo.MinorTicks.Finish) - AViewInfo.GetLabelPadding
  else
    Result := Max(Max(AViewInfo.AxisLineRect.Bottom, AViewInfo.Ticks.Start), AViewInfo.MinorTicks.Start) + AViewInfo.GetLabelPadding;
end;

class procedure TdxChartAxisHorizontalFarDirectionHelper.ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single);
begin
  ABounds.Bottom := ABounds.Bottom + dValue;
end;

class function TdxChartAxisHorizontalFarDirectionHelper.GetSign: TValueSign;
begin
  Result := -1;
end;

class function TdxChartAxisHorizontalFarDirectionHelper.IsFar: Boolean;
begin
  Result := True;
end;

class function TdxChartAxisHorizontalFarDirectionHelper.GetFarTransversalValue(const R: TdxRectF): Single;
begin
  Result := R.Bottom;
end;

class function TdxChartAxisHorizontalFarDirectionHelper.GetNearTransversalValue(const R: TdxRectF): Single;
begin
  Result := R.Top;
end;

class procedure TdxChartAxisHorizontalFarDirectionHelper.IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo;
  var ABounds: TdxRectF);
var
  I: Integer;
begin
  ABounds.Bottom := ABounds.Bottom + AViewInfo.GetInsideTickMarkMaxLength;
  if AViewInfo.Axis.Title.ActuallyVisible and (AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Inside) then
    ABounds.Bottom := Max(ABounds.Bottom, AViewInfo.Axis.Title.ViewInfo.Bounds.Bottom)
  else
    if AViewInfo.Axis.ValueLabels.Visible and (AViewInfo.Axis.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
    for I := 0 to AViewInfo.Labels.Count - 1 do
      if AViewInfo.&Label[I].Visible then
        ABounds.Bottom := Max(ABounds.Bottom, AViewInfo.&Label[I].Bounds.Bottom);
  ABounds.Bottom := ABounds.Bottom + AViewInfo.ActualSecondaryAxisIndent;
end;

class procedure TdxChartAxisHorizontalFarDirectionHelper.SetFarTransversalValue(var R: TdxRectF; AValue: Single);
begin
  R.Bottom := AValue;
end;

class procedure TdxChartAxisHorizontalFarDirectionHelper.SetNearTransversalValue(var R: TdxRectF; AValue: Single);
begin
  R.Top := AValue;
end;

{ TdxChartAxisHorizontalNearDirectionHelper }

class procedure TdxChartAxisHorizontalNearDirectionHelper.CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo;
  out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF);
begin
  ALineRect := AViewInfo.Bounds;
  ALineRect.Init(Ceil(ALineRect.Left), Ceil(ALineRect.Top), Floor(ALineRect.Right), Floor(ALineRect.Top + AViewInfo.GetActualThickness));
  ALineStart := cxPointF(ALineRect.Left, Ceil(ALineRect.CenterPoint.Y));
  ALineFinish := cxPointF(ALineRect.Right, ALineStart.Y);
end;

class function TdxChartAxisHorizontalNearDirectionHelper.GetActualTitlePosition(
  AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition;
begin
  Result := TdxChartTitlePosition.Bottom;
end;

class function TdxChartAxisHorizontalNearDirectionHelper.GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  if AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Inside then
  begin
    AViewInfo.CorrectAvailableArea(Result);
    if AViewInfo.ValueLabels.Visible and (AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
      Result.Bottom := AViewInfo.LabelsAreaStart - AViewInfo.LabelsAreaTransversalSize
    else
      Result.Bottom := Result.Bottom - AViewInfo.GetInsideTickMarkMaxLength;
  end;
end;

class function TdxChartAxisHorizontalNearDirectionHelper.GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  Result.Top := Max(Result.Top, Result.Bottom - AViewInfo.GetOuterTransversalSize);
end;

class function TdxChartAxisHorizontalNearDirectionHelper.GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  if AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside then
    Result := Max(Max(AViewInfo.AxisLineRect.Bottom, AViewInfo.Ticks.Finish), AViewInfo.MinorTicks.Finish) + AViewInfo.GetLabelPadding
  else
    Result := Min(Min(AViewInfo.AxisLineRect.Top, AViewInfo.Ticks.Start), AViewInfo.MinorTicks.Start) - AViewInfo.GetLabelPadding;
end;

class procedure TdxChartAxisHorizontalNearDirectionHelper.ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single);
begin
  ABounds.Top := ABounds.Top - dValue;
end;

class function TdxChartAxisHorizontalNearDirectionHelper.GetFarTransversalValue(const R: TdxRectF): Single;
begin
  Result := R.Top;
end;

class function TdxChartAxisHorizontalNearDirectionHelper.GetNearTransversalValue(const R: TdxRectF): Single;
begin
  Result := R.Bottom;
end;

class procedure TdxChartAxisHorizontalNearDirectionHelper.IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo;
  var ABounds: TdxRectF);
var
  I: Integer;
begin
  ABounds.Top := ABounds.Top - AViewInfo.GetInsideTickMarkMaxLength;
  if AViewInfo.Axis.Title.ActuallyVisible and (AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Inside) then
    ABounds.Top := Min(ABounds.Top, AViewInfo.Axis.Title.ViewInfo.Bounds.Top)
  else
    if AViewInfo.Axis.ValueLabels.Visible and (AViewInfo.Axis.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
    for I := 0 to AViewInfo.Labels.Count - 1 do
      if AViewInfo.&Label[I].Visible then
        ABounds.Top := Min(ABounds.Top, AViewInfo.&Label[I].Bounds.Top);
  ABounds.Top := ABounds.Top - AViewInfo.ActualSecondaryAxisIndent;
end;

class function TdxChartAxisHorizontalNearDirectionHelper.IsNear: Boolean;
begin
  Result := True;
end;

class procedure TdxChartAxisHorizontalNearDirectionHelper.SetFarTransversalValue(var R: TdxRectF; AValue: Single);
begin
  R.Top := AValue;
end;

class procedure TdxChartAxisHorizontalNearDirectionHelper.SetNearTransversalValue(var R: TdxRectF; AValue: Single);
begin
  R.Bottom := AValue;
end;

{ TdxChartAxisHorizontalCenterDirectionHelper }

class function TdxChartAxisHorizontalCenterDirectionHelper.IsCenter: Boolean;
begin
  Result := True;
end;

class procedure TdxChartAxisHorizontalCenterDirectionHelper.ExpandNearTransversalBorder(var ABounds: TdxRectF; dValue: Single);
begin
  ABounds.Bottom := ABounds.Bottom + dValue;
end;

class function TdxChartAxisHorizontalCenterDirectionHelper.GetActualTitlePosition(
  AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition;
begin
  if AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Outside then
    Result := TdxChartTitlePosition.Top
  else
    Result := TdxChartTitlePosition.Bottom;
end;

class function TdxChartAxisHorizontalCenterDirectionHelper.GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  if AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Outside then
  begin
    Result.Top := AViewInfo.Bounds.Bottom + AViewInfo.GetOutsideTickMarkMaxLength;
    if AViewInfo.ValueLabels.Visible and (AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside) then
      Result.Top := Result.Top + AViewInfo.GetLabelPadding + AViewInfo.LabelsAreaTransversalSize;
  end
  else
  begin
    Result.Bottom := AViewInfo.Bounds.Top - AViewInfo.GetInsideTickMarkMaxLength;
    if AViewInfo.ValueLabels.Visible and (AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
      Result.Bottom := AViewInfo.LabelsAreaStart - AViewInfo.LabelsAreaTransversalSize;
  end;
end;

class function TdxChartAxisHorizontalCenterDirectionHelper.GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
var
  AThickness: Single;
begin
  Result := AViewInfo.AvailableBounds;
  AThickness := AViewInfo.GetActualThickness;
  Result.Top := Result.CenterPoint.Y - AThickness / 2;
  Result.Bottom := Result.Top + AThickness;
end;

{ TdxChartAxisVerticalDirectionHelper }

class function TdxChartAxisVerticalDirectionHelper.GetLongitudinalSize(const ASize: TdxSizeF): Single;
begin
  Result := ASize.Height;
end;

class function TdxChartAxisVerticalDirectionHelper.GetTransversalSize(const ASize: TdxSizeF): Single;
begin
  Result := ASize.Width;
end;

class function TdxChartAxisVerticalDirectionHelper.AxisIncludesTickmark(AViewInfo: TdxChartAxisViewInfo; ATickmark: TdxChartAxisCustomTickViewInfo): Boolean;
begin
  Result := (AViewInfo.AxisLineRect.Left <= ATickmark.CanvasValue) and (ATickmark.CanvasValue <= AViewInfo.AxisLineRect.Right);
end;

class procedure TdxChartAxisVerticalDirectionHelper.CalculateLineEnds(AViewInfo: TdxChartAxisViewInfo;
  AAnchor, AThickness: Single; const ALineBounds: TdxRectF; var AStart, AFinish: TdxPointF);
begin
  AStart.X := ALineBounds.Left;
  AStart.Y := AAnchor;
  AFinish.X := ALineBounds.Right;
  AFinish.Y := AStart.Y;
end;

class procedure TdxChartAxisVerticalDirectionHelper.CalculateViewpoint(
  AAxis: TdxChartCustomAxis; const ABounds: TdxRectF; out AOffset: Single; out AOffsetDirection: TValueSign);
begin
  if AAxis.Reverse then
  begin
    AOffset := ABounds.Top;
    AOffsetDirection := 1;
  end
  else
  begin
    AOffset := ABounds.Bottom;
    AOffsetDirection := -1;
  end;
end;

class function TdxChartAxisVerticalDirectionHelper.GetAxisLineProjectionCanvasValue(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  Result := AViewInfo.AxisLineStart.X;
end;

class function TdxChartAxisVerticalDirectionHelper.GetInterlacedBounds(AStart, AFinish: Single; const APattern: TdxRectF): TdxRectF;
begin
  Result := APattern;
  Result.Top := AFinish;
  Result.Bottom := AStart;
end;

class function TdxChartAxisVerticalDirectionHelper.GetLabelsAreaTransversalSize(AViewInfo: TdxChartAxisViewInfo): Single;
var
  I, AVisibleIndex: Integer;
  AMinValue, AMaxValue: Single;
  ALabel: TdxChartAxisTickLabelViewInfo;
begin
  AMinValue := 0;
  AMaxValue := 0;
  AVisibleIndex := 0;
  for I := 0 to AViewInfo.Labels.Count - 1 do
  begin
    ALabel := AViewInfo.&Label[I];
    if ALabel.Visible then
    begin
      if AVisibleIndex = 0 then
      begin
        AMinValue := ALabel.BoundsBox.Left;
        AMaxValue := ALabel.BoundsBox.Right;
      end
      else
      begin
        AMinValue := Min(AMinValue, ALabel.BoundsBox.Left);
        AMaxValue := Max(AMaxValue, ALabel.BoundsBox.Right);
      end;
      Inc(AVisibleIndex);
    end;
  end;
  Result := Ceil(AMaxValue - AMinValue);
end;

class function TdxChartAxisVerticalDirectionHelper.GetLabelRectStart(AViewInfo: TdxChartAxisViewInfo;
  ATickCanvasValue, ATextLongitudinalSize: Single; ALabelAlignment: TdxAlignment): Single;
begin
  case ALabelAlignment of
    TdxAlignment.Near:
      Result := ATickCanvasValue;
    TdxAlignment.Far:
      Result := ATickCanvasValue - ATextLongitudinalSize;
  else  
    Result := ATickCanvasValue - ATextLongitudinalSize / 2;
  end;
end;

class function TdxChartAxisVerticalDirectionHelper.GetOccupiedSides(AViewInfo: TdxChartAxisViewInfo;
  const AArea: TdxRectF): TcxBorders;
begin
  Result := [];
  if AViewInfo.Axis.ActuallyVisible then
    if not(AViewInfo.Axis.IsFarAlignment or AViewInfo.IsCentered) and
       InRange(AArea.Left, AViewInfo.AxisLineRect.Left, AViewInfo.AxisLineRect.Right) then
        Result := [TcxBorder.bLeft]
    else
    if not(AViewInfo.Axis.IsNearAlignment or AViewInfo.IsCentered) and
       InRange(AArea.Right, AViewInfo.AxisLineRect.Left, AViewInfo.AxisLineRect.Right) then
        Result := [TcxBorder.bRight];
end;

class function TdxChartAxisVerticalDirectionHelper.GetTransversalOffsetDistance(AOffset: Single): TdxPointF;
begin
  Result := cxPointF(AOffset, 0);
end;

class function TdxChartAxisVerticalDirectionHelper.LabelsAreaCanIntersectsWith(const R: TdxRectF; AViewInfo: TdxChartAxisViewInfo): Boolean;
var
  ALabelsArea: TdxRectF;
begin
  ALabelsArea := AViewInfo.LabelsArea;
  ALabelsArea.Top := Min(ALabelsArea.Top, R.Top);
  ALabelsArea.Bottom := Max(ALabelsArea.Bottom, R.Bottom);
  Result := ALabelsArea.IntersectsWith(R);
end;

class function TdxChartAxisVerticalDirectionHelper.SelectFarFromBorder(AViewInfo: TdxChartAxisViewInfo; const R1, R2: TdxRectF): TdxRectF;
begin
  Result := R1;
  if AViewInfo.AvailableBounds.Bottom - R2.Bottom > R1.Top - AViewInfo.AvailableBounds.Top then
    Result := R2;
end;

class procedure TdxChartAxisVerticalDirectionHelper.UpdateGridline(AViewInfo: TdxChartAxisViewInfo;
  AGridline: TdxChartAxisGridlineViewInfo; const APlotArea: TdxRectF);
var
  ABounds: TdxRectF;
  AStart, AFinish: TdxPointF;
begin
  if AGridline.Visible then
  begin
    ABounds := AGridline.Bounds;
    AStart := AGridline.Start;
    AStart.X := AViewInfo.GetNearTransversalValue(APlotArea);
    AFinish := AGridline.Finish;
    AFinish.X := AViewInfo.GetFarTransversalValue(APlotArea);
    ABounds.Left := APlotArea.Left;
    ABounds.Right := APlotArea.Right;
    AGridline.UpdateBounds(ABounds, AStart, AFinish);
  end;
end;

class procedure TdxChartAxisVerticalDirectionHelper.UpdateInterlaced(AViewInfo: TdxChartAxisViewInfo;
  AInterlaced: TdxChartXYDiagramInterlacedViewInfo; const APlotArea: TdxRectF);
var
  ABounds: TdxRectF;
begin
  if not AInterlaced.ActuallyVisible then
    Exit;
  ABounds := AInterlaced.Bounds;
  ABounds.Left := APlotArea.Left;
  ABounds.Right := APlotArea.Right;
  AInterlaced.UpdateBounds(ABounds, APlotArea);
end;

class procedure TdxChartAxisVerticalDirectionHelper.ResolveOverlapping(AViewInfo: TdxChartAxisViewInfo);
begin
  while AViewInfo.IsLabelsCrossed do
    AViewInfo.HideLabels;
end;

class procedure TdxChartAxisVerticalDirectionHelper.StaggerLabels(AViewInfo: TdxChartAxisViewInfo);
const
  RowDistance = 2;
var
  I, AVisibleIndex, ADirection: Integer;
  ALabel: TdxChartAxisTickLabelViewInfo;
  AFirstColumnFinish, ASecondColumnStart: Single;
  ASecondColumn: TList<Integer>;
begin
  AVisibleIndex := 0;
  ADirection := GetSign * ValueIncrement[AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside];
  AFirstColumnFinish := AViewInfo.LabelsAreaStart;
  ASecondColumn := TList<Integer>.Create;
  try
    for I := 0 to AViewInfo.Labels.Count - 1 do
    begin
      ALabel := AViewInfo.&Label[I];
      if ALabel.Visible then
      begin
        if AVisibleIndex mod 2 = 0 then
          ASecondColumn.Add(I)
        else
          if ADirection > 0 then
            AFirstColumnFinish := Max(AFirstColumnFinish, ALabel.BoundsBox.Right)
          else
            AFirstColumnFinish := Min(AFirstColumnFinish, ALabel.BoundsBox.Left);
        Inc(AVisibleIndex);
      end;
    end;
    ASecondColumnStart := AFirstColumnFinish + ADirection * (AViewInfo.ValueLabels.ResolveOverlappingIndent + RowDistance);
    for I := 0 to ASecondColumn.Count - 1 do
    begin
      ALabel := AViewInfo.&Label[ASecondColumn[I]];
      if ADirection > 0 then
        ALabel.Offset(TdxPointF.Create(ASecondColumnStart - ALabel.BoundsBox.Left, 0))
      else
        ALabel.Offset(TdxPointF.Create(ASecondColumnStart - ALabel.BoundsBox.Right, 0))
    end;
  finally
    ASecondColumn.Free;
  end;
end;

class procedure TdxChartAxisVerticalDirectionHelper.SetFarLongitudinalValue(var R: TdxRectF; AValue: Single);
begin
  R.Bottom := AValue;
end;

class procedure TdxChartAxisVerticalDirectionHelper.SetNearLongitudinalValue(var R: TdxRectF; AValue: Single);
begin
  R.Top := AValue;
end;

{ TdxChartAxisVerticalFarDirectionHelper }

class procedure TdxChartAxisVerticalFarDirectionHelper.CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo;
  out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF);
begin
  ALineRect := AViewInfo.Bounds;
  ALineRect.Init(Ceil(ALineRect.Left), Ceil(ALineRect.Top), Floor(ALineRect.Left + AViewInfo.GetActualThickness), Floor(ALineRect.Bottom));
  ALineStart := cxPointF(Ceil(ALineRect.CenterPoint.X), ALineRect.Top);
  ALineFinish := cxPointF(ALineStart.X, ALineRect.Bottom);
end;

class function TdxChartAxisVerticalFarDirectionHelper.GetActualTitlePosition(
  AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition;
begin
  Result := TdxChartTitlePosition.Right;
end;

class function TdxChartAxisVerticalFarDirectionHelper.GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  if AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Inside then
  begin
    AViewInfo.CorrectAvailableArea(Result);
    if AViewInfo.ValueLabels.Visible and (AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
      Result.Right := AViewInfo.LabelsAreaStart - AViewInfo.LabelsAreaTransversalSize
    else
      Result.Right := Result.Right - AViewInfo.GetInsideTickMarkMaxLength;
  end;
end;

class function TdxChartAxisVerticalFarDirectionHelper.GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  Result.Left := Max(Result.Left, Result.Right - AViewInfo.GetOuterTransversalSize);
end;

class function TdxChartAxisVerticalFarDirectionHelper.GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  if AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside then
    Result := Max(Max(AViewInfo.AxisLineRect.Right, AViewInfo.Ticks.Finish), AViewInfo.MinorTicks.Finish) + AViewInfo.GetLabelPadding
  else
    Result := Min(Min(AViewInfo.AxisLineRect.Left, AViewInfo.Ticks.Start), AViewInfo.MinorTicks.Start) - AViewInfo.GetLabelPadding;
end;

class procedure TdxChartAxisVerticalFarDirectionHelper.ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single);
begin
  ABounds.Left := ABounds.Left - dValue;
end;

class function TdxChartAxisVerticalFarDirectionHelper.GetFarTransversalValue(const R: TdxRectF): Single;
begin
  Result := R.Left;
end;

class function TdxChartAxisVerticalFarDirectionHelper.GetNearTransversalValue(const R: TdxRectF): Single;
begin
  Result := R.Right;
end;

class procedure TdxChartAxisVerticalFarDirectionHelper.IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo;
  var ABounds: TdxRectF);
var
  I: Integer;
begin
  ABounds.Left := ABounds.Left - AViewInfo.GetInsideTickMarkMaxLength;
  if AViewInfo.Axis.Title.ActuallyVisible and (AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Inside) then
    ABounds.Left := Min(ABounds.Left, AViewInfo.Axis.Title.ViewInfo.Bounds.Left)
  else
    if AViewInfo.Axis.ValueLabels.Visible and (AViewInfo.Axis.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
    for I := 0 to AViewInfo.Labels.Count - 1 do
      if AViewInfo.&Label[I].Visible then
        ABounds.Left := Min(ABounds.Left, AViewInfo.&Label[I].Bounds.Left);
  ABounds.Left := ABounds.Left - AViewInfo.ActualSecondaryAxisIndent;
end;

class function TdxChartAxisVerticalFarDirectionHelper.IsFar: Boolean;
begin
  Result := True;
end;

class procedure TdxChartAxisVerticalFarDirectionHelper.SetFarTransversalValue(var R: TdxRectF; AValue: Single);
begin
  R.Left := AValue;
end;

class procedure TdxChartAxisVerticalFarDirectionHelper.SetNearTransversalValue(var R: TdxRectF; AValue: Single);
begin
  R.Right := AValue;
end;

{ TdxChartAxisVerticalNearDirectionHelper }

class procedure TdxChartAxisVerticalNearDirectionHelper.CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo;
  out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF);
begin
  ALineRect := AViewInfo.Bounds;
  ALineRect.Init(Ceil(ALineRect.Right - AViewInfo.GetActualThickness), Ceil(ALineRect.Top), Floor(ALineRect.Right), Floor(ALineRect.Bottom));
  ALineStart := cxPointF(Ceil(ALineRect.CenterPoint.X), ALineRect.Top);
  ALineFinish := cxPointF(ALineStart.X, ALineRect.Bottom);
end;

class function TdxChartAxisVerticalNearDirectionHelper.GetActualTitlePosition(
  AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition;
begin
  Result := TdxChartTitlePosition.Left;
end;

class function TdxChartAxisVerticalNearDirectionHelper.GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  if AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Inside then
  begin
    AViewInfo.CorrectAvailableArea(Result);
    if AViewInfo.ValueLabels.Visible and (AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
      Result.Left := AViewInfo.LabelsAreaStart + AViewInfo.LabelsAreaTransversalSize
    else
      Result.Left := Result.Left + AViewInfo.GetInsideTickMarkMaxLength;
  end;
end;

class function TdxChartAxisVerticalNearDirectionHelper.GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  Result.Right := Min(Result.Right, Result.Left + AViewInfo.GetOuterTransversalSize);
end;

class function TdxChartAxisVerticalNearDirectionHelper.GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  if AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside then
    Result := Min(Min(AViewInfo.AxisLineRect.Left, AViewInfo.Ticks.Finish), AViewInfo.MinorTicks.Finish) - AViewInfo.GetLabelPadding
  else
    Result := Max(Max(AViewInfo.AxisLineRect.Right, AViewInfo.Ticks.Start), AViewInfo.MinorTicks.Start) + AViewInfo.GetLabelPadding;
end;

class procedure TdxChartAxisVerticalNearDirectionHelper.ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single);
begin
  ABounds.Right := ABounds.Right + dValue;
end;

class function TdxChartAxisVerticalNearDirectionHelper.GetSign: TValueSign;
begin
  Result := -1;
end;

class function TdxChartAxisVerticalNearDirectionHelper.IsNear: Boolean;
begin
  Result := True;
end;

class function TdxChartAxisVerticalNearDirectionHelper.GetFarTransversalValue(const R: TdxRectF): Single;
begin
  Result := R.Right;
end;

class function TdxChartAxisVerticalNearDirectionHelper.GetNearTransversalValue(const R: TdxRectF): Single;
begin
  Result := R.Left;
end;

class procedure TdxChartAxisVerticalNearDirectionHelper.IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo;
  var ABounds: TdxRectF);
var
  I: Integer;
begin
  ABounds.Right := ABounds.Right + AViewInfo.GetInsideTickMarkMaxLength;
  if AViewInfo.Axis.Title.ActuallyVisible and (AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Inside) then
    ABounds.Right := Max(ABounds.Right, AViewInfo.Axis.Title.ViewInfo.Bounds.Right)
  else
    if AViewInfo.Axis.ValueLabels.Visible and (AViewInfo.Axis.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
    for I := 0 to AViewInfo.Labels.Count - 1 do
      if AViewInfo.&Label[I].Visible then
        ABounds.Right := Max(ABounds.Right, AViewInfo.&Label[I].Bounds.Right);
  ABounds.Right := ABounds.Right + AViewInfo.ActualSecondaryAxisIndent;
end;

class procedure TdxChartAxisVerticalNearDirectionHelper.SetFarTransversalValue(var R: TdxRectF; AValue: Single);
begin
  R.Right := AValue;
end;

class procedure TdxChartAxisVerticalNearDirectionHelper.SetNearTransversalValue(var R: TdxRectF; AValue: Single);
begin
  R.Left := AValue;
end;

{ TdxChartAxisVerticalCenterDirectionHelper }

class function TdxChartAxisVerticalCenterDirectionHelper.IsCenter: Boolean;
begin
  Result := True;
end;

class procedure TdxChartAxisVerticalCenterDirectionHelper.ExpandNearTransversalBorder(var ABounds: TdxRectF; dValue: Single);
begin
  ABounds.Left := ABounds.Left - dValue;
end;

class function TdxChartAxisVerticalCenterDirectionHelper.GetActualTitlePosition(
  AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition;
begin
  if AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Outside then
    Result := TdxChartTitlePosition.Right
  else
    Result := TdxChartTitlePosition.Left;
end;

class function TdxChartAxisVerticalCenterDirectionHelper.GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := AViewInfo.AvailableBounds;
  if AViewInfo.Axis.Title.Position = TdxChartAxisTitlePosition.Outside then
  begin
    Result.Right := AViewInfo.Bounds.Left - AViewInfo.GetOutsideTickMarkMaxLength;
    if AViewInfo.ValueLabels.Visible and (AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside) then
      Result.Right := Result.Right - AViewInfo.GetLabelPadding - AViewInfo.LabelsAreaTransversalSize;
  end
  else
  begin
    Result.Left := AViewInfo.Bounds.Right + AViewInfo.GetInsideTickMarkMaxLength;
    if AViewInfo.ValueLabels.Visible and (AViewInfo.ValueLabels.Position = TdxChartAxisValueLabelPosition.Inside) then
      Result.Left := AViewInfo.LabelsAreaStart + AViewInfo.LabelsAreaTransversalSize;
  end;
end;

class function TdxChartAxisVerticalCenterDirectionHelper.GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
var
  AThickness: Single;
begin
  Result := AViewInfo.AvailableBounds;
  AThickness := AViewInfo.GetActualThickness;
  Result.Left := Result.CenterPoint.X - AThickness / 2;
  Result.Right := Result.Left + AThickness;
end;

{ TdxChartAxisCustomTicksViewInfo }

function TdxChartAxisCustomTicksViewInfo.Add: TdxChartAxisCustomTickViewInfo;
begin
  Result := TdxChartAxisCustomTickViewInfo(inherited Add);
end;

procedure TdxChartAxisCustomTicksViewInfo.Offset(const ADistance: TdxPointF);
var
  ABounds: TdxRectF;
  AVisibleBounds: TdxRectF;
begin
  ABounds := cxRectOffset(Bounds, ADistance);
  AVisibleBounds := cxRectOffset(VisibleBounds, ADistance);
  inherited Offset(ADistance);
  UpdateBounds(ABounds, AVisibleBounds);
end;

{ TdxChartAxisTicksViewInfo }

constructor TdxChartAxisTicksViewInfo.Create(AOwner: TdxChartAxisViewInfo);
begin
  inherited Create(AOwner);
  FItemViewInfoClass := TdxChartAxisTickViewInfo;
end;

procedure TdxChartAxisTicksViewInfo.CalculateInterval;
begin
  FInterval := 0;
  if Count > 1 then
    FInterval := Abs(Items[0].CanvasValue - Items[1].CanvasValue);
end;

function TdxChartAxisTicksViewInfo.GetActualPen: TcxCanvasBasedPen;
begin
  Result := Owner.Axis.Appearance.ActualTickPen;
end;

function TdxChartAxisTicksViewInfo.GetItem(Index: Integer): TdxChartAxisTickViewInfo;
begin
  Result := TdxChartAxisTickViewInfo(FList.List[Index]);
end;

{ TdxChartAxisMinorTicksViewInfo }

constructor TdxChartAxisMinorTicksViewInfo.Create(AOwner: TdxChartAxisViewInfo);
begin
  inherited Create(AOwner);
  FItemViewInfoClass := TdxChartAxisMinorTickViewInfo;
end;

procedure TdxChartAxisMinorTicksViewInfo.CalculateInterval;
begin
  FInterval := Owner.Ticks.Interval / (Owner.Axis.MinorCount + 1);
end;

function TdxChartAxisMinorTicksViewInfo.GetActualPen: TcxCanvasBasedPen;
begin
  Result := Owner.Axis.Appearance.ActualMinorTickPen;
end;

function TdxChartAxisMinorTicksViewInfo.GetItem(Index: Integer): TdxChartAxisMinorTickViewInfo;
begin
  Result := TdxChartAxisMinorTickViewInfo(FList.List[Index]);
end;

{ TdxChartAxisGridlinesViewInfo }

constructor TdxChartAxisGridlinesViewInfo.Create(AOwner: TdxChartAxisViewInfo);
begin
  inherited Create(AOwner);
  FItemViewInfoClass := TdxChartAxisGridlineViewInfo;
end;

function TdxChartAxisGridlinesViewInfo.Add(ATick: TdxChartAxisCustomTickViewInfo): TdxChartAxisGridlineViewInfo;
begin
  Result := TdxChartAxisGridlineViewInfo(inherited Add);
  Result.FAxisTick := ATick;
end;

function TdxChartAxisGridlinesViewInfo.GetActualPen: TcxCanvasBasedPen;
begin
  Result := Owner.Axis.Gridlines.ActualPen;
end;

function TdxChartAxisGridlinesViewInfo.GetItem(Index: Integer): TdxChartAxisGridlineViewInfo;
begin
  Result := FList.List[Index];
end;

{ TdxChartAxisMinorGridlinesViewInfo }

function TdxChartAxisMinorGridlinesViewInfo.GetActualPen: TcxCanvasBasedPen;
begin
  Result := Owner.Axis.Gridlines.ActualMinorGridlinePen;
end;

{ TdxChartAxisViewData }

constructor TdxChartAxisViewData.Create(AAxis: TdxChartCustomAxis);
const
  AStepMap: array[0..6] of Double = (0.1, 0.2, 0.5, 1, 2, 5, 10);
begin
  FAxis := AAxis;
  SetLength(FStepMap, Length(AStepMap));
  Move(AStepMap[0], FStepMap[0], SizeOf(AStepMap));
  MakeDirty;
end;

function TdxChartAxisViewData.AxisValueAsDouble(const AValue: Variant): Double;
begin
  Result := NaN;
  if IsAssigned(AValue) then
    try
      Result := AValue;
    except
    end;
end;

procedure TdxChartAxisViewData.CalculateRanges;
begin
  Range.Calculate;
  CalculateStep;
  CalculateTicks;
  CalculateScalePrecision;
end;

procedure TdxChartAxisViewData.CalculateScalePrecision;

  function IsInt(const AValue: Double): Boolean; inline;
  begin
    Result := IsZero(Frac(AValue));
  end;

  function GetPrecision(const AValue: Double): Integer;
  var
    AFactor: Double;
    AFractionalPart: Double;
  begin
    if IsInt(AValue) then
      Exit(0);
    Result := 0;
    repeat
      Inc(Result);
      AFactor := IntPower(10.0, Result);
      AFractionalPart := Frac(AValue * AFactor) / AFactor;
    until SameValue(AFractionalPart, 0) or SameValue(Abs(AFractionalPart), 1);
  end;

begin
  if IsInt(TickStart) and IsInt(CalculatedStep) and IsInt(TickFinish) then
    FScalePrecision := 0
  else
    FScalePrecision := Max(GetPrecision(TickStart), Max(GetPrecision(CalculatedStep), GetPrecision(TickFinish)))
end;

procedure TdxChartAxisViewData.CalculateStep;
begin
  FCalculatedStep := GetTickStep(Range);
end;

procedure TdxChartAxisViewData.CalculateTicks;
var
  AMin, AMax: Double;
  ATickOffset: Double;
begin
  if IsZero(Range.RealWholeRange.Range) then
  begin
    FTickCount := 1;
    FTickFinish := Range.RealWholeRange.Max;
    FTickStart := Range.RealWholeRange.Min;
  end
  else
  begin
    ATickOffset := Axis.TickOffset;
    AMin := Range.WholeRangeExtended.Min;
    AMax := Range.WholeRangeExtended.Max;
    if Axis.DataValueConverter <> nil then
    begin
      AMin := Axis.DataValueConverter.DataValueToAxisValue(AMin);
      AMax := Axis.DataValueConverter.DataValueToAxisValue(AMax);
    end;
    FTickStart := Floor((AMin - ATickOffset) / CalculatedStep) * CalculatedStep + ATickOffset;
    FTickFinish := Ceil((AMax - ATickOffset) / CalculatedStep) * CalculatedStep + ATickOffset;
    FTickCount := Round((FTickFinish - FTickStart) / CalculatedStep) + 1;
  end;
end;

procedure TdxChartAxisViewData.DoCalculate;
begin
  inherited DoCalculate;
  CalculateRanges;
end;

procedure TdxChartAxisViewData.DoOffsetVisualRange(const ADistance: Double);
begin
  Range.VisibleMin := Range.RealVisibleRange.Min + ADistance;
  Range.VisibleMax := Range.RealVisibleRange.Max + ADistance;
end;

function TdxChartAxisViewData.DoubleToAxisValue(const AValue: Double): Variant;
begin
  Result := AValue;
end;

function TdxChartAxisViewData.GetMax: Double;
begin
  Result := Diagram.ViewData.MaxValue;
end;

function TdxChartAxisViewData.GetMin: Double;
begin
  Result := Diagram.ViewData.MinValue;
end;

function TdxChartAxisViewData.GetTickStep(ARange: TdxChartRange): Double;
begin
  if Axis.Step <> 0 then
    Result := Axis.Step
  else
  begin
    Result := 1;
    if Axis.ViewInfo.IsNumeric then
      Result := GetOptimalTickStep(ARange);
  end;
end;

function TdxChartAxisViewData.GetValueAsText(const AValue: Variant): string;
begin
  Result := Axis.ValueLabels.GetValueAsText(AValue);
end;

function TdxChartAxisViewData.GetDiagram: TdxChartXYDiagram;
begin
  Result := Axis.Diagram;
end;

function TdxChartAxisViewData.GetOptimalTickStep(ARange: TdxChartRange): Double;

  function GetMaxVisibleValue: Double;
  begin
    if IsNotAssigned(ARange.VisibleMax) or not Range.IsValidRangeBound(ARange.VisibleMax) then
      Result := ARange.RealWholeRange.Max
    else
      Result := AxisValueAsDouble(ARange.VisibleMax);
  end;

  function GetMinVisibleValue: Double;
  begin
    if IsNotAssigned(ARange.VisibleMin) or not Range.IsValidRangeBound(ARange.VisibleMin) then
      Result := ARange.RealWholeRange.Min
    else
      Result := AxisValueAsDouble(ARange.VisibleMin);
  end;

  function PowerOf(AValue: Double): Integer;
  begin
    Result := Trunc(Log10(AValue));
  end;

  function GetTickStepByTickCount(ARangeSize: Double; ATickCount: Integer): Double;
  var
    AApproximateStep, K, AStep: Double;
    I: Integer;
  begin
    Result := 1;
    AApproximateStep := ARangeSize / ATickCount;
    if AApproximateStep <> 0 then
    begin
      K := IntPower(10.0, PowerOf(AApproximateStep));
      for I := Low(StepMap) to High(StepMap) do
      begin
        AStep := StepMap[I] * K;
        Result := AStep;
        if AApproximateStep <= AStep then
          Break;
      end;
    end;
  end;

var
  ARangeSize: Double;
begin
  Result := 1;
  if not Axis.Logarithmic then
  begin
    ARangeSize := Min(Max(GetMaxVisibleValue - GetMinVisibleValue, 0), Max(ARange.RealWholeRange.Max - ARange.RealWholeRange.Min, 0));
    if not Math.IsZero(ARangeSize) then
      Result := GetTickStepByTickCount(ARangeSize, 11);
  end;
end;

function TdxChartAxisViewData.GetRange: TdxChartRange;
begin
  Result := Axis.Range;
end;

procedure TdxChartAxisViewData.OffsetVisualRange(ADistance: Double; out ARangeChanged: Boolean);
begin
  ARangeChanged := False;
  ADistance := IfThen(ADistance < 0, Max(ADistance, Range.WholeRangeExtended.Min - Range.VisibleRangeExtended.Min),
    Min(ADistance, Range.WholeRangeExtended.Max - Range.VisibleRangeExtended.Max));
  if IsZero(ADistance) then
    Exit;
  Axis.ViewData.Diagram.BeginUpdate;
  try
    DoOffsetVisualRange(ADistance);
    ARangeChanged := True;
  finally
    Axis.ViewData.Diagram.EndUpdate;
  end;
end;

{ TdxChartAxisXViewData }

constructor TdxChartAxisXViewData.Create(AAxis: TdxChartCustomAxis);
begin
  FStringValuesHandler := TStringValuesHandler.Create(Self);
  inherited Create(AAxis);
end;

destructor TdxChartAxisXViewData.Destroy;
begin
  FreeAndNil(FStringValuesHandler);
  inherited Destroy;
end;

function TdxChartAxisXViewData.AxisValueAsDouble(const AValue: Variant): Double;
begin
  if IsNumeric or not VarIsStr(AValue) then
    Result := inherited AxisValueAsDouble(AValue)
  else
  begin
    Result := StringValuesHandler.GetValueAsDouble(AValue);
    if Result = -1 then
      try
        Result := AValue;
      except
        Result := NaN;
      end;
  end;
end;

procedure TdxChartAxisXViewData.AsyncCalculateValues;
var
  I: Integer;
  AViewData: TdxChartXYSeriesViewCustomViewData;
  AViewInfo: TdxChartXYSeriesViewCustomViewInfo;
begin
  System.TMonitor.Enter(Self);
  try
    if ValuesDirty then
      Exit;
    FMax := NaN;
    FMin := NaN;
    StringValuesHandler.Clear;
    if IsNumeric then
    begin
      for I := 0 to Diagram.ViewData.SeriesCount - 1 do
      begin
        AViewInfo := TdxChartXYSeriesViewCustomViewInfo(TdxChartXYSeriesCustomView(Diagram.ViewData.Views[I]).ViewInfo);
        AViewData := TdxChartXYSeriesViewCustomViewData(AViewInfo.ViewData);
        if not IsNan(AViewData.ArgumentMin) then
          CheckMinMax(FMin, FMax,  AViewData.ArgumentMin, AViewData.ArgumentMax);
      end
    end
    else
    begin
      StringValuesHandler.Calculate;
      FMin := 0;
      FMax := StringValuesHandler.FValues.Count - 1;
    end;
    // if empty
    if IsNan(FMin) then
    begin
      FMin := 0;
      FMax := 0;
    end;
    FValuesDirty := False;
  finally
    System.TMonitor.Exit(Self);
  end;
end;

procedure TdxChartAxisXViewData.DoCalculate;
begin
  AsyncCalculateValues;
  inherited DoCalculate;
end;

procedure TdxChartAxisXViewData.DoOffsetVisualRange(const ADistance: Double);
begin
  if not IsNumeric then
  begin
    Range.RealVisibleRange.Min := Range.RealVisibleRange.Min + ADistance;
    Range.RealVisibleRange.Max := Range.RealVisibleRange.Max + ADistance;
    Range.VisibleMin := StringValuesHandler.GetNearestValueAsText(Range.RealVisibleRange.Min);
    Range.VisibleMax := StringValuesHandler.GetNearestValueAsText(Range.RealVisibleRange.Max);
    Range.IsNonNumericScrollingActive := True;
    Range.Changed;
  end
  else
    inherited DoOffsetVisualRange(ADistance);
end;

function TdxChartAxisXViewData.DoubleToAxisValue(const AValue: Double): Variant;
begin
  if not IsNumeric then
    Result := StringValuesHandler.GetNearestValueAsText(AValue)
  else
    Result := inherited DoubleToAxisValue(AValue);
end;

procedure TdxChartAxisXViewData.ForEachValue(AProc: TdxChartForEachXYValueProc);
var
  I: Integer;
begin
  for I := 0 to Diagram.ViewData.SeriesCount - 1 do
    TdxChartXYSeriesViewCustomViewInfo(TdxChartXYSeriesCustomView(Diagram.ViewData.Views[I]).ViewInfo).ForEachValue(
      procedure(AValue: TdxChartSeriesValueViewInfo)
      var
        XYValue: TdxChartXYSeriesValueViewInfo absolute AValue;
      begin
        if TdxChartXYSeriesValueViewInfo.TValueState.Visible in XYValue.FState then
          AProc(TdxChartXYSeriesValueViewInfo(AValue));
      end);
end;

function TdxChartAxisXViewData.GetMax: Double;
begin
  Result := FMax;
end;

function TdxChartAxisXViewData.GetMin: Double;
begin
  Result := FMin;
end;

{ TdxChartAxisXViewData.TStringValuesHandler }

constructor TdxChartAxisXViewData.TStringValuesHandler.Create(AOwner: TdxChartAxisXViewData);
begin
  FOwner := AOwner;
  FValues := TdxFastObjectList.Create(False);
  FValuesMap := TObjectDictionary<TdxChartXYSeriesValueViewInfo, Integer>.Create([], TdxChartStringValueComparer.Create);
end;

destructor TdxChartAxisXViewData.TStringValuesHandler.Destroy;
begin
  FreeAndNil(FValuesMap);
  FreeAndNil(FValues);
  inherited Destroy;
end;

procedure TdxChartAxisXViewData.TStringValuesHandler.Calculate;
var
  I: Integer;
begin
  Clear;
  FOwner.ForEachValue(
    procedure(AValue: TdxChartXYSeriesValueViewInfo)
    begin
      if FValuesMap.ContainsKey(AValue) then
        Exit;
      FValuesMap.Add(AValue, 0);
      FValues.Add(AValue);
    end);
  if Assigned(FOwner.Axis.OnCompareValues) then
  begin
    FValues.SortList(
      function(AItem1, AItem2: Pointer): Integer
      begin
        Result := FOwner.Axis.CompareValues(TdxChartXYSeriesValueViewInfo(AItem1), TdxChartXYSeriesValueViewInfo(AItem2));
      end, False);
  end;
  //
  for I := 0 to FValues.Count - 1 do
    FValuesMap.AddOrSetValue(FValues.List[I], I);
  FOwner.ForEachValue(
    procedure(AValue: TdxChartXYSeriesValueViewInfo)
    var
      AIndex: Integer;
    begin
      AIndex := -1;
      FValuesMap.TryGetValue(AValue, AIndex);
      AValue.MapOnArgumentAxis(AIndex);
    end);
end;

procedure TdxChartAxisXViewData.TStringValuesHandler.Clear;
begin
  FValuesMap.Clear;
  FValues.Clear;
end;

function TdxChartAxisXViewData.TStringValuesHandler.GetNearestValueAsText(const AValue: Double): string;
var
  AIndex: Integer;
begin
  AIndex := Round(AValue);
  if (AIndex >= 0) and (AIndex < FValues.Count) then
    Result := TdxChartXYSeriesValueViewInfo(FValues[AIndex]).ArgumentDisplayText
  else
    Result := '';
end;

function TdxChartAxisXViewData.TStringValuesHandler.GetValueAsText(const AValue: Integer): string;
begin
  if (AValue >= 0) and (AValue < FValues.Count) then
    Result := TdxChartXYSeriesValueViewInfo(FValues[AValue]).ArgumentDisplayText
  else
    Result := '';
end;

function TdxChartAxisXViewData.TStringValuesHandler.GetValueAsDouble(const ADisplayText: string): Double;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if TdxChartXYSeriesValueViewInfo(FValues[I]).ArgumentDisplayText = ADisplayText then
    begin
      Result := TdxChartXYSeriesValueViewInfo(FValues[I]).Argument;
      Break;
    end;
end;

function TdxChartAxisXViewData.TStringValuesHandler.GetCount: Integer;
begin
  Result := FValues.Count;
end;

function TdxChartAxisXViewData.GetValueAsText(const AValue: Variant): string;
begin
  if IsNumeric then
    Result := inherited GetValueAsText(AValue)
  else
    Result := Axis.ValueLabels.GetValueAsText(StringValuesHandler.GetValueAsText(Trunc(AValue)));
end;

function TdxChartAxisXViewData.IsNumeric: Boolean;
begin
  Result := Axis.IsNumeric;
end;

function TdxChartAxisXViewData.GetAxis: TdxChartCustomAxisX;
begin
  Result := TdxChartCustomAxisX(inherited Axis);
end;

{ TdxChartAxisViewInfoCalculationHelper }

class function TdxChartAxisViewInfoCalculationHelper.GetSign: TValueSign;
begin
  Result := 1;
end;

class function TdxChartAxisViewInfoCalculationHelper.IsCenter: Boolean;
begin
  Result := False;
end;

class function TdxChartAxisViewInfoCalculationHelper.IsFar: Boolean;
begin
  Result := False;
end;

class function TdxChartAxisViewInfoCalculationHelper.IsHorizontal: Boolean;
begin
  Result := False;
end;

class function TdxChartAxisViewInfoCalculationHelper.IsNear: Boolean;
begin
  Result := False;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.ExpandFarTransversalBorder(var ABounds: TdxRectF; dValue: Single);
begin
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.ExpandNearTransversalBorder(var ABounds: TdxRectF; dValue: Single);
begin
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetLongitudinalSize(const ASize: TdxSizeF): Single;
begin
  Result := 0;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetTransversalSize(const ASize: TdxSizeF): Single;
begin
  Result := 0;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetFarTransversalValue(const R: TdxRectF): Single;
begin
  Result := 0;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetNearTransversalValue(const R: TdxRectF): Single;
begin
  Result := 0;
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.SetFarLongitudinalValue(var R: TdxRectF; AValue: Single);
begin
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.SetFarTransversalValue(var R: TdxRectF; AValue: Single);
begin
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.SetNearLongitudinalValue(var R: TdxRectF; AValue: Single);
begin
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.SetNearTransversalValue(var R: TdxRectF; AValue: Single);
begin
  dxAbstractError;
end;


class function TdxChartAxisViewInfoCalculationHelper.AxisIncludesTickmark(AViewInfo: TdxChartAxisViewInfo; ATickmark: TdxChartAxisCustomTickViewInfo): Boolean;
begin
  Result := False;
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.CalculateAxisLine(AViewInfo: TdxChartAxisViewInfo; out ALineRect: TdxRectF; out ALineStart, ALineFinish: TdxPointF);
begin
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetActualTitlePosition(AViewInfo: TdxChartAxisViewInfo): TdxChartTitlePosition;
begin
  Result := TdxChartTitlePosition.Default;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetAvailableAreaForTitle(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := TdxRectF.Null;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetAxisBounds(AViewInfo: TdxChartAxisViewInfo): TdxRectF;
begin
  Result := TdxRectF.Null;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetAxisLineProjectionCanvasValue(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  Result := 0;
  dxAbstractError;
end;

class procedure  TdxChartAxisViewInfoCalculationHelper.CalculateLineEnds(AViewInfo: TdxChartAxisViewInfo;
  AAnchor, AThickness: Single; const ALineBounds: TdxRectF; var AStart, AFinish: TdxPointF);
begin
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.CalculateViewpoint(
  AAxis: TdxChartCustomAxis; const ABounds: TdxRectF; out AOffset: Single; out AOffsetDirection: TValueSign);
begin
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetInterlacedBounds(AStart, AFinish: Single; const APattern: TdxRectF): TdxRectF;
begin
  Result := TdxRectF.Null;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetLabelsAreaTransversalSize(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  Result := 0;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetLabelsAreaStart(AViewInfo: TdxChartAxisViewInfo): Single;
begin
  Result := 0;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetLabelRectStart(AViewInfo: TdxChartAxisViewInfo;
  ATickCanvasValue, ATextLongitudinalSize: Single; ALabelAlignment: TdxAlignment): Single;
begin
  Result := 0;
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetOccupiedSides(AViewInfo: TdxChartAxisViewInfo;
  const AArea: TdxRectF): TcxBorders;
begin
  Result := [];
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.GetTransversalOffsetDistance(AOffset: Single): TdxPointF;
begin
  Result := dxNullPointF;
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.IncludeInnerTitleAndLabelsInBounds(AViewInfo: TdxChartAxisViewInfo; var ABounds: TdxRectF);
begin
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.LabelsAreaCanIntersectsWith(const R: TdxRectF; AViewInfo: TdxChartAxisViewInfo): Boolean;
begin
  Result := False;
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.ResolveOverlapping(AViewInfo: TdxChartAxisViewInfo);
begin
  dxAbstractError;
end;

class function TdxChartAxisViewInfoCalculationHelper.SelectFarFromBorder(AViewInfo: TdxChartAxisViewInfo; const R1, R2: TdxRectF): TdxRectF;
begin
  Result := dxNullRectF;
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.UpdateGridline(
  AViewInfo: TdxChartAxisViewInfo; AGridline: TdxChartAxisGridlineViewInfo; const APlotArea: TdxRectF);
begin
  dxAbstractError;
end;

class procedure TdxChartAxisViewInfoCalculationHelper.UpdateInterlaced(
  AViewInfo: TdxChartAxisViewInfo; AInterlaced: TdxChartXYDiagramInterlacedViewInfo; const APlotArea: TdxRectF);
begin
  dxAbstractError;
end;

{ TdxChartAxisViewInfo }

constructor TdxChartAxisViewInfo.Create(AOwner: TdxChartCustomAxis);
begin
  inherited Create(AOwner.Appearance);
  FAxis := AOwner;
  FTicks := TdxChartAxisTicksViewInfo.Create(Self);
  FLabels := TdxFastObjectList.Create(True);
  FInterlacedItems := TdxFastObjectList.Create(True);
  FGridlines := TdxChartAxisGridlinesViewInfo.Create(Self);
  FMinorTicks := TdxChartAxisMinorTicksViewInfo.Create(Self);
  FMinorGridlines := TdxChartAxisMinorGridlinesViewInfo.Create(Self);
end;

destructor TdxChartAxisViewInfo.Destroy;
begin
  FreeAndNil(FMinorGridlines);
  FreeAndNil(FInterlacedItems);
  FreeAndNil(FGridlines);
  FreeAndNil(FMinorTicks);
  FreeAndNil(FLabels);
  FreeAndNil(FTicks);
  inherited Destroy;
end;

function TdxChartAxisViewInfo.CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
var
  I: Integer;
begin
  for I := Labels.Count - 1 downto 0 do
  begin
    Result := &Label[I].CalculateHitTest(AHitTest, P);
    if Result then
      Exit;
  end;
  if Axis.Title.ViewInfo.ActuallyVisible then
  begin
    Result := TdxChartCustomItemViewInfoAccess(Axis.Title.ViewInfo).CalculateHitTest(AHitTest, P);
    if Result then
      Exit;
  end;
  Result := inherited CalculateHitTest(AHitTest, P);
end;

procedure TdxChartAxisViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
var
  APrevBounds: TdxRectF;
  APrevTickLabelsAreaSize: Single;

  procedure InternalCalculate;
  begin
    CalculateBounds;
    CalculateVisibleRange;
    if APrevBounds <> Bounds then
    begin
      CalculateAxisLine;
      CalculateAxisTickDockedObjects;
    end;
  end;

begin
  if not IsCentered and (Axis.Title.Position = TdxChartAxisTitlePosition.Outside) then
    CalculateTitle(ACanvas, GetAvailableAreaForTitle);

  APrevTickLabelsAreaSize := FLabelsAreaTransversalSize;
  APrevBounds := Bounds;
  InternalCalculate;
  if APrevTickLabelsAreaSize <> FLabelsAreaTransversalSize then
    InternalCalculate;

  if APrevBounds <> Bounds then
  begin
    if IsCentered or (Axis.Title.Position = TdxChartAxisTitlePosition.Inside) then
      CalculateTitle(ACanvas, GetAvailableAreaForTitle);
  end;

  if ActualSecondaryAxisIndent > 0 then
    IncludeInnerTitleAndLabelsInBounds
  else
    UpdateBounds(Bounds);
  UpdateLabelsArea;
  FIsScrollBarEnabled := Axis.IsScrollBarEnabled;
end;

procedure TdxChartAxisViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin

  Axis.Title.ViewInfo.Draw(ACanvas);

  ACanvas.EnableAntialiasing(False);
  ACanvas.Line(AxisLineStart, AxisLineFinish, Axis.Appearance.ActualPen);
  MinorTicks.Draw(ACanvas);
  Ticks.Draw(ACanvas);
  ACanvas.RestoreAntialiasing;

  for I := 0 to Labels.Count - 1 do
    &Label[I].Draw(ACanvas);
end;

procedure TdxChartAxisViewInfo.EnableExportMode(AEnable: Boolean);
begin
  inherited EnableExportMode(AEnable);
  Ticks.FIsExportMode := AEnable;
  MinorTicks.FIsExportMode := AEnable;
  Gridlines.FIsExportMode := AEnable;
end;

function TdxChartAxisViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  Result := TdxChartComponentDependentHitElement.Create(Axis, False, Axis.Diagram, TdxChartHitCode.Axis);
end;

procedure TdxChartAxisViewInfo.AddGridlineAndInterlaced(AAxisTick, APriorTick: TdxChartAxisTickViewInfo;
  AThickness, AHalfThickness: Single; const APlotArea: TdxRectF; var ACurrentInterlaced: Boolean);
var
  AGridline: TdxChartAxisGridlineViewInfo;
  AInterlacedInfo: TdxChartXYDiagramInterlacedViewInfo;
begin
  AGridline := Gridlines.Add(AAxisTick);
  AGridline.Visible := Axis.Gridlines.Visible;
  CalculateGridline(AGridline, AAxisTick.CanvasValue, AThickness, AHalfThickness, APlotArea);

  if Axis.Interlaced and (APriorTick <> nil) then
  begin
    if ACurrentInterlaced and (APriorTick.InVisibleArea or AAxisTick.InVisibleArea) then
    begin
      AInterlacedInfo := TdxChartXYDiagramInterlacedViewInfo.Create(APriorTick);
      AInterlacedInfo.UpdateBounds(GetInterlacedBounds(APriorTick.CanvasValue, AAxisTick.CanvasValue, AGridline.Bounds), APlotArea);
      InterlacedItems.Add(AInterlacedInfo);
    end;
    ACurrentInterlaced := not ACurrentInterlaced;
  end;
end;

procedure TdxChartAxisViewInfo.CalculateAxisLine;
begin
  FCalculationHelper.CalculateAxisLine(Self, FAxisLineRect, FAxisLineStart, FAxisLineFinish);
end;

procedure TdxChartAxisViewInfo.CalculateBounds;
var
  ABounds: TdxRectF;
begin
  ABounds := GetAxisBounds;
  SetBounds(ABounds, ABounds);
end;

procedure TdxChartAxisViewInfo.CalculateGridline(AGridline: TdxChartAxisGridlineViewInfo;
  ACanvasValue, AThickness, AHalfThickness: Single; const APlotArea: TdxRectF);
var
  ABounds: TdxRectF;
  P1, P2: TdxPointF;
begin
  ABounds := GetGridlineRect(ACanvasValue, AHalfThickness);
  FCalculationHelper.CalculateLineEnds(Self, ACanvasValue, AThickness, ABounds, P1, P2);
  AGridline.Visible := AGridline.Visible and APlotArea.IntersectsWith(ABounds);
  AGridline.UpdateBounds(ABounds, P1, P2); // must be set always, because it used for Interlaced
end;

procedure TdxChartAxisViewInfo.CalculateGridlinesStartAndFinish(const APlotArea: TdxRectF);
begin
  FGridlinesStart := GetNearTransversalValue(APlotArea);
  FGridlinesFinish := GetFarTransversalValue(APlotArea);
end;

procedure TdxChartAxisViewInfo.CalculateMinorTicksStartAndFinish;
var
  AActualTickLength: Single;
begin
  if Axis.Ticks.MinorVisible then
  begin
    AActualTickLength := Axis.Ticks.MinorLength;
    MinorTicks.FStart := GetTickStart(Axis.Ticks.MinorCrossKind, AActualTickLength);
    MinorTicks.FFinish := MinorTicks.Start + GetSign * AActualTickLength;
  end
  else
  begin
    MinorTicks.FStart := GetNearTransversalValue(FAxisLineRect);
    MinorTicks.FFinish := MinorTicks.Start;
  end;
end;

procedure TdxChartAxisViewInfo.CalculateMinorTicksAndGridlines(const APlotArea, AVisibleBounds: TdxRectF);
var
  AGridline: TdxChartAxisGridlineViewInfo;
  AGridlineHalfThickness: Single;
  AGridlineThickness: Single;
  AMinorScale: Single;
  AMinorTick: TdxChartAxisCustomTickViewInfo;
  AMinorTicksVisible: Boolean;
  AStartValue: Single;
  ATickHalfThickness: Single;
  ATickThickness: Single;
  ATickValue: Double;
  I, M: Integer;
begin
  MinorTicks.Clear;

  if (Axis.MinorCount > 0) and (Ticks.Count >= 2) and IsNumeric and (Axis.Ticks.MinorVisible or Axis.Gridlines.MinorVisible) then
  begin
    ATickThickness := Axis.Ticks.MinorThickness;
    ATickHalfThickness := ATickThickness / 2;
    AGridlineThickness := Axis.Gridlines.MinorThickness;
    AGridlineHalfThickness := AGridlineThickness / 2;
    AMinorScale := (Ticks[1].AxisValue - Ticks[0].AxisValue) / (Axis.MinorCount + 1);
    AMinorTicksVisible := Axis.Ticks.MinorVisible;
    for I := 1 to Ticks.Count - 1 do
    begin
      AStartValue := Ticks[I - 1].AxisValue;

      for M := 1 to Axis.MinorCount do
      begin
        ATickValue := AStartValue + M * AMinorScale;
        if IsTickInVisibleArea(ATickValue) then
        begin
          AMinorTick := MinorTicks.Add;
          AMinorTick.AxisValue := ATickValue;
          AMinorTick.CanvasValue := Ceil(AxisValueToCanvasValue(ATickValue));
          AMinorTick.Visible := AMinorTicksVisible;
          if AMinorTick.Visible then
            CalculateTickMarkLine(AMinorTick, True, ATickThickness, ATickHalfThickness, AVisibleBounds);
          if Axis.Gridlines.MinorVisible then
          begin
            AGridline := MinorGridlines.Add(AMinorTick);
            AGridline.Visible := True;
            CalculateGridline(AGridline, AMinorTick.CanvasValue, AGridlineThickness, AGridlineHalfThickness, APlotArea);
          end;
        end;
      end;
    end;
  end;

  MinorTicks.CalculateBounds(AVisibleBounds);
end;

function TdxChartAxisViewInfo.GetLabelBounds(AAxisTick: TdxChartAxisTickViewInfo; ALabelAlignment: TdxAlignment): TdxRectF;
begin
  Result := GetLabelBounds(AAxisTick.&Label.Size, AAxisTick.CanvasValue, ALabelAlignment);
end;

function TdxChartAxisViewInfo.GetLabelBounds(ALabelSize: TdxSizeF; ACanvasValue: Single; ALabelAlignment: TdxAlignment): TdxRectF;
var
  ALabelLongitudinalSize, ALabelLongitudinalStart, ALabelTransversalFinish: Single;
  ADirectionSign: TValueSign;
begin
  ADirectionSign := GetSign;

  ALabelLongitudinalSize := GetLongitudinalSize(ALabelSize);
  ALabelLongitudinalStart := GetLabelRectStart(ACanvasValue, ALabelLongitudinalSize, ALabelAlignment);
  SetNearLongitudinalValue(Result, ALabelLongitudinalStart);
  SetFarLongitudinalValue(Result, ALabelLongitudinalStart + ALabelLongitudinalSize);
  if ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside then
  begin
    SetFarTransversalValue(Result, FLabelsAreaStart);
    ALabelTransversalFinish := FLabelsAreaStart + ADirectionSign * GetTransversalSize(ALabelSize);
    SetNearTransversalValue(Result, ALabelTransversalFinish);
  end
  else
  begin
    SetNearTransversalValue(Result, FLabelsAreaStart);
    ALabelTransversalFinish := FLabelsAreaStart - ADirectionSign * GetTransversalSize(ALabelSize);
    SetFarTransversalValue(Result, ALabelTransversalFinish);
  end;
  Result.InitSize(Floor(Result.Left), Floor(Result.Top), Ceil(Result.Width), Ceil(Result.Height));
end;

procedure TdxChartAxisViewInfo.CalculateTickMarkLine(ATick: TdxChartAxisCustomTickViewInfo;
  AMinorTick: Boolean; AThickness, AHalfThickness: Single; const AVisibleBounds: TdxRectF);
var
  ARect: TdxRectF;
  P1, P2: TdxPointF;
begin
  SetNearLongitudinalValue(ARect, ATick.CanvasValue - AHalfThickness);
  SetFarLongitudinalValue(ARect, ATick.CanvasValue + AHalfThickness);
  if AMinorTick then
  begin
    SetFarTransversalValue(ARect, MinorTicks.Start);
    SetNearTransversalValue(ARect, MinorTicks.Finish);
  end
  else
  begin
    SetFarTransversalValue(ARect, Ticks.Start);
    SetNearTransversalValue(ARect, Ticks.Finish);
  end;
  FCalculationHelper.CalculateLineEnds(Self, ATick.CanvasValue, AThickness, ARect, P1, P2);
  ATick.UpdateBounds(ARect, P1, P2);
end;

procedure TdxChartAxisViewInfo.CalculateTicksStartAndFinish;
var
  AActualTickLength: Single;
begin
  if Axis.Ticks.Visible then
  begin
    AActualTickLength := Axis.Ticks.Length;
    Ticks.FStart := GetTickStart(Axis.Ticks.CrossKind, AActualTickLength);
    Ticks.FFinish := Ticks.Start + GetSign * AActualTickLength;
  end
  else
  begin
    Ticks.FStart := GetNearTransversalValue(FAxisLineRect);
    Ticks.FFinish := Ticks.Start;
  end;
end;

procedure TdxChartAxisViewInfo.CalculateTickIntervals;
begin
  Ticks.CalculateInterval;
  MinorTicks.CalculateInterval;
  if IsNumeric then
    FActualTickInterval := MinorTicks.Interval
  else
    FActualTickInterval := Ticks.Interval;
end;

procedure TdxChartAxisViewInfo.ResolveLabelsOverlapping(ACompetingAxis: TdxChartCustomAxis; ACompetingSecondaryAxes: TdxChartSecondaryCustomAxes);

  function LabelHasOverlapping(ALabel: TdxChartAxisTickLabelViewInfo; AAxis: TdxChartCustomAxis): Boolean;
  begin
    Result := ALabel.BoundsBox.IntersectsWith(AAxis.ViewInfo.AxisLineRect);
    if Result and
      (ALabel.AxisTick.Axis.Ticks.LabelAlignment in [TdxAlignment.Near, TdxAlignment.Far]) and
       AAxis.ViewInfo.IncludesTickmark(ALabel.AxisTick) then
      Result := False;
    Result := Result or ALabel.IsOccupied(ALabel.BoundsBox, AAxis, False);
  end;

  function IsIntersectionDetected(var ALabel: TdxChartAxisTickLabelViewInfo): Boolean;
  var
    I: Integer;
  begin
    Result := LabelHasOverlapping(ALabel, ACompetingAxis);
    if not Result and (ACompetingSecondaryAxes <> nil) then
      for I := 0 to ACompetingSecondaryAxes.Count - 1 do
      begin
        Result := LabelHasOverlapping(ALabel, ACompetingSecondaryAxes.Items[I].Axis);
        if Result  then
          Break;
      end;
  end;

var
  I: Integer;
  ALabel: TdxChartAxisTickLabelViewInfo;
begin
  if not Axis.ValueLabels.Visible then
    Exit;
  if ACompetingAxis.ActuallyVisible then
    for I := 0 to Labels.Count - 1 do
    begin
      ALabel := &Label[I];
      if ALabel.Visible and IsIntersectionDetected(ALabel) then
        TryMoveLabel(ALabel, ACompetingAxis, ACompetingSecondaryAxes);
    end;
end;

procedure TdxChartAxisViewInfo.CalculateAxisTickDockedObjects;
var
  AAxisTick: TdxChartAxisTickViewInfo;
  ACurrentInterlaced: Boolean;
  AGridlineHalfThickness: Single;
  AGridlineThickness: Single;
  ALabelAlignment: TdxAlignment;
  ALabelVisibleBounds: TdxRectF;
  APlotArea: TdxRectF;
  APriorTick: TdxChartAxisTickViewInfo;
  ATickHalfThickness: Single;
  ATickMarkVisibleBounds: TdxRectF;
  ATickThickness: Single;
  ATicksVisible: Boolean;
  I: Integer;
begin
  FMinorGridlines.Clear;
  InterlacedItems.Clear;
  FGridlines.Clear;

  APlotArea := AvailableBounds;
  if not IsCentered then
    CorrectAvailableArea(APlotArea);
  ATickMarkVisibleBounds := GetTickMarkVisibleBounds;
  CalculateTicksStartAndFinish;
  CalculateMinorTicksStartAndFinish;
  CalculateGridlinesStartAndFinish(APlotArea);
  ATicksVisible := Axis.Ticks.Visible;

  FLabelsAreaStart := GetLabelsAreaStart;
  ALabelVisibleBounds := Axis.Diagram.ViewInfo.VisibleBounds;
  ALabelAlignment := Axis.Ticks.LabelAlignment;
  ATickThickness := Axis.Ticks.Thickness;
  ATickHalfThickness := ATickThickness / 2;
  AGridlineThickness := Axis.Gridlines.Thickness;
  AGridlineHalfThickness := AGridlineThickness / 2;
  ACurrentInterlaced := False;

  APriorTick := nil;
  for I := 0 to Ticks.Count - 1 do
  begin
    AAxisTick := Ticks[I];
    AAxisTick.CanvasValue := Ceil(AxisValueToCanvasValue(AAxisTick.AxisValue));
    AAxisTick.Visible := AAxisTick.InVisibleArea and ATicksVisible;
    if AAxisTick.Visible then
      CalculateTickMarkLine(AAxisTick, False, ATickThickness, ATickHalfThickness, ATickMarkVisibleBounds);

    if AAxisTick.&Label.Visible then
      AAxisTick.&Label.SetBounds(GetLabelBounds(AAxisTick, ALabelAlignment), ALabelVisibleBounds);

    if Axis.Gridlines.Visible or Axis.Gridlines.MinorVisible or Axis.Interlaced then
      AddGridlineAndInterlaced(AAxisTick, APriorTick, AGridlineThickness, AGridlineHalfThickness, APlotArea, ACurrentInterlaced);

    APriorTick := AAxisTick;
  end;
  CalculateTickIntervals;

  ResolveOverlapping;
  RecalculateLabelAreaTransversalSize;

  CalculateMinorTicksAndGridlines(APlotArea, ATickMarkVisibleBounds);
  Ticks.CalculateBounds(ATickMarkVisibleBounds);
  MinorGridlines.CalculateBounds(APlotArea);
  Gridlines.CalculateBounds(APlotArea);
end;

procedure TdxChartAxisViewInfo.CalculateTitle(ACanvas: TcxCustomCanvas; const AAvailableArea: TdxRectF);
var
  ATitleBounds: TdxRectF;
begin
  ATitleBounds := AAvailableArea;
  Axis.Title.CalculateAndAdjustContent(ACanvas, ATitleBounds);
  if Axis.Title.ViewInfo.ActuallyVisible and (Axis.Title.Position = TdxChartAxisTitlePosition.Outside) and not IsCentered then
    FTitleOuterAreaSize := GetTransversalSize(AAvailableArea.Size) - GetTransversalSize(ATitleBounds.Size)
  else
    FTitleOuterAreaSize := 0;
end;

procedure TdxChartAxisViewInfo.CorrectAvailableArea(var AArea: TdxRectF);
begin
  if Axis.ActuallyVisible and not Bounds.IsEmpty then
    SetNearTransversalValue(AArea, GetFarTransversalValue(Bounds));
end;

function TdxChartAxisViewInfo.GetActualThickness: Single;
begin
  Result := Appearance.Thickness;
end;

function TdxChartAxisViewInfo.GetOuterTransversalSize: Single;
begin
  Result := GetActualThickness + GetOutsideTickMarkMaxLength + FTitleOuterAreaSize;
  if ValueLabels.Visible and (ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside) then
    Result := Result + GetLabelPadding + FLabelsAreaTransversalSize
  else
    if IsZero(FTitleOuterAreaSize) and not IsCentered then
      Result := Result + GetLabelPadding;
end;

function TdxChartAxisViewInfo.GetActualTitlePosition: TdxChartTitlePosition;
begin
  Result := FCalculationHelper.GetActualTitlePosition(Self);
end;

function TdxChartAxisViewInfo.GetAvailableAreaForTitle: TdxRectF;
begin
  Result := FCalculationHelper.GetAvailableAreaForTitle(Self);
end;

function TdxChartAxisViewInfo.GetAxisLineProjectionCanvasValue: Single;
begin
  Result := FCalculationHelper.GetAxisLineProjectionCanvasValue(Self);
end;

function TdxChartAxisViewInfo.GetCanvasZeroValue(const AActualBounds: TdxRectF): Single;
begin
  CalculateViewpoint(AActualBounds);
  Result := Ceil(AxisValueToCanvasValue(0));
  CalculateViewpoint(Bounds);
end;

function TdxChartAxisViewInfo.GetCrosshairLabelsArea: TdxRectF;
begin
  Result := ViewData.Diagram.ViewInfo.Bounds;
  if ValueLabels.Position = TdxChartAxisValueLabelPosition.Outside then
    SetFarTransversalValue(Result, LabelsAreaStart)
  else
    SetNearTransversalValue(Result, LabelsAreaStart);
end;

function TdxChartAxisViewInfo.GetGridlineRect(ACanvasValue, AHalfThickness: Single): TdxRectF;
begin
  SetNearTransversalValue(Result, FGridlinesStart);
  SetFarTransversalValue(Result, FGridlinesFinish);
  SetNearLongitudinalValue(Result, ACanvasValue - AHalfThickness);
  SetFarLongitudinalValue(Result, ACanvasValue + AHalfThickness);
end;

function TdxChartAxisViewInfo.GetInsideTickMarkMaxLength: Single;
var
  ATicks: TdxChartAxisTicks;
begin
  ATicks := Axis.Ticks;
  Result := Max(
    ATicks.Length * Integer(ATicks.Visible and (ATicks.CrossKind <> TdxChartAxisTicksCrossKind.Outside)),
    ATicks.MinorLength * Integer(ATicks.MinorVisible and (ATicks.MinorCrossKind <> TdxChartAxisTicksCrossKind.Outside)));
end;

function TdxChartAxisViewInfo.GetInterlacedBounds(AStart, AFinish: Single; const APattern: TdxRectF): TdxRectF;
begin
  if Axis.Reverse then
    Result := FCalculationHelper.GetInterlacedBounds(AFinish, AStart, APattern)
  else
    Result := FCalculationHelper.GetInterlacedBounds(AStart, AFinish, APattern);
end;

function TdxChartAxisViewInfo.GetOccupiedSides(const AArea: TdxRectF): TcxBorders;
begin
  Result := FCalculationHelper.GetOccupiedSides(Self, AArea);
end;

function TdxChartAxisViewInfo.GetOutsideTickMarkMaxLength: Single;
var
  ATicks: TdxChartAxisTicks;
begin
  ATicks := Axis.Ticks;
  Result := Max(
    ATicks.Length * Integer(ATicks.Visible and (ATicks.CrossKind <> TdxChartAxisTicksCrossKind.Inside)),
    ATicks.MinorLength * Integer(ATicks.MinorVisible and (ATicks.MinorCrossKind <> TdxChartAxisTicksCrossKind.Inside)));
end;

function TdxChartAxisViewInfo.GetLabelsAreaStart: Single;
begin
  Result := FCalculationHelper.GetLabelsAreaStart(Self);
end;

function TdxChartAxisViewInfo.GetTickStart(const ACrossKind: TdxChartAxisTicksCrossKind; var AActualTickLength: Single): Single;
begin
  if ACrossKind = TdxChartAxisTicksCrossKind.Outside then
    Result := GetNearTransversalValue(FAxisLineRect)
  else
  begin
    Result := GetFarTransversalValue(FAxisLineRect) - GetSign * AActualTickLength;
    if ACrossKind = TdxChartAxisTicksCrossKind.Cross then
      AActualTickLength := 2 * AActualTickLength + GetActualThickness;
  end;
end;

function TdxChartAxisViewInfo.GetTickMarkVisibleBounds: TdxRectF;
var
  dNear, dFar: Single;
begin
  Result := Bounds;
  dFar := 0;
  dNear := 0;
  if IsCentered then
  begin
    if Axis.Ticks.Visible then
      case Axis.Ticks.CrossKind of
        TdxChartAxisTicksCrossKind.Outside:
          dNear := Axis.Ticks.Length;
        TdxChartAxisTicksCrossKind.Cross:
        begin
          dFar := Axis.Ticks.Length;
          dNear := Axis.Ticks.Length;
        end;
      else
        dFar := Axis.Ticks.Length;
      end;
    if Axis.Ticks.MinorVisible then
      case Axis.Ticks.MinorCrossKind of
        TdxChartAxisTicksCrossKind.Outside:
          dNear := Max(dNear, Axis.Ticks.MinorLength);
        TdxChartAxisTicksCrossKind.Cross:
        begin
          dFar := Max(dFar, Axis.Ticks.MinorLength);
          dNear := Max(dNear, Axis.Ticks.MinorLength);
        end;
      else
        dFar := Max(dFar, Axis.Ticks.MinorLength);
      end;
  end
  else
  begin
    if Axis.Ticks.Visible and (Axis.Ticks.CrossKind <> TdxChartAxisTicksCrossKind.Outside) then
      dFar := Axis.Ticks.Length;
    if Axis.Ticks.MinorVisible and (Axis.Ticks.MinorCrossKind <> TdxChartAxisTicksCrossKind.Outside) then
      dFar := Max(dFar, Axis.Ticks.MinorLength);
  end;
  if dNear <> 0 then
    FCalculationHelper.ExpandNearTransversalBorder(Result, dNear);
  if dFar <> 0 then
    FCalculationHelper.ExpandFarTransversalBorder(Result, dFar);
end;

function TdxChartAxisViewInfo.GetVisibleAreaSize: Single;
begin
  Result := GetLongitudinalSize(Bounds.Size);
end;

function TdxChartAxisViewInfo.GetZoomPercent: Single;
begin
  if FViewpointScaleFactor = 0 then
    Result := 100
  else
    Result := Abs(FViewpointScaleFactor) * 100;
end;

procedure TdxChartAxisViewInfo.HideCrossedLabels;
var
  I: Integer;
  ALabel: TdxChartAxisTickLabelViewInfo;
  Pg1, Pg2, Pg3: PdxPolygonF;
begin
  Pg1 := nil;
  Pg2 := nil;
  for I := 0 to Labels.Count - 1 do
  begin
    ALabel := &Label[I];
    if ALabel.Visible and ALabel.Area.PointsPresent(4) then
    begin
      Pg3 := @ALabel.Area;
      if HasPolygonIntersection(Pg1, Pg2, Pg3) then
        ALabel.Visible := False
      else
      begin
        Pg1 := Pg2;
        Pg2 := Pg3;
      end;
    end;
  end;
end;

procedure TdxChartAxisViewInfo.HideLabels;
var
  I, AVisibleIndex: Integer;
  ALabel: TdxChartAxisTickLabelViewInfo;
begin
  AVisibleIndex := 0;
  for I := 0 to Labels.Count - 1 do
  begin
    ALabel := &Label[I];
    if ALabel.Visible then
    begin
      ALabel.Visible := AVisibleIndex mod 2 = 0;
      Inc(AVisibleIndex);
    end;
  end;
end;

procedure TdxChartAxisViewInfo.IncludeInnerTitleAndLabelsInBounds;
var
  ABounds: TdxRectF;
begin
  ABounds := Bounds;
  FCalculationHelper.IncludeInnerTitleAndLabelsInBounds(Self, ABounds);
  UpdateBounds(ABounds, ABounds);
end;

function TdxChartAxisViewInfo.IncludesTickmark(AAxisTick: TdxChartAxisCustomTickViewInfo): Boolean;
begin
  Result := FCalculationHelper.AxisIncludesTickmark(Self, AAxisTick);
end;

function TdxChartAxisViewInfo.IsLabelsCrossed: Boolean;
var
  I: Integer;
  ALabel: TdxChartAxisTickLabelViewInfo;
  Pg1, Pg2, Pg3: PdxPolygonF;
begin
  Result := False;
  Pg1 := nil;
  Pg2 := nil;
  for I := 0 to Labels.Count - 1 do
  begin
    ALabel := &Label[I];
    if ALabel.Visible and ALabel.Area.PointsPresent(4) then
    begin
      Pg3 := @ALabel.Area;
      Result := HasPolygonIntersection(Pg1, Pg2, Pg3);
      if Result then
        Break;
      Pg1 := Pg2;
      Pg2 := Pg3;
    end;
  end;
end;

function TdxChartAxisViewInfo.IsNumeric: Boolean;
begin
  Result := Axis.IsNumeric;
end;

function TdxChartAxisViewInfo.IsTickInVisibleArea(const AAxisValue: Double): Boolean;
begin
  Result := (AAxisValue > MinAxisValue) and (AAxisValue < MaxAxisValue);
end;

function TdxChartAxisViewInfo.IsTickLabelsRotated: Boolean;
begin
  Result := not Axis.IsArgumentAxis;
end;

function TdxChartAxisViewInfo.LabelsAreaCanIntersectsWith(const R: TdxRectF): Boolean;
begin
  Result := FCalculationHelper.LabelsAreaCanIntersectsWith(R, Self);
end;

procedure TdxChartAxisViewInfo.Offset(const ADistance: TdxPointF);
var
  I: Integer;
begin
  if Axis.Title.ViewInfo.ActuallyVisible then
    Axis.Title.ViewInfo.Offset(ADistance);

  FAxisLineStart.Offset(ADistance);
  FAxisLineFinish.Offset(ADistance);
  FAxisLineRect.Offset(ADistance.X, ADistance.Y);

  if Axis.Ticks.MinorVisible then
    MinorTicks.Offset(ADistance);
  if Axis.Ticks.Visible then
    Ticks.Offset(ADistance);

  if Axis.ValueLabels.Visible then
    for I := 0 to Labels.Count - 1 do
      &Label[I].Offset(ADistance);

  if Math.IsZero(ADistance.X) then
    FLabelsAreaStart := FLabelsAreaStart + ADistance.Y
  else
    FLabelsAreaStart := FLabelsAreaStart + ADistance.X;

  if not FLabelsArea.IsEmpty then
    FLabelsArea.Offset(ADistance);

  inherited Offset(ADistance);
  UpdateBounds(Bounds, AvailableBounds);
end;

procedure TdxChartAxisViewInfo.UpdateBounds(const ABounds: TdxRectF);
begin
  inherited UpdateBounds(ABounds);
  CalculateViewpoint(Bounds);
end;

procedure TdxChartAxisViewInfo.TryMoveLabel(var ALabel: TdxChartAxisTickLabelViewInfo;
  ACompetingAxis: TdxChartCustomAxis; ACompetingSecondaryAxes: TdxChartSecondaryCustomAxes);

  function HasAnyOverlapping(const ANewBounds: TdxRectF; AAxisTick: TdxChartAxisTickViewInfo; AAxis: TdxChartCustomAxis): Boolean;
  begin
    Result := (ANewBounds.IntersectsWith(AAxis.ViewInfo.AxisLineRect) and not AAxis.ViewInfo.IncludesTickmark(AAxisTick)) or
      ALabel.IsOccupied(ANewBounds, AAxis, False);
  end;

  function HasAnyOverlappingWithCompetingAxes(const ANewBounds: TdxRectF; AAxisTick: TdxChartAxisTickViewInfo): Boolean;
  var
    I: Integer;
  begin
    Result := HasAnyOverlapping(ANewBounds, AAxisTick, ACompetingAxis);
    if not Result and (ACompetingSecondaryAxes <> nil) then
      for I := 0 to ACompetingSecondaryAxes.Count - 1 do
      begin
        Result := HasAnyOverlapping(ANewBounds, AAxisTick, ACompetingSecondaryAxes.Items[I].Axis);
        if Result then
          Break;
      end;
  end;

  function GetNewBounds(AAxisTick: TdxChartAxisTickViewInfo; ALabelAlignment: TdxAlignment): TdxRectF;
  begin
    Result := GetLabelBounds(AAxisTick, ALabelAlignment);
    if FCalculationHelper.IsHorizontal then  
      Result.Offset(0, ALabel.Bounds.Top - Result.Top)
    else
      Result.Offset(ALabel.Bounds.Left - Result.Left, 0);
    if ALabel.IsOccupied(ALabel.CalculateArea(Result), Self.Axis, True) or
       HasAnyOverlappingWithCompetingAxes(Result, AAxisTick) then
      Result.Empty;
  end;

  function SelectBestBounds(const R1, R2: TdxRectF): TdxRectF;
  begin
    if R1.IsEmpty or R1.IntersectsWith(ACompetingAxis.ViewInfo.LabelsArea) or
       ACompetingAxis.ViewInfo.LabelsAreaCanIntersectsWith(R1) then
      Result := R2
    else
      if R2.IsEmpty or R2.IntersectsWith(ACompetingAxis.ViewInfo.LabelsArea) or
         ACompetingAxis.ViewInfo.LabelsAreaCanIntersectsWith(R2) then
        Result := R1
      else
        Result := FCalculationHelper.SelectFarFromBorder(ALabel.AxisTick.Axis.ViewInfo, R1, R2);
  end;

var
  AAxisTick: TdxChartAxisTickViewInfo;
  ANearBounds, AFarBounds: TdxRectF;
begin
  AAxisTick := ALabel.AxisTick as TdxChartAxisTickViewInfo;
  ANearBounds := GetNewBounds(AAxisTick, TdxAlignment.Near);
  AFarBounds := GetNewBounds(AAxisTick, TdxAlignment.Far);
  ALabel.Visible := not (ANearBounds.IsEmpty and AFarBounds.IsEmpty);
  if ALabel.Visible then
    ALabel.SetBounds(SelectBestBounds(ANearBounds, AFarBounds), ALabel.VisibleBounds);
end;

procedure TdxChartAxisViewInfo.PrepareCalculation(ACanvas: TcxCustomCanvas);
var
  I: Integer;
  AAxisTick: TdxChartAxisTickViewInfo;
  ALabelsVisible: Boolean;
  ATickValueText: string;
  ADataValue: Double;
begin
  ViewData.Calculate;
  UpdateCalculationHelper;
  CalculateVisibleRange;

  FLabelsAreaTransversalSize := 0;
  FTitleOuterAreaSize := 0;

  ALabelsVisible := ValueLabels.Visible;
  SetTicksAndLabelsCount(ViewData.TickCount);
  for I := 0 to Ticks.Count - 1 do
  begin
    AAxisTick := Ticks[I];
    AAxisTick.AxisValue := RoundTo(ViewData.TickStart + ViewData.CalculatedStep * I, -ViewData.ScalePrecision);
    AAxisTick.InVisibleArea := IsTickInVisibleArea(AAxisTick.AxisValue);
    ADataValue := AAxisTick.DataValue;
    ATickValueText := ViewData.GetValueAsText(ADataValue);
    if Assigned(Axis.Axes.Diagram.OnGetAxisValueLabelDrawParameters) then
    begin
      if Axis.IsNumeric then
        RaiseGetAxisValueLabelDrawParametersEvent(ADataValue, ATickValueText)
      else if (ADataValue >= ViewData.GetMin) and (ADataValue <= ViewData.GetMax) then
        RaiseGetAxisValueLabelDrawParametersEvent(ATickValueText, ATickValueText);
    end;
    AAxisTick.&Label.CreateTextLayout(ACanvas);
    AAxisTick.&Label.Text := ATickValueText;
    AAxisTick.&Label.CalculateTextLayout;
    AAxisTick.&Label.Visible := ALabelsVisible and AAxisTick.InVisibleArea;

    FLabelsAreaTransversalSize := Max(FLabelsAreaTransversalSize, GetTransversalSize(AAxisTick.&Label.BoundsBox.Size));
  end;

  Bounds.Empty;
  Dirty := True;
end;

function TdxChartAxisViewInfo.GetLongitudinalSize(const ASize: TdxSizeF): Single;
begin
  Result := FCalculationHelper.GetLongitudinalSize(ASize);
end;

function TdxChartAxisViewInfo.GetTransversalSize(const ASize: TdxSizeF): Single;
begin
  Result := FCalculationHelper.GetTransversalSize(ASize);
end;

function TdxChartAxisViewInfo.GetSign: TValueSign;
begin
  Result := FCalculationHelper.GetSign;
end;

function TdxChartAxisViewInfo.GetFarTransversalValue(const R: TdxRectF): Single;
begin
  Result := FCalculationHelper.GetFarTransversalValue(R);
end;

function TdxChartAxisViewInfo.GetNearTransversalValue(const R: TdxRectF): Single;
begin
  Result := FCalculationHelper.GetNearTransversalValue(R);
end;

function TdxChartAxisViewInfo.GetTransversalOffsetDistance(AOffset: Single): TdxPointF;
begin
  Result := FCalculationHelper.GetTransversalOffsetDistance(AOffset);
end;

function TdxChartAxisViewInfo.IsCentered: Boolean;
begin
  Result := (FCalculationHelper = TdxChartAxisHorizontalCenterDirectionHelper) or
            (FCalculationHelper = TdxChartAxisVerticalCenterDirectionHelper);
end;

procedure TdxChartAxisViewInfo.RaiseGetAxisValueLabelDrawParametersEvent(const AAxisValue: Variant; var AText: string);
var
  AArgs: TdxChartGetAxisValueLabelDrawParametersEventArgs;
begin
  AArgs := TdxChartGetAxisValueLabelDrawParametersEventArgs.Create(Axis, AAxisValue, AText);
  try
    Axis.Axes.Diagram.DoGetAxisValueLabelDrawParameters(AArgs);
    AText := AArgs.Text;
  finally
    FreeAndNil(AArgs);
  end;
end;

procedure TdxChartAxisViewInfo.RecalculateLabelAreaTransversalSize;
begin
  FLabelsAreaTransversalSize := FCalculationHelper.GetLabelsAreaTransversalSize(Self);
end;

procedure TdxChartAxisViewInfo.ResolveOverlapping;
begin
  FCalculationHelper.ResolveOverlapping(Self);
end;

procedure TdxChartAxisViewInfo.SetAvailableBounds(const ABounds: TdxRectF; const AMakeDirty: Boolean);
begin
  Dirty := Dirty or AMakeDirty;
  FAvailableBounds := ABounds.DeflateToTRect;
end;

procedure TdxChartAxisViewInfo.SetBounds(const ABounds, AVisibleBounds: TdxRectF);
begin
  inherited SetBounds(ABounds, AVisibleBounds);
  CalculateViewpoint;
end;

procedure TdxChartAxisViewInfo.SetFarLongitudinalValue(var R: TdxRectF; AValue: Single);
begin
  FCalculationHelper.SetFarLongitudinalValue(R, AValue);
end;

procedure TdxChartAxisViewInfo.SetFarTransversalValue(var R: TdxRectF; AValue: Single);
begin
  FCalculationHelper.SetFarTransversalValue(R, AValue);
end;

procedure TdxChartAxisViewInfo.SetNearLongitudinalValue(var R: TdxRectF; AValue: Single);
begin
  FCalculationHelper.SetNearLongitudinalValue(R, AValue);
end;

procedure TdxChartAxisViewInfo.SetNearTransversalValue(var R: TdxRectF; AValue: Single);
begin
  FCalculationHelper.SetNearTransversalValue(R, AValue);
end;

procedure TdxChartAxisViewInfo.CalculateViewpoint;
begin
  CalculateViewpoint(Bounds);
end;

procedure TdxChartAxisViewInfo.CalculateViewpoint(const R: TdxRectF);
var
  ADirection: TValueSign;
  AOffset: Single;
begin
  FCalculationHelper.CalculateViewpoint(Axis, R, AOffset, ADirection);
  if IsVisibleRangeValid then
  begin
    FViewpointScaleFactor := ADirection / FAxisScaleFactor;
    FViewpointOffset := AOffset - FMinAxisValue * FViewpointScaleFactor;
  end
  else
  begin
    FViewpointOffset := AOffset;
    FViewpointScaleFactor := 0;
  end;
end;

procedure TdxChartAxisViewInfo.CalculateVisibleRange;
begin
  CalculateVisibleRange(VisibleAreaSize);
end;

function TdxChartAxisViewInfo.CanvasValueToAxisValue(
  const AValue: Single): Double;
begin
  if IsZero(FViewpointScaleFactor) then
    Result := FMinAxisValue
  else
    Result := (AValue - FViewpointOffset) / FViewpointScaleFactor;
end;

function TdxChartAxisViewInfo.CanvasValueToDataValue(const AValue: Single): Double;
begin
  if Axis.DataValueConverter <> nil then
    Result := Axis.DataValueConverter.AxisValueToDataValue(CanvasValueToAxisValue(AValue))
  else
    Result := CanvasValueToAxisValue(AValue);
end;

procedure TdxChartAxisViewInfo.CalculateVisibleRange(const AAxisSize: Single);
var
  ARange: TdxChartDataRange;
begin
  ARange := Axis.Range.VisibleRangeExtended;
  FMinAxisValue := ARange.Min;
  FMaxAxisValue := ARange.Max;

  if Axis.DataValueConverter <> nil then
  begin
    FMinAxisValue := Axis.DataValueConverter.DataValueToAxisValue(FMinAxisValue);
    FMaxAxisValue := Axis.DataValueConverter.DataValueToAxisValue(FMaxAxisValue);
  end;

  if IsZero(AAxisSize) then
    FAxisScaleFactor := 0
  else
    FAxisScaleFactor := (FMaxAxisValue - FMinAxisValue) / AAxisSize;

  FIsVisibleRangeValid := not IsZero(FAxisScaleFactor);
  CalculateViewpoint;
end;

function TdxChartAxisViewInfo.AxisValueToCanvasValue(const AValue: Double): Single;
begin
  Result := FViewpointOffset + AValue * FViewpointScaleFactor;
end;

function TdxChartAxisViewInfo.DataValueToCanvasValue(const AValue: Double): Single;
begin
  if Axis.DataValueConverter <> nil then
    Result := AxisValueToCanvasValue(Axis.DataValueConverter.DataValueToAxisValue(AValue))
  else
    Result := AxisValueToCanvasValue(AValue);
end;

function TdxChartAxisViewInfo.GetAppearance: TdxChartAxisAppearance;
begin
  Result := TdxChartAxisAppearance(inherited Appearance);
end;

function TdxChartAxisViewInfo.GetAxisBounds: TdxRectF;
begin
  Result := FCalculationHelper.GetAxisBounds(Self);
end;

function TdxChartAxisViewInfo.GetInterlaced(AIndex: Integer): TdxChartXYDiagramInterlacedViewInfo;
begin
  Result := TdxChartXYDiagramInterlacedViewInfo(FInterlacedItems.List[AIndex]);
end;

function TdxChartAxisViewInfo.GetLabel(AIndex: Integer): TdxChartAxisTickLabelViewInfo;
begin
  Result := Ticks[AIndex].&Label;
end;

procedure TdxChartAxisViewInfo.SetTicksAndLabelsCount(ACount: Integer);
var
  I: Integer;
begin
  FTicks.Clear;
  FTicks.EnsureCapacity(ACount);
  FLabels.Clear;
  FLabels.Capacity := ACount;
  for I := 0 to ACount - 1 do
    FLabels.Add(TdxChartAxisTickLabelViewInfo.Create(Ticks.Add));
end;

function TdxChartAxisViewInfo.GetLabelPadding: Single;
begin
  Result := Axis.ValueLabels.Appearance.Margins.All;
end;

function TdxChartAxisViewInfo.GetLabelRectStart(ATickCanvasValue, ATextLongitudinalSize: Single; ALabelAlignment: TdxAlignment): Single;
begin
  Result := FCalculationHelper.GetLabelRectStart(Self, ATickCanvasValue, ATextLongitudinalSize, ALabelAlignment);
end;

function TdxChartAxisViewInfo.GetValueLabels: TdxChartAxisValueLabels;
begin
  Result := Axis.ValueLabels;
end;

function TdxChartAxisViewInfo.GetViewData: TdxChartAxisViewData;
begin
  Result := Axis.ViewData;
end;

procedure TdxChartAxisViewInfo.UpdateCalculationHelper;
begin
  FCalculationHelper := Axis.GetViewInfoCalculationHelper;
end;

procedure TdxChartAxisViewInfo.UpdateGridlinesAndInterlacedItems(const APlotArea: TdxRectF);
var
  I: Integer;
begin
  CalculateGridlinesStartAndFinish(APlotArea);
  for I := 0 to Gridlines.Count - 1 do
    FCalculationHelper.UpdateGridline(Self, Gridlines[I], APlotArea);
  for I := 0 to MinorGridlines.Count - 1 do
    FCalculationHelper.UpdateGridline(Self, MinorGridlines[I], APlotArea);
  for I := 0 to InterlacedItems.Count - 1 do
    FCalculationHelper.UpdateInterlaced(Self, Interlaced[I], APlotArea);
  MinorGridlines.CalculateBounds(APlotArea);
  Gridlines.CalculateBounds(APlotArea);
end;

procedure TdxChartAxisViewInfo.UpdateActualSecondaryAxisIndent(AValue: Single);
begin
  FActualSecondaryAxisIndent := AValue;
end;

procedure TdxChartAxisViewInfo.UpdateLabelsArea;
var
  I: Integer;
  ALabel: TdxChartAxisTickLabelViewInfo;
begin
  FLabelsArea.Empty;
  if Axis.ValueLabels.Visible then
    for I := 0 to Labels.Count - 1 do
    begin
      ALabel := &Label[I];
      if ALabel.Visible then
        if FLabelsArea.IsEmpty then
          FLabelsArea := ALabel.AreaBox
        else
          FLabelsArea.Union(ALabel.AreaBox);
    end;
end;

{ TdxChartAxisAppearance }

destructor TdxChartAxisAppearance.Destroy;
begin
  FreeHandles;
  inherited Destroy;
end;

function TdxChartAxisAppearance.DefaultBorderThickness: Single;
begin
  Result := DefaultThickness;
end;

function TdxChartAxisAppearance.DefaultParentBackground: Boolean;
begin
  Result := False;
end;

function TdxChartAxisAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  case AIndex of
    PenColorIndex:
      Result := ColorScheme.DiagramXY.AxisColor;
    ColorIndex, Color2Index:
      Result := ColorScheme.DiagramXY.BackgroundInterlacedColor;
  else
    Result := inherited GetActualColor(AIndex);
  end;
end;

procedure TdxChartAxisAppearance.FreeHandles;
begin
  FreeAndNil(FActualTickPen);
  FreeAndNil(FActualMinorTickPen);
end;

function TdxChartAxisAppearance.GetAxis: TdxChartCustomAxis;
begin
  Result := TdxChartCustomAxis(Owner);
end;

function TdxChartAxisAppearance.GetColor: TdxAlphaColor;
begin
  Result := PenColor;
end;

function TdxChartAxisAppearance.GetThickness: Single;
begin
  Result := StrokeOptions.Width;
end;

function TdxChartAxisAppearance.GetInterlacedFillOptions: TdxFillOptions;
begin
  Result := inherited FillOptions;
end;

function TdxChartAxisAppearance.IsThicknessStored: Boolean;
begin
  Result := not SameValue(Thickness, DefaultThickness);
end;

function TdxChartAxisAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartAxisAppearance.HasStrokeOptions: Boolean;
begin
  Result := True;
end;

procedure TdxChartAxisAppearance.UpdateActualValues(ACanvas: TcxCustomCanvas);
var
  AChanges: TAppearanceChanges;
begin
  AChanges := Changes;
  inherited UpdateActualValues(ACanvas);
  if AChanges <> [] then
  begin
    FreeHandles;
    FActualTickPen := CreateSolidPen(ACanvas, ActualPenColor, Axis.Ticks.Thickness);
    FActualMinorTickPen := CreateSolidPen(ACanvas, ActualPenColor, Axis.Ticks.MinorThickness);
  end;
end;

procedure TdxChartAxisAppearance.SetColor(AValue: TdxAlphaColor);
begin
  PenColor := AValue;
end;

procedure TdxChartAxisAppearance.SetInterlacedFillOptions(AValue: TdxFillOptions);
begin
  InterlacedFillOptions.Assign(AValue);
end;

procedure TdxChartAxisAppearance.SetThickness(AValue: Single);
begin
  StrokeOptions.Width := AValue;
end;

{ TdxChartAxisTitle }

procedure TdxChartAxisTitle.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartAxisTitle then
    FPosition := TdxChartAxisTitle(Source).Position;
end;

function TdxChartAxisTitle.GetActualDockPosition: TdxChartTitlePosition;
begin
  Result := Axis.ViewInfo.GetActualTitlePosition;
end;

function TdxChartAxisTitle.GetAxis: TdxChartCustomAxis;
begin
  Result := Owner as TdxChartCustomAxis;
end;

class function TdxChartAxisTitle.GetHitCode: TdxChartHitCode;
begin
  Result := TdxChartHitCode.AxisTitle;
end;

function TdxChartAxisTitle.GetOwnerComponent: TComponent;
begin
  Result := Axis.Diagram;
end;

procedure TdxChartAxisTitle.SetPosition(AValue: TdxChartAxisTitlePosition);
begin
  if FPosition <> AValue then
  begin
    FPosition := AValue;
    LayoutChanged;
  end;
end;

{ TdxNumericScaleOptions }

procedure TdxChartAxisNumericScaleOptions.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartAxisNumericScaleOptions then
  begin
    FOffset := TdxChartAxisNumericScaleOptions(Source).Offset;
    FStep := TdxChartAxisNumericScaleOptions(Source).Step;
  end;
end;

function TdxChartAxisNumericScaleOptions.IsStepStored: Boolean;
begin
  Result := not IsZero(Step);
end;

function TdxChartAxisNumericScaleOptions.IsOffsetStored: Boolean;
begin
  Result := not IsZero(Offset);
end;

procedure TdxChartAxisNumericScaleOptions.SetOffset(AValue: Double);
begin
  if not SameValue(Offset, AValue) then
  begin
    FOffset := AValue;
    Changed;
  end;
end;

procedure TdxChartAxisNumericScaleOptions.SetStep(AValue: Double);
begin
  if not SameValue(Step, AValue) then
  begin
    FStep := AValue;
    Changed;
  end;
end;

{ TdxChartAxisTicks }

constructor TdxChartAxisTicks.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FCrossKind := TdxChartAxisTicksCrossKind.Outside;
  FLength := DefaultLength;
  FThickness := DefaultThickness;
  FVisible := True;
  FMinorCrossKind := TdxChartAxisTicksCrossKind.Outside;
  FMinorLength := DefaultMinorLength;
  FMinorThickness := DefaultThickness;
  FMinorVisible := True;
end;

procedure TdxChartAxisTicks.DoAssign(Source: TPersistent);
var
  ASource: TdxChartAxisTicks;
begin
  inherited DoAssign(Source);
  if Source is TdxChartAxisTicks then
  begin
    ASource := TdxChartAxisTicks(Source);
    CrossKind := ASource.CrossKind;
    Length := ASource.Length;
    Thickness := ASource.Thickness;
    Visible := ASource.Visible;
    MinorCrossKind := ASource.MinorCrossKind;
    MinorLength := ASource.MinorLength;
    MinorThickness := ASource.MinorThickness;
    MinorVisible := ASource.MinorVisible;
  end;
end;

procedure TdxChartAxisTicks.ChangeScale(M, D: Integer);
begin
  FLength := dxScale(FLength, M, D);
  FThickness := dxScale(FThickness, M, D);
  FMinorLength := dxScale(FMinorLength, M, D);
  FMinorThickness := dxScale(FMinorThickness, M, D);
end;

procedure TdxChartAxisTicks.DoChanged;
begin
  Axis.Appearance.Changed(Axis.Appearance.SizeChanges);
end;

function TdxChartAxisTicks.GetAxis: TdxChartCustomAxis;
begin
  Result := TdxChartCustomAxis(Owner);
end;

function TdxChartAxisTicks.IsLengthStored: Boolean;
begin
  Result := not SameValue(FLength, DefaultLength);
end;

function TdxChartAxisTicks.IsThicknessStored: Boolean;
begin
  Result := not SameValue(FThickness, DefaultThickness);
end;

procedure TdxChartAxisTicks.SetCrossKind(AValue: TdxChartAxisTicksCrossKind);
begin
  if FCrossKind <> AValue then
  begin
    FCrossKind := AValue;
    Changed;
  end;
end;

procedure TdxChartAxisTicks.SetLabelAlignment(AValue: TdxAlignment);
begin
  if AValue <> LabelAlignment then
  begin
    FLabelAlignment := AValue;
    Changed;
  end;
end;

procedure TdxChartAxisTicks.SetLength(AValue: Single);
begin
  AValue := Max(AValue, 1);
  if not SameValue(FLength, AValue) then
  begin
    FLength := AValue;
    Changed;
  end;
end;

procedure TdxChartAxisTicks.SetThickness(AValue: Single);
begin
  AValue := Max(AValue, 1);
  if not SameValue(FThickness, AValue) then
  begin
    FThickness := AValue;
    Changed;
  end;
end;

procedure TdxChartAxisTicks.SetVisible(AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Changed;
  end;
end;

function TdxChartAxisTicks.IsMinorLengthStored: Boolean;
begin
  Result := not SameValue(FMinorLength, DefaultMinorLength);
end;

function TdxChartAxisTicks.IsMinorThicknessStored: Boolean;
begin
  Result := not SameValue(FMinorThickness, DefaultThickness);
end;

procedure TdxChartAxisTicks.SetMinorCrossKind(AValue: TdxChartAxisTicksCrossKind);
begin
  if FMinorCrossKind <> AValue then
  begin
    FMinorCrossKind := AValue;
    Changed;
  end;
end;

procedure TdxChartAxisTicks.SetMinorLength(AValue: Single);
begin
  AValue := Max(AValue, 1);
  if not SameValue(FMinorLength, AValue) then
  begin
    FMinorLength := AValue;
    Changed;
  end;
end;

procedure TdxChartAxisTicks.SetMinorThickness(AValue: Single);
begin
  AValue := Max(AValue, 1);
  if not SameValue(FMinorThickness, AValue) then
  begin
    FMinorThickness := AValue;
    Changed;
  end;
end;

procedure TdxChartAxisTicks.SetMinorVisible(AValue: Boolean);
begin
  if FMinorVisible <> AValue then
  begin
    FMinorVisible := AValue;
    Changed;
  end;
end;

{ TdxChartAxisValueLabelsAppearance }

function TdxChartAxisValueLabelsAppearance.DefaultParentBackground: Boolean;
begin
  Result := False;
end;

procedure TdxChartAxisValueLabelsAppearance.UpdateActualValues(ACanvas: TcxCustomCanvas);
begin
  inherited UpdateActualValues(ACanvas);
end;

{ TdxChartAxisValueLabels }

constructor TdxChartAxisValueLabels.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FPosition := TdxChartAxisValueLabelPosition.Outside;
  Appearance.Margins.All := DefaultMargins;
end;

function TdxChartAxisValueLabels.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartAxisValueLabelsAppearance.Create(Self);
end;

procedure TdxChartAxisValueLabels.DoAssign(Source: TPersistent);
var
  ASource: TdxChartAxisValueLabels;
begin
  inherited DoAssign(Source);
  if Source is TdxChartAxisValueLabels then
  begin
    ASource := TdxChartAxisValueLabels(Source);
    FPosition := ASource.Position;
  end;
end;

function TdxChartAxisValueLabels.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  case AIndex of
    TdxChartAxisValueLabelsAppearance.BorderColorIndex, TdxChartAxisValueLabelsAppearance.PenColorIndex:
      Result := Appearance.ColorScheme.DiagramXY.LabelsColor;
    TdxChartAxisValueLabelsAppearance.ColorIndex:
      Result := Appearance.ColorScheme.DiagramXY.BackgroundColor;
    TdxChartAxisValueLabelsAppearance.TextColorIndex:
      Result := Appearance.ColorScheme.DiagramXY.TextColor;
  else
    Result := inherited GetActualColor(AIndex);
  end;
end;

function TdxChartAxisValueLabels.GetAppearance: TdxChartAxisValueLabelsAppearance;
begin
  Result := TdxChartAxisValueLabelsAppearance(inherited Appearance)
end;

function TdxChartAxisValueLabels.GetAxis: TdxChartCustomAxis;
begin
  Result := TdxChartCustomAxis(Owner);
end;

function TdxChartAxisValueLabels.GetDefaultResolveOverlappingIndent: Single;
begin
  Result := DefaultResolveOverlappingIndent;
end;

procedure TdxChartAxisValueLabels.SetAppearance(AValue: TdxChartAxisValueLabelsAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartAxisValueLabels.SetPosition(AValue: TdxChartAxisValueLabelPosition);
begin
  if FPosition <> AValue then
  begin
    FPosition := AValue;
    LayoutChanged;
  end;
end;

{ TdxChartAxisGridlines }

constructor TdxChartAxisGridlines.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FMinorGridlineStrokeOptions := TdxStrokeOptions.Create(Self, DefaultMinorGridlineColor);
  FMinorGridlineStrokeOptions.OnChange := StrokeOptions.OnChange;
  FVisible := Axis.IsGridlinesVisibleByDefault;
  FMinorVisible := Axis.IsMinorGridlinesVisibleByDefault;
end;

destructor TdxChartAxisGridlines.Destroy;
begin
  FreeAndNil(FMinorGridlineStrokeOptions);
  inherited Destroy;
end;

procedure TdxChartAxisGridlines.ChangeScaleCore(M, D: Integer);
begin
  inherited ChangeScaleCore(M, D);
  FMinorGridlineStrokeOptions.ChangeScale(M, D);
end;

function TdxChartAxisGridlines.DefaultMinorGridlineColor: TdxAlphaColor;
begin
  Result := GetActualColor(MinorGridlineColorIndex);
end;

procedure TdxChartAxisGridlines.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartAxisGridlines then
  begin
    FMinorGridlineStrokeOptions.Assign(TdxChartAxisGridlines(Source).MinorGridlineStrokeOptions);
    FVisible := TdxChartAxisGridlines(Source).Visible;
    FMinorVisible := TdxChartAxisGridlines(Source).MinorVisible;
  end;
end;

function TdxChartAxisGridlines.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  case AIndex of
    GridlineColorIndex, PenColorIndex:
      Result := ColorScheme.DiagramXY.GridlinesColor;
    MinorGridlineColorIndex:
      Result := ColorScheme.DiagramXY.MinorGridlinesColor;
  else
    Result := inherited GetActualColor(AIndex);
  end;
end;

function TdxChartAxisGridlines.GetColorCount: Integer;
begin
  Result := MinorGridlineColorIndex + 1;
end;

function TdxChartAxisGridlines.HasStrokeOptions: Boolean;
begin
  Result := True;
end;

procedure TdxChartAxisGridlines.UpdateActualValues(ACanvas: TcxCustomCanvas);
var
  AChanges: TAppearanceChanges;
begin
  AChanges := Changes;
  if Changes = [] then Exit;
  inherited UpdateActualValues(ACanvas);
  if TAppearanceChange.Stroke in AChanges then
    FActualMinorGridlinePen := MinorGridlineStrokeOptions.GetHandle(ACanvas);
end;

function TdxChartAxisGridlines.GetAxis: TdxChartCustomAxis;
begin
  Result := TdxChartCustomAxis(Owner);
end;

function TdxChartAxisGridlines.GetColor: TdxAlphaColor;
begin
  Result := StrokeOptions.Color;
end;

function TdxChartAxisGridlines.GetMinorColor: TdxAlphaColor;
begin
  Result := MinorGridlineStrokeOptions.Color;
end;

function TdxChartAxisGridlines.GetMinorStyle: TdxStrokeStyle;
begin
  Result := MinorGridlineStrokeOptions.Style;
end;

function TdxChartAxisGridlines.GetMinorThickness: Single;
begin
  Result := MinorGridlineStrokeOptions.Width;
end;

function TdxChartAxisGridlines.GetStyle: TdxStrokeStyle;
begin
  Result := StrokeOptions.Style;
end;

function TdxChartAxisGridlines.GetThickness: Single;
begin
  Result := StrokeOptions.Width;
end;

function TdxChartAxisGridlines.IsMinorThicknessStored: Boolean;
begin
  Result := not SameValue(MinorThickness, DefaultBorderThickness);
end;

function TdxChartAxisGridlines.IsMinorVisibleStored: Boolean;
begin
  Result := FMinorVisible <> Axis.IsMinorGridlinesVisibleByDefault;
end;

function TdxChartAxisGridlines.IsThicknessStored: Boolean;
begin
  Result := not SameValue(Thickness, DefaultBorderThickness);
end;

function TdxChartAxisGridlines.IsVisibleStored: Boolean;
begin
  Result := FVisible <> Axis.IsGridlinesVisibleByDefault;
end;

procedure TdxChartAxisGridlines.SetColor(AValue: TdxAlphaColor);
begin
  StrokeOptions.Color := AValue;
end;

procedure TdxChartAxisGridlines.SetMinorColor(AValue: TdxAlphaColor);
begin
  MinorGridlineStrokeOptions.Color := AValue;
end;

procedure TdxChartAxisGridlines.SetMinorStyle(AValue: TdxStrokeStyle);
begin
  MinorGridlineStrokeOptions.Style := AValue;
end;

procedure TdxChartAxisGridlines.SetMinorThickness(AValue: Single);
begin
  MinorGridlineStrokeOptions.Width := Max(1, AValue);
end;

procedure TdxChartAxisGridlines.SetMinorVisible(AValue: Boolean);
begin
  if FMinorVisible <> AValue then
  begin
    FMinorVisible := AValue;
    Changed(TAppearanceChange.Stroke);
  end;
end;

procedure TdxChartAxisGridlines.SetStyle(AValue: TdxStrokeStyle);
begin
  StrokeOptions.Style := AValue;
end;

procedure TdxChartAxisGridlines.SetThickness(AValue: Single);
begin
  StrokeOptions.Width := Max(1, AValue);
end;

procedure TdxChartAxisGridlines.SetVisible(AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Changed(TAppearanceChange.Stroke);
  end;
end;

{ TdxChartCrosshairAxisLabelAppearance }

function TdxChartCrosshairAxisLabelAppearance.DefaultPadding: Integer;
begin
  Result := 0;
end;

function TdxChartCrosshairAxisLabelAppearance.DefaultParentBackground: Boolean;
begin
  Result := False;
end;

function TdxChartCrosshairAxisLabelAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  if AIndex = ColorIndex then
  begin
    if GetAxis.IsArgumentAxis then
      Result := Chart.ToolTips.CrosshairOptions.ArgumentLines.Appearance.StrokeOptions.Color
    else
      Result := Chart.ToolTips.CrosshairOptions.ValueLines.Appearance.StrokeOptions.Color;
    if Result = TdxAlphaColors.Default then
      Result := TdxChartCrosshairLineAppearance.DefaultCrosshairLineColor;
  end
  else if AIndex = TextColorIndex then
    Result := TdxAlphaColors.White
  else
    Result := inherited GetActualColor(AIndex);
end;

function TdxChartCrosshairAxisLabelAppearance.GetActualPadding: TRect;
begin
  Result := TdxChartVisualElementAppearanceAccess(Parent).ActualPadding;
  Result.Left := Result.Left + TdxChartAxisTickLabelViewInfo.GDIToGDIPlusTextWidthCompensation div 2;
  Result.Right := Result.Right + TdxChartAxisTickLabelViewInfo.GDIToGDIPlusTextWidthCompensation - TdxChartAxisTickLabelViewInfo.GDIToGDIPlusTextWidthCompensation div 2;
end;

function TdxChartCrosshairAxisLabelAppearance.GetAxis: TdxChartCustomAxis;
begin
  Result := TdxChartAxisValueLabels(TdxChartCrosshairAxisLabels(Owner).Owner).Axis;
end;

function TdxChartCrosshairAxisLabelAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartCrosshairAxisLabelAppearance.HasFontOptions: Boolean;
begin
  Result := True;
end;

procedure TdxChartCrosshairAxisLabelAppearance.UpdateActualValues(ACanvas: TcxCustomCanvas);
begin
  if TdxChartVisualElementAppearance.TAppearanceChange.Fill in Changes then
    FillOptions.FlushCache;
  inherited UpdateActualValues(ACanvas);
end;

function TdxChartCrosshairAxisLabelAppearance.GetFontOptions: TdxChartVisualElementFontOptions;
begin
  Result := TdxChartVisualElementFontOptions(inherited FontOptions);
end;

procedure TdxChartCrosshairAxisLabelAppearance.SetFontOptions(AValue: TdxChartVisualElementFontOptions);
begin
  inherited FontOptions := AValue;
end;

{ TdxChartAxisCrosshairLabel }

destructor TdxChartCrosshairAxisLabels.Destroy;
begin
  TdxChartTextFormatController.Release(FTextFormatter);
  inherited;
end;

function TdxChartCrosshairAxisLabels.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartCrosshairAxisLabelAppearance.Create(Self);
end;

procedure TdxChartCrosshairAxisLabels.DoAssign(Source: TPersistent);
var
  ALabels: TdxChartCrosshairAxisLabels;
begin
  inherited DoAssign(Source);
  if Safe.Cast(Source, TdxChartCrosshairAxisLabels, ALabels) then
  begin
    Appearance := ALabels.Appearance;
    TextFormat := ALabels.TextFormat;
  end;
end;

function TdxChartCrosshairAxisLabels.GetAppearance: TdxChartCrosshairAxisLabelAppearance;
begin
  Result := TdxChartCrosshairAxisLabelAppearance(inherited Appearance);
end;

function TdxChartCrosshairAxisLabels.GetTextFormat: TdxChartTextFormat;
begin
  Result := TdxChartTextFormatController.GetFormat(FTextFormatter);
end;

procedure TdxChartCrosshairAxisLabels.SetAppearance(AValue: TdxChartCrosshairAxisLabelAppearance);
begin
  inherited Appearance := AValue;
end;

procedure TdxChartCrosshairAxisLabels.SetTextFormat(AValue: TdxChartTextFormat);
begin
  if AValue = '' then
    TdxChartTextFormatController.Release(FTextFormatter)
  else
    TdxChartTextFormatController.Add(AValue, FTextFormatter);
end;

{ TdxChartCustomAxis }

function TdxChartCustomAxis.GetViewInfo: TdxChartAxisViewInfo;
begin
  Result := TdxChartAxisViewInfo(inherited ViewInfo);
end;

constructor TdxChartCustomAxis.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  SetDefaultAxisAlignment;
  FViewData := CreateViewData;
  FGridlines := TdxChartAxisGridlines.Create(Self);
  FTicks := TdxChartAxisTicks.Create(Self);
  FValueLabels := TdxChartAxisValueLabels.Create(Self);
  FLogarithmicBase := DefaultLogarithmicBase;
  FMinorCount := GetDefaultMinorCount;
  FNumericScaleOptions := TdxChartAxisNumericScaleOptions.Create(Self);
  FRange := TdxChartRange.Create(Self);
  FTitle := TdxChartAxisTitle.Create(Self);
  FCrosshairLabels := TdxChartCrosshairAxisLabels.Create(FValueLabels);
end;

destructor TdxChartCustomAxis.Destroy;
begin
  FreeAndNil(FCrosshairLabels);
  FreeAndNil(FTitle);
  FreeAndNil(FRange);
  FreeAndNil(FNumericScaleOptions);
  FreeAndNil(FValueLabels);
  FreeAndNil(FTicks);
  FreeAndNil(FGridlines);
  FreeAndNil(FViewData);
  inherited Destroy;
end;

procedure TdxChartCustomAxis.BiDiModeChanged;
begin
  inherited BiDiModeChanged;
  Title.BiDiModeChanged;
end;

procedure TdxChartCustomAxis.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  DefaultSecondaryAxisIndent := dxScale(DefaultSecondaryAxisIndent, M, D);
  ValueLabels.ChangeScale(M, D);
  Ticks.ChangeScale(M, D);
end;
function TdxChartCustomAxis.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartAxisAppearance.Create(Self);
end;

function TdxChartCustomAxis.CreateViewInfo: TdxChartVisualElementCustomViewInfo;
begin
  Result := TdxChartAxisViewInfo.Create(Self);
end;

procedure TdxChartCustomAxis.DoAssign(Source: TPersistent);
var
  ASource: TdxChartCustomAxis;
begin
  inherited DoAssign(Source);
  if Source is TdxChartCustomAxis then
  begin
    ASource := TdxChartCustomAxis(Source);
    FAlignment := ASource.Alignment;
    Gridlines := ASource.Gridlines;
    NumericScaleOptions := ASource.NumericScaleOptions;
    Ticks := ASource.Ticks;
    ValueLabels := ASource.ValueLabels;
    Title := ASource.Title;
    Range := ASource.Range;
    Appearance := ASource.Appearance;
    FInterlaced := ASource.Interlaced;
    FLogarithmic := ASource.Logarithmic;
    FLogarithmicBase := ASource.LogarithmicBase;
    FMinorCount := ASource.MinorCount;
    FReverse := ASource.Reverse;
  end;
end;

function TdxChartCustomAxis.GetChart: TdxChart;
begin
  Result := Diagram.Chart;
end;

function TdxChartCustomAxis.GetParentElement: IdxChartVisualElement;
begin
  Result := Diagram;
end;

function TdxChartCustomAxis.GetViewInfoCalculationHelper: TdxChartAxisViewInfoCalculationHelperClass;

  function CanUseZeroAlignedCenterHelper(AOrthogonalAxis: TdxChartCustomAxis): Boolean;
  begin
    Result := SameValue(Abs(AOrthogonalAxis.ViewData.TickStart), Abs(AOrthogonalAxis.ViewData.TickFinish));
  end;

  function CanUseZeroAlignedNearHelper(AOrthogonalAxis: TdxChartCustomAxis): Boolean;
  var
    AVisibleRange: TdxChartDataRange;
  begin
    AVisibleRange := AOrthogonalAxis.Range.VisibleRangeExtended;
    Result := (AVisibleRange.Min > 0) or (Abs(AVisibleRange.Min) < AVisibleRange.Max);
  end;

const
  HorizontalFarHelpers: array[Boolean] of TdxChartAxisViewInfoCalculationHelperClass =
    (TdxChartAxisHorizontalFarDirectionHelper, TdxChartAxisHorizontalNearDirectionHelper);
  HorizontalNearHelpers: array[Boolean] of TdxChartAxisViewInfoCalculationHelperClass =
    (TdxChartAxisHorizontalNearDirectionHelper, TdxChartAxisHorizontalFarDirectionHelper);

  VerticalFarHelpers: array[Boolean] of TdxChartAxisViewInfoCalculationHelperClass =
    (TdxChartAxisVerticalFarDirectionHelper, TdxChartAxisVerticalNearDirectionHelper);
  VerticalNearHelpers: array[Boolean] of TdxChartAxisViewInfoCalculationHelperClass =
    (TdxChartAxisVerticalNearDirectionHelper, TdxChartAxisVerticalFarDirectionHelper);

var
  AOrthogonalAxis: TdxChartCustomAxis;
begin
  if IsArgumentAxis = Diagram.Rotated then
  begin  
    if IsNearAlignment then
      Result := TdxChartAxisVerticalNearDirectionHelper
    else if IsFarAlignment then
      Result := TdxChartAxisVerticalFarDirectionHelper
    else if not IsZeroAlignment then 
      Result := TdxChartAxisVerticalCenterDirectionHelper
    else
    begin
      AOrthogonalAxis := GetOrthogonalAxis;
      AOrthogonalAxis.ViewData.Calculate;
      if CanUseZeroAlignedCenterHelper(AOrthogonalAxis) then
        Result := TdxChartAxisVerticalCenterDirectionHelper
      else if CanUseZeroAlignedNearHelper(AOrthogonalAxis) then
        Result := VerticalNearHelpers[GetOrthogonalAxis.Reverse]
      else
        Result := VerticalFarHelpers[GetOrthogonalAxis.Reverse];
    end;
  end
  else  
    if IsNearAlignment then
      Result := TdxChartAxisHorizontalNearDirectionHelper
    else if IsFarAlignment then
      Result := TdxChartAxisHorizontalFarDirectionHelper
    else if not IsZeroAlignment then 
      Result := TdxChartAxisHorizontalCenterDirectionHelper
    else
    begin
      AOrthogonalAxis := GetOrthogonalAxis;
      AOrthogonalAxis.ViewData.Calculate;
      if CanUseZeroAlignedCenterHelper(AOrthogonalAxis) then
        Result := TdxChartAxisHorizontalCenterDirectionHelper
      else if CanUseZeroAlignedNearHelper(AOrthogonalAxis) then
        Result := HorizontalNearHelpers[GetOrthogonalAxis.Reverse]
      else
        Result := HorizontalFarHelpers[GetOrthogonalAxis.Reverse];
    end;
end;

function TdxChartCustomAxis.GetScrollPos: Integer;
var
  AFactor: Double;
  AReverse: Boolean;
begin
  if SameValue(Range.VisibleRangeExtended.Range, Range.WholeRangeExtended.Range) then
    Exit(0);
  if IsZero(Range.VisibleRangeExtended.Range) then
    Exit(0);
  AFactor := ViewInfo.VisibleAreaSize / Range.VisibleRangeExtended.Range;
  Result := Trunc(AFactor * (Range.VisibleRangeExtended.Min - Range.WholeRangeExtended.Min));
  AReverse := IsScrollableReverse;
  if AReverse then
    Result := Trunc(AFactor * Range.WholeRangeExtended.Range - ViewInfo.VisibleAreaSize - Result);
end;

function TdxChartCustomAxis.IsScrollableReverse: Boolean;
var
  AIsVertical: Boolean;
begin
  AIsVertical := InheritsFrom(TdxChartAxisY) xor ViewData.Axis.Diagram.Rotated;
  Result := Reverse xor AIsVertical;
end;

function TdxChartCustomAxis.IsScrollBarEnabled: Boolean;
begin
  Result := False;
end;

procedure TdxChartCustomAxis.InitScrollbarData(AScrollBarData: TcxScrollBarData);
var
  ADelta: Double;
  AReverse: Boolean;
begin
  AScrollbarData.Min := 0;
  if CompareValue(Range.VisibleRangeExtended.Range, 0) = GreaterThanValue then
  begin
    ADelta := ViewInfo.VisibleAreaSize / Range.VisibleRangeExtended.Range;
    AScrollbarData.SmallChange := Max(1, Round(ViewInfo.MinorTicks.Interval));
    AScrollbarData.Max := Trunc(ADelta * Range.WholeRangeExtended.Range);
    AScrollbarData.Position := Trunc(ADelta * (Range.VisibleRangeExtended.Min - Range.WholeRangeExtended.Min));
    AReverse := IsScrollableReverse;
    AScrollbarData.LargeChange := Trunc(ViewInfo.VisibleAreaSize);
    if AReverse then
      AScrollbarData.Position := AScrollbarData.Max - AScrollbarData.LargeChange - AScrollbarData.Position;
    AScrollbarData.Visible := IsScrollBarEnabled and (Range.WholeRangeExtended.Range > Range.VisibleRangeExtended.Range);
  end
  else
  begin
    AScrollbarData.SmallChange := 1;
    AScrollbarData.Max := 0;
    AScrollbarData.LargeChange := 1;
    AScrollbarData.Visible := False;
  end;
  AScrollbarData.AllowShow := AScrollbarData.Visible;
  AScrollbarData.AllowHide := False;
end;

procedure TdxChartCustomAxis.ScrollContent(AScrollCode: TScrollCode; AScrollPos: Integer; out ARangeChanged: Boolean);
var
  ADelta: Double;
  APosition: Integer;
  AReverse: Boolean;
begin
  ARangeChanged := False;
  if (AScrollCode = scEndScroll) or SameValue(Range.VisibleRangeExtended.Range, Range.WholeRangeExtended.Range) then
    Exit;
  ADelta := ViewInfo.VisibleAreaSize / Range.VisibleRangeExtended.Range;
  APosition := Trunc(ADelta * (Range.VisibleRangeExtended.Min - Range.WholeRangeExtended.Min));
  AReverse := IsScrollableReverse;
  if AReverse then
    APosition := Trunc(ADelta * Range.WholeRangeExtended.Range - ViewInfo.VisibleAreaSize - APosition);
  ViewData.OffsetVisualRange(IfThen(AReverse, -1, 1) * (AScrollPos - APosition) / ADelta, ARangeChanged);
end;

function TdxChartCustomAxis.GetAppearance: TdxChartAxisAppearance;
begin
  Result := TdxChartAxisAppearance(inherited Appearance);
end;

procedure TdxChartCustomAxis.SetAppearance(AValue: TdxChartAxisAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartCustomAxis.SetCrosshairLabels(AValue: TdxChartCrosshairAxisLabels);
begin
  FCrosshairLabels.Assign(AValue);
end;

function TdxChartCustomAxis.CreateViewData: TdxChartAxisViewData;
begin
  Result := TdxChartAxisViewData.Create(Self);
end;

function TdxChartCustomAxis.GetAxes: TdxChartAxes;
begin
  Result := TdxChartAxes(Owner);
end;

procedure TdxChartCustomAxis.GetDataTypes(var AValueType, AArgumentType: TVarType);
var
  I: Integer;
begin
  AValueType := varEmpty;
  AArgumentType := varEmpty;
  I := 0;
  while I < Diagram.ViewData.GroupCount do
  begin
    TdxChartXYDiagramSeriesGroup(Diagram.ViewData.Groups[I]).GetDataTypes(AValueType, AArgumentType);
    Inc(I);
  end;
end;

function TdxChartCustomAxis.GetDiagram: TdxChartXYDiagram;
begin
  Result := TdxChartXYDiagram(Axes.Owner);
end;

function TdxChartCustomAxis.GetValueType: TVarType;
var
  AArgumentType: TVarType;
begin
  GetDataTypes(Result, AArgumentType);
end;

function TdxChartCustomAxis.GetStep: Double;
begin
  Result := NumericScaleOptions.Step;
end;

function TdxChartCustomAxis.GetTickOffset: Double;
begin
  Result := NumericScaleOptions.Offset;
end;

function TdxChartCustomAxis.IsFarAlignment: Boolean;
begin
  Result := Alignment = TdxChartAxisAlignment.Far;
end;

function TdxChartCustomAxis.IsGridlinesVisibleByDefault: Boolean;
begin
  Result := False;
end;

function TdxChartCustomAxis.IsLogarithmicBaseStored: Boolean;
begin
  Result := not SameValue(FLogarithmicBase, DefaultLogarithmicBase);
end;

function TdxChartCustomAxis.IsMinorCountStored: Boolean;
begin
  Result := FMinorCount <> GetDefaultMinorCount;
end;

function TdxChartCustomAxis.IsMinorGridlinesVisibleByDefault: Boolean;
begin
  Result := False;
end;

function TdxChartCustomAxis.IsNearAlignment: Boolean;
begin
  Result := Alignment = TdxChartAxisAlignment.Near;
end;

function TdxChartCustomAxis.IsNumeric: Boolean;
begin
  Result := True;
end;

function TdxChartCustomAxis.IsSecondary: Boolean;
begin
  Result := False;
end;

function TdxChartCustomAxis.IsZeroAlignment: Boolean;
begin
  Result := Alignment = TdxChartAxisAlignment.Zero;
end;

procedure TdxChartCustomAxis.PopulateValues(AValues: TStrings);
begin
  AValues.Clear;
end;

procedure TdxChartCustomAxis.LayoutChanged;
begin
  ViewInfo.FreeCanvasBasedResources;
  Diagram.Changed(TdxChartXYDiagram.TDiagramChange.Layout);
end;

procedure TdxChartCustomAxis.StyleChanged;
begin
  LayoutChanged;
end;

procedure TdxChartCustomAxis.SetGridlines(AValue: TdxChartAxisGridlines);
begin
  FGridlines.Assign(AValue);
end;

procedure TdxChartCustomAxis.SetInterlaced(AValue: Boolean);
begin
  if FInterlaced <> AValue then
  begin
    FInterlaced := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomAxis.SetNumericScaleOptions(AValue: TdxChartAxisNumericScaleOptions);
begin
  FNumericScaleOptions.Assign(AValue);
end;

procedure TdxChartCustomAxis.SetRange(AValue: TdxChartRange);
begin
  FRange.Assign(AValue);
end;

procedure TdxChartCustomAxis.SetReverse(AValue: Boolean);
begin
  if FReverse <> AValue then
  begin
    FReverse := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomAxis.SetAlignment(AValue: TdxChartAxisAlignment);
begin
  if FAlignment <> AValue then
  begin
    FAlignment := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomAxis.SetLogarithmic(AValue: Boolean);
begin
  if FLogarithmic <> AValue then
  begin
    FLogarithmic := AValue;
    RecreateDataValueConverter;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomAxis.SetLogarithmicBase(AValue: Single);
begin
  if FLogarithmicBase <> AValue then
  begin
    FLogarithmicBase := AValue;
    RecreateDataValueConverter;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomAxis.SetMinorCount(AValue: Integer);
begin
  AValue := Max(0, AValue);
  if FMinorCount <> AValue then
  begin
    FMinorCount := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomAxis.SetTitle(AValue: TdxChartAxisTitle);
begin
  Title.Assign(AValue);
end;

procedure TdxChartCustomAxis.SetTicks(AValue: TdxChartAxisTicks);
begin
  Ticks.Assign(AValue);
end;

procedure TdxChartCustomAxis.RecreateDataValueConverter;
begin
  FreeAndNil(FDataValueConverter);
  if Logarithmic then
    FDataValueConverter := TdxChartLogarithmicAxisDataValueConverter.Create(LogarithmicBase);
end;

procedure TdxChartCustomAxis.SetDefaultAxisAlignment;
begin
  FAlignment := TdxChartAxisAlignment.Near;
end;

procedure TdxChartCustomAxis.SetValueLabels(AValue: TdxChartAxisValueLabels);
begin
  FValueLabels.Assign(AValue);
end;

{ TdxChartCustomAxisX }

function TdxChartCustomAxisX.CompareValues(AValue1, AValue2: TdxChartXYSeriesValueViewInfo): Integer;
begin
  Result := CompareValue(AValue1.Argument, AValue2.Argument);
  if Assigned(FOnCompareValues) then
    FOnCompareValues(Self, AValue1.ArgumentDisplayText, AValue2.ArgumentDisplayText, Result);
end;

function TdxChartCustomAxisX.CreateViewData: TdxChartAxisViewData;
begin
  Result := TdxChartAxisXViewData.Create(Self);
end;

function TdxChartCustomAxisX.GetDefaultMinorCount: Integer;
begin
  Result := DefaultMinorCount;
end;

function TdxChartCustomAxisX.GetOrthogonalAxis: TdxChartCustomAxis;
begin
  Result := Axes.AxisY;
end;

function TdxChartCustomAxisX.GetValueType: TVarType;
var
  AValueType: TVarType;
begin
  GetDataTypes(AValueType, Result);
end;

function TdxChartCustomAxisX.IsArgumentAxis: Boolean;
begin
  Result := True;
end;

function TdxChartCustomAxisX.IsNumeric: Boolean;
begin
  if Diagram.ViewData.GroupCount > 0 then
    Result := TdxChartXYDiagramSeriesGroup(Diagram.ViewData.Groups[0]).IsNumeric
  else
    Result := inherited IsNumeric;
end;

function TdxChartCustomAxisX.IsScrollBarEnabled: Boolean;
begin
  Result := not IsSecondary and Diagram.ScrollOptions.GetActualScrollbars and Diagram.ScrollOptions.AxisXScrollingEnabled;
end;

procedure TdxChartCustomAxisX.PopulateValues(AValues: TStrings);
var
  I: Integer;
begin
  ViewData.Calculate;
  if ViewData.StringValuesHandler = nil then
  begin
    inherited PopulateValues(AValues);
    Exit;
  end;
  AValues.BeginUpdate;
  try
    AValues.Clear;
    AValues.Capacity := ViewData.StringValuesHandler.Count;
    for I := 0 to ViewData.StringValuesHandler.Count - 1 do
      AValues.Add(ViewData.StringValuesHandler.GetValueAsText(I));
  finally
    AValues.EndUpdate;
  end;
end;

function TdxChartCustomAxisX.GetViewData: TdxChartAxisXViewData;
begin
  Result := TdxChartAxisXViewData(inherited ViewData);
end;

{ TdxChartAxisX }

function TdxChartAxisX.ActuallyVisible: Boolean;
begin
  Result := Visible;
end;

{ TdxChartSecondaryAxisX }

function TdxChartSecondaryAxisX.ActuallyVisible: Boolean;
begin
  Result := Visible and SecondaryAxes.Visible;
end;

function TdxChartSecondaryAxisX.GetAxes: TdxChartAxes;
begin
  Result := Diagram.Axes;
end;

function TdxChartSecondaryAxisX.GetDiagram: TdxChartXYDiagram;
begin
  Result := SecondaryAxes.Diagram;
end;

function TdxChartSecondaryAxisX.GetSecondaryAxes: TdxChartSecondaryAxes;
begin
  Result := TdxChartSecondaryAxes(inherited Owner);
end;

function TdxChartSecondaryAxisX.IsFarAlignment: Boolean;
begin
  Result := Alignment = TdxChartSecondaryAxisAlignment.Far;
end;

function TdxChartSecondaryAxisX.IsNearAlignment: Boolean;
begin
  Result := Alignment = TdxChartSecondaryAxisAlignment.Near;
end;

function TdxChartSecondaryAxisX.IsSecondary: Boolean;
begin
  Result := True;
end;

function TdxChartSecondaryAxisX.IsZeroAlignment: Boolean;
begin
  Result := False;
end;

procedure TdxChartSecondaryAxisX.SetAlignment(AValue: TdxChartSecondaryAxisAlignment);
begin
  if FAlignment <> AValue then
  begin
    FAlignment := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartSecondaryAxisX.SetDefaultAxisAlignment;
begin
  FAlignment := TdxChartSecondaryAxisAlignment.Far;
end;

{ TdxChartCustomAxisY }

function TdxChartCustomAxisY.GetDefaultMinorCount: Integer;
begin
  Result := DefaultMinorCount;
end;

function TdxChartCustomAxisY.GetOrthogonalAxis: TdxChartCustomAxis;
begin
  Result := Axes.AxisX;
end;

function TdxChartCustomAxisY.IsArgumentAxis: Boolean;
begin
  Result := False;
end;

function TdxChartCustomAxisY.IsScrollBarEnabled: Boolean;
begin
  Result := not IsSecondary and Diagram.ScrollOptions.GetActualScrollbars and Diagram.ScrollOptions.AxisYScrollingEnabled;
end;

{
function TdxChartCustomAxisY.IsPercentFormat: Boolean;
begin
  Result := (Diagram.ViewData.SeriesCount > 0) and (TdxChartXYSeriesCustomView(
    Diagram.ViewData.Series[0].View).GetValuesStacking = TdxChartXYSeriesCustomView.TValuesStacking.Full);
end;
}

{ TdxChartAxisY }

function TdxChartAxisY.ActuallyVisible: Boolean;
begin
  Result := Visible;
end;

function TdxChartAxisY.IsGridlinesVisibleByDefault: Boolean;
begin
  Result := True;
end;

{ TdxChartSecondaryAxisY }

function TdxChartSecondaryAxisY.GetAxes: TdxChartAxes;
begin
  Result := Diagram.Axes;
end;

function TdxChartSecondaryAxisY.ActuallyVisible: Boolean;
begin
  Result := Visible and SecondaryAxes.Visible;
end;

function TdxChartSecondaryAxisY.GetDiagram: TdxChartXYDiagram;
begin
  Result := SecondaryAxes.Diagram;
end;

function TdxChartSecondaryAxisY.GetSecondaryAxes: TdxChartSecondaryAxes;
begin
  Result := TdxChartSecondaryAxes(inherited Owner);
end;

function TdxChartSecondaryAxisY.IsFarAlignment: Boolean;
begin
  Result := Alignment = TdxChartSecondaryAxisAlignment.Far;
end;

function TdxChartSecondaryAxisY.IsNearAlignment: Boolean;
begin
  Result := Alignment = TdxChartSecondaryAxisAlignment.Near;
end;

function TdxChartSecondaryAxisY.IsSecondary: Boolean;
begin
  Result := True;
end;

function TdxChartSecondaryAxisY.IsZeroAlignment: Boolean;
begin
  Result := False;
end;

procedure TdxChartSecondaryAxisY.SetAlignment(AValue: TdxChartSecondaryAxisAlignment);
begin
  if FAlignment <> AValue then
  begin
    FAlignment := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartSecondaryAxisY.SetDefaultAxisAlignment;
begin
  FAlignment := TdxChartSecondaryAxisAlignment.Far;
end;

{ TdxChartSecondaryCustomAxisCollectionItem }

constructor TdxChartSecondaryCustomAxisCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FAxis := CreateAxis;
  Visible := True;
end;

destructor TdxChartSecondaryCustomAxisCollectionItem.Destroy;
begin
  FreeAndNil(FAxis);
  inherited Destroy;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.Assign(Source: TPersistent);
begin
  if Source is TdxChartSecondaryCustomAxisCollectionItem then
    Axis.Assign(TdxChartSecondaryCustomAxisCollectionItem(Source).Axis)
  else
    inherited Assign(Source);
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetAppearance: TdxChartAxisAppearance;
begin
  Result := FAxis.Appearance;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetGridlines: TdxChartAxisGridlines;
begin
  Result := FAxis.Gridlines;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetInterlaced: Boolean;
begin
  Result := FAxis.Interlaced;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetLogarithmic: Boolean;
begin
  Result := FAxis.Logarithmic;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetLogarithmicBase: Single;
begin
  Result := FAxis.LogarithmicBase;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetMinorCount: Integer;
begin
  Result := FAxis.MinorCount;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetNumericScaleOptions: TdxChartAxisNumericScaleOptions;
begin
  Result := FAxis.NumericScaleOptions;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetRange: TdxChartRange;
begin
  Result := FAxis.Range;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetReverse: Boolean;
begin
  Result := FAxis.Reverse;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetTicks: TdxChartAxisTicks;
begin
  Result := FAxis.Ticks;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetTitle: TdxChartAxisTitle;
begin
  Result := FAxis.Title;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetValueLabels: TdxChartAxisValueLabels;
begin
  Result := FAxis.ValueLabels;
end;

function TdxChartSecondaryCustomAxisCollectionItem.GetVisible: Boolean;
begin
  Result := FAxis.Visible;
end;

function TdxChartSecondaryCustomAxisCollectionItem.IsLogarithmicBaseStored: Boolean;
begin
  Result := not SameValue(LogarithmicBase, FAxis.DefaultLogarithmicBase);
end;

function TdxChartSecondaryCustomAxisCollectionItem.IsMinorCountStored: Boolean;
begin
  Result := MinorCount <> FAxis.MinorCount;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetAppearance(AValue: TdxChartAxisAppearance);
begin
  FAxis.Appearance := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetGridlines(AValue: TdxChartAxisGridlines);
begin
  FAxis.Gridlines := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetInterlaced(AValue: Boolean);
begin
  FAxis.Interlaced := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetValueLabels(AValue: TdxChartAxisValueLabels);
begin
  FAxis.ValueLabels := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetLogarithmic(AValue: Boolean);
begin
  FAxis.Logarithmic := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetLogarithmicBase(AValue: Single);
begin
  FAxis.LogarithmicBase := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetMinorCount(AValue: Integer);
begin
  FAxis.MinorCount := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetNumericScaleOptions(AValue: TdxChartAxisNumericScaleOptions);
begin
  FAxis.NumericScaleOptions := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetRange(AValue: TdxChartRange);
begin
  FAxis.Range := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetReverse(AValue: Boolean);
begin
  FAxis.Reverse := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetTicks(AValue: TdxChartAxisTicks);
begin
  FAxis.Ticks := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetTitle(AValue: TdxChartAxisTitle);
begin
  FAxis.Title := AValue;
end;

procedure TdxChartSecondaryCustomAxisCollectionItem.SetVisible(AValue: Boolean);
begin
  FAxis.Visible := AValue;
end;

{ TdxChartSecondaryAxisXCollectionItem }

function TdxChartSecondaryAxisXCollectionItem.GetAlignment: TdxChartSecondaryAxisAlignment;
begin
  Result := Axis.Alignment;
end;

function TdxChartSecondaryAxisXCollectionItem.GetAxis: TdxChartSecondaryAxisX;
begin
  Result := TdxChartSecondaryAxisX(inherited Axis);
end;

function TdxChartSecondaryAxisXCollectionItem.CreateAxis: TdxChartCustomAxis;
begin
  Result := TdxChartSecondaryAxisX.Create(TdxChartSecondaryCustomAxes(Collection).Diagram.SecondaryAxes);
end;

procedure TdxChartSecondaryAxisXCollectionItem.SetAlignment(AValue: TdxChartSecondaryAxisAlignment);
begin
  Axis.Alignment := AValue;
end;

{ TdxChartSecondaryAxisYCollectionItem }

function TdxChartSecondaryAxisYCollectionItem.GetAlignment: TdxChartSecondaryAxisAlignment;
begin
  Result := Axis.Alignment;
end;

function TdxChartSecondaryAxisYCollectionItem.GetAxis: TdxChartSecondaryAxisY;
begin
  Result := TdxChartSecondaryAxisY(inherited Axis);
end;

function TdxChartSecondaryAxisYCollectionItem.CreateAxis: TdxChartCustomAxis;
begin
  Result := TdxChartSecondaryAxisY.Create(TdxChartSecondaryCustomAxes(Collection).Diagram.SecondaryAxes);
end;

procedure TdxChartSecondaryAxisYCollectionItem.SetAlignment(AValue: TdxChartSecondaryAxisAlignment);
begin
  Axis.Alignment := AValue;
end;

{ TdxChartSecondaryCustomAxes }

constructor TdxChartSecondaryCustomAxes.Create(ADiagram: TdxChartXYDiagram);
begin
  inherited Create(ADiagram.Owner, GetCollectionItemClass);
  FDiagram := ADiagram;
end;

procedure TdxChartSecondaryCustomAxes.BiDiModeChanged;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Axis.BiDiModeChanged;
end;

procedure TdxChartSecondaryCustomAxes.ChangeScale(M, D: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Axis.ChangeScale(M, D);
end;

procedure TdxChartSecondaryCustomAxes.Draw(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Items[I].Axis.ViewInfo.Draw(ACanvas);
end;

function TdxChartSecondaryCustomAxes.GetDirty: Boolean;
var
  I: Integer;
begin
  Result := False;
  if Count > 0 then
    for I := 0 to Count - 1 do
    begin
      Result := Items[I].Axis.ViewInfo.Dirty;
      if Result then
        Break;
    end;
end;

function TdxChartSecondaryCustomAxes.GetItem(AIndex: Integer): TdxChartSecondaryCustomAxisCollectionItem;
begin
  Result := TdxChartSecondaryAxisXCollectionItem(inherited Items[AIndex]);
end;

procedure TdxChartSecondaryCustomAxes.LayoutChanged;
begin
  Diagram.Changed(TdxChartXYDiagram.TDiagramChange.Layout);
end;

procedure TdxChartSecondaryCustomAxes.SetItem(AIndex: Integer; AValue: TdxChartSecondaryCustomAxisCollectionItem);
begin
  Items[AIndex].Assign(AValue);
end;

procedure TdxChartSecondaryCustomAxes.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if (Item = nil) or TdxChartSecondaryCustomAxisCollectionItem(Item).Axis.ActuallyVisible then
    LayoutChanged;
end;

{ TdxChartSecondaryAxesX }

function TdxChartSecondaryAxesX.Add: TdxChartSecondaryAxisXCollectionItem;
begin
  Result := TdxChartSecondaryAxisXCollectionItem(inherited Add);
end;

function TdxChartSecondaryAxesX.GetCollectionItemClass: TdxChartSecondaryCustomAxisCollectionItemClass;
begin
  Result := TdxChartSecondaryAxisXCollectionItem;
end;

function TdxChartSecondaryAxesX.GetItem(AIndex: Integer): TdxChartSecondaryAxisXCollectionItem;
begin
  Result := TdxChartSecondaryAxisXCollectionItem(inherited Items[AIndex]);
end;

procedure TdxChartSecondaryAxesX.SetItem(AIndex: Integer; AValue: TdxChartSecondaryAxisXCollectionItem);
begin
  Items[AIndex].Assign(AValue);
end;

{ TdxChartSecondaryAxesY }

function TdxChartSecondaryAxesY.Add: TdxChartSecondaryAxisYCollectionItem;
begin
  Result := TdxChartSecondaryAxisYCollectionItem(inherited Add);
end;

function TdxChartSecondaryAxesY.GetCollectionItemClass: TdxChartSecondaryCustomAxisCollectionItemClass;
begin
  Result := TdxChartSecondaryAxisYCollectionItem;
end;

function TdxChartSecondaryAxesY.GetItem(AIndex: Integer): TdxChartSecondaryAxisYCollectionItem;
begin
  Result := TdxChartSecondaryAxisYCollectionItem(inherited Items[AIndex]);
end;

procedure TdxChartSecondaryAxesY.SetItem(AIndex: Integer; AValue: TdxChartSecondaryAxisYCollectionItem);
begin
  Items[AIndex].Assign(AValue);
end;

{ TdxChartAxes }

constructor TdxChartAxes.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FAxisX := TdxChartAxisX.Create(Self);
  FAxisY := TdxChartAxisY.Create(Self);
end;

destructor TdxChartAxes.Destroy;
begin
  FreeAndNil(FAxisX);
  FreeAndNil(FAxisY);
  inherited Destroy;
end;

procedure TdxChartAxes.BiDiModeChanged;
begin
  FAxisX.BiDiModeChanged;
  FAxisY.BiDiModeChanged;
end;

procedure TdxChartAxes.ChangeScale(M, D: Integer);
begin
  FAxisX.ChangeScale(M, D);
  FAxisY.ChangeScale(M, D);
end;

procedure TdxChartAxes.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartAxes then
  begin
    AxisX := TdxChartAxes(Source).AxisX;
    AxisY := TdxChartAxes(Source).AxisY;
  end;
end;

procedure TdxChartAxes.Draw(ACanvas: TcxCustomCanvas);
begin
  AxisX.ViewInfo.Draw(ACanvas);
  AxisY.ViewInfo.Draw(ACanvas);
end;

function TdxChartAxes.GetDiagram: TdxChartXYDiagram;
begin
  Result := TdxChartXYDiagram(Owner);
end;

procedure TdxChartAxes.SetAxisX(AValue: TdxChartAxisX);
begin
  FAxisX.Assign(AValue);
end;

procedure TdxChartAxes.SetAxisY(AValue: TdxChartAxisY);
begin
  FAxisY.Assign(AValue);
end;

{ TdxChartSecondaryAxes }

constructor TdxChartSecondaryAxes.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FAxesX := TdxChartSecondaryAxesX.Create(Diagram);
  FAxesY := TdxChartSecondaryAxesY.Create(Diagram);
  FVisible := True;
end;

destructor TdxChartSecondaryAxes.Destroy;
begin
  FreeAndNil(FAxesX);
  FreeAndNil(FAxesY);
  inherited Destroy;
end;

procedure TdxChartSecondaryAxes.BiDiModeChanged;
begin
  FAxesX.BiDiModeChanged;
  FAxesY.BiDiModeChanged;
end;

procedure TdxChartSecondaryAxes.ChangeScale(M, D: Integer);
begin
  FAxesX.ChangeScale(M, D);
  FAxesY.ChangeScale(M, D);
end;

procedure TdxChartSecondaryAxes.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartSecondaryAxes then
  begin
    AxesX.Assign(TdxChartSecondaryAxes(Source).AxesX);
    AxesY.Assign(TdxChartSecondaryAxes(Source).AxesY);
  end;
end;

procedure TdxChartSecondaryAxes.Draw(ACanvas: TcxCustomCanvas);
begin
  AxesX.Draw(ACanvas);
  AxesY.Draw(ACanvas);
end;

function TdxChartSecondaryAxes.GetDiagram: TdxChartXYDiagram;
begin
  Result := TdxChartXYDiagram(Owner);
end;

procedure TdxChartSecondaryAxes.SetAxesX(AValue: TdxChartSecondaryAxesX);
begin
  FAxesX.Assign(AValue);
end;

procedure TdxChartSecondaryAxes.SetAxesY(AValue: TdxChartSecondaryAxesY);
begin
  FAxesY.Assign(AValue);
end;

procedure TdxChartSecondaryAxes.SetVisible(AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Diagram.Changed(TdxChartXYDiagram.TDiagramChange.Layout);
  end;
end;

{ TdxChartXYSeriesCustomView }

function TdxChartXYSeriesCustomView.GetViewInfo: TdxChartXYSeriesViewCustomViewInfo;
begin
  Result := TdxChartXYSeriesViewCustomViewInfo(inherited ViewInfo);
end;

class function TdxChartXYSeriesCustomView.CanAggregate(AView: TdxChartSeriesCustomView): Boolean;
begin
  Result := inherited CanAggregate(AView) and (GetValuesStacking = TdxChartXYSeriesCustomView(AView).GetValuesStacking);
end;

function TdxChartXYSeriesCustomView.CreateValueLabels: TdxChartSeriesValueLabels;
begin
  Result := TdxChartXYSeriesValueLabels.Create(Self);
end;

function TdxChartXYSeriesCustomView.CreateViewData: TdxChartSeriesViewCustomViewData;
begin
  Result := TdxChartXYSeriesViewCustomViewData.Create(Self);
end;

function TdxChartXYSeriesCustomView.CreateViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
  Result := TdxChartXYSeriesViewCustomViewInfo.Create(Self);
end;

class function TdxChartXYSeriesCustomView.GetNegativeValuesStackingStyle: TNegativeValuesStackingStyle;
begin
  Result := TNegativeValuesStackingStyle.StackIfNoPositiveValues;
end;

function TdxChartXYSeriesCustomView.GetValueLabels: TdxChartXYSeriesValueLabels;
begin
  Result := TdxChartXYSeriesValueLabels(inherited ValueLabels);
end;

class function TdxChartXYSeriesCustomView.GetValuesStacking: TValuesStacking;
const
  Stacked = 'Stacked';
  FullStacked = 'FullStacked';
begin
  Result := TValuesStacking.None;
  if Pos(UpperCase(FullStacked), UpperCase(ClassName)) > 0 then
    Result := TValuesStacking.Full
  else
    if Pos(UpperCase(Stacked), UpperCase(ClassName)) > 0 then
      Result := TValuesStacking.Normal;
end;

function TdxChartXYSeriesCustomView.IsZeroBased: Boolean;
begin
  Result := False;
end;

procedure TdxChartXYSeriesCustomView.SetValueLabels(AValue: TdxChartXYSeriesValueLabels);
begin
  ValueLabels.Assign(AValue);
end;

{ TdxChartMouseActionExecutor }

function TdxChartMouseActionExecutor.GetDefaultMouseCursor: TCursor;
begin
  Result := crDefault;
end;

function TdxChartMouseActionExecutor.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  Result := nil;
end;

procedure TdxChartMouseActionExecutor.MouseUp(ADiagram: TdxChartCustomDiagram;
  AMouseX, AMouseY: Integer);
begin

end;

class function TdxChartMouseActionExecutor.NoRange(ADiagram: TdxChartXYDiagram): Boolean;
begin
  Result := IsZero(ADiagram.Axes.AxisX.Range.WholeRangeExtended.Range)
         or IsZero(ADiagram.Axes.AxisY.Range.WholeRangeExtended.Range)
         or IsZero(ADiagram.Axes.AxisX.Range.VisibleRangeExtended.Range)
         or IsZero(ADiagram.Axes.AxisY.Range.VisibleRangeExtended.Range);
end;

{ TdxChartRangeInfo }

constructor TdxChartRangeInfo.Create;
begin
  inherited Create;
end;

constructor TdxChartRangeInfo.Create(const AMin: Variant; const AMax: Variant);
begin
  inherited Create;
  FMin := AMin;
  FMax := AMax;
end;

{ TdxChartXYDiagramRangesChangeEventArgs }

constructor TdxChartXYDiagramRangesChangeEventArgs.Create(const AOldMinX, AOldMaxX, AOldMinY, AOldMaxY: Variant);
begin
  inherited Create;
  FNewXRange := TdxChartRangeInfo.Create;
  FNewYRange := TdxChartRangeInfo.Create;
  FOldXRange := TdxChartRangeInfo.Create(AOldMinX, AOldMaxX);
  FOldYRange := TdxChartRangeInfo.Create(AOldMinY, AOldMaxY);
end;

destructor TdxChartXYDiagramRangesChangeEventArgs.Destroy;
begin
  FreeAndNil(FNewXRange);
  FreeAndNil(FNewYRange);
  FreeAndNil(FOldXRange);
  FreeAndNil(FOldYRange);
  inherited Destroy;
end;

{ TdxChartXYDiagramBeforeZoomEventArgs }

constructor TdxChartXYDiagramBeforeZoomEventArgs.Create(AAxis: TdxChartCustomAxis; const ANewMin, ANewMax: Variant);
begin
  inherited Create;
  FAxis := AAxis;
  FNewRange := TdxChartRangeInfo.Create(ANewMin, ANewMax);
end;

destructor TdxChartXYDiagramBeforeZoomEventArgs.Destroy;
begin
  FreeAndNil(FNewRange);
  inherited Destroy;
end;

{ TdxChartGetAxisValueLabelDrawParametersEventArgs }

constructor TdxChartGetAxisValueLabelDrawParametersEventArgs.Create(AAxis: TdxChartCustomAxis; const AValue: Variant;
  AText: string);
begin
  inherited Create;
  FAxis := AAxis;
  FValue := AValue;
  FText := AText;
end;

{ TdxChartXYDiagramToolTipOptions }

constructor TdxChartXYDiagramToolTipOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FMode := TdxChartToolTipMode.Default;
end;

procedure TdxChartXYDiagramToolTipOptions.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYDiagramToolTipOptions then
    Mode := TdxChartXYDiagramToolTipOptions(Source).Mode;
end;

{ TdxChartXYDiagram }

constructor TdxChartXYDiagram.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAxes := TdxChartAxes.Create(Self);
  FSecondaryAxes := TdxChartSecondaryAxes.Create(Self);
  FZoomOptions := TdxChartXYDiagramZoomOptions.Create(Self);
  FScrollOptions := TdxChartXYDiagramScrollOptions.Create(Self);
end;

destructor TdxChartXYDiagram.Destroy;
begin
  FreeAndNil(FScrollOptions);
  FreeAndNil(FZoomOptions);
  FreeAndNil(FSecondaryAxes);
  FreeAndNil(FAxes);
  inherited Destroy;
end;

procedure TdxChartXYDiagram.AssignFrom(
  ASource: TdxChartCustomDiagram; ARecreate: Boolean = True; AStoreList:  TdxFastObjectList = nil);
var
  AXYDiagram: TdxChartXYDiagram;
begin
  BeginUpdate;
  try
    inherited AssignFrom(ASource, ARecreate, AStoreList);
    if ASource is TdxChartXYDiagram then
    begin
      AXYDiagram := TdxChartXYDiagram(ASource);
      Axes.Assign(AXYDiagram.Axes);
      FRotated := AXYDiagram.Rotated;
      SecondaryAxes.Assign(AXYDiagram.SecondaryAxes);
    end;
  finally
    EndUpdate;
  end;
end;

function TdxChartXYDiagram.AddSeries(const ACaption: string = ''): TdxChartXYSeries;
begin
  Result := inherited AddSeries(ACaption) as TdxChartXYSeries;
end;

procedure TdxChartXYDiagram.ForEachSeries(AHandler: TForEachSeriesProc);
var
  I: Integer;
begin
  for I := 0 to SeriesCount - 1 do
    AHandler(Series[I]);
end;

procedure TdxChartXYDiagram.ResetZoom;
begin
  Zoom(TdxChartRange.TZoomType.ResetZoom, 0, 0, TdxPointDouble.Null);
end;

procedure TdxChartXYDiagram.ZoomIn;
var
  AXRange, AYRange: TdxChartDataRange;
  ACentralPoint: TdxPointDouble;
begin
  AXRange := Axes.AxisX.Range.VisibleRangeExtended;
  AYRange := Axes.AxisY.Range.VisibleRangeExtended;
  ACentralPoint := TdxPointDouble.Create((AXRange.Min + AXRange.Max) / 2, (AYRange.Min + AYRange.Max) / 2);
  Zoom(TdxChartRange.TZoomType.CenteredBearingValue, Chart.ZoomOptions.LargeStep, 1, ACentralPoint);
end;

procedure TdxChartXYDiagram.ZoomOut;
var
  AXRange, AYRange: TdxChartDataRange;
  ACentralPoint: TdxPointDouble;
begin
  AXRange := Axes.AxisX.Range.VisibleRangeExtended;
  AYRange := Axes.AxisY.Range.VisibleRangeExtended;
  ACentralPoint := TdxPointDouble.Create((AXRange.Min + AXRange.Max) / 2, (AYRange.Min + AYRange.Max) / 2);
  Zoom(TdxChartRange.TZoomType.CenteredBearingValue, Chart.ZoomOptions.LargeStep, -1, ACentralPoint);
end;

procedure TdxChartXYDiagram.DoBeforeZoom(AArgs: TdxChartXYDiagramBeforeZoomEventArgs);
begin
  if Assigned(OnBeforeZoom) then
    OnBeforeZoom(Self, AArgs);
end;

procedure TdxChartXYDiagram.DoGetAxisValueLabelDrawParameters(AArgs: TdxChartGetAxisValueLabelDrawParametersEventArgs);
begin
  if Assigned(OnGetAxisValueLabelDrawParameters) then
    OnGetAxisValueLabelDrawParameters(Self, AArgs);
end;

procedure TdxChartXYDiagram.DoScroll(AArgs: TdxChartXYDiagramScrollEventArgs);
begin
  if Assigned(OnScroll) then
    OnScroll(Self, AArgs);
end;

procedure TdxChartXYDiagram.DoZoom(AArgs: TdxChartXYDiagramZoomEventArgs);
begin
  if Assigned(OnZoom) then
    OnZoom(Self, AArgs);
end;

function TdxChartXYDiagram.GetActualToolTipMode: TdxChartActualToolTipMode;
begin
  if ToolTips.Mode = TdxChartToolTipMode.Default then
    Result := Chart.ToolTips.DefaultMode
  else
    Result := ToolTips.Mode;
end;

procedure TdxChartXYDiagram.Zoom(AZoomType: TdxChartRange.TZoomType; AStepPercent: Single; AStepCount: Integer; ABearingPoint: TdxPointDouble);
begin
  if ZoomOptions.AxisXZoomingEnabled then
    Axes.AxisX.Range.Zoom(AZoomType, AStepPercent, AStepCount, ZoomOptions.AxisXMaxZoomPercent, ABearingPoint.X);
  if ZoomOptions.AxisYZoomingEnabled then
    Axes.AxisY.Range.Zoom(AZoomType, AStepPercent, AStepCount, ZoomOptions.AxisYMaxZoomPercent, ABearingPoint.Y);
end;

procedure TdxChartXYDiagram.ZoomByMouseWheel(AWheelDelta: Integer;
  AMousePos: TPoint; AByX: Boolean; AByY: Boolean);
const
  AZoomType = TdxChartRange.TZoomType.FixedBearingValue;
var
  AFixedX, AFixedY: Double;
  AArgs: TdxChartXYDiagramZoomEventArgs;
  AZoomStep: Single;
  AStepCount: Integer;
  AZoomedByX, AZoomedByY: Boolean;
begin
  AZoomedByX := False;
  AZoomedByY := False;
  if Rotated then
  begin
    AFixedX := Axes.AxisX.ViewInfo.CanvasValueToAxisValue(AMousePos.Y);
    AFixedY := Axes.AxisY.ViewInfo.CanvasValueToAxisValue(AMousePos.X);
  end
  else
  begin
    AFixedX := Axes.AxisX.ViewInfo.CanvasValueToAxisValue(AMousePos.X);
    AFixedY := Axes.AxisY.ViewInfo.CanvasValueToAxisValue(AMousePos.Y);
  end;
  AZoomStep := Chart.ZoomOptions.SmallStep;
  AStepCount := AWheelDelta div WHEEL_DELTA;
  AArgs := TdxChartXYDiagramZoomEventArgs.Create(Axes.AxisX.Range.VisibleMin, Axes.AxisX.Range.VisibleMax,
                                                 Axes.AxisY.Range.VisibleMin, Axes.AxisY.Range.VisibleMax
                                                );
  try
    if AByX and ZoomOptions.AxisXZoomingEnabled then
      AZoomedByX := ZoomByUserAlongAxis(Axes.AxisX, AZoomType, AZoomStep, AStepCount, ZoomOptions.AxisXMaxZoomPercent, AFixedX);
    if AByY and ZoomOptions.AxisYZoomingEnabled then
      AZoomedByY := ZoomByUserAlongAxis(Axes.AxisY, AZoomType, AZoomStep, AStepCount, ZoomOptions.AxisYMaxZoomPercent, AFixedY);
    if AZoomedByX or AZoomedByY then
    begin
      AArgs.FNewXRange.FMin := Axes.AxisX.Range.VisibleMin;
      AArgs.FNewXRange.FMax := Axes.AxisX.Range.VisibleMax;
      AArgs.FNewYRange.FMin := Axes.AxisY.Range.VisibleMin;
      AArgs.FNewYRange.FMax := Axes.AxisY.Range.VisibleMax;
      DoZoom(AArgs);
    end;
  finally
    FreeAndNil(AArgs);
  end;
end;

procedure TdxChartXYDiagram.ScrollByUser(AScrollStyle: System.UITypes.TScrollStyle;
                                         AHScrollCode: TScrollCode; AHScrollPos: Integer;
                                         AVScrollCode: TScrollCode; AVScrollPos: Integer);
var
  AArgs: TdxChartXYDiagramScrollEventArgs;
  AScrolledByX, AScrolledByY: Boolean;
begin
  AScrolledByX := False;
  AScrolledByY := False;
  AArgs := TdxChartXYDiagramScrollEventArgs.Create(Axes.AxisX.Range.VisibleMin, Axes.AxisX.Range.VisibleMax,
                                                   Axes.AxisY.Range.VisibleMin, Axes.AxisY.Range.VisibleMax
                                                  );
  try
    if ScrollOptions.AxisXScrollingEnabled and Axes.AxisX.ViewInfo.IsVisibleRangeValid then
    begin
      if Rotated and (AScrollStyle in [ssVertical, ssBoth]) then
        Axes.AxisX.ScrollContent(AVScrollCode, AVScrollPos, AScrolledByX);
      if not Rotated and (AScrollStyle in [ssHorizontal, ssBoth]) then
        Axes.AxisX.ScrollContent(AHScrollCode, AHScrollPos, AScrolledByX);
    end;
    if ScrollOptions.AxisYScrollingEnabled and Axes.AxisY.ViewInfo.IsVisibleRangeValid then
    begin
      if Rotated and (AScrollStyle in [ssHorizontal, ssBoth]) then
        Axes.AxisY.ScrollContent(AHScrollCode, AHScrollPos, AScrolledByY);
      if not Rotated and (AScrollStyle in [ssVertical, ssBoth]) then
        Axes.AxisY.ScrollContent(AVScrollCode, AVScrollPos, AScrolledByY);
    end;
    if AScrolledByX or AScrolledByY then
    begin
      AArgs.FNewXRange.FMin := Axes.AxisX.Range.VisibleMin;
      AArgs.FNewXRange.FMax := Axes.AxisX.Range.VisibleMax;
      AArgs.FNewYRange.FMin := Axes.AxisY.Range.VisibleMin;
      AArgs.FNewYRange.FMax := Axes.AxisY.Range.VisibleMax;
      DoScroll(AArgs);
    end;
  finally
    FreeAndNil(AArgs);
  end;
end;


procedure TdxChartXYDiagram.ZoomByUser(AZoomType: TdxChartRange.TZoomType; AStepPercent: Single; AStepCount: Integer; ABearingPoint: TdxPointDouble);
var
  AArgs: TdxChartXYDiagramZoomEventArgs;
  AZoomed: Boolean;
begin
  AZoomed := False;
  if not ZoomOptions.AxisXZoomingEnabled and not ZoomOptions.AxisYZoomingEnabled then
    Exit;
  AArgs := TdxChartXYDiagramZoomEventArgs.Create(Axes.AxisX.Range.VisibleMin, Axes.AxisX.Range.VisibleMax,
                                                 Axes.AxisY.Range.VisibleMin, Axes.AxisY.Range.VisibleMax
                                                );
  try
    if ZoomOptions.AxisXZoomingEnabled then
      AZoomed := ZoomByUserAlongAxis(Axes.AxisX, AZoomType, AStepPercent, AStepCount, ZoomOptions.AxisXMaxZoomPercent, ABearingPoint.X);
    if ZoomOptions.AxisYZoomingEnabled then
      AZoomed := ZoomByUserAlongAxis(Axes.AxisY, AZoomType, AStepPercent, AStepCount, ZoomOptions.AxisYMaxZoomPercent, ABearingPoint.Y) or AZoomed;
    if AZoomed then
    begin
      AArgs.FNewXRange.FMin := Axes.AxisX.Range.VisibleMin;
      AArgs.FNewXRange.FMax := Axes.AxisX.Range.VisibleMax;
      AArgs.FNewYRange.FMin := Axes.AxisY.Range.VisibleMin;
      AArgs.FNewYRange.FMax := Axes.AxisY.Range.VisibleMax;
      DoZoom(AArgs);
    end;
  finally
    FreeAndNil(AArgs);
  end;
end;

procedure TdxChartXYDiagram.ZoomToRect(ARect: TdxRectDouble);
  function TryZoomAlongAxis(AAxis: TdxChartCustomAxis; AMin, AMax: Double; AMaxPercent: Single): Boolean;
  var
    ARange: TdxChartRange;
    AArgs: TdxChartXYDiagramBeforeZoomEventArgs;

  begin
    Result := False;
    AArgs := nil;
    ARange := TdxChartRange.CreateUnattached(AAxis);
    try
      ARange.Assign(AAxis.Range);
      ARange.Calculate;
      ARange.ZoomIn(AMin, AMax, AMaxPercent);
      ARange.Calculate;
      if not SameValue(ARange.RealVisibleRange.Min, AAxis.Range.RealVisibleRange.Min) or
         not SameValue(ARange.RealVisibleRange.Max, AAxis.Range.RealVisibleRange.Max) then
      begin
        AArgs := TdxChartXYDiagramBeforeZoomEventArgs.Create(AAxis, ARange.VisibleMin, ARange.VisibleMax);
        DoBeforeZoom(AArgs);
        if not AArgs.Cancel then
        begin
          AAxis.Range.VisibleMin := ARange.VisibleMin;
          AAxis.Range.VisibleMax := ARange.VisibleMax;
          Result := True;
        end;
      end;
    finally
      FreeAndNil(ARange);
      FreeAndNil(AArgs);
    end;
  end;
var
  AZoomed: Boolean;
  AArgs: TdxChartXYDiagramZoomEventArgs;
begin
  AZoomed := False;
  AArgs := TdxChartXYDiagramZoomEventArgs.Create(Axes.AxisX.Range.VisibleMin, Axes.AxisX.Range.VisibleMax,
                                                 Axes.AxisY.Range.VisibleMin, Axes.AxisY.Range.VisibleMax
                                                );
  try
    if ZoomOptions.AxisYZoomingEnabled then
      AZoomed := TryZoomAlongAxis(Axes.AxisY, Min(ARect.Top, ARect.Bottom), Max(ARect.Top, ARect.Bottom), ZoomOptions.AxisYMaxZoomPercent);
    if ZoomOptions.AxisXZoomingEnabled then
      AZoomed := TryZoomAlongAxis(Axes.AxisX, Min(ARect.Left, ARect.Right), Max(ARect.Left, ARect.Right), ZoomOptions.AxisXMaxZoomPercent) or AZoomed;
    if AZoomed then
    begin
      AArgs.FNewXRange.FMin := Axes.AxisX.Range.VisibleMin;
      AArgs.FNewXRange.FMax := Axes.AxisX.Range.VisibleMax;
      AArgs.FNewYRange.FMin := Axes.AxisY.Range.VisibleMin;
      AArgs.FNewYRange.FMax := Axes.AxisY.Range.VisibleMax;
      DoZoom(AArgs);
    end;
  finally
    FreeAndNil(AArgs);
  end;
end;

function TdxChartXYDiagram.GetSeries(AIndex: Integer): TdxChartXYSeries;
begin
  Result := TdxChartXYSeries(SeriesList[AIndex]);
end;

function TdxChartXYDiagram.GetVisibleSeries(AIndex: Integer): TdxChartXYSeries;
begin
  Result := TdxChartXYSeries(inherited VisibleSeries[AIndex]);
end;

procedure TdxChartXYDiagram.SetAxes(AValue: TdxChartAxes);
begin
  FAxes.Assign(AValue);
end;

function TdxChartXYDiagram.GetViewData: TdxChartXYDiagramViewData;
begin
  Result := TdxChartXYDiagramViewData(inherited ViewData);
end;

procedure TdxChartXYDiagram.SetRotated(AValue: Boolean);
begin
  if Rotated <> AValue then
  begin
    FRotated := AValue;
    Changed;
  end;
end;

procedure TdxChartXYDiagram.SetScrollOptions(AValue: TdxChartXYDiagramScrollOptions);
begin
  FScrollOptions.Assign(AValue)
end;

procedure TdxChartXYDiagram.SetSecondaryAxes(AValue: TdxChartSecondaryAxes);
begin
  FSecondaryAxes.Assign(AValue);
end;

procedure TdxChartXYDiagram.SetSeries(AIndex: Integer; const AValue: TdxChartXYSeries);
begin
  Series[AIndex].Assign(AValue);
end;

procedure TdxChartXYDiagram.SetToolTips(AValue: TdxChartXYDiagramToolTipOptions);
begin
  ToolTips.Assign(AValue);
end;

procedure TdxChartXYDiagram.SetZoomOptions(
  const AValue: TdxChartXYDiagramZoomOptions);
begin
  FZoomOptions.Assign(AValue);
end;

function TdxChartXYDiagram.ZoomByUserAlongAxis(AAxis: TdxChartCustomAxis; AZoomType: TdxChartRange.TZoomType;
            AStepPercent: Single; AStepCount: Integer; AMaxPercent: Single; ABearingValue: Double): Boolean;
var
  ARange: TdxChartRange;
  AArgs: TdxChartXYDiagramBeforeZoomEventArgs;
begin
  Result := False;
  AArgs := nil;
  ARange := TdxChartRange.CreateUnattached(AAxis);
  try
    ARange.Assign(AAxis.Range);
    ARange.Calculate;
    ARange.Zoom(AZoomType, AStepPercent, AStepCount, AMaxPercent, ABearingValue);
    ARange.Calculate;
    if not SameValue(ARange.RealVisibleRange.Min, AAxis.Range.RealVisibleRange.Min) or
       not SameValue(ARange.RealVisibleRange.Max, AAxis.Range.RealVisibleRange.Max) then
    begin
      AArgs := TdxChartXYDiagramBeforeZoomEventArgs.Create(AAxis, ARange.VisibleMin, ARange.VisibleMax);
      DoBeforeZoom(AArgs);
      if not AArgs.Cancel then
      begin
        AAxis.Range.VisibleMin := ARange.VisibleMin;
        AAxis.Range.VisibleMax := ARange.VisibleMax;
        Result := True;
      end;
    end;
  finally
    FreeAndNil(AArgs);
    FreeAndNil(ARange);
  end;
end;

procedure TdxChartXYDiagram.BiDiModeChanged;
begin
  inherited BiDiModeChanged;
  Axes.BiDiModeChanged;
  SecondaryAxes.BiDiModeChanged;
end;

procedure TdxChartXYDiagram.ChangeResolveOverlappingIndent(AChangedValueLabels: TdxChartXYSeriesValueLabels);
var
  I: Integer;
  AValueLabels: TdxChartXYSeriesValueLabels;
begin
  for I := 0 to SeriesCount - 1 do
  begin
    AValueLabels := Series[I].View.ValueLabels;
    if AValueLabels <> AChangedValueLabels then
      AValueLabels.UpdateResolveOverlappingIndent(AChangedValueLabels.ResolveOverlappingIndent);
  end;
end;

procedure TdxChartXYDiagram.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  Axes.ChangeScale(M, D);
  SecondaryAxes.ChangeScale(M, D);
end;

function TdxChartXYDiagram.CreateAppearance: TdxChartDiagramAppearance;
begin
  Result := TdxChartXYDiagramAppearance.Create(Self);
end;

function TdxChartXYDiagram.CreateToolTipOptions: TdxChartDiagramToolTipOptions;
begin
  Result := TdxChartXYDiagramToolTipOptions.Create(Self);
end;

function TdxChartXYDiagram.CreateViewData: TdxChartDiagramCustomViewData;
begin
  Result := TdxChartXYDiagramViewData.Create(Self);
end;

function TdxChartXYDiagram.CreateViewInfo: TdxChartDiagramCustomViewInfo;
begin
  Result := TdxChartXYDiagramViewInfo.Create(Self);
end;

class function TdxChartXYDiagram.GetMouseActionExecutorClasses: TdxChartMouseActionExecutorClassArray;
const
  Executors: TdxChartMouseActionExecutorClassArray = (
    TdxChartPanActionExecutor, TdxChartZoomInActionExecutor, TdxChartZoomOutActionExecutor, TdxChartMarqueeZoomActionExecutor
  );
begin
  Result := Executors;
end;

function TdxChartXYDiagram.GetSeriesClass: TdxChartSeriesClass;
begin
  Result := TdxChartXYSeries;
end;

function TdxChartXYDiagram.GetToolTips: TdxChartXYDiagramToolTipOptions;
begin
  Result := TdxChartXYDiagramToolTipOptions(inherited ToolTips);
end;

{ TdxChartXYDiagramInterlacedViewInfo }

procedure TdxChartXYDiagramInterlacedViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  ACanvas.FillRect(Bounds, AxisTick.Axis.Appearance.ActualBrush);
end;

{ TdxChartXYDiagramPlotAreaViewInfo }

constructor TdxChartXYDiagramPlotAreaViewInfo.Create(ADiagram: TdxChartXYDiagram);
begin
  inherited Create;
  FDiagram := ADiagram;
  Dirty := True;
end;

function TdxChartXYDiagramPlotAreaViewInfo.CanDrawBorder: Boolean;
begin
  Result := BorderVisible and (BorderThickness > 0);
end;

procedure TdxChartXYDiagramPlotAreaViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);

  function GetSidesOccupiedBySecondaryAxes(ASecondaryAxes: TObjectList<TdxChartAxisViewInfo>): TcxBorders;
  var
    I: Integer;
  begin
    Result := [];
    for I := 0 to ASecondaryAxes.Count - 1 do
      Result := Result + ASecondaryAxes[I].GetOccupiedSides(Bounds);
  end;

begin
  FBounds := DiagramViewInfo.PlotArea;
  FBorderSides := cxBordersAll -
    DiagramViewInfo.AxisXViewInfo.GetOccupiedSides(Bounds) -
    DiagramViewInfo.AxisYViewInfo.GetOccupiedSides(Bounds) -
    GetSidesOccupiedBySecondaryAxes(DiagramViewInfo.SecondaryAxesX) -
    GetSidesOccupiedBySecondaryAxes(DiagramViewInfo.SecondaryAxesY);
end;

procedure TdxChartXYDiagramPlotAreaViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  ACanvas.EnableAntialiasing(False);
  DrawInterlaced(ACanvas);
  DrawMinorGridlines(ACanvas);
  DrawGridlines(ACanvas);
  if CanDrawBorder then
    ACanvas.FrameRect(Bounds, BorderColor, BorderThickness, BorderSides);
  ACanvas.RestoreAntialiasing;
end;

procedure TdxChartXYDiagramPlotAreaViewInfo.DrawInterlaced(ACanvas: TcxCustomCanvas);

  function GetInterlaced(AInterlacedItems: TdxFastObjectList; AIndex: Integer): TdxChartXYDiagramInterlacedViewInfo;
  begin
    Result := TdxChartXYDiagramInterlacedViewInfo(AInterlacedItems.Items[AIndex]);
  end;

  procedure InternalDraw(AAxis: TdxChartCustomAxis; ASecondaryAxes: TObjectList<TdxChartAxisViewInfo>);
  var
    I, J: Integer;
    AInterlacedItems: TdxFastObjectList;
  begin
    for I := 0 to ASecondaryAxes.Count - 1 do
    begin
      AInterlacedItems := ASecondaryAxes[I].InterlacedItems;
      for J := 0 to AInterlacedItems.Count - 1 do
        GetInterlaced(AInterlacedItems, J).Draw(ACanvas);
    end;

    AInterlacedItems := AAxis.ViewInfo.InterlacedItems;
    for I := 0 to AInterlacedItems.Count - 1 do
      GetInterlaced(AInterlacedItems, I).Draw(ACanvas);
  end;

begin
  InternalDraw(Diagram.Axes.AxisX, DiagramViewInfo.SecondaryAxesX);
  InternalDraw(Diagram.Axes.AxisY, DiagramViewInfo.SecondaryAxesY);
end;

procedure TdxChartXYDiagramPlotAreaViewInfo.DrawGridlines(ACanvas: TcxCustomCanvas);

  procedure InternalDraw(AAxis: TdxChartCustomAxis; ASecondaryAxes: TObjectList<TdxChartAxisViewInfo>);
  var
    I: Integer;
  begin
    for I := 0 to ASecondaryAxes.Count - 1 do
      ASecondaryAxes[I].Gridlines.Draw(ACanvas);
    AAxis.ViewInfo.Gridlines.Draw(ACanvas);
  end;

begin
  InternalDraw(Diagram.Axes.AxisX, DiagramViewInfo.SecondaryAxesX);
  InternalDraw(Diagram.Axes.AxisY, DiagramViewInfo.SecondaryAxesY);
end;

procedure TdxChartXYDiagramPlotAreaViewInfo.DrawMinorGridlines(ACanvas: TcxCustomCanvas);

  procedure InternalDraw(AAxis: TdxChartCustomAxis; ASecondaryAxes: TObjectList<TdxChartAxisViewInfo>);
  var
    I: Integer;
  begin
    for I := 0 to ASecondaryAxes.Count - 1 do
      ASecondaryAxes[I].MinorGridlines.Draw(ACanvas);
    AAxis.ViewInfo.MinorGridlines.Draw(ACanvas);
  end;

begin
  InternalDraw(Diagram.Axes.AxisX, DiagramViewInfo.SecondaryAxesX);
  InternalDraw(Diagram.Axes.AxisY, DiagramViewInfo.SecondaryAxesY);
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetHitPlotArea(const P: TdxPointF): IdxChartHitTestPlotAreaElement;
begin
  if FHitElement = nil then
    FHitElement := TdxChartXYDiagramPlotAreaHitElement.Create(DiagramViewInfo);
  Result := FHitElement;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetAppearance: TdxChartXYDiagramAppearance;
begin
  Result := TdxChartXYDiagramAppearance(Diagram.Appearance);
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetBorderColor: TdxAlphaColor;
begin
  Result := Appearance.ActualPlotAreaBorderColor;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetBorderThickness: Single;
begin
  Result := Appearance.PlotAreaBorderThickness;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetBorderVisible: Boolean;
begin
  Result := Appearance.PlotAreaBorder;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetDiagramViewInfo: TdxChartXYDiagramViewInfo;
begin
  Result := TdxChartXYDiagramViewInfo(Diagram.ViewInfo);
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetAxisXGridlines: TdxChartAxisGridlinesViewInfo;
begin
  Result := DiagramViewInfo.AxisXViewInfo.Gridlines;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetAxisXInterlacedItems: TdxFastObjectList;
begin
  Result := DiagramViewInfo.AxisXViewInfo.InterlacedItems;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetAxisXMinorGridlines: TdxChartAxisGridlinesViewInfo;
begin
  Result := DiagramViewInfo.AxisXViewInfo.MinorGridlines;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetAxisYGridlines: TdxChartAxisGridlinesViewInfo;
begin
  Result := DiagramViewInfo.AxisYViewInfo.Gridlines;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetAxisYInterlacedItems: TdxFastObjectList;
begin
  Result := DiagramViewInfo.AxisYViewInfo.InterlacedItems;
end;

function TdxChartXYDiagramPlotAreaViewInfo.GetAxisYMinorGridlines: TdxChartAxisGridlinesViewInfo;
begin
  Result := DiagramViewInfo.AxisYViewInfo.MinorGridlines;
end;

{ TdxChartXYDiagramPlotAreaHitElement }

constructor TdxChartXYDiagramPlotAreaHitElement.Create(ADiagramViewInfo: TdxChartXYDiagramViewInfo);
begin
  inherited Create;
  FDiagramViewInfo := ADiagramViewInfo;
end;

procedure TdxChartXYDiagramPlotAreaHitElement.GetDataPointFromCanvasPoint(const P: TdxPointF; out AArgument, AValue: Variant);
var
  ARawArgument, ARawValue: Double;
begin
  if FDiagramViewInfo.Diagram.Rotated then
  begin
    ARawArgument := FDiagramViewInfo.AxisXViewInfo.CanvasValueToDataValue(P.Y);
    ARawValue := FDiagramViewInfo.AxisYViewInfo.CanvasValueToDataValue(P.X);
  end
  else
  begin
    ARawArgument := FDiagramViewInfo.AxisXViewInfo.CanvasValueToDataValue(P.X);
    ARawValue := FDiagramViewInfo.AxisYViewInfo.CanvasValueToDataValue(P.Y);
  end;
  AArgument := FDiagramViewInfo.AxisXViewInfo.ViewData.DoubleToAxisValue(ARawArgument);
  AValue := FDiagramViewInfo.AxisYViewInfo.ViewData.DoubleToAxisValue(ARawValue);
end;

function TdxChartXYDiagramPlotAreaHitElement.GetPlotArea: TObject;
begin
  Result := FDiagramViewInfo.PlotAreaViewInfo;
end;

procedure TdxChartXYDiagramPlotAreaHitElement.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ADiagram: TdxChartXYDiagram;
begin
  ADiagram := FDiagramViewInfo.Diagram;
  TdxChartAccess(ADiagram.Chart).CrosshairController.ShowCrosshair(ADiagram, TdxPointF.Create(X, Y));
end;

procedure TdxChartXYDiagramPlotAreaHitElement.MouseLeave;
var
  ADiagram: TdxChartXYDiagram;
begin
  ADiagram := FDiagramViewInfo.Diagram;
  TdxChartAccess(ADiagram.Chart).CrosshairController.HideCrosshair(ADiagram);
end;


{ TdxChartXYDiagramSeriesGroup }

procedure TdxChartXYDiagramSeriesGroup.BeforeCalculate;
begin
  FMaxValue := NaN;
  FMinValue := NaN;
  TdxChartXYDiagramViewData(Owner).Diagram.Axes.AxisX.ViewData.AsyncCalculateValues;
end;

procedure TdxChartXYDiagramSeriesGroup.CheckValue(
  const AValue: Double; var AMinValue, AMaxValue: Double);
begin
  if IsNan(AValue) then
    Exit;
  CheckMin(AMinValue, AValue);
  CheckMax(AMaxValue, AValue);
end;

procedure TdxChartXYDiagramSeriesGroup.DoCalculate;
var
  I: Integer;
  AView: TdxChartXYSeriesCustomView;
  AViewData: TdxChartXYSeriesViewCustomViewData;
  AViewInfo: TdxChartXYSeriesViewCustomViewInfo;
begin
  for I := 0 to Count - 1 do
  begin
    AView := TdxChartXYSeriesCustomView(TdxChartXYSeries(List[I]).View);
    AViewInfo := TdxChartXYSeriesViewCustomViewInfo(AView.ViewInfo);
    AViewData := TdxChartXYSeriesViewCustomViewData(AView.ViewData);
    if (AViewInfo.Count > 0) and (AViewData.MinValue <> nil) then
    begin
      CheckValue(AViewData.MinValue.Value, FMinValue, FMaxValue);
      AViewData.ValidateStackedMinMax(TdxChartXYSeriesValueViewInfo(AViewData.MinValue));
      CheckValue(AViewData.MaxValue.Value, FMinValue, FMaxValue);
      AViewData.ValidateStackedMinMax(TdxChartXYSeriesValueViewInfo(AViewData.MaxValue));
      DoCheckBoundsValuesForZeroBase(AView);
    end;
  end;
end;

procedure TdxChartXYDiagramSeriesGroup.DoCheckBoundsValuesForZeroBase(AView: TdxChartXYSeriesCustomView);
begin
  if not AView.IsZeroBased then
    Exit;
  FMinValue := Min(0, FMinValue);
  FMaxValue := Max(0, FMaxValue);
end;

procedure TdxChartXYDiagramSeriesGroup.ForEachValue(AProc: TdxChartForEachXYValueProc);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    TdxChartXYSeriesViewCustomViewInfo(TdxChartXYSeriesCustomView(Views[I]).ViewInfo).ForEachValue(
      procedure(AValue: TdxChartSeriesValueViewInfo)
      begin
        AProc(TdxChartXYSeriesValueViewInfo(AValue));
      end);
end;

procedure TdxChartXYDiagramSeriesGroup.GetDataTypes(var AValueType, AArgumentType: TVarType);

   procedure GetVarType(AStorageItem: TdxStorageItem; var AVarType: TVarType);
   begin
     if (AStorageItem <> nil) and (AStorageItem.ValueTypeClass <> nil) then
       AVarType := AStorageItem.ValueTypeClass.GetVarType;
   end;

var
  AViewData: TdxChartXYSeriesViewCustomViewData;
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if (AValueType <> varEmpty) and (AArgumentType <> varEmpty) then
      Break;
    if not TdxChartXYSeries(Series[I]).ActuallyVisible then
      Continue;
    AViewData := TdxChartXYSeriesViewCustomViewData(TdxChartXYSeriesCustomView(Views[I]).ViewData);
    GetVarType(AViewData.ArgumentField, AArgumentType);
    GetVarType(AViewData.ValueField, AValueType);
  end;
end;

{ TdxChartXYDiagramStackedSeriesGroup }

constructor TdxChartXYDiagramStackedSeriesGroup.Create(
  AOwner: TdxChartDiagramCustomViewData; AMasterSeries: TdxChartCustomSeries);
begin
  inherited Create(AOwner, AMasterSeries);
  FValuesMap := TObjectDictionary<TdxChartXYSeriesValueViewInfo,
    TStackedValue>.Create([doOwnsValues], TdxChartNumericValueComparer.Create);
end;

destructor TdxChartXYDiagramStackedSeriesGroup.Destroy;
begin
  FreeAndNil(FValuesMap);
  inherited Destroy;
end;

function TdxChartXYDiagramStackedSeriesGroup.TStackedValue.ProcessValue(AValue: TdxChartXYSeriesValueViewInfo; AStackingStyle: TSeriesStackingStyle): Double;
begin
  if IsNan(AValue.SourceValue) then
    Exit(NaN);
  case AStackingStyle of
    TSeriesStackingStyle.StackPositiveValues:
      Result := StackValue(AValue, Max(0, AValue.SourceValue), StackedPositiveValue);
    TSeriesStackingStyle.StackNegativeValues:
      Result := StackValue(AValue, Min(0, AValue.SourceValue), StackedNegativeValue);
    TSeriesStackingStyle.PerPoint:
      if AValue.SourceValue >= 0 then
        Result := StackValue(AValue, AValue.SourceValue, StackedPositiveValue)
      else
        Result := StackValue(AValue, AValue.SourceValue, StackedNegativeValue);
  else
    Result := NaN; 
  end;
end;

function TdxChartXYDiagramStackedSeriesGroup.TStackedValue.StackValue(
  AValueViewInfo: TdxChartXYSeriesValueViewInfo; AActualValue: Double; var ABaseValue: Double): Double;
begin
  AValueViewInfo.FBaseValue := ABaseValue;
  ABaseValue := ABaseValue + AActualValue;
  AValueViewInfo.FValue := ABaseValue;
  Result := ABaseValue;
end;

procedure TdxChartXYDiagramStackedSeriesGroup.BeforeCalculate;
begin
  FValuesMap.Clear;
  inherited BeforeCalculate;
end;

procedure TdxChartXYDiagramStackedSeriesGroup.CheckViewInfoValue(
  AValue: TdxChartXYSeriesValueViewInfo; AStackingStyle: TSeriesStackingStyle; var AMinValue, AMaxValue: Double);
var
  AStackedValue: TStackedValue;
begin
  if not FValuesMap.TryGetValue(AValue, AStackedValue) then
  begin
    AStackedValue := TStackedValue.Create();
    FValuesMap.Add(AValue, AStackedValue);
  end;
  CheckValue(AStackedValue.ProcessValue(AValue, AStackingStyle), FMinValue, FMaxValue);
  TdxChartXYSeriesViewCustomViewData(AValue.ViewData).ValidateStackedMinMax(AValue);
end;

procedure TdxChartXYDiagramStackedSeriesGroup.DoCalculate;
var
  I: Integer;
  AStackingStyle: TSeriesStackingStyle;
  AView: TdxChartXYSeriesCustomView;
  AViewData: TdxChartXYSeriesViewCustomViewData;
begin
  for I := 0 to Count - 1 do
  begin
    AView := TdxChartXYSeriesCustomView(Views[I]);
    AViewData := TdxChartXYSeriesViewCustomViewData(AView.ViewData);
    if AViewData.MinValue = nil then
      Continue;
    if AView.GetNegativeValuesStackingStyle = TdxChartXYSeriesCustomView.TNegativeValuesStackingStyle.StackAlways then
      AStackingStyle := TSeriesStackingStyle.PerPoint
    else
    begin
      if (TdxChartXYSeriesValueViewInfo(AViewData.MinValue).SourceValue < 0) and (TdxChartXYSeriesValueViewInfo(AViewData.MaxValue).SourceValue <= 0) then
        AStackingStyle := TSeriesStackingStyle.StackNegativeValues
      else
        AStackingStyle := TSeriesStackingStyle.StackPositiveValues;
    end;
    AView.ViewInfo.ForEachValue(
      procedure(AValue: TdxChartSeriesValueViewInfo)
      begin
        if AValue.Visible then
        begin
          CheckViewInfoValue(TdxChartXYSeriesValueViewInfo(AValue), AStackingStyle, FMinValue, FMaxValue);
          DoCheckBoundsValuesForZeroBase(AView);
        end;
      end);
  end;
end;

function TdxChartXYDiagramStackedSeriesGroup.EnableReverseOrder: Boolean;
begin
  Result := False;
end;

{ TdxChartXYDiagramFullStackedSeriesGroup }

procedure TdxChartXYDiagramFullStackedSeriesGroup.AfterCalculate;
begin
  FMinValue := 0;
  FMaxValue := 0;
  ForEachValue(
    procedure(AValue: TdxChartXYSeriesValueViewInfo)
    var
      AStackedValue: TStackedValue;
      ASum: Double;
    begin
      if not (TdxChartXYSeriesValueViewInfo.TValueState.Visible in AValue.FState) then
        Exit;
      FValuesMap.TryGetValue(AValue, AStackedValue);
      ASum := AStackedValue.StackedPositiveValue - AStackedValue.StackedNegativeValue;
      if IsZero(ASum) then
      begin
        AValue.FValue := 0;
        AValue.FBaseValue := 0;
      end
      else
      begin
        AValue.FValue := AValue.FValue * 100 / ASum;
        AValue.FBaseValue := AValue.FBaseValue * 100 / ASum;
      end;
      CheckValue(AValue.Value, FMinValue, FMaxValue);
    end
  );
end;

{ TdxChartXYDiagramViewData }

procedure TdxChartXYDiagramViewData.DoCalculate;
var
  I: Integer;
  AGroup: TdxChartXYDiagramSeriesGroup;
begin
  FMaxValue := NaN;
  FMinValue := NaN;
  inherited DoCalculate;
  //
  for I := 0 to GroupCount - 1 do
  begin
    AGroup := TdxChartXYDiagramSeriesGroup(Groups[I]);
    if IsNan(AGroup.MinValue) then
      Continue;
    CheckMinMax(FMinValue, FMaxValue, AGroup.MinValue, AGroup.MaxValue);
  end;
  if IsNan(FMinValue) then
    CheckMinMax(FMinValue, FMaxValue,  0, 0);
  //
  Diagram.Axes.AxisX.ViewData.Calculate;
  Diagram.Axes.AxisY.ViewData.Calculate;
end;

function TdxChartXYDiagramViewData.GetSeriesGroupClass(
  ASeries: TdxChartCustomSeries): TdxChartDiagramSeriesGroupClass;
const
  AClasses: array[TdxChartXYSeriesCustomView.TValuesStacking] of TdxChartDiagramSeriesGroupClass =
    (TdxChartXYDiagramSeriesGroup, TdxChartXYDiagramStackedSeriesGroup, TdxChartXYDiagramFullStackedSeriesGroup);
begin
  Result := AClasses[TdxChartXYSeriesCustomView(ASeries.View).GetValuesStacking];
end;

function TdxChartXYDiagramViewData.IsReverseOrder: Boolean;
begin
  Result := Diagram.Axes.AxisX.Reverse;
end;

function TdxChartXYDiagramViewData.GetDiagram: TdxChartXYDiagram;
begin
  Result := TdxChartXYDiagram(inherited Diagram);
end;

procedure TdxChartXYDiagramViewData.MakeDirty;
begin
  inherited MakeDirty;
  if Diagram.Axes <> nil then   
  begin
    Diagram.Axes.AxisX.ViewData.MakeDirty;
    Diagram.Axes.AxisY.ViewData.MakeDirty;
  end;
end;

{ TdxChartXYDiagramViewInfo }

constructor TdxChartXYDiagramViewInfo.Create(AOwner: TdxChartCustomDiagram);
begin
  inherited Create(AOwner);
  FPlotAreaViewInfo := TdxChartXYDiagramPlotAreaViewInfo.Create(Diagram);
  FSecondaryAxesX := TObjectList<TdxChartAxisViewInfo>.Create(False);
  FSecondaryAxesY := TObjectList<TdxChartAxisViewInfo>.Create(False);
  FSelectionViewInfo := TdxChartXYDiagramSelectionViewInfo.Create;
  FSelectionViewInfo.Visible := False;
  MutableItems.Add(FSelectionViewInfo);
  Dirty := True;
end;

destructor TdxChartXYDiagramViewInfo.Destroy;
begin
  FreeAndNil(FSelectionViewInfo);
  FreeAndNil(FSecondaryAxesX);
  FreeAndNil(FSecondaryAxesY);
  FreeAndNil(FPlotAreaViewInfo);
  inherited Destroy;
end;

function TdxChartXYDiagramViewInfo.IsZoomed: Boolean;
begin
  Result := AxisXViewInfo.Axis.Range.IsZoomed or AxisYViewInfo.Axis.Range.IsZoomed;
end;

procedure TdxChartXYDiagramViewInfo.BeforeAxesCalculate(ACanvas: TcxCustomCanvas);
begin
  FAxisXViewInfo := Diagram.Axes.AxisX.ViewInfo;
  FAxisYViewInfo := Diagram.Axes.AxisY.ViewInfo;
  PrepareCustomAxisViewInfo(AxisXViewInfo, ACanvas);
  PrepareCustomAxisViewInfo(AxisYViewInfo, ACanvas);

  PrepareSecondaryAxes(True, ACanvas);
  PrepareSecondaryAxes(False, ACanvas);

  PrepareSecondaryAxesIndents(True, FNearEdgeAxisX, FFarEdgeAxisX);
  PrepareSecondaryAxesIndents(False, FNearEdgeAxisY, FFarEdgeAxisY);
end;

procedure TdxChartXYDiagramViewInfo.CalculateAxes(ACanvas: TcxCustomCanvas);

  procedure InternalCalculate(AViewInfo: TdxChartAxisViewInfo; ASecondaryIndex: Integer;
    var APlotArea: TdxRectF; var ANeedCalculationRestart: Boolean);
  begin
    AViewInfo.Calculate(ACanvas);
    if AViewInfo.Axis.IsNearAlignment or AViewInfo.Axis.IsFarAlignment then
      CorrectAvailableAreas(AViewInfo, ASecondaryIndex, APlotArea, ANeedCalculationRestart)
    else
      if AViewInfo.Axis.IsZeroAlignment and not AViewInfo.IsCentered then  
        OffsetIntoItProjection(AViewInfo, APlotArea, ANeedCalculationRestart);
  end;

  procedure PrepareAxesForCalculationRestart;
  begin
    PrepareCustomAxisViewInfo(AxisXViewInfo, ACanvas);
    PrepareCustomAxisViewInfo(AxisYViewInfo, ACanvas);
    PrepareSecondaryAxes(True, ACanvas);
    PrepareSecondaryAxes(False, ACanvas);
  end;

  function HasDirty: Boolean;
  begin
    Result := AxisXViewInfo.Dirty or AxisYViewInfo.Dirty or IsSecondaryAxesXDirty or IsSecondaryAxesYDirty;
  end;

  procedure UpdateGridlinesAndInterlacedItems;
  var
    I: Integer;
  begin
    AxisXViewInfo.UpdateGridlinesAndInterlacedItems(PlotArea);
    for I := 0 to SecondaryAxesX.Count - 1 do
      SecondaryAxesX[I].UpdateGridlinesAndInterlacedItems(PlotArea);

    AxisYViewInfo.UpdateGridlinesAndInterlacedItems(PlotArea);
    for I := 0 to SecondaryAxesY.Count - 1 do
      SecondaryAxesY[I].UpdateGridlinesAndInterlacedItems(PlotArea);
  end;

var
  APlotArea: TdxRectF;
  ANeedCalculationRestart: Boolean;
  I: Integer;
begin
  APlotArea := PlotArea;
  while HasDirty do
  begin
    ANeedCalculationRestart := False;
    for I := SecondaryAxesX.Count - 1 downto 0 do
      InternalCalculate(SecondaryAxesX[I], I, APlotArea, ANeedCalculationRestart);
    InternalCalculate(AxisXViewInfo, -1, APlotArea, ANeedCalculationRestart);
    if ANeedCalculationRestart then
      PrepareAxesForCalculationRestart
    else
      if HasDirty then
      begin
        for I := SecondaryAxesY.Count - 1 downto 0 do
          InternalCalculate(SecondaryAxesY[I], I, APlotArea, ANeedCalculationRestart);
        InternalCalculate(AxisYViewInfo, -1, APlotArea, ANeedCalculationRestart);
        if ANeedCalculationRestart then
          PrepareAxesForCalculationRestart;
      end;
  end;
  SetPlotArea(APlotArea);
  if (SecondaryAxesX.Count > 0) or (SecondaryAxesY.Count > 0) or
      AxisXViewInfo.Axis.IsZeroAlignment or AxisYViewInfo.Axis.IsZeroAlignment then
    UpdateGridlinesAndInterlacedItems;
  ResolveAxisLabelsOverlapping;
end;

function TdxChartXYDiagramViewInfo.CalculateChartHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
begin
  Result := inherited CalculateChartHitTest(AHitTest, P);
  PlotAreaViewInfo.CalculateHitTest(AHitTest, P);
  if not Result then
    Result := AxisXViewInfo.ActuallyVisible and AxisXViewInfo.CalculateHitTest(AHitTest, P);
  if not Result then
    Result := AxisYViewInfo.ActuallyVisible and AxisYViewInfo.CalculateHitTest(AHitTest, P);
end;

procedure TdxChartXYDiagramViewInfo.CalculateViews(ACanvas: TcxCustomCanvas);
begin
  BeforeAxesCalculate(ACanvas);
  CalculateAxes(ACanvas);

  PlotAreaViewInfo.Dirty := True;
  PlotAreaViewInfo.UpdateBounds(ContentBounds, ContentBounds);
  PlotAreaViewInfo.Calculate(ACanvas);

  inherited CalculateViews(ACanvas); 
  ResolveValueLabelsOverlapping;
end;

function TdxChartXYDiagramViewInfo.CheckNeedCalculationRestart(ACurrentAxis: TdxChartCustomAxis): Boolean;

  procedure UpdateActualSecondaryAxisIndent(var AAxis: TdxChartCustomAxis);
  begin
    AAxis.ViewInfo.UpdateActualSecondaryAxisIndent(AAxis.DefaultSecondaryAxisIndent);
    AAxis := ACurrentAxis;
    Result := True;
  end;

begin
  Result := False;
  if ACurrentAxis.IsZeroAlignment then
    if ACurrentAxis.IsArgumentAxis then
    begin
      if ACurrentAxis.ViewInfo.CalculationHelper.IsNear and (FNearEdgeAxisX <> nil) and FNearEdgeAxisX.IsSecondary then
        UpdateActualSecondaryAxisIndent(FNearEdgeAxisX)
      else
      if ACurrentAxis.ViewInfo.CalculationHelper.IsFar and (FFarEdgeAxisX <> nil) and FFarEdgeAxisX.IsSecondary then
        UpdateActualSecondaryAxisIndent(FFarEdgeAxisX);
    end
    else
    begin
      if ACurrentAxis.ViewInfo.CalculationHelper.IsNear and (FNearEdgeAxisY <> nil) and FNearEdgeAxisY.IsSecondary then
        UpdateActualSecondaryAxisIndent(FNearEdgeAxisY)
      else
      if ACurrentAxis.ViewInfo.CalculationHelper.IsFar and (FFarEdgeAxisY <> nil) and FFarEdgeAxisY.IsSecondary then
        UpdateActualSecondaryAxisIndent(FFarEdgeAxisY);
    end
end;

procedure TdxChartXYDiagramViewInfo.CorrectAvailableAreas(ACurrentAxis: TdxChartAxisViewInfo; ASecondaryIndex: Integer;
  var APlotArea: TdxRectF; var ANeedCalculationRestart: Boolean);

  procedure CorrectAxisAvailableBounds(AAxis: TdxChartAxisViewInfo);
  var
    ABounds: TdxRectF;
  begin
    ABounds := AAxis.AvailableBounds;
    ACurrentAxis.CorrectAvailableArea(ABounds);
    if AreaWasDecrease(ABounds, AAxis.AvailableBounds) then         
      AAxis.SetAvailableBounds(ABounds, True);
  end;

var
  ASameDirectionAxis, AOrthogonalAxis: TdxChartAxisViewInfo;
  ASameDirectionAxes, AOrthogonalAxes: TObjectList<TdxChartAxisViewInfo>;
  ANewPlotArea: TdxRectF;
  I: Integer;
begin
  if ACurrentAxis.Axis.IsArgumentAxis then
  begin
    ASameDirectionAxis := AxisXViewInfo;
    AOrthogonalAxis := AxisYViewInfo;
    ASameDirectionAxes := SecondaryAxesX;
    AOrthogonalAxes := SecondaryAxesY;
  end
  else
  begin
    ASameDirectionAxis := AxisYViewInfo;
    AOrthogonalAxis := AxisXViewInfo;
    ASameDirectionAxes := SecondaryAxesY;
    AOrthogonalAxes := SecondaryAxesX;
  end;

  ANeedCalculationRestart := CheckNeedCalculationRestart(ACurrentAxis.Axis);
  if not ANeedCalculationRestart then
  begin
    ANewPlotArea := APlotArea;
    ACurrentAxis.CorrectAvailableArea(ANewPlotArea);
    if AreaWasDecrease(ANewPlotArea, APlotArea) then
      APlotArea := ANewPlotArea;

    if ASecondaryIndex >= 0 then
    begin
      for I := ASecondaryIndex - 1 downto 0 do
        CorrectAxisAvailableBounds(ASameDirectionAxes.Items[I]);
      CorrectAxisAvailableBounds(ASameDirectionAxis);
    end;

    for I := 0 to AOrthogonalAxes.Count - 1 do
      CorrectAxisAvailableBounds(AOrthogonalAxes.Items[I]);
    CorrectAxisAvailableBounds(AOrthogonalAxis);
  end;
end;

function TdxChartXYDiagramViewInfo.AdjustPlotAreaByLabelsBounding(ACanvas: TcxCustomCanvas): Boolean;
const
  PlotAreaOffset = 2;
var
  AContentRect, ANewPlotArea: TdxRectF;
  ADelta: Single;
  AVerticalAxisViewInfo, AHorizontalAxisViewInfo: TdxChartAxisViewInfo;
  AVerticalSecondaryAxes, AHorizontalSecondaryAxes: TObjectList<TdxChartAxisViewInfo>;
  I: Integer;
begin
  AContentRect := GetContentRect;
  if TitleViewInfo.ActuallyVisible then
    TitleViewInfo.AdjustContent(AContentRect);
  if IsOutsideLegend then
    TdxChartCustomLegendAccess(Legend).CalculateAndAdjustContent(ACanvas, AContentRect);
  ANewPlotArea := AContentRect;

  if Diagram.Rotated then
  begin
    AVerticalAxisViewInfo := AxisXViewInfo;
    AVerticalSecondaryAxes := SecondaryAxesX;
    AHorizontalAxisViewInfo := AxisYViewInfo;
    AHorizontalSecondaryAxes := SecondaryAxesY;
  end
  else
  begin
    AVerticalAxisViewInfo := AxisYViewInfo;
    AVerticalSecondaryAxes := SecondaryAxesY;
    AHorizontalAxisViewInfo := AxisXViewInfo;
    AHorizontalSecondaryAxes := SecondaryAxesX;
  end;

  if not AVerticalAxisViewInfo.Axis.Range.IsZoomed then
  begin
    if LabelsBoundingRect.Top < ANewPlotArea.Top then
    begin
      ADelta := ANewPlotArea.Top - LabelsBoundingRect.Top;
      if ADelta > 0 then
      begin
        ANewPlotArea.Top := PlotArea.Top + ADelta + PlotAreaOffset;
        if (AHorizontalAxisViewInfo.Axis.Alignment = TdxChartAxisAlignment.Far) and AHorizontalAxisViewInfo.Axis.ActuallyVisible then
          ANewPlotArea.Top := ANewPlotArea.Top - AHorizontalAxisViewInfo.Bounds.Height;
        for I := 0 to AHorizontalSecondaryAxes.Count - 1 do
          if (AHorizontalSecondaryAxes[I].Axis.Alignment = TdxChartAxisAlignment.Far) and AHorizontalSecondaryAxes[I].Axis.ActuallyVisible then
            ANewPlotArea.Top := ANewPlotArea.Top - AHorizontalSecondaryAxes[I].Bounds.Height;
      end;
    end;

    if LabelsBoundingRect.Bottom > ANewPlotArea.Bottom then
    begin
      ADelta := LabelsBoundingRect.Bottom - ANewPlotArea.Bottom;
      if ADelta > 0 then
      begin
        ANewPlotArea.Bottom := PlotArea.Bottom - ADelta - PlotAreaOffset;
        if (AHorizontalAxisViewInfo.Axis.Alignment = TdxChartAxisAlignment.Near) and AHorizontalAxisViewInfo.Axis.ActuallyVisible then
          ANewPlotArea.Bottom := ANewPlotArea.Bottom + AHorizontalAxisViewInfo.Bounds.Height;
        for I := 0 to AHorizontalSecondaryAxes.Count - 1 do
          if (AHorizontalSecondaryAxes[I].Axis.Alignment = TdxChartAxisAlignment.Near) and AHorizontalSecondaryAxes[I].Axis.ActuallyVisible then
            ANewPlotArea.Bottom := ANewPlotArea.Bottom + AHorizontalSecondaryAxes[I].Bounds.Height;
      end;
    end;
  end;

  if not AHorizontalAxisViewInfo.Axis.Range.IsZoomed then
  begin
    if LabelsBoundingRect.Left < ANewPlotArea.Left then
    begin
      ADelta := ANewPlotArea.Left - LabelsBoundingRect.Left;
      if ADelta > 0 then
      begin
        ANewPlotArea.Left := PlotArea.Left + ADelta + PlotAreaOffset;
        if (AVerticalAxisViewInfo.Axis.Alignment = TdxChartAxisAlignment.Near) and AVerticalAxisViewInfo.Axis.ActuallyVisible then
          ANewPlotArea.Left := ANewPlotArea.Left - AVerticalAxisViewInfo.Bounds.Width;
        for I := 0 to AVerticalSecondaryAxes.Count - 1 do
          if (AVerticalSecondaryAxes[I].Axis.Alignment = TdxChartAxisAlignment.Near) and AVerticalSecondaryAxes[I].Axis.ActuallyVisible then
            ANewPlotArea.Left := ANewPlotArea.Left - AVerticalSecondaryAxes[I].Bounds.Width;
      end;
    end;

    if LabelsBoundingRect.Right > ANewPlotArea.Right then
    begin
      ADelta := LabelsBoundingRect.Right - ANewPlotArea.Right;
      if ADelta > 0 then
      begin
        ANewPlotArea.Right := PlotArea.Right - ADelta - PlotAreaOffset;
        if (AVerticalAxisViewInfo.Axis.Alignment = TdxChartAxisAlignment.Far) and AVerticalAxisViewInfo.Axis.ActuallyVisible then
          ANewPlotArea.Right := ANewPlotArea.Right + AVerticalAxisViewInfo.Bounds.Width;
        for I := 0 to AVerticalSecondaryAxes.Count - 1 do
          if (AVerticalSecondaryAxes[I].Axis.Alignment = TdxChartAxisAlignment.Far) and AVerticalSecondaryAxes[I].Axis.ActuallyVisible then
            ANewPlotArea.Right := ANewPlotArea.Right + AVerticalSecondaryAxes[I].Bounds.Width;
      end;
    end;
  end;

  Result := ANewPlotArea <> AContentRect;
  if Result then
    SetPlotArea(ANewPlotArea);
end;

procedure TdxChartXYDiagramViewInfo.ResolveAxisLabelsOverlapping;
var
  I: Integer;
begin
  for I := 0 to SecondaryAxesX.Count - 1 do
    SecondaryAxesX[I].ResolveLabelsOverlapping(FAxisYViewInfo.Axis, Diagram.SecondaryAxes.AxesY);
  for I := 0 to SecondaryAxesY.Count - 1 do
    SecondaryAxesY[I].ResolveLabelsOverlapping(FAxisXViewInfo.Axis, Diagram.SecondaryAxes.AxesX);
  FAxisXViewInfo.ResolveLabelsOverlapping(FAxisYViewInfo.Axis, Diagram.SecondaryAxes.AxesY);
  FAxisYViewInfo.ResolveLabelsOverlapping(FAxisXViewInfo.Axis, Diagram.SecondaryAxes.AxesX);
end;

procedure TdxChartXYDiagramViewInfo.ResolveValueLabelsOverlapping;
var
  I, K, AIndex: Integer;
  ALabelsList: TdxChartXYSeriesValueLabelViewInfoList;
  AIndent: Single;

  function CalculateDiagramBounds: TdxRectF;
  var
    I: Integer;
  begin
    Result := PlotArea;
    if AxisXViewInfo.ActuallyVisible then
      Result.Union(AxisXViewInfo.Bounds);
    if AxisYViewInfo.ActuallyVisible then
      Result.Union(AxisYViewInfo.Bounds);
    for I := 0 to SecondaryAxesX.Count - 1 do
      if SecondaryAxesX[I].ActuallyVisible then
        Result.Union(SecondaryAxesX[I].Bounds);
    for I := 0 to SecondaryAxesY.Count - 1 do
      if SecondaryAxesY[I].ActuallyVisible then
        Result.Union(SecondaryAxesY[I].Bounds);
  end;

  procedure PopulateNonOverlappingSeriesLabels(ASeries: TdxChartXYSeries);
  var
    AIndex, I, K: Integer;
    ATempLabelsList: TdxChartXYSeriesValueLabelViewInfoList;
    AResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode;
  begin
    AResolveOverlappingMode := ASeries.View.ValueLabels.GetResolveOverlappingMode;
    if ASeries.ActuallyVisible and (AResolveOverlappingMode <> TdxChartSeriesValueLabelsResolveOverlappingMode.None) then
    begin
      ATempLabelsList := TdxChartXYSeriesValueLabelViewInfoList.Create;
      try
        ASeries.View.ViewInfo.GetVisibleValueLabels(ATempLabelsList);
        AIndex := ATempLabelsList.Count div 2;
        if AResolveOverlappingMode = TdxChartSeriesValueLabelsResolveOverlappingMode.HideOverlapped then
        begin
          I := 0;
          K := ATempLabelsList.Count - 1;
          while I <= K do
          begin
            ALabelsList.Add(ATempLabelsList[I]);
            if K <> I then
              ALabelsList.Add(ATempLabelsList[K]);
            Inc(I);
            Dec(K);
          end;
        end
        else
        begin
          I := AIndex;
          K := AIndex - 1;
          while (I < ATempLabelsList.Count) or (K >= 0) do
          begin
            if I < ATempLabelsList.Count then
              ALabelsList.Add(ATempLabelsList[I]);
            if K >= 0 then
              ALabelsList.Add(ATempLabelsList[K]);
            Inc(I);
            Dec(K);
          end;
        end;
      finally
        ATempLabelsList.Free;
      end;
    end;
  end;

begin
  if (SeriesCount = 0) or (PlotArea.Width < 5) or (PlotArea.Height < 5) then
    Exit;
  ALabelsList := TdxChartXYSeriesValueLabelViewInfoList.Create;
  try
    AIndex := SeriesCount div 2;
    I := AIndex;
    K := AIndex - 1;
    while (I < SeriesCount) or (K >= 0) do
    begin
      if I < SeriesCount then
        PopulateNonOverlappingSeriesLabels(TdxChartXYSeries(Series[I]));
      if K >= 0 then
        PopulateNonOverlappingSeriesLabels(TdxChartXYSeries(Series[K]));
      Inc(I);
      Dec(K);
    end;

    if ALabelsList.Count > 0 then
    begin
      ALabelsList.SortList(
        function (AItem1, AItem2: Pointer): Integer
        var
          ASize1, ASize2: TSize;
        begin
          ASize1 := TdxChartXYSeriesValueLabelViewInfo(AItem1).Bounds.Size;
          ASize2 := TdxChartXYSeriesValueLabelViewInfo(AItem2).Bounds.Size;
          Result := CompareValue(ASize1.Width * ASize1.Height, ASize2.Width * ASize2.Height);
        end);

      AIndent := Series[0].View.ValueLabels.ResolveOverlappingIndent;
      TdxChartXYSeriesValueLabelsOverlappingResolver.Arrange(ALabelsList, CalculateDiagramBounds, AIndent);

      ResetLabelsBoundingRect;
      for I := 0 to SeriesCount - 1 do
        TdxChartXYSeriesCustomView(Series[I].View).ViewInfo.UpdateLabelsBoundingRect;
    end;
  finally
    ALabelsList.Free;
  end;
end;

procedure TdxChartXYDiagramViewInfo.DrawChart(ACanvas: TcxCustomCanvas);
begin
  if ActuallyVisible and ACanvas.RectVisible(PlotAreaViewInfo.ClipRect) then
  begin
    PlotAreaViewInfo.Draw(ACanvas);
    ACanvas.SaveClipRegion;
    try
      ACanvas.IntersectClipRect(PlotArea);
      Items.Draw(ACanvas);
    finally
      ACanvas.RestoreClipRegion;
    end;
  end;
end;

procedure TdxChartXYDiagramViewInfo.DrawSecondLayer(ACanvas: TcxCustomCanvas);
var
  AClipRect: TdxRectF;
begin
  Diagram.SecondaryAxes.Draw(ACanvas);
  Diagram.Axes.Draw(ACanvas);
  if ActuallyVisible and ACanvas.RectVisible(PlotAreaViewInfo.ClipRect) then
  begin
    ACanvas.SaveClipRegion;
    try
      AClipRect := GetContentRect;
      if TitleViewInfo.Visible then
        TitleViewInfo.AdjustContent(AClipRect);
      if (AxisXViewInfo.Axis.Range.IsZoomed and not Diagram.Rotated) or
        (AxisYViewInfo.Axis.Range.IsZoomed and Diagram.Rotated) then
      begin
        AClipRect.Left := PlotArea.Left;
        AClipRect.Right := PlotArea.Right;
      end;
      if (AxisYViewInfo.Axis.Range.IsZoomed and not Diagram.Rotated) or
        (AxisXViewInfo.Axis.Range.IsZoomed and Diagram.Rotated) then
      begin
        AClipRect.Top := PlotArea.Top;
        AClipRect.Bottom := PlotArea.Bottom;
      end;
      ACanvas.IntersectClipRect(AClipRect);
      DrawValuesLabels(ACanvas);
    finally
      ACanvas.RestoreClipRegion;
    end;
  end;
end;

procedure TdxChartXYDiagramViewInfo.EnableExportMode(AEnable: Boolean);
var
  I: Integer;
begin
  inherited EnableExportMode(AEnable);
  AxisXViewInfo.EnableExportMode(AEnable);
  AxisYViewInfo.EnableExportMode(AEnable);
  for I := 0 to SecondaryAxesX.Count - 1 do
    SecondaryAxesX[I].EnableExportMode(AEnable);
  for I := 0 to SecondaryAxesY.Count - 1 do
    SecondaryAxesY[I].EnableExportMode(AEnable);
end;

function TdxChartXYDiagramViewInfo.GetDiagram: TdxChartXYDiagram;
begin
  Result := TdxChartXYDiagram(inherited Diagram);
end;

function TdxChartXYDiagramViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  Result := inherited GetHitElement(P);
  if (Result.GetHitCode = TdxChartHitCode.Diagram) and PlotAreaViewInfo.Bounds.Contains(P) then
    Result := TdxChartComponentHitElement.Create(Diagram, TdxChartHitCode.PlotArea)
end;

function TdxChartXYDiagramViewInfo.GetHitScrollableElement(const P: TdxPointF): IdxChartHitTestScrollableElement;
begin
  Result := TdxChartXYDiagramScrollableElement.Create(Self);
end;

function TdxChartXYDiagramViewInfo.HasZeroBasedSeries: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to SeriesCount - 1 do
  begin
    Result := TdxChartXYSeriesCustomView(Series[I].View).IsZeroBased;
    if Result then
      Break;
  end;
end;

function TdxChartXYDiagramViewInfo.IsLabelsOutsideOfPlotArea: Boolean;
begin
  Result := inherited and not (AxisXViewInfo.Axis.Range.IsZoomed and AxisYViewInfo.Axis.Range.IsZoomed);
end;

function TdxChartXYDiagramViewInfo.IsSecondaryAxesXDirty: Boolean;
begin
  Result := Diagram.SecondaryAxes.AxesX.Dirty;
end;

function TdxChartXYDiagramViewInfo.IsSecondaryAxesYDirty: Boolean;
begin
  Result := Diagram.SecondaryAxes.AxesY.Dirty;
end;

procedure TdxChartXYDiagramViewInfo.OffsetIntoItProjection(AAxis: TdxChartAxisViewInfo;
  var APlotArea: TdxRectF; var ANeedCalculationRestart: Boolean);

  function GetOrthogonalAxisCanvasZeroValue(AOrthogonalAxis: TdxChartAxisViewInfo;
    ACurrentZeroValue, ATarget: Single; AInIterations: Boolean): Single;
  var
    AAxisBounds, AAvailableBounds: TdxRectF;
  begin
    AAvailableBounds := AOrthogonalAxis.AvailableBounds;
    if not AInIterations then
      AAxis.CorrectAvailableArea(AAvailableBounds)
    else
      AAxis.SetNearTransversalValue(AAvailableBounds,
        AAxis.GetNearTransversalValue(AAvailableBounds) + ATarget - ACurrentZeroValue);
    AOrthogonalAxis.SetAvailableBounds(AAvailableBounds, False);
    AAxisBounds := AOrthogonalAxis.GetAxisBounds;
    AOrthogonalAxis.CalculateVisibleRange(AOrthogonalAxis.GetLongitudinalSize(AAxisBounds.Size));
    Result := AOrthogonalAxis.GetCanvasZeroValue(AAxisBounds);
  end;

  procedure CorrectAvailableBoundsForOrthogonalSecondaryAxes(const APattern: TdxRectF);
  var
    AOrthogonalAxes: TObjectList<TdxChartAxisViewInfo>;
    ASecondaryAxis: TdxChartAxisViewInfo;
    ABounds: TdxRectF;
    I: Integer;
  begin
    if AAxis.Axis.IsArgumentAxis then
      AOrthogonalAxes := SecondaryAxesY
    else
      AOrthogonalAxes := SecondaryAxesX;

    for I := 0 to AOrthogonalAxes.Count - 1 do
    begin
      ASecondaryAxis := AOrthogonalAxes.Items[I];
      ABounds := ASecondaryAxis.AvailableBounds;
      if ASecondaryAxis.CalculationHelper.IsHorizontal then
      begin
        ABounds.Left := APattern.Left;
        ABounds.Right := APattern.Right;
      end
      else
      begin
        ABounds.Top := APattern.Top;
        ABounds.Bottom := APattern.Bottom;
      end;
      ASecondaryAxis.SetAvailableBounds(ABounds, True);
    end;
  end;

var
  ALastValues: array[0..3] of Single;
  AOrthogonalAxis: TdxChartAxisViewInfo;
  ARange: TdxChartRange;
  ACanvasZeroValue, ATarget, AOffset: Single;
  AOrthogonalAxisBounds, AOldAvailableBounds, ABounds: TdxRectF;
  I: Integer;
begin
  AOrthogonalAxis := AAxis.Axis.GetOrthogonalAxis.ViewInfo;
  ARange := AOrthogonalAxis.ViewData.Range;
  if (ARange.VisibleRangeExtended.Min >= 0) or (ARange.VisibleRangeExtended.Max <= 0) then
    CorrectAvailableAreas(AAxis, -1, APlotArea, ANeedCalculationRestart)
  else
  begin
    AOrthogonalAxisBounds := AOrthogonalAxis.GetAxisBounds;
    AOrthogonalAxis.CalculateVisibleRange(AOrthogonalAxis.GetLongitudinalSize(AOrthogonalAxisBounds.Size));
    if AOrthogonalAxis.IsVisibleRangeValid then
    begin
      ATarget := AAxis.GetAxisLineProjectionCanvasValue;
      AOffset := AOrthogonalAxis.GetCanvasZeroValue(AOrthogonalAxisBounds) - ATarget;
      if AOffset * AAxis.GetSign < 0 then
        AAxis.Offset(AAxis.GetTransversalOffsetDistance(AOffset))
      else
      begin
        ANeedCalculationRestart := CheckNeedCalculationRestart(AAxis.Axis);
        if ANeedCalculationRestart then
          Exit;
        AOldAvailableBounds := AOrthogonalAxis.AvailableBounds;
        ACanvasZeroValue := GetOrthogonalAxisCanvasZeroValue(AOrthogonalAxis, 0, ATarget, False);
        I := 0;
        while not SameValue(ACanvasZeroValue, ATarget, 1e-3) do
        begin
          ACanvasZeroValue := GetOrthogonalAxisCanvasZeroValue(AOrthogonalAxis, ACanvasZeroValue, ATarget, True);
          ALastValues[I mod 4] := ACanvasZeroValue;
          if IsZero(ALastValues[0] - ALastValues[2]) and IsZero(ALastValues[1] - ALastValues[3]) then   
            Break;
          Inc(I);
        end;
        AOrthogonalAxis.Dirty := AOrthogonalAxis.Dirty or AreaWasDecrease(AOrthogonalAxis.AvailableBounds, AOldAvailableBounds);
      end;
      ABounds := AAxis.AvailableBounds;
      ABounds.Intersect(AOrthogonalAxis.AvailableBounds);
      APlotArea := ABounds;
      if AOrthogonalAxis.Dirty then
        CorrectAvailableBoundsForOrthogonalSecondaryAxes(AOrthogonalAxis.AvailableBounds);
    end;
  end;
end;

procedure TdxChartXYDiagramViewInfo.PrepareCustomAxisViewInfo(AViewInfo: TdxChartAxisViewInfo; ACanvas: TcxCustomCanvas);
begin
  AViewInfo.PrepareCalculation(ACanvas);
  AViewInfo.SetAvailableBounds(PlotArea, True);
end;

procedure TdxChartXYDiagramViewInfo.PrepareSecondaryAxes(AForArguments: Boolean; ACanvas: TcxCustomCanvas);
var
  I: Integer;
  ASecondaryAxesCollection: TdxChartSecondaryCustomAxes;
  ASecondaryAxes: TObjectList<TdxChartAxisViewInfo>;
  AAxisViewInfo: TdxChartAxisViewInfo;
begin
  if AForArguments then
  begin
    ASecondaryAxesCollection := Diagram.SecondaryAxes.AxesX;
    ASecondaryAxes := FSecondaryAxesX
  end
  else
  begin
    ASecondaryAxesCollection := Diagram.SecondaryAxes.AxesY;
    ASecondaryAxes := FSecondaryAxesY;
  end;

  ASecondaryAxes.Clear;
  for I := 0 to ASecondaryAxesCollection.Count - 1 do
  begin
    AAxisViewInfo := ASecondaryAxesCollection.Items[I].Axis.ViewInfo;
    PrepareCustomAxisViewInfo(AAxisViewInfo, ACanvas);
    ASecondaryAxes.Add(AAxisViewInfo);
  end;
end;

procedure TdxChartXYDiagramViewInfo.PrepareSecondaryAxesIndents(AForArguments: Boolean; var ANearEdgeAxis, AFarEdgeAxis: TdxChartCustomAxis);
var
  I: Integer;
  AAxis, ASecondaryAxis: TdxChartCustomAxis;
  ASecondaryAxes: TObjectList<TdxChartAxisViewInfo>;
begin
  if AForArguments then
  begin
    AAxis := Diagram.Axes.AxisX;
    ASecondaryAxes := SecondaryAxesX;
  end
  else
  begin
    AAxis := Diagram.Axes.AxisY;
    ASecondaryAxes := SecondaryAxesY;
  end;

  ANearEdgeAxis := nil;
  AFarEdgeAxis := nil;

  if AAxis.ActuallyVisible then
    if AAxis.IsNearAlignment then
      ANearEdgeAxis := AAxis
    else
    if AAxis.ActuallyVisible and AAxis.IsFarAlignment then
      AFarEdgeAxis := AAxis;

  for I := 0 to ASecondaryAxes.Count - 1 do
  begin
    ASecondaryAxis := ASecondaryAxes[I].Axis;
    if ASecondaryAxis.ActuallyVisible then
      if ASecondaryAxis.IsNearAlignment then
      begin
        if ANearEdgeAxis = nil then
        begin
          ANearEdgeAxis := ASecondaryAxis;
          ASecondaryAxis.ViewInfo.UpdateActualSecondaryAxisIndent(0);
        end
        else
          ASecondaryAxis.ViewInfo.UpdateActualSecondaryAxisIndent(AAxis.DefaultSecondaryAxisIndent);
      end
      else  
        if AFarEdgeAxis = nil then
        begin
          AFarEdgeAxis := ASecondaryAxis;
          ASecondaryAxis.ViewInfo.UpdateActualSecondaryAxisIndent(0);
        end
        else
          ASecondaryAxis.ViewInfo.UpdateActualSecondaryAxisIndent(AAxis.DefaultSecondaryAxisIndent);
  end;
end;

procedure TdxChartXYDiagramViewInfo.RemoveSelectionRectangle;
begin
  FSelectionViewInfo.Visible := False;
  Diagram.Invalidate;
end;

procedure TdxChartXYDiagramViewInfo.UpdateLabelsBoundingRect(AValue: TdxChartSeriesValueViewInfo);
var
  AXYValue: TdxChartXYSeriesValueViewInfo absolute AValue;
begin
  if PlotArea.Contains(AXYValue.DisplayValue) then
    inherited UpdateLabelsBoundingRect(AValue);
end;

procedure TdxChartXYDiagramViewInfo.UpdateSelectionRectangle(ARect: TRect);
begin
  FSelectionViewInfo.Visible := True;
  FSelectionViewInfo.UpdateBounds(ARect, ARect);
  Diagram.Invalidate;
end;


{ TdxChartXYSeries }

class function TdxChartXYSeries.GetBaseViewClass: TdxChartSeriesViewClass;
begin
  Result := TdxChartXYSeriesCustomView;
end;

function TdxChartXYSeries.GetView: TdxChartXYSeriesCustomView;
begin
  Result := TdxChartXYSeriesCustomView(inherited View);
end;

procedure TdxChartXYSeries.SetView(AValue: TdxChartXYSeriesCustomView);
begin
  inherited View := AValue;
end;


{ TdxChartXYDiagramAppearance }

constructor TdxChartXYDiagramAppearance.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FPlotAreaBorderThickness := DefaultBorderThickness;
  FPlotAreaBorder := True;
end;

procedure TdxChartXYDiagramAppearance.ChangeScaleCore(M, D: Integer);
begin
  inherited ChangeScaleCore(M, D);
  FPlotAreaBorderThickness := dxScale(FPlotAreaBorderThickness, M, D);
end;

procedure TdxChartXYDiagramAppearance.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYDiagramAppearance then
  begin
    FPlotAreaBorder := TdxChartXYDiagramAppearance(Source).PlotAreaBorder;
    FPlotAreaBorderThickness := TdxChartXYDiagramAppearance(Source).PlotAreaBorderThickness;
  end;
end;

function TdxChartXYDiagramAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  case AIndex of
    PlotAreaBorderColorIndex:
      Result := ColorScheme.DiagramXY.BorderColor;
  else
    Result := inherited GetActualColor(AIndex);
  end;
end;

function TdxChartXYDiagramAppearance.GetColorCount: Integer;
begin
  Result := inherited GetColorCount + 1;
end;

function TdxChartXYDiagramAppearance.IsPlotAreaBorderThicknessStored: Boolean;
begin
  Result := PlotAreaBorderThickness <> DefaultBorderThickness;
end;

procedure TdxChartXYDiagramAppearance.SetPlotAreaBorder(AValue: Boolean);
begin
  if AValue <> PlotAreaBorder then
  begin
    FPlotAreaBorder := AValue;
    Changed(TAppearanceChange.Size);
  end;
end;

procedure TdxChartXYDiagramAppearance.SetPlotAreaBorderThickness(AValue: Single);
begin
  AValue := Max(0, AValue);
  if AValue <> PlotAreaBorderThickness then
  begin
    FPlotAreaBorderThickness := AValue;
    Changed(TAppearanceChange.Size);
  end;
end;


{ TdxChartXYDiagramZoomOptions }

constructor TdxChartXYDiagramZoomOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FAxisXMaxZoomPercent := DefaultMaxZoomPercent;
  FAxisYMaxZoomPercent := DefaultMaxZoomPercent;
  FAxisXZoomingEnabled := True;
  FAxisYZoomingEnabled := True;
end;

procedure TdxChartXYDiagramZoomOptions.DoAssign(Source: TPersistent);
var
  ASourceOptions: TdxChartXYDiagramZoomOptions;
begin
  inherited DoAssign(Source);
  if Source is TdxChartXYDiagramZoomOptions then
  begin
    ASourceOptions := TdxChartXYDiagramZoomOptions(Source);
    AxisXMaxZoomPercent := ASourceOptions.AxisXMaxZoomPercent;
    AxisYMaxZoomPercent := ASourceOptions.AxisYMaxZoomPercent;
    AxisXZoomingEnabled := ASourceOptions.AxisXZoomingEnabled;
    AxisYZoomingEnabled := ASourceOptions.AxisYZoomingEnabled;
  end;
end;

function TdxChartXYDiagramZoomOptions.IsAxisXMaxZoomPercentStored: Boolean;
begin
  Result := FAxisXMaxZoomPercent <> DefaultMaxZoomPercent;
end;

function TdxChartXYDiagramZoomOptions.IsAxisYMaxZoomPercentStored: Boolean;
begin
  Result := FAxisYMaxZoomPercent <> DefaultMaxZoomPercent;
end;

procedure TdxChartXYDiagramZoomOptions.SetAxisXMaxZoomPercent(
  AValue: Single);
begin
  if AValue < 100 then
    AValue := 100;
  FAxisXMaxZoomPercent := AValue;
end;

procedure TdxChartXYDiagramZoomOptions.SetAxisYMaxZoomPercent(
  AValue: Single);
begin
  if AValue < 100 then
    AValue := 100;
  FAxisYMaxZoomPercent := AValue;
end;

{ TdxChartXYDiagramScrollOptions }

constructor TdxChartXYDiagramScrollOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FScrollBars := bDefault;
  FAxisXScrollingEnabled := True;
  FAxisYScrollingEnabled := True;
end;

procedure TdxChartXYDiagramScrollOptions.DoAssign(ASource: TPersistent);
var
  ASourceOptions: TdxChartXYDiagramScrollOptions;
begin
  inherited DoAssign(ASource);
  if ASource is TdxChartXYDiagramScrollOptions then
  begin
    ASourceOptions := TdxChartXYDiagramScrollOptions(ASource);
    ScrollBars := ASourceOptions.ScrollBars;
    AxisXScrollingEnabled := ASourceOptions.AxisXScrollingEnabled;
    AxisYScrollingEnabled := ASourceOptions.AxisYScrollingEnabled;
  end;

end;

function TdxChartXYDiagramScrollOptions.GetActualScrollbars: Boolean;
begin
  if FScrollBars = bDefault then
    Result := not (Owner is TdxChartXYDiagram) or TdxChartXYDiagram(Owner).Chart.ScrollOptions.ScrollBars
  else
    Result := FScrollBars = bTrue;
end;

{ TdxChartXYSeriesValueViewInfo }

function TdxChartXYSeriesValueViewInfo.GetDistanceTo(const APoint: TdxPointF;
  AMeasuringMode: TdxChartCrosshairSnapToPointMode): Single;
var
  ADifference: Single;
  AByX: Boolean;
begin
  AByX := False; 
  case AMeasuringMode of
    TdxChartCrosshairSnapToPointMode.NearestToCursor:
      begin
        ADifference := APoint.X - CrosshairAnchorPoint.X;
        Result := ADifference * ADifference;
        ADifference := APoint.Y - CrosshairAnchorPoint.Y;
        Result := Result + ADifference * ADifference;
        Exit;
      end;
    TdxChartCrosshairSnapToPointMode.Argument:
      AByX := not Owner.Diagram.Rotated;
    TdxChartCrosshairSnapToPointMode.Value:
      AByX := Owner.Diagram.Rotated;
  end;
  if AByX then
    Result := Abs(APoint.X - CrosshairAnchorPoint.X)
  else
    Result := Abs(APoint.Y - CrosshairAnchorPoint.Y);
end;

function TdxChartXYSeriesValueViewInfo.SegmentFinish: Boolean;
begin
  Result := TValueState.SegmentFinish in FState;
end;

function TdxChartXYSeriesValueViewInfo.SegmentStart: Boolean;
begin
  Result := TValueState.SegmentStart in FState;
end;

function TdxChartXYSeriesValueViewInfo.GetOwner: TdxChartXYSeriesViewCustomViewInfo;
begin
  Result := TdxChartXYSeriesViewCustomViewInfo(inherited Owner);
end;

function TdxChartXYSeriesValueViewInfo.GetValueByName(const AName: string; out AValue: Variant): Boolean;
begin
  if AName = TdxChartTextFormatVariableNames.Value then
  begin
    if FValueText <> '' then
      AValue := FValueText
    else
      AValue := SourceValue;
    Result := True;
  end
  else
    Result := inherited GetValueByName(AName, AValue);
end;

function TdxChartXYSeriesValueViewInfo.GetView: TdxChartXYSeriesCustomView;
begin
  Result := Owner.View;
end;

procedure TdxChartXYSeriesValueViewInfo.CalculateDisplayText;
begin
  inherited CalculateDisplayText;
  if Assigned(TdxChartXYDiagram(Series.Diagram).OnGetValueLabelDrawParameters) then
    RaiseGetValueLabelDrawParametersEvent(FDisplayText);
end;

procedure TdxChartXYSeriesValueViewInfo.CalculateValue;
begin
  if &Record <> nil then
    IsGap := not TdxChartXYSeriesViewCustomViewInfo(Owner).ViewData.GetArgument(&Record, FArgument, FArgumentDisplayText)
  else
  begin
    raise Exception.Create('Others argument needed')
  end;
  if not IsGap then
    inherited CalculateValue
  else
    FState := FState - [TValueState.Visible];
  FSourceValue := FValue;
end;

function TdxChartXYSeriesValueViewInfo.CreateValueLabel: TdxChartValueLabelCustomViewInfo;
begin
  Result := TdxChartXYSeriesValueLabelViewInfo.Create(Self);
end;

function TdxChartXYSeriesValueViewInfo.GetCrosshairAnchorPoint: TdxPointF;
begin
  Result := FDisplayValue;
end;

function TdxChartXYSeriesValueViewInfo.GetDefaultPointToolTipFormatter: TObject;
begin
  if Owner.Diagram.GetActualToolTipMode = TdxChartToolTipMode.Crosshair then
    Result := TdxChartTextFormatController.FormatController.PointToolTipDefaultFormatter
  else
    Result := TdxChartTextFormatController.FormatController.XYSeriesPointToolTipDefaultFormatter;
end;

function TdxChartXYSeriesValueViewInfo.GetLabelAnchorPoint: TdxPointF;
begin
  Result := FDisplayValue;
end;

procedure TdxChartXYSeriesValueViewInfo.MapOnArgumentAxis(AAxisValue: Double);
begin
  FArgument := AAxisValue;
  TdxChartXYSeriesViewCustomViewData(ViewData).CheckMappedValueArgument(Self);
end;

{ TdxChartXYSeriesViewCustomViewData }

procedure TdxChartXYSeriesViewCustomViewData.CheckValue(AValue: TdxChartSeriesValueViewInfo);
begin
  if FArgumentIsNumeric then
  begin
    if IsNan(FArgumentMin) then
    begin
      FArgumentMin := TdxChartXYSeriesValueViewInfo(AValue).Argument;
      FArgumentMax := FArgumentMin;
    end
    else
    begin
      if TdxChartXYSeriesValueViewInfo(AValue).Argument > FArgumentMax then
        FArgumentMax := TdxChartXYSeriesValueViewInfo(AValue).Argument
      else
        if TdxChartXYSeriesValueViewInfo(AValue).Argument < FArgumentMin then
          FArgumentMin := TdxChartXYSeriesValueViewInfo(AValue).Argument;
    end;
  end;
  inherited CheckValue(AValue);
end;

procedure TdxChartXYSeriesViewCustomViewData.CheckMappedValueArgument(AValue: TdxChartXYSeriesValueViewInfo);
begin
  if FArgumentIsNumeric then
    Exit;
  if IsNan(FArgumentMin) then
  begin
    FArgumentMin := AValue.Argument;
    FArgumentMax := AValue.Argument;
  end
  else
  begin
    CheckMin(FArgumentMin, AValue.Argument);
    CheckMax(FArgumentMax, AValue.Argument);
  end;
end;


function TdxChartXYSeriesViewCustomViewData.IsSourceValueValid(ARecord: PdxDataRecord): Boolean;
begin
  Result := (ARecord <> nil) and (ArgumentField <> nil) and (ValueField <> nil) and not ARecord.IsNull[ArgumentField];
end;

procedure TdxChartXYSeriesViewCustomViewData.PrepareItems(ARecords: TdxFastList);
begin
  FArgumentIsNumeric := IsNumeric;
  FArgumentMin := Nan;
  FArgumentMax := Nan;
  FStackedValueMax := nil;
  FStackedValueMin := nil;
  inherited PrepareItems(ARecords);
end;

procedure TdxChartXYSeriesViewCustomViewData.ValidateStackedMinMax(AValue: TdxChartXYSeriesValueViewInfo);
begin
  if IsNan(AValue.Value) then
    Exit;
  if (FStackedValueMin = nil) or (CompareValue(FStackedValueMin.Value, AValue.Value) = GreaterThanValue) then
    FStackedValueMin := AValue;
  if (FStackedValueMax = nil) or (CompareValue(FStackedValueMax.Value, AValue.Value) = LessThanValue) then
    FStackedValueMax := AValue;
end;

{ TdxChartXYSeriesViewCustomViewInfo }

constructor TdxChartXYSeriesViewCustomViewInfo.Create(AOwner: TdxChartSeriesCustomView);
begin
  inherited Create(AOwner);
  FLegendGlyphPenProvider := TLegendGlyphPenProvider.Create(Self);
end;

destructor TdxChartXYSeriesViewCustomViewInfo.Destroy;
begin
  FreeAndNil(FLegendGlyphPenProvider);
  inherited Destroy;
end;

function TdxChartXYSeriesViewCustomViewInfo.IsPointAppropriateForCrosshair(APoint: TdxPointF; ANearestValue: TdxChartXYSeriesValueViewInfo; AMode: TdxChartCrosshairSnapToPointMode): Boolean;

  function IsPointOutOfDefinitionArea(const APoint: TdxPointF): Boolean;
  var
    AMinArgument, AMaxArgument: Single;
    AMinValue, AMaxValue: Single;
    AArgument, AValue: Single;
  begin
    Result := False;
    AMinArgument := FArgumentToCanvasValue(ViewData.ArgumentMin);
    AMaxArgument := FArgumentToCanvasValue(ViewData.ArgumentMax);
    if AMaxArgument < AMinArgument then
      ExchangeSingle(AMaxArgument, AMinArgument);
    if Diagram.Rotated then
    begin
      AArgument := APoint.Y;
      AValue := APoint.X;
      AMinValue := TdxChartXYSeriesValueViewInfo(ViewData.StackedValueMin).CrosshairAnchorPoint.X;
      AMaxValue := TdxChartXYSeriesValueViewInfo(ViewData.StackedValueMax).CrosshairAnchorPoint.X;
    end
    else
    begin
      AArgument := APoint.X;
      AValue := APoint.Y;
      AMinValue := TdxChartXYSeriesValueViewInfo(ViewData.StackedValueMin).CrosshairAnchorPoint.Y;
      AMaxValue := TdxChartXYSeriesValueViewInfo(ViewData.StackedValueMax).CrosshairAnchorPoint.Y;
    end;
    if AMaxValue < AMinValue then
      ExchangeSingle(AMinValue, AMaxValue);
    if ((AArgument < AMinArgument) or (AArgument > AMaxArgument)) and (AMode <> TdxChartCrosshairSnapToPointMode.Value) then
      Exit(True);
    if ((AValue < AMinValue) or (AValue > AMaxValue)) and (AMode <> TdxChartCrosshairSnapToPointMode.Argument) then
      Exit(True);
  end;

  function IsPointInGap(const APoint: TdxPointF; ANearestValue: TdxChartXYSeriesValueViewInfo): Boolean;
  var
    AGapStates: TdxChartXYSeriesValueViewInfo.TValueStates;
    ANextValue, APriorValue, ASecondValue: TdxChartXYSeriesValueViewInfo;
    X1, X2, Y1, Y2: Single;
  begin
    Result := False;
    AGapStates := ANearestValue.FState * [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart, TdxChartXYSeriesValueViewInfo.TValueState.SegmentFinish];
    if AGapStates = [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart, TdxChartXYSeriesValueViewInfo.TValueState.SegmentFinish] then
      Exit(True);

    if AMode = TdxChartCrosshairSnapToPointMode.NearestToCursor then
    begin
      if AGapStates = [] then
        Exit(False);
      if AGapStates = [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart] then
        ASecondValue := TdxChartXYSeriesValueViewInfo(ANearestValue.NextVisibleValue)
      else
        ASecondValue := TdxChartXYSeriesValueViewInfo(ANearestValue.PriorVisibleValue);
      X1 := ANearestValue.CrosshairAnchorPoint.X;
      Y1 := ANearestValue.CrosshairAnchorPoint.Y;
      X2 := ASecondValue.CrosshairAnchorPoint.X;
      Y2 := ASecondValue.CrosshairAnchorPoint.Y;
      Result := ((X1 <= X2) and (APoint.X <= X1) or (X1 > X2) and (APoint.X > X1)) and
                ((Y1 <= Y2) and (APoint.Y <= Y1) or (Y1 > Y2) and (APoint.Y > Y1));
      Exit;
    end;
    if not Diagram.Rotated and (AMode = TdxChartCrosshairSnapToPointMode.Argument) or
           Diagram.Rotated and (AMode = TdxChartCrosshairSnapToPointMode.Value) then
    begin
      AGapStates := [];
      ANextValue := ANearestValue;
      while (ANextValue <> nil) and (ANextValue.CrosshairAnchorPoint.X = ANearestValue.CrosshairAnchorPoint.X) do
      begin
        if ANextValue.SegmentFinish then
        begin
          AGapStates := AGapStates + [TdxChartXYSeriesValueViewInfo.TValueState.SegmentFinish];
          Break;
        end;
        ANextValue := TdxChartXYSeriesValueViewInfo(ANextValue.NextVisibleValue);
      end;
      APriorValue := ANearestValue;
      while (APriorValue <> nil) and (APriorValue.CrosshairAnchorPoint.X = ANearestValue.CrosshairAnchorPoint.X) do
      begin
        if APriorValue.SegmentStart then
        begin
          AGapStates := AGapStates + [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart];
          Break;
        end;
        APriorValue := TdxChartXYSeriesValueViewInfo(APriorValue.PriorVisibleValue);
      end;
      if AGapStates = [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart, TdxChartXYSeriesValueViewInfo.TValueState.SegmentFinish] then
        Exit(True);
      if AGapStates = [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart] then
        ASecondValue :=  TdxChartXYSeriesValueViewInfo(ANearestValue.NextVisibleValue)
      else if AGapStates = [TdxChartXYSeriesValueViewInfo.TValueState.SegmentFinish] then
        ASecondValue :=  TdxChartXYSeriesValueViewInfo(ANearestValue.PriorVisibleValue)
      else
        ASecondValue := nil;
      if ASecondValue <> nil then
      begin
        if (APoint.X < ANearestValue.CrosshairAnchorPoint.X) and (ANearestValue.CrosshairAnchorPoint.X < ASecondValue.CrosshairAnchorPoint.X) or
           (APoint.X > ANearestValue.CrosshairAnchorPoint.X) and (ANearestValue.CrosshairAnchorPoint.X > ASecondValue.CrosshairAnchorPoint.X) then
          Exit(True);
      end;
    end;

    if not Diagram.Rotated and (AMode = TdxChartCrosshairSnapToPointMode.Value) or
           Diagram.Rotated and (AMode = TdxChartCrosshairSnapToPointMode.Argument) then
    begin
      AGapStates := [];
      ANextValue := ANearestValue;
      while (ANextValue <> nil) and (ANextValue.CrosshairAnchorPoint.Y = ANearestValue.CrosshairAnchorPoint.Y) do
      begin
        if ANextValue.SegmentFinish then
        begin
          AGapStates := AGapStates + [TdxChartXYSeriesValueViewInfo.TValueState.SegmentFinish];
          Break;
        end;
        ANextValue := TdxChartXYSeriesValueViewInfo(ANextValue.NextVisibleValue);
      end;
      APriorValue := ANearestValue;
      while (APriorValue <> nil) and (APriorValue.CrosshairAnchorPoint.Y = ANearestValue.CrosshairAnchorPoint.Y) do
      begin
        if APriorValue.SegmentStart then
        begin
          AGapStates := AGapStates + [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart];
          Break;
        end;
        APriorValue := TdxChartXYSeriesValueViewInfo(APriorValue.PriorVisibleValue);
      end;
      if AGapStates = [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart, TdxChartXYSeriesValueViewInfo.TValueState.SegmentFinish] then
        Exit(True);
      if AGapStates = [TdxChartXYSeriesValueViewInfo.TValueState.SegmentStart] then
        ASecondValue :=  TdxChartXYSeriesValueViewInfo(ANearestValue.NextVisibleValue)
      else if AGapStates = [TdxChartXYSeriesValueViewInfo.TValueState.SegmentFinish] then
        ASecondValue :=  TdxChartXYSeriesValueViewInfo(ANearestValue.PriorVisibleValue)
      else
        ASecondValue := nil;
      if ASecondValue <> nil then
      begin
        if (APoint.Y < ANearestValue.CrosshairAnchorPoint.Y) and (ANearestValue.CrosshairAnchorPoint.Y < ASecondValue.CrosshairAnchorPoint.Y) or
           (APoint.Y > ANearestValue.CrosshairAnchorPoint.Y) and (ANearestValue.CrosshairAnchorPoint.Y > ASecondValue.CrosshairAnchorPoint.Y) then
          Exit(True);
      end;
    end;
  end;

const
  MaxDistanceInGap = 40;
var
  AMaxDistanceInGap: Single;
  ADistance: Single;
begin
  AMaxDistanceInGap := TdxChartVisualElementAppearanceAccess(Diagram.Appearance).ScaleFactor.Apply(MaxDistanceInGap);
  ADistance := ANearestValue.GetDistanceTo(APoint, AMode);
  Result := (ADistance <= ANearestValue.GetDistanceTo(cxPointF(ANearestValue.CrosshairAnchorPoint.X + AMaxDistanceInGap, ANearestValue.CrosshairAnchorPoint.Y + AMaxDistanceInGap), AMode)) or
            (not IsPointOutOfDefinitionArea(APoint) and not IsPointInGap(APoint, ANearestValue));
end;

function TdxChartXYSeriesViewCustomViewInfo.GetNearestPoint(const APoint: TdxPointF;
  AMode: TdxChartCrosshairSnapToPointMode): TdxChartXYSeriesValueViewInfo;
var
  AValue: TdxChartXYSeriesValueViewInfo;
  AMinDistance, ACurDistance: Single;
  AOppositeMode: TdxChartCrosshairSnapToPointMode;
begin
  Result := nil;
  AMinDistance := Math.Infinity;
  AValue := TdxChartXYSeriesValueViewInfo(FFirstVisibleValue);
  while AValue <> nil do
  begin
    ACurDistance := AValue.GetDistanceTo(APoint, AMode);
    if (ACurDistance = AMinDistance) and (AMode <> TdxChartCrosshairSnapToPointMode.NearestToCursor) and (Result <> nil) then
    begin
      if AMode = TdxChartCrosshairSnapToPointMode.Argument then
        AOppositeMode := TdxChartCrosshairSnapToPointMode.Value
      else
        AOppositeMode := TdxChartCrosshairSnapToPointMode.Argument;
      if AValue.GetDistanceTo(APoint, AOppositeMode) < Result.GetDistanceTo(APoint, AOppositeMode) then
        Result := AValue;
    end
    else if ACurDistance < AMinDistance then
    begin
      Result := AValue;
      AMinDistance := ACurDistance;
    end;

    AValue := TdxChartXYSeriesValueViewInfo(AValue.NextVisibleValue);
  end;

  if (Result <> nil) and not IsPointAppropriateForCrosshair(APoint, Result, AMode) then
    Result := nil;
end;

procedure TdxChartXYSeriesViewCustomViewInfo.CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo);
var
  XYValue: TdxChartXYSeriesValueViewInfo absolute AValue;
begin
  if TdxChartXYSeriesValueViewInfo.TValueState.Visible in XYValue.FState then
    FPointToDisplayPointProc(XYValue.FArgument, XYValue.FValue, XYValue.FDisplayValue);
end;

procedure TdxChartXYSeriesViewCustomViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
begin
  FArgumentToCanvasValue := DiagramViewInfo.AxisXViewInfo.DataValueToCanvasValue;
  FValueToCanvasValue := DiagramViewInfo.AxisYViewInfo.DataValueToCanvasValue;
  FPointToDisplayPointProc := PointToDisplayPoint;
  if Diagram.Rotated then
  begin
    FPointToDisplayPointProc := PointToDisplayPointRotated;
    ExchangePointers(FArgumentToCanvasValue, FValueToCanvasValue);
  end;
  inherited DoCalculate(ACanvas);
  FLegendGlyphPenProvider.Validate(ACanvas);
end;

procedure TdxChartXYSeriesViewCustomViewInfo.DrawHighlightedValue(ACanvas: TcxCustomCanvas;
  const AValue: TdxChartXYSeriesValueViewInfo);
begin

end;

function TdxChartXYSeriesViewCustomViewInfo.GetMaxLegendGlyphPenWidth: Single;
begin
  Result := TdxChartVisualElementAppearanceAccess(Appearance).ScaleFactor.ApplyF(1);
end;

function TdxChartXYSeriesViewCustomViewInfo.GetLegendGlyphPen: TcxCanvasBasedPen;
begin
  Result := FLegendGlyphPenProvider.Pen;
end;

function TdxChartXYSeriesViewCustomViewInfo.GetValueLabelVisibleBounds: TdxRectF;
begin
  Result := DiagramViewInfo.ContentBounds;
end;

function TdxChartXYSeriesViewCustomViewInfo.GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass;
begin
  Result := TdxChartXYSeriesValueViewInfo;
end;

function TdxChartXYSeriesViewCustomViewInfo.GetDiagram: TdxChartXYDiagram;
begin
  Result := TdxChartXYDiagram(inherited Diagram);
end;

function TdxChartXYSeriesViewCustomViewInfo.GetDiagramViewInfo: TdxChartXYDiagramViewInfo;
begin
  Result := TdxChartXYDiagramViewInfo(inherited DiagramViewInfo);
end;

function TdxChartXYSeriesViewCustomViewInfo.GetTickInterval: Single;
begin
  Result := Diagram.Axes.AxisX.ViewInfo.ActualTickInterval;
end;

function TdxChartXYSeriesViewCustomViewInfo.GetRotated: Boolean;
begin
  Result := Diagram.Rotated;
end;

function TdxChartXYSeriesViewCustomViewInfo.GetView: TdxChartXYSeriesCustomView;
begin
  Result := TdxChartXYSeriesCustomView(inherited View);
end;

function TdxChartXYSeriesViewCustomViewInfo.GetViewData: TdxChartXYSeriesViewCustomViewData;
begin
  Result := TdxChartXYSeriesViewCustomViewData(inherited ViewData);
end;

function TdxChartXYSeriesViewCustomViewInfo.GetAxisXWidth: Single;
begin
  if Rotated then
    Result := DiagramViewInfo.AxisXViewInfo.AxisLineRect.Height
  else
    Result := DiagramViewInfo.AxisXViewInfo.AxisLineRect.Width;
end;

procedure TdxChartXYSeriesViewCustomViewInfo.PointToDisplayPoint(
  const AArgument, AValue: Double; var ADisplayPoint: TdxPointF);
begin
  ADisplayPoint.X := FArgumentToCanvasValue(AArgument);
  ADisplayPoint.Y := FValueToCanvasValue(AValue);
end;

procedure TdxChartXYSeriesViewCustomViewInfo.PointToDisplayPointRotated(
  const AArgument, AValue: Double; var ADisplayPoint: TdxPointF);
begin
  ADisplayPoint.X := FValueToCanvasValue(AValue);
  ADisplayPoint.Y := FArgumentToCanvasValue(AArgument);
end;

{ TdxChartXYSeriesViewCustomViewInfo.TCachedLegendGlyphPen }

constructor TdxChartXYSeriesViewCustomViewInfo.TLegendGlyphPenProvider.Create(
  AOwner: TdxChartXYSeriesViewCustomViewInfo);
begin
   inherited Create;
   FOwner := AOwner;
end;

destructor TdxChartXYSeriesViewCustomViewInfo.TLegendGlyphPenProvider.Destroy;
begin
  FPen.Free;
  inherited Destroy;
end;

function TdxChartXYSeriesViewCustomViewInfo.TLegendGlyphPenProvider.GetAppearance: TAppearanceAccess;
begin
  Result:= TAppearanceAccess(FOwner.Appearance);
end;

function TdxChartXYSeriesViewCustomViewInfo.TLegendGlyphPenProvider.UseAppearancePen: Boolean;
begin
  Result := Appearance.StrokeOptions.Width <= FOwner.GetMaxLegendGlyphPenWidth;
end;

function TdxChartXYSeriesViewCustomViewInfo.TLegendGlyphPenProvider.GetPen: TcxCanvasBasedPen;
begin
  if FPen <> nil then
    Result := FPen
  else
    Result := Appearance.ActualPen;
end;

function TdxChartXYSeriesViewCustomViewInfo.TLegendGlyphPenProvider.NeedUpdate: Boolean;
begin
  Result:= (FPen = nil)
    or (FWidth <> FOwner.GetMaxLegendGlyphPenWidth)
    or (FStyle <> Appearance.StrokeOptions.Style)
    or (FColor <> Appearance.ActualPenColor);
end;

procedure TdxChartXYSeriesViewCustomViewInfo.TLegendGlyphPenProvider.Validate(ACanvas: TcxCustomCanvas);
begin
  if UseAppearancePen then
    FreeAndNil(FPen)
  else
    if NeedUpdate then
      Update(ACanvas);
end;

procedure TdxChartXYSeriesViewCustomViewInfo.TLegendGlyphPenProvider.Update(ACanvas: TcxCustomCanvas);
begin
  FColor := Appearance.ActualPenColor;
  FWidth := FOwner.GetMaxLegendGlyphPenWidth;
  FStyle := Appearance.StrokeOptions.Style;
  FPen.Free;
  FPen := ACanvas.CreatePeN(FColor, FWidth, FStyle);
end;

{ TdxChartXYDiagramScrollableElement }

constructor TdxChartXYDiagramScrollableElement.Create(AViewInfo: TdxChartXYDiagramViewInfo);
begin
  inherited Create(AViewInfo.Diagram);
  FViewInfo := AViewInfo;
end;

procedure TdxChartXYDiagramScrollableElement.DoObjectRemoved;
begin
  inherited DoObjectRemoved;
  if not FChangedHandlers.Empty then
    FChangedHandlers.Invoke(Self);
end;

function TdxChartXYDiagramScrollableElement.GetDiagram: TdxChartXYDiagram;
begin
  Result := FObject;
end;

function TdxChartXYDiagramScrollableElement.GetXAxisScrollBarData: TcxScrollBarData;
begin
  Result := TcxScrollBarData.Create;
  Diagram.Axes.AxisX.InitScrollbarData(Result);
end;

function TdxChartXYDiagramScrollableElement.GetYAxisScrollBarData: TcxScrollBarData;
begin
  Result := TcxScrollBarData.Create;
  Diagram.Axes.AxisY.InitScrollbarData(Result);
end;

function TdxChartXYDiagramScrollableElement.GetHitCode: TdxChartHitCode;
begin
  Result := TdxChartHitCode.Diagram;
end;

function TdxChartXYDiagramScrollableElement.GetSubAreaCode: Integer;
begin
  Result := 0;
end;

function TdxChartXYDiagramScrollableElement.GetHorizontalScrollBarData: TcxScrollBarData;
begin
  if Diagram.Rotated then
    Result := GetYAxisScrollBarData
  else
    Result := GetXAxisScrollBarData;
end;

function TdxChartXYDiagramScrollableElement.GetChartElement: TObject;
begin
  Result := Diagram;
end;

function TdxChartXYDiagramScrollableElement.GetScrollableArea: TRect;
begin
  Result := FViewInfo.PlotArea.DeflateToTRect;
end;

function TdxChartXYDiagramScrollableElement.GetVerticalScrollBarData: TcxScrollBarData;
begin
  if Diagram.Rotated then
    Result := GetXAxisScrollBarData
  else
    Result := GetYAxisScrollBarData;
end;

function TdxChartXYDiagramScrollableElement.IsPanArea(const APoint: TPoint): Boolean;
begin
  Result := FViewInfo.Bounds.Contains(APoint);
end;

function TdxChartXYDiagramScrollableElement.IsValid: Boolean;
begin
  Result := (Diagram <> nil) and Diagram.ActuallyVisible;
end;

procedure TdxChartXYDiagramScrollableElement.Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode;
  var AScrollPos: Integer);
begin
  if AScrollBarKind = sbHorizontal then
    Diagram.ScrollByUser(ssHorizontal, AScrollCode, AScrollPos, scEndScroll, 0)
  else
    Diagram.ScrollByUser(ssVertical, scEndScroll, 0, AScrollCode, AScrollPos);
end;

procedure TdxChartXYDiagramScrollableElement.AddChangedListener(AHandler: TNotifyEvent);
begin
  FChangedHandlers.Add(AHandler);
end;

procedure TdxChartXYDiagramScrollableElement.RemoveChangedListener(AHandler: TNotifyEvent);
begin
  FChangedHandlers.Remove(AHandler);
end;

{ TdxChartMarqueeZoomDragAndDropObject }

procedure TdxChartMarqueeZoomDragAndDropObject.DragAndDrop(const P: TPoint; var Accepted: Boolean);
var
  ARect: TdxRectF;
begin
  inherited DragAndDrop(P, Accepted);
  FEndPoint := P;
  ARect := GetSelectionRect;
  DiagramViewInfo.UpdateSelectionRectangle(Rect(Floor(ARect.Left), Floor(ARect.Top), Ceil(ARect.Right), Ceil(ARect.Bottom)));
end;

procedure TdxChartMarqueeZoomDragAndDropObject.EndDragAndDrop(Accepted: Boolean);
var
  ACanvasRect: TdxRectF;
  AAxisRect: TdxRectDouble;
  AAxisX, AAxisY: TdxChartCustomAxis;
begin
  inherited EndDragAndDrop(Accepted);
  DiagramViewInfo.RemoveSelectionRectangle;
  if Accepted then begin
    ACanvasRect := GetSelectionRect;
    AAxisX := Diagram.Axes.AxisX;
    AAxisY := Diagram.Axes.AxisY;
    if Diagram.Rotated then
    begin
      AAxisRect.Top := AAxisY.ViewInfo.CanvasValueToAxisValue(ACanvasRect.Left);
      AAxisRect.Bottom := AAxisY.ViewInfo.CanvasValueToAxisValue(ACanvasRect.Right);
      AAxisRect.Left := AAxisX.ViewInfo.CanvasValueToAxisValue(ACanvasRect.Top);
      AAxisRect.Right := AAxisX.ViewInfo.CanvasValueToAxisValue(ACanvasRect.Bottom);
    end
    else
    begin
      AAxisRect.Left := AAxisX.ViewInfo.CanvasValueToAxisValue(ACanvasRect.Left);
      AAxisRect.Right := AAxisX.ViewInfo.CanvasValueToAxisValue(ACanvasRect.Right);
      AAxisRect.Top := AAxisY.ViewInfo.CanvasValueToAxisValue(ACanvasRect.Top);
      AAxisRect.Bottom := AAxisY.ViewInfo.CanvasValueToAxisValue(ACanvasRect.Bottom);
    end;
    Diagram.ZoomToRect(AAxisRect);
  end;
end;

function TdxChartMarqueeZoomDragAndDropObject.GetDragAndDropCursor(Accepted: Boolean): TCursor;
begin
  Result := crdxChartControlZoomIn;
end;

function TdxChartMarqueeZoomDragAndDropObject.GetDiagram: TdxChartXYDiagram;
begin
  Result := inherited Diagram as TdxChartXYDiagram;
end;

function TdxChartMarqueeZoomDragAndDropObject.GetDiagramViewInfo: TdxChartXYDiagramViewInfo;
begin
  Result := inherited DiagramViewInfo as TdxChartXYDiagramViewInfo;
end;

function TdxChartMarqueeZoomDragAndDropObject.GetSelectionRect: TdxRectF;
var
  AZoomAlongX, AZoomAlongY: Boolean;
  APlotBounds: TdxRectF;
begin
  APlotBounds := DiagramViewInfo.PlotAreaViewInfo.Bounds;
  if Diagram.Rotated then begin
    AZoomAlongX := Diagram.ZoomOptions.AxisYZoomingEnabled;
    AZoomAlongY := Diagram.ZoomOptions.AxisXZoomingEnabled;
  end
  else
  begin
    AZoomAlongX := Diagram.ZoomOptions.AxisXZoomingEnabled;
    AZoomAlongY := Diagram.ZoomOptions.AxisYZoomingEnabled;
  end;

  if AZoomAlongX then
  begin
    if StartPoint.X < FEndPoint.X then
    begin
      Result.Left := Max(StartPoint.X, APlotBounds.Left);
      Result.Right := Min(FEndPoint.X, APlotBounds.Right);
    end
    else
    begin
      Result.Left := Max(FEndPoint.X, APlotBounds.Left);
      Result.Right := Min(StartPoint.X, APlotBounds.Right);
    end;
  end
  else
  begin
    Result.Left := APlotBounds.Left;
    Result.Right := APlotBounds.Right;
  end;
  if AZoomAlongY then
  begin
    if StartPoint.Y < FEndPoint.Y then
    begin
      Result.Top := Max(StartPoint.Y, APlotBounds.Top);
      Result.Bottom := Min(FEndPoint.Y, APlotBounds.Bottom);
    end
    else begin
      Result.Top := Max(FEndPoint.Y, APlotBounds.Top);
      Result.Bottom := Min(StartPoint.Y, APlotBounds.Bottom);
    end;
  end
  else
  begin
    Result.Top := APlotBounds.Top;
    Result.Bottom := APlotBounds.Bottom;
  end;

end;

{ TdxChartZoomInActionExecutorBase }

function TdxChartZoomInActionExecutorBase.GetDefaultMouseCursor: TCursor;
begin
  Result := crdxChartControlZoomIn;
end;

function TdxChartZoomInActionExecutorBase.IsAvailableFor(ADiagram: TdxChartCustomDiagram): Boolean;

  function IsZoomPercentLess(AAxis: TdxChartCustomAxis; AMaxPercent: Single): Boolean;
  var
    ACurPercent: Single;
  begin
    ACurPercent := AAxis.Range.GetZoomPercent;
    Result := (ACurPercent < AMaxPercent) and not SameValue(ACurPercent, AMaxPercent);
  end;

  function AllowedZoomInByX(ADiagram: TdxChartXYDiagram): Boolean;
  begin
    Result := ADiagram.ZoomOptions.AxisXZoomingEnabled
              and IsZoomPercentLess(ADiagram.Axes.AxisX, ADiagram.ZoomOptions.AxisXMaxZoomPercent)
              and (ADiagram.Axes.AxisX.IsNumeric or not IsZero(ADiagram.Axes.AxisX.Range.RealVisibleRange.Range));
  end;

  function AllowedZoomInByY(ADiagram: TdxChartXYDiagram): Boolean;
  begin
    Result := ADiagram.ZoomOptions.AxisYZoomingEnabled
              and IsZoomPercentLess(ADiagram.Axes.AxisY, ADiagram.ZoomOptions.AxisYMaxZoomPercent);
  end;

var
  AXYDiagram: TdxChartXYDiagram;
begin
  if not (ADiagram is TdxChartXYDiagram) then
    Exit(False);
  AXYDiagram := TdxChartXYDiagram(ADiagram);
  Result := not NoRange(AXYDiagram) and (AllowedZoomInByX(AXYDiagram) or AllowedZoomInByY(AXYDiagram));
end;

{ TdxChartMarqueeZoomActionExecutor }

function TdxChartMarqueeZoomActionExecutor.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  Result := TdxChartMarqueeZoomDragAndDropObject;
end;

{ TdxChartZoomInActionExecutor }

procedure TdxChartZoomInActionExecutor.MouseUp(ADiagram: TdxChartCustomDiagram; AMouseX, AMouseY: Integer);
var
  AXYDiagram: TdxChartXYDiagram;
  ACenteredX, ACenteredY: Double;
begin
  inherited MouseUp(ADiagram, AMouseX, AMouseY);
  if not (ADiagram is TdxChartXYDiagram) then
    Exit;
  AXYDiagram := TdxChartXYDiagram(ADiagram);
  if AXYDiagram.Rotated then
  begin
    ACenteredX := AXYDiagram.Axes.AxisX.ViewInfo.CanvasValueToAxisValue(AMouseY);
    ACenteredY := AXYDiagram.Axes.AxisY.ViewInfo.CanvasValueToAxisValue(AMouseX);
  end
  else
  begin
    ACenteredX := AXYDiagram.Axes.AxisX.ViewInfo.CanvasValueToAxisValue(AMouseX);
    ACenteredY := AXYDiagram.Axes.AxisY.ViewInfo.CanvasValueToAxisValue(AMouseY);
  end;

  AXYDiagram.ZoomByUser(TdxChartRange.TZoomType.CenteredBearingValue,
                        AXYDiagram.Chart.ZoomOptions.LargeStep,
                        1,
                        TdxPointDouble.Create(ACenteredX, ACenteredY)
                       );
end;

{ TdxChartZoomOutActionExecutor }

function TdxChartZoomOutActionExecutor.GetDefaultMouseCursor: TCursor;
begin
  Result := crdxChartControlZoomOut;
end;

function TdxChartZoomOutActionExecutor.IsAvailableFor(ADiagram: TdxChartCustomDiagram): Boolean;

  function CanBeZoomedOutByX(AXYDiagram: TdxChartXYDiagram): Boolean;
  var
    ARangeX: TdxChartRange;
  begin
    ARangeX := AXYDiagram.Axes.AxisX.Range;
    Result := AXYDiagram.ZoomOptions.AxisXZoomingEnabled and
              not SameValue(ARangeX.WholeRangeExtended.Range, ARangeX.VisibleRangeExtended.Range);
  end;

  function CanBeZoomedOutByY(AXYDiagram: TdxChartXYDiagram): Boolean;
  var
    ARangeY: TdxChartRange;
  begin
    ARangeY := AXYDiagram.Axes.AxisY.Range;
    Result := AXYDiagram.ZoomOptions.AxisYZoomingEnabled and
              not SameValue(ARangeY.WholeRangeExtended.Range, ARangeY.VisibleRangeExtended.Range);
  end;

var
  AXYDiagram: TdxChartXYDiagram;
begin
  if not (ADiagram is TdxChartXYDiagram) then
    Exit(False);
  AXYDiagram := TdxChartXYDiagram(ADiagram);
  Result := not NoRange(AXYDiagram) and (CanBeZoomedOutByX(AXYDiagram) or CanBeZoomedOutByY(AXYDiagram));
end;

procedure TdxChartZoomOutActionExecutor.MouseUp(ADiagram: TdxChartCustomDiagram; AMouseX, AMouseY: Integer);
var
  AXYDiagram: TdxChartXYDiagram;
  ACenteredX, ACenteredY: Double;
begin
  inherited MouseUp(ADiagram, AMouseX, AMouseY);
  if not (ADiagram is TdxChartXYDiagram) then
    Exit;
  AXYDiagram := TdxChartXYDiagram(ADiagram);
  if AXYDiagram.Rotated then
  begin
    ACenteredX := AXYDiagram.Axes.AxisX.ViewInfo.CanvasValueToAxisValue(AMouseY);
    ACenteredY := AXYDiagram.Axes.AxisY.ViewInfo.CanvasValueToAxisValue(AMouseX);
  end
  else
  begin
    ACenteredX := AXYDiagram.Axes.AxisX.ViewInfo.CanvasValueToAxisValue(AMouseX);
    ACenteredY := AXYDiagram.Axes.AxisY.ViewInfo.CanvasValueToAxisValue(AMouseY);
  end;
  AXYDiagram.ZoomByUser(TdxChartRange.TZoomType.CenteredBearingValue,
                        AXYDiagram.Chart.ZoomOptions.LargeStep,
                        -1,
                        TdxPointDouble.Create(ACenteredX, ACenteredY)
                        );
end;

{ TdxChartPanActionExecutor }

function TdxChartPanActionExecutor.GetDefaultMouseCursor: TCursor;
begin
  Result := crdxChartControlHand;
end;

function TdxChartPanActionExecutor.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  Result := TdxChartPanDragAndDropObject;
end;

function TdxChartPanActionExecutor.IsAvailableFor(ADiagram: TdxChartCustomDiagram): Boolean;

  function CanScrollByX(AXYDiagram: TdxChartXYDiagram): Boolean;
  var
    ARangeX: TdxChartRange;
  begin
    ARangeX := AXYDiagram.Axes.AxisX.Range;
    Result := not SameValue(ARangeX.WholeRangeExtended.Range, ARangeX.VisibleRangeExtended.Range) and
              AXYDiagram.ScrollOptions.AxisXScrollingEnabled;
  end;

  function CanScrollByY(AXYDiagram: TdxChartXYDiagram): Boolean;
  var
    ARangeY: TdxChartRange;
  begin
    ARangeY := AXYDiagram.Axes.AxisY.Range;
    Result := not SameValue(ARangeY.WholeRangeExtended.Range, ARangeY.VisibleRangeExtended.Range) and
              AXYDiagram.ScrollOptions.AxisYScrollingEnabled;
  end;

var
  AXYDiagram: TdxChartXYDiagram;
begin
  if not (ADiagram is TdxChartXYDiagram) then
    Exit(False);
  AXYDiagram := TdxChartXYDiagram(ADiagram);
  Result := not NoRange(AXYDiagram) and (CanScrollByX(AXYDiagram) or CanScrollByY(AXYDiagram));
end;

{ TdxChartPanDragAndDropObject }

procedure TdxChartPanDragAndDropObject.Init(ADiagram: TdxChartCustomDiagram; AStartPoint: TPoint);
begin
  inherited Init(ADiagram, AStartPoint);
  if Diagram.Rotated then
  begin
    FInitialScrollPos.Y := Diagram.Axes.AxisX.GetScrollPos;
    FInitialScrollPos.X := Diagram.Axes.AxisY.GetScrollPos;
  end
  else
  begin
    FInitialScrollPos.X := Diagram.Axes.AxisX.GetScrollPos;
    FInitialScrollPos.Y := Diagram.Axes.AxisY.GetScrollPos;
  end;
end;

procedure TdxChartPanDragAndDropObject.DragAndDrop(const P: TPoint; var Accepted: Boolean);
begin
  inherited DragAndDrop(P, Accepted);
  Diagram.ScrollByUser(ssBoth, scPosition, StartPoint.X - P.X + FInitialScrollPos.X, scPosition, StartPoint.Y - P.Y + FInitialScrollPos.Y);
end;

function TdxChartPanDragAndDropObject.GetDiagram: TdxChartXYDiagram;
begin
  Result := inherited Diagram as TdxChartXYDiagram;
end;

function TdxChartPanDragAndDropObject.GetDragAndDropCursor(Accepted: Boolean): TCursor;
begin
  Result := crdxChartControlDragByHand;
end;

{ TdxChartAxisValueLabelInfo }

constructor TdxChartAxisValueLabelInfo.Create(const AAxis: TdxChartCustomAxis; AAxisValue: Double; const AValueLabelText: string);
begin
  inherited Create;
  FAxis := AAxis;
  FAxisValue := AAxisValue;
  FText := AValueLabelText;
end;

function TdxChartAxisValueLabelInfo.Equals(Obj: TObject): Boolean;
var
  AValueLabelInfo: TdxChartAxisValueLabelInfo;
begin
  if Obj is TdxChartAxisValueLabelInfo then
  begin
    AValueLabelInfo :=  TdxChartAxisValueLabelInfo(Obj);
    Result := (AValueLabelInfo.Axis = Axis) and (AValueLabelInfo.Text = Text) and (AValueLabelInfo.FAxisValue = FAxisValue);
  end
  else
    Result := False;
end;

{ TdxChartXYSeriesValueLabels }

procedure TdxChartXYSeriesValueLabels.ResolveOverlappingIndentChanged;
begin
  TdxChartXYDiagram(Series.Diagram).ChangeResolveOverlappingIndent(Self);
end;

{ TdxChartXYSeriesValueLabelViewInfo }

function TdxChartXYSeriesValueLabelViewInfo.GetLabelOptions: TdxChartXYSeriesValueLabels;
begin
  Result := TdxChartXYSeriesValueLabels(inherited Options);
end;

function TdxChartXYSeriesValueLabelViewInfo.GetOwner: TdxChartXYSeriesValueViewInfo;
begin
  Result := TdxChartXYSeriesValueViewInfo(inherited Owner);
end;

function TdxChartXYSeriesValueLabelViewInfo.GetExcludedBounds: TdxRectF;
begin
  Result.Empty;
end;

function TdxChartXYSeriesValueLabelViewInfo.GetValidRect: TdxRectF;
begin
  Result.Empty;
end;

procedure TdxChartXYSeriesValueLabelViewInfo.Offset(const ADistance: TdxPointF);
var
  ANearestPoint: TdxPointF;
begin
  if IsZero(ADistance.X - Bounds.CenterPoint.X) and IsZero(ADistance.Y - Bounds.CenterPoint.Y) then
    Exit;
  Realign(ADistance);
  if LeaderLineType = TLeaderLineType.TwoPoints then
  begin
    ANearestPoint := TConnectionPointFinder.GetNearest(StartPoint, Bounds);
    MiddlePoint.Init(ANearestPoint.X, ANearestPoint.Y);
  end;
end;

{ TdxChartXYSeriesValueLabelViewInfoList }

function TdxChartXYSeriesValueLabelViewInfoList.GetItem(Index: TdxListIndex): TdxChartXYSeriesValueLabelViewInfo;
begin
  Result := TdxChartXYSeriesValueLabelViewInfo(List[Index]);
end;

{ TdxChartXYSeriesValueLabelsOverlappingResolver }

class function TdxChartXYSeriesValueLabelsOverlappingResolver.IsVisible(
  const ARect: TRect; const APoint: TPoint): Boolean;
begin
  Result := ARect.IsEmpty or ARect.Contains(APoint);
end;

class procedure TdxChartXYSeriesValueLabelsOverlappingResolver.Arrange(
  ALabels: TdxChartXYSeriesValueLabelViewInfoList; const ADiagramBounds: TdxRectF; AIndent: Single);
var
  AAlgorithm: TdxChartRectanglesLayoutAlgorithm;
  I: Integer;
begin
  AAlgorithm := TdxChartRectanglesLayoutAlgorithm.Create(ADiagramBounds.InflateToTRect, Round(AIndent));
  try
    PopulateRects(AAlgorithm, ALabels);
    for I := 0 to ALabels.Count - 1 do
      ArrangeLabel(AAlgorithm, ALabels[I]);
  finally
    AAlgorithm.Free;
  end;
end;

class procedure TdxChartXYSeriesValueLabelsOverlappingResolver.ArrangeLabel(
  AAlgorithm: TdxChartRectanglesLayoutAlgorithm; ALabel: TdxChartXYSeriesValueLabelViewInfo);
var
  ALabelBounds: TRect;
  ALabelCenter: TPoint;
  ALabelValidRect: TRect;
  AResolveMode: TdxChartSeriesValueLabelsResolveOverlappingMode;

  procedure Flush(ANewBounds: TRect);
  begin
    if ANewBounds <> ALabelBounds then
      ALabel.Offset(ANewBounds.CenterPoint)
  end;

begin
  AResolveMode := ALabel.Options.GetResolveOverlappingMode;
  if AResolveMode = TdxChartSeriesValueLabelsResolveOverlappingMode.None then
    Exit;

  ALabelBounds := ALabel.Bounds.DeflateToTRect;
  ALabelCenter := ALabelBounds.CenterPoint;
  ALabelValidRect := ALabel.GetValidRect.DeflateToTRect;

  case AResolveMode of
    TdxChartSeriesValueLabelsResolveOverlappingMode.Default:
      if not IsVisible(ALabelValidRect, ALabelCenter) or not AAlgorithm.IsEmptyRegion(ALabelBounds, False) then
        Flush(AAlgorithm.ArrangeRectangle(ALabelBounds, ALabelValidRect, True))
      else
        AAlgorithm.AddOccupiedRectangle(ALabelBounds);

    TdxChartSeriesValueLabelsResolveOverlappingMode.HideOverlapped:
      if not IsVisible(ALabelValidRect, ALabelCenter) or not AAlgorithm.IsEmptyRegionByList(ALabelBounds, False) then
        ALabel.Visible := False
      else
        AAlgorithm.AddOccupiedRectangle(ALabelBounds);

    TdxChartSeriesValueLabelsResolveOverlappingMode.JustifyAroundPoint:
      if not IsVisible(ALabelValidRect, ALabelCenter) or not AAlgorithm.IsEmptyRegion(ALabelBounds, False) then
        Flush(AAlgorithm.ArrangeRectangle(ALabelBounds, ALabelValidRect, ALabel.GetExcludedBounds.DeflateToTRect, False))
      else
        AAlgorithm.AddOccupiedRectangle(ALabelBounds);

    TdxChartSeriesValueLabelsResolveOverlappingMode.JustifyAllAroundPoint:
      Flush(AAlgorithm.ArrangeRectangle(ALabelBounds, ALabelValidRect, True));
  end;
end;

class procedure TdxChartXYSeriesValueLabelsOverlappingResolver.PopulateRects(
  AAlgorithm: TdxChartRectanglesLayoutAlgorithm; ALabels: TdxChartXYSeriesValueLabelViewInfoList);
var
  AExcludedRect: TdxRectF;
  ALabel: TdxChartXYSeriesValueLabelViewInfo;
  AResolveMode: TdxChartSeriesValueLabelsResolveOverlappingMode;
  I: Integer;
begin
  for I := 0 to ALabels.Count - 1 do
  begin
    ALabel := ALabels[I];
    AResolveMode := ALabel.Options.GetResolveOverlappingMode;
    if AResolveMode = TdxChartSeriesValueLabelsResolveOverlappingMode.None then
      AAlgorithm.AddOccupiedRectangle(ALabel.Bounds.DeflateToTRect)
    else
      if AResolveMode <> TdxChartSeriesValueLabelsResolveOverlappingMode.HideOverlapped then
      begin
        AExcludedRect := ALabel.GetExcludedBounds;
        if not AExcludedRect.IsEmpty then
          AAlgorithm.AddExcludedRectangle(AExcludedRect.DeflateToTRect);
      end;
  end;
end;

{ TdxChartXYDiagramSelectionViewInfo }

procedure TdxChartXYDiagramSelectionViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  ARect: TRect;
begin
  inherited;
  ARect := Rect(Ceil(Bounds.Left), Ceil(Bounds.Top), Floor(Bounds.Right), Floor(Bounds.Bottom));
  ACanvas.EnableAntialiasing(False);
  ACanvas.Rectangle(ARect, clNone, clBlue, psSolid);
  ACanvas.FillRect(ARect, Windows.RGB($49, $A7, $FF), 96);
  ACanvas.RestoreAntialiasing;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}

  RegisterClasses([TdxChartXYDiagram, TdxChartXYSeries, TdxChartAxes, TdxChartAxisTitle,
    TdxChartCustomAxis, TdxChartCustomAxis, TdxChartAxisX, TdxChartAxisY]);
  dxRegisterCursor(crdxChartControlZoomIn, HInstance, 'IDC_DXCHARTCONTROL_ZOOMIN');
  dxRegisterCursor(crdxChartControlZoomOut, HInstance, 'IDC_DXCHARTCONTROL_ZOOMOUT');
  dxRegisterCursor(crdxChartControlHand, HInstance, 'IDC_DXCHARTCONTROL_HAND');
  dxRegisterCursor(crdxChartControlDragByHand, HInstance, 'IDC_DXCHARTCONTROL_DRAGBYHAND');

  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}

finalization
  dxUnregisterCursor(crdxChartControlZoomIn);
  dxUnregisterCursor(crdxChartControlZoomOut);
  dxUnregisterCursor(crdxChartControlHand);
  dxUnregisterCursor(crdxChartControlDragByHand);
end.
