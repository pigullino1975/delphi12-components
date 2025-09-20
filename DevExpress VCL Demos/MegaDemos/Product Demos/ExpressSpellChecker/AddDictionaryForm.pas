unit AddDictionaryForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxCheckListBox, cxEdit, cxGroupBox, cxRadioGroup,
  cxTextEdit, cxHyperLinkEdit, dxSpellChecker, Menus, StdCtrls, cxButtons,
  ExtCtrls, cxDropDownEdit, cxMaskEdit, cxButtonEdit, cxClasses, dxForms, cxLabel, dxShellDialogs,
  dxLayoutcxEditAdapters, dxLayoutControlAdapters, dxLayoutLookAndFeels,
  dxLayoutContainer, dxLayoutControl;

type
  TfmAddDictionary = class(TdxForm)
    beAffFile: TcxButtonEdit;
    beDicFile: TcxButtonEdit;
    btnAdd: TcxButton;
    btnCancel: TcxButton;
    cbCodePage: TcxComboBox;
    cbLang: TcxComboBox;
    OpenDialog1: TdxOpenFileDialog;
    hlLink: TcxLabel;
    liCodePageGroup_Root: TdxLayoutGroup;
    liCodePage: TdxLayoutControl;
    dxLayoutGroup1: TdxLayoutGroup;
    lgDictionatyTypeHunspell: TdxLayoutRadioButtonItem;
    lgDictionatyTypeOpenOffice: TdxLayoutRadioButtonItem;
    lgDictionatyTypeISpell: TdxLayoutRadioButtonItem;
    lgLink: TdxLayoutGroup;
    dxLayoutLabeledItem1: TdxLayoutLabeledItem;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    dxLayoutGroup4: TdxLayoutGroup;
    dxLayoutItem6: TdxLayoutItem;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;

    procedure beAffFilePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure beAffFilePropertiesChange(Sender: TObject);
    procedure beDicFilePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure rgDictionatyTypePropertiesChange(Sender: TObject);
    procedure hlLinkClick(Sender: TObject);
  public
    procedure Add(ASpellChecker: TdxCustomSpellChecker);
  end;

var
  fmAddDictionary: TfmAddDictionary;

procedure AddDictionary(ASpellChecker: TdxCustomSpellChecker);

implementation

{$R *.dfm}

uses
  dxISpellDecompressor, dxHunspellDictionary, dxSpellCheckerUtils, ShellAPI;

procedure AddDictionary(ASpellChecker: TdxCustomSpellChecker);
begin
  if fmAddDictionary.ShowModal = mrOk then
    fmAddDictionary.Add(ASpellChecker);
end;

{ TfmAddDictionary }

procedure TfmAddDictionary.FormCreate(Sender: TObject);
var
  ACodePages: TdxSpellCheckerCodePages;
  I: Integer;
begin
  for I := 0 to dxLanguages.Count - 1 do
    cbLang.Properties.Items.AddObject(dxLanguages.Name[I], Pointer(dxLanguages.LocaleID[I]));
  cbLang.ItemIndex := dxLanguages.IndexOf(dxLanguages.GetDefaultLanguageLCID);
  ACodePages := TdxSpellCheckerCodePages.Create(True);
  try
    for I := 0 to ACodePages.Count - 1 do
      cbCodePage.Properties.Items.AddObject(ACodePages.Name[I], Pointer(ACodePages.Code[I]));
    for I := 0 to ACodePages.Count - 1 do
      if ACodePages.Code[I] = GetACP then
      begin
        cbCodePage.ItemIndex := I;
        Break;
      end;
  finally
    ACodePages.Free;
  end;
end;

procedure TfmAddDictionary.hlLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(hlLink.Caption), nil, nil, SW_SHOW);
end;

procedure TfmAddDictionary.Add(ASpellChecker: TdxCustomSpellChecker);
var
  ADictionaryItem: TdxSpellCheckerDictionaryItem;

  procedure InitializeHunspell;
  var
    D: TdxHunspellDictionary;
  begin
    ADictionaryItem.DictionaryTypeClass := TdxHunspellDictionary;
    D := ADictionaryItem.DictionaryType as TdxHunspellDictionary;
    D.GrammarPath := beAffFile.Text;
    D.DictionaryPath := beDicFile.Text;
    D.Language := Integer(cbLang.Properties.Items.Objects[cbLang.ItemIndex]);
  end;

  procedure InitializeOffice;
  var
    D: TdxOpenOfficeDictionary;
  begin
    ADictionaryItem.DictionaryTypeClass := TdxOpenOfficeDictionary;
    D := ADictionaryItem.DictionaryType as TdxOpenOfficeDictionary;
    D.GrammarPath := beAffFile.Text;
    D.DictionaryPath := beDicFile.Text;
    D.Language := Integer(cbLang.Properties.Items.Objects[cbLang.ItemIndex]);
  end;

  procedure InitializeISpell;
  var
    D: TdxISpellDictionary;
  begin
    ADictionaryItem.DictionaryTypeClass := TdxISpellDictionary;
    D := ADictionaryItem.DictionaryType as TdxISpellDictionary;
    D.GrammarPath := beAffFile.Text;
    D.DictionaryPath := beDicFile.Text;
    D.Language := Integer(cbLang.Properties.Items.Objects[cbLang.ItemIndex]);
    D.CodePage := Integer(cbCodePage.Properties.Items.Objects[cbCodePage.ItemIndex]);
  end;

begin
  ADictionaryItem := ASpellChecker.DictionaryItems.Add;
  if lgDictionatyTypeHunspell.Checked then
    InitializeHunspell
  else
    if lgDictionatyTypeOpenOffice.Checked then
      InitializeOffice
    else
      if lgDictionatyTypeISpell.Checked then
        InitializeISpell
      else
        Assert(False);
  ShowHourglassCursor;
  try
    ADictionaryItem.DictionaryType.Load(dlmDirectLoad);
  finally
    HideHourglassCursor;
  end;
end;

procedure TfmAddDictionary.rgDictionatyTypePropertiesChange(
  Sender: TObject);
begin
  liCodePage.Visible := lgDictionatyTypeOpenOffice.Checked;
  lgLink.Visible := not liCodePage.Visible;
end;

procedure TfmAddDictionary.beAffFilePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := 'Affix files (*.aff)|*.aff|All files (*.*)|*.*';
  if OpenDialog1.Execute then
    beAffFile.Text := OpenDialog1.FileName;
end;

procedure TfmAddDictionary.beDicFilePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := 'Dictionary files (*.dic)|*.dic|All files (*.*)|*.*';
  if OpenDialog1.Execute then
    beDicFile.Text := OpenDialog1.FileName;
end;

procedure TfmAddDictionary.beAffFilePropertiesChange(Sender: TObject);
begin
  btnAdd.Enabled := FileExists(beAffFile.Text) and FileExists(beDicFile.Text);
end;

end.
