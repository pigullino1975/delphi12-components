{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressLayoutControl cxEditors adapters                  }
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

unit dxLayoutcxEditAdapters;

{$I cxVer.inc}

interface

uses
  Classes, Windows, cxControls, cxContainer, dxLayoutContainer, cxEdit, cxLookAndFeelPainters, cxGraphics, dxColorGallery;

type
  TdxLayoutcxEditContainerAdapter = class(TdxCustomLayoutControlAdapter)
  private
    function GetControl: TcxCustomEditContainer;
    function GetControlStyle: TcxContainerStyle;
  protected
    function AllowCheckAutoSize: Boolean; override;
    procedure CombineRegion(const ARect: TRect); override;
    procedure Init; override;
    procedure InternalSetInitialSettings; override;
    function IsDefaultSkinAssigned: Boolean;

    property Control: TcxCustomEditContainer read GetControl;
    property ControlStyle: TcxContainerStyle read GetControlStyle;
  public
    procedure AfterInitialization; override;
    procedure BeforeInitialization; override;
  end;

  TdxLayoutcxEditAdapter = class(TdxLayoutcxEditContainerAdapter)
  private
    function GetEditStyle: TcxCustomEditStyle;
  protected
    procedure InternalSetInitialSettings; override;
    function GetControlAutoWidth: Boolean; override;
    function GetControlAutoHeight: Boolean; override;
    procedure SetControlAutoWidth(AValue: Boolean); override;
    procedure SetControlAutoHeight(AValue: Boolean); override;

    property EditStyle: TcxCustomEditStyle read GetEditStyle;
  end;

  TdxLayoutdxColorGalleryAdapter = class(TdxCustomLayoutControlAdapter)
  private
    function GetControl: TdxColorGallery;
  protected
    function AllowCheckAutoSize: Boolean; override;
    function GetControlAutoWidth: Boolean; override;
    function GetControlAutoHeight: Boolean; override;

    property Control: TdxColorGallery read GetControl;
  end;

implementation

uses
  dxLayoutLookAndFeels, cxLookAndFeels, TypInfo, dxCore;

const
  dxThisUnitName = 'dxLayoutcxEditAdapters';

type
  TcxCustomEditContainerAccess = class(TcxCustomEditContainer);
  TcxCustomEditAccess = class(TcxCustomEdit);
  TcxCustomEditStyleAccess = class(TcxCustomEditStyle);
  TcxContainerStyleAccess = class(TcxContainerStyle);
  TdxCustomLayoutLookAndFeelAccess = class(TdxCustomLayoutLookAndFeel);
  TdxCustomLayoutItemAccess = class(TdxCustomLayoutItem);

{ TcxCustomEditContainer }

procedure TdxLayoutcxEditContainerAdapter.AfterInitialization;
begin
  TcxCustomEditContainerAccess(Control).EndRefreshContainer;
  inherited;
end;

procedure TdxLayoutcxEditContainerAdapter.BeforeInitialization;
begin
  inherited;
  TcxCustomEditContainerAccess(Control).BeginRefreshContainer;
end;

function TdxLayoutcxEditContainerAdapter.GetControl: TcxCustomEditContainer;
begin
  Result := inherited Control as TcxCustomEditContainer;
end;

function TdxLayoutcxEditContainerAdapter.GetControlStyle: TcxContainerStyle;
begin
  Result := TcxCustomEditContainerAccess(Control).Style;
end;

function TdxLayoutcxEditContainerAdapter.IsDefaultSkinAssigned: Boolean;
begin
  with ControlStyle.LookAndFeel do
    Result := (MasterLookAndFeel <> nil) and (MasterLookAndFeel.SkinName <> '');
end;

function TdxLayoutcxEditContainerAdapter.AllowCheckAutoSize: Boolean;
begin
  Result := (Control <> nil) and IsPublishedProp(Control, 'AutoSize');
end;

procedure TdxLayoutcxEditContainerAdapter.CombineRegion(const ARect: TRect);
var
  ARegion: TcxRegion;
  ARgn: TcxRegionHandle;
begin
  ARegion := TcxRegion.Create(ARect);
  try
    ARgn := TcxCustomEditContainerAccess(Control).FNewWindowRegion;
    if ARgn <> 0 then
      ARegion.Combine(TcxRegion.Create(ARgn), roIntersect);
    TcxCustomEditContainerAccess(Control).FNewWindowRegion := ARegion.Handle;
  finally
    ARegion.Handle := 0;
    ARegion.Free;
  end;
end;

procedure TdxLayoutcxEditContainerAdapter.Init;
begin
  inherited;
  ControlStyle.HotTrack := False;
  if TdxCustomLayoutItemAccess(Item).IsDesigning then
    ControlStyle.TransparentBorder := False;
end;

procedure TdxLayoutcxEditContainerAdapter.InternalSetInitialSettings;
const
  BorderStyles: array[TdxLayoutBorderStyle] of TcxContainerBorderStyle = (cbsNone, cbsSingle, cbsFlat, cbs3D);
begin
  inherited;
  if TdxCustomLayoutLookAndFeelAccess(LayoutLookAndFeel).DoesCxLookAndFeelHavePriority then
    ControlStyle.AssignedValues := ControlStyle.AssignedValues - [svBorderColor, svBorderStyle, svButtonStyle, svPopupBorderStyle]
  else
  begin
    if TcxCustomEditStyleAccess(ControlStyle).DefaultBorderStyle <> cbsNone then
    begin
      ControlStyle.BorderColor := LayoutLookAndFeel.ItemOptions.GetControlBorderColor;
      ControlStyle.BorderStyle := BorderStyles[LayoutLookAndFeel.ItemOptions.ControlBorderStyle];
    end;
  end;
end;

{ TdxLayoutcxEditAdapter }

procedure TdxLayoutcxEditAdapter.InternalSetInitialSettings;
const
  ButtonStyles: array[TdxLayoutBorderStyle] of TcxEditButtonStyle =
    (btsHotFlat, btsHotFlat, btsFlat, bts3D);
  PopupBorderStyles: array[TdxLayoutBorderStyle] of TcxEditPopupBorderStyle =
    (epbsSingle, epbsSingle, epbsFlat, epbsFrame3D);
var
  AItemBorderStyle: TdxLayoutBorderStyle;
begin
  inherited;
  if not TdxCustomLayoutLookAndFeelAccess(LayoutLookAndFeel).DoesCxLookAndFeelHavePriority then
  begin
    AItemBorderStyle := LayoutLookAndFeel.ItemOptions.ControlBorderStyle;
    EditStyle.ButtonStyle := ButtonStyles[AItemBorderStyle];
    EditStyle.PopupBorderStyle := PopupBorderStyles[AItemBorderStyle];
  end;
end;

function TdxLayoutcxEditAdapter.GetControlAutoWidth: Boolean;
begin
  Result := TcxCustomEditAccess(Control).IsAutoWidth;
end;

function TdxLayoutcxEditAdapter.GetControlAutoHeight: Boolean;
begin
  Result := TcxCustomEditAccess(Control).IsAutoHeight;
end;

procedure TdxLayoutcxEditAdapter.SetControlAutoWidth(AValue: Boolean);
begin
  TcxCustomEditAccess(Control).AutoWidth := AValue;
end;

procedure TdxLayoutcxEditAdapter.SetControlAutoHeight(AValue: Boolean);
begin
  TcxCustomEditAccess(Control).AutoHeight := AValue;
end;

function TdxLayoutcxEditAdapter.GetEditStyle: TcxCustomEditStyle;
begin
  Result := ControlStyle as TcxCustomEditStyle;
end;

{ TdxLayoutdxColorGalleryAdapter }

function TdxLayoutdxColorGalleryAdapter.AllowCheckAutoSize: Boolean;
begin
  Result := (Control <> nil) and IsPublishedProp(Control, 'AutoSizeMode');
end;

function TdxLayoutdxColorGalleryAdapter.GetControlAutoWidth: Boolean;
begin
  Result := Control.AutoSizeMode in [asAutoWidth, asAutoSize];
end;

function TdxLayoutdxColorGalleryAdapter.GetControlAutoHeight: Boolean;
begin
  Result := Control.AutoSizeMode in [asAutoHeight, asAutoSize];
end;

function TdxLayoutdxColorGalleryAdapter.GetControl: TdxColorGallery;
begin
  Result := inherited Control as TdxColorGallery;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClasses([TdxLayoutcxEditAdapter, TdxLayoutcxEditContainerAdapter, TdxLayoutdxColorGalleryAdapter]);
  TdxLayoutcxEditContainerAdapter.Register(TcxCustomEditContainer);
  TdxLayoutcxEditAdapter.Register(TcxCustomEdit);
  TdxLayoutdxColorGalleryAdapter.Register(TdxColorGallery);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxLayoutdxColorGalleryAdapter.Unregister(TdxColorGallery);
  TdxLayoutcxEditAdapter.Unregister(TcxCustomEdit);
  TdxLayoutcxEditContainerAdapter.Unregister(TcxCustomEditContainer);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
