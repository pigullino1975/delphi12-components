{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEditors                                           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
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

unit dxTreeView;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, Classes, Controls, Generics.Collections, Generics.Defaults, Graphics, ImgList, Forms, StdCtrls,
  Messages, SysUtils, StrUtils, ComCtrls,
  dxCore, dxCoreClasses, dxCustomTree, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxGraphics, cxGeometry,
  cxClasses, dxCoreGraphics, dxInplaceEditing, dxIncrementalSearch, dxTypeHelpers, cxAccessibility;

type
  TdxTreeViewHitTest = class;
  TdxTreeViewCustomOptionsBehavior = class;
  TdxTreeViewCustomOptionsSelection = class;
  TdxTreeViewCustomOptionsView = class;
  TdxTreeViewViewInfo = class;
  TdxTreeViewNodeViewInfo = class;
  TdxTreeViewNode = class;
  TdxTreeViewPainter = class;
  TdxCustomTreeView = class;
  TdxTreeViewNodes = class;
  EdxTreeViewException = class(EdxException);

  { TdxTreeViewPersistent }

  TdxTreeViewPersistent = class(TPersistent)
  strict private
    FTreeView: TdxCustomTreeView;
  protected
    property TreeView: TdxCustomTreeView read FTreeView;
  public
    constructor Create(ATreeView: TdxCustomTreeView); virtual;
  end;

  TdxTreeViewChange = (tvcContent, tvcLayout, tvcStructure, tvcViewPort); // for internal use
  TdxTreeViewChanges = set of TdxTreeViewChange; // for internal use
  TdxTreeViewNodeCompareProc = function(ANode1, ANode2: TdxTreeViewNode; AData: TdxNativeInt): Integer;

  { TdxTreeViewNodeExpandCollapseProvider }

  TdxTreeViewNodeExpandCollapseProvider = class(TdxExpandCollapseProvider) // for internal use
  strict private
    FNode: TdxTreeViewNode;
  protected
    procedure Collapse; override;
    procedure Expand; override;
    function GetExpandCollapseState: Integer; override;
  public
    constructor Create(ANode: TdxTreeViewNode);
  end;

  { TdxTreeViewNodeAccessibilityHelper }

  TdxTreeViewNodeAccessibilityHelper = class(TcxAccessibilityHelper) // for internal use
  strict private
    FExpandCollapseProvider : TdxTreeViewNodeExpandCollapseProvider;

    function GetNode: TdxTreeViewNode;
  protected
    FLocalId: Integer;

    function ChildIsSimpleElement(AIndex: Integer): Boolean; override;
    procedure DoSelect(AFlags: Integer; AChildID: TcxAccessibleSimpleChildElementID); override;
    function GetChild(AIndex: Integer): TcxAccessibilityHelper; override;
    function GetChildCount: Integer; override;
    function GetLocalId(AChildID: TcxAccessibleSimpleChildElementID = 0): Integer; override;
    function GetName(AChildID: TcxAccessibleSimpleChildElementID): string; override;
    function GetParent: TcxAccessibilityHelper; override;
    function GetRole(AChildID: TcxAccessibleSimpleChildElementID): Integer; override;
    function GetState(AChildID: TcxAccessibleSimpleChildElementID): Integer; override;
    function GetSupportedProperties(AChildID: TcxAccessibleSimpleChildElementID): TcxAccessibleObjectProperties; override;
    function IsExtended: Boolean; override;
    function IsSupportedPattern(APatternID: Integer; out AProvider: IUnknown; AChildID: TcxAccessibleSimpleChildElementID = 0): Boolean; override;
    procedure OwnerObjectDestroyed; override;

    property Node: TdxTreeViewNode read GetNode;
  public
    constructor Create(AOwnerObject: TObject); override;
    destructor Destroy; override;

    function GetScreenBounds(AChildID: TcxAccessibleSimpleChildElementID): TRect; override;
  end;

  { TdxTreeViewNode }

  TdxTreeViewNode = class(TdxTreeCustomNode)
  strict private
    FCaption: string;
    FCheckState: TcxCheckBoxState;
    FCut: Boolean;
    FEnabled: Boolean;
    FExpandedImageIndex: Integer;
    FHideCheckBox: Boolean;
    FIAccessibilityHelper: IcxAccessibilityHelper;
    FOverlayImageIndex: Integer;
    FSelectedImageIndex: Integer;
    FStateImageIndex: Integer;

    procedure DoExpand(AExpand: Boolean; ARecurse: Boolean);
    function GetAbsoluteIndex: Integer;
    function GetChecked: Boolean;
    function GetDeleting: Boolean;
    function GetDropTarget: Boolean;
    function GetFirst: TdxTreeViewNode; inline;
    function GetFocused: Boolean; inline;
    function GetIAccessibilityHelper: IcxAccessibilityHelper;
    function GetIsVisible: Boolean;
    function GetItem(Index: Integer): TdxTreeViewNode; inline;
    function GetLast: TdxTreeViewNode; inline;
    function InternalGetNext: TdxTreeViewNode; inline;
    function GetParent: TdxTreeViewNode; inline;
    function InternalGetPrev: TdxTreeViewNode; inline;
    function GetRoot: TdxTreeViewNode; inline;
    function GetSelected: Boolean; inline;
    function GetTreeView: TdxCustomTreeView; inline;
    function GetVisibleIndex: Integer;
    procedure SetCaption(const AValue: string);
    procedure SetChecked(AValue: Boolean);
    procedure SetCheckState(AValue: TcxCheckBoxState);
    procedure SetCut(AValue: Boolean);
    procedure SetDropTarget(AValue: Boolean);
    procedure SetEnabled(AValue: Boolean);
    procedure SetExpandedImageIndex(AValue: Integer);
    procedure SetFocused(AValue: Boolean);
    procedure SetHideCheckBox(AValue: Boolean);
    procedure SetOverlayImageIndex(AValue: Integer);
    procedure SetSelected(AValue: Boolean);
    procedure SetSelectedImageIndex(AValue: Integer);
    procedure SetStateImageIndex(AValue: Integer);
  private
    FAbsoluteIndex: Integer;
    FGroupIndex: Integer;
  protected
    procedure Added(ANode: TdxTreeCustomNode); override;
    procedure AssignFromNode(ASource: TTreeNode); virtual;
    procedure DataChanged; override;
    procedure DoNodeExpandStateChanged; override;
    function GetDefaultImageIndexValue: Integer; override;
    function GetDefaultState: TdxTreeNodeStates; override;
    function GetHintText: string; virtual;
    function GetVisibleLevel: Integer;
    function IsHidden: Boolean;
    procedure ReadData(AStream: TStream; const AVersion: Cardinal = 0); override;
    procedure WriteData(AStream: TStream); override;

    property IAccessibilityHelper: IcxAccessibilityHelper read GetIAccessibilityHelper;
  public
    constructor Create(AOwner: IdxTreeOwner); override;
    destructor Destroy; override;
    //
    function AddChild(ACaption: string = ''; AData: Pointer = nil): TdxTreeViewNode; inline;
    function AddChildFirst(ACaption: string = ''; AData: Pointer = nil): TdxTreeViewNode; inline;
    function AddNode(ANode, ARelative: TdxTreeViewNode; AData: Pointer;
      AttachMode: TdxTreeNodeAttachMode): TdxTreeViewNode; inline;
    procedure AlphaSort(ARecurse: Boolean = False);
    procedure Assign(ASource: TdxTreeCustomNode); override;
    procedure Collapse(ARecurse: Boolean = False);
    function CustomSort(ACompareProc: TdxTreeViewNodeCompareProc; AData: TdxNativeInt; ARecurse: Boolean = False): Boolean;
    procedure DeleteChildren; override;
    function DisplayRect(TextOnly: Boolean): TRect;
    function EditCaption: Boolean;
    procedure EndEdit(ACancel: Boolean);
    procedure Expand(ARecurse: Boolean = False);
    function GetNext: TdxTreeViewNode;
    function GetPrev: TdxTreeViewNode;
    procedure Invalidate;
    procedure MakeVisible;
    //
    property AbsoluteIndex: Integer read GetAbsoluteIndex;
    property Caption: string read FCaption write SetCaption;
    property Checked: Boolean read GetChecked write SetChecked;
    property CheckState: TcxCheckBoxState read FCheckState write SetCheckState;
    property Cut: Boolean read FCut write SetCut;
    property Deleting: Boolean read GetDeleting;
    property DropTarget: Boolean read GetDropTarget write SetDropTarget;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property ExpandedImageIndex: Integer read FExpandedImageIndex write SetExpandedImageIndex;
    property Focused: Boolean read GetFocused write SetFocused;
    property HideCheckBox: Boolean read FHideCheckBox write SetHideCheckBox;
    property IsVisible: Boolean read GetIsVisible;
    property Items[Index: Integer]: TdxTreeViewNode read GetItem; default; // for internal use
    property First: TdxTreeViewNode read GetFirst; // for internal use
    property Last: TdxTreeViewNode read GetLast; // for internal use
    property Next: TdxTreeViewNode read InternalGetNext; // for internal use
    property OverlayImageIndex: Integer read FOverlayImageIndex write SetOverlayImageIndex;
    property Parent: TdxTreeViewNode read GetParent; // for internal use
    property Prev: TdxTreeViewNode read InternalGetPrev; // for internal use
    property Root: TdxTreeViewNode read GetRoot; // for internal use
    property Selected: Boolean read GetSelected write SetSelected;
    property SelectedImageIndex: Integer read FSelectedImageIndex write SetSelectedImageIndex;
    property StateImageIndex: Integer read FStateImageIndex write SetStateImageIndex;
    property TreeView: TdxCustomTreeView read GetTreeView; // for internal use
    property VisibleIndex: Integer read GetVisibleIndex;
  end;
  TdxTreeViewNodeClass = class of TdxTreeViewNode;

  TdxTreeViewNodesEnumerator = class // for internal use
  private
    FIndex: Integer;
    FTreeNodes: TdxTreeViewNodes;
  public
    constructor Create(ATreeNodes: TdxTreeViewNodes);
    function GetCurrent: TdxTreeViewNode;
    function MoveNext: Boolean;
    property Current: TdxTreeViewNode read GetCurrent;
  end;

  TdxTreeViewNodes = class(TdxTreeViewPersistent)  
  strict private
    function GetCount: Integer;
    function GetHandle: HWND;
    function GetItem(Index: Integer): TdxTreeViewNode;
    function GetRoot: TdxTreeViewNode;
  protected
    property Root: TdxTreeViewNode read GetRoot;
  public
    function AddChildFirst(AParent: TdxTreeViewNode; const S: string): TdxTreeViewNode;
    function AddChild(AParent: TdxTreeViewNode; const S: string): TdxTreeViewNode;
    function AddChildObjectFirst(AParent: TdxTreeViewNode; const S: string;
      AData: Pointer): TdxTreeViewNode;
    function AddChildObject(AParent: TdxTreeViewNode; const S: string;
      AData: Pointer): TdxTreeViewNode;
    function AddObjectFirst(ASibling: TdxTreeViewNode; const S: string;
      AData: Pointer): TdxTreeViewNode;
    function AddObject(ASibling: TdxTreeViewNode; const S: string;
      AData: Pointer): TdxTreeViewNode;
    function AddNode(ANode, ARelative: TdxTreeViewNode; const S: string; AData: Pointer; AttachMode: TdxTreeNodeAttachMode): TdxTreeViewNode;
    function AddFirst(ASibling: TdxTreeViewNode; const S: string): TdxTreeViewNode;
    function Add(ASibling: TdxTreeViewNode; const S: string): TdxTreeViewNode;
    function AlphaSort(ARecurse: Boolean = False): Boolean;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure Clear;
    procedure Delete(ANode: TdxTreeViewNode);
    procedure EndUpdate;
    function GetFirstNode: TdxTreeViewNode;
    function GetEnumerator: TdxTreeViewNodesEnumerator; // for internal use
    function Insert(ASibling: TdxTreeViewNode; const S: string): TdxTreeViewNode;
    function InsertObject(ASibling: TdxTreeViewNode; const S: string;
      AData: Pointer): TdxTreeViewNode;
    function InsertNode(ANode, ASibling: TdxTreeViewNode; const S: string; AData: Pointer): TdxTreeViewNode;
    function CustomSort(ASortProc: TdxTreeViewNodeCompareProc; AData: NativeInt; ARecurse: Boolean = True): Boolean;
    property Count: Integer read GetCount;
    property Handle: HWND read GetHandle;
    property Item[Index: Integer]: TdxTreeViewNode read GetItem; default;
  end;

  { TdxCustomTreeViewHintHelper }

  TdxCustomTreeViewHintHelper = class(TcxControlHintHelper) // for internal use
  strict private
    FIsTextTruncated: Boolean;
    FTreeView: TdxCustomTreeView;
  protected
    procedure CorrectHintWindowRect(var ARect: TRect); override;
    procedure DoShowHint(const AHintAreaBounds, ATextRect: TRect; const AText: string);
    function GetOwnerControl: TcxControl; override;
    function PtInCaller(const P: TPoint): Boolean; override;
  public
    constructor Create(ATreeView: TdxCustomTreeView); virtual;

    procedure CheckHint; virtual;

    property TreeView: TdxCustomTreeView read FTreeView;
  end;

  TdxTreeViewIncrementalSearchController = class(TdxIncrementalSearchController)
  strict private
    FTreeView: TdxCustomTreeView;
  protected
    function FocusNextItemWithText(const AText: string): Boolean; override;
  public
    constructor Create(ATreeView: TdxCustomTreeView);
  end;

  TdxTreeViewInplaceEditingController = class(TdxInplaceEditingController) // for internal use
  strict private
    FTreeView: TdxCustomTreeView;
  protected
    procedure InplaceEditKeyPress(Sender: TObject; var AKey: Char); override;
    procedure StartItemCaptionEditing; override;
  public
    constructor Create(ATreeView: TdxCustomTreeView);
  end;

  TdxCustomTreeViewDragObject = class(TcxDragControlObject) // for internal use
  strict private
    FAutoScrollHelper: TdxAutoScrollHelper;
    function GetTreeView: TdxCustomTreeView;
  protected
    function CreateAutoScrollHelper: TdxAutoScrollHelper; virtual;
    property TreeView: TdxCustomTreeView read GetTreeView;
  public
    constructor Create(AControl: TControl); override;
    destructor Destroy; override;
    property AutoScrollHelper: TdxAutoScrollHelper read FAutoScrollHelper;
  end;

  { TdxTreeViewAccessibilityHelper }

  TdxTreeViewAccessibilityHelper = class(TcxAccessibilityHelper) // for internal use
  strict private
    function GetTreeView: TdxCustomTreeView;
  protected
    function ChildIsSimpleElement(AIndex: Integer): Boolean; override;
    function GetChild(AIndex: Integer): TcxAccessibilityHelper; override;
    function GetChildCount: Integer; override;
    function GetHitTest(AScreenX: Integer; AScreenY: Integer; out AIAccessibilityHelper: IcxAccessibilityHelper): Boolean; override;
    function GetOwnerObjectWindow: HWND; override;
    function GetRole(AChildID: TcxAccessibleSimpleChildElementID): Integer; override;
    function GetState(AChildID: TcxAccessibleSimpleChildElementID): Integer; override;
    function GetSupportedProperties(AChildID: TcxAccessibleSimpleChildElementID): TcxAccessibleObjectProperties; override;
    function IsExtended: Boolean; override;

    property TreeView: TdxCustomTreeView read GetTreeView;
  public
    function GetScreenBounds(AChildID: TcxAccessibleSimpleChildElementID): TRect; override;
  end;

  { TdxCustomTreeView }

  TdxTreeViewCustomDrawEvent = procedure (Sender: TdxCustomTreeView;
    ACanvas: TcxCanvas; AViewInfo: TdxTreeViewViewInfo; var AHandled: Boolean) of object;
  TdxTreeViewCustomDrawNodeEvent = procedure (Sender: TdxCustomTreeView;
    ACanvas: TcxCanvas; ANodeViewInfo: TdxTreeViewNodeViewInfo; var AHandled: Boolean) of object;
  TdxTreeViewNodeTextEvent = procedure(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var AText: string) of object;
  TdxTreeViewGetImageIndexEvent = procedure(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var AImageIndex: Integer) of object;
  TdxTreeViewNodeAllowEvent = procedure (Sender: TdxCustomTreeView; ANode: TdxTreeViewNode; var Allow: Boolean) of object;
  TdxTreeViewNodeCompareEvent = procedure(Sender: TdxCustomTreeView; ANode1, ANode2: TdxTreeViewNode; AData: TdxNativeInt; var ACompare: Integer) of object;
  TdxTreeViewNodeEvent = procedure (Sender: TdxCustomTreeView; ANode: TdxTreeViewNode) of object;

  TdxCustomTreeView = class(TcxControl, IdxTreeOwner, IdxInplaceEditContainer, IdxSkinSupport)
  strict private const
    dxDefaultHeight = 200;
    dxDefaultWidth = 100;
  strict private type
    TMakeVisibleMode = (mvmMakeVisible, mvmMakeTop, mvmJustExpanded);
    TMakeVisibleNode = record
      Item: TdxTreeViewNode;
      Mode: TMakeVisibleMode;
    end;
    TdxTreeViewAddNodeFunc = reference to function: TdxTreeViewNode;
  strict private
    FAbsoluteNodes: TdxFastList;
    FAbsoluteVisibleNodes: TdxFastList;
    FAccessibleObjects: TList<TcxAccessibilityHelper>;
    FChangeDelayTimer: TcxTimer;
    FChanges: TdxTreeViewChanges;
    FDropTarget: TdxTreeViewNode;
    FEditingItem: TdxTreeViewNode;
    FEncoding: TEncoding;
    FFocusedNode: TdxTreeViewNode;
    FFocusNodeOnMouseUp: Boolean;
    FHighlightedText: string;
    FHintHelper: TdxCustomTreeViewHintHelper;
    FHitTest: TdxTreeViewHitTest;
    FHottrackItem: TdxTreeViewNode;
    FIAccessibilityHelper: IcxAccessibilityHelper;
    FImages: TCustomImageList;
    FImagesChangeLink: TChangeLink;
    FIncrementalSearchController: TdxTreeViewIncrementalSearchController;
    FInplaceEditingController: TdxTreeViewInplaceEditingController;
    FIsAbsoluteNodesValid: Boolean;
    FIsAbsoluteVisibleNodesValid: Boolean;
    FNodeAdditionEventLockCount: Integer;
    FIsSelectionChanged: Boolean;
    FItems: TdxTreeViewNodes;
    FLockCount: Integer;
    FLockSelectionCount: Integer;
    FMakeVisibleNode: TMakeVisibleNode;
    FOptionsBehavior: TdxTreeViewCustomOptionsBehavior;
    FOptionsSelection: TdxTreeViewCustomOptionsSelection;
    FOptionsView: TdxTreeViewCustomOptionsView;
    FPainter: TdxTreeViewPainter;
    FPressedItem: TdxTreeViewNode;
    FRightClickNode: TdxTreeViewNode;
    FRoot: TdxTreeViewNode;
    FSelectionAnchor: TdxTreeViewNode;
    FSelections: TdxFastList;
    FStateImages: TCustomImageList;
    FStateImagesChangeLink: TChangeLink;
    FUpdateItemsSelectionOnMouseUp: Boolean;
    FViewInfo: TdxTreeViewViewInfo;

    FOnAddition: TdxTreeViewNodeEvent;
    FOnCancelEdit: TdxTreeViewNodeEvent;
    FOnCanFocusNode: TdxTreeViewNodeAllowEvent;
    FOnCanSelectNode: TdxTreeViewNodeAllowEvent;
    FOnCollapsed: TdxTreeViewNodeEvent;
    FOnCollapsing: TdxTreeViewNodeAllowEvent;
    FOnCompare: TdxTreeViewNodeCompareEvent;
    FOnCustomDraw: TdxTreeViewCustomDrawEvent;
    FOnCustomDrawNode: TdxTreeViewCustomDrawNodeEvent;
    FOnDeletion: TdxTreeViewNodeEvent;
    FOnEdited: TdxTreeViewNodeTextEvent;
    FOnEditing: TdxTreeViewNodeAllowEvent;
    FOnExpanded: TdxTreeViewNodeEvent;
    FOnExpanding: TdxTreeViewNodeAllowEvent;
    FOnFocusedNodeChanged: TNotifyEvent;
    FOnGetChildren: TdxTreeViewNodeEvent;
    FOnGetEditingText: TdxTreeViewNodeTextEvent;
    FOnGetImageIndex: TdxTreeViewGetImageIndexEvent;
    FOnGetSelectedImageIndex: TdxTreeViewGetImageIndexEvent;
    FOnHint: TdxTreeViewNodeTextEvent;
    FOnNodeStateChanged: TdxTreeViewNodeEvent;
    FOnSelectionChanged: TNotifyEvent;

    procedure ChangeFocusedNode(ANode: TdxTreeViewNode; AShift: TShiftState);
    function DoAddNodeToSelection(ANode: TdxTreeViewNode; APosition: Integer = -1): Boolean;
    procedure DoChangeDelayTimer(Sender: TObject);
    procedure DoGetImageIndex(ANode: TdxTreeViewNode; var AImageIndex: Integer);
    procedure DoGetSelectedImageIndex(ANode: TdxTreeViewNode; var AImageIndex: Integer);
    procedure DoSelectionOperation(ASelectProc: TProc);
    procedure FinishEditingTimer;
    function GetAbsoluteCount: Integer;
    function GetAbsoluteItem(AIndex: Integer): TdxTreeViewNode;
    function GetAbsoluteVisibleCount: Integer;
    function GetAbsoluteVisibleItem(AIndex: Integer): TdxTreeViewNode;
    function GetIAccessibilityHelper: IcxAccessibilityHelper;
    function GetInplaceEdit: IdxInplaceEdit;
    function GetSelected: TdxTreeViewNode;
    function GetSelectionCount: Integer;
    function GetSelection(Index: Integer): TdxTreeViewNode;
    function GetTopItem: TdxTreeViewNode;
    procedure ImagesChangeHandler(Sender: TObject);
    function IsSelectionChanged(ASelectionBefore, ASelectionAfter: TdxFastList): Boolean;
    procedure SelectionChanged;
    procedure SetDropTarget(ANode: TdxTreeViewNode);
    procedure SetFocusedNode(AValue: TdxTreeViewNode);
    procedure SetHighlightedText(AValue: string);
    procedure SetHottrackItem(AValue: TdxTreeViewNode);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetItems(AValue: TdxTreeViewNodes);
    procedure SetOptionsBehavior(AValue: TdxTreeViewCustomOptionsBehavior);
    procedure SetOptionsSelection(AValue: TdxTreeViewCustomOptionsSelection);
    procedure SetOptionsView(AValue: TdxTreeViewCustomOptionsView);
    procedure SetRightClickNode(AValue: TdxTreeViewNode);
    procedure SetSelected(AValue: TdxTreeViewNode);
    procedure SetStateImages(AValue: TCustomImageList);
    procedure SetTopItem(AValue: TdxTreeViewNode);

    procedure WMGetObject(var Message: TMessage); message WM_GETOBJECT;
  private
    FGroupNodeCounts: TdxIntegerIndexes;
  protected
    //
    procedure AssignNodes(ASource: TTreeNodes);
    procedure AssignFromTreeView(ASource: TTreeView);
    //
    procedure ReadData(AStream: TStream);
    procedure ReadStructure(AStream: TStream; AVersion: Cardinal);
    procedure WriteData(AStream: TStream);
    procedure WriteStructure(AStream: TStream);

    // IdxInplaceEditContainer
    procedure IdxInplaceEditContainer.FinishEditing = FinishNodeCaptionEditing;
    procedure FinishNodeCaptionEditing(AAccept: Boolean = True); virtual;
    function GetEditingControl: TWinControl;
    function GetNodeCaptionTextColor: TColor;
    function IdxInplaceEditContainer.GetTextColor = GetNodeCaptionTextColor;
    procedure ValidatePasteText(var AText: string); virtual;

    // IdxIncrementalSearchOwner
    function FocusNextItemWithText(const AText: string): Boolean;

    procedure Added(ANode: TdxTreeViewNode);
    procedure AddNodeToSelection(ANode: TdxTreeViewNode; APosition: Integer = -1);
    function AllowInfoTips: Boolean; virtual;
    function AllowTouchScrollUIMode: Boolean; override;
    procedure BeginAddNode;
    procedure BoundsChanged; override;
    function CanFocusNode(ANode: TdxTreeViewNode): Boolean;
    function CanSelectNode(ANode: TdxTreeViewNode): Boolean;
    procedure Changed(AChanges: TdxTreeViewChanges);
    procedure ChangeScaleEx(M, D: Integer; isDpiChange: Boolean); override;
    procedure CheckAbsoluteNodes;
    procedure CheckHint;
    function CreateHintHelper: TdxCustomTreeViewHintHelper; virtual;
    function CreateHitTest: TdxTreeViewHitTest; virtual;
    function CreateIncrementalSearchController: TdxTreeViewIncrementalSearchController; virtual;
    function CreateInplaceEditingController: TdxTreeViewInplaceEditingController; virtual;
    function CreateOptionsBehavior: TdxTreeViewCustomOptionsBehavior; virtual;
    function CreateOptionsSelection: TdxTreeViewCustomOptionsSelection; virtual;
    function CreateOptionsView: TdxTreeViewCustomOptionsView; virtual;
    function CreatePainter: TdxTreeViewPainter; virtual;
    function CreateViewInfo: TdxTreeViewViewInfo; virtual;
    procedure DoCancelEdit(ANode: TdxTreeViewNode); virtual;
    procedure DoCancelMode; override;
    function DoCustomDraw(ACanvas: TcxCanvas; AViewInfo: TdxTreeViewViewInfo): Boolean; virtual;
    function DoCustomDrawNode(ACanvas: TcxCanvas; ANodeViewInfo: TdxTreeViewNodeViewInfo): Boolean; virtual;
    procedure DoEdited(ANode: TdxTreeViewNode; var ACaption: string); virtual;
    procedure DoFocusedNodeChanged; virtual;
    procedure DoHint(ANode: TdxTreeViewNode; var AText: string); virtual;
    function DoNodeAddition(AAddNodeFunc: TdxTreeViewAddNodeFunc): TdxTreeViewNode;
    procedure DoNodeExpandStateChanged(ANode: TdxTreeViewNode); virtual; 
    procedure DoPaint; override;
    procedure DoSelect(ANode: TdxTreeViewNode; AShift: TShiftState = []);
    procedure DoSelectionChanged; virtual;
    procedure DoSelectNodeByMouse(ANode: TdxTreeViewNode; AShift: TShiftState; AHitAtCheckBox: Boolean); virtual;
    procedure DoValidateSelection;
    procedure EndAddNode(ANode: TdxTreeViewNode);
    procedure FocusEnter; override;
    procedure FocusLeave; override;
    procedure FontChanged; override;
    function GetDefaultHeight: Integer; virtual;
    function GetDefaultWidth: Integer; virtual;
    function GetImageIndex(ANode: TdxTreeViewNode): Integer;
    function GetMainScrollBarsClass: TcxControlCustomScrollBarsClass; override;
    function GetNodeBounds(ANode: TdxTreeViewNode): TRect;
    function GetNodeClass: TdxTreeViewNodeClass; overload; virtual;
    function GetNodeTextRect(ANode: TdxTreeViewNode): TRect;
    function GetScrollContentForegroundColor: TColor; override;
    function GetSelectedImageIndex(ANode: TdxTreeViewNode): Integer;
    function HasGroups: Boolean; virtual;
    function HasHottrack: Boolean; virtual;
    procedure InitScrollBarsParameters; override;
    procedure InvalidateNode(ANode: TdxTreeViewNode);
    function IsExplorerStyle: Boolean; virtual;
    function IsNodeSelected(ANode: TdxTreeViewNode): Boolean;
    function IsUpdateLocked: Boolean;
    procedure LoadTreeFromStream(AStream: TStream; AEncoding: TEncoding); virtual;
    procedure LookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues); override;
    procedure MultiSelectStyleChanged;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure NodeStateChanged(ANode: TdxTreeViewNode); virtual;
    procedure ProcessChanges(AChanges: TdxTreeViewChanges); virtual;
    procedure SaveTreeToStream(AStream: TStream; AEncoding: TEncoding); virtual;
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer); override;
    procedure SelectVisibleRange(AStartNode, AFinishNode: TdxTreeViewNode);
    function ShowFirstLevelNodes: Boolean; virtual;
    procedure ShowInplaceEdit(ANode: TdxTreeViewNode; const ABounds: TRect; const AText: string; AFont: TFont; ASelStart, ASelLength: Integer; AMaxLength: Integer); virtual;
    procedure SortTypeChanged;
    procedure UpdateAbsoluteVisibleNodes; virtual;
    procedure UpdateChangeDelayTimer;
    procedure UpdateViewPort(const P: TPoint);
    procedure ValidateSelection;
    procedure ViewPortChanged; virtual;

    // Editing
    function AllowActivateEditByMouse: Boolean; virtual;
    function CanEdit(ANode: TdxTreeViewNode): Boolean; virtual;
    procedure Edit(ANode: TdxTreeViewNode; const AText: string); virtual;
    function GetEditingText(ANode: TdxTreeViewNode): string; virtual;
    procedure InplaceEditKeyPress(Sender: TObject; var AKey: Char); virtual;
    function StartItemCaptionEditing(ANode: TdxTreeViewNode): Boolean;

    // Keyboard
    function CheckFocusedObject: Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    // Mouse
    procedure CalculateHitTest(X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    // IdxTreeOwner
    procedure BeforeDelete(Sender: TdxTreeCustomNode); virtual;
    function CanCollapse(Sender: TdxTreeCustomNode): Boolean; virtual;
    function CanExpand(Sender: TdxTreeCustomNode): Boolean; virtual;
    procedure Collapsed(Sender: TdxTreeCustomNode); virtual;
    procedure DeleteNode(Sender: TdxTreeCustomNode); virtual;
    procedure Expanded(Sender: TdxTreeCustomNode); virtual;
    function GetNodeClass(ARelativeNode: TdxTreeCustomNode): TdxTreeCustomNodeClass; overload;
    function GetOwner: TPersistent; reintroduce;
    procedure LoadChildren(Sender: TdxTreeCustomNode);
    procedure TreeNotification(Sender: TdxTreeCustomNode; ANotification: TdxTreeNodeNotifications);

    // delphi drag and drop
    function CanDrag(X, Y: Integer): Boolean; override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure DrawDragImage(ACanvas: TcxCanvas; const R: TRect); override;
    function GetDragImagesSize: TPoint; override;
    function GetDragObjectClass: TDragControlObjectClass; override;
    function HasDragImages: Boolean; override;
    procedure Loaded; override;

    property AbsoluteVisibleNodes: TdxFastList read FAbsoluteVisibleNodes;
    property AccessibleObjects: TList<TcxAccessibilityHelper> read FAccessibleObjects;
    property EditingItem: TdxTreeViewNode read FEditingItem;
    property FocusNodeOnMouseUp: Boolean read FFocusNodeOnMouseUp write FFocusNodeOnMouseUp;
    property HighlightedText: string read FHighlightedText write SetHighlightedText;
    property HintHelper: TdxCustomTreeViewHintHelper read FHintHelper;
    property HitTest: TdxTreeViewHitTest read FHitTest;
    property HottrackItem: TdxTreeViewNode read FHottrackItem write SetHottrackItem;
    property IAccessibilityHelper: IcxAccessibilityHelper read GetIAccessibilityHelper;
    property Images: TCustomImageList read FImages write SetImages;
    property IncrementalSearchController: TdxTreeViewIncrementalSearchController read FIncrementalSearchController;
    property InplaceEdit: IdxInplaceEdit read GetInplaceEdit;
    property OptionsBehavior: TdxTreeViewCustomOptionsBehavior read FOptionsBehavior write SetOptionsBehavior;
    property OptionsSelection: TdxTreeViewCustomOptionsSelection read FOptionsSelection write SetOptionsSelection;
    property OptionsView: TdxTreeViewCustomOptionsView read FOptionsView write SetOptionsView;
    property Painter: TdxTreeViewPainter read FPainter;
    property PressedItem: TdxTreeViewNode read FPressedItem;
    property RightClickNode: TdxTreeViewNode read FRightClickNode write SetRightClickNode;
    property StateImages: TCustomImageList read FStateImages write SetStateImages;
    property ViewInfo: TdxTreeViewViewInfo read FViewInfo;
    property OnAddition: TdxTreeViewNodeEvent read FOnAddition write FOnAddition;
    property OnCancelEdit: TdxTreeViewNodeEvent read FOnCancelEdit write FOnCancelEdit;
    property OnCanFocusNode: TdxTreeViewNodeAllowEvent read FOnCanFocusNode write FOnCanFocusNode;
    property OnCanSelectNode: TdxTreeViewNodeAllowEvent read FOnCanSelectNode write FOnCanSelectNode;
    property OnCollapsed: TdxTreeViewNodeEvent read FOnCollapsed write FOnCollapsed;
    property OnCollapsing: TdxTreeViewNodeAllowEvent read FOnCollapsing write FOnCollapsing;
    property OnCompare: TdxTreeViewNodeCompareEvent read FOnCompare write FOnCompare;
    property OnCustomDraw: TdxTreeViewCustomDrawEvent read FOnCustomDraw write FOnCustomDraw;
    property OnCustomDrawNode: TdxTreeViewCustomDrawNodeEvent read FOnCustomDrawNode write FOnCustomDrawNode;
    property OnDeletion: TdxTreeViewNodeEvent read FOnDeletion write FOnDeletion;
    property OnEdited: TdxTreeViewNodeTextEvent read FOnEdited write FOnEdited;
    property OnEditing: TdxTreeViewNodeAllowEvent read FOnEditing write FOnEditing;
    property OnExpanded: TdxTreeViewNodeEvent read FOnExpanded write FOnExpanded;
    property OnExpanding: TdxTreeViewNodeAllowEvent read FOnExpanding write FOnExpanding;
    property OnFocusedNodeChanged: TNotifyEvent read FOnFocusedNodeChanged write FOnFocusedNodeChanged;
    property OnGetChildren: TdxTreeViewNodeEvent read FOnGetChildren write FOnGetChildren;
    property OnGetEditingText: TdxTreeViewNodeTextEvent read FOnGetEditingText write FOnGetEditingText;
    property OnGetImageIndex: TdxTreeViewGetImageIndexEvent read FOnGetImageIndex write FOnGetImageIndex;
    property OnGetSelectedImageIndex: TdxTreeViewGetImageIndexEvent read FOnGetSelectedImageIndex write FOnGetSelectedImageIndex;
    property OnHint: TdxTreeViewNodeTextEvent read FOnHint write FOnHint;
    property OnNodeStateChanged: TdxTreeViewNodeEvent read FOnNodeStateChanged write FOnNodeStateChanged;
    property OnSelectionChanged: TNotifyEvent read FOnSelectionChanged write FOnSelectionChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AlphaSort(ARecurse: Boolean = True): Boolean;
    procedure BeforeDestruction; override;
    procedure BeginUpdate;
    function CustomSort(ASortProc: TdxTreeViewNodeCompareProc; AData: NativeInt; ARecurse: Boolean = True): Boolean;
    procedure EndEdit(ACancel: Boolean);
    procedure EndUpdate;
    procedure ExpandTo(ANode: TdxTreeViewNode);
    procedure FullCollapse;
    procedure FullExpand;
    procedure FullRefresh;
    function GetNodeAtPos(const P: TPoint; out ANode: TdxTreeViewNode): Boolean;
    function GetHitTestAt(X, Y: Integer): TdxTreeViewHitTest;
    function IsEditing: Boolean;
    procedure MakeVisible(ANode: TdxTreeViewNode);
    procedure ScrollBy(ADeltaX, ADeltaY: Integer);
    // Load\Save
    // txt
    procedure LoadFromFile(const AFileName: string); overload;
    procedure LoadFromFile(const AFileName: string; AEncoding: TEncoding); overload;
    procedure LoadFromStream(AStream: TStream); overload;
    procedure LoadFromStream(AStream: TStream; AEncoding: TEncoding); overload;
    procedure SaveToFile(const AFileName: string); overload;
    procedure SaveToFile(const AFileName: string; AEncoding: TEncoding); overload;
    procedure SaveToStream(AStream: TStream); overload;
    procedure SaveToStream(AStream: TStream; AEncoding: TEncoding); overload;
    // binary data
    procedure LoadDataFromFile(const AFileName: string);
    procedure LoadDataFromStream(AStream: TStream);
    procedure SaveDataToFile(const AFileName: string);
    procedure SaveDataToStream(AStream: TStream);

    // Multiselect
    procedure BeginSelect;
    procedure ClearSelection(AKeepPrimary: Boolean = False);
    procedure Deselect(ANode: TdxTreeViewNode); overload;
    procedure Deselect(const ANodes: array of TdxTreeViewNode); overload;
    procedure Deselect(ANodes: TList); overload;
    procedure EndSelect;
    procedure GetSelectedData(AList: TList);
    function GetSelections(AList: TList): TdxTreeViewNode;
    procedure Select(ANode: TdxTreeViewNode; AShift: TShiftState = []; ASyncFocused: Boolean = True); overload;
    procedure Select(const ANodes: array of TdxTreeViewNode; ASyncFocused: Boolean = True); overload;
    procedure Select(ANodes: TList; ASyncFocused: Boolean = True); overload;
    procedure Subselect(ANode: TdxTreeViewNode; AValidate: Boolean = False);
    //
    property AbsoluteCount: Integer read GetAbsoluteCount;
    property AbsoluteItems[Index: Integer]: TdxTreeViewNode read GetAbsoluteItem;
    property AbsoluteVisibleCount: Integer read GetAbsoluteVisibleCount;
    property AbsoluteVisibleItems[Index: Integer]: TdxTreeViewNode read GetAbsoluteVisibleItem;
    property DropTarget: TdxTreeViewNode read FDropTarget write SetDropTarget;
    property FocusedNode: TdxTreeViewNode read FFocusedNode write SetFocusedNode;
    property Items: TdxTreeViewNodes read FItems write SetItems;
    property Root: TdxTreeViewNode read FRoot;
    property Selected: TdxTreeViewNode read GetSelected write SetSelected;
    property SelectionCount: Integer read GetSelectionCount;
    property Selections[Index: Integer]: TdxTreeViewNode read GetSelection;
    property TopItem: TdxTreeViewNode read GetTopItem write SetTopItem;
  end;

  { TdxTreeViewCustomOptionsView }

  TdxTreeViewCustomOptionsView = class(TdxTreeViewPersistent)
  strict private
    FIndent: Integer;
    FItemHeight: Integer;
    FShowCheckBoxes: Boolean;
    FShowEndEllipsis: Boolean;
    FShowExpandButtons: Boolean;
    FShowLines: Boolean;
    FShowRoot: Boolean;
    FUseImageIndexForExpanded: Boolean;
    FUseImageIndexForSelected: Boolean;

    function GetScrollBars: TcxScrollStyle;
    procedure SetIndent(AValue: Integer);
    procedure SetItemHeight(AValue: Integer);
    procedure SetScrollBars(AValue: TcxScrollStyle);
    procedure SetShowCheckBoxes(AValue: Boolean);
    procedure SetShowEndEllipsis(AValue: Boolean);
    procedure SetShowExpandButtons(AValue: Boolean);
    procedure SetShowLines(AValue: Boolean);
    procedure SetShowRoot(const Value: Boolean);
    procedure SetUseImageIndexForExpanded(const Value: Boolean);
    procedure SetUseImageIndexForSelected(const Value: Boolean);
  protected
    procedure Changed(AChanges: TdxTreeViewChanges);
    procedure ChangeScale(M, D: Integer); virtual;
    function GetDefaultShowEndEllipsis: Boolean; virtual;
  public
    constructor Create(ATreeView: TdxCustomTreeView); override;
    procedure Assign(Source: TPersistent); override;

    property Indent: Integer read FIndent write SetIndent default 19;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property ScrollBars: TcxScrollStyle read GetScrollBars write SetScrollBars;
    property ShowCheckBoxes: Boolean read FShowCheckBoxes write SetShowCheckBoxes;
    property ShowEndEllipsis: Boolean read FShowEndEllipsis write SetShowEndEllipsis;
    property ShowExpandButtons: Boolean read FShowExpandButtons write SetShowExpandButtons;
    property ShowLines: Boolean read FShowLines write SetShowLines;
    property ShowRoot: Boolean read FShowRoot write SetShowRoot;
    property UseImageIndexForExpanded: Boolean read FUseImageIndexForExpanded write SetUseImageIndexForExpanded;
    property UseImageIndexForSelected: Boolean read FUseImageIndexForSelected write SetUseImageIndexForSelected;
  end;

  { TdxTreeViewCustomOptionsBehavior }

  TdxTreeViewCustomOptionsBehavior = class(TdxTreeViewPersistent)
  strict private
    FAutoExpand: Boolean;
    FCaptionEditing: Boolean;
    FChangeDelay: Integer;
    FHotTrack: Boolean;
    FReadOnly: Boolean;
    FSortType: TSortType;
    FToolTips: Boolean;
    procedure SetCaptionEditing(AValue: Boolean);
    procedure SetChangeDelay(AValue: Integer);
    procedure SetSortType(AValue: TSortType);
  public
    constructor Create(ATreeView: TdxCustomTreeView); override;
    procedure Assign(Source: TPersistent); override;
    property AutoExpand: Boolean read FAutoExpand write FAutoExpand default False;
    property CaptionEditing: Boolean read FCaptionEditing write SetCaptionEditing;
    property ChangeDelay: Integer read FChangeDelay write SetChangeDelay;
    property HotTrack: Boolean read FHotTrack write FHotTrack;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property SortType: TSortType read FSortType write SetSortType default stNone;
    property ToolTips: Boolean read FToolTips write FToolTips default True;
  end;

  { TdxTreeViewCustomOptionsSelection }

  TdxTreeViewCustomOptionsSelection = class(TdxTreeViewPersistent)
  strict private
    FRowSelect: Boolean;
    FHideSelection: Boolean;
    FMultiSelect: Boolean;
    FMultiSelectStyle: TMultiSelectStyle;
    FRightClickSelect: Boolean;
    procedure SetHideSelection(AValue: Boolean);
    procedure SetMultiSelect(AValue: Boolean);
    procedure SetMultiSelectStyle(AValue: TMultiSelectStyle);
    procedure SetRowSelect(AValue: Boolean);
  protected
    procedure Changed(AChanges: TdxTreeViewChanges);
    function DefaultHideSelectionValue: Boolean; virtual;
  public
    constructor Create(ATreeView: TdxCustomTreeView); override;
    procedure Assign(Source: TPersistent); override;
    property HideSelection: Boolean read FHideSelection write SetHideSelection;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect;
    property MultiSelectStyle: TMultiSelectStyle read FMultiSelectStyle write SetMultiSelectStyle default [msControlSelect];
    property RightClickSelect: Boolean read FRightClickSelect write FRightClickSelect;
    property RowSelect: Boolean read FRowSelect write SetRowSelect;
  end;

  { TdxTreeViewHitTest }

  TdxTreeViewHitTest = class(TdxTreeViewPersistent)
  strict private
    FHitAtCheckBox: Boolean;
    FHitAtExpandButton: Boolean;
    FHitAtImage: Boolean;
    FHitAtSelection: Boolean;
    FHitAtStateImage: Boolean;
    FHitAtText: Boolean;
    FHitObject: TObject;
    FHitPoint: TPoint;

    function GetHitAtNode: Boolean;
    function GetHitObjectAsNode: TdxTreeViewNode;
  public
    procedure Reset; virtual;

    property HitAtCheckBox: Boolean read FHitAtCheckBox write FHitAtCheckBox;
    property HitAtExpandButton: Boolean read FHitAtExpandButton write FHitAtExpandButton;
    property HitAtImage: Boolean read FHitAtImage write FHitAtImage;
    property HitAtNode: Boolean read GetHitAtNode;
    property HitAtSelection: Boolean read FHitAtSelection write FHitAtSelection;
    property HitAtStateImage: Boolean read FHitAtStateImage write FHitAtStateImage;
    property HitAtText: Boolean read FHitAtText write FHitAtText;
    property HitObject: TObject read FHitObject write FHitObject;
    property HitObjectAsNode: TdxTreeViewNode read GetHitObjectAsNode;
    property HitPoint: TPoint read FHitPoint write FHitPoint;
  end;

  {TdxTreeViewPainter}

  TdxTreeViewPainter = class(TdxTreeViewPersistent)
  strict private
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter; inline;
  protected
    procedure DrawBackground(ACanvas: TcxCanvas; const R: TRect; AViewInfo: TdxTreeViewViewInfo); virtual;
    procedure DrawCheckBox(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); virtual;
    procedure DrawExpandButton(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); overload; virtual;
    procedure DrawNodeCaption(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); virtual;
    procedure DrawNodeFocus(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); virtual;
    procedure DrawNodeImage(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); virtual;
    procedure DrawNodeSelection(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); virtual;
    procedure DrawNodeStateImage(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); virtual;
    procedure DrawTreeLine(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); virtual;

    function GetBackgroundColor: TColor; virtual;
    function GetTextColor(ANodeViewInfo: TdxTreeViewNodeViewInfo): TColor; virtual;

    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter;
  end;

  { TdxTreeViewCustomViewInfo }

  TdxTreeViewCustomViewInfo = class abstract(TdxTreeViewPersistent)
  strict private
    FIsRightToLeftConverted: Boolean;
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter; inline;
    function GetPainter: TdxTreeViewPainter;
    function GetScaleFactor: TdxScaleFactor;
  protected
    FBounds: TRect;
    procedure DoRightToLeftConversion(ABounds: TRect); virtual;
    property IsRightToLeftConverted: Boolean read FIsRightToLeftConverted;
  public
    procedure Calculate(const ABounds: TRect); virtual; // for internal use
    procedure CalculateHitTest(AHitTest: TdxTreeViewHitTest); virtual; abstract; // for internal use
    procedure Draw(ACanvas: TcxCanvas); virtual; abstract; // for internal use
    function IsRowSelect: Boolean; // for internal use
    procedure RightToLeftConversion(ABounds: TRect); // for internal use
    //
    property Bounds: TRect read FBounds;
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter; // for internal use
    property Painter: TdxTreeViewPainter read GetPainter; // for internal use
    property ScaleFactor: TdxScaleFactor read GetScaleFactor; // for internal use
  end;

  { TdxTreeViewNodeViewInfo }

  TdxTreeViewNodeViewInfo = class(TdxTreeViewCustomViewInfo)
  strict private const
    ElementsOffset = 4;
  strict private
    FData: TdxTreeViewNode;
    FImageColorPalette: IdxColorPalette;

    function GetHeight: Integer; inline;
    function GetImages: TCustomImageList; inline;
  protected
    FCheckBoxRect: TRect;
    FExpandButtonRect: TRect;
    FImageRect: TRect;
    FLevelIndent: Integer;
    FImageRects: array [Boolean] of TRect;
    FSelectionRect: TRect;
    FStateImageRects: array [Boolean] of TRect;
    FStateImageRect: TRect;
    FTextRects: array [Boolean] of TRect;
    FTextRect: TRect;
    FTextWidth: Integer;
    FHorizontalTreeLineBounds: TRect;
    FVerticalTreeLineBounds: TRect;
    //
    FTextColor: TColor;

    procedure AdjustTextRect(AFont: TFont = nil); virtual;
    procedure CalculateTreeLines; virtual;
    function GetImageColorPalette(const R: TRect): IdxColorPalette;
    function GetLevelOffset: Integer; virtual;
    function GetState: TdxTreeViewNodeStates;
    procedure DoRightToLeftConversion(ABounds: TRect); override;
    function MeasureHeight(AImageSize, AExpandButtonSize, ACheckHeight, ATextHeight: Integer): Integer; virtual;
  public
    // Draw
    procedure DefaultDraw(ACanvas: TcxCanvas); virtual;
    procedure Draw(ACanvas: TcxCanvas); override;
    procedure DrawCaption(ACanvas: TcxCanvas); virtual;
    procedure DrawCheckBox(ACanvas: TcxCanvas); virtual;
    procedure DrawExpandButton(ACanvas: TcxCanvas); virtual;
    procedure DrawFocus(ACanvas: TcxCanvas); virtual;
    procedure DrawImage(ACanvas: TcxCanvas); virtual;
    procedure DrawSelection(ACanvas: TcxCanvas); virtual;
    procedure DrawStateImage(ACanvas: TcxCanvas); virtual;
    procedure DrawTreeLine(ACanvas: TcxCanvas; const R: TRect);
    procedure DrawTreeLines(ACanvas: TcxCanvas);
    //
    procedure Calculate(const ABounds: TRect); override; // for internal use
    procedure CalculateHitTest(AHitTest: TdxTreeViewHitTest); override; // for internal use
    function CalculateSelectionRect: TRect; virtual; // for internal use
    function GetImageIndex: Integer; // for internal use
    function HasCheckBox: Boolean; virtual; // for internal use
    function HasExpandButton: Boolean; virtual; // for internal use
    function HasFocus: Boolean; virtual; // for internal use
    function HasRootIndent: Boolean; // for internal use
    function HasHottrack: Boolean; virtual; // for internal use
    function HasImage: Boolean; virtual; // for internal use
    function HasSelection: Boolean; virtual; // for internal use
    function HasStateImage: Boolean; virtual; // for internal use
    function HasTreeLines: Boolean; virtual; // for internal use
    procedure SetData(ANode: TdxTreeViewNode); // for internal use

    property CheckBoxRect: TRect read FCheckBoxRect;
    property ExpandButtonRect: TRect read FExpandButtonRect;
    property Height: Integer read GetHeight; // for internal use
    property ImageColorPalette: IdxColorPalette read FImageColorPalette write FImageColorPalette; // for internal use
    property ImageRect: TRect read FImageRect;
    property Images: TCustomImageList read GetImages; // for internal use
    property LevelIndent: Integer read FLevelIndent; // for internal use
    property LevelOffset: Integer read GetLevelOffset; // for internal use
    property Node: TdxTreeViewNode read FData; // for internal use
    property SelectionRect: TRect read FSelectionRect;
    property TextRect: TRect read FTextRect;
    property TextWidth: Integer read FTextWidth; // for internal use
    property HorizontalTreeLineBounds: TRect read FHorizontalTreeLineBounds;
    property VerticalTreeLineBounds: TRect read FVerticalTreeLineBounds;
  end;

  { TdxTreeViewViewInfo }

  TdxTreeViewViewInfo = class(TdxTreeViewCustomViewInfo)
  strict private
    FBaseFirstGroupInterval: Integer;
    FBaseGroupInterval: Integer;
    FContentRect: TRect;
    FContentSize: TSize;
    FNodeViewInfo: TdxTreeViewNodeViewInfo;
    FViewPort: TPoint;

    function GetAbsoluteVisibleNodes: TdxFastList; inline;
    function GetFirstVisibleIndex: Integer;
    function GetNodeRowSelectionRect: TRect;
    function GetNumberOfNodesInContentRect: Integer;
    procedure SetViewPort(const AValue: TPoint);
  protected
    FContentOffset: TPoint;
    FFirstGroupInterval: Integer;
    FGroupInterval: Integer;
    function CalculateContentWidth: Integer;
    procedure CheckViewPort;
    function CreateNodeViewInfo: TdxTreeViewNodeViewInfo; virtual;
    procedure DoRightToLeftConversion(ABounds: TRect); override;
    function GetContentOffset: TPoint;
    function GetNodeIndexByPosition(APos: Integer; out AGroupIndex: Integer): Integer;
    function GetNodePositionByIndex(AIndex: Integer): Integer;
    //
    function GetGroupNodeCount(AIndex: Integer): Integer;
    function GetGroupCount: Integer;
    //
    property AbsoluteVisibleNodes: TdxFastList read GetAbsoluteVisibleNodes;
    property FirstVisibleIndex: Integer read GetFirstVisibleIndex;
  public
    constructor Create(ATreeView: TdxCustomTreeView); override;
    destructor Destroy; override;
    procedure Calculate(const ABounds: TRect); override; // for internal use
    procedure CalculateHitTest(AHitTest: TdxTreeViewHitTest); override; // for internal use
    procedure Draw(ACanvas: TcxCanvas); override;
    function GetNodeAtPos(P: TPoint; out ANodeIndex: Integer): Boolean; // for internal use
    property ContentRect: TRect read FContentRect;
    property ContentSize: TSize read FContentSize; // for internal use
    property NodeViewInfo: TdxTreeViewNodeViewInfo read FNodeViewInfo; // for internal use
    property NumberOfNodesInContentRect: Integer read GetNumberOfNodesInContentRect; // for internal use
    property ViewPort: TPoint read FViewPort write SetViewPort; // for internal use
  end;

  { TdxTreeViewOptionsView }

  TdxTreeViewOptionsView = class(TdxTreeViewCustomOptionsView) // for internal use
  strict private
    function GetImages: TCustomImageList;
    procedure SetImages(AValue: TCustomImageList);
  private
    function GetRowSelect: Boolean;
    procedure SetRowSelect(AValue: Boolean);
  protected
    function GetDefaultShowEndEllipsis: Boolean; override;
  published
    property Images: TCustomImageList read GetImages write SetImages;
    property ItemHeight default 0;
    property RowSelect: Boolean read GetRowSelect write SetRowSelect default False;
    property ShowCheckBoxes default False;
    property ShowLines default True;
    property ShowRoot default True;
  end;

  { TdxInternalTreeView }

  TdxInternalTreeView = class(TdxCustomTreeView) // for internal use
  strict private
    function GetOptionsView: TdxTreeViewOptionsView;
    procedure SetOptionsView(AValue: TdxTreeViewOptionsView);
  protected
    function CreateOptionsView: TdxTreeViewCustomOptionsView; override;
    function GetDefaultScrollbarsValue: TcxScrollStyle; override;
  published
    property Align;
    property BiDiMode;
    property BorderStyle default cxcbsDefault;
    property DragCursor;
    property DragMode;
    property LookAndFeel;
    property OptionsBehavior;
    property OptionsView: TdxTreeViewOptionsView read GetOptionsView write SetOptionsView;

    property OnCollapsed;
    property OnCollapsing;
    property OnCustomDrawNode;
    property OnContextPopup;
    property OnDblClick;
    property OnDeletion;
    property OnExpanded;
    property OnExpanding;
    property OnGetChildren;
    property OnKeyDown;
    property OnNodeStateChanged;
    property OnSelectionChanged;
  end;

  { TdxTreeViewControlOptionsView }

  TdxTreeViewControlOptionsView = class(TdxTreeViewCustomOptionsView)
  published
    property Indent;
    property ItemHeight default 0;
    property ScrollBars default ssBoth;
    property ShowCheckBoxes default False;
    property ShowEndEllipsis default False;
    property ShowExpandButtons default True;
    property ShowLines default True;
    property ShowRoot default True;
    property UseImageIndexForExpanded default False;
    property UseImageIndexForSelected default False;
  end;

  { TdxTreeViewControlOptionsBehavior }

  TdxTreeViewControlOptionsBehavior = class(TdxTreeViewCustomOptionsBehavior)
  public
    constructor Create(ATreeView: TdxCustomTreeView); override;
  published
    property AutoExpand;
    property CaptionEditing default True;
    property ChangeDelay default 0;
    property HotTrack default False;
    property ReadOnly;
    property SortType default stNone;
    property ToolTips;
  end;

  TdxTreeViewControlOptionsSelection = class(TdxTreeViewCustomOptionsSelection)
  protected
    function DefaultHideSelectionValue: Boolean; override;
  published
    property HideSelection default True;
    property MultiSelect default False;
    property MultiSelectStyle;
    property RowSelect default False;
    property RightClickSelect default False;
  end;

  { TdxTreeViewControl }

  TdxTreeViewControl = class(TdxCustomTreeView)
  strict private const
    dxDefaultHeight = 100;
    dxDefaultWidth = 120;
  strict private
    function GetOptionsBehavior: TdxTreeViewControlOptionsBehavior;
    function GetOptionsSelection: TdxTreeViewControlOptionsSelection;
    function GetOptionsView: TdxTreeViewControlOptionsView;
    procedure SetOptionsBehavior(AValue: TdxTreeViewControlOptionsBehavior);
    procedure SetOptionsSelection(AValue: TdxTreeViewControlOptionsSelection);
    procedure SetOptionsView(AValue: TdxTreeViewControlOptionsView);
  protected
    function CreateOptionsBehavior: TdxTreeViewCustomOptionsBehavior; override;
    function CreateOptionsSelection: TdxTreeViewCustomOptionsSelection; override;
    function CreateOptionsView: TdxTreeViewCustomOptionsView; override;
    function CreatePainter: TdxTreeViewPainter; override;
    procedure DefineProperties(Filer: TFiler); override;
    function GetDefaultHeight: Integer; override;
    function GetDefaultWidth: Integer; override;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle default cxcbsDefault;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Height default dxDefaultHeight;
    property Images;
    property Items;
    property LookAndFeel;
    property OptionsBehavior: TdxTreeViewControlOptionsBehavior read GetOptionsBehavior write SetOptionsBehavior;
    property OptionsSelection: TdxTreeViewControlOptionsSelection read GetOptionsSelection write SetOptionsSelection;
    property OptionsView: TdxTreeViewControlOptionsView read GetOptionsView write SetOptionsView;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property StateImages;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property Width default dxDefaultWidth;
    property OnAddition;
    property OnCancelEdit;
    property OnCanFocusNode;
    property OnCanSelectNode;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnCompare;
    property OnContextPopup;
    property OnCustomDraw;
    property OnCustomDrawNode;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanded;
    property OnExpanding;
    property OnFocusedNodeChanged;
    property OnGetEditingText;
    property OnGetImageIndex;
    property OnGetSelectedImageIndex;
    property OnHint;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnNodeStateChanged;
    property OnSelectionChanged;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  Math, cxDrawTextUtils, RTLConsts, CommCtrl;

const
  dxThisUnitName = 'dxTreeView';

const
  dxTreeViewVersion = $00010001;

type
  TdxTreeViewStreamHeader = packed record
    Minor, Major: Word;
    Size: Integer;
  end;

  TdxTreeViewNodeInternalSaveState = (insExpandedIndex, insImageIndex, insOverlay, insSelectedIndex, insStateIndex, insCheckState,
    insCut, insDisabled, insCollapsed, insInvisible, insHasCaption, insHasChildren, insHasData);
  TdxTreeViewNodeInternalSaveStates = set of TdxTreeViewNodeInternalSaveState;

function CallNodeAllowEvent(ANode: TdxTreeViewNode; AEvent: TdxTreeViewNodeAllowEvent): Boolean;
begin
  Result := True;
  if Assigned(AEvent) then
    AEvent(ANode.TreeView, TdxTreeViewNode(ANode), Result);
end;

procedure CallNodeEvent(ANode: TdxTreeViewNode; AEvent: TdxTreeViewNodeEvent);
begin
  if Assigned(AEvent) then
    AEvent(ANode.TreeView, TdxTreeViewNode(ANode));
end;

{ TdxTreeViewPersistent }

constructor TdxTreeViewPersistent.Create(ATreeView: TdxCustomTreeView);
begin
  inherited Create;
  FTreeView := ATreeView;
end;

{ TdxTreeViewNodeExpandCollapseProvider }

constructor TdxTreeViewNodeExpandCollapseProvider.Create(ANode: TdxTreeViewNode);
begin
  FNode := ANode;
end;

procedure TdxTreeViewNodeExpandCollapseProvider.Collapse;
begin
  FNode.Expanded := False;
end;

procedure TdxTreeViewNodeExpandCollapseProvider.Expand;
begin
  FNode.Expanded := True;
end;

function TdxTreeViewNodeExpandCollapseProvider.GetExpandCollapseState: Integer;
begin
  Result := Integer(FNode.Expanded);
end;

{ TdxTreeViewNodeAccessibilityHelper }

constructor TdxTreeViewNodeAccessibilityHelper.Create(AOwnerObject: TObject);
begin
  inherited;
  FLocalId := Node.TreeView.AccessibleObjects.Count + 1;
  Node.TreeView.AccessibleObjects.Add(Self);
  FExpandCollapseProvider := TdxTreeViewNodeExpandCollapseProvider.Create(Node);
end;

destructor TdxTreeViewNodeAccessibilityHelper.Destroy;
begin
  FreeAndNil(FExpandCollapseProvider);
  inherited;
end;

function TdxTreeViewNodeAccessibilityHelper.GetScreenBounds(AChildID: TcxAccessibleSimpleChildElementID): TRect;
begin
  Result := Node.DisplayRect(True);
  Result := cxRectSetOrigin(Result, Node.TreeView.ClientToScreen(Result.TopLeft));
end;

function TdxTreeViewNodeAccessibilityHelper.ChildIsSimpleElement(AIndex: Integer): Boolean;
begin
  Result := False;
end;

procedure TdxTreeViewNodeAccessibilityHelper.DoSelect(AFlags: Integer; AChildID: TcxAccessibleSimpleChildElementID);
begin
  Node.Selected := True;
end;

function TdxTreeViewNodeAccessibilityHelper.GetChild(AIndex: Integer): TcxAccessibilityHelper;
begin
  Result := Node.Items[AIndex].IAccessibilityHelper.GetHelper;
end;

function TdxTreeViewNodeAccessibilityHelper.GetChildCount: Integer;
begin
  Result := Node.Count;
end;

function TdxTreeViewNodeAccessibilityHelper.GetLocalId(AChildID: TcxAccessibleSimpleChildElementID = 0): Integer;
begin
  Result := FLocalId;
end;

function TdxTreeViewNodeAccessibilityHelper.GetName(AChildID: TcxAccessibleSimpleChildElementID): string;
begin
  Result := Node.Caption;
end;

function TdxTreeViewNodeAccessibilityHelper.GetParent: TcxAccessibilityHelper;
begin
  if Node.IsRoot then
    Result := Node.TreeView.IAccessibilityHelper.GetHelper
  else
    Result := Node.Parent.IAccessibilityHelper.GetHelper;
end;

function TdxTreeViewNodeAccessibilityHelper.GetRole(AChildID: TcxAccessibleSimpleChildElementID): Integer;
begin
  Result := cxROLE_SYSTEM_OUTLINEITEM;
end;

function TdxTreeViewNodeAccessibilityHelper.GetState(AChildID: TcxAccessibleSimpleChildElementID): Integer;
begin
  Result := cxSTATE_SYSTEM_FOCUSABLE or cxSTATE_SYSTEM_SELECTABLE;
  if not Node.Visible then
    Result := Result or cxSTATE_SYSTEM_INVISIBLE;
  if Node.Expanded then
    Result := Result or cxSTATE_SYSTEM_EXPANDED
  else
    Result := Result or cxSTATE_SYSTEM_COLLAPSED;
  if not Node.Enabled then
    Result := Result or cxSTATE_SYSTEM_UNAVAILABLE;
  if Node.IsHidden then
    Result := Result or cxSTATE_SYSTEM_INVISIBLE or cxSTATE_SYSTEM_OFFSCREEN;
  if Node.Focused then
    Result := Result or cxSTATE_SYSTEM_FOCUSED;
  if Node.Selected then
    Result := Result or cxSTATE_SYSTEM_SELECTED;
end;

function TdxTreeViewNodeAccessibilityHelper.GetSupportedProperties(AChildID: TcxAccessibleSimpleChildElementID): TcxAccessibleObjectProperties;
begin
  Result := [aopLocation, aopSelect, aopFocus, aopSelect];
end;

function TdxTreeViewNodeAccessibilityHelper.IsExtended: Boolean;
begin
  Result := True;
end;

function TdxTreeViewNodeAccessibilityHelper.IsSupportedPattern(
  APatternID: Integer; out AProvider: IUnknown; AChildID: TcxAccessibleSimpleChildElementID = 0): Boolean;
begin
  if APatternID = dxUIA_ExpandCollapsePatternId then
  begin
    Result := True;
    AProvider := FExpandCollapseProvider;
  end
  else
    Result := inherited;
end;

procedure TdxTreeViewNodeAccessibilityHelper.OwnerObjectDestroyed;
begin
  if (Node.TreeView <> nil) and (Node.TreeView.AccessibleObjects <> nil) then
    Node.TreeView.AccessibleObjects[FLocalID - 1] := nil;
  inherited;
end;

function TdxTreeViewNodeAccessibilityHelper.GetNode: TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(OwnerObject);
end;

{ TdxTreeViewNode }

constructor TdxTreeViewNode.Create(AOwner: IdxTreeOwner);
begin
  inherited Create(AOwner);
  FStateImageIndex := -1;
  FOverlayImageIndex := -1;
  FEnabled := True;
  FAbsoluteIndex := -1;
end;

destructor TdxTreeViewNode.Destroy;
begin
  cxAccessibilityHelperOwnerObjectDestroyed(FIAccessibilityHelper);
  inherited;
end;

function TdxTreeViewNode.AddChild(ACaption: string = ''; AData: Pointer = nil): TdxTreeViewNode;
begin
  Result := nil;
  TreeView.BeginAddNode;
  try
    Result := TdxTreeViewNode(inherited AddChild);
    Result.Caption := ACaption;
    Result.Data := AData;
  finally
    TreeView.EndAddNode(Result);
  end;
end;

function TdxTreeViewNode.AddChildFirst(ACaption: string = ''; AData: Pointer = nil): TdxTreeViewNode;
begin
  Result := nil;
  TreeView.BeginAddNode;
  try
    Result := TdxTreeViewNode(inherited AddChildFirst);
    Result.Caption := ACaption;
    Result.Data := AData;
  finally
    TreeView.EndAddNode(Result);
  end;
end;

function TdxTreeViewNode.AddNode(ANode, ARelative: TdxTreeViewNode;
  AData: Pointer; AttachMode: TdxTreeNodeAttachMode): TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(inherited AddNode(ANode, ARelative, AData, AttachMode));
end;

procedure TdxTreeViewNode.AlphaSort(ARecurse: Boolean = False);
begin
  CustomSort(nil, 0, ARecurse);
end;

procedure TdxTreeViewNode.Assign(ASource: TdxTreeCustomNode);
begin
  inherited Assign(ASource);
  if ASource is TdxTreeViewNode then
  begin
    BeginUpdate;
    try
      Caption := TdxTreeViewNode(ASource).Caption;
      CheckState := TdxTreeViewNode(ASource).CheckState;
      Cut := TdxTreeViewNode(ASource).Cut;
      Enabled := TdxTreeViewNode(ASource).Enabled;
      ExpandedImageIndex := TdxTreeViewNode(ASource).ExpandedImageIndex;
      HideCheckBox := TdxTreeViewNode(ASource).HideCheckBox;
      SelectedImageIndex := TdxTreeViewNode(ASource).SelectedImageIndex;
      StateImageIndex := TdxTreeViewNode(ASource).StateImageIndex;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxTreeViewNode.Collapse(ARecurse: Boolean = False);
begin
  DoExpand(False, ARecurse);
end;

function DefaultTreeViewSort(AItem1, AItem2: TdxTreeViewNode; AData: TdxNativeInt): Integer;
begin
  if Assigned(AItem1.TreeView.OnCompare) then
    AItem1.TreeView.OnCompare(AItem1.TreeView, AItem1, AItem2, AData, Result)
  else
    Result := AnsiCompareText(AItem1.Caption, AItem2.Caption);
end;

function TdxTreeViewNode.CustomSort(ACompareProc: TdxTreeViewNodeCompareProc; AData: TdxNativeInt; ARecurse: Boolean = False): Boolean;
var
  I: Integer;
  AList: TdxFastList;
begin
  Result := True;
  TreeView.FinishNodeCaptionEditing(True);
  if not Assigned(ACompareProc) then
    ACompareProc := @DefaultTreeViewSort;
  BeginUpdate;
  try
    AList := TdxFastList.Create;
    try
      PopulateItems(AList);
      if AList.Count > 1 then
      begin
        AList.SortList(
          function (AItem1, AItem2: Pointer): Integer
          begin
            Result := ACompareProc(TdxTreeViewNode(AItem1), TdxTreeViewNode(AItem2), AData);
          end, True);
        UpdateItems(AList);
      end;
      if ARecurse then
      begin
        for I := 0 to AList.Count - 1 do
          TdxTreeViewNode(AList.List[I]).CustomSort(ACompareProc, AData, ARecurse);
      end;
    finally
      AList.Free;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TdxTreeViewNode.DeleteChildren;
begin
  if TreeView.FocusedNode <> nil then 
  begin
    if IsRoot then
      TreeView.FocusedNode := nil
    else
      if TreeView.FocusedNode.HasAsParent(Self) then
        TreeView.FocusedNode := Self;
  end;
  inherited DeleteChildren;
end;

function TdxTreeViewNode.DisplayRect(TextOnly: Boolean): TRect;
begin
  if TextOnly then
    Result := TreeView.GetNodeTextRect(Self)
  else
    Result := TreeView.GetNodeBounds(Self);
end;

function TdxTreeViewNode.EditCaption: Boolean;
begin
  Result := TreeView.StartItemCaptionEditing(Self);
end;

procedure TdxTreeViewNode.EndEdit(ACancel: Boolean);
begin
  TreeView.EndEdit(ACancel);
end;

procedure TdxTreeViewNode.Expand(ARecurse: Boolean = False);
begin
  DoExpand(True, ARecurse);
end;

function TdxTreeViewNode.GetNext: TdxTreeViewNode;
var
  ANode: TdxTreeViewNode;
begin
  Result := First;
  if Count = 0 then
  begin
    ANode := Self;
    while ANode <> nil do
    begin
      if ANode.Next <> nil then
      begin
        Result := ANode.Next;
        Break;
      end;
      while (ANode <> nil) and (ANode.Next = nil) do ANode := ANode.Parent;
    end;
  end;
end;

function TdxTreeViewNode.GetPrev: TdxTreeViewNode;
var
  ANode: TdxTreeViewNode;
begin
  Result := Prev;
  if Result <> nil then
  begin
    ANode := Result;
    repeat
      Result := ANode;
      ANode := Result.Last;
    until ANode = nil;
  end
  else
    Result := Parent;
  if Result = TreeView.Root then
    Result := nil;
end;

procedure TdxTreeViewNode.Invalidate;
begin
  TreeView.InvalidateNode(Self);
end;

procedure TdxTreeViewNode.MakeVisible;
begin
  TreeView.MakeVisible(Self);
end;

procedure TdxTreeViewNode.Added(ANode: TdxTreeCustomNode);
var
  ASender: TdxTreeViewNode absolute ANode;
begin
  TreeView.Added(ASender);
end;

procedure TdxTreeViewNode.AssignFromNode(ASource: TTreeNode);
begin
  Caption := ASource.Text;
  ImageIndex := ASource.ImageIndex;
  ExpandedImageIndex := ASource.ExpandedImageIndex;
  StateImageIndex := ASource.StateIndex;
  SelectedImageIndex := ASource.SelectedIndex;
  OverlayImageIndex := ASource.OverlayIndex;
  Enabled := ASource.Enabled;
  Cut := ASource.Cut;
end;

procedure TdxTreeViewNode.DataChanged;
begin
  if (TreeView.OptionsBehavior.SortType in [stData, stBoth]) and Assigned(TreeView.OnCompare) and
    (Parent <> nil) then
  begin
    Parent.AlphaSort;
    TreeView.MakeVisible(TreeView.FocusedNode);
  end;
end;

procedure TdxTreeViewNode.DoNodeExpandStateChanged;
begin
  TreeView.DoNodeExpandStateChanged(Self);
end;

function TdxTreeViewNode.GetDefaultImageIndexValue: Integer;
begin
  Result := 0;
end;

function TdxTreeViewNode.GetHintText: string;
begin
  Result := Caption;
end;

function TdxTreeViewNode.GetVisibleLevel: Integer;
var
  ANode: TdxTreeViewNode;
begin
  if TreeView.ShowFirstLevelNodes then
    Result := Level
  else
  begin
    Result := -1;
    ANode := Parent;
    while ANode <> nil do
    begin
      if not ANode.IsHidden then
        Inc(Result);
      ANode := ANode.Parent;
    end;
  end;
end;

function TdxTreeViewNode.IsHidden: Boolean;
begin
  Result := (Parent <> nil) and Parent.IsRoot and not TreeView.ShowFirstLevelNodes;
end;

procedure TdxTreeViewNode.ReadData(AStream: TStream; const AVersion: Cardinal = 0);
var
  AData: UInt64;
  AState: TdxTreeViewNodeInternalSaveStates;
  ANodeInfoSize: Integer;
  ANodeInfoPos: Int64;
  ACount: Integer;
  I: Integer;
  ALength: Integer;
  AValue: Integer;
begin
  DeleteChildren;
  ANodeInfoPos := AStream.Position;
  AStream.ReadBuffer(ANodeInfoSize, SizeOf(Integer));
  AStream.ReadBuffer(AState, SizeOf(AState));

  if insExpandedIndex in AState then
    AStream.ReadBuffer(FExpandedImageIndex, SizeOf(Integer))
  else
    ExpandedImageIndex := 0;
  if insImageIndex in AState then
  begin
    AStream.ReadBuffer(AValue, SizeOf(Integer));
    ImageIndex := AValue;
  end
  else
    ImageIndex := 0;
  if insOverlay in AState then
    AStream.ReadBuffer(FOverlayImageIndex, SizeOf(Integer))
  else
    OverlayImageIndex := -1;
  if insSelectedIndex in AState then
    AStream.ReadBuffer(FSelectedImageIndex, SizeOf(Integer))
  else
    SelectedImageIndex := 0;
  if insStateIndex in AState then
    AStream.ReadBuffer(FStateImageIndex, SizeOf(Integer))
  else
    StateImageIndex := -1;
  if insCheckState in AState then
    AStream.ReadBuffer(FCheckState, SizeOf(TcxCheckBoxState))
  else
    Checked := False;
  if insHasChildren in AState then
  begin
    AStream.ReadBuffer(ACount, SizeOf(Integer));
    for I := 0 to ACount - 1 do
      AddChild;
  end;
  if insHasData in AState then
  begin
    AStream.ReadBuffer(AData, SizeOf(AData));
    Data := Pointer(AData);
  end;
  if insHasCaption in AState then
  begin
    AStream.ReadBuffer(ALength, SizeOf(Integer));
    SetLength(FCaption, ALength);
    AStream.ReadBuffer(FCaption[1], ALength * SizeOf(Char));
  end;

  Cut := insCut in AState;
  Enabled := not (insDisabled in AState);
  Expanded := (Count > 0) and not (insCollapsed in AState);
  Visible := not (insInvisible in AState);

  AStream.Position := ANodeInfoPos + ANodeInfoSize;
end;

procedure TdxTreeViewNode.WriteData(AStream: TStream);
var
  AData: UInt64;
  AState: TdxTreeViewNodeInternalSaveStates;
  ANodeInfoSize: Integer;
  ANodeInfoPos: Int64;
  AValue: Integer;
  ALength: Integer;
begin
  AState := [];
  ANodeInfoSize := 0;
  if ExpandedImageIndex <> 0 then
    Include(AState, insExpandedIndex);
  if ImageIndex <> 0 then
    Include(AState, insImageIndex);
  if OverlayImageIndex <> -1 then
    Include(AState, insOverlay);
  if SelectedImageIndex <> 0 then
    Include(AState, insSelectedIndex);
  if StateImageIndex <> -1 then
    Include(AState, insStateIndex);
  if CheckState <> cbsUnchecked then
    Include(AState, insCheckState);
  if Cut then
    Include(AState, insCut);
  if not Enabled then
    Include(AState, insDisabled);
  if nsCollapsed in State then
    Include(AState, insCollapsed);
  if nsInvisible in State then
    Include(AState, insInvisible);
  if Caption <> '' then
    Include(AState, insHasCaption);
  if Count > 0 then
    Include(AState, insHasChildren);
  if Data <> nil then
    Include(AState, insHasData);

  ANodeInfoPos := AStream.Size;
  AStream.WriteBuffer(ANodeInfoSize, SizeOf(Integer));
  AStream.WriteBuffer(AState, SizeOf(AState));
  if insExpandedIndex in AState then
    AStream.WriteBuffer(ExpandedImageIndex, SizeOf(Integer));
  if insImageIndex in AState then
  begin
    AValue := ImageIndex;
    AStream.WriteBuffer(AValue, SizeOf(Integer));
  end;
  if insOverlay in AState then
    AStream.WriteBuffer(OverlayImageIndex, SizeOf(Integer));
  if insSelectedIndex in AState then
    AStream.WriteBuffer(SelectedImageIndex, SizeOf(Integer));
  if insStateIndex in AState then
    AStream.WriteBuffer(StateImageIndex, SizeOf(Integer));
  if insCheckState in AState then
    AStream.WriteBuffer(CheckState, SizeOf(TcxCheckBoxState));
  if insHasChildren in AState then
    AStream.WriteBuffer(Count, SizeOf(Integer));
  if insHasData in AState then
  begin
    AData := UInt64(Data);
    AStream.WriteBuffer(AData, SizeOf(AData));
  end;
  if insHasCaption in AState then
  begin
    ALength := Length(FCaption);
    AStream.WriteBuffer(ALength, SizeOf(Integer));
    AStream.WriteBuffer(FCaption[1], ALength * SizeOf(Char));
  end;
  ANodeInfoSize := AStream.Size - ANodeInfoPos;
  AStream.Position := ANodeInfoPos;
  AStream.WriteBuffer(ANodeInfoSize, SizeOf(Integer));
  AStream.Position := AStream.Size;
end;

procedure TdxTreeViewNode.DoExpand(AExpand: Boolean; ARecurse: Boolean);
begin
  if not ARecurse then
    Expanded := AExpand
  else
  begin
    BeginUpdate;
    try
      dxTreeForEach(Self,
        function(ANode: TdxTreeCustomNode; AData: Pointer): Boolean
        begin
          Result := True;
          ANode.Expanded := AExpand;
        end, nil);
    finally
      EndUpdate;
    end;
  end;
end;

function TdxTreeViewNode.GetAbsoluteIndex: Integer;
begin
  TreeView.CheckAbsoluteNodes;
  Result := FAbsoluteIndex;
end;

function TdxTreeViewNode.GetChecked: Boolean;
begin
  Result := CheckState = cbsChecked;
end;

function TdxTreeViewNode.GetDefaultState: TdxTreeNodeStates;
begin
  Result := [nsCollapsed];
end;

function TdxTreeViewNode.GetDeleting: Boolean;
begin
  Result := nsDeleting in State;
end;

function TdxTreeViewNode.GetDropTarget: Boolean;
begin
  Result := TreeView.DropTarget = Self;
end;

function TdxTreeViewNode.GetFirst: TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(inherited First);
end;

function TdxTreeViewNode.GetItem(Index: Integer): TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(inherited Items[Index]);
end;

function TdxTreeViewNode.GetLast: TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(inherited Last);
end;

function TdxTreeViewNode.InternalGetNext: TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(inherited Next);
end;

function TdxTreeViewNode.GetParent: TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(inherited Parent);
end;

function TdxTreeViewNode.InternalGetPrev: TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(inherited Prev);
end;

function TdxTreeViewNode.GetRoot: TdxTreeViewNode;
begin
  Result := TdxTreeViewNode(inherited Root);
end;

function TdxTreeViewNode.GetSelected: Boolean;
begin
  if TreeView.OptionsSelection.MultiSelect then
    Result := TreeView.IsNodeSelected(Self)
  else
    Result := Focused;
end;

function TdxTreeViewNode.GetTreeView: TdxCustomTreeView;
begin
  Result := TdxCustomTreeView(Owner);
end;

function TdxTreeViewNode.GetVisibleIndex: Integer;
begin
  TreeView.UpdateAbsoluteVisibleNodes;
  Result := TreeView.AbsoluteVisibleNodes.IndexOf(Self);
end;

function TdxTreeViewNode.GetFocused: Boolean;
begin
  Result := TreeView.FocusedNode = Self;
end;

function TdxTreeViewNode.GetIAccessibilityHelper: IcxAccessibilityHelper;
begin
  if FIAccessibilityHelper = nil then
    FIAccessibilityHelper := TdxTreeViewNodeAccessibilityHelper.Create(Self);
  Result := FIAccessibilityHelper;
end;

function TdxTreeViewNode.GetIsVisible: Boolean;
begin
  Result := VisibleIndex >= 0;
end;

procedure TdxTreeViewNode.SetCaption(const AValue: string);
begin
  if FCaption <> AValue then
  begin
    FCaption := AValue;
    if (TreeView.OptionsBehavior.SortType in [stText, stBoth]) and (Parent <> nil) then
    begin
      Parent.AlphaSort;
      TreeView.MakeVisible(TreeView.FocusedNode);
    end
    else
      Notify([tnStructure]);
  end;
end;

procedure TdxTreeViewNode.SetChecked(AValue: Boolean);
const
  ACheckState: array[Boolean] of TcxCheckBoxState = (cbsUnchecked, cbsChecked);
begin
  if AValue <> Checked then
    CheckState := ACheckState[AValue];
end;

procedure TdxTreeViewNode.SetCheckState(AValue: TcxCheckBoxState);
begin
  if FCheckState <> AValue then
  begin
    FCheckState := AValue;
    Notify([tnData]);
    TreeView.NodeStateChanged(Self);
  end;
end;

procedure TdxTreeViewNode.SetCut(AValue: Boolean);
begin
  if FCut <> AValue then
  begin
    FCut := AValue;
    Invalidate;
  end;
end;

procedure TdxTreeViewNode.SetDropTarget(AValue: Boolean);
begin
  if AValue then
    TreeView.DropTarget := Self
  else
    if DropTarget then
      TreeView.DropTarget := nil;
end;

procedure TdxTreeViewNode.SetEnabled(AValue: Boolean);
begin
  if FEnabled <> AValue then
  begin
    FEnabled := AValue;
    Invalidate;
  end;
end;

procedure TdxTreeViewNode.SetExpandedImageIndex(AValue: Integer);
begin
  if AValue <> FExpandedImageIndex then
  begin
    FExpandedImageIndex := AValue;
    Notify([tnData]);
  end;
end;

procedure TdxTreeViewNode.SetHideCheckBox(AValue: Boolean);
begin
  if FHideCheckBox <> AValue then
  begin
    FHideCheckBox := AValue;
    Notify([tnData]);
  end;
end;

procedure TdxTreeViewNode.SetOverlayImageIndex(AValue: Integer);
begin
  if AValue <> FOverlayImageIndex then
  begin
    FOverlayImageIndex := AValue;
    Notify([tnData]);
  end;
end;

procedure TdxTreeViewNode.SetSelected(AValue: Boolean);
begin
  if Selected = AValue then
    Exit;
  if TreeView.OptionsSelection.MultiSelect then
  begin
    if AValue then
      TreeView.AddNodeToSelection(Self, 0)
    else
      TreeView.Deselect(Self);
  end
  else
    Focused := AValue;
end;

procedure TdxTreeViewNode.SetFocused(AValue: Boolean);
begin
  if AValue then
    TreeView.FocusedNode := Self
  else
    if Focused then
      TReeView.FocusedNode := nil;
end;

procedure TdxTreeViewNode.SetSelectedImageIndex(AValue: Integer);
begin
  if AValue <> FSelectedImageIndex then
  begin
    FSelectedImageIndex := AValue;
    Notify([tnData]);
  end;
end;

procedure TdxTreeViewNode.SetStateImageIndex(AValue: Integer);
begin
  if AValue <> FStateImageIndex then
  begin
    FStateImageIndex := AValue;
    Notify([tnData]);
  end;
end;

{ TdxTreeViewNodesEnumerator }

constructor TdxTreeViewNodesEnumerator.Create(ATreeNodes: TdxTreeViewNodes);
begin
  inherited Create;
  FIndex := -1;
  FTreeNodes := ATreeNodes;
end;

function TdxTreeViewNodesEnumerator.GetCurrent: TdxTreeViewNode;
begin
  Result := FTreeNodes[FIndex];
end;

function TdxTreeViewNodesEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FTreeNodes.Count - 1;
  if Result then
    Inc(FIndex);
end;

{ TdxTreeViewNodes }

function TdxTreeViewNodes.Add(ASibling: TdxTreeViewNode;
  const S: string): TdxTreeViewNode;
begin
  Result := AddNode(nil, ASibling, S, nil, namAdd);
end;

function TdxTreeViewNodes.AddChild(AParent: TdxTreeViewNode;
  const S: string): TdxTreeViewNode;
begin
  Result := AddNode(nil, AParent, S, nil, namAddChild);
end;

function TdxTreeViewNodes.AddChildFirst(AParent: TdxTreeViewNode;
  const S: string): TdxTreeViewNode;
begin
  Result := AddNode(nil, AParent, S, nil, namAddChildFirst);
end;

function TdxTreeViewNodes.AddChildObject(AParent: TdxTreeViewNode;
  const S: string; AData: Pointer): TdxTreeViewNode;
begin
  Result := AddNode(nil, AParent, S, AData, namAddChild);
end;

function TdxTreeViewNodes.AddChildObjectFirst(AParent: TdxTreeViewNode;
  const S: string; AData: Pointer): TdxTreeViewNode;
begin
  Result := AddNode(nil, AParent, S, AData, namAddChildFirst);
end;

function TdxTreeViewNodes.AddFirst(ASibling: TdxTreeViewNode;
  const S: string): TdxTreeViewNode;
begin
  Result := AddNode(nil, ASibling, S, nil, namAddFirst);
end;

function TdxTreeViewNodes.AddNode(ANode, ARelative: TdxTreeViewNode;
  const S: string; AData: Pointer; AttachMode: TdxTreeNodeAttachMode): TdxTreeViewNode;
begin
  Result := TreeView.DoNodeAddition(
    function: TdxTreeViewNode
    begin
      Result := Root.AddNode(ANode, ARelative, AData, AttachMode);
      Result.Caption := S;
    end);
end;

function TdxTreeViewNodes.AddObject(ASibling: TdxTreeViewNode; const S: string;
  AData: Pointer): TdxTreeViewNode;
begin
  Result := AddNode(nil, ASibling, S, AData, namAdd);
end;

function TdxTreeViewNodes.AddObjectFirst(ASibling: TdxTreeViewNode;
  const S: string; AData: Pointer): TdxTreeViewNode;
begin
  Result := AddNode(nil, ASibling, S, AData, namAddFirst);
end;

function TdxTreeViewNodes.AlphaSort(ARecurse: Boolean): Boolean;
begin
  Result := TreeView.AlphaSort(ARecurse);
end;

procedure TdxTreeViewNodes.Assign(Source: TPersistent);
var
  ATreeNodes: TdxTreeViewNodes;
  AMemStream: TMemoryStream;
begin
  if Source is TdxTreeViewNodes then
  begin
    ATreeNodes := TdxTreeViewNodes(Source);
    Clear;
    AMemStream := TMemoryStream.Create;
    try
      ATreeNodes.TreeView.WriteData(AMemStream);
      AMemStream.Position := 0;
      TreeView.ReadData(AMemStream);
    finally
      AMemStream.Free;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TdxTreeViewNodes.BeginUpdate;
begin
  TreeView.BeginUpdate;
end;

procedure TdxTreeViewNodes.Clear;
begin
  Root.Clear;
end;

function TdxTreeViewNodes.CustomSort(ASortProc: TdxTreeViewNodeCompareProc;
  AData: NativeInt; ARecurse: Boolean = True): Boolean;
begin
  Result := TreeView.CustomSort(ASortProc, AData, ARecurse);
end;

procedure TdxTreeViewNodes.Delete(ANode: TdxTreeViewNode);
begin
  ANode.Delete;
end;

procedure TdxTreeViewNodes.EndUpdate;
begin
  TreeView.EndUpdate;
end;

function TdxTreeViewNodes.GetCount: Integer;
begin
  Result := TreeView.AbsoluteCount;
end;

function TdxTreeViewNodes.GetEnumerator: TdxTreeViewNodesEnumerator;
begin
  Result := TdxTreeViewNodesEnumerator.Create(Self);
end;

function TdxTreeViewNodes.GetFirstNode: TdxTreeViewNode;
begin
  Result := Root.First;
end;

function TdxTreeViewNodes.GetHandle: HWND;
begin
  Result := TreeView.Handle;
end;

function TdxTreeViewNodes.GetItem(Index: Integer): TdxTreeViewNode;
begin
  Result := TreeView.AbsoluteItems[Index];
end;

function TdxTreeViewNodes.GetRoot: TdxTreeViewNode;
begin
  Result := TreeView.Root;
end;

function TdxTreeViewNodes.Insert(ASibling: TdxTreeViewNode;
  const S: string): TdxTreeViewNode;
begin
  Result := AddNode(nil, ASibling, S, nil, namInsert);
end;

function TdxTreeViewNodes.InsertNode(ANode, ASibling: TdxTreeViewNode;
  const S: string; AData: Pointer): TdxTreeViewNode;
begin
  Result := AddNode(ANode, ASibling, S, AData, namInsert);
end;

function TdxTreeViewNodes.InsertObject(ASibling: TdxTreeViewNode;
  const S: string; AData: Pointer): TdxTreeViewNode;
begin
  Result := AddNode(nil, ASibling, S, AData, namInsert);
end;

{ TdxCustomTreeViewHintHelper }

procedure TdxCustomTreeViewHintHelper.CheckHint;
var
  AHitNode: TdxTreeViewNode;
  R: TRect;
  AText: string;
  ATextWidth: Integer;
  ATextAreaWidth: Integer;
begin
  FIsTextTruncated := False;
  AHitNode := FTreeView.HitTest.HitObjectAsNode;
  if not FTreeView.HitTest.HitAtText then
    CancelHint
  else
    if HintableObject <> AHitNode then
    begin
      R := AHitNode.DisplayRect(True);
      AText := AHitNode.Caption;
      ATextWidth := FTreeView.ViewInfo.NodeViewInfo.TextWidth;
      if FTreeView.OptionsView.Scrollbars in [ssVertical, ssNone] then
        ATextAreaWidth := R.Width
      else
        if FTreeView.UseRightToLeftAlignment then
          ATextAreaWidth := R.Right - FTreeView.ViewInfo.ContentRect.Left
        else
          ATextAreaWidth := FTreeView.ViewInfo.ContentRect.Right - R.Left;
      FIsTextTruncated := ATextWidth > ATextAreaWidth;
      if not FIsTextTruncated and FTreeView.AllowInfoTips then
        AText := '';
      if FIsTextTruncated or FTreeView.AllowInfoTips then
        DoShowHint(R, R, AText);
    end;
end;

constructor TdxCustomTreeViewHintHelper.Create(ATreeView: TdxCustomTreeView);
begin
  inherited Create;
  FTreeView := ATreeView;
end;

procedure TdxCustomTreeViewHintHelper.CorrectHintWindowRect(var ARect: TRect);
begin
  inherited CorrectHintWindowRect(ARect);
  if not FIsTextTruncated then
  begin
    ARect := cxRectSetOrigin(ARect, GetMouseCursorPos);
    OffsetRect(ARect, 0, cxGetCursorSize.cy);
    if FTreeView.UseRightToLeftAlignment then
      ARect := cxRectOffsetHorz(ARect, -ARect.Width);
  end;
end;

procedure TdxCustomTreeViewHintHelper.DoShowHint(const AHintAreaBounds, ATextRect: TRect;
  const AText: string);
var
  S: string;
begin
  S := AText;
  FTreeView.DoHint(FTreeView.HitTest.HitObjectAsNode, S);
  if S <> '' then
    ShowHint(AHintAreaBounds, ATextRect, S, False, FTreeView.HitTest.HitObjectAsNode, FTreeView.Font);
end;

function TdxCustomTreeViewHintHelper.GetOwnerControl: TcxControl;
begin
  Result := FTreeView;
end;

function TdxCustomTreeViewHintHelper.PtInCaller(const P: TPoint): Boolean;
begin
  Result := PtInRect(GetHintControl.Bounds, P);
end;

{ TdxTreeViewIncrementalSearchController }

constructor TdxTreeViewIncrementalSearchController.Create(ATreeView: TdxCustomTreeView);
begin
  inherited Create;
  FTreeView := ATreeView;
end;

function TdxTreeViewIncrementalSearchController.FocusNextItemWithText(
  const AText: string): Boolean;
begin
  Result := FTreeView.FocusNextItemWithText(AText);
end;

{ TdxTreeViewInplaceEditingController }

constructor TdxTreeViewInplaceEditingController.Create(
  ATreeView: TdxCustomTreeView);
begin
  inherited Create;
  FTreeView := ATreeView;
end;

procedure TdxTreeViewInplaceEditingController.InplaceEditKeyPress(Sender: TObject; var AKey: Char);
begin
  FTreeView.InplaceEditKeyPress(Sender, AKey);
end;

procedure TdxTreeViewInplaceEditingController.StartItemCaptionEditing;
begin
  FTreeView.StartItemCaptionEditing(FTreeView.EditingItem);
end;

{ TdxCustomTreeViewDragObject }

constructor TdxCustomTreeViewDragObject.Create(AControl: TControl);
begin
  inherited Create(AControl);
  AlwaysShowDragImages := True;
  FAutoScrollHelper := CreateAutoScrollHelper;
end;

destructor TdxCustomTreeViewDragObject.Destroy;
begin
  FreeAndNil(FAutoScrollHelper);
  inherited Destroy;
end;

function TdxCustomTreeViewDragObject.CreateAutoScrollHelper: TdxAutoScrollHelper;
var
  AStep: Integer;
  ASize: TSize;
begin
  AStep := TreeView.ViewInfo.NodeViewInfo.Height;
  ASize.Init(AStep);
  Result := TdxAutoScrollHelper.CreateScroller(TreeView, TreeView.ClientBounds, TreeView.ScaleFactor.Apply(20), 250, ASize);
end;

function TdxCustomTreeViewDragObject.GetTreeView: TdxCustomTreeView;
begin
  Result := Control as TdxCustomTreeView;
end;

{ TdxTreeViewAccessibilityHelper }

function TdxTreeViewAccessibilityHelper.GetScreenBounds(AChildID: TcxAccessibleSimpleChildElementID): TRect;
begin
  Result := TreeView.Bounds;
  Result := cxRectSetOrigin(Result, TreeView.ClientToScreen(Result.TopLeft));
end;

function TdxTreeViewAccessibilityHelper.ChildIsSimpleElement(AIndex: Integer): Boolean;
begin
  Result := False;
end;

function TdxTreeViewAccessibilityHelper.GetChild(AIndex: Integer): TcxAccessibilityHelper;
begin
  Result := TreeView.Root.IAccessibilityHelper.GetHelper;
end;

function TdxTreeViewAccessibilityHelper.GetChildCount: Integer;
begin
  Result := 1;
end;

function TdxTreeViewAccessibilityHelper.GetHitTest(AScreenX: Integer; AScreenY: Integer; out AIAccessibilityHelper: IcxAccessibilityHelper): Boolean;
begin
  Result := (TreeView.HitTest <> nil) and TreeView.HitTest.HitAtNode;
  if Result then
    AIAccessibilityHelper := TreeView.HitTest.HitObjectAsNode.IAccessibilityHelper;
end;

function TdxTreeViewAccessibilityHelper.GetOwnerObjectWindow: HWND;
begin
  Result := TreeView.Handle;
end;

function TdxTreeViewAccessibilityHelper.GetRole(AChildID: TcxAccessibleSimpleChildElementID): Integer;
begin
  Result := cxROLE_SYSTEM_OUTLINE;
end;

function TdxTreeViewAccessibilityHelper.GetState(AChildID: TcxAccessibleSimpleChildElementID): Integer;
begin
  Result := cxSTATE_SYSTEM_FOCUSABLE;
end;

function TdxTreeViewAccessibilityHelper.GetSupportedProperties(AChildID: TcxAccessibleSimpleChildElementID): TcxAccessibleObjectProperties;
begin
  Result := [aopFocus, aopLocation];
end;

function TdxTreeViewAccessibilityHelper.IsExtended: Boolean;
begin
  Result := True;
end;

function TdxTreeViewAccessibilityHelper.GetTreeView: TdxCustomTreeView;
begin
  Result := TdxCustomTreeView(OwnerObject);
end;

{ TdxCustomTreeView }

constructor TdxCustomTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Keys := [kArrows, kChars];
  FRoot := GetNodeClass.Create(Self);
  FHitTest := CreateHitTest;
  FHintHelper := CreateHintHelper;
  FAbsoluteNodes := TdxFastList.Create;
  FAbsoluteVisibleNodes := TdxFastList.Create;
  FItems := TdxTreeViewNodes.Create(Self);
  FChangeDelayTimer := TcxTimer.Create(nil);
  FChangeDelayTimer.Enabled := False;
  FChangeDelayTimer.Interval := 0;
  FChangeDelayTimer.OnTimer := DoChangeDelayTimer;
  FImagesChangeLink := TChangeLink.Create;
  FImagesChangeLink.OnChange := ImagesChangeHandler;
  FStateImagesChangeLink := TChangeLink.Create;
  FStateImagesChangeLink.OnChange := ImagesChangeHandler;
  FOptionsBehavior := CreateOptionsBehavior;
  FOptionsSelection := CreateOptionsSelection;
  FOptionsView := CreateOptionsView;
  FSelections := TdxFastList.Create;
  FPainter := CreatePainter;
  FViewInfo := CreateViewInfo;
  BorderStyle := cxcbsDefault;
  TabStop := True;
  Height := GetDefaultHeight;
  Width := GetDefaultWidth;
  FInplaceEditingController := CreateInplaceEditingController;
  FIncrementalSearchController := CreateIncrementalSearchController;
  FMakeVisibleNode.Item := nil;
  FAccessibleObjects := TList<TcxAccessibilityHelper>.Create;
end;

destructor TdxCustomTreeView.Destroy;
begin
  cxAccessibilityHelperOwnerObjectDestroyed(FIAccessibilityHelper);
  FreeAndNil(FAccessibleObjects);
  FinishEditingTimer;
  if (FEncoding <> nil) and not TEncoding.IsStandardEncoding(FEncoding) then
    FEncoding.Free;
  FreeAndNil(FIncrementalSearchController);
  FreeAndNil(FInplaceEditingController);
  FreeAndNil(FStateImagesChangeLink);
  FreeAndNil(FImagesChangeLink);
  FreeAndNil(FChangeDelayTimer);
  FreeAndNil(FItems);
  FreeAndNil(FAbsoluteVisibleNodes);
  FreeAndNil(FAbsoluteNodes);
  FreeAndNil(FOptionsView);
  FreeAndNil(FPainter);
  FreeAndNil(FOptionsSelection);
  FreeAndNil(FOptionsBehavior);
  FreeAndNil(FSelections);
  FreeAndNil(FViewInfo);
  FreeAndNil(FHintHelper);
  FreeAndNil(FHitTest);
  FreeAndNil(FRoot);
  inherited Destroy;
end;

function TdxCustomTreeView.AlphaSort(ARecurse: Boolean = True): Boolean;
begin
  Result := CustomSort(nil, 0, ARecurse);
end;

// IdxInplaceEditContainer

procedure TdxCustomTreeView.FinishNodeCaptionEditing(AAccept: Boolean = True);
var
  ACaption: string;
begin
  if IsEditing then
  try
    if AAccept then
    begin
      ACaption := InplaceEdit.Value;
      DoEdited(FEditingItem, ACaption);
      if FEditingItem <> nil then  
        FEditingItem.Caption := ACaption;
    end
    else
      DoCancelEdit(FEditingItem);
  finally
    FEditingItem := nil;
    InplaceEdit.Hide;
    Invalidate;
  end;
end;

function TdxCustomTreeView.GetEditingControl: TWinControl;
begin
  Result := Self;
end;

function TdxCustomTreeView.GetNodeCaptionTextColor: TColor;
begin
  Result := LookAndFeelPainter.GetTreeViewNodeTextColor([]);
  if Result = clDefault then
    Result := clWindowText;
end;

procedure TdxCustomTreeView.ValidatePasteText(var AText: string);
begin
end;

// IdxIncrementalSearchOwner

function TdxCustomTreeView.FocusNextItemWithText(const AText: string): Boolean;
var
  I, AStartIndex: Integer;
  ASearchText: string;
begin
  Result := False;
  CheckFocusedObject;
  if FocusedNode <> nil then
  begin
    AStartIndex := FocusedNode.VisibleIndex;
    ASearchText := AText;
    if Length(AText) = 1 then
      Inc(AStartIndex)
    else
      if FIncrementalSearchController.IsRepeat then
        if AnsiStartsText(ASearchText, FocusedNode.Caption) then
        begin
          Result := True;
          Exit;
        end
        else
        begin
          ASearchText := AText[1];
          Inc(AStartIndex);
        end;
    for I := AStartIndex to AbsoluteVisibleCount - 1 do
    begin
      if AnsiStartsText(ASearchText, AbsoluteVisibleItems[I].Caption) then
      begin
        Result := True;
        ChangeFocusedNode(AbsoluteVisibleItems[I], []);
        Exit;
      end;
    end;
    for I := 0 to Min(AStartIndex, AbsoluteVisibleCount - 1) do
    begin
      if AnsiStartsText(ASearchText, AbsoluteVisibleItems[I].Caption) then
      begin
        Result := True;
        ChangeFocusedNode(AbsoluteVisibleItems[I], []);
        Exit;
      end;
    end;
  end;
end;
//

procedure TdxCustomTreeView.Added(ANode: TdxTreeViewNode);
begin
  if not IsLoading and (FNodeAdditionEventLockCount = 0) then
    CallNodeEvent(ANode, FOnAddition);
end;

procedure TdxCustomTreeView.AddNodeToSelection(ANode: TdxTreeViewNode; APosition: Integer = -1);
begin
  if OptionsSelection.MultiSelect and not IsNodeSelected(ANode) and
    DoAddNodeToSelection(ANode, APosition) then
    SelectionChanged;
end;

function TdxCustomTreeView.AllowInfoTips: Boolean;
begin
  Result := False;
end;

function TdxCustomTreeView.AllowTouchScrollUIMode: Boolean;
begin
  Result := not IsDesigning;
end;

procedure TdxCustomTreeView.BeginAddNode;
begin
  Inc(FNodeAdditionEventLockCount);
end;

procedure TdxCustomTreeView.BeforeDestruction;
begin
  inherited;
  Root.Clear;
  Images := nil;
end;

procedure TdxCustomTreeView.BeginUpdate;
begin
  Inc(FLockCount);
end;

function TdxCustomTreeView.CustomSort(ASortProc: TdxTreeViewNodeCompareProc; AData: NativeInt; ARecurse: Boolean = True): Boolean;
begin
  Result := Root.CustomSort(ASortProc, AData, ARecurse);
  MakeVisible(FocusedNode);
end;

procedure TdxCustomTreeView.EndEdit(ACancel: Boolean);
begin
  FinishNodeCaptionEditing(not ACancel);
end;

procedure TdxCustomTreeView.EndUpdate;
begin
  Dec(FLockCount);
  Changed([]);
end;

procedure TdxCustomTreeView.ExpandTo(ANode: TdxTreeViewNode);
begin
  BeginUpdate;
  try
    ANode := ANode.Parent;
    while ANode <> nil do
    begin
      ANode.Expanded := True;
      ANode := ANode.Parent;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomTreeView.FullCollapse;
begin
  Root.Collapse(True);
end;

procedure TdxCustomTreeView.FullExpand;
begin
  Root.Expand(True);
end;

procedure TdxCustomTreeView.FullRefresh;
begin
  Changed([tvcStructure]);
end;

function TdxCustomTreeView.GetNodeAtPos(const P: TPoint; out ANode: TdxTreeViewNode): Boolean;
var
  ANodeIndex: Integer;
begin
  Result := ViewInfo.GetNodeAtPos(P, ANodeIndex);
  if Result then
    ANode := AbsoluteVisibleNodes[ANodeIndex]
  else
    ANode := nil;
end;

function TdxCustomTreeView.GetHitTestAt(X, Y: Integer): TdxTreeViewHitTest;
begin
  CalculateHitTest(X, Y);
  Result := HitTest;
end;

function TdxCustomTreeView.IsEditing: Boolean;
begin
  Result := HandleAllocated and (FEditingItem <> nil) and InplaceEdit.IsVisible;
end;

procedure TdxCustomTreeView.MakeVisible(ANode: TdxTreeViewNode);
begin
  if (ANode <> nil) and not ANode.IsRoot and ANode.Visible then
  begin
    FMakeVisibleNode.Item := ANode;
    FMakeVisibleNode.Mode := mvmMakeVisible;
    Changed([]);
  end;
end;

procedure TdxCustomTreeView.ScrollBy(ADeltaX, ADeltaY: Integer);
begin
  UpdateViewPort(cxPointOffset(ViewInfo.ViewPort, ADeltaX, ADeltaY));
end;

procedure TdxCustomTreeView.LoadFromFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxCustomTreeView.LoadFromFile(const AFileName: string; AEncoding: TEncoding);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(AStream, AEncoding);
  finally
    AStream.Free;
  end;
end;

procedure TdxCustomTreeView.LoadFromStream(AStream: TStream);
begin
  LoadFromStream(AStream, nil);
end;

procedure TdxCustomTreeView.LoadFromStream(AStream: TStream; AEncoding: TEncoding);
begin
  LoadTreeFromStream(AStream, AEncoding);
end;

procedure TdxCustomTreeView.SaveToFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxCustomTreeView.SaveToFile(const AFileName: string; AEncoding: TEncoding);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(AStream, AEncoding);
  finally
    AStream.Free;
  end;
end;

procedure TdxCustomTreeView.SaveToStream(AStream: TStream);
begin
  SaveToStream(AStream, FEncoding);
end;

procedure TdxCustomTreeView.SaveToStream(AStream: TStream; AEncoding: TEncoding);
begin
  SaveTreeToStream(AStream, AEncoding);
end;

procedure TdxCustomTreeView.LoadDataFromFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadDataFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxCustomTreeView.LoadDataFromStream(AStream: TStream);
begin
  ReadData(AStream);
end;

procedure TdxCustomTreeView.SaveDataToFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveDataToStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxCustomTreeView.SaveDataToStream(AStream: TStream);
begin
  WriteData(AStream);
end;

procedure TdxCustomTreeView.BeginSelect;
begin
  Inc(FLockSelectionCount);
end;

procedure TdxCustomTreeView.ClearSelection(AKeepPrimary: Boolean = False);
begin
  if OptionsSelection.MultiSelect and (SelectionCount > 0) then
  begin
    FSelectionAnchor := nil;
    DoSelectionOperation(
      procedure
      begin
        FSelections.Clear;
        if AKeepPrimary and (FocusedNode <> nil) then
          DoAddNodeToSelection(FocusedNode);
      end
    );
  end;
end;

procedure TdxCustomTreeView.Deselect(ANode: TdxTreeViewNode);
begin
  if not OptionsSelection.MultiSelect then
    Exit;
  if FSelections.Remove(ANode) <> - 1 then
    SelectionChanged;
end;

procedure TdxCustomTreeView.Deselect(const ANodes: array of TdxTreeViewNode);
var
  AList: TList;
  I: Integer;
begin
  if not OptionsSelection.MultiSelect then
    Exit;
  AList := TList.Create;
  try
    for I := Low(ANodes) to High(ANodes) do
      AList.Add(ANodes[I]);
    Deselect(AList);
  finally
    AList.Free;
  end;
end;

procedure TdxCustomTreeView.Deselect(ANodes: TList);
begin
  if OptionsSelection.MultiSelect then
    DoSelectionOperation(
      procedure
      var
        I: Integer;
      begin
        for I := 0 to ANodes.Count - 1 do
          FSelections.Remove(ANodes[I]);
      end
    );
end;

procedure TdxCustomTreeView.EndSelect;
begin
  Dec(FLockSelectionCount);
  if (FLockSelectionCount = 0) and FIsSelectionChanged then
    SelectionChanged;
end;

procedure TdxCustomTreeView.GetSelectedData(AList: TList);
var
  I: Integer;
begin
  AList.Clear;
  for I := 0 to SelectionCount - 1 do
    AList.Add(Selections[I].Data);
end;

function TdxCustomTreeView.GetSelections(AList: TList): TdxTreeViewNode;
var
  I: Integer;
begin
  AList.Clear;
  for I := 0 to SelectionCount - 1 do
    AList.Add(Selections[I]);
  Result := Selected;
end;

function TdxCustomTreeView.GetTopItem: TdxTreeViewNode;
begin
  if (FChanges * [tvcLayout, tvcStructure, tvcViewPort] = []) and (AbsoluteVisibleNodes.Count > 0) then
    Result := AbsoluteVisibleItems[ViewInfo.FirstVisibleIndex]
  else
    Result := nil;
end;

procedure TdxCustomTreeView.Select(ANode: TdxTreeViewNode; AShift: TShiftState = []; ASyncFocused: Boolean = True);
begin
  if not OptionsSelection.MultiSelect then
    Exit;
  if (ANode <> nil) and ANode.Visible then
  begin
    BeginSelect;
    try
      ExpandTo(ANode);
      DoSelect(ANode, AShift);
      if ASyncFocused and (Selected <> nil) then
        Selected.Focused := True;
    finally
      EndSelect;
    end;
  end;
end;

procedure TdxCustomTreeView.Select(const ANodes: array of TdxTreeViewNode; ASyncFocused: Boolean = True);
var
  AList: TList;
  I: Integer;
begin
  if not OptionsSelection.MultiSelect then
    Exit;
  AList := TList.Create;
  try
    for I := Low(ANodes) to High(ANodes) do
      AList.Add(ANodes[I]);
    Select(AList, ASyncFocused);
  finally
    AList.Free;
  end;
end;

procedure TdxCustomTreeView.Select(ANodes: TList; ASyncFocused: Boolean = True);
begin
  if OptionsSelection.MultiSelect then
  begin
    if ANodes.Count = 0 then
      ClearSelection
    else
      DoSelectionOperation(
        procedure
        var
          I: Integer;
        begin
          FSelections.Clear;
          for I := 0 to ANodes.Count - 1 do
            if not IsNodeSelected(ANodes[I]) then
              DoAddNodeToSelection(ANodes[I]);
          if ASyncFocused and (Selected <> nil) then
            Selected.Focused := True;
          DoValidateSelection;
        end
      );
  end;
end;

procedure TdxCustomTreeView.Subselect(ANode: TdxTreeViewNode; AValidate: Boolean = False);
begin
  if not OptionsSelection.MultiSelect then
    raise EdxTreeViewException.Create('Multi select required')
  else
    DoSelectionOperation(
      procedure
      begin
        ANode.Selected := True;
        if AValidate then
          DoValidateSelection;
      end
    );
end;

procedure TdxCustomTreeView.BoundsChanged;
begin
  FinishNodeCaptionEditing;
  inherited BoundsChanged;
  Changed([tvcLayout]);
end;

function TdxCustomTreeView.CanFocusNode(ANode: TdxTreeViewNode): Boolean;
begin
  Result := True;
  if (ANode <> nil) and Assigned(FOnCanFocusNode) then
    FOnCanFocusNode(Self, ANode, Result);
end;

function TdxCustomTreeView.CanSelectNode(ANode: TdxTreeViewNode): Boolean;
begin
  Result := True;
  if (ANode <> nil) and Assigned(FOnCanSelectNode) then
    FOnCanSelectNode(Self, ANode, Result);
end;

procedure TdxCustomTreeView.Changed(AChanges: TdxTreeViewChanges);
begin
  FChanges := FChanges + AChanges;
  if tvcStructure in FChanges then
  begin
    FIsAbsoluteNodesValid := False; 
    FIsAbsoluteVisibleNodesValid := False;
  end;
  if not IsUpdateLocked then
  begin
    if not IsDestroying then
    begin
      if (FMakeVisibleNode.Item <> nil) and (FMakeVisibleNode.Mode <> mvmJustExpanded) then
      begin
        Inc(FLockCount);
        try
          ExpandTo(FMakeVisibleNode.Item);
        finally
          Dec(FLockCount);
        end;
      end;
      ProcessChanges(FChanges);
    end
    else
      FChanges := [];
  end;
end;

procedure TdxCustomTreeView.ChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  FinishNodeCaptionEditing;
  inherited;
  OptionsView.ChangeScale(M, D);
end;

procedure TdxCustomTreeView.CheckAbsoluteNodes;
begin
  if not FIsAbsoluteNodesValid then
  begin
    FAbsoluteNodes.Clear;
    dxTreeForEach(Root,
      function(ANode: TdxTreeCustomNode; AData: Pointer): Boolean
      begin
        Result := True;
        if not ANode.IsRoot then
        begin
          TdxTreeViewNode(ANode).FAbsoluteIndex := FAbsoluteNodes.Add(ANode);
        end;
      end, nil);
    FIsAbsoluteNodesValid := True;
  end;
end;

procedure TdxCustomTreeView.CheckHint;
begin
  HintHelper.CheckHint;
end;

function TdxCustomTreeView.CreateHintHelper: TdxCustomTreeViewHintHelper;
begin
  Result := TdxCustomTreeViewHintHelper.Create(Self);
end;

function TdxCustomTreeView.CreateHitTest: TdxTreeViewHitTest;
begin
  Result := TdxTreeViewHitTest.Create(Self);
end;

function TdxCustomTreeView.CreateIncrementalSearchController: TdxTreeViewIncrementalSearchController;
begin
  Result := TdxTreeViewIncrementalSearchController.Create(Self);
end;

function TdxCustomTreeView.CreateInplaceEditingController: TdxTreeViewInplaceEditingController;
begin
  Result := TdxTreeViewInplaceEditingController.Create(Self);
end;

function TdxCustomTreeView.CreateOptionsBehavior: TdxTreeViewCustomOptionsBehavior;
begin
  Result := TdxTreeViewCustomOptionsBehavior.Create(Self);
end;

function TdxCustomTreeView.CreateOptionsSelection: TdxTreeViewCustomOptionsSelection;
begin
  Result := TdxTreeViewCustomOptionsSelection.Create(Self);
end;

function TdxCustomTreeView.CreateOptionsView: TdxTreeViewCustomOptionsView;
begin
  Result := TdxTreeViewCustomOptionsView.Create(Self);
end;

function TdxCustomTreeView.CreatePainter: TdxTreeViewPainter;
begin
  Result := TdxTreeViewPainter.Create(Self);
end;

function TdxCustomTreeView.CreateViewInfo: TdxTreeViewViewInfo;
begin
  Result := TdxTreeViewViewInfo.Create(Self);
end;

procedure TdxCustomTreeView.DoCancelEdit(ANode: TdxTreeViewNode);
begin
  if Assigned(FOnCancelEdit) then
    OnCancelEdit(Self, ANode);
end;

procedure TdxCustomTreeView.DoCancelMode;
begin
  FinishEditingTimer;
  FinishNodeCaptionEditing(False);
  inherited DoCancelMode;
  if HasHottrack then
    HottrackItem := nil;
end;

function TdxCustomTreeView.DoCustomDraw(ACanvas: TcxCanvas; AViewInfo: TdxTreeViewViewInfo): Boolean;
begin
  Result := False;
  if Assigned(OnCustomDraw) then
    OnCustomDraw(Self, ACanvas, AViewInfo, Result);
end;

function TdxCustomTreeView.DoCustomDrawNode(ACanvas: TcxCanvas; ANodeViewInfo: TdxTreeViewNodeViewInfo): Boolean;
begin
  Result := False;
  if Assigned(OnCustomDrawNode) then
    OnCustomDrawNode(Self, ACanvas, ANodeViewInfo, Result);
end;

procedure TdxCustomTreeView.DoEdited(ANode: TdxTreeViewNode; var ACaption: string);
begin
  if Assigned(FOnEdited) then
    FOnEdited(Self, ANode, ACaption);
end;

procedure TdxCustomTreeView.DoFocusedNodeChanged;
begin
  CallNotify(OnFocusedNodeChanged, Self);
end;

procedure TdxCustomTreeView.DoSelectNodeByMouse(ANode: TdxTreeViewNode; AShift: TShiftState; AHitAtCheckBox: Boolean);
var
  AOldFocusedNode: TdxTreeViewNode;
  ATempNode: TdxTreeViewNode;
begin
  AOldFocusedNode := FocusedNode;
  ChangeFocusedNode(ANode, AShift);
  if OptionsBehavior.AutoExpand and (ANode <> nil) and not AHitAtCheckBox and
    (not OptionsSelection.MultiSelect or (AShift * [ssCtrl, ssShift] = [])) then
  begin
    if (AOldFocusedNode <> nil) and (AOldFocusedNode <> ANode) and not (ssCtrl in AShift) then
    begin
      ATempNode := AOldFocusedNode;
      while (ATempNode <> nil) and not ANode.HasAsParent(ATempNode) and (ATempNode <> ANode) do
      begin
        ATempNode.Collapse;
        ATempNode := ATempNode.Parent;
      end;
    end;
    ANode.Expanded := not ANode.Expanded;
  end;
end;

procedure TdxCustomTreeView.DoValidateSelection;
var
  I: Integer;
  AParent: TdxTreeViewNode;
begin
  if SelectionCount = 0 then
    Exit;
  AParent := Selections[0].Parent;
  for I := SelectionCount - 1 downto 0 do
    if (msSiblingOnly in OptionsSelection.MultiSelectStyle) and (AParent <> Selections[I].Parent) or
      (msVisibleOnly in OptionsSelection.MultiSelectStyle) and (AbsoluteVisibleNodes.IndexOf(Selections[I]) = -1) then
      FSelections.Remove(Selections[I]);
end;

procedure TdxCustomTreeView.EndAddNode(ANode: TdxTreeViewNode);
begin
  Dec(FNodeAdditionEventLockCount);
  if FNodeAdditionEventLockCount = 0 then
    Added(ANode);
end;

procedure TdxCustomTreeView.DoNodeExpandStateChanged(ANode: TdxTreeViewNode);
begin
  if not ANode.Expanded and OptionsSelection.MultiSelect and
    (msVisibleOnly in OptionsSelection.MultiSelectStyle) then
    ValidateSelection;
end;

procedure TdxCustomTreeView.DoPaint;
begin
  inherited DoPaint;
  ViewInfo.Draw(Canvas);
end;

procedure TdxCustomTreeView.DoSelect(ANode: TdxTreeViewNode; AShift: TShiftState = []);
begin
  if not OptionsSelection.MultiSelect then
    Exit;
  if ANode <> nil then
    DoSelectionOperation(
      procedure
      var
        ASelectionBefore: TdxFastList;
      begin
        if not (msControlSelect in OptionsSelection.MultiSelectStyle) then
          Exclude(AShift, ssCtrl);
        if not (msShiftSelect in OptionsSelection.MultiSelectStyle) then
          Exclude(AShift, ssShift);

        if AShift * [ssCtrl, ssShift] = [] then
        begin
          FSelectionAnchor := ANode;
          FSelections.Clear;
          DoAddNodeToSelection(ANode);
        end
        else
          if AShift * [ssCtrl, ssShift] = [ssCtrl] then
          begin
            FSelectionAnchor := ANode;
            if (SelectionCount > 0) and (msSiblingOnly in OptionsSelection.MultiSelectStyle) and
              (Selections[0].Parent <> ANode.Parent) then
              FSelections.Clear;
            if ANode.Selected then
              FSelections.Remove(ANode)
            else
              DoAddNodeToSelection(ANode, 0);
          end
          else
            if ssShift in AShift then
            begin
              if (ssCtrl in AShift) and (SelectionCount > 0) then
                ASelectionBefore := TdxFastList.Create
              else
                ASelectionBefore := nil;
              try
                if ASelectionBefore <> nil then
                  ASelectionBefore.Assign(FSelections);
                if FSelectionAnchor = nil then
                  FSelectionAnchor := FFocusedNode;
                if FSelectionAnchor <> nil then
                  SelectVisibleRange(FSelectionAnchor, ANode);
                if (ASelectionBefore <> nil) and
                 ((SelectionCount = 0) or not (msSiblingOnly in OptionsSelection.MultiSelectStyle) or
                  (TdxTreeViewNode(ASelectionBefore[0]).Parent = Selections[0].Parent)) then
                  FSelections.Assign(ASelectionBefore, laOr);
              finally
                if ASelectionBefore <> nil then
                  ASelectionBefore.Free;
              end;
            end;
      end);
end;

procedure TdxCustomTreeView.DoSelectionChanged;
begin
  CallNotify(OnSelectionChanged, Self);
end;

procedure TdxCustomTreeView.FocusEnter;
begin
  if (FocusedNode = nil) and (ActivateType <> atByMouse) then  
    Selected := TopItem;
  Invalidate;
  inherited FocusEnter;
end;

procedure TdxCustomTreeView.FocusLeave;
begin
  Invalidate;
  inherited FocusLeave;
end;

procedure TdxCustomTreeView.FontChanged;
begin
  inherited FontChanged;
  Canvas.Font := Font;
  Changed([tvcLayout]);
end;

function TdxCustomTreeView.GetDefaultHeight: Integer;
begin
  Result := dxDefaultHeight;
end;

function TdxCustomTreeView.GetDefaultWidth: Integer;
begin
  Result := dxDefaultWidth;
end;

function TdxCustomTreeView.GetImageIndex(ANode: TdxTreeViewNode): Integer;
begin
  Result := ANode.ImageIndex;
  DoGetImageIndex(ANode, Result);
end;

function TdxCustomTreeView.GetSelectedImageIndex(ANode: TdxTreeViewNode): Integer;
begin
  Result := ANode.SelectedImageIndex;
  DoGetSelectedImageIndex(ANode, Result);
end;

function TdxCustomTreeView.GetNodeClass: TdxTreeViewNodeClass;
begin
  Result := TdxTreeViewNode;
end;

function TdxCustomTreeView.GetNodeTextRect(ANode: TdxTreeViewNode): TRect;
var
  ABounds, R: TRect;
  ATextOffset, AOrigin: TPoint;
begin
  ABounds := GetNodeBounds(ANode);
  if ABounds.IsEmpty then
    Result.Empty
  else
  begin
    ViewInfo.NodeViewInfo.SetData(ANode);
    try
      R := ViewInfo.NodeViewInfo.Bounds;
      Result := ViewInfo.NodeViewInfo.TextRect;
      if UseRightToLeftAlignment then
        ATextOffset := Point(-Result.Right + R.Right - ViewInfo.NodeViewInfo.LevelOffset, Result.Top - R.Top)
      else
        ATextOffset := Point(Result.Left - R.Left + ViewInfo.NodeViewInfo.LevelOffset, Result.Top - R.Top);

      if UseRightToLeftAlignment then
        AOrigin.X := ABounds.Right - ATextOffset.X - Result.Width
      else
        AOrigin.X := ABounds.Left + ATextOffset.X;
      AOrigin.Y := ABounds.Top + ATextOffset.Y;
      Result := cxRectSetOrigin(Result, AOrigin);
    finally
      ViewInfo.NodeViewInfo.SetData(nil);
    end;
  end;
end;

function TdxCustomTreeView.GetScrollContentForegroundColor: TColor;
begin
  Result := LookAndFeelPainter.GetTreeViewNodeTextColor([]);
end;

function TdxCustomTreeView.HasGroups: Boolean;
begin
  Result := False;
end;

procedure TdxCustomTreeView.InitScrollBarsParameters;
begin
  SetScrollBarInfo(sbHorizontal, 0, ViewInfo.ContentSize.cx - 1,
    ViewInfo.NodeViewInfo.Height, cxRectWidth(ViewInfo.ContentRect), ViewInfo.ViewPort.X, True, True);
  SetScrollBarInfo(sbVertical, 0, ViewInfo.ContentSize.cy - 1,
    ViewInfo.NodeViewInfo.Height, cxRectHeight(ViewInfo.ContentRect), ViewInfo.ViewPort.Y, True, True);
end;

function TdxCustomTreeView.IsExplorerStyle: Boolean;
begin
  Result := False;
end;

function TdxCustomTreeView.IsNodeSelected(ANode: TdxTreeViewNode): Boolean;
begin
  Result := FSelections.IndexOf(ANode) <> -1;
end;

function TdxCustomTreeView.IsUpdateLocked: Boolean;
begin
  Result := FLockCount > 0;
end;

procedure TdxCustomTreeView.LoadTreeFromStream(AStream: TStream; AEncoding: TEncoding);

  procedure UpdateEncoding(AValue: TEncoding);
  begin
    if not TEncoding.IsStandardEncoding(FEncoding) then
      FEncoding.Free;
    if TEncoding.IsStandardEncoding(AValue) then
      FEncoding := AValue
    else
      if AValue <> nil then
        FEncoding := AValue.Clone
      else
        FEncoding := TEncoding.Default;
  end;

  function FindCaption(ABuffer: PChar; var ALevel: Integer): PChar;
  begin
    ALevel := 0;
    while CharInSet(ABuffer^, [' ', dxTab]) do
    begin
      Inc(ABuffer);
      Inc(ALevel);
    end;
    Result := ABuffer;
  end;

var
  AList: TStringList;
  ANode, ANextNode: TdxTreeViewNode;
  ALevel, I: Integer;
  ACaption: string;
begin
  AList := TStringList.Create;
  BeginUpdate;
  try
    Root.Clear;
    AList.LoadFromStream(AStream, AEncoding);
    UpdateEncoding(AList.Encoding);
    ANode := nil;
    for I := 0 to AList.Count - 1 do
    begin
      ACaption := FindCaption(PChar(AList[I]), ALevel);
      if ANode = nil then
        ANode := Root.AddChild(ACaption)
      else
       if ANode.Level = ALevel then
         ANode := ANode.Parent.AddChild(ACaption)
       else
         if ANode.Level = (ALevel - 1) then
            ANode := ANode.AddChild(ACaption)
          else
            if ANode.Level > ALevel then
            begin
              ANextNode := ANode.Parent;
              while ANextNode.Level > ALevel do
                ANextNode := ANextNode.Parent;
              ANode := ANextNode.Parent.AddChild(ACaption);
            end
            else
              raise EdxTreeViewException.CreateFmt('Invalid level (%d) for item "%s"', [ALevel, ACaption]);
    end;
  finally
    EndUpdate;
    AList.Free;
  end;
end;

procedure TdxCustomTreeView.LookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  inherited;
  FullRefresh;
end;

procedure TdxCustomTreeView.MultiSelectStyleChanged;
begin
  if OptionsSelection.MultiSelect and (SelectionCount <> 0) then
    ValidateSelection;
end;

procedure TdxCustomTreeView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if Images = AComponent then
      Images := nil
    else
      if StateImages = AComponent then
        StateImages := nil;
end;

procedure TdxCustomTreeView.NodeStateChanged(ANode: TdxTreeViewNode);
begin
  CallNodeEvent(ANode, OnNodeStateChanged);
end;

procedure TdxCustomTreeView.ProcessChanges(AChanges: TdxTreeViewChanges);

  function CalculateMakeVisibleDelta(const ARect: TRect): Integer;
  begin
    if ARect.Top < ViewInfo.ContentRect.Top then
      Result := ARect.Top - ViewInfo.ContentRect.Top
    else
      if ARect.Bottom > ViewInfo.ContentRect.Bottom then
        Result := Min(ARect.Bottom - ViewInfo.ContentRect.Bottom, ARect.Top - ViewInfo.ContentRect.Top)
      else
        Result := 0;
  end;

  function IsNextVisibleChildExists(ANode: TdxTreeViewNode; AIndex: Integer): Boolean;
  begin
    Result := (AIndex < FAbsoluteVisibleNodes.Count) and AbsoluteVisibleItems[AIndex].HasAsParent(ANode);
  end;

var
  ANode: TdxTreeViewNode;
  R: TRect;
  AExpandNodeVisibleIndex, AChildNodeVisibleIndex: Integer;
  ADelta, AMaxVisibleChildCount: Integer;
begin
  FChanges := [];
  if tvcStructure in AChanges then
  begin
    UpdateAbsoluteVisibleNodes;
    Include(AChanges, tvcLayout);
  end;
  if tvcLayout in AChanges then
  begin
    ViewInfo.Calculate(ClientBounds);
    if UseRightToLeftAlignment then
      ViewInfo.RightToLeftConversion(ClientBounds);
    ViewInfo.CheckViewPort;
    Include(AChanges, tvcViewPort);
  end;
  if (FMakeVisibleNode.Item <> nil) and FMakeVisibleNode.Item.IsVisible then
  begin
    ANode := FMakeVisibleNode.Item;
    R := ANode.DisplayRect(False);

    if FMakeVisibleNode.Mode = mvmJustExpanded then
    begin
      ADelta := R.Top - ViewInfo.ContentRect.Top;
      if ADelta <= 0 then
        ViewInfo.ViewPort := cxPointOffset(ViewInfo.ViewPort, 0, ADelta)
      else
      begin
        AExpandNodeVisibleIndex := ANode.VisibleIndex;
        AMaxVisibleChildCount := ViewInfo.NumberOfNodesInContentRect - 1;
        AChildNodeVisibleIndex := AExpandNodeVisibleIndex + 1;
        while IsNextVisibleChildExists(ANode, AChildNodeVisibleIndex) and ((AChildNodeVisibleIndex - AExpandNodeVisibleIndex) <= AMaxVisibleChildCount) do
          Inc(AChildNodeVisibleIndex);

        if (AChildNodeVisibleIndex - AExpandNodeVisibleIndex) < AMaxVisibleChildCount then
        begin
          FMakeVisibleNode.Mode := mvmMakeVisible;
          FMakeVisibleNode.Item := AbsoluteVisibleItems[AChildNodeVisibleIndex - 1];
          ANode := FMakeVisibleNode.Item;
          R := ANode.DisplayRect(False);
        end
        else
          ViewInfo.ViewPort := cxPointOffset(ViewInfo.ViewPort, 0, ADelta);
      end;
      Include(AChanges, tvcViewPort);
    end;

    if (FMakeVisibleNode.Mode in [mvmMakeVisible, mvmMakeTop]) then
    begin
      if FMakeVisibleNode.Mode = mvmMakeTop then
        ViewInfo.ViewPort := cxPointOffset(ViewInfo.ViewPort, 0, R.Top - ViewInfo.ContentRect.Top)
      else
        ViewInfo.ViewPort := cxPointOffset(ViewInfo.ViewPort, 0, CalculateMakeVisibleDelta(R));
      Include(AChanges, tvcViewPort);
    end;
  end;
  if tvcViewPort in AChanges then
  begin
    ViewPortChanged;
    UpdateScrollBars; 
    Include(AChanges, tvcContent);
  end;
  if tvcContent in AChanges then
    Invalidate;

  FMakeVisibleNode.Item := nil;
end;

procedure TdxCustomTreeView.SaveTreeToStream(AStream: TStream; AEncoding: TEncoding);
var
  ANodeStr: TStringBuilder;
  APreamble: TBytes;
begin
  if Root.Count > 0 then
  begin
    if AEncoding = nil then
      AEncoding := TEncoding.Default;
    APreamble := AEncoding.GetPreamble;
    if Length(APreamble) > 0 then
      AStream.WriteBuffer(APreamble[0], Length(APreamble));

    ANodeStr := TStringBuilder.Create(1024);
    try
      dxTreeForEach(Root,
        function(ANode: TdxTreeCustomNode; AData: Pointer): Boolean
        var
          I: Integer;
          ABuffer: TBytes;
        begin
          Result := True;
          if ANode.IsRoot then
            Exit;
          ANodeStr.Length := 0;
          for I := 0 to ANode.Level - 1 do
            ANodeStr.Append(dxTab);
          ANodeStr.Append(TdxTreeViewNode(ANode).Caption);
          ANodeStr.Append(dxCRLF);
          ABuffer := AEncoding.GetBytes(ANodeStr.ToString);
          AStream.Write(ABuffer[0], Length(ABuffer));
        end, nil);
    finally
      ANodeStr.Free;
    end;
  end;
end;

procedure TdxCustomTreeView.Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer);

  function GetScrollPos(AStartPos, AStep, AMax: Integer): Integer;
  const
    AInc: array[Boolean] of Integer = (-1, 1);
  begin
    if AScrollCode in [scLineDown, scLineUp] then
        AScrollPos := AStartPos + AInc[AScrollCode = scLineDown] * AStep;
    Result := AScrollPos;
  end;

var
  P: TPoint;
begin
  if AScrollCode = scEndScroll then
    Exit;
  FinishNodeCaptionEditing;
  if AScrollBarKind = sbVertical then
    P := Point(ViewInfo.ViewPort.X, GetScrollPos(ViewInfo.ViewPort.Y, ViewInfo.NodeViewInfo.Height, ViewInfo.ContentSize.cy - 1))
  else
    P := Point(GetScrollPos(ViewInfo.ViewPort.X, ViewInfo.NodeViewInfo.Height, ViewInfo.ContentSize.cx - 1), ViewInfo.ViewPort.Y);
  UpdateViewPort(P);
end;

procedure TdxCustomTreeView.SelectVisibleRange(AStartNode, AFinishNode: TdxTreeViewNode);

  procedure AddChildrenToSelection(ANode: TdxTreeViewNode);
  begin
    if ANode.HasChildren and ANode.Visible then
    begin
      ANode := ANode.First;
      if ANode <> nil then
      begin
        repeat
          DoAddNodeToSelection(ANode);
          AddChildrenToSelection(ANode);
          ANode := ANode.Next;
        until ANode = nil;
      end;
    end;
  end;

  function GetNodeVisibleIndex(ANode: TdxTreeViewNode; out AIndex: Integer): Boolean;
  begin
    AIndex := FAbsoluteVisibleNodes.IndexOf(ANode);
    Result := AIndex <> -1;
  end;

var
  I: Integer;
  ANode: TdxTreeViewNode;
  AIndex1, AIndex2: Integer;
  AExchange: Boolean;
begin
  if (AStartNode = nil) or (AFinishNode = nil) or not GetNodeVisibleIndex(AStartNode, AIndex1) or
    not GetNodeVisibleIndex(AFinishNode, AIndex2) then
    Exit;
  AExchange := AIndex1 > AIndex2;
  if AExchange then
    ExchangeIntegers(AIndex1, AIndex2);
  FSelections.Clear;
  for I := AIndex1 to AIndex2 do
  begin
    ANode := TdxTreeViewNode(FAbsoluteVisibleNodes[I]);
    if not (msSiblingOnly in OptionsSelection.MultiSelectStyle) or (ANode.Parent = AFinishNode.Parent) then
    begin
      DoAddNodeToSelection(ANode);
      if not (msSiblingOnly in OptionsSelection.MultiSelectStyle) and
        not (msVisibleOnly in OptionsSelection.MultiSelectStyle) and
        not ANode.Expanded and (I < AIndex2) then
        AddChildrenToSelection(ANode);
    end;
  end;
  if not AExchange then
    FSelections.Reverse;
end;

function TdxCustomTreeView.ShowFirstLevelNodes: Boolean;
begin
  Result := True;
end;

procedure TdxCustomTreeView.ShowInplaceEdit(ANode: TdxTreeViewNode; const ABounds: TRect; const AText: string;
  AFont: TFont; ASelStart, ASelLength: Integer; AMaxLength: Integer);
begin
  InplaceEdit.Show(Self, ABounds, AText, AFont, ASelStart, ASelLength, AMaxLength);
end;

procedure TdxCustomTreeView.SortTypeChanged;
begin
  if ((OptionsBehavior.SortType in [stData, stBoth]) and Assigned(OnCompare)) or
    (OptionsBehavior.SortType in [stText, stBoth]) then
    AlphaSort(True);
end;

procedure TdxCustomTreeView.UpdateAbsoluteVisibleNodes;

  procedure PopulateLevel(ANode: TdxTreeViewNode);
  begin
    ANode := ANode.First;
    while ANode <> nil do
    begin
      if ANode.Visible then
      begin
        FAbsoluteVisibleNodes.Add(ANode);
        ANode.FGroupIndex := ANode.Parent.FGroupIndex;
        if ANode.Expanded then
          PopulateLevel(ANode);
      end;
      ANode := ANode.Next;
    end;
  end;

  function IsTopLevelVisibleNode(ANode: TdxTreeViewNode): Boolean;
  begin
    Result := not ANode.IsRoot and
      (ShowFirstLevelNodes and ANode.Parent.IsRoot or
      not ANode.Parent.IsRoot and not ShowFirstLevelNodes and ANode.Parent.Parent.IsRoot);
  end;

  procedure PopulateFirstVisibleLevel(ANode: TdxTreeViewNode; var AGroupIndex: Integer);
  var
    AIndex: Integer;
  begin
    if not HasGroups then
      PopulateLevel(ANode)
    else
    begin
      ANode := ANode.First;
      while ANode <> nil do
      begin
        if ANode.Visible then
        begin
          AIndex := FAbsoluteVisibleNodes.Add(ANode);
          ANode.FGroupIndex := AGroupIndex;
          if ANode.Expanded then
            PopulateLevel(ANode);
          SetLength(FGroupNodeCounts, AGroupIndex + 1);
          FGroupNodeCounts[AGroupIndex] := FAbsoluteVisibleNodes.Count - AIndex;
          Inc(AGroupIndex);
        end;
        ANode := ANode.Next;
      end;
    end;
  end;

var
  ANode: TdxTreeViewNode;
  AGroupIndex: Integer;
begin
  if not FIsAbsoluteVisibleNodesValid then
  begin
    FAbsoluteVisibleNodes.Count := 0;
    SetLength(FGroupNodeCounts, 0);
    AGroupIndex := 0;
    if ShowFirstLevelNodes then
      PopulateFirstVisibleLevel(Root, AGroupIndex)
    else
    begin
      ANode := Root.First;
      while ANode <> nil do
      begin
        if ANode.Visible and ANode.Expanded then
          PopulateFirstVisibleLevel(ANode, AGroupIndex);
        ANode := ANode.Next;
      end
    end;
    FIsAbsoluteVisibleNodesValid := True;
  end;
end;

procedure TdxCustomTreeView.UpdateChangeDelayTimer;
begin
  if OptionsBehavior.ChangeDelay > 0 then
    FChangeDelayTimer.Interval := OptionsBehavior.ChangeDelay
  else
    FChangeDelayTimer.Enabled := False;
end;

procedure TdxCustomTreeView.UpdateViewPort(const P: TPoint);
begin
  ViewInfo.ViewPort := P;
  Changed([tvcViewPort]);
end;

procedure TdxCustomTreeView.ValidateSelection;
begin
  if OptionsSelection.MultiSelect then
    DoSelectionOperation(
      procedure
      begin
        DoValidateSelection;
      end
    );
end;

procedure TdxCustomTreeView.ViewPortChanged;
begin
  HintHelper.CancelHint;
end;

function TdxCustomTreeView.AllowActivateEditByMouse: Boolean;
begin
  Result := not OptionsBehavior.AutoExpand;
end;

function TdxCustomTreeView.CanEdit(ANode: TdxTreeViewNode): Boolean;
begin
  Result := OptionsBehavior.CaptionEditing and not OptionsBehavior.ReadOnly;
  if Assigned(FOnEditing) then
    FOnEditing(Self, ANode, Result);
end;

procedure TdxCustomTreeView.Edit(ANode: TdxTreeViewNode; const AText: string);
var
  ATextRect: TRect;
  AOffset: Integer;
begin
  if ANode = FocusedNode then
    MakeVisible(ANode)
  else
    FocusedNode := ANode;
  ATextRect := ANode.DisplayRect(True);
  AOffset := 0;

  if UseRightToLeftAlignment then
  begin
    if (ATextRect.Left < ClientBounds.Left) or (ATextRect.Width > ClientBounds.Width) then
      AOffset := ClientBounds.Left - ATextRect.Left
    else
      if (ATextRect.Right > ClientBounds.Right) then
        AOffset := ClientBounds.Right - ATextRect.Right;
  end
  else
    if (ATextRect.Right > ClientBounds.Right) or (ATextRect.Width > ClientBounds.Width) then
      AOffset := ATextRect.Right - ClientBounds.Right
    else
      if (ATextRect.Left < ClientBounds.Left) then
        AOffset := ATextRect.Left - ClientBounds.Left;

  if AOffset <> 0 then
  begin
    ScrollBy(AOffset, 0);
    ATextRect := ANode.DisplayRect(True);
    ATextRect.Intersect(ClientBounds);
  end;

  ShowInplaceEdit(ANode, ATextRect, AText, Font, 0, MaxInt, 0);
  FEditingItem := ANode;
end;

function TdxCustomTreeView.GetEditingText(ANode: TdxTreeViewNode): string;
begin
  Result := ANode.Caption;
  if Assigned(FOnGetEditingText) then
    FOnGetEditingText(Self, ANode, Result);
end;

procedure TdxCustomTreeView.InplaceEditKeyPress(Sender: TObject; var AKey: Char);
begin
end;

function TdxCustomTreeView.StartItemCaptionEditing(ANode: TdxTreeViewNode): Boolean;
begin
  if ANode = nil then
    Exit(False);
  Result := CanEdit(ANode);
  if Result then
    Edit(ANode, GetEditingText(ANode));
end;

function TdxCustomTreeView.CheckFocusedObject: Boolean;
var
  I: Integer;
begin
  Result := FocusedNode <> nil;
  if not Result and (AbsoluteVisibleNodes.Count > 0) then
  begin
    if SelectionCount > 0 then
      FocusedNode := Selections[0];
    if FocusedNode = nil then
      for I := 0 to AbsoluteVisibleNodes.Count - 1 do
      begin
        FocusedNode := AbsoluteVisibleNodes[I];
        if FocusedNode <> nil then
        begin
          DoSelect(FocusedNode, []);
          Break;
        end;
      end;
  end;
end;

procedure TdxCustomTreeView.KeyDown(var Key: Word; Shift: TShiftState);

  procedure InternalSetFocusedNode(ANode: TdxTreeViewNode);
  begin
    if [ssShift, ssCtrl] * Shift = [ssCtrl] then
      FocusedNode := ANode
    else
      ChangeFocusedNode(ANode, Shift);
  end;

  procedure SelectNextNode(ASkipFactor: Integer);
  var
    AIndex: Integer;
  begin
    if CheckFocusedObject then
    begin
      AIndex := AbsoluteVisibleNodes.IndexOf(FocusedNode);
      AIndex := Max(0, Min(AIndex + ASkipFactor, AbsoluteVisibleNodes.Count - 1));
      InternalSetFocusedNode(AbsoluteVisibleNodes[AIndex]);
    end;
  end;

  procedure ExpandAll(ANode: TdxTreeViewNode);
  begin
    if not ANode.HasChildren then Exit;
    BeginUpdate;
    try
      ANode.Expanded := True;
      ANode := ANode.First;
      while ANode <> nil do
      begin
        ExpandAll(ANode);
        ANode := ANode.Next;
      end;
    finally
      EndUpdate;
    end;
  end;

  procedure ExpandFocusedNodeOrFocusChildNode;
  begin
    if CheckFocusedObject then
    begin
      if not FocusedNode.Expanded then
        FocusedNode.Expanded := True
      else
        if FocusedNode.First <> nil then
          InternalSetFocusedNode(FocusedNode.First);
    end;
  end;

  procedure CollapseFocusedNodeOrFocusParentNode;
  begin
    if CheckFocusedObject then
    begin
      if FocusedNode.Expanded and CanCollapse(FocusedNode) then
        FocusedNode.Expanded := False
      else
        if (FocusedNode.Parent <> nil) and not FocusedNode.Parent.IsRoot then
          InternalSetFocusedNode(FocusedNode.Parent);
    end;
  end;

var
  AProcess: Boolean;
begin
  inherited;

  AProcess := True;
  case Key of
    VK_UP:
      SelectNextNode(-1);

    VK_DOWN:
      SelectNextNode(1);

    VK_NEXT:
      SelectNextNode(ViewInfo.NumberOfNodesInContentRect);

    VK_PRIOR:
      SelectNextNode(-ViewInfo.NumberOfNodesInContentRect);

    VK_SPACE:
      if CheckFocusedObject then
        if (ssCtrl in Shift) and OptionsSelection.MultiSelect then
          FocusedNode.Selected := not FocusedNode.Selected
        else
          if FocusedNode.Enabled and not OptionsBehavior.ReadOnly then
            FocusedNode.Checked := not FocusedNode.Checked;

    VK_HOME:
      if AbsoluteVisibleNodes.Count > 0 then
        InternalSetFocusedNode(AbsoluteVisibleNodes.First);

    VK_END:
      if AbsoluteVisibleNodes.Count > 0 then
        InternalSetFocusedNode(AbsoluteVisibleNodes.Last);

    VK_LEFT:
      if UseRightToLeftAlignment then
        ExpandFocusedNodeOrFocusChildNode
      else
        CollapseFocusedNodeOrFocusParentNode;

    VK_RIGHT:
      if UseRightToLeftAlignment then
        CollapseFocusedNodeOrFocusParentNode
      else
        ExpandFocusedNodeOrFocusChildNode;

    VK_ADD:
      if FocusedNode <> nil then
        FocusedNode.Expanded := True;
    VK_SUBTRACT:
      if FocusedNode <> nil then
        FocusedNode.Expanded := False;
    VK_MULTIPLY:
      begin
        if FocusedNode <> nil then
        begin
          ExpandAll(FocusedNode);
          MakeVisible(FocusedNode);
        end;
      end;
    VK_F2:
      begin
        if Shift = [] then
          StartItemCaptionEditing(FocusedNode);
      end
  else
    AProcess := False;
  end;
  if AProcess then
    FIncrementalSearchController.KeyDown(Key, Shift);
end;

procedure TdxCustomTreeView.KeyPress(var Key: Char);
begin
  inherited;
  if AbsoluteVisibleCount > 0 then
    FIncrementalSearchController.KeyPress(Key);
end;

procedure TdxCustomTreeView.CalculateHitTest(X, Y: Integer);
begin
  HitTest.Reset;
  HitTest.HitPoint := Point(X, Y);
  ViewInfo.CalculateHitTest(HitTest);
end;

procedure TdxCustomTreeView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AWasFocused: Boolean;
begin
  AWasFocused := Focused;
  inherited;
  CalculateHitTest(X, Y);
  FPressedItem := HitTest.HitObjectAsNode;
  FUpdateItemsSelectionOnMouseUp := False;
  FIncrementalSearchController.MouseDown(Button, Shift, X, Y);
  HintHelper.MouseDown;
  FEditingItem := nil;
  if HitTest.HitAtNode then
    if ssLeft in Shift then
    begin
      if AWasFocused and AllowActivateEditByMouse and HitTest.HitAtText and (FocusedNode = FPressedItem) and (Shift = [ssLeft]) then
        FEditingItem := FPressedItem;
      if HitTest.HitAtExpandButton or HitTest.HitAtText and (ssDouble in Shift) and not OptionsBehavior.AutoExpand then
        FPressedItem.Expanded := not FPressedItem.Expanded
      else
        if not FocusNodeOnMouseUp then
          if HitTest.HitAtCheckBox then
          begin
            if FPressedItem.Enabled and not OptionsBehavior.ReadOnly then
              FPressedItem.Checked := not FPressedItem.Checked;
            DoSelectNodeByMouse(FPressedItem, Shift, True);
          end
          else
            if HitTest.HitAtSelection then
              if OptionsSelection.MultiSelect and FPressedItem.Selected then
              begin
                FUpdateItemsSelectionOnMouseUp := True;
                FocusedNode := FPressedItem;
              end
              else
                DoSelectNodeByMouse(FPressedItem, Shift, False);
    end
    else
      if (ssRight in Shift) and OptionsSelection.RightClickSelect then
        RightClickNode := PressedItem;
  if not AWasFocused and (FocusedNode = nil) then
    Selected := TopItem;
end;

procedure TdxCustomTreeView.MouseLeave(AControl: TControl);
begin
  inherited MouseLeave(AControl);
  if HasHottrack then
    HottrackItem := nil;
end;

procedure TdxCustomTreeView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  AIsHitTestCalculated: Boolean;
begin
  inherited MouseMove(Shift, X, Y);
  AIsHitTestCalculated := False;
  if HasHottrack then
    if cxRectPtIn(ClientBounds, cxPoint(X, Y)) then
    begin
      CalculateHitTest(X, Y);
      AIsHitTestCalculated := True;
      if HitTest.HitAtSelection then
        HottrackItem := HitTest.HitObjectAsNode
      else
        HottrackItem := nil;
    end
    else
      HottrackItem := nil;
  if OptionsBehavior.ToolTips then
  begin
    if not AIsHitTestCalculated then
      CalculateHitTest(X, Y);
    CheckHint;
  end;
end;

procedure TdxCustomTreeView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  CalculateHitTest(X, Y);
  if (FocusNodeOnMouseUp or FUpdateItemsSelectionOnMouseUp) and
    HitTest.HitAtNode and (Button = mbLeft) and (FPressedItem = HitTest.HitObject) then
  begin
    if HitTest.HitAtCheckBox and FocusNodeOnMouseUp then
    begin
      if FPressedItem.Enabled and not OptionsBehavior.ReadOnly then
        FPressedItem.Checked := not FPressedItem.Checked;
      DoSelectNodeByMouse(FPressedItem, Shift, True);
    end
    else
      if HitTest.HitAtSelection and not HitTest.HitAtExpandButton then
        DoSelectNodeByMouse(HitTest.HitObjectAsNode, Shift, HitTest.HitAtCheckBox);
  end;
  RightClickNode := nil;
  FPressedItem := nil;

  if HitTest.HitAtText and (Button = mbLeft) and (FEditingItem <> nil) and (FEditingItem = HitTest.HitObjectAsNode) then
    FInplaceEditingController.StartEditingTimer;
end;

procedure TdxCustomTreeView.BeforeDelete(Sender: TdxTreeCustomNode);
var
  ANode: TdxTreeViewNode;
  ASender: TdxTreeViewNode absolute Sender;
begin
  FinishEditingTimer;
  FinishNodeCaptionEditing(False);
  CallNodeEvent(ASender, OnDeletion);
  if FEditingItem = ASender then
    FEditingItem := nil;
  if FSelectionAnchor = ASender then
    FSelectionAnchor := nil;
  if FHottrackItem = ASender then
    FHottrackItem := nil;
  if FPressedItem = ASender then
    FPressedItem := nil;
  if FDropTarget = ASender then
    FDropTarget := nil;
  if FRightClickNode = ASender then
    FRightClickNode := nil;
  if FMakeVisibleNode.Item = ASender then
    FMakeVisibleNode.Item := nil;
  if (FocusedNode = ASender) or (FocusedNode <> nil) and FocusedNode.HasAsParent(ASender) then
  begin
    ANode := ASender.Next;
    if ANode = nil then
      ANode := ASender.Prev;
    if ANode = nil then
      ANode := ASender.Parent;
    dxTestCheck(not (nsDeleting in ANode.State), 'BeforeDelete: FocusedNode := ANode but ANode has nsDeleting state');
    FocusedNode := ANode;
    if FocusedNode <> ANode then  
      FocusedNode := nil;
  end;
  Deselect(ASender);
end;

function TdxCustomTreeView.CanCollapse(Sender: TdxTreeCustomNode): Boolean;
var
  ASender: TdxTreeViewNode absolute Sender;
begin
  Result := CallNodeAllowEvent(ASender, OnCollapsing);
end;

function TdxCustomTreeView.CanExpand(Sender: TdxTreeCustomNode): Boolean;
var
  ASender: TdxTreeViewNode absolute Sender;
begin
  Result := CallNodeAllowEvent(ASender, OnExpanding);
end;

procedure TdxCustomTreeView.Collapsed(Sender: TdxTreeCustomNode);
var
  ASender: TdxTreeViewNode absolute Sender;
begin
  if (FocusedNode <> nil) and FocusedNode.HasAsParent(ASender) then
    FocusedNode := ASender;
  CallNodeEvent(ASender, OnCollapsed);
end;

procedure TdxCustomTreeView.DeleteNode(Sender: TdxTreeCustomNode);
begin
  Changed([tvcStructure]);
end;

procedure TdxCustomTreeView.Expanded(Sender: TdxTreeCustomNode);
var
  ASender: TdxTreeViewNode absolute Sender;
begin
  FMakeVisibleNode.Item := ASender;
  FMakeVisibleNode.Mode := mvmJustExpanded;
  CallNodeEvent(ASender, OnExpanded);
end;

function TdxCustomTreeView.GetMainScrollBarsClass: TcxControlCustomScrollBarsClass;
begin
  if not IsPopupScrollBars then
    Result := TcxControlScrollBars
  else
    Result := inherited GetMainScrollBarsClass;
end;

function TdxCustomTreeView.GetNodeClass(ARelativeNode: TdxTreeCustomNode): TdxTreeCustomNodeClass;
begin
  Result := GetNodeClass;
end;

function TdxCustomTreeView.GetNodeBounds(ANode: TdxTreeViewNode): TRect;
var
  ANodeIndex: Integer;
  APos: Integer;
begin
  Result := cxNullRect;
  if ANode <> nil then
  begin
    ANodeIndex := ANode.VisibleIndex;
    if ANodeIndex >= 0 then
    begin
      APos := ViewInfo.GetNodePositionByIndex(ANodeIndex);
      Result := cxRectBounds(0, APos,
      ViewInfo.ContentSize.cx, ViewInfo.NodeViewInfo.Height);
      Result := cxRectOffset(Result, ViewInfo.ContentRect.TopLeft);
      Result := cxRectOffset(Result, ViewInfo.ViewPort, False);
      if UseRightToLeftAlignment then
        Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, ClientBounds);
    end;
  end;
end;

function TdxCustomTreeView.GetOwner: TPersistent;
begin
  Result := Self;
end;

function TdxCustomTreeView.HasHottrack: Boolean;
begin
  Result := OptionsBehavior.HotTrack;
end;

procedure TdxCustomTreeView.InvalidateNode(ANode: TdxTreeViewNode);
var
  ABounds: TRect;
begin
  if ANode = nil then
    Exit;
  ABounds := GetNodeBounds(ANode);
  if ABounds.IsEmpty then
    Exit;
  if cxRectIntersect(ClientBounds, ABounds) then
    InvalidateRect(ABounds, True);
end;

procedure TdxCustomTreeView.LoadChildren(Sender: TdxTreeCustomNode);
var
  ASender: TdxTreeViewNode absolute Sender;
begin
  CallNodeEvent(ASender, OnGetChildren);
end;

procedure TdxCustomTreeView.TreeNotification(Sender: TdxTreeCustomNode; ANotification: TdxTreeNodeNotifications);
var
  ASender: TdxTreeViewNode absolute Sender;
begin
  BeginUpdate;
  try
    if tnStructure in ANotification then
      Changed([tvcStructure]);
    if tnData in ANotification then
      Changed([tvcContent]);
  finally
    EndUpdate;
  end;
end;

// delphi drag and drop

function TdxCustomTreeView.CanDrag(X, Y: Integer): Boolean;
begin
  Result := inherited CanDrag(X, Y);
  if Result then
  begin
    CalculateHitTest(X, Y);
    Result := HitTest.HitAtSelection and
      HitTest.HitObjectAsNode.Focused;
  end;
end;

procedure TdxCustomTreeView.DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  ADragObject: TdxCustomTreeViewDragObject;
begin
  inherited DragOver(Source, X, Y, State, Accept);
  case State of
    dsDragLeave:
      DropTarget := nil;
    dsDragMove:
      begin
        if cxRectPtIn(ClientBounds, cxPoint(X, Y)) then
        begin
          CalculateHitTest(X, Y);
          DropTarget := HitTest.HitObjectAsNode;
        end
        else
          DropTarget := nil;
        ADragObject := Safe<TdxCustomTreeViewDragObject>.Cast(Source);
        if (ADragObject <> nil) and (ADragObject.AutoScrollHelper <> nil) then
          ADragObject.AutoScrollHelper.CheckMousePosition(Point(X, Y));
      end;
  end;
end;

procedure TdxCustomTreeView.DrawDragImage(ACanvas: TcxCanvas; const R: TRect);
const
  FlagsMap: array[Boolean] of Cardinal = (
    CXTO_LEFT or CXTO_CENTER_VERTICALLY or CXTO_SINGLELINE,
    CXTO_RIGHT or CXTO_CENTER_VERTICALLY or CXTO_SINGLELINE
  );
var
  AImageRect, ATextRect: TRect;
begin
  AImageRect := R;
  AImageRect.Right := Images.Width + ScaleFactor.Apply(2*5);
  TdxImageDrawer.DrawImage(ACanvas, AImageRect, nil, Images, GetImageIndex(FocusedNode), True, nil, ScaleFactor);
  ATextRect := R;
  ATextRect.Left := AImageRect.Right;
  cxTextOut(ACanvas.Canvas, FocusedNode.Caption, ATextRect, FlagsMap[UseRightToLeftAlignment], 0, 0, Font,
    cxGetActualColor(ViewInfo.LookAndFeelPainter.DefaultSelectionColor, clHighlight),
    cxGetActualColor(ViewInfo.LookAndFeelPainter.DefaultSelectionTextColor, clHighlightText), 0, 0, 0,
    cxGetActualColor(ViewInfo.LookAndFeelPainter.DefaultEditorTextColor(not Enabled), clWindowText));
end;

function TdxCustomTreeView.GetDragImagesSize: TPoint;
var
  AWidth, AHeight: Integer;
begin
  ViewInfo.NodeViewInfo.SetData(FocusedNode);
  AHeight := ViewInfo.NodeViewInfo.Bounds.Height;
  AWidth := ViewInfo.NodeViewInfo.TextWidth + ViewInfo.NodeViewInfo.ImageRect.Width + 5*2;
  Result.Init(AWidth, AHeight);
  ViewInfo.NodeViewInfo.SetData(nil);
end;

function TdxCustomTreeView.GetDragObjectClass: TDragControlObjectClass;
begin
  Result := TdxCustomTreeViewDragObject;
end;

function TdxCustomTreeView.HasDragImages: Boolean;
begin
  Result := FImages <> nil;
end;

procedure TdxCustomTreeView.AssignNodes(ASource: TTreeNodes);
var
  AOldNode, AOldFirstLevelNode: TTreeNode;
  AdxFirstLevelNode: TdxTreeViewNode;
begin
  BeginUpdate;
  try
    Root.Clear;
    if ASource.Count > 0 then
    begin
      AOldFirstLevelNode := ASource[0];
      while AOldFirstLevelNode <> nil do
      begin
        AdxFirstLevelNode := Root.AddChild;
        AdxFirstLevelNode.AssignFromNode(AOldFirstLevelNode);
        AOldNode := AOldFirstLevelNode;
        dxTreeForEach(AdxFirstLevelNode,
          function (ANode: TdxTreeCustomNode; AData: Pointer): Boolean
          var
            I: Integer;
            AdxNode, AdxChildNode: TdxTreeViewNode;
          begin
            AdxNode := TdxTreeViewNode(ANode);
            if AOldNode <> nil then
            begin
              for I := 0 to AOldNode.Count - 1 do
              begin
                AdxChildNode := AdxNode.AddChild;
                AdxChildNode.AssignFromNode(AOldNode[I]);
              end;
              AOldNode := AOldNode.GetNext;
            end;
            Result := AOldNode <> nil;
          end, nil);
        AOldFirstLevelNode := AOldFirstLevelNode.getNextSibling;
      end;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomTreeView.AssignFromTreeView(ASource: TTreeView);
begin
  BeginUpdate;
  try
    Images := ASource.Images;
    StateImages := ASource.StateImages;
    OptionsBehavior.ReadOnly := ASource.ReadOnly;
    OptionsBehavior.ChangeDelay := ASource.ChangeDelay;
    OptionsBehavior.HotTrack := ASource.HotTrack;
    OptionsBehavior.SortType := ASource.SortType;
    OptionsBehavior.ToolTips := ASource.ToolTips;
    OptionsSelection.RowSelect := ASource.RowSelect;
    OptionsSelection.HideSelection := ASource.HideSelection;
    OptionsSelection.MultiSelect := ASource.MultiSelect;
    OptionsSelection.MultiSelectStyle := ASource.MultiSelectStyle;
    OptionsSelection.RightClickSelect := ASource.RightClickSelect;
    OptionsView.Indent := ASource.Indent;
    OptionsView.ShowExpandButtons := ASource.ShowButtons;
    OptionsView.ShowLines := ASource.ShowLines;
    OptionsView.ShowRoot := ASource.ShowRoot;
    OptionsView.UseImageIndexForExpanded := True;
    OptionsView.UseImageIndexForSelected := True;
    AssignNodes(ASource.Items);
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomTreeView.ReadData(AStream: TStream);
var
  AHeader: TdxTreeViewStreamHeader;
begin
  AStream.ReadBuffer(AHeader, SizeOf(TdxTreeViewStreamHeader));
  if (AHeader.Size <> AStream.Size) then
    raise EdxTreeViewException.Create('Invalid stream format');
  BeginUpdate;
  try
    Root.Clear;
    try
      ReadStructure(AStream, AHeader.Major);
    except
      Root.Clear;
      raise;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomTreeView.ReadStructure(AStream: TStream; AVersion: Cardinal);
begin
  dxTreeForEach(Root,
    function (ANode: TdxTreeCustomNode; AData: Pointer): Boolean
    begin
      DoNodeAddition(
        function: TdxTreeViewNode
        begin
          Result := TdxTreeViewNode(ANode);
          Result.ReadData(AStream, AVersion);
        end);
      Result := True;
    end, nil);
end;

procedure TdxCustomTreeView.WriteData(AStream: TStream);
var
  AHeader: TdxTreeViewStreamHeader;
begin
  AStream.Position := 0;
  PInteger(@AHeader)^ := dxTreeViewVersion;
  AHeader.Size := AStream.Size;
  AStream.WriteBuffer(AHeader, SizeOf(AHeader));
  WriteStructure(AStream);
  AHeader.Size := AStream.Size;
  AStream.Position := TdxNativeUInt(@AHeader.Size) - TdxNativeUInt(@AHeader);
  AStream.Write(AHeader.Size, SizeOf(AHeader.Size));
  AStream.Position := AHeader.Size;
end;

procedure TdxCustomTreeView.WriteStructure(AStream: TStream);
begin
  dxTreeForEach(Root,
    function (ANode: TdxTreeCustomNode; AData: Pointer): Boolean
    begin
      TdxTreeViewNode(ANode).WriteData(AStream);
      Result := True;
    end, nil);
end;

procedure TdxCustomTreeView.ChangeFocusedNode(ANode: TdxTreeViewNode; AShift: TShiftState);
begin
  DoSelect(ANode, AShift);
  FocusedNode := ANode;
end;

function TdxCustomTreeView.DoAddNodeToSelection(ANode: TdxTreeViewNode; APosition: Integer = -1): Boolean;
begin
  Result := False;
  if ANode.Visible and CanSelectNode(ANode) then
  begin
    dxTestCheck(not IsNodeSelected(ANode), Format('Node %s already selected', [ANode.Caption]));
    if APosition = -1 then
      FSelections.Add(ANode)
    else
      FSelections.insert(APosition, ANode);
    Result := True;
  end;
end;

procedure TdxCustomTreeView.DoChangeDelayTimer(Sender: TObject);
begin
  if not IsDestroying and not IsLoading then
  begin
    DoSelectionChanged;
    FChangeDelayTimer.Enabled := False;
  end;
end;

procedure TdxCustomTreeView.DoGetImageIndex(ANode: TdxTreeViewNode; var AImageIndex: Integer);
begin
  if Assigned(FOnGetImageIndex) then
    FOnGetImageIndex(Self, ANode, AImageIndex);
end;

procedure TdxCustomTreeView.DoGetSelectedImageIndex(ANode: TdxTreeViewNode; var AImageIndex: Integer);
begin
  if Assigned(FOnGetSelectedImageIndex) then
    FOnGetSelectedImageIndex(Self, ANode, AImageIndex);
end;

procedure TdxCustomTreeView.DoHint(ANode: TdxTreeViewNode;
  var AText: string);
begin
  if Assigned(OnHint) then
    OnHint(Self, ANode, AText);
end;

function TdxCustomTreeView.DoNodeAddition(AAddNodeFunc: TdxTreeViewAddNodeFunc): TdxTreeViewNode;
begin
  Result := nil;
  BeginAddNode;
  try
    Result := AAddNodeFunc;
  finally
    EndAddNode(Result);
  end;
end;

procedure TdxCustomTreeView.DoSelectionOperation(ASelectProc: TProc);
var
  ASelectionBefore: TdxFastList;
begin
  ASelectionBefore := TdxFastList.Create;
  try
    ASelectionBefore.Assign(FSelections);
    ASelectProc;
    if IsSelectionChanged(ASelectionBefore, FSelections) then
      SelectionChanged;
  finally
    ASelectionBefore.Free;
  end;
end;

procedure TdxCustomTreeView.FinishEditingTimer;
begin
  FInplaceEditingController.DestroyTimer;
end;

function TdxCustomTreeView.GetAbsoluteCount: Integer;
begin
  CheckAbsoluteNodes;
  Result := FAbsoluteNodes.Count;
end;

function TdxCustomTreeView.GetAbsoluteItem(AIndex: Integer): TdxTreeViewNode;
begin
  CheckAbsoluteNodes;
  Result := FAbsoluteNodes[AIndex];
end;

function TdxCustomTreeView.GetAbsoluteVisibleCount: Integer;
begin
  UpdateAbsoluteVisibleNodes;
  Result := FAbsoluteVisibleNodes.Count;
end;

function TdxCustomTreeView.GetAbsoluteVisibleItem(AIndex: Integer): TdxTreeViewNode;
begin
  UpdateAbsoluteVisibleNodes;
  Result := FAbsoluteVisibleNodes[AIndex];
end;

function TdxCustomTreeView.GetIAccessibilityHelper: IcxAccessibilityHelper;
begin
  if FIAccessibilityHelper = nil then
    FIAccessibilityHelper := TdxTreeViewAccessibilityHelper.Create(Self);
  Result := FIAccessibilityHelper;
end;

function TdxCustomTreeView.GetInplaceEdit: IdxInplaceEdit;
begin
  Result := FInplaceEditingController.InplaceEdit;
end;

function TdxCustomTreeView.GetSelected: TdxTreeViewNode;
begin
  if FRightClickNode <> nil then
    Result := FRightClickNode
  else
    if not OptionsSelection.MultiSelect then
      Result := FocusedNode
    else
      if SelectionCount > 0 then
        Result := Selections[0]
      else
        Result := nil;
end;

function TdxCustomTreeView.GetSelectionCount: Integer;
begin
  if OptionsSelection.MultiSelect then
    Result := FSelections.Count
  else
    Result := IfThen(FocusedNode <> nil, 1, 0);
end;

function TdxCustomTreeView.GetSelection(Index: Integer): TdxTreeViewNode;
begin
  if OptionsSelection.MultiSelect then
    Result := FSelections[Index]
  else
    Result := FocusedNode;
end;

procedure TdxCustomTreeView.ImagesChangeHandler(Sender: TObject);
begin
  Changed([tvcContent]);
end;

function TdxCustomTreeView.IsSelectionChanged(ASelectionBefore, ASelectionAfter: TdxFastList): Boolean;
var
  I: Integer;
begin
  Result := ASelectionBefore.Count <> ASelectionAfter.Count;
  if not Result then
    for I := 0 to ASelectionBefore.Count - 1 do
      if ASelectionAfter.IndexOf(ASelectionBefore[I]) = -1 then
      begin
        Result := True;
        Break;
      end;
end;

procedure TdxCustomTreeView.Loaded;
begin
  inherited Loaded;
  Changed([tvcStructure]);
end;

procedure TdxCustomTreeView.SelectionChanged;
begin
  if (FLockSelectionCount = 0) and not IsDestroying and not IsLoading then
  begin
    if OptionsBehavior.ChangeDelay = 0 then
      DoSelectionChanged
    else
      FChangeDelayTimer.Enabled := True;
    FIsSelectionChanged := False;
    Invalidate;
  end
  else
    FIsSelectionChanged := True;
end;

procedure TdxCustomTreeView.SetDropTarget(ANode: TdxTreeViewNode);
begin
  if FDropTarget <> ANode then
  begin
    InvalidateNode(FDropTarget);
    FDropTarget := ANode;
    InvalidateNode(FDropTarget);
  end;
end;

procedure TdxCustomTreeView.SetFocusedNode(AValue: TdxTreeViewNode);
begin
  if (AValue <> nil) and (AValue.IsRoot or not AValue.Visible or (not ShowFirstLevelNodes and AValue.Parent.IsRoot)) then
     AValue := nil;
  if not CanFocusNode(AValue) then
    Exit;
  if FFocusedNode <> AValue then
  begin
    FinishEditingTimer;
    FinishNodeCaptionEditing;
    FFocusedNode := AValue;
    MakeVisible(FocusedNode);
    if not IsDestroying then
    begin
      DoFocusedNodeChanged;
      if not OptionsSelection.MultiSelect then
        SelectionChanged;
      if (FocusedNode <> nil) and HandleAllocated and not IsUpdateLocked then
        NotifyWinEvent(EVENT_OBJECT_FOCUS, Handle,
          TdxTreeViewNodeAccessibilityHelper(FocusedNode.IAccessibilityHelper.GetHelper).FLocalId, CHILDID_SELF);
    end;
    Invalidate;
  end;
end;

procedure TdxCustomTreeView.SetHighlightedText(AValue: string);
begin
  if AValue <> HighlightedText then
  begin
    FHighlightedText := AValue;
    Changed([tvcContent]);
  end;
end;

procedure TdxCustomTreeView.SetHottrackItem(AValue: TdxTreeViewNode);
begin
  if FHottrackItem <> AValue then
  begin
    InvalidateNode(FHottrackItem);
    FHottrackItem := AValue;
    InvalidateNode(FHottrackItem);
  end;
end;

procedure TdxCustomTreeView.SetImages(AValue: TCustomImageList);
begin
  cxSetImageList(AValue, FImages, FImagesChangeLink, Self);
  Changed([tvcLayout]);
end;

procedure TdxCustomTreeView.SetItems(AValue: TdxTreeViewNodes);
begin
  FItems.Assign(AValue);
end;

procedure TdxCustomTreeView.SetOptionsBehavior(AValue: TdxTreeViewCustomOptionsBehavior);
begin
  FOptionsBehavior.Assign(AValue);
end;

procedure TdxCustomTreeView.SetOptionsSelection(AValue: TdxTreeViewCustomOptionsSelection);
begin
  FOptionsSelection.Assign(AValue);
end;

procedure TdxCustomTreeView.SetOptionsView(AValue: TdxTreeViewCustomOptionsView);
begin
  FOptionsView.Assign(AValue);
end;

procedure TdxCustomTreeView.SetRightClickNode(AValue: TdxTreeViewNode);
begin
  if FRightClickNode <> AValue then
  begin
   InvalidateNode(FRightClickNode);
   FRightClickNode := AValue;
   InvalidateNode(FRightClickNode);
  end;
end;

procedure TdxCustomTreeView.SetSelected(AValue: TdxTreeViewNode);
begin
  ChangeFocusedNode(AValue, []);
end;

procedure TdxCustomTreeView.SetStateImages(AValue: TCustomImageList);
begin
  cxSetImageList(AValue, FStateImages, FStateImagesChangeLink, Self);
  Changed([tvcLayout]);
end;

procedure TdxCustomTreeView.SetTopItem(AValue: TdxTreeViewNode);
begin
  if (AValue <> nil) and not AValue.IsRoot and AValue.Visible then
  begin
    FMakeVisibleNode.Item := AValue;
    FMakeVisibleNode.Mode := mvmMakeTop;
    Changed([]);
  end;
end;

procedure TdxCustomTreeView.WMGetObject(var Message: TMessage);
var
  AObjectID: Cardinal;
begin
  if CanReturnAccessibleObject(Message) then
  begin
    AObjectID := Cardinal(Message.LParam);
    if (AObjectID = OBJID_CLIENT) or (AObjectID = OBJID_WINDOW) then
      Message.Result := WMGetObjectResultFromIAccessibilityHelper(Message, IAccessibilityHelper)
    else
      if (AObjectID > 0) and (AObjectID <= Cardinal(FAccessibleObjects.Count)) then
        Message.Result := WMGetObjectResultFromIAccessibilityHelper(Message, FAccessibleObjects.Items[AObjectID - 1])
      else
        inherited;
  end
  else
    inherited;
end;

{ TdxTreeViewCustomOptionsView }

constructor TdxTreeViewCustomOptionsView.Create(ATreeView: TdxCustomTreeView);
begin
  inherited Create(ATreeView);
  FIndent := 19;
  FShowEndEllipsis := GetDefaultShowEndEllipsis;
  FShowExpandButtons := True;
  FShowLines := True;
  FShowRoot := True;
end;

function TdxTreeViewCustomOptionsView.GetScrollBars: TcxScrollStyle;
begin
  Result := TreeView.ScrollBars;
end;

procedure TdxTreeViewCustomOptionsView.Assign(Source: TPersistent);
begin
  if Source is TdxTreeViewCustomOptionsView then
  begin
    Indent := TdxTreeViewOptionsView(Source).Indent;
    ItemHeight := TdxTreeViewOptionsView(Source).ItemHeight;
    Scrollbars := TdxTreeViewCustomOptionsView(Source).Scrollbars;
    ShowCheckBoxes := TdxTreeViewCustomOptionsView(Source).ShowCheckBoxes;
    ShowEndEllipsis := TdxTreeViewCustomOptionsView(Source).ShowEndEllipsis;
    ShowExpandButtons := TdxTreeViewCustomOptionsView(Source).ShowExpandButtons;
    ShowLines := TdxTreeViewCustomOptionsView(Source).ShowLines;
    ShowRoot := TdxTreeViewCustomOptionsView(Source).ShowRoot;
    UseImageIndexForExpanded := TdxTreeViewCustomOptionsView(Source).UseImageIndexForExpanded;
    UseImageIndexForSelected := TdxTreeViewCustomOptionsView(Source).UseImageIndexForSelected;
  end;
end;

procedure TdxTreeViewCustomOptionsView.Changed(AChanges: TdxTreeViewChanges);
begin
  TreeView.Changed(AChanges);
end;

procedure TdxTreeViewCustomOptionsView.ChangeScale(M, D: Integer);
begin
  // do nothing
end;

function TdxTreeViewCustomOptionsView.GetDefaultShowEndEllipsis: Boolean;
begin
  Result := False;
end;

procedure TdxTreeViewCustomOptionsView.SetIndent(AValue: Integer);
begin
  if AValue <> Indent then
  begin
    FIndent := AValue;
    Changed([tvcLayout]);
  end;
end;

procedure TdxTreeViewCustomOptionsView.SetItemHeight(AValue: Integer);
begin
  AValue := Max(AValue, 0);
  if AValue <> ItemHeight then
  begin
    FItemHeight := AValue;
    Changed([tvcLayout]);
  end;
end;

procedure TdxTreeViewCustomOptionsView.SetScrollBars(AValue: TcxScrollStyle);
begin
  TreeView.ScrollBars := AValue;
end;

procedure TdxTreeViewCustomOptionsView.SetShowCheckBoxes(AValue: Boolean);
begin
  if FShowCheckBoxes <> AValue then
  begin
    FShowCheckBoxes := AValue;
    Changed([tvcLayout]);
  end;
end;

procedure TdxTreeViewCustomOptionsView.SetShowEndEllipsis(AValue: Boolean);
begin
  if FShowEndEllipsis <> AValue then
  begin
    FShowEndEllipsis := AValue;
    Changed([tvcContent]);
  end;
end;

procedure TdxTreeViewCustomOptionsView.SetShowExpandButtons(AValue: Boolean);
begin
  if FShowExpandButtons <> AValue then
  begin
    FShowExpandButtons := AValue;
    Changed([tvcLayout]);
  end;
end;

procedure TdxTreeViewCustomOptionsView.SetShowLines(AValue: Boolean);
begin
  if FShowLines <> AValue then
  begin
    FShowLines := AValue;
    Changed([tvcLayout]);
  end;
end;

procedure TdxTreeViewCustomOptionsView.SetShowRoot(const Value: Boolean);
begin
  if FShowRoot <> Value then
  begin
    FShowRoot := Value;
    Changed([tvcLayout]);
  end;
end;

procedure TdxTreeViewCustomOptionsView.SetUseImageIndexForExpanded(const Value: Boolean);
begin
  if FUseImageIndexForExpanded <> Value then
  begin
    FUseImageIndexForExpanded := Value;
    Changed([tvcContent]);
  end;
end;

procedure TdxTreeViewCustomOptionsView.SetUseImageIndexForSelected(
  const Value: Boolean);
begin
  if FUseImageIndexForSelected <> Value then
  begin
    FUseImageIndexForSelected := Value;
    Changed([tvcContent]);
  end;
end;

{ TdxTreeViewCustomOptionsBehavior }

constructor TdxTreeViewCustomOptionsBehavior.Create(ATreeView: TdxCustomTreeView);
begin
  inherited Create(ATreeView);
  FToolTips := True;
end;

procedure TdxTreeViewCustomOptionsBehavior.Assign(Source: TPersistent);
var
  ASource: TdxTreeViewCustomOptionsBehavior;
begin
  if Safe.Cast(Source, TdxTreeViewCustomOptionsBehavior, ASource) then
  begin
    AutoExpand := ASource.AutoExpand;
    CaptionEditing := ASource.CaptionEditing;
    ChangeDelay := ASource.ChangeDelay;
    HotTrack := ASource.HotTrack;
    SortType := ASource.SortType;
    ToolTips := ASource.ToolTips;
    ReadOnly := ASource.ReadOnly;
  end;
end;

procedure TdxTreeViewCustomOptionsBehavior.SetCaptionEditing(AValue: Boolean);
begin
  if FCaptionEditing <> AValue then
  begin
    FCaptionEditing := AValue;
    if not AValue then
      TreeView.FinishNodeCaptionEditing(False);
  end;
end;

procedure TdxTreeViewCustomOptionsBehavior.SetChangeDelay(AValue: Integer);
begin
  AValue := Max(0, AValue);
  if FChangeDelay <> AValue then
  begin
    FChangeDelay := AValue;
    TreeView.UpdateChangeDelayTimer;
  end;
end;

procedure TdxTreeViewCustomOptionsBehavior.SetSortType(AValue: TSortType);
begin
  if SortType <> AValue then
  begin
    FSortType := AValue;
    TreeView.SortTypeChanged;
  end;
end;

{ TdxTreeViewCustomOptionsSelection }

constructor TdxTreeViewCustomOptionsSelection.Create(ATreeView: TdxCustomTreeView);
begin
  inherited Create(ATreeView);
  FHideSelection := DefaultHideSelectionValue;
  FMultiSelectStyle := [msControlSelect];
end;

{ TdxTreeViewCustomOptionsSelection }

procedure TdxTreeViewCustomOptionsSelection.Assign(Source: TPersistent);
begin
  if Source is TdxTreeViewCustomOptionsSelection then
  begin
    RowSelect := TdxTreeViewCustomOptionsSelection(Source).RowSelect;
    HideSelection := TdxTreeViewCustomOptionsSelection(Source).HideSelection;
    MultiSelect := TdxTreeViewCustomOptionsSelection(Source).MultiSelect;
    MultiSelectStyle := TdxTreeViewCustomOptionsSelection(Source).MultiSelectStyle;
    RightClickSelect := TdxTreeViewCustomOptionsSelection(Source).RightClickSelect;
  end;
end;

procedure TdxTreeViewCustomOptionsSelection.Changed(AChanges: TdxTreeViewChanges);
begin
  TreeView.Changed(AChanges);
end;

function TdxTreeViewCustomOptionsSelection.DefaultHideSelectionValue: Boolean;
begin
  Result := False;
end;

procedure TdxTreeViewCustomOptionsSelection.SetRowSelect(AValue: Boolean);
begin
  if AValue <> RowSelect then
  begin
    FRowSelect := AValue;
    Changed([tvcContent, tvcLayout]);
  end;
end;

procedure TdxTreeViewCustomOptionsSelection.SetHideSelection(AValue: Boolean);
begin
  if AValue <> FHideSelection then
  begin
    FHideSelection := AValue;
    TreeView.Invalidate;
  end;
end;

procedure TdxTreeViewCustomOptionsSelection.SetMultiSelect(AValue: Boolean);
begin
  if AValue <> MultiSelect then
  begin
    if not AValue then
      TreeView.ClearSelection;
    FMultiSelect := AValue;
    if AValue and (TreeView.FocusedNode <> nil) then
      TreeView.AddNodeToSelection(TreeView.FocusedNode);
    TreeView.Invalidate;
  end;
end;

procedure TdxTreeViewCustomOptionsSelection.SetMultiSelectStyle(AValue: TMultiSelectStyle);
begin
  if AValue <> MultiSelectStyle then
  begin
    FMultiSelectStyle := AValue;
    TreeView.MultiSelectStyleChanged;
  end;
end;

{ TdxTreeViewHitTest }

function TdxTreeViewHitTest.GetHitAtNode: Boolean;
begin
  Result := HitObject is TdxTreeViewNode;
end;

function TdxTreeViewHitTest.GetHitObjectAsNode: TdxTreeViewNode;
begin
  if HitAtNode then
    Result := TdxTreeViewNode(HitObject)
  else
    Result := nil;
end;

procedure TdxTreeViewHitTest.Reset;
begin
  FHitAtCheckBox := False;
  FHitAtExpandButton := False;
  FHitAtImage := False;
  FHitAtSelection := False;
  FHitAtStateImage := False;
  FHitAtText := False;
  FHitObject := nil;
  FHitPoint := cxNullPoint;
end;

{ TdxTreeViewPainter }

procedure TdxTreeViewPainter.DrawBackground(ACanvas: TcxCanvas; const R: TRect;
  AViewInfo: TdxTreeViewViewInfo);
begin
  ACanvas.FillRect(R, GetBackgroundColor);
end;

procedure TdxTreeViewPainter.DrawCheckBox(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
var
  AButtonState: TcxButtonState;
begin
  if ANodeViewInfo.Node.Enabled then
    AButtonState := cxbsNormal
  else
    AButtonState := cxbsDisabled;
  LookAndFeelPainter.DrawScaledCheckButton(ACanvas, R, AButtonState, ANodeViewInfo.Node.CheckState, TreeView.ScaleFactor);
end;

procedure TdxTreeViewPainter.DrawExpandButton(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
var
  AState: TcxExpandButtonState;
begin
  if ANodeViewInfo.IsRowSelect and ANodeViewInfo.HasSelection then
    AState := cebsSelected
  else
    AState := cebsNormal;
  LookAndFeelPainter.DrawTreeViewExpandButton(ACanvas, R, ANodeViewInfo.Node.Expanded,
    TreeView.IsExplorerStyle, TreeView.ScaleFactor, clDefault, AState);
end;

procedure TdxTreeViewPainter.DrawNodeCaption(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
var
  ARect: TRect;
  AFlags: Cardinal;
begin
  ARect := R;
  AFlags := CXTO_SINGLELINE;
  if TreeView.UseRightToLeftAlignment then
    AFlags := AFlags or CXTO_RIGHT;
  if TreeView.OptionsView.ShowEndEllipsis then
    AFlags := AFlags or CXTO_END_ELLIPSIS;

  if TreeView.HighlightedText <> '' then
  begin
    cxTextOut(ACanvas.Canvas, ANodeViewInfo.Node.Caption, ARect, AFlags,
      Pos(AnsiUpperCase(TreeView.HighlightedText), AnsiUpperCase(ANodeViewInfo.Node.Caption)) - 1,
      Length(TreeView.HighlightedText), ACanvas.Font,
      cxGetActualColor(LookAndFeelPainter.DefaultSearchResultHighlightColor, clHighlight),
      cxGetActualColor(LookAndFeelPainter.DefaultSearchResultHighlightTextColor, clHighlightText),
      0, 0, 0, ANodeViewInfo.FTextColor);
  end
  else
    cxTextOut(ACanvas.Canvas, ANodeViewInfo.Node.Caption, ARect, AFlags, ACanvas.Font, 0, 0, 0, ANodeViewInfo.FTextColor);
end;

procedure TdxTreeViewPainter.DrawNodeFocus(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
var
  APrevColor: TColor;
begin
  APrevColor := ACanvas.Brush.Color;
  ACanvas.Brush.Color := GetBackgroundColor;
  ACanvas.FocusRectangle(R);
  ACanvas.Brush.Color := APrevColor;
end;

procedure TdxTreeViewPainter.DrawNodeImage(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
const
  ImageDrawMode: array [Boolean] of TcxImageDrawMode = (idmNormal, idmDingy);
begin
  TdxImageDrawer.DrawImage(ACanvas, R, nil, TreeView.Images, ANodeViewInfo.GetImageIndex, ifmNormal,
    ImageDrawMode[ANodeViewInfo.Node.Cut], True, ANodeViewInfo.GetImageColorPalette(R), TreeView.ScaleFactor);
  if ANodeViewInfo.Node.OverlayImageIndex >= 0 then
    TdxImageDrawer.DrawImage(ACanvas, R, nil, TreeView.Images, ANodeViewInfo.Node.OverlayImageIndex, ifmNormal,
      ImageDrawMode[ANodeViewInfo.Node.Cut], True, ANodeViewInfo.GetImageColorPalette(R), TreeView.ScaleFactor);
end;

procedure TdxTreeViewPainter.DrawNodeSelection(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
begin
  LookAndFeelPainter.DrawTreeViewNodeBackground(ACanvas, R, ANodeViewInfo.GetState);
end;

procedure TdxTreeViewPainter.DrawNodeStateImage(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
begin
  TdxImageDrawer.DrawImage(ACanvas, R, nil, TreeView.StateImages, ANodeViewInfo.Node.StateImageIndex,
    True, ANodeViewInfo.GetImageColorPalette(R), TreeView.ScaleFactor);
end;

procedure TdxTreeViewPainter.DrawTreeLine(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
begin
  cxFillHalfToneRect(ACanvas.Canvas, R, GetBackgroundColor, LookAndFeelPainter.DefaultTreeListTreeLineColor);
end;

function TdxTreeViewPainter.GetBackgroundColor: TColor;
begin
  Result := LookAndFeelPainter.GetTreeViewBackgroundColor(TreeView.Enabled);
end;

function TdxTreeViewPainter.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := TreeView.LookAndFeelPainter;
end;

function TdxTreeViewPainter.GetTextColor(ANodeViewInfo: TdxTreeViewNodeViewInfo): TColor;
begin
  Result := LookAndFeelPainter.GetTreeViewNodeTextColor(ANodeViewInfo.GetState);
end;

{ TdxTreeViewCustomViewInfo }

procedure TdxTreeViewCustomViewInfo.Calculate(const ABounds: TRect);
begin
  FIsRightToLeftConverted := False;
  FBounds := ABounds;
end;

function TdxTreeViewCustomViewInfo.IsRowSelect: Boolean;
begin
  Result := TreeView.OptionsSelection.RowSelect and not TreeView.OptionsView.ShowLines;
end;

procedure TdxTreeViewCustomViewInfo.RightToLeftConversion(ABounds: TRect);
begin
  if not IsRightToLeftConverted then
  begin
    DoRightToLeftConversion(ABounds);
    FIsRightToLeftConverted := True;
  end;
end;

procedure TdxTreeViewCustomViewInfo.DoRightToLeftConversion(ABounds: TRect);
begin
  FBounds := TdxRightToLeftLayoutConverter.ConvertRect(Bounds, ABounds);
end;

function TdxTreeViewCustomViewInfo.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := TreeView.LookAndFeelPainter;
end;

function TdxTreeViewCustomViewInfo.GetPainter: TdxTreeViewPainter;
begin
  Result := TreeView.Painter;
end;

function TdxTreeViewCustomViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := TreeView.ScaleFactor;
end;

{ TdxTreeViewNodeViewInfo }

procedure TdxTreeViewNodeViewInfo.Calculate(const ABounds: TRect);

  function PlaceArea(var R: TRect; AAreaWidth, AAreaHeight: Integer): TRect;
  begin
    Result := cxRectSetWidth(R, AAreaWidth);
    Result := cxRectCenterVertically(Result, AAreaHeight);
    R.Left := Result.Right + ScaleFactor.Apply(ElementsOffset);
  end;

var
  AExpandButtonSize, ACheckSize, AImageSize, AStateImageSize: TSize;
  AStateImageOffset: Integer;
  ATextHeight: Integer;
  AImageHeight: Integer;
begin
  inherited Calculate(ABounds);
  AImageSize := dxGetImageSize(Images, ScaleFactor);
  AStateImageSize := dxGetImageSize(TreeView.StateImages, ScaleFactor);
  AImageHeight := Max(AImageSize.cy, AStateImageSize.cy);

  AExpandButtonSize := LookAndFeelPainter.TreeViewExpandButtonSize(TreeView.IsExplorerStyle, ScaleFactor);
  ACheckSize := LookAndFeelPainter.ScaledCheckButtonAreaSize(ScaleFactor);

  FLevelIndent := TreeView.OptionsView.Indent;
  ATextHeight := TdxTextMeasurer.TextLineHeight(TreeView.Font);
  FBounds := cxRectSetHeight(FBounds, MeasureHeight(AImageHeight, AExpandButtonSize.cy, ACheckSize.cy, ATextHeight));
  FTextRect := cxRectInflate(FBounds, -ScaleFactor.Apply(cxTextOffset));

  FExpandButtonRect := PlaceArea(FTextRect, AExpandButtonSize.cx, AExpandButtonSize.cy);

  if TreeView.OptionsView.ShowCheckBoxes then
    FCheckBoxRect := PlaceArea(FTextRect, ACheckSize.cx, ACheckSize.cy)
  else
    FCheckBoxRect.Empty;

  if TreeView.StateImages <> nil then
  begin
    FStateImageRect := FTextRect;
    FStateImageRect.Width := AStateImageSize.cx;
    FStateImageRect := cxRectCenterVertically(FStateImageRect, AStateImageSize.cy);
  end
  else
    FStateImageRect.Empty;

  if Images <> nil then
    FImageRect := PlaceArea(FTextRect, AImageSize.cx, AImageSize.cy)
  else
    FImageRect.Empty;

  FTextRect := cxRectCenterVertically(FTextRect, ATextHeight);
  FTextRects[False] := FTextRect;
  FImageRects[False] := FImageRect;
  FStateImageRects[False] := FStateImageRect;
  AStateImageOffset := AStateImageSize.cx + ScaleFactor.Apply(ElementsOffset);
  FTextRects[True] := cxRectOffsetHorz(FTextRect, AStateImageOffset);
  if not cxRectIsEmpty(FImageRect) then
    FImageRects[True] := cxRectOffsetHorz(FImageRect, AStateImageOffset)
  else
    FImageRects[True] := FImageRect;
  FStateImageRects[True] := FStateImageRect;
  FSelectionRect := CalculateSelectionRect;
end;

procedure TdxTreeViewNodeViewInfo.CalculateHitTest(AHitTest: TdxTreeViewHitTest);
begin
  if PtInRect(Bounds, AHitTest.HitPoint) or IsRowSelect then
  begin
    AHitTest.HitObject := Node;
    AHitTest.HitAtCheckBox := PtInRect(CheckBoxRect, AHitTest.HitPoint);
    AHitTest.HitAtExpandButton := PtInRect(ExpandButtonRect, AHitTest.HitPoint);
    AHitTest.HitAtImage := PtInRect(ImageRect, AHitTest.HitPoint);
    AHitTest.HitAtStateImage := PtInRect(FStateImageRect, AHitTest.HitPoint);
    AHitTest.HitAtSelection := IsRowSelect or PtInRect(SelectionRect, AHitTest.HitPoint);
    AHitTest.HitAtText := PtInRect(TextRect, AHitTest.HitPoint);
  end;
end;

procedure TdxTreeViewNodeViewInfo.DefaultDraw(ACanvas: TcxCanvas);
begin
  if not IsRowSelect and (HasSelection or HasHottrack) then
    DrawSelection(ACanvas);
  if HasTreeLines then
    DrawTreeLines(ACanvas);
  if HasExpandButton then
    DrawExpandButton(ACanvas);
  if HasCheckBox then
    DrawCheckBox(ACanvas);
  if HasImage then
    DrawImage(ACanvas);
  if HasStateImage then
    DrawStateImage(ACanvas);
  if not (TreeView.IsEditing and (Node = TreeView.EditingItem)) then
    DrawCaption(ACanvas);
  if not IsRowSelect and HasFocus then
    DrawFocus(ACanvas);
end;

procedure TdxTreeViewNodeViewInfo.Draw(ACanvas: TcxCanvas);
 begin
  ACanvas.SaveState;
  try
    FTextColor := Painter.GetTextColor(Self);
    if not TreeView.DoCustomDrawNode(ACanvas, Self) then
      DefaultDraw(ACanvas);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TdxTreeViewNodeViewInfo.DrawCaption(ACanvas: TcxCanvas);
begin
  Painter.DrawNodeCaption(ACanvas, TextRect, Self);
end;

procedure TdxTreeViewNodeViewInfo.DrawCheckBox(ACanvas: TcxCanvas);
begin
  Painter.DrawCheckBox(ACanvas, CheckBoxRect, Self);
end;

procedure TdxTreeViewNodeViewInfo.DrawExpandButton(ACanvas: TcxCanvas);
begin
  Painter.DrawExpandButton(ACanvas, ExpandButtonRect, Self);
end;

procedure TdxTreeViewNodeViewInfo.DrawFocus(ACanvas: TcxCanvas);
begin
  Painter.DrawNodeFocus(ACanvas, SelectionRect, Self);
end;

procedure TdxTreeViewNodeViewInfo.DrawImage(ACanvas: TcxCanvas);
begin
  Painter.DrawNodeImage(ACanvas, FImageRect, Self);
end;

procedure TdxTreeViewNodeViewInfo.DrawSelection(ACanvas: TcxCanvas);
begin
  Painter.DrawNodeSelection(ACanvas, SelectionRect, Self);
end;

procedure TdxTreeViewNodeViewInfo.DrawStateImage(ACanvas: TcxCanvas);
begin
  Painter.DrawNodeStateImage(ACanvas, FStateImageRect, Self);
end;

procedure TdxTreeViewNodeViewInfo.DrawTreeLine(ACanvas: TcxCanvas; const R: TRect);
begin
  Painter.DrawTreeLine(ACanvas, R, Self);
end;

procedure TdxTreeViewNodeViewInfo.DrawTreeLines(ACanvas: TcxCanvas);
var
  AParentNode: TdxTreeViewNode;
  AFullTreeLineVert: TRect;
begin
  DrawTreeLine(ACanvas, HorizontalTreeLineBounds);
  DrawTreeLine(ACanvas, VerticalTreeLineBounds);
  AParentNode := Node.Parent;
  AFullTreeLineVert := cxRectSetTop(VerticalTreeLineBounds, Bounds.Top, cxRectHeight(Bounds));
  while AParentNode <> TreeView.Root do
  begin
    AFullTreeLineVert := cxRectOffsetHorz(AFullTreeLineVert, -LevelIndent);
    if AParentNode.Next <> nil then
      DrawTreeLine(ACanvas, AFullTreeLineVert);
    AParentNode := AParentNode.Parent;
  end;
end;

procedure TdxTreeViewNodeViewInfo.SetData(ANode: TdxTreeViewNode);
var
  AHasStateImage: Boolean;
begin
  if FData <> ANode then
  begin
    FData := ANode;
    AHasStateImage := (ANode <> nil) and (TreeView.StateImages <> nil) and
      InRange(ANode.StateImageIndex, 0, TreeView.StateImages.Count - 1);
    FTextRect := FTextRects[AHasStateImage];
    FImageRect := FImageRects[AHasStateImage];
    FStateImageRect := FStateImageRects[AHasStateImage];
    AdjustTextRect(TreeView.Font);
    CalculateTreeLines;
  end;
end;

procedure TdxTreeViewNodeViewInfo.AdjustTextRect(AFont: TFont = nil);
var
  ATotalWidth, AWidth: Integer;
  AText: string;
  ALineBreakPos: Integer;
begin
  if Node <> nil then
  begin
    AText := Node.Caption;
    if AText = '' then
      AText := 'W'
    else
    begin
      ALineBreakPos := Pos(dxCRLF, AText);
      if ALineBreakPos > 0 then
        SetLength(AText, ALineBreakPos - 1);
    end;
    if AFont = nil then
      AFont := TreeView.Font;
    FTextWidth := TdxTextMeasurer.TextWidthTO(AFont, AText);
    if IsRightToLeftConverted then
      ATotalWidth := FTextRect.Right - Bounds.Left + LevelOffset
    else
      ATotalWidth := Bounds.Right - FTextRect.Left - LevelOffset;
    Inc(ATotalWidth, TreeView.ViewInfo.ViewPort.X);

    AWidth := Min(ATotalWidth, FTextWidth);
  end
  else
    if IsRightToLeftConverted then
      AWidth := FTextRect.Right - Bounds.Left
    else
      AWidth := Bounds.Right - FTextRect.Left;

  if IsRightToLeftConverted then
    FTextRect.Left := FTextRect.Right - AWidth
  else
    FTextRect.Right := FTextRect.Left + AWidth;
  FSelectionRect := CalculateSelectionRect;
end;

procedure TdxTreeViewNodeViewInfo.CalculateTreeLines;
var
  ACenter: TPoint;
begin
  FHorizontalTreeLineBounds := cxNullRect;
  FVerticalTreeLineBounds := cxNullRect;
  if (Node <> nil) and TreeView.OptionsView.ShowLines and
    ((Node.Parent <> TreeView.Root) or TreeView.OptionsView.ShowRoot) then
  begin
    ACenter := cxRectCenter(ExpandButtonRect);
    if IsRightToLeftConverted then
      FHorizontalTreeLineBounds := cxRect(ACenter.X, ACenter.Y - 1, ExpandButtonRect.Left, ACenter.Y)
    else
      FHorizontalTreeLineBounds := cxRect(ACenter.X, ACenter.Y - 1, ExpandButtonRect.Right, ACenter.Y);
    FVerticalTreeLineBounds := cxRect(ACenter.X, ACenter.Y, ACenter.X + 1, ACenter.Y);
    if (Node.Prev <> nil) or ((Node.Parent <> TreeView.Root) and not HasExpandButton) then
      FVerticalTreeLineBounds.Top := Bounds.Top;
    if Node.Next <> nil then
      FVerticalTreeLineBounds.Bottom := Bounds.Bottom;
    Exit;
  end;
end;

function TdxTreeViewNodeViewInfo.GetImageColorPalette(const R: TRect): IdxColorPalette;
var
  AState: TdxTreeViewNodeStates;
begin
  if ImageColorPalette <> nil then
    Result := ImageColorPalette
  else
  begin
    AState := GetState;
    if not FSelectionRect.IntersectsWith(R) then
    begin
      Exclude(AState, dxtnsHot);
      Exclude(AState, dxtnsSelected);
    end;
    Result := TreeView.LookAndFeelPainter.GetTreeViewNodeColorPalette(AState);
  end;
end;

function TdxTreeViewNodeViewInfo.GetState: TdxTreeViewNodeStates;
begin
  Result := [];
  if not TreeView.Enabled then
    Include(Result, dxtnsDisabled);
  if HasHottrack then
    Include(Result, dxtnsHot);
  if HasSelection then
    Include(Result, dxtnsSelected);
  if not TreeView.Focused and not TreeView.IsEditing then
    Include(Result, dxtnsInactive);
end;

function TdxTreeViewNodeViewInfo.GetImageIndex: Integer;
begin
  if TreeView.OptionsView.UseImageIndexForSelected and HasSelection then
    Result := TreeView.GetSelectedImageIndex(Node)
  else
    if TreeView.OptionsView.UseImageIndexForExpanded and Node.Expanded then
      Result := Node.ExpandedImageIndex
    else
      Result := TreeView.GetImageIndex(Node);
end;

function TdxTreeViewNodeViewInfo.HasCheckBox: Boolean;
begin
  Result := not cxRectIsEmpty(CheckBoxRect) and not Node.HideCheckBox;
end;

function TdxTreeViewNodeViewInfo.HasExpandButton: Boolean;
begin
  Result := Node.HasChildren and TreeView.OptionsView.ShowExpandButtons and
    ((Node.Parent <> TreeView.Root) or TreeView.OptionsView.ShowRoot);
end;

function TdxTreeViewNodeViewInfo.HasFocus: Boolean;
begin
  Result := TreeView.OptionsSelection.MultiSelect and Node.Focused and
    not Node.Selected and TreeView.Focused;
end;

function TdxTreeViewNodeViewInfo.HasRootIndent: Boolean;
begin
  Result := TreeView.OptionsView.ShowRoot and
      (TreeView.OptionsView.ShowExpandButtons or TreeView.OptionsView.ShowLines);
end;

function TdxTreeViewNodeViewInfo.HasHottrack: Boolean;
begin
  Result := (TreeView.HottrackItem = Node) or
    (TreeView.DropTarget = Node);
end;

function TdxTreeViewNodeViewInfo.HasImage: Boolean;
begin
  Result := not cxRectIsEmpty(ImageRect);
end;

function TdxTreeViewNodeViewInfo.HasSelection: Boolean;
begin
  Result := (Node.Selected or (TreeView.RightClickNode = Node)) and
    (TreeView.Focused or not TreeView.OptionsSelection.HideSelection) or (TreeView.EditingItem = Node);
end;

function TdxTreeViewNodeViewInfo.HasStateImage: Boolean;
begin
  Result := not IsRectEmpty(FStateImageRect);
end;

function TdxTreeViewNodeViewInfo.HasTreeLines: Boolean;
begin
  Result := not (cxRectIsEmpty(HorizontalTreeLineBounds) and cxRectIsEmpty(VerticalTreeLineBounds));
end;

procedure TdxTreeViewNodeViewInfo.DoRightToLeftConversion(ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  FCheckBoxRect := TdxRightToLeftLayoutConverter.ConvertRect(FCheckBoxRect, ABounds);
  FExpandButtonRect := TdxRightToLeftLayoutConverter.ConvertRect(FExpandButtonRect, ABounds);
  FImageRect := TdxRightToLeftLayoutConverter.ConvertRect(FImageRect, ABounds);
  FStateImageRect := TdxRightToLeftLayoutConverter.ConvertRect(FStateImageRect, ABounds);
  FTextRect := TdxRightToLeftLayoutConverter.ConvertRect(FTextRect, ABounds);
  FLevelIndent := -FLevelIndent;
  FTextRects[False] := TdxRightToLeftLayoutConverter.ConvertRect(FTextRects[False], ABounds);
  FImageRects[False] := TdxRightToLeftLayoutConverter.ConvertRect(FImageRects[False], ABounds);
  FStateImageRects[False] := TdxRightToLeftLayoutConverter.ConvertRect(FStateImageRects[False], ABounds);
  FTextRects[True] := TdxRightToLeftLayoutConverter.ConvertRect(FTextRects[True], ABounds);
  FImageRects[True] := TdxRightToLeftLayoutConverter.ConvertRect(FImageRects[True], ABounds);
  FStateImageRects[True] := TdxRightToLeftLayoutConverter.ConvertRect(FStateImageRects[True], ABounds);
end;

function TdxTreeViewNodeViewInfo.MeasureHeight(AImageSize, AExpandButtonSize, ACheckHeight, ATextHeight: Integer): Integer;
begin
  if TreeView.OptionsView.ItemHeight = 0 then
    Result := 2 * ScaleFactor.Apply(cxTextOffset)
  else
    Result := 0;
  if TreeView.IsExplorerStyle then
    Inc(Result, Result);
  if not TreeView.OptionsView.ShowCheckBoxes then
    ACheckHeight := 0;
  if not TreeView.OptionsView.ShowExpandButtons or not TreeView.OptionsView.ShowRoot then
    AExpandButtonSize := 0;
  Inc(Result, Max(Max(AImageSize, ACheckHeight), Max(AExpandButtonSize, ATextHeight)));
  Result := Max(Result, ScaleFactor.Apply(TreeView.OptionsView.ItemHeight));
end;

function TdxTreeViewNodeViewInfo.GetHeight: Integer;
begin
  Result := cxRectHeight(Bounds)
end;

function TdxTreeViewNodeViewInfo.GetImages: TCustomImageList;
begin
  Result := TreeView.Images;
end;

function TdxTreeViewNodeViewInfo.GetLevelOffset: Integer;
begin
  if Node <> nil then
  begin
    Result := Node.GetVisibleLevel * FLevelIndent;
    if not HasRootIndent then
      Dec(Result, (cxRectWidth(ExpandButtonRect) + ElementsOffset) * Sign(FLevelIndent));
  end
  else
    Result := 0;
end;

function TdxTreeViewNodeViewInfo.CalculateSelectionRect: TRect;
begin
  if not IsRowSelect then
  begin
    Result := TextRect;
    if not ImageRect.IsZero then
      Result := cxRectUnion(ImageRect, Result);
    Result := cxRectInflate(Result, ScaleFactor.Apply(cxTextOffset));
    Result.Top := Bounds.Top;
    Result.Bottom := Bounds.Bottom;
  end
  else
    Result.Empty;
end;

{ TdxTreeViewViewInfo }

constructor TdxTreeViewViewInfo.Create(ATreeView: TdxCustomTreeView);
begin
  inherited;
  FNodeViewInfo := CreateNodeViewInfo;
  FContentOffset := Point(1, 1);
  FBaseGroupInterval := 8;
  FBaseFirstGroupInterval := 15;
end;

destructor TdxTreeViewViewInfo.Destroy;
begin
  FreeAndNil(FNodeViewInfo);
  inherited;
end;

procedure TdxTreeViewViewInfo.Calculate(const ABounds: TRect);
var
  AContentOffset: TPoint;
begin
  inherited Calculate(ABounds);
  AContentOffset := ScaleFactor.Apply(FContentOffset);
  FContentRect := cxRectInflate(Bounds, -AContentOffset.X, -AContentOffset.Y);
  FContentSize.cx := CalculateContentWidth;
  NodeViewInfo.Calculate(cxRectSetWidth(FContentRect, FContentSize.cx));
  FContentSize.cy := AbsoluteVisibleNodes.Count * NodeViewInfo.Height;
  if TreeView.HasGroups then
  begin
    FGroupInterval := ScaleFactor.Apply(FBaseGroupInterval);
    FFirstGroupInterval := ScaleFactor.Apply(FBaseFirstGroupInterval);
    FContentSize.cy := FContentSize.cy + (GetGroupCount - 1) * FGroupInterval + FFirstGroupInterval;
  end;
end;

procedure TdxTreeViewViewInfo.CalculateHitTest(AHitTest: TdxTreeViewHitTest);
var
  ANodeIndex: Integer;
  APrevHitPoint: TPoint;
begin
  if GetNodeAtPos(AHitTest.HitPoint, ANodeIndex) then
  begin
    APrevHitPoint := AHitTest.HitPoint;
    NodeViewInfo.SetData(AbsoluteVisibleNodes[ANodeIndex]);
    try
      AHitTest.HitPoint := cxPointOffset(AHitTest.HitPoint, GetContentOffset, False);
      AHitTest.HitPoint := cxPointOffset(AHitTest.HitPoint, -NodeViewInfo.LevelOffset, -GetNodePositionByIndex(ANodeIndex));
      NodeViewInfo.CalculateHitTest(AHitTest);
      AHitTest.HitPoint := APrevHitPoint;
    finally
      NodeViewInfo.SetData(nil);
    end;
  end;
end;

procedure TdxTreeViewViewInfo.Draw(ACanvas: TcxCanvas);
var
  AOffset: TPoint;
  I: Integer;
  AFirstVisibleIndex: Integer;
  ALastVisibleIndex: Integer;
  AGroupIndex: Integer;
begin
  Painter.DrawBackground(ACanvas, Bounds, Self);
  if TreeView.DoCustomDraw(ACanvas, Self) or (AbsoluteVisibleNodes.Count = 0) then
    Exit;
  ACanvas.SaveState;
  try
    AOffset := GetContentOffset;
    AFirstVisibleIndex := FirstVisibleIndex;
    ALastVisibleIndex := Min(Ceil(AFirstVisibleIndex + NumberOfNodesInContentRect), AbsoluteVisibleNodes.Count - 1);
    MoveWindowOrg(ACanvas.Handle, AOffset.X, AOffset.Y + GetNodePositionByIndex(AFirstVisibleIndex));
    AGroupIndex := TreeView.AbsoluteVisibleItems[AFirstVisibleIndex].FGroupIndex;
    for I := AFirstVisibleIndex to ALastVisibleIndex do
    begin
      NodeViewInfo.SetData(AbsoluteVisibleNodes[I]);
      if TreeView.HasGroups and (NodeViewInfo.Node.FGroupIndex <> AGroupIndex) then
      begin
        MoveWindowOrg(ACanvas.Handle, 0, FGroupInterval);
        AGroupIndex := NodeViewInfo.Node.FGroupIndex;
      end;
      if IsRowSelect then
        if (NodeViewInfo.HasSelection or NodeViewInfo.HasHottrack) then
          Painter.DrawNodeSelection(ACanvas, GetNodeRowSelectionRect, NodeViewInfo)
        else
          if NodeViewInfo.HasFocus then
            Painter.DrawNodeFocus(ACanvas, GetNodeRowSelectionRect, NodeViewInfo);
      MoveWindowOrg(ACanvas.Handle, NodeViewInfo.LevelOffset, 0);
      NodeViewInfo.Draw(ACanvas);
      MoveWindowOrg(ACanvas.Handle, -NodeViewInfo.LevelOffset, NodeViewInfo.Height);
    end;
  finally
    NodeViewInfo.SetData(nil);
    ACanvas.RestoreState;
  end;
end;

function TdxTreeViewViewInfo.GetNodeAtPos(P: TPoint; out ANodeIndex: Integer): Boolean;
var
  AGroupIndex: Integer;
begin
  Result := False;
  if PtInRect(ContentRect, P) then
  begin
    P := cxPointOffset(P, ViewPort);
    P := cxPointOffset(P, ContentRect.TopLeft, False);
    ANodeIndex := GetNodeIndexByPosition(P.Y, AGroupIndex);
    Result := InRange(ANodeIndex, 0, AbsoluteVisibleNodes.Count - 1);
  end;
end;

function TdxTreeViewViewInfo.GetNumberOfNodesInContentRect: Integer;
begin
  Result := cxRectHeight(ContentRect) div NodeViewInfo.Height
end;

procedure TdxTreeViewViewInfo.SetViewPort(const AValue: TPoint);
begin
  FViewPort.X := Max(0, Min(AValue.X, ContentSize.cx - cxRectWidth(ContentRect)));
  FViewPort.Y := Max(0, Min(AValue.Y, ContentSize.cy - cxRectHeight(ContentRect)));
end;

function TdxTreeViewViewInfo.GetAbsoluteVisibleNodes: TdxFastList;
begin
  Result := TreeView.AbsoluteVisibleNodes;
end;

function TdxTreeViewViewInfo.GetContentOffset: TPoint;
var
  AOffset: TPoint;
begin
  AOffset := ViewPort;
  if IsRightToLeftConverted then
    AOffset.X := - AOffset.X;
  Result := cxPointOffset(cxNullPoint, AOffset, False);
end;

function TdxTreeViewViewInfo.GetNodeIndexByPosition(APos: Integer; out AGroupIndex: Integer): Integer;
var
  I: Integer;
  H: Integer;
begin
  AGroupIndex := -1;
  if TreeView.HasGroups then
  begin
    Result := -1;
    H := FFirstGroupInterval;
    if APos >= H then
      for I := 0 to GetGroupCount - 1 do
      begin
        H := H + GetGroupNodeCount (I) * NodeViewInfo.Height + FGroupInterval;
        AGroupIndex := I;
        if APos <= H then
        begin
          if APos <= H - FGroupInterval then
            Result := Trunc((APos - I * FGroupInterval - FFirstGroupInterval) / NodeViewInfo.Height);
          Break;
        end;
      end;
  end
  else
    Result := Trunc(APos / NodeViewInfo.Height);
end;

function TdxTreeViewViewInfo.GetNodePositionByIndex(AIndex: Integer): Integer;
begin
  Result := AIndex * NodeViewInfo.Height;
  if TreeView.HasGroups then
    Result := Result + TreeView.AbsoluteVisibleItems[AIndex].FGroupIndex * FGroupInterval + FFirstGroupInterval;
end;

function TdxTreeViewViewInfo.GetGroupNodeCount(AIndex: Integer): Integer;
begin
  Result := TreeView.FGroupNodeCounts[AIndex];
end;

function TdxTreeViewViewInfo.GetGroupCount: Integer;
begin
  Result := Length(TreeView.FGroupNodeCounts);
end;

function TdxTreeViewViewInfo.GetFirstVisibleIndex: Integer;
var
  AGroupIndex: Integer;
  I: Integer;
begin
  Result := GetNodeIndexByPosition(-GetContentOffset.Y, AGroupIndex);
  if Result < 0 then
    if AGroupIndex >= 0 then
    begin
      if AGroupIndex < GetGroupCount - 1 then
      begin
        Result := 0;
        for I := 0 to AGroupIndex do
          Result := Result + GetGroupNodeCount(I);
      end;
    end
    else
      Result := 0;
end;

function TdxTreeViewViewInfo.GetNodeRowSelectionRect: TRect;
begin
  Result := NodeViewInfo.Bounds;
end;

function TdxTreeViewViewInfo.CalculateContentWidth: Integer;

  function CalculateNodeWidth(ANode: TdxTreeViewNode): Integer;
  begin
    NodeViewInfo.SetData(ANode);
    Result := NodeViewInfo.TextRect.Left + NodeViewInfo.TextWidth;
    Inc(Result, NodeViewInfo.LevelOffset);
  end;

var
  I: Integer;
begin
  Result := cxRectWidth(FContentRect);
  if TreeView.ScrollBars in [ssBoth, ssHorizontal] then
  try
    NodeViewInfo.Calculate(FContentRect);
    for I := 0 to TreeView.AbsoluteVisibleNodes.Count - 1 do
      Result := Max(Result, CalculateNodeWidth(TreeView.AbsoluteVisibleNodes[I]));
    Dec(Result, Bounds.Left);
  finally
    NodeViewInfo.SetData(nil);
  end;
end;

procedure TdxTreeViewViewInfo.CheckViewPort;
begin
  ViewPort := ViewPort;
end;

function TdxTreeViewViewInfo.CreateNodeViewInfo: TdxTreeViewNodeViewInfo;
begin
  Result := TdxTreeViewNodeViewInfo.Create(TreeView);
end;

procedure TdxTreeViewViewInfo.DoRightToLeftConversion(ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  NodeViewInfo.RightToLeftConversion(ABounds);
end;

function TdxTreeViewOptionsView.GetDefaultShowEndEllipsis: Boolean;
begin
  Result := True;
end;

{ TdxTreeViewOptionsView }

function TdxTreeViewOptionsView.GetImages: TCustomImageList;
begin
  Result := TreeView.Images;
end;

function TdxTreeViewOptionsView.GetRowSelect: Boolean;
begin
  Result := TreeView.OptionsSelection.RowSelect;
end;

procedure TdxTreeViewOptionsView.SetImages(AValue: TCustomImageList);
begin
  TreeView.Images := AValue;
end;

procedure TdxTreeViewOptionsView.SetRowSelect(AValue: Boolean);
begin
  TreeView.OptionsSelection.RowSelect := AValue;
end;

{ TdxInternalTreeView }


function TdxInternalTreeView.CreateOptionsView: TdxTreeViewCustomOptionsView;
begin
  Result := TdxTreeViewOptionsView.Create(Self);
end;

function TdxInternalTreeView.GetDefaultScrollbarsValue: TcxScrollStyle;
begin
  Result := ssVertical;
end;

function TdxInternalTreeView.GetOptionsView: TdxTreeViewOptionsView;
begin
  Result := inherited OptionsView as TdxTreeViewOptionsView;
end;

procedure TdxInternalTreeView.SetOptionsView(AValue: TdxTreeViewOptionsView);
begin
  inherited OptionsView := AValue;
end;

{ TdxTreeViewControlOptionsBehavior }

constructor TdxTreeViewControlOptionsBehavior.Create(ATreeView: TdxCustomTreeView);
begin
  inherited Create(ATreeView);
  CaptionEditing := True;
end;

{ TdxTreeViewControlOptionsSelection }

function TdxTreeViewControlOptionsSelection.DefaultHideSelectionValue: Boolean;
begin
  Result := True;
end;

{ TdxTreeViewControl }

function TdxTreeViewControl.CreateOptionsBehavior: TdxTreeViewCustomOptionsBehavior;
begin
  Result := TdxTreeViewControlOptionsBehavior.Create(Self);
end;

function TdxTreeViewControl.CreateOptionsSelection: TdxTreeViewCustomOptionsSelection;
begin
  Result := TdxTreeViewControlOptionsSelection.Create(Self);
end;

function TdxTreeViewControl.CreateOptionsView: TdxTreeViewCustomOptionsView;
begin
  Result := TdxTreeViewControlOptionsView.Create(Self);
end;

function TdxTreeViewControl.CreatePainter: TdxTreeViewPainter;
begin
  Result := TdxTreeViewPainter.Create(Self);
end;

procedure TdxTreeViewControl.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadData, WriteData, Root.HasChildren);
end;

function TdxTreeViewControl.GetDefaultHeight: Integer;
begin
  Result := dxDefaultHeight;
end;

function TdxTreeViewControl.GetDefaultWidth: Integer;
begin
  Result := dxDefaultWidth;
end;

function TdxTreeViewControl.GetOptionsBehavior: TdxTreeViewControlOptionsBehavior;
begin
  Result := inherited OptionsBehavior as TdxTreeViewControlOptionsBehavior;
end;

function TdxTreeViewControl.GetOptionsSelection: TdxTreeViewControlOptionsSelection;
begin
  Result := inherited OptionsSelection as TdxTreeViewControlOptionsSelection;
end;

function TdxTreeViewControl.GetOptionsView: TdxTreeViewControlOptionsView;
begin
  Result := inherited OptionsView as TdxTreeViewControlOptionsView;
end;

procedure TdxTreeViewControl.SetOptionsBehavior(AValue: TdxTreeViewControlOptionsBehavior);
begin
  inherited OptionsBehavior := AValue;
end;

procedure TdxTreeViewControl.SetOptionsSelection(
  AValue: TdxTreeViewControlOptionsSelection);
begin
  inherited OptionsSelection := AValue;
end;

procedure TdxTreeViewControl.SetOptionsView(AValue: TdxTreeViewControlOptionsView);
begin
  inherited OptionsView := AValue;
end;

end.


