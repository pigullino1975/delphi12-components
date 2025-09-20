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

unit dxSpreadSheetFormatXML;

{$I cxVer.Inc}

interface

uses
  System.UITypes,
  Windows, Types, SysUtils, Classes, Graphics, dxCore, dxHashUtils, cxGraphics,
  dxSpreadSheetCore, dxSpreadSheetClasses, dxSpreadSheetUtils, dxSpreadSheetTextFileFormatCore, dxSpreadSheetFormatHTML,
  dxSpreadSheetCoreStyles, dxSpreadSheetStyles;

type

  { TdxSpreadSheetXMLFormat }

  TdxSpreadSheetXMLFormat = class(TdxSpreadSheetCustomFormat)
  public
    class function CanReadFromStream(AStream: TStream): Boolean; override;
    class function GetDescription: string; override;
    class function GetExt: string; override;
    class function GetReader: TdxSpreadSheetCustomReaderClass; override;
    class function GetWriter: TdxSpreadSheetCustomWriterClass; override;
  end;

  { TdxSpreadSheetXMLWriter }

  TdxSpreadSheetXMLWriter = class(TdxSpreadSheetHTMLWriter)
  protected
    procedure WriteCellStyle(AWriteProc: TdxSpreadSheetHTMLWriter.TWriteProc; AStyle: TdxSpreadSheetCellStyleHandle); override;
    procedure WriteContainer(AContainer: TdxSpreadSheetContainer; AContainerBounds: TRect); override;
    procedure WriteDocumentFooter; override;
    procedure WriteDocumentHeader; override;
    procedure WriteStyleSheet(const AFileName: UnicodeString); virtual;
    procedure WriteTableViewCell(ARowIndex, AColumnIndex, AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer; ACell: TdxSpreadSheetCell); override;
    procedure WriteTableViewFooter; override;
    procedure WriteTableViewHeader; override;
    procedure WriteTableViewRowFooter(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow); override;
    procedure WriteTableViewRowHeader(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow); override;
  public
    function RegisterCellStyle(AStyle: TdxSpreadSheetCellStyle): string; override;
  end;

  { TdxSpreadSheetXMLWriterCellStyle }

  TdxSpreadSheetXMLWriterCellStyle = class(TdxSpreadSheetCustomFilerSubTask)
  strict private
    FOwner: TdxSpreadSheetXMLWriter;
    FStyle: TdxSpreadSheetCellStyleHandle;
    FStyleName: string;
    FWriteProc: TdxSpreadSheetHTMLWriter.TWriteProc;
  protected
    procedure Write(const S: string);
    procedure WriteBorders;
    procedure WriteBrush;
    procedure WriteFont;
    procedure WriteTextAlignment;
  public
    constructor Create(AOwner: TdxSpreadSheetXMLWriter;
      AStyle: TdxSpreadSheetCellStyleHandle; const AStyleName: string;
      AWriteProc: TdxSpreadSheetHTMLWriter.TWriteProc);
    procedure Execute; override;
    //
    property Style: TdxSpreadSheetCellStyleHandle read FStyle;
  end;

implementation

uses
  Math, dxSpreadSheetGraphics;

const
  dxThisUnitName = 'dxSpreadSheetFormatXML';

type
  TdxSpreadSheetContainerAccess = class(TdxSpreadSheetContainer);
  TdxSpreadSheetTableColumnsAccess = class(TdxSpreadSheetTableColumns);
  TdxSpreadSheetTableViewAccess = class(TdxSpreadSheetTableView);
  TdxSpreadSheetTableViewInfoAccess = class(TdxSpreadSheetTableViewInfo);

const
  sdxXMLStyleTemplate =
    '<?xml version="1.0" encoding="UTF-8"?>' + #13#10 +
    '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' + #13#10 +
    '   <xsl:template match="/">' + #13#10 +
    '     <xsl:apply-templates select="CACHE" />' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="CACHE">' + #13#10 +
    '     <html>' + #13#10 +
    '        <head>' + #13#10 +
    '          <xsl:apply-templates select="TITLE" />' + #13#10 +
    '          <xsl:apply-templates select="STYLES" />' + #13#10 +
    '        </head>' + #13#10 +
    '        <body>' + #13#10 +
    '          <xsl:apply-templates select="LINES" />' + #13#10 +
    '        </body>' + #13#10 +
    '     </html>' + #13#10 +
    '   </xsl:template>' +  #13#10 +

    '   <xsl:template match="TITLE">' + #13#10 +
    '     <title>' + #13#10 +
    '       <xsl:value-of select="." />' + #13#10 +
    '     </title>' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="STYLES">' + #13#10 +
    '     <style type="text/css">' + #13#10 +
    '       table td { overflow: hidden; padding: 0px;}' + #13#10 +
    '       <xsl:apply-templates select="STYLE" />' + #13#10 +
    '     </style>' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="STYLE">' + #13#10 +
    '     .Style<xsl:value-of select="@Id" />' + #13#10 +
    '     { ' + #13#10 +
    '       border-style: solid;' + #13#10 +
    '       padding: <xsl:value-of select="@CellPadding" />;' + #13#10 +
    '       font-family: <xsl:value-of select="@FontName" />;' + #13#10 +
    '       mso-font-charset: <xsl:value-of select="@FontCharset" />;' + #13#10 +
    '       font-size: <xsl:value-of select="@FontSize" />pt;' + #13#10 +
    '       color: <xsl:value-of select="@FontColor" />;' + #13#10 +
    '       background-color: <xsl:value-of select="@BrushBkColor" />;' + #13#10 +
    '     <xsl:if test="@Bold=''True''">' + #13#10 +
    '       font-weight: bold;' + #13#10 +
    '     </xsl:if>' + #13#10 +
    '     <xsl:if test="@Italic=''True''">' + #13#10 +
    '       font-style: italic;' + #13#10 +
    '     </xsl:if>' + #13#10 +
    '     <xsl:if test="@Underline=''True''">' + #13#10 +
    '       text-decoration: underline;' + #13#10 +
    '     </xsl:if>' + #13#10 +
    '     <xsl:if test="@StrikeOut=''True''">' + #13#10 +
    '       text-decoration: line-through;' + #13#10 +
    '     </xsl:if>' + #13#10 +
    '     <xsl:apply-templates select="BORDER_LEFT" />' + #13#10 +
    '     <xsl:apply-templates select="BORDER_UP" />' + #13#10 +
    '     <xsl:apply-templates select="BORDER_RIGHT" />' + #13#10 +
    '     <xsl:apply-templates select="BORDER_DOWN" />' + #13#10 +
    '     }' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="BORDER_LEFT">' + #13#10 +
    '     border-left-width: <xsl:value-of select="@Width" />px;' + #13#10 +
    '     border-left-color: <xsl:value-of select="@Color" />;' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="BORDER_UP">' + #13#10 +
    '     border-top-width: <xsl:value-of select="@Width" />px;' + #13#10 +
    '     border-top-color: <xsl:value-of select="@Color" />;' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="BORDER_RIGHT">' + #13#10 +
    '     border-right-width: <xsl:value-of select="@Width" />px;' + #13#10 +
    '     border-right-color: <xsl:value-of select="@Color" />;' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="BORDER_DOWN">' + #13#10 +
    '     border-bottom-width: <xsl:value-of select="@Width" />px;' + #13#10 +
    '     border-bottom-color: <xsl:value-of select="@Color" />;' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="LINES">' + #13#10 +
    '     <table border="0" cellspacing="0" style="border-collapse: collapse;">' + #13#10 +
    '       <xsl:apply-templates select="LINE" />' + #13#10 +
    '     </table>' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="LINE">' + #13#10 +
    '     <tr>' + #13#10 +
    '       <xsl:attribute name="height"><xsl:value-of select="@Height" /></xsl:attribute>' + #13#10 +
    '       <xsl:apply-templates select="CELL" />' + #13#10 +
    '     </tr>' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="CELL">' + #13#10 +
    '     <td>' + #13#10 +
    '       <xsl:attribute name="nowrap"></xsl:attribute>' + #13#10 +
    '       <xsl:attribute name="width"><xsl:value-of select="@Width" /></xsl:attribute>' + #13#10 +
    '       <xsl:attribute name="height"><xsl:value-of select="@Height" /></xsl:attribute>' + #13#10 +
    '       <xsl:attribute name="align"><xsl:value-of select="@Align" /></xsl:attribute>' + #13#10 +
    '       <xsl:attribute name="colspan"><xsl:value-of select="@ColSpan" /></xsl:attribute>' + #13#10 +
    '       <xsl:attribute name="rowspan"><xsl:value-of select="@RowSpan" /></xsl:attribute>' + #13#10 +
    '       <xsl:attribute name="class">Style<xsl:value-of select="@StyleClass" /></xsl:attribute>' + #13#10 +
    '       <xsl:choose>' + #13#10 +
    '         <xsl:when test="LINES">' + #13#10 +
    '           <xsl:apply-templates select="LINES" />' + #13#10 +
    '         </xsl:when>' + #13#10 +
    '         <xsl:when test="IMAGE">' + #13#10 +
    '           <xsl:apply-templates select="IMAGE" />' + #13#10 +
    '         </xsl:when>' + #13#10 +
    '         <xsl:otherwise>' + #13#10 +
    '           <xsl:value-of select="." />' + #13#10 +
    '         </xsl:otherwise>' + #13#10 +
    '       </xsl:choose>' + #13#10 +
    '     </td>' + #13#10 +
    '   </xsl:template>' + #13#10 +

    '   <xsl:template match="IMAGE">' + #13#10 +
    '     <img>' + #13#10 +
    '       <xsl:attribute name="src"><xsl:value-of select="@Src" /></xsl:attribute>' + #13#10 +
    '       <xsl:value-of select="." />' + #13#10 +
    '     </img>' + #13#10 +
    '   </xsl:template>' + #13#10 +
    '</xsl:stylesheet>';

type

  { TdxSpreadSheetStringBuilderHelper }

  TdxSpreadSheetStringBuilderHelper = class helper for TStringBuilder
  public
    procedure Write(const S: string);
  end;

function GetXMLColor(AColor: TColor): string;
begin
  AColor := ColorToRGB(AColor);
  Result := Format('rgb(%d,%d,%d)', [GetRValue(AColor), GetGValue(AColor), GetBValue(AColor)]);
end;

function cxStrUnicodeNeeded(const AText: string; ACheckNormal: Boolean = False): Boolean;
const
  Normal = ['0'..'9', ':', ';', '*', '+', ',', '-', '.', '/', '!', ' ',  'A'..'Z', 'a'..'z', '_', '(', ')'];
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(AText) do
    if (Ord(AText[I]) > $7F) or (ACheckNormal and not dxCharInSet(AText[I], Normal)) then
    begin
      Result := True;
      Break;
    end
end;

function CheckedUnicodeString(const S: string): string; overload;
var
  I: Integer;
begin
  if cxStrUnicodeNeeded(S, True) then
  begin
    Result := '';
    for I := 1 to Length(S) do
      Result := Result + '&#' + IntToStr(Integer(S[I])) + ';';
  end
  else
    Result := S;
end;

function GetAlignText(AAlign: TdxSpreadSheetDataAlignHorz): string;
begin
  case AAlign of
    ssahCenter:
      Result := 'Center';
    ssahRight:
      Result := 'Right';
  else
    Result := 'Left';
  end;
end;

{ TdxSpreadSheetStringBuilderHelper }

procedure TdxSpreadSheetStringBuilderHelper.Write(const S: string);
begin
  Append(S);
end;

{ TdxSpreadSheetXMLFormat }

class function TdxSpreadSheetXMLFormat.CanReadFromStream(AStream: TStream): Boolean;
begin
  Result := False;
end;

class function TdxSpreadSheetXMLFormat.GetDescription: string;
begin
  Result := 'XML Document';
end;

class function TdxSpreadSheetXMLFormat.GetExt: string;
begin
  Result := '.xml';
end;

class function TdxSpreadSheetXMLFormat.GetReader: TdxSpreadSheetCustomReaderClass;
begin
  Result := nil;
end;

class function TdxSpreadSheetXMLFormat.GetWriter: TdxSpreadSheetCustomWriterClass;
begin
  Result := TdxSpreadSheetXMLWriter;
end;

{ TdxSpreadSheetXMLWriter }

function TdxSpreadSheetXMLWriter.RegisterCellStyle(AStyle: TdxSpreadSheetCellStyle): string;
var
  ABuffer: TStringBuilder;
  AData: TdxSpreadSheetHTMLWriterStyleData;
begin
  if not StyleCollection.TryGetValue(AStyle.Handle, AData) then
  begin
    AData := TdxSpreadSheetHTMLWriterStyleData.Create;
    AData.Name := IntToStr(StyleCollection.Count);

    ABuffer := TStringBuilder.Create;
    try
      ExecuteSubTask(TdxSpreadSheetXMLWriterCellStyle.Create(Self, AStyle.Handle, AData.name, ABuffer.Write));
      AData.Data := Encoding.GetBytes(ABuffer.ToString);
    finally
      ABuffer.Free;
    end;

    StyleCollection.Add(AStyle.Handle, AData);
  end;
  Result := AData.Name;
end;

procedure TdxSpreadSheetXMLWriter.WriteCellStyle(
  AWriteProc: TdxSpreadSheetHTMLWriter.TWriteProc; AStyle: TdxSpreadSheetCellStyleHandle);
begin
  // do nothing
end;

procedure TdxSpreadSheetXMLWriter.WriteContainer(AContainer: TdxSpreadSheetContainer; AContainerBounds: TRect);
begin
  // do nothing, only inscribed containers are supported
end;

procedure TdxSpreadSheetXMLWriter.WriteDocumentFooter;
begin
  WriteLine('</CACHE>');
end;

procedure TdxSpreadSheetXMLWriter.WriteDocumentHeader;
var
  AStyleSheetFileName: string;
begin
  WriteLine('<?xml version="1.0" encoding="UTF-8"?>');
  if GetTargetFileName(AStyleSheetFileName) then
  begin
    AStyleSheetFileName := ChangeFileExt(AStyleSheetFileName, '.xsl');
    WriteStyleSheet(AStyleSheetFileName);
    WriteLine('<?xml-stylesheet type="text/xsl" href="' + AStyleSheetFileName + '"?>');
  end;

  WriteLine('<CACHE>');
  WriteLine('<TITLE>' + TableView.Caption + '</TITLE>');

  WriteLine('<STYLES>');
  FStylesPositionInStream := Stream.Position;
  WriteLine('</STYLES>');
end;

procedure TdxSpreadSheetXMLWriter.WriteStyleSheet(const AFileName: UnicodeString);
var
  AStream: TFileStream;
  AStreamWriter: TStreamWriter;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    AStreamWriter := TStreamWriter.Create(AStream, TEncoding.UTF8);
    try
      AStreamWriter.Write(sdxXMLStyleTemplate);
    finally
      AStreamWriter.Free;
    end;
  finally
    AStream.Free;
  end;
end;

procedure TdxSpreadSheetXMLWriter.WriteTableViewCell(
  ARowIndex, AColumnIndex, AAbsoluteRowIndex, AAbsoluteColumnIndex: Integer; ACell: TdxSpreadSheetCell);

  function GetInscribedContainer: TdxSpreadSheetContainer;
  begin
    if not InscribedContainers.TryGetValue(ACell, Result) then
      Result := nil;
  end;

var
  AAlignHorz: TdxSpreadSheetDataAlignHorz;
  AAreaSize: Integer;
  ACellDisplayText: string;
  AContainer: TdxSpreadSheetContainerAccess;
  AContainerBounds: TRect;
  AFileName: string;
  AMergedCell: TdxSpreadSheetMergedCell;
  AReference: string;
begin
  AMergedCell := TableView.MergedCells.FindCell(AAbsoluteRowIndex, AAbsoluteColumnIndex);
  if (AMergedCell <> nil) and ((AMergedCell.Area.Left <> AAbsoluteColumnIndex) or (AMergedCell.Area.Top <> AAbsoluteRowIndex)) then
    Exit;

  CalculateActualCellStyle(AAbsoluteRowIndex, AAbsoluteColumnIndex, ACell, DisplayStyleBuffer);
  Write(Format('<CELL StyleClass="%s" Width="%d"', [RegisterCellStyle(DisplayStyleBuffer),
    TdxSpreadSheetTableColumnsAccess(TableView.Columns).GetItemSize(AAbsoluteColumnIndex)]));

  if ACell <> nil then
  begin
    AAlignHorz := ACell.Style.AlignHorz;
    if (AAlignHorz = ssahGeneral) and ACell.IsNumericValue then
      AAlignHorz := ssahRight;
    Write(' Align="' + GetAlignText(AAlignHorz) + '"');
  end;

  if AMergedCell <> nil then
  begin
    AAreaSize := GetActualAreaWidth(AMergedCell.Area);
    if AAreaSize > 1 then
      Write(Format(' ColSpan="%d"', [AAreaSize]));

    AAreaSize := GetActualAreaHeight(AMergedCell.Area);
    if AAreaSize > 1 then
      Write(Format(' RowSpan="%d"', [AAreaSize]));
  end;
  Write('>');

  if ACell <> nil then
    ACellDisplayText := CheckedUnicodeString(ACell.DisplayText)
  else
    ACellDisplayText := '';

  AContainer := TdxSpreadSheetContainerAccess(GetInscribedContainer);
  if (AContainer <> nil) and GetImageReference(AFileName, AReference) then
  begin
    AContainerBounds := AContainer.Calculator.CalculateBounds;
    PrepareContainerImage(AFileName, AContainerBounds, AContainer);
    Write('<IMAGE Src="');
    Write(AReference);
    Write('">');
    Write(ACellDisplayText);
    Write('</IMAGE>');
  end
  else
    Write(ACellDisplayText);

  WriteLine('</CELL>');
end;

procedure TdxSpreadSheetXMLWriter.WriteTableViewFooter;
begin
  WriteLine('</LINES>');
end;

procedure TdxSpreadSheetXMLWriter.WriteTableViewHeader;
begin
  WriteLine(Format('<LINES ColCount="%d" RowCount="%d">', [TableViewArea.Right + 1, TableViewArea.Bottom + 1]));
end;

procedure TdxSpreadSheetXMLWriter.WriteTableViewRowFooter(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow);
begin
  WriteLine('</LINE>');
end;

procedure TdxSpreadSheetXMLWriter.WriteTableViewRowHeader(ARowIndex, AAbsoluteRowIndex: Integer; ARow: TdxSpreadSheetTableRow);
begin
  WriteLine(Format('<LINE Height="%d">', [FCurrentRowSize]));
end;

{ TdxSpreadSheetXMLWriterCellStyle }

constructor TdxSpreadSheetXMLWriterCellStyle.Create(
  AOwner: TdxSpreadSheetXMLWriter; AStyle: TdxSpreadSheetCellStyleHandle;
  const AStyleName: string; AWriteProc: TdxSpreadSheetHTMLWriter.TWriteProc);
begin
  inherited Create(AOwner);
  FOwner := AOwner;
  FStyle := AStyle;
  FWriteProc := AWriteProc;
  FStyleName := AStyleName;
end;

procedure TdxSpreadSheetXMLWriterCellStyle.Execute;
begin
  Write('<STYLE Id="' + FStyleName + '"');
  WriteTextAlignment;
  WriteFont;
  WriteBrush;
  Write('>');
  Write(dxCRLF);
  WriteBorders;
  Write('</STYLE>');
  Write(dxCRLF);
end;

procedure TdxSpreadSheetXMLWriterCellStyle.Write(const S: string);
begin
  FWriteProc(S);
end;

procedure TdxSpreadSheetXMLWriterCellStyle.WriteBorders;
const
  SideName: array[TcxBorder] of string = (
    'BORDER_LEFT', 'BORDER_UP', 'BORDER_RIGHT', 'BORDER_DOWN'
  );
var
  ABorderColor: TColor;
  ADefaultBorderColor: TColor;
  ASide: TcxBorder;
begin
  if SpreadSheet.ActiveSheetAsTable.Options.ActualGridLines then
    ADefaultBorderColor := cxGetActualColor(SpreadSheet.OptionsView.GridLineColor, clBtnShadow)
  else
    ADefaultBorderColor := clNone;

  for ASide := Low(TcxBorder) to High(TcxBorder) do
  begin
    ABorderColor := cxGetActualColor(Style.Borders.BorderColor[ASide], ADefaultBorderColor);
    Write('<' + SideName[ASide] + ' IsDefault="False" ');
    Write('Color="' + GetXMLColor(ABorderColor) + '" ');
    Write('Width="' + IntToStr(IfThen(ABorderColor <> clNone, dxSpreadSheetBorderStyleThickness[Style.Borders.BorderStyle[ASide]])) + '"');
    Write('/>');
  end;
end;

procedure TdxSpreadSheetXMLWriterCellStyle.WriteBrush;
begin
  if Style.Brush.Style = sscfsSolid then
  begin
    Write(' BrushStyle="Solid"');
    Write(' BrushBkColor="' + GetXMLColor(cxGetActualColor(Style.Brush.BackgroundColor, FOwner.FDefaultBackgroundColor)) + '"');
    Write(' BrushFgColor="' + GetXMLColor(cxGetActualColor(Style.Brush.ForegroundColor, FOwner.FDefaultFontColor)) + '"');
  end;
end;

procedure TdxSpreadSheetXMLWriterCellStyle.WriteFont;
const
  FontStyleNameMap: array[TFontStyle] of string = (
    'Bold', 'Italic', 'Underline', 'StrikeOut'
  );
var
  AStyle: TFontStyle;
begin
  Write(' FontName="' + CheckedUnicodeString(Style.Font.Name) + '"');
  Write(' FontCharset="' + IntToStr(Style.Font.Charset) + '"');
  for AStyle := Low(TFontStyle) to High(TFontStyle) do
    Write(' ' + FontStyleNameMap[AStyle] + '="' + BoolToStr(AStyle in Style.Font.Style, True) + '"');
  Write(' FontColor="' + GetXMLColor(cxGetActualColor(Style.Font.Color, FOwner.FDefaultFontColor)) + '"');
  Write(' FontSize="' + IntToStr(Style.Font.Size) + '"');
end;

procedure TdxSpreadSheetXMLWriterCellStyle.WriteTextAlignment;
begin
  Write(' AlignText="' + GetAlignText(Style.AlignHorz) + '"');
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetXMLFormat.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetXMLFormat.Unregister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
