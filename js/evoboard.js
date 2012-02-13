/*jslint devel: true, regexp: true, browser: true, unparam: true, debug: true, sloppy: true, sub: true, es5: true, vars: true, evil: true, fragment: true, white: false */
/*globals Sail, Rollcall, $, swfobject */

var passSailEventToFlash = function(sev) {
    var flashMovie = swfobject.getObjectById("evoboard");
    flashMovie.sevToFlash(sev.eventType, sev.payload || {});
};

var EvoBoard = {
    rollcallURL: '/rollcall',
    
    events: {
        sail: {
            student_submitted_data: passSailEventToFlash,
            some_other_event: passSailEventToFlash,
	    	organism_observation: passSailEventToFlash,
	    	note: passSailEventToFlash,
	    	observation_tabulation: passSailEventToFlash,
			organism_features: passSailEventToFlash,
	    	concept_discussion: passSailEventToFlash
        },
        
        initialized: function(ev) {
            Sail.app.authenticate();
        },
        
        connected: function(ev) {
            $("#evoboard").show();
            swfobject.switchOffAutoHideShow();
            swfobject.registerObject("evoboard", "9");
        },
        
        
        unauthenticated: function(ev) {
            Rollcall.Authenticator.requestRun();
        },
    },

    init: function() {
        Sail.app.rollcall = new Rollcall.Client(Sail.app.rollcallURL);

        Sail.app.run = Sail.app.run || JSON.parse($.cookie('run'));
        if (Sail.app.run) {
            Sail.app.groupchatRoom = Sail.app.run.name + '@conference.' + Sail.app.xmppDomain;
        }

        Sail.modules
        .load('Rollcall.Authenticator', {mode: 'picker', askForRun: true, curnit: 'EvoRoom3', userFilter: function(u) {return true; /*u.kind == "Student"*/}})
        .load('Strophe.AutoConnector')
        .thenRun(function () {
            Sail.autobindEvents(EvoBoard);

            $(document).ready(function() {
                $('#reload').click(function() {
                    Sail.Strophe.disconnect();
                    location.reload();
                });
            });

            $(Sail.app).trigger('initialized');
            return true;
        });
    },    

    authenticate: function() {
        Sail.app.token = Sail.app.rollcall.getCurrentToken();

        if (!Sail.app.run) {
            Rollcall.Authenticator.requestRun();
        } else if (!Sail.app.token) {
            Rollcall.Authenticator.requestLogin();
        } else {
            Sail.app.rollcall.fetchSessionForToken(Sail.app.token, 
                function(data) {
                    Sail.app.session = data.session;
                    $(Sail.app).trigger('authenticated');
                },
                function(error) {
                    console.warn("Token '"+Sail.app.token+"' is invalid. Will try to re-authenticate...");
                    Rollcall.Authenticator.unauthenticate();
                }
            );
        }
    },
};

