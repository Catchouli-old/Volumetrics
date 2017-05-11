float distToRay(vec3 o, vec3 dir, vec3 p)
{
  vec3 a = o;
  vec3 b = o + dir * 1000.0;
    
  vec3 dist = p - a;
  vec3 diff = b - a;
  float d = dot(dist, diff);
  float lengthSquared = dot(diff, diff);
  // distance from a to b of nearest point on segment to point p
  float t = d / lengthSquared;
    
  vec3 nearestPoint;
    
  if (t < 0.0) {
	nearestPoint = a;
  }
  else if (t > 1.0) {
	nearestPoint = b;
  }
  else {
    nearestPoint = a + t * diff;  
  }
  
  return length(nearestPoint - p);
}

bool rayIntersectsSphere(vec3 o, vec3 d, vec4 sphere)
{
    // get circle's centre's distance from line seg
    float dist = distToRay(o, d, sphere.xyz);
    
    // if it's less than the radius, they intersect
    return dist < sphere.w;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // calculate aspect ratio
    float aspect = iResolution.x / iResolution.y;
    
    // convert coords to (-1, 1) space, this makes it easier to correct for aspect ratio
    // without offsetting the image, and will result in a coordinate space for the image
    // which goes from -1 to 1 in the x axis, and slightly less in the y axis to correct
    // the units so they're equally sized in each axis
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 coord = 2.0 * uv - 1.0;
    coord.y /= aspect;
    
    // compute ray, with screen plane at z=1
    vec3 origin = vec3(0.0, 0.0, -10.0);
    vec3 direction = normalize(vec3(coord.x, coord.y, 1));
    
    // our scene, a single sphere at (0, 0, 10) with radius 1
    vec4 sphere = vec4(0, 0, 10, 1);
    
    if (rayIntersectsSphere(origin, direction, sphere))
        fragColor = vec4(1.0);
    else
        fragColor = vec4(0.0);
}