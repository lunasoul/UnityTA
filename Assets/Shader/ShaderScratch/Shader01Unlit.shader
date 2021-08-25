Shader "Scratch/Shader01Unlit"
{
    Properties
    {
       
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
      
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
           

            #include "UnityCG.cginc"

           

          
          

            fixed4 frag (v2f_img i) : SV_Target
            {

                return fixed4(1,0,0,1);
            }
            ENDCG
        }
    }
}
