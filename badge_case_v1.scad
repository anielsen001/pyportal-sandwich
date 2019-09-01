// battery dimensions
batt_height = 52.0; 
batt_width = 58.0;  // connector is on the side this wide
batt_thick = 8.0 ; 
batt_circuit_width = 8; 

// overall dimensions of pyportal board
pyportal_width = 90;
pyportal_height_max = 65;
pyportal_height_min = 55; 
pyportal_board_thick = 2.0; 
pyportal_component_thick = 8.5 - pyportal_board_thick - pyportal_screen_thick;

// dimensions of screen
// screen width and height are not the visible portions, they are the entire
// board.
pyportal_screen_height = 55; 
pyportal_screen_width = 80; 
pyportal_screen_thick = 3.5; 
pyportal_screen_offset_x = 10; 

// board + screen + components (except J-connectors) is 8.5 mm
// board + screen is 5.34 mm
pyportal_component_thick = 8.5 - 5.34;

// location of pyportal bolt holes
pyportal_thru_offset_y2 = 56.5/2+(62 - 56.5)/2;
pyportal_thru_offset_x2 = 80.5/2+(86-80.5)/2;

pyportal_thru_offset_y = ( 56.5/2+ 62/2 ) / 2;
pyportal_thru_offset_x = ( 80.5/2+ 86/2 ) /2;


// adafruit 1000C charger board dimensions
chg_board_thick = 2.0 ; 
chg_board_width = 22; 
chg_board_height = 36.1; 
chg_component_thick = 7.5 - chg_board_thick; 
chg_board_standoff_height = 2.0; // some minimum to allow for solder flow on bottom 
chg_board_thru_hole_od = 2.5 ; 
chg_board_usbside_thru_offset = ( 15.35/2.0 + 20.25/2.0 )/ 2.0 ; 
chg_board_usbside_edgesep_center = 1.38 + chg_board_thru_hole_od / 2.0;
chg_board_farside_thru_offset = ( 10.4/2 + 15.42/2 ) / 2.0;
chg_board_farside_edgesep_center = 1.02 + chg_board_thru_hole_od / 2.0; 

// front standoff dimensions
pyportal_standoff_diameter = 7; 
pyportal_standoff_thru = 2.5;  // the thru holes are M2.5 size
pyportal_standoff_height = pyportal_screen_thick;

// rear standoff dimensions ; 
pyportal_rear_standoff_height = batt_thick + pyportal_component_thick;

// m2 bolt sizes - use for sandwiching assy together
// https://www.engineersedge.com/hardware/metric-external-thread-sizes1.htm
// http://www.accuratescrew.com/asm-technical-info/metric-sae-information-conversion/
// https://www.boltdepot.com/fastener-information/nuts-washers/Metric-Nut-Dimensions.aspx
m2_thread_diam = 2; // use nominal
m2_head_diam = 5; // 
m2_head_height = 1.6; 
m2_nut_flats = 6; 
m2_nut_height = 1.6; 

giant_distance = 1000; 

// create a hole for an m2 hex nut
module m2_hex_hole() {
    $fn=6; 
    cylinder( r = m2_nut_flats/2.0, h = m2_nut_height ); 
}

// create a cylindrical shell
module cylinder_shell( or, ir, h ){
    difference(){
        cylinder( r = or, h = h );
        cylinder( r = ir, h = h );
    }
}

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
    
    screen_overlap = 2 ; 
    
    // this difference will clear out space for the pyportal board/screen
    difference (){
    
    // this union adds all the front panel parts that are needed
    union(){

    difference(){
    // create a front panel shape
    translate([ -(pyportal_width + front_panel_edge_pad)/2,
               -(pyportal_height_max + front_panel_edge_pad)/2,
                0 ])
    cube([pyportal_width + front_panel_edge_pad,
          pyportal_height_max + front_panel_edge_pad,
          front_panel_thick]);
    // remove from front panel an opening for the screen
    translate( [ -(pyportal_screen_width - screen_overlap)/2 + pyportal_screen_offset_x/2 ,
                -(pyportal_screen_height - screen_overlap)/2,
                - front_panel_thick ] )
    cube( [ (pyportal_screen_width - screen_overlap) - 6, 
            pyportal_screen_height - screen_overlap,
            front_panel_thick*4  ] );
        
     // add space for bolt head to be recessed
    translate( [ pyportal_thru_offset_x , pyportal_thru_offset_y , 0 ] )
    cylinder( $fn=100, r = m2_head_diam/2, h = m2_head_height);   
    translate( [ -pyportal_thru_offset_x , pyportal_thru_offset_y , 0 ] )
    cylinder( $fn=100, r = m2_head_diam/2, h = m2_head_height);       
    translate( [ pyportal_thru_offset_x , -pyportal_thru_offset_y , 0 ] )
    cylinder( $fn=100, r = m2_head_diam/2, h = m2_head_height);           
    translate( [ -pyportal_thru_offset_x , -pyportal_thru_offset_y , 0 ] )
    cylinder( $fn=100, r = m2_head_diam/2, h = m2_head_height);   
        
         // add thru holes for standoffs
   translate( [ pyportal_thru_offset_x , pyportal_thru_offset_y , front_panel_thick ] )
    cylinder( $fn=100, r = 2.5/2, h = giant_distance, center = true );   
   
        translate( [ -pyportal_thru_offset_x , pyportal_thru_offset_y , front_panel_thick ] ) 
    cylinder( $fn=100, r = 2.5/2, h = giant_distance, center = true );
    
    translate( [ pyportal_thru_offset_x , -pyportal_thru_offset_y , front_panel_thick ] )   cylinder( $fn=100, r = 2.5/2, h = giant_distance, center = true );
   
   translate( [ -pyportal_thru_offset_x , -pyportal_thru_offset_y , front_panel_thick ] ) 
    cylinder( $fn=100, r = 2.5/2, h = giant_distance, center = true );
           
             
         } // end difference
    
        // add standoffs 
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
    
    
    
    }// end union
translate( [-(pyportal_screen_width )/2 + pyportal_screen_offset_x/2,
                -(pyportal_screen_height )/2,
                 front_panel_thick ] )
     cube(  [pyportal_screen_width, pyportal_height_min + 0.5, giant_distance ] );
    
} // end difference to clearout for pyportal board
/*translate( [-(pyportal_screen_width )/2 + pyportal_screen_offset_x/2,
                -(pyportal_screen_height )/2,
                 pyportal_screen_thick - pyportal_board_thick] )
     cube(  [pyportal_screen_width, pyportal_height_min, pyportal_standoff_height*2 ] );*/
     
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
        
    union() {
    // create a back panel shape
    translate([ -(pyportal_width + back_panel_edge_pad)/2,
               -(pyportal_height_max + back_panel_edge_pad)/2,
                batt_thick + pyportal_component_thick ])
        // the height here needs to be measured to account for the back side thickness of parts
        // and the other parts to sandwich in
    cube([pyportal_width + back_panel_edge_pad,
          pyportal_height_max + back_panel_edge_pad,
          back_panel_thick]);
        
      // add lanyard attachments
     lanyard_or = 10;
     lanyard_ir = 7;
     $fn=6; 
     translate( [  (pyportal_width + back_panel_edge_pad)/2-lanyard_or ,
               (pyportal_height_max + back_panel_edge_pad)/2,
                batt_thick + pyportal_component_thick ] ) 
     cylinder_shell( or = lanyard_or, ir = lanyard_ir, h = back_panel_thick ); 
              
     translate( [  -(pyportal_width + back_panel_edge_pad)/2 +lanyard_or,
               (pyportal_height_max + back_panel_edge_pad)/2,
                batt_thick + pyportal_component_thick ] ) 
     cylinder_shell( or = lanyard_or, ir = lanyard_ir, h = back_panel_thick );       

     } // end union    
        
     // remove material to hold m2 hex nuts
    translate( [ pyportal_thru_offset_x , pyportal_thru_offset_y , back_panel_thick -m2_nut_height +.01+ pyportal_rear_standoff_height ] ) color("green") m2_hex_hole();  
    translate( [ -pyportal_thru_offset_x , pyportal_thru_offset_y , back_panel_thick -m2_nut_height + 0.01+ pyportal_rear_standoff_height ] ) color("green") m2_hex_hole();  
    translate( [ pyportal_thru_offset_x , -pyportal_thru_offset_y , back_panel_thick -m2_nut_height+ pyportal_rear_standoff_height ] ) color("green") m2_hex_hole();           
     translate( [ -pyportal_thru_offset_x , -pyportal_thru_offset_y , back_panel_thick -m2_nut_height+ pyportal_rear_standoff_height ] ) color("green") m2_hex_hole();    
  
    // remove material for m2 thru holes
    translate( [pyportal_thru_offset_x , pyportal_thru_offset_y , back_panel_thick -m2_nut_height+ pyportal_rear_standoff_height ] )
    cylinder( $fn=100, r = 2.5/2, h = giant_distance, center = true);  
      translate( [-pyportal_thru_offset_x , pyportal_thru_offset_y , back_panel_thick -m2_nut_height+ pyportal_rear_standoff_height ] )
    cylinder( $fn=100, r = 2.5/2, h = giant_distance, center = true);          
     translate( [pyportal_thru_offset_x , -pyportal_thru_offset_y , back_panel_thick -m2_nut_height+ pyportal_rear_standoff_height ] )
    cylinder( $fn=100, r = 2.5/2, h = giant_distance, center = true);     
    translate( [-pyportal_thru_offset_x , -pyportal_thru_offset_y , back_panel_thick -m2_nut_height+ pyportal_rear_standoff_height ] )
    cylinder( $fn=100, r = 2.5/2, h = giant_distance, center = true);      
    } // end difference
    
    //needs standoffs for pyportal board
    translate( [ pyportal_thru_offset_x , pyportal_thru_offset_y , 0] ){ 
    portal_back_panel_standoff();
    }   
    translate( [ -pyportal_thru_offset_x , pyportal_thru_offset_y , 0 ] ){ 
    portal_back_panel_standoff();
    }
    translate( [ pyportal_thru_offset_x , -pyportal_thru_offset_y , 0 ] ){ 
    portal_back_panel_standoff();
    }
    translate( [ -pyportal_thru_offset_x , -pyportal_thru_offset_y , 0 ] ){ 
    portal_back_panel_standoff();
    }   
    
    // create a slot to hold the battery
    batt_slot_wall_thick = 1; 
    translate( [ -( pyportal_width)/2.0 -batt_slot_wall_thick, 
                -(batt_height + batt_slot_wall_thick*2)/2.0,
                 batt_thick/2.0] ) 
    difference() {
        cube( [ batt_width - batt_circuit_width + batt_slot_wall_thick, 
                batt_height + batt_slot_wall_thick*2, 
                batt_thick ] );
        translate( [ batt_slot_wall_thick, batt_slot_wall_thick, 0] )
        cube( [ batt_width , batt_height , batt_thick ] );
    }
    
    module chg_bd_screw_mnt(){
        // this is a screw hole type mount
              cylinder_shell( or = chg_board_thru_hole_od/2 + 1, 
                        ir = 2.5/2, 
                        h = chg_board_standoff_height );        
    }
    
   module chg_bd_peg_mnt(){
        // this is a screw hole type mount
              cylinder( r = chg_board_thru_hole_od/2 - 0.25 , 
                        h = chg_board_standoff_height*2 );        
    }
    
    module chg_bd_mnt(){
        // this module is replicated many times, so make changes here 
        // so that changes are made in one place
        chg_bd_peg_mnt(); 
    }
    
    // add standoffs to hold the charging circuit board
    //
    // after building, translate on to the panel in the correct spot
    //translate([pyportal_width/2 - (pyportal_width/2-batt_width/2+batt_slot_wall_thick) -batt_circuit_width,
    //          pyportal_height_max/2 - ( pyportal_height_max/2 - chg_board_width/2),
    //          pyportal_rear_standoff_height - back_panel_thick/2 - chg_board_standoff_height ]){   
    translate([pyportal_width/2 - (pyportal_width/2-batt_width/2+batt_slot_wall_thick) -batt_circuit_width,
              -chg_board_width/2,
              pyportal_rear_standoff_height - back_panel_thick/2 - chg_board_standoff_height ]){
        $fn=100;
        /*   // these pegs are not necessary      
        translate( [ -chg_board_farside_thru_offset, chg_board_height/2 - 3, 0 ] )
                chg_bd_mnt();
        translate( [  chg_board_farside_thru_offset, chg_board_height/2 - 3, 0 ] )
                chg_bd_mnt();
        */         
        translate( [ -chg_board_usbside_thru_offset, -chg_board_height/2 - 1, 0 ] )
                chg_bd_mnt();     
        translate( [ chg_board_usbside_thru_offset,  -chg_board_height/2 - 1, 0 ] )
                chg_bd_mnt();
   
              }
     // end charging board stand offs
       

  

 
}
// place battery
//translate( [ -pyportal_width/2.0, -batt_height/2.0,  pyportal_screen_thick + pyportal_component_thick] ) color("green") battery(); 
/*
// place front panel
translate( [0,0,-pyportal_standoff_height])color("red") front_panel();
*/

// place rear panel 
translate([0,0, pyportal_screen_thick ] ) 
back_panel(); 

       
