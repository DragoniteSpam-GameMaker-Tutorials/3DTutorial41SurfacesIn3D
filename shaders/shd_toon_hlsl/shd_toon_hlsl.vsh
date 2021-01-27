struct VSInput {
    float3 pos: POSITION;
    float3 norm: NORMAL;
    float2 uv: TEXCOORD0;
    float4 color: COLOR0;
};

struct VSOutput {
    float4 pos: SV_POSITION;
    float2 uv: TEXCOORD;
    float4 color: COLOR;
    
    float3 worldPos: POSITION;
    float3 worldNorm: NORMAL;
    
    float depth: DEPTH;
};

VSOutput main(VSInput input) {
    VSOutput output;
    
    output.pos = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], float4(input.pos, 1.));
    output.uv = input.uv;
    output.color = input.color;
    
    output.worldPos = (mul(gm_Matrices[MATRIX_WORLD], float4(input.pos, 1.))).xyz;
    output.worldNorm = (mul(gm_Matrices[MATRIX_WORLD], normalize(float4(input.norm, 0.)))).xyz;
    
    output.depth = length(mul(gm_Matrices[MATRIX_WORLD_VIEW], float4(input.pos, 1.)).xyz);
    
    return output;
}