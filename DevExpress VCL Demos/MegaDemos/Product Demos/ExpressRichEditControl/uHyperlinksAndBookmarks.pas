unit uHyperlinksAndBookmarks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, UITypes,
  Dialogs, dxRichEditFrame, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxCore, dxCoreClasses,
  dxGDIPlusAPI, dxGDIPlusClasses, dxRichEdit.Types, dxRichEdit.Options,
  dxRichEdit.Control, dxHttpIndyRequest, dxBarBuiltInMenu, dxRichEdit.NativeApi,
  dxRichEdit.Platform.Win.Control, cxLabel, ExtCtrls, dxRibbon, cxCheckBox,
  cxGroupBox, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxColorComboBox,
  dxLayoutContainer, dxLayoutcxEditAdapters, dxRichEdit.Control.SpellChecker,
  dxRichEdit.Dialogs.EventArgs, dxRichEdit.Control.Core, cxClasses,
  dxLayoutControl, dxLayoutLookAndFeels;

type
  TfrmRichEditHyperlinksAndBookmarks = class(TfrmRichEditFrame)
    cbShowBookmarks: TcxCheckBox;
    ccbBookmarksColor: TcxColorComboBox;
    cbShowTooltip: TcxCheckBox;
    cbCtrl: TcxCheckBox;
    cbAlt: TcxCheckBox;
    cbShift: TcxCheckBox;
    lcTopGroup_Root: TdxLayoutGroup;
    lcTop: TdxLayoutControl;
    lgBookmarks: TdxLayoutGroup;
    lgHyperlinks: TdxLayoutGroup;
    liShowBookmarks: TdxLayoutItem;
    liBookmarksColor: TdxLayoutItem;
    liAlt: TdxLayoutItem;
    liCtrl: TdxLayoutItem;
    liShift: TdxLayoutItem;
    liShowTooltip: TdxLayoutItem;
    lgKeys: TdxLayoutGroup;
    llbModifierKeys: TdxLayoutLabeledItem;
    llflTop: TdxLayoutLookAndFeelList;
    llfTop: TdxLayoutCxLookAndFeel;
    procedure cbShowBookmarksPropertiesEditValueChanged(Sender: TObject);
    procedure ccbBookmarksColorPropertiesEditValueChanged(Sender: TObject);
    procedure cbShowTooltipPropertiesEditValueChanged(Sender: TObject);
    procedure cbModifierKeysPropertiesChange(Sender: TObject);
  protected
    function GetDescription: string; override;
    function GetStartDocumentName: string; override;
  end;

var
  frmRichEditHyperlinksAndBookmarks: TfrmRichEditHyperlinksAndBookmarks;

implementation

{$R *.dfm}

uses
  dxFrames, FrameIDs, uStrsConst, dxCoreGraphics;

{ TfrmRichEditHyperlinkAndBookmarks }

procedure TfrmRichEditHyperlinksAndBookmarks.cbModifierKeysPropertiesChange(Sender: TObject);
var
  AShortCut: TShortCut;
begin
  AShortCut := 0;
  if cbCtrl.Checked then
    Inc(AShortCut, scCtrl);
  if cbShift.Checked then
    Inc(AShortCut, scShift);
  if cbAlt.Checked then
    Inc(AShortCut, scAlt);
  RichEditControl.Options.Hyperlinks.ModifierKeys := AShortCut;
end;

procedure TfrmRichEditHyperlinksAndBookmarks.cbShowBookmarksPropertiesEditValueChanged(
  Sender: TObject);
begin
  if cbShowBookmarks.Checked then
    RichEditControl.Options.Bookmarks.Visibility := TdxRichEditBookmarkVisibility.Visible
  else
    RichEditControl.Options.Bookmarks.Visibility := TdxRichEditBookmarkVisibility.Hidden;
end;

procedure TfrmRichEditHyperlinksAndBookmarks.cbShowTooltipPropertiesEditValueChanged(
  Sender: TObject);
begin
  RichEditControl.Options.Hyperlinks.ShowToolTip := cbShowTooltip.Checked;
end;

procedure TfrmRichEditHyperlinksAndBookmarks.ccbBookmarksColorPropertiesEditValueChanged(
  Sender: TObject);
begin
  RichEditControl.Options.Bookmarks.Color := TdxAlphaColors.FromColor(ccbBookmarksColor.ColorValue);
end;

function TfrmRichEditHyperlinksAndBookmarks.GetDescription: string;
begin
  Result := sdxFrameHyperlinksDescription;
end;

function TfrmRichEditHyperlinksAndBookmarks.GetStartDocumentName: string;
begin
  Result := sdxHyperlinksAndBookmarksStartDocumentName;
end;

initialization
  dxFrameManager.RegisterFrame(RichEditHyperlinksAndBookmarksID, TfrmRichEditHyperlinksAndBookmarks,
    RichEditHyperlinksAndBookmarksFrameName, EditingFeaturesGroupIndex, -1, -1);

finalization

end.
