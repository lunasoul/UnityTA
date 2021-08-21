Shader "Holistic/09_BasicPhong" {
Properties{
		_myColour("Example Colour", Color) = (1,1,1,1)
		_SpecColor("SpecColour", Color) = (1,1,1,1)
		_Spec("Specular", Range(0,1)) = 0.5
		_Gloss("Gloss", Range(0,1)) = 0.5

}

SubShader{
	Tags{ "Queue" = "Geometry" }
	CGPROGRAM
	#pragma surface surf BlinnPhong

	struct Input {
		float2 uvMainTex;
	};

	fixed4 _myColour;
	half _Spec;
	fixed _Gloss;



	void surf(Input IN, inout SurfaceOutput o) {
		o.Albedo = _myColour.rgb;
		o.Specular = _Spec;
		o.Gloss = _Gloss;
	}

	ENDCG
}

FallBack "Diffuse"
}