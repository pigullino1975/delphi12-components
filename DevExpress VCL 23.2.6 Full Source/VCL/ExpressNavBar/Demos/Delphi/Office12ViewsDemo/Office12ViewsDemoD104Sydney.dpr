program Office12ViewsDemoD104Sydney;

uses
  Forms,
  Office12ViewsMain in 'Office12ViewsMain.pas' {fmMain};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
