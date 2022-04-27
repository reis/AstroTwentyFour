using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMonitor;
using Toybox.Activity as Act;
using Toybox.Application as App;
using Toybox.Time as Time;
using Hand;
using Dial;

enum {
  LAT,
  LON
}

// define watch geometry:
var screenCenterPoint;
var hourHand_r1; 
var hourHand_r2; 
var hourHand_t; 
var minuteHand_r1; 
var minuteHand_r2; 
var minuteHand_t; 
var hour24Hand_r1; 
var hour24Hand_r2; 
var hour24Hand_t; 
var hourMarker_ri;
var hourOddMarker_ri;
var hourMarker_ro;
var hourMarker_t;
var minuteMarker_ri;
var minuteMarker_ro;
var minuteMarker_t;

var radius, centerX, centerY;
var loc, lat, lon;
var color_list;
var length_list;
var width_list;

const MINUTES_PER_HOUR = 60.0;
const MINUTES_PER_DAY = 1440.0;

class AstroTwentyFourView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        centerX = dc.getWidth() / 2;
        centerY = dc.getHeight() / 2;
        radius = dc.getHeight() / 2;

        length_list=[26, 32, 44];
        width_list=[2, 3, 5, 6, 7];

        //compute geometry
        hourHand_r1 = Math.round(24/50.0*dc.getWidth()/2);
        hourHand_r2 = Math.round(12/50.0*dc.getWidth()/2);
        hourHand_t = Math.round(5.3/50.0*dc.getWidth()/2);
        minuteHand_r1 = Math.round(44/50.0*dc.getWidth()/2);
        minuteHand_r2 = Math.round(12/50.0*dc.getWidth()/2);
        minuteHand_t = Math.round(4/50.0*dc.getWidth()/2);
        hour24Hand_r1 = Math.round(44/50.0*dc.getWidth()/2);
        hour24Hand_r2 = Math.round(12/50.0*dc.getWidth()/2);
        hour24Hand_t = Math.round(2/50.0*dc.getWidth()/2);

        hourMarker_ri = Math.round(37/50.0*dc.getWidth()/2);
        hourOddMarker_ri = Math.round(42/50.0*dc.getWidth()/2);
        hourMarker_ro = Math.round(49/50.0*dc.getWidth()/2);
        hourMarker_t = Math.round(2.5/50.0*dc.getWidth()/2);
        minuteMarker_ri = Math.round(45/50.0*dc.getWidth()/2);
        minuteMarker_ro = Math.round(49/50.0*dc.getWidth()/2);
        minuteMarker_t = Math.round(1.2/50.0*dc.getWidth()/2);

        color_list=[Gfx.COLOR_BLACK, Gfx.COLOR_WHITE,
                    Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLUE,
                    Gfx.COLOR_GREEN, Gfx.COLOR_RED,
                    Gfx.COLOR_YELLOW];
        
    }

    //! Update the view
    function onUpdate(dc) {
        clear(dc);
        var lat_r = 0.0;
        var lon_r = 0.0;
        var now = new Time.Moment(Time.now().value());

        lat = App.getApp().getProperty("Latitude").toFloat();
        lon = App.getApp().getProperty("Longitude").toFloat();

        if (lat != null) {
            lat_r = lat * Math.PI / 180.0;
        }
        if ( lon != null) {
            lon_r = lon * Math.PI / 180.0;
        }

        if (App.getApp().getProperty("AutomaticPosition")) {
            loc = Act.getActivityInfo().currentLocation;
            if(loc != null) {
                lat = loc.toDegrees()[0];
                lon = loc.toDegrees()[1];
                lat_r = lat * Math.PI / 180.0;
                lon_r = lon * Math.PI / 180.0;
            }
        }
        
        //drawDial(dc);
        Dial.drawHashMarks(dc);

        //System.println(clock.timeZoneOffset);
        var time = Time.Gregorian.info(now , Time.FORMAT_SHORT);
        var sunrise = Sun.getsuntime(now, lat_r, lon_r, SUNRISE);
        var sunset = Sun.getsuntime(now, lat_r, lon_r, SUNSET);
        var dawn = Sun.getsuntime(now, lat_r, lon_r, DAWN);
        var dusk = Sun.getsuntime(now, lat_r, lon_r, DUSK);
        var gregorianShort = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var moonAge = Moon.getmoonage(gregorianShort.day.toNumber(), gregorianShort.month.toNumber(), gregorianShort.year.toNumber());
        
        // Draw sun events
        if (App.getApp().getProperty("ShowSunLines")) {
            drawHand(dc, timeAngle(sunrise), color_list[App.getApp().getProperty("SunLinesColor")], 2, 0);
            drawHand(dc, timeAngle(sunset), color_list[App.getApp().getProperty("SunLinesColor")], 2, 0);
            if (App.getApp().getProperty("ShowNoonLine")) {
                var noon = Sun.getsuntime(now, lat_r, lon_r, NOON);
                drawHand(dc, timeAngle(noon), color_list[App.getApp().getProperty("SunLinesColor")], 2, 0);
                drawHand(dc, timeAngle(noon)+Math.PI, color_list[App.getApp().getProperty("SunLinesColor")], 2, 0);
        }   }
        if (App.getApp().getProperty("ShowNightLines")) {
            drawHand(dc, timeAngle(dawn), color_list[App.getApp().getProperty("SunLinesColor")], 2, 0);
            drawHand(dc, timeAngle(dusk), color_list[App.getApp().getProperty("SunLinesColor")], 2, 0);
        }
        

        if (App.getApp().getProperty("ShowMoon")) {
            Fields.drawMoonIcon(dc, moonAge);
        }
        
        // Draw hands

        Hand.drawHands(dc);
        
        // Show fields
        if (App.getApp().getProperty("ShowDate")) {
            var gregorianInfo = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
            Fields.drawDay(dc, gregorianInfo);
        }
        if (App.getApp().getProperty("ShowMoon")) {
            Fields.drawMoonAge(dc, moonAge);
        }
        if (App.getApp().getProperty("ShowSteps")) {
            var steps = ActMonitor.getInfo().steps;
            Fields.drawSteps(dc, steps);
        }
        if (App.getApp().getProperty("ShowBattery")) {
            var battery = (System.getSystemStats().battery + 0.5).toNumber().toString();
            Fields.drawBattery(dc, battery);
        }
        

        return(true);


    }

    //! Clear the screen
    hidden function clear(dc) {
        dc.setColor(color_list[App.getApp().getProperty("BackgroundColor")], color_list[App.getApp().getProperty("BackgroundColor")]);
        dc.clear();
    }


    //! Angle for the current time.
    //! @returns time as an angle
    hidden function timeAngle(moment) {
        //! Shift time by 6 hours so that midnight is at the bottom
        var clock_offset = 360.0;

        var time = Time.Gregorian.info(moment , Time.FORMAT_SHORT);
        var minutes = time.min + (time.hour * MINUTES_PER_HOUR);

        // Convert to radians
        return ((minutes + clock_offset) / MINUTES_PER_DAY) * Math.PI * 2.0;
    }
            //! Draw the hand
    hidden function drawHand(dc, angle, color, width, hand_inset) {
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