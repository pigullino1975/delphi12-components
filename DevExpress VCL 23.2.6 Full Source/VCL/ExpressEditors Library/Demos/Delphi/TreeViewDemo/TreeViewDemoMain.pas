unit TreeViewDemoMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,Controls, Forms, Dialogs, ComCtrls, Menus, StdCtrls,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxClasses, dxLayoutContainer, dxLayoutControl,
  dxLayoutcxEditAdapters, cxCheckBox, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCheckComboBox,
  dxtree, dxTreeView, cxSpinEdit, dxLayoutControlAdapters, cxButtons, cxMemo, dxForms, Math, BaseForm,
  dxLayoutLookAndFeels;

type
  TdxTreeViewDemoAction = (tdaAdd, tdaClear, tdaExpand, tdaCollapse);

  TfmTreeViewDemo = class(TfmBaseForm)
    lcMainGroup_Root: TdxLayoutGroup;
    lcMain: TdxLayoutControl;
    dxNewTreeView: TdxTreeViewControl;
    lidxNewTreeView: TdxLayoutItem;
    seFirstLevelNodeCount: TcxSpinEdit;
    liseAddCount: TdxLayoutItem;
    btnTreeViewAdd: TcxButton;
    liTreeViewAdd: TdxLayoutItem;
    btnTreeViewClear: TcxButton;
    liTreeViewClear: TdxLayoutItem;
    lgTreeViews: TdxLayoutGroup;
    lgLog: TdxLayoutGroup;
    mLog: TcxMemo;
    limLog: TdxLayoutItem;
    dxLayoutItem1: TdxLayoutItem;
    seDepth: TcxSpinEdit;
    liNodesCount: TdxLayoutLabeledItem;
    lgdxTreeViewControl: TdxLayoutGroup;
    lgTreeView: TdxLayoutGroup;
    dxLayoutGroup3: TdxLayoutGroup;
    liTreeViewExpand: TdxLayoutItem;
    btnTreeViewFullExpand: TcxButton;
    liTreeViewCollapse: TdxLayoutItem;
    btnTreeViewFullCollapse: TcxButton;
    liChildrenCount: TdxLayoutItem;
    seChildrenCount: TcxSpinEdit;
    dxLayoutGroup5: TdxLayoutGroup;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    lidxTreeViewClear: TdxLayoutItem;
    btndxTreeViewClear: TcxButton;
    lidxTreeViewAdd: TdxLayoutItem;
    btndxTreeViewAdd: TcxButton;
    lidxTreeViewExpand: TdxLayoutItem;
    btndxTreeViewFullExpand: TcxButton;
    lidxTreeViewCollapse: TdxLayoutItem;
    btndxTreeViewFullCollapse: TcxButton;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
    TreeView: TTreeView;
    liTreeView: TdxLayoutItem;
    lidxTreeViewNodeCount: TdxLayoutLabeledItem;
    liTreeViewNodeCount: TdxLayoutLabeledItem;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    procedure FormCreate(Sender: TObject);
    procedure lgLogButton0Click(Sender: TObject);
    procedure seDepthPropertiesChange(Sender: TObject);
    procedure btnTreeViewAddClick(Sender: TObject);
    procedure btnTreeViewClearClick(Sender: TObject);
    procedure btnTreeViewFullCollapseClick(Sender: TObject);
    procedure btnTreeViewFullExpandClick(Sender: TObject);
    procedure btndxTreeViewAddClick(Sender: TObject);
    procedure btndxTreeViewClearClick(Sender: TObject);
    procedure btndxTreeViewFullCollapseClick(Sender: TObject);
    procedure btndxTreeViewFullExpandClick(Sender: TObject);
  private
    FLevelCount: Integer;
    FNodesCount: Int64;
    FTopLevelNodesCount: Integer;
    FTickCount: Cardinal;

    procedure DoTreeViewOperation(AProc: TProc; AAction: TdxTreeViewDemoAction);
    procedure DodxTreeViewControlOperation(AProc: TProc; AAction: TdxTreeViewDemoAction);

    procedure AdddxTreeViewNodes;
    procedure AdddxTreeViewChildren(AParent: TdxTreeViewNode);
    procedure AddTreeViewNodes;
    procedure AddTreeViewChildren(AParent: TTreeNode);
    procedure ClearTreeViewNodes;
    procedure CleardxTreeViewNodes;
    procedure CollapseTreeViewNodes;
    procedure CollapsedxTreeViewNodes;
    procedure ExpandTreeViewNodes;
    procedure ExpanddxTreeViewNodes;
    function GetdxTreeViewNodeCountText(AAction: TdxTreeViewDemoAction): string;
    function GetTreeViewNodeCountText(AAction: TdxTreeViewDemoAction): string;
    procedure SettingsChanged;
    procedure RefreshTreeViewActions;
    procedure RefreshdxTreeViewActions;

    procedure BeginTimeCalculation(const AMsg: string);
    procedure EndTimeCalculation(const AMsg: string);

    function GetActionDescription(AAction: TdxTreeViewDemoAction): string;
    function GetStartActionDescription(AAction: TdxTreeViewDemoAction): string;
  public
    { Public declarations }
  end;

var
  fmTreeViewDemo: TfmTreeViewDemo;

implementation

uses
  StrUtils, dxCustomTree, dxCore;

{$R *.dfm}

const
  SAdd = 'Added %s nodes to';
  SClear = 'Removed %s nodes from';
  SExpand = 'Expanded %s nodes in';
  SCollapse = 'Collapsed %s nodes in';

  SStartAdd = 'add nodes to';
  SStartClear = 'remove all nodes from';
  SStartExpand = 'expand all nodes in';
  SStartCollapse = 'collapse all nodes in';

  SNodesCountToAdd = 'Nodes to Add: %s';
  SNodesCount = 'Node Count: %s';

procedure TfmTreeViewDemo.FormCreate(Sender: TObject);
begin
  SettingsChanged;
  RefreshTreeViewActions;
  RefreshdxTreeViewActions;
end;

function TfmTreeViewDemo.GetActionDescription(AAction: TdxTreeViewDemoAction): string;
begin
  case AAction of
    tdaCollapse: Result := SCollapse;
    tdaClear: Result := SClear;
    tdaExpand: Result := SExpand
  else // tdaAdd
    Result := SAdd;
  end;
end;

function TfmTreeViewDemo.GetdxTreeViewNodeCountText(AAction: TdxTreeViewDemoAction): string;
begin
  Result := FormatFloat('#,###0', IfThen(AAction = tdaAdd, FNodesCount, dxNewTreeView.AbsoluteCount));
end;

function TfmTreeViewDemo.GetStartActionDescription(AAction: TdxTreeViewDemoAction): string;
begin
  case AAction of
    tdaCollapse: Result := SStartCollapse;
    tdaClear: Result := SStartClear;
    tdaExpand: Result := SStartExpand
  else // tdaAdd
    Result := SStartAdd;
  end;
end;

function TfmTreeViewDemo.GetTreeViewNodeCountText(AAction: TdxTreeViewDemoAction): string;
begin
  Result := FormatFloat('#,###0', IfThen(AAction = tdaAdd, FNodesCount, TreeView.Items.Count));
end;

procedure TfmTreeViewDemo.SettingsChanged;
var
  I: Integer;
begin
  FNodesCount := 0;
  FLevelCount := seDepth.Value;
  FTopLevelNodesCount := seFirstLevelNodeCount.Value;
  for I := 0 to FLevelCount - 1 do
    FNodesCount := FNodesCount + FTopLevelNodesCount * Round(Power(seChildrenCount.Value, I));
  liNodesCount.CaptionOptions.Text := Format(SNodesCountToAdd, [FormatFloat('#,###', FNodesCount)]);
end;

procedure TfmTreeViewDemo.AddTreeViewChildren(AParent: TTreeNode);
var
  I: Integer;
  ANode: TTreeNode;
begin
  if AParent.Level >= FLevelCount - 1 then
    Exit;
  for I := 0 to seChildrenCount.Value - 1 do
  begin
    ANode := TreeView.Items.AddChild(AParent, Format('%s%d', [AParent.Text, I]));
    AddTreeViewChildren(ANode);
  end;
end;

procedure TfmTreeViewDemo.AddTreeViewNodes;
var
  I: Integer;
  ANode: TTreeNode;
begin
  for I := 0 to FTopLevelNodesCount - 1 do
  begin
    ANode := TreeView.Items.Add(nil, Format('%d', [I]));
    AddTreeViewChildren(ANode);
  end;
end;

procedure TfmTreeViewDemo.AdddxTreeViewNodes;
var
  I: Integer;
  ANode: TdxTreeViewNode;
begin
  for I := 0 to FTopLevelNodesCount - 1 do
  begin
    ANode := dxNewTreeView.Items.Add(nil, Format('%d', [I]));
    AdddxTreeViewChildren(ANode);
  end;
end;

procedure TfmTreeViewDemo.AdddxTreeViewChildren(AParent: TdxTreeViewNode);
var
  I: Integer;
  ANode: TdxTreeViewNode;
begin
  if AParent.Level >= FLevelCount - 1 then
    Exit;
  for I := 0 to seChildrenCount.Value - 1 do
  begin
    ANode := dxNewTreeView.Items.AddChild(AParent, Format('%s%d', [AParent.Caption, I]));
    AdddxTreeViewChildren(ANode);
  end;
end;

procedure TfmTreeViewDemo.ClearTreeViewNodes;
begin
  TreeView.Items.Clear;
end;

procedure TfmTreeViewDemo.CleardxTreeViewNodes;
begin
  dxNewTreeView.Root.Clear;
end;

procedure TfmTreeViewDemo.CollapseTreeViewNodes;
begin
  TreeView.FullCollapse;
end;

procedure TfmTreeViewDemo.CollapsedxTreeViewNodes;
begin
  dxNewTreeView.FullCollapse;
end;

procedure TfmTreeViewDemo.DoTreeViewOperation(AProc: TProc; AAction: TdxTreeViewDemoAction);
var
  AEndDescription: string;
begin
  AEndDescription := Format(GetActionDescription(AAction), [GetTreeViewNodeCountText(AAction)]);
  BeginTimeCalculation(Format('%s TTreeView', [GetStartActionDescription(AAction)]));
  TreeView.Items.BeginUpdate;
  try
    AProc;
  finally
    TreeView.Items.EndUpdate;
    EndTimeCalculation(Format('%s TTreeView', [AEndDescription]));
    RefreshTreeViewActions;
  end;
end;

procedure TfmTreeViewDemo.DodxTreeViewControlOperation(AProc: TProc; AAction: TdxTreeViewDemoAction);
var
  AEndDescription: string;
begin
  AEndDescription := Format(GetActionDescription(AAction), [GetdxTreeViewNodeCountText(AAction)]);
  BeginTimeCalculation(Format('%s TdxTreeViewControl', [GetStartActionDescription(AAction)]));
  dxNewTreeView.BeginUpdate;
  try
    AProc;
  finally
    dxNewTreeView.EndUpdate;
    dxNewTreeView.Update;
    EndTimeCalculation(Format('%s TdxTreeViewControl', [AEndDescription]));
    RefreshdxTreeViewActions;
  end;
end;

procedure TfmTreeViewDemo.BeginTimeCalculation(const AMsg: string);
begin
  mLog.Lines.Add(Format('[%s] Starting to %s...', [TimeToStr(Now), AMsg]));
  FTickCount := GetTickCount;
  ShowHourglassCursor;
end;

procedure TfmTreeViewDemo.EndTimeCalculation(const AMsg: string);
begin
  mLog.Lines.Add(Format('[%s] %s. Time taken: %f seconds', [TimeToStr(Now), AMsg, (GetTickCount - FTickCount) / 1000]));
  HideHourglassCursor;
end;

procedure TfmTreeViewDemo.ExpandTreeViewNodes;
begin
  TreeView.FullExpand;
end;

procedure TfmTreeViewDemo.ExpanddxTreeViewNodes;
begin
  dxNewTreeView.FullExpand;
end;

procedure TfmTreeViewDemo.btnTreeViewAddClick(Sender: TObject);
begin
  DoTreeViewOperation(AddTreeViewNodes, tdaAdd);
end;

procedure TfmTreeViewDemo.btnTreeViewClearClick(Sender: TObject);
begin
  DoTreeViewOperation(ClearTreeViewNodes, tdaClear);
end;

procedure TfmTreeViewDemo.btnTreeViewFullCollapseClick(Sender: TObject);
begin
  DoTreeViewOperation(CollapseTreeViewNodes, tdaCollapse);
end;

procedure TfmTreeViewDemo.btnTreeViewFullExpandClick(Sender: TObject);
begin
  DoTreeViewOperation(ExpandTreeViewNodes, tdaExpand);
end;

procedure TfmTreeViewDemo.btndxTreeViewAddClick(Sender: TObject);
begin
  DodxTreeViewControlOperation(AdddxTreeViewNodes, tdaAdd);
end;

procedure TfmTreeViewDemo.btndxTreeViewClearClick(Sender: TObject);
begin
  DodxTreeViewControlOperation(CleardxTreeViewNodes, tdaClear);
end;

procedure TfmTreeViewDemo.btndxTreeViewFullCollapseClick(Sender: TObject);
begin
  DodxTreeViewControlOperation(CollapsedxTreeViewNodes, tdaCollapse);
end;

procedure TfmTreeViewDemo.btndxTreeViewFullExpandClick(Sender: TObject);
begin
  DodxTreeViewControlOperation(ExpanddxTreeViewNodes, tdaExpand);
end;

procedure TfmTreeViewDemo.lgLogButton0Click(Sender: TObject);
begin
  mLog.Lines.Clear;
end;

procedure TfmTreeViewDemo.RefreshTreeViewActions;
begin
  liTreeViewClear.Enabled := TreeView.Items.GetFirstNode <> nil;
  liTreeViewExpand.Enabled := liTreeViewClear.Enabled;
  liTreeViewCollapse.Enabled := liTreeViewClear.Enabled;
  liTreeViewNodeCount.CaptionOptions.Text := Format(SNodesCount, [GetTreeViewNodeCountText(tdaClear)]);
end;

procedure TfmTreeViewDemo.RefreshdxTreeViewActions;
begin
  lidxTreeViewClear.Enabled := dxNewTreeView.Root.First <> nil;
  lidxTreeViewExpand.Enabled := lidxTreeViewClear.Enabled;
  lidxTreeViewCollapse.Enabled := lidxTreeViewClear.Enabled;
  lidxTreeViewNodeCount.CaptionOptions.Text := Format(SNodesCount, [GetdxTreeViewNodeCountText(tdaClear)]);
end;

procedure TfmTreeViewDemo.seDepthPropertiesChange(Sender: TObject);
begin
  SettingsChanged;
end;

end.
