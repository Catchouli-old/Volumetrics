## Exercise 1
## Fragment shaders and vector geometry

The purpose of this exercise is to familiarise you with fragment shaders. At the end of it, you will have drawn your first 2D shape using a fragment shader, and should understand how to create an image using a fragment shader by specifying the value of each pixel.

https://www.shadertoy.com/new

A fragment shader is a program that decides the colour for a pixel on the screen. It has inputs, such as the pixel's position on the screen, the current time, texture coordinates, or anything that can be passed in from the cpu or inferred from the attributes of a 3d model. For shadertoy, a single fullscreen rectangle is drawn, with the fragment shader being invoked for every pixel in the image.

The form of a fragment shader is the following:

```
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	fragColor = vec4(uv,0.5+0.5*sin(iGlobalTime),1.0);
}
```
(the default new shader on shadertoy)

The output is the following:
![shader output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/1/0.PNG)

The input fragCoord is the position of the current fragment in pixels. The output fragColor is the resulting colour in the pixel. iResolution and iGlobalTime are built in 'uniform' inputs, which means that the values are the same across the whole shader invocation (for all pixels). A full list of available inputs can be seen on the shadertoy editor by clicking 'Shader Inputs' above the code panel.

The program above gets the position of the current pixel, divides it by the resolution to get a normalised value 0 to 1, and then outputs it as a colour. 

## 1.1 - Draw the flag of France

Modify the default shader to output the flag of France. By outputting a different colour depending on the value of uv, you should be able to produce a different output on different parts of the screen. 

![1.1 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/1/1.1.PNG)

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/1/1.1.glsl)

## 1.2 - Draw a circle

Modify your shader to draw a circle. By checking if the position of the current pixel is within the bounds of a shape, it should be possible to draw any shape.

![1.2 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/1/1.2.PNG)

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/1/1.2.glsl)
