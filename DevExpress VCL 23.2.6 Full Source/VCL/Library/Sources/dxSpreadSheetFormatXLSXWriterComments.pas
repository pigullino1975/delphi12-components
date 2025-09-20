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

unit dxSpreadSheetFormatXLSXWriterComments;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, Generics.Defaults, Generics.Collections,
  dxGDIPlusClasses, dxCoreGraphics, dxXMLDoc, dxSpreadSheetContainers, dxSpreadSheetFormatXLSXWriter,
  dxSpreadSheetFormatXLSXTags, dxSpreadSheetPackedFileFormatCore, dxSpreadSheetClasses, dxSpreadSheetCoreStyles,
  dxXMLWriter, dxSpreadSheetFormatXLSXUtils;

type

  { TdxXLSXWriterWorksheetTableViewCommentsBuilder }

  TdxXLSXWriterWorksheetTableViewCommentsBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    FAuthors: TStringList;
    FComments: TList;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;

    procedure PopulateAuthors;
    procedure WriteAuthors(AWriter: TdxXmlWriter); virtual;
    procedure WriteComment(AWriter: TdxXmlWriter; AComment: TdxSpreadSheetCommentContainer); virtual;
    procedure WriteCommentText(AWriter: TdxXmlWriter; AComment: TdxSpreadSheetCommentTextBox); virtual;
    procedure WriteComments(AWriter: TdxXmlWriter); virtual;
  public
    constructor Create(AOwner: TdxXLSXWriterWorksheetTableViewBuilder;
      AOwnerRels: TdxXLSXRelationships; const ATargetFileName: string);
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
    //
    property Authors: TStringList read FAuthors;
    property Comments: TList read FComments;
  end;

  { TdxXLSXWriterWorksheetTableViewCommentContainerBuilder }

  TdxXLSXWriterWorksheetTableViewCommentContainerBuilder = class(TdxXLSXWriterCustomBuilder)
  strict private
    FContainer: TdxSpreadSheetCommentContainer;
    FWriter: TdxXmlWriter;

    function EncodeAnchors: string;
    function EncodeColor(const AColor: TdxAlphaColor): string;
    function EncodeOpacity(AAlpha: Byte): string;
    function EncodeStyles: string;
  protected
    procedure WriteClientData(AWriter: TdxXmlWriter); virtual;
    procedure WriteShapeAttributes(AWriter: TdxXmlWriter; AShape: TdxSpreadSheetShape); virtual;
    procedure WriteShapeContent(AWriter: TdxXmlWriter; AShape: TdxSpreadSheetShape); virtual;
    procedure WriteTextBox(AWriter: TdxXmlWriter); virtual;
  public
    constructor Create(AContainer: TdxSpreadSheetCommentContainer; AWriter: TdxXmlWriter;
      AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships);
    procedure Execute; override;
    //
    property Container: TdxSpreadSheetCommentContainer read FContainer;
    property Writer: TdxXmlWriter read FWriter;
  end;

  { TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder }

  TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  strict private
    FOwnerWriter: TdxXLSXWriterWorksheetTableViewBuilder;

    function GetComments: TList;
  protected
    function GetContentRelationship: string; override;
    function GetContentType: string; override;

    procedure WriteDefaults(AWriter: TdxXmlWriter);
    procedure WriteShapes(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships);
  public
    constructor Create(const ATargetFileName: string;
      AOwnerRels: TdxXLSXRelationships; AOwnerWriter: TdxXLSXWriterWorksheetTableViewBuilder);
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
    //
    property Comments: TList read GetComments;
  end;

implementation

uses
  dxSpreadSheetUtils, dxSpreadSheetFormatUtils, AnsiStrings, dxSpreadSheetCore, cxGeometry, dxColorPicker,
  dxSpreadSheetFormatXLSXReaderDrawing, dxCore, cxGraphics, dxStringHelper;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXWriterComments';

type
  TdxSpreadSheetContainerAccess = class(TdxSpreadSheetContainer);

{ TdxXLSXWriterWorksheetTableViewCommentsBuilder }

constructor TdxXLSXWriterWorksheetTableViewCommentsBuilder.Create(
  AOwner: TdxXLSXWriterWorksheetTableViewBuilder; AOwnerRels: TdxXLSXRelationships; const ATargetFileName: string);
begin
  inherited Create(AOwner.Owner, AOwnerRels, ATargetFileName);
  FComments := AOwner.Comments;
end;

destructor TdxXLSXWriterWorksheetTableViewCommentsBuilder.Destroy;
begin
  FreeAndNil(FAuthors);
  inherited Destroy;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentsBuilder.AfterConstruction;
begin
  inherited AfterConstruction;
  FAuthors := TStringList.Create;
  FAuthors.CaseSensitive := True;
end;

function TdxXLSXWriterWorksheetTableViewCommentsBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXCommentsRelationship;
end;

function TdxXLSXWriterWorksheetTableViewCommentsBuilder.GetContentType: string;
begin
  Result := sdxXLSXCommentsContentType;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentsBuilder.ExecuteCore(AWriter: TdxXmlWriter);
begin
  PopulateAuthors;

  AWriter.WriteStartElement(sdxXLSXNodeComments, sdxXLSXWorkbookNamespace);
  try
    WriteAuthors(AWriter);
    WriteComments(AWriter);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentsBuilder.PopulateAuthors;
var
  AAuthor: string;
  I: Integer;
begin
  for I := 0 to Comments.Count - 1 do
  begin
    AAuthor := TdxSpreadSheetCommentContainer(Comments.List[I]).Author;
    if Authors.IndexOf(AAuthor) < 0 then
      Authors.Add(AAuthor);
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentsBuilder.WriteAuthors(AWriter: TdxXmlWriter);
var
  I: Integer;
begin
  AWriter.WriteStartElement(sdxXLSXNodeAuthors);
  try
    for I := 0 to Authors.Count - 1 do
      AWriter.WriteElementString(sdxXLSXNodeAuthor, Authors[I]);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentsBuilder.WriteComment(
  AWriter: TdxXmlWriter; AComment: TdxSpreadSheetCommentContainer);
begin
  AWriter.WriteStartElement(sdxXLSXNodeComment);
  try
    AWriter.WriteAttributeInteger(sdxXLSXAttrShapeId, 0);
    AWriter.WriteAttributeInteger(sdxXLSXAttrAuthorId, Authors.IndexOf(AComment.Author));
    AWriter.WriteAttributeString(sdxXLSXAttrRef, AComment.Cell.GetReference(False));
    WriteCommentText(AWriter, AComment.TextBox);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentsBuilder.WriteCommentText(
  AWriter: TdxXmlWriter; AComment: TdxSpreadSheetCommentTextBox);
var
  AString: TdxSpreadSheetFormattedSharedString;
begin
  AWriter.WriteStartElement(sdxXLSXNodeTextFull);
  try
    AString := TdxSpreadSheetFormattedSharedString.CreateObject(AComment.TextAsString);
    try
      AString.Runs.Add.FontHandle := AComment.Font.Handle;
      ExecuteSubTask(TdxXLSXWriterFormattedStringBuilder.Create(Owner, OwnerRels, AWriter, AString));
    finally
      AString.Free;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentsBuilder.WriteComments(AWriter: TdxXmlWriter);
var
  I: Integer;
begin
  AWriter.WriteStartElement(sdxXLSXNodeCommentList);
  try
    for I := 0 to Comments.Count - 1 do
      WriteComment(AWriter, Comments[I]);
  finally
    AWriter.WriteEndElement;
  end;
end;

{ TdxXLSXWriterWorksheetTableViewCommentContainerBuilder }

constructor TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.Create(
  AContainer: TdxSpreadSheetCommentContainer; AWriter: TdxXmlWriter;
  AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships);
begin
  inherited Create(AOwner, AOwnerRels);
  FContainer := AContainer;
  FWriter := AWriter;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.Execute;
begin
  Writer.WriteStartElement(sdxXLSXNamespaceVML, sdxXLSXNodeShape, '');
  Writer.WriteAttributeString('type', '#_x0000_t202');
  Writer.WriteAttributeString(sdxXLSXAttrStyle, EncodeStyles);

  WriteShapeAttributes(Writer, Container.Shape);
  WriteShapeContent(Writer, Container.Shape);

  Writer.WriteStartElement(sdxXLSXNamespaceVML, 'path', '');
  Writer.WriteAttributeString('o', 'connecttype', '', 'none');
  Writer.WriteEndElement;

  WriteTextBox(Writer);
  WriteClientData(Writer);

  Writer.WriteEndElement; // sdxXLSXNodeShape
end;

function TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.EncodeAnchors: string;

  procedure CalculateAnchor(AAnchor: TdxSpreadSheetContainerAnchorPoint; const P: TPoint; var AAnchorPoint, AAnchorOffset: TPoint);
  var
    ATableView: IdxSpreadSheetTableView;
  begin
    AAnchorOffset := AAnchor.Offset;
    if Supports(Container.Parent, IdxSpreadSheetTableView, ATableView) then
    begin
      if ATableView.GetCellAtAbsolutePoint(P, AAnchorPoint.Y, AAnchorPoint.X) then
        AAnchorOffset := cxPointOffset(P, ATableView.GetAbsoluteCellBounds(AAnchorPoint.Y, AAnchorPoint.X, False).TopLeft, False);
    end;
  end;

var
  AAnchorOffsets: TRect;
  AAnchorPoints: TRect;
  AContainerBounds: TRect;
begin
  AContainerBounds := TdxSpreadSheetContainerAccess(Container).Calculator.CalculateBounds;
  CalculateAnchor(Container.AnchorPoint1, AContainerBounds.TopLeft, AAnchorPoints.TopLeft, AAnchorOffsets.TopLeft);
  CalculateAnchor(Container.AnchorPoint2, AContainerBounds.BottomRight, AAnchorPoints.BottomRight, AAnchorOffsets.BottomRight);

  Result := Format('%d, %d, %d, %d, %d, %d, %d, %d', [
    AAnchorPoints.Left, AAnchorOffsets.Left, AAnchorPoints.Top, AAnchorOffsets.Top,
    AAnchorPoints.Right, AAnchorOffsets.Right, AAnchorPoints.Bottom, AAnchorOffsets.Bottom]);
end;

function TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.EncodeColor(const AColor: TdxAlphaColor): string;
begin
  if AColor = TdxAlphaColors.Empty then
    Result := 'none'
  else
    Result := TdxAlphaColors.ToHexCode(AColor, False, '#');
end;

function TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.EncodeOpacity(AAlpha: Byte): string;
begin
  Result := IntToStr(MulDiv(AAlpha, MaxWord, MaxByte)) + 'f';
end;

function TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.EncodeStyles: string;
const
  VisibilityMap: array[Boolean] of string = ('hidden', 'visible');
var
  ABuilder: TStringBuilder;
  AContainerBounds: TRect;
begin
  AContainerBounds := TdxSpreadSheetContainerAccess(Container).Calculator.CalculateBounds;
  ABuilder := TdxStringBuilderManager.Get;
  try
    ABuilder.Append('position:absolute;');
    ABuilder.Append(Format('margin-left:%0.2fpt;', [TdxValueUnitsHelper.PixelsToPoints(AContainerBounds.Left)], dxInvariantFormatSettings));
    ABuilder.Append(Format('margin-top:%0.2fpt;', [TdxValueUnitsHelper.PixelsToPoints(AContainerBounds.Top)], dxInvariantFormatSettings));
    ABuilder.Append(Format('width:%0.2fpt;', [TdxValueUnitsHelper.PixelsToPoints(cxRectWidth(AContainerBounds))], dxInvariantFormatSettings));
    ABuilder.Append(Format('height:%0.2fpt;', [TdxValueUnitsHelper.PixelsToPoints(cxRectHeight(AContainerBounds))], dxInvariantFormatSettings));
    ABuilder.AppendFormat('z-index:%d;', [Container.Index + 1]);
    ABuilder.AppendFormat('visibility:%s;', [VisibilityMap[Container.Visible]]);
    Result := ABuilder.ToString;
  finally
    TdxStringBuilderManager.Release(ABuilder);
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.WriteClientData(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceExcel, sdxXLSXNodeXClientData, '');
  AWriter.WriteAttributeString('ObjectType', 'Note');

  if Container.AnchorType in [catOneCell, catAbsolute] then
    AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXSizeWithCells, '', '');
  if Container.AnchorType in [catAbsolute] then
    AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXMoveWithCells, '', '');

  AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXAnchor, '', EncodeAnchors);
  AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXAutoFill, '', 'False');
  AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXTextHAlign, '', dxXLSXVMLTextAlignHorzMap[Container.TextBox.AlignHorz]);
  AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXTextVAlign, '', dxXLSXVMLTextAlignVertMap[Container.TextBox.AlignVert]);
  AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXRow, '', IntToStr(Container.Cell.RowIndex));
  AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXColumn, '', IntToStr(Container.Cell.ColumnIndex));
  if Container.Visible then
    AWriter.WriteElementString(sdxXLSXNamespaceExcel, sdxXLSXNodeXVisible, '', '');

  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.WriteShapeAttributes(AWriter: TdxXmlWriter; AShape: TdxSpreadSheetShape);
begin
  case AShape.Brush.Style of
    gpbsSolid:
      AWriter.WriteAttributeString(sdxXLSXAttrFillColor, EncodeColor(AShape.Brush.Color));
    gpbsGradient:
      if AShape.Brush.GradientPoints.Count > 1 then
        AWriter.WriteAttributeString(sdxXLSXAttrFillColor, EncodeColor(AShape.Brush.GradientPoints.Colors[0]));
  end;

  AWriter.WriteAttributeString(sdxXLSXAttrStrokeColor, EncodeColor(AShape.Pen.Brush.Color));
  AWriter.WriteAttributeString(sdxXLSXAttrStrokeWeight, IntToStr(Round(TdxValueUnitsHelper.PixelsToPoints(AShape.Pen.Width))) + 'pt');
end;

procedure TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.WriteShapeContent(AWriter: TdxXmlWriter; AShape: TdxSpreadSheetShape);
const
  AngleMap: array[TdxGPBrushGradientMode] of Integer = (270, 180, 225, 135);
  TypeMap: array[TdxGPBrushStyle] of string = (sdxXLSXValueSolid, sdxXLSXValueGradient, sdxXLSXValueTile, sdxXLSXValueSolid);
var
  AAlpha: Byte;
  AGradientPoints: TdxGPBrushGradientPoints;
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceVML, sdxXLSXNodeVMLFill, '');
  AWriter.WriteAttributeString(sdxXLSXAttrTypeLC, TypeMap[AShape.Brush.Style]);
  case AShape.Brush.Style of
    gpbsTexture:
      AWriter.WriteAttributeString(sdxXLSXNamespaceOffice, sdxXLSXAttrRelID, '', WriteImage(AShape.Brush.Texture));

    gpbsSolid:
      begin
        AAlpha := dxGetAlpha(AShape.Brush.Color);
        if AAlpha <> MaxByte then
          AWriter.WriteAttributeString(sdxXLSXAttrOpacity, EncodeOpacity(AAlpha));
      end;

    gpbsGradient:
      begin
        AGradientPoints := AShape.Brush.GradientPoints;
        if AGradientPoints.Count > 1 then
        begin
          AWriter.WriteAttributeString(sdxXLSXAttrOpacity, EncodeOpacity(dxGetAlpha(AGradientPoints.Colors[0])));
          AWriter.WriteAttributeString(sdxXLSXAttrColor2, EncodeColor(AGradientPoints.Colors[AGradientPoints.Count - 1]));
          AWriter.WriteAttributeString(sdxXLSXNamespaceOffice, sdxXLSXAttrOpacity2,
            EncodeOpacity(dxGetAlpha(AGradientPoints.Colors[AGradientPoints.Count - 1])));
          AWriter.WriteAttributeInteger(sdxXLSXAttrAngle, AngleMap[AShape.Brush.GradientMode]);
       end;
      end;
  end;
  AWriter.WriteEndElement;

  AWriter.WriteStartElement(sdxXLSXNamespaceVML, sdxXLSXNodeVMLStroke, '');
  AWriter.WriteAttributeString(sdxXLSXAttrDashStyle, dxXLSXVMLDashStyle[AShape.Pen.Style]);
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.WriteTextBox(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceVML, sdxXLSXNodeVMLTextBox, '');

  if not cxRectIsEqual(dxEMUToPixels(dxXLSXDefaultTextPadding), Container.TextBox.ContentOffsets) then
  begin
    AWriter.WriteAttributeString(sdxXLSXAttrInset, Format('%dmm,%dmm,%dmm,%dmm', [
      TdxValueUnitsHelper.PixelsToMillimeters(Container.TextBox.ContentOffsets.Left),
      TdxValueUnitsHelper.PixelsToMillimeters(Container.TextBox.ContentOffsets.Top),
      TdxValueUnitsHelper.PixelsToMillimeters(Container.TextBox.ContentOffsets.Right),
      TdxValueUnitsHelper.PixelsToMillimeters(Container.TextBox.ContentOffsets.Bottom)]));
  end;

  if Container.TextBox.AutoSize then
    AWriter.WriteAttributeString(sdxXLSXAttrStyle, sdxXLSXMSOFitShapeToText + ':t');

  AWriter.WriteStartElement('div');
  AWriter.WriteAttributeString(sdxXLSXAttrStyle, 'text-align:' + LowerCase(dxXLSXVMLTextAlignHorzMap[Container.TextBox.AlignHorz]));
  AWriter.WriteEndElement;

  AWriter.WriteEndElement;
end;

{ TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder }

constructor TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder.Create(const ATargetFileName: string;
  AOwnerRels: TdxXLSXRelationships; AOwnerWriter: TdxXLSXWriterWorksheetTableViewBuilder);
begin
  inherited Create(AOwnerWriter.Owner, AOwnerRels, ATargetFileName);
  FOwnerWriter := AOwnerWriter;
end;

procedure TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder.ExecuteCore(AWriter: TdxXmlWriter);
var
  ARels: TdxXLSXRelationships;
begin
  ARels := TdxXLSXRelationships.Create;
  try
    AWriter.WriteStartElement('xml');

    AWriter.WriteAttributeString('xmlns', sdxXLSXNamespaceVML, '', 'urn:schemas-microsoft-com:vml');
    AWriter.WriteAttributeString('xmlns', sdxXLSXNamespaceOffice, '', 'urn:schemas-microsoft-com:office:office');
    AWriter.WriteAttributeString('xmlns', sdxXLSXNamespaceExcel, '', 'urn:schemas-microsoft-com:office:excel');

    WriteDefaults(AWriter);
    WriteShapes(AWriter, ARels);

    AWriter.WriteEndElement;

    Owner.WriteRels(TargetFileNameRels, ARels, False);
  finally
    ARels.Free;
  end;
end;

procedure TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder.WriteDefaults(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceOffice, 'shapelayout', '');
  AWriter.WriteAttributeString(sdxXLSXNamespaceVML, 'ext', '', 'edit');

  AWriter.WriteStartElement(sdxXLSXNamespaceOffice, 'idmap', '');
  AWriter.WriteAttributeInteger('data', 1);
  AWriter.WriteAttributeString(sdxXLSXNamespaceVML, 'ext', '', 'edit');
  AWriter.WriteEndElement;

  AWriter.WriteEndElement; // o:shapelayout

  AWriter.WriteStartElement(sdxXLSXNamespaceVML, 'shapetype', '');
  AWriter.WriteAttributeString('id', #0't202');
  AWriter.WriteAttributeString('coordsize', '21600,21600');
  AWriter.WriteAttributeString(sdxXLSXNamespaceOffice, 'spt', '', '202');
  AWriter.WriteAttributeString('path', 'm,l,21600r21600,l21600,xe');

  AWriter.WriteStartElement(sdxXLSXNamespaceVML, 'stroke', '');
  AWriter.WriteAttributeString('joinstyle', 'miter');
  AWriter.WriteEndElement;

  AWriter.WriteStartElement(sdxXLSXNamespaceVML, 'path', '');
  AWriter.WriteAttributeString('gradientshapeok', 't');
  AWriter.WriteAttributeString(sdxXLSXNamespaceOffice, 'connecttype', '', 'rect');
  AWriter.WriteEndElement;

  AWriter.WriteEndElement; // v:shapetype
end;

procedure TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder.WriteShapes(AWriter: TdxXmlWriter; ARels: TdxXLSXRelationships);
var
  I: Integer;
begin
  for I := 0 to Comments.Count - 1 do
    ExecuteSubTask(TdxXLSXWriterWorksheetTableViewCommentContainerBuilder.Create(Comments.List[I], AWriter, Owner, ARels));
end;

function TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXVMLDrawingRelationship;
end;

function TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder.GetContentType: string;
begin
  Result := '';
end;

function TdxXLSXWriterWorksheetTableViewLegacyDrawingBuilder.GetComments: TList;
begin
  Result := FOwnerWriter.Comments;
end;

end.
