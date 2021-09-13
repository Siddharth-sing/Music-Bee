// Use this sample to create your own voice commands

intent('hello world', p => {
    p.play('(hello|hi there)');
});

question(
    'what this app can do?', 
    'what does this app do?',
    'what is the working of this app',
    reply('This is a radio app where you can ask me to play some music.'),
);


intent('(start|) (play|) $(CHANNEL* (.*)) (fm|)', p => {
    let channel = project.radios.filter(x => x.name.toLowerCase() === p.CHANNEL.value.toLowerCase())[0];
    try {
        p.play({ "command": "play_channel", "id": channel.id });
        p.play('(Playing Now|on it|Ok boss|Doing it)');
    } catch (err) {
        console.log("Can't play");
        p.play("I cannot play this");
    }
});


intent('play (some music|)',
       '(Alan|)  play (the|) (some|) (music|)(f m|) (radio|)',    
       'Start (the|)(some|) Raido',
        p => {
    p.play({"command":"play"});
    p.play("(Playing Now|On it|Wait I am playing)");
});


intent('play (some|) $(CATEGORY* (.*)) music', p => {
    let channel = project.radios.filter(x => x.category.toLowerCase() === p.CATEGORY.value.toLowerCase())[0];
    try {
        p.play({ 'command': 'play_channel', 'id': channel.id });
        p.play('(playing now|On it|Ok boss)');
    } catch (error) {
        console.log("Can't play");
        p.play('I could not find this genre');
    }

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

intent('(play|) next (channel|fm|radio|music|)', p => {
    p.play({ "command": "next" });
    p.play("(on it|Ok boss|Doing it|sure)");
});

intent('(play|) previous (channel|fm|radio|music|)', p => {
    p.play({ "command": "prev" });
    p.play("(on it|Ok boss|Doing it|sure)");
});
