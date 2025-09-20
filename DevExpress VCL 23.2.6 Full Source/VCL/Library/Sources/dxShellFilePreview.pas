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

unit dxShellFilePreview;

{$I cxVer.inc}
{$SCOPEDENUMS ON}
{$WARN SYMBOL_PLATFORM OFF}


interface

uses
  System.UITypes,
  Windows, Types, ShlObj, Classes, Messages, Controls, Generics.Defaults, Generics.Collections,
  dxCore, dxCoreClasses, dxGenerics, cxClasses, dxGDIPlusAPI, dxGDIPlusClasses,
  cxGraphics, cxControls, dxThreading, dxShellControls, cxShellControls, cxShellCommon;

type
  TdxPreviewTaskDispatcher = class;
  TdxCustomFilePreviewTask = class;
  TdxFilePreviewPane = class;

  TdxFilePreviewSource = (PreviewHandler, Thumbnail, CustomHandler);
  TdxFilePreviewSources = set of TdxFilePreviewSource;

  { TdxFilePreviewCustomHandler }

  TdxFilePreviewCustomHandler = class abstract 
  strict private
    FFileName: string;
    FPane: TdxFilePreviewPane;
  protected
    function RunInThread: Boolean; virtual; abstract; 

    property Pane: TdxFilePreviewPane read FPane;
  public
    constructor Create(APane: TdxFilePreviewPane; const AFileName: string); // for internal use
    function Initialize: Boolean; virtual; abstract;
    class procedure Register(const AFileExtension: string);
    class procedure Unregister(const AFileExtension: string);
    property FileName: string read FFileName;
  end;
  TdxFilePreviewCustomHandlerClass = class of TdxFilePreviewCustomHandler; // for internal use

  { TdxFilePreviewImageBasedHandler }

  TdxFilePreviewImageBasedHandler = class abstract (TdxFilePreviewCustomHandler) 
  protected
    function GetHeight: Integer; virtual; abstract;  
    function GetWidth: Integer; virtual; abstract;   
    function KeepAspectRatio: Boolean; virtual;      
    function ShowShadow: Boolean; virtual;           
  public
    procedure DrawPreview(ACanvas: TcxCanvas; const ABounds: TRect); virtual; abstract;
    property Height: Integer read GetHeight;
    property Width: Integer read GetWidth;
  end;

  { TdxFilePreviewControlBasedHandler }

  TdxFilePreviewControlBasedHandler = class abstract (TdxFilePreviewCustomHandler) 
  strict private
    FControl: TWinControl;
  protected
    function CreateControl(const AFileName: string): TWinControl; virtual; abstract; 
    function RunInThread: Boolean; override;

    property Control: TWinControl read FControl;
  public
    destructor Destroy; override;
    function Initialize: Boolean; override;
  end;

{$REGION 'for internal use'}

  { TdxFilePreviewPane }

  TdxFilePreviewMode = (NoFile, Empty, PreviewHandler, Thumbnail, CustomHandler); // for internal use

  TdxFilePreviewPane = class(TcxControl)
  public const
    DefaultFilePreviewSources = [TdxFilePreviewSource.PreviewHandler, TdxFilePreviewSource.Thumbnail, TdxFilePreviewSource.CustomHandler];
    DefaultPreviewDelay = 100;
  protected const
    PreviewPadding = 8;
  protected type
    TPreviewHandlerEvents = array[0..1] of THandle;
    TEvents = record
    private
      FCancelEvent: THandle;
      FResizeEvent: THandle;
      FLockEvent: THandle;
    public
      PreviewHandlerStartEvents: TPreviewHandlerEvents;
      PreviewHandlerRunEvents: TPreviewHandlerEvents;
      procedure CreateEvents;
      procedure DeleteEvents;
      procedure Lock;
      procedure Cancel;
      procedure Reset;
      procedure SizeChanged;
      procedure Unlock;
    end;
  strict private
    class var FRegisteredCustomHandlers: TDictionary<string, TdxFilePreviewCustomHandlerClass>;
  strict private
    FCurrentFileName: string;
    FCustomHandler: TdxFilePreviewCustomHandler;
    FEvents: TEvents;
    FFileName: string;
    FMode: TdxFilePreviewMode;
    FPreviewBitmap: HBITMAP;
    FPreviewDelay: Integer;
    FTaskDispatcher: TdxPreviewTaskDispatcher;
    FThumbnailAdornment: TdxThumbnailAdornmentKind;
    FShellNotifierPidl: PItemIDList;
    FShellNotifierData: TcxShellChangeNotifierData;
    FStartTimer: TcxTimer;
    FSources: TdxFilePreviewSources;
    procedure DeleteBitmap;
    procedure DoNCPaint(AWindowDC: HDC);
    procedure OnTimer(Sender: TObject);
    procedure SetFileName(const AValue: string);
    procedure SetMode(const AValue: TdxFilePreviewMode);
    procedure SetShellNotifier(const AFileName: string);
    procedure StartTimer;
    procedure StopTimer;
    procedure DSMSystemShellChangeNotify(var Message: TMessage); message DSM_SYSTEMSHELLCHANGENOTIFY;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    class procedure Initialize; static;
    class procedure Finalize; static;

    function CanApplyPreview(const AFileName: string; AMode: TdxFilePreviewMode): Boolean;
    procedure CancelCurrentPreview;
    procedure DrawCustomPreview(const ABounds: TRect); virtual;
    procedure DrawEmptyPreview(const ABounds: TRect); virtual;
    procedure DrawThumbnail(const ABounds: TRect); virtual;
    function FindCustomHandlerClass(const AFileName: string): TdxFilePreviewCustomHandlerClass; virtual;
    function GetPreviewBounds: TRect;
    function GetPreviewMessage: string; virtual;
    procedure GetPreviewHandlerVisuals(out ALogFont: TLogFont; out ATextColor, ABkgColor: TColorRef);
    function GetPreviewPaintBounds(const ABounds: TRect; AImageWidth, AImageHeight: Integer; const AMargins: TRect; AKeepAspectRatio: Boolean): TRect;
    function GetAdornmentMargins: TRect;
    procedure DoPaint; override;
    procedure SetCustomHandlerMode(AHandler: TdxFilePreviewCustomHandler);
    procedure SetEmptyPreviewMode;
    procedure SetNoFilePreviewMode;
    procedure SetPreviewHandlerMode;
    procedure SetThumbnailMode(ABitmap: HBITMAP);

    procedure UpdatePreviewSize;
    class procedure RegisterCustomPreview(const AFileExtension: string; AHandlerClass: TdxFilePreviewCustomHandlerClass); static;
    class procedure UnregisterCustomPreview(const AFileExtension: string; AHandlerClass: TdxFilePreviewCustomHandlerClass); static;

    property Events: TEvents read FEvents;
    property Mode: TdxFilePreviewMode read FMode write SetMode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property FileName: string read FFileName write SetFileName;
  published
    property Align;
    property Font;
    property LookAndFeel;
    property ParentFont;
    property PreviewDelay: Integer read FPreviewDelay write FPreviewDelay default DefaultPreviewDelay;
    property Sources: TdxFilePreviewSources read FSources write FSources default DefaultFilePreviewSources;
  end;

  { TdxCustomFilePreviewTask }

  TdxCustomFilePreviewTask = class(TInterfacedObject, IdxTask)
  strict private
    FFileName: string;
    FPane: TdxFilePreviewPane;
    FPreviewMode: TdxFilePreviewMode;
  strict protected
    FHasError: Boolean;
    // IdxTask
    function Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus; virtual; abstract;
    procedure OnComplete(AStatus: TdxTaskCompletedStatus); virtual; abstract;

    function CanApply(AStatus: TdxTaskCompletedStatus): Boolean;
    procedure Invalidate;

    property Pane: TdxFilePreviewPane read FPane;
    property PreviewMode: TdxFilePreviewMode read FPreviewMode;
  public
    constructor Create(APreviewPane: TdxFilePreviewPane; const AFileName: string; APreviewMode: TdxFilePreviewMode);

    property HasError: Boolean read FHasError;
    property FileName: string read FFileName;
  end;

  { TdxFilePreviewHandlerTask }

  TdxFilePreviewHandlerTask = class(TdxCustomFilePreviewTask)
  private
    FPreviewBounds: TRect;
    FPreviewHandlerCLSID: string;
  protected
    function Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus; override;
    procedure OnComplete(AStatus: TdxTaskCompletedStatus); override;
    procedure UpdateBounds(const APreviewHandler: IPreviewHandler);
  public
    constructor Create(APreviewPane: TdxFilePreviewPane; const AFileName, APreviewHandlerCLSID: string);
  end;

  { TdxFileThumbnailTask }

  TdxFileThumbnailTask = class(TdxCustomFilePreviewTask)
  private
    FBitmap: HBITMAP;
    FThumbnailSize: TSize;
  protected
    function Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus; override;
    procedure OnComplete(AStatus: TdxTaskCompletedStatus); override;
  public
    constructor Create(APreviewPane: TdxFilePreviewPane; const AFileName: string);
    destructor Destroy; override;
  end;

  { TdxFilePreviewCustomHandlerTask }

  TdxFilePreviewCustomHandlerTask = class(TdxCustomFilePreviewTask)
  private
    FHandler: TdxFilePreviewCustomHandler;
  protected
    function Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus; override;
    procedure OnComplete(AStatus: TdxTaskCompletedStatus); override;
  public
    constructor Create(APreviewPane: TdxFilePreviewPane; const AFileName: string; APreview: TdxFilePreviewCustomHandler);
    destructor Destroy; override;
  end;

  { TdxPreviewTaskDispatcher }

  TdxPreviewTaskDispatcher = class(TdxTaskDispatcher)
  strict private
    FPane: TdxFilePreviewPane;
  protected
    property Pane: TdxFilePreviewPane read FPane;
  public
    constructor Create(APreviewPane: TdxFilePreviewPane);
    procedure QueryPreview(const AFileName: string);
  end;

procedure ReadDialogFilePreviewInfo(var AVisible: Boolean; var AWidth: Integer);
procedure WriteDialogFilePreviewInfo(AVisible: Boolean; AWidth: Integer);

{$ENDREGION}

implementation

uses
  Math, SysUtils, Graphics, ComObj, ActiveX, Registry, PropSys, IOUtils,
  Forms, cxGeometry, dxTypeHelpers, cxEditConsts, cxLookAndFeelPainters, dxDPIAwareUtils;

const
  dxThisUnitName = 'dxShellFilePreview';

const
 {$EXTERNALSYM IID_IThumbnailProvider}
  IID_IThumbnailProvider: TGUID = '{E357FCCD-A995-4576-B01F-234630154E96}';

  PreviewPaneInfoRegistryKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CIDOpen\Modules\GlobalSettings\Sizer';

type
 {$EXTERNALSYM IThumbnailProvider}
  IThumbnailProvider = interface(IUnknown)
    ['{E357FCCD-A995-4576-B01F-234630154E96}']
    function GetThumbnail(cx : uint; out hBitmap : HBITMAP; out bitmapType : dword):HRESULT; stdcall;
  end;

  TReadingPaneSizerData = packed record
    Width: DWORD;
    Visible: DWORD;
    D1: DWORD;
    D2: DWORD;
  end;

const
  DefaultReadingPaneSizerData: TReadingPaneSizerData = (
    Width  : $00000104;
    Visible: $00000001;
    D1     : $00000000;
    D2     : $00000209);

type
  { TdxPreviewHandlers }

  TdxPreviewHandlers = class
  strict private
    class var FPreviewGUIDs: TdxStringsDictionary;
    class function GetPreviewHandler(const AFileName: string): string; static;
  protected
    class procedure Initialize; static;
    class procedure Finalize; static;
  public
    class property PreviewHandlers[const AFileName: string]: string read GetPreviewHandler;
  end;

function GetShellObjectCLSID(const AExtention: string; const ADesiredHandler: string): string;
const
  ASSOCF_INIT_DEFAULTTOSTAR = 4;
  ASSOCSTR_SHELLEXTENSION   = 16;
var
  ABuffer: array[0..1024] of Char;
  ABufferSize: DWORD;
begin
  ABufferSize := 1024; 
  if dxAssocQueryString(
          ASSOCF_INIT_DEFAULTTOSTAR,
          ASSOCSTR_SHELLEXTENSION, 
          PChar(AExtention),
          PChar(ADesiredHandler),
          @ABuffer[0],             
          @ABufferSize) <> S_OK then
    Result := ''
   else
     Result := PChar(@ABuffer[0]);
end;

function CreatePreviewComObject(const APreviewHandlerClassID: string): IPreviewHandler;
begin
{$IFDEF CPUX86}
  try
    Set8087CW( Default8087CW or $08);
{$ENDIF CPUX86}
    if CoCreateInstance(StringToGUID(APreviewHandlerClassID), nil,
       CLSCTX_LOCAL_SERVER or CLSCTX_ENABLE_CLOAKING or
       CLSCTX_NO_FAILURE_LOG 
      , IPreviewHandler, Result) <> S_OK then
      Result := nil;
{$IFDEF CPUX86}
  finally
    Reset8087CW;
  end;
{$ENDIF CPUX86}
end;

function GetReadingPaneSizerValue(out AValue: TReadingPaneSizerData): Boolean;
var
  ARegistry: TRegistry;
  ADataInfo: TRegDataInfo;
begin
  Result := False;
  if not IsWinSevenOrLater then
    Exit;

  ARegistry := TRegistry.Create(KEY_READ);
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.KeyExists(PreviewPaneInfoRegistryKey) then
    begin
      if ARegistry.OpenKeyReadOnly(PreviewPaneInfoRegistryKey) and
         ARegistry.GetDataInfo('ReadingPaneSizer', ADataInfo) and
         (ADataInfo.RegData = rdBinary) and
         (ADataInfo.DataSize = SizeOf(TReadingPaneSizerData)) then
      begin
        Result := ARegistry.ReadBinaryData('ReadingPaneSizer', AValue, SizeOf(AValue)) = SizeOf(AValue);
      end;
    end;
    if not Result then
    begin
      AValue := DefaultReadingPaneSizerData;
      Result := True;
    end;
  finally
    ARegistry.CloseKey;
    ARegistry.Free;
  end;
end;

procedure ReadDialogFilePreviewInfo(var AVisible: Boolean; var AWidth: Integer);
const
  MinWidth = $44;
  DefaultPreviewWidth = 200;
var
  ABuffer: TReadingPaneSizerData;
begin
  AVisible := False;
  AWidth := DefaultPreviewWidth;
  if not IsWinSevenOrLater then
    Exit;
  if GetReadingPaneSizerValue(ABuffer) then
  begin
    AVisible := ABuffer.Visible = 1;
    AWidth := ABuffer.Width;
    if AWidth < MinWidth then
      AWidth := MinWidth;
  end;
end;

procedure WriteDialogFilePreviewInfo(AVisible: Boolean; AWidth: Integer);
var
  ARegistry: TRegistry;
  ABuffer: TReadingPaneSizerData;
begin
  if not IsWinSevenOrLater then
    Exit;

  if not GetReadingPaneSizerValue(ABuffer) then
    Exit;

  ARegistry := TRegistry.Create(KEY_WRITE);
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKey(PreviewPaneInfoRegistryKey, True) then
    begin
      ABuffer.Visible := Ord(AVisible);
      ABuffer.Width := AWidth;
      ARegistry.WriteBinaryData('ReadingPaneSizer', ABuffer, SizeOf(ABuffer));
    end;
  finally
    ARegistry.CloseKey;
    ARegistry.Free;
  end;
end;

function GetPreviewHandlerCLSID(const AFileName: string): string;
begin
  Result := TdxPreviewHandlers.PreviewHandlers[AFileName];
end;

{ TdxPreviewHandlers }

class procedure TdxPreviewHandlers.Initialize;
begin
  FPreviewGUIDs := TdxStringsDictionary.Create(140);
end;

class procedure TdxPreviewHandlers.Finalize;
begin
  FreeAndNil(FPreviewGUIDs);
end;

class function TdxPreviewHandlers.GetPreviewHandler(const AFileName: string): string;
var
  AExtention: string;
  APreviewHandler: IPreviewHandler;
begin
  Result := '';
  AExtention := UpperCase(TPath.GetExtension(AFileName));
  if AExtention = '' then
    Exit;
  if not FPreviewGUIDs.TryGetValue(AExtention, Result) then
  begin
    Result := GetShellObjectCLSID(AExtention, SID_IPreviewHandler);
    if Result <> '' then
    begin
      APreviewHandler := CreatePreviewComObject(Result);
      if APreviewHandler = nil then
        Result := ''
      else
        APreviewHandler := nil;
    end;
    FPreviewGUIDs.Add(AExtention, Result);
  end;
end;

{ TdxFilePreviewCustomHandler }

constructor TdxFilePreviewCustomHandler.Create(APane: TdxFilePreviewPane; const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
  FPane := APane;
end;

class procedure TdxFilePreviewCustomHandler.Register(const AFileExtension: string);
begin
  TdxFilePreviewPane.RegisterCustomPreview(AFileExtension, Self);
end;

class procedure TdxFilePreviewCustomHandler.Unregister(const AFileExtension: string);
begin
  TdxFilePreviewPane.UnregisterCustomPreview(AFileExtension, Self);
end;

{ TdxFilePreviewImageBasedHandler }

function TdxFilePreviewImageBasedHandler.KeepAspectRatio: Boolean;
begin
  Result := True;
end;

function TdxFilePreviewImageBasedHandler.ShowShadow: Boolean;
begin
  Result := True;
end;

{ TdxFilePreviewControlBasedHandler }

destructor TdxFilePreviewControlBasedHandler.Destroy;
begin
  FControl.Parent := nil;
  FreeAndNil(FControl);
  inherited Destroy;
end;

function TdxFilePreviewControlBasedHandler.Initialize: Boolean;
begin
  FControl := CreateControl(FileName);
  Result := FControl <> nil;
  if Result then
  begin
    FControl.Align := alClient;
    FControl.Parent := Pane;
  end;
end;

function TdxFilePreviewControlBasedHandler.RunInThread: Boolean;
begin
  Result := False;
end;

{ TdxFilePreviewPane.TEvents }

procedure TdxFilePreviewPane.TEvents.CreateEvents;
begin
  FCancelEvent := CreateEvent(nil, True, False, nil);
  FResizeEvent := CreateEvent(nil, False, False, nil); 
  FLockEvent   := CreateEvent(nil, True, True, nil);
  PreviewHandlerStartEvents[0] := FLockEvent;
  PreviewHandlerStartEvents[1] := FCancelEvent;
  PreviewHandlerRunEvents[0] := FResizeEvent;
  PreviewHandlerRunEvents[1] := FCancelEvent;
end;

procedure TdxFilePreviewPane.TEvents.DeleteEvents;
begin
  CloseHandle(FCancelEvent);
  CloseHandle(FResizeEvent);
  CloseHandle(FLockEvent);
end;

procedure TdxFilePreviewPane.TEvents.Cancel;
begin
  SetEvent(FCancelEvent);
end;

procedure TdxFilePreviewPane.TEvents.Lock;
begin
  ResetEvent(FLockEvent);
end;

procedure TdxFilePreviewPane.TEvents.Reset;
begin
  ResetEvent(FCancelEvent);
end;

procedure TdxFilePreviewPane.TEvents.SizeChanged;
begin
  SetEvent(FResizeEvent);
end;

procedure TdxFilePreviewPane.TEvents.Unlock;
begin
  SetEvent(FLockEvent);
end;

{ TdxFilePreviewPane }

constructor TdxFilePreviewPane.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderWidth := LookAndFeelPainter.BorderSize; 
  BorderStyle := cxcbsNone;
  FSources := DefaultFilePreviewSources;
  FPreviewDelay := DefaultPreviewDelay;
  FEvents.CreateEvents;
  FMode := TdxFilePreviewMode.NoFile;
  FTaskDispatcher := TdxPreviewTaskDispatcher.Create(Self);
  Width := 100;
  Height := 100;
end;

destructor TdxFilePreviewPane.Destroy;
begin
  cxShellUnregisterChangeNotifier(FShellNotifierData);
  dxFreeAndNilPidl(FShellNotifierPidl);
  CancelCurrentPreview;
  StopTimer;
  FTaskDispatcher.Free;
  FEvents.DeleteEvents;
  inherited Destroy;
end;

class procedure TdxFilePreviewPane.Initialize;
begin
  FRegisteredCustomHandlers := TDictionary<string, TdxFilePreviewCustomHandlerClass>.Create;
end;

class procedure TdxFilePreviewPane.Finalize;
begin
  FreeAndNil(FRegisteredCustomHandlers);
end;

class procedure TdxFilePreviewPane.RegisterCustomPreview(const AFileExtension: string; AHandlerClass: TdxFilePreviewCustomHandlerClass);
var
  AKey: string;
begin
  AKey := Trim(UpperCase(AFileExtension));
  FRegisteredCustomHandlers.AddOrSetValue(AKey, AHandlerClass);
end;

class procedure TdxFilePreviewPane.UnregisterCustomPreview(const AFileExtension: string; AHandlerClass: TdxFilePreviewCustomHandlerClass);
var
  AKey: string;
  AValue: TdxFilePreviewCustomHandlerClass;
begin
  AKey := Trim(UpperCase(AFileExtension));
  if FRegisteredCustomHandlers.TryGetValue(AKey, AValue) and (AValue = AHandlerClass) then
    FRegisteredCustomHandlers.Remove(AKey);
end;

function TdxFilePreviewPane.CanApplyPreview(const AFileName: string; AMode: TdxFilePreviewMode): Boolean;
begin
  Result := HandleAllocated and (ComponentState * [csDestroying, csDesigning, csLoading] = []) and SameText(AFileName, FileName) and
    not ((Mode = AMode) and SameText(AFileName, FCurrentFileName));
end;

procedure TdxFilePreviewPane.CancelCurrentPreview;
begin
  Events.Cancel;
  DeleteBitmap;
  FreeAndNil(FCustomHandler);
end;

procedure TdxFilePreviewPane.DeleteBitmap;
begin
  if FPreviewBitmap <> 0 then
  begin
    DeleteObject(FPreviewBitmap);
    FPreviewBitmap := 0;
  end;
end;

procedure TdxFilePreviewPane.DrawCustomPreview(const ABounds: TRect);
var
  APaintRect: TRect;
  APreview: TdxFilePreviewImageBasedHandler;
begin
  APreview := Safe<TdxFilePreviewImageBasedHandler>.Cast(FCustomHandler);
  if APreview = nil then
    Exit;
  if APreview.ShowShadow then
  begin
    APaintRect := GetPreviewPaintBounds(ABounds, APreview.Width,
      APreview.Height, GetAdornmentMargins, APreview.KeepAspectRatio);

    TdxThumbnailAdornmentHelper.DrawAdornment(Canvas.Handle, APaintRect, TdxThumbnailAdornmentKind.DropShadow, LookAndFeelPainter,
      procedure (DC: HDC; ABounds: TRect)
      var
        AGraphics: TdxGPGraphics;
      begin
        AGraphics := TdxGPGraphics.Create(DC);
        try
          APreview.DrawPreview(Canvas, ABounds);
        finally
          AGraphics.Free;
        end;
      end);
  end
  else
  begin
    APaintRect := GetPreviewPaintBounds(ABounds,
      APreview.Width,
      APreview.Height,
      TRect.Null,
      APreview.KeepAspectRatio);
    if not APaintRect.IsEmpty then
      APreview.DrawPreview(Canvas, APaintRect);
  end;
end;

procedure TdxFilePreviewPane.DrawEmptyPreview(const ABounds: TRect);
begin
  Canvas.Font := Font;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(ABounds, LookAndFeelPainter.DefaultContentColor);
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Color := LookAndFeelPainter.DefaultContentTextColor;
  Canvas.DrawTexT(GetPreviewMessage, ABounds, taCenter, TcxAlignmentVert.vaCenter, True, False);
  Canvas.Brush.Style := bsSolid;
end;

function TdxFilePreviewPane.GetAdornmentMargins: TRect;
begin
  Result := TdxThumbnailAdornmentHelper.GetAdornmentMargins(TdxThumbnailAdornmentKind.DropShadow);
end;

procedure TdxFilePreviewPane.DrawThumbnail(const ABounds: TRect);
var
  APaintRect: TRect;
  AImage: TdxGPImage;
begin
   AImage := TdxGPImage.CreateFromHBitmap(FPreviewBitmap);
   try
      APaintRect := GetPreviewPaintBounds(ABounds, AImage.Width, AImage.Height,
        TdxThumbnailAdornmentHelper.GetAdornmentMargins(FThumbnailAdornment), True);

      TdxThumbnailAdornmentHelper.DrawAdornment(Canvas.Handle, APaintRect, FThumbnailAdornment, LookAndFeelPainter,
        procedure (DC: HDC; ABounds: TRect)
        var
          AGraphics: TdxGPGraphics;
        begin
          AGraphics := TdxGPGraphics.Create(DC);
          try
            AGraphics.Draw(AImage, ABounds);
          finally
            AGraphics.Free;
          end;
        end);
  finally
     AImage.Free;
  end;
end;

function TdxFilePreviewPane.GetPreviewBounds: TRect;
begin
  Result := dxSystemScaleFactor.Apply(ClientRect, ScaleFactor);
end;

function TdxFilePreviewPane.GetPreviewMessage: string;
var
  ALibraryHandle: THandle;
begin
  ALibraryHandle := LoadLibraryEx('shell32.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    case Mode of
      TdxFilePreviewMode.NoFile: Result := dxGetLocalizedSystemResourceString(sdxFilePreviewPanePreviewMessageNoFile, ALibraryHandle, 38245);
      TdxFilePreviewMode.Empty: Result := dxGetLocalizedSystemResourceString(sdxFilePreviewPanePreviewMessageEmpty, ALibraryHandle, 38246)
    else
      Result := '';
    end;
  finally
    FreeLibrary(ALibraryHandle);
  end;
end;

function TdxFilePreviewPane.FindCustomHandlerClass(const AFileName: string): TdxFilePreviewCustomHandlerClass;
var
  AExtension: string;
begin
  AExtension := UpperCase(TPath.GetExtension(AFileName));
  if not FRegisteredCustomHandlers.TryGetValue(AExtension, Result) then
    Result := nil;
end;

procedure TdxFilePreviewPane.GetPreviewHandlerVisuals(out ALogFont: TLogFont; out ATextColor, ABkgColor: TColorRef);
begin
  ABkgColor := ColorToRGB(LookAndFeelPainter.DefaultContentColor);
  ATextColor := ColorToRGB(LookAndFeelPainter.DefaultContentTextColor);
  cxGetFontData(Font.Handle, ALogFont);
end;

function TdxFilePreviewPane.GetPreviewPaintBounds(const ABounds: TRect; AImageWidth, AImageHeight: Integer;
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

procedure TdxFilePreviewPane.DoPaint;
var
  ABounds: TRect;
begin
  inherited DoPaint;
  ABounds := ClientBounds;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(ABounds, LookAndFeelPainter.DefaultContentColor);
  ABounds.Deflate(PreviewPadding);
  if ABounds.IsEmpty then
    Exit;
  case Mode of
    TdxFilePreviewMode.Empty,
    TdxFilePreviewMode.NoFile:
      DrawEmptyPreview(ABounds);
    TdxFilePreviewMode.Thumbnail:
      DrawThumbnail(ABounds);
    TdxFilePreviewMode.CustomHandler:
      DrawCustomPreview(ABounds);
  end;
end;

procedure TdxFilePreviewPane.UpdatePreviewSize;
begin
  if Mode = TdxFilePreviewMode.PreviewHandler then
    FEvents.SizeChanged;
end;

procedure TdxFilePreviewPane.SetFileName(const AValue: string);
begin
  if not SameText(FFileName, AValue) then
  begin
    FFileName := AValue;
    SetShellNotifier(AValue);
    if Trim(AValue) = '' then
      SetNoFilePreviewMode
    else
      StartTimer;
  end;
end;

procedure TdxFilePreviewPane.SetMode(const AValue: TdxFilePreviewMode);
begin
  FMode := AValue;
  Invalidate;
end;

procedure TdxFilePreviewPane.SetShellNotifier(const AFileName: string);
var
  AShellItem, AParentShellItem: IShellItem;
  APidl: PItemIDList;
begin
  if Succeeded(SHCreateItemFromParsingName(PChar(AFileName), nil, IID_IShellItem, AShellItem)) then
  begin
    if Succeeded(AShellItem.GetParent(AParentShellItem)) and
      Succeeded(SHGetIDListFromObject(AParentShellItem, APidl)) then
    begin
      cxShellRegisterChangeNotifier(APidl, Handle, DSM_SYSTEMSHELLCHANGENOTIFY, False, FShellNotifierData);
      dxFreeAndNilPidl(FShellNotifierPidl);
      FShellNotifierPidl := APidl;
    end;
  end;
end;

procedure TdxFilePreviewPane.SetCustomHandlerMode(AHandler: TdxFilePreviewCustomHandler);
begin
  CancelCurrentPreview;
  FCurrentFileName := FileName;
  FCustomHandler := AHandler;
  Mode := TdxFilePreviewMode.CustomHandler;
end;

procedure TdxFilePreviewPane.SetEmptyPreviewMode;
begin
  CancelCurrentPreview;
  FCurrentFileName := FileName;
  Mode := TdxFilePreviewMode.Empty;
end;

procedure TdxFilePreviewPane.SetNoFilePreviewMode;
begin
  CancelCurrentPreview;
  FCurrentFileName := FileName;
  Mode := TdxFilePreviewMode.NoFile;
end;

procedure TdxFilePreviewPane.SetPreviewHandlerMode;
begin
  CancelCurrentPreview;
  Events.Reset;
  FCurrentFileName := FileName;
  Mode := TdxFilePreviewMode.PreviewHandler;
end;

procedure TdxFilePreviewPane.SetThumbnailMode(ABitmap: HBITMAP);
begin
  CancelCurrentPreview;
  FPreviewBitmap := ABitmap;
  FCurrentFileName := FileName;
  FThumbnailAdornment := TdxThumbnailAdornmentHelper.GetAdornmentKind(TPath.GetExtension(FileName));
  Mode := TdxFilePreviewMode.Thumbnail;
end;

procedure TdxFilePreviewPane.OnTimer(Sender: TObject);
begin
  StopTimer;
  FCurrentFileName := '';
  Events.Cancel;
  FTaskDispatcher.QueryPreview(FFileName);
end;

procedure TdxFilePreviewPane.StartTimer;
begin
  FreeAndNil(FStartTimer);
  FStartTimer := TcxTimer.Create(nil);
  FStartTimer.Interval := PreviewDelay;
  FStartTimer.OnTimer := OnTimer;
end;

procedure TdxFilePreviewPane.StopTimer;
begin
  FreeAndNil(FStartTimer);
end;

procedure TdxFilePreviewPane.DSMSystemShellChangeNotify(var Message: TMessage);
var
  AEventID: Integer;
  APidl1: PItemIDList;
  APidls: PPidlList;
  ALock: THandle;
  ABuffer: array[0..MAX_PATH] of Char;
  ABufferName: LPWSTR;
begin
  ALock := SHChangeNotification_Lock(Message.WParam, Message.LParam, APidls, AEventID);
  if ALock <> 0 then
  begin
    try
      APidl1 := GetPidlCopy(APidls^[0]);
    finally
      SHChangeNotification_UnLock(ALock);
    end;
    if (AEventID = SHCNE_DELETE) or (AEventID = SHCNE_RMDIR) then
    begin
      ABufferName := @ABuffer;
      if Succeeded(SHGetNameFromIDList(APidl1, Integer(SIGDN_FILESYSPATH), ABufferName)) then
        if SameText(FileName, string(ABufferName)) then
          FileName := '';
    end;
  end;
end;

procedure TdxFilePreviewPane.WMNCPaint(var Message: TWMNCPaint);
var
  DC: THandle;
  AFlags: Integer;
  ARegion, AUpdateRegion: HRGN;
begin
  AFlags := DCX_CACHE or DCX_CLIPSIBLINGS or DCX_WINDOW or DCX_VALIDATE;
  AUpdateRegion := Message.RGN;

  if AUpdateRegion <> 1 then
  begin
    ARegion := CreateRectRgnIndirect(cxEmptyRect);
    CombineRgn(ARegion, AUpdateRegion, 0, RGN_COPY);
    AFlags := AFlags or DCX_INTERSECTRGN;
  end
  else
    ARegion := 0;

  DC := GetDCEx(Handle, ARegion, AFlags);
  DoNCPaint(DC);
  ReleaseDC(Handle, DC);
  Message.Result := 0;
end;

procedure TdxFilePreviewPane.DoNCPaint(AWindowDC: HDC);
var
  ABounds, AClientRect: TRect;
  ASaveIndex: Integer;
begin
  ASaveIndex := SaveDC(AWindowDC);
  try
    AClientRect := cxRectOffset(ClientRect, cxGetClientOffset(Handle));
    ExcludeClipRect(AWindowDC, AClientRect.Left, AClientRect.Top, AClientRect.Right, AClientRect.Bottom);
    ABounds := cxGetWindowBounds(Self);
    cxPaintCanvas.BeginPaint(AWindowDC);
    try
      LookAndFeelPainter.DrawBorder(cxPaintCanvas, ABounds);
    finally
      cxPaintCanvas.EndPaint;
    end;
  finally
    RestoreDC(AWindowDC, ASaveIndex);
  end;
end;

procedure TdxFilePreviewPane.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdatePreviewSize;
end;

{ TdxCustomFilePreviewTask }

constructor TdxCustomFilePreviewTask.Create(APreviewPane: TdxFilePreviewPane; const AFileName: string; APreviewMode: TdxFilePreviewMode);
begin
  inherited Create;
  FFileName := AFileName;
  FPane := APreviewPane;
  FPreviewMode := APreviewMode;
  Assert(FPane.HandleAllocated);
end;

function TdxCustomFilePreviewTask.CanApply(AStatus: TdxTaskCompletedStatus): Boolean;
begin
  Result := (AStatus = TdxTaskCompletedStatus.Success) and not HasError and
    Pane.CanApplyPreview(FileName, FPreviewMode);
end;

procedure TdxCustomFilePreviewTask.Invalidate;
begin
  FHasError := True;
end;

{ TdxFilePreviewHandlerTask }

constructor TdxFilePreviewHandlerTask.Create(APreviewPane: TdxFilePreviewPane; const AFileName, APreviewHandlerCLSID: string);
begin
  inherited Create(APreviewPane, AFileName, TdxFilePreviewMode.PreviewHandler);
  FPreviewHandlerCLSID := APreviewHandlerCLSID;
end;

procedure TdxFilePreviewHandlerTask.OnComplete(AStatus: TdxTaskCompletedStatus);
begin
end;

function TdxFilePreviewHandlerTask.Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus;
var
  AInitializeWithFile: IInitializeWithFile;
  AInitializeWithStream: IInitializeWithStream;
  AInitializeWithItem: IInitializeWithItem;
  AIStream: IStream;
  AMemory: TdxMemoryStream;
  APreviewHandler: IPreviewHandler;
  AShellItem: IShellItem;
  APreviewHandlerVisuals: IPreviewHandlerVisuals;
  ALogFont: TLogFont;
  ATextColor, ABkgColor: TColorRef;
begin
  APreviewHandler := nil;
  if WaitForMultipleObjects(2, @Pane.Events.PreviewHandlerStartEvents, False, INFINITE) <> WAIT_OBJECT_0 then
  begin
    Exit(TdxTaskCompletedStatus.Cancelled);
  end;
  TThread.Synchronize(nil,
    procedure ()
    begin
      if not CanApply(TdxTaskCompletedStatus.Success) then
        FHasError := True
      else
        Pane.Events.Lock;
    end);
  if HasError then
  begin
    Exit(TdxTaskCompletedStatus.Cancelled);
  end;
  CoInitializeEx(nil, COINIT_MULTITHREADED or COINIT_DISABLE_OLE1DDE or COINIT_SPEED_OVER_MEMORY);
  try
    APreviewHandler := CreatePreviewComObject(FPreviewHandlerCLSID);
    if APreviewHandler = nil then
      Exit(TdxTaskCompletedStatus.Fail);

    try
      if APreviewHandler.QueryInterface(IInitializeWithStream, AInitializeWithStream) = S_OK then
      begin
        AMemory := TdxMemoryStream.Create(FileName, fmOpenRead or fmShareDenyNone);
        AIStream := TStreamAdapter.Create(AMemory, soOwned);
        AInitializeWithStream.Initialize(AIStream, STGM_READ);
      end
      else if APreviewHandler.QueryInterface(IInitializeWithFile, AInitializeWithFile) = S_OK then
        AInitializeWithFile.Initialize(PChar(FileName), STGM_READ)
      else if APreviewHandler.QueryInterface(IInitializeWithItem, AInitializeWithItem) = S_OK then
      begin
        SHCreateItemFromParsingName(PChar(FileName), nil, IID_ISHELLITEM, AShellItem);
        AInitializeWithItem.Initialize(AShellItem, 0);
      end
      else
        Exit(TdxTaskCompletedStatus.Fail);
      Result := TdxTaskCompletedStatus.Success;
    except
      Result := TdxTaskCompletedStatus.Fail;
    end;

    TThread.Synchronize(nil,
      procedure ()
      begin
        FPreviewBounds := Pane.GetPreviewBounds;
        if CanApply(TdxTaskCompletedStatus.Success) then
        begin
          Pane.GetPreviewHandlerVisuals(ALogFont, ATextColor, ABkgColor);
          Pane.SetPreviewHandlerMode;
        end
        else
          FHasError := True;
      end);

    if (Result <> TdxTaskCompletedStatus.Success) or HasError then
      Exit(TdxTaskCompletedStatus.Cancelled);

    if APreviewHandler.QueryInterface(IPreviewHandlerVisuals, APreviewHandlerVisuals) = S_OK then
    begin
      APreviewHandlerVisuals.SetBackgroundColor(ABkgColor);
      APreviewHandlerVisuals.SetTextColor(ATextColor);
      APreviewHandlerVisuals.SetFont(ALogFont);
    end;
    APreviewHandler.SetWindow(Pane.Handle, FPreviewBounds);
    APreviewHandler.DoPreview;
    APreviewHandler.SetRect(FPreviewBounds);
    TThread.Synchronize(nil,
      procedure ()
      begin
        if not SameText(Pane.FileName, FileName) then
          FHasError := True;
      end);
    if HasError then
      Exit(TdxTaskCompletedStatus.Cancelled);
    repeat
      if WaitForMultipleObjects(2, @Pane.Events.PreviewHandlerRunEvents, False, INFINITE) = WAIT_OBJECT_0 then
      begin
        UpdateBounds(APreviewHandler);
      end
      else
      begin
        Exit(TdxTaskCompletedStatus.Cancelled);
      end;
    until Application.Terminated;

    if Application.Terminated then
      Result := TdxTaskCompletedStatus.Cancelled
    else
      Result := TdxTaskCompletedStatus.Success;
  finally
    if APreviewHandler <> nil then
    begin
      APreviewHandler.Unload;
      APreviewHandler := nil;
    end;
    Pane.Events.Unlock;
    CoUninitialize;
  end;
end;

procedure TdxFilePreviewHandlerTask.UpdateBounds(const APreviewHandler: IPreviewHandler);
begin
  TThread.Synchronize(nil,
    procedure ()
    begin
      FPreviewBounds := Pane.GetPreviewBounds;
    end);
  APreviewHandler.SetRect(FPreviewBounds);
  RedrawWindow(Pane.Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_ALLCHILDREN or RDW_FRAME);
end;

{ TdxFileThumbnailTask }

constructor TdxFileThumbnailTask.Create(APreviewPane: TdxFilePreviewPane; const AFileName: string);
begin
  inherited Create(APreviewPane, AFileName, TdxFilePreviewMode.Thumbnail);
  FThumbnailSize.Init(Pane.ClientWidth, Pane.ClientHeight);
end;

destructor TdxFileThumbnailTask.Destroy;
begin
  if FBitmap <> 0 then
    DeleteObject(FBitmap);
  inherited Destroy;
end;

procedure TdxFileThumbnailTask.OnComplete(AStatus: TdxTaskCompletedStatus);
begin
  if CanApply(AStatus) then
  begin
    Pane.SetThumbnailMode(FBitmap);
    FBitmap := 0;
  end
  else if Pane.CanApplyPreview(FileName, PreviewMode) then
    Pane.SetEmptyPreviewMode;
end;

function TdxFileThumbnailTask.Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus;
var
  AItemImageFactory: IShellItemImageFactory;
  AShellItem: IShellItem;
begin
  FBitmap := 0;
  Result := TdxTaskCompletedStatus.Fail;
  CoInitializeEx(nil, COINIT_MULTITHREADED or COINIT_DISABLE_OLE1DDE);
  try
    if SHCreateItemFromParsingName(PChar(FileName), nil, IID_IShellItem, AShellItem) = S_OK then
      if AShellItem.QueryInterface(IID_IShellItemImageFactory, AItemImageFactory) = S_OK then
        if AItemImageFactory.GetImage(FThumbnailSize,
            SIIGBF_THUMBNAILONLY or
            SIIGBF_BIGGERSIZEOK,
            FBitmap) = S_OK then
        Result := TdxTaskCompletedStatus.Success;
  finally
    CoUninitialize;
  end;
end;

{ TdxFilePreviewCustomHandlerTask }

constructor TdxFilePreviewCustomHandlerTask.Create(APreviewPane: TdxFilePreviewPane; const AFileName: string;
  APreview: TdxFilePreviewCustomHandler);
begin
  inherited Create(APreviewPane, AFileName, TdxFilePreviewMode.CustomHandler);
  FHandler := APreview;
end;

destructor TdxFilePreviewCustomHandlerTask.Destroy;
begin
  FreeAndNil(FHandler);
  inherited Destroy;
end;

procedure TdxFilePreviewCustomHandlerTask.OnComplete(AStatus: TdxTaskCompletedStatus);
begin
  if CanApply(AStatus) then
  begin
    Pane.SetCustomHandlerMode(FHandler);
    FHandler := nil;
  end
  else if Pane.CanApplyPreview(FileName, PreviewMode) then
    Pane.SetEmptyPreviewMode;
end;

function TdxFilePreviewCustomHandlerTask.Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus;
begin
  if FHandler.Initialize then
    Result := TdxTaskCompletedStatus.Success
  else
    Result := TdxTaskCompletedStatus.Fail;
end;

{ TdxPreviewTaskDispatcher }

constructor TdxPreviewTaskDispatcher.Create(APreviewPane: TdxFilePreviewPane);
begin
  inherited Create;
  FPane := APreviewPane;
end;

procedure TdxPreviewTaskDispatcher.QueryPreview(const AFileName: string);
var
  ACLSID: string;
  AThreadTask: TdxCustomFilePreviewTask;
  ACustomHandler: TdxFilePreviewCustomHandler;
  ACustomHandlerClass: TdxFilePreviewCustomHandlerClass;
begin
  Pane.Events.Reset;
  if TdxFilePreviewSource.PreviewHandler in Pane.Sources then
    ACLSID := TdxPreviewHandlers.PreviewHandlers[AFileName]
  else
    ACLSID := '';
  if ACLSID <> '' then
    AThreadTask := TdxFilePreviewHandlerTask.Create(Pane, AFileName, ACLSID)
  else
  begin
    if TdxFilePreviewSource.CustomHandler in Pane.Sources then
      ACustomHandlerClass := Pane.FindCustomHandlerClass(AFileName)
    else
      ACustomHandlerClass := nil;
    if ACustomHandlerClass <> nil then
    begin
      ACustomHandler := ACustomHandlerClass.Create(Pane, AFileName);
      if ACustomHandler.RunInThread then
        AThreadTask := TdxFilePreviewCustomHandlerTask.Create(Pane, AFileName, ACustomHandler)
      else
      begin
        if not ACustomHandler.Initialize then
        begin
          ACustomHandler.Free;
          Pane.SetEmptyPreviewMode;
        end
        else
          Pane.SetCustomHandlerMode(ACustomHandler);
        Exit;
      end;
    end
    else
      if TdxFilePreviewSource.Thumbnail in Pane.Sources then
        AThreadTask := TdxFileThumbnailTask.Create(Pane, AFileName)
      else
        AThreadTask := nil;
  end;
  if AThreadTask <> nil then
  begin
    if AThreadTask.HasError then
    begin
      AThreadTask.Free;
      Pane.SetEmptyPreviewMode;
    end
    else
      Run(AThreadTask);
  end
  else
    Pane.SetEmptyPreviewMode;
end;

procedure InitPreviewHandlers;
begin
  TdxFilePreviewPane.Initialize;
  TdxPreviewHandlers.Initialize;
end;

procedure DonePreviewHandlers;
begin
  TdxPreviewHandlers.Finalize;
  TdxFilePreviewPane.Finalize;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, InitPreviewHandlers, DonePreviewHandlers);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization

  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, DonePreviewHandlers);

end.
