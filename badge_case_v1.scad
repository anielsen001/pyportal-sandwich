// battery dimensions
batt_height = 52.0; 
batt_width = 58.0;  // connector is on the side this wide
batt_thick = 8.0 ; 

// overall dimensions of board
pyportal_width = 90;
pyportal_height_max = 65;
pyportal_height_min = 55; 
pyportal_board_thick = 2.0; 

// dimensions of screen
pyportal_screen_height = 55; 
pyportal_screen_width = 80; 
pyportal_screen_thick = 3.5; 
pyportal_screen_offset_x = 10; 

// location of pyportal bolt holes
pyportal_thru_offset_y = 56.5/2+(62 - 56.5)/2;
pyportal_thru_offset_x = 80.5/2+(86-80.5)/2;

// front standoff dimensions
pyportal_standoff_diameter = 5 ; 
pyportal_standoff_thru = 3.5;  // the thru holes are M2.5 size
pyportal_standoff_height = pyportal_screen_thick;

// rear standoff dimensions
pyportal_standoff_diameter = 5 ; 
pyportal_standoff_thru = 3.5;  // the thru holes are M2.5 size
pyportal_rear_standoff_height = 50;

// m2 bolt sizes - use for sandwiching assy together
// https://www.engineersedge.com/hardware/metric-external-thread-sizes1.htm
// http://www.accuratescrew.com/asm-technical-info/metric-sae-information-conversion/
// https://www.boltdepot.com/fastener-information/nuts-washers/Metric-Nut-Dimensions.aspx
m2_thread_diam = 2; // use nominal
m2_head_diam = 4; // 
m2_nut_flats = 4; 
m2_nut_height = 1.6; 

module battery(){
    cube( [ batt_width, batt_height, batt_thick ] );
}

// stand off for portal board from front panel
module portal_panel_standoff(){
    difference(){
        // outer cylinder
        $fn=100;
        cylinder( h = pyportal_standoff_height ,
                  d = pyportal_standoff_diameter
        ); 
        
        cylinder( h = pyportal_standoff_height ,
                  d = pyportal_standoff_thru
        ); 
    }; // end difference
       
}// end portal_panel_standoff

// design front panel
module front_panel(){
    front_panel_thick = 2; 
    front_panel_edge_pad = 2; 
    
    screen_overlap = 1 ; 
    
    difference(){
    // create a front panel shape
    translate([ -(pyportal_width + front_panel_edge_pad)/2,
               -(pyportal_height_max + front_panel_edge_pad)/2,
                0 ])
    cube([pyportal_width + front_panel_edge_pad,
          pyportal_height_max + front_panel_edge_pad,
          front_panel_thick]);
    // remove from front panel an opening for the screen
    translate( [ -(pyportal_screen_width - screen_overlap)/2 + pyportal_screen_offset_x/2,
                -(pyportal_screen_height - screen_overlap)/2,
                - front_panel_thick ] )
    cube( [ (pyportal_screen_width - screen_overlap), 
            pyportal_screen_height - screen_overlap,
            front_panel_thick*4  ] );
        
             
    } // end difference
     
    translate( [ pyportal_thru_offset_x , pyportal_thru_offset_y , front_panel_thick ] ){ 
    portal_panel_standoff();
    }   
    translate( [ -pyportal_thru_offset_x , pyportal_thru_offset_y , front_panel_thick ] ){ 
    portal_panel_standoff();
    }
    translate( [ pyportal_thru_offset_x , -pyportal_thru_offset_y , front_panel_thick ] ){ 
    portal_panel_standoff();
    }
    translate( [ -pyportal_thru_offset_x , -pyportal_thru_offset_y , front_panel_thick ] ){ 
    portal_panel_standoff();
    }
     
} // end module front panel

// stand off for portal board from front panel
module portal_back_panel_standoff(){
    difference(){
        // outer cylinder
        $fn=100;
        cylinder( h = pyportal_rear_standoff_height ,
                  d = pyportal_standoff_diameter
        ); 
        
        cylinder( h = pyportal_rear_standoff_height ,
                  d = pyportal_standoff_thru
        ); 
    }; // end difference
       
}// end portal_panel_standoff

module back_panel(){
    back_panel_thick = 2; 
    back_panel_edge_pad = 2; 

    difference(){
    // create a back panel shape
    translate([ -(pyportal_width + back_panel_edge_pad)/2,
               -(pyportal_height_max + back_panel_edge_pad)/2,
                pyportal_standoff_height ])
        // the height here needs to be measured to account for the back side thickness of parts
        // and the other parts to sandwich in
    cube([pyportal_width + back_panel_edge_pad,
          pyportal_height_max + back_panel_edge_pad,
          back_panel_thick]);
    } // end difference
    
    //needs standoffs
    translate( [ pyportal_thru_offset_x , pyportal_thru_offset_y , front_panel_thick ] ){ 
    portal_panel_standoff();
    }   
    translate( [ -pyportal_thru_offset_x , pyportal_thru_offset_y , front_panel_thick ] ){ 
    portal_panel_standoff();
    }
    translate( [ pyportal_thru_offset_x , -pyportal_thru_offset_y , front_panel_thick ] ){ 
    portal_panel_standoff();
    }
    translate( [ -pyportal_thru_offset_x , -pyportal_thru_offset_y , front_panel_thick ] ){ 
    portal_panel_standoff();
    }   
 
            
}
// place battery
translate( [ -pyportal_width/2.0, -batt_height/2.0, pyportal_standoff_height+ pyportal_screen_thick ] ) 
color("green") 
battery(); 

// place front panel
color("red") front_panel();

// place rear panel 
translate([0,0, pyportal_screen_thick + batt_thick] ) 
back_panel(); 
       
