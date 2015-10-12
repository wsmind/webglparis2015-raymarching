precision mediump float;

uniform float time; // seconds
varying vec2 uv;

vec2 rotate(vec2 v, float angle)
{
    float c = cos(angle);
    float s = sin(angle);
    return mat2(c, s, -s, c) * v;
}

float plane(vec3 pos)
{
    return pos.y;
}

float sphere(vec3 pos, float radius)
{
    return length(pos) - radius;
}

float box(vec3 pos, vec3 size)
{
    return length(max(abs(pos) - size, 0.0));
}

float roundedBox(vec3 pos, vec3 size, float radius)
{
    return length(max(abs(pos) - size, 0.0)) - radius;
}

vec2 repeat(inout vec2 pos, vec2 period)
{
    vec2 off = pos + period * 0.5;
    vec2 idx = floor(off / period);
    pos = mod(off, period) - period * 0.5;
    
    return idx;
}

float map(vec3 pos)
{
    float p = plane(pos);
    vec2 idx = repeat(pos.xz, vec2(8.0));
    float i = (idx.x + idx.y * 7.0) * 15.0;
    //pos.xy = rotate(pos.xy, sin(time) * pos.y * 0.2);
    pos.xz = rotate(pos.xz, pos.y * sin(time + i) * 0.4);
    //pos.yz = rotate(pos.yz, time * 0.7);
    return min(p, roundedBox(pos, vec3(1.0, 10.0 + sin(i) * 2.0, 1.0), 0.4));
}

vec3 computeNormal(vec3 pos)
{
    vec2 eps = vec2(0.01, 0.0);
    return normalize(vec3(
        map(pos + eps.xyy) - map(pos - eps.xyy),
        map(pos + eps.yxy) - map(pos - eps.yxy),
        map(pos + eps.yyx) - map(pos - eps.yyx)
    ));
}

vec3 material(vec3 pos)
{
    return vec3(smoothstep(0.4, 0.41, fract(pos.x + sin(pos.z * 0.4 + time))));
}

void main()
{
    vec3 pos = vec3(sin(time * 0.1) * 20.0, 7.0 + sin(time * 0.4) * 4.0, -3.0);
    vec3 dir = normalize(vec3(uv, 1.0 - length(uv) * 0.4));
    
    vec3 color = mix(vec3(0.4, 0.5, 0.6), vec3(0.7, 0.8, 0.9), -uv.y);
    for (int i = 0; i < 128; i++)
    {
        float d = map(pos);
        if (d < 0.001)
        {
            color = computeNormal(pos);
            break;
        }
        
        pos += d * dir;
    }
    
	gl_FragColor = vec4(color, 1.0);
}
