using Toybox.Graphics;
using Toybox.Math;
using Toybox.Application as App;

module Dial {

    function generateTickCoordinates(centerPoint, angle, innerRadius, outerRadius, width) {
        // Map out the coordinates of the watch face
        var coords = [[-(width / 2), -innerRadius], [-(width / 2), -outerRadius], [width / 2, -outerRadius], [width / 2, -innerRadius]];
        var result = new [4];
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        // Transform the coordinates
        for (var i = 0; i < 4; i += 1) {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
            var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;

            result[i] = [centerPoint[0] + x, centerPoint[1] + y];
        }

        return result;
    }

    // Draws the clock tick marks around the outside edges of the screen.
    function drawHashMarks(dc) {
        dc.setColor(color_list[App.getApp().getProperty("ForegroundColor")], color_list[App.getApp().getProperty("ForegroundColor")]);

        for (var i = 0; i < 12; i += 1) {
            // even hours
            dc.fillPolygon(generateTickCoordinates([centerX, centerY], i*Math.PI*2.0/12.0, hourMarker_ri, hourMarker_ro, hourMarker_t));
        }
        for (var i = 0; i < 72; i += 1) {
            if(i%6 == 0){
                //do nothing, already drew hours
            }else if(i%3 == 0){
                // odd hours
                dc.fillPolygon(generateTickCoordinates([centerX, centerY], i*Math.PI*2.0/72.0, hourOddMarker_ri, hourMarker_ro, hourMarker_t));
            }else {
                // 20 and 40 minutes
                dc.fillPolygon(generateTickCoordinates([centerX, centerY], i*Math.PI*2.0/72.0, minuteMarker_ri, minuteMarker_ro, minuteMarker_t));
            }
        }
    }
}