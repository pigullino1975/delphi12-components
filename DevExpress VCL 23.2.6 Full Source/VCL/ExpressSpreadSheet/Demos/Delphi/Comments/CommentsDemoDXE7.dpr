program CommentsDemoDXE7;

uses
  Forms,
  CommentsDemoMain in 'CommentsDemoMain.pas' {frmComments},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\Common\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmComments, frmComments);
  Application.Run;
end.
