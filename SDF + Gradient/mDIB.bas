Attribute VB_Name = "mDIB"
Option Explicit

Private Type BITMAPINFOHEADER
    biSize        As Long
    biWidth       As Long
    biHeight      As Long
    biPlanes      As Integer
    biBitCount    As Integer
    biCompression As Long
    biSizeImage   As Long
    biXPelsPerMeter As Double
    biClrUsed     As Double
End Type

Private Type BITMAPINFO
    bmiHeader     As BITMAPINFOHEADER
    bmiColors     As Long
End Type

Private bi32BitInfo As BITMAPINFO

Public BytesBuf() As Byte


Private Declare Function SetDIBitsToDevice Lib "gdi32" (ByVal hDC As Long, ByVal X As Long, ByVal Y As Long, ByVal dX As Long, ByVal dY As Long, ByVal SrcX As Long, ByVal SrcY As Long, ByVal Scan As Long, ByVal NumScans As Long, Bits As Any, BitsInfo As BITMAPINFO, ByVal wUsage As Long) As Long
Private Declare Function GetDIBits Lib "gdi32" (ByVal aHDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As BITMAPINFO, ByVal wUsage As Long) As Long

Private meWidth   As Long
Private meHeight  As Long

Private Color As tVec3


Public Sub InitByPIC(PIC As PictureBox)

    With bi32BitInfo.bmiHeader
        .biBitCount = 32
        .biPlanes = 1
        .biSize = Len(bi32BitInfo.bmiHeader)
        .biWidth = PIC.ScaleWidth
        .biHeight = PIC.ScaleHeight
        .biSizeImage = PIC.ScaleHeight * PIC.ScaleWidth * 4

    End With
    meWidth = PIC.ScaleWidth
    meHeight = PIC.ScaleHeight

    ReDim BytesBuf((PIC.ScaleWidth) * 4 - 1, PIC.ScaleHeight - 1)

    GetDIBits PIC.hDC, PIC.Image.Handle, 0, PIC.ScaleHeight, BytesBuf(0, 0), bi32BitInfo, 0
End Sub

Public Sub PaintToHDC(hDC As Long)
    SetDIBitsToDevice hDC, 0&, 0&, meWidth, meHeight, 0&, 0&, 0&, meHeight, BytesBuf(0&, 0&), bi32BitInfo, 0&
End Sub


Public Sub DrawUsingGDI()
    Dim X&, Y&
    Dim X40&, X41&, X42&
    Dim D         As tVec3

    Dim P#, Q#, T#
    T = Timer * 8#

    UpdateSegPos 1, vec2(180 + 100 * Cos(T * 0.13), _
                         120 + 100 * Cos(T * 0.09)), vec2(105, 105)
    UpdateSegPos 2, vec2(pW * 0.5 + pW * 0.4 * Cos(T * 0.075 + 1), _
                         pH * 0.5 + pH * 0.4 * Cos(T * 0.09 + 2)), _
                         vec2(pW * 0.5 + pW * 0.4 * Cos(T * 0.07 + 3), _
                              pH * 0.5 + pH * 0.4 * Cos(T * 0.05 + 4))


    UpdateRingPos 6, vec2(pW * 0.3 + pW * 0.2 * Cos(T * 0.07), pH * 0.7 + pH * 0.2 * Cos(T * 0.04))

    For X = 0 To pW1
        X40 = X * 4&
        X41 = X40 + 1&
        X42 = X40 + 2&

        For Y = 0 To pH1

            BytesBuf(X40, Y) = 41                ' BACKGROUND
            BytesBuf(X41, Y) = 64
            BytesBuf(X42, Y) = 41

            D = sdgSCENEex(vec2(X * 1, pH1 - Y))    ' << invert Y
            If D.X > 0# Then                     ' outside
                If D.X <= Border2 Then
                    '------------------------------------------
                    D.X = Sqr(D.X)
                    P = D.X * InvBorder
                    '------------------------------------------
                    '                                        P = D * InvBorder2
                    '------------------------------------------
                    Q = 1# - P
                    BytesBuf(X40, Y) = 255 * Q * (0.5 + 0.5 * D.Y) + P * BytesBuf(X40, Y)
                    BytesBuf(X41, Y) = 255 * Q * (0.5 + 0.5 * D.Z) + P * BytesBuf(X41, Y)
                    BytesBuf(X42, Y) = 200 * Q + P * BytesBuf(X42, Y)
                End If
            Else                                 'inside
            
     Color = vec3(1, 0.5, 0.8)
  If D.X Then Color = ADD3(Color, Clamp01(DOT3(vec3(-1, -1, 1), vec3(D.Y, D.Z, 8 / D.X))))
                BytesBuf(X40, Y) = Clamp01(Color.X) * 255
                BytesBuf(X41, Y) = Clamp01(Color.Y) * 255
                BytesBuf(X42, Y) = Clamp01(Color.Z) * 255
                
                
'                BytesBuf(X40, Y) = 255 * (0.5 + 0.5 * D.Y)
'                BytesBuf(X41, Y) = 255 * (0.5 + 0.5 * D.Z)
'                BytesBuf(X42, Y) = 200
            End If

        Next
    Next

    PaintToHDC PIChDC
End Sub
