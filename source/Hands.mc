using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Math as Math;
using Toybox.System as Sys;

module Hands{

	function generateHandCoordinates(centerPoint, angle, handLength, tailLength,
                                    width) {
        // Map out the coordinates of the watch hand
        var coords = [
            [ -(width / 2), tailLength ], [ -(width / 2), -handLength ],
            [ width / 2, -handLength ], [ width / 2, tailLength ]
            ];
        var result = new[4];
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        // Transform the coordinates
        for (var i = 0; i < 4; i += 1) {
        var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
        var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;

        result[i] = [ centerPoint[0] + x, centerPoint[1] + y ];
        }

        return result;
    }

  function drawHands(dc) { 
      	var center_x;
   		var center_y;
   		var width = dc.getWidth();
        var height  = dc.getHeight();
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
   		        
    	var clockTime;
    	var screenShape = 1;
           
   		var minute_radius = 0;
    	var hour_radius; 
    	       
		minute_radius = 0.9 * center_x;
        hour_radius = 0.6* center_x;
  				
		var color = (App.getApp().getProperty("HandsColor"));
		var outlineColor = (App.getApp().getProperty("HandsOutlineColor"));
		var x, n;
		var maxRad;
		var alpha, alpha2; 
		var r0, r1, r2, r3, r4, r5, r6, r7, hand, hand1;
		var deflec1, deflec2, deflec3;
		
		clockTime = Sys.getClockTime();

		alpha = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
		alpha2 = Math.PI/6*(1.0*clockTime.hour-3+clockTime.min/60.0);
		maxRad = hour_radius;	 													
		deflec1 = 0.4;
		deflec2 = 0.04;	//Tip			
		
		for (x=0; x<2; x++) {
			hand =        	[[center_x-20*Math.sin(alpha-deflec1),center_y+20*Math.cos(alpha-deflec1)],
							[center_x-20*Math.sin(alpha+deflec1),center_y+20*Math.cos(alpha+deflec1)],
							[center_x+maxRad*Math.sin(alpha-deflec2),center_y-maxRad*Math.cos(alpha-deflec2)],
							[center_x+maxRad*Math.sin(alpha+deflec2),center_y-maxRad*Math.cos(alpha+deflec2)] ];
							
			dc.setColor(color, Gfx.COLOR_TRANSPARENT);	
			dc.fillPolygon(hand);
									
			dc.setColor(outlineColor, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);
			for (n=0; n<3; n++) {
				dc.drawLine(hand[n][0], hand[n][1], hand[n+1][0], hand[n+1][1]);
			}
			dc.drawLine(hand[n][0], hand[n][1], hand[0][0], hand[0][1]);		
			
			//! minutes--------------
			alpha = Math.PI/30.0*clockTime.min;
			alpha2 = Math.PI/30.0*(clockTime.min-15);
			maxRad = minute_radius;			
			deflec1 = 0.2;
			deflec2 = 0.025;	//Tip
		}

		dc.setColor((App.getApp().getProperty("HandsColor")), Gfx.COLOR_TRANSPARENT);

        dc.fillCircle(width / 2, height / 2, 5);
        dc.setPenWidth(2);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(width / 2, height / 2 , 5);
  }
  
	



}