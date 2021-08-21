// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "TA/07_Rim"
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
		_RimPower("RimPower", Float) = 1.0
	}

	SubShader
	{
		Tags {"Queue" = "Transparent"}
		Pass
		{
			ZWrite Off
			Blend SrcAlpha One
			Cull [_CullMode]
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 texcoord0 : TEXCOORD0;
				float3 normal : NORMAL;

			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal_world : TEXCOORD1;
				half2 uv : TEXCOORD0;
				float3 view_world : TEXCOORD2;
			};

			float4 _LunaColor;
			sampler2D _LunaTex;
			float4 _LunaTex_ST;
			float _Emiss;
			float _RimPower;
			

			v2f vert(appdata v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal_world = normalize(mul(float4(v.normal,0.0),unity_WorldToObject));
				float3 pos_world = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.view_world = normalize(_WorldSpaceCameraPos.xyz - pos_world);
				o.uv = v.texcoord0*_LunaTex_ST.xy+_LunaTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float3 normal_world = normalize(i.normal_world);
				float3 view_world = normalize(i.view_world);
				float NdotV = saturate(dot(normal_world,view_world));
				float fresnel = pow((1.0-NdotV), _RimPower);
				float rim = saturate(fresnel*_Emiss);
				float3 col = _LunaColor.xyz*_Emiss;
				return float4(col, rim);
			}

			ENDCG
		}
	
	}

}