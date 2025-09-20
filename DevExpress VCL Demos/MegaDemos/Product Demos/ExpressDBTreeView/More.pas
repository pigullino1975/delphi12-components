unit More;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, dxdbtrel;

type
  TMoreForm = class(TForm)
    dxTreeViewEdit1: TdxTreeViewEdit;
    Label1: TLabel;
    dxDBTreeViewEdit1: TdxDBTreeViewEdit;
    dxDBTreeViewEdit: TLabel;
    dxLookupTreeView: TdxLookupTreeView;
    Label2: TLabel;
    dxDBLookupTreeView: TdxDBLookupTreeView;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dxDBTreeViewEdit1GetSelectedIndex(Sender: TObject;
      Node: TTreeNode);
    procedure dxLookupTreeViewGetSelectedIndex(Sender: TObject;
      Node: TTreeNode);
    procedure dxDBLookupTreeViewGetSelectedIndex(Sender: TObject;
      Node: TTreeNode);
    procedure dxDBTreeViewEdit1CloseUp(Sender: TObject; Accept: Boolean);
    procedure dxTreeViewEdit1GetSelectedIndex(Sender: TObject;
      Node: TTreeNode);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MoreForm: TMoreForm;

implementation

uses main;

{$R *.DFM}

procedure TMoreForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.btnMore.Down := False;
end;

procedure TMoreForm.dxDBTreeViewEdit1GetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TMoreForm.dxLookupTreeViewGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TMoreForm.dxDBLookupTreeViewGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TMoreForm.dxDBTreeViewEdit1CloseUp(Sender: TObject;
  Accept: Boolean);
begin
  if Accept then
   with MainForm.T1 do begin
    Edit;
//    MainForm.DBTreeView.Selected.ImageIndex := TdxDBTreeViewEdit(Sender).Selected.ImageIndex;
    FieldByName('Image').AsInteger := TdxDBTreeViewEdit(Sender).Selected.ImageIndex;
    Post;
  end;
end;

procedure TMoreForm.dxTreeViewEdit1GetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

end.
