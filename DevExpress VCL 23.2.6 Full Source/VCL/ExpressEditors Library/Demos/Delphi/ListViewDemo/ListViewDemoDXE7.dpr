program ListViewDemoDXE7;

uses
  Forms,
  ListViewDemoMain in 'ListViewDemoMain.pas' {fmListViewDemo},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  DemoUtils in '..\DemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmListViewDemo, fmListViewDemo);
  Application.Run;
end.
