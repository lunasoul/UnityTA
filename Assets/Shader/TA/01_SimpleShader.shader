// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TA/01_SimpleShader"
{
	Properties
	{
		_LunaFloat("LunaFloat", Float) = 0.0
		_LunaRange("LunaRange", Range(0.0,10.0)) = 5.0
		_LunaVector("LunaVector", Vector) = (1,1,1,1)
		_LunaColor("LunaColor", Color) = (1,0,0,1)
		_LunaTex("Luna Texture", 2D) = "bump"{}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 uv : TEXCOORD0;
				//float3 normal : NORMAL;
				//float4 color : COLOR;
			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float4 _LunaColor;
			sampler2D _LunaTex;
			float4 _LunaTex_ST;
			

			v2f vert(appdata v)
			{
				v2f o;
				//float4 pos_world = mul(unity_ObjectToWorld, v.vertex);
				//float4 pos_view = mul(UNITY_MATRIX_V, pos_world);
				//float4 pos_clip = mul(UNITY_MATRIX_P, pos_view);
				//o.pos = pos_clip;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv*_LunaTex_ST.xy+_LunaTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float4 col = tex2D(_LunaTex,i.uv);
				return col;
			}

			ENDCG
		}
	
	}

}