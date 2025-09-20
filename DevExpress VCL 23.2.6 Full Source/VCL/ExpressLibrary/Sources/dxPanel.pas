{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCommonLibrary                                     }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCOMMONLIBRARY AND ALL          }
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

unit dxPanel;

{$I cxVer.inc}

interface

uses
  Classes, Graphics, Controls, dxFramedControl, cxLookAndFeels;

type
  TdxCustomPanel = class(TdxFramedControl, IdxSkinSupport)
  protected
    procedure CreateParams(var AParams: TCreateParams); override;
    function GetDefaultColor: TColor; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Color default clDefault;
    property ParentBackground default False;
    property ParentColor default False;
    property TabStop default False;
    property UseDockManager default True;
  end;

  TdxPanel = class(TdxCustomPanel)
  published
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Frame;
    property Color;
    property Constraints;
    property UseDockManager;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property LookAndFeel;
    property ParentBackground;
    property ParentBiDiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnDragBorder;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

uses
  Windows;

const
  dxThisUnitName = 'dxPanel';

{ TdxCustomPanel }

constructor TdxCustomPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents, csDoubleClicks, csGestures, csOverrideStylePaint];
  Color := clDefault;
  TabStop := False;
  UseDockManager := True;
  ParentBackground := False;
end;

procedure TdxCustomPanel.CreateParams(var AParams: TCreateParams);
begin
  inherited CreateParams(AParams);
  AParams.WindowClass.style := AParams.WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  if UseRightToLeftAlignment then
    AParams.ExStyle := AParams.ExStyle or WS_EX_LAYOUTRTL or WS_EX_NOINHERITLAYOUT;
end;

function TdxCustomPanel.GetDefaultColor: TColor;
begin
  Result := LookAndFeelPainter.DefaultControlColor;
end;

end.
