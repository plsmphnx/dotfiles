precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {

    vec4 pixColor = texture2D(tex, v_texcoord);

    gl_FragColor.rgb = pow(pixColor.rgb, vec3(1.25));
}
