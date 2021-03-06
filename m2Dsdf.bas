Attribute VB_Name = "m2Dsdf"
Option Explicit
'https://iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm

Public Type tVec2
    X             As Double
    Y             As Double
End Type

Public Function max(A As Double, B As Double) As Double
    If A > B Then max = A Else: max = B
End Function
Public Function min(A As Double, B As Double) As Double
    If A < B Then min = A Else: min = B
End Function
Public Function vec2(X As Double, Y As Double) As tVec2
    vec2.X = X: vec2.Y = Y
End Function

Public Function DOT(v1 As tVec2, v2 As tVec2) As Double
    DOT = v1.X * v2.X + v1.Y * v2.Y
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
        Length = Sqr(.X * .X + .Y * .Y)
    End With
End Function
Public Function Length2(v As tVec2) As Double
    With v
        Length2 = .X * .X + .Y * .Y
    End With
End Function

Public Function sdCircle(P As tVec2, R As Double) As Double
    sdCircle = Length(P) - R
End Function
'Public Function sdCircle2(p As tVec2, r2 As Double) As Double
'    sdCircle2 = Length2(p) - r2
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
        PA.X = P.X - .X
        PA.Y = P.Y - .Y
        BA.X = B.X - .X
        BA.Y = B.Y - .Y
    End With
    h = Clamp01(DOT(PA, BA) / DOT(BA, BA))

    sdSegment = Length(vec2(PA.X - BA.X * h, _
                            PA.Y - BA.Y * h)) - R
End Function

Public Function sdSegmentEx(P As tVec2, A As tVec2, B As tVec2, R As Double, BA As tVec2, InvABlen2 As Double) As Double
' Faster. Avoid Division: / DOT(BA, BA)
    Dim PA        As tVec2
    '    Dim BA        As tVec2
    Dim h#
    With A
        PA.X = P.X - .X
        PA.Y = P.Y - .Y
        '        BA.x = B.x - .x
        '        BA.y = B.y - .y
    End With
    'h = Clamp01(DOT(PA, BA) * InvABlen2)

    h = (PA.X * BA.X + PA.Y * BA.Y) * InvABlen2
    If h > 1# Then
        h = 1#
    ElseIf h < 0# Then
        h = 0#
    End If
    '    sdSegmentEx = Length2(vec2(PA.x - BA.x * h, PA.y - BA.y * h)) - R*R
    sdSegmentEx = Length(vec2(PA.X - BA.X * h, PA.Y - BA.Y * h)) - R

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


''https://www.shadertoy.com/view/4lcBWn
''float sdUnevenCapsule( in vec2 p, in vec2 pa, in vec2 pb, in float ra, in float rb )
''{
''p  -= pa;
''pb -= pa;
''float h = dot(pb,pb);
''vec2  q = vec2( dot(p,vec2(pb.y,-pb.x)), dot(p,pb) )/h;
''
''//-----------
''
''q.x = abs(q.x);
''
''float b = ra-rb;
''vec2  c = vec2(sqrt(h-b*b),b);
''
''float k = cro(c,q);
''float m = dot(c,q);
''float n = dot(q,q);
''
''if( k < 0.0 ) return sqrt(h*(n            )) - ra;
''else if( k > c.x ) return sqrt(h*(n+1.0-2.0*q.y)) - rb;
''return m                       - ra;
Public Function sdUnevenCapsuleEx(P As tVec2, A As tVec2, B As tVec2, Ra As Double, BA As tVec2, InvABlen2 As Double, Rb#) As Double
    Dim h#, DeltaR#, ih#
    Dim PA        As tVec2

    Dim q         As tVec2
    Dim k#, m#, n#
    Dim c         As tVec2

    With A
        PA.X = P.X - .X
        PA.Y = P.Y - .Y
    End With

    h = BA.X * BA.X + BA.Y * BA.Y: ih = 1# / h
    q = vec2(DOT(PA, vec2(BA.Y, -BA.X)), DOT(PA, BA))
    q.X = Abs(q.X * ih)
    q.Y = q.Y * ih

    DeltaR = Ra - Rb
    If h - DeltaR * DeltaR > 0# Then
        c = vec2(Sqr(h - DeltaR * DeltaR), DeltaR)
    Else
        c.Y = DeltaR
    End If

    k = c.X * q.Y - c.Y * q.X                    'cro(c, q)   '2D cross
    m = DOT(c, q)
    n = DOT(q, q)

    If (k < 0#) Then
        sdUnevenCapsuleEx = Sqr(h * (n)) - Ra
    ElseIf (k > c.X) Then
        sdUnevenCapsuleEx = Sqr(h * (n + 1# - 2# * q.Y)) - Rb
    Else
        sdUnevenCapsuleEx = m - Ra
    End If

End Function
