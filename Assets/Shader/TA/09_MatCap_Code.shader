﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "TA/09_MatCap_Code"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MatcapTex("MatcapTex", 2D) = "black"{}
        _MatcapIntensity("MatcapIntensity", Float) = 1.0
        _RampTex("RampTex", 2D) = "black"{}
        _MatcapAddTex("MatcapAddTex", 2D) = "black"{}
        _MatcapAddIntensity("MatcapAddIntensity", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal_world : TEXCOORD1;
                float3 pos_world : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _MatcapTex;
            float _MatcapIntensity;
            sampler2D _RampTex;
            sampler2D _MatcapAddTex;
            float _MatcapAddIntensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float3 normal_world = mul(float4(v.normal,0.0),unity_WorldToObject);
                o.normal_world = normal_world;
                o.pos_world = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Diffuse
                fixed4 diffuse_color = tex2D(_MainTex, i.uv);
                
                //Base Matcap
                half3 normal_world = normalize(i.normal_world);
                half3 normal_viewspace = mul(UNITY_MATRIX_V, float4(normal_world,0.0)).xyz;
                half2 uv_matcap = 0.5*(normal_viewspace.xy + float2(1.0,1.0));
                fixed4 matcap_color = _MatcapIntensity*tex2D(_MatcapTex, uv_matcap);

                //Add Matcap
                fixed4 matcap_add_color = tex2D(_MatcapAddTex, uv_matcap);

                //Ramp
                half3 view_dir = normalize(_WorldSpaceCameraPos.xyz - i.pos_world);
                half NdotV = saturate(dot(normal_world, view_dir));
                half fresnel = 1.0 - NdotV;
                half2 uv_ramp = half2(fresnel, 0.5);
                fixed4 ramp_color = tex2D(_RampTex,uv_ramp);
                //Combine
                fixed4 combined_color = diffuse_color * matcap_color*ramp_color + matcap_add_color * _MatcapAddIntensity;
                return combined_color;
            }
            ENDCG
        }
    }
}
