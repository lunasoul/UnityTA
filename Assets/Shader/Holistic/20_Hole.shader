Shader "Holistic/20_Hole"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MyColor ("My Color", Color) = (1,1,1,1)
    }
    SubShader{
        Tags { "Queue"="Geometry-1" }

        ColorMask 0
        ZWrite off

        Stencil{
            Ref 1
            Comp Always
            Pass replace
        
        }

        CGPROGRAM
        #pragma surface surf Lambert
        sampler2D _MainTex;
        fixed4 _MyColor;

        struct Input{
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o){
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb*_MyColor;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
