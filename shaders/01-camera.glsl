precision mediump float;

uniform float time; // seconds
varying vec2 uv;

void main()
{
    vec3 pos = vec3(0.0, 10.0, 0.0);
    vec3 dir = normalize(vec3(uv, 1.0));
    
	gl_FragColor = vec4(dir, 1.0);
}
