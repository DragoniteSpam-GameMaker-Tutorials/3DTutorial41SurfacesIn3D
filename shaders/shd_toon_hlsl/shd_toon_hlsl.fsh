struct PSInput {
    float4 pos: SV_POSITION;
    float2 uv: TEXCOORD;
    float4 color: COLOR;
    
    float3 worldPos: POSITION;
    float3 worldNorm: NORMAL;
    
    float depth: DEPTH;
};

struct PSOutput {
    float4 base: SV_TARGET0;
    float4 normals: SV_TARGET1;
};

uniform float3 lightPosition;
uniform float4 lightColor;
uniform float lightRange;

uniform float time;

SamplerState rampTexture: register(s1);
Texture2D objRampTexture: register(t1);

PSOutput main(PSInput input) {
    PSOutput output;
    
    float4 starting_color = input.color * gm_BaseTextureObject.Sample(gm_BaseTexture, input.uv);
    float4 light_ambient = float4(0.125, 0.125, 0.125, 1.);
    
    float3 light_incoming = input.worldPos - lightPosition;
    float light_dist = length(light_incoming);
    light_incoming = normalize(-light_incoming);
    float NdotL = max(dot(input.worldNorm, light_incoming), 0.);
    
    float2 NdotL_tex = float2(NdotL, time);
    float4 NdotL_ramp = objRampTexture.Sample(rampTexture, NdotL_tex);
    
    float att = max((lightRange - light_dist) / lightRange, 0.);
    
    float4 white = float4(1., 1., 1., 1.);
    output.base = starting_color * float4(min(light_ambient + lightColor * att * NdotL_ramp, white).rgb, starting_color.a);
    // Normals to the render target
    output.normals = float4((input.worldNorm / 2.0) + float3(0.5, 0.5, 0.5), 1.);
    
    return output;
}