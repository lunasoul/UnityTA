Shader "TA/05_Clip"
{
	Properties
	{
		_LunaFloat("LunaFloat", Float) = 0.0
		_LunaRange("LunaRange", Range(0.0,10.0)) = 5.0
		_LunaVector("LunaVector", Vector) = (1,1,1,1)
		_LunaColor("LunaColor", Color) = (1,0,0,1)
		_LunaTex("Luna Texture", 2D) = "bump"{}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode",float) = 2
		_Cutout("Cutout",Float) = 0.0
		_Speed("Speed",Vector) = (1,1,0,0)
		_NoiseTex("NoiseTex",2D) = "white"{}
		
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
			};

			float4 _LunaColor;
			sampler2D _LunaTex;
			float4 _LunaTex_ST;
			float _Cutout;
			float4 _Speed;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;

			

			v2f vert(appdata v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv*_LunaTex_ST.xy+_LunaTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				half gradient = tex2D(_LunaTex,i.uv+_Time.y*_Speed.xy).r;
				half noise = tex2D(_NoiseTex,i.uv+_Time.y*_Speed.zw).r;
				clip(gradient-noise-_Cutout);
				return _LunaColor;
			}

			ENDCG
		}
	
	}

}