VERSION 5.00
Begin VB.Form fMain 
   Caption         =   "fMain"
   ClientHeight    =   6060
   ClientLeft      =   120
   ClientTop       =   420
   ClientWidth     =   8025
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   12
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   ScaleHeight     =   404
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   535
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox chkRC 
      Caption         =   "Render using RC6"
      Height          =   855
      Left            =   6240
      TabIndex        =   2
      Top             =   4680
      Width           =   1575
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   3135
      LargeChange     =   5
      Left            =   6480
      Max             =   40
      Min             =   1
      TabIndex        =   1
      Top             =   120
      Value           =   1
      Width           =   375
   End
   Begin VB.PictureBox PIC 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   5535
      Left            =   120
      ScaleHeight     =   369
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   369
      TabIndex        =   0
      Top             =   120
      Width           =   5535
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private WithEvents Timer1 As cTimer
Attribute Timer1.VB_VarHelpID = -1
Private WithEvents TimerFPS As cTimer
Attribute TimerFPS.VB_VarHelpID = -1

Private Sub chkRC_Click()
    DoRC6 = chkRC = vbChecked

End Sub

Private Sub Form_Load()

    pW = PIC.Width
    pH = PIC.Height
    pW1 = pW - 1
    pH1 = pH - 1

    Set SRF = Cairo.CreateSurface(pW, pH, ImageSurface)
    Set CC = SRF.CreateContext

    PIChDC = fMain.PIC.hDC

    '''    srfBIND
    SetBorder VScroll1

    SceneAddSegment vec2(4, 4), vec2(67, 66), 8
    'SceneAddSegment vec2(4, 2), vec2(61, 66), 4
    SceneAddUnevenCapsule vec2(4, 2), vec2(61, 66), 3, 25


    SceneAddSegment vec2(Rnd * pW, Rnd * pH), vec2(Rnd * pW, Rnd * pH), 1 + Rnd * 4
    SceneAddSegment vec2(Rnd * pW, Rnd * pH), vec2(Rnd * pW, Rnd * pH), 1 + Rnd * 4



    SceneAddCircle vec2(200, 200), 25

    SceneAddRing vec2(100, 300), 25 - 2, 4


    InitByPIC PIC


    Set Timer1 = New_c.Timer(40, True)
    Set TimerFPS = New_c.Timer(1000, True)
End Sub

Private Sub Form_Unload(Cancel As Integer)
'''    srfRELEASE
    End
End Sub

Private Sub Timer1_Timer()
    If DoRC6 Then
        DrawUsingRC6
    Else
        DrawUsingGDI
    End If

    cnt = cnt + 1
End Sub

Private Sub TimerFPS_Timer()
    fMain.Caption = "Drawing with Signed Distance Function (SDF)    FPS: " & cnt - FPS & "   Border: " & Border
    FPS = cnt
End Sub

Private Sub VScroll1_Change()
    SetBorder VScroll1
End Sub

Private Sub VScroll1_Scroll()
    SetBorder VScroll1
End Sub
