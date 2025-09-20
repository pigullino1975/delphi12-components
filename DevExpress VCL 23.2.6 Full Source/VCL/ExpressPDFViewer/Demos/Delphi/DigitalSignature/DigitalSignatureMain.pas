unit DigitalSignatureMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, BaseForm, dxCore, dxCoreClasses, dxHashUtils, dxPDFCore,
  dxPDFBase, dxPDFText, dxPDFRecognizedObject, dxPDFDocument, dxCustomPreview, dxPDFDocumentViewer,
  dxPDFViewer, dxLayoutContainer, cxClasses, dxLayoutControl, dxLayoutControlAdapters, Menus, StdCtrls,
  cxButtons, dxLayoutLookAndFeels, dxLayoutcxEditAdapters, cxContainer, cxEdit, cxTextEdit, dxGDIPlusClasses, cxImage,
  dxX509Certificate, dxX509CertificatePasswordDialog, cxLabel, cxMaskEdit, cxDropDownEdit, dxPDFSignature,
  dxShellDialogs;

type
  TfrmPDFSignature = class(TfmBaseForm)
    dxPDFViewer1: TdxPDFViewer;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutGroup1: TdxLayoutGroup;
    btnLoadCertificate: TcxButton;
    liLoadCertificate: TdxLayoutItem;
    liSignatureReason: TdxLayoutItem;
    teSignatureReason: TcxTextEdit;
    liSignatureLocation: TdxLayoutItem;
    teSignatureLocation: TcxTextEdit;
    liSignatureContactInfo: TdxLayoutItem;
    teSignatureContactInfo: TcxTextEdit;
    imSignatureImage: TcxImage;
    liSignatureImage: TdxLayoutItem;
    btnApply: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    btnViewCertificate: TcxButton;
    dxLayoutItem3: TdxLayoutItem;
    lblCertificateSubject: TcxLabel;
    liCertificateSubject: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    cbSignatureImagePosition: TcxComboBox;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutGroup5: TdxLayoutGroup;
    btnSignAndSave: TcxButton;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    CertificateOpenDialog: TdxOpenFileDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadCertificateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure teSignatureReasonPropertiesChange(Sender: TObject);
    procedure teSignatureLocationPropertiesChange(Sender: TObject);
    procedure teSignatureContactInfoPropertiesChange(Sender: TObject);
    procedure btnViewCertificateClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnSignAndSaveClick(Sender: TObject);
  protected
    FCertificate: TdxX509Certificate;
    //
    procedure LoadCertificate(const ACertificateFileName, APassword: string);
    procedure LoadDocument(const AFileName: string);
    procedure SaveDocumentToStream(AStream: TStream);
    procedure SignDocument(ADocument: TdxPDFDocument; AStream: TStream); overload;
    procedure ShowMessageBox(const ACaption, AMessage: string);
    procedure UpdateControls;
  end;

var
  frmPDFSignature: TfrmPDFSignature;

implementation

{$R *.dfm}

uses
  Types, cxGeometry;

procedure TfrmPDFSignature.btnLoadCertificateClick(Sender: TObject);
var
  APassword: string;
begin
  if CertificateOpenDialog.Execute(Handle) and TdxX509CertificatePasswordDialogForm.Execute(nil, nil, APassword) then
  begin
    LoadCertificate(CertificateOpenDialog.FileName, APassword);
    UpdateControls;
  end;
end;

procedure TfrmPDFSignature.btnApplyClick(Sender: TObject);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    SaveDocumentToStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TfrmPDFSignature.btnSignAndSaveClick(Sender: TObject);
var
  AStream: TFileStream;
begin
  if SaveDialog.Execute(Handle) then
  begin
    AStream := TFileStream.Create(SaveDialog.FileName, fmCreate);
    try
      SaveDocumentToStream(AStream);
    finally
      AStream.Free;
    end;
  end;
end;

procedure TfrmPDFSignature.btnViewCertificateClick(Sender: TObject);
begin
  dxX509DisplayCertificate(FCertificate, Handle);
end;

procedure TfrmPDFSignature.FormCreate(Sender: TObject);
begin
  CertificateOpenDialog.Filter := 'Digital ID File (*.pfx)|*.PFX';
  cbSignatureImagePosition.ItemIndex := 5;

  LoadDocument('..\..\Data\DigitalSignature.pdf');
  LoadCertificate('..\..\Data\DigitalSignature.pfx', 'dxdemo');

  UpdateControls;
end;

procedure TfrmPDFSignature.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCertificate);
end;

procedure TfrmPDFSignature.LoadCertificate(const ACertificateFileName, APassword: string);
begin
  FreeAndNil(FCertificate);
  try
    FCertificate := TdxX509Certificate.Create(ACertificateFileName, APassword);
    if not dxX509IsUsableForDigitalSignature(FCertificate) then
    begin
      ShowMessageBox('Invalid certificate', 'The certificate cannot be used for the digital signature');
      FreeAndNil(FCertificate);
    end;
  except
    ShowMessageBox('Incorrect password', 'The password for the certificate is incorrect.');
    FreeAndNil(FCertificate);
  end;
end;

procedure TfrmPDFSignature.LoadDocument(const AFileName: string);
begin
  dxPDFViewer1.LoadFromFile(AFileName);
  dxPDFViewer1.OptionsZoom.ZoomFactor := 60;
  Caption := 'PDF Signature - ' + AFileName;
end;

procedure TfrmPDFSignature.SaveDocumentToStream(AStream: TStream);
begin
  SignDocument(dxPDFViewer1.Document, AStream);
  AStream.Position := 0;
  dxPDFViewer1.LoadFromStream(AStream);
  AStream.Position := 0;
end;

procedure TfrmPDFSignature.SignDocument(ADocument: TdxPDFDocument; AStream: TStream);

  function GetImageBounds(APageIdex: Integer; const ASize: TSize): TdxRectF;
  var
    APageSize: TdxPointF;
  begin
    APageSize := ADocument.PageInfo[APageIdex].Size;
    case cbSignatureImagePosition.ItemIndex of
      1:  // Top Center
        Result := dxRectF((APageSize.X - ASize.cx) / 2, 0, (APageSize.X + ASize.cx) / 2, ASize.cy);
      2:  // Top Left
        Result := dxRectF(0, 0, ASize.cx, ASize.cy);
      3:  // Bottom Right
        Result := dxRectF(APageSize.X - ASize.cx, APageSize.Y - ASize.cy, APageSize.X, APageSize.Y);
      4:  // Bottom Center
        Result := dxRectF((APageSize.X - ASize.cx) / 2, APageSize.Y - ASize.cy, (APageSize.X + ASize.cx) / 2, APageSize.Y);
      5:  // Bottom Left
        Result := dxRectF(0, APageSize.Y - ASize.cy, ASize.cx, APageSize.Y);
    else
        Result := dxRectF(APageSize.X - ASize.cx, 0, APageSize.X, ASize.cy);
    end;
  end;

  procedure PrepareSingatureFieldInfo(AInfo: TdxPDFSignatureFieldInfo);
  begin
    AInfo.Reason := teSignatureReason.Text;
    AInfo.Location := teSignatureLocation.Text;
    AInfo.ContactInfo := teSignatureContactInfo.Text;
    AInfo.Certificate := FCertificate;
    if Assigned(imSignatureImage.Picture) then
    begin
      AInfo.Appearance.Image.Assign(imSignatureImage.Picture.Graphic);
      AInfo.Appearance.RotationAngle := ra0;
      AInfo.Appearance.FitMode := ifmProportionalStretch;
      AInfo.Appearance.Bounds.PageIndex := 0;
      AInfo.Appearance.Bounds.Rect := GetImageBounds(AInfo.Appearance.Bounds.PageIndex, cxSize(300, 150));
    end;
  end;

begin
  PrepareSingatureFieldInfo(ADocument.SignatureOptions.Signature);
  ADocument.SignatureOptions.Enabled := True;
  ADocument.SaveToStream(AStream, True);
end;

procedure TfrmPDFSignature.ShowMessageBox(const ACaption, AMessage: string);
begin
  Application.MessageBox(PChar(AMessage), PChar(ACaption), MB_OK OR MB_ICONERROR);
end;

procedure TfrmPDFSignature.teSignatureContactInfoPropertiesChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrmPDFSignature.teSignatureLocationPropertiesChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrmPDFSignature.teSignatureReasonPropertiesChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrmPDFSignature.UpdateControls;
begin
  btnApply.Enabled := (teSignatureReason.Text <> '') and (teSignatureContactInfo.Text <> '') and
    (teSignatureLocation.Text <> '') and (FCertificate <> nil);
  btnSignAndSave.Enabled := btnApply.Enabled;
  btnViewCertificate.Enabled := FCertificate <> nil;
  if FCertificate <> nil then
    lblCertificateSubject.Caption := FCertificate.Subject
  else
    lblCertificateSubject.Caption := 'Unassigned';
end;

end.

