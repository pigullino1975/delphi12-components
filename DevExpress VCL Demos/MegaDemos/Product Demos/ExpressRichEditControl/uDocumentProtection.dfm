inherited frmRichEditDocumentProtection: TfrmRichEditDocumentProtection
  inherited pnlSeparator: TPanel
    Top = 105
    ExplicitTop = 105
  end
  inherited RichEditControl: TdxRichEditControl
    Top = 105
    Height = 127
    OnDocumentProtectionChanged = RichEditControlDocumentProtectionChanged
    ExplicitTop = 105
    ExplicitHeight = 127
  end
  object pnlInfo: TPanel
    Left = 0
    Top = 57
    Width = 451
    Height = 48
    Align = alTop
    AutoSize = True
    BorderWidth = 8
    Color = 13499135
    ParentBackground = False
    TabOrder = 4
    DesignSize = (
      451
      48)
    object lbAccess: TcxLabel
      Left = 8
      Top = 9
      Caption = 'Restricted Access:'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      Transparent = True
    end
    object lbPermission: TcxLabel
      Left = 124
      Top = 9
      Anchors = [akLeft, akTop, akRight]
      Caption = 
        'Permission to this document is restricted. Only certain users ar' +
        'e authorized to edit specific portions of this document. The edi' +
        'table regions in this sample document are highlighted in yellow ' +
        'and differ from one user to the other. The default password for ' +
        'this document is '#39'123'#39'.'
      Properties.WordWrap = True
      Transparent = True
      Width = 977
    end
  end
end
