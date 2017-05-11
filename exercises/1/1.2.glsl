bool pointInCircle(vec2 point, vec2 circlePos, float radius)
{
    vec2 dist = point - circlePos;
    return dist.x * dist.x + dist.y * dist.y > radius * radius;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float aspect = iResolution.x / iResolution.y;
    vec2 uv = fragCoord.xy / iResolution.xy;
    if (pointInCircle(vec2(uv.x, uv.y / aspect), vec2(0.5, 0.5 / aspect), 0.25))
        fragColor = vec4(1.0, 1.0, 1.0, 1.0);
    else
        fragColor = vec4(0.0);
}