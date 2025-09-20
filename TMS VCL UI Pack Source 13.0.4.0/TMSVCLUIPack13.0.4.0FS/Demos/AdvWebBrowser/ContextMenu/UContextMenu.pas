unit UContextMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, AdvUtils, AdvCustomControl,
  AdvGraphics, AdvGraphicsTypes, AdvWebBrowser, Generics.Collections;

type
  TForm2 = class(TForm)
    URLEdit: TEdit;
    NavigationBtn: TButton;
    Label1: TLabel;
    SelectedMemo: TMemo;
    NativeRadio: TRadioButton;
    NormalRadio: TRadioButton;
    DefaultRadio: TRadioButton;
    CustomRadio: TRadioButton;
    ContextMenu: TPopupMenu;
    Youtube1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Light1: TMenuItem;
    Light2: TMenuItem;
    AdvWebBrowser1: TAdvWebBrowser;
    procedure Youtube1Click(Sender: TObject);
    procedure DefaultRadioClick(Sender: TObject);
    procedure NativeRadioClick(Sender: TObject);
    procedure NormalRadioClick(Sender: TObject);
    procedure CustomRadioClick(Sender: TObject);
    procedure AdvWebBrowser1CustomContextMenuItemSelected(Sender: TObject;
      ASelectedItem: TAdvWebBrowserCustomContextMenuItem);
    procedure AdvWebBrowser1GetContextMenu(Sender: TObject;
      ATarget: TAdvWebBrowserTargetItem;
      AContextMenu: TObjectList<AdvWebBrowser.TAdvWebBrowserContextMenuItem>);
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

procedure TForm2.AdvWebBrowser1CustomContextMenuItemSelected(Sender: TObject; ASelectedItem: TAdvWebBrowserCustomContextMenuItem);
var
  s: string;
begin
  if (ASelectedItem.DataInteger > 0) or Assigned(AdvWebBrowser1.PopupMenu) then
  begin
    s := ASelectedItem.Name;
    if Assigned(ASelectedItem.ParentItem) then
      s := s + ' (' + ASelectedItem.ParentItem.AsCustom.Name + ')';
    SelectedMemo.Lines.Add(s);

    if ASelectedItem.AsCustom.Name = 'Go to TMS' then
    begin
      AdvWebBrowser1.Navigate('https://www.tmssoftware.com');
    end;
  end;
end;

procedure TForm2.AdvWebBrowser1GetContextMenu(Sender: TObject;
  ATarget: TAdvWebBrowserTargetItem;
  AContextMenu: TObjectList<AdvWebBrowser.TAdvWebBrowserContextMenuItem>);
var
  I: Integer;
  mi: TAdvWebBrowserCustomContextMenuItem;
begin
  if ATarget.SelectionText <> '' then
    SelectedMemo.Lines.Add('Selected Text: ' + ATarget.SelectionText);

  if CustomRadio.Checked then
  begin
    I := 0;

    while I < AContextMenu.Count do
    begin
      if AContextMenu[I].AsSystem.Name.ToLower <> 'reload' then
      begin
        AContextMenu.Delete(I);
      end
      else
        Inc(I);
    end;

    mi := TAdvWebBrowserCustomContextMenuItem.Create;
    mi.Name := 'Go to TMS';
    mi.DataInteger := 1;

    AContextMenu.Add(mi);
  end;
end;

procedure TForm2.AdvWebBrowser1Initialized(Sender: TObject);
begin
  if Pos('http', AdvWebBrowser1.URL) > 0 then
    URLEdit.Text := AdvWebBrowser1.URL;
end;

procedure TForm2.CustomRadioClick(Sender: TObject);
begin
  if CustomRadio.Checked then
  begin
    DefaultRadio.Checked := False;
    NativeRadio.Checked := False;
    NormalRadio.Checked := False;

    AdvWebBrowser1.PopupMenu := nil;
  end;
end;

procedure TForm2.DefaultRadioClick(Sender: TObject);
begin
  if DefaultRadio.Checked then
  begin
    NativeRadio.Checked := False;
    NormalRadio.Checked := False;
    CustomRadio.Checked := False;

    AdvWebBrowser1.PopupMenu := ContextMenu;
    AdvWebBrowser1.Settings.UsePopupMenuAsContextMenu := False;
  end;
end;

procedure TForm2.NativeRadioClick(Sender: TObject);
begin
  if NativeRadio.Checked then
  begin
    DefaultRadio.Checked := False;
    NormalRadio.Checked := False;
    CustomRadio.Checked := False;

    AdvWebBrowser1.PopupMenu := ContextMenu;
    AdvWebBrowser1.Settings.UsePopupMenuAsContextMenu := True;
  end;
end;

procedure TForm2.NormalRadioClick(Sender: TObject);
begin
  if NormalRadio.Checked then
  begin
    DefaultRadio.Checked := False;
    NativeRadio.Checked := False;
    CustomRadio.Checked := False;

    AdvWebBrowser1.PopupMenu := nil;
  end;
end;

procedure TForm2.Youtube1Click(Sender: TObject);
begin
  TAdvUtils.OpenURL('https://www.youtube.com/@tmssoftwareTV')
end;

end.
