VERSION 5.00
Begin VB.Form fMain 
   Caption         =   "fMain"
   ClientHeight    =   6225
   ClientLeft      =   120
   ClientTop       =   420
   ClientWidth     =   7980
   LinkTopic       =   "Form1"
   ScaleHeight     =   415
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   532
   StartUpPosition =   1  'CenterOwner
   Begin VB.VScrollBar VScroll1 
      Height          =   3135
      LargeChange     =   5
      Left            =   6720
      Max             =   40
      Min             =   1
      TabIndex        =   1
      Top             =   360
      Value           =   4
      Width           =   375
   End
   Begin VB.PictureBox PIC 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   5655
      Left            =   360
      ScaleHeight     =   375
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   375
      TabIndex        =   0
      Top             =   240
      Width           =   5655
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
    SceneAddSegment vec2(4, 2), vec2(61, 66), 4


    SceneAddSegment vec2(Rnd * pW, Rnd * pH), vec2(Rnd * pW, Rnd * pH), 1 + Rnd * 4
    SceneAddSegment vec2(Rnd * pW, Rnd * pH), vec2(Rnd * pW, Rnd * pH), 1 + Rnd * 4

    SceneAddCircle vec2(200, 200), 25

    SceneAddRing vec2(100, 300), 25 - 2, 4


    Set Timer1 = New_c.Timer(40, True)
    Set TimerFPS = New_c.Timer(1000, True)
End Sub

Private Sub Form_Unload(Cancel As Integer)
'''    srfRELEASE
    End
End Sub

Private Sub Timer1_Timer()
    TESTsdf
    cnt = cnt + 1
End Sub

Private Sub TimerFPS_Timer()
    fMain.Caption = "Drawing with Signed Distance Field (SDF)    FPS: " & cnt - FPS & "   Border: " & Border
    FPS = cnt
End Sub

Private Sub VScroll1_Change()
    SetBorder VScroll1
End Sub

Private Sub VScroll1_Scroll()
    SetBorder VScroll1
End Sub
