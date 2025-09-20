{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressFlowChart                                         }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSFLOWCHART AND ALL ACCOMPANYING }
{   VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.              }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE end USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxSugiyamaLayout;

{$I cxVer.inc}
{.$DEFINE EQUALRESULTS}

interface

uses
  Types, SysUtils, Classes, Generics.Defaults, Generics.Collections,
  dxCore, dxCoreClasses, cxGeometry, dxGenerics, dxSugiyamaLayout.Utils;

{$IFDEF WIN64}

{$IF DEFINED(VER210)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS14.a"'}
{$ELSEIF DEFINED(VER220)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS15.a"'}
{$ELSEIF DEFINED(VER230)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS16.a"'}
{$ELSEIF DEFINED(VER240)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS17.a"'}
{$ELSEIF DEFINED(VER250)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS18.a"'}
{$ELSEIF DEFINED(VER260)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS19.a"'}
{$ELSEIF DEFINED(VER270)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS20.a"'}
{$ELSEIF DEFINED(VER280)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS21.a"'}
{$ELSEIF DEFINED(VER290)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS22.a"'}
{$ELSEIF DEFINED(VER300)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS23.a"'}
{$ELSEIF DEFINED(VER310)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS24.a"'}
{$ELSEIF DEFINED(VER320)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS25.a"'}
{$ELSEIF DEFINED(VER330)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS26.a"'}
{$ELSEIF DEFINED(VER340)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS27.a"'}
{$ELSEIF DEFINED(VER350)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS28.a"'}
{$ELSEIF DEFINED(VER360)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS29.a"'}
{$ELSE}
  Unsupported
{$IFEND}

{$ELSE}

{$IF DEFINED(VER210)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS14.lib"'}
{$ELSEIF DEFINED(VER220)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS15.lib"'}
{$ELSEIF DEFINED(VER230)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS16.lib"'}
{$ELSEIF DEFINED(VER240)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS17.lib"'}
{$ELSEIF DEFINED(VER250)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS18.lib"'}
{$ELSEIF DEFINED(VER260)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS19.lib"'}
{$ELSEIF DEFINED(VER270)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS20.lib"'}
{$ELSEIF DEFINED(VER280)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS21.lib"'}
{$ELSEIF DEFINED(VER290)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS22.lib"'}
{$ELSEIF DEFINED(VER300)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS23.lib"'}
{$ELSEIF DEFINED(VER310)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS24.lib"'}
{$ELSEIF DEFINED(VER320)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS25.lib"'}
{$ELSEIF DEFINED(VER330)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS26.lib"'}
{$ELSEIF DEFINED(VER340)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS27.lib"'}
{$ELSEIF DEFINED(VER350)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS28.lib"'}
{$ELSEIF DEFINED(VER360)}
  {$HPPEMIT '#pragma link "dxFlowChartLayoutsRS29.lib"'}
{$ELSE}
  Unsupported
{$IFEND}

{$ENDIF}

type
  TdxUseConnectionsMode = (OutgoingOnly, IncomingOnly);
  TdxUseConnectionsModes = set of TdxUseConnectionsMode;

const
  DefaultUseConnectionsModes = [OutgoingOnly, IncomingOnly];

type
  TdxGraph = class;

  TdxAlignment = (Near, Center, Far);
  TdxDirection = (Left, Up, Right, Down);
  TdxGraphViewKind = (Depth, Breadth);
  TdxLayoutDirection = (TopToBottom, BottomToTop, LeftToRight, RightToLeft);
  TdxLogicalDirectionKind = (Backward, Forward);
  TdxOrientationKind = (Horizontal, Vertical);
  TdxSugiyamaLayoutCheck = (AllCyclesRemoved, SingleConnectedComponent);
  TdxSugiyamaLayoutChecks = set of TdxSugiyamaLayoutCheck;
  TdxThicknessInfo = TdxRectDouble;
  TMedianAlignmentMode = (TopLeft, TopRight, BottomLeft, BottomRight);

  TdxPageInfo = record
    PageSize: TdxSizeDouble;
    PageMargin: TdxRectDouble;
    Canvas: TdxRectDouble;
    BreadthAlignment: TdxAlignment;
    DepthAlignment: TdxAlignment;
    constructor Create(const APageSize: TdxSizeDouble); overload;
    constructor Create(const APageSize: TdxSizeDouble; const APageMargin: TdxRectDouble); overload;
    constructor Create(const APageSize: TdxSizeDouble; const ACanvas: TdxRectDouble; APageMargin: TdxThicknessInfo;
      ABreadthAlignment: TdxAlignment = TdxAlignment.Center; ADepthAlignment: TdxAlignment = TdxAlignment.Near); overload;
    constructor Create(const APageSize: TdxSizeDouble; ABreadthAlignment: TdxAlignment; ADepthAlignment: TdxAlignment); overload;

    function GetAlignment(AGraphViewKind: TdxGraphViewKind): TdxAlignment;
  end;

  IdxGraphLayoutSettings = interface
  ['{D88A9EC3-9803-4DAA-AC30-ABD9C751F441}']
    function GetDirection: TdxDirection;
    function GetDepthOrientation: TdxOrientationKind;
    function GetBreadthOrientation: TdxOrientationKind;
    function GetLogicalDirection: TdxLogicalDirectionKind;
    function GetPageInfo: TdxPageInfo;
    function GetDepthSpacing: Double;

    property Direction: TdxDirection read GetDirection;
    property DepthOrientation: TdxOrientationKind read GetDepthOrientation;
    property BreadthOrientation: TdxOrientationKind read GetBreadthOrientation;
    property LogicalDirection: TdxLogicalDirectionKind read GetLogicalDirection;
    property PageInfo: TdxPageInfo read GetPageInfo;
    property DepthSpacing: Double read GetDepthSpacing;
  end;

  { TdxTuple<T> }

  TdxTuple<T> = class
  strict private
    FFirst: TList<T>;
    FSecond: TList<T>;
  public
    constructor Create(const AFirst, ASecond: TList<T>);
    destructor Destroy; override;
    property First: TList<T> read FFirst;
    property Second: TList<T> read FSecond;
  end;

  { TdxTuple<TFirst, TSecond> }

  TdxTuple<TFirst, TSecond> = packed record
  public
    First: TFirst;
    Second: TSecond;
    constructor Create(const AFirst: TFirst; const ASecond: TSecond);
  end;

  { TdxDiagramItem }

  TdxDiagramItemGetSizeFunc = function (): TdxSizeDouble of object;
  TdxDiagramItem = TObject;

  { TdxPositionInfo }

  TdxPositionInfo = packed record
  strict private
    FItem: TdxDiagramItem;
    FPosition: TdxPointDouble;
  public
    constructor Create(AItem: TdxDiagramItem; const APosition: TdxPointDouble);
    function Offset(const AOffset: TdxPointDouble): TdxPositionInfo;
    function ToString: string;

    property Item: TdxDiagramItem read FItem;
    property Position: TdxPointDouble read FPosition;
  end;

  { TdxEdge<T> }

  TdxEdge<T> = packed record
  strict private
    FFrom: T;
    FTo: T;
  public
    constructor Create(const AFrom, ATo: T);
    function Equals(AObj: TdxEdge<T>): Boolean;
    function GetHashCode: Integer;
    function ToString: string;
    function Reverse: TdxEdge<T>;

    property From: T read FFrom;
    property &To: T read FTo;
  end;

  { TdxEdgeDictionary<TValue> }

  TdxEdgeDictionary<T, TValue> = class(TObjectDictionary<TdxEdge<T>, TValue>)
  public
    constructor Create(AOwnerships: TDictionaryOwnerships = []);
    function ToString: string; override;
  end;

  { TdxAdjacentEdges<T> }

  TdxAdjacentEdges<T> = class
  strict private
    FIncoming: TArray<TdxEdge<T>>;
    FOutgoing: TArray<TdxEdge<T>>;
    function GetDegree: Integer;
  public
    constructor Create(const AOutgoingEdges, AIncomingEdges: TArray<TdxEdge<T>>);
    function GetEdges: TList<TdxEdge<T>>;
    function GetAdjacentNodes: TList<T>;

    property Degree: Integer read GetDegree;
    property Incoming: TArray<TdxEdge<T>> read FIncoming;
    property Outgoing: TArray<TdxEdge<T>> read FOutgoing;
  end;

  { TdxRecursiveSearchActions<T> }

  TdxRecursiveSearchActions<T> = record
  strict private
    FViewNode: TProc<T>;
    FNodeIsViewed: TFunc<T, Boolean>;
    FEdgeIsViewed: TFunc<TdxEdge<T>, Boolean>;
    FBeginOutAction: TProc<TdxEdge<T>>;
    FEndOutAction: TProc<TdxEdge<T>>;
    FAllChildrenAreViewed: TProc<T>;
    FBeginIncomingAction: TProc<TdxEdge<T>>;
    FEndIncomingAction: TProc<TdxEdge<T>>;
    FAllParentAreViewed: TProc<T>;
  public
    constructor Create(const AViewNode: TProc<T>; const ANodeIsViewed: TFunc<T, Boolean>; const AEdgeIsViewed: TFunc<TdxEdge<T>, Boolean>;
      const ABeginOutAction: TProc<TdxEdge<T>>; const AEndOutAction: TProc<TdxEdge<T>>; const AAllChildrenAreViewed: TProc<T>;
      const ABeginIncomingAction: TProc<TdxEdge<T>>; const AEndIncomingAction: TProc<TdxEdge<T>>; const AAllParentAreViewed: TProc<T>);

    property ViewNode: TProc<T> read FViewNode;
    property NodeIsViewed: TFunc<T, Boolean> read FNodeIsViewed;
    property EdgeIsViewed: TFunc<TdxEdge<T>, Boolean> read FEdgeIsViewed;
    property BeginOutAction: TProc<TdxEdge<T>> read FBeginOutAction;
    property EndOutAction: TProc<TdxEdge<T>> read FEndOutAction;
    property AllChildrenAreViewed: TProc<T> read FAllChildrenAreViewed;
    property BeginIncomingAction: TProc<TdxEdge<T>> read FBeginIncomingAction;
    property EndIncomingAction: TProc<TdxEdge<T>> read FEndIncomingAction;
    property AllParentAreViewed: TProc<T> read FAllParentAreViewed;
  end;

  { TdxGraph }

  TdxGraph = class
  strict private class var
    FNull: TdxDiagramItem;
    class constructor Initialize;
  strict private
    FNodes: TArray<TdxDiagramItem>;
    FEdges: TList<TdxEdge<TdxDiagramItem>>;
    class function IsSameKey(const AKey: TdxDiagramItem; AEdge: TdxEdge<TdxDiagramItem>; AIsOutgoing: Boolean): Boolean; static; inline;
    function GetOrderedDictionary(const AEdges: TList<TdxEdge<TdxDiagramItem>>; AIsOutgoing: Boolean): TdxSmartPointer<TDictionary<TdxDiagramItem, TList<TdxEdge<TdxDiagramItem>>>>;
  public
    constructor Create(const ANodes: TArray<TdxDiagramItem>; const AEdges: TList<TdxEdge<TdxDiagramItem>>); overload;
    constructor Create(const ANodes: TArray<TdxDiagramItem>; const AEdges: TArray<TdxEdge<TdxDiagramItem>>); overload;
    constructor Create; overload;
    destructor Destroy; override;
    function FindConnectedComponent(ARoot: TdxDiagramItem; const AGetAdjacentEdges: TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>): TdxGraph;
    function GetAdjacentEdges(AUseConnectionsModes: TdxUseConnectionsModes = DefaultUseConnectionsModes): TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>;
    function GetConnectedComponents: TList<TdxGraph>;
    function GetSpanningGraph(ARoot: TdxDiagramItem; AConnectionModes: TdxUseConnectionsModes;
      const AEdgeWeightFunc: TFunc<TdxEdge<TdxDiagramItem>, Double>): TdxGraph;
    function IsAcyclic: Boolean;
    class function IsNull(const AValue: TdxDiagramItem): Boolean; static; inline;

    class property Null: TdxDiagramItem read FNull;
    property Nodes: TArray<TdxDiagramItem> read FNodes;
    property Edges: TList<TdxEdge<TdxDiagramItem>> read FEdges;
  end;

  { TdxSugiyamaLayoutSettings }

  TdxSugiyamaLayoutSettings = record
  strict private
    FColumnSpacing: Double;
    FLayerSpacing: Double;
    FLayoutDirection: TdxLayoutDirection;
    function GetDirection: TdxDirection;
    function GetDepthOrientation: TdxOrientationKind;
    function GetBreadthOrientation: TdxOrientationKind;
    function GetLogicalDirection: TdxLogicalDirectionKind;
  public
    constructor Create(AColumnSpacing, ALayerSpacing: Double; ALayoutDirection: TdxLayoutDirection);

    property ColumnSpacing: Double read FColumnSpacing;
    property LayerSpacing: Double read FLayerSpacing;
    property Direction: TdxDirection read GetDirection;
    property DepthOrientation: TdxOrientationKind read GetDepthOrientation;
    property BreadthOrientation: TdxOrientationKind read GetBreadthOrientation;
    property LogicalDirection: TdxLogicalDirectionKind read GetLogicalDirection;
    property LayoutDirection: TdxLayoutDirection read FLayoutDirection;
  end;

  { TdxNodeInfo }

  TdxNodeInfo = class
  strict private
    FNode: TdxDiagramItem;
    FIsDummy: Boolean;
    FLayer: Integer;
    FPosition: Integer;
  public
    constructor Create(ANode: TdxDiagramItem; AIsDummy: Boolean; ALevel, APosition: Integer);
    procedure UpdatePosition(APosition: Integer);
    procedure UpdateLayer(ALevel: Integer);
    function IsEqual(ANodeInfo: TdxNodeInfo): Boolean; overload;
    property IsDummy: Boolean read FIsDummy;
    property Layer: Integer read FLayer write FLayer;
    property Node: TdxDiagramItem read FNode;
    property Position: Integer read FPosition write FPosition;
  end;

  { TdxEdgeInfo }

  TdxEdgeInfo = class
  strict private
    FFrom: TdxNodeInfo;
    FTo: TdxNodeInfo;
    function GetIsDummy: Boolean;
  public
    constructor Create(AFrom: TdxNodeInfo; ATo: TdxNodeInfo);
    function ToEdge: TdxEdge<TdxNodeInfo>;
    function Equals(Obj: TObject): Boolean; override;
    function GetHashCode: Integer; override;
    class function FromEdge(AEdge: TdxEdge<TdxNodeInfo>): TdxEdgeInfo; static;

    property From: TdxNodeInfo read FFrom;
    property &To: TdxNodeInfo read FTo;
    property IsDummy: Boolean read GetIsDummy;
  end;

  { TdxGraphInfo }

  TdxGraphInfo = class
  strict private
    FNodesInfo: TList<TdxNodeInfo>;
    FEdgesInfo: TList<TdxEdgeInfo>;
  public
    constructor Create(const ANodesInfo: TEnumerable<TdxNodeInfo>; const AEdgesInfo: TEnumerable<TdxEdgeInfo>); overload;
    constructor Create; overload;
    destructor Destroy; override;
    property NodesInfo: TList<TdxNodeInfo> read FNodesInfo;
    property EdgesInfo: TList<TdxEdgeInfo> read FEdgesInfo;
  end;

  { TdxSugiyamaPositionsInfo }

  TdxSugiyamaPositionsInfo = class
  strict private
    FPositionsInfo: TArray<TdxPositionInfo>;
    FDummyEdgesRoutes: TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>>;
  public
    constructor Create(const APositionsInfo: TArray<TdxPositionInfo>; ADummyEdgeRoute: TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>>); overload;
    constructor Create; overload;
    destructor Destroy; override;
    function GetEdgesRoutes(AEdge: TdxEdge<TdxDiagramItem>): TArray<TdxPointDouble>;

    property PositionsInfo: TArray<TdxPositionInfo> read FPositionsInfo;
    property DummyEdgesRoutes: TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>> read FDummyEdgesRoutes;
  end;

  { TdxGraphSugiyamaLayoutSettings }

  TdxGraphSugiyamaLayoutSettings = class(TcxIUnknownObject, IdxGraphLayoutSettings)
  strict private
    FSugiyamaLayout: TdxSugiyamaLayoutSettings;
    FPageInfo: TdxPageInfo;
    function GetDirection: TdxDirection;
    function GetDepthOrientation: TdxOrientationKind;
    function GetBreadthOrientation: TdxOrientationKind;
    function GetLogicalDirection: TdxLogicalDirectionKind;
    function GetPageInfo: TdxPageInfo;
    function GetDepthSpacing: Double;
  protected
    property PageInfo: TdxPageInfo read GetPageInfo;

    property Direction: TdxDirection read GetDirection;
    property DepthOrientation: TdxOrientationKind read GetDepthOrientation;
    property BreadthOrientation: TdxOrientationKind read GetBreadthOrientation;
    property LogicalDirection: TdxLogicalDirectionKind read GetLogicalDirection;
    property DepthSpacing: Double read GetDepthSpacing;
  public
    constructor Create(ASugiyamaLayout: TdxSugiyamaLayoutSettings; APageInfo: TdxPageInfo);
    property SugiyamaLayout: TdxSugiyamaLayoutSettings read FSugiyamaLayout;
  end;

  { TdxSugiyamaLayoutAlgorithm }

  TdxSugiyamaLayoutAlgorithm = record
  strict private
    FCycleRemoval: TFunc<TdxGraph, TdxGraph>;
    FLayerAssignment: TFunc<TdxGraph, TDictionary<TdxDiagramItem, Integer>>;
    FNodesOrdering: TFunc<TdxGraph, TDictionary<TdxDiagramItem, Integer>, TdxGraphInfo>;
    FCoordinateAssignment: TFunc<TList<TdxGraphInfo>, TdxSugiyamaPositionsInfo>;
    FChecks: TdxSugiyamaLayoutChecks;
  public
    constructor Create(
      ACycleRemoval: TFunc<TdxGraph, TdxGraph>;
      ALayerAssignment: TFunc<TdxGraph, TDictionary<TdxDiagramItem, Integer>>;
      ANodesOrdering: TFunc<TdxGraph, TDictionary<TdxDiagramItem, Integer>, TdxGraphInfo>;
      ACoordinateAssignment: TFunc<TList<TdxGraphInfo>, TdxSugiyamaPositionsInfo>;
      AChecks: TdxSugiyamaLayoutChecks);

    property CycleRemoval: TFunc<TdxGraph, TdxGraph> read FCycleRemoval;
    property LayerAssignment: TFunc<TdxGraph, TDictionary<TdxDiagramItem, Integer>> read FLayerAssignment;
    property NodesOrdering: TFunc<TdxGraph, TDictionary<TdxDiagramItem, Integer>, TdxGraphInfo> read FNodesOrdering;
    property CoordinateAssignment: TFunc<TList<TdxGraphInfo>, TdxSugiyamaPositionsInfo> read FCoordinateAssignment;
    property Checks: TdxSugiyamaLayoutChecks read FChecks;
  end;

  { TdxSugiyamaLayout }

  TdxSugiyamaLayout = class
  public
    class function LayoutGraph(AGraph: TdxGraph; ALayoutSteps: TdxSugiyamaLayoutAlgorithm): TdxSugiyamaPositionsInfo; static;
  end;

  { TdxCycleRemover }

  TdxCycleRemover = class
  protected
    class function GetNonTrivialStronglyConnectedComponents(AGraph: TdxGraph): TList<TdxGraph>; static;
  public
    class function CycleRemoval(ACyclicGraph: TdxGraph): TdxGraph; static;
    class function GetFeedbackSet(ACyclicGraph: TdxGraph): TdxHashSet<TdxEdge<TdxDiagramItem>>; static;
    class function GetMaxCyclicEdges(AStronglyConnectedComponent: TdxGraph): TdxHashSet<TdxEdge<TdxDiagramItem>>; static;
    class function GetStronglyConnectedComponents(ACyclicGraph: TdxGraph): TList<TdxGraph>; static;
    class function ReverseEdges(AGraph: TdxGraph; const AFeedbackSet: TdxHashSet<TdxEdge<TdxDiagramItem>>): TdxGraph; static;
  end;

  { TdxLayerAssignment }

  TdxLayerAssignment = class
  public
    class function GetLayerAssignment(AAcyclicGraph: TdxGraph): TDictionary<TdxDiagramItem, Integer>; static;
    class function GetFeasibleTree(AAcyclicGraph: TdxGraph): TdxGraph; static;
    class function InitLayerAssignment(AAcyclicGraph: TdxGraph): TDictionary<TdxDiagramItem, Integer>; static;
    class function CalculateNodesLayers(ASpanningTree: TdxGraph): TDictionary<TdxDiagramItem, Integer>; static;
  end;

  { TdxNodesOrderer }

  TdxNodesOrderer = class
  protected const
    MaxIteration = 14; 
  public type
    TOrderMode = (ParentToChildren, ChildrenToParent);
  public
    class function OrderNodes(AAcyclicGraph: TdxGraph; ANodesLayers: TDictionary<TdxDiagramItem, Integer>): TdxGraphInfo; static;
    class function InitGraphInfo(AAcyclicGraph: TdxGraph; ANodesLayers: TDictionary<TdxDiagramItem, Integer>): TdxGraphInfo; static;
    class function InitOrder(const ANodesInfo: TList<TdxNodeInfo>): TDictionary<Integer, TList<TdxNodeInfo>>; static;
    class function GetAdjacentNode(AGraphInfo: TdxGraphInfo): TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>; static;
    class function GetOrderNodes(ALayers: TDictionary<Integer, TList<TdxNodeInfo>>;
      const AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>; AOrderMode: TOrderMode): TDictionary<Integer, TList<TdxNodeInfo>>; static;
    class function SortNodes(ANodesPosition: TDictionary<TdxNodeInfo, Integer>): TList<TdxNodeInfo>; static;
    class function GetNodePosition(AAdjacentNodesPositions: TList<Integer>): Integer; static;
    class function GetAdjacentNodesPositions(ANodesInfo: TdxNodeInfo; AOrderMode: TOrderMode; const AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>): TList<Integer>; static;
    class function GetLayerCrossingCount(ALayer: TList<TdxNodeInfo>; const AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>): Integer; static;
    class function GetCrossingCount(ALayers: TDictionary<Integer, TList<TdxNodeInfo>>; const AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>): Integer; static;
  end;

  { TdxLayoutInfo }

  TdxLayoutInfo = class
  strict private
    FPositions: TArray<TdxPositionInfo>;
    FTotalSize: TdxSizeDouble;
    class function GetEmpty: TdxLayoutInfo; static;
  public
    constructor Create(const APositions: TArray<TdxPositionInfo>; const ATotalSize: TdxSizeDouble);

    class property Empty: TdxLayoutInfo read GetEmpty;
    property Positions: TArray<TdxPositionInfo> read FPositions;
    property TotalSize: TdxSizeDouble read FTotalSize;
  end;

  { TdxGraphOperationsCore }

  TdxGraphOperationsCore = class
  public
    class procedure RecursiveSearch<T>(ACurrentNode: T; const AGetAdjacentEdges: TFunc<T, TdxAdjacentEdges<T>>;
      const ARecursiveSearchActions: TdxRecursiveSearchActions<T>); static;
    class function LayoutGraphCore(const ALayoutInfos: TArray<TdxLayoutInfo>; const ASettings: IdxGraphLayoutSettings;
      const APositionsOffsetCallback: TProc<TdxTuple<Double, TdxPointDouble>, Integer>): TArray<TdxPositionInfo>; static;
    class function GetOffset(ALocation, ATotalSize, ASize: Double; AAlignment: TdxAlignment; AMargin: Double): Double; static;
  end;

  { TdxSugiyamaLayoutInfo }

  TdxSugiyamaLayoutInfo = class
  strict private
    FLayoutInfo: TdxLayoutInfo;
    FDummyEdgesRoutes: TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>>;
  public
    constructor Create(APositionsInfo: TdxLayoutInfo; ADummyEdgesRoutes: TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>>);
    destructor Destroy; override;

    property LayoutInfo: TdxLayoutInfo read FLayoutInfo;
    property DummyEdgesRoutes: TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>> read FDummyEdgesRoutes;
  end;

implementation

uses
  dxTypeHelpers, Math
;

const
  dxThisUnitName = 'dxSugiyamaLayout';


{ TdxPageInfo }

constructor TdxPageInfo.Create(const APageSize: TdxSizeDouble);
begin
  Create(APageSize, TdxRectDouble.Create(APageSize));
end;

constructor TdxPageInfo.Create(const APageSize: TdxSizeDouble; const APageMargin: TdxRectDouble);
begin
  Create(APageSize, TdxRectDouble.Create(APageSize), APageMargin);
end;

constructor TdxPageInfo.Create(const APageSize: TdxSizeDouble; const ACanvas: TdxRectDouble; APageMargin: TdxThicknessInfo;
  ABreadthAlignment: TdxAlignment = TdxAlignment.Center; ADepthAlignment: TdxAlignment = TdxAlignment.Near);
begin
  PageSize := APageSize;
  Canvas := ACanvas;
  PageMargin := APageMargin;
  BreadthAlignment := ABreadthAlignment;
  DepthAlignment := ADepthAlignment;
end;

constructor TdxPageInfo.Create(const APageSize: TdxSizeDouble; ABreadthAlignment, ADepthAlignment: TdxAlignment);
begin
  Create(APageSize, TdxRectDouble.Create(APageSize), TdxRectDouble.Null, ABreadthAlignment, ADepthAlignment);
end;

function TdxPageInfo.GetAlignment(AGraphViewKind: TdxGraphViewKind): TdxAlignment;
begin
  if AGraphViewKind = TdxGraphViewKind.Breadth then
    Result := BreadthAlignment
  else
    Result := DepthAlignment;
end;

{ TdxAdjacentEdges }

constructor TdxAdjacentEdges<T>.Create(const AOutgoingEdges, AIncomingEdges: TArray<TdxEdge<T>>);
begin
  FIncoming := AIncomingEdges;
  FOutgoing := AOutgoingEdges;
end;

function TdxAdjacentEdges<T>.GetDegree: Integer;
begin
  Result := Length(FOutgoing) + Length(FIncoming);
end;

function TdxAdjacentEdges<T>.GetEdges: TList<TdxEdge<T>>;
begin
  Result := TList<TdxEdge<T>>.Create;
  Result.Capacity := Length(Outgoing) + Length(Incoming);
  Result.AddRange(Outgoing);
  Result.AddRange(Incoming);
end;

function TdxAdjacentEdges<T>.GetAdjacentNodes: TList<T>;
var
  I: Integer;
begin
  Result := TList<T>.Create;
  Result.Capacity := Length(Outgoing) + Length(Incoming);
  for I := Low(Outgoing) to High(Outgoing) do
    Result.Add(Outgoing[I].&To);
  for I := Low(Incoming) to High(Incoming) do
    Result.Add(Incoming[I].From);
end;

{ TdxRecursiveSearchActions<T> }

constructor TdxRecursiveSearchActions<T>.Create(
  const AViewNode: TProc<T>;
  const ANodeIsViewed: TFunc<T, Boolean>;
  const AEdgeIsViewed: TFunc<TdxEdge<T>, Boolean>;
  const ABeginOutAction: TProc<TdxEdge<T>>;
  const AEndOutAction: TProc<TdxEdge<T>>;
  const AAllChildrenAreViewed: TProc<T>;
  const ABeginIncomingAction: TProc<TdxEdge<T>>;
  const AEndIncomingAction: TProc<TdxEdge<T>>;
  const AAllParentAreViewed: TProc<T>);
begin
  FViewNode := AViewNode;
  FNodeIsViewed := ANodeIsViewed;
  FEdgeIsViewed := AEdgeIsViewed;
  FBeginOutAction := ABeginOutAction;
  FEndOutAction := AEndOutAction;
  FAllChildrenAreViewed := AAllChildrenAreViewed;
  FBeginIncomingAction := ABeginIncomingAction;
  FEndIncomingAction := AEndIncomingAction;
  FAllParentAreViewed := AAllParentAreViewed;
end;

{ TdxGraphOperationsCore }

class procedure TdxGraphOperationsCore.RecursiveSearch<T>(ACurrentNode: T; const AGetAdjacentEdges: TFunc<T, TdxAdjacentEdges<T>>;
  const ARecursiveSearchActions: TdxRecursiveSearchActions<T>);
var
  AEdge: TdxEdge<T>;
  AEdges: TdxAdjacentEdges<T>;
begin
  if ARecursiveSearchActions.NodeIsViewed(ACurrentNode) then
    Exit;

  if Assigned(ARecursiveSearchActions.ViewNode) then
    ARecursiveSearchActions.ViewNode(ACurrentNode);

  AEdges := AGetAdjacentEdges(ACurrentNode);
  try
    for AEdge in AEdges.Outgoing do
    begin
      if not ARecursiveSearchActions.EdgeIsViewed(AEdge) then
      begin
        if Assigned(ARecursiveSearchActions.BeginOutAction) then
          ARecursiveSearchActions.BeginOutAction(AEdge);

        RecursiveSearch<T>(AEdge.&To, AGetAdjacentEdges, ARecursiveSearchActions);

        if Assigned(ARecursiveSearchActions.EndOutAction) then
          ARecursiveSearchActions.EndOutAction(AEdge);
      end;
    end;
  finally
    AEdges.Free;
  end;

  if Assigned(ARecursiveSearchActions.AllChildrenAreViewed) then
    ARecursiveSearchActions.AllChildrenAreViewed(ACurrentNode);

  AEdges := AGetAdjacentEdges(ACurrentNode);
  try
    for AEdge in AEdges.Incoming do
      if not ARecursiveSearchActions.EdgeIsViewed(AEdge) then
      begin
        if Assigned(ARecursiveSearchActions.BeginIncomingAction) then
          ARecursiveSearchActions.BeginIncomingAction(AEdge);

        RecursiveSearch<T>(AEdge.From, AGetAdjacentEdges, ARecursiveSearchActions);

        if Assigned(ARecursiveSearchActions.EndIncomingAction) then
          ARecursiveSearchActions.EndIncomingAction(AEdge);
      end;
  finally
    AEdges.Free;
  end;

  if Assigned(ARecursiveSearchActions.AllParentAreViewed) then
    ARecursiveSearchActions.AllParentAreViewed(ACurrentNode);
end;

function GetBreadth(const ASettings: IdxGraphLayoutSettings; const ASize: TdxSizeDouble): Double;
begin
  if ASettings.BreadthOrientation = TdxOrientationKind.Horizontal then
    Result := ASize.Width
  else
    Result := ASize.Height;
end;

function GetDepth(const ASettings: IdxGraphLayoutSettings; const ASize: TdxSizeDouble): Double;
begin
  if ASettings.DepthOrientation = TdxOrientationKind.Horizontal then
    Result := ASize.Width
  else
    Result := ASize.Height;
end;

function GetDirectedValue(ALogicalDirection: TdxLogicalDirectionKind; AValue: Double): Double;
begin
  if ALogicalDirection = TdxLogicalDirectionKind.Forward then
    Result := AValue
  else
    Result := -AValue;
end;

function InverseDirection(ADirection: TdxDirection): TdxDirection;
begin
  case ADirection of
    TdxDirection.Left:
      Result := TdxDirection.Right;
    TdxDirection.Up:
      Result := TdxDirection.Down;
    TdxDirection.Right:
      Result := TdxDirection.Left;
    else
      Result := TdxDirection.Up;
  end;
end;

function RotateDirection(ADirection: TdxDirection): TdxDirection;
begin
  case ADirection of
    TdxDirection.Left:
      Result := TdxDirection.Down;
    TdxDirection.Up:
      Result := TdxDirection.Right;
    TdxDirection.Right:
      Result := TdxDirection.Down;
    else
      Result := TdxDirection.Right;
  end;
end;

function GetValue(ADirection: TdxDirection; const APageMargin: TdxRectDouble): Double;
begin
  case ADirection of
    TdxDirection.Left:
      Result := APageMargin.Right;
    TdxDirection.Up:
      Result := APageMargin.Bottom;
    TdxDirection.Right:
      Result := APageMargin.Left;
    else
      Result := APageMargin.Top;
  end;
end;

function GetPageMargin(const ASettings: IdxGraphLayoutSettings; AGraphViewKind: TdxGraphViewKind): Double;
begin
  if AGraphViewKind = TdxGraphViewKind.Depth then
    Result := GetValue(ASettings.Direction, ASettings.PageInfo.PageMargin) +
      GetValue(InverseDirection(ASettings.Direction), ASettings.PageInfo.PageMargin)
  else
    Result := GetValue(RotateDirection(ASettings.Direction), ASettings.PageInfo.PageMargin) +
      GetValue(InverseDirection(RotateDirection(ASettings.Direction)), ASettings.PageInfo.PageMargin);
end;

function GetPagesSize(APageSize, ATotalSize, AMargin: Double): Double; overload;
var
  AMinPageCoef: Integer;
begin
  AMinPageCoef := Trunc(ATotalSize / APageSize);
  Result := APageSize * AMinPageCoef + APageSize - AMargin * AMinPageCoef;
end;

function GetPagesSize(const ASettings: IdxGraphLayoutSettings; AGraphViewKind: TdxGraphViewKind; ATotalSize: Double): Double; overload;
var
  APageSize: Double;
begin
  if AGraphViewKind = TdxGraphViewKind.Breadth then
    APageSize := GetBreadth(ASettings, ASettings.PageInfo.PageSize)
  else
    APageSize := GetDepth(ASettings, ASettings.PageInfo.PageSize);
  Result := GetPagesSize(APageSize, ATotalSize, GetPageMargin(ASettings, AGraphViewKind));
end;

function GetStartLocation(const ASettings: IdxGraphLayoutSettings; AGraphViewKind: TdxGraphViewKind): Double;
begin
  if AGraphViewKind = TdxGraphViewKind.Breadth then
  begin
    if ASettings.BreadthOrientation = TdxOrientationKind.Horizontal then
      Result := ASettings.PageInfo.Canvas.Left
    else
      Result := ASettings.PageInfo.Canvas.Top;
  end
  else
    Result := 0;
end;

function GetAlignmentDirection(AAlignment: TdxAlignment; ADirection: TdxDirection): TdxDirection;
begin
  if AAlignment = TdxAlignment.Far then
    Result := InverseDirection(ADirection)
  else
    Result := ADirection;
end;

function GetMarginValue(ADirection: TdxDirection; AAlignment: TdxAlignment; AKind: TdxGraphViewKind; APageMargin: TdxThicknessInfo): Double;
begin
  if AKind = TdxGraphViewKind.Depth then
    Result := GetValue(GetAlignmentDirection(AAlignment, ADirection), APageMargin)
  else
    Result := GetValue(GetAlignmentDirection(AAlignment, RotateDirection(ADirection)), APageMargin);
end;

function GetPoint(AOrientation: TdxOrientationKind; const APoint: TPoint): Double;
begin
  if AOrientation = TdxOrientationKind.Horizontal then
    Result := APoint.X
  else
    Result := APoint.Y;
end;

function ChooseDirectionStartValue(ADirection: TdxLogicalDirectionKind; ANear, AFar: Double): Double;
begin
  if ADirection = TdxLogicalDirectionKind.Forward then
    Result := ANear
  else
    Result := AFar;
end;

function GetDepthCorrection(ASettings: IdxGraphLayoutSettings; ADepthOffset: Double): Double;
var
  ALocation, ADepth: Double;
begin
  ALocation := GetPoint(ASettings.DepthOrientation, ASettings.PageInfo.Canvas.TopLeft);
  ADepth := GetPoint(ASettings.DepthOrientation, ASettings.PageInfo.Canvas.BottomRight);
  Result := ChooseDirectionStartValue(ASettings.LogicalDirection, ALocation + ADepthOffset, ADepth - ADepthOffset);
end;

function GetOffset(ASettings: IdxGraphLayoutSettings; AGraphViewKind: TdxGraphViewKind; ASize: Double; ATotalSize: Double): Double;
var
  AOffset: Double;
begin
  AOffset := TdxGraphOperationsCore.GetOffset(
    GetStartLocation(ASettings, AGraphViewKind),
    ATotalSize,
    ASize,
    ASettings.PageInfo.GetAlignment(AGraphViewKind),
    GetMarginValue(ASettings.Direction, ASettings.PageInfo.GetAlignment(AGraphViewKind), AGraphViewKind, ASettings.PageInfo.PageMargin));
  if AGraphViewKind = TdxGraphViewKind.Breadth then
    Result := AOffset
  else
    Result := GetDepthCorrection(ASettings, AOffset);
end;

function GetStartDepth(const ASettings: IdxGraphLayoutSettings; ATotalDepth: Double): Double;
begin
  Result := GetOffset(ASettings, TdxGraphViewKind.Depth, ATotalDepth, GetPagesSize(ASettings, TdxGraphViewKind.Depth, ATotalDepth));
end;

function MakePoint(AOrientation: TdxOrientationKind; APrimary, ASecondary: Double): TdxPointDouble;
begin
  if AOrientation = TdxOrientationKind.Horizontal then
    Result := TdxPointDouble.Create(APrimary, ASecondary)
  else
    Result := TdxPointDouble.Create(ASecondary, APrimary);
end;

function GetOffsetAndAdvanceDepth(const ASettings: IdxGraphLayoutSettings; const ASize: TdxSizeDouble;
  ATotalDepth, ATotalBreadth: Double): TdxTuple<Double, TdxPointDouble>;
var
  ADepthDelta: Double;
  AOffset: TdxPointDouble;
begin
  ADepthDelta := GetDepth(ASettings, ASize);
  ADepthDelta := GetDirectedValue(ASettings.LogicalDirection, ADepthDelta);

  if ASettings.LogicalDirection = TdxLogicalDirectionKind.Backward then
    ATotalDepth := ATotalDepth + ADepthDelta;

  AOffset := MakePoint(ASettings.BreadthOrientation, GetOffset(ASettings, TdxGraphViewKind.Breadth, GetBreadth(ASettings, ASize), ATotalBreadth), ATotalDepth);

  if ASettings.LogicalDirection = TdxLogicalDirectionKind.Forward then
    ATotalDepth := ATotalDepth + ADepthDelta;

  ATotalDepth := ATotalDepth + GetDirectedValue(ASettings.LogicalDirection, ASettings.DepthSpacing);
  Result := TdxTuple<Double, TdxPointDouble>.Create(ATotalDepth, AOffset);
end;

{ TdxGraphOperationsCore }

class function TdxGraphOperationsCore.LayoutGraphCore(const ALayoutInfos: TArray<TdxLayoutInfo>; const ASettings: IdxGraphLayoutSettings;
  const APositionsOffsetCallback: TProc<TdxTuple<Double, TdxPointDouble>, Integer>): TArray<TdxPositionInfo>;
var
  AMaxBreadth, ATotalDepth, ATotalBreadth, ACurrentDepth: Double;
  ALayoutInfo: TdxLayoutInfo;
  AOffset: TdxPointDouble;
  APosition: TdxPositionInfo;
  APositions: TList<TdxPositionInfo>;
  I: Integer;
  AOffsetAndAdvanceDepth: TdxTuple<Double, TdxPointDouble>;
begin
  AMaxBreadth := 0;
  ATotalDepth := 0;

  for ALayoutInfo in ALayoutInfos do
  begin
    AMaxBreadth := Max(AMaxBreadth, GetBreadth(ASettings, ALayoutInfo.TotalSize));
    ATotalDepth := ATotalDepth + GetDepth(ASettings, ALayoutInfo.TotalSize);
  end;

  ATotalBreadth := GetPagesSize(ASettings, TdxGraphViewKind.Breadth, AMaxBreadth);
  ACurrentDepth := GetStartDepth(ASettings, ATotalDepth);

  APositions := TList<TdxPositionInfo>.Create;
  try
    for I := 0 to Length(ALayoutInfos) - 1 do
    begin
      AOffsetAndAdvanceDepth := GetOffsetAndAdvanceDepth(ASettings, ALayoutInfos[I].TotalSize, ACurrentDepth, ATotalBreadth);
      APositionsOffsetCallback(AOffsetAndAdvanceDepth, I);
      ACurrentDepth := AOffsetAndAdvanceDepth.First;
      AOffset := AOffsetAndAdvanceDepth.Second;
      for APosition in ALayoutInfos[I].Positions do
        APositions.Add(APosition.Offset(AOffset));
    end;
    Result := APositions.ToArray;
  finally
    APositions.Free;
  end;
end;

class function TdxGraphOperationsCore.GetOffset(ALocation, ATotalSize, ASize: Double; AAlignment: TdxAlignment; AMargin: Double): Double;
var
  AOffset: Double;
begin
  AOffset := 0;
  case AAlignment of
    TdxAlignment.Near:
      AOffset := AMargin;
    TdxAlignment.Center:
      AOffset := (ATotalSize - ASize) / 2;
    TdxAlignment.Far:
      AOffset := ATotalSize - ASize - AMargin;
  end;
  Result := ALocation + AOffset;
end;

{ TdxTuple<T> }

constructor TdxTuple<T>.Create(const AFirst, ASecond: TList<T>);
begin
  FFirst := TList<T>.Create;
  if AFirst <> nil then
    FFirst.AddRange(AFirst);
  FSecond := TList<T>.Create;
  if ASecond <> nil then
    FSecond.AddRange(ASecond);
end;

destructor TdxTuple<T>.Destroy;
begin
  FFirst.Free;
  FSecond.Free;
  inherited Destroy;
end;

{ TdxTuple<TFirst, TSecond> }

constructor TdxTuple<TFirst, TSecond>.Create(const AFirst: TFirst; const ASecond: TSecond);
begin
  First := AFirst;
  Second := ASecond;
end;

{ TdxPositionInfo }

constructor TdxPositionInfo.Create(AItem: TdxDiagramItem; const APosition: TdxPointDouble);
begin
  FItem := AItem;
  FPosition := APosition;
end;

function TdxPositionInfo.Offset(const AOffset: TdxPointDouble): TdxPositionInfo;
begin
  Result.FItem := FItem;
  Result.FPosition := FPosition;
  Result.FPosition.Offset(AOffset);
end;

function TdxPositionInfo.ToString: string;
begin
  Result := Format('X=%g, Y=%g : %s', [FPosition.X, FPosition.Y, PString(@Item)^]);
end;

{ TdxEdge }

constructor TdxEdge<T>.Create(const AFrom, ATo: T);
begin
  FFrom := AFrom;
  FTo := ATo;
end;

function TdxEdge<T>.Equals(AObj: TdxEdge<T>): Boolean;
begin
  Result :=
    TEqualityComparer<T>.Default.Equals(FFrom, AObj.From) and
    TEqualityComparer<T>.Default.Equals(FTo, AObj.&To);
end;

function TdxEdge<T>.GetHashCode: Integer;
begin
  Result :=
    TEqualityComparer<T>.Default.GetHashCode(FFrom) xor
    TEqualityComparer<T>.Default.GetHashCode(FTo);
end;

function TdxEdge<T>.ToString: string;
begin
  Result := '';
end;

function TdxEdge<T>.Reverse: TdxEdge<T>;
begin
  Result := TdxEdge<T>.Create(&To, FFrom);
end;

{ TdxEdgeDictionary<TValue> }

constructor TdxEdgeDictionary<T, TValue>.Create(AOwnerships: TDictionaryOwnerships = []);
begin
  inherited Create(AOwnerships, TEqualityComparer<TdxEdge<T>>.Construct(
    function (const Left, Right: TdxEdge<T>): Boolean
    begin
      Result := Left.Equals(Right)
    end,
    function (const Value: TdxEdge<T>): Integer
    begin
      Result := Value.GetHashCode;
    end));
end;

function TdxEdgeDictionary<T, TValue>.ToString: string;
begin
  Result := inherited ToString;;
end;

{ TdxGraph }

constructor TdxGraph.Create;
begin
  FEdges := TList<TdxEdge<TdxDiagramItem>>.Create;
end;

constructor TdxGraph.Create(const ANodes: TArray<TdxDiagramItem>; const AEdges: TList<TdxEdge<TdxDiagramItem>>);
begin
  FNodes := ANodes;
  FEdges := AEdges;
end;

constructor TdxGraph.Create(const ANodes: TArray<TdxDiagramItem>; const AEdges: TArray<TdxEdge<TdxDiagramItem>>);
begin
  FNodes := ANodes;
  FEdges := TList<TdxEdge<TdxDiagramItem>>.Create;
  FEdges.AddRange(AEdges);
end;

destructor TdxGraph.Destroy;
begin
  FEdges.Free;
  inherited Destroy;
end;

class constructor TdxGraph.Initialize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorStarted(UnitName, 'TdxGraph.Initialize', SysInit.HInstance);{$ENDIF}
  FNull := Default(TdxDiagramItem);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorFinished(UnitName, 'TdxGraph.Initialize', SysInit.HInstance);{$ENDIF}
end;

function TdxGraph.FindConnectedComponent(ARoot: TdxDiagramItem; const AGetAdjacentEdges: TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>): TdxGraph;
var
  AViewedNodes: TdxHashSet<TdxDiagramItem>;
  AViewedEdges: TdxHashSet<TdxEdge<TdxDiagramItem>>;
begin
  AViewedNodes := TdxHashSet<TdxDiagramItem>.Create;
  AViewedEdges := TdxHashSet<TdxEdge<TdxDiagramItem>>.Create;
  try
    TdxGraphOperationsCore.RecursiveSearch<TdxDiagramItem>(
      ARoot,
      AGetAdjacentEdges,
      TdxRecursiveSearchActions<TdxDiagramItem>.Create(
        procedure (ACurrentNode: TdxDiagramItem)
        begin
          AViewedNodes.Include(ACurrentNode);
        end,
        function (ACurrentNode: TdxDiagramItem): Boolean
        begin
          Result := AViewedNodes.Contains(ACurrentNode);
        end,
        function (AEdge: TdxEdge<TdxDiagramItem>): Boolean
        begin
          Result := AViewedEdges.Contains(AEdge);
        end,
        procedure (AOutgoingEdge: TdxEdge<TdxDiagramItem>)
        begin
          AViewedEdges.Include(AOutgoingEdge);
        end,
        nil,
        nil,
        procedure (AIncomingEdge: TdxEdge<TdxDiagramItem>)
        begin
          AViewedEdges.Include(AIncomingEdge);
        end,
        nil,
        nil)
      );
    Result := TdxGraph.Create(AViewedNodes.ToArray, AViewedEdges.ToList);
  finally
    AViewedNodes.Free;
    AViewedEdges.Free;
  end;
end;

class function TdxGraph.IsSameKey(const AKey: TdxDiagramItem; AEdge: TdxEdge<TdxDiagramItem>; AIsOutgoing: Boolean): Boolean;
begin
  if AIsOutgoing then
    Result := AKey = AEdge.From
  else
    Result := AKey = AEdge.&To;
end;

function TdxGraph.GetOrderedDictionary(const AEdges: TList<TdxEdge<TdxDiagramItem>>; AIsOutgoing: Boolean): TdxSmartPointer<TDictionary<TdxDiagramItem, TList<TdxEdge<TdxDiagramItem>>>>;
var
  AKey: TdxDiagramItem;
  AKeyEdgeList: TList<TdxEdge<TdxDiagramItem>>;
  AEdge: TdxEdge<TdxDiagramItem>;
  I: Integer;
begin
  Result := TObjectDictionary<TdxDiagramItem, TList<TdxEdge<TdxDiagramItem>>>.Create([doOwnsValues]); //!!!!!!!!!!!!!!!!! TODO make TdxOrderedObjectDictionary
  if AEdges.Count = 0 then
    Exit;

  AEdge := AEdges[0];
  if AIsOutgoing then
    AKey := AEdge.From
  else
    AKey := AEdge.&To;
  AKeyEdgeList := TList<TdxEdge<TdxDiagramItem>>.Create;
  AKeyEdgeList.Add(AEdge);
  Result.Value.Add(AKey, AKeyEdgeList);

  for I := 1 to AEdges.Count - 1 do //AEdge in AEdges do
  begin
    AEdge := AEdges[I];
    if not IsSameKey(AKey, AEdge, AIsOutgoing) then
    begin
      if AIsOutgoing then
        AKey := AEdge.From
      else
        AKey := AEdge.&To;
      AKeyEdgeList := TList<TdxEdge<TdxDiagramItem>>.Create;
      Result.Value.Add(AKey, AKeyEdgeList);
    end;
    AKeyEdgeList.Add(AEdge);
  end;
end;

function TdxGraph.GetAdjacentEdges(AUseConnectionsModes: TdxUseConnectionsModes = DefaultUseConnectionsModes): TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>;
var
  AFullEdges: TList<TdxEdge<TdxDiagramItem>>;
  AEdge: TdxEdge<TdxDiagramItem>;
  AOutgoing, AIncoming: TdxSmartPointer<TDictionary<TdxDiagramItem, TList<TdxEdge<TdxDiagramItem>>>>;
  AComparer: IComparer<TdxEdge<TdxDiagramItem>>;
begin
  AFullEdges := TList<TdxEdge<TdxDiagramItem>>.Create;
  try
    AFullEdges.Capacity := Edges.Count;
    for AEdge in Edges do
      if not IsNull(AEdge.From) and not IsNull(AEdge.&To) and (AEdge.From <> AEdge.&To) then
        AFullEdges.Add(AEdge);

    AComparer := TComparer<TdxEdge<TdxDiagramItem>>.Construct(
      function (const Left, Right: TdxEdge<TdxDiagramItem>): Integer
      begin
        Result := TComparer<TdxDiagramItem>.Default.Compare(Right.From, Left.From);
      end);
    AFullEdges.Sort(AComparer);

    AOutgoing := GetOrderedDictionary(AFullEdges, True);
    AComparer := TComparer<TdxEdge<TdxDiagramItem>>.Construct(
      function (const Left, Right: TdxEdge<TdxDiagramItem>): Integer
      begin
        Result := TComparer<TdxDiagramItem>.Default.Compare(Right.&To, Left.&To);
      end);
    AFullEdges.Sort(AComparer);
    AIncoming := GetOrderedDictionary(AFullEdges, False);
  finally
    AFullEdges.Free;
  end;

  Result :=
    function (ANode: TdxDiagramItem): TdxAdjacentEdges<TdxDiagramItem>
    var
      AOutgoingEdges, AIncomingEdges: TArray<TdxEdge<TdxDiagramItem>>;
      AList: TList<TdxEdge<TdxDiagramItem>>;
    begin
      if (TdxUseConnectionsMode.OutgoingOnly in AUseConnectionsModes) and AOutgoing.Value.TryGetValue(ANode, AList) then
        AOutgoingEdges := AList.ToArray
      else
        AOutgoingEdges := nil;
      if (TdxUseConnectionsMode.IncomingOnly in AUseConnectionsModes) and AIncoming.Value.TryGetValue(ANode, AList) then
        AIncomingEdges := AList.ToArray
      else
        AIncomingEdges := nil;
      Result := TdxAdjacentEdges<TdxDiagramItem>.Create(AOutgoingEdges, AIncomingEdges);
    end;
end;

function TdxGraph.GetConnectedComponents: TList<TdxGraph>;
var
  AGetAdjacentEdges: TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>;
  AAllNodes: TdxHashSet<TdxDiagramItem>;
  AAllEdges: TdxHashSet<TdxEdge<TdxDiagramItem>>;
  AConnectedComponent: TdxGraph;
  ANode: TdxDiagramItem;
  AEdge: TdxEdge<TdxDiagramItem>;
begin
  Result := TObjectList<TdxGraph>.Create;
  if Length(Nodes) = 0 then
    Exit;

  AGetAdjacentEdges := GetAdjacentEdges();

  AAllNodes := TdxHashSet<TdxDiagramItem>.Create; 
  for ANode in Nodes do
    if not IsNull(ANode) then
      AAllNodes.Include(ANode);

  AAllEdges := TdxHashSet<TdxEdge<TdxDiagramItem>>.Create; 
  for AEdge in Edges do
    if not IsNull(AEdge.From) and not IsNull(AEdge.&To) and (AEdge.From <> AEdge.&To) then
      AAllEdges.Include(AEdge);
  try
    while AAllNodes.Count > 0 do
    begin
      AConnectedComponent := FindConnectedComponent(AAllNodes.ToArray[0], AGetAdjacentEdges);
      AAllNodes.Exclude(AConnectedComponent.Nodes);
      AAllEdges.Exclude(AConnectedComponent.Edges);

      Result.Add(AConnectedComponent);
    end;
  finally
    AAllNodes.Free;
    AAllEdges.Free;
  end;
end;

function TdxGraph.GetSpanningGraph(ARoot: TdxDiagramItem;
  AConnectionModes: TdxUseConnectionsModes;
  const AEdgeWeightFunc: TFunc<TdxEdge<TdxDiagramItem>, Double>): TdxGraph;
var
  ASpanningTreeNodes: TdxHashSet<TdxDiagramItem>;
  ASpanningTreeEdges: TdxHashSet<TdxEdge<TdxDiagramItem>>;
  AGetAdjacentEdges: TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>;
  ASortedAdjacentEdges: TdxSortedDictionaryOfList<Double, TdxEdge<TdxDiagramItem>>;
  ADefaultEdgeWeightFunc: TFunc<TdxEdge<TdxDiagramItem>, Double>;
  AAddAdjacentEdges, AAddNode: TProc<TdxDiagramItem>;
  AExceptIncorrectEdges: TProc;
  AGetMinWeightedEdge: TFunc<TdxEdge<TdxDiagramItem>>;
  AAddEdge: TProc<TdxEdge<TdxDiagramItem>>;
  AEdgeWeightDelegate: TFunc<TdxEdge<TdxDiagramItem>, Double>;
begin
  if Length(Nodes) = 0 then
  begin
    Result := TdxGraph.Create;
    Exit;
  end;

  ASpanningTreeNodes := TdxHashSet<TdxDiagramItem>.Create;
  ASpanningTreeEdges := TdxHashSet<TdxEdge<TdxDiagramItem>>.Create;
  AGetAdjacentEdges := GetAdjacentEdges(AConnectionModes);
  try
    if not Assigned(AEdgeWeightFunc) then
    begin
      AEdgeWeightDelegate :=
        function (x: TdxEdge<TdxDiagramItem>): Double
        begin
          Result := 1;
        end;
    end
    else
      AEdgeWeightDelegate := AEdgeWeightFunc;

    ASortedAdjacentEdges := TdxSortedDictionaryOfList<Double, TdxEdge<TdxDiagramItem>>.Create(AEdgeWeightDelegate);
    try
      AAddAdjacentEdges :=
        procedure (ANode: TdxDiagramItem)
        var
          AEdges: TArray<TdxEdge<TdxDiagramItem>>;
          AEdge: TdxEdge<TdxDiagramItem>;
          AAdjacentEdges: TdxAdjacentEdges<TdxDiagramItem>;
        begin
          AAdjacentEdges := AGetAdjacentEdges(ANode);
          try
            AEdges := AAdjacentEdges.Outgoing;
            for AEdge in AEdges do
              if not ASpanningTreeEdges.Contains(AEdge) then
                ASortedAdjacentEdges.Add(AEdge);
            AEdges := AAdjacentEdges.Incoming;
            for AEdge in AEdges do
              if not ASpanningTreeEdges.Contains(AEdge) then
                ASortedAdjacentEdges.Add(AEdge);
          finally
            AAdjacentEdges.Free;
          end;
        end;
      AExceptIncorrectEdges :=
        procedure ()
        begin
          ASortedAdjacentEdges.RemoveWhere(
            function (AEdge: TdxEdge<TdxDiagramItem>): Boolean
            begin
              Result := ASpanningTreeNodes.Contains(AEdge.From) and ASpanningTreeNodes.Contains(AEdge.&To);
            end);
        end;
      AGetMinWeightedEdge :=
        function (): TdxEdge<TdxDiagramItem>
        begin
          Result := ASortedAdjacentEdges.GetFirstMin;
          ASortedAdjacentEdges.RemoveFirstMin;
        end;
      AAddNode :=
        procedure (ANode: TdxDiagramItem)
        begin
          ASpanningTreeNodes.Include(ANode);
          AAddAdjacentEdges(ANode);
        end;
      AAddEdge :=
        procedure (AEdge: TdxEdge<TdxDiagramItem>)
        begin
          ASpanningTreeEdges.Include(AEdge);
          if ASpanningTreeNodes.Contains(AEdge.From) then
            AAddNode(AEdge.&To)
          else
            AAddNode(AEdge.From);
        end;

      if IsNull(ARoot) then
        AAddNode(Nodes[0])
      else
        AAddNode(ARoot);

      while ASortedAdjacentEdges.Any and (ASpanningTreeNodes.Count <> Length(Nodes)) do
      begin
        AAddEdge(AGetMinWeightedEdge);
        AExceptIncorrectEdges;
      end;
      Result := TdxGraph.Create(ASpanningTreeNodes.ToArray, ASpanningTreeEdges.ToList);
    finally
      ASortedAdjacentEdges.Free;
    end;
  finally
    ASpanningTreeNodes.Free;
    ASpanningTreeEdges.Free;

    AGetAdjacentEdges := nil;
    ADefaultEdgeWeightFunc := nil;
    AAddAdjacentEdges := nil;
    AAddNode := nil;
    AExceptIncorrectEdges := nil;
    AGetMinWeightedEdge := nil;
    AAddEdge := nil;
    AEdgeWeightDelegate := nil;
  end;
end;

function TdxGraph.IsAcyclic: Boolean;
var
  AGetAdjacentEdges: TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>;
  ABlackNodes, AGrayNodes: TdxHashSet<TdxDiagramItem>;
  ANode: TdxDiagramItem;
  AIsAcyclic: Boolean;
begin
  if Length(Nodes) = 0 then
    Exit(True);

  Result := False;
  AGetAdjacentEdges := GetAdjacentEdges([TdxUseConnectionsMode.OutgoingOnly]);
  ABlackNodes := TdxHashSet<TdxDiagramItem>.Create;
  AGrayNodes := TdxHashSet<TdxDiagramItem>.Create;
  try
    for ANode in Nodes do
    begin
      AIsAcyclic := True;
      TdxGraphOperationsCore.RecursiveSearch<TdxDiagramItem>(
        ANode,
        AGetAdjacentEdges,
        TdxRecursiveSearchActions<TdxDiagramItem>.Create(
          procedure (ACurrentNode: TdxDiagramItem)
          begin
            AGrayNodes.Include(ACurrentNode);
          end,
          function (ACurrentNode: TdxDiagramItem): Boolean
          begin
            if AGrayNodes.Contains(ACurrentNode) then
              AIsAcyclic := False;
            Result := not AIsAcyclic or AGrayNodes.Contains(ACurrentNode) or ABlackNodes.Contains(ACurrentNode);
          end,
          function (AEdge: TdxEdge<TdxDiagramItem>): Boolean
          begin
            Result := not AIsAcyclic;
          end,
          nil,
          nil,
          procedure (ACurrentNode: TdxDiagramItem)
          begin
            ABlackNodes.Include(ACurrentNode);
            AGrayNodes.Exclude(ACurrentNode);
          end,
          nil,
          nil,
          nil
        )
      );
      if not AIsAcyclic then
        Exit;
    end;
    Result := True;
  finally
    ABlackNodes.Free;
    AGrayNodes.Free;
  end;
end;

class function TdxGraph.IsNull(const AValue: TdxDiagramItem): Boolean;
begin
  Result := AValue = nil;
end;


{ TdxNodeInfo }

constructor TdxNodeInfo.Create(ANode: TdxDiagramItem; AIsDummy: Boolean; ALevel, APosition: Integer);
begin
  FNode := ANode;
  FIsDummy := AIsDummy;
  FLayer := ALevel;
  FPosition := APosition;
end;

procedure TdxNodeInfo.UpdatePosition(APosition: Integer);
begin
  Position := APosition;
end;

procedure TdxNodeInfo.UpdateLayer(ALevel: Integer);
begin
  Layer := ALevel;
end;

function TdxNodeInfo.IsEqual(ANodeInfo: TdxNodeInfo): Boolean;
begin
  Result := (FLayer = ANodeInfo.Layer) and (FPosition = ANodeInfo.Position) and (FNode = ANodeInfo.FNode);
end;


{ TdxGraphInfo }

constructor TdxGraphInfo.Create;
begin
  FNodesInfo := TObjectList<TdxNodeInfo>.Create;
  FEdgesInfo := TObjectList<TdxEdgeInfo>.Create;
end;

constructor TdxGraphInfo.Create(const ANodesInfo: TEnumerable<TdxNodeInfo>;
  const AEdgesInfo: TEnumerable<TdxEdgeInfo>);
begin
  Create;
  FNodesInfo.AddRange(ANodesInfo);
  FEdgesInfo.AddRange(AEdgesInfo);
end;

destructor TdxGraphInfo.Destroy;
begin
  FNodesInfo.Free;
  FEdgesInfo.Free;
  inherited Destroy;
end;


{ TdxSugiyamaPositionsInfo }

constructor TdxSugiyamaPositionsInfo.Create;
begin
  Assert(FDummyEdgesRoutes = nil);
  FDummyEdgesRoutes := TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>>.Create;
end;

constructor TdxSugiyamaPositionsInfo.Create(const APositionsInfo: TArray<TdxPositionInfo>;
  ADummyEdgeRoute: TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>>);
begin
  Assert(FDummyEdgesRoutes = nil);
  FPositionsInfo := APositionsInfo;
  FDummyEdgesRoutes := ADummyEdgeRoute;
end;

destructor TdxSugiyamaPositionsInfo.Destroy;
begin
  FDummyEdgesRoutes.Free;
  inherited Destroy;
end;

function TdxSugiyamaPositionsInfo.GetEdgesRoutes(AEdge: TdxEdge<TdxDiagramItem>): TArray<TdxPointDouble>;
begin
  if not FDummyEdgesRoutes.TryGetValue(AEdge, Result) then
    Result := nil;
end;

{ TdxEdgeInfo }

constructor TdxEdgeInfo.Create(AFrom: TdxNodeInfo; ATo: TdxNodeInfo);
begin
  FFrom := AFrom;
  FTo := ATo;
end;


function TdxEdgeInfo.Equals(Obj: TObject): Boolean;
begin
  Result := (FTo = TdxEdgeInfo(Obj).FTo) and (FFrom = TdxEdgeInfo(Obj).From);
end;

function TdxEdgeInfo.GetHashCode: Integer;
begin
  Result := FFrom.GetHashCode xor FTo.GetHashCode;
end;

function TdxEdgeInfo.GetIsDummy: Boolean;
begin
  Result := FFrom.IsDummy or FTo.IsDummy;
end;

function TdxEdgeInfo.ToEdge: TdxEdge<TdxNodeInfo>;
begin
  Result := TdxEdge<TdxNodeInfo>.Create(FFrom, FTo);
end;

class function TdxEdgeInfo.FromEdge(AEdge: TdxEdge<TdxNodeInfo>): TdxEdgeInfo;
begin
  Result := TdxEdgeInfo.Create(AEdge.From, AEdge.&To);
end;

{ TdxSugiyamaLayoutSettings }

constructor TdxSugiyamaLayoutSettings.Create(AColumnSpacing, ALayerSpacing: Double; ALayoutDirection: TdxLayoutDirection);
begin
  FColumnSpacing := AColumnSpacing;
  FLayerSpacing := ALayerSpacing;
  FLayoutDirection := ALayoutDirection;
end;

function TdxSugiyamaLayoutSettings.GetDirection: TdxDirection;
begin
  case LayoutDirection of
    TdxLayoutDirection.TopToBottom:
      Result := TdxDirection.Down;
    TdxLayoutDirection.BottomToTop:
      Result := TdxDirection.Up;
    TdxLayoutDirection.LeftToRight:
      Result := TdxDirection.Right;
    TdxLayoutDirection.RightToLeft:
      Result := TdxDirection.Left;
    else
      raise Exception.Create('Convert error!');
  end;
end;

function TdxSugiyamaLayoutSettings.GetDepthOrientation: TdxOrientationKind;
begin
  if Direction in [TdxDirection.Down, TdxDirection.Up] then
    Result := TdxOrientationKind.Vertical
  else
    Result := TdxOrientationKind.Horizontal;
end;

function TdxSugiyamaLayoutSettings.GetBreadthOrientation: TdxOrientationKind;
begin
  if GetDepthOrientation = TdxOrientationKind.Horizontal then
    Result := TdxOrientationKind.Vertical
  else
    Result := TdxOrientationKind.Horizontal;
end;

function TdxSugiyamaLayoutSettings.GetLogicalDirection: TdxLogicalDirectionKind;
begin
  if Direction in [TdxDirection.Right, TdxDirection.Down] then
    Result := TdxLogicalDirectionKind.Forward
  else
    Result := TdxLogicalDirectionKind.Backward;
end;

{ TdxGraphSugiyamaLayoutSettings }

constructor TdxGraphSugiyamaLayoutSettings.Create(ASugiyamaLayout: TdxSugiyamaLayoutSettings; APageInfo: TdxPageInfo);
begin
  FSugiyamaLayout := ASugiyamaLayout;
  FPageInfo := APageInfo;
end;

function TdxGraphSugiyamaLayoutSettings.GetDirection: TdxDirection;
begin
  Result := SugiyamaLayout.Direction;
end;

function TdxGraphSugiyamaLayoutSettings.GetDepthOrientation: TdxOrientationKind;
begin
  Result := SugiyamaLayout.DepthOrientation;
end;

function TdxGraphSugiyamaLayoutSettings.GetBreadthOrientation: TdxOrientationKind;
begin
  Result := SugiyamaLayout.BreadthOrientation;
end;

function TdxGraphSugiyamaLayoutSettings.GetLogicalDirection: TdxLogicalDirectionKind;
begin
  Result := SugiyamaLayout.LogicalDirection;
end;

function TdxGraphSugiyamaLayoutSettings.GetPageInfo: TdxPageInfo;
begin
  Result := FPageInfo;
end;

function TdxGraphSugiyamaLayoutSettings.GetDepthSpacing: Double;
begin
  Result := SugiyamaLayout.LayerSpacing;
end;

{ TdxSugiyamaLayoutAlgorithm }

constructor TdxSugiyamaLayoutAlgorithm.Create(
  ACycleRemoval: TFunc<TdxGraph, TdxGraph>;
  ALayerAssignment: TFunc<TdxGraph, TDictionary<TdxDiagramItem, Integer>>;
  ANodesOrdering: TFunc<TdxGraph, TDictionary<TdxDiagramItem, Integer>, TdxGraphInfo>;
  ACoordinateAssignment: TFunc<TList<TdxGraphInfo>, TdxSugiyamaPositionsInfo>;
  AChecks: TdxSugiyamaLayoutChecks);
begin
  FCycleRemoval := ACycleRemoval;
  FLayerAssignment := ALayerAssignment;
  FNodesOrdering := ANodesOrdering;
  FCoordinateAssignment := ACoordinateAssignment;
  FChecks := AChecks;
end;

{ TdxCycleRemover }

class function TdxCycleRemover.CycleRemoval(ACyclicGraph: TdxGraph): TdxGraph;
var
  AFeedbackSet: TdxHashSet<TdxEdge<TdxDiagramItem>>;
begin
  AFeedbackSet := GetFeedbackSet(ACyclicGraph);
  try
    Result := ReverseEdges(ACyclicGraph, AFeedbackSet);
  finally
    AFeedbackSet.Free;
  end;
end;

class function TdxCycleRemover.GetNonTrivialStronglyConnectedComponents(AGraph: TdxGraph): TList<TdxGraph>;
var
  AComponents: TEnumerable<TdxGraph>;
  AItem: TdxGraph;
begin
  AComponents := GetStronglyConnectedComponents(AGraph);
  try
    Result := TObjectList<TdxGraph>.Create;
    for AItem in AComponents do
      if AItem.Edges.Count > 0 then
        Result.Add(AItem)
      else
        AItem.Free;
  finally
    AComponents.Free;
  end;
end;

class function TdxCycleRemover.GetFeedbackSet(ACyclicGraph: TdxGraph): TdxHashSet<TdxEdge<TdxDiagramItem>>;
var
  AMaxCyclicEdges: TdxHashSet<TdxEdge<TdxDiagramItem>>;
  ACollection: TList<TdxGraph>;
  AComponent: TdxGraph;
  AEdge: TdxEdge<TdxDiagramItem>;
  AGraph: TdxGraph;
begin
  Result := TdxHashSet<TdxEdge<TdxDiagramItem>>.Create(
    TEqualityComparer<TdxEdge<TdxDiagramItem>>.Construct(
      function(const Left, Right: TdxEdge<TdxDiagramItem>): Boolean
      begin
        Result := Left.Equals(Right);
      end,
      function(const Value: TdxEdge<TdxDiagramItem>): Integer
      begin
        Result := Value.GetHashCode;
      end)
  );

  ACollection := GetNonTrivialStronglyConnectedComponents(ACyclicGraph);
  try
    while ACollection.Count > 0 do
    begin
      for AComponent in ACollection do
      begin
        AMaxCyclicEdges := GetMaxCyclicEdges(AComponent);
        try
          for AEdge in AMaxCyclicEdges do
          begin
            Result.Exclude(AEdge.Reverse);
            Result.Include(AEdge);
          end;
        finally
          AMaxCyclicEdges.Free;
        end;
      end;
      FreeAndNil(ACollection);
      AGraph := ReverseEdges(ACyclicGraph, Result);
      try
        ACollection := GetNonTrivialStronglyConnectedComponents(AGraph);
      finally
        AGraph.Free;
      end;
    end;
  finally
    ACollection.Free;
  end;
end;

class function TdxCycleRemover.ReverseEdges(AGraph: TdxGraph; const AFeedbackSet: TdxHashSet<TdxEdge<TdxDiagramItem>>): TdxGraph;
var
  AEdge, AReversedEdge: TdxEdge<TdxDiagramItem>;
  AEdges: TdxHashSet<TdxEdge<TdxDiagramItem>>;
  AGraphEdges: TList<TdxEdge<TdxDiagramItem>>;
begin
  AEdges := TdxHashSet<TdxEdge<TdxDiagramItem>>.Create(AGraph.Edges.Count,
    TEqualityComparer<TdxEdge<TdxDiagramItem>>.Construct(
        function (const Left, Right: TdxEdge<TdxDiagramItem>): Boolean
        begin
          Result := Left.Equals(Right)
        end,
        function (const Value: TdxEdge<TdxDiagramItem>): Integer
        begin
          Result := Value.GetHashCode;
        end));
  try
    AGraphEdges := TList<TdxEdge<TdxDiagramItem>>.Create;
    AGraphEdges.Capacity := AGraph.Edges.Count;
    for AEdge in AGraph.Edges do
    begin
      if AFeedbackSet.Contains(AEdge) then
      begin
        AReversedEdge := AEdge.Reverse;
        if not AEdges.Contains(AReversedEdge) then
        begin
          AEdges.Include(AReversedEdge);
          AGraphEdges.Add(AReversedEdge);
        end;
      end
      else
        if not AEdges.Contains(AEdge) then
        begin
          AEdges.Include(AEdge);
          AGraphEdges.Add(AEdge);
        end;
    end;
    Result := TdxGraph.Create(AGraph.Nodes, AGraphEdges);
  finally
    AEdges.Free;
  end;
end;

class function TdxCycleRemover.GetMaxCyclicEdges(AStronglyConnectedComponent: TdxGraph): TdxHashSet<TdxEdge<TdxDiagramItem>>;
var
  ABlackNodes, AGrayNodes: TdxHashSet<TdxDiagramItem>;
  AVisitedEdges, AEdges: TList<TdxEdge<TdxDiagramItem>>;
  ACycles: TList<TList<TdxEdge<TdxDiagramItem>>>;
  AEdgeCycleCount: TdxEdgeDictionary<TdxDiagramItem, Integer>;
  ACycleFound: TProc<TdxDiagramItem, TList<TdxEdge<TdxDiagramItem>>>;
  AMaxCycleCountEdge: TdxEdge<TdxDiagramItem>;
  I, ACurrentCycleCount, AMaxCycleCount: Integer;
begin
  ACycles := TObjectList<TList<TdxEdge<TdxDiagramItem>>>.Create;
  try
    AEdgeCycleCount := TdxEdgeDictionary<TdxDiagramItem, Integer>.Create;
    try
      ABlackNodes := TdxHashSet<TdxDiagramItem>.Create;
      AGrayNodes := TdxHashSet<TdxDiagramItem>.Create;
      AVisitedEdges := TList<TdxEdge<TdxDiagramItem>>.Create;
      try
        ACycleFound :=
          procedure (ARootNode: TdxDiagramItem; ACycleWay: TList<TdxEdge<TdxDiagramItem>>)
          var
            ACycle: TList<TdxEdge<TdxDiagramItem>>;
            AEdge: TdxEdge<TdxDiagramItem>;
            AValue: Integer;
          begin
            ACycle := TList<TdxEdge<TdxDiagramItem>>.Create;
            for AEdge in ACycleWay do
            begin
              if not AEdgeCycleCount.TryGetValue(AEdge, AValue) then
                AValue := 0;
              AEdgeCycleCount.AddOrSetValue(AEdge, AValue + 1);

              ACycle.Add(AEdge);
              if TEqualityComparer<TdxDiagramItem>.Default.Equals(AEdge.From, ARootNode) then
                break;
            end;
            ACycles.Add(ACycle);
          end;

        TdxGraphOperationsCore.RecursiveSearch<TdxDiagramItem>(
          AStronglyConnectedComponent.Nodes[0], 
          AStronglyConnectedComponent.GetAdjacentEdges([TdxUseConnectionsMode.OutgoingOnly]),
          TdxRecursiveSearchActions<TdxDiagramItem>.Create(
            procedure (ACurrentNode: TdxDiagramItem)
            begin
              AGrayNodes.Include(ACurrentNode);
            end,
            function (ACurrentNode: TdxDiagramItem): Boolean
            begin
              if AGrayNodes.Contains(ACurrentNode) then
                ACycleFound(ACurrentNode, AVisitedEdges);
              Result := AGrayNodes.Contains(ACurrentNode) or ABlackNodes.Contains(ACurrentNode);
            end,
            function (ACurrentEdge: TdxEdge<TdxDiagramItem>): Boolean
            begin
              Result := False;
            end,
            procedure (AOutgoingEdge: TdxEdge<TdxDiagramItem>)
            begin
              AVisitedEdges.Insert(0, AOutgoingEdge);
            end,
            procedure (AOutgoingEdge: TdxEdge<TdxDiagramItem>)
            begin
              AVisitedEdges.Delete(0);
            end,
            procedure (ACurrentNode: TdxDiagramItem)
            begin
              ABlackNodes.Include(ACurrentNode);
              AGrayNodes.Exclude(ACurrentNode);
            end,
            nil,
            nil,
            nil)
          )
      finally
        ABlackNodes.Free;
        AGrayNodes.Free;
        AVisitedEdges.Free;
      end;

      Result := TdxHashSet<TdxEdge<TdxDiagramItem>>.Create;

      for AEdges in ACycles do
      begin
        if AEdges.Count > 0 then
        begin
          AMaxCycleCountEdge := AEdges[0];
          AMaxCycleCount := AEdgeCycleCount[AMaxCycleCountEdge];
          for I := 1 to AEdges.Count - 1 do
          begin
            ACurrentCycleCount := AEdgeCycleCount[AEdges[I]];
            if ACurrentCycleCount > AMaxCycleCount then
            begin
              AMaxCycleCount := ACurrentCycleCount;
              AMaxCycleCountEdge := AEdges[I];
            end;
          end;
          Result.Include(AMaxCycleCountEdge);
        end;
      end;
    finally
      AEdgeCycleCount.Free;
    end;
  finally
    ACycles.Free;

    ACycleFound := nil;
  end;
end;

class function TdxCycleRemover.GetStronglyConnectedComponents(ACyclicGraph: TdxGraph): TList<TdxGraph>;
var
  AVisitedNodes: TdxHashSet<TdxDiagramItem>;
  ANodesStack: TStack<TdxDiagramItem>;
  AGetAdjacentEdges: TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>;
  ALowIndex, ALowLink: TDictionary<TdxDiagramItem, Integer>;
  AOnStack: TDictionary<TdxDiagramItem, Boolean>;
  AComponents: TList<TdxGraph>;
  AIndex: Integer;
  AAddConnectedComponent: TProc<TdxDiagramItem>;
  ANode: TdxDiagramItem;
begin
  AIndex := 0;
  AComponents := TList<TdxGraph>.Create;
  try
    AVisitedNodes := TdxHashSet<TdxDiagramItem>.Create;
    ANodesStack := TStack<TdxDiagramItem>.Create;
    ALowIndex := TDictionary<TdxDiagramItem, Integer>.Create;
    ALowLink := TDictionary<TdxDiagramItem, Integer>.Create;
    AOnStack := TDictionary<TdxDiagramItem, Boolean>.Create;

    AGetAdjacentEdges := ACyclicGraph.GetAdjacentEdges([TdxUseConnectionsMode.OutgoingOnly]);

    AAddConnectedComponent :=
      procedure (ARootNode: TdxDiagramItem)
      var
        AComponentNodes: TdxHashSet<TdxDiagramItem>;
        AComponentEdges: TList<TdxEdge<TdxDiagramItem>>;
        ANode, ATopStackNode: TdxDiagramItem;
        AAdjacentEdges: TdxAdjacentEdges<TdxDiagramItem>;
        AEdge: TdxEdge<TdxDiagramItem>;
      begin
        AComponentNodes := TdxHashSet<TdxDiagramItem>.Create;
        try
          AComponentEdges := TList<TdxEdge<TdxDiagramItem>>.Create;
          try
            repeat
              ATopStackNode := ANodesStack.Pop;
              AComponentNodes.Include(ATopStackNode);
              AOnStack.AddOrSetValue(ATopStackNode, False);
            until TEqualityComparer<TdxDiagramItem>.Default.Equals(ATopStackNode, ARootNode);

            for ANode in AComponentNodes do
            begin
              AAdjacentEdges := AGetAdjacentEdges(ANode);
              try
                for AEdge in AAdjacentEdges.Outgoing do
                  if AComponentNodes.Contains(AEdge.&To) then
                    AComponentEdges.Add(AEdge);
              finally
                AAdjacentEdges.Free;
              end;
            end;
            AComponents.Add(TdxGraph.Create(AComponentNodes.ToArray, AComponentEdges.ToArray));
          finally
            AComponentEdges.Free;
          end;
        finally
          AComponentNodes.Free;
        end;
      end;

    for ANode in ACyclicGraph.Nodes do
    begin
      TdxGraphOperationsCore.RecursiveSearch<TdxDiagramItem>(
        ANode,
        AGetAdjacentEdges,
        TdxRecursiveSearchActions<TdxDiagramItem>.Create(
          procedure (ACurrentNode: TdxDiagramItem)
          begin
            AVisitedNodes.Include(ACurrentNode);
            ANodesStack.Push(ACurrentNode);
            AOnStack.AddOrSetValue(ACurrentNode, True);
            ALowLink.AddOrSetValue(ACurrentNode, AIndex);
            ALowIndex.AddOrSetValue(ACurrentNode, AIndex);
            Inc(AIndex);
          end,
          function (ACurrentNode: TdxDiagramItem): Boolean
          begin
            Result := AVisitedNodes.Contains(ACurrentNode);
          end,
          function (ACurrentEdge: TdxEdge<TdxDiagramItem>): Boolean
          begin
            Result := AVisitedNodes.Contains(ACurrentEdge.&To);
            if Result and AOnStack[ACurrentEdge.&To] then
              ALowLink[ACurrentEdge.From] := Min(ALowLink[ACurrentEdge.From], ALowIndex[ACurrentEdge.&To]);
          end,
          nil,
          procedure (AOutgoingEdge: TdxEdge<TdxDiagramItem>)
          begin
            ALowLink.AddOrSetValue(AOutgoingEdge.From, Min(ALowLink[AOutgoingEdge.From], ALowLink[AOutgoingEdge.&To]));
          end,
          procedure (ACurrentNode: TdxDiagramItem)
          begin
            if (ALowLink[ACurrentNode] = ALowIndex[ACurrentNode]) then
              AAddConnectedComponent(ACurrentNode);
          end,
          nil,
          nil,
          nil)
        );
    end;
    Result := AComponents;
  finally
    AVisitedNodes.Free;
    ANodesStack.Free;
    ALowIndex.Free;
    ALowLink.Free;
    AOnStack.Free;

    AGetAdjacentEdges := nil;
    AAddConnectedComponent := nil;
  end;
end;

{ TdxLayerAssignment }

class function TdxLayerAssignment.GetLayerAssignment(AAcyclicGraph: TdxGraph): TDictionary<TdxDiagramItem, Integer>;
var
  AFeasibleTree: TdxGraph;
begin
  AFeasibleTree := GetFeasibleTree(AAcyclicGraph);
  try
    Result := CalculateNodesLayers(AFeasibleTree);
  finally
    AFeasibleTree.Free;
  end;
end;

class function TdxLayerAssignment.GetFeasibleTree(AAcyclicGraph: TdxGraph): TdxGraph;
var
  ANodesLayers: TDictionary<TdxDiagramItem, Integer>;
begin
  ANodesLayers := InitLayerAssignment(AAcyclicGraph);
  try
    Result := AAcyclicGraph.GetSpanningGraph(TdxGraph.Null, [OutgoingOnly, IncomingOnly],
      function (x: TdxEdge<TdxDiagramItem>): Double
      begin
        Result := ANodesLayers[x.&To] - ANodesLayers[x.From];
      end);
  finally
    ANodesLayers.Free;
  end;
end;

class function TdxLayerAssignment.InitLayerAssignment(AAcyclicGraph: TdxGraph): TDictionary<TdxDiagramItem, Integer>;
var
  AGetAdjacentEdges: TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>;
  ATestAdjacentEdges: TdxAdjacentEdges<TdxDiagramItem>;
  ATestNode: TdxDiagramItem;
  ANodesLayers: TDictionary<TdxDiagramItem, Integer>;
  AActualAssignedNodes, AAssigningNodes: TdxHashSet<TdxDiagramItem>;
  ACurrentLayer: Integer;
  AUpdateActualNode: TProc<TdxHashSet<TdxDiagramItem>>;
  AGetNonAssignedChild: TFunc<TdxHashSet<TdxDiagramItem>>;
  AAssignNodesToLayer: TProc<TdxHashSet<TdxDiagramItem>>;
begin
  ANodesLayers := TDictionary<TdxDiagramItem, Integer>.Create;
  try
    AGetAdjacentEdges := AAcyclicGraph.GetAdjacentEdges();
    ACurrentLayer := 0;

    AActualAssignedNodes := TdxHashSet<TdxDiagramItem>.Create;

    AUpdateActualNode :=
      procedure (AAssignedNodes: TdxHashSet<TdxDiagramItem>)
      var
        ANodes: TArray<TdxDiagramItem>;
        AAdjacentEdges: TdxAdjacentEdges<TdxDiagramItem>;
        AOutgoingEdges: TArray<TdxEdge<TdxDiagramItem>>;
        AEdge: TdxEdge<TdxDiagramItem>;
        AAll: Boolean;
        ANode: TdxDiagramItem;
      begin
        AActualAssignedNodes.Include(AAssignedNodes);
        ANodes := AActualAssignedNodes.ToArray;
        for ANode in ANodes do
        begin
          AAdjacentEdges := AGetAdjacentEdges(ANode);
          try
            AAll := True;
            AOutgoingEdges := AAdjacentEdges.Outgoing;
            for AEdge in AOutgoingEdges do
            begin
              if not ANodesLayers.ContainsKey(AEdge.&To) then
              begin
                AAll := False;
                break;
              end;
            end;
            if AAll then
              AActualAssignedNodes.Exclude(ANode);
          finally
            AAdjacentEdges.Free;
          end;
        end;
      end;
    AGetNonAssignedChild :=
      function (): TdxHashSet<TdxDiagramItem>
      var
        ANode, AChild: TdxDiagramItem;
        AAdjacentEdges, AChildAdjacentEdges: TdxAdjacentEdges<TdxDiagramItem>;
        AOutgoingEdges, AChildIncomingEdges: TArray<TdxEdge<TdxDiagramItem>>;
        AEdge, AChildEdge: TdxEdge<TdxDiagramItem>;
        AAll: Boolean;
      begin
        Result := TdxHashSet<TdxDiagramItem>.Create;
        for ANode in AActualAssignedNodes do
        begin
           AAdjacentEdges := AGetAdjacentEdges(ANode);
           try
             AOutgoingEdges := AAdjacentEdges.Outgoing;
             for AEdge in AOutgoingEdges do
             begin
               AChild := AEdge.&To;
               if not ANodesLayers.ContainsKey(AChild) then
               begin
                 AChildAdjacentEdges := AGetAdjacentEdges(AChild);
                 try
                   AAll := True;
                   AChildIncomingEdges := AChildAdjacentEdges.Incoming;
                   for AChildEdge in AChildIncomingEdges do
                     if not ANodesLayers.ContainsKey(AChildEdge.From) then
                     begin
                       AAll := False;
                       break;
                     end;
                   if AAll then
                     Result.Include(AChild);
                 finally
                   AChildAdjacentEdges.Free;
                 end;
               end;
             end;
           finally
             AAdjacentEdges.Free;
           end;
        end;
      end;
    AAssignNodesToLayer :=
      procedure (ANodes: TdxHashSet<TdxDiagramItem>)
      var
        ANode: TdxDiagramItem;
      begin
        for ANode in ANodes do
          ANodesLayers.AddOrSetValue(ANode, ACurrentLayer);
        Inc(ACurrentLayer);
      end;

    AAssigningNodes := TdxHashSet<TdxDiagramItem>.Create;
    try
      for ATestNode in AAcyclicGraph.Nodes do
      begin
        ATestAdjacentEdges := AGetAdjacentEdges(ATestNode);
        try
          if Length(ATestAdjacentEdges.Incoming) = 0 then
            AAssigningNodes.Include(ATestNode);
        finally
          ATestAdjacentEdges.Free;
        end;
      end;
      AAssignNodesToLayer(AAssigningNodes);
      AUpdateActualNode(AAssigningNodes);
    finally
      AAssigningNodes.Free;
    end;

    while True do
    begin
      AAssigningNodes := AGetNonAssignedChild;
      if AAssigningNodes.Count = 0 then
      begin
        AAssigningNodes.Free;
        Break;
      end;
      AAssignNodesToLayer(AAssigningNodes);
      AUpdateActualNode(AAssigningNodes);
      AAssigningNodes.Free;
    end;
    Result := ANodesLayers;
  finally
    AActualAssignedNodes.Free;
    AGetAdjacentEdges := nil;
    AUpdateActualNode := nil;
    AGetNonAssignedChild := nil;
    AAssignNodesToLayer := nil;
  end;
end;

class function TdxLayerAssignment.CalculateNodesLayers(ASpanningTree: TdxGraph): TDictionary<TdxDiagramItem, Integer>;
var
  ANodesLayers: TDictionary<TdxDiagramItem, Integer>;
  ACurrentLevel, ADelta: Integer;
  AGetAdjacentEdges: TFunc<TdxDiagramItem, TdxAdjacentEdges<TdxDiagramItem>>;
  AValues: TArray<Integer>;
  AKey: TdxDiagramItem;
begin
  ANodesLayers := TDictionary<TdxDiagramItem, Integer>.Create;
  ACurrentLevel := 0;
  AGetAdjacentEdges := ASpanningTree.GetAdjacentEdges();
  TdxGraphOperationsCore.RecursiveSearch<TdxDiagramItem>(
    ASpanningTree.Nodes[0],
      AGetAdjacentEdges,
      TdxRecursiveSearchActions<TdxDiagramItem>.Create(
        procedure (ACurrentNode: TdxDiagramItem)
        begin
          ANodesLayers.AddOrSetValue(ACurrentNode, ACurrentLevel);
        end,
        function (ACurrentNode: TdxDiagramItem): Boolean
        begin
          Result := ANodesLayers.ContainsKey(ACurrentNode);
        end,
        function (ACurrentEdge: TdxEdge<TdxDiagramItem>): Boolean
        begin
          Result := ANodesLayers.ContainsKey(ACurrentEdge.From) and ANodesLayers.ContainsKey(ACurrentEdge.&To);
        end,
        procedure (AOutgoingEdge: TdxEdge<TdxDiagramItem>)
        begin
          ACurrentLevel := ANodesLayers[AOutgoingEdge.From] + 1;
        end,
        nil,
        nil,
        procedure (AIncomingEdge: TdxEdge<TdxDiagramItem>)
        begin
          ACurrentLevel := ANodesLayers[AIncomingEdge.&To] - 1;
        end,
        nil,
        nil)
      );
  AValues := ANodesLayers.Values.ToArray;
  if Length(AValues) > 0 then 
  begin
    ADelta := MinIntValue(AValues);
    for AKey in ANodesLayers.Keys do
      ANodesLayers[AKey] := ANodesLayers[AKey] - ADelta;
  end;
  Result := ANodesLayers;
  AGetAdjacentEdges := nil;
end;

{ TdxNodesOrderer }

class function TdxNodesOrderer.OrderNodes(AAcyclicGraph: TdxGraph; ANodesLayers: TDictionary<TdxDiagramItem, Integer>): TdxGraphInfo;
var
  ACurrentIteration, ABestCrossingCount, ACurrentCrossingCount: Integer;
  AGraphInfo: TdxGraphInfo;
  AOrderedLayers, AOrderedLayersToDestroy: TDictionary<Integer, TList<TdxNodeInfo>>;
  ABestNodesPositions: TDictionary<TdxNodeInfo, Integer>;
  AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>;
  ACurrentOrderMode: TOrderMode;
  AGetCrossingCount: TFunc<TDictionary<Integer, TList<TdxNodeInfo>>, Integer>;
  ANodeInfo: TdxNodeInfo;
begin
  ACurrentIteration := 1;


  AGraphInfo := InitGraphInfo(AAcyclicGraph, ANodesLayers);


  AOrderedLayers := InitOrder(AGraphInfo.NodesInfo);
  try
    ABestNodesPositions := TObjectDictionary<TdxNodeInfo, Integer>.Create([]);
    try
      for ANodeInfo in AGraphInfo.NodesInfo do
        ABestNodesPositions.AddOrSetValue(ANodeInfo, ANodeInfo.Position);

      AGetAdjacentNodes := GetAdjacentNode(AGraphInfo);

      AGetCrossingCount :=
        function (AOrder: TDictionary<Integer, TList<TdxNodeInfo>>): Integer
        begin
          Result := GetCrossingCount(AOrder, AGetAdjacentNodes);
        end;

      ABestCrossingCount := AGetCrossingCount(AOrderedLayers);
      ACurrentOrderMode := TOrderMode.ParentToChildren;

      while (ACurrentIteration < MaxIteration) and (ABestCrossingCount <> 0) do
      begin
        AOrderedLayersToDestroy := AOrderedLayers;
        try
          AOrderedLayers := GetOrderNodes(AOrderedLayers, AGetAdjacentNodes, ACurrentOrderMode);
        finally
          AOrderedLayersToDestroy.Free;
        end;

        ACurrentCrossingCount := AGetCrossingCount(AOrderedLayers);
        if ACurrentCrossingCount < ABestCrossingCount then
        begin
          FreeAndNil(ABestNodesPositions);
          ABestNodesPositions := TDictionary<TdxNodeInfo, Integer>.Create;
          for ANodeInfo in AGraphInfo.NodesInfo do
            ABestNodesPositions.AddOrSetValue(ANodeInfo, ANodeInfo.Position);
          ABestCrossingCount := AGetCrossingCount(AOrderedLayers);
        end;
        if ACurrentOrderMode = TOrderMode.ParentToChildren then
          ACurrentOrderMode := TOrderMode.ChildrenToParent
        else
          ACurrentOrderMode := TOrderMode.ParentToChildren;
        Inc(ACurrentIteration);
      end;
      TEnumerableHelper.ForEach<TdxNodeInfo>(AGraphInfo.NodesInfo,
        procedure (ANodeInfo: TdxNodeInfo)
        begin
          ANodeInfo.UpdatePosition(ABestNodesPositions[ANodeInfo]);
        end);
      Result := AGraphInfo;
    finally
      AOrderedLayers.Free;
    end;
  finally
    FreeAndNil(ABestNodesPositions);
    AGetAdjacentNodes := nil;
    AGetCrossingCount := nil;
  end;
end;

class function TdxNodesOrderer.InitGraphInfo(AAcyclicGraph: TdxGraph; ANodesLayers: TDictionary<TdxDiagramItem, Integer>): TdxGraphInfo;
var
  ACountNodesOnLayer: TdxIntegersDictionary;
  ANodesInfoMap: TDictionary<TdxDiagramItem, TdxNodeInfo>;
  ANodesInfo: TList<TdxNodeInfo>;
  AEdgesInfo: TList<TdxEdgeInfo>;
  ANode: TdxDiagramItem;
  ALayer, APosition, AEdgeSpan, ADelta, ARootLayer: Integer;
  ANodeInfo, ARootNodeInfo, ADummyNodeInfo: TdxNodeInfo;
  AEdge: TdxEdge<TdxDiagramItem>;
begin
  ACountNodesOnLayer := TdxIntegersDictionary.Create;
  ANodesInfoMap := TDictionary<TdxDiagramItem, TdxNodeInfo>.Create;
  ANodesInfo := TList<TdxNodeInfo>.Create;
  AEdgesInfo := TList<TdxEdgeInfo>.Create;
  try
    for ANode in AAcyclicGraph.Nodes do
    begin
      ALayer := ANodesLayers[ANode];
      if not ACountNodesOnLayer.ContainsKey(ALayer) then
        ACountNodesOnLayer.Add(ALayer, 0);

      APosition := ACountNodesOnLayer[ALayer];
      ANodeInfo := TdxNodeInfo.Create(ANode, False, ALayer, APosition);
      ACountNodesOnLayer[ALayer] := APosition + 1;

      ANodesInfoMap.Add(ANode, ANodeInfo);
      ANodesInfo.Add(ANodeInfo);
    end;

    for AEdge in AAcyclicGraph.Edges do
    begin
      AEdgeSpan := ANodesLayers[AEdge.&To] - ANodesLayers[AEdge.From];
      if AEdgeSpan > 1 then
      begin
        ARootNodeInfo := ANodesInfoMap[AEdge.From];
        ARootLayer := ANodesLayers[AEdge.From];
        for ADelta := 1 to AEdgeSpan - 1 do
        begin
          APosition := ACountNodesOnLayer[ARootLayer + ADelta];
          ADummyNodeInfo := TdxNodeInfo.Create(Default(TdxDiagramItem), True, ARootLayer + ADelta, APosition);
          ACountNodesOnLayer[ARootLayer + ADelta] := APosition + 1;

          AEdgesInfo.Add(TdxEdgeInfo.Create(ARootNodeInfo, ADummyNodeInfo));
          ANodesInfo.Add(ADummyNodeInfo);
          ARootNodeInfo := ADummyNodeInfo;
        end;
        AEdgesInfo.Add(TdxEdgeInfo.Create(ARootNodeInfo, ANodesInfoMap[AEdge.&To]));
      end
      else
        AEdgesInfo.Add(TdxEdgeInfo.Create(ANodesInfoMap[AEdge.From], ANodesInfoMap[AEdge.&To]));
    end;

    Result := TdxGraphInfo.Create(ANodesInfo, AEdgesInfo);
  finally
    ACountNodesOnLayer.Free;
    ANodesInfoMap.Free;
    ANodesInfo.Free;
    AEdgesInfo.Free;
  end;
end;

class function TdxNodesOrderer.InitOrder(const ANodesInfo: TList<TdxNodeInfo>): TDictionary<Integer, TList<TdxNodeInfo>>;
var
  ANodeInfos: TArray<TdxNodeInfo>;
  APrevLayer, ALayer, I: Integer;
  AList: TList<TdxNodeInfo>;
begin
  ANodeInfos := ANodesInfo.ToArray;
  Result := TObjectDictionary<Integer, TList<TdxNodeInfo>>.Create([doOwnsValues], Length(ANodeInfos));
  if Length(ANodeInfos) > 0 then
  begin
    TArray.Sort<TdxNodeInfo>(ANodeInfos, TComparer<TdxNodeInfo>.Construct(
      function (const Left, Right: TdxNodeInfo): Integer
      begin
        Result := Left.Layer - Right.Layer;
      end));
    APrevLayer := ANodeInfos[0].Layer;
    AList := TList<TdxNodeInfo>.Create;    //TObjectList???
    AList.Add(ANodeInfos[0]);
    Result.Add(APrevLayer, AList);
    for I := Low(ANodeInfos) + 1 to High(ANodeInfos) do
    begin
      ALayer := ANodeInfos[I].Layer;
      if ALayer <> APrevLayer then
      begin
        APrevLayer := ALayer;
        AList := TList<TdxNodeInfo>.Create;
        Result.Add(APrevLayer, AList);
      end;
      AList.Add(ANodeInfos[I]);
    end;
    for AList in Result.Values do
      AList.Sort(
        TComparer<TdxNodeInfo>.Construct(
          function (const Left, Right: TdxNodeInfo): Integer
          begin
            Result := Left.Position - Right.Position;
          end));
  end;
end;

class function TdxNodesOrderer.GetAdjacentNode(AGraphInfo: TdxGraphInfo): TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>;
var
  AChildren, AParents: TdxSmartPointer<TDictionary<TdxNodeInfo, TList<TdxNodeInfo>>>;
begin
  AChildren := TEnumerableHelper.ToGroupsDictionary<TdxEdgeInfo, TdxNodeInfo, TdxNodeInfo>(
    AGraphInfo.EdgesInfo,
    function (X: TdxEdgeInfo): TdxNodeInfo
    begin
      Result := X.From;
    end,
    function (X: TList<TdxEdgeInfo>): TList<TdxNodeInfo>
    var
      AEdge: TdxEdgeInfo;
    begin
      Result := TList<TdxNodeInfo>.Create;
      Result.Capacity := X.Capacity;
      for AEdge in X do
        Result.Add(AEdge.&To);
    end);
  AParents := TEnumerableHelper.ToGroupsDictionary<TdxEdgeInfo, TdxNodeInfo, TdxNodeInfo>(
    AGraphInfo.EdgesInfo,
    function (X: TdxEdgeInfo): TdxNodeInfo
    begin
      Result := X.&To;
    end,
    function (X: TList<TdxEdgeInfo>): TList<TdxNodeInfo>
    var
      AEdge: TdxEdgeInfo;
    begin
      Result := TList<TdxNodeInfo>.Create;
      Result.Capacity := X.Capacity;
      for AEdge in X do
        Result.Add(AEdge.From);
    end);
  Result :=
    function (ANode: TdxNodeInfo): TdxTuple<TdxNodeInfo>
    var
      AFirst, ASecond: TList<TdxNodeInfo>;
    begin
      if not AParents.Value.TryGetValue(ANode, AFirst) then
        AFirst := nil;
      if not AChildren.Value.TryGetValue(ANode, ASecond) then
        ASecond := nil;
      Result := TdxTuple<TdxNodeInfo>.Create(AFirst, ASecond);
    end;
end;

class function TdxNodesOrderer.GetOrderNodes(ALayers: TDictionary<Integer, TList<TdxNodeInfo>>;
  const AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>; AOrderMode: TOrderMode): TDictionary<Integer, TList<TdxNodeInfo>>;
var
  AOrderedLayers: TDictionary<Integer, TList<TdxNodeInfo>>;
  AOrderLayer: TProc<Integer>;
  ALayer: Integer;
begin
  //Ordering nodes by Medians Methods
  AOrderedLayers := TObjectDictionary<Integer, TList<TdxNodeInfo>>.Create([doOwnsValues]);
  AOrderLayer :=
    procedure (ACurrentLayer: Integer)
    var
      ANewNodesPosition: TDictionary<TdxNodeInfo, Integer>;
    begin
      ANewNodesPosition := TDictionary<TdxNodeInfo, Integer>.Create;
      try
        TEnumerableHelper.ForEach<TdxNodeInfo>(ALayers[ACurrentLayer],
          procedure (ANode: TdxNodeInfo)
          var
            AAdjacentNodesPositions: TList<Integer>;
          begin
            AAdjacentNodesPositions := GetAdjacentNodesPositions(ANode, AOrderMode, AGetAdjacentNodes);
            try
              ANewNodesPosition.Add(ANode, GetNodePosition(AAdjacentNodesPositions));
            finally
              AAdjacentNodesPositions.Free;
            end;
          end);
        AOrderedLayers.AddOrSetValue(ACurrentLayer, SortNodes(ANewNodesPosition));
      finally
        ANewNodesPosition.Free;
      end;
    end;
  for ALayer := 0 to ALayers.Count - 1 do
    AOrderLayer(ALayer);
  Result := AOrderedLayers;
  AOrderLayer := nil;
end;

class function TdxNodesOrderer.SortNodes(ANodesPosition: TDictionary<TdxNodeInfo, Integer>): TList<TdxNodeInfo>;
var
  APairs: TArray<TPair<TdxNodeInfo, Integer>>;
  I: Integer;
  AItem: TdxNodeInfo;
begin
  APairs := ANodesPosition.ToArray;

  TArray.Sort<TPair<TdxNodeInfo, Integer>>(APairs, TComparer<TPair<TdxNodeInfo, Integer>>.Construct(
    function (const Left, Right: TPair<TdxNodeInfo, Integer>): Integer
    begin
      Result := Left.Value - Right.Value;
      if Result = 0 then
        Result := Left.Key.Position - Right.Key.Position;
    end));

  Result := TList<TdxNodeInfo>.Create;
  Result.Capacity := Length(APairs);
  for I := Low(APairs) to High(APairs) do
  begin
    AItem := APairs[I].Key;
    AItem.UpdatePosition(I);
    Result.Add(AItem);
  end;
end;

class function TdxNodesOrderer.GetNodePosition(AAdjacentNodesPositions: TList<Integer>): Integer;
var
  AMedianIndex: Integer;
  ALeftMedianPosition, ARightMedianPosition: Double;
begin
  if AAdjacentNodesPositions.Count = 0 then
    Exit(0);

  AAdjacentNodesPositions.Sort;

  if (AAdjacentNodesPositions.Count = 2) or (AAdjacentNodesPositions.Count mod 2 = 1) then
    Exit(AAdjacentNodesPositions[AAdjacentNodesPositions.Count div 2]);

  AMedianIndex := AAdjacentNodesPositions.Count div 2;
  ALeftMedianPosition := AAdjacentNodesPositions[AMedianIndex - 1] - AAdjacentNodesPositions.First;
  ARightMedianPosition := AAdjacentNodesPositions.Last - AAdjacentNodesPositions[AMedianIndex];

  Result := Trunc((AAdjacentNodesPositions[AMedianIndex - 1] * ARightMedianPosition +
    AAdjacentNodesPositions[AMedianIndex] * ALeftMedianPosition) / (ALeftMedianPosition + ARightMedianPosition));
end;

class function TdxNodesOrderer.GetAdjacentNodesPositions(ANodesInfo: TdxNodeInfo; AOrderMode: TOrderMode;
  const AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>): TList<Integer>;
var
  ANode: TdxTuple<TdxNodeInfo>;
  AItem: TdxNodeInfo;
begin
  ANode := AGetAdjacentNodes(ANodesInfo);
  try
    Result := TList<Integer>.Create;
    if AOrderMode = TOrderMode.ChildrenToParent then
    begin
      Result.Capacity := ANode.First.Count;
      for AItem in ANode.First do
        Result.Add(AItem.Position);
    end
    else
    begin
      Result.Capacity := ANode.Second.Count;
      for AItem in ANode.Second do
        Result.Add(AItem.Position);
    end;
  finally
    ANode.Free;
  end;
end;

class function TdxNodesOrderer.GetLayerCrossingCount(
  ALayer: TList<TdxNodeInfo>; const AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>): Integer;
var
  AViewedAdjacentNodesPositions: TList<Integer>;
  ACrossCount: Integer;
begin
  ACrossCount := 0;
  AViewedAdjacentNodesPositions := TList<Integer>.Create;
  try
    TEnumerableHelper.ForEach<TdxNodeInfo>(ALayer,
      procedure (ANode: TdxNodeInfo)
      var
        AAdjacentNodesPositions: TList<Integer>;
      begin
        AAdjacentNodesPositions := GetAdjacentNodesPositions(ANode, TOrderMode.ParentToChildren, AGetAdjacentNodes);
        try
          TEnumerableHelper.ForEach<Integer>(AAdjacentNodesPositions,
            procedure (APosition: Integer)
            var
              AViewedPosition: Integer;
            begin
              for AViewedPosition in AViewedAdjacentNodesPositions do
                if APosition < AViewedPosition then
                  Inc(ACrossCount);
            end);
          AViewedAdjacentNodesPositions.AddRange(AAdjacentNodesPositions);
        finally
          AAdjacentNodesPositions.Free;
        end;
      end);
  finally
    AViewedAdjacentNodesPositions.Free;
  end;
  Result := ACrossCount;
end;

class function TdxNodesOrderer.GetCrossingCount(ALayers: TDictionary<Integer, TList<TdxNodeInfo>>;
  const AGetAdjacentNodes: TFunc<TdxNodeInfo, TdxTuple<TdxNodeInfo>>): Integer;
var
  ALayer: Integer;
begin
  Result := 0;
  for ALayer := 0 to ALayers.Count - 1 do
    Inc(Result, GetLayerCrossingCount(ALayers[ALayer], AGetAdjacentNodes));
end;

{ TdxSugiyamaLayout }

{$WARNINGS OFF}
class function TdxSugiyamaLayout.LayoutGraph(AGraph: TdxGraph;
  ALayoutSteps: TdxSugiyamaLayoutAlgorithm): TdxSugiyamaPositionsInfo;
var
  ADisconnectedGraphs: TList<TdxGraphInfo>;
  AConnectedComponent, AAcyclicConnectedComponent: TdxGraph;
  AConnectedComponents: TList<TdxGraph>;
  ALayerAssignment: TDictionary<TdxDiagramItem, Integer>;
begin
  ADisconnectedGraphs := TObjectList<TdxGraphInfo>.Create;
  try
    AConnectedComponents := AGraph.GetConnectedComponents;
    try
      for AConnectedComponent in AConnectedComponents do
      begin
        AAcyclicConnectedComponent := ALayoutSteps.CycleRemoval(AConnectedComponent);
        try
          if (TdxSugiyamaLayoutCheck.AllCyclesRemoved in ALayoutSteps.Checks) and not AAcyclicConnectedComponent.IsAcyclic then
            raise Exception.Create('The '#$27'Cycle Removal'#$27' step should result in deleting all cycles in the graph');
          if (TdxSugiyamaLayoutCheck.SingleConnectedComponent in ALayoutSteps.Checks) and (AAcyclicConnectedComponent.GetConnectedComponents.Count <> 1) then
            raise Exception.Create('Input graph in the '#$27'Layer Assignment'#$27' step should have only a single connected component');

          ALayerAssignment := ALayoutSteps.LayerAssignment(AAcyclicConnectedComponent);
          try

            ADisconnectedGraphs.Add(ALayoutSteps.NodesOrdering(AAcyclicConnectedComponent, ALayerAssignment));
          finally
            ALayerAssignment.Free;
          end;
        finally
          AAcyclicConnectedComponent.Free;
        end;
      end;
      Result := ALayoutSteps.CoordinateAssignment(ADisconnectedGraphs);
    finally
      AConnectedComponents.Free;
    end;
  finally
    ADisconnectedGraphs.Free;
  end;
end;
{$WARNINGS ON}

{ TdxLayoutInfo<T> }

constructor TdxLayoutInfo.Create(const APositions: TArray<TdxPositionInfo>; const ATotalSize: TdxSizeDouble);
begin
  FPositions := APositions;
  FTotalSize := ATotalSize;
end;

class function TdxLayoutInfo.GetEmpty: TdxLayoutInfo;
begin
  Result := TdxLayoutInfo.Create(nil, TdxSizeDouble.Null);
end;

{ TdxSugiyamaLayoutInfo }

constructor TdxSugiyamaLayoutInfo.Create(APositionsInfo: TdxLayoutInfo;
  ADummyEdgesRoutes: TdxEdgeDictionary<TdxDiagramItem, TArray<TdxPointDouble>>);
begin
  FLayoutInfo := APositionsInfo;
  FDummyEdgesRoutes := ADummyEdgesRoutes;
end;

destructor TdxSugiyamaLayoutInfo.Destroy;
begin
  FLayoutInfo.Free;
  FDummyEdgesRoutes.Free;
  inherited Destroy;
end;


end.
