unit ListViewDemoMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxClasses, BaseForm, dxLayoutContainer,
  dxLayoutControl, Menus, StdCtrls, dxListView, 
  ImgList, dxCore, cxImageList, dxLayoutLookAndFeels;

type
  TfmListViewDemo = class(TfmBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutItem1: TdxLayoutItem;
    LV: TdxListViewControl;
    ilLargeCars: TcxImageList;
    LVGroup1: TdxListGroup;
    LVGroup2: TdxListGroup;
    LVGroup3: TdxListGroup;
    LVGroup4: TdxListGroup;
    LVGroup5: TdxListGroup;
    LVGroup6: TdxListGroup;
    LVGroup7: TdxListGroup;
    LVGroup8: TdxListGroup;
    LVGroup9: TdxListGroup;
    LVGroup10: TdxListGroup;
    LVGroup11: TdxListGroup;
    LVGroup12: TdxListGroup;
    LVGroup13: TdxListGroup;
    LVGroup14: TdxListGroup;
    LVGroup15: TdxListGroup;
    LVGroup16: TdxListGroup;
    LVGroup17: TdxListGroup;
    LVGroup18: TdxListGroup;
    LVGroup19: TdxListGroup;
    dxLayoutGroup1: TdxLayoutGroup;
    ilSmallCars: TcxImageList;
    liMultiSelect: TdxLayoutCheckBoxItem;
    lgViewStyles: TdxLayoutGroup;
    liIcons: TdxLayoutRadioButtonItem;
    liList: TdxLayoutRadioButtonItem;
    liReport: TdxLayoutRadioButtonItem;
    liSmallIcon: TdxLayoutRadioButtonItem;
    liGroupView: TdxLayoutCheckBoxItem;
    liCheckboxes: TdxLayoutCheckBoxItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
    lgItemsArrangement: TdxLayoutGroup;
    liHorizontal: TdxLayoutRadioButtonItem;
    liVertical: TdxLayoutRadioButtonItem;
    liExplorerStyle: TdxLayoutCheckBoxItem;
    dxLayoutGroup2: TdxLayoutGroup;
    liGDI: TdxLayoutRadioButtonItem;
    liGDIPlus: TdxLayoutRadioButtonItem;
    liDirectX: TdxLayoutRadioButtonItem;
    procedure liCheckboxesClick(Sender: TObject);
    procedure liGroupViewClick(Sender: TObject);
    procedure liMultiSelectClick(Sender: TObject);
    procedure liViewStyleClick(Sender: TObject);
    procedure liArrangementClick(Sender: TObject);
    procedure liExplorerStyleClick(Sender: TObject);
    procedure LVInfoTip(Sender: TdxCustomListView; AItem: TdxListItem;
      var AInfoTip: string);
    procedure OnRenderModeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmListViewDemo: TfmListViewDemo;

implementation


{$R *.dfm}

procedure TfmListViewDemo.liCheckboxesClick(Sender: TObject);
begin
  LV.Checkboxes := liCheckboxes.Checked;
end;

procedure TfmListViewDemo.liExplorerStyleClick(Sender: TObject);
begin
  LV.ExplorerStyle := liExplorerStyle.Checked;
end;

procedure TfmListViewDemo.liGroupViewClick(Sender: TObject);
begin
  LV.GroupView := liGroupView.Checked;
end;

procedure TfmListViewDemo.OnRenderModeClick(Sender: TObject);
var
  AItem: TdxLayoutRadioButtonItem;
begin
  AItem := Safe<TdxLayoutRadioButtonItem>.Cast(Sender);
  if AItem <> nil then
  begin
    ShowHourglassCursor;
    try
      case AItem.Tag of
        0: LV.LookAndFeel.RenderMode := rmGDI;
        1: LV.LookAndFeel.RenderMode := rmGDIPlus;
        2: LV.LookAndFeel.RenderMode := rmDirectX;
      end;
    finally
      HideHourglassCursor;
    end;
  end;
end;

procedure TfmListViewDemo.liArrangementClick(Sender: TObject);
var
  AItem: TdxLayoutRadioButtonItem;
begin
  AItem := Safe<TdxLayoutRadioButtonItem>.Cast(Sender);
  if AItem <> nil then
  begin
    case AItem.Tag of
      0:
        begin
          LV.ViewStyleIcon.Arrangement := TdxListIconsArrangement.Horizontal;
          LV.ViewStyleSmallIcon.Arrangement := TdxListIconsArrangement.Horizontal;
        end;
      1:
        begin
          LV.ViewStyleIcon.Arrangement := TdxListIconsArrangement.Vertical;
          LV.ViewStyleSmallIcon.Arrangement := TdxListIconsArrangement.Vertical;
        end;
    end;
  end;
end;

procedure TfmListViewDemo.liMultiSelectClick(Sender: TObject);
begin
  LV.MultiSelect := liMultiSelect.Checked;
end;

procedure TfmListViewDemo.liViewStyleClick(Sender: TObject);
var
  AItem: TdxLayoutRadioButtonItem;
begin
  AItem := Safe<TdxLayoutRadioButtonItem>.Cast(Sender);
  if AItem <> nil then
  begin
    case AItem.Tag of
      0: LV.ViewStyle := TdxListViewStyle.Icon;
      1: LV.ViewStyle := TdxListViewStyle.SmallIcon;
      2: LV.ViewStyle := TdxListViewStyle.List;
      3: LV.ViewStyle := TdxListViewStyle.Report;
    end;
    lgItemsArrangement.Enabled := AItem.Tag in [0, 1];
  end;
end;

procedure TfmListViewDemo.LVInfoTip(Sender: TdxCustomListView;
  AItem: TdxListItem; var AInfoTip: string);
begin
  AInfoTip := Format('Trademark: %s'#13#10'Model: %s', [AItem.Caption, AItem.SubItems[0]]);
end;

end.
