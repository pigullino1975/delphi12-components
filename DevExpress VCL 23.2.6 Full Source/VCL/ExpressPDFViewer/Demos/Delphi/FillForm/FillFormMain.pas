unit FillFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Menus, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, BaseForm, dxCore, dxCoreClasses, dxHashUtils,
  dxPDFCore, dxPDFBase, dxPDFText, dxPDFRecognizedObject, dxPDFDocument, dxLayoutContainer, dxLayoutControlAdapters,
  dxX509Certificate, dxPrintUtils, cxContainer, cxEdit, cxCustomListBox, cxListBox, cxButtons,
  dxCustomPreview, dxPDFDocumentViewer, dxPDFViewer, cxClasses, dxLayoutLookAndFeels, dxShellDialogs, dxLayoutControl,
  dxLayoutcxEditAdapters, cxTextEdit, ComCtrls, cxDateUtils, cxDropDownEdit, cxMaskEdit, cxCalendar, dxPDFForm,
  dxPDFFormData;

type
  TfrmPDFFillForm = class(TfmBaseForm)
    dxPDFViewer1: TdxPDFViewer;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    btnSubmit: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    teFirstName: TcxTextEdit;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    teLastName: TcxTextEdit;
    rbtMale: TdxLayoutRadioButtonItem;
    rbtFemale: TdxLayoutRadioButtonItem;
    lgGender: TdxLayoutGroup;
    deDateOfBirth: TcxDateEdit;
    dxLayoutItem5: TdxLayoutItem;
    tePassportNo: TcxTextEdit;
    dxLayoutItem6: TdxLayoutItem;
    cbNationality: TcxComboBox;
    dxLayoutItem7: TdxLayoutItem;
    teAddress: TcxTextEdit;
    dxLayoutItem8: TdxLayoutItem;
    teVisaNo: TcxTextEdit;
    dxLayoutItem9: TdxLayoutItem;
    teFlightNo: TcxTextEdit;
    dxLayoutItem10: TdxLayoutItem;
    btnReset: TcxButton;
    dxLayoutItem11: TdxLayoutItem;
    dxLayoutSplitterItem1: TdxLayoutSplitterItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    SaveAs1: TMenuItem;
    procedure btnSubmitClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
  protected
    FDocument: TdxPDFDocument;
    //
    procedure LoadDocument(const AFileName: string);
    procedure LoadNationalityItems;
    procedure ResetForm;
  public
    procedure AfterConstruction; override;
  end;

var
  frmPDFFillForm: TfrmPDFFillForm;

implementation

{$R *.dfm}

uses
  IOUtils, DateUtils, Types, Math, cxGeometry;

procedure TfrmPDFFillForm.AfterConstruction;
begin
  inherited AfterConstruction;;
  LoadDocument('..\..\Data\FormDemo.pdf');
  LoadNationalityItems;
  ResetForm;
end;

procedure TfrmPDFFillForm.btnResetClick(Sender: TObject);
begin
  ResetForm;
end;

procedure TfrmPDFFillForm.btnSubmitClick(Sender: TObject);

  procedure SetTextValue(const AFieldName, AValue: string);
  var
    AField: TdxPDFTextField;
  begin
    if FDocument.Form.TryGetTextField(AFieldName, AField) then
      AField.Text := AValue;
  end;

var
  AComboBoxField: TdxPDFComboBoxField;
  ADate: TDateTime;
  AForm: TdxPDFForm;
  ARadioGroupField: TdxPDFRadioGroupField;
begin
  AForm := FDocument.Form;
  FDocument.BeginUpdate;
  try
    SetTextValue('FirstName', teFirstName.Text);
    SetTextValue('LastName', teLastName.Text);
    SetTextValue('PassportNo', tePassportNo.Text);
    SetTextValue('Address', teAddress.Text);
    SetTextValue('VisaNo', teVisaNo.Text);
    SetTextValue('FlightNo', teFlightNo.Text);

    ADate := deDateOfBirth.Date;
    SetTextValue('DD', IntToStr(DayOf(ADate)));
    SetTextValue('MM', IntToStr(MonthOf(ADate)));
    SetTextValue('YYYY', IntToStr(YearOf(ADate)));

    if AForm.TryGetRadioGroupField('Gender', ARadioGroupField) then
      ARadioGroupField.ItemIndex := IfThen(rbtFemale.Checked, 1);

    if AForm.TryGetComboBoxField('Nationality', AComboBoxField) then
      AComboBoxField.ItemIndex := cbNationality.ItemIndex;
  finally
    FDocument.EndUpdate;
  end;
  btnReset.Enabled := True;
end;

procedure TfrmPDFFillForm.LoadDocument(const AFileName: string);
begin
  dxPDFViewer1.BeginUpdate;
  dxPDFViewer1.LoadFromFile(AFileName);
  dxPDFViewer1.OptionsZoom.ZoomMode := pzmPageWidth;
  dxPDFViewer1.EndUpdate;
  FDocument := dxPDFViewer1.Document;
  Caption := 'Fill PDF Form - ' + AFileName;
  Width := ScaleFactor.Apply(1005);
end;

procedure TfrmPDFFillForm.LoadNationalityItems;
var
  AComboBoxField: TdxPDFComboBoxField;
  I: Integer;
begin
  if not FDocument.Form.TryGetComboBoxField('Nationality', AComboBoxField) then
    Exit;
  cbNationality.Properties.BeginUpdate;
  try
    for I := 0 to AComboBoxField.ItemCount - 1 do
      cbNationality.Properties.Items.Add(AComboBoxField.Items[I].Value);
    cbNationality.ItemIndex := AComboBoxField.ItemIndex;
  finally
    cbNationality.Properties.EndUpdate;
  end;
end;

procedure TfrmPDFFillForm.ResetForm;
begin
  FDocument.Form.Reset;
  btnReset.Enabled := False;
end;

procedure TfrmPDFFillForm.SaveAs1Click(Sender: TObject);
begin
  if SaveDialog.Execute(Handle) then
    FDocument.SaveToFile(SaveDialog.FileName, True);
end;

end.

