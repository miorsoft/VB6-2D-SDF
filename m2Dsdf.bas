Attribute VB_Name = "m2Dsdf"
Option Explicit
'https://iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm

Public Type tVec2
    x             As Double
    y             As Double
End Type

Public Function max(A As Double, B As Double) As Double
    If A > B Then max = A Else: max = B
End Function
Public Function min(A As Double, B As Double) As Double
    If A < B Then min = A Else: min = B
End Function
Public Function vec2(x As Double, y As Double) As tVec2
    vec2.x = x: vec2.y = y
End Function

Public Function DOT(v1 As tVec2, v2 As tVec2) As Double
    DOT = v1.x * v2.x + v1.y * v2.y
End Function
Public Function Clamp01(A As Double) As Double
    Clamp01 = A
    If Clamp01 < 0# Then
        Clamp01 = 0#
    ElseIf Clamp01 > 1# Then
        Clamp01 = 1#
    End If
End Function


Public Function Length(v As tVec2) As Double
    With v
        Length = .x * .x + .y * .y
    End With
    Length = Sqr(Length)
End Function
Public Function Length2(v As tVec2) As Double
    With v
        Length2 = .x * .x + .y * .y
    End With
End Function

''Public Sub srfBIND()
''    SRF.BindToArray srfBYTES()
''End Sub
''Public Sub srfRELEASE()
''    SRF.ReleaseArray srfBYTES
''End Sub

Public Function sdCircle(P As tVec2, R As Double) As Double
    sdCircle = Length(P) - R
End Function
'Public Function sdCircle2(p As tVec2, r2 As Double) As Double
'    sdCircle2 = Length2(p) - r2
'End Function
'float sdUnevenCapsule( vec2 p, float r1, float r2, float h )
'{ p.x = abs(p.x);
'float b = (r1-r2)/h;
'float a = sqrt(1.0-b*b);
'float k = dot(p,vec2(-b,a));
'if( k < 0.0 ) return length(p) - r1;
'if( k > a*h ) return length(p-vec2(0.0,h)) - r2;
'return dot(p, vec2(a,b) ) - r1;
'}
'
'Public Function sdUnevenCapsule(p As tVec2, r1 As Double, r2 As Double) As Double
'
'End Function

''float sdSegment( in vec2 p, in vec2 a, in vec2 b )
''{ vec2 pa = p-a, ba = b-a;
''float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
''return length( pa - ba*h );
''}
Public Function sdSegment(P As tVec2, A As tVec2, B As tVec2, R As Double) As Double
    Dim PA        As tVec2
    Dim BA        As tVec2
    Dim h#
    With A
        PA.x = P.x - .x
        PA.y = P.y - .y
        BA.x = B.x - .x
        BA.y = B.y - .y
    End With
    h = Clamp01(DOT(PA, BA) / DOT(BA, BA))

    sdSegment = Length(vec2(PA.x - BA.x * h, _
                            PA.y - BA.y * h)) - R
End Function

Public Function sdSegmentEx(P As tVec2, A As tVec2, B As tVec2, R As Double, BA As tVec2, InvABlen2 As Double) As Double
    Dim PA        As tVec2
    '    Dim BA        As tVec2
    Dim h#
    With A
        PA.x = P.x - .x
        PA.y = P.y - .y
        '        BA.x = B.x - .x
        '        BA.y = B.y - .y
    End With
    'h = Clamp01(DOT(PA, BA) * InvABlen2)

    h = (PA.x * BA.x + PA.y * BA.y) * InvABlen2
    If h > 1# Then
        h = 1#
    ElseIf h < 0# Then
        h = 0#
    End If
    '    sdSegmentEx = Length2(vec2(PA.x - BA.x * h, PA.y - BA.y * h)) - R*R
    sdSegmentEx = Length(vec2(PA.x - BA.x * h, PA.y - BA.y * h)) - R

End Function


''Public Function sdSegmentEx2(P As tVec2, I As Long) As Double  ' <---SLOWER than sdSegmentEx
''    Dim PA        As tVec2
''    '    Dim BA        As tVec2
''    Dim h#
''    With E(I)
''        PA.x = P.x - .A.x
''        PA.y = P.y - .A.y
''        '        BA.x = B.x - .x
''        '        BA.y = B.y - .y
''
''        'h = Clamp01(DOT(PA, BA) * InvABlen2)
''
''        h = (PA.x * .BA.x + PA.y * .BA.y) * .InvABlen2
''        If h > 1# Then
''            h = 1#
''        ElseIf h < 0# Then
''            h = 0#
''        End If
''
''
''        sdSegmentEx2 = Length2(vec2(PA.x - .BA.x * h, PA.y - .BA.y * h)) - .R2
''    End With
''End Function

''Public Function sdSCENE(P As tVec2, T#) As Double
''    Dim DMIN#
''    Dim D#, D2#, D3#
''
''    '    D = sdCircle(vec2(p.x - 120 - 100 * Cos(t * 0.1), _
 ''         '                      p.y - 70 - 22 * Cos(t * 0.11)), 25)
''
''    D2 = sdSegment(P, _
 ''                   vec2(180 + 100 * Cos(T * 0.13), _
 ''                        120 + 100 * Cos(T * 0.09)), vec2(105, 105), 8)
''    D3 = sdSegment(P, _
 ''                   vec2(pW * 0.5 + pW * 0.4 * Cos(T * 0.075 + 1), _
 ''                        pH * 0.5 + pH * 0.4 * Cos(T * 0.09 + 2)), _
 ''                        vec2(pW * 0.5 + pW * 0.4 * Cos(T * 0.07 + 3), _
 ''                             pH * 0.5 + pH * 0.4 * Cos(T * 0.05 + 4)), 6)
''    '    D = min(D, D2)
''    '    sdSCENE = min(D, D3)
''    sdSCENE = min(D2, D3)
''End Function
