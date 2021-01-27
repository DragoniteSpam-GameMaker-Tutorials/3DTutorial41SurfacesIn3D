varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_worldPosition;
varying vec3 v_worldNormal;

uniform vec3 lightPosition;
uniform vec4 lightColor;
uniform float lightRange;

uniform sampler2D rampTex;
uniform float time;

void main() {
    vec4 starting_color = v_vColour *
        texture2D(gm_BaseTexture, v_vTexcoord);
    //vec4 starting_color = vec4(1.);
    
    vec4 lightAmbient = vec4(0.125, 0.125, 0.125, 1.);
    
    // Spot light stuff
    vec3 lightIncoming = v_worldPosition - lightPosition;
    float lightDist = length(lightIncoming);
    lightIncoming = normalize(-lightIncoming);
    float NdotL = max(dot(v_worldNormal, lightIncoming), 0.);
    
    vec2 NdotL_tex = vec2(NdotL, time);
    vec4 NdotL_ramp = texture2D(rampTex, NdotL_tex);
    //float NdotL_adjusted = (NdotL_ramp.r + NdotL_ramp.b +
        //NdotL_ramp.g) / 3.0;
    
    float att = max((lightRange - lightDist) / lightRange, 0.);
    
    vec4 final_color = starting_color *
        vec4(min(lightAmbient + lightColor * att * NdotL_ramp,
        vec4(1.)).rgb, starting_color.a);
    gl_FragData[0] = final_color;
    //gl_FragData[1] = vec4(1., 0., 0., 1.);
}
