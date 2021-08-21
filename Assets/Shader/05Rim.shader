// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "CS02/05Rim" //Shader的真正名字  可以是路径式的格式
{
	/*材质球参数及UI面板
	https://docs.unity3d.com/cn/current/Manual/SL-Properties.html
	https://docs.unity3d.com/cn/current/ScriptReference/MaterialPropertyDrawer.html
	https://zhuanlan.zhihu.com/p/93194054
	*/
	Properties
	{
		_MainColor("MainColor",Color) = (1,1,1,1)
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode",float) = 2
		_Emiss("Emiss",Float) = 1
		_RimPower("RimPower",Float) = 1
	}
		/*
		这是为了让你可以在一个Shader文件中写多种版本的Shader，但只有一个会被使用。
		提供多个版本的SubShader，Unity可以根据对应平台选择最合适的Shader
		或者配合LOD机制一起使用。
		一般写一个即可
		*/
		SubShader
	{
		/*
		标签属性，有两种：一种是SubShader层级，一种在Pass层级
		https://docs.unity3d.com/cn/current/Manual/SL-SubShaderTags.html
		https://docs.unity3d.com/cn/current/Manual/SL-PassTags.html
		*/
		Tags { "Queue" = "Transparent" }
		/*
		Pass里面的内容Shader代码真正起作用的地方，
		一个Pass对应一个真正意义上运行在GPU上的完整着色器(Vertex-Fragment Shader)
		一个SubShader里面可以包含多个Pass，每个Pass会被按顺序执行
		*/
		
		/*
		这个Shader预先写了一遍深度，不写Color
		这样可以有效避免穿透半透明物体看到后面的东西
		*/
		Pass
		{
			Cull Off
			ZWrite On
			ColorMask 0
			CGPROGRAM
			float4 _Color;
			#pragma vertex vert
			#pragma fragment frag
			
			float4 vert(float4 vertexPos : POSITION) : SV_POSITION
			{
				return UnityObjectToClipPos(vertexPos);
			}

			float4 frag() : COLOR
			{
				return _Color;
			}

			ENDCG



		}
		Pass 
		{
			ZWrite Off
			// Blend SrcAlpha OneMinusSrcAlpha
			Blend SrcAlpha One
			Cull [_CullMode]
			CGPROGRAM  // Shader代码从这里开始
			#pragma vertex vert //指定一个名为"vert"的函数为顶点Shader
			#pragma fragment frag //指定一个名为"frag"函数为片元Shader
			#include "UnityCG.cginc"  //引用Unity内置的文件，很方便，有很多现成的函数提供使用

			//https://docs.unity3d.com/Manual/SL-VertexProgramInputs.html
			struct appdata  //CPU向顶点Shader提供的模型数据
			{
				//冒号后面的是特定语义词，告诉CPU需要哪些类似的数据
				float4 vertex : POSITION; //模型空间顶点坐标
				half2 texcoord0 : TEXCOORD0; //第一套UV
				half2 texcoord1 : TEXCOORD1; //第二套UV
				half2 texcoord2 : TEXCOORD2; //第二套UV
				half2 texcoord4 : TEXCOORD3;  //模型最多只能有4套UV

				half4 color : COLOR; //顶点颜色
				float3 normal : NORMAL; //顶点法线
				half4 tangent : TANGENT; //顶点切线(模型导入Unity后自动计算得到)
			};

			struct v2f  //自定义数据结构体，顶点着色器输出的数据，也是片元着色器输入数据
			{
				float4 pos : SV_POSITION; //输出裁剪空间下的顶点坐标数据，给光栅化使用，必须要写的数据
				float2 uv : TEXCOORD0; //自定义数据体
				//注意跟上方的TEXCOORD的意义是不一样的，上方代表的是UV，这里可以是任意数据。
				//插值器：输出后会被光栅化进行插值，而后作为输入数据，进入片元Shader
				//最多可以写16个：TEXCOORD0 ~ TEXCOORD15。
				float3 normal_world : TEXCOORD1;
				float3 view_world : TEXCOORD2;
			};

			/*
			Shader内的变量声明，如果跟上面Properties模块内的参数同名，就可以产生链接
			*/
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;
			float _Emiss;
			float _RimPower;
			//Unity内置变量：https://docs.unity3d.com/560/Documentation/Manual/SL-UnityShaderVariables.html
			//Unity内置函数：https://docs.unity3d.com/560/Documentation/Manual/SL-BuiltinFunctions.html
			
			//顶点Shader
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normal_world = normalize(mul(float4(v.normal,0.0),unity_WorldToObject));
				float3 pos_world = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.view_world = normalize(_WorldSpaceCameraPos.xyz - pos_world);
				o.uv = v.texcoord0 * _MainTex_ST.xy + _MainTex_ST.zw;

				return o;
			}
			//片元Shader
			half4 frag(v2f i) : SV_Target //SV_Target表示为：片元Shader输出的目标地（渲染目标）
			{
				float3 normal_world = normalize(i.normal_world);
				float3 view_world = normalize(i.view_world);
				float NdotV = saturate(dot(normal_world, view_world));
				float3 col = _MainColor.xyz * _Emiss;
				float fresnel = pow((1.0-NdotV), _RimPower);
				float alpha = saturate(fresnel * _Emiss);
				return float4(col,alpha);


			}
			ENDCG // Shader代码从这里结束
		}
	}
}
