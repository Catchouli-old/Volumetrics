bool rayIntersectSphere(vec3 origin, vec3 direction, vec4 sphere, out vec2 hit)
{
    vec3 a = origin;
    vec3 b = origin + direction * 1000.0;
    vec3 p = sphere.xyz;
    
    vec3 dist = p - a;
    vec3 diff = b - a;
    float dotProduct = dot(dist, diff);
    float lengthSquared = dot(diff, diff);
    float t = dotProduct / lengthSquared;
    
    vec3 nearestPoint;
    
    if (t < 0.0)
        nearestPoint = a;
    else if (t > 1.0)
        nearestPoint = b;
    else
        nearestPoint = a + t * diff;
        
    float distToCentre = length(nearestPoint - sphere.xyz);
    
    if (distToCentre < sphere.w) {
        float c = sqrt(distToCentre * distToCentre + sphere.w * sphere.w);
    	float distToNearestPoint = length(nearestPoint - origin);
        
        float t0 = distToNearestPoint - c;
        float t1 = distToNearestPoint + c;
        
        hit = vec2(t0, t1);
        
        return true;
    }
    else {
        return false;
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
    vec4 sphere = vec4(0.0, 0, 10, 3);
    
    vec2 hit;
    if (rayIntersectSphere(origin, direction, sphere, hit)) {
        vec3 hitPoint = origin + hit.x * direction;
        vec3 normal = normalize(hitPoint - sphere.xyz);
        fragColor = vec4(normal, 1.0);
    }
    else
        fragColor = vec4(0.0);
}