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

unit dxSpreadSheetFormatXLSXWriterDrawing;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics,
  dxCore, dxCoreClasses, cxClasses, dxCustomTree, dxXMLDoc, dxZIPUtils, cxGeometry, dxGenerics, dxXMLWriter,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxSpreadSheetStrs, dxSpreadSheetPackedFileFormatCore,
  dxSpreadSheetUtils, dxSpreadSheetGraphics, Generics.Defaults, Generics.Collections, dxGDIPlusClasses, dxCoreGraphics,
  dxSpreadSheetPrinting, dxSpreadSheetConditionalFormattingRules, dxSpreadSheetContainers, dxSpreadSheetFormatXLSXWriter,
  dxSpreadSheetHyperlinks, dxSpreadSheetCoreStyles, dxSpreadSheetFormatXLSXUtils;

type

  { TdxXLSXWriterCustomContainerBuilder }

  TdxXLSXWriterCustomContainerBuilderClass = class of TdxXLSXWriterCustomContainerBuilder;
  TdxXLSXWriterCustomContainerBuilder = class(TdxXLSXWriterCustomBuilder)
  strict private
    FContainer: TdxSpreadSheetContainer;
    FWriter: TdxXmlWriter;

    procedure WriteAnchor(AWriter: TdxXmlWriter; const AName: string; AAnchor: TdxSpreadSheetContainerAnchorPoint);
    procedure WritePoint(AWriter: TdxXmlWriter; const AValue: TPoint; const Name, XName, YName: string);
  protected
    procedure WriteContent(AWriter: TdxXmlWriter); virtual; abstract;
    procedure WriteFooter(AWriter: TdxXmlWriter); virtual;
    procedure WriteHeader(AWriter: TdxXmlWriter); virtual;
  public
    constructor Create(AContainer: TdxSpreadSheetContainer;
      AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships; AWriter: TdxXmlWriter);
    procedure Execute; override;
    //
    property Container: TdxSpreadSheetContainer read FContainer;
    property Writer: TdxXmlWriter read FWriter;
  end;

  { TdxXLSXWriterCustomShapeContainerBuilder }

  TdxXLSXWriterCustomShapeContainerBuilder = class(TdxXLSXWriterCustomContainerBuilder)
  strict private
    function GetContainer: TdxSpreadSheetShapeContainer; inline;
  protected
    // Brushes
    procedure WriteColor(AWriter: TdxXmlWriter; AAlphaColor: TdxAlphaColor); virtual;
    procedure WriteGradientBrushParameters(AWriter: TdxXmlWriter; ABrush: TdxGPBrush); virtual;
    procedure WriteSolidBrushParameters(AWriter: TdxXmlWriter; ABrush: TdxGPBrush); virtual;
    procedure WriteTextureBrushParameters(AWriter: TdxXmlWriter; ABrush: TdxGPBrush); virtual;

    procedure WriteBlip(AWriter: TdxXmlWriter; AImage: TdxGPImage); virtual;
    procedure WriteDescription(AWriter: TdxXmlWriter); virtual;
    procedure WriteHyperlink(AWriter: TdxXmlWriter; AHyperlink: TdxSpreadSheetHyperlink); virtual;
    procedure WriteRestrictionsContent(AWriter: TdxXmlWriter); virtual;
    procedure WriteShapeFillParameters(AWriter: TdxXmlWriter; ABrush: TdxGPBrush); virtual;
    procedure WriteShapeGeometry(AWriter: TdxXmlWriter); virtual;
    procedure WriteShapeLineParameters(AWriter: TdxXmlWriter; APen: TdxGPPen); virtual;
    procedure WriteShapeProperties(AWriter: TdxXmlWriter); virtual;
    procedure WriteTransform(AWriter: TdxXmlWriter);
  public
    property Container: TdxSpreadSheetShapeContainer read GetContainer;
  end;

  { TdxXLSXWriterShapeContainerBuilder }

  TdxXLSXWriterShapeContainerBuilder = class(TdxXLSXWriterCustomShapeContainerBuilder)
  protected
    procedure WriteContent(AWriter: TdxXmlWriter); override;
    procedure WriteShapeContent(AWriter: TdxXmlWriter); virtual;
    procedure WriteShapeDescription(AWriter: TdxXmlWriter); virtual;
    procedure WriteShapePropertiesEx(AWriter: TdxXmlWriter); virtual;
    procedure WriteShapePropertiesExContent(AWriter: TdxXmlWriter); virtual;
  end;

  { TdxXLSXWriterTextBoxContainerBuilder }

  TdxXLSXWriterTextBoxContainerBuilder = class(TdxXLSXWriterShapeContainerBuilder)
  strict private
    function GetContainer: TdxSpreadSheetTextBoxContainer; inline;
  protected
    procedure WriteShapeContent(AWriter: TdxXmlWriter); override;
    procedure WriteShapePropertiesExContent(AWriter: TdxXmlWriter); override;
    procedure WriteTextBoxBody(AWriter: TdxXmlWriter; ATextBox: TdxSpreadSheetTextBox);
    procedure WriteTextBoxBodyData(AWriter: TdxXmlWriter; ATextBox: TdxSpreadSheetTextBox);
    procedure WriteTextBoxBodyParagraphInfo(AWriter: TdxXmlWriter; AFont: TdxSpreadSheetFontHandle);
    procedure WriteTextBoxBodyProperties(AWriter: TdxXmlWriter; ATextBox: TdxSpreadSheetTextBox);
  public
    property Container: TdxSpreadSheetTextBoxContainer read GetContainer;
  end;

  { TdxXLSXWriterPictureContainerBuilder }

  TdxXLSXWriterPictureContainerBuilder = class(TdxXLSXWriterCustomShapeContainerBuilder)
  strict private
    function GetContainer: TdxSpreadSheetPictureContainer; inline;
  protected
    procedure WriteContent(AWriter: TdxXmlWriter); override;
    procedure WritePictureDescription(AWriter: TdxXmlWriter); virtual;
    procedure WritePictureResource(AWriter: TdxXmlWriter); virtual;
  public
    property Container: TdxSpreadSheetPictureContainer read GetContainer;
  end;

  { TdxXLSXWriterWorksheetContainersBuilder }

  TdxXLSXWriterWorksheetContainersBuilder = class(TdxXLSXWriterCustomXMLBuilder)
  protected
    FBuilderFactory: TdxClassDictionary<TdxXLSXWriterCustomContainerBuilderClass>;
    FContainers: TList;

    function GetContentRelationship: string; override;
    function GetContentType: string; override;
  public
    constructor Create(const ATargetFileName: string; AContainers: TList;
      AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships);
    destructor Destroy; override;
    procedure ExecuteCore(AWriter: TdxXmlWriter); override;
  end;

implementation

uses
  AnsiStrings, Math, TypInfo, StrUtils, dxColorPicker, cxGraphics, dxHashUtils, dxTypeHelpers,
  dxSpreadSheetFormulas, dxSpreadSheetFormatXLSXTags, dxSpreadSheetFormatXLSX, dxSpreadSheetFormatUtils,
  dxSpreadSheetConditionalFormattingIconSet, dxSpreadSheetCoreStrs;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXWriterDrawing';

const
  sMsgWrongDataType = 'wrong data type';

type
  TdxSpreadSheetContainerAccess = class(TdxSpreadSheetContainer);
  TdxSpreadSheetRelsWriterAccess = class(TdxXLSXRelationships);

{ TdxXLSXWriterCustomContainerBuilder }

constructor TdxXLSXWriterCustomContainerBuilder.Create(AContainer: TdxSpreadSheetContainer;
  AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships; AWriter: TdxXmlWriter);
begin
  inherited Create(AOwner, AOwnerRels);
  FContainer := AContainer;
  FWriter := AWriter;
end;

procedure TdxXLSXWriterCustomContainerBuilder.Execute;
begin
  WriteHeader(Writer);
  WriteContent(Writer);
  WriteFooter(Writer);
end;

procedure TdxXLSXWriterCustomContainerBuilder.WriteFooter(AWriter: TdxXmlWriter);
begin
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterCustomContainerBuilder.WriteHeader(AWriter: TdxXmlWriter);
begin
  case Container.AnchorType of
    catOneCell:
      begin
        AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeAnchorOneCell, '');
        WriteAnchor(AWriter, sdxXLSXNodeAnchorFrom, Container.AnchorPoint1);
        WritePoint(AWriter, Container.AnchorPoint2.Offset, sdxXLSXNodeExt, sdxXLSXAttrCoordExtX, sdxXLSXAttrCoordExtY);
      end;

    catTwoCell:
      begin
        AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeAnchorTwoCell, '');

        if not Container.AnchorPoint1.FixedToCell then
          AWriter.WriteAttributeString(sdxXLSXAttrEditAs, sdxXLSXValueEditAsAbsolute)
        else if Container.AnchorPoint2.FixedToCell then
          AWriter.WriteAttributeString(sdxXLSXAttrEditAs, sdxXLSXValueEditAsTwoCell)
        else
          AWriter.WriteAttributeString(sdxXLSXAttrEditAs, sdxXLSXValueEditAsOneCell);

        WriteAnchor(AWriter, sdxXLSXNodeAnchorFrom, Container.AnchorPoint1);
        WriteAnchor(AWriter, sdxXLSXNodeAnchorTo, Container.AnchorPoint2);
      end;

  else
    begin
      AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeAnchorAbsolute, '');
      WritePoint(AWriter, Container.AnchorPoint1.Offset, sdxXLSXNodePos, sdxXLSXAttrCoordX, sdxXLSXAttrCoordY);
      WritePoint(AWriter, Container.AnchorPoint2.Offset, sdxXLSXNodeExt, sdxXLSXAttrCoordExtX, sdxXLSXAttrCoordExtY);
    end;
  end;
end;

procedure TdxXLSXWriterCustomContainerBuilder.WriteAnchor(
  AWriter: TdxXmlWriter; const AName: string; AAnchor: TdxSpreadSheetContainerAnchorPoint);

  function GetCellColumnIndex(AValue: TdxSpreadSheetCell): Integer;
  begin
    if AValue <> nil then
      Result := AValue.ColumnIndex
    else
      Result := 0;
  end;

  function GetCellRowIndex(AValue: TdxSpreadSheetCell): Integer;
  begin
    if AValue <> nil then
      Result := AValue.RowIndex
    else
      Result := 0;
  end;

begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, AName, '');
  try
    AWriter.WriteElementString(sdxXLSXNamespaceDrawingSpreadSheet,
      sdxXLSXNodeDrawingPosMarkerColumn, '', IntToStr(GetCellColumnIndex(AAnchor.Cell)));
    AWriter.WriteElementString(sdxXLSXNamespaceDrawingSpreadSheet,
      sdxXLSXNodeDrawingPosMarkerColumnOffset, '', IntToStr(dxPixelsToEMU(AAnchor.Offset.X)));

    AWriter.WriteElementString(sdxXLSXNamespaceDrawingSpreadSheet,
      sdxXLSXNodeDrawingPosMarkerRow, '' , IntToStr(GetCellRowIndex(AAnchor.Cell)));
    AWriter.WriteElementString(sdxXLSXNamespaceDrawingSpreadSheet,
      sdxXLSXNodeDrawingPosMarkerRowOffset, '', IntToStr(dxPixelsToEMU(AAnchor.Offset.Y)));
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterCustomContainerBuilder.WritePoint(
  AWriter: TdxXmlWriter; const AValue: TPoint; const Name, XName, YName: string);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, Name, '');
  AWriter.WriteAttributeString(XName, IntToStr(dxPixelsToEMU(AValue.X)));
  AWriter.WriteAttributeString(YName, IntToStr(dxPixelsToEMU(AValue.Y)));
  AWriter.WriteEndElement;
end;

{ TdxXLSXWriterCustomShapeContainerBuilder }

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteColor(AWriter: TdxXmlWriter; AAlphaColor: TdxAlphaColor);
var
  AAlpha: Byte;
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesCustomColor, '');
  AWriter.WriteAttributeString(sdxXLSXAttrVal, TdxAlphaColors.ToHexCode(AAlphaColor));

  AAlpha := dxGetAlpha(AAlphaColor);
  if AAlpha <> MaxByte then
  begin
    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeColorAlpha, '');
    AWriter.WriteAttributeInteger(sdxXLSXAttrVal, TdxXLSXUtils.EncodeColorAlpha(AAlpha));
    AWriter.WriteEndElement;
  end;

  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteGradientBrushParameters(AWriter: TdxXmlWriter; ABrush: TdxGPBrush);

  procedure WriteGradientPoint(AOffset: Single; AColor: TdxAlphaColor);
  begin
    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeGradientPoint, '');
    AWriter.WriteAttributeInteger(sdxXLSXAttrGradientPointPos, TdxXLSXUtils.EncodePercents(AOffset) * 100);
    WriteColor(AWriter, AColor);
    AWriter.WriteEndElement;
  end;

const
  AnglesMap: array[TdxGPBrushGradientMode] of Integer = (0, 90, 45, 135);
var
  I: Integer;
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeGradientFill, '');
  try
    if ABrush.GradientPoints.Count > 0 then
    begin
      AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeGradientPoints, '');
      if not SameValue(ABrush.GradientPoints.Offsets[0], 0) then
        WriteGradientPoint(0, TdxAlphaColors.Empty);
      for I := 0 to ABrush.GradientPoints.Count - 1 do
        WriteGradientPoint(ABrush.GradientPoints.Offsets[I], ABrush.GradientPoints.Colors[I]);
      if not SameValue(ABrush.GradientPoints.Offsets[ABrush.GradientPoints.Count - 1], 1) then
        WriteGradientPoint(1, TdxAlphaColors.Empty);
      AWriter.WriteEndElement;

      AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeLinearGradientFill, '');
      AWriter.WriteAttributeInteger(sdxXLSXAttrAng, TdxXLSXUtils.EncodePositiveFixedAngle(AnglesMap[ABrush.GradientMode]));
      AWriter.WriteAttributeInteger(sdxXLSXAttrScaled, 1);
      AWriter.WriteEndElement;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteSolidBrushParameters(AWriter: TdxXmlWriter; ABrush: TdxGPBrush);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeSolidFill, '');
  try
    WriteColor(AWriter, ABrush.Color);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteTextureBrushParameters(AWriter: TdxXmlWriter; ABrush: TdxGPBrush);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeTexturedFill, '');
  try
    AWriter.WriteAttributeInteger(sdxXLSXAttrRotateWithShape, 1);

    WriteBlip(AWriter, ABrush.Texture);

    AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingAttributeSourceRect, '', '');

    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeTile, '');
    AWriter.WriteAttributeInteger(sdxXLSXAttrTileTX, 0);
    AWriter.WriteAttributeInteger(sdxXLSXAttrTileTY, 0);
    AWriter.WriteAttributeInteger(sdxXLSXAttrTileSX, TdxXLSXUtils.EncodePercents(100));
    AWriter.WriteAttributeInteger(sdxXLSXAttrTileSY, TdxXLSXUtils.EncodePercents(100));
    AWriter.WriteAttributeString(sdxXLSXAttrFlip, 'none');
    AWriter.WriteAttributeString(sdxXLSXAttrTileAlign, 'tl');
    AWriter.WriteEndElement;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteBlip(AWriter: TdxXmlWriter; AImage: TdxGPImage);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingBlip, '');
  if (AImage <> nil) and not AImage.Empty then
  begin
    AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXNamespaceRelationship, '', sdxXLSXCommonRelationshipPath);
    AWriter.WriteAttributeString(sdxXLSXNamespaceRelationship, sdxXLSXAttrDrawingResourceEmbed, '', WriteImage(AImage));
  end;
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteDescription(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingDescription, '');
  AWriter.WriteAttributeInteger('id', Container.Index + 1);
  AWriter.WriteAttributeString(sdxXLSXAttrName, Container.Name);
  if Container.Description <> '' then
    AWriter.WriteAttributeString(sdxXLSXAttrAlternateText, Container.Description);
  if Container.Title <> '' then
    AWriter.WriteAttributeString(sdxXLSXAttrTitle, Container.Title);
  if Container.Hyperlink <> nil then
    WriteHyperlink(AWriter, Container.Hyperlink);
  if not Container.Visible then
    AWriter.WriteAttributeInteger(sdxXLSXAttrHidden, 1);
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteHyperlink(AWriter: TdxXmlWriter; AHyperlink: TdxSpreadSheetHyperlink);
var
  ARelId: string;
  AValue: string;
begin
  AValue := AHyperlink.Value;
  if (AHyperlink.ValueType = hvtReference) and (Pos('=', AValue) = 1) then
    AValue[1] := '#';

  ARelId := OwnerRels.AddNew(AValue, sdxXLSXHyperlinkRelationship,
    IfThen(AHyperlink.ValueType <> hvtReference, sdxXLSXValueTargetModeExternal));

  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingShapeHLink, '');
  try
    if havScreenTip in AHyperlink.AssignedValues then
      AWriter.WriteAttributeString(sdxXLSXAttrTooltip, AHyperlink.ScreenTip);
    AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXNamespaceRelationship, '', sdxXLSXCommonRelationshipPath);
    AWriter.WriteAttributeString(sdxXLSXNamespaceRelationship, sdxXLSXAttrIdLC, '', ARelId);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteRestrictionsContent(AWriter: TdxXmlWriter);
var
  AIndex: TdxSpreadSheetContainerRestriction;
begin
  for AIndex := Low(TdxSpreadSheetContainerRestriction) to High(TdxSpreadSheetContainerRestriction) do
  begin
    if AIndex in Container.Restrictions then
      AWriter.WriteAttributeBoolean(dxXLSXRestrictionNames[AIndex], True);
  end;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteShapeFillParameters(AWriter: TdxXmlWriter; ABrush: TdxGPBrush);
begin
  if ABrush.IsEmpty then
    AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeNoFill, '', '')
  else
    case ABrush.Style of
      gpbsSolid:
        WriteSolidBrushParameters(AWriter, ABrush);
      gpbsGradient:
        WriteGradientBrushParameters(AWriter, ABrush);
      gpbsTexture:
        WriteTextureBrushParameters(AWriter, ABrush);
    else
      AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeNoFill, '', '');
    end;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteShapeGeometry(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingShapeGeometry, '');
  AWriter.WriteAttributeString(sdxXLSXAttrPreset, dxXLSXShapeTypeMap[Container.Shape.ShapeType]);
  AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeAVList, '', '');
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteShapeLineParameters(AWriter: TdxXmlWriter; APen: TdxGPPen);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeLine, '');
  AWriter.WriteAttributeInt64(sdxXLSXAttrLineWidth, dxPixelsToEMUF(APen.Width));
  WriteShapeFillParameters(AWriter, APen.Brush);
  if APen.Style <> gppsSolid then
  begin
    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeLineDash, '');
    AWriter.WriteAttributeString(sdxXLSXAttrVal, dxXLSXPenStyleMap[APen.Style]);
    AWriter.WriteEndElement;
  end;
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteShapeProperties(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapeProperties, '');
  WriteTransform(AWriter);
  WriteShapeGeometry(AWriter);
  WriteShapeFillParameters(AWriter, Container.Shape.Brush);
  WriteShapeLineParameters(AWriter, Container.Shape.Pen);
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterCustomShapeContainerBuilder.WriteTransform(AWriter: TdxXmlWriter);
var
  AAngle: Integer;
  ABounds: TRect;
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingXForm, '');
  try
    AAngle := Round(Container.Transform.RotationAngle);
    if AAngle <> 0 then
      AWriter.WriteAttributeInteger(sdxXLSXAttrRot, TdxXLSXUtils.EncodePositiveFixedAngle(AAngle));
    if Container.Transform.FlipHorizontally then
      AWriter.WriteAttributeBoolean(sdxXLSXAttrFlipH, Container.Transform.FlipHorizontally);
    if Container.Transform.FlipVertically then
      AWriter.WriteAttributeBoolean(sdxXLSXAttrFlipV, Container.Transform.FlipVertically);

    ABounds := TdxSpreadSheetContainerAccess(Container).Calculator.CalculateBounds;

    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeCoordOff, '');
    AWriter.WriteAttributeInt64(sdxXLSXAttrCoordX, dxPixelsToEMU(ABounds.Left));
    AWriter.WriteAttributeInt64(sdxXLSXAttrCoordY, dxPixelsToEMU(ABounds.Top));
    AWriter.WriteEndElement;

    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeCoordExt, '');
    AWriter.WriteAttributeInt64(sdxXLSXAttrCoordExtX, dxPixelsToEMU(ABounds.Width));
    AWriter.WriteAttributeInt64(sdxXLSXAttrCoordExtY, dxPixelsToEMU(ABounds.Height));
    AWriter.WriteEndElement;
  finally
    AWriter.WriteEndElement;
  end;
end;

function TdxXLSXWriterCustomShapeContainerBuilder.GetContainer: TdxSpreadSheetShapeContainer;
begin
  Result := inherited Container as TdxSpreadSheetShapeContainer;
end;

{ TdxXLSXWriterShapeContainerBuilder }

procedure TdxXLSXWriterShapeContainerBuilder.WriteContent(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapeContainer, '');
  WriteShapeContent(AWriter);
  AWriter.WriteEndElement;

  AWriter.WriteElementString(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeClientData, '', '');
end;

procedure TdxXLSXWriterShapeContainerBuilder.WriteShapeContent(AWriter: TdxXmlWriter);
begin
  AWriter.WriteAttributeString(sdxXLSXAttrMacro, '');
  AWriter.WriteAttributeString(sdxXLSXAttrTextLink, '');
  WriteShapeDescription(AWriter);
  WriteShapeProperties(AWriter);
end;

procedure TdxXLSXWriterShapeContainerBuilder.WriteShapePropertiesEx(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapePropertiesEx, '');
  try
    WriteShapePropertiesExContent(AWriter);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterShapeContainerBuilder.WriteShapePropertiesExContent(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingShapeLocks, '');
  try
    WriteRestrictionsContent(AWriter);
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterShapeContainerBuilder.WriteShapeDescription(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingShapeDescription, '');
  try
    WriteDescription(AWriter);
    WriteShapePropertiesEx(AWriter);
  finally
    AWriter.WriteEndElement;
  end;
end;

{ TdxXLSXWriterTextBoxContainerBuilder }

procedure TdxXLSXWriterTextBoxContainerBuilder.WriteShapeContent(AWriter: TdxXmlWriter);
begin
  inherited;
  WriteTextBoxBody(AWriter, Container.TextBox);
end;

procedure TdxXLSXWriterTextBoxContainerBuilder.WriteShapePropertiesExContent(AWriter: TdxXmlWriter);
begin
  AWriter.WriteAttributeBoolean(sdxXLSXAttrTextBox, True);
  inherited;
end;

procedure TdxXLSXWriterTextBoxContainerBuilder.WriteTextBoxBody(AWriter: TdxXmlWriter; ATextBox: TdxSpreadSheetTextBox);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingTextBody, '');
  WriteTextBoxBodyProperties(AWriter, ATextBox);
  AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeListStyle, '', '');
  WriteTextBoxBodyData(AWriter, ATextBox);
  AWriter.WriteEndElement;
end;

procedure TdxXLSXWriterTextBoxContainerBuilder.WriteTextBoxBodyData(AWriter: TdxXmlWriter; ATextBox: TdxSpreadSheetTextBox);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeParagraph, '');

  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeRichTextParagraphProperties, '');
  AWriter.WriteAttributeString(sdxXLSXAttrAlign, dxXLSXAlignmentMap[ATextBox.AlignHorz]);
  AWriter.WriteEndElement;

  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeRichTextRun, '');
  WriteTextBoxBodyParagraphInfo(AWriter, ATextBox.Font.Handle);
  AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeText, '', ATextBox.TextAsString);
  AWriter.WriteEndElement;

  AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeRichTextEndParagraphRunProperties, '', '');

  AWriter.WriteEndElement; // sdxXLSXNodeParagraph
end;

procedure TdxXLSXWriterTextBoxContainerBuilder.WriteTextBoxBodyParagraphInfo(AWriter: TdxXmlWriter; AFont: TdxSpreadSheetFontHandle);
var
  ATextColor: TdxAlphaColor;
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeRichTextRunParagraph, '');
  try
    AWriter.WriteAttributeInteger(sdxXLSXNodeSZ, AFont.Size * 100);
    if fsUnderline in AFont.Style then
      AWriter.WriteAttributeString(dxXLSXFontStyles[fsUnderline], 'sng');
    if fsBold in AFont.Style then
      AWriter.WriteAttributeInteger(dxXLSXFontStyles[fsBold], 1);
    if fsItalic in AFont.Style then
      AWriter.WriteAttributeInteger(dxXLSXFontStyles[fsItalic], 1);
    if fsStrikeOut in AFont.Style then
      AWriter.WriteAttributeInteger(dxXLSXFontStyles[fsStrikeOut], 1);

    ATextColor := dxColorToAlphaColor(cxGetActualColor(AFont.Color, clWindowText));
    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeSolidFill, '');
    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeThemesCustomColor, '');
    AWriter.WriteAttributeString(sdxXLSXAttrVal, TdxAlphaColors.ToHexCode(ATextColor));
    AWriter.WriteEndElement;
    AWriter.WriteEndElement;

    if SpreadSheet.DefaultCellStyle.Font.Name <> AFont.Name then
    begin
      AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeLatin, '');
      AWriter.WriteAttributeString(sdxXLSXAttrTypeface, AFont.Name);
      AWriter.WriteEndElement;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterTextBoxContainerBuilder.WriteTextBoxBodyProperties(AWriter: TdxXmlWriter; ATextBox: TdxSpreadSheetTextBox);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeBodyProperties, '');

  AWriter.WriteAttributeInt64(sdxXLSXAttrLeftInset, dxPixelsToEMU(ATextBox.ContentOffsets.Left));
  AWriter.WriteAttributeInt64(sdxXLSXAttrTopInset, dxPixelsToEMU(ATextBox.ContentOffsets.Top));
  AWriter.WriteAttributeInt64(sdxXLSXAttrRightInset, dxPixelsToEMU(ATextBox.ContentOffsets.Right));
  AWriter.WriteAttributeInt64(sdxXLSXAttrBottomInset, dxPixelsToEMU(ATextBox.ContentOffsets.Bottom));
  AWriter.WriteAttributeString(sdxXLSXAttrAnchor, dxXLSXVerticalAlignmentMap[ATextBox.AlignVert]);
  AWriter.WriteAttributeString('horzOverflow', 'clip');
  AWriter.WriteAttributeString('vertOverflow', 'clip');

  if ATextBox.WordWrap then
    AWriter.WriteAttributeString(sdxXLSXAttrWrap, sdxXLSXValueSquare)
  else
    AWriter.WriteAttributeString(sdxXLSXAttrWrap, sdxXLSXValueNone);

  if ATextBox.AutoSize then
    AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeSpAutoFit, '', '')
  else
    AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeNoAutoFit, '', '');

  AWriter.WriteEndElement;
end;

function TdxXLSXWriterTextBoxContainerBuilder.GetContainer: TdxSpreadSheetTextBoxContainer;
begin
  Result := inherited Container as TdxSpreadSheetTextBoxContainer;
end;

{ TdxXLSXWriterPictureContainerBuilder }

procedure TdxXLSXWriterPictureContainerBuilder.WriteContent(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPictureContainer, '');
  WritePictureDescription(AWriter);
  WritePictureResource(AWriter);
  WriteShapeProperties(AWriter);
  AWriter.WriteEndElement;

  AWriter.WriteElementString(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeClientData, '', '');
end;

procedure TdxXLSXWriterPictureContainerBuilder.WritePictureDescription(AWriter: TdxXmlWriter);
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPictureDescription, '');
  try
    WriteDescription(AWriter);

    AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingPictureAttributes, '');
    try
      if not Container.RelativeResize then
        AWriter.WriteAttributeInteger(sdxXLSXAttrPreferRelativeResize, 0);

      AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingPictureLocks, '');
      WriteRestrictionsContent(AWriter);
      AWriter.WriteEndElement;
    finally
      AWriter.WriteEndElement;
    end;
  finally
    AWriter.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterPictureContainerBuilder.WritePictureResource(AWriter: TdxXmlWriter);
var
  ACropMargins: TRect;
begin
  AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingBlipFill, '');

  WriteBlip(AWriter, Container.Picture.Image);

  ACropMargins := TdxXLSXUtils.EncodeSourceRect(Container.Picture.CropMargins);
  if not cxRectIsNull(ACropMargins) then
  begin
    AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeDrawingAttributeSourceRect, '');
    if ACropMargins.Left <> 0 then
      AWriter.WriteAttributeInteger('l', ACropMargins.Left);
    if ACropMargins.Top <> 0 then
      AWriter.WriteAttributeInteger('t', ACropMargins.Top);
    if ACropMargins.Right <> 0 then
      AWriter.WriteAttributeInteger('r', ACropMargins.Right);
    if ACropMargins.Bottom <> 0 then
      AWriter.WriteAttributeInteger('b', ACropMargins.Bottom);
    AWriter.WriteEndElement;
  end;

  AWriter.WriteStartElement(sdxXLSXNamespaceDrawing, sdxXLSXNodeStretch, '');
  AWriter.WriteElementString(sdxXLSXNamespaceDrawing, sdxXLSXNodeFillRect, '', '');
  AWriter.WriteEndElement;

  AWriter.WriteEndElement;
end;

function TdxXLSXWriterPictureContainerBuilder.GetContainer: TdxSpreadSheetPictureContainer;
begin
  Result := inherited Container as TdxSpreadSheetPictureContainer;
end;

{ TdxXLSXWriterWorksheetContainersBuilder }

constructor TdxXLSXWriterWorksheetContainersBuilder.Create(const ATargetFileName: string;
  AContainers: TList; AOwner: TdxSpreadSheetXLSXWriter; AOwnerRels: TdxXLSXRelationships);
begin
  inherited Create(AOwner, AOwnerRels, ATargetFileName);
  FContainers := AContainers;
  FBuilderFactory := TdxClassDictionary<TdxXLSXWriterCustomContainerBuilderClass>.Create;
  FBuilderFactory.Add(TdxSpreadSheetContainer, TdxXLSXWriterCustomContainerBuilder);
  FBuilderFactory.Add(TdxSpreadSheetPictureContainer, TdxXLSXWriterPictureContainerBuilder);
  FBuilderFactory.Add(TdxSpreadSheetShapeContainer, TdxXLSXWriterShapeContainerBuilder);
  FBuilderFactory.Add(TdxSpreadSheetTextBoxContainer, TdxXLSXWriterTextBoxContainerBuilder);
end;

destructor TdxXLSXWriterWorksheetContainersBuilder.Destroy;
begin
  FreeAndNil(FBuilderFactory);
  inherited Destroy;
end;

procedure TdxXLSXWriterWorksheetContainersBuilder.ExecuteCore(AWriter: TdxXmlWriter);
var
  AContainer: TdxSpreadSheetContainer;
  ARels: TdxXLSXRelationships;
  I: Integer;
begin
  ARels := TdxXLSXRelationships.Create;
  try
    AWriter.WriteStartElement(sdxXLSXNamespaceDrawingSpreadSheet, sdxXLSXNodeDrawingHeader, sdxXLSXDrawingNamespaceXDR);
//    AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXNamespaceDrawingSpreadSheet, '', sdxXLSXDrawingNamespaceXDR);
    AWriter.WriteAttributeString(sdxXLSXAttrXMLNS, sdxXLSXNamespaceDrawing, '', sdxXLSXDrawingNamespace);

    for I := 0 to FContainers.Count - 1 do
    begin
      AContainer := FContainers.List[I];
      ExecuteSubTask(FBuilderFactory.Items[AContainer.ClassType].Create(AContainer, Owner, ARels, AWriter));
    end;

    AWriter.WriteEndElement;

    Owner.WriteRels(TargetFileNameRels, ARels, False);
  finally
    ARels.Free;
  end;
end;

function TdxXLSXWriterWorksheetContainersBuilder.GetContentRelationship: string;
begin
  Result := sdxXLSXDrawingRelationship;
end;

function TdxXLSXWriterWorksheetContainersBuilder.GetContentType: string;
begin
  Result := sdxXLSXDrawingContentType;
end;

end.
