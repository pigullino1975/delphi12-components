program DigitalSignatureD104Sydney;

uses
  Forms,
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\Common\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  DigitalSignatureMain in 'DigitalSignatureMain.pas' {frmPDFSignature};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPDFSignature, frmPDFSignature);
  Application.Run;
end.
