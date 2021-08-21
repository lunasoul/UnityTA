// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

shader "CS02/LunaShaderMini"
{
	Properties
	{
		_lunaFloat("浮点数",Float) = 3.0
		_range("Range", Range(0.0,1.0)) = 1.0
		_vector("vector", Vector) = (0,1,0,0)
		_Color("Color", Color) = (0,0,1,1)
		_MainTex("Texture", 2D) = "white"{}
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM  // Shader代码从这里开始
			#pragma vertex vert //指定一个名为"vert"的函数为顶点Shader
			#pragma fragment frag //指定一个名为"frag"函数为片元Shader
			#include "UnityCG.cginc"  //引用Unity内置的文件，很方便，有很多现成的函数提供使用

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;	//第1套UV
				//float2 uv2 : TEXCOORD1;	//第2套UV
				//float2 uv3 : TEXCOORD2;	//第3套UV
				//float2 uv4 : TEXCOORD3;	//第4套UV
				float3 normal : NORMAL;	
				float4 color : COLOR;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;	//储存器 插值器 0-15总共16个
			};

			v2f vert(appdata v)
			{
				v2f o;
				//float4 pos_world = mul(unity_ObjectToWorld, v.vertex);
				//float4 pos_view = mul(UNITY_MATRIX_V, pos_world);
				//float4 pos_clip = mul(UNITY_MATRIX_P, pos_view);
				//o.pos = pos_clip;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * _MainTex_ST.xy+_MainTex_ST.zw;
				return o;

			}

			float4 frag(v2f i) : SV_Target
			{
				float4 col = tex2D(_MainTex, i.uv);
				
				return col;
			}

			ENDCG // Shader代码从这里结束
		}
	}


}
