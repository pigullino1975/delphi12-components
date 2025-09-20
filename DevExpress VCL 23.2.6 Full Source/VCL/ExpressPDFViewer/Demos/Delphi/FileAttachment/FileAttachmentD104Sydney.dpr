program FileAttachmentD104Sydney;

uses
  Forms,
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\Common\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  FileAttachmentMain in 'FileAttachmentMain.pas' {frmPDFFileAttachment};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPDFFileAttachment, frmPDFFileAttachment);
  Application.Run;
end.
