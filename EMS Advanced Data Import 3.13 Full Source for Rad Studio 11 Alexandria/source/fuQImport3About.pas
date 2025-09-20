unit fuQImport3About;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    Winapi.ShellAPI,
    System.SysUtils,
    Vcl.Forms,
    Vcl.StdCtrls,
    Vcl.Buttons,
    Vcl.Controls,
    Vcl.ExtCtrls,
    System.Classes,
    Winapi.Windows,
    Vcl.Graphics,
  {$ELSE}
    ShellAPI,
    SysUtils,
    Forms,
    StdCtrls,
    Buttons,
    Controls,
    ExtCtrls,
    Classes,
    Windows,
    Graphics,
  {$ENDIF}
  QImport3Common,
  fuQImport3License;

type
  TfmQImport3About = class(TForm)
    Image: TImage;
    lbVerInfo: TLabel;
    lbCopyRight: TLabel;
    lbVersion: TLabel;
    BitBtn1: TButton;
    laWarn: TLabel;
    laDevelopers: TLabel;
    lbCompanyHomePageTag: TLabel;
    lbCompanyHomePage: TLabel;
    lbProductHomePageTag: TLabel;
    lbProductHomePage: TLabel;
    GroupBox1: TGroupBox;
    lbLicense: TLabel;
    Panel1: TPanel;
    lbRegisterNow: TLabel;
    procedure lbCompanyHomePageClick(Sender: TObject);
    procedure lbRegisterNowClick(Sender: TObject);
    procedure lbLicenseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAboutForm;

implementation

{$R *.DFM}

procedure ShowAboutForm;
var
  LForm: TfmQImport3About;
begin
  LForm := TfmQImport3About.Create(nil);
  try
    LForm.lbVerInfo.Caption := QI_FULL_PRODUCT_NAME + ' ' + QI_VERSION_NUMBER;
    LForm.lbCopyRight.Caption := QI_COPYRIGHT;
    LForm.lbVersion.Caption := QI_VERSION;
{$IFNDEF ADVANCED_DATA_IMPORT_TRIAL_VERSION}
    LForm.lbVersion.Font.Color := clBlack;
    LForm.lbRegisterNow.Visible := False;
{$ENDIF}
    LForm.ShowModal;
  finally
    FreeAndNil(LForm);
  end;
end;

procedure TfmQImport3About.lbCompanyHomePageClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar((Sender as TLabel).Caption), nil, nil, SW_SHOW);
end;

procedure TfmQImport3About.lbRegisterNowClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(QI_REG_URL), nil, nil, SW_SHOW);
end;

procedure TfmQImport3About.lbLicenseClick(Sender: TObject);
begin
  with TfmQImport3License.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

end.
