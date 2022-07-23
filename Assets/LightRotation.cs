using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightRotation : MonoBehaviour
{

    public float startX;
    private float currRot;
    public float rotVel;
    // Start is called before the first frame update
    void Start()
    {
        transform.rotation = Quaternion.Euler(startX, 0f, 0f);
        currRot = 0f;
    }

    // Update is called once per frame
    void Update()
    {
        currRot = (currRot + rotVel) % 360;
        transform.rotation = Quaternion.Euler(startX, currRot, 0f);
    }
}
