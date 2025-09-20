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

unit cxShellCommon;

{$I cxVer.inc}

interface

uses
  Types, MaskUtils,
  Windows, ActiveX, Classes, ComObj, Controls, Dialogs, Forms, Math, Messages,
  RTLConsts, Generics.Collections, Generics.Defaults, Menus, Graphics, KnownFolders,
  ShellApi, ShlObj, SyncObjs, SysUtils, dxCoreClasses, cxClasses, dxThreading;

resourcestring
  SShellDefaultNameStr = 'Name';
  SShellDefaultSizeStr = 'Size';
  SShellDefaultTypeStr = 'Type';
  SShellDefaultModifiedStr = 'Modified';

const
  cxShellObjectInternalAbsoluteVirtualPathPrefix = '::{9C211B58-E6F1-456A-9F22-7B3B418A7BB1}';
  cxShellObjectInternalRelativeVirtualPathPrefix = '::{63BE9ADB-E4B5-4623-96AA-57440B4EF5A8}';
  cxShellObjectInternalVirtualPathPrefixLength = 40;
  cxShellNormalItemOverlayIndex = -1;
  cxShellSharedItemOverlayIndex = 0;
  cxShellShortcutItemOverlayIndex = 1;
  SID_IImageList           = '{46EB5926-582E-4017-9FDF-E8998DAA0950}';
  IID_IImageList: TGUID    = SID_IImageList;
  CLSID_ShellItem: TGUID = (
    D1:$43826d1e; D2:$e718; D3:$42ee; D4:($bc,$55,$a1,$e2,$61,$c3,$7b,$fe));

  cxSFGAO_GHOSTED = $00008000; // Error in ShlObj.pas

// Interface declarations, that missed in D4 and D5 versions

(*$HPPEMIT '#include <OleIdl.h>'*)

// cxShell common classes
type
  ITEMIDLISTARRAY = array [0..MaxInt div SizeOf(PItemIDList) - 1] of PItemIDList;
  PITEMIDLISTARRAY = ^ITEMIDLISTARRAY;

  TcxBrowseFolder =(bfCustomPath, bfAltStartup, bfBitBucket,
    bfCommonDesktopDirectory, bfCommonDocuments, bfCommonFavorites,
    bfCommonPrograms, bfCommonStartMenu, bfCommonStartup, bfCommonTemplates,
    bfControls, bfDesktop, bfDesktopDirectory, bfDrives, bfPrinters,
    bfFavorites, bfFonts, bfHistory, bfMyMusic, bfMyPictures, bfNetHood,
    bfProfile, bfProgramFiles, bfPrograms, bfRecent, bfStartMenu, bfStartUp,
    bfTemplates, bfMyDocuments, bfNetwork);

  TcxDropEffect = (deCopy, deMove, deLink);
  TcxDropEffectSet = set of TcxDropEffect;

  TcxCustomItemProducer = class;
  TcxCustomShellRoot = class;
  TcxShellItemsInfoGatherer = class;
  TcxShellItemInfo = class;
  TcxShellDetails = class;

  IExtractImage = interface(IUnknown) // for internal use only
    [SID_IExtractImage]
    function GetLocation(pszPathBuffer: LPWSTR; cch: DWORD; var pdwPriority: DWORD;
      var prgSize: TSize; dwRecClrDepth: DWORD;
      var pdwFlags: DWORD): HRESULT; stdcall;
    function Extract(var phBmpThumbnail: HBITMAP): HRESULT; stdcall;
  end;

  IShellItemImageFactory = interface(IUnknown) // for internal use only
    [SID_IShellItemImageFactory]
    function GetImage(size: TSize; flags: UINT; out phbm: HBITMAP): HRESULT; stdcall;
  end;

  IcxDropSource = interface(IDropSource) // for internal use only
  ['{FCCB8EC5-ABB4-4256-B34C-25E3805EA046}']
  end;

  TcxDropSource=class(TInterfacedObject, IcxDropSource) // for internal use only
  private
    FOwner: TWinControl;
  protected
    function QueryContinueDrag(fEscapePressed: BOOL;
      grfKeyState: Longint): HResult; stdcall;
    function GiveFeedback(dwEffect: Longint): HResult; stdcall;
  public
    constructor Create(AOwner:TWinControl); virtual;
    property Owner:TWinControl read FOwner;
  end;

  { TcxShellOptions }

  TcxShellOptions = class(TPersistent)
  private
    FContextMenus: Boolean;
    FFileMask: string;
    FLock: Integer;
    FMasks: TStringList;
    FOwner: TWinControl;
    FShowFolders: Boolean;
    FShowToolTip: Boolean;
    FShowNonFolders: Boolean;
    FShowHidden: Boolean;
    FShowZipFilesWithFolders: Boolean;
    FTrackShellChanges: Boolean;
    FOnShowToolTipChanged: TNotifyEvent;
    procedure SetFileMask(const Value: string);
    procedure SetShowFolders(Value: Boolean);
    procedure SetShowHidden(Value: Boolean);
    procedure SetShowNonFolders(Value: Boolean);
    procedure SetShowToolTip(Value: Boolean);
    procedure SetShowZipFilesWithFolders(AValue: Boolean);
    procedure SetTrackShellChanges(AValue: Boolean);
    procedure UpdateMasks;
  protected
    procedure DoAssign(Source: TcxShellOptions); virtual;
    procedure DoNotifyUpdateContents; virtual;
    function GetDefaultShowToolTipValue: Boolean; virtual;
    function IsDefaultShowNonFolders: Boolean; virtual;
    procedure NotifyUpdateContents; virtual;
    property OnShowToolTipChanged: TNotifyEvent read FOnShowToolTipChanged
      write FOnShowToolTipChanged;
  public
    constructor Create(AOwner: TWinControl); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; // for internal use only
    procedure EndUpdate; // for internal use only
    function GetEnumFlags: Cardinal; // for internal use only
    function IsFileNameValid(const AName: string): Boolean; // for internal use only
    property FileMask: string read FFileMask write SetFileMask;
    property Owner: TWinControl read FOwner; // for internal use only
  published
    property ShowFolders: Boolean read FShowFolders write SetShowFolders default True;
    property ShowNonFolders: Boolean read FShowNonFolders write SetShowNonFolders default True;
    property ShowHidden: Boolean read FShowHidden write SetShowHidden default False;
    property ShowZipFilesWithFolders: Boolean read FShowZipFilesWithFolders write SetShowZipFilesWithFolders default True;
    property ContextMenus: Boolean read FContextMenus write FContextMenus default True;
    property TrackShellChanges: Boolean read FTrackShellChanges write SetTrackShellChanges default True;
    property ShowToolTip: Boolean read FShowToolTip write SetShowToolTip default True;
  end;

  TcxShellThumbnailOptions = class(TPersistent)
  private
    FHeight: Integer;
    FLock: Integer;
    FOwner: TPersistent;
    FShowThumbnails: Boolean;
    FWidth: Integer;
    FOnChange: TNotifyEvent;
    function GetSize: TSize;
    procedure SetHeight(const Value: Integer);
    procedure SetShowThumbnails(const Value: Boolean);
    procedure SetSize(const Value: TSize);
    procedure SetWidth(const Value: Integer);
  protected
    procedure Changed;
    procedure DoChange;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TPersistent); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property Size: TSize read GetSize write SetSize;
  published
    property Height: Integer read FHeight write SetHeight default 96;
    property ShowThumbnails: Boolean read FShowThumbnails write SetShowThumbnails default False;
    property Width: Integer read FWidth write SetWidth default 96;
  end;

  TcxDetailItem = record
    Text: string;
    Width: Integer;
    Alignment: TAlignment;
    ID: Integer;
    Flags: Cardinal;
    ShColumnID: SHCOLUMNID;
    Visible: Boolean;
    function IsShColumnIdEqual(const AShColumnID: SHCOLUMNID): Boolean;
  end;

  PcxDetailItem=^TcxDetailItem; // for internal use only

  TdxShellAddDetailItem = procedure (Sender: TcxShellDetails; var AItemInfo: TcxDetailItem) of object; // for internal use only

  TcxShellDetails = class
  private
    FItems: TList;
    FOnAddDetailItem: TdxShellAddDetailItem;
    function GetItems(Index: Integer): PcxDetailItem;
    function GetCount: Integer;
  protected
    property Items: TList read FItems;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ProcessDetails(ACharWidth: Integer; AShellFolder: IShellFolder;
      AFileSystem: Boolean; AFolderPidl: PItemIDList = nil); // for internal use only
    procedure Clear; // for internal use only
    function Add: PcxDetailItem; // for internal use only
    procedure Remove(Item: PcxDetailItem); // for internal use only
    property Item[Index:Integer]: PcxDetailItem read GetItems; default;
    property Count: Integer read GetCount;
    property OnAddDetailItem: TdxShellAddDetailItem read FOnAddDetailItem write FOnAddDetailItem; // for internal use only
  end;

  { TcxShellFolder }

  TcxShellFolderAttribute = (sfaGhosted, sfaHidden, sfaIsSlow, sfaLink,
    sfaReadOnly, sfaShare);
  TcxShellFolderAttributes = set of TcxShellFolderAttribute;

  TcxShellFolderCapability = (sfcCanCopy, sfcCanDelete, sfcCanLink, sfcCanMove,
    sfcCanRename, sfcDropTarget, sfcHasPropSheet);
  TcxShellFolderCapabilities = set of TcxShellFolderCapability;

  TcxShellFolderProperty = (sfpBrowsable, sfpCompressed, sfpEncrypted,
    sfpNewContent, sfpNonEnumerated, sfpRemovable);
  TcxShellFolderProperties = set of TcxShellFolderProperty;

  TcxShellFolderStorageCapability = (sfscFileSysAncestor, sfscFileSystem,
    sfscFolder, sfscLink, sfscReadOnly, sfscStorage, sfscStorageAncestor,
    sfscStream);
  TcxShellFolderStorageCapabilities = set of TcxShellFolderStorageCapability;

  TcxShellFolder = class
  private
    FAbsolutePIDL: PItemIDList;
    FAttributes: TcxShellFolderAttributes;
    FProperties: TcxShellFolderProperties;
    FCapabilities: TcxShellFolderCapabilities;
    FShellItemInfo: TcxShellItemInfo;
    FStorageCapabilities: TcxShellFolderStorageCapabilities;
    FIsAttributesValid: Boolean;
    FIsCapabilitiesValid: Boolean;
    FIsPropertiesValid: Boolean;
    FIsStorageCapabilitiesValid: Boolean;
    FIsLink: Boolean;
    FIsFolderLink: Boolean;
    FIsZipFolderLink: Boolean;
    FLock: TCriticalSection;
    FParentShellFolder: IShellFolder;
    FRelativePIDL: PItemIDList;
    function GetAbsolutePIDL: PItemIDList;
    function GetAttributes: TcxShellFolderAttributes;
    function GetCapabilities: TcxShellFolderCapabilities;
    function GetDisplayName: string;
    function GetIsFolder: Boolean;
    function GetIsZip: Boolean;
    function GetPathName: string;
    function GetProperties: TcxShellFolderProperties;
    function GetShellAttributes(ARequestedAttributes: LongWord): LongWord;
    function GetShellFolder: IShellFolder;
    function GetStorageCapabilities: TcxShellFolderStorageCapabilities;
    function GetSubFolders: Boolean;
    function HasShellAttribute(AAttribute: LongWord): Boolean; overload;
    function HasShellAttribute(AAttributes, AAttribute: LongWord): Boolean; overload;
    function GetEditingName: string;
    function GetRelativePIDL: PItemIDList;
  public
    constructor Create(AAbsolutePIDL: PItemIDList); overload;
    constructor Create(AShellItemInfo: TcxShellItemInfo); overload;
    destructor Destroy; override;

    function CreateAbsolutePidl: PItemIDList;

    property Attributes: TcxShellFolderAttributes read GetAttributes;
    property Capabilities: TcxShellFolderCapabilities read GetCapabilities;
    property IsFolder: Boolean read GetIsFolder;
    property IsFolderLink: Boolean read FIsFolderLink;
    property IsLink: Boolean read FIsLink;
    property IsZip: Boolean read GetIsZip;
    property IsZipFolderLink: Boolean read FIsZipFolderLink;
    property Properties: TcxShellFolderProperties read GetProperties;
    property StorageCapabilities: TcxShellFolderStorageCapabilities
      read GetStorageCapabilities;
    property SubFolders: Boolean read GetSubFolders;

    property AbsolutePIDL: PItemIDList read GetAbsolutePIDL; 
    property DisplayName: string read GetDisplayName;
    property EditingName: string read GetEditingName;
    property ParentShellFolder: IShellFolder read FParentShellFolder;
    property PathName: string read GetPathName;
    property RelativePIDL: PItemIDList read GetRelativePIDL;
    property ShellFolder: IShellFolder read GetShellFolder;
  end;

  TcxRootChangedEvent = procedure (Sender: TObject; Root: TcxCustomShellRoot) of object;

  TcxCustomShellRoot = class(TPersistent)
  private
    FAttributes: Cardinal;
    FBrowseFolder: TcxBrowseFolder;
    FCustomPath: string;
    FFolder: TcxShellFolder;
    FIsRootChecking: Boolean;
    FOwner: TPersistent;
    FParentWindow: HWND;
    FPidl: PItemIDList;
    FRootChangingCount: Integer;
    FShellFolder: IShellFolder;
    FUpdating: Boolean;
    FValid: Boolean;
    FOnFolderChanged: TcxRootChangedEvent;
    FOnSettingsChanged: TNotifyEvent;
    procedure SetBrowseFolder(Value: TcxBrowseFolder);
    procedure SetCustomPath(const Value: string);
    procedure SetPidl(const Value: PItemIDList);
    function GetCurrentPath: string;
    procedure UpdateFolder;
  protected
    procedure CheckRoot; virtual;
    procedure DoSettingsChanged;
    function GetParentWindow: HWND; virtual;
    procedure RootUpdated; virtual;
    property Owner: TPersistent read FOwner;
    property ParentWindow: HWND read GetParentWindow;
  public
    constructor Create(AOwner: TPersistent; AParentWindow: HWND); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Update(ARoot: TcxCustomShellRoot); // for internal use only

    property Attributes: Cardinal read FAttributes; // for internal use only
    property CurrentPath: string read GetCurrentPath;
    property Folder: TcxShellFolder read FFolder;
    property IsValid: Boolean read FValid; // for internal use only
    property Pidl: PItemIDList read FPidl write SetPidl;
    property ShellFolder: IShellFolder read FShellFolder;
    property OnFolderChanged: TcxRootChangedEvent read FOnFolderChanged
      write FOnFolderChanged; // for internal use only
    property OnSettingsChanged: TNotifyEvent read FOnSettingsChanged
      write FOnSettingsChanged; // for internal use only
  published
    property BrowseFolder: TcxBrowseFolder read FBrowseFolder
      write SetBrowseFolder default bfDesktop;
    property CustomPath: string read FCustomPath write SetCustomPath;
  end;

  TdxShellItem = record // for internal use only
    IconIndex: Integer;
    OpenIconIndex: Integer;
    OverlayIndex: Integer;
  end;

  TdxShellItemTask = class // for internal use only
  strict private
    FCanceled: Boolean;
    FItem: TcxShellItemInfo;
    FLock: TCriticalSection;
    //
    FIsFolder: Boolean;
    FAbsolutePidl: PItemIDList;
    FIconInfoUpdated: Boolean;
    //
    FItemInfo: TdxShellItem;
    procedure UpdateItem;
  protected
    procedure DoWork; virtual;
    procedure DoUpdateItem; virtual;
    property Canceled: Boolean read FCanceled;
    property IsFolder: Boolean read FIsFolder;
    property Item: TcxShellItemInfo read FItem;
    property AbsolutePidl: PItemIDList read FAbsolutePidl;
  public
    constructor Create(AItem: TcxShellItemInfo); virtual;
    destructor Destroy; override;
    procedure Execute; virtual;
    procedure Cancel;
  end;

  TdxShellItemHelper = class // for internal use only
  public
    class function GetIconIndexByPidl(const APidl: PItemIDList): Integer;
    class function GetOpenIconIndexByPidl(const APidl: PItemIDList): Integer;
    class function GetOverlayIndexByPidl(const APidl: PItemIDList): Integer;
    class function GetQuickIconIndexByName(const AName: string): Integer;
  end;

  TdxShellInfoTipState = (itsNone, itsLoaded, itsLoading);

  TcxShellItemInfo = class
  private type
    TcxShellItemDetail = record
      DisplayValue: string;
      Value: OleVariant;
    end;
  private
    FData: Pointer;
    FDetails: TStrings;
    FDetailsEx: TDictionary<Integer, TcxShellItemDetail>;
    FFolder: TcxShellFolder;
    FAbsolutePidl: PItemIDList;
    FHasSubfolder: Boolean;
    FIconIndex: Integer;
    FInfoTip: string;
    FInfoTipState: TdxShellInfoTipState;
    FInitialized: Boolean;
    FIsFilesystem: Boolean;
    FIsFolder: Boolean;
    FIsFolderLink: Boolean;
    FIsGhosted: Boolean;
    FIsLink: Boolean;
    FIsPinned: Boolean;
    FIsShare: Boolean;
    FIsSubitemsChecked: Boolean;
    FIsZipFolderLink: Boolean;
    FItemProducer: TcxCustomItemProducer;
    FLockUpdateItem: TCriticalSection;
    FLockUpdateDetails: TCriticalSection;
    FName: string;
    FOpenIconIndex: Integer;
    FOverlayIndex: Integer;
    Fpidl: PItemIDList;
    FPinIndex: Integer;
    FProcessed: Boolean;
    FRealItemPidl: PItemIDList;
    FThumbnailIndex: Integer;
    FThumbnailUpdated: Boolean;
    FThumbnailUpdating: Boolean;
    FUpdated: Boolean;
    FUpdating: Boolean;
    procedure AddDetails(AID: Integer; const ADisplayValue: string; const AValue: OleVariant);
    procedure CheckIsPinned;
    procedure CheckRealPidl;
    function GetItemIndex: Integer;
    procedure RebuildDetails(DetailsMap: TcxShellDetails);
    procedure UpdatePidl(AParentPidl, APidl: PItemIDList);
    function GetAbsolutePidl: PItemIDList;
    function GetIsRemovable: Boolean;
    function GetCanRename: Boolean;
    function GetIsDropTarget: Boolean;
    function GetIsZip: Boolean;
    function GetRealItemPidl: PItemIDList;
    procedure UpdateDetailItem(APDetailItem: PcxDetailItem);
  protected
    function CreateTask: TdxShellItemTask;
    function GetValueForSorting: OleVariant;
    function IsFullUpdated: Boolean;
    procedure UpdateInfoTip(const AInfoTip: string);
    property Updating: Boolean read FUpdating write FUpdating;
  public
    constructor Create(AItemProducer: TcxCustomItemProducer;
      AParentIFolder: IShellFolder; AParentPIDL, APIDL: PItemIDList;
      AFast: Boolean); virtual;
    destructor Destroy; override;
    procedure CheckUpdate(AShellFolder: IShellFolder; AFolderPidl: PItemIDList; AFast:Boolean);// deprecated;  // for internal use only
    procedure CheckInitialize(AIFolder: IShellFolder; APIDL: PItemIDList); // for internal use only
    function CreateAbsolutePidl: PItemIDList;
    procedure FetchDetails(Wnd: HWND; ShellFolder: IShellFolder; DetailsMap: TcxShellDetails); // for internal use only
    procedure CheckSubitems(AParentIFolder: IShellFolder;
      AEnumSettings: Cardinal); // for internal use only
    function GetOverlayIndex: Integer; // for internal use only
    function HasThumbnail: Boolean; // for internal use only
    procedure ResetDetails; // for internal use only
    procedure ResetThumbnail; // for internal use only
    procedure SetNewPidl(const APidl: PItemIDList); overload; // for internal use only
    procedure SetNewPidl(pFolder: IShellFolder; const AFolderPidl, APidl: PItemIDList); overload; // for internal use only
    procedure UpdateItem(AItemInfo: TdxShellItem); // for internal use only
    procedure UpdateThumbnail; // for internal use only

    procedure LockUpdate; // for internal use only
    procedure UnlockUpdate; // for internal use only

    property CanRename: Boolean read GetCanRename;
    property Data: Pointer read FData write FData; // for internal use only
    property Details: TStrings read FDetails;
    property Folder: TcxShellFolder read FFolder;
    property FullPIDL: PItemIDList read GetAbsolutePidl; 
    property HasSubfolder: Boolean read FHasSubfolder write FHasSubfolder;
    property IconIndex: Integer read FIconIndex;
    property InfoTip: string read FInfoTip; // for internal use only
    property InfoTipState: TdxShellInfoTipState read FInfoTipState write FInfoTipState; // for internal use only
    property Initialized: Boolean read FInitialized;
    property IsDropTarget: Boolean read GetIsDropTarget;
    property IsFilesystem: Boolean read FIsFilesystem;
    property IsFolder: Boolean read FIsFolder;
    property IsGhosted: Boolean read FIsGhosted;
    property IsLink: Boolean read FIsLink;
    property IsFolderLink: Boolean read FIsFolderLink;
    property IsPinned: Boolean read FIsPinned; // for internal use only
    property IsRemovable: Boolean read GetIsRemovable;
    property IsShare:Boolean read FIsShare;
    property IsSubitemsChecked: Boolean read FIsSubitemsChecked write FIsSubitemsChecked;
    property IsZip: Boolean read GetIsZip;
    property IsZipFolderLink: Boolean read FIsZipFolderLink;
    property ItemIndex: Integer read GetItemIndex;
    property ItemProducer: TcxCustomItemProducer read FItemProducer;
    property Name: string read FName;
    property OpenIconIndex: Integer read FOpenIconIndex;
    property OverlayIndex: Integer read FOverlayIndex;
    property pidl: PItemIDList read Fpidl;
    property Processed: Boolean read FProcessed write FProcessed; // for internal use only
    property RealItemPidl: PItemIDList read GetRealItemPidl; // for internal use only
    property ThumbnailIndex: Integer read FThumbnailIndex write FThumbnailIndex; // for internal use only
    property ThumbnailUpdated: Boolean read FThumbnailUpdated write FThumbnailUpdated; // for internal use only
    property Updated: Boolean read FUpdated write FUpdated; // for internal use only
  end;

  PcxShellItemInfo = TcxShellItemInfo; // for internal use only

  TFetchThread = class(TcxCustomThread) // for internal use only
  strict private
    FLockStopFetch: TCriticalSection;
    FProcessingLock: TCriticalSection;
    FTask: TdxShellItemTask;
    FTaskLock: TCriticalSection;
    FInfoGatherer: TcxShellItemsInfoGatherer;
  private
    FProcessingItem: TcxShellItemInfo;
    FCancelProcessItem: Boolean;

    procedure CancelTask;
    procedure LockStopFetch;
    procedure UnlockStopFetch;
  protected
    procedure Execute; override;
    //
    procedure LockItemProcessing;
    function TryLockItemProcessing: Boolean;
    procedure UnlockItemProcessing;
    //
    procedure LockTaskFinishing;
    procedure UnlockTaskFinishing;
  public
    constructor Create(AInfoGatherer: TcxShellItemsInfoGatherer);
    destructor Destroy; override;
  end;

  { TcxShellItemsInfoGatherer }

  TcxShellItemsInfoGatherer = class // for internal use only
  private
    FQueuePopulated: TcxEvent;
    FFetchQueue: TThreadList;
    FFetchThread: TFetchThread;
    FIsFetchQueueClearing: Boolean;
    FOwner: TWinControl;
    FProcessedItems: TThreadList;
    FStopFetchCount: Integer;
    procedure CreateFetchThread;
    procedure StartRequest;
  protected
    procedure CancelRequest(AItem: TcxShellItemInfo);
    procedure DestroyFetchThread;
    procedure LockFetchThread;
    procedure UnlockFetchThread;
    procedure WaitForRequest;
    property FetchQueue: TThreadList read FFetchQueue;
  public
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
    procedure ClearFetchQueue(AItemProducer: TcxCustomItemProducer);
    procedure ClearVisibleItems;
    procedure RequestItemInfo(AItem: TcxShellItemInfo);
    procedure RequestItems(AItems: TList);
    procedure ResumeFetch;
    procedure StopFetch;
    procedure UpdateRequest(AItems: TList);
    property ProcessedItems: TThreadList read FProcessedItems;
  end;

  TdxShellEnumCallback = reference to procedure(const APidl: PItemIDList); // for internal use
  TdxShellShouldStopEnumeration = reference to function: Boolean; // for internal use

  TdxShellEnumHelper = class   // for internal use
    class procedure DoEnumeration(AEnum: IEnumIDList; ADoCallBack: TdxShellEnumCallback;
      AShouldStopEnumeration: TdxShellShouldStopEnumeration);
  end;

  TdxShellInternalTask = class(TdxTask) // for internal use
  strict private
    FProducer: TcxCustomItemProducer;
  protected
    procedure DoExecute; virtual;
    procedure Execute; override;
    property Producer: TcxCustomItemProducer read FProducer;
  public
    constructor Create(AProducer: TcxCustomItemProducer);
    destructor Destroy; override;
  end;

  TcxCustomItemProducer = class
  strict private type

    TdxShellListViewGetInfoTipTask = class(TdxShellInternalTask)
    strict private
      FItem: TcxShellItemInfo;
      FInfoTip: string;
      FPidl: PItemIDList;
      FParentShellFolder: IShellFolder;
      FSucceeded: Boolean;
      procedure SyncComplete;
    protected
      //
      procedure Complete; override;
      procedure DoExecute; override;
    public
      constructor Create(AProducer: TcxCustomItemProducer; AItem: TcxShellItemInfo);
      destructor Destroy; override;

      property Item: TcxShellItemInfo read FItem;
      property InfoTip: string read FInfoTip;
    end;

  private
    FDetails: TcxShellDetails;
    FGetInfoTipItemTaskHandles: TList<THandle>;
    FFolderPidl: PItemIDList;
    FIsFavorites: Boolean;
    FIsLibraryFolder: Boolean;
    FIsQuickAccess: Boolean;
    FIsSearchFolder: Boolean;
    FItems: TdxFastList;
    FItemsLock: TMultiReadExclusiveWriteSynchronizer;
    FOwner: TWinControl;
    FShellFolder: IShellFolder;
    FSortColumn: Integer;
    FSortDescending: Boolean;
    FSortDetailItem: PcxDetailItem;
    procedure CancelInfoTipTask(AItem: TcxShellItemInfo);
    procedure CancelInfoTipTasks;
    function GetFolderPidl: PItemIDList;
    procedure InfoTipTaskCompleted;
    procedure SetFolderPidl(AValue: PItemIDList);
    function GetItemInfo(AIndex: Integer): TcxShellItemInfo;
  protected
    function CanAddFolder(AFolder: TcxShellFolder): Boolean; virtual;
    function CanCancelTask: Boolean; virtual;
    function CreateShellItemInfo(APidl: PItemIDList; AFast: Boolean): TcxShellItemInfo;
    procedure DoSlowInitialization(AItem: TcxShellItemInfo); virtual; 
    function DoCompareItems(AItem1, AItem2: TcxShellFolder; out ACompare: Integer): Boolean; virtual;
    procedure DoDestroy; virtual;
    procedure DoSort; virtual;
    function EnumerateItems: Boolean;
    procedure FetchItems(APreloadItems: Integer); virtual;
    function GetEnumerationObjectParentWindow: HWND; virtual;
    function GetEnumerator(out pEnum: IEnumIDList): Boolean;
    function GetEnumFlags: Cardinal; virtual; abstract;
    function GetFolderForEnumeration: IShellFolder; virtual;
    procedure GetInfoTip(AHandle: HWND; AItemIndex: Integer; var AInfoTip: string);
    function GetItemsInfoGatherer: TcxShellItemsInfoGatherer; virtual;
    function GetShowToolTip: Boolean; virtual; abstract;
    function GetSortfunction: TdxListSortCompareDelegate;
    function GetThumbnailIndex(AItem: TcxShellItemInfo): Integer; virtual;
    procedure Initialize(AIFolder: IShellFolder; AFolderPIDL: PItemIDList);
    procedure InitializeItem(AItem: TcxShellItemInfo); virtual;
    function InternalAddItem(APidl: PItemIDList): TcxShellItemInfo;
    function IsItemFullUpdated(AItem: TcxShellItemInfo): Boolean; virtual;
    procedure ItemImageUpdated(AItem: TcxShellItemInfo); virtual;
    procedure CheckForSubitems(AItem: TcxShellItemInfo); virtual;
    procedure ClearFetchQueue; virtual;
    function CreateTask(AItem: TcxShellItemInfo): TdxShellItemTask; virtual;
    procedure PopulateItems(pEnum: IEnumIDList);
    procedure RemoveItem(AItem: TcxShellItemInfo);
    function SlowInitializationDone(AItem: TcxShellItemInfo): Boolean; virtual; abstract;
    procedure UpdateItemInfoTip(AItem: TcxShellItemInfo; const AInfoTip: string);

    property IsFavorites: Boolean read FIsFavorites;
    property IsQuickAccess: Boolean read FIsQuickAccess;
    property IsLibraryFolder: Boolean read FIsLibraryFolder;
    property IsSearchFolder: Boolean read FIsSearchFolder;
    property ItemInfo[Index: Integer]: TcxShellItemInfo read GetItemInfo;
    property ItemsLock: TMultiReadExclusiveWriteSynchronizer read FItemsLock;
    property ShellFolder: IShellFolder read FShellFolder;
    property SortColumn: Integer read FSortColumn write FSortColumn;
    property SortDescending: Boolean read FSortDescending write FSortDescending;
    property FolderPidl: PItemIDList read GetFolderPidl write SetFolderPidl;
    property Owner: TWinControl read FOwner;
  public
    constructor Create(AOwner: TWinControl); virtual;
    destructor Destroy; override;
    procedure ProcessItems(AIFolder: IShellFolder; AFolderPIDL: PItemIDList;
      APreloadItemCount: Integer); virtual; // for internal use only
    procedure ProcessDetails(ShellFolder: IShellFolder; CharWidth: Integer); virtual; // for internal use only
    procedure FetchRequest(AItem: TcxShellItemInfo); // for internal use only
    procedure ClearItemDetails; // for internal use only
    procedure ClearItems; virtual; // for internal use only
    procedure LockRead; // for internal use only
    procedure LockWrite; // for internal use only
    procedure UnlockRead; // for internal use only
    procedure UnlockWrite; // for internal use only
    procedure SetItemsCount(Count: Integer); virtual; // for internal use only
    procedure NotifyRemoveItem(Index: Integer); virtual; // for internal use only
    procedure NotifyAddItem(Index: Integer); virtual; // for internal use only
    procedure DoGetInfoTip(AHandle: HWND; AItemIndex: Integer; AInfoTip: PChar; cch: Integer); // for internal use only
    function GetItemByPidl(APidl: PItemIDList): TcxShellItemInfo;
    function GetItemIndexByPidl(APidl: PItemIDList): Integer;
    procedure Sort; // for internal use only
    property Details: TcxShellDetails read FDetails; // for internal use only
    property Items: TdxFastList read FItems;
    property ItemsInfoGatherer: TcxShellItemsInfoGatherer read GetItemsInfoGatherer; // for internal use only
  end;

  TcxDragDropSettings = class(TPersistent)
  private
    FAllowDragObjects: Boolean;
    FDefaultDropEffect: TcxDropEffect;
    FDropEffect: TcxDropEffectSet;
    FScroll: Boolean;
    FOnChange: TNotifyEvent;
    function GetDefaultDropEffectAPI: Integer;
    function GetDropEffectAPI: DWORD;
    procedure SetAllowDragObjects(Value: Boolean);
  protected
    procedure Changed;
  public
    property DropEffectAPI: DWORD read GetDropEffectApi;
    property DefaultDropEffectAPI: Integer read GetDefaultDropEffectAPI;
    constructor Create;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property AllowDragObjects: Boolean read FAllowDragObjects
      write SetAllowDragObjects default True;
    property DefaultDropEffect: TcxDropEffect read FDefaultDropEffect
      write FDefaultDropEffect default deMove;
    property DropEffect: TcxDropEffectSet read FDropEffect write FDropEffect
      default [deCopy, deMove, deLink];
    property Scroll: Boolean read FScroll write FScroll stored False; // deprecated
  end;

  TShChangeNotifyEntry = packed record // for internal use only
    pidlPath: PItemIDList;
    bWatchSubtree: BOOL;
  end;

  DWORDITEMID=record // for internal use only
    cb: SHORT;
    dwItem1: DWORD;
    dwItem2: DWORD;
  end;

  PDWORDITEMID=^DWORDITEMID; // for internal use only

  PShChangeNotifyEntry = ^TShChangeNotifyEntry; // for internal use only

  TcxShellCustomContextMenu = class // for internal use only
  private
    FContextMenu: IContextMenu;
    FFirstInvokeShellCommandIndex: Cardinal;
    FMenu: HMenu;
  protected
    procedure DoAddDefaultShellItems;
    procedure DoPopup(APos: TPoint); virtual;
    procedure ExecuteMenuItemCommand(ACommandId: Cardinal); virtual;
    function GetContextMenuQueryFlags: Cardinal; virtual;
    function GetSite: IUnknown; virtual;
    function GetWindowHandle: THandle; virtual; abstract;
    function IsSameCommand(const ACommandId: Cardinal; const ACommandName: string): Boolean;
    procedure Populate; virtual; abstract;

    property Menu: HMenu read FMenu;
    property WindowHandle: THandle read GetWindowHandle;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddDefaultShellItems(AIShellFolder: IShellFolder); overload;
    procedure AddDefaultShellItems(AIShellFolder: IShellFolder; AItemPIDLList: TList); overload;
    procedure Popup(APos: TPoint); virtual;
  end;

function GetDesktopIShellFolder: IShellFolder;
function GetTextFromStrRet(var AStrRet: TStrRet; APIDL: PitemIDList): string;
function GetShellDetails(pFolder:IShellFolder;pidl:PItemIDList;out sd:IShellDetails):Hresult;
function HasSubItems(AParentIFolder: IShellFolder; AAbsolutePidl: PItemIDList; AEnumSettings: Cardinal): Boolean;
function cxGetFolderLocation(AWnd: HWND; ACSIDL: Integer; AToken: THandle;
  AReserwed: DWORD; var APIDL: PItemIDList): HRESULT;
function cxMalloc: IMalloc;
procedure DisplayContextMenu(AWnd: HWND; AIFolder: IShellFolder;
  AItemPIDLList: TList; const APos: TPoint);

{ Pidl Tools}

procedure dxFreeAndNilPidl(var APidl: PItemIDList);
function GetPidlItemsCount(APidl: PItemIDList): Integer;
function GetPidlSize(APidl: PItemIDList): Integer; // not take in account last 2 zero bytes!
function GetNextItemID(APidl: PItemIDList): PItemIDList;
function GetPidlCopy(APidl: PItemIDList): PItemIDList;
function GetLastPidlItem(APidl: PItemIDList): PItemIDList;
function GetPidlName(APIDL: PItemIDList): string;
function ConcatenatePidls(APidl1, APidl2: PItemIDList): PItemIDList;
procedure DisposePidl(APidl: PItemIDList);
function GetPidlParent(APidl: PItemIDList): PItemIDList;
function CreateEmptyPidl:PItemIDList;
function CreatePidlArrayFromList(AList: TList): PITEMIDLISTARRAY;
procedure DisposePidlArray(APidls: PITEMIDLISTARRAY);
function ExtractParticularPidl(APidl: PItemIDList): PItemIDList;
function EqualPIDLs(APIDL1, APIDL2: PItemIDList): Boolean;
function IsParentPidl(APIDL1, APIDL2: PItemIDList): Boolean;
function IsSubPath(APIDL1, APIDL2: PItemIDList): Boolean;

{ Unicode Tools }

procedure StrPLCopyW(Dest:PWideChar;Source:string;MaxLen:Cardinal);
function StrPasW(Source:PWideChar):string;
function StrLenW(Source:PWideChar):Cardinal;
function UpperCaseW(Source:string):string;
function LowerCaseW(Source:string):string;

procedure CheckShellRoot(ARoot: TcxCustomShellRoot);
function dxGetPidlDisplayName(AParentFolder: IShellFolder; APIDL: PItemIDList; AFlags: Cardinal): string;
function GetShellItemDisplayName(AIFolder: IShellFolder;
  APIDL: PItemIDList; ACheckIsFolder: Boolean): string;
function cxShellGetThreadSafeFileInfo(pszPath: PChar; dwFileAttributes: DWORD;
  var psfi: TSHFileInfo; cbFileInfo, uFlags: UINT): DWORD; stdcall;
function dxIsZipFile(APidl: PItemIDList): Boolean;

const
  DSM_SETCOUNT                    = CM_BASE + 315;
  DSM_NOTIFYUPDATE                = CM_BASE + 316;
  DSM_NOTIFYREMOVEITEM            = CM_BASE + 318;
  DSM_NOTIFYADDITEM               = CM_BASE + 319;
  DSM_NOTIFYUPDATECONTENTS        = CM_BASE + 320;
  DSM_SHELLCHANGENOTIFY           = CM_BASE + 321;
  DSM_DONAVIGATE                  = CM_BASE + 322;
  DSM_SYNCHRONIZEROOT             = CM_BASE + 323;
  DSM_SHELLTREECHANGENOTIFY       = CM_BASE + 324;
  DSM_SHELLTREERESTORECURRENTPATH = CM_BASE + 325;
  DSM_SYSTEMSHELLCHANGENOTIFY     = CM_BASE + 326;

  DSM_FIRST = DSM_SETCOUNT;
  DSM_LAST  = DSM_SYSTEMSHELLCHANGENOTIFY;

  PRELOAD_ITEMS_COUNT = 10;

  SHCNF_ACCEPT_INTERRUPTS =     $1;
  SHCNF_ACCEPT_NON_INTERRUPTS = $2;
  SHCNF_NO_PROXY =              $8000;

type
  TPidlList = array [0..1] of PItemIDList;
  PPidlList = ^TPidlList;

var
  SHChangeNotifyRegister: function (hwnd: HWND; dwFlags: DWORD; wEventMask: DWORD;
    uMsg: UINT; cItems: DWORD; lpItems: PShChangeNotifyEntry): Cardinal; stdcall;
  SHChangeNotifyUnregister: function (hNotify: Cardinal): Boolean; stdcall;
  SHChangeNotification_Lock: function (hChange: THandle; dwProcId: DWORD;
    var PPidls: PPidlList; var plEvent: Longint): THandle; stdcall;
  SHChangeNotification_UnLock: function (hLock: THandle): BOOL; stdcall;
  SHGetImageList: function (iImageList: Integer; const riid: TIID; out ppv): HResult; stdcall; 
  SHCreateIconImageList: function (iImageList: Integer; const riid: TIID; out ppv): HResult; stdcall;
  dxSHGetViewStatePropertyBag: function(pidl: PItemIDList; pszBagName: PChar; dwFlags: DWORD; const riid: TIID; out ppvOut): HRESULT; stdcall;
  dxSHDoDragDropWithPreferredEffect: function(AHandle: HWND; A1: DWORD; pidl: PItemIDList; A2: DWORD; A3: DWORD): HRESULT; stdcall;
  dxPropVariantToVariant: function(const ppropvar: PROPVARIANT; out pvar: OleVariant): HResult; stdcall;
  dxPSGetPropertyDescription: function(const propkey: TPropertyKey; const riid: TIID; out ppv): HResult; stdcall;
  dxPSPropertyBag_ReadStream: function (propBag: IPropertyBag; propName: LPCWSTR; out AStream: IStream): HResult; stdcall;
  dxPSPropertyBag_WriteStream: function (propBag: IPropertyBag; propName: LPCWSTR; AStream: IStream): HResult; stdcall;
  dxSHGetFolderTypeFromCanonicalName: function(AName: PChar; var AFolderTypeID: TGUID): HRESULT; stdcall;
  dxPathIsUNC: function(pszPath: LPCWSTR): BOOL; stdcall;
  dxPathIsRelative: function (pszPath: LPCWSTR): BOOL; stdcall;
  dxILLoadFromStreamEx: function(AStream: IStream; var APidl: PItemIDList): HResult; stdcall;
  dxIUnknown_SetSite: function(punk: IUnknown; punkSite: IUnknown): HResult; stdcall;
  dxIUnknown_GetClassID: function(punk: IUnknown; var pClassID: TGUID): HResult; stdcall;
  dxAssocQueryString: function (flags: DWORD; str: DWORD; pszAssoc, pszExtra: LPCWSTR; pszOut: LPWSTR; pcchOut: PDWORD): HRESULT; stdcall;
  dxAssocGetPerceivedType: function (pszExt: PChar; var ptype, pflag: DWORD; ppszType: Pointer): HRESULT; stdcall;

procedure dxShowInExplorer(const AFileName: UnicodeString);
function dxGetDesktopPidl(out APidl: PItemIDList): Boolean;
function dxGetFavoritesPidl(out APidl: PItemIDList): Boolean;
function dxGetQuickAccessPidl(out APidl: PItemIDList): Boolean;
function dxIsPidlEnumerable(AParentWindow: HWND; APidl: PItemIDList): Boolean;
function dxIsSearchFolderPidl(APidl: PItemIDList): Boolean;

implementation

uses
  Contnrs, ComCtrls, CommCtrl, Variants, PropSys,
  cxContainer, cxControls, cxEdit, dxUxTheme, dxCore, cxVariants, cxGeometry, StrUtils;

const
  dxThisUnitName = 'cxShellCommon';

type
  TdxShellCommonColumnIDs = (ccidItemNameDisplay, ccidSize, ccidItemType, ccidDateModified, ccidDateCreated,
    ccidDateAccessed, ccidFileAttributes, ccidOfflineStatus);

const
  CommonPKeys: array [TdxShellCommonColumnIDs] of SHCOLUMNID = (
      (
        fmtid: '{B725F130-47EF-101A-A5F1-02608C9EEBAC}';
        pid: $A;
      ), // PKey_ItemNameDisplay

      (
        fmtid: '{B725F130-47EF-101A-A5F1-02608C9EEBAC}';
        pid: $C;
      ), // PKey_Size

      (
        fmtid: '{28636AA6-953D-11D2-B5D6-00C04FD918D0}';
        pid: $B;
      ), // PKey_ItemType

      (
        fmtid: '{B725F130-47EF-101A-A5F1-02608C9EEBAC}';
        pid: $E;
      ), // PKey_DateModified

      (
        fmtid: '{B725F130-47EF-101A-A5F1-02608C9EEBAC}';
        pid: $F;
      ), // PKey_DateCreated

      (
        fmtid: '{B725F130-47EF-101A-A5F1-02608C9EEBAC}';
        pid: $10;
      ), // PKey_DateAccessed

      (
        fmtid: '{B725F130-47EF-101A-A5F1-02608C9EEBAC}';
        pid: $D;
      ), // PKey_FileAttributes

      (
        fmtid: '{6D24888F-4718-4BDA-AFED-EA0FB4386CD8}';
        pid: $64;
      ) // PKey_OfflineStatus
    );

type
  TcxContextMenuMessageWindow = class(TcxMessageWindow)
  private
    FContextMenu: IContextMenu2;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    property ContextMenu: IContextMenu2 read FContextMenu write FContextMenu;
  end;

  TSHGetPathFromIDList = function(APIDL: PItemIDList; APath: PChar): BOOL; stdcall;
  TSHGetPathFromIDListW = function(APIDL: PItemIDList; APath: PWideChar): BOOL; stdcall;

{$IFNDEF XE3}
  {$HPPEMIT 'DECLARE_DINTERFACE_TYPE(IPropertyDescription);'}
  IPropertyDescription = interface(IUnknown)
    [SID_IPropertyDescription]
    function GetPropertyKey(var pkey: TPropertyKey): HRESULT; stdcall;
    function GetCanonicalName(var ppszName: LPWSTR): HRESULT; stdcall;
    function GetPropertyType(var pvartype: TVarType): HRESULT; stdcall;
    function GetDisplayName(var ppszName: LPWSTR): HRESULT; stdcall;
    function GetEditInvitation(var ppszInvite: LPWSTR): HRESULT; stdcall;
    function GetTypeFlags(mask: TPropDescTypeFlags;
      var ppdtFlags: TPropDescTypeFlags): HRESULT; stdcall;
    function GetViewFlags(var ppdvFlags: TPropDescViewFlags): HRESULT; stdcall;
    function GetDefaultColumnWidth(var pcxChars: UINT): HRESULT; stdcall;
    function GetDisplayType(
      var pdisplaytype: TPropDescDisplayType): HRESULT; stdcall;
    function GetColumnState(var pcsFlags: DWORD): HRESULT; stdcall;
    function GetGroupingRange(var pgr: TPropDescGroupingRange): HRESULT; stdcall;
    function GetRelativeDescriptionType(
      var prdt: TPropDescRelativeDescriptionType): HRESULT; stdcall;
    function GetRelativeDescription(const propvar1: TPropVariant;
      propvar2: TPropVariant; var ppszDesc1: LPWSTR;
      var ppszDesc2: LPWSTR): HRESULT; stdcall;
    function GetSortDescription(
      var psd: TPropDescSortDescription): HRESULT; stdcall;
    function GetSortDescriptionLabel(fDescending: BOOL;
      var ppszDescription: LPWSTR): HRESULT; stdcall;
    function GetAggregationType(
      var paggtype: TPropDescAggregationType): HRESULT; stdcall;
    function GetConditionType(var pcontype: TPropDescConditionType;
      var popDefault: Integer): HRESULT; stdcall;
    function GetEnumTypeList(const riid: TIID; var ppv: Pointer): HRESULT; stdcall;
    function CoerceToCanonicalValue(var ppropvar: TPropVariant): HRESULT; stdcall;
    function FormatForDisplay(const propvar: TPropVariant;
      pdfFlags: TPropDescFormatFlags; var ppszDisplay: LPWSTR): HRESULT; stdcall;
    function IsValueCanonical(const propvar: TPropVariant): HRESULT; stdcall;
  end;
  {$EXTERNALSYM IPropertyDescription}
{$ENDIF}

var
  FComInitializationSucceeded: Boolean;
  FSysFileIconIndex: Integer = -1;
  FSysFolderIconIndex: Integer = -1;
  FSysFolderOpenIconIndex: Integer = -1;
  cxSHGetFolderLocation: function (wnd: HWND; nFolder: Integer; hToken: THandle;
    dwReserwed: DWORD; var ppidl: PItemIDList): HResult; stdcall;
  cxSHGetPathFromIDList: TSHGetPathFromIDList = nil;
  cxSHGetPathFromIDListW: TSHGetPathFromIDListW = nil;
  dxILFindLastID: function (pidl: PItemIDList): PItemIDList; stdcall;
  dxILIsEqual: function (pidl1: PItemIDList; pidl2: PItemIDList): BOOL; stdcall;
  dxILIsParent: function (pidl1: PItemIDList; pidl2: PItemIDList;
    fImmediate: BOOL): BOOL; stdcall;
  ShellLibrary: HMODULE = 0;
  ShlwapiLibrary: HMODULE = 0;
  PropSysLibrary: HMODULE = 0;
  FcxMalloc: IMalloc;
  FShellItemsInfoGatherers: TList;
  FShellLock: TCriticalSection;

function ShellItemCompareByColumnID(Item1, Item2: Pointer): Integer;
const
  R: array[Boolean] of Byte = (0, 1);
var
  AItemInfo1, AItemInfo2: TcxShellItemInfo;
  AItemProducer: TcxCustomItemProducer;
  AHResult: HResult;
  AColumnId: Integer;
begin
  AItemInfo1 := TcxShellItemInfo(Item1);
  AItemInfo2 := TcxShellItemInfo(Item2);
  AItemProducer := AItemInfo1.ItemProducer;
  if not AItemProducer.DoCompareItems(AItemInfo1.Folder, AItemInfo2.Folder, Result) then
  begin
    Result := R[AItemInfo2.IsFolder and not AItemInfo2.IsZip] - R[AItemInfo1.IsFolder and not AItemInfo1.IsZip];
    if Result = 0 then
    begin
      AColumnId := AItemProducer.FSortColumn;
      AHResult := AItemProducer.ShellFolder.CompareIDs(AColumnId, AItemInfo1.pidl, AItemInfo2.pidl);
      Result := SmallInt(AHResult);
    end;
    if AItemProducer.FSortDescending then
      Result := -Result;
  end;
end;

function ShellItemCompareByValue(Item1, Item2: Pointer): Integer;
const
  R: array[Boolean] of Byte = (0, 1);
var
  AItemInfo1, AItemInfo2: TcxShellItemInfo;
  AItemProducer: TcxCustomItemProducer;
  AValue1, AValue2: OleVariant;
begin
  AItemInfo1 := TcxShellItemInfo(Item1);
  AItemInfo2 := TcxShellItemInfo(Item2);
  AItemProducer := AItemInfo1.ItemProducer;
  if not AItemProducer.DoCompareItems(AItemInfo1.Folder, AItemInfo2.Folder, Result) then
  begin
    Result := R[AItemInfo2.IsFolder and not AItemInfo2.IsZip] - R[AItemInfo1.IsFolder and not AItemInfo1.IsZip];
    if Result = 0 then
    begin
      if AItemProducer.FSortColumn = 0 then
        Result := SmallInt(AItemProducer.ShellFolder.CompareIDs(0, AItemInfo1.pidl, AItemInfo2.pidl))
      else
      begin
        AValue1 := AItemInfo1.GetValueForSorting;
        AValue2 := AItemInfo2.GetValueForSorting;
        Result := VarCompare(AValue1, AValue2);
      end;
      if AItemProducer.FSortDescending then
        Result := -Result;
    end;
  end;
end;

procedure dxShowInExplorer(const AFileName: UnicodeString);
var
 IL: PItemIDList;
begin
  if AFileName <> '' then
  begin
    IL := ILCreateFromPathW(PWideChar(AFileName));
    if IL <> nil then
    try
      SHOpenFolderAndSelectItems(IL, 0, nil, 0);
    finally
      ILFree(IL);
    end;
  end;
end;

function GetSpecialFolderPidl(const AGuid: string; out APidl: PItemIDList): Boolean;
var
  AAttributes, AParsedCharCount: ULONG;
begin
  APidl := nil;
  Result := Succeeded(GetDesktopIShellFolder.ParseDisplayName(0, nil, PChar(Format('shell:::%s', [AGuid])),
    AParsedCharCount, APidl, AAttributes));
end;

function dxGetDesktopPidl(out APidl: PItemIDList): Boolean;
begin
  if IsWinVistaOrLater then
    Result := Succeeded(SHGetKnownFolderIDList(FOLDERID_Desktop, 0, 0, APidl))
  else
    Result := Succeeded(cxGetFolderLocation(0, CSIDL_DESKTOP, 0, 0, APidl));
end;

function dxGetFavoritesPidl(out APidl: PItemIDList): Boolean;
begin
  APidl := nil;
  Result := GetSpecialFolderPidl('{323CA680-C24D-4099-B94D-446DD2D7249E}', APidl);
end;

function dxGetQuickAccessPidl(out APidl: PItemIDList): Boolean;
begin
  APidl := nil;
  Result := GetSpecialFolderPidl('{679F85CB-0220-4080-B29B-5540CC05AAB6}', APidl);
end;

function CheckPidlEnumerable(AParentWindow: HWND; AValue: PItemIDList; out AFolder: IShellFolder; out AIsDesktop: Boolean): Boolean;
var
  pEnum: IEnumIDList;
  ADesktopPidl: PItemIDList;
begin
  ADesktopPidl := nil;
  AFolder := nil;
  ShowHourglassCursor;
  try
    Result := Succeeded(GetDesktopIShellFolder.BindToObject(AValue, nil, IID_IShellFolder, AFolder)) and
      Succeeded(AFolder.EnumObjects(AParentWindow, 0, pEnum)) and Assigned(pEnum) or
      dxGetDesktopPidl(ADesktopPidl) and EqualPIDLs(AValue, ADesktopPidl);
    AIsDesktop := Result and (ADesktopPidl <> nil);
    if AIsDesktop then
      AFolder := GetDesktopIShellFolder;
  finally
    DisposePidl(ADesktopPidl);
    HideHourglassCursor;
  end;
end;

function dxIsPidlEnumerable(AParentWindow: HWND; APidl: PItemIDList): Boolean;
var
  AIsDesktop: Boolean;
  AFolder: IShellFolder;
begin
  Result := CheckPidlEnumerable(AParentWindow, APidl, AFolder, AIsDesktop);
end;

function dxIsSearchFolder(AFolder: IShellFolder): Boolean;
const
  CLSID_DBFolder: TGUID = '{B2952B16-0E07-4E5A-B993-58C52CB94CAE}';
var
  AClassID: TGUID;
begin
  AClassID := GUID_NULL;
  Result := Assigned(dxIUnknown_GetClassID) and Succeeded(dxIUnknown_GetClassID(AFolder, AClassID)) and
   IsEqualGUID(AClassID, CLSID_DBFolder);
end;

function dxIsSearchFolderPidl(APidl: PItemIDList): Boolean;
var
  AFolder: IShellFolder;
begin
  Result := Succeeded(GetDesktopIShellFolder.BindToObject(APidl, nil, IID_IShellFolder, AFolder)) and
    dxIsSearchFolder(AFolder);
end;

procedure CheckShellRoot(ARoot: TcxCustomShellRoot);
begin
  if ARoot.ShellFolder = nil then
    ARoot.CheckRoot;
end;

function InternalGetPidlDisplayName(AFolder: IShellFolder;
  APIDL: PItemIDList; ANameType: DWORD): string;
var
  AStrRet: TStrRet;
begin
  if Succeeded(AFolder.GetDisplayNameOf(APIDL, ANameType, AStrRet)) then
    Result := GetTextFromStrRet(AStrRet, APIDL)
  else
    Result := '';
end;

function dxGetPidlDisplayName(AParentFolder: IShellFolder; APIDL: PItemIDList; AFlags: Cardinal): string;
begin
  Result := InternalGetPidlDisplayName(AParentFolder, APIDL, AFlags);
end;

function GetShellItemDisplayName(AIFolder: IShellFolder;
  APIDL: PItemIDList; ACheckIsFolder: Boolean): string;
begin
  Result := InternalGetPidlDisplayName(AIFolder, APIDL, SHGDN_INFOLDER);
end;

function cxShellGetThreadSafeFileInfo(pszPath: PChar; dwFileAttributes: DWORD;
  var psfi: TSHFileInfo; cbFileInfo, uFlags: UINT): DWORD;
begin
//  FShellLock.Enter;
  Result := SHGetFileInfo(pszPath, dwFileAttributes, psfi, cbFileInfo, uFlags);
//  FShellLock.Leave;
end;

function dxIsZipFile(APidl: PItemIDList): Boolean;
var
  AFileInfo: TSHFileInfo;
begin
  Result := (cxShellGetThreadSafeFileInfo(PChar(APidl), 0, AFileInfo, SizeOf(AFileInfo), SHGFI_PIDL or SHGFI_ATTRIBUTES) <> 0) and
    (AFileInfo.dwAttributes and (SFGAO_FOLDER or SFGAO_STREAM) = SFGAO_FOLDER or SFGAO_STREAM);
end;

function HasSubItems(AParentIFolder: IShellFolder; AAbsolutePidl: PItemIDList;
  AEnumSettings: Cardinal): Boolean;

  function HasAttributes(AAttributes: UINT): Boolean;
  var
    ATempAttributes: UINT;
    ATempPIDL: PItemIDList;
  begin
    ATempAttributes := AAttributes;
    ATempPIDL := GetLastPidlItem(AAbsolutePidl);
    AParentIFolder.GetAttributesOf(1, ATempPIDL, ATempAttributes);
    Result := ATempAttributes and AAttributes = AAttributes;
  end;

  function CheckLocalFolder(out AHasSubItems: Boolean): Boolean;
  var
    AAttributes, AParsedCharCount: ULONG;
    AFileSearchAttributes: Integer;
    ATempPIDL: PItemIDList;
    ASearchRec: TSearchRec;
    S: string;
  begin
    Result := False;
    S := GetPidlName(AAbsolutePidl);
    if (S = '')(* or (Pos('\\', S) = 1)*) then
      Exit;
    AAttributes := 0;
    GetDesktopIShellFolder.ParseDisplayName(0, nil, PWideChar(S),
      AParsedCharCount, ATempPIDL, AAttributes);
    if ATempPIDL = nil then
      Exit;
    try
      Result := True;
      AHasSubItems := False;

      AFileSearchAttributes := faReadOnly or faSysFile or faArchive;
      if AEnumSettings and SHCONTF_FOLDERS <> 0 then
        AFileSearchAttributes := AFileSearchAttributes or faDirectory;
      if AEnumSettings and SHCONTF_INCLUDEHIDDEN <> 0 then
        AFileSearchAttributes := AFileSearchAttributes or faHidden;

      if S[Length(S)] = PathDelim then
        Delete(S, Length(S), 1);

      if FindFirst(S + PathDelim + '*.*', AFileSearchAttributes, ASearchRec) = 0 then
      begin
        repeat
          AHasSubItems := (ASearchRec.Name <> '.') and (ASearchRec.Name <> '..');
        until (FindNext(ASearchRec) <> 0) or AHasSubItems;
        FindClose(ASearchRec);
      end;
    finally
      DisposePidl(ATempPIDL);
    end;
  end;

var
  ATempIFolder: IShellFolder;
  ATempPIDL: PItemIDList;
  AIEnum: IEnumIDList;
  AFetchedItemCount: Cardinal;
begin
  Result := HasAttributes(SFGAO_FOLDER) and Succeeded(AParentIFolder.BindToObject(
    GetLastPidlItem(AAbsolutePidl), nil, IShellFolder, ATempIFolder));
  if Result then
    if AEnumSettings and SHCONTF_NONFOLDERS = 0 then
      Result := HasAttributes(SFGAO_HASSUBFOLDER)
    else
      if not CheckLocalFolder(Result) then
      begin
        Result := HasAttributes(SFGAO_HASSUBFOLDER);
        if not Result and (ATempIFolder <> nil) and Succeeded(ATempIFolder.EnumObjects(0, AEnumSettings, AIEnum)) and
          Assigned(AIEnum) and (AIEnum.Next(1, ATempPIDL, AFetchedItemCount) = S_OK) then
          try
            Result := AFetchedItemCount = 1;
          finally
            DisposePidl(ATempPIDL);
          end;
      end;
end;

function GetDesktopIShellFolder: IShellFolder;
begin
  OleCheck(SHGetDesktopFolder(Result));
end;

function GetTextFromStrRet(var AStrRet: TStrRet; APIDL: PitemIDList): string;
var
  P: PChar;
  ATmp: PChar;
begin
  case AStrRet.uType of
    STRRET_CSTR:
      begin
        ATmp := PChar(dxAnsiStringToString(AStrRet.cStr));
        SetString(Result, ATmp, lstrlen(ATmp));
      end;
    STRRET_OFFSET:
      begin
        P := @APIDL.mkid.abID;
        Inc(P, AStrRet.uOffset - SizeOf(APIDL.mkid.cb));
        SetString(Result, P, APIDL.mkid.cb - AStrRet.uOffset);
      end;
    STRRET_WSTR:
      begin
        Result := StrPasW(AStrRet.pOleStr);
        cxMalloc.Free(AStrRet.pOleStr);
      end;
  end;
end;

function GetShellDetails(pFolder:IShellFolder;pidl:PItemIDList;out sd:IShellDetails):Hresult;
begin
  try
    Result := pFolder.QueryInterface(IID_IShellDetails, sd);
    if Result = S_OK then
       Exit;
    Result:=pFolder.GetUIObjectOf(0,0,pidl,IID_IShellDetails,nil,sd);
    if Result = S_OK then
       Exit;
    Result:=pFolder.CreateViewObject(0,IID_IShellDetails,sd);
    if Result = S_OK then
       Exit;
    Result:=pFolder.GetUIObjectOf(0,Integer(pidl<>nil)(*1*),pidl,IID_IShellDetails,nil,sd);
  finally
    if sd = nil then
      Result := E_NOINTERFACE;
  end;
end;

function cxGetFolderLocation(AWnd: HWND; ACSIDL: Integer; AToken: THandle;
  AReserwed: DWORD; var APIDL: PItemIDList): HRESULT;
begin
  if Win32MajorVersion < 5 then
    Result := SHGetSpecialFolderLocation(AWnd, ACSIDL, APIDL)
  else
    Result := cxSHGetFolderLocation(AWnd, ACSIDL, AToken, AReserwed, APIDL);
end;

function cxMalloc: IMalloc;
begin
  if FcxMalloc = nil then
    SHGetMalloc(FcxMalloc);
  Result := FcxMalloc;
end;

procedure TcxContextMenuMessageWindow.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_INITMENUPOPUP:
      begin
        ContextMenu.HandleMenuMsg(Message.Msg, Message.wParam, Message.lParam);
        Message.Result := 0;
      end;
    WM_DRAWITEM, WM_MEASUREITEM:
      begin
        ContextMenu.HandleMenuMsg(Message.Msg, Message.wParam, Message.lParam);
        Message.Result := 1;
      end;
    else
      inherited WndProc(Message);
  end;
end;

function CreateCallbackWnd(AContextMenu: IContextMenu2): TcxContextMenuMessageWindow;
begin
  Result := TcxContextMenuMessageWindow.Create;
  Result.ContextMenu := AContextMenu;
end;

type
  TcxShellContextMenuHelper = class(TcxShellCustomContextMenu)
  private
    FFolder: IShellFolder;
    FItemPIDLList: TList;
    FWnd: HWND;
  protected
    function GetWindowHandle: THandle; override;
    procedure Populate; override;
  public
    constructor Create(AWnd: HWND; AIFolder: IShellFolder;
      AItemPIDLList: TList);
  end;

{ TcxShellContextMenuHelper }

constructor TcxShellContextMenuHelper.Create(AWnd: HWND; AIFolder: IShellFolder;
  AItemPIDLList: TList);
begin
  inherited Create;
  FWnd := AWnd;
  FItemPIDLList := AItemPIDLList;
  FFolder := AIFolder;
end;

function TcxShellContextMenuHelper.GetWindowHandle: THandle;
begin
  Result := FWnd;
end;

procedure TcxShellContextMenuHelper.Populate;
begin
  AddDefaultShellItems(FFolder, FItemPIDLList);
end;

procedure DisplayContextMenu(AWnd: HWND; AIFolder: IShellFolder;
  AItemPIDLList: TList; const APos: TPoint);
begin
  if (AIFolder <> nil) and (AItemPIDLList.Count <> 0) then
    with TcxShellContextMenuHelper.Create(AWnd, AIFolder, AItemPIDLList) do
    begin
      Popup(APos);
      Free;
    end;
end;

function SysFileIconIndex: Integer;
var
  AFileInfo: TSHFileInfo;
begin
  if FSysFileIconIndex = -1 then
  begin
    cxShellGetThreadSafeFileInfo('C:\CXDUMMYFILE.TXT', FILE_ATTRIBUTE_NORMAL, AFileInfo,
      SizeOf(AFileInfo), SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
    FSysFileIconIndex := AFileInfo.iIcon;
  end;
  Result := FSysFileIconIndex;
end;

function SysFolderIconIndex: Integer;
var
  AFileInfo: TSHFileInfo;
begin
  if FSysFolderIconIndex = -1 then
  begin
    cxShellGetThreadSafeFileInfo('C:\CXDUMMYFOLDER', FILE_ATTRIBUTE_DIRECTORY, AFileInfo,
      SizeOf(AFileInfo), SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
    FSysFolderIconIndex := AFileInfo.iIcon;
  end;
  Result := FSysFolderIconIndex;
end;

function SysFolderOpenIconIndex: Integer;
var
  AFileInfo: TSHFileInfo;
begin
  if FSysFolderOpenIconIndex = -1 then
  begin
    cxShellGetThreadSafeFileInfo('C:\CXDUMMYFOLDER', FILE_ATTRIBUTE_DIRECTORY, AFileInfo,
      SizeOf(AFileInfo), SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES or SHGFI_OPENICON);
    FSysFolderOpenIconIndex := AFileInfo.iIcon;
  end;
  Result := FSysFolderOpenIconIndex;
end;

{ Unicode Tools }

function UpperCaseW(Source: string):string;
begin
  Result := AnsiUpperCase(Source);
end;

function LowerCaseW(Source:string):string;
begin
  Result := AnsiLowerCase(Source);
end;

function StrLenW(Source: PWideChar): Cardinal;
begin
  Result := StrLen(Source);
end;

function StrPasW(Source: PWideChar): string;
var
  StringLength:Cardinal;
begin
  StringLength:=StrLenW(Source);
  SetLength(Result,StringLength);
  CopyMemory(Pointer(Result),Source,StringLength*2);
end;

procedure StrPLCopyW(Dest:PWideChar;Source:string;MaxLen:Cardinal);
begin 
  lstrcpynw(Dest,PWideChar(Source),MaxLen);
end;

{ PidlTools}

function GetPidlParent(APidl: PItemIDList): PItemIDList;
var
  ASourceSize: Integer;
  APrevPidl: PItemIDList;
  AInitialPidl: PItemIDList;
begin
  Result := nil;
  ASourceSize := 0;
  AInitialPidl := APidl;
  APrevPidl := nil;
  if APidl <> nil then
  begin
    while APidl.mkid.cb <> 0 do
    begin
      Inc(ASourceSize, APidl.mkid.cb);
      APrevPidl := APidl;
      APidl := GetNextItemID(APidl);
    end;
    if ASourceSize > 0 then
      Dec(ASourceSize,APrevPidl.mkid.cb);
    Result := cxMalloc.Alloc(ASourceSize + 2);
    ZeroMemory(Result, ASourceSize + 2);
    CopyMemory(Result, AInitialPidl, ASourceSize);
  end;
end;

function CreateEmptyPidl:PItemIDList;
begin
  Result:=cxMalloc.Alloc(SizeOf(ITEMIDLIST));
  Result.mkid.cb:=0;
  Result.mkid.abID[0]:=0;
end;

function CreatePidlArrayFromList(AList: TList): PITEMIDLISTARRAY;
var
  I: Integer;
begin
  Result := nil;
  if AList = nil then
    Exit;
  Result := cxMalloc.Alloc(AList.Count * SizeOf(Pointer));
  for I := 0 to AList.Count - 1 do
    Result[I] := AList[I];
end;

procedure DisposePidlArray(APidls: PITEMIDLISTARRAY);
begin
  if APidls <> nil then
     cxMalloc.Free(APidls);
end;

function ExtractParticularPidl(APidl: PItemIDList): PItemIDList;
begin
  Result := nil;
  if (APidl <> nil) and (APidl.mkid.cb <> 0) then
  begin
    Result := cxMalloc.Alloc(APidl.mkid.cb + 2);
    ZeroMemory(Result, APidl.mkid.cb + 2);
    CopyMemory(Result, APidl, APidl.mkid.cb);
  end;
end;

function EqualPIDLs(APIDL1, APIDL2: PItemIDList): Boolean;
var
  L1, L2: Integer;
begin
  Result := APIDL1 = APIDL2;
  if not Result then
    if (APIDL1 = nil) or (APIDL2 = nil) then
      Exit
    else
      if Assigned(dxILIsEqual) then
        Result := dxILIsEqual(APIDL1, APIDL2)
      else
      begin
        L1 := GetPidlSize(APIDL1);
        L2 := GetPidlSize(APIDL2);
        Result := (L1 = L2) and CompareMem(APIDL1, APIDL2, L1);
      end;
end;

function IsParentPidl(APIDL1, APIDL2: PItemIDList): Boolean;
var
  ATempPidl: PItemIDList;
begin
 if Assigned(dxILIsParent) then
   Result := dxILIsParent(APIDL1, APIDL2, True)
 else
 begin
   ATempPidl := GetPidlParent(APIDL2);
   try
     Result := EqualPIDLs(APIDL1, ATempPidl);
   finally
     DisposePidl(ATempPidl);
   end;
 end;
end;

function IsSubPath(APIDL1, APIDL2: PItemIDList): Boolean; // TODO
var
  L1, L2: Integer;
begin
 if Assigned(dxILIsParent) then
   Result := dxILIsParent(APIDL1, APIDL2, False)
 else
 begin
    L1 := GetPidlSize(APIDL1);
    L2 := GetPidlSize(APIDL2);
    Result := (L1 = 0) or (L2 >= L1) and CompareMem(APIDL1, APIDL2, L1);
 end;
end;

function ConcatenatePidls(APidl1, APidl2: PItemIDList): PItemIDList;
var
  cb1,cb2:Integer;
begin
  if (APidl1 = nil) and (APidl2 = nil) then
    Result := nil
  else
    if APidl1 = nil then
      Result := GetPidlCopy(APidl2)
    else
      if APidl2 = nil then
        Result := GetPidlCopy(APidl1)
      else
      begin
        cb1 := GetPidlSize(APidl1);
        cb2 := GetPidlSize(APidl2) + 2;
        Result := cxMalloc.Alloc(cb1 + cb2);
        if Result <> nil then
        begin
          CopyMemory(Result, APidl1, cb1);
          CopyMemory(ShiftPointer(Result, cb1), APidl2, cb2);
        end;
      end;
end;

function GetPidlName(APIDL: PItemIDList): string;
var
  P: PChar;
  PW: PWideChar;
begin
  Result := '';
  if APIDL = nil then
    Exit;
  if not Assigned(cxSHGetPathFromIDListW) then
  begin
    GetMem(P, MAX_PATH + 1);
    try
      cxSHGetPathFromIDList(APIDL, P);
      Result := StrPas(P);
    finally
      FreeMem(P);
    end;
  end
  else
  begin
    GetMem(PW, (MAX_PATH + 1) * 2);
    try
      cxSHGetPathFromIDListW(APIDL, PW);
      Result := StrPasW(PW);
    finally
      FreeMem(PW);
    end;
  end;
end;

function GetLastPidlItem(APidl: PItemIDList): PItemIDList;
var
  ATempPidl: PItemIDList;
begin
  Result := APidl;
  if APidl <> nil then
  begin
    if Assigned(dxILFindLastID) then
      Result := dxILFindLastID(APidl)
    else
    begin
      ATempPidl := APidl;
      while ATempPidl.mkid.cb <> 0 do
      begin
        Result := ATempPidl;
        ATempPidl := GetNextItemID(ATempPidl);
      end;
    end;
  end;
end;

procedure DisposePidl(APidl: PItemIDList);
begin
  if APidl <> nil then
    cxMalloc.Free(APidl);
end;

function GetPidlCopy(APidl: PItemIDList): PItemIDList;
var
  ASize: Integer;
begin
  Result := nil;
  if APidl <> nil then
  begin
    ASize := GetPidlSize(APidl) + 2;
    Result := cxMalloc.Alloc(ASize);
    CopyMemory(Result, APidl, ASize);
  end;
end;

procedure dxFreeAndNilPidl(var APidl: PItemIDList);
var
  ATempPidl: PItemIDList;
begin
  ATempPidl := APidl;
  APidl := nil;
  DisposePidl(ATempPidl);
end;

function GetPidlItemsCount(APidl: PItemIDList): Integer;
begin
  Result := 0;
  if APidl <> nil then
    while APidl.mkid.cb <> 0 do
    begin
      Inc(Result);
      APidl := GetNextItemID(APidl);
      if Result > MAX_PATH then
      begin
        Result := -1;
        Break;
      end;
    end;
end;

function GetPidlSize(APidl: PItemIDList): Integer;
begin
  Result := 0;
  while (APidl <> nil) and (APidl.mkid.cb <> 0) do
  begin
    Inc(Result, APidl.mkid.cb);
    APidl := GetNextItemID(APidl);
  end;
end;

function GetNextItemID(APidl: PItemIDList): PItemIDList;
begin
  Result := nil;
  if (APidl <> nil) and (APidl.mkid.cb <> 0) then
     Result := PItemIDList(ShiftPointer(APidl, APidl.mkid.cb));
end;

procedure RegisterShellItemsInfoGatherer(AGatherer: TcxShellItemsInfoGatherer);
begin
  if FShellItemsInfoGatherers = nil then
    FShellItemsInfoGatherers := TList.Create;
  FShellItemsInfoGatherers.Add(AGatherer);
end;

procedure UnregisterShellItemsInfoGatherer(AGatherer: TcxShellItemsInfoGatherer);
begin
  FShellItemsInfoGatherers.Remove(AGatherer);
  if FShellItemsInfoGatherers.Count = 0 then
    FreeAndNil(FShellItemsInfoGatherers);
end;

{ TcxCustomShellRoot }

procedure TcxCustomShellRoot.CheckRoot;
const
  ACSIDLs: array[TcxBrowseFolder] of Integer = (
    CSIDL_DESKTOP, CSIDL_STARTUP, CSIDL_BITBUCKET, CSIDL_COMMON_DESKTOPDIRECTORY,
    CSIDL_COMMON_DOCUMENTS, CSIDL_COMMON_FAVORITES, CSIDL_COMMON_PROGRAMS,
    CSIDL_COMMON_STARTMENU, CSIDL_COMMON_STARTUP, CSIDL_COMMON_TEMPLATES,
    CSIDL_CONTROLS, CSIDL_DESKTOP, CSIDL_DESKTOPDIRECTORY, CSIDL_DRIVES,
    CSIDL_PRINTERS, CSIDL_FAVORITES, CSIDL_FONTS, CSIDL_HISTORY, CSIDL_MYMUSIC,
    CSIDL_MYPICTURES, CSIDL_NETHOOD, CSIDL_PROFILE, CSIDL_PROGRAM_FILES,
    CSIDL_PROGRAMS, CSIDL_RECENT, CSIDL_STARTMENU, CSIDL_STARTUP, CSIDL_TEMPLATES,
    CSIDL_PERSONAL, CSIDL_NETWORK);
var
  ABrowseFolder: TcxBrowseFolder;
  ADesktopFolder: IShellFolder;
  AParsedCharCount, AAttributes: Cardinal;
  ATempCustomPath: PWideChar;
  ATempPIDL: PItemIDList;
begin
  if FIsRootChecking then
    Exit;

  ADesktopFolder := GetDesktopIShellFolder;
  ATempPIDL := nil;
  FValid := False;
  FShellFolder := nil;
  if FPidl <> nil then
    dxFreeAndNilPidl(FPidl);

  ABrowseFolder := BrowseFolder;
  if (ABrowseFolder = bfCustomPath) and not DirectoryExists(CustomPath) then
    ABrowseFolder := bfDesktop;

  FIsRootChecking := True;
  try
    try
      if ABrowseFolder = bfCustomPath then
      begin
        ATempCustomPath := PWideChar(CustomPath);
        OleCheck(ADesktopFolder.ParseDisplayName(ParentWindow, nil,
          ATempCustomPath, AParsedCharCount, ATempPIDL, AAttributes));
      end
      else
        OleCheck(cxGetFolderLocation(ParentWindow, ACSIDLs[ABrowseFolder], 0, 0, ATempPIDL));
    except
      on E: Exception do
        if FRootChangingCount > 0 then
          raise EcxEditError.Create(E.Message)
        else
        begin
          RootUpdated;
          Exit;
        end;
    end;
    if ABrowseFolder = bfDesktop then
    begin
      FShellFolder := ADesktopFolder;
      FPidl := GetPidlCopy(ATempPIDL);
      FValid := True;
      FAttributes := SFGAO_FILESYSTEM;
      RootUpdated;
    end
    else
      Pidl := ATempPIDL;
  finally
    FIsRootChecking := False;
    if ATempPIDL <> nil then
      DisposePidl(ATempPIDL);
  end;
end;

procedure TcxCustomShellRoot.DoSettingsChanged;
begin
  if not FUpdating and Assigned(FOnSettingsChanged) then
    FOnSettingsChanged(Self);
end;

function TcxCustomShellRoot.GetParentWindow: HWND;
begin
  Result := FParentWindow;
end;

procedure TcxCustomShellRoot.RootUpdated;
begin
  UpdateFolder;
  if Assigned(FOnFolderChanged) then
     FOnFolderChanged(FOwner, Self);
end;

procedure TcxCustomShellRoot.SetPidl(const Value: PItemIDList);
var
  AFolder: IShellFolder;
  AIsDesktop: Boolean;
begin
  if (Value <> nil) and CheckPidlEnumerable(ParentWindow, Value, AFolder, AIsDesktop) then
  begin
    if FPidl <> nil then
    begin
      dxFreeAndNilPidl(FPidl);
      FValid := False;
      FAttributes := 0;
    end;
    FShellFolder := AFolder;
    FPidl := GetPidlCopy(Value);
    FValid := True;
    if AIsDesktop then
      FAttributes := SFGAO_FILESYSTEM
    else
    begin
      FAttributes := 0;
      if Failed(GetDesktopIShellFolder.GetAttributesOf(1, FPidl, FAttributes)) then
         FAttributes := 0;
    end;
    RootUpdated;
  end;
end;

constructor TcxCustomShellRoot.Create(AOwner: TPersistent; AParentWindow: HWND);
begin
  inherited Create;
  FOwner := AOwner;
  FParentWindow := AParentWindow;
  FBrowseFolder := bfDesktop;
  FCustomPath := '';
  FShellFolder := nil;
  FPidl := nil;
end;

destructor TcxCustomShellRoot.Destroy;
begin
  FreeAndNil(FFolder);
  FShellFolder := nil;
  dxFreeAndNilPidl(FPidl);
  inherited;
end;

procedure TcxCustomShellRoot.Assign(Source: TPersistent);
var
  APrevBrowseFolder: TcxBrowseFolder;
  APrevCustomPath: string;
begin
  if Source is TcxCustomShellRoot then
  begin
    APrevBrowseFolder := FBrowseFolder;
    APrevCustomPath := FCustomPath;
    try
      FBrowseFolder := TcxCustomShellRoot(Source).FBrowseFolder;
      FCustomPath := TcxCustomShellRoot(Source).FCustomPath;
      Inc(Self.FRootChangingCount);
      try
        CheckRoot;
      finally
        Dec(FRootChangingCount);
      end;
      DoSettingsChanged;
    except
      FBrowseFolder := APrevBrowseFolder;
      FCustomPath := APrevCustomPath;
      CheckRoot;
      raise;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TcxCustomShellRoot.Update(ARoot: TcxCustomShellRoot);
begin
  if FUpdating then
    Exit;
  FUpdating := True;
  try
    Assign(ARoot);
  finally
    FUpdating := False;
  end;
end;

procedure TcxCustomShellRoot.SetBrowseFolder(Value: TcxBrowseFolder);
var
  APrevBrowseFolder: TcxBrowseFolder;
begin
  APrevBrowseFolder := FBrowseFolder;
  try
    Inc(FRootChangingCount);
    try
      if FBrowseFolder <> Value then
      begin
        FBrowseFolder := Value;
        CheckRoot;
      end
      else
        if Pidl = nil then
          CheckRoot;
    finally
      Dec(FRootChangingCount);
    end;
    DoSettingsChanged;
  except
    FBrowseFolder := APrevBrowseFolder;
    CheckRoot;
    raise;
  end;
end;

procedure TcxCustomShellRoot.SetCustomPath(const Value: string);
var
  APrevCustomPath: string;
begin
  APrevCustomPath := FCustomPath;
  try
    FCustomPath := Value;
    Inc(FRootChangingCount);
    try
      if BrowseFolder = bfCustomPath then
        CheckRoot;
    finally
      Dec(FRootChangingCount);
    end;
    DoSettingsChanged;
  except
    FCustomPath := APrevCustomPath;
    CheckRoot;
    raise;
  end;
end;

function TcxCustomShellRoot.GetCurrentPath: string;
var
  AStrName: TStrRet;
begin
  Result := '';
  if (Pidl <> nil) and
    Succeeded(GetDesktopIShellFolder.GetDisplayNameOf(Pidl, SHGDN_NORMAL or SHGDN_FORPARSING, AStrName)) then
    Result := GetTextFromStrRet(AStrName, Pidl);
end;

procedure TcxCustomShellRoot.UpdateFolder;
begin
  FreeAndNil(FFolder);
  FFolder := TcxShellFolder.Create(PIDL);
end;

{ TdxShellItemTask }

procedure TdxShellItemTask.Cancel;
begin
  FLock.Enter;
  try
    FCanceled := True;
  finally
    FLock.Leave;
  end;
end;

constructor TdxShellItemTask.Create(AItem: TcxShellItemInfo);
begin
  inherited Create;
  FItem := AItem;
  FLock := TCriticalSection.Create;
  FIsFolder := AItem.IsFolder;
  FAbsolutePidl := AItem.CreateAbsolutePidl;
  FIconInfoUpdated := AItem.Updated;
end;

destructor TdxShellItemTask.Destroy;
begin
  dxFreeAndNilPidl(FAbsolutePidl);
  FreeAndNil(FLock);
  inherited Destroy;
end;

procedure TdxShellItemTask.Execute;
begin
  DoWork;
  UpdateItem;
end;

procedure TdxShellItemTask.DoUpdateItem; 
begin
  if not FIconInfoUpdated then
    Item.UpdateItem(FItemInfo);
end;

procedure TdxShellItemTask.DoWork;
begin
  if not FIconInfoUpdated then
  begin
    FItemInfo.IconIndex := TdxShellItemHelper.GetIconIndexByPidl(FAbsolutePidl);
    if FIsFolder then
      FItemInfo.OpenIconIndex := TdxShellItemHelper.GetOpenIconIndexByPidl(FAbsolutePidl);
    FItemInfo.OverlayIndex := TdxShellItemHelper.GetOverlayIndexByPidl(FAbsolutePidl);
  end;
end;

procedure TdxShellItemTask.UpdateItem;
begin
  FLock.Enter;
  try
    if not Canceled then
      DoUpdateItem;
  finally
    FLock.Leave;
  end;
end;

class procedure TdxShellEnumHelper.DoEnumeration(AEnum: IEnumIDList; ADoCallBack: TdxShellEnumCallback;
  AShouldStopEnumeration: TdxShellShouldStopEnumeration);
var
  ACeltFetched: Cardinal;
  AHResult: HRESULT;
  APidl: PItemIDList;
{$IFDEF CPUX64}
  ASavedExceptionMask: TArithmeticExceptionMask;
{$ENDIF}
begin
{$IFDEF CPUX64}
  if IsWin11OrLater then
  begin
    ASavedExceptionMask := GetExceptionMask;
    SetExceptionMask(exAllArithmeticExceptions); 
  end;
{$ENDIF}
  try
    repeat
      if AShouldStopEnumeration then
        Break;
      AHResult := AEnum.Next(1, APidl, ACeltFetched);
      if AHResult = E_INVALIDARG then
      begin
        if AShouldStopEnumeration then
          Break;
        AHResult := AEnum.Next(1, APidl, ACeltFetched);
      end;

      if Succeeded(AHResult) and (AHResult <> S_FALSE) and (ACeltFetched > 0) and (APidl <> nil) then
      begin
        if AShouldStopEnumeration then
        begin
          DisposePidl(APidl);
          Break;
        end
        else
          ADoCallback(APidl);
      end
      else
        Break;
    until False;
  finally
  {$IFDEF CPUX64}
    if IsWin11OrLater then
      SetExceptionMask(ASavedExceptionMask);
  {$ENDIF}
  end;
end;

{ TcxCustomItemProducer }

procedure TcxCustomItemProducer.ClearItemDetails;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    ItemInfo[I].Details.Clear;
end;

procedure TcxCustomItemProducer.ClearItems;

  (*function HasItems: Boolean;
  begin
    LockRead;
    try
      Result := Items.Count <> 0;
    finally
      UnlockRead;
    end;
  end;*)

var
  I: Integer;
begin
  CancelInfoTipTasks;
  //if HasItems then
  begin
    ClearFetchQueue;
    for I := 0 to Items.Count - 1 do
      ItemInfo[I].Free;
    Items.Clear;
  end;
  FShellFolder := nil;
  FolderPidl := nil;
end;

constructor TcxCustomItemProducer.Create(AOwner: TWinControl);
begin
  inherited Create;
  FOwner := AOwner;
  FDetails := TcxShellDetails.Create;
  FItems := TdxFastList.Create;
  FItemsLock := TMultiReadExclusiveWriteSynchronizer.Create;
  FGetInfoTipItemTaskHandles := TList<THandle>.Create;
end;

destructor TcxCustomItemProducer.Destroy;
begin
  DoDestroy;
  inherited Destroy;
end;

function TcxCustomItemProducer.CreateShellItemInfo(
  APidl: PItemIDList; AFast: Boolean): TcxShellItemInfo;
begin
  Result := TcxShellItemInfo.Create(Self, ShellFolder, FFolderPidl, APidl, AFast);
end;

procedure TcxCustomItemProducer.LockRead;
begin
  ItemsLock.BeginRead;
end;

procedure TcxCustomItemProducer.LockWrite;
begin
  ItemsLock.BeginWrite;
end;

procedure TcxCustomItemProducer.ProcessItems(AIFolder: IShellFolder;
  AFolderPIDL: PItemIDList; APreloadItemCount: Integer);
begin
  Initialize(AIFolder, AFolderPIDL);
  ProcessDetails(ShellFolder, APreloadItemCount);
  FetchItems(APreloadItemCount);
end;

procedure TcxCustomItemProducer.SetItemsCount(Count: Integer);
begin
  if Owner.HandleAllocated then
     SendMessage(Owner.Handle, DSM_SETCOUNT, Count, 0);
end;

procedure TcxCustomItemProducer.UnlockRead;
begin
  ItemsLock.EndRead;
end;

procedure TcxCustomItemProducer.UnlockWrite;
begin
  ItemsLock.EndWrite;
end;

procedure TcxCustomItemProducer.NotifyRemoveItem(Index: Integer);
begin
  if Owner.HandleAllocated then
     SendMessage(Owner.Handle, DSM_NOTIFYREMOVEITEM, Index, 0);
end;

procedure TcxCustomItemProducer.NotifyAddItem(Index: Integer);
begin
  if Owner.HandleAllocated then
     SendMessage(Owner.Handle, DSM_NOTIFYADDITEM, Index, 0);
end;

function TcxCustomItemProducer.GetFolderForEnumeration: IShellFolder;
begin
  Result := ShellFolder;
end;

procedure TcxCustomItemProducer.GetInfoTip(AHandle: HWND; AItemIndex: Integer; var AInfoTip: string);
var
  AHint: PChar;
begin
  AHint := AllocMem(1024);
  try
    DoGetInfoTip(AHandle, AItemIndex, AHint, 1024);
    if (AInfoTip <> '') and (AInfoTip <> AHint) then
      AInfoTip := AInfoTip + IfThen(AHint <> '', dxCRLF + AHint)
    else
      AInfoTip := AHint;
  finally
    FreeMem(AHint);
  end;
end;

function TcxCustomItemProducer.GetItemsInfoGatherer: TcxShellItemsInfoGatherer;
begin
  Result := nil;
end;

function QuickAccessItemCompare(Item1, Item2: Pointer): Integer;

  function CompareByPinIndex(AItemInfo1, AItemInfo2: TcxShellItemInfo): Integer;
  begin
    if AItemInfo2.FPinIndex > AItemInfo1.FPinIndex then
      Result := -1
    else
      if AItemInfo2.FPinIndex < AItemInfo1.FPinIndex then
        Result := 1
      else
        Result := 0;
  end;

const
  R: array[Boolean] of Byte = (0, 1);
var
  AItemInfo1, AItemInfo2: TcxShellItemInfo;
  AItemProducer: TcxCustomItemProducer;
begin
  AItemInfo1 := TcxShellItemInfo(Item1);
  AItemInfo2 := TcxShellItemInfo(Item2);
  AItemProducer := AItemInfo1.ItemProducer;
  if not AItemProducer.DoCompareItems(AItemInfo1.Folder, AItemInfo2.Folder, Result) then
  begin
    Result := R[AItemInfo2.IsPinned] - R[AItemInfo1.IsPinned];
    if Result = 0 then
      if AItemInfo1.IsPinned then
        Result := CompareByPinIndex(AItemInfo1, AItemInfo2)
      else
      begin
        Result := R[AItemInfo2.IsFolder and not AItemInfo2.IsZip] - R[AItemInfo1.IsFolder and not AItemInfo1.IsZip];
        if Result = 0 then
          if AItemInfo1.IsFolder and not AItemInfo1.IsZip then
            Result := AnsiCompareText(AItemInfo1.Name, AItemInfo2.Name)
          else
            Result := CompareByPinIndex(AItemInfo1, AItemInfo2);
      end;
  end;
end;

function TcxCustomItemProducer.GetSortfunction: TdxListSortCompareDelegate;

  function CanCompareByColumnID: Boolean;
  var
    AID: TdxShellCommonColumnIDs;
  begin
    Result := False;
    for AID := Low(TdxShellCommonColumnIDs) to High(TdxShellCommonColumnIDs) do
      if FSortDetailItem.IsShColumnIdEqual(CommonPKeys[AID]) then
      begin
        Result := True;
        Exit;
      end;
  end;

var
  I: Integer;
begin
  if FIsQuickAccess then
    Result := QuickAccessItemCompare
  else
  begin
    for I := 0 to Details.Count - 1 do
      if Details[I].ID = FSortColumn then
      begin
        FSortDetailItem := Details[I];
        Break;
      end;
    if not IsWinSevenOrLater or (Details.Count = 0) or CanCompareByColumnID and not FIsLibraryFolder then
      Result := ShellItemCompareByColumnID
    else
      Result := ShellItemCompareByValue;
  end;
end;

function TcxCustomItemProducer.GetThumbnailIndex(AItem: TcxShellItemInfo): Integer;
begin
  Result := -1;
end;

procedure TcxCustomItemProducer.Initialize(AIFolder: IShellFolder;
  AFolderPIDL: PItemIDList);

  function IsLibraryFolder(const APidl: PItemIDList): Boolean;
  var
    AShellItem: IShellItem;
    AShellLibrary: IShellLibrary;
  begin
    Result := Succeeded(SHCreateItemFromIDList(APidl, IID_IShellItem, AShellItem)) and
      Succeeded(SHLoadLibraryFromItem(AShellItem, 0, IID_IShellLibrary, AShellLibrary));
  end;

  function IsQuickAccess(const APidl: PItemIDList): Boolean;
  var
    ATempPidl: PItemIDList;
  begin
    try
      Result := dxGetQuickAccessPidl(ATempPidl) and EqualPIDLs(ATempPidl, APidl);
    finally
      DisposePidl(ATempPidl);
    end;
  end;

  function IsFavorites(const APidl: PItemIDList): Boolean;
  var
    ATempPidl: PItemIDList;
  begin
    try
      Result := dxGetFavoritesPidl(ATempPidl) and EqualPIDLs(ATempPidl, APidl);
    finally
      DisposePidl(ATempPidl);
    end;
  end;

begin
  FShellFolder := AIFolder;
  FolderPidl := AFolderPIDL;
  FIsLibraryFolder := IsWinSevenOrLater and IsLibraryFolder(AFolderPIDL);
  if  FIsLibraryFolder then
    Exit;
  FIsQuickAccess := IsWin10OrLater and IsQuickAccess(AFolderPIDL);
  if FIsQuickAccess then
    Exit;
  FIsSearchFolder := dxIsSearchFolder(AIFolder);
  if FIsSearchFolder then
    Exit;
  FIsFavorites := IsWinSevenOrLater and IsFavorites(AFolderPIDL);
  if FIsFavorites then
    Exit;
end;

procedure TcxCustomItemProducer.InitializeItem(AItem: TcxShellItemInfo);
begin
  AItem.CheckUpdate(ShellFolder, FolderPidl, False);
end;

function TcxCustomItemProducer.InternalAddItem(APidl: PItemIDList): TcxShellItemInfo;
begin
  try
    Result := CreateShellItemInfo(APidl, False);
    if (Result.Name <> '') and CanAddFolder(Result.Folder) then
    begin
      if FIsQuickAccess then
        Result.FPinIndex := Items.Add(Result)
      else
        Items.Add(Result);
    end
    else
      FreeAndNil(Result);
  finally
    DisposePidl(APidl);
  end;
end;

function TcxCustomItemProducer.IsItemFullUpdated(AItem: TcxShellItemInfo): Boolean;
begin
  Result := SlowInitializationDone(AItem);
end;

procedure TcxCustomItemProducer.ItemImageUpdated(AItem: TcxShellItemInfo);
begin
end;

function TcxCustomItemProducer.CanAddFolder(AFolder: TcxShellFolder): Boolean;
begin
  Result := True;
end;

function TcxCustomItemProducer.CanCancelTask: Boolean;
begin
  Result := False;
end;

function TcxCustomItemProducer.DoCompareItems(AItem1, AItem2: TcxShellFolder;
  out ACompare: Integer): Boolean;
begin
  Result := False;
end;

procedure TcxCustomItemProducer.DoDestroy;
begin
  ClearItems;
  FreeAndNil(FGetInfoTipItemTaskHandles);
  FreeAndNil(FDetails);
  FreeAndNil(FItems);
  FreeAndNil(FItemsLock);
end;

procedure TcxCustomItemProducer.DoSlowInitialization(AItem: TcxShellItemInfo);
begin
end;

procedure TcxCustomItemProducer.DoSort;
begin
  Items.SortList(GetSortfunction());
end;

function TcxCustomItemProducer.EnumerateItems: Boolean;
var
  pEnum: IEnumIDList;
begin
  Result := GetEnumerator(pEnum);
  if Result then
  begin
    PopulateItems(pEnum);
    Sort;
  end;
end;

procedure TcxCustomItemProducer.FetchItems(APreloadItems: Integer);

  procedure InitializeItems;
  var
    I: Integer;
  begin
    for I := 0 to Min(APreloadItems - 1, Items.Count - 1) do
      InitializeItem(Items[I]);
  end;

begin
  ShowHourglassCursor;
  LockWrite;
  try
    EnumerateItems;
    InitializeItems;
    SetItemsCount(Items.Count);
  finally
    UnlockWrite;
    HideHourglassCursor;
  end;
end;

function TcxCustomItemProducer.GetEnumerationObjectParentWindow: HWND;
begin
  if Owner.HandleAllocated then
    Result := Owner.Handle
  else
    Result := 0;
end;

function TcxCustomItemProducer.GetEnumerator(out pEnum: IEnumIDList): Boolean;
var
  AShellFolder: IShellFolder;
begin
  AShellFolder := GetFolderForEnumeration;
  Result := (AShellFolder <> nil) and Succeeded(AShellFolder.EnumObjects(GetEnumerationObjectParentWindow,
    GetEnumFlags or Cardinal(IfThen(FIsFavorites, SHCONTF_NONFOLDERS)), pEnum)) and Assigned(pEnum);
end;

procedure TcxCustomItemProducer.ProcessDetails(ShellFolder: IShellFolder; CharWidth: Integer);
var
  Attr: Cardinal;
  ATempPidl: PitemIDList;
begin
  Attr := 0;
  ATempPidl := GetPidlCopy(FolderPidl);
  try
    if Failed(GetDesktopIShellFolder.GetAttributesOf(1, ATempPidl, Attr)) then
       Attr := 0;
    Details.ProcessDetails(CharWidth, ShellFolder, (Attr and SFGAO_FILESYSTEM) = SFGAO_FILESYSTEM);
  finally
    DisposePidl(ATempPidl);
  end;
end;

procedure TcxCustomItemProducer.DoGetInfoTip(AHandle: HWND; AItemIndex:
    Integer; AInfoTip: PChar; cch: Integer);
var
  ATask: TdxShellListViewGetInfoTipTask;
  AItem: TcxShellItemInfo;
begin
  if GetShowToolTip then
  begin
    if AItemIndex > Items.Count - 1 then
       Exit;

    AItem := ItemInfo[AItemIndex];
    if AItem.InfoTipState = itsNone then
    begin
      ATask := TdxShellListViewGetInfoTipTask.Create(Self, AItem);
      AItem.InfoTipState := itsLoading;
      FGetInfoTipItemTaskHandles.Add(dxTasksDispatcher.Run(ATask, InfoTipTaskCompleted, tmcmSync));
//      if NeedInfoTipWaiting then
        dxTasksDispatcher.WaitFor(FGetInfoTipItemTaskHandles.Last, 100)
    end;

    if AItem.InfoTip <> '' then
      StrLCopy(AInfoTip, PChar(AItem.InfoTip), cch);
  end;
end;

function TcxCustomItemProducer.GetItemByPidl(APidl: PItemIDList): TcxShellItemInfo;
var
  AItemIndex: Integer;
begin
  AItemIndex := GetItemIndexByPidl(APidl);
  if AItemIndex <> -1 then
    Result := ItemInfo[AItemIndex]
  else
    Result := nil;
end;

function TcxCustomItemProducer.GetItemIndexByPidl(APidl: PItemIDList): Integer;
var
  I: Integer;
begin
  Result := -1;
  LockRead;
  try
    for I := 0 to Items.Count - 1 do
      if IsQuickAccess and EqualPIDLs(APidl, ItemInfo[I].pidl) or
        not IsQuickAccess and (SmallInt(ShellFolder.CompareIDs(0, ItemInfo[I].pidl, APidl)) = 0) then
      begin
        Result := I;
        Break;
      end;
  finally
    UnlockRead;
  end;
end;

procedure TcxCustomItemProducer.Sort;
begin
  LockWrite;
  try
    DoSort;
  finally
    UnlockWrite;
  end;
end;

procedure TcxCustomItemProducer.FetchRequest(AItem: TcxShellItemInfo);
begin
  if ItemsInfoGatherer <> nil then
    ItemsInfoGatherer.RequestItemInfo(AItem);
end;

procedure TcxCustomItemProducer.ClearFetchQueue;
begin
  if ItemsInfoGatherer <> nil then
    ItemsInfoGatherer.ClearFetchQueue(Self);
end;

procedure TcxCustomItemProducer.CheckForSubitems(AItem: TcxShellItemInfo);
begin
end;

function TcxCustomItemProducer.CreateTask(AItem: TcxShellItemInfo): TdxShellItemTask;
begin
  Result := nil;
end;

procedure TcxCustomItemProducer.PopulateItems(pEnum: IEnumIDList);
begin
  TdxShellEnumHelper.DoEnumeration(pEnum,
    procedure(const APidl: PITemIDList)
    begin
      InternalAddItem(APidl);
    end,
    function: Boolean
    begin
      Result := False;
    end);
end;

procedure TcxCustomItemProducer.RemoveItem(AItem: TcxShellItemInfo);
begin
  CancelInfoTipTask(AItem);
  if CanCancelTask then
    ItemsInfoGatherer.CancelRequest(AItem);
  Items.Remove(AItem);
  AItem.Free;
end;

procedure TcxCustomItemProducer.UpdateItemInfoTip(AItem: TcxShellItemInfo; const AInfoTip: string);
begin
  AItem.UpdateInfoTip(AInfoTip);
end;

procedure TcxCustomItemProducer.CancelInfoTipTask(AItem: TcxShellItemInfo);
var
  I: Integer;
begin
  if AItem.InfoTipState = itsLoading then
    for I := 0 to FGetInfoTipItemTaskHandles.Count - 1 do
      if TdxShellListViewGetInfoTipTask(FGetInfoTipItemTaskHandles[I]).Item = AItem then
      begin
        dxTasksDispatcher.WaitFor(FGetInfoTipItemTaskHandles[I]);
        break;
      end;
end;

procedure TcxCustomItemProducer.CancelInfoTipTasks;
begin
  while FGetInfoTipItemTaskHandles.Count > 0 do
    dxTasksDispatcher.Cancel(FGetInfoTipItemTaskHandles[0], True);
end;

function TcxCustomItemProducer.GetFolderPidl: PItemIDList;
begin
  Result := FFolderPidl;
end;

procedure TcxCustomItemProducer.InfoTipTaskCompleted;
begin
end;

procedure TcxCustomItemProducer.SetFolderPidl(AValue: PItemIDList);
begin
  dxFreeAndNilPidl(FFolderPidl);
  FFolderPidl := GetPidlCopy(AValue);
end;

function TcxCustomItemProducer.GetItemInfo(AIndex: Integer): TcxShellItemInfo;
begin
  Result := TcxShellItemInfo(Items[AIndex]);
end;

{ TFetchThread }

constructor TFetchThread.Create(AInfoGatherer: TcxShellItemsInfoGatherer);
begin
  inherited Create(True);
  FInfoGatherer := AInfoGatherer;
  FTaskLock := TCriticalSection.Create;
  FProcessingLock := TCriticalSection.Create;
  FLockStopFetch := TCriticalSection.Create;
end;

destructor TFetchThread.Destroy;
begin
  FreeAndNil(FLockStopFetch);
  FreeAndNil(FProcessingLock);
  FreeAndNil(FTaskLock);
  inherited;
end;

procedure TFetchThread.CancelTask;
begin
  FTask.Cancel;
end;

procedure TFetchThread.LockItemProcessing;
begin
  FProcessingLock.Enter;
end;

function TFetchThread.TryLockItemProcessing: Boolean;
begin
  Result := FProcessingLock.TryEnter;
end;

procedure TFetchThread.UnlockItemProcessing;
begin
  FProcessingLock.Leave;
end;

procedure TFetchThread.LockTaskFinishing;
begin
  FTaskLock.Enter;
end;

procedure TFetchThread.UnlockTaskFinishing;
begin
  FTaskLock.Leave;
end;

procedure TFetchThread.Execute;

  procedure AddToProcessedItems;
  var
    AList: TList;
  begin
    AList := FInfoGatherer.ProcessedItems.LockList;
    try
      if not FCancelProcessItem then
      begin
        dxTestCheck(AList.IndexOf(FProcessingItem) = -1, Format('AddToProcessedItems fails, item name is %s', [FProcessingItem.Name]));
        AList.Add(FProcessingItem);
      end;
    finally
      FInfoGatherer.ProcessedItems.UnlockList;
    end;
  end;

  procedure ProcessFetchQueueItem;
  var
    AItemProducer: TcxCustomItemProducer;
  begin
    FTask := FProcessingItem.CreateTask;
    if FTask <> nil then
    begin
      LockItemProcessing;
      try
        if not Terminated and not FCancelProcessItem then
          FTask.Execute;
      finally
        UnlockItemProcessing;
      end;

      LockTaskFinishing;
      try
        if FTask.Canceled then
          FCancelProcessItem := True;
        FreeAndNil(FTask);
      finally
        UnlockTaskFinishing;
      end;
    end
    else
    begin 
      AItemProducer := FProcessingItem.ItemProducer;
      AItemProducer.LockRead;
      try
        if not AItemProducer.SlowInitializationDone(FProcessingItem) then
          AItemProducer.DoSlowInitialization(FProcessingItem);
      finally
        AItemProducer.UnlockRead;
      end;
    end;
    if not Terminated then
      AddToProcessedItems;
  end;

var
  AList: TList;
  AThreadList: TThreadList;
  ASucceeded: Boolean;
begin
   try
    ASucceeded := Succeeded(CoInitializeEx(nil, COINIT_APARTMENTTHREADED));
    try
      AThreadList := FInfoGatherer.FetchQueue;
      repeat
        LockStopFetch;
        try
          AList := AThreadList.LockList;
          try
            FCancelProcessItem := False;
            if AList.Count = 0 then
              FProcessingItem := nil
            else
              repeat
                FProcessingItem := TcxShellItemInfo(AList.Extract(AList.First));
                if FProcessingItem.IsFullUpdated then
                  FProcessingItem := nil;
              until (AList.Count = 0) or (FProcessingItem <> nil);
          finally
            AThreadList.UnlockList;
          end;
          if FProcessingItem <> nil then
            ProcessFetchQueueItem;
        finally
          UnlockStopFetch;
        end;
       if not Terminated and (FProcessingItem = nil) then
         FInfoGatherer.WaitForRequest;
       until Terminated;
    finally
      if ASucceeded then
        CoUninitialize;
    end;
  except
    HandleException;
  end;
end;

procedure TFetchThread.LockStopFetch;
begin
  FLockStopFetch.Enter; 
end;

procedure TFetchThread.UnlockStopFetch;
begin
  FLockStopFetch.Leave; 
end;

{ TcxShellItemsInfoGatherer }

constructor TcxShellItemsInfoGatherer.Create(AOwner: TWinControl);
begin
  inherited Create;
  FOwner := AOwner;
  FFetchQueue := TThreadList.Create;
  FProcessedItems := TThreadList.Create;
  FQueuePopulated := TcxEvent.Create(False, False);
  RegisterShellItemsInfoGatherer(Self);
end;

destructor TcxShellItemsInfoGatherer.Destroy;
begin
  UnregisterShellItemsInfoGatherer(Self);
  DestroyFetchThread;
  FreeAndNil(FQueuePopulated);
  FreeAndNil(FProcessedItems);
  FreeAndNil(FFetchQueue);
  inherited Destroy;
end;

procedure TcxShellItemsInfoGatherer.ClearFetchQueue(
  AItemProducer: TcxCustomItemProducer);

  procedure InternalClearFetchQueue(AQueue: TThreadList);
  var
    I: Integer;
    AList: TList;
  begin
    AList := AQueue.LockList;
    try
      if AItemProducer = nil then
        AList.Clear
      else
        for I := 0 to AItemProducer.Items.Count - 1 do
          AList.Remove(AItemProducer.Items[I]);
    finally
      AQueue.UnlockList;
    end;
  end;

  procedure ClearQueues;
  begin
    InternalClearFetchQueue(FetchQueue);
    InternalClearFetchQueue(FProcessedItems);
  end;

var
  AWaitThread: Boolean;
begin
  if (FFetchThread = nil) or FIsFetchQueueClearing then
    Exit;
  FIsFetchQueueClearing := True;
  try
    if AItemProducer = nil then
    begin
      FFetchThread.LockTaskFinishing;
      try
        if FFetchThread.TryLockItemProcessing then
          try
            FFetchThread.Terminate; 
            ClearQueues;
            AWaitThread := True;
          finally
            FFetchThread.UnlockItemProcessing;
          end
        else
        begin  
          FFetchThread.CancelTask;
          FFetchThread.Terminate;
          ClearQueues;
          FFetchThread.FreeOnTerminate := True;
          AWaitThread := False;
        end;
      finally
        FFetchThread.UnlockTaskFinishing;
      end;

      if AWaitThread then
        DestroyFetchThread 
      else
        FFetchThread := nil;
    end
    else
    begin
      StopFetch; 
      try
        ClearQueues;
      finally
        ResumeFetch;
      end;
    end;
  finally
    FIsFetchQueueClearing := False;
  end;
end;

procedure TcxShellItemsInfoGatherer.ClearVisibleItems;
var
  AList, AProcessedList: TList;
begin
  AList := FFetchQueue.LockList;
  AProcessedList := FProcessedItems.LockList;
  try
    AList.Clear;
    AProcessedList.Clear;
  finally
    FProcessedItems.UnlockList;
    FFetchQueue.UnlockList;
  end;
end;

procedure TcxShellItemsInfoGatherer.RequestItemInfo(AItem: TcxShellItemInfo);
var
  AList: TList;
  I: Integer;
begin
  AList := FFetchQueue.LockList;
  try
    I := AList.IndexOf(AItem);
    if I <> -1 then
      AList.Move(I, 0)
    else
      AList.Add(AItem);
  finally
    FFetchQueue.UnlockList;
  end;
  StartRequest;
end;

procedure TcxShellItemsInfoGatherer.RequestItems(AItems: TList);
var
  AList: TList;
  I: Integer;
begin
  AList := FFetchQueue.LockList;
  try
    for I := 0 to AItems.Count - 1 do
      AList.Add(AItems[I]);
  finally
    FFetchQueue.UnlockList;
  end;
  StartRequest;
end;

procedure TcxShellItemsInfoGatherer.ResumeFetch;
begin
  if FStopFetchCount > 0 then
  begin
    Dec(FStopFetchCount);
    if FStopFetchCount = 0 then
      UnLockFetchThread;
  end;
end;

procedure TcxShellItemsInfoGatherer.StopFetch;
begin
  Inc(FStopFetchCount);
  if FStopFetchCount = 1 then
    LockFetchThread;
end;

procedure TcxShellItemsInfoGatherer.UpdateRequest(AItems: TList);
begin
  ClearVisibleItems;
  RequestItems(AItems);
end;

procedure TcxShellItemsInfoGatherer.CancelRequest(AItem: TcxShellItemInfo);
var
  AFetchQueue, AProcessItems: TList;
begin
  if FFetchThread = nil then
    Exit;
  AFetchQueue := FFetchQueue.LockList;
  try
    if AItem <> nil then
      AFetchQueue.Remove(AItem)
    else
      AItem := FFetchThread.FProcessingItem; 
    if FFetchThread.FProcessingItem = AItem then
    begin
      FFetchThread.LockTaskFinishing;
      try
        if FFetchThread.TryLockItemProcessing then
        try
          AProcessItems := FProcessedItems.LockList;
          try
            FFetchThread.FCancelProcessItem := True;
            AProcessItems.Remove(AItem);
          finally
            FProcessedItems.UnlockList;
          end;
        finally
          FFetchThread.UnlockItemProcessing;
        end
        else
          FFetchThread.CancelTask;
      finally
        FFetchThread.UnlockTaskFinishing;
      end;
    end
    else
      FProcessedItems.Remove(AItem);
  finally
    FFetchQueue.UnlockList;
  end;
end;

procedure TcxShellItemsInfoGatherer.DestroyFetchThread;
begin
  if FFetchThread <> nil then
  begin
    FFetchThread.Terminate;
    FQueuePopulated.SetEvent;
    FFetchThread.WaitFor;
    FreeAndNil(FFetchThread);
  end;
end;

procedure TcxShellItemsInfoGatherer.LockFetchThread;
begin
  if FFetchThread <> nil then
    FFetchThread.LockStopFetch;
end;

procedure TcxShellItemsInfoGatherer.UnlockFetchThread;
begin
  if FFetchThread <> nil then
    FFetchThread.UnlockStopFetch;
end;

procedure TcxShellItemsInfoGatherer.WaitForRequest;
begin
  FQueuePopulated.WaitFor(INFINITE);
end;


procedure TcxShellItemsInfoGatherer.CreateFetchThread;
begin
  FFetchThread := TFetchThread.Create(Self);
  FFetchThread.Priority := tpIdle;
  FFetchThread.Start;
end;

procedure TcxShellItemsInfoGatherer.StartRequest;
begin
  if FFetchThread = nil then
    CreateFetchThread;
  FQueuePopulated.SetEvent;
end;

{ TcxShellFolder }

constructor TcxShellFolder.Create(AAbsolutePIDL: PItemIDList);
var
  AParentPIDL: PItemIDList;
  ALink: IShellLink;
  AShellItem: IShellItem;
  ATargetPidl: PItemIDList;
  AAttr: Cardinal;
// for XP
  AParentTargetPidl, ARelativeTargetPidl: PItemIDList;
  AParentTargetShellFolder: IShellFolder;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  if FShellItemInfo = nil then
    FAbsolutePIDL := AAbsolutePIDL;
  if GetPIDLItemsCount(AAbsolutePIDL) <= 1 then
  begin
    FParentShellFolder := GetDesktopIShellFolder;
    FRelativePIDL := GetPIDLCopy(AAbsolutePIDL);
  end
  else
  begin
    if FShellItemInfo <> nil then
      FParentShellFolder := FShellItemInfo.ItemProducer.ShellFolder
    else
    begin
      AParentPIDL := GetPIDLParent(AAbsolutePIDL);
      try
        GetDesktopIShellFolder.BindToObject(AParentPIDL, nil, IShellFolder,
          FParentShellFolder);
      finally
        DisposePidl(AParentPIDL);
      end;
    end;
    if FShellItemInfo = nil then
      FRelativePIDL := GetPIDLCopy(GetLastPIDLItem(AAbsolutePIDL));
  end;
  FIsLink := sfaLink in Attributes;
  FIsFolderLink := False;
  FIsZipFolderLink := False;
  AAttr := SFGAO_FOLDER or SFGAO_STREAM;
  if FIsLink and Succeeded(FParentShellFolder.BindToObject(RelativePIDL, nil, IID_IShellLink, ALink)) and
    Succeeded(ALink.GetIDList(ATargetPidl)) then
  begin
    if IsWinVistaOrLater then
      FIsFolderLink := Succeeded(SHCreateItemFromIDList(ATargetPidl, IID_IShellItem, AShellItem)) and
        Succeeded(AShellItem.GetAttributes(SFGAO_FOLDER or SFGAO_STREAM, AAttr))
    else
    begin
      AParentTargetPidl := GetPidlParent(ATargetPidl);
      ARelativeTargetPidl := GetPidlCopy(GetLastPidlItem(ATargetPidl));
      try
        FIsFolderLink := Succeeded(GetDesktopIShellFolder.BindToObject(AParentTargetPidl, nil, IID_IShellFolder, AParentTargetShellFolder)) and
         Succeeded(AParentTargetShellFolder.GetAttributesOf(1, ARelativeTargetPidl, AAttr));
      finally
        DisposePidl(ARelativeTargetPidl);
        DisposePidl(AParentTargetPidl);
      end;
    end;
    FIsFolderLink := FIsFolderLink and ((AAttr and SFGAO_FOLDER) = SFGAO_FOLDER);
    FIsZipFolderLink := FIsFolderLink and ((AAttr and (SFGAO_FOLDER or SFGAO_STREAM)) = (SFGAO_FOLDER or SFGAO_STREAM));
  end;
end;

constructor TcxShellFolder.Create(AShellItemInfo: TcxShellItemInfo);
var
  AAbsolutePidl: PItemIDList;
begin
  FShellItemInfo := AShellItemInfo;
  AAbsolutePidl := FShellItemInfo.CreateAbsolutePidl;
  Create(AAbsolutePidl);
  DisposePidl(AAbsolutePidl);
end;

destructor TcxShellFolder.Destroy;
begin
  FShellItemInfo := nil;
  dxFreeAndNilPidl(FRelativePIDL);
  FreeAndNil(FLock);
  inherited Destroy;
end;

function TcxShellFolder.CreateAbsolutePidl: PItemIDList;
begin
  if FShellItemInfo <> nil then
    Result := FShellItemInfo.CreateAbsolutePidl
  else
    Result := GetPidlCopy(FAbsolutePIDL);
end;

function TcxShellFolder.GetAbsolutePIDL: PItemIDList;
begin
  if FShellItemInfo <> nil then
    Result := FShellItemInfo.FullPIDL
  else
    Result := FAbsolutePIDL;
end;

function TcxShellFolder.GetAttributes: TcxShellFolderAttributes;

  procedure CheckAttribute(AShellAttributes, AAttributeShellAttribute: LongWord;
    AAttribute: TcxShellFolderAttribute);
  begin
    if HasShellAttribute(AShellAttributes, AAttributeShellAttribute) then
      Include(FAttributes, AAttribute);
  end;

var
  AShellAttributes: LongWord;
begin
  if not FIsAttributesValid then
  begin
    AShellAttributes := GetShellAttributes(SFGAO_DISPLAYATTRMASK and not SFGAO_ISSLOW);
    FAttributes := [];
    CheckAttribute(AShellAttributes, cxSFGAO_GHOSTED, sfaGhosted);
    CheckAttribute(AShellAttributes, SFGAO_HIDDEN, sfaHidden);
    //CheckAttribute(AShellAttributes, SFGAO_ISSLOW, sfaIsSlow);  // #Ch depricated - very slow request
    CheckAttribute(AShellAttributes, SFGAO_LINK, sfaLink);
    CheckAttribute(AShellAttributes, SFGAO_READONLY, sfaReadOnly);
    CheckAttribute(AShellAttributes, SFGAO_SHARE, sfaShare);
    FIsAttributesValid := True;
  end;
  Result := FAttributes;
end;

function TcxShellFolder.GetCapabilities: TcxShellFolderCapabilities;

  procedure CheckCapability(AShellAttributes, ACapabilityShellAttribute: LongWord;
    ACapability: TcxShellFolderCapability);
  begin
    if HasShellAttribute(AShellAttributes, ACapabilityShellAttribute) then
      Include(FCapabilities, ACapability);
  end;

var
  AShellAttributes: LongWord;
begin
  if not FIsCapabilitiesValid then
  begin
    AShellAttributes := GetShellAttributes(SFGAO_CAPABILITYMASK);
    FCapabilities := [];
    CheckCapability(AShellAttributes, SFGAO_CANCOPY, sfcCanCopy);
    CheckCapability(AShellAttributes, SFGAO_CANDELETE, sfcCanDelete);
    CheckCapability(AShellAttributes, SFGAO_CANLINK, sfcCanLink);
    CheckCapability(AShellAttributes, SFGAO_CANMOVE, sfcCanMove);
    CheckCapability(AShellAttributes, SFGAO_CANRENAME, sfcCanRename);
    CheckCapability(AShellAttributes, SFGAO_DROPTARGET, sfcDropTarget);
    CheckCapability(AShellAttributes, SFGAO_HASPROPSHEET, sfcHasPropSheet);
    FIsCapabilitiesValid := True;
  end;
  Result := FCapabilities;
end;

function TcxShellFolder.GetDisplayName: string;
begin
  Result := InternalGetPidlDisplayName(ParentShellFolder, RelativePIDL, SHGDN_INFOLDER);
end;

function TcxShellFolder.GetEditingName: string;
begin
  Result := InternalGetPidlDisplayName(ParentShellFolder, RelativePIDL, SHGDN_INFOLDER or SHGDN_FOREDITING)
end;

function TcxShellFolder.GetIsFolder: Boolean;
begin
  Result := sfscFolder in StorageCapabilities;
end;

function TcxShellFolder.GetIsZip: Boolean;
begin
  Result := StorageCapabilities * [sfscStream, sfscFolder] = [sfscStream, sfscFolder];
end;

function TcxShellFolder.GetPathName: string;
var
  AAbsolutePidl: PItemIDList;
begin
  AAbsolutePidl := CreateAbsolutePidl;
  Result := InternalGetPidlDisplayName(GetDesktopIShellFolder, AAbsolutePidl, SHGDN_FORPARSING);
  if Pos('::{', Result) = 1 then
    Result := InternalGetPidlDisplayName(GetDesktopIShellFolder, AAbsolutePidl, SHGDN_NORMAL);
  DisposePidl(AAbsolutePidl);
end;

function TcxShellFolder.GetProperties: TcxShellFolderProperties;

  procedure CheckProperty(AShellAttributes, APropertyShellAttribute: LongWord;
    AProperty: TcxShellFolderProperty);
  begin
    if HasShellAttribute(AShellAttributes, APropertyShellAttribute) then
      Include(FProperties, AProperty);
  end;

var
  AShellAttributes: LongWord;
begin
  FLock.Enter;
  try
    if not FIsPropertiesValid then
    begin
      AShellAttributes := GetShellAttributes(SFGAO_BROWSABLE or SFGAO_COMPRESSED or
        SFGAO_ENCRYPTED or SFGAO_NEWCONTENT or SFGAO_NONENUMERATED or SFGAO_REMOVABLE);
      FProperties := [];
      CheckProperty(AShellAttributes, SFGAO_BROWSABLE, sfpBrowsable);
      CheckProperty(AShellAttributes, SFGAO_COMPRESSED, sfpCompressed);
      CheckProperty(AShellAttributes, SFGAO_ENCRYPTED, sfpEncrypted);
      CheckProperty(AShellAttributes, SFGAO_NEWCONTENT, sfpNewContent);
      CheckProperty(AShellAttributes, SFGAO_NONENUMERATED, sfpNonEnumerated);
      CheckProperty(AShellAttributes, SFGAO_REMOVABLE, sfpRemovable);
      FIsPropertiesValid := True;
    end;
    Result := FProperties;
  finally
    FLock.Leave;
  end;
end;

function TcxShellFolder.GetRelativePIDL: PItemIDList;
begin
  if FShellItemInfo <> nil then
    Result := FShellItemInfo.pidl
  else
    Result := FRelativePIDL;
end;

function TcxShellFolder.GetShellAttributes(ARequestedAttributes: LongWord): LongWord;
var
  APidl: PItemIDList;
begin
  APidl := RelativePIDL;
  ParentShellFolder.GetAttributesOf(1, APidl, ARequestedAttributes);
  Result := ARequestedAttributes;
end;

function TcxShellFolder.GetShellFolder: IShellFolder;
var
  AAbsolutePidl: PItemIDList;
begin
  AAbsolutePidl := CreateAbsolutePidl;
  if GetPIDLItemsCount(AAbsolutePidl) = 0 then
    Result := GetDesktopIShellFolder
  else
    GetDesktopIShellFolder.BindToObject(AAbsolutePidl, nil, IID_IShellFolder, Result);
  DisposePidl(AAbsolutePidl);
end;

function TcxShellFolder.GetStorageCapabilities: TcxShellFolderStorageCapabilities;

  procedure CheckStorageCapability(AShellAttributes, AStorageCapabilityShellAttribute: LongWord;
    AStorageCapability: TcxShellFolderStorageCapability);
  begin
    if HasShellAttribute(AShellAttributes, AStorageCapabilityShellAttribute) then
      Include(FStorageCapabilities, AStorageCapability);
  end;

var
  AShellAttributes: LongWord;
begin
  FLock.Enter;
  try
    if not FIsStorageCapabilitiesValid then
    begin
      AShellAttributes := GetShellAttributes(SFGAO_STORAGECAPMASK);
      FStorageCapabilities := [];
      CheckStorageCapability(AShellAttributes, SFGAO_FILESYSANCESTOR, sfscFileSysAncestor);
      CheckStorageCapability(AShellAttributes, SFGAO_FILESYSTEM, sfscFileSystem);
      CheckStorageCapability(AShellAttributes, SFGAO_FOLDER, sfscFolder);
      CheckStorageCapability(AShellAttributes, SFGAO_LINK, sfscLink);
      CheckStorageCapability(AShellAttributes, SFGAO_READONLY, sfscReadOnly);
      CheckStorageCapability(AShellAttributes, SFGAO_STORAGE, sfscStorage);
      CheckStorageCapability(AShellAttributes, SFGAO_STORAGEANCESTOR, sfscStorageAncestor);
      CheckStorageCapability(AShellAttributes, SFGAO_STREAM, sfscStream);
      FIsStorageCapabilitiesValid := True;
    end;
    Result := FStorageCapabilities;
  finally
    FLock.Leave;
  end;
end;

function TcxShellFolder.GetSubFolders: Boolean;
begin
  Result := HasShellAttribute(SFGAO_HASSUBFOLDER);
end;

function TcxShellFolder.HasShellAttribute(AAttribute: LongWord): Boolean;
begin
  Result := HasShellAttribute(GetShellAttributes(AAttribute), AAttribute);
end;

function TcxShellFolder.HasShellAttribute(AAttributes, AAttribute: LongWord): Boolean;
begin
  Result := AAttributes and AAttribute <> 0;
end;

{ TdxShellItemHelper }

class function TdxShellItemHelper.GetIconIndexByPidl(
  const APidl: PItemIDList): Integer;
var
  AFileInfo: TShFileInfo;
  AFlags: Cardinal;
begin
  AFlags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_TYPENAME;
  cxShellGetThreadSafeFileInfo(PChar(APidl), 0, AFileInfo, SizeOf(AFileInfo), AFlags);
  Result := AFileInfo.iIcon;
end;

class function TdxShellItemHelper.GetOpenIconIndexByPidl(
  const APidl: PItemIDList): Integer;
var
  AFileInfo: TShFileInfo;
  AFlags: Cardinal;
begin
  AFlags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_TYPENAME or SHGFI_OPENICON;
  cxShellGetThreadSafeFileInfo(PChar(APidl), 0, AFileInfo, SizeOf(AFileInfo), AFlags);
  Result := AFileInfo.iIcon;
end;

class function TdxShellItemHelper.GetOverlayIndexByPidl(
  const APidl: PItemIDList): Integer;
var
  AFileInfo: TShFileInfo;
  AFlags: Cardinal;
begin
  AFlags := SHGFI_PIDL or SHGFI_ICON or SHGFI_OVERLAYINDEX;
  ZeroMemory(@AFileInfo, SizeOf(AFileInfo));
  cxShellGetThreadSafeFileInfo(PChar(APidl), 0, AFileInfo, SizeOf(AFileInfo), AFlags);
  DestroyIcon(AFileInfo.hIcon);
  Result := AFileInfo.iIcon;
  Result := (Result shr ((SizeOf(Result) - 1) * 8)) and $FF - 1;
end;

class function TdxShellItemHelper.GetQuickIconIndexByName(
  const AName: string): Integer;
var
  AFileInfo: TShFileInfo;
begin
  cxShellGetThreadSafeFileInfo(PChar(AName), FILE_ATTRIBUTE_NORMAL, AFileInfo, SizeOf(TShFileInfo),
    SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  Result := AFileInfo.iIcon;
end;

type
  TdxShellQuickAccessItemHelper = class
  strict private const
    PKEY_Home_IsPinned: TGUID = '{30C8EEF4-A832-41E2-AB32-E3C3CA28FD29}';
  public
    function IsPinned(APidl: PItemIDList): Boolean;
  end;

function TdxShellQuickAccessItemHelper.IsPinned(APidl: PItemIDList): Boolean;
var
  AShellItem2: IShellItem2;
  APropertyKey: TPropertyKey;
  AValue: LongBool;
begin
  APropertyKey.fmtid := PKEY_Home_IsPinned;
  APropertyKey.pid := 4;
  Result := Succeeded(SHCreateItemFromIDList(APidl, IID_IShellItem2, AShellItem2)) and
    Succeeded(AShellItem2.GetBool(APropertyKey, AValue)) and AValue;
end;

{ TcxShellItemInfo }

procedure TcxShellItemInfo.CheckInitialize(AIFolder: IShellFolder;
  APIDL: PItemIDList);
var
  AAttributes: Cardinal;
begin
  if Initialized then
    Exit;
  AAttributes := SFGAO_FOLDER;
  if Succeeded(AIFolder.GetAttributesOf(1, APIDL, AAttributes)) then
    FIsFolder := AAttributes and SFGAO_FOLDER <> 0
  else
  begin
    FIsFolder := False;
    FIsFilesystem := False;
  end;
  FName := Folder.DisplayName;
  FInfoTip := '';
  FInfoTipState := itsNone;
  FIsLink := Folder.IsLink;
  FIsFolderLink := Folder.IsFolderLink;
  FIsZipFolderLink := Folder.IsZipFolderLink;
  FIsGhosted := sfaHidden in Folder.Attributes; 
  FIsShare := sfaShare in Folder.Attributes;
  FIsFilesystem := sfscFileSystem in Folder.StorageCapabilities;
  FHasSubfolder := IsFolder;

  if IsFolder then
  begin
    FIconIndex := sysFolderIconIndex;
    FOpenIconIndex := sysFolderOpenIconIndex;
  end
  else
  begin
    FIconIndex := sysFileIconIndex;
    FOpenIconIndex := sysFileIconIndex;
  end;
  FOverlayIndex := -1;
  ResetThumbnail;
  FIsSubitemsChecked := False;
  FUpdated := False;
  FInitialized := True;
end;

function TcxShellItemInfo.CreateAbsolutePidl: PItemIDList;
begin
  Result := ConcatenatePidls(ItemProducer.FolderPidl, pidl)
end;

procedure TcxShellItemInfo.CheckSubitems(AParentIFolder: IShellFolder;
  AEnumSettings: Cardinal);
var
  AAbsolutePidl: PItemIDList;
begin
  if not FIsSubitemsChecked then
  begin
    AAbsolutePidl := CreateAbsolutePidl;
    FHasSubfolder := HasSubItems(AParentIFolder, AAbsolutePidl, AEnumSettings);
    DisposePidl(AAbsolutePidl);
    FIsSubitemsChecked := True;
  end;
end;

procedure TcxShellItemInfo.CheckUpdate(AShellFolder: IShellFolder;
  AFolderPidl: PItemIDList; AFast: Boolean);
var
  AItemInfo: TdxShellItem;
  AAbsolutePidl: PItemIDList;
begin
  if Updated or Updating then
     Exit;
  Updating := True;
  try
    Assert(pidl <> nil,'Item object not initialized');
    if pidl = nil then
      Exit;
    AItemInfo.IconIndex := FIconIndex;
    AItemInfo.OpenIconIndex := FOpenIconIndex;
    AItemInfo.OverlayIndex := FOverlayIndex;
    if not AFast then
    begin
      AAbsolutePidl := CreateAbsolutePidl;
      AItemInfo.IconIndex := TdxShellItemHelper.GetIconIndexByPidl(AAbsolutePidl);
      if FIsFolder then
        AItemInfo.OpenIconIndex := TdxShellItemHelper.GetOpenIconIndexByPidl(AAbsolutePidl);
      AItemInfo.OverlayIndex := TdxShellItemHelper.GetOverlayIndexByPidl(AAbsolutePidl);
      DisposePidl(AAbsolutePidl);
    end
    else
      if not IsFolder then
        AItemInfo.IconIndex := TdxShellItemHelper.GetQuickIconIndexByName(Name);
    UpdateItem(AItemInfo);
  finally
    Updating := False;
  end;
end;

constructor TcxShellItemInfo.Create(AItemProducer: TcxCustomItemProducer;
  AParentIFolder: IShellFolder; AParentPIDL, APIDL: PItemIDList;
  AFast: Boolean);
var
  AWithoutAV: Boolean;
begin
  inherited Create;
  FItemProducer := AItemProducer;
  FLockUpdateItem := TCriticalSection.Create;
  FLockUpdateDetails := TCriticalSection.Create;
  // the following code required to get rid of bug, that occasionally appeared
  // on Windows XP. The pidl received from thr shell, anothed memory block
  // allocated internally, but occasionally appeared exception thad CopyMemory
  // can't be performed
  FDetails := TStringList.Create;
  FDetailsEx := TDictionary<Integer, TcxShellItemDetail>.Create;
  repeat
    try
      UpdatePidl(AParentPIDL, APIDL);
      AWithoutAV := True;
    except
      AWithoutAV := False;
    end;
  until AWithoutAV;
  if not AFast then
    CheckInitialize(AParentIFolder, APIDL)
  else
  begin
    FName := ' ';
    FIconIndex := sysFileIconIndex;
    FOpenIconIndex := sysFileIconIndex;
    FOverlayIndex := -1;
    FThumbnailIndex := -1;
  end;
  FInfoTip := '';
  FPinIndex := -1;
end;

destructor TcxShellItemInfo.Destroy;
begin
  FreeAndNil(FLockUpdateDetails);
  FreeAndNil(FLockUpdateItem);
  FreeAndNil(FFolder);
  dxFreeAndNilPidl(FRealItemPidl);
  dxFreeAndNilPidl(FAbsolutePidl);
  dxFreeAndNilPidl(Fpidl);
  FreeAndNil(FDetailsEx);
  FreeAndNil(FDetails);
  inherited;
end;

procedure TcxShellItemInfo.FetchDetails(Wnd: HWND; ShellFolder: IShellFolder; DetailsMap: TcxShellDetails);

  function FormatSizeStr(AStr: string): string;
  begin
    Result := FormatMaskText('!### ### ### KB;0;*', AStr);
  end;

  function GetFileTypeInfo(const AFilename: string): string;
  begin
    Result := GetRegStringValue(GetRegStringValue(ExtractFileExt(AFileName), ''), '');
  end;

var
  AColumnDetails: TShellDetails;
  AFileInfo: TWIN32FindData;
  AFileSize: record
    case integer of
      0:(l,h:cardinal);
      1:(c:int64);
    end;
  AFindFileHandle: THandle;
  APDetailItem: PcxDetailItem;
  AShellDetails: IShellDetails;
  AShellFolder2: IShellFolder2;
  AStrPath: TStrRet;
  ATempName: PChar;
  I: Integer;
  AStr: OleVariant;
begin
  if IsWinSevenOrLater then
  begin
    for I := 0 to DetailsMap.Count - 1 do
      UpdateDetailItem(DetailsMap[I]);
    RebuildDetails(DetailsMap);
  end
  else
    if Succeeded(ShellFolder.QueryInterface(IShellFolder2, AShellFolder2)) then
    begin
      for I := 0 to DetailsMap.Count - 1 do
      begin
        APDetailItem := DetailsMap[I];
        if (APDetailItem.ID = 0) or not APDetailItem.Visible or FDetailsEx.ContainsKey(APDetailItem.ID) then
          Continue;
        AStr := '';
        if (AShellFolder2.GetDetailsEx(pidl, APDetailItem.ShColumnID, @AStr) = S_OK) and
          not (VarIsStr(AStr) or VarIsDate(AStr) or VarIsNumeric(AStr)) then
        begin
          AddDetails(APDetailItem.ID, '', Null);
          Continue;
        end;

        if AShellFolder2.GetDetailsOf(pidl, APDetailItem.ID, AColumnDetails) = S_OK then
          AddDetails(APDetailItem.ID, GetTextFromStrRet(AColumnDetails.str, pidl), AStr)
        else
          AddDetails(APDetailItem.ID, VarToStr(AStr), AStr);
      end;
      RebuildDetails(DetailsMap);
    end
    else  
    begin
      Details.Clear;
      if Succeeded(GetShellDetails(ShellFolder, pidl, AShellDetails)) then
      begin
        for I := 0 to DetailsMap.Count - 1 do
        begin
          APDetailItem := DetailsMap[I];
          if APDetailItem.ID = 0 then
             Continue; // Name column already exists
          if AShellDetails.GetDetailsOf(pidl, APDetailItem.ID, AColumnDetails) = S_OK then
            Details.Add(GetTextFromStrRet(AColumnDetails.str, pidl))
          else
            Details.Add('');
        end;
      end
      else
        if IsFilesystem then
        begin
          if Failed(ShellFolder.GetDisplayNameOf(pidl, SHGDN_NORMAL or SHGDN_FORPARSING, AStrPath)) then
            Exit;
          GetMem(ATempName, MAX_PATH);
          try
            StrPLCopy(ATempName, GetTextFromStrRet(AStrPath, pidl), MAX_PATH);
            AFindFileHandle := FindFirstFile(ATempName, AFileInfo);
            if AFindFileHandle <> INVALID_HANDLE_VALUE then
            try
              AFileSize.h := AFileInfo.nFileSizeHigh;
              AFileSize.l := AFileInfo.nFileSizeLow;
              Details.Add(FormatSizeStr(IntToStr(Ceil(AFileSize.c/1024))));
              Details.Add(GetFileTypeInfo(AFileInfo.cFileName));
              Details.Add(DateTimeToStr(cxFileTimeToDateTime(AFileInfo.ftLastWriteTime)));
            finally
              Windows.FindClose(AFindFileHandle);
            end;
          finally
            FreeMem(ATempName);
          end;
        end;
    end;
end;

procedure TcxShellItemInfo.AddDetails(AID: Integer; const ADisplayValue: string; const AValue: OleVariant);
var
  AShellDetail: TcxShellItemDetail;
begin
  AShellDetail.DisplayValue := ADisplayValue;
  AShellDetail.Value := AValue;
  FDetailsEx.Add(AID, AShellDetail);
end;

procedure TcxShellItemInfo.CheckIsPinned;
var
  AQuickAccessItemHelper: TdxShellQuickAccessItemHelper;
  AAbsolutePidl: PItemIDList;
begin
  AQuickAccessItemHelper := TdxShellQuickAccessItemHelper.Create;
  AAbsolutePidl := CreateAbsolutePidl;
  try
    FIsPinned := AQuickAccessItemHelper.IsPinned(AAbsolutePidl);
  finally
    DisposePidl(AAbsolutePidl);
    AQuickAccessItemHelper.Free;
  end;
end;

procedure TcxShellItemInfo.CheckRealPidl;

  function GetQuickAccessItemAbsolutePidl(out APidl: PItemIDList): Boolean;
  var
    AShellItem: IShellItem;
    ALink: IShellLink;
  begin
    APidl := nil;
    Result := Succeeded(SHCreateItemWithParent(ItemProducer.FolderPidl, ItemProducer.ShellFolder, pidl, IID_IShellItem, AShellItem)) and
      Succeeded(AShellItem.BindToHandler(nil, BHID_SFUIObject, IShellLink, ALink)) and
        Succeeded(ALink.GetIDList(APidl));
  end;

  function GetTargetItemAbsolutePidl(out APidl: PItemIDList): Boolean;
  var
    ALink: IShellLink;
  begin
    APidl := nil;
    Result := FFolder.IsFolderLink and Succeeded(ItemProducer.ShellFolder.BindToObject(Fpidl, nil, IID_IShellLink, ALink)) and
      Succeeded(ALink.GetIDList(APidl));
  end;

begin
  if FRealItemPidl = nil then
    if ItemProducer.IsQuickAccess then
      GetQuickAccessItemAbsolutePidl(FRealItemPidl)
    else
      if ItemProducer.FIsFavorites then
        GetTargetItemAbsolutePidl(FRealItemPidl);
end;

function TcxShellItemInfo.GetItemIndex: Integer;
begin
  Result := ItemProducer.FItems.IndexOf(Self);
end;

procedure TcxShellItemInfo.RebuildDetails(DetailsMap: TcxShellDetails);
var
  I: Integer;
  ADetailItem: PcxDetailItem;
begin
  Details.Clear;
  for I := 0 to DetailsMap.Count - 1 do
  begin
    ADetailItem := DetailsMap[I];
    if (ADetailItem.ID = 0) or not ADetailItem.Visible then
      Continue;
    Details.Add(FDetailsEx[ADetailItem.ID].DisplayValue);
  end;
end;

procedure TcxShellItemInfo.UnlockUpdate;
begin
  FLockUpdateItem.Leave;
end;

procedure TcxShellItemInfo.UpdatePidl(AParentPidl, APidl: PItemIDList);
begin
  dxFreeAndNilPidl(FPidl);
  FPidl := GetPidlCopy(APidl);
  dxFreeAndNilPidl(FRealItemPidl);
  dxFreeAndNilPidl(FAbsolutePidl);
  FFolder.Free;
  FFolder := TcxShellFolder.Create(Self);
  if ItemProducer.IsQuickAccess then
  begin
    CheckIsPinned;
    HasSubfolder := False;
    FIsSubitemsChecked := True;
  end
  else
    if ItemProducer.FIsFavorites then
    begin
      HasSubfolder := False;
      FIsSubitemsChecked := True;
    end;
end;

function TcxShellItemInfo.GetOverlayIndex: Integer;
var
  AAbsolutePidl: PItemIDList;
begin
  if GetComCtlVersion >= ComCtlVersionIE5 then
  begin
    AAbsolutePidl := CreateAbsolutePidl;
    Result := TdxShellItemHelper.GetOverlayIndexByPidl(AAbsolutePidl);
    DisposePidl(AAbsolutePidl);
  end
  else
    if IsLink then
      Result := cxShellShortcutItemOverlayIndex
    else
      if IsShare then
        Result := cxShellSharedItemOverlayIndex
      else
        Result := cxShellNormalItemOverlayIndex;
end;

function TcxShellItemInfo.GetRealItemPidl: PItemIDList;
begin
  CheckRealPidl;
  if FRealItemPidl <> nil then
    Result := GetPidlCopy(FRealItemPidl)
  else
    Result := CreateAbsolutePidl;
end;

function TcxShellItemInfo.HasThumbnail: Boolean;
begin
  Result := FThumbnailIndex <> -1;
end;

procedure TcxShellItemInfo.LockUpdate;
begin
  FLockUpdateItem.Enter;
end;

procedure TcxShellItemInfo.ResetDetails;
begin
  FLockUpdateDetails.Enter;
  try
    FDetailsEx.Clear;
  finally
    FLockUpdateDetails.Leave;
  end;
  Details.Clear;
end;

procedure TcxShellItemInfo.ResetThumbnail;
begin
  FThumbnailIndex := -1;
  FThumbnailUpdated := False;
end;

procedure TcxShellItemInfo.SetNewPidl(const APidl: PItemIDList);
begin
  SetNewPidl(ItemProducer.ShellFolder, ItemProducer.FolderPidl, APidl);
end;

procedure TcxShellItemInfo.SetNewPidl(pFolder: IShellFolder; const AFolderPidl, APidl: PItemIDList);
begin
  if APidl = nil then
    Exit;

  ItemProducer.CancelInfoTipTask(Self);
  if ItemProducer.CanCancelTask then
    ItemProducer.ItemsInfoGatherer.CancelRequest(Self);
  UpdatePidl(AFolderPidl, APidl);
  FProcessed := False;
  FInitialized := False;
  CheckInitialize(pFolder, APidl);
  if ItemProducer.CanCancelTask then
    ItemProducer.ItemsInfoGatherer.RequestItemInfo(Self)
  else
    CheckUpdate(pFolder, AFolderPidl, False);
end;

procedure TcxShellItemInfo.UpdateItem(AItemInfo: TdxShellItem);
begin
  LockUpdate;
  try
    FIconIndex := AItemInfo.IconIndex;
    if FIsFolder then
      FOpenIconIndex := AItemInfo.OpenIconIndex
    else
      FOpenIconIndex := FIconIndex;
    FOverlayIndex := AItemInfo.OverlayIndex;
    FUpdated := True;
  finally
    UnlockUpdate;
  end;
  ItemProducer.ItemImageUpdated(Self);
end;

procedure TcxShellItemInfo.UpdateThumbnail;
begin
  if not FThumbnailUpdating then
  begin
    FThumbnailUpdating := True;
    try
      FThumbnailIndex := ItemProducer.GetThumbnailIndex(Self);
      FThumbnailUpdated := True;
    finally
      FThumbnailUpdating := False;
    end;
  end;
end;

function TcxShellItemInfo.CreateTask: TdxShellItemTask;
begin
  Result := ItemProducer.CreateTask(Self);
end;

function TcxShellItemInfo.GetValueForSorting: OleVariant;
var
  AShellItemDetail: TcxShellItemDetail;
begin
  if ItemProducer.FSortColumn = 0 then
    Result := UpperCase(Name)
  else
  begin
    UpdateDetailItem(ItemProducer.FSortDetailItem);
    if FDetailsEx.TryGetValue(ItemProducer.FSortColumn, AShellItemDetail) then
    begin
      Result := AShellItemDetail.Value;
      if VarIsStr(Result) then
        Result := UpperCase(Result)
    end
    else
      Result := Null;
  end;
end;

function TcxShellItemInfo.IsFullUpdated: Boolean;
begin
  Result := ItemProducer.IsItemFullUpdated(Self);
end;

procedure TcxShellItemInfo.UpdateInfoTip(const AInfoTip: string);
begin
  FInfoTip := AInfoTip;
  FInfoTipState := itsLoaded;
end;

function TcxShellItemInfo.GetCanRename: Boolean;
begin
  Result := sfcCanRename in Folder.Capabilities;
end;

function TcxShellItemInfo.GetAbsolutePidl: PItemIDList;
begin
  if FAbsolutePidl = nil then
    FAbsolutePidl := CreateAbsolutePidl;
  Result := FAbsolutePidl;
end;

function TcxShellItemInfo.GetIsDropTarget: Boolean;
begin
  Result := sfcDropTarget in Folder.Capabilities;
end;

function TcxShellItemInfo.GetIsRemovable: Boolean;
begin
  Result := sfpRemovable in Folder.Properties;
end;

function TcxShellItemInfo.GetIsZip: Boolean;
begin
  Result := Folder.IsZip;
end;

procedure TcxShellItemInfo.UpdateDetailItem(APDetailItem: PcxDetailItem);

  function SHColumnIDToPropertyKey(const AShColumnID: SHCOLUMNID): TPropertyKey;
  begin
    Result.fmtid := AShColumnID.fmtid;
    Result.pid := AShColumnID.pid;
  end;

  function IsItemFast(AItem: PcxDetailItem): Boolean;
  begin
    Result := AItem.Flags and (SHCOLSTATE_BATCHREAD or SHCOLSTATE_SLOW or SHCOLSTATE_EXTENDED) = 0;
  end;

  function CanDisplayAsString(APropVar: TPropVariant): Boolean;
  begin
    Result := APropVar.vt <> VT_BLOB;
  end;

var
  ADisplayValue: string;
  S: PChar;
  AShellItem2: IShellItem2;
  APropertyDescription: IPropertyDescription;
  APropVar: TPropVariant;
  AFormatFlags: Cardinal;
  AValue: OleVariant;
  AAbsolutePidl: PItemIDList;
begin
  if (APDetailItem.ID = 0) or not APDetailItem.Visible then
    Exit;

  FLockUpdateDetails.Enter;
  try
    if not FDetailsEx.ContainsKey(APDetailItem.ID) then
    begin
      ADisplayValue := '';
      AValue := '';
      AAbsolutePidl := CreateAbsolutePidl;
      try
        if Succeeded(SHCreateItemFromIDList(AAbsolutePidl, IID_IShellItem2, AShellItem2)) and Succeeded(AShellItem2.Update(nil)) and
          Succeeded(AShellItem2.GetProperty(SHColumnIDToPropertyKey(APDetailItem.ShColumnID), APropVar)) then
        begin
          if CanDisplayAsString(APropVar) and Assigned(dxPSGetPropertyDescription) and
            Succeeded(dxPSGetPropertyDescription(SHColumnIDToPropertyKey(APDetailItem.ShColumnID), IID_IPropertyDescription, APropertyDescription)) then
          begin
            AFormatFlags := PDFF_SHORTTIME;
            if APDetailItem.IsShColumnIdEqual(CommonPKeys[ccidSize]) then
              AFormatFlags := AFormatFlags or PDFF_ALWAYSKB;
            if Succeeded(APropertyDescription.FormatForDisplay(APropVar, AFormatFlags, S)) then
              ADisplayValue := S;
          end;
          dxPropVariantToVariant(APropVar, AValue);
        end;
      finally
        DisposePidl(AAbsolutePidl);
      end;
      AddDetails(APDetailItem.ID, ADisplayValue, AValue);
    end;
  finally
    FLockUpdateDetails.Leave;
  end;
end;

{ TcxShellOptions }

constructor TcxShellOptions.Create(AOwner: TWinControl);
begin
  inherited Create;
  FOwner := AOwner;
  FContextMenus := True;
  FMasks := TStringList.Create;
  FShowFolders := True;
  FShowNonFolders := IsDefaultShowNonFolders;
  FShowToolTip := GetDefaultShowToolTipValue;
  FShowZipFilesWithFolders := True;
  FTrackShellChanges := True;
end;

destructor TcxShellOptions.Destroy;
begin
  FreeAndNil(FMasks);
  inherited Destroy;
end;

procedure TcxShellOptions.Assign(Source: TPersistent);
begin
  if Source is TcxShellOptions then
  begin
    BeginUpdate;
    try
      DoAssign(TcxShellOptions(Source));
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TcxShellOptions.BeginUpdate;
begin
  Inc(FLock);
end;

procedure TcxShellOptions.EndUpdate;
begin
  Dec(FLock);
  if FLock <= 0 then
    NotifyUpdateContents;
end;

function TcxShellOptions.GetEnumFlags: Cardinal;
begin
  if ShowFolders then
    Result := SHCONTF_FOLDERS
  else
    Result := 0;
  if ShowNonFolders then
    Result := Result or SHCONTF_NONFOLDERS;
  if ShowHidden then
    Result := Result or SHCONTF_INCLUDEHIDDEN;
end;

type
  TParseState = class
  private
    AnySym: Boolean;
    MaskPos: Integer;
    NamePos: Integer;
  end;

function TcxShellOptions.IsFileNameValid(const AName: string): Boolean;
var
  AParseStates: TObjectList;
  AState: TParseState;
  AMaskLength, ANameLength: Integer;

  procedure StoreCurrentState(const AMaskPos, ANamePos: Integer; AAnySym: Boolean);
  begin
    AState := TParseState.Create;
    AParseStates.Add(AState);
    AState.MaskPos := AMaskPos;
    AState.NamePos := ANamePos;
    AState.AnySym := AAnySym;
  end;

  procedure RestoreCurrentState(out AMaskPos, ANamePos: Integer; out AAnySym: Boolean);
  begin
    AState := TParseState(AParseStates.Extract(AParseStates.Last));
    AMaskPos := AState.MaskPos;
    ANamePos := AState.NamePos + 1;
    AAnySym := AState.AnySym;
    AState.Free;
  end;

  function Parse(const AMask, AFileName: string): Boolean;
  var
    P, AFirstSym: Integer;
    AMaskPos, ANamePos: Integer;
    AAnySym: Boolean;
  begin
    Result := False;
    RestoreCurrentState(AMaskPos, ANamePos, AAnySym);
    while AMaskPos <= AMaskLength do
    begin
      case AMask[AMaskPos] of
        '*':
          begin
            while (AMaskPos < AMaskLength) and (AMask[AMaskPos + 1] = '*') do
              Inc(AMaskPos);
            AAnySym := True;
          end;
        '?':
          begin
            if ANamePos > ANameLength then
              Exit;
            Inc(ANamePos);
          end;
        else
        begin
          AFirstSym := AMaskPos;
          while (AMaskPos < AMaskLength) and (AMask[AMaskPos + 1] <> '*') and (AMask[AMaskPos + 1] <> '?') do
            Inc(AMaskPos);
          P := Pos(Copy(AMask, AFirstSym, AMaskPos - AFirstSym + 1), Copy(AFileName, ANamePos, 260));
          if (P = 0) or (not AAnySym and (P <> 1)) then
            Exit;

          StoreCurrentState(AMaskPos, ANamePos, AAnySym);

          Inc(ANamePos, P - 1 + (AMaskPos - AFirstSym + 1));
          AAnySym := False;
        end;
      end;
      Inc(AMaskPos);
    end;
    Result := (ANamePos > ANameLength) or AAnySym or (AParseStates.Count > 0) and Parse(AMask, AFileName);
  end;

var
  AMask, AFileName: string;
  I: Integer;
begin
  Result := True;
  AParseStates := TObjectList.Create;
  try
    AFileName := AnsiUpperCase(AName);
    ANameLength := Length(AFileName);
    for I := 0 to FMasks.Count - 1 do
    begin
      AParseStates.Clear;
      AMask := AnsiUpperCase(FMasks[I]);
      AMaskLength := Length(AMask);
      StoreCurrentState(1, 0, False);
      Result := Parse(AMask, AFileName);
      if Result then
        Break;
    end;
  finally
    AParseStates.Free;
  end;
end;

procedure TcxShellOptions.DoAssign(Source: TcxShellOptions);
begin
  Self.ContextMenus := Source.ContextMenus;
  Self.FileMask := Source.FileMask;
  Self.ShowFolders := Source.ShowFolders;
  Self.ShowHidden := Source.ShowHidden;
  Self.ShowNonFolders := Source.ShowNonFolders;
  Self.ShowToolTip := Source.ShowToolTip;
  Self.ShowZipFilesWithFolders := Source.ShowZipFilesWithFolders;
  Self.TrackShellChanges := Source.TrackShellChanges;
end;

procedure TcxShellOptions.DoNotifyUpdateContents;
begin
  if Owner.HandleAllocated then
    SendMessage(Owner.Handle, DSM_NOTIFYUPDATECONTENTS, 0, 0);
end;

function TcxShellOptions.GetDefaultShowToolTipValue: Boolean;
begin
  Result := True;
end;

function TcxShellOptions.IsDefaultShowNonFolders: Boolean;
begin
  Result := True;
end;

procedure TcxShellOptions.NotifyUpdateContents;
begin
  if FLock <= 0 then
    DoNotifyUpdateContents;
end;

procedure TcxShellOptions.SetFileMask(const Value: string);
begin
  if Value <> FFileMask then
  begin
    FFileMask := Value;
    UpdateMasks;
    NotifyUpdateContents;
  end;
end;

procedure TcxShellOptions.SetShowFolders(Value: Boolean);
begin
  FShowFolders := Value;
  NotifyUpdateContents;
end;

procedure TcxShellOptions.SetShowHidden(Value: Boolean);
begin
  FShowHidden := Value;
  NotifyUpdateContents;
end;

procedure TcxShellOptions.SetShowNonFolders(Value: Boolean);
begin
  FShowNonFolders := Value;
  NotifyUpdateContents;
end;

procedure TcxShellOptions.SetShowToolTip(Value: Boolean);
begin
  if Value <> FShowToolTip then
  begin
    FShowToolTip := Value;
    if Assigned(FOnShowToolTipChanged) then
      FOnShowToolTipChanged(Self);
  end;
end;

procedure TcxShellOptions.SetShowZipFilesWithFolders(AValue: Boolean);
begin
  FShowZipFilesWithFolders := AValue;
  NotifyUpdateContents;
end;

procedure TcxShellOptions.SetTrackShellChanges(AValue: Boolean);
begin
  if FTrackShellChanges <> AValue then
  begin
    FTrackShellChanges := AValue;
    NotifyUpdateContents;
  end;
end;

procedure TcxShellOptions.UpdateMasks;
var
  I: Integer;
begin
  FMasks.Clear;
  FMasks.Text := StringReplace(FFileMask, ';', #13#10, [rfReplaceAll]);
  for I := 0 to FMasks.Count - 1 do
  begin
    if (FMasks[I] = '') or (FMasks[I] = '*') or (FMasks[I] = '*.*') then
    begin
      FMasks.Clear;
      Break;
    end;
  end;
end;

{ TcxShellThumbnailOptions }

constructor TcxShellThumbnailOptions.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  FWidth := 96;
  FHeight := 96;
end;

procedure TcxShellThumbnailOptions.Assign(Source: TPersistent);
var
  ASourceOptions: TcxShellThumbnailOptions;
begin
  if Source is TcxShellThumbnailOptions then
  begin
    ASourceOptions := TcxShellThumbnailOptions(Source);
    BeginUpdate;
    try
      Height := ASourceOptions.Height;
      Width := ASourceOptions.Width;
      ShowThumbnails := ASourceOptions.ShowThumbnails;
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TcxShellThumbnailOptions.BeginUpdate;
begin
  Inc(FLock);
end;

procedure TcxShellThumbnailOptions.EndUpdate;
begin
  Dec(FLock);
  Changed;
end;

function TcxShellThumbnailOptions.GetSize: TSize;
begin
  Result := cxSize(FWidth, FHeight);
end;

procedure TcxShellThumbnailOptions.Changed;
begin
  if FLock <= 0 then
    DoChange;
end;

procedure TcxShellThumbnailOptions.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TcxShellThumbnailOptions.SetHeight(const Value: Integer);
begin
  if Value <> FHeight then
  begin
    FHeight := Value;
    Changed;
  end;
end;

procedure TcxShellThumbnailOptions.SetShowThumbnails(const Value: Boolean);
begin
  if Value <> FShowThumbnails then
  begin
    FShowThumbnails := Value;
    Changed;
  end;
end;

procedure TcxShellThumbnailOptions.SetSize(const Value: TSize);
begin
  if not cxSizeIsEqual(Value, cxSize(Width, Height)) then
  begin
    FHeight := Value.cx;
    FWidth := Value.cy;
    Changed;
  end;
end;

procedure TcxShellThumbnailOptions.SetWidth(const Value: Integer);
begin
  if Value <> FWidth then
  begin
    FWidth := Value;
    Changed;
  end;
end;

{ TcxDetailItem }

function TcxDetailItem.IsShColumnIdEqual(const AShColumnID: SHCOLUMNID): Boolean;
begin
  Result := IsEqualGUID(AShColumnID.fmtid, ShColumnID.fmtid) and
    (AShColumnID.pid = ShColumnID.pid);
end;

{ TcxShellDetails }

function TcxShellDetails.Add: PcxDetailItem;
begin
  New(Result);
  Items.Add(Result);
end;

procedure TcxShellDetails.Clear;
var
  di:PcxDetailItem;
begin
  while Items.Count<>0 do
  begin
    di:=Items.Last;
    Items.Remove(di);
    Dispose(di);
  end;
end;

constructor TcxShellDetails.Create;
begin
  inherited Create;
  FItems:=TList.Create;
end;

destructor TcxShellDetails.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  inherited;
end;

function TcxShellDetails.GetCount: Integer;
begin
  Result:=Items.Count;
end;

function TcxShellDetails.GetItems(Index: Integer): PcxDetailItem;
begin
  Result:=Items[Index];
end;

procedure TcxShellDetails.ProcessDetails(ACharWidth: Integer; AShellFolder: IShellFolder; AFileSystem: Boolean; AFolderPidl: PItemIDList = nil);
const
  AAlignment: array[0..2] of TAlignment = (taLeftJustify, taRightJustify, taCenter);
var
  AColumnDetails: TShellDetails;
  AColumnFlags: Cardinal;
  AColumnIndex: Integer;
  SD: IShellDetails;
  SF2: IShellFolder2;

  procedure AddItem(AItemInfo: TcxDetailItem);
  var
    ANewColumn: PcxDetailItem;
  begin
    ANewColumn := Add;
    ANewColumn^ := AItemInfo;
  end;

var
  ADefaultColumns: Boolean;
  AShColumnID: SHCOLUMNID;
  AItemInfo: TcxDetailItem;
begin
  ZeroMemory(@AColumnDetails, SizeOf(AColumnDetails));
  AColumnIndex := 0;
  Clear;
  if Succeeded(AShellFolder.QueryInterface(IShellFolder2, SF2)) then
  begin
    ADefaultColumns := False;
    while SF2.GetDetailsOf(nil, AColumnIndex, AColumnDetails) = S_OK do
    begin
      Inc(AColumnIndex);
      AItemInfo.Text := GetTextFromStrRet(AColumnDetails.str, nil);
      AItemInfo.ID := AColumnIndex - 1;
      if (AItemInfo.Text = '') or not Succeeded(SF2.MapColumnToSCID(AItemInfo.ID, AShColumnID)) then
        Continue;

      AItemInfo.Width := AColumnDetails.cxChar * ACharWidth;
      AItemInfo.Alignment := AAlignment[AColumnDetails.fmt];
      AItemInfo.ShColumnID := AShColumnID;
      AItemInfo.Visible := False;

      if Succeeded(SF2.GetDefaultColumnState(AColumnIndex - 1, AColumnFlags)) then
      begin
        AItemInfo.Flags := AColumnFlags;
        if AColumnFlags and SHCOLSTATE_HIDDEN = SHCOLSTATE_HIDDEN then
          Continue;
        ADefaultColumns := ADefaultColumns or (AColumnFlags and SHCOLSTATE_ONBYDEFAULT = SHCOLSTATE_ONBYDEFAULT);
        AItemInfo.Visible := (AColumnFlags and SHCOLSTATE_ONBYDEFAULT = SHCOLSTATE_ONBYDEFAULT);
      end;

      if Assigned(FOnAddDetailItem) then
      begin
        FOnAddDetailItem(Self, AItemInfo);
        AddItem(AItemInfo);
      end
      else
        if AItemInfo.Visible then 
          AddItem(AItemInfo);
    end;
  end
  else
    if GetShellDetails(AShellFolder, nil, SD) = S_OK then
    begin
      while SD.GetDetailsOf(nil, AColumnIndex, AColumnDetails) = S_OK do
      begin
        AItemInfo.Text := GetTextFromStrRet(AColumnDetails.str, nil);
        AItemInfo.Width := AColumnDetails.cxChar * ACharWidth;
        AItemInfo.Alignment := AAlignment[AColumnDetails.fmt];
        AItemInfo.ID := AColumnIndex;
        AddItem(AItemInfo);
        Inc(AColumnIndex);
      end;
    end;
end;

procedure TcxShellDetails.Remove(Item: PcxDetailItem);
begin
  Items.Remove(Item);
  Dispose(Item);
end;

{ TcxDropTarget }

constructor TcxDropSource.Create(AOwner: TWinControl);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TcxDropSource.GiveFeedback(dwEffect: Integer): HResult;
begin
  Result:=DRAGDROP_S_USEDEFAULTCURSORS;
end;

function TcxDropSource.QueryContinueDrag(fEscapePressed: BOOL;
  grfKeyState: Integer): HResult;
begin
  if fEscapePressed then
     Result:=DRAGDROP_S_CANCEL
  else
  if ((grfKeyState and MK_LBUTTON)<>MK_LBUTTON) and
     ((grfKeyState and MK_RBUTTON)<>MK_RBUTTON) then
     Result:=DRAGDROP_S_DROP
  else
     Result:=S_OK;
end;

{ TcxDragDropSettings }

constructor TcxDragDropSettings.Create;
begin
  inherited Create;
  FAllowDragObjects := True;
  FDefaultDropEffect := deMove;
  FDropEffect := [deMove, deCopy, deLink];
end;

procedure TcxDragDropSettings.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TcxDragDropSettings.GetDefaultDropEffectAPI: Integer;
begin
  case DefaultDropEffect of
    deCopy:
      Result := DROPEFFECT_COPY;
    deMove:
      Result := DROPEFFECT_MOVE;
    deLink:
      Result := DROPEFFECT_LINK;
  else
    Result := DROPEFFECT_NONE;
  end;
end;

function TcxDragDropSettings.GetDropEffectAPI: DWORD;
begin
  Result := 0;
  if deCopy in DropEffect then
    Result := Result or DROPEFFECT_COPY;
  if deMove in DropEffect then
    Result := Result or DROPEFFECT_MOVE;
  if deLink in DropEffect then
    Result := Result or DROPEFFECT_LINK;
end;

procedure TcxDragDropSettings.SetAllowDragObjects(Value: Boolean);
begin
  if Value <> FAllowDragObjects then
  begin
    FAllowDragObjects := Value;
    Changed;
  end;
end;

procedure cxShellInitialize;
begin
  FComInitializationSucceeded := Succeeded(OleInitialize(nil));
  FShellLock := TCriticalSection.Create;
  ShellLibrary := LoadLibrary(shell32);
  cxSHGetFolderLocation := GetProcAddress(ShellLibrary, 'SHGetFolderLocation');
  SHChangeNotifyRegister := GetProcAddress(ShellLibrary,PChar(2));
  SHChangeNotifyUnregister := GetProcAddress(ShellLibrary,PChar(4));
  SHChangeNotification_Lock := GetProcAddress(ShellLibrary, PChar(644));
  SHChangeNotification_UnLock := GetProcAddress(ShellLibrary, PChar(645));
  SHGetImageList := GetProcAddress(ShellLibrary, 'SHGetImageList');
  SHCreateIconImageList := GetProcAddress(ShellLibrary, PChar(939));
  cxSHGetPathFromIDList := GetProcAddress(ShellLibrary, 'SHGetPathFromIDListA');
  cxSHGetPathFromIDListW := GetProcAddress(ShellLibrary, 'SHGetPathFromIDListW');
  dxILFindLastID := GetProcAddress(ShellLibrary, 'ILFindLastID');
  dxILIsEqual := GetProcAddress(ShellLibrary, 'ILIsEqual');
  dxILIsParent := GetProcAddress(ShellLibrary, 'ILIsParent');
  dxILLoadFromStreamEx := GetProcAddress(ShellLibrary, 'ILLoadFromStreamEx');
  dxSHGetFolderTypeFromCanonicalName := GetProcAddress(ShellLibrary, PChar(824));
  dxSHDoDragDropWithPreferredEffect := GetProcAddress(ShellLibrary, PChar(884));

  ShlwapiLibrary := LoadLibrary('shlwapi.dll');
  dxSHGetViewStatePropertyBag := GetProcAddress(ShlwapiLibrary, 'SHGetViewStatePropertyBag');
  dxPathIsUNC := GetProcAddress(ShlwapiLibrary, 'PathIsUNCW');
  dxPathIsRelative := GetProcAddress(ShlwapiLibrary, 'PathIsRelativeW');
  dxIUnknown_SetSite := GetProcAddress(ShlwapiLibrary, 'IUnknown_SetSite');
  dxIUnknown_GetClassID := GetProcAddress(ShlwapiLibrary, PChar(175));
  dxAssocQueryString := GetProcAddress(ShlwapiLibrary, 'AssocQueryStringW');
  dxAssocGetPerceivedType := GetProcAddress(ShlwapiLibrary, 'AssocGetPerceivedType');

  PropSysLibrary := LoadLibrary('propsys.dll');
  dxPropVariantToVariant := GetProcAddress(PropSysLibrary, 'PropVariantToVariant');
  dxPSPropertyBag_ReadStream := GetProcAddress(PropSysLibrary, 'PSPropertyBag_ReadStream');
  dxPSPropertyBag_WriteStream := GetProcAddress(PropSysLibrary, 'PSPropertyBag_WriteStream');
  dxPSGetPropertyDescription := GetProcAddress(PropSysLibrary, 'PSGetPropertyDescription');
end;

procedure cxShellUninitialize;
var
  I: Integer;
begin
  if FShellItemsInfoGatherers <> nil then
    for I := 0 to FShellItemsInfoGatherers.Count - 1 do
      TcxShellItemsInfoGatherer(FShellItemsInfoGatherers[I]).DestroyFetchThread;

  FcxMalloc := nil;
  if ShellLibrary <> 0 then
    FreeLibrary(ShellLibrary);
  if ShlwapiLibrary <> 0 then
    FreeLibrary(ShlwapiLibrary);
  if PropSysLibrary <> 0 then
    FreeLibrary(PropSysLibrary);
  FreeAndNil(FShellLock);
  if FComInitializationSucceeded then
    OleUninitialize;
end;

{ TcxShellCustomContextMenu }

procedure TcxShellCustomContextMenu.AddDefaultShellItems(
  AIShellFolder: IShellFolder);
begin
  FContextMenu := nil;
  if Succeeded(AIShellFolder.CreateViewObject(WindowHandle, IID_IContextMenu, FContextMenu)) then
    DoAddDefaultShellItems;
end;

procedure TcxShellCustomContextMenu.AddDefaultShellItems(
  AIShellFolder: IShellFolder; AItemPIDLList: TList);
var
  APIDLs: PITEMIDLISTARRAY;
begin
  APIDLs := CreatePidlArrayFromList(AItemPIDLList);
  try
    if Succeeded(AIShellFolder.GetUIObjectOf(WindowHandle, AItemPIDLList.Count,
      APIDLs[0], IID_IContextMenu, nil, FContextMenu)) then
      DoAddDefaultShellItems;
  finally
    DisposePidlArray(APIDLs);
  end;
end;

constructor TcxShellCustomContextMenu.Create;
begin
  inherited Create;
  FFirstInvokeShellCommandIndex := 200;
end;

destructor TcxShellCustomContextMenu.Destroy;
begin
  DestroyMenu(FMenu);
  inherited Destroy;
end;

procedure TcxShellCustomContextMenu.Popup(APos: TPoint);
begin
  FMenu := CreatePopupMenu;
  try
    Populate;
    DoPopup(APos);
  finally
    DestroyMenu(FMenu);
  end;
end;

procedure TcxShellCustomContextMenu.DoAddDefaultShellItems;
var
  ASite: IUnknown;
begin
  ASite := GetSite;
  if ASite <> nil then
    dxIUnknown_SetSite(FContextMenu, ASite);
  FContextMenu.QueryContextMenu(Menu, GetMenuItemCount(Menu),
    FFirstInvokeShellCommandIndex, $7FFF, GetContextMenuQueryFlags);
end;

procedure TcxShellCustomContextMenu.DoPopup(APos: TPoint);
var
  ACommandId: BOOL;
  AHandle: THandle;
  ACallbackWnd: TcxContextMenuMessageWindow;
  AContextMenu2: IContextMenu2;
begin
  if (FContextMenu <> nil) and Succeeded(FContextMenu.QueryInterface(IID_IContextMenu2, AContextMenu2)) then
    ACallbackWnd := CreateCallbackWnd(AContextMenu2)
  else
    ACallbackWnd := nil;
  try
    if ACallbackWnd <> nil then
      AHandle := ACallbackWnd.Handle
    else
      AHandle := WindowHandle;
    ACommandId := TrackPopupMenu(Menu, TPM_LEFTALIGN or TPM_LEFTBUTTON or
      TPM_RIGHTBUTTON or TPM_RETURNCMD, APos.X, APos.Y, 0, AHandle, nil);
  finally
    FreeAndNil(ACallbackWnd);
  end;
  if ACommandId then
    ExecuteMenuItemCommand(Cardinal(ACommandId));
end;

procedure TcxShellCustomContextMenu.ExecuteMenuItemCommand(ACommandId: Cardinal);
var
  AInvokeCommandInfo: TCMInvokeCommandInfo;
begin
  if (FContextMenu <> nil) and (ACommandId >= FFirstInvokeShellCommandIndex) then
  begin
    ZeroMemory(@AInvokeCommandInfo, SizeOf(AInvokeCommandInfo));
    AInvokeCommandInfo.cbSize := SizeOf(AInvokeCommandInfo);
    AInvokeCommandInfo.hwnd := WindowHandle;
    AInvokeCommandInfo.lpVerb := MakeIntResourceA(ACommandId - FFirstInvokeShellCommandIndex);
    AInvokeCommandInfo.nShow := SW_SHOWNORMAL;
    FContextMenu.InvokeCommand(AInvokeCommandInfo);
  end;
end;

function TcxShellCustomContextMenu.GetContextMenuQueryFlags: Cardinal;
begin
  Result := CMF_NORMAL;
  if GetKeyState(VK_SHIFT) < 0 then
    Result := Result or CMF_EXTENDEDVERBS;
end;

function TcxShellCustomContextMenu.GetSite: IUnknown;
begin
  Result := nil;
end;

function TcxShellCustomContextMenu.IsSameCommand(const ACommandId: Cardinal; const ACommandName: string): Boolean;
var
  AAnsiCommandName: AnsiString;
begin
  SetLength(AAnsiCommandName, Length(ACommandName));
  Result := (FContextMenu.GetCommandString(ACommandId - FFirstInvokeShellCommandIndex, GCS_VERBA, nil,
    PAnsiChar(AAnsiCommandName), Length(ACommandName)) = S_OK) and
    SameText(dxAnsiStringToString(AAnsiCommandName), ACommandName);
end;

{ TdxShellInternalTask }

constructor TdxShellInternalTask.Create(
  AProducer: TcxCustomItemProducer);
begin
  inherited Create;
  FProducer := AProducer;
end;

destructor TdxShellInternalTask.Destroy;
begin
  FProducer := nil;
  inherited Destroy;
end;

procedure TdxShellInternalTask.DoExecute;
begin
end;

procedure TdxShellInternalTask.Execute;
var
  ASucceeded: Boolean;
begin
  ASucceeded := Succeeded(CoInitializeEx(nil, COINIT_APARTMENTTHREADED));
  try
    DoExecute;
  finally
    if ASucceeded then
      CoUninitialize;
  end;
end;

{ TcxCustomItemProducer.TdxShellListViewGetInfoTipTask }

constructor TcxCustomItemProducer.TdxShellListViewGetInfoTipTask.Create(
  AProducer: TcxCustomItemProducer; AItem: TcxShellItemInfo);
begin
  inherited Create(AProducer);
  FItem := AItem;
  FParentShellFolder := Producer.ShellFolder;
  FPidl := GetPidlCopy(AItem.pidl);
end;

destructor TcxCustomItemProducer.TdxShellListViewGetInfoTipTask.Destroy;
begin
  FItem := nil;
  dxFreeAndNilPidl(FPidl);
  inherited Destroy;
end;

procedure TcxCustomItemProducer.TdxShellListViewGetInfoTipTask.Complete;
begin
  TThread.Synchronize(nil, SyncComplete);
end;

procedure TcxCustomItemProducer.TdxShellListViewGetInfoTipTask.DoExecute;
var
  AQueryInfo: IQueryInfo;
  AInfoStr: PWideChar;
begin
  if Succeeded(FParentShellFolder.GetUIObjectOf(0, 1, FPidl, IQueryInfo, nil, AQueryInfo)) and
    Succeeded(AQueryInfo.GetInfoTip(0, AInfoStr)) and (AInfoStr <> nil) then
  begin
    FSucceeded := True;
    FInfoTip := AInfoStr;
    cxMalloc.Free(AInfoStr);
  end;
end;

procedure TcxCustomItemProducer.TdxShellListViewGetInfoTipTask.SyncComplete;
begin
  if FSucceeded and not Canceled then
    Producer.UpdateItemInfoTip(FItem, FInfoTip);
  Producer.FGetInfoTipItemTaskHandles.Remove(Handle);
end;

initialization
  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, cxShellInitialize, cxShellUninitialize);

finalization
  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, cxShellUninitialize);

end.
