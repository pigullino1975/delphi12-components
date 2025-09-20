{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressLayoutControl control adapters                    }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSLAYOUTCONTROL AND ALL          }
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

unit dxLayoutControlAdapters;

{$I cxVer.inc}

interface

uses
  Classes, dxLayoutContainer, Forms;

type
  TdxLayoutComboAdapter = class(TdxCustomLayoutControlAdapter)
  protected
    function AllowCheckSize: Boolean; override;
  end;

  TdxLayoutPanelAdapter = class(TdxCustomLayoutControlAdapter)
  protected
    function NeedBorder: Boolean; override;
    function UseItemColor: Boolean; override;
  end;

  TdxButtonControlAdapter = class(TdxCustomLayoutControlAdapter)
  private
    FChanged: Boolean;
    FStyles: Integer;
    function GetHandle: THandle;
  protected
    procedure BeginCustomization; override;
    procedure EndCustomization; override;

    property Handle: THandle read GetHandle;
  end;

procedure dxPrepareActiveControlForScrolling(AForm: TCustomForm);

implementation

uses
  SysUtils, dxCore, Windows, Messages, Controls, StdCtrls, ExtCtrls, cxControls, cxDropDownEdit;

const
  dxThisUnitName = 'dxLayoutControlAdapters';

type
  TCustomComboAccess = class(TCustomCombo);

procedure dxPrepareActiveControlForScrolling(AForm: TCustomForm);
var
  AComboBox: TCustomCombo;
  AControl: TWinControl;
  AIntf: IdxScrollParentWindowNotify;
begin
  if AForm = nil then Exit;
  AControl := AForm.ActiveControl;
  if (AControl <> nil) and AControl.HandleAllocated then
  begin
    if Supports(AControl, IdxScrollParentWindowNotify, AIntf) then
    begin
      AIntf.Notify;
      Exit;
    end;
    AComboBox := Safe<TCustomCombo>.Cast(AForm.ActiveControl);
    if AComboBox <> nil then
    begin
      AComboBox.DroppedDown := False;
      Exit;
    end;
    if AControl.CanFocus then
    begin
      AControl.SetFocus;
      SetFocus(AControl.Handle);
    end;
  end;
end;

{ TdxLayoutComboAdapter }

function TdxLayoutComboAdapter.AllowCheckSize: Boolean;
begin
  Result := not TCustomComboAccess(Control).FDroppingDown;
end;

{ TdxLayoutPanelAdapter }

function TdxLayoutPanelAdapter.NeedBorder: Boolean;
begin
  Result := False;
end;

function TdxLayoutPanelAdapter.UseItemColor: Boolean;
begin
  Result := True;
end;

{ TdxButtonControlAdapter }

procedure TdxButtonControlAdapter.BeginCustomization; 
const
  BS_TYPEMASK       = $0F;
  BS_DEFSPLITBUTTON = $0000000D;
  BS_DEFCOMMANDLINK = $0000000F;
begin
  inherited;
  FChanged := IsWinVistaOrLater;
  if FChanged then
  begin
    FStyles := GetWindowLong(Handle, GWL_STYLE) and BS_TYPEMASK;
    FChanged := (FStyles = BS_DEFPUSHBUTTON) or (FStyles = BS_DEFCOMMANDLINK) or
      (FStyles = BS_DEFSPLITBUTTON);
    if FChanged then
      //remove default attribute
      SendMessage(Handle, BM_SETSTYLE, FStyles - 1, 1);
  end;
end;

procedure TdxButtonControlAdapter.EndCustomization;
var
  AForm: TCustomForm;
begin
  inherited EndCustomization;
  if FChanged then
  begin
    SendMessage(Handle, BM_SETSTYLE, FStyles, 1);
    AForm := GetParentForm(Control);
    if AForm <> nil then
      AForm.Perform(CM_FOCUSCHANGED, 0, LPARAM(AForm.ActiveControl));
  end;
end;

function TdxButtonControlAdapter.GetHandle: THandle;
begin
  Result := TButtonControl(Control).Handle;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClasses([TdxLayoutComboAdapter]);
  TdxLayoutComboAdapter.Register(TCustomCombo);
  TdxLayoutPanelAdapter.Register(TCustomPanel);
  TdxButtonControlAdapter.Register(TButtonControl);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxButtonControlAdapter.Unregister(TButtonControl);
  TdxLayoutPanelAdapter.Unregister(TCustomPanel);
  TdxLayoutComboAdapter.Unregister(TCustomCombo);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
