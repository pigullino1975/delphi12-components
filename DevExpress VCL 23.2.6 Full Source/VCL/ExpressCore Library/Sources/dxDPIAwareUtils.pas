{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCore Library                                      }
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

unit dxDPIAwareUtils;

{$I cxVer.inc}

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Types, Windows, Forms, MultiMon, Classes, Contnrs, Controls, Graphics, Generics.Defaults, Generics.Collections,
  cxGeometry, dxCore;

const
  dxDefaultDPI = USER_DEFAULT_SCREEN_DPI;
  dxMaxDPI = 480;
  dxMinDPI = 30;

  dxDefaultDPIValues: array[0..7] of Integer = (96, 120, 144, 168, 192, 216, 240, 288);

  SPI_SETLOGICALDPIOVERRIDE = $9F;
  {$EXTERNALSYM SPI_SETLOGICALDPIOVERRIDE}

  WM_DPICHANGED_AFTERPARENT = $02E3;
  {$EXTERNALSYM WM_DPICHANGED_AFTERPARENT}
  WM_DPICHANGED_BEFOREPARENT = $02E2;
  {$EXTERNALSYM WM_DPICHANGED_BEFOREPARENT}

type
  TdxProcessDpiAwareness = (pdaUnaware, pdaSystemDpiAware, pdaPerMonitorDpiAware, pdaPerMonitorDpiAwareV2, pdaUnawareGdiScaled);

  TdxSystemDPINotifyEvent = procedure (Sender: TObject; AOldDPI, ANewDPI: Integer) of object;

  { IdxSourceSize }

  IdxSourceSize = interface
  ['{F8A5DDDA-FE77-45F1-8A75-203767ED5982}']
    function GetSourceSize: TSize;
  end;

  { IdxSourceDPI }

  IdxSourceDPI = interface
  ['{F722512C-50D3-4266-AA1C-399C3301BB6A}']
    function GetSourceDPI: Integer;
  end;

  { TdxCursorManager }

  TdxCursorManager = class
  strict private type
  {$REGION 'Internal Types'}
    TCursorInfo = class
    protected
      Index: Integer;
      ResInstance: THandle;
      ResInt: Integer;
      ResName: PChar;
    end;
  {$ENDREGION}
  strict private
    class var FList: TList;
  protected
    class procedure Finalize;
    class procedure DoRegister(const AInfo: TCursorInfo);
  public
    class procedure Refresh;
    class procedure Register(ACursorIndex: Integer; AResInstance: THandle; const AResName: PChar);
    class procedure Unregister(ACursorIndex: Integer);
  end;

  { TdxScaleFactorHelper }

  TdxScaleFactorHelper = class helper for TdxScaleFactor
  public
    function TargetDPI: Integer;
  end;

  TdxGetSourceDPIFunc = function (AObject: TObject; out DPI: Integer): Boolean;

var
  FGetSourceDPIFunc: TdxGetSourceDPIFunc = nil; // for internal use

procedure dxAssignFont(ATargetFont, ASourceFont: TFont; ATargetScaleFactor, ASourceScaleFactor: TdxScaleFactor); overload;
procedure dxAssignFont(ATargetFont, ASourceFont: TFont; ATargetDPI, ASourceDPI: Integer); overload;
function dxCheckDPIValue(AValue: Integer): Integer;
function dxCreateFontForDefaultDPI: TFont; overload;
function dxCreateFontForDefaultDPI(ASize: Integer): TFont; overload;
function dxGetFontHeight(AFontSize: Integer; AScaleFactor: TdxScaleFactor): Integer;
function dxGetFontHeightForDefaultDPI(AFontSize: Integer; ADesignDPI: Integer = dxDefaultDPI): Integer;
procedure dxScaleFont(AFont: TFont; M, D: Integer); inline;

function dxAdjustWindowRectEx(var R: TRect; Style, ExStyle: Cardinal; Menu: Boolean; AScaleFactor: TdxScaleFactor): Boolean;
function dxGetCurrentDPI(AComponent: TComponent): Integer;
function dxGetCurrentScaleFactor(AComponent: TComponent; out M, D: Integer): Boolean;
function dxGetFormDPI(AForm: TCustomForm): Integer;
function dxGetDesktopDPI: Integer; 
function dxGetMonitorDPI(const AMonitor: TMonitor): Integer; overload;
function dxGetMonitorDPI(const AScreenPoint: TPoint): Integer; overload;
function dxGetMonitorDPI(const AWndHandle: THandle): Integer; overload;
function dxGetTargetDPI(AComponent: TComponent): Integer;
function dxGetScaleFactor(AOwner: TObject): TdxScaleFactor;
function dxGetScaleFactorForCanvas(const ACanvas: TCanvas): TdxScaleFactor; 
function dxGetScaleFactorForInterface(const AOwner: IUnknown): TdxScaleFactor; 
function dxGetSystemDPI: Integer;
function dxGetSystemMetrics(AIndex: Integer; AScaleFactor: TdxScaleFactor = nil): Integer;
function dxTryGetScaleFactorForControl(AControl: TControl; out AScaleFactor: TdxScaleFactor): Boolean;
function dxForceUpdateControlDPI(AControl: TWinControl): Boolean;
procedure dxAddSystemDPIListener(AProcedure: TdxSystemDPINotifyEvent);

function dxDefaultScaleFactor: TdxScaleFactor;
function dxDesktopScaleFactor: TdxScaleFactor;
function dxSystemScaleFactor: TdxScaleFactor;

function dxIsGdiScaledMode: Boolean;
function dxIsProcessDPIAware: Boolean;
function dxIsProcessDPIPerMonitorV2Aware: Boolean;
function dxIsWindowsVistaCompatibilityMode: Boolean;

function dxGetProcessDpiAwareness: TdxProcessDpiAwareness; overload;
function dxGetProcessDpiAwareness(AProcess: THandle): TdxProcessDpiAwareness; overload; deprecated;
function dxGetProcessDpiAwareness(AProcess: THandle; out AValue: TdxProcessDpiAwareness): Boolean; overload;
function dxSetProcessDpiAwareness(AValue: TdxProcessDpiAwareness): Boolean;

implementation

uses
  Messages, Registry, SysUtils, Math, dxCoreGraphics, dxMessages;

const
  dxThisUnitName = 'dxDPIAwareUtils';

const
  SHCore = 'SHCore.dll';

type
  TDpiAwarenessContext = type THandle;

const
  DPI_AWARENESS_CONTEXT_INVALID = 0;
  DPI_AWARENESS_CONTEXT_UNAWARE = TDpiAwarenessContext(-1);
  DPI_AWARENESS_CONTEXT_SYSTEM_AWARE = TDpiAwarenessContext(-2);
  DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE = TDpiAwarenessContext(-3);
  DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 = TDpiAwarenessContext(-4);
  DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED = TDpiAwarenessContext(-5);

type
  TControlAccess = class(TControl);
  TCustomFormAccess = class(TCustomForm);
  TDataModuleAccess = class(TDataModule);
  TWinControlAccess = class(TWinControl);

  TProcessDpiAwareness = (
    PROCESS_DPI_UNAWARE = 0,
    PROCESS_SYSTEM_DPI_AWARE = 1,
    PROCESS_PER_MONITOR_DPI_AWARE = 2
  );

  TAdjustWindowRectExForDPI = function (var lpRect: TRect; dwStyle: DWORD; bMenu: BOOL; dwExStyle: DWORD; DPI: UINT): BOOL; stdcall;
  TAreDpiAwarenessContextsEqual = function (Value1, Value: TDpiAwarenessContext): BOOL; stdcall;
  TGetDpiForMonitorFunc = function (Monitor: HMONITOR; dpiType: Cardinal; out dpiX: UINT; out dpiY: UINT): HRESULT; stdcall;
  TGetProcessDpiAwarenessFunc = function (Process: THandle; out value: TProcessDpiAwareness): HRESULT; stdcall;
  TGetSystemMetricsForDpiFunc = function (Index, DPI: Integer): Integer; stdcall;
  TGetThreadDpiAwarenessContext = function : TDpiAwarenessContext; stdcall;
  TSetProcessDpiAwarenessFunc = function (value: TProcessDpiAwareness): HRESULT; stdcall;
  TSetThreadDpiAwarenessContext = function (Value: TDpiAwarenessContext): TDpiAwarenessContext; stdcall;

type
  { TdxSystemBasedScaleFactor }

  TdxSystemBasedScaleFactor = class(TdxScaleFactor)
  public
    procedure AfterConstruction; override;
    procedure Update; virtual; abstract;
  end;

  { TdxDesktopScaleFactor }

  TdxDesktopScaleFactor = class(TdxSystemBasedScaleFactor)
  public
    procedure Update; override;
  end;

  { TdxSystemScaleFactor }

  TdxSystemScaleFactor = class(TdxSystemBasedScaleFactor)
  public
    procedure Update; override;
  end;

  { TdxSystemDPIController }

  TdxSystemDPIController = class
  strict private
    FHandle: HWND;
    FListeners: TList<TdxSystemDPINotifyEvent>;
    class var FDPI: Integer;
    procedure MainWndProc(var Message: TMessage);
  protected
    procedure Changed(AOldDPI, ANewDPI: Integer); virtual;
    procedure SetDPI(Value: Integer); virtual;
    procedure WndProc(var Message: TMessage); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ListenerAdd(AEventHandler: TdxSystemDPINotifyEvent);
    procedure ListenerRemove(AEventHandler: TdxSystemDPINotifyEvent);

    property Handle: HWND read FHandle;
    class property DPI: Integer read FDPI;
  end;

const
  DpiAwarenessContextMap: array[TdxProcessDpiAwareness] of TDpiAwarenessContext = (
    DPI_AWARENESS_CONTEXT_UNAWARE,
    DPI_AWARENESS_CONTEXT_SYSTEM_AWARE,
    DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE,
    DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2,
    DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED
  );

var
  FUnitIsFinalized: Boolean = False;
  FDefaultScaleFactor: TdxScaleFactor = nil;
  FDesktopScaleFactor: TdxSystemBasedScaleFactor = nil;
  FSystemScaleFactor: TdxSystemBasedScaleFactor = nil;
  FSystemDPIController: TdxSystemDPIController = nil;
  FWindowsVistaCompatibilityMode: TdxDefaultBoolean = bDefault;

  FAdjustWindowRectExForDpi: TAdjustWindowRectExForDPI = nil;
  FAreDpiAwarenessContextsEqual: TAreDpiAwarenessContextsEqual = nil;
  FGetDpiForMonitor: TGetDpiForMonitorFunc;
  FGetProcessDpiAwareness: TGetProcessDpiAwarenessFunc;
  FGetSystemMetricsForDpi: TGetSystemMetricsForDpiFunc;
  FGetThreadDpiAwarenessContext: TGetThreadDpiAwarenessContext;
  FSetProcessDpiAwareness: TSetProcessDpiAwarenessFunc;
  FSetThreadDpiAwarenessContext: TSetThreadDpiAwarenessContext;
  FShellCoreLibHandle: THandle;

function dxCheckDPIValue(AValue: Integer): Integer;
begin
  Result := Min(Max(AValue, dxMinDPI), dxMaxDPI);
end;

procedure dxAssignFont(ATargetFont, ASourceFont: TFont; ATargetScaleFactor, ASourceScaleFactor: TdxScaleFactor);
begin
  ATargetFont.Assign(ASourceFont);
  ATargetFont.Height := ATargetScaleFactor.Apply(ASourceFont.Height, ASourceScaleFactor);
end;

procedure dxAssignFont(ATargetFont, ASourceFont: TFont; ATargetDPI, ASourceDPI: Integer); overload;
begin
  ATargetFont.Assign(ASourceFont);
  ATargetFont.Height := MulDiv(ASourceFont.Height, ATargetDPI, ASourceDPI);
end;

function dxCreateFontForDefaultDPI: TFont;
begin
  Result := TFont.Create;
  Result.Height := dxGetFontHeightForDefaultDPI(Result.Size);
end;

function dxCreateFontForDefaultDPI(ASize: Integer): TFont;
begin
  Result := TFont.Create;
  Result.Height := dxGetFontHeightForDefaultDPI(ASize);
end;

function dxGetFontHeight(AFontSize: Integer; AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(dxGetFontHeightForDefaultDPI(AFontSize));
end;

function dxGetFontHeightForDefaultDPI(AFontSize: Integer; ADesignDPI: Integer = dxDefaultDPI): Integer;
begin
  Result := -MulDiv(AFontSize, ADesignDPI, 72);
end;

procedure dxScaleFont(AFont: TFont; M, D: Integer);
begin
{$IFDEF DELPHIXE8}
  AFont.Height := MulDiv(AFont.Height, M, D);
{$ELSE}
  AFont.Size := MulDiv(AFont.Size, M, D);
{$ENDIF}
end;

function dxAdjustWindowRectEx(var R: TRect; Style, ExStyle: Cardinal; Menu: Boolean; AScaleFactor: TdxScaleFactor): Boolean;
begin
  if Assigned(FAdjustWindowRectExForDpi) then
    Result := FAdjustWindowRectExForDpi(R, Style, Menu, ExStyle, AScaleFactor.TargetDPI)
  else
  begin
    Result := AdjustWindowRectEx(R, Style, Menu, ExStyle);
    if not AScaleFactor.Equals(dxSystemScaleFactor) then
    begin
      Inc(R.Top, GetSystemMetrics(SM_CYCAPTION));
      R := AScaleFactor.Apply(R, dxSystemScaleFactor);
      if AScaleFactor.TargetDPI > dxSystemScaleFactor.TargetDPI then
        R := cxRectInflate(R, -1);
      Dec(R.Top, dxGetSystemMetrics(SM_CYCAPTION, AScaleFactor));
    end;
  end;
end;

function dxGetCurrentDPI(AComponent: TComponent): Integer;
var
  M, D: Integer;
begin
  Result := dxDefaultDPI;
  if dxGetCurrentScaleFactor(AComponent, M, D) then
    Result := MulDiv(Result, M, D);
end;

function dxGetFormDPI(AForm: TCustomForm): Integer;
var
  AFormAccess: TCustomFormAccess absolute AForm;
begin
{$IFDEF DELPHI110}
  if AForm.Scaled and (csLoading in AForm.ComponentState) then
  begin
    if csDesigning in AForm.ComponentState then
      Exit(AFormAccess.GetDPIForDesigner);
    if AFormAccess.PixelsPerInch <> dxDefaultDPI then
      Exit(AFormAccess.PixelsPerInch);
  end;
{$ENDIF}
{$IFDEF DELPHI101BERLIN}
  Result := AFormAccess.FCurrentPPI;
  if Result = 0 then
{$ENDIF}
    Result := AFormAccess.PixelsPerInch;
end;

function dxGetCurrentScaleFactor(AComponent: TComponent; out M, D: Integer): Boolean;
var
  AIntf: IdxScaleFactor;
begin
  Result := True;

  if AComponent is TCustomForm then
  begin
    M := dxGetFormDPI(TCustomForm(AComponent));
    D := dxDefaultDPI;
  end
  {$IFDEF DELPHI110}
  else if (AComponent is TFrame) and (csLoading in AComponent.ComponentState) then
  begin
    D := dxDefaultDPI;
    if csDesigning in AComponent.ComponentState then
      M := TWinControlAccess(AComponent).GetDPIForDesigner
    else
      M := TWinControlAccess(AComponent).PixelsPerInch;
  end
  {$ENDIF}
  else if Supports(AComponent, IdxScaleFactor, AIntf) then
  begin
    M := AIntf.Value.Numerator;
    D := AIntf.Value.Denominator;
  end
  else if AComponent is TControl then
    Result := dxGetCurrentScaleFactor(TControl(AComponent).Parent, M, D)
  else if AComponent is TDataModule then
  begin
    {$IFDEF DELPHI110}
    M := TDataModuleAccess(AComponent).PixelsPerInch;
    if M = 0 then
    {$ENDIF}
    M := dxGetSystemDPI;
    D := dxDefaultDPI;
  end
  else
    Result := False;
end;

function dxGetDesktopDPI: Integer;
const
  SAppliedDPI = 'AppliedDPI';
var
  ARegistry: TRegistry;
begin
  ARegistry := TRegistry.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    if ARegistry.OpenKeyReadOnly('Control Panel\Desktop\WindowMetrics') and ARegistry.ValueExists(SAppliedDPI) then
      Result := ARegistry.ReadInteger(SAppliedDPI)
    else
      Result := dxGetSystemDPI;
  finally
    ARegistry.Free;
  end;
end;

function dxGetSystemDPI: Integer;
begin
  Result := TdxSystemDPIController.DPI;
end;

function dxGetMonitorDPI(const AMonitor: TMonitor): Integer;
{$IFNDEF DELPHI10SEATTLE}
var
  X, Y: Cardinal;
{$ENDIF}
begin
{$IFDEF DELPHI10SEATTLE}
  if AMonitor <> nil then
    Result := AMonitor.PixelsPerInch
{$ELSE}
  if (AMonitor <> nil) and Assigned(FGetDpiForMonitor) and (FGetDpiForMonitor(AMonitor.Handle, 0, X, Y) = S_OK) then
    Result := X
{$ENDIF}
  else
    Result := dxGetSystemDPI;
end;

function dxGetMonitorDPI(const AScreenPoint: TPoint): Integer;
begin
  Result := dxGetMonitorDPI(Screen.MonitorFromPoint(AScreenPoint));
end;

function dxGetMonitorDPI(const AWndHandle: THandle): Integer; overload;
begin
  Result := dxGetMonitorDPI(Screen.MonitorFromWindow(AWndHandle));
end;

function dxGetTargetDPI(AComponent: TComponent): Integer;
var
  AControl: TControl;
begin
  if IsWin8OrLater then
  begin
    while AComponent <> nil do
    begin
      if Safe.Cast(AComponent, TControl, AControl) then
        Exit(dxGetMonitorDPI(AControl.ClientToScreen(cxRectCenter(AControl.ClientRect))));
      AComponent := AComponent.Owner;
    end;
  end;
  Result := dxGetSystemDPI;
end;

function dxGetScaleFactor(AOwner: TObject): TdxScaleFactor;
var
  AScaleFactor: IdxScaleFactor;
begin
  if Supports(AOwner, IdxScaleFactor, AScaleFactor) then
    Result := AScaleFactor.Value
  else
    Result := dxSystemScaleFactor;
end;

function dxGetScaleFactorForCanvas(const ACanvas: TCanvas): TdxScaleFactor;
var
  AScaleFactor: TdxScaleFactor;
begin
  if ACanvas is TControlCanvas then
  begin
    if dxTryGetScaleFactorForControl(TControlCanvas(ACanvas).Control, AScaleFactor) then
      Exit(AScaleFactor);
  end;
  Result := dxDefaultScaleFactor;
end;

function dxGetScaleFactorForInterface(const AOwner: IUnknown): TdxScaleFactor;
var
  AScaleFactor: IdxScaleFactor;
begin
  if Supports(AOwner, IdxScaleFactor, AScaleFactor) then
    Result := AScaleFactor.Value
  else
    Result := dxSystemScaleFactor;
end;

function dxGetSystemMetrics(AIndex: Integer; AScaleFactor: TdxScaleFactor = nil): Integer;
begin
  if AScaleFactor = nil then
    Result := GetSystemMetrics(AIndex)
  else
    if Assigned(FGetSystemMetricsForDpi) then
      Result := FGetSystemMetricsForDpi(AIndex, AScaleFactor.TargetDPI)
    else
      Result := AScaleFactor.Apply(GetSystemMetrics(AIndex), dxDesktopScaleFactor);





  if ((AIndex = SM_CXSIZEFRAME) or (AIndex = SM_CYSIZEFRAME)) then 
    Inc(Result, dxGetSystemMetrics(SM_CXPADDEDBORDER, AScaleFactor));
end;

function dxTryGetScaleFactorForControl(AControl: TControl; out AScaleFactor: TdxScaleFactor): Boolean;
var
  AIntf: IdxScaleFactor;
begin
  while AControl <> nil do
  begin
    if Supports(AControl, IdxScaleFactor, AIntf) then
    begin
      AScaleFactor := AIntf.Value;
      Exit(True);
    end;
    AControl := AControl.Parent;
  end;
  Result := False;
end;

function dxForceUpdateControlDPI(AControl: TWinControl): Boolean;
begin
  Result := False;
  if dxIsProcessDPIPerMonitorV2Aware then
  begin
    AControl.HandleNeeded;
    if AControl.HandleAllocated then
    begin
      SendMessage(AControl.Handle, WM_DPICHANGED_BEFOREPARENT, 0, 0);
      SendMessage(AControl.Handle, WM_DPICHANGED_AFTERPARENT, 0, 0);
      Result := True;
    end;
  end;
end;

procedure dxAddSystemDPIListener(AProcedure: TdxSystemDPINotifyEvent);
begin
  FSystemDPIController.ListenerAdd(AProcedure);
end;

function dxDefaultScaleFactor: TdxScaleFactor;
begin
  if (FDefaultScaleFactor = nil) and not FUnitIsFinalized then
    FDefaultScaleFactor := TdxScaleFactor.Create;
  Result := FDefaultScaleFactor;
end;

function dxDesktopScaleFactor: TdxScaleFactor;
begin
  if (FDesktopScaleFactor = nil) and not FUnitIsFinalized then
    FDesktopScaleFactor := TdxDesktopScaleFactor.Create;
  Result := FDesktopScaleFactor;
end;

function dxSystemScaleFactor: TdxScaleFactor;
begin
  if (FSystemScaleFactor = nil) and not FUnitIsFinalized then
    FSystemScaleFactor := TdxSystemScaleFactor.Create;
  Result := FSystemScaleFactor;
end;

function dxAreDpiAwarenessContextsEqual(const AContext1, AContext2: TDpiAwarenessContext): Boolean;
begin
  if Assigned(FAreDpiAwarenessContextsEqual) then
    Result := FAreDpiAwarenessContextsEqual(AContext1, AContext2)
  else
    Result := AContext1 = AContext2;
end;

function dxGetProcessDpiAwareness: TdxProcessDpiAwareness;
var
  AAwareness: TdxProcessDpiAwareness;
  AContext: TDpiAwarenessContext;
begin
  if Assigned(FGetThreadDpiAwarenessContext) then
  begin
    AContext := FGetThreadDpiAwarenessContext;
    for AAwareness := Low(TdxProcessDpiAwareness) to High(TdxProcessDpiAwareness) do
    begin
      if dxAreDpiAwarenessContextsEqual(AContext, DpiAwarenessContextMap[AAwareness]) then
        Exit(AAwareness);
    end;
  end;
  if not dxGetProcessDpiAwareness(GetCurrentProcess, Result) then
  begin
    if dxIsProcessDPIAware then
      Result := pdaSystemDpiAware
    else
      Result := pdaUnaware;
  end;
end;

function dxGetProcessDpiAwareness(AProcess: THandle): TdxProcessDpiAwareness;
begin
  if not dxGetProcessDpiAwareness(AProcess, Result) then
    Result := pdaUnaware;
end;

function dxGetProcessDpiAwareness(AProcess: THandle; out AValue: TdxProcessDpiAwareness): Boolean;
var
  AProcessDpiAwareness: TProcessDpiAwareness;
begin
  Result := Assigned(FGetProcessDpiAwareness) and Succeeded(FGetProcessDpiAwareness(AProcess, AProcessDpiAwareness));
  if Result then
    AValue := TdxProcessDpiAwareness(AProcessDpiAwareness);
end;

function dxIsGdiScaledMode: Boolean;
begin
  Result := IsWin10v1809OrLater and (dxGetProcessDpiAwareness = pdaUnawareGdiScaled);
end;

function dxIsProcessDPIAware: Boolean;
begin
{$WARNINGS OFF}
  Result := IsWinVistaOrLater and IsProcessDPIAware;
{$WARNINGS ON}
end;

function dxIsProcessDPIPerMonitorV2Aware: Boolean;
begin
  Result := IsWin10OrLater and (dxGetProcessDpiAwareness = pdaPerMonitorDpiAwareV2);
end;

function dxIsWindowsVistaCompatibilityMode: Boolean;
var
  ADosHeader: PImageDosHeader;
  ANtHeader: PImageNtHeaders;
begin
  if FWindowsVistaCompatibilityMode = bDefault then
  begin
    FWindowsVistaCompatibilityMode := bFalse;
    if IsWinVistaOrLater then
    begin
      ADosHeader := PImageDosHeader(HInstance);
      if dxCanReadMemory(ADosHeader, SizeOf(TImageDosHeader)) then
      begin
        ANtHeader := PImageNtHeaders(HInstance + NativeUInt(ADosHeader^._lfanew));
        if dxCanReadMemory(ANtHeader, SizeOf(TImageNtHeaders)) then
        begin
          if ANtHeader.OptionalHeader.MajorSubsystemVersion >= 6 then
            FWindowsVistaCompatibilityMode := bTrue;
        end;
      end;
    end;
  end;
  Result := FWindowsVistaCompatibilityMode = bTrue;
end;

function dxSetProcessDpiAwareness(AValue: TdxProcessDpiAwareness): Boolean;
begin
  if Assigned(FSetThreadDpiAwarenessContext) then
    Result := FSetThreadDpiAwarenessContext(DpiAwarenessContextMap[AValue]) <> DPI_AWARENESS_CONTEXT_INVALID
  else
    if Assigned(FSetProcessDpiAwareness) then
      Result := (AValue <= pdaPerMonitorDpiAware) and Succeeded(FSetProcessDpiAwareness(TProcessDpiAwareness(AValue)))
    else
      Result := IsWinVistaOrLater and (AValue <> pdaUnaware) and SetProcessDPIAware;

  if Result then
  begin
    if FDesktopScaleFactor <> nil then
      FDesktopScaleFactor.Update;
    if FSystemScaleFactor <> nil then
      FSystemScaleFactor.Update;
  end;
end;

{ TdxSystemBasedScaleFactor }

procedure TdxSystemBasedScaleFactor.AfterConstruction;
begin
  inherited;
  Update;
end;

{ TdxDesktopScaleFactor }

procedure TdxDesktopScaleFactor.Update;
begin
  if dxIsProcessDPIAware then
    Assign(dxGetDesktopDPI, dxDefaultDPI)
  else
    Assign(dxGetSystemDPI, dxDefaultDPI);
end;

{ TdxSystemScaleFactor }

procedure TdxSystemScaleFactor.Update;
begin
  Assign(dxGetSystemDPI, dxDefaultDPI);
end;

{ TdxScaleFactorHelper }

function TdxScaleFactorHelper.TargetDPI: Integer;
begin
  Result := Apply(dxDefaultDPI);
end;

{ TdxSystemDPIController }

procedure TdxSystemDPIController.Changed(AOldDPI, ANewDPI: Integer);
var
  I: Integer;
begin
  if FListeners <> nil then
    for I := 0 to FListeners.Count - 1 do
      FListeners[I](Self, AOldDPI, ANewDPI);
end;

constructor TdxSystemDPIController.Create;
var
  DC: Integer;
begin
  inherited Create;
  FHandle := AllocateHWnd(MainWndProc);

  DC := GetDC(0);
  try
    FDPI := GetDeviceCaps(DC, LOGPIXELSY);
  finally
    ReleaseDC(0, DC);
  end;
end;

destructor TdxSystemDPIController.Destroy;
begin
  FreeAndNil(FListeners);
  DeallocateHWnd(FHandle);
  inherited Destroy;
end;

procedure TdxSystemDPIController.ListenerAdd(AEventHandler: TdxSystemDPINotifyEvent);
begin
  if FListeners = nil then
    FListeners := TList<TdxSystemDPINotifyEvent>.Create;
  FListeners.Add(AEventHandler);
end;

procedure TdxSystemDPIController.ListenerRemove(AEventHandler: TdxSystemDPINotifyEvent);
begin
  if (Self <> nil) and (FListeners <> nil) then
  begin
    FListeners.Remove(AEventHandler);
    if FListeners.Count = 0 then
      FreeAndNil(FListeners);
  end;
end;

procedure TdxSystemDPIController.MainWndProc(var Message: TMessage);
begin
  try
    WndProc(Message);
  except
    Application.HandleException(Self);
  end;
end;

procedure TdxSystemDPIController.SetDPI(Value: Integer);
var
  AChanged: Boolean;
  AOldDPI: Integer;
begin
  AChanged := FDPI <> Value;
  if AChanged then
  begin
    AOldDPI := FDPI;
    FDPI := Value;
    Changed(AOldDPI, FDPI);
  end;
end;

procedure TdxSystemDPIController.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_DPICHANGED:
      SetDPI(Message.WParamHi);
  else
    Message.Result := DefWindowProc(Handle, Message.Msg, Message.wParam, Message.lParam);
  end;
end;

procedure InitializeUnit;
var
  AUserLibHandle: THandle;
begin
  FUnitIsFinalized := False;
  FShellCoreLibHandle := LoadLibrary(Shcore);
  if FShellCoreLibHandle > 32 then
  begin
    @FGetDpiForMonitor := GetProcAddress(FShellCoreLibHandle, 'GetDpiForMonitor');
    @FGetProcessDpiAwareness := GetProcAddress(FShellCoreLibHandle, 'GetProcessDpiAwareness');
    @FSetProcessDpiAwareness := GetProcAddress(FShellCoreLibHandle, 'SetProcessDpiAwareness');
  end;

  AUserLibHandle := GetModuleHandle(user32);
  if AUserLibHandle > 32 then
  begin
    @FAreDpiAwarenessContextsEqual := GetProcAddress(AUserLibHandle, 'AreDpiAwarenessContextsEqual');
    @FGetSystemMetricsForDpi := GetProcAddress(AUserLibHandle, 'GetSystemMetricsForDpi');
    @FGetThreadDpiAwarenessContext := GetProcAddress(AUserLibHandle, 'GetThreadDpiAwarenessContext');
    @FSetThreadDpiAwarenessContext := GetProcAddress(AUserLibHandle, 'SetThreadDpiAwarenessContext');
    @FAdjustWindowRectExForDpi := GetProcAddress(AUserLibHandle, 'AdjustWindowRectExForDpi');
  end;
end;

procedure FinalizeUnit;
begin
  FUnitIsFinalized := True;
  @FGetDpiForMonitor := nil;
  @FGetProcessDpiAwareness := nil;
  @FGetSystemMetricsForDpi := nil;
  @FGetThreadDpiAwarenessContext := nil;
  @FSetProcessDpiAwareness := nil;
  @FSetThreadDpiAwarenessContext := nil;
  @FAdjustWindowRectExForDpi := nil;
  TdxCursorManager.Finalize;
  if FShellCoreLibHandle > 32 then
  begin
    FreeLibrary(FShellCoreLibHandle);
    FShellCoreLibHandle := 0;
  end;
end;

{ TdxCursorManager }

class procedure TdxCursorManager.Refresh;
var
  I: Integer;
begin
  if FList <> nil then
  begin
    for I := 0 to FList.Count - 1 do
      DoRegister(TCursorInfo(FList[I]));
  end;
end;

class procedure TdxCursorManager.Register(ACursorIndex: Integer; AResInstance: THandle; const AResName: PChar);
var
  AInfo: TCursorInfo;
begin
  AInfo := TCursorInfo.Create;
  AInfo.Index := ACursorIndex;
  AInfo.ResInstance := AResInstance;

  if dxIsIntResource(AResName) then
    AInfo.ResInt := Integer(AResName)
  else
    AInfo.ResName := AResName;

  if FList = nil then
    FList := TObjectList.Create(True);
  FList.Add(AInfo);

  DoRegister(AInfo);
end;

class procedure TdxCursorManager.Unregister(ACursorIndex: Integer);
var
  AInfo: TCursorInfo;
  I: Integer;
begin
  if FList <> nil then
    for I := FList.Count - 1 downto 0 do
    begin
      AInfo := TCursorInfo(FList[I]);
      if AInfo.Index = ACursorIndex then
      begin
        Screen.Cursors[AInfo.Index] := 0;
        FList.Delete(I);
      end;
    end;
end;

class procedure TdxCursorManager.DoRegister(const AInfo: TCursorInfo);
var
  AResName: PChar;
begin
  if AInfo.ResInt <> 0 then
    AResName := MakeIntResource(AInfo.ResInt)
  else
    AResName := PChar(AInfo.ResName);

  Screen.Cursors[AInfo.Index] := dxLoadCursor(AInfo.ResInstance, AResName);
end;

class procedure TdxCursorManager.Finalize;
begin
  FreeAndNil(FList);
end;


initialization
  FSystemDPIController := TdxSystemDPIController.Create;

  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, InitializeUnit, FinalizeUnit);

finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, FinalizeUnit);
  dxFreeGlobalObject(FDesktopScaleFactor);
  dxFreeGlobalObject(FDefaultScaleFactor);
  dxFreeGlobalObject(FSystemScaleFactor);
  dxFreeGlobalObject(FSystemDPIController);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
