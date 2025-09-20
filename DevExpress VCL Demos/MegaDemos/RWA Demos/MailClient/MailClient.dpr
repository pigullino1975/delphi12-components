program MailClient;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  MidasLib,
  Vcl.Controls,
  Forms,
  SysUtils,
  dxAboutDemo in '..\..\Product Demos\Common\dxAboutDemo.pas',
  dxDemoUtils in '..\..\Product Demos\Common\dxDemoUtils.pas',
  MailClientDemoBase in 'MailClientDemoBase.pas' {MailClientDemoBaseFrame: TFrame},
  MailClientDemoCalendar in 'MailClientDemoCalendar.pas' {MailClientDemoCalendarFrame: TFrame},
  MailClientDemoMain in 'MailClientDemoMain.pas' {fmMailClientDemoMain},
  MailClientDemoData in 'MailClientDemoData.pas' {DM: TDataModule},
  MailClientDemoBaseGrid in 'MailClientDemoBaseGrid.pas' {MailClientDemoBaseGridFrame: TFrame},
  MailClientDemoMails in 'MailClientDemoMails.pas' {MailClientDemoMailsFrame: TFrame},
  MailClientDemoContacts in 'MailClientDemoContacts.pas' {MailClientDemoContactsFrame: TFrame},
  MailClientDemoTasks in 'MailClientDemoTasks.pas' {MailClientDemoTasksFrame: TFrame},
  fmMailUnit in 'fmMailUnit.pas' {fmMail},
  fmWhomSelectUnit in 'fmWhomSelectUnit.pas' {fmWhomSelect},
  fmBaseEditUnit in 'fmBaseEditUnit.pas' {fmBaseEdit},
  fmContactUnit in 'fmContactUnit.pas' {fmContact},
  fmTaskUnit in 'fmTaskUnit.pas' {fmTask},
  dxMailClientDemoUtils in 'dxMailClientDemoUtils.pas',
  fmTaskCustomDateUnit in 'fmTaskCustomDateUnit.pas' {fmTaskCustomDate},
  MailCloseDialog in 'MailCloseDialog.pas' {fmMailCloseDialog},
  fmSplashScreenUnit in 'fmSplashScreenUnit.pas' {fmSplashScreen},
  MailClientDateNavigator in 'MailClientDateNavigator.pas' {Frame1: TFrame},
  MainClientDemoPrinting in 'MainClientDemoPrinting.pas' {frmPrinting: TFrame},
  LocalizationStrs in 'LocalizationStrs.pas',
  SelectLanguageUnit in 'SelectLanguageUnit.pas' {fmSelectLanguage};

{$R *.res}
{$R dxDPIAwareManifestPM2.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfmSelectLanguage, fmSelectLanguage);
  try
    if fmSelectLanguage.ShowModal = mrOk then
    begin
      FreeAndNil(fmSelectLanguage);
      TfmSplashScreen.BeginLoading;
      Application.CreateForm(TfmMailClientDemoMain, fmMailClientDemoMain);
      TfmSplashScreen.EndLoading;
    end;
  finally
    FreeAndNil(fmSelectLanguage);
  end;
  Application.Run;
end.
