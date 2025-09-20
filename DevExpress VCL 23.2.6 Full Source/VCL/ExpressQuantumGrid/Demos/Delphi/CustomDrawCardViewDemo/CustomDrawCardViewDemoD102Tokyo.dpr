program CustomDrawCardViewDemoD102Tokyo;

{$R 'CustomDrawCardViewDemoImages.res' 'CustomDrawCardViewDemoImages.rc'}

uses
  Forms,
  CustomDrawCardViewDemoMain in 'CustomDrawCardViewDemoMain.pas' {CustomDrawCardViewDemoMainForm},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  DemoUtils in '..\DemoUtils.pas',
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  FilmsDemoData in '..\Common\FilmsDemoData.pas' {FilmsDemoDM: TDataModule};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid CustomDrawCardView Demo';
  Application.CreateForm(TFilmsDemoDM, FilmsDemoDM);
  Application.CreateForm(TCustomDrawCardViewDemoMainForm, CustomDrawCardViewDemoMainForm);
  Application.Run;
end.
