unit UDownloadManagerDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AdvCustomControl, AdvWebBrowser, AdvUtils;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    NavBtn: TButton;
    NavEdit: TEdit;
    Splitter1: TSplitter;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    ListBox1: TListBox;
    Button2: TButton;
    Button3: TButton;
    Panel3: TPanel;
    SilentCheck: TCheckBox;
    DownloadList: TListBox;
    CancelBtn: TButton;
    ResumeBtn: TButton;
    PauseBtn: TButton;
    AdvWebBrowser1: TAdvWebBrowser;
    DestEdit: TEdit;
    procedure NavBtnClick(Sender: TObject);
    procedure PauseBtnClick(Sender: TObject);
    procedure ResumeBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AdvWebBrowser1DownloadStarted(Sender: TObject;
      ADownload: TAdvWebBrowserDownload; var ASilent, APause, AResume,
      ACancel: Boolean);
    procedure AdvWebBrowser1DownloadBytesReceivedChanged(Sender: TObject;
      ADownload: TAdvWebBrowserDownload; ABytesReceived: Int64; var APause,
      AResume, ACancel: Boolean);
    procedure AdvWebBrowser1DownloadStateChanged(Sender: TObject;
      ADownload: TAdvWebBrowserDownload;
      AState: TAdvWebBrowserDownloadState; var APause, AResume,
      ACancel: Boolean);
    procedure DownloadListClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateDownloadList;
    procedure UpdateButtons;
    function ExtractURLFileName(AFileName: string): string;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.CancelBtnClick(Sender: TObject);
var
  d: TAdvWebBrowserDownload;
begin
  if (DownloadList.ItemIndex >= 0) and (DownloadList.ItemIndex < AdvWebBrowser1.Downloads.Count) then
  begin
    d := TAdvWebBrowserDownload(DownloadList.Items.Objects[DownloadList.ItemIndex]);

    d.Cancel;
  end;
end;

procedure TForm3.DownloadListClick(Sender: TObject);
begin
  UpdateDownloadList;
end;

function TForm3.ExtractURLFileName(AFileName: string): string;
var
  FilN,fn, ext: string;
  slPos, extPos: Integer;
begin
  FilN := AFileName;
  Result := '';
  if FilN.Contains('://') then
  begin
    slPos := FilN.LastIndexOf('/') + 1;
    fn := AFileName.Substring(slPos);
    ext := ExtractFileExt(fn);

    if ext.IndexOfAny(['?','&',',','%',' ']) > 0 then
      ext := ext.Substring(0, ext.IndexOfAny(['?','&',',','%',' ']));

    extPos := fn.IndexOf(ext)+ Length(ext);
    Result := fn.Substring(0, extPos);
  end
  else
  begin
    fn := ExtractFileName(FilN);
    if ExtractFileExt(fn) <> '' then
    begin
      Result := fn;
    end;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  PauseBtn.Enabled := False;
  ResumeBtn.Enabled := False;
  CancelBtn.Enabled := False;
end;

procedure TForm3.NavBtnClick(Sender: TObject);
begin
  AdvWebBrowser1.Navigate(NavEdit.Text);
end;

procedure TForm3.PauseBtnClick(Sender: TObject);
var
  d: TAdvWebBrowserDownload;
begin
  if (DownloadList.ItemIndex >= 0) and (DownloadList.ItemIndex < AdvWebBrowser1.Downloads.Count) then
  begin
    d := TAdvWebBrowserDownload(DownloadList.Items.Objects[DownloadList.ItemIndex]);

    d.Pause;
  end;
end;

procedure TForm3.ResumeBtnClick(Sender: TObject);
var
  d: TAdvWebBrowserDownload;
begin
  if (DownloadList.ItemIndex >= 0) and (DownloadList.ItemIndex < AdvWebBrowser1.Downloads.Count) then
  begin
    d := TAdvWebBrowserDownload(DownloadList.Items.Objects[DownloadList.ItemIndex]);

    d.Resume;
  end;
end;

procedure TForm3.AdvWebBrowser1DownloadBytesReceivedChanged(
  Sender: TObject; ADownload: TAdvWebBrowserDownload; ABytesReceived: Int64;
  var APause, AResume, ACancel: Boolean);
begin
  UpdateDownloadList;
end;

procedure TForm3.AdvWebBrowser1DownloadStarted(Sender: TObject; ADownload: TAdvWebBrowserDownload; var ASilent, APause, AResume, ACancel: Boolean);
var
  dir: string;
begin
  ASilent := SilentCheck.Checked;

  if DestEdit.Text <> '' then
  begin
    dir := DestEdit.Text;
    if dir[Length(dir)] <> '\' then
      dir := dir + '\';
    ADownload.ResultFilePath := dir + ExtractFileName(ADownload.ResultFilePath);
  end;

  UpdateDownloadList;
end;

procedure TForm3.AdvWebBrowser1DownloadStateChanged(Sender: TObject;
  ADownload: TAdvWebBrowserDownload; AState: TAdvWebBrowserDownloadState;
  var APause, AResume, ACancel: Boolean);
begin
  UpdateDownloadList;
end;

procedure TForm3.UpdateButtons;
var
  d: TAdvWebBrowserDownload;
  p,r,c: Boolean;
begin
  p := False;
  r := False;
  c := False;

  if (DownloadList.ItemIndex >= 0) and (DownloadList.ItemIndex < AdvWebBrowser1.Downloads.Count) then
  begin
    d := TAdvWebBrowserDownload(DownloadList.Items.Objects[DownloadList.ItemIndex]);

    if d.State = dsInProgress then
    begin
      p := True;
      c := True;
    end
    else if (d.State = dsInterrupted) then
    begin
      if d.CanResume then
        r := True;
      c := True;
    end;
  end;

  PauseBtn.Enabled := p;
  ResumeBtn.Enabled := r;
  CancelBtn.Enabled := c;
end;

procedure TForm3.UpdateDownloadList;
var
  I, idx: Integer;
  s: string;
begin
  idx := DownloadList.ItemIndex;
  DownloadList.Items.Clear;

  for I := AdvWebBrowser1.Downloads.Count - 1 downto 0 do
  begin
    if AdvWebBrowser1.Downloads[I].State = dsInterrupted then
      s:= ExtractURLFileName(AdvWebBrowser1.Downloads[I].URI) + ': ' + AdvWebBrowser1.GetDownloadInterruptReasonText(AdvWebBrowser1.Downloads[I].InterruptReason)
    else
      s:= ExtractURLFileName(AdvWebBrowser1.Downloads[I].URI) + ': ' + AdvWebBrowser1.GetDownloadStateText(AdvWebBrowser1.Downloads[I].State) + ' (' + IntToStr(AdvWebBrowser1.Downloads[I].BytesReceived) + '/' + IntToStr(AdvWebBrowser1.Downloads[I].TotalBytes) + ')';

    DownloadList.Items.AddObject(s, AdvWebBrowser1.Downloads.Items[I]);
  end;

  DownloadList.ItemIndex := idx;
  UpdateButtons;
end;

end.
