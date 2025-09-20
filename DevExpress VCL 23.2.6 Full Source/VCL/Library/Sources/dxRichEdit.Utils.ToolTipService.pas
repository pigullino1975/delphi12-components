unit dxRichEdit.Utils.ToolTipService; //for internal use

interface

uses Types, dxRichEdit.Control.Core, dxRichEdit.DocumentModel.Hyperlink, dxCustomHint;

type
  IdxToolTipService = interface //for internal use
  ['{75320BD6-1BC5-4199-8D21-D4FA14741E95}']
    function CalculateToolTipInfo(APoint: TPoint): IcxHintableObject2;
  end;

  TdxToolTipService = class(TInterfacedObject, IdxToolTipService) //for internal use
  strict private
    FControl: TdxRichEditControlBase;
    function CalculateToolTipInfo(AHyperlinkInfo: TdxHyperlinkInfo): IcxHintableObject2; overload;
    function GetHyperlinkToolTipFooter: string;
  protected
    // IdxToolTipService
    function CalculateToolTipInfo(APoint: TPoint): IcxHintableObject2; overload;
  public
    constructor Create(AControl: TdxRichEditControlBase);
  end;

implementation

uses
  SysUtils, Classes, Menus, Graphics,
  dxCore, dxTypeHelpers, cxGeometry,
  dxRichEdit.Control.Mouse, dxRichEdit.Strs, dxRichEdit.DocumentModel.Fields.Core;

type
  TdxRichEditToolTipInfo = class(TInterfacedObject, IcxHintableObject2) //for internal use
  strict private
    FControl: TdxRichEditControlBase;
    FObject: TObject;
    FText: string;
  protected
    // IcxHintableObject
    function HasHintPoint(const P: TPoint): Boolean;
    function IsHintAtMousePos: Boolean;
    function UseHintHidePause: Boolean;

    // IcxHintableObject2
    function ImmediateShowHint: Boolean;
    function GetHintObject: TObject;
    function GetHintText: string;
    function IsHintMultiLine: Boolean;
    function GetHintFont: TFont;
    function GetHintAreaBounds: TRect;
    function GetHintTextBounds: TRect;

  public
    constructor Create(AControl: TdxRichEditControlBase; AHintObject: TObject; AText: string);
  end;


  TdxRichEditControlBaseAccess = class(TdxRichEditControlBase);
  TdxHyperlinkInfoAccess = class(TdxHyperlinkInfo);

{ TdxToolTipService }

constructor TdxToolTipService.Create(AControl: TdxRichEditControlBase);
begin
  inherited Create;
  FControl := AControl;
end;

function TdxToolTipService.CalculateToolTipInfo(APoint: TPoint): IcxHintableObject2;
var
  AActiveObject: TObject;
  AMouseController: TdxRichEditMouseController;
  AHyperlinkInfo: TdxHyperlinkInfo;
  AField: TdxField;
begin
  Result := nil;
  if not Safe.Cast(TdxRichEditControlBaseAccess(FControl).MouseController, TdxRichEditMouseController, AMouseController) then
    Exit;

  AActiveObject := AMouseController.ActiveObject;
  if AActiveObject = nil then
    Exit;

  if Safe.Cast(AActiveObject, TdxField, AField) then
  begin
    if not AField.IsCodeView and FControl.DocumentModel.ActivePieceTable.IsHyperlinkField(AField) then
      Result := CalculateToolTipInfo(FControl.DocumentModel.ActivePieceTable.HyperlinkInfos[AField.Index]);
  end
  else if Safe.Cast(AActiveObject, TdxHyperlinkInfo, AHyperlinkInfo) then
    Result := CalculateToolTipInfo(AHyperlinkInfo);
end;

function TdxToolTipService.CalculateToolTipInfo(AHyperlinkInfo: TdxHyperlinkInfo): IcxHintableObject2;
var
  AText: string;
begin
  if not FControl.Options.Hyperlinks.ShowToolTip then
    Exit;
  AText := Format('%s'#13#10'%s', [TdxHyperlinkInfoAccess(AHyperlinkInfo).GetActualToolTip, GetHyperlinkToolTipFooter]) ;
  Result := TdxRichEditToolTipInfo.Create(FControl, AHyperlinkInfo, AText);
end;

function TdxToolTipService.GetHyperlinkToolTipFooter: string;
var
  AKey: Word;
  AShiftState: TShiftState;
begin
  Result := cxGetResourceString(@sdxRichEditToolTipFooter_ClickToFollowHyperlink);
  ShortCutToKey(FControl.Options.Hyperlinks.ModifierKeys, AKey, AShiftState);
  if ssAlt in AShiftState then
    Result := 'Alt + ' + Result;
  if ssCtrl in AShiftState then
    Result := 'Ctrl + ' + Result;
  if ssShift in AShiftState then
    Result := 'Shift + ' + Result;
end;


{ TdxRichEditToolTipInfo }

constructor TdxRichEditToolTipInfo.Create(AControl: TdxRichEditControlBase; AHintObject: TObject; AText: string);
begin
  inherited Create;
  FControl := AControl;
  FObject := AHintObject;
  FText := AText;
end;

function TdxRichEditToolTipInfo.GetHintAreaBounds: TRect;
begin
  Result := FControl.Bounds;
end;

function TdxRichEditToolTipInfo.GetHintFont: TFont;
begin
  Result := nil;
end;

function TdxRichEditToolTipInfo.GetHintObject: TObject;
begin
  Result := FObject;
end;

function TdxRichEditToolTipInfo.GetHintText: string;
begin
  Result := FText;
end;

function TdxRichEditToolTipInfo.GetHintTextBounds: TRect;
begin
  Result := Rect(0, 0, cxMaxRectSize, 0);
end;

function TdxRichEditToolTipInfo.HasHintPoint(const P: TPoint): Boolean;
begin
  Result := cxRectPtIn(FControl.Bounds, P);
end;

function TdxRichEditToolTipInfo.ImmediateShowHint: Boolean;
begin
  Result := False;
end;

function TdxRichEditToolTipInfo.IsHintAtMousePos: Boolean;
begin
  Result := True;
end;

function TdxRichEditToolTipInfo.IsHintMultiLine: Boolean;
begin
  Result := True;
end;

function TdxRichEditToolTipInfo.UseHintHidePause: Boolean;
begin
  Result := True;
end;

end.
