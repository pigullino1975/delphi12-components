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

unit dxShellBreadcrumbEdit;

{$I cxVer.inc}

interface

uses
  Types, ActiveX, ShlObj, Windows, SysUtils, Classes, Messages, Graphics, ImgList, Controls,
  dxCustomTree, cxControls, dxBreadcrumbEdit, cxShellCommon, cxShellControls, StrUtils,
  cxShellListView, cxShellComboBox, cxShellTreeView, dxCoreClasses, dxShellControls, ClipBrd;

type
  TdxShellBreadcrumbEditNode = class;
  TdxShellBreadcrumbEditRoot = class(TcxCustomShellRoot)
  protected
    function GetParentWindow: HWND; override;
  end;

  IdxShellBreadcrumbEditEvents = interface(IdxBreadcrumbEditEvents)
  ['{73A3108B-0FC0-41D7-A885-B8F7C2431779}']
    procedure AddFolder(AFolder: TcxShellFolder; var ACanAdd: Boolean);
    procedure ShellChanged(AEventID: DWORD; APIDL1, APIDL2: PItemIDList);
  end;

  TdxShellBreadcrumbEditShellOptionsChange = (bcescContent, bcescRoot, bcescTracking);
  TdxShellBreadcrumbEditShellOptionsChanges = set of TdxShellBreadcrumbEditShellOptionsChange;
  TdxShellBreadcrumbEditShellOptionsChangeEvent = procedure (Sender: TObject;
    const AChanges: TdxShellBreadcrumbEditShellOptionsChanges) of object;

  { TdxShellBreadcrumbEditShellOptions }

  TdxShellBreadcrumbEditShellOptions = class(TcxOwnedPersistent)
  strict private
    FRoot: TdxShellBreadcrumbEditRoot;
    FShowHiddenFolders: Boolean;
    FTrackShellChanges: Boolean;
    FShowZipFilesWithFolders: Boolean;

    FOnChange: TdxShellBreadcrumbEditShellOptionsChangeEvent;

    procedure DoFolderChanged(Sender: TObject; Root: TcxCustomShellRoot);
    procedure DoSettingsChanged(Sender: TObject);
    procedure SetRoot(AValue: TdxShellBreadcrumbEditRoot);
    procedure SetShowHiddenFolders(AValue: Boolean);
    procedure SetShowZipFilesWithFolders(AValue: Boolean);
    procedure SetTrackShellChanges(AValue: Boolean);
  protected
    procedure Changed(AChanges: TdxShellBreadcrumbEditShellOptionsChanges); virtual;
    //
    property OnChange: TdxShellBreadcrumbEditShellOptionsChangeEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Root: TdxShellBreadcrumbEditRoot read FRoot write SetRoot;
    property ShowHiddenFolders: Boolean read FShowHiddenFolders write SetShowHiddenFolders default False;
    property ShowZipFilesWithFolders: Boolean read FShowZipFilesWithFolders write SetShowZipFilesWithFolders default True;
    property TrackShellChanges: Boolean read FTrackShellChanges write SetTrackShellChanges default True;
  end;

  TdxShellBreadcrumbEditPathEditorProperties = class(TdxBreadcrumbEditPathEditorProperties)
  strict private
    FUseSystemRecentPaths: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property UseSystemRecentPaths: Boolean read FUseSystemRecentPaths write FUseSystemRecentPaths default False;
  end;

  { TdxShellBreadcrumbEditProperties }

  TdxShellBreadcrumbEditProperties = class(TdxCustomBreadcrumbEditProperties)
  strict private
    FAllowDragDrop: Boolean;
    FShellImageList: TdxShellSmallImageList;
    FShellOptions: TdxShellBreadcrumbEditShellOptions;
    FOnShellOptionsChanged: TdxShellBreadcrumbEditShellOptionsChangeEvent;

    function CreateShellImageList: TdxShellSmallImageList;
    function GetPathEditor: TdxShellBreadcrumbEditPathEditorProperties;
    procedure ShellOptionsChanged(Sender: TObject; const AChanges: TdxShellBreadcrumbEditShellOptionsChanges);
    procedure SetPathEditor(AValue: TdxShellBreadcrumbEditPathEditorProperties);
    procedure SetShellOptions(AValue: TdxShellBreadcrumbEditShellOptions);
  protected
    procedure ChangeScale(M, D: Integer); override;
    function CreatePathEditorProperties: TdxBreadcrumbEditPathEditorProperties; override;
    procedure ItemImageUpdated(ANode: TdxShellBreadcrumbEditNode);
    property OnShellOptionsChanged: TdxShellBreadcrumbEditShellOptionsChangeEvent read FOnShellOptionsChanged write FOnShellOptionsChanged;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property AllowDragDrop: Boolean read FAllowDragDrop write FAllowDragDrop default False;
    property Borders;
    property Buttons;
    property ButtonImages;
    property DropDownIndent;
    property DropDownRows;
    property PathEditor: TdxShellBreadcrumbEditPathEditorProperties read GetPathEditor write SetPathEditor;
    property ProgressBar;
    property ShellOptions: TdxShellBreadcrumbEditShellOptions read FShellOptions write SetShellOptions;
  end;

  { TdxShellBreadcrumbEditProducer }

  TdxShellBreadcrumbEditProducer = class(TcxCustomItemProducer)
  strict private
    FNode: TdxShellBreadcrumbEditNode;
    FShellItemInfo: TcxShellItemInfo;

    function GetIsInitialized: Boolean;
  protected
    function CanAddFolder(AFolder: TcxShellFolder): Boolean; override;
    function GetEnumFlags: Cardinal; override;
    function GetShowToolTip: Boolean; override;
    function SlowInitializationDone(AItem: TcxShellItemInfo): Boolean; override;
    procedure DoSlowInitialization(AItem: TcxShellItemInfo); override;
  public
    constructor Create(ANode: TdxShellBreadcrumbEditNode); reintroduce; virtual;
    procedure CheckInitialized;
    function GetItemIndexByPidl(APidl: PItemIDList): Integer;
    function GetNodeByPidl(APidl: PItemIDList): TdxShellBreadcrumbEditNode; virtual;
    procedure ProcessItems; reintroduce; overload;
    procedure SetItemsCount(Count: Integer); override;
    //
    property IsInitialized: Boolean read GetIsInitialized;
    property Node: TdxShellBreadcrumbEditNode read FNode;
    property ShellItemInfo: TcxShellItemInfo read FShellItemInfo write FShellItemInfo;
  end;

  { TdxShellBreadcrumbEditNode }

  TdxShellBreadcrumbEditNode = class(TdxBreadcrumbEditNode)
  strict private
    FAbsolutePidl: PItemIDList;
    FProducer: TdxShellBreadcrumbEditProducer;
    FShellFolder: IShellFolder;

    procedure FreeShellObjects;
    function GetAbsolutePidl: PItemIDList;
    function GetEdit: IdxBreadcrumbEdit;
    function GetFolderName: string;
    function GetItem(AIndex: Integer): TdxShellBreadcrumbEditNode;
    function GetOptions: TdxShellBreadcrumbEditShellOptions;
    function GetParent: TdxShellBreadcrumbEditNode;
    function GetPidl: PItemIDList;
    function GetProperties: TdxShellBreadcrumbEditProperties;
    function GetShellFolder: IShellFolder;
    procedure SetPidl(const Value: PItemIDList);
  protected
    function AreChildrenLoaded: Boolean; override;
    function GetPath: string; override;
    function GetRealPath: string; virtual;
    procedure Initialize(AItemInfo: TcxShellItemInfo); virtual;
    //
    property AbsolutePidl: PItemIDList read GetAbsolutePidl;
    property Edit: IdxBreadcrumbEdit read GetEdit;
    property Options: TdxShellBreadcrumbEditShellOptions read GetOptions;
    property Pidl: PItemIDList read GetPidl write SetPidl;
    property Producer: TdxShellBreadcrumbEditProducer read FProducer;
    property Properties: TdxShellBreadcrumbEditProperties read GetProperties;
    property ShellFolder: IShellFolder read GetShellFolder;
  public
    constructor Create(AOwner: IdxTreeOwner); override;
    destructor Destroy; override;
    function AddChild: TdxShellBreadcrumbEditNode; overload;
    function Compare(const AName: string): Boolean; override;
    //
    property FolderName: string read GetFolderName;
    property Items[AIndex: Integer]: TdxShellBreadcrumbEditNode read GetItem; default;
    property Parent: TdxShellBreadcrumbEditNode read GetParent;
    property RealPath: string read GetRealPath;
  end;

  { TdxShellBreadcrumbEditController }

  TdxShellBreadcrumbEditController = class(TdxBreadcrumbEditController)
  public type
    TState = record
      DropDownMenuOwnerPidl: PItemIDList;
      DropDownMenuState: Boolean;
      SelectedPidl: PItemIDList;
    end;
  strict private
    FShellChangeNotifierData: TcxShellChangeNotifierData;
    FUpdateContentLockCount: Integer;

    function GetPathDelimiter: Char;
    function GetRoot: TdxShellBreadcrumbEditNode;
    function GetSelected: TdxShellBreadcrumbEditNode;
    function GetSelectedPidl: PItemIDList;
    function GetSelectedRealPath: string;
    function GetShellOptions: TdxShellBreadcrumbEditShellOptions;
    procedure SetSelected(AValue: TdxShellBreadcrumbEditNode);
    procedure SetSelectedPidl(AValue: PItemIDList);
    procedure ShellChangeNotify(AEventID: Longint; APidl1, APidl2: PItemIDList);
  protected
    function CreatePathEditingController: TdxBreadcrumbEditPathEditingController; override;
    procedure DoAfterSelect; override;
    procedure DoShellChangeNotify(AEventID: LongInt; APidl1, APidl2: PItemIDList); virtual;
    function FindRootNodeForPath(var APath: string; out ANode: TdxBreadcrumbEditNode): Boolean; override;
    function GetPidlByPath(APath: string; out APidl: PItemIDList): Boolean; virtual;
    procedure RemoveChangeNotification;
    procedure RestoreSelection(APidl: PItemIDList);
    function ShouldUpdateSelectedNode(ANode: TdxBreadcrumbEditNode): Boolean; override;
    procedure WndProc(var Message: TMessage); override;
  public
    function FindNodeByPath(APath: string): TdxBreadcrumbEditNode; override;
    function FindNodeByPidl(APidl: PItemIDList; AIgnoreFile: Boolean = False): TdxShellBreadcrumbEditNode;
    procedure CancelSelectionChanges;
    procedure BeginUpdateContent(var AState: TState);
    procedure EndUpdateContent(var AState: TState);
    function IsUpdatingContent: Boolean;
    procedure SelectPathViaDropDownMenu(AItem: TdxBreadcrumbEditNode); override;
    procedure UpdateContent;
    procedure UpdateTrackingSettings;
    //
    property PathDelimiter: Char read GetPathDelimiter;
    property Root: TdxShellBreadcrumbEditNode read GetRoot;
    property Selected: TdxShellBreadcrumbEditNode read GetSelected write SetSelected;
    property SelectedPidl: PItemIDList read GetSelectedPidl write SetSelectedPidl;
    property SelectedRealPath: string read GetSelectedRealPath;
    property ShellOptions: TdxShellBreadcrumbEditShellOptions read GetShellOptions;
  end;

  { TdxShellBreadcrumbEditPathEditor }

  TdxShellBreadcrumbEditPathEditor = class(TdxBreadcrumbEditPathEditor)
  public
    procedure PasteFromClipboard; override;
  end;

  { TdxShellBreadcrumbPathEditingController }

  TdxShellBreadcrumbPathEditingController = class(TdxBreadcrumbEditPathEditingController)
  strict private
    function GetController: TdxShellBreadcrumbEditController; inline;
  protected
    function CreatePathEditor: TdxBreadcrumbEditPathEditor; override;
    procedure PopulateSuggestions(const APath: string; ASuggestions: TStringList); override;
  public
    procedure ReleasePathEditor; override;
    //
    property Controller: TdxShellBreadcrumbEditController read GetController;
  end;

  { TdxCustomShellBreadcrumbEdit }

  TdxCustomShellBreadcrumbEdit = class(TdxCustomBreadcrumbEdit,
    IcxShellDependedControls,
    IdxShellBreadcrumbEditEvents,
    IcxShellRoot,
    IDropTarget)
  strict private
    FDependedControls: TcxShellDependedControls;
    FIsSystemRecentPathsLoaded: Boolean;
    FLoadedGroupIndex: Integer;
    FNavigationLockCount: Integer;
    FShellComboBox: TWinControl;
    FShellListView: TWinControl;
    FShellTreeView: TWinControl;
    FCurrentDropTarget: IDropTarget;
    FDraggedObject: IDataObject;
    FDragSource: TdxShellBreadcrumbEditNode;
    FDropTarget: TdxShellBreadcrumbEditNode;
    FDropTargetHelper: IDropTargetHelper;
    FGroupIndex: Integer;
    FShellDragDropState: TcxDragAndDropState;
    FWasMouseRButtonPressed: Boolean;
    //

    FOnAddFolder: TcxShellAddFolderEvent;
    FOnRootChanged: TcxRootChangedEvent;
    FOnShellChange: TcxShellChangeEvent;

    procedure DoBeginDrag;
    procedure DoHandleDependedInitialization;
    function GetController: TdxShellBreadcrumbEditController;
    function GetProperties: TdxShellBreadcrumbEditProperties;
    function GetRoot: TdxShellBreadcrumbEditNode;
    function GetSelectedPidl: PItemIDList;
    function IsParentLoading: Boolean;
    procedure PopulateSystemRecentPaths;
    procedure ShellOptionsChangeHandler(Sender: TObject; const AChanges: TdxShellBreadcrumbEditShellOptionsChanges);
    procedure SetDropTarget(AValue: TdxShellBreadcrumbEditNode);
    procedure SetGroupIndex(AValue: Integer);
    procedure SetProperties(AValue: TdxShellBreadcrumbEditProperties);
    procedure SetSelectedPidl(AValue: PItemIDList);
    procedure SetShellComboBox(AValue: TWinControl);
    procedure SetShellListView(AValue: TWinControl);
    procedure SetShellTreeView(AValue: TWinControl);
    function TryReleaseDropTarget: HResult;
    procedure UpdateDropTarget(const APoint: TPoint; out ANew: Boolean);
    //
    procedure DSMNavigate(var Message: TMessage); message DSM_DONAVIGATE;
    procedure DSMNotifyUpdateContents(var Message: TMessage); message DSM_NOTIFYUPDATECONTENTS;
    procedure DSMSynchronizeRoot(var Message: TMessage); message DSM_SYNCHRONIZEROOT;
  protected
    function CreateController: TdxBreadcrumbEditController; override;
    function CreateProperties: TdxCustomBreadcrumbEditProperties; override;
    function CreateRoot: TdxBreadcrumbEditNode; override;
    procedure DestroyWnd; override;
    procedure InitControl; override;
    procedure LoadChildren(ASender: TdxTreeCustomNode); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure PopulateRecentPaths; override;
    procedure RootChanged; virtual;
    procedure SelectionChanged; override;
    procedure ShellOptionsChanged(const AChanges: TdxShellBreadcrumbEditShellOptionsChanges); virtual;
    procedure SynchronizeDependedControls; virtual;
    procedure SynchronizeRoot; virtual;
    // IDropTarget
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function IDropTarget.DragOver = IDropTargetDragOver;
    function IDropTargetDragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    //
    function GetSelectedPath: string; override;
    // IdxShellBreadcrumbEditEvents
    procedure AddFolder(AFolder: TcxShellFolder; var ACanAdd: Boolean);
    procedure ShellChanged(AEventID: DWORD; APIDL1, APIDL2: PItemIDList);
    // IcxShellDependedControls
    function GetDependedControls: TcxShellDependedControls;
    // IcxShellRoot
    function IcxShellRoot.GetRoot = GetShellRoot;
    function GetShellRoot: TcxCustomShellRoot;
    property Controller: TdxShellBreadcrumbEditController read GetController;
    property DependedControls: TcxShellDependedControls read FDependedControls;
    property DropTarget: TdxShellBreadcrumbEditNode read FDropTarget write SetDropTarget;
    property Root: TdxShellBreadcrumbEditNode read GetRoot;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateContent;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
    //
    property Properties: TdxShellBreadcrumbEditProperties read GetProperties write SetProperties;
    property SelectedPidl: PItemIDList read GetSelectedPidl write SetSelectedPidl;
    property ShellComboBox: TWinControl read FShellComboBox write SetShellComboBox;
    property ShellListView: TWinControl read FShellListView write SetShellListView;
    property ShellTreeView: TWinControl read FShellTreeView write SetShellTreeView;
    //
    property OnAddFolder: TcxShellAddFolderEvent read FOnAddFolder write FOnAddFolder;
    property OnRootChanged: TcxRootChangedEvent read FOnRootChanged write FOnRootChanged;
    property OnShellChange: TcxShellChangeEvent read FOnShellChange write FOnShellChange;
  end;

  { TdxShellBreadcrumbEdit }

  TdxShellBreadcrumbEdit = class(TdxCustomShellBreadcrumbEdit)
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color;
    property Enabled;
    property Font;
    property GroupIndex default -1;
    property LookAndFeel;
    property ParentBiDiMode;
    property ParentShowHint;
    property Properties;
    property ShellComboBox;
    property ShellListView;
    property ShellTreeView;
    property ShowHint;
    property TabOrder;
    property Transparent;
    property Visible;

    property OnAddFolder;
    property OnButtonClick;
    property OnInitPathEdit;
    property OnPathEntered;
    property OnPathSelected;
    property OnPathValidate;
    property OnPopulateAutoCompleteSuggestions;
    property OnRootChanged;
    property OnShellChange;
  end;

implementation

uses
  Registry, Dialogs, Math, RTLConsts, ShellAPI, dxCore, cxImageList, dxThreading;

const
  dxThisUnitName = 'dxShellBreadcrumbEdit';

const
  CLSID_ShellUrl: TGUID = '{4BEC2015-BFA1-42FA-9C0C-59431BBE880E}';
  SID_IShellUrl = '{88DF9332-6ADB-4604-8218-508673EF7F8A}';
  SID_IShellUrl2 = '{4F33718D-BAE1-4F9B-96F2-D2A16E683346}';
  IID_IShellUrl: TGUID = SID_IShellUrl;
  IID_IShellUrl2: TGUID = SID_IShellUrl2;

{$TYPEINFO OFF}
type
  TdxBreadcrumbEditNodeViewItemAccess = class(TdxBreadcrumbEditNodeViewItem);

  IShellUrl = interface
  [SID_IShellUrl]
    function ParseFromOutsideSource(APath: PChar; AFlags: DWORD): HRESULT; stdcall;
    function GetUrl(APath: PChar; AParam: DWORD): HRESULT; stdcall;
    function SetUrl(const APath: PChar; AParam: DWORD): HRESULT; stdcall; 
    function GetDisplayName(APath: PChar; AParam: DWORD): HRESULT; stdcall;
    function GetPidl(out APidl: PItemIDLIst): HRESULT; stdcall;
    function SetPidl(APidl: PItemIDLIst): HRESULT; stdcall; 
    function SetPidlAndArgs(APidl: PItemIDLIst; AParam: PChar): HRESULT; stdcall; 
    function GetArgs: PChar; stdcall; 
    function AddPath(APidl: PItemIDList): HRESULT; stdcall;
    procedure SetCancelObject(ACancelMethodCalls: Pointer); stdcall; 
    function StartAsyncPathParse: HRESULT; stdcall; 
    function GetParseResult: HRESULT; stdcall; 
    function SetRequestID(AParam: Integer): HRESULT; stdcall; 
    function GetRequestID(var AParam: Integer): HRESULT; stdcall; 
    function SetNavFlags(AParam1: Integer; AParam2: Integer): HRESULT; stdcall; 
    function Stub: HRESULT; stdcall; 
    function Execute: HRESULT; stdcall; 
    function SetCurrentWorkingDir(APidl: PItemIDList): HRESULT; stdcall; 
    procedure SetMessageBoxParent(AWindow: HWND); stdcall; 
    function GetPidlNoGenerate(out APidl: PItemIDList): HRESULT; stdcall; 
    function GetStandardParsingFlags(AParam: BOOL): DWORD; stdcall;
  end;

  IShellUrl2 = interface
  [SID_IShellUrl2]
    function ParseFromOutsideSource(APath: PChar; AFlags: DWORD): HRESULT; stdcall;
    function GetUrl(APath: PChar; AParam: DWORD): HRESULT; stdcall;
    function SetUrl(const APath: PChar; AParam: DWORD): HRESULT; stdcall; 
    function GetDisplayName(APath: PChar; AParam: DWORD): HRESULT; stdcall;
    function GetPidl(out APidl: PItemIDLIst): HRESULT; stdcall;
    function SetPidl(APidl: PItemIDLIst): HRESULT; stdcall; 
    function SetPidlAndArgs(APidl: PItemIDLIst; AParam: PChar): HRESULT; stdcall; 
    function GetArgs: PChar; stdcall; 
    function AddPath(APidl: PItemIDList): HRESULT; stdcall;
    procedure SetCancelObject(ACancelMethodCalls: Pointer); stdcall; 
    function StartAsyncPathParse: HRESULT; stdcall; 
    function GetParseResult: HRESULT; stdcall; 
    function SetRequestID(AParam: Integer): HRESULT; stdcall; 
    function GetRequestID(var AParam: Integer): HRESULT; stdcall; 
    function SetNavFlags(AParam1: Integer; AParam2: Integer): HRESULT; stdcall; 
    function Stub: HRESULT; stdcall; 
    function Execute: HRESULT; stdcall; 
    function SetCurrentWorkingDir(APidl: PItemIDList): HRESULT; stdcall; 
    procedure SetMessageBoxParent(AWindow: HWND); stdcall; 
    function GetPidlNoGenerate(out APidl: PItemIDList): HRESULT; stdcall; 
    function GetStandardParsingFlags(AParam: BOOL): DWORD; stdcall;
    function GetUrlAlloc(out APath: PChar): HRESULT; stdcall;
  end;

  TdxShellUrl = class
  strict private
    FIsInitialized: Boolean;
    FShellUrl: IShellUrl;
    FShellUrl2: IShellUrl2;
    procedure AddPath(APidl: PItemIDList);
    function GetParsingFlags: Cardinal;
    function GetPidl(out APidl: PItemIDList): Boolean;
    function GetUrlAlloc(out APath: string): Boolean;
    function ParseFromOutsideSource(APath: PChar; AFlags: Cardinal): Boolean;
    function SetPidl(const APidl: PItemIDList): Boolean;
    function UseNewInterface: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function GetPidlByRelativePath(const APath: string): PItemIDList;
    function GetRelativePathByPidl(const APidl: PItemIDList): string;
  end;

{ TdxShellUrl }

constructor TdxShellUrl.Create;
const
  SCidls2: array [0..2] of Integer = ($11, $4005, $4006);
  SCidls: array [0..2] of Integer = ($11, $5, $6);
var
  I: Integer;
  ATempPidl: PItemIDList;
  ACidl: Integer;
begin
  inherited Create;
  if UseNewInterface then
    FIsInitialized := Succeeded(CoCreateInstance(CLSID_ShellUrl, nil,
      CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IID_IShellUrl2, FShellUrl2))
  else
    FIsInitialized := Succeeded(CoCreateInstance(CLSID_ShellUrl, nil,
      CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IID_IShellUrl, FShellUrl));
  if FIsInitialized then
    for I := 0 to High(SCidls) do
    begin
      if UseNewInterface then
        ACidl := SCidls2[I]
      else
        ACidl := SCidls[I];
      cxGetFolderLocation(0, ACidl, 0, 0, ATempPidl);
      AddPath(ATempPidl);
      DisposePidl(ATempPidl);
    end;
end;

destructor TdxShellUrl.Destroy;
begin
  FShellUrl := nil;
  FShellUrl2 := nil;
  inherited Destroy;
end;

procedure TdxShellUrl.AddPath(APidl: PItemIDList);
begin
  if UseNewInterface then
    FShellUrl2.AddPath(APidl)
  else
    FShellUrl.AddPath(APidl);
end;

function TdxShellUrl.GetParsingFlags: Cardinal;
begin
  if UseNewInterface then
    Result := FShellUrl2.GetStandardParsingFlags(True)
  else
    Result := FShellUrl.GetStandardParsingFlags(True);
  Result := Result or 1;
end;

function TdxShellUrl.GetPidl(out APidl: PItemIDList): Boolean;
begin
  if UseNewInterface then
    Result := Succeeded(FShellUrl2.GetPidl(APidl))
  else
    Result := Succeeded(FShellUrl.GetPidl(APidl))
end;

function TdxShellUrl.GetUrlAlloc(out APath: string): Boolean;
var
  AStr: PChar;
begin
  AStr := StrAlloc(255);
  try
    if UseNewInterface then
      Result := Succeeded(FShellUrl2.GetUrl(AStr, $824))
    else
      Result := Succeeded(FShellUrl.GetUrl(AStr, $824));
    if Result then
      APath := AStr
    else
      APath := '';
  finally
    StrDispose(AStr);
  end;
end;

function TdxShellUrl.GetPidlByRelativePath(const APath: string): PItemIDList;
var
  APidl: PItemIDList;
begin
  if FIsInitialized and ParseFromOutsideSource(PChar(APath), GetParsingFlags) and GetPidl(APidl) then
    Result := APidl
  else
    Result := nil;
end;

function TdxShellUrl.GetRelativePathByPidl(const APidl: PItemIDList): string;
begin
  if not FIsInitialized or not SetPidl(APidl) or not GetUrlAlloc(Result) then
    Result := '';
end;

function TdxShellUrl.ParseFromOutsideSource(APath: PChar;  AFlags: Cardinal): Boolean;
begin
  if UseNewInterface then
    Result := Succeeded(FShellUrl2.ParseFromOutsideSource(APath, GetParsingFlags))
  else
    Result := Succeeded(FShellUrl.ParseFromOutsideSource(APath, GetParsingFlags));
end;

function TdxShellUrl.SetPidl(const APidl: PItemIDList): Boolean;
begin
  if UseNewInterface then
    Result := Succeeded(FShellUrl2.SetPidl(APidl))
  else
    Result := Succeeded(FShellUrl.SetPidl(APidl));
end;

function TdxShellUrl.UseNewInterface: Boolean;
begin
  Result := IsWin10OrLater;
end;
{$TYPEINFO ON}

{ TdxShellBreadcrumbEditNode }

constructor TdxShellBreadcrumbEditNode.Create(AOwner: IdxTreeOwner);
begin
  inherited Create(AOwner);
  FProducer := TdxShellBreadcrumbEditProducer.Create(Self);
end;

destructor TdxShellBreadcrumbEditNode.Destroy;
begin
  FreeShellObjects;
  FreeAndNil(FProducer);
  inherited Destroy;
end;

function TdxShellBreadcrumbEditNode.AddChild: TdxShellBreadcrumbEditNode;
begin
  Result := TdxShellBreadcrumbEditNode(inherited AddChild);
end;

function TdxShellBreadcrumbEditNode.Compare(const AName: string): Boolean;
begin
  Result := inherited Compare(AName) or SameText(FolderName, AName);
end;

procedure TdxShellBreadcrumbEditNode.FreeShellObjects;
begin
  FShellFolder := nil;
  DisposePidl(FAbsolutePidl);
  FAbsolutePidl := nil;
end;

procedure TdxShellBreadcrumbEditNode.Initialize(AItemInfo: TcxShellItemInfo);

  function GetRootNodeInfo(AShellRoot: TdxShellBreadcrumbEditRoot;
    out AFolder: TcxShellFolder; out APidl: PItemIDList): Boolean;
  begin
    if AShellRoot.ShellFolder = nil then
      AShellRoot.CheckRoot;
    Result := AShellRoot.IsValid;
    if Result then
    begin
      AFolder := AShellRoot.Folder;
      APidl := GetPidlCopy(AShellRoot.Pidl);
    end;
  end;

  function GetNodeInfo(out AFolder: TcxShellFolder; out AIconIndex: Integer): Boolean;
  var
    APidl: PItemIDList;
  begin
    if IsRoot then
      Result := GetRootNodeInfo(Options.Root, AFolder, APidl)
    else
    begin
      APidl := AItemInfo.CreateAbsolutePidl;
      AFolder := AItemInfo.Folder;
      Result := True;
    end;

    if Result then
    begin
      AIconIndex := TdxShellItemHelper.GetIconIndexByPidl(APidl);
      DisposePidl(APidl);
    end;
  end;

var
  AFolder: TcxShellFolder;
  AIconIndex: Integer;
begin
  BeginUpdate;
  try
    DeleteChildren;
    FreeShellObjects;
    Producer.ShellItemInfo := AItemInfo;
    if GetNodeInfo(AFolder, AIconIndex) then
    begin
      FName := AFolder.DisplayName;
      HasChildren := AFolder.SubFolders;
      ImageIndex := AIconIndex;
      Properties.ItemImageUpdated(Self);
      IsHidden := not Options.ShowHiddenFolders and (sfaHidden in AFolder.Attributes) or
        dxIsSearchFolderPidl(Pidl);
    end;
    Notify([tnStructure, tnData]);
  finally
    EndUpdate;
  end;
end;

function TdxShellBreadcrumbEditNode.GetAbsolutePidl: PItemIDList;
begin
  if FAbsolutePidl = nil then
  begin
    if IsRoot then
      FAbsolutePidl := GetPidlCopy(Pidl)
    else
    begin
      if Parent.Producer.IsQuickAccess then
        FAbsolutePidl := Producer.ShellItemInfo.RealItemPidl
      else
        FAbsolutePidl := ConcatenatePidls(Parent.AbsolutePidl, Pidl);
    end;
  end;
  Result := FAbsolutePidl;
end;

function TdxShellBreadcrumbEditNode.GetEdit: IdxBreadcrumbEdit;
begin
  Result := FOwner as IdxBreadcrumbEdit;
end;

function TdxShellBreadcrumbEditNode.GetFolderName: string;
var
  ATempPath: string;
begin
  ATempPath := dxExcludeTrailingPathDelimiter(Path, PathDelimiter);
  Result := dxExtractFileName(ATempPath, PathDelimiter);
  if Result = '' then
    Result := ATempPath;
end;

function TdxShellBreadcrumbEditNode.GetItem(AIndex: Integer): TdxShellBreadcrumbEditNode;
begin
  Result := TdxShellBreadcrumbEditNode(inherited Items[AIndex]);
end;

function TdxShellBreadcrumbEditNode.AreChildrenLoaded: Boolean;
begin
  Result := not (nsHasChildren in State);
end;

function TdxShellBreadcrumbEditNode.GetPath: string;
begin
  Result := RealPath;
  if (Result = '') or IsRoot then
    Result := inherited GetPath;
end;

function TdxShellBreadcrumbEditNode.GetRealPath: string;
var
  AShellUrl: TdxShellUrl;
begin
  AShellUrl := TdxShellUrl.Create;
  try
    Result := AShellUrl.GetRelativePathByPidl(AbsolutePidl);
  finally
    AShellUrl.Free;
  end;

  if Result = '' then
    Result := dxReplacePathDelimiter(GetPidlName(AbsolutePIDL), PathDelim, PathDelimiter);
end;

function TdxShellBreadcrumbEditNode.GetParent: TdxShellBreadcrumbEditNode;
begin
  Result := TdxShellBreadcrumbEditNode(inherited Parent);
end;

function TdxShellBreadcrumbEditNode.GetPidl: PItemIDList;
begin
  if IsRoot then
    Result := Options.Root.Pidl
  else
    Result := Producer.ShellItemInfo.Pidl;
end;

function TdxShellBreadcrumbEditNode.GetProperties: TdxShellBreadcrumbEditProperties;
begin
  Result := Edit.GetProperties as TdxShellBreadcrumbEditProperties;
end;

function TdxShellBreadcrumbEditNode.GetShellFolder: IShellFolder;
begin
  if FShellFolder = nil then
  begin
    if IsRoot then
      FShellFolder := Options.Root.ShellFolder
    else
      if Failed(Parent.ShellFolder.BindToObject(Pidl, nil, IID_IShellFolder, FShellFolder)) then
        FShellFolder := nil;
  end;
  Result := FShellFolder;
end;

function TdxShellBreadcrumbEditNode.GetOptions: TdxShellBreadcrumbEditShellOptions;
begin
  Result := Properties.ShellOptions;
end;

procedure TdxShellBreadcrumbEditNode.SetPidl(const Value: PItemIDList);
var
  AShellFolder: TcxShellFolder;
begin
  if Parent <> nil then
  begin
    Producer.CheckInitialized;
    Producer.ShellItemInfo.SetNewPidl(Producer.ShellFolder, Producer.FolderPidl, Value);
    FreeShellObjects;

    AShellFolder := TcxShellFolder.Create(AbsolutePidl);
    try
      FName := AShellFolder.DisplayName;
    finally
      AShellFolder.Free;
    end;
    Notify([tnData]);
  end;
end;

{ TdxShellBreadcrumbEditProducer }

constructor TdxShellBreadcrumbEditProducer.Create(ANode: TdxShellBreadcrumbEditNode);
begin
  inherited Create(ANode.Edit.GetContainer);
  FNode := ANode;
end;

function TdxShellBreadcrumbEditProducer.CanAddFolder(AFolder: TcxShellFolder): Boolean;
var
  AEvents: IdxShellBreadcrumbEditEvents;
begin
  Result := (AFolder <> nil) and AFolder.IsFolder and (Node.Options.ShowZipFilesWithFolders or not cxShellIsZipFile(AFolder));
  if Result then
  begin
    if Supports(Node.Edit, IdxShellBreadcrumbEditEvents, AEvents) then
      AEvents.AddFolder(AFolder, Result);
  end;
end;

procedure TdxShellBreadcrumbEditProducer.CheckInitialized;
begin
  if not IsInitialized then
    Initialize(Node.ShellFolder, Node.AbsolutePidl);
end;

function TdxShellBreadcrumbEditProducer.SlowInitializationDone(AItem: TcxShellItemInfo): Boolean;
begin
  Result := AItem.Updated;
end;

procedure TdxShellBreadcrumbEditProducer.DoSlowInitialization(AItem: TcxShellItemInfo);
begin
  InitializeItem(AItem);
end;

procedure TdxShellBreadcrumbEditProducer.ProcessItems;
var
  AFolder: IShellFolder;
  APidl: PItemIDList;
begin
  ClearItems;
  AFolder := Node.ShellFolder;
  if AFolder <> nil then
  try
    APidl := GetPidlCopy(Node.AbsolutePidl);
    if APidl <> nil then
    try
      ProcessItems(AFolder, APidl, 0);
    finally
      DisposePidl(APidl);
    end;
  finally
    AFolder := nil;
  end;
end;

function TdxShellBreadcrumbEditProducer.GetEnumFlags: Cardinal;
begin
  Result := SHCONTF_FOLDERS;
  if Node.Options.ShowHiddenFolders then
    Result := Result or SHCONTF_INCLUDEHIDDEN;
end;

function TdxShellBreadcrumbEditProducer.GetIsInitialized: Boolean;
begin
  Result := ShellFolder <> nil;
end;

function TdxShellBreadcrumbEditProducer.GetItemIndexByPidl(APidl: PItemIDList): Integer;
begin
  Result := EnsureRange(inherited GetItemIndexByPidl(APidl), -1, Node.Count - 1);
end;

function TdxShellBreadcrumbEditProducer.GetNodeByPidl(APidl: PItemIDList): TdxShellBreadcrumbEditNode;
var
  AIndex: Integer;
  AItemInfo: TcxShellItemInfo;
begin
  AIndex := GetItemIndexByPidl(APidl);
  if AIndex = -1 then
  begin
    LockWrite;
    try
      CheckInitialized;
      AItemInfo := InternalAddItem(GetPidlCopy(APidl));
      if AItemInfo <> nil then
      begin
        Node.BeginUpdate;
        try
          Sort;
          InitializeItem(AItemInfo);
          SetItemsCount(Items.Count);
          AIndex := GetItemIndexByPidl(APidl);
        finally
          Node.EndUpdate;
        end;
      end;
    finally
      UnlockWrite;
    end;
  end;

  if (AIndex > -1) and (AIndex < Node.Count) then
    Result := Node[AIndex]
  else
    Result := nil;
end;

function TdxShellBreadcrumbEditProducer.GetShowToolTip: Boolean;
begin
  Result := False;
end;

procedure TdxShellBreadcrumbEditProducer.SetItemsCount(Count: Integer);
var
  APrevState: TdxTreeNodeStates;
  I: Integer;
begin
  LockRead;
  try
    Node.BeginUpdate;
    try
      APrevState := Node.State;
      try
        Node.DeleteChildren;
        for I := 0 to Count - 1 do
          Node.AddChild.Initialize(Items[I]);
      finally
        Node.State := APrevState;
      end;
    finally
      Node.EndUpdate;
    end;
  finally
    UnlockRead;
  end;
end;

{ TdxShellBreadcrumbEditProperties }

constructor TdxShellBreadcrumbEditProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FShellOptions := TdxShellBreadcrumbEditShellOptions.Create(Self);
  FShellOptions.OnChange := ShellOptionsChanged;
  FShellImageList := CreateShellImageList;
  Images := FShellImageList;
end;

destructor TdxShellBreadcrumbEditProperties.Destroy;
begin
  Images := nil;
  FreeAndNil(FShellImageList);
  FreeAndNil(FShellOptions);
  inherited Destroy;
end;

procedure TdxShellBreadcrumbEditProperties.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  Images := FShellImageList;
  if Source is TdxShellBreadcrumbEditProperties then
  begin
    AllowDragDrop := TdxShellBreadcrumbEditProperties(Source).AllowDragDrop;
    ShellOptions := TdxShellBreadcrumbEditProperties(Source).ShellOptions;
  end;
end;

procedure TdxShellBreadcrumbEditProperties.ChangeScale(M, D: Integer);
var
  ABreadcrumb: IdxBreadcrumbEdit;
begin
  inherited ChangeScale(M, D);
  if Supports(Owner, IdxBreadcrumbEdit, ABreadcrumb) then
    FShellImageList.ScaleChanged(ABreadcrumb.GetScaleFactor);
end;

function TdxShellBreadcrumbEditProperties.CreatePathEditorProperties: TdxBreadcrumbEditPathEditorProperties;
begin
  Result := TdxShellBreadcrumbEditPathEditorProperties.Create(Self);
end;

procedure TdxShellBreadcrumbEditProperties.ItemImageUpdated(ANode: TdxShellBreadcrumbEditNode);
begin
  if ANode.ImageIndex > FShellImageList.Count - 1 then
    FShellImageList.Reload;
end;

function TdxShellBreadcrumbEditProperties.CreateShellImageList: TdxShellSmallImageList;
begin
  Result := TdxShellSmallImageList.Create(nil);
end;

function TdxShellBreadcrumbEditProperties.GetPathEditor: TdxShellBreadcrumbEditPathEditorProperties;
begin
  Result := inherited PathEditor as TdxShellBreadcrumbEditPathEditorProperties;
end;

procedure TdxShellBreadcrumbEditProperties.ShellOptionsChanged(
  Sender: TObject; const AChanges: TdxShellBreadcrumbEditShellOptionsChanges);
begin
  if Assigned(OnShellOptionsChanged) then
    OnShellOptionsChanged(Self, AChanges);
end;

procedure TdxShellBreadcrumbEditProperties.SetPathEditor(AValue: TdxShellBreadcrumbEditPathEditorProperties);
begin
  inherited PathEditor := AValue;
end;

procedure TdxShellBreadcrumbEditProperties.SetShellOptions(AValue: TdxShellBreadcrumbEditShellOptions);
begin
  FShellOptions.Assign(AValue);
end;

{ TdxShellBreadcrumbEditShellOptions }

constructor TdxShellBreadcrumbEditShellOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FRoot := TdxShellBreadcrumbEditRoot.Create(Self, 0);
  FRoot.OnSettingsChanged := DoSettingsChanged;
  FRoot.OnFolderChanged := DoFolderChanged;
  FShowZipFilesWithFolders := True;
  FTrackShellChanges := True;
end;

destructor TdxShellBreadcrumbEditShellOptions.Destroy;
begin
  FreeAndNil(FRoot);
  inherited Destroy;
end;

procedure TdxShellBreadcrumbEditShellOptions.Assign(Source: TPersistent);
begin
  if Source is TdxShellBreadcrumbEditShellOptions then
  begin
    Root := TdxShellBreadcrumbEditShellOptions(Source).Root;
    ShowHiddenFolders := TdxShellBreadcrumbEditShellOptions(Source).ShowHiddenFolders;
    TrackShellChanges := TdxShellBreadcrumbEditShellOptions(Source).TrackShellChanges;
    ShowZipFilesWithFolders := TdxShellBreadcrumbEditShellOptions(Source).ShowZipFilesWithFolders;
  end;
end;

procedure TdxShellBreadcrumbEditShellOptions.Changed(AChanges: TdxShellBreadcrumbEditShellOptionsChanges);
begin
  if Assigned(OnChange) then
    OnChange(Self, AChanges);
end;

procedure TdxShellBreadcrumbEditShellOptions.DoFolderChanged(Sender: TObject; Root: TcxCustomShellRoot);
begin
  Changed([bcescContent, bcescRoot]);
end;

procedure TdxShellBreadcrumbEditShellOptions.DoSettingsChanged(Sender: TObject);
begin
  Changed([bcescContent]);
end;

procedure TdxShellBreadcrumbEditShellOptions.SetRoot(AValue: TdxShellBreadcrumbEditRoot);
begin
  FRoot.Assign(AValue);
end;

procedure TdxShellBreadcrumbEditShellOptions.SetShowHiddenFolders(AValue: Boolean);
begin
  if FShowHiddenFolders <> AValue then
  begin
    FShowHiddenFolders := AValue;
    Changed([bcescContent]);
  end;
end;

procedure TdxShellBreadcrumbEditShellOptions.SetShowZipFilesWithFolders(AValue: Boolean);
begin
  if FShowZipFilesWithFolders <> AValue then
  begin
    FShowZipFilesWithFolders := AValue;
    Changed([bcescContent]);
  end;
end;

procedure TdxShellBreadcrumbEditShellOptions.SetTrackShellChanges(AValue: Boolean);
begin
  if FTrackShellChanges <> AValue then
  begin
    FTrackShellChanges := AValue;
    Changed([bcescTracking]);
  end;
end;

{ TdxShellBreadcrumbEditController }

procedure TdxShellBreadcrumbEditController.CancelSelectionChanges;
begin
  Exclude(FChanges, bcecSelection);
end;

function TdxShellBreadcrumbEditController.CreatePathEditingController: TdxBreadcrumbEditPathEditingController;
begin
  Result := TdxShellBreadcrumbPathEditingController.Create(Self);
end;

procedure TdxShellBreadcrumbEditController.DoAfterSelect;
begin
  inherited DoAfterSelect;
  UpdateTrackingSettings;
end;

procedure TdxShellBreadcrumbEditController.DoShellChangeNotify(
  AEventID: Longint; APidl1, APidl2: PItemIDList);
var
  AEvents: IdxShellBreadcrumbEditEvents;
begin
  if Supports(Control, IdxShellBreadcrumbEditEvents, AEvents) then
  try
    AEvents.ShellChanged(AEventID, APidl1, APidl2);
  finally
    AEvents := nil;
  end;
end;

function TdxShellBreadcrumbEditController.FindNodeByPath(APath: string): TdxBreadcrumbEditNode;
var
  APidl: PItemIDList;
begin
  Result := nil;
  if GetPidlByPath(APath, APidl) then
  try
    Result := FindNodeByPidl(APidl);
  finally
    DisposePidl(APidl);
  end;
  if Result = nil then
    Result := inherited FindNodeByPath(APath);
end;

function TdxShellBreadcrumbEditController.FindNodeByPidl(APidl: PItemIDList; AIgnoreFile: Boolean = False): TdxShellBreadcrumbEditNode;
var
  AItemInfo: TcxShellItemInfo;
  AParentNode: TdxShellBreadcrumbEditNode;
  APartDestPidl: PItemIDList;
  ASourcePidl: PItemIDList;
  I: Integer;
  AOriginalPidl: PItemIDList;
begin
  Result := nil;
  AOriginalPidl := GetPidlCopy(APidl);
  try
    ASourcePidl := ShellOptions.Root.Pidl;
    if GetPidlItemsCount(ASourcePidl) <= GetPidlItemsCount(APidl) then
    begin
      for I := 0 to GetPidlItemsCount(ASourcePidl) - 1 do
        APidl := GetNextItemID(APidl);

      Result := Root;
      for I := 0 to GetPidlItemsCount(APidl) - 1 do
      begin
        APartDestPidl := ExtractParticularPidl(APidl);
        APidl := GetNextItemID(APidl);
        if APartDestPidl <> nil then
        try
          AParentNode := Result;
          Result := Result.Producer.GetNodeByPidl(APartDestPidl);

          if Result = nil then
          begin
            if (AParentNode <> nil) and AIgnoreFile then
            begin
              AParentNode.Producer.CheckInitialized;
              AItemInfo := AParentNode.Producer.CreateShellItemInfo(APartDestPidl, False);
              try
                if not AItemInfo.IsFolder then
                  Result := AParentNode;
              finally
                AItemInfo.Free;
              end;
            end;
            Break;
          end;
        finally
          DisposePidl(APartDestPidl);
        end
        else
          Break;
      end;
    end;
    if (Result <> nil) and dxIsSearchFolderPidl(AOriginalPidl) then
    begin
      Result.DeleteChildren;
      Result.HasChildren := True;
      Result.Pidl := AOriginalPidl; 
    end;
  finally
    DisposePidl(AOriginalPidl);
  end;
end;

procedure TdxShellBreadcrumbEditController.ShellChangeNotify(AEventID: Longint; APidl1, APidl2: PItemIDList);
var
  AItemInfo: TcxShellItemInfo;
  ANode: TdxShellBreadcrumbEditNode;
  AProducer: TdxShellBreadcrumbEditProducer;
begin
  try
    case AEventID of
      SHCNE_RMDIR:
        if (Selected <> nil) and Selected.AreChildrenLoaded then
          FindNodeByPidl(APidl1).Free;

      SHCNE_RENAMEFOLDER:
        if (Selected <> nil) and Selected.AreChildrenLoaded then
        begin
          ANode := FindNodeByPidl(APidl1);
          if ANode <> nil then
            ANode.Pidl := GetLastPidlItem(APidl2);
        end;

      SHCNE_MKDIR:
        if (Selected <> nil) and Selected.AreChildrenLoaded and (FindNodeByPidl(APidl1) = nil) then
        begin
          BeginUpdate;
          try
            AProducer := Selected.Producer;
            AProducer.CheckInitialized;
            AItemInfo := AProducer.CreateShellItemInfo(GetLastPidlItem(APidl1), False);
            if AItemInfo <> nil then
            begin
              AProducer.LockWrite;
              try
                AProducer.Items.Add(AItemInfo);
                AProducer.Sort;
                Selected.AddChild.Initialize(AItemInfo);
              finally
                AProducer.UnlockWrite;
              end;
            end
            else
              UpdateContent;
          finally
            EndUpdate;
          end;
        end;
      SHCNE_UPDATEDIR:
        begin
          if (Selected <> nil) and Selected.AreChildrenLoaded then
          begin
            ANode := FindNodeByPidl(APidl1);
            if ANode <> nil then
            begin
              ANode.DeleteChildren;
              ANode.HasChildren := True;
              ANode.LoadChildren;
            end;
          end;
        end;
    end;
  finally
    DoShellChangeNotify(AEventID, APidl1, APidl2);
  end;
end;

procedure TdxShellBreadcrumbEditController.BeginUpdateContent(var AState: TState);
begin
  Inc(FUpdateContentLockCount);
  AState.DropDownMenuState := IsNodeDropDownMenuWindowActive;
  AState.DropDownMenuOwnerPidl := nil;
  if DropDownMenuOwner <> nil then
    AState.DropDownMenuOwnerPidl := GetPidlCopy((DropDownMenuOwner.Node as TdxShellBreadcrumbEditNode).AbsolutePidl);
  AState.SelectedPidl := GetPidlCopy(SelectedPidl);
  BeginUpdate;
end;

procedure TdxShellBreadcrumbEditController.EndUpdateContent(var AState: TState);
var
  ANodeViewItem: TdxBreadcrumbEditNodeViewItem;
begin
  RestoreSelection(AState.SelectedPidl);
  EndUpdate;

  if AState.DropDownMenuState then
  begin
    if ViewInfo.NodesAreaViewInfo.FindViewItem(FindNodeByPidl(AState.DropDownMenuOwnerPidl), ANodeViewItem) then
      ShowNodeDropDownMenu(ANodeViewItem);
  end;

  dxFreeAndNilPidl(AState.DropDownMenuOwnerPidl);
  dxFreeAndNilPidl(AState.SelectedPidl);
  Dec(FUpdateContentLockCount);
end;

function TdxShellBreadcrumbEditController.IsUpdatingContent: Boolean;
begin
  Result := FUpdateContentLockCount > 0;
end;

procedure TdxShellBreadcrumbEditController.UpdateContent;
var
  AState: TState;
begin
  BeginUpdateContent(AState);
  try
    Root.Initialize(nil);
  finally
    EndUpdateContent(AState);
  end;
end;

procedure TdxShellBreadcrumbEditController.UpdateTrackingSettings;
begin
  if ShellOptions.TrackShellChanges then
    cxShellRegisterChangeNotifier(SelectedPidl, Handle, DSM_SYSTEMSHELLCHANGENOTIFY, False, FShellChangeNotifierData)
  else
    RemoveChangeNotification;
end;

procedure TdxShellBreadcrumbEditController.WndProc(var Message: TMessage);
var
  AEventID: Integer;
  APidl1, APidl2: PItemIDList;
begin
  if Message.Msg = DSM_SYSTEMSHELLCHANGENOTIFY then
  begin
    cxShellGetNotifyParams(Message, AEventID, APidl1, APidl2);
    try
      ShellChangeNotify(AEventID, APidl1, APidl2);
    finally
      DisposePidl(APidl1);
      DisposePidl(APidl2);
    end;
  end;
  inherited WndProc(Message);
end;

function TdxShellBreadcrumbEditController.FindRootNodeForPath(var APath: string; out ANode: TdxBreadcrumbEditNode): Boolean;
var
  ASavedPath: string;
  ARootRealPath: string;
begin
  ASavedPath := APath;
  Result := inherited FindRootNodeForPath(APath, ANode);
  if not Result then
  begin
    ARootRealPath := dxIncludeTrailingPathDelimiter(Root.RealPath, PathDelimiter);
    Result := Pos(LowerCase(ARootRealPath), LowerCase(dxIncludeTrailingPathDelimiter(ASavedPath, PathDelimiter))) = 1;
    if Result then
    begin
      APath := Copy(ASavedPath, Length(ARootRealPath) + 1, MaxInt);
      ANode := Root;
    end;
  end;
end;

function TdxShellBreadcrumbEditController.GetPidlByPath(APath: string; out APidl: PItemIDList): Boolean;

  function DecodePath(const AOriginalPath: string): string;
  begin
    Result := dxIncludeTrailingPathDelimiter(dxReplacePathDelimiter(AOriginalPath, PathDelimiter, PathDelim));
  end;

const
  ViewOptions = [svoShowFolders, svoShowHidden];
var
  ANode: TdxBreadcrumbEditNode;
  ANodeName: string;
  ASavedNode: TdxShellBreadcrumbEditNode;
  ASavedPath: string;
  ATempPidl: PItemIDList;
  AShellUrl: TdxShellUrl;
begin
  if dxPathIsRelative(PChar(APath)) then
  begin
    AShellUrl := TdxShellUrl.Create;
    try
      APidl := AShellUrl.GetPidlByRelativePath(APath);
    finally
      AShellUrl.Free;
    end;
  end
  else
    APidl := nil;
  if APidl = nil then
    APidl := PathToAbsolutePIDL(DecodePath(APath), ShellOptions.Root, ViewOptions);
  if APidl = nil then
  begin
    if FindRootNodeForPath(APath, ANode) then
    begin
      repeat
        ASavedPath := APath;
        ASavedNode := ANode as TdxShellBreadcrumbEditNode;
        if not ParsePath(ANodeName, APath) then
          Break;
        if not ANode.FindNode(ANodeName, ANode) and (ASavedNode.ShellFolder <> nil) then
        begin
          ATempPidl := InternalParseDisplayName(ASavedNode.ShellFolder, DecodePath(ASavedPath), ViewOptions);
          if ATempPidl <> nil then
          try
            APidl := ConcatenatePidls(ASavedNode.AbsolutePidl, ATempPidl);
          finally
            DisposePidl(ATempPidl);
          end;
          Break;
        end;
      until False;
    end;
  end;
  Result := APidl <> nil;
end;

procedure TdxShellBreadcrumbEditController.RemoveChangeNotification;
begin
  cxShellUnregisterChangeNotifier(FShellChangeNotifierData);
end;

procedure TdxShellBreadcrumbEditController.RestoreSelection(APidl: PItemIDList);
var
  ANode: TdxShellBreadcrumbEditNode;
  AParentPidl: PItemIDList;
  ASelectedPidl: PItemIDList;
begin
  ASelectedPidl := APidl;
  while APidl <> nil do
  begin
    ANode := FindNodeByPidl(APidl);
    if ANode <> nil then
    begin
      if SelectPath(ANode) then
      begin
        if APidl = ASelectedPidl then
          CancelSelectionChanges;
      end;
      Break;
    end;
    if GetPidlItemsCount(APidl) = 0 then
      Break;
    AParentPidl := GetPidlParent(APidl);
    if ASelectedPidl <> APidl then
      DisposePidl(APidl);
    APidl := AParentPidl;
  end;
end;

function TdxShellBreadcrumbEditController.ShouldUpdateSelectedNode(ANode: TdxBreadcrumbEditNode): Boolean;
begin
  Result := inherited ShouldUpdateSelectedNode(ANode) or dxIsSearchFolderPidl(TdxShellBreadcrumbEditNode(ANode).AbsolutePidl);
end;

function TdxShellBreadcrumbEditController.GetPathDelimiter: Char;
begin
  Result := PathEditingController.Properties.PathDelimiter;
end;

function TdxShellBreadcrumbEditController.GetRoot: TdxShellBreadcrumbEditNode;
begin
  Result := TdxShellBreadcrumbEditNode(inherited Root);
end;

function TdxShellBreadcrumbEditController.GetSelected: TdxShellBreadcrumbEditNode;
begin
  Result := TdxShellBreadcrumbEditNode(inherited Selected);
end;

function TdxShellBreadcrumbEditController.GetSelectedPidl: PItemIDList;
begin
  if Selected <> nil then
    Result := TdxShellBreadcrumbEditNode(Selected).AbsolutePidl
  else
    Result := nil;
end;

function TdxShellBreadcrumbEditController.GetSelectedRealPath: string;
begin
  if Selected <> nil then
    Result := Selected.RealPath
  else
    Result := '';
end;

function TdxShellBreadcrumbEditController.GetShellOptions: TdxShellBreadcrumbEditShellOptions;
begin
  Result := (Control.GetProperties as TdxShellBreadcrumbEditProperties).ShellOptions;
end;

procedure TdxShellBreadcrumbEditController.SelectPathViaDropDownMenu(AItem: TdxBreadcrumbEditNode);
var
  APidl: PItemIDList;
begin
  if (TdxShellBreadcrumbEditNode(AItem).Parent <> nil) and
  TdxShellBreadcrumbEditNode(AItem).Parent.Producer.IsQuickAccess then
  begin
    APidl := GetPidlCopy(TdxShellBreadcrumbEditNode(AItem).AbsolutePidl); 
    TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
      procedure ()
      begin
        if dxIsPidlEnumerable(ControlContainer.Handle, APidl) then
          SelectPath(FindNodeByPidl(APidl));
        DisposePidl(APidl);
      end);
  end
  else
    inherited;
end;

procedure TdxShellBreadcrumbEditController.SetSelected(AValue: TdxShellBreadcrumbEditNode);
begin
  inherited Selected := AValue;
end;

procedure TdxShellBreadcrumbEditController.SetSelectedPidl(AValue: PItemIDList);
begin
  Selected := TdxShellBreadcrumbEditNode(FindNodeByPidl(AValue));
end;

{ TdxShellBreadcrumbPathEditingController }

procedure TdxShellBreadcrumbPathEditingController.PopulateSuggestions(const APath: string; ASuggestions: TStringList);
var
  AState: TdxShellBreadcrumbEditController.TState;
begin
  Controller.BeginUpdateContent(AState);
  try
    inherited;
  finally
    Controller.EndUpdateContent(AState);
  end;
end;

procedure TdxShellBreadcrumbPathEditingController.ReleasePathEditor;
begin
  if not Controller.IsUpdatingContent then
    inherited;
end;

function TdxShellBreadcrumbPathEditingController.CreatePathEditor: TdxBreadcrumbEditPathEditor;
begin
  Result :=  TdxShellBreadcrumbEditPathEditor.Create(nil, True);
end;

function TdxShellBreadcrumbPathEditingController.GetController: TdxShellBreadcrumbEditController;
begin
  Result := TdxShellBreadcrumbEditController(inherited Controller);
end;

{ TdxCustomShellBreadcrumbEdit }

constructor TdxCustomShellBreadcrumbEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDependedControls := TcxShellDependedControls.Create;
  FGroupIndex := -1;
  FLoadedGroupIndex := -1;
  Properties.OnShellOptionsChanged := ShellOptionsChangeHandler;
  UpdateContent;
end;

destructor TdxCustomShellBreadcrumbEdit.Destroy;
begin
  Controller.RemoveChangeNotification;
  ShellComboBox := nil;
  ShellListView := nil;
  ShellTreeView := nil;
  FreeAndNil(FDependedControls);
  inherited Destroy;
end;

function TdxCustomShellBreadcrumbEdit.CreateProperties: TdxCustomBreadcrumbEditProperties;
begin
  Result := TdxShellBreadcrumbEditProperties.Create(Self);
end;

function TdxCustomShellBreadcrumbEdit.CreateController: TdxBreadcrumbEditController;
begin
  Result := TdxShellBreadcrumbEditController.Create(ViewInfo);
end;

function TdxCustomShellBreadcrumbEdit.CreateRoot: TdxBreadcrumbEditNode;
begin
  Result := TdxShellBreadcrumbEditNode.Create(Self);
end;

procedure TdxCustomShellBreadcrumbEdit.DestroyWnd;
begin
  dxTestCheck(Succeeded(RevokeDragDrop(Handle)), 'RevokeDragDrop - dxShellBreadcrumbEdit');
  Controller.RemoveChangeNotification;
  inherited DestroyWnd;
end;

procedure TdxCustomShellBreadcrumbEdit.DSMNavigate(var Message: TMessage);
begin
  if FNavigationLockCount = 0 then
  begin
    Inc(FNavigationLockCount);
    try
      Selected := Controller.FindNodeByPidl(PItemIDList(Message.WParam), True);
    finally
      Dec(FNavigationLockCount);
    end;
  end;
end;

procedure TdxCustomShellBreadcrumbEdit.DSMNotifyUpdateContents(var Message: TMessage);
begin
  if not (csLoading in ComponentState) then
    UpdateContent;
end;

procedure TdxCustomShellBreadcrumbEdit.DSMSynchronizeRoot(var Message: TMessage);
begin
  if not IsParentLoading then
    GetShellRoot.Update(TcxCustomShellRoot(Message.WParam));
end;

function TdxCustomShellBreadcrumbEdit.IsParentLoading: Boolean;
begin
  Result := (Parent <> nil) and (csLoading in Parent.ComponentState);
end;

procedure TdxCustomShellBreadcrumbEdit.PopulateSystemRecentPaths;

  function GetImageIndexByPath(const APath: string): Integer;
  var
    AFileInfo: TSHFileInfo;
  begin
    if cxShellGetThreadSafeFileInfo(PChar(APath), FILE_ATTRIBUTE_DIRECTORY, AFileInfo,
      SizeOf(AFileInfo), SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES) <> 0 then
      Result := AFileInfo.iIcon
    else
      Result := -1;
  end;

  function GetImageIndexByPidl(const APidl: PItemIDList): Integer;
  var
    AFileInfo: TSHFileInfo;
  begin
    if cxShellGetThreadSafeFileInfo(PChar(APidl), 0, AFileInfo,
      SizeOf(AFileInfo), SHGFI_SYSICONINDEX or SHGFI_PIDL) <> 0 then
      Result := AFileInfo.iIcon
    else
      Result := -1;
  end;

const
  SExplorerRegPath = 'Software\Microsoft\Windows\CurrentVersion\Explorer\';
  STypedPaths = 'TypedPaths';
  SMaxRecentPathItemCount = 25;

var
  ARegistry: TRegistryIniFile;
  AItems: TStrings;
  I: Integer;
  APath: TdxBreadcrumbEditRecentPath;
  AImageIndex: Integer;
  APidl: PItemIDList;
  AShellUrl: TdxShellUrl;
begin
  if not IsWinSevenOrLater then
    Exit;
  ShowHourglassCursor;
  Properties.PathEditor.RecentPaths.BeginUpdate;
  ARegistry := TRegistryIniFile.Create(SExplorerRegPath, KEY_READ);
  AItems := TStringList.Create;
  AShellUrl := nil;
  try
    ARegistry.ReadSection(STypedPaths, AItems);
    for I := 0 to Min(AItems.Count - 1, SMaxRecentPathItemCount - 1) do
    begin
      APath := Properties.PathEditor.RecentPaths.Add;
      APath.Path := ARegistry.ReadString(STypedPaths, AItems[I], '');
      AImageIndex := -1;
      if dxPathIsRelative(PChar(APath.Path)) then
      begin
        if AShellUrl = nil then
          AShellUrl := TdxShellUrl.Create;
        APidl := AShellUrl.GetPidlByRelativePath(APath.Path);
        if APidl <> nil then
        begin
          AImageIndex := GetImageIndexByPidl(APidl);
          DisposePidl(APidl);
        end;
      end;
      if AImageIndex = -1 then
        AImageIndex := GetImageIndexByPath(APath.Path);
      APath.ImageIndex := AImageIndex;
    end;
  finally
    if AShellUrl <> nil then
      AShellUrl.Free;
    AItems.Free;
    ARegistry.Free;
    Properties.PathEditor.RecentPaths.EndUpdate;
    HideHourglassCursor;
  end;
end;

procedure TdxCustomShellBreadcrumbEdit.LoadChildren(ASender: TdxTreeCustomNode);
var
  AState: TdxShellBreadcrumbEditController.TState;
begin
  if ASender.Count > 0 then
  begin
    Controller.BeginUpdateContent(AState);
    try
      TdxShellBreadcrumbEditNode(ASender).Producer.ProcessItems;
    finally
      Controller.EndUpdateContent(AState);
    end;
  end
  else
    TdxShellBreadcrumbEditNode(ASender).Producer.ProcessItems;
end;

procedure TdxCustomShellBreadcrumbEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Properties.AllowDragDrop and (Controller.PressedViewItem is TdxBreadcrumbEditNodeViewItem) and
    PtInRect(TdxBreadcrumbEditNodeViewItem(Controller.PressedViewItem).ButtonRect, Point(X, Y)) then
    FShellDragDropState := ddsStarting;
end;

procedure TdxCustomShellBreadcrumbEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if (FShellDragDropState = ddsStarting) and not IsMouseInPressedArea(X, Y) then
  begin
    FShellDragDropState := ddsInProcess;
    DoBeginDrag;
    FShellDragDropState := ddsNone;
  end;
end;

procedure TdxCustomShellBreadcrumbEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FShellDragDropState := ddsNone;
end;

procedure TdxCustomShellBreadcrumbEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = ShellComboBox then
      ShellComboBox := nil;
    if AComponent = ShellListView then
      ShellListView := nil;
    if AComponent = ShellTreeView then
      ShellTreeView := nil;
  end;
end;

procedure TdxCustomShellBreadcrumbEdit.Paint;
begin
  if not Controller.IsUpdatingContent then
    inherited Paint;
end;

procedure TdxCustomShellBreadcrumbEdit.PopulateRecentPaths;
begin
  if not FIsSystemRecentPathsLoaded and (Properties.PathEditor as TdxShellBreadcrumbEditPathEditorProperties).UseSystemRecentPaths then
  begin
    PopulateSystemRecentPaths;
    FIsSystemRecentPathsLoaded := True;
  end;
  inherited PopulateRecentPaths;
end;

procedure TdxCustomShellBreadcrumbEdit.RootChanged;
begin
  if Assigned(OnRootChanged) then
    OnRootChanged(Self, GetShellRoot);
end;

procedure TdxCustomShellBreadcrumbEdit.SelectionChanged;
begin
  SynchronizeDependedControls;
  inherited SelectionChanged;
end;

procedure TdxCustomShellBreadcrumbEdit.AddFolder(AFolder: TcxShellFolder; var ACanAdd: Boolean);
begin
  if Assigned(OnAddFolder) then
    OnAddFolder(Self, AFolder, ACanAdd);
end;

procedure TdxCustomShellBreadcrumbEdit.DoBeginDrag;

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
  ASourceItemProducer: TdxShellBreadcrumbEditProducer;
  ANode: TdxShellBreadcrumbEditNode;
begin
  ANode := (Controller.PressedViewItem as TdxBreadcrumbEditNodeViewItem).Node as TdxShellBreadcrumbEditNode;
  if ANode.Parent = nil then
    Exit;
  FDragSource := ANode;
  try
    Controller.PressedViewItem := nil;
    ASourceItemProducer := ANode.Parent.Producer;
    ASourceItemProducer.LockRead;
    try
      if Assigned(dxSHDoDragDropWithPreferredEffect) then
        dxSHDoDragDropWithPreferredEffect(Handle, 0, ANode.AbsolutePidl, 4, 0)
      else
        InternalDoDragDrop(ASourceItemProducer.ShellFolder, GetPidlCopy(ANode.pidl));
    finally
      ASourceItemProducer.UnlockRead;
    end;
  finally
    FDragSource := nil;
  end;
end;

procedure TdxCustomShellBreadcrumbEdit.DoHandleDependedInitialization;
begin
  dxTestCheck(Succeeded(RegisterDragDrop(Handle, Self)), 'RegisterDragDrop - dxShellBreadcrumbEdit');
end;

procedure TdxCustomShellBreadcrumbEdit.ShellChanged(AEventID: DWORD; APIDL1, APIDL2: PItemIDList);
begin
  if Assigned(OnShellChange) then
    OnShellChange(Self, AEventID, APIDL1, APIDL2);
end;

procedure TdxCustomShellBreadcrumbEdit.ShellOptionsChangeHandler(
  Sender: TObject; const AChanges: TdxShellBreadcrumbEditShellOptionsChanges);
begin
  ShellOptionsChanged(AChanges);
end;

procedure TdxCustomShellBreadcrumbEdit.SetDropTarget(AValue: TdxShellBreadcrumbEditNode);
var
  AViewItem: TdxBreadcrumbEditNodeViewItem;
begin
  if FDropTarget <> AValue then
  begin
    if (FDropTarget <> nil) and ViewInfo.NodesAreaViewInfo.FindViewItem(FDropTarget, AViewItem) then
    begin
      TdxBreadcrumbEditNodeViewItemAccess(AViewItem).FIsDropTarget := False;
      AViewItem.Invalidate;
    end;
    FDropTarget := AValue;
    if (FDropTarget <> nil) and ViewInfo.NodesAreaViewInfo.FindViewItem(FDropTarget, AViewItem) then
    begin
      TdxBreadcrumbEditNodeViewItemAccess(AViewItem).FIsDropTarget := True;
      AViewItem.Invalidate;
    end;
  end;
end;

procedure TdxCustomShellBreadcrumbEdit.SetGroupIndex(AValue: Integer);
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

procedure TdxCustomShellBreadcrumbEdit.ShellOptionsChanged(const AChanges: TdxShellBreadcrumbEditShellOptionsChanges);
begin
  if [bcescRoot, bcescContent] * AChanges = [bcescRoot, bcescContent] then
    Root.Initialize(nil)
  else
    if bcescContent in AChanges then
      UpdateContent;

  if bcescRoot in AChanges then
  begin
    RootChanged;
    SynchronizeRoot;
  end;

  if bcescTracking in AChanges then
    Controller.UpdateTrackingSettings;
end;

procedure TdxCustomShellBreadcrumbEdit.SynchronizeDependedControls;
var
  APidl: PItemIDList;
begin
  if (Selected <> nil) and (FNavigationLockCount = 0) then
  begin
    Inc(FNavigationLockCount);
    try
      APidl := GetPidlCopy(SelectedPidl);
      try
        DependedControls.Navigate(APidl);
        TdxShellControlGroups.AbsolutePidlChanged(Self, APidl, FGroupIndex);
      finally
        DisposePidl(APidl);
      end;
    finally
      Dec(FNavigationLockCount);
    end;
  end;
end;

procedure TdxCustomShellBreadcrumbEdit.SynchronizeRoot;
begin
  if not IsParentLoading then
  begin
    DependedControls.SynchronizeRoot(GetShellRoot);
    TdxShellControlGroups.RootChanged(Self, GetShellRoot, FGroupIndex);
  end;
end;

// IDropTarget

function TdxCustomShellBreadcrumbEdit.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  if FDropTargetHelper = nil then
    CoCreateInstance(CLSID_DragDropHelper, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IDropTargetHelper, FDropTargetHelper);
  FDraggedObject := dataObj;
  FCurrentDropTarget := nil;
  dwEffect := DROPEFFECT_NONE;
  Result := S_OK;
  if FDropTargetHelper <> nil then
    FDropTargetHelper.DragEnter(Handle, dataObj, pt, dwEffect);
end;

function TdxCustomShellBreadcrumbEdit.DragLeave: HResult;
begin
  FDraggedObject := nil;
  Result := TryReleaseDropTarget;
  if FDropTargetHelper <> nil then
    FDropTargetHelper.DragLeave;
  FDropTargetHelper := nil;
end;

function TdxCustomShellBreadcrumbEdit.IDropTargetDragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
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
    FWasMouseRButtonPressed := grfKeyState and MK_RBUTTON <> 0;
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

function TdxCustomShellBreadcrumbEdit.Drop(const dataObj: IDataObject;
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
    end;
  end;
  FDraggedObject := nil;
  TryReleaseDropTarget;
  FDropTargetHelper := nil;
end;
//

procedure TdxCustomShellBreadcrumbEdit.UpdateContent;
begin
  Controller.UpdateContent;
end;

function TdxCustomShellBreadcrumbEdit.GetDependedControls: TcxShellDependedControls;
begin
  Result := FDependedControls;
end;

function TdxCustomShellBreadcrumbEdit.GetController: TdxShellBreadcrumbEditController;
begin
  Result := TdxShellBreadcrumbEditController(inherited Controller);
end;

function TdxCustomShellBreadcrumbEdit.GetProperties: TdxShellBreadcrumbEditProperties;
begin
  Result := TdxShellBreadcrumbEditProperties(inherited Properties);
end;

function TdxCustomShellBreadcrumbEdit.GetShellRoot: TcxCustomShellRoot;
begin
  Result := Properties.ShellOptions.Root;
end;

function TdxCustomShellBreadcrumbEdit.GetRoot: TdxShellBreadcrumbEditNode;
begin
  Result := TdxShellBreadcrumbEditNode(inherited Root);
end;

function TdxCustomShellBreadcrumbEdit.GetSelectedPidl: PItemIDList;
begin
  Result := Controller.SelectedPidl;
end;

function TdxCustomShellBreadcrumbEdit.GetSelectedPath: string;
begin
  Result := Controller.SelectedRealPath;
end;

procedure TdxCustomShellBreadcrumbEdit.InitControl;
begin
  if not IsLoading then
    DoHandleDependedInitialization;
end;

procedure TdxCustomShellBreadcrumbEdit.Loaded;
begin
  inherited Loaded;
  GroupIndex := FLoadedGroupIndex;
  if HandleAllocated then
    DoHandleDependedInitialization;
end;

procedure TdxCustomShellBreadcrumbEdit.SetProperties(AValue: TdxShellBreadcrumbEditProperties);
begin
  inherited Properties := AValue;
end;

procedure TdxCustomShellBreadcrumbEdit.SetSelectedPidl(AValue: PItemIDList);
var
  AHandle: HWND;
begin
  if HandleAllocated then
    AHandle := Handle
  else
    AHandle := 0;
  if dxIsPidlEnumerable(AHandle, AValue) then
    Controller.SelectedPidl := AValue;
end;

procedure TdxCustomShellBreadcrumbEdit.SetShellComboBox(AValue: TWinControl);
begin
  cxSetShellControl(Self, AValue, FShellComboBox);
end;

procedure TdxCustomShellBreadcrumbEdit.SetShellListView(AValue: TWinControl);
begin
  cxSetShellControl(Self, AValue, FShellListView);
end;

procedure TdxCustomShellBreadcrumbEdit.SetShellTreeView(AValue: TWinControl);
begin
  cxSetShellControl(Self, AValue, FShellTreeView);
end;

function TdxCustomShellBreadcrumbEdit.TryReleaseDropTarget: HResult;
begin
  Result := S_OK;
  if FCurrentDropTarget <> nil then
     Result := FCurrentDropTarget.DragLeave;
  FCurrentDropTarget := nil;
  DropTarget := nil;
end;

procedure TdxCustomShellBreadcrumbEdit.UpdateDropTarget(const APoint: TPoint; out ANew: Boolean);
var
  ANode: TdxShellBreadcrumbEditNode;
begin
  if not Properties.AllowDragDrop then
  begin
    FCurrentDropTarget := nil;
    Exit;
  end;
  ViewInfo.CalculateHitTest(ScreenToClient(APoint));
  if ViewInfo.HitTestInfo.ViewItem is TdxBreadcrumbEditNodeViewItem then
    ANode := TdxBreadcrumbEditNodeViewItem(ViewInfo.HitTestInfo.ViewItem).Node as TdxShellBreadcrumbEditNode
  else
    ANode := nil;
  if ANode = nil then
    TryReleaseDropTarget;
  ANew := (ANode <> nil) and ((ANode <> FDropTarget) or (FCurrentDropTarget = nil));
  if ANew then
  begin
    TryReleaseDropTarget;
    if (FDragSource = ANode) or (ANode.ShellFolder = nil) or Failed(ANode.ShellFolder.CreateViewObject(Handle, IDropTarget, FCurrentDropTarget)) then
      FCurrentDropTarget := nil;
  end;
  DropTarget := ANode;
end;

procedure TdxShellBreadcrumbEditPathEditorProperties.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TdxShellBreadcrumbEditPathEditorProperties then
    UseSystemRecentPaths := TdxShellBreadcrumbEditPathEditorProperties(Source).UseSystemRecentPaths;
end;

{ TdxShellBreadcrumbEditRoot }

function TdxShellBreadcrumbEditRoot.GetParentWindow: HWND;
begin
  if TdxCustomShellBreadcrumbEdit(Owner).HandleAllocated then
    Result := TdxCustomShellBreadcrumbEdit(Owner).Handle
  else
    Result := 0;
end;

{ TdxShellBreadcrumbEditPathEditor }

procedure TdxShellBreadcrumbEditPathEditor.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_HDROP) and not ((Properties.MaxLength > 0) and (Length(Text) >= Properties.MaxLength)) then
    cxPasteFileNameFromClipboard(Self)
  else
    inherited PasteFromClipboard;
end;

end.

