bool pointInCircle(vec2 point, vec2 circlePos, float radius)
{
    vec2 dist = point - circlePos;
    return dist.x * dist.x + dist.y * dist.y < radius * radius;
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
    
    if (pointInCircle(coord, vec2(0, 0), 0.25))
        fragColor = vec4(1.0, 1.0, 1.0, 1.0);
    else
        fragColor = vec4(0.0);
}
