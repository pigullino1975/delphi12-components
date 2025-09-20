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

unit dxPDFViewerAnnotations; // for internal use

{$I cxVer.inc}

interface

uses
  Classes, Controls, cxGraphics, dxPDFCore, dxPDFViewer;

type
  { TdxPDFViewerInteractiveAnnotationViewInfo }

  TdxPDFViewerInteractiveAnnotationViewInfo = class(TdxPDFViewerCustomAnnotationViewInfo, IdxPDFInteractiveObject)
  protected
    function AllowActivateByMouseDown: Boolean;
    function GetAction: TdxPDFInteractiveOperation; virtual;
  end;

  { TdxPDFViewerMarkupAnnotationViewInfo }

  TdxPDFViewerMarkupAnnotationViewInfo = class(TdxPDFViewerInteractiveAnnotationViewInfo)
  protected
    function CanFocus: Boolean; override;
    function GetHint: string; override;
  end;

  { TdxPDFViewerFileAttachmentViewInfo }

  TdxPDFViewerFileAttachmentViewInfo = class(TdxPDFViewerMarkupAnnotationViewInfo)
  strict private
    function GetAttachment: TdxPDFFileAttachment;
  protected
    function CanFocus: Boolean; override;
    function GetCursor: TCursor; override;
    function GetHitCode: Integer; override;
    //
    property Attachment: TdxPDFFileAttachment read GetAttachment;
  end;

  { TdxPDFViewerHyperlinkViewInfo }

  TdxPDFViewerHyperlinkViewInfo = class(TdxPDFViewerInteractiveAnnotationViewInfo)
  protected
    function CanFocus: Boolean; override;
    function GetCursor: TCursor; override;
    function GetHint: string; override;
    function GetHitCode: Integer; override;
    procedure Execute(AShift: TShiftState = []); override;
  end;

implementation

uses
  Types, Graphics, cxLibraryConsts, cxGeometry, dxPDFAnnotation, dxCore;

const
  dxThisUnitName = 'dxPDFViewerAnnotations';

{ TdxPDFViewerInteractiveAnnotationViewInfo }

function TdxPDFViewerInteractiveAnnotationViewInfo.AllowActivateByMouseDown: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerInteractiveAnnotationViewInfo.GetAction: TdxPDFInteractiveOperation;
begin
  Result := (Annotation as TdxPDFActionAnnotation).InteractiveOperation;
end;

{ TdxPDFViewerMarkupAnnotationViewInfo }

function TdxPDFViewerMarkupAnnotationViewInfo.CanFocus: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerMarkupAnnotationViewInfo.GetHint: string;
begin
  Result := (Annotation as TdxPDFMarkupAnnotation).Hint;
end;

{ TdxPDFViewerFileAttachmentViewInfo }

function TdxPDFViewerFileAttachmentViewInfo.CanFocus: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerFileAttachmentViewInfo.GetCursor: TCursor;
begin
  Result := crdxPDFViewerContext;
end;

function TdxPDFViewerFileAttachmentViewInfo.GetHitCode: Integer;
begin
  Result := hcAttachment;
end;

function TdxPDFViewerFileAttachmentViewInfo.GetAttachment: TdxPDFFileAttachment;
begin
  Result := (Annotation as TdxPDFFileAttachmentAnnotation).Attachment;
end;

{ TdxPDFViewerHyperlinkViewInfo }

function TdxPDFViewerHyperlinkViewInfo.CanFocus: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerHyperlinkViewInfo.GetCursor: TCursor;
begin
  Result := crHandPoint;
end;

function TdxPDFViewerHyperlinkViewInfo.GetHint: string;
begin
  Result := (Annotation as TdxPDFLinkAnnotation).Hint;
end;

function TdxPDFViewerHyperlinkViewInfo.GetHitCode: Integer;
begin
  Result := hcHyperlink;
end;

procedure TdxPDFViewerHyperlinkViewInfo.Execute(AShift: TShiftState = []);
begin
  (Controller as TdxPDFViewerController).ExecuteOperation(GetAction);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFFileAttachmentAnnotation, TdxPDFViewerFileAttachmentViewInfo);
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFLinkAnnotation, TdxPDFViewerHyperlinkViewInfo);
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFMarkupAnnotation, TdxPDFViewerMarkupAnnotationViewInfo);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFMarkupAnnotation);
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFLinkAnnotation);
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFFileAttachmentAnnotation);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
