unit UWebBrowserPrinting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvCustomControl, AdvWebBrowser,
  Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    PrintUIBtn: TButton;
    PrintToPDFStreamBtn: TButton;
    PrintBtn: TButton;
    PrintToPDFBtn: TButton;
    NavigateBtn: TButton;
    URLEdit: TEdit;
    AdvWebBrowser1: TAdvWebBrowser;
    procedure NavigateBtnClick(Sender: TObject);
    procedure PrintUIBtnClick(Sender: TObject);
    procedure PrintToPDFStreamBtnClick(Sender: TObject);
    procedure AdvWebBrowser1GetPrintPDFStream(Sender: TObject; AStream: TMemoryStream);
    procedure PrintToPDFBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure AdvWebBrowser1Initialized(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.AdvWebBrowser1Initialized(Sender: TObject);
begin
  if Pos('http', AdvWebBrowser1.Url) > 0 then
    URLEdit.Text := AdvWebBrowser1.Url;
end;

procedure TForm2.NavigateBtnClick(Sender: TObject);
begin
  AdvWebBrowser1.Navigate(URLEdit.Text);
end;

procedure TForm2.PrintBtnClick(Sender: TObject);
var
  ps: TAdvWebBrowserPrintSettings;
begin
  ps := AdvWebBrowser1.InitialPrintSettings;
  ps.PrintHeaderAndFooter := False;
  ps.Orientation := poLandscape;
  AdvWebBrowser1.Print(ps);
end;

procedure TForm2.PrintToPDFBtnClick(Sender: TObject);
begin
  AdvWebBrowser1.PrintToPDF(GetCurrentDir + '/test.pdf');
end;

procedure TForm2.PrintToPDFStreamBtnClick(Sender: TObject);
begin
  AdvWebBrowser1.PrintToPDFStream;
end;

procedure TForm2.PrintUIBtnClick(Sender: TObject);
begin
  AdvWebBrowser1.ShowPrintUI;
end;

procedure TForm2.AdvWebBrowser1GetPrintPDFStream(Sender: TObject; AStream: TMemoryStream);
begin
  if Assigned(AStream) then
    AStream.SaveToFile('PDFStream.pdf');
end;

end.