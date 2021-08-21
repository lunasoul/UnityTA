Shader "Holistic/17_BlendTest2"
{
	Properties{
		_MainTex("Texture", 2D) = "black"{}
	}
		SubShader{
		Tags { "Queue" = "Transparent" }
		//Blend One One
		//Blend SrcAlpha OneMinusSrcAlpha
		Blend DstColor Zero
		Pass{
			SetTexture [_MainTex] { combine texture }
		}
	}
}
