bool rayIntersectSphere(vec3 origin, vec3 direction, vec4 sphere, out vec2 intersectionPoints) {
  float c = length(origin - sphere.xyz) - sphere.w*sphere.w ;
  float dotVal = dot(direction, (origin - sphere.xyz));
  float sqrtVal = dotVal*dotVal - dot(origin - sphere.xyz, origin - sphere.xyz) + sphere.w*sphere.w ;
  if (sqrtVal <= 0.0) {
    return false ;
  }
  if (sqrtVal == 0.0) {
    intersectionPoints.x = -dotVal ;
    intersectionPoints.y = -dotVal ;
    return true ;
  }
  else {
    float d1 = -(dotVal) + sqrt(sqrtVal) ;
    float d2 = -(dotVal) - sqrt(sqrtVal) ;
    if (d1 < 0.0 && d2 < 0.0) {
      return false ;
    } else if (d1 < 0.0 || d2 < 0.0) {
      intersectionPoints.x = min(d1,d2) ;
      intersectionPoints.y = max(d1,d2) ;
      return true ;
    } else {
      intersectionPoints.x = min(d1,d2) ;
      intersectionPoints.y = max(d1,d2) ;
      return true ;
    }
  }
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
    vec3 origin = vec3(0.0, 0.0, 0.0);
    vec3 direction = normalize(vec3(coord.x, coord.y, 1));
    
    // our scene, a single sphere at (0, 0, 10) with radius 1
    vec4 sphere = vec4(0.0, 0.0, 10, 4);
    
    vec2 hit;
    if (rayIntersectSphere(origin, direction, sphere, hit)) {
        vec3 hitPoint = origin + hit.y * direction;
        vec3 normal = normalize(hitPoint - sphere.xyz);
        vec3 lightPoint = vec3(0.0, 5.0, 10.0);
        vec3 lightDir = lightPoint - hitPoint;
        float diffuseIntensity = dot(lightDir, normal);
        fragColor = vec4(normal * vec3(1.0), 1.0);
    }
    else
        fragColor = vec4(0.0);
}