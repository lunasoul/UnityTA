Shader "Holistic/25_ColourVF"
{
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
                float2 uv : TEXCOORD;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR0;
                float2 uv : TEXCOORD;
            };


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color.r = (v.vertex.x+10)/20;
                o.color.g = (v.vertex.y+10)/20;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = i.color;
                col.r = (i.vertex.x)/500;
                col.g = (i.vertex.y)/500;
                return col;
            }
            ENDCG
        }
    }
    FallBack  "DIFFUSE"
}
