unit uModelViewer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Generics.Collections, dxXmlDoc, dxSkinDevExpressStyle, dxForms,
  dxEMFModelObjects, dxEMFChart, dxEMFToolTypes, Vcl.ImgList, cxImageList, cxGraphics, System.ImageList, dxflchrt;

type
  TModelViewer = class(TdxForm, IEMFDesigner)
    ilModelObjects: TcxImageList;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  strict private
    procedure CreateDiagramControl; overload;
  private
    FDiagram: TdxEMFChart;
    FModel: TDataModel;
    function GetOptions: TdxFcOptions;
    procedure SetOptions(const Value: TdxFcOptions);
  public
    class function CreateDiagramControl(AParent: TWinControl; AImages: TcxImageList): TWinControl; overload;

    // IEMFDesigner
    procedure DeleteObject(AItem: TNamedPersistent);
    procedure SelectObject(AItem: TNamedPersistent);
    procedure ItemAdded(AItem: TNamedPersistent);
    procedure ItemNameChanged(AItem: TNamedPersistent);
    procedure ItemPropertiesChanged(AItem: TNamedPersistent);
    procedure ItemRemoved(AItem: TNamedPersistent);
    function GetKnownDataTypes: TDictionary<string, TDataType>;
    function GetModel: TDataModel;
    procedure Modified;
    procedure RegisterDataType(ADataType: TDataType);

    procedure LoadFromFile(const AFileName: string);

    property Options: TdxFcOptions read GetOptions write SetOptions;
  end;

var
  FModelViewer: TModelViewer;

implementation

{$R *.dfm}

uses
  IOUtils, dxEMFModelValidator, Main;

procedure TModelViewer.FormDestroy(Sender: TObject);
begin
  FModel.Free;
  FModel := nil;
  UnregisterEMFDesigner(Self);
end;

procedure TModelViewer.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

class function TModelViewer.CreateDiagramControl(AParent: TWinControl; AImages: TcxImageList): TWinControl;
begin
  Result := TdxEMFChart.Create(AParent);
  TdxEMFChart(Result).LookAndFeel.SkinName := 'DevExpressStyle';
  TdxEMFChart(Result).Align := alClient;
  TdxEMFChart(Result).Images := AImages;
  TdxEMFChart(Result).Parent := AParent;
end;

procedure TModelViewer.CreateDiagramControl;
begin
  FDiagram := CreateDiagramControl(Self, ilModelObjects) as TdxEMFChart;
end;

procedure TModelViewer.DeleteObject(AItem: TNamedPersistent);
begin
  AItem.Delete;
end;

procedure TModelViewer.FormCreate(Sender: TObject);
begin
  RegisterEMFDesigner(Self);
  FModel := TDataModel.Create(nil);
  CreateDiagramControl;
end;

function TModelViewer.GetKnownDataTypes: TDictionary<string, TDataType>;
begin
  Result := nil;
end;

function TModelViewer.GetModel: TDataModel;
begin
  Result := FModel;
end;

procedure TModelViewer.ItemAdded(AItem: TNamedPersistent);
begin

end;

procedure TModelViewer.ItemNameChanged(AItem: TNamedPersistent);
begin

end;

procedure TModelViewer.ItemPropertiesChanged(AItem: TNamedPersistent);
begin

end;

procedure TModelViewer.ItemRemoved(AItem: TNamedPersistent);
begin

end;

procedure TModelViewer.LoadFromFile(const AFileName: string);
var
  AXmlDoc: TdxXMLDocument;
  AModelNode, ADiagramNode: TdxXMLNode;
begin
  AXmlDoc := TdxXMLDocument.Create(nil);
  try
    AXmlDoc.LoadFromFile(AFileName);
    if AXmlDoc.FindChild('DataModel', AModelNode) then
      FModel.Restore(AModelNode);
    if AXmlDoc.FindChild('Diagram', ADiagramNode) then
     FDiagram.LoadFromXml(FModel, ADiagramNode);
    TdxEMFModelValidator.Validate(FModel);
  finally
    AXmlDoc.Free;
  end;
end;

procedure TModelViewer.Modified;
begin

end;

procedure TModelViewer.RegisterDataType(ADataType: TDataType);
begin

end;

procedure TModelViewer.SelectObject(AItem: TNamedPersistent);
begin

end;

function TModelViewer.GetOptions: TdxFcOptions;
begin
  Result := FDiagram.Options;
end;

procedure TModelViewer.SetOptions(const Value: TdxFcOptions);
begin
  FDiagram.Options := Value;
end;

end.
