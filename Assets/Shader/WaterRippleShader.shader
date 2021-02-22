Shader "Custom/WaterRippleShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Scale("Scale",float) = 1
		_Speed("Speed",float) = 1
		_Frequency("Frequency",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert


        sampler2D _MainTex;
		float _Scale;
		float _Speed;
		float _Frequency;

        struct Input
        {
            float2 uv_MainTex;
        };
		void vert (inout appdata_full v)
		{
			half offsetvert = (v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z);

			half value = _Scale * sin(_Time.w * _Speed + offsetvert * _Frequency);
			v.vertex.y += value;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Emission = tex2D(_MainTex, IN.uv_MainTex);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
