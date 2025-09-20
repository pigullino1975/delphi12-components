unit main;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Types, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, Buttons, Grids, DBGrids, ComCtrls,
  ExtCtrls, DB, Menus, Mask, dxtree, dxdbtree, dxBar, ShellAPI,
  dxBarExtItems, ImgList, dxSkinsCore, dxSkinsdxBarPainter, cxClasses, dxmdaset;

type
  TMainForm = class(TForm)
    DS1: TDataSource;
    Panel2: TPanel;
    DBTreeView: TdxDBTreeView;
    ImageList: TImageList;
    BarManager: TdxBarManager;
    bbExit: TdxBarButton;
    bsFile: TdxBarSubItem;
    bsEdit: TdxBarSubItem;
    bsAddNode: TdxBarButton;
    bbAddChild: TdxBarButton;
    bbRenameNode: TdxBarButton;
    bbDeleteNode: TdxBarButton;
    sbView: TdxBarSubItem;
    bbFullExpand: TdxBarButton;
    bbFullCollaps: TdxBarButton;
    btnCustomDrow: TdxBarButton;
    btnUp: TdxBarButton;
    btnDown: TdxBarButton;
    btnNextLevel: TdxBarButton;
    siOptions: TdxBarSubItem;
    btnDragRoot: TdxBarButton;
    btnDisplayField: TdxBarButton;
    btnAutoDrag: TdxBarButton;
    StatusBar: TStatusBar;
    btnGrid: TdxBarButton;
    miHelp: TdxBarSubItem;
    btnMore: TdxBarButton;
    dxBarPopupMenu: TdxBarPopupMenu;
    DS2: TDataSource;
    btnFind: TdxBarButton;
    cbImage: TdxBarImageCombo;
    T1: TdxMemData;
    T2: TdxMemData;
    T1Pr_id: TAutoIncField;
    T1Pr_parent: TIntegerField;
    T1Pr_name: TStringField;
    T1Pr_bdate: TDateField;
    T1Pr_edate: TDateField;
    T1Image: TSmallintField;
    T2Pr_id: TAutoIncField;
    T2Pr_parent: TIntegerField;
    T2Pr_name: TStringField;
    T2Pr_bdate: TDateField;
    T2Pr_edate: TDateField;
    T2Image: TSmallintField;
    ilBars: TImageList;
    procedure T1Pr_parentChange(Sender: TField);
    procedure DBTreeViewSetDisplayItemText(Sender: TObject;
      var DisplayText: string);
    procedure DBTreeViewDragDropTreeNode(Destination, Source: TTreeNode;
      var Accept: Boolean);
    procedure DBTreeViewCustomDraw(Sender: TObject; TreeNode: TTreeNode;
      AFont: TFont; var AColor, ABKColor: TColor);
    procedure FormCreate(Sender: TObject);
    procedure bsAddNodeClick(Sender: TObject);
    procedure bbAddChildClick(Sender: TObject);
    procedure bbRenameNodeClick(Sender: TObject);
    procedure bbDeleteNodeClick(Sender: TObject);
    procedure bbFullExpandClick(Sender: TObject);
    procedure bbFullCollapsClick(Sender: TObject);
    procedure bbExitClick(Sender: TObject);
    procedure btnCustomDrowClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnDisplayFieldClick(Sender: TObject);
    procedure btnAutoDragClick(Sender: TObject);
    procedure btnGridClick(Sender: TObject);
    procedure DBTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure btnMoreClick(Sender: TObject);
    procedure DBTreeViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBTreeViewGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure btnFindClick(Sender: TObject);
    procedure cbImageChange(Sender: TObject);
    procedure DBTreeViewAddNewItem(Sender: TObject;
      var DBTreeNode: TdxDBTreeNode);
    procedure DBTreeViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    function IsLoop : Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  OldIndex : integer;
  FUpdate : Boolean;

implementation

uses Grid, More, Find, dxDemoUtils, cxLookAndFeels;

{$R *.DFM}

function TMainForm.IsLoop : Boolean;
Var
  dbItemP, dbItem : TdxDBTreeNode;
begin
  Result := False;
  {Get Selected DBTreeNode}
  dbItem := DBTreeView.DBTreeNodes.GetDBTreeNode(T1.FindField('pr_id').Value);
  {Get Parent DBTreeNode}
  dbItemP := DBTreeView.DBTreeNodes.GetDBTreeNode(T1.FindField('pr_parent').Value);
  {Is it loop ?}
  if(dbItem <> nil) and  (dbItemP <> nil) and (dbItemP <> dbItem)
  and dbItemP.HasAsParent(dbItem) then
    Result := True;
end;

procedure TMainForm.T1Pr_parentChange(Sender: TField);
begin
  if(IsLoop) then
    ShowMessage('It is Loop');
end;

procedure TMainForm.DBTreeViewSetDisplayItemText(Sender: TObject;
  var DisplayText: string);
begin
  if(T1.FindField('pr_id').AsInteger = 1) then
    DisplayText := 'It is the first item. ' + DisplayText;
end;

procedure TMainForm.DBTreeViewDragDropTreeNode(Destination,
  Source: TTreeNode; var Accept: Boolean);
begin
  if Destination <> nil then
    if btnNextLevel.Down  then
      Accept := Source.Level > Destination.Level;
  if Accept and btnDragRoot.Down then
    Accept := not (Source.Parent = nil);
end;

procedure TMainForm.DBTreeViewCustomDraw(Sender: TObject;
  TreeNode: TTreeNode; AFont: TFont; var AColor, ABKColor: TColor);
begin
  if not btnCustomDrow.Down then exit;
  case TreeNode.Level mod 3 of
    0:  AColor := clBlue;
    1:  AColor := clRed;
    2:  AColor := clMaroon;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  T1.Open;
  T2.Open;
  OldIndex := -1 ;
  FUpdate := True;
  CreateHelpMenuItems(BarManager, miHelp);
end;

procedure TMainForm.bsAddNodeClick(Sender: TObject);
var ANode : TTreeNode;
begin
  ANode := DBTreeView.Items.Add(DBTreeView.Selected, 'New Item');
  ANode.ImageIndex := -1;
  DBTreeView.Selected := ANode;
end;

procedure TMainForm.bbAddChildClick(Sender: TObject);
var ANode : TTreeNode;
begin
  if (DBTreeView.Selected <> nil) then begin
    ANode := DBTreeView.Items.AddChild(DBTreeView.Selected,'Child of ' + DBTreeView.Selected.Text);
    ANode.ImageIndex := -1;
    DBTreeView.Selected := ANode;
  end;
end;

procedure TMainForm.bbRenameNodeClick(Sender: TObject);
begin
  if (DBTreeView.Selected <> nil) then
    DBTreeView.Selected.EditText;
end;

procedure TMainForm.bbDeleteNodeClick(Sender: TObject);
begin
  if (DBTreeView.Selected <> nil) then
    if MessageDlg('Delete Selected Item ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      DBTreeView.Selected.Delete;
end;

procedure TMainForm.bbFullExpandClick(Sender: TObject);
begin
  with DBTreeView do begin
    Items.BeginUpdate;
    FullExpand;
    Items.EndUpdate;
  end;
end;

procedure TMainForm.bbFullCollapsClick(Sender: TObject);
begin
  with DBTreeView do begin
    Items.BeginUpdate;
    FullCollapse;
    Items.EndUpdate;
  end;

end;

procedure TMainForm.bbExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.btnCustomDrowClick(Sender: TObject);
begin
  DBTreeView.Repaint;
end;

procedure TMainForm.btnUpClick(Sender: TObject);
var
  ParentNode : TTreeNode;
begin
  with DBTreeView do begin
    if Selected <> nil then begin
      ParentNode := Selected.Parent;
      if ParentNode <> nil then begin
        if ParentNode.Parent <> nil then
          Selected.MoveTo(ParentNode.Parent, naAddChild)
        else
          Selected.MoveTo(nil, naAdd);
      end;
    end;
  end;
end;

procedure TMainForm.btnDownClick(Sender: TObject);
var PrevChild, NextChild, ParentNode : TTreeNode;
begin
  with DBTreeView do
    if Selected <> nil then begin
        ParentNode := Selected.Parent;
        NextChild := ParentNode.GetNextChild(Selected);
        PrevChild := ParentNode.GetPrevChild(Selected);
        if NextChild <> nil then
          Selected.MoveTo(NextChild, naAddChild)
        else
         if PrevChild <> nil then
           Selected.MoveTo(PrevChild, naAddChild);
    end;
end;

procedure TMainForm.btnDisplayFieldClick(Sender: TObject);
begin
  if TdxBarButton(Sender).Down then
    DBTreeView.DisplayField := 'pr_name;pr_id'
    else DBTreeView.DisplayField := '';
end;

procedure TMainForm.btnAutoDragClick(Sender: TObject);
begin
  if TdxBarButton(Sender).Down then
    DBTreeView.DragMode := dmAutomatic
  else DBTreeView.DragMode := dmManual;
end;

procedure TMainForm.btnGridClick(Sender: TObject);
begin
  if TdxBarButton(Sender).Down then
    GridForm.Show
  else
    GridForm.Close;
end;

procedure TMainForm.DBTreeViewChange(Sender: TObject; Node: TTreeNode);
var S : String;
    ANode : TTreeNode;
begin
  S := '';
  with DBTreeView do begin
    ANode := Selected;
    while ANode <> nil do begin
      if S = '' then S := ANode.Text
      else S := ANode.Text + ' . ' + S;
      ANode := ANode.Parent;
    end;
    FUpdate := False;
    if Selected <> nil then cbImage.ItemIndex := Selected.ImageIndex
    else cbImage.ItemIndex := -1;
    FUpdate := True;
  end;
  StatusBar.Panels[0].Text := S;
end;

procedure TMainForm.btnMoreClick(Sender: TObject);
begin
  if TdxBarButton(Sender).Down then
    MoreForm.Show
  else
    MoreForm.Close;
end;

procedure TMainForm.DBTreeViewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button =  mbRight then
   dxBarPopupMenu.PopupFromCursorPos;
end;

procedure TMainForm.DBTreeViewGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TMainForm.btnFindClick(Sender: TObject);
begin
  if TdxBarButton(Sender).Down then
    FindForm.Show
  else
    FindForm.Close;
end;

procedure TMainForm.cbImageChange(Sender: TObject);
begin
  if not FUpdate then exit;
  with T1 do begin
    Edit;
    FieldByName('Image').AsInteger := cbImage.ItemIndex;
    Post;
  end;
end;

procedure TMainForm.DBTreeViewAddNewItem(Sender: TObject;
  var DBTreeNode: TdxDBTreeNode);
begin
  if OldIndex <> -1 then
    with T1 do begin
      DBTreeNode.ImageIndex := OldIndex;
      OldIndex := -1;
    end;
end;

procedure TMainForm.DBTreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ssCtrl in Shift) then
    if DBTreeView.GetNodeAt(X, Y) <> nil then
      OldIndex := DBTreeView.GetNodeAt(X, Y).ImageIndex;
end;

initialization
  dxMegaDemoProductIndex := dxDBTreeViewIndex;
  TdxVisualRefinements.LightBorders := True;
end.
