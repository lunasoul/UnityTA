using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Main : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //if space key pressed
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("Space Key");
		}

        if(Input.GetKey(KeyCode.E))
        {
            Debug.Log("Holding E");
		}
        
    }
}
