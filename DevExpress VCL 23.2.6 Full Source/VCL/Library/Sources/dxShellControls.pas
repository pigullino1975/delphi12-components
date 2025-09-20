{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
{   ACCOMPANYING VCL AND CLX CONTROLS AS PART OF AN EXECUTABLE       }
{   PROGRAM ONLY.                                                    }
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

unit dxShellControls;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  Windows, SysUtils, Classes, Controls, AppEvnts, ShlObj, ShellAPI, Messages, Math, Types, CommCtrl,
  Forms, StdCtrls, ImgList, Graphics, ComCtrls, ActiveX, Generics.Collections, Generics.Defaults,
  dxCore, dxCoreGraphics, dxCoreClasses, cxClasses, cxControls, cxGraphics, cxGeometry, cxLookAndFeelPainters, dxSkinsCore,
  cxCustomCanvas, dxGDIPlusClasses, dxThreading, cxImageList,
  cxShellCommon, cxShellControls, dxTreeView, dxCustomTree, dxListView, cxShellListView, cxShellTreeView;

type
  TdxCustomShellTreeView = class;
  TdxCustomShellListView = class;

  TdxShellImageListIconType = (Small, Large, ExtraLarge, Jumbo);

  { TdxShellImageList }

  TdxShellImageList = class(TcxBaseImageList) // for internal use only
  protected
  const
    DefaultSmallSize = 16;
    DefaultLargeSize = 32;
    DefaultExtraLargeSize = 48;
    DefaultJumboSize = 256;
  strict private
    FScaleFactor: TdxScaleFactor;
    FShellIconType: TdxShellImageListIconType;
    FShellNeedUpdate: Boolean;
    FShellUpdateCount: Integer;
    procedure SetShellIconType(AValue: TdxShellImageListIconType);
  protected
    function CreateHandle: HImageList;
    function GetActualIconFlag: Integer;
    function GetActualIconSize: Integer;
    function GetImageListHandle(AType: TdxShellImageListIconType): HImageList;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateEx(AOwner: TComponent; AIconType: TdxShellImageListIconType; AScaleFactor: TdxScaleFactor); overload;
    destructor Destroy; override;

    function GetShellIconIndex(const AFileName: string): Integer;
    function GetShellVisualIconSize: TSize;

    procedure ShellReload;
    procedure ShellRecreateHandle;
    procedure ScaleChanged(AScaleFactor: TdxScaleFactor);

    procedure ShellBeginUpdate;
    procedure ShellEndUpdate;
    property ShellUpdateCount: Integer read FShellUpdateCount;

    property ShellIconType: TdxShellImageListIconType read FShellIconType write SetShellIconType;
  end;

  { TdxShellSmallImageList }
  TdxShellSmallImageList = class(TcxBaseImageList) // for internal use only
  strict private
    FScaleFactor: TdxScaleFactor;
    procedure RecreateHandle;
    procedure UpdateSourceDPI;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Reload;
    procedure ScaleChanged(AScaleFactor: TdxScaleFactor);
  end;

  TdxShellTreeViewItemTask = class(TdxShellItemTask) // for internal use only
  strict private
    FCheckSubItems: Boolean;
    FParentShellFolder: IShellFolder;
    FEnumFlags: Cardinal;
    //
    FHasSubItems: Boolean;
  protected
    procedure DoUpdateItem; override;
    procedure DoWork; override;
  public
    constructor Create(AItem: TcxShellItemInfo); override;
    destructor Destroy; override;
  end;

  { TdxShellTreeViewItemProducer }

  TdxShellTreeViewItemProducer = class(TdxCustomShellTreeItemProducer) // for internal use only
  strict private
    FNode: TdxTreeViewNode;
    //
    function GetTreeView: TdxCustomShellTreeView;
  protected
    function CanAddFolder(AFolder: TcxShellFolder): Boolean; override;
    function CanCancelTask: Boolean; override;
    function CreateFakeProducer: TdxCustomShellTreeItemProducer; override;
    function CreateTask(AItem: TcxShellItemInfo): TdxShellItemTask; override;
    function GetEnumFlags: Cardinal; override;
    function GetItemsInfoGatherer: TcxShellItemsInfoGatherer; override;
    function GetShowToolTip: Boolean; override;
    procedure ItemImageUpdated(AItem: TcxShellItemInfo); override;
    //
    property Node: TdxTreeViewNode read FNode write FNode;
    property TreeView: TdxCustomShellTreeView read GetTreeView;
  public
    constructor Create(AOwner: TWinControl); override;
    destructor Destroy; override;
    //
    procedure NotifyAddItem(Index: Integer); override;
    procedure NotifyRemoveItem(Index: Integer); override;
    procedure ProcessItems(AIFolder: IShellFolder; APIDL: PItemIDList; ANode: TdxTreeViewNode;
      APreloadItemCount: Integer); reintroduce; overload;
    procedure SetItemsCount(Count: Integer); override;
  end;

  { TdxShellTreeViewContextMenu }

  TdxShellTreeViewContextMenu = class(TcxShellCustomContextMenu) // for internal use only
  strict private
    FItemProducer: TdxShellTreeViewItemProducer;
    procedure ItemProducerDestroyHandler(Sender: TObject);
  private
    FTreeView: TdxCustomShellTreeView;
    FNode: TdxTreeViewNode;
    procedure AssignProducer;
    procedure UnassignProducer;
  protected
    procedure ExecuteMenuItemCommand(ACommandId: Cardinal); override;
    function GetContextMenuQueryFlags: Cardinal; override;
    function GetSite: IUnknown; override;
    function GetWindowHandle: THandle; override;
    procedure Populate; override;
  public
    constructor Create(ATreeView: TdxCustomShellTreeView; ANode: TdxTreeViewNode);
    property TreeView: TdxCustomShellTreeView read FTreeView;
  end;

  { TdxShellTreeViewOptions }

  TdxShellTreeViewOptions = class(TcxShellOptions)
  strict private const
    DefaultShowNonFoldersValue = False;
  protected
    procedure DoNotifyUpdateContents; override;
    function GetDefaultShowToolTipValue: Boolean; override;
    function IsDefaultShowNonFolders: Boolean; override;
  published
    property FileMask;
    property ShowNonFolders default DefaultShowNonFoldersValue;
    property ShowToolTip default False;
  end;

  TdxShellTreeViewNode = class(TdxTreeViewNode) // for internal use only
  public
    procedure DeleteChildren; override;
  end;

  TdxShellTreeViewStateData = record // for internal use only
    CurrentPath: PItemIDList;
    ExpandedNodeList: TList;
    ViewPort: TPoint;
  end;

  TdxShellTreeViewPainter = class(TdxTreeViewPainter) // for internal use only
  protected
    procedure DrawNodeCaption(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); override;
    procedure DrawNodeImage(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo); override;
  end;

  { TdxShellTreeViewControlOptionsView }

  TdxShellTreeViewControlOptionsView = class(TdxTreeViewCustomOptionsView)
  published
    property Indent;
    property ItemHeight default 0;
    property ScrollBars default ssBoth;
    property ShowEndEllipsis default False;
    property ShowExpandButtons default True;
    property ShowLines default True;
    property ShowRoot default True;
  end;

  { TdxShellTreeViewControlOptionsBehavior }

  TdxShellTreeViewControlOptionsBehavior = class(TdxTreeViewCustomOptionsBehavior)
  strict private
    FAllowDragDrop: Boolean;
  public
    constructor Create(ATreeView: TdxCustomTreeView); override;
    procedure Assign(Source: TPersistent); override;
  published
    property AllowDragDrop: Boolean read FAllowDragDrop write FAllowDragDrop default True;
    property AutoExpand;
    property CaptionEditing default True;
    property ChangeDelay default 0;
    property HotTrack default False;
    property ToolTips;
  end;

  { TdxShellTreeViewControlOptionsSelection }

  TdxShellTreeViewControlOptionsSelection = class(TdxTreeViewCustomOptionsSelection)
  protected
    function DefaultHideSelectionValue: Boolean; override;
  published
    property HideSelection default True;
    property RowSelect default False;
    property RightClickSelect default False;
  end;

  TdxShellTreeViewRoot = class(TcxCustomShellRoot)
  protected
    function GetParentWindow: HWND; override;
  end;

  { TdxCustomShellTreeView }

  TdxCustomShellTreeView = class(TdxCustomTreeView, IDropTarget, IcxShellDependedControls, IcxShellRoot)
  strict private type
  {$REGION 'Private types'}
    TdxShellSystemEventInfo = record
      EventID: Longint;
      Pidl1: PItemIDList;
      Pidl2: PItemIDList;
    end;
  {$ENDREGION}
  strict private
    FAppEvents: TApplicationEvents;
    FCutItemPIDL: PItemIDList;
    FShellRootNode: TdxTreeViewNode;
    // drag&drop
    FAutoScrollHelper: TdxAutoScrollHelper;
    FCurrentDropTarget: IDropTarget;
    FDragSource: TdxTreeViewNode;
    FDropTargetHelper: IDropTargetHelper;
    FDraggedObject: IDataObject;
    FExpandingNode: TdxTreeViewNode;
    FExpandTimer: TcxTimer;
    FPrevDragOverPoint: TPoint;
    FShellDragDropState: TcxDragAndDropState;
    //
    FDefferedShellSystemEvents: TList<TdxShellSystemEventInfo>;
    FEventProcessingCount: Integer;
    FFavoritesRootNode: TdxTreeViewNode;
    FFavoritesShellChangeNotifierData: TcxShellChangeNotifierData;
    FFirstLevelNodesVisible: Boolean;
    FInternalSmallImages: TdxShellSmallImageList;
    FIsChangeNotificationCreationLocked: Boolean;
    FIsContextPopupProcessing: Boolean;
    FIsUpdating: Boolean;
    FItemProducersList: TThreadList;
    FItemsInfoGatherer: TcxShellItemsInfoGatherer;
    FGroupIndex: Integer;
    FLoadedGroupIndex: Integer;
    FLockChange: Integer;
    FLockVisibleUpdate: Integer;
    FQuickAccessRootNode: TdxTreeViewNode;
    FNavigation: Boolean;
    FNeedUpdateImages: Boolean;
    FShellChangeNotificationCreation: Boolean;
    FShellChangeNotifierData: TcxShellChangeNotifierData;
    FShellOptions: TdxShellTreeViewOptions;
    FShellRoot: TdxShellTreeViewRoot;
    FStateData: TdxShellTreeViewStateData;
    FShellDependedControls: TcxShellDependedControls;
    //
    FOnAddFolder: TcxShellAddFolderEvent;
    FOnPathChanged: TNotifyEvent;
    FOnRootChanged: TcxRootChangedEvent;
    FOnShellChange: TcxShellChangeEvent;
    // DefferedShellSystemEvents
    procedure AddDefferedShellSystemEvent(AEventID: Longint; APidl1, APidl2: PItemIDList);
    procedure ClearDefferedShellSystemEvents;
    procedure ProcessDefferedShellSystemEvents;
    //
    procedure CreateDropTarget;
    function CreateShellNode(AParentNode: TdxTreeViewNode;
      AShellItem: TcxShellItemInfo): TdxTreeViewNode;
    procedure DoBeginDrag;
    procedure DoHandleDependedInitialization;
    procedure DoNavigate(APidl: PItemIDList);
    procedure DoPathChanged;
    procedure DoProcessSystemShellChange(AEventID: Longint; APidl1, APidl2: PItemIDList);
    procedure InternalUpdateNode(ANode: TdxTreeViewNode);
    function GetAbsolutePIDL: PItemIDList;
    function GetOptionsBehavior: TdxShellTreeViewControlOptionsBehavior;
    function GetOptionsSelection: TdxShellTreeViewControlOptionsSelection;
    function GetOptionsView: TdxShellTreeViewControlOptionsView;
    function GetPath: string;
    procedure LockUpdateVisibleInfo;
    procedure OnExpandTimer(Sender: TObject);
    procedure RestoreTreeState;
    procedure RootFolderChanged(Sender: TObject; Root: TcxCustomShellRoot);
    procedure RootSettingsChanged(Sender: TObject);
    procedure SaveTreeState;
    procedure SetAbsolutePIDL(AValue: PItemIDList);
    procedure SetFirstLevelNodesVisible(AValue: Boolean);
    procedure SetGroupIndex(AValue: Integer);
    procedure SetOptionsBehavior(AValue: TdxShellTreeViewControlOptionsBehavior);
    procedure SetOptionsSelection(AValue: TdxShellTreeViewControlOptionsSelection);
    procedure SetOptionsView(AValue: TdxShellTreeViewControlOptionsView);
    procedure SetPath(AValue: string);
    procedure SetRootField(AValue: TdxShellTreeViewRoot);
    procedure ShellChangeNotify(AEventID: Longint; APidl1, APidl2: PItemIDList);
    function TryReleaseDropTarget: HResult;
    procedure UnlockUpdateVisibleInfo;
    procedure UpdateDropTarget(const APoint: TPoint; out ANew: Boolean);
    procedure InternalUpdateDropTarget(ANode: TdxTreeViewNode);
    //
    procedure DsmDoNavigate(var Message: TMessage); message DSM_DONAVIGATE;
    procedure DSMNotifyAddItem(var Message: TMessage); message DSM_NOTIFYADDITEM;
    procedure DSMNotifyRemoveItem(var Message: TMessage); message DSM_NOTIFYREMOVEITEM;
    procedure DSMSetCount(var Message: TMessage); message DSM_SETCOUNT;
    procedure DSMSynchronizeRoot(var Message: TMessage); message DSM_SYNCHRONIZEROOT;
    procedure DSMSystemShellChangeNotify(var Message: TMessage); message DSM_SYSTEMSHELLCHANGENOTIFY;
  private
    FIsInternalItemCreation: Boolean;
    procedure AddDefferedUpdateContent;
    procedure DoOnAddFolder(AFolder: TcxShellFolder; var ACanAdd: Boolean);
    function IsShellRootNode(ANode: TdxTreeViewNode): Boolean;
    function IsFavoritesItemNode(ANode: TdxTreeViewNode): Boolean;
    function IsQuickAccessItemNode(ANode: TdxTreeViewNode): Boolean;
    function IsFavoritesParentFakeNode(ANode: TdxTreeViewNode): Boolean;
    function IsShellOrFavoritesRootNode(ANode: TdxTreeViewNode): Boolean;
  protected
    function AllowInfoTips: Boolean; override;
    procedure AssignFromCxShellTreeView(ASource: TcxShellTreeView);
    function CanCollapse(Sender: TdxTreeCustomNode): Boolean; override;
    function CanExpand(Sender: TdxTreeCustomNode): Boolean; override;
    procedure DeleteNode(Sender: TdxTreeCustomNode); override;
    procedure DestroyWnd; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure DoHint(ANode: TdxTreeViewNode; var AText: string); override;
    procedure InitControl; override;
    function IsExplorerStyle: Boolean; override;
    function IsFavoritesVisible: Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    // IDropTarget
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function IDropTarget.DragOver = IDropTargetDragOver;
    function IDropTargetDragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    // IcxShellDependedControls
    function GetDependedControls: TcxShellDependedControls;
    // IcxShellRoot
    function GetRoot: TcxCustomShellRoot;
    //
    procedure AddItemProducer(AProducer: TdxShellTreeViewItemProducer);
    function CanEdit(ANode: TdxTreeViewNode): Boolean; override;
    procedure ChangeTreeContent(AChangeProc: TProc);
    function CheckFileMask(AFolder: TcxShellFolder): Boolean;
    procedure CreateChangeNotification(ANode: TdxTreeViewNode = nil);
    function CreateOptionsBehavior: TdxTreeViewCustomOptionsBehavior; override;
    function CreateOptionsSelection: TdxTreeViewCustomOptionsSelection; override;
    function CreateOptionsView: TdxTreeViewCustomOptionsView; override;
    function CreatePainter: TdxTreeViewPainter; override;
    procedure CutNode(ANode: TdxTreeViewNode);
    function DoAddFolder(AFolder: TcxShellFolder): Boolean;
    procedure ChangeScaleEx(M, D: Integer; isDpiChange: Boolean); override;
    procedure DoEdited(ANode: TdxTreeViewNode; var ACaption: string); override;
    procedure DoOnIdle(Sender: TObject; var Done: Boolean);
    procedure DoSelectionChanged; override;
    procedure DoSelectNodeByMouse(ANode: TdxTreeViewNode; AShift: TShiftState; AHitAtCheckBox: Boolean); override;
    function GetContextMenuSite: IUnknown; virtual;
    function GetItemProducer(ANode: TdxTreeViewNode): TdxShellTreeViewItemProducer;
    function GetNodeByPIDL(APIDL: PItemIDList; ANearestInChain: Boolean = False;
        ACheckExpanded: Boolean = False; ACheckCreated: Boolean = True;
        AStartParentNode: TdxTreeViewNode = nil): TdxTreeViewNode;
    function GetNodeClass: TdxTreeViewNodeClass; override;
    function GetShellItemInfo(ANode: TdxTreeViewNode): TcxShellItemInfo;
    procedure InplaceEditKeyPress(Sender: TObject; var Key: Char); override;
    procedure ProcessDragAndDropOnMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ProcessDragAndDropOnMouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure RemoveChangeNotification;
    procedure RemoveItemProducer(AProducer: TdxShellTreeViewItemProducer);
    function ShowFirstLevelNodes: Boolean; override;
    procedure ShowInplaceEdit(ANode: TdxTreeViewNode; const ABounds: TRect; const AText: string; AFont: TFont;
      ASelStart, ASelLength: Integer; AMaxLength: Integer); override;
    procedure UpdateImages;
    procedure UpdateItem(AItem: TcxShellItemInfo);
    procedure UpdateNode(ANode: TdxTreeViewNode; AFast: Boolean);
    procedure UpdateRootNodes;
    procedure UpdateVisibleItems;
    procedure ValidatePasteText(var AText: string); override;
    procedure ViewPortChanged; override;
    //
    property OptionsBehavior: TdxShellTreeViewControlOptionsBehavior read GetOptionsBehavior write SetOptionsBehavior;
    property OptionsSelection: TdxShellTreeViewControlOptionsSelection read GetOptionsSelection write SetOptionsSelection;
    property OptionsView: TdxShellTreeViewControlOptionsView read GetOptionsView write SetOptionsView;
    //
    property FirstLevelNodesVisible: Boolean read FFirstLevelNodesVisible write SetFirstLevelNodesVisible;
    property IsContextPopupProcessing: Boolean read FIsContextPopupProcessing;
    property ItemsInfoGatherer: TcxShellItemsInfoGatherer read FItemsInfoGatherer;
    property ShellRootNode: TdxTreeViewNode read FShellRootNode;
    property FavoritesRootNode: TdxTreeViewNode read FFavoritesRootNode;
    property QuickAccessRootNode: TdxTreeViewNode read FQuickAccessRootNode;
    //
    property OnPathChanged: TNotifyEvent read FOnPathChanged write FOnPathChanged;
    property OnRootChanged: TcxRootChangedEvent read FOnRootChanged write FOnRootChanged;
    property OnShellChange: TcxShellChangeEvent read FOnShellChange write FOnShellChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetNodeAbsolutePIDL(ANode: TdxTreeViewNode): PItemIDList;
    procedure UpdateContent;
    //
    property AbsolutePIDL: PItemIDList read GetAbsolutePIDL write SetAbsolutePIDL;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property Path: string read GetPath write SetPath;
    property ScrollBars;
    property ShellOptions: TdxShellTreeViewOptions read FShellOptions write FShellOptions;
    property ShellRoot: TdxShellTreeViewRoot read FShellRoot write SetRootField;
    //
    property OnAddFolder: TcxShellAddFolderEvent read FOnAddFolder write FOnAddFolder;
    property OnKeyDown;
    property OnMouseDown;
    property OnSelectionChanged;
  end;

  TdxShellTreeView = class(TdxCustomShellTreeView)
  strict private const
    dxDefaultHeight = 100;
    dxDefaultWidth = 120;
    function GetFolder(AIndex: Integer): TcxShellFolder;
    function GetFolderCount: Integer;
  protected
    function GetDefaultHeight: Integer; override;
    function GetDefaultWidth: Integer; override;
  public
    property FolderCount: Integer read GetFolderCount;
    property Folders[AIndex: Integer]: TcxShellFolder read GetFolder;
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
    property GroupIndex default -1;
    property Height default dxDefaultHeight;
    property LookAndFeel;
    property OptionsBehavior;
    property OptionsSelection;
    property OptionsView;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShellOptions;
    property ShellRoot;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property Width default dxDefaultWidth;
    property OnAddFolder;
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
    property OnShellChange;
    property OnStartDock;
    property OnStartDrag;
  end;

  TdxShellListViewItemTask = class(TdxShellItemTask) // for internal use only
  strict private
    FPidl: PItemIDList;
    FParentShellFolder: IShellFolder;
    FThumbnailSize: TSize;
    FUseThumbnail: Boolean;
    //
    FHBitmap: HBITMAP;
    function GetThumbnailBitmap: HBitmap;
  protected
    procedure DoUpdateItem; override;
    procedure DoWork; override;
  public
    constructor Create(AItem: TcxShellItemInfo); override;
    destructor Destroy; override;
  end;

  { TdxShellListViewItemProducer }

  TdxShellListViewItemProducer = class(TcxCustomItemProducer)
  strict private const
    SID_IQueryContinue = '{7307055C-B24A-486B-9F25-163E597A28A9}';
    IID_IQueryContinue: TGUID = SID_IQueryContinue;
  strict private
    FEnumeratedPidls: TdxFastList;
    FIsCheckingEnumeration: Boolean;
    FIsPopulating: Boolean;
    FIsPopulatingCompleted: Boolean;
    FIsSortingCompleted: Boolean;
    FIsDestroying: Boolean;
  strict private type
  {$REGION 'Private types'}
  {$TYPEINFO OFF}
    IQueryContinue = interface(IUnknown)
      [SID_IQueryContinue]
      function QueryContinue: HRESULT; stdcall;
    end;
  {$TYPEINFO ON}

    TdxShellListViewInternalTask = class(TdxShellInternalTask)
    protected
      function GetProducer: TdxShellListViewItemProducer;
      property Producer: TdxShellListViewItemProducer read GetProducer;
    end;

    TdxShellListViewEnumerateItemsTask = class(TdxShellListViewInternalTask, IServiceProvider, IQueryContinue)
    protected
      // IServiceProvider
      function QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;
      // IQueryContinue
      function QueryContinue: HRESULT; stdcall;
      //
      procedure Complete; override;
      procedure DoExecute; override;
    end;

    TdxShellListSortItemsTask = class(TdxShellListViewInternalTask)
    strict private
      FSortFunction: TdxListSortCompareDelegate;
      function Compare(AItem1, AItem2: Pointer): Integer;
    protected
      procedure DoExecute; override;
    public
      constructor Create(AProducer: TcxCustomItemProducer);
    end;
  {$ENDREGION}
  private
    FEnumeratingItemsTaskHandle: THandle;
    FEnumeratingItemPidls: TdxFastThreadList;
    FIsItemsStoreFull: Boolean;
    FSortingItems: TdxFastList;
    FSortingItemsTaskHandle: THandle;
    FThumbnails: THandle;
    //
    function AddThumbnailToImageList(AItem: TcxShellItemInfo; AHBitmap: HBITMAP; const ARequiredSize: TSize): Integer;
    procedure CheckEnumeration;
    procedure CheckThumbnails;
    function GetListView: TdxCustomShellListView;
    procedure ItemEnumerationCompleted;
    procedure ItemSortCompleted;
  protected
    function CanAddFolder(AFolder: TcxShellFolder): Boolean; override;
    function CanCancelTask: Boolean; override;
    procedure CancelSortingTask;
    procedure ClearFetchQueue; override;
    function CreateTask(AItem: TcxShellItemInfo): TdxShellItemTask; override;
    function DoCompareItems(AItem1, AItem2: TcxShellFolder; out ACompare: Integer): Boolean; override;
    procedure DoDestroy; override;
    procedure DoSort; override;
    procedure FetchItems(APreloadItems: Integer); override;
    function GetEnumFlags: Cardinal; override;
    function GetFolderForEnumeration: IShellFolder; override;
    function GetItemsInfoGatherer: TcxShellItemsInfoGatherer; override;
    function GetShowToolTip: Boolean; override;
    function IsSortSupported: Boolean;
    procedure ItemImageUpdated(AItem: TcxShellItemInfo); override;
    procedure RecreateListItems;
    function SlowInitializationDone(AItem: TcxShellItemInfo): Boolean; override;
    //
    property IsPopulating: Boolean read FIsPopulating;
    property IsPopulatingCompleted: Boolean read FIsPopulatingCompleted;
    property IsSortingCompleted: Boolean read FIsSortingCompleted;
    property ListView: TdxCustomShellListView read GetListView;
  public
    constructor Create(AOwner: TWinControl); override;
    procedure ClearItems; override;
    procedure ProcessDetails(ShellFolder: IShellFolder; CharWidth: Integer); override;
    procedure ProcessItems(AIFolder: IShellFolder; AFolderPIDL: PItemIDList; APreloadItemCount: Integer); override;
    procedure SetItemsCount(ACount: Integer); override;
  end;

  { TdxShellListViewContextMenu }

  TdxShellListViewContextMenu = class(TcxShellCustomContextMenu) // for internal use only
  private
    FListView: TdxCustomShellListView;
  protected
    procedure ExecuteMenuItemCommand(ACommandId: Cardinal); override;
    function GetContextMenuQueryFlags: Cardinal; override;
    function GetWindowHandle: THandle; override;
    procedure Populate; override;
  public
    constructor Create(AListView: TdxCustomShellListView);
    property ListView: TdxCustomShellListView read FListView;
  end;
  TdxShellListViewContextMenuClass = class of TdxShellListViewContextMenu;

  { TdxShellListViewCurrentFolderContextMenu }

  TdxShellListViewCurrentFolderContextMenu = class(TdxShellListViewContextMenu) // for internal use only
  private
    FLastSortColumnIndexCommandId: Cardinal;
    procedure AddCheckItem(const ACaption: string; AId: Cardinal; AIsChecked: Boolean; AIsEnabled: Boolean = True;
      AMenu: HMenu = 0);
    procedure AddItem(const ACaption: string; AId: Cardinal; AIsEnabled: Boolean = True; AMenu: HMenu = 0);
    procedure AddRadioGroup(AItems: array of string; AStartId, AStartPos: Cardinal; AItemIndex: Integer;
     AMenu: HMenu = 0);
    procedure AddSeparator(AMenu: HMenu = 0);
    function AddSubItem(const ACaption: string; AMenu: HMenu = 0): HMenu;
  protected
    procedure ExecuteMenuItemCommand(ACommandId: Cardinal); override;
    function GetSite: IUnknown; override;
    procedure Populate; override;
  end;

  { TdxShellListViewOptions }

  TdxShellListViewOptions = class(TcxShellListViewOptions)
  strict private
    FShowReadOnly: Boolean;
  private
    procedure SetShowReadOnly(const Value: Boolean);
  protected
    procedure DoAssign(Source: TcxShellOptions); override;
  public
    constructor Create(AOwner: TWinControl); override;
  published
    property ShowReadOnly: Boolean read FShowReadOnly write SetShowReadOnly default True;
  end;

  TdxCustomShellListViewReportOptions = class(TdxListViewReportOptions)
  protected
    function IsAlwaysShowItemImageInFirstColumnStored: Boolean; override;
    function IsRowSelectStored: Boolean; override;
  end;

  { TdxShellListItemViewInfo }

  TdxShellListItemViewInfo = class(TdxListItemViewInfo) // for internal use only
  strict private
    function GetShellListView: TdxCustomShellListView;
  protected
    procedure DrawGlyph(ACanvas: TcxCustomCanvas); override;
    function GetHintText: string; override;
    function NeedShowHint: Boolean; override;
    property ShellListView: TdxCustomShellListView read GetShellListView;
  end;

  { TdxShellListItemReportStyleViewInfo }

  TdxShellListItemReportStyleViewInfo = class(TdxListItemReportStyleViewInfo)
  strict private
    function GetShellListView: TdxCustomShellListView;
  protected
    function GetHintText: string; override;
    function NeedShowHint: Boolean; override;
    property ShellListView: TdxCustomShellListView read GetShellListView;
  end;

  { TdxShellListViewViewInfo }

  TdxShellListViewViewInfo = class(TdxListViewViewInfo) // for internal use only
  protected
    function CreateItemViewInfo(AOwner: TdxListGroupCustomViewInfo; AItemIndex: Integer): TdxListItemCustomViewInfo; override;
    function GetIconsGlyphSideGap: Integer; override;
  end;

  { TdxShellListViewController }

  TdxShellListViewController = class(TdxListViewController) // for internal use only
  protected
    function CanSelectColumnInDesigner: Boolean; override;
    function NeedToRestoreSingleItemSelection(AShift: TShiftState): Boolean; override;
  public
    procedure KeyDown(AKey: Word; AShift: TShiftState); override;
    procedure SelectAll;
  end;

  TdxShellListViewHintHelper = class(TdxListViewHintHelper) // for internal use
  protected
    procedure CorrectHintWindowRect(var ARect: TRect); override;
  end;

  TdxShellListViewIconOptions = class(TdxListViewIconOptions)
  private
    function GetIconSize: TcxShellIconSize;
    procedure SetIconSize(const AValue: TcxShellIconSize);
    function GetShellListView: TdxCustomShellListView;
  protected
    procedure DoAssign(ASource: TPersistent); override;
    property ShellListView: TdxCustomShellListView read GetShellListView;
  published
    property IconSize: TcxShellIconSize read GetIconSize write SetIconSize default isDefault;
  end;

  { TdxShellListViewColumn }

  TdxShellListViewColumn = class(TdxListColumn) // for internal use only
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TdxShellListViewRoot = class(TcxCustomShellRoot)
  protected
    function GetParentWindow: HWND; override;
  end;

  { TdxCustomShellListView }

  TdxNavigationEvent = procedure (Sender: TdxCustomShellListView; APIDL: PItemIDList; ADisplayName: string) of object;

  TdxCustomShellListView = class(TdxCustomListView, IDropTarget, IcxShellDependedControls, IcxShellRoot)
  strict private type
  {$REGION 'Private types'}
    TdxShellSystemEventInfo = record
      EventID: Longint;
      Pidl1: PItemIDList;
      Pidl2: PItemIDList;
    end;
    TdxFocusAndSelectionInfo = record
      IsRestoring: Boolean;
      FocusedPidl: PItemIDList;
      SelectedPidls: TList;
    end;
    TdxScrollPositionInfo = record
      IsValid: Boolean;
      Left: Integer;
      Top: Integer;
    end;
  {$ENDREGION}
  strict private
    FAppEvents: TApplicationEvents;
    FCutItemsPIDLList: TList;
    FDefferedShellSystemEvents: TList<TdxShellSystemEventInfo>;
    FEventProcessingCount: Integer;
    FFocusAndSelectionInfo: TdxFocusAndSelectionInfo;
    FNavigateFolderLinks: Boolean;
    FNeedUpdateImages: Boolean;
    FNoItemsMatchStr: string;
    FFakeThumbnailImages: TCustomImageList;
    FFirstUpdateItem: Integer;
    FInternalSmallImages: TdxShellSmallImageList;
    FIsContextPopupProcessing: Boolean;
    FIsFinishEditing: Boolean;
    FIsThumbnailView: Boolean;
    FItemProducer: TdxShellListViewItemProducer;
    FItemsInfoGatherer: TcxShellItemsInfoGatherer;
    FIsCalculating: Boolean;
    FLargeIconSize: TcxShellIconSize;
    FLargeImages: TCustomImageList;
    FLastUpdateItem: Integer;
    FLoadedGroupIndex: Integer;
    FSavedScrollPos: TdxScrollPositionInfo;
    FSelectedFiles: TStringList;
    FShellDependedControls: TcxShellDependedControls;
    FShellChangeNotifierData: TcxShellChangeNotifierData;
    FShellOptions: TdxShellListViewOptions;
    FShellRoot: TdxShellListViewRoot;
    FSorting: Boolean;
    FThumbnailOptions: TcxShellThumbnailOptions;
    FThumbnailOverlayImageHelper: TObject;
    FWorkingOnItStr: string;
    // drag&drop
    FAllowDragDrop: Boolean;
    FAutoScrollHelper: TdxAutoScrollHelper;
    FCurrentDropTarget: IDropTarget;
    FDraggedObject: IDataObject;
    FDragKeyState: Integer;
    FDropTargetHelper: IDropTargetHelper;
    FDropTargetItemIndex: Integer;
    FDropTargetRealItemIndex: Integer;
    FGroupIndex: Integer;
    FIsDragging: Boolean;
    FPrevDragOverPoint: TPoint;
    FShellDragDropState: TcxDragAndDropState;
    //
    FOnAfterNavigation: TdxNavigationEvent;
    FOnBeforeNavigation: TdxNavigationEvent;
    FOnAddFolder: TcxShellAddFolderEvent;
    FOnCompare: TcxShellCompareEvent;
    FOnCurrentFolderChanged: TNotifyEvent;
    FOnExecuteItem: TcxShellExecuteItemEvent;
    FOnItemsPopulated: TNotifyEvent;
    FOnShellChange: TcxShellChangeEvent;
    FOnSortColumnChanged: TNotifyEvent;
    FOnSortCompleted: TNotifyEvent;
    FOnViewChanged: TNotifyEvent;
    // DefferedShellSystemEvents
    procedure AddDefferedShellSystemEvent(AEventID: Longint; APidl1, APidl2: PItemIDList);
    procedure ClearDefferedShellSystemEvents;
    procedure ProcessDefferedShellSystemEvents;
    //
    procedure CreateDropTarget;
    procedure DoBeginDrag;
    procedure DoHandleDependedInitialization;
    function CutItemsPIDLListContains(APIDL: PItemIDList): Boolean;
    procedure DoProcessSystemShellChange(AEventID: Longint; APidl1, APidl2: PItemIDList);
    function GetAbsolutePIDL: PItemIDList;
    function GetController: TdxShellListViewController;
    function GetFolder(AIndex: Integer): TcxShellFolder;
    function GetFolderCount: Integer;
    function GetLargeImageListType: Integer;
    function GetPath: string;
    function GetSelectedFilePaths: TStrings;
    function GetShellRoot: TdxShellListViewRoot;
    procedure InitializeLocalizableSources;
    procedure InvokeFolderContextMenuCommand(ACommandName: PAnsiChar);
    procedure ResetSorting;
    procedure RootFolderChanged(Sender: TObject; Root: TcxCustomShellRoot);
    procedure RootSettingsChanged(Sender: TObject);
    procedure SetAbsolutePIDL(AValue: PItemIDList);
    procedure SetGroupIndex(AValue: Integer);
    procedure SetLargeIconSize(const AValue: TcxShellIconSize);
    procedure SetPath(AValue: string);
    procedure SetShellRoot(AValue: TdxShellListViewRoot);
    procedure SetSorting(const AValue: Boolean);
    function TryReleaseDropTarget: HResult;
    procedure UpdateColumnSortOrder(AIndex: Integer);
    procedure UpdateColumnsSortOrder;
    procedure UpdateDropTarget(grfKeyState: Integer; const APoint: TPoint; var dwEffect: Integer; out ANew: Boolean);
    //
    procedure DsmDoNavigate(var Message: TMessage); message DSM_DONAVIGATE;
    procedure DSMSynchronizeRoot(var Message: TMessage); message DSM_SYNCHRONIZEROOT;
    procedure DSMSystemShellChangeNotify(var Message: TMessage); message DSM_SYSTEMSHELLCHANGENOTIFY;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  private
    FIsInternalNewItemCreation: Boolean;
    FStoredEditingItemPidl: PItemIDList;
    procedure AddDefferedUpdateContent;
    function CanSort: Boolean;
    procedure ClearFocusAndSelection;
    procedure ClearScrollPosition;
    procedure DoSetItemCount(ACount: Integer);
    function GetViewStyleIcon: TdxShellListViewIconOptions;
    procedure ItemsPopulated;
    procedure RestoreEditingItem;
    procedure RestoreFocusAndSelection;
    procedure RestoreScrollPosition;
    procedure SetViewStyleIcon(AValue: TdxShellListViewIconOptions);
    procedure SortCompleted;
    procedure StoreEditingItem;
    procedure StoreFocusAndSelection;
    procedure StoreScrollPosition;
    procedure SetDropTargetItemIndex(AValue: Integer);
    procedure UpdateEmptyText;
    property DropTargetItemIndex: Integer read FDropTargetItemIndex write SetDropTargetItemIndex;
  protected
    procedure AssignFromCxShellListView(ASource: TcxShellListView);
    function CanEdit(AItem: TdxListItem): Boolean; override;
    function CreateController: TdxListViewController; override;
    function CreateHintHelper: TdxListViewHintHelper; override;
    function CreateIconOptions: TdxListViewIconOptions; override;
    function CreateReportOptions: TdxListViewReportOptions; override;
    function CreateViewInfo: TdxListViewViewInfo; override;
    procedure DblClick; override;
    procedure DestroyWnd; override;
    procedure DoChangeScaleEx(M, D: Integer; isDpiChange: Boolean); override;
    procedure DoColumnClick(AColumn: TdxListColumn); override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure DoEdited(AItem: TdxListItem; var ACaption: string); override;
    procedure DoMakeVisible(P: TPoint; AAnimated: Boolean = False); override;
    procedure DoSelectionChanged; override;
    procedure FinishItemCaptionEditing(AAccept: Boolean = True); override;
    procedure InitControl; override;
    function InternalMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    function IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function OwnerDataFetch(AItem: TdxListItem; ARequest: TdxListItemRequest): Boolean; override;
    function OwnerDataFind(AFind: TdxListItemFind; const AFindString: string; const AFindPosition: TPoint; AFindData: Pointer;
      AStartIndex: Integer; ADirection: TdxListItemSearchDirection; AWrap: Boolean): Integer; override;
    function OwnerDataHint(AStartIndex, AEndIndex: Integer): Boolean; override;
    procedure ProcessDragAndDropOnMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ProcessDragAndDropOnMouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure ShowInplaceEdit(AItemIndex: Integer; ABounds: TRect; const AText: string); override;
    function SupportsItemEnabledState: Boolean; override;
    function UseDisplayedItemsForBestFit: Boolean; override;
    procedure ValidatePasteText(var AText: string); override;
    //
    procedure Calculate(AType: TdxChangeType); override;
    procedure ChangeView(AViewId: Integer);
    function CheckFileMask(AFolder: TcxShellFolder): Boolean;
    procedure CheckLargeImages;
    procedure CheckUpdateItems;
    procedure ClearCutItems(const AUpdateContent: Boolean = True);
    procedure CreateChangeNotification;
    procedure CreateNewFolder;
    function CreateSelectedPidlsList: TList;
    procedure CutSelectedItems;
    procedure DestroySelectedPidlsList(var ASelectedPidls: TList);
    procedure DisplayContextMenu(const APos: TPoint);
    function DoAddFolder(AFolder: TcxShellFolder): Boolean;
    procedure DoAfterNavigation;
    procedure DoBeforeNavigation(APIDL: PItemIDList);
    function DoCompare(AItem1, AItem2: TcxShellFolder; out ACompare: Integer): Boolean; virtual;
    procedure DoCreateColumns; virtual;
    procedure DoInfoTip(AItem: TdxListItem; var AInfoTip: string); override;
    procedure DoItemDblClick(AItemIndex: Integer);
    procedure DoOnIdle(Sender: TObject; var Done: Boolean);
    procedure DoProcessDefaultCommand(AShellItem: TcxShellItemInfo); virtual;
    procedure DoProcessNavigation(AShellItem: TcxShellItemInfo);
    procedure DoSortColumnChanged;
    procedure DoViewChanged;
    function GetColumnClass: TdxListColumnClass; override;
    function GetColumnID(AIndex: Integer): Integer;
    function GetColumnIndexByID(AID: Integer): Integer;
    function GetContextMenuSite: IUnknown; virtual;
    function GetCurrentCursor(X, Y: Integer): TCursor; override;
    function GetDetailItemByColumnIndex(AIndex: Integer): PcxDetailItem;
    function GetCurrentViewId: Integer;
    function GetItemInfo(AIndex: Integer): TcxShellItemInfo;
    function GetLargeIconSize: TSize;
    function GetPidlByItemIndex(AIndex: Integer): PItemIDList;
    function GetSortColumnIndex: Integer;
    function GetThumbnailScaledSize: TSize;
    function GetViewCaption(const AViewId: Integer; AShell32DLLHandle: THandle = 0): string;
    function GetViewOptions(AForNavigation: Boolean = False): TcxShellViewOptions;
    procedure InvalidateImageList;
    function IsThumbnailView: Boolean;
    procedure Navigate(APIDL: PItemIDList); virtual;
    procedure PasteFromClipboard;
    procedure RemoveChangeNotification;
    procedure SelectItemByPidl(APidl: PITemIDList);
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer); override;
    procedure SortColumnChanged; virtual;
    procedure ThumbnailOptionsChanged(Sender: TObject);
    procedure UpdateThumbnails;
    procedure UpdateThumbnailSizeByViewID(AViewId: Integer);
    //
    procedure DSMNotifyUpdateContents(var Message: TMessage); message DSM_NOTIFYUPDATECONTENTS;
    procedure DSMNotifyUpdateItem(var Message: TMessage); message DSM_NOTIFYUPDATE;
    procedure DSMSetCount(var Message: TMessage); message DSM_SETCOUNT;
    // IDropTarget
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function IDropTarget.DragOver = IDropTargetDragOver;
    function IDropTargetDragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    // IcxShellDependedControls
    function GetDependedControls: TcxShellDependedControls;
    // IcxShellRoot
    function GetRoot: TcxCustomShellRoot;

    procedure InplaceEditKeyPress(Sender: TObject; var Key: Char); override;
    procedure UpdateImages;
    //
    property AllowDragDrop: Boolean read FAllowDragDrop write FAllowDragDrop;
    property NavigateFolderLinks: Boolean read FNavigateFolderLinks write FNavigateFolderLinks;
    property FirstUpdateItem: Integer read FFirstUpdateItem write FFirstUpdateItem;
    property ItemProducer: TdxShellListViewItemProducer read FItemProducer;
    property ItemsInfoGatherer: TcxShellItemsInfoGatherer read FItemsInfoGatherer;
    property LargeIconSize: TcxShellIconSize read FLargeIconSize write SetLargeIconSize;
    property LargeImages: TCustomImageList read FLargeImages;
    property LastUpdateItem: Integer read FLastUpdateItem write FLastUpdateItem;
    //
    property ThumbnailOverlayImageHelper: TObject read FThumbnailOverlayImageHelper;
    property OnAfterNavigation: TdxNavigationEvent read FOnAfterNavigation write FOnAfterNavigation;
    property OnItemsPopulated: TNotifyEvent read FOnItemsPopulated write FOnItemsPopulated;
    property OnCompare: TcxShellCompareEvent read FOnCompare write FOnCompare;
    property OnCurrentFolderChanged: TNotifyEvent read FOnCurrentFolderChanged write FOnCurrentFolderChanged;
    property OnShellChange: TcxShellChangeEvent read FOnShellChange write FOnShellChange;
    property OnSortColumnChanged: TNotifyEvent read FOnSortColumnChanged write FOnSortColumnChanged;
    property OnSortCompleted: TNotifyEvent read FOnSortCompleted write FOnSortCompleted;
    property OnViewChanged: TNotifyEvent read FOnViewChanged write FOnViewChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // IdxLocalizerListener
    procedure TranslationChanged; override;
    //
    procedure BrowseParent;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetItemAbsolutePIDL(AIndex: Integer): PItemIDList;
    procedure Sort; overload;
    procedure Sort(AColumnIndex: Integer; AIsAscending: Boolean); overload;
    procedure UpdateContent;
    //
    property AbsolutePIDL: PItemIDList read GetAbsolutePIDL write SetAbsolutePIDL;
    property Controller: TdxShellListViewController read GetController; // for internal use
    property FolderCount: Integer read GetFolderCount;
    property Folders[AIndex: Integer]: TcxShellFolder read GetFolder;
    property Path: string read GetPath write SetPath;
    property SelectedFilePaths: TStrings read GetSelectedFilePaths;
    property Sorting: Boolean read FSorting write SetSorting default False;
    property ShellOptions: TdxShellListViewOptions read FShellOptions write FShellOptions;
    property ShellRoot: TdxShellListViewRoot read GetShellRoot write SetShellRoot;
    property ThumbnailOptions: TcxShellThumbnailOptions read FThumbnailOptions write FThumbnailOptions;
    //
    property OnBeforeNavigation: TdxNavigationEvent read FOnBeforeNavigation write FOnBeforeNavigation;
    property OnAddFolder: TcxShellAddFolderEvent read FOnAddFolder write FOnAddFolder;
    property OnExecuteItem: TcxShellExecuteItemEvent read FOnExecuteItem write FOnExecuteItem;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    property OnSelectionChanged;
    property ViewStyle;
    property ViewStyleIcon: TdxShellListViewIconOptions read GetViewStyleIcon write SetViewStyleIcon;
    //
    property OnSelectItem;
  end;

  TdxShellListView = class(TdxCustomShellListView)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Fonts;
    property ParentBiDiMode;
    property ParentFont;
    property PopupMenu;
    property Visible;

    property AllowDragDrop default True;
    property BorderStyle;
    property LookAndFeel;
    property MultiSelect;
    property PaddingOptions;
    property ParentShowHint;
    property ReadOnly;
    property Checkboxes;
    property GroupIndex default -1;
    property ShellOptions;
    property ShellRoot;
    property ShowHint;
    property Sorting;
    property TabOrder;
    property TabStop;
    property ThumbnailOptions;
    property Transparent;
    property ViewStyle;
    property ViewStyleIcon;
    property ViewStyleList;
    property ViewStyleReport;
    property ViewStyleSmallIcon;
    //
    property OnAddFolder;
    property OnAfterNavigation;
    property OnBeforeNavigation;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    property OnColumnPosChanged;
    property OnColumnRightClick;
    property OnCompare;
    property OnContextPopup;
    property OnCurrentFolderChanged;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExecuteItem;
    property OnExit;
    property OnInfoTip;
    property OnItemsPopulated;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSelectionChanged;
    property OnSelectItem;
    property OnShellChange;
    property OnSortCompleted;
    property OnStartDock;
    property OnStartDrag;
    property OnViewChanged;
  end;

{$SCOPEDENUMS ON}
  TdxThumbnailAdornmentKind = (NoAdornment, DropShadow, PhotoBorder, VideoSprockets);        // for internal use
  TdxDrawThumbnailProc = reference to procedure (DC: HDC; ABounds: TRect);  // for internal use

  TdxThumbnailAdornmentHelper = class // for internal use
  protected type
    TShadowImage = class(TdxSkinImage);
  strict private
    class var FMap: TDictionary<string, TdxThumbnailAdornmentKind>;
    class var FDropShadowImage: TShadowImage;
    class var FVideoSprocketsImage: TdxPNGImage;
    class procedure CheckInit; static;
    class function LoadThumbnailAdornmentImage(AGroupIconID: Integer): TdxSmartImage; static;
  protected
    class procedure Initialize; static;
    class procedure Finalize; static;
    class procedure DrawWithVideoSprockets(DC: HDC; const ABounds: TRect;
      const ALFPainter: TcxCustomLookAndFeelPainter; const ADrawThumbnailProc: TdxDrawThumbnailProc); static;
    class procedure DrawWithDropShadow(DC: HDC; const ABounds: TRect;
      const ALFPainter: TcxCustomLookAndFeelPainter; const ADrawThumbnailProc: TdxDrawThumbnailProc); static;
  public
    class procedure DrawAdornment(DC: HDC; const ABounds: TRect; AAdornment: TdxThumbnailAdornmentKind;
      const ALFPainter: TcxCustomLookAndFeelPainter; const ADrawThumbnailProc: TdxDrawThumbnailProc); static;
    class function GetAdornmentKind(const AExtension: string): TdxThumbnailAdornmentKind; static;
    class function GetAdornmentMargins(AAdornment: TdxThumbnailAdornmentKind): TRect; static;
  end;
{$SCOPEDENUMS OFF}

implementation

uses
  IOUtils, RTLConsts, dxTypeHelpers, cxEditConsts,
  ComObj, dxGenerics, Clipbrd, dxDPIAwareUtils, dxStringHelper;

const
  dxThisUnitName = 'dxShellControls';

const
  dxShellExtraLargeIconSize: TSize = (cx: 256; cy: 256);
  dxShellLargeIconSize: TSize      = (cx: 96; cy: 96);
  dxShellMediumIconSize: TSize     = (cx: 48; cy: 48);
  //
  CLSID_FrequentPlacesFolder: TGUID = '{3936E9E4-D92C-4EEE-A85A-BC16D5EA0819}';

type
  EdxShellException = class(EdxException);
  EdxCancelSortException = class(EdxShellException);
  PPItemIDList = ^PItemIDList;
  TcxShellRootAccess = class(TcxCustomShellRoot);
  TcxShellItemsInfoGathererAccess = class(TcxShellItemsInfoGatherer);
  TdxListColumnsAccess = class(TdxListColumns);
  TdxTreeViewViewInfoAccess = class(TdxTreeViewViewInfo);
  TcxShellThumbnailOptionsAccess = class(TcxShellThumbnailOptions);

  TdxListItemCustomViewInfoHelper = class helper for TdxListItemCustomViewInfo
  private
    function GetItemIndex: Integer;
  public
    property ItemIndex: Integer read GetItemIndex;
  end;

  TcxBitmap32Helper = class helper for TcxBitmap32
  public
    procedure SmoothResize(ANewWidth, ANewHeight: Integer);
  end;

  { TThumbnailOverlayImageHelper }

  TThumbnailOverlayImageHelper = class
  public type
    TIconInfo = class
    public
      FileName: string;
      IconIndex: Integer;
      Image: TcxCanvasBasedImage;
      constructor Create(const AFileName: string; AIconIndex: Integer);
      destructor Destroy; override;
      procedure UpdateImage(ACanvas: TcxCustomCanvas; AIconSize, ADrawSize: Integer);
    end;
  strict private
    class var FOverlayIconsData: array[1..15] of TIconInfo;
    class var FInitialized: Boolean;
    class var FResourceDLLName: string;
  strict private
    FLastCanvas: TcxCustomCanvas;
    FLastLoadedSize: Integer;
    class procedure CheckReservedOverlayIconInfo; static;
    class function GetOverlayHandlerIconInfo(const AHandlerCLSID: TCLSID; out AIconFileName: string; out AIconIndex: Integer): Boolean; static;
    class function GetNextOverlayIconHandlerName(AKey: HKEY; AIndex: Integer; out AHandlerName: string): Boolean; static;
    class function GetOverlayIconHandlerCLSID(AKey: HKEY; const AName: string; out ACLSID: TCLSID): Boolean; static;
    class function GetResourceDLLName: string; static;
    class procedure PopulateOverlayIconsData; static;
  public
    constructor Create;
    procedure Initialize(ACanvas: TcxCustomCanvas; ASize: Integer);
    procedure Draw(ACanvas: TcxCustomCanvas; const ABounds: TRect; AOverlayIndex: Integer);
    class procedure Finalize; static;
  end;

function dxSHGetIconOverlayIndex(pszIconPath: LPCWSTR; iIconIndex: Integer): Integer; stdcall; external shell32 name 'SHGetIconOverlayIndexW' delayed;

function IsValidShellNameChar(AChar: Char): Boolean;
begin
  Result :=
    (AChar <> '\') and (AChar <> '/') and (AChar <> '"') and
    (AChar <> ':') and (AChar <> '*') and (AChar <> '?') and
    (AChar <> '<') and (AChar <> '>') and (AChar <> '|');
end;

procedure CheckShellItemDisplayName(var AText: string);
var
  I: Integer;
begin
  for I := Length(AText) downto 1 do
   if not IsValidShellNameChar(AText[I]) then
     Delete(AText, I, 1);
end;

{ TdxListItemCustomViewInfoHelper }

function TdxListItemCustomViewInfoHelper.GetItemIndex: Integer;
begin
  Result := inherited ItemIndex;
end;

{ TcxBitmap32Helper }

procedure TcxBitmap32Helper.SmoothResize(ANewWidth, ANewHeight: Integer);
begin
  Resize(ANewWidth, ANewHeight, True, True);
end;

{ TThumbnailOverlayImageHelper.TIconInfo }

constructor TThumbnailOverlayImageHelper.TIconInfo.Create(const AFileName: string; AIconIndex: Integer);
begin
  inherited Create;
  FileName := AFileName;
  IconIndex := AIconIndex;
end;

destructor TThumbnailOverlayImageHelper.TIconInfo.Destroy;
begin
  Image.Free;
  inherited Destroy;
end;

procedure TThumbnailOverlayImageHelper.TIconInfo.UpdateImage(ACanvas: TcxCustomCanvas; AIconSize, ADrawSize: Integer);
const
  LOAD_LIBRARY_AS_IMAGE_RESOURCE = $00000020;
var
  ALibrary: THandle;
  AIcon: HICON;
  AVclIcon: TIcon;
  ABitmap: TcxBitmap32;
begin
  FreeAndNil(Image);
  ALibrary := LoadLibraryEx(PChar(FileName), 0, LOAD_LIBRARY_AS_IMAGE_RESOURCE);
  if ALibrary > 0 then
  begin
    AIcon := LoadImage(ALibrary, MAKEINTRESOURCE(IconIndex), IMAGE_ICON, AIconSize, AIconSize, LR_CREATEDIBSECTION);
    if AIcon <> 0 then
    begin
      AVclIcon := TIcon.Create;
      try
        AVclIcon.Handle := AIcon;
        ABitmap := TcxBitmap32.Create;
        try
          ABitmap.Assign(AVclIcon);
          ABitmap.SmoothResize(ADrawSize, ADrawSize);
          Image := ACanvas.CreateImage(ABitmap, afDefined);
        finally
          ABitmap.Free;
        end;
      finally
        AVclIcon.Free;
      end;
      DestroyIcon(AIcon);
    end;
    FreeLibrary(ALibrary);
  end;
end;

{ TThumbnailOverlayImageHelper }

constructor TThumbnailOverlayImageHelper.Create;
begin
  inherited Create;
  PopulateOverlayIconsData;
end;

class procedure TThumbnailOverlayImageHelper.Finalize;
var
  I: Integer;
begin
  for I := Low(FOverlayIconsData) to High(FOverlayIconsData) do
    FreeAndNil(FOverlayIconsData[I]);
end;

procedure TThumbnailOverlayImageHelper.Draw(ACanvas: TcxCustomCanvas; const ABounds: TRect; AOverlayIndex: Integer);
var
  AIconInfo: TIconInfo;
  AImage: TcxCanvasBasedImage;
  ADrawBounds: TRect;
begin
  Inc(AOverlayIndex);
  if InRange(AOverlayIndex, 1, 15) then
  begin
    AIconInfo := FOverlayIconsData[AOverlayIndex];
    if AIconInfo <> nil then
    begin
      AImage := AIconInfo.Image;
      if AImage <> nil then
      begin
        ADrawBounds.Init(ABounds.Left, ABounds.Bottom - AImage.Height, ABounds.Left + AImage.Width, ABounds.Bottom);
        AIconInfo.Image.Draw(ADrawBounds);
      end;
    end;
  end;
end;

procedure TThumbnailOverlayImageHelper.Initialize(ACanvas: TcxCustomCanvas; ASize: Integer);
var
  I, AIconSize, ADrawSize: Integer;
begin
  if (ASize <> FLastLoadedSize) or (FLastCanvas <> ACanvas) then
  begin
    FLastLoadedSize := ASize;
    FLastCanvas := ACanvas;
    if ASize > 96 then
    begin
      AIconSize := 256;
      ADrawSize := MulDiv(ASize, 3, 8)
    end
    else if ASize > 48 then
    begin
      AIconSize := 96;
      ADrawSize := ASize div 2;
    end
    else
    begin
      AIconSize := 48;
      ADrawSize := MulDiv(ASize, 2, 3);
    end;
    for I := Low(FOverlayIconsData) to High(FOverlayIconsData) do
    begin
      if FOverlayIconsData[I] <> nil then
        FOverlayIconsData[I].UpdateImage(ACanvas, AIconSize, ADrawSize);
    end;
  end;
end;

class function TThumbnailOverlayImageHelper.GetNextOverlayIconHandlerName(AKey: HKEY; AIndex: Integer; out AHandlerName: string): Boolean;
var
  AStatus, ASize: DWORD;
begin
  Result := False;
  ASize  := 256;
  while True do
  begin
    SetLength(AHandlerName, ASize - 1);
    AStatus := RegEnumKeyEx(AKey, AIndex, PChar(AHandlerName), ASize, nil, nil, nil, nil);
    case AStatus of
      ERROR_SUCCESS:
        begin
          SetLength(AHandlerName, ASize);
          Exit(True);
        end;
      ERROR_NO_MORE_ITEMS:
        begin
          AHandlerName := '';
          Exit(True);
        end;
      ERROR_MORE_DATA:
        Inc(ASize, ASize);
    else
      Exit;
    end;
  end;
end;

class function TThumbnailOverlayImageHelper.GetOverlayIconHandlerCLSID(AKey: HKEY; const AName: string; out ACLSID: TCLSID): Boolean;
var
  ABuffer: string;
  AStatus, ABufferLength, ASize: DWORD;
  ASubKey: HKEY;
begin
  Result := False;
  if RegOpenKeyEx(AKey, PChar(AName), 0, KEY_READ, ASubKey) = ERROR_SUCCESS then
  try
    ABufferLength := 256;
    while True do
    begin
      SetLength(ABuffer, ABufferLength);
      ASize := ABufferLength * SizeOf(Char);
      AStatus := RegQueryValueExW(ASubKey, nil, nil, nil, @ABuffer[1], @ASize);
      case AStatus of
        ERROR_SUCCESS:
          begin
            SetLength(ABuffer, (ASize div SizeOf(Char)) - 1);
            ACLSID := StringToGUID(ABuffer);
            Exit(True);
          end;
        ERROR_MORE_DATA:
          ABufferLength := (ASize div SizeOf(Char));
      else
        Exit;
      end;
    end;
  finally
    RegCloseKey(ASubKey);
  end;
end;

class function TThumbnailOverlayImageHelper.GetOverlayHandlerIconInfo(const AHandlerCLSID: TCLSID; out AIconFileName: string; out AIconIndex: Integer): Boolean;
var
  AFlags: DWORD;
  AUnknownIntf: IUnknown;
  AShellIconOverlayIdentifier: IShellIconOverlayIdentifier;
begin
  Result := False;
  if Succeeded(CoCreateInstance(AHandlerCLSID, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IUnknown, AUnknownIntf)) then
  try
    if Succeeded(AUnknownIntf.QueryInterface(IID_IShellIconOverlayIdentifier, AShellIconOverlayIdentifier)) then
    try
      SetLength(AIconFileName, MAX_PATH);
      AIconFileName[1] := #0;
      AFlags := 0;
      AIconIndex := 0;
      if Succeeded(AShellIconOverlayIdentifier.GetOverlayInfo(PChar(AIconFileName), Length(AIconFileName), AIconIndex, AFlags)) then
      begin
        AIconFileName := PChar(AIconFileName);
        if AFlags and ISIOI_ICONFILE <> 0 then
        begin
          if AFlags and ISIOI_ICONINDEX = 0 then
            AIconIndex := 0;
        end
        else
        begin
          AIconFileName := '';
          AIconIndex := 0;
        end;
        Exit(True);
      end;
    finally
      AShellIconOverlayIdentifier := nil;
    end;
  finally
    AUnknownIntf := nil;
  end;
end;

class procedure TThumbnailOverlayImageHelper.CheckReservedOverlayIconInfo;
const
  IconIndices: array[Boolean, 1..4] of Integer = (
    (   29,   30,      0,    31),
    (  164,  163,    157,    169)); 
var
  AOverlayIconIndex, AIconIndex: Integer;
begin
  for AOverlayIconIndex := 1 to 4 do
    if FOverlayIconsData[AOverlayIconIndex] = nil then
    begin
      AIconIndex := IconIndices[IsWinVistaOrLater, AOverlayIconIndex];
      if AIconIndex <> 0 then
        FOverlayIconsData[AOverlayIconIndex] := TIconInfo.Create(FResourceDLLName, AIconIndex);
    end;
end;

class function TThumbnailOverlayImageHelper.GetResourceDLLName: string;
const
  ResourceDLLNames: array[Boolean] of string = ('shell32.dll', 'imageres.dll');
begin
  SetLength(Result, MAX_PATH);
  OleCheck(SHGetFolderPath(0, CSIDL_SYSTEM, 0, SHGFP_TYPE_CURRENT, PChar(Result)));
  Result := PChar(Result) + '\' + ResourceDLLNames[IsWinVistaOrLater];
end;

class procedure TThumbnailOverlayImageHelper.PopulateOverlayIconsData;
const
  ShellIconOverlayIdentifiersKeyName: array[Boolean] of string = (
    'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers',
    'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers');
var
  AIndex, AOverlayIconIndex, AIconIndex: Integer;
  AKey: HKEY;
  AHandlerName, AIconFileName: string;
  ACLSID: TCLSID;
begin
  if FInitialized then
    Exit;
  FResourceDLLName := GetResourceDLLName;
  AIconIndex := 0;
  if RegOpenKeyExW(HKEY_LOCAL_MACHINE, PChar(ShellIconOverlayIdentifiersKeyName[
  {$IFDEF CPUX64}
    False
  {$ELSE}
    IsWin64Bit
  {$ENDIF CPUX64}
    ]), 0, KEY_READ, AKey) = ERROR_SUCCESS then
  try
    AIndex := 0;
    while GetNextOverlayIconHandlerName(AKey, AIndex, AHandlerName) and (AHandlerName <> '') do
    begin
      if GetOverlayIconHandlerCLSID(AKey, AHandlerName, ACLSID) then
      begin
        if GetOverlayHandlerIconInfo(ACLSID, AIconFileName, AIconIndex) then
        begin
          AOverlayIconIndex := dxSHGetIconOverlayIndex(PChar(AIconFileName), AIconIndex);
          if InRange(AOverlayIconIndex, Low(FOverlayIconsData), High(FOverlayIconsData)) then
          begin
            if FOverlayIconsData[AOverlayIconIndex] = nil then
              FOverlayIconsData[AOverlayIconIndex] := TIconInfo.Create(AIconFileName, AOverlayIconIndex);
          end;
        end;
      end;
      Inc(AIndex);
    end;
  finally
    RegCloseKey(AKey);
  end;
  CheckReservedOverlayIconInfo;
  FInitialized := True;
end;

{ TdxShellTreeViewItemProducer }

constructor TdxShellTreeViewItemProducer.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  TreeView.AddItemProducer(Self);
end;

destructor TdxShellTreeViewItemProducer.Destroy;
begin
  TreeView.RemoveItemProducer(Self);
  inherited Destroy;
end;

procedure TdxShellTreeViewItemProducer.NotifyAddItem(Index: Integer);
begin
  if Node <> nil then
    Owner.Perform(DSM_NOTIFYADDITEM, Index, LPARAM(Node));
end;

procedure TdxShellTreeViewItemProducer.NotifyRemoveItem(Index: Integer);
begin
  if Node <> nil then
    Owner.Perform(DSM_NOTIFYREMOVEITEM, Index, LPARAM(Node));
end;

procedure TdxShellTreeViewItemProducer.ProcessItems(AIFolder: IShellFolder; APIDL: PItemIDList; ANode: TdxTreeViewNode;
  APreloadItemCount: Integer);
var
  AFileInfo: TShFileInfo;
begin
  Node := ANode;
  if TreeView.IsShellOrFavoritesRootNode(ANode) then
  begin
    cxShellGetThreadSafeFileInfo(PChar(APIDL), 0, AFileInfo, SizeOf(AFileInfo),
      SHGFI_PIDL or SHGFI_DISPLAYNAME or SHGFI_SYSICONINDEX);
    Node.Caption := AFileInfo.szDisplayName;
    Node.ImageIndex := AFileInfo.iIcon;
  end;
  ProcessItems(AIFolder, APIDL, APreloadItemCount);
end;

procedure TdxShellTreeViewItemProducer.SetItemsCount(Count: Integer);
begin
  if Node <> nil then
    Owner.Perform(DSM_SETCOUNT, Count, LPARAM(Node))
end;

function TdxShellTreeViewItemProducer.CanAddFolder(AFolder: TcxShellFolder): Boolean;
begin
  if IsFavorites then
  begin
    Result := True;
    TreeView.DoOnAddFolder(AFolder, Result);
  end
  else
    Result := TreeView.DoAddFolder(AFolder);
end;

function TdxShellTreeViewItemProducer.CanCancelTask: Boolean;
begin
  Result := True;
end;

function TdxShellTreeViewItemProducer.CreateFakeProducer: TdxCustomShellTreeItemProducer;
begin
  Result := TdxShellTreeViewItemProducer.Create(TreeView);
end;

function TdxShellTreeViewItemProducer.CreateTask(AItem: TcxShellItemInfo): TdxShellItemTask;
begin
  Result := TdxShellTreeViewItemTask.Create(AItem);
end;

function TdxShellTreeViewItemProducer.GetEnumFlags: Cardinal;
var
  APidl: PItemIDList;
begin
  Result := TreeView.ShellOptions.GetEnumFlags;
  if TreeView.ShellOptions.TrackShellChanges and (ShellItemInfo <> nil) and
    Succeeded(cxGetFolderLocation(0, CSIDL_NETWORK, 0, 0, APidl)) then
  begin
    if IsSubPath(ShellItemInfo.pidl, APidl) then
      Result := Result or SHCONTF_ENABLE_ASYNC;
    DisposePidl(APidl);
  end;
end;

function TdxShellTreeViewItemProducer.GetItemsInfoGatherer: TcxShellItemsInfoGatherer;
begin
  Result := TreeView.ItemsInfoGatherer;
end;

function TdxShellTreeViewItemProducer.GetShowToolTip: Boolean;
begin
  Result := TreeView.ShellOptions.ShowToolTip;
end;

function TdxShellTreeViewItemProducer.GetTreeView: TdxCustomShellTreeView;
begin
  Result := TdxCustomShellTreeView(Owner);
end;

procedure TdxShellTreeViewItemProducer.ItemImageUpdated(AItem: TcxShellItemInfo);
begin
  if (AItem.IconIndex > TreeView.Images.Count - 1) or (AItem.OpenIconIndex > TreeView.Images.Count - 1) then
    TreeView.UpdateImages;
end;

{ TdxShellTreeViewContextMenu }

constructor TdxShellTreeViewContextMenu.Create(ATreeView: TdxCustomShellTreeView; ANode: TdxTreeViewNode);
begin
  inherited Create;
  FTreeView := ATreeView;
  FNode := ANode;
end;

procedure TdxShellTreeViewContextMenu.ItemProducerDestroyHandler(Sender: TObject);
begin
  UnassignProducer;
end;

procedure TdxShellTreeViewContextMenu.ExecuteMenuItemCommand(ACommandId: Cardinal);
begin
  if (ACommandId = 218) and IsSameCommand(ACommandId, 'rename'#0) then
    FTreeView.Selected.EditCaption
  else
  begin
    inherited ExecuteMenuItemCommand(ACommandId);
    if (ACommandId = 224) and IsSameCommand(ACommandId, 'cut'#0) then
      FTreeView.CutNode(FTreeView.Selected)
    else
      if (ACommandId = 226) and IsSameCommand(ACommandId, 'paste'#0) then
      begin
        FTreeView.CutNode(nil);
        if not FTreeView.ShellOptions.TrackShellChanges then
          FTreeView.UpdateContent;
      end
      else
        if not FTreeView.ShellOptions.TrackShellChanges and
          IsSameCommand(ACommandId, 'delete'#0) then
          FTreeView.UpdateContent;
  end;
end;

function TdxShellTreeViewContextMenu.GetContextMenuQueryFlags: Cardinal;
begin
  Result := inherited GetContextMenuQueryFlags;
  if FTreeView.SelectionCount = 1 then
    Result := Result or CMF_CANRENAME;
end;

function TdxShellTreeViewContextMenu.GetSite: IUnknown;
begin
  Result := TreeView.GetContextMenuSite;
end;

function TdxShellTreeViewContextMenu.GetWindowHandle: THandle;
begin
  Result := FTreeView.Handle;
end;

procedure TdxShellTreeViewContextMenu.Populate;
var
  AItemPIDLList: TList;
begin
  AssignProducer;
  try
    if FNode = TreeView.FavoritesRootNode then
      AddDefaultShellItems(FTreeView.GetItemProducer(FNode).ShellFolder)
    else
    begin
      AItemPIDLList := TList.Create;
      try
        if TreeView.IsShellOrFavoritesRootNode(FNode) then
          AItemPIDLList.Add(FTreeView.GetNodeAbsolutePIDL(FNode))
        else
          AItemPIDLList.Add(GetPidlCopy(FTreeView.GetShellItemInfo(FNode).pidl));
        AddDefaultShellItems(FItemProducer.ShellFolder, AItemPIDLList);
      finally
        DisposePidl(AItemPIDLList[0]);
        AItemPIDLList.Free;
      end;
    end;
  finally
    UnassignProducer;
  end;
end;

procedure TdxShellTreeViewContextMenu.AssignProducer;
begin
  if TreeView.IsShellOrFavoritesRootNode(FNode) then
    FItemProducer := FTreeView.GetItemProducer(FTreeView.ShellRootNode)
  else
    FItemProducer := FTreeView.GetItemProducer(FNode.Parent);
  FItemProducer.OnDestroy := ItemProducerDestroyHandler;
  FItemProducer.LockRead;
end;

procedure TdxShellTreeViewContextMenu.UnassignProducer;
begin
  if FItemProducer <> nil then
  begin
    FItemProducer.UnlockRead;
    FItemProducer.OnDestroy := nil;
    FItemProducer := nil;
  end;
end;

{ TdxShellTreeViewOptions }

function TdxShellTreeViewOptions.GetDefaultShowToolTipValue: Boolean;
begin
  Result := False;
end;

procedure TdxShellTreeViewOptions.DoNotifyUpdateContents;
begin
  (Owner as TdxCustomShellTreeView).UpdateContent;
end;

function TdxShellTreeViewOptions.IsDefaultShowNonFolders: Boolean;
begin
  Result := DefaultShowNonFoldersValue;
end;

{ TdxShellTreeViewNode }

procedure TdxShellTreeViewNode.DeleteChildren;
begin
  if IsRoot then
    (TreeView as TdxCustomShellTreeView).ItemsInfoGatherer.ClearFetchQueue(nil);
  inherited DeleteChildren;
end;

procedure TdxShellTreeViewPainter.DrawNodeCaption(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);
const
  QuickAccessPinColor: TdxAlphaColor = $FFA6A095;
var
  ARect: TRect;
  ANode: TdxTreeViewNode;
begin
  inherited;
  ANode := ANodeViewInfo.Node;
  if TdxCustomShellTreeView(TreeView).IsQuickAccessItemNode(ANode) and
    TdxCustomShellTreeView(TreeView).GetShellItemInfo(ANode).IsPinned then
  begin
    ARect := ANodeViewInfo.Bounds;
    if TreeView.UseRightToLeftAlignment then
    begin
      ARect.Left := ARect.Left + ANodeViewInfo.ScaleFactor.Apply(cxTextOffset) - ANodeViewInfo.LevelOffset;
      ARect.Right := ARect.Left + ANodeViewInfo.ScaleFactor.Apply(14);
    end
    else
    begin
      ARect.Right := ARect.Right - ANodeViewInfo.ScaleFactor.Apply(cxTextOffset) - ANodeViewInfo.LevelOffset;
      ARect.Left := ARect.Right - ANodeViewInfo.ScaleFactor.Apply(14);
    end;
    LookAndFeelPainter.DrawShellQuickAccessPin(ACanvas, ARect, ifmNormal,
      TdxSimpleColorPalette.Create(QuickAccessPinColor, TdxAlphaColors.Empty));
  end;
end;

{ TdxShellTreeViewPainter }

procedure TdxShellTreeViewPainter.DrawNodeImage(ACanvas: TcxCanvas; const R: TRect; ANodeViewInfo: TdxTreeViewNodeViewInfo);

  function IndexToOverlayMask(Index: Integer): Integer;
  begin
    Result := Index shl 8;
  end;

  function GetDrawingStyle(AStyle: TDrawingStyle): Integer;
  const
    DrawingStyles: array[TDrawingStyle] of Longint = (ILD_FOCUS, ILD_SELECTED, ILD_NORMAL, ILD_TRANSPARENT);
  begin
    Result := DrawingStyles[AStyle];
    if ANodeViewInfo.Node.Cut then
      Result := Result or ILD_BLEND50;
    if ANodeViewInfo.Node.OverlayImageIndex >= 0 then
      Result := Result or ILD_OVERLAYMASK and IndexToOverlayMask(ANodeViewInfo.Node.OverlayImageIndex + 1);
  end;

  procedure DoDrawImage(DC: HDC; X, Y: Integer);
  begin
    ImageList_DrawEx(ANodeViewInfo.Images.Handle, ANodeViewInfo.GetImageIndex,
      DC, X, Y, 0, 0, CLR_NONE, CLR_NONE, GetDrawingStyle(TDrawingStyle.dsNormal));
  end;

var
  ABuffer: TcxBitmap32;
begin
  if IsWinSevenOrLater then
  begin
    if (ANodeViewInfo.Images.Width <> R.Width) or (ANodeViewInfo.Images.Height <> R.Height) then
    begin
      ABuffer := TcxBitmap32.CreateSize(ANodeViewInfo.Images.Width, ANodeViewInfo.Images.Height, True);
      try
        DoDrawImage(ABuffer.Canvas.Handle, 0, 0);
        TdxImageDrawer.DrawImage(ACanvas, R, ABuffer, nil, -1, ifmFit, idmNormal, False, nil, ANodeViewInfo.ScaleFactor);
      finally
        ABuffer.Free;
      end;
    end
    else
      DoDrawImage(ACanvas.Handle, R.Left, R.Top);
  end
  else
    inherited DrawNodeImage(ACanvas, R, ANodeViewInfo);
end;

{ TdxShellTreeViewControlOptionsBehavior }

constructor TdxShellTreeViewControlOptionsBehavior.Create(ATreeView: TdxCustomTreeView);
begin
  inherited Create(ATreeView);
  FAllowDragDrop := True;
  CaptionEditing := True;
end;

procedure TdxShellTreeViewControlOptionsBehavior.Assign(Source: TPersistent);
var
  ASource: TdxShellTreeViewControlOptionsBehavior;
begin
  inherited Assign(Source);
  if Safe.Cast(Source, TdxShellTreeViewControlOptionsBehavior, ASource) then
  begin
    AllowDragDrop := ASource.AllowDragDrop;
  end;
end;

{ TdxShellTreeViewControlOptionsSelection }

function TdxShellTreeViewControlOptionsSelection.DefaultHideSelectionValue: Boolean;
begin
  Result := True;
end;

{ TdxCustomShellTreeView }

constructor TdxCustomShellTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShellDependedControls := TcxShellDependedControls.Create;
  FGroupIndex := -1;
  FLoadedGroupIndex := -1;
  FFirstLevelNodesVisible := True;
  FItemsInfoGatherer := TcxShellItemsInfoGatherer.Create(Self);
  FShellRoot := TdxShellTreeViewRoot.Create(Self, 0);
  FShellRoot.OnFolderChanged := RootFolderChanged;
  FShellRoot.OnSettingsChanged := RootSettingsChanged;
  FShellOptions := TdxShellTreeViewOptions.Create(Self);
  FItemProducersList := TThreadList.Create;
  FInternalSmallImages := TdxShellSmallImageList.Create(Self);
  Images := FInternalSmallImages;
  DoubleBuffered := True;
  FAppEvents := TApplicationEvents.Create(nil);
  FAppEvents.OnIdle := DoOnIdle;
  FDefferedShellSystemEvents := TList<TdxShellSystemEventInfo>.Create;
  FCutItemPIDL := nil;
end;

destructor TdxCustomShellTreeView.Destroy;
begin
  TdxUIThreadSyncService.Unsubscribe(Self);
  DragLeave; // #Ch needed to avoid freezing for external drag source (e.g. esc on Dialog while dragging from WinExplorer)
  DisposePidl(FCutItemPIDL);
  FreeAndNil(FDefferedShellSystemEvents);
  FreeAndNil(FAppEvents);
  RemoveChangeNotification;
  dxTestCheck(Root.Count = 0, 'Root.Count <> 0');
  FreeAndNil(FInternalSmallImages);
  FreeAndNil(FItemProducersList);
  FreeAndNil(FShellOptions);
  FreeAndNil(FShellRoot);
  FreeAndNil(FItemsInfoGatherer);
  FreeAndNil(FShellDependedControls);
  inherited Destroy;
end;

function TdxCustomShellTreeView.GetNodeAbsolutePIDL(ANode: TdxTreeViewNode): PItemIDList;
var
  AItemProducer: TdxShellTreeViewItemProducer;
  AItem: TcxShellItemInfo;
begin
  AItemProducer := GetItemProducer(ANode);
  if AItemProducer = nil then
    Result := nil
  else
  begin
    AItem := AItemProducer.ShellItemInfo;
    if AItem <> nil then
      Result := AItem.RealItemPidl
    else
      Result := GetPidlCopy(AItemProducer.FolderPidl);
  end;
end;

procedure TdxCustomShellTreeView.UpdateContent;
begin
  if (FEventProcessingCount > 0) or FIsContextPopupProcessing or (FLockChange > 0) or FIsUpdating or (FDragSource <> nil) then
    AddDefferedUpdateContent
  else
    if ShellRoot.ShellFolder = nil then
      CheckShellRoot(ShellRoot)
    else
      ShellChangeNotify(0, ShellRoot.pidl, nil);
end;

function TdxCustomShellTreeView.AllowInfoTips: Boolean;
begin
  Result := ShellOptions.ShowToolTip;
end;

procedure TdxCustomShellTreeView.AssignFromCxShellTreeView(ASource: TcxShellTreeView);
begin
  BeginUpdate;
  try
    OptionsBehavior.AllowDragDrop := ASource.DragDropSettings.AllowDragObjects;
    OptionsBehavior.AutoExpand := ASource.AutoExpand;
    OptionsBehavior.CaptionEditing := not ASource.ReadOnly;
    OptionsBehavior.ChangeDelay := ASource.ChangeDelay;
    OptionsBehavior.HotTrack := ASource.TreeHotTrack;
    OptionsSelection.HideSelection := ASource.HideSelection;
    OptionsSelection.RightClickSelect := ASource.RightClickSelect;
    OptionsView.Indent := ASource.Indent;
    OptionsView.ShowExpandButtons := ASource.ShowButtons;
    OptionsView.ShowLines := ASource.ShowLines;
    OptionsView.ShowRoot := ASource.ShowRoot;
    ShellOptions.Assign(ASource.Options);
    if ASource.ShowInfoTips then
    begin
      ShellOptions.ShowToolTip := True;
      OptionsBehavior.ToolTips := True;
    end
    else
    begin
      ShellOptions.ShowToolTip := False;
      OptionsBehavior.ToolTips := ASource.Options.ShowToolTip;
    end;
    ShellRoot.Assign(ASource.Root);
  finally
    EndUpdate;
  end;
end;

function TdxCustomShellTreeView.CanCollapse(Sender: TdxTreeCustomNode): Boolean;
begin
  Result := inherited CanCollapse(Sender) and (FFirstLevelNodesVisible or not IsShellRootNode(TdxTreeViewNode(Sender)));
end;

function TdxCustomShellTreeView.CanExpand(Sender: TdxTreeCustomNode): Boolean;

  function GetDataForProcessing(out AProcessingFolder: IShellFolder; out AProcessingPidl: PItemIDList): Boolean;
  var
    AItemProducer: TdxShellTreeViewItemProducer;
    AItemInfo: TcxShellItemInfo;
    ANode: TdxTreeViewNode;
  begin
    ANode := Sender as TdxTreeViewNode;
    if not IsShellRootNode(ANode) then
    begin
      AItemProducer := GetItemProducer(ANode.Parent);
      AItemInfo := GetShellItemInfo(ANode);
      ANode.HasChildren := AItemInfo.IsFolder;
      ANode.Cut := AItemInfo.IsGhosted;
      Result := AItemInfo.IsFolder and
        Succeeded(AItemProducer.ShellFolder.BindToObject(AItemInfo.pidl, nil, IID_IShellFolder, AProcessingFolder));
      if Result then
        AProcessingPidl := ConcatenatePidls(AItemProducer.FolderPidl, AItemInfo.pidl);
    end
    else
    begin
      Result := True;
      AProcessingFolder := ShellRoot.ShellFolder;
      AProcessingPidl := GetPidlCopy(ShellRoot.Pidl);
    end;
  end;

  function InternalCanExpand: Boolean;
  var
    ANode: TdxTreeViewNode;
    AProcessingPidl: PItemIDList;
    AProcessingFolder: IShellFolder;
    APreloadItemCount: Integer;
  begin
    Inc(FLockChange);
    try
      Result := GetDataForProcessing(AProcessingFolder, AProcessingPidl);
      if Result then
        try
          ANode := Sender as TdxTreeViewNode;
          APreloadItemCount := ViewInfo.NumberOfNodesInContentRect;
          GetItemProducer(ANode).ProcessItems(AProcessingFolder, AProcessingPidl, ANode, APreloadItemCount);
        finally
          DisposePidl(AProcessingPidl);
        end;
    finally
      Dec(FLockChange);
    end;
    ProcessDefferedShellSystemEvents;
  end;

begin
  Result := not IsQuickAccessItemNode(Sender as TdxTreeViewNode) and not IsFavoritesItemNode(Sender as TdxTreeViewNode) and
   ((Sender.First <> nil) or (Sender = QuickAccessRootNode) or InternalCanExpand) and inherited CanExpand(Sender);
end;

procedure TdxCustomShellTreeView.DeleteNode(Sender: TdxTreeCustomNode);
var
  AItemProducer: TdxShellTreeViewItemProducer;
  ANode: TdxTreeViewNode;
begin
  inherited DeleteNode(Sender);
  ANode := Sender as TdxTreeViewNode;
  AItemProducer := GetItemProducer(ANode);
  if AItemProducer <> nil then
  begin
    AItemProducer.Free;
    ANode.Data := nil;
  end;
  if FShellRootNode = Sender then
    FShellRootNode := nil;
  if FQuickAccessRootNode = Sender then
    FQuickAccessRootNode := nil;
  if FFavoritesRootNode = Sender then
    FFavoritesRootNode := nil;
  if FExpandingNode = Sender then
    FExpandingNode := nil;
end;

procedure TdxCustomShellTreeView.DestroyWnd;
begin
  dxTestCheck(Succeeded(RevokeDragDrop(Handle)), 'RevokeDragDrop - dxShellTreeView');
  RemoveChangeNotification;
  inherited DestroyWnd;
end;

procedure TdxCustomShellTreeView.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
var
  ANode: TdxTreeViewNode;
  AContextMenu: TdxShellTreeViewContextMenu;
begin
  if not ShellOptions.ContextMenus or not GetNodeAtPos(MousePos, ANode) or FIsUpdating or (FEventProcessingCount > 0) then
  begin
    inherited DoContextPopup(MousePos, Handled);
    Exit;
  end;
  FIsContextPopupProcessing := True;
  try
    Handled := True;
    AContextMenu := TdxShellTreeViewContextMenu.Create(Self, ANode);
    try
      AContextMenu.Popup(ClientToScreen(MousePos));
    finally
      AContextMenu.Free;
    end;
  finally
    FIsContextPopupProcessing := False;
  end;
  ProcessDefferedShellSystemEvents;
end;

procedure TdxCustomShellTreeView.DoHint(ANode: TdxTreeViewNode; var AText: string);
var
  AItemProducer: TdxShellTreeViewItemProducer;
begin
  if IsShellOrFavoritesRootNode(ANode) then
    AItemProducer := GetItemProducer(ShellRootNode)
  else
    AItemProducer := GetItemProducer(ANode.Parent);
  AItemProducer.GetInfoTip(Handle, ANode.Index, AText);
  inherited DoHint(ANode, AText);
end;

procedure TdxCustomShellTreeView.InitControl;
begin
  if not IsLoading then
  begin
    if ShellRoot.Pidl = nil then
       TcxShellRootAccess(ShellRoot).CheckRoot;
    DoHandleDependedInitialization;
  end;
end;

function TdxCustomShellTreeView.IsExplorerStyle: Boolean;
begin
  Result := True;
end;

function TdxCustomShellTreeView.IsFavoritesVisible: Boolean;
begin
  Result := False;
end;

procedure TdxCustomShellTreeView.KeyDown(var Key: Word; Shift: TShiftState);

  procedure InvokeContextMenuCommand(const ACommandStr: AnsiString);
  var
    AShellFolder : IShellFolder;
    AItemPIDLList: TList;
    AItem: TcxShellItemInfo;
    AParentItemProducer: TdxShellTreeViewItemProducer;
  begin
    if (FocusedNode <> nil) and not IsShellRootNode(FocusedNode) then
    begin
      AItemPIDLList := TList.Create;
      try
        AParentItemProducer := GetItemProducer(FocusedNode.Parent);
        AShellFolder := AParentItemProducer.ShellFolder;
        AItem := AParentItemProducer.ItemInfo[FocusedNode.Index];
        AItemPIDLList.Add(GetPidlCopy(AItem.pidl));
        cxShellInvokeContextMenuCommand(AShellFolder, AItemPIDLList, ACommandStr, Handle);
      finally
        if AItemPIDLList.Count > 0 then
          DisposePidl(AItemPIDLList[0]);
        AItemPIDLList.Free;
      end;
    end;
  end;

begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_F5:
      UpdateContent;
    VK_RETURN, VK_SPACE:
      DoPathChanged
  else
    if ShellOptions.ContextMenus and
      (cxShellIsClipboardCommandContextMenuShortCut(Key, Shift) or (Key = VK_DELETE) and (FocusedNode <> nil)) then
    begin
      InvokeContextMenuCommand(cxShellGetContextMenuCommandStrByShortCut(Key, Shift));
      if Key = Ord('X') then
        CutNode(FocusedNode)
      else
        if Key = Ord('V') then
        begin
          CutNode(nil);
          if not ShellOptions.TrackShellChanges then
            UpdateContent;
        end
        else
          if (Key = VK_DELETE) and not ShellOptions.TrackShellChanges then
            UpdateContent;
    end;
  end;
end;

procedure TdxCustomShellTreeView.Loaded;
begin
  inherited Loaded;
  if ShellRoot.Pidl = nil then
    TcxShellRootAccess(ShellRoot).CheckRoot;
  GroupIndex := FLoadedGroupIndex;
  if HandleAllocated then
    DoHandleDependedInitialization;
end;

procedure TdxCustomShellTreeView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FShellDragDropState := ddsNone;
end;

// IDropTarget

function TdxCustomShellTreeView.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  ASize: TSize;
begin
  ASize.Init(ViewInfo.NodeViewInfo.Height);
  FAutoScrollHelper := TdxAutoScrollHelper.CreateScroller(Self, ClientBounds, ScaleFactor.Apply(20), 250, ASize);
  FExpandTimer := TcxTimer.Create(nil);
  if FDropTargetHelper = nil then
    CoCreateInstance(CLSID_DragDropHelper, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IDropTargetHelper, FDropTargetHelper);
  FDraggedObject := dataObj;
  FCurrentDropTarget := nil;
  dwEffect := DROPEFFECT_NONE;
  Result := S_OK;
  if FDropTargetHelper <> nil then
    FDropTargetHelper.DragEnter(Handle, dataObj, pt, dwEffect);
end;

function TdxCustomShellTreeView.DragLeave: HResult;
begin
  FDraggedObject := nil;
  Result := TryReleaseDropTarget;
  if FDropTargetHelper <> nil then
    FDropTargetHelper.DragLeave;
  FDropTargetHelper := nil;
  FreeAndNil(FExpandTimer);
  FreeAndNil(FAutoScrollHelper);
end;

function TdxCustomShellTreeView.IDropTargetDragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
var
  ANew: Boolean;
begin
  if not FPrevDragOverPoint.IsEqual(pt) then
  begin
    FAutoScrollHelper.CheckMousePosition(ScreenToClient(pt));
    FPrevDragOverPoint := pt;
  end;
  UpdateDropTarget(pt, ANew);
  if FCurrentDropTarget = nil then
  begin
    dwEffect := DROPEFFECT_NONE;
    Result := S_OK;
  end
  else
  begin
    if ANew then
      Result := FCurrentDropTarget.DragEnter(FDraggedObject, grfKeyState, pt, dwEffect)
    else
      Result := S_OK;
    if Succeeded(Result) then
      Result := FCurrentDropTarget.DragOver(grfKeyState, pt, dwEffect);
  end;
  if FDropTargetHelper <> nil then
    FDropTargetHelper.DragOver(pt, dwEffect);
  if DropTarget <> FExpandingNode then
  begin
    FExpandTimer.Enabled := False;
    FExpandingNode := DropTarget;
    if (FExpandingNode <> nil) and (FExpandingNode.HasChildren) then
    begin
      FExpandTimer.Interval := 1200;
      FExpandTimer.Enabled := True;
      FExpandTimer.OnTimer := OnExpandTimer;
    end;
  end;
end;

function TdxCustomShellTreeView.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  ANew: Boolean;
begin
  UpdateDropTarget(pt, ANew);
  if FCurrentDropTarget = nil then
  begin
    dwEffect := DROPEFFECT_NONE;
    Result := S_OK;
  end
  else
  begin
    if ANew then
      Result := FCurrentDropTarget.DragEnter(dataObj, grfKeyState, pt, dwEffect)
    else
      Result := S_OK;
    if Succeeded(Result) then
    begin
      if FDropTargetHelper <> nil then
        FDropTargetHelper.Drop(dataObj, pt, dwEffect);
      Result := FCurrentDropTarget.Drop(dataObj, grfKeyState, pt, dwEffect);
      if not ShellOptions.TrackShellChanges then
      begin
        TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
          procedure
          begin
            UpdateContent;
          end);
      end;
    end;
  end;
  FDraggedObject := nil;
  TryReleaseDropTarget;
  FDropTargetHelper := nil;
  FreeAndNil(FExpandTimer);
  FreeAndNil(FAutoScrollHelper);
end;

function TdxCustomShellTreeView.GetRoot: TcxCustomShellRoot;
begin
  Result := FShellRoot;
end;

function TdxCustomShellTreeView.GetDependedControls: TcxShellDependedControls;
begin
  Result := FShellDependedControls;
end;

procedure TdxCustomShellTreeView.AddItemProducer(AProducer: TdxShellTreeViewItemProducer);
var
  ATempList: TList;
begin
  ATempList := FItemProducersList.LockList;
  try
    ATempList.Add(AProducer);
  finally
    FItemProducersList.UnlockList;
  end;
end;

function TdxCustomShellTreeView.CanEdit(ANode: TdxTreeViewNode): Boolean;
var
  AShellItemInfo: TcxShellItemInfo;
begin
  Result := False;
  if ANode.Parent = nil then
     Exit;
  AShellItemInfo := GetShellItemInfo(ANode);
  if AShellItemInfo <> nil then
    Result := AShellItemInfo.CanRename and inherited CanEdit(ANode);
end;

procedure TdxCustomShellTreeView.ChangeTreeContent(AChangeProc: TProc);
var
  APrevSelectedPidl, ASelectedPidl: PItemIDList;
begin
  BeginUpdate;
  try
    if HandleAllocated then
      SendMessage(Handle, WM_SETREDRAW, 0, 0);
    LockUpdateVisibleInfo;
    APrevSelectedPidl := AbsolutePIDL;
    FIsUpdating := True;
    try
      SaveTreeState;
      try
        AChangeProc;
      finally
        RestoreTreeState;
      end;
    finally
      FIsUpdating := False;
      ASelectedPidl := AbsolutePIDL;
      try
        if not EqualPIDLs(APrevSelectedPidl, ASelectedPidl) then
          DoSelectionChanged;
      finally
        DisposePidl(ASelectedPidl);
      end;
      DisposePidl(APrevSelectedPidl);
      UnlockUpdateVisibleInfo;
      if HandleAllocated then
        SendMessage(Handle, WM_SETREDRAW, 1, 0);
      Update;
    end;
  finally
    EndUpdate;
  end;
end;

function TdxCustomShellTreeView.CheckFileMask(AFolder: TcxShellFolder): Boolean;
begin
  Result := ShellOptions.IsFileNameValid(ExtractFileName(AFolder.PathName));
end;

procedure TdxCustomShellTreeView.CreateChangeNotification(ANode: TdxTreeViewNode = nil);

  function GetShellChangeNotifierPIDL: PItemIDList;
  begin
    CheckShellRoot(ShellRoot);
    if ANode = nil then
      ANode := ShellRootNode;
    if IsShellRootNode(ANode) then
      Result := GetPidlCopy(ShellRoot.Pidl)
    else
      Result := GetShellItemInfo(ANode).RealItemPidl;
  end;

var
  APidl: PItemIDList;
begin
  if FIsChangeNotificationCreationLocked then
    Exit;
  FShellChangeNotificationCreation := True;
  try
    if not ShellOptions.TrackShellChanges or (Root.Count = 0) then
      RemoveChangeNotification
    else
    begin
      if FavoritesRootNode <> nil then
        cxShellRegisterChangeNotifier(GetItemProducer(FavoritesRootNode).FolderPidl, Handle, DSM_SYSTEMSHELLCHANGENOTIFY, False,
          FFavoritesShellChangeNotifierData);
      APidl := GetShellChangeNotifierPIDL;
      cxShellRegisterChangeNotifier(APidl, Handle, DSM_SYSTEMSHELLCHANGENOTIFY, True,
        FShellChangeNotifierData);
      DisposePidl(APidl);
    end;
  finally
    FShellChangeNotificationCreation := False;
  end;
end;

function TdxCustomShellTreeView.CreateOptionsBehavior: TdxTreeViewCustomOptionsBehavior;
begin
  Result := TdxShellTreeViewControlOptionsBehavior.Create(Self);
end;

function TdxCustomShellTreeView.CreateOptionsSelection: TdxTreeViewCustomOptionsSelection;
begin
  Result := TdxShellTreeViewControlOptionsSelection.Create(Self);
end;

function TdxCustomShellTreeView.CreateOptionsView: TdxTreeViewCustomOptionsView;
begin
  Result := TdxShellTreeViewControlOptionsView.Create(Self);
end;

function TdxCustomShellTreeView.CreatePainter: TdxTreeViewPainter;
begin
  Result := TdxShellTreeViewPainter.Create(Self);
end;

procedure TdxCustomShellTreeView.CutNode(ANode: TdxTreeViewNode);
var
  ANewCutItemPIDL: PItemIDList;
  APrevCutNode: TdxTreeViewNode;
  AShellItemInfo: TcxShellItemInfo;
begin
  if ANode <> nil then
    ANewCutItemPIDL := GetNodeAbsolutePIDL(ANode)
  else
    ANewCutItemPIDL := nil;
  if not EqualPIDLs(FCutItemPIDL, ANewCutItemPIDL) then
  begin
    if FCutItemPIDL <> nil then 
    begin
      APrevCutNode := GetNodeByPIDL(FCutItemPIDL);
      if APrevCutNode <> nil then
      begin
        AShellItemInfo := GetShellItemInfo(APrevCutNode);
        if AShellItemInfo <> nil then
          APrevCutNode.Cut := AShellItemInfo.IsGhosted;
      end;
      DisposePidl(FCutItemPIDL);
    end;
    FCutItemPIDL := ANewCutItemPIDL; 
    if FCutItemPIDL <> nil then
      ANode.Cut := True;
  end;
end;

function TdxCustomShellTreeView.DoAddFolder(AFolder: TcxShellFolder): Boolean;
begin
  Result := AFolder.IsFolder and
    (ShellOptions.ShowNonFolders or ShellOptions.ShowZipFilesWithFolders or not AFolder.IsZip) or
    not AFolder.IsFolder and CheckFileMask(AFolder);
  DoOnAddFolder(AFolder, Result);
end;

procedure TdxCustomShellTreeView.DoOnIdle(Sender: TObject; var Done: Boolean);
var
  AList: TList;
  AItem: TcxShellItemInfo;
begin
  AList := ItemsInfoGatherer.ProcessedItems.LockList;
  try
    if AList.Count > 0 then
      AItem := TcxShellItemInfo(AList.Extract(AList.First))
    else
      AItem := nil;
  finally
    ItemsInfoGatherer.ProcessedItems.UnlockList;
  end;
  if AItem <> nil then
    UpdateItem(AItem);
end;

function TdxCustomShellTreeView.GetNodeByPIDL(APIDL: PItemIDList;
  ANearestInChain: Boolean = False; ACheckExpanded: Boolean = False; ACheckCreated: Boolean = True;
  AStartParentNode: TdxTreeViewNode = nil): TdxTreeViewNode;
var
  AItemIndex, I: Integer;
  APID, AStartPidl: PItemIDList;
  AItemProducer: TdxShellTreeViewItemProducer;
  AAbsolutePidl: PItemIDList;
begin
  Result := nil;
  if APIDL = nil then
    Exit;

  CheckShellRoot(ShellRoot);
  if (QuickAccessRootNode <> nil) and EqualPIDLs(GetItemProducer(QuickAccessRootNode).FolderPidl, APIDL) then
  begin
    Result := QuickAccessRootNode;
    Exit;
  end
  else
    if (FFavoritesRootNode <> nil) and EqualPIDLs(GetItemProducer(FFavoritesRootNode).FolderPidl, APIDL) then
    begin
      Result := FFavoritesRootNode;
      Exit;
    end
    else
      if EqualPIDLs(ShellRoot.Pidl, APIDL) then
      begin
        Result := ShellRootNode;
        Exit;
      end;

  if AStartParentNode = nil then
  begin
    if (QuickAccessRootNode <> nil) and IsSubPath(GetItemProducer(QuickAccessRootNode).FolderPidl, APIDL) then
    begin
      for I := 0 to QuickAccessRootNode.Count - 1 do
      begin
        AAbsolutePidl := GetShellItemInfo(QuickAccessRootNode.Items[I]).CreateAbsolutePidl;
        if EqualPIDLs(AAbsolutePidl, APIDL) then
        begin
          DisposePidl(AAbsolutePidl);
          Result := QuickAccessRootNode.Items[I];
          Break;
        end;
        DisposePidl(AAbsolutePidl);
      end;
      Exit;
    end
    else
      if (FavoritesRootNode <> nil) and IsSubPath(GetItemProducer(FavoritesRootNode).FolderPidl, APIDL) then
      begin
        for I := 0 to FavoritesRootNode.Count - 1 do
        begin
          AAbsolutePidl := GetShellItemInfo(FavoritesRootNode.Items[I]).CreateAbsolutePidl;
          if EqualPIDLs(AAbsolutePidl, APIDL) then
          begin
            DisposePidl(AAbsolutePidl);
            Result := FavoritesRootNode.Items[I];
            Break;
          end;
          DisposePidl(AAbsolutePidl);
        end;
        Exit;
      end
      else
        if IsSubPath(ShellRoot.Pidl, APIDL) then
        begin
          AStartParentNode := ShellRootNode;
          AStartPidl := ShellRoot.Pidl;
        end
        else
          Exit;
  end
  else
  begin
    AItemProducer := GetItemProducer(AStartParentNode);
    AStartPidl := AItemProducer.FolderPidl;
  if not IsSubPath(AStartPidl, APIDL) then
    Exit;
  end;
  for I := 0 to GetPidlItemsCount(AStartPidl) - 1 do
    APIDL := GetNextItemID(APIDL);
  Result := AStartParentNode;
  for I := 0 to GetPidlItemsCount(APIDL) - 1 do
  begin
    APID := ExtractParticularPidl(APIDL);
    if APID = nil then
      Break;
    try
      AItemProducer := GetItemProducer(Result);
      AItemIndex := AItemProducer.GetItemIndexByPidl(APID);

      if not InRange(AItemIndex, 0, Result.Count - 1) then
      begin
        if not ANearestInChain then
          Result := nil;
        Break;
      end;
      Result := TdxTreeViewNode(AItemProducer.ItemInfo[AItemIndex].Data);
      if ACheckExpanded and not Result.Expanded or not ACheckExpanded and not ACheckCreated and not CanExpand(Result) then
        Break;
      APIDL := GetNextItemID(APIDL);
    finally
      DisposePidl(APID);
    end;
  end;
end;

procedure TdxCustomShellTreeView.RemoveChangeNotification;
begin
  cxShellUnregisterChangeNotifier(FShellChangeNotifierData);
  cxShellUnregisterChangeNotifier(FFavoritesShellChangeNotifierData);
end;

procedure TdxCustomShellTreeView.RemoveItemProducer(AProducer: TdxShellTreeViewItemProducer);
var
  ATempList: TList;
begin
  ATempList := FItemProducersList.LockList;
  try
    ATempList.Remove(AProducer);
  finally
    FItemProducersList.UnlockList;
  end;
end;

procedure TdxCustomShellTreeView.UpdateImages;
begin
  FNeedUpdateImages := True;
  TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
    procedure
    begin
      if FNeedUpdateImages then
      begin
        FInternalSmallImages.Reload;
        FNeedUpdateImages := False;
      end;
    end);
end;

procedure TdxCustomShellTreeView.UpdateItem(AItem: TcxShellItemInfo);
var
  AItemProducer: TdxShellTreeViewItemProducer;
  AUpdatingNode: TdxTreeViewNode;
begin
  AUpdatingNode := TdxTreeViewNode(AItem.Data);
  AItemProducer := TdxShellTreeViewItemProducer(AItem.ItemProducer);
  AItemProducer.LockRead;
  try
    AUpdatingNode.ImageIndex := AItem.IconIndex;
    if IsFavoritesItemNode(AUpdatingNode) then
      AUpdatingNode.OverlayImageIndex := -1
    else
      AUpdatingNode.OverlayImageIndex := AItem.OverlayIndex;
    AUpdatingNode.Caption := AItem.Name;
    AUpdatingNode.HasChildren := AItem.HasSubfolder;
    AUpdatingNode.Cut := AItem.IsGhosted or ((FCutItemPIDL <> nil) and (GetNodeByPIDL(FCutItemPIDL) = AUpdatingNode));
    AItem.Processed := True;
  finally
    AItemProducer.UnlockRead;
  end;
end;

procedure TdxCustomShellTreeView.UpdateNode(ANode: TdxTreeViewNode; AFast: Boolean);
begin
  if not IsLoading and ShellRoot.IsValid and (ANode <> nil) then
  begin
    if not AFast or IsShellRootNode(ANode) then
    begin
      ANode.HasChildren := True;
      if not CanExpand(ANode) then
        InternalUpdateNode(ANode);
    end
    else
      InternalUpdateNode(ANode);
  end;
end;

procedure TdxCustomShellTreeView.UpdateRootNodes;

  procedure AddQuickAccessNode(AParent: TdxTreeViewNode);
  begin
    FQuickAccessRootNode := AParent.AddChild;
    FQuickAccessRootNode.Data := TdxShellTreeViewItemProducer.Create(Self);
  end;

  procedure CreateQuickAccessNode;
  var
    ANode: TdxTreeViewNode;
    ATempPidl: PItemIDList;
    ATempIFolder: IShellFolder;
  begin
    if dxGetQuickAccessPidl(ATempPidl) then
      if Succeeded(GetDesktopIShellFolder.BindToObject(ATempPidl, nil, IID_IShellFolder, ATempIFolder)) then
      begin
        if FirstLevelNodesVisible then
         AddQuickAccessNode(Root)
        else
        begin
          ANode := Root.AddChild;
          ANode.Data := nil;
          AddQuickAccessNode(ANode);
        end;
        GetItemProducer(QuickAccessRootNode).ProcessItems(ATempIFolder, ATempPidl, QuickAccessRootNode, ViewInfo.NumberOfNodesInContentRect);
      end
      else
        DisposePidl(ATempPidl);
  end;

  procedure AddFavoritedNode(AParent: TdxTreeViewNode);
  begin
    FFavoritesRootNode := AParent.AddChild;
    FFavoritesRootNode.Data := TdxShellTreeViewItemProducer.Create(Self);
  end;

  procedure CreateFavoritesNode;
  var
    ANode: TdxTreeViewNode;
    ATempPidl: PItemIDList;
    ATempIFolder: IShellFolder;
  begin
    if dxGetFavoritesPidl(ATempPidl) then
      if Succeeded(GetDesktopIShellFolder.BindToObject(ATempPidl, nil, IID_IShellFolder, ATempIFolder)) then
      begin
        if FirstLevelNodesVisible then
         AddFavoritedNode(Root)
        else
        begin
          ANode := Root.AddChild;
          ANode.Data := nil;
          AddFavoritedNode(ANode);
        end;
        GetItemProducer(FFavoritesRootNode).ProcessItems(ATempIFolder, ATempPidl, FFavoritesRootNode, ViewInfo.NumberOfNodesInContentRect);
      end
      else
        DisposePidl(ATempPidl);
  end;

  procedure CreateDesktopNode;
  begin
    FShellRootNode := Root.AddChild;
    ShellRootNode.Data := TdxShellTreeViewItemProducer.Create(Self);
    ShellRootNode.HasChildren := True;
    if not CanExpand(ShellRootNode) then
      InternalUpdateNode(ShellRootNode);
    if HandleAllocated then
      CreateChangeNotification;
  end;

begin
  ClearDefferedShellSystemEvents;
  Root.Clear;
  if IsFavoritesVisible then
  begin
    if IsWin10OrLater then
      CreateQuickAccessNode 
    else
      CreateFavoritesNode;
  end;
  CreateDesktopNode;
  if (QuickAccessRootNode <> nil) and not FirstLevelNodesVisible then
    QuickAccessRootNode.Parent.Expand;
  if (FFavoritesRootNode <> nil) and not FirstLevelNodesVisible then
    FFavoritesRootNode.Parent.Expand;
end;

procedure TdxCustomShellTreeView.UpdateVisibleItems;
var
  I, AFirstVisibleIndex, ALastVisibleIndex: Integer;
  ANode: TdxTreeViewNode;
  AItems: TList;
  AVisibleCount: Integer;
  AItemInfo: TcxShellItemInfo;
begin
  AVisibleCount := Min(ViewInfo.NumberOfNodesInContentRect + 1, AbsoluteVisibleNodes.Count);
  if (FLockVisibleUpdate > 0) or (AVisibleCount = 0) then
    Exit;
  AItems := TList.Create;
  FItemsInfoGatherer.ProcessedItems.LockList; 
  try
    AFirstVisibleIndex := TdxTreeViewViewInfoAccess(ViewInfo).FirstVisibleIndex;
    ALastVisibleIndex := Min(AFirstVisibleIndex + AVisibleCount - 1, AbsoluteVisibleNodes.Count - 1);
    for I := AFirstVisibleIndex to ALastVisibleIndex do
    begin
      ANode := AbsoluteVisibleNodes[I];
      if not IsShellOrFavoritesRootNode(ANode) then
      begin
        AItemInfo := GetShellItemInfo(ANode);
        if not AItemInfo.Updated then
          AItems.Add(AItemInfo)
        else
          if not AItemInfo.Processed then
            UpdateItem(AItemInfo);
      end;
    end;
    ItemsInfoGatherer.UpdateRequest(AItems);
  finally
    FItemsInfoGatherer.ProcessedItems.UnlockList;
    AItems.Free;
  end;
end;

procedure TdxCustomShellTreeView.AddDefferedUpdateContent;
begin
  AddDefferedShellSystemEvent(0, GetPidlCopy(ShellRoot.Pidl), nil);
end;

procedure TdxCustomShellTreeView.DoOnAddFolder(AFolder: TcxShellFolder; var ACanAdd: Boolean);
begin
  if Assigned(FOnAddFolder) then
    FOnAddFolder(Self, AFolder, ACanAdd);
end;

function TdxCustomShellTreeView.IsShellRootNode(ANode: TdxTreeViewNode): Boolean;
begin
   Result := ANode = ShellRootNode;
end;

function TdxCustomShellTreeView.IsFavoritesItemNode(ANode: TdxTreeViewNode): Boolean;
begin
  Result := (FavoritesRootNode <> nil) and (ANode.Parent = FavoritesRootNode);
end;

function TdxCustomShellTreeView.IsQuickAccessItemNode(ANode: TdxTreeViewNode): Boolean;
begin
  Result := (QuickAccessRootNode <> nil) and (ANode.Parent = QuickAccessRootNode);
end;

function TdxCustomShellTreeView.IsFavoritesParentFakeNode(ANode: TdxTreeViewNode): Boolean;
begin
  Result := not FirstLevelNodesVisible and (ANode.Parent.IsRoot) and not IsShellRootNode(ANode);
end;

function TdxCustomShellTreeView.IsShellOrFavoritesRootNode(ANode: TdxTreeViewNode): Boolean;
begin
  Result := FFirstLevelNodesVisible and (ANode.Parent.IsRoot) or
    not FFirstLevelNodesVisible and (IsShellRootNode(ANode) or
      (ANode.Parent <> nil) and not IsShellRootNode(ANode.Parent) and (ANode.Parent.Parent <> nil) and ANode.Parent.Parent.IsRoot);
end;

procedure TdxCustomShellTreeView.AddDefferedShellSystemEvent(AEventID: Longint; APidl1, APidl2: PItemIDList);
var
  AEventInfo: TdxShellSystemEventInfo;
begin
  AEventInfo.EventID := AEventID;
  AEventInfo.Pidl1 := APidl1;
  AEventInfo.Pidl2 := APidl2;
  FDefferedShellSystemEvents.Add(AEventInfo);
end;

procedure TdxCustomShellTreeView.ClearDefferedShellSystemEvents;
var
  I: Integer;
begin
  for I := FDefferedShellSystemEvents.Count - 1 downto 0 do
  begin
    DisposePidl(FDefferedShellSystemEvents[I].Pidl1);
    DisposePidl(FDefferedShellSystemEvents[I].Pidl2);
    FDefferedShellSystemEvents.Delete(I);
  end;
end;

procedure TdxCustomShellTreeView.ProcessDefferedShellSystemEvents;
var
  AEventInfo: TdxShellSystemEventInfo;
begin
  if (FEventProcessingCount = 0) and not FIsContextPopupProcessing and (FLockChange = 0) and not FIsUpdating and (FDragSource = nil) then
    while FDefferedShellSystemEvents.Count > 0 do
    begin
      Inc(FEventProcessingCount);
      AEventInfo := FDefferedShellSystemEvents.Extract(FDefferedShellSystemEvents.First);
      try
        DoProcessSystemShellChange(AEventInfo.EventID, AEventInfo.Pidl1, AEventInfo.Pidl2);
      finally
        DisposePidl(AEventInfo.Pidl1);
        DisposePidl(AEventInfo.Pidl2);
      end;
      Dec(FEventProcessingCount);
    end;
end;

procedure TdxCustomShellTreeView.CreateDropTarget;
begin
  dxTestCheck(Succeeded(RegisterDragDrop(Handle, Self)), 'RegisterDragDrop - dxShellTreeView');
end;

function TdxCustomShellTreeView.CreateShellNode(AParentNode: TdxTreeViewNode; AShellItem: TcxShellItemInfo): TdxTreeViewNode;
var
  AItemProducer: TdxShellTreeViewItemProducer;
begin
  AItemProducer := TdxShellTreeViewItemProducer.Create(Self);
  AItemProducer.ShellItemInfo := AShellItem;
  Result := AParentNode.AddChild(AShellItem.Name, AItemProducer);
  AShellItem.Data := Result;
  Result.ImageIndex := AShellItem.IconIndex;
  Result.HasChildren := AShellItem.HasSubfolder;
  Result.Cut := AShellItem.IsGhosted;
end;

procedure TdxCustomShellTreeView.DoEdited(ANode: TdxTreeViewNode; var ACaption: string);
var
  AShellItem: TcxShellItemInfo;
  AItemProducer: TdxShellTreeViewItemProducer;
  APIDL: PItemIDList;
begin
  if ANode.Caption = ACaption then
    Exit;
  inherited DoEdited(ANode, ACaption);
  AShellItem := GetShellItemInfo(ANode);
  AItemProducer := GetItemProducer(ANode.Parent);
  if Succeeded(AItemProducer.ShellFolder.SetNameOf(Handle, AShellItem.pidl,
    PChar(ACaption), SHGDN_INFOLDER or SHGDN_FOREDITING, APIDL)) then
  try
    if not ShellOptions.TrackShellChanges then
      AShellItem.SetNewPidl(APIDL);
  finally
    DisposePidl(APIDL);
  end;
end;

procedure TdxCustomShellTreeView.DoSelectionChanged;
begin
  if not FIsUpdating then
  begin
    inherited DoSelectionChanged;
    UpdateNode(FocusedNode, not FNavigation);
  end;
end;

function TdxCustomShellTreeView.GetContextMenuSite: IUnknown;
begin
  Result := nil;
end;

procedure TdxCustomShellTreeView.InternalUpdateNode(ANode: TdxTreeViewNode);
var
  AAbsolutePIDL: PItemIDList;
  AParentItemProducer: TdxShellTreeViewItemProducer;
  AShellItemInfo: TcxShellItemInfo;
begin
  AShellItemInfo := GetShellItemInfo(ANode);
  AParentItemProducer := GetItemProducer(ANode.Parent);
  if AParentItemProducer = nil then
    Exit;
  AAbsolutePIDL := ConcatenatePidls(AParentItemProducer.FolderPidl, AShellItemInfo.pidl);
  try
    GetItemProducer(ANode).FolderPidl := AAbsolutePIDL;
    ANode.HasChildren := HasSubItems(AParentItemProducer.ShellFolder, AAbsolutePIDL,
      AParentItemProducer.GetEnumFlags);
  finally
    DisposePidl(AAbsolutePIDL);
  end;
end;

function TdxCustomShellTreeView.GetAbsolutePIDL: PItemIDList;
begin
  Result := nil;
  if FocusedNode <> nil then
    Result := GetNodeAbsolutePIDL(FocusedNode);
end;

procedure TdxCustomShellTreeView.UpdateDropTarget(const APoint: TPoint; out ANew: Boolean);
var
  ANode: TdxTreeViewNode;
begin
  if not OptionsBehavior.AllowDragDrop then
  begin
    FCurrentDropTarget := nil;
    Exit;
  end;
  if not GetNodeAtPos(ScreenToClient(APoint), ANode) then
    TryReleaseDropTarget;
  ANew := (ANode <> nil) and ((ANode <> DropTarget) or (FCurrentDropTarget = nil));
  if ANew then
  begin
    TryReleaseDropTarget;
    if (FDragSource = nil) or ((ANode <> FDragSource) and not ANode.HasAsParent(FDragSource)) then
      InternalUpdateDropTarget(ANode);
  end;
  DropTarget := ANode;
end;

function TdxCustomShellTreeView.GetOptionsBehavior: TdxShellTreeViewControlOptionsBehavior;
begin
  Result := inherited OptionsBehavior as TdxShellTreeViewControlOptionsBehavior;
end;

function TdxCustomShellTreeView.GetOptionsSelection: TdxShellTreeViewControlOptionsSelection;
begin
  Result := inherited OptionsSelection as TdxShellTreeViewControlOptionsSelection;
end;

function TdxCustomShellTreeView.GetOptionsView: TdxShellTreeViewControlOptionsView;
begin
  Result := inherited OptionsView as TdxShellTreeViewControlOptionsView;
end;

function TdxCustomShellTreeView.GetItemProducer(ANode: TdxTreeViewNode): TdxShellTreeViewItemProducer;
begin
  Result := TdxShellTreeViewItemProducer(ANode.Data);
end;

function TdxCustomShellTreeView.GetPath: string;
var
  ATempPIDL: PItemIDList;
begin
  ATempPIDL := AbsolutePIDL;
  try
    Result := GetPidlName(ATempPIDL);
  finally
    DisposePidl(ATempPIDL);
  end;
end;

function TdxCustomShellTreeView.GetShellItemInfo(ANode: TdxTreeViewNode): TcxShellItemInfo;
begin
  Result := GetItemProducer(ANode).ShellItemInfo;
end;

procedure TdxCustomShellTreeView.LockUpdateVisibleInfo;
begin
  Inc(FLockVisibleUpdate);
end;

procedure TdxCustomShellTreeView.OnExpandTimer(Sender: TObject);
begin
  FExpandTimer.Enabled := False;
  if FExpandingNode <> nil then
    FExpandingNode.Expand;
end;

procedure TdxCustomShellTreeView.RestoreTreeState;

  procedure RestoreExpandedNodes;

    procedure ExpandNode(APIDL: PItemIDList);
    var
      ANode: TdxTreeViewNode;
    begin
      CheckShellRoot(ShellRoot);
      if APIDL = nil then
        APIDL := ShellRoot.Pidl;
      ANode := GetNodeByPIDL(APIDL);
      if ANode <> nil then
        ANode.Expanded := True;
    end;

    procedure DestroyExpandedNodeList;
    var
      I: Integer;
    begin
      if FStateData.ExpandedNodeList = nil then
        Exit;
      for I := 0 to FStateData.ExpandedNodeList.Count - 1 do
        DisposePidl(PItemIDList(FStateData.ExpandedNodeList[I]));
      FreeAndNil(FStateData.ExpandedNodeList);
    end;

  var
    I: Integer;
  begin
    try
      for I := 0 to FStateData.ExpandedNodeList.Count - 1 do
        ExpandNode(PItemIDList(FStateData.ExpandedNodeList[I]));
    finally
      DestroyExpandedNodeList;
    end;
  end;

  procedure RestoreCurrentPath;
  var
    ACurrentPath, ATempPIDL: PItemIDList;
  begin
    if FStateData.CurrentPath = nil then
      Exit;
    ACurrentPath := GetPidlCopy(FStateData.CurrentPath);
    try
      repeat
        if GetNodeByPIDL(ACurrentPath) <> nil then
        begin
          FNavigation := True;
          try
            DoNavigate(ACurrentPath);
          finally
            FNavigation := False;
          end;
          Break;
        end;
        ATempPIDL := ACurrentPath;
        ACurrentPath := GetPidlParent(ACurrentPath);
        DisposePidl(ATempPIDL);
      until GetPidlItemsCount(ACurrentPath) <= 1;
    finally
      DisposePidl(ACurrentPath);
    end;
  end;

begin
  try
    RestoreExpandedNodes;
    RestoreCurrentPath;
    ViewInfo.ViewPort := FStateData.ViewPort;
  finally
    DisposePidl(FStateData.CurrentPath);
    FStateData.CurrentPath := nil;
  end;
end;

procedure TdxCustomShellTreeView.RootFolderChanged(Sender: TObject; Root: TcxCustomShellRoot);
begin
  UpdateRootNodes;
  if Assigned(FOnRootChanged) then
    FOnRootChanged(Self, FShellRoot);
end;

procedure TdxCustomShellTreeView.RootSettingsChanged(Sender: TObject);
begin
  if not IsLoading then
  begin
    TdxShellControlGroups.RootChanged(Self, ShellRoot, FGroupIndex);
    FShellDependedControls.SynchronizeRoot(ShellRoot);
  end;
end;

procedure TdxCustomShellTreeView.SaveTreeState;

  procedure DoSaveExpandedNode(ANode: TdxTreeViewNode);
  begin
    if IsShellRootNode(ANode) then
      FStateData.ExpandedNodeList.Add(nil)
    else
      FStateData.ExpandedNodeList.Add(GetNodeAbsolutePIDL(ANode));
  end;

  procedure SaveExpandedNodes(AParentNode: TdxTreeViewNode);
  var
    ANode: TdxTreeViewNode;
  begin
    if FStateData.ExpandedNodeList = nil then
      FStateData.ExpandedNodeList := TList.Create;
    ANode :=  AParentNode.First;
    while ANode <> nil do
    begin
      if ANode.Expanded and not IsFavoritesParentFakeNode(ANode) then
        DoSaveExpandedNode(ANode);
      if ANode.HasChildren and (not IsShellOrFavoritesRootNode(ANode) or IsShellRootNode(ANode)) then
        SaveExpandedNodes(ANode);
      ANode := ANode.Next;
    end;
  end;

  procedure SaveCurrentPath;
  begin
    if (FocusedNode <> nil) and not FocusedNode.IsRoot then
      if IsQuickAccessItemNode(FocusedNode) or IsFavoritesItemNode(FocusedNode) then
        FStateData.CurrentPath := GetShellItemInfo(FocusedNode).CreateAbsolutePidl
      else
        FStateData.CurrentPath := GetNodeAbsolutePIDL(FocusedNode);
  end;

begin
  FStateData.ViewPort := ViewInfo.ViewPort;
  SaveExpandedNodes(Root);
  SaveCurrentPath;
end;

procedure TdxCustomShellTreeView.SetAbsolutePIDL(AValue: PItemIDList);
begin
  if CheckAbsolutePIDL(AValue, ShellRoot, True) then
  begin
    FNavigation := True;
    try
      DoNavigate(AValue);
    finally
      FNavigation := False;
    end;
  end;
end;

procedure TdxCustomShellTreeView.SetFirstLevelNodesVisible(AValue: Boolean);
begin
  if FFirstLevelNodesVisible <> AValue then
  begin
    FFirstLevelNodesVisible := AValue;
    UpdateRootNodes;
  end;
end;

procedure TdxCustomShellTreeView.SetGroupIndex(AValue: Integer);
begin
  if FGroupIndex <> AValue then
  begin
    if IsLoading then
      FLoadedGroupIndex := AValue
    else
    begin
      if FGroupIndex >= 0 then
        TdxShellControlGroups.RemoveControl(Self, FGroupIndex);
      FGroupIndex := AValue;
      if FGroupIndex >= 0 then
        TdxShellControlGroups.AddControl(Self, FGroupIndex);
    end;
  end;
end;

procedure TdxCustomShellTreeView.SetOptionsBehavior(AValue: TdxShellTreeViewControlOptionsBehavior);
begin
  inherited OptionsBehavior := AValue;
end;

procedure TdxCustomShellTreeView.SetOptionsSelection(AValue: TdxShellTreeViewControlOptionsSelection);
begin
  inherited OptionsSelection := AValue;
end;

procedure TdxCustomShellTreeView.SetOptionsView(AValue: TdxShellTreeViewControlOptionsView);
begin
  inherited OptionsView := AValue;
end;

procedure TdxCustomShellTreeView.SetPath(AValue: string);

  function GetViewOptions: TcxShellViewOptions;
  begin
    Result := [svoShowHidden];
    if ShellOptions.ShowNonFolders then
      Include(Result, svoShowFiles);
    if ShellOptions.ShowFolders then
      Include(Result, svoShowFolders);
  end;

var
  APIDL: PItemIDList;
begin
  APIDL := PathToAbsolutePIDL(AValue, ShellRoot, GetViewOptions);
  if APIDL <> nil then
    try
      AbsolutePIDL := APIDL;
    finally
      DisposePidl(APIDL);
    end;
end;

procedure TdxCustomShellTreeView.SetRootField(AValue: TdxShellTreeViewRoot);
begin
  FShellRoot.Assign(AValue);
end;

procedure TdxCustomShellTreeView.ShellChangeNotify(AEventID: Longint; APidl1, APidl2: PItemIDList);
begin
  if not FShellChangeNotificationCreation and not FIsUpdating and (FLockChange = 0) then
  begin
    try
      ChangeTreeContent(procedure
        begin
          UpdateRootNodes;
        end);
    finally
      if Assigned(FOnShellChange) then
        FOnShellChange(Self, AEventID, APidl1, APidl2);
    end
  end;
end;

function TdxCustomShellTreeView.TryReleaseDropTarget: HResult;
begin
  Result := S_OK;
  if FCurrentDropTarget <> nil then
     Result := FCurrentDropTarget.DragLeave;
  FCurrentDropTarget := nil;
  DropTarget := nil;
end;

procedure TdxCustomShellTreeView.UnlockUpdateVisibleInfo;
begin
  if FLockVisibleUpdate > 0 then
    Dec(FLockVisibleUpdate);
end;

procedure TdxCustomShellTreeView.InternalUpdateDropTarget(ANode: TdxTreeViewNode);
var
  AItemProducer: TdxShellTreeViewItemProducer;
  ATempShellItemInfo: TcxShellItemInfo;
  ATempPidl: PItemIDList;
  ATempShellFolder: IShellFolder;
  AIsFolder: Boolean;
begin
  ATempPidl := nil;
  ATempShellItemInfo := GetShellItemInfo(ANode);
  AIsFolder := IsShellOrFavoritesRootNode(ANode) or ATempShellItemInfo.IsFolder;
  try
    if AIsFolder then
    begin
      if IsShellOrFavoritesRootNode(ANode) then
      begin
        AItemProducer := GetItemProducer(ANode);
        if not AItemProducer.IsQuickAccess then
          ATempShellFolder := AItemProducer.ShellFolder
        else
          if Failed(CoCreateInstance(CLSID_FrequentPlacesFolder, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IShellFolder, ATempShellFolder)) then
            ATempShellFolder := nil;
      end
      else
      begin
        AItemProducer := GetItemProducer(ANode.Parent);
        ATempPidl := GetPidlCopy(ATempShellItemInfo.pidl);
        if Failed(AItemProducer.ShellFolder.BindToObject(ATempPidl,
          nil, IID_IShellFolder, ATempShellFolder)) then
          ATempShellFolder := nil;
      end;
      if (ATempShellFolder = nil) or Failed(ATempShellFolder.CreateViewObject(Handle, IDropTarget, FCurrentDropTarget)) then
        FCurrentDropTarget := nil;
    end
    else
    begin
      AItemProducer := GetItemProducer(ANode.Parent);
      ATempPidl := GetPidlCopy(ATempShellItemInfo.pidl);
      if Failed(AItemProducer.ShellFolder.GetUIObjectOf(0, 1,
        ATempPidl, IDropTarget, nil, FCurrentDropTarget)) then
        FCurrentDropTarget := nil;
    end;
  finally
    DisposePidl(ATempPidl);
  end;
end;

procedure TdxCustomShellTreeView.DoBeginDrag;

  procedure InternalDoDragDrop(AFolder: IShellFolder; ATempPidl: PItemIDList);
  var
    ADataObject: IDataObject;
    AEffect: Cardinal;
    AAttributes: Cardinal;
  begin
    try
      if Succeeded(AFolder.GetUIObjectOf(Handle, 1, ATempPidl,
        IDataObject, nil, ADataObject)) then
      begin
        AEffect := 0;
        AAttributes := SFGAO_CANDELETE or SFGAO_CANCOPY or SFGAO_CANMOVE or SFGAO_CANLINK;
        if Succeeded(AFolder.GetAttributesOf(1, ATempPidl, AAttributes)) then
        begin
          if AAttributes and SFGAO_CANDELETE <> 0 then
            AAttributes := AAttributes or DROPEFFECT_MOVE;
          AEffect := AAttributes and (DROPEFFECT_COPY or DROPEFFECT_MOVE or DROPEFFECT_LINK);
        end;
        SHDoDragDrop(Handle, ADataObject, nil, AEffect, AEffect); // #Ch different function declaration in old ide
      end;
    finally
      DisposePidl(ATempPidl);
    end;
  end;

var
  ASourceItemProducer: TdxShellTreeViewItemProducer;
begin
  if IsShellRootNode(PressedItem) then
    Exit;
  FDragSource := PressedItem;
  try
    if IsShellOrFavoritesRootNode(PressedItem) then
      InternalDoDragDrop(GetDesktopIShellFolder, GetNodeAbsolutePIDL(PressedItem))
    else
    begin
      ASourceItemProducer := GetItemProducer(PressedItem.Parent);
      ASourceItemProducer.LockRead;
      try
        if PressedItem.Index < ASourceItemProducer.Items.Count then
          InternalDoDragDrop(ASourceItemProducer.ShellFolder, GetPidlCopy(GetShellItemInfo(PressedItem).pidl));
      finally
        ASourceItemProducer.UnlockRead;
      end;
    end;
  finally
    FDragSource := nil;
    if not ShellOptions.TrackShellChanges then
      AddDefferedUpdateContent;
    ProcessDefferedShellSystemEvents;
  end;
end;

procedure TdxCustomShellTreeView.ChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  inherited ChangeScaleEx(M, D, isDpiChange);
  FInternalSmallImages.ScaleChanged(ScaleFactor);
end;

procedure TdxCustomShellTreeView.DoHandleDependedInitialization;
begin
  CreateChangeNotification;
  CreateDropTarget;
end;

procedure TdxCustomShellTreeView.DoNavigate(APidl: PItemIDList);
var
  ASourcePidl: PItemIDList;
  AShellFolder: IShellFolder;
  APartDstPidl: PItemIDList;
  I: Integer;
  ATempProducer: TdxShellTreeViewItemProducer;
  ATempIndex: Integer;
  ANode: TdxTreeViewNode;
begin
  if (ShellRootNode = nil) or Failed(SHGetDesktopFolder(AShellFolder)) then
    Exit;
  BeginUpdate;
  try
    if (QuickAccessRootNode <> nil) and EqualPIDLs(GetItemProducer(QuickAccessRootNode).FolderPidl, APidl) then
    begin
      FocusedNode := QuickAccessRootNode;
      Exit;
    end
    else
      if (FavoritesRootNode <> nil) and EqualPIDLs(GetItemProducer(FavoritesRootNode).FolderPidl, APidl) then
      begin
        FocusedNode := FavoritesRootNode;
        Exit;
      end
      else
        if EqualPIDLs(ShellRoot.Pidl, APidl) then
        begin
          FocusedNode := ShellRootNode;
          Exit;
        end;

    if (QuickAccessRootNode <> nil) and IsSubPath(GetItemProducer(QuickAccessRootNode).FolderPidl, APidl) then
    begin
      FocusedNode := GetNodeByPIDL(APidl);
      Exit;
    end
    else
      if (FavoritesRootNode <> nil) and IsSubPath(GetItemProducer(FavoritesRootNode).FolderPidl, APidl) then
      begin
        FocusedNode := GetNodeByPIDL(APidl);
        Exit;
      end
      else
        if IsSubPath(ShellRoot.Pidl, APidl) then
        begin
          ANode := ShellRootNode;
          ASourcePidl := ShellRoot.Pidl;
        end
        else
        begin
          ShellRoot.Pidl := APidl;
          FocusedNode := ShellRootNode;
          Exit;
        end;

    for I := 0 to GetPidlItemsCount(ASourcePidl) - 1 do
      APidl := GetNextItemID(APidl);
    FocusedNode := ANode; // #ch is nil for desktop node if ShowFirstLevelNodes false
    for I := 0 to GetPidlItemsCount(APidl) - 1 do
    begin
      ATempProducer := ANode.Data;
      APartDstPidl := ExtractParticularPidl(APidl);
      APidl := GetNextItemID(APidl);
      if APartDstPidl = nil then
        Break;
      try
        ATempIndex := ATempProducer.GetItemIndexByPidl(APartDstPidl);
        if ATempIndex = -1 then
          Break;
        FocusedNode := ANode.Items[ATempIndex];
        ANode := FocusedNode;
      finally
        DisposePidl(APartDstPidl);
      end;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomShellTreeView.DoPathChanged;
var
  APidl: PItemIDList;
begin
  if (FocusedNode <> nil) and not FocusedNode.IsRoot then
  begin
    APidl := AbsolutePIDL;
    try
      TdxShellControlGroups.AbsolutePidlChanged(Self, APidl, FGroupIndex);
      FShellDependedControls.Navigate(APidl);
    finally
      DisposePidl(APidl);
    end;
  end;
  CallNotify(FOnPathChanged, Self);
end;

procedure TdxCustomShellTreeView.DoProcessSystemShellChange(AEventID: Longint; APidl1, APidl2: PItemIDList);

  function NeedProcessMessage(AEventID: Longint; APidl1, APidl2: PItemIDList): Boolean;
  var
    AParentPidl: PItemIDList;
  begin
    if AEventID and SHCNE_UPDATEITEM = SHCNE_UPDATEITEM then
      Result := False
    else
    begin
      Result := GetNodeByPIDL(APidl1) <> nil;
      if not Result then
      begin
        AParentPidl := GetPidlParent(APidl1);
        try
          Result := GetNodeByPIDL(AParentPidl) <> nil;
        finally
          DisposePidl(AParentPidl);
        end;
      end;
    end;
  end;

  procedure CheckRenameNotify(AEventID: Longint; APidl1, APidl2: PItemIDList);
  var
    AShellItemInfo: TcxShellItemInfo;
    ANode: TdxTreeViewNode;
  begin
    if (AEventID and SHCNE_RENAMEFOLDER = SHCNE_RENAMEFOLDER) or (AEventID and SHCNE_RENAMEITEM = SHCNE_RENAMEITEM) then
    begin
      ANode := GetNodeByPIDL(APidl1);
      if ANode <> nil then
      begin
        AShellItemInfo := GetShellItemInfo(ANode);
        AShellItemInfo.SetNewPidl(GetLastPidlItem(APidl2));
      end;
    end;
  end;

var
  ANode: TdxTreeViewNode;
begin
  if NeedProcessMessage(AEventID, APidl1, APidl2) then
  begin
    CheckRenameNotify(AEventID, APidl1, APidl2);
    ShellChangeNotify(AEventID, APidl1, APidl2);
    if FIsInternalItemCreation and ((AEventID = SHCNE_MKDIR) or (AEventID = SHCNE_CREATE)) then
    begin
      ANode := GetNodeByPIDL(APidl1);
      if ANode <> nil then
        StartItemCaptionEditing(ANode);
    end;
  end;
end;

procedure TdxCustomShellTreeView.DoSelectNodeByMouse(ANode: TdxTreeViewNode; AShift: TShiftState; AHitAtCheckBox: Boolean);
begin
  inherited DoSelectNodeByMouse(ANode, AShift, AHitAtCheckBox);
  DoPathChanged;
end;

procedure TdxCustomShellTreeView.DsmDoNavigate(var Message: TMessage);
var
  ANode: TdxTreeViewNode;
begin
  ANode := GetNodeByPIDL(PItemIDList(Message.WParam), True, False, False);
  if ANode <> nil then
  begin
    FocusedNode := ANode;
    MakeVisible(FocusedNode);
  end;
end;

procedure TdxCustomShellTreeView.DSMNotifyAddItem(var Message: TMessage);
var
  AParentProducer: TdxShellTreeViewItemProducer;
  ANode: TdxTreeViewNode;
begin
  ANode := TdxTreeViewNode(Message.LParam);
  AParentProducer := GetItemProducer(ANode);
  if AParentProducer = nil then
    Exit;
  AParentProducer.LockRead;
  try
    CreateShellNode(ANode, AParentProducer.Items[Message.WParam]);
  finally
    AParentProducer.UnlockRead;
  end;
end;

procedure TdxCustomShellTreeView.DSMNotifyRemoveItem(var Message: TMessage);
var
  ANode: TdxTreeViewNode;
begin
  ANode := TdxTreeViewNode(Message.LParam);
  if Message.WParam < WParam(ANode.Count) then
    ANode.Items[Message.WParam].Free;
end;

procedure TdxCustomShellTreeView.DSMSetCount(var Message: TMessage);
var
  ANode: TdxTreeViewNode;
  AParentProducer: TdxShellTreeViewItemProducer;
  I: Integer;
  AWasExpanded: Boolean;
begin
  ANode := TdxTreeViewNode(Message.LParam);
  if Message.WParam = 0 then
  begin
    ANode.Clear;
    ANode.HasChildren := False;
    Exit;
  end;
  AParentProducer := GetItemProducer(ANode);
  AParentProducer.LockRead;
  try
    BeginUpdate;
    try
      AWasExpanded := ANode.Expanded;
      for I := 0 to AParentProducer.Items.Count - 1 do
        CreateShellNode(ANode, AParentProducer.Items[I]);
      ANode.Expanded := AWasExpanded;
    finally
      EndUpdate;
    end;
    if ANode.First = nil then
       ANode.HasChildren := False;
  finally
    AParentProducer.UnlockRead;
  end;
end;

procedure TdxCustomShellTreeView.DSMSynchronizeRoot(var Message: TMessage);
begin
  if not IsLoading then
    ShellRoot.Update(TcxCustomShellRoot(Message.WParam));
end;

procedure TdxCustomShellTreeView.DSMSystemShellChangeNotify(var Message: TMessage);
var
  AEventID: Integer;
  APIDL1, APIDL2: PItemIDList;
  APidls: PPidlList;
  ALock: THandle;
begin
  ALock := SHChangeNotification_Lock(Message.WParam, Message.LParam, APidls, AEventID);
  if ALock <> 0 then
  begin
    try
      APidl1 := GetPidlCopy(APidls^[0]);
      APidl2 := GetPidlCopy(APidls^[1]);
    finally
      SHChangeNotification_UnLock(ALock);
    end;
    if (FEventProcessingCount > 0) or FIsContextPopupProcessing or (FLockChange > 0) or FIsUpdating or (FDragSource <> nil) then
      AddDefferedShellSystemEvent(AEventID, APidl1, APidl2)
    else
    begin
      Inc(FEventProcessingCount);
      try
        DoProcessSystemShellChange(AEventID, APidl1, APidl2);
      finally
        DisposePidl(APidl1);
        DisposePidl(APidl2);
        Dec(FEventProcessingCount);
      end;
      ProcessDefferedShellSystemEvents;
    end;
  end;
end;

function TdxCustomShellTreeView.GetNodeClass: TdxTreeViewNodeClass;
begin
  Result := TdxShellTreeViewNode;
end;

procedure TdxCustomShellTreeView.InplaceEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not IsValidShellNameChar(Key) then
    Key := #0;
end;

procedure TdxCustomShellTreeView.ProcessDragAndDropOnMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  function CanStartDragAndDrop(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
  begin
    Result := OptionsBehavior.AllowDragDrop;
    if Result then
    begin
      CalculateHitTest(X, Y);
      Result := HitTest.HitAtSelection and not HitTest.HitAtExpandButton;
    end;
  end;

begin
  if CanStartDragAndDrop(Button, Shift, X, Y) then
    FShellDragDropState := ddsStarting
  else
    inherited ProcessDragAndDropOnMouseDown(Button, Shift, X, Y);
end;

procedure TdxCustomShellTreeView.ProcessDragAndDropOnMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if (FShellDragDropState = ddsStarting) and not IsMouseInPressedArea(X, Y) then
  begin
    FShellDragDropState := ddsInProcess;
    DoBeginDrag;
    FShellDragDropState := ddsNone;
  end
  else
    inherited ProcessDragAndDropOnMouseMove(Shift, X, Y);
end;

function TdxCustomShellTreeView.ShowFirstLevelNodes: Boolean;
begin
  Result := FFirstLevelNodesVisible;
end;

procedure TdxCustomShellTreeView.ShowInplaceEdit(ANode: TdxTreeViewNode; const ABounds: TRect; const AText: string; AFont: TFont; ASelStart, ASelLength: Integer; AMaxLength: Integer);
var
  AFolder: TcxShellFolder;
  ASelCount: Integer;
  S: string;
begin
  AFolder := GetShellItemInfo(ANode).Folder;
  S := AFolder.EditingName;
  if AFolder.IsFolder and not AFolder.IsZip then
    ASelCount := MaxInt
  else
    ASelCount := Length(TPath.GetFileNameWithoutExtension(AFolder.PathName));
  inherited ShowInplaceEdit(ANode, ABounds, S, AFont, 0, ASelCount, MAX_PATH);
end;

procedure TdxCustomShellTreeView.ValidatePasteText(var AText: string);
begin
  CheckShellItemDisplayName(AText);
end;

procedure TdxCustomShellTreeView.ViewPortChanged;
begin
  inherited ViewPortChanged;
  UpdateVisibleItems;
end;

{ TdxShellTreeView }

function TdxShellTreeView.GetFolder(AIndex: Integer): TcxShellFolder;
var
  ANode: TdxTreeViewNode;
  AItemInfo: TcxShellItemInfo;
begin
  Result := nil;
  ANode := AbsoluteItems[AIndex];
  if IsShellRootNode(ANode) then
    Result := ShellRoot.Folder
  else
  begin
    AItemInfo := GetShellItemInfo(ANode);
    if AItemInfo <> nil then
      Result := AItemInfo.Folder;
  end;
end;

function TdxShellTreeView.GetFolderCount: Integer;
begin
  Result := AbsoluteCount;
end;

function TdxShellTreeView.GetDefaultHeight: Integer;
begin
  Result := dxDefaultHeight;
end;

function TdxShellTreeView.GetDefaultWidth: Integer;
begin
  Result := dxDefaultWidth;
end;

{ TdxShellListViewItemProducer }

constructor TdxShellListViewItemProducer.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  FEnumeratedPidls := TdxFastList.Create;
  FEnumeratingItemPidls := TdxFastThreadList.Create;
end;

procedure TdxShellListViewItemProducer.ProcessDetails(ShellFolder: IShellFolder; CharWidth: Integer);
begin
  inherited ProcessDetails(ShellFolder, 10); 
  ListView.DoCreateColumns;
end;

procedure TdxShellListViewItemProducer.ProcessItems(AIFolder: IShellFolder; AFolderPIDL: PItemIDList;
  APreloadItemCount: Integer);
begin
  CheckThumbnails;
  inherited ProcessItems(AIFolder, AFolderPIDL, APreloadItemCount);
end;


function GetPreviewPaintBounds(const ABounds: TRect; AImageWidth, AImageHeight: Integer;
  const AMargins: TRect; AKeepAspectRatio: Boolean): TRect;
var
  AWidth, AHeight: Integer;
begin
  if ABounds.IsEmpty then
    Exit(TRect.Null);
  AWidth := ABounds.Width;
  AHeight := ABounds.Height;
  Inc(AImageWidth, AMargins.Left + AMargins.Right);
  Inc(AImageHeight, AMargins.Top + AMargins.Bottom);
  if (AWidth >= AImageWidth) and (AHeight >= AImageHeight) then
  begin
    Result.InitSize(
      ABounds.Left + (AWidth - AImageWidth) div 2,
      ABounds.Top + (AHeight - AImageHeight) div 2,
      AImageWidth, AImageHeight);
  end
  else
  begin
    if AKeepAspectRatio then
    begin
      Result := cxRectProportionalStretch(ABounds, AImageWidth, AImageHeight);
      Result := cxRectCenter(ABounds, Result.Width, Result.Height);
    end
    else
    begin
      AImageWidth := Min(AWidth, AImageWidth);
      AImageHeight := Min(AHeight, AImageHeight);
      Result.InitSize(
        ABounds.Left + (AWidth - AImageWidth) div 2,
        ABounds.Top + (AHeight - AImageHeight) div 2,
        AImageWidth, AImageHeight);
    end;
  end;
end;

function TdxShellListViewItemProducer.AddThumbnailToImageList(AItem: TcxShellItemInfo; AHBitmap: HBITMAP; const ARequiredSize: TSize): Integer;
var
  ABitmap: TcxBitmap32;
  ARect, APaintRect: TRect;
  AImage: TdxGPImage;
  AThumbnailAdornment: TdxThumbnailAdornmentKind;
begin
  AImage := TdxGPImage.CreateFromHBitmap(AHBitmap);
  try
    ARect.InitSize(ARequiredSize);
    AThumbnailAdornment := TdxThumbnailAdornmentHelper.GetAdornmentKind(TPath.GetExtension(AItem.Folder.PathName));
    APaintRect := GetPreviewPaintBounds(ARect, AImage.Width, AImage.Height,
      TdxThumbnailAdornmentHelper.GetAdornmentMargins(AThumbnailAdornment), True);
    ABitmap := TcxBitmap32.CreateSize(ARequiredSize);
    try
      ABitmap.Canvas.Lock;
      try
        ABitmap.Clear;
        TdxThumbnailAdornmentHelper.DrawAdornment(ABitmap.Canvas.Handle, APaintRect,
          AThumbnailAdornment, nil,
          procedure (DC: HDC; ABounds: TRect)
          var
            ACanvas: TdxGPCanvas;
          begin
            ACanvas := TdxGPCanvas.Create(DC);
            try
              ACanvas.Draw(AImage, ABounds, AImage.ClientRect);
            finally
              ACanvas.Free;
            end;
          end);
      finally
        ABitmap.Canvas.Unlock;
      end;

      Result := ImageList_Add(FThumbnails, ABitmap.Handle, 0);
    finally
      ABitmap.Free;
    end;
  finally
    AImage.Free;
  end;
end;

function TdxShellListViewItemProducer.CanAddFolder(AFolder: TcxShellFolder): Boolean;
begin
  Result := ListView.DoAddFolder(AFolder);
end;

function TdxShellListViewItemProducer.CanCancelTask: Boolean;
begin
  Result := True;
end;

procedure TdxShellListViewItemProducer.CancelSortingTask;
var
  APreviousSortingTaskHandle: THandle;
begin
  FIsSortingCompleted := False;
  if FSortingItemsTaskHandle <> 0 then
  begin
    APreviousSortingTaskHandle := FSortingItemsTaskHandle;
    FSortingItemsTaskHandle := 0;
    dxTasksDispatcher.Cancel(APreviousSortingTaskHandle, True);
  end;
end;

function TdxShellListViewItemProducer.DoCompareItems(AItem1, AItem2: TcxShellFolder;
  out ACompare: Integer): Boolean;
begin
  Result := ListView.DoCompare(AItem1, AItem2, ACompare);
end;

function TdxShellListViewItemProducer.GetEnumFlags: Cardinal;
begin
  Result := ListView.ShellOptions.GetEnumFlags;
  if ListView.ShellOptions.TrackShellChanges then
    Result := Result or SHCONTF_ENABLE_ASYNC;
end;

function TdxShellListViewItemProducer.GetFolderForEnumeration: IShellFolder;
begin
  if not Succeeded(GetDesktopIShellFolder.BindToObject(FolderPidl, nil, IShellFolder, Result)) then
    Result := inherited GetFolderForEnumeration; 
end;

function TdxShellListViewItemProducer.GetItemsInfoGatherer: TcxShellItemsInfoGatherer;
begin
  Result := ListView.ItemsInfoGatherer;
end;

function TdxShellListViewItemProducer.GetShowToolTip: Boolean;
begin
  Result := ListView.ShellOptions.ShowToolTip;
end;

function TdxShellListViewItemProducer.IsSortSupported: Boolean;
begin
  Result := not IsQuickAccess;
end;

procedure TdxShellListViewItemProducer.RecreateListItems;
begin
  SetItemsCount(Items.Count);
end;

function TdxShellListViewItemProducer.SlowInitializationDone(AItem: TcxShellItemInfo): Boolean;
begin
  Result := (not ListView.IsThumbnailView or AItem.ThumbnailUpdated) and AItem.Updated;
end;

procedure TdxShellListViewItemProducer.CheckEnumeration;
const
  MaxItemsCount = 500000;
var
  AList: TdxFastList;
  ANeedItemsSetCount: Boolean;
  AIsEnumeratingTaskCompleted: Boolean;
  AAddingTickCount: Cardinal;
begin
  if FIsPopulating and not FIsCheckingEnumeration then
  begin
    FIsCheckingEnumeration := True;
    try
      ANeedItemsSetCount := False;
      AIsEnumeratingTaskCompleted := FEnumeratingItemsTaskHandle = 0;
      AList := FEnumeratingItemPidls.LockList;
      try
        if AList.Count > 0 then
        begin
          FEnumeratedPidls.AddRange(AList); 
          AList.Clear;
        end;
      finally
        FEnumeratingItemPidls.UnlockList;
      end;

      AAddingTickCount := GetTickCount;
      while (FEnumeratedPidls.Count > 0) and ((GetTickCount - AAddingTickCount) < 64) do
      begin
        if not FIsItemsStoreFull then
        begin
          ANeedItemsSetCount := True;
          InternalAddItem(FEnumeratedPidls[0]);
        end;
        FEnumeratedPidls.Delete(0);
        if Items.Count >= MaxItemsCount then
          FIsItemsStoreFull := True;
      end;

      if AIsEnumeratingTaskCompleted and (FEnumeratedPidls.Count = 0) then
      begin
        FIsPopulatingCompleted := True;
        FIsPopulating := False;
        ANeedItemsSetCount := True;
        ListView.UpdateEmptyText;
        if not Assigned(ListView.OnCompare) then
          Sort;
      end;

      if ANeedItemsSetCount then
      begin
        RecreateListItems;
        ListView.Update;
        if FIsPopulatingCompleted then
        begin
          ListView.ItemsPopulated;
          if Assigned(ListView.OnCompare) then
            Sort;
          ListView.ClearFocusAndSelection;
          ListView.RestoreEditingItem;
        end;
      end;
    finally
      FIsCheckingEnumeration := False;
    end;
  end;
end;

procedure TdxShellListViewItemProducer.CheckThumbnails;
begin
  if ListView.IsThumbnailView then
  begin
    ListView.ImageOptions.LargeImages.Clear;
    FThumbnails := ListView.ImageOptions.LargeImages.Handle;
    ListView.InvalidateImageList;
  end;
end;

procedure TdxShellListViewItemProducer.ClearFetchQueue;
begin
  if ItemsInfoGatherer <> nil then
    ItemsInfoGatherer.ClearFetchQueue(nil);
end;

procedure TdxShellListViewItemProducer.ClearItems;
var
  AList: TdxFastList;
  I: Integer;
  ATaskHandle: THandle;
begin
  FIsPopulating := False;
  CancelSortingTask;
  if FEnumeratingItemsTaskHandle <> 0 then
  begin
    ATaskHandle := FEnumeratingItemsTaskHandle;
    FEnumeratingItemsTaskHandle := 0;
    dxTasksDispatcher.Cancel(ATaskHandle, IfThen(not IsWin8OrLater and IsSearchFolder, 1000, INFINITE));
  end;
  for I := 0 to FEnumeratedPidls.Count - 1 do
    DisposePidl(FEnumeratedPidls[I]);
  FEnumeratedPidls.Clear;
  AList := FEnumeratingItemPidls.LockList;
  try
    for I := 0 to AList.Count - 1 do
      DisposePidl(AList[I]);
    AList.Clear;
  finally
    FEnumeratingItemPidls.UnlockList;
  end;
  inherited ClearItems;
end;

function TdxShellListViewItemProducer.CreateTask(AItem: TcxShellItemInfo): TdxShellItemTask;
begin
  Result := TdxShellListViewItemTask.Create(AItem);
end;

procedure TdxShellListViewItemProducer.DoDestroy;
var
  AList: TdxFastList;
begin
  FIsDestroying := True;
  inherited DoDestroy;
  AList := FEnumeratingItemPidls.LockList; 
  try
    dxTestCheck(AList.Count = 0, 'TdxShellListViewItemProducer.DoDestroy: AList.Count > 0');
  finally
    FEnumeratingItemPidls.UnlockList;
  end;
  FreeAndNil(FEnumeratingItemPidls);
  FreeAndNil(FEnumeratedPidls);
  dxTestCheck(FSortingItems = nil, 'FSortingItems <> nil on TdxShellListViewItemProducer.DoDestroy');
end;

procedure TdxShellListViewItemProducer.DoSort;
var
  ATask: TdxShellListSortItemsTask;
begin
  dxTestCheck(not FIsDestroying, 'call sorting on destroying');
  CancelSortingTask;
  if Assigned(ListView.OnCompare) then
  begin
    try
      inherited DoSort;
    finally
      FIsSortingCompleted := True;
      ListView.SortCompleted;
    end;
  end
  else
  begin
    ATask := TdxShellListSortItemsTask.Create(Self);
    FSortingItemsTaskHandle := dxTasksDispatcher.Run(ATask, ItemSortCompleted, tmcmSync);
  end;
end;

procedure TdxShellListViewItemProducer.FetchItems(APreloadItems: Integer);
var
  ATask: TdxShellListViewEnumerateItemsTask;
begin
  ATask := TdxShellListViewEnumerateItemsTask.Create(Self);
  FIsItemsStoreFull := False;
  FIsPopulatingCompleted := False;
  FIsSortingCompleted := False;
  FIsPopulating := True;
  ListView.UpdateEmptyText;
  FEnumeratingItemsTaskHandle := dxTasksDispatcher.Run(ATask, ItemEnumerationCompleted, tmcmSync);
end;

function TdxShellListViewItemProducer.GetListView: TdxCustomShellListView;
begin
  Result := TdxCustomShellListView(Owner);
end;

procedure TdxShellListViewItemProducer.ItemEnumerationCompleted;
begin
  FEnumeratingItemsTaskHandle := 0;
end;

procedure TdxShellListViewItemProducer.ItemImageUpdated(AItem: TcxShellItemInfo);
begin
  if (AItem.IconIndex > ListView.ImageOptions.SmallImages.Count - 1) or (AItem.OpenIconIndex > ListView.ImageOptions.SmallImages.Count - 1) then
    ListView.UpdateImages;
end;

procedure TdxShellListViewItemProducer.ItemSortCompleted;
begin
  if FSortingItemsTaskHandle = 0 then
  begin
    FreeAndNil(FSortingItems);
    Exit;
  end;
  FSortingItemsTaskHandle := 0;
  ListView.StoreEditingItem;
  try
    ListView.BeginUpdate;
    try
      ListView.StoreFocusAndSelection;
      Items.Assign(FSortingItems);
      FreeAndNil(FSortingItems);
      ListView.RestoreFocusAndSelection;
      ListView.ClearFocusAndSelection;
    finally
      ListView.EndUpdate;
    end;
  finally
    ListView.RestoreEditingItem;
  end;
  FIsSortingCompleted := True;
  ListView.SortCompleted;
end;

procedure TdxShellListViewItemProducer.SetItemsCount(ACount: Integer);
begin
  ListView.DoSetItemCount(ACount);
end;

{ TdxShellListViewContextMenu }

constructor TdxShellListViewContextMenu.Create(AListView: TdxCustomShellListView);
begin
  inherited Create;
  FListView := AListView;
end;

procedure TdxShellListViewContextMenu.ExecuteMenuItemCommand(ACommandId: Cardinal);
begin
  if (ACommandId = 218) and IsSameCommand(ACommandId, 'rename'#0) then
    FListView.SelectedItems[0].EditCaption
  else
  begin
    inherited ExecuteMenuItemCommand(ACommandId);
    if (ACommandId = 224) and IsSameCommand(ACommandId, 'cut'#0) then
      FListView.CutSelectedItems
    else
      if (ACommandId = 226) and IsSameCommand(ACommandId, 'paste'#0) then
        FListView.ClearCutItems
      else
        if not FListView.ShellOptions.TrackShellChanges and
          IsSameCommand(ACommandId, 'delete'#0) then
          FListView.UpdateContent;
  end;
end;

function TdxShellListViewContextMenu.GetContextMenuQueryFlags: Cardinal;
begin
  Result := inherited GetContextMenuQueryFlags;
  if FListView.SelectedItemCount = 1 then
    Result := Result or CMF_CANRENAME;
end;

function TdxShellListViewContextMenu.GetWindowHandle: THandle;
begin
  Result := FListView.Handle;
end;

procedure TdxShellListViewContextMenu.Populate;
var
  AItemPIDLList: TList;
begin
  AItemPIDLList := FListView.CreateSelectedPidlsList;
  try
    AddDefaultShellItems(FListView.ItemProducer.ShellFolder, AItemPIDLList);
  finally
    FListView.DestroySelectedPidlsList(AItemPIDLList);
  end;
end;

{ TdxShellListViewCurrentFolderContextMenu }

const
  cmdExtraLargeIconId = 1;
  cmdLargeIconId = 2;
  cmdIconId = 3;
  cmdSmallIconId = 4;
  cmdListId = 5;
  cmdDetailId = 6;
  cmdRefreshId = 7;
  cmdAscendingId = 8;
  cmdDescendingId = 9;
  cmdPasteId = 10;
  cmdLastId = cmdPasteId;

procedure TdxShellListViewCurrentFolderContextMenu.ExecuteMenuItemCommand(ACommandId: Cardinal);
begin
  case ACommandId of
    cmdExtraLargeIconId..cmdDetailId:
    begin
      ListView.ChangeView(ACommandId);
      ListView.DoViewChanged;
    end;
    cmdRefreshId:
      ListView.UpdateContent;
    cmdDescendingId:
      begin
        ListView.Sort(ListView.GetSortColumnIndex, False);
        ListView.DoSortColumnChanged;
      end;
    cmdAscendingId:
      begin
        ListView.Sort(ListView.GetSortColumnIndex, True);
        ListView.DoSortColumnChanged;
      end;
    cmdPasteId:
      ListView.PasteFromClipboard;
  else
    if (ACommandId > cmdLastId) and (ACommandId <= FLastSortColumnIndexCommandId) then
    begin
      ListView.Sort(ACommandId - cmdLastId - 1, ListView.ItemProducer.SortDescending);
      ListView.DoSortColumnChanged;
    end
    else
    begin
      ListView.FIsInternalNewItemCreation := True;
      try
        inherited ExecuteMenuItemCommand(ACommandId);
      finally
        ListView.FIsInternalNewItemCreation := False;
      end;
    end;
  end;
end;

procedure TdxShellListViewCurrentFolderContextMenu.Populate;

  function GetCheckedIconSizeMenuItemIndex: Integer;
  begin
    Result := ListView.GetCurrentViewId;
    Dec(Result);
  end;

const
  AIconSizeMenuItemsCount = 6;
  ASortDirectionMenuItemIndex: array [Boolean] of Integer = (0, 1);
var
  AViewSubmenu: HMENU;
  I: Integer;
  ASortColumnMenuItemCaptions: array of string;
  ASortDirectionMenuItemCaptions: array [0..1] of string;
  AViewMenuItemCaptions: array [0..AIconSizeMenuItemsCount - 1] of string;
  ALibraryHandle: THandle;
  APasteMenuItemCaption: string;
begin
  ALibraryHandle := LoadLibraryEx('shell32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    AViewSubmenu := AddSubitem(dxGetLocalizedSystemResourceString(sdxShellViewsCaption, ALibraryHandle,
      IfThen(IsWinSevenOrLater, 31145, 33585)), 0);
    for I := 0 to Length(AViewMenuItemCaptions) - 1 do
      if IsWinSevenOrLater or not ((I + 1) in [cmdExtraLargeIconId, cmdSmallIconId]) then
        AViewMenuItemCaptions[I] := ListView.GetViewCaption(I + 1, ALibraryHandle);
    APasteMenuItemCaption := dxGetLocalizedSystemResourceString(sdxShellListViewMenuItemPaste, ALibraryHandle, 33562);
  finally
    FreeLibrary(ALibraryHandle);
  end;
  AddRadioGroup(AViewMenuItemCaptions, cmdExtraLargeIconId, 0, GetCheckedIconSizeMenuItemIndex, AViewSubmenu);
  if ListView.Sorting and ListView.CanSort then
  begin
    SetLength(ASortColumnMenuItemCaptions, ListView.Columns.Count);
    for I := 0 to ListView.Columns.Count - 1 do
      ASortColumnMenuItemCaptions[I] := ListView.Columns[I].Caption;
    AViewSubmenu := AddSubitem(cxGetResourceString(@sdxShellListViewMenuItemSort), 0); 
    AddRadioGroup(ASortColumnMenuItemCaptions, cmdLastId + 1, 0, ListView.GetSortColumnIndex, AViewSubmenu);
    AddSeparator(AViewSubmenu);
    ASortDirectionMenuItemCaptions[0] := cxGetResourceString(@sdxShellListViewMenuItemSortAscending); 
    ASortDirectionMenuItemCaptions[1] := cxGetResourceString(@sdxShellListViewMenuItemSortDescending); 
    AddRadioGroup(ASortDirectionMenuItemCaptions, cmdAscendingId, Length(ASortColumnMenuItemCaptions) + 1,
      ASortDirectionMenuItemIndex[ListView.ItemProducer.SortDescending], AViewSubmenu);
    FLastSortColumnIndexCommandId := cmdLastId + Length(ASortColumnMenuItemCaptions);
  end
  else
    FLastSortColumnIndexCommandId := 0;
  AddItem(cxGetResourceString(@sdxShellListViewMenuItemRefresh), cmdRefreshId); 
  AddSeparator;
  AddItem(APasteMenuItemCaption, cmdPasteId, Clipboard.HasFormat(CF_HDROP));
  AddDefaultShellItems(FListView.ItemProducer.ShellFolder);
end;

procedure TdxShellListViewCurrentFolderContextMenu.AddCheckItem(const ACaption: string;
  AId: Cardinal; AIsChecked: Boolean; AIsEnabled: Boolean = True; AMenu: HMenu = 0);
begin
  if AMenu = 0 then
    AMenu := Menu;
  AppendMenu(AMenu, IfThen(AIsEnabled, MF_ENABLED, MF_DISABLED) or MF_STRING or
    IfThen(AIsChecked, MFS_CHECKED, MFS_UNCHECKED), AId, PChar(ACaption));
end;

procedure TdxShellListViewCurrentFolderContextMenu.AddItem(const ACaption: string;
  AId: Cardinal; AIsEnabled: Boolean = True; AMenu: HMenu = 0);
begin
  AddCheckItem(ACaption, AId, False, AIsEnabled, AMenu);
end;

procedure TdxShellListViewCurrentFolderContextMenu.AddRadioGroup(AItems: array of string;
  AStartId, AStartPos: Cardinal; AItemIndex: Integer; AMenu: HMenu = 0);
var
  I: Integer;
  AMenuItemInfo: TMenuItemInfo;
begin
  if AMenu = 0 then
    AMenu := Menu;
  for I := 0 to High(AItems) do
  begin
    if AItems[I] = '' then
      Continue;
    cxZeroMemory(@AMenuItemInfo, SizeOf(AMenuItemInfo));
    AMenuItemInfo.cbSize := SizeOf(AMenuItemInfo);
    AMenuItemInfo.fMask := MIIM_FTYPE or MIIM_STATE or MIIM_STRING or MIIM_ID;
    AMenuItemInfo.fType := MFT_RADIOCHECK;
    AMenuItemInfo.fState := IfThen(I = AItemIndex, MFS_CHECKED, MFS_UNCHECKED);
    AMenuItemInfo.dwTypeData := PChar(AItems[I]);
    AMenuItemInfo.wID := AStartId + Cardinal(I);
    InsertMenuItem(AMenu, AStartPos + Cardinal(I), True, AMenuItemInfo);
  end;
end;

procedure TdxShellListViewCurrentFolderContextMenu.AddSeparator(AMenu: HMenu = 0);
begin
  if AMenu = 0 then
    AMenu := Menu;
  AppendMenu(AMenu, MF_SEPARATOR, 0, nil);
end;

function TdxShellListViewCurrentFolderContextMenu.AddSubitem(
  const ACaption: string; AMenu: HMenu): HMenu;
begin
  Result := CreatePopupMenu;
  if AMenu = 0 then
    AMenu := Menu;
  AppendMenu(AMenu, MF_ENABLED or MF_STRING or MF_POPUP, Result, PChar(ACaption));
end;

function TdxShellListViewCurrentFolderContextMenu.GetSite: IUnknown;
begin
  Result := ListView.GetContextMenuSite;
end;

{ TdxShellListViewOptions }

constructor TdxShellListViewOptions.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  FShowReadOnly := True;
end;

procedure TdxShellListViewOptions.DoAssign(Source: TcxShellOptions);
begin
  inherited DoAssign(Source);
  if Source is TdxShellListViewOptions then
    ShowReadOnly := TdxShellListViewOptions(Source).ShowReadOnly;
end;

procedure TdxShellListViewOptions.SetShowReadOnly(const Value: Boolean);
begin
  FShowReadOnly := Value;
  NotifyUpdateContents;
end;

{ TdxShellListItemViewInfo }

procedure TdxShellListItemViewInfo.DrawGlyph(ACanvas: TcxCustomCanvas);

  procedure InternalDrawIcon(ACanvas: TcxCustomCanvas; AShellItem: TcxShellItemInfo);
  var
    R: TRect;
  begin
    R := cxRectCenter(GlyphBounds, dxGetImageSize(ShellListView.LargeImages, ScaleFactor));
    if IsWinXP then
      ACanvas.FrameRect(GlyphBounds, clBtnFace);
    DrawGlyphCore(ACanvas, R, ShellListView.LargeImages, AShellItem.IconIndex, -1, GetGlyphState, GetGlyphAlpha, GetColorPalette);
  end;

var
  AShellItem: TcxShellItemInfo;
begin
  if ShellListView.IsThumbnailView then
  begin
    AShellItem := ShellListView.GetItemInfo(ItemIndex);
    if AShellItem.HasThumbnail then
      inherited DrawGlyph(ACanvas)
    else
      InternalDrawIcon(ACanvas, AShellItem);
    if not TdxShellListViewItemProducer(AShellItem.ItemProducer).IsFavorites then
      TThumbnailOverlayImageHelper(ShellListView.ThumbnailOverlayImageHelper).Draw(ACanvas, GlyphBounds, AShellItem.OverlayIndex);
  end
  else
    inherited DrawGlyph(ACanvas);
end;

function TdxShellListItemViewInfo.GetHintText: string;
begin
  if TextLayout.IsTruncated then
    Result := Text
  else
    Result := '';
  ShellListView.DoInfoTip(ShellListView.GetItem(ItemIndex), Result);
end;

function TdxShellListItemViewInfo.GetShellListView: TdxCustomShellListView;
begin
  Result := ListView as TdxCustomShellListView;
end;

function TdxShellListItemViewInfo.NeedShowHint: Boolean;
begin
  Result := ShellListView.ShellOptions.ShowToolTip;
end;

{ TdxShellListItemReportStyleViewInfo }

function TdxShellListItemReportStyleViewInfo.GetHintText: string;
begin
  if TextLayout.IsTruncated then
    Result := Text
  else
    Result := '';
  ShellListView.DoInfoTip(ShellListView.GetItem(ItemIndex), Result);
end;

function TdxShellListItemReportStyleViewInfo.GetShellListView: TdxCustomShellListView;
begin
  Result := ListView as TdxCustomShellListView;
end;

function TdxShellListItemReportStyleViewInfo.NeedShowHint: Boolean;
begin
  Result := ShellListView.ShellOptions.ShowToolTip;
end;

{ TdxShellListViewViewInfo }

function TdxShellListViewViewInfo.CreateItemViewInfo(AOwner: TdxListGroupCustomViewInfo; AItemIndex: Integer): TdxListItemCustomViewInfo;
begin
  if IsReportView then
    Result := TdxShellListItemReportStyleViewInfo.Create(AOwner, AItemIndex, ItemViewParams)
  else
    Result := TdxShellListItemViewInfo.Create(AOwner, AItemIndex, ItemViewParams);
end;

function TdxShellListViewViewInfo.GetIconsGlyphSideGap: Integer;
begin
  Result := 11;
end;

{ TdxShellListViewColumn }

constructor TdxShellListViewColumn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComponentStyle := [csTransient];
end;

{ TdxShellListViewController }

function TdxShellListViewController.CanSelectColumnInDesigner: Boolean;
begin
  Result := False;
end;

function TdxShellListViewController.NeedToRestoreSingleItemSelection(AShift: TShiftState): Boolean;
begin
  Result := inherited NeedToRestoreSingleItemSelection(AShift) and not (ssDouble in AShift);
end;

procedure TdxShellListViewController.SelectAll;
var
  I: Integer;
begin
  BeginSelectionChanged;
  try
    ListView.BeginUpdate;
    try
      for I := 0 to ListView.Items.Count - 1 do
        SelectItem(I, True);
    finally
      ListView.EndUpdate;
    end;
  finally
    EndSelectionChanged;
  end;
end;

procedure TdxShellListViewController.KeyDown(AKey: Word; AShift: TShiftState);
begin
  inherited KeyDown(AKey, AShift);
  case AKey of
    Ord('A'):
      if AShift = [ssCtrl] then
        SelectAll;
  end;
end;

{ TdxCustomShellListView }

constructor TdxCustomShellListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShellDependedControls := TcxShellDependedControls.Create;
  FDefferedShellSystemEvents := TList<TdxShellSystemEventInfo>.Create;
  FGroupIndex := -1;
  FLoadedGroupIndex := -1;
  FNavigateFolderLinks := True;
  FFirstUpdateItem := -1;
  FDropTargetItemIndex := -1;
  FLargeImages := TcxSystemImageList.Create(nil);
  FLargeImages.ShareImages := True;
  FFakeThumbnailImages := TcxSystemImageList.Create(nil);
  CheckLargeImages;
  FInternalSmallImages := TdxShellSmallImageList.Create(Self);
  ImageOptions.ScaleOnDPIChanges := False;
  ImageOptions.SmallImages := FInternalSmallImages;
  FItemProducer := TdxShellListViewItemProducer.Create(Self);
  FItemsInfoGatherer := TcxShellItemsInfoGatherer.Create(Self);
  FLastUpdateItem := -1;
  FShellOptions := TdxShellListViewOptions.Create(Self);
  FThumbnailOptions := TcxShellThumbnailOptions.Create(Self);
  TcxShellThumbnailOptionsAccess(FThumbnailOptions).OnChange := ThumbnailOptionsChanged;
  FShellRoot := TdxShellListViewRoot.Create(Self, 0);
  FShellRoot.OnFolderChanged := RootFolderChanged;
  FShellRoot.OnSettingsChanged := RootSettingsChanged;
  FAllowDragDrop := True;
  DoubleBuffered := True;
  ImageOptions.LargeImages := FLargeImages;
  OwnerData := True;

  //visual settings
  ExplorerStyle := True;
  ViewStyleReport.AlwaysShowItemImageInFirstColumn := True;
  ViewStyleReport.RowSelect := True;

  FAppEvents := TApplicationEvents.Create(nil);
  FAppEvents.OnIdle := DoOnIdle;

  FSelectedFiles := TStringList.Create;
  ParentFont := True;
  FThumbnailOverlayImageHelper := TThumbnailOverlayImageHelper.Create;
  InitializeLocalizableSources;
  ViewStyleChanged;
end;

destructor TdxCustomShellListView.Destroy;
begin
  TdxUIThreadSyncService.Unsubscribe(Self);
  DragLeave; // #Ch needed to avoid freezing for external drag source (e.g. esc on Dialog while dragging from WinExplorer)
  FreeAndNil(FThumbnailOverlayImageHelper);
  DestroySelectedPidlsList(FCutItemsPIDLList);
  dxFreeAndNilPidl(FStoredEditingItemPidl);
  ClearFocusAndSelection;
  FreeAndNil(FSelectedFiles);
  FreeAndNil(FAppEvents);
  RemoveChangeNotification;
  FreeAndNil(FItemProducer);
  FreeAndNil(FItemsInfoGatherer);
  FreeAndNil(FShellRoot);
  FreeAndNil(FShellOptions);
  FreeAndNil(FThumbnailOptions);
  FreeAndNil(FInternalSmallImages);
  FreeAndNil(FFakeThumbnailImages);
  FreeAndNil(FLargeImages);
  FreeAndNil(FDefferedShellSystemEvents);
  FreeAndNil(FShellDependedControls);
  inherited Destroy;
end;

procedure TdxCustomShellListView.BrowseParent;
var
  APIDL: PItemIDList;
begin
  APIDL := GetPidlParent(ItemProducer.FolderPidl);
  try
    Navigate(APIDL);
  finally
    DisposePidl(APIDL);
  end;
end;

procedure TdxCustomShellListView.Sort;
begin
  if FItemProducer.IsPopulatingCompleted then
    ItemProducer.Sort;
end;

procedure TdxCustomShellListView.Sort(AColumnIndex: Integer; AIsAscending: Boolean);
var
  AColumnID: Integer;
begin
  AColumnID := GetColumnID(AColumnIndex);
  if (AColumnID <> ItemProducer.SortColumn) or (ItemProducer.SortDescending xor not AIsAscending) then
  begin
    ItemProducer.SortColumn := AColumnID;
    ItemProducer.SortDescending := not AIsAscending;
    SortColumnChanged;
  end;
end;

procedure TdxCustomShellListView.UpdateContent;
begin
  if (FEventProcessingCount > 0) or FIsContextPopupProcessing then
    AddDefferedUpdateContent
  else
  begin
    if not ItemProducer.IsPopulating then
    begin
      StoreFocusAndSelection;
      StoreScrollPosition;
    end;
    CheckUpdateItems;
  end;
end;

procedure TdxCustomShellListView.AssignFromCxShellListView(ASource: TcxShellListView);
begin
  BeginUpdate;
  try
    AllowDragDrop := ASource.DragDropSettings.AllowDragObjects;
    ViewStyleIcon.IconSize := ASource.IconOptions.Size;
    case ASource.IconOptions.Arrangement of
      iaTop: ViewStyleIcon.Arrangement := TdxListIconsArrangement.Horizontal;
      iaLeft: ViewStyleIcon.Arrangement := TdxListIconsArrangement.Vertical;
    end;
    if ASource.IconOptions.WrapText then
      ViewStyleIcon.TextLineCount := 2
    else
      ViewStyleIcon.TextLineCount := 1;
    ViewStyleReport.ShowColumnHeaders := ASource.ShowColumnHeaders;
    ShellOptions.Assign(ASource.Options);
    MultiSelect := ASource.MultiSelect;
    Sorting := ASource.Sorting;
    ReadOnly := ASource.ReadOnly;
    ThumbnailOptions.Assign(ASource.ThumbnailOptions);
    case ASource.ViewStyle of
      TViewStyle.vsReport: ViewStyle := TdxListViewStyle.Report;
      TViewStyle.vsIcon: ViewStyle := TdxListViewStyle.Icon;
      TViewStyle.vsSmallIcon: ViewStyle := TdxListViewStyle.SmallIcon;
      TViewStyle.vsList: ViewStyle := TdxListViewStyle.List;
    end;
    ShellRoot.Assign(ASource.Root);
  finally
    EndUpdate;
  end;
end;


function TdxCustomShellListView.CanEdit(AItem: TdxListItem): Boolean;
begin
  Result := True;
  if AItem = nil then
    Exit;
  if AItem.Index > ItemProducer.Items.Count - 1 then
  begin
    Result := False;
    Exit;
  end;
  Result := GetItemInfo(AItem.Index).CanRename and inherited CanEdit(AItem);
end;

function TdxCustomShellListView.CreateController: TdxListViewController;
begin
  Result := TdxShellListViewController.Create(Self);
end;

function TdxCustomShellListView.CreateHintHelper: TdxListViewHintHelper;
begin
  Result := TdxShellListViewHintHelper.Create(Self);
end;

function TdxCustomShellListView.CreateIconOptions: TdxListViewIconOptions;
begin
  Result := TdxShellListViewIconOptions.Create(Self);
end;

function TdxCustomShellListView.CreateReportOptions: TdxListViewReportOptions;
begin
  Result := TdxCustomShellListViewReportOptions.Create(Self);
end;

function TdxCustomShellListView.CreateViewInfo: TdxListViewViewInfo;
begin
  Result := TdxShellListViewViewInfo.Create(Self);
end;

procedure TdxCustomShellListView.DblClick;
var
  AItemViewInfo: TdxListItemCustomViewInfo;
  AMousePos: TPoint;
begin
  AMousePos := GetMouseCursorClientPos;
  if ViewInfo.GetItemAtPos(AMousePos, AItemViewInfo) then
  begin
    if AItemViewInfo.GetHitTest(AMousePos) <> TdxListItemHitTest.StateGlyph then
      DoItemDblClick(AItemViewInfo.ItemIndex);
  end;
  inherited DblClick;
end;

procedure TdxCustomShellListView.DestroyWnd;
begin
  if not IsDesigning then
  begin
    dxTestCheck(Succeeded(RevokeDragDrop(Handle)), 'RevokeDragDrop - dxShellListView');
    RemoveChangeNotification;
  end;
  inherited DestroyWnd;
end;

procedure TdxCustomShellListView.DoChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  inherited DoChangeScaleEx(M, D, isDpiChange);
  FInternalSmallImages.ScaleChanged(ScaleFactor);
  ThumbnailOptionsChanged(nil);
end;

procedure TdxCustomShellListView.DoColumnClick(AColumn: TdxListColumn);
var
  AColumnID: Integer;
begin
  if FSorting and CanSort then
  begin
    AColumnID := GetColumnID(AColumn.Index);
    if ItemProducer.SortColumn = AColumnID then
      ItemProducer.SortDescending := not ItemProducer.SortDescending
    else
      ItemProducer.SortColumn := AColumnID;
    SortColumnChanged;
    DoSortColumnChanged;
  end;
  inherited;
end;

procedure TdxCustomShellListView.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
begin
  if (FEventProcessingCount = 0) and (ShellOptions.ContextMenus and (SelectedItemCount > 0) or
    (SelectedItemCount = 0) and ShellOptions.CurrentFolderContextMenu) then
  begin
    FIsContextPopupProcessing := True;
    try
      Handled := True;
      ItemProducer.LockRead;
      try
        DisplayContextMenu(ClientToScreen(MousePos));
      finally
        ItemProducer.UnlockRead;
      end;
    finally
      FIsContextPopupProcessing := False;
    end;
    ProcessDefferedShellSystemEvents;
  end
  else
    inherited DoContextPopup(MousePos, Handled);
end;

procedure TdxCustomShellListView.DoEdited(AItem: TdxListItem; var ACaption: string);
var
  AShellItem: TcxShellItemInfo;
  APIDL: PItemIDList;
begin
  if AItem.Caption = ACaption then
    Exit;
  inherited DoEdited(AItem, ACaption);
  AShellItem := GetItemInfo(AItem.Index);
  if Succeeded(ItemProducer.ShellFolder.SetNameOf(Handle, AShellItem.pidl,
    PChar(ACaption), SHGDN_INFOLDER or SHGDN_FOREDITING, APIDL)) then
  try
    if not ShellOptions.TrackShellChanges then
      AShellItem.SetNewPidl(APIDL);
  finally
    DisposePidl(APIDL);
  end;
end;

procedure TdxCustomShellListView.DoMakeVisible(P: TPoint; AAnimated: Boolean = False);
begin
  if ItemProducer.IsPopulating and FFocusAndSelectionInfo.IsRestoring then
    Exit;
  inherited DoMakeVisible(P, AAnimated);
  if ItemProducer.IsPopulating then
    StoreScrollPosition;
end;

procedure TdxCustomShellListView.DoSelectionChanged;
begin
  if ItemProducer.IsPopulating and not FFocusAndSelectionInfo.IsRestoring then
    StoreFocusAndSelection;
  inherited DoSelectionChanged;
end;

procedure TdxCustomShellListView.FinishItemCaptionEditing(AAccept: Boolean = True);
var
  AIsEditing: Boolean;
begin
  if FIsFinishEditing then
    Exit;
  FIsFinishEditing := True;
  AIsEditing := IsEditing;
  inherited FinishItemCaptionEditing(AAccept);
  if AAccept and AIsEditing and not ShellOptions.TrackShellChanges then
    UpdateContent;
  FIsFinishEditing := False;
end;

procedure TdxCustomShellListView.InitControl;
begin
  if not IsLoading then
  begin
    if ShellRoot.Pidl = nil then
       TcxShellRootAccess(ShellRoot).CheckRoot;
    DoHandleDependedInitialization;
  end;
end;

function TdxCustomShellListView.InternalMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  if ssCtrl in Shift then
  begin
    FinishItemCaptionEditing(True);
    Result := True;
  end
  else
    Result := inherited InternalMouseWheel(Shift, WheelDelta, MousePos);
end;

function TdxCustomShellListView.IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := (ssCtrl in Shift) or inherited IsMouseWheelHandleNeeded(Shift, WheelDelta, MousePos);
end;

procedure TdxCustomShellListView.KeyDown(var Key: Word; Shift: TShiftState);

  procedure InvokeContextMenuCommand(const ACommandStr: AnsiString);
  var
    AItemPIDLList: TList;
  begin
    AItemPIDLList := CreateSelectedPidlsList;
    try
      cxShellInvokeContextMenuCommand(ShellRoot.ShellFolder, AItemPIDLList, ACommandStr, Handle);
    finally
      DestroySelectedPidlsList(AItemPIDLList);
    end;
  end;

begin
  inherited KeyDown(Key, Shift);
  if not IsEditing then
    case Key of
      VK_RETURN:
        if Controller.FocusedItemIndex >= 0 then
          DoItemDblClick(Controller.FocusedItemIndex);
      VK_BACK:
        if ShellOptions.AutoNavigate then
          BrowseParent;
      VK_F5:
        UpdateContent;
    else
      if (ShellOptions.ContextMenus and (cxShellIsClipboardCommandContextMenuShortCut(Key, Shift) or
        (Key = VK_DELETE)) and ((SelectedItemCount > 0) or (Key = Ord('V')))) then
      begin
        if Key = Ord('V') then
        begin
          PasteFromClipboard;
          ClearCutItems(False);
        end
        else
          InvokeContextMenuCommand(cxShellGetContextMenuCommandStrByShortCut(Key, Shift));
        if Key = Ord('X') then
          CutSelectedItems
        else
          if (Key = VK_DELETE) and not ShellOptions.TrackShellChanges then
            UpdateContent;
      end;
    end;
end;

procedure TdxCustomShellListView.Loaded;
begin
  inherited Loaded;
  if ShellRoot.Pidl = nil then
     TcxShellRootAccess(ShellRoot).CheckRoot
  else
    CheckUpdateItems;
  GroupIndex := FLoadedGroupIndex;
  if HandleAllocated then
    DoHandleDependedInitialization;
end;

procedure TdxCustomShellListView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FShellDragDropState := ddsNone;
end;

function TdxCustomShellListView.OwnerDataFetch(AItem: TdxListItem; ARequest: TdxListItemRequest): Boolean;
var
  AShellItem: TcxShellItemInfo;
  I: Integer;
begin
  Result := True;
  ItemProducer.LockRead;
  try
    if AItem.Index >= ItemProducer.Items.Count then
      Exit;
    AShellItem := GetItemInfo(AItem.Index);
    AItem.Caption := AShellItem.Name;

    if IsThumbnailView then
      AItem.ImageIndex := AShellItem.ThumbnailIndex
    else
      if AShellItem.Updated or AShellItem.IsFolder then
        AItem.ImageIndex := AShellItem.IconIndex
      else
        AItem.ImageIndex := TdxShellItemHelper.GetQuickIconIndexByName(AShellItem.Name);

    if ViewStyle = TdxListViewStyle.Report then
    begin
      if AShellItem.Details.Count = 0 then
        AShellItem.FetchDetails(Handle, ItemProducer.ShellFolder, ItemProducer.Details);
      for I := 0 to AShellItem.Details.Count - 1 do
        AItem.SubItems.Add(AShellItem.Details[I]);
    end;
    AItem.Cut := AShellItem.IsGhosted or CutItemsPIDLListContains(AShellItem.pidl);
    if ItemProducer.IsFavorites then
      AItem.OverlayIndex := -1
    else
      AItem.OverlayIndex := AShellItem.OverlayIndex;
  finally
    ItemProducer.UnlockRead;
  end;
  Result := inherited OwnerDataFetch(AItem, ARequest);
end;

function TdxCustomShellListView.OwnerDataFind(AFind: TdxListItemFind; const AFindString: string; const AFindPosition: TPoint;
  AFindData: Pointer; AStartIndex: Integer; ADirection: TdxListItemSearchDirection; AWrap: Boolean): Integer;

  function IsItemSuitable(AIndex: Integer; ALocalFind: TdxListItemFind; const ALocalFindString: string): Boolean;
  var
    ACaption: string;
  begin
    ACaption := GetItemInfo(AIndex).Name;
    if ALocalFind = TdxListItemFind.PartialString then
      Result := TdxStringHelper.StartsWith(ACaption, ALocalFindString, True)
    else
      Result := ALocalFindString = ACaption;
  end;

  function FindItemByCaption(ALocalFind: TdxListItemFind; const ALocalFindString: string; ALocalStartIndex: Integer;
    ALocalWrap: Boolean): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    ALocalStartIndex := EnsureRange(ALocalStartIndex, 0, ItemProducer.Items.Count - 1);
    for I := ALocalStartIndex to ItemProducer.Items.Count - 1 do
      if IsItemSuitable(I, ALocalFind, ALocalFindString) then
      begin
        Result := I;
        Break;
      end;
    if ALocalWrap and (Result = -1) then
      for I := 0 to ALocalStartIndex - 1 do
        if IsItemSuitable(I, ALocalFind, ALocalFindString) then
          begin
            Result := I;
            Break;
          end;
  end;

begin
  Result := inherited OwnerDataFind(AFind, AFindString, AFindPosition, AFindData, AStartIndex, ADirection, AWrap);
  if (Result = -1) and (AFind in [TdxListItemFind.PartialString, TdxListItemFind.ExactString]) then
    Result := FindItemByCaption(AFind, AFindString, AStartIndex, AWrap);
end;

function TdxCustomShellListView.OwnerDataHint(AStartIndex, AEndIndex: Integer): Boolean;
var
  AItems: TList;
  I: Integer;
  AShellItem: TcxShellItemInfo;
begin
  Result := inherited OwnerDataHint(AStartIndex, AEndIndex);
  AItems := TList.Create;
  try
    for I := AStartIndex to AEndIndex do
    begin
      AShellItem := GetItemInfo(I);
      if not ItemProducer.SlowInitializationDone(AShellItem) then
        AItems.Add(AShellItem);
    end;
    ItemsInfoGatherer.UpdateRequest(AItems);
  finally
    AItems.Free;
  end;
end;

procedure TdxCustomShellListView.ProcessDragAndDropOnMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FAllowDragDrop and (GetItemAtPos(Point(X, Y)) <> nil) then
    FShellDragDropState := ddsStarting
  else
    inherited ProcessDragAndDropOnMouseDown(Button, Shift, X, Y)
end;

procedure TdxCustomShellListView.ProcessDragAndDropOnMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if (FShellDragDropState = ddsStarting) and not IsMouseInPressedArea(X, Y) then
  begin
    FShellDragDropState := ddsInProcess;
    DoBeginDrag;
    FShellDragDropState := ddsNone;
  end
  else
    inherited ProcessDragAndDropOnMouseMove(Shift, X, Y);
end;

procedure TdxCustomShellListView.ShowInplaceEdit(AItemIndex: Integer; ABounds: TRect; const AText: string);
var
  AFolder: TcxShellFolder;
  ASelCount: Integer;
  S: string;
begin
  AFolder := Folders[AItemIndex];
  S := AFolder.EditingName;
  if AFolder.IsFolder and not AFolder.IsZip then
    ASelCount := MaxInt
  else
    ASelCount := Length(TPath.GetFileNameWithoutExtension(AFolder.PathName));
  InplaceEdit.Show(Self, ABounds, S, Fonts.Item, 0, ASelCount, MAX_PATH);
end;

function TdxCustomShellListView.SupportsItemEnabledState: Boolean;
begin
  Result := False;
end;

function TdxCustomShellListView.UseDisplayedItemsForBestFit: Boolean;
begin
  Result := True;
end;

procedure TdxCustomShellListView.ValidatePasteText(var AText: string);
begin
  CheckShellItemDisplayName(AText);
end;

procedure TdxCustomShellListView.Calculate(AType: TdxChangeType);
begin
  FIsCalculating := True;
  inherited Calculate(AType);
  FIsCalculating := False;
end;

procedure TdxCustomShellListView.ChangeView(AViewId: Integer);
begin
  case AViewId of
    cmdSmallIconId:
        ViewStyle := TdxListViewStyle.SmallIcon;
    cmdListId:
        ViewStyle := TdxListViewStyle.List;
    cmdDetailId:
        ViewStyle := TdxListViewStyle.Report;
  else //  cmdExtraLargeId, cmdLargeId, cmdIconId
    ViewStyle := TdxListViewStyle.Icon;
    if IsWinSevenOrLater or (AViewId = cmdLargeIconId) then
      LargeIconSize := isExtraLarge
    else
      LargeIconSize := isDefault;
    UpdateThumbnailSizeByViewID(AViewId);
  end;
  ThumbnailOptions.ShowThumbnails := (AViewId in [cmdExtraLargeIconId, cmdLargeIconId]) or
    IsWinSevenOrLater and (AViewId = cmdIconId);
end;

function TdxCustomShellListView.CheckFileMask(AFolder: TcxShellFolder): Boolean;

  function CheckIsFileLink(out AFileName: string): Boolean;
  var
    ALink: IShellLink;
    ATargetPidl: PItemIDList;
  begin
    Result := AFolder.IsLink and
      Succeeded(AFolder.ParentShellFolder.BindToObject(AFolder.RelativePIDL, nil, IID_IShellLink, ALink)) and
      Succeeded(ALink.GetIDList(ATargetPidl));
    if Result then
    begin
      AFileName := GetPidlName(ATargetPidl);
      Result := AFileName <> '';
    end
    else
      AFileName := '';
  end;

var
  AFileName: string;
begin
  if AFolder.IsFolderLink then
    Exit(True);
  if not CheckIsFileLink(AFileName) then
    AFileName := AFolder.PathName;
  Result := ShellOptions.IsFileNameValid(ExtractFileName(AFileName));
end;

procedure TdxCustomShellListView.CheckLargeImages;
var
  AHImages: HIMAGELIST;
begin
  if IsWinXPOrLater then
  begin
    SHGetImageList(GetLargeImageListType, IID_IImageList, AHImages);
    FLargeImages.Handle := AHImages;
  end
  else
    FLargeImages.Handle := cxShellGetImageList(SHGFI_LARGEICON);
end;

procedure TdxCustomShellListView.CheckUpdateItems;
begin
  if IsLoading then
    Exit;
  RemoveChangeNotification; 
  ClearDefferedShellSystemEvents;
  Items.Count := 0;
  ItemProducer.ClearItems;
  ItemProducer.ProcessItems(ShellRoot.ShellFolder, ShellRoot.Pidl, 0);
  if HandleAllocated then
    CreateChangeNotification;
end;

procedure TdxCustomShellListView.ClearCutItems(const AUpdateContent: Boolean = True);
begin
  DestroySelectedPidlsList(FCutItemsPIDLList);
  if AUpdateContent then
    UpdateContent;
end;

procedure TdxCustomShellListView.CreateChangeNotification;
begin
  if not IsDesigning then
  begin
    if ShellOptions.TrackShellChanges then
      cxShellRegisterChangeNotifier(ItemProducer.FolderPidl, Handle, DSM_SYSTEMSHELLCHANGENOTIFY, False,
        FShellChangeNotifierData)
    else
      RemoveChangeNotification;
  end;
end;

procedure TdxCustomShellListView.CreateNewFolder;
begin
  FIsInternalNewItemCreation := True;
  try
    InvokeFolderContextMenuCommand(PAnsiChar('NewFolder'));
    if not ShellOptions.TrackShellChanges then
      UpdateContent;
  finally
    FIsInternalNewItemCreation := False;
  end;
end;

function TdxCustomShellListView.CreateSelectedPidlsList: TList;
var
  APIDL: PItemIDList;
  I: Integer;
begin
  Result := TList.Create;
  for I := 0 to SelectedItemCount - 1 do
  begin
    APIDL := GetPidlByItemIndex(Controller.SelectedIndices[I]);
    if APIDL <> nil then
      Result.Add(GetPidlCopy(APIDL));
  end;
end;

procedure TdxCustomShellListView.CutSelectedItems;
begin
  ClearCutItems(False);
  FCutItemsPIDLList := CreateSelectedPidlsList;
  if FCutItemsPIDLList.Count = 0 then
    FreeAndNil(FCutItemsPIDLList);
  UpdateContent;
end;

procedure TdxCustomShellListView.DestroySelectedPidlsList(var ASelectedPidls: TList);
var
  I: Integer;
begin
  if ASelectedPidls <> nil then
    try
      for I := 0 to ASelectedPidls.Count - 1 do
        DisposePidl(ASelectedPidls[I]);
    finally
      FreeAndNil(ASelectedPidls);
    end;
end;

procedure TdxCustomShellListView.DisplayContextMenu(const APos: TPoint);
var
  AContextMenu: TdxShellListViewContextMenu;
begin
  if SelectedItemCount <> 0 then
    AContextMenu := TdxShellListViewContextMenu.Create(Self)
  else
    AContextMenu := TdxShellListViewCurrentFolderContextMenu.Create(Self);
  try
    AContextMenu.Popup(APos);
  finally
    AContextMenu.Free;
  end;
end;

function TdxCustomShellListView.DoAddFolder(AFolder: TcxShellFolder): Boolean;
var
  AIsFolder: Boolean;
begin
  AIsFolder := AFolder.IsFolder and (ShellOptions.ShowZipFilesWithFolders or not AFolder.IsZip);

  Result := AIsFolder or (ShellOptions.ShowReadOnly or not(sfaReadOnly in AFolder.Attributes)) and CheckFileMask(AFolder);

  if Assigned(FOnAddFolder) then
    FOnAddFolder(Self, AFolder, Result);
end;

procedure TdxCustomShellListView.DoAfterNavigation;
begin
  ClearCutItems(False);
  TdxShellControlGroups.AbsolutePidlChanged(Self, ShellRoot.Pidl, FGroupIndex);
  FShellDependedControls.Navigate(ShellRoot.Pidl);
  if Assigned(FOnAfterNavigation) then
    FOnAfterNavigation(Self, ShellRoot.Pidl, ShellRoot.CurrentPath);
end;

procedure TdxCustomShellListView.DoBeforeNavigation(APIDL: PItemIDList);
var
  ADesktop: IShellFolder;
  APath: string;
  AName: TStrRet;
begin
  if Assigned(FOnBeforeNavigation) then
  begin
    if Failed(SHGetDesktopFolder(ADesktop)) then
      Exit;
    if Succeeded(ADesktop.GetDisplayNameOf(APIDL, SHGDN_NORMAL or SHGDN_FORPARSING, AName)) then
      APath := GetTextFromStrRet(AName, APIDL)
    else
      APath := '';
    FOnBeforeNavigation(Self, APIDL, APath);
  end;
end;

function TdxCustomShellListView.DoCompare(AItem1, AItem2: TcxShellFolder; out ACompare: Integer): Boolean;
begin
  Result := Assigned(FOnCompare);
  if Result then
    FOnCompare(Self, AItem1, AItem2, ACompare);
end;

procedure TdxCustomShellListView.DoCreateColumns;
var
  AColumn: TdxListColumn;
  AColumns: TdxListColumnsAccess;
  AItem: PcxDetailItem;
  I, AMaxWidth: Integer;
begin
  AColumns := TdxListColumnsAccess(Columns);
  AColumns.BeginUpdate;
  try
    AColumns.Clear;
    AMaxWidth := Screen.WorkAreaRect.Width;
    for I := 0 to ItemProducer.Details.Count - 1 do
    begin
      AItem := ItemProducer.Details[I];
      if AItem.Visible then
      begin
        AColumn := TdxShellListViewColumn(AColumns.AddItem(TdxShellListViewColumn, AColumns.ParentComponent, nil));
        AColumn.Caption := AItem.Text;
        AColumn.Alignment := AItem.Alignment;
        AColumn.MaxWidth := AMaxWidth;
        AColumn.MinWidth := ScaleFactor.Apply(90);
        AColumn.Width := AItem.Width;
        AColumn.Tag := TdxNativeInt(AItem);
        UpdateColumnSortOrder(AColumn.Index);
      end;
    end;
  finally
    AColumns.EndUpdate;
  end;
end;

procedure TdxCustomShellListView.DoItemDblClick(AItemIndex: Integer);
var
  AShellItemInfo: TcxShellItemInfo;
  ALink: IShellLink;
  ATargetPidl: PItemIDList;
begin
  if ShellOptions.AutoNavigate then
  begin
    ItemProducer.LockRead;
    try
      AShellItemInfo := GetItemInfo(AItemIndex);
      if AShellItemInfo.IsFolder and (ShellOptions.ShowZipFilesWithFolders or not AShellItemInfo.IsZip) then
      begin
        if AShellItemInfo.Folder.ShellFolder <> nil then
          DoProcessNavigation(AShellItemInfo);
      end
      else
        if NavigateFolderLinks and AShellItemInfo.IsFolderLink and
          (ShellOptions.ShowZipFilesWithFolders or not AShellItemInfo.IsZipFolderLink) then
        begin
          if Succeeded(ItemProducer.ShellFolder.BindToObject(AShellItemInfo.pidl, nil, IID_IShellLink, ALink)) and
            Succeeded(ALink.GetIDList(ATargetPidl)) and Succeeded(ALink.Resolve(Handle, 0)) then
            Navigate(ATargetPidl)
        end
        else
          if ShellOptions.AutoExecute then
            DoProcessDefaultCommand(AShellItemInfo);
    finally
      ItemProducer.UnlockRead;
    end;
  end;
end;

procedure TdxCustomShellListView.DoOnIdle(Sender: TObject; var Done: Boolean);
var
  AList: TList;
  AShellItem: TcxShellItemInfo;
  AViewInfo: TdxListItemCustomViewInfo;
  I: Integer;
begin
  if ItemProducer <> nil then
    ItemProducer.CheckEnumeration;
  AList := FItemsInfoGatherer.ProcessedItems.LockList;
  try
    if AList.Count > 0 then
    begin
      for I := 0 to AList.Count - 1 do
      begin
        AShellItem := TcxShellItemInfo(AList[I]);
        if ViewInfo.FindItemViewInfo(AShellItem.ItemIndex, AViewInfo) then
        begin
          AList.Clear;
          Invalidate;
          Exit;
        end;
      end;
    end;
  finally
    FItemsInfoGatherer.ProcessedItems.UnlockList;
  end;
end;

procedure TdxCustomShellListView.DoProcessDefaultCommand(AShellItem: TcxShellItemInfo);
var
  APIDL: PItemIDList;
  AExecuteInfo: PShellExecuteInfo;
  AHandled: Boolean;
begin
  APIDL := ConcatenatePidls(ItemProducer.FolderPidl, AShellItem.pidl);
  try
    AHandled := False;
    if Assigned(OnExecuteItem) then
      OnExecuteItem(Self, APIDL, AHandled);
    if not AHandled then
    begin
      New(AExecuteInfo);
      try
        ZeroMemory(AExecuteInfo, SizeOf(TShellExecuteInfo));
        AExecuteInfo.cbSize := SizeOf(TShellExecuteInfo);
        AExecuteInfo.fMask := SEE_MASK_INVOKEIDLIST;
        AExecuteInfo.Wnd := Handle;
        AExecuteInfo.lpIDList := APIDL;
        AExecuteInfo.nShow := SW_SHOW;
        ShellExecuteEx(AExecuteInfo);
      finally
        Dispose(AExecuteInfo);
      end;
    end;
  finally
    DisposePidl(APIDL);
  end;
end;

procedure TdxCustomShellListView.DoProcessNavigation(AShellItem: TcxShellItemInfo);
var
  APIDL: PItemIDList;
begin
  if not AShellItem.IsFolder then
    Exit;
  APIDL := AShellItem.RealItemPidl;
  try
    Navigate(APIDL);
  finally
    DisposePidl(APIDL);
  end;
end;

procedure TdxCustomShellListView.DoSortColumnChanged;
begin
  dxCallNotify(FOnSortColumnChanged, Self);
end;

procedure TdxCustomShellListView.DoViewChanged;
begin
  dxCallNotify(FOnViewChanged, Self);
end;

function TdxCustomShellListView.GetColumnClass: TdxListColumnClass;
begin
  Result := TdxShellListViewColumn;
end;

function TdxCustomShellListView.GetColumnID(AIndex: Integer): Integer;
begin
  Result := GetDetailItemByColumnIndex(AIndex).ID;
end;

function TdxCustomShellListView.GetColumnIndexByID(AID: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Columns.Count - 1 do
    if GetColumnID(I) = AID then
    begin
      Result := I;
      Break;
    end;
end;

function TdxCustomShellListView.GetContextMenuSite: IUnknown;
begin
  Result := nil;
end;

function TdxCustomShellListView.GetCurrentCursor(X, Y: Integer): TCursor;
begin
  if not ItemProducer.IsSortingCompleted then
    Result := crAppStart
  else
    Result := inherited GetCurrentCursor(X, Y);
end;

function TdxCustomShellListView.GetDetailItemByColumnIndex(AIndex: Integer): PcxDetailItem;
begin
  Result := PcxDetailItem(Columns[AIndex].Tag);
end;

function TdxCustomShellListView.GetCurrentViewId: Integer;
begin
  Result := cmdDetailId;
  case ViewStyle of
    TdxListViewStyle.Icon:
      begin
        if not IsWinSevenOrLater then
          if ThumbnailOptions.ShowThumbnails then
            Result := cmdLargeIconId
          else
            Result := cmdIconId
        else
          if ThumbnailOptions.Width >= dxShellExtraLargeIconSize.cx then
            Result := cmdExtraLargeIconId
          else
            if ThumbnailOptions.Width >= dxShellLargeIconSize.cx then
              Result := cmdLargeIconId
            else
              Result := cmdIconId;
      end;
    TdxListViewStyle.SmallIcon:
      Result := cmdSmallIconId;
    TdxListViewStyle.List:
      Result := cmdListId;
  end;
end;

function TdxCustomShellListView.GetItemInfo(AIndex: Integer): TcxShellItemInfo;
begin
  Result := ItemProducer.ItemInfo[AIndex];
end;

function TdxCustomShellListView.GetLargeIconSize: TSize;
begin
  Result := cxSize(FLargeImages.Width, FLargeImages.Height);
end;

function TdxCustomShellListView.GetPidlByItemIndex(AIndex: Integer): PItemIDList;
begin
  Result := GetItemInfo(AIndex).pidl;
end;

function TdxCustomShellListView.GetSortColumnIndex: Integer;
begin
  Result := GetColumnIndexByID(ItemProducer.SortColumn);
end;

function TdxCustomShellListView.GetThumbnailScaledSize: TSize;
begin
  Result := ScaleFactor.Apply(ThumbnailOptions.Size);
  Result.cx := Min(Result.cx, dxShellExtraLargeIconSize.cx); 
  Result.cy := Min(Result.cy, dxShellExtraLargeIconSize.cy); 
end;

function TdxCustomShellListView.GetViewCaption(const AViewId: Integer; AShell32DLLHandle: THandle = 0): string;
var
  ALibraryHandle: THandle;
begin
  if AShell32DLLHandle <> 0 then
    ALibraryHandle := AShell32DLLHandle
  else
    ALibraryHandle := LoadLibraryEx('shell32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    case AViewId of
      cmdExtraLargeIconId:
        Result := dxGetLocalizedSystemResourceString(sdxShellExtraLargeIconsCaption, ALibraryHandle,
          IfThen(IsWinSevenOrLater, 31136, -1));
      cmdLargeIconId:
        Result := dxGetLocalizedSystemResourceString(sdxShellLargeIconsCaption, ALibraryHandle,
          IfThen(IsWinSevenOrLater, 31137, 16384)); 
      cmdIconId:
        if IsWinSevenOrLater then
          Result := dxGetLocalizedSystemResourceString(sdxShellMediumIconsCaption, ALibraryHandle, 31138)
        else
          Result := cxGetResourceString(@sdxShellIconsCaption);
      cmdSmallIconId:
        Result := dxGetLocalizedSystemResourceString(sdxShellSmallIconsCaption, ALibraryHandle, 31139);
      cmdListId:
        Result := dxGetLocalizedSystemResourceString(sdxShellListCaption, ALibraryHandle,
          IfThen(IsWinSevenOrLater, 31140, 33579));
      cmdDetailId:
        Result := dxGetLocalizedSystemResourceString(sdxShellDetailsCaption, ALibraryHandle,
          IfThen(IsWinSevenOrLater, 31141, 33580));
    else
      Result := '';
    end;
    Result := StringReplace(Result, '|', '', [rfReplaceAll]); 
  finally
    if AShell32DLLHandle = 0 then
      FreeLibrary(ALibraryHandle);
  end;
end;

function TdxCustomShellListView.GetViewOptions(AForNavigation: Boolean = False): TcxShellViewOptions;
begin
  if AForNavigation then
    Result := [svoShowFolders, svoShowHidden]
  else
  begin
    Result := [];
    if ShellOptions.ShowNonFolders then
      Include(Result, svoShowFiles);
    if ShellOptions.ShowFolders then
      Include(Result, svoShowFolders);
    if ShellOptions.ShowHidden then
      Include(Result, svoShowHidden);
  end;
end;

procedure TdxCustomShellListView.InvalidateImageList;
begin
  Painter.InvalidateImageList(ImageOptions.LargeImages);
end;

function TdxCustomShellListView.IsThumbnailView: Boolean;
begin
  Result := IsWinXPOrLater and (ViewStyle = TdxListViewStyle.Icon) and ThumbnailOptions.ShowThumbnails;
end;

procedure TdxCustomShellListView.Navigate(APIDL: PItemIDList);
begin
  if not dxIsSearchFolderPidl(APIDL) and EqualPIDLs(APIDL, ItemProducer.FolderPidl) then
    Exit;
  BeginUpdate;
  try
    DoBeforeNavigation(APIDL);
    ShellRoot.Pidl := APIDL;
    DoAfterNavigation;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomShellListView.PasteFromClipboard;
begin
  InvokeFolderContextMenuCommand(PAnsiChar('Paste'));
  if not ShellOptions.TrackShellChanges then
    UpdateContent;
end;

procedure TdxCustomShellListView.RemoveChangeNotification;
begin
  cxShellUnregisterChangeNotifier(FShellChangeNotifierData);
end;

procedure TdxCustomShellListView.SelectItemByPidl(APidl: PITemIDList);
var
  AList: TList;
begin
  if APidl <> nil then
  begin
    ClearFocusAndSelection;
    AList := TList.Create;
    AList.Add(GetPidlCopy(APidl));
    FFocusAndSelectionInfo.SelectedPidls := AList;
    FFocusAndSelectionInfo.FocusedPidl := GetPidlCopy(APidl);
    if not ItemProducer.IsPopulating then
      RestoreFocusAndSelection;
   end;
end;

procedure TdxCustomShellListView.Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer);
begin
  inherited;
  if ItemProducer.IsPopulating then
    StoreScrollPosition
end;

procedure TdxCustomShellListView.SortColumnChanged;
begin
  BeginUpdate;
  try
    Sort;
    UpdateColumnsSortOrder;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomShellListView.ThumbnailOptionsChanged(Sender: TObject);
var
  I: Integer;
begin
  UpdateThumbnails;
  if IsThumbnailView then
  begin
    TThumbnailOverlayImageHelper(ThumbnailOverlayImageHelper).Initialize(ActualCanvas, ThumbnailOptions.Width);
    FItemsInfoGatherer.ClearVisibleItems;
    TcxShellItemsInfoGathererAccess(FItemsInfoGatherer).CancelRequest(nil);
    for I := 0 to ItemProducer.Items.Count - 1 do
      ItemProducer.ItemInfo[I].ResetThumbnail;
    ItemProducer.CheckThumbnails;
  end;
end;

procedure TdxCustomShellListView.UpdateThumbnails;
var
  ASize: TSize;
begin
  if IsThumbnailView then
  begin
    FIsThumbnailView := True;
    ASize := GetThumbnailScaledSize;
    FFakeThumbnailImages.SetSize(ASize.cx, ASize.cy);
    ImageOptions.LargeImages := FFakeThumbnailImages;
  end
  else
  begin
    FIsThumbnailView := False;
    ImageOptions.LargeImages := FLargeImages;
  end;
end;

procedure TdxCustomShellListView.UpdateThumbnailSizeByViewID(AViewId: Integer);

  function GetThumbnailSizeByViewID(AViewId: Integer): TSize;
  begin
    if AViewId = cmdExtraLargeIconId then
      Result := dxShellExtraLargeIconSize
    else
      if AViewId = cmdLargeIconId then
        Result := dxShellLargeIconSize
      else
        Result := dxShellMediumIconSize;
  end;

begin
  ThumbnailOptions.Size := GetThumbnailSizeByViewID(AViewId);
end;

procedure TdxCustomShellListView.DSMNotifyUpdateContents(var Message: TMessage);
begin
  CheckUpdateItems;
end;

procedure TdxCustomShellListView.DSMNotifyUpdateItem(var Message: TMessage);
begin
  LayoutChanged;
end;


procedure TdxCustomShellListView.DSMSetCount(var Message: TMessage);
begin
  DoSetItemCount(Message.WParam);
end;

// IDropTarget
function TdxCustomShellListView.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  AStep: Integer;
  ASize: TSize;
begin
  AStep := ViewInfo.ItemSize.cy;// + ViewInfo.GetGapBetweenItems;
  ASize.Init(AStep);
  FAutoScrollHelper := TdxAutoScrollHelper.CreateScroller(Self, ClientBounds, ScaleFactor.Apply(20), 250, ASize);
  if FDropTargetHelper = nil then
    CoCreateInstance(CLSID_DragDropHelper, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IDropTargetHelper, FDropTargetHelper);
  FDraggedObject := dataObj;
  dwEffect := DROPEFFECT_NONE;
  Result := S_OK;
  FDropTargetRealItemIndex := -1;
  FDragKeyState := 0;
  if FDropTargetHelper <> nil then
    FDropTargetHelper.DragEnter(Handle, dataObj, pt, dwEffect);
end;

function TdxCustomShellListView.DragLeave: HResult;
begin
  if FDropTargetHelper <> nil then
    FDropTargetHelper.DragLeave;
  FDropTargetHelper := nil;
  FDraggedObject := nil;
  Result := TryReleaseDropTarget;
  FreeAndNil(FAutoScrollHelper);
end;

function TdxCustomShellListView.IDropTargetDragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
var
  ANew: Boolean;
begin
  if not FPrevDragOverPoint.IsEqual(pt) then
  begin
    FAutoScrollHelper.CheckMousePosition(ScreenToClient(pt));
    FPrevDragOverPoint := pt;
  end;
  UpdateDropTarget(grfKeyState, pt, dwEffect, ANew);
  if FCurrentDropTarget = nil then
  begin
    dwEffect := DROPEFFECT_NONE;
    Result := S_OK;
  end
  else
  begin
    if ANew then
      Result := FCurrentDropTarget.DragEnter(FDraggedObject, grfKeyState, pt, dwEffect)
    else
      Result := S_OK;
    if Succeeded(Result) then
      Result := FCurrentDropTarget.DragOver(grfKeyState, pt, dwEffect);
  end;
  if FDropTargetHelper <> nil then
    FDropTargetHelper.DragOver(pt, dwEffect);
end;

function TdxCustomShellListView.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  ANew: Boolean;
begin
  UpdateDropTarget(grfKeyState, pt, dwEffect, ANew);
  if FCurrentDropTarget = nil then
  begin
    dwEffect := DROPEFFECT_NONE;
    Result := S_OK;
  end
  else
  begin
    if ANew then
      Result := FCurrentDropTarget.DragEnter(dataObj, grfKeyState, pt, dwEffect)
    else
      Result := S_OK;
    if Succeeded(Result) then
    begin
      if FDropTargetHelper <> nil then
        FDropTargetHelper.Drop(dataObj, pt, dwEffect);
      Result := FCurrentDropTarget.Drop(dataObj, grfKeyState, pt, dwEffect);
      if not ShellOptions.TrackShellChanges then
      begin
        TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
          procedure
          begin
            UpdateContent;
          end);
      end;
    end;
  end;
  FDropTargetHelper := nil;
  FDraggedObject := nil;
  TryReleaseDropTarget;
  FreeAndNil(FAutoScrollHelper);
end;

function TdxCustomShellListView.GetRoot: TcxCustomShellRoot;
begin
  Result := FShellRoot;
end;

function TdxCustomShellListView.GetDependedControls: TcxShellDependedControls;
begin
  Result := FShellDependedControls;
end;

procedure TdxCustomShellListView.InplaceEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not IsValidShellNameChar(Key) then
    Key := #0;
end;

procedure TdxCustomShellListView.AddDefferedUpdateContent;
begin
  AddDefferedShellSystemEvent(0, AbsolutePIDL, nil);
end;

function TdxCustomShellListView.CanSort: Boolean;
begin
  Result := ItemProducer.IsSortSupported;
end;

procedure TdxCustomShellListView.ClearFocusAndSelection;
begin
  dxFreeAndNilPidl(FFocusAndSelectionInfo.FocusedPidl);
  DestroySelectedPidlsList(FFocusAndSelectionInfo.SelectedPidls);
end;

procedure TdxCustomShellListView.ClearScrollPosition;
begin
  FSavedScrollPos.IsValid := False;
end;

procedure TdxCustomShellListView.DoSetItemCount(ACount: Integer);
begin
  BeginUpdate;
  try
    Items.Count := ACount;
    FocusedItem := nil;
    RestoreFocusAndSelection;
    RestoreScrollPosition;
  finally
    EndUpdate;
  end;
end;

function TdxCustomShellListView.GetViewStyleIcon: TdxShellListViewIconOptions;
begin
  Result := TdxShellListViewIconOptions(inherited ViewStyleIcon);
end;

procedure TdxCustomShellListView.ItemsPopulated;
begin
  dxCallNotify(FOnItemsPopulated, Self);
end;

procedure TdxCustomShellListView.RestoreEditingItem;
var
  AItemIndex: Integer;
begin
  if FStoredEditingItemPidl <> nil then
  begin
    AItemIndex := ItemProducer.GetItemIndexByPidl(FStoredEditingItemPidl);
    if (AItemIndex >= 0) and (AItemIndex < Items.Count) then
      StartItemCaptionEditing(AItemIndex);
    dxFreeAndNilPidl(FStoredEditingItemPidl);
  end;
end;

procedure TdxCustomShellListView.RestoreFocusAndSelection;
var
  AItemPIDLList: TList;
  I, AItemIndex: Integer;
  APidl: PItemIDList;
  ASelectedItems: TdxIntegerList;
begin
  FFocusAndSelectionInfo.IsRestoring := True;
  try
    AItemPIDLList := FFocusAndSelectionInfo.SelectedPidls;
    APidl := FFocusAndSelectionInfo.FocusedPidl;
    if AItemPIDLList <> nil then
    begin
      Controller.BeginSelectionChanged;
      try
        ASelectedItems := TdxIntegerList.Create;
        try
          ASelectedItems.Capacity := AItemPIDLList.Count;
          for I := 0 to AItemPIDLList.Count - 1 do
          begin
            AItemIndex := ItemProducer.GetItemIndexByPidl(AItemPIDLList[I]);
            if AItemIndex >= 0 then
              ASelectedItems.Add(AItemIndex);
          end;
          Controller.ReplaceSelection(ASelectedItems);
        finally
          ASelectedItems.Free;
        end;
      finally
        Controller.EndSelectionChanged;
      end;
    end;
    if APidl <> nil then
    begin
      AItemIndex := ItemProducer.GetItemIndexByPidl(APidl);
      if AItemIndex >= 0 then
        Controller.FocusedItemIndex := AItemIndex;
    end;
  finally
    FFocusAndSelectionInfo.IsRestoring := False;
  end;
end;

procedure TdxCustomShellListView.RestoreScrollPosition;
begin
  if FSavedScrollPos.IsValid then
    SetLeftTop(Point(FSavedScrollPos.Left, FSavedScrollPos.Top));
end;

procedure TdxCustomShellListView.SetViewStyleIcon(
  AValue: TdxShellListViewIconOptions);
begin
  inherited ViewStyleIcon := AValue;
end;

procedure TdxCustomShellListView.SortCompleted;
begin
  dxCallNotify(OnSortCompleted, Self);
end;

procedure TdxCustomShellListView.StoreEditingItem;
begin
  if IsEditing then
  begin
    dxFreeAndNilPidl(FStoredEditingItemPidl);
    FStoredEditingItemPidl := GetPidlCopy(GetPidlByItemIndex(EditingItem.Index));
    FinishItemCaptionEditing(False);
  end;
end;

procedure TdxCustomShellListView.StoreFocusAndSelection;
var
  APidl: PItemIDList;
begin
  ClearFocusAndSelection;
  FFocusAndSelectionInfo.SelectedPidls := CreateSelectedPidlsList;
  if FocusedItem <> nil then
    APidl := GetPidlCopy(GetPidlByItemIndex(Controller.FocusedItemIndex))
  else
    APidl := nil;
  FFocusAndSelectionInfo.FocusedPidl := APidl;
end;

procedure TdxCustomShellListView.StoreScrollPosition;
begin
  FSavedScrollPos.Left := LeftPos;
  FSavedScrollPos.Top := TopPos;
  FSavedScrollPos.IsValid := True;
end;

function TdxCustomShellListView.CutItemsPIDLListContains(APIDL: PItemIDList): Boolean;
var
  I: Integer;
begin
  Result := False;
  if FCutItemsPIDLList <> nil then
    for I := 0 to FCutItemsPIDLList.Count - 1 do
      if EqualPIDLs(APIDL, FCutItemsPIDLList[I]) then
      begin
        Result := True;
        Break;
      end;
end;

procedure TdxCustomShellListView.DoProcessSystemShellChange(AEventID: Longint; APidl1, APidl2: PItemIDList);

  procedure UpdateView;
  begin
    StoreFocusAndSelection;
    StoreScrollPosition;
    ItemProducer.RecreateListItems;
    Sort;
  end;

  function CheckRenameNotify(AEventID: Longint; APidl1, APidl2: PItemIDList): Boolean;
  var
    AShellItemInfo: TcxShellItemInfo;
  begin
    Result := (AEventID and SHCNE_RENAMEFOLDER = SHCNE_RENAMEFOLDER) or (AEventID and SHCNE_RENAMEITEM = SHCNE_RENAMEITEM);
    if Result then
    begin
      AShellItemInfo := ItemProducer.GetItemByPidl(GetLastPidlItem(APidl1));
      if AShellItemInfo <> nil then
      begin
        if not ItemProducer.IsSortingCompleted then
          ItemProducer.CancelSortingTask;
        AShellItemInfo.SetNewPidl(GetLastPidlItem(APidl2));
        UpdateView;
      end;
    end;
  end;

  function CheckUpdateItemNotify(AEventID: Longint; APidl1, APidl2: PItemIDList): Boolean;
  var
    AShellItemInfo: TcxShellItemInfo;
  begin
    Result := AEventID = SHCNE_UPDATEITEM;
    if Result and not IsEditing then
    begin
      AShellItemInfo := ItemProducer.GetItemByPidl(GetLastPidlItem(APidl1));
      if AShellItemInfo <> nil then
      begin
        AShellItemInfo.ResetDetails;
        UpdateView;
      end
      else
        if IsParentPidl(ItemProducer.FolderPidl, APidl1) then
          Result := False; 
    end;
  end;

  function CheckAddNotify(AEventID: Longint; APidl1, APidl2: PItemIDList): Boolean;
  var
    AShellItemInfo: TcxShellItemInfo;
  begin
    Result := ((AEventID = SHCNE_MKDIR) or (AEventID = SHCNE_CREATE)) and
     not ItemProducer.IsPopulating and IsParentPidl(ItemProducer.FolderPidl, APidl1); 
    if Result then
    begin
      AShellItemInfo := ItemProducer.GetItemByPidl(GetLastPidlItem(APidl1)); 
      if AShellItemInfo <> nil then
      begin
        Result := False; 
        Exit;
      end;
      if not ItemProducer.IsSortingCompleted then
        ItemProducer.CancelSortingTask;
      ItemProducer.InternalAddItem(GetPidlCopy(GetLastPidlItem(APidl1)));
      if FIsInternalNewItemCreation then
      begin
        Controller.SelectedIndices.Clear;
        Controller.SelectedIndices.Add(ItemProducer.Items.Count - 1);
      end;
      UpdateView;
      if FIsInternalNewItemCreation then
      begin
        DisposePidl(FStoredEditingItemPidl);
        FStoredEditingItemPidl := GetPidlCopy(GetLastPidlItem(APidl1));
        if ItemProducer.FEnumeratingItemsTaskHandle = 0 then
          RestoreEditingItem;
      end;
    end;
  end;

  function CheckRemoveNotify(AEventID: Longint; APidl1, APidl2: PItemIDList): Boolean;
  var
    AShellItemInfo: TcxShellItemInfo;
    AIndex: Integer;
  begin
    Result := ((AEventID = SHCNE_DELETE) or (AEventID = SHCNE_RMDIR)) and
      not ItemProducer.IsPopulating;
    if Result then
    begin
      AShellItemInfo := ItemProducer.GetItemByPidl(GetLastPidlItem(APidl1));
      if AShellItemInfo <> nil then
      begin
        if not ItemProducer.IsSortingCompleted then
          ItemProducer.CancelSortingTask;
        AIndex := ItemProducer.Items.IndexOf(AShellItemInfo);
        if Controller.FocusedItemIndex = AIndex then
          if AIndex < ItemProducer.Items.Count - 1 then
            Controller.FocusedItemIndex := AIndex + 1
          else
            Controller.FocusedItemIndex := AIndex - 1;
        Controller.SelectedIndices.Remove(AIndex);
        StoreFocusAndSelection;
        ItemProducer.RemoveItem(AShellItemInfo);
        StoreScrollPosition;
        ItemProducer.RecreateListItems;
        Sort;
      end
      else
        if IsParentPidl(ItemProducer.FolderPidl, APidl1) then
          Result := False; 
    end;
  end;

begin
  if not CheckRenameNotify(AEventID, APidl1, APidl2) and
    not CheckUpdateItemNotify(AEventID, APidl1, APidl2) and
    not CheckAddNotify(AEventID, APidl1, APidl2) and
    not CheckRemoveNotify(AEventID, APidl1, APidl2) then
  begin
    if not ItemProducer.IsPopulating then
    begin
      StoreFocusAndSelection;
      StoreScrollPosition;
    end;
    StoreEditingItem;
    CheckUpdateItems;
  end;
  if Assigned(FOnShellChange) then
    FOnShellChange(Self, AEventID, APIDL1, APIDL2);
end;

procedure TdxCustomShellListView.AddDefferedShellSystemEvent(AEventID: Longint; APidl1, APidl2: PItemIDList);
var
  AEventInfo: TdxShellSystemEventInfo;
begin
  AEventInfo.EventID := AEventID;
  AEventInfo.Pidl1 := APidl1;
  AEventInfo.Pidl2 := APidl2;
  FDefferedShellSystemEvents.Add(AEventInfo);
end;

procedure TdxCustomShellListView.ClearDefferedShellSystemEvents;
var
  I: Integer;
begin
  for I := FDefferedShellSystemEvents.Count - 1 downto 0 do
  begin
    DisposePidl(FDefferedShellSystemEvents[I].Pidl1);
    DisposePidl(FDefferedShellSystemEvents[I].Pidl2);
    FDefferedShellSystemEvents.Delete(I);
  end;
end;

procedure TdxCustomShellListView.ProcessDefferedShellSystemEvents;
var
  AEventInfo: TdxShellSystemEventInfo;
begin
  if (FEventProcessingCount = 0) and not FIsContextPopupProcessing then
    while FDefferedShellSystemEvents.Count > 0 do
    begin
      Inc(FEventProcessingCount);
      AEventInfo := FDefferedShellSystemEvents.Extract(FDefferedShellSystemEvents.First);
      try
        DoProcessSystemShellChange(AEventInfo.EventID, AEventInfo.Pidl1, AEventInfo.Pidl2);
      finally
        DisposePidl(AEventInfo.Pidl1);
        DisposePidl(AEventInfo.Pidl2);
      end;
      Dec(FEventProcessingCount);
    end;
end;

procedure TdxCustomShellListView.CreateDropTarget;
begin
  if not IsDesigning then
    dxTestCheck(Succeeded(RegisterDragDrop(Handle, Self)), 'RegisterDragDrop - dxShellListView');
end;

procedure TdxCustomShellListView.DoBeginDrag;
var
  ASelectedPidls: TList;
  APidlList: PITEMIDLISTARRAY;
  ADataObject: IDataObject;
  AEffect: Cardinal;
  AAttributes: Cardinal;
begin
  if SelectedItemCount > 0 then
  begin
    FIsDragging := True;
    try
      ASelectedPidls := CreateSelectedPidlsList;
      try
        APidlList := CreatePidlArrayFromList(ASelectedPidls);
        try
          if Succeeded(ItemProducer.ShellFolder.GetUIObjectOf(Handle, ASelectedPidls.Count, APidlList[0],
            IDataObject, nil, ADataObject)) then
          begin
            AAttributes := SFGAO_CANDELETE or SFGAO_CANCOPY or SFGAO_CANMOVE or SFGAO_CANLINK;
            if Succeeded(ItemProducer.ShellFolder.GetAttributesOf(ASelectedPidls.Count, APidlList[0], AAttributes)) then
            begin
              if AAttributes and SFGAO_CANDELETE <> 0 then
                AAttributes := AAttributes or DROPEFFECT_MOVE;
              AEffect := AAttributes and (DROPEFFECT_COPY or DROPEFFECT_MOVE or DROPEFFECT_LINK);
            end;
            SHDoDragDrop(Handle, ADataObject, nil, AEffect, AEffect);
          end;
        finally
          DisposePidlArray(APidlList);
        end;
      finally
        DestroySelectedPidlsList(ASelectedPidls);
      end;
    finally
      FIsDragging := False;
    end;
    if not ShellOptions.TrackShellChanges then
      AddDefferedUpdateContent;
    ProcessDefferedShellSystemEvents;
  end;
end;

procedure TdxCustomShellListView.DoHandleDependedInitialization;
begin
  CreateChangeNotification;
  CreateDropTarget;
end;

procedure TdxCustomShellListView.DoInfoTip(AItem: TdxListItem; var AInfoTip: string);
begin
  inherited DoInfoTip(AItem, AInfoTip);
  ItemProducer.GetInfoTip(Handle, AItem.Index, AInfoTip);
end;

function TdxCustomShellListView.GetAbsolutePIDL: PItemIDList;
begin
  CheckShellRoot(ShellRoot);
  Result := GetPidlCopy(ShellRoot.Pidl);
end;

function TdxCustomShellListView.GetController: TdxShellListViewController;
begin
  Result := TdxShellListViewController(inherited Controller);
end;

function TdxCustomShellListView.GetFolder(AIndex: Integer): TcxShellFolder;
begin
  Result := GetItemInfo(AIndex).Folder;
end;

function TdxCustomShellListView.GetFolderCount: Integer;
begin
  Result := Items.Count;
end;

function TdxCustomShellListView.GetLargeImageListType: Integer;
begin
  case FLargeIconSize of
    isDefault:
      Result := SHIL_LARGE;
    isExtraLarge:
      Result := SHIL_EXTRALARGE;
  else // isJumbo
    if IsWinVistaOrLater then
      Result := SHIL_JUMBO
    else
      Result := SHIL_EXTRALARGE;
  end;
end;

function TdxCustomShellListView.GetPath: string;
var
  APIDL: PItemIDList;
begin
  APIDL := AbsolutePIDL;
  try
    Result := GetPidlName(APIDL);
  finally
    DisposePidl(APIDL);
  end;
end;

function TdxCustomShellListView.GetSelectedFilePaths: TStrings;
var
  I: Integer;
begin
  FSelectedFiles.Clear;
  for I := 0 to SelectedItemCount - 1 do
    FSelectedFiles.Add(Folders[Controller.SelectedIndices[I]].PathName);
  Result := FSelectedFiles;
end;

function TdxCustomShellListView.GetShellRoot: TdxShellListViewRoot;
begin
  Result := FShellRoot;
end;

procedure TdxCustomShellListView.InitializeLocalizableSources;
begin
  FNoItemsMatchStr := dxGetLocalizedSystemResourceString(sdxShellListViewNoItemsMatch, shell32, $3415);
  if IsWin10OrLater then
    FWorkingOnItStr := dxGetLocalizedSystemResourceString(sdxShellListViewWorkingOnIt, 'explorerframe.dll', $A208)
  else
    FWorkingOnItStr := dxGetLocalizedSystemResourceString(sdxShellListViewWorkingOnIt, shell32, $80B6);
end;

procedure TdxCustomShellListView.InvokeFolderContextMenuCommand(ACommandName: PAnsiChar);
var
  AIContextMenu: IContextMenu;
  AInvokeCommandInfo: TCMInvokeCommandInfo;
  AMenu: HMenu;
begin
  AMenu := CreatePopupMenu;
  try
    if Succeeded(ShellRoot.ShellFolder.CreateViewObject(Handle, IID_IContextMenu, AIContextMenu)) then
    begin
      AIContextMenu.QueryContextMenu(AMenu, 0, 0, $7FFF, 0);
      ZeroMemory(@AInvokeCommandInfo, SizeOf(AInvokeCommandInfo));
      AInvokeCommandInfo.cbSize := SizeOf(AInvokeCommandInfo);
      AInvokeCommandInfo.hwnd := Handle;
      AInvokeCommandInfo.lpVerb := ACommandName;
      AInvokeCommandInfo.nShow := SW_SHOWNORMAL;
      AIContextMenu.InvokeCommand(AInvokeCommandInfo);
    end;
  finally
    DestroyMenu(AMenu);
  end;
end;

procedure TdxCustomShellListView.ResetSorting;
begin
  FItemProducer.SortDescending := False;
  FItemProducer.SortColumn := 0;
end;

procedure TdxCustomShellListView.RootFolderChanged(Sender: TObject; Root: TcxCustomShellRoot);
begin
  ClearScrollPosition;
  ResetSorting;
  ClearFocusAndSelection;
  dxFreeAndNilPidl(FStoredEditingItemPidl);
  CheckUpdateItems;
  dxCallNotify(FOnCurrentFolderChanged, Self);
end;

procedure TdxCustomShellListView.RootSettingsChanged(Sender: TObject);
begin
  if not IsLoading then
  begin
    TdxShellControlGroups.RootChanged(Self, ShellRoot, FGroupIndex);
    FShellDependedControls.SynchronizeRoot(ShellRoot);
  end;
end;

procedure TdxCustomShellListView.SetAbsolutePIDL(AValue: PItemIDList);
begin
  Navigate(AValue);
end;

procedure TdxCustomShellListView.SetGroupIndex(AValue: Integer);
begin
  if FGroupIndex <> AValue then
  begin
    if IsLoading then
      FLoadedGroupIndex := AValue
    else
    begin
      if FGroupIndex >= 0 then
        TdxShellControlGroups.RemoveControl(Self, FGroupIndex);
      FGroupIndex := AValue;
      if FGroupIndex >= 0 then
        TdxShellControlGroups.AddControl(Self, FGroupIndex);
    end;
  end;
end;

procedure TdxCustomShellListView.SetDropTargetItemIndex(AValue: Integer);
begin
  if FDropTargetItemIndex <> -1 then
    Items[FDropTargetItemIndex].DropTarget := False;
  FDropTargetItemIndex := AValue;
  if FDropTargetItemIndex <> -1 then
    Items[FDropTargetItemIndex].DropTarget := True;
end;

procedure TdxCustomShellListView.UpdateEmptyText;
begin
  if ItemProducer.IsPopulating then
    EmptyText := FWorkingOnItStr
  else
    EmptyText := FNoItemsMatchStr
end;

procedure TdxCustomShellListView.SetLargeIconSize(const AValue: TcxShellIconSize);
begin
  if AValue <> FLargeIconSize then
  begin
    FLargeIconSize := AValue;
    CheckLargeImages;
    if ViewStyle = TdxListViewStyle.Icon then
      LayoutChanged;
  end;
end;

procedure TdxCustomShellListView.SetPath(AValue: string);
var
  APIDL: PItemIDList;
begin
  APIDL := PathToAbsolutePIDL(AValue, ShellRoot, GetViewOptions(True), False);
  if APIDL <> nil then
    try
      AbsolutePIDL := APIDL;
    finally
      DisposePidl(APIDL);
    end;
end;

procedure TdxCustomShellListView.SetShellRoot(AValue: TdxShellListViewRoot);
begin
  FShellRoot.Assign(AValue);
end;

procedure TdxCustomShellListView.SetSorting(const AValue: Boolean);
begin
  if FSorting <> AValue then
  begin
    FSorting := AValue;
    SortColumnChanged;
  end;
end;

function TdxCustomShellListView.TryReleaseDropTarget: HResult;
begin
  Result := S_OK;
  if FCurrentDropTarget <> nil then
    Result := FCurrentDropTarget.DragLeave;
  FCurrentDropTarget := nil;
  DropTargetItemIndex := -1;
end;

procedure TdxCustomShellListView.UpdateColumnSortOrder(AIndex: Integer);
begin
  if not CanSort or not FSorting or (AIndex <> GetSortColumnIndex) then
    Columns[AIndex].SortOrder := soNone
  else
    if ItemProducer.SortDescending then
      Columns[AIndex].SortOrder := soDescending
    else
      Columns[AIndex].SortOrder := soAscending;
end;

procedure TdxCustomShellListView.UpdateColumnsSortOrder;
var
  I: Integer;
begin
  Columns.BeginUpdate;
  try
    LeftPos := 0;
    for I := 0 to Columns.Count - 1 do
      UpdateColumnSortOrder(I);
  finally
    Columns.EndUpdate;
  end;
end;

procedure TdxCustomShellListView.UpdateDropTarget(grfKeyState: Integer;
  const APoint: TPoint; var dwEffect: Integer; out ANew: Boolean);

  function GetDropTargetItemIndex: Integer;
  var
    AItem: TdxListItem;
  begin
    AItem := GetItemAtPos(ScreenToClient(APoint));
    if AItem <> nil then
      Result := AItem.Index
    else
      Result := -1;
  end;

  function ProvideDropTargetFromCurrentFolder(AllowQuickAccess: Boolean): Boolean;
  var
    AFolder: IShellFolder;
  begin
    if not ItemProducer.IsQuickAccess then
      AFolder := ItemProducer.ShellFolder
    else
      if not AllowQuickAccess or
         Failed(CoCreateInstance(CLSID_FrequentPlacesFolder, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IShellFolder, AFolder)) then
        AFolder := nil;
    Result := (AFolder <> nil) and Succeeded(AFolder.CreateViewObject(Handle, IDropTarget, FCurrentDropTarget));
  end;

  function IsDragOverDragSourceItem(AItemIndex: Integer): Boolean;
  begin
    Result := FIsDragging and (Controller.SelectedIndices.IndexOf(AItemIndex) <> -1);
  end;

  function ProvideDropTargetFromItem(AItemIndex: Integer): Boolean;
  var
    ATempPidl: PItemIDList;
  begin
    ATempPidl := GetPidlCopy(GetPidlByItemIndex(AItemIndex));
    try
      Result := Succeeded(ItemProducer.ShellFolder.GetUIObjectOf(Handle, 1, ATempPidl, IDropTarget, nil, FCurrentDropTarget));
    finally
      DisposePidl(ATempPidl);
    end;
  end;

var
  AItemIndex: Integer;
begin
  ANew := False;
  if not FAllowDragDrop then
  begin
    FCurrentDropTarget := nil;
    Exit;
  end;
  AItemIndex := GetDropTargetItemIndex;
  if AItemIndex = -1 then
  begin // There are no items selected, so drop target is current opened folder
    ANew := (FDropTargetItemIndex <> -1) or (FCurrentDropTarget = nil) or FIsDragging and ((FDragKeyState = MK_LBUTTON) xor (grfKeyState = MK_LBUTTON));
    FDragKeyState := grfKeyState;
    if ANew then
    begin
      TryReleaseDropTarget;
      if not FIsDragging or not ItemProducer.IsQuickAccess and (grfKeyState <> MK_LBUTTON) then
        if not ProvideDropTargetFromCurrentFolder(True) then
          FCurrentDropTarget := nil;
    end;
  end
  else
  begin // Use one of Items as Drop Target
    ANew := (AItemIndex <> FDropTargetRealItemIndex) or ((FDragKeyState = MK_LBUTTON) xor (grfKeyState = MK_LBUTTON));
    FDragKeyState := grfKeyState;
    if ANew then
    begin
      TryReleaseDropTarget;
      if IsDragOverDragSourceItem(AItemIndex) or not ProvideDropTargetFromItem(AItemIndex) then
      begin
        if (not FIsDragging or (grfKeyState <> MK_LBUTTON)) and
          not ProvideDropTargetFromCurrentFolder(False) then
            FCurrentDropTarget := nil;
      end
      else
        DropTargetItemIndex := AItemIndex;
    end;
  end;
  FDropTargetRealItemIndex := AItemIndex;
end;

procedure TdxCustomShellListView.DsmDoNavigate(var Message: TMessage);
begin
  AbsolutePIDL := PITemIDList(Message.WParam);
end;

procedure TdxCustomShellListView.DSMSynchronizeRoot(var Message: TMessage);
begin
  if not IsLoading then
    ShellRoot.Update(TcxCustomShellRoot(Message.WParam));
end;

procedure TdxCustomShellListView.DSMSystemShellChangeNotify(var Message: TMessage);
var
  AEventID: Integer;
  APIDL1, APIDL2: PItemIDList;
  APidls: PPidlList;
  ALock: THandle;
begin
  ALock := SHChangeNotification_Lock(Message.WParam, Message.LParam, APidls, AEventID);
  if ALock <> 0 then
  begin
    try
      APidl1 := GetPidlCopy(APidls^[0]);
      APidl2 := GetPidlCopy(APidls^[1]);
    finally
      SHChangeNotification_UnLock(ALock);
    end;
    if (FEventProcessingCount > 0) or FIsContextPopupProcessing then
    begin
      AddDefferedShellSystemEvent(AEventID, APidl1, APidl2);
      if (FEventProcessingCount = 0) and FIsInternalNewItemCreation and ((AEventID = SHCNE_MKDIR) or (AEventID = SHCNE_CREATE)) then
      begin
        DisposePidl(FStoredEditingItemPidl);
        FStoredEditingItemPidl := GetPidlCopy(GetLastPidlItem(APidl1));
      end
    end
    else
    begin
      Inc(FEventProcessingCount);
      try
        DoProcessSystemShellChange(AEventID, APidl1, APidl2);
      finally
        DisposePidl(APidl1);
        DisposePidl(APidl2);
        Dec(FEventProcessingCount);
      end;
      ProcessDefferedShellSystemEvents;
    end;
  end;
end;

procedure TdxCustomShellListView.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

function TdxCustomShellListView.GetItemAbsolutePIDL(AIndex: Integer): PItemIDList;
begin
  CheckShellRoot(ShellRoot);
  Result := ItemProducer.ItemInfo[AIndex].pidl;
  Result := ConcatenatePidls(ShellRoot.Pidl, Result);
end;

procedure TdxCustomShellListView.TranslationChanged;
begin
  inherited TranslationChanged;
  InitializeLocalizableSources;
end;

procedure TdxCustomShellListView.UpdateImages;
begin
  FNeedUpdateImages := True;
  TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
    procedure
    begin
      if FNeedUpdateImages then
      begin
        FInternalSmallImages.Reload;
        FNeedUpdateImages := False;
      end;
    end);
end;

procedure TdxCustomShellListView.WMPaint(var Message: TWMPaint);
begin
  if FIsCalculating then
    Message.Result := DefWindowProc(Handle, Message.Msg, TMessage(Message).WParam, TMessage(Message).LParam)
  else
    inherited;
end;

{ TdxShellListView }

constructor TdxShellListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 250;
  Height := 150;
end;

{ TdxShellListViewItemTask }

constructor TdxShellListViewItemTask.Create(AItem: TcxShellItemInfo);
begin
  inherited Create(AItem);
  FPidl := GetPidlCopy(AItem.pidl);
  FParentShellFolder := (AItem.ItemProducer as TdxShellListViewItemProducer).ShellFolder;
  FThumbnailSize := (AItem.ItemProducer as TdxShellListViewItemProducer).ListView.GetThumbnailScaledSize;
  FUseThumbnail := (AItem.ItemProducer as TdxShellListViewItemProducer).ListView.IsThumbnailView;
end;

destructor TdxShellListViewItemTask.Destroy;
begin
  FParentShellFolder := nil;
  DisposePidl(FPidl);
  if FHBitmap <> 0 then
    DeleteObject(FHBitmap);
  inherited Destroy;
end;

procedure TdxShellListViewItemTask.DoUpdateItem;
begin
  inherited DoUpdateItem;
  if FUseThumbnail then
  begin
    if FHBitmap = 0 then
      Item.ThumbnailIndex := -1
    else
      Item.ThumbnailIndex := (Item.ItemProducer as TdxShellListViewItemProducer).AddThumbnailToImageList(Item, FHBitmap, FThumbnailSize);
    Item.ThumbnailUpdated := True;
  end;
end;

procedure TdxShellListViewItemTask.DoWork;
begin
  inherited DoWork;
  if FUseThumbnail then
    FHBitmap := GetThumbnailBitmap;
end;

function TdxShellListViewItemTask.GetThumbnailBitmap: HBitmap;
var
  AFlags: Cardinal;
  AExtractor: IExtractImage;
  APathBuffer: array [0..1024] of WideChar;
  ASize: TSize;
  APriority: Cardinal;
  AItemImageFactory: IShellItemImageFactory;
begin
  Result := 0;
  if not IsWinVistaOrLater or not Succeeded(SHCreateItemFromIDList(AbsolutePidl, IID_IShellItemImageFactory, AItemImageFactory)) or
    not Succeeded(AItemImageFactory.GetImage(FThumbnailSize, 0, Result)) then
    if FParentShellFolder.GetUIObjectOf(0, 1, FPidl, IID_IExtractImage, nil, AExtractor) = S_OK then
    begin
      ASize := FThumbnailSize;
      APriority := IEIT_PRIORITY_NORMAL;
      AFlags := IEIFLAG_OFFLINE or IEIFLAG_QUALITY or IEIFLAG_ORIGSIZE;
      if Succeeded(AExtractor.GetLocation(APathBuffer, 255, APriority, ASize, 32, AFlags)) then
        AExtractor.Extract(Result);
    end;
end;

{ TdxShellTreeViewItemTask }

constructor TdxShellTreeViewItemTask.Create(AItem: TcxShellItemInfo);
begin
  inherited Create(AItem);
  FCheckSubItems := not AItem.IsSubitemsChecked and not AItem.IsRemovable;
  FParentShellFolder := (AItem.ItemProducer as TdxShellTreeViewItemProducer).ShellFolder;
  FEnumFlags := (AItem.ItemProducer as TdxShellTreeViewItemProducer).GetEnumFlags;
end;

destructor TdxShellTreeViewItemTask.Destroy;
begin
  FParentShellFolder := nil;
  inherited Destroy;
end;

procedure TdxShellTreeViewItemTask.DoUpdateItem;
begin
  inherited DoUpdateItem;
  if FCheckSubItems then
  begin
    Item.HasSubfolder := FHasSubItems;
    Item.IsSubitemsChecked := True;
  end;
end;

procedure TdxShellTreeViewItemTask.DoWork;
begin
  inherited DoWork;
  if FCheckSubItems then
    FHasSubItems := HasSubItems(FParentShellFolder, AbsolutePidl, FEnumFlags);
end;

{ TdxThumbnailAdornmentHelper }

class procedure TdxThumbnailAdornmentHelper.CheckInit;
begin
  if FMap = nil then
    Initialize;
end;

class procedure TdxThumbnailAdornmentHelper.DrawAdornment(DC: HDC; const ABounds: TRect;
  AAdornment: TdxThumbnailAdornmentKind; const ALFPainter: TcxCustomLookAndFeelPainter;
  const ADrawThumbnailProc: TdxDrawThumbnailProc);
begin
  if ABounds.IsEmpty then
    Exit;
  if IsWinVistaOrLater then
  begin
    CheckInit;
    case AAdornment of
      TdxThumbnailAdornmentKind.DropShadow:
        DrawWithDropShadow(DC, ABounds, ALFPainter, ADrawThumbnailProc);
      TdxThumbnailAdornmentKind.VideoSprockets:
        DrawWithVideoSprockets(DC, ABounds, ALFPainter, ADrawThumbnailProc);
    else
      ADrawThumbnailProc(DC, ABounds);
    end;
  end
  else
    ADrawThumbnailProc(DC, ABounds);
end;

class procedure TdxThumbnailAdornmentHelper.DrawWithDropShadow(DC: HDC;
  const ABounds: TRect; const ALFPainter: TcxCustomLookAndFeelPainter;
  const ADrawThumbnailProc: TdxDrawThumbnailProc);
var
  AImageBounds: TRect;
begin
  if FDropShadowImage <> nil then
    FDropShadowImage.Draw(DC, ABounds);
  AImageBounds := ABounds;
  AImageBounds.Deflate(GetAdornmentMargins(TdxThumbnailAdornmentKind.DropShadow));
  if not AImageBounds.IsEmpty then
    ADrawThumbnailProc(DC, AImageBounds);
end;

class procedure TdxThumbnailAdornmentHelper.DrawWithVideoSprockets(DC: HDC;
  const ABounds: TRect; const ALFPainter: TcxCustomLookAndFeelPainter;
  const ADrawThumbnailProc: TdxDrawThumbnailProc);
var
  AClipRect: TRect;
  fw, fh: Single;
  ASaveIndex: Integer;
  ACanvas: TdxGPCanvas;
begin
  if FVideoSprocketsImage = nil then
  begin
    ADrawThumbnailProc(DC, ABounds);
    Exit;
  end;
  fw := ABounds.Width / FVideoSprocketsImage.Width;
  fh := ABounds.Height / FVideoSprocketsImage.Height;
  AClipRect := TRect.Round(TdxRectF.Create(31 * fw, 10 * fh, 221 * fw, 135 * fh));
  AClipRect.Offset(ABounds.TopLeft);
  if not AClipRect.IsEmpty then
  begin
    ASaveIndex := SaveDC(DC);
    try
      if cxIntersectClipRect(DC, AClipRect) then
        ADrawThumbnailProc(DC, ABounds);
    finally
      RestoreDC(DC, ASaveIndex);
    end;
  end;
  ACanvas := TdxGPCanvas.Create(DC);
  try
    ACanvas.InterpolationMode := TdxGPInterpolationMode.imNearestNeighbor;
    FVideoSprocketsImage.StretchDraw(ACanvas, ABounds, FVideoSprocketsImage.ClientRect, nil);
  finally
    ACanvas.Free;
  end;
end;

class function TdxThumbnailAdornmentHelper.GetAdornmentKind(const AExtension: string): TdxThumbnailAdornmentKind;
const
	PERCEIVED_TYPE_CUSTOM         = -3; 
	PERCEIVED_TYPE_UNSPECIFIED    = -2; 
	PERCEIVED_TYPE_FOLDER         = -1; 
	PERCEIVED_TYPE_UNKNOWN        = 0;  
	PERCEIVED_TYPE_TEXT           = 1;  
	PERCEIVED_TYPE_IMAGE          = 2;  
	PERCEIVED_TYPE_AUDIO          = 3;  
	PERCEIVED_TYPE_VIDEO          = 4;  
	PERCEIVED_TYPE_COMPRESSED     = 5;  
	PERCEIVED_TYPE_DOCUMENT       = 6;  
	PERCEIVED_TYPE_SYSTEM         = 7;  
	PERCEIVED_TYPE_APPLICATION    = 8;  
	PERCEIVED_TYPE_GAMEMEDIA      = 9;  
	PERCEIVED_TYPE_CONTACTS       = 10; 
var
  ptype, pflag: DWORD;
  AKey: string;
begin
  if not IsWinVistaOrLater then
    Exit(TdxThumbnailAdornmentKind.NoAdornment);
  CheckInit;
  AKey := UpperCase(AExtension);
  if not FMap.TryGetValue(AKey, Result) then
  begin
    Result := TdxThumbnailAdornmentKind.NoAdornment;
    if dxAssocGetPerceivedType(PChar(AExtension), ptype, pflag, nil) = S_OK then
    begin
      case ptype of
        PERCEIVED_TYPE_VIDEO: Result := TdxThumbnailAdornmentKind.VideoSprockets;
        PERCEIVED_TYPE_IMAGE: Result := TdxThumbnailAdornmentKind.DropShadow;
      end;
    end;
    FMap.Add(AKey, Result);
  end;
end;

class function TdxThumbnailAdornmentHelper.GetAdornmentMargins(AAdornment: TdxThumbnailAdornmentKind): TRect;
begin
  Result.Empty;
  if not IsWinVistaOrLater then
    Exit;
  CheckInit;
  case AAdornment of
    TdxThumbnailAdornmentKind.DropShadow:
      if FDropShadowImage <> nil then
        Result := FDropShadowImage.Margins.Margin;
  end;
end;

class function TdxThumbnailAdornmentHelper.LoadThumbnailAdornmentImage(AGroupIconID: Integer): TdxSmartImage;
const
  LOAD_LIBRARY_AS_IMAGE_RESOURCE = $00000020;
var
  ALibrary: THandle;
  AResourceStream: TResourceStream;
  AMemoryStream: TMemoryStream;
  AIconID: Integer;
begin
  Result := nil;
  ALibrary := LoadLibraryEx('imageres.dll', 0, LOAD_LIBRARY_AS_IMAGE_RESOURCE);
  if ALibrary > 0 then
  begin
    AIconID := 0;
    AResourceStream := TResourceStream.CreateFromID(ALibrary, AGroupIconID, MAKEINTRESOURCE(RT_GROUP_ICON));
    try
      AMemoryStream := TMemoryStream.Create;
      try
        AMemoryStream.CopyFrom(AResourceStream, 0);
        if AMemoryStream.Size > 0 then
          AIconID := LookupIconIdFromDirectoryEx(AMemoryStream.Memory, True, 256, 256, 0);
      finally
        AMemoryStream.Free;
      end;
    finally
      AResourceStream.Free;
    end;
    if AIconID <> 0 then
    begin
      AResourceStream := TResourceStream.CreateFromID(ALibrary, AIconID, MAKEINTRESOURCE(RT_ICON));
      try
        AMemoryStream := TMemoryStream.Create;
        try
          AMemoryStream.CopyFrom(AResourceStream, 0);
          AMemoryStream.Position := 0;
          Result := TdxSmartImage.CreateFromStream(AMemoryStream);
          if Result.Empty or (Result.ImageDataFormat <> dxImagePng) then
            FreeAndNil(Result);
        finally
          AMemoryStream.Free;
        end;
      finally
        AResourceStream.Free;
      end;
    end;
    FreeLibrary(ALibrary);
  end;
end;

class procedure TdxThumbnailAdornmentHelper.Initialize;
var
  ACropBitmap: TBitmap;
  AImage: TdxSmartImage;
begin
  FMap := TDictionary<string, TdxThumbnailAdornmentKind>.Create;
  AImage := LoadThumbnailAdornmentImage(191);
  if AImage <> nil then
  try
    FDropShadowImage := TShadowImage.Create(nil);
    FDropShadowImage.Texture.Assign(AImage);
    FDropShadowImage.Margins.Margin := TRect.Create(4, 4, 8, 8);
  finally
    FreeAndNil(AImage);
  end;
  AImage := LoadThumbnailAdornmentImage(194);
  if AImage <> nil then
  try
    ACropBitmap := AImage.GetAsBitmap;
    try
      ACropBitmap.Height := 148;
      FVideoSprocketsImage := TdxPNGImage.CreateFromBitmap(ACropBitmap);
    finally
      ACropBitmap.Free;
    end;
  finally
    FreeAndNil(AImage);
  end;
end;

class procedure TdxThumbnailAdornmentHelper.Finalize;
begin
  FreeAndNil(FMap);
  FreeAndNil(FDropShadowImage);
  FreeAndNil(FVideoSprocketsImage);
end;

procedure Finalize;
begin
  TThumbnailOverlayImageHelper.Finalize;
  TdxThumbnailAdornmentHelper.Finalize;
end;

procedure TdxShellListViewItemProducer.TdxShellListViewEnumerateItemsTask.Complete;
begin
  if not Canceled then 
    inherited Complete;
end;

procedure TdxShellListViewItemProducer.TdxShellListViewEnumerateItemsTask.DoExecute;
var
  AEnum: IEnumIDList;
begin
  if not Producer.GetEnumerator(AEnum) then
    Exit;
  if IsWinSevenOrLater then
    dxIUnknown_SetSite(AEnum, Self);
  try
    TdxShellEnumHelper.DoEnumeration(AEnum,
      procedure(const APidl: PITemIDList)
      var
        AItems: TdxFastList;
      begin
        AItems := Producer.FEnumeratingItemPidls.LockList;
        try
          if Canceled or Producer.FIsItemsStoreFull then
            DisposePidl(APidl)
          else
            AItems.Add(APidl);
        finally
          Producer.FEnumeratingItemPidls.UnlockList;
        end;
      end,
      function: Boolean
      begin
        Result := Canceled or Producer.FIsItemsStoreFull;
      end);
  finally
    if IsWinSevenOrLater then
      dxIUnknown_SetSite(AEnum, nil);
  end;
end;

function TdxShellListViewItemProducer.TdxShellListViewEnumerateItemsTask.QueryContinue: HRESULT;
begin
  if Canceled or Producer.FIsItemsStoreFull then
    Result := S_FALSE
  else
    Result := S_OK;
end;

function TdxShellListViewItemProducer.TdxShellListViewEnumerateItemsTask.QueryService(const rsid, iid: TGuid;
  out Obj): HResult;
begin
  if Supports(Self, iid, Obj) then
    Result := S_OK
  else
    Result := E_NOTIMPL;
end;

constructor TdxShellListViewItemProducer.TdxShellListSortItemsTask.Create(
  AProducer: TcxCustomItemProducer);
begin
  inherited Create(AProducer);
  dxTestCheck(Producer.FSortingItems = nil, 'Producer.FSortingItems <> nil');
  Producer.FSortingItems := TdxFastList.Create;
  Producer.FSortingItems.Assign(Producer.Items);
end;

procedure TdxShellListViewItemProducer.TdxShellListSortItemsTask.DoExecute;
begin
  try
    FSortFunction := Producer.GetSortfunction();
    Producer.FSortingItems.Sort(Compare, False);
  except
    on E: EdxCancelSortException do;
  end;
end;

function TdxShellListViewItemProducer.TdxShellListSortItemsTask.Compare(AItem1, AItem2: Pointer): Integer;
begin
  Result := FSortFunction(AItem1, AItem2);
  if Canceled then
    raise EdxCancelSortException.Create('Sort canceled');
end;

{ TdxShellImageList }

constructor TdxShellImageList.Create(AOwner: TComponent);
begin
  CreateEx(AOwner, TdxShellImageListIconType.Small, nil);
end;

constructor TdxShellImageList.CreateEx(AOwner: TComponent; AIconType: TdxShellImageListIconType; AScaleFactor: TdxScaleFactor);
begin
  inherited Create(AOwner);
  FShellIconType := AIconType;
  ShareImages := True;
  FScaleFactor := TdxScaleFactor.Create;
  if AScaleFactor <> nil then
    FScaleFactor.Assign(AScaleFactor)
  else
    FScaleFactor.Assign(dxSystemScaleFactor); 
  SourceDPI := FScaleFactor.TargetDPI;
end;

destructor TdxShellImageList.Destroy;
begin
  FreeAndNil(FScaleFactor);
  inherited Destroy;
end;

procedure TdxShellImageList.ShellBeginUpdate;
begin
  if FShellUpdateCount = 0 then
    FShellNeedUpdate := False;
  Inc(FShellUpdateCount);
end;

procedure TdxShellImageList.ShellEndUpdate;
begin
 Dec(FShellUpdateCount);
 if FShellUpdateCount = 0 then
   try
    if FShellNeedUpdate then
      ShellRecreateHandle;
   finally
     FShellNeedUpdate := False;
   end;
end;

function TdxShellImageList.CreateHandle: HImageList;
begin
  Result := GetImageListHandle(ShellIconType);
end;

procedure TdxShellImageList.ShellRecreateHandle;
begin
  if [csLoading, csDestroying] * ComponentState <> [] then
    Exit;
  if FShellUpdateCount > 0 then
    FShellNeedUpdate := True
  else
  begin
    Handle := CreateHandle;
    if HandleAllocated then
      ImageList_SetBkColor(Handle, CLR_NONE);
  end;
end;

procedure TdxShellImageList.Loaded;
begin
  inherited Loaded;
  ShellRecreateHandle;
end;

procedure TdxShellImageList.ShellReload;
begin
  if IsWin10OrLater then
    ShellRecreateHandle;
end;

procedure TdxShellImageList.ScaleChanged(AScaleFactor: TdxScaleFactor);
begin
  if not FScaleFactor.Equals(AScaleFactor) and IsWin10OrLater then
  begin
    FScaleFactor.Assign(AScaleFactor);
    SourceDPI := FScaleFactor.TargetDPI;
    ShellRecreateHandle;
  end;
end;

function TdxShellImageList.GetShellIconIndex(const AFileName: string): Integer;
begin
  Result := TdxShellItemHelper.GetQuickIconIndexByName(AFileName);
  if (Result >= Count) or not HandleAllocated then
    ShellRecreateHandle;
end;

function TdxShellImageList.GetShellVisualIconSize: TSize;
begin
  Result := cxInvalidSize;
  if HandleAllocated and not ImageList_GetIconSize(Handle, Result.cx, Result.cy) then
    Result := cxInvalidSize;
end;

procedure TdxShellImageList.SetShellIconType(AValue: TdxShellImageListIconType);
begin
  if AValue <> FShellIconType then
  begin
    FShellIconType := AValue;
    ShellRecreateHandle;
  end;
end;

function TdxShellImageList.GetActualIconFlag: Integer;
begin
  case ShellIconType of
      TdxShellImageListIconType.Small: Result := SHIL_SMALL;
      TdxShellImageListIconType.Large: Result := SHIL_LARGE;
      TdxShellImageListIconType.ExtraLarge:  Result := SHIL_EXTRALARGE;
      TdxShellImageListIconType.Jumbo: Result := SHIL_JUMBO;
  else
    Result := SHIL_SMALL;
  end;
end;

function TdxShellImageList.GetActualIconSize: Integer;
begin
  case ShellIconType of
      TdxShellImageListIconType.Large: Result := FScaleFactor.Apply(DefaultLargeSize);
      TdxShellImageListIconType.ExtraLarge: Result := FScaleFactor.Apply(DefaultExtraLargeSize);
      TdxShellImageListIconType.Jumbo: Result := DefaultJumboSize;
  else
    Result := FScaleFactor.Apply(DefaultSmallSize);
  end;
end;

function TdxShellImageList.GetImageListHandle(AType: TdxShellImageListIconType): HImageList;
var
  ASize: Integer;
begin
  Result := 0;

  if Assigned(SHCreateIconImageList) then
  begin
    ASize := GetActualIconSize;
    if ASize > 0 then
      SHCreateIconImageList(ASize, IID_IImageList, Result); 
  end;

  if Result = 0 then
  begin
    ASize := GetActualIconFlag;
    if ASize >= 0 then
    begin
      if (ASize = SHIL_JUMBO) and not IsWinVistaOrLater then
        ASize := SHIL_EXTRALARGE;

      if IsWinXPOrLater then
        SHGetImageList(ASize, IID_IImageList, Result)
      else
      begin
        if ASize = SHIL_SMALL then
          Result := cxShellGetImageList(SHGFI_SMALLICON)
        else
          Result := cxShellGetImageList(SHGFI_LARGEICON);
      end;
    end;
  end;
end;


{ TdxShellSmallImageList }

constructor TdxShellSmallImageList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShareImages := True;
  FScaleFactor := TdxScaleFactor.Create;
  FScaleFactor.Assign(dxSystemScaleFactor);
  RecreateHandle;
  UpdateSourceDPI;
  ImageList_SetBkColor(Handle, CLR_NONE);
end;

destructor TdxShellSmallImageList.Destroy;
begin
  FreeAndNil(FScaleFactor);
  inherited Destroy;
end;

procedure TdxShellSmallImageList.Reload;
begin
  if IsWin10OrLater then
    RecreateHandle;
end;

procedure TdxShellSmallImageList.RecreateHandle;
var
  AImageList: HIMAGELIST;
begin
  if Assigned(SHCreateIconImageList) then
    SHCreateIconImageList(dxGetSystemMetrics(SM_CXSMICON, FScaleFactor), IID_IImageList, AImageList)
  else
    SHGetImageList(SHIL_SMALL, IID_IImageList, AImageList);
  Handle := AImageList;
end;

procedure TdxShellSmallImageList.ScaleChanged(AScaleFactor: TdxScaleFactor);
begin
  if IsWin10OrLater then
  begin
    FScaleFactor.Assign(AScaleFactor);
    UpdateSourceDPI;
    RecreateHandle;
  end;
end;

procedure TdxShellSmallImageList.UpdateSourceDPI;
begin
  SourceDPI := FScaleFactor.TargetDPI;
end;

{ TdxShellListViewRoot }

function TdxShellListViewRoot.GetParentWindow: HWND;
begin
  if TdxCustomShellListView(Owner).HandleAllocated then
    Result := TdxCustomShellListView(Owner).Handle
  else
    Result := 0;
end;

{ TdxShellTreeViewRoot }

function TdxShellTreeViewRoot.GetParentWindow: HWND;
begin
  if TdxCustomShellTreeView(Owner).HandleAllocated then
    Result := TdxCustomShellTreeView(Owner).Handle
  else
    Result := 0;
end;

function TdxCustomShellListViewReportOptions.IsAlwaysShowItemImageInFirstColumnStored: Boolean;
begin
  Result := not AlwaysShowItemImageInFirstColumn;
end;

function TdxCustomShellListViewReportOptions.IsRowSelectStored: Boolean;
begin
  Result := not RowSelect;
end;

procedure TdxShellListViewHintHelper.CorrectHintWindowRect(var ARect: TRect);
var
  ACellViewInfo: TdxListViewCellViewInfo;
begin
  inherited CorrectHintWindowRect(ARect);
  ACellViewInfo := Safe<TdxListViewCellViewInfo>.Cast(HintableObject);
  if not ((ACellViewInfo <> nil) and ACellViewInfo.TextLayout.IsTruncated and
    (ListView.ViewStyle in [TdxListViewStyle.Report, TdxListViewStyle.List])) then
  begin
    ARect := cxRectSetOrigin(ARect, GetMouseCursorPos);
    OffsetRect(ARect, 0, cxGetCursorSize.cy);
    if ListView.UseRightToLeftAlignment then
      ARect := cxRectOffsetHorz(ARect, -ARect.Width);
  end;
end;

{ TdxShellListViewIconOptions }

procedure TdxShellListViewIconOptions.DoAssign(ASource: TPersistent);
var
  AOptions: TdxShellListViewIconOptions;
begin
  inherited DoAssign(ASource);
  if Safe.Cast(ASource, TdxListViewIconOptions, AOptions) then
    IconSize := AOptions.IconSize;
end;

function TdxShellListViewIconOptions.GetIconSize: TcxShellIconSize;
begin
  Result := ShellListView.LargeIconSize;
end;

function TdxShellListViewIconOptions.GetShellListView: TdxCustomShellListView;
begin
  Result := TdxCustomShellListView(ListView);
end;

procedure TdxShellListViewIconOptions.SetIconSize(
  const AValue: TcxShellIconSize);
begin
  ShellListView.LargeIconSize := AValue;
end;

{ TdxShellListViewItemProducer.TdxShellListViewInternalTask }

function TdxShellListViewItemProducer.TdxShellListViewInternalTask.GetProducer: TdxShellListViewItemProducer;
begin
  Result := inherited Producer as TdxShellListViewItemProducer;
end;


initialization

  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, nil, Finalize);

finalization

  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, Finalize);

end.
