precision mediump float;

uniform float time; // seconds
varying vec2 uv;

float intersectPlane(vec3 pos, vec3 dir)
{
    return -pos.y / dir.y;
}

float intersectSphere(vec3 pos, vec3 dir)
{
	// solve pos + k*dir = unit sphere surface
	// dot(pos + k*dir, pos + k*dir) = 1
	
	// quadratic coefficients
	float a = dot(dir, dir);
	float b = 2.0 * dot(pos, dir);
	float c = dot(pos, pos) - 1.0;
	float discriminant = b * b - 4.0 * a * c;
	
	// only the positive root is useful
	return (-b - sqrt(discriminant)) / (2.0 * a);
}

void main()
{
    vec3 pos = vec3(sin(time), 2.2, -3.0);
    vec3 dir = normalize(vec3(uv, 1.0));
    
    float d = min(intersectPlane(pos, dir), intersectSphere(pos, dir));
    pos += d * dir;
    
    vec3 color = fract(pos.xxz * 0.5);

	gl_FragColor = vec4(color, 1.0);
}
