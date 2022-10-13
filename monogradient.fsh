//
//  monogradient.fsh
//  Angelica Fighti
//
//  Created by Pablo  on 10/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

void main()
{
    /*
    vec4 color = texture2D(u_texture, v_tex_coord);
    float gradient = 0.0;
    
        if (color.a > 0.1 && color.a < 0.99){
            gl_FragColor = vec4(0,0,0,1);
        }
        else{
                if (v_tex_coord.y < 0.5){
                    gradient = 0.35 - v_tex_coord.y;
                }
                else if (v_tex_coord.y < 0.7){
                    gradient = -0.15 - v_tex_coord.y*0.005;
                }
                else if ( v_tex_coord.y >= 0.7){
                    gradient = -0.15 - 0.7*0.005;
                }
            color = vec4(gradient + color.r, gradient + color.g, gradient + color.b, color.a);
            color.rgb *= color.a; // set background to alpha 0
            gl_FragColor = color;
        }*/
    vec4 current_color = texture2D(u_texture, v_tex_coord);

        // if it's not transparent
        if (current_color.a > 0.0) {
            // subtract its current RGB values from 1 and use its current alpha; multiply by the node alpha so we can fade in or out
            gl_FragColor = vec4(1.0 - current_color.rgb, current_color.a) * current_color.a * v_color_mix.a;
        } else {
            // use the current (transparent) color
            gl_FragColor = current_color;
        }
    
}
