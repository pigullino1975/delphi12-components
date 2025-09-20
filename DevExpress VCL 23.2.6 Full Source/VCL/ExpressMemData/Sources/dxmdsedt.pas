{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressMemData                                           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSMEMDATA AND ALL                }
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

unit dxmdsedt;

interface

{$I cxVer.inc}

uses
  DesignIntf, Windows, Classes, Controls, Forms, StdCtrls, dxmdaset, ExtCtrls, Menus, Graphics, dxCore, dxForms;

type
  TfrmdxMemDataEditor = class(TdxForm)
    ListBox: TListBox;
    pnButtons: TPanel;
    BAdd: TButton;
    BDelete: TButton;
    BUp: TButton;
    BDown: TButton;
    pmColumns: TPopupMenu;
    miShowButtons: TMenuItem;
    procedure ListBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BAddClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure miUpClick(Sender: TObject);
    procedure miDownClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miShowButtonsClick(Sender: TObject);
    procedure ListBoxDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ListBoxStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ListBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    FData: TdxMemData;
    FFormDesigner: IDesigner;
    procedure MoveField(ADirection: Integer);
    procedure GetSelection(AList: TList);
    procedure SetSelection(AList: TList);
    procedure FillList;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AData: TdxMemData; AFormDesigner: IDesigner); reintroduce;
  end;

function ShowMemDataFieldEditor(AData: TdxMemData; AFormDesigner: IDesigner): Boolean;

implementation

{$R *.dfm}

uses
  SysUtils, Contnrs, DB, dxmdseda;

const
  dxThisUnitName = 'dxmdsedt';

var
  FormList: TList;

const
  OldDragIndex: Integer = -1;

type
  TMemDataSetDesigner = class(TDataSetDesigner)
  private
    FForm: TfrmdxMemDataEditor;
    FDestroying: Boolean;
  public
    constructor Create(ADataSet: TDataSet; AForm: TfrmdxMemDataEditor); reintroduce;
    destructor Destroy; override;
    procedure DataEvent(Event: TDataEvent; Info: TdxNativeInt); override;
  end;

function ShowMemDataFieldEditor(AData: TdxMemData; AFormDesigner: IDesigner): Boolean;
var
  AForm: TfrmdxMemDataEditor;
  I: Integer;
begin
  AForm := nil;
  for I := 0 to FormList.Count - 1 do
    if TfrmdxMemDataEditor(FormList[I]).FData = AData then
    begin
      AForm := TfrmdxMemDataEditor(FormList[I]);
      Break;
    end;

  if AForm = nil then
  begin
    AForm := TfrmdxMemDataEditor.Create(AData, AFormDesigner);
    TMemDataSetDesigner.Create(AData, AForm);
    FormList.Add(AForm);
  end;

  AForm.FillList;
  AForm.Caption := 'Editing ' + AForm.FData.Name + '.Fields';
  AForm.Show;
  Result := True;
end;

{ TMemDataSetDesigner }

destructor TMemDataSetDesigner.Destroy;
begin
  FDestroying := True;
  if FForm <> nil then
    FForm.Close;
  inherited Destroy;
end;

constructor TMemDataSetDesigner.Create(ADataSet: TDataSet;
  AForm: TfrmdxMemDataEditor);
begin
  inherited Create(ADataSet);
  FForm := AForm;
end;

procedure TMemDataSetDesigner.DataEvent(Event: TDataEvent;
  Info: TdxNativeInt);
var
  I, J: Integer;
begin
  if FForm <> nil then
  begin
    for I := 0 to FForm.FData.FieldCount - 1 do
      if FForm.FData.Fields[I].Owner = FForm.FData.Owner then
      begin
        J := FForm.ListBox.Items.IndexOfObject(FForm.FData.Fields[I]);
        if J > -1 then
          FForm.ListBox.Items[J] := FForm.FData.Fields[I].FieldName;
      end;
  end;
end;

{ TfrmdxMemDataEditor }

procedure TfrmdxMemDataEditor.FillList;
Var
  I: Integer;
begin
  ListBox.Items.BeginUpdate;
  try
    ListBox.Items.Clear;
    for I := 0 to FData.FieldCount - 1 do
      if FData.Fields[I].Owner = FData.Owner then
        ListBox.Items.AddObject(FData.Fields[I].FieldName, FData.Fields[I]);
  finally
    ListBox.Items.EndUpdate;
  end;
  ListBoxClick(nil);
end;

procedure TfrmdxMemDataEditor.ListBoxClick(Sender: TObject);
var
  AList: IDesignerSelections;
  I: Integer;
begin
  if (csDesigning in FData.ComponentState) then
  begin
    AList := CreateSelectionList;
    try
      for I := 0 to Listbox.Items.Count - 1 do
        if Listbox.Selected[I] then
          AList.Add(TComponent(Listbox.Items.Objects[I]));
        if AList.Count > 0 then
          FFormDesigner.SetSelections(AList)
        else
          FFormDesigner.SelectComponent(FData);
    finally
      AList := nil;
    end;
  end;
  BDelete.Enabled := Listbox.SelCount > 0;
  BUp.Enabled := Listbox.SelCount > 0;
  BDown.Enabled := Listbox.SelCount > 0;
end;

procedure TfrmdxMemDataEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (FData <> nil) and not (csDestroying in FData.ComponentState) and
    (FData.Designer <> nil) and not TMemDataSetDesigner(FData.Designer).FDestroying then
  begin
    TMemDataSetDesigner(FData.Designer).FForm := nil;
    FData.Designer.Free;
  end;
  FormList.Remove(self);
  Action := caFree;
end;

procedure TfrmdxMemDataEditor.BAddClick(Sender: TObject);
var
  AField: TField;
  P: TPoint;
begin
  P := Point(BAdd.Left + BAdd.Width, BAdd.Top);
  P := ClientToScreen(P);
  FData.Close;
  AField := GetMemDataNewFieldType(FData, P.X, P.Y, FFormDesigner);
  if AField <> nil then
  begin
    FillList;
    ListBox.Selected[ListBox.Items.Count-1] := True;
    ListBox.ItemIndex := ListBox.Items.Count-1;
    ListBox.SetFocus;
    ListBoxClick(nil);
  end;
end;

procedure TfrmdxMemDataEditor.BDeleteClick(Sender: TObject);
var
  I, OldIndex: Integer;
  List: TList;
begin
  if FData <> nil then
  begin
    OldIndex := ListBox.ItemIndex;
    List := TList.Create;
    for I := 0 to ListBox.Items.Count - 1 do
     if ListBox.Selected[I] then
        List.Add(ListBox.Items.Objects[I]);
    for I := 0 to List.Count - 1 do
       TField(List[I]).Free;
    List.Free;
    FillList;
    if OldIndex >= ListBox.Items.Count then
      OldIndex := ListBox.Items.Count - 1;
    if (OldIndex <> -1) and (ListBox.Items.Count > 0) then
      ListBox.Selected[OldIndex] := True;
    ListBox.SetFocus;
    ListBoxClick(nil);
  end;
end;

procedure TfrmdxMemDataEditor.miUpClick(Sender: TObject);
begin
  MoveField(-1);
end;

procedure TfrmdxMemDataEditor.miDownClick(Sender: TObject);
begin
  MoveField(1);
end;

procedure TfrmdxMemDataEditor.miSelectAllClick(Sender: TObject);
var
  I: Integer;
begin
  with ListBox do
    for I := 0 to Items.Count - 1 do
      Selected[I] := True;
  ListBox.SetFocus;
  ListBoxClick(nil);
end;

procedure TfrmdxMemDataEditor.miShowButtonsClick(Sender: TObject);
begin
  miShowButtons.Checked := not miShowButtons.Checked;
  pnButtons.Visible := miShowButtons.Checked;
end;

procedure TfrmdxMemDataEditor.ListBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  Index: Integer;
begin
  Accept := Source = ListBox;
  if not Accept then
    Exit;
  Index := ListBox.ItemAtPos(Point(X, Y), True);
  if OldDragIndex <> Index then
  begin
    if OldDragIndex <> -1 then
      ListBox.Selected[OldDragIndex] := False;
    if Index <> -1 then
      if not ListBox.Selected[Index] then
      begin
        ListBox.Selected[Index] := True;
        OldDragIndex := Index;
      end
      else
        OldDragIndex := -1;
  end;
  if (Index <> -1) then
    ListBox.ItemIndex := Index;
end;

procedure TfrmdxMemDataEditor.ListBoxStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  OldDragIndex := -1;
end;

procedure TfrmdxMemDataEditor.ListBoxEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  if OldDragIndex <> -1 then
  begin
    ListBox.Selected[OldDragIndex] := False;
    OldDragIndex := -1;
  end;
end;

procedure TfrmdxMemDataEditor.ListBoxDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  I, Index: Integer;
  List: TList;
begin
  if OldDragIndex <> -1 then
  begin
    ListBox.Selected[OldDragIndex] := False;
    OldDragIndex := -1;
  end;
  Index := ListBox.ItemAtPos(Point(X, Y), True);
  if (Index <> -1) and (FData <> nil) then
  begin
    List := TList.Create;
    try
      GetSelection(List);
      if TField(List[0]).Index > Index then
        for I := List.Count - 1 downto 0 do
          TField(List[I]).Index := Index + 1
      else
        for I := 0 to List.Count - 1 do
          TField(List[I]).Index := Index + 1;
      if FFormDesigner <> nil then
        FFormDesigner.Modified;
      FillList;
      SetSelection(List);
      ListBoxClick(nil);
    finally
      List.Free;
    end;
  end;
end;

procedure TfrmdxMemDataEditor.MoveField(ADirection: Integer);

  procedure MoveListItem(AList: TList; AIndex: Integer);
  begin
    TField(AList[AIndex]).Index := TField(AList[AIndex]).Index + ADirection
  end;

var
  I: Integer;
  AList: TList;
begin
  if FData <> nil then
  begin
    AList := TList.Create;
    try
      GetSelection(AList);
      if ADirection < 0 then
        for I := 0 to AList.Count - 1 do
          MoveListItem(AList, I)
      else
        for I := AList.Count - 1 downto 0 do
          MoveListItem(AList, I);
      if FFormDesigner <> nil then
        FFormDesigner.Modified;
      FillList;
      SetSelection(AList);
    finally
      AList.Free;
    end;
    ListBoxClick(nil);
  end;
end;

procedure TfrmdxMemDataEditor.GetSelection(AList: TList);
var
  I: Integer;
begin
  for I := 0 to ListBox.Items.Count - 1 do
    if ListBox.Selected[I] then
      AList.Add(ListBox.Items.Objects[I]);
end;

procedure TfrmdxMemDataEditor.SetSelection(AList: TList);
var
  I: Integer;
begin
  for I := 0 to ListBox.Items.Count - 1 do
    ListBox.Selected[I] := AList.IndexOf(ListBox.Items.Objects[I]) <> -1;
end;

constructor TfrmdxMemDataEditor.Create(AData: TdxMemData;
  AFormDesigner: IDesigner);
begin
  inherited Create(nil);
  FData := AData;
  FFormDesigner := AFormDesigner;
end;

procedure TfrmdxMemDataEditor.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := Application.MainForm.Handle;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FormList := TList.Create;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(FormList);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
