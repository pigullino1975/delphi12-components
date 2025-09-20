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

unit dxFormattedHintEditor; // for internal use

{$I cxVer.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, StdCtrls, ComCtrls, ToolWin, StrUtils,
  dxFormattedLabelCaptionEditor, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxLayoutContainer, dxLayoutcxEditAdapters, dxLayoutControlAdapters, dxFormattedLabel, dxColorDialog, cxImageList,
  cxClasses, cxButtons, cxTextEdit, cxMemo, cxRichEdit, dxLayoutControl, cxHint;

type
  TfrmFormattedHintEditor = class(TfrmFormattedLabelCaptionEditor)
    dxliTextPreview: TdxLayoutItem;
    flHintPreview: TdxFormattedLabel;
    lgPreview: TdxLayoutGroup;
    dxLayoutSplitterItem1: TdxLayoutSplitterItem;
    liAddHintStyleController: TdxLayoutItem;
    flAddHintStyleController: TdxFormattedLabel;
    procedure flAddHintStyleControllerPropertiesHyperlinkClick(Sender: TObject; const AURI: string;
      var AHandled: Boolean);
    procedure lgTabGroupTabChanged(Sender: TObject);
    procedure reEditorTextChange(Sender: TObject);
  private
    FComponent: TComponent;
    FHintStyleController: TcxHintStyleController;
  protected
    procedure InitForm(AText: string; AObject: TObject);
  end;

function dxShowFormattedHintEditor(var AText: string; AComponent: TComponent): Boolean;

implementation

uses dxCustomHint;

const
  dxThisUnitName = 'dxFormattedHintEditor';

{$R *.dfm}

type
  TdxCustomLayoutItemCaptionOptionsAccessor = class(TdxCustomLayoutItemCaptionOptions);

function dxShowFormattedHintEditor(var AText: string; AComponent: TComponent): Boolean;
var
  AForm: TfrmFormattedHintEditor;
begin
  AForm := TfrmFormattedHintEditor.Create(nil);
  try
    AForm.InitForm(AText, AComponent);
    Result := AForm.ShowModal = mrOk;
    if Result then
      AText := AForm.Text;
  finally
    AForm.Release;
  end;
end;

procedure TfrmFormattedHintEditor.flAddHintStyleControllerPropertiesHyperlinkClick(Sender: TObject; const AURI: string;
  var AHandled: Boolean);
var
  AController: TcxHintStyleController;
  AParentComponent: TComponent;
begin
  AParentComponent := FComponent.Owner;
  if (AParentComponent = nil) and ((FComponent is TCustomForm) or (FComponent is TCustomFrame)) then
    AParentComponent := FComponent;

  AController := TcxHintStyleController.Create(AParentComponent);
  AController.Name := CreateUniqueName(AParentComponent, nil, AController, '', '');
  liAddHintStyleController.Visible := False;
end;

procedure TfrmFormattedHintEditor.lgTabGroupTabChanged(Sender: TObject);
begin
  inherited;
  MoveActionPanel;
end;

procedure TfrmFormattedHintEditor.reEditorTextChange(Sender: TObject);
begin
  flHintPreview.Caption := GetText;
  flHintPreview.Hint := flHintPreview.Caption;
end;

procedure TfrmFormattedHintEditor.InitForm(AText: string; AObject: TObject);
var
  AOwnerCaption, AComponentName: string;
  AController: TcxCustomHintStyleController;
  AHintData: IcxHint;
  AComponent: TComponent absolute AObject;
  ALayoutOptions: TdxCustomLayoutItemCaptionOptions absolute AObject;
  ALItem: TdxCustomLayoutItem;
begin
  if AObject is TComponent then
  begin
    AComponentName := AComponent.Name;
    if (AComponent.Owner <> nil) then
      AOwnerCaption := AComponent.Owner.Name;
  end;
  if (AObject is TdxCustomLayoutItemCaptionOptions) and
    Assigned(TdxCustomLayoutItemCaptionOptionsAccessor(ALayoutOptions).Item) then
  begin
    ALItem := TdxCustomLayoutItemCaptionOptionsAccessor(ALayoutOptions).Item;
    AComponentName := ALItem.Name;
    if Assigned(ALItem.Owner) then
      AOwnerCaption := ALItem.Owner.Name;
  end;
  Caption := Format('%s%s - Formatted Hint Editor', [IfThen(AOwnerCaption = '', '', AOwnerCaption + '.'), AComponentName]);
  Text := AText;
  flHintPreview.Caption := AText;
  flHintPreview.Hint := AText;
  FComponent := AComponent;
  AController := cxGetHintStyleController;
  if Assigned(AController) and Supports(AController.HintStyle, IcxHint, AHintData) then
    flHintPreview.Style.Font := AHintData.GetHintFont
  else
    flHintPreview.Style.Font := Screen.HintFont;
  reRtf.Style.Font := flHintPreview.Style.Font;
  FHintStyleController := TcxHintStyleController.Create(Self);
  if Assigned(AController) then
    FHintStyleController.Assign(AController);
  liAddHintStyleController.Visible := not Assigned(AController) and Assigned(FComponent) and
    (Assigned(FComponent.Owner) or (FComponent is TCustomForm) or (FComponent is TCustomFrame));
  reBBCode.Properties.OnChange := reEditorTextChange;
  reRtf.Properties.OnChange := reEditorTextChange;
end;

end.
