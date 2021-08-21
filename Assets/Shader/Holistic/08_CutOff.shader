Shader "Holistic/08_CutOff" {
    Properties {
      _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
      _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
      _ObjScale("ObjScale", Range(0.1,10))=1.0
      _BeltDensity("BeltDensity", Range(0.02,1))=0.5
    }
    SubShader {
      CGPROGRAM
      #pragma surface surf Lambert
      struct Input {
          float3 viewDir;
          float3 worldPos;
      };

      float4 _RimColor;
      float _RimPower;
      float _ObjScale;
      float _BeltDensity;


      void surf (Input IN, inout SurfaceOutput o) {
          half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
          rim = pow(rim,_RimPower);
          //o.Emission = IN.worldPos.y>1 ? float3(0,1,0):float3(1,0,0);
          o.Emission = frac(IN.worldPos.y*_ObjScale*_BeltDensity)>0.4?
                        float3(0,1,0)*rim:float3(1,0,0)*rim;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }