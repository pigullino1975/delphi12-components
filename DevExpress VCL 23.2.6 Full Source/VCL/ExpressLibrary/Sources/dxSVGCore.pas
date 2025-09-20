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

unit dxSVGCore;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, TypInfo, Windows, Classes, Variants, Rtti, Graphics, Generics.Collections, Generics.Defaults, Contnrs,
  dxCore, dxSmartImage, dxXMLDoc, dxCoreGraphics, cxGraphics, cxGeometry, dxGDIPlusAPI, dxGDIPlusClasses,
  dxDPIAwareUtils, dxGenerics, dxTypeHelpers;

type
  TdxSVGElement = class;
  TdxSVGElementRoot = class;

  TdxSVGContentUnits = (cuUserSpaceOnUse, cuObjectBoundingBox);
  TdxSVGFillMode = (fmNonZero, fmEvenOdd, fmInherit);
  TdxSVGLineCapStyle = (lcsDefault, lcsButt, lcsSquare, lcsRound);
  TdxSVGShapeRendering = (srAuto, srOptimizeSpeed, srCrispEdges, srGeometricPrecision);
  TdxSVGTextAnchor = (taStart, taMiddle, taEnd, taInherit);
  TdxSVGUnitsType = (utPx, utMm, utCm, utIn, utPc, utPt, utPercents);

  { TdxSVGFill }

  TdxSVGFill = record
    Data: Variant;

    class function Create(const AColor: TdxAlphaColor): TdxSVGFill; overload; static;
    class function Create(const AReference: string): TdxSVGFill; overload; static;
    class function Default: TdxSVGFill; static;
    function AsColor: TdxAlphaColor;
    function AsReference: string;
    function IsDefault: Boolean;
    function IsEmpty: Boolean;
    function IsReference: Boolean;
    procedure UpdateReference(const AOldReference, ANewReference: string);
  end;

  { TdxSVGValue }

  TdxSVGValue = record
    Data: Single;
    UnitsType: TdxSVGUnitsType;

    class function Create(const AValue: Single; AUnitsType: TdxSVGUnitsType): TdxSVGValue; static;
    class operator Equal(const V1, V2: TdxSVGValue): Boolean;
    class operator NotEqual(const V1, V2: TdxSVGValue): Boolean;
    function IsEmpty: Boolean; inline;
    function ToPixels(ATargetDPI: Integer = dxDefaultDPI): Single; overload;
    function ToPixels(const AParentSize: Single; ATargetDPI: Integer = dxDefaultDPI): Single; overload;
  end;

  { TdxSVGList<T> }

  TdxSVGList<T> = class(TList<T>)
  public
    procedure Assign(AValues: TdxSVGList<T>);
  end;

  { TdxSVGSchema }

  TdxSVGSchema = class
  public const
    CenterX = 'cx';
    CenterY = 'cy';
    ClassName = 'class';
    ClipPath = 'clip-path';
    ClipRule = 'clip-rule';
    DeltaX = 'dx';
    DeltaY = 'dy';
    EnableBackground = 'enable-background';
    Fill = 'fill';
    FillOpacity = 'fill-opacity';
    FillRule = 'fill-rule';
    FocalRadius = 'fr';
    FocalX = 'fx';
    FocalY = 'fy';
    Font = 'font';
    FontFamily = 'font-family';
    FontSize = 'font-size';
    FontStyle = 'font-style';
    FontWeight = 'font-weight';
    GradientTransform = 'gradientTransform';
    GradientUnits = 'gradientUnits';
    Height = 'height';
    Href = 'href';
    ID = 'id';
    Inherit = 'inherit';
    None = 'none';
    Offset = 'offset';
    Opacity = 'opacity';
    PathData = 'd';
    PatternTransform = 'patternTransform';
    PatternUnits = 'patternUnits';
    Points = 'points';
    PreserveAspectRatio = 'preserveAspectRatio';
    Radius = 'r';
    RadiusX = 'rx';
    RadiusY = 'ry';
    ShapeRendering = 'shape-rendering';
    SpreadMethod = 'spreadMethod';
    Stop = 'stop';
    StopColor = 'stop-color';
    StopOpacity = 'stop-opacity';
    Stroke = 'stroke';
    StrokeDashArray = 'stroke-dasharray';
    StrokeDashOffset = 'stroke-dashoffset';
    StrokeLineCap = 'stroke-linecap';
    StrokeLineJoin = 'stroke-linejoin';
    StrokeMiterLimit = 'stroke-miterlimit';
    StrokeOpacity = 'stroke-opacity';
    StrokeWidth = 'stroke-width';
    Style = 'style';
    Svg = 'svg';
    Tag = 'tag';
    TextAnchor = 'text-anchor';
    TextDecoration = 'text-decoration';
    Transform = 'transform';
    ViewBox = 'viewBox';
    Width = 'width';
    X = 'x';
    X1 = 'x1';
    X2 = 'x2';
    XLinkHref = 'xlink:href';
    Y = 'y';
    Y1 = 'y1';
    Y2 = 'y2';
  end;

  { TdxSVGReferences }

  TdxSVGReferences = class(TdxHashSet<string>)
  strict private const
    Template = 'id_%d';
  strict private
    FCounter: Integer;
  public
    procedure Clear;
    function Generate: string;
  end;

  { TdxSVGSingleValues }

  TdxSVGSingleValues = class(TdxSVGList<Single>);

  { TdxSVGValues }

  TdxSVGValues = class(TdxSVGList<TdxSVGValue>);

  { TdxSVGPath }

  TdxSVGPath = class(TdxGPPath)
  strict private
    FCommandLine: string;
  public
    procedure Assign(ASource: TdxGPPath); override;
    procedure FromString(const S: string);
    function ToString: string; override;
  end;

  { TdxSVGPoints }

  TdxSVGPoints = class(TdxSVGList<TdxPointF>)
  public
    procedure Assign(const P: array of TPoint); overload;
    procedure Assign(const P: array of TdxPointF); overload;
    function BoudingRect: TdxRectF;
  end;

  { TdxSVGRect }

  TdxSVGRect = class
  strict private
    FValue: TdxRectF;

    function GetHeight: Single; inline;
    function GetWidth: Single; inline;
  public
    function IsEmpty: Boolean; inline;

    property Height: Single read GetHeight;
    property Width: Single read GetWidth;
    property Value: TdxRectF read FValue write FValue;
  end;

{$REGION 'Renderers'}

  { TdxSVGBrush }

  TdxSVGBrushGradientMode = (sbgmLinear, sbgmRadial, sbgmNative);

  TdxSVGBrush = class(TdxGPBrush)
  strict private
    FGradientBox: TdxRectF;
    FGradientFocalPoint: TdxPointF;
    FGradientMode: TdxSVGBrushGradientMode;

    function GetGradientModeNative: TdxGPBrushGradientMode;
    procedure SetGradientModeNative(AValue: TdxGPBrushGradientMode);
  protected
    procedure CreateGradientBrushHandle(out AHandle: Pointer); override;
    function NeedRecreateHandleOnTargetRectChange: Boolean; override;
  public
    procedure Assign(ASource: TdxGPCustomGraphicObject); override;
    //
    property GradientBox: TdxRectF read FGradientBox write FGradientBox;
    property GradientFocalPoint: TdxPointF read FGradientFocalPoint write FGradientFocalPoint;
    property GradientMode: TdxSVGBrushGradientMode read FGradientMode write FGradientMode;
    property GradientModeNative: TdxGPBrushGradientMode read GetGradientModeNative write SetGradientModeNative;
  end;

  { TdxSVGPen }

  TdxSVGPen = class(TdxGpPen)
  strict private
    function GetBrush: TdxSVGBrush;
  protected
    function CreateBrush: TdxGPBrush; override;
  public
    property Brush: TdxSVGBrush read GetBrush;
  end;

  { TdxSVGCustomRenderer }

  TdxSVGCustomRenderer = class abstract
  strict private
    FBrush: TdxSVGBrush;
    FOpacity: Single;
    FOpacityAssigned: Boolean;
    FPalette: IdxColorPalette;
    FPen: TdxSVGPen;
    FWorldTransform: TdxGPMatrix;
    FSavedWorldTransforms: TStack;
    FShapeRendering: TdxSVGShapeRendering;
    FUseDrawCorrection: Boolean;
  protected
    function CreateBrush: TdxSVGBrush; virtual;
    function CreatePen: TdxSVGPen; virtual;
    function TransformPenWidth(AWidth: Single): Single; virtual;
  public
    constructor Create(APalette: IdxColorPalette = nil);
    destructor Destroy; override;
    procedure InitializeAppearance(AElement: TdxSVGElement); virtual;
    // Primitives
    procedure Draw(const AImage: TdxSmartImage; const R: TdxRectF); virtual; abstract;
    procedure Ellipse(const R: TdxRectF); virtual; abstract;
    procedure Line(const X1, Y1, X2, Y2: Single); virtual; abstract;
    procedure Path(APath: TdxGPPath); virtual; abstract;
    procedure Polygon(const APoints: array of TdxPointF; const AUsePen: Boolean = True); virtual; abstract;
    procedure Polyline(const APoints: array of TdxPointF); virtual; abstract;
    procedure Rectangle(const R: TdxRectF); virtual; abstract;
    procedure RoundRect(const R: TdxRectF; ARadiusX, ARadiusY: Single); virtual; abstract;
    procedure TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont); virtual; abstract;
    // Opacity
    function MakeColor(AColor: TdxAlphaColor; AOpacity: Single): TdxAlphaColor; virtual;
    function ModifyOpacity(const AOpacity: Single): Single; virtual;
    procedure SetOpacity(const AOpacity: Single); virtual;
    // State
    procedure RestoreClipRegion; virtual; abstract;
    procedure SaveClipRegion; virtual; abstract;
    procedure SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode = gmIntersect); virtual; abstract;
    // World Transform
    procedure ModifyWorldTransform(const AMatrix: TXForm); overload;
    procedure ModifyWorldTransform(const AMatrix: TdxGPMatrix); overload; virtual;
    procedure RestoreWorldTransform; virtual;
    procedure SaveWorldTransform; virtual;
    // Antialiasing
    procedure EnableAntialiasing(AEnable: Boolean); virtual;
    procedure RestoreAntialiasing; virtual;
    //
    property Brush: TdxSVGBrush read FBrush;
    property Opacity: Single read FOpacity;
    property Palette: IdxColorPalette read FPalette;
    property Pen: TdxSVGPen read FPen;
    property ShapeRendering: TdxSVGShapeRendering read FShapeRendering write FShapeRendering;
    property UseDrawCorrection: Boolean read FUseDrawCorrection write FUseDrawCorrection;
    property WorldTransform: TdxGPMatrix read FWorldTransform;
  end;

  { TdxSVGRenderer }

  TdxSVGRenderer = class(TdxSVGCustomRenderer)
  protected
    FCanvas: TdxGPCanvas;

    function TransformPenWidth(AWidth: Single): Single; override;
  public
    constructor Create(ACanvas: TdxGPCanvas; APalette: IdxColorPalette = nil);
    // Primitives
    procedure Draw(const AImage: TdxSmartImage; const R: TdxRectF); override;
    procedure Ellipse(const R: TdxRectF); override;
    procedure Line(const X1, Y1, X2, Y2: Single); override;
    procedure Path(APath: TdxGPPath); override;
    procedure Polygon(const APoints: array of TdxPointF; const AUsePen: Boolean = True); override;
    procedure Polyline(const APoints: array of TdxPointF); override;
    procedure Rectangle(const R: TdxRectF); override;
    procedure RoundRect(const R: TdxRectF; ARadiusX, ARadiusY: Single); override;
    procedure TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont); override;
    // State
    procedure RestoreClipRegion; override;
    procedure SaveClipRegion; override;
    procedure SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode = gmIntersect); override;
    // WorldTransform
    procedure ModifyWorldTransform(const AMatrix: TdxGPMatrix); override;
    procedure RestoreWorldTransform; override;
    procedure SaveWorldTransform; override;

    procedure EnableAntialiasing(AEnable: Boolean); override;
    procedure RestoreAntialiasing; override;
  end;

  { TdxSVGRendererClipPath }

  TdxSVGRendererClipPath = class(TdxSVGCustomRenderer)
  type
    TAddChildShape = reference to procedure(ANewPath: TdxGPPath);
  strict private
    FClipPath: TdxGPPath;
    FSavedTransforms: TdxIntegerList;
    FTransforms: TObjectList<TdxGPMatrix>;
    FFillMode: TdxGPFillMode;
    procedure TransformPath(APath: TdxGPPath);
    function TransformPoint(const P: TdxPointF): TdxPointF;
    function TransformRect(const R: TdxRectF): TdxRectF;
    procedure ApplyClipRule(AClipRule: TdxGPFillMode);
  public
    constructor Create(AClipRule: TdxGPFillMode);
    destructor Destroy; override;
    procedure InitializeAppearance(AElement: TdxSVGElement); override;
    // Primitives
    procedure Draw(const AImage: TdxSmartImage; const R: TdxRectF); override;
    procedure Ellipse(const R: TdxRectF); override;
    procedure Line(const X1, Y1, X2, Y2: Single); override;
    procedure Path(APath: TdxGPPath); override;
    procedure Polygon(const APoints: array of TdxPointF; const AUsePen: Boolean = True); override;
    procedure Polyline(const APoints: array of TdxPointF); override;
    procedure Rectangle(const R: TdxRectF); override;
    procedure RoundRect(const R: TdxRectF; ARadiusX, ARadiusY: Single); override;
    procedure TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont); override;
    // State
    procedure RestoreClipRegion; override;
    procedure SaveClipRegion; override;
    procedure SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode = gmIntersect); override;
    // WorldTransform
    procedure ModifyWorldTransform(const AMatrix: TdxGPMatrix); override;
    procedure RestoreWorldTransform; override;
    procedure SaveWorldTransform; override;
    //
    property ClipPath: TdxGPPath read FClipPath;
  end;

{$ENDREGION}

{$REGION 'Elements'}

  { TdxSVGElement }

  TdxSVGElementClass = class of TdxSVGElement;
  TdxSVGElement = class(TPersistent)
  strict private
    FChildren: TObjectList;
    FClipRule: TdxSVGFillMode;
    FClipPath: string;
    FFill: TdxSVGFill;
    FFillMode: TdxSVGFillMode;
    FFillOpacity: Single;
    FID: string;
    FOpacity: Single;
    FStroke: TdxSVGFill;
    FStrokeDashArray: TdxSVGSingleValues;
    FStrokeDashOffset: Single;
    FStrokeLineCap: TdxSVGLineCapStyle;
    FStrokeLineJoin: TdxGpLineJoin;
    FStrokeMiterLimit: Single;
    FStrokeOpacity: Single;
    FStrokeSize: Single;
    FStyleName: string;
    FTagName: string;
    FTransform: TdxMatrix;

    function GetCount: Integer;
    function GetElement(Index: Integer): TdxSVGElement;
    procedure SetFillOpacity(const Value: Single);
    procedure SetOpacity(const Value: Single);
    procedure SetParent(const AParent: TdxSVGElement);
    procedure SetStrokeDashArray(const Value: TdxSVGSingleValues);
    procedure SetStrokeOpacity(const Value: Single);
    procedure SetTransform(const Value: TdxMatrix);
  private
    FParent: TdxSVGElement;
  protected
    procedure AssignCore(ASource: TdxSVGElement); virtual;
    function GetRoot: TdxSVGElementRoot; virtual;
    function IsInheritanceSupported: Boolean; virtual;
    procedure UpdateReference(const AOldReference, ANewReference: string); virtual;
    // Clipping
    procedure ApplyClipping(ARenderer: TdxSVGCustomRenderer);
    function HasClipping: Boolean;
    // Drawing
    procedure InitializeBrush(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement); virtual;
    procedure InitializePen(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement); virtual;
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); virtual;
    procedure DrawCoreAndChildren(ARenderer: TdxSVGCustomRenderer);
    // Antialiasing
    procedure EnableAntialiasing(ARenderer: TdxSVGCustomRenderer); virtual;
    procedure RestoreAntialiasing(ARenderer: TdxSVGCustomRenderer); virtual;
    // Relative Coordinates and Sizes
    function GetBounds: TdxRectF; virtual;
    function GetX(const X: TdxSVGValue): Single; inline;
    function GetY(const Y: TdxSVGValue): Single; inline;
    // I/O
    procedure Load(const ANode: TdxXMLNode); virtual;
    procedure Save(const ANode: TdxXMLNode); virtual;
    // Actual Values
    function GetActualClipRule: TdxGPFillMode;
    function GetActualFill(APalette: IdxColorPalette): TdxSVGFill;
    function GetActualFillMode: TdxGPFillMode;
    function GetActualStroke(APalette: IdxColorPalette): TdxSVGFill;
    function GetActualStrokeDashArray: TdxSVGSingleValues;
    function GetActualStrokeDashOffset: Single;
    function GetActualStrokeLineCap: TdxSVGLineCapStyle;
    function GetActualStrokeSize: Single;
  public
    constructor Create; overload; virtual;
    constructor Create(AParent: TdxSVGElement); overload; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override; final;
    function Clone: TdxSVGElement;
    procedure Draw(ARenderer: TdxSVGCustomRenderer); virtual;
    function FindByID(const ID: string; out AElement: TdxSVGElement): Boolean; overload; virtual;
    function FindByID(const ID: string; AClass: TdxSVGElementClass; out AElement): Boolean; overload;
    //
    property Count: Integer read GetCount;
    property Elements[Index: Integer]: TdxSVGElement read GetElement; default;
    property Parent: TdxSVGElement read FParent write SetParent;
    property Root: TdxSVGElementRoot read GetRoot;

    property ID: string read FID write FID;
    property ClipPath: string read FClipPath write FClipPath;
    property ClipRule: TdxSVGFillMode read FClipRule write FClipRule;
    property Fill: TdxSVGFill read FFill write FFill;
    property FillMode: TdxSVGFillMode read FFillMode write FFillMode;
    property FillOpacity: Single read FFillOpacity write SetFillOpacity;
    property Opacity: Single read FOpacity write SetOpacity;
    property Stroke: TdxSVGFill read FStroke write FStroke;
    property StrokeDashArray: TdxSVGSingleValues read FStrokeDashArray write SetStrokeDashArray;
    property StrokeDashOffset: Single read FStrokeDashOffset write FStrokeDashOffset;
    property StrokeLineCap: TdxSVGLineCapStyle read FStrokeLineCap write FStrokeLineCap;
    property StrokeLineJoin: TdxGpLineJoin read FStrokeLineJoin write FStrokeLineJoin;
    property StrokeMiterLimit: Single read FStrokeMiterLimit write FStrokeMiterLimit;
    property StrokeOpacity: Single read FStrokeOpacity write SetStrokeOpacity;
    property StrokeSize: Single read FStrokeSize write FStrokeSize;
    property StyleName: string read FStyleName write FStyleName;
    property TagName: string read FTagName write FTagName;
    property Transform: TdxMatrix read FTransform write SetTransform;
  end;

  { TdxSVGElementGroup }

  TdxSVGElementGroup = class(TdxSVGElement)
  strict private
    FTag: string;
  protected
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    property Tag: string read FTag write FTag;
  end;

  { TdxSVGShapedElement }

  TdxSVGShapedElement = class(TdxSVGElement)
  strict private
    FShapeRendering: TdxSVGShapeRendering;
  protected
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
    // Antialiasing
    procedure EnableAntialiasing(ARenderer: TdxSVGCustomRenderer); override;
    procedure RestoreAntialiasing(ARenderer: TdxSVGCustomRenderer); override;
  public
    property ShapeRendering: TdxSVGShapeRendering read FShapeRendering write FShapeRendering;
  end;

  { TdxSVGElementCircle }

  TdxSVGElementCircle = class(TdxSVGShapedElement)
  strict private
    FRadius: TdxSVGValue;
    FCenterX: TdxSVGValue;
    FCenterY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function GetBounds: TdxRectF; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    property CenterX: TdxSVGValue read FCenterX write FCenterX;
    property CenterY: TdxSVGValue read FCenterY write FCenterY;
    property Radius: TdxSVGValue read FRadius write FRadius;
  end;

  { TdxSVGElementEllipse }

  TdxSVGElementEllipse = class(TdxSVGShapedElement)
  strict private
    FCenterX: TdxSVGValue;
    FCenterY: TdxSVGValue;
    FRadiusX: TdxSVGValue;
    FRadiusY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function GetBounds: TdxRectF; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    procedure SetBounds(const R: TdxRectF; AUnitsType: TdxSVGUnitsType);

    property CenterX: TdxSVGValue read FCenterX write FCenterX;
    property CenterY: TdxSVGValue read FCenterY write FCenterY;
    property RadiusX: TdxSVGValue read FRadiusX write FRadiusX;
    property RadiusY: TdxSVGValue read FRadiusY write FRadiusY;
  end;

  { TdxSVGElementLine }

  TdxSVGElementLine = class(TdxSVGShapedElement)
  strict private
    FX2: TdxSVGValue;
    FY2: TdxSVGValue;
    FX1: TdxSVGValue;
    FY1: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function GetBounds: TdxRectF; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    property X1: TdxSVGValue read FX1 write FX1;
    property X2: TdxSVGValue read FX2 write FX2;
    property Y1: TdxSVGValue read FY1 write FY1;
    property Y2: TdxSVGValue read FY2 write FY2;
  end;

  { TdxSVGElementImage }

  TdxSVGElementImage = class(TdxSVGElement)
  strict private
    FHeight: TdxSVGValue;
    FImage: TdxSmartImage;
    FWidth: TdxSVGValue;
    FX: TdxSVGValue;
    FY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function GetBounds: TdxRectF; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure SetBounds(const R: TdxRectF);
    //
    property Image: TdxSmartImage read FImage;
    property Height: TdxSVGValue read FHeight write FHeight;
    property Width: TdxSVGValue read FWidth write FWidth;
    property X: TdxSVGValue read FX write FX;
    property Y: TdxSVGValue read FY write FY;
  end;

  { TdxSVGElementPath }

  TdxSVGElementPath = class(TdxSVGShapedElement)
  strict private
    FPath: TdxSVGPath;

    procedure SetPath(const Value: TdxSVGPath);
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function GetBounds: TdxRectF; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    property Path: TdxSVGPath read FPath write SetPath;
  end;

  { TdxSVGElementPolygon }

  TdxSVGElementPolygon = class(TdxSVGShapedElement)
  strict private
    FPoints: TdxSVGPoints;

    procedure SetPoints(const Value: TdxSVGPoints);
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function GetBounds: TdxRectF; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Points: TdxSVGPoints read FPoints write SetPoints;
  end;

  { TdxSVGElementPolyline }

  TdxSVGElementPolyline = class(TdxSVGElementPolygon)
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
  end;

  { TdxSVGElementRectangle }

  TdxSVGElementRectangle = class(TdxSVGShapedElement)
  strict private
    FCornerRadiusX: TdxSVGValue;
    FCornerRadiusXAssigned: Boolean;
    FCornerRadiusY: TdxSVGValue;
    FCornerRadiusYAssigned: Boolean;
    FHeight: TdxSVGValue;
    FWidth: TdxSVGValue;
    FX: TdxSVGValue;
    FY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function GetBounds: TdxRectF; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    procedure SetBounds(const R: TdxRectF; AUnitsType: TdxSVGUnitsType); overload;
    procedure SetBounds(const R: TRect; AUnitsType: TdxSVGUnitsType); overload;
    //
    property CornerRadiusX: TdxSVGValue read FCornerRadiusX write FCornerRadiusX;
    property CornerRadiusY: TdxSVGValue read FCornerRadiusY write FCornerRadiusY;
    property Height: TdxSVGValue read FHeight write FHeight;
    property Width: TdxSVGValue read FWidth write FWidth;
    property X: TdxSVGValue read FX write FX;
    property Y: TdxSVGValue read FY write FY;
  end;

  { TdxSVGElementText }

  TdxSVGElementText = class(TdxSVGShapedElement)
  strict private
    FDX: TdxSVGValue;
    FDY: TdxSVGValue;
    FFontName: string;
    FFontSize: Single;
    FFontStyles: TFontStyles;
    FFontStylesAssigned: Boolean;
    FText: string;
    FTextAnchor: TdxSVGTextAnchor;
    FX: TdxSVGValues;
    FY: TdxSVGValues;

    function GetActualFontName: string;
    function GetActualFontSize: Single;
    function GetActualFontStyles: TFontStyles;
    function GetTextAssigned: Boolean;
    procedure SetFontStyles(const AValue: TFontStyles);
    procedure SetFontStyleString(const AValue: string);
    procedure SetX(const AValues: TdxSVGValues);
    procedure SetY(const AValues: TdxSVGValues);
  protected
    FCachedFontFamily: TdxGPFontFamily;

    function CalculateTextPadding(AFont: TdxGPFont): Single;
    function CalculateVertOffset(AFont: TdxGPFont): Single;
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
    procedure ResetCachedValues;

    function GetDefaultFontName: string; virtual;
    function GetDefaultFontSize: Single; virtual;
    function GetDefaultFontStyles: TFontStyles; virtual;

    function TryCreateFont(out AFont: TdxGpFont): Boolean;
    function TryCreateFontFamily(AName: string; out AFamily: TdxGPFontFamily): Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property ActualFontName: string read GetActualFontName;
    property ActualFontSize: Single read GetActualFontSize;
    property ActualFontStyles: TFontStyles read GetActualFontStyles;
    property TextAssigned: Boolean read GetTextAssigned;
  public
    property X: TdxSVGValues read FX write SetX;
    property Y: TdxSVGValues read FY write SetY;
    property DX: TdxSVGValue read FDX write FDX;
    property DY: TdxSVGValue read FDY write FDY;
    property FontName: string read FFontName write FFontName;
    property FontSize: Single read FFontSize write FFontSize;
    property FontStyles: TFontStyles read FFontStyles write SetFontStyles;
    property Text: string read FText write FText;
    property TextAnchor: TdxSVGTextAnchor read FTextAnchor write FTextAnchor;
  end;

  { TdxSVGElementTSpan }

  TdxSVGElementTSpan = class(TdxSVGElementText)
  protected
    function GetDefaultFontName: string; override;
    function GetDefaultFontSize: Single; override;
    function GetDefaultFontStyles: TFontStyles; override;
  public
    constructor Create(AParent: TdxSVGElement); override;
  end;

  { TdxSVGElementRoot }

  TdxSVGElementRoot = class(TdxSVGElementGroup)
  strict private
    FBackground: TdxSVGRect;
    FHeight: TdxSVGValue;
    FViewBox: TdxSVGRect;
    FWidth: TdxSVGValue;
    FX: TdxSVGValue;
    FY: TdxSVGValue;

    function GetActualViewBox: TdxRectF; inline;
    function GetSize: TdxSizeF;
    procedure SetBackground(const Value: TdxSVGRect);
    procedure SetViewBox(const Value: TdxSVGRect);
  protected
    function GetBounds: TdxRectF; override;
    function GetRoot: TdxSVGElementRoot; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Draw(ARender: TdxSVGRenderer; const R: TdxRectF); reintroduce;
    //
    property ActualViewBox: TdxRectF read GetActualViewBox;
    property Size: TdxSizeF read GetSize;
  public
    property X: TdxSVGValue read FX write FX;
    property Y: TdxSVGValue read FY write FY;
    property Height: TdxSVGValue read FHeight write FHeight;
    property Width: TdxSVGValue read FWidth write FWidth;
    property Background: TdxSVGRect read FBackground write SetBackground;
    property ViewBox: TdxSVGRect read FViewBox write SetViewBox;
  end;

  { TdxSVGElementUse }

  TdxSVGElementUse = class(TdxSVGElement)
  strict private
    FReference: string;
    FX: TdxSVGValue;
    FY: TdxSVGValue;
  protected
    procedure DrawCore(ARenderer: TdxSVGCustomRenderer); override;
    function IsInheritanceSupported: Boolean; override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
    procedure UpdateReference(const AOldReference, ANewReference: string); override;
  public
    property X: TdxSVGValue read FX write FX;
    property Y: TdxSVGValue read FY write FY;
    property Reference: string read FReference write FReference;
  end;

{$ENDREGION}

{$REGION 'NeverRendered Elements'}

  { TdxSVGElementNeverRendered }

  TdxSVGElementNeverRendered = class(TdxSVGElement)
  public
    procedure Draw(ARenderer: TdxSVGCustomRenderer); override;
  end;

  { TdxSVGElementDefinitions }

  TdxSVGElementDefinitions = class(TdxSVGElementNeverRendered);

  { TdxSVGElementClipPath }

  TdxSVGElementClipPath = class(TdxSVGElementNeverRendered)
  public
    procedure ApplyTo(ARenderer: TdxSVGCustomRenderer; AElement: TdxSVGElement);
  end;

  { TdxSVGElementCustomPattern }

  TdxSVGElementCustomPattern = class(TdxSVGElementNeverRendered)
  strict private
    FPatternTransform: TdxMatrix;
    FPatternUnitsType: TdxSVGContentUnits;
  protected
    function GetHostBounds(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement): TdxRectF; virtual;
    procedure InitializeBrush(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement); override;
    procedure InitializeBrushCore(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush); virtual; abstract;
    procedure InitializePen(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    //
    property PatternTransform: TdxMatrix read FPatternTransform;
    property PatternUnitsType: TdxSVGContentUnits read FPatternUnitsType write FPatternUnitsType;
  end;

  { TdxSVGElementGradientStop }

  TdxSVGElementGradientStop = class(TdxSVGElementNeverRendered)
  strict private
    FColor: TdxAlphaColor;
    FColorOpacity: Single;
    FOffset: TdxSVGValue;
  protected
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    procedure AfterConstruction; override;
  public
    property Color: TdxAlphaColor read FColor write FColor;
    property ColorOpacity: Single read FColorOpacity write FColorOpacity;
    property Offset: TdxSVGValue read FOffset write FOffset;
  end;

  { TdxSVGElementCustomGradient }

  TdxSVGElementCustomGradient = class(TdxSVGElementCustomPattern)
  strict private
    function GetElement(Index: Integer): TdxSVGElementGradientStop;
  protected
    procedure InitializeBrushCore(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush); override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;

    function CalculateGradientBox(const AHostBounds, APatternRect: TdxRectF): TdxRectF; virtual; abstract;
    procedure CalculateGradientOffsets(const AHostBounds, APatternRect, AGradientBox: TdxRectF; out AStartOffset, AFinishOffset: Single); virtual; abstract;
    function CalculatePatternRect(const AHostBounds: TdxRectF): TdxRectF; virtual; abstract;
    procedure PopulateGradientPoints(ARenderer: TdxSVGCustomRenderer;
      APoints: TdxGPBrushGradientPoints; AStartOffset, AFinishOffset: Single);
  public
    constructor Create; override;
    procedure AddStop(AOffsetInPercents: Single; AColor: TdxAlphaColor; AOpacity: Single = 1.0);
    //
    property Elements[Index: Integer]: TdxSVGElementGradientStop read GetElement;
  end;

  { TdxSVGElementLinearGradient }

  TdxSVGElementLinearGradient = class(TdxSVGElementCustomGradient)
  strict private
    FX1: TdxSVGValue;
    FX2: TdxSVGValue;
    FY1: TdxSVGValue;
    FY2: TdxSVGValue;
  protected
    function CalculateGradientBox(const AHostBounds, APatternRect: TdxRectF): TdxRectF; override;
    procedure CalculateGradientOffsets(const AHostBounds, APatternRect, AGradientLine: TdxRectF; out AStartOffset, AFinishOffset: Single); override;
    function CalculatePatternRect(const AHostBounds: TdxRectF): TdxRectF; override;
    procedure InitializeBrushCore(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush); override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    procedure AfterConstruction; override;
    procedure SetBounds(const ADirection: TdxGpLinearGradientMode); overload;
    procedure SetBounds(const X1, Y1, X2, Y2: Single; AUnitsType: TdxSVGUnitsType); overload;
    procedure SetRotationAngle(const ARotationAngle: Single);
  public
    property X1: TdxSVGValue read FX1 write FX1;
    property X2: TdxSVGValue read FX2 write FX2;
    property Y1: TdxSVGValue read FY1 write FY1;
    property Y2: TdxSVGValue read FY2 write FY2;
  end;

  { IdxSVGGradientPalette }

  IdxSVGLinearGradientPalette = interface // for internal use
  ['{E64B09DB-515E-47CA-9CA4-2031FD991920}']
    function GetLinearGradient(const ID: string; out AGradient: TdxSVGElementLinearGradient): Boolean;
  end;

  { TdxSVGElementRadialGradient }

  TdxSVGElementRadialGradient = class(TdxSVGElementCustomGradient)
  strict private
    FCenterX: TdxSVGValue;
    FCenterY: TdxSVGValue;
    FFocalRadius: TdxSVGValue;
    FFocalX: TdxSVGValue;
    FFocalY: TdxSVGValue;
    FRadius: TdxSVGValue;

    procedure SetCenterX(const Value: TdxSVGValue);
    procedure SetCenterY(const Value: TdxSVGValue);
  protected
    function CalculateGradientBox(const AHostBounds, APatternRect: TdxRectF): TdxRectF; override;
    function CalculateGradientFocalPoint(const AHostBounds: TdxRectF): TdxPointF;
    procedure CalculateGradientOffsets(const AHostBounds, APatternRect, AGradientBox: TdxRectF; out AStartOffset, AFinishOffset: Single); override;
    function CalculatePatternRect(const AHostBounds: TdxRectF): TdxRectF; override;
    function CalculateRadius(const AHostBounds: TdxRectF; const ARadius: TdxSVGValue): Single;
    procedure InitializeBrushCore(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush); override;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    procedure AfterConstruction; override;
    //
    property CenterX: TdxSVGValue read FCenterX write SetCenterX;
    property CenterY: TdxSVGValue read FCenterY write SetCenterY;
    property FocalRadius: TdxSVGValue read FFocalRadius write FFocalRadius;
    property FocalX: TdxSVGValue read FFocalX write FFocalX;
    property FocalY: TdxSVGValue read FFocalY write FFocalY;
    property Radius: TdxSVGValue read FRadius write FRadius;
  end;

  { TdxSVGElementPattern }

  TdxSVGElementPattern = class(TdxSVGElementCustomPattern)
  strict private
    FX: TdxSVGValue;
    FY: TdxSVGValue;
    FHeight: TdxSVGValue;
    FWidth: TdxSVGValue;
    FViewBox: TdxSVGRect;
  protected
    function GetHostBounds(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement): TdxRectF; override;
    procedure InitializeBrushCore(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush); override;
    function IsRasterPattern: Boolean;
    procedure Load(const ANode: TdxXMLNode); override;
    procedure Save(const ANode: TdxXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property X: TdxSVGValue read FX write FX;
    property Y: TdxSVGValue read FY write FY;
    property Height: TdxSVGValue read FHeight write FHeight;
    property Width: TdxSVGValue read FWidth write FWidth;
    property ViewBox: TdxSVGRect read FViewBox write FViewBox;
  end;

{$ENDREGION}

  { TdxSVGStyle }

  TdxSVGStyle = class(TdxXMLNode)
  strict private
    FName: string;
  public
    constructor Create(const AName: string); reintroduce;
    procedure Apply(AElement: TdxSVGElement);
    //
    property Name: string read FName;
  end;

  { TdxSVGStyles }

  TdxSVGStyles = class
  strict private const
    sInline = '_inline_%p';
  strict private
    FItems: TObjectDictionary<string, TdxSVGStyle>;

    function GetItem(const Name: string): TdxSVGStyle;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AName: string): TdxSVGStyle;
    function AddInline(const AReference: TObject): TdxSVGStyle;
    procedure Apply(AElement: TdxSVGElement);
    function TryGetStyle(const AName: string; out AStyle: TdxSVGStyle): Boolean;
    //
    property Items[const Name: string]: TdxSVGStyle read GetItem; default;
  end;

  { TdxSVGFiler }

  TdxSVGFiler = class
  protected
    class var FElementMap: TdxMap<TdxXMLString, TdxSVGElementClass>;

    class procedure Finalize;
    class procedure Initialize;
  end;

  { TdxSVGImporter }

  TdxSVGImporter = class(TdxSVGFiler)
  strict private
    FFixups: TObjectList;
    FStyles: TdxSVGStyles;
  protected
    procedure ImportCore(AElement: TdxSVGElement; ANode: TdxXMLNode);
    procedure ImportNode(AParent: TdxSVGElement; ANode: TdxXMLNode);
    procedure ImportStyles(ANode: TdxXMLNode);
    procedure ResolveReferences(ARoot: TdxSVGElementRoot);
  public
    constructor Create;
    destructor Destroy; override;
    class function GetSize(ADocument: TdxXMLDocument; out ASize: TSize): Boolean;
    class function Import(ADocument: TdxXMLDocument; out ARoot: TdxSVGElementRoot): Boolean; overload;
    class function Import(AStream: TStream; out ARoot: TdxSVGElementRoot): Boolean; overload;
  end;

  { TdxSVGExporter }

  TdxSVGExporter = class(TdxSVGFiler)
  protected
    class procedure ExportCore(AElement: TdxSVGElement; ANode: TdxXMLNode);
    class procedure ExportElement(AElement: TdxSVGElement; AParent: TdxXMLNode);
  public
    class procedure Export(ARoot: TdxSVGElementRoot; ADocument: TdxXMLDocument);
  end;

  { TdxFontIconsResolver }

  TdxFontIconsResolver = class // for internal use
  public type
    TFontIconsStyle  = (Latest, Win10);
  public const
    FontIconsFamily = 'dx-font-icons';
    FluentIcons = 'segoe fluent icons';
    MdlAssets = 'segoe mdl2 assets';
  private class var
    FIconsStyle: TFontIconsStyle;
    FLatest: string;
    FWin10: string;
    FTrimChars: TArray<Char>;
    class constructor Initialize;
  public
    class function ResolveFontName(const AInput: string): string; static;
    class property IconsStyle: TFontIconsStyle read FIconsStyle write FIconsStyle default TFontIconsStyle.Latest;
  end;

var
  dxSVGAutoDarkMode: Boolean = False; // for internal use

implementation

uses
  SysUtils, Math, StrUtils, Character, RTLConsts, dxStringHelper, dxSVGCoreParsers;

const
  dxThisUnitName = 'dxSVGCore';

type
  TdxGPBrushGradientPointsAccess = class(TdxGPBrushGradientPoints);

  { TdxSVGReferenceFixup }

  TdxSVGReferenceFixup = class
  protected
    Element: TdxSVGElement;
    Node: TdxXMLNode;
    Reference: string;
  public
    constructor Create(AElement: TdxSVGElement; ANode: TdxXMLNode; const AReference: string);
  end;

  { TdxSVGNodeAdapter }

  TdxSVGNodeAdapter = class helper for TdxXMLNode
  public
    procedure SetAttr(const AName: TdxXMLString; const AValue, ADefaultValue: Single); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: Single); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: string); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxAlphaColor); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxGpLineJoin); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxMatrix); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxRectF; AAddNewPrefix: Boolean = False); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxSVGContentUnits); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxSVGFill); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxSVGFillMode); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxSVGLineCapStyle); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxSVGShapeRendering); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxSVGTextAnchor); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValue: TdxSVGValue); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValues: TdxSVGSingleValues); overload;
    procedure SetAttr(const AName: TdxXMLString; const AValues: TdxSVGValues); overload;
  end;

  { TdxSVGAttributeConverter }

  TdxSVGAttributeConverter = class
  protected const
    ReferencePrefix = '#';
    RGBMacro = 'rgb(';
    URLPart1 = 'url(';
    URLPart2 = ')';
  protected const
    ContentUnitsToString: array[TdxSVGContentUnits] of string = ('userSpaceOnUse', 'objectBoundingBox');
    FillRuleToString: array[TdxSVGFillMode] of string = ('nonzero', 'evenodd', 'inherit');
    LineCapToString: array[TdxSVGLineCapStyle] of string = ('', 'butt', 'square', 'round');
    LineJoinToString: array[TdxGpLineJoin] of string = ('miter', 'bevel', 'round', '');
    TextAnchorToString: array[TdxSVGTextAnchor] of string = ('start', 'middle', 'end', 'inherit');
  protected
    class function AlphaColorToString(const AValue: TdxAlphaColor): string;
    class function ReferenceToString(const AValue: string; AIsLocalReference: Boolean): string;
    class function StringToAlphaColor(const AValue: string): TdxAlphaColor;
    class function StringToContentUnits(const S: string): TdxSVGContentUnits;
    class function StringToFillRule(const S: string): TdxSVGFillMode;
    class function StringToLineCap(const S: string): TdxSVGLineCapStyle;
    class function StringToLineJoin(const S: string): TdxGpLineJoin;
    class function StringToReference(S: string): string;
    class function StringToTextAnchor(const S: string): TdxSVGTextAnchor;
  end;

  { TdxSVGAttributeAdapter }

  TdxSVGAttributeAdapter = class helper for TdxXMLNodeAttribute
  strict private
    function GetValueAsColor: TdxAlphaColor;
    function GetValueAsContentUnits: TdxSVGContentUnits;
    function GetValueAsFill: TdxSVGFill;
    function GetValueAsFillMode: TdxSVGFillMode;
    function GetValueAsFloat: Double;
    function GetValueAsLineCap: TdxSVGLineCapStyle;
    function GetValueAsLineJoin: TdxGpLineJoin;
    function GetValueAsRectF: TdxRectF;
    function GetValueAsShapeRendering: TdxSVGShapeRendering;
    function GetValueAsSvgValue: TdxSVGValue;
    function GetValueAsTextAnchor: TdxSVGTextAnchor;
    procedure SetValueAsColor(const AValue: TdxAlphaColor);
    procedure SetValueAsContentUnits(const AValue: TdxSVGContentUnits);
    procedure SetValueAsFill(const AValue: TdxSVGFill);
    procedure SetValueAsFillMode(const AValue: TdxSVGFillMode);
    procedure SetValueAsFloat(const AValue: Double);
    procedure SetValueAsLineCap(const AValue: TdxSVGLineCapStyle);
    procedure SetValueAsLineJoin(const AValue: TdxGpLineJoin);
    procedure SetValueAsRectF(const AValue: TdxRectF);
    procedure SetValueAsShapeRendering(const AValue: TdxSVGShapeRendering);
    procedure SetValueAsSvgValue(const AValue: TdxSVGValue);
    procedure SetValueAsTextAnchor(const AValue: TdxSVGTextAnchor);
  public
    procedure GetValueAsArray(AArray: TdxSVGSingleValues);
    procedure GetValueAsMatrix(AMatrix: TdxMatrix);
    function GetValueAsSvgValues: TdxSVGValues;
    procedure SetValueAsArray(AArray: TdxSVGSingleValues);
    procedure SetValueAsMatrix(AMatrix: TdxMatrix);
    procedure SetValueAsSvgValues(const AValues: TdxSVGValues);

    property ValueAsColor: TdxAlphaColor read GetValueAsColor write SetValueAsColor;
    property ValueAsContentUnits: TdxSVGContentUnits read GetValueAsContentUnits write SetValueAsContentUnits;
    property ValueAsFill: TdxSVGFill read GetValueAsFill write SetValueAsFill;
    property ValueAsFillMode: TdxSVGFillMode read GetValueAsFillMode write SetValueAsFillMode;
    property ValueAsFloat: Double read GetValueAsFloat write SetValueAsFloat;
    property ValueAsLineCap: TdxSVGLineCapStyle read GetValueAsLineCap write SetValueAsLineCap;
    property ValueAsLineJoin: TdxGpLineJoin read GetValueAsLineJoin write SetValueAsLineJoin;
    property ValueAsRectF: TdxRectF read GetValueAsRectF write SetValueAsRectF;
    property ValueAsShapeRendering: TdxSVGShapeRendering read GetValueAsShapeRendering write SetValueAsShapeRendering;
    property ValueAsSvgValue: TdxSVGValue read GetValueAsSvgValue write SetValueAsSvgValue;
    property ValueAsSvgValues: TdxSVGValues read GetValueAsSvgValues write SetValueAsSvgValues;
    property ValueAsTextAnchor: TdxSVGTextAnchor read GetValueAsTextAnchor write SetValueAsTextAnchor;
  end;

function IsZeroVector(const R: TdxRectF): Boolean; inline;
begin
  Result := IsZero(R.Width) and IsZero(R.Height);
end;

function dxSVGFloatToString(const AValue: Single): string;
begin
  Result := FormatFloat('0.#####', AValue, dxInvariantFormatSettings);
end;

function dxGpMeasureString(AFont: TdxGpFont; const AText: string): TdxSizeF;
begin
  dxGPPaintCanvas.BeginPaint(cxMeasureCanvas.Handle, cxSimpleRect);
  try
    Result := dxGPPaintCanvas.MeasureString(AText, AFont);
  finally
    dxGPPaintCanvas.EndPaint;
  end;
end;

{ TdxSVGFill }

class function TdxSVGFill.Create(const AColor: TdxAlphaColor): TdxSVGFill;
begin
  Result.Data := AColor;
end;

class function TdxSVGFill.Create(const AReference: string): TdxSVGFill;
begin
  Result.Data := AReference;
end;

class function TdxSVGFill.Default: TdxSVGFill;
begin
  Result := TdxSVGFill.Create(TdxAlphaColors.Default);
end;

function TdxSVGFill.IsDefault: Boolean;
begin
  Result := VarIsNumeric(Data) and (Data = TdxAlphaColors.Default);
end;

function TdxSVGFill.IsEmpty: Boolean;
begin
  if IsReference then
    Result := AsReference = ''
  else
    Result := AsColor = TdxAlphaColors.Empty;
end;

function TdxSVGFill.IsReference: Boolean;
begin
  Result := VarIsStr(Data);
end;

procedure TdxSVGFill.UpdateReference(const AOldReference, ANewReference: string);
begin
  if IsReference then
  begin
    if dxSameText(AsReference, AOldReference) then
      Data := ANewReference;
  end;
end;

function TdxSVGFill.AsColor: TdxAlphaColor;
begin
  Result := Data;
end;

function TdxSVGFill.AsReference: string;
begin
  if IsReference then
    Result := Data
  else
    Result := '';
end;

{ TdxSVGValue }

class function TdxSVGValue.Create(const AValue: Single; AUnitsType: TdxSVGUnitsType): TdxSVGValue;
begin
  Result.Data := AValue;
  Result.UnitsType := AUnitsType;
end;

function TdxSVGValue.IsEmpty: Boolean;
begin
  Result := IsZero(Data);
end;

class operator TdxSVGValue.Equal(const V1, V2: TdxSVGValue): Boolean;
begin
  Result := (V1.UnitsType = V2.UnitsType) and SameValue(V1.Data, V2.Data);
end;

class operator TdxSVGValue.NotEqual(const V1, V2: TdxSVGValue): Boolean;
begin
  Result := not (V1 = V2);
end;

function TdxSVGValue.ToPixels(ATargetDPI: Integer): Single;
begin
  if UnitsType = utPercents then
    raise EInvalidArgument.Create('TdxSVGValue.ToPixels');
  Result := ToPixels(0, ATargetDPI);
end;

function TdxSVGValue.ToPixels(const AParentSize: Single; ATargetDPI: Integer = dxDefaultDPI): Single;
const
  CMPerInch = 2.54;
begin
  case UnitsType of
    utCm:
      Result := Data / CMPerInch * ATargetDPI;
    utIn:
      Result := Data * ATargetDPI;
    utMm:
      Result := Data / (10 * CMPerInch) * ATargetDPI;
    utPc:
      Result := Data * 12 / 72 * ATargetDPI;
    utPt:
      Result := Data / 72 * ATargetDPI;
    utPercents:
      Result := Data / 100 * AParentSize;
  else // pixels
    Result := Data;
  end;
end;

{ TdxSVGList<T> }

procedure TdxSVGList<T>.Assign(AValues: TdxSVGList<T>);
begin
  Clear;
  Capacity := AValues.Count;
  AddRange(AValues);
end;

{ TdxSVGBrush }

procedure TdxSVGBrush.Assign(ASource: TdxGPCustomGraphicObject);
begin
  inherited;
  if ASource is TdxSVGBrush then
  begin
    GradientMode := TdxSVGBrush(ASource).GradientMode;
    GradientBox := TdxSVGBrush(ASource).GradientBox;
    GradientFocalPoint := TdxSVGBrush(ASource).GradientFocalPoint;
  end;
end;

procedure TdxSVGBrush.CreateGradientBrushHandle(out AHandle: Pointer);
var
  APath: TdxGPPath;
  APoint1: TdxGpPointF;
  APoint2: TdxGpPointF;
  AStopColors: PdxAlphaColor;
  AStopCount: Integer;
  AStopOffsets: PSingle;
begin
  if GradientMode = sbgmNative then
  begin
    inherited CreateGradientBrushHandle(AHandle);
    Exit;
  end;

  if GradientPoints.Count = 0 then
  begin
    CreateSolidBrushHandle(AHandle, TdxAlphaColors.Empty);
    Exit;
  end;

  TdxGPBrushGradientPointsAccess(GradientPoints).CalculateParams(AStopColors, AStopOffsets, AStopCount);

  if GradientMode = sbgmRadial then
  begin
    APath := TdxGPPath.Create;
    try
      APath.FigureStart;
      APath.AddEllipse(GradientBox);
      APath.FigureFinish;

      APoint1 := MakePoint(GradientFocalPoint.X, GradientFocalPoint.Y);
      GdipCheck(GdipCreatePathGradientFromPath(APath.Handle, AHandle));
      GdipCheck(GdipSetPathGradientCenterPoint(AHandle, @APoint1));
      GdipCheck(GdipSetPathGradientPresetBlend(AHandle, AStopColors, AStopOffsets, AStopCount));
    finally
      APath.Free;
    end;
  end
  else
  begin
    APoint1 := MakePoint(GradientBox.Left, GradientBox.Top);
    APoint2 := MakePoint(GradientBox.Right, GradientBox.Bottom);
    GdipCheck(GdipCreateLineBrush(@APoint1, @APoint2, 0, 0, WrapModeTileFlipX, AHandle));
    GdipCheck(GdipSetLinePresetBlend(AHandle, AStopColors, AStopOffsets, AStopCount));
  end;
end;

function TdxSVGBrush.GetGradientModeNative: TdxGPBrushGradientMode;
begin
  Result := inherited GradientMode;
end;

function TdxSVGBrush.NeedRecreateHandleOnTargetRectChange: Boolean;
begin
  Result := GradientMode = sbgmNative;
end;

procedure TdxSVGBrush.SetGradientModeNative(AValue: TdxGPBrushGradientMode);
begin
  inherited GradientMode := AValue;
end;

{ TdxSVGPen }

function TdxSVGPen.CreateBrush: TdxGpBrush;
begin
  Result := TdxSVGBrush.Create;
end;

function TdxSVGPen.GetBrush: TdxSVGBrush;
begin
  Result := inherited Brush as TdxSVGBrush;
end;

{ TdxSVGReferences }

procedure TdxSVGReferences.Clear;
begin
  FCounter := 0;
  inherited Clear;
end;

function TdxSVGReferences.Generate: string;
begin
  repeat
    Result := Format(Template, [FCounter]);
    Inc(FCounter);
  until not Contains(Result);
end;

{ TdxSVGPath }

procedure TdxSVGPath.Assign(ASource: TdxGPPath);
begin
  if ASource is TdxSVGPath then
  begin
    FCommandLine := TdxSVGPath(ASource).FCommandLine;
    inherited;
  end
  else
    raise EInvalidArgument.Create('');
end;

procedure TdxSVGPath.FromString(const S: string);
var
  AParser: TdxSVGParserPath;
  I: Integer;
begin
  Reset;
  FCommandLine := S;
  if S <> '' then
  begin
    AParser := TdxSVGParserPath.Create;
    try
      AParser.Parse(S);
      for I := 0 to AParser.CommandCount - 1 do
        AParser.Commands[I].Append(Self);
    finally
      AParser.Free;
    end;
  end;
end;

function TdxSVGPath.ToString: string;
begin
  Result := FCommandLine;
end;

{ TdxSVGPoints }

procedure TdxSVGPoints.Assign(const P: array of TdxPointF);
var
  I: Integer;
begin
  Clear;
  Capacity := Length(P);
  for I := 0 to Length(P) - 1 do
    Add(P[I]);
end;

procedure TdxSVGPoints.Assign(const P: array of TPoint);
var
  I: Integer;
begin
  Clear;
  Capacity := Length(P);
  for I := 0 to Length(P) - 1 do
    Add(dxPointF(P[I]));
end;

function TdxSVGPoints.BoudingRect: TdxRectF;
var
  APoint: TdxPointF;
  I: Integer;
begin
  if Count > 0 then
  begin
    APoint := Items[0];
    Result.Left := APoint.X;
    Result.Top := APoint.Y;
    Result.Right := APoint.X;
    Result.Bottom := APoint.Y;
    for I := 1 to Count - 1 do
    begin
      APoint := Items[I];
      Result.Left := Min(Result.Left, APoint.X);
      Result.Top := Min(Result.Top, APoint.Y);
      Result.Right := Max(Result.Right, APoint.X);
      Result.Bottom := Max(Result.Bottom, APoint.Y);
    end;
  end
  else
    Result := cxInvalidRect;
end;

{ TdxSVGRect }

function TdxSVGRect.GetHeight: Single;
begin
  Result := Value.Height;
end;

function TdxSVGRect.GetWidth: Single;
begin
  Result := Value.Width;
end;

function TdxSVGRect.IsEmpty: Boolean;
begin
  Result := FValue.IsEmpty;
end;

{ TdxSVGCustomRenderer }

constructor TdxSVGCustomRenderer.Create(APalette: IdxColorPalette);
begin
  FPen := CreatePen;
  FBrush := CreateBrush;
  FPalette := APalette;
  FSavedWorldTransforms := TStack.Create;
  FWorldTransform := TdxGPMatrix.Create;
  SetOpacity(1.0);
  FShapeRendering := TdxSVGShapeRendering.srCrispEdges;
end;

destructor TdxSVGCustomRenderer.Destroy;
begin
  FreeAndNil(FSavedWorldTransforms);
  FreeAndNil(FWorldTransform);
  FreeAndNil(FBrush);
  FreeAndNil(FPen);
  inherited Destroy;
end;

procedure TdxSVGCustomRenderer.EnableAntialiasing(AEnable: Boolean);
begin
  // do nothing
end;

procedure TdxSVGCustomRenderer.InitializeAppearance(AElement: TdxSVGElement);
begin
  AElement.InitializePen(Self, AElement);
  AElement.InitializeBrush(Self, AElement);
end;

function TdxSVGCustomRenderer.MakeColor(AColor: TdxAlphaColor; AOpacity: Single): TdxAlphaColor;
begin
  if FOpacityAssigned then
    AOpacity := AOpacity * FOpacity;

  if (AOpacity < 1) and dxAlphaColorIsValid(AColor) then
  begin
    with dxAlphaColorToRGBQuad(AColor) do
      Result := dxMakeAlphaColor(Trunc(rgbReserved * AOpacity), rgbRed, rgbGreen, rgbBlue);
  end
  else
    Result := AColor;

  if dxSVGAutoDarkMode and dxAlphaColorIsValid(Result) then
    Result := TdxColorUtils.InvertLightness(Result);
end;

function TdxSVGCustomRenderer.ModifyOpacity(const AOpacity: Single): Single;
begin
  Result := FOpacity;
  SetOpacity(Result * AOpacity);
end;

procedure TdxSVGCustomRenderer.ModifyWorldTransform(const AMatrix: TXForm);
var
  AGpMatrix: TdxGPMatrix;
begin
  AGpMatrix := TdxGPMatrix.CreateEx(AMatrix);
  try
    ModifyWorldTransform(AGpMatrix);
  finally
    AGpMatrix.Free;
  end;
end;

procedure TdxSVGCustomRenderer.ModifyWorldTransform(const AMatrix: TdxGPMatrix);
begin
  WorldTransform.Multiply(AMatrix);
end;

procedure TdxSVGCustomRenderer.RestoreAntialiasing;
begin
  // do nothing
end;

procedure TdxSVGCustomRenderer.RestoreWorldTransform;
begin
  FreeAndNil(FWorldTransform);
  FWorldTransform := FSavedWorldTransforms.Pop;
end;

procedure TdxSVGCustomRenderer.SaveWorldTransform;
begin
  FSavedWorldTransforms.Push(WorldTransform.Clone);
end;

procedure TdxSVGCustomRenderer.SetOpacity(const AOpacity: Single);
begin
  FOpacity := AOpacity;
  FOpacityAssigned := not SameValue(FOpacity, 1.0);
end;

function TdxSVGCustomRenderer.CreateBrush: TdxSVGBrush;
begin
  Result := TdxSVGBrush.Create;
end;

function TdxSVGCustomRenderer.CreatePen: TdxSVGPen;
begin
  Result := TdxSVGPen.Create;
end;

function TdxSVGCustomRenderer.TransformPenWidth(AWidth: Single): Single;
begin
  Result := AWidth;
end;

{ TdxSVGRenderer }

constructor TdxSVGRenderer.Create(ACanvas: TdxGPCanvas; APalette: IdxColorPalette = nil);
begin
  inherited Create(APalette);
  FCanvas := ACanvas;
end;

procedure TdxSVGRenderer.Draw(const AImage: TdxSmartImage; const R: TdxRectF);
begin
  FCanvas.Draw(AImage, R, Trunc(MaxByte * Opacity));
end;

procedure TdxSVGRenderer.Ellipse(const R: TdxRectF);
begin
  FCanvas.Ellipse(R, Pen, Brush);
end;

procedure TdxSVGRenderer.EnableAntialiasing(AEnable: Boolean);
begin
  FCanvas.EnableAntialiasing(AEnable);
end;

procedure TdxSVGRenderer.Line(const X1, Y1, X2, Y2: Single);
begin
  FCanvas.Line(X1, Y1, X2, Y2, Pen);
end;

procedure TdxSVGRenderer.Path(APath: TdxGPPath);
begin
  FCanvas.Path(APath, Pen, Brush);
end;

procedure TdxSVGRenderer.Polygon(const APoints: array of TdxPointF; const AUsePen: Boolean = True);
begin
  if AUsePen then
    FCanvas.Polygon(APoints, Pen, Brush)
  else
    FCanvas.Polygon(APoints, nil, Brush)
end;

procedure TdxSVGRenderer.Polyline(const APoints: array of TdxPointF);
begin
  FCanvas.Polyline(APoints, Pen);
end;

procedure TdxSVGRenderer.Rectangle(const R: TdxRectF);
begin
  FCanvas.Rectangle(R, Pen, Brush);
end;

procedure TdxSVGRenderer.RoundRect(const R: TdxRectF; ARadiusX, ARadiusY: Single);
var
  APath: TdxGPPath;
begin
  APath := TdxGPPath.Create;
  try
    APath.AddRoundRect(R, ARadiusX, ARadiusY);
    Path(APath);
  finally
    APath.Free;
  end;
end;

procedure TdxSVGRenderer.TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont);
begin
  FCanvas.DrawString(AText, AFont, Brush, X, Y);
end;

procedure TdxSVGRenderer.RestoreAntialiasing;
begin
  FCanvas.RestoreAntialiasing;
end;

procedure TdxSVGRenderer.RestoreClipRegion;
begin
  FCanvas.RestoreClipRegion;
end;

procedure TdxSVGRenderer.SaveClipRegion;
begin
  FCanvas.SaveClipRegion;
end;

procedure TdxSVGRenderer.SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode = gmIntersect);
begin
  FCanvas.SetClipPath(APath, AMode);
end;

procedure TdxSVGRenderer.ModifyWorldTransform(const AMatrix: TdxGPMatrix);
begin
  inherited ModifyWorldTransform(AMatrix);
  FCanvas.ModifyWorldTransform(AMatrix);
end;

procedure TdxSVGRenderer.RestoreWorldTransform;
begin
  inherited RestoreWorldTransform;
  FCanvas.RestoreWorldTransform;
end;

procedure TdxSVGRenderer.SaveWorldTransform;
begin
  inherited SaveWorldTransform;
  FCanvas.SaveWorldTransform;
end;

function TdxSVGRenderer.TransformPenWidth(AWidth: Single): Single;
var
  AMatrix: TdxGPMatrix;
  AXForm: TXForm;
begin
  if AWidth > 0 then
  begin
    AMatrix := FCanvas.GetWorldTransform;
    try
      AXForm := AMatrix.ToXForm;
      AXForm.eDx := 0;
      AXForm.eDy := 0;
      Result := TdxVectors.Length(AXForm.Transform(dxPointF(AWidth, AWidth))) / TdxVectors.Length(1, 1);
    finally
      AMatrix.Free;
    end;
  end
  else
    Result := 0;
end;

{ TdxSVGRendererClipPath }

constructor TdxSVGRendererClipPath.Create(AClipRule: TdxGPFillMode);
begin
  inherited Create(nil);
  FFillMode := AClipRule;
  FClipPath := TdxGPPath.Create(AClipRule);
end;

destructor TdxSVGRendererClipPath.Destroy;
begin
  FreeAndNil(FSavedTransforms);
  FreeAndNil(FTransforms);
  FreeAndNil(FClipPath);
  inherited Destroy;
end;

procedure TdxSVGRendererClipPath.ApplyClipRule(AClipRule: TdxGPFillMode);
begin
  FFillMode := AClipRule;
  if ClipPath.FillMode <> AClipRule then
    ClipPath.FillMode := AClipRule;
end;

procedure TdxSVGRendererClipPath.Draw(const AImage: TdxSmartImage; const R: TdxRectF);
begin
  // do nothing
end;

procedure TdxSVGRendererClipPath.Ellipse(const R: TdxRectF);
begin
  ClipPath.AddEllipse(TransformRect(R));
end;

procedure TdxSVGRendererClipPath.InitializeAppearance(AElement: TdxSVGElement);
begin
  inherited;
  ApplyClipRule(AElement.GetActualClipRule);
end;

procedure TdxSVGRendererClipPath.Line(const X1, Y1, X2, Y2: Single);
begin
  ClipPath.AddLine(TransformPoint(TdxPointF.Create(X1, Y1)), TransformPoint(TdxPointF.Create(X2, Y2)));
end;

procedure TdxSVGRendererClipPath.Path(APath: TdxGPPath);
var
  ATempPath: TdxGPPath;
begin
  ATempPath := TdxGPPath.Create;
  try
    ATempPath.Assign(APath);
    ATempPath.FillMode := FFillMode;
    TransformPath(ATempPath);
    ClipPath.AddPath(ATempPath);
  finally
    ATempPath.Free;
  end;
end;

procedure TdxSVGRendererClipPath.Polygon(const APoints: array of TdxPointF; const AUsePen: Boolean = True);
var
  I: Integer;
  ATempArray: array of TdxPointF;
begin
  SetLength(ATempArray, Length(APoints));
  for I := 0 to Length(APoints) - 1 do
    ATempArray[I] := TransformPoint(APoints[I]);
  ClipPath.AddPolygon(ATempArray);
end;

procedure TdxSVGRendererClipPath.Polyline(const APoints: array of TdxPointF);
var
  I: Integer;
  ATempArray: array of TdxPointF;
begin
  SetLength(ATempArray, Length(APoints));
  for I := 0 to Length(APoints) - 1 do
    ATempArray[I] := TransformPoint(APoints[I]);
  ClipPath.AddPolyline(ATempArray);
end;

procedure TdxSVGRendererClipPath.Rectangle(const R: TdxRectF);
begin
  ClipPath.AddRect(TransformRect(R));
end;

procedure TdxSVGRendererClipPath.RoundRect(const R: TdxRectF; ARadiusX, ARadiusY: Single);
begin
  ClipPath.AddRoundRect(TransformRect(R), ARadiusX, ARadiusY);
end;

procedure TdxSVGRendererClipPath.TextOut(const X, Y: Single; const AText: string; AFont: TdxGPFont);
var
  ATextSize: TdxSizeF;
  ATextRect: TdxRectF;
begin
  ATextSize := dxGpMeasureString(AFont, AText);
  ATextRect := TransformRect(dxRectF(X, Y, X + ATextSize.Width, Y + ATextSize.Height));
  ClipPath.AddString(AText, AFont, nil, ATextRect);
end;

procedure TdxSVGRendererClipPath.TransformPath(APath: TdxGPPath);
var
  I: Integer;
begin
  if FTransforms = nil then
    Exit;
  for I := 0 to FTransforms.Count- 1 do
    APath.Transform(FTransforms.Items[I]);
end;

function TdxSVGRendererClipPath.TransformPoint(const P: TdxPointF): TdxPointF;
var
  I: Integer;
begin
  Result := P;
  if FTransforms = nil then
    Exit;
  for I := 0 to FTransforms.Count- 1 do
    Result := FTransforms.Items[I].TransformPoint(Result);
end;

function TdxSVGRendererClipPath.TransformRect(const R: TdxRectF): TdxRectF;
var
  I: Integer;
begin
  Result := R;
  if FTransforms = nil then
    Exit;
  for I := 0 to FTransforms.Count- 1 do
    Result := FTransforms.Items[I].TransformRect(Result);
end;

procedure TdxSVGRendererClipPath.ModifyWorldTransform(const AMatrix: TdxGPMatrix);
begin
  inherited;
  if FTransforms = nil then
    FTransforms := TObjectList<TdxGPMatrix>.Create;
  FTransforms.Add(AMatrix.Clone);
end;

procedure TdxSVGRendererClipPath.RestoreWorldTransform;
var
  AIndex, I: Integer;
begin
  inherited;
  if (FSavedTransforms <> nil) and (FSavedTransforms.Count > 0) then
  begin
    AIndex := FSavedTransforms.Last;
    FSavedTransforms.Delete(FSavedTransforms.Count - 1);
    for I := FTransforms.Count - 1 downto AIndex + 1 do
    begin
      FTransforms[I].Invert;
      FTransforms.Delete(I);
    end;
  end;
end;

procedure TdxSVGRendererClipPath.SaveWorldTransform;
begin
  inherited;
  if FTransforms <> nil then
  begin
    if FSavedTransforms = nil then
      FSavedTransforms := TdxIntegerList.Create;
    FSavedTransforms.Add(FTransforms.Count - 1);
  end;
end;

procedure TdxSVGRendererClipPath.RestoreClipRegion;
begin
  // do nothing
end;

procedure TdxSVGRendererClipPath.SaveClipRegion;
begin
  // do nothing
end;

procedure TdxSVGRendererClipPath.SetClipRegion(APath: TdxGPPath; AMode: TdxGPCombineMode);
begin
  // do nothing
end;

{ TdxSVGElement }

constructor TdxSVGElement.Create;
begin
  inherited Create;
  FOpacity := 1.0;
  FFillOpacity := 1.0;
  FStrokeOpacity := 1.0;
  FStrokeMiterLimit := 4;
  FStrokeDashOffset := -1; // default
  FStrokeDashArray := TdxSVGSingleValues.Create;
  FTransform := TdxMatrix.Create;
  Stroke := TdxSVGFill.Default;
  Fill := TdxSVGFill.Default;
end;

constructor TdxSVGElement.Create(AParent: TdxSVGElement);
begin
  Create;
  Parent := AParent;
end;

destructor TdxSVGElement.Destroy;
begin
  FreeAndNil(FStrokeDashArray);
  FreeAndNil(FTransform);
  FreeAndNil(FChildren);
  inherited Destroy;
end;

procedure TdxSVGElement.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if (Source is TdxSVGElement) and (Source <> Self) then
  begin
    FreeAndNil(FChildren);
    AssignCore(TdxSVGElement(Source));
    for I := 0 to TdxSVGElement(Source).Count - 1 do
      TdxSVGElement(Source).Elements[I].Clone.Parent := Self;
  end
  else
    inherited;
end;

function TdxSVGElement.Clone: TdxSVGElement;
begin
  Result := TdxSVGElementClass(ClassType).Create;
  Result.Assign(Self);
end;

procedure TdxSVGElement.Draw(ARenderer: TdxSVGCustomRenderer);
var
  AHasTransform: Boolean;
  APrevOpacity: Single;
begin
  APrevOpacity := ARenderer.ModifyOpacity(Opacity);
  AHasTransform := not Transform.IsIdentity;
  if AHasTransform then
  begin
    ARenderer.SaveWorldTransform;
    ARenderer.ModifyWorldTransform(Transform.XForm);
  end;
  ARenderer.InitializeAppearance(Self);

  if HasClipping then
  begin
    ARenderer.SaveClipRegion;
    try
      ApplyClipping(ARenderer);
      DrawCoreAndChildren(ARenderer);
    finally
      ARenderer.RestoreClipRegion;
    end;
  end
  else
    DrawCoreAndChildren(ARenderer);

  if AHasTransform then
    ARenderer.RestoreWorldTransform;
  ARenderer.SetOpacity(APrevOpacity);
end;

function TdxSVGElement.FindByID(const ID: string; out AElement: TdxSVGElement): Boolean;
var
  I: Integer;
begin
  if ID = '' then
    Exit(False);

  for I := 0 to Count - 1 do
    if dxSameText(Elements[I].ID, ID) then
    begin
      AElement := Elements[I];
      Exit(True);
    end;

  for I := 0 to Count - 1 do
  begin
    if Elements[I].FindByID(ID, AElement) then
      Exit(True);
  end;

  Result := False;
end;

function TdxSVGElement.FindByID(const ID: string; AClass: TdxSVGElementClass; out AElement): Boolean;
var
  ATempElement: TdxSVGElement;
begin
  Result := Root.FindByID(ID, ATempElement) and ATempElement.InheritsFrom(AClass);
  if Result then
    TObject(AElement) := ATempElement;
end;

procedure TdxSVGElement.AssignCore(ASource: TdxSVGElement);
var
  ANode: TdxXMLNode;
begin
  ANode := TdxXMLNode.Create;
  try
    ASource.Save(ANode);
    Load(ANode);
  finally
    ANode.Free;
  end;
end;

function TdxSVGElement.GetRoot: TdxSVGElementRoot;
begin
  if Parent <> nil then
    Result := Parent.Root
  else
    Result := nil;
end;

function TdxSVGElement.IsInheritanceSupported: Boolean;
begin
  Result := True;
end;

procedure TdxSVGElement.UpdateReference(const AOldReference, ANewReference: string);
var
  I: Integer;
begin
  if dxSameText(ID, AOldReference) then
    ID := ANewReference;
  if dxSameText(ClipPath, AOldReference) then
    ClipPath := ANewReference;
  Stroke.UpdateReference(AOldReference, ANewReference);
  Fill.UpdateReference(AOldReference, ANewReference);

  for I := 0 to Count - 1 do
    Elements[I].UpdateReference(AOldReference, ANewReference);
end;

procedure TdxSVGElement.ApplyClipping(ARenderer: TdxSVGCustomRenderer);
var
  AClipPath: TdxSVGElementClipPath;
begin
  if (ClipPath <> '') and Root.FindByID(ClipPath, TdxSVGElementClipPath, AClipPath) then
    AClipPath.ApplyTo(ARenderer, Self);
end;

function TdxSVGElement.HasClipping: Boolean;
begin
  Result := ClipPath <> '';
end;

procedure TdxSVGElement.InitializeBrush(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement);
var
  AElement: TdxSVGElement;
  AFill: TdxSVGFill;
  ASVGLinearGradientPalette: IdxSVGLinearGradientPalette;
  AElementGradient: TdxSVGElementLinearGradient;
begin
  if (TagName <> '') and Supports(ARenderer.Palette, IdxSVGLinearGradientPalette, ASVGLinearGradientPalette)
    and (ASVGLinearGradientPalette.GetLinearGradient(TagName, AElementGradient)) then
  begin
    AElementGradient.InitializeBrush(ARenderer, ACaller);
    FreeAndNil(AElementGradient);
  end
  else
  begin
    AFill := GetActualFill(ARenderer.Palette);
    if AFill.IsReference then
    begin
      if Root.FindByID(AFill.AsReference, AElement) then
        AElement.InitializeBrush(ARenderer, ACaller);
    end
    else
    begin
      ARenderer.Brush.Style := gpbsSolid;
      ARenderer.Brush.Color := ARenderer.MakeColor(AFill.AsColor, FillOpacity);
    end;
  end;
end;

procedure TdxSVGElement.InitializePen(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement);
const
  LineCapMap: array[TdxSVGLineCapStyle] of TdxGPPenLineCapStyle = (gpcsFlat, gpcsFlat, gpcsSquare, gpcsRound);
var
  ADashes: TArray<Single>;
  AElement: TdxSVGElement;
  APen: TdxSVGPen;
  APenWidth: Single;
  AStrokeFill: TdxSVGFill;
  I: Integer;
begin
  APen := ARenderer.Pen;
  AStrokeFill := GetActualStroke(ARenderer.Palette);
  if AStrokeFill.IsReference then
  begin
    if Root.FindByID(AStrokeFill.AsReference, AElement) then
      AElement.InitializePen(ARenderer, ACaller);
  end
  else
  begin
    APen.Brush.Style := gpbsSolid;
    APen.Brush.Color := ARenderer.MakeColor(AStrokeFill.AsColor, StrokeOpacity);
  end;

  APenWidth := GetActualStrokeSize;

  APen.Style := gppsSolid;
  APen.LineJoin := StrokeLineJoin;
  APen.LineStartCapStyle := LineCapMap[GetActualStrokeLineCap];
  APen.LineEndCapStyle := APen.LineStartCapStyle;
  APen.MiterLimit := StrokeMiterLimit;
  APen.Width := ARenderer.TransformPenWidth(APenWidth);

  ADashes := GetActualStrokeDashArray.ToArray;
  if Length(ADashes) > 0 then
  begin
    for I := Low(ADashes) to High(ADashes) do
      ADashes[I] := ADashes[I] / APenWidth;

    APen.Style := gppsDash;
    GdipSetPenDashArray(APen.Handle, @ADashes[0], Length(ADashes));
    GdipSetPenDashOffset(APen.Handle, GetActualStrokeDashOffset);
  end;
end;

procedure TdxSVGElement.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  // do nothing
end;

procedure TdxSVGElement.DrawCoreAndChildren(ARenderer: TdxSVGCustomRenderer);
var
  I: Integer;
begin
  EnableAntialiasing(ARenderer);
  DrawCore(ARenderer);
  for I := 0 to Count - 1 do
    Elements[I].Draw(ARenderer);
  RestoreAntialiasing(ARenderer);
end;

procedure TdxSVGElement.EnableAntialiasing(ARenderer: TdxSVGCustomRenderer);
begin
  // do nothing
end;

function TdxSVGElement.GetBounds: TdxRectF;
begin
  Result := Root.GetBounds;
end;

function TdxSVGElement.GetX(const X: TdxSVGValue): Single;
begin
  Result := X.ToPixels(Root.Size.Width);
end;

function TdxSVGElement.GetY(const Y: TdxSVGValue): Single;
begin
  Result := Y.ToPixels(Root.Size.Height);
end;

procedure TdxSVGElement.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  if ANode.Attributes.Find(TdxSVGSchema.ID, AAttr) then
    ID := AAttr.ValueAsString;
  if ANode.Attributes.Find(TdxSVGSchema.ClassName, AAttr) then
    StyleName := AAttr.ValueAsString;
  if ANode.Attributes.Find(TdxSVGSchema.Tag, AAttr) then
    TagName := AAttr.ValueAsString;
  if ANode.Attributes.Find(TdxSVGSchema.ClipPath, AAttr) then
    ClipPath := TdxSVGAttributeConverter.StringToReference(AAttr.ValueAsString);
  if ANode.Attributes.Find(TdxSVGSchema.ClipRule, AAttr) then
    ClipRule := AAttr.ValueAsFillMode;
  if ANode.Attributes.Find(TdxSVGSchema.Fill, AAttr) then
    Fill := AAttr.ValueAsFill;
  if ANode.Attributes.Find(TdxSVGSchema.FillRule, AAttr) then
    FillMode := AAttr.ValueAsFillMode;
  if ANode.Attributes.Find(TdxSVGSchema.FillOpacity, AAttr) then
    FillOpacity := AAttr.ValueAsFloat;
  if ANode.Attributes.Find(TdxSVGSchema.Opacity, AAttr) then
    Opacity := AAttr.ValueAsFloat;
  if ANode.Attributes.Find(TdxSVGSchema.Stroke, AAttr) then
    Stroke := AAttr.ValueAsFill;
  if ANode.Attributes.Find(TdxSVGSchema.StrokeOpacity, AAttr) then
    StrokeOpacity := AAttr.ValueAsFloat;
  if ANode.Attributes.Find(TdxSVGSchema.StrokeDashArray, AAttr) then
    AAttr.GetValueAsArray(StrokeDashArray);
  if ANode.Attributes.Find(TdxSVGSchema.StrokeDashOffset, AAttr) then
    StrokeDashOffset := AAttr.ValueAsFloat;
  if ANode.Attributes.Find(TdxSVGSchema.StrokeWidth, AAttr) then
    StrokeSize := AAttr.ValueAsSvgValue.ToPixels(0.0);
  if ANode.Attributes.Find(TdxSVGSchema.StrokeLineCap, AAttr) then
    StrokeLineCap := AAttr.ValueAsLineCap;
  if ANode.Attributes.Find(TdxSVGSchema.StrokeLineJoin, AAttr) then
    StrokeLineJoin := AAttr.ValueAsLineJoin;
  if ANode.Attributes.Find(TdxSVGSchema.StrokeMiterLimit, AAttr) then
    StrokeMiterLimit := AAttr.ValueAsFloat;
  if ANode.Attributes.Find(TdxSVGSchema.Transform, AAttr) then
    AAttr.GetValueAsMatrix(Transform);
end;

procedure TdxSVGElement.RestoreAntialiasing(ARenderer: TdxSVGCustomRenderer);
begin
  // do nothing
end;

procedure TdxSVGElement.Save(const ANode: TdxXMLNode);
begin
  ANode.SetAttr(TdxSVGSchema.ID, ID);

  ANode.SetAttr(TdxSVGSchema.ClipPath, TdxSVGAttributeConverter.ReferenceToString(ClipPath, False));
  ANode.SetAttr(TdxSVGSchema.ClipRule, ClipRule);
  ANode.SetAttr(TdxSVGSchema.Transform, Transform);
  ANode.SetAttr(TdxSVGSchema.Opacity, Opacity, 1);

  ANode.SetAttr(TdxSVGSchema.Fill, Fill);
  if not Fill.IsEmpty then
  begin
    ANode.SetAttr(TdxSVGSchema.FillRule, FillMode);
    ANode.SetAttr(TdxSVGSchema.FillOpacity, FillOpacity, 1);
  end;

  ANode.SetAttr(TdxSVGSchema.Stroke, Stroke);
  if not Stroke.IsEmpty then
  begin
    ANode.SetAttr(TdxSVGSchema.StrokeOpacity, StrokeOpacity, 1);
    ANode.SetAttr(TdxSVGSchema.StrokeDashArray, StrokeDashArray);
    ANode.SetAttr(TdxSVGSchema.StrokeDashOffset, StrokeDashOffset, -1);
    ANode.SetAttr(TdxSVGSchema.StrokeLineCap, StrokeLineCap);
    ANode.SetAttr(TdxSVGSchema.StrokeLineJoin, StrokeLineJoin);
    ANode.SetAttr(TdxSVGSchema.StrokeMiterLimit, StrokeMiterLimit, 4);
    ANode.SetAttr(TdxSVGSchema.StrokeWidth, StrokeSize, 0);
  end;
end;

function TdxSVGElement.GetActualClipRule: TdxGPFillMode;
begin
  case ClipRule of
    fmEvenOdd:
      Result := gpfmAlternate;
    fmNonZero:
      Result := gpfmWinding;
  else
    // fmInherit
    if (Parent <> nil) and (StyleName <> 'clipPath') then
      Result := Parent.GetActualClipRule
    else
      Result := gpfmWinding;
  end;
end;

function TdxSVGElement.GetActualFill(APalette: IdxColorPalette): TdxSVGFill;
var
  AlphaColor: TdxAlphaColor;
  AID: string;
begin
  if Fill.IsEmpty then
    Exit(Fill);

  if APalette <> nil then
  begin
    AlphaColor := APalette.GetFillColor(TagName);
    if AlphaColor = TdxAlphaColors.Default then
      AlphaColor := APalette.GetFillColor(StyleName);

    if AlphaColor = TdxAlphaColors.Default then
    begin
      AID := StyleName;
      if LowerCase(Copy(AID, 1, 3)) = 'alt' then
        Delete(AID, 1, 3)
      else
        AID := StringReplace(AID, ' (addl)', '', [rfIgnoreCase]);
      AlphaColor := APalette.GetFillColor(AID);
    end;
    Result := TdxSVGFill.Create(AlphaColor);
  end
  else
    Result := TdxSVGFill.Default;

  if Result.IsDefault then
    Result := Fill;

  if Result.IsDefault then
    if Parent <> nil then
      Result := Parent.GetActualFill(APalette)
    else
    begin
      if APalette <> nil then
        Result := TdxSVGFill.Create(APalette.GetFillColor(TdxAlphaColors.GetColorName(TdxAlphaColors.Black)));
      if Result.IsDefault then 
        Result := TdxSVGFill.Create(TdxAlphaColors.Black);
    end;
end;

function TdxSVGElement.GetActualFillMode: TdxGPFillMode;
begin
  case FillMode of
    fmEvenOdd:
      Result := gpfmAlternate;
    fmNonZero:
      Result := gpfmWinding;
  else
    // fmInherit
    if Parent <> nil then
      Result := Parent.GetActualFillMode
    else
      Result := gpfmWinding;
  end;
end;

function TdxSVGElement.GetActualStroke(APalette: IdxColorPalette): TdxSVGFill;
var
  AlphaColor: TdxAlphaColor;
  AID: string;
begin
  if (APalette <> nil) and not Stroke.IsDefault then
  begin
    AlphaColor := APalette.GetStrokeColor(TagName);
    if AlphaColor = TdxAlphaColors.Default then
      AlphaColor := APalette.GetStrokeColor(StyleName);
    if AlphaColor = TdxAlphaColors.Default then
    begin
      AID := StyleName;
      if LowerCase(Copy(AID, 1, 3)) = 'alt' then
        Delete(AID, 1, 3)
      else
        AID := StringReplace(AID, ' (addl)', '', [rfIgnoreCase]);
      AlphaColor := APalette.GetStrokeColor(AID);
    end;
    Result := TdxSVGFill.Create(AlphaColor);
  end
  else
    Result := TdxSVGFill.Default;

  if Result.IsDefault then
    Result := Stroke;

  if Result.IsDefault then
  begin
    if Parent <> nil then
      Result := Parent.GetActualStroke(APalette)
    else if APalette <> nil then
      Result := TdxSVGFill.Create(APalette.GetStrokeColor(TdxAlphaColors.GetColorName(TdxAlphaColors.Empty)))
    else
      Result := TdxSVGFill.Create(TdxAlphaColors.Empty);
  end;
end;

function TdxSVGElement.GetActualStrokeDashArray: TdxSVGSingleValues;
begin
  Result := StrokeDashArray;
  if (Result.Count = 0) and (Parent <> nil) then
    Result := Parent.GetActualStrokeDashArray;
end;

function TdxSVGElement.GetActualStrokeDashOffset: Single;
begin
  Result := StrokeDashOffset;
  if Result < 0 then
  begin
    if Parent <> nil then
      Result := Parent.GetActualStrokeDashOffset
    else
      Result := 0;
  end;
end;

function TdxSVGElement.GetActualStrokeLineCap: TdxSVGLineCapStyle;
begin
  Result := StrokeLineCap;
  if (Result = lcsDefault) and (Parent <> nil) then
    Result := Parent.GetActualStrokeLineCap;
end;

function TdxSVGElement.GetActualStrokeSize: Single;
begin
  Result := StrokeSize;
  if Result = 0 then
  begin
    if Parent <> nil then
      Result := Parent.GetActualStrokeSize
    else
      Result := 1;
  end;
end;

function TdxSVGElement.GetCount: Integer;
begin
  if FChildren <> nil then
    Result := FChildren.Count
  else
    Result := 0;
end;

function TdxSVGElement.GetElement(Index: Integer): TdxSVGElement;
begin
  if FChildren <> nil then
    Result := TdxSVGElement(FChildren[Index])
  else
    raise EInvalidArgument.CreateFmt(SListIndexError, [Index]);
end;

procedure TdxSVGElement.SetFillOpacity(const Value: Single);
begin
  FFillOpacity := EnsureRange(Value, 0, 1);
end;

procedure TdxSVGElement.SetOpacity(const Value: Single);
begin
  FOpacity := EnsureRange(Value, 0, 1);
end;

procedure TdxSVGElement.SetParent(const AParent: TdxSVGElement);
begin
  if AParent <> FParent then
  begin
    if FParent <> nil then
    begin
      FParent.FChildren.Extract(Self);
      FParent := nil;
    end;
    if AParent <> nil then
    begin
      FParent := AParent;
      if FParent.FChildren = nil then
        FParent.FChildren := TObjectList.Create;
      FParent.FChildren.Add(Self)
    end;
  end;
end;

procedure TdxSVGElement.SetStrokeDashArray(const Value: TdxSVGSingleValues);
begin
  FStrokeDashArray.Assign(Value);
end;

procedure TdxSVGElement.SetStrokeOpacity(const Value: Single);
begin
  FStrokeOpacity := EnsureRange(Value, 0, 1);
end;

procedure TdxSVGElement.SetTransform(const Value: TdxMatrix);
begin
  FTransform.Assign(Value);
end;

{ TdxSVGElementGroup }

procedure TdxSVGElementGroup.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.Tag, AAttr) then
    Tag := AAttr.ValueAsString;
end;

procedure TdxSVGElementGroup.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.Tag, Tag);
end;

{ TdxSVGShapedElement }

procedure TdxSVGShapedElement.EnableAntialiasing(ARenderer: TdxSVGCustomRenderer);
var
  AEnable: Boolean;
begin
  case ARenderer.ShapeRendering of
    TdxSVGShapeRendering.srAuto:
      AEnable := ShapeRendering in [TdxSVGShapeRendering.srAuto, TdxSVGShapeRendering.srGeometricPrecision];
    TdxSVGShapeRendering.srOptimizeSpeed:
      AEnable := ShapeRendering in [TdxSVGShapeRendering.srGeometricPrecision];
    TdxSVGShapeRendering.srCrispEdges:
      AEnable := False;
    TdxSVGShapeRendering.srGeometricPrecision:
      AEnable := True
  else
    AEnable := False;
  end;
  ARenderer.EnableAntialiasing(AEnable);
end;

procedure TdxSVGShapedElement.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.ShapeRendering, AAttr) then
    ShapeRendering := AAttr.ValueAsShapeRendering;
end;

procedure TdxSVGShapedElement.RestoreAntialiasing(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.RestoreAntialiasing;
end;

procedure TdxSVGShapedElement.Save(const ANode: TdxXMLNode);
begin
  inherited;
  if ShapeRendering <> TdxSVGShapeRendering.srAuto then
    ANode.SetAttr(TdxSVGSchema.ShapeRendering, FShapeRendering);
end;

{ TdxSVGElementCircle }

procedure TdxSVGElementCircle.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Ellipse(GetBounds);
end;

function TdxSVGElementCircle.GetBounds: TdxRectF;
begin
  Result := dxEllipseF(GetX(CenterX), GetY(CenterY), GetX(Radius), GetY(Radius));
end;

procedure TdxSVGElementCircle.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.CenterX, AAttr) then
    CenterX := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.CenterY, AAttr) then
    CenterY := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Radius, AAttr) then
    Radius := AAttr.ValueAsSvgValue;
end;

procedure TdxSVGElementCircle.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.CenterX, CenterX);
  ANode.SetAttr(TdxSVGSchema.CenterY, CenterY);
  ANode.SetAttr(TdxSVGSchema.Radius, Radius);
end;

{ TdxSVGElementEllipse }

procedure TdxSVGElementEllipse.SetBounds(const R: TdxRectF; AUnitsType: TdxSVGUnitsType);
var
  ACenter: TdxPointF;
begin
  ACenter := R.CenterPoint;
  CenterX := TdxSVGValue.Create(ACenter.X, AUnitsType);
  CenterY := TdxSVGValue.Create(ACenter.Y, AUnitsType);
  RadiusX := TdxSVGValue.Create(R.Width / 2, AUnitsType);
  RadiusY := TdxSVGValue.Create(R.Height / 2, AUnitsType);
end;

procedure TdxSVGElementEllipse.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Ellipse(GetBounds);
end;

function TdxSVGElementEllipse.GetBounds: TdxRectF;
begin
  Result := dxEllipseF(GetX(CenterX), GetY(CenterY), GetX(RadiusX), GetY(RadiusY));
end;

procedure TdxSVGElementEllipse.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.CenterX, AAttr) then
    CenterX := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.CenterY, AAttr) then
    CenterY := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.RadiusX, AAttr) then
    RadiusX := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.RadiusY, AAttr) then
    RadiusY := AAttr.ValueAsSvgValue;
end;

procedure TdxSVGElementEllipse.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.CenterX, CenterX);
  ANode.SetAttr(TdxSVGSchema.CenterY, CenterY);
  ANode.SetAttr(TdxSVGSchema.RadiusX, RadiusX);
  ANode.SetAttr(TdxSVGSchema.RadiusY, RadiusY);
end;

{ TdxSVGElementLine }

procedure TdxSVGElementLine.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Line(GetX(X1), GetY(Y1), GetX(X2), GetY(Y2));
end;

function TdxSVGElementLine.GetBounds: TdxRectF;
begin
  Result := dxRectF(GetX(X1), GetY(Y1), GetX(X2), GetY(Y2));
end;

procedure TdxSVGElementLine.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.X1, AAttr) then
    X1 := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Y1, AAttr) then
    Y1 := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.X2, AAttr) then
    X2 := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Y2, AAttr) then
    Y2 := AAttr.ValueAsSvgValue;
end;

procedure TdxSVGElementLine.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.X1, X1);
  ANode.SetAttr(TdxSVGSchema.Y1, Y1);
  ANode.SetAttr(TdxSVGSchema.X2, X2);
  ANode.SetAttr(TdxSVGSchema.Y2, Y2);
end;

{ TdxSVGElementImage }

constructor TdxSVGElementImage.Create;
begin
  inherited Create;
  FImage := TdxSmartImage.Create;
end;

destructor TdxSVGElementImage.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TdxSVGElementImage.SetBounds(const R: TdxRectF);
begin
  X := TdxSVGValue.Create(R.Left, utPx);
  Y := TdxSVGValue.Create(R.Top, utPx);
  Width := TdxSVGValue.Create(R.Width, utPx);
  Height := TdxSVGValue.Create(R.Height, utPx);
end;

procedure TdxSVGElementImage.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Draw(Image, GetBounds);
end;

function TdxSVGElementImage.GetBounds: TdxRectF;
begin
  Result := cxRectFBounds(GetX(X), GetY(Y), GetX(Width), GetY(Height));
end;

procedure TdxSVGElementImage.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;

  if ANode.Attributes.Find(TdxSVGSchema.XLinkHref, AAttr) or ANode.Attributes.Find(TdxSVGSchema.Href, AAttr) then
    TdxSVGParserImage.StringToImage(Image, AAttr.ValueAsString)
  else
    Image.Clear;

  if ANode.Attributes.Find(TdxSVGSchema.X, AAttr) then
    X := AAttr.ValueAsSvgValue
  else
    X := TdxSVGValue.Create(0, utPx);

  if ANode.Attributes.Find(TdxSVGSchema.Y, AAttr) then
    Y := AAttr.ValueAsSvgValue
  else
    Y := TdxSVGValue.Create(0, utPx);

  if ANode.Attributes.Find(TdxSVGSchema.Height, AAttr) then
    Height := AAttr.ValueAsSvgValue
  else
    Height := TdxSVGValue.Create(Image.Height, utPx);

  if ANode.Attributes.Find(TdxSVGSchema.Width, AAttr) then
    Width := AAttr.ValueAsSvgValue
  else
    Width := TdxSVGValue.Create(Image.Width, utPx);
end;

procedure TdxSVGElementImage.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.PreserveAspectRatio, 'none');
  ANode.SetAttr(TdxSVGSchema.X, X);
  ANode.SetAttr(TdxSVGSchema.Y, Y);
  ANode.SetAttr(TdxSVGSchema.Height, Height);
  ANode.SetAttr(TdxSVGSchema.Width, Width);
  ANode.SetAttr(TdxSVGSchema.XLinkHref, TdxSVGParserImage.ImageToString(Image));
end;

{ TdxSVGElementPath }

constructor TdxSVGElementPath.Create;
begin
  inherited Create;
  FPath := TdxSVGPath.Create;
end;

destructor TdxSVGElementPath.Destroy;
begin
  FreeAndNil(FPath);
  inherited Destroy;
end;

procedure TdxSVGElementPath.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  Path.FillMode := GetActualFillMode;
  ARenderer.Path(Path);
end;

function TdxSVGElementPath.GetBounds: TdxRectF;
var
  R: TdxRectF;
begin
  if Path.TryGetBoundsF(R) = Ok then
    Result := R
  else
    Result := inherited;
end;

procedure TdxSVGElementPath.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.PathData, AAttr) then
    Path.FromString(AAttr.ValueAsString);
end;

procedure TdxSVGElementPath.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.PathData, Path.ToString);
end;

procedure TdxSVGElementPath.SetPath(const Value: TdxSVGPath);
begin
  FPath.Assign(Value);
end;

{ TdxSVGElementPolygon }

constructor TdxSVGElementPolygon.Create;
begin
  inherited Create;
  FPoints := TdxSVGPoints.Create;
end;

destructor TdxSVGElementPolygon.Destroy;
begin
  FreeAndNil(FPoints);
  inherited Destroy;
end;

procedure TdxSVGElementPolygon.DrawCore(ARenderer: TdxSVGCustomRenderer);
begin
  ARenderer.Polygon(Points.ToArray);
end;

function TdxSVGElementPolygon.GetBounds: TdxRectF;
begin
  if Points.Count > 0 then
    Result := Points.BoudingRect
  else
    Result := inherited;
end;

procedure TdxSVGElementPolygon.Load(const ANode: TdxXMLNode);
var
  AAttrs: TdxXMLNodeAttribute;
begin
  inherited;

  if ANode.Attributes.Find(TdxSVGSchema.Points, AAttrs) then
    TdxSVGParserNumbers.AsPoints(AAttrs.ValueAsString, Points);
end;

procedure TdxSVGElementPolygon.Save(const ANode: TdxXMLNode);
var
  AStringBuilder: TStringBuilder;
  I: Integer;
begin
  inherited;

  if Points.Count > 0 then
  begin
    AStringBuilder := TdxStringBuilderManager.Get(256);
    try
      for I := 0 to Points.Count - 1 do
      begin
        if I > 0 then
          AStringBuilder.Append(' ');
        AStringBuilder.Append(dxSVGFloatToString(Points[I].X));
        AStringBuilder.Append(',');
        AStringBuilder.Append(dxSVGFloatToString(Points[I].Y));
      end;
      ANode.SetAttr(TdxSVGSchema.Points, AStringBuilder.ToString);
    finally
      TdxStringBuilderManager.Release(AStringBuilder);
    end;
  end;
end;

procedure TdxSVGElementPolygon.SetPoints(const Value: TdxSVGPoints);
begin
  FPoints.Assign(Value);
end;

{ TdxSVGElementPolyline }

procedure TdxSVGElementPolyline.DrawCore(ARenderer: TdxSVGCustomRenderer);
var
  APoints: TArray<TdxPointF>;

  procedure CorrectLine(APoint1Index, APoint2Index: Integer);
  begin
    if APoints[APoint1Index].X = APoints[APoint2Index].X then
    begin
      APoints[APoint1Index].X := APoints[APoint1Index].X - 1;
      APoints[APoint2Index].X := APoints[APoint2Index].X - 1;
      if APoints[APoint1Index].Y <> APoints[APoint2Index].Y then
        if APoints[APoint1Index].Y < APoints[APoint2Index].Y then
          APoints[APoint2Index].Y := APoints[APoint2Index].Y - 1
        else
          APoints[APoint1Index].Y := APoints[APoint1Index].Y - 1;
    end
    else
      if APoints[APoint1Index].Y = APoints[APoint2Index].Y then
      begin
        APoints[APoint1Index].Y := APoints[APoint1Index].Y - 1;
        APoints[APoint2Index].Y := APoints[APoint2Index].Y - 1;
        if APoints[APoint1Index].X <> APoints[APoint2Index].X then
          if APoints[APoint1Index].X < APoints[APoint2Index].X then
            APoints[APoint2Index].X := APoints[APoint2Index].X - 1
          else
            APoints[APoint1Index].X := APoints[APoint1Index].X - 1;
      end;
  end;

begin
  APoints := Points.ToArray;
  if ARenderer.UseDrawCorrection and (Points.Count = 2) then
    CorrectLine(0, 1);
  if not ARenderer.Brush.IsEmpty then
    ARenderer.Polygon(APoints, False);
  ARenderer.Polyline(APoints);
end;

{ TdxSVGElementRectangle }

procedure TdxSVGElementRectangle.DrawCore(ARenderer: TdxSVGCustomRenderer);
var
  ABounds: TdxRectF;
begin
  ABounds := GetBounds;
  if ARenderer.UseDrawCorrection then
    if (((Fill.IsDefault or Fill.IsEmpty) and (not Stroke.IsEmpty or not Stroke.IsDefault)) or
        (not Fill.IsDefault and not Stroke.IsDefault)) and
      (ABounds.Width > 1) and (ABounds.Height > 1) then
      ABounds.Inflate(0, 0, -1, -1);
  if CornerRadiusX.IsEmpty and CornerRadiusY.IsEmpty then
    ARenderer.Rectangle(ABounds)
  else
    ARenderer.RoundRect(ABounds, GetX(CornerRadiusX), GetY(CornerRadiusY));
end;

function TdxSVGElementRectangle.GetBounds: TdxRectF;
begin
  Result := cxRectFBounds(GetX(X), GetY(Y), GetX(Width), GetY(Height));
end;

procedure TdxSVGElementRectangle.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.X, AAttr) then
    X := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Y, AAttr) then
    Y := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Height, AAttr) then
    Height := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Width, AAttr) then
    Width := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.RadiusX, AAttr) then
  begin
    CornerRadiusX := AAttr.ValueAsSvgValue;
    FCornerRadiusXAssigned := True;
  end;
  if ANode.Attributes.Find(TdxSVGSchema.RadiusY, AAttr) then
  begin
    CornerRadiusY := AAttr.ValueAsSvgValue;
    FCornerRadiusYAssigned := True;
  end;
  if FCornerRadiusXAssigned and not FCornerRadiusYAssigned then
    CornerRadiusY := CornerRadiusX;
end;

procedure TdxSVGElementRectangle.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.X, X);
  ANode.SetAttr(TdxSVGSchema.Y, Y);
  ANode.SetAttr(TdxSVGSchema.Height, Height);
  ANode.SetAttr(TdxSVGSchema.Width, Width);
  if FCornerRadiusXAssigned then
    ANode.SetAttr(TdxSVGSchema.RadiusX, CornerRadiusX);
  if FCornerRadiusYAssigned then
    ANode.SetAttr(TdxSVGSchema.RadiusY, CornerRadiusY);
end;

procedure TdxSVGElementRectangle.SetBounds(const R: TdxRectF; AUnitsType: TdxSVGUnitsType);
begin
  X := TdxSVGValue.Create(R.Left, utPx);
  Y := TdxSVGValue.Create(R.Top, utPx);
  Width := TdxSVGValue.Create(R.Width, utPx);
  Height := TdxSVGValue.Create(R.Height, utPx);
end;

procedure TdxSVGElementRectangle.SetBounds(const R: TRect; AUnitsType: TdxSVGUnitsType);
begin
  X := TdxSVGValue.Create(R.Left, utPx);
  Y := TdxSVGValue.Create(R.Top, utPx);
  Width := TdxSVGValue.Create(R.Width, utPx);
  Height := TdxSVGValue.Create(R.Height, utPx);
end;

{ TdxSVGElementText }

constructor TdxSVGElementText.Create;
begin
  inherited Create;
  FX := TdxSVGValues.Create;
  FX.Add(TdxSVGValue.Create(0, utPx));
  FY := TdxSVGValues.Create;
  FY.Add(TdxSVGValue.Create(0, utPx));
end;

destructor TdxSVGElementText.Destroy;
begin
  FX.Free;
  FY.Free;
  ResetCachedValues;
  inherited Destroy;
end;

function TdxSVGElementText.CalculateTextPadding(AFont: TdxGPFont): Single;
begin
  Result := Max(dxGpMeasureString(AFont, '|').Width - dxGpMeasureString(AFont, '||').Width / 2, 0);
end;

function TdxSVGElementText.CalculateVertOffset(AFont: TdxGPFont): Single;
begin
  Result := AFont.Size * AFont.FontFamily.GetCellAscent(AFont.Style) / AFont.FontFamily.GetEmHeight(AFont.Style);
end;

procedure TdxSVGElementText.DrawCore(ARenderer: TdxSVGCustomRenderer);
var
  AFont: TdxGPFont;
  APoints: TdxPointsF;
  ADX, ADY, AVertOffset, ATextPadding: Single;
  ATextWidth, APrevTextWidth: Single;
  I, ALastXIndex, ALastYIndex, ALastIndex, ATextLength: Integer;
  ATextParts: array of string;
begin
  if TextAssigned and TryCreateFont(AFont) then
  try
    ADX := GetX(dX);
    ADY := GetY(dY);
    AVertOffset := CalculateVertOffset(AFont);
    ATextPadding := CalculateTextPadding(AFont);
    ATextLength := Length(Text);
    ATextWidth := 0;
    APrevTextWidth := 0;
    ALastXIndex := X.Count - 1;
    ALastYIndex := Y.Count - 1;
    ALastIndex := Max(ALastXIndex, ALastYIndex);
    SetLength(APoints, ALastIndex + 1);
    SetLength(ATextParts, ALastIndex + 1);
    for I := 0 to ALastIndex do
    begin
      if I >= ATextLength then
        Break;
      ATextParts[I] := Copy(Text, I + 1, IfThen(I = ALastIndex, ATextLength - I, 1));
      ATextWidth := dxGpMeasureString(AFont, ATextParts[I]).Width;
      if I <= ALastXIndex then
        APoints[I].X := GetX(X[I]) - ATextPadding
      else
        APoints[I].X := APoints[I - 1].X + APrevTextWidth - ATextPadding * 2;
      APrevTextWidth := ATextWidth;
      if I <= ALastYIndex then
        APoints[I].Y := GetY(Y[I]) - AVertOffset
      else
        APoints[I].Y := APoints[I - 1].Y
    end;
    if (ALastIndex >= 0) and (TextAnchor in [taMiddle, taEnd]) then
      ATextWidth := (APoints[Length(APoints) - 1].X + ATextWidth - ATextPadding) - APoints[0].X;
    for I := 0 to ALastIndex do
    begin
      case TextAnchor of
        taMiddle:
          APoints[I].X := APoints[I].X - ATextWidth / 2 + ATextPadding / 2;
        taEnd:
          APoints[I].X := APoints[I].X - ATextWidth + ATextPadding;
      end;
      ARenderer.TextOut(APoints[I].X + ADX, APoints[I].Y + ADY, ATextParts[I], AFont);
    end;
  finally
    AFont.Free;
  end;
end;

procedure TdxSVGElementText.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
  ASVGValues: TdxSVGValues;
begin
  ResetCachedValues;

  inherited Load(ANode);

  if ANode.Text <> '' then
    Text := ANode.TextAsString;
  if ANode.Attributes.Find(TdxSVGSchema.X, AAttr) then
  begin
    ASVGValues := AAttr.ValueAsSvgValues;
    if ASVGValues.Count > 0 then
      X := ASVGValues;
    ASVGValues.Free;
  end;
  if ANode.Attributes.Find(TdxSVGSchema.Y, AAttr) then
  begin
    ASVGValues := AAttr.ValueAsSvgValues;
    if ASVGValues.Count > 0 then
      Y := ASVGValues;
    ASVGValues.Free;
  end;
  if ANode.Attributes.Find(TdxSVGSchema.DeltaX, AAttr) then
    DX := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.DeltaY, AAttr) then
    DY := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Font, AAttr) then
    SetFontStyleString(AAttr.ValueAsString);
  if ANode.Attributes.Find(TdxSVGSchema.FontFamily, AAttr) then
    FontName := TdxSVGFontFamilyString.Decode(AAttr.ValueAsString);
  if ANode.Attributes.Find(TdxSVGSchema.FontSize, AAttr) then
    FontSize := AAttr.ValueAsSvgValue.ToPixels(0.0);
  FontStyles := FontStyles + TdxSVGFontStyleString.GetFontStyles(ANode.Attributes.GetValueAsString(TdxSVGSchema.FontStyle));
  FontStyles := FontStyles + TdxSVGFontStyleString.GetFontStyles(ANode.Attributes.GetValueAsString(TdxSVGSchema.FontWeight));
  FontStyles := FontStyles + TdxSVGFontStyleString.GetFontStyles(ANode.Attributes.GetValueAsString(TdxSVGSchema.TextDecoration));
  if ANode.Attributes.Find(TdxSVGSchema.TextAnchor, AAttr) then
    TextAnchor := AAttr.ValueAsTextAnchor;
end;

procedure TdxSVGElementText.Save(const ANode: TdxXMLNode);
var
  ABuffer: TStringBuilder;
begin
  inherited;
  ANode.TextAsString := Text;
  ANode.SetAttr(TdxSVGSchema.X, X);
  ANode.SetAttr(TdxSVGSchema.Y, Y);
  ANode.SetAttr(TdxSVGSchema.DeltaX, DX);
  ANode.SetAttr(TdxSVGSchema.DeltaY, DY);
  ANode.SetAttr(TdxSVGSchema.TextAnchor, TextAnchor);

  ABuffer := TdxStringBuilderManager.Get(64);
  try
    // font
    ABuffer.Append(TdxSVGSchema.Font);
    ABuffer.Append(TdxSVGInlineStyles.KeySeparator);
    ABuffer.Append(TdxSVGFontStyleString.Build(ActualFontName, ActualFontSize, ActualFontStyles));
    ABuffer.Append(TdxSVGInlineStyles.PairSeparator);

    // font-style
    if (fsUnderline in ActualFontStyles) or (fsStrikeOut in ActualFontStyles) then
    begin
      ABuffer.Append(' ');
      ABuffer.Append(TdxSVGSchema.TextDecoration).Append(TdxSVGInlineStyles.KeySeparator);
      if fsUnderline in ActualFontStyles then
        ABuffer.Append(TdxSVGFontStyleString.NameMap[fsUnderline]).Append(' ');
      if fsStrikeOut in ActualFontStyles then
        ABuffer.Append(TdxSVGFontStyleString.NameMap[fsStrikeOut]);
      ABuffer.Append(TdxSVGInlineStyles.PairSeparator);
    end;

    ANode.SetAttr(TdxSVGSchema.Style, ABuffer.ToString);
  finally
    TdxStringBuilderManager.Release(ABuffer);
  end;
end;

procedure TdxSVGElementText.ResetCachedValues;
begin
  FFontName := '';
  FFontSize := 0;
  FFontStylesAssigned := False;
  FreeAndNil(FCachedFontFamily);
end;

function TdxSVGElementText.GetDefaultFontName: string;
begin
  Result := string(DefFontData.Name);
end;

function TdxSVGElementText.GetDefaultFontSize: Single;
begin
  Result := 8;
end;

function TdxSVGElementText.GetDefaultFontStyles: TFontStyles;
begin
  Result := [];
end;

function TdxSVGElementText.TryCreateFont(out AFont: TdxGpFont): Boolean;
var
  AFontIndex: Integer;
  AFontNames: TStringDynArray;
begin
  Result := False;

  if FCachedFontFamily = nil then
  begin
    AFontNames := SplitString(TdxFontIconsResolver.ResolveFontName(ActualFontName), TdxSVGFontFamilyString.Separator);
    for AFontIndex := Low(AFontNames) to High(AFontNames) do
    begin
      if TryCreateFontFamily(AFontNames[AFontIndex], FCachedFontFamily) then
        Break;
    end;
    if (FCachedFontFamily = nil) and ContainsText(ActualFontName, 'sans-serif') then
      FCachedFontFamily := TdxGPFontFamily.GenericSansSerif.Clone;
    if FCachedFontFamily = nil then
      FCachedFontFamily := TdxGPFontFamily.GenericSerif.Clone;
  end;

  if FCachedFontFamily <> nil then
  try
    AFont := TdxGPFont.Create(FCachedFontFamily, ActualFontSize,
      TdxGPFontStyle(dxFontStylesToGpFontStyles(ActualFontStyles)), guPixel);
    Result := True;
  except
    Result := False;
  end;
end;

function TdxSVGElementText.TryCreateFontFamily(AName: string; out AFamily: TdxGPFontFamily): Boolean;
begin
  Result := False;
  while AName <> '' do
  begin
    AFamily := TdxGPFontFamily.Create(AName);
    if AFamily.Handle <> nil then
      Exit(True);
    FreeAndNil(AFamily);
    AName := Copy(AName, 1, LastDelimiter('-', AName) - 1);
  end;
end;

function TdxSVGElementText.GetActualFontName: string;
begin
  if FFontName <> '' then
    Result := FFontName
  else
    Result := GetDefaultFontName
end;

function TdxSVGElementText.GetActualFontSize: Single;
begin
  if FFontSize > 0 then
    Result := FFontSize
  else
    Result := GetDefaultFontSize;
end;

function TdxSVGElementText.GetActualFontStyles: TFontStyles;
begin
  if FFontStylesAssigned then
    Result := FFontStyles
  else
    Result := GetDefaultFontStyles;
end;

function TdxSVGElementText.GetTextAssigned: Boolean;
begin
  Result := Text <> '';
end;

procedure TdxSVGElementText.SetFontStyles(const AValue: TFontStyles);
begin
  FFontStyles := AValue;
  FFontStylesAssigned := True;
end;

procedure TdxSVGElementText.SetFontStyleString(const AValue: string);
var
  AName: string;
  ASize: Single;
  AStyles: TFontStyles;
begin
  if TdxSVGFontStyleString.Parse(AValue, AName, ASize, AStyles) then
  begin
    FontName := AName;
    FontSize := ASize;
    FontStyles := AStyles;
  end;
end;

procedure TdxSVGElementText.SetX(const AValues: TdxSVGValues);
begin
  FX.Assign(AValues);
end;

procedure TdxSVGElementText.SetY(const AValues: TdxSVGValues);
begin
  FY.Assign(AValues);
end;

{ TdxSVGElementTSpan }

constructor TdxSVGElementTSpan.Create(AParent: TdxSVGElement);
begin
  inherited Create(AParent);

  if AParent is TdxSVGElementText then
  begin
    AssignCore(AParent);
    Transform.Reset;
  end;
end;

function TdxSVGElementTSpan.GetDefaultFontName: string;
begin
  if Parent is TdxSVGElementText then
    Result := TdxSVGElementText(Parent).ActualFontName
  else
    Result := inherited;
end;

function TdxSVGElementTSpan.GetDefaultFontSize: Single;
begin
  if Parent is TdxSVGElementText then
    Result := TdxSVGElementText(Parent).ActualFontSize
  else
    Result := inherited;
end;

function TdxSVGElementTSpan.GetDefaultFontStyles: TFontStyles;
begin
  if Parent is TdxSVGElementText then
    Result := TdxSVGElementText(Parent).ActualFontStyles
  else
    Result := inherited;
end;

{ TdxSVGElementRoot }

constructor TdxSVGElementRoot.Create;
begin
  inherited Create;
  FViewBox := TdxSVGRect.Create;
  FBackground := TdxSVGRect.Create;
end;

destructor TdxSVGElementRoot.Destroy;
begin
  FreeAndNil(FBackground);
  FreeAndNil(FViewBox);
  inherited Destroy;
end;

procedure TdxSVGElementRoot.Draw(ARender: TdxSVGRenderer; const R: TdxRectF);
var
  AViewBox: TdxRectF;
begin
  ARender.SaveWorldTransform;
  try
    AViewBox := ActualViewBox;
    ARender.FCanvas.TranslateWorldTransform(R.Left, R.Top);
    ARender.FCanvas.ScaleWorldTransform(R.Width / AViewBox.Width, R.Height / AViewBox.Height);
    ARender.FCanvas.TranslateWorldTransform(-AViewBox.Left, -AViewBox.Top);
    inherited Draw(ARender);
  finally
    ARender.RestoreWorldTransform;
  end;
end;

function TdxSVGElementRoot.GetActualViewBox: TdxRectF;
begin
  Result := ViewBox.Value;
  if IsZero(Result.Height) then
    Result.Height := Height.ToPixels;
  if IsZero(Result.Width) then
    Result.Width := Width.ToPixels;
end;

function TdxSVGElementRoot.GetBounds: TdxRectF;
begin
  Result := cxRectSetSizeF(ViewBox.Value, Size);
end;

function TdxSVGElementRoot.GetRoot: TdxSVGElementRoot;
begin
  Result := Self;
end;

function TdxSVGElementRoot.GetSize: TdxSizeF;
begin
  Result := ViewBox.Value.Size;
  if not Width.IsEmpty and (Width.UnitsType <> utPercents) then
    Result.Width := Width.ToPixels;
  if not Height.IsEmpty and (Height.UnitsType <> utPercents) then
    Result.Height := Height.ToPixels;
end;

procedure TdxSVGElementRoot.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.X, AAttr) then
    X := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Y, AAttr) then
    Y := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Height, AAttr) then
    Height := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Width, AAttr) then
    Width := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.EnableBackground, AAttr) then
    Background.Value := AAttr.ValueAsRectF;
  if ANode.Attributes.Find(TdxSVGSchema.ViewBox, AAttr) then
    ViewBox.Value := AAttr.ValueAsRectF;
end;

procedure TdxSVGElementRoot.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.X, X);
  ANode.SetAttr(TdxSVGSchema.Y, Y);
  ANode.SetAttr(TdxSVGSchema.Height, Height);
  ANode.SetAttr(TdxSVGSchema.Width, Width);
  ANode.SetAttr(TdxSVGSchema.EnableBackground, Background.Value, True);
  ANode.SetAttr(TdxSVGSchema.ViewBox, ViewBox.Value);
end;

procedure TdxSVGElementRoot.SetBackground(const Value: TdxSVGRect);
begin
  Background.Value := Value.Value;
end;

procedure TdxSVGElementRoot.SetViewBox(const Value: TdxSVGRect);
begin
  ViewBox.Value := Value.Value;
end;

{ TdxSVGElementUse }

procedure TdxSVGElementUse.DrawCore(ARenderer: TdxSVGCustomRenderer);

  type
    TdxUsedElementValues = record
      FillMode: TdxSVGFillMode;
      ClipRule: TdxSVGFillMode;
      Parent: TdxSVGElement;
    end;

  function UpdateLinkedProperties(AElement: TdxSVGElement): TdxUsedElementValues;
  begin
    Result.Parent := AElement.Parent;
    Result.ClipRule := AElement.ClipRule;
    Result.FillMode := AElement.FillMode;

    AElement.Parent := Self;
    AElement.ClipRule := fmInherit;
    AElement.FillMode := fmInherit;
  end;

  procedure ResetLinkedElementProperies(AElement: TdxSVGElement; AElementValues: TdxUsedElementValues);
  begin
    AElement.Parent := AElementValues.Parent;
    AElement.ClipRule := AElementValues.ClipRule;
    AElement.FillMode := AElementValues.FillMode;
  end;

var
  AElement: TdxSVGElement;
  AElementValues: TdxUsedElementValues;
begin
  if Root.FindByID(Reference, AElement) then
  begin
    ARenderer.SaveWorldTransform;
    try
      ARenderer.ModifyWorldTransform(TXForm.CreateTranslateMatrix(GetX(X), GetY(Y)));

      AElementValues := UpdateLinkedProperties(AElement);
      AElement.Draw(ARenderer);
      ResetLinkedElementProperies(AElement, AElementValues);
    finally
      ARenderer.RestoreWorldTransform;
    end;
  end;
end;

function TdxSVGElementUse.IsInheritanceSupported: Boolean;
begin
  Result := False;
end;

procedure TdxSVGElementUse.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.X, AAttr) then
    X := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Y, AAttr) then
    Y := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.XLinkHref, AAttr) or ANode.Attributes.Find(TdxSVGSchema.Href, AAttr) then
    Reference := TdxSVGAttributeConverter.StringToReference(AAttr.ValueAsString);
end;

procedure TdxSVGElementUse.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.X, X);
  ANode.SetAttr(TdxSVGSchema.Y, Y);
  ANode.SetAttr(TdxSVGSchema.Href, TdxSVGAttributeConverter.ReferenceToString(Reference, True));
end;

procedure TdxSVGElementUse.UpdateReference(const AOldReference, ANewReference: string);
begin
  if dxSameText(Reference, AOldReference) then
    Reference := ANewReference;
  inherited;
end;

{ TdxSVGElementNeverRendered }

procedure TdxSVGElementNeverRendered.Draw(ARenderer: TdxSVGCustomRenderer);
begin
  // do nothing
end;

{ TdxSVGElementClipPath }

procedure TdxSVGElementClipPath.ApplyTo(ARenderer: TdxSVGCustomRenderer; AElement: TdxSVGElement);
var
  ABuilder: TdxSVGRendererClipPath;
begin
  ABuilder := TdxSVGRendererClipPath.Create(GetActualClipRule);
  try
    DrawCoreAndChildren(ABuilder);
    ARenderer.SetClipRegion(ABuilder.ClipPath);
  finally
    ABuilder.Free;
  end;
end;

{ TdxSVGElementCustomPattern }

constructor TdxSVGElementCustomPattern.Create;
begin
  inherited Create;
  FPatternTransform := TdxMatrix.Create;
end;

destructor TdxSVGElementCustomPattern.Destroy;
begin
  FreeAndNil(FPatternTransform);
  inherited Destroy;
end;

function TdxSVGElementCustomPattern.GetHostBounds(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement): TdxRectF;
var
  AMatrix: TdxGPMatrix;
begin
  if PatternUnitsType = cuObjectBoundingBox then
    Result := ACaller.GetBounds
  else
  begin
    AMatrix := ARenderer.WorldTransform.Clone;
    try
      AMatrix.Invert;
      Result := AMatrix.TransformRect(Root.GetBounds);
    finally
      AMatrix.Free;
    end;
  end;
end;

procedure TdxSVGElementCustomPattern.InitializeBrush(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement);
begin
  InitializeBrushCore(ARenderer, ACaller, ARenderer.Brush);
end;

procedure TdxSVGElementCustomPattern.InitializePen(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement);
begin
  InitializeBrushCore(ARenderer, ACaller, ARenderer.Pen.Brush);
end;

{ TdxSVGElementGradientStop }

procedure TdxSVGElementGradientStop.AfterConstruction;
begin
  inherited;
  FColorOpacity := 1.0;
end;

procedure TdxSVGElementGradientStop.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.StopColor, AAttr) then
    Color := AAttr.ValueAsColor;
  if ANode.Attributes.Find(TdxSVGSchema.StopOpacity, AAttr) then
    ColorOpacity := AAttr.ValueAsSvgValue.ToPixels(0.0);
  if ANode.Attributes.Find(TdxSVGSchema.Offset, AAttr) then
    Offset := AAttr.ValueAsSvgValue;
end;

procedure TdxSVGElementGradientStop.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.StopColor, Color);
  ANode.SetAttr(TdxSVGSchema.StopOpacity, ColorOpacity, 1.0);
  ANode.SetAttr(TdxSVGSchema.Offset, Offset);
end;

{ TdxSVGElementCustomGradient }

constructor TdxSVGElementCustomGradient.Create;
begin
  inherited Create;
  PatternUnitsType := cuObjectBoundingBox;
end;

procedure TdxSVGElementCustomGradient.AddStop(AOffsetInPercents: Single; AColor: TdxAlphaColor; AOpacity: Single = 1.0);
var
  AGradientStop: TdxSVGElementGradientStop;
begin
  AGradientStop := TdxSVGElementGradientStop.Create(Self);
  AGradientStop.Offset := TdxSVGValue.Create(AOffsetInPercents, utPercents);
  AGradientStop.ColorOpacity := AOpacity * dxGetAlpha(AColor) / MaxByte;
  AGradientStop.Color := AColor;
end;

procedure TdxSVGElementCustomGradient.InitializeBrushCore(
  ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush);
var
  AHostBounds: TdxRectF;
  AFinishOffset: Single;
  APatternRect: TdxRectF;
  APatternRectEmpty: Boolean;
  AStartOffset: Single;
begin
  ABrush.FreeHandle;

  AHostBounds := GetHostBounds(ARenderer, ACaller);
  APatternRect := CalculatePatternRect(AHostBounds);
  APatternRect := PatternTransform.Transform(APatternRect);
  APatternRectEmpty := IsZeroVector(APatternRect);
  if not APatternRectEmpty then
  begin
    ABrush.GradientBox := CalculateGradientBox(AHostBounds, APatternRect);
    APatternRectEmpty := IsZeroVector(ABrush.GradientBox);
  end;

  if APatternRectEmpty then
  begin
    PopulateGradientPoints(ARenderer, ABrush.GradientPoints, 0, 1);
    if ABrush.GradientPoints.Count > 0 then
      ABrush.Color := ABrush.GradientPoints.Colors[ABrush.GradientPoints.Count - 1]
    else
      ABrush.Color := TdxAlphaColors.Empty;

    ABrush.Style := gpbsSolid;
  end
  else
  begin
    CalculateGradientOffsets(AHostBounds, APatternRect, ABrush.GradientBox, AStartOffset, AFinishOffset);
    PopulateGradientPoints(ARenderer, ABrush.GradientPoints, AStartOffset, AFinishOffset);
    ABrush.Style := gpbsGradient;
  end;
end;

procedure TdxSVGElementCustomGradient.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.GradientTransform, AAttr) then
    AAttr.GetValueAsMatrix(PatternTransform);
  if ANode.Attributes.Find(TdxSVGSchema.GradientUnits, AAttr) then
    PatternUnitsType := AAttr.ValueAsContentUnits;
end;

procedure TdxSVGElementCustomGradient.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.GradientTransform, PatternTransform);
  ANode.SetAttr(TdxSVGSchema.GradientUnits, PatternUnitsType);
end;

procedure TdxSVGElementCustomGradient.PopulateGradientPoints(
  ARenderer: TdxSVGCustomRenderer; APoints: TdxGPBrushGradientPoints; AStartOffset, AFinishOffset: Single);

  function GetActualColor(AElement: TdxSVGElementGradientStop): TdxAlphaColor;
  begin
    Result := ARenderer.MakeColor(AElement.Color, AElement.ColorOpacity);
  end;

  function GetActualOffset(AElement: TdxSVGElementGradientStop; AInvertOrder: Boolean): Single;
  begin
    Result := AStartOffset + AElement.Offset.ToPixels(1.0) * (AFinishOffset - AStartOffset);
    if AInvertOrder then
      Result := 1 - Result;
  end;

  function GetActualStop(AIndex: Integer; AInvertOrder: Boolean): TdxSVGElementGradientStop;
  begin
    if AInvertOrder then
      AIndex := Count - 1 - AIndex;
    Result := Elements[AIndex];
  end;

var
  AInvertOrder: Boolean;
  AStop: TdxSVGElementGradientStop;
  I: Integer;
begin
  APoints.Clear;
  if Count > 0 then
  begin
    AStartOffset := EnsureRange(AStartOffset, 0, 1);
    AFinishOffset := EnsureRange(AFinishOffset, 0, 1);
    AInvertOrder := AStartOffset > AFinishOffset;
    if AInvertOrder then
      ExchangeSingle(AStartOffset, AFinishOffset);

    AStop := GetActualStop(0, AInvertOrder);
    if GetActualOffset(AStop, AInvertOrder) > 0 then
      APoints.Add(0, GetActualColor(AStop));

    for I := 0 to Count - 1 do
    begin
      AStop := GetActualStop(I, AInvertOrder);
      APoints.Add(GetActualOffset(AStop, AInvertOrder), GetActualColor(AStop));
    end;

    AStop := GetActualStop(Count - 1, AInvertOrder);
    if GetActualOffset(AStop, AInvertOrder) < 1 then
      APoints.Add(1, GetActualColor(AStop));
  end;
end;

function TdxSVGElementCustomGradient.GetElement(Index: Integer): TdxSVGElementGradientStop;
begin
  Result := inherited Elements[Index] as TdxSVGElementGradientStop;
end;

{ TdxSVGElementLinearGradient }

procedure TdxSVGElementLinearGradient.AfterConstruction;
begin
  inherited;
  FX2 := TdxSVGValue.Create(1, utPx);
end;

procedure TdxSVGElementLinearGradient.SetBounds(const ADirection: TdxGpLinearGradientMode);
begin
  case ADirection of
    LinearGradientModeHorizontal:
      SetBounds(0, 0, 100, 0, utPercents);
    LinearGradientModeVertical:
      SetBounds(0, 0, 0, 100, utPercents);
    LinearGradientModeForwardDiagonal:
      SetBounds(0, 0, 100, 100, utPercents);
    LinearGradientModeBackwardDiagonal:
      SetBounds(100, 0, 0, 100, utPercents);
  end;
end;

procedure TdxSVGElementLinearGradient.SetBounds(const X1, Y1, X2, Y2: Single; AUnitsType: TdxSVGUnitsType);
begin
  Self.X1 := TdxSVGValue.Create(X1, AUnitsType);
  Self.X2 := TdxSVGValue.Create(X2, AUnitsType);
  Self.Y1 := TdxSVGValue.Create(Y1, AUnitsType);
  Self.Y2 := TdxSVGValue.Create(Y2, AUnitsType);
end;

procedure TdxSVGElementLinearGradient.SetRotationAngle(const ARotationAngle: Single);
var
  AAnglePI, ASin, ACos: Single;
begin
  AAnglePI := DegToRad(ARotationAngle - 90.0);  
  SinCos(AAnglePI, ASin, ACos);
  X1 := TdxSVGValue.Create(50.0 + ASin * 50.0, utPercents);
  Y1 := TdxSVGValue.Create(50.0 + ACos * 50.0, utPercents);
  X2 := TdxSVGValue.Create(50.0 - ASin * 50.0, utPercents);
  Y2 := TdxSVGValue.Create(50.0 - ACos * 50.0, utPercents);
end;

procedure TdxSVGElementLinearGradient.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.X1, AAttr) then
    X1 := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Y1, AAttr) then
    Y1 := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.X2, AAttr) then
    X2 := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Y2, AAttr) then
    Y2 := AAttr.ValueAsSvgValue;
end;

procedure TdxSVGElementLinearGradient.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.X1, X1);
  ANode.SetAttr(TdxSVGSchema.Y1, Y1);
  ANode.SetAttr(TdxSVGSchema.X2, X2);
  ANode.SetAttr(TdxSVGSchema.Y2, Y2);
end;

function TdxSVGElementLinearGradient.CalculateGradientBox(const AHostBounds, APatternRect: TdxRectF): TdxRectF;

  procedure AdjustPoint(var X, Y: Single; const ACanvasRect: TdxRectF; ADeltaX, ADeltaY: Single);
  var
    ACount: Single;
  begin
    ACount := 0;
    if ADeltaX < 0 then
      ACount := Max(ACount, (ACanvasRect.Left - X) / ADeltaX);
    if ADeltaX > 0 then
      ACount := Max(ACount, (ACanvasRect.Right - X) / ADeltaX);
    if ADeltaY < 0 then
      ACount := Max(ACount, (ACanvasRect.Top - Y) / ADeltaY);
    if ADeltaY > 0 then
      ACount := Max(ACount, (ACanvasRect.Bottom - Y) / ADeltaY);
    X := X + ACount * ADeltaX;
    Y := Y + ACount * ADeltaY;
  end;

var
  ADeltaX: Single;
  ADeltaY: Single;
  ALength: Single;
begin
  ALength := TdxVectors.Length(APatternRect.Width, APatternRect.Height);
  if IsZero(ALength) then
    Exit(dxNullRectF);

  ADeltaX := APatternRect.Width / ALength;
  ADeltaY := APatternRect.Height / ALength;

  Result := APatternRect;
  AdjustPoint(Result.Left, Result.Top, AHostBounds, -ADeltaX, -ADeltaY);
  AdjustPoint(Result.Right, Result.Bottom, AHostBounds, ADeltaX, ADeltaY);
end;

procedure TdxSVGElementLinearGradient.CalculateGradientOffsets(
  const AHostBounds, APatternRect, AGradientLine: TdxRectF; out AStartOffset, AFinishOffset: Single);
var
  ALength: Single;
begin
  ALength := TdxVectors.Length(AGradientLine.Width, AGradientLine.Height);
  AStartOffset := TdxVectors.Length(APatternRect.Left - AGradientLine.Left, APatternRect.Top - AGradientLine.Top) / ALength;
  AFinishOffset := TdxVectors.Length(APatternRect.Right - AGradientLine.Left, APatternRect.Bottom - AGradientLine.Top) / ALength;
end;

function TdxSVGElementLinearGradient.CalculatePatternRect(const AHostBounds: TdxRectF): TdxRectF;
begin
  if PatternUnitsType = cuObjectBoundingBox then
  begin
    Result.Top := AHostBounds.Top + Y1.ToPixels(1.0) * AHostBounds.Height;
    Result.Left := AHostBounds.Left + X1.ToPixels(1.0) * AHostBounds.Width;
    Result.Right := AHostBounds.Left + X2.ToPixels(1.0) * AHostBounds.Width;
    Result.Bottom := AHostBounds.Top + Y2.ToPixels(1.0) * AHostBounds.Height;
  end
  else
    Result := cxRectF(GetX(X1), GetY(Y1), GetX(X2), GetY(Y2));
end;

procedure TdxSVGElementLinearGradient.InitializeBrushCore(
  ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush);
begin
  ABrush.GradientMode := sbgmLinear;
  inherited;
end;

{ TdxSVGElementRadialGradient }

procedure TdxSVGElementRadialGradient.AfterConstruction;
begin
  inherited;
  Radius := TdxSVGValue.Create(50, utPercents);
  CenterX := TdxSVGValue.Create(50, utPercents);
  CenterY := TdxSVGValue.Create(50, utPercents);
end;

function TdxSVGElementRadialGradient.CalculateGradientBox(const AHostBounds, APatternRect: TdxRectF): TdxRectF;
var
  ACenter: TdxPointF;
  ARadiusX: Single;
  ARadiusY: Single;
begin
  ACenter := APatternRect.CenterPoint;
  ARadiusX := APatternRect.Width / 2;
  ARadiusY := APatternRect.Height / 2;

  if IsZero(ARadiusX) or IsZero(ARadiusY) then
    Exit(dxNullRectF);

  while not dxEllipseRectIn(ACenter, ARadiusX, ARadiusY, AHostBounds) do
  begin
    ARadiusX := ARadiusX * 1.25;
    ARadiusY := ARadiusY * 1.25;
  end;

  Result := dxEllipseF(ACenter, ARadiusX, ARadiusY);
end;

function TdxSVGElementRadialGradient.CalculateGradientFocalPoint(const AHostBounds: TdxRectF): TdxPointF;
begin
  if PatternUnitsType = cuObjectBoundingBox then
  begin
    Result.Y := AHostBounds.Top + FocalY.ToPixels(1.0) * AHostBounds.Height;
    Result.X := AHostBounds.Left + FocalX.ToPixels(1.0) * AHostBounds.Width;
  end
  else
  begin
    Result.X := GetX(FocalX);
    Result.Y := GetY(FocalY);
  end;
  Result := PatternTransform.Transform(Result);
end;

procedure TdxSVGElementRadialGradient.CalculateGradientOffsets(
  const AHostBounds, APatternRect, AGradientBox: TdxRectF; out AStartOffset, AFinishOffset: Single);
begin
  AStartOffset := APatternRect.Width / AGradientBox.Width;
  AFinishOffset := 2 * CalculateRadius(AHostBounds, FocalRadius) / AGradientBox.Width; 
  AFinishOffset := Min(AFinishOffset, AStartOffset);
end;

function TdxSVGElementRadialGradient.CalculatePatternRect(const AHostBounds: TdxRectF): TdxRectF;
var
  ACenter: TdxPointF;
begin
  if PatternUnitsType = cuObjectBoundingBox then
  begin
    ACenter.X := AHostBounds.Left + CenterX.ToPixels(1.0) * AHostBounds.Width;
    ACenter.Y := AHostBounds.Top + CenterY.ToPixels(1.0) * AHostBounds.Height;
  end
  else
  begin
    ACenter.X := GetX(CenterX);
    ACenter.Y := GetY(CenterY);
  end;
  Result := dxEllipseF(ACenter, CalculateRadius(AHostBounds, Radius));
end;

function TdxSVGElementRadialGradient.CalculateRadius(const AHostBounds: TdxRectF; const ARadius: TdxSVGValue): Single;
begin
  if PatternUnitsType = cuObjectBoundingBox then
    Result := ARadius.ToPixels(1.0) * Max(AHostBounds.Width, AHostBounds.Height)
  else
    Result := Max(GetX(ARadius), GetY(ARadius));
end;

procedure TdxSVGElementRadialGradient.InitializeBrushCore(
  ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush);
begin
  ABrush.GradientMode := sbgmRadial;
  ABrush.GradientFocalPoint := CalculateGradientFocalPoint(GetHostBounds(ARenderer, ACaller));
  inherited InitializeBrushCore(ARenderer, ACaller, ABrush);
end;

procedure TdxSVGElementRadialGradient.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.CenterX, AAttr) then
    CenterX := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.CenterY, AAttr) then
    CenterY := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Radius, AAttr) then
    Radius := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.FocalRadius, AAttr) then
    FocalRadius := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.FocalX, AAttr) then
    FocalX := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.FocalY, AAttr) then
    FocalY := AAttr.ValueAsSvgValue;
end;

procedure TdxSVGElementRadialGradient.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.CenterX, CenterX);
  ANode.SetAttr(TdxSVGSchema.CenterY, CenterY);
  ANode.SetAttr(TdxSVGSchema.Radius, Radius);
  if FocalX <> CenterX then
    ANode.SetAttr(TdxSVGSchema.FocalX, FocalX);
  if FocalY <> CenterY then
    ANode.SetAttr(TdxSVGSchema.FocalY, FocalY);
  if not FocalRadius.IsEmpty then
    ANode.SetAttr(TdxSVGSchema.FocalRadius, FocalRadius);
end;

procedure TdxSVGElementRadialGradient.SetCenterX(const Value: TdxSVGValue);
begin
  FCenterX := Value;
  FFocalX := Value;
end;

procedure TdxSVGElementRadialGradient.SetCenterY(const Value: TdxSVGValue);
begin
  FCenterY := Value;
  FFocalY := Value;
end;

{ TdxSVGElementPattern }

constructor TdxSVGElementPattern.Create;
begin
  inherited Create;
  FViewBox := TdxSVGRect.Create;
end;

destructor TdxSVGElementPattern.Destroy;
begin
  FreeAndNil(FViewBox);
  inherited Destroy;
end;

function TdxSVGElementPattern.GetHostBounds(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement): TdxRectF;
begin
  if PatternUnitsType = cuUserSpaceOnUse then
    Result := ACaller.GetBounds
  else
    Result := inherited GetHostBounds(ARenderer, ACaller);
end;

procedure TdxSVGElementPattern.InitializeBrushCore(ARenderer: TdxSVGCustomRenderer; ACaller: TdxSVGElement; ABrush: TdxSVGBrush);
var
  ABounds: TdxRectF;
  AHostBounds: TdxRectF;
  ATexture: TdxGPImage;
  ATextureCanvas: TdxGPCanvas;
  ATextureRenderer: TdxSVGCustomRenderer;
  ATextureScaleFactor: Single;
  AViewScaleFactor: Single;
begin
  if Count = 0 then
    Exit;

  if IsRasterPattern then
    ATextureScaleFactor := 1
  else
    ATextureScaleFactor := ARenderer.TransformPenWidth(1);

  AHostBounds := GetHostBounds(ARenderer, ACaller);
  ABounds.InitSize(X.ToPixels(AHostBounds.Width), Y.ToPixels(AHostBounds.Height), Width.ToPixels(AHostBounds.Width), Height.ToPixels(AHostBounds.Height));
  ABounds := cxRectScale(ABounds, ATextureScaleFactor);
  if ABounds.IsEmpty then Exit;

  ATexture := TdxGPImage.CreateSize(Ceil(ABounds.Width), Ceil(ABounds.Height));
  try
    ATextureCanvas := ATexture.CreateCanvas;
    try
      if ViewBox.IsEmpty then
        AViewScaleFactor := ATextureScaleFactor
      else
        AViewScaleFactor := Min(ATexture.Width / ViewBox.Width, ATexture.Height / ViewBox.Height);

      ATextureCanvas.ScaleWorldTransform(AViewScaleFactor, AViewScaleFactor);
      ATextureCanvas.TranslateWorldTransform(-ViewBox.Value.Left, -ViewBox.Value.Top);
      ATextureCanvas.PixelOffsetMode := PixelOffsetModeHalf;
      ATextureCanvas.SmoothingMode := smHighQuality;

      ATextureRenderer := TdxSVGRenderer.Create(ATextureCanvas, ARenderer.Palette);
      ATextureRenderer.ShapeRendering := ARenderer.ShapeRendering;
      try
        ATextureRenderer.ModifyOpacity(ARenderer.Opacity);
        DrawCoreAndChildren(ATextureRenderer);
      finally
        ATextureRenderer.Free;
      end;
    finally
      ATextureCanvas.Free;
    end;

    ABrush.Style := gpbsTexture;
    ABrush.Texture.Assign(ATexture);
    ABrush.TextureTransform.Reset;
    ABrush.TextureTransform.Scale(1 / ATextureScaleFactor);
    ABrush.TextureTransform.Multiply(PatternTransform.XForm);
    ABrush.TextureTransform.Translate(
      -IfThen(SameValue(ABounds.Left, AHostBounds.Left), 0, ABounds.Left + AHostBounds.Left),
      -IfThen(SameValue(ABounds.Top, AHostBounds.Top), 0, ABounds.Top + AHostBounds.Top));
  finally
    ATexture.Free;
  end;
end;

function TdxSVGElementPattern.IsRasterPattern: Boolean;
begin
  Result := (Count = 1) and (Elements[0] is TdxSVGElementImage);
end;

procedure TdxSVGElementPattern.Load(const ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  inherited;
  if ANode.Attributes.Find(TdxSVGSchema.X, AAttr) then
    X := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Y, AAttr) then
    Y := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Width, AAttr) then
    Width := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.Height, AAttr) then
    Height := AAttr.ValueAsSvgValue;
  if ANode.Attributes.Find(TdxSVGSchema.PatternTransform, AAttr) then
    AAttr.GetValueAsMatrix(PatternTransform);
  if ANode.Attributes.Find(TdxSVGSchema.PatternUnits, AAttr) then
    PatternUnitsType := AAttr.ValueAsContentUnits;
  if ANode.Attributes.Find(TdxSVGSchema.ViewBox, AAttr) then
    ViewBox.Value := AAttr.ValueAsRectF;
end;

procedure TdxSVGElementPattern.Save(const ANode: TdxXMLNode);
begin
  inherited;
  ANode.SetAttr(TdxSVGSchema.X, X);
  ANode.SetAttr(TdxSVGSchema.Y, Y);
  ANode.SetAttr(TdxSVGSchema.Width, Width);
  ANode.SetAttr(TdxSVGSchema.Height, Height);
  ANode.SetAttr(TdxSVGSchema.PatternTransform, PatternTransform);
  ANode.SetAttr(TdxSVGSchema.PatternUnits, PatternUnitsType);
  if not ViewBox.IsEmpty then
    ANode.SetAttr(TdxSVGSchema.ViewBox, ViewBox.Value);
end;

{ TdxSVGStyle }

constructor TdxSVGStyle.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

procedure TdxSVGStyle.Apply(AElement: TdxSVGElement);
begin
  AElement.Load(Self);
end;

{ TdxSVGStyles }

constructor TdxSVGStyles.Create;
begin
  inherited Create;
  FItems := TObjectDictionary<string, TdxSVGStyle>.Create([doOwnsValues]);
end;

destructor TdxSVGStyles.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

function TdxSVGStyles.Add(const AName: string): TdxSVGStyle;
begin
  if not FItems.TryGetValue(AName, Result) then
  begin
    Result := TdxSVGStyle.Create(AName);
    FItems.Add(AName, Result);
  end;
end;

function TdxSVGStyles.AddInline(const AReference: TObject): TdxSVGStyle;
begin
  Result := Add(Format(sInline, [Pointer(AReference)]));
end;

procedure TdxSVGStyles.Apply(AElement: TdxSVGElement);
var
  AStyle: TdxSVGStyle;
  AStyles: TStringDynArray;
  I: Integer;
begin
  AStyles := SplitString(AElement.StyleName, ' ');
  for I := 0 to Length(AStyles) - 1 do
  begin
    if TryGetStyle(AStyles[I], AStyle) then
      AStyle.Apply(AElement);
  end;
  if TryGetStyle(Format(sInline, [Pointer(AElement)]), AStyle) then
    AStyle.Apply(AElement);
  for I := 0 to AElement.Count - 1 do
    Apply(AElement[I]);
end;

function TdxSVGStyles.TryGetStyle(const AName: string; out AStyle: TdxSVGStyle): Boolean;
begin
  Result := (AName <> '') and FItems.TryGetValue(AName, AStyle);
end;

function TdxSVGStyles.GetItem(const Name: string): TdxSVGStyle;
begin
  Result := FItems.Items[Name]
end;

{ TdxSVGFiler }

class procedure TdxSVGFiler.Finalize;
begin
  FreeAndNil(FElementMap);
end;

class procedure TdxSVGFiler.Initialize;
begin
  FElementMap := TdxMap<TdxXMLString, TdxSVGElementClass>.Create;
  FElementMap.Add('circle', TdxSVGElementCircle);
  FElementMap.Add('clipPath', TdxSVGElementClipPath);
  FElementMap.Add('defs', TdxSVGElementDefinitions);
  FElementMap.Add('ellipse', TdxSVGElementEllipse);
  FElementMap.Add('g', TdxSVGElementGroup);
  FElementMap.Add('image', TdxSVGElementImage);
  FElementMap.Add('line', TdxSVGElementLine);
  FElementMap.Add('linearGradient', TdxSVGElementLinearGradient);
  FElementMap.Add('path', TdxSVGElementPath);
  FElementMap.Add('pattern', TdxSVGElementPattern);
  FElementMap.Add('polygon', TdxSVGElementPolygon);
  FElementMap.Add('polyline', TdxSVGElementPolyline);
  FElementMap.Add('radialGradient', TdxSVGElementRadialGradient);
  FElementMap.Add('rect', TdxSVGElementRectangle);
  FElementMap.Add('stop', TdxSVGElementGradientStop);
  FElementMap.Add('svg', TdxSVGElementRoot);
  FElementMap.Add('text', TdxSVGElementText);
  FElementMap.Add('tspan', TdxSVGElementTSpan);
  FElementMap.Add('use', TdxSVGElementUse);
end;

{ TdxSVGImporter }

constructor TdxSVGImporter.Create;
begin
  FStyles := TdxSVGStyles.Create;
  FFixups := TObjectList.Create;
end;

destructor TdxSVGImporter.Destroy;
begin
  FreeAndNil(FStyles);
  FreeAndNil(FFixups);
  inherited Destroy;
end;

class function TdxSVGImporter.GetSize(ADocument: TdxXMLDocument; out ASize: TSize): Boolean;
var
  ANode: TdxXMLNode;
  ARoot: TdxSVGElementRoot;
begin
  Result := ADocument.FindChild(TdxSVGSchema.Svg, ANode);
  if Result then
  begin
    ARoot := TdxSVGElementRoot.Create;
    try
      ARoot.Load(ANode);
      ASize := cxSize(ARoot.Size, False);
    finally
      ARoot.Free;
    end;
  end;
end;

class function TdxSVGImporter.Import(ADocument: TdxXMLDocument; out ARoot: TdxSVGElementRoot): Boolean;
var
  AImporter: TdxSVGImporter;
  ANode: TdxXMLNode;
begin
  Result := ADocument.FindChild(TdxSVGSchema.Svg, ANode);
  if Result then
  begin
    AImporter := TdxSVGImporter.Create;
    try
      ARoot := TdxSVGElementRoot.Create;
      AImporter.ImportCore(ARoot, ANode);
      AImporter.ResolveReferences(ARoot);
    finally
      AImporter.Free;
    end;
  end;
end;

class function TdxSVGImporter.Import(AStream: TStream; out ARoot: TdxSVGElementRoot): Boolean;
var
  ADocument: TdxXMLDocument;
begin
  Result := False;
  ADocument := TdxXMLDocument.Create;
  try
    ADocument.LoadFromStream(AStream);
    if Import(ADocument, ARoot) then
      Result := True; 
  finally
    ADocument.Free;
  end;
end;

procedure TdxSVGImporter.ImportCore(AElement: TdxSVGElement; ANode: TdxXMLNode);
var
  AAttr: TdxXMLNodeAttribute;
begin
  AElement.Load(ANode);
  if ANode.Attributes.Find(TdxSVGSchema.Style, AAttr) then
    TdxSVGInlineStyles.Parse(FStyles.AddInline(AElement), AAttr.ValueAsString);
  if AElement.IsInheritanceSupported and ANode.Attributes.Find(TdxSVGSchema.XLinkHref, AAttr) then
  begin
    if StartsStr(TdxSVGAttributeConverter.ReferencePrefix, AAttr.ValueAsString) then
      FFixups.Add(TdxSVGReferenceFixup.Create(AElement, ANode, TdxSVGAttributeConverter.StringToReference(AAttr.ValueAsString)));
  end;

  ANode := ANode.First;
  while ANode <> nil do
  begin
    ImportNode(AElement, ANode);
    ANode := ANode.Next;
  end;
end;

procedure TdxSVGImporter.ImportNode(AParent: TdxSVGElement; ANode: TdxXMLNode);
var
  AElement: TdxSVGElement;
  AElementClass: TdxSVGElementClass;
begin
  if FElementMap.TryGetValue(ANode.Name, AElementClass) then
  begin
    AElement := AElementClass.Create(AParent);
    AElement.StyleName := ANode.NameAsString;
    ImportCore(AElement, ANode);
  end
  else
    if ANode.Name = TdxSVGSchema.Style then
      ImportStyles(ANode)
    else
end;

procedure TdxSVGImporter.ImportStyles(ANode: TdxXMLNode);

  procedure ParseStyle(AName: string; const AValue: string);
  begin
    AName := Trim(AName);
    if (AName <> '') and (AName[1] = '.') then
      Delete(AName, 1, 1);
    if AName <> '' then
      TdxSVGInlineStyles.Parse(FStyles.Add(AName), AValue);
  end;

var
  AStyleNames: TStringDynArray;
  AStyleParts: TStringDynArray;
  AStylesArray: TStringDynArray;
  I, J: Integer;
begin
  AStylesArray := SplitString(ANode.TextAsString, '}');
  for I := 0 to Length(AStylesArray) - 1 do
    if Pos('{', AStylesArray[I]) > 0 then
    begin
      AStyleParts := SplitString(Trim(AStylesArray[I]), '{');
      if Length(AStyleParts) = 2 then
      begin
        AStyleNames := SplitString(AStyleParts[0], ',');
        for J := 0 to Length(AStyleNames) - 1 do
          ParseStyle(AStyleNames[J], AStyleParts[1]);
      end;
    end;
end;

procedure TdxSVGImporter.ResolveReferences(ARoot: TdxSVGElementRoot);
var
  AFixup: TdxSVGReferenceFixup;
  AFixupCount: Integer;
  APrevID: string;
  AReference: TdxSVGElement;
  I: Integer;
begin
  FStyles.Apply(ARoot);

  repeat
    AFixupCount := FFixups.Count;
    for I := FFixups.Count - 1 downto 0 do
    begin
      AFixup := FFixups.List[I];
      if ARoot.FindByID(AFixup.Reference, AReference) then
      try
        APrevID := AFixup.Element.ID;
        try
          if AFixup.Element.Count > 0 then
            AFixup.Element.AssignCore(AReference)
          else
            AFixup.Element.Assign(AReference);

          AFixup.Element.Load(AFixup.Node);
        finally
          AFixup.Element.ID := APrevID;
        end;
      finally
        FFixups.Delete(I);
      end;
    end;
  until AFixupCount = FFixups.Count;
end;

{ TdxSVGExporter }

class procedure TdxSVGExporter.Export(ARoot: TdxSVGElementRoot; ADocument: TdxXMLDocument);
var
  AChild: TdxXMLNode;
begin
  ADocument.Root.Clear;
  AChild := ADocument.AddChild(TdxSVGSchema.Svg);
  AChild.Attributes.SetValue('version', '1.1');
  AChild.Attributes.SetValue('xmlns', 'http://www.w3.org/2000/svg');
  AChild.Attributes.SetValue('xmlns:xlink', 'http://www.w3.org/1999/xlink');
  ExportCore(ARoot, AChild);
end;

class procedure TdxSVGExporter.ExportCore(AElement: TdxSVGElement; ANode: TdxXMLNode);
var
  I: Integer;
begin
  AElement.Save(ANode);
  for I := 0 to AElement.Count - 1 do
    ExportElement(AElement[I], ANode);
end;

class procedure TdxSVGExporter.ExportElement(AElement: TdxSVGElement; AParent: TdxXMLNode);
var
  ANodeName: TdxXMLString;
begin
  if FElementMap.TryGetKey(TdxSVGElementClass(AElement.ClassType), ANodeName) then
    ExportCore(AElement, AParent.AddChild(ANodeName));
end;

{ TdxSVGReferenceFixup }

constructor TdxSVGReferenceFixup.Create(AElement: TdxSVGElement; ANode: TdxXMLNode; const AReference: string);
begin
  Element := AElement;
  Node := ANode;
  Reference := AReference;
end;

{ TdxSVGNodeAdapter }

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: Single);
begin
  Attributes.SetValueAsString(AName, dxSVGFloatToString(AValue));
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: string);
begin
  if AValue <> '' then
    Attributes.SetValueAsString(AName, AValue);
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue, ADefaultValue: Single);
begin
  if not SameValue(AValue, ADefaultValue) then
    SetAttr(AName, AValue);
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxSVGFill);
begin
  if not AValue.IsDefault then
    Attributes.Add(AName).ValueAsFill := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxSVGFillMode);
begin
  if AValue <> fmNonZero then
    Attributes.Add(AName).ValueAsFillMode := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxGpLineJoin);
begin
  if AValue <> LineJoinMiter then
    Attributes.Add(AName).ValueAsLineJoin := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxSVGLineCapStyle);
begin
  if AValue <> lcsDefault then
    Attributes.Add(AName).ValueAsLineCap := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxSVGShapeRendering);
begin
  Attributes.Add(AName).ValueAsShapeRendering := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxSVGTextAnchor);
begin
  if AValue <> taInherit then
    Attributes.Add(AName).ValueAsTextAnchor := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxSVGContentUnits);
begin
  Attributes.Add(AName).ValueAsContentUnits := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxAlphaColor);
begin
  if AValue <> TdxAlphaColors.Default then
    Attributes.Add(AName).ValueAsColor := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxRectF; AAddNewPrefix: Boolean);
var
  AAttr: TdxXMLNodeAttribute;
begin
  if not cxRectIsEmpty(AValue) then
  begin
    AAttr := Attributes.Add(AName);
    AAttr.ValueAsRectF := AValue;
    if AAddNewPrefix then
      AAttr.ValueAsString := 'new ' + AAttr.ValueAsString;
  end;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxSVGValue);
begin
//  if not AValue.IsEmpty then
    Attributes.Add(AName).ValueAsSvgValue := AValue;
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValue: TdxMatrix);
begin
  if not AValue.IsIdentity then
    Attributes.Add(AName).SetValueAsMatrix(AValue);
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValues: TdxSVGSingleValues);
begin
  if AValues.Count > 0 then
    Attributes.Add(AName).SetValueAsArray(AValues);
end;

procedure TdxSVGNodeAdapter.SetAttr(const AName: TdxXMLString; const AValues: TdxSVGValues);
begin
  if AValues.Count > 0 then
    Attributes.Add(AName).SetValueAsSvgValues(AValues);
end;

{ TdxSVGAttributeConverter }

class function TdxSVGAttributeConverter.AlphaColorToString(const AValue: TdxAlphaColor): string;
begin
  if AValue = TdxAlphaColors.Empty then
    Result := 'none'
  else if AValue = TdxAlphaColors.Default then
    Result := ''
  else
    Result := TdxAlphaColors.ToHtml(AValue, False)
end;

class function TdxSVGAttributeConverter.ReferenceToString(const AValue: string; AIsLocalReference: Boolean): string;
begin
  if AValue <> '' then
  begin
    Result := ReferencePrefix + AValue;
    if not AIsLocalReference then
      Result := URLPart1 + Result + URLPart2;
  end
  else
    Result := '';
end;

class function TdxSVGAttributeConverter.StringToAlphaColor(const AValue: string): TdxAlphaColor;
var
  ARgbMacro: Integer;
  ARgbValues: TdxSVGSingleValues;
begin
  ARgbMacro := Pos(RGBMacro, AValue);
  if ARgbMacro > 0 then
  begin
    ARgbValues := TdxSVGParserNumbers.AsNumbers(Copy(AValue, ARgbMacro + Length(RGBMacro), MaxInt), MaxByte);
    try
      if ARgbValues.Count = 3 then
        Result := TdxAlphaColors.FromArgb(MaxByte, Round(ARgbValues[0]), Round(ARgbValues[1]), Round(ARgbValues[2]))
      else
        Result := TdxAlphaColors.Default;
    finally
      ARgbValues.Free;
    end;
  end
  else
    if AValue = TdxSVGSchema.Inherit then
      Result := TdxAlphaColors.Default
    else
      Result := TdxAlphaColors.FromHtml(AValue);
end;

class function TdxSVGAttributeConverter.StringToContentUnits(const S: string): TdxSVGContentUnits;
var
  AIndex: TdxSVGContentUnits;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if ContentUnitsToString[AIndex] = S then
      Exit(AIndex);
  end;
  Result := cuObjectBoundingBox;
end;

class function TdxSVGAttributeConverter.StringToFillRule(const S: string): TdxSVGFillMode;
var
  ARule: TdxSVGFillMode;
begin
  for ARule := Low(TdxSVGFillMode) to High(TdxSVGFillMode) do
  begin
    if FillRuleToString[ARule] = S then
      Exit(ARule);
  end;
  Result := fmInherit;
end;

class function TdxSVGAttributeConverter.StringToLineCap(const S: string): TdxSVGLineCapStyle;
var
  AIndex: TdxSVGLineCapStyle;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if LineCapToString[AIndex] = S then
      Exit(AIndex);
  end;
  Result := lcsDefault;
end;

class function TdxSVGAttributeConverter.StringToLineJoin(const S: string): TdxGpLineJoin;
var
  AIndex: TdxGpLineJoin;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if LineJoinToString[AIndex] = S then
      Exit(AIndex);
  end;
  Result := LineJoinMiter;
end;

class function TdxSVGAttributeConverter.StringToTextAnchor(const S: string): TdxSVGTextAnchor;
var
  AIndex: TdxSVGTextAnchor;
begin
  for AIndex := Low(AIndex) to High(AIndex) do
  begin
    if TextAnchorToString[AIndex] = S then
      Exit(AIndex);
  end;
  Result := taInherit;
end;

class function TdxSVGAttributeConverter.StringToReference(S: string): string;
begin
  S := Trim(S);
  if StartsText(URLPart1, S) and EndsText(URLPart2, S)  then
    S := Copy(S, Length(URLPart1) + 1, Length(S) - Length(URLPart1) - Length(URLPart2));
  if StartsText(ReferencePrefix, S) then
    Result := Copy(S, Length(ReferencePrefix) + 1, MaxInt)
  else
    Result := '';
end;

{ TdxSVGAttributeAdapter }

procedure TdxSVGAttributeAdapter.GetValueAsArray(AArray: TdxSVGSingleValues);
var
  ASource: TdxSVGSingleValues;
begin
  ASource := TdxSVGParserNumbers.AsNumbers(ValueAsString);
  try
    AArray.Assign(ASource);
  finally
    ASource.Free;
  end;
end;

procedure TdxSVGAttributeAdapter.SetValueAsArray(AArray: TdxSVGSingleValues);
var
  AStringBuilder: TStringBuilder;
  I: Integer;
begin
  AStringBuilder := TdxStringBuilderManager.Get(256);
  try
    for I := 0 to AArray.Count - 1 do
    begin
      if I > 0 then
        AStringBuilder.Append(',');
      AStringBuilder.Append(dxSVGFloatToString(AArray[I]));
    end;
    ValueAsString := AStringBuilder.ToString;
  finally
    TdxStringBuilderManager.Release(AStringBuilder);
  end;
end;

function TdxSVGAttributeAdapter.GetValueAsColor: TdxAlphaColor;
begin
  Result := TdxSVGAttributeConverter.StringToAlphaColor(ValueAsString);
end;

function TdxSVGAttributeAdapter.GetValueAsFill: TdxSVGFill;
var
  AReference: string;
  AValue: string;
begin
  AValue := ValueAsString;
  if StartsText(TdxSVGAttributeConverter.URLPart1, Trim(AValue)) then
  begin
    AReference := TdxSVGAttributeConverter.StringToReference(AValue);
    if AReference <> '' then
      Result := TdxSVGFill.Create(AReference)
    else
      Result := TdxSVGFill.Default;
  end
  else
    Result := TdxSVGFill.Create(TdxSVGAttributeConverter.StringToAlphaColor(AValue));
end;

function TdxSVGAttributeAdapter.GetValueAsFillMode: TdxSVGFillMode;
begin
  Result := TdxSVGAttributeConverter.StringToFillRule(ValueAsString);
end;

function TdxSVGAttributeAdapter.GetValueAsFloat: Double;
begin
  Result := dxStrToFloatDef(ValueAsString);
end;

function TdxSVGAttributeAdapter.GetValueAsLineCap: TdxSVGLineCapStyle;
begin
  Result := TdxSVGAttributeConverter.StringToLineCap(ValueAsString);
end;

function TdxSVGAttributeAdapter.GetValueAsLineJoin: TdxGpLineJoin;
begin
  Result := TdxSVGAttributeConverter.StringToLineJoin(ValueAsString);
end;

procedure TdxSVGAttributeAdapter.GetValueAsMatrix(AMatrix: TdxMatrix);
begin
  TdxSVGParserTransform.Parse(ValueAsString, AMatrix);
end;

function TdxSVGAttributeAdapter.GetValueAsRectF: TdxRectF;
begin
  Result := TdxSVGParserRect.Parse(ValueAsString);
end;

function TdxSVGAttributeAdapter.GetValueAsShapeRendering: TdxSVGShapeRendering;
begin
  Result := TdxSVGShapeRenderingString.Parse(ValueAsString);
end;

function TdxSVGAttributeAdapter.GetValueAsSvgValue: TdxSVGValue;
begin
  if not TdxSVGParserValue.Parse(ValueAsString, Result) then
    Result := TdxSVGValue.Create(0, utPx);
end;

function TdxSVGAttributeAdapter.GetValueAsSvgValues: TdxSVGValues;
begin
  TdxSVGParserValue.Parse(ValueAsString, Result);
end;

function TdxSVGAttributeAdapter.GetValueAsTextAnchor: TdxSVGTextAnchor;
begin
  Result := TdxSVGAttributeConverter.StringToTextAnchor(ValueAsString);
end;

function TdxSVGAttributeAdapter.GetValueAsContentUnits: TdxSVGContentUnits;
begin
  Result := TdxSVGAttributeConverter.StringToContentUnits(ValueAsString);
end;

procedure TdxSVGAttributeAdapter.SetValueAsColor(const AValue: TdxAlphaColor);
begin
  ValueAsString := TdxSVGAttributeConverter.AlphaColorToString(AValue);
end;

procedure TdxSVGAttributeAdapter.SetValueAsFill(const AValue: TdxSVGFill);
begin
  if AValue.IsDefault then
    ValueAsString := ''
  else if AValue.IsReference then
    ValueAsString := TdxSVGAttributeConverter.ReferenceToString(AValue.AsReference, False)
  else if AValue.IsEmpty then
    ValueAsString := TdxSVGSchema.None
  else
    ValueAsString := TdxSVGAttributeConverter.AlphaColorToString(AValue.AsColor);
end;

procedure TdxSVGAttributeAdapter.SetValueAsFillMode(const AValue: TdxSVGFillMode);
begin
  ValueAsString := TdxSVGAttributeConverter.FillRuleToString[AValue];
end;

procedure TdxSVGAttributeAdapter.SetValueAsFloat(const AValue: Double);
begin
  ValueAsString := dxSVGFloatToString(AValue);
end;

procedure TdxSVGAttributeAdapter.SetValueAsLineCap(const AValue: TdxSVGLineCapStyle);
begin
  ValueAsString := TdxSVGAttributeConverter.LineCapToString[AValue];
end;

procedure TdxSVGAttributeAdapter.SetValueAsLineJoin(const AValue: TdxGpLineJoin);
begin
  ValueAsString := TdxSVGAttributeConverter.LineJoinToString[AValue];
end;

procedure TdxSVGAttributeAdapter.SetValueAsMatrix(AMatrix: TdxMatrix);
var
  ABuffer: TStringBuilder;
begin
  ABuffer := TdxStringBuilderManager.Get(256);
  try
    ABuffer.Append('matrix(');
    ABuffer.Append(dxSVGFloatToString(AMatrix.XForm.eM11));
    ABuffer.Append(' ');
    ABuffer.Append(dxSVGFloatToString(AMatrix.XForm.eM12));
    ABuffer.Append(' ');
    ABuffer.Append(dxSVGFloatToString(AMatrix.XForm.eM21));
    ABuffer.Append(' ');
    ABuffer.Append(dxSVGFloatToString(AMatrix.XForm.eM22));
    ABuffer.Append(' ');
    ABuffer.Append(dxSVGFloatToString(AMatrix.XForm.eDx));
    ABuffer.Append(' ');
    ABuffer.Append(dxSVGFloatToString(AMatrix.XForm.eDy));
    ABuffer.Append(')');
    ValueAsString := ABuffer.ToString;
  finally
    TdxStringBuilderManager.Release(ABuffer);
  end;
end;

procedure TdxSVGAttributeAdapter.SetValueAsRectF(const AValue: TdxRectF);
var
  ABuffer: TStringBuilder;
begin
  ABuffer := TdxStringBuilderManager.Get(32);
  try
    ABuffer.Append(dxSVGFloatToString(AValue.Left));
    ABuffer.Append(' ');
    ABuffer.Append(dxSVGFloatToString(AValue.Top));
    ABuffer.Append(' ');
    ABuffer.Append(dxSVGFloatToString(AValue.Right));
    ABuffer.Append(' ');
    ABuffer.Append(dxSVGFloatToString(AValue.Bottom));

    ValueAsString := ABuffer.ToString;
  finally
    TdxStringBuilderManager.Release(ABuffer);
  end;
end;

procedure TdxSVGAttributeAdapter.SetValueAsShapeRendering(const AValue: TdxSVGShapeRendering);
begin
  ValueAsString := TdxSVGShapeRenderingString.NameMap[AValue];
end;

procedure TdxSVGAttributeAdapter.SetValueAsSvgValue(const AValue: TdxSVGValue);
begin
  ValueAsString := dxSVGFloatToString(AValue.Data) + TdxSVGParserValue.NameMap[AValue.UnitsType];
end;

procedure TdxSVGAttributeAdapter.SetValueAsSvgValues(const AValues: TdxSVGValues);
var
  I: Integer;
  AResult: TStringBuilder;
begin
  if AValues.Count = 0 then
    ValueAsString := ''
  else
  begin
    AResult := TdxStringBuilderManager.Get;
    try
      AResult.Append(dxSVGFloatToString(AValues[0].Data));
      AResult.Append(TdxSVGParserValue.NameMap[AValues[0].UnitsType]);
      for I := 1 to AValues.Count - 1 do
      begin
        AResult.Append(' ');
        AResult.Append(dxSVGFloatToString(AValues[I].Data));
        AResult.Append(TdxSVGParserValue.NameMap[AValues[I].UnitsType]);
      end;
      ValueAsString := AResult.ToString;
    finally
      TdxStringBuilderManager.Release(AResult);
    end;
  end;
end;

procedure TdxSVGAttributeAdapter.SetValueAsTextAnchor(const AValue: TdxSVGTextAnchor);
begin
  ValueAsString := TdxSVGAttributeConverter.TextAnchorToString[AValue];
end;

procedure TdxSVGAttributeAdapter.SetValueAsContentUnits(const AValue: TdxSVGContentUnits);
begin
  ValueAsString := TdxSVGAttributeConverter.ContentUnitsToString[AValue];
end;

{ TdxFontIconsResolver }

class constructor TdxFontIconsResolver.Initialize;
begin
  FTrimChars := TArray<Char>.Create('"', ' ', #$27);
  IconsStyle := TFontIconsStyle.Latest;
  FLatest := Format('%s,%s', [fluentIcons, mdlAssets]);
  FWin10 := MdlAssets;
end;

class function TdxFontIconsResolver.ResolveFontName(const AInput: string): string;
begin
  Result := TdxStringHelper.Trim(AInput, FTrimChars);
  if SameText(Result, FontIconsFamily) then
  begin
    case IconsStyle of
      TFontIconsStyle.Latest:
        Exit(FLatest);
      TFontIconsStyle.Win10:
        Exit(FWin10);
      else
        Exit(FLatest);
    end;
  end;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSVGFiler.Initialize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSVGFiler.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
