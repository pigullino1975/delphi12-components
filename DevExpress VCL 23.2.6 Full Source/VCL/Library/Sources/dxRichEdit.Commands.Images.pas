{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressRichEditControl                                   }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSRICHEDITCONTROL AND ALL        }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
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

unit dxRichEdit.Commands.Images;

{$I cxVer.inc}
{$I dxRichEditControl.inc}

interface

type
  TdxRichEditControlCommandsImages = class sealed
  public const
    //Actions
    Bookmark                        = 'Actions\Bookmark.png';
    Close                           = 'Actions\Close.png';
    LoadDocument                    = 'Actions\Open.png';
    NewDocument                     = 'Actions\New.png';
    SelectAll                       = 'Actions\SelectAll2.png';
    ShowHyperlinkForm               = 'RichEdit\Hyperlink.png';
    TableStyles                     = 'Actions\FormatAsTable.png';
    //Alignment
    MergeCells                      = 'Alignment\MergeCells.png';
    //Arrange
    BringForward                    = 'Arrange\BringForward.png';
    BringInFrontOfText              = 'Arrange\BringToFrontOfText.png';
    BringToFront                    = 'Arrange\BringToFront.png';
    ImagePositionBottomCenter       = 'Arrange\WithTextWrapping_BottomCenter.png';
    ImagePositionBottomLeft         = 'Arrange\WithTextWrapping_BottomLeft.png';
    ImagePositionBottomRight        = 'Arrange\WithTextWrapping_BottomRight.png';
    ImagePositionMiddleCenter       = 'Arrange\WithTextWrapping_CenterCenter.png';
    ImagePositionMiddleLeft         = 'Arrange\WithTextWrapping_CenterLeft.png';
    ImagePositionMiddleRight        = 'Arrange\WithTextWrapping_CenterRight.png';
    ImagePositionTopCenter          = 'Arrange\WithTextWrapping_TopCenter.png';
    ImagePositionTopLeft            = 'Arrange\WithTextWrapping_TopLeft.png';
    ImagePositionTopRight           = 'Arrange\WithTextWrapping_TopRight.png';
    SendBackward                    = 'Arrange\SendBackward.png';
    SendBehindText                  = 'Arrange\SendBehindText.png';
    SendToBack                      = 'Arrange\SendToBack.png';
    WrapTextBehindText              = 'Arrange\BehindText.png';
    WrapTextInFrontOfText           = 'Arrange\InFrontOfText.png';
    WrapTextSquare                  = 'Arrange\Square.png';
    WrapTextThrough                 = 'Arrange\Through.png';
    WrapTextTight                   = 'Arrange\Tight.png';
    WrapTextTopAndBottom            = 'Arrange\TopAndBottom.png';
    //Content
    InsertPicture                   = 'Content\Image.png';
    //Edit
    CopySelection                   = 'Edit\Copy.png';
    CutSelection                    = 'Edit\Cut.png';
    PasteSelection                  = 'Edit\Paste.png';
    //Find
    SearchFind                      = 'Find\Find.png';
    //Format
    ChangeFontColor                 = 'RichEdit\FontColor.png';
    ChangeFontStyle                 = 'Format\ChangeFontStyle.png';
    DecreaseFontSize                = 'Format\FontSizeDecrease.png';
    DecrementIndent                 = 'Format\IndentDecrease.png';
    Font                            = 'Format\Font.png';
    FillBackground                  = 'Format\FillBackground.png';
    FontSize                        = 'Format\FontSize.png';
    IncreaseFontSize                = 'Format\FontSizeIncrease.png';
    IncrementIndent                 = 'Format\IndentIncrease.png';
    SearchReplace                   = 'Format\Replace.png';
    ShowParagraphForm               = 'Format\LineSpacingOptions.png';
    ShowSymbolForm                  = 'RichEdit\Symbol.png';
    TextHighlight                   = 'RichEdit\Highlight.png';
    ToggleBulletedList              = 'Format\ListBullets.png';
    ToggleFontBold                  = 'Format\Bold.png';
    ToggleFontDoubleStrikeout       = 'Format\StrikeoutDouble.png';
    ToggleFontDoubleUnderline       = 'Format\UnderlineDouble.png';
    ToggleFontItalic                = 'Format\Italic.png';
    ToggleFontStrikeout             = 'Format\Strikeout.png';
    ToggleFontSubscript             = 'Format\Subscript.png';
    ToggleFontSuperscript           = 'Format\Superscript.png';
    ToggleFontUnderline             = 'Format\Underline.png';
    ToggleMultiLevelList            = 'Format\ListMultilevel.png';
    ToggleParagraphAlignmentCenter  = 'Format\AlignCenter.png';
    ToggleParagraphAlignmentJustify = 'Format\AlignJustify.png';
    ToggleParagraphAlignmentLeft    = 'Format\AlignLeft.png';
    ToggleParagraphAlignmentRight   = 'Format\AlignRight.png';
    ToggleSimpleNumberingList       = 'Format\ListNumbers.png';
    ToggleShowWhitespace            = 'Format\ShowHidden.png';
    //Grid
    ShowInsertTableForm             = 'Grid\Grid.png';
    //History
    Undo                            = 'History\Undo.png';
    Redo                            = 'History\Redo.png';
    //Pages
    InsertColumnBreak               = 'RichEdit\InsertColumnBreak.png';
    InsertPageBreak                 = 'Pages\InsertPageBreak.png';
    InsertSectionBreakEvenPage      = 'RichEdit\InsertSectionBreakEvenPage.png';
    InsertSectionBreakNextPage      = 'RichEdit\InsertSectionBreakNextPage.png';
    InsertSectionBreakOddPage       = 'RichEdit\InsertSectionBreakOddPage.png';
    LineNumbers                     = 'RichEdit\LineNumbering.png';
    Margins                         = 'Pages\PageMargins.png';
    PaperSize                       = 'Pages\PaperSize.png';
    SetSectionOneColumn             = 'RichEdit\ColumnsOne.png';
    SetSectionTwoColumns            = 'RichEdit\ColumnsTwo.png';
    SetSectionThreeColumns          = 'RichEdit\ColumnsThree.png';
    ShowColumnsSetupForm            = 'Format\Columns.png';
    ToggleShowHorizontalRuler       = 'RichEdit\RulerHorizontal.png';
    ToggleShowVerticalRuler         = 'RichEdit\RulerVertical.png';
    PageOrientationLandscape        = 'Pages\PageOrientationLandscape.png';
    PageOrientationPortrait         = 'Pages\PageOrientationPortrait.png';
    //Print
    ShowPageSetupForm               = 'Setup\PageSetup.png';
    ShowPrintForm                   = 'Print\PrintDialog.png';
    ShowPrintPreviewForm            = 'Print\Preview.png';
    //Save
    SaveDocument                    = 'Save\Save.png';
    SaveDocumentAs                  = 'Save\SaveAs.png';
    //Reports
    SwitchToDraftView               = 'RichEdit\DraftView.png';
    SwitchToPrintLayoutView         = 'RichEdit\PrintLayoutView.png';
    SwitchToSimpleView              = 'RichEdit\SimpleView.png';
    //Rich Edit
    AddParagraphToTableOfContents   = 'RichEdit\AddParagraphToTableOfContents.png';
    AutoFitContents                 = 'RichEdit\TableAutoFitContents.png';
    AutoFitWindow                   = 'RichEdit\TableAutoFitWindow.png';
    BorderBottom                    = 'RichEdit\BorderBottom.png';
    BorderInsideHorizontal          = 'RichEdit\BorderInsideHorizontal.png';
    BorderInsideVertical            = 'RichEdit\BorderInsideVertical.png';
    BorderLeft                      = 'RichEdit\BorderLeft.png';
    BorderNone                      = 'RichEdit\BorderNone.png';
    BorderRight                     = 'RichEdit\BorderRight.png';
    BordersAll                      = 'RichEdit\BordersAll.png';
    BordersInside                   = 'RichEdit\BordersInside.png';
    BordersOutside                  = 'RichEdit\BordersOutside.png';
    BorderTop                       = 'RichEdit\BorderTop.png';
    CellsAlignmentBottomLeft        = 'RichEdit\AlignBottomLeft.png';
    CellsAlignmentBottomCenter      = 'RichEdit\AlignBottomCenter.png';
    CellsAlignmentBottomRight       = 'RichEdit\AlignBottomRight.png';
    CellsAlignmentMiddleLeft        = 'RichEdit\AlignMiddleLeft.png';
    CellsAlignmentMiddleCenter      = 'RichEdit\AlignMiddleCenter.png';
    CellsAlignmentMiddleRight       = 'RichEdit\AlignMiddleRight.png';
    CellsAlignmentTopLeft           = 'RichEdit\AlignTopLeft.png';
    CellsAlignmentTopCenter         = 'RichEdit\AlignTopCenter.png';
    CellsAlignmentTopRight          = 'RichEdit\AlignTopRight.png';
    DeleteCells                     = 'RichEdit\DeleteTableCells.png';
    DeleteColumns                   = 'RichEdit\DeleteTableColumns.png';
    DeleteHyperlink                 = 'SpreadSheet\DeleteHyperlink.png';
    DeleteRows                      = 'RichEdit\DeleteTableRows.png';
    DeleteTable                     = 'RichEdit\DeleteTable.png';
    DifferentFirstPage              = 'RichEdit\DifferentFirstPage.png';
    DifferentOddAndEvenPages        = 'RichEdit\DifferentOddEvenPages.png';
    FixedColumnWidth                = 'RichEdit\TableFixedColumnWidth.png';
    FloatingObjectFillColor         = 'RichEdit\FloatingObjectFillColor.png';
    FloatingObjectLayoutOptions     = 'RichEdit\FloatingObjectLayoutOptions.png';
    FloatingObjectOutlineColor      = 'RichEdit\FloatingObjectOutlineColor.png';
    Footer                          = 'RichEdit\Footer.png';
    GoToFooter                      = 'RichEdit\GoToFooter.png';
    GoToHeader                      = 'RichEdit\GoToHeader.png';
    Header                          = 'RichEdit\Header.png';
    InsertCaption                   = 'RichEdit\InsertCaption.png';
    InsertColumnsToTheLeft          = 'RichEdit\InsertTableColumnsToTheLeft.png';
    InsertColumnsToTheRight         = 'RichEdit\InsertTableColumnsToTheRight.png';
    InsertDataField                 = 'RichEdit\InsertDataField.png';
    InsertEquationCaption           = 'RichEdit\InsertEquationCaption.png';
    InsertFigureCaption             = 'RichEdit\InsertFigureCaption.png';
    InsertRowsAbove                 = 'RichEdit\InsertTableRowsAbove.png';
    InsertRowsBelow                 = 'RichEdit\InsertTableRowsBelow.png';
    InsertTableCaption              = 'RichEdit\InsertTableCaption.png';
    InsertTableCells                = 'RichEdit\InsertTableCells.png';
    InsertTableOfCaptions           = 'RichEdit\InsertTableOfCaptions.png';
    InsertTableOfContents           = 'RichEdit\InsertTableOfContents.png';
    InsertTableOfEquations          = 'RichEdit\InsertTableOfEquations.png';
    InsertTableOfFigures            = 'RichEdit\InsertTableOfFigures.png';
    LinkToPrevious                  = 'RichEdit\LinkToPrevious.png';
    MailMerge                       = 'RichEdit\MailMerge.png';
    PageCount                       = 'RichEdit\InsertPageCount.png';
    PageNumber                      = 'RichEdit\InsertPageNumber.png';
    ShowAllFieldCodes               = 'RichEdit\ShowAllFieldCodes.png';
    ShowAllFieldResults             = 'RichEdit\ShowAllFieldResults.png';
    ShowNextHeaderFooter            = 'RichEdit\GoToNextHeaderFooter.png';
    ShowPreviousHeaderFooter        = 'RichEdit\GoToPreviousHeaderFooter.png';
    SplitCells                      = 'RichEdit\SplitTableCells.png';
    SplitTable                      = 'RichEdit\SplitTable.png';
    TableProperties                 = 'RichEdit\TableProperties.png';
    TextBox                         = 'RichEdit\InsertTextBox.png';
    ToggleFieldCodes                = 'RichEdit\ToggleFieldCodes.png';
    UpdateField                     = 'RichEdit\UpdateField.png';
    UpdateTableOfContents           = 'RichEdit\UpdateTableOfContents.png';
    ViewMergedData                  = 'RichEdit\ViewMergedData.png';
    ViewTableGridlines              = 'RichEdit\ViewTableGridlines.png';
    //Zoom
    ZoomIn                          = 'Zoom\ZoomIn.png';
    ZoomOut                         = 'Zoom\ZoomOut.png';
    // Review
    CheckSpelling                   = 'RichEdit\SpellCheck.png';
    EditRangePermission             = 'RichEdit\EditRangePermission.png';
    ProtectDocument                 = 'RichEdit\ProtectDocument.png';
    UnprotectDocument               = 'RichEdit\UnprotectDocument.png';
    EncryptDocument                 = 'SpreadSheet\Encrypt.png';
  end;

implementation

const
  dxThisUnitName = 'dxRichEdit.Commands.Images';

end.
