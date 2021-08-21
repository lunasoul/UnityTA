// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "TA/08_ScanCode"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
        _FlowTex("FlowTex", 2D) = "black" {}
        _RimMin("RimMin",Range(-1.0,1.0)) = 0.0
        _RimMax("RimMax",Range(0.0,2.0)) = 0.5
        _InnerColor("InnerColor",Color) = (0.0,0.0,0.0,0.0)
        _RimColor("RimColor",Color) = (1.0,1.0,1.0,1.0)
        _RimIntensity("RimIntensity",Range(0.0,1.0)) = 1.0
        _FlowTiling("FlowTiling", Vector) = (1.0,1.0,1.0,1.0)
        _FlowSpeed("FlowSpeed", Vector) =  (1.0,1.0,1.0,1.0)
        _FlowIntensity("FlowIntensity", Range(0.0,1.0)) = 1.0
        _InnerAlpha("InnerAlpha", Range(0.0,1.0)) = 0.0
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }

        Pass
        {
            ZWrite Off
            Blend SrcAlpha One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 pos_world : TEXCOORD1;
                float3 normal_world : TEXCOORD2;
                float3 pivot_world : TEXCOORD3;
            };

            sampler2D _MainTex;
            sampler2D _FlowTex;
            float4 _MainTex_ST;
            float _RimMin;
            float _RimMax;
            float4 _InnerColor;
            float4 _RimColor;
            float _RimIntensity;
            float4 _FlowTiling;
            float4 _FlowSpeed;
            float _FlowIntensity;
            float _InnerAlpha;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                float3 normal_world = mul(float4(v.normal,0.0),unity_WorldToObject).xyz;
                float3 pos_world = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal_world = normalize(normal_world);
                o.pos_world = pos_world;
                o.pivot_world = mul(unity_ObjectToWorld, float4(0.0,0.0,0.0,1.0)).xyz;
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 normal_world = normalize(i.normal_world);
                half3 view_world = normalize(_WorldSpaceCameraPos - i.pos_world);
                half NdotV = saturate(dot(normal_world,view_world));
                half fresnel = 1.0 - NdotV;
                fresnel = smoothstep(_RimMin, _RimMax,fresnel);
                fixed4 col = tex2D(_MainTex, i.uv);
                half emiss = col.r;
                emiss = pow(emiss,5.0);
                
                half finalFresnel = saturate(fresnel + emiss);

                half3 final_rim_color = lerp(_InnerColor.xyz,_RimColor.xyz*_RimIntensity,finalFresnel);
                half final_rim_alpha = finalFresnel;

                half2 uv_flow = (i.pos_world.xy - i.pivot_world) * _FlowTiling.xy;
                uv_flow = _Time.y * _FlowSpeed.xy + uv_flow;

                float4 flow_rgba = tex2D(_FlowTex, uv_flow)*_FlowIntensity;
                float3 final_color = final_rim_color+flow_rgba.xyz;
                float final_alpha = saturate(final_rim_alpha+flow_rgba.w+_InnerAlpha);
                //return float4(final_rim_color,final_rim_alphe);
                return float4(final_color,final_alpha);
            }
            ENDCG
        }
    }
}
