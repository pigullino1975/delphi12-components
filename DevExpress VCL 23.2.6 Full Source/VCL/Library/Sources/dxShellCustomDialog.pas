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

unit dxShellCustomDialog;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Windows, Messages, Variants, Classes, Graphics, Controls, Forms, Dialogs, Menus, ComCtrls, ShlObj, StdCtrls,
  ShellAPI, ActiveX, ComObj, ImgList, Math, Types, SysUtils, Clipbrd,
  Actions,
  Generics.Collections, Generics.Defaults,
  dxCore, cxGraphics, cxControls, cxLookAndFeels, cxContainer, cxLookAndFeelPainters, cxClasses, dxCoreGraphics, dxForms,
  dxLayoutControl, dxLayoutContainer, dxLayoutControlAdapters, dxLayoutcxEditAdapters, dxLayoutLookAndFeels,
  cxEdit, cxTextEdit, dxBreadcrumbEdit, cxShellCommon, dxShellBreadcrumbEdit, cxButtons, cxMaskEdit, cxButtonEdit,
  cxDropDownEdit, cxImageList, dxShellControls, dxListView, ActnList, dxGenerics, dxCustomTree, dxTreeView, dxShellFilePreview,
  PropSys, dxAutoCompleteWindow, cxListBox;

type
  { TdxFileDialogPreviewOptions }

  TdxFileDialogPreviewOptions = class(TPersistent)
  strict private
    FDelay: Integer;
    FSources: TdxFilePreviewSources;
    FVisible: TdxDefaultBoolean;
    procedure SetDelay(AValue: Integer);
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Delay: Integer read FDelay write SetDelay default TdxFilePreviewPane.DefaultPreviewDelay;
    property Sources: TdxFilePreviewSources read FSources write FSources default TdxFilePreviewPane.DefaultFilePreviewSources;
    property Visible: TdxDefaultBoolean read FVisible write FVisible default bDefault;
  end;

  { TdxfrmCommonFileCustomDialog }

  TdxfrmCommonFileCustomDialog = class(TdxForm) // for internal use only
  strict private
    FForceFileSystem: Boolean;
    FDefaultExt: string;
    FFiles: TStringList;
    FLookAndFeel: TcxLookAndFeel;
    FOptions: TOpenOptions;
    FOnFileOkClick: TCloseQueryEvent;
    FOnFolderChange: TNotifyEvent;
    FOnIncludeItem: TIncludeItemEvent;
    FOnSelectionChange: TNotifyEvent;
    FOnTypeChange: TNotifyEvent;
    procedure UpdateSystemMenuItems(AMenu: HMENU);
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk); message WM_NCLBUTTONDBLCLK;
  protected
    FLoadedInitialDirPidl: PItemIDList;
    FLoadedSearchString: string;
    FInitializeDir: string;
    function GetFileName: string; virtual; abstract;
    function GetFilterIndex: Integer; virtual; abstract;
    function GetTitle: string; virtual; abstract;
    function GetViewStyle: TdxListViewStyle; virtual; abstract;
    procedure SetFileName(const AValue: string); virtual; abstract;
    procedure SetOptions(const AValue: TOpenOptions); virtual;
    procedure SetTitle(const AValue: string); virtual; abstract;
    procedure SetViewStyle(const AValue: TdxListViewStyle); virtual; abstract;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ApplyLocalization; virtual; abstract;
    procedure InitializeFilter(const AFilter: string; const AFilterIndex: Integer); virtual; abstract;
    procedure InitializeFolder(const AInitialDir: string); virtual; abstract;
    procedure SetHistoryList(AHistoryList: TStrings); virtual; abstract;
    procedure SetPreviewOptions(AValue: TdxFileDialogPreviewOptions); virtual; abstract;
    procedure WndProc(var Message: TMessage); override;

    property ForceFileSystem: Boolean read FForceFileSystem write FForceFileSystem;
    property DefaultExt: string read FDefaultExt write FDefaultExt;
    property FileName: string read GetFileName write SetFileName;
    property Files: TStringList read FFiles;
    property FilterIndex: Integer read GetFilterIndex;
    property LookAndFeel: TcxLookAndFeel read FLookAndFeel;
    property Options: TOpenOptions read FOptions write SetOptions;
    property Title: string read GetTitle write SetTitle;
    property OnFileOkClick: TCloseQueryEvent read FOnFileOkClick write FOnFileOkClick;
    property OnFolderChange: TNotifyEvent read FOnFolderChange write FOnFolderChange;
    property OnIncludeItem: TIncludeItemEvent read FOnIncludeItem write FOnIncludeItem;
    property OnSelectionChange: TNotifyEvent read FOnSelectionChange write FOnSelectionChange;
    property OnTypeChange: TNotifyEvent read FOnTypeChange write FOnTypeChange;
  end;
  TdxfrmCommonFileCustomDialogClass = class of TdxfrmCommonFileCustomDialog;

  { TdxfrmCommonFileDialog }

  TdxfrmCommonFileDialog = class(TdxfrmCommonFileCustomDialog, IdxLocalizerListener) // for internal use only
    lcMainGroup_Root: TdxLayoutGroup;
    lcMain: TdxLayoutControl;
    btnBack: TcxButton;
    libtnBack: TdxLayoutItem;
    btnForward: TcxButton;
    libtnForward: TdxLayoutItem;
    btnUp: TcxButton;
    libtnUp: TdxLayoutItem;
    lisbePath: TdxLayoutItem;
    lgNavigationAndSearch: TdxLayoutGroup;
    dxLayoutLookAndFeelList: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel: TdxLayoutCxLookAndFeel;
    lgFolders: TdxLayoutGroup;
    lgControls: TdxLayoutGroup;
    beSearch: TcxButtonEdit;
    libeSearch: TdxLayoutItem;
    btnOK: TcxButton;
    libtnOK: TdxLayoutItem;
    btnCancel: TcxButton;
    libtnCancel: TdxLayoutItem;
    cbName: TcxComboBox;
    licbName: TdxLayoutItem;
    cbFilter: TcxComboBox;
    licbFilter: TdxLayoutItem;
    lgButtons: TdxLayoutGroup;
    lgFilterAndButtons: TdxLayoutGroup;
    btnHistory: TcxButton;
    libtnHistory: TdxLayoutItem;
    liShellListView: TdxLayoutItem;
    liShellTreeView: TdxLayoutItem;
    dxLayoutSplitterItem: TdxLayoutSplitterItem;
    dxLayoutCxLookAndFeel_NoItemOffset: TdxLayoutCxLookAndFeel;
    lgNewFolderAndViews: TdxLayoutGroup;
    btnNewFolder: TcxButton;
    btnViews: TcxButton;
    libtnNewFolder: TdxLayoutItem;
    libtnViews: TdxLayoutItem;
    ilViews: TcxImageList;
    pmHistory: TPopupMenu;
    pmViews: TPopupMenu;
    pmiExtraLargeIcons: TMenuItem;
    pmiLargeIcons: TMenuItem;
    pmiMediumIcons: TMenuItem;
    pmiSmallIcons: TMenuItem;
    pmSeparator1: TMenuItem;
    pmiList: TMenuItem;
    pmSeparator2: TMenuItem;
    pmiDetails: TMenuItem;
    pmSeparator3: TMenuItem;
    pmiTiles: TMenuItem;
    pmSeparator4: TMenuItem;
    pmiContent: TMenuItem;
    alViews: TActionList;
    actExtraLarge: TAction;
    actLarge: TAction;
    actMedium: TAction;
    actSmall: TAction;
    actDetails: TAction;
    actList: TAction;
    alNavigation: TActionList;
    actBack: TAction;
    actForward: TAction;
    actUp: TAction;
    actNewFolder: TAction;
    liPreviewPane: TdxLayoutItem;
    liPreviewPaneSplitter: TdxLayoutSplitterItem;
    libtnFilePreview: TdxLayoutItem;
    btnFilePreview: TcxButton;
    liPathSplitter: TdxLayoutSplitterItem;
    actStartSearch: TAction;
    actStopSearch: TAction;
    ilSearch: TcxImageList;
    actFocusSearchEdit: TAction;
    alHistory: TActionList;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    //
    procedure DoButtonCustomDraw(Sender: TObject; ACanvas: TcxCanvas; AViewInfo: TcxButtonViewInfo; var AHandled: Boolean);
    procedure DoChooseFile(Sender: TObject; APIDL: PItemIDList; var AHandled: Boolean);
    procedure DoHistoryItemClick(Sender: TObject);
    procedure DoPopupBuiltInPopupMenu(Sender: TObject; var APopupMenu: TPopupMenu; var AHandled: Boolean);
    procedure DoShellListViewAfterNavigation(Sender: TdxCustomShellListView; APIDL: PItemIDList; ADisplayName: string);
    procedure DoShellTreeViewAddFolder(Sender: TObject; AFolder: TcxShellFolder; var ACanAdd: Boolean);
    procedure DoShellListViewAddFolder(Sender: TObject; AFolder: TcxShellFolder; var ACanAdd: Boolean);
    procedure DoViewClick(Sender: TObject);
    procedure DoViewChanged(Sender: TObject);
    //
    procedure actBackExecute(Sender: TObject);
    procedure actFocusSearchEditExecute(Sender: TObject);
    procedure actForwardExecute(Sender: TObject);
    procedure actNewFolderExecute(Sender: TObject);
    procedure actStartSearchExecute(Sender: TObject);
    procedure actStopSearchExecute(Sender: TObject);
    procedure actUpExecute(Sender: TObject);
    procedure beSearchEnter(Sender: TObject);
    procedure beSearchExit(Sender: TObject);
    procedure beSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure beSearchMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnViewsClick(Sender: TObject);
    procedure cbFilterPropertiesEditValueChanged(Sender: TObject);
    procedure sbePathPathSelected(Sender: TObject);
    procedure cbNamePropertiesChange(Sender: TObject);
    procedure cbNamePropertiesInitPopup(Sender: TObject);
    procedure sbePathPathValidate(Sender: TObject; const APath: string; var ANode: TdxBreadcrumbEditNode; var AErrorText: string; var AError: Boolean);
    procedure dxLayoutSplitterItemCanResize(Sender: TObject; AItem: TdxCustomLayoutItem; var ANewSize: Integer; var AAccept: Boolean);
    procedure btnFilePreviewClick(Sender: TObject);
    procedure beSearchPropertiesChange(Sender: TObject);
    procedure beSearchPropertiesEditValueChanged(Sender: TObject);
    procedure cbNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  strict private const
    SID_IShellItemBrowser = '{9536CA39-1ACB-4AE6-AD27-2403D04CA28F}';
    IID_IShellItemBrowser: TGUID = SID_IShellItemBrowser;
  strict private type
  {$REGION 'Private types'}
    TdxFileInfo = class
    private
      FFileName: string;
      FIsLink: Boolean;
      FPidl: PItemIDList;
      FTargetFileName: string;
      procedure SetPidl(AValue: PItemIDList);
    public
      destructor Destroy; override;
      property FileName: string read FFileName write FFileName;
      property IsLink: Boolean read FIsLink write FIsLink;
      property Pidl: PItemIDList read FPidl write SetPidl;
      property TargetFileName: string read FTargetFileName write FTargetFileName;
    end;

    TdxHistoryItem = class
    strict private
      FPidl: PItemIDList;
      FSelectedPidl: PItemIDList;
      private
        procedure SetSelectedPidl(AValue: PItemIDList);
    public
      constructor Create(APidl: PItemIDList);
      destructor Destroy; override;
      property Pidl: PItemIDList read FPidl;
      property SelectedPidl: PItemIDList read FSelectedPidl write SetSelectedPidl;
    end;

    TdxShellColumnInfo = record
      Width: Integer;
      ColumnId: SHCOLUMNID;
    end;

  {$TYPEINFO OFF}
    IShellItemBrowser = interface(IUnknown)
      [SID_IShellItemBrowser]
      function BrowseItem(AShellItem: IShellItem; A: UINT): HRESULT; stdcall;
      function GetCurrentItem(const AGuid: TGuid; out Obj): HRESULT; stdcall;
      function GetPendingItem(const AGuid: TGuid; out Obj): HRESULT; stdcall;
    end;
  {$TYPEINFO ON}

    TdxShellDialogTreeView = class(TdxCustomShellTreeView, IServiceProvider, IShellItemBrowser)
    strict private
      FOnExpandStateChanged: TdxTreeViewNodeEvent;
    protected
      // IServiceProvider
      function QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;
      // IShellItemBrowser
      function BrowseItem(AShellItem: IShellItem; A: UINT): HRESULT; stdcall;
      function GetCurrentItem(const AGuid: TGuid; out Obj): HRESULT; stdcall;
      function GetPendingItem(const AGuid: TGuid; out Obj): HRESULT; stdcall;
      //
      function AllowActivateEditByMouse: Boolean; override;
      procedure DoNodeExpandStateChanged(ANode: TdxTreeViewNode); override;
      function GetContextMenuSite: IUnknown; override;
      function GetDefaultScrollbarsValue: TcxScrollStyle; override;
      function HasGroups: Boolean; override;
      function IsFavoritesVisible: Boolean; override;
      procedure KeyDown(var Key: Word; Shift: TShiftState); override;
      procedure KeyPress(var Key: Char); override;
      property OnExpandStateChanged: TdxTreeViewNodeEvent read FOnExpandStateChanged write FOnExpandStateChanged;
    public
      constructor Create(AOwner: TComponent); override;
    end;

    TdxShellDialogListView = class(TdxCustomShellListView, IServiceProvider, IFolderView)
    strict private
      FGotDblClickMessage: Boolean;
      FIsColumnChanged: Boolean;
      FLastLeftMouseButtonDownTime: Cardinal;
      FLastLeftMouseButtonDownPos: TPoint;
      FHeaderPopup: TPopupMenu;
      FVisibleColumnInfos: TList<TdxShellColumnInfo>;
      procedure AddListViewVisibleColumn(Sender: TcxShellDetails; var AItemInfo: TcxDetailItem);
      procedure DoDetailItemClick(Sender: TObject);
      procedure DoMoreItemClick(Sender: TObject);
      function GetDialog: TdxfrmCommonFileDialog;
      procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    protected
      // IServiceProvider
      function QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;
      // IFolderView
      function GetCurrentViewMode(var pViewMode: UINT): HRESULT; stdcall;
      function SetCurrentViewMode(ViewMode: UINT): HRESULT; stdcall;
      function GetFolder(const riid: TIID; out ppv): HRESULT; stdcall;
      function Item(iItemIndex: Integer; var ppidl: PItemIDList): HRESULT; stdcall;
      function ItemCount(uFlags: UINT; var pcItems: Integer): HRESULT; stdcall;
      function Items(uFlags: UINT; const riid: TIID; out ppv): HRESULT; stdcall;
      function GetSelectionMarkedItem(var piItem: Integer): HRESULT; stdcall;
      function GetFocusedItem(var piItem: Integer): HRESULT; stdcall;
      function GetItemPosition(pidl: PItemIDList; var ppt: TPoint): HRESULT; stdcall;
      function GetSpacing(var ppt: TPoint): HRESULT; stdcall;
      function GetDefaultSpacing(var ppt: TPoint): HRESULT; stdcall;
      function GetAutoArrange: HRESULT; stdcall;
      function SelectItem(iItem: Integer; dwFlags: DWORD): HRESULT; stdcall;
      function SelectAndPositionItems(cidl: UINT; apidl: PItemIDList;
        var apt: TPoint; dwFlags: DWORD): HRESULT; stdcall;

      procedure CheckEmulateDblClick(X, Y: Integer);
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
      //
      procedure DoColumnPosChanged(AColumn: TdxListColumn); override;
      procedure DoColumnSizeChanged(AColumn: TdxListColumn); override;
      procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
      procedure DoCreateColumns; override;
      function GetContextMenuSite: IUnknown; override;
      procedure UpdateColumnInfos;
      procedure ViewStyleChanged; override;

      property Dialog: TdxfrmCommonFileDialog read GetDialog;
      property IsColumnChanged: Boolean read FIsColumnChanged write FIsColumnChanged;
      property VisibleColumnInfos: TList<TdxShellColumnInfo> read FVisibleColumnInfos;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    end;

    TdxShellDialogBreadcrumbEdit = class(TdxShellBreadcrumbEdit);

    TdxSearchControlInnerListBox = class(TdxCustomAutoCompleteInnerListBox)
    strict private
      FItemButtonImageIndex: Integer;
      FIsItemButtonPressed: Boolean;
      FOnItemButtonClick: TNotifyEvent;
      procedure DoItemButtonClick;
      function GetItemButtonRect(const AItemRect: TRect): TRect;
    protected
      function CanUpdateHotState: Boolean; override;
      procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); override;
      procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
      procedure DrawItemImage(const R: TRect; AItem: TdxCustomListBoxItem; AState: TcxButtonState); override;
      procedure DrawItemText(const R: TRect; AItem: TdxCustomListBoxItem; AState: TcxButtonState); override;
      function GetItemBackgroundRect(AItem: TdxCustomListBoxItem; const AItemRect: TRect): TRect; override;
      function GetItemTextRect(AItem: TdxCustomListBoxItem; const AItemRect: TRect): TRect; override;
      procedure InternalMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
      function IsSizeGripVisible: Boolean; override;
      function NeedHotTrack: Boolean; override;
      function ProcessNavigationKey(var Key: Word; Shift: TShiftState): Boolean; override;
    public
      function CalculateItemHeight: Integer; override;
      property ItemButtonImageIndex: Integer read FItemButtonImageIndex write FItemButtonImageIndex;
      property OnItemButtonClick: TNotifyEvent read FOnItemButtonClick write FOnItemButtonClick;
    end;

    TdxSearchControlPopup = class(TdxCustomAutoCompleteWindow)
    strict private
      FOnItemButtonClick: TNotifyEvent;
      procedure DoItemButtonClick(ASender: TObject);
      private
        function GetItemButtonImageIndex: Integer;
        procedure SetItemButtonImageIndex(const Value: Integer);
    protected
      function CreateInnerListBox: TdxCustomAutoCompleteInnerListBox; override;
      function NeedIgnoreMouseMessageAfterCloseUp(AWnd: THandle; AMsg: Cardinal;
        AShift: TShiftState; const APos: TPoint): Boolean; override;
    public
      constructor Create(AOwnerControl: TWinControl); override;
      property ItemButtonImageIndex: Integer read GetItemButtonImageIndex write SetItemButtonImageIndex;
      property OnItemButtonClick: TNotifyEvent read FOnItemButtonClick write FOnItemButtonClick;
    end;

    TdxDialogFilePreviewPane = class(TdxFilePreviewPane);
  {$ENDREGION}
  strict private
    FCanSyncPaths: Boolean;
    FFileTypes: TFileTypeItems;
    FFileInfos: TObjectList<TdxFileInfo>;
    FFileName: string;
    FFilterIndex: Integer;
    FHideFileExt: Boolean;
    FHistoryUpdateCount: Integer;
    FInitialDirPidl: PItemIDList;
    FIsFolderInitializing: Boolean;
    FIsSearching: Boolean;
    FIsSelectionChanging: Boolean;
    FIsSortColumnChanged: Boolean;
    FLockSearchControlChange: Integer;
    FMaxHistoryItemsCount: Integer;
    FPreviewPane: TdxDialogFilePreviewPane;
    FPreviewVisible: Boolean;
    FPreviewVisibility: TdxDefaultBoolean;
    FSavedFileName: string;
    FSearchControlPopup: TdxSearchControlPopup;
    FSearchControlPopupJustClosed: Boolean;
    FSearchNullStr: string;
    FSearchOriginDirPidl: PItemIDList;
    FSelectedChildPidl: PItemIDList;
    FShellListView: TdxShellDialogListView;
    FShellTreeView: TdxShellDialogTreeView;
    FShellBreadcrumbEdit: TdxShellDialogBreadcrumbEdit;
    FShowAllFolders: Boolean;
    function IsSelectableItem(AIndex: Integer): Boolean;
    procedure CheckHistoryItem(AItem: TAction);
    procedure DeleteSearchMRUItemButtonClick(ASender: TObject);
    procedure DeleteSearchMruItem(const AItem: string);
    procedure DoSearch(AAddSearchTextToHistory: Boolean = True);
    procedure DoShellTreeViewPathChanged(Sender: TObject);
    procedure DoShellTreeViewNodeExpandStateChanged(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
    procedure DoStopSearch;
    procedure DrawSearchEditButton(Sender: TcxEditButtonViewInfo;
      ACanvas: TcxCanvas; var AHandled: Boolean);
    procedure EnsureSearchPopup;
    function HasPreview: Boolean;
    function GetCheckedHistoryItemIndex: Integer;
    function GetCurrentPidl: PItemIDList;
    function GetInitialDir: string;
    function GetIsColumnChanged: Boolean;
    function GetViewStatePropertyBag(APidl: PItemIDList; out APropertyBag: IPropertyBag): Boolean;
    function GetFileMask: string;
    function GetSearchMRUItems: TStrings;
    function GetShellListViewSelectedItemIndices: TdxIntegerList;
    function GetCurrentFilterExtensions: TStrings;
    procedure InitializeLocalizableSources;
    procedure PasteFileNameFromClipboard;
    function ReadExpandedState(APersistStream: IPersistStream): Boolean;
    procedure RepopulateSearchPopup;
    procedure RestoreExpandedState;
    procedure RestoreInitialDir;
    procedure SearchEditResize(ASender: TObject);
    procedure SearchPopupClosed(ASender: TObject);
    procedure SelectSearchPopupItem(ASender: TObject);
    procedure SetFileTypes(const AValue: TFileTypeItems);
    procedure SetPreviewVisible(AValue: Boolean);
    procedure ShellBreadcrumbResize(Sender: TObject);
    class function SplitQuotedFilesStr(const AStr: string; out AResult: TArray<string>): Boolean;
    procedure StoreExpandedState;
    procedure StoreFileNameToMRUList;
    procedure StoreInitialDir;
    procedure StorePreviewPaneInfo;
    procedure StoreRecentPaths;
    procedure StoreSearchText;
    procedure SyncTreeView(APIDL: PItemIDList);
    procedure SyncWithTreeView;
    procedure UpdatePreviewFile;
    procedure UpdateSearchEdit;
    procedure UpdateSelectedFilesInfo;
    procedure ViewChanged;
    procedure WriteExpandedState(APersistStream: IPersistStream);
    //
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMAppCommand(var Msg: TMessage); message WM_APPCOMMAND;
  protected
    procedure AddToRecentDocs(const APidl: PItemIDList; const AName: string); virtual; abstract;
    procedure ApplyFilter(const AIndex: Integer);
    procedure BeginUpdateHistory;
    function CanUpdateHistory: Boolean;
    procedure ChangeView(AViewId: Integer);
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoShellListViewBeforeNavigation(Sender: TdxCustomShellListView; APIDL: PItemIDList; ADisplayName: string);
    procedure DoShellListViewSortColumnChanged(Sender: TObject);
    procedure DoShellListViewSelectionChanged(Sender: TObject);
    procedure DoShow; override;
    function DoUpdateFileName(const ABasePath: string): Boolean;
    function DoUpdateFiles(const ABasePath: string): Boolean;
    procedure EndUpdateHistory;
    function FindMask(const AValue: string; out AIndex: Integer): Boolean;
    function ForceShowPreview: Boolean; virtual;
    function GetFileName: string; override;
    function GetFilterIndex: Integer; override;
    function GetTitle: string; override;
    function GetViewStyle: TdxListViewStyle; override;
    procedure InitializeFileTypes(const AFilter: string);
    procedure InitializeLookAndFeel;
    function IsFileExistsCheckNeeded: Boolean;
    function IsFileSystemItem(const AFileName: string): Boolean;
    function IsMask(const AFileName: string; var AFileMask: string): Boolean;
    function IsOptionsCheckPassed(const AFileName: string): Boolean; virtual;
    function NeedPreview(out APreviewWidth: Integer): Boolean;
    function PreviewSupports: Boolean; virtual;
    procedure RestoreListViewState;
    procedure SetActiveMask(AValue: string);
    procedure SetFileName(const AValue: string); override;
    procedure SetOptions(const AValue: TOpenOptions); override;
    procedure SetTitle(const AValue: string); override;
    procedure SetViewStyle(const AValue: TdxListViewStyle); override;
    procedure StoreColumns;
    procedure StoreListViewState;
    procedure StoreSortColumnInfo;
    procedure SyncPaths(APIDL: PItemIDList; ASyncControl: TWinControl = nil);
    procedure UpdateButtonsHints;
    procedure UpdateButtonsSize;
    procedure UpdateButtonsStates;
    procedure UpdateHistory(APidl: PItemIDList);
    procedure UpdatePreviewPane;
    procedure UpdateViews;
    //
    property FileTypes: TFileTypeItems read FFileTypes write SetFileTypes;
    property IsColumnChanged: Boolean read GetIsColumnChanged;
    property IsSortColumnChanged: Boolean read FIsSortColumnChanged;
    property PreviewPane: TdxDialogFilePreviewPane read FPreviewPane;
    property PreviewVisible: Boolean read FPreviewVisible write SetPreviewVisible;
    property PreviewVisibility: TdxDefaultBoolean read FPreviewVisibility;
    property ShellBreadcrumbEdit: TdxShellDialogBreadcrumbEdit read FShellBreadcrumbEdit;
    property ShellListViewSelectedItemIndices: TdxIntegerList read GetShellListViewSelectedItemIndices;
    property ShellListView: TdxShellDialogListView read FShellListView;
    property ShellTreeView: TdxShellDialogTreeView read FShellTreeView;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyLocalization; override;
    procedure InitializeFilter(const AFilter: string; const AFilterIndex: Integer); override;
    procedure InitializeFolder(const AInitialDir: string); override;
    procedure SetHistoryList(AHistoryList: TStrings); override;
    procedure SetPreviewOptions(AValue: TdxFileDialogPreviewOptions); override;
    function ShowModal: Integer; override;
    // IdxLocalizerListener
    procedure TranslationChanged; virtual;
  end;

  { TdxfrmOpenFileDialog }

  TdxfrmOpenFileDialog = class(TdxfrmCommonFileDialog) // for internal use only
  protected
    procedure AddToRecentDocs(const APidl: PItemIDList; const AName: string); override;
    function IsOptionsCheckPassed(const AFileName: string): Boolean; override;
    procedure SetOptions(const AValue: TOpenOptions); override;
  public
    procedure ApplyLocalization; override;
  end;

  { TdxfrmSaveFileDialog }

  TdxfrmSaveFileDialog = class(TdxfrmCommonFileDialog) // for internal use only
  protected
    procedure AddToRecentDocs(const APidl: PItemIDList; const AName: string); override;
    function IsOptionsCheckPassed(const AFileName: string): Boolean; override;
  public
    procedure ApplyLocalization; override;
  end;

  { TdxFileDialogsSettings}

  TdxFileDialogsSettings = class // for internal use only
  protected type
  {$REGION 'Internal Types'}
    TdxFileDialogInfo = class
    public
      Changed: Boolean;
      Position: TPoint;
      SplitterPosition: Integer;
      Size: TSize;
    end;
  {$ENDREGION}
  protected const
    DefaultSize: TSize = (cx: 999; cy: 585);
    DefaultSplitterPosition: Integer = 276;
    //
    SettingsRootKeyName: string = 'Software\Developer Express\Dialogs\';
    //
    HeightPropertyName: string = 'FormHeight';
    LastDirPropertyName: string = 'LastVisitedDialogDirectoryProperty';
    LeftPropertyName: string = 'FormLeft';
    SplitterPositionPropertyName: string = 'SplitterPosition';
    TopPropertyName: string = 'FormTop';
    WidthPropertyName: string = 'FormWidth';
  protected
    Changed: Boolean;
    FInitialDir: string;
    FSettings: TObjectDictionary<TClass, TdxFileDialogInfo>;

    procedure DoLoad; virtual;
    procedure DoSave; virtual;
    function GetInfo(AClass: TClass): TdxFileDialogInfo; virtual;
    function GetSplitterPosition(AClass: TClass): Integer;
    function GetSize(AClass: TClass): TSize;
    procedure LoadDialogInfo(ADialog: TdxfrmCommonFileCustomDialog); virtual;
    procedure SaveDialogInfo(ADialog: TdxfrmCommonFileCustomDialog); virtual;
    procedure SetInitialDir(const AValue: string);
    procedure SetSplitterPosition(AClass: TClass; AValue: Integer);
    procedure SetSize(AClass: TClass; const AValue: TSize);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property InitialDir: string read FInitialDir write SetInitialDir;
    property SplitterPosition[AClass: TClass]: Integer read GetSplitterPosition write SetSplitterPosition;
    property Size[AClass: TClass]: TSize read GetSize write SetSize;
  end;

var
  dxFileDialogsSettings: TdxFileDialogsSettings; // for internal use only


implementation

{$R *.dfm}

uses
  StrUtils, Registry, StructuredQuery, StructuredQueryCondition,
  dxThreading, cxGeometry, cxEditConsts, dxHooks, cxShellControls,
  dxDPIAwareUtils, dxTypeHelpers, dxLayoutCommon, cxShellListView, dxShellColumnCustomization, dxMessageDialog,
  dxBuiltInPopupMenu, ShLwApi, IOUtils, NetEncoding;

const
  dxThisUnitName = 'dxShellCustomDialog';

const
  SID_IFolderType = '{053B4A86-0DC9-40A3-B7ED-BC6A2E951F48}';
  SID_IMruDataList = '{FE787BCB-0EE8-44FB-8C89-12F508913C40}';
  SID_IMruDataList2 = '{D2C22919-91F5-4284-8807-58A2D64E561C}';
  SID_INewItemAdvisor = '{24D16EE5-10F5-4DE3-8766-D23779BA7A6D}';
  SID_IObjectArray = '{92CA9DCD-5622-4BBA-A805-5E9F541BD8C9}';
  SID_IObjectCollection = '{5632B1A4-E38A-400A-928A-D4CD63230295}';
  //
  CLSID_MruLongList: TGUID = '{53BD6B4E-3780-4693-AFC3-7161C2F3EE9C}';
  CLSID_ShellItemArrayAsCollection: TGUID = '{CDC82860-468D-4D4E-B7E7-C298FF23AB2C}';
  //
  IID_IFolderType: TGUID = SID_IFolderType;
  IID_INewItemAdvisor: TGUID = SID_INewItemAdvisor;
  IID_IObjectCollection: TGUID = SID_IObjectCollection;
  IID_IPropertyBag: TGUID = '{55272A00-42CB-11CE-8135-00AA004BB851}';
  IID_IPropertyBag2: TGUID = '{22F55882-280B-11d0-A8A9-00A0C90C2004}';
  PKEY_AddToTreeView: TGUID = '{5D76B67F-9B3D-44BB-B6AE-25DA4F638A67}';
  PKEY_ExpandState: TGUID = '{77C77E35-1BE3-4350-A48C-7563D727776D}';
  SExplorerRegPath = 'Software\Microsoft\Windows\CurrentVersion\Explorer\';
  SExplorerAdvanced = SExplorerRegPath + 'Advanced';
  SExplorerModules = SExplorerRegPath + 'Modules';
  STypedPaths = 'TypedPaths';
  SExplorerLastVisitedPidlMRU = SExplorerRegPath + 'ComDlg32\LastVisitedPidlMRU';
  SExplorerOpenSavePidlMRU = SExplorerRegPath + 'ComDlg32\OpenSavePidlMRU';
  SNavPane = 'NavPane';
  SExpandedState = 'ExpandedState';
  SShowAllFolders = 'NavPaneShowAllFolders';
  SHideFileExt = 'HideFileExt';
  SAutoCheckSelect = 'AutoCheckSelect';
  // const
  SMaxRecentPathItemCount = 25;
  SMaxRecentFileItemCount = 25;
  // viewmode
  SComdlg = 'Comdlg\';
  IID_GenericFolderTypeId: TGUID = '{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}';
  IID_IPersistStream: TGUID = '{00000109-0000-0000-C000-000000000046}';
  IID_ITopViewDescription: TGUID = '{FE812157-522C-46CB-8D53-6EFE3DCE2C46}';
  SLogicalViewMode = 'LogicalViewMode';
  SMode = 'Mode';
  SIconSize = 'IconSize';
  //
  SColumnSortPropertyName: PChar = 'Sort';
  SColumnInfoPropertyName: PChar = 'ColInfo';
  // ShellListView mode
  cmdExtraLargeIconId = 1;
  cmdLargeIconId = 2;
  cmdIconId = 3;
  cmdSmallIconId = 4;
  cmdListId = 5;
  cmdDetailId = 6;
  DefaultShellListViewMode = cmdIconId;

type
  TcxButtonAccess = class(TcxButton);

var
  FAddItemToRecentDocs: function(const APidl: PItemIDList; const AName: PChar; A1, A2, A3, A4, A5, A6: Cardinal): HResult; stdcall;
  ShellLibrary: HMODULE = 0;

procedure AddItemToRecentDocs(const APidl: PItemIDList; const AName: string; A1, A2, A3, A4, A5, A6: Cardinal);
begin
  if not IsWin10OrLater then
    Exit;
  if @FAddItemToRecentDocs = nil then
  begin
    ShellLibrary := GetModuleHandle(shell32);
    if ShellLibrary <> 0 then
      FAddItemToRecentDocs := GetProcAddress(ShellLibrary, PChar(903));
  end;
  if @FAddItemToRecentDocs <> nil then
    FAddItemToRecentDocs(APidl, PChar(AName), A1, A2, A3, A4, A5, A6);
end;

function IsRegisteredExtension(const AExt: string): Boolean;  
var
  ASubKey: HKEY;
begin
  Result := RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar(AExt), 0, KEY_READ, ASubKey) = ERROR_SUCCESS;
  if Result then
    RegCloseKey(ASubKey);
end;

function GetExplorerShowCheckBoxes: Boolean;
var
  AValue, ASize: DWORD;
  ASubKey: HKEY;
begin
  Result := False;
  if RegOpenKeyEx(HKEY_CURRENT_USER, SExplorerAdvanced, 0, KEY_READ, ASubKey) = ERROR_SUCCESS then
  try
    ASize := SizeOf(AVAlue);
    if RegQueryValueExW(ASubKey, SAutoCheckSelect, nil, nil, @AValue, @ASize) = ERROR_SUCCESS then
      Result := AValue = 1;
  finally
    RegCloseKey(ASubKey);
  end;
end;

type
{$TYPEINFO OFF}
  TcxControlAccess = class(TcxControl);
  TcxCustomButtonAccess = class(TcxCustomButton);
  TcxButtonViewInfoAccess = class(TcxButtonViewInfo);
  TcxButtonPainterAccess = class(TcxButtonPainter);
  TcxButtonStandardLayoutCalculatorAccess = class(TcxButtonStandardLayoutCalculator);
  TdxListViewControllerAccess = class(TdxListViewController);
  TdxShellListViewItemProducerAccess = class(TdxShellListViewItemProducer);
  TdxBreadcrumbEditPathEditorPropertiesAccess = class(TdxBreadcrumbEditPathEditorProperties);
  TdxListViewViewInfoAccess = class(TdxListViewViewInfo);
  TcxButtonEditAccess = class(TcxButtonEdit);

  IQueryParser = interface(IUnknown)
    [SID_IQueryParser]
    function Parse(pszInputString: LPCWSTR; pCustomProperties: IEnumUnknown;
      out ppSolution: IQuerySolution): HRESULT; stdcall;

    function SetOption(option: STRUCTURED_QUERY_SINGLE_OPTION;
      var pOptionValue: TPropVariant): HRESULT; stdcall;

    function GetOption(option: STRUCTURED_QUERY_SINGLE_OPTION;
      var pOptionValue: TPropVariant): HRESULT; stdcall;

    function SetMultiOption(option: STRUCTURED_QUERY_MULTIOPTION;
      pszOptionKey: LPCWSTR; var pOptionValue: TPropVariant): HRESULT; stdcall;

    function GetSchemaProvider(
      out ppSchemaProvider: ISchemaProvider): HRESULT; stdcall;

    function RestateToString(var pCondition: ICondition; fUseEnglish: BOOL;
      var ppszQueryString: LPWSTR): HRESULT; stdcall;

    function ParsePropertyValue(pszPropertyName: LPCWSTR; pszInputString: LPCWSTR;
      out ppSolution: IQuerySolution): HRESULT; stdcall;

    function RestatePropertyValueToString(var pCondition: ICondition;
      fUseEnglish: BOOL; var ppszPropertyName: LPWSTR;
      var ppszQueryString: LPWSTR): HRESULT; stdcall;
  end;

  IFolderType = interface
    [SID_IFolderType]
    function GetFolderType (var AFolderTypeId: TGUID): HRESULT; stdcall;
  end;

  INewItemAdvisor = interface
    [SID_INewItemAdvisor]
    function IsTypeSupported (const AType: LPCWSTR): HRESULT; stdcall;
    function GetPropertiesToApply (APropertyStore: IPropertyStore; const iid: TIID; out pv): HRESULT; stdcall;
    function QueryObject (const iid1: TIID; const iid2: TIID; out pv): HRESULT; stdcall;
  end;

  IMruDataList = interface
  [SID_IMruDataList]
    function InitData(uMax: UINT; flags: Integer; hKey: HKEY; pszSubKey: LPCWSTR; pfnCompare: Pointer): HRESULT; stdcall;
    function AddData(const pData: Pointer; cbData: DWORD; var pdwSlot: DWORD): HRESULT; stdcall;
    function FindData(const pData: Pointer; cbData: DWORD; var piIndex: Integer): HRESULT; stdcall;
    function GetData(iIndex: Integer; pData: Pointer; cbData: DWORD): HRESULT; stdcall;
    function QueryInfo(iIndex: Integer; pdwSlot: DWORD; var cbData: DWORD): HRESULT; stdcall;
    function Delete(iIndex: Integer): HRESULT; stdcall;
  end;

  IMruDataList2 = interface
  [SID_IMruDataList2]
    function InitData(uMax: UINT; flags: Integer; hKey: HKEY; pszSubKey: LPCWSTR; pfnCompare: Pointer): HRESULT; stdcall;
    function AddData(const pData: Pointer; cbData: DWORD; var pdwSlot: DWORD): HRESULT; stdcall;
    function InsertData(AData: PChar; A1: Integer; A2: Cardinal; var A3: Cardinal): HRESULT; stdcall;
    function FindData(const pData: Pointer; cbData: DWORD; var piIndex: Integer): HRESULT; stdcall;
    function GetData(iIndex: Integer; pData: Pointer; cbData: DWORD): HRESULT; stdcall;
    function QueryInfo(iIndex: Integer; pdwSlot: DWORD; var cbData: DWORD): HRESULT; stdcall;
    function Delete(iIndex: Integer): HRESULT; stdcall;
  end;

  IObjectArray = interface
  [SID_IObjectArray]
    function GetCount(out pcObjects: UINT): HRESULT; stdcall;
    function GetAt(uiIndex: UINT; riid: TIID; out ppv): HRESULT; stdcall;
  end;

  IObjectCollection = interface(IObjectArray)
  [SID_IObjectCollection]
    function AddObject(const punk: IUnknown): HRESULT; stdcall;
    function AddFromArray(const poaSource: IObjectArray): HRESULT; stdcall;
    function RemoveObjectAt(uiIndex: UINT): HRESULT; stdcall;
    function Clear: HRESULT; stdcall;
  end;

  TdxMRULongList = class
  strict private
    FIsInitialized: Boolean;
    FMRUDataList: IMruDataList;
    FMRUDataList2: IMruDataList2;
    function UseNewInterface: Boolean;
  protected
    property IsInitialized: Boolean read FIsInitialized;
  public
    constructor Create(AMax: Cardinal; AFlags: Integer; const ASubKey: string);
    destructor Destroy; override;
    procedure ClearData(const AData: string; ALength: Integer);
    //
    procedure InitData(AMax: Cardinal; AFlags: Integer; const ASubKey: string);
    function AddData(AData: Pointer; ADataSize: Integer): Boolean;
    function FindData(const AData: string; ALength: Integer; out AIndex: Integer): Boolean;
    function GetData(AIndex: Integer; AData: Pointer; ABytesCount: Cardinal): Boolean;
    function QueryInfo(AIndex: Integer; out ABytesCount: Cardinal): Boolean;
    function Delete(AIndex: Integer): Boolean;
  end;

  TdxInitialDirStorage = class
  strict private
    FMRUList: TdxMRULongList;
    FProcessName: string;
    FProcessNameLength: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearData;
    function ReadPidl(out APidl: PItemIDList): Boolean;
    function WritePidl(APidl: PItemIDList): Boolean;
  end;

  TdxMRUPidls = class
  strict private
    FMRUList: TdxMRULongList;
  public
    constructor Create(const AFilter: string);
    destructor Destroy; override;
    procedure GetList(AList: TStrings);
    procedure AddItem(APidl: PItemIDList);
  end;

  TdxMRUSearch = class
  strict private
    FMRUList: TdxMRULongList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddItem(const AItem: string);
    procedure DeleteItem(const AItem: string);
    procedure GetList(AList: TStrings);
  end;
{$TYPEINFO ON}

{ TdxMRULongList }

constructor TdxMRULongList.Create(AMax: Cardinal; AFlags: Integer; const ASubKey: string);
begin
  inherited Create;
  InitData(AMax, AFlags, ASubKey);
end;

destructor TdxMRULongList.Destroy;
begin
  FMRUDataList := nil;
  FMRUDataList2 := nil;
  inherited;
end;

procedure TdxMRULongList.ClearData(const AData: string; ALength: Integer);
var
  AIndex: Integer;
begin
  if FIsInitialized and FindData(AData, ALength, AIndex) then
    Delete(AIndex);
end;

procedure TdxMRULongList.InitData(AMax: Cardinal; AFlags: Integer; const ASubKey: string);
begin
  if UseNewInterface then
    FIsInitialized := Succeeded(CoCreateInstance(CLSID_MruLongList, nil,
      CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IMruDataList2, FMRUDataList2)) and
      Succeeded(FMruDataList2.InitData(AMax, AFlags, HKEY_CURRENT_USER, PChar(ASubKey), nil))
  else
    FIsInitialized := Succeeded(CoCreateInstance(CLSID_MruLongList, nil,
      CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IMruDataList, FMRUDataList)) and
      Succeeded(FMruDataList.InitData(AMax, AFlags, HKEY_CURRENT_USER, PChar(ASubKey), nil));
end;

function TdxMRULongList.AddData(AData: Pointer; ADataSize: Integer): Boolean;
var
  ASlot: Cardinal;
  AIndex: Integer;
begin
  if UseNewInterface then
  begin
    if Succeeded(FMruDataList2.FindData(AData, ADataSize, AIndex)) then
      FMruDataList2.Delete(AIndex);
    Result := Succeeded(FMruDataList2.AddData(AData, ADataSize, ASlot));
  end
  else
    Result := Succeeded(FMruDataList.AddData(AData, ADataSize, ASlot));
end;

function TdxMRULongList.FindData(const AData: string; ALength: Integer; out AIndex: Integer): Boolean;
begin
  if UseNewInterface then
    Result := Succeeded(FMruDataList2.FindData(PChar(AData), ALength, AIndex))
  else
    Result := Succeeded(FMruDataList.FindData(PChar(AData), ALength, AIndex));
end;

function TdxMRULongList.GetData(AIndex: Integer; AData: Pointer; ABytesCount: Cardinal): Boolean;
begin
  if UseNewInterface then
    Result := Succeeded(FMruDataList2.GetData(AIndex, AData, ABytesCount))
  else
    Result := Succeeded(FMruDataList.GetData(AIndex, AData, ABytesCount));
end;

function TdxMRULongList.QueryInfo(AIndex: Integer; out ABytesCount: Cardinal): Boolean;
begin
  if UseNewInterface then
    Result := Succeeded(FMruDataList2.QueryInfo(AIndex, 0, ABytesCount))
  else
    Result := Succeeded(FMruDataList.QueryInfo(AIndex, 0, ABytesCount));
end;

function TdxMRULongList.Delete(AIndex: Integer): Boolean;
begin
  if UseNewInterface then
    Result := Succeeded(FMruDataList2.Delete(AIndex))
  else
    Result := Succeeded(FMruDataList.Delete(AIndex));
end;

function TdxMRULongList.UseNewInterface: Boolean;
begin
  Result := IsWin8OrLater;
end;

{ TdxInitialDirStorage }

constructor TdxInitialDirStorage.Create;
begin
  inherited Create;
  FMRUList := TdxMRULongList.Create($19, 1, SExplorerLastVisitedPidlMRU);
  if FMRUList.IsInitialized then
  begin
    FProcessName := ExtractFileName(Application.ExeName);
    FProcessNameLength := Length(FProcessName) * SizeOf(Char) + SizeOf(Char);
  end;
end;

destructor TdxInitialDirStorage.Destroy;
begin
  FreeAndNil(FMRUList);
  inherited;
end;

procedure TdxInitialDirStorage.ClearData;
begin
  FMRUList.ClearData(FProcessName, FProcessNameLength);
end;

function TdxInitialDirStorage.ReadPidl(out APidl: PItemIDList): Boolean;
var
  AIndex: Integer;
  ABytesCount: Cardinal;
  AData: Pointer;
begin
  Result := False;
  APidl := nil;
  if FMRUList.IsInitialized and FMRUList.FindData(FProcessName, FProcessNameLength, AIndex) and
    FMRUList.QueryInfo(AIndex, ABytesCount) then
  begin
    AData := cxAllocMem(ABytesCount);
    if FMRUList.GetData(AIndex, AData, ABytesCount) then
    begin
      APidl := ShiftPointer(AData, FProcessNameLength);
      APidl := GetPidlCopy(APidl);
      Result := APidl <> nil;
    end;
    cxFreeMem(AData);
  end;
end;

function TdxInitialDirStorage.WritePidl(APidl: PItemIDList): Boolean;
var
  AData: Pointer;
  APidlSize: Integer;
begin
  Result := False;
  if FMRUList.IsInitialized then
  begin
    ClearData;
    APidlSize := GetPidlSize(APidl) + 2;
    AData := cxAllocMem(FProcessNameLength + APidlSize);
    try
      cxCopyData(PChar(FProcessName), AData, FProcessNameLength);
      cxCopyData(APidl, AData, 0, FProcessNameLength, APidlSize);
      Result := FMRUList.AddData(AData, FProcessNameLength + APidlSize);
    finally
      cxFreeMem(AData);
    end;
  end;
end;

{ TdxMRUPidls }

constructor TdxMRUPidls.Create(const AFilter: string);
begin
  inherited Create;
  FMRUList := TdxMRULongList.Create($14, 3, SExplorerOpenSavePidlMRU + '\' + AFilter);
end;

destructor TdxMRUPidls.Destroy;
begin
  FreeAndNil(FMRUList);
  inherited;
end;

procedure TdxMRUPidls.GetList(AList: TStrings);
var
  ABytesCount: Cardinal;
  I: Integer;
  AData: Pointer;
  APidl: PItemIDList;
  AItemName: string;
begin
  if FMRUList.IsInitialized and FMRUList.QueryInfo(0, ABytesCount) then
  begin
    for I := 0 to $19 do
      if FMRUList.QueryInfo(I, ABytesCount) then
      begin
        AData := cxAllocMem(ABytesCount);
        if FMRUList.GetData(I, AData, ABytesCount) then
        begin
          APidl := GetPidlCopy(AData);
          if APidl <> nil then
          begin
            AItemName := GetPIDLDisplayName(APidl, True);
            if AItemName <> '' then
              AList.Add(AItemName);
          end;
          DisposePidl(APidl);
        end;
        cxFreeMem(AData);
      end
      else
        Break;
  end;
end;

procedure TdxMRUPidls.AddItem(APidl: PItemIDList);
begin
  if FMRUList.IsInitialized then
    FMRUList.AddData(APidl, GetPidlSize(APidl) + 2);
end;

function IsExtensionExplicitlyIncludedInFilter(const AMask: string; const AExtension: string): Boolean;
var
  AExt, AMaskStr: string;
  APos, ALength, I: Integer;
begin
  AMaskStr := AMask.ToLower;
  AExt := AExtension.ToLower;
  ALength := Length(AExt);
  I := 1;
  repeat
    APos := PosEx(AExt, AMaskStr, I);
    I := APos + ALength;
    Result := (APos > 0) and ((APos + ALength - 1 = Length(AMask)) or
      CharInSet(AMaskStr[APos + ALength], [';', ' ']));
  until Result or (APos <= 0);
end;

function IsExtensionExplicitlyIncludedInFilters(const AExtension: string; ADialogFilters: TFileTypeItems): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to ADialogFilters.Count - 1 do
    if IsExtensionExplicitlyIncludedInFilter(ADialogFilters[I].FileMask, AExtension) then
    begin
      Result := True;
      Break;
    end;
end;

function GetFileExtension(const AFileName: string; ADialogFilters: TFileTypeItems; out AExtension: string): Boolean;
begin
  AExtension := ExtractFileExt(AFileName);
  Result := (Length(AExtension) > 1) and (IsRegisteredExtension(AExtension) or IsExtensionExplicitlyIncludedInFilters(AExtension, ADialogFilters));
  if not Result then
    AExtension := '';
end;

function GetFirstExtensionFromFileMask(const AFileMask: string; out AExt: string): Boolean;
var
  APos: Integer;
begin
  Result := False;
  AExt := '';
  APos := Pos('.', AFileMask);
  if APos > 0 then
  begin
    Result := True;
    AExt := Copy(AFileMask, APos, Length(AFileMask) - APos + 1);
    APos := Pos(';', AExt);
    if APos > 0 then
      AExt := Copy(AExt, 1, APos - 1);
    APos := Pos(' ', AExt);
    if APos > 0 then
      AExt := Copy(AExt, 1, APos - 1);
  end;
end;

procedure CheckDefaultExtension(var AExt: string);
begin
  if (Pos('.', AExt) > 0) or (Pos('*', AExt) > 0) then
    AExt := '';
  if AExt <> '' then
    AExt := '.' + AExt;
end;

procedure CheckFileExtension(var ASelectedFileName: string; const ASavedFileName: string;
  ADialogFilters: TFileTypeItems; AActiveFilterIndex: Integer; const ADefaultExt: string);
var
  ASelectedExt, ASavedFileExt, ADefExt, AExt: string;
  AFileMask: string;
begin
  if (ADefaultExt <> '') and not GetFileExtension(ASelectedFileName, ADialogFilters, AExt) then
  begin
    GetFileExtension(ASavedFileName, ADialogFilters, ASavedFileExt);
    ADefExt := Trim(ADefaultExt);
    CheckDefaultExtension(ADefExt);
    ASelectedExt := '';

    if AActiveFilterIndex >= 0 then
      AFileMask := ADialogFilters[AActiveFilterIndex].FileMask
    else
      AFileMask := '';

    if GetFirstExtensionFromFileMask(AFileMask, AExt) and (AExt <> '.*') then
    begin
      if (ASavedFileExt <> '') and IsExtensionExplicitlyIncludedInFilter(AFileMask, ASavedFileExt) then
        ASelectedExt := ASavedFileExt
      else
        if (ADefExt <> '') and IsExtensionExplicitlyIncludedInFilter(AFileMask, ADefExt) then
          ASelectedExt := ADefExt
        else
          ASelectedExt := AExt;
    end
    else
      if (AExt <> '.*') or (ExtractFileExt(ASelectedFileName) = '') then  
        ASelectedExt := ADefExt;

    if (ASelectedExt <> '') and (ExtractFileExt(ASelectedFileName).ToLower <> ASelectedExt.ToLower) then
      ASelectedFileName := ASelectedFileName + ASelectedExt;
  end;
end;


procedure dxMouseWheelHook(ACode: Integer; wParam: WPARAM; lParam: LPARAM; var AHookResult: LRESULT);
var
  AControl: TControl;
  AMHS: PMouseHookStructEx;
begin
  if (ACode < 0) or (wParam <> WM_MOUSEWHEEL) or not Mouse.WheelPresent then
    Exit;
  AMHS := PMouseHookStructEx(lParam);
  AControl := FindVCLWindow(AMHS^.MouseHookStruct.pt);
  if not ((AControl is TdxCustomShellTreeView) or (AControl is TdxCustomShellListView)) then
    Exit;
  if TcxControlAccess(AControl).DoMouseWheel(KeyboardStateToShiftState, SmallInt(HiWord(AMHS.mouseData)), AMHS^.MouseHookStruct.pt) then
    AHookResult := 1;
end;

{ TdxFileDialogPreviewOptions }

constructor TdxFileDialogPreviewOptions.Create;
begin
  inherited Create;
  FDelay := TdxFilePreviewPane.DefaultPreviewDelay;
  FSources := TdxFilePreviewPane.DefaultFilePreviewSources;
  FVisible := bDefault;
end;

procedure TdxFileDialogPreviewOptions.SetDelay(AValue: Integer);
begin
  FDelay := Max(0, AValue);
end;

procedure TdxFileDialogPreviewOptions.Assign(Source: TPersistent);
var
  AOptions: TdxFileDialogPreviewOptions;
begin
  AOptions := Safe<TdxFileDialogPreviewOptions>.Cast(Source);
  if AOptions <> nil then
  begin
    Delay := AOptions.Delay;
    Sources := AOptions.Sources;
    Visible := AOptions.Visible;
  end;
end;

{ TdxfrmCommonFileCustomDialog }

constructor TdxfrmCommonFileCustomDialog.Create(AOwner: TComponent);
begin
  inherited Create(Application);
  DefaultMonitor := dmDesktop;
  Font := Screen.IconFont;
  Font.Height := MulDiv(Font.Height, ScaleFactor.TargetDPI, dxSystemScaleFactor.TargetDPI);
  FFiles := TStringList.Create;
  FLookAndFeel := TcxLookAndFeel.Create(Self);
  if not IsWin10OrLater then
    dxSetHook(htMouse, dxMouseWheelHook);
end;

destructor TdxfrmCommonFileCustomDialog.Destroy;
begin
  DisposePidl(FLoadedInitialDirPidl);
  TdxUIThreadSyncService.Unsubscribe(Self);
  if not IsWin10OrLater then
    dxReleaseHook(dxMouseWheelHook);
  FreeAndNil(FFiles);
  FreeAndNil(FLookAndFeel);
  inherited Destroy;
end;

procedure TdxfrmCommonFileCustomDialog.UpdateSystemMenuItems(AMenu: HMENU);
begin
  if WindowState = wsMaximized then
  begin
    EnableMenuItem(AMenu, SC_MAXIMIZE, MF_BYCOMMAND or MF_GRAYED);
    EnableMenuItem(AMenu, SC_RESTORE, MF_BYCOMMAND);
  end
  else
  begin
    EnableMenuItem(AMenu, SC_MAXIMIZE, MF_BYCOMMAND);
    EnableMenuItem(AMenu, SC_RESTORE, MF_BYCOMMAND or MF_GRAYED);
  end;
end;

procedure TdxfrmCommonFileCustomDialog.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
var
  AMinMaxInfo: PMinMaxInfo;
  AWorkarea, ABounds: TRect;
  AMonitor: TMonitor;
begin
  inherited;
  if not (csReading in ComponentState) then
  begin
    AMonitor := Screen.MonitorFromWindow(Handle);
    if AMonitor <> nil then
    begin
      AWorkarea := AMonitor.WorkareaRect;
      ABounds := AMonitor.BoundsRect;
      AMinMaxInfo := Message.MinMaxInfo;
      with AMinMaxInfo^ do
      begin
        ptMaxPosition.Init(AWorkarea.Left - ABounds.Left, AWorkarea.Top - ABounds.Top);
        ptMaxSize.Init(AWorkarea.Width, AWorkarea.Height);
      end;
    end;
  end;
end;

procedure TdxfrmCommonFileCustomDialog.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  if IsZoomed(Handle) then
    if Message.Result in [
       HTBORDER, HTBOTTOM, HTBOTTOMLEFT, HTBOTTOMRIGHT,
       HTLEFT, HTRIGHT, HTTOP, HTTOPLEFT, HTTOPRIGHT] then
     Message.Result := HTCLIENT;
end;

procedure TdxfrmCommonFileCustomDialog.WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk);
var
  P: TPoint;
begin
  if not (ofEnableSizing in Options) then
    Exit;
  P := GetMouseCursorPos;
  if SendMessage(Handle, WM_NCHITTEST, 0, MakeLong(P.X, P.Y)) = HTCAPTION then
  begin
    if WindowState = wsNormal then
      TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
        procedure ()
        begin
          WindowState := wsMaximized;
        end)
    else
      TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
        procedure ()
        begin
          WindowState := wsNormal;
        end)
  end;
end;

procedure TdxfrmCommonFileCustomDialog.WndProc(var Message: TMessage);
begin
  with Message do
  begin
    case Msg of
      WM_INITMENU:
        begin
          Message.WParam := GetSystemMenu(Handle, False);
          LockWindowUpdate(Handle);
          try
            DeleteMenu(Message.WParam, SC_MINIMIZE, MF_BYCOMMAND);
            if not (ofEnableSizing in Options) then
            begin
              DeleteMenu(Message.WParam, SC_MAXIMIZE, MF_BYCOMMAND);
              DeleteMenu(Message.WParam, SC_RESTORE, MF_BYCOMMAND);
              DeleteMenu(Message.WParam, SC_SIZE, MF_BYCOMMAND);
            end;
            UpdateSystemMenuItems(Message.WParam);
            inherited WndProc(Message);
          finally
            LockWindowUpdate(0);
          end;
        end;
    else
      inherited;
    end;
  end;
end;

{
procedure TdxfrmCommonFileCustomDialog.GetBorderStyles(var Style, ExStyle, ClassStyle: Cardinal);
begin
  inherited GetBorderStyles(Style, ExStyle, ClassStyle);
  Style := Style or (WS_CAPTION or WS_THICKFRAME);
  if not (ofEnableSizing in Options) then
    Style := Style or not WS_THICKFRAME;
end;

}

procedure TdxfrmCommonFileCustomDialog.SetOptions(const AValue: TOpenOptions);
begin
  FOptions := AValue;
end;

{ TdxfrmCommonFileDialog }

procedure TdxfrmCommonFileDialog.DoButtonCustomDraw(Sender: TObject; ACanvas: TcxCanvas; AViewInfo: TcxButtonViewInfo;
  var AHandled: Boolean);
begin
  AHandled := AViewInfo.State in [cxbsNormal, cxbsDisabled];
  if AHandled then
  begin
    cxDrawTransparentControlBackground(Sender as TcxButton, ACanvas, AViewInfo.Bounds);
    TcxButtonViewInfoAccess(AViewInfo).DrawContent(ACanvas);
    if AViewInfo.HasDropDownButton and not cxRectIsEmpty(AViewInfo.DropDownArrowRect) and
      (AViewInfo.Painter.LookAndFeelStyle = lfsSkin) then
      AViewInfo.Painter.LookAndFeelPainter.DrawScaledDropDownButtonArrow(ACanvas, AViewInfo.DropDownArrowRect,
        AViewInfo.DropDownButtonState, TcxButtonPainterAccess(AViewInfo.Painter).ScaleFactor);
  end;
end;

procedure TdxfrmCommonFileDialog.DoChooseFile(Sender: TObject; APIDL: PItemIDList; var AHandled: Boolean);
begin
  AHandled := True;
  btnOK.Click;
end;

procedure TdxfrmCommonFileDialog.DoHistoryItemClick(Sender: TObject);
var
  AAction: TAction;
  APidl: PItemIDList;
  AHistoryItem: TdxHistoryItem;
begin
  BeginUpdateHistory;
  try
    AAction := Sender as TAction;
    AHistoryItem := TdxHistoryItem(AAction.Tag);
    APidl := AHistoryItem.Pidl;
    if dxIsPidlEnumerable(Handle, APidl) then
    begin
      SyncPaths(APidl);
      FShellListView.SelectItemByPidl(AHistoryItem.SelectedPidl);
      CheckHistoryItem(AAction);
    end;
  finally
    EndUpdateHistory;
  end;
end;

procedure TdxfrmCommonFileDialog.DoPopupBuiltInPopupMenu(Sender: TObject; var APopupMenu: TPopupMenu;
  var AHandled: Boolean);
var
  AAdapter: TdxCustomBuiltInPopupMenuAdapter;
begin
  AHandled := not TdxBuiltInPopupMenuAdapterManager.IsActualAdapterStandard;
  if AHandled then
  begin
    AAdapter := TdxBuiltInPopupMenuAdapterManager.GetActualAdapterClass.Create(Self);
    try
      TdxBuiltInPopupMenuAdapterHelper.AddMenu(AAdapter, APopupMenu, nil);
      AAdapter.Popup(cxPointOffset(TControl(Sender).ClientOrigin, 0, TControl(Sender).Height));
    finally
      AAdapter.Free;
    end;
  end;
end;

procedure TdxfrmCommonFileDialog.DoShellListViewAfterNavigation(Sender: TdxCustomShellListView; APIDL: PItemIDList;
  ADisplayName: string);
var
  I: Integer;
  AShellItem: IShellItem;
  AAttr: Cardinal;
  ANewItemAdvisor: INewItemAdvisor;
  APreviousPidl: PItemIDList;
begin
  SyncPaths(APIDL, FShellListView);
  RestoreListViewState;
  if not FIsFolderInitializing then
    for I := 0 to FFileInfos.Count - 1 do
    begin
      FFileInfos[I].Pidl := nil;
      FFileInfos[I].FileName := ExtractFileName(FFileInfos[I].FileName);
      FFileInfos[I].IsLink := False;
      FFileInfos[I].TargetFileName := '';
    end;
  if IsWinSevenOrLater and Succeeded(SHCreateItemFromIDList(APIDL, IID_IShellItem, AShellItem)) then
  begin
    if Succeeded(AShellItem.BindToHandler(nil, BHID_SFViewObject, IID_INewItemAdvisor, ANewItemAdvisor)) then
      libtnNewFolder.Visible := Succeeded(ANewItemAdvisor.IsTypeSupported(PChar('Folder')))
    else
      if Succeeded(AShellItem.GetAttributes(SFGAO_READONLY or SFGAO_STORAGE, AAttr)) then
        libtnNewFolder.Visible := AAttr and (SFGAO_READONLY or SFGAO_STORAGE) = SFGAO_STORAGE
      else
        libtnNewFolder.Visible := False;
  end
  else
    libtnNewFolder.Visible := FShellListView.Path <> '';

  if Assigned(OnSelectionChange) or Assigned(OnFolderChange) then
  begin
    UpdateSelectedFilesInfo;
    dxCallNotify(OnSelectionChange, Self); 
    dxCallNotify(OnFolderChange, Self);
  end;
  UpdatePreviewFile;
  if not FIsSearching then
  begin
    actStopSearch.Visible := False;
    APreviousPidl := ShellListView.AbsolutePIDL;
    if not dxIsSearchFolderPidl(APreviousPidl) then
    begin
      dxFreeAndNilPidl(FSearchOriginDirPidl);
      FSearchOriginDirPidl := APreviousPidl;
    end
    else
      dxFreeAndNilPidl(APreviousPidl);
    beSearch.EditValue := Null;
  end;
  UpdateSearchEdit;
  if FSelectedChildPidl <> nil then
  begin
    FShellListView.SelectItemByPidl(FSelectedChildPidl);
    dxFreeAndNilPidl(FSelectedChildPidl);
  end;
end;

procedure TdxfrmCommonFileDialog.DoShellListViewBeforeNavigation(Sender: TdxCustomShellListView; APIDL: PItemIDList; ADisplayName: string);

  procedure RestoreColumns(APropertyBag: IPropertyBag);
  var
    I: Integer;
    AData: DWORD;
    AItemCount: Integer;
    cbRead: LongWord;
    AIStream: IStream;
  {$IFDEF DELPHIXE8}
    ANewPosition: LargeUInt;
    AItemSize: Cardinal;
  {$ELSE}
    ANewPosition: LargeInt;
    AItemSize: Integer;
  {$ENDIF}
    AColumnInfo: TdxShellColumnInfo;
  begin
    if Succeeded(dxPSPropertyBag_ReadStream(APropertyBag, SColumnInfoPropertyName, AIStream)) and
      Succeeded(AIStream.Seek(0, STREAM_SEEK_CUR, ANewPosition)) and
      Succeeded(AIStream.Read(@AData, 4, @cbRead)) and (cbRead = 4) and (AData = $FDDFDFFD) and
      Succeeded(AIStream.Read(@AData, 4, @cbRead)) and (cbRead = 4) and (AData >= $10) and
      Succeeded(AIStream.Seek(ANewPosition + AData, STREAM_SEEK_SET, ANewPosition)) and
      Succeeded(AIStream.Read(@AItemCount, 4, @cbRead)) and (cbRead = 4) and (AItemCount > 0) and
      Succeeded(AIStream.Read(@AItemSize, 4, @cbRead)) and (cbRead = 4) and (AItemSize = 24) and
      Succeeded(AIStream.Seek(ANewPosition + 8, STREAM_SEEK_SET, ANewPosition)) then
    begin
      for I := 0 to AItemCount - 1 do
        if Succeeded(AIStream.Read(@AColumnInfo.ColumnId, SizeOf(AColumnInfo.ColumnId), @cbRead)) and (cbRead = SizeOf(AColumnInfo.ColumnId)) and
           Succeeded(AIStream.Read(@AColumnInfo.Width, 4, @cbRead)) and (cbRead = 4) and
          ((I = AItemCount - 1) or Succeeded(AIStream.Seek(ANewPosition + AItemSize, STREAM_SEEK_SET, ANewPosition))) then
          ShellListView.VisibleColumnInfos.Add(AColumnInfo)
        else
        begin
          ShellListView.VisibleColumnInfos.Clear;
          Break;
        end;
    end;
  end;

var
  APropertyBag: IPropertyBag;
  ASelectedPidl: PItemIDList;
  AHistoryItemIndex: Integer;
  I: Integer;
  AChildPidl: PItemIDList;
begin
  if FIsSortColumnChanged then
    StoreSortColumnInfo;
  if IsColumnChanged then
    StoreColumns;
  ShellListView.VisibleColumnInfos.Clear;
  if GetViewStatePropertyBag(APIDL, APropertyBag) then
    RestoreColumns(APropertyBag);
  AHistoryItemIndex := GetCheckedHistoryItemIndex;
  if AHistoryItemIndex >= 0 then
  begin
    if ShellListViewSelectedItemIndices.Count = 1 then
      ASelectedPidl := FShellListView.GetItemInfo(ShellListViewSelectedItemIndices[0]).pidl
    else
      ASelectedPidl := nil;
    TdxHistoryItem(alHistory.Actions[AHistoryItemIndex].Tag).SelectedPidl := ASelectedPidl;
  end;
  UpdateHistory(APidl);
  AChildPidl := FShellListView.ShellRoot.Pidl;
  FSelectedChildPidl := nil;
  if IsSubPath(APidl, AChildPidl) then
  begin
    for I := 0 to GetPidlItemsCount(APidl) - 1 do
      AChildPidl := GetNextItemID(AChildPidl);
    FSelectedChildPidl := ExtractParticularPidl(AChildPidl);
  end;
end;

procedure TdxfrmCommonFileDialog.DoShellListViewSortColumnChanged(Sender: TObject);
begin
  FIsSortColumnChanged := True;
end;

procedure TdxfrmCommonFileDialog.DoShellListViewSelectionChanged(Sender: TObject);
var
  ASelectedCount, I: Integer;
  AItemIndex: Integer;
  AFolder: TcxShellFolder;
  AItemInfo: TcxShellItemInfo;
  ASelection: TdxIntegerList;
  ASelectedItems: TStringBuilder;
  AFileName, ATargetFileName: string;
  APidl, ATargetPidl: PItemIDList;
  ALink: IShellLink;
  AIsLink: Boolean;
  AFileInfos: TList<TdxFileInfo>;
  AFileInfo: TdxFileInfo;
begin
  FIsSelectionChanging := True;
  try
    ASelectedItems := TStringBuilder.Create;
    AFileInfos := TList<TdxFileInfo>.Create;
    try
      ASelectedCount := 0;
      ASelection := ShellListViewSelectedItemIndices;
      for I := 0 to ASelection.Count - 1 do
      begin
        AItemIndex := ASelection[I];
        AFolder := FShellListView.Folders[AItemIndex];
        if IsSelectableItem(AItemIndex) then
        begin
          AFileName := AFolder.PathName;
          APidl := AFolder.AbsolutePIDL;
          ATargetFileName := '';
          AIsLink := False;
          if not (ofNoDereferenceLinks in Options) then
          begin
            AItemInfo := FShellListView.GetItemInfo(AItemIndex);
            if AItemInfo.IsZipFolderLink or AItemInfo.IsLink and not AItemInfo.IsFolderLink then
            begin
              if Succeeded(TdxShellListViewItemProducerAccess(AItemInfo.ItemProducer).ShellFolder.BindToObject(AItemInfo.pidl, nil, IID_IShellLink, ALink)) and
                Succeeded(ALink.GetIDList(ATargetPidl)) then
              begin
                ATargetFileName := GetPidlName(ATargetPidl);
                AIsLink := ATargetFileName <> '';
              end;
            end;
          end;

          if AFileName <> '' then
          begin
            AFileInfo := TdxFileInfo.Create;
            AFileInfo.FileName := AFileName;
            AFileInfo.Pidl := GetPidlCopy(APidl);
            AFileInfo.IsLink := AIsLink;
            AFileInfo.TargetFileName := ATargetFileName;
            AFileInfos.Add(AFileInfo);
          end;

          if ASelectedCount > 0 then
            ASelectedItems.Append(#32);
          ASelectedItems.Append(#34);
          ASelectedItems.Append(AFolder.DisplayName);
          ASelectedItems.Append(#34);
          Inc(ASelectedCount);
        end;
      end;
      if ASelectedItems.Length > 0 then
      begin
        if ASelectedCount = 1 then
        begin
          ASelectedItems.Remove(0, 1);
          ASelectedItems.Remove(ASelectedItems.Length - 1, 1);
        end;
        cbName.Text := ASelectedItems.ToString;
        FFileInfos.Clear;
      end;
      for I := 0 to AFileInfos.Count - 1 do
        FFileInfos.Add(AFileInfos[I]);
    finally
      AFileInfos.Free;
      ASelectedItems.Free;
    end;
    UpdatePreviewFile;
    if Assigned(OnSelectionChange) then
    begin
      UpdateSelectedFilesInfo;
      OnSelectionChange(Self);
    end;
  finally
    FIsSelectionChanging := False;
  end;
end;

procedure TdxfrmCommonFileDialog.DoShellTreeViewAddFolder(Sender: TObject; AFolder: TcxShellFolder; var ACanAdd: Boolean);
var
  AShellItem2: IShellItem2;
  APropertyKey: TPropertyKey;
  AValue: LongBool;
begin
  if ACanAdd then
  begin
    if IsWinSevenOrLater and not FShowAllFolders and (GetDesktopIShellFolder = AFolder.ParentShellFolder) and
      Succeeded(SHCreateItemWithParent(nil, AFolder.ParentShellFolder, AFolder.RelativePIDL, IID_IShellItem2, AShellItem2)) then
    begin
      APropertyKey.fmtid := PKEY_AddToTreeView;
      APropertyKey.pid := 2;
      if Succeeded(AShellItem2.GetBool(APropertyKey, AValue)) and not AValue then
        ACanAdd := False;
    end;
    ACanAdd := ACanAdd and (AFolder.IsFolderLink or ((sfscFileSysAncestor in AFolder.StorageCapabilities) or AFolder.IsZip));
  end;
end;

procedure TdxfrmCommonFileDialog.DoShellListViewAddFolder(Sender: TObject; AFolder: TcxShellFolder; var ACanAdd: Boolean);
begin
  if ACanAdd and AFolder.IsFolder then
  begin
    ACanAdd := (sfscFileSysAncestor in AFolder.StorageCapabilities) or AFolder.IsZip and
      FShellListView.CheckFileMask(AFolder);
  end;
end;

procedure TdxfrmCommonFileDialog.DoViewClick(Sender: TObject);
begin
  ChangeView(TComponent(Sender).Tag);
end;

procedure TdxfrmCommonFileDialog.dxLayoutSplitterItemCanResize(Sender: TObject; AItem: TdxCustomLayoutItem;
  var ANewSize: Integer; var AAccept: Boolean);
var
  ADelta: Integer;
begin
  ADelta := ANewSize - AItem.Width;
  if liShellListView.Control.Width - ADelta < liShellListView.ControlOptions.MinWidth then
    AAccept := False;
end;

procedure TdxfrmCommonFileDialog.DoViewChanged(Sender: TObject);
begin
  ViewChanged;
end;

procedure TdxfrmCommonFileDialog.actBackExecute(Sender: TObject);
begin
  alHistory.Actions[GetCheckedHistoryItemIndex + 1].Execute;
end;

procedure TdxfrmCommonFileDialog.actForwardExecute(Sender: TObject);
begin
  alHistory.Actions[GetCheckedHistoryItemIndex - 1].Execute;
end;

procedure TdxfrmCommonFileDialog.actNewFolderExecute(Sender: TObject);
begin
  FShellListView.CreateNewFolder;
end;

procedure TdxfrmCommonFileDialog.actUpExecute(Sender: TObject);
begin
  FShellListView.BrowseParent;
  UpdateButtonsStates;
end;

procedure TdxfrmCommonFileDialog.beSearchPropertiesChange(Sender: TObject);
begin
  if FLockSearchControlChange <> 0 then
    Exit;
  actStartSearch.Visible := (beSearch.EditingValue <> Null) and (beSearch.EditingValue <> '');
  if beSearch.Focused then
  begin
    EnsureSearchPopup;
    RepopulateSearchPopup;
    DoSearch(False);
  end;
end;

procedure TdxfrmCommonFileDialog.beSearchPropertiesEditValueChanged(
  Sender: TObject);
begin
  if FLockSearchControlChange = 0 then
  begin
    if FSearchControlPopup <> nil then
      FSearchControlPopup.CloseUp;
    StoreSearchText;
  end;
end;

procedure TdxfrmCommonFileDialog.btnFilePreviewClick(Sender: TObject);
begin
  if not PreviewSupports then
    Exit;
  PreviewVisible := not PreviewVisible;
  if PreviewVisible then
    btnFilePreview.OptionsImage.ImageIndex := 8
  else
    btnFilePreview.OptionsImage.ImageIndex := 9;
  UpdateButtonsHints;
end;

procedure TdxfrmCommonFileDialog.btnViewsClick(Sender: TObject);
var
  I: Integer;
begin
  I := FShellListView.GetCurrentViewId;
  if I > alViews.ActionCount - 1 then
    I := IfThen(IsWinSevenOrLater, 0, 1)
  else
    if not IsWinSevenOrLater and (I = 3) then
      Inc(I, 1);
  alViews.Actions[I].Execute;
end;

procedure TdxfrmCommonFileDialog.cbFilterPropertiesEditValueChanged(Sender: TObject);
begin
  ApplyFilter(cbFilter.ItemIndex);
  dxCallNotify(OnTypeChange, Self);
end;

procedure TdxfrmCommonFileDialog.cbNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  VK_V = 86;
begin
  inherited KeyDown(Key, Shift);
  if ((Key = VK_INSERT) and (Shift = [ssShift])) or ((Key = VK_V) and (Shift = [ssCtrl])) then
    PasteFileNameFromClipboard;
end;

procedure TdxfrmCommonFileDialog.cbNamePropertiesChange(Sender: TObject);
begin
  if FIsSelectionChanging then
    Exit;
  FShellListView.ClearSelection;
  FFileInfos.Clear;
end;

procedure TdxfrmCommonFileDialog.cbNamePropertiesInitPopup(Sender: TObject);
var
  AMRUPidls: TdxMRUPidls;
  AExtension: string;
  ALists: TObjectList<TStrings>;
  AItems: TStrings;
  I, J: Integer;
  AIsMruListFull: Boolean;
  AExtensions: TStrings;
begin
  cbName.Properties.BeginUpdate;
  try
    cbName.Properties.Items.Clear;
    ALists := TObjectList<TStrings>.Create;
    try
      AExtensions := GetCurrentFilterExtensions;
      try
        for I := 0 to AExtensions.Count - 1 do
        begin
          AExtension := Copy(AExtensions[I], 3, Length(AExtensions[I]) - 2);
          AMRUPidls := TdxMRUPidls.Create(AExtension);
          try
            AItems := TStringList.Create;
            AMRUPidls.GetList(AItems);
            if AItems.Count > 0 then
              ALists.Add(AItems)
            else
              AItems.Free;
          finally
            AMRUPidls.Free;
          end;
        end;
      finally
        AExtensions.Free;
      end;
      AIsMruListFull := False;
      for I := 0 to SMaxRecentFileItemCount - 1 do
      begin
        for J := 0 to ALists.Count - 1 do
          if ALists[J].Count > I then
          begin
            cbName.Properties.Items.Add(ALists[J].Strings[I]);
            AIsMruListFull := cbName.Properties.Items.Count = SMaxRecentFileItemCount;
            if AIsMruListFull then
              Break;
          end;
        if AIsMruListFull then
          Break;
      end;
    finally
      ALists.Free;
    end;
  finally
    cbName.Properties.EndUpdate(False);
  end;
end;

procedure TdxfrmCommonFileDialog.sbePathPathSelected(Sender: TObject);
begin
  SyncPaths(ShellBreadcrumbEdit.SelectedPidl, ShellBreadcrumbEdit);
end;

constructor TdxfrmCommonFileDialog.Create(AOwner: TComponent);
var
  ARegistry: TRegistry;
  ARegDataInfo: TRegDataInfo;
begin
  inherited Create(AOwner);
  FCanSyncPaths := True;
  FFileInfos := TObjectList<TdxFileInfo>.Create;
  FFileTypes := TFileTypeItems.Create(TFileTypeItem);
  FFilterIndex := 1;
  FHistoryUpdateCount := 0;
  FMaxHistoryItemsCount := 10;

  FShellBreadcrumbEdit := TdxShellDialogBreadcrumbEdit.Create(Self);
  FShellBreadcrumbEdit.Width := 615;
  FShellBreadcrumbEdit.Height := 21;
  FShellBreadcrumbEdit.Properties.DropDownIndent := ddiExplorerLike;
  FShellBreadcrumbEdit.TabOrder := 4;
  FShellBreadcrumbEdit.AutoSize := True;
  FShellBreadcrumbEdit.Properties.AllowDragDrop := True;
  FShellBreadcrumbEdit.Properties.PathEditor.UseSystemRecentPaths := True;
  FShellBreadcrumbEdit.Properties.PathEditor.RecentPathsMaxCount := SMaxRecentPathItemCount;
  TdxBreadcrumbEditPathEditorPropertiesAccess(FShellBreadcrumbEdit.Properties.PathEditor).RecentPathsAddToSuggestions := False;
  FShellBreadcrumbEdit.OnPathSelected := sbePathPathSelected;
  FShellBreadcrumbEdit.OnPathValidate := sbePathPathValidate;
  FShellBreadcrumbEdit.OnResize := ShellBreadcrumbResize;
  lisbePath.Caption := '';
  lisbePath.ControlOptions.OriginalWidth := 227;
  lisbePath.Control := ShellBreadcrumbEdit;


  FShowAllFolders := not IsWinSevenOrLater;
  ARegistry := TRegistry.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKeyReadOnly(SExplorerAdvanced) then
    begin
      if ARegistry.GetDataInfo(SShowAllFolders, ARegDataInfo) and (ARegDataInfo.RegData = rdInteger) then
        FShowAllFolders := ARegistry.ReadBool(SShowAllFolders);
      if ARegistry.GetDataInfo(SHideFileExt, ARegDataInfo) and (ARegDataInfo.RegData = rdInteger) then
        FHideFileExt := ARegistry.ReadBool(SHideFileExt);
      ARegistry.CloseKey;
    end;
  finally
    ARegistry.Free;
  end;

  FShellListView := TdxShellDialogListView.Create(Self);
  FShellListView.ShellOptions.CurrentFolderContextMenu := True;
  FShellListView.ShellOptions.ShowZipFilesWithFolders := False;
  FShellListView.OnAfterNavigation := DoShellListViewAfterNavigation;
  FShellListView.OnBeforeNavigation := DoShellListViewBeforeNavigation;
  FShellListView.OnExecuteItem := DoChooseFile;
  FShellListView.OnSelectionChanged := DoShellListViewSelectionChanged;
  FShellListView.OnAddFolder := DoShellListViewAddFolder;
  FShellListView.OnViewChanged := DoViewChanged;
  FShellListView.OnSortColumnChanged := DoShellListViewSortColumnChanged;
  FShellListView.Sorting := True;
  //visual settings
  FShellListView.PaddingOptions.View.Margin := TRect.Create(15, 4, 8, 4);
  FShellListView.ViewStyleIcon.TextLineCount := 3;
  FShellListView.ViewStyleSmallIcon.ColumnWidth := 306;
  //
  liShellListView.Control := FShellListView;

  FShellTreeView := TdxShellDialogTreeView.Create(Self);
  FShellTreeView.OnPathChanged := DoShellTreeViewPathChanged;
  FShellTreeView.OnAddFolder := DoShellTreeViewAddFolder;
  FShellTreeView.OnExpandStateChanged := DoShellTreeViewNodeExpandStateChanged;
  FShellTreeView.BeginUpdate;
  FShellTreeView.Width := 50;
  FShellTreeView.ShellOptions.BeginUpdate;
  FShellTreeView.ShellOptions.ShowNonFolders := False;
  FShellTreeView.ShellOptions.ShowToolTip := False;
  FShellTreeView.ShellOptions.EndUpdate;
  FShellTreeView.FirstLevelNodesVisible := FShowAllFolders;
  FShellTreeView.FocusNodeOnMouseUp := True;
  FShellTreeView.OptionsView.ShowLines := False;
  FShellTreeView.ShowHint := True;
  liShellTreeView.Control := FShellTreeView;
  FShellTreeView.EndUpdate;
  FShellTreeView.ShellRootNode.Expand;

  TcxCustomButtonAccess(btnBack).ShowFocusRect := False;
  TcxCustomButtonAccess(btnForward).ShowFocusRect := False;
  TcxCustomButtonAccess(btnHistory).ShowFocusRect := False;
  TcxCustomButtonAccess(btnUp).ShowFocusRect := False;
  TcxCustomButtonAccess(btnNewFolder).ShowFocusRect := False;
  TcxCustomButtonAccess(btnViews).ShowFocusRect := False;

  actExtraLarge.Visible := IsWinSevenOrLater;
  actSmall.Visible := IsWinSevenOrLater;

  FPreviewPane := TdxDialogFilePreviewPane.Create(Self);
  FPreviewPane.Align := alClient;

  if IsWinSevenOrLater then
  begin
    libeSearch.Visible := True;
    liPathSplitter.Visible := True;
    beSearch.ViewInfo.OnDrawButton := DrawSearchEditButton;
    TcxButtonEditAccess(beSearch).OnResize := SearchEditResize;
  end;

  InitializeLookAndFeel;

  RestoreExpandedState;

  TcxButtonAccess(btnNewFolder).AutoSize := True;
  InitializeLocalizableSources;
  dxResourceStringsRepository.AddListener(Self);
end;

destructor TdxfrmCommonFileDialog.Destroy;
var
  I: Integer;
begin
  dxResourceStringsRepository.RemoveListener(Self);
  StoreExpandedState;
  StoreRecentPaths;
  for I := 0 to alHistory.ActionCount - 1 do
    TdxHistoryItem(alHistory.Actions[I].Tag).Free;
  DisposePidl(FInitialDirPidl);
  dxFreeAndNilPidl(FSearchOriginDirPidl);
  FreeAndNil(FShellTreeView);
  FreeAndNil(FShellListView);
  FreeAndNil(FFileTypes);
  FreeAndNil(FFileInfos);
  FreeAndNil(FPreviewPane);
  FreeAndNil(FSearchControlPopup);
  inherited Destroy;
end;

procedure TdxfrmCommonFileDialog.actFocusSearchEditExecute(Sender: TObject);
begin
  if not beSearch.Focused then
    beSearch.SetFocus;
end;

procedure TdxfrmCommonFileDialog.actStartSearchExecute(Sender: TObject);
begin
  DoSearch;
end;

procedure TdxfrmCommonFileDialog.actStopSearchExecute(Sender: TObject);
begin
  DoStopSearch;
end;

procedure TdxfrmCommonFileDialog.ApplyLocalization;
var
  ALibraryHandle: THandle;
  I: Integer;
begin
  ALibraryHandle := LoadLibraryEx('shell32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    btnCancel.Caption := dxGetLocalizedSystemResourceString(cxSEditButtonCancel, ALibraryHandle, 28743);
    actNewFolder.Caption := dxGetLocalizedSystemResourceString(sdxFileDialogNewFolderCaption, ALibraryHandle,
      IfThen(IsWinSevenOrLater, 16859, 30320)) + ' ';
    actNewFolder.Hint := dxGetLocalizedSystemResourceString(sdxFileDialogNewFolderHint, ALibraryHandle, 31237);
    if IsWinSevenOrLater then
      btnViews.Hint := dxGetLocalizedSystemResourceString(sdxFileDialogViewsHint, ALibraryHandle, 31297);
    btnHistory.Hint := cxGetResourceString(@sdxFileDialogHistoryHint);
    actUp.Hint := cxGetResourceString(@sdxFileDialogUpHint);
    for I := 0 to alViews.ActionCount - 1 do
      TAction(alViews.Actions[I]).Caption := 
        FShellListView.GetViewCaption(alViews.Actions[I].Tag, ALibraryHandle);
  finally
    FreeLibrary(ALibraryHandle);
  end;

  ALibraryHandle := LoadLibraryEx('comdlg32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    if not IsWinSevenOrLater then
      btnViews.Hint := dxGetLocalizedSystemResourceString(sdxFileDialogViewsHint, ALibraryHandle, 711);
  finally
    FreeLibrary(ALibraryHandle);
  end;

  ALibraryHandle :=
    LoadLibraryEx(PWideChar(IfThen(IsWinSevenOrLater, 'comdlg32.dll', 'shell32.dll')), 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    licbName.Caption := dxGetLocalizedSystemResourceString(sdxFileDialogFileNameCaption, ALibraryHandle,
      IfThen(IsWinSevenOrLater, 433, 9124));
  finally
    FreeLibrary(ALibraryHandle);
  end;
  UpdateSearchEdit;
end;

procedure TdxfrmCommonFileDialog.InitializeFilter(const AFilter: string; const AFilterIndex: Integer);
var
  I: Integer;
begin
  FFilterIndex := AFilterIndex;
  InitializeFileTypes(AFilter);
  licbFilter.Visible := FileTypes.Count > 0;
  if not licbFilter.Visible then
  begin
    licbName.AlignVert := avCenter;
    Exit;
  end;
  cbFilter.Properties.BeginUpdate;
  try
    for I := 0 to FileTypes.Count - 1 do
      cbFilter.Properties.Items.Add(FileTypes[I].DisplayName);
    if InRange(FilterIndex, 0, FileTypes.Count) then
      cbFilter.ItemIndex := IfThen(FilterIndex <> 0, FilterIndex - 1)
    else
      cbFilter.ItemIndex := FileTypes.Count - 1;
  finally
    cbFilter.Properties.EndUpdate;
  end;
end;

procedure TdxfrmCommonFileDialog.InitializeFolder(const AInitialDir: string);
var
  ATempPIDL: PItemIDList;
  AHandle: THandle;
  AFindData: TWIN32FindData;
  AExtensions: TStrings;
  I: Integer;
begin
  FIsFolderInitializing := True;
  try
    if IsWinSevenOrLater and (FLoadedInitialDirPidl = nil) and (AInitialDir = '') then
      RestoreInitialDir;
    if FLoadedInitialDirPidl = nil then
    begin
      if (AInitialDir = '') and IsWinSevenOrLater then
      begin
        AExtensions := GetCurrentFilterExtensions;
        try
          for I := 0 to AExtensions.Count - 1 do
          begin
            AHandle := FindFirstFile(PChar(AExtensions[I]), AFindData);
            if AHandle <> INVALID_HANDLE_VALUE then
            begin
              FInitializeDir := GetCurrentDir;
              Windows.FindClose(AHandle);
              Break;
            end;
          end;
        finally
          AExtensions.Free;
        end;
        if (FInitializeDir = '') and Succeeded(cxGetFolderLocation(0, CSIDL_MYDOCUMENTS, 0, 0, ATempPIDL)) then
        begin
          FShellListView.AbsolutePIDL := ATempPIDL;
          DisposePidl(ATempPIDL);
        end;
      end
      else
        FInitializeDir := AInitialDir;
      if FInitializeDir <> '' then
        FShellListView.Path := FInitializeDir;
    end;
  finally
    FIsFolderInitializing := False;
  end;
end;

procedure TdxfrmCommonFileDialog.SetHistoryList(AHistoryList: TStrings);
begin
  cbName.Properties.Items.Assign(AHistoryList);
end;

procedure TdxfrmCommonFileDialog.SetPreviewOptions(AValue: TdxFileDialogPreviewOptions);
begin
  FPreviewVisibility := AValue.Visible;
  PreviewPane.PreviewDelay := AValue.Delay;
  PreviewPane.Sources := AValue.Sources;
end;

procedure TdxfrmCommonFileDialog.ApplyFilter(const AIndex: Integer);
begin
  FFilterIndex := AIndex + 1; //due to specific VCL's property behavior
  SetActiveMask(FileTypes[AIndex].FileMask);
end;

procedure TdxfrmCommonFileDialog.BeginUpdateHistory;
begin
  Inc(FHistoryUpdateCount);
end;

procedure TdxfrmCommonFileDialog.beSearchEnter(Sender: TObject);
begin
  EnsureSearchPopup;
  RepopulateSearchPopup;
end;

procedure TdxfrmCommonFileDialog.beSearchExit(Sender: TObject);
begin
  if FSearchControlPopup <> nil then
    FSearchControlPopup.CloseUp;
end;

procedure TdxfrmCommonFileDialog.beSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  procedure PreviewEditValue(const AEditValue: string; ASelectAll: Boolean);
  begin
    Inc(FLockSearchControlChange);
    try
      beSearch.EditValue := AEditValue;
    finally
      Dec(FLockSearchControlChange);
    end;
    if ASelectAll then
    begin
      beSearch.SelStart := 0;
      beSearch.SelLength := Length(AEditValue);
    end
    else
      beSearch.SelStart := Length(AEditValue);
  end;

begin
  case Key of
    VK_RETURN:
      if FSearchControlPopup <> nil then
      begin
        if FSearchControlPopup.SelectedText <> '' then
        begin
          FSearchControlPopup.ProcessNavigationKey(Key, Shift);
          Key := 0;
        end;
      end;

    VK_ESCAPE:
      if FSearchControlPopup <> nil then
      begin
        FSearchControlPopup.CloseUp;
      end;

    VK_UP, VK_DOWN:
      begin
        if FSearchControlPopup <> nil then
        begin
          FSearchControlPopup.OnSelectItem := nil;
          FSearchControlPopup.ProcessNavigationKey(Key, Shift);
          FSearchControlPopup.OnSelectItem := SelectSearchPopupItem;
          PreviewEditValue(FSearchControlPopup.SelectedText, False);
        end;

        Key := 0;
      end;
  end;
end;

procedure TdxfrmCommonFileDialog.beSearchMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    if not FSearchControlPopupJustClosed then
    begin
      EnsureSearchPopup;
      RepopulateSearchPopup;
    end
    else
      FSearchControlPopupJustClosed := False;
end;

function TdxfrmCommonFileDialog.CanUpdateHistory: Boolean;
begin
  Result := FHistoryUpdateCount = 0;
end;

procedure TdxfrmCommonFileDialog.ChangeView(AViewId: Integer);
begin
  FShellListView.ChangeView(AViewId);
  ViewChanged;
end;

procedure TdxfrmCommonFileDialog.DoClose(var Action: TCloseAction);

  function IsItemBrowsable(AIndex: Integer): Boolean;
  var
    AItemInfo: TcxShellItemInfo;
  begin
    AItemInfo := FShellListView.GetItemInfo(AIndex);
    Result := AItemInfo.IsFolder and not AItemInfo.IsZip or
      AItemInfo.IsFolderLink and not AItemInfo.IsZipFolderLink and not (ofNoDereferenceLinks in Options);
  end;

  function IsBrowsable(AFileName: string): Boolean;

    function RelativePathToAbsolute(const ARelativePath, ABasePath: string; out AAbsolutePath: string): Boolean;
    var
      ABuf: array[0..MAX_PATH-1] of Char;
    begin
      Result := PathCanonicalize(@ABuf, PChar(IncludeTrailingPathDelimiter(ABasePath) + ExcludeTrailingBackslash(ARelativePath)));
      if Result then
        AAbsolutePath := ABuf;
    end;

    function GetRelativePathInfo(const APath, AToPath: string; out AAbsolutePath: string; out AIsDirectory: Boolean): Boolean;
    begin
      if RelativePathToAbsolute(APath, AToPath, AAbsolutePath) then
      begin
        if DirectoryExists(AAbsolutePath) then
        begin
          AIsDirectory := True;
          Exit(True);
        end
        else if FileExists(AAbsolutePath) then
        begin
          AIsDirectory := False;
          Exit(True);
        end
        else
          Result := False;
      end
      else
        Result := False;
    end;

  var
    AFileInfo: TSHFileInfo;
    AFolderName: string;
    APIDL: PItemIDList;
    AFullPath: string;
    AIsDirectory: Boolean;
  begin
    Result := False;
    AFileName := AFileName.DeQuotedString('"');
    if not TdxShellListViewItemProducerAccess(ShellListView.ItemProducer).IsSearchFolder then
    begin
      AFolderName := IncludeTrailingPathDelimiter(AFileName);
      APIDL := PathToAbsolutePIDL(AFolderName, ShellListView.ShellRoot,
        ShellListView.GetViewOptions(True), ExtractFileDrive(AFolderName) = '');
      try
        if (APIDL <> nil) and (cxShellGetThreadSafeFileInfo(PChar(APIDL), 0, AFileInfo, SizeOf(AFileInfo),
          SHGFI_PIDL or SHGFI_ATTRIBUTES) <> 0) and ((AFileInfo.dwAttributes and SFGAO_FOLDER) = SFGAO_FOLDER) and
          ((AFileInfo.dwAttributes and SFGAO_STREAM) <> SFGAO_STREAM) then
        begin
          ShellListView.Path := AFolderName;
          cbName.Clear;
          Result := True;
        end
        else if (APIDL = nil) and (Trim(AFileName) <> '') and GetRelativePathInfo(AFolderName, ShellListView.ShellRoot.CurrentPath, AFullPath, AIsDirectory) then
        begin
          if AIsDirectory then
          begin
            ShellListView.Path := AFullPath;
            cbName.Clear;
            Result := True;
          end;
        end;
      finally
        DisposePidl(APIDL);
      end;
    end;
  end;

  function CalculateBasePath: string;
  var
    AShellItem: IShellItem;
    AShellLibrary: IShellLibrary;
    APidl: PItemIDList;
    AStrPath: PChar;
  begin
    if TdxShellListViewItemProducerAccess(FShellListView.ItemProducer).IsSearchFolder and (FSearchOriginDirPidl <> nil) then
    begin
      Result := GetPidlName(FSearchOriginDirPidl);
      APidl := FSearchOriginDirPidl;
    end
    else
    begin
      Result := FShellListView.Path;
      APidl := FShellListView.ShellRoot.Pidl;
    end;
    if (Result = '') and IsWinSevenOrLater then
    begin
      if Succeeded(SHCreateItemFromIDList(APidl, IID_IShellItem, AShellItem)) and
        Succeeded(SHLoadLibraryFromItem(AShellItem, 0, IID_IShellLibrary, AShellLibrary)) and
        Succeeded(AShellLibrary.GetDefaultSaveFolder(2, IID_IShellItem, AShellItem)) and
        Succeeded(AShellItem.GetDisplayName(SIGDN_FILESYSPATH, AStrPath)) then
      begin
        Result := AStrPath;
        cxMalloc.Free(AStrPath);
      end;
    end;
    if Result <> '' then
      Result := IncludeTrailingBackslash(Result);
  end;

var
  AFileMask: string;
  AFilterItemIndex: Integer;
  ACanClose: Boolean;
  AFileNameFromCombo: string;
  ABasePath: string;
begin
  inherited DoClose(Action);
  StorePreviewPaneInfo;
  if ModalResult = mrOk then
  begin
    if btnOK.Focused then
      FocusControl(cbName);
    if ShellListViewSelectedItemIndices.Count > 0 then
    begin
      if IsItemBrowsable(ShellListViewSelectedItemIndices[0]) then
      begin
        FShellListView.DoItemDblClick(ShellListViewSelectedItemIndices[0]);
        Action := caNone;
      end
    end
    else
    begin
      AFileNameFromCombo := Trim(cbName.Text);
      if AFileNameFromCombo = '' then
        Action := caNone
      else
        if IsMask(AFileNameFromCombo, AFileMask) then
        begin
          if FindMask(AFileMask, AFilterItemIndex) then
            cbFilter.ItemIndex := AFilterItemIndex
          else
            SetActiveMask(AFileMask);
          Action := caNone;
        end
        else
          if IsBrowsable(AFileNameFromCombo) then
            Action := caNone;
    end;
    if Action <> caNone then
    begin
      ABasePath := CalculateBasePath;
      if DoUpdateFileName(ABasePath) and DoUpdateFiles(ABasePath) then
      begin
        if Assigned(OnFileOkClick) then
        begin
          OnFileOkClick(Self, ACanClose);
          if not ACanClose then
            Action := caNone;
        end;
      end
      else
        Action := caNone;
    end;
  end
  else
    FFileName := FSavedFileName;
end;

procedure TdxfrmCommonFileDialog.DoShow;
begin
  inherited DoShow;
  UpdateButtonsSize;
  UpdateButtonsStates;
  UpdatePreviewPane;
  cbName.SetFocus;
  UpdateSearchEdit;
  if beSearch.EditValue <> Null then
    beSearch.SetFocus;
end;

function TdxfrmCommonFileDialog.DoUpdateFileName(const ABasePath: string): Boolean;
var
  AValue: string;
  AFiles: TArray<string>;
  I: Integer;
begin
  FFileName := '';
  DisposePidl(FInitialDirPidl);
  FInitialDirPidl := nil;
  if FFileInfos.Count > 0 then
  begin
    if FFileInfos[0].IsLink then
      AValue := FFileInfos[0].TargetFileName
    else
      AValue := FFileInfos[0].FileName;
  end
  else
  begin
    AValue := cbName.Text;
    if SplitQuotedFilesStr(AValue, AFiles) then
    begin
      for I := 0 to High(AFiles) do
        if AFiles[I] = '' then
          Exit(False);
      if (ofAllowMultiSelect in Options) or (Length(AFiles) = 1) then
        AValue := AFiles[0]
      else
        Exit(False);
    end;
  end;

  if AValue <> '' then
  begin
    if ExtractFilePath(AValue) =  '' then
      FInitialDirPidl := FShellListView.AbsolutePIDL;

    if (ABasePath <> '') and TPath.HasValidPathChars(AValue, False) and not TPath.IsPathRooted(AValue) then
      AValue := ABasePath + AValue;

    if not FileExists(AValue) then
      CheckFileExtension(AValue, FSavedFileName, FileTypes, cbFilter.ItemIndex, DefaultExt);

    Result := IsOptionsCheckPassed(AValue);
    if Result then
      FFileName := AValue;
  end
  else
    Result := False;
end;

function TdxfrmCommonFileDialog.DoUpdateFiles(const ABasePath: string): Boolean;
var
  I: Integer;
  AFileName: string;
  AFiles: TArray<string>;
begin
  AFileName := FileName;
  Files.Clear;
  if (AFileName <> '') and (FFileInfos.Count = 0) and (not (ofAllowMultiSelect in Options)) then
    Files.Add(AFileName)
  else
  begin
    if (FFileInfos.Count = 0) and (ofAllowMultiSelect in Options) then
    begin
      if SplitQuotedFilesStr(cbName.Text, AFiles) then
      begin
        for I := 0 to High(AFiles) do
        begin
          if AFiles[I] = '' then
            Exit(False);
          AFileName := AFiles[I];
          if TPath.HasValidPathChars(AFileName, False) and not TPath.IsPathRooted(AFileName) then
            AFileName := ABasePath + AFileName;
          AFiles[I] := AFileName;
        end;
      end
      else if AFileName <> '' then
        AFiles := [AFileName];
    end
    else
    begin
      SetLength(AFiles, FFileInfos.Count);
      for I := 0 to FFileInfos.Count - 1 do
      begin
        if FFileInfos[I].IsLink then
          AFileName := FFileInfos[I].TargetFileName
        else
        begin
          AFileName := FFileInfos[I].FileName;
          if ExtractFilePath(AFileName) = '' then
            AFileName := ABasePath + AFileName;
        end;
        AFiles[I] := AFileName;
      end;
    end;

    if not Assigned(AFiles) then
      Exit(False);
    for I := 0 to High(AFiles) do
    begin
      AFileName := AFiles[I];
      if not FileExists(AFileName) then
      begin
        CheckFileExtension(AFileName, FSavedFileName, FileTypes, cbFilter.ItemIndex, DefaultExt);
        AFiles[I] := AFileName;
      end;
      if (I <> 0) and (not IsOptionsCheckPassed(AFileName)) then
        Exit(False);
    end;
    for I := 0 to High(AFiles) do
      Files.Add(AFiles[I]);
  end;
  Result := True;
end;

procedure TdxfrmCommonFileDialog.EndUpdateHistory;
begin
  Dec(FHistoryUpdateCount);
end;

function TdxfrmCommonFileDialog.FindMask(const AValue: string; out AIndex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FileTypes.Count - 1 do
    if AnsiSameText(FileTypes[I].FileMask, AValue) then
    begin
      Result := True;
      AIndex := I;
      Break;
    end;
end;

procedure TdxfrmCommonFileDialog.InitializeFileTypes(const AFilter: string);

  function GetPartItem(var AStartPosition: Integer; var APart: string): Boolean;
  var
    ANextPosition: Integer;
  begin
    APart := '';
    if AStartPosition > Length(AFilter) then
      Exit(False);
    ANextPosition := PosEx('|', AFilter, AStartPosition);
    if ANextPosition <= 0 then
       ANextPosition := Length(AFilter) + 1;
    APart := Copy(AFilter, AStartPosition, ANextPosition - AStartPosition);
    AStartPosition := ANextPosition + 1;
    Result := Length(APart) > 0;
  end;

  function TrimFileMask(AFileMask: string): string;
  var
    AParts: TStringList;
    I: Integer;
  begin
    Result := AFileMask;
    AParts := TStringList.Create;
    try
      AParts.StrictDelimiter := True;
      AParts.Delimiter := ';';
      AParts.DelimitedText := Result;
      for I := 0 to AParts.Count - 1 do
        AParts[I] := TrimLeft(AParts[I]); 
      Result := AParts.DelimitedText;
    finally
      AParts.Free;
    end;
  end;

var
  APart: string;
  ACurrentPos: Integer;
  AFilterItem: TFileTypeItem;
begin
  if Pos('|', AFilter) = 0 then
    Exit;
  ACurrentPos := 1;
  while GetPartItem(ACurrentPos, APart) do
  begin
    AFilterItem := FileTypes.Add;
    AFilterItem.DisplayName := APart;
    if GetPartItem(ACurrentPos, APart) then
      AFilterItem.FileMask := TrimFileMask(APart)
    else
      Break;
  end;
end;

procedure TdxfrmCommonFileDialog.SyncPaths(APIDL: PItemIDList; ASyncControl: TWinControl = nil);
begin
  if FCanSyncPaths then
  begin
    FCanSyncPaths := False;
    try
      if dxIsPidlEnumerable(Handle, APIDL) then
      begin
        if ASyncControl <> FShellListView then
          FShellListView.AbsolutePIDL := APidl;
        if ASyncControl <> ShellBreadcrumbEdit then
          ShellBreadcrumbEdit.SelectedPidl := APIDL;
        if (ASyncControl <> FShellTreeView) and not dxIsSearchFolderPidl(APIDL) then
          SyncTreeView(APIDL);
      end;
      UpdateButtonsStates;
    finally
      FCanSyncPaths := True;
    end;
  end;
end;

procedure TdxfrmCommonFileDialog.UpdateButtonsHints;

  function NormalizeHintMessage(const AHintConstValue: string): string;
  var
    AIdx: Integer;
    AEndIdx: Integer;
  begin
    Result := AHintConstValue;
    AIdx := Pos(' (', Result);
    if AIdx <> 0 then
    begin
      AEndIdx := PosEx(')', Result, AIdx + 2);
      if AEndIdx <> 0 then
        Delete(Result, AIdx, AEndIdx - AIdx + 1);
    end;
  end;

var
  ALibraryHandle: THandle;
begin
  if IsWinSevenOrLater then
    ALibraryHandle := LoadLibraryEx('ieframe.dll', 0, LOAD_LIBRARY_AS_DATAFILE)
  else
    ALibraryHandle := 0;

  try
    if actBack.Enabled then
      actBack.Hint := Format(NormalizeHintMessage(dxGetLocalizedSystemResourceString(sdxFileDialogBackEnabledHint, ALibraryHandle, 49856)),
        [TAction(alHistory.Actions[GetCheckedHistoryItemIndex + 1]).Caption]) 
    else
      actBack.Hint := dxGetLocalizedSystemResourceString(sdxFileDialogBackDisabledHint, ALibraryHandle, 49858);
    if actForward.Enabled then
      actForward.Hint := Format(
        NormalizeHintMessage(dxGetLocalizedSystemResourceString(sdxFileDialogForwardEnabledHint, ALibraryHandle, 49857)),
        [TAction(alHistory.Actions[GetCheckedHistoryItemIndex - 1]).Caption]) 
    else
      actForward.Hint := dxGetLocalizedSystemResourceString(sdxFileDialogForwardDisabledHint, ALibraryHandle, 49859);
  finally
    if ALibraryHandle <> 0 then
      FreeLibrary(ALibraryHandle);
  end;

  ALibraryHandle := LoadLibraryEx('shell32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    if PreviewVisible then
      btnFilePreview.Hint := dxGetLocalizedSystemResourceString(sdxFileDialogFilePreviewHidePaneHint, ALibraryHandle, 50210)
    else
      btnFilePreview.Hint := dxGetLocalizedSystemResourceString(sdxFileDialogFilePreviewShowPaneHint, ALibraryHandle, 50209);
  finally
    FreeLibrary(ALibraryHandle);
  end;
end;

procedure TdxfrmCommonFileDialog.UpdateButtonsSize;

  procedure DoUpdateButtonSize(AButton: TcxButton);
  var
    ACalculator: TcxButtonStandardLayoutCalculatorAccess;
    ADesirededWidth, ACalculatedWidth: Integer;
  begin
    ACalculator := TcxButtonStandardLayoutCalculatorAccess.Create(AButton);
    try
      ADesirededWidth := TdxTextMeasurer.TextSizeDT(AButton.Font, AButton.Caption).cx +
        cxMarginsWidth(ACalculator.GetTextOffsets) +
        IfThen(AButton.OptionsImage.Glyph <> nil, ACalculator.OptionsImage.Spacing);

      ACalculator.Calculate;
      ACalculatedWidth := ACalculator.TextAreaSize.cx;

      if ADesirededWidth > ACalculatedWidth then
        AButton.Width := AButton.Width + (ADesirededWidth - ACalculatedWidth);
    finally
      ACalculator.Free;
    end;
  end;

begin
  DoUpdateButtonSize(btnNewFolder);
  DoUpdateButtonSize(btnOK);
  DoUpdateButtonSize(btnCancel);
end;

procedure TdxfrmCommonFileDialog.UpdateButtonsStates;
var
  ACheckedHistoryItemIndex: Integer;
  APidl: PItemIDList;
begin
  ACheckedHistoryItemIndex := GetCheckedHistoryItemIndex;
  actBack.Enabled := (ACheckedHistoryItemIndex >= 0) and (ACheckedHistoryItemIndex < (alHistory.ActionCount - 1));
  actForward.Enabled := ACheckedHistoryItemIndex > 0;
  UpdateButtonsHints;
  APidl := GetCurrentPidl;
  try
    actUp.Enabled := APidl.mkid.cb <> 0;
  finally
    DisposePidl(APidl);
  end;
end;

procedure TdxfrmCommonFileDialog.UpdateHistory(APidl: PItemIDList);
var
  AAction: TAction;
  ACheckedItemIndex: Integer;
  ADisplayName: string;
  AMenuItem: TMenuItem;
  I: Integer;
  AHistoryItem: TdxHistoryItem;
begin
  if CanUpdateHistory then
  begin
    ADisplayName := GetPIDLDisplayName(APIDL);
    if ADisplayName <> '' then
    begin
      AAction := TAction.Create(alHistory);
      AAction.ActionList := alHistory;
      AAction.Caption := ADisplayName;
      AHistoryItem := TdxHistoryItem.Create(APIDL);
      AAction.Tag := NativeInt(AHistoryItem);
      AAction.OnExecute := DoHistoryItemClick;
      AMenuItem := TMenuItem.Create(pmHistory);
      AMenuItem.Action := AAction;

      ACheckedItemIndex := GetCheckedHistoryItemIndex;
      if ACheckedItemIndex <> 0 then
        for I := ACheckedItemIndex - 1 downto 0 do
        begin
          TdxHistoryItem(alHistory.Actions[I].Tag).Free;
          alHistory.Actions[I].Free;
          pmHistory.Items.Delete(I);
        end;
      AAction.Index := 0;
      pmHistory.Items.Insert(0, AMenuItem);
      if alHistory.ActionCount > FMaxHistoryItemsCount then
      begin
        I := alHistory.ActionCount - 1;
        TdxHistoryItem(alHistory.Actions[I].Tag).Free;
        alHistory.Actions[I].Free;
        pmHistory.Items.Delete(I);
      end;
      CheckHistoryItem(AAction);
    end;
    btnHistory.Enabled := alHistory.ActionCount > 1;
  end;
end;

procedure TdxfrmCommonFileDialog.UpdatePreviewPane;
var
  APreviewWidth: Integer;
begin
  libtnFilePreview.Visible := PreviewSupports and not ForceShowPreview;
  if not PreviewSupports then
    Exit;
  FPreviewVisible := NeedPreview(APreviewWidth);
  FPreviewPane.Visible := PreviewVisible;
  if PreviewVisible then
  begin
    lcMain.BeginUpdate;
    try
      liPreviewPane.Control := FPreviewPane;
      liPreviewPane.Width := APreviewWidth;
      liPreviewPaneSplitter.Visible := True;
      liPreviewPane.Visible := True;
      btnFilePreview.OptionsImage.ImageIndex := 8;
    finally
      lcMain.EndUpdate;
    end;
    UpdatePreviewFile;
  end
  else
  begin
    lcMain.BeginUpdate;
    try
      liPreviewPaneSplitter.Visible := False;
      liPreviewPane.Control := nil;
      liPreviewPane.Visible := False;
      btnFilePreview.OptionsImage.ImageIndex := 9;
    finally
      lcMain.EndUpdate;
    end;
  end;
  UpdateButtonsHints;
end;

procedure TdxfrmCommonFileDialog.UpdateViews;
var
  ActionIndex: Integer;
  AAction: TCustomAction;
begin
  ActionIndex := FShellListView.GetCurrentViewId - 1;
  AAction := alViews.Actions[ActionIndex] as TCustomAction;
  AAction.Checked := True;
  btnViews.OptionsImage.ImageIndex := AAction.ImageIndex;
end;

function TdxfrmCommonFileDialog.IsSelectableItem(AIndex: Integer): Boolean;
begin
  Result := not ShellListView.Folders[AIndex].IsFolder or ShellListView.Folders[AIndex].IsZip;
end;

procedure TdxfrmCommonFileDialog.CheckHistoryItem(AItem: TAction);
var
  I: Integer;
begin
  for I := 0 to alHistory.ActionCount - 1 do
    TAction(alHistory.Actions[I]).Checked := False; 
  AItem.Checked := True;
  UpdateButtonsStates;
end;

procedure TdxfrmCommonFileDialog.DeleteSearchMRUItemButtonClick(ASender: TObject);
begin
  DeleteSearchMruItem(FSearchControlPopup.SelectedText);
  RepopulateSearchPopup;
end;

procedure TdxfrmCommonFileDialog.DeleteSearchMruItem(const AItem: string);
var
  AMruSearch: TdxMRUSearch;
begin
  if AItem <> '' then
  begin
    AMRUSearch := TdxMRUSearch.Create;
    try
      AMruSearch.DeleteItem(AItem);
    finally
      AMRUSearch.Free;
    end;
  end;
end;

procedure TdxfrmCommonFileDialog.DoSearch(AAddSearchTextToHistory: Boolean = True);
var
  ASearchPidl: PItemIDList;
  ASearchFolderItemFactory: ISearchFolderItemFactory;
  AQueryParserManager: IQueryParserManager;
  AQueryParser: IQueryParser;
  AQuerySolution: IQuerySolution;
  ACustomProperties: IEnumUnknown;
  AQueryNode: ICondition;
  AMainType: IEntity;
  AShellItem: IShellItem;
  AShellItemArray: IShellItemArray;
  APidl: PItemIDList;
  APreviousPidl: PItemIDList;
begin
  if (beSearch.EditingValue = '') or (beSearch.EditingValue = Null) then
  begin
    DoStopSearch;
    Exit;
  end;
  FIsSearching := True;
  try
    actStopSearch.Visible := True;
    if FSearchOriginDirPidl <> nil then
      ASearchPidl := FSearchOriginDirPidl
    else
      ASearchPidl := ShellListView.ShellRoot.Pidl;
    if Succeeded(CoCreateInstance(CLSID_SearchFolderItemFactory, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
      ISearchFolderItemFactory, ASearchFolderItemFactory)) then
    begin
      if Succeeded(SHCreateItemFromIDList(ASearchPidl, IShellItem, AShellItem)) and
        Succeeded(SHCreateShellItemArrayFromShellItem(AShellItem, IShellItemArray, Pointer(AshellITemArray))) then
      begin
        if Succeeded(ASearchFolderItemFactory.SetScope(AShellItemArray)) then
        begin
          if Succeeded(CoCreateInstance(CLSID_IQueryParserManager, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
            IQueryParserManager, AQueryParserManager)) then
          begin
            if Succeeded(AQueryParserManager.CreateLoadedParser(PChar('SystemIndex'), GetThreadLocale, IQueryParser, Pointer(AQueryParser))) then
            begin
              ACustomProperties := nil;
              if Succeeded(AQueryParser.Parse(PChar(VarToStr(beSearch.EditingText)), nil, AQuerySolution)) then
              begin
                if Succeeded(AQuerySolution.GetQuery(AQueryNode, AMainType)) then
                begin
                  if Succeeded(ASearchFolderItemFactory.SetCondition(AQueryNode)) then
                  begin
                    if Succeeded(ASearchFolderItemFactory.GetIDList(APidl)) then
                    begin
                      if AAddSearchTextToHistory then
                        StoreSearchText;

                      APreviousPidl := ShellListView.AbsolutePIDL;
                      if not dxIsSearchFolderPidl(APreviousPidl) then
                      begin
                        dxFreeAndNilPidl(FSearchOriginDirPidl);
                        FSearchOriginDirPidl := APreviousPidl;
                      end
                      else
                        dxFreeAndNilPidl(APreviousPidl);

                      ShellListView.AbsolutePIDL := APidl;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    FIsSearching := False;
  end;
end;

procedure TdxfrmCommonFileDialog.DoShellTreeViewPathChanged(Sender: TObject);
begin
  SyncWithTreeView;
end;

procedure TdxfrmCommonFileDialog.DoShellTreeViewNodeExpandStateChanged(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
var
  AFindNode: TdxTreeViewNode;
begin
  if (Node = Sender.FocusedNode) and Node.Expanded then
  begin
    AFindNode := FShellTreeView.GetNodeByPIDL(FShellListView.ShellRoot.Pidl, True, True, True, Node);
    if AFindNode <> nil then
      ShellTreeView.FocusedNode := AFindNode;
  end;
end;

procedure TdxfrmCommonFileDialog.DoStopSearch;
begin
  if FSearchOriginDirPidl <> nil then
    ShellListView.AbsolutePIDL := FSearchOriginDirPidl;
end;

procedure TdxfrmCommonFileDialog.DrawSearchEditButton(
  Sender: TcxEditButtonViewInfo; ACanvas: TcxCanvas; var AHandled: Boolean);
var
  ARect: TRect;
  AColor: TdxAlphaColor;
  ASize: TSize;
begin
  AHandled := (Sender.ButtonIndex = 0) and (ACanvas <> nil);
  if AHandled then
  begin
    if not (Sender.Data.UseSkins or Sender.Data.NativeStyle) then
      FillRectByColor(ACanvas.Handle, Sender.Bounds, Sender.Data.BackgroundColor);
    ASize := dxGetImageSize(Sender.Glyph, Sender.Images, 0, Sender.ScaleFactor);
    ARect := cxRectCenter(Sender.Bounds, ASize);
    AColor := dxColorToAlphaColor(SEnder.EditViewInfo.TextColor);
    TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, ARect, ARect, Sender.Glyph, Sender.Images, Sender.ImageIndex, idmNormal, False, 0, clNone, True,
      TdxSimpleColorPalette.Create(AColor, AColor));
  end;
end;

procedure TdxfrmCommonFileDialog.EnsureSearchPopup;
begin
  if FSearchControlPopup = nil then
  begin
    FSearchControlPopup := TdxSearchControlPopup.Create(beSearch);
    FSearchControlPopup.OnClosed := SearchPopupClosed;
    FSearchControlPopup.Adjustable := True;
    FSearchControlPopup.OwnerBounds := beSearch.Bounds;
    FSearchControlPopup.OnSelectItem := SelectSearchPopupItem;
    FSearchControlPopup.OnItemButtonClick := DeleteSearchMRUItemButtonClick;
    FSearchControlPopup.InnerListBox.Images := ilSearch;
    FSearchControlPopup.ItemButtonImageIndex := 1;
    FSearchControlPopup.InnerListBox.Font := beSearch.Style.Font;
    FSearchControlPopup.LookAndFeel.MasterLookAndFeel := beSearch.Style.LookAndFeel;
  end;
end;

function TdxfrmCommonFileDialog.HasPreview: Boolean;
begin
  Result := FPreviewPane <> nil;
end;

function TdxfrmCommonFileDialog.GetCheckedHistoryItemIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to alHistory.ActionCount - 1 do
    if TAction(alHistory.Actions[I]).Checked then 
    begin
      Result := I;
      Break;
    end;
end;

function TdxfrmCommonFileDialog.GetCurrentPidl: PItemIDList;
begin
  Result := FShellListView.AbsolutePIDL; 
end;

function TdxfrmCommonFileDialog.GetInitialDir: string;
begin
  if (FFileInfos.Count > 0) and FFileInfos[0].IsLink then
    Result := FShellListView.Path
  else
    Result := ExtractFileDir(FileName);
end;

function TdxfrmCommonFileDialog.GetIsColumnChanged: Boolean;
begin
  Result := FShellListView.IsColumnChanged;
end;

function TdxfrmCommonFileDialog.GetFileMask: string;
begin
  Result := FileTypes[FilterIndex - 1].FileMask;
end;

function TdxfrmCommonFileDialog.GetSearchMRUItems: TStrings;
var
  AMRUSearch: TdxMRUSearch;
  I: Integer;
begin
  Result := TStringList.Create;
  AMRUSearch := TdxMRUSearch.Create;
  try
    AMRUSearch.GetList(Result);
  finally
    AMRUSearch.Free;
  end;

  if beSearch.EditingText <> '' then
    for I := Result.Count - 1 downto 0 do
    begin
      if not AnsiStartsText(beSearch.EditingText, Result[I]) then
        Result.Delete(I);
    end;
  for I := Result.Count - 1 downto 10 do
    Result.Delete(I);
end;

function TdxfrmCommonFileDialog.GetViewStatePropertyBag(APidl: PItemIDList; out APropertyBag: IPropertyBag): Boolean;

  function GetBagFlagsByPath(const APath: string): Cardinal;
  const
    SHGVSPB_FOLDER = 5;
    SHGVSPB_ROAM = 32;
  begin
    Result := SHGVSPB_FOLDER;
    if dxPathIsUNC(PChar(APath)) then
      Result := Result or SHGVSPB_ROAM;
  end;

  function GetStrProperty(ABag: IPropertyBag; const AName: string): string;
  var
    pvar: OleVariant;
  begin
    if Succeeded(ABag.Read(PChar(AName), pvar, nil)) and VarIsStr(pvar) then
      Result := VarToStr(pvar)
    else
      Result := '';
  end;

var
  AViewStatePropertyBagName: string;
  AFolderTypeId: TGUID;
  AFolderCanonicalName: string;
  AShellItem: IShellItem;
  AShellFolder: IShellFolder;
  AFolderType: IFolderType;
begin
  Result := False;
  if not IsWinSevenOrLater then
    Exit;
  AFolderTypeId := IID_GenericFolderTypeId;
  if Assigned(dxSHGetFolderTypeFromCanonicalName) then
    if Succeeded(dxSHGetViewStatePropertyBag(APidl,
      PChar('Shell'), 5, IID_IPropertyBag, APropertyBag)) then
    begin
      AFolderCanonicalName := GetStrProperty(APropertyBag, 'FolderType');
      if AFolderCanonicalName = '' then
        AFolderCanonicalName := GetStrProperty(APropertyBag, 'SniffedFolderType');
      if AFolderCanonicalName <> '' then
        dxSHGetFolderTypeFromCanonicalName(PChar(AFolderCanonicalName), AFolderTypeId)
      else
        if Succeeded(SHCreateItemFromIDList(APidl, IID_IShellItem, AShellItem)) and
          Succeeded(AShellItem.BindToHandler(nil, BHID_SFObject, IID_IShellFolder, AShellFolder)) and
          Succeeded(AShellFolder.QueryInterface(IID_IFolderType, AFolderType)) then
            AFolderType.GetFolderType(AFolderTypeId);
    end;
  AViewStatePropertyBagName := SComDlg + GUIDToString(AFolderTypeId);
  if Succeeded(dxSHGetViewStatePropertyBag(APidl, PChar(AViewStatePropertyBagName),
    GetBagFlagsByPath(GetPidlName(APidl)), IID_IPropertyBag, APropertyBag)) then
    Result := True;
end;

function TdxfrmCommonFileDialog.GetShellListViewSelectedItemIndices: TdxIntegerList;
begin
  Result := TdxListViewControllerAccess(FShellListView.Controller).SelectedIndices;
end;

function TdxfrmCommonFileDialog.GetCurrentFilterExtensions: TStrings;
var
  AFileMask: string;
  APos: Integer;
  APattern: string;
begin
  Result := TStringList.Create;
  if FFileTypes.Count > 0 then
  begin
    AFileMask := GetFileMask;
    repeat
      APos := Pos(';', AFileMask);
      if APos <> 0 then
      begin
        APattern := Copy(AFileMask, 1, APos - 1);
        Delete(AFileMask, 1, APos);
      end
      else
        APattern := AFileMask;

      APattern := Trim(APattern);

      if (Length(APattern) >= 3) and (APattern[1] + APattern[2] = '*.') then
        Result.Add(APattern);
    until APos = 0;
  end;
end;

procedure TdxfrmCommonFileDialog.InitializeLocalizableSources;
var
  AValue: string;
begin
  if not dxFindLocalizedResourceString(sdxFileDialogSearchNullstring, AValue) then
    FSearchNullStr := StringReplace(dxGetLocalizedSystemResourceString(sdxFileDialogSearchNullstring + ' %1',
      'explorerframe.dll', $3606), '%1', '%s', [])
  else
    FSearchNullStr := AValue + ' %s';
end;

function TdxfrmCommonFileDialog.ReadExpandedState(APersistStream: IPersistStream): Boolean;
var
  AStream: TStream;
  AStreamAdapter: TStreamAdapter;
  ARegistry: TRegistryIniFile;
begin
  AStream := TMemoryStream.Create;
  try
    ARegistry := TRegistryIniFile.Create(SExplorerModules, KEY_READ);
    try
      Result := ARegistry.ReadBinaryStream(SNavPane, SExpandedState, AStream) > 0;
    finally
      ARegistry.Free;
    end;

    if Result then
    begin
      AStreamAdapter := TStreamAdapter.Create(AStream, soReference);
      try
        Result := Succeeded(APersistStream.Load(AStreamAdapter));
      finally
        AStreamAdapter.Free;
      end;
    end;

  finally
    AStream.Free;
  end;
end;

procedure TdxfrmCommonFileDialog.RepopulateSearchPopup;
var
  I: Integer;
  AList: TStrings;
begin
  AList := GetSearchMRUItems;
  try
    if AList.Count > 0 then
    begin
      FSearchControlPopup.DisplayRowsCount := AList.Count;
      FSearchControlPopup.Populate(AList);
      for I := 0 to FSearchControlPopup.InnerListBox.Items.Count - 1 do
        FSearchControlPopup.InnerListBox.Items[I].ImageIndex := 0;
      FSearchControlPopup.Popup(beSearch);
    end
    else
      FSearchControlPopup.CloseUp;
  finally
    AList.Free;
  end;
end;

procedure TdxfrmCommonFileDialog.RestoreExpandedState;
var
  AShellItemArray: IShellItemArray;
  AShellItem: IShellItem;
  AShellItem2: IShellItem2;
  APropertyStore: IPropertyStore;
  APidl: PItemIDList;
  APersistStream: IPersistStream;
  AItemCount: Cardinal;
  I: Integer;
  ANode: TdxTreeViewNode;
  APropertyKey: TPropertyKey;
  AProperty: TPropVariant;
begin
  if not IsWinSevenOrLater then
    Exit;
  if Succeeded(CoCreateInstance(CLSID_ShellItemArrayAsCollection, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
    IID_IPersistStream, APersistStream)) and
    ReadExpandedState(APersistStream) and
    Succeeded(APersistStream.QueryInterface(IID_IShellItemArray, AShellItemArray)) and
    Succeeded(AShellItemArray.GetCount(AItemCount)) then
    for I := 0 to AItemCount - 1 do
      if Succeeded(AShellItemArray.GetItemAt(I, AShellItem)) and
        Succeeded(AShellItem.QueryInterface(IID_IShellItem2, AShellItem2)) and
        Succeeded(AShellItem2.GetPropertyStore(GPS_TEMPORARY, IID_IPropertyStore, APropertyStore)) then
      begin
        APropertyKey.fmtid := PKEY_ExpandState;
        APropertyKey.pid := 2;
        if Succeeded(APropertyStore.GetValue(APropertyKey, AProperty)) and
          Succeeded(SHGetIDListFromObject(AShellItem, APidl)) then
        try
          ANode := FShellTreeView.GetNodeByPIDL(APidl);
          if ANode <> nil then
            ANode.Expanded := AProperty.bool;
        finally
          DisposePidl(APidl);
        end;
      end;
end;

procedure TdxfrmCommonFileDialog.RestoreInitialDir;

  function GetLastSearchString: string;
  var
    AMRUSearch: TdxMRUSearch;
    ASearchHistory: TStringList;
  begin
    AMRUSearch := TdxMRUSearch.Create;
    try
      ASearchHistory := TStringList.Create;
      try
        AMRUSearch.GetList(ASearchHistory);
        if ASearchHistory.Count <> 0 then
          Result := ASearchHistory[0]
        else
          Result := '';
      finally
        ASearchHistory.Free;
      end;
    finally
      AMRUSearch.Free;
    end;
  end;

  function ExtractSearchOriginDir(const AUrl: string): string;
  const
    LocationElementPrefix = 'crumb=location:';
  var
    AElement: string;
  begin
    Result := '';
    for AElement in AUrl.Split(['&'], TStringSplitOptions.ExcludeEmpty) do
      if AElement.StartsWith(LocationElementPrefix, True) then
        Result := TNetEncoding.URL.Decode(Copy(AElement, Length(LocationElementPrefix) + 1, MaxInt));
  end;

var
  AInitialDirStorage: TdxInitialDirStorage;
  ASearchString: string;
  ASearchOriginDir: string;
  ADummy: DWORD;
begin
  AInitialDirStorage := TdxInitialDirStorage.Create;
  try
    if AInitialDirStorage.ReadPidl(FLoadedInitialDirPidl) then
    begin
      FShellListView.AbsolutePIDL := FLoadedInitialDirPidl;
      FSearchOriginDirPidl := nil;
      if IsWinSevenOrLater then
      begin
        if dxIsSearchFolderPidl(FLoadedInitialDirPidl) then
        begin
          ASearchOriginDir := ExtractSearchOriginDir(FShellBreadcrumbEdit.SelectedPath);
          if ASearchOriginDir <> '' then
            SHParseDisplayName(PChar(ASearchOriginDir), nil, FSearchOriginDirPidl, 0, ADummy);

          ASearchString := GetLastSearchString;
          FLoadedSearchString := ASearchString;
          if ASearchString <> '' then
          begin
            beSearch.Text := ASearchString;
            actStopSearch.Visible := True;
          end;
        end;
      end;
    end;
  finally
    AInitialDirStorage.Free;
  end;
end;

procedure TdxfrmCommonFileDialog.SearchEditResize(ASender: TObject);
begin
  UpdateSearchEdit;
end;

procedure TdxfrmCommonFileDialog.SearchPopupClosed(ASender: TObject);
begin
  FSearchControlPopupJustClosed := FSearchControlPopup.JustClosed;
end;

procedure TdxfrmCommonFileDialog.SelectSearchPopupItem(ASender: TObject);
begin
  Inc(FLockSearchControlChange);
  try
    beSearch.EditValue := FSearchControlPopup.SelectedText;
  finally
    Dec(FLockSearchControlChange);
  end;
  FSearchControlPopup.CloseUp;
  DoSearch;
end;

function TdxfrmCommonFileDialog.ForceShowPreview: Boolean;
begin
  Result := PreviewVisibility = bTrue;
end;

function TdxfrmCommonFileDialog.GetFileName: string;
begin
  Result := FFileName;
end;

function TdxfrmCommonFileDialog.GetFilterIndex: Integer;
begin
  Result := FFilterIndex;
end;

function TdxfrmCommonFileDialog.GetTitle: string;
begin
  Result := Caption;
end;

function TdxfrmCommonFileDialog.GetViewStyle: TdxListViewStyle;
begin
  Result := FShellListView.ViewStyle;
end;

procedure TdxfrmCommonFileDialog.InitializeLookAndFeel;
begin
  dxLayoutCxLookAndFeel_NoItemOffset.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  if LookAndFeel.SkinPainter <> nil then
    dxLayoutCxLookAndFeel_NoItemOffset.Offsets.ItemOffset := 0
  else
    dxLayoutCxLookAndFeel_NoItemOffset.Offsets.ItemOffset := 1;
  dxLayoutCxLookAndFeel.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  FShellTreeView.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  FShellListView.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  btnBack.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  btnForward.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  btnUp.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  ShellBreadcrumbEdit.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  beSearch.Style.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  btnOK.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  btnCancel.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  cbName.Style.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  cbFilter.Style.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  btnHistory.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  btnNewFolder.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  btnViews.LookAndFeel.MasterLookAndFeel := LookAndFeel;
end;

function TdxfrmCommonFileDialog.IsFileExistsCheckNeeded: Boolean;
begin
  Result := (FFileInfos.Count > 0) and FFileInfos[0].IsLink or (ofFileMustExist in Options);
end;

function TdxfrmCommonFileDialog.IsFileSystemItem(const AFileName: string): Boolean;

  function CreateShellItemForPath(const APath: string; out AShellItem: IShellItem): HRESULT;
  var
    APidl: PItemIDList;
  begin
    APidl := ILCreateFromPath(PWideChar(APath));
    try
      Result := SHCreateShellItem(nil, nil, APidl, AShellItem);
    finally
      ILFree(APidl);
    end;
  end;

var
  APath: string;
  AShellItem: IShellItem;
  AAttributes: Cardinal;
  APathLength: Integer;
begin

  if Succeeded(CreateShellItemForPath(AFileName, AShellItem)) and
     Succeeded(AShellItem.GetAttributes(SFGAO_FILESYSTEM, AAttributes)) and
     ((AAttributes and SFGAO_FILESYSTEM) <> 0) then
    Exit(True);

  APath := AFileName;
  repeat
    APathLength := Length(APath);
    APath := ExtractFileDir(APath);
    if Length(APath) = APathLength then
      Exit(False);
  until Succeeded(CreateShellItemForPath(APath, AShellItem));
  Result := Succeeded(AShellItem.GetAttributes(SFGAO_FILESYSTEM or SFGAO_FOLDER or SFGAO_STREAM, AAttributes)) and
            (AAttributes and (SFGAO_FILESYSTEM or SFGAO_FOLDER or SFGAO_STREAM) = (SFGAO_FILESYSTEM or SFGAO_FOLDER));
end;

function TdxfrmCommonFileDialog.IsMask(const AFileName: string; var AFileMask: string): Boolean;
begin
  AFileMask := ExtractFileName(AFileName);
  Result := (Pos('*',  AFileMask) > 0) or (Pos('?',  AFileMask) > 0);
end;

function TdxfrmCommonFileDialog.IsOptionsCheckPassed(const AFileName: string): Boolean;
var
  ALibraryHandle: THandle;
  AMsg: string;
begin
  Result := not (FileIsReadOnly(AFileName) and (ofNoReadOnlyReturn in Options));
  if not Result then
  begin
    ALibraryHandle := LoadLibraryEx('comdlg32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
    try
      AMsg := dxGetSystemResourceString(ALibraryHandle, 396);
      AMsg := StringReplace(AMsg, '%1', '%s', []); 
      dxMessageDlg(Format(AMsg, [ExtractFileName(AFileName)]), mtWarning, [mbOK], 0);
    finally
      FreeLibrary(ALibraryHandle);
    end;
  end;
end;

function TdxfrmCommonFileDialog.NeedPreview(out APreviewWidth: Integer): Boolean;
begin
  if PreviewVisibility = bFalse then
    Exit(False);
  ReadDialogFilePreviewInfo(Result, APreviewWidth);
  APreviewWidth := ScaleFactor.Apply(APreviewWidth);
  if not Result then
    Result := IsWinSevenOrLater and ForceShowPreview;
end;

procedure TdxfrmCommonFileDialog.PasteFileNameFromClipboard;
begin
  cxPasteFileNameFromClipboard(cbName);
end;

function TdxfrmCommonFileDialog.PreviewSupports: Boolean;
begin
  Result := IsWinSevenOrLater and (PreviewVisibility <> bFalse);
end;

procedure TdxfrmCommonFileDialog.RestoreListViewState;

  function GetIntProperty(ABag: IPropertyBag; const AName: string): Int64 ;
  var
    pvar: OleVariant;
  begin
    if Succeeded(ABag.Read(PChar(AName), pvar, nil)) and VarIsNumeric(pvar) then
      Result := pvar
    else
      Result := -1;
  end;

  procedure RestoreSortColumnInfo(APropertyBag: IPropertyBag);
  var
    I: Integer;
    AShColumnID: SHCOLUMNID;
    AColCount, ASortDirection: Integer;
    cbRead: LongWord;
    AIStream: IStream;
  begin
    if Succeeded(dxPSPropertyBag_ReadStream(APropertyBag, SColumnSortPropertyName, AIStream)) and
      Succeeded(AIStream.Read(@AColCount, 4, @cbRead)) and (cbRead = 4) and (AColCount > 0) and
      Succeeded(AIStream.Read(@AShColumnID, SizeOf(AShColumnID), @cbRead)) and (cbRead = SizeOf(AShColumnID)) and
      Succeeded(AIStream.Read(@ASortDirection, SizeOf(ASortDirection), @cbRead)) and (cbRead = 4) then
      for I := 0 to ShellListView.Columns.Count - 1 do
        if ShellListView.GetDetailItemByColumnIndex(I).IsShColumnIdEqual(AShColumnID) then
          begin
            ShellListView.Sort(I, ASortDirection > 0);
            Break;
          end;
  end;

var
  {AMode, }ALogicalViewMode, AIconSize: Int64;
  AShellListViewMode: Integer;
  APropertyBag: IPropertyBag;
begin
  AShellListViewMode := DefaultShellListViewMode;
  if GetViewStatePropertyBag(ShellListView.ShellRoot.Pidl, APropertyBag) then
  begin
    RestoreSortColumnInfo(APropertyBag);
    ALogicalViewMode := GetIntProperty(APropertyBag, SLogicalViewMode);
//    AMode := GetIntProperty(APropertyBag, SMode);
    AIconSize := GetIntProperty(APropertyBag, SIconSize);
    if ALogicalViewMode in [FLVM_ICONS, FLVM_TILES, FLVM_CONTENT] then
    begin
      if AIconSize < 32 then
        AShellListViewMode := cmdSmallIconId
      else
        if AIconSize < 96 then
          AShellListViewMode := cmdIconId
        else
          if AIconSize < 256 then
             AShellListViewMode := cmdLargeIconId
          else
            AShellListViewMode := cmdExtraLargeIconId;
    end
    else
      if ALogicalViewMode = FLVM_DETAILS then
        AShellListViewMode := cmdDetailId
      else
        if ALogicalViewMode = FLVM_LIST then
          AShellListViewMode := cmdListId;
  end;

  FShellListView.ChangeView(AShellListViewMode);
  UpdateViews;
end;

procedure TdxfrmCommonFileDialog.SetActiveMask(AValue: string);
begin
  FShellListView.ShellOptions.FileMask := ExtractFileName(AValue);
end;

procedure TdxfrmCommonFileDialog.SetFileName(const AValue: string);
var
  AFileInfo: TdxFileInfo;
begin
  FSavedFileName := AValue;
  if FHideFileExt then
    cbName.Text := ChangeFileExt(AValue, '')
  else
    cbName.Text := AValue;
  if AValue <> '' then
  begin
    AFileInfo := TdxFileInfo.Create;
    AFileInfo.FileName := AValue;
    FFileInfos.Add(AFileInfo);
  end;
end;

procedure TdxfrmCommonFileDialog.SetOptions(const AValue: TOpenOptions);
begin
  inherited SetOptions(AValue);
  FShellListView.ShellOptions.ShowHidden := ofForceShowHidden in Options;
  FShellTreeView.ShellOptions.ShowHidden := ofForceShowHidden in Options;
  ShellBreadcrumbEdit.Properties.ShellOptions.ShowHiddenFolders := ofForceShowHidden in Options;
  FShellListView.NavigateFolderLinks := not (ofNoDereferenceLinks in Options);
end;

procedure TdxfrmCommonFileDialog.SetFileTypes(const AValue: TFileTypeItems);
begin
  if AValue <> nil then
    FFileTypes.Assign(AValue);
end;

procedure TdxfrmCommonFileDialog.SetPreviewVisible(AValue: Boolean);
begin
  if not PreviewSupports then
    Exit;
  if FPreviewVisible <> AValue then
  begin
    FPreviewVisible := AValue;
    StorePreviewPaneInfo;
    UpdatePreviewPane;
  end;
end;

procedure TdxfrmCommonFileDialog.ShellBreadcrumbResize(Sender: TObject);
begin
  if beSearch.Visible and (beSearch.Height <> ShellBreadcrumbEdit.Height) then
    beSearch.Height := ShellBreadcrumbEdit.Height;
end;

procedure TdxfrmCommonFileDialog.StoreExpandedState;

  procedure AddNodeExpandStateToCollection(ANode: TdxTreeViewNode; AObjectCollection: IObjectCollection);
  var
    AShellItem2: IShellItem2;
    APropertyStore: IPropertyStore;
    APropertyKey: TPropertyKey;
    AProperty: TPropVariant;
    APidl: PItemIDList;
  begin
    APidl := FShellTreeView.GetNodeAbsolutePIDL(ANode);
    try
      if Succeeded(SHCreateItemFromIDList(APidl, IID_IShellItem2, AShellItem2)) and
        Succeeded(AObjectCollection.AddObject(AShellItem2)) and
        Succeeded(AShellItem2.GetPropertyStore(GPS_TEMPORARY, IID_IPropertyStore, APropertyStore)) then
      begin
        APropertyKey.fmtid := PKEY_ExpandState;
        APropertyKey.pid := 2;
        ZeroMemory(@AProperty, SizeOf(AProperty));
        AProperty.vt := VT_BOOL;
        AProperty.boolVal := ANode.Expanded;
        APropertyStore.SetValue(APropertyKey, AProperty);
      end;
    finally
      DisposePidl(APidl);
    end;
  end;

var
  AShellItemArray: IShellItemArray;
  APersistStream: IPersistStream;
  I: Integer;
  ANode: TdxTreeViewNode;
  AObjectCollection: IObjectCollection;
begin
  if not IsWinSevenOrLater then
    Exit;

  if Succeeded(CoCreateInstance(CLSID_ShellItemArrayAsCollection, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
    IID_IShellItemArray, AShellItemArray)) then
    begin
      if Succeeded(AShellItemArray.QueryInterface(IID_IObjectCollection, AObjectCollection)) then
      begin
        if FShellTreeView.QuickAccessRootNode <> nil then
          AddNodeExpandStateToCollection(FShellTreeView.QuickAccessRootNode, AObjectCollection);
        if FShellTreeView.FavoritesRootNode <> nil then
          AddNodeExpandStateToCollection(FShellTreeView.FavoritesRootNode, AObjectCollection);
        for I := 0 to FShellTreeView.ShellRootNode.Count - 1 do
        begin
          ANode := FShellTreeView.ShellRootNode.Items[I];
          AddNodeExpandStateToCollection(ANode, AObjectCollection);
        end;
      end;
      if Succeeded(AShellItemArray.QueryInterface(IID_IPersistStream, APersistStream)) then
        WriteExpandedState(APersistStream);
    end;
end;

procedure TdxfrmCommonFileDialog.StoreFileNameToMRUList;
var
  AMRUPidls: TdxMRUPidls;
  APidl: PItemIDList;
  AFilter, AFileExt: string;
  AMruFileName: string;
begin
  if FileTypes.Count = 0 then
    Exit;

  if (FFileInfos.Count > 0) and FFileInfos[0].IsLink then
    AMruFileName := FFileInfos[0].FileName
  else
    AMruFileName := FileName;
  if (FFileInfos.Count > 0) and (FFileInfos[0].Pidl <> nil) then
    APidl := GetPidlCopy(FFileInfos[0].Pidl)
  else
    APidl := PathToAbsolutePIDL(AMruFileName, FShellListView.ShellRoot,
      [svoShowFiles, svoShowFolders, svoShowHidden], False);

  if APidl <> nil then
  try
    AFilter := GetFileMask;
    if AFilter <> '*.*' then 
    begin
      AFileExt := ExtractFileExt(AMruFileName);
      AFilter := Copy(AFileExt, 2, Length(AFileExt) - 1);
    end
    else
      AFilter := '*';

    AMRUPidls := TdxMRUPidls.Create(AFilter);
    try
      AMRUPidls.AddItem(APidl);
    finally
      AMRUPidls.Free;
    end;

    AddToRecentDocs(APidl, AMruFileName);
  finally
    DisposePidl(APidl);
  end;
end;

procedure TdxfrmCommonFileDialog.StoreInitialDir;
var
  AInitialDirStorage: TdxInitialDirStorage;
begin
  if FInitialDirPidl = nil then
  begin
    if (FFileInfos.Count > 0) and (FFileInfos[0].Pidl <> nil) then
      FInitialDirPidl := GetPidlParent(FFileInfos[0].Pidl)
    else
      if (FFileInfos.Count = 0) or not FFileInfos[0].IsLink then
        FInitialDirPidl := PathToAbsolutePIDL(ExtractFileDir(FileName), FShellListView.ShellRoot,
           [svoShowFiles, svoShowFolders, svoShowHidden], False);
  end;
  if FInitialDirPidl = nil then
    FInitialDirPidl := FShellListView.AbsolutePIDL;
  try
    if FInitialDirPidl <> nil then
    begin
      AInitialDirStorage := TdxInitialDirStorage.Create;
      try
        AInitialDirStorage.WritePidl(FInitialDirPidl);
        if dxIsSearchFolderPidl(FInitialDirPidl) then
          StoreSearchText;
      finally
        AInitialDirStorage.Free;
      end;
    end;
  finally
    DisposePidl(FInitialDirPidl);
    FInitialDirPidl := nil;
  end;
end;

procedure TdxfrmCommonFileDialog.StorePreviewPaneInfo;
begin
  if PreviewSupports and (PreviewVisibility = bDefault) then
    WriteDialogFilePreviewInfo(PreviewVisible, ScaleFactor.Revert(liPreviewPane.Width));
end;

procedure TdxfrmCommonFileDialog.StoreRecentPaths;
var
  ARegistry: TRegistryIniFile;
  I: Integer;
begin
  if not IsWinSevenOrLater then
    Exit;
  ARegistry := TRegistryIniFile.Create(SExplorerRegPath, KEY_WRITE);
  try
    for I := 0 to Min(ShellBreadcrumbEdit.Properties.PathEditor.RecentPaths.Count - 1, SMaxRecentPathItemCount - 1) do
    begin
      ARegistry.WriteString(STypedPaths, Format('url%d', [I + 1]), ShellBreadcrumbEdit.Properties.PathEditor.RecentPaths[I].Path);
    end;
  finally
    ARegistry.Free;
  end;
end;

procedure TdxfrmCommonFileDialog.StoreSearchText;
var
  AMRUSearch: TdxMRUSearch;
begin
  if (beSearch.EditingText <> '') and (beSearch.EditingText <> beSearch.Properties.Nullstring) then
  begin
    AMRUSearch := TdxMRUSearch.Create;
    try
      AMRUSearch.AddItem(beSearch.EditingText);
    finally
      AMRUSearch.Free;
    end;
  end;
end;

procedure TdxfrmCommonFileDialog.SyncTreeView(APIDL: PItemIDList);
var
  ANode: TdxTreeViewNode;
begin
  ANode := FShellTreeView.GetNodeByPIDL(APIDL, True, True);
  if ANode <> nil then
  begin
    FShellTreeView.FocusedNode := ANode;
    FShellTreeView.MakeVisible(FShellTreeView.FocusedNode);
  end;
end;

procedure TdxfrmCommonFileDialog.SyncWithTreeView;
var
  ATreeViewPidl, ACurrentPidl: PItemIDList;
begin
  if (FShellTreeView.FocusedNode <> nil) and not FShellTreeView.FocusedNode.IsRoot then
  begin
    ACurrentPidl := GetCurrentPidl;
    ATreeViewPidl := FShellTreeView.AbsolutePIDL;
    try
      if not EqualPIDLs(ATreeViewPidl, ACurrentPidl) then
        SyncPaths(ATreeViewPidl, FShellTreeView);
    finally
      DisposePidl(ATreeViewPidl);
      DisposePidl(ACurrentPidl);
    end;
  end;
end;

procedure TdxfrmCommonFileDialog.UpdatePreviewFile;
var
  AIndex: Integer;
  AFileName: string;
  AFolder: TcxShellFolder;
begin
  if HasPreview and PreviewVisible then
  begin
    if ShellListViewSelectedItemIndices.Count > 0 then
    begin
      AIndex := ShellListViewSelectedItemIndices[0];
      AFolder := FShellListView.Folders[AIndex];
      if IsSelectableItem(AIndex) then
      begin
        AFileName := AFolder.PathName;
        if FileExists(AFileName) then
          FPreviewPane.FileName := AFileName;
      end
      else
        FPreviewPane.FileName := '';
    end
    else
      FPreviewPane.FileName := '';
  end;
end;

procedure TdxfrmCommonFileDialog.UpdateSearchEdit;
var
  APidl: PItemIDList;
  ASearchText: string;
begin
  if FSearchOriginDirPidl <> nil then
    APidl := FSearchOriginDirPidl
  else
    APidl := ShellListView.ShellRoot.Pidl;
  ASearchText := Format(FSearchNullStr, [GetPidlDisplayName(APidl)]);
  beSearch.Properties.Nullstring := cxGetStringAdjustedToWidth(beSearch.Style.Font, ASearchText, beSearch.InnerControl.Width);
end;

procedure TdxfrmCommonFileDialog.UpdateSelectedFilesInfo;
var
  AValue: string;
  I: Integer;
  AFileName: string;
  AInitialDir: string;
begin
  Files.Clear;
  FFileName := '';

  if FFileInfos.Count > 0 then
    AValue := FFileInfos[0].FileName
  else
    AValue := cbName.Text;

  if AValue = '' then
    Exit;
  if ExtractFilePath(AValue) = '' then
    AValue := IncludeTrailingPathDelimiter(FShellListView.Path) + AValue;
  FFileName := AValue;


  AFileName := FileName;
  AInitialDir := ExtractFileDir(AFileName);

  if (AFileName <> '') and (FFileInfos.Count = 0) then
    Files.Add(AFileName)
  else
  begin
    if AInitialDir <> '' then
      AInitialDir := IncludeTrailingPathDelimiter(AInitialDir);
    for I := 0 to FFileInfos.Count - 1 do
    begin
      AFileName := FFileInfos[I].FileName;
      if ExtractFilePath(AFileName) = '' then
        AFileName := AInitialDir + AFileName;
      Files.Add(AFileName);
    end;
  end;
end;

procedure TdxfrmCommonFileDialog.ViewChanged;
begin
  UpdateViews;
  StoreListViewState;
end;

procedure TdxfrmCommonFileDialog.WriteExpandedState(APersistStream: IPersistStream);
var
  AStream: TStream;
  AStreamAdapter: TStreamAdapter;
  ARegistry: TRegistryIniFile;
begin
  AStream := TMemoryStream.Create;
  try
    AStreamAdapter := TStreamAdapter.Create(AStream, soReference);
    try
      APersistStream.Save(AStreamAdapter, True);
    finally
      AStreamAdapter.Free;
    end;

    ARegistry := TRegistryIniFile.Create(SExplorerModules);
    try
      AStream.Position := 0;
      ARegistry.WriteBinaryStream(SNavPane, SExpandedState, AStream);
    finally
      ARegistry.Free;
    end;

  finally
    AStream.Free;
  end;
end;

procedure TdxfrmCommonFileDialog.CMDialogKey(var Message: TCMDialogKey);
begin
  if GetKeyState(VK_MENU) >= 0 then
    case Message.CharCode of
      VK_RETURN:
        begin
          if ShellTreeView.Focused or ShellBreadcrumbEdit.Focused or beSearch.Focused then
          begin
            Message.Result := 0;
            Exit;
          end;
        end;
      VK_ESCAPE:
        begin
          if beSearch.Focused then
          begin
            Message.Result := 0;
            beSearch.Parent.SetFocus;
            Exit;
          end;
        end;
    end;
  inherited;
end;

procedure TdxfrmCommonFileDialog.sbePathPathValidate(Sender: TObject; const APath: string;
  var ANode: TdxBreadcrumbEditNode; var AErrorText: string; var AError: Boolean);
begin
  if AError and (ANode = nil) then
  begin
    dxMessageDlg(AErrorText, mtError, [mbOK], 0);
    Abort;
  end;
end;

procedure TdxfrmCommonFileDialog.WMAppCommand(var Msg: TMessage);
begin
  case GET_APPCOMMAND_LPARAM(Msg.LParam) of
    APPCOMMAND_BROWSER_BACKWARD:
    begin
      if btnBack.Enabled then
        btnBack.Click;
      Msg.Result := 1;
    end;
    APPCOMMAND_BROWSER_FORWARD:
    begin
      if btnForward.Enabled then
        btnForward.Click;
      Msg.Result := 1;
    end;
  end;
end;

procedure TdxfrmCommonFileDialog.SetTitle(const AValue: string);
begin
  Caption := AValue;
end;

procedure TdxfrmCommonFileDialog.SetViewStyle(const AValue: TdxListViewStyle);
begin
  if AValue <> FShellListView.ViewStyle then
  begin
    FShellListView.ViewStyle := AValue;
    UpdateViews;
  end;
end;

procedure TdxfrmCommonFileDialog.StoreColumns;
var
  APropertyBag: IPropertyBag;
  AIStream: IStream;
  AData1, AData2: DWORD;
  AData3: UInt64;
  AItemCount, AItemSize: Integer;
  cbWritten: LongWord;
  I: Integer;
  AShColumnID: SHCOLUMNID;
  AWidth: Integer;
  AIsWriteStreamError: Boolean;
begin
  if GetViewStatePropertyBag(ShellListView.ShellRoot.Pidl, APropertyBag) then
  begin
    if ShellListView.VisibleColumnInfos.Count > 0 then
    begin
      AIsWriteStreamError := False;
      AData1 := $FDDFDFFD;
      AData2 := $10;
      AData3 := 0;
      AItemCount := ShellListView.VisibleColumnInfos.Count;
      AItemSize := 24;
      AIStream := TStreamAdapter.Create(TMemoryStream.Create, soOwned);
      if Succeeded(AIStream.Write(@AData1, 4, @cbWritten)) and (cbWritten = 4) and
        Succeeded(AIStream.Write(@AData2, 4, @cbWritten)) and (cbWritten = 4) and
        Succeeded(AIStream.Write(@AData3, 8, @cbWritten)) and (cbWritten = 8) and
        Succeeded(AIStream.Write(@AItemCount, 4, @cbWritten)) and (cbWritten = 4) and
        Succeeded(AIStream.Write(@AItemSize, 4, @cbWritten)) and (cbWritten = 4) then
        for I := 0 to ShellListView.VisibleColumnInfos.Count - 1 do
        begin
          AShColumnID := ShellListView.VisibleColumnInfos[I].ColumnId;
          AWidth := ShellListView.VisibleColumnInfos[I].Width;
          if not (Succeeded(AIStream.Write(@AShColumnID, SizeOf(AShColumnID), @cbWritten)) and
            (cbWritten = SizeOf(AShColumnID)) and
            Succeeded(AIStream.Write(@AWidth, 4, @cbWritten)) and (cbWritten = 4)) then
          begin
            AIsWriteStreamError := True;
            Break;
          end;
        end;

      if not AIsWriteStreamError then
        dxPSPropertyBag_WriteStream(APropertyBag, SColumnInfoPropertyName, AIStream);
    end;
  end;
  FShellListView.IsColumnChanged := False;
end;

procedure TdxfrmCommonFileDialog.StoreListViewState;

  procedure SetIntProperty(ABag: IPropertyBag; const AName: string; AValue: Integer);
  var
    pvar: OleVariant;
  begin
    pvar := AValue;
    ABag.Write(PChar(AName), pvar);
  end;

var
  AViewId: Integer;
  AMode, ALogicalViewMode, AIconSize: Integer;
  APropertyBag: IPropertyBag;
begin
  if GetViewStatePropertyBag(ShellListView.ShellRoot.Pidl, APropertyBag) then
  begin
    AViewId := FShellListView.GetCurrentViewId;
    if AViewId = cmdDetailId then
    begin
      ALogicalViewMode := FLVM_DETAILS;
      AIconSize := -1;
      AMode := FVM_DETAILS;
    end
    else
      if AViewId = cmdListId then
      begin
        ALogicalViewMode := FLVM_LIST;
        AIconSize := -1;
        AMode := FVM_LIST;
      end
      else
      begin
        ALogicalViewMode := FLVM_ICONS;
        if AViewId = cmdSmallIconId then
        begin
          AIconSize := 16;
          AMode := FVM_SMALLICON;
        end
        else
          if AViewId = cmdIconId then
          begin
            AIconSize := 48;
            AMode := FVM_ICON;
          end
          else
            if AViewId = cmdLargeIconId then
            begin
              AIconSize := 96;
              AMode := FVM_ICON;
            end
            else  // cmdExtraLargeIconId
            begin
              AIconSize := 256;
              AMode := FVM_ICON;
            end;
      end;

    SetIntProperty(APropertyBag, SLogicalViewMode, ALogicalViewMode);
    SetIntProperty(APropertyBag, SMode, AMode);
    if AIconSize <> -1 then
      SetIntProperty(APropertyBag, SIconSize, AIconSize);
  end;
end;

procedure TdxfrmCommonFileDialog.StoreSortColumnInfo;
var
  APropertyBag: IPropertyBag;
  AIStream: IStream;
  AColumnIndex: Integer;
  AColCount: Integer;
  cbWritten: LongWord;
  AColumnID, ASortDirection: Integer;
  AProducer: TdxShellListViewItemProducerAccess;
  AShColumnID: SHCOLUMNID;
begin
  if GetViewStatePropertyBag(ShellListView.ShellRoot.Pidl, APropertyBag) then
  begin
    AProducer := TdxShellListViewItemProducerAccess(ShellListView.ItemProducer);
    AColumnID := AProducer.SortColumn;
    ASortDirection := IfThen(AProducer.SortDescending, -1, 1);
    if (AColumnID >= 0) and (AColumnID < AProducer.Details.Count) then
    begin
      AColumnIndex := FShellListView.GetColumnIndexByID(AColumnID);
      if AColumnIndex >= 0 then
      begin
        AIStream := TStreamAdapter.Create(TMemoryStream.Create, soOwned);
        AColCount := 1;
        AShColumnID := FShellListView.GetDetailItemByColumnIndex(AColumnIndex).ShColumnID;
        if Succeeded(AIStream.Write(@AColCount, 4, @cbWritten)) and (cbWritten = 4) and
          Succeeded(AIStream.Write(@AShColumnID, SizeOf(AShColumnID), @cbWritten)) and (cbWritten = SizeOf(AShColumnID)) and
          Succeeded(AIStream.Write(@ASortDirection, SizeOf(ASortDirection), @cbWritten)) and (cbWritten = SizeOf(ASortDirection)) then
          dxPSPropertyBag_WriteStream(APropertyBag, SColumnSortPropertyName, AIStream);
      end;
    end;
  end;
  FIsSortColumnChanged := False;
end;

function TdxfrmCommonFileDialog.ShowModal: Integer;
var
  AMRUSearch: TdxMRUSearch;
begin
  dxFileDialogsSettings.LoadDialogInfo(Self);
  Result := inherited ShowModal;
  if Result = mrOk then
  begin
    dxFileDialogsSettings.InitialDir := GetInitialDir;
    if IsWinSevenOrLater then
    begin
      StoreInitialDir;
      StoreFileNameToMRUList;
    end;
  end
  else
  begin
    if IsWinSevenOrLater then
    begin
      if dxIsSearchFolderPidl(FLoadedInitialDirPidl) and (FLoadedSearchString <> '') then
      begin
        AMRUSearch := TdxMRUSearch.Create;
        try
          AMRUSearch.AddItem(FLoadedSearchString);
        finally
          AMRUSearch.Free;
        end;
      end;
    end;
  end;

  if FIsSortColumnChanged then
    StoreSortColumnInfo;
  if FShellListView.IsColumnChanged then
    StoreColumns;
  dxFileDialogsSettings.SaveDialogInfo(Self);
end;

class function TdxfrmCommonFileDialog.SplitQuotedFilesStr(const AStr: string;
  out AResult: TArray<string>): Boolean;
var
  P: PChar;
  AStrEnd: PChar;
  AFileName: string;
  AQuotedStrStart: PChar;
begin
  if AStr = '' then
    Exit(False);

  P := Pointer(AStr);
  AStrEnd := P + Length(AStr) - 1;
  while P <= AStrEnd do
  begin
    while (P <= AStrEnd) and (P^ = ' ') do
      Inc(P);
    if P > AStrEnd then
      Exit(Assigned(AResult));
    if P^ <> '"' then
    begin
      AResult := nil;
      Exit(False);
    end;
    AQuotedStrStart := P;
    Inc(P);
    while (P <= AStrEnd) and (P^ <> '"') do
      Inc(P);
    if (P > AStrEnd) then
    begin
      AResult := nil;
      Exit(False);
    end;
    SetString(AFileName, AQuotedStrStart + 1, P - AQuotedStrStart - 1);
    AResult := AResult + [AFileName];
    Inc(P);
  end;
  Result := Assigned(AResult);
end;


procedure TdxfrmCommonFileDialog.TranslationChanged;
begin
  InitializeLocalizableSources;
end;

{ TdxfrmCommonFileDialog.TdxFileInfo }

destructor TdxfrmCommonFileDialog.TdxFileInfo.Destroy;
begin
  Pidl := nil;
  inherited;
end;

procedure TdxfrmCommonFileDialog.TdxFileInfo.SetPidl(AValue: PItemIDList);
begin
  DisposePidl(FPidl);
  FPidl := AValue;
end;

{TdxfrmCommonFileDialog.TdxShellDialogTreeView}

constructor TdxfrmCommonFileDialog.TdxShellDialogTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OptionsSelection.RowSelect := True;
  OptionsSelection.RightClickSelect := True;
  OptionsSelection.HideSelection := False;
  OptionsBehavior.CaptionEditing := True;
  OptionsBehavior.HotTrack := True;
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.BrowseItem(AShellItem: IShellItem; A: UINT): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.GetCurrentItem(const AGuid: TGuid; out Obj): HRESULT;
var
  APidl: PItemIDList;
begin
  APidl := (Owner as TdxfrmCommonFileDialog).ShellListView.AbsolutePIDL;
  try
  if Succeeded(SHCreateItemFromIDList(APIDL, AGuid, Obj)) then
    Result := S_OK
  else
    Result := E_NOTIMPL;
  finally
    DisposePidl(APidl);
  end;
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.GetPendingItem(const AGuid: TGuid; out Obj): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.QueryService(const rsid, iid: TGuid;
  out Obj): HResult;
begin
  if Supports(Self, iid, Obj) then
    Result := S_OK
  else
    Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.AllowActivateEditByMouse: Boolean;
begin
  Result := False;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogTreeView.DoNodeExpandStateChanged(ANode: TdxTreeViewNode);
begin
  inherited DoNodeExpandStateChanged(ANode);
  if Assigned(FOnExpandStateChanged) then
    FOnExpandStateChanged(Self, ANode);
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.GetContextMenuSite: IUnknown;
begin
  if IsWinSevenOrLater then
    Result := Self
  else
    Result := inherited GetContextMenuSite;
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.GetDefaultScrollbarsValue: TcxScrollStyle;
begin
  Result := ssVertical;
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.HasGroups: Boolean;
begin
  Result := True;
end;

function TdxfrmCommonFileDialog.TdxShellDialogTreeView.IsFavoritesVisible: Boolean;
begin
  Result := True;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogTreeView.KeyDown(var Key: Word; Shift: TShiftState);
var
  AKey: Word;
begin
  AKey := Key;
  if (AKey = VK_LEFT) and (FocusedNode <> nil) and not FocusedNode.Expanded and
    not ShowFirstLevelNodes and (FocusedNode.Level = 1) then
      Key := 0;
  inherited KeyDown(Key, Shift);
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogTreeView.KeyPress(var Key: Char);
begin
  if Ord(Key) = VK_SPACE then
    Key := #0;
  inherited KeyPress(Key);
end;

{TdxfrmCommonFileDialog.TdxShellDialogListView}

constructor TdxfrmCommonFileDialog.TdxShellDialogListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisibleColumnInfos := TList<TdxShellColumnInfo>.Create;
  ItemProducer.Details.OnAddDetailItem := AddListViewVisibleColumn;
  CheckBoxes := GetExplorerShowCheckBoxes;
end;

destructor TdxfrmCommonFileDialog.TdxShellDialogListView.Destroy;
begin
  FreeAndNil(FVisibleColumnInfos);
  FreeAndNil(FHeaderPopup);
  inherited Destroy;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.QueryService(const rsid, iid: TGuid;
  out Obj): HResult;
begin
  if Supports(Self, iid, Obj) then
    Result := S_OK
  else
    Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetCurrentViewMode(var pViewMode: UINT): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.SetCurrentViewMode(ViewMode: UINT): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetFolder(const riid: TIID; out ppv): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.Item(iItemIndex: Integer; var ppidl: PItemIDList): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.ItemCount(uFlags: UINT; var pcItems: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.Items(uFlags: UINT; const riid: TIID; out ppv): HRESULT;
var
  AShellItem: IShellItem;
begin
  if (uFlags = $80000001) and Succeeded(SHCreateItemFromIDList(ShellRoot.Pidl, IShellItem, AShellItem)) and
    Succeeded(SHCreateShellItemArrayFromShellItem(AShellItem, IShellItemArray, Pointer(ppv))) then
    Result := S_OK
  else
    Result := E_NOTIMPL;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.CheckEmulateDblClick(X, Y: Integer);
var
  R: TRect;
  DX, DY: Integer;
begin
  if not FGotDblClickMessage and ((GetTickCount - FLastLeftMouseButtonDownTime) <= GetDoubleClickTime) then
  begin
    DX := ScaleFactor.Apply(GetSystemMetrics(SM_CXDOUBLECLK)) div 2;
    DY := ScaleFactor.Apply(GetSystemMetrics(SM_CYDOUBLECLK)) div 2;
    R.Init(
      FLastLeftMouseButtonDownPos.X - DX,
      FLastLeftMouseButtonDownPos.Y - DY,
      FLastLeftMouseButtonDownPos.X + DX,
      FLastLeftMouseButtonDownPos.Y + DY);
    if R.Contains(X, Y) then
      DblClick;
  end;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Dialog.PreviewVisible then
    CheckEmulateDblClick(X, Y);
  FLastLeftMouseButtonDownTime := GetTickCount;
  FLastLeftMouseButtonDownPos.Init(X, Y);
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FGotDblClickMessage := False;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetSelectionMarkedItem(var piItem: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetFocusedItem(var piItem: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetItemPosition(pidl: PItemIDList; var ppt: TPoint): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetSpacing(var ppt: TPoint): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetDefaultSpacing(var ppt: TPoint): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetDialog: TdxfrmCommonFileDialog;
begin
  Result := TdxfrmCommonFileDialog(Owner);
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetAutoArrange: HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.SelectItem(iItem: Integer; dwFlags: DWORD): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.SelectAndPositionItems(cidl: UINT; apidl: PItemIDList; var apt: TPoint; dwFlags: DWORD): HRESULT;
begin
  Result := E_NOTIMPL;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.DoColumnPosChanged(AColumn: TdxListColumn);
begin
  inherited DoColumnPosChanged(AColumn);
  UpdateColumnInfos;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.DoColumnSizeChanged(AColumn: TdxListColumn);
begin
  inherited DoColumnSizeChanged(AColumn);
  UpdateColumnInfos;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
const
  MaxDetailMenuItemCount = 25;
var
  AColumn: TdxListColumn;
  AMenuItem: TMenuItem;
  I: Integer;
  APos: TPoint;
  ADetailItem: PcxDetailItem;
  AColCount: Integer;
begin
  AColumn :=  TdxListViewViewInfoAccess(ViewInfo).FindColumn(MousePos);
  if AColumn <> nil then
  begin
    if FHeaderPopup = nil then
      FHeaderPopup := TPopupMenu.Create(nil)
    else
      FHeaderPopup.Items.Clear;

    AColCount := 0;
    for I := 0 to ItemProducer.Details.Count - 1 do
    begin
      ADetailItem := ItemProducer.Details.Item[I];
      if ADetailItem.Flags and SHCOLSTATE_SECONDARYUI = 0 then
      begin
        AMenuItem := TMenuItem.Create(FHeaderPopup);
        AMenuItem.AutoCheck := True;
        AMenuItem.Tag := I;
        AMenuItem.Enabled := I > 0;
        AMenuItem.Caption := ADetailItem.Text;
        AMenuItem.Checked := ADetailItem.Visible;
        AMenuItem.OnClick := DoDetailItemClick;
        FHeaderPopup.Items.Add(AMenuItem);
        Inc(AColCount);
        if AColCount = MaxDetailMenuItemCount then
          Break;
      end;
    end;
    if AColCount < MaxDetailMenuItemCount then
      for I := 1 to ItemProducer.Details.Count - 1 do
      begin
        ADetailItem := ItemProducer.Details.Item[I];
        if (ADetailItem.Flags and SHCOLSTATE_SECONDARYUI = SHCOLSTATE_SECONDARYUI) and ADetailItem.Visible then
        begin
          AMenuItem := TMenuItem.Create(FHeaderPopup);
          AMenuItem.AutoCheck := True;
          AMenuItem.Tag := I;
          AMenuItem.Enabled := I > 0;
          AMenuItem.Caption := ADetailItem.Text;
          AMenuItem.Checked := ADetailItem.Visible;
          AMenuItem.OnClick := DoDetailItemClick;
          FHeaderPopup.Items.Add(AMenuItem);
          Inc(AColCount);
          if AColCount = MaxDetailMenuItemCount then
            Break;
        end;
      end;

    if ItemProducer.Details.Count > AColCount then
    begin
      AMenuItem := TMenuItem.Create(FHeaderPopup);
      AMenuItem.Caption := '-';
      FHeaderPopup.Items.Add(AMenuItem);
      AMenuItem := TMenuItem.Create(FHeaderPopup);
      AMenuItem.Caption := 'More...';
      AMenuItem.OnClick := DoMoreItemClick;
      FHeaderPopup.Items.Add(AMenuItem);
    end;
    APos := ClientToScreen(MousePos);
    FHeaderPopup.Popup(APos.X, APos.Y);
  end
  else
    inherited DoContextPopup(MousePos, Handled);
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.DoCreateColumns;

  function GetColumnIndexByColumnId(AColumnId: SHCOLUMNID; out AIndex: Integer): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to Columns.Count - 1 do
      if GetDetailItemByColumnIndex(I).IsShColumnIdEqual(AColumnId) then
      begin
        Result := True;
        AIndex := I;
      end;
  end;

var
  I: Integer;
  AIndex, APosition: Integer;
  AShellColumnInfo: TdxShellColumnInfo;
begin
  Columns.BeginUpdate;
  try
    inherited DoCreateColumns;
    APosition := 0;
    for I := 0 to FVisibleColumnInfos.Count - 1 do
    begin
      AShellColumnInfo := FVisibleColumnInfos[I];
      if GetColumnIndexByColumnId(AShellColumnInfo.ColumnId, AIndex) then
      begin
        if AShellColumnInfo.Width > 0 then
        begin
          GetDetailItemByColumnIndex(AIndex).Width := AShellColumnInfo.Width;
          Columns[AIndex].Width := AShellColumnInfo.Width;
        end;
        Columns[AIndex].Index := APosition;
        Inc(APosition);
      end;
    end;
  finally
    Columns.EndUpdate;
  end;
end;

function TdxfrmCommonFileDialog.TdxShellDialogListView.GetContextMenuSite: IUnknown;
begin
  if IsWinSevenOrLater then
    Result := Self
  else
    Result := inherited GetContextMenuSite;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.UpdateColumnInfos;
var
  I: Integer;
  AShellColumnInfo: TdxShellColumnInfo;
begin
  FVisibleColumnInfos.Clear;
  for I := 0 to Columns.Count - 1 do
  begin
    AShellColumnInfo.Width := Columns[I].Width;
    AShellColumnInfo.ColumnId := GetDetailItemByColumnIndex(I).ShColumnID;
    FVisibleColumnInfos.Add(AShellColumnInfo);
  end;
  FIsColumnChanged := True;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.AddListViewVisibleColumn(Sender: TcxShellDetails; var AItemInfo: TcxDetailItem);

  function FindColumnInfo(out AColInfo: TdxShellColumnInfo): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to FVisibleColumnInfos.Count - 1 do
      if AItemInfo.IsShColumnIdEqual(FVisibleColumnInfos[I].ColumnId) then
      begin
        Result := True;
        AColInfo := FVisibleColumnInfos[I];
        Break;
      end;
  end;

var
  AColInfo: TdxShellColumnInfo;
begin
  if FVisibleColumnInfos.Count > 0 then
    AItemInfo.Visible := FindColumnInfo(AColInfo);
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.DoDetailItemClick(Sender: TObject);
var
  ADetailItem: PcxDetailItem;
  AIndex: Integer;
  AColumnInfo: TdxShellColumnInfo;
begin
  AIndex := (Sender as TMenuItem).Tag;
  ADetailItem := ItemProducer.Details.Item[AIndex];
  ADetailItem.Visible := (Sender as TMenuItem).Checked;
  UpdateColumnInfos;
  if ADetailItem.Visible then
  begin
    if ADetailItem.ID < FVisibleColumnInfos.Count then
    begin
      AColumnInfo.Width := ADetailItem.Width;
      AColumnInfo.ColumnId := ADetailItem.ShColumnID;
      FVisibleColumnInfos.Insert(ADetailItem.ID, AColumnInfo); 
    end;
  end
  else
    ADetailItem.Width := Columns[GetColumnIndexByID(ADetailItem.ID)].Width;
  ItemProducer.ClearItemDetails;
  DoCreateColumns;
  UpdateColumnInfos;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.DoMoreItemClick(Sender: TObject);

  procedure AddCustomizeItem(AList: TList<TdxShellColumnCustomizeItem>;
    ADetailItem: PcxDetailItem; AVisibleIndex, ADetailIndex: Integer);
  var
    ACustomizeItem: TdxShellColumnCustomizeItem;
  begin
    ACustomizeItem :=  TdxShellColumnCustomizeItem.Create;
    ACustomizeItem.DetailIndex := ADetailIndex;
    ACustomizeItem.Text := ADetailItem.Text;
    ACustomizeItem.VisibleIndex := AVisibleIndex;
    ACustomizeItem.Width := ADetailItem.Width;
    AList.Add(ACustomizeItem);
  end;

var
  AForm: TfmShellDialogColumnCustomization;
  I: Integer;
  AVisibleIndex: Cardinal;
  ADetailItem: PcxDetailItem;
  AItems: TdxShellColumnCustomizeItems;
  AColumnInfo: TdxShellColumnInfo;
begin
  AForm := TfmShellDialogColumnCustomization.Create(nil);
  AItems := TdxShellColumnCustomizeItems.Create(TdxShellColumnCustomizeItemComparer.Create);
  try
    AForm.InitializeLookAndFeel(LookAndFeel);

    for I := 0 to ItemProducer.Details.Count - 1 do
    begin
      ADetailItem := ItemProducer.Details[I];
      if ADetailItem.Visible then
        AVisibleIndex := GetColumnIndexByID(ADetailItem.ID)
      else
        AVisibleIndex := $FFFFFFFF;
      AddCustomizeItem(AItems, ADetailItem, AVisibleIndex, I);
    end;

    if AForm.Customize(AItems) then
    begin
      FVisibleColumnInfos.Clear;
      AItems.Sort;
      for I := 0 to AItems.Count - 1 do
      begin
        ADetailItem := ItemProducer.Details[AItems[I].DetailIndex];
        ADetailItem.Visible := AItems[I].VisibleIndex <> $FFFFFFFF;
        if ADetailItem.Visible then
        begin
          ADetailItem.Width := AItems[I].Width;
          AColumnInfo.ColumnId := ADetailItem.ShColumnID;
          AColumnInfo.Width := AItems[I].Width;
          FVisibleColumnInfos.Add(AColumnInfo);
        end;
      end;
      IsColumnChanged := True;
      ItemProducer.ClearItemDetails;
      DoCreateColumns;
    end;
  finally
    AItems.Free;
    AForm.Free;
  end;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.ViewStyleChanged;
var
  P: TPoint;
begin
  case ViewStyle of
    TdxListViewStyle.Icon:
      P := ScaleFactor.Apply(TPoint.Create(2, 6));
    TdxListViewStyle.Report:
      P := ScaleFactor.Apply(TPoint.Create(5, 2));
  else
    P := ScaleFactor.Apply(TPoint.Create(5, 1));
  end;
  PaddingOptions.Item.Margin := TRect.Create(P, P);
  if (ViewStyle = TdxListViewStyle.Report) and LookAndFeel.NativeStyle then
    Fonts.SubItem.Color := cl3DDkShadow;
end;

procedure TdxfrmCommonFileDialog.TdxShellDialogListView.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  FGotDblClickMessage := True;
  inherited;
end;

{ TdxfrmOpenFileDialog }

procedure TdxfrmOpenFileDialog.ApplyLocalization;
var
  ALibraryHandle: THandle;
begin
  inherited ApplyLocalization;
  ALibraryHandle := LoadLibraryEx('comdlg32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    btnOK.Caption := dxGetLocalizedSystemResourceString(sdxOpenFileDialogOkCaption, ALibraryHandle, 370);
    Caption := dxGetLocalizedSystemResourceString(sdxOpenFileDialogDefaultTitle, ALibraryHandle, 384);
  finally
    FreeLibrary(ALibraryHandle);
  end;
end;

procedure TdxfrmOpenFileDialog.AddToRecentDocs(const APidl: PItemIDList; const AName: string);
begin
  AddItemToRecentDocs(APidl, AName, 0, 0, 1, 2, 0, 1);
end;

function TdxfrmOpenFileDialog.IsOptionsCheckPassed(const AFileName: string): Boolean;
var
  ALibraryHandle: THandle;
  AMsg: string;
begin
  Result := inherited IsOptionsCheckPassed(AFileName);

  if Result and ForceFileSystem and not IsFileSystemItem(AFileName) then
  begin
    Result := False;
    ALibraryHandle := LoadLibraryEx('comdlg32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
    try
      AMsg := dxGetSystemResourceString(ALibraryHandle, 437, 'You can’t open this location using this program.'#10' Please try a different location.');
      dxMessageDlg(AMsg, mtWarning, [mbOK], 0);
    finally
      FreeLibrary(ALibraryHandle);
    end;
  end;

  if Result and (ofCreatePrompt in Options) and not FileExists(AFileName) then
  begin
    ALibraryHandle := LoadLibraryEx('comdlg32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
    try
      AMsg := dxGetSystemResourceString(ALibraryHandle, 402);
      AMsg := StringReplace(AMsg, '%1', '%s', []); 
      Result := dxMessageDlg(Format(AMsg, [ExtractFileName(AFileName)]), mtWarning, [mbYes, mbNo], 0, mbYes) = mrYes;
      if Result then
        Exit;
    finally
      FreeLibrary(ALibraryHandle);
    end;
  end;

  if Result then
  begin
    Result := not IsFileExistsCheckNeeded or FileExists(AFileName);
    if not Result then
    begin
      dxMessageDlg(ExtractFileName(AFileName) + cxGetResourceString(@sdxFileDialogFileNotExistWarning), mtWarning, [mbOK], 0);
      Exit;
    end;
  end;
end;

procedure TdxfrmOpenFileDialog.SetOptions(const AValue: TOpenOptions);
begin
  inherited SetOptions(AValue);
  ShellListView.MultiSelect := ofAllowMultiSelect in Options;
end;

{ TdxfrmSaveFileDialog }

procedure TdxfrmSaveFileDialog.ApplyLocalization;
var
  ALibraryHandle: THandle;
begin
  inherited ApplyLocalization;
  ALibraryHandle := LoadLibraryEx('comdlg32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    btnOK.Caption := dxGetLocalizedSystemResourceString(sdxSaveFileDialogOkCaption, ALibraryHandle, 369);
    Caption := RemoveAccelChars(dxGetLocalizedSystemResourceString(sdxSaveFileDialogDefaultTitle, ALibraryHandle, 369));
  finally
    FreeLibrary(ALibraryHandle);
  end;
end;

procedure TdxfrmSaveFileDialog.AddToRecentDocs(const APidl: PItemIDList; const AName: string);
begin
  AddItemToRecentDocs(APidl, AName, 0, 0, 0, 3, 0, 1);
end;

function TdxfrmSaveFileDialog.IsOptionsCheckPassed(const AFileName: string): Boolean;
var
  ALibraryHandle: THandle;
  AMsg: string;
begin
  Result := inherited IsOptionsCheckPassed(AFileName);
  if Result and ForceFileSystem and not IsFileSystemItem(AFileName) then
  begin
    Result := False;
    ALibraryHandle := LoadLibraryEx('comdlg32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
    try
      AMsg := dxGetSystemResourceString(ALibraryHandle, 449, 'You can’t save to ''%s''. Please choose another location.');
      dxMessageDlg(Format(AMsg, [ExtractFileDir(AFileName)]), mtWarning, [mbOK], 0);
    finally
      FreeLibrary(ALibraryHandle);
    end;
  end;
  if Result and (ofOverwritePrompt in Options) and FileExists(AFileName) then
  begin
    ALibraryHandle := LoadLibraryEx('comdlg32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
    try
      AMsg := dxGetSystemResourceString(ALibraryHandle, 257);
      AMsg := StringReplace(AMsg, '%1', '%s', []); 
      Result := dxMessageDlg(Format(AMsg, [ExtractFileName(AFileName)]), mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes;
    finally
      FreeLibrary(ALibraryHandle);
    end;
  end;
end;

{ TdxFileDialogsSettings }

constructor TdxFileDialogsSettings.Create;
begin
  FSettings := TObjectDictionary<TClass, TdxFileDialogInfo>.Create([doOwnsValues]);
end;

destructor TdxFileDialogsSettings.Destroy;
begin
  FSettings.Free;
end;

procedure TdxFileDialogsSettings.DoLoad;
var
  ARegistry: TRegistry;
  AKeys: TStringList;
  AKey: string;
  AClass: TClass;
  AInfo: TdxFileDialogInfo;
begin
  ARegistry := TRegistry.Create(KEY_READ);
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKeyReadOnly(SettingsRootKeyName) then
      FInitialDir := ARegistry.ReadString(LastDirPropertyName)
    else
      Exit;
    AKeys := TStringList.Create;
    try
      ARegistry.GetKeyNames(AKeys);
      ARegistry.CloseKey;
      for AKey in AKeys do
      begin
        AClass := GetClass('Tdxfrm' + StringReplace(AKey, 'Form', '', [rfReplaceAll, rfIgnoreCase]));
        if (AClass = nil) or not AClass.InheritsFrom(TdxfrmCommonFileCustomDialog) then
          Continue;
        if (AClass <> nil) and ARegistry.OpenKeyReadOnly(SettingsRootKeyName + AKey) then
        try
          AInfo := GetInfo(TdxfrmCommonFileCustomDialogClass(AClass));
          AInfo.SplitterPosition := StrToIntDef(ARegistry.ReadString(SplitterPositionPropertyName), AInfo.SplitterPosition);
          AInfo.Position.X := StrToIntDef(ARegistry.ReadString(LeftPropertyName  ), AInfo.Position.X);
          AInfo.Position.Y := StrToIntDef(ARegistry.ReadString(TopPropertyName   ), AInfo.Position.Y);
          AInfo.Size.cx    := StrToIntDef(ARegistry.ReadString(WidthPropertyName ), AInfo.Size.cx);
          AInfo.Size.cy    := StrToIntDef(ARegistry.ReadString(HeightPropertyName), AInfo.Size.cy);
        finally
          ARegistry.CloseKey;
        end;
      end;
    finally
      AKeys.Free;
    end;
  finally
    ARegistry.Free;
  end;
  Changed := False;
end;

procedure TdxFileDialogsSettings.DoSave;
var
  ARegistry: TRegistry;
  AKey: string;
  AClass: TClass;
  AInfo: TdxFileDialogInfo;
begin
  if not Changed then
    Exit;
  ARegistry := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if not IsWinSevenOrLater and ARegistry.OpenKey(SettingsRootKeyName, True) then
    begin
      ARegistry.WriteString(LastDirPropertyName, FInitialDir);
      ARegistry.CloseKey;
    end;
    for AClass in FSettings.Keys do
      if FSettings.TryGetValue(AClass, AInfo) and AInfo.Changed then
      begin
        AKey := StringReplace(AClass.ClassName, 'Tdxfrm', '', [rfReplaceAll, rfIgnoreCase]) + 'Form';
        if ARegistry.OpenKey(SettingsRootKeyName + AKey, True) then
        try
          ARegistry.WriteString(SplitterPositionPropertyName, IntToStr(AInfo.SplitterPosition));
          ARegistry.WriteString(LeftPropertyName,   IntToStr(AInfo.Position.X));
          ARegistry.WriteString(TopPropertyName,    IntToStr(AInfo.Position.Y));
          ARegistry.WriteString(WidthPropertyName,  IntToStr(AInfo.Size.cx));
          ARegistry.WriteString(HeightPropertyName, IntToStr(AInfo.Size.cy));
          AInfo.Changed := False;
        finally
          ARegistry.CloseKey;
        end;
      end;
  finally
    Changed := False;
    ARegistry.Free;
  end;
end;

function TdxFileDialogsSettings.GetInfo(AClass: TClass): TdxFileDialogInfo;
begin
  if FSettings.TryGetValue(AClass, Result) then
    Exit;
  Result := TdxFileDialogInfo.Create;
  Result.Position := cxInvisiblePoint;
  Result.Size := Self.DefaultSize;
  Result.SplitterPosition := Self.DefaultSplitterPosition;
  FSettings.Add(AClass, Result);
end;

function TdxFileDialogsSettings.GetSize(AClass: TClass): TSize;
begin
  Result := GetInfo(AClass).Size;
end;

procedure TdxFileDialogsSettings.LoadDialogInfo(ADialog: TdxfrmCommonFileCustomDialog);

  function GetActiveApplicationForm: TCustomForm;
  begin
    if dxIsDesignTime then
      Exit(nil);
    Result := Screen.ActiveCustomForm;
    while (Result <> nil) and (Result.Parent is TCustomForm) and
      Result.HandleAllocated and (Windows.GetParent(Result.Handle) <> 0) do
        Result := TCustomForm(Result.Parent);
    if (Result <> nil) and not Result.HandleAllocated then
      Result := nil;
  end;

  function GetActiveApplicationFormHandle: HWND;
  var
    AForm: TCustomForm;
  begin
    Result := 0;
    if dxIsDesignTime then
      Result := Application.ActiveFormHandle
    else
    begin
      AForm := GetActiveApplicationForm;
      if (AForm <> nil) then
        Result := AForm.Handle;
    end;
  end;

  function GetDefaultMonitor: TMonitor;
  var
    AHandle: HWND;
  begin
    Result := nil;
    AHandle := GetActiveApplicationFormHandle;
    if AHandle <> 0 then
      Result := Screen.MonitorFromWindow(AHandle);
    if Result = nil then
      Result := Screen.PrimaryMonitor;
  end;

  function GetActualMonitor(AInfo: TdxFileDialogInfo): TMonitor;
  begin
    if AInfo.Position = cxInvisiblePoint then
      Result := GetDefaultMonitor
    else
    begin
      Result := Screen.MonitorFromPoint(TRect.CreateSize(AInfo.Position, AInfo.Size).CenterPoint);
      if Result = nil then
        Result := GetDefaultMonitor;
    end;
  end;

  function GetDialogRect(const AMonitorWorkArea: TRect; AInfo: TdxFileDialogInfo): TRect;

    procedure AdjustRectangle(const AOutterRect: TRect; var AInnerRect: TRect);
    begin
      AInnerRect.Width := Min(AInnerRect.Width,  AOutterRect.Width);
      AInnerRect.Height := Min(AInnerRect.Height, AOutterRect.Height);
      AInnerRect.SetLocation(
        Min(Max(AInnerRect.Left, AOutterRect.Left), AOutterRect.Right - AInnerRect.Width),
        Min(Max(AInnerRect.Top, AOutterRect.Top), AOutterRect.Bottom - AInnerRect.Height));
    end;

    function GetPosition(const ADialogSize: TSize): TPoint;
    begin
      if AInfo.Position = cxInvisiblePoint then
      begin
        // #kp: in the center of the monitor
        Result.X := AMonitorWorkArea.Left + AMonitorWorkArea.Width div 2 - ADialogSize.cx div 2;
        Result.Y := AMonitorWorkArea.Top + AMonitorWorkArea.Height div 2 - ADialogSize.cy div 2;
      end
      else
        Result := AInfo.Position;
    end;

  var
    ASize: TSize;
    APosition: TPoint;
  begin
    ASize := ADialog.ScaleFactor.Apply(AInfo.Size);
    APosition := GetPosition(ASize);
    Result := TRect.CreateSize(APosition, ASize);
    AdjustRectangle(AMonitorWorkArea, Result);
  end;

  procedure UpdateDialogBounds(const AMonitorWorkArea: TRect; AInfo: TdxFileDialogInfo);
  var
    ARect: TRect;
  begin
    ARect := GetDialogRect(AMonitorWorkArea, AInfo);
    ADialog.DisableAlign;
    try
      ADialog.SetBounds(ARect.Left, ARect.Top, ADialog.Width, ADialog.Height);
      ADialog.ClientHeight := ARect.Height;
      ADialog.ClientWidth := ARect.Width;
    finally
      ADialog.EnableAlign;
    end;
  end;

var
  AInfo: TdxFileDialogInfo;
  AMonitor: TMonitor;
begin
  try
    DoLoad;
  except
    on ERegistryException do;
  end;
  AInfo := GetInfo(ADialog.ClassType);
  AMonitor := GetActualMonitor(AInfo);
  ADialog.Position := poDesigned;
  ADialog.ScaleForPPI(dxGetMonitorDPI(AMonitor));
  UpdateDialogBounds(AMonitor.WorkareaRect, AInfo);

  if ADialog is TdxfrmCommonFileDialog then
    TdxfrmCommonFileDialog(ADialog).liShellTreeView.Width := ADialog.ScaleFactor.Apply(AInfo.SplitterPosition);
  if not IsWinSevenOrLater and (ADialog.FInitializeDir = '') and (ADialog.GetFileName = '') then
    ADialog.InitializeFolder(InitialDir);
end;

procedure TdxFileDialogsSettings.SaveDialogInfo(ADialog: TdxfrmCommonFileCustomDialog);
var
  AInfo: TdxFileDialogInfo;
begin
  AInfo := GetInfo(ADialog.ClassType);
  AInfo.Position := Point(ADialog.Left, ADialog.Top);
  AInfo.Size := ADialog.ScaleFactor.Revert(cxSize(ADialog.ClientWidth, ADialog.ClientHeight));
  if ADialog is TdxfrmCommonFileDialog then
    AInfo.SplitterPosition := ADialog.ScaleFactor.Revert(TdxfrmCommonFileDialog(ADialog).liShellTreeView.Width);
  AInfo.Changed := True;
  Changed := True;
  try
    DoSave;
  except
    on ERegistryException do;
  end;
end;

function TdxFileDialogsSettings.GetSplitterPosition(AClass: TClass): Integer;
begin
  Result := GetInfo(AClass).SplitterPosition;
end;

procedure TdxFileDialogsSettings.SetSize(AClass: TClass; const AValue: TSize);
var
  AInfo: TdxFileDialogInfo;
begin
  AInfo := GetInfo(AClass);
  if cxSizeIsEqual(AValue, AInfo.Size) then
    Exit;
  AInfo.Size := AValue;
  AInfo.Changed := True;
  Changed := True;
end;

procedure TdxFileDialogsSettings.SetInitialDir(const AValue: string);
begin
  if AValue <> FInitialDir then
  begin
    FInitialDir := AValue;
    Changed := True;
  end;
end;

procedure TdxFileDialogsSettings.SetSplitterPosition(AClass: TClass; AValue: Integer);
var
  AInfo: TdxFileDialogInfo;
begin
  AInfo := GetInfo(AClass);
  if AValue = AInfo.SplitterPosition then
    Exit;
  AInfo.SplitterPosition := AValue;
  AInfo.Changed := True;
  Changed := True;
end;

{ TdxMRUSearch }

constructor TdxMRUSearch.Create;
begin
  inherited Create;
  FMRUList := TdxMRULongList.Create($64, 1, SExplorerRegPath + 'WordWheelQuery');
end;

destructor TdxMRUSearch.Destroy;
begin
  FreeAndNil(FMRUList);
  inherited;
end;

procedure TdxMRUSearch.AddItem(const AItem: string);
begin
  if FMRUList.IsInitialized then
    FMRUList.AddData(PChar(AItem), Length(AItem) * SizeOf(Char) + SizeOf(Char));
end;

procedure TdxMRUSearch.DeleteItem(const AItem: string);
begin
  FMRUList.ClearData(AItem, Length(AItem) * SizeOf(Char) + SizeOf(Char));
end;

procedure TdxMRUSearch.GetList(AList: TStrings);
var
  ABytesCount: Cardinal;
  I: Integer;
  AData: PChar;
begin
  if FMRUList.IsInitialized and FMRUList.QueryInfo(0, ABytesCount) then
  begin
    for I := 0 to 100 do
      if FMRUList.QueryInfo(I, ABytesCount) then
      begin
        AData := cxAllocMem(ABytesCount);
        if FMRUList.GetData(I, AData, ABytesCount) and (AData <> '') then
          AList.Add(AData);
        cxFreeMem(AData);
      end
      else
        Break;
  end;
end;

{ TdxSearchControlPopup }

constructor TdxfrmCommonFileDialog.TdxSearchControlPopup.Create(AOwnerControl: TWinControl);
begin
  inherited Create(AOwnerControl);
  InnerListBox.ItemHeight := ScaleFactor.Apply(27);
  TdxSearchControlInnerListBox(InnerListBox).ScrollBars := ssNone;
  TdxSearchControlInnerListBox(InnerListBox).OnItemButtonClick := DoItemButtonClick;
end;

function TdxfrmCommonFileDialog.TdxSearchControlPopup.CreateInnerListBox: TdxCustomAutoCompleteInnerListBox;
begin
  Result := TdxSearchControlInnerListBox.Create(nil);
end;

procedure TdxfrmCommonFileDialog.TdxSearchControlPopup.DoItemButtonClick(ASender: TObject);
begin
  if Assigned(FOnItemButtonClick) then
    FOnItemButtonClick(Self);
end;

function TdxfrmCommonFileDialog.TdxSearchControlPopup.GetItemButtonImageIndex: Integer;
begin
  Result := TdxSearchControlInnerListBox(InnerListBox).ItemButtonImageIndex;
end;

function TdxfrmCommonFileDialog.TdxSearchControlPopup.NeedIgnoreMouseMessageAfterCloseUp(AWnd: THandle; AMsg: Cardinal; AShift: TShiftState; const APos: TPoint): Boolean;
begin
  Result := True;
end;

procedure TdxfrmCommonFileDialog.TdxSearchControlPopup.SetItemButtonImageIndex(
  const Value: Integer);
begin
  TdxSearchControlInnerListBox(InnerListBox).ItemButtonImageIndex := Value;
end;

function TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.CalculateItemHeight: Integer;
begin
  Result := ItemHeight;
end;

function TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.CanUpdateHotState: Boolean;
begin
  Result := HandleAllocated and (DragAndDropState = ddsNone);
end;

procedure TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FIsItemButtonPressed then
    DoItemButtonClick
  else
    inherited;
end;

procedure TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.DrawItemText(const R: TRect; AItem: TdxCustomListBoxItem; AState: TcxButtonState);
var
  ATextRect: TRect;
  AImageRect: TRect;
  AColor: TdxAlphaColor;
begin
  if (AState = cxbsHot) or (AState = cxbsPressed) and (HotIndex = ItemIndex) then
  begin
    ATextRect := R;
    if UseRightToLeftAlignment then
      Inc(ATextRect.Left, ItemHeight)
    else
      Dec(ATextRect.Right, ItemHeight);
    inherited DrawItemText(ATextRect, AItem, AState);
    AImageRect := GetItemButtonRect(R);
    AImageRect := cxRectCenter(AImageRect, ImageSize);
    AColor := dxColorToAlphaColor(GetTextColor(AItem, AState));
    TdxImageDrawer.DrawUncachedImage(Canvas.Handle, AImageRect, AImageRect, nil, Images, ItemButtonImageIndex, idmNormal, False, 0, clNone, True,
      TdxSimpleColorPalette.Create(AColor, AColor));
  end
  else
    inherited DrawItemText(R, AItem, AState);
end;

function TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.GetItemBackgroundRect(AItem: TdxCustomListBoxItem; const AItemRect: TRect): TRect;
begin
  Result := AItemRect;
end;

function TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.GetItemTextRect(AItem: TdxCustomListBoxItem; const AItemRect: TRect): TRect;
begin
  Result := inherited GetItemTextRect(AItem, AItemRect);
  Inc(Result.Left, ImagesAreaSize);
end;

function TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.IsSizeGripVisible: Boolean;
begin
  Result := False;
end;

function TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.ProcessNavigationKey(var Key: Word; Shift: TShiftState): Boolean;
begin
  case Key of
    VK_RETURN:
      Result := (ItemIndex <> -1) and inherited ProcessNavigationKey(Key, Shift)
    else
      Result := inherited ProcessNavigationKey(Key, Shift);
  end;
end;

procedure TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.DoItemButtonClick;
begin
  if Assigned(FOnItemButtonClick) then
    FOnItemButtonClick(Self);
end;

procedure TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.DoMouseMove(Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.DrawItemImage(const R: TRect; AItem: TdxCustomListBoxItem; AState: TcxButtonState);
var
  AImageRect: TRect;
  AColor: TdxAlphaColor;
begin
  if IsImageAssigned(Images, AItem.ImageIndex) then
  begin
    AImageRect := cxRectCenter(R, ImageSize);
    AColor := dxColorToAlphaColor(GetTextColor(AItem, AState));
    TdxImageDrawer.DrawUncachedImage(Canvas.Handle, AImageRect, AImageRect, nil, Images, AItem.ImageIndex, idmNormal, False, 0, clNone, True,
      TdxSimpleColorPalette.Create(AColor, AColor));
  end;
end;

function TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.GetItemButtonRect(const AItemRect: TRect): TRect;
begin
  Result := AItemRect;
  if UseRightToLeftAlignment then
    Result.Right := Result.Left + ImagesAreaSize
  else
    Result.Left := Result.Right - ImagesAreaSize;
end;

procedure TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.InternalMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  AItemButtonRect: TRect;
begin
  inherited InternalMouseDown(Button, Shift, X, Y);
  FIsItemButtonPressed := False;
  if ItemIndex <> - 1 then
  begin
    AItemButtonRect := GetItemButtonRect(ItemRect(ItemIndex));
    if PtInRect(AItemButtonRect, Point(X, Y)) then
      FIsItemButtonPressed := True;
  end;
end;

function TdxfrmCommonFileDialog.TdxSearchControlInnerListBox.NeedHotTrack: Boolean;
begin
  Result := True;
end;

{ TdxfrmCommonFileDialog.TdxHistoryItem }

constructor TdxfrmCommonFileDialog.TdxHistoryItem.Create(APidl: PItemIDList);
begin
  inherited Create;
  FPidl := GetPidlCopy(APidl);
  FSelectedPidl := nil;
end;

destructor TdxfrmCommonFileDialog.TdxHistoryItem.Destroy;
begin
  DisposePidl(FSelectedPidl);
  DisposePidl(FPidl);
  inherited Destroy;
end;

procedure TdxfrmCommonFileDialog.TdxHistoryItem.SetSelectedPidl(AValue: PItemIDList);
begin
  dxFreeAndNilPidl(FSelectedPidl);
  FSelectedPidl := GetPidlCopy(AValue);
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxFileDialogsSettings := TdxFileDialogsSettings.Create;
  RegisterClasses([TdxfrmOpenFileDialog, TdxfrmSaveFileDialog]);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(dxFileDialogsSettings);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
