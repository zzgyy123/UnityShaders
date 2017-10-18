using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestSharedMaterial : MonoBehaviour
{

    Renderer myRenderer;

    void Start()
    {
        myRenderer = GetComponent<Renderer>();
        myRenderer.material.color = Color.red;
        //myRenderer.sharedMaterial.color = Color.blue;
    }
}
