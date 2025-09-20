program BackgroundDemoD102Tokyo;

uses
  Forms,
  BackgroundDemoMain in 'BackgroundDemoMain.pas' {BackgroundDemoMainForm},
  EBarsDemoRating in '..\Common\EBarsDemoRating.pas' {EBarsDemoRatingForm},
  EBarsUtils in '..\Common\EBarsUtils.pas' {dmCommonData: TDataModule},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressBars Background Demo';
  Application.CreateForm(TdmCommonData, dmCommonData);
  Application.CreateForm(TBackgroundDemoMainForm, BackgroundDemoMainForm);
  Application.CreateForm(TEBarsDemoRatingForm, EBarsDemoRatingForm);
  Application.Run;
end.
