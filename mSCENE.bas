Attribute VB_Name = "mSCENE"
Option Explicit
Public Type tSegment
    A             As tVec2
    B             As tVec2
    BA            As tVec2
    R             As Double
    thickness As Double
    R2            As Double
    InvABlen2     As Double
    Etype         As Long
End Type

Public E()        As tSegment
Public NE         As Long

Public Sub SceneAddSegment(A As tVec2, B As tVec2, R As Double)
    NE = NE + 1
    ReDim Preserve E(NE)
    With E(NE)
        .Etype = 1
        .A = A
        .B = B
        .BA.x = B.x - A.x
        .BA.y = B.y - A.y
        .R = R
        .R2 = R * R
        .InvABlen2 = 1# / Length2(vec2(B.x - A.x, B.y - A.y))    '/ DOT(BA, BA))
    End With
End Sub

Public Sub SceneAddCircle(A As tVec2, R As Double)
    NE = NE + 1
    ReDim Preserve E(NE)
    With E(NE)
        .Etype = 0
        .A = A
        .R = R
        .R2 = R * R
    End With
End Sub
Public Sub SceneAddRing(A As tVec2, R As Double, Thick As Double)
    NE = NE + 1
    ReDim Preserve E(NE)
    With E(NE)
        .Etype = 2
        .A = A
        .R = R
        .thickness = Thick
        .R2 = R * R
    End With
End Sub

Public Sub UpdateSegPos(wE As Long, A As tVec2, B As tVec2)
    With E(wE)
        .A = A
        .B = B
        .BA.x = B.x - A.x
        .BA.y = B.y - A.y
        '.InvLen2 = 1# / Length2(vec2(B.x - A.x, B.y - A.y))
        .InvABlen2 = 1# / Length2(vec2(.BA.x, .BA.y))
    End With
End Sub
Public Sub UpdateCirclePos(wE As Long, A As tVec2)
    With E(wE)
        .A = A
    End With
End Sub
Public Sub UpdateRingPos(wE As Long, A As tVec2)
    With E(wE)
        .A = A
    End With
End Sub

Public Function sdSCENEex(P As tVec2) As Double
    Dim D#, I&

    sdSCENEex = 1E+32
    For I = 1 To NE
        With E(I)
            'D = min(D, sdSegmentEx(P, .A, .B, .R2, .BA, .InvABlen2))
            Select Case .Etype
            Case 0                               'CIRCLE
                D = Length(vec2(.A.x - P.x, .A.y - P.y)) - .R
            Case 1                               'SEGMENT
                D = sdSegmentEx(P, .A, .B, .R, .BA, .InvABlen2)
            Case 2                               ' RING
                D = Abs(Length(vec2(.A.x - P.x, .A.y - P.y)) - .R) - .thickness

            End Select
            'If D > 0 Then D = Sqr(D)
        End With
        If D < sdSCENEex Then sdSCENEex = D
    Next

End Function
