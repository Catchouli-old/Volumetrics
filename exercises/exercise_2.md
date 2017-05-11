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

You should be able to change the origin to get closer to or further away from the sphere, and move left or right. You should also be able to change the sphere's position and radius and see it change.

[Solution](https://github.com/Catchouli/Volumetrics/blob/master/exercises/1/2.1.glsl)
