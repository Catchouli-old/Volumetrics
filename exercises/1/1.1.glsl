void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    if (uv.x < 0.33)
        fragColor = vec4(0.0, 0.0, 1.0, 0.0);
    else if (uv.x > 0.66)
        fragColor = vec4(1.0, 0.0, 0.0, 0.0);
    else
        fragColor = vec4(1.0, 1.0, 1.0, 0.0);
}