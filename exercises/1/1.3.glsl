bool pointInCircle(vec2 point, vec2 circlePos, float radius)
{
    vec2 dist = point - circlePos;
    return dist.x * dist.x + dist.y * dist.y < radius * radius;
}

float distToLine(vec2 a, vec2 b, vec2 p)
{
  vec2 dist = p - a;
  vec2 diff = b - a;
  float d = dot(dist, diff);
  float lengthSquared = dot(diff, diff);
  // distance from a to b of nearest point on segment to point p
  float t = d / lengthSquared;
    
  vec2 nearestPoint;
    
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
    
    // Line width
    const float lineWidth = 0.00125;
    
    if (pointInCircle(coord, vec2(0, 0), 0.25)
     || distToLine(vec2(-0.5, -0.5), vec2(0.5, 0.5), coord) < lineWidth)
        fragColor = vec4(1.0, 1.0, 1.0, 1.0);
    else
        fragColor = vec4(0.0);
}