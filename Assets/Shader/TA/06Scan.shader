// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TA/06Scan"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_RimMin("RimMin", Float) = 0
		_RimMax("RimMax", Float) = 0
		_InnerColor("InnerColor", Color) = (0,0,0,0)
		_RimColor("RimColor", Color) = (0,0,0,0)
		_RimIntensity("RimIntensity", Float) = 0
		_FlowIntensity("FlowIntensity", Float) = 0
		_FlowTiling("FlowTiling", Vector) = (0,0,0,0)
		_Speed("Speed", Vector) = (0,0,0,0)
		_InnerAlpha("InnerAlpha", Float) = 0
		_TexPower("TexPower", Float) = 0
		_FlowEmiss("FlowEmiss", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 viewDir;
			float3 worldPos;
		};

		uniform float4 _InnerColor;
		uniform float4 _RimColor;
		uniform float _RimIntensity;
		uniform sampler2D _MainTex;
		SamplerState sampler_MainTex;
		uniform float4 _MainTex_ST;
		uniform float _TexPower;
		uniform float _RimMin;
		uniform float _RimMax;
		uniform sampler2D _FlowEmiss;
		uniform float2 _FlowTiling;
		uniform float2 _Speed;
		uniform float _FlowIntensity;
		uniform float _InnerAlpha;
		SamplerState sampler_FlowEmiss;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldNormal = i.worldNormal;
			float dotResult8 = dot( ase_worldNormal , i.viewDir );
			float clampResult9 = clamp( dotResult8 , 0.0 , 1.0 );
			float smoothstepResult17 = smoothstep( _RimMin , _RimMax , ( 1.0 - clampResult9 ));
			float clampResult48 = clamp( ( pow( tex2D( _MainTex, uv_MainTex ).r , _TexPower ) + smoothstepResult17 ) , 0.0 , 1.0 );
			float4 lerpResult22 = lerp( _InnerColor , ( _RimColor * _RimIntensity ) , clampResult48);
			float4 RimColor57 = lerpResult22;
			float3 ase_worldPos = i.worldPos;
			float4 appendResult33 = (float4(ase_worldPos.x , ase_worldPos.y , 0.0 , 0.0));
			float3 objToWorld34 = mul( unity_ObjectToWorld, float4( float3(0,0,0), 1 ) ).xyz;
			float4 appendResult36 = (float4(objToWorld34.x , objToWorld34.y , 0.0 , 0.0));
			float4 tex2DNode25 = tex2D( _FlowEmiss, ( ( ( appendResult33 - appendResult36 ) * float4( _FlowTiling, 0.0 , 0.0 ) ) + float4( ( _Speed * _Time.y ), 0.0 , 0.0 ) ).xy );
			float4 FlowColor51 = ( tex2DNode25 * _FlowIntensity );
			o.Emission = ( RimColor57 + FlowColor51 ).rgb;
			float RimAlpha58 = clampResult48;
			float FlowAlpha53 = ( tex2DNode25.a * _FlowIntensity );
			float clampResult40 = clamp( ( RimAlpha58 + _InnerAlpha + FlowAlpha53 ) , 0.0 , 1.0 );
			o.Alpha = clampResult40;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
348.8;146.4;1609;803;1089.654;-2818.292;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;56;-986.9008,2318.938;Inherit;False;2519.582;1116.161;Flow Light;18;35;32;34;36;33;37;50;27;49;29;28;25;44;53;42;41;51;62;Flow Light;0.5943396,0.7924528,0.6603706,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-991.8561,-14.51992;Inherit;False;2437.951;1840.828;Rim Light;20;48;7;6;8;9;1;46;18;10;19;17;45;47;24;21;23;20;22;57;58;Rim Light;0.5479708,0.7376485,0.8867924,1;0;0
Node;AmplifyShaderEditor.Vector3Node;35;-936.9008,2625.407;Inherit;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;34;-735.6869,2621.814;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;32;-814.9398,2368.938;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;6;-657.101,1014.533;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;7;-647.101,1252.533;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;36;-473.6867,2633.814;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-582.8803,2383.624;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;8;-377.1012,1152.533;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;50;-264.087,2803.698;Inherit;False;Property;_FlowTiling;FlowTiling;12;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;-318.2333,2561.523;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;62;-413.6541,3269.292;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-431.3454,3068.615;Inherit;False;Property;_Speed;Speed;13;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;9;-135.5396,1255.991;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-170.3455,3181.615;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;10;50.50433,1261.37;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-103.8915,1569.309;Inherit;False;Property;_RimMin;RimMin;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-616.3358,844.5938;Inherit;False;Property;_TexPower;TexPower;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-941.8561,645.653;Inherit;True;Property;_MainTex;MainTex;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-120.8914,1710.309;Inherit;False;Property;_RimMax;RimMax;7;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-83.55833,2570.812;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PowerNode;45;-184.3358,706.5938;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;254.9241,2968.433;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;17;293.1964,1384.343;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;535.8279,2912.496;Inherit;True;Property;_FlowEmiss;FlowEmiss;16;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;693.9189,2648.56;Inherit;False;Property;_FlowIntensity;FlowIntensity;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;196.3785,642.4207;Inherit;False;Property;_RimIntensity;RimIntensity;10;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;548.8992,1082.122;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;234.6442,410.4801;Inherit;False;Property;_RimColor;RimColor;9;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;257.6442,35.48008;Inherit;False;Property;_InnerColor;InnerColor;8;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;48;785.3546,1082.169;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;1096.587,2933.594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;546.0465,517.5453;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;22;1064.243,598.4801;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;1222.094,1077.834;Inherit;False;RimAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;1290.106,2946.068;Inherit;False;FlowAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;1080.221,2642.429;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;1216.155,872.6469;Inherit;False;RimColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;2297.087,1423.966;Inherit;False;58;RimAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;2168.694,1694.664;Inherit;False;53;FlowAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;2096.209,1591.512;Inherit;False;Property;_InnerAlpha;InnerAlpha;14;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;1308.681,2662.839;Inherit;False;FlowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;2291.307,1026.286;Inherit;False;51;FlowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;2269.667,850.0938;Inherit;False;57;RimColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;2508.155,1562.923;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;40;2681.703,1556.72;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;2621.549,985.1689;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3253.298,1282.427;Float;False;True;-1;7;ASEMaterialInspector;0;0;Unlit;TA/06Scan;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;35;0
WireConnection;36;0;34;1
WireConnection;36;1;34;2
WireConnection;33;0;32;1
WireConnection;33;1;32;2
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;37;0;33;0
WireConnection;37;1;36;0
WireConnection;9;0;8;0
WireConnection;29;0;27;0
WireConnection;29;1;62;0
WireConnection;10;0;9;0
WireConnection;49;0;37;0
WireConnection;49;1;50;0
WireConnection;45;0;1;1
WireConnection;45;1;46;0
WireConnection;28;0;49;0
WireConnection;28;1;29;0
WireConnection;17;0;10;0
WireConnection;17;1;18;0
WireConnection;17;2;19;0
WireConnection;25;1;28;0
WireConnection;47;0;45;0
WireConnection;47;1;17;0
WireConnection;48;0;47;0
WireConnection;44;0;25;4
WireConnection;44;1;42;0
WireConnection;23;0;21;0
WireConnection;23;1;24;0
WireConnection;22;0;20;0
WireConnection;22;1;23;0
WireConnection;22;2;48;0
WireConnection;58;0;48;0
WireConnection;53;0;44;0
WireConnection;41;0;25;0
WireConnection;41;1;42;0
WireConnection;57;0;22;0
WireConnection;51;0;41;0
WireConnection;39;0;60;0
WireConnection;39;1;55;0
WireConnection;39;2;54;0
WireConnection;40;0;39;0
WireConnection;38;0;59;0
WireConnection;38;1;52;0
WireConnection;0;2;38;0
WireConnection;0;9;40;0
ASEEND*/
//CHKSM=3BDB16DEF19AB35ED410037631A039634FBD2A09