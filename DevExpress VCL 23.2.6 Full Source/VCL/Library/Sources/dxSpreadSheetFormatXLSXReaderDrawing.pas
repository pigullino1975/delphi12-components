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

unit dxSpreadSheetFormatXLSXReaderDrawing;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, dxCore, dxCoreClasses, cxClasses, dxCustomTree, dxXMLDoc, dxZIPUtils,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxSpreadSheetStrs, dxSpreadSheetPackedFileFormatCore,
  dxSpreadSheetUtils, dxGDIPlusClasses, Generics.Defaults, Generics.Collections, dxCoreGraphics, cxGeometry, dxHashUtils, Variants,
  dxSpreadSheetPrinting, dxSpreadSheetConditionalFormattingRules, dxSpreadSheetContainers, dxSpreadSheetFormatXLSXReader,
  dxSpreadSheetHyperlinks, dxSpreadSheetCoreStyles, dxXMLReader, dxXMLReaderUtils;

const
  dxXLSXDefaultTextPadding: TRect = (Left: 91440; Top: 45720; Right: 91440; Bottom: 45720);

type

  { TdxXLSXContainerHandler }

  TdxXLSXContainerHandler = class(TdxXLSXNodeHandler)
  strict private
    FView: TdxSpreadSheetTableView;

    procedure BrushChangeHandler(Sender: TObject);
    procedure PenChangeHandler(Sender: TObject);
  protected type
  {$REGION 'Internal Types'}
    PAnchor = ^TAnchor;
    TAnchor = record
      Cell: TPoint;
      Offset: TPoint;
      procedure Reset;
    end;
  {$ENDREGION}
  protected
    FAnchor1: TAnchor;
    FAnchor2: TAnchor;
    FAnchorType: TdxSpreadSheetContainerAnchorType;
    FDescription: string;
    FEditMode: string;
    FFlipHorizontally: Boolean;
    FFlipVertically: Boolean;
    FHyperlink: TdxSpreadSheetHyperlink;
    FName: string;
    FRestrictions: TdxSpreadSheetContainerRestrictions;
    FRotationAngle: Double;
    FTitle: string;
    FVisible: Boolean;

    FPicture: TdxSpreadSheetSharedImageHandle;
    FPictureCropMargins: TRect;
    FPictureIsSet: Boolean;
    FPictureRelativeResize: Boolean;

    FShapeBrush: TdxGPBrush;
    FShapeBrushIsSet: Boolean;
    FShapePen: TdxGPPen;
    FShapePenIsSet: Boolean;
    FShapeType: TdxSpreadSheetShapeType;

    FText: TStringBuilder;
    FTextAlignHorz: TAlignment;
    FTextAlignVert: TVerticalAlignment;
    FTextAutoSize: Boolean;
    FTextContentOffsets: TRect;
    FTextIsSet: Boolean;
    FTextParagraphNumber: Integer;
    FTextRuns: TdxSpreadSheetFormattedSharedStringRuns;
    FTextWordWrap: Boolean;

    procedure ApplyAnchor(AAnchor: TdxSpreadSheetContainerAnchorPoint; const ASource: TAnchor);
    procedure ApplyAnchors(AContainer: TdxSpreadSheetContainer);
    procedure ApplyGeneralProperties(AContainer: TdxSpreadSheetContainer);
    procedure ApplyPictureProperties(AContainer: TdxSpreadSheetPictureContainer);
    procedure ApplyShapeProperties(AShape: TdxSpreadSheetShape);
    procedure ApplyTextBoxProperties(AContainer: TdxSpreadSheetTextBoxContainer);

    function ReadPoint(const AReader: TdxXmlReader; const XName, YName: string): TPoint;

    function ProcessAnchor1(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessAnchor1Offset(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessAnchor2(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessAnchor2Offset(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessBrushRef(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessDescription(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessGeometry(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessHyperlink(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessPenRef(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessPicture(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessPictureAttributes(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessPictureContainer(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessPictureCropMargins(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessRestrictions(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessTextAutoSize(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessTextBoxContainer(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessTextBoxParagraph(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessTextBoxProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessTransformProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AReader: TdxXmlReader; AOwner, AData: TObject); reintroduce;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    //
    property View: TdxSpreadSheetTableView read FView;
  end;

  { TdxXLSXDrawingReader }

  TdxXLSXDrawingReader = class(TdxXLSXCustomDocumentReader)
  strict private
    FView: TdxSpreadSheetTableView;

    function CreateContainerHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(const AFileName: string; AOwner: TdxSpreadSheetXLSXReader; AView: TdxSpreadSheetTableView); reintroduce;
  end;

implementation

uses
  AnsiStrings, Math, dxColorPicker, cxGraphics, dxSpreadSheetGraphics, dxSpreadSheetFormulas,
  dxSpreadSheetFormatXLSX, dxSpreadSheetFormatXLSXTags, dxSpreadSheetFormatUtils, dxSpreadSheetCoreStrs,
  dxSpreadSheetFormatXLSXReaderStyles, StrUtils, dxSpreadSheetFormatXLSXUtils;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXReaderDrawing';

type
  TdxSpreadSheetCustomReaderAccess = class(TdxSpreadSheetCustomReader);
  TdxSpreadSheetPictureAccess = class(TdxSpreadSheetPicture);
  TdxSpreadSheetXLSXReaderAccess = class(TdxSpreadSheetXLSXReader);
  TdxXLSXDocumentReaderAccess = class(TdxXLSXCustomDocumentReader);

  { TdxXLSXContainerAnchorHandler }

  TdxXLSXContainerAnchorHandler = class(TdxXLSXNodeHandler)
  strict private
    FAnchor: TdxXLSXContainerHandler.PAnchor;

    procedure ProcessColumn(const AText: string);
    procedure ProcessColumnOffset(const AText: string);
    procedure ProcessRow(const AText: string);
    procedure ProcessRowOffset(const AText: string);
  public
    constructor Create(AOwner: TdxXLSXCustomDocumentReader; AAnchor: TdxXLSXContainerHandler.PAnchor); reintroduce; overload;
    constructor Create(AOwner, AData: TObject); overload; override;
  end;

  { TdxXLSXContainerHyperlinkHandler }

  TdxXLSXContainerHyperlinkHandler = class(TdxXLSXHyperlinkHandler)
  protected
    function ReadValue(AReader: TdxXmlReader): string; override;
  end;

  { TdxXLSXTextBoxTextHandler }

  TdxXLSXTextBoxTextHandler = class(TdxXLSXFormattedTextHandler)
  strict private
    FOwner: TdxXLSXContainerHandler;

    function ProcessTextBoxParagraphProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner: TdxXLSXContainerHandler; const ANamespace: AnsiString;
      ARuns: TdxSpreadSheetFormattedSharedStringRuns; AText: TStringBuilder); reintroduce;
  end;

  { TdxXLSXTextBoxTextFontHandler }

  TdxXLSXTextBoxTextFontHandler = class(TdxXLSXFormattedTextFontHandler)
  strict private
    FColor: TdxAlphaColor;

    function ProcessColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessName(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

{ TdxXLSXDrawingReader }

constructor TdxXLSXDrawingReader.Create(const AFileName: string; AOwner: TdxSpreadSheetXLSXReader; AView: TdxSpreadSheetTableView);
begin
  FView := AView;
  inherited Create(AFileName, AOwner);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeAnchorAbsolute, CreateContainerHandler); 
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeAnchorOneCell, CreateContainerHandler); 
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeAnchorTwoCell, CreateContainerHandler); 
end;

function TdxXLSXDrawingReader.CreateContainerHandler(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXContainerHandler.Create(AReader, Self, FView);
end;

{ TdxXLSXContainerHandler }

constructor TdxXLSXContainerHandler.Create(AReader: TdxXmlReader; AOwner, AData: TObject);
begin
  inherited Create(AOwner, AData);
  FAnchor1.Reset;
  FAnchor2.Reset;
  FShapePen := TdxGPPen.Create;
  FShapePen.OnChange := PenChangeHandler;
  FShapeBrush := TdxGPBrush.Create;
  FShapeBrush.OnChange := BrushChangeHandler;
  FPictureRelativeResize := True;
  FText := TStringBuilder.Create;
  FTextRuns := TdxSpreadSheetFormattedSharedStringRuns.Create;
  FEditMode := AReader.GetAttribute(sdxXLSXAttrEditAs);
  FView := AData as TdxSpreadSheetTableView;
end;

destructor TdxXLSXContainerHandler.Destroy;
begin
  FreeAndNil(FShapeBrush);
  FreeAndNil(FShapePen);
  FreeAndNil(FTextRuns);
  FreeAndNil(FText);
  inherited;
end;

procedure TdxXLSXContainerHandler.AfterConstruction;
begin
  inherited;

  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeAnchorFrom, ProcessAnchor1);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeAnchorTo, ProcessAnchor2);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeExt, ProcessAnchor2Offset);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodePos, ProcessAnchor1Offset);

  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeBodyProperties, ProcessTextBoxProperties);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingAttributeSourceRect, ProcessPictureCropMargins);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingBlip, ProcessPicture);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingPictureLocks, ProcessRestrictions);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingShapeGeometry, ProcessGeometry);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingShapeHLink, ProcessHyperlink);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingShapeLocks, ProcessRestrictions);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingXForm, ProcessTransformProperties);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingBlipFill, Skip);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingDescription, ProcessDescription);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPictureAttributes, ProcessPictureAttributes);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPictureContainer, ProcessPictureContainer);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPictureDescription, Skip);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapeContainer, Skip);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapeDescription, Skip);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapeProperties, Skip);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapePropertiesEx, Skip);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingTextBody, ProcessTextBoxContainer);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapeGroup, Skip);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingStyle, Skip);

  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeGradientFill, TdxXLSXGradientBrushHandler, FShapeBrush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeLine, TdxXLSXPenHandler, FShapePen);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeNoFill, TdxXLSXEmptyBrushHandler, FShapeBrush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodePatternFill, TdxXLSXPatternBrushHandler, FShapeBrush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeSolidFill, TdxXLSXSolidBrushHandler, FShapeBrush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeTexturedFill, TdxXLSXTexturedBrushHandler, FShapeBrush);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeFillRef, ProcessBrushRef);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeLineRef, ProcessPenRef);

  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeParagraph, ProcessTextBoxParagraph);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeSpAutoFit, ProcessTextAutoSize);
end;

procedure TdxXLSXContainerHandler.BeforeDestruction;
var
  AContainer: TdxSpreadSheetContainer;
  AContainerClass: TdxSpreadSheetContainerClass;
begin
  inherited;

  if FPictureIsSet then
    AContainerClass := TdxSpreadSheetPictureContainer
  else if FTextIsSet then
    AContainerClass := TdxSpreadSheetTextBoxContainer
  else
    AContainerClass := TdxSpreadSheetShapeContainer;

  AContainer := FView.Containers.Add(AContainerClass);
  AContainer.BeginUpdate;
  try
    ApplyAnchors(AContainer);
    ApplyGeneralProperties(AContainer);
    if AContainer is TdxSpreadSheetShapeContainer then
      ApplyShapeProperties(TdxSpreadSheetShapeContainer(AContainer).Shape);
    if AContainer is TdxSpreadSheetPictureContainer then
      ApplyPictureProperties(TdxSpreadSheetPictureContainer(AContainer));
    if AContainer is TdxSpreadSheetTextBoxContainer then
      ApplyTextBoxProperties(TdxSpreadSheetTextBoxContainer(AContainer));
  finally
    AContainer.EndUpdate;
  end;
end;

procedure TdxXLSXContainerHandler.ApplyAnchor(AAnchor: TdxSpreadSheetContainerAnchorPoint; const ASource: TAnchor);
begin
  if not cxPointIsEqual(ASource.Cell, cxInvalidPoint) then
    AAnchor.Cell := FView.CreateCell(ASource.Cell.Y, ASource.Cell.X);
  if not cxPointIsEqual(ASource.Offset, cxInvalidPoint) then
    AAnchor.Offset := ASource.Offset;
end;

procedure TdxXLSXContainerHandler.ApplyAnchors(AContainer: TdxSpreadSheetContainer);
begin
  AContainer.AnchorType := FAnchorType;
  ApplyAnchor(AContainer.AnchorPoint1, FAnchor1);
  ApplyAnchor(AContainer.AnchorPoint2, FAnchor2);

  if FAnchorType <> catAbsolute then
  begin
    AContainer.AnchorPoint1.FixedToCell := (FEditMode = '') or SameText(FEditMode, sdxXLSXValueEditAsOneCell) or SameText(FEditMode, sdxXLSXValueEditAsTwoCell);
    AContainer.AnchorPoint2.FixedToCell := (FEditMode = '') or SameText(FEditMode, sdxXLSXValueEditAsTwoCell);
  end;
end;

procedure TdxXLSXContainerHandler.ApplyGeneralProperties(AContainer: TdxSpreadSheetContainer);
begin
  AContainer.Description := FDescription;
  AContainer.Title := FTitle;
  AContainer.Name := FName;
  AContainer.Visible := FVisible;
  AContainer.Restrictions := FRestrictions;
  AContainer.Transform.FlipHorizontally := FFlipHorizontally;
  AContainer.Transform.FlipVertically := FFlipVertically;
  AContainer.Transform.RotationAngle := FRotationAngle;
  AContainer.Hyperlink := FHyperlink;
end;

procedure TdxXLSXContainerHandler.ApplyPictureProperties(AContainer: TdxSpreadSheetPictureContainer);
begin
  AContainer.RelativeResize := FPictureRelativeResize;
  AContainer.Picture.CropMargins := FPictureCropMargins;
  if FPicture <> nil then
    TdxSpreadSheetPictureAccess(AContainer.Picture).ImageHandle := FPicture;
end;

procedure TdxXLSXContainerHandler.ApplyShapeProperties(AShape: TdxSpreadSheetShape);
begin
  AShape.ShapeType := FShapeType;
  AShape.Brush.Assign(FShapeBrush);
  AShape.Pen.Assign(FShapePen);
end;

procedure TdxXLSXContainerHandler.ApplyTextBoxProperties(AContainer: TdxSpreadSheetTextBoxContainer);
begin
  AContainer.TextBox.AutoSize := FTextAutoSize;
  AContainer.TextBox.AlignHorz := FTextAlignHorz;
  AContainer.TextBox.AlignVert := FTextAlignVert;
  AContainer.TextBox.ContentOffsets := FTextContentOffsets;
  AContainer.TextBox.WordWrap := FTextWordWrap;
  AContainer.TextBox.Text := TdxSpreadSheetCustomReaderAccess(Owner.Owner).AddSharedString(FText.ToString, FTextRuns);
  if FTextRuns.Count > 0 then
    AContainer.TextBox.Font.Handle := FTextRuns[0].FontHandle;
end;

function TdxXLSXContainerHandler.ReadPoint(const AReader: TdxXmlReader; const XName, YName: string): TPoint;
begin
  try
    Result.X := dxEMUToPixels(StrToInt64(AReader.GetAttribute(XName)));
    Result.Y := dxEMUToPixels(StrToInt64(AReader.GetAttribute(YName)));
  except
    DoError(sdxErrorInvalidAnchorDefinition, ssmtWarning);
    Result := cxNullPoint;
  end;
end;

function TdxXLSXContainerHandler.ProcessAnchor1(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FAnchor1.Reset;
  FAnchorType := catOneCell;
  Result := TdxXLSXContainerAnchorHandler.Create(Owner, @FAnchor1);
end;

function TdxXLSXContainerHandler.ProcessAnchor1Offset(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FAnchorType := catAbsolute;
  FAnchor1.Reset;
  FAnchor1.Offset := ReadPoint(AReader, sdxXLSXAttrCoordX, sdxXLSXAttrCoordY);
  Result := nil;
end;

function TdxXLSXContainerHandler.ProcessAnchor2(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FAnchor2.Reset;
  FAnchorType := catTwoCell;
  Result := TdxXLSXContainerAnchorHandler.Create(Owner, @FAnchor2);
end;

function TdxXLSXContainerHandler.ProcessAnchor2Offset(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FAnchor2.Reset;
  FAnchor2.Offset := ReadPoint(AReader, sdxXLSXAttrCoordExtX, sdxXLSXAttrCoordExtY);
  Result := nil;
end;

function TdxXLSXContainerHandler.ProcessBrushRef(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  ABrush: TdxGPBrush;
begin
  if not FShapeBrushIsSet then
  begin
    if Owner.Owner.ThemeData.TryGetBrush(AReader.GetAttributeAsInteger(sdxXLSXAttrRefIndex), ABrush) then
      FShapeBrush.Assign(ABrush);
  end;
  Result := nil;
end;

function TdxXLSXContainerHandler.ProcessDescription(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := Self;
  FName := AReader.GetAttribute(sdxXLSXAttrName);
  FDescription := AReader.GetAttribute(sdxXLSXAttrAlternateText);
  FTitle := AReader.GetAttribute(sdxXLSXAttrTitle);
  FVisible := not AReader.GetAttributeAsBoolean(sdxXLSXAttrHidden);
end;

function TdxXLSXContainerHandler.ProcessGeometry(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := nil;
  FShapeType := TdxSpreadSheetXLSXHelper.StringToShapeType(AReader.GetAttribute(sdxXLSXAttrPreset));
end;

function TdxXLSXContainerHandler.ProcessHyperlink(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if FHyperlink = nil then
    FHyperlink := View.Hyperlinks.Add(cxInvalidRect);
  Result := TdxXLSXContainerHyperlinkHandler.Create(Owner, FHyperlink);
end;

function TdxXLSXContainerHandler.ProcessPenRef(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  APen: TdxGPPen;
begin
  if not FShapePenIsSet then
  begin
    if Owner.Owner.ThemeData.TryGetPen(AReader.GetAttributeAsInteger(sdxXLSXAttrRefIndex), APen) then
      FShapePen.Assign(APen);
  end;
  Result := nil;
end;

function TdxXLSXContainerHandler.ProcessPicture(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  ADocumentReader: TdxSpreadSheetXLSXReaderAccess;
  AItem: TdxXLSXRelationship;
  APictureId: string;
  AStream: TStream;
begin
  Result := nil;

  APictureId := AReader.GetAttribute(sdxXLSXNamespaceRelationship, sdxXLSXAttrDrawingResourceEmbed, '');
  if Owner.Rels.Find(APictureId, AItem) then
  begin
    ADocumentReader := TdxSpreadSheetXLSXReaderAccess(Owner.Owner);
    if ADocumentReader.FEmbeddedImageIndex.TryGetValue(AItem.Target, TObject(FPicture)) then
      Exit;
    if ADocumentReader.FileExists(AItem.Target) then
    begin
      AStream := ADocumentReader.ReadFile(AItem.Target);
      try
        FPicture := ADocumentReader.AddImage(AStream);
        ADocumentReader.FEmbeddedImageIndex.Add(AItem.Target, FPicture);
      finally
        AStream.Free;
      end;
    end
    else
      DoError(sdxErrorPictureCannotBeFound, [Owner.FileName + ':' + AItem.Target], ssmtWarning);
  end
  else
    DoError(sdxErrorPictureCannotBeFound, [Owner.FileName + ':' + APictureId], ssmtWarning);
end;

function TdxXLSXContainerHandler.ProcessPictureAttributes(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AValue: string;
begin
  AValue := AReader.GetAttribute(sdxXLSXAttrPreferRelativeResize);
  if AValue <> '' then
    FPictureRelativeResize := TdxXMLHelper.DecodeBoolean(AValue);
  Result := Self;
end;

function TdxXLSXContainerHandler.ProcessPictureContainer(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FPictureIsSet := True;
  Result := Self;
end;

function TdxXLSXContainerHandler.ProcessPictureCropMargins(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FPictureCropMargins := TdxXLSXUtils.DecodeSourceRect(cxRect(
    AReader.GetAttributeAsInteger('l'), AReader.GetAttributeAsInteger('t'),
    AReader.GetAttributeAsInteger('r'), AReader.GetAttributeAsInteger('b')));
  Result := nil;
end;

function TdxXLSXContainerHandler.ProcessRestrictions(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AIndex: TdxSpreadSheetContainerRestriction;
begin
  for AIndex := Low(TdxSpreadSheetContainerRestriction) to High(TdxSpreadSheetContainerRestriction) do
  begin
    if AReader.GetAttributeAsBoolean(dxXLSXRestrictionNames[AIndex]) then
      Include(FRestrictions, AIndex)
    else
      Exclude(FRestrictions, AIndex);
  end;
  Result := Self;
end;

function TdxXLSXContainerHandler.ProcessTextAutoSize(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FTextAutoSize := True;
  Result := nil;
end;

function TdxXLSXContainerHandler.ProcessTextBoxContainer(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FTextIsSet := True;
  Result := Self;
end;

function TdxXLSXContainerHandler.ProcessTextBoxParagraph(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Inc(FTextParagraphNumber);
  if FTextParagraphNumber > 1 then
    FText.Append(#13#10);
  Result := TdxXLSXTextBoxTextHandler.Create(Self, 'a', FTextRuns, FText);
end;

function TdxXLSXContainerHandler.ProcessTextBoxProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FTextAlignVert := TdxSpreadSheetXLSXHelper.StringToVerticalAlignment(AReader.GetAttribute(sdxXLSXAttrAnchor));
  FTextContentOffsets := Rect(
    dxEMUToPixels(AReader.GetAttributeAsInt64(sdxXLSXAttrLeftInset, dxXLSXDefaultTextPadding.Left)),
    dxEMUToPixels(AReader.GetAttributeAsInt64(sdxXLSXAttrTopInset, dxXLSXDefaultTextPadding.Top)),
    dxEMUToPixels(AReader.GetAttributeAsInt64(sdxXLSXAttrRightInset, dxXLSXDefaultTextPadding.Right)),
    dxEMUToPixels(AReader.GetAttributeAsInt64(sdxXLSXAttrBottomInset, dxXLSXDefaultTextPadding.Bottom)));
  FTextWordWrap := AReader.GetAttribute(sdxXLSXAttrWrap) <> sdxXLSXValueNone;
  Result := Self;
end;

function TdxXLSXContainerHandler.ProcessTransformProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FRotationAngle := TdxXLSXUtils.DecodePositiveFixedAngle(AReader.GetAttributeAsInteger(sdxXLSXAttrRot));
  FFlipHorizontally := AReader.GetAttributeAsBoolean(sdxXLSXAttrFlipH);
  FFlipVertically := AReader.GetAttributeAsBoolean(sdxXLSXAttrFlipV);
  Result := nil;
end;

procedure TdxXLSXContainerHandler.BrushChangeHandler(Sender: TObject);
begin
  FShapeBrushIsSet := True;
end;

procedure TdxXLSXContainerHandler.PenChangeHandler(Sender: TObject);
begin
  FShapePenIsSet := True;
end;

{ TdxXLSXContainerHandler.TAnchor }

procedure TdxXLSXContainerHandler.TAnchor.Reset;
begin
  Cell := cxInvalidPoint;
  Offset := cxNullPoint;
end;

{ TdxXLSXContainerAnchorHandler }

constructor TdxXLSXContainerAnchorHandler.Create(AOwner: TdxXLSXCustomDocumentReader; AAnchor: TdxXLSXContainerHandler.PAnchor);
begin
  FAnchor := AAnchor;
  inherited Create(AOwner, nil);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPosMarkerColumn, ProcessColumn);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPosMarkerColumnOffset, ProcessColumnOffset);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPosMarkerRow, ProcessRow);
  Handlers.Add(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPosMarkerRowOffset, ProcessRowOffset);
end;

constructor TdxXLSXContainerAnchorHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FAnchor := (AData as TdxXLSXContainerAnchorHandler).FAnchor;
end;

procedure TdxXLSXContainerAnchorHandler.ProcessColumn(const AText: string);
begin
  FAnchor^.Cell.X := StrToInt(AText);
end;

procedure TdxXLSXContainerAnchorHandler.ProcessColumnOffset(const AText: string);
begin
  FAnchor^.Offset.X := dxEMUToPixels(StrToInt64(AText));
end;

procedure TdxXLSXContainerAnchorHandler.ProcessRow(const AText: string);
begin
  FAnchor^.Cell.Y := StrToInt(AText);
end;

procedure TdxXLSXContainerAnchorHandler.ProcessRowOffset(const AText: string);
begin
  FAnchor^.Offset.Y := dxEMUToPixels(StrToInt64(AText));
end;

{ TdxXLSXContainerHyperlinkHandler }

function TdxXLSXContainerHyperlinkHandler.ReadValue(AReader: TdxXmlReader): string;
var
  ARelsItem: TdxXLSXRelationship;
  AValue: string;
begin
  Result := '';
  if AReader.TryGetAttribute(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '', AValue) then
  begin
    if Owner.Rels.Find(AValue, ARelsItem) then
      Result := ARelsItem.Target;
    if StartsStr('#', Result) then
      Result[1] := '=';
  end;
end;

{ TdxXLSXTextBoxTextHandler }

constructor TdxXLSXTextBoxTextHandler.Create(AOwner: TdxXLSXContainerHandler;
  const ANamespace: AnsiString; ARuns: TdxSpreadSheetFormattedSharedStringRuns; AText: TStringBuilder);
begin
  FOwner := AOwner;
  inherited Create(AOwner.Owner, ANamespace, ARuns, AText);
  Handlers.Add(ANamespace, sdxXLSXNodeRichTextRunParagraph, TdxXLSXTextBoxTextFontHandler, Self);
  Handlers.Add(ANamespace, sdxXLSXNodeRichTextParagraphProperties, ProcessTextBoxParagraphProperties);
end;

function TdxXLSXTextBoxTextHandler.ProcessTextBoxParagraphProperties(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if FOwner.FTextParagraphNumber = 1 then
    FOwner.FTextAlignHorz := TdxSpreadSheetXLSXHelper.StringToAlignment(AReader.GetAttribute(sdxXLSXAttrAlign));
  Result := Self;
end;

{ TdxXLSXTextBoxTextFontHandler }

constructor TdxXLSXTextBoxTextFontHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FColor := TdxAlphaColors.Default;
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeLatin, ProcessName);
  Handlers.Add(sdxXLSXNamespaceDrawing, sdxXLSXNodeSolidFill, ProcessColor);
end;

procedure TdxXLSXTextBoxTextFontHandler.BeforeDestruction;
begin
  FHandle.Color := dxAlphaColorToColor(FColor);
  inherited;
end;

procedure TdxXLSXTextBoxTextFontHandler.OnAttributes(const AReader: TdxXmlReader);
var
  AStyle: TFontStyle;
  AValue: string;
begin
  for AStyle := Low(AStyle) to High(AStyle) do
  begin
    if AReader.GetAttributeAsBoolean(dxXLSXFontStyles[AStyle]) then
      Include(FHandle.Style, AStyle);
  end;

  AValue := AReader.GetAttribute(dxXLSXFontStyles[fsUnderline]);
  if (AValue <> '') and (AValue <> 'none') then
    Include(FHandle.Style, fsUnderline);

  AValue := AReader.GetAttribute(sdxXLSXNodeSZ);
  if AValue <> '' then
    FHandle.Size := StrToInt64Def(AValue, 0) div 100;
end;

function TdxXLSXTextBoxTextFontHandler.ProcessColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXAdvancedColorHandler.Create(Owner, @FColor);
end;

function TdxXLSXTextBoxTextFontHandler.ProcessName(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AValue: string;
begin
  AValue := AReader.GetAttribute(sdxXLSXAttrTypeface);
  if AValue <> '' then
    FHandle.Name := AValue;
  Result := nil;
end;

end.
