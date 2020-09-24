using UnityEngine;
using System.Collections.Generic;
using System;
using Engine4.Internal;

namespace Engine4
{
    /// <summary>
    /// Mathematical abstraction of a plane that split spaces in 4D
    /// </summary>
    public struct Plane4
    {
        /// <summary>
        /// The distance of the plane
        /// </summary>
        public float distance;

        /// <summary>
        /// The normal of the plane
        /// </summary>
        public Vector4 normal;

        /// <summary>
        /// Create a new plane with given normal at given point
        /// </summary>
        public Plane4(Vector4 norm, Vector4 point)
        {
            normal = Vector4.Normalize(norm);
            distance = Vector4.Dot(normal, point);
        }

        /// <summary>
        /// Create a new plane with given normal and distance
        /// </summary>
        public Plane4(Vector4 norm, float dist)
        {
            normal = Vector4.Normalize(norm);
            distance = dist;
        }

        /// <summary>
        /// Create a new plane from known vertices
        /// </summary>
        public Plane4(Vector4 a, Vector4 b, Vector4 c, Vector4 d)
        {
            normal = Vector4.Normalize(Vector4.Cross(b - a, c - a, d - a));
            distance = Vector4.Dot(normal, a);
        }

        /// <summary>
        /// Get origin of a plane
        /// </summary>
        public Vector4 origin { get { return normal * distance; } set { distance = Vector4.Dot(normal, value); } }

        /// <summary>
        /// Get distance between a point and the nearest point on a plane.
        /// </summary>
        /// <remarks> The method can return a negative value, which mean the point is behind the plae </remarks>
        public float Distance(Vector4 point)
        {
            return Vector4.Dot(normal, point) - distance;
        }

        /// <summary>
        /// Is the point is above or behind the plane?
        /// </summary>
        public bool GetSide(Vector4 point)
        {
            return Vector4.Dot(this.normal, point) - this.distance > -1e-4;
        }

        /// <summary>
        /// Given an edge represented as two points, return an interpolation where the point intersects
        /// </summary>
        /// <remarks> The resulting interpolation is unclamped, can go beyond 0..1 </remarks>
        public float Intersect(Vector4 a, Vector4 b)
        {
            // Think of an inverse lerp function
            var x = Vector4.Dot(normal, a);
            var y = Vector4.Dot(normal, b);
            return y == x ? 0 : (distance - x) / (y - x);
        }


        /// <summary>
        /// Project the point to the nearest point on the plane.
        /// </summary>
        public Vector4 Project(Vector4 point)
        {
            return point - normal * Distance(point);
        }

        /// <summary>
        /// Is the two point is in the same side of the plane?
        /// </summary>
        public bool SameSide(Vector4 a, Vector4 b)
        {
            var x = Vector4.Dot(normal, a) - distance;
            var y = Vector4.Dot(normal, b) - distance;
            return x * y > 0;
        }
    }
}