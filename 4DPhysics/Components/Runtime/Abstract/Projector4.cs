using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using Engine4;

namespace Engine4.Rendering
{
    /// <summary>
    /// Base class to handle projection from 4D to 3D
    /// </summary>
    public abstract class Projector4 : MonoBehaviour
    {
        /// <summary>
        /// Called by the viewer to initialize the projction
        /// </summary>
        public abstract void Setup(Matrix4x5 viewer);

        /// <summary>
        /// Dynamic projection
        /// </summary>
        public abstract void Project(Buffer4 from, Matrix4x5 transform, IVisualizer to);
        
        /// <summary>
        /// Arbitrary (4D to 3D) point projection 
        /// </summary>
        public abstract Vector3 Project(Vector4 v);
        
        /// <summary>
        /// Arbitrary (4D to 3D) point projection with cull verification
        /// </summary>
        public abstract Vector3 Project(Vector4 v, out bool culled);

        /// <summary>
        /// For static objects, see if given object AABB can be culled out completely
        /// </summary>
        public abstract bool IsCullable(SphereBounds4 bound);

        //void OnValidate ()
        //{
        //    Viewer4.main.SetDirty(DirtyLevel.Transform);
        //}

        /// <summary>
        /// Adapt to simplex requirement for this projection.
        /// </summary>
        public abstract SimplexMode SimplexModeForVisualizing(SimplexMode mode);

    }
}
