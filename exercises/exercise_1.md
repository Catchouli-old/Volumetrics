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

The following exercises will direct you through the fundamental glsl, vector maths, and geometry knowledge needed for eventually implementing a volume ray tracer. Part 2 will then extend these techniques to 3d, introducing ray casting.

To follow along, attempt the exercise and then compare to my solution. If your solution is different, analyse why, as it might be important in the following exercises. Each step should leave you with a functioning shader, producing something similar to the image provided.

## 1.1 - Draw the flag of France

Modify the default shader to output the flag of France. By outputting a different colour depending on the value of uv, you should be able to produce a different output on different parts of the screen. 

![1.1 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/1/1.1.PNG)

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/1/1.1.glsl)

## 1.2 - Draw a circle

Modify your shader to draw a circle. By checking if the position of the current pixel is within the bounds of a shape, it should be possible to draw any shape. I recommend remapping your UV coordinates to the range [-1, 1] instead of [0, 1] as it will be more useful to you. Pay careful attention to the aspect ratio of the image, noting that because it is not square and that the coordinates are normalised, some correction will need to be applied in order to produce a circle instead of an ellipse.

![1.2 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/1/1.2.PNG)

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/1/1.2.glsl)

## 1.3 - Draw a line segment

![1.3 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/1/1.3.PNG)

The following function tells you the distance of a point from a line segment a b:

```
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
```

Extend your solution to 1.2 so that you can also draw a line segment. The line segment should be defined by two vectors a and b, in two dimensions.

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/1/1.3.glsl)

## 1.4 - Draw multiple circles and a line segment

![1.4 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/1/1.4.PNG)

Extend your solution to 1.3 to draw the following circles and line segment:

```
vec4 segment = vec4(-0.9, -0.5, 0.7, 0.1);
const int circleCount = 7;
vec3 circles[circleCount];
circles[0] = vec3(-0.7, 0.4, 0.1);
circles[1] = vec3(-0.5, 0.1, 0.1);
circles[2] = vec3(0.0, 0.4, 0.1);
circles[3] = vec3(0.2, -0.4, 0.1);
circles[4] = vec3(0.5, 0.0, 0.1);
circles[5] = vec3(-0.8, -0.4, 0.1);
circles[6] = vec3(0.0, 0.0, 0.1);
```

Circles are in the form vec3(x, y, radius).

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/1/1.4.glsl)

## 1.5 - Colour intersecting circles

![1.5 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/1/1.5.PNG)

Use the function distToLine given in 1.3 to write a function that checks if a line segment intersects a circle. Use this function to colour intersecting circles red.

Once you're at this point, you're basically ray casting in 2D. Ray casting involves intersecting a ray from the origin (the eye position, for example) with objects in the scene to create a 3D image. In the next section we will discuss ray casting, what it approximates, and what it represents, and then we will extend this concept to 3D to produce an image of a 3D scene.

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/1/1.5.glsl)
