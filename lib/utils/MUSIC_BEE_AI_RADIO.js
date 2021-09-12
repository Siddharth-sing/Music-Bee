// Use this sample to create your own voice commands
intent('hello world', p => {
    p.play('(hello|hi there)');
});

intent('play',
       '(Alan|)  play (the|) (some|) music',    
       'Start (the|)(some|) Raido',
        p => {
    p.play({"command":"play"});
    p.play("(Playing Now|On it|Wait I am playing)");
});

intent('stop',
       '(Alan|)  stop (the|) music',    
       'stop (it|) (the|) Radio',
       'Pause (it|) (the|) (radio|) (music|)',
       'Pause (the|) music',
       'Pause (the|) radio',
       
        p => {
    p.play({"command":"stop"});
    p.play("(Stopping Now|On it|Wait I am stopping the radio)");
});

intent('(play|) next (channel|fm|radio|)', p => {
    p.play({ "command": "next" });
    p.play("(on it|Ok boss|Doing it|sure)");
});

intent('(play|) previous (channel|fm|radio|)', p => {
    p.play({ "command": "prev" });
    p.play("(on it|Ok boss|Doing it|sure)");
});
