precision mediump float;

uniform bool uEnableLighting;

uniform vec3 uLightPosition;
uniform vec3 uLightColor;

varying vec3 vNormalEye;
varying vec3 vVertexPositionEye3;

varying vec3 vColor;

const float ambientFactor = 0.4;
const float shininess = 50.0;
const vec3 specularMaterialColor = vec3(0.5, 0.5, 0.5);

void main() {
    vec3 baseColor = vColor;

    if (uEnableLighting) {
        // calculate light direction as seen from the vertex position
        vec3 lightDirectionEye = normalize(uLightPosition - vVertexPositionEye3);
        vec3 normal = normalize(vNormalEye);

        // ambient lighting
        vec3 ambientColor = ambientFactor * baseColor.rgb;

        // diffuse lighting
        float cosAngle = clamp(dot(normal, lightDirectionEye), 0.0, 1.0);
        vec3 diffuseColor = cosAngle * baseColor.rgb * uLightColor;

        // specular lighting
        vec3 specularColor = vec3(0, 0, 0);
        if (cosAngle > 0.0) {
            vec3 reflectionDir =  normalize(reflect(-lightDirectionEye, normal));
            vec3 eyeDir = normalize(-1.0 * vVertexPositionEye3);
            float cosPhi = clamp(dot(reflectionDir, eyeDir), 0.0 , 1.0);
            cosPhi = pow(cosPhi, shininess);
            specularColor = cosPhi * specularMaterialColor * uLightColor * cosPhi;
        }
        vec3 color = ambientColor + diffuseColor + specularColor;
        gl_FragColor = vec4(color, 1.0);
    }
}