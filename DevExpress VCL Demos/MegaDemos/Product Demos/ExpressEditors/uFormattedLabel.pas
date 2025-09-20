unit uFormattedLabel;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Types, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  dxCustomDemoFrameUnit, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxLayoutContainer, dxUIAdorners,
  Actions, ActnList, cxClasses, dxLayoutControl, dxColorDialog,
  ImgList, cxImageList, Menus, dxLayoutcxEditAdapters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxColorComboBox, cxGroupBox, cxRadioGroup, ComCtrls, ToolWin, cxTextEdit, cxMemo, cxRichEdit, dxFormattedLabel, dxBar;

type
  TfrmFormattedLabel = class(TdxCustomDemoFrame)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    miAbout: TMenuItem;
    cxImageList1: TcxImageList;
    ActionList2: TActionList;
    acBold: TAction;
    acItalic: TAction;
    acUnderline: TAction;
    acStrikeout: TAction;
    acFont: TAction;
    acFontColor: TAction;
    acBackgroundColor: TAction;
    acHyperlink: TAction;
    acNoparse: TAction;
    acSup: TAction;
    acSub: TAction;
    dxColorDialog1: TdxColorDialog;
    FontDialog1: TFontDialog;
    flMain: TdxFormattedLabel;
    reBBCode: TcxRichEdit;
    cbHyperlincColor: TcxColorComboBox;
    dxLayoutGroup9: TdxLayoutGroup;
    cbWordWrap: TdxLayoutCheckBoxItem;
    cbShowEndEllipsis: TdxLayoutCheckBoxItem;
    lgHorizontal: TdxLayoutGroup;
    lgVertical: TdxLayoutGroup;
    lrbLeft: TdxLayoutRadioButtonItem;
    lrbRight: TdxLayoutRadioButtonItem;
    lrbCenter: TdxLayoutRadioButtonItem;
    lrbTop: TdxLayoutRadioButtonItem;
    lrbBottom: TdxLayoutRadioButtonItem;
    lrbCenterV: TdxLayoutRadioButtonItem;
    dxBarManager1: TdxBarManager;
    dxBarDockControl1: TdxBarDockControl;
    dxLayoutItem5: TdxLayoutItem;
    dxBarManager1Bar1: TdxBar;
    bbBold: TdxBarButton;
    bbItalic: TdxBarButton;
    bbUnderline: TdxBarButton;
    bbStrikeout: TdxBarButton;
    bbSuperscript: TdxBarButton;
    bbSubscript: TdxBarButton;
    dxBarButton7: TdxBarButton;
    bbFont: TdxBarButton;
    bbFontColor: TdxBarButton;
    bbBackgroundColor: TdxBarButton;
    bbHyperlink: TdxBarButton;
    bbNoparse: TdxBarButton;
    cbShowHint: TdxLayoutCheckBoxItem;
    procedure acBoldExecute(Sender: TObject);
    procedure acItalicExecute(Sender: TObject);
    procedure acUnderlineExecute(Sender: TObject);
    procedure acStrikeoutExecute(Sender: TObject);
    procedure acFontExecute(Sender: TObject);
    procedure acFontColorExecute(Sender: TObject);
    procedure acBackgroundColorExecute(Sender: TObject);
    procedure acHyperlinkExecute(Sender: TObject);
    procedure acNoparseExecute(Sender: TObject);
    procedure acSupExecute(Sender: TObject);
    procedure acSubExecute(Sender: TObject);
    procedure reBBCodePropertiesEditValueChanged(Sender: TObject);
    procedure cbHyperlincColorPropertiesEditValueChanged(Sender: TObject);
    procedure cbWordWrapClick(Sender: TObject);
    procedure cbShowEndEllipsisClick(Sender: TObject);
    procedure lrbLeftClick(Sender: TObject);
    procedure lrbTopClick(Sender: TObject);
    procedure cbShowHintClick(Sender: TObject);
  protected
    function GetDescription: string; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  dxFrames, FrameIDs, uHyperlincDialog, dxCoreGraphics, dxFormattedText, uStrsConst;

{ TfrmFormattedLabel }

procedure TfrmFormattedLabel.acBackgroundColorExecute(Sender: TObject);
begin
  if dxColorDialog1.Execute then
    reBBCode.SelText := Format('[BACKCOLOR=#%s]%s[/BACKCOLOR]', [TdxAlphaColors.ToHexCode(dxColorDialog1.Color, False),
      reBBCode.SelText]);
  reBBCode.SelStart := reBBCode.SelStart - 12;
end;

procedure TfrmFormattedLabel.acBoldExecute(Sender: TObject);
begin
  reBBCode.SelText := Format('[B]%s[/B]', [reBBCode.SelText]);
  reBBCode.SelStart := reBBCode.SelStart - 4;
end;

procedure TfrmFormattedLabel.acFontColorExecute(Sender: TObject);
begin
  if dxColorDialog1.Execute then
  begin
    reBBCode.SelText := Format('[COLOR=#%s]%s[/COLOR]', [TdxAlphaColors.ToHexCode(dxColorDialog1.Color, False),
      reBBCode.SelText]);
    reBBCode.SelStart := reBBCode.SelStart - 8;
  end;
end;

procedure TfrmFormattedLabel.acFontExecute(Sender: TObject);
var
  ASelectedText: string;
  ASelStartIndent: Integer;
begin
  inherited;
  if FontDialog1.Execute(reBBCode.Handle) then
  begin
    ASelStartIndent := 0;
    ASelectedText := reBBCode.SelText;
    if FontDialog1.Font.Name <> reBBCode.Style.Font.Name then
    begin
      ASelectedText := Format('[FONT=%s]%s[/FONT]', [FontDialog1.Font.Name,  ASelectedText]);
      ASelStartIndent := ASelStartIndent + 7;
    end;
    if FontDialog1.Font.Size <> reBBCode.Style.Font.Size then
    begin
      ASelectedText := Format('[SIZE=%s]%s[/SIZE]', [IntToStr(FontDialog1.Font.Size),  ASelectedText]);
      ASelStartIndent := ASelStartIndent + 7;
    end;
    if FontDialog1.Font.Color <> reBBCode.Style.Font.Color then
    begin
      ASelectedText := Format('[COLOR=#%.2x%.2x%.2x]%s[/COLOR]', [dxColorToRGBQuad(FontDialog1.Font.Color).rgbRed,
        dxColorToRGBQuad(FontDialog1.Font.Color).rgbGreen, dxColorToRGBQuad(FontDialog1.Font.Color).rgbBlue,  ASelectedText]);
      ASelStartIndent := ASelStartIndent + 8;
    end;
    if fsBold in FontDialog1.Font.Style then
    begin
      ASelectedText := Format('[B]%s[/B]', [ASelectedText]);
      ASelStartIndent := ASelStartIndent + 4;
    end;
    if fsItalic in FontDialog1.Font.Style then
    begin
      ASelectedText := Format('[I]%s[/I]', [ASelectedText]);
      ASelStartIndent := ASelStartIndent + 4;
    end;
    if fsUnderline in FontDialog1.Font.Style then
    begin
      ASelectedText := Format('[U]%s[/U]', [ASelectedText]);
      ASelStartIndent := ASelStartIndent + 4;
    end;
    if fsStrikeOut in FontDialog1.Font.Style then
    begin
      ASelectedText := Format('[S]%s[/S]', [ASelectedText]);
      ASelStartIndent := ASelStartIndent + 4;
    end;
    reBBCode.SelText := ASelectedText;
    reBBCode.SelStart := reBBCode.SelStart - ASelStartIndent;
  end;
end;

procedure TfrmFormattedLabel.acHyperlinkExecute(Sender: TObject);
var
  AHyperlinkDialog: TfmHyperlinkDialog;
begin
  AHyperlinkDialog := TfmHyperlinkDialog.Create(nil);
  try
    AHyperlinkDialog.edtTextToDisplay.Text := reBBCode.SelText;
    if AHyperlinkDialog.ShowModal = mrOk then
    begin
      reBBCode.SelText := Format('[URL=%s]%s[/URL]', [AHyperlinkDialog.edtAddress.Text, AHyperlinkDialog.edtTextToDisplay.Text]);
      reBBCode.SelStart := reBBCode.SelStart - 6;
    end;
  finally
    AHyperlinkDialog.Release;
  end;
end;

procedure TfrmFormattedLabel.acItalicExecute(Sender: TObject);
begin
  reBBCode.SelText := Format('[I]%s[/I]', [reBBCode.SelText]);
  reBBCode.SelStart := reBBCode.SelStart - 4;
end;

procedure TfrmFormattedLabel.acNoparseExecute(Sender: TObject);
begin
  reBBCode.SelText := Format('[NOPARSE]%s[/NOPARSE]', [reBBCode.SelText]);
  reBBCode.SelStart := reBBCode.SelStart - 10;
end;

procedure TfrmFormattedLabel.acStrikeoutExecute(Sender: TObject);
begin
  reBBCode.SelText := Format('[S]%s[/S]', [reBBCode.SelText]);
  reBBCode.SelStart := reBBCode.SelStart - 4;
end;

procedure TfrmFormattedLabel.acSubExecute(Sender: TObject);
begin
  reBBCode.SelText := Format('[SUB]%s[/SUB]', [reBBCode.SelText]);
  reBBCode.SelStart := reBBCode.SelStart - 6;
end;

procedure TfrmFormattedLabel.acSupExecute(Sender: TObject);
begin
  reBBCode.SelText := Format('[SUP]%s[/SUP]', [reBBCode.SelText]);
  reBBCode.SelStart := reBBCode.SelStart - 6;
end;

procedure TfrmFormattedLabel.acUnderlineExecute(Sender: TObject);
begin
  reBBCode.SelText := Format('[U]%s[/U]', [reBBCode.SelText]);
  reBBCode.SelStart := reBBCode.SelStart - 4;
end;

procedure TfrmFormattedLabel.cbHyperlincColorPropertiesEditValueChanged(Sender: TObject);
begin
  flMain.Properties.HyperlinkColor := cbHyperlincColor.ColorValue;
end;

procedure TfrmFormattedLabel.cbShowEndEllipsisClick(Sender: TObject);
begin
  flMain.Properties.ShowEndEllipsis := cbShowEndEllipsis.Checked;
end;

procedure TfrmFormattedLabel.cbShowHintClick(Sender: TObject);
begin
  flMain.Hint := flMain.Caption;
  flMain.ShowHint := cbShowHint.Checked;
end;

procedure TfrmFormattedLabel.cbWordWrapClick(Sender: TObject);
begin
  flMain.Properties.WordWrap := cbWordWrap.Checked;
end;

constructor TfrmFormattedLabel.Create(AOwner: TComponent);
begin
  inherited;
  reBBCode.Text := '[B]Questions?[/B]'#13#10'Visit our [URL=https://www.devexpress.com/support/]Support Center[/URL]';
end;

function TfrmFormattedLabel.GetDescription: string;
begin
  Result := sdxFrameFormattedLabelDescription;
end;

procedure TfrmFormattedLabel.lrbLeftClick(Sender: TObject);
begin
  flMain.Properties.Alignment.Horz := TcxEditHorzAlignment(TdxLayoutItem(Sender).Tag);
end;

procedure TfrmFormattedLabel.lrbTopClick(Sender: TObject);
begin
  flMain.Properties.Alignment.Vert := TcxEditVertAlignment(TdxLayoutItem(Sender).Tag);
end;

procedure TfrmFormattedLabel.reBBCodePropertiesEditValueChanged(Sender: TObject);
begin
  flMain.Caption := reBBCode.EditingText;
  if cbShowHint.Checked then
    flMain.Hint := flMain.Caption;
end;
initialization
  dxFrameManager.RegisterFrame(FormattedLabelFrameID, TfrmFormattedLabel, FormattedLabelFrameName, -1,
    EditorsWithoutTextBoxesGroupIndex, HighlightedFeatureGroupIndex, -1);
end.
