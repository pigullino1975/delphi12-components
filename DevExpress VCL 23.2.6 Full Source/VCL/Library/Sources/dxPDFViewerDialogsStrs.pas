{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPDFViewer                                         }
{                                                                    }
{           Copyright (c) 2015-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPDFVIEWER AND ALL              }
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

unit dxPDFViewerDialogsStrs;

{$I cxVer.Inc}

interface

uses
  dxCore;

resourcestring
  sdxPDFViewerDocumentPropertiesDialogAdvanced = 'Advanced';
  sdxPDFViewerDocumentPropertiesDialogApplication = 'Application:';
  sdxPDFViewerDocumentPropertiesDialogAuthor = 'Author:';
  sdxPDFViewerDocumentPropertiesDialogCaption = 'Document Properties';
  sdxPDFViewerDocumentPropertiesDialogCreated = 'Created:';
  sdxPDFViewerDocumentPropertiesDialogDescription = 'Description';
  sdxPDFViewerDocumentPropertiesDialogFile = 'File:';
  sdxPDFViewerDocumentPropertiesDialogFileSize = 'File Size:';
  sdxPDFViewerDocumentPropertiesDialogKeywords = 'Keywords:';
  sdxPDFViewerDocumentPropertiesDialogLocation = 'Location:';
  sdxPDFViewerDocumentPropertiesDialogModified = 'Modified:';
  sdxPDFViewerDocumentPropertiesDialogNumberOfPages = 'Number of Pages:';
  sdxPDFViewerDocumentPropertiesDialogPageSize = 'Page Size:';
  sdxPDFViewerDocumentPropertiesDialogProducer = 'Producer:';
  sdxPDFViewerDocumentPropertiesDialogRevision = 'Revision';
  sdxPDFViewerDocumentPropertiesDialogSubject = 'Subject:';
  sdxPDFViewerDocumentPropertiesDialogTitle = 'Title:';
  sdxPDFViewerDocumentPropertiesDialogVersion = 'Version:';

  sdxPDFViewerRotatePagesDialogCaption = 'Rotate Pages';
  sdxPDFViewerRotatePagesRotation = '&Rotation:';
  sdxPDFViewerRotatePagesClockwise90DegreesDirection = '90 Degrees Clockwise';
  sdxPDFViewerRotatePages180DegreesDirection = '180 Degrees';
  sdxPDFViewerRotatePagesCounterclockwise90DegreesDirection = '90 Degrees Counterclockwise';
  sdxPDFViewerRotatePagesPageRange = 'Page Range: Selected %d of %d Pages';
  sdxPDFViewerRotatePagesPageSubset = 'Page Subset';
  sdxPDFViewerRotatePagesPageNumbersSubset = '&Numbers:';
  sdxPDFViewerRotatePagesAllPagesSubset = 'All';
  sdxPDFViewerRotatePagesOddPagesSubset = 'Odd';
  sdxPDFViewerRotatePagesEvenPagesSubset = 'Even';
  sdxPDFViewerRotatePagesPageOrientation = '&Orientation:';
  sdxPDFViewerRotatePagesAllOrientationSubset = 'Pages of Any Orientation';
  sdxPDFViewerRotatePagesLandscapeOrientationSubset = 'Landscape Pages';
  sdxPDFViewerRotatePagesPortraitOrientationSubset = 'Portrait Pages';

  sdxPDFViewerPasswordDialogCaption = 'Enter Password';
  sdxPDFViewerPasswordDialogProtectedDocument = 'This document is password protected. Enter a valid user or owner password to open it.';
  sdxPDFViewerPasswordDialogPassword = 'Password:';
  sdxPDFViewerPasswordDialogButtonCancel = 'Cancel';
  sdxPDFViewerPasswordDialogButtonOK = 'OK';

  sdxPDFViewerFindPanelFindCaption = 'Search';
  sdxPDFViewerFindPanelNextButtonCaption = 'Next';
  sdxPDFViewerFindPanelPreviousButtonCaption = 'Previous';
  sdxPDFViewerTextSearchingNoMatchesFoundMessage = 'Finished searching the document. No matches were found.';
  sdxPDFViewerTextSearchingCompleteMessage = 'Finished searching the document. No more matches were found.';

  sdxPDFViewerPopupMenuCopyImage = 'Copy Image';
  sdxPDFViewerPopupMenuCopyText = 'Copy';
  sdxPDFViewerPopupMenuDocumentProperties = 'Document Properties...';
  sdxPDFViewerPopupMenuPrint = 'Print...';

  sdxPDFViewerPopupMenuOpenAttachmentFileText = 'Open File';
  sdxPDFViewerPopupMenuSaveAttachmentFileText = 'Save Embedded File to Disk...';

  sdxPDFViewerFindPanelPopupMenuCaseSensitive = 'Case Sensitive';
  sdxPDFViewerFindPanelPopupMenuWholeWords = 'Whole Words Only';

  sdxPDFViewerBookmarkPopupMenuGoToBookmark = 'Go to Bookmark';
  sdxPDFViewerBookmarkPopupMenuPrintPages = 'Print Pages...';
  sdxPDFViewerBookmarkPopupMenuPrintSections = 'Print Sections...';
  sdxPDFViewerBookmarksOptionsPopupMenuCollapseTopLevelBookmarks = 'Collapse Top-Level Bookmarks';
  sdxPDFViewerBookmarksOptionsPopupMenuExpandCurrentBookmark = 'Expand Current Bookmark';
  sdxPDFViewerBookmarksOptionsPopupMenuExpandTopLevelBookmarks = 'Expand Top-Level Bookmarks';
  sdxPDFViewerBookmarksOptionsPopupMenuHideAfterUse = 'Hide After Use';
  sdxPDFViewerBookmarksOptionsPopupMenuLargeTextSize = 'Large';
  sdxPDFViewerBookmarksOptionsPopupMenuMediumTextSize = 'Medium';
  sdxPDFViewerBookmarksOptionsPopupMenuSmallTextSize = 'Small';
  sdxPDFViewerBookmarksOptionsPopupMenuTextSize = 'Text Size';

  sdxPDFViewerNavigationPageAttachmentDescriptionCaption = 'Description: ';
  sdxPDFViewerNavigationPageAttachmentFileNameCaption = 'Name: ';
  sdxPDFViewerNavigationPageAttachmentFileSizeCaption = 'Size: ';
  sdxPDFViewerNavigationPageAttachmentModifiedCaption = 'Modified: ';
  sdxPDFViewerNavigationPageAttachmentsCaption = 'Attachments';
  sdxPDFViewerNavigationPageOpenAttachmentButtonHint = 'Open file in its native application';
  sdxPDFViewerNavigationPageSaveAttachmentButtonHint = 'Save attachment';

  sdxPDFViewerNavigationPageBookmarksCaption = 'Bookmarks';
  sdxPDFViewerNavigationPageThumbnailsCaption = 'Page Thumbnails';
  sdxPDFViewerNavigationPageExpandBookmarkButtonHint = 'Expand current bookmark';
  sdxPDFViewerNavigationPageOptionsButtonHint = 'Options';
  sdxPDFViewerNavigationPageThumbnailsSizeTrackBarHint = 'Zoom page thumbnails';
  sdxPDFViewerNavigationPageExpandButtonHint = 'Expand';
  sdxPDFViewerNavigationPageCollapseButtonHint = 'Collapse';
  sdxPDFViewerNavigationPageHideButtonHint = 'Hide';
  sdxPDFViewerThumbnailPopupMenuEnlargePageThumbnails = 'Enlarge Page Thumbnails';
  sdxPDFViewerThumbnailPopupMenuPrintPages = 'Print Pages...';
  sdxPDFViewerThumbnailPopupMenuReducePageThumbnails = 'Reduce Page Thumbnails';
  sdxPDFViewerThumbnailPopupMenuRotatePages = 'Rotate Pages...';

  sdxPDFViewerBytes = 'Bytes';
  sdxPDFViewerKiloBytes = 'KB';
  sdxPDFViewerMegaBytes = 'MB';
  sdxPDFViewerGigaBytes = 'GB';
  sdxPDFViewerUnitsInches = 'in';

implementation

const
  dxThisUnitName = 'dxPDFViewerDialogsStrs';

procedure AddPDFViewerDialogsResourceStrings(AProduct: TdxProductResourceStrings);
begin
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogAdvanced', @sdxPDFViewerDocumentPropertiesDialogAdvanced);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogApplication', @sdxPDFViewerDocumentPropertiesDialogApplication);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogAuthor', @sdxPDFViewerDocumentPropertiesDialogAuthor);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogCaption', @sdxPDFViewerDocumentPropertiesDialogCaption);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogCreated', @sdxPDFViewerDocumentPropertiesDialogCreated);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogDescription', @sdxPDFViewerDocumentPropertiesDialogDescription);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogFile', @sdxPDFViewerDocumentPropertiesDialogFile);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogFileSize', @sdxPDFViewerDocumentPropertiesDialogFileSize);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogKeywords', @sdxPDFViewerDocumentPropertiesDialogKeywords);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogLocation', @sdxPDFViewerDocumentPropertiesDialogLocation);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogModified', @sdxPDFViewerDocumentPropertiesDialogModified);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogNumberOfPages', @sdxPDFViewerDocumentPropertiesDialogNumberOfPages);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogPageSize', @sdxPDFViewerDocumentPropertiesDialogPageSize);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogProducer', @sdxPDFViewerDocumentPropertiesDialogProducer);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogRevision', @sdxPDFViewerDocumentPropertiesDialogRevision);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogSubject', @sdxPDFViewerDocumentPropertiesDialogSubject);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogTitle', @sdxPDFViewerDocumentPropertiesDialogTitle);
  AProduct.Add('sdxPDFViewerDocumentPropertiesDialogVersion', @sdxPDFViewerDocumentPropertiesDialogVersion);

  AProduct.Add('sdxPDFViewerRotatePagesDialogCaption', @sdxPDFViewerRotatePagesDialogCaption);
  AProduct.Add('sdxPDFViewerRotatePagesRotation', @sdxPDFViewerRotatePagesRotation);
  AProduct.Add('sdxPDFViewerRotatePagesClockwise90DegreesDirection', @sdxPDFViewerRotatePagesClockwise90DegreesDirection);
  AProduct.Add('sdxPDFViewerRotatePages180DegreesDirection', @sdxPDFViewerRotatePages180DegreesDirection);
  AProduct.Add('sdxPDFViewerRotatePagesCounterclockwise90DegreesDirection', @sdxPDFViewerRotatePagesCounterclockwise90DegreesDirection);
  AProduct.Add('sdxPDFViewerRotatePagesPageRange', @sdxPDFViewerRotatePagesPageRange);
  AProduct.Add('sdxPDFViewerRotatePagesPageSubset', @sdxPDFViewerRotatePagesPageSubset);
  AProduct.Add('sdxPDFViewerRotatePagesPageNumbersSubset', @sdxPDFViewerRotatePagesPageNumbersSubset);
  AProduct.Add('sdxPDFViewerRotatePagesAllPagesSubset', @sdxPDFViewerRotatePagesAllPagesSubset);
  AProduct.Add('sdxPDFViewerRotatePagesOddPagesSubset', @sdxPDFViewerRotatePagesOddPagesSubset);
  AProduct.Add('sdxPDFViewerRotatePagesEvenPagesSubset', @sdxPDFViewerRotatePagesEvenPagesSubset);
  AProduct.Add('sdxPDFViewerRotatePagesPageOrientation', @sdxPDFViewerRotatePagesPageOrientation);
  AProduct.Add('sdxPDFViewerRotatePagesAllOrientationSubset', @sdxPDFViewerRotatePagesAllOrientationSubset);
  AProduct.Add('sdxPDFViewerRotatePagesLandscapeOrientationSubset', @sdxPDFViewerRotatePagesLandscapeOrientationSubset);
  AProduct.Add('sdxPDFViewerRotatePagesPortraitOrientationSubset', @sdxPDFViewerRotatePagesPortraitOrientationSubset);

  AProduct.Add('sdxPDFViewerPasswordDialogCaption', @sdxPDFViewerPasswordDialogCaption);
  AProduct.Add('sdxPDFViewerPasswordDialogProtectedDocument', @sdxPDFViewerPasswordDialogProtectedDocument);
  AProduct.Add('sdxPDFViewerPasswordDialogPassword', @sdxPDFViewerPasswordDialogPassword);
  AProduct.Add('sdxPDFViewerPasswordDialogButtonCancel', @sdxPDFViewerPasswordDialogButtonCancel);
  AProduct.Add('sdxPDFViewerPasswordDialogButtonOK', @sdxPDFViewerPasswordDialogButtonOK);

  AProduct.Add('sdxPDFViewerPopupMenuCopyImage', @sdxPDFViewerPopupMenuCopyImage);
  AProduct.Add('sdxPDFViewerPopupMenuCopyText', @sdxPDFViewerPopupMenuCopyText);
  AProduct.Add('sdxPDFViewerPopupMenuDocumentProperties', @sdxPDFViewerPopupMenuDocumentProperties);
  AProduct.Add('sdxPDFViewerPopupMenuPrint', @sdxPDFViewerPopupMenuPrint);

  AProduct.Add('sdxPDFViewerPopupMenuOpenAttachmentFileText', @sdxPDFViewerPopupMenuOpenAttachmentFileText);
  AProduct.Add('sdxPDFViewerPopupMenuSaveAttachmentFileText', @sdxPDFViewerPopupMenuSaveAttachmentFileText);

  AProduct.Add('sdxPDFViewerFindPanelFindCaption', @sdxPDFViewerFindPanelFindCaption);
  AProduct.Add('sdxPDFViewerFindPanelNextButtonCaption', @sdxPDFViewerFindPanelNextButtonCaption);
  AProduct.Add('sdxPDFViewerFindPanelPreviousButtonCaption', @sdxPDFViewerFindPanelPreviousButtonCaption);
  AProduct.Add('sdxPDFViewerTextSearchingNoMatchesFoundMessage', @sdxPDFViewerTextSearchingNoMatchesFoundMessage);
  AProduct.Add('sdxPDFViewerTextSearchingCompleteMessage', @sdxPDFViewerTextSearchingCompleteMessage);

  AProduct.Add('sdxPDFViewerFindPanelPopupMenuCaseSensitive', @sdxPDFViewerFindPanelPopupMenuCaseSensitive);
  AProduct.Add('sdxPDFViewerFindPanelPopupMenuWholeWords', @sdxPDFViewerFindPanelPopupMenuWholeWords);

  AProduct.Add('sdxPDFViewerBookmarkPopupMenuGoToBookmark', @sdxPDFViewerBookmarkPopupMenuGoToBookmark);
  AProduct.Add('sdxPDFViewerBookmarkPopupMenuPrintPages', @sdxPDFViewerBookmarkPopupMenuPrintPages);
  AProduct.Add('sdxPDFViewerBookmarkPopupMenuPrintSections', @sdxPDFViewerBookmarkPopupMenuPrintSections);
  AProduct.Add('sdxPDFViewerBookmarksOptionsPopupMenuCollapseTopLevelBookmarks', @sdxPDFViewerBookmarksOptionsPopupMenuCollapseTopLevelBookmarks);
  AProduct.Add('sdxPDFViewerBookmarksOptionsPopupMenuExpandCurrentBookmark', @sdxPDFViewerBookmarksOptionsPopupMenuExpandCurrentBookmark);
  AProduct.Add('sdxPDFViewerBookmarksOptionsPopupMenuExpandTopLevelBookmarks', @sdxPDFViewerBookmarksOptionsPopupMenuExpandTopLevelBookmarks);
  AProduct.Add('sdxPDFViewerBookmarksOptionsPopupMenuHideAfterUse', @sdxPDFViewerBookmarksOptionsPopupMenuHideAfterUse);
  AProduct.Add('sdxPDFViewerBookmarksOptionsPopupMenuLargeTextSize', @sdxPDFViewerBookmarksOptionsPopupMenuLargeTextSize);
  AProduct.Add('sdxPDFViewerBookmarksOptionsPopupMenuMediumTextSize', @sdxPDFViewerBookmarksOptionsPopupMenuMediumTextSize);
  AProduct.Add('sdxPDFViewerBookmarksOptionsPopupMenuSmallTextSize', @sdxPDFViewerBookmarksOptionsPopupMenuSmallTextSize);
  AProduct.Add('sdxPDFViewerBookmarksOptionsPopupMenuTextSize', @sdxPDFViewerBookmarksOptionsPopupMenuTextSize);

  AProduct.Add('sdxPDFViewerNavigationPageAttachmentDescriptionCaption', @sdxPDFViewerNavigationPageAttachmentDescriptionCaption);
  AProduct.Add('sdxPDFViewerNavigationPageAttachmentFileNameCaption', @sdxPDFViewerNavigationPageAttachmentFileNameCaption);
  AProduct.Add('sdxPDFViewerNavigationPageAttachmentFileSizeCaption', @sdxPDFViewerNavigationPageAttachmentFileSizeCaption);
  AProduct.Add('sdxPDFViewerNavigationPageAttachmentModifiedCaption', @sdxPDFViewerNavigationPageAttachmentModifiedCaption);
  AProduct.Add('sdxPDFViewerNavigationPageAttachmentsCaption', @sdxPDFViewerNavigationPageAttachmentsCaption);
  AProduct.Add('sdxPDFViewerNavigationPageOpenAttachmentButtonHint', @sdxPDFViewerNavigationPageOpenAttachmentButtonHint);
  AProduct.Add('sdxPDFViewerNavigationPageSaveAttachmentButtonHint', @sdxPDFViewerNavigationPageSaveAttachmentButtonHint);

  AProduct.Add('sdxPDFViewerNavigationPageBookmarksCaption', @sdxPDFViewerNavigationPageBookmarksCaption);
  AProduct.Add('sdxPDFViewerNavigationPageExpandBookmarkButtonHint', @sdxPDFViewerNavigationPageExpandBookmarkButtonHint);
  AProduct.Add('sdxPDFViewerNavigationPageOptionsButtonHint', @sdxPDFViewerNavigationPageOptionsButtonHint);
  AProduct.Add('sdxPDFViewerNavigationPageExpandButtonHint', @sdxPDFViewerNavigationPageExpandButtonHint);
  AProduct.Add('sdxPDFViewerNavigationPageCollapseButtonHint', @sdxPDFViewerNavigationPageCollapseButtonHint);
  AProduct.Add('sdxPDFViewerNavigationPageHideButtonHint', @sdxPDFViewerNavigationPageHideButtonHint);
  AProduct.Add('sdxPDFViewerNavigationPageThumbnailsCaption', @sdxPDFViewerNavigationPageThumbnailsCaption);
  AProduct.Add('sdxPDFViewerNavigationPageThumbnailsSizeTrackBarHint', @sdxPDFViewerNavigationPageThumbnailsSizeTrackBarHint);
  AProduct.Add('sdxPDFViewerThumbnailPopupMenuEnlargePageThumbnails', @sdxPDFViewerThumbnailPopupMenuEnlargePageThumbnails);
  AProduct.Add('sdxPDFViewerThumbnailPopupMenuPrintPages', @sdxPDFViewerThumbnailPopupMenuPrintPages);
  AProduct.Add('sdxPDFViewerThumbnailPopupMenuRotatePages', @sdxPDFViewerThumbnailPopupMenuRotatePages);
  AProduct.Add('sdxPDFViewerThumbnailPopupMenuReducePageThumbnails', @sdxPDFViewerThumbnailPopupMenuReducePageThumbnails);

  AProduct.Add('sdxPDFViewerBytes', @sdxPDFViewerBytes);
  AProduct.Add('sdxPDFViewerKiloBytes', @sdxPDFViewerKiloBytes);
  AProduct.Add('sdxPDFViewerMegaBytes', @sdxPDFViewerMegaBytes);
  AProduct.Add('sdxPDFViewerGigaBytes', @sdxPDFViewerGigaBytes);
  AProduct.Add('sdxPDFViewerUnitsInches', @sdxPDFViewerUnitsInches);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxResourceStringsRepository.RegisterProduct('ExpressPDFViewer', @AddPDFViewerDialogsResourceStrings);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxResourceStringsRepository.UnRegisterProduct('ExpressPDFViewer', @AddPDFViewerDialogsResourceStrings);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

