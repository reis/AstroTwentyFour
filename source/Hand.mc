using Toybox.Math;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Application as App;
using Toybox.Time as Time;

module Hand {
    function getHour12Angle() {
        var clockTime = System.getClockTime();
        var hourHandAngle;
        hourHandAngle = (((clockTime.hour % 12) * 60) + clockTime.min);
        hourHandAngle = hourHandAngle / (12 * 60.0);
        // degrees to radians:
        hourHandAngle = hourHandAngle * Math.PI * 2;
        return(hourHandAngle);
    }

    function getHour24Angle() {
        var clockTime = System.getClockTime();
        var hourHandAngle;
        hourHandAngle = ((((clockTime.hour+12) % 24) * 60) + clockTime.min);
        hourHandAngle = hourHandAngle / (24 * 60.0);
        // degrees to radians:
        hourHandAngle = (hourHandAngle) * Math.PI * 2;
        return(hourHandAngle);
    }

    function getMinuteAngle() {
        var clockTime = System.getClockTime();
        var minuteHandAngle = (clockTime.min / 60.0);
        // degrees to radians:
        minuteHandAngle = minuteHandAngle * Math.PI * 2;
        return(minuteHandAngle);
    }

    // This function is used to generate the coordinates of the 4 corners of the polygon
    // used to draw a watch hand. The coordinates are generated with specified length,
    // tail length, and width and rotated around the center point at the provided angle.
    // 0 degrees is at the 12 o'clock position, and increases in the clockwise direction.
    // from "analog" example
    function generateHandCoordinates(centerPoint, angle, handLength, tailLength, width) {
        // Map out the coordinates of the watch hand
        var coords = [[-(width / 2), tailLength], [-Math.round(0.8*width / 2), -handLength], [Math.round(0.8*width / 2), -handLength], [width / 2, tailLength]];
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

    function drawHandRailway(dc, angle, color, r1, r2, t) {
        dc.setColor(color_list[App.getApp().getProperty("ForegroundColor")], color_list[App.getApp().getProperty("ForegroundColor")]);
        dc.fillPolygon(generateHandCoordinates([centerX+1, centerY+1], angle, r1, r2, t+1));
        dc.setColor(color_list[App.getApp().getProperty("BackgroundColor")], color_list[App.getApp().getProperty("BackgroundColor")]);
        dc.fillPolygon(generateHandCoordinates([centerX, centerY], angle, r1, r2, t+2));
        dc.setColor(color, color);
        dc.fillPolygon(generateHandCoordinates([centerX, centerY], angle, r1, r2, t));
        
    }

    function drawHands(dc) {
        if (App.getApp().getProperty("CustomHandSize") ==  false) {
            if (App.getApp().getProperty("ShowMinuteHand")) {
                //drawHand(dc, minuteAngle(now), App.getApp().getProperty("MinuteColor"), App.getApp().getProperty("MinuteWidth"), radius*0.1);
                drawHandRailway(dc, getMinuteAngle(), color_list[App.getApp().getProperty("MinuteColor")], minuteHand_r1, minuteHand_r2, minuteHand_t);

                if (App.getApp().getProperty("Hand24Show") and App.getApp().getProperty("Hand12Show")) {
                    drawHandRailway(dc, getHour12Angle(), color_list[App.getApp().getProperty("Hand12Color")], hourHand_r1, hourHand_r2, hourHand_t);
                    drawHandRailway(dc, getHour24Angle(), color_list[App.getApp().getProperty("Hand24Color")], hour24Hand_r1, hour24Hand_r2, hour24Hand_t);
                } else if (App.getApp().getProperty("Hand24Show")){
                    if (App.getApp().getProperty("Hand24Needle")){
                        //drawHandLine(dc, timeAngle(Time.now()), color_list[App.getApp().getProperty("Hand24Color")], 2, 0);
                        drawHandRailway(dc, getHour24Angle(), color_list[App.getApp().getProperty("Hand24Color")], hour24Hand_r1, hour24Hand_r2, 1/50.0*dc.getWidth()/2);
                    }
                    drawHandRailway(dc, getHour24Angle(), color_list[App.getApp().getProperty("Hand24Color")], hourHand_r1, hourHand_r2, hourHand_t);
                } else if (App.getApp().getProperty("Hand12Show")){
                    drawHandRailway(dc, getHour12Angle(), color_list[App.getApp().getProperty("Hand12Color")], hourHand_r1, hourHand_r2, hourHand_t);
                }
            } else {
                if (App.getApp().getProperty("Hand24Show")) {
                    if (App.getApp().getProperty("Hand24Needle")){
                        drawHandRailway(dc, getHour24Angle(), color_list[App.getApp().getProperty("Hand24Color")], hour24Hand_r1, hour24Hand_r2, 1/50.0*dc.getWidth()/2);
                        drawHandRailway(dc, getHour24Angle(), color_list[App.getApp().getProperty("Hand24Color")], hourHand_r1, hourHand_r2, hourHand_t);
                    } else {
                        drawHandRailway(dc, getHour24Angle(), color_list[App.getApp().getProperty("Hand24Color")], minuteHand_r1, minuteHand_r2, minuteHand_t);
                    }
                }
                if (App.getApp().getProperty("Hand12Show")) {
                    drawHandRailway(dc, getHour12Angle(), color_list[App.getApp().getProperty("Hand12Color")], minuteHand_r1, minuteHand_r2, minuteHand_t);
                }
            }
        } else {
            hourHand_r1 = Math.round(length_list[App.getApp().getProperty("Hand12Length")]/50.0*dc.getWidth()/2);
            hourHand_t = Math.round(width_list[App.getApp().getProperty("Hand12Width")]/50.0*dc.getWidth()/2);
            minuteHand_r1 = Math.round(length_list[App.getApp().getProperty("HandMinuteLength")]/50.0*dc.getWidth()/2);
            minuteHand_t = Math.round(width_list[App.getApp().getProperty("HandMinuteWidth")]/50.0*dc.getWidth()/2);
            hour24Hand_r1 = Math.round(length_list[App.getApp().getProperty("Hand24Length")]/50.0*dc.getWidth()/2);
            hour24Hand_t = Math.round(width_list[App.getApp().getProperty("Hand24Width")]/50.0*dc.getWidth()/2);
         
            if (App.getApp().getProperty("Hand12Show")) {
                drawHandRailway(dc, getHour12Angle(), color_list[App.getApp().getProperty("Hand12Color")], hourHand_r1, hourHand_r2, hourHand_t);
            }
            if (App.getApp().getProperty("ShowMinuteHand")) {
                drawHandRailway(dc, getMinuteAngle(), color_list[App.getApp().getProperty("MinuteColor")], minuteHand_r1, minuteHand_r2, minuteHand_t);
            }
            if (App.getApp().getProperty("Hand24Show")) {
                if (App.getApp().getProperty("Hand24Needle")){
                    drawHandRailway(dc, getHour24Angle(), color_list[App.getApp().getProperty("Hand24Color")], Math.round(44/50.0*dc.getWidth()/2), hour24Hand_r2, Math.round(1/50.0*dc.getWidth()/2));
                }
                drawHandRailway(dc, getHour24Angle(), color_list[App.getApp().getProperty("Hand24Color")], hour24Hand_r1, hour24Hand_r2, hour24Hand_t);
            }
            
        }
        dc.setColor(color_list[App.getApp().getProperty("BackgroundColor")], color_list[App.getApp().getProperty("ForegroundColor")]);
        dc.fillCircle(centerX, centerY, Math.round(width_list[1]));
    }

    function timeAngle(moment) {
        //! Shift time by 6 hours so that midnight is at the bottom
        var clock_offset = 360.0;

        var time = Time.Gregorian.info(moment , Time.FORMAT_SHORT);
        var minutes = time.min + (time.hour * MINUTES_PER_HOUR);

        // Convert to radians
        return ((minutes + clock_offset) / MINUTES_PER_DAY) * Math.PI * 2.0;
    }

    //! Draw the hand
    function drawHandLine(dc, angle, color, width, hand_inset) {
        var length = radius - hand_inset;
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        var pointX = centerX + (cos * length);
        var pointY = centerY + (sin * length);

        dc.setColor(color, color);
        dc.setPenWidth(width);
        dc.drawLine(
            centerX, centerY,
            pointX, pointY
        );
    }

}