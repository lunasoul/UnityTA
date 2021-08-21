Shader "Holistic/04_NormalMapShader"{
Properties{
		_myDiffuse("Diffuse Tex", 2D) = "white" {}
		_myNormal("Normal Tex", 2D) = "bump" {}
		_mySlider("Bump Amount", Range(0,10)) = 1

}

SubShader{
	Tags { "Queue" = "Geometry+100" }
	ZWrite Off
	CGPROGRAM
	#pragma surface surf Lambert
	sampler2D _myDiffuse;
	sampler2D _myNormal;
	half _mySlider;

	struct Input {
		float2 uv_myDiffuse;
		float2 uv_myNormal;
	};



	void surf(Input IN, inout SurfaceOutput o) {
		o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
		o.Normal = UnpackNormal(tex2D(_myNormal, IN.uv_myNormal));
		o.Normal *= float3(_mySlider,_mySlider,1);
	}

ENDCG
}

FallBack "Diffuse"
}