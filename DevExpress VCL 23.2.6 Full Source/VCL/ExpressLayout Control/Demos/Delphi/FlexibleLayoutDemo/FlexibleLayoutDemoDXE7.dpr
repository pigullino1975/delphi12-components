program FlexibleLayoutDemoDXE7;

uses
  Forms,
  DemoDM in '..\common\DemoDM.pas' {dmDemo: TDataModule},
  FlexibleLayoutDemoMain in 'FlexibleLayoutDemoMain.pas' {fmFlexibleLayoutDemooMain};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDemo, dmDemo);
  Application.CreateForm(TfmFlexibleLayoutDemoMain, fmFlexibleLayoutDemoMain);
  Application.Run;
end.
