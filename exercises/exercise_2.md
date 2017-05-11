# Ray casting
## Background
### Path of light
This is the necessary theory section which allows a transition from 2d to 3d.

Ray casting and related approaches involve considering the path of light within a scene, and at what point it intersects with objects. For example, consider the following scene and the (approximate) path of light from a light source to the eye.

![path of light](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/2/1.png)

The direct light is emitted by the light source, bounces off the sphere, and hits the eye observing. In reality, light from such a light source is emitted in every direction, and may have bounced off multiple surfaces by the time it reaches the eye. By simulating all of these rays, we could find out which ones reach the eye and accumulate them to generate an image. This, however, has infinite computational complexity, so what we really want is to approximate the result.

An alternative is to work in reverse. By firing a ray from the eye at the object, and then calculating how much light is reaching the point on the surface we hit, we can come up with a finite approximation for the amount of light reaching the eye from the light source.

### Rays

One way to implement this, is to fire a ray through each pixel on the screen. The plane we're rendering to is called the screen plane and is made up of pixels. The origin of our rays is some point in front of the screen plane, from the point of reference of our viewer. If we then fire rays from that point, through each pixel, and see what they hit behind the screen plane, we can build up a view of the 3d scene.

![rays through screen](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/2/3.png)

We define these rays using an origin point, and a direction. For example, with the origin at (0, 0, 0), and the screen plane's coordinates (x, y) from (-1, -1) to (1, 1) and at z=1 (1 unit in front of the origin): (try and visualise this but if you're having trouble I can make an image)

origin = (0, 0, 0)
direction = normalize (x, y, 1)

It's that simple. The field of view of the image will depend on the choice of z-value for the image plane. In this example, it is 90 degrees (this can be worked out with some trigonometry - if you can't visualise this ask me and I'll make an image).

This ray, defined for the current pixel, can then then be intersection tested with an object to produce an extremely simple 3d render of it. For example, for a sphere at (0, 0, 10) (directly in front of the image plane, at 10 units into the screen) and with a radius of 1:

```
o = (0, 0, 0)
d = normalize (x, y, 1)
sphere = (0, 0, 10, 1)
hit = intersectSphereRay(o, d, sphere)
fragColor = iif(hit, white, black)
```

## Exercise
### 2.1 - Draw the sillouette of a sphere
![2.1 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/2/2.1.PNG)

This is the example from the previous paragraph. To test the intersection of a sphere with a ray can be defined in terms of the line segment/circle intersection from the previous section.

Start from exercise 1.5, and modify your distToLine and lineIntersectCircle functions to work with rays and spheres. To simplify things, you can consider your rays (o, d) to be line segments (o, o + d * 1000). Mathematically speaking, rays should go to infinity, but in practice all this means is that you won't be able to see objects more than 1000 units away.

Then, compute a ray for each pixel and use your new rayIntersectsSphere function to see if the current pixel can see the sphere. If it can, output white. Otherwise, output black.

The result is not much different than a circle as we are not currently considering lighting, but you should be able to change the origin to get closer to or further away from the sphere, and move left or right. You should also be able to change the sphere's position and radius and see it change.

For fun try using an animated value for the position, or radius, such as sin(iGlobalTime).

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/2/2.1.glsl)

### 2.2 - Normals
![2.2 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/2/2.2.PNG)

The normal is the vector pointing straight up out of a surface. The normal of a point on a sphere's surface is normalize(point - sphere centre). Implement the ray sphere intersection formula [found here](http://www.ccs.neu.edu/home/fell/CSU540/programs/RayTracingFormulas.htm) and use it to find the distance down the ray at which the ray intersects the sphere (if it does). If it does, use that distance to calculate the point of intersection, and use the point of intersection to calculate the normal. Output the normal as the colour of the sphere, or black if it misses.

You can use out parameters to return an extra value from a function. For example: bool test(out float x) { x = 5.0; return true; }

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/2/2.2.glsl)

### 2.3 - Diffuse reflection
![2.3 expected output](https://raw.githubusercontent.com/Catchouli/Volumetrics/master/exercises/2/2.3.PNG)

Diffuse reflection is the light that's reflected in every direction from a surface, and results in an even scattering of coloured light depending on the colour and orientation of the surface. Our initial lighting model will only consider diffuse reflection, and will only properly represent completely diffuse materials, but will allow us to see the shape of an object and the effect of the lighting parameters on it.

Diffuse reflection can be approximated by lambert's cosine law. The radiant intensity, or the light coming from a surface, is directly proportional to the cosine of the angle between the light direction, and the normal of the surface. This effect is independent of view direction, meaning that an illuminated point's diffuse reflection will always stay the same no matter what angle or position you look at it from.

At this point the following equation for dot product should be remembered:

dot a b = |a| |b| cos(theta)

Where a and b are vectors, |a| and |b| are their magnitudes, and theta is the angle between them. If we normalise the vectors a and be we get 'dot a b = cos(theta)', which eliminates the need to calculate the angle.

In other words, for a diffuse surface:
```
light direction = point being illuminated - light position (for a point light)
reflected light = surface colour * dot(light direction, surface normal)
```

Choose a light position (somewhere between you and the object so that it lights the correct side), and apply the above formula to your surface normal, and output the reflected light. You should be able to see a 3d object.

For my reference image above, the sphere is at (0, 0, 10) with radius 4, and the light is at (10, 10, 0).

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/2/2.3.glsl)
