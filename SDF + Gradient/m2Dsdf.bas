Attribute VB_Name = "m2Dsdf"
Option Explicit
'https://iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm

Public Type tVec2
    X             As Double
    Y             As Double
End Type

Public Type tVec3
    X             As Double
    Y             As Double
    Z             As Double
End Type

Public Function max(a As Double, b As Double) As Double
    If a > b Then max = a Else: max = b
End Function
Public Function min(a As Double, b As Double) As Double
    If a < b Then min = a Else: min = b
End Function
Public Function mix(a As Double, b As Double, v#) As Double
    mix = a * (1# - v#) + b * v
End Function
Public Function vec2(X As Double, Y As Double) As tVec2
    vec2.X = X: vec2.Y = Y
End Function
Public Function vec3(X As Double, Y As Double, Z As Double) As tVec3
    With vec3
        .X = X: .Y = Y: .Z = Z
    End With

End Function
Public Function DOT(v1 As tVec2, v2 As tVec2) As Double
    DOT = v1.X * v2.X + v1.Y * v2.Y
End Function
Public Function DOT3(v1 As tVec3, v2 As tVec3) As Double
    DOT3 = v1.X * v2.X + v1.Y * v2.Y + v1.Z * v2.Z
End Function

Public Function Clamp01(a As Double) As Double
    Clamp01 = a
    If Clamp01 < 0# Then
        Clamp01 = 0#
    ElseIf Clamp01 > 1# Then
        Clamp01 = 1#
    End If
End Function

Public Function V2Length(v As tVec2) As Double
    With v
        V2Length = Sqr(.X * .X + .Y * .Y)
    End With
End Function
Public Function V2Length2(v As tVec2) As Double
    With v
        V2Length2 = .X * .X + .Y * .Y
    End With
End Function

Public Function V3Length(v As tVec3) As Double
    With v
        V3Length = Sqr(.X * .X + .Y * .Y + .Z * .Z)
    End With
End Function

Public Function sdCircle(P As tVec2, R As Double) As Double
    sdCircle = V2Length(P) - R
End Function
Public Function sdgCircle(P As tVec2, R As Double) As tVec3
    Dim D#, iD#
    D = V2Length(P): If D Then iD = 1# / D
    sdgCircle = vec3(D - R, -P.X * iD, -P.Y * iD)
End Function


''float sdSegment( in vec2 p, in vec2 a, in vec2 b )
''{ vec2 pa = p-a, ba = b-a;
''float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
''return V2Length( pa - ba*h );
''}
Public Function sdSegment(P As tVec2, a As tVec2, b As tVec2, R As Double) As Double
    Dim PA        As tVec2
    Dim BA        As tVec2
    Dim h#
    With a
        PA.X = P.X - .X
        PA.Y = P.Y - .Y
        BA.X = b.X - .X
        BA.Y = b.Y - .Y
    End With
    h = Clamp01(DOT(PA, BA) / DOT(BA, BA))

    sdSegment = V2Length(vec2(PA.X - BA.X * h, _
                              PA.Y - BA.Y * h)) - R
End Function

Public Function sdSegmentEx(P As tVec2, a As tVec2, b As tVec2, R As Double, BA As tVec2, InvABlen2 As Double) As Double
' Faster. Avoid Division: / DOT(BA, BA)
    Dim PA        As tVec2
    '    Dim BA        As tVec2
    Dim h#
    With a
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
    '    sdSegmentEx = V2Length2(vec2(PA.x - BA.x * h, PA.y - BA.y * h)) - R*R
    sdSegmentEx = V2Length(vec2(PA.X - BA.X * h, PA.Y - BA.Y * h)) - R

End Function
Public Function sdgSegmentEx(P As tVec2, a As tVec2, b As tVec2, R As Double, BA As tVec2, InvABlen2 As Double) As tVec3
' Faster. Avoid Division: / DOT(BA, BA)
    Dim PA        As tVec2
    '    Dim BA        As tVec2
    Dim h#
    Dim Q         As tVec2
    Dim D#, iD#

    With a
        PA.X = P.X - .X
        PA.Y = P.Y - .Y
    End With
    h = (PA.X * BA.X + PA.Y * BA.Y) * InvABlen2
    If h > 1# Then
        h = 1#
    ElseIf h < 0# Then
        h = 0#
    End If

    Q.X = PA.X - h * BA.X
    Q.Y = PA.Y - h * BA.Y
    D = V2Length(Q): If D Then iD = 1# / D
    sdgSegmentEx = vec3(D - R, Q.X * iD, Q.Y * iD)
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
''        sdSegmentEx2 = V2Length2(vec2(PA.x - .BA.x * h, PA.y - .BA.y * h)) - .R2
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
Public Function sdUnevenCapsuleEx(P As tVec2, a As tVec2, b As tVec2, Ra As Double, BA As tVec2, InvABlen2 As Double, Rb#) As Double
    Dim h#, DeltaR#, ih#
    Dim PA        As tVec2

    Dim Q         As tVec2
    Dim K#, m#, n#
    Dim c         As tVec2

    With a
        PA.X = P.X - .X
        PA.Y = P.Y - .Y
    End With

    h = BA.X * BA.X + BA.Y * BA.Y: ih = 1# / h
    Q = vec2(DOT(PA, vec2(BA.Y, -BA.X)), DOT(PA, BA))
    Q.X = Abs(Q.X * ih)
    Q.Y = Q.Y * ih

    DeltaR = Ra - Rb
    If h - DeltaR * DeltaR > 0# Then
        c = vec2(Sqr(h - DeltaR * DeltaR), DeltaR)
    Else
        c.Y = DeltaR
    End If

    K = c.X * Q.Y - c.Y * Q.X                    'cro(c, q)   '2D cross
    m = DOT(c, Q)
    n = DOT(Q, Q)

    If (K < 0#) Then
        sdUnevenCapsuleEx = Sqr(h * (n)) - Ra
    ElseIf (K > c.X) Then
        sdUnevenCapsuleEx = Sqr(h * (n + 1# - 2# * Q.Y)) - Rb
    Else
        sdUnevenCapsuleEx = m - Ra
    End If

End Function



'vec3 sdgSmoothMin( in vec3 a, in vec3 b, in float k )
'{
'    float h = max(k-abs(a.x-b.x),0.0);
'    float m = 0.25*h*h/k;
'    float n = 0.50*  h/k;
'    return vec3( min(a.x,  b.x) - m,
'                 mix(a.yz, b.yz, (a.x<b.x)?n:1.0-n) );
'}
Public Function sdgSmoothMin(a As tVec3, b As tVec3, K#, iK#) As tVec3
    Dim h#, m#, n#
    h = K - Abs(a.X - b.X): If h < 0# Then h = 0#
    m = 0.25 * h * h * iK
    n = 0.5 * h * iK
    If a.X < b.X Then
        sdgSmoothMin = vec3(min(a.X, b.X) - m, _
                            mix(a.Y, b.Y, n), _
                            mix(a.Z, b.Z, n))
    Else
        sdgSmoothMin = vec3(min(a.X, b.X) - m, _
                            mix(b.Y, a.Y, n), _
                            mix(b.Z, a.Z, n))
    End If
End Function
