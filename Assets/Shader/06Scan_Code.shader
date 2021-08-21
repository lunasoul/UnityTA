// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/06Scan_Code"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RimMin("RimMin",Range(-1,1)) = 0.0
        _RimMax("RimMax",Range(0,2)) = 1.0
        _InnerColor("InnerColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        LOD 100

        Pass
        {
            ZWrite on
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
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 pos_world : TEXCOORD1;
                float3 normal_world : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _RimMin;
            float _RimMax;
            float4 _InnerColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                float3 normal_world = mul(float4(v.normal,0.0),unity_WorldToObject).xyz;
                float3 pos_world = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal_world = normalize(normal_world);
                o.pos_world = pos_world;
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 normal_world = normalize(i.normal_world);
                half3 view_world = normalize(_WorldSpaceCameraPos.xyz - i.pos_world);
                half NdotV = saturate(dot(normal_world,view_world));
                half fresnel = 1.0 - NdotV;
                fresnel = smoothstep(_RimMin, _RimMax, fresnel);
                half4 emiss = tex2D(_MainTex, i.uv).r;
                emiss = pow(emiss,5.0);
                half final_fresnel = saturate(fresnel + emiss);
                half3 rim_color = _InnerColor.xyz;
                return fresnel.xxxx;

            }
            ENDCG
        }
    }
}
