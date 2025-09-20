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

unit cxShellEditorsReg;

{$I cxVer.inc}

interface

procedure Register;

implementation

uses
  DesignEditors, DesignIntf, Windows, Classes, Controls, Forms, cxDBShellComboBox, cxEditPropEditors,
  cxEditRepositoryEditor, cxExtEditConsts, cxShellBrowserDialog, cxShellComboBox, cxEdit,
  cxShellCommon, cxShellEditRepositoryItems, cxShellListView, cxShellTreeView,
  cxLookAndFeels, dxShellBreadcrumbEdit, dxShellControls, dxCoreReg, dxCore;

const
  dxThisUnitName = 'cxShellEditorsReg';

const
  cxShellBrowserEditorVerb = 'Test Browser...';

type
  TdxShellListViewAccess = class(TdxShellListView);
  TdxShellTreeViewAccess = class(TdxShellTreeView);

  { TcxShellEditorSelectionEditor }

  TcxShellEditorSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;

  { TcxShellBrowserEditor }

  TcxShellBrowserEditor = class(TcxEditorsLibraryComponentEditorEx)
  protected
    function GetEditItemCaption: string; override;
    procedure ExecuteEditAction; override;
  end;

  { TdxShellListViewEditor }

  TdxShellListViewComponentEditor = class(TcxEditorsLibraryCXControlComponentEditor)
  protected
    procedure DoLinkTo(AObject: TObject); override;
    function GetLinkToTypeClass: TClass; override;
    function IsLinkable: Boolean; override;
    function IsObjectLinkable(AObject: TObject): Boolean; override;
  end;

  { TdxShellListViewEditor }

  TdxShellTreeViewComponentEditor = class(TcxEditorsLibraryCXControlComponentEditor)
  protected
    procedure DoLinkTo(AObject: TObject); override;
    function GetLinkToTypeClass: TClass; override;
    function IsLinkable: Boolean; override;
    function IsObjectLinkable(AObject: TObject): Boolean; override;
  end;

  { TdxShellWinControlCustomProperty }

  TdxShellWinControlCustomProperty = class abstract(TComponentProperty)
  private
    FProc: TGetStrProc;
    procedure CheckComponent(const Value: string);
  protected
    function IsValidComponent(C: TComponent): Boolean; virtual; abstract;
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TdxShellTreeViewProperty }

  TdxShellTreeViewProperty = class(TdxShellWinControlCustomProperty)
  protected
    function IsValidComponent(C: TComponent): Boolean; override;
  end;

  { TdxShellListViewProperty }

  TdxShellListViewProperty = class(TdxShellWinControlCustomProperty)
  protected
    function IsValidComponent(C: TComponent): Boolean; override;
  end;

  { TdxShellComboBoxProperty }

  TdxShellComboBoxProperty = class(TdxShellWinControlCustomProperty)
  protected
    function IsValidComponent(C: TComponent): Boolean; override;
  end;


{ TcxShellEditorSelectionEditor }

procedure TcxShellEditorSelectionEditor.RequiresUnits(Proc: TGetStrProc);
begin
  Proc('Vcl.ComCtrls');
  Proc('Winapi.ShlObj');
  Proc('cxShellCommon');
end;

{ TcxShellBrowserEditor }

function TcxShellBrowserEditor.GetEditItemCaption: string;
begin
  Result := cxShellBrowserEditorVerb;
end;

procedure TcxShellBrowserEditor.ExecuteEditAction;
var
  ADialog: TcxShellBrowserDialog;
begin
ADialog := Component as TcxShellBrowserDialog;
with TcxShellBrowserDialog.Create(Application) do
  try
    if Length(ADialog.Title) > 0 then
      Title := ADialog.Title;
    if Length(ADialog.FolderLabelCaption) > 0 then
      FolderLabelCaption := ADialog.FolderLabelCaption;
    Options.ShowFolders := ADialog.Options.ShowFolders;
    Options.ShowToolTip := ADialog.Options.ShowToolTip;
    Options.TrackShellChanges := ADialog.Options.TrackShellChanges;
    Options.ContextMenus := ADialog.Options.ContextMenus;
    Options.ShowNonFolders := ADialog.Options.ShowNonFolders;
    Options.ShowHidden := ADialog.Options.ShowHidden;
    Options.ShowZipFilesWithFolders := ADialog.Options.ShowZipFilesWithFolders;
    Root.BrowseFolder := ADialog.Root.BrowseFolder;
    Root.CustomPath := ADialog.Root.CustomPath;
    LookAndFeel.Kind := ADialog.LookAndFeel.Kind;
    LookAndFeel.NativeStyle := ADialog.LookAndFeel.NativeStyle;
    LookAndFeel.SkinName := ADialog.LookAndFeel.SkinName;
    ShowButtons := ADialog.ShowButtons;
    ShowInfoTips := ADialog.ShowInfoTips;
    ShowLines := ADialog.ShowLines;
    ShowRoot := ADialog.ShowRoot;
    Path := ADialog.Path;
    Execute;
  finally
    Free;
  end;
end;

{ TdxShellListViewComponentEditor }

procedure TdxShellListViewComponentEditor.DoLinkTo(AObject: TObject);
begin
  if AObject is TcxShellListView then
  begin
    TdxShellListViewAccess(Component).AssignFromCxShellListView(TcxShellListView(AObject));
    Designer.Modified;
  end;
end;

function TdxShellListViewComponentEditor.GetLinkToTypeClass: TClass;
begin
  Result := TcxShellListView;
end;

function TdxShellListViewComponentEditor.IsLinkable: Boolean;
begin
  Result := True;
end;

function TdxShellListViewComponentEditor.IsObjectLinkable(AObject: TObject): Boolean;
begin
  Result := AObject is TcxShellListView;
end;

{ TdxShellTreeViewComponentEditor }

procedure TdxShellTreeViewComponentEditor.DoLinkTo(AObject: TObject);
begin
  if AObject is TcxShellTreeView then
  begin
    TdxShellTreeViewAccess(Component).AssignFromCxShellTreeView(TcxShellTreeView(AObject));
    Designer.Modified;
  end;
end;

function TdxShellTreeViewComponentEditor.GetLinkToTypeClass: TClass;
begin
  Result := TcxShellTreeView;
end;

function TdxShellTreeViewComponentEditor.IsLinkable: Boolean;
begin
  Result := True;
end;

function TdxShellTreeViewComponentEditor.IsObjectLinkable(AObject: TObject): Boolean;
begin
  Result := AObject is TcxShellTreeView;
end;

{ TdxShellWinControlCustomProperty }

procedure TdxShellWinControlCustomProperty.CheckComponent(const Value: string);
var
  AComponent: TComponent;
begin
  AComponent := Designer.GetComponent(Value);
  if IsValidComponent(AComponent) then
    FProc(Value);
end;

procedure TdxShellWinControlCustomProperty.GetValues(Proc: TGetStrProc);
begin
  FProc := Proc;
  inherited GetValues(CheckComponent);
end;

{ TdxShellTreeViewProperty }

function TdxShellTreeViewProperty.IsValidComponent(C: TComponent): Boolean;
begin
  Result := (C is TcxCustomShellTreeView) or (C is TdxCustomShellTreeView);
end;

{ TdxShellListViewProperty }

function TdxShellListViewProperty.IsValidComponent(C: TComponent): Boolean;
begin
  Result := (C is TcxCustomShellListView) or (C is TdxCustomShellListView);
end;

{ TdxShellComboBoxProperty }

function TdxShellComboBoxProperty.IsValidComponent(C: TComponent): Boolean;
begin
  Result := C is TcxCustomShellComboBox;
end;

procedure Register;
begin
  RegisterComponents(cxEditorsLibraryProductPage, [TcxShellComboBox]);
  RegisterComponents(cxEditorsDBLibraryProductPage, [TcxDBShellComboBox]);
  RegisterComponents('Express Utilities', [TdxShellListView, TdxShellTreeView, TcxShellListView, TcxShellTreeView,
    TcxShellBrowserDialog, TdxShellBreadcrumbEdit]);
  RegisterSelectionEditor(TdxCustomShellBreadcrumbEdit, TcxShellEditorSelectionEditor);
  RegisterSelectionEditor(TcxCustomShellComboBox, TcxShellEditorSelectionEditor);
  RegisterSelectionEditor(TcxCustomShellListView, TcxShellEditorSelectionEditor);
  RegisterSelectionEditor(TcxCustomShellTreeView, TcxShellEditorSelectionEditor);
  RegisterSelectionEditor(TdxShellListView, TcxShellEditorSelectionEditor);
  RegisterSelectionEditor(TdxShellTreeView, TcxShellEditorSelectionEditor);
  RegisterComponentEditor(TcxShellBrowserDialog, TcxShellBrowserEditor);
  RegisterPropertyEditor(TypeInfo(Boolean), TcxDragDropSettings, 'Scroll', nil);
  RegisterPropertyEditor(TypeInfo(Boolean), TcxCustomShellTreeView, 'RightClickSelect', nil);
  RegisterComponentEditor(TdxShellListView, TdxShellListViewComponentEditor);
  RegisterComponentEditor(TdxShellTreeView, TdxShellTreeViewComponentEditor);
  RegisterPropertyEditor(TypeInfo(TWinControl), TdxCustomShellBreadcrumbEdit, 'ShellTreeView', TdxShellTreeViewProperty);
  RegisterPropertyEditor(TypeInfo(TWinControl), TdxCustomShellBreadcrumbEdit, 'ShellListView', TdxShellListViewProperty);
  RegisterPropertyEditor(TypeInfo(TWinControl), TdxCustomShellBreadcrumbEdit, 'ShellComboBox', TdxShellComboBoxProperty);
end;








initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterEditRepositoryItem(TcxEditRepositoryShellComboBoxItem, scxSEditRepositoryShellComboBoxItem);
  RegisterEditPropertiesIcon(TcxShellComboBoxProperties, 'TcxShellComboBox', Hinstance);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  UnregisterEditRepositoryItem(TcxEditRepositoryShellComboBoxItem);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
