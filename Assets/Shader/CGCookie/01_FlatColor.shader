// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityCookie/1 - Flat Color"{
	Properties{
		_Color("Color", Color) = (1.0,0.0,1.0,1.0)
	}

	SubShader{
		Pass{
			CGPROGRAM
			//pragmas
			#pragma vertex bob
			#pragma fragment jill 
			
			//user defined variables
			uniform float4 _Color;

			//base input structs
			struct vertexInput{
				float4 vertex : POSITION;							
			};		

			struct vertexOutput{
				float4 pos : SV_POSITION;
			};
			
			//vertex functions
			vertexOutput bob(vertexInput v){
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//UNITY_MATRIX_MVP xyzw
				//v.vertex xyzw
				//mul(UNITY_MATRIX_MVP,v.vertex)=
				return o;
			}

			//fragment function
			float4 jill(vertexOutput i) : COLOR
			{
				return _Color;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}