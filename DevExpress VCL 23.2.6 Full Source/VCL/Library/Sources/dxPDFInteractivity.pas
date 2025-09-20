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

unit dxPDFInteractivity;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, SysUtils, Classes, Generics.Defaults, Generics.Collections, Graphics, dxCoreClasses, dxCoreGraphics,
  cxGeometry, dxPDFBase, dxPDFTypes, dxPDFCore, dxPDFRecognizedObject;

const
  dxPDFOutlineTreeItemDefaultColor = clNone;

type
  { TdxPDFJumpAction }

  TdxPDFJumpAction = class(TdxPDFCustomAction)
  strict private
    FDestination: TdxPDFCustomDestination;
    FDestinationInfo: TdxPDFDestinationInfo;
    //
    function GetDestination: TdxPDFCustomDestination;
    procedure SetDestination(const AValue: TdxPDFCustomDestination);
    procedure SetDestinationInfo(const AValue: TdxPDFDestinationInfo);
  protected
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    function IsInternal: Boolean; virtual; abstract;
    //
    property DestinationInfo: TdxPDFDestinationInfo read FDestinationInfo write SetDestinationInfo; // for internal use
  public
    property Destination: TdxPDFCustomDestination read GetDestination write SetDestination; // for internal use
  end;

  { TdxPDFGoToAction }

  TdxPDFGoToAction = class(TdxPDFJumpAction)
  protected
    function IsInternal: Boolean; override;
    procedure Execute(const AController: IdxPDFInteractivityController); override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFURIAction }

  TdxPDFURIAction = class(TdxPDFCustomAction)
  strict private
    FURI: string;
  protected
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Execute(const AController: IdxPDFInteractivityController); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property URI: string read FURI;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFNamedAction }

  TdxPDFNamedAction = class(TdxPDFCustomAction)
  strict private
    FActionName: string;
  protected
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Execute(const AController: IdxPDFInteractivityController); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property ActionName: string read FActionName;
  public
    class function GetTypeName: string; override;
  end;


  { TdxPDFEmbeddedGoToAction }

  TdxPDFEmbeddedGoToAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFGoTo3dViewAction }

  TdxPDFGoTo3dViewAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFHideAction }

  TdxPDFHideAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFImportDataAction }

  TdxPDFImportDataAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFJavaScriptAction }

  TdxPDFJavaScriptAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFLaunchAction }

  TdxPDFLaunchAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFMovieAction }

  TdxPDFMovieAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFRemoteGoToAction }

  TdxPDFRemoteGoToAction = class(TdxPDFJumpAction)
  strict private
    FFileName: string;
  protected
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFRenditionAction }

  TdxPDFRenditionAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFResetFormAction }

  TdxPDFResetFormAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFSetOCGStateAction }

  TdxPDFSetOCGStateAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFSoundAction }

  TdxPDFSoundAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFSubmitFormAction }

  TdxPDFSubmitFormAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFThreadAction }

  TdxPDFThreadAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFTransitionAction }

  TdxPDFTransitionAction = class(TdxPDFCustomAction)
  public
    class function GetTypeName: string; override;
  end;

implementation

uses
  Math, dxPDFUtils, dxCore;

const
  dxThisUnitName = 'dxPDFInteractivity';

type
  TdxPDFCustomDestinationAccess = class(TdxPDFCustomDestination);

{ TdxPDFJumpAction }

procedure TdxPDFJumpAction.DestroySubClasses;
begin
  DestinationInfo := nil;
  Destination := nil;
  inherited DestroySubClasses;
end;

procedure TdxPDFJumpAction.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  DestinationInfo := ADictionary.GetDestinationInfo(TdxPDFKeywords.ActionDestination);
end;

procedure TdxPDFJumpAction.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.ActionDestination, DestinationInfo);
end;

function TdxPDFJumpAction.GetDestination: TdxPDFCustomDestination;
begin
  if FDestination <> nil then
    Result := FDestination
  else
    if FDestinationInfo <> nil then
    begin
      if FDestination = nil then
        Destination := FDestinationInfo.GetDestination(Catalog, IsInternal);
      Result := FDestination;
    end
    else
      Result := nil;
end;

procedure TdxPDFJumpAction.SetDestination(const AValue: TdxPDFCustomDestination);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDestination));
end;

procedure TdxPDFJumpAction.SetDestinationInfo(const AValue: TdxPDFDestinationInfo);
begin
  dxPDFChangeValue(AValue, TdxPDFReferencedObject(FDestinationInfo));
end;

{ TdxPDFGoToAction }

class function TdxPDFGoToAction.GetTypeName: string;
begin
  Result := 'GoTo';
end;

function TdxPDFGoToAction.IsInternal: Boolean;
begin
  Result := True;
end;

procedure TdxPDFGoToAction.Execute(const AController: IdxPDFInteractivityController);
var
  ADestination: TdxPDFCustomDestination;
begin
  ADestination := Destination;
  if ADestination <> nil then
    AController.ShowDocumentPosition(TdxPDFCustomDestinationAccess(ADestination).GetTarget);
end;

{ TdxPDFURIAction }

class function TdxPDFURIAction.GetTypeName: string;
begin
  Result := 'URI';
end;

procedure TdxPDFURIAction.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FURI := TdxPDFUtils.ConvertToUTF8String(ADictionary.GetBytes(GetTypeName));
end;

procedure TdxPDFURIAction.Execute(const AController: IdxPDFInteractivityController);
begin
  AController.OpenURI(URI);
end;

procedure TdxPDFURIAction.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(GetTypeName, FURI);
end;

{ TdxPDFNamedAction }

class function TdxPDFNamedAction.GetTypeName: string;
begin
  Result := TdxPDFKeywords.ActionNamed;
end;

procedure TdxPDFNamedAction.Execute(const AController: IdxPDFInteractivityController);
begin
  if FActionName = 'NextPage' then
    AController.GoToNextPage
  else if FActionName = 'PrevPage' then
    AController.GoToPrevPage
  else if FActionName = 'FirstPage' then
    AController.GoToFirstPage
  else if FActionName = 'LastPage' then
    AController.GoToLastPage;
end;

procedure TdxPDFNamedAction.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FActionName := ADictionary.GetString(TdxPDFKeywords.ActionName);
end;

procedure TdxPDFNamedAction.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.ActionName, FActionName);
end;

{ TdxPDFEmbeddedGoToAction }

class function TdxPDFEmbeddedGoToAction.GetTypeName: string;
begin
  Result := 'GoToE';
end;

{ TdxPDFGoTo3dViewAction }

class function TdxPDFGoTo3dViewAction.GetTypeName: string;
begin
  Result := 'GoTo3DView';
end;

{ TdxPDFHideAction }

class function TdxPDFHideAction.GetTypeName: string;
begin
  Result := 'Hide';
end;

{ TdxPDFImportDataAction }

class function TdxPDFImportDataAction.GetTypeName: string;
begin
  Result := 'ImportData';
end;

{ TdxPDFJavaScriptAction }

class function TdxPDFJavaScriptAction.GetTypeName: string;
begin
  Result := 'JavaScript';
end;

{ TdxPDFLaunchAction }

class function TdxPDFLaunchAction.GetTypeName: string;
begin
  Result := 'Launch';
end;

{ TdxPDFMovieAction }

class function TdxPDFMovieAction.GetTypeName: string;
begin
  Result := 'Movie';
end;

{ TdxPDFRemoteGoToAction }

class function TdxPDFRemoteGoToAction.GetTypeName: string;
begin
  Result := 'GoToR';
end;

procedure TdxPDFRemoteGoToAction.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FFileName := ADictionary.GetString(TdxPDFKeywords.FileName);
end;

procedure TdxPDFRemoteGoToAction.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.FileName, FFileName);
end;

{ TdxPDFRenditionAction }

class function TdxPDFRenditionAction.GetTypeName: string;
begin
  Result := 'Rendition';
end;

{ TdxPDFResetFormAction }

class function TdxPDFResetFormAction.GetTypeName: string;
begin
  Result := 'ResetForm';
end;

{ TdxPDFSetOCGStateAction }

class function TdxPDFSetOCGStateAction.GetTypeName: string;
begin
  Result := 'SetOCGState';
end;

{ TdxPDFSoundAction }

class function TdxPDFSoundAction.GetTypeName: string;
begin
  Result := 'Sound';
end;

{ TdxPDFSubmitFormAction }

class function TdxPDFSubmitFormAction.GetTypeName: string;
begin
  Result := 'SubmitForm';
end;

{ TdxPDFThreadAction }

class function TdxPDFThreadAction.GetTypeName: string;
begin
  Result := 'Thread';
end;

{ TdxPDFTransitionAction }

class function TdxPDFTransitionAction.GetTypeName: string;
begin
  Result := 'Trans';
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFRegisterDocumentObjectClass(TdxPDFGoToAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFURIAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFEmbeddedGoToAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFGoTo3dViewAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFHideAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFImportDataAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFJavaScriptAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFLaunchAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFNamedAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFRemoteGoToAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFRenditionAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFResetFormAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFSetOCGStateAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFSoundAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFSubmitFormAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFThreadAction);
  dxPDFRegisterDocumentObjectClass(TdxPDFTransitionAction);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFUnregisterDocumentObjectClass(TdxPDFTransitionAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFThreadAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFSubmitFormAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFSoundAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFSetOCGStateAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFResetFormAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFRenditionAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFRemoteGoToAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFNamedAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFLaunchAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFJavaScriptAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFImportDataAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFHideAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFGoTo3dViewAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFEmbeddedGoToAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFURIAction);
  dxPDFUnregisterDocumentObjectClass(TdxPDFGoToAction);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

