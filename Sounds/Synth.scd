s.boot();
// Sounds

// Additive synthesis with random frequencies (environmental -horror effect)
(
SynthDef.new(\yaw, {
	// control vol, fund, duration, pan, speed
	arg outBus = 0, effectBus, vol = 0.1, fund = 800, duration = 2, pan = 0, speed = 0.5;
	// evaluate the function nOsc times
    var nOsc = 6, out;
	out = Mix.fill(
        nOsc,
        {
			SinOsc.ar([fund, 67.rrand(1000)], 0, nOsc.reciprocal * 0.1);
        }
    )*EnvGen.kr(Env.perc(duration / 2, duration), LFSaw.kr(speed));

	// Output
	Out.ar(outBus, Pan2.ar(vol * out, pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(vol * out, pan));
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
	arg freq = 2, note = 1, outBus = 0, effectBus, pan = 0.5, vol= 0.1, duration = 0.5, vol1 = 0.5, vol2 = 0.3, vol3 = 0.2, speed = 0.4, direction = 0.5;
	var osc1, osc2, osc3, env, out;
	// note conversion to frequency
	freq = freq*pow(pow(2, 1/12), note);

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
)

// test sound
s = Synth(\tone, [\effectBus, 1, \pan, 0.5, \vol, 0.1, \speed, 2]);
// s.set(\speed, 1);
// s.set(\duration, 0.3);
// s.set(\vol1, 3, \vol2, 2, \vol3, 1.6);
//s.set(\note, 17);
//s.set(\freq, 60);
// s.free();


(
SynthDef.new(\water,{
	// we want to control vol, fund, speed, pan, direction
	arg outBus = 0, effectBus, direction = 0.5, fund = 800, speed = 80, pan = 0, vol = 0.1;
	var trigs, freq, osc1, osc2, osc3, out;

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
	osc3 = SinOsc.ar(freq*1.5, 0, mul:vol/3);
	out = osc1 + osc2 + PinkNoise.ar(mul:0.03);

	// Output
	Out.ar(outBus, Pan2.ar(out*direction, pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(out*(1-direction), pan));
}
).send(s);
)

(
SynthDef.new(\organo, {
	// vol, freq, pan, direction
	arg outBus = 0, effectBus, direction = 0.5, pan= 0, freq= 400, vol= 0.1;
	var amps= [1, 0.5, 0.25, 0.125, 0.06, 0.03];
	var dets= [0, 1, 0, 1.7, 0, 0];    // Detune
	// Mix.fill(n,function) n= size of array to create, function: array filling function
	var src= Mix.fill(6, {
		arg i;
		var env = EnvGen.ar(Env.asr);
		LFTri.ar(freq*i/4 + dets[i], 0, vol*env*amps[i]);
	});

	// Output
	Out.ar(outBus, Pan2.ar(src*direction, pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(src*(1-direction), pan));

}).send(s);
)

(
SynthDef.new(\blipblop, {
	arg outBus = 0, effectBus, direction = 0.5, period = 0.05, mille = 2000, pan = 0;
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

	Out.ar(outBus, Pan2.ar(sig*direction, pos:pan));
	// Effect
	Out.ar(outBus, Pan2.ar(sig*(1-direction), pos:pan));
}
).send(s);
)


//

// Effects

(
SynthDef(\reverb,{
	// control: delay, decay
	arg outBus = 0, flangerBus, inBus, dir = 0.5, delay = 0.04, decay = 3;
	var input;

	input = In.ar(inBus, 1);
	16.do({input = AllpassC.ar(in:input, maxdelaytime:delay, delaytime:{Rand(0.001,0.04)}.dup, decaytime:decay)});

	// Reverb
	Out.ar(outBus, input*dir);
	// to Flanger
	Out.ar(flangerBus, input*(1-dir));

}).send(s);
)

(
SynthDef(\flanger, {
	arg flangefreq=0.1, fdback=0.1, inBus;
	var input, effect;

	input=In.ar(inBus,2); //get two channels of input starting (and ending)
	input= input+ LocalIn.ar(2); //add some feedback
	effect= DelayN.ar(input,0.02,SinOsc.kr(flangefreq,0,0.005,0.005)); //max delay of 20msec
	LocalOut.ar(fdback*effect);
	Out.ar(0, effect); //adds to bus 0 where original signal is already playing

}).send(s);
)


// Connecting


(
NetAddr("127.0.0.1",57120);

// Bus that connects all the sounds to Reverb effect
~myBus = Bus.audio(s,1);

// direction direzione dai Synth sounds all'output senza effetti
// dir direzione al reverb
// 1-dir direzione dal reverb al flanger

//Effects
~myReverb = Synth.new(\reverb, [\inBus, ~myBus, \dir, 1]);
//~myFlanger = Synth.new(\flanger, [\inBus, ~myBus]); stand-by

//Yaw
~yaw = Synth.before(~myReverb, \yaw, [\effectBus, ~myBus, \direction, 1]);

//Water
~water = Synth.before(~myReverb, \water, [\effectBus, ~myBus, \direction, 1]);

//Tone
~tone = Synth.before(~myReverb, \tone, [\effectBus, ~myBus, \direction, 1]);

//Organo
~organo = Synth.before(~myReverb, \organo, [\effectBus, ~myBus, \direction, 1]);

//BlipBlop
~blipblop = Synth.before(~myReverb, \blipblop, [\effectBus, ~myBus, \direction, 1]);


OSCdef('OSCreciver',
	{
		arg msg;
		// msg 1-2 Reverb
		rdelay = msg[1];
		rdecay = msg[2];
		~myReverb.set(\delay, rdelay, \decay, rdecay);

		// msg 3-7 (5) Yaw
		yvol = msg[3];
		yfund = msg[4];
		yspeed = msg[5];
		ypan = msg[6];
		ydir = msg[7];
		~yaw.set(\vol, yvol, \fund, yfund, \speed, yspeed, \pan, ypan, \direction, ydir);

		// msg 8-12 (5) Tone
		tvol = msg[8];
		tfreq = msg[9];
		tspeed = msg[10];
		tpan = msg[11];
		tdir = msg[12];
		~tone.set(\vol, tvol, \freq, tfreq, \speed, tspeed, \pan, tpan, \direction, tdir);

		// msg 13-17 (5) Water
		wvol = msg[13];
		wfund = msg[14];
		wspeed = msg[15];
		wpan = msg[16];
		wdir = msg[17];
		~water.set(\vol, wvol, \fund, wfund, \speed, wspeed, \pan, wpan, \direction, wdir);

		// msg 18-21 (4) Organo
		ovol = msg[18];
		ofreq = msg[19];
		opan = msg[20];
		odir = msg[21];
		~organo.set(\vol, ovol, \freq, ofreq, \pan, opan, \direction, odir);

		// msg 22-24 (3) BlipBlop
		bperiod = msg[22];
		bmille = msg[23];
		bdir = msg[24];
		~blipblop.set(\period, bperiod, \mille, bmille, \direction, bdir);

	},
	"/pos");
)



)



























z
