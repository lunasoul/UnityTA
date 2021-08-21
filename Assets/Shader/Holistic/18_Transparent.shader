Shader "Holistic/18_Transparent" {
	Properties{
			_MainTex("MainTex", 2D) = "black"{}

	}

		SubShader{
			Tags{ "Queue" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off
			Pass{
			SetTexture [_MainTex] { combine texture }
			}

	}

		FallBack "Diffuse"
}