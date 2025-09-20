{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressQuantumTreeList                                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSQUANTUMTREELIST AND ALL        }
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

unit cxDBTL;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Windows, SysUtils, Classes, Variants, DB, Contnrs, Types,
  dxCore, dxCoreClasses, cxEdit, cxVariants,
  cxDBEdit, cxControls, cxClasses, cxDataStorage, cxCustomData, cxDB, cxDBData, cxDataUtils,
  cxInplaceContainer, cxEditDBRegisteredRepositoryItems, cxTL, cxTLData;

type
  TcxCustomDBTreeList = class;
  TcxDBTreeListColumn = class;
  TcxDBTreeListDataController = class;
  TcxDBTreeListOptionsData = class;

  TcxDBTreeListNode = class(TcxTreeListNode)
  private
    FKeyValue: Variant;
    FParentKeyValue: Variant;
  public
    property KeyValue: Variant read FKeyValue write FKeyValue;
    property ParentKeyValue: Variant read FParentKeyValue write FParentKeyValue;
  end;

  { TcxTreeListDataLink }

  TcxTreeListDataLink = class(TcxDBCustomDataLink)
  private
    FDataController: TcxDBTreeListDataController;
    FModified: Boolean;
    function GetDataBusy: Boolean;
    function GetDataLocate: Boolean;
    function GetOptionsData: TcxDBTreeListOptionsData;
    function GetTreeList: TcxCustomDBTreeList;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure EditingChanged; override;
    function FocusControl(Field: TField): Boolean; override;
    function GetIsDataSetBusyState: Boolean; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
  public
    constructor Create(ADataController: TcxDBTreeListDataController); virtual;

    property DataBusy: Boolean read GetDataBusy;
    property DataLocate: Boolean read GetDataLocate;
    property DataController: TcxDBTreeListDataController read FDataController;
    property Modified: Boolean read FModified write FModified;
    property OptionsData: TcxDBTreeListOptionsData read GetOptionsData;
    property TreeList: TcxCustomDBTreeList read GetTreeList;
  end;

  { TcxDBTreeListDataController }

  TcxDBTreeListDataController = class(TcxDataTreeListDataController)
  private
    FDataLink: TcxTreeListDataLink;
    FImageIndexField: TField;
    FImageIndexFieldName: string;
    FKeyField: TField;
    FKeyFieldName: string;
    FParentKeyField: TField;
    FParentKeyFieldName: string;
    FStateIndexFieldName: string;
    FStateIndexField: TField;
    FUpdateEditing: Boolean;
    FUpdateInserting: Boolean;
    function GetDataSet: TDataSet;
    function GetDataSource: TDataSource;
    function GetTreeList: TcxCustomDBTreeList;
    procedure SetDataSource(AValue: TDataSource);
    procedure SetImageIndexFieldName(const AValue: string);
    procedure SetKeyFieldName(const AValue: string);
    procedure SetParentKeyFieldName(const AValue: string);
    procedure SetStateIndexFieldName(const AValue: string);
  protected
    FInserting: Boolean;
    procedure AfterLoad; override;
    function CanLocateByNode(AOldNode, ANode: TcxDBTreeListNode): Boolean;
    procedure ClearInternalFields; virtual;
    function CreateDataLink: TcxTreeListDataLink; virtual;
    function CreateLoader: TcxTreeListStructureLoader; override;
    procedure DataScrolled(ADistance: Integer); override;
    procedure DeleteChildren(ANode: TcxTreeListNode); virtual;
    procedure DeleteNode(ANode: TcxTreeListNode); override;
    procedure DoCopyTo(AttachNode: TcxDBTreeListNode;
      AttachMode: TcxTreeListNodeAttachMode; ANodes: TList);
    procedure DoInitInsertingNode(ANode: TcxTreeListNode); override;
    function GetEditState: TcxDataControllerEditState; override;
    function GetFieldByName(const AFieldName: string): TField;
    function GetIsKeyFieldsEmpty: Boolean;
    function GetUniqueKeyValue(Delta: Integer = 0): Variant;
    function IsDataMode: Boolean; override;
    function IsFieldSupportsExpression(AField: TcxCustomDataField): Boolean; override;
    function IsSmartLoad: Boolean; override;
    procedure PostRecord; override;
    procedure PostValues; override;
    procedure SetFieldName(var AField: string; const AValue: string);
    procedure SetNodeParentValue(ANode: TcxDBTreeListNode; const AValue: Variant);
    procedure SyncFocused(ANode: TcxTreeListNode); override;
    procedure UpdateActive;
    procedure UpdateFocused; override;
    procedure UpdateInternalFields; virtual;

    property DataLink: TcxTreeListDataLink read FDataLink;
    property DBKeyField: TField read FKeyField;
    property DBParentField: TField read FParentKeyField;
    property DBStateIndexField: TField read FStateIndexField;
    property DBImageIndexField: TField read FImageIndexField;
    property IsKeyFieldsEmpty: Boolean read GetIsKeyFieldsEmpty;
    property UpdateEditing: Boolean read FUpdateEditing write FUpdateEditing;
    property UpdateInserting: Boolean read FUpdateInserting write FUpdateInserting;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Append; override;
    procedure Cancel; override;
    procedure CheckBrowseMode; override;
    procedure CreateAllItems(AMissingItemsOnly: Boolean = False); virtual;
    procedure Edit; override;
    procedure FocusControl(AItemIndex: Integer; var Done: Boolean); override;
    function GetFilterItemFieldName(AItem: TObject): string; override;
    function HasAllItems: Boolean;
    procedure Insert; override;
    function LocateByKey(const AKeyValue: Variant): Boolean;
    function LocateByKeyEx(const AKeyValue: Variant): Boolean;
    function SetEditValue(AItemIndex: Integer; const AValue: Variant;
      AEditValueSource: TcxDataEditValueSource): Boolean; override;

    property DataSet: TDataSet read GetDataSet;
    property TreeList: TcxCustomDBTreeList read GetTreeList;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ImageIndexField: string read FImageIndexFieldName write SetImageIndexFieldName;
    property ParentField: string read FParentKeyFieldName write SetParentKeyFieldName;
    property KeyField: string read FKeyFieldName write SetKeyFieldName;
    property StateIndexField: string read FStateIndexFieldName write SetStateIndexFieldName;
  end;

  { TcxDBTreeListDefaultValuesProvider }

  TcxDBTreeListDefaultValuesProvider = class(TcxCustomDBEditDefaultValuesProvider)
  public
    function IsDisplayFormatDefined(AIsCurrencyValueAccepted: Boolean): Boolean; override;
  end;

  { TcxDBItemDataBinding }

  TcxDBItemDataBinding = class(TcxCustomItemDataBinding, IUnknown)
  private
    FField: TField;
    FFieldName: string;
    function GetDataController: TcxDBTreeListDataController;
    function GetDefaultValuesProviderProperty: TcxDBTreeListDefaultValuesProvider;
    function GetFieldName: string;
    function GetTreeList: TcxCustomDBTreeList;
    procedure SetFieldName(const AValue: string);
  protected
    procedure Changed; virtual;
    procedure CheckFreeNotification(AComponent: TComponent); virtual;
    function DefaultRepositoryItem: TcxEditRepositoryItem; override;
    function GetDefaultCaption: string; override;
    function GetDefaultValuesProviderClass: TcxCustomEditDefaultValuesProviderClass; override;
    function GetDefaultValueTypeClass: TcxValueTypeClass; override;
    function GetFilterFieldName: string; override;
    function GetValueTypeClass: TcxValueTypeClass; override;
    procedure Init; override;
    procedure InitializeField;
    function IsDisplayFormatDefinedForColumn(AIgnoreSimpleCurrency: Boolean): Boolean;
    function IsValueTypeChangeable: Boolean; override;
    function IsValueTypeStored: Boolean; override;
    procedure UpdateExpressionState;
    // IUnknown
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;

    property DefaultValuesProvider: TcxDBTreeListDefaultValuesProvider read GetDefaultValuesProviderProperty;
  public
    procedure Assign(Source: TPersistent); override;

    property DataController: TcxDBTreeListDataController read GetDataController;
    property Field: TField read FField;
    property TreeList: TcxCustomDBTreeList read GetTreeList;
  published
    property FieldName: string read GetFieldName write SetFieldName;
  end;

  { TcxDBTreeListColumn }

  TcxDBTreeListColumn = class(TcxTreeListColumn)
  private
    function GetDataBinding: TcxDBItemDataBinding;
    function GetDataController: TcxDBTreeListDataController;
    function GetField: TField;
    procedure SetDataBinding(Value: TcxDBItemDataBinding);
  protected
    procedure AssignValueFromField(ANode: TcxTreeListNode);
    function GetDataBindingClass: TcxItemDataBindingClass; override;
    function GetEditValue: Variant; override;
    function GetIsCurrency: Boolean; override;
    function GetIsTextStored: Boolean; override;

    property DataController: TcxDBTreeListDataController read GetDataController;
    property Field: TField read GetField;
  published
    property DataBinding: TcxDBItemDataBinding read GetDataBinding write SetDataBinding;
  end;

  { TcxDBTreeListOptionsData }

  TcxDBTreeListOptionsData = class(TcxVirtualTreeListOptionsData)
  private
    FAutoCalcKeyValue: Boolean;
    FSmartRefresh: Boolean;
    FSyncMode: Boolean;
    function GetTreeList: TcxCustomDBTreeList;
    procedure SetSmartRefresh(AValue: Boolean);
    procedure SetSyncMode(AValue: Boolean);
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;

    property TreeList: TcxCustomDBTreeList read GetTreeList;
  published
    property AutoCalcKeyValue: Boolean read FAutoCalcKeyValue write FAutoCalcKeyValue default False;
    property SmartRefresh: Boolean read FSmartRefresh write SetSmartRefresh default False;
    property SyncMode: Boolean read FSyncMode write SetSyncMode default True;
    property SmartLoad;
  end;

  { TcxDBTreeListLoader }

  TcxDBTreeListLoader = class(TcxTreeListStructureLoader)
  private
    FDataSetBookmark: TObject;
    function GetDataController: TcxDBTreeListDataController;
    function GetDataSet: TDataSet;
    function GetTreeList: TcxCustomDBTreeList;
    function GetKeyField: TField;
    function GetKeyFieldName: string;
    function GetParentKeyField: TField;
    function GetParentKeyFieldName: string;
  protected
    CursorKey: Variant;
    CursorNode: TcxDBTreeListNode;
    HasChildren: TList;
    LoadingIndex: Integer;
    procedure AssignValues(ANode: TcxTreeListNode); override;
    procedure ClearNodeLinks(ANode: TcxTreeListNode); override;
    procedure DoLoad(ALoadingNode: TcxTreeListNode); override;
    function FindLoadedNode(const AParentValue: Variant; var AIndex: Integer): Boolean;
    function FindNode(var ANode: TcxDBTreeListNode; const AValue: Variant): Boolean;
    function GetImageIndex(ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType): Integer; override;
    function GetImageIndexAsInteger(AField: TField): Integer;
    function IsChildrenExist(ANode: TcxTreeListNode): Boolean; override;
    function IsExistKeyRoot(AParentValue: Variant): Boolean; virtual;
    procedure LoadLevel(ANode: TcxDBTreeListNode; const AParentValue: Variant; ANewNodes: TList);
    procedure LoadLevelBack(AParentValue: Variant);
    function LoadValues(const AKeyValue, AParentKeyValue: Variant): TcxDBTreeListNode;
    procedure RestorePos; override;
    procedure SavePos; override;
  public
    constructor Create(AOwner: TcxDataTreeListDataController); override;
    destructor Destroy; override;
    procedure Load(ANode: TcxTreeListNode); override;

    property DataController: TcxDBTreeListDataController read GetDataController;
    property DataSet: TDataSet read GetDataSet;
    property KeyField: TField read GetKeyField;
    property KeyFieldName: string read GetKeyFieldName;
    property ParentKeyField: TField read GetParentKeyField;
    property ParentKeyFieldName: string read GetParentKeyFieldName;
    property TreeList: TcxCustomDBTreeList read GetTreeList;
  end;


  TcxDBTreeListGetUniqueKeyValueEvent = procedure(Sender: TcxCustomDBTreeList; var KeyValue: Variant) of object;
  TcxDBTreeListInitInsertingRecordEvent = procedure(Sender: TcxCustomDBTreeList; AFocusedNode: TcxDBTreeListNode; var AHandled: Boolean) of object;

 { TcxDBTreeListSearchEngine }

  TcxDBTreeListSearchEngine = class(TcxTreeListSearchEngine) // for internal use
  type

    { TBoundMatcher }

    TBoundMatcher = class(TcxTreeListSearchEngine.TMatcher)
    public
      class function CompareKey(ANode: TcxTreeListNode; AData: Pointer): Boolean; static;
      class function Match(ARootNode: TcxTreeListNode; AData: Pointer): Boolean; static;
    end;

    { TBoundCustomSearchStrategy }

    TBoundCustomSearchStrategy = class(TcxTreeListSearchEngine.TCustomSearchStrategy)
    protected type

      { TItem }

      TItem = class
      public
        Key: Variant;
        Parent: Variant;
      end;

    strict private
      FStack: TObjectStack;
      FDataSet: TDataSet;
      FParentField: TField;
      FKeyField: TField;
      FTreeList: TcxCustomDBTreeList;
      procedure ClearStack;
    protected
      procedure BuildPath(AKey: Variant);
      function GetNodeByPath: TcxTreeListNode;
      procedure SearchInDataSet;
    public
      constructor Create(AArguments: PArguments); override;
      destructor Destroy; override;
    end;

    { TKeyBasedSearchStrategy }

    TKeyBasedSearchStrategy = class(TBoundCustomSearchStrategy)
    public
      function Execute: TcxTreeListNode; override;
    end;

    { TDataBasedSearchStrategy }

    TDataBasedSearchStrategy = class(TBoundCustomSearchStrategy)
    public
      function Execute: TcxTreeListNode; override;
    end;

  public
    class function ShouldSearchInDataSet(AArguments: TcxTreeListSearchEngine.PArguments): Boolean; virtual;
    class function GetTextMatchFunc(AArguments: TcxTreeListSearchEngine.PArguments): TcxTreeListSearchEngine.TMatchFunc; override;
    class function Search(AArguments: TcxTreeListSearchEngine.PArguments): TcxTreeListNode; override;
    class function SearchByData(AArguments: TcxTreeListSearchEngine.PArguments): TcxTreeListNode; static;
    class function SearchByKey(AArguments: TcxTreeListSearchEngine.PArguments): TcxTreeListNode; static;
    class function SearchByKeyAtLevel(ANode: TcxTreeListNode; const AKey: Variant): TcxTreeListNode; static;
  end;

  { TcxCustomDBTreeList }

  TcxCustomDBTreeList = class(TcxCustomDataTreeList)
  private type

    { TSyncNodeHelper }

    TSyncNodeHelper = class
    strict private
      FOwner: TcxCustomDBTreeList;
      FCount: Integer;
      FFlag: Boolean;
      procedure DisplayNodeByCurrentKey;
    public
      procedure Synchronize;
      constructor Create(AOnwer: TcxCustomDBTreeList);
    end;

  var
    FDataBusy: Boolean;
    FDataLocate: Boolean;
    FIsAppend: Boolean;
    FLockRefreshCount: Integer;
    FSyncNodeHelper: TSyncNodeHelper;
    FIsRefreshValues: Boolean;
    FRootValue: Variant;
    FUpdateFocused: Boolean;
    FUpdatingNode: TcxDBTreeListNode;
    FOnGetUniqueKeyValue: TcxDBTreeListGetUniqueKeyValueEvent;
    FOnInitInsertingRecord: TcxDBTreeListInitInsertingRecordEvent;
    function GetDataController: TcxDBTreeListDataController;
    function GetDataSet: TDataSet;
    function GetLoader: TcxDBTreeListLoader;
    function GetIsRefreshing: Boolean;
    function GetOptionsData: TcxDBTreeListOptionsData;
    procedure SetDataController(AValue: TcxDBTreeListDataController);
    procedure SetOptionsData(AValue: TcxDBTreeListOptionsData);
    procedure SetRootValue(const AValue: Variant);
    procedure InternalDisplayNodeByCurrentKey;
  protected
    procedure AssignData(ASource: TcxCustomTreeList; ARecreateBandsAndColumns: Boolean); override;
    function CanCreateAllItems: Boolean; override;
    procedure CreateAllItems(AMissingItemsOnly: Boolean = False); override;
    function CreateNode: TcxTreeListNode; override;
    procedure DataChanged; override;
    procedure DataModeChanged; override;
    procedure DoClear; override;
    procedure DoDeleteNode(ANode: TcxTreeListNode); override;
    procedure DeleteNodes(AList: TList); override;
    function DoInitInsertingNode(ANode: TcxDBTreeListNode): Boolean; virtual;
    procedure DoMoveTo(AttachNode: TcxTreeListNode;
      AttachMode: TcxTreeListNodeAttachMode; ANodes: TList; IsCopy: Boolean); override;
    function FindLoadedNodeByKeyValue(const AValue: Variant): TcxDBTreeListNode;
    procedure DisplayNodeByCurrentKey;
    function GetDataControllerClass: TcxCustomDataControllerClass; override;
    function GetOptionsDataClass: TcxControlOptionsDataClass; override;
    function GetTreeListColumnClass: TcxTreeListColumnClass; override;
    function HasAllItems: Boolean; override;
    function HasData: Boolean; override;
    procedure InitializeFields; override;
    function InsertNode(ARelative: TcxTreeListNode; IsAppend: Boolean): Boolean; override;
    function  InternalFindNode(const AKeyValue: Variant; AStartNode: TcxTreeListNode = nil;
      AExpandedOnly: Boolean = False; AForward: Boolean = True; ARefreshAll: Boolean = True): TcxDBTreeListNode; virtual;
    procedure InternalInsertNode(IsAppend: Boolean);
    function IsAutoCalcKeyValue: Boolean;
    function IsDataSettingsValid: Boolean; override;
    function IsNodeInserting(ANode: TcxTreeListNode): Boolean; override;
    function IsTreeListLocked: Boolean; override;
    procedure RefreshTree;
    procedure LoadListByID(const AKeyValue: Variant; AList: TList);
    procedure LoadListByNode(ANode: TcxDBTreeListNode; AList: TList);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure RefreshFields; override;
    function SupportCreateAllItems: Boolean; override;
    procedure UpdateFocusedNode(AColumn: TcxTreeListColumn); override;

    class function GetSearchEngineClass: TcxTreeListSearchEngineClass; override;

    procedure LockRefresh;
    procedure UnLockRefresh;

    property DataBusy: Boolean read FDataBusy write FDataBusy;
    property DataController: TcxDBTreeListDataController read GetDataController write SetDataController;
    property DataLocate: Boolean read FDataLocate write FDataLocate;
    property DataSet: TDataSet read GetDataSet;
    property IsRefreshing: Boolean read GetIsRefreshing;
    property IsRefreshValues: Boolean read FIsRefreshValues write FIsRefreshValues;
    property Loader: TcxDBTreeListLoader read GetLoader;
    property OptionsData: TcxDBTreeListOptionsData read GetOptionsData write SetOptionsData;
    property RootValue: Variant read FRootValue write SetRootValue;
    property UpdateFocused: Boolean read FUpdateFocused write FUpdateFocused;
    property UpdatingNode: TcxDBTreeListNode read FUpdatingNode write FUpdatingNode;
    property OnGetUniqueKeyValue: TcxDBTreeListGetUniqueKeyValueEvent read FOnGetUniqueKeyValue write FOnGetUniqueKeyValue;
    property OnInitInsertingRecord: TcxDBTreeListInitInsertingRecordEvent read FOnInitInsertingRecord write FOnInitInsertingRecord;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    // find
    function FindNodeByKeyValue(const AKeyValue: Variant; AStartNode: TcxTreeListNode = nil; AExpandedOnly: Boolean = False; AForward: Boolean = True): TcxDBTreeListNode;

    function GetColumnByFieldName(const AFieldName: string): TcxDBTreeListColumn;
    //
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    //
  end;

  { TcxDBTreeList }

  TcxDBTreeList = class(TcxCustomDBTreeList)
  public
    property Customizing;
    property ColumnCount;
    property Columns;
    property FocusedColumn;
    property FocusedNode;
    property HitTest;
    property IsEditing;
    property SelectionCount;
    property Selections;
    property Sorted;
    property SortedColumnCount;
    property SortedColumns;
    property TopVisibleNode;
    property VisibleColumnCount;
    property VisibleColumns;
    property VisibleCount;
  published
    property Align;
    property Anchors;
    property Bands;
    property BiDiMode;
    property BorderStyle;
    property Constraints;
    property Cursor;
    property DataController;
    property DateTimeHandling;
    property DefaultLayout;
    property DefaultRowHeight;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Filter;
    property FilterBox;
    property Filtering;
    property FindPanel;
    property Font;
    property HelpContext;
    property HelpKeyword;
    property HelpType;
    property Hint;
    property Images;
    property LookAndFeel;
    property Navigator;
    property OptionsBehavior;
    property OptionsCustomizing;
    property OptionsData;
    property OptionsSelection;
    property OptionsView;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property PopupMenus;
    property Preview;
    property RootValue;
    property ScrollbarAnnotations;
    property StateImages;
    property Styles;
    property TabOrder;
    property TabStop;
    property Visible;
    property NavigatorEvents;
    property OnAfterSummary;
    property OnBandHeaderClick;
    property OnBandPosChanged;
    property OnBandSizeChanged;
    property OnBeginDragNode;
    property OnCanFocusNode;
    property OnCanResize;
    property OnCanSelectNode;
    property OnChange;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnColumnHeaderClick;
    property OnColumnPosChanged;
    property OnColumnSizeChanged;
    property OnCompare;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnCustomDrawBackgroundCell;
    property OnCustomDrawBandCell;
    property OnCustomDrawBandHeaderCell;
    property OnCustomDrawDataCell;
    property OnCustomDrawFooterCell;
    property OnCustomDrawHeaderCell;
    property OnCustomDrawIndentCell;
    property OnCustomDrawIndicatorCell;
    property OnCustomDrawPreviewCell;
    property OnCustomizationFormVisibleChanged;
    property OnDataChanged;
    property OnDblClick;
    property OnDeletion;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEditValueChanged;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanded;
    property OnExpanding;
    property OnFilterControlDialogShow;
    property OnFilterCustomization;
    property OnFilterDialogShow;
    property OnFilterNode;
    property OnFindCriteriaBeforeChange;
    property OnFindCriteriaChanged;
    property OnFindPanelVisibilityChanged;
    property OnFocusedColumnChanged;
    property OnFocusedNodeChanged;
    property OnGetCellHint;
    property OnGetDragDropText;
    property OnGetLevelImages;
    property OnGetNodeHeight;
    property OnGetNodeImageIndex;
    property OnGetNodePreviewHeight;
    property OnGetScrollbarAnnotationHint;
    property OnGetSiteInfo;
    property OnGetStoredProperties;
    property OnGetStoredPropertyValue;
    property OnGetUniqueKeyValue;
    property OnHotTrackNode;
    property OnInitEdit;
    property OnInitEditValue;
    property OnInitFilteringDateRanges;
    property OnInitInsertingRecord;
    property OnInitStoredObject;
    property OnIsGroupNode;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLayoutChanged;
    property OnLeftPosChanged;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnMoveTo;
    property OnNodeChanged;
    property OnNodeCheckChanged;
    property OnPopulateCustomScrollbarAnnotationRowIndexList;
    property OnResize;
    property OnSelectionChanged;
    property OnSetStoredPropertyValue;
    property OnSorted;
    property OnSorting;
    property OnStartDock;
    property OnStartDrag;
    property OnSummary;
    property OnTopRecordIndexChanged;
    property OnUnDock;
    property PopupMenusEvents;
    property StylesEvents;
  end;

implementation

uses
  cxTLStrs, cxLike, cxEditDataRegisteredRepositoryItems, Math, RTLConsts;

const
  dxThisUnitName = 'cxDBTL';

type
  TDataSetAccess = class(TDataSet);
  TcxCustomDataFieldAccess = class(TcxCustomDataField);

function cxCompareByKeyValue(ANode1, ANode2: TcxDBTreeListNode): Integer;
begin
  Result := VarCompare(ANode1.KeyValue, ANode2.KeyValue);
end;

function cxCompareByParentKey(ANode1, ANode2: TcxDBTreeListNode): Integer;
begin
  Result := VarCompare(ANode1.ParentKeyValue, ANode2.ParentKeyValue);
end;

{ TcxTreeListDataLink }

constructor TcxTreeListDataLink.Create(
  ADataController: TcxDBTreeListDataController);
begin
  inherited Create; 
  FDataController := ADataController;
  VisualControl := True;
end;

procedure TcxTreeListDataLink.ActiveChanged;
begin
  if TreeList.DataLocate then Exit;
  TreeList.InternalClearAll;
  if Active then
  begin
    TreeList.ChangesLocked := True;
    try
      TreeList.InitializeFields;
    finally
      TreeList.ChangesLocked := False;
      TreeList.FullRefresh;
    end;
  end
  else
  begin
    DataController.ClearInternalFields;
    TreeList.LayoutChanged;
  end;
end;

procedure TcxTreeListDataLink.DataSetChanged;
begin
  if not DataController.IsDataLoaded and not DataController.LoadingInProcess and (TreeList.IsRefreshing or IsDataSetBusy) then
    TreeList.RefreshTree;
  if DataSet.State <> dsInsert then
    TreeList.UpdatingNode := nil;
  if IsDataSetBusy then
  begin
    DataSetScrolled(0);
    Exit;
  end;
  if DataLocate then
  begin
    TreeList.BeginUpdate;
    try
      TreeList.UpdateFocusedNode(nil);
    finally
      TreeList.EndUpdate;
    end;
    TreeList.DataLocate := False;
    Exit;
  end;
  if DataBusy or TreeList.IsRefreshing or (DataSet.State = dsEdit) or (DataSet.State = dsSetKey) then
    Exit;
  if not DataController.IsKeyFieldsEmpty and (DataSet.State = dsInsert) then
  begin
    if not DataController.FInserting then
      TreeList.InternalInsertNode(DataSet.EOF);
    Exit;
  end;
  TreeList.RefreshTree;
  FModified := False;
end;

procedure TcxTreeListDataLink.DataSetScrolled(Distance: Integer);
begin
  DataController.DataScrolled(Distance);
end;

procedure TcxTreeListDataLink.EditingChanged;
begin
  if TreeList.IsLocked then Exit;
  DataController.UpdateEditing := DataSet.State in dsEditModes;
  try
    if DataSet.State in dsEditModes then
      DataController.EditingNode := TreeList.FocusedNode
    else
      DataController.EditingNode := nil;
  finally
    DataController.UpdateEditing := False;
  end;
end;

function TcxTreeListDataLink.FocusControl(Field: TField): Boolean;
var
  I: Integer;
  ADone: Boolean;
begin
  ADone := False;
  Result := False;
  for I := 0 to TreeList.ColumnCount - 1 do
    if TcxDBTreeListColumn(TreeList.Columns[I]).DataBinding.Field = Field then
    begin
      DataController.FocusControl(TcxDBTreeListColumn(TreeList.Columns[I]).ItemIndex, ADone);
      if ADone then Break;
    end;
  if ADone then
    Result := True;
end;

function TcxTreeListDataLink.GetIsDataSetBusyState: Boolean;
begin
  Result := DataBusy or not DataController.IsDataLoaded;
end;

procedure TcxTreeListDataLink.LayoutChanged;
begin
  TreeList.DataChanged;
  DataSetChanged;
end;

procedure TcxTreeListDataLink.RecordChanged(Field: TField);
var
  I: Integer;
  AColumn: TcxTreeListColumn;
  AParentNode: TcxTreeListNode;
begin
  if not (DataSet.State in dsEditModes) or ((DataSet.State = dsInsert) and
    (TreeList.UpdatingNode = nil)) or DataController.UpdateInserting then Exit;
  if (TreeList.FocusedNode <> nil) and (Field = DataController.DBParentField) then
  begin
    TcxDBTreeListNode(TreeList.FocusedNode).ParentKeyValue := GetFieldValue(DataController.DBParentField);
    AParentNode := TreeList.InternalFindNode(TcxDBTreeListNode(TreeList.FocusedNode).ParentKeyValue, nil, False, True, False);
    if AParentNode = nil then
      AParentNode := TreeList.Root;
    if TreeList.FocusedNode.Parent <> AParentNode then
    begin
      TreeList.InternalMove(TreeList.FocusedNode, AParentNode, tlamAdd);
      if TreeList.OptionsData.SmartLoad then
        TreeList.Loader.Load(AParentNode);
    end;
    AParentNode.AlphaSort;
    TreeList.FocusedNode.MakeVisible;
  end;
  TreeList.BeginUpdate;
  try
    if Field = nil then
      TreeList.UpdateFocusedNode(nil)
    else
      for I := 0 to TreeList.ColumnCount - 1 do
      begin
        AColumn := TreeList.Columns[I];
        if TcxDBTreeListColumn(AColumn).DataBinding.Field = Field then
        begin
          TreeList.UpdateFocusedNode(AColumn);
          Break;
        end;
      end;
      DataController.IsValueChanged := True;
  finally
    TreeList.EndUpdate;
  end;
end;

procedure TcxTreeListDataLink.UpdateData;
var
  AIsValueChanged: Boolean;
begin
  AIsValueChanged := DataController.IsValueChanged;
  try
    TreeList.UpdateData;
    TreeList.UpdateFocusedNode(nil);
  finally
    DataController.IsValueChanged := AIsValueChanged;
    DataController.FInserting := False;
  end;
  if TreeList.Sorted then
    TreeList.AddChanges([tcSortOrder]);
end;

function TcxTreeListDataLink.GetDataBusy: Boolean;
begin
  Result := TreeList.DataBusy;
end;

function TcxTreeListDataLink.GetDataLocate: Boolean;
begin
  Result := TreeList.DataLocate;
end;

function TcxTreeListDataLink.GetOptionsData: TcxDBTreeListOptionsData;
begin
  Result := TreeList.OptionsData;
end;

function TcxTreeListDataLink.GetTreeList: TcxCustomDBTreeList;
begin
  Result := DataController.TreeList;
end;

{ TcxDBTreeListDataController }

constructor TcxDBTreeListDataController.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := CreateDataLink;
end;

destructor TcxDBTreeListDataController.Destroy;
begin
  FDataLink.Free;
  inherited Destroy;
end;

procedure TcxDBTreeListDataController.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TcxDBTreeListDataController then
  begin
    DataSource := TcxDBTreeListDataController(Source).DataSource;
    ParentField := TcxDBTreeListDataController(Source).ParentField;
    KeyField := TcxDBTreeListDataController(Source).KeyField;
    ImageIndexField := TcxDBTreeListDataController(Source).ImageIndexField;
    StateIndexField := TcxDBTreeListDataController(Source).StateIndexField;
  end;
end;

procedure TcxDBTreeListDataController.Append;
begin
  inherited Append;
  if DataSet <> nil then
    DataSet.Append;
end;

procedure TcxDBTreeListDataController.Cancel;
begin
  inherited Cancel;
  if DataLink.Active and not UpdateEditing then
  begin
    DataSet.Cancel;
    if not TreeList.IsRefreshing then
      TreeList.RefreshTree;
  end;
end;

procedure TcxDBTreeListDataController.CheckBrowseMode;
begin
  if not Assigned(DataSet) then Exit;
  if DataSet.State <> dsInactive then
    TDataSetAccess(DataSet).DataEvent(deCheckBrowseMode, 0);
  if DataSet.State in [dsEdit, dsInsert] then
  begin
    DataSet.UpdateRecord;
    if not DataSet.Modified or ((DataSet.State = dsInsert) and not IsValueChanged) then
      DataSet.Cancel
    else
      DataSet.Post;
  end;
end;

procedure TcxDBTreeListDataController.CreateAllItems(AMissingItemsOnly: Boolean = False);
var
  I: Integer;
  ABand: TcxTreeListBand;
  AColumn: TcxDBTreeListColumn;
begin
  if (DataSet = nil) or (DataSet.FieldCount = 0) then Exit;
  TreeList.SetGlassCursor;
  try
    TreeList.BeginUpdate;
    try
      ABand := TreeList.GetDefaultColumnContainer;
      for I := 0 to DataSet.FieldCount - 1 do
      begin
        if AMissingItemsOnly and (TreeList.GetColumnByFieldName(DataSet.Fields[I].FieldName) <> nil) then
          Continue;
        AColumn := TcxDBTreeListColumn(TreeList.CreateColumn(ABand));
        AColumn.DataBinding.FieldName := DataSet.Fields[I].FieldName;
        if TreeList.Owner <> nil then
          AColumn.Name := CreateUniqueName(TreeList.Owner, TreeList, AColumn,
            scxTLPrefixName, DataSet.Fields[I].FieldName);
        AColumn.Visible := DataSet.Fields[I].Visible;
      end;
    finally
      TreeList.EndUpdate;
    end;
  finally
    TreeList.RestoreCursor;
    TreeList.Modified;
  end;
end;

procedure TcxDBTreeListDataController.Edit;
begin
  if (DataSet = nil) or (DataSet.State = dsEdit) then Exit;
  if CanLocateByNode(nil, TcxDBTreeListNode(TreeList.FocusedNode)) then
    LocateByKey(TcxDBTreeListNode(TreeList.FocusedNode).KeyValue);
  DataLink.Edit;
  if DataSet.State <> dsEdit then Exit;
  inherited Edit;
end;

procedure TcxDBTreeListDataController.FocusControl(
  AItemIndex: Integer; var Done: Boolean);
begin
  TcxDBTreeListColumn(GetItem(AItemIndex)).Editing := True;
  Done := TcxDBTreeListColumn(GetItem(AItemIndex)).Editing;
end;

function TcxDBTreeListDataController.GetFilterItemFieldName(AItem: TObject): string;
var
  AColumn: TcxDBTreeListColumn absolute AItem;
begin
  if AColumn.Field <> nil then
    Result := GetFilterFieldName(AColumn.Field, True)
  else
    Result := AColumn.DataBinding.FieldName;
end;

function TcxDBTreeListDataController.HasAllItems: Boolean;
var
  I: Integer;
begin
  Result := (DataSet <> nil) and (DataSet.Fields.Count > 0);
  if not Result then
    Exit;
  for I := 0 to DataSet.Fields.Count - 1 do
    if TreeList.GetColumnByFieldName(DataSet.Fields[I].FieldName) = nil then
      Exit(False);
  Result := True;
end;

procedure TcxDBTreeListDataController.Insert;
begin
  inherited Insert;
  if DataSet <> nil then
    DataSet.Insert;
end;

function TcxDBTreeListDataController.LocateByKey(
  const AKeyValue: Variant): Boolean;
var
  ANode: TcxDBTreeListNode;
begin
  Result := False;
  if DataLink.Active then
  begin
    TreeList.DataBusy := not (DataSet.State in dsEditModes);
    TreeList.DataLocate := True;
    if (EditingNode <> nil) and not IsValueChanged then
      Cancel;
    try
      CheckBrowseMode;
      Result := TreeList.UpdateFocused or VarEquals(DBKeyField.Value, AKeyValue) or DataSet.Locate(KeyField, AKeyValue, []);
      if Result then
      begin
        ANode := TreeList.InternalFindNode(GetFieldValue(DBKeyField));
        if ANode <> nil then
        begin
          ANode.Focused := True;
          ANode.MakeVisible;
        end;
      end;
    finally
      TreeList.DataLocate := False;
      TreeList.DataBusy := False;
    end;
  end;
end;

function TcxDBTreeListDataController.LocateByKeyEx(const AKeyValue: Variant): Boolean;
begin
  Result := False;
  if DataLink.Active then
  begin
    TreeList.DataBusy := not (DataSet.State in dsEditModes);
    TreeList.DataLocate := True;
    if (EditingNode <> nil) and not IsValueChanged then
      Cancel;
    try
      CheckBrowseMode;
      Result := TreeList.UpdateFocused or DataSet.Locate(KeyField, AKeyValue, []);
    finally
      TreeList.DataLocate := False;
      TreeList.DataBusy := False;
    end;
  end;
end;

function TcxDBTreeListDataController.SetEditValue(AItemIndex: Integer;
  const AValue: Variant; AEditValueSource: TcxDataEditValueSource): Boolean;
var
  AColumn: TcxDBTreeListColumn;
begin
  Result := False;
  AColumn := TcxDBTreeListColumn(TreeList.ContainerList[AItemIndex]);
  if (DataSet.State in [dsInsert, dsEdit]) and (AColumn.Field <> nil) and (EditingNode <> nil) then
  begin
    if (AEditValueSource = evsText) or Assigned(AColumn.Field.OnSetText) then
      AColumn.Field.Text := VarToStr(AValue)
    else
      if (AEditValueSource = evsKey) and (AColumn.Field.KeyFields <> '') then
        AColumn.Field.DataSet.FieldValues[AColumn.Field.KeyFields] := AValue
      else
        SetFieldValue(AColumn.Field, AValue);
    Result := True;
    IsValueChanged := True;
  end;
end;

procedure TcxDBTreeListDataController.UpdateInternalFields;
begin
  FKeyField := GetFieldByName(KeyField);
  FParentKeyField := GetFieldByName(ParentField);
  FImageIndexField := GetFieldByName(ImageIndexField);
  FStateIndexField := GetFieldByName(StateIndexField);
end;

procedure TcxDBTreeListDataController.AfterLoad;
begin
  TreeList.DisplayNodeByCurrentKey;
  FInserting := False;
end;

function TcxDBTreeListDataController.CanLocateByNode(AOldNode, ANode: TcxDBTreeListNode): Boolean;
begin
  Result := TreeList.OptionsData.SyncMode and  not IsKeyFieldsEmpty and
    (ANode <> nil) and not DataLink.IsDataSetBusy and not TreeList.IsRefreshing;
  if not Result or ((AOldNode = ANode) and (GetFieldValue(DBKeyField) = ANode.KeyValue)) then Exit;
  Result := not ((ANode = TreeList.UpdatingNode) and
    DataLink.Active and (DataLink.DataSet.State = dsInsert));
end;

procedure TcxDBTreeListDataController.ClearInternalFields;
begin
  FKeyField := nil;
  FParentKeyField := nil;
  FImageIndexField := nil;
  FStateIndexField := nil;
end;

function TcxDBTreeListDataController.CreateDataLink: TcxTreeListDataLink;
begin
  Result := TcxTreeListDataLink.Create(Self);
end;

function TcxDBTreeListDataController.CreateLoader: TcxTreeListStructureLoader;
begin
  Result := TcxDBTreeListLoader.Create(Self);
end;

procedure TcxDBTreeListDataController.DataScrolled(ADistance: Integer);
var
  ANode: TcxTreeListNode;
begin
  if not TreeList.OptionsData.SyncMode then Exit;
  TreeList.UpdateFocused := True;
  UpdateActive;
  if IsSmartLoad and (ADistance <> 0) and not IsKeyFieldsEmpty then
  begin
    ANode := TreeList.InternalFindNode(GetFieldValue(DBKeyField));
    if ANode <> nil then
      ANode.MakeVisible;
  end;
  TreeList.UpdateFocused := False;
end;

procedure TcxDBTreeListDataController.DeleteChildren(ANode: TcxTreeListNode);
var
  I: Integer;
  AList: TList;
begin
  AList := TList.Create;
  try
    if not TreeList.OptionsData.SmartLoad then
      TreeList.LoadListByNode(TcxDBTreeListNode(ANode), AList)
    else
      TreeList.LoadListByID(TcxDBTreeListNode(ANode).KeyValue, AList);
    for I := AList.Count - 1 downto 0 do
      if LocateByKeyEx(PVariant(AList[I])^) then
        DataSet.Delete;
  finally
    for I := 0 to AList.Count - 1 do
      Dispose(AList[I]);
    AList.Free;
  end;
end;

procedure TcxDBTreeListDataController.DeleteNode(ANode: TcxTreeListNode);
begin
  DataSet.DisableControls;
  try
    if not ANode.HasChildren then
    begin
      if LocateByKeyEx(TcxDBTreeListNode(ANode).KeyValue) then
        DataSet.Delete
    end
    else
      DeleteChildren(ANode);
    inherited DeleteNode(ANode);
  finally
    DataSet.EnableControls;
  end;
end;

procedure TcxDBTreeListDataController.DoCopyTo(AttachNode: TcxDBTreeListNode;
  AttachMode: TcxTreeListNodeAttachMode; ANodes: TList);

type
  PNodeBuffer =^TNodeBuffer;
  TNodeBuffer = record
    Key: Variant;
    Buffer: Variant;
    Items: TList;
  end;

var
  F: TField;
  I: Integer;
  AFieldList, BufferList: TList;
  AKeyField, AParentField: TField;
  NewParentValue, KeyValue, Delta: Variant;

  function LoadBufferValues(const AKeyValue: Variant): PNodeBuffer;
  var
    I: Integer;
  begin
    New(Result);
    Result^.Items := nil;
    Result^.Key := AKeyValue;
    Result^.Buffer := VarArrayCreate([0, AFieldList.Count - 1], varVariant);
    for I := 0 to AFieldList.Count - 1 do
      Result^.Buffer[I] := GetFieldValue(TField(AFieldList[I]));
  end;

  procedure LoadSubItems(PBuffer: PNodeBuffer);
  var
    AParentValue: Variant;
    I: Integer;
  begin
    with DataSet do
    begin
      AParentValue := PBuffer^.Key;
      if Locate(ParentField, AParentValue, []) then
      begin
        PBuffer^.Items := TList.Create;
        while not EOF and (GetFieldValue(AParentField) = AParentValue) do
        begin
          PBuffer^.Items.Add(LoadBufferValues(GetFieldValue(AKeyField)));
          Next;
        end;
        for I := 0 to PBuffer^.Items.Count - 1 do
          LoadSubItems(PNodeBuffer(PBuffer^.Items[I]));
      end;
    end;
  end;

  procedure AddNewNode(PBuffer: PNodeBuffer; const AParentValue: Variant);
  var
    I: Integer;
    Key: Variant;
  begin
    with DataSet do
    begin
      Append;
      if AKeyField.IsNull and TreeList.OptionsData.AutoCalcKeyValue then
      begin
        SetFieldValue(AKeyField, GetUniqueKeyValue(Delta));
        Inc(Delta);
      end;
      SetFieldValue(AParentField, AParentValue);
      for I := 0 to AFieldList.Count - 1 do
        SetFieldValue(TField(AFieldList[I]), PBuffer^.Buffer[I]);
      Post;
      Key := GetFieldValue(AKeyField);
      if PBuffer^.Items <> nil then
        for I := 0 to PBuffer^.Items.Count - 1 do
          AddNewNode(PBuffer^.Items[I], Key);
    end;
  end;

  procedure FreeBuffer(PBuffer: PNodeBuffer);
  var
    I: Integer;
    L: TList;
  begin
    L := PBuffer^.Items;
    if L <> nil then
    begin
      for I := 0 to L.Count - 1 do
        FreeBuffer(L[I]);
      FreeAndNil(L);
    end;
    Dispose(PBuffer);
  end;

begin
  AParentField := DBParentField;
  AKeyField := DBKeyField;
  with DataSet do
  begin
    if AttachMode in [tlamAddChild, tlamAddChildFirst] then
      NewParentValue := AttachNode.KeyValue
    else
      NewParentValue := AttachNode.ParentKeyValue;
    DisableControls;
    try
      AFieldList := TList.Create;
      try
        for I := 0 to FieldCount - 1 do
        begin
          F := Fields[I];
          if F.FieldKind = fkLookup then
            F := FindField(F.KeyFields)
          else
          if (F = AKeyField) or (F = AParentField) or (F.FieldKind <> fkData) then
            F := nil;
          if Assigned(F) and F.CanModify then
            AFieldList.Add(F);
        end;
        if AFieldList.Count > 0 then
        begin
          ANodes.Sort(@cxCompareByParentKey);
          for I := ANodes.Count - 1 downto 1 do
            if TcxTreeListNode(ANodes[I]).HasAsParent(TcxTreeListNode(ANodes[I - 1])) then
              ANodes.Delete(I);
          BufferList := TList.Create;
          try
            for I := 0 to ANodes.Count - 1 do
            begin
              KeyValue := TcxDBTreeListNode(ANodes[I]).KeyValue;
              if Locate(KeyField, KeyValue, []) then
              begin
                BufferList.Add(LoadBufferValues(KeyValue));
                LoadSubItems(BufferList[I]);
              end;
            end;
            Delta := 0;
            for I := 0 to BufferList.Count - 1 do
              AddNewNode(BufferList[I], NewParentValue);
          finally
            for I := 0 to BufferList.Count - 1 do
              FreeBuffer(PNodeBuffer(BufferList[I]));
            FreeAndNil(BufferList);
          end;
        end;
      finally
        FreeAndNil(AFieldList);
      end;
    finally
      EnableControls;
    end;
  end;
end;

procedure TcxDBTreeListDataController.DoInitInsertingNode(
  ANode: TcxTreeListNode);
var
  AInit: Boolean;
begin
  UpdateInserting := True;
  try
    AInit := TreeList.DoInitInsertingNode(TcxDBTreeListNode(ANode));
    if not AInit and TreeList.IsAutoCalcKeyValue then
      SetFieldValue(DBKeyField, GetUniqueKeyValue(0))
    else
      if AInit then
      begin
        SetFieldValue(DBKeyField, TcxDBTreeListNode(ANode).KeyValue);
        SetFieldValue(DBParentField, TcxDBTreeListNode(ANode).ParentKeyValue);
      end;
  finally
    UpdateInserting := False;
  end;
  TreeList.Loader.AssignValues(ANode);
end;

function TcxDBTreeListDataController.GetEditState: TcxDataControllerEditState;
begin
  Result := [];
  if DataSet = nil then Exit;
  if DataSet.State in dsEditModes then
    Include(Result, dceEdit);
  if DataSet.State = dsInsert then
    Include(Result, dceInsert);
  if (Result <> []) and (IsValueChanged or DataSet.Modified) then
    Result := Result + [dceModified];
end;

function TcxDBTreeListDataController.GetFieldByName(
  const AFieldName: string): TField;
begin
  Result := nil;
  if DataSet <> nil then
    Result := DataSet.FindField(AFieldName);
end;

function TcxDBTreeListDataController.GetIsKeyFieldsEmpty: Boolean;
begin
  Result := not Assigned(DBParentField) or not Assigned(DBKeyField);
end;

function TcxDBTreeListDataController.GetUniqueKeyValue(
  Delta: Integer = 0): Variant;
var
  AList: TList;
begin
  Result := Null;
  if Assigned(TreeList.FOnGetUniqueKeyValue) then
    TreeList.FOnGetUniqueKeyValue(TreeList, Result)
  else
    if not TreeList.OptionsData.SmartLoad then
    try
      AList := TcxDBTreeListLoader(Loader).CloneList(TreeList.AbsoluteItemsList);
      try
        if not IsKeyFieldsEmpty and (AList.Count > 0) then
        begin
          AList.Sort(@cxCompareByKeyValue);
          Result := TcxDBTreeListNode(AList.Last).KeyValue;
        end;
      finally
        AList.Free;
      end;
      if VarType(Result) in [varSmallint, varInteger, varSingle, varDouble, varCurrency] then
        Result := Result + 1 + Delta
      else
        Result := 0;
    except
      Result := Null;
    end;
end;

function TcxDBTreeListDataController.IsDataMode: Boolean;
begin
  Result := True; 
end;

function TcxDBTreeListDataController.IsFieldSupportsExpression(AField: TcxCustomDataField): Boolean;
var
  AColumn: TcxDBTreeListColumn;
begin
  Result := inherited IsFieldSupportsExpression(AField);
  if Result and not AField.IsInternal then
  begin
    AColumn := TcxDBTreeListColumn(AField.Item);
    Result := (AColumn.DataBinding.FieldName = '') and (AColumn.DataBinding.Field = nil);
  end;
end;

function TcxDBTreeListDataController.IsSmartLoad: Boolean;
begin
  Result := TreeList.OptionsData.SmartLoad;
end;

procedure TcxDBTreeListDataController.PostRecord;
begin
  if (DataSet.State in dsEditModes) and not UpdateEditing then
  begin
    try
      TreeList.DataLocate := True;
      CheckBrowseMode;
    finally
      TreeList.DataLocate := False;
      TreeList.DataBusy := False;
    end;
    TreeList.RefreshTree;
  end;
end;

procedure TcxDBTreeListDataController.PostValues;
begin
end;

procedure TcxDBTreeListDataController.SetFieldName(
  var AField: string; const AValue: string);
begin
  if AField <> AValue then
  begin
    AField := AValue;
    TreeList.FullRefresh;
  end;
end;

procedure TcxDBTreeListDataController.SetNodeParentValue(
  ANode: TcxDBTreeListNode; const AValue: Variant);
begin
  if DataSet.Locate(KeyField, ANode.KeyValue, []) then
  begin
    DataSet.Edit;
    ANode.ParentKeyValue := AValue;
    SetFieldValue(DBParentField, AValue);
    DataSet.Post;
    if TreeList.OptionsData.SmartRefresh then
      Load(ANode);
  end;
end;

procedure TcxDBTreeListDataController.SyncFocused(ANode: TcxTreeListNode);
begin
  if TreeList.DataLocate or not CanLocateByNode(TcxDBTreeListNode(TreeList.Controller.PrevFocusedNode), TcxDBTreeListNode(ANode)) then Exit;
  try
    TreeList.DataLocate := True;
    CheckBrowseMode;
    if not VarEquals(TcxDBTreeListNode(ANode).KeyValue, GetFieldValue(DBKeyField)) then
      LocateByKey((ANode as TcxDBTreeListNode).KeyValue);
  finally
    TreeList.DataLocate := False;
    TreeList.DataBusy := False;
    if TreeList.FocusedNode <> EditingNode then
      EditingNode := nil;
  end;
end;

procedure TcxDBTreeListDataController.UpdateActive;
begin
  if not (DataLink.Active and DataLink.DataSet.Active) or TreeList.IsLoading then Exit;
  TreeList.DisplayNodeByCurrentKey;
  TreeList.UpdateData;
end;

procedure TcxDBTreeListDataController.UpdateFocused;
var
  ANode: TcxTreeListNode;
begin
  if IsKeyFieldsEmpty then
    Exit;
  ANode := TreeList.FindLoadedNodeByKeyValue(GetFieldValue(DBKeyField));
  if TreeList.UpdatingNode <> nil then
    ANode := TreeList.UpdatingNode;
  if ANode <> nil then
    ANode.Focused := True;
end;

function TcxDBTreeListDataController.GetDataSet: TDataSet;
begin
  if DataSource <> nil then
    Result := DataSource.DataSet
  else
    Result := nil;
end;

function TcxDBTreeListDataController.GetDataSource: TDataSource;
begin
  Result := DataLink.DataSource;
end;

function TcxDBTreeListDataController.GetTreeList: TcxCustomDBTreeList;
begin
  Result := TcxCustomDBTreeList(GetOwner)
end;

procedure TcxDBTreeListDataController.SetDataSource(AValue: TDataSource);
begin
  DataLink.DataSource := AValue;
  TreeList.DataChanged;
end;

procedure TcxDBTreeListDataController.SetImageIndexFieldName(
  const AValue: string);
begin
  SetFieldName(FImageIndexFieldName, AValue);
end;

procedure TcxDBTreeListDataController.SetKeyFieldName(const AValue: string);
begin
  SetFieldName(FKeyFieldName, AValue);
end;

procedure TcxDBTreeListDataController.SetParentKeyFieldName(
  const AValue: string);
begin
  SetFieldName(FParentKeyFieldName, AValue);
end;

procedure TcxDBTreeListDataController.SetStateIndexFieldName(
  const AValue: string);
begin
  SetFieldName(FStateIndexFieldName, AValue);
end;

{ TcxDBTreeListDefaultValuesProvider }

function TcxDBTreeListDefaultValuesProvider.IsDisplayFormatDefined(
  AIsCurrencyValueAccepted: Boolean): Boolean;
begin
  Result := TcxDBItemDataBinding(Owner).IsDisplayFormatDefinedForColumn(not AIsCurrencyValueAccepted);
end;

{ TcxDBItemDataBinding }

procedure TcxDBItemDataBinding.Assign(Source: TPersistent);
begin
  if Source is TcxDBItemDataBinding then
    FieldName := TcxDBItemDataBinding(Source).FieldName
  else
    inherited Assign(Source);
end;

procedure TcxDBItemDataBinding.Changed;
begin
  TreeList.RefreshFields;
  TreeList.AddDataChanges([dtcStructure]);
  TreeList.LayoutChanged;
end;

procedure TcxDBItemDataBinding.CheckFreeNotification(
  AComponent: TComponent);
begin
  if AComponent = FField then
  begin
    FField := nil;
    UpdateExpressionState;
  end;
end;

function TcxDBItemDataBinding.DefaultRepositoryItem: TcxEditRepositoryItem;
begin
  if (Field = nil) and (ValueTypeClass <> nil) then
    Result := inherited DefaultRepositoryItem
  else
    Result := GetDefaultEditDBRepositoryItems.GetItemByDataBinding(Field, Self);
end;

function TcxDBItemDataBinding.GetDefaultCaption: string;
begin
  if Field <> nil then
    Result := Field.DisplayName
  else
    Result := FieldName;
end;

function TcxDBItemDataBinding.GetDefaultValuesProviderClass: TcxCustomEditDefaultValuesProviderClass;
begin
  Result := TcxDBTreeListDefaultValuesProvider;
end;

function TcxDBItemDataBinding.GetDefaultValueTypeClass: TcxValueTypeClass;
begin
  Result := nil;
end;

function TcxDBItemDataBinding.GetFilterFieldName: string;
begin
  if Field = nil then
    Result := ''
  else
    Result := Field.FieldName;
end;

function TcxDBItemDataBinding.GetValueTypeClass: TcxValueTypeClass;
begin
  if Field = nil then
    Result := inherited GetValueTypeClass
  else
    Result := GetValueTypeClassByField(Field);
end;

procedure TcxDBItemDataBinding.Init;
begin
  InitializeField;
  DefaultValuesProvider.DataSource := DataController.DataSource;
  if DefaultValuesProvider.Field <> Field then
  begin
    DefaultValuesProvider.Field := Field;
    ValueTypeClassChanged;
  end;
  inherited Init;
end;

procedure TcxDBItemDataBinding.InitializeField;
begin
  FField := nil;
  if (DataController.DataSet <> nil) {and DataController.DataLink.Active} then
  begin
    FField := DataController.DataSet.FindField(FieldName);
    if FField <> nil then
      FField.FreeNotification(TreeList);
  end;
  UpdateExpressionState;
end;

function TcxDBItemDataBinding.IsDisplayFormatDefinedForColumn(AIgnoreSimpleCurrency: Boolean): Boolean;
begin
  Result := IsDisplayFormatDefined(not AIgnoreSimpleCurrency) or
    ((Field is TNumericField) and (TNumericField(Field).DisplayFormat <> ''));
  if Result and AIgnoreSimpleCurrency and IsSimpleCurrencyField(Field) then
    Result := False;
end;

function TcxDBItemDataBinding.IsValueTypeChangeable: Boolean;
begin
  Result := Field = nil;
end;

function TcxDBItemDataBinding.IsValueTypeStored: Boolean;
begin
  Result := Field = nil;
end;

procedure TcxDBItemDataBinding.UpdateExpressionState;
begin
  TcxCustomDataFieldAccess(DataController.Fields[EditContainer.ItemIndex]).UpdateExpressionState;
end;

function TcxDBItemDataBinding._AddRef: Integer;
begin
  Result := -1;
end;

function TcxDBItemDataBinding._Release: Integer;
begin
  Result := -1;
end;

function TcxDBItemDataBinding.QueryInterface(
  const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := cxE_NOINTERFACE;
end;

function TcxDBItemDataBinding.GetDataController: TcxDBTreeListDataController;
begin
  Result := TcxDBTreeListDataController(inherited DataController);
end;

function TcxDBItemDataBinding.GetDefaultValuesProviderProperty: TcxDBTreeListDefaultValuesProvider;
begin
  Result := inherited DefaultValuesProvider as TcxDBTreeListDefaultValuesProvider;
end;

function TcxDBItemDataBinding.GetFieldName: string;
begin
  if Field <> nil then
    Result := Field.FieldName
  else
    Result := FFieldName;
  FFieldName := Result;  
end;

function TcxDBItemDataBinding.GetTreeList: TcxCustomDBTreeList;
begin
  Result := DataController.TreeList; 
end;

procedure TcxDBItemDataBinding.SetFieldName(const AValue: string);
begin
  if AValue <> FieldName then
  begin
    FFieldName := AValue;
    if Field = nil then
      ResetValueTypeClass;
    Changed;
  end;
end;

{ TcxDBTreeListOptionsData }

constructor TcxDBTreeListOptionsData.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FSyncMode := True;
end;

procedure TcxDBTreeListOptionsData.Assign(Source: TPersistent);
begin
  if Source is TcxDBTreeListOptionsData then
  begin
    AutoCalcKeyValue := TcxDBTreeListOptionsData(Source).AutoCalcKeyValue;
    SmartRefresh := TcxDBTreeListOptionsData(Source).SmartRefresh;
    SyncMode := TcxDBTreeListOptionsData(Source).SyncMode;
  end;
  inherited Assign(Source);
end;

function TcxDBTreeListOptionsData.GetTreeList: TcxCustomDBTreeList;
begin
  Result := GetOwner as TcxCustomDBTreeList
end;

procedure TcxDBTreeListOptionsData.SetSmartRefresh(AValue: Boolean);
begin
  if SmartRefresh <> AValue then
  begin
    FSmartRefresh := AValue;
    TreeList.DataModeChanged;
  end;
end;

procedure TcxDBTreeListOptionsData.SetSyncMode(AValue: Boolean);
begin
  if SyncMode <> AValue then
  begin
    FSyncMode := AValue;
    TreeList.DataModeChanged;
  end;
end;

{ TcxDBTreeListColumn }

procedure TcxDBTreeListColumn.AssignValueFromField(ANode: TcxTreeListNode);
var
  AText: string;
begin
  AText := '';
  if Field <> nil then
  begin
    DataController.SetNodeValue(ANode, ItemIndex, GetFieldValue(Field));
    if IsTextStored then
      AText := Field.DisplayText;
  end
  else
    if IsExpression then
      DataController.ClearNodeValue(ANode, DataController.Fields[ItemIndex])
    else
      DataController.SetNodeValue(ANode, ItemIndex, Null);
  if IsTextStored then
    DataController.SetNodeDisplayText(ANode, ItemIndex, AText);
end;

function TcxDBTreeListColumn.GetDataBindingClass: TcxItemDataBindingClass;
begin
  Result := TcxDBItemDataBinding;
end;

function TcxDBTreeListColumn.GetEditValue: Variant;
var
  AEditValueSource: TcxDataEditValueSource;
begin
  Result := Null;
  if Assigned(Field) then 
  begin
    AEditValueSource := PropertiesValue.GetEditValueSource(True);
    if AEditValueSource = evsText then
    begin
      if Field.IsNull and not Assigned(Field.OnGetText) then
        Result := Null
      else
        Result := Field.Text;
    end
    else
      if (AEditValueSource = evsKey) and (Field.KeyFields <> '') then
        Result := Field.DataSet.FieldValues[Field.KeyFields]
      else
        if not Field.IsNull then
          Result := Field.Value; // evsValue
  end
  else
    Result := inherited GetEditValue;
end;

function TcxDBTreeListColumn.GetIsCurrency: Boolean;
begin
  Result := IsSimpleCurrencyField(Field);
end;

function TcxDBTreeListColumn.GetIsTextStored: Boolean;
begin
  Result := (Field <> nil) and IsFieldFormatted(Field, DataController.GetItemValueSource(ItemIndex) = evsText);
end;

function TcxDBTreeListColumn.GetDataBinding: TcxDBItemDataBinding;
begin
  Result := TcxDBItemDataBinding(inherited DataBinding);
end;

function TcxDBTreeListColumn.GetDataController: TcxDBTreeListDataController;
begin
  Result := TcxDBTreeListDataController(inherited DataController);
end;

function TcxDBTreeListColumn.GetField: TField;
begin
  Result := DataBinding.Field;
end;

procedure TcxDBTreeListColumn.SetDataBinding(Value: TcxDBItemDataBinding);
begin
  DataBinding.Assign(Value);
end;

{ TcxDBTreeListLoader }

constructor TcxDBTreeListLoader.Create(AOwner: TcxDataTreeListDataController);
begin
  inherited Create(AOwner);
  HasChildren := TList.Create;
  Loaded := TList.Create;
end;

destructor TcxDBTreeListLoader.Destroy;
begin
  HasChildren.Free; 
  Loaded.Free;
  inherited Destroy;
end;

procedure TcxDBTreeListLoader.Load(ANode: TcxTreeListNode);
var
  AIsChanges: Boolean;

  procedure InitializeHasChildrenItems;
  var
    I : Integer;
  begin
     for I := 0 to HasChildren.Count - 1 do
        TcxDBTreeListNode(HasChildren[I]).HasChildren := True;
     HasChildren.Clear;
  end;

  procedure StoreAbsoluteItemsList;
  begin
    TreeList.ChangesLocked := True;
    try
      dxCopyList(TreeList.AbsoluteItemsList, Loaded);
    finally
      TreeList.ChangesLocked := False;
    end;
    Loaded.Sort(@cxCompareByKeyValue);
  end;

  procedure RestoreAbsoluteItemsList;
  begin
    TreeList.ChangesLocked := True;
    try
      dxCopyList(Loaded, TreeList.AbsoluteItemsList); 
    finally
      TreeList.ChangesLocked := False;
    end;
    if AIsChanges then
      TreeList.CheckChanges;
  end;

begin
  AIsChanges := False;
  TreeList.DataBusy := True;
  try
    Loaded.Clear;
    HasChildren.Clear;
    StoreAbsoluteItemsList;
    if ANode = nil then
      Nodes := CloneList(Loaded);
    try
      TreeList.LockRefresh;
      try
        DataSet.DisableControls;
        try
          inherited Load(ANode);
        finally
          DataSet.EnableControls;
        end;
      finally
        TreeList.UnLockRefresh;
        DataController.FInserting := False;
        InitializeHasChildrenItems;
        if Nodes <> nil then
        begin
          Nodes.Sort(@cxCompareByParentKey);
          AIsChanges := True;
          InternalDelete(Nodes);
        end;
      end;
    finally
      RestoreAbsoluteItemsList;
      FreeAndNil(Nodes);
    end;
  finally
    TreeList.DataBusy := False;
  end;
end;

procedure TcxDBTreeListLoader.AssignValues(ANode: TcxTreeListNode);
var
  I: Integer;
  APrevIsChanged: Boolean;
begin
  TreeList.IsRefreshValues := True;
  try
    APrevIsChanged := DataController.IsValueChanged;
    inherited AssignValues(ANode);
    for I := 0 to TreeList.ColumnCount - 1 do
      TcxDBTreeListColumn(TreeList.Columns[I]).AssignValueFromField(ANode);
    with DataController do
    begin
      if Assigned(DBImageIndexField) then
        TcxDBTreeListNode(ANode).FImageIndexes[tlitImageIndex] := GetImageIndexAsInteger(DBImageIndexField);
      if Assigned(DBStateIndexField) then
        TcxDBTreeListNode(ANode).FImageIndexes[tlitStateIndex] := GetImageIndexAsInteger(DBStateIndexField);
    end;
    TcxDBTreeListNode(ANode).KeyValue := GetFieldValue(KeyField);
    TcxDBTreeListNode(ANode).ParentKeyValue := GetFieldValue(ParentKeyField);
    DataController.IsValueChanged := APrevIsChanged or (not ANode.Inserting and (DataSet.State in dsEditModes));
  finally
     TreeList.IsRefreshValues := False;
  end;
end;

procedure TcxDBTreeListLoader.ClearNodeLinks(ANode: TcxTreeListNode);
begin
  inherited ClearNodeLinks(ANode);
  if ANode = CursorNode then
    CursorNode := nil;
  if HasChildren <> nil then
    HasChildren.Remove(ANode);
end;

procedure TcxDBTreeListLoader.DoLoad(ALoadingNode: TcxTreeListNode);
var
  I, AIndex: Integer;
  ANode, APrev: TcxDBTreeListNode;
  AKeyValue, AParentKeyValue: Variant;
begin
  TreeList.ClearSelection;
  CursorNode := nil;
  if IsLoadAllRecords then
  begin
    LoadingIndex := 0;
    for I := 0 to Loaded.Count - 1 do
      TcxDBTreeListNode(Loaded[I]).SaveStateBeforeRefresh;
    DataSet.First;
    while not DataSet.EOF do
    begin
      LoadValues(GetFieldValue(KeyField), GetFieldValue(ParentKeyField));
      DataSet.Next;
    end;
    for I := 0 to Nodes.Count - 1 do
      Include(TcxDBTreeListNode(Nodes[I]).State, nsDeleting);
    ANode := TcxDBTreeListNode(Root.GetLastChild);
    while ANode <> nil do
    begin
      APrev := TcxDBTreeListNode(ANode.GetPrevSibling);
      if not ANode.Deleting and FindLoadedNode(ANode.ParentKeyValue, AIndex) and
        ANode.CanMove(TcxTreeListNode(Loaded.List[AIndex]), tlamAddChildFirst) then
        InternalMove(ANode, TcxTreeListNode(Loaded.List[AIndex]), tlamAddChildFirst);
      ANode := APrev;
    end;
    for I := 0 to Loaded.Count - 1 do
      TcxDBTreeListNode(Loaded[I]).RestoreStateAfterRefresh;
  end
  else
    if ALoadingNode = nil then
    begin
      AKeyValue := GetFieldValue(KeyField);
      AParentKeyValue := GetFieldValue(ParentKeyField);
      LoadLevel(nil, TreeList.RootValue, nil);
      Loaded.Sort(@cxCompareByKeyValue);
      if (KeyField <> ParentKeyField) and IsExistKeyRoot(AParentKeyValue) and
        not FindLoadedNode(AKeyValue, I) and (AParentKeyValue <> TreeList.RootValue) then
        LoadLevelBack(AParentKeyValue);
    end
    else
      LoadLevel(TcxDBTreeListNode(ALoadingNode), TcxDBTreeListNode(ALoadingNode).KeyValue, nil);
end;

function TcxDBTreeListLoader.FindLoadedNode(
  const AParentValue: Variant; var AIndex: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := Loaded.Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := VarCompare(TcxDBTreeListNode(Loaded.List[I]).KeyValue, AParentValue);
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  AIndex := L;
end;

function TcxDBTreeListLoader.FindNode(var ANode: TcxDBTreeListNode;
  const AValue: Variant): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  if Nodes = nil then Exit;
  L := 0;
  H := Nodes.Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    try
      ANode := TcxDBTreeListNode(Nodes.List[I]);
      C := VarCompare(ANode.KeyValue,  AValue);
      if C = 0 then
      begin
        Nodes.Delete(I);
        Result := True;
        Break;
      end
      else
        if C < 0 then
          L := I + 1
        else
          H := I - 1;
    except
      Result := False; // Variant Error
      Break;
    end;
  end;
end;

function TcxDBTreeListLoader.GetImageIndex(
  ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType): Integer;
begin
  Result := -1;
end;

function TcxDBTreeListLoader.GetImageIndexAsInteger(AField: TField): Integer;
begin
  if AField = nil then
    Result := -1
  else
    try
      Result := AField.Value
    except
      on EVariantError do Result := -1;
    end;
end;

function TcxDBTreeListLoader.IsChildrenExist(ANode: TcxTreeListNode): Boolean;
begin
  Result := not TreeList.OptionsData.CheckHasChildren or
    DataSet.Locate(ParentKeyFieldName, TcxDBTreeListNode(ANode).KeyValue, []);
end;

function TcxDBTreeListLoader.IsExistKeyRoot(AParentValue: Variant): Boolean;
var
  ARootValue: Variant;
begin
  Result := False;
  ARootValue := TreeList.RootValue;
  repeat
    if AParentValue = ARootValue then
    begin
      Result := True;
      Break;
    end;
    if not DataSet.Locate(KeyFieldName, AParentValue, []) or
      (GetFieldValue(KeyField) = GetFieldValue(ParentKeyField)) then Break;
    AParentValue := GetFieldValue(ParentKeyField);
  until False;
end;

procedure TcxDBTreeListLoader.LoadLevel(ANode: TcxDBTreeListNode;
  const AParentValue: Variant; ANewNodes: TList);
var
  I: Integer;
  AList: TList;
  AItem: TcxDBTreeListNode;
begin
  if not DataSet.Locate(ParentKeyFieldName, AParentValue, []) then Exit;
  AList := TList.Create;
  try
    while not DataSet.EOF and (GetFieldValue(ParentKeyField) = AParentValue) do
    begin
      AItem := LoadValues(GetFieldValue(KeyField), AParentValue);
      if ANewNodes <> nil then ANewNodes.Add(AItem);
      if ANode = nil then AList.Add(AItem);
      DataSet.Next;
    end;
    if ANode = nil then
    begin
      for I := 0 to AList.Count - 1 do
      begin
        AItem := TcxDBTreeListNode(AList[I]);
        if AItem.Expanded then
          LoadLevel(AItem, AItem.KeyValue, nil)
        else
          if IsChildrenExist(AItem) then HasChildren.Add(AItem);
      end;
    end
    else
    begin
      ANode := TcxDBTreeListNode(ANode.GetFirstChild);
      while ANode <> nil do
      begin
        if ANode.Expanded then
          LoadLevel(ANode, ANode.KeyValue, nil)
        else
          if IsChildrenExist(ANode) then HasChildren.Add(ANode);
        ANode := TcxDBTreeListNode(ANode.GetNextSibling);
      end;
    end;
  finally
    AList.Free;
  end;
end;

procedure TcxDBTreeListLoader.LoadLevelBack(AParentValue: Variant);
var
  I, AIndex: Integer;
  ANewNodes: TList;
  ANode: TcxDBTreeListNode;
begin
  ANewNodes := TList.Create;
  try
    repeat
      if FindLoadedNode(AParentValue, I) then
      begin
        LoadLevel(TcxDBTreeListNode(Loaded.List[I]), AParentValue, nil);
        Break;
      end
      else
      begin
        LoadLevel(nil, AParentValue, ANewNodes);
        if not DataSet.Locate(KeyFieldName, AParentValue, []) then Break;
        AParentValue := GetFieldValue(ParentKeyField);
      end;
    until False;
    for I := 0 to ANewNodes.Count - 1 do
    begin
      ANode := TcxDBTreeListNode(ANewNodes.List[I]);
      if FindLoadedNode(ANode.ParentKeyValue, AIndex) and
         ANode.CanMove(TcxDBTreeListNode(Loaded.List[AIndex]), tlamAddChild) then
        InternalMove(ANode, Loaded[AIndex], tlamAddChild);
    end;
  finally
    FreeAndNil(ANewNodes);
  end;
end;

function TcxDBTreeListLoader.LoadValues(
  const AKeyValue, AParentKeyValue: Variant): TcxDBTreeListNode;
var
  I: Integer;
  AFound: Boolean;
begin
  Result := nil;
  AFound := FindNode(Result, AKeyValue);
  if AFound then
  begin
    if DataController.IsSmartLoad then
    begin
      if (Result.ParentKeyValue <> AParentKeyValue) or
        ((Result.Parent <> Root) and (TcxDBTreeListNode(Result.Parent).KeyValue <> AParentKeyValue)) then
      begin
        if FindLoadedNode(AParentKeyValue, I) and Result.CanMove(TcxTreeListNode(Loaded.List[I]), tlamAddChild) then
          InternalMove(Result, TcxTreeListNode(Loaded.List[I]), tlamAddChild)
        else
          InternalMove(Result, Root, tlamAdd);
      end
    end
    else
    begin
      if ((Result.ParentKeyValue <> AParentKeyValue) or
        ((Result.Parent <> nil) and (Result.Parent <> Root) and (TcxDBTreeListNode(Result.Parent).KeyValue <> AParentKeyValue))) and
        FindLoadedNode(AParentKeyValue, I) and Result.CanMove(TcxTreeListNode(Loaded.List[I]), tlamAddChild) then
        InternalMove(Result, TcxTreeListNode(Loaded.List[I]), tlamAddChild)
      else
        InternalMove(Result, Root, tlamAdd);
    end;
  end
  else
  begin
    if DataController.IsSmartLoad and FindLoadedNode(AParentKeyValue, I) then
      Result := TcxDBTreeListNode(TcxTreeListNode(Loaded.List[I]).AddChild)
    else
      Result := TcxDBTreeListNode(TreeList.Root.AddChild);
  end;
  AssignValues(Result);
  Result.OriginalIndex := LoadingIndex;
  Inc(LoadingIndex);
  if (CursorNode = nil) and VarEquals(Result.KeyValue, CursorKey) then
    CursorNode := Result;
  Exclude(Result.State, nsInserting);
  if not AFound and not FindLoadedNode(Result.KeyValue, I) then
    Loaded.Insert(I, Result);
end;

procedure TcxDBTreeListLoader.SavePos;
begin
  if DataController.LoadingRefCount = 0 then
    CursorKey := KeyField.Value;
  inherited SavePos;
  FDataSetBookmark := cxDataSetCreateBookMark(DataSet);
end;

procedure TcxDBTreeListLoader.RestorePos;
begin
  inherited RestorePos;
  cxDataSetRestoreBookmark(DataSet, TcxDataSetBookmark(FDataSetBookmark));
end;

function TcxDBTreeListLoader.GetDataController: TcxDBTreeListDataController;
begin
  Result := TcxDBTreeListDataController(inherited DataController);
end;

function TcxDBTreeListLoader.GetDataSet: TDataSet;
begin
  Result := DataController.DataSet;
end;

function TcxDBTreeListLoader.GetTreeList: TcxCustomDBTreeList;
begin
  Result := TcxCustomDBTreeList(inherited TreeList);
end;

function TcxDBTreeListLoader.GetKeyField: TField;
begin
  Result := DataController.DBKeyField;
end;

function TcxDBTreeListLoader.GetKeyFieldName: string;
begin
  Result := DataController.KeyField;
end;

function TcxDBTreeListLoader.GetParentKeyField: TField;
begin
  Result := DataController.DBParentField;
end;

function TcxDBTreeListLoader.GetParentKeyFieldName: string;
begin
  Result := DataController.ParentField;
end;

{ TcxCustomDBTreeList }

constructor TcxCustomDBTreeList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRootValue := Integer(-1);
  FSyncNodeHelper := TSyncNodeHelper.Create(Self);
end;

destructor TcxCustomDBTreeList.Destroy;
begin
  BeginUpdate;
  DataController.DataSource := nil;
  FreeAndNil(FSyncNodeHelper);
  inherited Destroy;
end;

procedure TcxCustomDBTreeList.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TcxCustomDBTreeList then
    FRootValue :=  TcxCustomDBTreeList(Source).FRootValue;
end;

function TcxCustomDBTreeList.GetColumnByFieldName(const AFieldName: string): TcxDBTreeListColumn;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ColumnCount - 1 do
    if AnsiCompareText(TcxDBTreeListColumn(Columns[I]).DataBinding.FieldName, AFieldName) = 0 then
    begin
      Result := TcxDBTreeListColumn(Columns[I]);
      Break;
    end;
end;

procedure TcxCustomDBTreeList.AssignData(ASource: TcxCustomTreeList; ARecreateBandsAndColumns: Boolean);
begin
  inherited AssignData(ASource, ARecreateBandsAndColumns);
  if ASource is TcxCustomDBTreeList then
    DataController.DataSource := TcxCustomDBTreeList(ASource).DataController.DataSource;
end;

function TcxCustomDBTreeList.CanCreateAllItems: Boolean;
begin
  Result := DataSet <> nil;
end;

procedure TcxCustomDBTreeList.CreateAllItems(AMissingItemsOnly: Boolean = False);
begin
  DataController.CreateAllItems(AMissingItemsOnly);
end;

function TcxCustomDBTreeList.CreateNode: TcxTreeListNode;
begin
  Result := TcxDBTreeListNode.Create(Self);
  TcxDBTreeListNode(Result).OriginalIndex := DataController.NodesCount;
end;

procedure TcxCustomDBTreeList.DataChanged;
begin
  if DataController <> nil then
    DataController.UpdateInternalFields;
  inherited DataChanged;
end;

procedure TcxCustomDBTreeList.DataModeChanged;
begin
  if OptionsData.SmartLoad then
    OptionsData.SmartRefresh := False;
  inherited DataModeChanged;
end;

procedure TcxCustomDBTreeList.DoClear;
begin
  InternalClearAll;
end;

procedure TcxCustomDBTreeList.DoDeleteNode(ANode: TcxTreeListNode);
begin
  if ANode = UpdatingNode then
    UpdatingNode := nil;
  Loader.ClearNodeLinks(ANode);
  inherited DoDeleteNode(ANode);
end;

procedure TcxCustomDBTreeList.DeleteNodes(AList: TList);
begin
  DataSet.DisableControls;
  try
    inherited DeleteNodes(AList);
  finally
    DataSet.EnableControls;
  end;
end;

function TcxCustomDBTreeList.DoInitInsertingNode(ANode: TcxDBTreeListNode): Boolean;
begin
  Result := False;
  if (ANode <> nil) and (ANode <> Root) then
  begin
    if (ANode.Parent <> Root) and VarIsNull(DataController.DBParentField.Value) then
    begin
      ANode.ParentKeyValue := TcxDBTreeListNode(ANode.Parent).KeyValue;
      if VarIsEmpty(ANode.KeyValue) or VarIsNull(ANode.KeyValue) then
        ANode.KeyValue := DataController.DBKeyField.Value;
      Result := True;
    end;
  end
  else
    ANode := nil;
  //
  if Assigned(FOnInitInsertingRecord) then
    FOnInitInsertingRecord(Self, ANode, Result)
  else
    Result := Result and not IsAutoCalcKeyValue;
end;

procedure TcxCustomDBTreeList.DoMoveTo(AttachNode: TcxTreeListNode;
  AttachMode: TcxTreeListNodeAttachMode; ANodes: TList; IsCopy: Boolean);
var
  I: Integer;
  NewParentValue: Variant;
begin
  if AttachMode in [tlamAddChild, tlamAddChildFirst] then
    NewParentValue := TcxDBTreeListNode(AttachNode).KeyValue
  else
    NewParentValue := TcxDBTreeListNode(AttachNode).ParentKeyValue;
  if not IsCopy then
  begin
    inherited DoMoveTo(AttachNode, AttachMode, ANodes, IsCopy);
    DataController.DataSet.DisableControls;
    try
      for I := 0 to ANodes.Count - 1 do
        DataController.SetNodeParentValue(
            TcxDBTreeListNode(ANodes.List[I]), NewParentValue);
    finally
      DataController.DataSet.EnableControls;
    end;
  end
  else
  begin
    BeginUpdate;
    try
      DataController.DoCopyTo(TcxDBTreeListNode(AttachNode), AttachMode, ANodes);
    finally
      EndUpdate;
    end
  end;
  if OptionsData.SmartRefresh then
    DataChanged;
end;

function TcxCustomDBTreeList.FindNodeByKeyValue(
  const AKeyValue: Variant; AStartNode: TcxTreeListNode = nil;
  AExpandedOnly: Boolean = False; AForward: Boolean = True): TcxDBTreeListNode;
begin
  Result := InternalFindNode(AKeyValue, AStartNode, AExpandedOnly, AForward, False);
end;

function TcxCustomDBTreeList.FindLoadedNodeByKeyValue(
  const AValue: Variant): TcxDBTreeListNode;
var
  I: Integer;
  AList: TList;
begin
  Result := nil;
  if (FocusedNode <> nil) and VarEquals(TcxDBTreeListNode(FocusedNode).KeyValue, AValue) then
    Exit(TcxDBTreeListNode(FocusedNode))
  else
    if (UpdatingNode <> nil) and VarEquals(UpdatingNode.KeyValue, AValue) then
      Exit(UpdatingNode);
  AList := AbsoluteItemsList;
  for I := 0 to AList.Count - 1 do
    if VarEquals(TcxDBTreeListNode(AList.List[I]).KeyValue, AValue) then
      Exit(TcxDBTreeListNode(AList.List[I]));
end;

procedure TcxCustomDBTreeList.DisplayNodeByCurrentKey;
begin
  FSyncNodeHelper.Synchronize;
end;

procedure TcxCustomDBTreeList.InternalDisplayNodeByCurrentKey;
var
  ANode: TcxTreeListNode;
begin
  if DataLocate or DataBusy or
    DataController.IsKeyFieldsEmpty or
    (not OptionsData.SyncMode and not OptionsData.SmartLoad) or
    (DataSet.State in dsEditModes) then
      Exit;
  ANode := InternalFindNode(GetFieldValue(DataController.DBKeyField));
  if ANode <> nil then
  begin
    Controller.Select(ANode, []);
    ANode.MakeVisible;
  end;
end;

function TcxCustomDBTreeList.GetDataControllerClass: TcxCustomDataControllerClass;
begin
  Result := TcxDBTreeListDataController;
end;

function TcxCustomDBTreeList.GetOptionsDataClass: TcxControlOptionsDataClass;
begin
  Result := TcxDBTreeListOptionsData;
end;

function TcxCustomDBTreeList.GetTreeListColumnClass: TcxTreeListColumnClass;
begin
  Result := TcxDBTreeListColumn;
end;

function TcxCustomDBTreeList.HasAllItems: Boolean;
begin
  Result := DataController.HasAllItems;
end;

function TcxCustomDBTreeList.HasData: Boolean;
begin
  Result := inherited HasData and not DataController.IsKeyFieldsEmpty and DataController.DataLink.Active;
end;

procedure TcxCustomDBTreeList.InitializeFields;
var
  I: Integer;
begin
  DataController.UpdateInternalFields;
  for I := 0 to ColumnCount - 1 do
    TcxDBTreeListColumn(Columns[I]).DataBinding.InitializeField;
  inherited InitializeFields;
end;

function TcxCustomDBTreeList.InsertNode(ARelative: TcxTreeListNode; IsAppend: Boolean): Boolean;
var
  AModified: Boolean;
  AParentKeyValue: Variant;
begin
  Result := True;
  HideEdit();
  FIsAppend := IsAppend;
  DataController.FInserting := False;
  DataSet.DisableControls;
  try
    DataController.CheckBrowseMode;
    AParentKeyValue := Null;
    AModified := DataSet.Modified;
    if (ARelative = nil) and (FocusedNode <> nil) and IsAppend then
      ARelative := FocusedNode.Parent;
    if not DataSet.Eof then
    begin
      if IsAppend and (ARelative <> nil) and (ARelative <> Root) then
        AParentKeyValue := DataController.DBKeyField.Value
      else
        AParentKeyValue := DataController.DBParentField.Value;
    end;
    if IsAppend and (ARelative = Root) then
      DataSet.Append
    else
      DataSet.Insert;
    if not VarIsNull(AParentKeyValue) then
      DataController.DBParentField.Value := AParentKeyValue;
    TDataSetAccess(DataSet).SetModified(AModified);
  finally
    DataSet.EnableControls;
    FIsAppend := False;
    DataController.FInserting := False;
  end;
  ShowEdit;
end;

function TcxCustomDBTreeList.InternalFindNode(const AKeyValue: Variant;
  AStartNode: TcxTreeListNode = nil; AExpandedOnly: Boolean = False;
  AForward: Boolean = True; ARefreshAll: Boolean = True): TcxDBTreeListNode;
begin
  Result := nil;
  if (FocusedNode <> nil) and VarEquals(TcxDBTreeListNode(FocusedNode).KeyValue, AKeyValue) then
    Result := FocusedNode as TcxDBTreeListNode
  else
   if (Loader.CursorNode <> nil) and VarEquals(Loader.CursorNode.KeyValue, AKeyValue) then
     Result := Loader.CursorNode
    else
     if not (VarIsNull(AKeyValue) or (OptionsData.SmartLoad and VarEquals(AKeyValue, RootValue))) then
     begin
       Result := Find(@AKeyValue, AStartNode, AExpandedOnly, AForward, @TcxDBTreeListSearchEngine.TBoundMatcher.CompareKey) as TcxDBTreeListNode;
       if ARefreshAll and (Result = nil) and (UpdatingNode = nil) and not DataBusy and not IsRefreshing then
       begin
         RefreshTree;
         Result := Find(@AKeyValue, AStartNode, AExpandedOnly, AForward, @TcxDBTreeListSearchEngine.TBoundMatcher.CompareKey) as TcxDBTreeListNode;
       end;
     end;
end;

procedure TcxCustomDBTreeList.InternalInsertNode(IsAppend: Boolean);
var
  ANode: TcxDBTreeListNode;
begin
  if not IsDataSettingsValid or IsTreeListLocked then Exit;
  IsAppend := IsAppend or FIsAppend;
  InternalCreationAddRef;
  try
    if (FocusedNode <> nil) then
    begin
      if (FocusedNode.Parent <> nil) and IsAppend then
      begin
        if AppendToFocused then
          UpdatingNode := FocusedNode.AddChild as TcxDBTreeListNode
        else
          UpdatingNode := FocusedNode.Parent.AddChild as TcxDBTreeListNode
      end
      else
        UpdatingNode := TcxDBTreeListNode(AddNode(CreateNode, FocusedNode, nil, tlamInsert));
    end
    else
      UpdatingNode := Root.AddChild as TcxDBTreeListNode;
    DataController.DoInitInsertingNode(UpdatingNode);
    if not VarIsNull(UpdatingNode.ParentKeyValue) then
    begin
      ANode := InternalFindNode(UpdatingNode.ParentKeyValue);
      if ANode = nil then
        ANode := TcxDBTreeListNode(Root);
      if (UpdatingNode.Parent <> ANode) or IsAppend then
        UpdatingNode.MoveTo(ANode, tlamAddChild);
      if OptionsData.SmartLoad then
        Loader.Load(ANode);
    end
    else
    begin
      if not IsAppend and (FocusedNode <> nil) and (FocusedNode <> UpdatingNode) then
        UpdatingNode.MoveTo(FocusedNode, tlamInsert)
      else
        UpdatingNode.MoveTo(Root, tlamAddChild);
    end;
    if UpdatingNode = nil then Exit;
    if UpdatingNode.Parent <> nil then
      UpdatingNode.Parent.AlphaSort();
    UpdatingNode.Focused := True;
    UpdatingNode.MakeVisible;
    DataController.UpdateEditing := True;
    try
      DataController.EditingNode := UpdatingNode;
      DataController.IsValueChanged := False;
    finally
      DataController.UpdateEditing := False;
    end;
    ClearSelection;
  finally
    InternalCreationRelease;
  end;
  DataController.FInserting := True;
end;

function TcxCustomDBTreeList.IsAutoCalcKeyValue: Boolean;
begin
  Result := OptionsData.AutoCalcKeyValue and not OptionsData.SmartLoad;
end;

function TcxCustomDBTreeList.IsDataSettingsValid: Boolean;
begin
  Result := inherited IsDataSettingsValid and not IsLoading and not IsDestroying and
   (DataController.DataSet <> nil) and DataController.DataSet.Active and
    not DataController.IsKeyFieldsEmpty and not DataController.DataSet.ControlsDisabled;
end;

function TcxCustomDBTreeList.IsNodeInserting(ANode: TcxTreeListNode): Boolean;
begin
  Result := (ANode <> nil) and DataController.DataLink.Active and (DataSet.State = dsInsert) and
    (TcxDBTreeListNode(ANode).KeyValue = GetFieldValue(DataController.DBKeyField));
end;

function TcxCustomDBTreeList.IsTreeListLocked: Boolean;
begin
  Result := inherited IsTreeListLocked or IsRefreshValues or IsRefreshing;
end;

procedure TcxCustomDBTreeList.RefreshFields;
begin
  IsRefreshFields := True;
  try
    DataController.UpdateInternalFields;
    inherited RefreshFields;
  finally
    IsRefreshFields := False;
  end;
end;

function TcxCustomDBTreeList.SupportCreateAllItems: Boolean;
begin
  Result := True;
end;

procedure TcxCustomDBTreeList.UpdateFocusedNode(
  AColumn: TcxTreeListColumn);
begin
  DataController.UpdateFocused;
  if (FocusedNode <> nil) then
  begin
    Loader.AssignValues(FocusedNode);
    if (DataSet.State in dsEditModes) and not DataController.IsValueChanged then
      DataController.EditingNode := FocusedNode;
  end;
  inherited UpdateFocusedNode(AColumn);
end;

function TcxCustomDBTreeList.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := DataController.DataLink.ExecuteAction(Action);
end;

function TcxCustomDBTreeList.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := DataController.DataLink.UpdateAction(Action);
end;

procedure TcxCustomDBTreeList.LoadListByNode(
  ANode: TcxDBTreeListNode; AList: TList);
var
  P: PVariant;
  I: Integer;
begin
  New(P);
  P^ := ANode.KeyValue;
  AList.Add(P);
  for I := 0 to ANode.Count - 1 do
    LoadListByNode(TcxDBTreeListNode(ANode[I]), AList);
end;

procedure TcxCustomDBTreeList.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);
  if not (csDestroying in ComponentState) and (Operation = opRemove) then
  begin
    if AComponent is TField  then
      for I := 0 to ColumnCount - 1 do
        TcxDBTreeListColumn(Columns[I]).DataBinding.CheckFreeNotification(AComponent);
  end;
end;

function TcxCustomDBTreeList.GetIsRefreshing: Boolean;
begin
  Result := FLockRefreshCount <> 0;
end;

procedure TcxCustomDBTreeList.LockRefresh;
begin
  Inc(FLockRefreshCount);
end;

procedure TcxCustomDBTreeList.UnLockRefresh;
begin
  Dec(FLockRefreshCount);
end;

procedure TcxCustomDBTreeList.RefreshTree;
begin
  LockRefresh;
  try
    InitializeFields;
    DataController.Load(nil);
    ClearSelection;
  finally
    UnLockRefresh;
    DisplayNodeByCurrentKey;
  end;
  LayoutChanged;
end;

procedure TcxCustomDBTreeList.LoadListByID(
  const AKeyValue: Variant; AList: TList);
var
  P: PVariant;
  ATempList: TList;
  I: Integer;
begin
  New(P);
  P^ := AKeyValue;
  AList.Add(P);
  if not DataSet.Locate(DataController.ParentField, AKeyValue, []) then Exit;
  ATempList := TList.Create;
  try
    while not DataSet.Eof and (GetFieldValue(DataController.DBParentField) = AKeyValue) do
    begin
      New(P);
      P^ := GetFieldValue(DataController.DBKeyField);
      ATempList.Add(P);
      DataSet.Next;
    end;
    for I := 0 to ATempList.Count - 1 do
      LoadListByID(PVariant(ATempList[I])^, AList);
  finally
    for I := 0 to ATempList.Count - 1 do
      Dispose(ATempList[I]);
    ATempList.Free;
  end;             
end;

function TcxCustomDBTreeList.GetDataController: TcxDBTreeListDataController;
begin
  Result := TcxDBTreeListDataController(inherited DataController);
end;

function TcxCustomDBTreeList.GetDataSet: TDataSet;
begin
  if (DataController = nil) or (DataController.DataSource = nil) then
    Result := nil
  else
    Result := DataController.DataSource.DataSet;
end;

class function TcxCustomDBTreeList.GetSearchEngineClass: TcxTreeListSearchEngineClass;
begin
  Result := TcxDBTreeListSearchEngine;
end;

function TcxCustomDBTreeList.GetLoader: TcxDBTreeListLoader;
begin
  Result := inherited Loader as TcxDBTreeListLoader;
end;

function TcxCustomDBTreeList.GetOptionsData: TcxDBTreeListOptionsData;
begin
  Result := TcxDBTreeListOptionsData(inherited OptionsData); 
end;

procedure TcxCustomDBTreeList.SetDataController(
  AValue: TcxDBTreeListDataController);
begin
  DataController.Assign(AValue);
end;

procedure TcxCustomDBTreeList.SetOptionsData(AValue: TcxDBTreeListOptionsData);
begin
  OptionsData.Assign(AValue);
end;

procedure TcxCustomDBTreeList.SetRootValue(const AValue: Variant);
begin
  FRootValue := AValue;
  if OptionsData.SmartLoad then
    DataChanged;
end;

{ TcxDBTreeListSearchEngine }

class function TcxDBTreeListSearchEngine.GetTextMatchFunc(AArguments: TcxTreeListSearchEngine.PArguments): TcxTreeListSearchEngine.TMatchFunc;
begin
  if ShouldSearchInDataSet(AArguments) then
    Result := TBoundMatcher.Match
  else
    Result := TMatcher.Match
end;

class function TcxDBTreeListSearchEngine.ShouldSearchInDataSet(AArguments: TcxTreeListSearchEngine.PArguments): Boolean;
begin
  Result := AArguments.IsDefault and (AArguments.TreeList as TcxCustomDBTreeList).OptionsData.SmartLoad;
end;

class function TcxDBTreeListSearchEngine.Search(AArguments: TcxTreeListSearchEngine.PArguments): TcxTreeListNode;
var
  AUse: Boolean;
begin
  AUse := ShouldSearchInDataSet(AArguments);
  if AUse and (@AArguments.Match = @TBoundMatcher.CompareKey) then
    Result := SearchByKey(AArguments)
  else
    if AUse and (@AArguments.Match = @TBoundMatcher.Match) then
      Result := SearchByData(AArguments)
    else
      if (@AArguments.Match = @TMatcher.Match) or (@AArguments.Match = @TBoundMatcher.CompareKey) then
        Result := inherited Search(AArguments)
      else
        Result := inherited Search(AArguments); 
end;

class function TcxDBTreeListSearchEngine.SearchByKeyAtLevel(ANode: TcxTreeListNode; const AKey: Variant): TcxTreeListNode;
var
  AArguments: TcxTreeListSearchEngine.TArguments;
begin
  AArguments := TcxTreeListSearchEngine.TArguments.Create(ANode.TreeList, @AKey, ANode, nil, False, True, TBoundMatcher.CompareKey, False);
  Result := SearchAtLevel(@AArguments);
end;

class function TcxDBTreeListSearchEngine.SearchByData(AArguments: TcxTreeListSearchEngine.PArguments): TcxTreeListNode;
begin
  Result := Execute(TDataBasedSearchStrategy, AArguments);
end;

class function TcxDBTreeListSearchEngine.SearchByKey(AArguments: TcxTreeListSearchEngine.PArguments): TcxTreeListNode;
begin
  Result := Execute(TKeyBasedSearchStrategy, AArguments);
end;

{ TcxDBTreeListSearchEngine.TBoundMatcher }

class function TcxDBTreeListSearchEngine.TBoundMatcher.CompareKey(ANode: TcxTreeListNode; AData: Pointer): Boolean;
begin
  Result := VarEquals(TcxDBTreeListNode(ANode).KeyValue, PVariant(AData)^);
end;

class function TcxDBTreeListSearchEngine.TBoundMatcher.Match(ARootNode: TcxTreeListNode; AData: Pointer): Boolean;
var
  ANodeText: string;
  ATextInfo: TcxTreeListSearchEngine.TSearchTextInfo;
  AColumn: TcxDBTreeListColumn;
  I: Integer;
begin
  ATextInfo := TcxTreeListSearchEngine.TSearchTextInfo(AData);
  AColumn := ATextInfo.Column as TcxDBTreeListColumn;
  if AColumn <> nil then
  begin
    if AColumn.Field = nil then
      Exit(False);
    ANodeText := AColumn.Field.AsString;
  end
  else
  begin
    Assert(ARootNode <> nil);
    Assert(ATextInfo.Buffer <> nil);
    ATextInfo.Buffer.Clear;
    ANodeText := '';
    for I := 0 to ARootNode.TreeList.ColumnCount - 1 do
    begin
      AColumn := TcxDBTreeListColumn(ARootNode.TreeList.Columns[I]);
      if (AColumn <> nil) and (AColumn.Field <> nil) then
        ATextInfo.Buffer.Append(AColumn.Field.AsString);
    end;
    ANodeText := ATextInfo.Buffer.ToString;
  end;
  Result := ATextInfo.Match(ANodeText);
end;

{ TcxDBTreeListSearchEngine.TBoundCustomSearchStrategy }

constructor TcxDBTreeListSearchEngine.TBoundCustomSearchStrategy.Create(AArguments: PArguments);
begin
  inherited Create(AArguments);
  FStack := TObjectStack.Create;
  FTreeList := Arguments.TreeList as TcxCustomDBTreeList;
  FDataSet := FTreeList.DataController.DataSet;
  FKeyField := FDataSet.FieldByName(FTreeList.DataController.KeyField);
  FParentField := FDataSet.FieldByName(FTreeList.DataController.ParentField);
end;

destructor TcxDBTreeListSearchEngine.TBoundCustomSearchStrategy.Destroy;
begin
  ClearStack;
  FreeAndNil(FStack);
  inherited;
end;

procedure TcxDBTreeListSearchEngine.TBoundCustomSearchStrategy.ClearStack;
begin
  while FStack.Count > 0  do
    FStack.Pop.Free;
end;

procedure TcxDBTreeListSearchEngine.TBoundCustomSearchStrategy.BuildPath(AKey: Variant);
var
  AItem: TItem;
begin
  ClearStack;
  FDataSet.DisableControls;
  try
    while not VarEquals(AKey, FTreeList.RootValue) and FDataSet.Locate(FKeyField.FieldName, AKey, []) do
    begin
      AItem := TItem.Create;
      AItem.Key := FKeyField.AsVariant;
      AItem.Parent := FParentField.AsVariant;
      AKey := AItem.Parent;
      FStack.Push(AItem);
    end;
  finally
    FDataSet.EnableControls;
  end;
end;

function TcxDBTreeListSearchEngine.TBoundCustomSearchStrategy.GetNodeByPath: TcxTreeListNode;
var
  AItem: TItem;
begin
  if FStack.Count = 0 then
    Exit(nil);
  Result := FTreeList.Root;
  while (FStack.Count > 0) and (Result <> nil) do
  begin
    AItem := TItem(FStack.Pop);
    try
      Result := TcxDBTreeListSearchEngine.SearchByKeyAtLevel(Result, AItem.Key);
    finally
       AItem.Free;
    end;
  end;
end;

procedure TcxDBTreeListSearchEngine.TBoundCustomSearchStrategy.SearchInDataSet;
begin
  FDataSet.DisableControls;
  try
    FDataSet.First;
    while not FDataSet.Eof do
    begin
      if Arguments.Match(FTreeList.Root, Arguments.Data) then
      begin
        BuildPath(FKeyField.AsVariant);
        Break;
      end;
      FDataSet.Next;
    end;
  finally
    FDataSet.EnableControls;
  end;
end;

{ TcxDBTreeListSearchEngine.TKeyBasedSearchStrategy }

function TcxDBTreeListSearchEngine.TKeyBasedSearchStrategy.Execute: TcxTreeListNode;
begin
  BuildPath(PVariant(Arguments.Data)^);
  Result := GetNodeByPath;
end;

{ TcxDBTreeListSearchEngine.TDataBasedSearchStrategy }

function TcxDBTreeListSearchEngine.TDataBasedSearchStrategy.Execute: TcxTreeListNode;
begin
  SearchInDataSet;
  Result := GetNodeByPath;
end;

{ TcxCustomDBTreeList.TSyncNodeHelper }

constructor TcxCustomDBTreeList.TSyncNodeHelper.Create(
  AOnwer: TcxCustomDBTreeList);
begin
  inherited Create;
  FOwner := AOnwer;
end;

procedure TcxCustomDBTreeList.TSyncNodeHelper.DisplayNodeByCurrentKey;
begin
  FOwner.InternalDisplayNodeByCurrentKey;
end;

procedure TcxCustomDBTreeList.TSyncNodeHelper.Synchronize;
begin
  Inc(FCount);
  try
    if FCount > 1 then
      FFlag := True;
    if FFlag then
      Exit;
    try
      DisplayNodeByCurrentKey;
    finally
      if (FCount = 1) and FFlag then
      begin
        try
          DisplayNodeByCurrentKey;
        finally
          FFlag := False;
        end;
      end;
    end;
  finally
    Dec(FCount);
  end;
end;

end.
