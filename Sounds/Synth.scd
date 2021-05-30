s.quit;
s.options.memSize = 65536;
s.boot();
// Sounds

// Additive synthesis with random frequencies (environmental -horror effect)
(
SynthDef.new(\yaw, {
	// control vol, fund, pan, speed, direction
	arg outBus = 0, effectBus, vol = 0.1, fund = 800, duration = 2, pan = 0, speed = 0.5, direction = 1;
	// evaluate the function nOsc times
    var nOsc = 6, out;
	out = Mix.fill(
        nOsc,
        {
			SinOsc.ar([fund, 67.rrand(1000)], 0, nOsc.reciprocal * 0.1);
        }
    )*EnvGen.kr(Env.perc(duration / 2, duration), LFSaw.kr(speed));

	// Output
	Out.ar(outBus, Pan2.ar(vol * out * direction, pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(vol * out * (1 -direction), pan));
}
).send(s);
);
// test sound
//s = Synth(\yaw, [\effectBus, 1, \pan, 1, \duration, 1, \vol, 0.1]);
//s.set(\speed, 0.3);
//s.set(\duration, 3);
//s.set(\fund, 100);
//s.set(\pan, 0.3);

(
SynthDef.new(\tone, {
	arg freq = 400, outBus = 0, effectBus, pan = 0, vol= 0.1, duration = 0.5, vol1 = 0.5, vol2 = 0.3, vol3 = 0.2, speed = 0.4, direction = 1;
	var osc1, osc2, osc3, env, out;

	env = EnvGen.kr(Env.new([0, duration,0],[0.1, duration], [1,-1]), LFSaw.kr(speed));

	osc1 = LFTri.ar(freq, mul:vol1*vol*pow(duration, -1));
	osc2 = LFPar.ar(freq*2, mul:vol2*vol*pow(duration, -1));
	osc3 = SinOsc.ar(freq*3, mul:vol3*vol*pow(duration, -1));

	out = (osc1 + osc2 + osc3)*env;

	// Output
	Out.ar(outBus, Pan2.ar(out*direction, pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(out*(1-direction)), pan);
}
).send(s);
);

// test sound
//s = Synth(\tone, [\effectBus, 1, \pan, 0.5, \vol, 0.1, \speed, 2]);
// s.set(\speed, 1);
// s.set(\duration, 0.3);
// s.set(\vol1, 3, \vol2, 2, \vol3, 1.6);
//s.set(\note, 17);
//s.set(\freq, 60);
// s.free();


(
SynthDef.new(\water,{
	// we want to control vol, fund, speed, pan, direction
	arg outBus = 0, effectBus, direction = 1, fund = 800, speed = 80, pan = 0, vol = 0.1;
	var trigs, freq, osc1, osc2, out;

		trigs = Dust.kr(speed);
		freq =
			// Generally choose from a varied base freq
			TExpRand.kr(fund, fund + 700, trigs)
			// Wobbly variation
			+ LFNoise2.kr(20, mul: 300)
			// General tendency for upward rise
			+ EnvGen.kr(Env.perc(1).range(0,17), trigs);

	osc1 = SinOsc.ar(freq, 0, mul:vol);
	osc2 = SinOsc.ar(freq/2, 0, mul:vol/2);
	out = osc1 + osc2 + PinkNoise.ar(mul:vol*0.05);

	// Output
	Out.ar(outBus, Pan2.ar(out*direction, pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(out*(1-direction), pan));
}
).send(s);
);

(
SynthDef.new(\organo, {
	// vol, freq, pan, direction, dur
	arg outBus = 0, effectBus, direction = 0.5, pan= 0, freq= 400, vol= 1, dur = 5, t_gate = 1;
	var amps= [1, 0.5, 0.4, 0.3, 0.2, 0.1];
	var dets= [0, 1, 0, 1.7, 0, 0];    // Detune
	// Mix.fill(n,function) n= size of array to create, function: array filling function
	var src= Mix.fill(6, {
		arg i;
		var env = EnvGen.ar(Env.asr(attackTime:1, sustainLevel: dur, releaseTime: dur/2),t_gate);
		LFTri.ar(freq*i/4 + dets[i], 0, vol*env*amps[i]);
	});

	// Output
	Out.ar(outBus, Pan2.ar(src*direction, pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(src*(1-direction), pan));

}).send(s);
);

(
SynthDef.new(\blipblop, {
	arg outBus = 0, effectBus, direction = 1, period = 0.05, mille = 100, pan = 0, vol = 0.1;
	// we control period and mille
	var change, rate, sig, carrierFreq, cfRamp, carrierLvl, clRamp,
	modulatorRatio, mrRamp, modulatorIndex, miRamp, outputAmplitude, oaRamp;

	period = period * 600 + 100;

	// Calculation of a recursive working metronome (Impulse.kr) that generates its
	// changing frequency out of its own impulses.
	change = Impulse.kr(LocalIn.kr(1,10));
	rate = CoinGate.kr(1/3, change);
	rate = (TChoose.kr(rate, period/((0..1) + 1))/1000).reciprocal;
	LocalOut.kr(rate);

	# carrierFreq, cfRamp = TIRand.kr(0, [mille, 1], change);
	carrierFreq = Ramp.kr( carrierFreq / mille, (cfRamp * period) / mille ) * 0.6;

	# carrierLvl, clRamp = TIRand.kr(0, [9000, 1], CoinGate.kr(1/3, change));
	carrierLvl = Ramp.kr( carrierLvl, (clRamp * period) / 1000) + 100;

	# modulatorRatio, mrRamp = TIRand.kr([800,1], CoinGate.kr(1/4, change));
	modulatorRatio = Ramp.kr(modulatorRatio, (mrRamp * period) / 1000) + 20;

	# modulatorIndex, miRamp = TIRand.kr(0, [100, 1], CoinGate.kr(1/4, change));
	modulatorIndex = Ramp.kr(modulatorIndex / 200, (miRamp * period) / 1000) + 0.2;

	# outputAmplitude, oaRamp = TIRand.kr(0!2, 1!2, CoinGate.kr(1/2, change));
	outputAmplitude = Ramp.kr(outputAmplitude, (oaRamp * period + 3) / 1000);

	// jointed FM Synthesizer
	sig = LFSaw.ar(carrierFreq, 1, 0.5, 0.5) * carrierLvl;
	sig = sig + SinOsc.ar(carrierFreq * modulatorRatio) * modulatorIndex;
	sig = cos(sig * 2pi) * outputAmplitude;

	// One pole filters:
	sig = OnePole.ar(sig, exp(-2pi * (10000 * SampleDur.ir)));
	sig = OnePole.ar(sig, exp(-2pi * (10000 * SampleDur.ir)));
	sig = (sig - OnePole.ar(sig, exp(-2pi * (100 * SampleDur.ir))));
	sig = (sig - OnePole.ar(sig, exp(-2pi * (100 * SampleDur.ir))));
	sig = sig!2 * 0.06;

	Out.ar(outBus, Pan2.ar(sig*direction * vol, pos:pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(sig*(1-direction) * vol, pos:pan));
}
).send(s);
);


//

// Effects

(
SynthDef(\reverb,{
	// control: delay, decay
	arg outBus = 0, inBus, delay = 0.04, decay = 3;
	var input;

	input = In.ar(inBus, 1);
	16.do({input = AllpassC.ar(in:input, maxdelaytime:2, delaytime:{Rand(0.001,delay)}.dup, decaytime:decay)});

	// Reverb
	Out.ar(outBus, input);


}).send(s);
);


// Connecting


(
NetAddr("127.0.0.1",57120);

// Bus that connects all the sounds to Reverb effect
~myBus = Bus.audio(s,1);

// direction direzione dai Synth sounds all'output senza effetti

//Effects
~myReverb = Synth.new(\reverb, [\inBus, ~myBus]);
//~myFlanger = Synth.new(\flanger, [\inBus, ~myBus]); stand-by

//Yaw
~yaw = Synth.before(~myReverb, \yaw, [\effectBus, ~myBus, \direction, 1]);

//Water
~water = Synth.before(~myReverb, \water, [\effectBus, ~myBus, \direction, 1]);
//~water.set(\pan, 0, \vol, 0.05, \direction, 1);
//~water.set(\speed, 100);
//~water.free;

//Tone
~tone = Synth.before(~myReverb, \tone, [\effectBus, ~myBus, \direction, 1]);


//Organo
~organo = Synth.before(~myReverb, \organo, [\effectBus, ~myBus, \direction, 1, \t_gate, 1]);


//BlipBlop
~blipblop = Synth.before(~myReverb, \blipblop, [\effectBus, ~myBus, \direction, 1]);
//~blipblop.set(\vol, 0.5, \pan, 0);
//~blipblop.set(\mille, 20000);


OSCdef('OSCreciver',
	{
		arg msg;
		var rdelay, rdecay, yvol, yfund, yspeed, ypan, ydir, tvol, tfreq, tspeed, tpan, tdir, tvol1, tvol2, tvol3, wvol, wfund, wspeed, wpan, wdir, ovol, opan, odur, odir, bvol, bperiod, bmille, bdir;
		// msg 1-2 Reverb
		rdelay = msg[1];
		rdecay = msg[2];
		~myReverb.set(\delay, rdelay, \decay, rdecay);

		// msg 3-7 (5) Yaw
		if(msg[26], {yvol = msg[3]}, {yvol = 0});
		yfund = msg[4];
		yspeed = msg[5];
		ypan = msg[6];
		ydir = msg[7];
		~yaw.set(\vol, yvol, \fund, yfund, \speed, yspeed, \pan, ypan, \direction, ydir);

		// msg 8-12 (5) Tone
		if(msg[27], {tvol = msg[8]}, {tvol = 0});
		tfreq = msg[9];
		tspeed = msg[10];
		tvol1 = msg[11];
		tvol2 = msg[12];
		tvol3 = msg[31];
		~tone.set(\vol, tvol, \freq, tfreq, \speed, tspeed, \vol1, tvol1, \vol2, tvol2, \vol3, tvol3);

		// msg 13-17 (5) Water
		if(msg[28], {wvol = msg[13]}, {wvol = 0});
		wfund = msg[14];
		wspeed = msg[15];
		wpan = msg[16];
		wdir = msg[17];
		~water.set(\vol, wvol, \fund, wfund, \speed, wspeed, \pan, wpan, \direction, wdir);

		// msg 18-21 (4) Organo
		if(msg[29], {ovol = msg[18]}, {ovol = 0});
		odur = msg[19];
		opan = msg[20];
		odir = msg[21];
		~organo.set(\vol, ovol, \dur, odur, \pan, opan, \direction, odir);

		// msg 22-25 (4) BlipBlop
		if(msg[30], {bvol = msg[22]}, {bvol = 0});
		bperiod = msg[23];
		bmille = msg[24];
		bdir = msg[25];
		~blipblop.set(\vol, bvol, \period, bperiod, \mille, bmille, \direction, bdir);


	},
	"/pos");
);


// only MIDI section
MIDIClient.init;
MIDIIn.connectAll;

(
MIDIdef.noteOn(\orgOn, {
	arg vel, nn;
	[vel, nn].postln;
	~organo.set(\t_gate, 1, \freq, nn.midicps);
}
);
);
//~organo.set(\t_gate, 1);
