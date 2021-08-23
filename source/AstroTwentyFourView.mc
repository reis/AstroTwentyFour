using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMonitor;
using Toybox.Activity as Act;
using Toybox.Application as App;
using Toybox.Time as Time;

enum {
  LAT,
  LON
}

class AstroTwentyFourView extends Ui.WatchFace {

    hidden var radius, centerX, centerY, app;

    function initialize() {
        WatchFace.initialize();
        app = App.getApp();
    }

    function onLayout(dc) {
        centerX = dc.getWidth() / 2;
        centerY = dc.getHeight() / 2;
        radius = dc.getHeight() / 2;
    }

    //! Update the view
    function onUpdate(dc) {
        clear(dc);
        radius = dc.getHeight() / 2;
        var loc = Act.getActivityInfo().currentLocation;
        var lat = app.getProperty("Latitude") * Math.PI / 180.0;
        var lon = app.getProperty("Longitude") * Math.PI / 180.0;
        var now = new Time.Moment(Time.now().value());

        if (app.getProperty("AutomaticPosition")) {
            if(loc != null) {
                lat = loc.toDegrees()[0] * Math.PI / 180.0;
                lon = loc.toDegrees()[1] * Math.PI / 180.0;
            }
        }

        //System.println(clock.timeZoneOffset);
        var time = Time.Gregorian.info(now , Time.FORMAT_SHORT);
        var sunrise = Sun.getsuntime(now, lat, lon, SUNRISE);
        var sunset = Sun.getsuntime(now, lat, lon, SUNSET);
        var dawn = Sun.getsuntime(now, lat, lon, DAWN);
        var dusk = Sun.getsuntime(now, lat, lon, DUSK);
        // Draw sun events
        if (app.getProperty("ShowSunLines")) {
            drawHand(dc, timeAngle(sunrise), app.getProperty("SunLinesColor"), 2, 0);
            drawHand(dc, timeAngle(sunset), app.getProperty("SunLinesColor"), 2, 0);
            if (app.getProperty("ShowNoonLine")) {
                var noon = Sun.getsuntime(now, lat, lon, NOON);
                drawHand(dc, timeAngle(noon), app.getProperty("SunLinesColor"), 2, 0);
                drawHand(dc, timeAngle(noon)+Math.PI, app.getProperty("SunLinesColor"), 2, 0);
        }   }
        if (app.getProperty("ShowNightLines")) {
            drawHand(dc, timeAngle(dawn), app.getProperty("NightLinesColor"), 2, 0);
            drawHand(dc, timeAngle(dusk), app.getProperty("NightLinesColor"), 2, 0);
        }
        
        drawDial(dc);
        
        // Draw hands
        if (app.getProperty("Hand24Show")) {
            drawHand(dc, timeAngle(now), app.getProperty("Hand24Color"), app.getProperty("Hand24Width"), radius*app.getProperty("Hand24Length")/10);
        }
        if (app.getProperty("ShowMinuteHand")) {
            drawHand(dc, minuteAngle(now), app.getProperty("MinuteColor"), app.getProperty("MinuteWidth"), radius*0.1);
        } 
        if (app.getProperty("Hand12Show")) {
            drawHand(dc, timeAngle12(now), app.getProperty("Hand12Color"), app.getProperty("Hand12Width"), radius*app.getProperty("Hand12Length")/10);
        }

        // Show fields
        if (app.getProperty("ShowDate")) {
            var gregorianInfo = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
            Fields.drawDay(dc, gregorianInfo);
        }
        if (app.getProperty("ShowMoon")) {
            var gregorianShort = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            var moonAge = Moon.getmoonage(gregorianShort.day.toNumber(), gregorianShort.month.toNumber(), gregorianShort.year.toNumber());
            Fields.drawMoonIcon(dc, moonAge);
            Fields.drawMoonAge(dc, moonAge);
        }
        if (app.getProperty("ShowSteps")) {
            var steps = ActMonitor.getInfo().steps;
            Fields.drawSteps(dc, steps);
        }
        if (app.getProperty("ShowBattery")) {
            var battery = (System.getSystemStats().battery + 0.5).toNumber().toString();
            Fields.drawBattery(dc, battery);
        }


        var tickest = app.getProperty("Hand12Width");
        if (tickest < app.getProperty("Hand24Width")) { tickest = app.getProperty("Hand24Width"); }
        if (tickest < app.getProperty("MinuteWidth")) { tickest = app.getProperty("MinuteWidth"); }
        dc.setColor(app.getProperty("BackgroundColor"), app.getProperty("ForegroundColor"));
        dc.setPenWidth(1);
        dc.fillCircle(centerX, centerY, tickest);
        dc.setColor(app.getProperty("ForegroundColor"), app.getProperty("ForegroundColor"));
        dc.setPenWidth(2);
        dc.drawCircle(centerX, centerY, tickest);

        return(true);

        //drawHand(dc, timeAngle(utcTime), app.getProperty("Hand24Color"), 3, 0);
        /*if (app.getProperty("ShowDualTime1")) {
            var dualTime1Offset = new Time.Duration(app.getProperty("DualTime1Offset").toNumber() * 3600 );
            drawHand(dc, timeAngle(utcTime.add(dualTime1Offset)), app.getProperty("HourColor"), 3, 0);
        }
        if (app.getProperty("ShowDualTime2")) {
            var dualTime2Offset = new Time.Duration(app.getProperty("DualTime2Offset").toNumber() * 3600);
            drawHand(dc, timeAngle(utcTime.add(dualTime2Offset)), app.getProperty("HourColor"), 3, 0);
        }*/
    }

    //! Clear the screen
    hidden function clear(dc) {
        dc.setColor(Application.getApp().getProperty("BackgroundColor"), Application.getApp().getProperty("BackgroundColor"));
        dc.clear();
    }

    //! Draw the watch dial
    hidden function drawDial(dc) {
        var oedge = radius + 1;
        var radians = Math.PI / 48.0; // * 2.0 / 96.0
        centerX = dc.getWidth() / 2;
        centerY = dc.getHeight() / 2;

        for (var i = 0, angle = 0; i < 13; i += 1) {
            var iedge, cos, sin, x1, y1, x2, y2;
            dc.setPenWidth(1);
            iedge = oedge - 2;
            dc.setColor(Application.getApp().getProperty("ForegroundColor"), Application.getApp().getProperty("BackgroundColor"));

            if (i == 0) {
                dc.setPenWidth(6);
                iedge = oedge - 25;
            } else if (i == 4 or i == 12) {
                dc.setPenWidth(3);
                iedge = oedge - 10;
            } else if (i == 8) {
                dc.setPenWidth(3);
                iedge = oedge - 20;
            } else {
                dc.setPenWidth(2);
                iedge = oedge - 5;
            }

            x1 = Math.cos(angle) * iedge;
            y1 = Math.sin(angle) * iedge;
            x2 = Math.cos(angle) * oedge;
            y2 = Math.sin(angle) * oedge;

            dc.drawLine(centerX + y1, centerY - x1, centerX + y2, centerY - x2); // 12 clockwise
            dc.drawLine(centerX + x1, centerY + y1, centerX + x2, centerY + y2); // 3 clockwise
            dc.drawLine(centerX - y1, centerY + x1, centerX - y2, centerY + x2); // 6 clockwise
            dc.drawLine(centerX - x1, centerY - y1, centerX - x2, centerY - y2); // 9 clockwise
            dc.drawLine(centerX - y1, centerY - x1, centerX - y2, centerY - x2); // 12 anticlock
            dc.drawLine(centerX - x1, centerY + y1, centerX - x2, centerY + y2); // 9 anticlock
            dc.drawLine(centerX + y1, centerY + x1, centerX + y2, centerY + x2); // 6 anticlock
            dc.drawLine(centerX + x1, centerY - y1, centerX + x2, centerY - y2); // 3 anticlock

            angle += radians;
        }
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

    hidden const MINUTES_PER_HOUR = 60.0;
    hidden const MINUTES_PER_DAY = 1440.0;

    hidden const CLOCK_OFFSET = 360.0;

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

    hidden function timeAngle12(moment) {

        var time = Time.Gregorian.info(moment , Time.FORMAT_SHORT);

        var minutes = time.min + (time.hour * MINUTES_PER_HOUR);

        // Convert to radians
        return ((minutes - 180) / MINUTES_PER_DAY) * Math.PI * 4.0;
    }

    //! Angle for the current minute.
    //! @returns time as an angle
    hidden function minuteAngle(moment) {
        var time = Time.Gregorian.info(moment , Time.FORMAT_SHORT);
        var minutes = time.min*24;
        var alpha = Math.PI/30.0*minutes;

        // Convert to radians
        //return ((minutes) / MINUTES_PER_DAY) * Math.PI * 2.0;
        return ((minutes - 360) / MINUTES_PER_DAY) * Math.PI * 2.0;
        return alpha;
    }

}