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

unit dxInputDialogs;

{$I cxVer.inc}

interface

uses
  Types, Windows, Classes, Controls, Dialogs, Forms, Variants, cxEditConsts;

type
  TdxInputQueryValidationProc = reference to procedure (ValueIndex: Integer; const Value: string; var IsValid: Boolean);

function dxInputBox(const ACaption, APrompt, ADefaultValue: string): string; overload;
function dxInputQuery(const ACaption, APrompt: string; var AValue: string): Boolean; overload;
function dxInputQuery(const ACaption, APrompt: string; var AValue: string; AValidationProc: TdxInputQueryValidationProc): Boolean; overload;
function dxInputQuery(const ACaption: string; const APrompts: array of string; var AValues: array of string): Boolean; overload;
function dxInputQuery(const ACaption: string; const APrompts: array of string;
  var AValues: array of string; AValidationProc: TdxInputQueryValidationProc): Boolean; overload;
function dxSelectQuery(const ACaption: string; const APrompt: string; AValues: TStrings; var AValue: string;
  AAllowCustomValues: Boolean = False; AValidationProc: TdxInputQueryValidationProc = nil): Boolean;
implementation

uses
  SysUtils, Generics.Collections, Generics.Defaults, dxForms,
  cxTextEdit, cxButtons, cxLabel, cxGeometry, dxCoreClasses, cxClasses, dxCore, cxGraphics, cxDropDownEdit,
  dxLayoutControl, dxLayoutContainer, dxLayoutLookAndFeels,
  Math;

const
  dxThisUnitName = 'dxInputDialogs';

type

  { TdxCustomInputDialog }

  TdxCustomInputDialog = class(TdxForm)
  strict private
    FCancelButton: TcxButton;
    FOkButton: TcxButton;
  protected
    FValidationProc: TdxInputQueryValidationProc;
    FLayout: TdxLayoutControl;
    FLayoutCxLookAndFeel: TdxLayoutCxLookAndFeel;

    function AreAllValuesValid: Boolean; virtual; abstract;
    procedure DoShow; override;
    procedure DoValidate; virtual;
    procedure PlaceButtons();
    //
    procedure HandlerEditChanged(Sender: TObject);
  public
    procedure AfterConstruction; override;
  end;

  { TdxInputDialog }

  TdxInputDialog = class(TdxCustomInputDialog)
  strict private
    FListEditors: TObjectList<TcxTextEdit>;
    FListLabels: TObjectList<TcxLabel>;
  protected
    function AreAllValuesValid: Boolean; override;
  public
    destructor Destroy; override;
    procedure Initialize(AValueCount: Integer);
    procedure InitializeEditor(AIndex: Integer; const ACaption, AValue: string);
    function GetValue(AIndex: Integer): string;
    //
    property ListEditors: TObjectList<TcxTextEdit> read FListEditors;
    property ListLabels: TObjectList<TcxLabel> read FListLabels;
  end;

  { TdxSelectDialog }

  TdxSelectDialog = class(TdxCustomInputDialog)
  strict private
    FEditor: TcxComboBox;
    FPrompt: TcxLabel;
  protected
    function AreAllValuesValid: Boolean; override;
  public
    procedure Initialize(AValues: TStrings; const AValue: string; AAllowCustomValues: Boolean);
    //
    property Editor: TcxComboBox read FEditor;
    property Prompt: TcxLabel read FPrompt;
  end;

function CreateControl(AClass: TControlClass; AParent: TWinControl;
  const AOrigin: TPoint;  AAlign: TAlign = alNone; AAnchors: TAnchors = [akLeft, akTop]): TControl; overload;
begin
  Result := AClass.Create(AParent);
  Result.Parent := AParent;
  Result.SetBounds(AOrigin.X, AOrigin.Y, Result.Width, Result.Height);
  Result.Align := AAlign;
  Result.Anchors := AAnchors;
end;

procedure CreateControl(var Obj; AClass: TControlClass; AParent: TWinControl;
  const AOrigin: TPoint; AAlign: TAlign = alNone; AAnchors: TAnchors = [akLeft, akTop]); overload;
begin
  TControl(Obj) := CreateControl(AClass, AParent, AOrigin, AAlign, AAnchors);
end;

function dxInputBox(const ACaption, APrompt, ADefaultValue: string): string;
begin
  Result := ADefaultValue;
  dxInputQuery(ACaption, APrompt, Result);
end;

function dxInputQuery(const ACaption, APrompt: string; var AValue: string): Boolean;
begin
  Result := dxInputQuery(ACaption, APrompt, AValue, nil);
end;

function dxInputQuery(const ACaption, APrompt: string;
  var AValue: string; AValidationProc: TdxInputQueryValidationProc): Boolean;
var
  AValues: array[0..0] of string;
begin
  AValues[0] := AValue;
  Result := dxInputQuery(ACaption, [APrompt], AValues, AValidationProc);
  if Result then
    AValue := AValues[0];
end;

function dxInputQuery(const ACaption: string; const APrompts: array of string; var AValues: array of string): Boolean;
begin
  Result := dxInputQuery(ACaption, APrompts, AValues, nil);
end;

function dxInputQuery(const ACaption: string; const APrompts: array of string;
  var AValues: array of string; AValidationProc: TdxInputQueryValidationProc): Boolean;
var
  ADialog: TdxInputDialog;
  I: Integer;
begin
  ADialog := TdxInputDialog.CreateNew(nil);
  try
    ADialog.Caption := ACaption;
    ADialog.Initialize(Length(APrompts));
    for I := 0 to Length(APrompts) - 1 do
      ADialog.InitializeEditor(I, APrompts[I], AValues[I]);
    ADialog.FValidationProc := AValidationProc;

    Result := ADialog.ShowModal = mrOk;
    if Result then
    begin
      for I := 0 to Length(APrompts) - 1 do
        AValues[I] := ADialog.GetValue(I);
    end;
  finally
    ADialog.Free;
  end;
end;

function dxSelectQuery(const ACaption: string; const APrompt: string; AValues: TStrings; var AValue: string;
  AAllowCustomValues: Boolean = False; AValidationProc: TdxInputQueryValidationProc = nil): Boolean;
var
  ADialog: TdxSelectDialog;
begin
  ADialog := TdxSelectDialog.CreateNew(nil);
  try
    ADialog.Caption := ACaption;
    ADialog.Initialize(AValues, AValue, AAllowCustomValues);
    ADialog.Prompt.Caption := APrompt;
    ADialog.FValidationProc := AValidationProc;
    Result := ADialog.ShowModal = mrOk;
    if Result then
      AValue := ADialog.Editor.Text;
  finally
    ADialog.Free;
  end;
end;

{ TdxCustomInputDialog }

procedure TdxCustomInputDialog.AfterConstruction;
begin
  inherited;

  Position := poOwnerFormCenter;
  BorderStyle := bsDialog;
  DoubleBuffered := True;

  CreateControl(FOKButton, TcxButton, Self, cxNullPoint);
  FOkButton.Caption := cxGetResourceString(@cxSEditButtonOK);
  FOkButton.ModalResult := mrOk;
  FOkButton.Default := True;

  CreateControl(FCancelButton, TcxButton, Self, cxNullPoint);
  FCancelButton.Caption := cxGetResourceString(@cxSEditButtonCancel);
  FCancelButton.ModalResult := mrCancel;
  FCancelButton.Cancel := True;

  FLayout := TdxLayoutControl.Create(Self);
  FLayout.Parent := Self;
  FLayout.AutoSize := True;
  FLayoutCxLookAndFeel := TdxLayoutCxLookAndFeel.Create(Self);
  FLayout.LayoutLookAndFeel := FLayoutCxLookAndFeel;
  AutoSize := True;
end;

procedure TdxCustomInputDialog.DoShow;
begin
  DoValidate;
  inherited;
end;

procedure TdxCustomInputDialog.DoValidate;
begin
  FOkButton.Enabled := AreAllValuesValid;
end;

procedure TdxCustomInputDialog.PlaceButtons();
var
  AButtonsGroup: TdxCustomLayoutGroup;
begin
  FLayout.BeginUpdate;
  try
    AButtonsGroup := FLayout.CreateGroup(nil, FLayout.Items);
    AButtonsGroup.Hidden := True;
    AButtonsGroup.LayoutDirection := ldHorizontal;
    AButtonsGroup.SizeOptions.Width := ScaleFactor.Apply(315);
    AButtonsGroup.CreateItemForControl(FOkButton).AlignHorz := ahRight;
    AButtonsGroup.CreateItemForControl(FCancelButton).AlignHorz := ahRight;
  finally
    FLayout.EndUpdate;
  end;
end;

procedure TdxCustomInputDialog.HandlerEditChanged(Sender: TObject);
begin
  DoValidate;
end;

{ TdxInputDialog }

destructor TdxInputDialog.Destroy;
begin
  FreeAndNil(FListEditors);
  FreeAndNil(FListLabels);
  inherited Destroy;
end;

procedure TdxInputDialog.Initialize(AValueCount: Integer);
var
  AEdit: TcxTextEdit;
  ALabel: TcxLabel;
  AInputGroup: TdxCustomLayoutGroup;
  I: Integer;
begin
  FListEditors := TObjectList<TcxTextEdit>.Create;
  FListLabels := TObjectList<TcxLabel>.Create;

  FLayout.BeginUpdate;
  try
    AInputGroup := FLayout.CreateGroup(nil, FLayout.Items);
    AInputGroup.Hidden := True;
    for I := 0 to AValueCount - 1 do
    begin
      CreateControl(ALabel, TcxLabel, Self, Point(0, MaxWord), alTop);
      ALabel.AutoSize := True;
      ALabel.AlignWithMargins := True;
      ALabel.Style.TransparentBorder := False;
      ALabel.Properties.ShowEndEllipsis := True;
      ALabel.Properties.WordWrap := True;
      ALabel.Transparent := True;
      ALabel.Margins.Bottom := 0;
      FListLabels.Add(ALabel);
      AInputGroup.CreateItemForControl(ALabel);

      CreateControl(AEdit, TcxTextEdit, Self, Point(0, MaxWord), alTop);
      AEdit.Style.TransparentBorder := False;
      AEdit.AlignWithMargins := True;
      AEdit.Tag := I;
      AEdit.Properties.OnChange := HandlerEditChanged;
      FListEditors.Add(AEdit);
      AInputGroup.CreateItemForControl(AEdit);
    end;
    PlaceButtons();
  finally
    FLayout.EndUpdate;
  end;
  ActiveControl := FListEditors[0];
end;

procedure TdxInputDialog.InitializeEditor(AIndex: Integer; const ACaption, AValue: string);

  function GetEchoMode(const ACaption: string): TcxEditEchoMode;
  begin
    if (Length(ACaption) > 1) and (ACaption[1] < #32) then
      Result := eemPassword
    else
      Result := eemNormal;
  end;

  function GetPromptCaption(const ACaption: string): string;
  begin
    if (Length(ACaption) > 1) and (ACaption[1] < #32) then
      Result := Copy(ACaption, 2, MaxInt)
    else
      Result := ACaption;
  end;

begin
  ListEditors[AIndex].EditValue := AValue;
  ListLabels[AIndex].Caption := GetPromptCaption(ACaption);
  ListEditors[AIndex].Properties.EchoMode := GetEchoMode(ACaption)
end;

function TdxInputDialog.GetValue(AIndex: Integer): string;
begin
  Result := ListEditors[AIndex].EditValue;
end;

function TdxInputDialog.AreAllValuesValid: Boolean;
var
  I: Integer;
begin
  Result := True;
  if Assigned(FValidationProc) then
  begin
    for I := 0 to FListEditors.Count - 1 do
    begin
      FValidationProc(I, ListEditors[I].EditingValue, Result);
      if not Result then
        Break;
    end;
  end;
end;

{ TdxSelectDialog }

procedure TdxSelectDialog.Initialize(AValues: TStrings; const AValue: string; AAllowCustomValues: Boolean);
const
  Map: array[Boolean] of TcxEditDropDownListStyle = (lsFixedList, lsEditList);
var
  AInputGroup: TdxCustomLayoutGroup;
begin
  FLayout.BeginUpdate;
  try
    AInputGroup := FLayout.CreateGroup(nil, FLayout.Items);
    AInputGroup.Hidden := True;

    CreateControl(FPrompt, TcxLabel, Self, Point(0, MaxWord), alTop);
    Prompt.AutoSize := True;
    Prompt.AlignWithMargins := True;
    Prompt.Style.TransparentBorder := False;
    Prompt.Properties.ShowEndEllipsis := True;
    Prompt.Properties.WordWrap := True;
    Prompt.Transparent := True;
    AInputGroup.CreateItemForControl(Prompt);

    CreateControl(FEditor, TcxComboBox, Self, Point(0, MaxWord), alTop);
    Editor.Style.TransparentBorder := False;
    Editor.AlignWithMargins := True;
    Editor.Properties.Items.Assign(AValues);
    Editor.Properties.DropDownListStyle := Map[AAllowCustomValues];
    Editor.ItemIndex := Max(AValues.IndexOf(AValue), IfThen(AAllowCustomValues, -1));
    Editor.Properties.OnChange := HandlerEditChanged;

    AInputGroup.CreateItemForControl(Editor);
    PlaceButtons();
  finally
    FLayout.EndUpdate;
  end;
end;

function TdxSelectDialog.AreAllValuesValid: Boolean;
begin
  if Editor.Properties.DropDownListStyle = lsFixedList then
    Result := Editor.ItemIndex >= 0
  else
  begin
    Result := True;
    if Assigned(FValidationProc) then
      FValidationProc(0, Editor.Text, Result);
  end;
end;

end.
