{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright (c) 2020 - 2023                               }
{            Email : info@tmssoftware.com                            }
{            Web : https://www.tmssoftware.com                       }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The complete source code remains property of the author and may    }
{ not be distributed, published, given or sold in any form as such.  }
{ No parts of the source code can be included in any other component }
{ or application without written authorization of the author.        }
{********************************************************************}

unit AdvWebBrowser;

{$I TMSDEFS.INC}

{$IFDEF WEBLIB}
{$DEFINE CMNWEBLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}
{$IFDEF CMNLIB}
{$DEFINE CMNWEBLIB}
{$ENDIF}
{$IFDEF LCLLIB}
{$DEFINE LCLWEBLIB}
{$ENDIF}

{$IFDEF MSWINDOWS}
{$DEFINE USEEDGE}
{$ENDIF}

{$IFDEF USEEDGE}
{$DEFINE EDGESUPPORT}
{$ENDIF}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF FMXLIB}
  UITypes, FMX.Types, System.Messaging, FMX.Menus,
  {$ENDIF}
  {$IFDEF VCLLIB}
  VCL.Menus, Messages,
  {$ENDIF}
  {$IFDEF LCLLIB}
  Menus,
  {$ENDIF}
  Types, AdvCustomControl, AdvGraphics, AdvUtils, AdvTypes,
  Classes, TypInfo,
  {$IFNDEF LCLLIB}
  Generics.Collections,
  {$ELSE}
  fgl,
  {$ENDIF}
  {$IFDEF WEBLIB}
  Contnrs, WEBLib.Menus,
  {$ENDIF}
  StdCtrls, Forms, Controls
  {$IFDEF ANDROID}
  ,FMX.Platform.Android, AndroidApi.JNI.Embarcadero, AndroidApi.JNI.App, Androidapi.JNI.GraphicsContentViewText, AndroidApi.JNI.JavaTypes,
  AndroidApi.JNI.Widget, FMX.Helpers.Android, AndroidApi.JNIBridge, AndroidApi.Helpers
  {$ENDIF}
  {$IFDEF IOS}
  ,FMX.Platform.iOS, iOSApi.CocoaTypes, iOSApi.CoreGraphics, iOSApi.UIKit, iOSApi.Foundation,
  Macapi.ObjectiveC, MacApi.ObjcRuntime
  {$ENDIF}
  {$IFDEF MACOS}
  {$IFNDEF IOS}
  ,MacApi.Foundation, MacApi.AppKit, MacApi.CocoaTypes, FMX.Platform.Mac
  {$ENDIF}
  ,MacApi.Helpers
  {$ENDIF}
  ;

const
  {$IFDEF FNCLIB}
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 1; // Minor version nr.
  REL_VER = 5; // Release nr.
  BLD_VER = 2; // Build nr.
  {$ENDIF}
  {$IFNDEF FNCLIB}
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 3; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 2; // Build nr.
  {$ENDIF}
  DESIGNTIMEMESSAGE = 'Selectable/Draggable area (only active at designtime)';

  //v1.0.0.0 : First release
  //v1.0.0.1 : Improved : Interfaces added to Edge Chromium to add JavaScript object injection
  //           (bridge to Delphi) and capture preview capabilities in TAdvWebBrowser
  //1.1.0.0 : New : CaptureScreenShot method
  //        : New : JavaScript bridge support
  //        : Fixed : Issue with Visibility / Parenting in FMX
  //1.1.1.0 : Improved : Support for Microsoft Edge Chromium Stable v85.0.564.41 detection/fallback mechanism
  //1.1.2.0 : Improved : CacheFolderName & ClearCache for defining Edge Chromium cache folder
  //        : Improved : Moved Edge detection entry points and variables to be available at application level
  //1.1.2.1 : Fixed : Issue detecting stable version v86.0.622.38 (copy to temp folder solution)
  //1.1.3.0 : New : CacheFolder, CacheFolderName & AutoClearCache properties
  //        : Improved : Changed ClearCache property to method to manually clear cache
  //        : Fixed : Issues with clearing cache when AutoClearCache = False
  //1.1.4.0 : New : EnableAcceleratorKeys to enable/disable keyboard accelerator keys
  //1.1.4.1 : Fixed : Issue with default value of EnableAcceleratorKeys
  //1.1.4.2 : Fixed : Issue with reparenting in Windows
  //1.1.4.3 : Fixed : Issue with scaling in FMX
  //1.1.4.4 : Fixed : Issue with focus exception in combination with TMS Scripter
  //1.1.4.5 : Fixed : Issue with keyboard handling in macOS
  //1.1.4.6 : Fixed : Issue with border being visible in Linux GTK
  //1.1.4.7 : Fixed : Issue with retaining and releasing focus in macOS
  {$IFDEF FNCLIB}
  //1.1.4.8 : New : Methods added for AdvEdgeWebBrowser
  //1.1.4.9 : Fixed : Issue with the menus unit in Linux Lazarus
  //1.1.5.0 : New : DevTool Protocol methods implemented
  //        : New : Download Manager implemented
  //1.1.5.1 : Fixed : Issue parsing JavaScript functions in WEB
  //1.1.5.2 : Fixed : Edge Chromium fallback implementation causing multiple copies in Windows temp folder during runtime update mechanism
  //1.1.6.0 : New : Additional events added
  //        : Fixed : Issue with download assign in AdvWebBrowser.Win  
  {$ENDIF}
  {$IFNDEF FNCLIB}
  //1.2.0.0 : New : Print and save to PDF
  //        : New : Use popupmenu or manipulate context menu
  //        : New : Manage Cookies
  //        : New : Navigate with custom method and data
  //1.3.0.0 : New : DevTool Protocol methods implemented
  //        : New : Download Manager implemented
  //1.3.0.1 : Fixed : Issue parsing JavaScript functions in WEB
  //1.3.0.2 : Fixed : Edge Chromium fallback implementation causing multiple copies in Windows temp folder during runtime update mechanism
  //1.3.1.0 : New : Additional events added
  //        : Fixed : Issue with download assign in AdvWebBrowser.Win  
  {$ENDIF}
const
  {$IFDEF FNCLIB}
  IID_IAdvCustomWebBrowserGUID = '{F74562D0-56C7-4ED2-B01B-8C9C16DD9361}';
  IID_IAdvCustomWebBrowserExGUID = '{6B5D75C1-B5EC-463D-A602-1FFB97C8668C}';
  IID_IAdvCustomWebBrowserContextMenuGUID = '{04BD0560-104B-4D3B-8CB1-45628D16CB0D}';
  IID_IAdvCustomWebBrowserBridgeGUID = '{AC2934EC-9397-4A99-8E0A-1EF58803C8EA}';
  IID_IAdvCustomWebBrowserSettingsGUID = '{25142510-A807-4635-BAE7-CB261D00137E}';
  IID_IAdvCustomWebBrowserCookiesGUID = '{A50ABF08-0A6F-4877-AC92-FC834CF36AE6}';
  IID_IAdvCustomWebBrowserServiceGUID = '{4B7A5FE1-A889-47C6-B40F-A611BB6266E6}';
  IID_IAdvCustomWebBrowserPrintGUID = '{56EFC9E8-CD92-4FAC-B79C-084BF3DB0FBD}';
  IID_IAdvCustomWebBrowserEdgeGUID = '{BAA1AC1A-4392-4496-A595-47388CC6A083}';
  IID_IAdvCustomWebBrowserInfoGUID = '{307CE047-ED5D-4B5C-87EF-0237EC695C08}';
  {$ELSE}
  IID_IAdvCustomWebBrowserGUID = '{8CE780C0-D22F-4063-993B-CFB0DD7D1351}';
  IID_IAdvCustomWebBrowserExGUID = '{8620B994-4E90-4A43-82A6-62BD445E76F5}';
  IID_IAdvCustomWebBrowserContextMenuGUID = '{45D26565-5CB6-4343-80F0-2E31991C13E1}';
  IID_IAdvCustomWebBrowserBridgeGUID = '{E639C360-3FD0-4F63-9132-E8D0044EF860}';
  IID_IAdvCustomWebBrowserSettingsGUID = '{86DF94BF-9310-4291-B22A-2E791A797E29}';
  IID_IAdvCustomWebBrowserCookiesGUID = '{6B92ADFC-FD76-4708-B8AB-60904123449E}';
  IID_IAdvCustomWebBrowserServiceGUID = '{94C7BF89-2B0A-40DF-8C24-B393CEB91389}';
  IID_IAdvCustomWebBrowserPrintGUID = '{8C4A1B85-CC31-4A4D-9334-6D76DBAC569C}';
  IID_IAdvCustomWebBrowserEdgeGUID = '{CCFBAF21-A278-40DC-AD61-51A70D58EAE4}';
  IID_IAdvCustomWebBrowserInfoGUID = '{A89FBC24-BA7C-486C-8D49-1C8F6D60418D}';
  {$ENDIF}
  IID_IAdvCustomWebBrowser: TGUID = IID_IAdvCustomWebBrowserGUID;
  IID_IAdvCustomWebBrowserBridge: TGUID = IID_IAdvCustomWebBrowserBridgeGUID;
  IID_IAdvCustomWebBrowserSettings: TGUID = IID_IAdvCustomWebBrowserSettingsGUID;
  IID_IAdvCustomWebBrowserCookies: TGUID = IID_IAdvCustomWebBrowserCookiesGUID;
  IID_IAdvCustomWebBrowserService: TGUID = IID_IAdvCustomWebBrowserServiceGUID;
  IID_IAdvCustomWebBrowserEx: TGUID = IID_IAdvCustomWebBrowserExGUID;
  IID_IAdvCustomWebBrowserEdge: TGUID = IID_IAdvCustomWebBrowserEdgeGUID;
  IID_IAdvCustomWebBrowserContextMenu: TGUID = IID_IAdvCustomWebBrowserContextMenuGUID;
  IID_IAdvCustomWebBrowserPrint: TGUID = IID_IAdvCustomWebBrowserPrintGUID;

type
  TAdvWebBrowserJavaScriptCompleteEvent = {$IFNDEF LCLLIB}reference to {$ENDIF}procedure(const AValue: string){$IFDEF LCLLIB} of object{$ENDIF};

  TAdvWebBrowserContextMenuType = (mtPage, mtImage, mtSelectedText, mtAudio, mtVideo, (*not implemented in dll only for Delphi usage*)mtSubMenu);
  TAdvWebBrowserContextMenuItemKind = (ikCommand, ikCheckBox, ikRadioButton, ikSeperator, ikSubMenu);
  TAdvWebBrowserPrintOrientation = (poPortrait, poLandscape);


  TAdvWebBrowserSystemContextMenuItem = class;
  TAdvWebBrowserCustomContextMenuItem = class;

  {$IFNDEF MACOS}
  TAdvWebBrowserSameSiteType = (sstNone, sstLax, sstSameSite);   //Lax means same-site and cross-site
  {$ENDIF}

  TAdvWebBrowserCookie = record
    Path: string;
    Name: string;
    Expires: TDateTime;
    Domain: string;
    Secure: Boolean;
    HTTPOnly: Boolean;
    Value: string;
    Session: Boolean;
    {$IFNDEF MACOS}
    SameSite: TAdvWebBrowserSameSiteType;
    {$ENDIF}
  end;

  TAdvCustomWebBrowser = class;

  TAdvWebBrowserLogSeverityLevel = (lslUnknown, lslVerbose, lslInfo, lslWarning, lslError);
//  TAdvWebBrowserLogSource = (lsOther, lsXML, lsJavascript, lsNetwork, lsStorage, lsAppCache, lsRendering, lsSecurity, lsDeprecation, lsWorker, lsViolation, lsIntervention, lsRecommendation);

  TAdvWebBrowserLogEntry = record
    Level: TAdvWebBrowserLogSeverityLevel;
    Text: string;
//    Source: TAdvWebBrowserLogSource
    Url: string;
    LineNumber: integer;
    TimeStamp: TDateTime;
  end;

  TAdvWebBrowserDownloadInterruptReason = (dirNone, dirFileFailed, dirFileAccessDenied, dirFileNoSpace, dirFileNameTooLong, dirFileTooLarge, dirFileMalicious, dirFileTransientError, dirFileBlockedByPolicy,
    dirFileSecurityCheckFailed, dirFileTooShort, dirFileHasMismatch, dirNetworkFailed, dirNetworkTimeout, dirNetworkDisconnected, dirNetworkServerDown, dirNetworkInvalidRequest, dirServerFailed, dirServerNoRange,
    dirServerBadContent, dirServerUnauthorized, dirServerCertificateProblem, dirServerForbidden, dirServerUnexpectedResponse, dirServerContentLengthMismatch, dirServerCrossOriginRedirect, dirUserCanceled,
    dirUserShutdown, dirUserPaused, dirDownloadProcessCrashed);

  TAdvWebBrowserDownloadState = (dsInProgress, dsInterrupted, dsCompleted, dsCancelled);

  TAdvWebBrowserDownload = class(TCollectionItem)
  private
    FOwner: TAdvCustomWebBrowser;
    FDataPointer: Pointer;
    FDataBoolean: Boolean;
    FDataString: String;
    FDataObject: TObject;
    FDataInteger: NativeInt;
    FInterruptReason: TAdvWebBrowserDownloadInterruptReason;
    FCanResume: Boolean;
    FState: TAdvWebBrowserDownloadState;
    FBytesReceived: Int64;
    FMimeType: string;
    FURI: string;
    FTotalBytes: Int64;
    FResultFilePath: string;
    procedure SetResultFilePath(const Value: string);
  protected
    FInternalOperationInterface: IInterface;
    procedure SetURI(const Value: string);
    procedure SetTotalBytes(const Value: Int64);
    procedure SetBytesReceived(const Value: Int64);
    procedure SetState(const Value: TAdvWebBrowserDownloadState);
    procedure SetInterruptReason(const Value: TAdvWebBrowserDownloadInterruptReason);
    procedure SetMimeType(const Value: string);
    procedure SetCanResume(const Value: boolean);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Cancel;
    procedure Pause;
    procedure Resume;
    property URI: string read FURI;
    property ResultFilePath: string read FResultFilePath write SetResultFilePath;
    property State: TAdvWebBrowserDownloadState read FState;
    property InterruptReason: TAdvWebBrowserDownloadInterruptReason read FInterruptReason;
    property BytesReceived: Int64 read FBytesReceived;
    property TotalBytes: Int64 read FTotalBytes;
    property MimeType: string read FMimeType;
    property CanResume: Boolean read FCanResume;
    property DataPointer: Pointer read FDataPointer write FDataPointer;
    property DataBoolean: Boolean read FDataBoolean write FDataBoolean;
    property DataObject: TObject read FDataObject write FDataObject;
    property DataString: String read FDataString write FDataString;
    property DataInteger: NativeInt read FDataInteger write FDataInteger;
  end;

  {$IFDEF WEBLIB}
  TAdvWebBrowserDownloads = class(TAdvOwnedCollection)
  {$ELSE}
  TAdvWebBrowserDownloads = class({$IFDEF LCLLIB}specialize {$ENDIF}TAdvOwnedCollection<TAdvWebBrowserDownload>)
  {$ENDIF}
  private
    FOwner: TAdvCustomWebBrowser;
    function GetItem(Index: Integer): TAdvWebBrowserDownload;
    procedure SetItem(Index: Integer; const Value: TAdvWebBrowserDownload);
  protected
    function CreateItemClass: TCollectionItemClass; virtual;
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TAdvCustomWebBrowser); virtual;
    property Items[Index: Integer]: TAdvWebBrowserDownload read GetItem write SetItem; default;
    function Add: TAdvWebBrowserDownload;
    function Insert(Index: Integer): TAdvWebBrowserDownload;
    procedure ClearFinishedDownloads;
    function GetDownloadByURI(AURI: string): TAdvWebBrowserDownload;
  end;

  TAdvWebBrowserTargetItem = record
    Kind: TAdvWebBrowserContextMenuType;
    URI: string;
    SelectionText: string;
    LinkText: string;
  end;

  TAdvWebBrowserContextMenuItem = class;

  TAdvWebBrowserContextMenuItemList = class(TObjectList<TAdvWebBrowserContextMenuItem>);

  TAdvWebBrowserContextMenuItem = class(TPersistent)
  private
    FParentItem: TAdvWebBrowserContextMenuItem;
    FName: string;
    FText: string;
    FChildren: TAdvWebBrowserContextMenuItemList;
    FCommandId: Integer;
    FEnabled: Boolean;
    FShortcutKeyDescription: string;
    FKind: TAdvWebBrowserContextMenuItemKind;
    FChecked: Boolean;
    FOriginalIndex: Integer;
    FInternalObject: TObject;
    FDataPointer: Pointer;
    FDataBoolean: Boolean;
    FDataString: String;
    FDataObject: TObject;
    FDataInteger: NativeInt;
    FIcon: TAdvBitmap;
    FEventHandlerObject: TObject;
    procedure SetShortcutKeyDescription(const Value: string);
  protected
    property Name: string read FName write FName;
    property Text: string read FText write FText;
    property Children: TAdvWebBrowserContextMenuItemList read FChildren write FChildren;
    property OriginalIndex: Integer read FOriginalIndex write FOriginalIndex;
    property CommandId: Integer read FCommandId write FCommandId;
    property ShortcutKeyDescription: string read FShortcutKeyDescription write SetShortcutKeyDescription;
    property Icon: TAdvBitmap read FIcon write FIcon;
    property Kind: TAdvWebBrowserContextMenuItemKind read FKind write FKind;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Checked: Boolean read FChecked write FChecked;
    property InternalObject: TObject read FInternalObject write FInternalObject;
    property EventHandlerObject: TObject read FEventHandlerObject write FEventHandlerObject;
    property ParentItem: TAdvWebBrowserContextMenuItem read FParentItem write FParentItem;
  public
    constructor Create;
    destructor Destroy; override;
    function AsCustom: TAdvWebBrowserCustomContextMenuItem;
    function AsSystem: TAdvWebBrowserSystemContextMenuItem;
    property DataPointer: Pointer read FDataPointer write FDataPointer;
    property DataBoolean: Boolean read FDataBoolean write FDataBoolean;
    property DataObject: TObject read FDataObject write FDataObject;
    property DataString: String read FDataString write FDataString;
    property DataInteger: NativeInt read FDataInteger write FDataInteger;
  end;

  TAdvWebBrowserSystemContextMenuItem = class(TAdvWebBrowserContextMenuItem)
  private
    function GetName: string;
    function GetText: string;
    function GetChildren: TObjectList<TAdvWebBrowserContextMenuItem>;
    function GetKind: TAdvWebBrowserContextMenuItemKind;
    function GetChecked: Boolean;
    function GetEnabled: Boolean;
    function GetIcon: TAdvBitmap;
    function GetParentItem: TAdvWebBrowserContextMenuItem;
  public
    property Name: string read GetName;
    property Text: string read GetText;
    property Children: TObjectList<TAdvWebBrowserContextMenuItem> read GetChildren;
    property Kind: TAdvWebBrowserContextMenuItemKind read GetKind;
    property Enabled: Boolean read GetEnabled;
    property Checked: Boolean read GetChecked;
    property Icon: TAdvBitmap read GetIcon;
    property ParentItem: TAdvWebBrowserContextMenuItem read GetParentItem;
  end;

  TAdvWebBrowserCustomContextMenuItem = class(TAdvWebBrowserContextMenuItem)
  private
    function GetParentItem: TAdvWebBrowserContextMenuItem;
  public
    property Name;
    property Text;
    property Children;
    property Kind;
    property Enabled;
    property Checked;
    property Icon;
    property ParentItem: TAdvWebBrowserContextMenuItem read GetParentItem;
  end;

  TAdvWebBrowserPrintSettings = record
    Orientation: TAdvWebBrowserPrintOrientation;
    ScaleFactor: Double;
    PageWidth: Integer;
    PageHeight: Integer;
    MarginLeft: Integer;
    MarginTop: Integer;
    MarginRight: Integer;
    MarginBottom: Integer;
    PrintBackgrounds: Boolean;
    PrintSelectionOnly: Boolean;
    PrintHeaderAndFooter: Boolean;
    HeaderTitle: string;
    FooterURI: string;
  end;

  TAdvWebBrowserOnGetContextMenu = procedure(Sender: TObject; ATarget: TAdvWebBrowserTargetItem; AContextMenu: TObjectList<TAdvWebBrowserContextMenuItem>) of object;
  TAdvWebBrowserOnGetPopupMenuForContextMenu = procedure(Sender: TObject; ATarget: TAdvWebBrowserTargetItem; var APopupMenu: TPopupMenu) of object;
  TAdvWebBrowserOnCustomContextMenuItemSelected = procedure(Sender: TObject; ASelectedItem: TAdvWebBrowserCustomContextMenuItem) of object;
  TAdvWebBrowserOnGetCookies = procedure(Sender: TObject; ACookies: array of TAdvWebBrowserCookie) of object;
  TAdvWebBrowserOnGetPrintPDFStream = procedure(Sender: TObject; AStream: TMemoryStream) of object;
  TAdvWebBrowserOnGetDevTools = procedure(Sender: TObject; AEventName: string; AJSONResponse: string) of object;
  TAdvWebBrowserOnDownloadStarted = procedure(Sender: TObject; ADownload: TAdvWebBrowserDownload; var ASilent: Boolean; var APause: Boolean; var AResume: Boolean; var ACancel: Boolean) of object;
  TAdvWebBrowserOnDownloadStateChanged = procedure(Sender: TObject; ADownload: TAdvWebBrowserDownload; AState: TAdvWebBrowserDownloadState; var APause: Boolean; var AResume: Boolean; var ACancel: Boolean) of object;
  TAdvWebBrowserOnDownloadBytesChanged = procedure(Sender: TObject; ADownload: TAdvWebBrowserDownload; ABytesReceived: Int64; var APause: Boolean; var AResume: Boolean; var ACancel: Boolean) of object;

  IAdvCustomWebBrowserBridge = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserBridgeGUID]
  {$ENDIF}
    function GetObjectMessage: string;
    procedure SetObjectMessage(const AValue: string);
    property ObjectMessage: string read GetObjectMessage write SetObjectMessage;
  end;

  IAdvCustomWebBrowser = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserGUID]
  {$ENDIF}
    procedure SetFocus;
    procedure SetUserAgent(const AValue: string);
    procedure SetURL(const AValue: string);
    procedure SetExternalBrowser(const AValue: Boolean);
    procedure SetEnableContextMenu(const AValue: Boolean);
    procedure SetEnableShowDebugConsole(const AValue: Boolean);
    procedure SetEnableAcceleratorKeys(const AValue: Boolean);
    procedure SetCacheFolderName(const Value: string);
    procedure SetAutoClearCache(const Value: Boolean);
    procedure SetCacheFolder(const Value: string);
    procedure Navigate(const AURL: String); overload;
    procedure Navigate; overload;
    procedure LoadHTML(AHTML: String);
    procedure LoadFile(AFile: String);
    procedure GoForward;
    procedure GoBack;
    procedure Reload;
    procedure Close;
    procedure StopLoading;
    procedure AddBridge(ABridgeName: string; ABridgeObject: TObject);
    procedure RemoveBridge(ABridgeName: string);
    procedure UpdateBounds;
    procedure CaptureScreenShot;
    procedure UpdateVisible;
    procedure UpdateEnabled;
    procedure BeforeChangeParent;
    procedure Initialize;
    procedure DeInitialize;
    procedure ClearCache;
    procedure ShowDebugConsole;
    function GetUserAgent: string;
    function GetURL: string;
    function GetExternalBrowser: Boolean;
    function GetEnableContextMenu: Boolean;
    function GetEnableShowDebugConsole: Boolean;
    function GetEnableAcceleratorKeys: Boolean;
    procedure ExecuteJavaScript(AScript: String; ACompleteEvent: TAdvWebBrowserJavaScriptCompleteEvent; ACallback: TNotifyEvent);
    function NativeEnvironment: Pointer;
    function NativeBrowser: Pointer;
    function GetBrowserInstance: IInterface;
    function CanGoBack: Boolean;
    function CanGoForward: Boolean;
    function NativeDialog: Pointer;
    function IsFMXBrowser: Boolean;
    function GetCacheFolderName: string;
    function GetAutoClearCache: Boolean;
    function GetCacheFolder: string;
    procedure UpdateContentFromControl;
    property UserAgent: string read GetUserAgent write SetUserAgent;
    property CacheFolderName: string read GetCacheFolderName write SetCacheFolderName;
    property CacheFolder: string read GetCacheFolder write SetCacheFolder;
    property AutoClearCache: Boolean read GetAutoClearCache write SetAutoClearCache;
    property URL: string read GetURL write SetURL;
    property ExternalBrowser: Boolean read GetExternalBrowser write SetExternalBrowser;
    property EnableContextMenu: Boolean read GetEnableContextMenu write SetEnableContextMenu;
    property EnableShowDebugConsole: Boolean read GetEnableShowDebugConsole write SetEnableShowDebugConsole;
    property EnableAcceleratorKeys: Boolean read GetEnableAcceleratorKeys write SetEnableAcceleratorKeys;
  end;

  IAdvCustomWebBrowserEx = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserExGUID]
  {$ENDIF}
    procedure OpenTaskManagerWindow;
    procedure NavigateWithData(AURI: string; AMethod: string; ABody: string; AHeaders: TStrings = nil); overload;
    procedure NavigateWithData(AURI: string; AMethod: string; ABodyStream: TStream; AHeaders: TStrings = nil); overload;
  end;

  IAdvCustomWebBrowserInfo = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserInfoGUID]
  {$ENDIF}
    function GetDocumentTitle: string;
    function GetContainsFullScreenElement: Boolean;
    function GetParentWindowHandle: Cardinal;
    function GetBrowserVersion: string;
    function GetUserDataFolder: string;
  end;

  IAdvCustomWebBrowserSettings = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserSettingsGUID]
  {$ENDIF}
    function GetEnableScript: Boolean;
    procedure SetEnableScript(const Value: Boolean);
    function GetAllowExternalDrop: Boolean;
    procedure SetAllowExternalDrop(const Value: Boolean);
    property EnableScript: boolean read GetEnableScript write SetEnableScript;
    property AllowExternalDrop: boolean read GetAllowExternalDrop write SetAllowExternalDrop;
  end;

  IAdvCustomWebBrowserCookies = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserCookiesGUID]
  {$ENDIF}
    procedure GetCookies(AURI: string);
    procedure AddCookie(ACookie: TAdvWebBrowserCookie);
    procedure DeleteAllCookies;
    procedure DeleteCookie(AName: string; ADomain: string; APath: string);
  end;

  IAdvCustomWebBrowserEdge = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserEdgeGUID]
  {$ENDIF}
    procedure SubscribeDevtools(AEventName: string);
    procedure CallDevToolsProtocolMethod(AMethodName: string; AParametersAsJSON: string);
    procedure EnableDevToolDomain(AEventName: string; AJSONParameters: string = '');
    procedure DisableDevToolDomain(ADomain: string);
    procedure SetupStartDomains;
    procedure CancelDownload(ADownload: TAdvWebBrowserDownload);
    procedure PauseDownload(ADownload: TAdvWebBrowserDownload);
    procedure ResumeDownload(ADownload: TAdvWebBrowserDownload);
  end;

  IAdvCustomWebBrowserContextMenu = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserContextMenuGUID]
  {$ENDIF}
  end;

  IAdvCustomWebBrowserPrint = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserPrintGUID]
  {$ENDIF}
    procedure ShowPrintUI;
    procedure Print; overload;
    procedure Print(APrintSettings: TAdvWebBrowserPrintSettings); overload;
    procedure PrintToPDFStream(APrintSettings: TAdvWebBrowserPrintSettings); overload;
    procedure PrintToPDFStream; overload;
    procedure PrintToPDF(AFileName: string; APrintSettings: TAdvWebBrowserPrintSettings); overload;
    procedure PrintToPDF(AFileName: string); overload;
  end;

  IAdvWebBrowserService = interface(IInterface)
  {$IFNDEF WEBLIB}
  [IID_IAdvCustomWebBrowserServiceGUID]
  {$ENDIF}
    function CreateWebBrowser(const AValue: TAdvCustomWebBrowser): IAdvCustomWebBrowser;
    procedure DeleteCookies;
    procedure DestroyWebBrowser(const AValue: IAdvCustomWebBrowser);
  end;

  TAdvCustomWebBrowserNavigateCompleteParams = record
    URL: String;
    Success: Boolean;
    ErrorCode: Integer;
  end;

  TAdvCustomWebBrowserBeforeNavigateParams = record
    URL: String;
    Cancel: Boolean;
  end;

  TAdvCustomWebBrowserFrameNavigateCompleteParams = record
    URL: String;
    Success: Boolean;
    ErrorCode: Integer;
  end;

  TAdvCustomWebBrowserBeforeFrameNavigateParams = record
    URL: String;
    Cancel: Boolean;
  end;

  TAdvWebBrowserNewWindowRequestedParams = record
    URL: String;
    Handled: Boolean;
    IsUserInitiated: Boolean;
  end;

  TAdvWebBrowserPermissionKind = (pkUnknown, pkMicrophone, pkCamera, pkGeolocation, pkNotifications, pkOtherSensors, pkClipboardRead);
  TAdvWebBrowserPermissionState = (psDefault, psAllow, psDeny);

  TAdvWebBrowserPermissionRequestedParams = record
    State: TAdvWebBrowserPermissionState;
    URL: String;
    PermissionKind: TAdvWebBrowserPermissionKind;
    IsUserInitiated: Boolean;
  end;

  TAdvWebBrowserProcessFailedKind = (pfkBrowserProcessExited, pfkRenderProcessExited, pfkRenderProcessUnresponsive, pfkFrameRenderProcessExited, pfkUtilityProcessExited,
      pfkSandboxHelperProcessExited, pfkGpuProcessExited, pfkPpapiPluginProcessExited, pfkPpapiBrokerProcessExited, pfkUnknownProcessExited);

  TAdvWebBrowserProcessFailedParams = record
    ProcessFailedKind: TAdvWebBrowserProcessFailedKind;
  end;

  TAdvWebBrowserScriptDialogKind = (sdkAlert, sdkConfirm, sdkPrompt, sdkBeforeUnload, sdkUnknown);

  TAdvWebBrowserScriptDialogOpeningParams = record
    URL: String;
    ResultText: String;
    Accept: Boolean;
    DialogMessage: String;
    DialogKind: TAdvWebBrowserScriptDialogKind;
    DefaultText: String;
  end;

  TAdvWebBrowserSourceChangedParams = record
    IsNewDocument: Boolean;
  end;

  TAdvWebBrowserWebMessageReceivedParams = record
    Source: String;
    WebMessageAsJSON: String;
  end;

  TAdvWebBrowserWebResourceRequest = record
    URL: String;
    Method: String;
  end;

  TAdvWebBrowserWebResourceContext = (wrcAll, wrcDocument, wrcStylesheet, wrcImage, wrcMedia, wrcFont, wrcScript, wrcXMLHTTPRequest, wrcFetch, wrcTextTrack, wrcEventSource, wrcWebSocket, wrcManifest, wrcSignedExchange, wrcPing, wrcCSPViolationReport, wrcOther);

  TAdvWebBrowserWebResourceRequestedParams = record
    Request: TAdvWebBrowserWebResourceRequest;
    ResourceContext: TAdvWebBrowserWebResourceContext;
  end;

  TAdvCustomWebBrowserNavigateComplete = procedure(Sender: TObject; var Params: TAdvCustomWebBrowserNavigateCompleteParams) of object;
  TAdvCustomWebBrowserBeforeNavigate = procedure(Sender: TObject; var Params: TAdvCustomWebBrowserBeforeNavigateParams) of object;
  TAdvCustomWebBrowserCaptureScreenShot = procedure(Sender: TObject; AScreenShot: TAdvBitmap) of object;
  TAdvCustomWebBrowserOnExecuteSuccessful = procedure(Sender: TObject; ASuccessful: Boolean) of object;
  TAdvCustomWebBrowserOnGetConsoleMessage = procedure(Sender: TObject; ALogEntry: TAdvWebBrowserLogEntry) of object;
  TAdvWebBrowserFrameNavigateComplete = procedure(Sender: TObject; var Params: TAdvCustomWebBrowserFrameNavigateCompleteParams) of object;
  TAdvWebBrowserBeforeFrameNavigate = procedure(Sender: TObject; var Params: TAdvCustomWebBrowserBeforeFrameNavigateParams) of object;
  TAdvWebBrowserNewWindowRequested = procedure(Sender: TObject; var Params: TAdvWebBrowserNewWindowRequestedParams) of object;
  TAdvWebBrowserPermissionRequested = procedure(Sender: TObject; var Params: TAdvWebBrowserPermissionRequestedParams) of object;
  TAdvWebBrowserProcessFailed = procedure(Sender: TObject; var Params: TAdvWebBrowserProcessFailedParams) of object;
  TAdvWebBrowserScriptDialogOpening = procedure(Sender: TObject; var Params: TAdvWebBrowserScriptDialogOpeningParams) of object;
  TAdvWebBrowserSourceChanged = procedure(Sender: TObject; var Params: TAdvWebBrowserSourceChangedParams) of object;
  TAdvWebBrowserWebMessageReceivedChanged = procedure(Sender: TObject; var Params: TAdvWebBrowserWebMessageReceivedParams) of object;
  TAdvWebBrowserWebResourceRequested = procedure(Sender: TObject; var Params: TAdvWebBrowserWebResourceRequestedParams) of object;

  {$IFNDEF WEBLIB}
  TAdvWebBrowserDocumentReadyStateThread = class(TThread)
  private
    FWebBrowser: TAdvCustomWebBrowser;
  protected
    procedure Execute; override;
  public
    constructor Create(AWebBrowser: TAdvCustomWebBrowser);
  end;
  {$ENDIF}

  {$IFNDEF WEBLIB}
  TAdvScript = class
  private
    FScript: string;
    FCompleteEvent: TAdvWebBrowserJavaScriptCompleteEvent;
  public
    constructor Create(AScript: string; ACompleteEvent: TAdvWebBrowserJavaScriptCompleteEvent);
  end;

  TAdvScriptList = class(TObjectList<TAdvScript>);
  {$ENDIF}

  TAdvCustomWebBrowserSettings = class(TPersistent)
  private
    FOwner: TAdvCustomWebBrowser;
    FAllowExternalDrop: Boolean;
    FEnableScript: Boolean;
    FEnableAcceleratorKeys: Boolean;
    FEnableContextMenu: Boolean;
    FEnableShowDebugConsole: Boolean;
    FUsePopupMenuAsContextMenu: Boolean;
    function GetEnableAcceleratorKeys: Boolean;
    function GetEnableContextMenu: Boolean;
    function GetEnableScript: Boolean;
    function GetEnableShowDebugConsole: Boolean;
    procedure SetEnableAcceleratorKeys(const Value: Boolean);
    procedure SetEnableContextMenu(const Value: Boolean);
    procedure SetEnableShowDebugConsole(const Value: Boolean);
    procedure SetEnableScript(const Value: boolean);
    function GetUsePopupMenuAsContextMenu: Boolean;
    procedure SetUsePopupMenuAsContextMenu(const Value: Boolean);
    function GetAllowExternalDrop: Boolean;
    procedure SetAllowExternalDrop(const Value: Boolean);
  protected
    procedure ApplySettings;
    property EnableScript: Boolean read GetEnableScript write SetEnableScript;
    property EnableContextMenu: Boolean read GetEnableContextMenu write SetEnableContextMenu;
    property EnableShowDebugConsole: Boolean read GetEnableShowDebugConsole write SetEnableShowDebugConsole;
    property EnableAcceleratorKeys: Boolean read GetEnableAcceleratorKeys write SetEnableAcceleratorKeys;
    property UsePopupMenuAsContextMenu: Boolean read GetUsePopupMenuAsContextMenu write SetUsePopupMenuAsContextMenu;
    property AllowExternalDrop: Boolean read GetAllowExternalDrop write SetAllowExternalDrop;
  public
    constructor Create(AOwner: TAdvCustomWebBrowser);
    destructor Destroy; override;
  end;

  TAdvWebBrowserSettings = class(TAdvCustomWebBrowserSettings)
  published
//    property EnableScript;
    property EnableContextMenu;
    property EnableShowDebugConsole;
    property EnableAcceleratorKeys;
    property AllowExternalDrop;
    property UsePopupMenuAsContextMenu;
  end;

  TAdvCustomWebBrowser = class(TAdvCustomControl)
  private
    FInitializeEventCalled: Boolean;
    FDesigntimeEnabled: Boolean;
    FCanDestroyDispatch: Boolean;
    FSyncValue: string;
    FSyncValueExecuted: Boolean;
    FThreadDone: Boolean;
    FReady: Boolean;
    FInitialized: Boolean;
    {$IFNDEF WEBLIB}
    FScriptList: TAdvScriptList;
    FDocumentReadyStateThread: TAdvWebBrowserDocumentReadyStateThread;
    {$ENDIF}
    FWebBrowser: IAdvCustomWebBrowser;
    FURL: string;
    FExternalBrowser, FEnableShowDebugConsole, FEnableAcceleratorKeys, FEnableContextMenu: Boolean;
    FOnNavigateComplete: TAdvCustomWebBrowserNavigateComplete;
    FOnBeforeNavigate: TAdvCustomWebBrowserBeforeNavigate;
    FOnHardwareButtonClicked: TNotifyEvent;
    FOnInitialized: TNotifyEvent;
    FOnCloseForm: TNotifyEvent;
    FOnDocumentComplete: TNotifyEvent;
    FOnCaptureScreenShot: TAdvCustomWebBrowserCaptureScreenShot;
    FSettings: TAdvWebBrowserSettings;
    FOnGetContextMenu: TAdvWebBrowserOnGetContextMenu;
    FOnGetCookies: TAdvWebBrowserOnGetCookies;
    FOnGetPrintPDFStream: TAdvWebBrowserOnGetPrintPDFStream;
    FOnPrintedToPDF: TAdvCustomWebBrowserOnExecuteSuccessful;
    FOnPrinted: TAdvCustomWebBrowserOnExecuteSuccessful;
    FOnCustomContextMenuItemSelected: TAdvWebBrowserOnCustomContextMenuItemSelected;
    FOnGetPopupMenuForContextMenu: TAdvWebBrowserOnGetPopupMenuForContextMenu;
    FOnDevToolsSubscribedEvent: TAdvWebBrowserOnGetDevTools;
    FOnDevToolsMethodCompleted: TAdvWebBrowserOnGetDevTools;
    FOnGetConsoleMessage: TAdvCustomWebBrowserOnGetConsoleMessage;
    FOnDownloadStarted: TAdvWebBrowserOnDownloadStarted;
    FDownloads: TAdvWebBrowserDownloads;
    FOnDownloadStateChanged: TAdvWebBrowserOnDownloadStateChanged;
    FOnDownloadBytesReceivedChanged: TAdvWebBrowserOnDownloadBytesChanged;
    FOnContainsFullScreenElementChanged: TNotifyEvent;
    FOnDocumentTitleChanged: TNotifyEvent;
    FOnFrameNavigateComplete: TAdvWebBrowserFrameNavigateComplete;
    FOnBeforeFrameNavigate: TAdvWebBrowserBeforeFrameNavigate;
    FOnHistoryChanged: TNotifyEvent;
    FOnNewWindowRequested: TAdvWebBrowserNewWindowRequested;
    FOnPermissionRequested: TAdvWebBrowserPermissionRequested;
    FOnProcessFailed: TAdvWebBrowserProcessFailed;
    FOnScriptDialogOpening: TAdvWebBrowserScriptDialogOpening;
    FOnSourceChanged: TAdvWebBrowserSourceChanged;
    FOnWebMessageReceived: TAdvWebBrowserWebMessageReceivedChanged;
    FOnWebResourceRequested: TAdvWebBrowserWebResourceRequested;
    FOnWindowCloseRequested: TNotifyEvent;
    FOnZoomFactorChanged: TNotifyEvent;
    function GetURL: string;
    procedure SetURL(const Value: string);
    function GetExternalBrowser: Boolean;
    procedure SetExternalBrowser(const Value: Boolean);
    function GetEnableContextMenu: Boolean;
    function GetEnableShowDebugConsole: Boolean;
    procedure SetEnableContextMenu(const Value: Boolean);
    procedure SetEnableShowDebugConsole(const Value: Boolean);
    function GetCacheFolder: string;
    function GetCacheFolderName: string;
    function GetAutoClearCache: Boolean;
    procedure SetCacheFolder(const Value: string);
    procedure SetCacheFolderName(const Value: string);
    procedure SetAutoClearCache(const Value: Boolean);
    procedure SetDesigntimeEnabled(const Value: Boolean);
    function GetEnableAcceleratorKeys: Boolean;
    procedure SetEnabledAcceleratorKeys(const Value: Boolean);
    function GetUserAgent: string;
    procedure SetUserAgent(const Value: string);
    procedure DoExecuteJavaScriptSync(const AValue: string);
    procedure SetSettings(const Value: TAdvWebBrowserSettings);
    function GetSettingsI: IAdvCustomWebBrowserSettings;
    {$IFDEF FMXLIB}
    {$HINTS OFF}
    {$IF COMPILERVERSION > 32}
    procedure FormHandleCreated(const Sender: TObject; const Msg: TMessage);
    {$IFEND}
    {$HINTS ON}
    {$ENDIF}
    {$IFDEF VCLLIB}
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    {$ENDIF}
  protected
    {$IFDEF LCLLIB}
    {$IFDEF UNIX}
    {$IFDEF LCLGTK3}
    class procedure WSRegisterClass; override;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}

    function GetDocURL: string; override;
    function GetVersion: string; override;
    function CanCreateBrowser: Boolean;
    function CanBeVisible: Boolean; virtual;
    function CheckIdentifier: Boolean; virtual;
    class procedure DeleteCookies; virtual;
    {$IFNDEF WEBLIB}
    procedure StartDocumentReadyStateThread; virtual;
    procedure DoTerminate(Sender: TObject);
    procedure StopDocumentReadyStateThread;
    procedure DoScriptHandled(Sender: TObject);
    {$ENDIF}
    {$IFDEF WEBLIB}
    procedure UpdateElement; override;
    {$ENDIF}
    procedure DoEnter; override;
    procedure ChangeDPIScale({%H-}M, {%H-}D: Integer); override;
    procedure CreateClasses; virtual;
    procedure DoDocumentComplete; virtual;
    procedure CheckApplicationInitialized;
    procedure DoCheckReadyState(const AValue: string);
    procedure DoCheckIdentifier(const AValue: string);
    procedure DoHardwareButtonClicked; virtual;
    procedure DoCloseForm; virtual;
    procedure DoCaptureScreenShot(AScreenShot: TAdvBitmap); virtual;
    procedure BeforeNavigate(var Params: TAdvCustomWebBrowserBeforeNavigateParams); virtual;
    procedure NavigateComplete(var Params: TAdvCustomWebBrowserNavigateCompleteParams); virtual;
    procedure Initialized; virtual;
    {$IFDEF FMXLIB}
    procedure AncestorVisibleChanged(const Visible: Boolean); override;
    procedure SetParent(const Value: TFmxObject); override;
    procedure SetVisible(const Value: Boolean); override;
    procedure SetEnabled(const Value: Boolean); override;
    {$ENDIF}
    {$IFDEF CMNWEBLIB}
    {$IFDEF CMNLIB}
    procedure SetParent(Value: TWinControl); override;
    {$ELSE}
    procedure SetParent(Value: TControl); override;
    {$ENDIF}
    procedure SetEnabled(Value: Boolean); override;
    {$ENDIF}
    procedure DoKeyPressed(var Key: Word); virtual;
    procedure Draw({%H-}AGraphics: TAdvGraphics; {%H-}ARect: TRectF); override;
    procedure Loaded; override;
    property OnInitialized: TNotifyEvent read FOnInitialized write FOnInitialized;
    property ExternalBrowser: Boolean read GetExternalBrowser write SetExternalBrowser default False;
    procedure Navigate; overload; virtual;
    procedure Navigate(const AURL: string); overload; virtual;
    procedure ExecuteJavaScript(AScript: String; ACompleteEvent: TAdvWebBrowserJavaScriptCompleteEvent = nil; AImmediate: Boolean = False); virtual;
    function ExecuteJavaScriptSync(AScript: string): string; virtual;
    procedure LoadHTML(AHTML: String); virtual;
    procedure LoadFile(AFile: String); virtual;
    procedure Initialize; virtual;
    procedure DeInitialize; virtual;
    procedure GoForward; virtual;
    procedure GoBack; virtual;
    procedure Reload; virtual;
    procedure StopLoading; virtual;
    procedure AddBridge(ABridgeName: string; ABridgeObject: TObject); virtual;
    procedure RemoveBridge(ABridgeName: string); virtual;
    procedure CaptureScreenShot; virtual;
    procedure ShowDebugConsole; virtual;
    property URL: string read GetURL write SetURL;
    property SettingsI: IAdvCustomWebBrowserSettings read GetSettingsI;
    function GetBridgeCommunicationLayer(ABridgeName: string): string; virtual;
    function NativeEnvironment: Pointer; virtual;
    function NativeBrowser: Pointer; virtual;
    function IsFMXBrowser: Boolean; virtual;
    function CanGoBack: Boolean; virtual;
    function CanGoForward: Boolean; virtual;
    {$IFDEF ANDROID}
    function NativeDialog: Pointer; virtual;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    function GetWebBrowserInstance: IInterface; virtual;
    {$ENDIF}
    property OnCloseForm: TNotifyEvent read FOnCloseForm write FOnCloseForm;
    property OnBeforeNavigate: TAdvCustomWebBrowserBeforeNavigate read FOnBeforeNavigate write FOnBeforeNavigate;
    property OnNavigateComplete: TAdvCustomWebBrowserNavigateComplete read FOnNavigateComplete write FOnNavigateComplete;
    property OnHardwareButtonClicked: TNotifyEvent read FOnHardwareButtonClicked write FOnHardwareButtonClicked;
    property OnDocumentComplete: TNotifyEvent read FOnDocumentComplete write FOnDocumentComplete;
    property OnCaptureScreenShot: TAdvCustomWebBrowserCaptureScreenShot read FOnCaptureScreenShot write FOnCaptureScreenShot;
    property EnableContextMenu: Boolean read GetEnableContextMenu write SetEnableContextMenu default True;
    property EnableShowDebugConsole: Boolean read GetEnableShowDebugConsole write SetEnableShowDebugConsole default True;
    property EnableAcceleratorKeys: Boolean read GetEnableAcceleratorKeys write SetEnabledAcceleratorKeys default True;
    property CacheFolder: string read GetCacheFolder write SetCacheFolder;
    property CacheFolderName: string read GetCacheFolderName write SetCacheFolderName;
    property AutoClearCache: Boolean read GetAutoClearCache write SetAutoClearCache;
    property UserAgent: string read GetUserAgent write SetUserAgent;
    property CanDestroyDispatch: Boolean read FCanDestroyDispatch write FCanDestroyDispatch;
    property DesigntimeEnabled: Boolean read FDesigntimeEnabled write SetDesigntimeEnabled default True;
    property Settings: TAdvWebBrowserSettings read FSettings write SetSettings;
    property OnGetContextMenu: TAdvWebBrowserOnGetContextMenu read FOnGetContextMenu write FOnGetContextMenu;
    property OnGetPopupMenuForContextMenu: TAdvWebBrowserOnGetPopupMenuForContextMenu read FOnGetPopupMenuForContextMenu write FOnGetPopupMenuForContextMenu;
    property OnCustomContextMenuItemSelected: TAdvWebBrowserOnCustomContextMenuItemSelected read FOnCustomContextMenuItemSelected write FOnCustomContextMenuItemSelected;
    procedure DoGetContextMenuItemEvent(ATarget: TAdvWebBrowserTargetItem; AContextMenu: TObjectList<TAdvWebBrowserContextMenuItem>);
    procedure DoGetPopupMenuForContextMenu(ATarget: TAdvWebBrowserTargetItem; var APopUpMenu: TPopupMenu);
    procedure DoCustomContextMenuItemSelected(ASelectedItem: TAdvWebBrowserCustomContextMenuItem); virtual;
    function InitialPrintSettings: TAdvWebBrowserPrintSettings; virtual;
    procedure DoGetPrintPDFStream(AStream: TMemoryStream); virtual;
    property OnGetPrintPDFStream: TAdvWebBrowserOnGetPrintPDFStream read FOnGetPrintPDFStream write FOnGetPrintPDFStream;
    property OnGetCookies: TAdvWebBrowserOnGetCookies read FOnGetCookies write FOnGetCookies;
    procedure DoGetCookies(ACookies: array of TAdvWebBrowserCookie); virtual;
    procedure DoPrintedToPDF(ASuccesfull: Boolean); virtual;
    procedure DoPrinted(APrinterStatus: Boolean); virtual;
    property OnPrintedToPDF: TAdvCustomWebBrowserOnExecuteSuccessful read FOnPrintedToPDF write FOnPrintedToPDF;
    property OnPrinted: TAdvCustomWebBrowserOnExecuteSuccessful read FOnPrinted write FOnPrinted;
    procedure OpenTaskManager; virtual;
    procedure GetCookies(AURI: string = ''); virtual;
    procedure AddCookie(ACookie: TAdvWebBrowserCookie); virtual;
    procedure DeleteAllCookies; virtual;
    procedure DeleteCookie(AName: string; ADomain: string; APath: string); virtual;
    procedure ShowPrintUI; virtual;
    procedure Print(APrintSettings: TAdvWebBrowserPrintSettings); overload; virtual;
    procedure Print; overload; virtual;
    procedure PrintToPDFStream(APrintSettings: TAdvWebBrowserPrintSettings); overload; virtual;
    procedure PrintToPDFStream; overload; virtual;
    procedure PrintToPDF(AFileName: string; APrintSettings: TAdvWebBrowserPrintSettings); overload; virtual;
    procedure PrintToPDF(AFileName: string); overload; virtual;
    procedure NavigateWithData(AURI: string; AMethod: string; ABody: string; AHeaders: TStrings = nil); overload; virtual;
    procedure NavigateWithData(AURI: string; AMethod: string; ABodyStream: TStream; AHeaders: TStrings = nil); overload; virtual;
    procedure ClearCache; virtual;
    procedure SubscribeDevtools(AEventName: string); virtual;
    procedure CallDevToolsProtocolMethod(AMethodName: string; AParametersAsJSON: string); virtual;
    procedure DoDevToolsMethodCompleted(AEventName: string; AJSONResponse: string); virtual;
    procedure DoDevToolsSubscribedEvent(AEventName: string; AJSONResponse: string); virtual;
    procedure DoGetConsoleMessage(ALogEntry: TAdvWebBrowserLogEntry); virtual;
    procedure SetupStartDomains; virtual;
    property OnDevToolsMethodCompleted: TAdvWebBrowserOnGetDevTools read FOnDevToolsMethodCompleted write FOnDevToolsMethodCompleted;
    property OnDevToolsSubscribedEvent: TAdvWebBrowserOnGetDevTools read FOnDevToolsSubscribedEvent write FOnDevToolsSubscribedEvent;
    property  OnGetConsoleMessage: TAdvCustomWebBrowserOnGetConsoleMessage read FOnGetConsoleMessage write FOnGetConsoleMessage;
    procedure DoDownloadStarted(ADownload: TAdvWebBrowserDownload; var ASilent: Boolean; var APause: Boolean; var AResume: Boolean; var ACancel: Boolean); virtual;
    procedure DoDownloadStateChanged(ADownload: TAdvWebBrowserDownload; AState: TAdvWebBrowserDownloadState; var APause: Boolean; var AResume: Boolean; var ACancel: Boolean); virtual;
    procedure DoDownloadBytesReceivedChanged(ADownload: TAdvWebBrowserDownload; ABytesReceived: Int64; var APause: Boolean; var AResume: Boolean; var ACancel: Boolean); virtual;
    procedure CancelDownload(ADownload: TAdvWebBrowserDownload);
    procedure PauseDownload(ADownload: TAdvWebBrowserDownload);
    procedure ResumeDownload(ADownload: TAdvWebBrowserDownload);
    function GetDownloadInterruptReasonText(ADownloadInterruptReason: TAdvWebBrowserDownloadInterruptReason): string; virtual;
    function GetDownloadStateText(ADownloadState: TAdvWebBrowserDownloadState): string; virtual;
    function GetDocumentTitle: string; virtual;
    function GetContainsFullScreenElement: Boolean; virtual;
    function GetParentWindowHandle: Cardinal; virtual;
    function GetBrowserVersion: string; virtual;
    function GetUserDataFolder: string; virtual;
    procedure DoContainsFullScreenElementChanged; virtual;
    procedure DoDocumentTitleChanged; virtual;
    procedure DoBeforeFrameNavigate(var Params: TAdvCustomWebBrowserBeforeFrameNavigateParams); virtual;
    procedure DoFrameNavigationComplete(var Params: TAdvCustomWebBrowserFrameNavigateCompleteParams); virtual;
    procedure DoHistoryChanged; virtual;
    procedure DoNewWindowRequested(var Params: TAdvWebBrowserNewWindowRequestedParams); virtual;
    procedure DoPermissionRequested(var Params: TAdvWebBrowserPermissionRequestedParams); virtual;
    procedure DoProcessFailed(var Params: TAdvWebBrowserProcessFailedParams); virtual;
    procedure DoScriptDialogOpening(var Params: TAdvWebBrowserScriptDialogOpeningParams); virtual;
    procedure DoSourceChanged(var Params: TAdvWebBrowserSourceChangedParams); virtual;
    procedure DoWebMessageReceived(var Params: TAdvWebBrowserWebMessageReceivedParams); virtual;
    procedure DoWebResourceRequested(var Params: TAdvWebBrowserWebResourceRequestedParams); virtual;
    procedure DoWindowCloseRequested; virtual;
    procedure DoZoomFactorChanged; virtual;
    property OnDownloadStarted: TAdvWebBrowserOnDownloadStarted read FOnDownloadStarted write FOnDownloadStarted;
    property OnDownloadStateChanged: TAdvWebBrowserOnDownloadStateChanged read FOnDownloadStateChanged write FOnDownloadStateChanged;
    property OnDownloadBytesReceivedChanged: TAdvWebBrowserOnDownloadBytesChanged read FOnDownloadBytesReceivedChanged write FOnDownloadBytesReceivedChanged;
    property Downloads: TAdvWebBrowserDownloads read FDownloads write FDownloads;
    property OnContainsFullScreenElementChanged: TNotifyEvent read FOnContainsFullScreenElementChanged write FOnContainsFullScreenElementChanged;
    property OnDocumentTitleChanged: TNotifyEvent read FOnDocumentTitleChanged write FOnDocumentTitleChanged;
    property OnBeforeFrameNavigate: TAdvWebBrowserBeforeFrameNavigate read FOnBeforeFrameNavigate write FOnBeforeFrameNavigate;
    property OnFrameNavigateComplete: TAdvWebBrowserFrameNavigateComplete read FOnFrameNavigateComplete write FOnFrameNavigateComplete;
    property OnHistoryChanged: TNotifyEvent read FOnHistoryChanged write FOnHistoryChanged;
    property OnNewWindowRequested: TAdvWebBrowserNewWindowRequested read FOnNewWindowRequested write FOnNewWindowRequested;
    property OnPermissionRequested: TAdvWebBrowserPermissionRequested read FOnPermissionRequested write FOnPermissionRequested;
    property OnProcessFailed: TAdvWebBrowserProcessFailed read FOnProcessFailed write FOnProcessFailed;
    property OnScriptDialogOpening: TAdvWebBrowserScriptDialogOpening read FOnScriptDialogOpening write FOnScriptDialogOpening;
    property OnSourceChanged: TAdvWebBrowserSourceChanged read FOnSourceChanged write FOnSourceChanged;
    property OnWebMessageReceived: TAdvWebBrowserWebMessageReceivedChanged read FOnWebMessageReceived write FOnWebMessageReceived;
    property OnWebResourceRequested: TAdvWebBrowserWebResourceRequested read FOnWebResourceRequested write FOnWebResourceRequested;
    property OnWindowCloseRequested: TNotifyEvent read FOnWindowCloseRequested write FOnWindowCloseRequested;
    property OnZoomFactorChanged: TNotifyEvent read FOnZoomFactorChanged write FOnZoomFactorChanged;
    {$IFDEF FMXLIB}
    procedure Show; override;
    procedure Hide; override;
    procedure Move; override;
    procedure DoAbsoluteChanged; override;
    {$ENDIF}
    {$IFDEF VCLLIB}
    procedure CreateWnd; override;
    {$ENDIF}
    function CanRecreate: Boolean; virtual;
    function CanLoadDefaultHTML: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {$IFDEF FMXLIB}
    procedure SetBounds(X, Y, AWidth, AHeight: Single); override;
    {$ENDIF}
    procedure UpdateControlAfterResize; override;
    property Version: string read GetVersion;
  end;

  {$IFDEF WEBLIB}
  TAdvWebBrowserList = class(TList)
  private
    function GetItem(Index: Integer): IAdvCustomWebBrowser;
    procedure SetItem(Index: Integer; const Value: IAdvCustomWebBrowser);
  public
    property Items[Index: Integer]: IAdvCustomWebBrowser read GetItem write SetItem; default;
  end;
  {$ENDIF}
  {$IFNDEF WEBLIB}
  TAdvWebBrowserList = class(TList<IAdvCustomWebBrowser>);
  {$ENDIF}

  TAdvWebBrowserFactoryService = class(TInterfacedObject, IAdvWebBrowserService)
  protected
    FWebBrowsers: TAdvWebBrowserList;
    function DoCreateWebBrowser(const AValue: TAdvCustomWebBrowser): IAdvCustomWebBrowser; virtual; abstract;
    procedure DoRemoveWebBrowser(const AValue: IAdvCustomWebBrowser);
  public
    constructor Create;
    destructor Destroy; override;
    function CreateWebBrowser(const AValue: TAdvCustomWebBrowser): IAdvCustomWebBrowser;
    procedure DeleteCookies; virtual; abstract;
    procedure DestroyWebBrowser(const AValue: IAdvCustomWebBrowser);
  end;

  {$IFNDEF LCLLIB}
  [ComponentPlatformsAttribute(TMSPlatforms)]
  {$ENDIF}
  TAdvWebBrowser = class(TAdvCustomWebBrowser)
  public
    {$IFNDEF WEBLIB}
    procedure StartDocumentReadyStateThread; override;
    {$ENDIF}
    procedure Navigate; overload; override;
    procedure Navigate(const AURL: string); overload; override;
    procedure ExecuteJavaScript(AScript: String; ACompleteEvent: TAdvWebBrowserJavaScriptCompleteEvent = nil; AImmediate: Boolean = False); override;
    function ExecuteJavaScriptSync(AScript: string): string; override;
    procedure LoadHTML(AHTML: String); override;
    procedure LoadFile(AFile: String); override;
    procedure Initialize; override;
    procedure DeInitialize; override;
    procedure GoForward; override;
    procedure GoBack; override;
    procedure Reload; override;
    procedure StopLoading; override;
    procedure ShowDebugConsole; override;
    procedure AddBridge(ABridgeName: string; ABridgeObject: TObject); override;
    procedure RemoveBridge(ABridgeName: string); override;
    procedure CaptureScreenShot; override;
    function GetBridgeCommunicationLayer(ABridgeName: string): string; override;
    function NativeEnvironment: Pointer; override;
    function NativeBrowser: Pointer; override;
    function IsFMXBrowser: Boolean; override;
    function CanGoBack: Boolean; override;
    function CanGoForward: Boolean; override;
    {$IFDEF ANDROID}
    function NativeDialog: Pointer; override;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    function GetWebBrowserInstance: IInterface; override;
    {$ENDIF}
    {$IFNDEF FNCLIB}
    procedure OpenTaskManager; override;
    procedure GetCookies(AURI: string = ''); override;
    procedure AddCookie(ACookie: TAdvWebBrowserCookie); override;
    procedure DeleteAllCookies; override;
    procedure DeleteCookie(AName: string; ADomain: string; APath: string); override;
    function InitialPrintSettings: TAdvWebBrowserPrintSettings; override;
    procedure ShowPrintUI; override;
    procedure Print(APrintSettings: TAdvWebBrowserPrintSettings); overload; override;
    procedure Print; overload; override;
    procedure PrintToPDFStream(APrintSettings: TAdvWebBrowserPrintSettings); overload; override;
    procedure PrintToPDFStream; overload; override;
    procedure PrintToPDF(AFileName: string; APrintSettings: TAdvWebBrowserPrintSettings); overload; override;
    procedure PrintToPDF(AFileName: string); overload; override;
    procedure NavigateWithData(AURI: string; AMethod: string; ABody: string; AHeaders: TStrings = nil); overload; override;
    procedure NavigateWithData(AURI: string; AMethod: string; ABodyStream: TStream; AHeaders: TStrings = nil); overload; override;
    procedure SubscribeDevtools(AEventName: string); override;
    procedure CallDevToolsProtocolMethod(AMethodName: string; AParametersAsJSON: string); override;
    function GetDownloadInterruptReasonText(ADownloadInterruptReason: TAdvWebBrowserDownloadInterruptReason): string; override;
    function GetDownloadStateText(ADownloadState: TAdvWebBrowserDownloadState): string; override;
    property Downloads;
    {$ENDIF}
    property OnCloseForm;
    property EnableContextMenu;
    property EnableShowDebugConsole;
    property EnableAcceleratorKeys;
    property CacheFolder;
    property CacheFolderName;
    property AutoClearCache;
    procedure ClearCache; override;
    property UserAgent;
  published
    property OnInitialized;
    property URL;
    property OnBeforeNavigate;
    property OnNavigateComplete;
    property OnHardwareButtonClicked;
    property OnCaptureScreenShot;
    property OnDocumentComplete;
    property Version;
    property DesigntimeEnabled;
    {$IFNDEF FNCLIB}
    property Settings;
    property OnGetContextMenu;
    property OnGetCookies;
    property OnPrintedToPDF;
    property OnGetPrintPDFStream;
    property OnPrinted;
    property OnCustomContextMenuItemSelected;
    property OnGetPopupMenuForContextMenu;
    property OnDevToolsMethodCompleted;
    property OnDevToolsSubscribedEvent;
    property OnGetConsoleMessage;
    property OnDownloadStarted;
    property OnDownloadStateChanged;
    property OnDownloadBytesReceivedChanged;
    property OnContainsFullScreenElementChanged;
    property OnDocumentTitleChanged;
    property OnBeforeFrameNavigate;
    property OnFrameNavigateComplete;
    property OnHistoryChanged;
    property OnNewWindowRequested;
    property OnPermissionRequested;
    property OnProcessFailed;
    property OnScriptDialogOpening;
    property OnSourceChanged;
    property OnWebMessageReceived;
    property OnWebResourceRequested;
    property OnWindowCloseRequested;
    {$ENDIF}
  end;

  TAdvWebBrowserPopup = class;

  {$IFDEF FMXMOBILE}
  TAdvWebBrowserPopupForm = class(TCommonCustomForm)
  {$ELSE}
  TAdvWebBrowserPopupForm = class(TCustomForm)
  {$ENDIF}
  private
    FWebBrowserPopup: TAdvWebBrowserPopup;
  protected
    procedure UpdateBackGround;
  public
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  end;

  {$IFDEF IOS}
  IAdvWebBrowserPopupButtonEventHandler = interface(NSObject)
  ['{723E9874-7EEF-4E40-896D-9E2DAC8E6DD4}']
    procedure Click; cdecl;
  end;

  TAdvWebBrowserPopupButtonEventHandler = class(TOCLocal)
  private
    FWebBrowserPopup: TAdvWebBrowserPopup;
  protected
    function GetObjectiveCClass: PTypeInfo; override;
  public
    procedure Click; cdecl;
  end;
  {$ENDIF}

  {$IFDEF ANDROID}
  TAdvWebBrowserPopupButtonEventHandler = class(TJavaLocal, JView_OnClickListener)
  private
    FWebBrowserPopup: TAdvWebBrowserPopup;
  public
    procedure onClick(P1: JView); cdecl;
  end;
  {$ENDIF}

  TAdvCustomWebBrowserClass = class of TAdvCustomWebBrowser;

  {$IFDEF FMXLIB}
  TAdvWebBrowserFormPosition = TFormPosition;
  {$ENDIF}
  {$IFNDEF FMXLIB}
  TAdvWebBrowserFormPosition = TPosition;
  {$ENDIF}

  {$IFNDEF LCLLIB}
  [ComponentPlatformsAttribute(TMSPlatforms)]
  {$ENDIF}
  TAdvWebBrowserPopup = class(TComponent)
  private
    {$IFDEF MSWINDOWS}
    FLoadURL: String;
    FFirstLoad: Boolean;
    {$ENDIF}
    FModal: Boolean;
    {$IFDEF IOS}
    FButton: UIButton;
    {$ENDIF}
    {$IFNDEF ANDROID}
    {$IFNDEF CMNWEBLIB}
    FPopup: TPopup;
    {$ENDIF}
    FWebBrowserForm: TAdvWebBrowserPopupForm;
    {$ENDIF}
    {$IFDEF ANDROID}
    FButton: JButton;
    {$ENDIF}
    {$IFDEF FMXMOBILE}
    FButtonEventHandler: TAdvWebBrowserPopupButtonEventHandler;
    {$ENDIF}
    FWebBrowser: TAdvCustomWebBrowser;
    FOnNavigateComplete: TAdvCustomWebBrowserNavigateComplete;
    FOnBeforeNavigate: TAdvCustomWebBrowserBeforeNavigate;
    FURL: String;
    FPosition: TAdvWebBrowserFormPosition;
    FWidth: Integer;
    FHeight: Integer;
    FT: Integer;
    FL: Integer;
    FFullScreen: Boolean;
    FCloseButton: Boolean;
    FOnClose: TNotifyEvent;
    FCloseButtonText: String;
    FExternalBrowser: Boolean;
  protected
    procedure ButtonClose(Sender: TObject);
    {$IFDEF MSWINDOWS}
    procedure FormShow(Sender: TObject);
    {$ENDIF}
    {$IFNDEF ANDROID}
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    {$ENDIF}
    procedure CloseForm(Sender: TObject);
    procedure DoBeforeNavigate(Sender: TObject; var Params: TAdvCustomWebBrowserBeforeNavigateParams); virtual;
    procedure DoNavigateComplete(Sender: TObject; var Params: TAdvCustomWebBrowserNavigateCompleteParams); virtual;
    procedure InitializeWebBrowser(AWebBrowser: TAdvCustomWebBrowser); virtual;
    function GetWebBrowserClass: TAdvCustomWebBrowserClass; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Open(AModal: Boolean = True): TModalResult; overload;
    function Open(AURL: String; AModal: Boolean = True): TModalResult; overload;
    procedure Close(AModalResult: TModalResult = mrOk);
    property WebBrowser: TAdvCustomWebBrowser read FWebBrowser;
    property ExternalBrowser: Boolean read FExternalBrowser write FExternalBrowser default False;
  published
    property OnBeforeNavigate: TAdvCustomWebBrowserBeforeNavigate read FOnBeforeNavigate write FOnBeforeNavigate;
    property OnNavigateComplete: TAdvCustomWebBrowserNavigateComplete read FOnNavigateComplete write FOnNavigateComplete;
    property URL: String read FURL write FURL;
    {$IFDEF FMXLIB}
    property Position: TAdvWebBrowserFormPosition read FPosition write FPosition default TFormPosition.ScreenCenter;
    {$ENDIF}
    {$IFNDEF FMXLIB}
    property Position: TAdvWebBrowserFormPosition read FPosition write FPosition default poScreenCenter;
    {$ENDIF}
    property FullScreen: Boolean read FFullScreen write FFullScreen default False;
    property Width: Integer read FWidth write FWidth default 640;
    property Height: Integer read FHeight write FHeight default 480;
    property Left: Integer read FL write FL default 0;
    property Top: Integer read FT write FT default 0;
    property CloseButton: Boolean read FCloseButton write FCloseButton default False;
    property CloseButtonText: String read FCloseButtonText write FCloseButtonText;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;

  TAdvWebBrowserPlatformServicesService = class
  private
    FInterface: IInterface;
    FGUID: string;
  public
    constructor Create(AGUID: string; AInterface: IInterface);
    property GUID: string read FGUID;
    property &Interface: IInterface read FInterface;
  end;

  {$IFDEF WEBLIB}
  TAdvWebBrowserPlatformServicesList = class(TObjectList)
  private
    function GetItem(Index: Integer): TAdvWebBrowserPlatformServicesService;
    procedure SetItem(Index: Integer; const Value: TAdvWebBrowserPlatformServicesService);
  public
    property Items[Index: Integer]: TAdvWebBrowserPlatformServicesService read GetItem write SetItem; default;
  {$ENDIF}
  {$IFNDEF WEBLIB}
  TAdvWebBrowserPlatformServicesList = class(TObjectList<TAdvWebBrowserPlatformServicesService>)
  {$ENDIF}
  private
    function GetValue(AGUID: string): IInterface;
  public
    function ContainsKey(AGUID: string): Boolean;
    procedure RemoveByGUID(AGUID: string);
    property Interfaces[AGUID: string]: IInterface read GetValue;
  end;

  TAdvWebBrowserPlatformServices = class
  private
    FServicesList: TAdvWebBrowserPlatformServicesList;
    class var FCurrent: TAdvWebBrowserPlatformServices;
    class var FCurrentReleased: Boolean;
{$IFNDEF AUTOREFCOUNT}
    class procedure ReleaseCurrent;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddPlatformService(const AServiceGUID: TGUID; const AService: IInterface);
    procedure RemovePlatformService(const AServiceGUID: TGUID);
    function Count: Integer;
    function GetPlatformService(const AServiceGUID: TGUID): IInterface;
    function SupportsPlatformService(const AServiceGUID: TGUID): Boolean; overload;
    function SupportsPlatformService(const AServiceGUID: TGUID; var AService: IInterface): Boolean; overload;
    class function Current: TAdvWebBrowserPlatformServices;
  end;

{$IFDEF MACOS}
function NSStrEx(AString: string): NSString;
{$ENDIF}

implementation

uses
  SysUtils, AdvGraphicsTypes
{$IFDEF FMXLIB}
  ,FMX.Platform
{$ENDIF}
{$IFDEF WEBLIB}
  ,AdvWebBrowser.WEB
{$ENDIF}
{$IFDEF MSWINDOWS}
  ,AdvWebBrowser.Win
{$ENDIF}
{$IFDEF UNIX}
  ,AdvWebBrowser.Unix
{$ENDIF}
{$IFDEF MACOS}
{$IFDEF IOS}
  ,AdvWebBrowser.iOS
{$ELSE}
  ,AdvWebBrowser.Mac
{$ENDIF}
{$ENDIF}
{$IFDEF ANDROID}
  ,AdvWebBrowser.Android
{$ENDIF}
  ;

var
  FTrial: Integer = 0;

function Hiword(L: DWORD): integer;
begin
  Result := L shr 16;
end;

function LoWord(L: DWORD): Integer;
begin
  Result := L AND $FFFF;
end;

function MakeWord(b1,b2: integer): integer;
begin
  Result := b1 or b2 shl 8;
end;

function MakeLong(i1,i2: integer): integer;
begin
  Result := i1 or i2 shl 16;
end;

{$IFDEF MACOS}
function NSStrEx(AString: string): NSString;
begin
  Result := StrToNSStr(AString);
end;
{$ENDIF}

{$IFDEF IOS}
function GetSharedApplication: UIApplication;
begin
  Result := TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication);
end;
{$ENDIF}

{$IFDEF FREEWARE}
function ScrambleEx(s:string): string;
var
  r:string;
  i: integer;
  c: char;
  b: byte;
begin
  r := '';
  {$IFDEF ZEROSTRINGINDEX}
  for i := 0 to length(s) - 1 do
  {$ELSE}
  for i := 1 to length(s) do
  {$ENDIF}
  begin
    b := ord(s[i]);
    b := (b and $E0) + ((b and $1F) xor 5);
    c := chr(b);
    r := r + c;
  end;
  Result := r;
end;
{$ENDIF}

{ TAdvCustomWebBrowser }

{$IFDEF FMXLIB}
procedure TAdvCustomWebBrowser.Show;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;
{$ENDIF}

procedure TAdvCustomWebBrowser.AddBridge(ABridgeName: string;
  ABridgeObject: TObject);
begin
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.RemoveBridge(ABridgeName);
    FWebBrowser.AddBridge(ABridgeName, ABridgeObject);
  end;
end;

procedure TAdvCustomWebBrowser.AddCookie(ACookie: TAdvWebBrowserCookie);
var
  ic: IAdvCustomWebBrowserCookies;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserCookies, ic) = S_OK then
      ic.AddCookie(ACookie);
  end;
end;

procedure TAdvCustomWebBrowser.BeforeNavigate(
  var Params: TAdvCustomWebBrowserBeforeNavigateParams);
begin
  if Assigned(OnBeforeNavigate) then
    OnBeforeNavigate(Self, Params);
end;

procedure TAdvCustomWebBrowser.CallDevToolsProtocolMethod(AMethodName, AParametersAsJSON: string);
var
  ie: IAdvCustomWebBrowserEdge;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEdge, ie) = S_OK then
      ie.CallDevToolsProtocolMethod(AMethodName, AParametersAsJSON);
  end;
end;

function TAdvCustomWebBrowser.CanBeVisible: Boolean;
begin
  Result := True;
end;

procedure TAdvCustomWebBrowser.CancelDownload(ADownload: TAdvWebBrowserDownload);
var
  ie: IAdvCustomWebBrowserEdge;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEdge, ie) = S_OK then
      ie.CancelDownload(ADownload);
  end;
end;

function TAdvCustomWebBrowser.CheckIdentifier: Boolean;
begin
  Result := False;
end;

function TAdvCustomWebBrowser.CanCreateBrowser: Boolean;
begin
  {$IFDEF EDGESUPPORT}
  Result := True;
  {$ELSE}
  {$IFDEF WEBLIB}
  Result := True;
  {$ELSE}
  Result := not IsDesigning
  {$ENDIF}
  {$ENDIF}
end;

function TAdvCustomWebBrowser.CanGoBack: Boolean;
begin
  Result := False;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.CanGoBack;
end;

function TAdvCustomWebBrowser.CanGoForward: Boolean;
begin
  Result := False;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.CanGoForward;
end;

procedure TAdvCustomWebBrowser.CaptureScreenShot;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.CaptureScreenShot;
end;

procedure TAdvCustomWebBrowser.ChangeDPIScale(M, D: Integer);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

procedure TAdvCustomWebBrowser.CheckApplicationInitialized;
begin
  ExecuteJavaScript('document.readyState', {$IFDEF LCLWEBLIB}@{$ENDIF}DoCheckReadyState);
end;

procedure TAdvCustomWebBrowser.ClearCache;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.ClearCache;
end;

constructor TAdvCustomWebBrowser.Create(AOwner: TComponent);
var
  WebBrowserService: IAdvWebBrowserService;
begin
  inherited;
  FSettings := TAdvWebBrowserSettings.Create(Self);
  FCanDestroyDispatch := True;
  FDesigntimeEnabled := True;
  {$IFDEF FMXLIB}
  {$HINTS OFF}
  {$IF COMPILERVERSION > 32}
  TMessageManager.DefaultManager.SubscribeToMessage(TAfterCreateFormHandle, FormHandleCreated);
  {$IFEND}
  {$HINTS ON}
  {$ENDIF}
  {$IFNDEF WEBLIB}
  FScriptList := TAdvScriptList.Create;
  {$ENDIF}

  FDownloads := TAdvWebBrowserDownloads.Create(Self);

  FExternalBrowser := False;
  FEnableShowDebugConsole := True;
  FEnableContextMenu := True;
  FEnableAcceleratorKeys := True;
  if CanCreateBrowser then
    if TAdvWebBrowserPlatformServices.Current.SupportsPlatformService(IAdvWebBrowserService, IInterface(WebBrowserService)) then
      FWebBrowser := WebBrowserService.CreateWebBrowser(Self);

  CreateClasses;

  Width := 500;
  Height := 350;
end;

{$IFDEF WEBLIB}
procedure TAdvCustomWebBrowser.UpdateElement;
begin
  inherited;
  if Assigned(ElementHandle) then
    ElementHandle.style.setProperty('overflow', 'auto');
end;
{$ENDIF}

procedure TAdvCustomWebBrowser.CreateClasses;
begin
//
end;

destructor TAdvCustomWebBrowser.Destroy;
var
  WebBrowserService: IAdvWebBrowserService;
begin
  {$IFNDEF WEBLIB}
  StopDocumentReadyStateThread;
  {$ENDIF}

  if CanCreateBrowser and TAdvWebBrowserPlatformServices.Current.SupportsPlatformService(IAdvWebBrowserService, IInterface(WebBrowserService)) then
    WebBrowserService.DestroyWebBrowser(FWebBrowser);

  if Assigned(FDownloads) then
    FDownloads.Free;

  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.Deinitialize;
    FWebBrowser := nil;
  end;

  {$IFNDEF WEBLIB}
  FScriptList.Free;
  {$ENDIF}

  {$IFDEF FMXLIB}
  {$HINTS OFF}
  {$IF COMPILERVERSION > 32}
  TMessageManager.DefaultManager.Unsubscribe(TAfterCreateFormHandle, FormHandleCreated);
  {$IFEND}
  {$HINTS ON}
  {$ENDIF}

  FreeAndNil(FSettings);
  inherited;
end;

procedure TAdvCustomWebBrowser.DoBeforeFrameNavigate(var Params: TAdvCustomWebBrowserBeforeFrameNavigateParams);
begin
  if Assigned(OnBeforeFrameNavigate) then
    OnBeforeFrameNavigate(Self, Params);
end;

procedure TAdvCustomWebBrowser.DoCaptureScreenShot(AScreenShot: TAdvBitmap);
begin
  if Assigned(OnCaptureScreenShot) then
    OnCaptureScreenShot(Self, AScreenShot);
end;

procedure TAdvCustomWebBrowser.DoCheckIdentifier(const AValue: string);
begin
  if LowerCase(StringReplace(AValue, '"', '', [rfReplaceAll])) = 'unknown' then
    FReady := True;
end;

procedure TAdvCustomWebBrowser.DoDevToolsMethodCompleted(AEventName, AJSONResponse: string);
begin
  if Assigned(OnDevToolsMethodCompleted) then
    OnDevToolsMethodCompleted(Self, AEventName, AJSONResponse);
end;

procedure TAdvCustomWebBrowser.DoDevToolsSubscribedEvent(AEventName, AJSONResponse: string);
begin
  if Assigned(OnDevToolsSubscribedEvent) then
    OnDevToolsSubscribedEvent(Self, AEventName, AJSONResponse);
end;

procedure TAdvCustomWebBrowser.DoDocumentComplete;
begin
  if Assigned(OnDocumentComplete) then
    OnDocumentComplete(Self);
end;

procedure TAdvCustomWebBrowser.DoDocumentTitleChanged;
begin
  if Assigned(OnDocumentTitleChanged) then
    OnDocumentTitleChanged(Self);
end;

procedure TAdvCustomWebBrowser.DoCheckReadyState(const AValue: string);
begin
  if LowerCase(StringReplace(AValue, '"', '', [rfReplaceAll]))  = 'complete' then
  begin
    if CheckIdentifier then
      ExecuteJavaScript('window.TMSWEBCoreClientIdentifier', {$IFDEF LCLWEBLIB}@{$ENDIF}DoCheckIdentifier)
    else
      FReady := True;
  end;
end;

procedure TAdvCustomWebBrowser.DoCloseForm;
begin
  if Assigned(OnCloseForm) then
    OnCloseForm(Self);
end;

procedure TAdvCustomWebBrowser.DoContainsFullScreenElementChanged;
begin
  if Assigned(OnContainsFullScreenElementChanged) then
    OnContainsFullScreenElementChanged(Self);
end;

procedure TAdvCustomWebBrowser.DoCustomContextMenuItemSelected(ASelectedItem: TAdvWebBrowserCustomContextMenuItem);
begin
  if Assigned(OnCustomContextMenuItemSelected) then
    OnCustomContextMenuItemSelected(Self, ASelectedItem);
end;

{$IFNDEF WEBLIB}
procedure TAdvCustomWebBrowser.DoTerminate(Sender: TObject);
begin
  FThreadDone := True;
end;
{$ENDIF}

procedure TAdvCustomWebBrowser.DoWebMessageReceived(var Params: TAdvWebBrowserWebMessageReceivedParams);
begin
  if Assigned(OnWebMessageReceived) then
    OnWebMessageReceived(Self, Params);
end;

procedure TAdvCustomWebBrowser.DoWebResourceRequested(var Params: TAdvWebBrowserWebResourceRequestedParams);
begin
  if Assigned(OnWebResourceRequested) then
    OnWebResourceRequested(Self, Params);
end;

procedure TAdvCustomWebBrowser.DoWindowCloseRequested;
begin
  if Assigned(OnWindowCloseRequested) then
    OnWindowCloseRequested(Self);
end;

procedure TAdvCustomWebBrowser.DoZoomFactorChanged;
begin
  if Assigned(OnZoomFactorChanged) then
    OnZoomFactorChanged(Self);
end;

procedure TAdvCustomWebBrowser.DoHardwareButtonClicked;
begin
  if Assigned(OnHardwareButtonClicked) then
    OnHardwareButtonClicked(Self);
end;

procedure TAdvCustomWebBrowser.DoHistoryChanged;
begin
  if Assigned(OnHistoryChanged) then
    OnHistoryChanged(Self);
end;

procedure TAdvCustomWebBrowser.DoKeyPressed(var Key: Word);
begin

end;

procedure TAdvCustomWebBrowser.DoNewWindowRequested(var Params: TAdvWebBrowserNewWindowRequestedParams);
begin
  if Assigned(OnNewWindowRequested) then
    OnNewWindowRequested(Self, Params);
end;

procedure TAdvCustomWebBrowser.DoPermissionRequested(var Params: TAdvWebBrowserPermissionRequestedParams);
begin
  if Assigned(OnPermissionRequested) then
    OnPermissionRequested(Self, Params);
end;

procedure TAdvCustomWebBrowser.DoPrinted(APrinterStatus: Boolean);
begin
  if Assigned(OnPrinted) then
    OnPrinted(Self, APrinterStatus);
end;

procedure TAdvCustomWebBrowser.DoPrintedToPDF(ASuccesfull: Boolean);
begin
  if Assigned(OnPrintedToPDF) then
    OnPrintedToPDF(Self, ASuccesfull);
end;

procedure TAdvCustomWebBrowser.DoProcessFailed(var Params: TAdvWebBrowserProcessFailedParams);
begin
  if Assigned(OnProcessFailed) then
    OnProcessFailed(Self, Params);
end;


procedure TAdvCustomWebBrowser.DoScriptDialogOpening(var Params: TAdvWebBrowserScriptDialogOpeningParams);
begin
  if Assigned(OnScriptDialogOpening) then
    OnScriptDialogOpening(Self, Params);
end;

{$IFNDEF WEBLIB}
procedure TAdvCustomWebBrowser.DoScriptHandled(Sender: TObject);
var
  s: TAdvScript;
begin
  if Assigned(FWebBrowser) then
  begin
    if FScriptList.Count > 0 then
      FScriptList.Delete(0);

    if FScriptList.Count > 0 then
    begin
      s := FScriptList[0];
      FWebBrowser.ExecuteJavaScript(s.FScript, s.FCompleteEvent, {$IFDEF LCLWEBLIB}@{$ENDIF}DoScriptHandled);
    end;
  end;
end;
{$ENDIF}

procedure TAdvCustomWebBrowser.DoSourceChanged(var Params: TAdvWebBrowserSourceChangedParams);
begin
  if Assigned(OnSourceChanged) then
    OnSourceChanged(Self, Params);
end;

procedure TAdvCustomWebBrowser.Draw(AGraphics: TAdvGraphics; ARect: TRectF);
var
  s: string;
  sz: Single;
begin
  inherited;
  if IsDesigning then
  begin
    AGraphics.Font.Size := 12;
    AGraphics.Font.Name := 'Montserrat';
    {$IFDEF MSWINDOWS}
    if not EdgeLoaded then
      AGraphics.DrawText(RectF(0, 0, Width, Height), EErrorMessageNoDLL, True, gtaCenter, gtaCenter)
    else
    {$ENDIF}
    s := DESIGNTIMEMESSAGE;
    sz := AGraphics.CalculateTextHeight(s);
    AGraphics.DrawText(RectF(ScalePaintValue(5), ScalePaintValue(5), Width - ScalePaintValue(5), sz + ScalePaintValue(5)), s);
  end;
end;

procedure TAdvCustomWebBrowser.DoEnter;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.SetFocus;
end;

procedure TAdvCustomWebBrowser.DoExecuteJavaScriptSync(const AValue: string);
begin
  FSyncValue := AValue;
  FSyncValueExecuted := True;
end;

procedure TAdvCustomWebBrowser.DoFrameNavigationComplete(var Params: TAdvCustomWebBrowserFrameNavigateCompleteParams);
begin
  if Assigned(OnFrameNavigateComplete) then
    OnFrameNavigateComplete(Self, Params);
end;

procedure TAdvCustomWebBrowser.DoGetConsoleMessage(ALogEntry: TAdvWebBrowserLogEntry);
begin
  if Assigned(OnGetConsoleMessage) then
    OnGetConsoleMessage(Self, ALogEntry);
end;

procedure TAdvCustomWebBrowser.DoGetContextMenuItemEvent(ATarget: TAdvWebBrowserTargetItem; AContextMenu: TObjectList<TAdvWebBrowserContextMenuItem>);
begin
  if Assigned(FOnGetContextMenu) then
    OnGetContextMenu(Self, ATarget, AContextMenu);
end;

procedure TAdvCustomWebBrowser.DoGetCookies(ACookies: array of TAdvWebBrowserCookie);
begin
  if Assigned(OnGetCookies) then
    OnGetCookies(Self, ACookies);
end;

procedure TAdvCustomWebBrowser.DoDownloadBytesReceivedChanged(ADownload: TAdvWebBrowserDownload; ABytesReceived: Int64;
  var APause, AResume, ACancel: Boolean);
begin
  if Assigned(OnDownloadBytesReceivedChanged) then
    OnDownloadBytesReceivedChanged(Self, ADownload, ABytesReceived, APause, AResume, ACancel);
end;

procedure TAdvCustomWebBrowser.DoDownloadStarted(ADownload: TAdvWebBrowserDownload; var ASilent, APause, AResume, ACancel: Boolean);
begin
  if Assigned(OnDownloadStarted) then
    OnDownloadStarted(Self, ADownload, ASilent, APause, AResume, ACancel);
end;

procedure TAdvCustomWebBrowser.DoDownloadStateChanged(ADownload: TAdvWebBrowserDownload; AState: TAdvWebBrowserDownloadState;
  var APause, AResume, ACancel: Boolean);
begin
  if Assigned(OnDownloadStateChanged) then
    OnDownloadStateChanged(Self, ADownload, AState, APause, AResume, ACancel);
end;

procedure TAdvCustomWebBrowser.DoGetPopupMenuForContextMenu(ATarget: TAdvWebBrowserTargetItem; var APopUpMenu: TPopupMenu);
begin
  if Assigned(OnGetPopupMenuForContextMenu) then
    OnGetPopupMenuForContextMenu(Self, ATarget, APopupMenu);
end;

procedure TAdvCustomWebBrowser.DoGetPrintPDFStream(AStream: TMemoryStream);
begin
  if Assigned(OnGetPrintPDFStream) then
    OnGetPrintPDFStream(Self, AStream);
end;

function TAdvCustomWebBrowser.ExecuteJavaScriptSync(AScript: string): string;
{$IFNDEF WEBLIB}
{$IFNDEF ANDROID}
var
  i: Integer;
{$ENDIF}
{$ENDIF}
begin
  Result := '';
  if Assigned(FWebBrowser) then
  begin
    FSyncValue := '';
    FSyncValueExecuted := False;
    FWebBrowser.ExecuteJavaScript(AScript, {$IFDEF LCLWEBLIB}@{$ENDIF}DoExecuteJavaScriptSync, nil);
    {$IFNDEF ANDROID}
    {$IFNDEF WEBLIB}
    i := 0;
    while not FSyncValueExecuted and (i <= 60000) do
    begin
      Application.ProcessMessages;
      Sleep(1);
      Inc(i);
    end;
    {$ENDIF}
    {$ENDIF}

    Result := FSyncValue;
  end;
end;

procedure TAdvCustomWebBrowser.ExecuteJavaScript(AScript: String; ACompleteEvent: TAdvWebBrowserJavaScriptCompleteEvent = nil; AImmediate: Boolean = False);
begin
  if Assigned(FWebBrowser) then
  begin
    if AImmediate and FInitialized then
      FWebBrowser.ExecuteJavaScript(AScript, ACompleteEvent, nil)
    else
    begin
      {$IFNDEF WEBLIB}
      FScriptList.Add(TAdvScript.Create(AScript, ACompleteEvent));
      if FScriptList.Count = 1 then
      begin
        if FInitialized then
          FWebBrowser.ExecuteJavaScript(AScript, ACompleteEvent, {$IFNDEF WEBLIB}{$IFDEF LCLLIB}@{$ENDIF}DoScriptHandled{$ELSE}nil{$ENDIF})
        else
          DoScriptHandled(nil);
      end
      else if not FInitialized then
        DoScriptHandled(nil);
      {$ELSE}
      FWebBrowser.ExecuteJavaScript(AScript, ACompleteEvent, {$IFNDEF WEBLIB}{$IFDEF LCLLIB}@{$ENDIF}DoScriptHandled{$ELSE}nil{$ENDIF});
      {$ENDIF}
    end;
  end;
end;

function TAdvCustomWebBrowser.GetBridgeCommunicationLayer(ABridgeName: string): string;
const
  LB = #13;
begin
  Result :=
    'var send' + ABridgeName + 'ObjectMessage = function(parameters) {' + LB +
    '  var v = parameters;' + LB +
    {$IFDEF ANDROID}
    '  if (!' + ABridgeName + ') {' + LB +
    '    return;' + LB +
    '  }' + LB +
    '  ' + ABridgeName + '.Setjsvalue(v); ' + LB +
    '  ' + ABridgeName + '.performClick();' + LB +
    {$ENDIF}
    {$IFDEF MACOS}
    '  if (!window.webkit || !window.webkit.messageHandlers || !window.webkit.messageHandlers.' + ABridgeName + ') {' + LB +
    '    return;' + LB +
    '  }' + LB +
    '  window.webkit.messageHandlers.' + ABridgeName + '.postMessage(v);' + LB +
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    'if (!window.chrome || !window.chrome.webview || !window.chrome.webview.hostObjects || !window.chrome.webview.hostObjects.sync) {' + LB +
    '  return;' + LB +
    '}' + LB +
    'var obj = window.chrome.webview.hostObjects.sync.' + ABridgeName + ';' + LB +
    '  if (obj) {' + LB +
    '    obj.ObjectMessage = v;' + LB +
    '  }' + LB +
    {$ENDIF}
    {$IFDEF WEBLIB}
    '  var event = new CustomEvent("' + ABridgeName + '", {detail: v});' + LB +
    '  ' + ElementID + '.dispatchEvent(event);' + LB +
    {$ENDIF}
    {$IFDEF LINUX}
    '  if (!window.webkit || !window.webkit.messageHandlers || !window.webkit.messageHandlers.' + ABridgeName + ') {' + LB +
    '    return;' + LB +
    '  }' + LB +
    '  window.webkit.messageHandlers.' + ABridgeName + '.postMessage(v);' + LB +
    {$ENDIF}
    '};';
end;

function TAdvCustomWebBrowser.GetBrowserVersion: string;
var
  ii: IAdvCustomWebBrowserInfo;
begin
  Result := '';
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IAdvCustomWebBrowserInfo, ii) = S_OK then
      Result := ii.GetBrowserVersion;
  end;
end;

function TAdvCustomWebBrowser.GetCacheFolder: string;
begin
  Result := '';
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.CacheFolder;
end;

function TAdvCustomWebBrowser.GetCacheFolderName: string;
begin
  Result := '';
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.CacheFolderName;
end;

function TAdvCustomWebBrowser.GetContainsFullScreenElement: Boolean;
var
  ii: IAdvCustomWebBrowserInfo;
begin
  Result := False;
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEx, ii) = S_OK then
      Result := ii.GetContainsFullScreenElement;
  end;
end;

procedure TAdvCustomWebBrowser.GetCookies(AURI: string = '');
var
  ic: IAdvCustomWebBrowserCookies;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserCookies, ic) = S_OK then
      ic.GetCookies(AURI);
  end;
end;

function TAdvCustomWebBrowser.GetDocumentTitle: string;
var
  ii: IAdvCustomWebBrowserInfo;
begin
  Result := '';
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IAdvCustomWebBrowserInfo, ii) = S_OK then
      Result := ii.GetDocumentTitle;
  end;
end;

function TAdvCustomWebBrowser.GetDocURL: string;
begin
  Result := TAdvBaseDocURL + 'tmsfnccore/components/ttmsfncwebbrowser';
end;

function TAdvCustomWebBrowser.GetDownloadInterruptReasonText(ADownloadInterruptReason: TAdvWebBrowserDownloadInterruptReason): string;
begin
  case ADownloadInterruptReason of
    dirNone: Result := 'None';
    dirFileFailed: Result := 'File Failed';
    dirFileAccessDenied: Result := 'File Access Denied';
    dirFileNoSpace: Result := 'File No Space';
    dirFileNameTooLong: Result := 'File Name Too Long';
    dirFileTooLarge: Result := 'File Too Large';
    dirFileMalicious: Result := 'File Malicious';
    dirFileTransientError: Result := 'File Transient Error';
    dirFileBlockedByPolicy: Result := 'File Blocked By Policy';
    dirFileSecurityCheckFailed: Result := 'File Security Check Failed';
    dirFileTooShort: Result := 'File Too Short';
    dirFileHasMismatch: Result := 'File Has Mismatch';
    dirNetworkFailed: Result := 'Network Failed';
    dirNetworkTimeout: Result := 'Network Timeout';
    dirNetworkDisconnected: Result := 'Network Disconnected';
    dirNetworkServerDown: Result := 'Network Server Down';
    dirNetworkInvalidRequest: Result := 'Network Invalid Request';
    dirServerFailed: Result := 'Server Failed';
    dirServerNoRange: Result := 'Server No Range';
    dirServerBadContent: Result := 'Server Bad Content';
    dirServerUnauthorized: Result := 'Server Unauthorized';
    dirServerCertificateProblem: Result := 'Server Certificate Problem';
    dirServerForbidden: Result := 'Server Forbidden';
    dirServerUnexpectedResponse: Result := 'Server Unexpected Response';
    dirServerContentLengthMismatch: Result := 'Server Content Length Mismatch';
    dirServerCrossOriginRedirect: Result := 'Server Cross Origin Redirect';
    dirUserCanceled: Result := 'User Canceled';
    dirUserShutdown: Result := 'User Shutdown';
    dirUserPaused: Result := 'User Paused';
    dirDownloadProcessCrashed: Result := 'Download Process Crashed';
  end;
end;

function TAdvCustomWebBrowser.GetDownloadStateText(ADownloadState: TAdvWebBrowserDownloadState): string;
begin
  case ADownloadState of
    dsInProgress: Result := 'In Progress';
    dsInterrupted: Result := 'Interrupted';
    dsCompleted: Result := 'Completed';
    dsCancelled: Result := 'Cancelled';
  end;
end;

function TAdvCustomWebBrowser.GetAutoClearCache: Boolean;
begin
  Result := False;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.AutoClearCache;
end;

function TAdvCustomWebBrowser.GetEnableAcceleratorKeys: Boolean;
begin
  if FWebBrowser <> nil then
    Result := FWebBrowser.EnableAcceleratorKeys
  else
    Result := FEnableAcceleratorKeys;
end;

function TAdvCustomWebBrowser.GetEnableContextMenu: Boolean;
begin
  if FWebBrowser <> nil then
    Result := FWebBrowser.EnableContextMenu
  else
    Result := FEnableContextMenu;
end;

function TAdvCustomWebBrowser.GetEnableShowDebugConsole: Boolean;
begin
  if FWebBrowser <> nil then
    Result := FWebBrowser.EnableShowDebugConsole
  else
    Result := FEnableShowDebugConsole;
end;

function TAdvCustomWebBrowser.GetExternalBrowser: Boolean;
begin
  if FWebBrowser <> nil then
    Result := FWebBrowser.ExternalBrowser
  else
    Result := FExternalBrowser;
end;

function TAdvCustomWebBrowser.GetParentWindowHandle: Cardinal;
var
  ii: IAdvCustomWebBrowserInfo;
begin
  Result := 0;
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IAdvCustomWebBrowserInfo, ii) = S_OK then
      Result := ii.GetParentWindowHandle;
  end;
end;

function TAdvCustomWebBrowser.GetSettingsI: IAdvCustomWebBrowserSettings;
var
  s: IAdvCustomWebBrowserSettings;
begin
  Result := nil;
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserSettings, s) = S_OK then
      Result := s;
  end;
end;

function TAdvCustomWebBrowser.GetURL: string;
begin
  if FWebBrowser <> nil then
    Result := FWebBrowser.URL
  else
    Result := FURL;
end;

function TAdvCustomWebBrowser.GetUserAgent: string;
begin
  Result := '';
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.UserAgent;
end;

function TAdvCustomWebBrowser.GetUserDataFolder: string;
var
  ii: IAdvCustomWebBrowserInfo;
begin
  Result := '';
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IAdvCustomWebBrowserInfo, ii) = S_OK then
      Result := ii.GetUserDataFolder;
  end;
end;

procedure TAdvCustomWebBrowser.GoBack;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.GoBack;
end;

function TAdvCustomWebBrowser.GetVersion: string;
begin
  Result := GetVersionNumber(MAJ_VER, MIN_VER, REL_VER, BLD_VER);
end;

procedure TAdvCustomWebBrowser.GoForward;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.GoForward;
end;

{$IFDEF VCLLIB}
procedure TAdvCustomWebBrowser.CreateWnd;
begin
  if CanRecreate and (not isLoading and not IsDestroying) then
  begin
    Deinitialize;
    inherited;
    Initialize;
  end
  else
    inherited;
end;
{$ENDIF}

{$IFDEF FMXLIB}
procedure TAdvCustomWebBrowser.Hide;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

procedure TAdvCustomWebBrowser.DoAbsoluteChanged;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;
{$ENDIF}

procedure TAdvCustomWebBrowser.Initialize;
begin
  if (IsDesigning and FDesigntimeEnabled) or not IsDesigning then
  begin
    if Assigned(FWebBrowser) then
      FWebBrowser.Initialize;
  end;
end;

procedure TAdvCustomWebBrowser.Initialized;
begin
  {$IFNDEF FNCLIB}
  SetupStartDomains;
  {$ENDIF}

  FInitialized := True;

  if Assigned(Settings) then
    Settings.ApplySettings;

  if Assigned(OnInitialized) and not FInitializeEventCalled then
  begin
    FInitializeEventCalled := True;
    OnInitialized(Self);
  end;
end;

function TAdvCustomWebBrowser.InitialPrintSettings: TAdvWebBrowserPrintSettings;
begin
  Result.Orientation := poPortrait;
  Result.ScaleFactor := 0;
  Result.PageWidth := 0;
  Result.PageHeight := 0;
  Result.MarginLeft := 0;
  Result.MarginRight := 0;
  Result.MarginTop := 0;
  Result.MarginBottom := 0;
  Result.PrintBackgrounds := False;
  Result.PrintSelectionOnly := False;
  Result.PrintHeaderAndFooter := False;
  Result.HeaderTitle := '';
  Result.FooterURI := '';
end;

function TAdvCustomWebBrowser.CanLoadDefaultHTML: Boolean;
begin
  Result := True;
end;

function TAdvCustomWebBrowser.CanRecreate: Boolean;
begin
  Result := True;
end;

function TAdvCustomWebBrowser.IsFMXBrowser: Boolean;
begin
  Result := False;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.IsFMXBrowser;
end;

procedure TAdvCustomWebBrowser.Loaded;
begin
  inherited;
  Initialize;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;

  if Assigned(OnInitialized) and FInitialized and not FInitializeEventCalled then
  begin
    FInitializeEventCalled := True;
    OnInitialized(Self);
  end;
end;

procedure TAdvCustomWebBrowser.LoadFile(AFile: String);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.LoadFile(AFile);
end;

procedure TAdvCustomWebBrowser.LoadHTML(AHTML: String);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.LoadHTML(AHTML);
end;

{$IFDEF FMXLIB}
procedure TAdvCustomWebBrowser.Move;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;
{$ENDIF}

{$IFDEF ANDROID}
function TAdvCustomWebBrowser.NativeDialog: Pointer;
begin
  Result := nil;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.NativeDialog;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function TAdvCustomWebBrowser.GetWebBrowserInstance: IInterface;
begin
  Result := nil;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.GetBrowserInstance;
end;
{$ENDIF}

function TAdvCustomWebBrowser.NativeBrowser: Pointer;
begin
  Result := nil;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.NativeBrowser;
end;

function TAdvCustomWebBrowser.NativeEnvironment: Pointer;
begin
  Result := nil;
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.NativeEnvironment;
end;

procedure TAdvCustomWebBrowser.Navigate(const AURL: string);
begin
  FReady := False;
  if Assigned(FWebBrowser) then
    FWebBrowser.Navigate(AURL);
end;

procedure TAdvCustomWebBrowser.NavigateComplete(
  var Params: TAdvCustomWebBrowserNavigateCompleteParams);
begin
  if Assigned(OnNavigateComplete) then
    OnNavigateComplete(Self, Params);
end;

procedure TAdvCustomWebBrowser.NavigateWithData(AURI: string; AMethod: string; ABodyStream: TStream; AHeaders: TStrings = nil);
var
  iX: IAdvCustomWebBrowserEx;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEx, iX) = S_OK then
      iX.NavigateWithData(AURI, AMethod, ABodyStream, AHeaders);
  end;
end;

procedure TAdvCustomWebBrowser.NavigateWithData(AURI, AMethod, ABody: string; AHeaders: TStrings);
var
  iX: IAdvCustomWebBrowserEx;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEx, iX) = S_OK then
      iX.NavigateWithData(AURI, AMethod, ABody, AHeaders);
  end;
end;

procedure TAdvCustomWebBrowser.OpenTaskManager;
var
  iX: IAdvCustomWebBrowserEx;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEx, iX) = S_OK then
      iX.OpenTaskManagerWindow;
  end;
end;

procedure TAdvCustomWebBrowser.Print(APrintSettings: TAdvWebBrowserPrintSettings);
var
  ip: IAdvCustomWebBrowserPrint;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserPrint, ip) = S_OK then
      ip.Print(APrintSettings);
  end;
end;

procedure TAdvCustomWebBrowser.PauseDownload(ADownload: TAdvWebBrowserDownload);
var
  ie: IAdvCustomWebBrowserEdge;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEdge, ie) = S_OK then
      ie.PauseDownload(ADownload);
  end;
end;

procedure TAdvCustomWebBrowser.Print;
var
  ip: IAdvCustomWebBrowserPrint;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserPrint, ip) = S_OK then
      ip.Print;
  end;
end;

procedure TAdvCustomWebBrowser.PrintToPDF(AFileName: string);
var
  ip: IAdvCustomWebBrowserPrint;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserPrint, ip) = S_OK then
      ip.PrintToPDF(AFileName);
  end;
end;

procedure TAdvCustomWebBrowser.PrintToPDF(AFileName: string; APrintSettings: TAdvWebBrowserPrintSettings);
var
  ip: IAdvCustomWebBrowserPrint;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserPrint, ip) = S_OK then
      ip.PrintToPDF(AFileName, APrintSettings);
  end;
end;

procedure TAdvCustomWebBrowser.PrintToPDFStream;
var
  ip: IAdvCustomWebBrowserPrint;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserPrint, ip) = S_OK then
      ip.PrintToPDFStream;
  end;
end;

procedure TAdvCustomWebBrowser.PrintToPDFStream(APrintSettings: TAdvWebBrowserPrintSettings);
var
  ip: IAdvCustomWebBrowserPrint;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserPrint, ip) = S_OK then
      ip.PrintToPDFStream(APrintSettings);
  end;
end;

procedure TAdvCustomWebBrowser.Reload;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.Reload;
end;

procedure TAdvCustomWebBrowser.RemoveBridge(ABridgeName: string);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.RemoveBridge(ABridgeName);
end;

procedure TAdvCustomWebBrowser.ResumeDownload(ADownload: TAdvWebBrowserDownload);
var
  ie: IAdvCustomWebBrowserEdge;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEdge, ie) = S_OK then
      ie.ResumeDownload(ADownload);
  end;
end;

procedure TAdvCustomWebBrowser.UpdateControlAfterResize;
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

procedure TAdvCustomWebBrowser.Navigate;
begin
  FReady := False;
  if Assigned(FWebBrowser) then
    FWebBrowser.Navigate;
end;

procedure TAdvCustomWebBrowser.SetCacheFolder(const Value: string);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.CacheFolder := Value;
end;

procedure TAdvCustomWebBrowser.SetCacheFolderName(const Value: string);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.CacheFolderName := Value;
end;

procedure TAdvCustomWebBrowser.SetDesigntimeEnabled(const Value: Boolean);
begin
  FDesigntimeEnabled := Value;
  if IsDesigning then
  begin
    if FDesigntimeEnabled and not FInitialized then
      Initialize
    else
      DeInitialize;
  end;
end;

procedure TAdvCustomWebBrowser.SetAutoClearCache(const Value: Boolean);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.AutoClearCache := Value;
end;

procedure TAdvCustomWebBrowser.SetEnableContextMenu(const Value: Boolean);
begin
  FEnableContextMenu := Value;
  if Assigned(FWebBrowser) then
    FWebBrowser.EnableContextMenu := Value;
end;

{$IFDEF VCLLIB}
procedure TAdvCustomWebBrowser.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateVisible;
end;
{$ENDIF}

{$IFDEF FMXLIB}
{$HINTS OFF}
{$IF COMPILERVERSION > 32}
procedure TAdvCustomWebBrowser.FormHandleCreated(const Sender: TObject; const Msg: TMessage);

  function GetParentForm(Control: TFmxObject): TCommonCustomForm;
  begin
    if (Control.Root <> nil) and (Control.Root.GetObject is TCommonCustomForm) then
      Result := TCommonCustomForm(Control.Root.GetObject)
    else
      Result := nil;
  end;

begin
  if not (csDesigning in ComponentState) and ((FWebBrowser = nil) or (Sender = GetParentForm(self as TFmxObject))) then
  begin
    FWebBrowser.UpdateContentFromControl;
{$IFNDEF MACOS}
    DeInitialize;
    Initialize;
{$ENDIF}
  end;
end;
{$IFEND}
{$HINTS ON}
{$ENDIF}

procedure TAdvCustomWebBrowser.SetEnabledAcceleratorKeys(const Value: Boolean);
begin
  FEnableAcceleratorKeys := Value;
  if Assigned(FWebBrowser) then
    FWebBrowser.EnableAcceleratorKeys := Value;
end;

procedure TAdvCustomWebBrowser.SetEnableShowDebugConsole(const Value: Boolean);
begin
  FEnableShowDebugConsole := Value;
  if Assigned(FWebBrowser) then
    FWebBrowser.EnableShowDebugConsole := Value;
end;

procedure TAdvCustomWebBrowser.SetExternalBrowser(const Value: Boolean);
begin
  FExternalBrowser := Value;
  if Assigned(FWebBrowser) then
    FWebBrowser.ExternalBrowser := Value;
end;

procedure TAdvCustomWebBrowser.SetSettings(const Value: TAdvWebBrowserSettings);
begin
  FSettings.Assign(Value);
end;

procedure TAdvCustomWebBrowser.SetupStartDomains;
var
  ie: IAdvCustomWebBrowserEdge;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEdge, ie) = S_OK then
      ie.SetupStartDomains;
  end;
end;

{$IFDEF CMNWEBLIB}
procedure TAdvCustomWebBrowser.SetEnabled(Value: Boolean);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateEnabled;
end;

{$IFDEF CMNLIB}
procedure TAdvCustomWebBrowser.SetParent(Value: TWinControl);
{$ELSE}
procedure TAdvCustomWebBrowser.SetParent(Value: TControl);
{$ENDIF}
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.BeforeChangeParent;
  inherited;
  Initialize;
  {$IFDEF WEBLIB}
  BeginUpdate;
  EndUpdate;
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF FMXLIB}
procedure TAdvCustomWebBrowser.SetBounds(X, Y, AWidth, AHeight: Single);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateBounds;
end;

procedure TAdvCustomWebBrowser.SetEnabled(const Value: Boolean);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateEnabled;
end;

procedure TAdvCustomWebBrowser.AncestorVisibleChanged(const Visible: Boolean);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateVisible;
end;

procedure TAdvCustomWebBrowser.SetParent(const Value: TFmxObject);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.BeforeChangeParent;
  inherited;
  Initialize;
end;

procedure TAdvCustomWebBrowser.SetVisible(const Value: Boolean);
begin
  inherited;
  if Assigned(FWebBrowser) then
    FWebBrowser.UpdateVisible;
end;
{$ENDIF}

procedure TAdvCustomWebBrowser.SetURL(const Value: string);
begin
  FURL := Value;
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.URL := Value;
    if CanCreateBrowser and (Value <> '') then
      Navigate;
  end;
end;

procedure TAdvCustomWebBrowser.SetUserAgent(const Value: string);
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.UserAgent := Value;
end;

procedure TAdvCustomWebBrowser.ShowDebugConsole;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.ShowDebugConsole;
end;

procedure TAdvCustomWebBrowser.ShowPrintUI;
var
  ip: IAdvCustomWebBrowserPrint;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserPrint, ip) = S_OK then
    begin
      ip.ShowPrintUI;
    end;
  end;
end;

procedure TAdvCustomWebBrowser.DeInitialize;
begin
  FInitialized := False;
  FInitializeEventCalled := False;
  if Assigned(FWebBrowser) then
    FWebBrowser.DeInitialize;
end;

procedure TAdvCustomWebBrowser.DeleteAllCookies;
var
  ic: IAdvCustomWebBrowserCookies;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserCookies, ic) = S_OK then
      ic.DeleteAllCookies;
  end;
end;

procedure TAdvCustomWebBrowser.DeleteCookie(AName, ADomain, APath: string);
var
  ic: IAdvCustomWebBrowserCookies;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserCookies, ic) = S_OK then
      ic.DeleteCookie(AName, ADomain, APath);
  end;
end;

{$IFDEF LCLLIB}
{$IFDEF UNIX}
{$IFDEF LCLGTK3}
class procedure TAdvCustomWebBrowser.WSRegisterClass;
begin
  inherited WSRegisterClass;
  RegisterGTK3WebBrowser;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}

class procedure TAdvCustomWebBrowser.DeleteCookies;
var
  WebBrowserService: IAdvWebBrowserService;
begin
  inherited;
  if TAdvWebBrowserPlatformServices.Current.SupportsPlatformService(IAdvWebBrowserService, IInterface(WebBrowserService)) then
    WebBrowserService.DeleteCookies;
end;

{$IFNDEF WEBLIB}
procedure TAdvCustomWebBrowser.StartDocumentReadyStateThread;
begin
  StopDocumentReadyStateThread;

  if not Assigned(FDocumentReadyStateThread) then
  begin
    FDocumentReadyStateThread := TAdvWebBrowserDocumentReadyStateThread.Create(Self);
    FDocumentReadyStateThread.OnTerminate := DoTerminate;
  end;
end;

procedure TAdvCustomWebBrowser.StopDocumentReadyStateThread;
begin
  if Assigned(FDocumentReadyStateThread) then
  begin
    FDocumentReadyStateThread.Terminate;
    FDocumentReadyStateThread.WaitFor;

    while not FThreadDone do
    begin
      Sleep(100);
      Application.ProcessMessages;
    end;

    FreeAndNil(FDocumentReadyStateThread);
    FThreadDone := False;
  end;
end;
{$ENDIF}

procedure TAdvCustomWebBrowser.StopLoading;
begin
  if Assigned(FWebBrowser) then
    FWebBrowser.StopLoading;
end;

procedure TAdvCustomWebBrowser.SubscribeDevtools(AEventName: string);
var
  ie: IAdvCustomWebBrowserEdge;
begin
  if Assigned(FWebBrowser) then
  begin
    if FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserEdge, ie) = S_OK then
      ie.SubscribeDevtools(AEventName);
  end;
end;

{ TAdvWebBrowserFactoryService }

constructor TAdvWebBrowserFactoryService.Create;
begin
  inherited Create;
  FWebBrowsers := TAdvWebBrowserList.Create;
end;

function TAdvWebBrowserFactoryService.CreateWebBrowser(const AValue: TAdvCustomWebBrowser): IAdvCustomWebBrowser;
begin
  Result := DoCreateWebBrowser(AValue);
  FWebBrowsers.Add(Result);
end;

destructor TAdvWebBrowserFactoryService.Destroy;
begin
  FreeAndNil(FWebBrowsers);
  inherited Destroy;
end;

procedure TAdvWebBrowserFactoryService.DestroyWebBrowser(const AValue: IAdvCustomWebBrowser);
begin
  DoRemoveWebBrowser(AValue);
end;

procedure TAdvWebBrowserFactoryService.DoRemoveWebBrowser(const AValue: IAdvCustomWebBrowser);
begin
  if (FWebBrowsers <> nil) and (AValue <> nil) then
    FWebBrowsers.Remove(AValue);
end;

{ TAdvWebBrowserPopup }

procedure TAdvWebBrowserPopup.DoBeforeNavigate(Sender: TObject; var Params: TAdvCustomWebBrowserBeforeNavigateParams);
begin
  if Assigned(OnBeforeNavigate) then
    OnBeforeNavigate(Self, Params);
end;

procedure TAdvWebBrowserPopup.Close(AModalResult: TModalResult = mrOk);
begin
  {$IFDEF ANDROID}
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.DisposeOf;
    FWebBrowser := nil;
  end;
  if Assigned(OnClose) then
    OnClose(Self);
  {$ELSE}
  if Assigned(FWebBrowserForm) then
  begin
    if FModal then
      FWebBrowserForm.ModalResult := AModalResult
    else
    begin
      if Assigned(FWebBrowserForm) then
        FWebBrowserForm.Close;
    end;
  end;
  {$ENDIF}
end;

procedure TAdvWebBrowserPopup.CloseForm(Sender: TObject);
begin
  Close;
end;

constructor TAdvWebBrowserPopup.Create(AOwner: TComponent);
begin
  inherited;
  {$IFNDEF ANDROID}
  {$IFNDEF CMNWEBLIB}
  FPopup := TPopup.Create(Self);
  {$ENDIF}
  {$ENDIF}
  {$IFDEF FMXLIB}
  FPosition := TFormPosition.ScreenCenter;
  {$ENDIF}
  {$IFNDEF FMXLIB}
  FPosition := poScreenCenter;
  {$ENDIF}
  {$IFDEF FMXMOBILE}
  FButtonEventHandler := TAdvWebBrowserPopupButtonEventHandler.Create;
  FButtonEventHandler.FWebBrowserPopup := Self;
  {$ENDIF}
  FFullScreen := False;
  FWidth := 640;
  FHeight := 480;
  FL := 0;
  FT := 0;
  FExternalBrowser := False;
  if csDesigning in ComponentState then
    FCloseButtonText := 'Close';
end;

destructor TAdvWebBrowserPopup.Destroy;
begin
  {$IFNDEF ANDROID}
  {$IFNDEF CMNWEBLIB}
  if Assigned(FPopup) then
    FPopup := nil;
  {$ENDIF}
  {$ENDIF}
  {$IFDEF FMXMOBILE}
  if Assigned(FButtonEventHandler) then
  begin
    FButtonEventHandler.Free;
    FButtonEventHandler := nil;
  end;
  {$ENDIF}
  if Assigned(FWebBrowser) then
  begin
    {$IFDEF LCLLIB}
    FWebBrowser.Free;
    {$ELSE}
    FWebBrowser.DisposeOf;
    {$ENDIF}
    FWebBrowser := nil;
  end;
  inherited;
end;

{$IFDEF MSWINDOWS}
procedure TAdvWebBrowserPopup.FormShow(Sender: TObject);
begin
  if FFirstLoad then
  begin
    FFirstLoad := False;
    if Assigned(FWebBrowser) then
      FWebBrowser.URL := FLoadURL;
  end;
end;
{$ENDIF}

function TAdvWebBrowserPopup.GetWebBrowserClass: TAdvCustomWebBrowserClass;
begin
  Result := TAdvCustomWebBrowser;
end;

procedure TAdvWebBrowserPopup.InitializeWebBrowser(AWebBrowser: TAdvCustomWebBrowser);
begin

end;

{$IFNDEF ANDROID}
procedure TAdvWebBrowserPopup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FModal then
  begin
    {$IFDEF MACOS}
    {$IFDEF IOS}
    Action := TCloseAction.caFree;
    {$ENDIF}
    {$ELSE}
    Action := TCloseAction.caFree;
    {$ENDIF}
  end
  else
    Action := TCloseAction.caFree;

  FWebBrowserForm := nil;
  FWebBrowser := nil;

  if Assigned(OnClose) then
    OnClose(Self);
end;

{$ENDIF}

procedure TAdvWebBrowserPopup.DoNavigateComplete(Sender: TObject; var Params: TAdvCustomWebBrowserNavigateCompleteParams);
begin
  if Assigned(OnNavigateComplete) then
    OnNavigateComplete(Self, Params);
end;

function TAdvWebBrowserPopup.Open(AURL: String;
  AModal: Boolean = True): TModalResult;
begin
  URL := AURL;
  Result := Open(AModal);
end;

procedure TAdvWebBrowserPopup.ButtonClose(Sender: TObject);
begin
  Close;
end;

function TAdvWebBrowserPopup.Open(AModal: Boolean = True): TModalResult;
{$IFNDEF FMXMOBILE}
var
  b: TButton;
{$ENDIF}
{$IFDEF IOS}
var
  h: TiOSWindowHandle;
  wbv: UIView;
  p: Pointer;
{$ENDIF}
{$IFDEF ANDROID}
var
  wb: JWebBrowser;
  {$IF COMPILERVERSION < 32}
  wnd: JWindow;
  dl: JDialog;
  {$ENDIF}
  ll: JLinearLayout;
{$ENDIF}
begin
  try
    FModal := AModal;
    {$IFDEF ANDROID}
    FModal := False;
    {$ENDIF}

    {$IFNDEF ANDROID}
    {$IFDEF CMNWEBLIB}
    FWebBrowserForm := TAdvWebBrowserPopupForm.CreateNew(Application);
    {$ELSE}
    FWebBrowserForm := TAdvWebBrowserPopupForm.CreateNew(FPopup);
    {$ENDIF}
    FWebBrowserForm.FWebBrowserPopup := Self;
    {$IFDEF DELPHHI_LLVM}
    FWebBrowserForm.FullScreen := FullScreen;
    {$ENDIF}
    FWebBrowserForm.OnClose := FormClose;
    {$IFDEF MSWINDOWS}
    FFirstLoad := True;
    FWebBrowserForm.OnShow := FormShow;
    {$ENDIF}
    FWebBrowserForm.Position := Position;
    FWebBrowserForm.Left := Left;
    FWebBrowserForm.Top := Top;
    FWebBrowserForm.Width := Width;
    FWebBrowserForm.Height := Height;
    {$ENDIF}

    FWebBrowser := GetWebBrowserClass.Create(Self);
    FWebBrowser.ExternalBrowser := ExternalBrowser;
    FWebBrowser.OnCloseForm := CloseForm;
    FWebBrowser.OnBeforeNavigate := DoBeforeNavigate;
    FWebBrowser.OnNavigateComplete := DoNavigateComplete;
    InitializeWebBrowser(FWebBrowser);

    {$IFDEF MSWINDOWS}
    FLoadURL := URL;
    if FWebBrowser.ExternalBrowser then
      FWebBrowser.URL := URL;
    {$ELSE}
    FWebBrowser.URL := URL;
    {$ENDIF}
    {$IFNDEF FMXMOBILE}
    FWebBrowser.ControlAlignment := caClient;
    {$ENDIF}

    {$IFDEF ANDROID}
    FWebBrowser.Parent := Application.MainForm;
    if FullScreen then
    begin
      FWebBrowser.ControlAlignment := caClient;
    end
    else
    begin
      case Position of
        TFormPosition.ScreenCenter, TFormPosition.DesktopCenter, TFormPosition.MainFormCenter,
          TFormPosition.OwnerFormCenter:
        FWebBrowser.Align := TAlignLayout.Center;
      end;
    end;
    {$ELSE}
    FWebBrowser.Parent := FWebBrowserForm;
    {$ENDIF}

    {$IFDEF FMXLIB}
    FWebBrowser.Position.X := Left;
    FWebBrowser.Position.Y := Top;
    {$ENDIF}
    {$IFDEF CMNWEBLIB}
    FWebBrowser.Left := Left;
    FWebBrowser.Top := Top;
    {$ENDIF}
    FWebBrowser.Width := Width;
    FWebBrowser.Height := Height;

    if CloseButton then
    begin
      {$IFNDEF FMXMOBILE}
      b := TButton.Create(FWebBrowserForm);
      b.Parent := FWebBrowserForm;
      {$IFDEF FMXLIB}
      b.Text := CloseButtonText;
      {$ENDIF}
      {$IFDEF CMNWEBLIB}
      b.Caption := CloseButtonText;
      {$ENDIF}
      b.OnClick := ButtonClose;
      {$IFNDEF FMXMOBILE}
      {$IFDEF FMXLIB}
      b.Align := TAlignLayout.Top;
      {$ENDIF}
      {$IFNDEF FMXLIB}
      b.Align := alTop;
      {$ENDIF}
      {$ELSE}
      if FullScreen then
      begin
        {$IFDEF FMXLIB}
        b.Align := TAlignLayout.Top;
        {$ENDIF}
        {$IFNDEF FMXLIB}
        b.Align := alTop;
        {$ENDIF}
      end;

      {$IFDEF FMXLIB}
      FWebBrowser.Position.Y := FWebBrowser.Position.Y + b.Height;
      FWebBrowser.Height := FWebBrowser.Height - b.Height;
      b.Position.X := FWebBrowser.Position.X;
      b.Position.Y := FWebBrowser.Position.Y - b.Height;
      {$ENDIF}
      {$IFDEF CMNWEBLIB}
      FWebBrowser.Position.Y := FWebBrowser.Top + b.Height;
      FWebBrowser.Height := FWebBrowser.Height - b.Height;
      b.Position.X := FWebBrowser.Left;
      b.Position.Y := FWebBrowser.Top - b.Height;
      {$ENDIF}
      b.Width := FWebBrowserForm.Width;
      {$ENDIF}
      {$ELSE}
      {$IFDEF IOS}
      FButton := TUIButton.Wrap(TUIButton.OCClass.buttonWithType(UIButtonTypeRoundedRect));
      FButton.addTarget(FButtonEventHandler.GetObjectID, sel_getUid('Click'), UIControlEventTouchUpInside);
      FButton.setTitle(NSStrEx(CloseButtonText), UIControlStateNormal);
      FWebBrowser.Position.Y := FWebBrowser.Position.Y + FButton.frame.size.height;
      FWebBrowser.Height := FWebBrowser.Height - FButton.frame.size.height;
      FButton.setFrame(CGRectMake(FWebBrowser.Position.X, FWebBrowser.Position.Y - FButton.frame.size.height, FWebBrowser.Width, 30));
      {$ELSE}
      CallInUIThreadAndWaitFinishing(
      procedure
      begin
        FButton := TJButton.JavaClass.init(SharedActivityEx);
        FButton.setText(StrToJCharSequence(CloseButtonText));
        FButton.setOnClickListener(FButtonEventHandler);
        wb := TJWebBrowser.Wrap(FWebBrowser.NativeBrowser);
        ll := TJLinearLayout.Wrap((wb.getParent as ILocalObject).GetObjectID);
        ll.addView(FButton, 0);
      end
      );
      {$ENDIF}
      {$ENDIF}
    end;

    {$IFDEF ANDROID}
    {$HINTS ON}
    {$IF COMPILERVERSION < 32}
    CallInUIThreadAndWaitFinishing(
    procedure
    begin
      dl := TJDialog.Wrap(FWebBrowser.NativeDialog);
      wnd := dl.getWindow;
      wnd.clearFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_NOT_TOUCH_MODAL);
      wnd.addFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_DIM_BEHIND);
    end
    );
    {$IFEND}
    {$HINTS OFF}
    FWebBrowser.SetFocus;
    {$ENDIF}

    {$IFDEF IOS}
    p := FWebBrowser.NativeBrowser;
    if Assigned(p) then
    begin
      wbv := TUIView.Wrap(p);
      wbv.layer.setShadowColor(TUIColor.OCClass.blackColor);
      wbv.layer.setShadowColor(TUIColor.Wrap(TUIColor.OCClass.blackColor).CGColor);
      wbv.layer.setShadowOffset(CGSizeMake(1,1));
      wbv.layer.setShadowRadius(5);
      wbv.layer.setShadowOpacity(0.75);

      h := WindowHandleToPlatform(FWebBrowserForm.Handle);
      h.View.setBackgroundColor(TUIColor.Wrap(TUIColor.OCClass.whiteColor).colorWithAlphaComponent(0.75));
      if Assigned(FButton) then
      begin
        h.View.addSubview(FButton);
        FButton.layer.setShadowColor(TUIColor.OCClass.blackColor);
        FButton.layer.setShadowColor(TUIColor.Wrap(TUIColor.OCClass.blackColor).CGColor);
        FButton.layer.setShadowOffset(CGSizeMake(1,1));
        FButton.layer.setShadowRadius(5);
        FButton.layer.setShadowOpacity(0.75);
        h.View.sendSubviewToBack(FButton);
      end;
    end;
    {$ENDIF}

    if ExternalBrowser then
    begin
      if Assigned(FWebBrowser) then
      begin
        {$IFDEF LCLLIB}
        FWebBrowser.Free;
        {$ELSE}
        FWebBrowser.DisposeOf;
        {$ENDIF}
        FWebBrowser := nil;
      end;

      {$IFNDEF ANDROID}
      if Assigned(FWebBrowserForm) then
      begin
        FWebBrowserForm.Free;
        FWebBrowserForm := nil;
      end;
      {$ENDIF}

      Result := mrOk;
      Exit;
    end;

    {$IFNDEF ANDROID}
    if FModal then
    begin
      Result := FWebBrowserForm.ShowModal;
      {$IFDEF MACOS}
      {$IFNDEF IOS}
      FWebBrowserForm.Free;
      FWebBrowserForm := nil;
      {$ENDIF}
      {$ENDIF}
    end
    else
    begin
      FWebBrowserForm.Show;
      Result := mrOk;
    end;
    {$ELSE}
    Result := mrOk;
    {$ENDIF}
  finally
  end;
end;

{ TAdvWebBrowserPopupForm }

procedure TAdvWebBrowserPopupForm.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  UpdateBackGround;
end;

procedure TAdvWebBrowserPopupForm.UpdateBackGround;
var
  wb: TAdvCustomWebBrowser;
  {$IFDEF IOS}
  btn: UIButton;
  {$ENDIF}
begin
  if Assigned(FWebBrowserPopup) then
  begin
    wb := FWebBrowserPopup.FWebBrowser;
    if Assigned(wb) then
    begin
      if FWebBrowserPopup.FullScreen then
      begin
        wb.SetBounds(0, 0, Width, Height);
      end
      else
      begin
        {$IFDEF FMXLIB}
        case Position of
          TFormPosition.ScreenCenter, TFormPosition.DesktopCenter, TFormPosition.MainFormCenter,
            TFormPosition.OwnerFormCenter:
          begin
            wb.SetBounds((Width - FWebBrowserPopup.Width) / 2 , (Height - FWebBrowserPopup.Height) / 2, FWebBrowserPopup.Width, FWebBrowserPopup.Height);
          end;
        {$ENDIF}
        {$IFDEF CMNWEBLIB}
        case Position of
          poScreenCenter, poDesktopCenter, poMainFormCenter, poOwnerFormCenter:
          begin
            wb.SetBounds((Width - FWebBrowserPopup.Width) div 2 , (Height - FWebBrowserPopup.Height) div 2, FWebBrowserPopup.Width, FWebBrowserPopup.Height);
          end;
        {$ENDIF}
          else
          begin
            wb.SetBounds(FWebBrowserPopup.Left, FWebBrowserPopup.Top, FWebBrowserPopup.Width, FWebBrowserPopup.Height);
          end;
        end;
      end;
      {$IFDEF IOS}
      if Assigned(FWebBrowserPopup.FButton) and FWebBrowserPopup.CloseButton then
      begin
        btn := FWebBrowserPopup.FButton;
        btn.setFrame(CGRectMake(wb.Position.X, wb.Position.Y - FWebBrowserPopup.FButton.frame.size.height, wb.Width, FWebBrowserPopup.FButton.frame.size.height));
        wb.Position.Y := wb.Position.Y + btn.frame.size.height;
        wb.Height := wb.Height - btn.frame.size.height;
        btn.setFrame(CGRectMake(wb.Position.X, wb.Position.Y - btn.frame.size.height, wb.Width, 30));
      end;
      {$ENDIF}
    end;
  end;
end;

{ TAdvWebBrowserDownloads }

function TAdvWebBrowserDownloads.Add: TAdvWebBrowserDownload;
begin
  Result := TAdvWebBrowserDownload(inherited Add);
end;

procedure TAdvWebBrowserDownloads.ClearFinishedDownloads;
var
  I: integer;
begin
  I := 0;
  while I < Self.Count do
  begin
    if Items[I].State = dsCompleted then
      Delete(I)
    else
      Inc(I);
  end;
end;

constructor TAdvWebBrowserDownloads.Create(AOwner: TAdvCustomWebBrowser);
begin
  inherited Create(AOwner, CreateItemClass);
  FOwner := AOwner;
end;

function TAdvWebBrowserDownloads.CreateItemClass: TCollectionItemClass;
begin
  Result := TAdvWebBrowserDownload;
end;

function TAdvWebBrowserDownloads.GetDownloadByURI(AURI: string): TAdvWebBrowserDownload;
var
  I: Integer;
begin
  Result := nil;
  for I := Count - 1 downto 0 do
  begin
    if Items[I].URI = AURI then
    begin
      Result := Items[I];
      Break;
    end;
  end;
end;

function TAdvWebBrowserDownloads.GetItem(Index: Integer): TAdvWebBrowserDownload;
begin
  Result := TAdvWebBrowserDownload(inherited Items[Index]);
end;

function TAdvWebBrowserDownloads.GetOwner: TPersistent;
begin
  Result := FOwner
end;

function TAdvWebBrowserDownloads.Insert(Index: Integer): TAdvWebBrowserDownload;
begin
  Result := TAdvWebBrowserDownload(inherited Insert(Index));
end;

procedure TAdvWebBrowserDownloads.SetItem(Index: Integer; const Value: TAdvWebBrowserDownload);
begin
  inherited Items[Index] := Value;
end;

{ TAdvWebBrowserDownload }

procedure TAdvWebBrowserDownload.Cancel;
begin
  if Assigned(FOwner) then
    FOwner.CancelDownload(Self);
end;

constructor TAdvWebBrowserDownload.Create(Collection: TCollection);
begin
  inherited;
  if (Collection is TAdvWebBrowserDownloads) then
    FOwner := (Collection as TAdvWebBrowserDownloads).FOwner;
end;

destructor TAdvWebBrowserDownload.Destroy;
begin

  inherited;
end;

procedure TAdvWebBrowserDownload.Pause;
begin
  if Assigned(FOwner) then
    FOwner.PauseDownload(Self);
end;

procedure TAdvWebBrowserDownload.Resume;
begin
  if Assigned(FOwner) then
    FOwner.ResumeDownload(Self);
end;

procedure TAdvWebBrowserDownload.SetBytesReceived(const Value: Int64);
begin
  if FBytesReceived <> Value then
    FBytesReceived := Value;
end;

procedure TAdvWebBrowserDownload.SetCanResume(const Value: boolean);
begin
  if FCanResume <> Value then
    FCanResume := Value;
end;

procedure TAdvWebBrowserDownload.SetInterruptReason(const Value: TAdvWebBrowserDownloadInterruptReason);
begin
  if FInterruptReason <> Value then
    FInterruptReason := Value;
end;

procedure TAdvWebBrowserDownload.SetMimeType(const Value: string);
begin
  if FMimeType <> Value then
    FMimeType := Value;
end;

procedure TAdvWebBrowserDownload.SetResultFilePath(const Value: string);
begin
  if FResultFilePath <> Value then
    FResultFilePath := Value;
end;

procedure TAdvWebBrowserDownload.SetState(const Value: TAdvWebBrowserDownloadState);
begin
  if FState <> Value then
  FState := Value;
end;

procedure TAdvWebBrowserDownload.SetTotalBytes(const Value: Int64);
begin
  if FTotalBytes <> Value then
    FTotalBytes := Value;
end;

procedure TAdvWebBrowserDownload.SetURI(const Value: string);
begin
  if FURI <> Value then
    FURI := Value;
end;

{ TAdvWebBrowserCustomContextMenuItem }

function TAdvWebBrowserCustomContextMenuItem.GetParentItem: TAdvWebBrowserContextMenuItem;
begin
  Result := inherited ParentItem;
end;

{ TAdvBrowserContextMenuItem }

function TAdvWebBrowserContextMenuItem.AsCustom: TAdvWebBrowserCustomContextMenuItem;
begin
  if Self is TAdvWebBrowserCustomContextMenuItem then
    Result := TAdvWebBrowserCustomContextMenuItem(Self)
  else
    Result := nil;
end;

function TAdvWebBrowserContextMenuItem.AsSystem: TAdvWebBrowserSystemContextMenuItem;
begin
  if Self is TAdvWebBrowserSystemContextMenuItem then
    Result := TAdvWebBrowserSystemContextMenuItem(Self)
  else if Self is TAdvWebBrowserCustomContextMenuItem then
    Result :=  TAdvWebBrowserSystemContextMenuItem(Self)
  else
    Result := nil;
end;

constructor TAdvWebBrowserContextMenuItem.Create;
begin
  FKind := ikCommand;
  FEnabled := True;
  FOriginalIndex := -1;
  FChildren := TAdvWebBrowserContextMenuItemList.Create;
  FIcon := TAdvBitmap.Create;
end;

destructor TAdvWebBrowserContextMenuItem.Destroy;
begin
  if Assigned(FEventHandlerObject) then
    FreeAndNil(FEventHandlerObject);

  FIcon.Free;
  FChildren.Free;
  inherited;
end;

procedure TAdvWebBrowserContextMenuItem.SetShortcutKeyDescription(const Value: string);
begin
  FShortcutKeyDescription := Value;
end;

{ TAdvBrowserSystemContextMenuItem }

function TAdvWebBrowserSystemContextMenuItem.GetChecked: Boolean;
begin
  Result := inherited Checked;
end;

function TAdvWebBrowserSystemContextMenuItem.GetChildren: TObjectList<TAdvWebBrowserContextMenuItem>;
begin
  Result := inherited Children;
end;

function TAdvWebBrowserSystemContextMenuItem.GetEnabled: Boolean;
begin
  Result := inherited Enabled;
end;

function TAdvWebBrowserSystemContextMenuItem.GetIcon: TAdvBitmap;
begin
  Result := inherited Icon;
end;

function TAdvWebBrowserSystemContextMenuItem.GetKind: TAdvWebBrowserContextMenuItemKind;
begin
  Result := inherited Kind;
end;

function TAdvWebBrowserSystemContextMenuItem.GetName: string;
begin
  Result := inherited Name;
end;

function TAdvWebBrowserSystemContextMenuItem.GetParentItem: TAdvWebBrowserContextMenuItem;
begin
  Result := inherited ParentItem;
end;

function TAdvWebBrowserSystemContextMenuItem.GetText: string;
begin
  Result := inherited Text;
end;

{ TAdvCustomWebBrowserSettings }

procedure TAdvCustomWebBrowserSettings.ApplySettings;
begin
  SetEnableAcceleratorKeys(FEnableAcceleratorKeys);
  SetEnableContextMenu(FEnableContextMenu);
  SetEnableShowDebugConsole(FEnableShowDebugConsole);
  SetAllowExternalDrop(FAllowExternalDrop);
//  SetEnableScript(FEnableScript);
end;

constructor TAdvCustomWebBrowserSettings.Create(AOwner: TAdvCustomWebBrowser);
begin
  inherited Create;
  FEnableScript := True;
  FEnableContextMenu := True;
  FEnableAcceleratorKeys := True;
  FEnableShowDebugConsole := True;
  FAllowExternalDrop := True;

  FOwner := AOwner;
end;

destructor TAdvCustomWebBrowserSettings.Destroy;
begin

  inherited;
end;

function TAdvCustomWebBrowserSettings.GetAllowExternalDrop: Boolean;
var
  s: IAdvCustomWebBrowserSettings;
begin
  Result := FAllowExternalDrop;
  if Assigned(FOwner) and Assigned(FOwner.FWebBrowser) then
  begin
    if FOwner.FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserSettings, s) = S_OK then
      Result := s.AllowExternalDrop;
  end;
end;

function TAdvCustomWebBrowserSettings.GetEnableAcceleratorKeys: Boolean;
begin
  Result := FEnableAcceleratorKeys;
  if Assigned(FOwner) and FOwner.FInitialized then
    Result := FOwner.EnableAcceleratorKeys;
end;

function TAdvCustomWebBrowserSettings.GetEnableContextMenu: Boolean;
begin
  Result := FEnableContextMenu;
  if Assigned(FOwner) and FOwner.FInitialized then
    Result := FOwner.EnableContextMenu;
end;

function TAdvCustomWebBrowserSettings.GetEnableScript: Boolean;
var
  s: IAdvCustomWebBrowserSettings;
begin
  if Assigned(FOwner) and FOwner.FInitialized then
  begin
    if Assigned(FOwner) then
    begin
      s := FOwner.SettingsI;
      if Assigned(s) then
        FEnableScript := s.GetEnableScript;
    end;
  end;
  Result := FEnableScript;
end;

function TAdvCustomWebBrowserSettings.GetEnableShowDebugConsole: Boolean;
begin
  Result := FEnableShowDebugConsole;
  if Assigned(FOwner) and FOwner.FInitialized then
    Result := FOwner.EnableShowDebugConsole;
end;

function TAdvCustomWebBrowserSettings.GetUsePopupMenuAsContextMenu: Boolean;
begin
  Result := FUsePopupMenuAsContextMenu;
end;

procedure TAdvCustomWebBrowserSettings.SetAllowExternalDrop(const Value: Boolean);
var
  s: IAdvCustomWebBrowserSettings;
begin
  FAllowExternalDrop := Value;
  if Assigned(FOwner) and Assigned(FOwner.FWebBrowser) then
  begin
    if FOwner.FWebBrowser.QueryInterface(IID_IAdvCustomWebBrowserSettings, s) = S_OK then
      s.SetAllowExternalDrop(FAllowExternalDrop);
  end;
end;

procedure TAdvCustomWebBrowserSettings.SetEnableAcceleratorKeys(const Value: Boolean);
begin
  FEnableAcceleratorKeys := Value;
  if Assigned(FOwner) then
    FOwner.EnableAcceleratorKeys := Value;
end;

procedure TAdvCustomWebBrowserSettings.SetEnableContextMenu(const Value: Boolean);
begin
  FEnableContextMenu := Value;
  if Assigned(FOwner) then
    FOwner.EnableContextMenu := Value;
end;

procedure TAdvCustomWebBrowserSettings.SetEnableScript(const Value: boolean);
var
  s: IAdvCustomWebBrowserSettings;
begin
  FEnableScript := Value;
  if Assigned(FOwner) then
  begin
    s := FOwner.SettingsI;
    if Assigned(s) then
      s.SetEnableScript(Value);
  end;
end;

procedure TAdvCustomWebBrowserSettings.SetEnableShowDebugConsole(const Value: Boolean);
begin
  FEnableShowDebugConsole := Value;
  if Assigned(FOwner) then
    FOwner.EnableShowDebugConsole := Value;
end;

procedure TAdvCustomWebBrowserSettings.SetUsePopupMenuAsContextMenu(const Value: Boolean);
begin
  FUsePopupMenuAsContextMenu := Value;
end;

{$IFNDEF WEBLIB}

{ TAdvScript }

constructor TAdvScript.Create(AScript: string; ACompleteEvent: TAdvWebBrowserJavaScriptCompleteEvent);
begin
  FScript := AScript;
  FCompleteEvent := ACompleteEvent;
end;
{$ENDIF}

{$IFDEF IOS}

{ TAdvWebBrowserPopupButtonEventHandler }

procedure TAdvWebBrowserPopupButtonEventHandler.Click;
begin
  if Assigned(FWebBrowserPopup) then
    FWebBrowserPopup.Close;
end;

function TAdvWebBrowserPopupButtonEventHandler.GetObjectiveCClass: PTypeInfo;
begin
  Result := TypeInfo(IAdvWebBrowserPopupButtonEventHandler);
end;
{$ENDIF}

{$IFDEF ANDROID}

{ TAdvWebBrowserPopupButtonEventHandler }

procedure TAdvWebBrowserPopupButtonEventHandler.onClick(P1: JView);
begin
  if Assigned(FWebBrowserPopup) then
    FWebBrowserPopup.Close;
end;

{$ENDIF}

{$IFNDEF WEBLIB}

{ TAdvWebBrowserDocumentReadyStateThread }

constructor TAdvWebBrowserDocumentReadyStateThread.Create(AWebBrowser: TAdvCustomWebBrowser);
begin
  inherited Create(False);
  FWebBrowser := AWebBrowser;
end;

procedure TAdvWebBrowserDocumentReadyStateThread.Execute;
begin
  while not Terminated do
  begin
    if Assigned(FWebBrowser) then
    begin
      Synchronize(FWebBrowser.CheckApplicationInitialized);
      Sleep(100);
      if FWebBrowser.FReady then
      begin
        Synchronize(FWebBrowser.DoDocumentComplete);
        Terminate;
      end;
    end
    else
      Terminate;
  end;
end;

{$ENDIF}

{ TAdvWebBrowserPlatformServices }

function TAdvWebBrowserPlatformServices.Count: Integer;
begin
  Result := FServicesList.Count;
end;

procedure TAdvWebBrowserPlatformServices.AddPlatformService(const AServiceGUID: TGUID; const AService: IInterface);
var
  LService: IInterface;
begin
  if not FServicesList.ContainsKey(GUIDToString(AServiceGUID)) then
  begin
    if Supports(AService, AServiceGUID, LService) then
      FServicesList.Add(TAdvWebBrowserPlatformServicesService.Create(GUIDToString(AServiceGUID), AService));
  end;
end;

constructor TAdvWebBrowserPlatformServices.Create;
begin
  inherited;
  FServicesList := TAdvWebBrowserPlatformServicesList.Create;
end;

destructor TAdvWebBrowserPlatformServices.Destroy;
begin
  FreeAndNil(FServicesList);
  inherited;
end;

{$IFNDEF AUTOREFCOUNT}
class procedure TAdvWebBrowserPlatformServices.ReleaseCurrent;
begin
  FreeAndNil(FCurrent);
  FCurrentReleased := True;
end;
{$ENDIF}

class function TAdvWebBrowserPlatformServices.Current: TAdvWebBrowserPlatformServices;
begin
  if (FCurrent = nil) and not FCurrentReleased then
    FCurrent := TAdvWebBrowserPlatformServices.Create;
  Result := FCurrent;
end;

function TAdvWebBrowserPlatformServices.GetPlatformService(const AServiceGUID: TGUID): IInterface;
var
  k: IInterface;
begin
  k := FServicesList.Interfaces[GUIDToString(AServiceGUID)];
  Supports(k, AServiceGUID, Result);
end;

procedure TAdvWebBrowserPlatformServices.RemovePlatformService(const AServiceGUID: TGUID);
begin
  FServicesList.RemoveByGUID(GUIDToString(AServiceGUID));
end;

function TAdvWebBrowserPlatformServices.SupportsPlatformService(const AServiceGUID: TGUID;
  var AService: IInterface): Boolean;
begin
  if FServicesList.ContainsKey(GUIDToString(AServiceGUID)) then
    Result := Supports(FServicesList.Interfaces[GUIDToString(AServiceGUID)], AServiceGUID, AService)
  else
  begin
    AService := nil;
    Result := False;
  end;
end;

function TAdvWebBrowserPlatformServices.SupportsPlatformService(const AServiceGUID: TGUID): Boolean;
begin
  Result := FServicesList.ContainsKey(GUIDToString(AServiceGUID));
end;

{ TAdvWebBrowserPlatformServicesService }

constructor TAdvWebBrowserPlatformServicesService.Create(AGUID: string;
  AInterface: IInterface);
begin
  FGUID := AGUID;
  FInterface := AInterface;
end;

{ TAdvWebBrowserPlatformServicesList }

function TAdvWebBrowserPlatformServicesList.ContainsKey(AGUID: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    if Items[I].GUID = AGUID then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TAdvWebBrowserPlatformServicesList.GetValue(AGUID: string): IInterface;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[I].GUID = AGUID then
    begin
      Result := Items[I].&Interface;
      Break;
    end;
  end;
end;

procedure TAdvWebBrowserPlatformServicesList.RemoveByGUID(AGUID: string);
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
  begin
    if Items[I].GUID = AGUID then
    begin
      Remove(Items[I]);
      Break;
    end;
  end;
end;

{$IFDEF WEBLIB}
function TAdvWebBrowserList.GetItem(Index: Integer): IAdvCustomWebBrowser;
begin
  Result := IAdvCustomWebBrowser(inherited Items[Index]);
end;

procedure TAdvWebBrowserList.SetItem(Index: Integer; const Value: IAdvCustomWebBrowser);
begin
  inherited Items[Index] := Value;
end;

function TAdvWebBrowserPlatformServicesList.GetItem(Index: Integer): TAdvWebBrowserPlatformServicesService;
begin
  Result := TAdvWebBrowserPlatformServicesService(inherited Items[Index]);
end;

procedure TAdvWebBrowserPlatformServicesList.SetItem(Index: Integer; const Value: TAdvWebBrowserPlatformServicesService);
begin
  inherited Items[Index] := Value;
end;
{$ENDIF}

{ TAdvWebBrowser }

procedure TAdvWebBrowser.AddBridge(ABridgeName: string; ABridgeObject: TObject);
begin
  inherited AddBridge(ABridgeName, ABridgeObject);
end;

{$IFNDEF FNCLIB}
procedure TAdvWebBrowser.AddCookie(ACookie: TAdvWebBrowserCookie);
begin
  inherited AddCookie(ACookie);
end;

procedure TAdvWebBrowser.DeleteAllCookies;
begin
  inherited DeleteAllCookies;
end;

procedure TAdvWebBrowser.DeleteCookie(AName, ADomain, APath: string);
begin
  inherited DeleteCookie(AName, ADomain, APath);
end;

procedure TAdvWebBrowser.GetCookies(AURI: string);
begin
  inherited GetCookies(AURI);
end;

function TAdvWebBrowser.InitialPrintSettings: TAdvWebBrowserPrintSettings;
begin
  Result := inherited InitialPrintSettings;
end;

procedure TAdvWebBrowser.OpenTaskManager;
begin
  inherited OpenTaskManager;
end;

procedure TAdvWebBrowser.ShowPrintUI;
begin
  inherited ShowPrintUI;
end;

procedure TAdvWebBrowser.Print(APrintSettings: TAdvWebBrowserPrintSettings);
begin
  inherited Print(APrintSettings);
end;

procedure TAdvWebBrowser.PrintToPDFStream(APrintSettings: TAdvWebBrowserPrintSettings);
begin
  inherited PrintToPDFStream(APrintSettings);
end;

procedure TAdvWebBrowser.Print;
begin
  inherited Print;
end;

procedure TAdvWebBrowser.PrintToPDF(AFileName: string;
  APrintSettings: TAdvWebBrowserPrintSettings);
begin
  inherited PrintToPDF(AFileName, APrintSettings);
end;

procedure TAdvWebBrowser.PrintToPDF(AFileName: string);
begin
  inherited PrintToPDF(AFileName);
end;

procedure TAdvWebBrowser.PrintToPDFStream;
begin
  inherited PrintToPDFStream;
end;

procedure TAdvWebBrowser.NavigateWithData(AURI: string; AMethod: string; ABodyStream: TStream; AHeaders: TStrings);
begin
  inherited NavigateWithData(AURI, AMethod, ABodyStream, AHeaders);
end;

procedure TAdvWebBrowser.NavigateWithData(AURI, AMethod, ABody: string; AHeaders: TStrings);
begin
  inherited NavigateWithData(AURI, AMethod, ABody, AHeaders);
end;

procedure TAdvWebBrowser.SubscribeDevtools(AEventName: string);
begin
  inherited SubscribeDevtools(AEventName);
end;

procedure TAdvWebBrowser.CallDevToolsProtocolMethod(AMethodName: string; AParametersAsJSON: string);
begin
  inherited CallDevToolsProtocolMethod(AMethodName, AParametersAsJSON);
end;

function TAdvWebBrowser.GetDownloadInterruptReasonText(ADownloadInterruptReason: TAdvWebBrowserDownloadInterruptReason): string;
begin
  Result := inherited GetDownloadInterruptReasonText(ADownloadInterruptReason);
end;

function TAdvWebBrowser.GetDownloadStateText(ADownloadState: TAdvWebBrowserDownloadState): string;
begin
  Result := inherited GetDownloadStateText(ADownloadState);
end;

{$ENDIF}

function TAdvWebBrowser.CanGoBack: Boolean;
begin
  Result := inherited CanGoBack;
end;

function TAdvWebBrowser.CanGoForward: Boolean;
begin
  Result := inherited CanGoForward;
end;

procedure TAdvWebBrowser.CaptureScreenShot;
begin
  inherited CaptureScreenShot;
end;

procedure TAdvWebBrowser.ClearCache;
begin
  inherited ClearCache;
end;

procedure TAdvWebBrowser.DeInitialize;
begin
  inherited DeInitialize;
end;

procedure TAdvWebBrowser.ExecuteJavaScript(AScript: String; ACompleteEvent: TAdvWebBrowserJavaScriptCompleteEvent = nil; AImmediate: Boolean = False);
begin
  inherited ExecuteJavaScript(AScript, ACompleteEvent, AImmediate);
end;

function TAdvWebBrowser.ExecuteJavaScriptSync(AScript: string): string;
begin
  Result := inherited ExecuteJavaScriptSync(AScript);
end;

function TAdvWebBrowser.GetBridgeCommunicationLayer(ABridgeName: string): string;
begin
  Result := inherited GetBridgeCommunicationLayer(ABridgeName);
end;

{$IFDEF ANDROID}
function TAdvWebBrowser.NativeDialog: Pointer;
begin
  Result := inherited NativeDialog;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function TAdvWebBrowser.GetWebBrowserInstance: IInterface;
begin
  Result := inherited GetWebBrowserInstance;
end;
{$ENDIF}

procedure TAdvWebBrowser.GoBack;
begin
  inherited GoBack;
end;

procedure TAdvWebBrowser.GoForward;
begin
  inherited GoForward;
end;

procedure TAdvWebBrowser.Initialize;
begin
  inherited Initialize;
end;

function TAdvWebBrowser.IsFMXBrowser: Boolean;
begin
  Result := inherited IsFMXBrowser;
end;

procedure TAdvWebBrowser.LoadFile(AFile: String);
begin
  inherited LoadFile(AFile);
end;

procedure TAdvWebBrowser.LoadHTML(AHTML: String);
begin
  inherited LoadHTML(AHTML);
end;

function TAdvWebBrowser.NativeBrowser: Pointer;
begin
  Result := inherited NativeBrowser;
end;

function TAdvWebBrowser.NativeEnvironment: Pointer;
begin
  Result := inherited NativeEnvironment;
end;

{$IFNDEF WEBLIB}
procedure TAdvWebBrowser.StartDocumentReadyStateThread;
begin
  inherited StartDocumentReadyStateThread;
end;
{$ENDIF}

procedure TAdvWebBrowser.Navigate;
begin
  inherited Navigate;
end;

procedure TAdvWebBrowser.Navigate(const AURL: string);
begin
  inherited Navigate(AURL);
end;

procedure TAdvWebBrowser.Reload;
begin
  inherited Reload;
end;

procedure TAdvWebBrowser.RemoveBridge(ABridgeName: string);
begin
  inherited RemoveBridge(ABridgeName);
end;

procedure TAdvWebBrowser.ShowDebugConsole;
begin
  inherited ShowDebugConsole;
end;

procedure TAdvWebBrowser.StopLoading;
begin
  inherited StopLoading;
end;

initialization
begin
  TAdvWebBrowserPlatformServices.FCurrentReleased := False;
  RegisterWebBrowserService;
end;

{$IFNDEF WEBLIB}
finalization
begin
  UnRegisterWebBrowserService;
{$IFNDEF AUTOREFCOUNT}
  TAdvWebBrowserPlatformServices.ReleaseCurrent;
{$ENDIF}
end;
{$ENDIF}

end.
