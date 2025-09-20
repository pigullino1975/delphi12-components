program PageMergingD102Tokyo;

uses
  Forms,
  PageMergingMain in 'PageMergingMain.pas' {frmPDFPageMerging},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\Common\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPDFPageMerging, frmPDFPageMerging);
  Application.Run;
end.
