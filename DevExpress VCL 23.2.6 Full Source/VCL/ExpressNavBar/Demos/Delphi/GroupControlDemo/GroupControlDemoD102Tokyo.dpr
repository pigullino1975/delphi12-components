program GroupControlDemoD102Tokyo;

uses
  Forms,
  GroupControlMain in 'GroupControlMain.pas' {fmGroupControlMain};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmGroupControlMain, fmGroupControlMain);
  Application.Run;
end.
