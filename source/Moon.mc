using Toybox.Math;

module Moon{
    function calcmoonphase(day, month, year) {
    //	Sys.println(day + "." + month + "." + year);  // berechnet am "4.6.2017"
    
	    var r = (year % 100); 		// 2017 modulo 100 = 17 --> 2017 / 100 = 2000 Rest 17
		r = (r % 19);  				// 17 modulo 19 = 19 --> 17 / 19 = 0 Rest 17
	    if (r>9) { 
	        r = r - 19; 			// r = -2
	        //!Sys.println("r0 = " + r);
	    }
		r = ((r * 11) % 30) + month + day;  	//= ((-2 * 11) % 30) = -22 --> -22 + 6 + 4 = -12
		//!Sys.println("r1 = " + r);
		 
	    if (month<3) {
	        r = r + 2;				//wenn Jan-Mrz : --> r = 17 +2 = 19
	    }
	    r = 1.0*r - 8.3 + 0.5;		//sonst: 1.0 * -12 = -12 -8.3 + 0,5 = -19,8
	    //!Sys.println("r2 = " + r);
	    
		r = (r.toNumber() % 30);	//-19,8 modulo 30 = 10,8
	    if (r < 0) {				
	        r = r + 30;				//wenn < 0 = r + 30
	    }
	    //!Sys.println(" r = " + r);
	    return r;					//11 (ganze Zahl)
    }

	function getmoonage(day, month, year) {
        
        var age = 0.0;
        
        var yy = 0.0;
        var mm = 0.0;
        var k1 = 0.0;
        var k2 = 0.0;
        var k3 = 0.0;
        var jd = 0.0;
        var ip = 0.0;
        
        yy = year - Math.floor((12 - month) / 10);
        mm = month + 9.0;
        if (mm >= 12) {
            mm = mm - 12;
        }
        
        k1 = Math.floor(365.25 * (yy + 4712));
        k2 = Math.floor(30.6 * mm + 0.5);
        k3 = Math.floor(Math.floor((yy / 100) + 49) * 0.75) - 38;
        
        jd = k1 + k2 + day + 59;
        if (jd > 2299160) {
            jd = jd - k3;
        }
        
        ip = normalize((jd - 2451550.1) / 29.530588853); 
        age = ip * 29.53;
        
        return age.toNumber();
    }

	function normalize(v)
	{
		v =  v - Math.floor(v);
		if(v<0) {
			v = v+1;
		}
		return(v);
	}

}