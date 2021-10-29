Attribute VB_Name = "mRC6"
Option Explicit

'Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal pDest As Long, ByVal pSrc As Long, ByVal ByteLen As Long)

Public SRF        As cCairoSurface
Public CC         As cCairoContext
Public pW         As Long
Public pH         As Long
Public pW1        As Long
Public pH1        As Long


Public cnt        As Long
Public FPS        As Long

Public srfBYTES() As Byte

Public Border#, Border2#, InvBorder#, InvBorder2#
Attribute Border2.VB_VarUserMemId = 1073741833
Attribute InvBorder.VB_VarUserMemId = 1073741833
Attribute InvBorder2.VB_VarUserMemId = 1073741833

Public PIChDC     As Long

Public Function SetBorder(v#)
    Border = v
    Border2 = v * v
    InvBorder = 1 / Border
    InvBorder2 = 1 / Border2

End Function
Public Sub DrawUsingRC6()

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




    CC.SetSourceRGB 0.16, 0.25, 0.16
    CC.Paint

    SRF.BindToArray srfBYTES()

    For X = 0 To pW1
        X40 = X * 4&
        X41 = X40 + 1&
        X42 = X40 + 2&
        
        For Y = 0 To pH1

            D = sdgSCENEex(vec2(X * 1, Y * 1))
            If D.X > 0# Then                     ' outside
                If D.X <= Border2 Then
                    '------------------------------------------
                    D.X = Sqr(D.X)
                    P = D.X * InvBorder
                    '------------------------------------------
                    '                    P = D * InvBorder2
                    '------------------------------------------
                    Q = 1# - P
                    srfBYTES(X40, Y) = 255 * Q * (0.5 + 0.5 * D.Y) + P * srfBYTES(X40, Y)    '255 * (0.5 + 0.5 * Cos(D * 0.5))
                    srfBYTES(X41, Y) = 255 * Q * (0.5 + 0.5 * D.Z) + P * srfBYTES(X41, Y)
                    srfBYTES(X42, Y) = 200 * Q + P * srfBYTES(X42, Y)
                End If
            Else                                 'inside
            
                srfBYTES(X40, Y) = 255 * (0.5 + 0.5 * D.Y)
                srfBYTES(X41, Y) = 255 * (0.5 + 0.5 * D.Z)
                srfBYTES(X42, Y) = 200
            End If

        Next
    Next

    SRF.ReleaseArray srfBYTES
    '---------------------------------
    SRF.DrawToDC PIChDC
    '---------------------------------
    'fMain.PIC = SRF.Picture

End Sub

