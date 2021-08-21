Shader "TA/06_Blending"
{
	Properties
	{
		_LunaFloat("LunaFloat", Float) = 0.0
		_LunaRange("LunaRange", Range(0.0,10.0)) = 5.0
		_LunaVector("LunaVector", Vector) = (1,1,1,1)
		_LunaColor("LunaColor", Color) = (1,0,0,1)
		_LunaTex("Luna Texture", 2D) = "white"{}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode",float) = 2
		_Emiss("Emiss", Float) = 1.0
	}

	SubShader
	{
		Tags{ "Queue" = "Transparent"}
		Pass
		{
			ZWrite Off
			//Blend SrcAlpha OneMinusSrcAlpha
			Blend SrcAlpha One
			Cull [_CullMode]
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 uv : TEXCOORD0;

			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float4 _LunaColor;
			sampler2D _LunaTex;
			float4 _LunaTex_ST;
			float _Emiss;
			

			v2f vert(appdata v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv*_LunaTex_ST.xy+_LunaTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				half3 col = _LunaColor.xyz*_Emiss;
				half alpha = saturate(tex2D(_LunaTex,i.uv).r*_LunaColor.a);
				return float4(col,alpha);
			}

			ENDCG
		}
	
	}

}