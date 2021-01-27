varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 lightPosition;
uniform vec3 lightDirection;
uniform vec4 lightColor;
uniform float lightRange;
uniform float lightCutoffAngle;

varying vec3 v_worldPosition;
varying vec3 v_worldNormal;

void main() {
    vec4 starting_color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    //vec4 lightAmbient = vec4(0.25, 0.25, 0.25, 1.);
    vec4 lightAmbient = vec4(1.);
    
    // Spot light stuff
    vec3 lightIncoming = v_worldPosition - lightPosition;
    float lightDist = length(lightIncoming);
    lightIncoming = normalize(-lightIncoming);
    float NdotL = max(dot(v_worldNormal, lightIncoming), 0.);
    
    float coneAngle = max(dot(lightIncoming, -normalize(lightDirection)), 0.);
    
    // This is equal to dcos(30) - you may wish for this to be a uniform instead
    float innerCone = cos(3.14159 / 6.);
    float f = clamp((coneAngle - lightCutoffAngle) / (innerCone - lightCutoffAngle), 0., 1.);
    float att = f * max((lightRange - lightDist) / lightRange, 0.);
    
    vec4 final_color = starting_color * vec4(min(lightAmbient + att * lightColor * NdotL, vec4(1.)).rgb, starting_color.a);
    gl_FragColor = final_color;
}