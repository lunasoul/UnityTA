Shader "Holistic/15_Hologram" {
	Properties{
	  _RimColor("Rim Color", Color) = (0,0.5,0.5,0.0)
	  _RimPower("Rim Power", Range(0.5,8.0)) = 3.0
	  _EmissScale("EmissScale",Float) = 1.0
	}
		SubShader{
		Tags { "Queue" = "Transparent" }

		Pass{
				ZWrite On
				ColorMask 0
		}

		CGPROGRAM
		#pragma surface surf Lambert alpha:blend
		struct Input {
		float3 viewDir;
		};

		float4 _RimColor;
		float _RimPower;
		float _EmissScale;

		void surf(Input IN, inout SurfaceOutput o) {
		half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
		o.Emission = _RimColor.rgb * pow(rim, _RimPower) * _EmissScale;
		o.Alpha = pow(rim, _RimPower);
		}
		ENDCG
		}
		Fallback "Diffuse"
}