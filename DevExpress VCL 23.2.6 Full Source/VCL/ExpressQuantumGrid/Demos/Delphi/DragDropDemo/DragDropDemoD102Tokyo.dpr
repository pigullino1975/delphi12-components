program DragDropDemoD102Tokyo;

uses
  Forms,
  DragDropDemoDictionaries in 'DragDropDemoDictionaries.pas' {DragDropDemoDictionariesForm},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  DemoUtils in '..\DemoUtils.pas',
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  FilmsDemoData in '..\Common\FilmsDemoData.pas' {FilmsDemoDM: TDataModule},
  DragDropDemoMain in 'DragDropDemoMain.pas' {DragDropDemoMainForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid DragDropDemoD102Tokyo';
  Application.CreateForm(TFilmsDemoDM, FilmsDemoDM);
  Application.CreateForm(TDragDropDemoMainForm, DragDropDemoMainForm);
  Application.CreateForm(TDragDropDemoDictionariesForm, DragDropDemoDictionariesForm);
  Application.Run;
end.
