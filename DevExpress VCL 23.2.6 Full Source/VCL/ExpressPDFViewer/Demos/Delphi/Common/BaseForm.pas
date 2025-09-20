unit BaseForm;

{$I cxVer.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls,
{$IFDEF EXPRESSBARS}
  dxBar, dxStatusBar,
{$ENDIF}
  SkinDemoUtils, dxForms,
  dxCore, cxClasses, cxStyles, cxLookAndFeels, cxGeometry, dxPDFViewer, cxGraphics, cxControls, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, dxShellDialogs, dxLayoutContainer, dxLayoutControl, dxLayoutLookAndFeels;

type
  TfmBaseForm = class(TdxForm)
    miAbout: TMenuItem;
    miExit: TMenuItem;
    miFile: TMenuItem;
    mmMain: TMainMenu;
    lbDescription: TLabel;
    SaveDialog: TdxSaveFileDialog;
    OpenDialog: TdxOpenFileDialog;
    lcMainGroup_Root: TdxLayoutGroup;
    lcMain: TdxLayoutControl;
    liDescription: TdxLayoutItem;
    lgContent: TdxLayoutGroup;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    cxLookAndFeelController1: TcxLookAndFeelController;

    procedure miAboutClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
  private
    FLookAndFeel: TcxLookAndFeel;
    procedure CreateSkinsMenuItem;
  protected
    function CanUseStyleSheet: Boolean;
    function GetMenuItemChecked(AMenuItem: TObject): Boolean;
    procedure LookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues); virtual;
    procedure TouchModeClick(Sender: TObject);
    //
    function FindMenuItem(const AMenuItemName: string; out AItem: TdxBaseMenuItem): Boolean;
    procedure MenuItemCheckSubItemWithTag(const AMenuItemName: string; ATag: Integer);
    procedure MenuItemSetChecked(const AMenuItemName: string; AChecked: Boolean); overload;
    procedure MenuItemSetChecked(Sender: TObject; AChecked: Boolean); overload;
    procedure MenuItemSetEnabled(const AMenuItemName: string; AEnabled: Boolean); overload;
    procedure MenuItemSetEnabled(Sender: TObject; AEnabled: Boolean); overload;
    procedure MenuItemSetVisible(const AMenuItemName: string; AVisible: Boolean); overload;
    procedure MenuItemSetVisible(Sender: TObject; AVisible: Boolean); overload;
  public
  {$IFDEF EXPRESSBARS}
    BarManager: TdxBarManager;
  {$ENDIF}
    procedure AfterConstruction; override;
    destructor Destroy; override;
    procedure CreateTouchModeMenuOption;
    procedure PlaceControls; virtual;
  end;

var
  fmBaseForm: TfmBaseForm;

implementation

{$R *.dfm}

uses
  Types, dxGDIPlusAPI, AboutDemoForm;

{ TfmBaseForm }

procedure TfmBaseForm.AfterConstruction;
{$IFDEF EXPRESSBARS}
  procedure StatusBarPanelAssign(ADXPanel: TdxStatusBarPanel; APanel: TStatusPanel);
  begin
    ADXPanel.Width := APanel.Width;
  end;
{$ENDIF}
begin
  inherited;
  FLookAndFeel := TcxLookAndFeel.Create(nil);
  FLookAndFeel.OnChanged := LookAndFeelChanged;
{$IFDEF EXPRESSBARS}
  BarManager := TdxBarManager.Create(Self);
  dxBarConvertMainMenu(mmMain, BarManager);
  BarManager.Style := bmsUseLookAndFeel;
{$ENDIF}
  PlaceControls;
  CreateSkinsMenuItem;
  CreateTouchModeMenuOption;
  OpenDialog.Filter := 'PDF Files (*.pdf)|*.pdf';
  SaveDialog.Filter := 'PDF Files (*.pdf)|*.pdf';
end;

destructor TfmBaseForm.Destroy;
begin
  FreeAndNil(FLookAndFeel);
  inherited Destroy;
end;

procedure TfmBaseForm.miAboutClick(Sender: TObject);
begin
  ShowAboutDemoForm;
end;

procedure TfmBaseForm.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmBaseForm.CreateSkinsMenuItem;
begin
{$IFDEF EXPRESSBARS}
  SkinDemoUtils.CreateSkinsMenuItem(BarManager);
{$ELSE}
  SkinDemoUtils.CreateSkinsMenuItem(mmMain);
{$ENDIF}
end;

{$IFDEF EXPRESSBARS}
function TfmBaseForm.FindMenuItem(const AMenuItemName: string; out AItem: TdxBaseMenuItem): Boolean;
begin
  Result := SkinDemoUtils.FindMenuItem(BarManager, AMenuItemName, AItem);
end;
{$ELSE}

function TfmBaseForm.FindMenuItem(const AMenuItemName: string; out AItem: TdxBaseMenuItem): Boolean;
begin
  Result := SkinDemoUtils.FindMenuItem(mmMain, AMenuItemName, AItem);
end;

{$ENDIF}

procedure TfmBaseForm.CreateTouchModeMenuOption;
var
  AItem: TdxBaseMenuItem;
{$IFDEF EXPRESSBARS}
  ABarButton: TdxBarButton;
{$ELSE}
  AMenuItem: TMenuItem;
{$ENDIF}
begin
  if FindMenuItem('miOptions', AItem) then
  begin
{$IFDEF EXPRESSBARS}
    ABarButton := BarManager.AddButton;
    (AItem as TdxBarSubItem).ItemLinks.Add(ABarButton);
    ABarButton.Caption := 'Touch Mode';
    ABarButton.ButtonStyle := bsChecked;
    ABarButton.Name := 'miTouchMode';
    ABarButton.Down := cxIsTouchModeEnabled;
    ABarButton.OnClick := TouchModeClick;
{$ELSE}
    AMenuItem := TMenuItem.Create(AItem as TMenuItem);
    (AItem as TMenuItem).Add(AMenuItem);
    AMenuItem.Caption := 'Touch Mode';
    AMenuItem.Name := 'miTouchMode';
    AMenuItem.AutoCheck := True;
    AMenuItem.Checked := cxIsTouchModeEnabled;
    AMenuItem.OnClick := TouchModeClick;
{$ENDIF}
  end;
end;

procedure TfmBaseForm.PlaceControls;
begin
{$IFDEF EXPRESSBARS}
  BarManager.MainMenuControl.DockControl.Top := 0;
{$ENDIF}
end;

function TfmBaseForm.CanUseStyleSheet: Boolean;
begin
  Result := FLookAndFeel.SkinPainter = nil;
end;

function TfmBaseForm.GetMenuItemChecked(AMenuItem: TObject): Boolean;
begin
{$IFDEF EXPRESSBARS}
  if AMenuItem is TdxBarButton then
    Result := TdxBarButton(AMenuItem).Down
  else
{$ENDIF}
   Result := (AMenuItem as TMenuItem).Checked;
end;

procedure TfmBaseForm.LookAndFeelChanged(
  Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  MenuItemSetChecked('miTouchMode', cxIsTouchModeEnabled);
end;

procedure TfmBaseForm.TouchModeClick(Sender: TObject);
begin
  cxLookAndFeelController1.TouchMode := GetMenuItemChecked(Sender);
end;

procedure TfmBaseForm.MenuItemCheckSubItemWithTag(const AMenuItemName: string; ATag: Integer);
var
  AMenuItem: TdxBaseMenuItem;
{$IFDEF EXPRESSBARS}
  ASubMenuItem: TdxBarSubItem;
{$ENDIF}
  I: Integer;
begin
  if FindMenuItem(AMenuItemName, AMenuItem) then
  begin
  {$IFDEF EXPRESSBARS}
    ASubMenuItem := AMenuItem as TdxBarSubItem;
    for I := 0 to ASubMenuItem.ItemLinks.Count - 1 do
    begin
      with ASubMenuItem.ItemLinks[I] do
        MenuItemSetChecked(Item, Item.Tag = ATag);
    end;
  {$ELSE}
    for I := 0 to AMenuItem.Count - 1 do
      AMenuItem.Items[I].Checked := AMenuItem.Items[I].Tag = ATag;
  {$ENDIF}
  end;
end;

procedure TfmBaseForm.MenuItemSetChecked(const AMenuItemName: string; AChecked: Boolean);
var
  AMenuItem: TdxBaseMenuItem;
begin
  if FindMenuItem(AMenuItemName, AMenuItem) then
    SetMenuItemChecked(AMenuItem, AChecked);
end;

procedure TfmBaseForm.MenuItemSetChecked(Sender: TObject; AChecked: Boolean);
begin
  SetMenuItemChecked(Sender, AChecked);
end;

procedure TfmBaseForm.MenuItemSetEnabled(Sender: TObject; AEnabled: Boolean);
begin
  SetMenuItemEnable(Sender, AEnabled);
end;

procedure TfmBaseForm.MenuItemSetEnabled(const AMenuItemName: string; AEnabled: Boolean);
var
  AMenuItem: TdxBaseMenuItem;
begin
  if FindMenuItem(AMenuItemName, AMenuItem) then
    AMenuItem.Enabled := AEnabled;
end;

procedure TfmBaseForm.MenuItemSetVisible(const AMenuItemName: string; AVisible: Boolean);
var
  AMenuItem: TdxBaseMenuItem;
begin
  if FindMenuItem(AMenuItemName, AMenuItem) then
    SetMenuItemVisible(AMenuItem, AVisible);
end;

procedure TfmBaseForm.MenuItemSetVisible(Sender: TObject; AVisible: Boolean);
begin
  SetMenuItemVisible(Sender, AVisible);
end;

end.
