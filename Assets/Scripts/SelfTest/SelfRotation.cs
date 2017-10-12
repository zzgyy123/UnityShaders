using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelfRotation : MonoBehaviour {

    public float YAxisRotateSpeed=40.0f;

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
        transform.rotation =transform.rotation* Quaternion.Euler(0.0f, YAxisRotateSpeed  * Time.deltaTime, 0.0f);
	}
}
