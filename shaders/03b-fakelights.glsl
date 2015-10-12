precision mediump float;

uniform float time; // seconds
varying vec2 uv;

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

float map(vec3 pos)
{
    return min(plane(pos), sphere(pos, 2.0));
}

vec3 material(vec3 pos)
{
    float l = box(pos, vec3(2.0));
    return 1.0 / l / l * vec3(1.0, 0.0, 0.0) * vec3(smoothstep(0.4, 0.41, fract(pos.x + sin(pos.z * 0.4 + time))));
}

void main()
{
    vec3 pos = vec3(sin(time), 4.0, -8.0);
    vec3 dir = normalize(vec3(uv, 1.0));
    
    vec3 color = mix(vec3(0.4, 0.5, 0.6), vec3(0.7, 0.8, 0.9), -uv.y);
    for (int i = 0; i < 64; i++)
    {
        float d = map(pos);
        if (d < 0.01)
        {
            color = material(pos);
            break;
        }
        
        pos += d * dir;
    }
    
	gl_FragColor = vec4(color, 1.0);
}
