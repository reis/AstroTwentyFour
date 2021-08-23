using Toybox.Graphics;
using Toybox.Math as Math;
using Toybox.Application;
using Toybox.Lang;
using Toybox.Time;
using Toybox.WatchUi as Ui;

module Fields {

    function drawDay(dc, gregorianInfo) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var position12 = Hands.generateHandCoordinates([width/2, height/2], Math.PI/6*(12), (width/3.3), 0, 1);
        //var position3 = Hands.generateHandCoordinates([width/2, height/2], Math.PI/6*(3), (width/3.3), 0, 1);
        //var position4 = Hands.generateHandCoordinates([width/2, height/2], Math.PI/6*(4), (width/3.3), 0, 1);
        
        //[ info.day_of_week, info.day, info.month, steps, batt ]);

        dc.setColor(Application.getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
        //dc.drawText(position3[1][0], position3[1][1], Graphics.FONT_TINY, gregorianInfo.day,
        //            Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(position12[1][0], position12[1][1], Graphics.FONT_TINY, gregorianInfo.day_of_week.substring(0,3) + " " + gregorianInfo.day + " " + gregorianInfo.month.substring(0,3),
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        //dc.drawText(position4[1][0], position4[1][1], Graphics.FONT_TINY, gregorianInfo.month.substring(0,3),
        //            Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawMoonIcon (dc, moonage) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var position3 = Hands.generateHandCoordinates([width/2, height/2], Math.PI/12*(6), (width/3.0)-30, 0, 1);

        var moon_char = {
            0 => "a",
            1 => "b",
            2 => "c",
            3 => "d",
            4 => "e",
            5 => "f",
            6 => "g",
            7 => "h",
            8 => "i",
            9 => "j",
            10 => "k",
            11 => "l",
            12 => "m",
            13 => "n",
            14 => "o",
            15 => "p",
            16 => "q",
            17 => "r",
            18 => "s",
            19 => "t",
            20 => "u",
            21 => "v",
            22 => "w",
            23 => "x",
            24 => "y",
            25 => "z",
            26 => "{",
            27 => "|",
            28 => "}",
            29 => "~"
        };

        var font = Ui.loadResource( Rez.Fonts.moon );
        dc.setColor(Application.getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
        dc.drawText(position3[1][0], position3[1][1], font, moon_char[moonage], 
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        //dc.drawText(width/2, height/2, font, (moonage/31.0*10).format("%.0f"), 
 
    }

    function drawMoonAge (dc, moonage) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var position3 = Hands.generateHandCoordinates([width/2, height/2], Math.PI/12*(6), (width/3.0)-5, 0, 1);

        //dc.setColor(Application.getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
        //dc.fillCircle(position3[1][0]-17, position3[1][1], 5);
        //dc.setColor(Application.getApp().getProperty("BackgroundColor"), Graphics.COLOR_TRANSPARENT);
        //dc.fillCircle(position3[1][0]-20, position3[1][1], 5);
        
        dc.setColor(Application.getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
        dc.drawText(position3[1][0], position3[1][1], Graphics.FONT_TINY, moonage,
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawSteps (dc, steps) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var position6 = Hands.generateHandCoordinates([width/2, height/2], Math.PI/6*(6), (width/3.3), 0, 1);

        dc.setColor(Application.getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
        dc.drawText(position6[1][0], position6[1][1], Graphics.FONT_TINY, Lang.format("$1$", [(steps).format("%.0f")]),
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawBattery (dc, battery) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var position9 = Hands.generateHandCoordinates([width/2, height/2], Math.PI/6*(9), (width/3)-10, 0, 1);

        dc.setColor(Application.getApp().getProperty("ForegroundColor"), Graphics.COLOR_TRANSPARENT);
        dc.drawText( position9[1][0], position9[1][1] , Graphics.FONT_TINY, battery+"%",
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }

}