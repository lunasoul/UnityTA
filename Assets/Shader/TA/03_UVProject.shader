Shader "TA/03_UVProject"
{
	Properties
	{
		_LunaFloat("LunaFloat", Float) = 0.0
		_LunaRange("LunaRange", Range(0.0,10.0)) = 5.0
		_LunaVector("LunaVector", Vector) = (1,1,1,1)
		_LunaColor("LunaColor", Color) = (1,0,0,1)
		_LunaTex("Luna Texture", 2D) = "bump"{}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode",float) = 2
	}

	SubShader
	{
		Pass
		{
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
				float2 pos_uv : TEXCOORD1;
			};

			float4 _LunaColor;
			sampler2D _LunaTex;
			float4 _LunaTex_ST;
			

			v2f vert(appdata v)
			{
				v2f o;
				float4 pos_world = mul(unity_ObjectToWorld,v.vertex);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv*_LunaTex_ST.xy+_LunaTex_ST.zw;
				//o.pos_uv = v.vertex.zy*_LunaTex_ST.xy + _LunaTex_ST.zw;
				o.pos_uv = pos_world.xy*_LunaTex_ST.xy + _LunaTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float4 col = tex2D(_LunaTex,i.pos_uv);
				return col;
			}

			ENDCG
		}
	
	}

}