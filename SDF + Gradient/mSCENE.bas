Attribute VB_Name = "mSCENE"
Option Explicit
Public Type tSegment
    a             As tVec2
    b             As tVec2
    BA            As tVec2
    R             As Double
    thickness     As Double
    R2            As Double
    InvABlen2     As Double
    Etype         As Long
End Type

Public E()        As tSegment
Public NE         As Long

Public DoRC6      As Long

Private Const SmoothMin As Single = 5
Private Const iSmoothMin As Single = 1 / 5

Public Sub SceneAddCircle(a As tVec2, R As Double)
    NE = NE + 1
    ReDim Preserve E(NE)
    With E(NE)
        .Etype = 0
        .a = a
        .R = R
        .R2 = R * R
    End With
End Sub
Public Sub SceneAddSegment(a As tVec2, b As tVec2, R As Double)
    NE = NE + 1
    ReDim Preserve E(NE)
    With E(NE)
        .Etype = 1
        .a = a
        .b = b
        .BA.X = b.X - a.X
        .BA.Y = b.Y - a.Y
        .R = R
        .R2 = R * R
        .InvABlen2 = 1# / V2Length2(vec2(b.X - a.X, b.Y - a.Y))    '/ DOT(BA, BA))
    End With
End Sub
Public Sub SceneAddRing(a As tVec2, R As Double, Thick As Double)
    NE = NE + 1
    ReDim Preserve E(NE)
    With E(NE)
        .Etype = 2
        .a = a
        .R = R
        .thickness = Thick
        .R2 = R * R
    End With
End Sub
Public Sub SceneAddUnevenCapsule(a As tVec2, b As tVec2, Ra As Double, Rb As Double)
    NE = NE + 1
    ReDim Preserve E(NE)
    With E(NE)
        .Etype = 3
        .a = a
        .b = b
        .BA.X = b.X - a.X
        .BA.Y = b.Y - a.Y
        .R = Ra
        .R2 = Rb
        .InvABlen2 = 1# / V2Length2(vec2(b.X - a.X, b.Y - a.Y))    '/ DOT(BA, BA))
    End With
End Sub
Public Sub UpdateSegPos(wE As Long, a As tVec2, b As tVec2)
    With E(wE)
        .a = a
        .b = b
        .BA.X = b.X - a.X
        .BA.Y = b.Y - a.Y
        '.InvLen2 = 1# / V2Length2(vec2(B.x - A.x, B.y - A.y))
        .InvABlen2 = 1# / V2Length2(vec2(.BA.X, .BA.Y))
    End With
End Sub
Public Sub UpdateCirclePos(wE As Long, a As tVec2)
    With E(wE)
        .a = a
    End With
End Sub
Public Sub UpdateRingPos(wE As Long, a As tVec2)
    With E(wE)
        .a = a
    End With
End Sub

Public Function sdgSCENEex(P As tVec2) As tVec3
    Dim D         As tVec3, I&


    D.X = 1E+32

    For I = 1 To NE
        With E(I)
            Select Case .Etype
            Case 0&                              'CIRCLE

                'D = V2Length(vec2(.a.X - P.X, .a.Y - P.Y)) - .R
                D = sdgSmoothMin(sdgCircle(vec2(.a.X - P.X, .a.Y - P.Y), .R), D, SmoothMin, iSmoothMin)

                            Case 1&                              'SEGMENT / capsule
                                D = sdgSmoothMin(sdgSegmentEx(P, .a, .b, .R, .BA, .InvABlen2), D, SmoothMin, iSmoothMin)
                '            Case 2&                              ' RING
                '                D = Abs(V2Length(vec2(.a.X - P.X, .a.Y - P.Y)) - .R) - .thickness
                '            Case 3&                              'Uneven capsule
                '                D = sdUnevenCapsuleEx(P, .a, .b, .R, .BA, .InvABlen2, .R2)
            End Select
        End With
    Next
    sdgSCENEex = D
End Function
