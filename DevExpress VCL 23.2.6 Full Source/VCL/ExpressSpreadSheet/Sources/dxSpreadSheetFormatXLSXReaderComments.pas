{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSpreadSheet                                       }
{                                                                    }
{           Copyright (c) 2001-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSSPREADSHEET CONTROL AND ALL    }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxSpreadSheetFormatXLSXReaderComments;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, dxCore, dxCoreClasses, cxClasses, dxCustomTree, dxXMLDoc, dxZIPUtils,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxSpreadSheetStrs, dxSpreadSheetPackedFileFormatCore,
  dxSpreadSheetUtils, dxGDIPlusClasses, dxCoreGraphics, cxGeometry, dxHashUtils, Variants, dxSpreadSheetContainers,
  dxSpreadSheetFormatXLSXReader, dxXMLReader;

type

  { TdxXLSXCommentsReader }

  TdxXLSXCommentsReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FAuthors: TStrings;
  public
    constructor Create(const AFileName: string; AView: TdxSpreadSheetTableView; AOwner: TdxSpreadSheetXLSXReader); reintroduce;
    destructor Destroy; override;
    //
    property Authors: TStrings read FAuthors;
  end;

  { TdxXLSXCommentContainersReader }

  TdxXLSXCommentContainersReader = class(TdxXLSXCustomDocumentReader)
  public
    constructor Create(const AFileName: string; AView: TdxSpreadSheetTableView; AOwner: TdxSpreadSheetXLSXReader); reintroduce;
  end;

implementation

uses
  dxSpreadSheetFormatXLSXTags, dxSpreadSheetFormatUtils, Math, dxSpreadSheetFormatXLSXReaderDrawing,
  dxSpreadSheetCoreStyles, dxSVGCoreParsers, dxSVGCore, dxSpreadSheetFormatXLSX, dxSpreadSheetCoreStrs,
  dxSpreadSheetFormatXLSXUtils, dxXMLReaderUtils;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXReaderComments';

type
  TdxSpreadSheetContainerAccess = class(TdxSpreadSheetContainer);
  TdxSpreadSheetReaderAccess = class(TdxSpreadSheetXLSXReader);

  { TdxXLSXCommentHandler }

  TdxXLSXCommentHandler = class(TdxXLSXNodeHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXCommentAuthorsHandler }

  TdxXLSXCommentAuthorsHandler = class(TdxXLSXNodeHandler)
  strict private
    FAuthors: TStrings;

    procedure ProcessAuthor(const S: string);
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXCommentContainerHandler }

  TdxXLSXCommentContainerHandler = class(TdxXLSXNodeHandler)
  strict private
    FAbsolutePoint1: TPoint;
    FAbsolutePoint2: TPoint;
    FAbsolutePointAssigned: Boolean;
    FAlignHorz: TAlignment;
    FAlignVert: TVerticalAlignment;
    FAnchorPoints: TStrings;
    FAutoSize: Boolean;
    FCellRef: TPoint;
    FContentOffsets: TRect;
    FFill: TdxGPBrush;
    FMoveWithCells: Boolean;
    FSizeWithCells: Boolean;
    FStrokeColor: TdxAlphaColor;
    FStrokeStyle: TdxGPPenStyle;
    FStrokeWidth: Single;
    FView: TdxSpreadSheetTableView;
    FVisible: Boolean;

    procedure ApplyPlacement(AContainer: TdxSpreadSheetCommentContainer);
    function DecodeColor(S: string; ADefaultColor: TColor = clBlack): TColor;
    function DecodeOpacity(const S: string): Byte;
    function ReadFillTexture(const AReader: TdxXmlReader): Boolean;
    function ReadGradientAngle(const AReader: TdxXmlReader): Double;
    function SplitString(const S: string; ADelimiter: Char): TStringList;
    function ToBoolean(const S: string): Boolean; inline;

    procedure ProcessAnchorPoints(const S: string);
    procedure ProcessColumn(const S: string);
    function ProcessFill(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    procedure ProcessMoveWithCells(const S: string);
    procedure ProcessRow(const S: string);
    procedure ProcessSizeWithCells(const S: string);
    function ProcessStrokeStyle(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    procedure ProcessTextAlignHorz(const S: string);
    procedure ProcessTextAlignVert(const S: string);
    function ProcessTextBox(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    procedure ProcessVisible(const S: string);
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXCommentListHandler }

  TdxXLSXCommentListHandler = class(TdxXLSXNodeHandler)
  strict private
    FAuthors: TStrings;
    FView: TdxSpreadSheetTableView;

    function CreateCommentHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    //
    property Authors: TStrings read FAuthors;
    property View: TdxSpreadSheetTableView read FView;
  end;

  { TdxXLSXCommentTextHandler }

  TdxXLSXCommentTextHandler = class(TdxXLSXFormattedTextHandler)
  strict private
    FContainer: TdxSpreadSheetCommentContainer;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
  end;

{ TdxXLSXCommentHandler }

constructor TdxXLSXCommentHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNodeTextFull, TdxXLSXCommentTextHandler, AData);
end;

{ TdxXLSXCommentAuthorsHandler }

constructor TdxXLSXCommentAuthorsHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FAuthors := AData as TStrings;
  Handlers.Add(sdxXLSXNodeAuthor, ProcessAuthor);
end;

procedure TdxXLSXCommentAuthorsHandler.ProcessAuthor(const S: string);
begin
  FAuthors.Add(S);
end;

{ TdxXLSXCommentContainerHandler }

constructor TdxXLSXCommentContainerHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FStrokeWidth := 1;
  FStrokeColor := dxColorToAlphaColor(clBlack);
  FCellRef := cxInvalidPoint;
  FFill := TdxGPBrush.Create;
  FFill.Color := dxColorToAlphaColor(clInfoBk);
  FView := AData as TdxSpreadSheetTableView;
end;

destructor TdxXLSXCommentContainerHandler.Destroy;
begin
  FreeAndNil(FAnchorPoints);
  FreeAndNil(FFill);
  inherited;
end;

procedure TdxXLSXCommentContainerHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXClientData, Skip);
  Handlers.Add(sdxXLSXNamespaceVML, sdxXLSXNodeVMLFill, ProcessFill);
  Handlers.Add(sdxXLSXNamespaceVML, sdxXLSXNodeVMLStroke, ProcessStrokeStyle);
  Handlers.Add(sdxXLSXNamespaceVML, sdxXLSXNodeVMLTextBox, ProcessTextBox);

  // sdxXLSXNodeXClientData
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXAnchor, ProcessAnchorPoints);
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXColumn, ProcessColumn);
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXMoveWithCells, ProcessMoveWithCells);
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXRow, ProcessRow);
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXSizeWithCells, ProcessSizeWithCells);
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXTextHAlign, ProcessTextAlignHorz);
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXTextVAlign, ProcessTextAlignVert);
  Handlers.Add(sdxXLSXNamespaceExcel, sdxXLSXNodeXVisible, ProcessVisible);
end;

procedure TdxXLSXCommentContainerHandler.BeforeDestruction;
var
  AContainer: TdxSpreadSheetCommentContainer;
begin
  inherited;

  if FView.Containers.FindCommentContainer(FCellRef.Y, FCellRef.X, AContainer) then
  begin
    AContainer.TextBox.ContentOffsets := FContentOffsets;
    AContainer.TextBox.AutoSize := FAutoSize;
    AContainer.TextBox.AlignHorz := FAlignHorz;
    AContainer.TextBox.AlignVert := FAlignVert;

    AContainer.Shape.Brush.Assign(FFill);
    AContainer.Shape.Pen.Brush.Style := gpbsSolid;
    AContainer.Shape.Pen.Brush.Color := FStrokeColor;
    AContainer.Shape.Pen.Style := FStrokeStyle;
    AContainer.Shape.Pen.Width := FStrokeWidth;

    AContainer.Visible := FVisible;

    ApplyPlacement(AContainer);
  end;
end;

procedure TdxXLSXCommentContainerHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AAttrValue: string;
  AList: TStringList;
  AValue: TdxSVGValue;
begin
  if AReader.GetAttribute(sdxXLSXNamespaceOffice, sdxXLSXAttrInsetMode, '') = 'auto' then
    FContentOffsets := dxEMUToPixels(dxXLSXDefaultTextPadding);

  if AReader.TryGetAttribute(sdxXLSXNodeStyle, AAttrValue) then
  begin
    AList := SplitString(AAttrValue, ';');
    try
      AList.NameValueSeparator := ':';
      if AList.Values[sdxXLSXAttrPosition] = sdxXLSXValueEditAsAbsolute then
      begin
        FAbsolutePointAssigned := True;
        if TdxSVGParserValue.Parse(AList.Values['margin-left'], AValue) then
          FAbsolutePoint1.X := Round(AValue.ToPixels);
        if TdxSVGParserValue.Parse(AList.Values['margin-top'], AValue) then
          FAbsolutePoint1.Y := Round(AValue.ToPixels);

        if TdxSVGParserValue.Parse(AList.Values['margin-right'], AValue) then
          FAbsolutePoint2.X := Round(AValue.ToPixels) - FAbsolutePoint1.X
        else if TdxSVGParserValue.Parse(AList.Values['width'], AValue) then
          FAbsolutePoint2.X := Round(AValue.ToPixels);

        if TdxSVGParserValue.Parse(AList.Values['margin-bottom'], AValue) then
          FAbsolutePoint2.Y := Round(AValue.ToPixels) - FAbsolutePoint1.Y
        else if TdxSVGParserValue.Parse(AList.Values['height'], AValue) then
          FAbsolutePoint2.Y := Round(AValue.ToPixels);
      end;
    finally
      AList.Free;
    end;
  end;

  if AReader.TryGetAttribute(sdxXLSXAttrStrokeColor, AAttrValue) then
    FStrokeColor := dxColorToAlphaColor(DecodeColor(AAttrValue));
  if AReader.TryGetAttribute(sdxXLSXAttrStrokeWeight, AAttrValue) then
    FStrokeWidth := TdxValueUnitsHelper.ValueToPixels(AAttrValue);
  if AReader.TryGetAttribute(sdxXLSXAttrFillColor, AAttrValue) then
    FFill.Color := dxColorToAlphaColor(DecodeColor(AAttrValue));
end;

procedure TdxXLSXCommentContainerHandler.ApplyPlacement(AContainer: TdxSpreadSheetCommentContainer);

  function GetCell(const ARow, AColumn: string): TdxSpreadSheetCell;
  begin
    Result := FView.CreateCell(StrToInt(ARow), StrToInt(AColumn));
  end;

  function GetOffset(const ARowOffset, AColumnOffset: string): TPoint;
  begin
    Result := Point(StrToIntDef(AColumnOffset, 0), StrToIntDef(ARowOffset, 0));
  end;

  function GetAnchorType: TdxSpreadSheetContainerAnchorType;
  begin
    if FMoveWithCells and FSizeWithCells then
      Result := catTwoCell
    else if FMoveWithCells then
      Result := catOneCell
    else
      Result := catAbsolute;
  end;

var
  ASavedBounds: TRect;
begin
  if FAbsolutePointAssigned then
  begin
    AContainer.BeginUpdate;
    try
      AContainer.AnchorType := catAbsolute;
      AContainer.AnchorPoint1.Offset := FAbsolutePoint1;
      AContainer.AnchorPoint2.Offset := FAbsolutePoint2;
    finally
      AContainer.EndUpdate;
    end;
  end;

  if (FAnchorPoints <> nil) and (FAnchorPoints.Count = 8) then
  begin

    AContainer.BeginUpdate;
    try
      AContainer.AnchorType := catTwoCell;
      AContainer.AnchorPoint1.Cell := GetCell(FAnchorPoints[2], FAnchorPoints[0]);
      AContainer.AnchorPoint1.Offset := GetOffset(FAnchorPoints[3], FAnchorPoints[1]);
      AContainer.AnchorPoint2.Cell := GetCell(FAnchorPoints[6], FAnchorPoints[4]);
      AContainer.AnchorPoint2.Offset := GetOffset(FAnchorPoints[7], FAnchorPoints[5]);
    finally
      AContainer.EndUpdate;
    end;
  end;

  if GetAnchorType <> AContainer.AnchorType then
  begin
    ASavedBounds := TdxSpreadSheetContainerAccess(AContainer).Calculator.CalculateBounds;
    try
      AContainer.AnchorType := GetAnchorType;
    finally
      TdxSpreadSheetContainerAccess(AContainer).Calculator.UpdateAnchors(ASavedBounds);
    end;
  end;
end;

function TdxXLSXCommentContainerHandler.DecodeColor(S: string; ADefaultColor: TColor = clBlack): TColor;
begin
  if Pos(' ', S) > 0 then
    Delete(S, Pos(' ', S), MaxInt);

  if (S <> '') and (S[1] = '#') then
    Result := TdxXLSXUtils.DecodeColor(Copy(S, 2, MaxInt))
  else
    if SameText(S, 'infoBackground') then
      Result := clInfoBk
    else
      if not IdentToColor('cl' + S, Integer(Result))  then
        Result := ADefaultColor;
end;

function TdxXLSXCommentContainerHandler.DecodeOpacity(const S: string): Byte;
var
  ALength: Integer;
begin
  ALength := Length(S);
  if ALength = 0 then
    Result := MaxByte
  else
    case S[ALength] of
      'f':
        Result := MulDiv(MaxByte, StrToInt(Copy(S, 1, ALength - 1)), MaxWord);
      '%':
        Result := MulDiv(MaxByte, StrToInt(Copy(S, 1, ALength - 1)), 100);
    else
      Result := StrToIntDef(S, MaxByte);
    end;
end;

procedure TdxXLSXCommentContainerHandler.ProcessAnchorPoints(const S: string);
begin
  FAnchorPoints := SplitString(S, ',');
end;

procedure TdxXLSXCommentContainerHandler.ProcessColumn(const S: string);
begin
  FCellRef.X := StrToIntDef(S, -1);
end;

function TdxXLSXCommentContainerHandler.ProcessFill(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AColor1: TdxAlphaColor;
  AColor2: TdxAlphaColor;
  AInvertOrder: Boolean;
  AType: string;
begin
  AColor1 := dxColorToAlphaColor(dxAlphaColorToColor(FFill.Color),
    DecodeOpacity(AReader.GetAttribute(sdxXLSXAttrOpacity)));
  AColor2 := dxColorToAlphaColor(DecodeColor(sdxXLSXAttrColor2),
    DecodeOpacity(AReader.GetAttribute(sdxXLSXNamespaceOffice, sdxXLSXAttrOpacity2, '')));

  AType := AReader.GetAttribute(sdxXLSXAttrTypeLC);
  if AType = sdxXLSXValueGradient then
  begin
    FFill.Style := gpbsGradient;
    FFill.GradientPoints.Add(0, AColor1);
    FFill.GradientPoints.Add(1, AColor2);
    FFill.GradientMode := dxGetNearestGradientMode(ReadGradientAngle(AReader), AInvertOrder);
    if AInvertOrder then
      FFill.GradientPoints.InvertOrder;
  end
  else

  if AType = sdxXLSXValueTile then
    ReadFillTexture(AReader)
  else

  if AType = sdxXLSXValuePattern then
  begin
    if ReadFillTexture(AReader) then
      dxSpreadSheetInitializeBrushPattern(FFill, FFill.Texture, AColor1, AColor2);
  end
  else
  begin
    FFill.Style := gpbsSolid;
    FFill.Color := AColor1;
  end;
  Result := nil;
end;

procedure TdxXLSXCommentContainerHandler.ProcessMoveWithCells(const S: string);
begin
  FMoveWithCells := ToBoolean(S);
end;

procedure TdxXLSXCommentContainerHandler.ProcessRow(const S: string);
begin
  FCellRef.Y := StrToIntDef(S, -1);
end;

procedure TdxXLSXCommentContainerHandler.ProcessSizeWithCells(const S: string);
begin
  FSizeWithCells := ToBoolean(S);
end;

procedure TdxXLSXCommentContainerHandler.ProcessTextAlignHorz(const S: string);
begin
  FAlignHorz := TdxSpreadSheetXLSXHelper.StringToVMLTextAlignHorz(S);
end;

procedure TdxXLSXCommentContainerHandler.ProcessTextAlignVert(const S: string);
begin
  FAlignVert := TdxSpreadSheetXLSXHelper.StringToVMLTextAlignVert(S);
end;

function TdxXLSXCommentContainerHandler.ProcessStrokeStyle(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FStrokeStyle := TdxSpreadSheetXLSXHelper.StringToVMLDashStyle(AReader.GetAttribute(sdxXLSXAttrDashStyle));
  Result := nil;
end;

function TdxXLSXCommentContainerHandler.ProcessTextBox(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AList: TStringList;
  AValue: string;
begin
  if AReader.TryGetAttribute(sdxXLSXAttrInset, AValue) then
  begin
    AList := SplitString(AValue, ',');
    try
      if AList.Count > 0 then
        FContentOffsets.Left := TdxValueUnitsHelper.ValueToPixels(AList[0]);
      if AList.Count > 1 then
        FContentOffsets.Top := TdxValueUnitsHelper.ValueToPixels(AList[1]);
      if AList.Count > 2 then
        FContentOffsets.Right := TdxValueUnitsHelper.ValueToPixels(AList[2]);
      if AList.Count > 3 then
        FContentOffsets.Bottom := TdxValueUnitsHelper.ValueToPixels(AList[3]);
    finally
      AList.Free;
    end;
  end;

  if AReader.TryGetAttribute(sdxXLSXAttrStyle, AValue) then
  begin
    AList := SplitString(AValue, ';');
    try
      AList.NameValueSeparator := ':';
      FAutoSize := Trim(AList.Values[sdxXLSXMSOFitShapeToText]) = 't';
    finally
      AList.Free;
    end;
  end;

  Result := nil;
end;

procedure TdxXLSXCommentContainerHandler.ProcessVisible(const S: string);
begin
  FVisible := ToBoolean(S)
end;

function TdxXLSXCommentContainerHandler.ReadFillTexture(const AReader: TdxXmlReader): Boolean;
var
  ADocumentReader: TdxSpreadSheetReaderAccess;
  ARelItem: TdxXLSXRelationship;
  AStream: TMemoryStream;
begin
  Result := False;
  if Owner.Rels.Find(AReader.GetAttribute(sdxXLSXNamespaceOffice, sdxXLSXAttrRelID, ''), ARelItem) then
  begin
    ADocumentReader := TdxSpreadSheetReaderAccess(Owner.Owner);
    if ADocumentReader.FileExists(ARelItem.Target) then
    begin
      AStream := ADocumentReader.ReadFile(ARelItem.Target);
      try
        FFill.Style := gpbsTexture;
        FFill.Texture.LoadFromStream(AStream);
        Result := True;
      finally
        AStream.Free;
      end;
    end
    else
      DoError(sdxErrorPictureCannotBeFound, [Owner.FileName + ':' + ARelItem.Target], ssmtWarning);
  end;
end;

function TdxXLSXCommentContainerHandler.ReadGradientAngle(const AReader: TdxXmlReader): Double;
var
  AFocus: Integer;
begin
  Result := dxNormalizeAngle(StrToFloatDef(AReader.GetAttribute(sdxXLSXAttrAngle), 0, dxInvariantFormatSettings));
  AFocus := StrToIntDef(StringReplace(AReader.GetAttribute(sdxXLSXAttrFocus), '%', '', [rfReplaceAll]), 0);

  case Round(Result / 45) of
    0, 2, 4, 6, 8:
      Result := Result + 90;
    3, 7:
      AFocus := 100 - AFocus;
  end;

  if AFocus >= 50 then
    Result := Result + 180;
end;

function TdxXLSXCommentContainerHandler.SplitString(const S: string; ADelimiter: Char): TStringList;
var
  AStrings: TStringList;
  I: Integer;
begin
  AStrings := TStringList.Create;
  AStrings.Delimiter := ADelimiter;
  AStrings.DelimitedText := S;
  for I := 0 to AStrings.Count - 1 do
    AStrings[I] := Trim(AStrings[I]);
  Result := AStrings;
end;

function TdxXLSXCommentContainerHandler.ToBoolean(const S: string): Boolean;
begin
  Result := (S = '') or TdxXMLHelper.DecodeBoolean(S);
end;

{ TdxXLSXCommentListHandler }

constructor TdxXLSXCommentListHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FAuthors := TdxXLSXCommentsReader(AOwner).Authors;
  FView := AData as TdxSpreadSheetTableView;
  Handlers.Add(sdxXLSXNodeComment, CreateCommentHandler);
end;

function TdxXLSXCommentListHandler.CreateCommentHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AAuthorId: Integer;
  AContainer: TdxSpreadSheetCommentContainer;
begin
  View.Containers.AddCommentContainer(View.CreateCell(AReader.GetAttribute(sdxXLSXAttrRef)), AContainer);
  AContainer.Visible := False;

  AAuthorId := AReader.GetAttributeAsInteger(sdxXLSXAttrAuthorId, -1);
  if InRange(AAuthorId, 0, Authors.Count - 1) then
    AContainer.Author := Authors.Strings[AAuthorId];

  Result := TdxXLSXCommentHandler.Create(Owner, AContainer);
end;

{ TdxXLSXCommentTextHandler }

constructor TdxXLSXCommentTextHandler.Create(AOwner, AData: TObject);
begin
  inherited Create(AOwner, '', TdxSpreadSheetFormattedSharedStringRuns.Create, TStringBuilder.Create);
  FContainer := AData as TdxSpreadSheetCommentContainer;
end;

destructor TdxXLSXCommentTextHandler.Destroy;
begin
  FreeAndNil(FRuns);
  FreeAndNil(FText);
  inherited;
end;

procedure TdxXLSXCommentTextHandler.BeforeDestruction;
begin
  inherited;
  FContainer.TextBox.Text := TdxSpreadSheetReaderAccess(Owner.Owner).AddSharedString(FText.ToString, FRuns);
  if FRuns.Count > 0 then
    FContainer.TextBox.Font.Handle := FRuns[0].FontHandle;
end;

{ TdxXLSXCommentsReader }

constructor TdxXLSXCommentsReader.Create(const AFileName: string; AView: TdxSpreadSheetTableView; AOwner: TdxSpreadSheetXLSXReader);
begin
  inherited Create(AFileName, AOwner);
  FAuthors := TStringList.Create;
  Handlers.Add(sdxXLSXNodeAuthors, TdxXLSXCommentAuthorsHandler, FAuthors);
  Handlers.Add(sdxXLSXNodeCommentList, TdxXLSXCommentListHandler, AView);
end;

destructor TdxXLSXCommentsReader.Destroy;
begin
  FreeAndNil(FAuthors);
  inherited;
end;

{ TdxXLSXCommentContainersReader }

constructor TdxXLSXCommentContainersReader.Create(const AFileName: string;
  AView: TdxSpreadSheetTableView; AOwner: TdxSpreadSheetXLSXReader);
begin
  inherited Create(AFileName, AOwner);
  Handlers.Add(sdxXLSXNamespaceVML, sdxXLSXNodeShape, TdxXLSXCommentContainerHandler, AView);
end;

end.
